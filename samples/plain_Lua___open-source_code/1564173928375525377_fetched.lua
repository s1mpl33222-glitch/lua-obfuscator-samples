--!nocheck
--!nolint

local __ANTIBRAIN_MODULES = {cache = {}}

do
    do
        local function __modImpl()
            local Failure = {}

            Failure.traceback = function(problem)
                local ok, text = pcall(tostring, problem)

                return debug.traceback((ok and {text} or {
                    'An unprintable error was raised',
                })[1], 2)
            end
            Failure.capture = function(callback, ...)
                local ok, message = xpcall(callback, Failure.traceback, ...)

                return (ok and {nil} or {message})[1]
            end

            function Failure.summary(failure)
                return failure:split('\n')[1]
            end

            return table.freeze(Failure)
        end

        function __ANTIBRAIN_MODULES.a()
            local v = __ANTIBRAIN_MODULES.cache.a

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            return table.freeze({})
        end

        function __ANTIBRAIN_MODULES.b()
            local v = __ANTIBRAIN_MODULES.cache.b

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.b = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local REPORTS_PER_CONNECTION = 5
            local HIDDEN_NOTICE = 'Further errors from this connection are not reported.'
            local REPORTS_PER_SCOPE = 10
            local Class = {}

            Class.__index = Class

            local Scope = {}

            function Scope.new(report, label)
                local fields = {
                    closed = false,
                    label = label,
                    _report = report,
                    _tail = nil,
                    _reported = {},
                    _reports = 0,
                }

                return setmetatable(fields, Class)
            end

            local function fail(scope, failure)
                if not failure then
                    return
                end

                local text = (scope.label and {
                    string.format('[%s] %s', tostring(scope.label), tostring(failure)),
                } or {failure})[1]
                local report = scope._report

                if report then
                    pcall(report, text)
                else
                    warn(text)
                end
            end
            local function unlink(scope, entry)
                if not entry.attached then
                    return
                end

                entry.attached = false

                if entry.previous then
                    entry.previous.next = entry.next
                end
                if entry.next then
                    entry.next.previous = entry.previous
                else
                    scope._tail = entry.previous
                end

                entry.previous = nil
                entry.next = nil
            end
            local function dispose(scope, cleanup)
                fail(scope, Failure.capture(cleanup))
            end

            function Class.add(self, cleanup)
                if self.closed then
                    dispose(self, cleanup)

                    return function() end
                end

                local tail = self._tail
                local entry = {
                    cleanup = cleanup,
                    previous = tail,
                    next = nil,
                    attached = true,
                }

                if tail then
                    tail.next = entry
                end

                self._tail = entry

                return function()
                    unlink(self, entry)
                end
            end

            local function release(object)
                local kind = typeof(object)

                if kind == 'Instance' then
                    object:Destroy()
                elseif kind == 'RBXScriptConnection' then
                    object:Disconnect()
                elseif kind == 'table' and type(object.Destroy) == 'function' then
                    object:Destroy()
                else
                    object:Remove()
                end
            end

            function Scope.own(scope, object)
                scope:add(function()
                    release(object)
                end)

                return object
            end
            function Class.child(self, label)
                local child = Scope.new(self._report, label or self.label)
                local detach = self:add(function()
                    child:close()
                end)

                child:add(detach)

                return child
            end
            function Class.detached(self, label)
                return Scope.new(self._report, label or self.label)
            end
            function Class.report(self, failure)
                local line = failure:match('^[^\n]*') or failure

                if self._reported[line] or self._reports >= REPORTS_PER_SCOPE then
                    return
                end

                self._reported[line] = true
                self._reports = self._reports + 1

                fail(self, failure)
            end
            function Class.connect(self, signal, callback)
                local reported = {}
                local remaining = REPORTS_PER_CONNECTION
                local connection = signal:Connect(function(...)
                    if self.closed then
                        return
                    end

                    local failure = Failure.capture(callback, ...)

                    if not failure or remaining == 0 then
                        return
                    end

                    local line = Failure.summary(failure)

                    if reported[line] then
                        return
                    end

                    reported[line] = true
                    remaining = remaining - 1

                    fail(self, (remaining == 0 and {
                        string.format('%s\n%s', tostring(failure), tostring(HIDDEN_NOTICE)),
                    } or {failure})[1])
                end)

                self:add(function()
                    connection:Disconnect()
                end)

                return connection
            end

            local function launch(self, callback, args, schedule)
                local detach = function() end
                local worker = coroutine.create(function()
                    if self.closed then
                        detach()

                        return
                    end

                    local failure = Failure.capture(callback, table.unpack(args, 1, args.n))

                    detach()
                    fail(self, failure)
                end)

                if self.closed then
                    return worker
                end

                detach = self:add(function()
                    if coroutine.status(worker) == 'suspended' then
                        task.cancel(worker)
                    end
                end)

                local failure = Failure.capture(schedule, worker)

                if failure then
                    detach()
                    error(failure, 0)
                end

                return worker
            end

            function Class.spawn(self, callback, ...)
                return launch(self, callback, table.pack(...), function(worker)
                    task.spawn(worker)
                end)
            end
            function Class.defer(self, callback, ...)
                return launch(self, callback, table.pack(...), function(worker)
                    task.defer(worker)
                end)
            end
            function Class.delay(self, seconds, callback, ...)
                assert(seconds >= 0 and seconds < math.huge, 'Delay must be finite and nonnegative')

                return launch(self, callback, table.pack(...), function(worker)
                    task.delay(seconds, worker)
                end)
            end
            function Class.close(self)
                if self.closed then
                    return
                end

                self.closed = true

                local entry = self._tail

                while entry do
                    unlink(self, entry)
                    dispose(self, entry.cleanup)

                    entry = self._tail
                end
            end

            return table.freeze(Scope)
        end

        function __ANTIBRAIN_MODULES.c()
            local v = __ANTIBRAIN_MODULES.cache.c

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.c = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()
            __ANTIBRAIN_MODULES.c()

            return table.freeze({})
        end

        function __ANTIBRAIN_MODULES.d()
            local v = __ANTIBRAIN_MODULES.cache.d

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.d = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Scope = __ANTIBRAIN_MODULES.c()
            local Class = {}

            Class.__index = Class

            function Class.start(self, initialize)
                if self._initialized or self.state ~= 'starting' then
                    return 'Session already started or stopped'
                end

                self._initialized = true

                local failure = Failure.capture(initialize, self.scope)

                if failure then
                    self:stop()

                    return failure
                end
                if self.state ~= 'starting' or self.scope.closed then
                    self:stop()

                    return 'Session superseded'
                end

                self.state = 'running'

                return nil
            end
            function Class.stop(self)
                if self.state == 'stopping' or self.state == 'stopped' then
                    return
                end

                self.state = 'stopping'

                self.scope:close()

                self.state = 'stopped'
            end

            local Session = {}

            function Session.new(report)
                local fields = {
                    state = 'starting',
                    scope = Scope.new(report),
                    _initialized = false,
                }

                return setmetatable(fields, Class)
            end

            return table.freeze(Session)
        end

        function __ANTIBRAIN_MODULES.e()
            local v = __ANTIBRAIN_MODULES.cache.e

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.e = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.e()

            return table.freeze({})
        end

        function __ANTIBRAIN_MODULES.f()
            local v = __ANTIBRAIN_MODULES.cache.f

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.f = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()
            __ANTIBRAIN_MODULES.d()
            __ANTIBRAIN_MODULES.f()
            __ANTIBRAIN_MODULES.c()

            return table.freeze({})
        end

        function __ANTIBRAIN_MODULES.g()
            local v = __ANTIBRAIN_MODULES.cache.g

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.g = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.g()

            local function register(routes, ids, definition, kind)
                for _, id in ids do
                    assert(id >= 1 and id % 1 == 0, string.format('Game "%s": %s id %s is not a positive integer', tostring(definition.id), tostring(kind), tostring(id)))

                    local owner = routes[id]

                    assert(owner == nil, string.format('Game "%s": %s id %s is already registered by "%s"', tostring(definition.id), tostring(kind), tostring(id), tostring(owner and owner.id)))

                    routes[id] = definition
                end
            end

            local Registry = {}

            function Registry.select(catalog, placeId, universeId)
                local seen = {}
                local places, universes = {}, {}

                for _, definition in catalog do
                    local id = definition.id

                    assert(id:match('^[a-z][a-z0-9_-]*$'), string.format(
[[Game "%s": the id must use lowercase letters, digits, - or _]], tostring(id)))
                    assert(not seen[id], string.format('Game "%s": the id is registered twice', tostring(id)))
                    assert(definition.name:match('%S'), string.format('Game "%s": the name is blank', tostring(id)))

                    seen[id] = true

                    register(universes, definition.universeIds, definition, 'universe')
                    register(places, definition.placeIds or {}, definition, 'place')
                end

                return places[placeId] or universes[universeId]
            end

            return table.freeze(Registry)
        end

        function __ANTIBRAIN_MODULES.h()
            local v = __ANTIBRAIN_MODULES.cache.h

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.h = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.g()
            __ANTIBRAIN_MODULES.d()
            __ANTIBRAIN_MODULES.f()

            local Registry = __ANTIBRAIN_MODULES.h()

            __ANTIBRAIN_MODULES.c()

            local Session = __ANTIBRAIN_MODULES.e()

            local function replacePrevious(slot)
                local previous = slot.current

                if not previous then
                    return nil
                end
                if previous.state == 'stopping' then
                    return 'Previous session is still stopping'
                end

                local failure = Failure.capture(previous.stop, previous)

                if failure then
                    return string.format('Previous session failed to stop: %s', tostring(failure))
                end
                if previous.state ~= 'stopped' then
                    return 'Previous session did not stop'
                end
                if slot.current and slot.current ~= previous then
                    return 'A newer session has started'
                end

                return nil
            end
            local function missingApis(definition, platform)
                local missing = {}
                local requires = definition.requires or {}

                for _, name in requires do
                    if not platform.supports(name) then
                        table.insert(missing, name)
                    end
                end

                return missing
            end

            local ALERT_SECONDS = 30
            local ALERT_LENGTH = 120

            local function reporter(platform, alerts)
                return function(failure)
                    platform.log(failure)

                    local notify = alerts.notify
                    local now = os.clock()

                    if notify and now - alerts.last >= ALERT_SECONDS then
                        alerts.last = now

                        local summary = Failure.summary(failure):sub(1, ALERT_LENGTH)

                        Failure.capture(notify, string.format('Something hit an error: %s The console has the details.', tostring(summary)))
                    end
                end
            end
            local function open(deps, session, owner, module, problem, alerts)
                local mounted = deps.mount({
                    scope = owner:child(),
                    persistence = deps.platform.persistence,
                    module = module,
                    problem = problem,
                    stop = function()
                        if not owner.closed then
                            session:stop()
                        end
                    end,
                    log = deps.platform.log,
                    report = reporter(deps.platform, alerts),
                })

                alerts.notify = mounted.game.notify

                return mounted
            end
            local function finish(deps, ui)
                local failure = Failure.capture(ui.ready)

                if failure then
                    deps.platform.log(string.format('Settings could not finish loading: %s', tostring(failure)))
                end
            end
            local function prepare(deps, module)
                local failure = Failure.capture(function()
                    local reason = deps.platform.prepare(module)

                    if reason then
                        deps.platform.log(string.format("The hub's folders are not all there: %s", tostring(reason)))
                    end
                end)

                if failure then
                    deps.platform.log(string.format("The hub's folders could not be made: %s", tostring(failure)))
                end
            end
            local function startModule(
                deps,
                session,
                scope,
                definition,
                shown,
                alerts
            )
                local platform = deps.platform
                local missing = missingApis(definition, platform)

                if #missing > 0 then
                    local list = table.concat(missing, ', ')

                    platform.log(string.format('%s needs %s, which %s does not provide', tostring(definition.name), tostring(list), tostring(platform.executor)))

                    return {
                        name = definition.name,
                        reason = string.format('%s does not provide %s.', tostring(platform.executor), tostring(list)),
                    }
                end

                prepare(deps, definition.id)

                if scope.closed then
                    return nil
                end

                local attempt = scope:child()
                local ui = open(deps, session, attempt, {
                    id = definition.id,
                    name = definition.name,
                }, shown, alerts)

                if scope.closed then
                    return nil
                end

                local failure = Failure.capture(definition.start, {
                    game = platform.game,
                    scope = attempt:child(),
                    ui = ui.game,
                    log = function(message)
                        platform.log(string.format('%s: %s', tostring(definition.name), tostring(message)))
                    end,
                    wait = platform.wait,
                    services = {},
                })

                if scope.closed then
                    return nil
                end
                if not failure then
                    finish(deps, ui)

                    return nil
                end

                platform.log(string.format('%s failed to start: %s', tostring(definition.name), tostring(failure)))
                attempt:close()

                return {
                    name = definition.name,
                    reason = string.format('It failed to start: %s. The full error is in the console.', tostring(Failure.summary(failure))),
                }
            end

            local App = {}

            function App.launch(deps)
                local platform = deps.platform
                local slot = platform.slot
                local conflict = replacePrevious(slot)

                if conflict then
                    return nil, conflict
                end

                local alerts = {
                    notify = nil,
                    last = -math.huge,
                }
                local session = Session.new(reporter(platform, alerts))

                slot.current = session

                session.scope:add(function()
                    if slot.current == session then
                        slot.current = nil
                    end
                end)

                local failure = session:start(function(scope)
                    if platform.initialize then
                        platform.initialize(scope)
                    end
                    if scope.closed then
                        return
                    end

                    prepare(deps, nil)

                    if scope.closed then
                        return
                    end

                    local definition = Registry.select(deps.catalog, platform.game.placeId, platform.game.universeId)
                    local problem = (definition and {
                        (startModule(deps, session, scope, definition, nil, alerts)),
                    } or {nil})[1]

                    if (definition and not problem) or scope.closed then
                        return
                    end

                    local universal = deps.universal

                    if universal then
                        local universalProblem = startModule(deps, session, scope, universal, problem, alerts)

                        if not universalProblem or scope.closed then
                            return
                        end

                        problem = problem or universalProblem
                    end

                    local ui = open(deps, session, scope, nil, problem, alerts)

                    if not scope.closed then
                        finish(deps, ui)
                    end
                end)

                if failure then
                    return nil, failure
                end

                return session, nil
            end

            return table.freeze(App)
        end

        function __ANTIBRAIN_MODULES.i()
            local v = __ANTIBRAIN_MODULES.cache.i

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.i = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local GameCode = {}
            local requireFound = require

            function GameCode.find(label, root, names)
                local current = root

                for _, name in names do
                    local found = current:FindFirstChild(name)

                    assert(found, string.format('%s %s is unavailable: %s is missing', tostring(label), tostring(table.concat(names, '.')), tostring(name)))

                    current = found
                end

                return current
            end
            function GameCode.load(label, root, names)
                local module = GameCode.find(label, root, names)

                assert(module:IsA('ModuleScript'), string.format('%s %s is not a module', tostring(label), tostring(table.concat(names, '.'))))

                return requireFound(module)
            end

            return table.freeze(GameCode)
        end

        function __ANTIBRAIN_MODULES.j()
            local v = __ANTIBRAIN_MODULES.cache.j

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.j = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local function protect(service)
                if type(cloneref) ~= 'function' then
                    return service
                end

                local ok, clone = pcall(cloneref, service)

                return (ok and typeof(clone) == 'Instance' and {clone} or {service})[1]
            end

            local cache = {}
            local resolve = function(_, name)
                local service = cache[name]

                if not service then
                    service = protect(game:GetService(name))
                    cache[name] = service
                end

                return service
            end
            local Services = setmetatable({}, {__index = resolve})

            return ((table.freeze(Services)))
        end

        function __ANTIBRAIN_MODULES.k()
            local v = __ANTIBRAIN_MODULES.cache.k

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.k = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local GameCode = __ANTIBRAIN_MODULES.j()
            local Services = __ANTIBRAIN_MODULES.k()

            local function find(root, names)
                return GameCode.find('RIVALS', root, names)
            end
            local function load(root, names)
                return GameCode.load('RIVALS', root, names)
            end
            local function player()
                return assert(Services.Players.LocalPlayer, 'RIVALS LocalPlayer is unavailable')
            end

            local scripts = nil

            local function playerScripts()
                local held = scripts

                if held then
                    return held
                end

                local found = find(player(), {
                    'PlayerScripts',
                })

                scripts = found

                return found
            end
            local function client(names)
                local path = table.clone(names)

                table.insert(path, 1, 'Modules')

                return load(playerScripts(), path)
            end

            local Modules = {}

            Modules.player = player

            function Modules.controller(name)
                return load(playerScripts(), {
                    'Controllers',
                    name,
                })
            end

            Modules.client = client

            local function under(folder, names)
                local path = table.clone(names)

                table.insert(path, 1, folder)

                return find(playerScripts(), path)
            end

            function Modules.interface(names)
                return under('UserInterface', names)
            end
            function Modules.asset(names)
                return under('Assets', names)
            end
            function Modules.shared(name)
                return load(Services.ReplicatedStorage, {
                    'Modules',
                    name,
                })
            end
            function Modules.remote(names)
                local path = table.clone(names)

                table.insert(path, 1, 'Remotes')

                return find(Services.ReplicatedStorage, path)
            end
            function Modules.viewModels()
                return Modules.asset({
                    'ViewModels',
                })
            end

            return table.freeze(Modules)
        end

        function __ANTIBRAIN_MODULES.l()
            local v = __ANTIBRAIN_MODULES.cache.l

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.l = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.g()
            __ANTIBRAIN_MODULES.c()

            local Service = {}

            function Service.new(name, make)
                return table.freeze({
                    name = name,
                    make = make,
                })
            end
            function Service.use(run, services, service, ...)
                assert(not run.closed, string.format('Cannot use %s from a closed scope', tostring(service.name)))

                local entry = services[service]

                assert(not entry or not entry.initializing, string.format('%s is still being made', tostring(service.name)))

                if not entry then
                    local scope = run:detached(service.name)
                    local pending = {
                        value = nil,
                        scope = scope,
                        users = 0,
                        initializing = true,
                    }

                    services[service] = pending

                    local function discard()
                        if services[service] == pending then
                            services[service] = nil
                        end

                        scope:close()
                    end

                    local detach = run:add(discard)
                    local ok, made = xpcall(service.make, Failure.traceback, scope, services, 
...)

                    detach()

                    if not ok then
                        discard()
                        error(made, 0)
                    end
                    if run.closed or scope.closed then
                        discard()
                        error(string.format('%s was closed while it was being made', tostring(service.name)), 0)
                    end

                    pending.value, pending.initializing = made, false
                    entry = pending
                end

                local used = entry

                used.users = used.users + 1

                run:add(function()
                    used.users = used.users - 1

                    if used.users == 0 and services[service] == used then
                        services[service] = nil

                        used.scope:close()
                    end
                end)

                return used.value
            end
            function Service.value(name)
                return table.freeze({
                    name = name,
                    _value = nil,
                })
            end

            Service.get = function(services, value)
                return services[value]
            end

            function Service.set(services, value, current)
                services[value] = current
            end

            return table.freeze(Service)
        end

        function __ANTIBRAIN_MODULES.m()
            local v = __ANTIBRAIN_MODULES.cache.m

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.m = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Service = __ANTIBRAIN_MODULES.m()
            local REPORT = Service.value('ragebot report')
            local RageReport = {}

            RageReport.get = function(services)
                return Service.get(services, REPORT)
            end

            function RageReport.set(services, report)
                Service.set(services, REPORT, report)
            end

            return table.freeze(RageReport)
        end

        function __ANTIBRAIN_MODULES.n()
            local v = __ANTIBRAIN_MODULES.cache.n

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.n = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Fighter = {}

            Fighter.alive = function(fighter, player)
                if type(fighter) ~= 'table' or type(fighter.Items) ~= 'table' or #fighter.Items == 0 then
                    return false
                end

                local character = player.Character
                local humanoid = (character and {
                    (character:FindFirstChildOfClass('Humanoid')),
                } or {nil})[1]

                return humanoid ~= nil and humanoid.Health > 0
            end
            Fighter.invincible = function(fighter)
                local entity = fighter.Entity

                return type(entity) ~= 'table' or (entity._invincibility_visual and true or false)
            end
            Fighter.deflecting = function(fighter)
                local item = fighter.EquippedItem

                return type(item) == 'table' and item._deflect_hash and type(item._attack_cooldown) == 'number' and tick() < item._attack_cooldown
            end

            return table.freeze(Fighter)
        end

        function __ANTIBRAIN_MODULES.o()
            local v = __ANTIBRAIN_MODULES.cache.o

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.o = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Reaction = {}

            function Reaction.new()
                return {
                    targeted = false,
                    forgetAt = -math.huge,
                    readyAt = -math.huge,
                }
            end

            Reaction.step = function(
                reaction,
                found,
                now,
                reactionSeconds,
                forgetSeconds,
                suppressed
            )
                if found and reaction.readyAt == -math.huge then
                    reaction.readyAt = now + reactionSeconds
                end
                if not found then
                    if reaction.targeted then
                        reaction.forgetAt = now + forgetSeconds
                    end
                    if reaction.forgetAt < now then
                        reaction.readyAt = now + reactionSeconds
                    end
                end

                local ready = reaction.readyAt <= now and not suppressed

                reaction.targeted = found and ready

                return ready
            end

            return table.freeze(Reaction)
        end

        function __ANTIBRAIN_MODULES.p()
            local v = __ANTIBRAIN_MODULES.cache.p

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.p = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Services = __ANTIBRAIN_MODULES.k()
            local REACH = 9.5
            local FLOOR_DEPTH = 5
            local offsets = nil

            local function around()
                local cached = offsets

                if cached then
                    return cached
                end

                local list = {}

                for x = -1, 1 do
                    for y = -1, 1 do
                        for z = -1, 1 do
                            if x ~= 0 or y ~= 0 or z ~= 0 then
                                table.insert(list, Vector3.new(x, y, z).Unit * REACH)
                            end
                        end
                    end
                end

                offsets = list

                return list
            end

            local Sight = {}

            function Sight.new()
                return {
                    params = RaycastParams.new(),
                }
            end

            Sight.ignore = function(sight, instances)
                sight.params.FilterDescendantsInstances = instances
            end
            Sight.clear = function(sight, from, to)
                local hit = Services.Workspace:Raycast(from, to - from, sight.params)

                return hit == nil, hit
            end

            local fromAround = function(sight, origin, target)
                for _, offset in around()do
                    local from = origin + offset

                    if Sight.clear(sight, from, target) then
                        return true, {origin = from}
                    end
                end

                return false, nil
            end

            Sight.manipulate = function(
                sight,
                origin,
                target,
                character,
                melee
            )
                if melee then
                    return false, nil
                end
                if Sight.clear(sight, origin, target) then
                    return true, nil
                end

                local _, floor = Sight.clear(sight, origin, origin + Vector3.new(0, 
-FLOOR_DEPTH, 0))
                local ground = (floor and {
                    floor.Instance,
                } or {nil})[1]

                if not floor or not ground or not ground:IsA('BasePart') then
                    return fromAround(sight, origin, target)
                end

                local depth = floor.Distance + math.min(ground.Size.Y * 0.99, REACH - floor.Distance)
                local below = origin + Vector3.new(0, -depth, 0)

                if Sight.clear(sight, below, target) then
                    return true, {origin = below}
                end

                local body = character:FindFirstChild('HitboxBody')

                if not body or not body:IsA('BasePart') then
                    return fromAround(sight, origin, target)
                end

                local drop = Vector3.new(0, -body.Size.Y / 2.01, 0)

                if not Sight.clear(sight, below, body.Position + drop) then
                    return fromAround(sight, origin, target)
                end

                return true, {
                    origin = below,
                    part = body,
                    hitOffset = drop,
                }
            end

            return table.freeze(Sight)
        end

        function __ANTIBRAIN_MODULES.q()
            local v = __ANTIBRAIN_MODULES.cache.q

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.q = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Fighter = __ANTIBRAIN_MODULES.o()
            local Reaction = __ANTIBRAIN_MODULES.p()
            local Services = __ANTIBRAIN_MODULES.k()
            local Sight = __ANTIBRAIN_MODULES.q()
            local EYE, CROUCHED_EYE = 1.75, 0.25
            local NOT_BODY = table.freeze({
                HitboxBody = true,
                HitboxHead = true,
                PhysicalHitboxHead = true,
                HitboxBodySmall = true,
                HitboxHeadSmall = true,
                FakeMass = true,
            })
            local NOTHING = table.freeze({manipulated = false})
            local Targeting = {}
            local hasItem = function(fighter, name)
                for _, item in fighter.Items do
                    if item.Name == name then
                        return true
                    end
                end

                return false
            end
            local protected = function(fighter, ignoreIf, origin, position)
                if Fighter.invincible(fighter) then
                    return true
                end
                if ignoreIf['katana deflecting'] and Fighter.deflecting(fighter) then
                    return true
                end

                local item = fighter.EquippedItem

                if ignoreIf['blocked by riot shield'] then
                    local holding = type(item) == 'table' and item.Name == 'Riot Shield'

                    if holding or hasItem(fighter, 'Riot Shield') then
                        local turn = ((position - origin).Unit - fighter:GetRotationCFrame().LookVector).Magnitude

                        return (holding and {
                            (turn > 1.66),
                        } or {
                            (turn < 0.77),
                        })[1]
                    end
                end

                return false
            end
            local closestPart = function(character, camera, center, blacklist)
                local best, bestScreen, bestDistance = nil, nil, math.huge

                for _, child in character:GetChildren()do
                    if child:IsA('MeshPart') and not NOT_BODY[child.Name] and not blacklist[child.Name] then
                        local projected = camera:WorldToViewportPoint(child.Position)
                        local screen = Vector2.new(projected.X, projected.Y)
                        local distance = (screen - center).Magnitude

                        if distance < bestDistance then
                            best, bestScreen, bestDistance = child, screen, distance
                        end
                    end
                end

                return best, bestScreen
            end
            local eyes = function(player, fighter, camera)
                local character = player.Character
                local root = (character and {
                    (character:FindFirstChild('HumanoidRootPart')),
                } or {nil})[1]

                if root and root:IsA('BasePart') then
                    return root.Position + Vector3.new(0, (fighter:IsCrouching() and {CROUCHED_EYE} or {EYE})[1], 0)
                end

                return camera.CFrame.Position
            end
            local ignoreCharacters = function(sight)
                local ignored = {}
                local viewModels = Services.Workspace:FindFirstChild('ViewModels')

                if viewModels then
                    table.insert(ignored, viewModels)
                end

                for _, other in Services.Players:GetPlayers()do
                    if other.Character then
                        table.insert(ignored, other.Character)
                    end
                end

                Sight.ignore(sight, ignored)
            end
            local consider = function(
                targeting,
                settings,
                search,
                opponent,
                dueler
            )
                local model = opponent.Character
                local humanoid = (model and {
                    (model:FindFirstChildOfClass('Humanoid')),
                } or {nil})[1]
                local part = (model and {
                    (model:FindFirstChild(search.partName)),
                } or {nil})[1]

                if opponent == targeting.player or type(dueler) ~= 'table' or dueler._is_ally or not model or not humanoid or not (humanoid.Health > 0) or not part or not part:IsA('BasePart') then
                    return nil
                end

                local position = part.Position
                local screen, onScreen = search.camera:WorldToViewportPoint(position)
                local point = Vector2.new(screen.X, screen.Y)
                local away = (point - search.center).Magnitude
                local enemy = dueler.ClientFighter
                local wanted = (not settings.limitDistance or (search.origin - position).Magnitude <= settings.maxDistance) and onScreen and away <= search.radius and type(enemy) == 'table' and not (settings.ignoreProtected and protected(enemy, settings.ignoreIf, search.origin, position))

                if not wanted then
                    return nil
                end

                local hit = part
                local manipulation = nil

                if search.manipulate then
                    local allowed

                    allowed, manipulation = Sight.manipulate(targeting.sight, search.origin, position, model, search.melee)

                    if not allowed then
                        return nil
                    end
                    if manipulation and manipulation.part then
                        hit = manipulation.part
                    end
                elseif settings.visibleOnly and not Sight.clear(targeting.sight, search.origin, position) then
                    return nil
                end

                return {
                    character = model,
                    part = hit,
                    screen = point,
                    humanoid = humanoid,
                    fighter = enemy,
                    manipulation = manipulation,
                    distance = away,
                }
            end
            local selectionOf = function(pick, settings, search)
                local closest, focus = nil, pick.screen

                if (settings.closestPart or settings.aimClosestPart) and not pick.manipulation then
                    closest, focus = closestPart(pick.character, search.camera, search.center, settings.closestBlacklist)
                end

                local silentPart = (settings.closestPart and closest and {closest} or {
                    pick.part,
                })[1]
                local aimPart = (settings.aimClosestPart and closest and {closest} or {
                    pick.part,
                })[1]

                return {
                    silent = pick.distance < search.silentRadius and {
                        part = silentPart,
                        manipulation = pick.manipulation,
                    } or nil,
                    aimbot = pick.distance < search.aimRadius and {
                        part = aimPart,
                        character = pick.character,
                        humanoid = pick.humanoid,
                        fighter = pick.fighter,
                    } or nil,
                    manipulated = search.manipulate,
                    focus = focus,
                }
            end

            function Targeting.new(player, fighters, spectate)
                return {
                    player = player,
                    fighters = fighters,
                    spectate = spectate,
                    sight = Sight.new(),
                    reaction = Reaction.new(),
                    warned = false,
                }
            end

            Targeting.select = function(
                targeting,
                settings,
                camera,
                silentOn,
                aimOn
            )
                local fighter = targeting.fighters.LocalFighter
                local duel = targeting.spectate.CurrentDuelSubject
                local duelers = (type(duel) == 'table' and {
                    duel._duelers_by_player,
                } or {nil})[1]

                if type(fighter) ~= 'table' or type(duelers) ~= 'table' then
                    Reaction.step(targeting.reaction, false, os.clock(), 0, 0, false)

                    return NOTHING
                end

                ignoreCharacters(targeting.sight)

                local item = fighter.EquippedItem
                local manipulate = silentOn and settings.active and settings.manipulation
                local silentRadius = (silentOn and {
                    settings.radius,
                } or {0})[1]
                local aimRadius = (aimOn and {
                    settings.aimRadius,
                } or {0})[1]
                local search = {
                    camera = camera,
                    origin = eyes(targeting.player, fighter, camera),
                    center = camera.ViewportSize / 2,
                    silentRadius = silentRadius,
                    aimRadius = aimRadius,
                    radius = math.max(silentRadius, aimRadius),
                    partName = manipulate and 'HitboxHead' or settings.part,
                    manipulate = manipulate,
                    melee = type(item) == 'table' and type(item.Info) == 'table' and item.Info.Type == 'Melee',
                }
                local picked = nil

                for opponent, dueler in duelers do
                    local checked, pick = pcall(consider, targeting, settings, search, opponent, dueler)

                    if checked then
                        picked = pick or picked
                    elseif not targeting.warned then
                        targeting.warned = true

                        warn(string.format(
[[An opponent could not be checked for aiming; later ones are not reported: %s]], tostring(pick)))
                    end
                end

                local flashed = settings.disableOnFlash and Services.Lighting:FindFirstChild('Flashbang') ~= nil
                local ready = Reaction.step(targeting.reaction, picked ~= nil, os.clock(), settings.reactionTime / 1000, settings.forgetTime, flashed)

                if not ready or not picked then
                    return NOTHING
                end

                return selectionOf(picked, settings, search)
            end

            return table.freeze(Targeting)
        end

        function __ANTIBRAIN_MODULES.r()
            local v = __ANTIBRAIN_MODULES.cache.r

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.r = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Modules = __ANTIBRAIN_MODULES.l()
            local RageReport = __ANTIBRAIN_MODULES.n()

            __ANTIBRAIN_MODULES.c()

            local Service = __ANTIBRAIN_MODULES.m()
            local Services = __ANTIBRAIN_MODULES.k()
            local Targeting = __ANTIBRAIN_MODULES.r()
            local LATEST = Service.value('aim selection')
            local PASS = Service.new('aiming', function(
                scope,
                services,
                settings
            )
                local fighters = Modules.controller('FighterController')
                local targeting = Targeting.new(Modules.player(), fighters, Modules.controller('SpectateController'))
                local members = {}

                scope:connect(Services.RunService.Heartbeat, function(
                    deltaTime
                )
                    local camera = Services.Workspace.CurrentCamera

                    if not camera then
                        return
                    end

                    local report = RageReport.get(services)
                    local selection

                    if report then
                        local focus = nil

                        if report.target then
                            local point, visible = camera:WorldToViewportPoint(report.target.Position)

                            focus = (visible and {
                                (Vector2.new(point.X, point.Y)),
                            } or {nil})[1]
                        end

                        selection = {
                            manipulated = false,
                            focus = focus,
                        }
                    else
                        selection = Targeting.select(targeting, settings(), camera, members.silent ~= nil, members.aimbot ~= nil)
                    end

                    Service.set(services, LATEST, selection)

                    local fighter = fighters.LocalFighter

                    for role, member in members do
                        local failure = Failure.capture(member, selection, camera, fighter, deltaTime)

                        if failure then
                            scope:report(string.format('The %s aiming frame failed: %s', tostring(role), tostring(failure)))
                        end
                    end
                end)
                scope:add(function()
                    Service.set(services, LATEST, nil)
                end)

                return {members = members}
            end)
            local Aiming = {}

            Aiming.ragebotActive = function(services)
                return RageReport.get(services) ~= nil
            end
            Aiming.latest = function(services)
                return Service.get(services, LATEST)
            end

            function Aiming.join(run, services, role, settings, frame)
                local pass = Service.use(run, services, PASS, settings)

                pass.members[role] = frame

                run:add(function()
                    if pass.members[role] == frame then
                        pass.members[role] = nil
                    end
                end)
            end

            return table.freeze(Aiming)
        end

        function __ANTIBRAIN_MODULES.s()
            local v = __ANTIBRAIN_MODULES.cache.s

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.s = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local THICKNESS, OUTLINE_THICKNESS = 1, 3

            local function circle(parent, thickness, zIndex, fill, made)
                local function track(instance)
                    table.insert(made, instance)

                    return instance
                end

                local frame = track(Instance.new('Frame'))

                frame.AnchorPoint = Vector2.new(0.5, 0.5)
                frame.BackgroundColor3 = Color3.new(1, 1, 1)
                frame.BackgroundTransparency = 1
                frame.BorderSizePixel = 0
                frame.Visible = false
                frame.ZIndex = zIndex

                local corner = track(Instance.new('UICorner'))

                corner.CornerRadius = UDim.new(1, 0)
                corner.Parent = frame

                local stroke = track(Instance.new('UIStroke'))

                stroke.Color = Color3.new(1, 1, 1)
                stroke.Thickness = thickness
                stroke.Parent = frame

                local gradients = {}

                if fill then
                    local gradient = track(Instance.new('UIGradient'))

                    gradient.Parent = frame

                    table.insert(gradients, gradient)
                end

                local gradient = track(Instance.new('UIGradient'))

                gradient.Parent = stroke

                table.insert(gradients, gradient)

                frame.Parent = parent

                return frame, gradients
            end

            local size = function(frame, radius, thickness)
                local diameter = radius * 2 - thickness * 2

                frame.Size = UDim2.fromOffset(diameter, diameter)
            end
            local sequences = function(colors, transparencies)
                local colorPoints, transparencyPoints = {}, {}

                for index = 1, 3 do
                    local at = (index - 1) / 2

                    table.insert(colorPoints, ColorSequenceKeypoint.new(at, colors[index]))
                    table.insert(transparencyPoints, NumberSequenceKeypoint.new(at, transparencies[index]))
                end

                return ColorSequence.new(colorPoints), NumberSequence.new(transparencyPoints)
            end
            local paint = function(fov, gradient, colors, transparencies)
                local previous = fov.looks[gradient]
                local unchanged = previous ~= nil

                if previous then
                    for index = 1, 3 do
                        if previous.colors[index] ~= colors[index] or previous.transparencies[index] ~= transparencies[index] then
                            unchanged = false

                            break
                        end
                    end
                end
                if unchanged then
                    return
                end

                gradient.Color, gradient.Transparency = sequences(colors, transparencies)
                fov.looks[gradient] = {
                    colors = table.clone(colors),
                    transparencies = table.clone(transparencies),
                }
            end
            local FovCircle = {}

            FovCircle.anchored = function(anchors, places)
                if anchors['position on target'] and places.target then
                    return places.target
                end
                if anchors['position on barrel'] and places.barrel then
                    return places.barrel
                end

                return nil
            end
            FovCircle.barrel = function(fighter, camera)
                local item = fighter.EquippedItem

                if type(item) ~= 'table' or not item.ViewModel or type(item.Info) ~= 'table' or item.Info.Type ~= 'Gun' then
                    return nil
                end

                local viewModel = item.ViewModel
                local body = viewModel._body_model
                local muzzles = viewModel._muzzle_attachments

                if not ((type(muzzles) == 'table' and #muzzles > 0) or (body and body.PrimaryPart)) then
                    return nil
                end

                local projected, screen, onScreen = pcall(function()
                    local point, visible = camera:WorldToViewportPoint(viewModel:GetMuzzlePosition())

                    return Vector2.new(point.X, point.Y), visible
                end)

                return (projected and onScreen and {screen} or {nil})[1]
            end

            function FovCircle.new(parent)
                local made = {}
                local ok, built = pcall(function()
                    local gui = Instance.new('ScreenGui')

                    table.insert(made, gui)

                    gui.DisplayOrder = 15
                    gui.IgnoreGuiInset = true
                    gui.ResetOnSpawn = false
                    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

                    local main, mainGradients = circle(gui, THICKNESS, 5, true, made)
                    local outline, outlineGradients = circle(gui, OUTLINE_THICKNESS, 4, false, made)

                    gui.Parent = parent

                    return {
                        gui = gui,
                        circle = main,
                        outline = outline,
                        gradients = {
                            mainGradients[1],
                            mainGradients[2],
                            outlineGradients[1],
                        },
                        looks = {},
                        at = Vector2.zero,
                        rotation = nil,
                    }
                end)

                if not ok then
                    for index = #made, 1, -1 do
                        pcall(made[index].Destroy, made[index])
                    end

                    error(built, 0)
                end

                return built
            end
            function FovCircle.destroy(fov)
                fov.gui:Destroy()
            end

            FovCircle.draw = function(fov, look, places, now)
                local main, outline = fov.circle, fov.outline

                main.Visible = look.show
                outline.Visible = look.show and look.outline

                size(main, look.radius, THICKNESS)
                size(outline, look.radius + 1, OUTLINE_THICKNESS)

                main.BackgroundTransparency = look.filled and 0 or 1

                local fill, line, outer = fov.gradients[1], fov.gradients[2], fov.gradients[3]

                paint(fov, line, look.colors, look.transparencies)
                paint(fov, outer, look.outlineColors, look.outlineTransparencies)
                paint(fov, fill, look.fillColors, look.fillTransparencies)

                if look.moving then
                    fov.rotation = nil

                    local turn = (now * 360 * look.speed) % 360

                    for _, gradient in fov.gradients do
                        gradient.Rotation = turn
                    end
                elseif fov.rotation ~= look.rotation then
                    fill.Rotation, line.Rotation = look.rotation, look.rotation
                    fov.rotation = look.rotation
                end

                fov.at = fov.at:Lerp(FovCircle.anchored(look.anchors, places) or places.center, look.lerp)

                local at = UDim2.fromOffset(fov.at.X, fov.at.Y)

                main.Position, outline.Position = at, at
            end

            return table.freeze(FovCircle)
        end

        function __ANTIBRAIN_MODULES.t()
            local v = __ANTIBRAIN_MODULES.cache.t

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.t = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local AIRBORNE = nil
            local Steer = {}

            Steer.step = function(smoothing, deltaTime)
                return math.min(smoothing * deltaTime * 120, 1)
            end
            Steer.airborne = function(humanoid)
                local states = AIRBORNE or {
                    [Enum.HumanoidStateType.Freefall] = true,
                    [Enum.HumanoidStateType.Jumping] = true,
                }

                AIRBORNE = states

                return states[humanoid:GetState()] == true or humanoid.FloorMaterial == Enum.Material.Air
            end
            Steer.matchAxis = function(part, point, camera)
                local position = camera.Position
                local projected = position + camera.LookVector * (point - position).Magnitude
                local half = part.Size / 2
                local low, high = (part.CFrame * CFrame.new(-half)).Position, (part.CFrame * CFrame.new(half)).Position

                return Vector3.new(math.clamp(projected.X, math.min(low.X, high.X), math.max(low.X, high.X)), math.clamp(projected.Y, math.min(low.Y, high.Y), math.max(low.Y, high.Y)), math.clamp(projected.Z, math.min(low.Z, high.Z), math.max(low.Z, high.Z)))
            end
            Steer.sway = function(from, to)
                local pitch, yaw = (from:Inverse() * to):ToOrientation()

                return Vector2.new(pitch * 0.5, yaw) * 14
            end

            return table.freeze(Steer)
        end

        function __ANTIBRAIN_MODULES.u()
            local v = __ANTIBRAIN_MODULES.cache.u

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.u = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Aiming = __ANTIBRAIN_MODULES.s()
            local FovCircle = __ANTIBRAIN_MODULES.t()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Steer = __ANTIBRAIN_MODULES.u()

            __ANTIBRAIN_MODULES.r()

            local Aimbot = {}

            function Aimbot.start(run, settings, services)
                local cameras = Modules.controller('CameraController')
                local trailing, trailed = nil, nil
                local fov = FovCircle.new(gethui())

                run:add(function()
                    FovCircle.destroy(fov)
                end)

                local places = {
                    center = Vector2.zero,
                }
                local aim = function(target, options, fighter, deltaTime)
                    if not options.aimActive or not target then
                        trailing, trailed = nil, nil

                        return
                    end

                    local camera = cameras:GetCameraCFrame()
                    local position = camera.Position
                    local point = target.part.Position

                    if options.closestPosition then
                        point = Steer.matchAxis(target.part, point, camera)
                    end

                    local look = point

                    if options.delayPosition then
                        local projected = position + camera.LookVector * (position - point).Magnitude
                        local previous = (trailed == target.fighter and trailing and {trailing} or {projected})[1]

                        trailed = target.fighter

                        if (projected - point).Magnitude < (previous - point).Magnitude then
                            previous = projected
                        end

                        local vertical = (Steer.airborne(target.humanoid) and {
                            options.smoothJump,
                        } or {
                            options.smoothY,
                        })[1]
                        local y = previous.Y + (point.Y - previous.Y) * Steer.step(vertical, deltaTime)
                        local across = previous:Lerp(point, Steer.step(options.smoothX, deltaTime))

                        look = Vector3.new(across.X, y, across.Z)
                        trailing = look
                    end

                    local aimed = camera:Lerp(CFrame.lookAt(position, look), Steer.step(options.smoothing, deltaTime))

                    if aimed ~= aimed then
                        return
                    end

                    local pitch, yaw = aimed:ToOrientation()

                    cameras:SetRotation(Vector2.new(pitch, yaw))

                    local item = (type(fighter) == 'table' and {
                        fighter.EquippedItem,
                    } or {nil})[1]
                    local viewModel = (type(item) == 'table' and {
                        item.ViewModel,
                    } or {nil})[1]

                    if viewModel then
                        local sway = Steer.sway(camera, aimed)

                        do
                            local __DARKLUA_VAR = viewModel._sway_spring

                            __DARKLUA_VAR.Value = __DARKLUA_VAR.Value + sway * 35
                        end
                        do
                            local __DARKLUA_VAR0 = cameras._sway_spring

                            __DARKLUA_VAR0.Value = __DARKLUA_VAR0.Value + sway * 0.25
                        end
                    end
                end

                Aiming.join(run, services, 'aimbot', settings, function(
                    selection,
                    camera,
                    fighter,
                    deltaTime
                )
                    local options = settings()

                    aim(selection.aimbot, options, fighter, deltaTime)

                    places.center = camera.ViewportSize / 2
                    places.target = selection.focus
                    places.barrel = (options.aimLook.anchors['position on barrel'] and type(fighter) == 'table' and {
                        (FovCircle.barrel(fighter, camera)),
                    } or {nil})[1]

                    FovCircle.draw(fov, options.aimLook, places, tick())
                end)
            end

            return table.freeze(Aimbot)
        end

        function __ANTIBRAIN_MODULES.v()
            local v = __ANTIBRAIN_MODULES.cache.v

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.v = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.c()

            local Hooks = {}

            function Hooks.disguise(hook, original)
                setfenv(hook, getfenv(original))

                local executorDebug = debug

                if type(executorDebug.setinfo) == 'function' and type(executorDebug.getinfo) == 'function' then
                    executorDebug.setinfo(hook, executorDebug.getinfo(original))
                end
            end
            function Hooks.executor()
                return {
                    hookfunction = hookfunction,
                    getupvalues = debug.getupvalues,
                    setupvalue = debug.setupvalue,
                    getconstants = debug.getconstants,
                    setconstant = debug.setconstant,
                    disguise = Hooks.disguise,
                    cclosure = (type(newcclosure) == 'function' and {newcclosure} or {
                        function(f)
                            return f
                        end,
                    })[1],
                }
            end
            function Hooks.hook(run, access, target, make)
                local original
                local hook = make(function(...)
                    return original(...)
                end)

                access.disguise(hook, target)

                original = access.hookfunction(target, hook)

                run:add(function()
                    access.hookfunction(target, original)
                end)

                return original
            end

            local function swap(run, list, set, current, replacement, what)
                if run.closed then
                    return
                end

                local slots = {}

                for index, value in list()do
                    if value == current then
                        table.insert(slots, index)
                    end
                end

                assert(#slots > 0, string.format('RIVALS code no longer holds %s', tostring(what)))

                local transaction = run:child()

                for _, index in slots do
                    if transaction.closed then
                        return
                    end

                    local function restore()
                        if list()[index] == replacement then
                            set(index, current)
                        end
                    end

                    transaction:add(restore)

                    local failure = Failure.capture(set, index, replacement)

                    if failure then
                        transaction:close()
                    end
                    if transaction.closed then
                        local rollbackFailure = Failure.capture(restore)

                        if rollbackFailure then
                            run:report(rollbackFailure)
                        end
                    end
                    if failure then
                        error(failure, 0)
                    end
                end
            end

            function Hooks.swapUpvalue(
                run,
                access,
                closure,
                current,
                replacement,
                what
            )
                swap(run, function()
                    return access.getupvalues(closure)
                end, function(index, value)
                    access.setupvalue(closure, index, value)
                end, current, replacement, what)
            end
            function Hooks.swapConstant(
                run,
                access,
                closure,
                current,
                replacement,
                what
            )
                swap(run, function()
                    return access.getconstants(closure)
                end, function(index, value)
                    access.setconstant(closure, index, value)
                end, current, replacement, what)
            end

            return table.freeze(Hooks)
        end

        function __ANTIBRAIN_MODULES.w()
            local v = __ANTIBRAIN_MODULES.cache.w

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.w = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Service = __ANTIBRAIN_MODULES.m()
            local HOLD = 1

            local function resolve()
                local loop = Modules.controller('FighterController')._CameraReplicationLoop

                assert(type(loop) == 'function', 
[[RIVALS FighterController._CameraReplicationLoop is unavailable]])

                local update = Modules.remote({
                    'Replication',
                    'Fighter',
                    'UpdateCameraRotation',
                })

                assert(update:IsA('UnreliableRemoteEvent'), string.format(
[[RIVALS UpdateCameraRotation is a %s, not an UnreliableRemoteEvent]], tostring(update.ClassName)))

                return {
                    loop = loop,
                    access = Hooks.executor(),
                    replicatedStorage = game:GetService('ReplicatedStorage'),
                    delay = function(seconds, callback)
                        return task.delay(seconds, callback)
                    end,
                    cancel = task.cancel,
                    fire = function(encoded)
                        update:FireServer(encoded, nil)
                    end,
                }
            end

            local CameraHold = {}

            function CameraHold.release(hold)
                hold.holding = false

                local pending = hold.release

                hold.release = nil

                if pending then
                    hold.deps.cancel(pending)
                end
            end

            local CAMERA_HOLD = Service.new('camera hold', function(
                scope,
                _services,
                dependencies
            )
                local deps = dependencies or resolve()
                local cclosure = deps.access.cclosure
                local hold = {
                    holding = false,
                    deps = deps,
                    release = nil,
                }
                local swallow = nil
                local swallowing = setmetatable({}, {
                    __index = cclosure(function()
                        return swallow
                    end),
                    __call = cclosure(function()
                        return swallow
                    end),
                    __newindex = cclosure(function() end),
                    __tostring = cclosure(function()
                        return 'ReplicatedStorage'
                    end),
                    __metatable = 'The metatable is locked',
                })

                swallow = swallowing

                local replicatedStorage = deps.replicatedStorage
                local standIn = setmetatable({}, {
                    __index = cclosure(function(_, key)
                        return (hold.holding and {swallowing} or {
                            replicatedStorage[key],
                        })[1]
                    end),
                    __tostring = cclosure(function()
                        return 'ReplicatedStorage'
                    end),
                    __metatable = 'The metatable is locked',
                })

                Hooks.swapUpvalue(scope, deps.access, deps.loop, replicatedStorage, standIn, 'ReplicatedStorage in its camera replication loop')
                scope:add(function()
                    CameraHold.release(hold)
                end)

                return hold
            end)

            function CameraHold.use(run, services, dependencies)
                return Service.use(run, services, CAMERA_HOLD, dependencies)
            end
            function CameraHold.begin(hold)
                hold.holding = true
            end
            function CameraHold.send(hold, encoded)
                local deps = hold.deps
                local failure = Failure.capture(function()
                    deps.fire(encoded)

                    hold.holding = true

                    if hold.release then
                        deps.cancel(hold.release)
                    end

                    hold.release = deps.delay(HOLD, function()
                        hold.holding = false
                        hold.release = nil
                    end)
                end)

                if failure then
                    Failure.capture(CameraHold.release, hold)
                    error(failure, 0)
                end
            end

            return table.freeze(CameraHold)
        end

        function __ANTIBRAIN_MODULES.x()
            local v = __ANTIBRAIN_MODULES.cache.x

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.x = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local MAX_CODE_POINT = 0x10ffff
            local TAU = 2 * math.pi
            local codePoint = function(value)
                local point = math.floor(value)

                if point >= 0xd800 and point < 0xe000 then
                    point = 0xe000
                end

                return utf8.char(math.clamp(point, 0, MAX_CODE_POINT))
            end
            local turn = function(angle)
                return utf8.char(math.clamp(math.floor(angle % TAU / math.pi / 2 * 256 + 0.5), 0, 255))
            end
            local Pose = {}

            Pose.PITCHES = table.freeze({
                'disabled',
                'offset',
                'random',
                'look up',
                'look down',
                'custom',
                'extended custom',
                'extended random',
            })
            Pose.YAWS = table.freeze({
                'disabled',
                'offset',
                'backwards',
                'random',
                'custom',
            })
            Pose.bend = function(settings, pitch, yaw, random)
                local mode = settings.pitch

                if mode == 'extended custom' then
                    return {
                        kind = 'encoded',
                        data = codePoint((settings.customPitch + 180) / 360 * MAX_CODE_POINT),
                    }
                elseif mode == 'extended random' then
                    return {
                        kind = 'encoded',
                        data = codePoint(random(0, MAX_CODE_POINT)),
                    }
                elseif mode == 'offset' then
                    pitch = pitch + settings.customPitch
                elseif mode == 'random' then
                    pitch = random(0, 360)
                elseif mode == 'look up' then
                    pitch = 179
                elseif mode == 'look down' then
                    pitch = 180
                elseif mode == 'custom' then
                    pitch = settings.customPitch
                end

                mode = settings.yaw

                if mode == 'offset' then
                    yaw = yaw + settings.customYaw
                elseif mode == 'backwards' then
                    yaw = yaw + 180
                elseif mode == 'random' then
                    yaw = random(0, 360)
                elseif mode == 'custom' then
                    yaw = settings.customYaw
                end

                return {
                    kind = 'angles',
                    pitch = pitch,
                    yaw = yaw,
                }
            end
            Pose.encode = function(pitch, yaw)
                return turn(pitch) .. turn(yaw)
            end

            return table.freeze(Pose)
        end

        function __ANTIBRAIN_MODULES.y()
            local v = __ANTIBRAIN_MODULES.cache.y

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.y = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local CameraHold = __ANTIBRAIN_MODULES.x()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()
            local Pose = __ANTIBRAIN_MODULES.y()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local SETTLE = 0.05

            local function resolve()
                local startAiming = Modules.client({
                    'Items',
                    'Knife',
                }).StartAiming

                assert(type(startAiming) == 'function', 'RIVALS Knife.StartAiming is unavailable')

                local sideTasks = Modules.client({
                    'UserInterface',
                    'SideTasks',
                })

                return {
                    startAiming = startAiming,
                    access = Hooks.executor(),
                    now = tick,
                    wait = task.wait,
                    target = function()
                        local fighter = rawget(sideTasks, '_local_fighter')
                        local cameraData = (fighter and {
                            (fighter:GetCameraData()),
                        } or {nil})[1]

                        return (type(cameraData) == 'table' and {
                            cameraData[utf8.char(2)],
                        } or {nil})[1]
                    end,
                    validTarget = function(target)
                        if typeof(target) ~= 'Instance' then
                            return false
                        end

                        local model = target:FindFirstAncestorOfClass('Model')

                        return model ~= nil and model:FindFirstChildOfClass('Humanoid') ~= nil
                    end,
                    behind = function(target)
                        local cframe = target.CFrame
                        local pitch, yaw = (cframe * CFrame.new(0, 0, 3)):ToOrientation()

                        return pitch, yaw
                    end,
                }
            end

            local AlwaysBackstab = {}

            function AlwaysBackstab.start(run, services, dependencies)
                local deps = dependencies or resolve()
                local hold = CameraHold.use(run, services, deps.hold)

                Hooks.hook(run, deps.access, deps.startAiming, function(
                    original
                )
                    return function(knife, secondary, ...)
                        local arguments = table.pack(...)
                        local results
                        local failure = Failure.capture(function()
                            if not secondary and knife.ClientFighter.IsLocalPlayer and knife._attack_cooldown < deps.now() and not knife:IsEquipping() then
                                local target = deps.target()

                                if target and deps.validTarget(target) then
                                    CameraHold.begin(hold)
                                    deps.wait(SETTLE)

                                    if run.closed then
                                        CameraHold.release(hold)

                                        results = table.pack(original(knife, secondary, table.unpack(arguments, 1, arguments.n)))

                                        return
                                    end

                                    CameraHold.send(hold, Pose.encode(deps.behind(target)))
                                    deps.wait(SETTLE)

                                    if run.closed then
                                        CameraHold.release(hold)
                                    end
                                end
                            end

                            results = table.pack(original(knife, secondary, table.unpack(arguments, 1, arguments.n)))
                        end)

                        if failure then
                            local releaseFailure = Failure.capture(CameraHold.release, hold)

                            if releaseFailure then
                                run:report(releaseFailure)
                            end

                            error(failure, 0)
                        end

                        return table.unpack(results, 1, results.n)
                    end
                end)
            end

            return table.freeze(AlwaysBackstab)
        end

        function __ANTIBRAIN_MODULES.z()
            local v = __ANTIBRAIN_MODULES.cache.z

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.z = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Aiming = __ANTIBRAIN_MODULES.s()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()
            local Pose = __ANTIBRAIN_MODULES.y()

            __ANTIBRAIN_MODULES.c()

            local Service = __ANTIBRAIN_MODULES.m()

            local function resolve()
                local loop = Modules.controller('FighterController')._CameraReplicationLoop

                assert(type(loop) == 'function', 
[[RIVALS FighterController._CameraReplicationLoop is unavailable]])

                return {
                    loop = loop,
                    utility = Modules.shared('Utility'),
                    random = math.random,
                    access = Hooks.executor(),
                }
            end

            local ENCODER = Service.new('pose encoder', function(
                scope,
                services,
                dependencies
            )
                local deps = dependencies or resolve()
                local utility = deps.utility
                local encode = utility.EncodeCameraRotation

                assert(type(encode) == 'function', 'RIVALS Utility.EncodeCameraRotation is unavailable')

                local state = {bend = nil}
                local standIn = setmetatable({}, {__index = utility})

                standIn.EncodeCameraRotation = function(_, rotation, ...)
                    if Aiming.ragebotActive(services) then
                        return '\0\0'
                    end

                    local settings = state.bend

                    if not settings then
                        return encode(utility, rotation, ...)
                    end

                    local pose = Pose.bend(settings(), math.deg(rotation.X), math.deg(rotation.Y), deps.random)

                    if pose.kind == 'encoded' then
                        return pose.data
                    end

                    return encode(utility, Vector2.new(math.rad(pose.pitch), math.rad(pose.yaw)), 
...)
                end

                deps.access.disguise(standIn.EncodeCameraRotation, encode)
                Hooks.swapUpvalue(scope, deps.access, deps.loop, utility, standIn, 'Utility in its camera replication loop')

                return state
            end)
            local Encoder = {}

            function Encoder.use(run, services, bend, dependencies)
                local encoder = Service.use(run, services, ENCODER, dependencies)

                if bend then
                    encoder.bend = bend

                    run:add(function()
                        if encoder.bend == bend then
                            encoder.bend = nil
                        end
                    end)
                end
            end

            return table.freeze(Encoder)
        end

        function __ANTIBRAIN_MODULES.A()
            local v = __ANTIBRAIN_MODULES.cache.A

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.A = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Encoder = __ANTIBRAIN_MODULES.A()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()
            local Pose = __ANTIBRAIN_MODULES.y()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local AntiAim = {}

            AntiAim.PITCHES, AntiAim.YAWS = Pose.PITCHES, Pose.YAWS

            function AntiAim.start(run, settings, services, dependencies)
                Encoder.use(run, services, settings, dependencies)
            end
            function AntiAim.guardDecoding(run, dependencies)
                local deps = dependencies or {
                    utility = Modules.shared('Utility'),
                    access = Hooks.executor(),
                }
                local target = deps.utility.DecodeCameraRotationBulk

                assert(type(target) == 'function', 'RIVALS Utility.DecodeCameraRotationBulk is unavailable')
                Hooks.hook(run, deps.access, target, function(original)
                    return function(...)
                        local results = table.pack(pcall(original, ...))

                        if results[1] then
                            return table.unpack(results, 2, results.n)
                        end

                        return {}
                    end
                end)
            end

            return table.freeze(AntiAim)
        end

        function __ANTIBRAIN_MODULES.B()
            local v = __ANTIBRAIN_MODULES.cache.B

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.B = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local AntiAim = __ANTIBRAIN_MODULES.B()

            __ANTIBRAIN_MODULES.g()

            local Character = {}

            function Character.build(ui)
                local aiming = ui.tab('character'):groupbox('Right', 'anti aim')
                local antiAim = aiming:toggle(ui.id('anti-aim'), {
                    text = 'enabled',
                    default = false,
                })
                local box = aiming:dependent(function()
                    return antiAim.value
                end)
                local pitch = box:dropdown(ui.id('anti-aim-pitch'), {
                    text = 'pitch',
                    values = table.clone(AntiAim.PITCHES),
                    default = 'disabled',
                })
                local customPitch = box:dependent(function()
                    local chosen = pitch.value

                    return chosen == 'offset' or chosen == 'custom' or chosen == 'extended custom' or chosen == 'extended random'
                end):slider(ui.id('anti-aim-custom-pitch'), {
                    text = 'pitch angle',
                    default = 0,
                    min = -180,
                    max = 180,
                    rounding = 0,
                    increment = 5,
                    suffix = '\u{b0}',
                })
                local yaw = box:dropdown(ui.id('anti-aim-yaw'), {
                    text = 'yaw',
                    values = table.clone(AntiAim.YAWS),
                    default = 'disabled',
                })
                local customYaw = box:dependent(function()
                    local chosen = yaw.value

                    return chosen == 'offset' or chosen == 'custom'
                end):slider(ui.id('anti-aim-custom-yaw'), {
                    text = 'yaw angle',
                    default = 0,
                    min = -180,
                    max = 180,
                    rounding = 0,
                    increment = 5,
                    suffix = '\u{b0}',
                })
                local underground = aiming:toggle(ui.id('underground'), {
                    text = 'underground',
                    default = false,
                    tooltip = 
[[the server sees you lying under the floor below you, wherever you are]],
                })
                local undergroundKey = underground:keybind(ui.id('underground-key'), {
                    text = 'underground',
                })
                local settings = {
                    pitch = 'disabled',
                    customPitch = 0,
                    yaw = 'disabled',
                    customYaw = 0,
                }

                return {
                    antiAim = antiAim,
                    antiAimSettings = function()
                        settings.pitch, settings.customPitch = pitch.value or 'disabled', customPitch.value
                        settings.yaw, settings.customYaw = yaw.value or 'disabled', customYaw.value

                        return settings
                    end,
                    underground = underground,
                    undergroundActive = function()
                        return undergroundKey:active()
                    end,
                }
            end

            return table.freeze(Character)
        end

        function __ANTIBRAIN_MODULES.C()
            local v = __ANTIBRAIN_MODULES.cache.C

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.C = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local DEFAULTS = table.freeze({
                flySpeed = 15000,
                zigAmplitude = 400,
                zigFrequency = 8,
                cycle = 0.05,
                flyTime = 0.025,
                depth = 6,
                boost = 100000,
                boostEvery = 0.6,
                spread = 30,
            })
            local MOST_FLYING = 0.95
            local Blink = {}

            Blink.DEFAULTS = DEFAULTS

            function Blink.new()
                return {
                    started = nil,
                    fly = {
                        x = 0,
                        y = 0,
                        z = 0,
                    },
                    boostAt = 0,
                    cycle = nil,
                    stop = nil,
                    spot = nil,
                    from = nil,
                }
            end
            function Blink.reset(blink)
                blink.started, blink.cycle, blink.stop, blink.spot, blink.from = nil, nil, nil, nil, nil
            end

            local function pick(blink, spots, engine, random)
                local index = math.clamp(math.floor(random() * #spots) + 1, 1, #spots)

                if index == blink.spot and #spots > 1 then
                    index = index % #spots + 1
                end

                blink.spot = index

                local spot = spots[index]
                local angle = random() * math.pi * 2
                local distance = math.sqrt(random()) * engine.spread

                return {
                    x = spot.x + math.cos(angle) * distance,
                    y = spot.floor - engine.depth,
                    z = spot.z + math.sin(angle) * distance,
                    flying = false,
                }
            end

            function Blink.pose(blink, now, delta, from, spots, random, engine)
                if not blink.started then
                    blink.started = now
                    blink.from = {
                        x = from.x,
                        y = from.y,
                        z = from.z,
                    }
                    blink.fly = {
                        x = from.x,
                        y = from.y,
                        z = from.z,
                    }
                    blink.boostAt = now + engine.boostEvery
                end

                local started = blink.started or now
                local home = blink.from or from
                local fly = blink.fly

                fly.y = fly.y + engine.flySpeed * delta

                if now >= blink.boostAt then
                    fly.y = fly.y + engine.boost
                    blink.boostAt = now + engine.boostEvery
                end

                local length = math.max(engine.cycle, 0.005)
                local elapsed = now - started
                local cycle = math.floor(elapsed / length)
                local phase = elapsed / length - cycle
                local share = math.min(engine.flyTime / length, MOST_FLYING)

                if phase < share or (spots and #spots == 0) then
                    return {
                        x = fly.x + math.cos(now * engine.zigFrequency) * engine.zigAmplitude,
                        y = fly.y,
                        z = fly.z,
                        flying = true,
                    }
                end
                if not spots then
                    return {
                        x = home.x,
                        y = home.y - engine.depth,
                        z = home.z,
                        flying = false,
                    }
                end

                local stop = blink.stop

                if not stop or blink.cycle ~= cycle then
                    stop = pick(blink, spots, engine, random)
                    blink.stop, blink.cycle = stop, cycle
                end

                return stop
            end

            return table.freeze(Blink)
        end

        function __ANTIBRAIN_MODULES.D()
            local v = __ANTIBRAIN_MODULES.cache.D

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.D = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()

            local function bind(run, priority, callback)
                if run.closed then
                    return
                end

                local runService = Services.RunService
                local name = string.format('AntiBrain.%s', tostring(Services.HttpService:GenerateGUID(false)))

                runService:BindToRenderStep(name, priority, function()
                    if run.closed then
                        return
                    end

                    local failure = Failure.capture(callback)

                    if failure then
                        run:report(failure)
                    end
                end)
                run:add(function()
                    runService:UnbindFromRenderStep(name)
                end)
            end

            local RenderStep = {}

            function RenderStep.afterCamera(run, callback)
                bind(run, Enum.RenderPriority.Camera.Value + 1, callback)
            end
            function RenderStep.beforeCamera(run, callback)
                bind(run, Enum.RenderPriority.Camera.Value - 1, callback)
            end

            return table.freeze(RenderStep)
        end

        function __ANTIBRAIN_MODULES.E()
            local v = __ANTIBRAIN_MODULES.cache.E

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.E = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Fighter = __ANTIBRAIN_MODULES.o()
            local Modules = __ANTIBRAIN_MODULES.l()
            local RenderStep = __ANTIBRAIN_MODULES.E()

            __ANTIBRAIN_MODULES.c()

            local Service = __ANTIBRAIN_MODULES.m()
            local Services = __ANTIBRAIN_MODULES.k()
            local ROOT_TIMEOUT = 10
            local DESYNC = Service.new('desync', function(scope, services)
                local player = Modules.player()
                local fighters = Modules.controller('FighterController')
                local index = ((assert(getrawmetatable(game), 'Instance metatable is unavailable'))).__index
                local members = {}
                local character = nil
                local root = nil
                local real = nil

                local function track(model)
                    character, root, real = model, nil, nil

                    local part = model:WaitForChild('HumanoidRootPart', ROOT_TIMEOUT)

                    if character == model and part and part:IsA('BasePart') then
                        root = part
                    end
                end

                scope:connect(player.CharacterAdded, track)
                scope:connect(player.CharacterRemoving, function(model)
                    if model == character then
                        character, root, real = nil, nil, nil
                    end
                end)

                if player.Character then
                    scope:spawn(track, player.Character)
                end

                RenderStep.beforeCamera(scope, function()
                    local part, cframe = root, real

                    if part and cframe then
                        part.CFrame = cframe
                    end
                end)
                scope:connect(Services.RunService.Heartbeat, function(
                    deltaTime
                )
                    local part = root

                    if not part or not Fighter.alive(fighters.LocalFighter, player) then
                        real = nil

                        for _, member in members do
                            if member.idle then
                                local failure = Failure.capture(member.idle)

                                if failure then
                                    scope:report(string.format('A member sitting out failed: %s', tostring(failure)))
                                end
                            end
                        end

                        return
                    end

                    local cframe = index(part, 'CFrame')

                    real = cframe

                    for _, member in members do
                        local ok, server = pcall(member.propose, cframe, part, deltaTime)

                        if not ok then
                            part.CFrame = cframe

                            scope:report(string.format('A desync member failed: %s', tostring(server)))
                        elseif server then
                            part.CFrame = server

                            return
                        else
                            cframe = index(part, 'CFrame')
                            real = cframe
                        end
                    end

                    real = nil
                end)
                scope:add(function()
                    local part, cframe = root, real

                    root, real = nil, nil

                    if part and cframe and part.Parent then
                        part.CFrame = cframe
                    end
                end)

                return {members = members}
            end)
            local Desync = {}

            function Desync.join(run, services, order, propose, idle)
                local desync = Service.use(run, services, DESYNC)
                local member = {
                    order = order,
                    propose = propose,
                    idle = idle,
                }

                table.insert(desync.members, member)
                table.sort(desync.members, function(a, b)
                    return a.order < b.order
                end)
                run:add(function()
                    local at = table.find(desync.members, member)

                    if at then
                        table.remove(desync.members, at)
                    end
                end)
            end

            return table.freeze(Desync)
        end

        function __ANTIBRAIN_MODULES.F()
            local v = __ANTIBRAIN_MODULES.cache.F

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.F = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.q()

            local CAMERA, MUZZLE, HIT_PART, HIT_OFFSET = '\0', '\1', '\2', '\3'
            local PACKED = table.freeze({
                '\0',
                '\1',
                '\2',
                '\3',
                '\4',
                '\5',
            })
            local SCATTER = 0.1
            local pack = function(frame)
                local x, y, z = frame:ToOrientation()
                local position = frame.Position
                local values = {
                    position.X,
                    position.Y,
                    position.Z,
                    x,
                    y,
                    z,
                }
                local packed = {}

                for index, key in PACKED do
                    packed[key] = values[index]
                end

                return packed
            end
            local unpackFrame = function(packed)
                if type(packed) ~= 'table' then
                    return nil
                end

                local values = table.create(6)

                for index, key in PACKED do
                    local value = packed[key]

                    if type(value) ~= 'number' then
                        return nil
                    end

                    values[index] = value
                end

                return CFrame.new(values[1], values[2], values[3]) * CFrame.fromOrientation(values[4], values[5], values[6])
            end
            local Shot = {}

            Shot.pack = pack

            function Shot.scatter()
                return CFrame.new(math.random() * SCATTER, math.random() * SCATTER, math.random() * SCATTER)
            end

            Shot.aim = function(cameraData, part, manipulation)
                if type(cameraData) ~= 'table' then
                    return
                end

                local camera, muzzle = unpackFrame(cameraData[CAMERA]), unpackFrame(cameraData[MUZZLE])

                if not camera or not muzzle then
                    return
                end

                local offset = CFrame.new(Random.new():NextUnitVector() * SCATTER)

                if manipulation then
                    camera = CFrame.new(manipulation.origin) * camera.Rotation
                    muzzle = CFrame.new(manipulation.origin) * muzzle.Rotation

                    if manipulation.hitOffset then
                        offset = CFrame.new(manipulation.hitOffset)
                    end
                else
                    camera = CFrame.lookAt(camera.Position, part.Position)
                    muzzle = CFrame.lookAt(muzzle.Position, part.Position)
                end

                cameraData[CAMERA] = pack(camera)
                cameraData[MUZZLE] = pack(muzzle)
                cameraData[HIT_OFFSET] = pack(offset)
                cameraData[HIT_PART] = part
            end

            return table.freeze(Shot)
        end

        function __ANTIBRAIN_MODULES.G()
            local v = __ANTIBRAIN_MODULES.cache.G

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.G = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Shot = __ANTIBRAIN_MODULES.G()
            local Swing = {}

            function Swing.data(aim, part)
                return {
                    ['\0'] = Shot.pack(aim),
                    ['\1'] = Shot.pack(aim + Vector3.one * 0.01),
                    ['\2'] = part,
                    ['\3'] = Shot.pack(Shot.scatter()),
                }
            end
            function Swing.animation(item, heavy)
                local kind = heavy and 'HeavyAttack' or 'Attack'
                local count = #item.ViewModel:GetAnimationKeys(kind)

                if count == 0 then
                    return nil
                end
                if heavy then
                    item._heavy_attack_num = (item._heavy_attack_num or 0) % count + 1

                    return string.format('%s%s', tostring(kind), tostring(item._heavy_attack_num))
                end

                item._attack_num = (item._attack_num or 0) % count + 1

                return string.format('%s%s', tostring(kind), tostring(item._attack_num))
            end
            function Swing.send(use, enums, item, aim, part, heavy)
                local animation = Swing.animation(item, heavy)

                if not animation then
                    return false
                end

                use(item:Get('ObjectID'), enums:ToEnum(heavy and 'StartAiming' or 'StartShooting'), {
                    ['\1'] = Swing.data(aim, part),
                    ['\2'] = enums:ToEnum(animation),
                }, nil)

                return true
            end

            return table.freeze(Swing)
        end

        function __ANTIBRAIN_MODULES.H()
            local v = __ANTIBRAIN_MODULES.cache.H

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.H = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local SPEED = 400
            local JUMP_DISTANCE = 20
            local HOVER_HEIGHT = 12
            local HOVER_DRIFT = 0.2
            local HOVER_TIME = 0.5
            local THRESHOLD = 4
            local WINDOW = 3
            local MEMORY = 15
            local Ragers = {}

            Ragers.WINDOW = WINDOW
            Ragers.MEMORY = MEMORY

            function Ragers.new()
                return {
                    seen = {},
                    signs = {},
                    flagged = {},
                }
            end

            local function sign(ragers, player, now, points)
                local signs = ragers.signs[player]

                if not signs then
                    signs = {}
                    ragers.signs[player] = signs
                end

                table.insert(signs, {
                    at = now,
                    points = points,
                })

                while signs[1] and now - signs[1].at > WINDOW do
                    table.remove(signs, 1)
                end

                local total = 0

                for _, entry in signs do
                    total = total + entry.points
                end

                if total >= THRESHOLD then
                    ragers.flagged[player] = now
                end
            end

            function Ragers.observe(ragers, player, sample)
                local now = sample.now
                local last = ragers.seen[player]
                local seen = {
                    x = sample.x,
                    y = sample.y,
                    z = sample.z,
                    at = now,
                    still = nil,
                }

                ragers.seen[player] = seen

                if sample.grace then
                    return
                end
                if sample.outside then
                    sign(ragers, player, now, THRESHOLD)
                end
                if not last or now <= last.at then
                    return
                end

                local dx, dy, dz = sample.x - last.x, sample.y - last.y, sample.z - last.z
                local distance = math.sqrt(dx * dx + dy * dy + dz * dz)

                if distance >= JUMP_DISTANCE and distance / (now - last.at) > SPEED then
                    sign(ragers, player, now, sample.nearMe and 2 or 1)

                    return
                end

                local height = sample.height

                if height and height >= HOVER_HEIGHT and math.abs(dy) <= HOVER_DRIFT then
                    local since = last.still or last.at

                    if now - since >= HOVER_TIME then
                        sign(ragers, player, now, 1)

                        seen.still = now
                    else
                        seen.still = since
                    end
                end
            end
            function Ragers.is(ragers, player, now)
                local at = ragers.flagged[player]

                return at ~= nil and now - at <= MEMORY
            end
            function Ragers.respawned(ragers, player)
                ragers.seen[player] = nil
            end

            return table.freeze(Ragers)
        end

        function __ANTIBRAIN_MODULES.I()
            local v = __ANTIBRAIN_MODULES.cache.I

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.I = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Ragers = __ANTIBRAIN_MODULES.I()
            local Services = __ANTIBRAIN_MODULES.k()
            local OUTSIDE, NEAR, GRACE, GROUND = 100, 8, 1.5, 200
            local VOID = 1000000
            local RUNNING = 200
            local Watch = {}

            function Watch.new()
                local ground = RaycastParams.new()

                ground.FilterType = Enum.RaycastFilterType.Exclude

                return {
                    ragers = Ragers.new(),
                    ground = ground,
                    box = nil,
                    spawned = {},
                    last = {},
                }
            end

            local function barriers(watch, duel)
                local map = (type(duel.Map) == 'table' and {
                    duel.Map.Model,
                } or {nil})[1]
                local folder = (typeof(map) == 'Instance' and {
                    (map:FindFirstChild('Barriers')),
                } or {nil})[1]

                if not folder then
                    return nil, nil
                end

                local held = watch.box

                if held and held.map == map then
                    return held.low, held.high
                end

                local low, high = Vector3.one * math.huge, -Vector3.one * math.huge

                for _, part in folder:GetChildren()do
                    if part:IsA('BasePart') then
                        local half = part.Size / 2

                        low = low:Min(part.Position - half)
                        high = high:Max(part.Position + half)
                    end
                end

                if low.X > high.X then
                    return nil, nil
                end

                watch.box = {
                    map = map,
                    low = low,
                    high = high,
                }

                return low, high
            end

            function Watch.update(watch, me, duel, mine)
                local list = {}
                local duelers = (type(duel) == 'table' and {
                    duel._duelers_by_player,
                } or {nil})[1]

                if type(duelers) ~= 'table' then
                    return list
                end

                local now = tick()
                local started = type(duel.Data) == 'table' and duel.Data.Status == 'RoundStarted'
                local low, high = barriers(watch, duel)
                local characters = {}

                for player in duelers do
                    if player.Character then
                        table.insert(characters, player.Character)
                    end
                end

                watch.ground.FilterDescendantsInstances = characters

                for player, dueler in duelers do
                    local character = player.Character
                    local humanoid = (character and {
                        (character:FindFirstChildOfClass('Humanoid')),
                    } or {nil})[1]
                    local root = (character and {
                        (character:FindFirstChild('HumanoidRootPart')),
                    } or {nil})[1]

                    if player ~= me and character and type(dueler) == 'table' and humanoid and root and root:IsA('BasePart') then
                        local ally = dueler._is_ally == true
                        local position = root.Position
                        local health = humanoid.Health
                        local outside = position.Magnitude >= VOID

                        if low and high then
                            outside = outside or (position - position:Max(low):Min(high)).Magnitude > OUTSIDE
                        end
                        if not ally and health > 0 then
                            local held = watch.spawned[player]
                            local life = (held and held.character == character and {held} or {nil})[1]

                            if not life then
                                life = {
                                    character = character,
                                    at = now,
                                }
                                watch.spawned[player] = life

                                Ragers.respawned(watch.ragers, player)
                            end

                            local born = (life).at
                            local hit = Services.Workspace:Raycast(position, Vector3.new(0, 
-GROUND, 0), watch.ground)

                            Ragers.observe(watch.ragers, player, {
                                x = position.X,
                                y = position.Y,
                                z = position.Z,
                                now = now,
                                outside = outside,
                                nearMe = (position - mine).Magnitude <= NEAR,
                                height = (hit and {
                                    (position.Y - hit.Position.Y),
                                } or {GROUND})[1],
                                grace = not started or now - born < GRACE,
                            })
                        end

                        local seen = watch.last[player]
                        local velocity = root.AssemblyLinearVelocity

                        if seen and now - seen.at > 0.005 then
                            local moved = (position - seen.position) / (now - seen.at)

                            if moved.Magnitude <= RUNNING and moved.Magnitude > velocity.Magnitude then
                                velocity = moved
                            end
                        end
                        if not seen or now - seen.at > 0.005 then
                            watch.last[player] = {
                                position = position,
                                at = now,
                            }
                        end

                        local head = character:FindFirstChild('HitboxHead') or character:FindFirstChild('HitboxBody')

                        table.insert(list, {
                            player = player,
                            name = player.Name,
                            character = character,
                            root = root,
                            part = (head and head:IsA('BasePart') and {head} or {root})[1],
                            position = position,
                            velocity = velocity,
                            distance = (position - mine).Magnitude,
                            health = health,
                            ally = ally,
                            rager = not ally and Ragers.is(watch.ragers, player, now),
                            inside = not outside,
                        })
                    end
                end

                return list
            end

            return table.freeze(Watch)
        end

        function __ANTIBRAIN_MODULES.J()
            local v = __ANTIBRAIN_MODULES.cache.J

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.J = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Blink = __ANTIBRAIN_MODULES.D()
            local Desync = __ANTIBRAIN_MODULES.F()
            local Fighter = __ANTIBRAIN_MODULES.o()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Services = __ANTIBRAIN_MODULES.k()
            local Shot = __ANTIBRAIN_MODULES.G()
            local Swing = __ANTIBRAIN_MODULES.H()
            local Watch = __ANTIBRAIN_MODULES.J()
            local LIFT = 6000
            local CEILING = 40000
            local HOP_EVERY = 4
            local HOP_MIN, HOP_MAX = 1000, 2000
            local EYE = 1.75
            local CAMERA = 1.8
            local ORDER = 1.5
            local NAMES = table.freeze({
                ue = 'ue counter',
                solix = 'solix counter',
                kicia = 'kicia counter',
            })

            local function isMelee(item)
                return type(item) == 'table' and type(item.Info) == 'table' and item.Info.Type == 'Melee'
            end
            local function short(height)
                local size = math.abs(height)

                if size >= 1e6 then
                    return string.format('%sM', tostring(math.floor(height / 1e5) / 10))
                elseif size >= 1e4 then
                    return string.format('%sK', tostring(math.floor(height / 1e2) / 10))
                end

                return tostring(math.floor(height))
            end
            local function toSpawn()
                local character = Modules.player().Character
                local part = (character and {
                    (character:FindFirstChild('HumanoidRootPart')),
                } or {nil})[1]

                if not part or not part:IsA('BasePart') then
                    return
                end

                local duel = Modules.controller('SpectateController').CurrentDuelSubject
                local map = (type(duel) == 'table' and type(duel.Map) == 'table' and {
                    duel.Map.Model,
                } or {nil})[1]
                local folder = (typeof(map) == 'Instance' and {
                    (map:FindFirstChild('Spawns')),
                } or {nil})[1]

                if not folder then
                    return
                end

                for _, spawn in folder:GetDescendants()do
                    if spawn:IsA('BasePart') then
                        part.AssemblyLinearVelocity = Vector3.zero
                        part.CFrame = CFrame.new(spawn.Position + Vector3.new(0, 3, 0))

                        return
                    end
                end
            end
            local function resolve(run, services)
                local me = Modules.player()
                local fighters = Modules.controller('FighterController')
                local spectate = Modules.controller('SpectateController')
                local enums = Modules.shared('EnumLibrary')
                local useItem = (Modules.remote({
                    'Replication',
                    'Fighter',
                    'UseItem',
                }))
                local random = Random.new()
                local watch = Watch.new()
                local taken = nil

                local function send(...)
                    useItem:FireServer(...)
                end
                local function root()
                    local character = me.Character
                    local part = (character and {
                        (character:FindFirstChild('HumanoidRootPart')),
                    } or {nil})[1]

                    return (part and part:IsA('BasePart') and {part} or {nil})[1]
                end

                return {
                    now = tick,
                    fighter = function()
                        local fighter = fighters.LocalFighter

                        return (Fighter.alive(fighter, me) and {fighter} or {nil})[1]
                    end,
                    root = root,
                    opponents = function(part)
                        return (Watch.update(watch, me, spectate.CurrentDuelSubject, part.Position))
                    end,
                    height = function(part)
                        return part.Position.Y
                    end,
                    equip = function(fighter, item)
                        run:spawn(fighter.EquipItem, fighter, item.Data.ItemIndex)
                    end,
                    lift = function(part, anchor)
                        part.CFrame = CFrame.new(anchor.x, anchor.y + LIFT, anchor.z) * part.CFrame.Rotation
                    end,
                    hop = function(part)
                        local angle = random:NextNumber(0, math.pi * 2)
                        local distance = random:NextNumber(HOP_MIN, HOP_MAX)

                        part.CFrame = part.CFrame + Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
                    end,
                    rise = function(part, speed)
                        part.AssemblyLinearVelocity = Vector3.new(0, speed, 0)
                    end,
                    drop = function(part, opponent, lead)
                        local seen = opponent
                        local position = seen.position
                        local moving = seen.velocity * Vector3.new(1, 0, 1)
                        local at = position + ((moving.Magnitude > 1 and {
                            (moving.Unit * lead),
                        } or {
                            Vector3.zero,
                        })[1])

                        part.CFrame = CFrame.new(at) * part.CFrame.Rotation
                        part.AssemblyLinearVelocity = Vector3.zero
                    end,
                    rescue = function(anchor)
                        local part = root()

                        if part and anchor then
                            part.AssemblyLinearVelocity = Vector3.zero
                            part.CFrame = CFrame.new(anchor.x, anchor.y + 3, anchor.z)
                        else
                            toSpawn()
                        end
                    end,
                    prepare = function()
                        taken = nil

                        local fighter = fighters.LocalFighter

                        if type(fighter) == 'table' then
                            local ok, data = pcall(fighter.GetCameraData, fighter)

                            taken = (ok and type(data) == 'table' and {
                                (table.clone(data)),
                            } or {nil})[1]
                        end
                    end,
                    replicate = function(part)
                        local setIdentity = setthreadidentity
                        local setHidden = sethiddenproperty

                        if type(setIdentity) == 'function' then
                            setIdentity(8)
                        end
                        if type(setHidden) == 'function' then
                            setHidden(part, 'PhysicsRepRootPart', Services.Workspace.Terrain)
                        end
                    end,
                    swing = function(item, part)
                        local own = root()

                        if not own then
                            return
                        end

                        local data = taken

                        if data then
                            local animation = Swing.animation(item, false)

                            if animation then
                                local sent = table.clone(data)

                                sent['\0'] = Shot.pack(CFrame.new(own.Position + Vector3.new(0, CAMERA, 0)))

                                send(item:Get('ObjectID'), enums:ToEnum('StartShooting'), {
                                    ['\1'] = sent,
                                    ['\2'] = enums:ToEnum(animation),
                                }, nil)
                            end

                            return
                        end

                        local eye = own.Position + Vector3.new(0, EYE, 0)
                        local level = Vector3.new(part.Position.X, eye.Y, part.Position.Z)
                        local aim = ((level - eye).Magnitude > 0.01 and {
                            (CFrame.lookAt(eye, level)),
                        } or {
                            (CFrame.new(eye)),
                        })[1]

                        Swing.send(send, enums, item, aim, part, false)
                    end,
                    position = function(part)
                        local position = part.Position

                        return {
                            x = position.X,
                            y = position.Y,
                            z = position.Z,
                        }
                    end,
                    spots = function()
                        local duel = spectate.CurrentDuelSubject
                        local map = (type(duel) == 'table' and type(duel.Map) == 'table' and {
                            duel.Map.Model,
                        } or {nil})[1]
                        local folder = (typeof(map) == 'Instance' and {
                            (map:FindFirstChild('Spawns')),
                        } or {nil})[1]
                        local spots = {}

                        if folder then
                            for _, part in folder:GetDescendants()do
                                if part:IsA('BasePart') then
                                    local position = part.Position

                                    table.insert(spots, {
                                        x = position.X,
                                        z = position.Z,
                                        floor = position.Y - part.Size.Y / 2,
                                    })
                                end
                            end
                        end

                        return spots
                    end,
                    place = function(part, pose)
                        local pitch = (pose.flying and {
                            (-math.pi / 2),
                        } or {
                            (math.pi / 2),
                        })[1]

                        part.CFrame = CFrame.new(pose.x, pose.y, pose.z) * CFrame.Angles(pitch, 0, 0)
                        part.AssemblyLinearVelocity = Vector3.zero
                    end,
                    random = function()
                        return random:NextNumber()
                    end,
                    heartbeat = Services.RunService.Heartbeat,
                    join = services and function(frame)
                        Desync.join(run, services, ORDER, function()
                            frame()

                            return nil
                        end, frame)
                    end or nil,
                }
            end

            local Counter = {}

            Counter.HOP_EVERY = HOP_EVERY
            Counter.CEILING = CEILING
            Counter.resolve = resolve

            function Counter.new()
                return {
                    life = false,
                    born = 0,
                    hopAt = 0,
                    equipAt = 0,
                    mode = nil,
                    last = nil,
                    blink = Blink.new(),
                    drop = nil,
                    nextDrop = 0,
                    anchor = nil,
                }
            end

            local function over(counter, forget)
                if forget then
                    counter.anchor = nil
                end

                counter.life = false
                counter.last = nil
                counter.drop = nil
                counter.nextDrop = 0

                Blink.reset(counter.blink)
            end
            local function allowed(opponent, settings)
                return (not settings.enemiesOnly or not opponent.ally) and (not settings.aliveOnly or opponent.health > 0)
            end
            local function first(list, priority, random)
                if #list == 0 then
                    return nil
                elseif priority == 'random' then
                    return list[math.clamp(math.floor(random() * #list) + 1, 1, #list)]
                end

                local best = list[1]

                for index = 2, #list do
                    local other = list[index]
                    local better = (priority == 'a to z' and {
                        (other.name < best.name),
                    } or {
                        (priority == 'z to a' and {
                            (other.name > best.name),
                        } or {
                            (other.health < best.health),
                        })[1],
                    })[1]

                    if better then
                        best = other
                    end
                end

                return best
            end
            local function choose(counter, opponents, settings, now, random)
                local bots, legits = {}, {}

                for _, opponent in opponents do
                    if opponent.health > 0 and opponent.inside and allowed(opponent, settings) then
                        table.insert((opponent.rager and {bots} or {legits})[1], opponent)
                    end
                end

                local priority = settings.legits.priority

                if settings.bots.on and #bots > 0 then
                    return first(bots, priority, random), settings.bots
                end

                local legit = settings.legits

                if legit.on and #legits > 0 and #legits <= legit.max and now - counter.born >= legit.delay then
                    return first(legits, priority, random), legit
                end

                return nil, nil
            end

            function Counter.step(counter, deps, settings)
                if not settings.active then
                    if counter.life then
                        deps.rescue(counter.anchor)
                    end

                    over(counter, true)

                    return nil
                end

                local fighter = deps.fighter()
                local root = (fighter and {
                    (deps.root()),
                } or {nil})[1]

                if not fighter or not root then
                    over(counter, true)

                    return 'counter: no character...'
                end
                if counter.mode ~= settings.mode then
                    if counter.life then
                        deps.rescue(counter.anchor)
                    end

                    over(counter, false)

                    counter.mode = settings.mode
                end

                local anchor = counter.anchor

                if not anchor then
                    anchor = deps.position(root)
                    counter.anchor = anchor
                end

                local from = anchor
                local opponents = deps.opponents(root)
                local now = deps.now()
                local item = fighter.EquippedItem
                local holding = isMelee(item)

                if settings.swapToMelee and not holding and now >= counter.equipAt then
                    for _, carried in fighter.Items do
                        if isMelee(carried) then
                            deps.equip(fighter, carried)

                            counter.equipAt = now + settings.swapEvery

                            break
                        end
                    end
                end

                local delta = (counter.last and {
                    (now - counter.last),
                } or {0})[1]

                counter.last = now

                if not counter.life then
                    counter.born = now

                    deps.prepare(root)
                end

                local name = NAMES[settings.mode] or settings.mode
                local status
                local target = nil
                local fresh = false

                if settings.mode == 'solix' or settings.mode == 'kicia' then
                    counter.life = true

                    local spots = (settings.mode == 'solix' and {
                        (deps.spots()),
                    } or {nil})[1]
                    local pose = Blink.pose(counter.blink, now, delta, from, spots, deps.random, settings.engine)

                    deps.place(root, pose)

                    status = string.format('%s: at %s...', tostring(name), tostring(short(pose.y)))
                else
                    local drop = counter.drop

                    if drop and now >= drop.ends then
                        counter.drop, counter.nextDrop = nil, drop.ends + drop.gap
                        drop = nil

                        deps.lift(root, from)
                    end
                    if drop then
                        for _, opponent in opponents do
                            if opponent.name == drop.name and opponent.health > 0 and opponent.inside and allowed(opponent, settings) then
                                target = opponent
                            end
                        end

                        if not target then
                            counter.drop, counter.nextDrop = nil, now

                            deps.lift(root, from)
                        end
                    elseif counter.life and now >= counter.nextDrop then
                        local chosen, group = choose(counter, opponents, settings, now, deps.random)

                        if chosen and group then
                            target = chosen
                            fresh = true
                            counter.drop = {
                                name = chosen.name,
                                ends = now + group.stay,
                                gap = group.gap,
                                lead = group.lead,
                            }
                        end
                    end

                    local dropping = counter.drop

                    if target and dropping then
                        deps.drop(root, target, dropping.lead)

                        if fresh then
                            deps.replicate(root)
                        end

                        status = string.format('%s: dropping on %s...', tostring(name), tostring(target.name))
                    else
                        if not counter.life then
                            counter.life = true
                            counter.hopAt = now + HOP_EVERY

                            deps.lift(root, from)
                        elseif deps.height(root) > CEILING then
                            deps.lift(root, from)
                        elseif now >= counter.hopAt then
                            counter.hopAt = now + HOP_EVERY

                            deps.hop(root)
                        end

                        deps.rise(root, settings.voidSpeed)

                        status = string.format('%s: climbing...', tostring(name))
                    end
                end
                if holding and now >= (item._equip_cooldown or 0) then
                    local aim = target

                    if not aim then
                        for _, opponent in opponents do
                            if allowed(opponent, settings) and (not aim or opponent.distance < aim.distance) then
                                aim = opponent
                            end
                        end
                    end
                    if aim then
                        deps.swing(item, aim.part)
                    end
                end

                return status
            end
            function Counter.loop(run, settings, deps, report)
                local counter = Counter.new()
                local frame = function()
                    local status = Counter.step(counter, deps, settings())

                    if report then
                        report(status)
                    end
                end
                local join = deps.join

                if join then
                    join(frame)
                else
                    run:connect(assert(deps.heartbeat, 'the counter needs a frame signal'), frame)
                end
            end

            Counter.rescue = toSpawn

            return table.freeze(Counter)
        end

        function __ANTIBRAIN_MODULES.K()
            local v = __ANTIBRAIN_MODULES.cache.K

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.K = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Blink = __ANTIBRAIN_MODULES.D()
            local CounterSystem = __ANTIBRAIN_MODULES.K()
            local RageReport = __ANTIBRAIN_MODULES.n()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Counter = {}

            Counter.ENGINE = Blink.DEFAULTS
            Counter.rescue = CounterSystem.rescue

            function Counter.start(run, settings, services, dependencies)
                local shown = false

                run:add(function()
                    if shown then
                        RageReport.set(services, nil)
                    end
                end)
                CounterSystem.loop(run, settings, dependencies or CounterSystem.resolve(run, services), function(
                    status
                )
                    if status ~= nil then
                        shown = true

                        RageReport.set(services, {
                            status = status,
                            target = nil,
                        })
                    elseif shown then
                        shown = false

                        RageReport.set(services, nil)
                    end
                end)
            end

            return table.freeze(Counter)
        end

        function __ANTIBRAIN_MODULES.L()
            local v = __ANTIBRAIN_MODULES.cache.L

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.L = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Counter = __ANTIBRAIN_MODULES.L()

            __ANTIBRAIN_MODULES.g()

            local ENGINES = table.freeze({
                ['ue counter'] = 'ue',
                ['kicia counter'] = 'kicia',
                ['solix counter'] = 'solix',
            })
            local CounterControls = {}

            function CounterControls.build(box, ui)
                local counter = box:toggle(ui.id('counter'), {
                    text = 'enabled',
                    default = false,
                    tooltip = 
[[throws your character far out of the map and drops onto enemies for a split second at a time, swinging your melee. while it is on the ragebot rests; use it against ragebots]],
                })
                local key = counter:keybind(ui.id('counter-key'), {
                    text = 'counter',
                })
                local options = box:dependent(function()
                    return counter.value
                end)
                local engine = options:dropdown(ui.id('counter-engine'), {
                    text = 'engine',
                    values = {
                        'ue counter',
                        'kicia counter',
                        'solix counter',
                    },
                    default = 'ue counter',
                    tooltip = 
[[ue climbs out of the map and drops onto enemies; kicia and solix blink between the sky and under your spawn]],
                })
                local drops = options:dependent(function()
                    return engine.value == 'ue counter'
                end)
                local attackBots = drops:toggle(ui.id('counter-bots'), {
                    text = 'attack ragebots',
                    default = true,
                    tooltip = 
[[drops onto players using a ragebot when they come into the map]],
                })
                local attackLegits = drops:toggle(ui.id('counter-legits'), {
                    text = 'attack legits',
                    default = true,
                    tooltip = 
[[also drops onto normal players, three seconds after you spawn, while only one is alive]],
                })

                box:button({
                    text = 'get me out of the void',
                    callback = Counter.rescue,
                    tooltip = 
[[puts you back above your spawn, should you ever be left stuck far out of the map]],
                })

                local settings = {
                    active = false,
                    mode = 'ue',
                    enemiesOnly = true,
                    aliveOnly = true,
                    swapToMelee = true,
                    swapEvery = 0.3,
                    voidSpeed = 3000,
                    engine = Counter.ENGINE,
                    bots = {
                        on = true,
                        stay = 0.35,
                        gap = 0.5,
                        lead = 6,
                    },
                    legits = {
                        on = true,
                        stay = 0.35,
                        gap = 0.5,
                        lead = 6,
                        delay = 3,
                        max = 1,
                        priority = 'lowest health',
                    },
                }

                return {
                    counter = counter,
                    settings = function()
                        settings.active = key:active()
                        settings.mode = ENGINES[engine.value or 'ue counter'] or 'ue'
                        settings.bots.on, settings.legits.on = attackBots.value, attackLegits.value

                        return settings
                    end,
                }
            end

            return table.freeze(CounterControls)
        end

        function __ANTIBRAIN_MODULES.M()
            local v = __ANTIBRAIN_MODULES.cache.M

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.M = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local STEP = 0.05
            local Poll = {}

            function Poll.waitFor(condition, timeout, interval, clock, pause)
                local step = interval or STEP

                assert(step > 0 and step < math.huge, 'Poll interval must be finite and positive')
                assert(timeout >= 0 and timeout < math.huge, 'Poll timeout must be finite and nonnegative')

                local now = clock or os.clock
                local wait = pause or function(seconds)
                    task.wait(seconds)
                end
                local deadline = now() + timeout

                while not condition() do
                    local remaining = deadline - now()

                    if remaining <= 0 then
                        return false
                    end

                    wait(math.min(step, remaining))
                end

                return true
            end
            function Poll.backoff(first, most)
                local next = first

                return function()
                    local wait = next

                    next = math.min(next * 2, most)

                    return wait
                end
            end
            function Poll.retry(interval, patience)
                return {
                    interval = interval,
                    patience = patience,
                    nextAt = 0,
                    since = nil,
                }
            end
            function Poll.due(retry, now)
                return now >= retry.nextAt
            end
            function Poll.failed(retry, now)
                retry.nextAt = now + retry.interval

                local since = retry.since or now

                retry.since = since

                return now - since >= retry.patience
            end
            function Poll.reset(retry)
                retry.nextAt, retry.since = 0, nil
            end

            return table.freeze(Poll)
        end

        function __ANTIBRAIN_MODULES.N()
            local v = __ANTIBRAIN_MODULES.cache.N

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.N = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.g()

            local Poll = __ANTIBRAIN_MODULES.N()

            __ANTIBRAIN_MODULES.c()

            local FIRST_WAIT, LONGEST_WAIT, NOTICE_SECONDS, GIVE_UP_SECONDS = 0.25, 2, 8, 30
            local Feature = {}

            local function launch(context, owner, name, start, giveUp)
                local lastFailure = 'Initialization did not finish'
                local startedAt = os.clock()
                local finished = false
                local watchdog = owner:child()

                local function say(message)
                    local failure = Failure.capture(context.ui.notify, message)

                    if failure then
                        pcall(context.log, string.format('Feature notification failed: %s', tostring(failure)))
                    end
                end
                local function timeout()
                    if finished or owner.closed then
                        return
                    end

                    finished = true

                    owner:close()
                    pcall(context.log, string.format('%s failed to start after %s seconds: %s', tostring(name), tostring(GIVE_UP_SECONDS), tostring(lastFailure)))
                    say((giveUp and {
                        string.format(
[[%s failed to start; see the console and try enabling it again]], tostring(name)),
                    } or {
                        string.format(
[[%s failed to start; see the console and restart the hub to try again]], tostring(name)),
                    })[1])

                    if giveUp then
                        local failure = Failure.capture(giveUp)

                        if failure then
                            pcall(context.log, failure)
                        end
                    end
                end

                watchdog:delay(GIVE_UP_SECONDS, timeout)

                local function attempt()
                    local run = owner:child()
                    local failure = Failure.capture(start, run)

                    if owner.closed then
                        return false
                    end
                    if not failure then
                        if os.clock() - startedAt >= GIVE_UP_SECONDS then
                            timeout()

                            return false
                        end

                        finished = true

                        watchdog:close()

                        return true
                    end

                    run:close()

                    lastFailure = failure

                    return false
                end
                local function retry()
                    local nextWait = Poll.backoff(FIRST_WAIT, LONGEST_WAIT)
                    local waited, told = 0, false

                    while true do
                        local __DARKLUA_CONTINUE_38 = false

                        repeat
                            if owner.closed then
                                return
                            end

                            local remaining = GIVE_UP_SECONDS - math.max(waited, os.clock() - startedAt)

                            if remaining <= 0 then
                                timeout()

                                return
                            end

                            local seconds = math.min(nextWait(), remaining)

                            context.wait(seconds)

                            waited = waited + seconds

                            if owner.closed then
                                return
                            elseif math.max(waited, os.clock() - startedAt) >= GIVE_UP_SECONDS then
                                __DARKLUA_CONTINUE_38 = true

                                break
                            elseif attempt() then
                                if told then
                                    say(string.format('%s started', tostring(name)))
                                end

                                return
                            end
                            if not told and waited >= NOTICE_SECONDS then
                                told = true

                                pcall(context.log, string.format('%s has not started yet and keeps trying: %s', tostring(name), tostring(lastFailure)))
                                say(string.format('%s is waiting for the game', tostring(name)))
                            end

                            __DARKLUA_CONTINUE_38 = true
                        until true

                        if not __DARKLUA_CONTINUE_38 then
                            break
                        end
                    end
                end

                owner:spawn(function()
                    if not attempt() and not owner.closed then
                        owner:defer(retry)
                    end
                end)
            end
            local function with(start, ...)
                local args = table.pack(...)

                if args.n == 0 then
                    return start
                end

                return function(run)
                    (start)(run, table.unpack(args, 1, args.n))
                end
            end

            function Feature.bind(context, toggle, start, ...)
                local begin = with(start, ...)
                local current = nil
                local running = false

                local function stop()
                    local owner = current

                    current = nil

                    if owner then
                        owner:close()
                    end
                end
                local function apply(enabled)
                    if enabled == running or context.scope.closed then
                        return
                    end

                    running = enabled

                    stop()

                    if not running or context.scope.closed or current then
                        return
                    end

                    local owner = context.scope:child(toggle.text)

                    current = owner

                    launch(context, owner, toggle.text, begin, function()
                        if current ~= owner or context.scope.closed then
                            return
                        end

                        current = nil
                        running = false

                        toggle:set(false)
                    end)
                end

                context.scope:add(toggle:onChanged(apply))
                apply(toggle.value)
            end
            function Feature.always(context, name, start, ...)
                launch(context, context.scope:child(name), name, with(start, ...))
            end

            return table.freeze(Feature)
        end

        function __ANTIBRAIN_MODULES.O()
            local v = __ANTIBRAIN_MODULES.cache.O

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.O = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Poll = __ANTIBRAIN_MODULES.N()

            __ANTIBRAIN_MODULES.c()

            local REPOSITORY = 'https://raw.githubusercontent.com/bluescan/proggyfonts/'
            local COMMIT = '139ec08a38096161291792313ef5803fc4f0e37b'
            local FILE = 'ProggyOriginal/ProggyClean.ttf'
            local SMALLEST = 1024
            local registered = {}
            local body = nil
            local fetching = nil
            local DOWNLOAD_WAIT = 20

            local function plausible(text)
                return #text >= SMALLEST and text:sub(1, 1) ~= '<'
            end
            local function download()
                local held = body

                if held then
                    return held
                end
                if fetching then
                    if coroutine.status(fetching) == 'dead' then
                        fetching = nil
                    else
                        Poll.waitFor(function()
                            local worker = fetching

                            return not worker or coroutine.status(worker) == 'dead'
                        end, DOWNLOAD_WAIT)

                        if body then
                            return body
                        end

                        local worker = fetching

                        if worker and coroutine.status(worker) == 'dead' then
                            fetching = nil
                        else
                            error('ProggyClean could not be downloaded', 0)
                        end
                    end
                end

                fetching = coroutine.running()

                local ok, result = pcall(function()
                    local response = request({
                        Url = string.format('%s%s/%s', tostring(REPOSITORY), tostring(COMMIT), tostring(FILE)),
                        Method = 'GET',
                    })

                    if not response.Success then
                        error(string.format('ProggyClean could not be downloaded: HTTP %s', tostring(response.StatusCode)), 0)
                    end
                    if type(response.Body) ~= 'string' or not plausible(response.Body) then
                        error(
[[ProggyClean could not be downloaded: the answer holds no font]], 0)
                    end

                    return response.Body
                end)

                fetching = nil

                if not ok then
                    error(result, 0)
                end

                body = result

                return result
            end

            local Fonts = {}

            Fonts.SIZE = 13

            function Fonts.fallback()
                return Drawing.Fonts.UI
            end
            function Fonts.load(size)
                local made = registered[size]

                if made then
                    return made
                end

                local bytes = download()
                local ready = registered[size]

                if ready then
                    return ready
                end

                local font = DrawFont.Register(bytes, {PixelSize = size})

                registered[size] = font

                return font
            end
            function Fonts.follow(run, told)
                local font = Fonts.fallback()

                run:spawn(function()
                    local nextWait = Poll.backoff(5, 60)
                    local said = false

                    while not run.closed do
                        local failure = Failure.capture(function()
                            font = Fonts.load(Fonts.SIZE)
                        end)

                        if not failure then
                            return
                        end
                        if not said then
                            said = true

                            told(failure)
                        end

                        task.wait(nextWait())
                    end
                end)

                return function()
                    return font
                end
            end

            return table.freeze(Fonts)
        end

        function __ANTIBRAIN_MODULES.P()
            local v = __ANTIBRAIN_MODULES.cache.P

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.P = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Fonts = __ANTIBRAIN_MODULES.P()
            local FovCircle = __ANTIBRAIN_MODULES.t()
            local LINE_GAP = 2
            local Indicator = {}

            Indicator.EMPTY = '"out of ammo" if empty'

            local piece = function(settings, color, value)
                local text = (settings.style == 'upper' and {
                    (string.upper(tostring(value))),
                } or {
                    (string.lower(tostring(value))),
                })[1]

                return {
                    text = text,
                    color = color,
                }
            end

            Indicator.manipulated = function(settings, manipulated)
                if not (manipulated and settings.manipulated) then
                    return {}
                end

                return {
                    {
                        piece(settings, settings.manipulatedColor, 'manipulated'),
                    },
                }
            end
            Indicator.ragebot = function(settings, status)
                if not settings.ragebot then
                    return {}
                end

                local style = settings.ragebotStyle
                local line = {}

                if style.text then
                    table.insert(line, piece(settings, settings.ragebotTextColor, 'ragebot'))
                end
                if style.status then
                    if style.text then
                        table.insert(line, piece(settings, settings.ragebotTextColor, ': '))
                    end

                    table.insert(line, piece(settings, settings.ragebotStatusColor, status or '?'))
                end

                return #line > 0 and {line} or {}
            end
            Indicator.ammo = function(settings, item)
                if not settings.ammo or type(item) ~= 'table' or not item.ViewModel or type(item.Info) ~= 'table' or item.Info.Type ~= 'Gun' or type(item.Data) ~= 'table' then
                    return {}
                end

                local maxAmmo, reserve, ammo = item.Info.MaxAmmo, item.Data.AmmoReserve, item.Data.Ammo

                for _, count in {maxAmmo, reserve, ammo}do
                    if type(count) ~= 'number' or count == math.huge then
                        return {}
                    end
                end

                local style, line = settings.ammoStyle, {}

                if style[Indicator.EMPTY] and ammo == 0 and reserve == 0 then
                    table.insert(line, piece(settings, settings.emptyColor, 'out of ammo'))
                else
                    local function add(color, value)
                        if #line > 0 then
                            table.insert(line, piece(settings, settings.dividerColor, '/'))
                        end

                        table.insert(line, piece(settings, color, value))
                    end

                    if style.ammo then
                        add(settings.ammoColor, ammo)
                    end
                    if style['max ammo'] then
                        add(settings.maxAmmoColor, maxAmmo)
                    end
                    if style.reserve then
                        add(settings.reserveColor, reserve)
                    end
                end

                return #line > 0 and {line} or {}
            end

            function Indicator.new()
                return {
                    texts = {},
                    at = Vector2.zero,
                }
            end
            function Indicator.destroy(indicator)
                for _, text in indicator.texts do
                    pcall(text.Remove, text)
                end

                table.clear(indicator.texts)
            end

            local function textAt(indicator, index)
                local held = indicator.texts[index]

                if held then
                    return held
                end

                local text = Drawing.new('Text')

                indicator.texts[index] = text
                text.Center, text.Outline, text.OutlineColor = false, true, Color3.new(0, 0, 0)
                text.Size, text.ZIndex = Fonts.SIZE, 10

                return text
            end

            Indicator.draw = function(indicator, settings, lines, places, font)
                indicator.at = indicator.at:Lerp(FovCircle.anchored(settings.anchors, places) or places.center, settings.lerp)

                local at = indicator.at + settings.offset
                local used = 0
                local y = at.Y

                for _, line in lines do
                    local first, width = used + 1, 0

                    for _, part in line do
                        used = used + 1

                        local text = textAt(indicator, used)

                        text.Font, text.Text, text.Color = font, part.text, part.color
                        text.Visible = true
                        width = width + text.TextBounds.X
                    end

                    local x = at.X - width / 2

                    for index = first, used do
                        local text = indicator.texts[index]

                        text.Position = Vector2.new(x, y)
                        x = x + text.TextBounds.X
                    end

                    y = y + (Fonts.SIZE + LINE_GAP)
                end

                for index = used + 1, #indicator.texts do
                    indicator.texts[index].Visible = false
                end
            end

            return table.freeze(Indicator)
        end

        function __ANTIBRAIN_MODULES.Q()
            local v = __ANTIBRAIN_MODULES.cache.Q

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.Q = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Aiming = __ANTIBRAIN_MODULES.s()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Fonts = __ANTIBRAIN_MODULES.P()
            local FovCircle = __ANTIBRAIN_MODULES.t()
            local Indicator = __ANTIBRAIN_MODULES.Q()
            local Modules = __ANTIBRAIN_MODULES.l()
            local RageReport = __ANTIBRAIN_MODULES.n()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Services = __ANTIBRAIN_MODULES.k()
            local Indicators = {}

            Indicators.EMPTY = Indicator.EMPTY

            function Indicators.start(run, settings, services, log)
                local fighters = Modules.controller('FighterController')
                local indicator = Indicator.new()
                local font = Fonts.follow(run, function(failure)
                    log(string.format(
[[The indicator font is not available, so the executor's UI font is used until it is: %s]], tostring(Failure.summary(failure))))
                end)

                run:add(function()
                    Indicator.destroy(indicator)
                end)

                local places = {
                    center = Vector2.zero,
                }

                run:connect(Services.RunService.Heartbeat, function()
                    local camera = Services.Workspace.CurrentCamera

                    if not camera then
                        return
                    end

                    local options = settings()
                    local fighter = fighters.LocalFighter
                    local report = RageReport.get(services)
                    local lines

                    places.center, places.target = camera.ViewportSize / 2, nil

                    if report then
                        lines = Indicator.ragebot(options, report.status)

                        if report.target then
                            local point, visible = camera:WorldToViewportPoint(report.target.Position)

                            places.target = (visible and {
                                (Vector2.new(point.X, point.Y)),
                            } or {nil})[1]
                        end
                    else
                        local selection = Aiming.latest(services)

                        lines = Indicator.manipulated(options, selection ~= nil and selection.manipulated)
                        places.target = (selection and {
                            selection.focus,
                        } or {nil})[1]
                    end

                    local equipped = (type(fighter) == 'table' and {
                        fighter.EquippedItem,
                    } or {nil})[1]

                    for _, line in Indicator.ammo(options, equipped)do
                        table.insert(lines, line)
                    end

                    places.barrel = (options.anchors['position on barrel'] and type(fighter) == 'table' and {
                        (FovCircle.barrel(fighter, camera)),
                    } or {nil})[1]

                    Indicator.draw(indicator, options, lines, places, font())
                end)
            end

            return table.freeze(Indicators)
        end

        function __ANTIBRAIN_MODULES.R()
            local v = __ANTIBRAIN_MODULES.cache.R

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.R = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.c()

            local LEVEL = 3
            local CAMERA, MUZZLE, HIT_PART, HIT_OFFSET = '\0', '\1', '\2', '\3'
            local isCameraData = function(value)
                return type(value) == 'table' and typeof(rawget(value, CAMERA)) == 'CFrame'
            end
            local Visualize = {}

            function Visualize.start(run, active, part, deps)
                local tracers = deps.tracers
                local environment = getfenv(tracers)
                local slot = nil
                local redirect = function()
                    if not slot or not isCameraData(deps.getstack(LEVEL, slot)) then
                        slot = nil

                        for index, value in deps.getstack(LEVEL)do
                            if isCameraData(value) then
                                slot = index

                                break
                            end
                        end
                    end

                    local target = part()

                    if slot and target then
                        local data = deps.getstack(LEVEL, slot)

                        data[CAMERA] = CFrame.new(data[CAMERA].Position, target.Position)
                        data[MUZZLE] = data[CAMERA]
                        data[HIT_PART] = nil
                        data[HIT_OFFSET] = nil
                    end
                end
                local char = deps.cclosure(function(...)
                    if select(1, ...) == 0 and active() then
                        pcall(redirect)
                    end

                    return utf8.char(...)
                end)
                local hooked = setmetatable({
                    utf8 = setmetatable({char = char}, {__index = utf8}),
                }, {__index = environment})

                setfenv(tracers, hooked)
                run:add(function()
                    if getfenv(tracers) == hooked then
                        setfenv(tracers, environment)
                    end
                end)
            end

            return table.freeze(Visualize)
        end

        function __ANTIBRAIN_MODULES.S()
            local v = __ANTIBRAIN_MODULES.cache.S

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.S = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Aiming = __ANTIBRAIN_MODULES.s()
            local Failure = __ANTIBRAIN_MODULES.a()
            local FovCircle = __ANTIBRAIN_MODULES.t()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Shot = __ANTIBRAIN_MODULES.G()

            __ANTIBRAIN_MODULES.r()

            local Visualize = __ANTIBRAIN_MODULES.S()
            local SilentAim = {}

            function SilentAim.start(run, settings, log, services)
                local access = Hooks.executor()
                local target = nil
                local reported = false
                local hooked = nil
                local override = nil

                local function unhook()
                    if hooked and rawget(hooked, 'GetCameraData') == override then
                        rawset(hooked, 'GetCameraData', nil)
                    end

                    hooked, override = nil, nil
                end
                local function hook(fighter)
                    unhook()

                    local original = fighter.GetCameraData
                    local redirect = function(self, ...)
                        local aimed = target

                        if select('#', ...) ~= 0 or not aimed then
                            return original(self, ...)
                        end

                        local options = settings()

                        if options.hitChance < math.random(0, 99) or not options.active then
                            return original(self, ...)
                        end

                        local results = table.pack(original(self, ...))
                        local failure = Failure.capture(Shot.aim, results[1], aimed.part, aimed.manipulation)

                        if failure and not reported then
                            reported = true

                            log(string.format(
[[Silent aim could not redirect a shot; later errors are not reported: %s]], tostring(failure)))
                        end

                        return table.unpack(results, 1, results.n)
                    end

                    access.disguise(redirect, original)
                    rawset(fighter, 'GetCameraData', redirect)

                    hooked, override = fighter, redirect
                end

                run:add(unhook)

                local tracers = Modules.client({
                    'ItemTypes',
                    'Gun',
                })._LocalTracers

                assert(type(tracers) == 'function', 'RIVALS Gun._LocalTracers is unavailable')

                local executorGetstack = getstack

                Visualize.start(run, function()
                    local options = settings()

                    return options.visualize and options.active
                end, function()
                    return (target and {
                        target.part,
                    } or {nil})[1]
                end, {
                    tracers = tracers,
                    getstack = executorGetstack,
                    cclosure = access.cclosure,
                })

                local fov = FovCircle.new(gethui())

                run:add(function()
                    FovCircle.destroy(fov)
                end)

                local places = {
                    center = Vector2.zero,
                }

                Aiming.join(run, services, 'silent', settings, function(
                    selection,
                    camera,
                    fighter
                )
                    if type(fighter) == 'table' and fighter ~= hooked then
                        hook(fighter)
                    end

                    target = selection.silent

                    local options = settings()

                    places.center = camera.ViewportSize / 2
                    places.target = selection.focus
                    places.barrel = (options.look.anchors['position on barrel'] and type(fighter) == 'table' and {
                        (FovCircle.barrel(fighter, camera)),
                    } or {nil})[1]

                    FovCircle.draw(fov, options.look, places, tick())
                end)
                run:add(function()
                    target = nil
                end)
            end

            return table.freeze(SilentAim)
        end

        function __ANTIBRAIN_MODULES.T()
            local v = __ANTIBRAIN_MODULES.cache.T

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.T = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.g()
            __ANTIBRAIN_MODULES.T()

            local FovControls = {}

            FovControls.ANCHORS = table.freeze({
                'position on target',
                'position on barrel',
            })

            function FovControls.look()
                return {
                    show = false,
                    outline = false,
                    filled = false,
                    radius = 100,
                    colors = {},
                    transparencies = {},
                    outlineColors = {},
                    outlineTransparencies = {},
                    fillColors = {},
                    fillTransparencies = {},
                    lerp = 1,
                    rotation = 0,
                    moving = false,
                    speed = 1,
                    anchors = {},
                }
            end

            local function gradient(ui, toggle, id, color, transparency)
                local pickers = {}

                for index, place in {
                    'start',
                    'middle',
                    'end',
                }do
                    table.insert(pickers, toggle:color(ui.id(string.format('%s-%s', tostring(id), tostring(index))), {
                        title = string.format('color %s', tostring(place)),
                        default = color,
                        transparency = transparency,
                    }))
                end

                return function(colors, transparencies)
                    for index, picker in pickers do
                        colors[index], transparencies[index] = picker.value, picker.transparency
                    end
                end
            end

            function FovControls.build(box, ui, prefix)
                local show = box:toggle(ui.id(string.format('%s-show-fov', tostring(prefix))), {
                    text = 'show fov',
                    default = false,
                })
                local readColors = gradient(ui, show, string.format('%s-fov-color', tostring(prefix)), Color3.new(1, 1, 1), 0)
                local fov = box:dependent(function()
                    return show.value
                end)
                local outline = fov:toggle(ui.id(string.format('%s-fov-outline', tostring(prefix))), {
                    text = 'outline',
                    default = false,
                })
                local readOutline = gradient(ui, outline, string.format('%s-fov-outline-color', tostring(prefix)), Color3.new(0, 0, 0), 0.7)
                local fill = fov:toggle(ui.id(string.format('%s-fov-fill', tostring(prefix))), {
                    text = 'fill',
                    default = false,
                })
                local readFill = gradient(ui, fill, string.format('%s-fov-fill-color', tostring(prefix)), Color3.new(0, 0, 0), 0.7)
                local lerp = fov:slider(ui.id(string.format('%s-fov-lerp', tostring(prefix))), {
                    text = 'lerp',
                    default = 1,
                    min = 0.01,
                    max = 1,
                    rounding = 2,
                    suffix = 'x',
                })
                local moving = fov:toggle(ui.id(string.format('%s-fov-moving', tostring(prefix))), {
                    text = 'moving rotation',
                    default = false,
                })
                local rotation = fov:slider(ui.id(string.format('%s-fov-rotation', tostring(prefix))), {
                    text = 'rotation',
                    default = 0,
                    min = 0,
                    max = 360,
                    rounding = 0,
                    increment = 5,
                    suffix = '\u{b0}',
                })
                local speed = rotation:slider(ui.id(string.format('%s-fov-rotation-speed', tostring(prefix))), {
                    text = 'speed',
                    default = 1,
                    min = 0.1,
                    max = 10,
                    rounding = 1,
                    suffix = 'rps',
                    tooltip = 'only if moving rotation is on',
                })
                local anchors = fov:multiDropdown(ui.id(string.format('%s-fov-position', tostring(prefix))), {
                    text = 'fov settings',
                    values = table.clone(FovControls.ANCHORS),
                    allowNull = true,
                })

                return function(look, radius)
                    look.show, look.outline, look.filled = show.value, outline.value, fill.value
                    look.radius, look.lerp, look.anchors = radius, lerp.value, anchors.value
                    look.rotation, look.moving, look.speed = rotation.value, moving.value, speed.value

                    readColors(look.colors, look.transparencies)
                    readOutline(look.outlineColors, look.outlineTransparencies)
                    readFill(look.fillColors, look.fillTransparencies)
                end
            end

            return table.freeze(FovControls)
        end

        function __ANTIBRAIN_MODULES.U()
            local v = __ANTIBRAIN_MODULES.cache.U

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.U = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Fighter = __ANTIBRAIN_MODULES.o()

            __ANTIBRAIN_MODULES.c()

            local VOID = 1000000
            local Targets = {}

            function Targets.priority(settings, notify, scope)
                return {
                    players = {},
                    notify = notify,
                    settings = settings,
                    scope = scope,
                    current = nil,
                }
            end
            function Targets.prioritize(priority, player, me)
                if player == me or table.find(priority.players, player) then
                    return
                end

                table.insert(priority.players, player)

                local leaving = player.AncestryChanged:Once(function()
                    local at = table.find(priority.players, player)

                    if at then
                        table.remove(priority.players, at)
                    end
                end)
                local owner = priority.scope

                if owner and leaving then
                    owner:add(function()
                        leaving:Disconnect()
                    end)
                end
                if priority.settings().notify then
                    priority.notify(string.format('Added %s to ragebot priority', tostring(player.Name)))
                end
            end

            local function candidate(player, dueler, me)
                if player == me or type(dueler) ~= 'table' or dueler._is_ally then
                    return nil
                end

                local character = player.Character
                local humanoid = (character and {
                    (character:FindFirstChildOfClass('Humanoid')),
                } or {nil})[1]

                if not character or not humanoid or not (humanoid.Health > 0) then
                    return nil
                end

                local root = character:FindFirstChild('HumanoidRootPart')
                local distance = (root and root:IsA('BasePart') and {
                    root.Position.Magnitude,
                } or {
                    math.huge,
                })[1]

                if not (distance < VOID) then
                    return nil
                end

                local head = character:FindFirstChild('HitboxHead')
                local fighter = dueler.ClientFighter

                if not head or not head:IsA('BasePart') or not fighter or Fighter.invincible(fighter) then
                    return nil
                end
                if Fighter.deflecting(fighter) then
                    return nil
                end
                if not (head.Position.Magnitude < VOID) then
                    return nil
                end

                return {
                    part = head,
                    character = character,
                    fighter = fighter,
                    name = player.Name,
                    health = humanoid.Health,
                }
            end

            Targets.candidate = candidate

            function Targets.pick(priority, duelers, me, reachable)
                local options = priority.settings()
                local checked = {}
                local rejected = {}

                local function available(player, dueler)
                    if rejected[player] then
                        return nil
                    end

                    local target = checked[player] or candidate(player, dueler, me)

                    if target and (not reachable or checked[player] or reachable(target)) then
                        checked[player] = target

                        return target
                    end

                    rejected[player] = true

                    return nil
                end

                if options.autoPrioritize then
                    if options.join['voided players'] then
                        for player, dueler in duelers do
                            local character = player.Character
                            local root = (character and {
                                (character:FindFirstChild('HumanoidRootPart')),
                            } or {nil})[1]

                            if player ~= me and not dueler._is_ally and root and root:IsA('BasePart') and root.Position.Magnitude > VOID then
                                Targets.prioritize(priority, player, me)
                            end
                        end
                    end

                    for _, player in priority.players do
                        local dueler = duelers[player]
                        local target = (dueler and {
                            (available(player, dueler)),
                        } or {nil})[1]

                        if target then
                            priority.current = player

                            return target
                        end
                    end
                end

                local current = priority.current
                local currentDueler = (current and {
                    duelers[current],
                } or {nil})[1]
                local held = (current and currentDueler and {
                    (available(current, currentDueler)),
                } or {nil})[1]

                if held then
                    return held
                end

                local best = nil
                local selected = nil

                for player, dueler in duelers do
                    local target = available(player, dueler)

                    if target and (not best or target.health < best.health or (target.health == best.health and target.name < best.name)) then
                        best, selected = target, player
                    end
                end

                priority.current = selected

                return best
            end

            return table.freeze(Targets)
        end

        function __ANTIBRAIN_MODULES.V()
            local v = __ANTIBRAIN_MODULES.cache.V

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.V = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local Swing = __ANTIBRAIN_MODULES.H()
            local Targets = __ANTIBRAIN_MODULES.V()
            local GAP = 2
            local CONE = math.cos(math.rad(60))

            local function resolve()
                local me = Modules.player()
                local spectate = Modules.controller('SpectateController')
                local startShooting = Modules.client({
                    'ItemTypes',
                    'Melee',
                }).StartShooting

                assert(type(startShooting) == 'function', 'RIVALS Melee.StartShooting is unavailable')

                local function eye()
                    local camera = Services.Workspace.CurrentCamera

                    return (camera and {
                        camera.CFrame.Position,
                    } or {nil})[1]
                end

                return {
                    startShooting = startShooting,
                    access = Hooks.executor(),
                    ready = function(item)
                        return not item:IsEquipping() and tick() >= item._attack_cooldown and (not item.Info.NeedsAmmoToAttack or item:Get('Ammo') > 0)
                    end,
                    pick = function(item, range)
                        local character = me.Character
                        local own = (character and {
                            (character:FindFirstChild('HumanoidRootPart')),
                        } or {nil})[1]
                        local camera = Services.Workspace.CurrentCamera
                        local duel = spectate.CurrentDuelSubject
                        local duelers = (type(duel) == 'table' and {
                            duel._duelers_by_player,
                        } or {nil})[1]

                        if not own or not own:IsA('BasePart') or not camera or type(duelers) ~= 'table' then
                            return nil
                        end
                        if type(duel.Data) ~= 'table' or duel.Data.Status ~= 'RoundStarted' then
                            return nil
                        end

                        local native = tonumber(item.Info.AttackReach) or 0
                        local from, look = camera.CFrame.Position, camera.CFrame.LookVector
                        local best, bestDot = nil, CONE

                        for player, dueler in duelers do
                            local target = Targets.candidate(player, dueler, me)

                            if target then
                                local position = target.part.Position
                                local distance = (position - own.Position).Magnitude
                                local dot = (position - from).Unit:Dot(look)

                                if distance > native and distance <= range and dot >= bestDot then
                                    best, bestDot = target.part, dot
                                end
                            end
                        end

                        return best
                    end,
                    aim = function(cameraData, head)
                        local position = head.Position
                        local from = eye() or position
                        local toward = position - from
                        local origin = (toward.Magnitude > GAP and {
                            (position - toward.Unit * GAP),
                        } or {from})[1]
                        local aim = CFrame.lookAt(origin, position)

                        for key, value in Swing.data(aim, head)do
                            cameraData[key] = value
                        end
                    end,
                }
            end

            local MeleeReach = {}

            function MeleeReach.start(run, settings, dependencies)
                local deps = dependencies or resolve()

                Hooks.hook(run, deps.access, deps.startShooting, function(
                    original
                )
                    return function(item, forced, ...)
                        local options = settings()

                        if forced or not options.active or not item.ClientFighter.IsLocalPlayer or not deps.ready(item) then
                            return original(item, forced, ...)
                        end

                        local head = deps.pick(item, options.reach)
                        local results = table.pack(original(item, forced, ...))

                        if head and results[1] == true and type(results[3]) == 'table' then
                            deps.aim(results[3], head)
                        end

                        return table.unpack(results, 1, results.n)
                    end
                end)
            end

            return table.freeze(MeleeReach)
        end

        function __ANTIBRAIN_MODULES.W()
            local v = __ANTIBRAIN_MODULES.cache.W

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.W = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Origins = {}
            local TRACK_REACH = 16

            function Origins.gun(target, preferred, eye, held, clear)
                if held and (held.Position - target).Magnitude <= TRACK_REACH and clear(held.Position + eye, target) then
                    return held
                end
                if clear(preferred + eye, target) then
                    return CFrame.new(preferred)
                end

                for _, offset in {
                    Vector3.new(3, 1, 0),
                    Vector3.new(-3, 1, 0),
                    Vector3.new(0, 1, 3),
                    Vector3.new(0, 1, -3),
                    Vector3.new(3, 3, 3),
                    Vector3.new(-3, 3, -3),
                }do
                    local position = target + offset

                    if clear(position + eye, target) then
                        return CFrame.new(position)
                    end
                end

                return nil
            end

            return table.freeze(Origins)
        end

        function __ANTIBRAIN_MODULES.X()
            local v = __ANTIBRAIN_MODULES.cache.X

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.X = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local CameraHold = __ANTIBRAIN_MODULES.x()
            local Origins = __ANTIBRAIN_MODULES.X()
            local Pose = __ANTIBRAIN_MODULES.y()
            local Shot = __ANTIBRAIN_MODULES.G()
            local Swing = __ANTIBRAIN_MODULES.H()

            __ANTIBRAIN_MODULES.V()

            local SETTLE = 0.05
            local EYE, CROUCHED_EYE = 1.75, 0.25

            local function shield(fighter)
                local item = fighter.EquippedItem

                if type(item) == 'table' and item.Name == 'Riot Shield' then
                    return true, true
                end

                for _, carried in fighter.Items do
                    if carried.Name == 'Riot Shield' then
                        return true, false
                    end
                end

                return false, false
            end
            local function beyondShield(target, reach)
                local has, held = shield(target.fighter)

                if not has then
                    return nil
                end

                local facing = CFrame.new(target.part.Position) * target.fighter:GetRotationCFrame()

                return (facing * CFrame.new(0, 0, (held and {reach} or {
                    (-reach),
                })[1])).Position
            end
            local function around(target, reach)
                local position = target.part.Position
                local from = beyondShield(target, reach) or position + Random.new():NextUnitVector() * reach

                return CFrame.new(from, position)
            end

            local Attacks = {}

            function Attacks.new(deps)
                return {
                    deps = deps,
                    server = nil,
                    meleeAt = tick(),
                    swingAt = tick(),
                    physicsAt = tick(),
                    shotAt = tick(),
                    spamAt = tick(),
                    hiding = false,
                    burstAt = nil,
                    burstAmmo = nil,
                    attackPose = nil,
                    attackTarget = nil,
                    attackItem = nil,
                    attackMode = nil,
                    attackPosition = nil,
                    poseFired = false,
                    equipItem = nil,
                    equipAt = 0,
                    reloadItem = nil,
                    reloadAt = 0,
                }
            end

            local function detach(attacks)
                attacks.attackPose, attacks.attackTarget, attacks.attackItem = nil, nil, nil
                attacks.attackMode, attacks.attackPosition, attacks.burstAt = nil, nil, nil
                attacks.burstAmmo = nil
                attacks.poseFired = false
            end

            function Attacks.reset(attacks)
                detach(attacks)

                attacks.hiding, attacks.spamAt = false, tick()
                attacks.equipItem, attacks.reloadItem, attacks.equipAt, attacks.reloadAt = nil, nil, 0, 0
            end

            local function spamming(attacks)
                local options = attacks.deps.settings()

                if not options.voidSpam then
                    attacks.hiding, attacks.spamAt, attacks.burstAt = false, tick(), nil

                    return false
                end

                local now = tick()
                local item, ammo, started = attacks.attackItem, attacks.burstAmmo, attacks.burstAt
                local confirmed = item and ammo and started and (item.Data.Ammo or ammo) < ammo and (item.Info.ShootCooldown or 0) > options.voidAttack and now >= started + SETTLE

                if attacks.hiding then
                    if now >= attacks.spamAt then
                        attacks.hiding = false
                    end
                elseif confirmed or (attacks.burstAt and now >= attacks.burstAt + math.max(options.voidAttack, SETTLE)) or (not attacks.attackPose and now >= attacks.spamAt) then
                    attacks.hiding = true
                    attacks.spamAt = now + options.voidHide
                end

                return attacks.hiding
            end
            local function place(attacks, root, at)
                attacks.server = at

                if at then
                    root.CFrame = at
                end

                attacks.deps.replicate(root)
            end
            local function settle(attacks, root)
                detach(attacks)

                attacks.physicsAt = tick() + SETTLE

                place(attacks, root, attacks.deps.hide())
            end
            local function attach(attacks, root, item, target, mode, pose)
                local held, position = attacks.attackPose, attacks.attackPosition
                local reuse = mode == 'gun' and attacks.attackMode == mode and attacks.attackItem == item and held == pose
                local changed = not held or (attacks.attackTarget ~= target.part and not reuse) or attacks.attackItem ~= item or attacks.attackMode ~= mode or not position or (mode == 'gun' and held ~= pose)
                local moved = mode ~= 'gun' and position and (target.part.Position - position).Magnitude > 2

                if changed or (moved and attacks.poseFired) then
                    held = pose
                    attacks.attackPose, attacks.attackTarget, attacks.attackItem = held, target.part, item
                    attacks.attackMode, attacks.attackPosition = mode, target.part.Position
                    attacks.poseFired = false

                    if changed then
                        attacks.burstAt = nil
                        attacks.burstAmmo = nil
                    end

                    local delay = attacks.deps.replicationDelay

                    attacks.physicsAt = tick() + math.max(SETTLE, (delay and {
                        (delay()),
                    } or {SETTLE})[1])
                end

                attacks.attackTarget = target.part

                local published = assert(held)

                place(attacks, root, published)

                return published, tick() >= attacks.physicsAt
            end
            local function beginBurst(attacks, now)
                attacks.poseFired = true

                if not attacks.burstAt then
                    attacks.burstAt = now
                    attacks.burstAmmo = attacks.attackItem.Data.Ammo
                end
            end
            local function equip(attacks, fighter, item)
                local now = tick()

                if attacks.equipItem == item and now < attacks.equipAt then
                    return
                end

                attacks.equipItem, attacks.equipAt = item, now + 0.25

                local schedule = attacks.deps.equip

                if schedule then
                    schedule(fighter, item)
                else
                    task.spawn(fighter.EquipItem, fighter, item.Data.ItemIndex)
                end
            end
            local function knife(attacks, fighter, root, item, target)
                local deps = attacks.deps

                if fighter.EquippedItem ~= item then
                    equip(attacks, fighter, item)
                    settle(attacks, root)

                    return 'void...'
                end
                if not target or tick() < (item._equip_cooldown or 0) then
                    settle(attacks, root)

                    return 'void...'
                end
                if spamming(attacks) then
                    settle(attacks, root)

                    return 'void spamming...'
                end

                local now = tick()
                local facing = (type(target.fighter.GetRotationCFrame) == 'function' and {
                    (CFrame.new(target.part.Position) * target.fighter:GetRotationCFrame()),
                } or {
                    target.part.CFrame,
                })[1]
                local behind = facing * CFrame.new(0, 0, 3)
                local previous = attacks.attackPose
                local pose, ready = attach(attacks, root, item, target, 'knife', behind)
                local aim = CFrame.lookAt(pose.Position, target.part.Position)

                if previous ~= pose or (ready and now >= attacks.swingAt) then
                    local pitch, yaw = aim:ToOrientation()

                    CameraHold.send(deps.hold, Pose.encode(pitch, yaw))
                end
                if ready and now >= attacks.swingAt then
                    if not Swing.send(deps.use, deps.enums, item, aim, target.part, true) then
                        settle(attacks, root)

                        return 'invalid knife animation... (void)'
                    end

                    attacks.swingAt = now + 1 / 60

                    beginBurst(attacks, now)
                end

                return (ready and {
                    string.format('backstabbing %s...', tostring(target.name)),
                } or {
                    string.format('attaching %s...', tostring(target.name)),
                })[1]
            end
            local function melee(attacks, fighter, root, item, target)
                local deps = attacks.deps

                local function wait()
                    settle(attacks, root)

                    attacks.meleeAt = tick() + SETTLE
                end

                if fighter.EquippedItem ~= item then
                    equip(attacks, fighter, item)
                    wait()

                    return 'void...'
                end
                if not target then
                    wait()

                    return 'void...'
                end
                if tick() < (item._equip_cooldown or 0) then
                    wait()

                    return 'void...'
                end
                if spamming(attacks) then
                    wait()

                    return 'void spamming...'
                end

                local now = tick()
                local pose, ready = attach(attacks, root, item, target, 'melee', around(target, 3))
                local aim = CFrame.lookAt(pose.Position, target.part.Position)

                if ready and now >= attacks.meleeAt and now >= attacks.swingAt then
                    if not Swing.send(deps.use, deps.enums, item, aim, target.part, false) then
                        wait()

                        return 'invalid melee animation... (void)'
                    end

                    attacks.swingAt = now + 1 / 60

                    beginBurst(attacks, now)
                end

                return (ready and {
                    string.format('attacking %s...', tostring(target.name)),
                } or {
                    string.format('attaching %s...', tostring(target.name)),
                })[1]
            end
            local function ammunition(item)
                if (item.Data.Ammo or 0) > 0 then
                    return true, false
                end

                return false, (item.Data.AmmoReserve or 0) == 0
            end
            local function reload(attacks, item)
                local deps = attacks.deps
                local now = tick()

                if attacks.reloadItem == item and now < attacks.reloadAt then
                    return
                end

                attacks.reloadItem, attacks.reloadAt = item, now + 0.25

                local results = {
                    item:StartReloading(),
                }

                if table.remove(results, 1) ~= true then
                    return
                end

                local action = table.remove(results, 1)

                if type(action) ~= 'string' then
                    return
                end

                local arguments = {}

                for index, value in results do
                    arguments[utf8.char(index)] = value
                end

                deps.use(item:Get('ObjectID'), deps.enums:ToEnum(action), arguments, nil)
            end
            local function chooseGun(guns, options)
                local first, last, step = 1, #guns, 1

                if not options.primary then
                    first, last, step = #guns, 1, -1
                end

                local chosen = nil

                for index = first, last, step do
                    local item = guns[index]
                    local loaded, empty = ammunition(item)
                    local candidate = {
                        item = item,
                        loaded = loaded,
                        empty = empty,
                    }

                    if loaded or not empty then
                        local reloading = tick() < (item._reload_cooldown or 0)
                        local threads = item._reload_threads

                        if item.Info.ReloadType == 'Segmented' and type(threads) == 'table' then
                            local active = threads[#threads]

                            reloading = reloading or (active ~= nil and coroutine.status(active) ~= 'dead')
                        end
                        if not options.swapWhenEmpty or (loaded and not reloading) then
                            return candidate
                        end

                        chosen = chosen or candidate
                    end
                end

                return chosen
            end
            local function shoot(deps, item, target, aim, attempts)
                for _ = 1, attempts do
                    local arguments = {
                        ['\1'] = {
                            ['\0'] = Shot.pack(aim),
                            ['\1'] = Shot.pack(aim),
                            ['\2'] = target.part,
                            ['\3'] = Shot.pack(Shot.scatter()),
                        },
                        ['\2'] = true,
                    }

                    if item.Name == 'Revolver' then
                        arguments['\3'] = true
                    end

                    deps.use(item:Get('ObjectID'), deps.enums:ToEnum('StartShooting'), arguments, nil)
                end
            end
            local function gun(attacks, fighter, root, guns, target, status)
                local options = attacks.deps.settings()
                local chosen = chooseGun(guns, options)

                if not chosen then
                    settle(attacks, root)

                    return 'no usable item(s)... (void)'
                end

                local item = chosen.item

                if fighter.EquippedItem ~= item then
                    equip(attacks, fighter, item)
                    settle(attacks, root)

                    return 'void...'
                end
                if item.Info.ReloadType == 'Segmented' then
                    local threads = item._reload_threads
                    local thread = threads[#threads]

                    if thread and coroutine.status(thread) ~= 'dead' then
                        settle(attacks, root)

                        return 'reloading...'
                    end
                end

                local now = tick()

                if now < (item._equip_cooldown or 0) then
                    settle(attacks, root)

                    return 'void...'
                end
                if now < (item._reload_cooldown or 0) then
                    settle(attacks, root)

                    return 'reloading...'
                end
                if status ~= 'RoundStarted' then
                    settle(attacks, root)

                    return 'void...'
                end
                if not chosen.loaded and not chosen.empty then
                    reload(attacks, item)
                    settle(attacks, root)

                    return 'reloading...'
                end
                if not target then
                    settle(attacks, root)

                    return 'void...'
                end
                if spamming(attacks) then
                    settle(attacks, root)

                    return 'void spamming...'
                end

                local position = target.part.Position
                local above = beyondShield(target, 2) or position + Vector3.new(0, 3, 0)
                local eye = Vector3.new(0, (fighter:IsCrouching() and {CROUCHED_EYE} or {EYE})[1], 0)
                local clear = attacks.deps.clear or function(_from, _to)
                    return true
                end
                local hasShield = shield(target.fighter)
                local held = (attacks.attackMode == 'gun' and attacks.attackItem == item and not hasShield and {
                    attacks.attackPose,
                } or {nil})[1]
                local route = (held and not attacks.poseFired and attacks.attackTarget == target.part and clear(held.Position + eye, position) and {held} or {
                    (Origins.gun(position, above, eye, held, clear)),
                })[1]

                if not route then
                    settle(attacks, root)

                    return string.format('blocked %s... (void)', tostring(target.name))
                end

                local pose, ready = attach(attacks, root, item, target, 'gun', route)
                local aim = CFrame.lookAt(pose.Position + eye, position)

                if ready and now >= attacks.shotAt then
                    attacks.shotAt = now + 1 / 120

                    beginBurst(attacks, now)
                    shoot(attacks.deps, item, target, aim, options.shootAttempts)
                end

                return (ready and {
                    string.format('killing %s...', tostring(target.name)),
                } or {
                    string.format('attaching %s...', tostring(target.name)),
                })[1]
            end

            function Attacks.cycle(
                attacks,
                fighter,
                root,
                target,
                status,
                _deltaTime
            )
                attacks.server = nil

                local mode = attacks.deps.settings().mode
                local guns, chosen = {}, nil

                for _, item in fighter.Items do
                    if item.Info.Type == 'Gun' then
                        table.insert(guns, item)
                    elseif mode == 'knife' and item.Name == 'Knife' then
                        chosen = item

                        break
                    elseif mode == 'melee' and item.Info.Type == 'Melee' then
                        chosen = item

                        break
                    end
                end

                local doing

                if chosen and mode == 'knife' then
                    doing = knife(attacks, fighter, root, chosen, target)
                elseif chosen then
                    doing = melee(attacks, fighter, root, chosen, target)
                elseif #guns > 0 then
                    doing = gun(attacks, fighter, root, guns, target, status)
                else
                    doing = 'invalid weapons for ragebot'
                end

                return attacks.server, doing
            end

            return table.freeze(Attacks)
        end

        function __ANTIBRAIN_MODULES.Y()
            local v = __ANTIBRAIN_MODULES.cache.Y

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.Y = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Service = __ANTIBRAIN_MODULES.m()
            local Services = __ANTIBRAIN_MODULES.k()
            local EVENTS = Service.new('fighter events', function(
                scope,
                services
            )
                local access = Hooks.executor()
                local fighters = Modules.controller('FighterController')
                local listeners = {}
                local hooked, hook = nil, nil

                local function follow(fighter)
                    if hooked and rawget(hooked, 'ReplicateFromServer') == hook then
                        rawset(hooked, 'ReplicateFromServer', nil)
                    end

                    hooked, hook = fighter, nil

                    if type(fighter) ~= 'table' then
                        return
                    end

                    local original = fighter.ReplicateFromServer

                    hook = function(self, kind, ...)
                        for heard in listeners do
                            local failure = Failure.capture(heard, kind, ...)

                            if failure then
                                scope:report(string.format('A fighter event listener failed: %s', tostring(failure)))
                            end
                        end

                        return original(self, kind, ...)
                    end

                    access.disguise(hook, original)
                    rawset(fighter, 'ReplicateFromServer', hook)
                end

                follow(fighters.LocalFighter)
                scope:connect(Services.RunService.Heartbeat, function()
                    if fighters.LocalFighter ~= hooked then
                        follow(fighters.LocalFighter)
                    end
                end)
                scope:add(function()
                    follow(nil)
                end)

                return {listeners = listeners}
            end)
            local FighterEvents = {}

            function FighterEvents.listen(run, services, listener)
                local events = Service.use(run, services, EVENTS)

                events.listeners[listener] = true

                run:add(function()
                    events.listeners[listener] = nil
                end)
            end

            return table.freeze(FighterEvents)
        end

        function __ANTIBRAIN_MODULES.Z()
            local v = __ANTIBRAIN_MODULES.cache.Z

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.Z = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Identity = {}
            local HUB = 8

            function Identity.restore()
                local set = setthreadidentity

                if type(set) == 'function' then
                    set(HUB)
                end
            end
            function Identity.current()
                local get = getthreadidentity

                if type(get) ~= 'function' then
                    return nil
                end

                local ok, value = pcall(get)

                return (ok and type(value) == 'number' and {value} or {nil})[1]
            end

            return table.freeze(Identity)
        end

        function __ANTIBRAIN_MODULES._()
            local v = __ANTIBRAIN_MODULES.cache._

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache._ = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local HEIGHT = 2 ^ 20
            local Void = {}

            function Void.resolver(_duel, _private, real)
                return function()
                    local position = real()

                    if position and position.Magnitude < HEIGHT then
                        return CFrame.new(position.X, HEIGHT, position.Z)
                    end

                    return CFrame.new(0, HEIGHT, 0)
                end
            end

            return table.freeze(Void)
        end

        function __ANTIBRAIN_MODULES.aa()
            local v = __ANTIBRAIN_MODULES.cache.aa

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aa = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Aiming = __ANTIBRAIN_MODULES.s()
            local Attacks = __ANTIBRAIN_MODULES.Y()
            local CameraHold = __ANTIBRAIN_MODULES.x()
            local Desync = __ANTIBRAIN_MODULES.F()
            local Encoder = __ANTIBRAIN_MODULES.A()
            local FighterEvents = __ANTIBRAIN_MODULES.Z()
            local Identity = __ANTIBRAIN_MODULES._()
            local Modules = __ANTIBRAIN_MODULES.l()
            local Origins = __ANTIBRAIN_MODULES.X()
            local RageReport = __ANTIBRAIN_MODULES.n()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Services = __ANTIBRAIN_MODULES.k()
            local Targets = __ANTIBRAIN_MODULES.V()
            local Void = __ANTIBRAIN_MODULES.aa()
            local ORDER = 1
            local Ragebot = {}

            function Ragebot.start(run, settings, services, notify, counterOn)
                local me = Modules.player()
                local fighters = Modules.controller('FighterController')
                local spectate = Modules.controller('SpectateController')
                local enums = Modules.shared('EnumLibrary')
                local constants = Modules.shared('CONSTANTS')
                local useItem = (Modules.remote({
                    'Replication',
                    'Fighter',
                    'UseItem',
                }))
                local setIdentity = setthreadidentity
                local setHidden = sethiddenproperty
                local terrain = Services.Workspace.Terrain
                local real = nil
                local params = RaycastParams.new()

                params.FilterType = Enum.RaycastFilterType.Exclude

                local function duel()
                    local current = spectate.CurrentDuelSubject

                    return (type(current) == 'table' and {current} or {nil})[1]
                end

                Encoder.use(run, services)

                local priority = Targets.priority(settings, function(message)
                    Identity.restore()
                    notify(message)
                end, run)
                local attacks = Attacks.new({
                    settings = settings,
                    enums = enums,
                    use = function(...)
                        useItem:FireServer(...)
                    end,
                    hide = Void.resolver(duel, constants.IS_PRIVATE_SERVER == true, function(
                    )
                        return real
                    end),
                    hold = CameraHold.use(run, services),
                    clear = function(from, to)
                        return Services.Workspace:Raycast(from, to - from, params) == nil
                    end,
                    equip = function(fighter, item)
                        run:spawn(fighter.EquipItem, fighter, item.Data.ItemIndex)
                    end,
                    replicationDelay = function()
                        return math.max(0.05, me:GetNetworkPing() * 2 + 1 / 30)
                    end,
                    replicate = function(root)
                        if type(setIdentity) == 'function' then
                            setIdentity(8)
                        end
                        if type(setHidden) == 'function' then
                            setHidden(root, 'PhysicsRepRootPart', terrain)
                        end
                    end,
                })
                local hurt = enums:ToEnum('HurtEffect')

                FighterEvents.listen(run, services, function(
                    kind,
                    effect,
                    detail
                )
                    if kind ~= 'EntityChanged' or effect ~= hurt or type(detail) ~= 'table' then
                        return
                    end

                    local part = detail['\2']
                    local attacker = (typeof(part) == 'Instance' and part.Parent and {
                        (Services.Players:GetPlayerFromCharacter(part.Parent)),
                    } or {nil})[1]

                    if attacker and Aiming.ragebotActive(services) and settings().join.attackers then
                        Targets.prioritize(priority, attacker, me)
                    end
                end)

                local function stop()
                    Attacks.reset(attacks)

                    priority.current = nil

                    RageReport.set(services, nil)
                end

                Desync.join(run, services, ORDER, function(
                    cframe,
                    root,
                    deltaTime
                )
                    local fighter = fighters.LocalFighter

                    if not settings().active or counterOn() or type(fighter) ~= 'table' then
                        stop()

                        return nil
                    end

                    real = cframe.Position

                    local current = duel()
                    local status = (current and type(current.Data) == 'table' and {
                        current.Data.Status,
                    } or {nil})[1]
                    local duelers = (current and {
                        current._duelers_by_player,
                    } or {nil})[1]
                    local excluded = {}

                    if me.Character then
                        table.insert(excluded, me.Character)
                    end
                    if type(duelers) == 'table' then
                        for player in duelers do
                            if player.Character then
                                table.insert(excluded, player.Character)
                            end
                        end
                    end

                    local camera = Services.Workspace.CurrentCamera

                    if camera then
                        table.insert(excluded, camera)
                    end

                    params.FilterDescendantsInstances = excluded

                    local function reachable(checked)
                        if settings().mode ~= 'gun' then
                            return true
                        end

                        local position = checked.part.Position
                        local eye = Vector3.new(0, fighter:IsCrouching() and 0.25 or 1.75, 0)

                        return Origins.gun(position, position + Vector3.new(0, 3, 0), eye, attacks.attackPose, function(
                            from,
                            to
                        )
                            return Services.Workspace:Raycast(from, to - from, params) == nil
                        end) ~= nil
                    end

                    local target = (status == 'RoundStarted' and type(duelers) == 'table' and {
                        (Targets.pick(priority, duelers, me, reachable)),
                    } or {nil})[1]
                    local server, doing = Attacks.cycle(attacks, fighter, root, target, status, deltaTime)

                    RageReport.set(services, {
                        status = doing,
                        target = (target and {
                            target.part,
                        } or {nil})[1],
                    })

                    return server
                end, stop)
                run:add(stop)
            end

            return table.freeze(Ragebot)
        end

        function __ANTIBRAIN_MODULES.ab()
            local v = __ANTIBRAIN_MODULES.cache.ab

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ab = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Fighter = __ANTIBRAIN_MODULES.o()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local HITBOXES = table.freeze({
                HitboxBody = true,
                HitboxHead = true,
                PhysicalHitboxHead = true,
                HitboxBodySmall = true,
                HitboxHeadSmall = true,
                FakeMass = true,
            })
            local INTERVAL = 1 / 60
            local MAX_CASTS = 64
            local Triggerbot = {}

            function Triggerbot.start(run, settings)
                local player = Modules.player()
                local fighters = Modules.controller('FighterController')
                local spectate = Modules.controller('SpectateController')
                local input = Modules.client({
                    'ClientReplicatedClasses',
                    'ClientFighter',
                    'ClientItem',
                }).Input

                assert(type(input) == 'function', 'RIVALS ClientItem.Input is unavailable')

                local random = Random.new()
                local setIdentity = setthreadidentity
                local nextCast, shootAfter, readyAt, forgetAt = 0, 0, 0, 0
                local current = nil
                local wait = function(now)
                    local options = settings()
                    local offset = options.reactionOffset

                    readyAt = now + options.reactionTime + ((offset > 0 and {
                        (random:NextNumber(-offset, offset)),
                    } or {0})[1])
                end

                wait(tick())

                local function shoot(item, humanoid, now)
                    local options = settings()

                    current = humanoid
                    forgetAt = now + options.forgetTime
                    shootAfter = now + options.shootDelay

                    if type(setIdentity) == 'function' then
                        setIdentity(1)
                    end

                    local shot, failure = pcall(input, item, 'StartShooting')

                    if type(setIdentity) == 'function' then
                        setIdentity(8)
                    end
                    if not shot then
                        error(failure, 0)
                    end
                end

                local aimedAt = function(camera, options)
                    local params = RaycastParams.new()

                    params.CollisionGroup = ''

                    local ignored = {}
                    local viewModels = Services.Workspace:FindFirstChild('ViewModels')

                    if viewModels then
                        table.insert(ignored, viewModels)
                    end
                    if player.Character then
                        table.insert(ignored, player.Character)
                    end

                    params.FilterDescendantsInstances = ignored

                    local frame = camera.CFrame
                    local direction = frame.LookVector * options.maxDistance

                    for _ = 1, MAX_CASTS do
                        local hit = Services.Workspace:Raycast(frame.Position, direction, params)

                        if not hit or not hit.Instance:IsA('BasePart') then
                            return nil, nil
                        end

                        local part = hit.Instance

                        if HITBOXES[part.Name] or options.blacklist[part.Name] then
                            params:AddToFilter(part)
                        else
                            local model = part:FindFirstAncestorOfClass('Model')
                            local humanoid = (model and {
                                (model:FindFirstChildOfClass('Humanoid')),
                            } or {nil})[1]

                            return model, humanoid
                        end
                    end

                    return nil, nil
                end

                run:connect(Services.RunService.Heartbeat, function()
                    if not Fighter.alive(fighters.LocalFighter, player) then
                        return
                    end

                    local options = settings()

                    if not options.active then
                        return
                    end

                    local now = tick()

                    if now < nextCast or now < shootAfter then
                        return
                    end

                    local duel = spectate.CurrentDuelSubject
                    local duelers = (type(duel) == 'table' and {
                        duel._duelers_by_player,
                    } or {nil})[1]
                    local fighter = fighters.LocalFighter

                    if type(duelers) ~= 'table' or type(fighter) ~= 'table' then
                        return
                    end

                    nextCast = now + INTERVAL

                    local item = fighter.EquippedItem
                    local camera = Services.Workspace.CurrentCamera

                    if type(item) ~= 'table' or item.Info.Type ~= 'Gun' or not camera then
                        return wait(now)
                    end
                    if options.scoped[item.Name] and not item:IsFullyAiming() then
                        return wait(now)
                    end

                    local model, humanoid = aimedAt(camera, options)

                    if not model or not humanoid then
                        return wait(now)
                    end
                    if humanoid.Health <= 0 then
                        return
                    end

                    local opponent = Services.Players:GetPlayerFromCharacter(model)

                    if not opponent then
                        return
                    end

                    local dueler = duelers[opponent]

                    if not dueler or dueler._is_ally then
                        return wait(now)
                    end

                    local enemy = dueler.ClientFighter

                    if not enemy or Fighter.invincible(enemy) then
                        return wait(now)
                    end
                    if options.options['anti katana'] and Fighter.deflecting(enemy) then
                        return wait(now)
                    end
                    if forgetAt < now then
                        current = nil
                    end
                    if current == humanoid or (current and options.options['no delay between targets']) then
                        return shoot(item, humanoid, now)
                    end
                    if now >= readyAt then
                        shoot(item, humanoid, now)
                    end
                end)
            end

            return table.freeze(Triggerbot)
        end

        function __ANTIBRAIN_MODULES.ac()
            local v = __ANTIBRAIN_MODULES.cache.ac

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ac = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local PLAY, PLAY_HOOK = 'PlayAnimation', '\0PlayAnimation '

            local function constantAt(access, closure, value)
                for index, constant in access.getconstants(closure)do
                    if constant == value then
                        return index
                    end
                end

                return nil
            end
            local function impactTime(visual)
                local step = visual._last_args[4] or 0.05
                local longest = visual._last_args[6] or math.huge
                local impact = visual._impact_sphere.CFrame

                for index, segment in visual._segments do
                    if segment.CFrame == impact then
                        return math.min(longest, (index - 2) * step)
                    end
                end

                return nil
            end
            local function tracerSpread(run, access, gun, settings)
                for _, value in access.getupvalues(gun._LocalTracers)do
                    if type(value) == 'table' and rawget(value, 'OOB_DEFAULT_WARN_DELAY') ~= nil then
                        local getSpread = value.GetSpread
                        local standIn = setmetatable({}, {__index = value})

                        standIn.GetSpread = function(a, b, c, noSpread, ...)
                            return getSpread(a, b, c, settings().noSpread and true or noSpread, 
...)
                        end

                        access.disguise(standIn.GetSpread, getSpread)
                        Hooks.swapUpvalue(run, access, gun._LocalTracers, value, standIn, "the tracers' spread")

                        break
                    end
                end
            end
            local function shotSpread(run, access, gun, settings)
                return Hooks.hook(run, access, gun.StartShooting, function(
                    original
                )
                    return function(self, ...)
                        if not self.ClientFighter.IsLocalPlayer then
                            return original(self, ...)
                        end

                        local results = table.pack(original(self, ...))

                        if results[1] and results[2] == 'StartShooting' then
                            if self.Name == 'Revolver' then
                                results[5] = true
                            end
                            if settings().noSpread then
                                results[4] = true
                            end
                        end

                        return table.unpack(results, 1, results.n)
                    end
                end)
            end
            local function firerate(
                run,
                access,
                startShooting,
                viewModelClass,
                settings
            )
                local playAnimation = viewModelClass.PlayAnimation

                assert(type(playAnimation) == 'function', 'RIVALS ClientViewModel.PlayAnimation is unavailable')

                local play = function(viewModel, name, amount, ...)
                    local item = viewModel.ClientItem

                    if item.ClientFighter.IsLocalPlayer then
                        item._shoot_cooldown = item._shoot_cooldown - amount * (1 - settings().firerate / 100)
                    end

                    return playAnimation(viewModel, name, ...)
                end

                access.disguise(play, playAnimation)
                rawset(viewModelClass, PLAY_HOOK, play)
                run:add(function()
                    if rawget(viewModelClass, PLAY_HOOK) == play then
                        rawset(viewModelClass, PLAY_HOOK, nil)
                    end
                end)
                Hooks.swapConstant(run, access, startShooting, PLAY, PLAY_HOOK, 'the PlayAnimation name in Gun.StartShooting')
            end
            local function meleeCooldown(run, access, melee, settings)
                Hooks.hook(run, access, melee.StartShooting, function(original)
                    return function(self, ...)
                        local results = table.pack(original(self, ...))
                        local kept = settings().meleeCooldown / 100

                        if results[1] == true and kept < 1 and self.ClientFighter.IsLocalPlayer then
                            local started = self._last_attack

                            self._attack_cooldown = started + (self._attack_cooldown - started) * kept
                        end

                        return table.unpack(results, 1, results.n)
                    end
                end)
            end
            local function fullAuto(run, access, settings)
                for _, info in Modules.shared('ItemLibrary').Items do
                    local spamming = (type(info) == 'table' and {
                        (rawget(info, 'InputSpammingEnabled')),
                    } or {nil})[1]

                    if type(spamming) == 'table' and rawget(spamming, 'StartShooting') == false then
                        local stored = false

                        run:add(function()
                            setmetatable(spamming, nil)
                            rawset(spamming, 'StartShooting', stored)
                        end)
                        rawset(spamming, 'StartShooting', nil)
                        setmetatable(spamming, {
                            __index = access.cclosure(function(_, key)
                                if key ~= 'StartShooting' then
                                    return nil
                                end

                                return settings().fullAuto and 0 or stored
                            end),
                            __newindex = access.cclosure(function(
                                target,
                                key,
                                value
                            )
                                if key ~= 'StartShooting' then
                                    rawset(target, key, value)
                                else
                                    stored = value
                                end
                            end),
                        })
                    end
                end
            end
            local function explosions(run, access, throwable, settings)
                return Hooks.hook(run, access, throwable._FinishThrow, function(
                    original
                )
                    return function(self, ...)
                        if self.Name ~= 'Grenade' or not self.ClientFighter.IsLocalPlayer then
                            return original(self, ...)
                        end

                        local options = settings().grenade
                        local at = nil

                        if options['explode on throw'] then
                            at = 0
                        elseif options['explode on impact'] then
                            pcall(function()
                                at = impactTime(self._trajectory_visual)
                            end)
                        end

                        local results = table.pack(original(self, ...))

                        if at and type(results[2]) == 'number' then
                            results[2] = at
                        end

                        return table.unpack(results, 1, results.n)
                    end
                end)
            end
            local function fuses(run, access, throwable, finishThrow, settings)
                local executorGetproto = getproto
                local found = {}

                local function fuse(closure, normal, removed)
                    local index = constantAt(access, closure, normal)

                    if index then
                        table.insert(found, {
                            closure = closure,
                            index = index,
                            normal = normal,
                            removed = removed,
                        })
                    end
                end

                fuse(throwable._StartThrow, 'delay', 'wait')
                fuse(finishThrow, '_cook_detonate_delay', '\0')
                pcall(function()
                    fuse(executorGetproto(throwable._CreateTractoryVisual, 1), '_cook_detonate_delay', '\0')
                end)

                local fuseRemoved = false
                local dirty = false
                local setFuse = function(removed)
                    dirty = true

                    for _, constant in found do
                        access.setconstant(constant.closure, constant.index, (removed and {
                            constant.removed,
                        } or {
                            constant.normal,
                        })[1])
                    end

                    fuseRemoved = removed
                    dirty = false
                end

                run:connect(Services.RunService.Heartbeat, function()
                    local removed = settings().grenade['remove fuse'] == true

                    if dirty or removed ~= fuseRemoved then
                        setFuse(removed)
                    end
                end)

                for _, constant in found do
                    run:add(function()
                        access.setconstant(constant.closure, constant.index, constant.normal)
                    end)
                end
            end

            local Weapons = {}

            function Weapons.start(run, settings)
                local access = Hooks.executor()
                local gun = Modules.client({
                    'ItemTypes',
                    'Gun',
                })
                local viewModelClass = Modules.client({
                    'ClientReplicatedClasses',
                    'ClientFighter',
                    'ClientItem',
                    'ClientViewModel',
                })

                tracerSpread(run, access, gun, settings)

                local startShooting = shotSpread(run, access, gun, settings)

                firerate(run, access, startShooting, viewModelClass, settings)
                meleeCooldown(run, access, Modules.client({
                    'ItemTypes',
                    'Melee',
                }), settings)
                fullAuto(run, access, settings)

                local throwable = Modules.client({
                    'ItemTypes',
                    'Throwable',
                })

                fuses(run, access, throwable, explosions(run, access, throwable, settings), settings)
            end

            return table.freeze(Weapons)
        end

        function __ANTIBRAIN_MODULES.ad()
            local v = __ANTIBRAIN_MODULES.cache.ad

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ad = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.v()

            local FovControls = __ANTIBRAIN_MODULES.U()

            __ANTIBRAIN_MODULES.g()
            __ANTIBRAIN_MODULES.W()
            __ANTIBRAIN_MODULES.ab()
            __ANTIBRAIN_MODULES.T()
            __ANTIBRAIN_MODULES.ac()
            __ANTIBRAIN_MODULES.ad()

            local BODY_PARTS = table.freeze({
                'Head',
                'HumanoidRootPart',
                'UpperTorso',
                'LowerTorso',
                'LeftFoot',
                'LeftLowerLeg',
                'LeftUpperLeg',
                'RightFoot',
                'RightLowerLeg',
                'RightUpperLeg',
                'LeftHand',
                'LeftLowerArm',
                'LeftUpperArm',
                'RightHand',
                'RightLowerArm',
                'RightUpperArm',
            })

            local function silentAim(box, ui)
                local toggle = box:toggle(ui.id('silent-aim'), {
                    text = 'enabled',
                    default = false,
                })
                local key = toggle:keybind(ui.id('silent-aim-key'), {
                    text = 'silent aim',
                })

                box = box:dependent(function()
                    return toggle.value
                end)

                local manipulation = box:toggle(ui.id('silent-aim-manipulation'), {
                    text = 'manipulation',
                    default = false,
                    tooltip = 'silent aim must be enabled, overrides closest part',
                })
                local closestPart = box:toggle(ui.id('silent-aim-closest-part'), {
                    text = 'closest part',
                    default = false,
                })
                local visualize = box:toggle(ui.id('silent-aim-visualize'), {
                    text = 'visualize',
                    default = true,
                    tooltip = 'if enabled, redirects bullets visually',
                })
                local options = box:dependent(function()
                    return toggle.value
                end)
                local readFov = FovControls.build(options, ui, 'silent-aim')
                local radius = box:slider(ui.id('silent-aim-radius'), {
                    text = 'radius',
                    default = 100,
                    min = 0,
                    max = 1000,
                    rounding = 0,
                    increment = 5,
                    suffix = 'px',
                })
                local hitChance = box:slider(ui.id('silent-aim-hit-chance'), {
                    text = 'hit chance',
                    default = 100,
                    min = 1,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })

                return toggle, function(settings)
                    settings.active, settings.manipulation = key:active(), manipulation.value
                    settings.closestPart, settings.visualize = closestPart.value, visualize.value
                    settings.radius, settings.hitChance = radius.value, hitChance.value

                    readFov(settings.look, radius.value)
                end
            end
            local function aimbot(box, ui)
                local toggle = box:toggle(ui.id('aimbot'), {
                    text = 'enabled',
                    default = false,
                })
                local key = toggle:keybind(ui.id('aimbot-key'), {
                    text = 'aimbot',
                })

                box = box:dependent(function()
                    return toggle.value
                end)

                local closestPart = box:toggle(ui.id('aimbot-closest-part'), {
                    text = 'closest part',
                    default = false,
                })
                local closestPosition = box:toggle(ui.id('aimbot-closest-position'), {
                    text = 'closest position',
                    default = false,
                })
                local delayPosition = box:toggle(ui.id('aimbot-delay-position'), {
                    text = 'delay position',
                    default = false,
                })
                local delay = box:dependent(function()
                    return delayPosition.value
                end)

                local function percent(text, tooltip)
                    return {
                        text = text,
                        default = 100,
                        min = 1,
                        max = 100,
                        rounding = 0,
                        suffix = '%',
                        tooltip = tooltip,
                    }
                end

                local smoothX = delay:slider(ui.id('aimbot-delay-smooth-x'), percent('x smooth'))
                local smoothY = smoothX:slider(ui.id('aimbot-delay-smooth-y'), percent('y smooth'))
                local smoothJump = delay:slider(ui.id('aimbot-delay-smooth-jump'), percent('jump smoothing', 'assuming they are jumping, overrides y smooth'))
                local options = box:dependent(function()
                    return toggle.value
                end)
                local readFov = FovControls.build(options, ui, 'aimbot')
                local radius = box:slider(ui.id('aimbot-radius'), {
                    text = 'radius',
                    default = 100,
                    min = 0,
                    max = 1000,
                    rounding = 0,
                    increment = 5,
                    suffix = 'px',
                })
                local smoothing = box:slider(ui.id('aimbot-smoothing'), {
                    text = 'smoothing',
                    default = 100,
                    min = 1,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })

                return toggle, function(settings)
                    settings.aimActive, settings.aimRadius = key:active(), radius.value
                    settings.aimClosestPart, settings.closestPosition = closestPart.value, closestPosition.value
                    settings.delayPosition, settings.smoothing = delayPosition.value, smoothing.value / 100
                    settings.smoothX, settings.smoothY = smoothX.value / 100, smoothY.value / 100
                    settings.smoothJump = smoothJump.value / 100

                    readFov(settings.aimLook, radius.value)
                end
            end
            local function triggerbot(box, ui)
                local toggle = box:toggle(ui.id('triggerbot'), {
                    text = 'enabled',
                    default = false,
                })
                local key = toggle:keybind(ui.id('triggerbot-key'), {
                    text = 'triggerbot',
                })
                local options = box:dependent(function()
                    return toggle.value
                end)
                local reactionTime = options:slider(ui.id('triggerbot-reaction-time'), {
                    text = 'reaction time',
                    default = 100,
                    min = 0,
                    max = 300,
                    rounding = 0,
                    increment = 5,
                    suffix = 'ms',
                })
                local reactionOffset = options:slider(ui.id('triggerbot-reaction-time-offset'), {
                    text = 'reaction time offset',
                    default = 0,
                    min = 0,
                    max = 100,
                    rounding = 0,
                    increment = 5,
                    suffix = 'ms',
                    tooltip = 'the range used to generate a random reaction time offset',
                })
                local forgetTime = options:slider(ui.id('triggerbot-forget-time'), {
                    text = 'forget time',
                    default = 0.5,
                    min = 0,
                    max = 10,
                    rounding = 1,
                    suffix = 's',
                    tooltip = 
[[time it takes to use reaction time assuming you had a target]],
                })
                local shootDelay = options:slider(ui.id('triggerbot-shoot-delay'), {
                    text = 'shoot delay',
                    default = 0,
                    min = 0,
                    max = 300,
                    rounding = 0,
                    suffix = 'ms',
                    tooltip = 'the delay between each shot',
                })
                local maxDistance = options:slider(ui.id('triggerbot-max-distance'), {
                    text = 'max distance',
                    default = 100,
                    min = 25,
                    max = 500,
                    rounding = 0,
                    increment = 5,
                    suffix = 's',
                })
                local blacklist = options:multiDropdown(ui.id('triggerbot-part-blacklist'), {
                    text = 'part blacklist',
                    values = table.clone(BODY_PARTS),
                    allowNull = true,
                })
                local settingsDropdown = options:multiDropdown(ui.id('triggerbot-settings'), {
                    text = 'settings',
                    values = {
                        'no delay between targets',
                        'anti katana',
                    },
                    default = {
                        'anti katana',
                    },
                    allowNull = true,
                })
                local scoped = options:multiDropdown(ui.id('triggerbot-scoped'), {
                    text = 'check scoped if',
                    values = {
                        'Sniper',
                        'Crossbow',
                    },
                    default = {
                        'Sniper',
                        'Crossbow',
                    },
                    allowNull = true,
                })
                local settings = {
                    active = false,
                    reactionTime = 0.1,
                    reactionOffset = 0,
                    forgetTime = 0.5,
                    shootDelay = 0,
                    maxDistance = 100,
                    blacklist = {},
                    options = {},
                    scoped = {},
                }

                return toggle, function()
                    settings.active = key:active()
                    settings.reactionTime, settings.reactionOffset = reactionTime.value / 1000, reactionOffset.value / 1000
                    settings.forgetTime, settings.shootDelay = forgetTime.value, shootDelay.value / 1000
                    settings.maxDistance, settings.blacklist = maxDistance.value, blacklist.value
                    settings.options, settings.scoped = settingsDropdown.value, scoped.value

                    return settings
                end
            end
            local function targeting(box, ui)
                local visibleOnly = box:toggle(ui.id('targeting-visible-only'), {
                    text = 'visible only',
                    default = false,
                })
                local ignoreProtected = box:toggle(ui.id('targeting-ignore-protected'), {
                    text = 'ignore protected',
                    default = false,
                })
                local ignoreIf = box:dependent(function()
                    return ignoreProtected.value
                end):multiDropdown(ui.id('targeting-ignore-if'), {
                    text = 'ignore if',
                    values = {
                        'blocked by riot shield',
                        'katana deflecting',
                    },
                    default = {
                        'katana deflecting',
                    },
                })
                local disableOnFlash = box:toggle(ui.id('targeting-disable-on-flash'), {
                    text = 'disable on flash',
                    default = false,
                })
                local limitDistance = box:toggle(ui.id('targeting-limit-distance'), {
                    text = 'limit distance',
                    default = false,
                })
                local maxDistance = box:dependent(function()
                    return limitDistance.value
                end):slider(ui.id('targeting-max-distance'), {
                    text = 'max distance',
                    default = 250,
                    min = 25,
                    max = 250,
                    rounding = 0,
                    suffix = 's',
                })
                local reactionTime = box:slider(ui.id('targeting-reaction-time'), {
                    text = 'reaction time',
                    default = 0,
                    min = 0,
                    max = 300,
                    rounding = 0,
                    increment = 5,
                    suffix = 'ms',
                })
                local forgetTime = box:slider(ui.id('targeting-forget-time'), {
                    text = 'forget time',
                    default = 1,
                    min = 0,
                    max = 10,
                    rounding = 1,
                    suffix = 's',
                    tooltip = 
[[time it takes to use reaction time assuming you had a target]],
                })
                local part = box:dropdown(ui.id('targeting-part'), {
                    text = 'target part',
                    values = table.clone(BODY_PARTS),
                    default = 'Head',
                })
                local closestBlacklist = box:multiDropdown(ui.id('targeting-closest-part-blacklist'), {
                    text = 'closest part blacklist',
                    values = table.clone(BODY_PARTS),
                    default = {
                        'LeftHand',
                        'LeftLowerArm',
                        'LeftUpperArm',
                        'RightHand',
                        'RightLowerArm',
                        'RightUpperArm',
                    },
                    allowNull = true,
                })

                return function(settings)
                    settings.part, settings.closestBlacklist = part.value or 'Head', closestBlacklist.value
                    settings.visibleOnly, settings.disableOnFlash = visibleOnly.value, disableOnFlash.value
                    settings.ignoreProtected, settings.ignoreIf = ignoreProtected.value, ignoreIf.value
                    settings.limitDistance, settings.maxDistance = limitDistance.value, maxDistance.value
                    settings.reactionTime, settings.forgetTime = reactionTime.value, forgetTime.value
                end
            end
            local function weapons(box, ui)
                local noSpread = box:toggle(ui.id('weapons-no-spread'), {
                    text = 'no spread',
                    default = false,
                })
                local fullAuto = box:toggle(ui.id('weapons-full-auto'), {
                    text = 'full auto',
                    default = false,
                })
                local alwaysBackstab = box:toggle(ui.id('always-backstab'), {
                    text = 'always backstab',
                    default = false,
                    tooltip = 'every knife heavy attack lands as a backstab',
                })
                local grenade = box:multiDropdown(ui.id('weapons-grenade-options'), {
                    text = 'grenade options',
                    values = {
                        'explode on impact',
                        'explode on throw',
                        'remove fuse',
                    },
                    allowNull = true,
                })
                local firerate = box:slider(ui.id('weapons-firerate'), {
                    text = 'firerate',
                    default = 100,
                    min = 10,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })
                local meleeCooldown = box:slider(ui.id('weapons-melee-cooldown'), {
                    text = 'melee cooldown',
                    default = 100,
                    min = 10,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                    tooltip = "how much of each swing's cooldown is kept",
                })
                local meleeReach = box:toggle(ui.id('weapons-melee-reach'), {
                    text = 'melee reach',
                    default = false,
                    tooltip = 
[[your light swings reach players past your weapon's own reach, sent as if swung right in front of them]],
                })
                local meleeReachKey = meleeReach:keybind(ui.id('weapons-melee-reach-key'), {
                    text = 'melee reach',
                })
                local reachDistance = box:dependent(function()
                    return meleeReach.value
                end):slider(ui.id('weapons-melee-reach-distance'), {
                    text = 'reach distance',
                    default = 20,
                    min = 5,
                    max = 100,
                    rounding = 0,
                    suffix = 's',
                    tooltip = 
[[how far, in studs, a player may be for a swing to reach them]],
                })
                local reachSettings = {
                    active = false,
                    reach = 20,
                }
                local settings = {
                    noSpread = false,
                    fullAuto = false,
                    firerate = 100,
                    meleeCooldown = 100,
                    grenade = {},
                }

                return alwaysBackstab, meleeReach, function()
                    reachSettings.active, reachSettings.reach = meleeReachKey:active(), reachDistance.value

                    return reachSettings
                end, function()
                    settings.noSpread, settings.fullAuto = noSpread.value, fullAuto.value
                    settings.firerate, settings.meleeCooldown = firerate.value, meleeCooldown.value
                    settings.grenade = grenade.value

                    return settings
                end
            end
            local function ragebot(rage, priority, ui)
                local toggle = rage:toggle(ui.id('ragebot'), {
                    text = 'enabled',
                    default = false,
                })
                local key = toggle:keybind(ui.id('ragebot-key'), {
                    text = 'ragebot',
                })

                rage = rage:dependent(function()
                    return toggle.value
                end)

                local voidSpam = rage:toggle(ui.id('ragebot-void-spam'), {
                    text = 'void spam',
                    default = true,
                })
                local spam = rage:dependent(function()
                    return voidSpam.value
                end)
                local hide = spam:slider(ui.id('ragebot-void-spam-hide'), {
                    text = 'hide',
                    default = 0.25,
                    min = 0.01,
                    max = 1,
                    rounding = 2,
                    suffix = 's',
                    tooltip = 'how long it stays in void for',
                })
                local attack = hide:slider(ui.id('ragebot-void-spam-attack'), {
                    text = 'attack',
                    default = 0.1,
                    min = 0.01,
                    max = 1,
                    rounding = 2,
                    suffix = 's',
                    tooltip = 'the amount of time attacking before hiding again',
                })
                local attempts = rage:slider(ui.id('ragebot-shoot-attempts'), {
                    text = 'shoot attempts',
                    default = 1,
                    min = 1,
                    max = 2,
                    rounding = 0,
                    suffix = 'x',
                    tooltip = 'how many times it will try to fire your weapon',
                })
                local mode = rage:dropdown(ui.id('ragebot-mode'), {
                    text = 'attack mode',
                    values = {
                        'gun',
                        'knife',
                        'melee',
                    },
                    default = 'gun',
                    tooltip = 'how the ragebot fights, defaulting to gun if not possible',
                })
                local weapon = rage:dropdown(ui.id('ragebot-weapon'), {
                    text = 'preferred weapon',
                    values = {
                        'primary',
                        'secondary',
                    },
                    default = 'primary',
                    tooltip = 'which weapon the ragebot will use first',
                })
                local options = rage:multiDropdown(ui.id('ragebot-settings'), {
                    text = 'settings',
                    values = {
                        'swap weapons when empty',
                    },
                    allowNull = true,
                })
                local autoPrioritize = priority:toggle(ui.id('ragebot-priority'), {
                    text = 'auto prioritize',
                    default = false,
                    tooltip = 'prioritizes players for ragebot',
                })
                local listed = priority:dependent(function()
                    return autoPrioritize.value
                end)
                local notify = listed:toggle(ui.id('ragebot-priority-notification'), {
                    text = 'send notification',
                    default = true,
                    tooltip = 'sends a notification when a player is added to the priority',
                })
                local join = listed:multiDropdown(ui.id('ragebot-priority-settings'), {
                    text = 'auto priority settings',
                    values = {
                        'attackers',
                        'voided players',
                    },
                    default = {
                        'attackers',
                        'voided players',
                    },
                    tooltip = 'set how auto priority will target',
                })
                local settings = {
                    active = false,
                    voidSpam = true,
                    voidHide = 0.25,
                    voidAttack = 0.1,
                    shootAttempts = 1,
                    mode = 'gun',
                    primary = true,
                    swapWhenEmpty = false,
                    autoPrioritize = false,
                    notify = true,
                    join = {},
                }

                return toggle, function()
                    settings.active, settings.voidSpam = key:active(), voidSpam.value
                    settings.voidHide, settings.voidAttack = hide.value, attack.value
                    settings.shootAttempts, settings.mode = attempts.value, mode.value or 'gun'
                    settings.primary = weapon.value ~= 'secondary'
                    settings.swapWhenEmpty = options.value['swap weapons when empty'] == true
                    settings.autoPrioritize, settings.notify, settings.join = autoPrioritize.value, notify.value, join.value

                    return settings
                end
            end

            local Main = {}

            function Main.build(ui)
                local tab = ui.tab('main')
                local aimBox = tab:tabbox('Left')
                local silentToggle, readSilent = silentAim(aimBox:tab('silent aim'), ui)
                local aimbotToggle, readAimbot = aimbot(aimBox:tab('aimbot'), ui)
                local triggerToggle, readTrigger = triggerbot(tab:tabbox('Right'):tab('triggerbot'), ui)
                local readTargeting = targeting(tab:groupbox('Left', 'targeting'), ui)
                local backstabToggle, reachToggle, readReach, readWeapons = weapons(tab:tabbox('Right'):tab('weapons'), ui)
                local rage = tab:tabbox('Right')
                local rageBox, priorityBox, counterBox = rage:tab('ragebot'), rage:tab('priority'), rage:tab('counter')
                local rageToggle, readRagebot = ragebot(rageBox, priorityBox, ui)
                local aim = {
                    active = false,
                    radius = 100,
                    aimRadius = 100,
                    part = 'Head',
                    closestPart = false,
                    aimClosestPart = false,
                    closestBlacklist = {},
                    manipulation = false,
                    visibleOnly = false,
                    ignoreProtected = false,
                    ignoreIf = {},
                    limitDistance = false,
                    maxDistance = 250,
                    reactionTime = 0,
                    forgetTime = 1,
                    disableOnFlash = false,
                    hitChance = 100,
                    visualize = true,
                    look = FovControls.look(),
                    aimActive = false,
                    closestPosition = false,
                    delayPosition = false,
                    smoothX = 1,
                    smoothY = 1,
                    smoothJump = 1,
                    smoothing = 1,
                    aimLook = FovControls.look(),
                }

                return {
                    silentAim = silentToggle,
                    aimbot = aimbotToggle,
                    triggerbot = triggerToggle,
                    ragebot = rageToggle,
                    alwaysBackstab = backstabToggle,
                    meleeReach = reachToggle,
                    aim = function()
                        readSilent(aim)
                        readAimbot(aim)
                        readTargeting(aim)

                        return aim
                    end,
                    triggerbotSettings = readTrigger,
                    weaponSettings = readWeapons,
                    meleeReachSettings = readReach,
                    ragebotSettings = readRagebot,
                    counterBox = counterBox,
                }
            end

            return table.freeze(Main)
        end

        function __ANTIBRAIN_MODULES.ae()
            local v = __ANTIBRAIN_MODULES.cache.ae

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ae = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Modules = __ANTIBRAIN_MODULES.l()
            local Cosmetics = {}

            function Cosmetics.load()
                local cosmetics = Modules.shared('CosmeticLibrary')
                local shop = Modules.shared('ShopLibrary')
                local weapons, seen = {}, {}

                for _, weapon in shop.OwnableWeapons do
                    if type(weapon) == 'string' and not seen[weapon] then
                        seen[weapon] = true

                        table.insert(weapons, weapon)
                    end
                end

                local skins = {}
                local pools = {
                    wrap = {},
                    charm = {},
                    finisher = {},
                }

                for name, cosmetic in cosmetics.Cosmetics do
                    if type(cosmetic) == 'table' then
                        if cosmetic.Type == 'Skin' and type(cosmetic.ItemName) == 'string' then
                            local list = skins[cosmetic.ItemName] or {}

                            skins[cosmetic.ItemName] = list

                            table.insert(list, name)
                        elseif cosmetic.Type == 'Wrap' then
                            table.insert(pools.wrap, name)
                        elseif cosmetic.Type == 'Charm' then
                            table.insert(pools.charm, name)
                        elseif cosmetic.Type == 'Finisher' then
                            table.insert(pools.finisher, name)
                        end
                    end
                end

                return {
                    weapons = weapons,
                    skins = skins,
                    pools = pools,
                    libraries = {
                        cosmetics = cosmetics,
                        items = Modules.shared('ItemLibrary'),
                        utility = Modules.shared('Utility'),
                        enums = Modules.shared('EnumLibrary'),
                    },
                    viewModels = Modules.viewModels(),
                }
            end
            function Cosmetics.pool(catalog, weapon, kind)
                if kind == 'skin' then
                    return catalog.skins[weapon] or {}
                end

                return catalog.pools[kind] or {}
            end
            function Cosmetics.validSkin(catalog, weapon, name)
                local skins = catalog.skins[weapon]

                if not skins or not table.find(skins, name) then
                    return false
                end

                local cosmetic = catalog.libraries.cosmetics.Cosmetics[name]
                local items = catalog.libraries.items

                if type(cosmetic) ~= 'table' or cosmetic.Type ~= 'Skin' or cosmetic.ItemName ~= weapon then
                    return false
                end
                if type(items.ViewModels) ~= 'table' or items.ViewModels[name] == nil then
                    return false
                end

                local ok, found = pcall(function()
                    return catalog.libraries.utility:LookThrough(catalog.viewModels, name)
                end)

                return ok and found ~= nil
            end
            function Cosmetics.weaponImage(catalog, weapon, skin)
                local viewModels = catalog.libraries.items.ViewModels

                if type(viewModels) ~= 'table' then
                    return 'rbxassetid://0'
                end

                local entry = viewModels[weapon]

                if skin and skin ~= weapon then
                    local skins = catalog.skins[weapon]
                    local at = (skins and {
                        (table.find(skins, skin)),
                    } or {nil})[1]
                    local known = (skins and at and {
                        skins[at],
                    } or {nil})[1]

                    if known then
                        entry = viewModels[known] or catalog.libraries.cosmetics.Cosmetics[known] or entry
                    end
                end
                if type(entry) ~= 'table' then
                    return 'rbxassetid://0'
                end

                return entry.ImageHighResolution or entry.Image or 'rbxassetid://0'
            end
            function Cosmetics.cosmeticImage(catalog, name)
                local cosmetic = catalog.libraries.cosmetics.Cosmetics[name]

                return (type(cosmetic) == 'table' and type(cosmetic.Image) == 'string' and {
                    cosmetic.Image,
                } or {
                    '',
                })[1]
            end

            return table.freeze(Cosmetics)
        end

        function __ANTIBRAIN_MODULES.af()
            local v = __ANTIBRAIN_MODULES.cache.af

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.af = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Selection = {}

            Selection.kinds = table.freeze({
                'skin',
                'wrap',
                'charm',
                'finisher',
            })

            local function fresh()
                local choices = {}

                for _, kind in Selection.kinds do
                    choices[kind] = {
                        name = nil,
                        random = false,
                        enabled = true,
                    }
                end

                return choices
            end

            function Selection.new(weapons)
                local selection = {}

                for _, weapon in weapons do
                    selection[weapon] = fresh()
                end

                return selection
            end
            function Selection.reset(selection)
                for weapon in selection do
                    selection[weapon] = fresh()
                end
            end
            function Selection.choose(selection, weapon, kind, name)
                local choice = selection[weapon][kind]

                choice.name = (choice.name ~= name and {name} or {nil})[1]
                choice.random = false
            end
            function Selection.toggleRandom(selection, weapon, kind)
                local choice = selection[weapon][kind]

                choice.random = not choice.random

                if choice.random then
                    choice.name = nil
                end
            end
            function Selection.toggle(selection, weapon, kind)
                local choice = selection[weapon][kind]

                choice.enabled = not choice.enabled

                return choice.enabled
            end
            function Selection.applyToAll(selection, weapon, kind)
                local source = selection[weapon][kind]

                if kind == 'skin' and not source.random then
                    return nil
                end

                for _, choices in selection do
                    local choice = choices[kind]

                    choice.name = (source.random and {nil} or {
                        source.name,
                    })[1]
                    choice.random = source.random
                end

                return source.random and 'random' or string.lower(source.name or 'none')
            end
            function Selection.pick(selection, weapon, kind, pool, roll)
                local choices = selection[weapon]
                local choice = (choices and {
                    choices[kind],
                } or {nil})[1]

                if not choice or not choice.enabled then
                    return nil
                end
                if choice.random and pool and #pool > 0 then
                    return pool[roll(#pool)]
                end

                return choice.name
            end
            function Selection.load(selection, saved, validSkin)
                if type(saved) ~= 'table' then
                    return
                end

                for weapon, choices in saved do
                    if type(weapon) == 'string' and selection[weapon] and type(choices) == 'table' then
                        local loaded = fresh()

                        for _, kind in Selection.kinds do
                            local choice = choices[kind]

                            if type(choice) == 'table' then
                                local target = loaded[kind]

                                target.name = (type(choice.name) == 'string' and {
                                    choice.name,
                                } or {nil})[1]
                                target.random = choice.random == true
                                target.enabled = choice.enabled ~= false
                                target.inverted = choice.inverted == true and true or nil
                            end
                        end

                        local skin = loaded.skin

                        if skin.name and not validSkin(weapon, skin.name) then
                            skin.name, skin.random = nil, false
                        end

                        selection[weapon] = loaded
                    end
                end
            end

            return table.freeze(Selection)
        end

        function __ANTIBRAIN_MODULES.ag()
            local v = __ANTIBRAIN_MODULES.cache.ag

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ag = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Cosmetics = __ANTIBRAIN_MODULES.af()
            local Failure = __ANTIBRAIN_MODULES.a()
            local FighterEvents = __ANTIBRAIN_MODULES.Z()
            local Hooks = __ANTIBRAIN_MODULES.w()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Selection = __ANTIBRAIN_MODULES.ag()

            __ANTIBRAIN_MODULES.m()

            local TRANSIENT = table.freeze({
                ItemIndex = true,
                FOVOffset = true,
                IsAiming = true,
            })
            local FINISHER, FINISHER_HOOK = '_PlayFinisher', '\0_PlayFinisher '

            local function deepCopy(value)
                if type(value) ~= 'table' then
                    return value
                end

                local copy = {}

                for key, inner in value do
                    copy[key] = deepCopy(inner)
                end

                return copy
            end
            local function roll(count)
                return math.random(1, count)
            end
            local function pick(wardrobe, weapon, kind)
                return Selection.pick(wardrobe.selection(), weapon, kind, Cosmetics.pool(wardrobe.catalog, weapon, kind), roll)
            end
            local function skinFor(wardrobe, weapon)
                local name = pick(wardrobe, weapon, 'skin')

                return (name and Cosmetics.validSkin(wardrobe.catalog, weapon, name) and {name} or {nil})[1]
            end
            local function replace(wardrobe, target, key, make)
                local existing = target[key]

                assert(type(existing) == 'function', string.format('RIVALS %s is unavailable', tostring(key)))
                Hooks.hook(wardrobe.run, wardrobe.access, existing, make)
            end
            local function dressViewModels(wardrobe)
                local selection, fighters, ids = wardrobe.selection, wardrobe.fighters, wardrobe.ids

                replace(wardrobe, Modules.client({
                    'ClientReplicatedClasses',
                    'ClientFighter',
                    'ClientItem',
                }), '_CreateViewModel', function(original)
                    return function(self, data, ...)
                        local itemData = (type(data) == 'table' and {
                            data[ids.data],
                        } or {nil})[1]

                        if type(self) == 'table' and self.ClientFighter == fighters.LocalFighter and type(itemData) == 'table' and selection()[self.Name] then
                            pcall(function()
                                local weapon = self.Name
                                local skin = skinFor(wardrobe, weapon)

                                if skin then
                                    itemData[ids.name] = skin
                                end

                                local charm = pick(wardrobe, weapon, 'charm')

                                if charm then
                                    itemData[ids.charm] = {Name = charm}
                                end

                                local wrap = pick(wardrobe, weapon, 'wrap')

                                if wrap then
                                    itemData[ids.wrap] = {
                                        Name = wrap,
                                        Inverted = selection()[weapon].wrap.inverted,
                                    }
                                end
                            end)
                        end

                        return original(self, data, ...)
                    end
                end)
            end
            local function dressImages(wardrobe)
                local selection = wardrobe.selection

                replace(wardrobe, wardrobe.catalog.libraries.items, 'GetViewModelImage', function(
                    original
                )
                    return function(self, name, ...)
                        local choices = (type(name) == 'string' and {
                            selection()[name],
                        } or {nil})[1]
                        local skin = (choices and {
                            choices.skin,
                        } or {nil})[1]

                        if skin and (skin.name or skin.random) and debug.traceback():find('.PickWeapons', 1, true) then
                            name = skinFor(wardrobe, name) or name
                        end

                        return original(self, name, ...)
                    end
                end)
            end
            local function dressFinishers(wardrobe)
                local run, access, fighters, player = wardrobe.run, wardrobe.access, wardrobe.fighters, wardrobe.player
                local entity = Modules.client({
                    'ClientReplicatedClasses',
                    'ClientEntity',
                })
                local replicateFromServer, playFinisher = entity.ReplicateFromServer, entity._PlayFinisher

                assert(type(replicateFromServer) == 'function', 'RIVALS ClientEntity.ReplicateFromServer is unavailable')
                assert(type(playFinisher) == 'function', 'RIVALS ClientEntity._PlayFinisher is unavailable')

                local function isLocal(owner)
                    return typeof(owner) == 'Instance' and owner:IsA('Player') and owner.UserId == player.UserId
                end

                local finish = function(self, finisher, detail, owner, ...)
                    local fighter = fighters.LocalFighter
                    local item = (isLocal(owner) and type(fighter) == 'table' and {
                        fighter.EquippedItem,
                    } or {nil})[1]

                    if type(item) == 'table' and type(item.Name) == 'string' then
                        finisher = pick(wardrobe, item.Name, 'finisher') or finisher
                    end

                    return playFinisher(self, finisher, detail, owner, ...)
                end

                access.disguise(finish, playFinisher)
                rawset(entity, FINISHER_HOOK, finish)
                run:add(function()
                    if rawget(entity, FINISHER_HOOK) == finish then
                        rawset(entity, FINISHER_HOOK, nil)
                    end
                end)
                Hooks.swapConstant(run, access, replicateFromServer, FINISHER, FINISHER_HOOK, 'the _PlayFinisher name in ClientEntity.ReplicateFromServer')
            end
            local function keepOriginals(wardrobe)
                local originals = {}
                local ids = wardrobe.ids

                FighterEvents.listen(wardrobe.run, wardrobe.services, function(
                    kind,
                    payload
                )
                    local data = (kind == 'ItemAdded' and type(payload) == 'table' and {
                        payload[ids.data],
                    } or {nil})[1]
                    local id = (type(data) == 'table' and {
                        data[ids.objectId],
                    } or {nil})[1]

                    if id ~= nil then
                        originals[id] = deepCopy(payload)
                    end
                end)

                return originals
            end
            local function firstSent(wardrobe, originals, item, id)
                local sent = originals[id]

                if sent then
                    return sent
                end

                local enums, ids = wardrobe.enums, wardrobe.ids
                local base = {
                    [ids.data] = {},
                    [ids.viewModel] = {
                        [ids.data] = {},
                    },
                }

                for key, value in item.Data do
                    local enum = (TRANSIENT[key] and {nil} or {
                        (enums:ToEnum(key, true)),
                    })[1]

                    if enum then
                        base[ids.data][enum] = value
                    end
                end
                for key, value in item.ViewModel.Data do
                    local enum = enums:ToEnum(key, true)

                    if enum then
                        base[ids.viewModel][ids.data][enum] = value
                    end
                end

                return base
            end
            local function payloadOf(wardrobe, base, item)
                local enums, ids = wardrobe.enums, wardrobe.ids
                local payload = deepCopy(base)

                for key, value in item.Data do
                    local enum = ((TRANSIENT[key] or key == 'Name') and {nil} or {
                        (enums:ToEnum(key, true)),
                    })[1]

                    if enum then
                        payload[ids.data][enum] = value
                    end
                end

                return payload
            end
            local function redresser(wardrobe, originals)
                local enums, selection, fighters = wardrobe.enums, wardrobe.selection, wardrobe.fighters
                local replicate = Modules.remote({
                    'Replication',
                    'Fighter',
                    'Replicate',
                })

                assert(replicate:IsA('RemoteEvent'), string.format('RIVALS Replicate is a %s, not a RemoteEvent', tostring(replicate.ClassName)))

                local CHANGED, ADDED, REMOVED = enums:ToEnum('ReplicationChanged'), enums:ToEnum('ItemAdded'), enums:ToEnum('ItemRemoved')

                local function replicateTo(fighter, ...)
                    for _, connection in getconnections(replicate.OnClientEvent)do
                        local handler = connection.Function

                        if handler then
                            handler(CHANGED, fighter:Get('ObjectID'), ...)
                        end
                    end
                end

                return function()
                    local fighter = fighters.LocalFighter

                    if type(fighter) ~= 'table' or type(getconnections) ~= 'function' then
                        return
                    end

                    local equipped = fighter.EquippedItem
                    local equippedIndex = (type(equipped) == 'table' and type(equipped.Data) == 'table' and {
                        equipped.Data.ItemIndex,
                    } or {nil})[1]
                    local remade = {}
                    local count = 0

                    for index, item in fighter.Items do
                        if type(item) == 'table' and item.ViewModel and selection()[item.Name] then
                            local id = item:Get('ObjectID')
                            local payload = payloadOf(wardrobe, firstSent(wardrobe, originals, item, id), item)

                            remade[index] = {
                                payload = payload,
                                id = id,
                            }
                            count = count + 1
                        end
                    end

                    if count == 0 then
                        return
                    end

                    local firstFailure = nil

                    local function attempt(callback, ...)
                        local failure = Failure.capture(callback, ...)

                        if failure and not firstFailure then
                            firstFailure = failure
                        end
                    end

                    if equippedIndex then
                        attempt(fighter.EquipItem, fighter, nil)
                    end

                    for _, weapon in remade do
                        attempt(replicateTo, fighter, REMOVED, weapon.id)
                    end

                    local setIdentity = setthreadidentity

                    for index, weapon in remade do
                        if type(setIdentity) == 'function' then
                            setIdentity(1)
                        end

                        attempt(replicateTo, fighter, ADDED, weapon.payload, index)

                        if type(setIdentity) == 'function' then
                            setIdentity(8)
                        end
                    end

                    if equippedIndex then
                        attempt(fighter.EquipItem, fighter, equippedIndex)
                    end
                    if firstFailure then
                        error(firstFailure, 0)
                    end
                end
            end

            local Dresser = {}

            function Dresser.start(run, catalog, selection, fighters, services)
                assert(type(getconnections) == 'function', 'RIVALS skin changer needs getconnections')

                local player = Modules.player()
                local access = Hooks.executor()
                local enums = catalog.libraries.enums
                local wardrobe = {
                    run = run,
                    access = access,
                    catalog = catalog,
                    selection = selection,
                    fighters = fighters,
                    services = services,
                    enums = enums,
                    player = player,
                    ids = {
                        data = enums:ToEnum('Data'),
                        name = enums:ToEnum('Name'),
                        charm = enums:ToEnum('Charm'),
                        wrap = enums:ToEnum('Wrap'),
                        objectId = enums:ToEnum('ObjectID'),
                        viewModel = enums:ToEnum('ViewModel'),
                    },
                }

                dressViewModels(wardrobe)
                dressImages(wardrobe)
                dressFinishers(wardrobe)

                return {
                    redress = redresser(wardrobe, keepOriginals(wardrobe)),
                }
            end

            return table.freeze(Dresser)
        end

        function __ANTIBRAIN_MODULES.ah()
            local v = __ANTIBRAIN_MODULES.cache.ah

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ah = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.ag()

            local Listing = {}

            Listing.RANDOM = '!Random'

            local RANDOM_IMAGE, RANDOM_ZOOM = 'rbxassetid://94238795177693', 0.5
            local FINISHER_ZOOM = 1

            function Listing.ordered(weapons, owned)
                local known = {}

                for _, weapon in weapons do
                    known[weapon] = true
                end

                local ordered = {}
                local placed = {}

                for _, weapon in owned do
                    if known[weapon] and not placed[weapon] then
                        placed[weapon] = true

                        table.insert(ordered, weapon)
                    end
                end
                for _, weapon in weapons do
                    if not placed[weapon] then
                        placed[weapon] = true

                        table.insert(ordered, weapon)
                    end
                end

                return ordered
            end

            local function matches(name, filter)
                return filter == '' or name:lower():find(filter:lower(), 1, true) ~= nil
            end

            function Listing.weapons(
                selection,
                weapons,
                filter,
                mode,
                current,
                imageOf
            )
                local items = {}

                for _, weapon in weapons do
                    if matches(weapon, filter) then
                        local choices = selection[weapon]
                        local off = not choices[mode].enabled

                        table.insert(items, {
                            key = weapon,
                            text = (off and {
                                string.format('%s%s Off', tostring(mode:sub(1, 1):upper()), tostring(mode:sub(2))),
                            } or {weapon})[1],
                            image = imageOf(weapon, choices.skin.name),
                            selected = weapon == current,
                            off = off,
                        })
                    end
                end

                return items
            end
            function Listing.cosmetics(
                selection,
                weapon,
                mode,
                pool,
                filter,
                imageOf,
                viewOf
            )
                local choice = selection[weapon][mode]
                local items = {
                    {
                        key = Listing.RANDOM,
                        text = 'Random',
                        image = RANDOM_IMAGE,
                        zoom = RANDOM_ZOOM,
                        selected = choice.random,
                    },
                }
                local names = table.clone(pool)

                table.sort(names)

                if mode == 'skin' then
                    local skins = names

                    names = {weapon}

                    for _, name in skins do
                        if name ~= weapon then
                            table.insert(names, name)
                        end
                    end
                end

                local model = mode == 'wrap' or mode == 'charm'

                for _, name in names do
                    if matches(name, filter) then
                        table.insert(items, {
                            key = name,
                            text = name,
                            image = model and '' or imageOf(name),
                            zoom = (mode == 'finisher' and {FINISHER_ZOOM} or {nil})[1],
                            selected = not choice.random and choice.name == name,
                            view = (model and {
                                (viewOf(name)),
                            } or {nil})[1],
                        })
                    end
                end

                return items
            end

            return table.freeze(Listing)
        end

        function __ANTIBRAIN_MODULES.ai()
            local v = __ANTIBRAIN_MODULES.cache.ai

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ai = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Framing = {}
            local MARGIN = 0.1
            local NEAREST = 0.1

            function Framing.distance(corners, fov)
                local reach = math.tan(math.rad(fov) / 2)
                local distance = NEAREST

                for _, corner in corners do
                    distance = math.max(distance, math.max(math.abs(corner.x), math.abs(corner.y)) / reach - corner.z)
                end

                return distance * (1 + MARGIN)
            end
            function Framing.fit(points, fov)
                assert(#points > 0, 'There is nothing to frame')

                local first = points[1]
                local low = {
                    x = first.x,
                    y = first.y,
                    z = first.z,
                }
                local high = {
                    x = first.x,
                    y = first.y,
                    z = first.z,
                }

                for _, point in points do
                    low.x, low.y, low.z = math.min(low.x, point.x), math.min(low.y, point.y), math.min(low.z, point.z)
                    high.x, high.y, high.z = math.max(high.x, point.x), math.max(high.y, point.y), math.max(high.z, point.z)
                end

                local middle = {
                    x = (low.x + high.x) / 2,
                    y = (low.y + high.y) / 2,
                    z = (low.z + high.z) / 2,
                }
                local half = {
                    x = (high.x - low.x) / 2,
                    y = (high.y - low.y) / 2,
                    z = (high.z - low.z) / 2,
                }
                local corners = {}

                for _, x in {
                    -1,
                    1,
                }do
                    for _, y in {
                        -1,
                        1,
                    }do
                        for _, z in {
                            -1,
                            1,
                        }do
                            table.insert(corners, {
                                x = x * half.x,
                                y = y * half.y,
                                z = z * half.z,
                            })
                        end
                    end
                end

                return middle, Framing.distance(corners, fov)
            end

            return table.freeze(Framing)
        end

        function __ANTIBRAIN_MODULES.aj()
            local v = __ANTIBRAIN_MODULES.cache.aj

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aj = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Framing = __ANTIBRAIN_MODULES.aj()
            local Identity = __ANTIBRAIN_MODULES._()
            local Modules = __ANTIBRAIN_MODULES.l()

            __ANTIBRAIN_MODULES.c()

            local Preview = {}

            Preview.KINDS = table.freeze({
                'wrap',
                'charm',
            })

            function Preview.new(run)
                local previews = {
                    run = run,
                    views = {
                        wrap = {},
                        charm = {},
                    },
                    parts = nil,
                }

                run:add(function()
                    table.clear(previews.views.wrap)
                    table.clear(previews.views.charm)
                end)

                return previews
            end
            function Preview.cached(previews, kind, name)
                local byName = previews.views[kind]

                return (byName and {
                    byName[name],
                } or {nil})[1]
            end

            local function parts(previews)
                local held = previews.parts

                if held then
                    return held
                end

                local frame = Modules.interface({
                    'CosmeticViewportFrame',
                })

                assert(frame:IsA('ViewportFrame'), 'RIVALS CosmeticViewportFrame is not a ViewportFrame')

                local found = {
                    frame = frame,
                    wrap = Modules.asset({
                        'Misc',
                        'Wrap',
                    }),
                    charms = Modules.asset({
                        'Charms',
                    }),
                    cameras = Modules.client({
                        'ViewportCameras',
                    }),
                    wraps = Modules.controller('WrapController'),
                }

                previews.parts = found

                return found
            end
            local function frameLike(frame, template)
                frame.BackgroundTransparency = template.BackgroundTransparency
                frame.BackgroundColor3 = template.BackgroundColor3
                frame.BorderSizePixel = 0
                frame.Ambient = template.Ambient
                frame.LightColor = template.LightColor
                frame.LightDirection = template.LightDirection
                frame.ImageColor3 = template.ImageColor3
                frame.ImageTransparency = template.ImageTransparency
            end
            local function charm(found, frame, name)
                local source = found.charms:FindFirstChild(name)

                assert(source, string.format('RIVALS has no charm model %s', tostring(name)))

                local model = (source:Clone())

                model.Parent = frame
                model.PrimaryPart = (model:FindFirstChild('Primary'))

                model:PivotTo(CFrame.identity)

                local hook = model:FindFirstChild('Hook')

                if hook then
                    hook:Destroy()
                end

                frame.CurrentCamera = found.cameras.Charm
            end
            local function wrap(found, frame, name)
                local model = (found.wrap:Clone())

                model.Parent = frame

                model:PivotTo(CFrame.identity)

                frame.CurrentCamera = found.cameras.Wrap

                local record = found.wraps:RecordOriginalWrapProperties(model)

                for _, piece in record do
                    piece.IgnoreObject = true
                end

                found.wraps:ApplyWrap(record, {Name = name})
            end
            local function seen(model, right, up, look)
                local points = {}

                local function add(box, size)
                    for _, x in {
                        -1,
                        1,
                    }do
                        for _, y in {
                            -1,
                            1,
                        }do
                            for _, z in {
                                -1,
                                1,
                            }do
                                local at = box * Vector3.new(x * size.X / 2, y * size.Y / 2, z * size.Z / 2)

                                table.insert(points, {
                                    x = at:Dot(right),
                                    y = at:Dot(up),
                                    z = at:Dot(look),
                                })
                            end
                        end
                    end
                end

                for _, part in model:GetDescendants()do
                    if part:IsA('BasePart') and part.Transparency < 0.95 then
                        add(part.CFrame, part.Size)
                    end
                end

                if #points == 0 then
                    local box, size = model:GetBoundingBox()

                    if size.Magnitude > 0 then
                        add(box, size)
                    end
                end

                return points
            end
            local function framed(frame, source)
                local model = frame:FindFirstChildOfClass('Model')

                if not model then
                    return
                end

                local look, fov = Vector3.new(0, -0.3, -1).Unit, 30

                if typeof(source) == 'Instance' and source:IsA('Camera') then
                    look, fov = source.CFrame.LookVector, source.FieldOfView
                end

                local right = look:Cross(Vector3.yAxis)

                right = ((right.Magnitude < 0.001 and {
                    Vector3.xAxis,
                } or {right})[1]).Unit

                local up = right:Cross(look)
                local points = seen(model, right, up, look)

                if #points == 0 then
                    return
                end

                local middle, distance = Framing.fit(points, fov)
                local center = right * middle.x + up * middle.y + look * middle.z
                local camera = Instance.new('Camera')

                camera.Parent = frame
                camera.FieldOfView = fov
                camera.CFrame = CFrame.lookAt(center - look * distance, center)
                frame.CurrentCamera = camera
            end

            local slotTitle = nil

            function Preview.slotTitle()
                local held = slotTitle

                if held then
                    return held
                end

                local ok, found = pcall(Modules.interface, {
                    'CosmeticSlot',
                    'Button',
                    'Title',
                })

                if ok and found:IsA('TextLabel') then
                    slotTitle = found

                    return found
                end

                return nil
            end
            function Preview.make(previews, kind, name)
                assert(not previews.run.closed, 'The preview scope is closed')

                local byName = previews.views[kind]

                assert(byName, string.format('%s cosmetics have no preview', tostring(kind)))

                local found = parts(previews)

                assert(not previews.run.closed, 'The preview scope is closed')

                local frame = Instance.new('ViewportFrame')
                local detach = previews.run:add(function()
                    frame:Destroy()
                end)
                local failure = Failure.capture(function()
                    frameLike(frame, found.frame)

                    if kind == 'charm' then
                        charm(found, frame, name)
                    else
                        wrap(found, frame, name)
                    end
                end)

                if previews.run.closed then
                    detach()
                    error('The preview scope closed during setup', 0)
                end
                if not failure then
                    Failure.capture(framed, frame, (kind == 'charm' and {
                        found.cameras.Charm,
                    } or {
                        found.cameras.Wrap,
                    })[1])
                end

                local identityFailure = Failure.capture(Identity.restore)

                failure = failure or identityFailure

                if failure then
                    local cleanupFailure = Failure.capture(function()
                        frame:Destroy()
                    end)

                    if cleanupFailure then
                        previews.run:report(cleanupFailure)
                    else
                        detach()
                    end

                    error(failure, 0)
                end

                byName[name] = frame

                return frame
            end

            return table.freeze(Preview)
        end

        function __ANTIBRAIN_MODULES.ak()
            local v = __ANTIBRAIN_MODULES.cache.ak

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ak = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Cosmetics = __ANTIBRAIN_MODULES.af()
            local Dresser = __ANTIBRAIN_MODULES.ah()
            local Failure = __ANTIBRAIN_MODULES.a()
            local FighterEvents = __ANTIBRAIN_MODULES.Z()

            __ANTIBRAIN_MODULES.g()

            local Identity = __ANTIBRAIN_MODULES._()
            local Listing = __ANTIBRAIN_MODULES.ai()
            local Modules = __ANTIBRAIN_MODULES.l()
            local Preview = __ANTIBRAIN_MODULES.ak()

            __ANTIBRAIN_MODULES.c()

            local Selection = __ANTIBRAIN_MODULES.ag()

            __ANTIBRAIN_MODULES.m()

            local Services = __ANTIBRAIN_MODULES.k()
            local SkinChanger = {}

            SkinChanger.KINDS = Selection.kinds
            SkinChanger.slotTitle = Preview.slotTitle

            local BATCH = 6

            function SkinChanger.start(run, controls, window, log, services)
                local fighters = Modules.controller('FighterController')
                local catalog = Cosmetics.load()
                local selection = Selection.new(catalog.weapons)

                local function validSkin(weapon, name)
                    return Cosmetics.validSkin(catalog, weapon, name)
                end

                local saved = ''

                local function loadSaved(value)
                    saved = value
                    selection = Selection.new(catalog.weapons)

                    if value ~= '' then
                        local ok, decoded = pcall(Services.HttpService.JSONDecode, Services.HttpService, value)

                        if ok then
                            Selection.load(selection, decoded, validSkin)
                        end
                    end
                end

                loadSaved(controls.data.value)

                local dresser = nil

                run:add(function()
                    local last = dresser

                    if last then
                        task.spawn(function()
                            local failure = Failure.capture(last.redress)

                            if failure then
                                log(string.format('The skin changer could not put the weapons back: %s', tostring(failure)))
                            end
                        end)
                    end
                end)

                dresser = Dresser.start(run, catalog, function()
                    return selection
                end, fighters, services)

                local function redress()
                    local current = dresser

                    if not current then
                        return
                    end

                    run:spawn(function()
                        local failure = Failure.capture(current.redress)

                        if failure then
                            log(string.format('The skin changer could not remake the weapons: %s', tostring(failure)))
                        end
                    end)
                end
                local function owned()
                    local fighter = fighters.LocalFighter
                    local items = (type(fighter) == 'table' and {
                        fighter.Items,
                    } or {nil})[1]
                    local held = {}

                    if type(items) == 'table' then
                        for key, item in items do
                            if type(item) == 'table' and type(item.Name) == 'string' then
                                table.insert(held, {
                                    order = (type(key) == 'number' and {key} or {
                                        math.huge,
                                    })[1],
                                    name = item.Name,
                                })
                            end
                        end
                    end

                    table.sort(held, function(a, b)
                        return a.order < b.order
                    end)

                    local names = {}

                    for _, entry in held do
                        table.insert(names, entry.name)
                    end

                    return names
                end

                assert(#catalog.weapons > 0, 'the game lists no weapons')

                local weapon = Listing.ordered(catalog.weapons, owned())[1]
                local keptMode = controls.mode.value
                local mode = (keptMode and table.find(Selection.kinds, keptMode) and {keptMode} or {
                    'skin',
                })[1]
                local showing, loading = false, false

                local function weaponImage(name, skin)
                    return Cosmetics.weaponImage(catalog, name, skin)
                end
                local function cosmeticImage(name)
                    return (mode == 'skin' and {
                        (Cosmetics.weaponImage(catalog, weapon, name)),
                    } or {
                        (Cosmetics.cosmeticImage(catalog, name)),
                    })[1]
                end
                local function showWeapons()
                    controls.weapons:setItems(Listing.weapons(selection, Listing.ordered(catalog.weapons, owned()), controls.weaponFilter.value, mode, weapon, weaponImage))
                end

                local previews = Preview.new(run)

                local function viewOf(name)
                    return Preview.cached(previews, mode, name)
                end
                local function listCosmetics()
                    return Listing.cosmetics(selection, weapon, mode, Cosmetics.pool(catalog, weapon, mode), controls.cosmeticFilter.value, cosmeticImage, viewOf)
                end

                local failed = {}
                local building, told = false, false

                local function missing(items)
                    local names = {}

                    if table.find(Preview.KINDS, mode) then
                        for _, item in items do
                            if item.key ~= Listing.RANDOM and item.view == nil and not failed[string.format('%s\0%s', tostring(mode), tostring(item.key))] then
                                table.insert(names, item.key)
                            end
                        end
                    end

                    return names
                end
                local function build()
                    if building or #missing(listCosmetics()) == 0 then
                        return
                    end

                    building = true

                    run:spawn(function()
                        while true do
                            local names = missing(listCosmetics())

                            if #names == 0 then
                                break
                            end

                            for index = 1, math.min(#names, BATCH)do
                                local failure = Failure.capture(Preview.make, previews, mode, names[index])

                                if failure then
                                    failed[string.format('%s\0%s', tostring(mode), tostring(names[index]))] = true

                                    if not told then
                                        told = true

                                        log(string.format('The skin changer could not draw a preview: %s', tostring(failure)))
                                    end
                                end
                            end

                            controls.cosmetics:setItems(listCosmetics())
                            task.wait()
                        end

                        building = false
                    end)
                end
                local function showCosmetics()
                    controls.cosmetics:setItems(listCosmetics())
                    build()
                end
                local function show()
                    showing = true

                    controls.mode:set(mode)
                    controls.inverted:set(selection[weapon].wrap.inverted == true)

                    showing = false

                    showWeapons()
                    showCosmetics()
                end
                local function changed(remake)
                    saved = Services.HttpService:JSONEncode(selection)

                    controls.data:set(saved)
                    show()

                    if remake then
                        redress()
                    end
                end

                controls.actions.applyAll = function()
                    local applied = Selection.applyToAll(selection, weapon, mode)

                    if not applied then
                        window.notify('cant apply weapon skins to all!')

                        return
                    end

                    window.notify(string.format('applied %s: %s to all weapons', tostring(mode), tostring(applied)))
                    changed(true)
                end
                controls.actions.reset = function()
                    Selection.reset(selection)

                    mode = 'skin'

                    changed(true)
                end

                run:add(function()
                    controls.actions.applyAll, controls.actions.reset = nil, nil
                end)
                run:add(controls.data:onChanged(function(value)
                    if value == saved then
                        return
                    end

                    loadSaved(value)

                    if not loading then
                        loading = true

                        run:spawn(function()
                            task.wait()

                            loading = false

                            show()
                            redress()
                        end)
                    end

                    show()
                end))
                FighterEvents.listen(run, services, function(kind)
                    if kind == 'ItemAdded' or kind == 'ItemRemoved' then
                        run:spawn(function()
                            Identity.restore()
                            task.wait()
                            Identity.restore()
                            showWeapons()
                        end)
                    end
                end)
                run:add(controls.weaponFilter:onChanged(showWeapons))
                run:add(controls.cosmeticFilter:onChanged(showCosmetics))
                run:add(controls.mode:onChanged(function(value)
                    if not showing and value and table.find(Selection.kinds, value) then
                        mode = value

                        show()
                    end
                end))
                run:add(controls.inverted:onChanged(function(value)
                    if not showing and not loading then
                        selection[weapon].wrap.inverted = value and true or nil

                        changed(true)
                    end
                end))
                run:add(controls.weapons:onPressed(function(key, secondary)
                    if not selection[key] then
                        return
                    end
                    if secondary then
                        Selection.toggle(selection, key, mode)
                        changed(true)
                    else
                        weapon = key

                        controls.weaponFilter:set('')
                        show()
                    end
                end))
                run:add(controls.cosmetics:onPressed(function(key)
                    if key == Listing.RANDOM then
                        Selection.toggleRandom(selection, weapon, mode)
                    else
                        Selection.choose(selection, weapon, mode, key)
                    end

                    controls.weaponFilter:set('')
                    changed(mode ~= 'finisher')
                end))
                show()
                redress()
            end

            return table.freeze(SkinChanger)
        end

        function __ANTIBRAIN_MODULES.al()
            local v = __ANTIBRAIN_MODULES.cache.al

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.al = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Desync = __ANTIBRAIN_MODULES.F()

            __ANTIBRAIN_MODULES.c()
            __ANTIBRAIN_MODULES.m()

            local Services = __ANTIBRAIN_MODULES.k()
            local DEPTH = 5
            local REACH = 500
            local ORDER = 2

            local function resolve()
                local params = RaycastParams.new()

                params.FilterType = Enum.RaycastFilterType.Exclude

                local down = Vector3.new(0, -REACH, 0)
                local floor = function(from, character)
                    params.FilterDescendantsInstances = character and {character} or {}

                    local hit = Services.Workspace:Raycast(from, down, params)

                    return (hit and {
                        hit.Position.Y,
                    } or {nil})[1]
                end

                return {floor = floor}
            end

            local Underground = {}

            function Underground.start(run, active, services, dependencies)
                local deps = dependencies or resolve()
                local drop = Vector3.new(0, DEPTH, 0)
                local flat = CFrame.Angles(math.rad(90), 0, 0)

                Desync.join(run, services, ORDER, function(real, root)
                    if not active() then
                        return nil
                    end

                    local position = real.Position
                    local floor = deps.floor(position, root.Parent)
                    local hidden = (floor and {
                        (Vector3.new(position.X, floor - DEPTH, position.Z)),
                    } or {
                        (position - drop),
                    })[1]

                    return CFrame.new(hidden) * flat
                end)
            end

            return table.freeze(Underground)
        end

        function __ANTIBRAIN_MODULES.am()
            local v = __ANTIBRAIN_MODULES.cache.am

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.am = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.g()

            local SkinChanger = __ANTIBRAIN_MODULES.al()
            local WIDTH, ROWS = 669, 2
            local CAPTION_GAP = 4
            local CosmeticChanger = {}

            function CosmeticChanger.build(ui, shown)
                local popout = ui.popout({
                    title = 'Cosmetic Changer',
                    width = WIDTH,
                })

                shown:onChanged(function(value)
                    popout:show(value)
                end)
                popout:show(shown.value)

                local box = popout.box
                local weaponFilter = box:input(ui.id('weapon-filter'), {
                    text = 'weapon filter',
                    placeholder = 'grenade launcher...',
                    captionGap = CAPTION_GAP,
                })
                local weapons = box:gallery({
                    rows = ROWS,
                    title = SkinChanger.slotTitle,
                    empty = 'no weapon matches the filter',
                })

                box:divider()

                local kind = box:dropdown(ui.id('cosmetics-mode'), {
                    text = 'mode',
                    values = table.clone(SkinChanger.KINDS),
                    default = 'skin',
                    tooltip = 'what kind of cosmetic to change',
                })
                local cosmeticFilter = box:input(ui.id('cosmetic-filter'), {
                    text = 'cosmetic filter',
                    placeholder = 'red...',
                    captionGap = CAPTION_GAP,
                })
                local cosmetics = box:gallery({
                    rows = ROWS,
                    title = SkinChanger.slotTitle,
                    empty = 'no cosmetic matches the filter',
                })
                local inverted = box:dependent(function()
                    return kind.value == 'wrap'
                end):toggle(ui.id('wrap-inverted'), {
                    text = 'inverted',
                    default = false,
                    tooltip = 'inverts the selected wrap',
                })

                box:divider()

                local actions = {}

                box:button({
                    text = 'apply selected to all',
                    doubleClick = true,
                    callback = function()
                        local applyAll = actions.applyAll

                        if applyAll then
                            applyAll()
                        end
                    end,
                })

                local reset = box:button({
                    text = 'reset to defaults',
                    doubleClick = true,
                    callback = function()
                        local reset = actions.reset

                        if reset then
                            reset()
                        end
                    end,
                })

                reset:button({
                    text = 'close',
                    callback = function()
                        shown:set(false)
                    end,
                })
                box:note('right click a weapon to toggle the skin changer for it.')

                return {
                    weaponFilter = weaponFilter,
                    weapons = weapons,
                    cosmeticFilter = cosmeticFilter,
                    cosmetics = cosmetics,
                    mode = kind,
                    inverted = inverted,
                    data = ui.data('cosmetics-data'),
                    actions = actions,
                }
            end

            return table.freeze(CosmeticChanger)
        end

        function __ANTIBRAIN_MODULES.an()
            local v = __ANTIBRAIN_MODULES.cache.an

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.an = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local CosmeticChanger = __ANTIBRAIN_MODULES.an()
            local FovControls = __ANTIBRAIN_MODULES.U()

            __ANTIBRAIN_MODULES.g()

            local Indicators = __ANTIBRAIN_MODULES.R()

            __ANTIBRAIN_MODULES.al()

            local Visuals = {}

            function Visuals.build(ui)
                local tab = ui.tab('visuals')
                local viewmodel = tab:tabbox('Left'):tab('viewmodel')
                local shown = viewmodel:toggle(ui.id('cosmetics-show'), {
                    text = 'show cosmetics changer',
                    default = false,
                })
                local cosmetics = CosmeticChanger.build(ui, shown)
                local box = tab:groupbox('Right', 'indicators')

                local function color(toggle, id, title)
                    return toggle:color(ui.id(id), {
                        title = title,
                        default = Color3.new(1, 1, 1),
                    })
                end

                local manipulated = box:toggle(ui.id('indicator-manipulated'), {
                    text = 'manipulated',
                    default = true,
                    tooltip = 'if your target is manipulated, this will show',
                })
                local manipulatedColor = color(manipulated, 'indicator-manipulated-color', 'manipulated color')
                local ragebot = box:toggle(ui.id('indicator-ragebot'), {
                    text = 'ragebot',
                    default = true,
                    tooltip = 'if ragebot is enabled, this will show',
                })
                local ragebotText = color(ragebot, 'indicator-ragebot-text-color', 'ragebot text color')
                local ragebotStatus = color(ragebot, 'indicator-ragebot-status-color', 'ragebot status color')
                local ragebotStyle = box:dependent(function()
                    return ragebot.value
                end):multiDropdown(ui.id('indicator-ragebot-style'), {
                    text = 'ragebot style',
                    values = {
                        'text',
                        'status',
                    },
                    default = {
                        'status',
                        'text',
                    },
                })
                local ammo = box:toggle(ui.id('indicator-ammo'), {
                    text = 'ammo',
                    default = false,
                })
                local ammoColor = color(ammo, 'indicator-ammo-color', 'ammo color')
                local dividerColor = color(ammo, 'indicator-ammo-divider-color', 'divider color')
                local maxAmmoColor = color(ammo, 'indicator-ammo-max-color', 'max ammo color')
                local reserveColor = color(ammo, 'indicator-ammo-reserve-color', 'reserve color')
                local emptyColor = color(ammo, 'indicator-ammo-empty-color', 'empty color')
                local ammoStyle = box:dependent(function()
                    return ammo.value
                end):multiDropdown(ui.id('indicator-ammo-style'), {
                    text = 'ammo style',
                    values = {
                        'ammo',
                        'max ammo',
                        'reserve',
                        Indicators.EMPTY,
                    },
                    default = {
                        'ammo',
                        'reserve',
                    },
                })

                box:divider()

                local lerp = box:slider(ui.id('indicator-lerp'), {
                    text = 'lerp',
                    default = 1,
                    min = 0.01,
                    max = 1,
                    rounding = 2,
                    suffix = 'x',
                })
                local offsetX = box:slider(ui.id('indicator-offset-x'), {
                    text = 'offset x',
                    default = 0,
                    min = -100,
                    max = 100,
                    rounding = 0,
                    increment = 5,
                    suffix = 'px',
                    tooltip = 'start offset x',
                })
                local offsetY = offsetX:slider(ui.id('indicator-offset-y'), {
                    text = 'offset y',
                    default = 25,
                    min = -100,
                    max = 100,
                    rounding = 0,
                    increment = 5,
                    suffix = 'px',
                    tooltip = 'start offset y',
                })
                local style = box:dropdown(ui.id('indicator-text-style'), {
                    text = 'text style',
                    values = {
                        'lower',
                        'upper',
                    },
                    default = 'lower',
                })
                local anchors = box:multiDropdown(ui.id('indicator-position'), {
                    text = 'position',
                    values = table.clone(FovControls.ANCHORS),
                    allowNull = true,
                })
                local white = Color3.new(1, 1, 1)
                local settings = {
                    manipulated = true,
                    manipulatedColor = white,
                    ragebot = true,
                    ragebotStyle = {},
                    ragebotTextColor = white,
                    ragebotStatusColor = white,
                    ammo = false,
                    ammoStyle = {},
                    ammoColor = white,
                    dividerColor = white,
                    maxAmmoColor = white,
                    reserveColor = white,
                    emptyColor = white,
                    style = 'lower',
                    lerp = 1,
                    offset = Vector2.zero,
                    anchors = {},
                }

                return {
                    indicators = function()
                        settings.manipulated, settings.manipulatedColor = manipulated.value, manipulatedColor.value
                        settings.ragebot, settings.ragebotStyle = ragebot.value, ragebotStyle.value
                        settings.ragebotTextColor, settings.ragebotStatusColor = ragebotText.value, ragebotStatus.value
                        settings.ammo, settings.ammoStyle = ammo.value, ammoStyle.value
                        settings.ammoColor, settings.dividerColor = ammoColor.value, dividerColor.value
                        settings.maxAmmoColor, settings.reserveColor = maxAmmoColor.value, reserveColor.value
                        settings.emptyColor = emptyColor.value
                        settings.style = style.value or 'lower'
                        settings.lerp, settings.offset = lerp.value, Vector2.new(offsetX.value, offsetY.value)
                        settings.anchors = anchors.value

                        return settings
                    end,
                    cosmetics = cosmetics,
                }
            end

            return table.freeze(Visuals)
        end

        function __ANTIBRAIN_MODULES.ao()
            local v = __ANTIBRAIN_MODULES.cache.ao

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ao = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Aimbot = __ANTIBRAIN_MODULES.v()
            local AlwaysBackstab = __ANTIBRAIN_MODULES.z()
            local AntiAim = __ANTIBRAIN_MODULES.B()
            local Character = __ANTIBRAIN_MODULES.C()
            local Counter = __ANTIBRAIN_MODULES.L()
            local CounterControls = __ANTIBRAIN_MODULES.M()
            local Feature = __ANTIBRAIN_MODULES.O()

            __ANTIBRAIN_MODULES.g()

            local Indicators = __ANTIBRAIN_MODULES.R()
            local Main = __ANTIBRAIN_MODULES.ae()
            local MeleeReach = __ANTIBRAIN_MODULES.W()
            local Ragebot = __ANTIBRAIN_MODULES.ab()
            local SilentAim = __ANTIBRAIN_MODULES.T()
            local SkinChanger = __ANTIBRAIN_MODULES.al()
            local Triggerbot = __ANTIBRAIN_MODULES.ac()
            local Underground = __ANTIBRAIN_MODULES.am()
            local Visuals = __ANTIBRAIN_MODULES.ao()
            local Weapons = __ANTIBRAIN_MODULES.ad()

            local function start(context)
                local main = Main.build(context.ui)
                local counter = CounterControls.build(main.counterBox, context.ui)
                local visuals = Visuals.build(context.ui)
                local character = Character.build(context.ui)

                Feature.always(context, 'Pose decoding guard', AntiAim.guardDecoding)
                Feature.always(context, 'Weapons', Weapons.start, main.weaponSettings)
                Feature.always(context, 'Indicator', Indicators.start, visuals.indicators, context.services, context.log)
                Feature.always(context, 'Skin changer', SkinChanger.start, visuals.cosmetics, context.ui, context.log, context.services)
                Feature.bind(context, main.silentAim, SilentAim.start, main.aim, context.log, context.services)
                Feature.bind(context, main.aimbot, Aimbot.start, main.aim, context.services)
                Feature.bind(context, main.triggerbot, Triggerbot.start, main.triggerbotSettings)
                Feature.bind(context, main.alwaysBackstab, AlwaysBackstab.start, context.services)
                Feature.bind(context, main.meleeReach, MeleeReach.start, main.meleeReachSettings)
                Feature.bind(context, main.ragebot, Ragebot.start, main.ragebotSettings, context.services, context.ui.notify, function(
                )
                    return counter.settings().active
                end)
                Feature.bind(context, counter.counter, Counter.start, counter.settings, context.services)
                Feature.bind(context, character.antiAim, AntiAim.start, character.antiAimSettings, context.services)
                Feature.bind(context, character.underground, Underground.start, character.undergroundActive, context.services)
            end

            local definition = {
                id = 'rivals',
                name = 'RIVALS',
                universeIds = {6035872082},
                requires = {
                    'debug.getupvalues',
                    'debug.setupvalue',
                    'debug.getconstants',
                    'debug.setconstant',
                    'hookfunction',
                    'getrawmetatable',
                    'getstack',
                    'getproto',
                },
                start = start,
            }

            return table.freeze(definition)
        end

        function __ANTIBRAIN_MODULES.ap()
            local v = __ANTIBRAIN_MODULES.cache.ap

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ap = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.g()

            return table.freeze({
                games = table.freeze({
                    (__ANTIBRAIN_MODULES.ap()),
                }),
                universal = nil,
            })
        end

        function __ANTIBRAIN_MODULES.aq()
            local v = __ANTIBRAIN_MODULES.cache.aq

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aq = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Services = __ANTIBRAIN_MODULES.k()
            local Files = {}

            function Files.validName(name)
                if not name:match('^[%w _%-][%w _%-%.]*$') or #name > 64 or name:match('[%. ]$') then
                    return false
                end

                local stem = (name:match('^[^%.]+') or name):upper()

                return stem ~= 'CON' and stem ~= 'PRN' and stem ~= 'AUX' and stem ~= 'NUL' and not stem:match('^COM[1-9]$') and not stem:match('^LPT[1-9]$')
            end

            local function ensure(folder)
                local path = ''

                for part in folder:gmatch('[^/]+')do
                    path = (path == '' and {part} or {
                        string.format('%s/%s', tostring(path), tostring(part)),
                    })[1]

                    if not isfolder(path) then
                        makefolder(path)
                    end
                end
            end

            function Files.prepare(folders)
                local failed = nil

                for _, folder in folders do
                    local failure = Failure.capture(ensure, folder)

                    if failure and not failed then
                        failed = string.format('could not make %s: %s', tostring(folder), tostring(Failure.summary(failure)))
                    end
                end

                return failed
            end
            function Files.seed(path, value)
                local ok, present = pcall(function()
                    return isfile(path)
                end)

                if not ok then
                    return string.format('could not look for %s: %s', tostring(path), tostring(present))
                end
                if present then
                    return nil
                end

                return Files.write(path, value)
            end
            function Files.read(path)
                local ok, result = pcall(function()
                    if not isfile(path) then
                        return nil
                    end

                    local value = Services.HttpService:JSONDecode(readfile(path))

                    assert(value ~= nil, 'the file contains JSON null')

                    return value
                end)

                if not ok then
                    return nil, string.format('could not read %s: %s', tostring(path), tostring(result))
                end

                return result, nil
            end
            function Files.readRaw(path)
                local ok, result = pcall(function()
                    if not isfile(path) then
                        return nil
                    end

                    return readfile(path)
                end)

                if not ok then
                    return nil, string.format('could not read %s: %s', tostring(path), tostring(result))
                end

                return result, nil
            end
            function Files.writeRaw(path, text)
                local ok, failure = pcall(function()
                    ensure(path:match('^(.*)/[^/]*$') or '')
                    writefile(path, text)
                end)

                return (ok and {nil} or {
                    string.format('could not write %s: %s', tostring(path), tostring(failure)),
                })[1]
            end
            function Files.write(path, value)
                local ok, failure = pcall(function()
                    ensure(path:match('^(.*)/[^/]*$') or '')
                    writefile(path, Services.HttpService:JSONEncode(value))
                end)

                return (ok and {nil} or {
                    string.format('could not write %s: %s', tostring(path), tostring(failure)),
                })[1]
            end
            function Files.delete(path)
                local ok, failure = pcall(function()
                    if isfile(path) then
                        delfile(path)
                    end
                end)

                return (ok and {nil} or {
                    string.format('could not delete %s: %s', tostring(path), tostring(failure)),
                })[1]
            end
            function Files.entries(folder)
                local ok, paths = pcall(function()
                    if not isfolder(folder) then
                        return {}
                    end

                    return listfiles(folder)
                end)

                if not ok then
                    return {}, string.format('could not list %s: %s', tostring(folder), tostring(paths))
                end

                local names = {}

                for _, path in paths do
                    local name = path:match('([^/\\]+)$')

                    if name then
                        table.insert(names, name)
                    end
                end

                table.sort(names)

                return names, nil
            end
            function Files.names(folder)
                local names = {}

                for _, entry in Files.entries(folder)do
                    local name = entry:match('^(.+)%.json$')

                    if name and Files.validName(name) then
                        table.insert(names, name)
                    end
                end

                return names
            end
            function Files.isFile(path)
                local ok, found = pcall(function()
                    return isfile(path)
                end)

                return ok and found
            end
            function Files.isFolder(path)
                local ok, found = pcall(function()
                    return isfolder(path)
                end)

                if not ok then
                    return false, string.format('could not inspect %s: %s', tostring(path), tostring(found))
                end

                return found, nil
            end
            function Files.removeEmpty(path)
                local ok = pcall(function()
                    local entries, failure = Files.entries(path)

                    if not failure and #entries == 0 then
                        (delfolder)(path)
                    end
                end)

                return ok and not Files.isFolder(path)
            end

            return table.freeze(Files)
        end

        function __ANTIBRAIN_MODULES.ar()
            local v = __ANTIBRAIN_MODULES.cache.ar

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ar = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            return table.freeze({
                name = 'AntiBrain',
                version = '0.1.0',
                folder = 'AntiBrain',
            })
        end

        function __ANTIBRAIN_MODULES.as()
            local v = __ANTIBRAIN_MODULES.cache.as

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.as = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Meta = __ANTIBRAIN_MODULES.as()
            local Paths = {}

            Paths.LAYOUT = 2

            function Paths.root()
                return Meta.folder
            end
            function Paths.settings()
                return string.format('%s/settings.json', tostring(Meta.folder))
            end
            function Paths.key(scriptId)
                assert(scriptId:match('^[a-f0-9]+$'), 'Invalid script ID for a saved key path')

                return string.format('%s/keys/%s.txt', tostring(Meta.folder), tostring(scriptId))
            end
            function Paths.themes()
                return string.format('%s/themes', tostring(Meta.folder))
            end
            function Paths.theme(name)
                return string.format('%s/%s.json', tostring(Paths.themes()), tostring(name))
            end
            function Paths.games()
                return string.format('%s/games', tostring(Meta.folder))
            end
            function Paths.configs(game)
                return string.format('%s/%s/configs', tostring(Paths.games()), tostring(game))
            end
            function Paths.config(game, name)
                return string.format('%s/%s.json', tostring(Paths.configs(game)), tostring(name))
            end
            function Paths.folders(game)
                local folders = {
                    Meta.folder,
                    Paths.themes(),
                    Paths.games(),
                }

                if game then
                    table.insert(folders, string.format('%s/%s', tostring(Paths.games()), tostring(game)))
                    table.insert(folders, Paths.configs(game))
                end

                return folders
            end

            return table.freeze(Paths)
        end

        function __ANTIBRAIN_MODULES.at()
            local v = __ANTIBRAIN_MODULES.cache.at

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.at = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Files = __ANTIBRAIN_MODULES.ar()
            local Paths = __ANTIBRAIN_MODULES.at()
            local Migration = {}
            local NOT_GAMES = table.freeze({
                themes = true,
                games = true,
            })

            local function move(game, name, oldFolder)
                local from, to = string.format('%s/%s', tostring(oldFolder), tostring(name)), Paths.config(game, (name:gsub('%.json$', '')))
                local text, readFailure = Files.readRaw(from)

                if not text then
                    return readFailure
                end

                local existing, targetFailure = Files.readRaw(to)

                if targetFailure then
                    return targetFailure
                end
                if existing ~= nil then
                    if existing == text then
                        return Files.delete(from)
                    end

                    return string.format(
[[the saved config at %s differs from %s; both files were kept]], tostring(to), tostring(from))
                end

                local failure = Files.writeRaw(to, text)

                if failure then
                    return failure
                end
                if Files.readRaw(to) ~= text then
                    return string.format('the copy of %s does not match it', tostring(from))
                end

                return Files.delete(from)
            end
            local function moveGame(game, failures)
                local oldFolder = string.format('%s/%s/configs', tostring(Paths.root()), tostring(game))
                local entries, listingFailure = Files.entries(oldFolder)

                if listingFailure then
                    table.insert(failures, listingFailure)

                    return
                end

                for _, name in entries do
                    if name:match('%.json$') then
                        local failure = move(game, name, oldFolder)

                        if failure then
                            table.insert(failures, failure)
                        end
                    end
                end

                if Files.removeEmpty(oldFolder) then
                    Files.removeEmpty(string.format('%s/%s', tostring(Paths.root()), tostring(game)))
                end
            end

            function Migration.version(settings)
                return (type(settings) == 'table' and type(settings.version) == 'number' and {
                    settings.version,
                } or {1})[1]
            end
            function Migration.run()
                local settings, readFailure = Files.read(Paths.settings())

                if readFailure then
                    return readFailure
                end
                if settings ~= nil and type(settings) ~= 'table' then
                    return 
[[Saved settings are not a JSON object; migration was not started]]
                end
                if type(settings) == 'table' and settings.version ~= nil then
                    local version = settings.version

                    if type(version) ~= 'number' or version < 1 or version % 1 ~= 0 then
                        return 
[[Saved settings have an invalid layout version; migration was not started]]
                    end
                end
                if Migration.version(settings) >= Paths.LAYOUT then
                    return nil
                end

                local failures = {}
                local failure = Failure.capture(function()
                    local entries, listingFailure = Files.entries(Paths.root())

                    if listingFailure then
                        table.insert(failures, listingFailure)

                        return
                    end

                    for _, game in entries do
                        if not NOT_GAMES[game] then
                            local present, folderFailure = Files.isFolder(string.format('%s/%s/configs', tostring(Paths.root()), tostring(game)))

                            if folderFailure then
                                table.insert(failures, folderFailure)
                            elseif present then
                                moveGame(game, failures)
                            end
                        end
                    end
                end)

                if failure then
                    table.insert(failures, Failure.summary(failure))
                end
                if #failures > 0 then
                    return string.format('some saved files could not be moved to the new layout: %s', tostring(table.concat(failures, '; ')))
                end
                if type(settings) == 'table' then
                    settings.version = Paths.LAYOUT

                    return Files.write(Paths.settings(), settings)
                end

                return nil
            end

            return table.freeze(Migration)
        end

        function __ANTIBRAIN_MODULES.au()
            local v = __ANTIBRAIN_MODULES.cache.au

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.au = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Files = __ANTIBRAIN_MODULES.ar()
            local Meta = __ANTIBRAIN_MODULES.as()
            local Migration = __ANTIBRAIN_MODULES.au()
            local Paths = __ANTIBRAIN_MODULES.at()

            __ANTIBRAIN_MODULES.f()

            local Services = __ANTIBRAIN_MODULES.k()
            local REQUIRED = table.freeze({
                'getgenv',
                'gethui',
            })
            local FILE_APIS = table.freeze({
                'readfile',
                'writefile',
                'isfile',
                'isfolder',
                'makefolder',
                'listfiles',
                'delfile',
            })
            local SLOT_KEY = '__ANTIBRAIN_SESSION_V1'

            local function claimSlot(environment)
                if environment[SLOT_KEY] == nil then
                    environment[SLOT_KEY] = {}
                end

                local slot = environment[SLOT_KEY]

                assert(type(slot) == 'table', string.format('The %s session slot holds an incompatible value', tostring(Meta.name)))
                assert(slot.current == nil or (type(slot.current) == 'table' and type(slot.current.stop) == 'function'), string.format('An incompatible %s session is running; unload it first', tostring(Meta.name)))

                return slot
            end
            local function executorName(environment)
                if type(environment.identifyexecutor) ~= 'function' then
                    return 'Unknown executor'
                end

                local ok, name, version = pcall(environment.identifyexecutor)

                if not ok or type(name) ~= 'string' then
                    return 'Unknown executor'
                end

                return (type(version) == 'string' and version ~= '' and {
                    string.format('%s %s', tostring(name), tostring(version)),
                } or {name})[1]
            end
            local function experienceName()
                local ok, info = pcall(function()
                    return Services.MarketplaceService:GetProductInfoAsync(game.PlaceId)
                end)

                return (ok and type(info) == 'table' and type(info.Name) == 'string' and {
                    info.Name,
                } or {
                    game.Name,
                })[1]
            end

            local Executor = {}

            function Executor.inspect(environment)
                local missing = {}

                for _, name in REQUIRED do
                    if type(environment[name]) ~= 'function' then
                        table.insert(missing, name)
                    end
                end

                local persistence = true

                for _, name in FILE_APIS do
                    if type(environment[name]) ~= 'function' then
                        persistence = false

                        break
                    end
                end

                return {
                    missing = missing,
                    persistence = persistence,
                }
            end
            function Executor.supports(environment, name)
                local value = environment

                for part in (string.format('%s.', tostring(name))):gmatch('([^.]*)%.')do
                    if type(value) ~= 'table' or not part:match('^[%a_][%w_]*$') then
                        return false
                    end

                    value = value[part]
                end

                return type(value) == 'function' or type(value) == 'table'
            end
            function Executor.connect()
                assert(type(getgenv) == 'function', string.format('%s requires an executor with getgenv', tostring(Meta.name)))

                local environment = getgenv()
                local capabilities = Executor.inspect(environment)

                assert(#capabilities.missing == 0, string.format('Missing executor APIs: %s', tostring(table.concat(capabilities.missing, ', '))))

                if not game:IsLoaded() then
                    game.Loaded:Wait()
                end

                local function log(message)
                    warn(string.format('[%s] %s', tostring(Meta.name), tostring(message)))
                end

                local info = {
                    placeId = game.PlaceId,
                    universeId = game.GameId,
                    name = game.Name,
                }

                return {
                    slot = claimSlot(environment),
                    game = info,
                    executor = executorName(environment),
                    persistence = capabilities.persistence,
                    initialize = function(scope)
                        scope:spawn(function()
                            info.name = experienceName()
                        end)
                    end,
                    supports = function(name)
                        return Executor.supports(environment, name)
                    end,
                    prepare = function(module)
                        if not capabilities.persistence then
                            return nil
                        end

                        local failure = Files.prepare(Paths.folders(module))

                        if module == nil then
                            failure = failure or Migration.run()
                        end

                        return failure or Files.seed(Paths.settings(), {
                            version = Paths.LAYOUT,
                        })
                    end,
                    wait = function(seconds)
                        task.wait(seconds)
                    end,
                    log = log,
                }
            end

            return table.freeze(Executor)
        end

        function __ANTIBRAIN_MODULES.av()
            local v = __ANTIBRAIN_MODULES.cache.av

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.av = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local VERSION = 1
            local Options = {}

            function Options.new()
                return {options = {}}
            end
            function Options.add(registry, option)
                assert(not registry.options[option.id], string.format('Option id "%s" is already used', tostring(option.id)))

                registry.options[option.id] = option
            end
            function Options.save(registry, only, into)
                local saved = into or {
                    version = VERSION,
                    options = {},
                }

                for id, option in registry.options do
                    if not only or only[id] then
                        local ok, value = pcall(option.save)

                        if ok then
                            saved.options[id] = value
                        end
                    end
                end

                return saved
            end
            function Options.load(registry, saved, only)
                if type(saved) ~= 'table' or type(saved.options) ~= 'table' then
                    return 'it is not a saved config'
                end
                if saved.version ~= VERSION then
                    return string.format('it was saved in layout %s, which this version cannot read', tostring(saved.version))
                end

                local failed = {}

                for id, value in saved.options do
                    local option = (type(id) == 'string' and {
                        registry.options[id],
                    } or {nil})[1]

                    if option and (not only or only[id]) then
                        local failure = Failure.capture(option.load, value)

                        if failure then
                            table.insert(failed, id)
                        end
                    end
                end

                if #failed > 0 then
                    table.sort(failed)

                    return string.format('these values could not be applied: %s', tostring(table.concat(failed, ', ')))
                end

                return nil
            end

            return table.freeze(Options)
        end

        function __ANTIBRAIN_MODULES.aw()
            local v = __ANTIBRAIN_MODULES.cache.aw

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aw = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Signal = {}

            function Signal.new(report)
                local entries = {}
                local signal = {
                    connect = function(_, listener)
                        local entry = {
                            listener = listener,
                            connected = true,
                        }

                        table.insert(entries, entry)

                        return function()
                            entry.connected = false

                            local at = table.find(entries, entry)

                            if at then
                                table.remove(entries, at)
                            end
                        end
                    end,
                    fire = function(_, ...)
                        for _, entry in table.clone(entries)do
                            if entry.connected then
                                local failure = Failure.capture(entry.listener, 
...)

                                if failure then
                                    pcall(report, failure)
                                end
                            end
                        end
                    end,
                }

                return signal
            end

            return table.freeze(Signal)
        end

        function __ANTIBRAIN_MODULES.ax()
            local v = __ANTIBRAIN_MODULES.cache.ax

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ax = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()

            local Options = __ANTIBRAIN_MODULES.aw()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Data = {}

            function Data.new(registry, id, default, report)
                local changed = Signal.new(report)
                local data = {
                    id = id,
                    value = default,
                    set = function(self, value)
                        if value == self.value then
                            return
                        end

                        self.value = value

                        changed:fire(value)
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                }

                Options.add(registry, {
                    id = id,
                    save = function()
                        return data.value
                    end,
                    load = function(saved)
                        if type(saved) == 'string' then
                            data:set(saved)
                        end
                    end,
                })

                return data
            end

            return table.freeze(Data)
        end

        function __ANTIBRAIN_MODULES.ay()
            local v = __ANTIBRAIN_MODULES.cache.ay

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ay = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Scope = __ANTIBRAIN_MODULES.c()
            local Services = __ANTIBRAIN_MODULES.k()
            local Backdrop = {}
            local apply

            function Backdrop.new(scope, gui, mobile)
                local dim = Scope.own(scope, Instance.new('Frame'))

                dim.BackgroundColor3 = Color3.new(0, 0, 0)
                dim.BackgroundTransparency = 1
                dim.BorderSizePixel = 0
                dim.Size = UDim2.fromScale(1, 1)
                dim.ZIndex = 0
                dim.Visible = false
                dim.Parent = gui

                local backdrop = {
                    scope = scope,
                    settings = {
                        enabled = true,
                        color = Color3.new(0, 0, 0),
                        transparency = 0.7,
                        blur = mobile and 0 or 15,
                        contrast = 0,
                        saturation = 0,
                        brightness = 0,
                    },
                    open = false,
                    dim = dim,
                    blur = nil,
                    correction = nil,
                }

                scope:add(function()
                    backdrop.open = false
                    backdrop.dim.Visible = false
                end)
                scope:add(function()
                    local blur = backdrop.blur

                    backdrop.blur = nil

                    if blur then
                        blur:Destroy()
                    end
                end)
                scope:add(function()
                    local correction = backdrop.correction

                    backdrop.correction = nil

                    if correction then
                        correction:Destroy()
                    end
                end)
                scope:connect(Services.Workspace:GetPropertyChangedSignal('CurrentCamera'), function(
                )
                    apply(backdrop)
                end)

                return backdrop
            end

            local function kept(current, class)
                if current then
                    if current.Parent then
                        return current
                    end

                    current:Destroy()
                end

                local made = Instance.new(class)
                local ok, failure = pcall(function()
                    made.Name = '\0'
                end)

                if not ok then
                    made:Destroy()
                    error(failure, 0)
                end

                return made
            end

            apply = function(backdrop)
                local settings = backdrop.settings
                local on = backdrop.open and settings.enabled
                local camera = Services.Workspace.CurrentCamera or Services.Lighting

                if on and (settings.contrast ~= 0 or settings.saturation ~= 0 or settings.brightness ~= 0) then
                    local correction = (kept(backdrop.correction, 'ColorCorrectionEffect'))

                    backdrop.correction = correction
                    correction.Contrast = settings.contrast
                    correction.Saturation = settings.saturation
                    correction.Brightness = settings.brightness
                    correction.Parent = camera
                elseif backdrop.correction then
                    backdrop.correction:Destroy()

                    backdrop.correction = nil
                end
                if on and settings.blur > 0 then
                    local blur = (kept(backdrop.blur, 'BlurEffect'))

                    backdrop.blur = blur
                    blur.Size = settings.blur
                    blur.Parent = camera
                elseif backdrop.blur then
                    backdrop.blur:Destroy()

                    backdrop.blur = nil
                end

                local dim = backdrop.dim

                dim.BackgroundColor3 = settings.color
                dim.BackgroundTransparency = (on and {
                    settings.transparency,
                } or {1})[1]
                dim.Visible = on
            end

            function Backdrop.show(backdrop, open)
                if backdrop.scope.closed then
                    return
                end

                backdrop.open = open

                apply(backdrop)
            end
            function Backdrop.restyle(backdrop, change)
                if backdrop.scope.closed then
                    return
                end

                change(backdrop.settings)

                if backdrop.scope.closed then
                    return
                end

                apply(backdrop)
            end

            return table.freeze(Backdrop)
        end

        function __ANTIBRAIN_MODULES.az()
            local v = __ANTIBRAIN_MODULES.cache.az

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.az = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Palette = {}

            local function theme(
                name,
                font,
                main,
                accent,
                background,
                outline,
                risk
            )
                return table.freeze({
                    name = name,
                    colors = table.freeze({
                        font = font,
                        main = main,
                        accent = accent,
                        background = background,
                        outline = outline,
                        risk = risk,
                    }),
                })
            end

            Palette.DEFAULT = 'Default'
            Palette.BUILT_IN = table.freeze({
                theme('Default', 'ffffff', '181818', '4777b6', '141414', '1f1f1f', 'ff0000'),
                theme('Dark', 'ffffff', '0a0a0a', '5945ff', '0a0a0a', '171717', 'e50000'),
                theme('Fatality', 'ffffff', '181537', 'ca0756', '201c46', '39335a', 'e50000'),
                theme('Imgui', 'ffffff', '151617', '406ba8', '151617', '242424', 'e50000'),
                theme('Iniuria', 'ffffff', '1e1d1e', 'c41275', '1e1d1e', '33252b', 'e50000'),
                theme('Monolith', 'ffffff', '141115', 'c707bd', '171417', '272427', 'e50000'),
                theme('Neverlose', 'ffffff', '0c1014', '01a3f1', '0c0f14', '191919', 'e50000'),
                theme('Nord', 'ffffff', '1c1e20', '9effc8', '1c1e20', '24282d', 'ff7a00'),
                theme('Onetap', 'ffffff', '1e1d22', 'faa614', '18181c', '313033', 'e50000'),
                theme('Primordial', 'ffffff', '181818', 'd7a6b0', '1f1f1f', '2a2a2a', 'e50000'),
                theme('Skeet', 'ffffff', '131313', '81ff54', '151515', '2a2a2a', 'e50000'),
                theme('Tokyo Night', 'ffffff', '191925', '6956cb', '15151e', '272727', 'fb5f5f'),
                theme('V3rmillion', 'ffffff', '202020', 'cd1818', '202020', '2a2a2a', 'e50000'),
            })

            local KEYS = {
                {
                    key = 'main',
                    label = 'Main Color',
                },
                {
                    key = 'accent',
                    label = 'Accent Color',
                },
                {
                    key = 'background',
                    label = 'Background Color',
                },
                {
                    key = 'outline',
                    label = 'Outline Color',
                },
                {
                    key = 'font',
                    label = 'Text Color',
                },
                {
                    key = 'risk',
                    label = 'Risk Text Color',
                },
            }

            Palette.KEYS = table.freeze(KEYS)

            function Palette.builtIn(name)
                for _, builtIn in Palette.BUILT_IN do
                    if builtIn.name == name then
                        return builtIn
                    end
                end

                return nil
            end
            function Palette.isHex(text)
                return text:match('^#?%x%x%x%x%x%x$') ~= nil
            end
            function Palette.colors(hex)
                return {
                    font = Color3.fromHex(hex.font),
                    main = Color3.fromHex(hex.main),
                    background = Color3.fromHex(hex.background),
                    accent = Color3.fromHex(hex.accent),
                    outline = Color3.fromHex(hex.outline),
                    risk = Color3.fromHex(hex.risk),
                }
            end
            function Palette.darker(color)
                local hue, saturation, value = color:ToHSV()

                return Color3.fromHSV(hue, saturation, value / 1.5)
            end

            return table.freeze(Palette)
        end

        function __ANTIBRAIN_MODULES.aA()
            local v = __ANTIBRAIN_MODULES.cache.aA

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aA = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Palette = __ANTIBRAIN_MODULES.aA()

            __ANTIBRAIN_MODULES.c()

            local Theme = {}

            function Theme.new(scope, colors)
                local bindings = {}

                scope:add(function()
                    table.clear(bindings)
                end)

                local theme

                theme = {
                    colors = colors,
                    accentDark = Palette.darker(colors.accent),
                    bind = function(_, owner, paint)
                        if scope.closed then
                            return function() end
                        end

                        local binding = bindings[owner]

                        if not binding then
                            local life = scope:child()

                            binding = {
                                scope = life,
                                painters = {},
                            }
                            bindings[owner] = binding

                            life:connect(owner.Destroying, function()
                                bindings[owner] = nil

                                life:close()
                            end)
                        end

                        local life = binding.scope

                        local function repaint()
                            if not life.closed then
                                local failure = Failure.capture(paint)

                                if failure then
                                    scope:report(failure)
                                end
                            end
                        end

                        table.insert(binding.painters, repaint)
                        repaint()

                        return repaint
                    end,
                    set = function(_, value)
                        if scope.closed then
                            return
                        end

                        theme.colors = value
                        theme.accentDark = Palette.darker(value.accent)

                        for _, binding in table.clone(bindings)do
                            for _, paint in table.clone(binding.painters)do
                                paint()
                            end
                        end
                    end,
                }

                return theme
            end

            return table.freeze(Theme)
        end

        function __ANTIBRAIN_MODULES.aB()
            local v = __ANTIBRAIN_MODULES.cache.aB

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aB = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Palette = __ANTIBRAIN_MODULES.aA()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()

            __ANTIBRAIN_MODULES.aB()

            local Kit = {}

            function Kit.font()
                return Enum.Font.RobotoMono
            end

            local function colorOf(theme, shade)
                if shade == 'black' then
                    return Color3.new(0, 0, 0)
                elseif shade == 'accentDark' then
                    return theme.accentDark
                elseif shade == 'dim' then
                    return Palette.darker(theme.colors.font)
                end

                return theme.colors[shade]
            end

            function Kit.new(theme, scope)
                return {
                    theme = theme,
                    scope = scope,
                }
            end
            function Kit.frame(kit, parent, spec)
                assert(spec.border == nil or spec.fill ~= nil, 'A border shows only over a fill')

                local frame = Instance.new('Frame')

                frame.Position = spec.position or UDim2.new()
                frame.Size = spec.size
                frame.ZIndex = spec.zIndex
                frame.AnchorPoint = spec.anchor or Vector2.zero
                frame.Visible = spec.visible ~= false
                frame.ClipsDescendants = spec.clips == true
                frame.Active = spec.active == true
                frame.LayoutOrder = spec.layoutOrder or 0
                frame.BackgroundTransparency = spec.fill and 0 or 1
                frame.BorderSizePixel = (spec.border and {
                    spec.borderSize or 1,
                } or {0})[1]
                frame.BorderMode = (spec.inset and {
                    Enum.BorderMode.Inset,
                } or {
                    Enum.BorderMode.Outline,
                })[1]

                local fill, border = spec.fill, spec.border
                local theme = kit.theme
                local paint = theme:bind(frame, function()
                    if fill then
                        frame.BackgroundColor3 = colorOf(theme, fill)
                    end
                    if border then
                        frame.BorderColor3 = colorOf(theme, border)
                    end
                end)

                frame.Parent = parent

                return frame, function(nextFill, nextBorder)
                    fill, border = nextFill or fill, nextBorder or border

                    paint()
                end
            end
            function Kit.text(kit, parent, spec)
                local label = Instance.new('TextLabel')

                label.BackgroundTransparency = 1
                label.Font = Kit.font()
                label.Text = spec.text
                label.TextSize = spec.textSize or 16
                label.Position = spec.position or UDim2.new()
                label.Size = spec.size
                label.ZIndex = spec.zIndex
                label.AnchorPoint = spec.anchor or Vector2.zero
                label.Visible = spec.visible ~= false
                label.TextXAlignment = spec.xAlignment or Enum.TextXAlignment.Center
                label.TextYAlignment = spec.yAlignment or Enum.TextYAlignment.Center
                label.TextWrapped = spec.wrapped == true
                label.RichText = spec.rich == true

                if spec.engineStroke then
                    label.TextStrokeTransparency = 0
                else
                    Kit.outline(label)
                end

                local shade = spec.shade or 'font'
                local theme = kit.theme
                local paint = theme:bind(label, function()
                    label.TextColor3 = colorOf(theme, shade)
                end)

                label.Parent = parent

                return label, function(value)
                    shade = value

                    paint()
                end
            end
            function Kit.measure(text, size, bounds)
                return Services.TextService:GetTextSize(text, size, Kit.font(), bounds or Vector2.new(1920, 1080))
            end
            function Kit.outline(text)
                local stroke = Instance.new('UIStroke')

                stroke.Color = Color3.new(0, 0, 0)
                stroke.Thickness = 1
                stroke.LineJoinMode = Enum.LineJoinMode.Miter
                stroke.Parent = text
            end
            function Kit.well(kit, parent, size, zIndex, fill)
                local outer, restyleOuter = Kit.frame(kit, parent, {
                    size = size,
                    zIndex = zIndex,
                    fill = 'black',
                    border = 'black',
                })
                local inner, restyleInner = Kit.frame(kit, outer, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = zIndex + 1,
                    fill = fill or 'main',
                    border = 'outline',
                    inset = true,
                })

                return outer, inner, restyleOuter, restyleInner
            end
            function Kit.sheen(parent)
                local gradient = Instance.new('UIGradient')

                gradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromRGB(212, 212, 212))
                gradient.Rotation = 90
                gradient.Parent = parent
            end
            function Kit.list(parent, padding, horizontal)
                local layout = Instance.new('UIListLayout')

                layout.Padding = UDim.new(0, padding or 0)
                layout.FillDirection = (horizontal and {
                    Enum.FillDirection.Horizontal,
                } or {
                    Enum.FillDirection.Vertical,
                })[1]
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Parent = parent

                return layout
            end
            function Kit.hover(scope, target, enter, leave)
                scope:connect(target.MouseEnter, enter)
                scope:connect(target.MouseLeave, leave)
            end
            function Kit.highlight(kit, target, restyle, over, rest)
                Kit.hover(kit.scope, target, function()
                    restyle(nil, over)
                end, function()
                    restyle(nil, rest)
                end)
            end

            return table.freeze(Kit)
        end

        function __ANTIBRAIN_MODULES.aC()
            local v = __ANTIBRAIN_MODULES.cache.aC

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aC = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local Pointer = {}

            Pointer.location = function()
                local inset = Services.GuiService:GetGuiInset()

                return Services.UserInputService:GetMouseLocation() - inset
            end

            function Pointer.pressed(input)
                return input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
            end
            function Pointer.secondary(input)
                return input.UserInputType == Enum.UserInputType.MouseButton2
            end

            Pointer.over = function(frame, point)
                local position, size = frame.AbsolutePosition, frame.AbsoluteSize

                return point.X >= position.X and point.X <= position.X + size.X and point.Y >= position.Y and point.Y <= position.Y + size.Y
            end

            function Pointer.drag(scope, input, move, finish)
                if scope.closed then
                    return
                end

                local drag = scope:child()
                local touch = input.UserInputType == Enum.UserInputType.Touch
                local inputService = Services.UserInputService
                local position = function(changed)
                    return Vector2.new(changed.Position.X, changed.Position.Y)
                end

                local function begin()
                    drag:connect(inputService.InputChanged, function(changed)
                        if (touch and changed == input) or (not touch and changed.UserInputType == Enum.UserInputType.MouseMovement) then
                            move(position(changed))
                        end
                    end)
                    drag:connect(inputService.InputEnded, function(ended)
                        if (touch and ended == input) or (not touch and ended.UserInputType == input.UserInputType) then
                            drag:close()

                            if finish then
                                finish()
                            end
                        end
                    end)
                    move(position(input))
                end

                local failure = Failure.capture(begin)

                if failure then
                    drag:close()
                    error(failure, 0)
                end
            end

            return table.freeze(Pointer)
        end

        function __ANTIBRAIN_MODULES.aD()
            local v = __ANTIBRAIN_MODULES.cache.aD

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aD = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.aC()

            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Scope = __ANTIBRAIN_MODULES.c()
            local Drag = {}

            local function outlineOf(kit, target, layer, life)
                local outline = Scope.own(life, Instance.new('Frame'))

                outline.AnchorPoint = target.AnchorPoint
                outline.BackgroundTransparency = 1
                outline.Size = target.Size
                outline.Position = target.Position

                local stroke = Instance.new('UIStroke')

                stroke.Parent = outline

                kit.theme:bind(stroke, function()
                    stroke.Color = kit.theme.colors.accent
                end)

                outline.Parent = layer

                return outline
            end
            local function followOutline(
                kit,
                target,
                layer,
                input,
                activate,
                restore,
                move,
                finish
            )
                local life = kit.scope:child()

                if life.closed then
                    return
                end

                life:add(restore)

                local failure = Failure.capture(function()
                    local outline = outlineOf(kit, target, layer, life)

                    activate()

                    if life.closed then
                        return
                    end

                    Pointer.drag(life, input, function(point)
                        move(outline, point)
                    end, function()
                        local commitFailure = Failure.capture(finish, outline)

                        life:close()

                        if commitFailure then
                            error(commitFailure, 0)
                        end
                    end)
                end)

                if failure then
                    life:close()
                    error(failure, 0)
                end
            end
            local function placed(frame, point, offset)
                local size, anchor = frame.AbsoluteSize, frame.AnchorPoint

                return UDim2.fromOffset(point.X - offset.X + size.X * anchor.X, point.Y - offset.Y + size.Y * anchor.Y)
            end
            local function grab(target, input, cutoff)
                if not Pointer.pressed(input) then
                    return nil
                end

                local offset = Vector2.new(input.Position.X, input.Position.Y) - target.AbsolutePosition

                return (offset.Y <= cutoff and {offset} or {nil})[1]
            end

            function Drag.move(kit, handle, target, cutoff)
                handle.Active = true

                kit.scope:connect(handle.InputBegan, function(input)
                    local offset = grab(target, input, cutoff)

                    if not offset then
                        return
                    end

                    Pointer.drag(kit.scope, input, function(point)
                        target.Position = placed(target, point, offset)
                    end)
                end)
            end
            function Drag.outline(
                kit,
                handle,
                target,
                cutoff,
                layer,
                dragging,
                allowed
            )
                handle.Active = true

                kit.scope:connect(handle.InputBegan, function(input)
                    local offset = grab(target, input, cutoff)

                    if not offset or (allowed and not allowed()) then
                        return
                    end

                    followOutline(kit, target, layer, input, function()
                        dragging(true)
                    end, function()
                        dragging(false)
                    end, function(outline, point)
                        outline.Position = placed(target, point, offset)
                    end, function(outline)
                        target.Position = outline.Position
                    end)
                end)
            end
            function Drag.resize(kit, target, minimum, layer)
                local region = Instance.new('Frame')

                region.BackgroundTransparency = 1
                region.BorderSizePixel = 0
                region.ClipsDescendants = true
                region.Size = UDim2.fromOffset(25, 25)
                region.Position = UDim2.new(1, -25, 1, -25)
                region.ZIndex = 1
                region.Parent = target

                local grip = Instance.new('ImageButton')

                grip.Image = ''
                grip.BackgroundTransparency = 0.5
                grip.BorderSizePixel = 0
                grip.Size = UDim2.fromScale(2, 2)
                grip.ZIndex = 2

                local corner = Instance.new('UICorner')

                corner.CornerRadius = UDim.new(0.5, 0)
                corner.Parent = grip

                kit.theme:bind(grip, function()
                    grip.BackgroundColor3 = kit.theme.colors.accent
                end)

                grip.Parent = region

                kit.scope:connect(grip.InputBegan, function(input)
                    if not Pointer.pressed(input) then
                        return
                    end

                    local bottomRight = target.AbsolutePosition + target.AbsoluteSize
                    local offset = Vector2.new(input.Position.X, input.Position.Y) - bottomRight

                    followOutline(kit, target, layer, input, function()
                        grip.BackgroundTransparency = 1
                    end, function()
                        grip.BackgroundTransparency = 0.5
                    end, function(outline, point)
                        local size = point - offset - target.AbsolutePosition

                        outline.Size = UDim2.fromOffset(math.max(size.X, minimum.X), math.max(size.Y, minimum.Y))
                    end, function(outline)
                        target.Size = outline.Size
                    end)
                end)
            end

            return table.freeze(Drag)
        end

        function __ANTIBRAIN_MODULES.aE()
            local v = __ANTIBRAIN_MODULES.cache.aE

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aE = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Drag = __ANTIBRAIN_MODULES.aE()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Services = __ANTIBRAIN_MODULES.k()
            local ENTRY_HEIGHT, HEADER_HEIGHT = 18, 23
            local MIN_WIDTH = 210
            local KeybindList = {}

            function KeybindList.new(kit, gui, mobile)
                local outer, inner = Kit.well(kit, gui, UDim2.fromOffset(MIN_WIDTH, 20), 100)

                outer.Position = UDim2.new(0, 10, 0.5, 0)
                outer.AnchorPoint = Vector2.new(0, 0.5)
                outer.Visible = false

                Kit.frame(kit, inner, {
                    size = UDim2.new(1, 0, 0, 2),
                    zIndex = 102,
                    fill = 'accent',
                })
                Kit.text(kit, inner, {
                    text = 'Keybinds',
                    position = UDim2.fromOffset(5, 2),
                    size = UDim2.new(1, 0, 0, 20),
                    zIndex = 104,
                })

                local container = Kit.frame(kit, inner, {
                    position = UDim2.fromOffset(0, 20),
                    size = UDim2.new(1, 0, 1, -20),
                    zIndex = 1,
                })

                Kit.list(container)

                local padding = Instance.new('UIPadding')

                padding.PaddingLeft = UDim.new(0, 5)
                padding.Parent = container

                Drag.move(kit, outer, outer, 40)

                local list = {
                    kit = kit,
                    outer = outer,
                    inner = inner,
                    container = container,
                    entries = {},
                    mode = 'Toggled',
                    shown = true,
                    mobile = mobile,
                }

                local function refresh()
                    if list.shown and not list.mobile then
                        KeybindList.refresh(list)
                    end
                end

                kit.scope:connect(Services.UserInputService.InputBegan, refresh)
                kit.scope:connect(Services.UserInputService.InputEnded, refresh)

                return list
            end
            function KeybindList.add(list, state)
                local label, tint = Kit.text(list.kit, list.container, {
                    text = '',
                    size = UDim2.new(1, 0, 0, ENTRY_HEIGHT),
                    zIndex = 110,
                    textSize = 13,
                    xAlignment = Enum.TextXAlignment.Left,
                    visible = false,
                })
                local entry = {
                    label = label,
                    tint = tint,
                    state = state,
                }

                table.insert(list.entries, entry)
                KeybindList.refresh(list)

                return function()
                    local at = table.find(list.entries, entry)

                    if at then
                        table.remove(list.entries, at)
                    end

                    label:Destroy()
                    KeybindList.refresh(list)
                end
            end
            function KeybindList.refresh(list)
                local count, width = 0, 0

                for _, entry in list.entries do
                    local state = entry.state()
                    local shown = (list.mode == 'All' or not state.onToggle) and true or (list.mode == 'Active' and {
                        state.active,
                    } or {
                        state.enabled,
                    })[1]

                    entry.label.Visible = shown

                    if shown then
                        count = count + 1
                        entry.label.Text = state.text

                        entry.tint(state.active and 'accent' or 'font')

                        width = math.max(width, entry.label.TextBounds.X)
                    end
                end

                list.outer.Size = UDim2.fromOffset(math.max(width + 10, MIN_WIDTH), count * ENTRY_HEIGHT + HEADER_HEIGHT)
                list.outer.Visible = list.shown and count > 0 and not list.mobile
            end
            function KeybindList.setMode(list, mode)
                list.mode = mode

                KeybindList.refresh(list)
            end
            function KeybindList.setShown(list, shown)
                list.shown = shown

                KeybindList.refresh(list)
            end
            function KeybindList.setOpacity(list, opacity)
                local transparency = 1 - math.clamp(opacity, 0, 1)

                list.outer.BackgroundTransparency = transparency
                list.inner.BackgroundTransparency = transparency
            end

            return table.freeze(KeybindList)
        end

        function __ANTIBRAIN_MODULES.aF()
            local v = __ANTIBRAIN_MODULES.cache.aF

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aF = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Pointer = __ANTIBRAIN_MODULES.aD()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local Overlay = {}

            local function release(overlay, popup)
                local failure = Failure.capture(popup.close)

                if failure then
                    overlay.scope:report(failure)
                end
            end
            local function inside(popup, point)
                local anchor = popup.anchor

                return Pointer.over(popup.frame, point) or (anchor ~= nil and Pointer.over(anchor, point))
            end

            function Overlay.new(scope)
                local overlay = {
                    open = {},
                    scope = scope,
                }

                scope:connect(Services.UserInputService.InputBegan, function(
                    input
                )
                    if not (Pointer.pressed(input) or Pointer.secondary(input)) then
                        return
                    end

                    local point = Vector2.new(input.Position.X, input.Position.Y)

                    for _, popup in table.clone(overlay.open)do
                        if not inside(popup, point) then
                            Overlay.close(overlay, popup.frame)
                        end
                    end
                end)
                scope:add(function()
                    Overlay.closeAll(overlay)
                end)

                return overlay
            end
            function Overlay.show(overlay, popup)
                if overlay.scope.closed then
                    release(overlay, popup)

                    return
                end

                for _, other in table.clone(overlay.open)do
                    if other.frame == popup.frame or (popup.group and other.group == popup.group) then
                        Overlay.close(overlay, other.frame)
                    end
                end

                if overlay.scope.closed then
                    release(overlay, popup)

                    return
                end

                table.insert(overlay.open, popup)
            end
            function Overlay.close(overlay, frame)
                for index, popup in overlay.open do
                    if popup.frame == frame then
                        table.remove(overlay.open, index)
                        release(overlay, popup)

                        return
                    end
                end
            end
            function Overlay.closeAnchored(overlay, ancestor)
                for _, popup in table.clone(overlay.open)do
                    local anchor = popup.anchor

                    if anchor and (anchor == ancestor or anchor:IsDescendantOf(ancestor)) then
                        Overlay.close(overlay, popup.frame)
                    end
                end
            end
            function Overlay.isOpen(overlay, frame)
                for _, popup in overlay.open do
                    if popup.frame == frame then
                        return true
                    end
                end

                return false
            end

            local function covered(overlay, point)
                for _, popup in overlay.open do
                    if Pointer.over(popup.frame, point) then
                        return true
                    end
                end

                return false
            end

            function Overlay.covering(overlay)
                return covered(overlay, Pointer.location())
            end
            function Overlay.blocks(overlay, input)
                return covered(overlay, Vector2.new(input.Position.X, input.Position.Y))
            end
            function Overlay.closeAll(overlay)
                while#overlay.open > 0 do
                    Overlay.close(overlay, overlay.open[#overlay.open].frame)
                end
            end

            return table.freeze(Overlay)
        end

        function __ANTIBRAIN_MODULES.aG()
            local v = __ANTIBRAIN_MODULES.cache.aG

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aG = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Services = __ANTIBRAIN_MODULES.k()
            local TEXT_SIZE, PADDING_X, PADDING_Y, OFFSET_X, OFFSET_Y = 14, 5, 4, 15, 12
            local Tooltip = {}

            function Tooltip.new(kit, overlay, gui)
                local frame = Kit.frame(kit, gui, {
                    size = UDim2.new(),
                    zIndex = 100,
                    fill = 'main',
                    border = 'outline',
                    visible = false,
                })
                local label = Kit.text(kit, frame, {
                    text = '',
                    position = UDim2.fromOffset(3, 1),
                    size = UDim2.new(),
                    zIndex = 101,
                    textSize = TEXT_SIZE,
                    xAlignment = Enum.TextXAlignment.Left,
                })
                local tooltips = {
                    kit = kit,
                    overlay = overlay,
                    frame = frame,
                    label = label,
                    owner = nil,
                }

                kit.scope:connect(Services.UserInputService.InputChanged, function(
                    input
                )
                    if tooltips.owner and input.UserInputType == Enum.UserInputType.MouseMovement then
                        frame.Position = UDim2.fromOffset(input.Position.X + OFFSET_X, input.Position.Y + OFFSET_Y)
                    end
                end)

                return tooltips
            end
            function Tooltip.hide(tooltips)
                tooltips.owner = nil
                tooltips.frame.Visible = false
            end
            function Tooltip.attach(tooltips, target, text)
                Kit.hover(tooltips.kit.scope, target, function()
                    if Overlay.covering(tooltips.overlay) then
                        return
                    end

                    local bounds = Kit.measure(text, TEXT_SIZE)
                    local at = Pointer.location()

                    tooltips.owner = target
                    tooltips.label.Text = text
                    tooltips.label.Size = UDim2.fromOffset(bounds.X, bounds.Y)
                    tooltips.frame.Size = UDim2.fromOffset(bounds.X + PADDING_X, bounds.Y + PADDING_Y)
                    tooltips.frame.Position = UDim2.fromOffset(at.X + OFFSET_X, at.Y + OFFSET_Y)
                    tooltips.frame.Visible = true
                end, function()
                    if tooltips.owner == target then
                        Tooltip.hide(tooltips)
                    end
                end)
            end

            return table.freeze(Tooltip)
        end

        function __ANTIBRAIN_MODULES.aH()
            local v = __ANTIBRAIN_MODULES.cache.aH

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aH = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()
            __ANTIBRAIN_MODULES.aF()
            __ANTIBRAIN_MODULES.aC()

            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Pointer = __ANTIBRAIN_MODULES.aD()

            __ANTIBRAIN_MODULES.ax()
            __ANTIBRAIN_MODULES.aH()

            local Context = {}

            function Context.pressed(context, input)
                return Pointer.pressed(input) and not context.dragging and not Overlay.blocks(context.overlay, input)
            end
            function Context.secondary(context, input)
                return Pointer.secondary(input) and not context.dragging and not Overlay.blocks(context.overlay, input)
            end

            return table.freeze(Context)
        end

        function __ANTIBRAIN_MODULES.aI()
            local v = __ANTIBRAIN_MODULES.cache.aI

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aI = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.aC()

            local Pointer = __ANTIBRAIN_MODULES.aD()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local ARROW = 'rbxassetid://4292970642'
            local Cursor = {}

            function Cursor.new(kit, gui)
                local function image(size, zIndex)
                    local arrow = Instance.new('ImageLabel')

                    arrow.BackgroundTransparency = 1
                    arrow.Image = ARROW
                    arrow.Rotation = -45
                    arrow.Size = UDim2.fromOffset(size, size)
                    arrow.ZIndex = zIndex
                    arrow.Visible = false
                    arrow.Parent = gui

                    return arrow
                end

                local outline = image(19, 99)

                outline.ImageColor3 = Color3.new(0, 0, 0)

                local arrow = image(17, 100)

                kit.theme:bind(arrow, function()
                    arrow.ImageColor3 = kit.theme.colors.accent
                end)

                local cursor = {
                    kit = kit,
                    arrow = arrow,
                    outline = outline,
                    showing = nil,
                }

                kit.scope:add(function()
                    Cursor.hide(cursor)
                end)

                return cursor
            end
            function Cursor.show(cursor)
                if cursor.showing or cursor.kit.scope.closed then
                    return
                end

                local inputService = Services.UserInputService
                local scope = cursor.kit.scope:child()

                cursor.showing = {
                    scope = scope,
                    gameIcon = inputService.MouseIconEnabled,
                }
                cursor.arrow.Visible, cursor.outline.Visible = true, true

                local place = function(point)
                    cursor.arrow.Position = UDim2.fromOffset(point.X, point.Y - 1)
                    cursor.outline.Position = UDim2.fromOffset(point.X - 1, point.Y - 2)
                end

                place(Pointer.location())
                scope:connect(inputService.InputChanged, function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement then
                        place(Vector2.new(input.Position.X, input.Position.Y))
                    end
                end)

                inputService.MouseIconEnabled = false

                scope:connect(inputService:GetPropertyChangedSignal('MouseIconEnabled'), function(
                )
                    if inputService.MouseIconEnabled then
                        inputService.MouseIconEnabled = false
                    end
                end)
            end
            function Cursor.hide(cursor)
                local showing = cursor.showing

                if not showing then
                    return
                end

                cursor.showing = nil

                showing.scope:close()

                cursor.arrow.Visible, cursor.outline.Visible = false, false
                Services.UserInputService.MouseIconEnabled = showing.gameIcon
            end

            return table.freeze(Cursor)
        end

        function __ANTIBRAIN_MODULES.aJ()
            local v = __ANTIBRAIN_MODULES.cache.aJ

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aJ = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Failure = __ANTIBRAIN_MODULES.a()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Palette = __ANTIBRAIN_MODULES.aA()

            __ANTIBRAIN_MODULES.c()

            local Services = __ANTIBRAIN_MODULES.k()
            local SECONDS, SLIDE = 5, 0.4
            local WIDTH, TOP = 2560, 39
            local Notifications = {}

            local function bar(side)
                if side == 'Top' then
                    return UDim2.fromOffset(-1, 0), UDim2.new(1, 3, 0, 2)
                elseif side == 'Left' then
                    return UDim2.fromOffset(-1, -1), UDim2.new(0, 3, 1, 2)
                elseif side == 'Right' then
                    return UDim2.new(1, -2, 0, -1), UDim2.new(0, 3, 1, 2)
                end

                return UDim2.new(0, -1, 1, -2), UDim2.new(1, 3, 0, 2)
            end
            local function place(notifications)
                local style, area = notifications.style, notifications.area
                local left, right = style.anchor == 'Left', style.anchor == 'Right'

                area.AnchorPoint = Vector2.new(left and 0 or (right and 1 or 0.5), 0)
                area.Position = UDim2.new(style.x, 0, style.y, TOP)
                area.ClipsDescendants = style.clips
                area.Size = UDim2.fromOffset(WIDTH, style.clipDistance)
                notifications.layout.SortOrder = (style.sortOrder == 'Text Length' and {
                    Enum.SortOrder.Name,
                } or {
                    Enum.SortOrder.LayoutOrder,
                })[1]
                notifications.layout.HorizontalAlignment = (left and {
                    Enum.HorizontalAlignment.Left,
                } or {
                    (right and {
                        Enum.HorizontalAlignment.Right,
                    } or {
                        Enum.HorizontalAlignment.Center,
                    })[1],
                })[1]
            end

            function Notifications.new(kit, gui)
                local area = Instance.new('Frame')

                area.BackgroundTransparency = 1
                area.ZIndex = 100
                area.Parent = gui

                local column = Instance.new('Frame')

                column.BackgroundTransparency = 1
                column.Position = UDim2.fromOffset(0, 1)
                column.Size = UDim2.fromScale(1, 1)
                column.ZIndex = 100
                column.Parent = area

                local layout = Kit.list(column, 4)

                layout.VerticalAlignment = Enum.VerticalAlignment.Top

                local notifications = {
                    kit = kit,
                    area = area,
                    column = column,
                    layout = layout,
                    style = {
                        barSide = 'Bottom',
                        transparency = 0.75,
                        x = 0.5,
                        y = 0.6,
                        clips = true,
                        clipDistance = 200,
                        anchor = 'Center',
                        sortOrder = 'Default',
                        colors = nil,
                    },
                }

                place(notifications)

                return notifications
            end
            function Notifications.restyle(notifications, change)
                if notifications.kit.scope.closed then
                    return
                end

                change(notifications.style)

                if notifications.kit.scope.closed then
                    return
                end

                place(notifications)
            end

            local function own(life, instance)
                life:add(function()
                    instance:Destroy()
                end)
            end
            local function showOwned(notifications, text, seconds, life)
                local kit, style = notifications.kit, notifications.style

                if kit.scope.closed then
                    return
                end

                local colors = kit.theme.colors
                local forced = style.colors
                local main = (forced and {
                    forced.main,
                } or {
                    colors.main,
                })[1]
                local accent = (forced and {
                    forced.accent,
                } or {
                    colors.accent,
                })[1]
                local outline = (forced and {
                    forced.outline,
                } or {
                    colors.outline,
                })[1]
                local font = (forced and {
                    forced.text,
                } or {
                    colors.font,
                })[1]
                local bounds = Kit.measure(text, 14)

                if life.closed then
                    return
                end

                local width, height = bounds.X + 12, bounds.Y + 7
                local outer = Instance.new('Frame')

                own(life, outer)

                outer.BackgroundColor3 = main
                outer.BackgroundTransparency = style.transparency
                outer.BorderColor3 = Color3.new(0, 0, 0)
                outer.ClipsDescendants = true
                outer.Size = UDim2.fromOffset(0, height)
                outer.ZIndex = 100
                outer.Name = string.char(256 - math.max(1, #text % 256))

                local inner = Instance.new('Frame')

                own(life, inner)

                inner.BackgroundColor3 = main
                inner.BackgroundTransparency = style.transparency
                inner.BorderColor3 = outline
                inner.BorderMode = Enum.BorderMode.Inset
                inner.Size = UDim2.fromScale(1, 1)
                inner.ZIndex = 101
                inner.Parent = outer

                local body = Instance.new('Frame')

                own(life, body)

                body.BackgroundColor3 = Color3.new(1, 1, 1)
                body.BackgroundTransparency = style.transparency
                body.BorderSizePixel = 0
                body.Position = UDim2.fromOffset(1, 1)
                body.Size = UDim2.new(1, -2, 1, -2)
                body.ZIndex = 102
                body.Parent = inner

                local gradient = Instance.new('UIGradient')

                own(life, gradient)

                gradient.Color = ColorSequence.new(Palette.darker(main), main)
                gradient.Rotation = -90
                gradient.Parent = body

                local label = Instance.new('TextLabel')

                own(life, label)

                label.BackgroundTransparency = 1
                label.Font = Kit.font()
                label.Text = text
                label.TextColor3 = font
                label.TextSize = 14
                label.TextXAlignment = Enum.TextXAlignment.Left
                label.Position = UDim2.fromOffset(4, 0)
                label.Size = UDim2.new(1, -4, 1, 0)
                label.ZIndex = 103

                Kit.outline(label)

                label.Parent = body

                local accentBar = Instance.new('Frame')

                own(life, accentBar)

                accentBar.BackgroundColor3 = accent
                accentBar.BorderSizePixel = 0
                accentBar.Position, accentBar.Size = bar(style.barSide)
                accentBar.ZIndex = 104
                accentBar.Parent = outer
                outer.Parent = notifications.column

                local slide = TweenInfo.new(SLIDE, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tweens = Services.TweenService

                local function animate(size)
                    local tween = tweens:Create(outer, slide, {Size = size})

                    life:add(function()
                        tween:Cancel()
                    end)
                    tween:Play()
                end

                animate(UDim2.fromOffset(width, height))
                life:spawn(function()
                    local failure = Failure.capture(function()
                        task.wait(seconds or SECONDS)
                        animate(UDim2.fromOffset(0, height))
                        task.wait(SLIDE)
                    end)

                    life:close()

                    if failure then
                        error(failure, 0)
                    end
                end)
            end

            function Notifications.show(notifications, text, seconds)
                if notifications.kit.scope.closed then
                    return
                end

                local life = notifications.kit.scope:child()
                local failure = Failure.capture(showOwned, notifications, text, seconds, life)

                if failure or life.closed then
                    life:close()

                    if failure then
                        error(failure, 0)
                    end
                end
            end

            return table.freeze(Notifications)
        end

        function __ANTIBRAIN_MODULES.aK()
            local v = __ANTIBRAIN_MODULES.cache.aK

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aK = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.aI()
            __ANTIBRAIN_MODULES.aw()

            local Slot = {}

            function Slot.new(context, column, registry)
                return {
                    context = context,
                    column = column,
                    registry = registry,
                    rows = 0,
                }
            end
            function Slot.row(slot, height)
                slot.rows = slot.rows + 1

                local row = Instance.new('Frame')

                row.BackgroundTransparency = 1
                row.BorderSizePixel = 0
                row.Size = UDim2.new(1, 0, 0, height)
                row.LayoutOrder = slot.rows
                row.ZIndex = 1
                row.Parent = slot.column

                return row
            end

            return table.freeze(Slot)
        end

        function __ANTIBRAIN_MODULES.aL()
            local v = __ANTIBRAIN_MODULES.cache.aL

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aL = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()

            __ANTIBRAIN_MODULES.b()

            local Failure = __ANTIBRAIN_MODULES.a()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local HEIGHT, GAP, CONFIRM_SECONDS = 20, 5, 0.5
            local Button = {}

            local function build(slot, row, info, size, position)
                local context = slot.context
                local kit = context.kit
                local outer, inner, restyleOuter = Kit.well(kit, row, size, 5)

                outer.Position = position
                outer.Active = true

                Kit.sheen(inner)

                local label, tint = Kit.text(kit, inner, {
                    text = info.text,
                    size = UDim2.new(1, 0, 1, -1),
                    zIndex = 6,
                    textSize = 14,
                })

                Kit.highlight(kit, outer, restyleOuter, 'outline', 'black')

                if info.tooltip then
                    Tooltip.attach(context.tooltips, outer, info.tooltip)
                end

                local function run()
                    local failure = Failure.capture(info.callback)

                    if failure then
                        context.report(failure)
                    end
                end

                local button
                local asking = nil
                local asked = 0

                local function stopAsking()
                    asking = nil
                    label.Text = button.text

                    tint('font')
                end

                kit.scope:connect(outer.InputBegan, function(input)
                    if not Context.pressed(context, input) then
                        return
                    end
                    if not info.doubleClick then
                        run()

                        return
                    end
                    if asking then
                        stopAsking()
                        run()

                        return
                    end

                    asked = asked + 1

                    local this = asked

                    asking = this
                    label.Text = 'Are you sure?'

                    tint('risk')
                    kit.scope:delay(CONFIRM_SECONDS, function()
                        if asking == this then
                            stopAsking()
                        end
                    end)
                end)

                button = {
                    text = info.text,
                    setText = function(self, text)
                        self.text = text

                        if not asking then
                            label.Text = text
                        end
                    end,
                    button = function(_, sibling)
                        outer.Size = UDim2.new(0.5, -2, 0, HEIGHT)

                        return build(slot, row, sibling, UDim2.new(0.5, -5, 0, HEIGHT), UDim2.new(0.5, 1, 0, 0))
                    end,
                }

                return button
            end

            function Button.new(slot, info)
                local row = Slot.row(slot, HEIGHT + GAP)

                return build(slot, row, info, UDim2.new(1, -4, 0, HEIGHT), UDim2.new())
            end

            return table.freeze(Button)
        end

        function __ANTIBRAIN_MODULES.aM()
            local v = __ANTIBRAIN_MODULES.cache.aM

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aM = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Values = {}

            function Values.round(value, rounding, increment)
                if increment and increment > 0 then
                    return tonumber(('%.10f'):format(math.round(value / increment) * increment)) or value
                elseif rounding <= 0 then
                    return math.floor(value)
                end

                return tonumber((string.format('%%.%sf', tostring(rounding))):format(value)) or value
            end
            function Values.fraction(value, min, max)
                if max == min then
                    return 0
                end

                return math.clamp((value - min) / (max - min), 0, 1)
            end
            function Values.at(fraction, min, max, rounding, increment)
                local value = Values.round(min + (max - min) * math.clamp(fraction, 0, 1), rounding, increment)

                return math.clamp(value, min, max)
            end
            function Values.sliderText(
                text,
                value,
                max,
                suffix,
                compact,
                hideMax
            )
                if compact then
                    return string.format('%s: %s%s', tostring(text), tostring(value), tostring(suffix))
                elseif hideMax then
                    return string.format('%s%s', tostring(value), tostring(suffix))
                end

                return string.format('%s%s/%s%s', tostring(value), tostring(suffix), tostring(max), tostring(suffix))
            end
            function Values.sliderLane(index, count)
                local between = count > 1 and count % 2 == 1 and 7 or 6
                local beside = index > 1

                return {
                    share = 1 / count,
                    width = -6,
                    start = (index - 1) / count,
                    offset = (index - 1) * (between - 6),
                    titleX = (beside and {
                        (4 - between),
                    } or {0})[1],
                    titleY = beside and 1 or 0,
                }
            end
            function Values.dropdownText(values, chosen)
                local text = ''

                if type(chosen) == 'table' then
                    local names = {}

                    for _, value in values do
                        if chosen[value] then
                            table.insert(names, value)
                        end
                    end

                    text = table.concat(names, ', ')
                elseif type(chosen) == 'string' then
                    text = chosen
                end

                return text == '' and '...' or text
            end
            function Values.offered(values, chosen)
                return (chosen and table.find(values, chosen) and {chosen} or {nil})[1]
            end
            function Values.offeredSet(values, chosen)
                local kept = {}

                for name, on in chosen do
                    if on and table.find(values, name) then
                        kept[name] = true
                    end
                end

                return kept
            end
            function Values.sameSet(a, b)
                for name in a do
                    if not b[name] then
                        return false
                    end
                end
                for name in b do
                    if not a[name] then
                        return false
                    end
                end

                return true
            end
            function Values.inputText(text, previous, numeric, maxLength)
                if maxLength and #text > maxLength then
                    text = text:sub(1, maxLength)
                end
                if numeric and #text > 0 then
                    local value = tonumber(text)

                    if not value or not (value > -math.huge and value < math.huge) then
                        return previous
                    end
                end

                return text
            end

            return table.freeze(Values)
        end

        function __ANTIBRAIN_MODULES.aN()
            local v = __ANTIBRAIN_MODULES.cache.aN

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aN = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()

            __ANTIBRAIN_MODULES.b()

            local Kit = __ANTIBRAIN_MODULES.aC()
            local Options = __ANTIBRAIN_MODULES.aw()
            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local Values = __ANTIBRAIN_MODULES.aN()
            local BOX, ITEM, SHOWN, TEXT, GAP = 20, 20, 8, 13, 5
            local Dropdown = {}

            local function makeBox(context, row, top, tooltip)
                local kit = context.kit
                local outer, inner, restyleOuter = Kit.well(kit, row, UDim2.new(1, 
-4, 0, BOX), 5)

                outer.Position = UDim2.fromOffset(0, top)
                outer.Active = true

                Kit.sheen(inner)

                local arrow = Kit.text(kit, inner, {
                    text = '>',
                    anchor = Vector2.new(0, 0.5),
                    position = UDim2.new(1, -16, 0.5, 0),
                    size = UDim2.fromOffset(12, 12),
                    zIndex = 7,
                    textSize = 13,
                })
                local shown = Kit.text(kit, inner, {
                    text = '...',
                    position = UDim2.fromOffset(5, -1),
                    size = UDim2.new(1, -5, 1, 0),
                    zIndex = 7,
                    textSize = 14,
                    xAlignment = Enum.TextXAlignment.Left,
                    wrapped = true,
                })

                Kit.highlight(kit, outer, restyleOuter, 'outline', 'black')

                if tooltip then
                    Tooltip.attach(context.tooltips, outer, tooltip)
                end

                return outer, arrow, shown
            end
            local function makeList(context)
                local kit = context.kit
                local list = Kit.frame(kit, context.gui, {
                    size = UDim2.new(),
                    zIndex = 20,
                    fill = 'black',
                    border = 'black',
                    visible = false,
                    active = true,
                })
                local listWell = Kit.frame(kit, list, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = 21,
                    fill = 'main',
                    inset = true,
                })
                local scroller = Instance.new('ScrollingFrame')

                scroller.BackgroundTransparency = 1
                scroller.BorderSizePixel = 0
                scroller.CanvasSize = UDim2.new()
                scroller.Size = UDim2.fromScale(1, 1)
                scroller.ZIndex = 21
                scroller.TopImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
                scroller.BottomImage = 'rbxasset://textures/ui/Scroll/scroll-middle.png'
                scroller.ScrollBarThickness = context.mobile and 15 or 3

                kit.theme:bind(scroller, function()
                    scroller.ScrollBarImageColor3 = kit.theme.colors.accent
                end)

                scroller.Parent = listWell

                Kit.list(scroller)

                return list, scroller
            end
            local function build(slot, text, tooltip, values, core)
                local context = slot.context
                local kit = context.kit
                local scope = kit.scope
                local top = (text and {TEXT} or {0})[1]
                local row = Slot.row(slot, top + BOX + GAP)

                if text then
                    Kit.text(kit, row, {
                        text = text,
                        size = UDim2.new(1, 0, 0, 10),
                        zIndex = 5,
                        textSize = 14,
                        xAlignment = Enum.TextXAlignment.Left,
                        yAlignment = Enum.TextYAlignment.Bottom,
                    })
                end

                local outer, arrow, shown = makeBox(context, row, top, tooltip)
                local list, scroller = makeList(context)
                local tints = {}
                local items = scope:child()
                local count = 0

                local function place()
                    list.Position = UDim2.fromOffset(outer.AbsolutePosition.X, outer.AbsolutePosition.Y + BOX + 1)
                    list.Size = UDim2.fromOffset(outer.AbsoluteSize.X + 0.5, math.min(count, SHOWN) * ITEM + 1)
                end
                local function redraw()
                    shown.Text = core.shown()

                    for value, tint in tints do
                        tint(core.chosen(value) and 'accent' or 'font')
                    end
                end
                local function rebuild(offered)
                    items:close()

                    items = scope:child()

                    for _, child in scroller:GetChildren()do
                        if child:IsA('Frame') then
                            child:Destroy()
                        end
                    end

                    table.clear(tints)

                    count = #offered

                    for index, value in offered do
                        local item = Kit.frame(kit, scroller, {
                            size = UDim2.new(1, -1, 0, ITEM),
                            zIndex = 23,
                            fill = 'main',
                            border = 'outline',
                            active = true,
                            layoutOrder = index,
                        })

                        item.BorderMode = Enum.BorderMode.Middle

                        local label, tint = Kit.text(kit, item, {
                            text = value,
                            position = UDim2.fromOffset(6, 0),
                            size = UDim2.new(1, -6, 1, 0),
                            zIndex = 25,
                            textSize = 14,
                            xAlignment = Enum.TextXAlignment.Left,
                        })

                        tints[value] = tint

                        Kit.hover(items, item, function()
                            item.ZIndex = 24
                        end, function()
                            item.ZIndex = 23
                        end)
                        items:connect(label.InputBegan, function(input)
                            if Pointer.pressed(input) then
                                core.click(value)
                            end
                        end)
                    end

                    scroller.CanvasSize = UDim2.fromOffset(0, count * ITEM + 1)

                    place()
                    redraw()
                end

                scope:connect(outer:GetPropertyChangedSignal('AbsolutePosition'), place)
                scope:connect(outer.InputBegan, function(input)
                    if not Context.pressed(context, input) then
                        return
                    end

                    local overlay = context.overlay

                    if Overlay.isOpen(overlay, list) then
                        Overlay.close(overlay, list)

                        return
                    end

                    place()

                    list.Visible = true
                    arrow.Rotation = 90

                    Overlay.show(overlay, {
                        frame = list,
                        anchor = outer,
                        close = function()
                            list.Visible = false
                            arrow.Rotation = 0
                        end,
                    })
                end)
                rebuild(values)

                return {
                    redraw = redraw,
                    rebuild = rebuild,
                    row = row,
                }
            end

            function Dropdown.single(slot, id, info)
                local context = slot.context
                local changed = Signal.new(context.report)
                local dropdown
                local built

                local function tell(value)
                    changed:fire(value)
                    context.changed:fire()
                end

                dropdown = {
                    id = id,
                    value = Values.offered(info.values, info.default),
                    values = table.clone(info.values),
                    set = function(self, value)
                        if value == self.value or (value ~= nil and not table.find(self.values, value)) then
                            return
                        end
                        if value == nil and not info.allowNull then
                            return
                        end

                        self.value = value

                        built.redraw()
                        tell(value)
                    end,
                    setValues = function(self, values)
                        self.values = table.clone(values)

                        local kept = Values.offered(self.values, self.value)
                        local dropped = kept ~= self.value and info.allowNull == true

                        if dropped then
                            self.value = kept
                        end

                        built.rebuild(self.values)

                        if dropped then
                            tell(kept)
                        end
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                    setVisible = function(_, visible)
                        built.row.Visible = visible
                    end,
                }
                built = build(slot, info.text, info.tooltip, dropdown.values, {
                    chosen = function(value)
                        return dropdown.value == value
                    end,
                    click = function(value)
                        dropdown:set((dropdown.value == value and {nil} or {value})[1])
                    end,
                    shown = function()
                        return Values.dropdownText(dropdown.values, dropdown.value)
                    end,
                })

                Options.add(slot.registry, {
                    id = id,
                    save = function()
                        return dropdown.value or false
                    end,
                    load = function(saved)
                        if saved == false then
                            dropdown:set(nil)
                        elseif type(saved) == 'string' then
                            dropdown:set(saved)
                        end
                    end,
                })

                return dropdown
            end
            function Dropdown.multi(slot, id, info)
                local context = slot.context
                local changed = Signal.new(context.report)
                local defaults = {}
                local listed = info.default or {}

                for _, value in listed do
                    defaults[value] = true
                end

                local dropdown
                local built

                local function tell(value)
                    changed:fire(value)
                    context.changed:fire()
                end
                local function allowed(chosen)
                    return info.allowNull == true or next(chosen) ~= nil
                end

                dropdown = {
                    id = id,
                    value = Values.offeredSet(info.values, defaults),
                    values = table.clone(info.values),
                    set = function(self, value)
                        local chosen = Values.offeredSet(self.values, value)

                        if Values.sameSet(chosen, self.value) or not allowed(chosen) then
                            return
                        end

                        self.value = chosen

                        built.redraw()
                        tell(chosen)
                    end,
                    setValues = function(self, values)
                        self.values = table.clone(values)

                        local kept = Values.offeredSet(self.values, self.value)
                        local dropped = not Values.sameSet(kept, self.value) and allowed(kept)

                        if dropped then
                            self.value = kept
                        end

                        built.rebuild(self.values)

                        if dropped then
                            tell(kept)
                        end
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                    setVisible = function(_, visible)
                        built.row.Visible = visible
                    end,
                }
                built = build(slot, info.text, info.tooltip, dropdown.values, {
                    chosen = function(value)
                        return dropdown.value[value] == true
                    end,
                    click = function(value)
                        local chosen = table.clone(dropdown.value)

                        if chosen[value] then
                            chosen[value] = nil
                        else
                            chosen[value] = true
                        end

                        dropdown:set(chosen)
                    end,
                    shown = function()
                        return Values.dropdownText(dropdown.values, dropdown.value)
                    end,
                })

                Options.add(slot.registry, {
                    id = id,
                    save = function()
                        local chosen = {}

                        for _, value in dropdown.values do
                            if dropdown.value[value] then
                                table.insert(chosen, value)
                            end
                        end

                        return chosen
                    end,
                    load = function(saved)
                        if type(saved) ~= 'table' then
                            return
                        end

                        local value = {}

                        for _, name in saved do
                            if type(name) == 'string' then
                                value[name] = true
                            end
                        end

                        dropdown:set(value)
                    end,
                })

                return dropdown
            end

            return table.freeze(Dropdown)
        end

        function __ANTIBRAIN_MODULES.aO()
            local v = __ANTIBRAIN_MODULES.cache.aO

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aO = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()

            __ANTIBRAIN_MODULES.b()

            local Failure = __ANTIBRAIN_MODULES.a()
            local Identity = __ANTIBRAIN_MODULES._()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Scope = __ANTIBRAIN_MODULES.c()
            local Services = __ANTIBRAIN_MODULES.k()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local GAP, ZOOM, HOVER, PRESS, VIEW = 5, 1.6, 1.09375, 0.95, 0.7
            local COLUMNS, BETWEEN, MARGIN, SLACK = 6, 5, 6, 2
            local START = 96
            local TEXT_SIZE, TEXT_HEIGHT = 12, 14
            local PLATE, PLATE_SIZE = 'rbxassetid://13188153054', 0.4
            local REST, OVER, CHOSEN = 0.85, 0.7, 0.45

            local function idle()
                return Color3.fromRGB(51, 51, 51)
            end
            local function selectedColor()
                return Color3.new(0.133333, 0.34902, 0.0980392)
            end
            local function selectedOutline()
                return Color3.fromRGB(70, 160, 50)
            end

            local Gallery = {}

            function Gallery.new(slot, info)
                local context = slot.context
                local kit = context.kit
                local scope = kit.scope
                local columns, rows = math.max(info.columns or COLUMNS, 1), math.max(info.rows, 1)
                local pressed = Signal.new(context.report)

                local function heightFor(side)
                    return rows * side + (rows - 1) * BETWEEN + 2 * MARGIN
                end

                local row = Slot.row(slot, heightFor(START) + GAP)
                local outer, inner, restyleOuter = Kit.well(kit, row, UDim2.new(1, 
-4, 0, heightFor(START)), 5)

                Kit.sheen(inner)
                Kit.highlight(kit, outer, restyleOuter, 'outline', 'black')

                local scroller = Instance.new('ScrollingFrame')

                scroller.BackgroundTransparency = 1
                scroller.BorderSizePixel = 0
                scroller.Size = UDim2.fromScale(1, 1)
                scroller.CanvasSize = UDim2.new()
                scroller.AutomaticCanvasSize = Enum.AutomaticSize.Y
                scroller.TopImage = ''
                scroller.BottomImage = ''
                scroller.ScrollBarThickness = 0
                scroller.ClipsDescendants = true
                scroller.ZIndex = 7
                scroller.Parent = inner

                local padding = Instance.new('UIPadding')

                padding.PaddingTop = UDim.new(0, MARGIN)
                padding.PaddingBottom = UDim.new(0, MARGIN)
                padding.PaddingLeft = UDim.new(0, MARGIN)
                padding.PaddingRight = UDim.new(0, MARGIN)
                padding.Parent = scroller

                local grid = Instance.new('UIGridLayout')

                grid.CellPadding = UDim2.fromOffset(BETWEEN, BETWEEN)
                grid.CellSize = UDim2.fromOffset(START, START)
                grid.FillDirection = Enum.FillDirection.Horizontal
                grid.SortOrder = Enum.SortOrder.LayoutOrder
                grid.Parent = scroller

                local function fit()
                    local width = scroller.AbsoluteSize.X

                    if width <= 0 then
                        return
                    end

                    local usable = width - 2 * MARGIN - (columns - 1) * BETWEEN
                    local side = math.max(math.floor((usable - SLACK) / columns), 16)
                    local spare = math.max(usable - side * columns, 0)

                    grid.CellSize = UDim2.fromOffset(side, side)
                    padding.PaddingLeft = UDim.new(0, MARGIN + math.floor(spare / 2))
                    padding.PaddingRight = UDim.new(0, MARGIN + math.ceil(spare / 2))
                    row.Size = UDim2.new(1, 0, 0, heightFor(side) + GAP)
                    outer.Size = UDim2.new(1, -4, 0, heightFor(side))
                end

                scope:connect(scroller:GetPropertyChangedSignal('AbsoluteSize'), fit)
                fit()

                local empty = nil

                if info.empty then
                    empty = Kit.text(kit, inner, {
                        text = info.empty,
                        size = UDim2.fromScale(1, 1),
                        zIndex = 8,
                        textSize = 14,
                        shade = 'dim',
                        visible = false,
                    })
                end

                local cells = {}
                local easing = TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out)
                local fading = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

                local function settle(cell)
                    if cell.tween then
                        cell.tween:Cancel()
                    end

                    local size = cell.zoom * ((cell.pressed and {PRESS} or {
                        (cell.hovered and {HOVER} or {1})[1],
                    })[1])
                    local tween = Services.TweenService:Create(cell.image, easing, {
                        Size = UDim2.fromScale(size, size),
                    })

                    cell.tween = tween

                    tween:Play()
                end
                local function paint(cell, animate)
                    local color = (cell.selected and {
                        (selectedColor()),
                    } or {
                        (idle()),
                    })[1]
                    local seeThrough = (cell.selected and {CHOSEN} or {
                        (cell.hovered and {OVER} or {REST})[1],
                    })[1]

                    cell.outline.Enabled = cell.selected

                    if cell.fade then
                        cell.fade:Cancel()

                        cell.fade = nil
                    end
                    if animate then
                        local fade = Services.TweenService:Create(cell.button, fading, {
                            BackgroundColor3 = color,
                            BackgroundTransparency = seeThrough,
                        })

                        cell.fade = fade

                        fade:Play()
                    else
                        cell.button.BackgroundColor3 = color
                        cell.button.BackgroundTransparency = seeThrough
                    end
                end
                local function resemble(label, template)
                    label.FontFace = template.FontFace
                    label.TextSize = template.TextSize
                    label.TextColor3 = template.TextColor3
                    label.TextTransparency = template.TextTransparency
                    label.TextStrokeColor3 = template.TextStrokeColor3
                    label.TextStrokeTransparency = template.TextStrokeTransparency
                    label.TextXAlignment = template.TextXAlignment
                    label.TextYAlignment = template.TextYAlignment
                    label.TextWrapped = template.TextWrapped
                    label.TextScaled = template.TextScaled
                    label.TextTruncate = template.TextTruncate
                    label.RichText = template.RichText
                    label.LineHeight = template.LineHeight
                    label.AnchorPoint = template.AnchorPoint
                    label.Position = template.Position
                    label.Size = template.Size

                    for _, modifier in template:GetChildren()do
                        if modifier:IsA('UIStroke') then
                            local stroke = Instance.new('UIStroke')

                            stroke.Color = modifier.Color
                            stroke.Thickness = modifier.Thickness
                            stroke.Transparency = modifier.Transparency
                            stroke.ApplyStrokeMode = modifier.ApplyStrokeMode
                            stroke.LineJoinMode = modifier.LineJoinMode
                            stroke.Parent = label
                        elseif modifier:IsA('UITextSizeConstraint') then
                            local constraint = Instance.new('UITextSizeConstraint')

                            constraint.MinTextSize = modifier.MinTextSize
                            constraint.MaxTextSize = modifier.MaxTextSize
                            constraint.Parent = label
                        elseif modifier:IsA('UIPadding') then
                            local inset = Instance.new('UIPadding')

                            inset.PaddingTop = modifier.PaddingTop
                            inset.PaddingBottom = modifier.PaddingBottom
                            inset.PaddingLeft = modifier.PaddingLeft
                            inset.PaddingRight = modifier.PaddingRight
                            inset.Parent = label
                        end
                    end
                end
                local function makeTitle(button, life)
                    local template = nil
                    local asked = info.title

                    if asked then
                        local ok, given = pcall(asked)

                        if ok and given then
                            template = given
                        end
                    end

                    assert(not life.closed, 'Gallery scope closed while making a title')

                    if template then
                        local title = Scope.own(life, Instance.new('TextLabel'))

                        title.BackgroundTransparency = 1
                        title.BorderSizePixel = 0
                        title.ZIndex = 10

                        if not Failure.capture(resemble, title, template) then
                            title.Parent = button

                            return title
                        end

                        title:Destroy()
                    end

                    local title = Kit.text(kit, button, {
                        text = '',
                        position = UDim2.new(0, 0, 1, -TEXT_HEIGHT - 2),
                        size = UDim2.new(1, 0, 0, TEXT_HEIGHT),
                        zIndex = 10,
                        textSize = TEXT_SIZE,
                        engineStroke = true,
                    })

                    title.TextTruncate = Enum.TextTruncate.AtEnd

                    return title
                end
                local function makeOwned(key, life)
                    local button = Scope.own(life, Instance.new('ImageButton'))

                    button.AutoButtonColor = false
                    button.Image = ''
                    button.BorderSizePixel = 0
                    button.ZIndex = 8

                    local outline = Scope.own(life, Instance.new('UIStroke'))

                    outline.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
                    outline.Color = selectedOutline()
                    outline.Thickness = 1
                    outline.Enabled = false
                    outline.Parent = button

                    local image = Scope.own(life, Instance.new('ImageLabel'))

                    image.AnchorPoint = Vector2.new(0.5, 0.5)
                    image.Position = UDim2.fromScale(0.5, 0.5)
                    image.Size = UDim2.fromScale(ZOOM, ZOOM)
                    image.BackgroundTransparency = 1
                    image.BorderSizePixel = 0
                    image.ScaleType = Enum.ScaleType.Fit
                    image.ZIndex = 9
                    image.Parent = button

                    local plate = Scope.own(life, Instance.new('ImageLabel'))

                    plate.AnchorPoint = Vector2.new(0.5, 0.5)
                    plate.Position = UDim2.fromScale(0.5, 0.5)
                    plate.Size = UDim2.fromScale(PLATE_SIZE, PLATE_SIZE)
                    plate.BackgroundTransparency = 1
                    plate.BorderSizePixel = 0
                    plate.Image = PLATE
                    plate.ImageColor3 = Color3.new(0, 0, 0)
                    plate.ImageTransparency = 0.75
                    plate.ZIndex = 8
                    plate.Parent = image

                    local cell = {
                        scope = life,
                        button = button,
                        outline = outline,
                        image = image,
                        title = makeTitle(button, life),
                        view = nil,
                        zoom = ZOOM,
                        tween = nil,
                        fade = nil,
                        selected = false,
                        hovered = false,
                        pressed = false,
                    }

                    life:add(function()
                        if cell.view and cell.view.Parent == cell.button then
                            cell.view.Parent = nil
                            cell.view = nil
                        end
                    end)
                    life:add(function()
                        if cell.tween then
                            cell.tween:Cancel()
                        end
                    end)
                    life:add(function()
                        if cell.fade then
                            cell.fade:Cancel()
                        end
                    end)
                    paint(cell, false)
                    Kit.hover(life, button, function()
                        cell.hovered = true

                        paint(cell, true)
                        settle(cell)
                    end, function()
                        cell.hovered = false
                        cell.pressed = false

                        paint(cell, true)
                        settle(cell)
                    end)
                    life:connect(button.InputBegan, function(input)
                        if Context.pressed(context, input) then
                            cell.pressed = true

                            settle(cell)
                            pressed:fire(key, false)
                        elseif Context.secondary(context, input) then
                            pressed:fire(key, true)
                        end
                    end)
                    life:connect(button.InputEnded, function(input)
                        if cell.pressed and Pointer.pressed(input) then
                            cell.pressed = false

                            settle(cell)
                        end
                    end)

                    button.Parent = scroller

                    return cell
                end
                local function make(key)
                    local life = scope:child()
                    local ok, cell = xpcall(makeOwned, Failure.traceback, key, life)

                    if not ok then
                        life:close()
                        error(cell, 0)
                    end

                    return cell
                end

                local updating = 0

                local function current(revision)
                    return revision == updating and not scope.closed
                end
                local function seat(cell, view, revision)
                    if cell.view == view then
                        return
                    end
                    if cell.view then
                        local previous = cell.view

                        cell.view = nil
                        previous.Parent = nil

                        if not current(revision) then
                            return
                        end
                    end

                    cell.view = view

                    if view then
                        view.AnchorPoint = Vector2.new(0.5, 0.5)

                        if not current(revision) then
                            return
                        end

                        view.Position = UDim2.fromScale(0.5, 0.46)

                        if not current(revision) then
                            return
                        end

                        view.Size = UDim2.fromScale(VIEW, VIEW)

                        if not current(revision) then
                            return
                        end

                        view.ZIndex = 9

                        if not current(revision) then
                            return
                        end

                        view.Visible = true

                        if not current(revision) then
                            return
                        end

                        view.Parent = cell.button
                    end
                end

                local showing = 0

                local function reveal(mine, key)
                    task.wait()
                    Identity.restore()

                    local cell = (key and {
                        cells[key],
                    } or {nil})[1]

                    if mine ~= showing or not cell then
                        return
                    end

                    local top = cell.button.AbsolutePosition.Y - scroller.AbsolutePosition.Y + scroller.CanvasPosition.Y
                    local bottom = top + cell.button.AbsoluteSize.Y
                    local window, at = scroller.AbsoluteSize.Y, scroller.CanvasPosition.Y

                    if top - MARGIN < at then
                        scroller.CanvasPosition = Vector2.new(0, math.max(top - MARGIN, 0))
                    elseif bottom + MARGIN > at + window then
                        scroller.CanvasPosition = Vector2.new(0, bottom + MARGIN - window)
                    end
                end

                local listed = {}
                local listedCount = 0

                local function apply(items, revision)
                    local keep = {}
                    local selectedKey = nil

                    for order, item in items do
                        if not current(revision) then
                            return
                        end

                        keep[item.key] = true

                        if item.selected and not selectedKey then
                            selectedKey = item.key
                        end

                        local cell = cells[item.key]
                        local created = cell == nil

                        if not cell then
                            local made = make(item.key)

                            if not current(revision) then
                                made.scope:close()

                                return
                            end

                            cell = made
                            cells[item.key] = cell
                        end

                        cell.button.LayoutOrder = order

                        if not current(revision) then
                            return
                        end

                        local was = cell.selected

                        cell.selected = item.selected == true

                        paint(cell, not created and was ~= cell.selected)

                        if not current(revision) then
                            return
                        end

                        cell.title.Text = item.text

                        if not current(revision) then
                            return
                        end
                        if cell.image.Image ~= item.image then
                            cell.image.Image = item.image
                        end
                        if not current(revision) then
                            return
                        end

                        cell.image.ImageColor3 = (item.off and {
                            (Color3.new(1, 0, 0)),
                        } or {
                            (Color3.new(1, 1, 1)),
                        })[1]

                        if not current(revision) then
                            return
                        end

                        cell.image.ImageTransparency = item.off and 0.75 or 0

                        if not current(revision) then
                            return
                        end

                        local zoom = item.zoom or ZOOM

                        if zoom ~= cell.zoom then
                            cell.zoom = zoom
                            cell.image.Size = UDim2.fromScale(zoom, zoom)
                        end
                        if not current(revision) then
                            return
                        end

                        seat(cell, item.view, revision)

                        if not current(revision) then
                            return
                        end
                    end
                    for key, cell in cells do
                        if not current(revision) then
                            return
                        end
                        if not keep[key] then
                            cells[key] = nil

                            cell.scope:close()

                            if not current(revision) then
                                return
                            end
                        end
                    end

                    if empty then
                        empty.Visible = #items == 0
                    end
                    if not current(revision) then
                        return
                    end

                    local same = #items == listedCount

                    for key in keep do
                        same = same and listed[key] == true
                    end

                    listed, listedCount = keep, #items

                    if not same then
                        scroller.CanvasPosition = Vector2.zero

                        if not current(revision) then
                            return
                        end

                        showing = showing + 1

                        local mine = showing

                        scope:spawn(function()
                            reveal(mine, selectedKey)
                        end)
                    end
                end

                local gallery = {
                    setItems = function(_, items)
                        if scope.closed then
                            return
                        end

                        Identity.restore()

                        updating = updating + 1

                        local failure = Failure.capture(apply, items, updating)

                        if failure then
                            error(string.format('%s\n(thread identity %s)', tostring(failure), tostring(Identity.current() or 'unknown')), 0)
                        end
                    end,
                    onPressed = function(_, callback)
                        return pressed:connect(callback)
                    end,
                    setVisible = function(_, visible)
                        if scope.closed then
                            return
                        end

                        row.Visible = visible
                    end,
                }

                return gallery
            end

            return table.freeze(Gallery)
        end

        function __ANTIBRAIN_MODULES.aP()
            local v = __ANTIBRAIN_MODULES.cache.aP

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aP = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()

            local Kit = __ANTIBRAIN_MODULES.aC()
            local Options = __ANTIBRAIN_MODULES.aw()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local Values = __ANTIBRAIN_MODULES.aN()
            local TEXT, BOX, GAP, MARGIN = 15, 20, 5, 2
            local TEXT_GAP = 1
            local Input = {}

            function Input.new(slot, id, info)
                local context = slot.context
                local kit = context.kit
                local scope = kit.scope
                local changed = Signal.new(context.report)
                local gap = info.captionGap or TEXT_GAP
                local row = Slot.row(slot, TEXT + gap + BOX + GAP)

                Kit.text(kit, row, {
                    text = info.text,
                    size = UDim2.new(1, 0, 0, TEXT),
                    zIndex = 5,
                    textSize = 14,
                    xAlignment = Enum.TextXAlignment.Left,
                })

                local outer, inner, restyleOuter = Kit.well(kit, row, UDim2.new(1, 
-4, 0, BOX), 5)

                outer.Position = UDim2.fromOffset(0, TEXT + gap)

                Kit.highlight(kit, outer, restyleOuter, 'outline', 'black')

                if info.tooltip then
                    Tooltip.attach(context.tooltips, outer, info.tooltip)
                end

                Kit.sheen(inner)

                local clip = Kit.frame(kit, inner, {
                    position = UDim2.fromOffset(5, 0),
                    size = UDim2.new(1, -5, 1, 0),
                    zIndex = 7,
                    clips = true,
                })
                local box = Instance.new('TextBox')

                box.BackgroundTransparency = 1
                box.Size = UDim2.fromScale(5, 1)
                box.Font = Kit.font()
                box.PlaceholderColor3 = Color3.fromRGB(190, 190, 190)
                box.PlaceholderText = info.placeholder or ''
                box.ClearTextOnFocus = info.clearOnFocus == true
                box.Text = info.default or ''
                box.TextSize = 14
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ZIndex = 7

                Kit.outline(box)
                kit.theme:bind(box, function()
                    box.TextColor3 = kit.theme.colors.font
                end)

                box.Parent = clip

                local function scroll()
                    local width = clip.AbsoluteSize.X

                    if not box:IsFocused() or box.TextBounds.X <= width - 2 * MARGIN then
                        box.Position = UDim2.fromOffset(MARGIN, 0)

                        return
                    end

                    local cursor = box.CursorPosition

                    if cursor == -1 then
                        return
                    end

                    local before = Kit.measure(box.Text:sub(1, cursor - 1), box.TextSize, Vector2.new(math.huge, math.huge)).X
                    local at = box.Position.X.Offset + before

                    if at < MARGIN then
                        box.Position = UDim2.fromOffset(MARGIN - before, 0)
                    elseif at > width - MARGIN - 1 then
                        box.Position = UDim2.fromOffset(width - before - MARGIN - 1, 0)
                    end
                end

                scope:connect(box:GetPropertyChangedSignal('CursorPosition'), scroll)
                scope:connect(box.Focused, scroll)
                scope:connect(box.FocusLost, scroll)

                local input
                local revision = 0

                input = {
                    id = id,
                    value = box.Text,
                    set = function(self, value)
                        if scope.closed then
                            return
                        end

                        local taken = Values.inputText(value, self.value, info.numeric == true, info.maxLength)
                        local different = taken ~= self.value

                        if different then
                            self.value = taken
                            revision = revision + 1
                        end

                        local mine = revision

                        if box.Text ~= taken then
                            box.Text = taken
                        end
                        if not different or mine ~= revision or scope.closed then
                            return
                        end

                        changed:fire(taken)
                        context.changed:fire()
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                    setVisible = function(_, visible)
                        row.Visible = visible
                    end,
                }

                if info.finished then
                    scope:connect(box.FocusLost, function()
                        input:set(box.Text)
                    end)
                else
                    scope:connect(box:GetPropertyChangedSignal('Text'), function(
                    )
                        input:set(box.Text)
                        scroll()
                    end)
                end

                scroll()
                Options.add(slot.registry, {
                    id = id,
                    save = function()
                        return input.value
                    end,
                    load = function(saved)
                        if type(saved) == 'string' then
                            input:set(saved)
                        end
                    end,
                })

                return input
            end

            return table.freeze(Input)
        end

        function __ANTIBRAIN_MODULES.aQ()
            local v = __ANTIBRAIN_MODULES.cache.aQ

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aQ = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.aI()

            local Kit = __ANTIBRAIN_MODULES.aC()
            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local OPTION_HEIGHT, MIN_WIDTH = 15, 60
            local ContextMenu = {}

            local function place(anchor, frame)
                frame.Position = UDim2.fromOffset(anchor.AbsolutePosition.X + anchor.AbsoluteSize.X + 4, anchor.AbsolutePosition.Y + 1)
            end

            function ContextMenu.new(context, anchor)
                local frame, inner = Kit.well(context.kit, context.gui, UDim2.new(), 14, 'background')

                frame.Visible = false
                frame.Active = true

                local layout = Kit.list(inner)

                context.kit.scope:connect(anchor:GetPropertyChangedSignal('AbsolutePosition'), function(
                )
                    place(anchor, frame)
                end)

                return {
                    context = context,
                    anchor = anchor,
                    frame = frame,
                    inner = inner,
                    layout = layout,
                }
            end
            function ContextMenu.add(menu, text, action)
                local context = menu.context
                local option, tint = Kit.text(context.kit, menu.inner, {
                    text = text,
                    size = UDim2.new(1, 0, 0, OPTION_HEIGHT),
                    zIndex = 16,
                    textSize = 13,
                })

                option.Active = true

                local rest = 'font'

                Kit.hover(context.kit.scope, option, function()
                    tint('accent')
                end, function()
                    tint(rest)
                end)
                context.kit.scope:connect(option.InputBegan, function(input)
                    if Pointer.pressed(input) then
                        ContextMenu.hide(menu)
                        action()
                    end
                end)

                return function(shade)
                    rest = shade

                    tint(shade)
                end
            end
            function ContextMenu.show(menu)
                local anchor, frame = menu.anchor, menu.frame
                local width = MIN_WIDTH

                for _, child in menu.inner:GetChildren()do
                    if child:IsA('TextLabel') then
                        width = math.max(width, child.TextBounds.X)
                    end
                end

                frame.Size = UDim2.fromOffset(width + 8, menu.layout.AbsoluteContentSize.Y + 4)

                place(anchor, frame)

                frame.Visible = true

                Overlay.show(menu.context.overlay, {
                    frame = frame,
                    anchor = anchor,
                    group = 'menu',
                    close = function()
                        frame.Visible = false
                    end,
                })
            end
            function ContextMenu.hide(menu)
                Overlay.close(menu.context.overlay, menu.frame)
            end

            return table.freeze(ContextMenu)
        end

        function __ANTIBRAIN_MODULES.aR()
            local v = __ANTIBRAIN_MODULES.cache.aR

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aR = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()
            local ContextMenu = __ANTIBRAIN_MODULES.aR()

            __ANTIBRAIN_MODULES.b()

            local Kit = __ANTIBRAIN_MODULES.aC()
            local Options = __ANTIBRAIN_MODULES.aw()
            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Palette = __ANTIBRAIN_MODULES.aA()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local SQUARE_IMAGE = 'rbxassetid://4155801252'
            local CURSOR_IMAGE = 'rbxassetid://9619665977'
            local SWATCH_CHECKER = 'rbxassetid://12977615774'
            local BAR_CHECKER = 'rbxassetid://12978095818'
            local WIDTH, HEIGHT, TALL_HEIGHT = 230, 253, 271

            local function makeSwatch(host, offersTransparency)
                local swatch = Instance.new('Frame')

                swatch.BorderMode = Enum.BorderMode.Inset
                swatch.Size = UDim2.fromOffset(28, 14)
                swatch.ZIndex = 6
                swatch.Active = true
                swatch.Parent = host.label

                local checker = Instance.new('ImageLabel')

                checker.BorderSizePixel = 0
                checker.Size = UDim2.fromOffset(27, 13)
                checker.ZIndex = 5
                checker.Image = SWATCH_CHECKER
                checker.Visible = offersTransparency
                checker.Parent = swatch

                return swatch
            end
            local function makePicker(context, offersTransparency, title)
                local kit = context.kit
                local height = (offersTransparency and {TALL_HEIGHT} or {HEIGHT})[1]
                local picker, body = Kit.well(kit, context.gui, UDim2.fromOffset(WIDTH, height), 15, 'background')

                picker.Visible = false
                picker.Active = true

                Kit.frame(kit, body, {
                    size = UDim2.new(1, 0, 0, 2),
                    zIndex = 17,
                    fill = 'accent',
                })
                Kit.text(kit, body, {
                    text = title or 'Color picker',
                    position = UDim2.fromOffset(5, 5),
                    size = UDim2.new(1, 0, 0, 14),
                    zIndex = 16,
                    textSize = 14,
                    xAlignment = Enum.TextXAlignment.Left,
                })

                return picker, body
            end
            local function makeSquare(kit, body)
                local squareFrame, squareWell = Kit.well(kit, body, UDim2.fromOffset(200, 200), 17, 'background')

                squareFrame.Position = UDim2.fromOffset(4, 25)

                local square = Instance.new('ImageLabel')

                square.BorderSizePixel = 0
                square.Size = UDim2.fromScale(1, 1)
                square.ZIndex = 18
                square.Image = SQUARE_IMAGE
                square.Active = true
                square.Parent = squareWell

                local cursor = Instance.new('ImageLabel')

                cursor.AnchorPoint = Vector2.new(0.5, 0.5)
                cursor.Size = UDim2.fromOffset(6, 6)
                cursor.BackgroundTransparency = 1
                cursor.Image = CURSOR_IMAGE
                cursor.ImageColor3 = Color3.new(0, 0, 0)
                cursor.ZIndex = 19
                cursor.Parent = square

                local cursorInner = Instance.new('ImageLabel')

                cursorInner.Size = UDim2.fromOffset(4, 4)
                cursorInner.Position = UDim2.fromOffset(1, 1)
                cursorInner.BackgroundTransparency = 1
                cursorInner.Image = CURSOR_IMAGE
                cursorInner.ZIndex = 20
                cursorInner.Parent = cursor

                return square, cursor
            end
            local function makeHueBar(kit, body)
                local hueFrame = Kit.frame(kit, body, {
                    position = UDim2.fromOffset(208, 25),
                    size = UDim2.fromOffset(15, 200),
                    zIndex = 17,
                    fill = 'black',
                    border = 'black',
                })
                local hueBar = Instance.new('Frame')

                hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
                hueBar.BorderSizePixel = 0
                hueBar.Size = UDim2.fromScale(1, 1)
                hueBar.ZIndex = 18
                hueBar.Active = true
                hueBar.Parent = hueFrame

                local points = {}

                for step = 0, 10 do
                    table.insert(points, ColorSequenceKeypoint.new(step / 10, Color3.fromHSV(step / 10, 1, 1)))
                end

                local hueGradient = Instance.new('UIGradient')

                hueGradient.Color = ColorSequence.new(points)
                hueGradient.Rotation = 90
                hueGradient.Parent = hueBar

                local hueCursor = Instance.new('Frame')

                hueCursor.AnchorPoint = Vector2.new(0, 0.5)
                hueCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                hueCursor.BorderColor3 = Color3.new(0, 0, 0)
                hueCursor.Size = UDim2.new(1, 0, 0, 1)
                hueCursor.ZIndex = 18
                hueCursor.Parent = hueBar

                return hueBar, hueCursor
            end
            local function makeTextBox(kit, body, position, placeholder)
                local theme = kit.theme
                local outer, inner = Kit.well(kit, body, UDim2.new(0.5, -6, 0, 20), 18)

                outer.Position = position
                inner.ZIndex = 18

                Kit.sheen(inner)

                local box = Instance.new('TextBox')

                box.BackgroundTransparency = 1
                box.Position = UDim2.fromOffset(5, 0)
                box.Size = UDim2.new(1, -5, 1, 0)
                box.Font = Kit.font()
                box.PlaceholderColor3 = Color3.fromRGB(190, 190, 190)
                box.PlaceholderText = placeholder
                box.ClearTextOnFocus = false
                box.TextSize = 14
                box.TextXAlignment = Enum.TextXAlignment.Left
                box.ZIndex = 20

                Kit.outline(box)
                theme:bind(box, function()
                    box.TextColor3 = theme.colors.font
                end)

                box.Parent = inner

                return box
            end
            local function makeTransparencyBar(kit, body)
                local theme = kit.theme
                local barFrame = Kit.frame(kit, body, {
                    position = UDim2.fromOffset(4, 251),
                    size = UDim2.new(1, -8, 0, 15),
                    zIndex = 19,
                    fill = 'black',
                    border = 'black',
                })
                local bar = Instance.new('Frame')

                bar.BorderMode = Enum.BorderMode.Inset
                bar.Size = UDim2.fromScale(1, 1)
                bar.ZIndex = 19
                bar.Active = true

                theme:bind(bar, function()
                    bar.BorderColor3 = theme.colors.outline
                end)

                bar.Parent = barFrame

                local barChecker = Instance.new('ImageLabel')

                barChecker.BackgroundTransparency = 1
                barChecker.Size = UDim2.fromScale(1, 1)
                barChecker.Image = BAR_CHECKER
                barChecker.ZIndex = 20
                barChecker.Parent = bar

                local barCursor = Instance.new('Frame')

                barCursor.AnchorPoint = Vector2.new(0.5, 0)
                barCursor.BackgroundColor3 = Color3.new(1, 1, 1)
                barCursor.BorderColor3 = Color3.new(0, 0, 0)
                barCursor.Size = UDim2.new(0, 1, 1, 0)
                barCursor.ZIndex = 21
                barCursor.Parent = bar

                return bar, barCursor
            end
            local function makeMenu(context, host, swatch, color)
                local menu = ContextMenu.new(context, swatch)

                ContextMenu.add(menu, 'Make gradient', function()
                    local siblings = host.siblings

                    if #siblings < 3 then
                        context.notify('not enough colors for a gradient.', 2)

                        return
                    end

                    local first, last = siblings[1].value, siblings[#siblings].value

                    for index = 2, #siblings - 1 do
                        siblings[index]:set(first:Lerp(last, index / #siblings))
                    end

                    context.notify('created gradient!', 2)
                end)
                ContextMenu.add(menu, 'Match color', function()
                    for _, sibling in host.siblings do
                        sibling:set(color.value)
                    end

                    context.notify('matched all colors!', 2)
                end)
                ContextMenu.add(menu, 'Copy color', function()
                    context.copied = color

                    context.notify('Copied color!', 2)
                end)
                ContextMenu.add(menu, 'Paste color', function()
                    local copied = context.copied

                    if not copied then
                        context.notify('You have not copied a color!', 2)

                        return
                    end

                    color:set(copied.value, copied.transparency)
                end)

                return menu
            end
            local function openOnClick(context, swatch, picker, menu)
                local scope = context.kit.scope

                local function place()
                    picker.Position = UDim2.fromOffset(swatch.AbsolutePosition.X, swatch.AbsolutePosition.Y + 18)
                end

                scope:connect(swatch:GetPropertyChangedSignal('AbsolutePosition'), place)
                scope:connect(swatch.InputBegan, function(input)
                    local overlay = context.overlay

                    if Context.pressed(context, input) then
                        if Overlay.isOpen(overlay, picker) then
                            Overlay.close(overlay, picker)

                            return
                        end

                        place()

                        picker.Visible = true

                        Overlay.show(overlay, {
                            frame = picker,
                            anchor = swatch,
                            group = 'picker',
                            close = function()
                                picker.Visible = false
                            end,
                        })
                    elseif Pointer.secondary(input) and not Overlay.blocks(overlay, input) then
                        Overlay.close(overlay, picker)
                        ContextMenu.show(menu)
                    end
                end)
            end

            local ColorPicker = {}

            function ColorPicker.new(context, host, registry, id, info)
                local kit = context.kit
                local scope = kit.scope
                local offersTransparency = info.transparency ~= nil
                local changed = Signal.new(context.report)
                local hue, saturation, brightness = info.default:ToHSV()
                local swatch = makeSwatch(host, offersTransparency)
                local picker, body = makePicker(context, offersTransparency, info.title)
                local square, cursor = makeSquare(kit, body)
                local hueBar, hueCursor = makeHueBar(kit, body)
                local hexBox = makeTextBox(kit, body, UDim2.fromOffset(4, 228), 'Hex color')
                local rgbBox = makeTextBox(kit, body, UDim2.new(0.5, 2, 0, 228), 'RGB color')
                local transparencyBar, transparencyCursor = nil, nil

                if offersTransparency then
                    transparencyBar, transparencyCursor = makeTransparencyBar(kit, body)
                end

                local color
                local displayedTransparency = info.transparency or 0

                local function display(notify)
                    local value = Color3.fromHSV(hue, saturation, brightness)
                    local previous, previousTransparency = color.value, displayedTransparency

                    color.value = value
                    displayedTransparency = color.transparency
                    swatch.BackgroundColor3 = value
                    swatch.BackgroundTransparency = color.transparency
                    swatch.BorderColor3 = Palette.darker(value)
                    square.BackgroundColor3 = Color3.fromHSV(hue, 1, 1)
                    cursor.Position = UDim2.fromScale(saturation, 1 - brightness)
                    hueCursor.Position = UDim2.fromScale(0, hue)
                    hexBox.Text = string.format('#%s', tostring(value:ToHex()))
                    rgbBox.Text = string.format('%s, %s, %s', tostring(math.floor(value.R * 255)), tostring(math.floor(value.G * 255)), tostring(math.floor(value.B * 255)))

                    if transparencyBar and transparencyCursor then
                        transparencyBar.BackgroundColor3 = value
                        transparencyCursor.Position = UDim2.fromScale(1 - color.transparency, 0)
                    end
                    if notify and (value ~= previous or color.transparency ~= previousTransparency) then
                        changed:fire(value)
                        context.changed:fire()
                    end
                end

                color = {
                    id = id,
                    value = info.default,
                    transparency = info.transparency or 0,
                    set = function(self, value, transparency)
                        hue, saturation, brightness = value:ToHSV()

                        if transparency and offersTransparency and transparency > 
-math.huge and transparency < math.huge then
                            self.transparency = math.clamp(transparency, 0, 1)
                        end

                        display(true)
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                }

                table.insert(host.siblings, color)
                display(false)

                local function drag(target, input, apply)
                    if not Pointer.pressed(input) then
                        return
                    end

                    Pointer.drag(scope, input, function(point)
                        local position, size = target.AbsolutePosition, target.AbsoluteSize

                        apply(math.clamp((point.X - position.X) / size.X, 0, 1), math.clamp((point.Y - position.Y) / size.Y, 0, 1))
                        display(true)
                    end)
                end

                scope:connect(square.InputBegan, function(input)
                    drag(square, input, function(x, y)
                        saturation, brightness = x, 1 - y
                    end)
                end)
                scope:connect(hueBar.InputBegan, function(input)
                    drag(hueBar, input, function(_, y)
                        hue = y
                    end)
                end)

                local bar = transparencyBar

                if bar then
                    scope:connect(bar.InputBegan, function(input)
                        drag(bar, input, function(x)
                            color.transparency = 1 - x
                        end)
                    end)
                end

                scope:connect(hexBox.FocusLost, function(entered)
                    if entered then
                        local ok, parsed = pcall(Color3.fromHex, hexBox.Text)

                        if ok then
                            hue, saturation, brightness = parsed:ToHSV()
                        end
                    end

                    display(true)
                end)
                scope:connect(rgbBox.FocusLost, function(entered)
                    if entered then
                        local red, green, blue = rgbBox.Text:match('(%d+),%s*(%d+),%s*(%d+)')

                        if red and green and blue then
                            local picked = Color3.fromRGB(math.min(tonumber(red) or 0, 255), math.min(tonumber(green) or 0, 255), math.min(tonumber(blue) or 0, 255))

                            hue, saturation, brightness = picked:ToHSV()
                        end
                    end

                    display(true)
                end)
                openOnClick(context, swatch, picker, makeMenu(context, host, swatch, color))
                Options.add(registry, {
                    id = id,
                    save = function()
                        return {
                            color = color.value:ToHex(),
                            transparency = color.transparency,
                        }
                    end,
                    load = function(saved)
                        if type(saved) == 'table' and type(saved.color) == 'string' and Palette.isHex(saved.color) then
                            local transparency = (type(saved.transparency) == 'number' and {
                                saved.transparency,
                            } or {nil})[1]

                            color:set(Color3.fromHex(saved.color), transparency)
                        end
                    end,
                })

                return color
            end

            return table.freeze(ColorPicker)
        end

        function __ANTIBRAIN_MODULES.aS()
            local v = __ANTIBRAIN_MODULES.cache.aS

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aS = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()
            local ContextMenu = __ANTIBRAIN_MODULES.aR()

            __ANTIBRAIN_MODULES.b()

            local KeybindList = __ANTIBRAIN_MODULES.aF()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Options = __ANTIBRAIN_MODULES.aw()
            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Services = __ANTIBRAIN_MODULES.k()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local MODES = {
                'Always',
                'Toggle',
                'Hold',
            }
            local BOX_WIDTH, BOX_HEIGHT = 28, 15
            local Keybind = {}

            local function keyOf(input)
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    local code = input.KeyCode

                    return (code == Enum.KeyCode.Escape or code == Enum.KeyCode.Backspace) and 'None' or code.Name
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    return 'MB1'
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    return 'MB2'
                end

                return nil
            end
            local function shown(key)
                return key == 'None' and '...' or key
            end
            local function validKey(key)
                if key == 'None' or key == 'MB1' or key == 'MB2' then
                    return true
                end

                for _, code in Enum.KeyCode:GetEnumItems()do
                    if code.Name == key and key ~= 'Unknown' then
                        return true
                    end
                end

                return false
            end
            local function held(key)
                local inputService = Services.UserInputService

                if key == 'MB1' then
                    return inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
                elseif key == 'MB2' then
                    return inputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
                end

                local code = Enum.KeyCode:FromName(key)

                return code ~= nil and inputService:IsKeyDown(code)
            end

            function Keybind.new(context, host, registry, id, info)
                local kit = context.kit
                local scope = kit.scope
                local switch = (info.syncToggleState and {
                    host.switch,
                } or {nil})[1]
                local sync = switch ~= nil
                local listed = not info.hidden
                local modes = sync and {
                    'Toggle',
                } or (info.modes or MODES)
                local changed = Signal.new(context.report)
                local pressed = Signal.new(context.report)
                local toggled, picking = sync and host.enabled(), false
                local binding = nil
                local box, well = Kit.well(kit, host.label, UDim2.fromOffset(BOX_WIDTH, BOX_HEIGHT), 6, 'background')

                box.Visible = not context.mobile
                box.Active = true

                local display = Kit.text(kit, well, {
                    text = '',
                    size = UDim2.fromScale(1, 1),
                    zIndex = 8,
                    textSize = 13,
                    wrapped = true,
                })
                local menu = ContextMenu.new(context, box)
                local keybind
                local tints = {}

                local function showMode()
                    for mode, tint in tints do
                        tint(mode == keybind.mode and 'accent' or 'font')
                    end
                end
                local function refreshList()
                    if listed then
                        KeybindList.refresh(context.keybinds)
                    end
                end

                keybind = {
                    id = id,
                    text = info.text,
                    key = info.default or 'None',
                    mode = (info.mode and table.find(modes, info.mode) and {
                        info.mode,
                    } or {
                        modes[1],
                    })[1],
                    active = function(self)
                        if not host.enabled() then
                            return false
                        elseif self.mode == 'Always' or self.key == 'None' then
                            return true
                        elseif self.mode == 'Hold' then
                            return held(self.key)
                        end

                        return toggled
                    end,
                    set = function(self, key, mode)
                        local keyChanged = key ~= self.key

                        self.key = key

                        if mode and table.find(modes, mode) then
                            self.mode = mode
                        end

                        display.Text = shown(key)

                        showMode()
                        refreshList()

                        if keyChanged then
                            changed:fire(key)
                        end
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                    onPressed = function(_, callback)
                        return pressed:connect(callback)
                    end,
                }
                display.Text = shown(keybind.key)

                for _, mode in modes do
                    tints[mode] = ContextMenu.add(menu, mode, function()
                        keybind:set(keybind.key, mode)
                    end)
                end

                showMode()

                local function pick()
                    picking = true
                    display.Text = ''

                    local waiting = scope:child()

                    waiting:spawn(function()
                        local dots = 0

                        while true do
                            dots = dots % 3 + 1
                            display.Text = ('.'):rep(dots)

                            task.wait(0.4)
                        end
                    end)
                    waiting:delay(0.2, function()
                        if waiting.closed then
                            return
                        end

                        waiting:connect(Services.UserInputService.InputBegan, function(
                            input
                        )
                            local key = keyOf(input)

                            if not key then
                                return
                            end

                            waiting:close()

                            picking, binding = false, input

                            keybind:set(key)
                            scope:defer(function()
                                if binding == input then
                                    binding = nil
                                end
                            end)
                        end)
                    end)
                end

                scope:connect(box.InputBegan, function(input)
                    if picking then
                        return
                    end
                    if Context.pressed(context, input) then
                        pick()
                    elseif Pointer.secondary(input) and not Overlay.blocks(context.overlay, input) then
                        ContextMenu.show(menu)
                    end
                end)

                local function press()
                    toggled = not toggled

                    if switch then
                        switch(toggled)
                    end

                    refreshList()
                    pressed:fire(toggled)
                end

                scope:connect(Services.UserInputService.InputBegan, function(
                    input,
                    processed
                )
                    if picking or processed or input == binding or keybind.mode ~= 'Toggle' then
                        return
                    end
                    if keyOf(input) == keybind.key and keybind.key ~= 'None' then
                        press()
                    end
                end)

                if listed then
                    scope:add(KeybindList.add(context.keybinds, function()
                        return {
                            onToggle = host.switch ~= nil,
                            enabled = host.enabled(),
                            active = keybind:active(),
                            text = string.format('[%s] %s (%s)', tostring(shown(keybind.key)), tostring(keybind.text), tostring(keybind.mode)),
                        }
                    end))
                end

                Options.add(registry, {
                    id = id,
                    save = function()
                        return {
                            key = keybind.key,
                            mode = keybind.mode,
                        }
                    end,
                    load = function(saved)
                        if type(saved) == 'table' and type(saved.key) == 'string' and validKey(saved.key) then
                            local at = table.find(modes, saved.mode)

                            keybind:set(saved.key, (at and {
                                modes[at],
                            } or {nil})[1])
                        end
                    end,
                })

                return {
                    keybind = keybind,
                    hostChanged = function(enabled)
                        if sync then
                            toggled = enabled
                        end

                        refreshList()
                    end,
                }
            end

            return table.freeze(Keybind)
        end

        function __ANTIBRAIN_MODULES.aT()
            local v = __ANTIBRAIN_MODULES.cache.aT

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aT = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local ColorPicker = __ANTIBRAIN_MODULES.aS()

            __ANTIBRAIN_MODULES.b()

            local Keybind = __ANTIBRAIN_MODULES.aT()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local HEIGHT, TEXT_SIZE, GAP = 15, 14, 5
            local Label = {}

            local function build(slot, text, wrap, note)
                local context = slot.context
                local kit = context.kit
                local row = Slot.row(slot, HEIGHT + GAP)
                local line = Kit.text(kit, row, {
                    text = text,
                    size = UDim2.new(1, -4, 0, HEIGHT),
                    zIndex = 5,
                    textSize = TEXT_SIZE,
                    xAlignment = (note and {
                        Enum.TextXAlignment.Center,
                    } or {
                        Enum.TextXAlignment.Left,
                    })[1],
                    wrapped = wrap == true,
                    rich = true,
                })

                if note then
                    line.TextTransparency = 0.5
                end

                local function fit()
                    if not wrap then
                        return
                    end

                    local height = Kit.measure(line.Text, TEXT_SIZE, Vector2.new(line.AbsoluteSize.X, math.huge)).Y

                    line.Size = UDim2.new(1, -4, 0, height)
                    row.Size = UDim2.new(1, 0, 0, height + GAP)
                end

                if wrap then
                    kit.scope:connect(line:GetPropertyChangedSignal('AbsoluteSize'), fit)
                    fit()
                elseif not note then
                    local addons = Kit.list(line, 4, true)

                    addons.HorizontalAlignment = Enum.HorizontalAlignment.Right
                end

                local host = {
                    label = line,
                    siblings = {},
                }
                local label = {
                    text = text,
                    setText = function(self, value)
                        self.text = value
                        line.Text = value

                        fit()
                    end,
                    setVisible = function(_, visible)
                        row.Visible = visible
                    end,
                    keybind = function(_, id, info)
                        assert(not wrap and not note, 'A wrapping label or a note holds no keybind')

                        return Keybind.new(context, {
                            label = line,
                            enabled = function()
                                return true
                            end,
                        }, slot.registry, id, info).keybind
                    end,
                    color = function(_, id, info)
                        assert(not wrap and not note, 'A wrapping label or a note holds no color picker')

                        return ColorPicker.new(context, host, slot.registry, id, info)
                    end,
                }

                return label
            end

            function Label.new(slot, text, wrap)
                return build(slot, text, wrap, false)
            end
            function Label.note(slot, text)
                return build(slot, text, true, true)
            end

            return table.freeze(Label)
        end

        function __ANTIBRAIN_MODULES.aU()
            local v = __ANTIBRAIN_MODULES.cache.aU

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aU = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()

            __ANTIBRAIN_MODULES.b()

            local Kit = __ANTIBRAIN_MODULES.aC()
            local Options = __ANTIBRAIN_MODULES.aw()
            local Pointer = __ANTIBRAIN_MODULES.aD()
            local Services = __ANTIBRAIN_MODULES.k()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local Values = __ANTIBRAIN_MODULES.aN()
            local BAR, TEXT, GAP = 13, 13, 6
            local PER_ROW = 3
            local Slider = {}

            local function arrange(row)
                local count = #row.lanes
                local labelled = table.find(row.labelled, true) ~= nil
                local top = (labelled and {TEXT} or {0})[1]

                row.frame.Size = UDim2.new(1, 0, 0, top + BAR + GAP)

                for index, lane in row.lanes do
                    local at = Values.sliderLane(index, count)

                    lane.Size = UDim2.new(at.share, at.width, 0, top + BAR)
                    lane.Position = UDim2.new(at.start, at.offset, 0, 0)
                    row.titles[index].Position = UDim2.fromOffset(at.titleX, at.titleY)
                end
            end
            local function build(slot, row, id, info)
                local context = slot.context
                local kit = context.kit
                local changed = Signal.new(context.report)
                local compact = info.compact ~= false
                local suffix = info.suffix or ''
                local lane = Instance.new('Frame')

                lane.BackgroundTransparency = 1
                lane.BorderSizePixel = 0
                lane.ZIndex = 1
                lane.Parent = row.frame

                local title = Kit.text(kit, lane, {
                    text = info.text,
                    size = UDim2.new(1, 0, 0, 10),
                    zIndex = 5,
                    textSize = 14,
                    xAlignment = Enum.TextXAlignment.Left,
                    yAlignment = Enum.TextYAlignment.Bottom,
                    visible = not compact,
                })

                table.insert(row.lanes, lane)
                table.insert(row.titles, title)
                table.insert(row.labelled, not compact)
                arrange(row)

                local outer, inner, restyleOuter = Kit.well(kit, lane, UDim2.new(1, 0, 0, BAR), 5)

                outer.AnchorPoint = Vector2.new(0, 1)
                outer.Position = UDim2.fromScale(0, 1)
                inner.Active = true

                local fill = Kit.frame(kit, inner, {
                    size = UDim2.fromScale(0, 1),
                    zIndex = 7,
                    fill = 'accent',
                    border = 'accentDark',
                })
                local seam = Kit.frame(kit, fill, {
                    position = UDim2.fromScale(1, 0),
                    size = UDim2.new(0, 1, 1, 0),
                    zIndex = 8,
                    fill = 'accent',
                })
                local display = Kit.text(kit, inner, {
                    text = '',
                    size = UDim2.fromScale(1, 1),
                    zIndex = 9,
                    textSize = 14,
                })

                Kit.highlight(kit, outer, restyleOuter, 'accent', 'black')

                if info.tooltip then
                    Tooltip.attach(context.tooltips, outer, info.tooltip)
                end

                local easing = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = nil
                local slider

                local function draw()
                    local fraction = Values.fraction(slider.value, info.min, info.max)

                    display.Text = Values.sliderText(info.text, slider.value, info.max, suffix, compact, info.hideMax == true)

                    if tween then
                        tween:Cancel()
                    end

                    local easeTo = Services.TweenService:Create(fill, easing, {
                        Size = UDim2.fromScale(fraction, 1),
                    })

                    easeTo:Play()

                    tween = easeTo
                    seam.Visible = fraction > 0 and fraction < 1
                end

                slider = {
                    id = id,
                    text = info.text,
                    value = math.clamp(info.default, info.min, info.max),
                    set = function(self, value)
                        if not (value > -math.huge and value < math.huge) then
                            return
                        end

                        local clamped = math.clamp(value, info.min, info.max)

                        if clamped == self.value then
                            return
                        end

                        self.value = clamped

                        draw()
                        changed:fire(clamped)
                        context.changed:fire()
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                    setVisible = function(_, visible)
                        row.frame.Visible = visible
                    end,
                    slider = function(_, siblingId, siblingInfo)
                        assert(#row.lanes < PER_ROW, string.format('A row holds at most %s sliders', tostring(PER_ROW)))

                        if compact and siblingInfo.compact == false then
                            compact = false
                            row.labelled[table.find(row.lanes, lane) or 1] = true
                            title.Visible = true

                            draw()
                        end

                        return build(slot, row, siblingId, siblingInfo)
                    end,
                }

                draw()
                kit.scope:connect(inner.InputBegan, function(input)
                    if not Context.pressed(context, input) then
                        return
                    end

                    Pointer.drag(kit.scope, input, function(point)
                        local reach = inner.AbsoluteSize.X - 2
                        local fraction = (reach > 0 and {
                            ((point.X - inner.AbsolutePosition.X) / reach),
                        } or {0})[1]

                        slider:set(Values.at(fraction, info.min, info.max, info.rounding, info.increment))
                    end)
                end)
                Options.add(slot.registry, {
                    id = id,
                    save = function()
                        return slider.value
                    end,
                    load = function(saved)
                        local value = tonumber(saved)

                        if value then
                            slider:set(value)
                        end
                    end,
                })

                return slider
            end

            function Slider.new(slot, id, info)
                local frame = Slot.row(slot, BAR + GAP)

                return build(slot, {
                    frame = frame,
                    lanes = {},
                    titles = {},
                    labelled = {},
                }, id, info)
            end

            return table.freeze(Slider)
        end

        function __ANTIBRAIN_MODULES.aV()
            local v = __ANTIBRAIN_MODULES.cache.aV

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aV = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local ColorPicker = __ANTIBRAIN_MODULES.aS()
            local Context = __ANTIBRAIN_MODULES.aI()

            __ANTIBRAIN_MODULES.b()

            local Keybind = __ANTIBRAIN_MODULES.aT()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Options = __ANTIBRAIN_MODULES.aw()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local SQUARE, GAP, TEXT_X, TEXT_MARGIN, CLICK_WIDTH, SWATCH_WIDTH = 13, 7, 19, 25, 170, 32
            local Toggle = {}

            function Toggle.new(slot, id, info)
                local context = slot.context
                local kit = context.kit
                local changed = Signal.new(context.report)
                local row = Slot.row(slot, SQUARE + GAP)
                local square, _, restyleSquare, restyleWell = Kit.well(kit, row, UDim2.fromOffset(SQUARE, SQUARE), 5)
                local label = Kit.text(kit, row, {
                    text = info.text,
                    position = UDim2.fromOffset(TEXT_X, 0),
                    size = UDim2.new(1, -TEXT_MARGIN, 0, SQUARE),
                    zIndex = 6,
                    textSize = 14,
                    xAlignment = Enum.TextXAlignment.Left,
                    shade = info.risky and 'risk' or 'font',
                })
                local addons = Kit.list(label, 4, true)

                addons.HorizontalAlignment = Enum.HorizontalAlignment.Right

                local region = Kit.frame(kit, square, {
                    size = UDim2.new(0, CLICK_WIDTH, 1, 0),
                    zIndex = 8,
                    active = true,
                })

                Kit.highlight(kit, region, restyleSquare, 'outline', 'black')

                if info.tooltip then
                    Tooltip.attach(context.tooltips, region, info.tooltip)
                end

                local keybinds = {}
                local host = {
                    label = label,
                    siblings = {},
                }
                local toggle

                local function display()
                    if toggle.value then
                        restyleWell('accent', 'accentDark')
                    else
                        restyleWell('main', 'outline')
                    end
                end

                toggle = {
                    id = id,
                    text = info.text,
                    value = info.default == true,
                    set = function(self, value)
                        if value == self.value then
                            return
                        end

                        self.value = value

                        display()

                        for _, keybind in keybinds do
                            keybind.hostChanged(value)
                        end

                        changed:fire(value)
                        context.changed:fire()
                    end,
                    onChanged = function(_, callback)
                        return changed:connect(callback)
                    end,
                    setVisible = function(_, visible)
                        row.Visible = visible
                    end,
                    keybind = function(self, keybindId, keybindInfo)
                        local attached = Keybind.new(context, {
                            label = label,
                            enabled = function()
                                return self.value
                            end,
                            switch = function(value)
                                self:set(value)
                            end,
                        }, slot.registry, keybindId, keybindInfo)

                        table.insert(keybinds, attached)

                        return attached.keybind
                    end,
                    color = function(_, colorId, colorInfo)
                        local color = ColorPicker.new(context, host, slot.registry, colorId, colorInfo)

                        if #host.siblings > 2 then
                            region.Size = region.Size - UDim2.fromOffset(SWATCH_WIDTH, 0)
                        end

                        return color
                    end,
                }

                display()
                kit.scope:connect(region.InputBegan, function(input)
                    if Context.pressed(context, input) then
                        toggle:set(not toggle.value)
                    end
                end)
                Options.add(slot.registry, {
                    id = id,
                    save = function()
                        return toggle.value
                    end,
                    load = function(saved)
                        if type(saved) == 'boolean' then
                            toggle:set(saved)
                        end
                    end,
                })

                return toggle
            end

            return table.freeze(Toggle)
        end

        function __ANTIBRAIN_MODULES.aW()
            local v = __ANTIBRAIN_MODULES.cache.aW

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aW = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Button = __ANTIBRAIN_MODULES.aM()

            __ANTIBRAIN_MODULES.aI()
            __ANTIBRAIN_MODULES.b()

            local Dropdown = __ANTIBRAIN_MODULES.aO()
            local Gallery = __ANTIBRAIN_MODULES.aP()
            local Input = __ANTIBRAIN_MODULES.aQ()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Label = __ANTIBRAIN_MODULES.aU()
            local Slider = __ANTIBRAIN_MODULES.aV()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Toggle = __ANTIBRAIN_MODULES.aW()
            local HEADER, FOOTER, TOP_GAP = 20, 4, 3
            local DIVIDER_ABOVE, DIVIDER, DIVIDER_BELOW = 2, 5, 9
            local Box = {}

            function Box.frame(context, column, order)
                local kit = context.kit
                local outer = Kit.frame(kit, column, {
                    size = UDim2.new(1, 0, 0, HEADER + FOOTER),
                    zIndex = 2,
                    fill = 'background',
                    border = 'outline',
                    inset = true,
                    layoutOrder = order,
                })
                local inner = Kit.frame(kit, outer, {
                    position = UDim2.fromOffset(1, 1),
                    size = UDim2.new(1, -2, 1, -2),
                    zIndex = 4,
                    fill = 'background',
                    border = 'black',
                })

                return outer, inner
            end
            function Box.column(inner, visible)
                local column = Instance.new('Frame')

                column.BackgroundTransparency = 1
                column.BorderSizePixel = 0
                column.Position = UDim2.fromOffset(4, HEADER)
                column.Size = UDim2.new(1, -4, 1, -HEADER)
                column.ZIndex = 1
                column.Visible = visible
                column.Parent = inner

                local layout = Kit.list(column)
                local gap = Instance.new('Frame')

                gap.BackgroundTransparency = 1
                gap.Size = UDim2.new(1, 0, 0, TOP_GAP)
                gap.LayoutOrder = 0
                gap.Parent = column

                return column, layout
            end
            function Box.fit(outer, layout)
                outer.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + HEADER + FOOTER)
            end
            function Box.new(slot)
                local context = slot.context
                local kit = context.kit
                local box = {
                    toggle = function(_, id, info)
                        return Toggle.new(slot, id, info)
                    end,
                    slider = function(_, id, info)
                        return Slider.new(slot, id, info)
                    end,
                    dropdown = function(_, id, info)
                        return Dropdown.single(slot, id, info)
                    end,
                    multiDropdown = function(_, id, info)
                        return Dropdown.multi(slot, id, info)
                    end,
                    input = function(_, id, info)
                        return Input.new(slot, id, info)
                    end,
                    label = function(_, text, wrap)
                        return Label.new(slot, text, wrap)
                    end,
                    button = function(_, info)
                        return Button.new(slot, info)
                    end,
                    gallery = function(_, info)
                        return Gallery.new(slot, info)
                    end,
                    note = function(_, text)
                        return Label.note(slot, text)
                    end,
                    divider = function()
                        local row = Slot.row(slot, DIVIDER_ABOVE + DIVIDER + DIVIDER_BELOW)
                        local outer = Kit.well(kit, row, UDim2.new(1, -4, 0, DIVIDER), 5)

                        outer.Position = UDim2.fromOffset(0, DIVIDER_ABOVE)
                    end,
                    dependent = function(_, visible)
                        local row = Slot.row(slot, 0)
                        local column = Instance.new('Frame')

                        column.BackgroundTransparency = 1
                        column.BorderSizePixel = 0
                        column.Size = UDim2.fromScale(1, 1)
                        column.Parent = row

                        local layout = Kit.list(column)

                        local function resize()
                            row.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y)
                        end

                        kit.scope:connect(layout:GetPropertyChangedSignal('AbsoluteContentSize'), resize)
                        resize()

                        local function update()
                            row.Visible = visible()
                        end

                        kit.scope:add(context.changed:connect(update))
                        update()

                        return Box.new(Slot.new(context, column, slot.registry))
                    end,
                }

                return box
            end

            return table.freeze(Box)
        end

        function __ANTIBRAIN_MODULES.aX()
            local v = __ANTIBRAIN_MODULES.cache.aX

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aX = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Box = __ANTIBRAIN_MODULES.aX()

            __ANTIBRAIN_MODULES.aI()
            __ANTIBRAIN_MODULES.b()

            local Drag = __ANTIBRAIN_MODULES.aE()
            local Kit = __ANTIBRAIN_MODULES.aC()

            __ANTIBRAIN_MODULES.aw()

            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local TITLE, OPENS_X, OPENS_Y, BESIDE_GAP = 25, 175, 50, 8
            local MARGIN, FOOT = 8, 3
            local TOP, BOTTOM = 1 + TITLE + 8 + MARGIN, FOOT + 8 + 8 + 1
            local Popout = {}

            function Popout.new(
                context,
                registry,
                info,
                windowShown,
                movable,
                beside
            )
                local kit = context.kit
                local holder = Kit.frame(kit, context.gui, {
                    position = UDim2.fromOffset(OPENS_X, OPENS_Y),
                    size = UDim2.fromOffset(info.width, TOP + BOTTOM),
                    zIndex = 1,
                    fill = 'black',
                    visible = false,
                    active = true,
                })

                Drag.outline(kit, holder, holder, TITLE, context.gui, function(
                    active
                )
                    context.dragging = active
                end, movable)

                local frame = Kit.frame(kit, holder, {
                    position = UDim2.fromOffset(1, 1),
                    size = UDim2.new(1, -2, 1, -2),
                    zIndex = 1,
                    fill = 'main',
                    border = 'outline',
                    inset = true,
                })

                Kit.text(kit, frame, {
                    text = info.title,
                    size = UDim2.new(1, 0, 0, TITLE),
                    zIndex = 1,
                })

                local section = Kit.frame(kit, frame, {
                    position = UDim2.fromOffset(8, TITLE),
                    size = UDim2.new(1, -16, 1, -33),
                    zIndex = 1,
                    fill = 'background',
                    border = 'outline',
                })
                local sectionInner = Kit.frame(kit, section, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = 1,
                    fill = 'background',
                    border = 'black',
                    inset = true,
                })
                local well = Kit.frame(kit, sectionInner, {
                    position = UDim2.fromOffset(8, 8),
                    size = UDim2.new(1, -16, 1, -16),
                    zIndex = 2,
                    fill = 'background',
                    border = 'outline',
                })
                local column = Kit.frame(kit, well, {
                    position = UDim2.fromOffset(MARGIN, MARGIN),
                    size = UDim2.new(1, 4 - 2 * MARGIN, 1, 0),
                    zIndex = 2,
                })
                local layout = Kit.list(column)

                local function fit()
                    local height = layout.AbsoluteContentSize.Y + TOP + BOTTOM

                    holder.Size = UDim2.fromOffset(info.width, height)

                    local screen = context.gui.AbsoluteSize

                    if screen.X > 0 and screen.Y > 0 then
                        local left = math.clamp(holder.Position.X.Offset, 0, math.max(screen.X - info.width, 0))
                        local top = math.clamp(holder.Position.Y.Offset, 0, math.max(screen.Y - height, 0))

                        holder.Position = UDim2.fromOffset(left, top)
                    end
                end

                kit.scope:connect(layout:GetPropertyChangedSignal('AbsoluteContentSize'), fit)
                kit.scope:connect(holder:GetPropertyChangedSignal('Position'), fit)
                kit.scope:connect(context.gui:GetPropertyChangedSignal('AbsoluteSize'), fit)
                fit()

                local placed = false

                local function place()
                    local window = (beside and {
                        (beside()),
                    } or {nil})[1]

                    if not window then
                        return
                    end

                    local at, size = window.AbsolutePosition, window.AbsoluteSize
                    local screen = context.gui.AbsoluteSize
                    local left = at.X - BESIDE_GAP - info.width
                    local right = at.X + size.X + BESIDE_GAP

                    if left >= 0 then
                        holder.Position = UDim2.fromOffset(left, at.Y)
                    elseif right + info.width <= screen.X then
                        holder.Position = UDim2.fromOffset(right, at.Y)
                    end
                end

                local wanted = false

                local function sync()
                    local show = wanted and windowShown()

                    if show and not holder.Visible then
                        if not placed then
                            placed = true

                            place()
                        end

                        fit()
                    end

                    holder.Visible = show

                    if not show then
                        Overlay.closeAnchored(context.overlay, holder)

                        local owner = context.tooltips.owner

                        if owner and owner:IsDescendantOf(holder) then
                            Tooltip.hide(context.tooltips)
                        end
                    end
                end

                local popout = {
                    box = Box.new(Slot.new(context, column, registry)),
                    show = function(_, shown)
                        wanted = shown

                        sync()
                    end,
                }

                return {
                    popout = popout,
                    sync = sync,
                }
            end

            return table.freeze(Popout)
        end

        function __ANTIBRAIN_MODULES.aY()
            local v = __ANTIBRAIN_MODULES.cache.aY

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aY = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Drag = __ANTIBRAIN_MODULES.aE()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Palette = __ANTIBRAIN_MODULES.aA()
            local WIDTH, HEIGHT, LEFT = 77, 30, 0.008
            local TouchButton = {}

            function TouchButton.new(kit, gui, text, top, pressed)
                local outer = Kit.frame(kit, gui, {
                    position = UDim2.fromScale(LEFT, top),
                    size = UDim2.fromOffset(WIDTH, HEIGHT),
                    zIndex = 200,
                    fill = 'black',
                    border = 'black',
                })

                Kit.frame(kit, outer, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = 201,
                    fill = 'main',
                    border = 'accent',
                    inset = true,
                })

                local body = Instance.new('Frame')

                body.BackgroundColor3 = Color3.new(1, 1, 1)
                body.BorderSizePixel = 0
                body.Position = UDim2.fromOffset(1, 1)
                body.Size = UDim2.new(1, -2, 1, -2)
                body.ZIndex = 202
                body.Parent = outer

                local gradient = Instance.new('UIGradient')

                gradient.Rotation = -90

                kit.theme:bind(gradient, function()
                    local main = kit.theme.colors.main

                    gradient.Color = ColorSequence.new(Palette.darker(main), main)
                end)

                gradient.Parent = body

                local button = Instance.new('TextButton')

                button.AutoButtonColor = false
                button.BackgroundTransparency = 1
                button.Font = Kit.font()
                button.Text = text
                button.TextSize = 14
                button.TextStrokeTransparency = 0
                button.TextXAlignment = Enum.TextXAlignment.Left
                button.Position = UDim2.fromOffset(5, 0)
                button.Size = UDim2.new(1, -4, 1, 0)
                button.ZIndex = 203

                kit.theme:bind(button, function()
                    button.TextColor3 = kit.theme.colors.font
                end)

                button.Parent = body

                Drag.move(kit, button, outer, 40)
                kit.scope:connect(button.MouseButton1Down, function()
                    pressed(button)
                end)
            end

            return table.freeze(TouchButton)
        end

        function __ANTIBRAIN_MODULES.aZ()
            local v = __ANTIBRAIN_MODULES.cache.aZ

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.aZ = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Box = __ANTIBRAIN_MODULES.aX()

            __ANTIBRAIN_MODULES.aI()
            __ANTIBRAIN_MODULES.b()

            local Kit = __ANTIBRAIN_MODULES.aC()

            __ANTIBRAIN_MODULES.aw()

            local Slot = __ANTIBRAIN_MODULES.aL()
            local Groupbox = {}

            function Groupbox.new(context, column, order, registry, title)
                local kit = context.kit
                local outer, inner = Box.frame(context, column, order)

                Kit.frame(kit, inner, {
                    size = UDim2.new(1, 0, 0, 2),
                    zIndex = 5,
                    fill = 'accent',
                })
                Kit.text(kit, inner, {
                    text = title,
                    position = UDim2.fromOffset(4, 2),
                    size = UDim2.new(1, 0, 0, 18),
                    zIndex = 5,
                    textSize = 14,
                })

                local controls, layout = Box.column(inner, true)

                kit.scope:connect(layout:GetPropertyChangedSignal('AbsoluteContentSize'), function(
                )
                    Box.fit(outer, layout)
                end)
                Box.fit(outer, layout)

                return Box.new(Slot.new(context, controls, registry))
            end

            return table.freeze(Groupbox)
        end

        function __ANTIBRAIN_MODULES.a_()
            local v = __ANTIBRAIN_MODULES.cache.a_

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a_ = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Box = __ANTIBRAIN_MODULES.aX()
            local Context = __ANTIBRAIN_MODULES.aI()

            __ANTIBRAIN_MODULES.b()

            local Kit = __ANTIBRAIN_MODULES.aC()

            __ANTIBRAIN_MODULES.aw()

            local Slot = __ANTIBRAIN_MODULES.aL()
            local Tabbox = {}

            function Tabbox.new(context, column, order, registry)
                local kit = context.kit
                local outer, inner = Box.frame(context, column, order)
                local header = Kit.frame(kit, inner, {
                    size = UDim2.new(1, 0, 0, 18),
                    zIndex = 5,
                })

                Kit.list(header, 0, true)

                local entries = {}
                local chosen = nil

                local function choose(entry)
                    chosen = entry

                    for _, each in entries do
                        local on = each == entry

                        each.column.Visible = on
                        each.accent.Visible = on
                        each.cover.Visible = on
                        each.face.Visible = not on

                        each.restyle(on and 'background' or 'main', nil)
                    end

                    Box.fit(outer, entry.layout)
                end

                return {
                    tab = function(_, title)
                        local button, restyle = Kit.frame(kit, header, {
                            size = UDim2.fromScale(1, 1),
                            zIndex = 6,
                            fill = 'main',
                            border = 'black',
                            active = true,
                            layoutOrder = #entries + 1,
                        })
                        local face = Kit.frame(kit, button, {
                            size = UDim2.fromScale(1, 1),
                            zIndex = 7,
                            fill = 'main',
                            border = 'outline',
                            inset = true,
                        })

                        Kit.text(kit, button, {
                            text = title,
                            size = UDim2.fromScale(1, 1),
                            zIndex = 7,
                            textSize = 14,
                        })

                        local accent = Kit.frame(kit, button, {
                            size = UDim2.new(1, 0, 0, 1),
                            zIndex = 8,
                            fill = 'accent',
                            visible = false,
                        })
                        local cover = Kit.frame(kit, button, {
                            position = UDim2.fromScale(0, 1),
                            size = UDim2.new(1, 0, 0, 1),
                            zIndex = 9,
                            fill = 'background',
                            visible = false,
                        })
                        local controls, layout = Box.column(inner, false)
                        local entry = {
                            button = button,
                            restyle = restyle,
                            accent = accent,
                            cover = cover,
                            face = face,
                            column = controls,
                            layout = layout,
                        }

                        table.insert(entries, entry)
                        kit.scope:connect(layout:GetPropertyChangedSignal('AbsoluteContentSize'), function(
                        )
                            if chosen == entry then
                                Box.fit(outer, layout)
                            end
                        end)

                        for _, each in entries do
                            each.button.Size = UDim2.fromScale(1 / #entries, 1)
                        end

                        kit.scope:connect(button.InputBegan, function(input)
                            if Context.pressed(context, input) then
                                choose(entry)
                            end
                        end)

                        if #entries == 1 then
                            choose(entry)
                        end

                        return Box.new(Slot.new(context, controls, registry))
                    end,
                }
            end

            return table.freeze(Tabbox)
        end

        function __ANTIBRAIN_MODULES.a0()
            local v = __ANTIBRAIN_MODULES.cache.a0

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a0 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local TITLE, TEXT_SIZE, GAP = 18, 14, 5
            local Warning = {}

            local function fit(warning)
                local text = warning.text
                local textHeight = Kit.measure(text.Text, TEXT_SIZE, Vector2.new(text.AbsoluteSize.X, math.huge)).Y

                text.Size = UDim2.new(1, -4, 0, textHeight)

                local height = 10 + 2 + TITLE + textHeight + GAP

                height = math.max(height, math.ceil((textHeight + GAP) / (1 - text.Position.Y.Scale)) + 2)

                if height ~= warning.frame.Size.Y.Offset then
                    warning.frame.Size = UDim2.new(1, -10, 0, height)

                    warning.resized()
                end
            end

            function Warning.new(kit, page, position, resized)
                local frame = Instance.new('Frame')

                frame.BorderColor3 = Color3.fromRGB(248, 51, 51)
                frame.BorderMode = Enum.BorderMode.Inset
                frame.Position = position
                frame.Size = UDim2.new(1, -10, 0, 0)
                frame.ZIndex = 2
                frame.Visible = false

                kit.theme:bind(frame, function()
                    frame.BackgroundColor3 = kit.theme.colors.background
                end)

                frame.Parent = page

                local well = Instance.new('Frame')

                well.BackgroundColor3 = Color3.fromRGB(117, 22, 17)
                well.BorderColor3 = Color3.new(0, 0, 0)
                well.Position = UDim2.fromOffset(1, 1)
                well.Size = UDim2.new(1, -2, 1, -2)
                well.ZIndex = 4
                well.Parent = frame

                local line = Instance.new('Frame')

                line.BackgroundColor3 = Color3.fromRGB(255, 75, 75)
                line.BorderSizePixel = 0
                line.Size = UDim2.new(1, 0, 0, 2)
                line.ZIndex = 5
                line.Parent = well

                local title = Instance.new('TextLabel')

                title.BackgroundTransparency = 1
                title.Font = Kit.font()
                title.Text = ''
                title.TextColor3 = Color3.fromRGB(255, 55, 55)
                title.TextSize = TEXT_SIZE
                title.TextXAlignment = Enum.TextXAlignment.Left
                title.Position = UDim2.fromOffset(4, 2)
                title.Size = UDim2.new(1, 0, 0, TITLE)
                title.ZIndex = 5

                local titleStroke = Instance.new('UIStroke')

                titleStroke.Color = Color3.fromRGB(174, 3, 3)
                titleStroke.LineJoinMode = Enum.LineJoinMode.Miter
                titleStroke.Parent = title
                title.Parent = well

                local text = Kit.text(kit, well, {
                    text = '',
                    position = UDim2.new(0, 4, 0.35, 0),
                    size = UDim2.new(1, -4, 0, 15),
                    zIndex = 5,
                    textSize = TEXT_SIZE,
                    wrapped = true,
                    xAlignment = Enum.TextXAlignment.Left,
                    yAlignment = Enum.TextYAlignment.Top,
                })
                local warning = {
                    frame = frame,
                    title = title,
                    text = text,
                    resized = resized,
                }

                kit.scope:connect(text:GetPropertyChangedSignal('AbsoluteSize'), function(
                )
                    fit(warning)
                end)

                return warning
            end
            function Warning.set(warning, title, text)
                warning.frame.Visible = title ~= nil or text ~= nil
                warning.title.Text = title or ''
                warning.text.Text = text or ''

                fit(warning)
                warning.resized()
            end
            function Warning.height(warning)
                return (warning.frame.Visible and {
                    warning.frame.Size.Y.Offset,
                } or {0})[1]
            end

            return table.freeze(Warning)
        end

        function __ANTIBRAIN_MODULES.a1()
            local v = __ANTIBRAIN_MODULES.cache.a1

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a1 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.aI()
            __ANTIBRAIN_MODULES.b()

            local Groupbox = __ANTIBRAIN_MODULES.a_()
            local Kit = __ANTIBRAIN_MODULES.aC()

            __ANTIBRAIN_MODULES.aw()

            local Tabbox = __ANTIBRAIN_MODULES.a0()
            local Warning = __ANTIBRAIN_MODULES.a1()
            local MARGIN, BETWEEN, WARNING_X = 7, 8, 8
            local Tab = {}

            function Tab.new(context, container, name, registry)
                local kit = context.kit
                local frame = Kit.frame(kit, container, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = 2,
                    visible = false,
                })

                local function column()
                    local side = Instance.new('ScrollingFrame')

                    side.BackgroundTransparency = 1
                    side.BorderSizePixel = 0
                    side.CanvasSize = UDim2.new()
                    side.AutomaticCanvasSize = Enum.AutomaticSize.Y
                    side.TopImage = ''
                    side.BottomImage = ''
                    side.ScrollBarThickness = 0
                    side.ZIndex = 2
                    side.Parent = frame

                    local layout = Kit.list(side, BETWEEN)

                    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

                    return side
                end

                local left, right = column(), column()
                local orders = {
                    Left = 0,
                    Right = 0,
                }
                local warning

                local function arrange()
                    local taken = Warning.height(warning)
                    local top = (taken > 0 and {
                        (MARGIN + taken + 10),
                    } or {MARGIN})[1]

                    left.Position = UDim2.fromOffset(MARGIN, top)
                    left.Size = UDim2.new(0.5, -10, 1, -MARGIN - top)
                    right.Position = UDim2.new(0.5, 5, 0, top)
                    right.Size = UDim2.new(0.5, -10, 1, -MARGIN - top)
                end

                warning = Warning.new(kit, frame, UDim2.fromOffset(WARNING_X, MARGIN), arrange)

                arrange()

                local function place(side)
                    orders[side] = orders[side] + 1

                    return (side == 'Left' and {left} or {right})[1], orders[side]
                end

                local tab = {
                    name = name,
                    groupbox = function(_, side, title)
                        local target, order = place(side)

                        return Groupbox.new(context, target, order, registry, title)
                    end,
                    tabbox = function(_, side)
                        local target, order = place(side)

                        return Tabbox.new(context, target, order, registry)
                    end,
                    setWarning = function(_, title, text)
                        Warning.set(warning, title, text)
                    end,
                }

                return {
                    tab = tab,
                    frame = frame,
                }
            end

            return table.freeze(Tab)
        end

        function __ANTIBRAIN_MODULES.a2()
            local v = __ANTIBRAIN_MODULES.cache.a2

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a2 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Context = __ANTIBRAIN_MODULES.aI()
            local Drag = __ANTIBRAIN_MODULES.aE()
            local Kit = __ANTIBRAIN_MODULES.aC()

            __ANTIBRAIN_MODULES.aw()

            local Tab = __ANTIBRAIN_MODULES.a2()
            local WIDTH, HEIGHT, MIN_WIDTH, MIN_HEIGHT = 550, 650, 550, 300
            local TITLE, TAB_GAP, TAB_PADDING = 25, 8, 12

            local function makeChrome(context, layer, config)
                local kit = context.kit
                local mobile = context.mobile
                local outer = Kit.frame(kit, context.gui, {
                    position = UDim2.new(0.5, -WIDTH / 2, mobile and 0 or 0.5, mobile and 0 or 
-HEIGHT / 2),
                    size = (mobile and {
                        (UDim2.new(0, WIDTH, 0.8, 0)),
                    } or {
                        (UDim2.fromOffset(WIDTH, HEIGHT)),
                    })[1],
                    zIndex = 1,
                    fill = 'black',
                    visible = false,
                    active = true,
                })

                Drag.outline(kit, outer, outer, TITLE, layer, function(active)
                    context.dragging = active
                end, function()
                    return not context.locked
                end)
                Drag.resize(kit, outer, Vector2.new(MIN_WIDTH, MIN_HEIGHT), layer)

                local inner = Kit.frame(kit, outer, {
                    position = UDim2.fromOffset(1, 1),
                    size = UDim2.new(1, -2, 1, -2),
                    zIndex = 1,
                    fill = 'main',
                    border = 'outline',
                    inset = true,
                })

                Kit.text(kit, inner, {
                    text = config.title,
                    size = UDim2.new(1, 0, 0, TITLE),
                    zIndex = 1,
                    textSize = 18,
                    rich = true,
                })
                Kit.text(kit, inner, {
                    text = config.game or '',
                    position = UDim2.fromOffset(-8, 0),
                    size = UDim2.new(1, 0, 0, TITLE),
                    zIndex = 1,
                    shade = 'accent',
                    xAlignment = Enum.TextXAlignment.Right,
                    rich = true,
                    engineStroke = true,
                })

                local section = Kit.frame(kit, inner, {
                    position = UDim2.fromOffset(8, TITLE),
                    size = UDim2.new(1, -16, 1, -33),
                    zIndex = 1,
                    fill = 'background',
                    border = 'outline',
                })
                local sectionInner = Kit.frame(kit, section, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = 1,
                    fill = 'background',
                    border = 'black',
                    inset = true,
                })
                local tabBar = Instance.new('ScrollingFrame')

                tabBar.BackgroundTransparency = 1
                tabBar.BorderSizePixel = 0
                tabBar.Position = UDim2.fromOffset(0, 4)
                tabBar.Size = UDim2.new(1, -10, 0, 29)
                tabBar.CanvasSize = UDim2.new()
                tabBar.AutomaticCanvasSize = Enum.AutomaticSize.XY
                tabBar.ScrollBarThickness = 0
                tabBar.ScrollingDirection = Enum.ScrollingDirection.X
                tabBar.ZIndex = 1
                tabBar.Parent = sectionInner

                local barPadding = Instance.new('UIPadding')

                barPadding.PaddingTop = UDim.new(0, 1)
                barPadding.Parent = tabBar

                local barLayout = Kit.list(tabBar, TAB_GAP, true)

                barLayout.VerticalAlignment = Enum.VerticalAlignment.Center

                for _, order in {
                    -1,
                    9999999,
                }do
                    local spacer = Instance.new('Frame')

                    spacer.BackgroundTransparency = 1
                    spacer.Size = UDim2.new()
                    spacer.LayoutOrder = order
                    spacer.ZIndex = 1
                    spacer.Parent = tabBar
                end

                local pages = Kit.frame(kit, sectionInner, {
                    position = UDim2.fromOffset(8, 38),
                    size = UDim2.new(1, -16, 1, -47),
                    zIndex = 1,
                    fill = 'main',
                    border = 'outline',
                    borderSize = 2,
                })
                local pagesInner = Kit.frame(kit, pages, {
                    size = UDim2.fromScale(1, 1),
                    zIndex = 2,
                    fill = 'main',
                    border = 'black',
                })

                return {
                    frame = outer,
                    tabBar = tabBar,
                    pages = pagesInner,
                }
            end

            local Window = {}

            function Window.new(context, layer, config)
                local kit = context.kit
                local scope = kit.scope
                local chrome = makeChrome(context, layer, config)
                local entries = {}

                local function edgeColor(on)
                    return (on and {
                        (Color3.new(0, 0, 0)),
                    } or {
                        (Color3.fromRGB(25, 25, 25)),
                    })[1]
                end
                local function choose(chosen)
                    for _, entry in entries do
                        local on = entry == chosen

                        entry.page.frame.Visible = on
                        entry.accent.Visible = on

                        entry.restyle(on and 'main' or 'background', nil)
                        entry.tint(on and 'font' or 'dim')

                        entry.stroke.Color = edgeColor(on)
                    end
                end

                local window = {
                    frame = chrome.frame,
                    tab = function(_, name, registry)
                        local page = Tab.new(context, chrome.pages, name, registry)
                        local button, restyle = Kit.frame(kit, chrome.tabBar, {
                            size = UDim2.new(0, Kit.measure(name, 16).X + TAB_PADDING, 0.75, 0),
                            zIndex = 1,
                            fill = 'background',
                            border = 'outline',
                            borderSize = 2,
                            active = true,
                            layoutOrder = #entries + 1,
                        })
                        local edge = Kit.frame(kit, button, {
                            size = UDim2.fromScale(1, 1),
                            zIndex = 2,
                        })
                        local stroke = Instance.new('UIStroke')

                        stroke.Color = edgeColor(false)
                        stroke.LineJoinMode = Enum.LineJoinMode.Miter
                        stroke.Parent = edge

                        local accent = Kit.frame(kit, button, {
                            size = UDim2.new(1, 0, 0, 1),
                            zIndex = 104,
                            fill = 'accent',
                            visible = false,
                        })
                        local _, tint = Kit.text(kit, button, {
                            text = name,
                            size = UDim2.new(1, 0, 1, -1),
                            zIndex = 1,
                            shade = 'dim',
                        })
                        local entry = {
                            page = page,
                            restyle = restyle,
                            tint = tint,
                            accent = accent,
                            stroke = stroke,
                        }

                        table.insert(entries, entry)
                        scope:connect(button.InputBegan, function(input)
                            if Context.pressed(context, input) then
                                choose(entry)
                            end
                        end)

                        if #entries == 1 then
                            choose(entry)
                        end

                        return page
                    end,
                }

                return window
            end

            return table.freeze(Window)
        end

        function __ANTIBRAIN_MODULES.a3()
            local v = __ANTIBRAIN_MODULES.cache.a3

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a3 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Backdrop = __ANTIBRAIN_MODULES.az()

            __ANTIBRAIN_MODULES.aI()
            __ANTIBRAIN_MODULES.b()

            local Cursor = __ANTIBRAIN_MODULES.aJ()
            local KeybindList = __ANTIBRAIN_MODULES.aF()
            local Kit = __ANTIBRAIN_MODULES.aC()
            local Notifications = __ANTIBRAIN_MODULES.aK()

            __ANTIBRAIN_MODULES.aw()

            local Overlay = __ANTIBRAIN_MODULES.aG()
            local Palette = __ANTIBRAIN_MODULES.aA()
            local Popout = __ANTIBRAIN_MODULES.aY()
            local Scope = __ANTIBRAIN_MODULES.c()
            local Services = __ANTIBRAIN_MODULES.k()
            local Signal = __ANTIBRAIN_MODULES.ax()
            local Theme = __ANTIBRAIN_MODULES.aB()
            local Tooltip = __ANTIBRAIN_MODULES.aH()
            local TouchButton = __ANTIBRAIN_MODULES.aZ()
            local Window = __ANTIBRAIN_MODULES.a3()
            local BACKDROP, OUTLINES, WINDOW, POPOUTS, CURSOR = 997, 998, 999, 1000, 1001
            local Library = {}

            local function layer(scope, parent, order, ignoreInset)
                local gui = Scope.own(scope, Instance.new('ScreenGui'))

                gui.DisplayOrder = order
                gui.IgnoreGuiInset = ignoreInset == true
                gui.ResetOnSpawn = false
                gui.ZIndexBehavior = Enum.ZIndexBehavior.Global
                gui.Parent = parent

                return gui
            end
            local function mobilePlatform()
                local ok, platform = pcall(function()
                    return Services.UserInputService:GetPlatform()
                end)

                return ok and (platform == Enum.Platform.Android or platform == Enum.Platform.IOS)
            end

            function Library.new(scope, config)
                local inputService = Services.UserInputService
                local mobile = mobilePlatform()
                local gui = layer(scope, config.parent, WINDOW)
                local outlines = layer(scope, config.parent, OUTLINES)
                local popouts = layer(scope, config.parent, POPOUTS)
                local cursorLayer = layer(scope, config.parent, CURSOR)
                local backdropLayer = layer(scope, config.parent, BACKDROP, true)
                local theme = Theme.new(scope, Palette.colors(Palette.BUILT_IN[1].colors))
                local kit = Kit.new(theme, scope)
                local overlay = Overlay.new(scope)
                local notifications = Notifications.new(kit, gui)
                local context = {
                    kit = kit,
                    gui = gui,
                    overlay = overlay,
                    tooltips = Tooltip.new(kit, overlay, gui),
                    keybinds = KeybindList.new(kit, gui, mobile),
                    changed = Signal.new(config.report),
                    report = config.report,
                    notify = function(text, seconds)
                        Notifications.show(notifications, text, seconds)
                    end,
                    mobile = mobile,
                    dragging = false,
                    locked = false,
                    copied = nil,
                }
                local popoutContext = table.clone(context)

                popoutContext.gui = popouts
                popoutContext.tooltips = Tooltip.new(kit, overlay, popouts)
                popoutContext.dragging = false

                local syncPopouts = {}
                local window = Window.new(context, outlines, {
                    title = config.title,
                    game = config.game,
                })
                local modal = Instance.new('TextButton')

                modal.BackgroundTransparency = 1
                modal.Size = UDim2.new()
                modal.Text = ''
                modal.Modal = false
                modal.Parent = gui

                local cursor = Cursor.new(kit, cursorLayer)
                local library

                library = {
                    theme = theme,
                    window = window,
                    notifications = notifications,
                    keybinds = context.keybinds,
                    backdrop = Backdrop.new(scope, backdropLayer, mobile),
                    visible = false,
                    menuKeybind = nil,
                    setMenuKeybind = function(self, keybind)
                        assert(self.menuKeybind == nil, 'The menu keybind is set once')

                        self.menuKeybind = keybind

                        scope:add(keybind:onPressed(function()
                            if keybind.key ~= 'MB1' and keybind.key ~= 'MB2' then
                                self:toggle()
                            end
                        end))
                    end,
                    popout = function(_, registry, info)
                        local made = Popout.new(popoutContext, registry, info, function(
                        )
                            return library.visible
                        end, function()
                            return not context.locked
                        end, function()
                            return window.frame
                        end)

                        table.insert(syncPopouts, made.sync)

                        return made.popout
                    end,
                    setVisible = function(self, visible)
                        if visible == self.visible or scope.closed then
                            return
                        end

                        self.visible = visible

                        Overlay.closeAll(overlay)
                        Tooltip.hide(context.tooltips)
                        Tooltip.hide(popoutContext.tooltips)

                        for _, sync in syncPopouts do
                            sync()
                        end

                        modal.Modal = visible
                        window.frame.Visible = visible

                        Backdrop.show(self.backdrop, visible)

                        if visible then
                            Cursor.show(cursor)
                        else
                            Cursor.hide(cursor)
                        end
                    end,
                    toggle = function(self)
                        self:setVisible(not self.visible)
                    end,
                    notify = function(_, text, seconds)
                        context.notify(text, seconds)
                    end,
                }

                scope:connect(inputService.InputBegan, function(
                    input,
                    processed
                )
                    if library.menuKeybind or input.UserInputType ~= Enum.UserInputType.Keyboard then
                        return
                    end
                    if input.KeyCode == Enum.KeyCode.RightControl or (input.KeyCode == Enum.KeyCode.Insert and not processed) then
                        library:toggle()
                    end
                end)

                if mobile then
                    TouchButton.new(kit, gui, 'Toggle UI', 0.018, function()
                        library:toggle()
                    end)
                    TouchButton.new(kit, gui, 'Lock UI', 0.075, function(
                        button
                    )
                        context.locked = not context.locked
                        button.Text = context.locked and 'Unlock UI' or 'Lock UI'
                    end)
                end

                return library
            end

            return table.freeze(Library)
        end

        function __ANTIBRAIN_MODULES.a4()
            local v = __ANTIBRAIN_MODULES.cache.a4

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a4 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Backdrop = __ANTIBRAIN_MODULES.az()

            __ANTIBRAIN_MODULES.b()
            __ANTIBRAIN_MODULES.a4()

            local BackgroundTab = {}

            BackgroundTab.THEME_IDS = table.freeze({
                'background-color',
                'background-transparency',
                'background-blur',
                'background-contrast',
                'background-saturation',
                'background-brightness',
            })

            function BackgroundTab.build(library, tab)
                local backdrop = library.backdrop
                local start = backdrop.settings
                local color = tab:label('Background Color'):color('background-color', {
                    default = start.color,
                })
                local transparency = tab:slider('background-transparency', {
                    text = 'Transparency',
                    compact = false,
                    default = start.transparency,
                    min = 0,
                    max = 1,
                    rounding = 2,
                })
                local blur = transparency:slider('background-blur', {
                    text = 'Blur',
                    compact = false,
                    default = start.blur,
                    min = 0,
                    max = 50,
                    rounding = 0,
                })
                local contrast = tab:slider('background-contrast', {
                    text = 'Contrast',
                    compact = false,
                    default = start.contrast,
                    min = -10,
                    max = 10,
                    rounding = 1,
                })
                local saturation = contrast:slider('background-saturation', {
                    text = 'Saturation',
                    compact = false,
                    default = start.saturation,
                    min = -10,
                    max = 10,
                    rounding = 1,
                })
                local brightness = tab:slider('background-brightness', {
                    text = 'Brightness',
                    compact = false,
                    default = start.brightness,
                    min = -1,
                    max = 1,
                    rounding = 1,
                })

                local function restyle()
                    Backdrop.restyle(backdrop, function(settings)
                        settings.color = color.value
                        settings.transparency = transparency.value
                        settings.blur = blur.value
                        settings.contrast = contrast.value
                        settings.saturation = saturation.value
                        settings.brightness = brightness.value
                    end)
                end

                color:onChanged(restyle)

                for _, slider in {
                    transparency,
                    blur,
                    contrast,
                    saturation,
                    brightness,
                }do
                    slider:onChanged(restyle)
                end
            end

            return table.freeze(BackgroundTab)
        end

        function __ANTIBRAIN_MODULES.a5()
            local v = __ANTIBRAIN_MODULES.cache.a5

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a5 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Files = __ANTIBRAIN_MODULES.ar()
            local Paths = __ANTIBRAIN_MODULES.at()
            local Preferences = {}

            local function fileName(value)
                return type(value) == 'string' and Files.validName(value)
            end

            function Preferences.read()
                local saved, readFailure = Files.read(Paths.settings())
                local preferences = {
                    theme = nil,
                    autoload = {},
                }

                if readFailure then
                    return preferences, readFailure
                end
                if saved == nil then
                    return preferences, nil
                end
                if type(saved) ~= 'table' then
                    return preferences, 'Saved preferences are not an object'
                end
                if saved.version ~= nil and saved.version ~= 1 and saved.version ~= Paths.LAYOUT then
                    return preferences, 'Saved preferences use an unsupported layout'
                end
                if fileName(saved.theme) then
                    preferences.theme = saved.theme
                end
                if type(saved.autoload) == 'table' then
                    for module, config in saved.autoload do
                        if type(module) == 'string' and fileName(config) then
                            preferences.autoload[module] = config
                        end
                    end
                end

                return preferences, nil, saved.version or 1
            end
            function Preferences.update(change)
                local preferences, readFailure, layout = Preferences.read()

                if readFailure then
                    return readFailure
                end

                change(preferences)

                return Files.write(Paths.settings(), {
                    version = layout or Paths.LAYOUT,
                    theme = preferences.theme,
                    autoload = preferences.autoload,
                })
            end

            return table.freeze(Preferences)
        end

        function __ANTIBRAIN_MODULES.a6()
            local v = __ANTIBRAIN_MODULES.cache.a6

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a6 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()

            local Files = __ANTIBRAIN_MODULES.ar()

            __ANTIBRAIN_MODULES.a4()

            local Options = __ANTIBRAIN_MODULES.aw()
            local Paths = __ANTIBRAIN_MODULES.at()
            local Preferences = __ANTIBRAIN_MODULES.a6()
            local Services = __ANTIBRAIN_MODULES.k()
            local ConfigurationBox = {}

            local function save(sources)
                return Options.save(sources.settings, sources.ids, Options.save(sources.game))
            end
            local function load(sources, saved)
                local gameFailure = Options.load(sources.game, saved)
                local settingsFailure = Options.load(sources.settings, saved, sources.ids)

                return gameFailure or settingsFailure
            end
            local function decode(text)
                local ok, decoded = pcall(function()
                    return Services.HttpService:JSONDecode(text)
                end)

                return (ok and {decoded} or {nil})[1]
            end
            local function addManage(shelf, nameInput)
                local library, box, sources, path = shelf.library, shelf.box, shelf.sources, shelf.path

                box:button({
                    text = 'Create config',
                    callback = function()
                        local name = nameInput.value

                        if not Files.validName(name) then
                            library:notify('Invalid config name (empty)', 2)

                            return
                        end

                        local failure = Files.write(path(name), save(sources))

                        if failure then
                            library:notify(string.format('Failed to save config: %s', tostring(failure)))

                            return
                        end

                        library:notify(string.format('Created config "%s"', tostring(name)))
                        shelf.refresh()
                    end,
                }):button({
                    text = 'Load config',
                    callback = function()
                        local name = shelf.chosen('load')

                        if name then
                            local failure = shelf.loadNamed(name)

                            library:notify((failure and {
                                string.format('Failed to load config: %s', tostring(failure)),
                            } or {
                                string.format('Loaded config "%s"', tostring(name)),
                            })[1])
                        end
                    end,
                })
                box:button({
                    text = 'Overwrite config',
                    doubleClick = true,
                    callback = function()
                        local name = shelf.chosen('overwrite')

                        if name then
                            local failure = Files.write(path(name), save(sources))

                            library:notify((failure and {
                                string.format('Failed to overwrite config: %s', tostring(failure)),
                            } or {
                                string.format('Overwrote config "%s"', tostring(name)),
                            })[1])
                        end
                    end,
                }):button({
                    text = 'Delete config',
                    doubleClick = true,
                    callback = function()
                        local name = shelf.chosen('delete')

                        if not name then
                            return
                        end

                        local failure = Files.delete(path(name))

                        if failure then
                            library:notify(string.format('Failed to delete config: %s', tostring(failure)))

                            return
                        end

                        library:notify(string.format('Deleted config "%s"', tostring(name)))
                        shelf.refresh()
                    end,
                })
                box:button({
                    text = 'Refresh list',
                    callback = shelf.refresh,
                })
            end
            local function addAutoload(shelf)
                local library, box, module = shelf.library, shelf.box, shelf.module
                local label

                local function show()
                    local name = Preferences.read().autoload[module]

                    label:setText(string.format('Current autoload config: %s', tostring(name or 'none')))
                end

                box:button({
                    text = 'Set autoload',
                    callback = function()
                        local name = shelf.chosen('set autoload')

                        if not name then
                            return
                        end

                        local failure = Preferences.update(function(
                            preferences
                        )
                            preferences.autoload[module] = name
                        end)

                        show()
                        library:notify(failure or string.format('Set "%s" to auto load', tostring(name)))
                    end,
                }):button({
                    text = 'Remove autoload',
                    callback = function()
                        local failure = Preferences.update(function(
                            preferences
                        )
                            preferences.autoload[module] = nil
                        end)

                        show()
                        library:notify(failure or 'removed autoload')
                    end,
                })

                label = box:label('Current autoload config: none', true)

                show()

                return function()
                    local name = Preferences.read().autoload[module]

                    if not name then
                        return
                    end

                    local failure = shelf.loadNamed(name)

                    library:notify((failure and {
                        string.format('Failed to load autoload config: %s', tostring(failure)),
                    } or {
                        string.format('Auto loaded config "%s"', tostring(name)),
                    })[1])
                end
            end
            local function addClipboard(shelf)
                local library, box, sources = shelf.library, shelf.box, shelf.sources
                local import = box:input('config-import', {
                    text = 'Import from clipboard',
                    placeholder = 'Paste config here...',
                })

                import:onChanged(function(raw)
                    if raw == '' then
                        return
                    end

                    import:set('')

                    local decoded = decode(raw)

                    if type(decoded) ~= 'table' or decoded.options == nil then
                        library:notify('Failed to load paste config, did you copy it properly?')

                        return
                    end

                    local failure = load(sources, decoded)

                    library:notify((failure and {
                        string.format('Failed to load config: %s', tostring(failure)),
                    } or {
                        'Loaded copied config!',
                    })[1])
                end)
                box:button({
                    text = 'Copy config to clipboard',
                    callback = function()
                        local name = shelf.chosen('copy')

                        if not name then
                            return
                        end
                        if type(setclipboard) ~= 'function' then
                            library:notify('Failed to copy config: this executor has no clipboard')

                            return
                        end

                        local copied, failure = pcall(function()
                            setclipboard(Services.HttpService:JSONEncode(save(sources)))
                        end)

                        library:notify((copied and {
                            string.format('copied config "%s"', tostring(name)),
                        } or {
                            string.format('Failed to copy config: %s', tostring(failure)),
                        })[1])
                    end,
                })
            end

            function ConfigurationBox.build(
                library,
                box,
                sources,
                module,
                persistence
            )
                if not module or not persistence then
                    box:label(not persistence and 
[[This executor has no file functions, so themes and configs cannot be saved.]] or 
[[No module is running, so there are no game settings to save as a config.]], true)

                    return {
                        loadAutoload = function() end,
                    }
                end

                local folder = Paths.configs(module)
                local nameInput = box:input('config-name', {
                    text = 'Config name',
                })
                local list = box:dropdown('config-list', {
                    text = 'Config list',
                    values = Files.names(folder),
                    allowNull = true,
                })
                local shelf

                shelf = {
                    library = library,
                    box = box,
                    sources = sources,
                    module = module,
                    list = list,
                    path = function(name)
                        return Paths.config(module, name)
                    end,
                    loadNamed = function(name)
                        local saved, readFailure = Files.read(shelf.path(name))

                        return readFailure or load(sources, saved)
                    end,
                    refresh = function()
                        list:setValues(Files.names(folder))
                        list:set(nil)
                    end,
                    chosen = function(doing)
                        local name = list.value

                        if not name then
                            library:notify(string.format('Failed to %s config: no config file is selected', tostring(doing)))
                        end

                        return name
                    end,
                }

                addManage(shelf, nameInput)

                local loadAutoload = addAutoload(shelf)

                box:divider()
                addClipboard(shelf)

                return {loadAutoload = loadAutoload}
            end

            return table.freeze(ConfigurationBox)
        end

        function __ANTIBRAIN_MODULES.a7()
            local v = __ANTIBRAIN_MODULES.cache.a7

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a7 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()

            local KeybindList = __ANTIBRAIN_MODULES.aF()

            __ANTIBRAIN_MODULES.a4()

            local MenuTab = {}

            MenuTab.CONFIG_IDS = table.freeze({
                'menu-keybind',
                'keybind-list',
                'keybind-list-opacity',
                'keybind-list-mode',
            })

            local function listMode(name)
                return name == 'Active' and 'Active' or (name == 'All' and 'All' or 'Toggled')
            end

            function MenuTab.build(library, tab, stop)
                local keybinds = library.keybinds
                local modes = {
                    'Toggle',
                }

                library:setMenuKeybind(tab:label('Menu bind'):keybind('menu-keybind', {
                    text = 'Menu keybind',
                    default = 'RightShift',
                    modes = modes,
                    hidden = true,
                }))

                local shown = tab:toggle('keybind-list', {
                    text = 'Keybind Menu',
                    default = true,
                    tooltip = 'Shows Keybinds',
                })
                local opacity = tab:slider('keybind-list-opacity', {
                    text = 'Menu Transparency',
                    default = 100,
                    min = 0,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })
                local mode = tab:dropdown('keybind-list-mode', {
                    text = 'Keybind Menu Mode',
                    values = {
                        'Active',
                        'Toggled',
                        'All',
                    },
                    default = 'Toggled',
                })

                tab:button({
                    text = 'Unload',
                    doubleClick = true,
                    callback = stop,
                })
                shown:onChanged(function(value)
                    KeybindList.setShown(keybinds, value)
                end)
                opacity:onChanged(function(value)
                    KeybindList.setOpacity(keybinds, value / 100)
                end)
                mode:onChanged(function(value)
                    KeybindList.setMode(keybinds, listMode(value))
                end)
            end

            return table.freeze(MenuTab)
        end

        function __ANTIBRAIN_MODULES.a8()
            local v = __ANTIBRAIN_MODULES.cache.a8

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a8 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()
            __ANTIBRAIN_MODULES.a4()

            local Notifications = __ANTIBRAIN_MODULES.aK()
            local NotificationsTab = {}

            NotificationsTab.CONFIG_IDS = table.freeze({
                'notification-force-colors',
                'notification-main',
                'notification-accent',
                'notification-outline',
                'notification-font',
                'notification-clips',
                'notification-clip-distance',
                'notification-x',
                'notification-y',
                'notification-transparency',
                'notification-alignment',
                'notification-bar',
                'notification-sort',
            })

            local function alignment(name)
                return name == 'Left' and 'Left' or (name == 'Right' and 'Right' or 'Center')
            end
            local function barSide(name)
                return name == 'Left' and 'Left' or (name == 'Top' and 'Top' or (name == 'Right' and 'Right' or 'Bottom'))
            end
            local function sortOrder(name)
                return name == 'Text Length' and 'Text Length' or 'Default'
            end

            function NotificationsTab.build(library, tab)
                local clips = tab:toggle('notification-clips', {
                    text = 'Clip Descendants',
                    default = true,
                    tooltip = 'if enabled, will hide notifications past a certain point',
                })
                local clipDistance = tab:dependent(function()
                    return clips.value
                end):slider('notification-clip-distance', {
                    text = 'Clip Past Distance',
                    default = 200,
                    min = 100,
                    max = 1000,
                    rounding = 0,
                    suffix = 'px',
                })
                local force = tab:toggle('notification-force-colors', {
                    text = 'Force Color',
                    default = false,
                    tooltip = 
[[forces the notification colors based on the config, not the theme]],
                })
                local colors = library.theme.colors
                local main = force:color('notification-main', {
                    title = 'Main Color',
                    default = colors.main,
                })
                local accent = force:color('notification-accent', {
                    title = 'Accent Color',
                    default = colors.accent,
                })
                local outline = force:color('notification-outline', {
                    title = 'Outline Color',
                    default = colors.outline,
                })
                local text = force:color('notification-font', {
                    title = 'Font Color',
                    default = colors.font,
                })

                tab:dependent(function()
                    return force.value
                end):button({
                    text = 'copy colors',
                    tooltip = 'copys the colors from your current theme',
                    doubleClick = true,
                    callback = function()
                        local current = library.theme.colors

                        main:set(current.main)
                        accent:set(current.accent)
                        outline:set(current.outline)
                        text:set(current.font)
                    end,
                })

                local x = tab:slider('notification-x', {
                    text = 'Position X',
                    default = 50,
                    min = 0,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })
                local y = x:slider('notification-y', {
                    text = 'Position Y',
                    default = 60,
                    min = 0,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })
                local opacity = tab:slider('notification-transparency', {
                    text = 'Transparency',
                    default = 25,
                    min = 0,
                    max = 100,
                    rounding = 0,
                    suffix = '%',
                })
                local anchor = tab:dropdown('notification-alignment', {
                    text = 'Alignment',
                    values = {
                        'Left',
                        'Right',
                        'Center',
                    },
                    default = 'Center',
                    tooltip = 'how the text is positioned',
                })
                local bar = tab:dropdown('notification-bar', {
                    text = 'Bar Side',
                    values = {
                        'Left',
                        'Right',
                        'Top',
                        'Bottom',
                    },
                    default = 'Bottom',
                })
                local sort = tab:dropdown('notification-sort', {
                    text = 'Sort Order',
                    values = {
                        'Text Length',
                        'Default',
                    },
                    default = 'Default',
                })
                local test = 1

                tab:button({
                    text = 'Send Notification',
                    callback = function()
                        library:notify(string.format('test notification (%s)', tostring(test)), 3)

                        test = test * 2
                    end,
                })

                local function restyle()
                    Notifications.restyle(library.notifications, function(
                        style
                    )
                        style.clips = clips.value
                        style.clipDistance = clipDistance.value
                        style.colors = force.value and {
                            main = main.value,
                            accent = accent.value,
                            outline = outline.value,
                            text = text.value,
                        } or nil
                        style.x = x.value / 100
                        style.y = y.value / 100
                        style.transparency = 1 - opacity.value / 100
                        style.anchor = alignment(anchor.value)
                        style.barSide = barSide(bar.value)
                        style.sortOrder = sortOrder(sort.value)
                    end)
                end

                for _, toggle in {clips, force}do
                    toggle:onChanged(restyle)
                end
                for _, picker in {
                    main,
                    accent,
                    outline,
                    text,
                }do
                    picker:onChanged(restyle)
                end
                for _, slider in {
                    clipDistance,
                    x,
                    y,
                    opacity,
                }do
                    slider:onChanged(restyle)
                end
                for _, dropdown in {anchor, bar, sort}do
                    dropdown:onChanged(restyle)
                end

                restyle()
            end

            return table.freeze(NotificationsTab)
        end

        function __ANTIBRAIN_MODULES.a9()
            local v = __ANTIBRAIN_MODULES.cache.a9

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.a9 = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            __ANTIBRAIN_MODULES.b()

            local Files = __ANTIBRAIN_MODULES.ar()

            __ANTIBRAIN_MODULES.a4()

            local Options = __ANTIBRAIN_MODULES.aw()
            local Palette = __ANTIBRAIN_MODULES.aA()
            local Paths = __ANTIBRAIN_MODULES.at()
            local Preferences = __ANTIBRAIN_MODULES.a6()
            local ThemesTab = {}

            ThemesTab.THEME_IDS = table.freeze({
                'theme-font',
                'theme-main',
                'theme-accent',
                'theme-outline',
                'theme-background',
                'theme-risk',
            })

            local function savedThemes(
                library,
                themes,
                registry,
                saved,
                remember
            )
                local nameInput = themes:input('theme-name', {
                    text = 'Custom theme name',
                })

                local function write(name)
                    return Files.write(Paths.theme(name), Options.save(registry, saved))
                end

                local customList

                local function refresh()
                    customList:setValues(Files.names(Paths.themes()))
                    customList:set(nil)
                end

                themes:button({
                    text = 'Create theme',
                    callback = function()
                        local name = nameInput.value:gsub('%.json$', '')

                        if not Files.validName(name) then
                            library:notify('Failed to create theme: invalid name')

                            return
                        end

                        local failure = write(name)

                        if failure then
                            library:notify(string.format('Failed to create theme: %s', tostring(failure)))

                            return
                        end

                        refresh()
                        library:notify(string.format('Created theme "%s"', tostring(name)))
                    end,
                })

                local stored = Files.names(Paths.themes())

                customList = themes:dropdown('theme-custom', {
                    text = 'Custom themes',
                    values = stored,
                    default = stored[1],
                    allowNull = true,
                })

                themes:button({
                    text = 'Load theme',
                    callback = function()
                        local name = customList.value

                        if not name then
                            return
                        end

                        local theme, readFailure = Files.read(Paths.theme(name))
                        local failure = readFailure or Options.load(registry, theme, saved)

                        if failure then
                            library:notify(string.format('Failed to load theme: %s', tostring(failure)), 3)
                        end
                    end,
                })
                themes:button({
                    text = 'Overwrite Theme',
                    callback = function()
                        local name = customList.value
                        local failure = (name and {
                            (write(name)),
                        } or {nil})[1]

                        if failure then
                            library:notify(string.format('Failed to overwrite theme: %s', tostring(failure)))
                        end
                    end,
                }):button({
                    text = 'Delete Theme',
                    callback = function()
                        local name = customList.value

                        if not name then
                            library:notify('Failed to delete theme: no theme file is selected')

                            return
                        end

                        local failure = Files.delete(Paths.theme(name))

                        if failure then
                            library:notify(string.format('Failed to delete theme: %s', tostring(failure)))

                            return
                        end

                        library:notify(string.format('Deleted theme "%s"', tostring(name)))
                        refresh()
                    end,
                })
                themes:button({
                    text = 'Set Default',
                    callback = function()
                        local name = customList.value

                        if name then
                            remember(name, string.format('Set default theme to "%s"', tostring(name)))
                        end
                    end,
                }):button({
                    text = 'Reset Default',
                    callback = function()
                        remember(nil, 'Removed default theme')
                    end,
                })
                themes:button({
                    text = 'Refresh',
                    callback = refresh,
                })

                return customList
            end

            function ThemesTab.build(
                library,
                themes,
                registry,
                saved,
                persistence
            )
                local function remember(name, told)
                    local failure = Preferences.update(function(preferences)
                        preferences.theme = name
                    end)

                    library:notify(failure or told)
                end

                local colors = library.theme.colors
                local pickers = {}

                for _, entry in Palette.KEYS do
                    pickers[entry.key] = themes:label(entry.label):color(string.format('theme-%s', tostring(entry.key)), {
                        default = colors[entry.key],
                    })
                end

                local function repaint()
                    local chosen = table.clone(library.theme.colors)

                    for key, picker in pickers do
                        chosen[key] = picker.value
                    end

                    library.theme:set(chosen)
                end

                for _, picker in pickers do
                    picker:onChanged(repaint)
                end

                local defaults
                local names = {}

                for _, builtIn in Palette.BUILT_IN do
                    table.insert(names, builtIn.name)
                end

                local list = themes:dropdown('theme-list', {
                    text = 'Theme list',
                    values = names,
                    default = Palette.DEFAULT,
                })

                local function applyBuiltIn(name)
                    local builtIn = Palette.builtIn(name)

                    if not builtIn then
                        return
                    end

                    local theme = table.clone(defaults.options)

                    for key, hex in builtIn.colors do
                        theme[string.format('theme-%s', tostring(key))] = {
                            color = hex,
                            transparency = 0,
                        }
                    end

                    Options.load(registry, {
                        version = defaults.version,
                        options = theme,
                    }, saved)
                end

                list:onChanged(function(name)
                    if name then
                        applyBuiltIn(name)
                    end
                end)
                themes:button({
                    text = 'Set Default',
                    callback = function()
                        local name = list.value

                        if name then
                            remember(name, string.format('Set default theme to "%s"', tostring(name)))
                        end
                    end,
                })

                local custom = (persistence and {
                    (savedThemes(library, themes, registry, saved, remember)),
                } or {nil})[1]

                defaults = Options.save(registry, saved)

                return {
                    applyDefault = function()
                        local name = Preferences.read().theme or Palette.DEFAULT

                        if Palette.builtIn(name) then
                            if list.value == name then
                                applyBuiltIn(name)
                            else
                                list:set(name)
                            end

                            return
                        end

                        local theme = (custom and {
                            (Files.read(Paths.theme(name))),
                        } or {nil})[1]

                        if not theme or Options.load(registry, theme, saved) then
                            applyBuiltIn(Palette.DEFAULT)
                        end
                    end,
                }
            end

            return table.freeze(ThemesTab)
        end

        function __ANTIBRAIN_MODULES.ba()
            local v = __ANTIBRAIN_MODULES.cache.ba

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.ba = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local BackgroundTab = __ANTIBRAIN_MODULES.a5()
            local ConfigurationBox = __ANTIBRAIN_MODULES.a7()

            __ANTIBRAIN_MODULES.a4()

            local MenuTab = __ANTIBRAIN_MODULES.a8()
            local NotificationsTab = __ANTIBRAIN_MODULES.a9()
            local Options = __ANTIBRAIN_MODULES.aw()
            local ThemesTab = __ANTIBRAIN_MODULES.ba()
            local SettingsTab = {}

            SettingsTab.NAME = 'settings'

            local function set(lists)
                local ids = {}

                for _, list in lists do
                    for _, id in list do
                        ids[id] = true
                    end
                end

                return ids
            end

            function SettingsTab.build(setup)
                local library = setup.library
                local registry = Options.new()
                local tab = library.window:tab(SettingsTab.NAME, registry).tab
                local menuBox = tab:tabbox('Left')

                MenuTab.build(library, menuBox:tab('Menu'), setup.stop)
                NotificationsTab.build(library, menuBox:tab('Notifications'))

                local configuration = ConfigurationBox.build(library, tab:groupbox('Right', 'Configuration'), {
                    game = setup.game,
                    settings = registry,
                    ids = set({
                        MenuTab.CONFIG_IDS,
                        NotificationsTab.CONFIG_IDS,
                    }),
                }, setup.module, setup.persistence)
                local themeBox = tab:tabbox('Left')
                local themesTab, backgroundTab = themeBox:tab('Themes'), themeBox:tab('Background')

                BackgroundTab.build(library, backgroundTab)

                local themes = ThemesTab.build(library, themesTab, registry, set({
                    ThemesTab.THEME_IDS,
                    BackgroundTab.THEME_IDS,
                }), setup.persistence)

                return function()
                    themes.applyDefault()
                    configuration.loadAutoload()
                end
            end

            return table.freeze(SettingsTab)
        end

        function __ANTIBRAIN_MODULES.bb()
            local v = __ANTIBRAIN_MODULES.cache.bb

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.bb = v
            end

            return v.c
        end
    end
    do
        local function __modImpl()
            local Data = __ANTIBRAIN_MODULES.ay()
            local Failure = __ANTIBRAIN_MODULES.a()

            __ANTIBRAIN_MODULES.d()

            local Library = __ANTIBRAIN_MODULES.a4()
            local Meta = __ANTIBRAIN_MODULES.as()
            local Options = __ANTIBRAIN_MODULES.aw()
            local SettingsTab = __ANTIBRAIN_MODULES.bb()
            local View = {}

            function View.mount(context)
                local scope = context.scope

                assert(not scope.closed, 'UI session was superseded')

                local module = context.module
                local library = Library.new(scope, {
                    parent = gethui(),
                    title = Meta.name,
                    game = (module and {
                        module.name,
                    } or {nil})[1],
                    report = context.report,
                })
                local game = Options.new()
                local ready = false
                local tabNames = {
                    [SettingsTab.NAME] = true,
                }
                local ids = {}

                local function qualify(localId)
                    local running = assert(module, 'Control ids require a running module')

                    assert(localId:match('^[a-z][a-z0-9_-]*$'), string.format('Control id "%s" must use lowercase letters, digits, - or _', tostring(localId)))
                    assert(not ids[localId], string.format('Control id "%s" is already used', tostring(localId)))

                    ids[localId] = true

                    return string.format('%s.%s', tostring(running.id), tostring(localId))
                end

                local gameUI = {
                    tab = function(name)
                        assert(not scope.closed, 'Cannot add a tab to a stopped session')
                        assert(not ready, 'Game tabs must be added during start')
                        assert(name:match('%S') and not tabNames[name], string.format(
[[Cannot add tab "%s": the name is blank, reserved or already used]], tostring(name)))

                        tabNames[name] = true

                        return library.window:tab(name, game).tab
                    end,
                    popout = function(info)
                        assert(not scope.closed, 'Cannot add a popout to a stopped session')
                        assert(not ready, 'Popouts must be added during start')

                        return library:popout(game, info)
                    end,
                    id = qualify,
                    data = function(localId, default)
                        return Data.new(game, qualify(localId), default or '', context.log)
                    end,
                    notify = function(message)
                        library:notify(message)
                    end,
                }

                return {
                    game = gameUI,
                    ready = function()
                        assert(not scope.closed, 'Cannot finish UI in a stopped session')
                        assert(not ready, 'UI is already ready')

                        ready = true

                        local settingsFailure = Failure.capture(function()
                            local start = SettingsTab.build({
                                library = library,
                                game = game,
                                persistence = context.persistence,
                                module = (module and {
                                    module.id,
                                } or {nil})[1],
                                stop = context.stop,
                            })

                            start()
                        end)
                        local problem = context.problem

                        if problem then
                            library:notify(string.format('%s is not running. %s', tostring(problem.name), tostring(problem.reason)), 10)
                        else
                            library:notify(string.format('%s loaded', tostring((module and {
                                module.name,
                            } or {
                                Meta.name,
                            })[1])), 4)
                        end

                        library:setVisible(true)

                        if settingsFailure then
                            error(settingsFailure, 0)
                        end
                    end,
                }
            end

            return table.freeze(View)
        end

        function __ANTIBRAIN_MODULES.bc()
            local v = __ANTIBRAIN_MODULES.cache.bc

            if not v then
                v = {
                    c = __modImpl(),
                }
                __ANTIBRAIN_MODULES.cache.bc = v
            end

            return v.c
        end
    end
end

local App = __ANTIBRAIN_MODULES.i()
local Catalog = __ANTIBRAIN_MODULES.aq()
local Executor = __ANTIBRAIN_MODULES.av()
local Failure = __ANTIBRAIN_MODULES.a()
local Meta = __ANTIBRAIN_MODULES.as()
local View = __ANTIBRAIN_MODULES.bc()
local connected, platform = xpcall(Executor.connect, Failure.traceback)

if not connected then
    warn(string.format('[%s] %s', tostring(Meta.name), tostring(platform)))

    return
end

local launched, session, problem = xpcall(App.launch, Failure.traceback, {
    platform = platform,
    catalog = Catalog.games,
    universal = Catalog.universal,
    mount = View.mount,
})

if not launched then
    platform.log(string.format('Unable to start: %s', tostring(session)))
elseif not session then
    platform.log(problem or 'Unable to start')
end
