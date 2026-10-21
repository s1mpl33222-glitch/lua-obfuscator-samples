--Made by Pulse Hub / Discord.gg/pulsezone --
local Slate_modules = {}
local Slate_cache = {}
local function Slate_require(name)
    local hit = Slate_cache[name]
    if hit ~= nil then
        return hit
    end
    local factory = Slate_modules[name]
    if not factory then
        error("Slate: unknown module '" .. tostring(name) .. "'", 2)
    end
    local value = factory(Slate_require)
    if value == nil then
        value = true
    end
    Slate_cache[name] = value
    return value
end
Slate_modules["core/Util"] = function(require)
local Util = {}

local nextId = 0

function Util.uid(prefix)
    nextId += 1
    return (prefix or "slate") .. "_" .. nextId
end

function Util.new(class, props, children)
    local inst = Instance.new(class)
    local parent
    if props then
        for key, value in pairs(props) do
            if key == "Parent" then
                parent = value
            else
                inst[key] = value
            end
        end
    end
    if children then
        for _, child in ipairs(children) do
            child.Parent = inst
        end
    end
    if parent then
        inst.Parent = parent
    end
    return inst
end

function Util.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    end
    return value
end

function Util.round(value, decimals)
    local mult = 10 ^ math.max(0, math.floor(decimals or 0))
    return math.floor(value * mult + 0.5) / mult
end

function Util.lerp(a, b, t)
    return a + (b - a) * t
end

function Util.alpha(value, min, max)
    if max == min then
        return 0
    end
    return Util.clamp((value - min) / (max - min), 0, 1)
end

function Util.str(value, fallback)
    if type(value) == "string" then
        return value
    end
    if value == nil then
        return fallback
    end
    if type(value) == "number" or type(value) == "boolean" then
        return tostring(value)
    end
    return fallback
end

function Util.num(value, fallback)
    local converted = tonumber(value)
    if converted == nil or converted ~= converted then
        return fallback
    end
    return converted
end

function Util.bool(value, fallback)
    if type(value) == "boolean" then
        return value
    end
    return fallback
end

function Util.fn(value)
    if type(value) == "function" then
        return value
    end
    return nil
end

function Util.list(value)
    if type(value) ~= "table" then
        return {}
    end
    local out = {}
    for index, item in ipairs(value) do
        out[index] = item
    end
    return out
end

function Util.indexOf(list, value)
    for index, item in ipairs(list) do
        if item == value then
            return index
        end
    end
    return nil
end

function Util.remove(list, value)
    local index = Util.indexOf(list, value)
    if index then
        table.remove(list, index)
        return true
    end
    return false
end

function Util.merge(target, patch)
    for key, value in pairs(patch) do
        target[key] = value
    end
    return target
end

function Util.copy(source)
    local out = {}
    for key, value in pairs(source) do
        out[key] = value
    end
    return out
end

function Util.count(source)
    local total = 0
    for _ in pairs(source) do
        total += 1
    end
    return total
end

function Util.normalise(text)
    return (string.lower(tostring(text or "")):gsub("[^%w]", ""))
end

function Util.matches(haystack, needle)
    if needle == "" then
        return true
    end
    return string.find(Util.normalise(haystack), needle, 1, true) ~= nil
end

function Util.dispatch(callback, ...)
    if type(callback) ~= "function" then
        return
    end
    local args = table.pack(...)
    task.spawn(function()
        local ok, err = pcall(callback, table.unpack(args, 1, args.n))
        if not ok then
            require("core/Log").error("callback", err)
        end
    end)
end

function Util.guiInset()
    local ok, inset = pcall(function()
        return game:GetService("GuiService"):GetGuiInset()
    end)
    if ok and typeof(inset) == "Vector2" then
        return inset
    end
    return Vector2.new(0, 0)
end

local executorName, executorVersion, executorProbed = nil, nil, false

function Util.executor()
    if executorProbed then
        return executorName, executorVersion
    end
    executorProbed = true
    local names = { "identifyexecutor", "getexecutorname", "get_executor_name" }
    for _, name in ipairs(names) do
        local fn = rawget(getfenv(), name)
        if type(fn) ~= "function" then
            local ok, value = pcall(function()
                return getgenv and getgenv()[name] or nil
            end)
            fn = ok and value or nil
        end
        if type(fn) == "function" then
            local ok, label, version = pcall(fn)
            if ok and type(label) == "string" and label ~= "" then
                executorName = label
                executorVersion = type(version) == "string" and version ~= "" and version or nil
                return executorName, executorVersion
            end
        end
    end
    return nil, nil
end

function Util.viewport()
    local camera = workspace.CurrentCamera
    if camera then
        return camera.ViewportSize
    end
    return Vector2.new(1280, 720)
end

return Util

end
Slate_modules["core/Signal"] = function(require)
local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({ _handlers = {}, _dead = false }, Signal)
end

function Signal:Connect(handler)
    if self._dead or type(handler) ~= "function" then
        return { Disconnect = function() end, Connected = false }
    end
    local entry = { fn = handler, alive = true }
    table.insert(self._handlers, entry)
    local connection = {}
    connection.Connected = true
    function connection.Disconnect()
        if not entry.alive then
            return
        end
        entry.alive = false
        connection.Connected = false
        for index, candidate in ipairs(self._handlers) do
            if candidate == entry then
                table.remove(self._handlers, index)
                break
            end
        end
    end
    connection.disconnect = connection.Disconnect
    return connection
end

function Signal:Once(handler)
    local connection
    connection = self:Connect(function(...)
        connection.Disconnect()
        handler(...)
    end)
    return connection
end

function Signal:Fire(...)
    if self._dead then
        return
    end
    local snapshot = table.clone(self._handlers)
    for _, entry in ipairs(snapshot) do
        if entry.alive then
            local ok, err = pcall(entry.fn, ...)
            if not ok then
                require("core/Log").error("signal", err)
            end
        end
    end
end

function Signal:Count()
    return #self._handlers
end

function Signal:Destroy()
    self._dead = true
    table.clear(self._handlers)
end

return Signal

end
Slate_modules["core/Maid"] = function(require)
local Maid = {}
Maid.__index = Maid

function Maid.new()
    return setmetatable({ _tasks = {}, _dead = false }, Maid)
end

local function dispose(item)
    local kind = typeof(item)
    if kind == "RBXScriptConnection" then
        item:Disconnect()
    elseif kind == "Instance" then
        item:Destroy()
    elseif kind == "function" then
        item()
    elseif kind == "thread" then
        if coroutine.status(item) == "suspended" then
            task.cancel(item)
        end
    elseif kind == "table" then
        if type(item.Destroy) == "function" then
            item:Destroy()
        elseif type(item.Disconnect) == "function" then
            item:Disconnect()
        elseif type(item.disconnect) == "function" then
            item.disconnect()
        end
    end
end

function Maid:Add(item)
    if item == nil then
        return nil
    end
    if self._dead then
        pcall(dispose, item)
        return item
    end
    table.insert(self._tasks, item)
    return item
end

function Maid:AddAll(items)
    for _, item in ipairs(items) do
        self:Add(item)
    end
end

function Maid:Remove(item)
    for index, candidate in ipairs(self._tasks) do
        if candidate == item then
            table.remove(self._tasks, index)
            return true
        end
    end
    return false
end

function Maid:Extend()
    local child = Maid.new()
    self:Add(child)
    return child
end

function Maid:IsDead()
    return self._dead
end

function Maid:Clean()
    local pending = self._tasks
    self._tasks = {}
    for index = #pending, 1, -1 do
        local ok, err = pcall(dispose, pending[index])
        if not ok then
            require("core/Log").error("cleanup", err)
        end
    end
end

function Maid:Destroy()
    if self._dead then
        return
    end
    self._dead = true
    self:Clean()
end

return Maid

end
Slate_modules["core/Log"] = function(require)
local Log = {}

local enabled = false
local counters = { warn = 0, error = 0 }
local history = {}
local HISTORY_LIMIT = 100

local function record(level, scope, message)
    local line = string.format("[Slate/%s] %s: %s", level, tostring(scope), tostring(message))
    table.insert(history, line)
    if #history > HISTORY_LIMIT then
        table.remove(history, 1)
    end
    return line
end

function Log.setEnabled(state)
    enabled = state == true
end

function Log.isEnabled()
    return enabled
end

function Log.warn(scope, message)
    counters.warn += 1
    local line = record("warn", scope, message)
    if enabled then
        warn(line)
    end
end

function Log.error(scope, message)
    counters.error += 1
    local line = record("error", scope, message)
    if enabled then
        warn(line)
    end
end

function Log.expect(condition, scope, message)
    if not condition then
        Log.warn(scope, message)
    end
    return condition
end

function Log.field(scope, field, value, expected)
    Log.warn(scope, string.format(
        "field '%s' expected %s, got %s (%s)",
        tostring(field), tostring(expected), typeof(value), tostring(value)
    ))
end

function Log.stats()
    return { warnings = counters.warn, errors = counters.error, entries = #history }
end

function Log.dump()
    return table.concat(history, "\n")
end

function Log.clear()
    table.clear(history)
    counters.warn = 0
    counters.error = 0
end

return Log

end
Slate_modules["core/Theme"] = function(require)
local Signal = require("core/Signal")
local Log = require("core/Log")
local Util = require("core/Util")

local Theme = {}

Theme.Changed = Signal.new()

local PALETTES = {
    Violet = {
        Background = Color3.fromRGB(11, 11, 16),
        Surface = Color3.fromRGB(19, 19, 26),
        SurfaceAlt = Color3.fromRGB(26, 26, 35),
        Elevated = Color3.fromRGB(31, 31, 42),
        Border = Color3.fromRGB(255, 255, 255),
        Line = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(240, 240, 246),
        Muted = Color3.fromRGB(140, 140, 158),
        Faint = Color3.fromRGB(92, 92, 110),
        Accent = Color3.fromRGB(139, 92, 246),
        OnAccent = Color3.fromRGB(255, 255, 255),
        Success = Color3.fromRGB(74, 200, 140),
        Warning = Color3.fromRGB(232, 176, 78),
        Danger = Color3.fromRGB(228, 96, 106),
        ToggleOn = Color3.fromRGB(64, 196, 118),
        ToggleKnob = Color3.fromRGB(252, 253, 252),
        Info = Color3.fromRGB(110, 160, 240),
    },
    Graphite = {
        Background = Color3.fromRGB(10, 10, 11),
        Surface = Color3.fromRGB(17, 17, 19),
        SurfaceAlt = Color3.fromRGB(22, 22, 25),
        Elevated = Color3.fromRGB(27, 27, 31),
        Border = Color3.fromRGB(255, 255, 255),
        Line = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(240, 240, 242),
        Muted = Color3.fromRGB(132, 132, 141),
        Faint = Color3.fromRGB(84, 84, 92),
        Accent = Color3.fromRGB(212, 175, 120),
        OnAccent = Color3.fromRGB(14, 12, 9),
        Success = Color3.fromRGB(122, 190, 142),
        Warning = Color3.fromRGB(216, 176, 106),
        Danger = Color3.fromRGB(214, 102, 102),
        ToggleOn = Color3.fromRGB(64, 196, 118),
        ToggleKnob = Color3.fromRGB(252, 253, 252),
        Info = Color3.fromRGB(130, 152, 190),
    },
    Ash = {
        Background = Color3.fromRGB(13, 14, 15),
        Surface = Color3.fromRGB(20, 21, 23),
        SurfaceAlt = Color3.fromRGB(25, 26, 29),
        Elevated = Color3.fromRGB(31, 32, 36),
        Border = Color3.fromRGB(255, 255, 255),
        Line = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(236, 238, 240),
        Muted = Color3.fromRGB(128, 133, 140),
        Faint = Color3.fromRGB(80, 84, 90),
        Accent = Color3.fromRGB(168, 186, 200),
        OnAccent = Color3.fromRGB(14, 15, 16),
        Success = Color3.fromRGB(122, 190, 142),
        Warning = Color3.fromRGB(216, 176, 106),
        Danger = Color3.fromRGB(214, 102, 102),
        ToggleOn = Color3.fromRGB(64, 196, 118),
        ToggleKnob = Color3.fromRGB(252, 253, 252),
        Info = Color3.fromRGB(130, 152, 190),
    },
    Moss = {
        Background = Color3.fromRGB(9, 12, 10),
        Surface = Color3.fromRGB(15, 19, 16),
        SurfaceAlt = Color3.fromRGB(20, 25, 21),
        Elevated = Color3.fromRGB(25, 31, 26),
        Border = Color3.fromRGB(255, 255, 255),
        Line = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(234, 240, 235),
        Muted = Color3.fromRGB(124, 138, 127),
        Faint = Color3.fromRGB(78, 90, 80),
        Accent = Color3.fromRGB(138, 190, 148),
        OnAccent = Color3.fromRGB(10, 16, 11),
        Success = Color3.fromRGB(138, 190, 148),
        Warning = Color3.fromRGB(216, 176, 106),
        Danger = Color3.fromRGB(214, 102, 102),
        ToggleOn = Color3.fromRGB(64, 196, 118),
        ToggleKnob = Color3.fromRGB(252, 253, 252),
        Info = Color3.fromRGB(130, 152, 190),
    },
    Paper = {
        Background = Color3.fromRGB(243, 243, 241),
        Surface = Color3.fromRGB(252, 252, 251),
        SurfaceAlt = Color3.fromRGB(246, 246, 244),
        Elevated = Color3.fromRGB(255, 255, 255),
        Border = Color3.fromRGB(0, 0, 0),
        Line = Color3.fromRGB(0, 0, 0),
        Text = Color3.fromRGB(24, 24, 26),
        Muted = Color3.fromRGB(112, 112, 118),
        Faint = Color3.fromRGB(168, 168, 172),
        Accent = Color3.fromRGB(126, 96, 48),
        OnAccent = Color3.fromRGB(252, 252, 251),
        Success = Color3.fromRGB(58, 132, 82),
        Warning = Color3.fromRGB(158, 116, 30),
        Danger = Color3.fromRGB(176, 56, 56),
        ToggleOn = Color3.fromRGB(64, 196, 118),
        ToggleKnob = Color3.fromRGB(252, 253, 252),
        Info = Color3.fromRGB(58, 96, 154),
    },
}

local METRICS = {
    Radius = 5,
    RadiusSm = 3,
    RowHeight = 36,
    Pad = 14,
    Gap = 8,
    RailWidth = 164,
    HeaderHeight = 48,
    FooterHeight = 24,
    BorderT = 0.90,
    LineT = 0.86,
    HoverT = 0.965,
    ScrollBar = 2,
}

local tokens = Util.merge(Util.copy(PALETTES.Violet), METRICS)
local activePalette = "Violet"

local bindings = {}
local liveCount = 0

local function apply(entry)
    local value = tokens[entry.token]
    if value == nil then
        return
    end
    local ok = pcall(function()
        entry.instance[entry.property] = value
    end)
    if not ok then
        entry.dead = true
    end
end

function Theme.tokens()
    return Util.copy(tokens)
end

function Theme.get(token, fallback)
    local value = tokens[token]
    if value == nil then
        if fallback ~= nil then
            return fallback
        end
        Log.warn("theme", "unknown token '" .. tostring(token) .. "'")
        return Color3.new(1, 0, 1)
    end
    return value
end

function Theme.color(token)
    local value = tokens[token]
    if typeof(value) == "Color3" then
        return value
    end
    Log.warn("theme", "token '" .. tostring(token) .. "' is not a colour")
    return Color3.new(1, 0, 1)
end

function Theme.number(token, fallback)
    local value = tokens[token]
    if type(value) == "number" then
        return value
    end
    return fallback or 0
end

function Theme.bind(instance, property, token)
    if typeof(instance) ~= "Instance" then
        Log.warn("theme", "bind expects an Instance")
        return nil
    end
    if tokens[token] == nil then
        Log.warn("theme", "bind to unknown token '" .. tostring(token) .. "'")
    end
    local entry = { instance = instance, property = property, token = token, dead = false }
    function entry:Destroy()
        Theme.unbind(self)
    end
    table.insert(bindings, entry)
    liveCount += 1
    apply(entry)
    return entry
end

function Theme.rebind(entry, token)
    if not entry or entry.dead then
        return
    end
    entry.token = token
    apply(entry)
end

function Theme.unbind(entry)
    if entry and not entry.dead then
        entry.dead = true
        liveCount -= 1
    end
end

local function compact()
    local kept = {}
    for _, entry in ipairs(bindings) do
        if not entry.dead then
            table.insert(kept, entry)
        end
    end
    bindings = kept
    liveCount = #kept
end

function Theme.Set(patch)
    if type(patch) ~= "table" then
        Log.warn("theme", "Set expects a table")
        return Theme
    end
    local changed = false
    for key, value in pairs(patch) do
        if tokens[key] == nil and METRICS[key] == nil then
            Log.warn("theme", "unknown token '" .. tostring(key) .. "' ignored")
        elseif typeof(value) ~= typeof(tokens[key]) then
            Log.field("theme", key, value, typeof(tokens[key]))
        else
            tokens[key] = value
            changed = true
        end
    end
    if not changed then
        return Theme
    end
    compact()
    for _, entry in ipairs(bindings) do
        apply(entry)
    end
    Theme.Changed:Fire(tokens)
    return Theme
end

function Theme.Preset(name)
    local palette = PALETTES[name]
    if not palette then
        Log.warn("theme", "unknown preset '" .. tostring(name) .. "'")
        return Theme
    end
    activePalette = name
    return Theme.Set(palette)
end

function Theme.Presets()
    local names = {}
    for name in pairs(PALETTES) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function Theme.Register(name, palette)
    if type(name) ~= "string" or type(palette) ~= "table" then
        Log.warn("theme", "Register expects (string, table)")
        return Theme
    end
    local merged = Util.copy(PALETTES.Violet)
    for key, value in pairs(palette) do
        if merged[key] ~= nil then
            merged[key] = value
        end
    end
    PALETTES[name] = merged
    return Theme
end

function Theme.Current()
    return activePalette
end

function Theme.stats()
    compact()
    return { bindings = liveCount, palette = activePalette }
end

return Theme

end
Slate_modules["core/Motion"] = function(require)
local TweenService = game:GetService("TweenService")
local Log = require("core/Log")

local Motion = {}

Motion.Duration = {
    Instant = 0,
    Fast = 0.09,
    Base = 0.15,
    Slow = 0.24,
    Lazy = 0.38,
}

local active = setmetatable({}, { __mode = "k" })
local watchers = setmetatable({}, { __mode = "k" })
local enabled = true
local running = 0

local function forget(instance)
    local record = active[instance]
    if record then
        for _, tween in pairs(record) do
            pcall(function()
                tween:Cancel()
            end)
            running -= 1
        end
    end
    active[instance] = nil
    local watcher = watchers[instance]
    if watcher then
        watcher:Disconnect()
        watchers[instance] = nil
    end
end

local function watch(instance)
    if watchers[instance] then
        return
    end
    local ok, connection = pcall(function()
        return instance.Destroying:Connect(function()
            forget(instance)
        end)
    end)
    if ok and connection then
        watchers[instance] = connection
    end
end

function Motion.setEnabled(state)
    enabled = state ~= false
end

function Motion.isEnabled()
    return enabled
end

function Motion.set(instance, props)
    if typeof(instance) ~= "Instance" then
        return
    end
    for property in pairs(props) do
        Motion.cancel(instance, property)
    end
    for property, value in pairs(props) do
        local ok = pcall(function()
            instance[property] = value
        end)
        if not ok then
            Log.warn("motion", "cannot set '" .. tostring(property) .. "'")
        end
    end
end

function Motion.play(instance, props, options)
    if typeof(instance) ~= "Instance" then
        Log.warn("motion", "play expects an Instance")
        return nil
    end
    options = options or {}
    local duration = options.duration or Motion.Duration.Base

    if not enabled or duration <= 0 then
        Motion.set(instance, props)
        if options.onDone then
            task.spawn(options.onDone, true)
        end
        return nil
    end

    for property in pairs(props) do
        Motion.cancel(instance, property)
    end

    local info = TweenInfo.new(
        duration,
        options.easing or Enum.EasingStyle.Quint,
        options.direction or Enum.EasingDirection.Out,
        0,
        false,
        options.delay or 0
    )

    local ok, tween = pcall(function()
        return TweenService:Create(instance, info, props)
    end)
    if not ok or not tween then
        Motion.set(instance, props)
        return nil
    end

    watch(instance)
    local record = active[instance]
    if not record then
        record = {}
        active[instance] = record
    end
    for property in pairs(props) do
        record[property] = tween
        running += 1
    end

    tween.Completed:Connect(function(state)
        local current = active[instance]
        if current then
            for property, candidate in pairs(current) do
                if candidate == tween then
                    current[property] = nil
                    running -= 1
                end
            end
            if next(current) == nil then
                active[instance] = nil
            end
        end
        tween:Destroy()
        if options.onDone then
            task.spawn(options.onDone, state == Enum.PlaybackState.Completed)
        end
    end)

    tween:Play()
    return tween
end

function Motion.cancel(instance, property)
    local record = active[instance]
    if not record then
        return
    end
    if property then
        local tween = record[property]
        if tween then
            pcall(function()
                tween:Cancel()
            end)
            for key, candidate in pairs(record) do
                if candidate == tween then
                    record[key] = nil
                    running -= 1
                end
            end
        end
        if next(record) == nil then
            active[instance] = nil
        end
        return
    end
    forget(instance)
end

function Motion.stop(instance)
    forget(instance)
end

function Motion.hover(instance, props)
    return Motion.play(instance, props, { duration = Motion.Duration.Fast, easing = Enum.EasingStyle.Sine })
end

function Motion.press(instance, props)
    return Motion.play(instance, props, { duration = 0.06, easing = Enum.EasingStyle.Sine })
end

function Motion.slide(instance, props, onDone)
    return Motion.play(instance, props, {
        duration = Motion.Duration.Base,
        easing = Enum.EasingStyle.Quint,
        onDone = onDone,
    })
end

function Motion.stats()
    local instances = 0
    for _ in pairs(active) do
        instances += 1
    end
    return { tweens = running, instances = instances, enabled = enabled }
end

return Motion

end
Slate_modules["core/Input"] = function(require)
local UserInputService = game:GetService("UserInputService")
local Signal = require("core/Signal")
local Util = require("core/Util")

local Input = {}

Input.KeyDown = Signal.new()
Input.KeyUp = Signal.new()
Input.PointerDown = Signal.new()
Input.PointerUp = Signal.new()
Input.PointerMoved = Signal.new()

local layers = {}
local hotkeys = {}
local captureHandler = nil
local pendingModifier = nil
local connections = {}

local POINTER_TYPES = {
    [Enum.UserInputType.MouseButton1] = true,
    [Enum.UserInputType.MouseButton2] = true,
    [Enum.UserInputType.Touch] = true,
}

local MODIFIER_KEYS = {
    [Enum.KeyCode.LeftShift] = "Shift",
    [Enum.KeyCode.RightShift] = "Shift",
    [Enum.KeyCode.LeftControl] = "Ctrl",
    [Enum.KeyCode.RightControl] = "Ctrl",
    [Enum.KeyCode.LeftAlt] = "Alt",
    [Enum.KeyCode.RightAlt] = "Alt",
}

function Input.isModifier(keyCode)
    return MODIFIER_KEYS[keyCode] ~= nil
end

function Input.modifiers()
    local held = {}
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
        table.insert(held, "Ctrl")
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
        table.insert(held, "Shift")
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftAlt) or UserInputService:IsKeyDown(Enum.KeyCode.RightAlt) then
        table.insert(held, "Alt")
    end
    return held
end

-- GetMouseLocation includes the topbar inset; InputObject.Position and every
-- GuiObject.AbsolutePosition do not. Everything below reports the latter space.
function Input.pointerPosition()
    local location = UserInputService:GetMouseLocation()
    local inset = Util.guiInset()
    return Vector2.new(location.X - inset.X, location.Y - inset.Y)
end

local function normalise(input)
    return Vector2.new(input.Position.X, input.Position.Y)
end

function Input.pushLayer(config)
    local layer = {
        contains = config.contains,
        dismiss = config.dismiss,
        onEscape = config.onEscape,
        modal = config.modal == true,
        id = Util.uid("layer"),
    }
    table.insert(layers, layer)
    return layer
end

function Input.popLayer(layer)
    if not layer then
        return
    end
    for index = #layers, 1, -1 do
        if layers[index] == layer then
            table.remove(layers, index)
            return
        end
    end
end

function Input.layerCount()
    return #layers
end

function Input.capture(handler)
    pendingModifier = nil
    captureHandler = handler
end

function Input.cancelCapture(handler)
    if handler == nil or captureHandler == handler then
        pendingModifier = nil
        captureHandler = nil
    end
end

function Input.isCapturing()
    return captureHandler ~= nil
end

function Input.bindHotkey(keyCode, handler)
    local entry = { key = keyCode, fn = handler, id = Util.uid("hotkey") }
    table.insert(hotkeys, entry)
    return entry
end

function Input.unbindHotkey(entry)
    Util.remove(hotkeys, entry)
end

local function handleDismiss(position)
    for index = #layers, 1, -1 do
        local layer = layers[index]
        local inside = true
        if type(layer.contains) == "function" then
            local ok, result = pcall(layer.contains, position)
            inside = ok and result == true
        end
        if inside then
            return
        end
        if type(layer.dismiss) == "function" then
            task.spawn(layer.dismiss)
        end
        if layer.modal then
            return
        end
    end
end

local function handleEscape()
    local layer = layers[#layers]
    if not layer then
        return false
    end
    if type(layer.onEscape) == "function" then
        task.spawn(layer.onEscape)
    elseif type(layer.dismiss) == "function" then
        task.spawn(layer.dismiss)
    end
    return true
end

table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if captureHandler then
        local handler = captureHandler
        -- a modifier only becomes the bind when it is released on its own
        if input.UserInputType == Enum.UserInputType.Keyboard and Input.isModifier(input.KeyCode) then
            pendingModifier = input
            return
        end
        pendingModifier = nil
        captureHandler = nil
        task.spawn(handler, input)
        return
    end

    if POINTER_TYPES[input.UserInputType] then
        local position = normalise(input)
        Input.PointerDown:Fire(position, input)
        handleDismiss(position)
        return
    end

    if input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    if input.KeyCode == Enum.KeyCode.Escape then
        if handleEscape() then
            return
        end
    end

    Input.KeyDown:Fire(input.KeyCode, processed, input)

    if processed then
        return
    end
    for _, entry in ipairs(table.clone(hotkeys)) do
        if entry.key == input.KeyCode then
            task.spawn(entry.fn)
        end
    end
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if captureHandler and pendingModifier and input.UserInputType == Enum.UserInputType.Keyboard
        and input.KeyCode == pendingModifier.KeyCode then
        local handler = captureHandler
        local held = pendingModifier
        pendingModifier = nil
        captureHandler = nil
        task.spawn(handler, held)
        return
    end
    if POINTER_TYPES[input.UserInputType] then
        Input.PointerUp:Fire(normalise(input), input)
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        Input.KeyUp:Fire(input.KeyCode, input)
    end
end))

table.insert(connections, UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        Input.PointerMoved:Fire(normalise(input), input)
    end
end))

function Input.describe(keyCode, mods)
    local name = typeof(keyCode) == "EnumItem" and keyCode.Name or tostring(keyCode)
    if name == "Unknown" or name == "nil" then
        return "None"
    end
    local shortcuts = {
        MouseButton1 = "M1",
        MouseButton2 = "M2",
        MouseButton3 = "M3",
        LeftShift = "Shift",
        RightShift = "RShift",
        LeftControl = "Ctrl",
        RightControl = "RCtrl",
        LeftAlt = "Alt",
        RightAlt = "RAlt",
    }
    name = shortcuts[name] or name
    if mods and #mods > 0 then
        return table.concat(mods, "+") .. "+" .. name
    end
    return name
end

function Input.shutdown()
    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    table.clear(connections)
    table.clear(layers)
    table.clear(hotkeys)
    captureHandler = nil
    Input.KeyDown:Destroy()
    Input.KeyUp:Destroy()
    Input.PointerDown:Destroy()
    Input.PointerUp:Destroy()
    Input.PointerMoved:Destroy()
end

function Input.stats()
    return { layers = #layers, hotkeys = #hotkeys, capturing = captureHandler ~= nil }
end

return Input

end
Slate_modules["core/Registry"] = function(require)
local Util = require("core/Util")
local Log = require("core/Log")
local Signal = require("core/Signal")

local Registry = {}

Registry.Changed = Signal.new()

local records = {}
local byId = {}

function Registry.add(element)
    local id = element.Id
    if byId[id] then
        Log.warn("registry", "duplicate id '" .. tostring(id) .. "'")
    end
    local record = {
        id = id,
        element = element,
        kind = element.Kind,
        flag = element.Flag,
    }
    byId[id] = record
    table.insert(records, record)
    return record
end

function Registry.remove(element)
    local record = byId[element.Id]
    if not record then
        return
    end
    byId[element.Id] = nil
    Util.remove(records, record)
end

function Registry.get(id)
    local record = byId[id]
    return record and record.element or nil
end

function Registry.byFlag(flag)
    for _, record in ipairs(records) do
        if record.flag == flag then
            return record.element
        end
    end
    return nil
end

function Registry.each(callback)
    for _, record in ipairs(table.clone(records)) do
        if not record.element.Destroyed then
            callback(record.element)
        end
    end
end

function Registry.search(query, filter)
    local needle = Util.normalise(query)
    local hits = {}
    for _, record in ipairs(records) do
        local element = record.element
        if not element.Destroyed and element.Searchable ~= false then
            if filter == nil or filter(element) then
                local haystack = table.concat({
                    element.Name or "",
                    element.Description or "",
                    element.Kind or "",
                    element:Path(),
                }, " ")
                if Util.matches(haystack, needle) then
                    table.insert(hits, element)
                end
            end
        end
    end
    return hits
end

function Registry.savable()
    local out = {}
    for _, record in ipairs(records) do
        local element = record.element
        if not element.Destroyed and element.Flag and element.Serialise then
            out[element.Flag] = element
        end
    end
    return out
end

function Registry.stats()
    local kinds = {}
    for _, record in ipairs(records) do
        kinds[record.kind] = (kinds[record.kind] or 0) + 1
    end
    return { total = #records, kinds = kinds }
end

return Registry

end
Slate_modules["core/Config"] = function(require)
local HttpService = game:GetService("HttpService")
local Util = require("core/Util")
local Log = require("core/Log")
local Signal = require("core/Signal")
local Registry = require("core/Registry")

local Config = {}
Config.__index = Config

local function fsCall(name)
    local fn = rawget(getfenv(), name)
    if type(fn) == "function" then
        return fn
    end
    local ok, value = pcall(function()
        return getgenv and getgenv()[name] or nil
    end)
    if ok and type(value) == "function" then
        return value
    end
    return nil
end

local FS = {
    write = fsCall("writefile"),
    read = fsCall("readfile"),
    isFile = fsCall("isfile"),
    delete = fsCall("delfile"),
    list = fsCall("listfiles"),
    isFolder = fsCall("isfolder"),
    makeFolder = fsCall("makefolder"),
}

local memory = {}
local memoryMeta = {}

function Config.new(options)
    options = options or {}
    local self = setmetatable({}, Config)
    self.Folder = Util.str(options.Folder, "SlateConfigs")
    self.Extension = ".json"
    self.Persistent = FS.write ~= nil and FS.read ~= nil
    self.Scope = options.Scope
    self.AutoSaveDelay = math.max(0.2, Util.num(options.AutoSaveDelay, 1.2))
    self.Saved = Signal.new()

    if self.Persistent and FS.makeFolder and FS.isFolder then
        local ok = pcall(function()
            if not FS.isFolder(self.Folder) then
                FS.makeFolder(self.Folder)
            end
        end)
        if not ok then
            self.Persistent = false
        end
    end
    if not self.Persistent then
        Log.warn("config", "no filesystem access, configs are session only")
    end

    if options.AutoLoad ~= nil then
        self:SetAutoLoad(options.AutoLoad == true)
    end
    if options.AutoSave ~= nil then
        self:SetAutoSave(options.AutoSave == true)
    end
    if options.Boot ~= false then
        task.defer(function()
            self:Boot()
        end)
    end
    return self
end

function Config:_path(name)
    return self.Folder .. "/" .. name .. self.Extension
end

function Config:_elements()
    local out = {}
    Registry.each(function(element)
        if element.Flag and element.Serialise then
            if not self.Scope or self.Scope(element) then
                out[element.Flag] = element
            end
        end
    end)
    return out
end

function Config:Collect()
    local payload = {}
    for flag, element in pairs(self:_elements()) do
        local ok, value = pcall(element.Serialise, element)
        if ok and value ~= nil then
            payload[flag] = { kind = element.Kind, value = value }
        end
    end
    return payload
end

function Config:Apply(payload)
    if type(payload) ~= "table" then
        return 0
    end
    local applied = 0
    local elements = self:_elements()
    for flag, record in pairs(payload) do
        local element = elements[flag]
        if element and type(record) == "table" then
            local ok, err = pcall(element.Deserialise, element, record.value)
            if ok then
                applied += 1
            else
                Log.error("config", err)
            end
        end
    end
    return applied
end

function Config:Save(name)
    name = Util.str(name, "default")
    local payload = self:Collect()
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode({ version = 1, saved = payload })
    end)
    if not ok then
        Log.error("config", encoded)
        return false, "encode failed"
    end
    if not self.Persistent then
        memory[name] = encoded
        return true
    end
    local written = pcall(FS.write, self:_path(name), encoded)
    if not written then
        return false, "write failed"
    end
    return true
end

function Config:Load(name)
    name = Util.str(name, "default")
    local raw
    if self.Persistent then
        if not FS.isFile or not FS.isFile(self:_path(name)) then
            return false, "not found"
        end
        local ok, contents = pcall(FS.read, self:_path(name))
        if not ok then
            return false, "read failed"
        end
        raw = contents
    else
        raw = memory[name]
        if not raw then
            return false, "not found"
        end
    end

    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(raw)
    end)
    if not ok or type(decoded) ~= "table" then
        Log.error("config", "corrupt config '" .. name .. "'")
        return false, "corrupt"
    end
    self._muted = true
    local applied = self:Apply(decoded.saved or decoded)
    self._muted = false
    self:SetActive(name)
    return true, applied
end

function Config:Delete(name)
    name = Util.str(name, "default")
    if not self.Persistent then
        memory[name] = nil
        return true
    end
    if not FS.delete then
        return false, "unsupported"
    end
    local ok = pcall(FS.delete, self:_path(name))
    return ok
end

function Config:Exists(name)
    name = Util.str(name, "default")
    if not self.Persistent then
        return memory[name] ~= nil
    end
    return FS.isFile ~= nil and FS.isFile(self:_path(name)) == true
end

function Config:GetList()
    local names = {}
    if not self.Persistent then
        for name in pairs(memory) do
            table.insert(names, name)
        end
    elseif FS.list then
        local ok, files = pcall(FS.list, self.Folder)
        if ok and type(files) == "table" then
            for _, path in ipairs(files) do
                local name = string.match(tostring(path), "([^/\\]+)%" .. self.Extension .. "$")
                if name then
                    table.insert(names, name)
                end
            end
        end
    end
    table.sort(names)
    return names
end


local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function encode64(text)
    local out = {}
    for index = 1, #text, 3 do
        local a, b, c = string.byte(text, index, index + 2)
        local block = a * 65536 + (b or 0) * 256 + (c or 0)
        local chars = {
            string.sub(B64, math.floor(block / 262144) % 64 + 1, math.floor(block / 262144) % 64 + 1),
            string.sub(B64, math.floor(block / 4096) % 64 + 1, math.floor(block / 4096) % 64 + 1),
            b and string.sub(B64, math.floor(block / 64) % 64 + 1, math.floor(block / 64) % 64 + 1) or "=",
            c and string.sub(B64, block % 64 + 1, block % 64 + 1) or "=",
        }
        table.insert(out, table.concat(chars))
    end
    return table.concat(out)
end

local function decode64(text)
    text = string.gsub(tostring(text), "[^%w%+/=]", "")
    local out = {}
    for index = 1, #text, 4 do
        local block, bits = 0, 0
        for offset = 0, 3 do
            local char = string.sub(text, index + offset, index + offset)
            if char ~= "" and char ~= "=" then
                local at = string.find(B64, char, 1, true)
                if not at then
                    return nil
                end
                block = block * 64 + (at - 1)
                bits += 1
            else
                block = block * 64
            end
        end
        local bytes = { math.floor(block / 65536) % 256, math.floor(block / 256) % 256, block % 256 }
        for byte = 1, bits - 1 do
            table.insert(out, string.char(bytes[byte]))
        end
    end
    return table.concat(out)
end

function Config:_metaPath()
    return self.Folder .. "/_slate" .. self.Extension
end

function Config:_readMeta()
    if self._meta then
        return self._meta
    end
    local meta = { active = nil, autoLoad = false, autoSave = false }
    if self.Persistent and FS.isFile and FS.isFile(self:_metaPath()) then
        local ok, raw = pcall(FS.read, self:_metaPath())
        if ok then
            local decoded, value = pcall(function()
                return HttpService:JSONDecode(raw)
            end)
            if decoded and type(value) == "table" then
                meta.active = type(value.active) == "string" and value.active or nil
                meta.autoLoad = value.autoLoad == true
                meta.autoSave = value.autoSave == true
            end
        end
    else
        meta = memoryMeta[self.Folder] or meta
    end
    self._meta = meta
    return meta
end

function Config:_writeMeta()
    local meta = self:_readMeta()
    memoryMeta[self.Folder] = meta
    if not self.Persistent or not FS.write then
        return
    end
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(meta)
    end)
    if ok then
        pcall(FS.write, self:_metaPath(), encoded)
    end
end

function Config:GetActive()
    return self:_readMeta().active
end

function Config:SetActive(name)
    local meta = self:_readMeta()
    meta.active = name and Util.str(name, nil) or nil
    self:_writeMeta()
    return self
end

function Config:GetAutoLoad()
    return self:_readMeta().autoLoad == true
end

function Config:SetAutoLoad(state)
    local meta = self:_readMeta()
    meta.autoLoad = state == true
    self:_writeMeta()
    return self
end

function Config:GetAutoSave()
    return self:_readMeta().autoSave == true
end

function Config:_flush()
    local name = self:GetActive()
    if not name then
        return
    end
    local ok = self:Save(name)
    if ok then
        self.Saved:Fire(name, true)
    end
end

function Config:SetAutoSave(state, delay)
    local meta = self:_readMeta()
    meta.autoSave = state == true
    self.AutoSaveDelay = math.max(0.2, Util.num(delay, self.AutoSaveDelay or 1.2))
    self:_writeMeta()

    if meta.autoSave then
        if not self._watch then
            self._watch = Registry.Changed:Connect(function()
                if not self:GetAutoSave() or self._muted then
                    return
                end
                if self._pending then
                    task.cancel(self._pending)
                end
                self._pending = task.delay(self.AutoSaveDelay, function()
                    self._pending = nil
                    self:_flush()
                end)
            end)
        end
    elseif self._watch then
        self._watch.Disconnect()
        self._watch = nil
        if self._pending then
            task.cancel(self._pending)
            self._pending = nil
        end
    end
    return self
end

function Config:Boot()
    if not self:GetAutoLoad() then
        if self:GetAutoSave() then
            self:SetAutoSave(true)
        end
        return false
    end
    local name = self:GetActive()
    if not name or not self:Exists(name) then
        return false
    end
    local ok, applied = self:Load(name)
    if self:GetAutoSave() then
        self:SetAutoSave(true)
    end
    return ok, applied
end

function Config:Share(name)
    local raw
    if name and self:Exists(name) then
        if self.Persistent then
            local ok, contents = pcall(FS.read, self:_path(name))
            raw = ok and contents or nil
        else
            raw = memory[name]
        end
    end
    if not raw then
        raw = self:Export(name)
    end
    if not raw then
        return nil
    end
    return "SLATE1:" .. encode64(raw)
end

function Config:Receive(text)
    local body = string.match(tostring(text), "^SLATE1:(.+)$")
    if body then
        local decoded = decode64(body)
        if not decoded then
            return false, "corrupt"
        end
        return self:Import(decoded)
    end
    return self:Import(text)
end

function Config:Copy(name)
    local payload = self:Share(name)
    if not payload then
        return false, "nothing to share"
    end
    local clip = fsCall("setclipboard") or fsCall("toclipboard")
    if not clip then
        return false, payload
    end
    local ok = pcall(clip, payload)
    return ok, payload
end

function Config:Paste()
    local clip = fsCall("getclipboard")
    if not clip then
        return false, "no clipboard access"
    end
    local ok, text = pcall(clip)
    if not ok or type(text) ~= "string" or text == "" then
        return false, "clipboard empty"
    end
    return self:Receive(text)
end

function Config:Destroy()
    if self._watch then
        self._watch.Disconnect()
        self._watch = nil
    end
    if self._pending then
        task.cancel(self._pending)
        self._pending = nil
    end
    self.Saved:Destroy()
end

function Config:Export(name)
    name = Util.str(name, "default")
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode({ version = 1, saved = self:Collect() })
    end)
    return ok and encoded or nil
end

function Config:Import(raw)
    local ok, decoded = pcall(function()
        return HttpService:JSONDecode(tostring(raw))
    end)
    if not ok or type(decoded) ~= "table" then
        return false, "corrupt"
    end
    return true, self:Apply(decoded.saved or decoded)
end

return Config

end
Slate_modules["ui/Primitives"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Signal = require("core/Signal")
local Log = require("core/Log")

local P = {}

local FONT_ROOT = "rbxasset://fonts/families/"
local EXTRA_FAMILIES = { "Montserrat" }

local familyList = nil

local function shortName(value)
    if type(value) ~= "string" then
        return nil
    end
    return string.match(value, "families/(.+)%.json") or value
end

local function families()
    if familyList then
        return familyList
    end
    local seen, list = {}, {}
    pcall(function()
        for _, item in ipairs(Enum.Font:GetEnumItems()) do
            local ok, font = pcall(Font.fromEnum, item)
            if ok and font then
                local name = shortName(font.Family)
                if name and not seen[name] then
                    seen[name] = true
                    table.insert(list, name)
                end
            end
        end
    end)
    for _, name in ipairs(EXTRA_FAMILIES) do
        if not seen[name] then
            seen[name] = true
            table.insert(list, name)
        end
    end
    if #list == 0 then
        list = { "Roboto", "RobotoMono", "SourceSansPro" }
    end
    table.sort(list)
    familyList = list
    return list
end

local function makeFont(family, weight, style)
    local ok, font = pcall(function()
        return Font.new(FONT_ROOT .. family .. ".json", weight, style or Enum.FontStyle.Normal)
    end)
    if ok and font then
        return font
    end
    return Font.fromEnum(Enum.Font.GothamBold)
end

local SLOTS = { Sans = "Roboto", Mono = "RobotoMono", Display = "Montserrat" }

local ROLES = {
    { role = "Regular", slot = "Sans", weight = Enum.FontWeight.Regular },
    { role = "Medium", slot = "Sans", weight = Enum.FontWeight.Medium },
    { role = "Bold", slot = "Sans", weight = Enum.FontWeight.SemiBold },
    { role = "Mono", slot = "Mono", weight = Enum.FontWeight.Regular },
    { role = "Display", slot = "Display", weight = Enum.FontWeight.Heavy, style = Enum.FontStyle.Italic },
}

P.Font = {}
for _, spec in ipairs(ROLES) do
    P.Font[spec.role] = makeFont(SLOTS[spec.slot], spec.weight, spec.style)
end

P.FontChanged = Signal.new()

P.Size = {
    Micro = 10,
    Small = 11,
    Body = 12,
    Label = 13,
    Title = 14,
    Head = 16,
}

local roots = setmetatable({}, { __mode = "k" })

function P.trackRoot(instance)
    if typeof(instance) == "Instance" then
        roots[instance] = true
    end
    return instance
end

function P.untrackRoot(instance)
    if typeof(instance) == "Instance" then
        roots[instance] = nil
    end
end

local function sameFont(a, b)
    if typeof(a) ~= "Font" or typeof(b) ~= "Font" then
        return false
    end
    return a.Family == b.Family and a.Weight == b.Weight and a.Style == b.Style
end

local function repaintFonts(swaps)
    for root in pairs(roots) do
        pcall(function()
            if not root.Parent then
                return
            end
            for _, node in ipairs(root:GetDescendants()) do
                if (node:IsA("TextLabel") or node:IsA("TextBox") or node:IsA("TextButton"))
                    and node:GetAttribute("SlateFontLocked") ~= true then
                    for _, swap in ipairs(swaps) do
                        if sameFont(node.FontFace, swap.old) then
                            node.FontFace = swap.new
                            break
                        end
                    end
                end
            end
        end)
    end
end

function P.lockFont(instance, font)
    if typeof(instance) ~= "Instance" then
        return instance
    end
    if font then
        instance.FontFace = font
        instance:SetAttribute("SlateFontLocked", true)
    else
        instance:SetAttribute("SlateFontLocked", nil)
    end
    return instance
end

function P.fontFor(family, weight, style)
    local name = shortName(family)
    if type(name) ~= "string" or name == "" then
        return P.Font.Regular
    end
    return makeFont(name, weight or Enum.FontWeight.Regular, style)
end

function P.families()
    return Util.list(families())
end

function P.hasFamily(name)
    local needle = shortName(name)
    if not needle then
        return false
    end
    for _, candidate in ipairs(families()) do
        if candidate == needle then
            return true
        end
    end
    return false
end

function P.family(slot)
    return SLOTS[slot or "Sans"]
end

function P.slots()
    return { Sans = SLOTS.Sans, Mono = SLOTS.Mono, Display = SLOTS.Display }
end

function P.setSlot(slot, name)
    if SLOTS[slot] == nil then
        Log.warn("primitives", "unknown font slot '" .. tostring(slot) .. "'")
        return false
    end
    local family = shortName(name)
    if type(family) ~= "string" or family == "" then
        return false
    end
    if not P.hasFamily(family) then
        Log.warn("primitives", "font family '" .. family .. "' is not available")
        return false
    end
    if SLOTS[slot] == family then
        return false
    end
    SLOTS[slot] = family

    local swaps = {}
    for _, spec in ipairs(ROLES) do
        if spec.slot == slot then
            local old = P.Font[spec.role]
            local fresh = makeFont(family, spec.weight, spec.style)
            if not sameFont(old, fresh) then
                P.Font[spec.role] = fresh
                table.insert(swaps, { old = old, new = fresh })
            end
        end
    end
    if #swaps == 0 then
        return false
    end
    repaintFonts(swaps)
    P.FontChanged:Fire(slot, family)
    return true
end

function P.setFamily(sans, mono)
    local changed = false
    if sans ~= nil then
        changed = P.setSlot("Sans", sans) or changed
    end
    if mono ~= nil then
        changed = P.setSlot("Mono", mono) or changed
    end
    return changed
end

function P.frame(props, children)
    local defaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
    }
    for key, value in pairs(props or {}) do
        defaults[key] = value
    end
    return Util.new("Frame", defaults, children)
end

function P.canvas(props, children)
    local defaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ClipsDescendants = true,
    }
    for key, value in pairs(props or {}) do
        defaults[key] = value
    end
    return Util.new("CanvasGroup", defaults, children)
end

function P.text(props, children)
    local defaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        FontFace = P.Font.Regular,
        TextSize = P.Size.Body,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        RichText = false,
        Text = "",
    }
    for key, value in pairs(props or {}) do
        defaults[key] = value
    end
    return Util.new("TextLabel", defaults, children)
end

function P.image(props, children)
    local defaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScaleType = Enum.ScaleType.Fit,
    }
    for key, value in pairs(props or {}) do
        defaults[key] = value
    end
    return Util.new("ImageLabel", defaults, children)
end

function P.hitbox(props)
    local defaults = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        Size = UDim2.fromScale(1, 1),
        ZIndex = 5,
    }
    for key, value in pairs(props or {}) do
        defaults[key] = value
    end
    return Util.new("TextButton", defaults)
end

function P.corner(parent, radius)
    return Util.new("UICorner", {
        CornerRadius = UDim.new(0, radius or Theme.number("Radius", 5)),
        Parent = parent,
    })
end

function P.stroke(parent, token, thickness, transparency)
    local stroke = Util.new("UIStroke", {
        Thickness = thickness or 1,
        Transparency = transparency or Theme.number("BorderT", 0.9),
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
    local binding = Theme.bind(stroke, "Color", token or "Border")
    return stroke, binding
end

function P.pad(parent, top, right, bottom, left)
    return Util.new("UIPadding", {
        PaddingTop = UDim.new(0, top or 0),
        PaddingRight = UDim.new(0, right or top or 0),
        PaddingBottom = UDim.new(0, bottom or top or 0),
        PaddingLeft = UDim.new(0, left or right or top or 0),
        Parent = parent,
    })
end

function P.list(parent, options)
    options = options or {}
    return Util.new("UIListLayout", {
        FillDirection = options.horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
        Padding = UDim.new(0, options.gap or 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = options.align or Enum.HorizontalAlignment.Left,
        VerticalAlignment = options.valign or Enum.VerticalAlignment.Top,
        Parent = parent,
    })
end

function P.hairline(parent, options)
    options = options or {}
    local line = P.frame({
        Name = "Hairline",
        BackgroundTransparency = options.transparency or Theme.number("LineT", 0.94),
        Size = options.vertical and UDim2.new(0, 1, 1, 0) or UDim2.new(1, 0, 0, 1),
        Position = options.position or UDim2.fromScale(0, 1),
        AnchorPoint = options.anchor or Vector2.new(0, 1),
        ZIndex = options.zindex or 2,
        Parent = parent,
    })
    local binding = Theme.bind(line, "BackgroundColor3", options.token or "Line")

    if options.fade then
        local edge = options.edge or 0.28
        Util.new("UIGradient", {
            Rotation = options.vertical and 90 or 0,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(edge, 0),
                NumberSequenceKeypoint.new(1 - edge, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = line,
        })
    end

    return line, binding
end

function P.glow(parent, options)
    options = options or {}
    local glow = P.frame({
        Name = "Glow",
        BackgroundTransparency = 1,
        Size = options.size or UDim2.new(1, 0, 0, 3),
        Position = options.position or UDim2.new(0, 0, 1, 0),
        AnchorPoint = options.anchor or Vector2.new(0, 1),
        ZIndex = options.zindex or 1,
        Parent = parent,
    })
    local binding = Theme.bind(glow, "BackgroundColor3", options.token or "Accent")
    Util.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.22, 0.55),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(0.78, 0.55),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = glow,
    })
    return glow, binding
end

local function hex(colour)
    return string.format("#%02X%02X%02X",
        math.round(colour.R * 255), math.round(colour.G * 255), math.round(colour.B * 255))
end

function P.logo(parent, options)
    options = options or {}
    local text = tostring(options.text or "Slate")
    local size = options.size or 20
    local depth = math.max(0, math.floor(options.depth or 4))
    local step = options.step or 1
    local split = options.accentFrom
    if split == nil then
        split = #text
    end
    split = math.clamp(split, 1, #text + 1)

    local container = P.frame({
        Name = "Logo",
        Size = options.frameSize or UDim2.new(1, 0, 0, size + 6),
        Position = options.position or UDim2.fromOffset(0, 0),
        Parent = parent,
    })

    local bindings = {}

    for index = depth, 1, -1 do
        local layer = P.text({
            Name = "Depth" .. index,
            Size = UDim2.fromScale(1, 1),
            Position = UDim2.fromOffset(index * step, index * step),
            Text = text,
            TextSize = size,
            FontFace = P.Font.Display,
            TextXAlignment = options.align or Enum.TextXAlignment.Left,
            TextTransparency = 0.18 + (index / (depth + 1)) * 0.62,
            ZIndex = 1,
            Parent = container,
        })
        table.insert(bindings, Theme.bind(layer, "TextColor3", options.shadowToken or "Background"))
    end

    local head = string.sub(text, 1, split - 1)
    local tail = string.sub(text, split)

    local face = P.text({
        Name = "Face",
        Size = UDim2.fromScale(1, 1),
        Text = text,
        TextSize = size,
        FontFace = P.Font.Display,
        TextXAlignment = options.align or Enum.TextXAlignment.Left,
        RichText = tail ~= "",
        ZIndex = 3,
        Parent = container,
    })
    table.insert(bindings, Theme.bind(face, "TextColor3", options.token or "Text"))

    if tail == "" then
        return container, bindings, nil
    end

    local function repaint()
        face.Text = head .. '<font color="' .. hex(Theme.color(options.accentToken or "Accent")) .. '">'
            .. tail .. "</font>"
    end
    repaint()

    local connection = Theme.Changed:Connect(repaint)

    return container, bindings, connection
end

P.emboss = P.logo

P.FieldHeight = 24
P.FieldRadius = 6
P.FieldPad = 8

local FIELD_REST = 0.45
local FIELD_HOVER = 0.3
local FIELD_ACTIVE = 0.22

function P.field(parent, options)
    options = options or {}
    local frame = P.frame({
        Name = options.name or "Field",
        AnchorPoint = options.anchor or Vector2.new(1, 0.5),
        Position = options.position or UDim2.new(1, 0, 0.5, 0),
        Size = options.size or UDim2.new(1, 0, 0, P.FieldHeight),
        BackgroundTransparency = FIELD_REST,
        Parent = parent,
    })
    P.corner(frame, options.radius or P.FieldRadius)
    local fill = Theme.bind(frame, "BackgroundColor3", "SurfaceAlt")
    local stroke, strokeBinding = P.stroke(frame, "Border", 1, Theme.number("BorderT", 0.9))

    local state = { hovered = false, active = false, invalid = false }

    local function paint(animate)
        local duration = animate == false and 0 or Motion.Duration.Fast
        local border = Theme.number("BorderT", 0.9)
        Theme.rebind(strokeBinding, state.invalid and "Danger" or (state.active and "Accent" or "Border"))
        Motion.play(frame, {
            BackgroundTransparency = state.active and FIELD_ACTIVE
                or (state.hovered and FIELD_HOVER or FIELD_REST),
        }, { duration = duration, easing = Enum.EasingStyle.Sine })
        Motion.play(stroke, {
            Transparency = (state.active or state.invalid) and 0.3
                or (state.hovered and (border - 0.28) or border),
        }, { duration = duration })
    end
    paint(false)

    local handle = { frame = frame, stroke = stroke, state = state, paint = paint }

    function handle.set(key, value)
        local target = value == true
        if state[key] == target then
            return
        end
        state[key] = target
        paint(true)
    end

    function handle.Destroy()
        Theme.unbind(fill)
        Theme.unbind(strokeBinding)
    end

    return frame, handle
end

function P.surface(props, children)
    local frame = P.frame(props, children)
    frame.BackgroundTransparency = props and props.BackgroundTransparency or 0
    local binding = Theme.bind(frame, "BackgroundColor3", (props and props.Token) or "Surface")
    return frame, binding
end

local HOVER_DEFAULT = { duration = Motion.Duration.Fast, easing = Enum.EasingStyle.Sine }

function P.interactive(button, config)
    if typeof(button) ~= "Instance" then
        Log.warn("primitives", "interactive expects a button")
        return function() end
    end
    config = config or {}
    local state = { hovered = false, pressed = false, disabled = false }
    local connections = {}

    local function refresh()
        if config.render then
            config.render(state)
        end
    end

    local function set(key, value)
        if state[key] == value then
            return
        end
        state[key] = value
        refresh()
    end

    table.insert(connections, button.MouseEnter:Connect(function()
        if state.disabled then
            return
        end
        set("hovered", true)
        if config.onEnter then
            config.onEnter()
        end
    end))
    table.insert(connections, button.MouseLeave:Connect(function()
        set("pressed", false)
        set("hovered", false)
        if config.onLeave then
            config.onLeave()
        end
    end))
    table.insert(connections, button.MouseButton1Down:Connect(function()
        if state.disabled then
            return
        end
        set("pressed", true)
    end))
    table.insert(connections, button.MouseButton1Up:Connect(function()
        set("pressed", false)
    end))
    if config.onClick then
        table.insert(connections, button.MouseButton1Click:Connect(function()
            if state.disabled then
                return
            end
            config.onClick()
        end))
    end
    if config.onRightClick then
        table.insert(connections, button.MouseButton2Click:Connect(function()
            if state.disabled then
                return
            end
            config.onRightClick()
        end))
    end

    refresh()

    local handle = {}
    function handle.setDisabled(value)
        set("disabled", value == true)
        if value then
            set("hovered", false)
            set("pressed", false)
        end
    end
    function handle.state()
        return state
    end
    function handle.refresh()
        refresh()
    end
    function handle.Destroy()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        table.clear(connections)
    end
    return handle
end

function P.fade(instance, transparency, duration)
    Motion.play(instance, { BackgroundTransparency = transparency }, {
        duration = duration or HOVER_DEFAULT.duration,
        easing = Enum.EasingStyle.Sine,
    })
end

function P.autowrap(label, options)
    options = options or {}
    local host = options.host or label.Parent
    local inset = options.inset or 0
    local minimum = options.minimum or (label.TextSize + 4)

    label.AutomaticSize = Enum.AutomaticSize.None
    label.TextWrapped = true

    local function refresh()
        if not label.Parent or not host or not host.Parent then
            return
        end
        local width = host.AbsoluteSize.X - inset
        if width <= 0 then
            return
        end
        local bounds = P.measure(label.Text, label.FontFace, label.TextSize, width)
        local height = math.max(minimum, math.ceil(bounds.Y) + 4)
        if math.abs(label.Size.Y.Offset - height) < 1 then
            return
        end
        label.Size = UDim2.new(label.Size.X.Scale, label.Size.X.Offset, 0, height)
        if options.onChange then
            options.onChange(height)
        end
    end

    local connections = {
        host:GetPropertyChangedSignal("AbsoluteSize"):Connect(refresh),
        label:GetPropertyChangedSignal("Text"):Connect(refresh),
        P.FontChanged:Connect(refresh),
    }
    task.defer(refresh)

    local handle = {}
    handle.Refresh = refresh
    function handle.Destroy()
        for _, connection in ipairs(connections) do
            connection:Disconnect()
        end
        table.clear(connections)
    end
    return handle
end

function P.measure(text, font, size, width)
    local service = game:GetService("TextService")
    local ok, result = pcall(function()
        local params = Instance.new("GetTextBoundsParams")
        params.Text = text
        params.Font = font
        params.Size = size
        params.Width = width or math.huge
        return service:GetTextBoundsAsync(params)
    end)
    if ok and result then
        return result
    end
    return Vector2.new(#tostring(text) * size * 0.5, size)
end

return P

end
Slate_modules["ui/Icons"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Log = require("core/Log")
local P = require("ui/Primitives")

local Icons = {}

local packs = {}
local packOrder = {}

local SOURCES = {
    lucide = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/lucide/dist/Icons.lua",
    gravity = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/gravity/dist/Icons.lua",
    solar = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/solar/dist/Icons.lua",
    sfsymbols = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/sfsymbols/dist/Icons.lua",
    craft = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/craft/dist/Icons.lua",
    geist = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/geist/dist/Icons.lua",
    hero = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/hero/dist/Icons.lua",
    gmi = "https://raw.githubusercontent.com/StyearX/Icons/refs/heads/main/GoogleMaterialIcons/dist/Icons.lua",
}

local maps = {}
local defaultPack = "lucide"
local fallbackPacks = { "lucide" }
local VARIANTS = {
    solar = { "", "-bold", "-linear", "-outline", "-broken" },
}

local function lookup(map, name, packName)
    if not map then
        return nil
    end
    local hit = map[name]
    if hit then
        return hit
    end
    for _, suffix in ipairs(VARIANTS[packName] or {}) do
        if suffix ~= "" then
            hit = map[name .. suffix]
            if hit then
                return hit
            end
        end
    end
    return nil
end

local function loadPack(name)
    local cached = maps[name]
    if cached ~= nil then
        return cached or nil
    end
    local url = SOURCES[name]
    if not url then
        maps[name] = false
        return nil
    end
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok or type(body) ~= "string" then
        Log.warn("icons", "could not fetch pack '" .. name .. "'")
        maps[name] = false
        return nil
    end
    local chunk = loadstring(body)
    if not chunk then
        maps[name] = false
        return nil
    end
    local built, map = pcall(chunk)
    if not built or type(map) ~= "table" then
        maps[name] = false
        return nil
    end
    maps[name] = map
    return map
end

function Icons.sources()
    local names = {}
    for name in pairs(SOURCES) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function Icons.setPack(name)
    if SOURCES[name] or packs[name] then
        defaultPack = name
        return true
    end
    Log.warn("icons", "unknown pack '" .. tostring(name) .. "'")
    return false
end

function Icons.pack()
    return defaultPack
end

function Icons.setFallbacks(list)
    fallbackPacks = Util.list(list)
    return true
end

function Icons.preload(names)
    for _, name in ipairs(names or { defaultPack }) do
        loadPack(name)
    end
end

function Icons.addSource(name, url)
    if type(name) == "string" and type(url) == "string" then
        SOURCES[name] = url
        maps[name] = nil
    end
end

local BAR = 1.6

local function bar(length, x, y, rotation, thickness)
    return { kind = "bar", length = length, x = x, y = y, rotation = rotation or 0, thickness = thickness }
end

local function ring(radius, x, y, thickness)
    return { kind = "ring", radius = radius, x = x, y = y, thickness = thickness or BAR }
end

local function disc(radius, x, y)
    return { kind = "disc", radius = radius, x = x, y = y }
end

local function spokes(count, inner, outer, x, y, thickness)
    local parts = {}
    for index = 0, count - 1 do
        local angle = (index / count) * math.pi * 2
        local mid = (inner + outer) / 2
        table.insert(parts, bar(
            outer - inner,
            x + math.cos(angle) * mid,
            y + math.sin(angle) * mid,
            math.deg(angle),
            thickness
        ))
    end
    return parts
end

local function polygon(sides, radius, x, y, rotation, thickness)
    local parts = {}
    local side = 2 * radius * math.sin(math.pi / sides)
    local apothem = radius * math.cos(math.pi / sides)
    for index = 0, sides - 1 do
        local angle = (index / sides) * math.pi * 2 + math.rad(rotation or 0)
        table.insert(parts, bar(
            side,
            x + math.cos(angle) * apothem,
            y + math.sin(angle) * apothem,
            math.deg(angle) + 90,
            thickness
        ))
    end
    return parts
end

local function merge(...)
    local out = {}
    for _, group in ipairs({ ... }) do
        for _, part in ipairs(group) do
            table.insert(out, part)
        end
    end
    return out
end

local GLYPHS = {
    ["chevron-down"] = { bar(0.38, 0.355, 0.53, 45), bar(0.38, 0.645, 0.53, -45) },
    ["chevron-up"] = { bar(0.38, 0.355, 0.47, -45), bar(0.38, 0.645, 0.47, 45) },
    ["chevron-right"] = { bar(0.38, 0.47, 0.355, -45), bar(0.38, 0.47, 0.645, 45) },
    ["chevron-left"] = { bar(0.38, 0.53, 0.355, 45), bar(0.38, 0.53, 0.645, -45) },
    ["check"] = { bar(0.30, 0.33, 0.62, 45), bar(0.58, 0.60, 0.45, -45) },
    ["close"] = { bar(0.58, 0.5, 0.5, 45), bar(0.58, 0.5, 0.5, -45) },
    ["plus"] = { bar(0.56, 0.5, 0.5, 0), bar(0.56, 0.5, 0.5, 90) },
    ["minus"] = { bar(0.56, 0.5, 0.5, 0) },
    ["search"] = { ring(0.28, 0.43, 0.43), bar(0.26, 0.72, 0.72, 45) },
    ["dot"] = { disc(0.14, 0.5, 0.5) },
    ["circle"] = { ring(0.34, 0.5, 0.5) },
    ["grip"] = { bar(0.5, 0.5, 0.38, 0), bar(0.5, 0.5, 0.62, 0) },
    ["arrow-right"] = { bar(0.54, 0.48, 0.5, 0), bar(0.26, 0.68, 0.37, -45), bar(0.26, 0.68, 0.63, 45) },
    ["lock"] = {
        ring(0.18, 0.5, 0.32),
        bar(0.40, 0.5, 0.52, 0), bar(0.40, 0.5, 0.80, 0),
        bar(0.28, 0.30, 0.66, 90), bar(0.28, 0.70, 0.66, 90),
    },
    ["sliders"] = { bar(0.62, 0.5, 0.34, 0), bar(0.62, 0.5, 0.66, 0), disc(0.09, 0.66, 0.34), disc(0.09, 0.36, 0.66) },
    ["layers"] = { bar(0.52, 0.5, 0.32, 0), bar(0.52, 0.5, 0.5, 0), bar(0.52, 0.5, 0.68, 0) },
    ["home"] = {
        bar(0.42, 0.35, 0.35, 42), bar(0.42, 0.65, 0.35, -42),
        bar(0.36, 0.24, 0.62, 90), bar(0.36, 0.76, 0.62, 90),
        bar(0.54, 0.5, 0.79, 0),
    },
    ["user"] = {
        ring(0.17, 0.5, 0.30),
        bar(0.40, 0.5, 0.78, 0),
        bar(0.26, 0.28, 0.66, 62), bar(0.26, 0.72, 0.66, -62),
    },
    ["eye"] = {
        ring(0.15, 0.5, 0.5),
        bar(0.34, 0.5, 0.29, 0), bar(0.34, 0.5, 0.71, 0),
        bar(0.30, 0.20, 0.5, 90), bar(0.30, 0.80, 0.5, 90),
    },
    ["target"] = { ring(0.34, 0.5, 0.5), ring(0.17, 0.5, 0.5), disc(0.06, 0.5, 0.5) },
    ["globe"] = { ring(0.34, 0.5, 0.5), bar(0.66, 0.5, 0.5, 0), ring(0.15, 0.5, 0.5) },
    ["shield"] = {
        bar(0.44, 0.5, 0.22, 0),
        bar(0.34, 0.28, 0.40, 90), bar(0.34, 0.72, 0.40, 90),
        bar(0.36, 0.37, 0.66, 50), bar(0.36, 0.63, 0.66, -50),
    },
    ["crown"] = {
        bar(0.48, 0.5, 0.74, 0),
        bar(0.36, 0.27, 0.52, 76), bar(0.36, 0.73, 0.52, -76),
        bar(0.32, 0.39, 0.42, -52), bar(0.32, 0.61, 0.42, 52),
    },
    ["zap"] = { bar(0.38, 0.43, 0.33, 66), bar(0.26, 0.5, 0.5, 8), bar(0.38, 0.57, 0.67, 66) },
    ["sun"] = merge({ disc(0.14, 0.5, 0.5) }, spokes(8, 0.26, 0.40, 0.5, 0.5, 1.4)),
    ["refresh"] = { ring(0.30, 0.5, 0.5), bar(0.22, 0.71, 0.29, 45), bar(0.22, 0.29, 0.71, 45) },
    ["settings"] = merge({ ring(0.16, 0.5, 0.5) }, spokes(6, 0.23, 0.38, 0.5, 0.5, 1.6)),
    ["hexagon"] = polygon(6, 0.36, 0.5, 0.5, 90),
    ["box"] = polygon(4, 0.34, 0.5, 0.5, 45),
    ["heart"] = { ring(0.15, 0.37, 0.38), ring(0.15, 0.63, 0.38), bar(0.34, 0.36, 0.62, 50), bar(0.34, 0.64, 0.62, -50) },
    ["bell"] = { ring(0.22, 0.5, 0.42), bar(0.48, 0.5, 0.66, 0), disc(0.07, 0.5, 0.79) },
    ["sword"] = { bar(0.62, 0.55, 0.45, 45), bar(0.22, 0.28, 0.72, -45), bar(0.18, 0.34, 0.80, 45) },
}

function Icons.names()
    local out = {}
    for name in pairs(GLYPHS) do
        table.insert(out, name)
    end
    table.sort(out)
    return out
end

function Icons.registerPack(name, resolver)
    if type(name) ~= "string" or type(resolver) ~= "function" then
        Log.warn("icons", "registerPack expects (string, function)")
        return
    end
    if not packs[name] then
        table.insert(packOrder, name)
    end
    packs[name] = resolver
end

function Icons.registerGlyph(name, parts)
    if type(name) ~= "string" or type(parts) ~= "table" then
        Log.warn("icons", "registerGlyph expects (string, table)")
        return
    end
    GLYPHS[name] = parts
end

local function resolveImage(name)
    if type(name) ~= "string" then
        return nil
    end
    if string.match(name, "^rbxassetid://") or string.match(name, "^rbxasset://") or string.match(name, "^http") then
        return name
    end
    if string.match(name, "^%d+$") then
        return "rbxassetid://" .. name
    end
    local packName, iconName = string.match(name, "^([%w_]+):(.+)$")
    if packName then
        if packs[packName] then
            local ok, result = pcall(packs[packName], iconName)
            if ok and type(result) == "string" and result ~= "" then
                return result
            end
            return nil
        end
        local map = loadPack(packName)
        return lookup(map, iconName, packName)
    end

    for _, key in ipairs(packOrder) do
        local ok, result = pcall(packs[key], name)
        if ok and type(result) == "string" and result ~= "" then
            return result
        end
    end

    local hit = lookup(loadPack(defaultPack), name, defaultPack)
    if hit then
        return hit
    end
    for _, packName in ipairs(fallbackPacks) do
        if packName ~= defaultPack then
            hit = lookup(loadPack(packName), name, packName)
            if hit then
                return hit
            end
        end
    end
    return nil
end

local function buildGlyph(parts, box, token)
    local container = P.frame({ Name = "Glyph", Size = UDim2.fromOffset(box, box) })
    local bindings = {}

    for index, part in ipairs(parts) do
        if part.kind == "bar" then
            local piece = P.frame({
                Name = "Bar" .. index,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(part.x, part.y),
                Size = UDim2.fromOffset(
                    math.max(1, math.round(part.length * box)),
                    part.thickness or BAR
                ),
                Rotation = part.rotation,
                BackgroundTransparency = 0,
                Parent = container,
            })
            Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = piece })
            table.insert(bindings, Theme.bind(piece, "BackgroundColor3", token))
        elseif part.kind == "ring" then
            local diameter = math.max(3, math.round(part.radius * 2 * box))
            local piece = P.frame({
                Name = "Ring" .. index,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(part.x, part.y),
                Size = UDim2.fromOffset(diameter, diameter),
                BackgroundTransparency = 1,
                Parent = container,
            })
            Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = piece })
            local stroke = Util.new("UIStroke", {
                Thickness = part.thickness,
                ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                Parent = piece,
            })
            table.insert(bindings, Theme.bind(stroke, "Color", token))
        elseif part.kind == "disc" then
            local diameter = math.max(2, math.round(part.radius * 2 * box))
            local piece = P.frame({
                Name = "Disc" .. index,
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(part.x, part.y),
                Size = UDim2.fromOffset(diameter, diameter),
                BackgroundTransparency = 0,
                Parent = container,
            })
            Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = piece })
            table.insert(bindings, Theme.bind(piece, "BackgroundColor3", token))
        end
    end

    return container, bindings
end

function Icons.create(name, options)
    options = options or {}
    local box = options.size or 14
    local token = options.token or "Muted"

    local image = resolveImage(name)
    if image then
        local label = P.image({
            Name = "Icon",
            Size = UDim2.fromOffset(box, box),
            Image = image,
        })
        local binding = Theme.bind(label, "ImageColor3", token)
        return label, { binding }
    end

    local glyph = GLYPHS[name]
    if glyph then
        return buildGlyph(glyph, box, token)
    end

    if type(name) == "string" and name ~= "" then
        local label = P.text({
            Name = "Icon",
            Size = UDim2.fromOffset(box, box),
            Text = string.upper(string.sub(name, 1, 1)),
            TextSize = math.max(9, box - 3),
            FontFace = P.Font.Medium,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        local binding = Theme.bind(label, "TextColor3", token)
        return label, { binding }
    end

    return nil, {}
end

function Icons.has(name)
    return GLYPHS[name] ~= nil or resolveImage(name) ~= nil
end

function Icons.colour(instance, bindings, value)
    if typeof(value) ~= "Color3" or typeof(instance) ~= "Instance" then
        return
    end
    for _, binding in ipairs(bindings or {}) do
        Theme.unbind(binding)
    end
    if instance:IsA("ImageLabel") then
        instance.ImageColor3 = value
    elseif instance:IsA("TextLabel") then
        instance.TextColor3 = value
    end
    for _, node in ipairs(instance:GetDescendants()) do
        if node:IsA("UIStroke") then
            node.Color = value
        elseif node:IsA("Frame") then
            node.BackgroundColor3 = value
        end
    end
end

function Icons.recolour(bindings, token)
    for _, binding in ipairs(bindings or {}) do
        Theme.rebind(binding, token)
    end
end

return Icons

end
Slate_modules["ui/Overlay"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local Input = require("core/Input")
local Log = require("core/Log")
local P = require("ui/Primitives")

local Overlay = {}
Overlay.__index = Overlay

Overlay.Z = {
    Popup = 500,
    Tooltip = 700,
    Modal = 900,
    Toast = 1100,
}

function Overlay.new(parent)
    local self = setmetatable({}, Overlay)
    self.maid = Maid.new()
    self.handles = {}
    self.root = P.frame({
        Name = "Overlay",
        Size = UDim2.fromScale(1, 1),
        ZIndex = Overlay.Z.Popup,
        Parent = parent,
    })
    self.maid:Add(self.root)
    return self
end

function Overlay:Count()
    return #self.handles
end

function Overlay:ToLocal(absolute)
    local origin = self.root.AbsolutePosition
    return UDim2.fromOffset(absolute.X - origin.X, absolute.Y - origin.Y)
end

local function clampToViewport(desired, size)
    local viewport = Util.viewport()
    return Vector2.new(
        Util.clamp(desired.X, 8, math.max(8, viewport.X - size.X - 8)),
        Util.clamp(desired.Y, 8, math.max(8, viewport.Y - size.Y - 8))
    )
end

function Overlay:Open(config)
    if not self.root or not self.root.Parent then
        Log.warn("overlay", "overlay is not attached")
        return nil
    end

    local maid = Maid.new()
    local handle = { id = Util.uid("overlay"), closed = false }

    local panel = P.canvas({
        Name = config.name or "Panel",
        BackgroundTransparency = 0,
        Size = config.size or UDim2.fromOffset(200, 120),
        Position = config.absolute and self:ToLocal(config.absolute)
            or config.position
            or UDim2.fromOffset(0, 0),
        ZIndex = config.zindex or Overlay.Z.Popup,
        Parent = self.root,
    })
    maid:Add(panel)
    maid:Add(Theme.bind(panel, "BackgroundColor3", config.token or "Elevated"))
    P.corner(panel, config.radius or Theme.number("Radius", 5))
    local strokeRest = Theme.number("BorderT", 0.9) - 0.06
    local stroke, strokeBinding = P.stroke(panel, "Border", 1, strokeRest)
    maid:Add(strokeBinding)
    handle.panelStroke = stroke

    local backdrop
    if config.modal then
        backdrop = P.frame({
            Name = "Backdrop",
            BackgroundTransparency = 1,
            BackgroundColor3 = Color3.new(0, 0, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = (config.zindex or Overlay.Z.Modal) - 1,
            Parent = self.root,
        })
        maid:Add(backdrop)
        Motion.play(backdrop, { BackgroundTransparency = 0.5 }, { duration = Motion.Duration.Base })
    end

    if config.anchorTo and typeof(config.anchorTo) == "Instance" then
        local anchor = config.anchorTo
        local width = config.width or anchor.AbsoluteSize.X
        local height = config.height or 160
        local gap = config.gap or 5
        panel.Size = UDim2.fromOffset(width, height)

        local function place()
            if not anchor.Parent then
                handle.Close()
                return
            end
            local anchorPosition = anchor.AbsolutePosition
            local anchorSize = anchor.AbsoluteSize
            local viewport = Util.viewport()
            local below = Vector2.new(anchorPosition.X, anchorPosition.Y + anchorSize.Y + gap)
            local flip = below.Y + height + 8 > viewport.Y and anchorPosition.Y - height - gap > 8
            local target = flip and Vector2.new(anchorPosition.X, anchorPosition.Y - height - gap) or below
            target = clampToViewport(target, Vector2.new(width, height))
            panel.Position = self:ToLocal(target)
            handle.flipped = flip
        end

        place()
        maid:Add(anchor:GetPropertyChangedSignal("AbsolutePosition"):Connect(place))
        maid:Add(anchor:GetPropertyChangedSignal("AbsoluteSize"):Connect(place))
        task.defer(place)
    elseif config.centre then
        panel.AnchorPoint = Vector2.new(0.5, 0.5)
        panel.Position = UDim2.fromScale(0.5, 0.5)
    end

    if config.build then
        local ok, err = pcall(config.build, panel, maid, handle)
        if not ok then
            Log.error("overlay", err)
        end
    end

    local layer = Input.pushLayer({
        modal = config.modal == true,
        contains = function(position)
            local topLeft = panel.AbsolutePosition
            local size = panel.AbsoluteSize
            if position.X >= topLeft.X and position.X <= topLeft.X + size.X
                and position.Y >= topLeft.Y and position.Y <= topLeft.Y + size.Y then
                return true
            end
            local keep = config.keepOpenOver
            if keep and typeof(keep) == "Instance" and keep.Parent then
                local anchorPos = keep.AbsolutePosition
                local anchorSize = keep.AbsoluteSize
                return position.X >= anchorPos.X and position.X <= anchorPos.X + anchorSize.X
                    and position.Y >= anchorPos.Y and position.Y <= anchorPos.Y + anchorSize.Y
            end
            return false
        end,
        dismiss = function()
            if config.dismissable == false then
                return
            end
            handle.Close()
        end,
        onEscape = function()
            if config.onEscape then
                config.onEscape(handle)
            else
                handle.Close()
            end
        end,
    })
    maid:Add(function()
        Input.popLayer(layer)
    end)

    local scale = Util.new("UIScale", { Scale = config.modal and 0.97 or 1, Parent = panel })
    panel.GroupTransparency = 1
    stroke.Transparency = 1
    Motion.play(panel, { GroupTransparency = 0 }, {
        duration = Motion.Duration.Base,
        easing = Enum.EasingStyle.Sine,
    })
    Motion.play(stroke, { Transparency = strokeRest }, {
        duration = Motion.Duration.Base,
        easing = Enum.EasingStyle.Sine,
    })
    if config.modal then
        Motion.play(scale, { Scale = 1 }, { duration = Motion.Duration.Base })
    end

    function handle.Close()
        if handle.closed then
            return
        end
        handle.closed = true
        Util.remove(self.handles, handle)
        if config.onClose then
            Util.dispatch(config.onClose)
        end
        Motion.play(panel, { GroupTransparency = 1 }, {
            duration = Motion.Duration.Base,
            easing = Enum.EasingStyle.Sine,
            onDone = function()
                maid:Destroy()
            end,
        })
        Motion.play(stroke, { Transparency = 1 }, {
            duration = Motion.Duration.Base,
            easing = Enum.EasingStyle.Sine,
        })
        if backdrop then
            Motion.play(backdrop, { BackgroundTransparency = 1 }, { duration = Motion.Duration.Fast })
        end
    end

    handle.panel = panel
    handle.maid = maid
    table.insert(self.handles, handle)
    return handle
end

function Overlay:CloseAll()
    for _, handle in ipairs(table.clone(self.handles)) do
        handle.Close()
    end
end

function Overlay:Destroy()
    for _, handle in ipairs(table.clone(self.handles)) do
        if not handle.closed then
            handle.closed = true
            handle.maid:Destroy()
        end
    end
    table.clear(self.handles)
    self.maid:Destroy()
end

return Overlay

end
Slate_modules["ui/Scroller"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Maid = require("core/Maid")
local P = require("ui/Primitives")

local Scroller = {}
Scroller.__index = Scroller

function Scroller.new(options)
    options = options or {}
    local self = setmetatable({}, Scroller)
    self.maid = Maid.new()

    self.frame = Util.new("ScrollingFrame", {
        Name = options.name or "Scroller",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = options.size or UDim2.fromScale(1, 1),
        Position = options.position or UDim2.fromScale(0, 0),
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = Theme.number("ScrollBar", 2),
        ScrollBarImageTransparency = 0.55,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ElasticBehavior = Enum.ElasticBehavior.Never,
        ClipsDescendants = true,
        ZIndex = options.zindex or 1,
    })
    self.maid:Add(self.frame)
    self.maid:Add(Theme.bind(self.frame, "ScrollBarImageColor3", "Faint"))

    self.layout = P.list(self.frame, { gap = options.gap or 0 })
    if options.padding then
        self.padding = P.pad(
            self.frame,
            options.padding.top or 0,
            options.padding.right or 0,
            options.padding.bottom or 0,
            options.padding.left or 0
        )
    end

    self.empty = nil
    self.count = 0
    return self
end

function Scroller:SetEmptyState(text)
    if not self.empty then
        self.empty = P.text({
            Name = "Empty",
            Size = UDim2.new(1, 0, 0, 56),
            Text = text or "Nothing here",
            TextSize = P.Size.Body,
            TextXAlignment = Enum.TextXAlignment.Center,
            LayoutOrder = 10000,
            Visible = false,
            Parent = self.frame,
        })
        self.maid:Add(Theme.bind(self.empty, "TextColor3", "Faint"))
    else
        self.empty.Text = text or self.empty.Text
    end
    self:Refresh()
end

function Scroller:Refresh()
    if not self.empty then
        return
    end
    local visible = 0
    for _, child in ipairs(self.frame:GetChildren()) do
        if child:IsA("GuiObject") and child ~= self.empty and child.Visible then
            visible += 1
        end
    end
    self.count = visible
    self.empty.Visible = visible == 0
end

function Scroller:ScrollTo(position)
    self.frame.CanvasPosition = Vector2.new(0, math.max(0, position))
end

function Scroller:ScrollToTop()
    self:ScrollTo(0)
end

function Scroller:Destroy()
    self.maid:Destroy()
end

return Scroller

end
Slate_modules["ui/Tooltip"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local Input = require("core/Input")
local P = require("ui/Primitives")
local Overlay = require("ui/Overlay")

local Tooltip = {}

local DELAY = 0.45
local current = nil
local currentMaid = nil

local function hide()
    if currentMaid then
        currentMaid:Destroy()
        currentMaid = nil
    end
    current = nil
end

local function show(overlay, text, position)
    local overlayRoot = overlay.root
    hide()
    currentMaid = Maid.new()

    local width = math.min(260, math.max(80, #text * 6 + 20))
    local frame = P.frame({
        Name = "Tooltip",
        BackgroundTransparency = 0,
        Size = UDim2.fromOffset(width, 24),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = Overlay.Z.Tooltip,
        Parent = overlayRoot,
    })
    currentMaid:Add(frame)
    currentMaid:Add(Theme.bind(frame, "BackgroundColor3", "Elevated"))
    P.corner(frame, Theme.number("RadiusSm", 3))
    local _, strokeBinding = P.stroke(frame, "Border", 1, Theme.number("BorderT", 0.9) - 0.06)
    currentMaid:Add(strokeBinding)

    local label = P.text({
        Name = "Text",
        Position = UDim2.fromOffset(8, 5),
        Size = UDim2.new(1, -16, 0, 14),
        AutomaticSize = Enum.AutomaticSize.Y,
        Text = text,
        TextSize = P.Size.Small,
        TextWrapped = true,
        TextTruncate = Enum.TextTruncate.None,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = Overlay.Z.Tooltip + 1,
        Parent = frame,
    })
    currentMaid:Add(Theme.bind(label, "TextColor3", "Muted"))

    local viewport = Util.viewport()
    local x = Util.clamp(position.X + 12, 8, viewport.X - width - 8)
    local y = Util.clamp(position.Y + 18, 8, viewport.Y - 60)
    frame.Position = overlay:ToLocal(Vector2.new(x, y))

    frame.BackgroundTransparency = 1
    label.TextTransparency = 1
    Motion.play(frame, { BackgroundTransparency = 0 }, { duration = Motion.Duration.Fast })
    Motion.play(label, { TextTransparency = 0 }, { duration = Motion.Duration.Fast })
    current = frame
end

function Tooltip.attach(window, target, text)
    if not window or not window.overlay or typeof(target) ~= "Instance" then
        return function() end
    end
    local maid = Maid.new()
    local pending = nil

    maid:Add(target.MouseEnter:Connect(function()
        if pending then
            task.cancel(pending)
        end
        pending = task.delay(DELAY, function()
            pending = nil
            if window.Destroyed then
                return
            end
            show(window.overlay, Util.str(text, ""), Input.pointerPosition())
        end)
    end))

    maid:Add(target.MouseLeave:Connect(function()
        if pending then
            task.cancel(pending)
            pending = nil
        end
        hide()
    end))

    maid:Add(function()
        if pending then
            task.cancel(pending)
        end
        hide()
    end)

    return maid
end

function Tooltip.hide()
    hide()
end

return Tooltip

end
Slate_modules["ui/Notify"] = function(require)
local RunService = game:GetService("RunService")

local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")
local Overlay = require("ui/Overlay")

local Notify = {}

local TYPES = {
    Info = { token = "Info", icon = "info", glyph = "dot" },
    Success = { token = "Success", icon = "check-check", glyph = "check" },
    Warning = { token = "Warning", icon = "triangle-alert", glyph = "zap" },
    Error = { token = "Danger", icon = "octagon-x", glyph = "close" },
}

local WIDTH = 316
local GAP = 10
local PAD = 14
local TILE = 36
local TEXT_X = PAD + TILE + 12
local RIGHT = 48
local LINE_H = 14
local MAX = 5

local screen = nil
local container = nil
local active = {}
local order = 0

local function host()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then
            return result
        end
    end
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and core then
        return core
    end
    local player = game:GetService("Players").LocalPlayer
    return player and player:FindFirstChildOfClass("PlayerGui")
end

local function ensureContainer()
    if container and container.Parent and screen and screen.Parent then
        return container
    end
    local parent = host()
    if not parent then
        return nil
    end
    screen = Util.new("ScreenGui", {
        Name = "SlateToasts",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 1000,
        Parent = parent,
    })
    P.trackRoot(screen)
    container = P.frame({
        Name = "Toasts",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(WIDTH, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = Overlay.Z.Toast,
        Parent = screen,
    })
    P.list(container, { gap = GAP, align = Enum.HorizontalAlignment.Right })
    return container
end

local function tint(instance, property, token, colour)
    if typeof(colour) == "Color3" then
        instance[property] = colour
        return nil
    end
    return Theme.bind(instance, property, token)
end

local function pickIcon(preferred, fallback)
    if type(preferred) == "string" and preferred ~= "" then
        local ok, has = pcall(Icons.has, preferred)
        if ok and has then
            return preferred
        end
    end
    return fallback
end

function Notify.setLimit(value)
    MAX = math.max(1, math.floor(Util.num(value, 5)))
end

function Notify.count()
    return #active
end

function Notify.push(config)
    if type(config) ~= "table" then
        config = { Title = Util.str(config, "Notice") }
    end
    local parent = ensureContainer()
    if not parent then
        return nil
    end

    while #active >= MAX do
        local oldest = active[1]
        if oldest then
            oldest.Close(true)
        else
            break
        end
    end

    local kind = TYPES[Util.str(config.Type, "Info")] or TYPES.Info
    local tone = typeof(config.Tone) == "Color3" and config.Tone or nil
    local duration = Util.num(config.Duration, 4)
    local title = Util.str(config.Title, "Notice")
    local content = Util.str(config.Content or config.Text or config.Description, nil)

    local maid = Maid.new()
    local handle = { closed = false }

    local lines = 0
    if content then
        local bounds = P.measure(content, P.Font.Regular, P.Size.Small, WIDTH - TEXT_X - RIGHT)
        lines = math.clamp(math.ceil(bounds.Y / LINE_H), 1, 3)
    end
    local textBottom = content and (33 + lines * LINE_H) or 31
    local height = math.max(64, textBottom + 21)

    order += 1
    local card = P.canvas({
        Name = "Toast",
        Size = UDim2.fromOffset(WIDTH, height),
        BackgroundTransparency = 0,
        LayoutOrder = order,
        ZIndex = Overlay.Z.Toast,
        Parent = parent,
    })
    maid:Add(card)
    maid:Add(Theme.bind(card, "BackgroundColor3", "Elevated"))
    P.corner(card, 10)
    local strokeRest = Theme.number("BorderT", 0.9) - 0.12
    local cardStrokeInstance, cardStroke = P.stroke(card, "Border", 1, strokeRest)
    maid:Add(cardStroke)

    local topGlow = P.frame({
        Name = "TopGlow",
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundTransparency = 0.9,
        ZIndex = 1,
        Parent = card,
    })
    maid:Add(tint(topGlow, "BackgroundColor3", kind.token, tone))
    Util.new("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = topGlow,
    })

    local tile = P.frame({
        Name = "Tile",
        Position = UDim2.fromOffset(PAD, PAD),
        Size = UDim2.fromOffset(TILE, TILE),
        BackgroundTransparency = 0.82,
        ZIndex = 2,
        Parent = card,
    })
    P.corner(tile, 11)
    maid:Add(tint(tile, "BackgroundColor3", kind.token, tone))
    local tileStroke = Util.new("UIStroke", {
        Thickness = 1,
        Transparency = 0.62,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = tile,
    })
    maid:Add(tint(tileStroke, "Color", kind.token, tone))
    Util.new("UIGradient", {
        Rotation = 125,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 0.55),
        }),
        Parent = tile,
    })

    local glyph, glyphBindings = Icons.create(
        pickIcon(config.Icon, pickIcon(kind.icon, kind.glyph)),
        { size = 17, token = kind.token }
    )
    if glyph then
        glyph.AnchorPoint = Vector2.new(0.5, 0.5)
        glyph.Position = UDim2.fromScale(0.5, 0.5)
        glyph.ZIndex = 3
        glyph.Parent = tile
        if tone then
            Icons.colour(glyph, glyphBindings, tone)
        else
            maid:AddAll(glyphBindings)
        end
    end

    local titleFrame, titleBindings, titleConnection = P.emboss(card, {
        text = title,
        size = 14,
        depth = 2,
        step = 1,
        accentFrom = #title + 1,
        token = "Text",
        shadowToken = "Background",
        frameSize = UDim2.new(1, -TEXT_X - RIGHT, 0, 18),
        position = UDim2.fromOffset(TEXT_X, 12),
    })
    titleFrame.Name = "Title"
    titleFrame.ZIndex = 2
    maid:AddAll(titleBindings)
    maid:Add(titleConnection)

    if content then
        local body = P.text({
            Name = "Content",
            Position = UDim2.fromOffset(TEXT_X, 33),
            Size = UDim2.new(1, -TEXT_X - RIGHT, 0, lines * LINE_H),
            Text = content,
            TextSize = P.Size.Small,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 2,
            Parent = card,
        })
        maid:Add(Theme.bind(body, "TextColor3", "Muted"))
    end

    local timerLabel
    if duration > 0 then
        timerLabel = P.text({
            Name = "Timer",
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -34, 0, 13),
            Size = UDim2.fromOffset(20, 14),
            Text = tostring(math.ceil(duration)),
            TextSize = P.Size.Micro,
            FontFace = P.Font.Mono,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 2,
            Parent = card,
        })
        maid:Add(Theme.bind(timerLabel, "TextColor3", "Faint"))
    end

    local closeButton = P.hitbox({
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 10),
        Size = UDim2.fromOffset(20, 20),
        ZIndex = 6,
        Parent = card,
    })
    local closeSkin = P.frame({
        Name = "Skin",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 5,
        Parent = closeButton,
    })
    P.corner(closeSkin, 6)
    maid:Add(Theme.bind(closeSkin, "BackgroundColor3", "SurfaceAlt"))
    local closeGlyph, closeBindings = Icons.create("close", { size = 9, token = "Faint" })
    if closeGlyph then
        closeGlyph.AnchorPoint = Vector2.new(0.5, 0.5)
        closeGlyph.Position = UDim2.fromScale(0.5, 0.5)
        closeGlyph.ZIndex = 7
        closeGlyph.Parent = closeButton
        maid:AddAll(closeBindings)
    end

    local track, fill
    if duration > 0 then
        track = P.frame({
            Name = "Track",
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, PAD, 1, -10),
            Size = UDim2.new(1, -PAD * 2, 0, 3),
            BackgroundTransparency = 0.86,
            ClipsDescendants = true,
            ZIndex = 2,
            Parent = card,
        })
        P.corner(track, 2)
        maid:Add(Theme.bind(track, "BackgroundColor3", "Faint"))

        fill = P.frame({
            Name = "Fill",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0,
            ZIndex = 3,
            Parent = track,
        })
        P.corner(fill, 2)
        maid:Add(tint(fill, "BackgroundColor3", kind.token, tone))
        Util.new("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.5),
                NumberSequenceKeypoint.new(1, 0),
            }),
            Parent = fill,
        })
    end

    local paused = false
    local remaining = duration

    card.GroupTransparency = 1
    cardStrokeInstance.Transparency = 1
    card.Position = UDim2.fromOffset(WIDTH + 24, 0)
    Motion.play(card, { Position = UDim2.fromOffset(0, 0) }, {
        duration = 0.36,
        easing = Enum.EasingStyle.Quint,
    })
    Motion.play(card, { GroupTransparency = 0 }, {
        duration = Motion.Duration.Slow,
        easing = Enum.EasingStyle.Sine,
    })
    Motion.play(cardStrokeInstance, { Transparency = strokeRest }, {
        duration = Motion.Duration.Slow,
        easing = Enum.EasingStyle.Sine,
    })

    function handle.Close(immediate)
        if handle.closed then
            return
        end
        handle.closed = true
        Util.remove(active, handle)
        if config.OnClose then
            Util.dispatch(config.OnClose)
        end
        if immediate then
            maid:Destroy()
            return
        end
        Motion.play(card, {
            Position = UDim2.fromOffset(WIDTH + 24, 0),
            GroupTransparency = 1,
        }, {
            duration = Motion.Duration.Slow,
            easing = Enum.EasingStyle.Quint,
        })
        Motion.play(cardStrokeInstance, { Transparency = 1 }, {
            duration = Motion.Duration.Slow,
            easing = Enum.EasingStyle.Sine,
        })
        Motion.play(card, { Size = UDim2.fromOffset(WIDTH, 0) }, {
            duration = 0.14,
            delay = Motion.Duration.Slow,
            easing = Enum.EasingStyle.Sine,
            onDone = function()
                maid:Destroy()
            end,
        })
    end

    local function setHover(state)
        paused = state
        Motion.hover(closeSkin, { BackgroundTransparency = state and 0.4 or 1 })
        Icons.recolour(closeBindings, state and "Text" or "Faint")
        if track then
            Motion.hover(track, { BackgroundTransparency = state and 0.74 or 0.86 })
        end
    end

    maid:Add(P.interactive(closeButton, {
        onEnter = function()
            setHover(true)
        end,
        onLeave = function()
            setHover(false)
        end,
        onClick = function()
            handle.Close()
        end,
    }))

    local body = P.hitbox({
        Name = "Surface",
        Size = UDim2.fromScale(1, 1),
        ZIndex = 4,
        Parent = card,
    })
    maid:Add(P.interactive(body, {
        render = function(state)
            setHover(state.hovered)
            Motion.hover(card, { BackgroundTransparency = state.hovered and 0.04 or 0 })
        end,
        onClick = function()
            if config.Callback then
                Util.dispatch(config.Callback)
                handle.Close()
            end
        end,
    }))

    if duration > 0 then
        maid:Add(RunService.Heartbeat:Connect(function(delta)
            if handle.closed then
                return
            end
            if not paused then
                remaining = math.max(0, remaining - delta)
            end
            if fill then
                fill.Size = UDim2.fromScale(remaining / duration, 1)
            end
            if timerLabel then
                local shown = tostring(math.max(0, math.ceil(remaining)))
                if timerLabel.Text ~= shown then
                    timerLabel.Text = shown
                end
            end
            if remaining <= 0 then
                handle.Close()
            end
        end))
    end

    handle.card = card
    if not handle.closed then
        table.insert(active, handle)
    end
    return handle
end

function Notify.clear()
    for _, handle in ipairs(table.clone(active)) do
        handle.Close(true)
    end
    table.clear(active)
end

function Notify.destroy()
    Notify.clear()
    if screen then
        P.untrackRoot(screen)
        screen:Destroy()
        screen = nil
    end
    container = nil
    order = 0
end

return Notify

end
Slate_modules["ui/Modal"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")
local Overlay = require("ui/Overlay")

local Modal = {}

local function actionButton(parent, config, maid, order)
    local button = P.hitbox({
        Name = "Action",
        Size = UDim2.fromOffset(config.width or 96, 30),
        LayoutOrder = order,
        BackgroundTransparency = 0,
        Parent = parent,
    })
    P.corner(button, Theme.number("RadiusSm", 3))

    local filled = config.Primary == true
    local tone = config.Tone or (config.Danger and "Danger" or "Accent")
    maid:Add(Theme.bind(button, "BackgroundColor3", filled and tone or "SurfaceAlt"))
    if not filled then
        local _, strokeBinding = P.stroke(button, "Border", 1, Theme.number("BorderT", 0.9))
        maid:Add(strokeBinding)
    end

    local label = P.text({
        Name = "Label",
        Size = UDim2.fromScale(1, 1),
        Text = Util.str(config.Text or config.Name, "OK"),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextSize = P.Size.Body,
        FontFace = P.Font.Medium,
        ZIndex = 3,
        Parent = button,
    })
    maid:Add(Theme.bind(label, "TextColor3", filled and "OnAccent" or "Text"))

    maid:Add(P.interactive(button, {
        render = function(state)
            Motion.hover(button, {
                BackgroundTransparency = state.hovered and (filled and 0.12 or 0.4) or (filled and 0 or 0.7),
            })
        end,
        onClick = config.onClick,
    }))
    return button
end

function Modal.open(window, config)
    if not window or not window.overlay then
        Log.warn("modal", "no window")
        return nil
    end
    config = config or {}

    local title = Util.str(config.Title, "Confirm")
    local content = Util.str(config.Content or config.Text or config.Description, nil)
    local buttons = config.Buttons
    if type(buttons) ~= "table" or #buttons == 0 then
        buttons = {
            { Text = "Cancel" },
            { Text = "Confirm", Primary = true, Callback = config.Callback },
        }
    end

    local bodyHeight = content and 54 or 12
    local height = 56 + bodyHeight + 46

    return window.overlay:Open({
        name = "Modal",
        centre = true,
        modal = true,
        dismissable = config.Dismissable ~= false,
        size = UDim2.fromOffset(Util.num(config.Width, 360), height),
        zindex = Overlay.Z.Modal,
        onClose = config.OnClose,
        build = function(panel, maid, handle)
            local tone = config.Tone or (config.Danger and "Danger" or "Accent")

            local accent = P.frame({
                Name = "Accent",
                Size = UDim2.new(0, 2, 0, 18),
                Position = UDim2.fromOffset(0, 20),
                BackgroundTransparency = 0,
                Parent = panel,
            })
            P.corner(accent, 1)
            maid:Add(Theme.bind(accent, "BackgroundColor3", tone))

            local titleLabel = P.text({
                Name = "Title",
                Position = UDim2.fromOffset(18, 18),
                Size = UDim2.new(1, -60, 0, 20),
                Text = title,
                TextSize = P.Size.Title,
                FontFace = P.Font.Medium,
                Parent = panel,
            })
            maid:Add(Theme.bind(titleLabel, "TextColor3", "Text"))

            local close = P.hitbox({
                Name = "Close",
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -14, 0, 16),
                Size = UDim2.fromOffset(20, 20),
                ZIndex = 5,
                Parent = panel,
            })
            local closeGlyph, closeBindings = Icons.create("close", { size = 10, token = "Faint" })
            if closeGlyph then
                closeGlyph.AnchorPoint = Vector2.new(0.5, 0.5)
                closeGlyph.Position = UDim2.fromScale(0.5, 0.5)
                closeGlyph.ZIndex = 5
                closeGlyph.Parent = close
                maid:AddAll(closeBindings)
            end
            maid:Add(P.interactive(close, {
                render = function(state)
                    Icons.recolour(closeBindings, state.hovered and "Text" or "Faint")
                end,
                onClick = function()
                    handle.Close()
                end,
            }))

            if content then
                local body = P.text({
                    Name = "Content",
                    Position = UDim2.fromOffset(18, 44),
                    Size = UDim2.new(1, -36, 0, 44),
                    Text = content,
                    TextSize = P.Size.Body,
                    TextWrapped = true,
                    TextTruncate = Enum.TextTruncate.None,
                    TextYAlignment = Enum.TextYAlignment.Top,
                    Parent = panel,
                })
                maid:Add(Theme.bind(body, "TextColor3", "Muted"))
            end

            local footer = P.frame({
                Name = "Footer",
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, -16, 1, -14),
                Size = UDim2.new(1, -32, 0, 30),
                Parent = panel,
            })
            P.list(footer, {
                horizontal = true,
                gap = 8,
                align = Enum.HorizontalAlignment.Right,
                valign = Enum.VerticalAlignment.Center,
            })

            for index, spec in ipairs(buttons) do
                actionButton(footer, {
                    Text = spec.Text or spec.Name,
                    Primary = spec.Primary,
                    Tone = spec.Tone,
                    Danger = spec.Danger,
                    width = spec.Width,
                    onClick = function()
                        handle.Close()
                        Util.dispatch(spec.Callback)
                    end,
                }, maid, index)
            end
        end,
    })
end

function Modal.confirm(window, config)
    config = config or {}
    return Modal.open(window, {
        Title = config.Title or "Confirm action",
        Content = config.Content or config.Text,
        Danger = config.Danger,
        Width = config.Width,
        Buttons = {
            { Text = config.CancelText or "Cancel", Callback = config.OnCancel },
            {
                Text = config.ConfirmText or "Confirm",
                Primary = true,
                Danger = config.Danger,
                Callback = config.OnConfirm or config.Callback,
            },
        },
    })
end

function Modal.prompt(window, config)
    if not window or not window.overlay then
        Log.warn("modal", "no window")
        return nil
    end
    config = config or {}
    local box

    return window.overlay:Open({
        name = "Prompt",
        centre = true,
        modal = true,
        size = UDim2.fromOffset(Util.num(config.Width, 360), 152),
        zindex = Overlay.Z.Modal,
        build = function(panel, maid, handle)
            local titleLabel = P.text({
                Name = "Title",
                Position = UDim2.fromOffset(18, 18),
                Size = UDim2.new(1, -36, 0, 20),
                Text = Util.str(config.Title, "Enter a value"),
                TextSize = P.Size.Title,
                FontFace = P.Font.Medium,
                Parent = panel,
            })
            maid:Add(Theme.bind(titleLabel, "TextColor3", "Text"))

            local field = P.frame({
                Name = "Field",
                Position = UDim2.fromOffset(18, 52),
                Size = UDim2.new(1, -36, 0, 32),
                BackgroundTransparency = 0.4,
                Parent = panel,
            })
            P.corner(field, Theme.number("RadiusSm", 3))
            maid:Add(Theme.bind(field, "BackgroundColor3", "Surface"))
            local _, fieldStroke = P.stroke(field, "Border", 1, Theme.number("BorderT", 0.9))
            maid:Add(fieldStroke)

            box = Util.new("TextBox", {
                Name = "Entry",
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(10, 0),
                Size = UDim2.new(1, -20, 1, 0),
                FontFace = P.Font.Regular,
                TextSize = P.Size.Body,
                TextXAlignment = Enum.TextXAlignment.Left,
                PlaceholderText = Util.str(config.Placeholder, ""),
                Text = Util.str(config.Default, ""),
                ClearTextOnFocus = false,
                Parent = field,
            })
            maid:Add(Theme.bind(box, "TextColor3", "Text"))
            maid:Add(Theme.bind(box, "PlaceholderColor3", "Faint"))

            local footer = P.frame({
                Name = "Footer",
                AnchorPoint = Vector2.new(1, 1),
                Position = UDim2.new(1, -16, 1, -14),
                Size = UDim2.new(1, -32, 0, 30),
                Parent = panel,
            })
            P.list(footer, {
                horizontal = true,
                gap = 8,
                align = Enum.HorizontalAlignment.Right,
                valign = Enum.VerticalAlignment.Center,
            })

            actionButton(footer, {
                Text = "Cancel",
                onClick = function()
                    handle.Close()
                end,
            }, maid, 1)

            actionButton(footer, {
                Text = Util.str(config.ConfirmText, "Save"),
                Primary = true,
                onClick = function()
                    local value = box.Text
                    handle.Close()
                    Util.dispatch(config.Callback, value)
                end,
            }, maid, 2)

            maid:Add(box.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    local value = box.Text
                    handle.Close()
                    Util.dispatch(config.Callback, value)
                end
            end))

            task.defer(function()
                if box.Parent then
                    box:CaptureFocus()
                end
            end)
        end,
        onClose = config.OnClose,
    })
end

return Modal

end
Slate_modules["ui/ContextMenu"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Input = require("core/Input")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")
local Overlay = require("ui/Overlay")

local ContextMenu = {}

local ITEM_H = 28
local WIDTH = 168

function ContextMenu.open(window, items, position)
    if not window or not window.overlay then
        return nil
    end
    items = Util.list(items)
    if #items == 0 then
        return nil
    end

    position = position or Input.pointerPosition()
    local height = 8
    for _, item in ipairs(items) do
        height += (item.Separator and 7 or ITEM_H)
    end

    local viewport = Util.viewport()
    local x = Util.clamp(position.X, 8, viewport.X - WIDTH - 8)
    local y = Util.clamp(position.Y, 8, viewport.Y - height - 8)

    return window.overlay:Open({
        name = "ContextMenu",
        size = UDim2.fromOffset(WIDTH, height),
        absolute = Vector2.new(x, y),
        zindex = Overlay.Z.Popup + 20,
        build = function(panel, maid, handle)
            P.pad(panel, 4, 4, 4, 4)
            P.list(panel, { gap = 0 })

            for index, item in ipairs(items) do
                if item.Separator then
                    local rule = P.frame({
                        Name = "Separator",
                        Size = UDim2.new(1, 0, 0, 7),
                        LayoutOrder = index,
                        Parent = panel,
                    })
                    local line = P.frame({
                        Name = "Line",
                        AnchorPoint = Vector2.new(0, 0.5),
                        Position = UDim2.new(0, 0, 0.5, 0),
                        Size = UDim2.new(1, 0, 0, 1),
                        BackgroundTransparency = Theme.number("LineT", 0.94) - 0.02,
                        Parent = rule,
                    })
                    maid:Add(Theme.bind(line, "BackgroundColor3", "Line"))
                else
                    local row = P.hitbox({
                        Name = "Item",
                        Size = UDim2.new(1, 0, 0, ITEM_H),
                        LayoutOrder = index,
                        ZIndex = 3,
                        Parent = panel,
                    })
                    P.corner(row, Theme.number("RadiusSm", 3))
                    maid:Add(Theme.bind(row, "BackgroundColor3", "Text"))
                    row.BackgroundTransparency = 1

                    local textX = 10
                    if item.Icon then
                        local glyph, bindings = Icons.create(item.Icon, { size = 11, token = "Faint" })
                        if glyph then
                            glyph.AnchorPoint = Vector2.new(0, 0.5)
                            glyph.Position = UDim2.new(0, 8, 0.5, 0)
                            glyph.ZIndex = 4
                            glyph.Parent = row
                            maid:AddAll(bindings)
                            textX = 26
                        end
                    end

                    local label = P.text({
                        Name = "Label",
                        Position = UDim2.fromOffset(textX, 0),
                        Size = UDim2.new(1, -textX - 8, 1, 0),
                        Text = Util.str(item.Name or item.Text, "Item"),
                        TextSize = P.Size.Body,
                        ZIndex = 4,
                        Parent = row,
                    })
                    maid:Add(Theme.bind(label, "TextColor3",
                        item.Disabled and "Faint" or (item.Danger and "Danger" or "Text")))

                    maid:Add(P.interactive(row, {
                        render = function(state)
                            Motion.hover(row, {
                                BackgroundTransparency = (state.hovered and not item.Disabled) and 0.94 or 1,
                            })
                        end,
                        onClick = function()
                            if item.Disabled then
                                return
                            end
                            handle.Close()
                            Util.dispatch(item.Callback)
                        end,
                    }))
                end
            end
        end,
    })
end

return ContextMenu

end
Slate_modules["elements/Base"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local Signal = require("core/Signal")
local Log = require("core/Log")
local Registry = require("core/Registry")
local P = require("ui/Primitives")

local Base = {}

local ROW_SINGLE = 34
local ROW_DOUBLE = 48

local Element = {}
Element.__index = Element

function Element:Path()
    local parts = {}
    if self.section then
        table.insert(parts, self.section.Name or "")
        if self.section.tab then
            table.insert(parts, 1, self.section.tab.Name or "")
        end
    end
    table.insert(parts, self.Name or "")
    return table.concat(parts, " / ")
end

function Element:Get()
    return self.Value
end

function Element:Set(value, silent)
    if self.Destroyed then
        Log.warn(self.Kind, "Set on a destroyed element")
        return self
    end
    if self._spec.set then
        self._spec.set(self, value, silent == true)
    else
        self.Value = value
    end
    return self
end

function Element:Reset(silent)
    return self:Set(self.Default, silent)
end

function Element:Emit(value)
    self.Value = value
    self.Changed:Fire(value, self)
    if self.window then
        self.window._elementChanged:Fire(self, value)
    end
    if self.Flag then
        Registry.Changed:Fire(self, value)
    end
    Util.dispatch(self.Callback, value, self)
end

function Element:OnChanged(handler)
    local connection = self.Changed:Connect(handler)
    self.maid:Add(connection)
    return connection
end

function Element:SetCallback(callback)
    self.Callback = Util.fn(callback)
    return self
end

function Element:SetName(text)
    self.Name = Util.str(text, self.Name)
    if self.nameLabel then
        self.nameLabel.Text = self.Name
    end
    return self
end

function Element:SetDescription(text)
    local value = Util.str(text, nil)
    self.Description = value
    if value and value ~= "" then
        if not self.descLabel then
            self.descLabel = P.text({
                Name = "Description",
                Size = UDim2.new(1, 0, 0, 14),
                Position = UDim2.fromOffset(0, 19),
                TextSize = P.Size.Small,
                Parent = self.left,
            })
            self.maid:Add(Theme.bind(self.descLabel, "TextColor3", "Muted"))
        end
        self.descLabel.Text = value
        self.descLabel.Visible = true
    elseif self.descLabel then
        self.descLabel.Visible = false
    end
    self:_layout()
    return self
end

local THUMB = 26
local THUMB_GAP = 10

function Element:SetImage(asset)
    if asset == nil or asset == false or asset == "" then
        if self.thumb then
            self.thumb.Visible = false
        end
        if self.thumbPad then
            self.thumbPad.PaddingLeft = UDim.new()
        end
        return self
    end
    local image = asset
    if type(image) == "number" then
        image = "rbxassetid://" .. tostring(image)
    end
    if not self.thumb then
        self.thumb = P.image({
            Name = "Thumb",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(THUMB, THUMB),
            BackgroundTransparency = 0,
            ZIndex = 2,
            Parent = self.row,
        })
        P.corner(self.thumb, Theme.number("RadiusSm", 4))
        self.maid:Add(Theme.bind(self.thumb, "BackgroundColor3", "Elevated"))
        self.thumbPad = Util.new("UIPadding", { Parent = self.left })
    end
    self.thumb.Image = image
    self.thumb.Visible = true
    self.thumbPad.PaddingLeft = UDim.new(0, THUMB + THUMB_GAP)
    return self
end

function Element:SetVisible(state)
    local visible = state ~= false
    if self.Visible == visible then
        return self
    end
    self.Visible = visible
    self.row.Visible = visible
    if self.section then
        self.section:_invalidate()
    end
    return self
end

function Element:SetDisabled(state)
    local disabled = state == true
    if self.Disabled == disabled then
        return self
    end
    self.Disabled = disabled
    if self.hover then
        self.hover.setDisabled(disabled)
    end
    local fade = disabled and 0.55 or 0
    Motion.play(self.nameLabel, { TextTransparency = fade }, { duration = Motion.Duration.Fast })
    if self.descLabel then
        Motion.play(self.descLabel, { TextTransparency = fade }, { duration = Motion.Duration.Fast })
    end
    self.hitbox.Active = not disabled
    if self._spec.disabled then
        self._spec.disabled(self, disabled)
    end
    return self
end

function Element:SetFlag(flag)
    self.Flag = Util.str(flag, nil)
    return self
end

function Element:Serialise()
    if self._spec.serialise then
        return self._spec.serialise(self)
    end
    return self.Value
end

function Element:Deserialise(data)
    if self._spec.deserialise then
        self._spec.deserialise(self, data)
    else
        self:Set(data, false)
    end
    return self
end

function Element:Highlight()
    if self.Destroyed then
        return
    end
    Motion.set(self.row, { BackgroundTransparency = 0.86 })
    Motion.play(self.row, { BackgroundTransparency = 1 }, {
        duration = 0.9,
        easing = Enum.EasingStyle.Sine,
    })
end

local LABEL_MIN = 96

function Element:NeedWidth()
    local control = self.ControlWidth or self._spec.controlWidth or 120
    if control <= 0 or not self.nameLabel or not self.nameLabel.Visible then
        return 0
    end
    local bounds = P.measure(self.nameLabel.Text, self.nameLabel.FontFace, self.nameLabel.TextSize)
    return math.ceil(bounds.X) + control + 14
end

function Element:_fit()
    if self.Destroyed then
        return
    end
    local want = self.ControlWidth or self._spec.controlWidth or 120
    if want <= 0 or not self.control then
        return
    end
    local width = self.row.AbsoluteSize.X
    if width <= 0 then
        return
    end
    local allowed = math.min(want, math.max(64, width - LABEL_MIN - 12))
    if math.abs(self.control.Size.X.Offset - allowed) < 1 then
        return
    end
    self.control.Size = UDim2.new(0, allowed, 1, 0)
    self.left.Size = UDim2.new(1, -allowed - 12, 1, 0)
end

function Element:SetControlWidth(width)
    local value = math.max(0, math.floor(width))
    if self.ControlWidth == value then
        return self
    end
    self.ControlWidth = value
    self:_fit()
    if self.section and self.section._invalidate then
        self.section:_invalidate()
    end
    return self
end

function Element:HugControl(text, font, size, extra, minimum, maximum)
    task.defer(function()
        if self.Destroyed then
            return
        end
        local bounds = P.measure(text, font, size)
        local want = math.ceil(bounds.X) + P.FieldPad * 2 + (extra or 0)
        self:SetControlWidth(math.clamp(want, minimum, maximum))
    end)
    return self
end

function Element:_layout()
    local hasDescription = self.descLabel ~= nil and self.descLabel.Visible
    local height = hasDescription and ROW_DOUBLE or ROW_SINGLE
    if self._spec.height then
        height = self._spec.height(self, hasDescription)
    end
    self.row.Size = UDim2.new(1, 0, 0, height)
    if self.nameLabel then
        self.nameLabel.Position = UDim2.fromOffset(0, hasDescription and 4 or 0)
        self.nameLabel.Size = hasDescription and UDim2.new(1, 0, 0, 16) or UDim2.new(1, 0, 1, 0)
    end
    if self._spec.layout then
        self._spec.layout(self, hasDescription, height)
    end
end

function Element:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    Registry.remove(self)
    if self.section then
        Util.remove(self.section.elements, self)
        self.section:_invalidate()
    end
    self.Changed:Destroy()
    self.maid:Destroy()
end

function Base.define(spec)
    local meta = { __index = Element }
    if type(spec.api) == "table" then
        local extended = setmetatable({}, { __index = Element })
        for name, fn in pairs(spec.api) do
            extended[name] = fn
        end
        meta.__index = extended
    end

    return function(section, config)
        if type(config) ~= "table" then
            Log.warn(spec.Kind, "config must be a table")
            config = {}
        end

        local self = setmetatable({}, meta)
        self._spec = spec
        self.Kind = spec.Kind
        self.Id = Util.uid(string.lower(spec.Kind))
        self.Name = Util.str(config.Name or config.Title, spec.Kind)
        self.Description = Util.str(config.Description or config.Desc, nil)
        self.Flag = Util.str(config.Flag, nil)
        self.Callback = Util.fn(config.Callback)
        self.Searchable = config.Searchable ~= false
        self.Visible = true
        self.Disabled = false
        self.Destroyed = false
        self.Changed = Signal.new()
        self.maid = Maid.new()
        self.section = section
        self.window = section and section.window or nil

        if config.Name ~= nil and type(config.Name) ~= "string" then
            Log.field(spec.Kind, "Name", config.Name, "string")
        end
        if config.Callback ~= nil and type(config.Callback) ~= "function" then
            Log.field(spec.Kind, "Callback", config.Callback, "function")
        end

        local row = P.frame({
            Name = spec.Kind,
            Size = UDim2.new(1, 0, 0, ROW_SINGLE),
            BackgroundTransparency = 1,
            LayoutOrder = section and (#section.elements + 1) or 1,
        })
        self.row = row
        self.maid:Add(row)
        self.maid:Add(Theme.bind(row, "BackgroundColor3", "Text"))
        row.BackgroundTransparency = 1

        self.left = P.frame({
            Name = "Label",
            Position = UDim2.fromOffset(0, 0),
            Size = UDim2.new(1, -(spec.controlWidth or 120) - 12, 1, 0),
            Parent = row,
        })

        self.nameLabel = P.text({
            Name = "Name",
            Size = UDim2.new(1, 0, 1, 0),
            Text = self.Name,
            TextSize = P.Size.Label,
            FontFace = P.Font.Medium,
            Parent = self.left,
        })
        self.maid:Add(Theme.bind(self.nameLabel, "TextColor3", "Text"))

        self.control = P.frame({
            Name = "Control",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(0, spec.controlWidth or 120, 1, 0),
            Parent = row,
        })

        self.ControlWidth = spec.controlWidth or 120

        if spec.controlOnTop then
            self.control.ZIndex = 6
        end

        if (spec.controlWidth or 120) > 0 then
            self.maid:Add(row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                self:_fit()
            end))
            task.defer(function()
                if not self.Destroyed then
                    self:_fit()
                end
            end)
        end

        self.hitbox = P.hitbox({ Parent = row, ZIndex = 3 })
        self.maid:Add(self.hitbox)

        if spec.hoverable ~= false then
            self.hover = P.interactive(self.hitbox, {
                render = function(state)
                    local lit = state.hovered and not state.disabled
                    Motion.hover(row, {
                        BackgroundTransparency = lit and Theme.number("HoverT", 0.965) or 1,
                    })
                end,
                onClick = function()
                    if spec.activate then
                        spec.activate(self)
                    end
                end,
            })
            self.maid:Add(self.hover)
        else
            self.hitbox.Active = false
        end

        if section and section._invalidate then
            task.defer(function()
                if not self.Destroyed and section._invalidate then
                    section:_invalidate()
                end
            end)
        end

        if spec.build then
            spec.build(self, config)
        end

        if config.Image ~= nil then
            self:SetImage(config.Image)
        end

        if self.Description then
            self:SetDescription(self.Description)
        else
            self:_layout()
        end

        if config.Visible == false then
            self:SetVisible(false)
        end
        if config.Disabled == true then
            self:SetDisabled(true)
        end

        Registry.add(self)
        if section then
            table.insert(section.elements, self)
            row.Parent = section.body
            section:_invalidate()
        end

        return self
    end
end

Base.RowSingle = ROW_SINGLE
Base.RowDouble = ROW_DOUBLE
Base.Element = Element

return Base

end
Slate_modules["elements/Button"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Base = require("elements/Base")
local Icons = require("ui/Icons")

return Base.define({
    Kind = "Button",
    controlWidth = 22,

    build = function(self, config)
        self.Value = nil
        self.Default = nil

        local glyph, bindings = Icons.create(config.Icon or "chevron-right", { size = 12, token = "Faint" })
        if glyph then
            glyph.AnchorPoint = Vector2.new(1, 0.5)
            glyph.Position = UDim2.new(1, 0, 0.5, 0)
            glyph.Parent = self.control
            self.glyph = glyph
            self.maid:AddAll(bindings)
        end
    end,

    activate = function(self)
        if self.Disabled then
            return
        end
        Motion.set(self.row, { BackgroundTransparency = 0.9 })
        Motion.play(self.row, { BackgroundTransparency = Theme.number("HoverT", 0.965) }, {
            duration = Motion.Duration.Base,
            easing = Enum.EasingStyle.Sine,
        })
        if self.glyph then
            Motion.set(self.glyph, { Position = UDim2.new(1, 3, 0.5, 0) })
            Motion.play(self.glyph, { Position = UDim2.new(1, 0, 0.5, 0) }, {
                duration = Motion.Duration.Base,
            })
        end
        self.Changed:Fire(true, self)
        Util.dispatch(self.Callback, self)
    end,

    set = function()
    end,

    serialise = function()
        return nil
    end,

    deserialise = function()
    end,
})

end
Slate_modules["elements/Toggle"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local Base = require("elements/Base")
local P = require("ui/Primitives")

local TRACK_W = 44
local TRACK_H = 24
local KNOB = 18
local INSET = 3

local function paint(self, animate)
    local on = self.Value == true
    local duration = animate and Motion.Duration.Base or 0

    Theme.rebind(self.trackBinding, on and "ToggleOn" or "SurfaceAlt")
    Theme.rebind(self.knobBinding, on and "ToggleKnob" or "Muted")
    Theme.rebind(self.strokeBinding, on and "ToggleOn" or "Border")

    Motion.play(self.track, {
        BackgroundTransparency = self.Disabled and 0.8 or (on and 0 or 0.45),
    }, { duration = duration, easing = Enum.EasingStyle.Sine })

    Motion.play(self.stroke, {
        Transparency = on and 0.6 or Theme.number("BorderT", 0.9),
    }, { duration = duration })

    local target = on and (TRACK_W - KNOB - INSET) or INSET
    if animate then
        Motion.play(self.knob, {
            Size = UDim2.fromOffset(KNOB + 5, KNOB - 2),
            Position = UDim2.new(0, on and (target - 3) or (target - 1), 0.5, 0),
        }, {
            duration = 0.08,
            easing = Enum.EasingStyle.Sine,
            onDone = function()
                if self.Destroyed or self.Value ~= on then
                    return
                end
                Motion.play(self.knob, {
                    Size = UDim2.fromOffset(KNOB, KNOB),
                    Position = UDim2.new(0, target, 0.5, 0),
                }, { duration = 0.24, easing = Enum.EasingStyle.Back })
            end,
        })
    else
        Motion.set(self.knob, {
            Size = UDim2.fromOffset(KNOB, KNOB),
            Position = UDim2.new(0, target, 0.5, 0),
        })
    end

end

return Base.define({
    Kind = "Toggle",
    controlWidth = TRACK_W,

    build = function(self, config)
        self.Default = Util.bool(config.Default or config.Value, false)
        self.Value = self.Default

        if config.Default ~= nil and type(config.Default) ~= "boolean" then
            Log.field("Toggle", "Default", config.Default, "boolean")
        end

        self.track = P.frame({
            Name = "Track",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.fromOffset(TRACK_W, TRACK_H),
            BackgroundTransparency = 0.45,
            ClipsDescendants = true,
            Parent = self.control,
        })
        Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.track })
        self.trackBinding = Theme.bind(self.track, "BackgroundColor3", "SurfaceAlt")
        self.maid:Add(self.trackBinding)

        local stroke, strokeBinding = P.stroke(self.track, "Border", 1, Theme.number("BorderT", 0.9))
        self.stroke = stroke
        self.strokeBinding = strokeBinding
        self.maid:Add(strokeBinding)

        Util.new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.14),
            }),
            Parent = self.track,
        })

        self.knob = P.frame({
            Name = "Knob",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, INSET, 0.5, 0),
            Size = UDim2.fromOffset(KNOB, KNOB),
            BackgroundTransparency = 0,
            ZIndex = 3,
            Parent = self.track,
        })
        Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.knob })
        self.knobBinding = Theme.bind(self.knob, "BackgroundColor3", "Muted")
        self.maid:Add(self.knobBinding)
        Util.new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0.22),
            }),
            Parent = self.knob,
        })

        paint(self, false)
    end,

    activate = function(self)
        if self.Disabled then
            return
        end
        self.Value = not self.Value
        paint(self, true)
        self:Emit(self.Value)
    end,

    set = function(self, value, silent)
        local target = value == true
        if target == self.Value then
            return
        end
        self.Value = target
        paint(self, true)
        if not silent then
            self:Emit(target)
        end
    end,

    disabled = function(self)
        paint(self, true)
    end,

    serialise = function(self)
        return self.Value
    end,

    deserialise = function(self, data)
        self:Set(data == true, false)
    end,
})

end
Slate_modules["elements/Slider"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local Input = require("core/Input")
local Base = require("elements/Base")
local P = require("ui/Primitives")

local CONTROL_W = 184
local VALUE_W = 54
local TRACK_H = 6
local GRIP_H = 14

local function format(self, value)
    local text = string.format("%." .. self.Decimals .. "f", value)
    if self.Suffix ~= "" then
        text ..= self.Suffix
    end
    return text
end

local function paint(self, animate)
    local alpha = Util.alpha(self.Value, self.Min, self.Max)
    local duration = animate and Motion.Duration.Fast or 0
    Motion.play(self.fill, { Size = UDim2.new(alpha, 0, 1, 0) }, {
        duration = duration,
        easing = Enum.EasingStyle.Sine,
    })
    Motion.play(self.grip, { Position = UDim2.new(alpha, 0, 0.5, 0) }, {
        duration = duration,
        easing = Enum.EasingStyle.Sine,
    })
    self.valueLabel.Text = format(self, self.Value)
end

local function quantise(self, raw)
    local value = Util.clamp(raw, self.Min, self.Max)
    if self.Step > 0 then
        value = self.Min + math.floor((value - self.Min) / self.Step + 0.5) * self.Step
    end
    value = Util.round(value, self.Decimals)
    return Util.clamp(value, self.Min, self.Max)
end

local function commit(self, raw, silent)
    local value = quantise(self, raw)
    if value == self.Value then
        paint(self, true)
        return
    end
    self.Value = value
    paint(self, true)
    if not silent then
        self:Emit(value)
    end
end

return Base.define({
    Kind = "Slider",
    controlWidth = CONTROL_W,
    hoverable = true,
    controlOnTop = true,

    build = function(self, config)
        local value = config.Value
        if type(value) == "table" then
            self.Min = Util.num(value.Min, 0)
            self.Max = Util.num(value.Max, 100)
            self.Default = Util.num(value.Default, self.Min)
        else
            self.Min = Util.num(config.Min, 0)
            self.Max = Util.num(config.Max, 100)
            self.Default = Util.num(config.Default or value, self.Min)
        end
        if self.Max <= self.Min then
            Log.warn("Slider", "Max must be greater than Min on '" .. self.Name .. "'")
            self.Max = self.Min + 1
        end
        self.Decimals = math.floor(Util.clamp(Util.num(config.Decimals, 0), 0, 4))
        self.Step = math.max(0, Util.num(config.Step, 0))
        self.Suffix = Util.str(config.Suffix, "")
        self.Default = quantise(self, self.Default)
        self.Value = self.Default

        local pill, field = P.field(self.control, { name = "Field" })
        self.pill = pill
        self.field = field
        self.maid:Add(field)

        self.valuePill = pill

        self.valueLabel = P.text({
            Name = "Value",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -P.FieldPad, 0.5, 0),
            Size = UDim2.fromOffset(VALUE_W, 16),
            TextXAlignment = Enum.TextXAlignment.Right,
            FontFace = P.Font.Mono,
            TextSize = P.Size.Small,
            Text = format(self, self.Value),
            ZIndex = 3,
            Parent = pill,
        })
        self.maid:Add(Theme.bind(self.valueLabel, "TextColor3", "Text"))

        self.trackArea = P.frame({
            Name = "TrackArea",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, P.FieldPad, 0.5, 0),
            Size = UDim2.new(1, -VALUE_W - P.FieldPad * 2 - 10, 1, 0),
            Parent = pill,
        })

        self.track = P.frame({
            Name = "Track",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, TRACK_H),
            BackgroundTransparency = 0.35,
            ClipsDescendants = true,
            Parent = self.trackArea,
        })
        P.corner(self.track, 3)
        self.maid:Add(Theme.bind(self.track, "BackgroundColor3", "Background"))

        self.fill = P.frame({
            Name = "Fill",
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 0,
            Parent = self.track,
        })
        P.corner(self.fill, 3)
        self.maid:Add(Theme.bind(self.fill, "BackgroundColor3", "Accent"))
        Util.new("UIGradient", {
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.45),
                NumberSequenceKeypoint.new(1, 0),
            }),
            Parent = self.fill,
        })

        self.grip = P.frame({
            Name = "Grip",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.fromOffset(3, GRIP_H),
            BackgroundTransparency = 0,
            ZIndex = 4,
            Parent = self.trackArea,
        })
        P.corner(self.grip, 2)
        self.maid:Add(Theme.bind(self.grip, "BackgroundColor3", "Text"))

        self.grab = P.hitbox({
            Name = "Grab",
            Size = UDim2.new(1, 12, 1, 0),
            Position = UDim2.fromOffset(-6, 0),
            ZIndex = 6,
            Parent = self.trackArea,
        })

        local dragging = false
        local dragMaid = self.maid:Extend()

        local function valueAt(x)
            local left = self.trackArea.AbsolutePosition.X
            local width = math.max(1, self.trackArea.AbsoluteSize.X)
            local alpha = Util.clamp((x - left) / width, 0, 1)
            return self.Min + alpha * (self.Max - self.Min)
        end

        local function stopDrag()
            if not dragging then
                return
            end
            dragging = false
            dragMaid:Clean()
            self.field.set("active", false)
            Motion.play(self.grip, { Size = UDim2.fromOffset(3, GRIP_H) }, {
                duration = 0.22,
                easing = Enum.EasingStyle.Back,
            })
        end

        self.maid:Add(self.grab.MouseButton1Down:Connect(function()
            if self.Disabled then
                return
            end
            dragging = true
            self.field.set("active", true)
            Motion.play(self.grip, { Size = UDim2.fromOffset(3, GRIP_H + 2) }, { duration = Motion.Duration.Fast })
            commit(self, valueAt(Input.pointerPosition().X), false)
            dragMaid:Add(Input.PointerMoved:Connect(function(position)
                if dragging then
                    commit(self, valueAt(position.X), false)
                end
            end))
            dragMaid:Add(Input.PointerUp:Connect(stopDrag))
        end))
        self.maid:Add(function()
            dragging = false
        end)

        self.maid:Add(P.interactive(self.grab, {
            render = function(state)
                self.field.set("hovered", state.hovered and not self.Disabled)
            end,
        }))

        self.editing = false
        self.valueButton = P.hitbox({
            Name = "Edit",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -P.FieldPad + 4, 0.5, 0),
            Size = UDim2.fromOffset(VALUE_W + 6, 20),
            ZIndex = 8,
            Parent = pill,
        })

        self.maid:Add(self.valueButton.MouseButton1Click:Connect(function()
            if self.Disabled or self.editing then
                return
            end
            self.editing = true
            local box = Util.new("TextBox", {
                Name = "Entry",
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -P.FieldPad, 0.5, 0),
                Size = UDim2.fromOffset(VALUE_W, 16),
                FontFace = P.Font.Mono,
                TextSize = P.Size.Small,
                TextXAlignment = Enum.TextXAlignment.Right,
                Text = string.format("%." .. self.Decimals .. "f", self.Value),
                ClearTextOnFocus = true,
                ZIndex = 9,
                Parent = pill,
            })
            local binding = Theme.bind(box, "TextColor3", "Text")
            self.valueLabel.Visible = false
            box:CaptureFocus()
            local finished
            finished = box.FocusLost:Connect(function()
                finished:Disconnect()
                local entered = tonumber(box.Text)
                if entered then
                    commit(self, entered, false)
                end
                Theme.unbind(binding)
                box:Destroy()
                self.valueLabel.Visible = true
                self.editing = false
            end)
        end))

        paint(self, false)
    end,

    set = function(self, value, silent)
        local number = Util.num(value, nil)
        if number == nil then
            Log.field("Slider", "value", value, "number")
            return
        end
        commit(self, number, silent)
    end,

    disabled = function(self, state)
        self.grab.Active = not state
        self.valueButton.Active = not state
        Motion.play(self.fill, { BackgroundTransparency = state and 0.6 or 0 }, { duration = Motion.Duration.Fast })
        Motion.play(self.grip, { BackgroundTransparency = state and 0.6 or 0 }, { duration = Motion.Duration.Fast })
    end,

    serialise = function(self)
        return self.Value
    end,

    deserialise = function(self, data)
        local number = Util.num(data, nil)
        if number then
            commit(self, number, false)
        end
    end,
})

end
Slate_modules["elements/Dropdown"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local Base = require("elements/Base")
local Scroller = require("ui/Scroller")
local Icons = require("ui/Icons")
local P = require("ui/Primitives")

local CONTROL_W = 184
local MIN_W = 96
local OPTION_H = 28
local PANEL_MAX = 232
local SEARCH_THRESHOLD = 7

local function normalise(list)
    local out = {}
    for _, entry in ipairs(list or {}) do
        if type(entry) == "table" then
            local value = entry.Value
            if value == nil then
                value = entry.Name or entry.Title
            end
            table.insert(out, {
                label = Util.str(entry.Name or entry.Title or tostring(value), tostring(value)),
                value = value,
                disabled = entry.Disabled == true,
                font = typeof(entry.Font) == "Font" and entry.Font or nil,
            })
        elseif entry ~= nil then
            table.insert(out, { label = tostring(entry), value = entry, disabled = false })
        end
    end
    return out
end

local function fontFor(self, value)
    for _, option in ipairs(self.Options) do
        if option.value == value then
            return option.font
        end
    end
    return nil
end

local function labelFor(self, value)
    for _, option in ipairs(self.Options) do
        if option.value == value then
            return option.label
        end
    end
    return tostring(value)
end

local function selectionText(self)
    if self.Multi then
        local picked = {}
        for _, value in ipairs(self.Value) do
            table.insert(picked, labelFor(self, value))
        end
        if #picked == 0 then
            return self.Placeholder, true
        end
        if #picked <= 2 then
            return table.concat(picked, ", "), false
        end
        return string.format("%d selected", #picked), false
    end
    if self.Value == nil then
        return self.Placeholder, true
    end
    return labelFor(self, self.Value), false
end

local function paint(self)
    local text, muted = selectionText(self)
    self.display.Text = text
    Theme.rebind(self.displayBinding, muted and "Muted" or "Text")
    local preview = not self.Multi and not muted and fontFor(self, self.Value) or nil
    if preview then
        P.lockFont(self.display, preview)
    else
        P.lockFont(self.display, nil)
        self.display.FontFace = P.Font.Regular
    end
    self:SetControlWidth(CONTROL_W)
end

local function isSelected(self, value)
    if self.Multi then
        return Util.indexOf(self.Value, value) ~= nil
    end
    return self.Value == value
end

local function commit(self, silent)
    paint(self)
    if not silent then
        self:Emit(self.Multi and Util.list(self.Value) or self.Value)
    end
end

local function buildPanel(self, panel, maid)
    local pad = 6
    local searchHeight = self.showSearch and 30 or 0

    local rows = Scroller.new({
        name = "Options",
        size = UDim2.new(1, -pad * 2, 1, -pad * 2 - searchHeight),
        position = UDim2.fromOffset(pad, pad + searchHeight),
        gap = 1,
    })
    rows.frame.Parent = panel
    maid:Add(rows)
    rows:SetEmptyState("No matches")

    local query = ""

    local function rebuild()
        for _, child in ipairs(rows.frame:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end
        for index, option in ipairs(self.Options) do
            if Util.matches(option.label, Util.normalise(query)) then
                local row = P.hitbox({
                    Name = "Option",
                    Size = UDim2.new(1, 0, 0, OPTION_H),
                    LayoutOrder = index,
                    ZIndex = 2,
                    Parent = rows.frame,
                })

                local text = P.text({
                    Name = "Label",
                    Position = UDim2.fromOffset(8, 0),
                    Size = UDim2.new(1, -34, 1, 0),
                    Text = option.label,
                    TextSize = P.Size.Body,
                    ZIndex = 3,
                    Parent = row,
                })
                if option.font then
                    P.lockFont(text, option.font)
                end
                local selected = isSelected(self, option.value)
                maid:Add(Theme.bind(text, "TextColor3",
                    option.disabled and "Faint" or (selected and "Accent" or "Text")))

                if selected then
                    local mark, markBindings = Icons.create("check", { size = 11, token = "Accent" })
                    if mark then
                        mark.AnchorPoint = Vector2.new(1, 0.5)
                        mark.Position = UDim2.new(1, -8, 0.5, 0)
                        mark.ZIndex = 3
                        mark.Parent = row
                        maid:AddAll(markBindings)
                    end
                end

                P.corner(row, Theme.number("RadiusSm", 3))
                local highlight = Theme.bind(row, "BackgroundColor3", "Text")
                maid:Add(highlight)
                row.BackgroundTransparency = 1

                maid:Add(P.interactive(row, {
                    render = function(state)
                        Motion.hover(row, {
                            BackgroundTransparency = (state.hovered and not option.disabled) and 0.94 or 1,
                        })
                    end,
                    onClick = function()
                        if option.disabled then
                            return
                        end
                        if self.Multi then
                            local at = Util.indexOf(self.Value, option.value)
                            if at then
                                table.remove(self.Value, at)
                            else
                                if self.Max and #self.Value >= self.Max then
                                    return
                                end
                                table.insert(self.Value, option.value)
                            end
                            commit(self, false)
                            rebuild()
                        else
                            self.Value = option.value
                            commit(self, false)
                            self.handle.Close()
                        end
                    end,
                }))
            end
        end
        rows:Refresh()
    end

    if self.showSearch then
        local search = P.frame({
            Name = "Search",
            Position = UDim2.fromOffset(pad, pad),
            Size = UDim2.new(1, -pad * 2, 0, 24),
            BackgroundTransparency = 0.5,
            Parent = panel,
        })
        P.corner(search, Theme.number("RadiusSm", 3))
        maid:Add(Theme.bind(search, "BackgroundColor3", "Surface"))

        local glyph, glyphBindings = Icons.create("search", { size = 11, token = "Faint" })
        if glyph then
            glyph.Position = UDim2.fromOffset(7, 6)
            glyph.Parent = search
            maid:AddAll(glyphBindings)
        end

        local box = Util.new("TextBox", {
            Name = "Query",
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(24, 0),
            Size = UDim2.new(1, -30, 1, 0),
            FontFace = P.Font.Regular,
            TextSize = P.Size.Body,
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "Filter",
            Text = "",
            ClearTextOnFocus = false,
            Parent = search,
        })
        maid:Add(Theme.bind(box, "TextColor3", "Text"))
        maid:Add(Theme.bind(box, "PlaceholderColor3", "Faint"))
        maid:Add(box:GetPropertyChangedSignal("Text"):Connect(function()
            query = box.Text
            rebuild()
        end))
        task.defer(function()
            if box.Parent then
                box:CaptureFocus()
            end
        end)
    end

    rebuild()
end

local function open(self)
    if self.handle and not self.handle.closed then
        self.handle.Close()
        return
    end
    local visible = #self.Options
    self.showSearch = self.Search and visible >= SEARCH_THRESHOLD
    local height = math.min(PANEL_MAX, 12 + (self.showSearch and 30 or 0) + math.max(1, visible) * (OPTION_H + 1))

    local overlay = self.window and self.window.overlay
    if not overlay then
        return
    end
    self.handle = overlay:Open({
        name = "DropdownPanel",
        anchorTo = self.pill,
        width = math.max(self.pill.AbsoluteSize.X, 160),
        height = height,
        keepOpenOver = self.pill,
        build = function(panel, maid)
            buildPanel(self, panel, maid)
        end,
        onClose = function()
            Motion.play(self.chevron, { Rotation = 0 }, { duration = Motion.Duration.Fast })
            self.field.set("active", false)
            Icons.recolour(self.chevronBindings, "Faint")
        end,
    })
    if self.handle then
        Motion.play(self.chevron, { Rotation = 180 }, { duration = Motion.Duration.Base })
        self.field.set("active", true)
        Icons.recolour(self.chevronBindings, "Text")
    end
end

return Base.define({
    Kind = "Dropdown",
    controlWidth = CONTROL_W,

    build = function(self, config)
        self.Multi = config.Multi == true
        self.Search = config.Search ~= false
        self.Placeholder = Util.str(config.Placeholder, self.Multi and "None selected" or "Select")
        self.Max = Util.num(config.Max, nil)
        self.Options = normalise(config.Options or config.Option or config.Values)

        if config.Options ~= nil and type(config.Options) ~= "table" then
            Log.field("Dropdown", "Options", config.Options, "table")
        end

        local default = config.Default
        if default == nil then
            default = config.Value
        end
        if self.Multi then
            self.Default = Util.list(default)
            self.Value = Util.list(self.Default)
        else
            self.Default = default
            self.Value = default
        end

        local pill, field = P.field(self.control, { name = "Field" })
        self.pill = pill
        self.field = field
        self.maid:Add(field)

        self.display = P.text({
            Name = "Display",
            Position = UDim2.fromOffset(P.FieldPad, 0),
            Size = UDim2.new(1, -P.FieldPad - 26, 1, 0),
            TextSize = P.Size.Body,
            Parent = self.pill,
        })
        self.displayBinding = Theme.bind(self.display, "TextColor3", "Muted")
        self.maid:Add(self.displayBinding)

        local chevron, chevronBindings = Icons.create("chevron-down", { size = 11, token = "Faint" })
        if chevron then
            chevron.AnchorPoint = Vector2.new(1, 0.5)
            chevron.Position = UDim2.new(1, -P.FieldPad, 0.5, 0)
            chevron.Parent = self.pill
            self.chevron = chevron
            self.chevronBindings = chevronBindings
            self.maid:AddAll(chevronBindings)
        end

        self.maid:Add(P.interactive(self.hitbox, {
            render = function(state)
                field.set("hovered", state.hovered and not self.Disabled)
                Icons.recolour(self.chevronBindings, (state.hovered or self.handle) and "Text" or "Faint")
            end,
        }))

        self.maid:Add(function()
            if self.handle and not self.handle.closed then
                self.handle.Close()
            end
        end)

        paint(self)
    end,

    activate = function(self)
        if self.Disabled then
            return
        end
        open(self)
    end,

    set = function(self, value, silent)
        if self.Multi then
            local list = {}
            if type(value) == "table" then
                for _, item in ipairs(value) do
                    for _, option in ipairs(self.Options) do
                        if option.value == item then
                            table.insert(list, item)
                            break
                        end
                    end
                end
            end
            self.Value = list
        else
            if value ~= nil then
                local found = false
                for _, option in ipairs(self.Options) do
                    if option.value == value then
                        found = true
                        break
                    end
                end
                if not found then
                    Log.warn("Dropdown", "value not in options on '" .. self.Name .. "'")
                    return
                end
            end
            self.Value = value
        end
        commit(self, silent)
    end,

    disabled = function(self, state)
        Motion.play(self.display, { TextTransparency = state and 0.55 or 0 }, { duration = Motion.Duration.Fast })
        if state and self.handle and not self.handle.closed then
            self.handle.Close()
        end
    end,

    serialise = function(self)
        if self.Multi then
            return Util.list(self.Value)
        end
        return self.Value
    end,

    deserialise = function(self, data)
        self:Set(data, false)
    end,

    api = {
        SetOptions = function(self, options)
            self.Options = normalise(options)
            if self.Multi then
                local kept = {}
                for _, value in ipairs(self.Value) do
                    for _, option in ipairs(self.Options) do
                        if option.value == value then
                            table.insert(kept, value)
                            break
                        end
                    end
                end
                self.Value = kept
            else
                local found = false
                for _, option in ipairs(self.Options) do
                    if option.value == self.Value then
                        found = true
                        break
                    end
                end
                if not found then
                    self.Value = nil
                end
            end
            if self.handle and not self.handle.closed then
                self.handle.Close()
            end
            paint(self)
            return self
        end,

        GetOptions = function(self)
            local out = {}
            for _, option in ipairs(self.Options) do
                table.insert(out, option.value)
            end
            return out
        end,

        Clear = function(self)
            self.Value = self.Multi and {} or nil
            commit(self, false)
            return self
        end,

        Refresh = function(self, options)
            if options then
                return self:SetOptions(options)
            end
            paint(self)
            return self
        end,

        Open = function(self)
            open(self)
            return self
        end,

        Close = function(self)
            if self.handle and not self.handle.closed then
                self.handle.Close()
            end
            return self
        end,
    },
})

end
Slate_modules["elements/Textbox"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local Base = require("elements/Base")
local P = require("ui/Primitives")

local CONTROL_W = 184

local function maskText(text)
    return string.rep("\u{2022}", #text)
end

local function render(self)
    if self.Password and not self.focused then
        self.box.Text = maskText(self.Value)
    elseif self.box.Text ~= self.Value then
        self.box.Text = self.Value
    end
end

local function validate(self, text)
    if self.Numeric then
        local number = tonumber(text)
        if number == nil then
            return false, "not a number"
        end
        if self.MinValue and number < self.MinValue then
            return false, "below minimum"
        end
        if self.MaxValue and number > self.MaxValue then
            return false, "above maximum"
        end
    end
    if self.MaxLength and #text > self.MaxLength then
        return false, "too long"
    end
    if self.Validator then
        local ok, result = pcall(self.Validator, text)
        if ok and result == false then
            return false, "rejected"
        end
        if not ok then
            Log.error("Input", result)
        end
    end
    return true
end

local function setInvalid(self, invalid)
    self.field.set("invalid", invalid)
    self.field.set("active", self.focused)
end

return Base.define({
    Kind = "Input",
    controlWidth = CONTROL_W,
    hoverable = true,

    build = function(self, config)
        self.Default = Util.str(config.Default or config.Value, "")
        self.Value = self.Default
        self.Placeholder = Util.str(config.Placeholder, "")
        self.Numeric = config.Numeric == true
        self.Password = config.Password == true
        self.MaxLength = Util.num(config.MaxLength, nil)
        self.MinValue = Util.num(config.MinValue, nil)
        self.MaxValue = Util.num(config.MaxValue, nil)
        self.Validator = Util.fn(config.Validate)
        self.OnEnter = Util.fn(config.OnEnter or config.Enter)
        self.focused = false

        local pill, field = P.field(self.control, { name = "Field" })
        self.pill = pill
        self.field = field
        self.maid:Add(field)

        self.maid:Add(P.interactive(self.hitbox, {
            render = function(state)
                field.set("hovered", state.hovered and not self.Disabled)
            end,
        }))

        self.box = Util.new("TextBox", {
            Name = "Entry",
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(P.FieldPad, 0),
            Size = UDim2.new(1, -P.FieldPad * 2, 1, 0),
            FontFace = self.Numeric and P.Font.Mono or P.Font.Regular,
            TextSize = P.Size.Body,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ClearTextOnFocus = false,
            PlaceholderText = self.Placeholder,
            Text = self.Value,
            ZIndex = 6,
            Parent = pill,
        })
        self.maid:Add(Theme.bind(self.box, "TextColor3", "Text"))
        self.maid:Add(Theme.bind(self.box, "PlaceholderColor3", "Faint"))

        self.maid:Add(self.box.Focused:Connect(function()
            self.focused = true
            if self.Password then
                self.box.Text = self.Value
            end
            setInvalid(self, false)
        end))

        self.maid:Add(self.box.FocusLost:Connect(function(enterPressed)
            self.focused = false
            local text = self.box.Text
            local ok = validate(self, text)
            if not ok then
                setInvalid(self, true)
                task.delay(1.2, function()
                    if not self.Destroyed then
                        setInvalid(self, false)
                    end
                end)
                render(self)
                return
            end
            setInvalid(self, false)
            if text ~= self.Value then
                self.Value = text
                render(self)
                self:Emit(text)
            else
                render(self)
            end
            if enterPressed and self.OnEnter then
                Util.dispatch(self.OnEnter, text, self)
            end
        end))

        self.maid:Add(self.hitbox.MouseButton1Click:Connect(function()
            if not self.Disabled then
                self.box:CaptureFocus()
            end
        end))

        render(self)
    end,

    set = function(self, value, silent)
        local text = Util.str(value, nil)
        if text == nil then
            Log.field("Input", "value", value, "string")
            return
        end
        if text == self.Value then
            return
        end
        self.Value = text
        render(self)
        if not silent then
            self:Emit(text)
        end
    end,

    disabled = function(self, state)
        self.box.TextEditable = not state
        self.box.Active = not state
        Motion.play(self.box, { TextTransparency = state and 0.55 or 0 }, { duration = Motion.Duration.Fast })
    end,

    serialise = function(self)
        return self.Value
    end,

    deserialise = function(self, data)
        self:Set(Util.str(data, ""), false)
    end,
})

end
Slate_modules["elements/Keybind"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local Input = require("core/Input")
local Base = require("elements/Base")
local P = require("ui/Primitives")

local CONTROL_W = 184
local MIN_W = 46

local MODES = { Toggle = true, Hold = true, Always = true }

local function label(self)
    if self.capturing then
        return "Press a key"
    end
    if not self.Value or not self.Value.Key then
        return "None"
    end
    return Input.describe(self.Value.Key, self.Value.Modifiers)
end

local function paint(self)
    self.text.Text = label(self)
    self:SetControlWidth(CONTROL_W)
    Theme.rebind(self.textBinding, self.capturing and "Accent" or (self.Value and self.Value.Key and "Text" or "Faint"))
    if self.field then
        self.field.set("active", self.capturing)
    end
end

local function fire(self, state)
    Util.dispatch(self.Callback, state, self)
    self.Changed:Fire(self.Value, self)
    if self.window then
        self.window._elementChanged:Fire(self, self.Value)
    end
end

return Base.define({
    Kind = "Keybind",
    controlWidth = CONTROL_W,

    build = function(self, config)
        local default = config.Default or config.Value
        local key, mods
        if typeof(default) == "EnumItem" then
            key = default
        elseif type(default) == "string" then
            local ok, code = pcall(function()
                return Enum.KeyCode[default]
            end)
            key = ok and code or nil
        elseif type(default) == "table" then
            if typeof(default.Key) == "EnumItem" then
                key = default.Key
            elseif type(default.Key) == "string" then
                local ok, code = pcall(function()
                    return Enum.KeyCode[default.Key]
                end)
                key = ok and code or nil
            end
            mods = Util.list(default.Modifiers)
        end

        self.Mode = MODES[config.Mode] and config.Mode or "Toggle"
        self.Default = { Key = key, Modifiers = mods or {} }
        self.Value = { Key = key, Modifiers = mods or {} }
        self.capturing = false
        self.held = false
        self.State = self.Mode == "Always"

        local pill, field = P.field(self.control, { name = "Field" })
        self.pill = pill
        self.field = field
        self.maid:Add(field)

        self.maid:Add(P.interactive(self.hitbox, {
            render = function(state)
                self.hovered = state.hovered
                field.set("hovered", state.hovered and not self.Disabled)
            end,
        }))

        self.text = P.text({
            Name = "Bind",
            Size = UDim2.new(1, -P.FieldPad * 2, 1, 0),
            Position = UDim2.fromOffset(P.FieldPad, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            FontFace = P.Font.Mono,
            TextSize = P.Size.Small,
            Parent = self.pill,
        })
        self.textBinding = Theme.bind(self.text, "TextColor3", "Faint")
        self.maid:Add(self.textBinding)

        self.maid:Add(function()
            if self.capturing then
                self.capturing = false
                Input.cancelCapture()
            end
        end)

        self.maid:Add(Input.KeyDown:Connect(function(keyCode, processed)
            if self.Destroyed or self.Disabled or self.capturing or processed then
                return
            end
            if not self.Value.Key or keyCode ~= self.Value.Key then
                return
            end
            for _, required in ipairs(self.Value.Modifiers) do
                if not table.find(Input.modifiers(), required) then
                    return
                end
            end
            if self.Mode == "Toggle" then
                self.State = not self.State
                fire(self, self.State)
            elseif self.Mode == "Hold" then
                self.held = true
                self.State = true
                fire(self, true)
            else
                fire(self, true)
            end
        end))

        self.maid:Add(Input.KeyUp:Connect(function(keyCode)
            if self.Mode ~= "Hold" or not self.held then
                return
            end
            if self.Value.Key and keyCode == self.Value.Key then
                self.held = false
                self.State = false
                fire(self, false)
            end
        end))

        paint(self)
    end,

    activate = function(self)
        if self.Disabled or self.capturing then
            return
        end
        self.capturing = true
        paint(self)
        Input.capture(function(input)
            self.capturing = false
            if self.Destroyed then
                return
            end
            if input.UserInputType == Enum.UserInputType.Keyboard then
                if input.KeyCode == Enum.KeyCode.Backspace or input.KeyCode == Enum.KeyCode.Delete then
                    self.Value = { Key = nil, Modifiers = {} }
                else
                    local held = Input.isModifier(input.KeyCode) and {} or Input.modifiers()
                    self.Value = { Key = input.KeyCode, Modifiers = held }
                end
            elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not self.hovered then
                    paint(self)
                    return
                end
                self.Value = { Key = input.UserInputType, Modifiers = {} }
            elseif input.UserInputType == Enum.UserInputType.MouseButton2
                or input.UserInputType == Enum.UserInputType.MouseButton3 then
                self.Value = { Key = input.UserInputType, Modifiers = {} }
            end
            paint(self)
            self.Changed:Fire(self.Value, self)
            if self.window then
                self.window._elementChanged:Fire(self, self.Value)
            end
        end)
    end,

    set = function(self, value, silent)
        if value == nil then
            self.Value = { Key = nil, Modifiers = {} }
        elseif typeof(value) == "EnumItem" then
            self.Value = { Key = value, Modifiers = {} }
        elseif type(value) == "table" then
            local key = value.Key
            if type(key) == "string" then
                local ok, code = pcall(function()
                    return Enum.KeyCode[key]
                end)
                key = ok and code or nil
            end
            self.Value = { Key = key, Modifiers = Util.list(value.Modifiers) }
        else
            Log.field("Keybind", "value", value, "EnumItem or table")
            return
        end
        paint(self)
        if not silent then
            self.Changed:Fire(self.Value, self)
        end
    end,

    disabled = function(self, state)
        Motion.play(self.text, { TextTransparency = state and 0.55 or 0 }, { duration = Motion.Duration.Fast })
    end,

    serialise = function(self)
        return {
            Key = self.Value.Key and self.Value.Key.Name or nil,
            Modifiers = self.Value.Modifiers,
            Mode = self.Mode,
        }
    end,

    deserialise = function(self, data)
        if type(data) ~= "table" then
            return
        end
        if MODES[data.Mode] then
            self.Mode = data.Mode
        end
        self:Set({ Key = data.Key, Modifiers = data.Modifiers }, true)
    end,
})

end
Slate_modules["elements/Colorpicker"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Log = require("core/Log")
local Input = require("core/Input")
local Base = require("elements/Base")
local P = require("ui/Primitives")

local CONTROL_W = 184
local PANEL_W = 202
local SV_H = 96
local PAD = 10
local BAR_H = 8
local ROW_H = 24

local SWATCHES = {
    Color3.fromRGB(214, 175, 120),
    Color3.fromRGB(226, 106, 106),
    Color3.fromRGB(226, 176, 106),
    Color3.fromRGB(126, 196, 144),
    Color3.fromRGB(120, 176, 214),
    Color3.fromRGB(150, 130, 220),
    Color3.fromRGB(214, 130, 180),
    Color3.fromRGB(236, 236, 238),
}

local function toHex(color)
    return string.format("%02X%02X%02X",
        math.round(color.R * 255),
        math.round(color.G * 255),
        math.round(color.B * 255))
end

local function fromHex(text)
    local clean = string.gsub(tostring(text), "[^%x]", "")
    if #clean == 3 then
        clean = clean:sub(1, 1):rep(2) .. clean:sub(2, 2):rep(2) .. clean:sub(3, 3):rep(2)
    end
    if #clean ~= 6 then
        return nil
    end
    local value = tonumber(clean, 16)
    if not value then
        return nil
    end
    return Color3.fromRGB(
        math.floor(value / 65536) % 256,
        math.floor(value / 256) % 256,
        value % 256
    )
end

local function paintSwatch(self)
    self.swatch.BackgroundColor3 = self.Value
    self.hexLabel.Text = "#" .. toHex(self.Value)
end

local function rainbow()
    local keypoints = {}
    for index = 0, 6 do
        local t = index / 6
        table.insert(keypoints, ColorSequenceKeypoint.new(t, Color3.fromHSV(t, 1, 1)))
    end
    return ColorSequence.new(keypoints)
end

local function buildPanel(self, panel, maid)
    local pad = PAD
    local h, s, v = self.Value:ToHSV()

    local sv = P.frame({
        Name = "SV",
        Position = UDim2.fromOffset(pad, pad),
        Size = UDim2.new(1, -pad * 2, 0, SV_H),
        BackgroundColor3 = Color3.fromHSV(h, 1, 1),
        BackgroundTransparency = 0,
        Parent = panel,
    })
    P.corner(sv, 6)

    local white = P.frame({
        Name = "Sat",
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0,
        Parent = sv,
    })
    P.corner(white, 6)
    Util.new("UIGradient", {
        Color = ColorSequence.new(Color3.new(1, 1, 1)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = white,
    })

    local black = P.frame({
        Name = "Val",
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0,
        Parent = sv,
    })
    P.corner(black, 6)
    Util.new("UIGradient", {
        Color = ColorSequence.new(Color3.new(0, 0, 0)),
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Rotation = 90,
        Parent = black,
    })

    local cursor = P.frame({
        Name = "Cursor",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.fromOffset(11, 11),
        BackgroundTransparency = 1,
        ZIndex = 4,
        Parent = sv,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = cursor })
    Util.new("UIStroke", { Thickness = 2, Color = Color3.new(1, 1, 1), Parent = cursor })
    local cursorShade = P.frame({
        Name = "Shade",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(15, 15),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = cursor,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = cursorShade })
    Util.new("UIStroke", {
        Thickness = 1,
        Color = Color3.new(0, 0, 0),
        Transparency = 0.55,
        Parent = cursorShade,
    })

    local function marker(parent, position)
        local pin = P.frame({
            Name = "Pin",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = position,
            Size = UDim2.fromOffset(6, BAR_H + 6),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0,
            ZIndex = 4,
            Parent = parent,
        })
        P.corner(pin, 3)
        Util.new("UIStroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0),
            Transparency = 0.6,
            Parent = pin,
        })
        return pin
    end

    local hueBar = P.frame({
        Name = "Hue",
        Position = UDim2.fromOffset(pad, pad + SV_H + 10),
        Size = UDim2.new(1, -pad * 2, 0, BAR_H),
        BackgroundTransparency = 0,
        BackgroundColor3 = Color3.new(1, 1, 1),
        Parent = panel,
    })
    P.corner(hueBar, 4)
    Util.new("UIGradient", { Color = rainbow(), Parent = hueBar })
    local hueCursor = marker(hueBar, UDim2.new(h, 0, 0.5, 0))

    local alphaBar, alphaCursor
    local cursorY = pad + SV_H + 10 + BAR_H
    if self.UseAlpha then
        alphaBar = P.frame({
            Name = "Alpha",
            Position = UDim2.fromOffset(pad, cursorY + 10),
            Size = UDim2.new(1, -pad * 2, 0, BAR_H),
            BackgroundTransparency = 0,
            BackgroundColor3 = Color3.new(1, 1, 1),
            Parent = panel,
        })
        P.corner(alphaBar, 4)
        Util.new("UIGradient", {
            Color = ColorSequence.new(Color3.new(0, 0, 0), self.Value),
            Parent = alphaBar,
        })
        alphaCursor = marker(alphaBar, UDim2.new(self.Alpha, 0, 0.5, 0))
        cursorY = cursorY + 10 + BAR_H
    end

    local fieldsY = cursorY + 12

    local hexField, hexHandle = P.field(panel, {
        name = "Hex",
        anchor = Vector2.new(0, 0),
        position = UDim2.fromOffset(pad, fieldsY),
        size = UDim2.new(1, -pad * 2, 0, ROW_H),
    })
    maid:Add(hexHandle)

    local preview = P.frame({
        Name = "Preview",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, P.FieldPad, 0.5, 0),
        Size = UDim2.fromOffset(14, 14),
        BackgroundColor3 = self.Value,
        BackgroundTransparency = 0,
        ZIndex = 3,
        Parent = hexField,
    })
    P.corner(preview, 4)
    Util.new("UIStroke", {
        Thickness = 1,
        Color = Color3.new(0, 0, 0),
        Transparency = 0.7,
        Parent = preview,
    })

    local hexBox = Util.new("TextBox", {
        Name = "Entry",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(P.FieldPad + 22, 0),
        Size = UDim2.new(1, -P.FieldPad * 2 - 22, 1, 0),
        FontFace = P.Font.Mono,
        TextSize = P.Size.Small,
        TextXAlignment = Enum.TextXAlignment.Left,
        Text = "#" .. toHex(self.Value),
        ClearTextOnFocus = false,
        ZIndex = 3,
        Parent = hexField,
    })
    maid:Add(Theme.bind(hexBox, "TextColor3", "Text"))
    maid:Add(hexBox.Focused:Connect(function()
        hexHandle.set("active", true)
    end))

    local swatchRow = P.frame({
        Name = "Swatches",
        Position = UDim2.fromOffset(pad, fieldsY + ROW_H + 10),
        Size = UDim2.new(1, -pad * 2, 0, 14),
        Parent = panel,
    })
    P.list(swatchRow, { horizontal = true, gap = 6, valign = Enum.VerticalAlignment.Center })

    local function refresh(fromHexBox)
        self.Value = Color3.fromHSV(h, s, v)
        sv.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
        cursor.Position = UDim2.fromScale(s, 1 - v)
        hueCursor.Position = UDim2.new(h, 0, 0.5, 0)
        preview.BackgroundColor3 = self.Value
        if alphaBar then
            alphaBar:FindFirstChildOfClass("UIGradient").Color =
                ColorSequence.new(Color3.new(0, 0, 0), self.Value)
            alphaCursor.Position = UDim2.new(self.Alpha, 0, 0.5, 0)
        end
        if not fromHexBox then
            hexBox.Text = "#" .. toHex(self.Value)
        end
        paintSwatch(self)
        self:Emit(self.Value)
    end

    for _, colour in ipairs(SWATCHES) do
        local dot = P.hitbox({
            Name = "Swatch",
            Size = UDim2.fromOffset(14, 14),
            BackgroundTransparency = 0,
            BackgroundColor3 = colour,
            Parent = swatchRow,
        })
        Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
        Util.new("UIStroke", {
            Thickness = 1,
            Color = Color3.new(0, 0, 0),
            Transparency = 0.72,
            Parent = dot,
        })
        maid:Add(dot.MouseButton1Click:Connect(function()
            h, s, v = colour:ToHSV()
            refresh(false)
        end))
    end

    local dragMaid = maid:Extend()

    local function drag(target, apply)
        local grab = P.hitbox({
            Name = "Grab",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.new(1, 0, 1, 10),
            ZIndex = 8,
            Parent = target,
        })
        maid:Add(grab.MouseButton1Down:Connect(function()
            apply(Input.pointerPosition())
            dragMaid:Clean()
            dragMaid:Add(Input.PointerMoved:Connect(apply))
            dragMaid:Add(Input.PointerUp:Connect(function()
                dragMaid:Clean()
            end))
        end))
    end

    drag(sv, function(position)
        local origin = sv.AbsolutePosition
        local size = sv.AbsoluteSize
        s = Util.clamp((position.X - origin.X) / math.max(1, size.X), 0, 1)
        v = 1 - Util.clamp((position.Y - origin.Y) / math.max(1, size.Y), 0, 1)
        refresh(false)
    end)

    drag(hueBar, function(position)
        local origin = hueBar.AbsolutePosition
        local size = hueBar.AbsoluteSize
        h = Util.clamp((position.X - origin.X) / math.max(1, size.X), 0, 1)
        refresh(false)
    end)

    if alphaBar then
        drag(alphaBar, function(position)
            local origin = alphaBar.AbsolutePosition
            local size = alphaBar.AbsoluteSize
            self.Alpha = Util.clamp((position.X - origin.X) / math.max(1, size.X), 0, 1)
            refresh(false)
        end)
    end

    maid:Add(hexBox.FocusLost:Connect(function()
        hexHandle.set("active", false)
        local parsed = fromHex(hexBox.Text)
        if parsed then
            h, s, v = parsed:ToHSV()
            refresh(true)
        else
            hexBox.Text = "#" .. toHex(self.Value)
        end
    end))

    cursor.Position = UDim2.fromScale(s, 1 - v)
end

local function open(self)
    if self.handle and not self.handle.closed then
        self.handle.Close()
        return
    end
    local height = PAD + SV_H + 10 + BAR_H
        + (self.UseAlpha and (10 + BAR_H) or 0)
        + 12 + ROW_H + 10 + 14 + PAD
    local overlay = self.window and self.window.overlay
    if not overlay then
        return
    end
    self.handle = overlay:Open({
        name = "ColourPanel",
        anchorTo = self.pill,
        width = PANEL_W,
        height = height,
        keepOpenOver = self.pill,
        clip = false,
        build = function(panel, maid)
            buildPanel(self, panel, maid)
        end,
        onClose = function()
            self.field.set("active", false)
        end,
    })
    if self.handle then
        self.field.set("active", true)
    end
end

return Base.define({
    Kind = "Colorpicker",
    controlWidth = CONTROL_W,

    build = function(self, config)
        local default = config.Default or config.Value or config.Color
        if typeof(default) ~= "Color3" then
            if default ~= nil then
                Log.field("Colorpicker", "Default", default, "Color3")
            end
            default = Theme.color("Accent")
        end
        self.Default = default
        self.Value = default
        self.UseAlpha = config.Alpha == true
        self.Alpha = Util.clamp(Util.num(config.DefaultAlpha, 1), 0, 1)

        local pill, field = P.field(self.control, { name = "Field" })
        self.pill = pill
        self.field = field
        self.maid:Add(field)

        self.maid:Add(P.interactive(self.hitbox, {
            render = function(state)
                field.set("hovered", state.hovered and not self.Disabled)
            end,
        }))

        self.hexLabel = P.text({
            Name = "Hex",
            Position = UDim2.fromOffset(P.FieldPad, 0),
            Size = UDim2.new(1, -P.FieldPad * 2 - 26, 1, 0),
            FontFace = P.Font.Mono,
            TextSize = P.Size.Small,
            Parent = pill,
        })
        self.maid:Add(Theme.bind(self.hexLabel, "TextColor3", "Text"))

        self.swatch = P.frame({
            Name = "Swatch",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -P.FieldPad, 0.5, 0),
            Size = UDim2.fromOffset(22, 14),
            BackgroundTransparency = 0,
            ZIndex = 3,
            Parent = pill,
        })
        P.corner(self.swatch, 4)
        local _, strokeBinding = P.stroke(self.swatch, "Border", 1, Theme.number("BorderT", 0.9) - 0.3)
        self.maid:Add(strokeBinding)

        self.maid:Add(function()
            if self.handle and not self.handle.closed then
                self.handle.Close()
            end
        end)

        paintSwatch(self)
    end,

    activate = function(self)
        if self.Disabled then
            return
        end
        open(self)
    end,

    set = function(self, value, silent)
        if typeof(value) ~= "Color3" then
            Log.field("Colorpicker", "value", value, "Color3")
            return
        end
        self.Value = value
        paintSwatch(self)
        if not silent then
            self:Emit(value)
        end
    end,

    disabled = function(self, state)
        Motion.play(self.swatch, { BackgroundTransparency = state and 0.5 or 0 }, {
            duration = Motion.Duration.Fast,
        })
    end,

    serialise = function(self)
        return { Hex = toHex(self.Value), Alpha = self.Alpha }
    end,

    deserialise = function(self, data)
        if type(data) == "table" then
            local parsed = fromHex(data.Hex)
            if parsed then
                self:Set(parsed, false)
            end
            self.Alpha = Util.clamp(Util.num(data.Alpha, 1), 0, 1)
        elseif typeof(data) == "Color3" then
            self:Set(data, false)
        end
    end,

    api = {
        Open = function(self)
            open(self)
            return self
        end,
        Close = function(self)
            if self.handle and not self.handle.closed then
                self.handle.Close()
            end
            return self
        end,
        GetAlpha = function(self)
            return self.Alpha
        end,
        SetAlpha = function(self, value)
            self.Alpha = Util.clamp(Util.num(value, 1), 0, 1)
            return self
        end,
        GetHex = function(self)
            return toHex(self.Value)
        end,
    },
})

end
Slate_modules["elements/Static"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Base = require("elements/Base")
local Icons = require("ui/Icons")
local P = require("ui/Primitives")

local Static = {}

Static.Label = Base.define({
    Kind = "Label",
    controlWidth = 0,
    hoverable = false,

    height = function()
        return 26
    end,

    build = function(self, config)
        self.Value = self.Name
        self.Default = self.Name
        self.nameLabel.FontFace = P.Font.Regular
        self.nameLabel.TextSize = P.Size.Body
        self.left.Size = UDim2.new(1, 0, 1, 0)
    end,

    set = function(self, value)
        self:SetName(Util.str(value, self.Name))
        self.Value = self.Name
    end,

    serialise = function()
        return nil
    end,
})

Static.Paragraph = Base.define({
    Kind = "Paragraph",
    controlWidth = 0,
    hoverable = false,

    build = function(self, config)
        self.Value = Util.str(config.Text or config.Content or config.Body, "")
        self.Default = self.Value

        self.left.Size = UDim2.new(1, 0, 1, 0)
        self.nameLabel.Size = UDim2.new(1, 0, 0, 17)
        self.nameLabel.Position = UDim2.fromOffset(0, 8)
        self.nameLabel.TextYAlignment = Enum.TextYAlignment.Top

        self.body = P.text({
            Name = "Body",
            Position = UDim2.fromOffset(0, 27),
            Size = UDim2.new(1, 0, 0, 16),
            Text = self.Value,
            TextSize = P.Size.Body,
            TextWrapped = true,
            TextTruncate = Enum.TextTruncate.None,
            TextYAlignment = Enum.TextYAlignment.Top,
            Parent = self.left,
        })
        self.maid:Add(Theme.bind(self.body, "TextColor3", "Muted"))

        self.wrap = P.autowrap(self.body, {
            host = self.left,
            onChange = function()
                self:_layout()
            end,
        })
        self.maid:Add(self.wrap)
    end,

    height = function(self)
        local bodyHeight = self.body and self.body.Size.Y.Offset or 0
        return math.max(44, 34 + bodyHeight)
    end,

    set = function(self, value)
        self.Value = Util.str(value, "")
        if self.body then
            self.body.Text = self.Value
        end
        if self.wrap then
            self.wrap.Refresh()
        end
        self:_layout()
    end,

    serialise = function()
        return nil
    end,
})

Static.Divider = Base.define({
    Kind = "Divider",
    controlWidth = 0,
    hoverable = false,

    height = function()
        return 22
    end,

    build = function(self, config)
        self.Value = nil
        self.nameLabel.Visible = false

        local caption = Util.str(config.Name or config.Title, nil)
        local rule = P.frame({
            Name = "Rule",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 0, 1),
            BackgroundTransparency = Theme.number("LineT", 0.94) - 0.02,
            Parent = self.row,
        })
        self.maid:Add(Theme.bind(rule, "BackgroundColor3", "Line"))
        self.rule = rule

        if caption and caption ~= "" and caption ~= "Divider" then
            local label = P.text({
                Name = "Caption",
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 0),
                Size = UDim2.new(0, 0, 0, 16),
                AutomaticSize = Enum.AutomaticSize.X,
                Text = caption,
                TextSize = P.Size.Micro,
                FontFace = P.Font.Medium,
                ZIndex = 3,
                Parent = self.row,
            })
            self.maid:Add(Theme.bind(label, "TextColor3", "Faint"))
            self.caption = label

            local function place()
                if self.Destroyed then
                    return
                end
                local width = math.ceil(P.measure(label.Text, label.FontFace, label.TextSize).X) + 10
                rule.Position = UDim2.new(0, width, 0.5, 0)
                rule.Size = UDim2.new(1, -width, 0, 1)
            end
            place()
            self.maid:Add(P.FontChanged:Connect(place))
        end
    end,

    serialise = function()
        return nil
    end,
})

Static.Stat = Base.define({
    Kind = "Stat",
    controlWidth = 150,
    hoverable = false,

    height = function()
        return 30
    end,

    build = function(self, config)
        self.Value = Util.str(config.Value or config.Text, "")
        self.Default = self.Value
        self.nameLabel.FontFace = P.Font.Regular
        self.nameLabel.TextSize = P.Size.Body
        self.maid:Add(Theme.bind(self.nameLabel, "TextColor3", "Muted"))

        self.valueLabel = P.text({
            Name = "Value",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, 0, 0.5, 0),
            Size = UDim2.new(1, 0, 1, 0),
            TextXAlignment = Enum.TextXAlignment.Right,
            FontFace = P.Font.Mono,
            TextSize = P.Size.Small,
            Text = self.Value,
            Parent = self.control,
        })
        self.maid:Add(Theme.bind(self.valueLabel, "TextColor3", "Text"))
    end,

    set = function(self, value)
        self.Value = Util.str(value, tostring(value))
        self.valueLabel.Text = self.Value
    end,

    serialise = function()
        return nil
    end,
})

Static.Card = Base.define({
    Kind = "Card",
    controlWidth = 0,
    hoverable = false,

    height = function()
        return 66
    end,

    build = function(self, config)
        self.Value = Util.str(config.Value, "")
        self.Tone = Util.str(config.Tone, "Accent")
        self.nameLabel.Visible = false
        self.left.Size = UDim2.new(1, 0, 1, 0)

        local card = P.frame({
            Name = "Card",
            Size = UDim2.new(1, 0, 1, -6),
            Position = UDim2.fromOffset(0, 3),
            BackgroundTransparency = 0,
            Parent = self.row,
        })
        P.corner(card, Theme.number("Radius", 5) + 3)
        self.maid:Add(Theme.bind(card, "BackgroundColor3", "Surface"))
        self.card = card

        local tint = P.frame({
            Name = "Tint",
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 0.9,
            Parent = card,
        })
        P.corner(tint, Theme.number("Radius", 5) + 3)
        self.tintBinding = Theme.bind(tint, "BackgroundColor3", self.Tone)
        self.maid:Add(self.tintBinding)
        Util.new("UIGradient", {
            Rotation = 35,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(0.7, 0.65),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = tint,
        })

        local stroke, strokeBinding = P.stroke(card, self.Tone, 1, 0.78)
        self.accentBinding = strokeBinding
        self.maid:Add(strokeBinding)
        self.stroke = stroke

        local badgeWidth = config.Icon and 46 or 0

        local block = P.frame({
            Name = "Text",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, 15, 0.5, 0),
            Size = UDim2.new(1, -30 - badgeWidth, 0, 38),
            ZIndex = 3,
            Parent = card,
        })

        self.caption = P.text({
            Name = "Caption",
            Size = UDim2.new(1, 0, 0, 13),
            Text = string.upper(self.Name),
            TextSize = P.Size.Micro,
            FontFace = P.Font.Medium,
            ZIndex = 3,
            Parent = block,
        })
        self.maid:Add(Theme.bind(self.caption, "TextColor3", "Muted"))

        self.big = P.text({
            Name = "Value",
            Position = UDim2.fromOffset(0, 15),
            Size = UDim2.new(1, 0, 0, 23),
            Text = self.Value,
            TextSize = 18,
            TextTruncate = Enum.TextTruncate.AtEnd,
            FontFace = P.Font.Display,
            ZIndex = 3,
            Parent = block,
        })
        self.maid:Add(Theme.bind(self.big, "TextColor3", "Text"))

        local STEPS = { 18, 17, 16, 15, 14, 13, 12, 11 }
        local function fit()
            if self.Destroyed or not self.big.Parent then
                return
            end
            local width = self.big.AbsoluteSize.X
            if width <= 0 then
                return
            end
            for _, size in ipairs(STEPS) do
                local bounds = P.measure(self.big.Text, self.big.FontFace, size)
                if bounds.X <= width then
                    self.big.TextSize = size
                    return
                end
            end
            self.big.TextSize = STEPS[#STEPS]
        end
        self._fitValue = function()
            task.defer(fit)
        end
        self.maid:Add(self.big:GetPropertyChangedSignal("AbsoluteSize"):Connect(self._fitValue))
        self.maid:Add(P.FontChanged:Connect(self._fitValue))
        self._fitValue()

        if config.Icon or config.Image then
            local badge = P.frame({
                Name = "Badge",
                AnchorPoint = Vector2.new(1, 0.5),
                Position = UDim2.new(1, -13, 0.5, 0),
                Size = UDim2.fromOffset(34, 34),
                BackgroundTransparency = 0.72,
                ClipsDescendants = true,
                ZIndex = 3,
                Parent = card,
            })
            P.corner(badge, 10)
            self.badge = badge
            self.badgeBinding = Theme.bind(badge, "BackgroundColor3", self.Tone)
            self.maid:Add(self.badgeBinding)

            if config.Icon then
                local glyph, bindings = Icons.create(config.Icon, { size = 18, token = self.Tone })
                if glyph then
                    glyph.AnchorPoint = Vector2.new(0.5, 0.5)
                    glyph.Position = UDim2.fromScale(0.5, 0.5)
                    glyph.ZIndex = 4
                    glyph.Parent = badge
                    self.badgeGlyph = glyph
                    self.maid:AddAll(bindings)
                end
            end

            if config.Image then
                self:SetImage(config.Image)
            end
        end
    end,

    set = function(self, value)
        self.Value = Util.str(value, tostring(value))
        self.big.Text = self.Value
        if self._fitValue then
            self._fitValue()
        end
    end,

    api = {
        SetTone = function(self, tone)
            self.Tone = tone
            Theme.rebind(self.tintBinding, tone)
            Theme.rebind(self.accentBinding, tone)
            if self.badgeBinding then
                Theme.rebind(self.badgeBinding, tone)
            end
            return self
        end,

        SetImage = function(self, image)
            if not self.badge then
                return self
            end
            if type(image) ~= "string" or image == "" then
                if self.badgeImage then
                    self.badgeImage.Visible = false
                end
                if self.badgeGlyph then
                    self.badgeGlyph.Visible = true
                end
                self.badge.BackgroundTransparency = 0.72
                return self
            end
            if not self.badgeImage then
                self.badgeImage = P.image({
                    Name = "Thumb",
                    Size = UDim2.fromScale(1, 1),
                    ScaleType = Enum.ScaleType.Crop,
                    ZIndex = 4,
                    Parent = self.badge,
                })
                P.corner(self.badgeImage, 10)
            end
            self.badgeImage.Image = image
            self.badgeImage.Visible = true
            if self.badgeGlyph then
                self.badgeGlyph.Visible = false
            end
            self.badge.BackgroundTransparency = 0.4
            return self
        end,
    },

    serialise = function()
        return nil
    end,
})

Static.Action = Base.define({
    Kind = "Action",
    controlWidth = 0,

    height = function()
        return 52
    end,

    build = function(self, config)
        self.Value = nil
        self.nameLabel.Visible = false
        self.left.Size = UDim2.new(1, 0, 1, 0)

        local tile = P.frame({
            Name = "Tile",
            Size = UDim2.new(1, 0, 1, -6),
            Position = UDim2.fromOffset(0, 3),
            BackgroundTransparency = 0.35,
            Parent = self.row,
        })
        P.corner(tile, Theme.number("Radius", 5))
        self.maid:Add(Theme.bind(tile, "BackgroundColor3", "Surface"))
        local _, tileStroke = P.stroke(tile, "Border", 1, Theme.number("BorderT", 0.9))
        self.maid:Add(tileStroke)
        self.tile = tile

        local glyph, bindings = Icons.create(config.Icon or "dot", { size = 15, token = "Accent" })
        if glyph then
            glyph.Position = UDim2.fromOffset(13, 11)
            glyph.Parent = tile
            self.maid:AddAll(bindings)
        end

        self.title = P.text({
            Name = "Title",
            Position = UDim2.fromOffset(13, 28),
            Size = UDim2.new(1, -26, 0, 14),
            Text = self.Name,
            TextSize = P.Size.Body,
            FontFace = P.Font.Medium,
            Parent = tile,
        })
        self.maid:Add(Theme.bind(self.title, "TextColor3", "Text"))

        self.hitbox.ZIndex = 8
        if self.hover then
            self.hover.Destroy()
        end
        self.hover = P.interactive(self.hitbox, {
            render = function(state)
                Motion.hover(tile, {
                    BackgroundTransparency = state.hovered and 0 or 0.35,
                    Position = state.pressed and UDim2.fromOffset(0, 4) or UDim2.fromOffset(0, 3),
                })
            end,
            onClick = function()
                if self.Disabled then
                    return
                end
                Util.dispatch(self.Callback, self)
                self.Changed:Fire(true, self)
            end,
        })
        self.maid:Add(self.hover)
    end,

    set = function()
    end,

    serialise = function()
        return nil
    end,
})

return Static

end
Slate_modules["elements/Progress"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Base = require("elements/Base")
local P = require("ui/Primitives")

local CONTROL_W = 184
local VALUE_W = 42
local TRACK_H = 6

local function paint(self, animate)
    local duration = animate and Motion.Duration.Base or 0
    Motion.play(self.fill, { Size = UDim2.new(self.Value, 0, 1, 0) }, {
        duration = duration,
        easing = Enum.EasingStyle.Quint,
    })
    self.valueLabel.Text = string.format("%d%%", math.floor(self.Value * 100 + 0.5))
end

return Base.define({
    Kind = "Progress",
    controlWidth = CONTROL_W,
    hoverable = false,

    build = function(self, config)
        self.Default = Util.clamp(Util.num(config.Default or config.Value, 0), 0, 1)
        self.Value = self.Default
        self.Indeterminate = false

        local pill, field = P.field(self.control, { name = "Field" })
        self.pill = pill
        self.field = field
        self.maid:Add(field)

        self.valueLabel = P.text({
            Name = "Value",
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -P.FieldPad, 0.5, 0),
            Size = UDim2.fromOffset(VALUE_W, 16),
            TextXAlignment = Enum.TextXAlignment.Right,
            FontFace = P.Font.Mono,
            TextSize = P.Size.Small,
            ZIndex = 3,
            Parent = pill,
        })
        self.maid:Add(Theme.bind(self.valueLabel, "TextColor3", "Text"))

        self.track = P.frame({
            Name = "Track",
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, P.FieldPad, 0.5, 0),
            Size = UDim2.new(1, -VALUE_W - P.FieldPad * 2 - 10, 0, TRACK_H),
            BackgroundTransparency = 0.35,
            ClipsDescendants = true,
            Parent = pill,
        })
        P.corner(self.track, 3)
        self.maid:Add(Theme.bind(self.track, "BackgroundColor3", "Background"))

        self.fill = P.frame({
            Name = "Fill",
            Size = UDim2.new(0, 0, 1, 0),
            BackgroundTransparency = 0,
            Parent = self.track,
        })
        P.corner(self.fill, 3)
        self.maid:Add(Theme.bind(self.fill, "BackgroundColor3", Util.str(config.Tone, "Accent")))

        paint(self, false)
    end,

    set = function(self, value, silent)
        local number = Util.num(value, nil)
        if number == nil then
            return
        end
        if number > 1 then
            number /= 100
        end
        number = Util.clamp(number, 0, 1)
        if number == self.Value then
            return
        end
        self.Value = number
        paint(self, true)
        if not silent then
            self:Emit(number)
        end
    end,

    api = {
        SetIndeterminate = function(self, state)
            local wanted = state == true
            if self.Indeterminate == wanted then
                return self
            end
            self.Indeterminate = wanted
            if not wanted then
                Motion.cancel(self.fill)
                self.fill.Position = UDim2.fromScale(0, 0)
                paint(self, true)
                self.valueLabel.Visible = true
                return self
            end
            self.valueLabel.Visible = false
            self.fill.Size = UDim2.new(0.3, 0, 1, 0)
            local function cycle()
                if self.Destroyed or not self.Indeterminate then
                    return
                end
                self.fill.Position = UDim2.fromScale(-0.3, 0)
                Motion.play(self.fill, { Position = UDim2.fromScale(1, 0) }, {
                    duration = 0.9,
                    easing = Enum.EasingStyle.Sine,
                    direction = Enum.EasingDirection.InOut,
                    onDone = function()
                        cycle()
                    end,
                })
            end
            cycle()
            return self
        end,

        SetTone = function(self, tone)
            Theme.bind(self.fill, "BackgroundColor3", tone)
            return self
        end,
    },

    serialise = function()
        return nil
    end,
})

end
Slate_modules["elements/Invite"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Base = require("elements/Base")
local Icons = require("ui/Icons")
local P = require("ui/Primitives")

local BANNER_H = 64
local RADIUS = 10
local AVATAR = 58
local HEIGHT = 244
local JOIN = Color3.fromRGB(35, 165, 90)

local function count(value)
    local number = Util.num(value, nil)
    if not number then
        return Util.str(value, "0")
    end
    if number >= 1000 then
        local thousands = math.floor(number / 1000)
        local rest = number % 1000
        return string.format("%d,%03d", thousands, rest)
    end
    return tostring(math.floor(number))
end

local function tone(value, fallback)
    if typeof(value) == "Color3" then
        return value, nil
    end
    local token = Util.str(value, fallback)
    return Theme.color(token), token
end

local function statusDot(parent, colour, x, y)
    local dot = P.frame({
        Name = "Dot",
        Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(8, 8),
        BackgroundColor3 = colour,
        BackgroundTransparency = 0,
        ZIndex = 4,
        Parent = parent,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
    return dot
end

return Base.define({
    Kind = "Invite",
    controlWidth = 0,
    hoverable = false,

    height = function()
        return HEIGHT
    end,

    build = function(self, config)
        self.Value = nil
        self.nameLabel.Visible = false
        self.left.Size = UDim2.new(1, 0, 1, 0)
        self.Url = Util.str(config.Url or config.Invite, nil)

        local card = P.frame({
            Name = "Invite",
            Size = UDim2.new(1, 0, 1, -10),
            Position = UDim2.fromOffset(0, 5),
            BackgroundTransparency = 0,
            ClipsDescendants = true,
            Parent = self.row,
        })
        P.corner(card, RADIUS)
        self.maid:Add(Theme.bind(card, "BackgroundColor3", "Surface"))
        local _, cardStroke = P.stroke(card, "Border", 1, Theme.number("BorderT", 0.9))
        self.maid:Add(cardStroke)
        self.card = card

        local bannerClip = P.frame({
            Name = "BannerClip",
            Size = UDim2.new(1, 0, 0, BANNER_H),
            ClipsDescendants = true,
            Parent = card,
        })

        local banner = P.frame({
            Name = "Banner",
            Size = UDim2.new(1, 0, 0, BANNER_H + RADIUS + 4),
            BackgroundTransparency = 0,
            Parent = bannerClip,
        })
        P.corner(banner, RADIUS)
        local toneColour, toneToken = tone(config.Tone, "Accent")
        self.ToneColour = toneColour
        if toneToken then
            self.bannerBinding = Theme.bind(banner, "BackgroundColor3", toneToken)
            self.maid:Add(self.bannerBinding)
        else
            banner.BackgroundColor3 = toneColour
        end

        if Util.str(config.Banner, nil) then
            local image = P.image({
                Name = "Art",
                Size = UDim2.fromScale(1, 1),
                Image = config.Banner,
                ScaleType = Enum.ScaleType.Crop,
                Parent = banner,
            })
            self.bannerImage = image
        else
            Util.new("UIGradient", {
                Rotation = 18,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 120, 140)),
                }),
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.15),
                    NumberSequenceKeypoint.new(1, 0.62),
                }),
                Parent = banner,
            })
        end

        local avatarRing = P.frame({
            Name = "AvatarRing",
            Position = UDim2.fromOffset(14, BANNER_H - AVATAR / 2 - 4),
            Size = UDim2.fromOffset(AVATAR + 8, AVATAR + 8),
            BackgroundTransparency = 0,
            ZIndex = 3,
            Parent = card,
        })
        P.corner(avatarRing, 18)
        self.maid:Add(Theme.bind(avatarRing, "BackgroundColor3", "Surface"))

        local avatar = P.frame({
            Name = "Avatar",
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(AVATAR, AVATAR),
            BackgroundTransparency = 0,
            ClipsDescendants = true,
            ZIndex = 4,
            Parent = avatarRing,
        })
        P.corner(avatar, 14)
        self.maid:Add(Theme.bind(avatar, "BackgroundColor3", "Elevated"))

        if Util.str(config.Icon, nil) and string.find(tostring(config.Icon), "://") then
            -- UICorner on the parent does not clip children, so the artwork needs
            -- its own rounding or its square corners poke out of the avatar
            local art = P.image({
                Name = "Art",
                AnchorPoint = Vector2.new(0.5, 0.5),
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromScale(1, 1),
                Image = config.Icon,
                ScaleType = Enum.ScaleType.Crop,
                ZIndex = 5,
                Parent = avatar,
            })
            P.corner(art, 14)
        else
            Util.new("UIGradient", {
                Rotation = 45,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, toneColour),
                    ColorSequenceKeypoint.new(1, toneColour:Lerp(Color3.new(0, 0, 0), 0.45)),
                }),
                Parent = avatar,
            })

            if config.Glyph then
                local glyph, bindings = Icons.create(config.Glyph, { size = 26, token = "Text" })
                if glyph then
                    glyph.AnchorPoint = Vector2.new(0.5, 0.5)
                    glyph.Position = UDim2.fromScale(0.5, 0.5)
                    glyph.ZIndex = 5
                    glyph.Parent = avatar
                    self.maid:AddAll(bindings)
                end
            else
                local initials = P.text({
                    Name = "Initials",
                    Size = UDim2.fromScale(1, 1),
                    Text = string.upper(string.sub(self.Name, 1, 2)),
                    TextSize = 22,
                    FontFace = P.Font.Display,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextColor3 = Color3.new(1, 1, 1),
                    ZIndex = 5,
                    Parent = avatar,
                })
                self.initials = initials
            end
        end

        local textTop = BANNER_H + AVATAR / 2 + 12

        self.title = P.text({
            Name = "Server",
            Position = UDim2.fromOffset(16, textTop),
            Size = UDim2.new(1, -32, 0, 20),
            Text = self.Name,
            TextSize = 15,
            FontFace = P.Font.Bold,
            ZIndex = 4,
            Parent = card,
        })
        self.maid:Add(Theme.bind(self.title, "TextColor3", "Text"))

        local stats = P.frame({
            Name = "Stats",
            Position = UDim2.fromOffset(16, textTop + 22),
            Size = UDim2.new(1, -32, 0, 14),
            ZIndex = 4,
            Parent = card,
        })
        P.list(stats, { horizontal = true, gap = 14, valign = Enum.VerticalAlignment.Center })

        local function stat(order, colour, text)
            local group = P.frame({
                Name = "Stat",
                Size = UDim2.fromOffset(0, 14),
                AutomaticSize = Enum.AutomaticSize.X,
                LayoutOrder = order,
                ZIndex = 4,
                Parent = stats,
            })
            statusDot(group, colour, 0, 3)
            local label = P.text({
                Name = "Label",
                Position = UDim2.fromOffset(13, 0),
                Size = UDim2.fromOffset(0, 14),
                AutomaticSize = Enum.AutomaticSize.X,
                Text = text,
                TextSize = P.Size.Small,
                TextTruncate = Enum.TextTruncate.None,
                ZIndex = 4,
                Parent = group,
            })
            self.maid:Add(Theme.bind(label, "TextColor3", "Muted"))
            return label
        end

        if type(config.Stats) == "table" then
            for index, entry in ipairs(config.Stats) do
                stat(index,
                    typeof(entry.Dot) == "Color3" and entry.Dot or Color3.fromRGB(128, 132, 142),
                    Util.str(entry.Text, ""))
            end
        else
            self.onlineLabel = stat(1, Color3.fromRGB(59, 165, 93), count(config.Online or 0) .. " Online")
            self.membersLabel = stat(2, Color3.fromRGB(128, 132, 142), count(config.Members or 0) .. " Members")
        end

        local created = Util.str(config.Created, nil)
        if created then
            self.created = P.text({
                Name = "Created",
                Position = UDim2.fromOffset(16, textTop + 42),
                Size = UDim2.new(1, -32, 0, 13),
                Text = "Created " .. created,
                TextSize = P.Size.Micro,
                ZIndex = 4,
                Parent = card,
            })
            self.maid:Add(Theme.bind(self.created, "TextColor3", "Faint"))
        end

        local button = P.hitbox({
            Name = "Join",
            AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -14),
            Size = UDim2.new(1, -32, 0, 36),
            BackgroundColor3 = typeof(config.ButtonColor) == "Color3" and config.ButtonColor or JOIN,
            BackgroundTransparency = 0,
            ZIndex = 6,
            Parent = card,
        })
        P.corner(button, 7)
        self.button = button

        local label = P.text({
            Name = "Label",
            Size = UDim2.fromScale(1, 1),
            Text = Util.str(config.ButtonText, "Join Server"),
            TextSize = P.Size.Label,
            FontFace = P.Font.Bold,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextColor3 = Color3.new(1, 1, 1),
            ZIndex = 7,
            Parent = button,
        })
        self.buttonLabel = label

        self.maid:Add(P.interactive(button, {
            render = function(state)
                Motion.hover(button, {
                    BackgroundTransparency = state.pressed and 0.25 or (state.hovered and 0.12 or 0),
                })
            end,
            onClick = function()
                if self.Url and typeof(setclipboard) == "function" then
                    pcall(setclipboard, self.Url)
                end
                Util.dispatch(self.Callback, self.Url, self)
                self.Changed:Fire(self.Url, self)
                Motion.set(label, { Text = Util.str(config.CopiedText, "Invite copied") })
                task.delay(1.6, function()
                    if not self.Destroyed then
                        label.Text = Util.str(config.ButtonText, "Join Server")
                    end
                end)
            end,
        }))

        if config.Game then
            local row = P.frame({
                Name = "Game",
                Position = UDim2.fromOffset(16, textTop + 60),
                Size = UDim2.new(1, -32, 0, 16),
                ZIndex = 4,
                Parent = card,
            })
            local glyph, bindings = Icons.create(Util.str(config.GameIcon, "gamepad-2"), {
                size = 13,
                token = "Muted",
            })
            if glyph then
                glyph.Position = UDim2.fromOffset(0, 2)
                glyph.ZIndex = 4
                glyph.Parent = row
                self.maid:AddAll(bindings)
            end
            local gameLabel = P.text({
                Name = "Name",
                Position = UDim2.fromOffset(19, 0),
                Size = UDim2.new(1, -19, 1, 0),
                Text = tostring(config.Game),
                TextSize = P.Size.Small,
                ZIndex = 4,
                Parent = row,
            })
            self.maid:Add(Theme.bind(gameLabel, "TextColor3", "Muted"))
        end
    end,

    set = function(self, value)
        self.Url = Util.str(value, self.Url)
    end,

    api = {
        SetCounts = function(self, online, members)
            if self.onlineLabel then
                self.onlineLabel.Text = count(online) .. " Online"
            end
            if self.membersLabel then
                self.membersLabel.Text = count(members) .. " Members"
            end
            return self
        end,
        SetServer = function(self, name)
            self.Name = Util.str(name, self.Name)
            self.title.Text = self.Name
            if self.initials then
                self.initials.Text = string.upper(string.sub(self.Name, 1, 2))
            end
            return self
        end,
    },

    serialise = function()
        return nil
    end,
})

end
Slate_modules["elements/Update"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Log = require("core/Log")
local Base = require("elements/Base")
local Icons = require("ui/Icons")
local P = require("ui/Primitives")

local HEADER_H = 38
local PAD = 14
local GROUP_GAP = 12
local ROW_GAP = 5
local CHIP_H = 17
local DOT_X = 7
local TEXT_X = 20

local KINDS = {
    Added = { key = "Added", token = "Success", icon = "plus", label = "Added", order = 1 },
    Improved = { key = "Improved", token = "Accent", icon = "arrow-up", label = "Improved", order = 2 },
    Changed = { key = "Changed", token = "Warning", icon = "refresh", label = "Changed", order = 3 },
    Fixed = { key = "Fixed", token = "Info", icon = "settings", label = "Fixed", order = 4 },
    Removed = { key = "Removed", token = "Danger", icon = "minus", label = "Removed", order = 5 },
    Note = { key = "Note", token = "Muted", icon = "dot", label = "Note", order = 6 },
}

local function resolve(kind)
    if type(kind) ~= "string" then
        return KINDS.Note
    end
    local key = string.upper(string.sub(kind, 1, 1)) .. string.lower(string.sub(kind, 2))
    return KINDS[key] or KINDS.Note
end

local function makeChip(self, kind, parent)
    local caption = string.upper(kind.label)
    local bounds = P.measure(caption, P.Font.Bold, P.Size.Micro)
    local width = math.ceil(bounds.X) + 30

    local chip = P.frame({
        Name = "Chip",
        Size = UDim2.fromOffset(width, CHIP_H),
        BackgroundTransparency = 0.86,
        LayoutOrder = 0,
        Parent = parent,
    })
    P.corner(chip, 5)
    self.maid:Add(Theme.bind(chip, "BackgroundColor3", kind.token))

    local glyph, bindings = Icons.create(kind.icon, { size = 9, token = kind.token })
    if glyph then
        glyph.AnchorPoint = Vector2.new(0, 0.5)
        glyph.Position = UDim2.new(0, 7, 0.5, 0)
        glyph.Parent = chip
        self.maid:AddAll(bindings)
    end

    local label = P.text({
        Name = "Label",
        Position = UDim2.fromOffset(glyph and 20 or 8, 0),
        Size = UDim2.new(1, glyph and -26 or -14, 1, 0),
        Text = caption,
        TextSize = P.Size.Micro,
        FontFace = P.Font.Bold,
        Parent = chip,
    })
    self.maid:Add(Theme.bind(label, "TextColor3", kind.token))

    return chip
end

local function group(self, kind)
    local existing = self.groups[kind.key]
    if existing then
        return existing
    end

    local frame = P.frame({
        Name = kind.key,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = kind.order,
        Parent = self.list,
    })
    P.list(frame, { gap = 6 })

    if self.Grouped then
        makeChip(self, kind, frame)
    end

    local rows = P.frame({
        Name = "Rows",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Parent = frame,
    })
    P.list(rows, { gap = ROW_GAP })

    local entry = { frame = frame, rows = rows, count = 0 }
    self.groups[kind.key] = entry
    return entry
end

return Base.define({
    Kind = "Update",
    controlWidth = 0,
    hoverable = false,

    build = function(self, config)
        self.Value = nil
        self.nameLabel.Visible = false
        self.left.Size = UDim2.new(1, 0, 1, 0)
        self.Grouped = config.Group ~= false

        local card = P.frame({
            Name = "Update",
            Size = UDim2.new(1, 0, 1, -8),
            Position = UDim2.fromOffset(0, 4),
            BackgroundTransparency = 0,
            ClipsDescendants = true,
            Parent = self.row,
        })
        P.corner(card, Theme.number("Radius", 5) + 3)
        self.maid:Add(Theme.bind(card, "BackgroundColor3", "Surface"))
        local _, cardStroke = P.stroke(card, "Border", 1, Theme.number("BorderT", 0.9))
        self.maid:Add(cardStroke)
        self.card = card

        local tint = P.frame({
            Name = "Tint",
            Size = UDim2.new(1, 0, 0, HEADER_H + 12),
            BackgroundTransparency = 0.94,
            ZIndex = 0,
            Parent = card,
        })
        self.maid:Add(Theme.bind(tint, "BackgroundColor3", "Accent"))
        Util.new("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = tint,
        })

        local version = Util.str(config.Version or self.Name, "Changelog")
        local versionFrame, versionBindings, versionConnection = P.emboss(card, {
            text = version,
            size = 15,
            depth = 2,
            step = 1,
            accentFrom = #version + 1,
            token = "Text",
            shadowToken = "Background",
            frameSize = UDim2.new(0.6, -PAD, 0, 18),
            position = UDim2.fromOffset(PAD, 10),
        })
        versionFrame.Name = "Version"
        versionFrame.ZIndex = 2
        self.versionFrame = versionFrame
        self.versionLabel = versionFrame:FindFirstChild("Face")
        self.maid:AddAll(versionBindings)
        self.maid:Add(versionConnection)

        local underline = P.frame({
            Name = "Underline",
            Position = UDim2.fromOffset(PAD, 30),
            Size = UDim2.fromOffset(22, 2),
            BackgroundTransparency = 0.25,
            ZIndex = 2,
            Parent = card,
        })
        P.corner(underline, 1)
        self.maid:Add(Theme.bind(underline, "BackgroundColor3", "Accent"))

        local date = Util.str(config.Date, nil)
        if date then
            local pill = P.frame({
                Name = "DatePill",
                AnchorPoint = Vector2.new(1, 0),
                Position = UDim2.new(1, -PAD, 0, 11),
                Size = UDim2.fromOffset(math.ceil(P.measure(date, P.Font.Mono, P.Size.Micro).X) + 16, 18),
                BackgroundTransparency = 0.5,
                ZIndex = 2,
                Parent = card,
            })
            P.corner(pill, 5)
            self.maid:Add(Theme.bind(pill, "BackgroundColor3", "SurfaceAlt"))
            self.datePill = pill

            self.dateLabel = P.text({
                Name = "Date",
                Size = UDim2.fromScale(1, 1),
                TextXAlignment = Enum.TextXAlignment.Center,
                Text = date,
                TextSize = P.Size.Micro,
                FontFace = P.Font.Mono,
                ZIndex = 3,
                Parent = pill,
            })
            self.maid:Add(Theme.bind(self.dateLabel, "TextColor3", "Muted"))
        end

        local rule, ruleBinding = P.hairline(card, {
            fade = true,
            edge = 0.04,
            position = UDim2.fromOffset(0, HEADER_H),
            anchor = Vector2.new(0, 0),
        })
        rule.Size = UDim2.new(1, 0, 0, 1)
        rule.ZIndex = 2
        self.maid:Add(ruleBinding)

        self.list = P.frame({
            Name = "Entries",
            Position = UDim2.fromOffset(PAD, HEADER_H + 11),
            Size = UDim2.new(1, -PAD * 2, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
            Parent = card,
        })
        P.list(self.list, { gap = self.Grouped and GROUP_GAP or ROW_GAP })

        self.groups = {}
        self.entries = {}
        self:AddEntries(config.Entries or config.Changes or {})

        self.maid:Add(self.list:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            self:_layout()
        end))
    end,

    height = function(self)
        local listHeight = self.list and self.list.AbsoluteSize.Y or 0
        return math.max(78, HEADER_H + listHeight + 26)
    end,

    api = {
        AddEntry = function(self, entry)
            if type(entry) ~= "table" then
                Log.field("Update", "entry", entry, "table")
                return self
            end
            local kind = resolve(entry.Type or entry.Kind)
            local text = Util.str(entry.Text or entry.Name, "")

            local bucket = self.Grouped and group(self, kind) or nil
            local host = bucket and bucket.rows or self.list
            local order = bucket and bucket.count + 1 or #self.entries + 1

            local row = P.frame({
                Name = "Entry",
                Size = UDim2.new(1, 0, 0, 16),
                AutomaticSize = Enum.AutomaticSize.Y,
                LayoutOrder = order,
                Parent = host,
            })

            local dot = P.frame({
                Name = "Dot",
                Position = UDim2.fromOffset(DOT_X, 6),
                Size = UDim2.fromOffset(5, 5),
                BackgroundTransparency = 0.15,
                Parent = row,
            })
            Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
            self.maid:Add(Theme.bind(dot, "BackgroundColor3", kind.token))

            local label = P.text({
                Name = "Text",
                Position = UDim2.fromOffset(TEXT_X, 0),
                Size = UDim2.new(1, -TEXT_X, 0, 16),
                Text = text,
                TextSize = P.Size.Body,
                TextWrapped = true,
                TextTruncate = Enum.TextTruncate.None,
                TextYAlignment = Enum.TextYAlignment.Top,
                Parent = row,
            })
            self.maid:Add(Theme.bind(label, "TextColor3", "Muted"))
            self.maid:Add(P.autowrap(label, {
                host = row,
                inset = TEXT_X,
                minimum = 16,
                onChange = function()
                    self:_layout()
                end,
            }))

            if bucket then
                bucket.count += 1
            end
            table.insert(self.entries, { row = row, label = label, kind = kind })
            return self
        end,

        AddEntries = function(self, entries)
            for _, entry in ipairs(entries or {}) do
                self:AddEntry(entry)
            end
            self:_layout()
            return self
        end,

        Clear = function(self)
            for _, entry in ipairs(self.entries) do
                entry.row:Destroy()
            end
            table.clear(self.entries)
            for _, bucket in pairs(self.groups) do
                bucket.frame:Destroy()
            end
            table.clear(self.groups)
            self:_layout()
            return self
        end,

        SetVersion = function(self, version, date)
            if version ~= nil and self.versionLabel then
                self.versionLabel.Text = Util.str(version, self.versionLabel.Text)
                for _, layer in ipairs(self.versionFrame:GetChildren()) do
                    if layer:IsA("TextLabel") then
                        layer.Text = self.versionLabel.Text
                    end
                end
            end
            if date and self.dateLabel then
                self.dateLabel.Text = Util.str(date, self.dateLabel.Text)
                if self.datePill then
                    self.datePill.Size = UDim2.fromOffset(
                        math.ceil(P.measure(self.dateLabel.Text, P.Font.Mono, P.Size.Micro).X) + 16,
                        18
                    )
                end
            end
            return self
        end,
    },

    serialise = function()
        return nil
    end,
})

end
Slate_modules["elements/index"] = function(require)
local Static = require("elements/Static")

return {
    Button = require("elements/Button"),
    Toggle = require("elements/Toggle"),
    Slider = require("elements/Slider"),
    Dropdown = require("elements/Dropdown"),
    Input = require("elements/Textbox"),
    Keybind = require("elements/Keybind"),
    Colorpicker = require("elements/Colorpicker"),
    Progress = require("elements/Progress"),
    Invite = require("elements/Invite"),
    Update = require("elements/Update"),
    Label = Static.Label,
    Paragraph = Static.Paragraph,
    Divider = Static.Divider,
    Stat = Static.Stat,
    Card = Static.Card,
    Action = Static.Action,
}

end
Slate_modules["ui/Launcher"] = function(require)
local Players = game:GetService("Players")
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local Input = require("core/Input")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")

local Launcher = {}
Launcher.__index = Launcher

local DEFAULT_SIZE = 44
local DRAG_SLOP = 5
local EDGE_PAD = 6

local function host()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then
            return result
        end
    end
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and core then
        return core
    end
    local player = Players.LocalPlayer
    return player and player:FindFirstChildOfClass("PlayerGui")
end

function Launcher.new(window, config)
    local parent = host()
    if not parent then
        return nil
    end
    config = config or {}

    local self = setmetatable({}, Launcher)
    self.window = window
    self.maid = Maid.new()
    self.Size = math.floor(Util.clamp(Util.num(config.LauncherSize, DEFAULT_SIZE), 22, 96))

    self.gui = Util.new("ScreenGui", {
        Name = Util.str(config.LauncherGuiName, "SlateLauncher"),
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = Util.num(config.DisplayOrder, 999) + 1,
        Parent = parent,
    })
    self.maid:Add(self.gui)
    P.trackRoot(self.gui)
    self.maid:Add(function()
        P.untrackRoot(self.gui)
    end)

    local start = config.LauncherPosition
    if typeof(start) ~= "UDim2" then
        start = UDim2.new(0, 16, 0, 150)
    end

    self.root = P.frame({
        Name = "Bubble",
        Position = start,
        Size = UDim2.fromOffset(self.Size, self.Size),
        BackgroundTransparency = 0,
        Parent = self.gui,
    })
    self.maid:Add(Theme.bind(self.root, "BackgroundColor3", "Surface"))
    P.corner(self.root, math.floor(self.Size / 2))
    local _, strokeBinding = P.stroke(self.root, "Border", 1, 0.85)
    self.maid:Add(strokeBinding)

    self.ring = P.frame({
        Name = "Ring",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.new(1, 8, 1, 8),
        BackgroundTransparency = 1,
        ZIndex = 0,
        Parent = self.root,
    })
    P.corner(self.ring, math.floor((self.Size + 8) / 2))
    local ringStroke, ringBinding = P.stroke(self.ring, "Accent", 1, 0.55)
    self.ringStroke = ringStroke
    self.maid:Add(ringBinding)

    self.glyphSlot = P.frame({
        Name = "Glyph",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(self.Size - 18, self.Size - 18),
        ZIndex = 3,
        Parent = self.root,
    })

    self.hitbox = P.hitbox({
        Name = "Grip",
        Size = UDim2.fromScale(1, 1),
        ZIndex = 6,
        Parent = self.root,
    })

    self:SetIcon(config.LauncherIcon or config.Icon or "layers")

    self.maid:Add(P.interactive(self.hitbox, {
        render = function(state)
            Motion.hover(self.root, { BackgroundTransparency = state.hovered and 0.1 or 0 })
        end,
    }))

    self:_setupDrag()
    self:_paint()

    self.root.BackgroundTransparency = 1
    Motion.play(self.root, { BackgroundTransparency = 0 }, { duration = Motion.Duration.Fast })

    return self
end

function Launcher:SetIcon(name)
    if self.Destroyed then
        return self
    end
    for _, child in ipairs(self.glyphSlot:GetChildren()) do
        child:Destroy()
    end
    for _, binding in ipairs(self.iconBindings or {}) do
        Theme.unbind(binding)
    end
    self.Icon = name
    local glyph, bindings = Icons.create(name, {
        size = math.max(10, self.Size - 18),
        token = "Text",
    })
    self.iconBindings = bindings or {}
    self.glyph = glyph
    if glyph then
        glyph.AnchorPoint = Vector2.new(0.5, 0.5)
        glyph.Position = UDim2.fromScale(0.5, 0.5)
        glyph.ZIndex = 4
        glyph.Parent = self.glyphSlot
    end
    self:_paint()
    return self
end

function Launcher:_paint()
    if self.Destroyed then
        return
    end
    local open = self.window and not self.window.Hidden
    if self.ringStroke then
        Motion.play(self.ringStroke, { Transparency = open and 0.45 or 0.88 }, {
            duration = Motion.Duration.Fast,
        })
    end
    Icons.recolour(self.iconBindings, open and "Text" or "Muted")
end

function Launcher:_viewport()
    local camera = workspace.CurrentCamera
    return camera and camera.ViewportSize or Vector2.new(1280, 720)
end

function Launcher:_clamp()
    local view = self:_viewport()
    local position = self.root.Position
    local x = position.X.Scale * view.X + position.X.Offset
    local y = position.Y.Scale * view.Y + position.Y.Offset
    x = Util.clamp(x, EDGE_PAD, math.max(EDGE_PAD, view.X - self.Size - EDGE_PAD))
    y = Util.clamp(y, EDGE_PAD, math.max(EDGE_PAD, view.Y - self.Size - EDGE_PAD))
    self.root.Position = UDim2.fromOffset(math.floor(x), math.floor(y))
end

function Launcher:_setupDrag()
    local dragMaid = self.maid:Extend()
    self.maid:Add(self.hitbox.MouseButton1Down:Connect(function()
        if self.Destroyed then
            return
        end
        -- the anchor is taken at press time and the origin is the UDim2 the frame
        -- already has; measuring from AbsolutePosition instead makes the bubble
        -- jump by the GUI inset the moment a drag starts
        local anchor = Input.pointerPosition()
        local origin = self.root.Position
        local travel = 0
        dragMaid:Clean()
        dragMaid:Add(Input.PointerMoved:Connect(function(position)
            if typeof(anchor) ~= "Vector2" then
                anchor = position
                return
            end
            local delta = position - anchor
            travel = math.max(travel, math.abs(delta.X) + math.abs(delta.Y))
            if travel <= DRAG_SLOP then
                return
            end
            self.root.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + delta.X,
                origin.Y.Scale, origin.Y.Offset + delta.Y
            )
        end))
        dragMaid:Add(Input.PointerUp:Connect(function()
            dragMaid:Clean()
            if travel > DRAG_SLOP then
                self:_clamp()
                return
            end
            self:Press()
        end))
    end))
end

function Launcher:Press()
    local window = self.window
    if not window or window.Destroyed then
        return self
    end
    window:SetVisible(window.Hidden)
    self:_paint()
    return self
end

function Launcher:SetVisible(state)
    if self.Destroyed then
        return self
    end
    self.gui.Enabled = state ~= false
    return self
end

function Launcher:SetPosition(position)
    if self.Destroyed or typeof(position) ~= "UDim2" then
        return self
    end
    self.root.Position = position
    self:_clamp()
    return self
end

function Launcher:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    self.maid:Destroy()
end

return Launcher

end
Slate_modules["ui/Section"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Maid = require("core/Maid")
local Log = require("core/Log")
local P = require("ui/Primitives")
local Elements = require("elements/index")

local Section = {}
Section.__index = Section

local HEADER_H = 26

function Section.new(tab, config)
    if type(config) ~= "table" then
        config = { Name = Util.str(config, "Section") }
    end

    local self = setmetatable({}, Section)
    self.Name = Util.str(config.Name or config.Title, "Section")
    self.Id = Util.uid("section")
    self.Order = tab and (#tab.sections + 1) or 1
    self.Column = config.Column and math.max(1, math.floor(Util.num(config.Column, 1))) or nil
    self.tab = tab
    self.window = tab and tab.window or nil
    self.elements = {}
    self.maid = Maid.new()
    self.Destroyed = false
    self.Collapsed = false

    self.frame = P.frame({
        Name = "Section",
        Size = UDim2.new(1, 0, 0, HEADER_H),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = self.Order,
    })
    self.maid:Add(self.frame)
    P.list(self.frame, { gap = 0 })

    self.header = P.frame({
        Name = "Header",
        Size = UDim2.new(1, 0, 0, HEADER_H),
        LayoutOrder = 0,
        Parent = self.frame,
    })

    self.title = P.text({
        Name = "Title",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.new(0, 0, 1, -7),
        Size = UDim2.new(1, -20, 0, 12),
        Text = string.upper(self.Name),
        TextSize = P.Size.Micro,
        FontFace = P.Font.Medium,
        Parent = self.header,
    })
    self.maid:Add(Theme.bind(self.title, "TextColor3", "Muted"))

    if config.Collapsible then
        self.toggle = P.hitbox({ Name = "Collapse", Parent = self.header, ZIndex = 4 })
        self.maid:Add(self.toggle)
        self.maid:Add(self.toggle.MouseButton1Click:Connect(function()
            self:SetCollapsed(not self.Collapsed)
        end))
    end

    self.body = P.frame({
        Name = "Body",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = 1,
        Parent = self.frame,
    })
    P.list(self.body, { gap = 0 })

    if tab then
        table.insert(tab.sections, self)
        self.frame.Parent = tab.columns and tab.columns[1] or tab.page
        tab:_layoutColumns(true)
    end

    return self
end

function Section:_invalidate()
    if self.tab and self.tab._invalidateColumns then
        self.tab:_invalidateColumns()
    end
end

function Section:SetCollapsed(state)
    self.Collapsed = state == true
    self.body.Visible = not self.Collapsed
    return self
end

function Section:SetName(name)
    self.Name = Util.str(name, self.Name)
    self.title.Text = string.upper(self.Name)
    return self
end

function Section:SetVisible(state)
    self.frame.Visible = state ~= false
    return self
end

function Section:SetColumn(index)
    if index == nil or index == false then
        self.Column = nil
    else
        self.Column = math.max(1, math.floor(Util.num(index, 1)))
    end
    if self.tab and self.tab._layoutColumns then
        self.tab:_layoutColumns(true)
    end
    return self
end

function Section:Grid(config)
    config = config or {}
    local columns = math.max(1, math.floor(Util.num(config.Columns, 3)))
    local height = Util.num(config.Height, 58)
    local gap = Util.num(config.Gap, 8)

    local grid = setmetatable({}, Section)
    grid.Name = Util.str(config.Name, self.Name)
    grid.Id = Util.uid("grid")
    grid.tab = self.tab
    grid.window = self.window
    grid.elements = {}
    grid.maid = self.maid:Extend()
    grid.Destroyed = false
    grid.isGrid = true

    grid.frame = P.frame({
        Name = "Grid",
        Size = UDim2.new(1, 0, 0, height),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = #self.elements + 100,
        Parent = self.body,
    })
    grid.maid:Add(grid.frame)
    grid.body = grid.frame

    local layout = Util.new("UIGridLayout", {
        CellSize = UDim2.fromOffset(120, height),
        CellPadding = UDim2.fromOffset(gap, gap),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = grid.frame,
    })
    grid.layout = layout

    local minCell = math.max(40, Util.num(config.MinWidth, 132))

    local function measure()
        local width = grid.frame.AbsoluteSize.X
        if width <= 0 then
            return
        end
        local fits = math.max(1, math.floor((width + gap) / (minCell + gap)))
        local used = math.min(columns, fits)
        local cell = math.floor((width - gap * (used - 1)) / used)
        layout.CellSize = UDim2.fromOffset(math.max(40, cell), height)
    end
    grid.maid:Add(grid.frame:GetPropertyChangedSignal("AbsoluteSize"):Connect(measure))
    task.defer(measure)

    function grid:_invalidate()
        if grid.tab and grid.tab._invalidateColumns then
            grid.tab:_invalidateColumns()
        end
    end

    return grid
end

local function register(kind, constructor)
    Section[kind] = function(self, config)
        if self.Destroyed then
            Log.warn("section", "adding a " .. kind .. " to a destroyed section")
            return nil
        end
        return constructor(self, config or {})
    end
end

for kind, constructor in pairs(Elements) do
    register(kind, constructor)
end

Section.Textbox = Section.Input
Section.Toggle = Section.Toggle
Section.Header = Section.Label

function Section:Elements()
    return Util.list(self.elements)
end

function Section:Find(name)
    local needle = Util.normalise(name)
    for _, element in ipairs(self.elements) do
        if Util.normalise(element.Name) == needle then
            return element
        end
    end
    return nil
end

function Section:Clear()
    for _, element in ipairs(Util.list(self.elements)) do
        element:Destroy()
    end
    table.clear(self.elements)
    return self
end

function Section:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    self:Clear()
    local owner = self.tab
    if owner then
        Util.remove(owner.sections, self)
    end
    self.maid:Destroy()
    if owner and owner._layoutColumns and not owner.Destroyed then
        owner:_layoutColumns(true)
    end
end

return Section

end
Slate_modules["ui/Tab"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local Log = require("core/Log")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")
local Section = require("ui/Section")

local Tab = {}
Tab.__index = Tab

local BUTTON_H = 30
local DOCK_BUTTON = 34
local COLUMN_GAP = 10
local COLUMN_MIN = 224
local COLUMN_MAX = 470
local MAX_COLUMNS = 4

local function isActive(self)
    local active = self.window and self.window.activeTab
    if not active then
        return false
    end
    if active == self then
        return true
    end
    return self.parent == nil and active.parent == self
end

local function paint(self)
    local active = isActive(self)
    local token = self.Disabled and "Faint" or (active and "Text" or "Muted")
    Theme.rebind(self.labelBinding, token)
    Icons.recolour(self.iconBindings, self.Disabled and "Faint" or (active and "Accent" or "Faint"))

    Motion.play(self.button, {
        BackgroundTransparency = active and (self.docked and 0.62 or 0.82) or 1,
    }, { duration = Motion.Duration.Fast })
    Theme.rebind(self.buttonBinding, active and "Accent" or "Text")
end

function Tab.new(window, config, parent)
    if type(config) ~= "table" then
        config = { Name = Util.str(config, "Tab") }
    end

    local self = setmetatable({}, Tab)
    self.Name = Util.str(config.Name or config.Title, "Tab")
    self.Id = Util.uid("tab")
    self.window = window
    self.parent = parent
    self.subs = {}
    self.sections = {}
    self.maid = Maid.new()
    self.Destroyed = false
    self.Disabled = false

    local host, order
    if parent then
        host = parent.subContainer
        order = #parent.subs + 1
    else
        host = window.rail.frame
        window._tabOrder = (window._tabOrder or 0) + 1
        order = window._tabOrder
    end
    self.docked = parent ~= nil

    self.button = P.frame({
        Name = "TabButton",
        Size = self.docked and UDim2.fromOffset(DOCK_BUTTON, DOCK_BUTTON)
            or UDim2.new(1, 0, 0, BUTTON_H),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        Parent = host,
    })
    self.maid:Add(self.button)
    self.buttonBinding = Theme.bind(self.button, "BackgroundColor3", "Text")
    self.maid:Add(self.buttonBinding)
    self.corner = P.corner(self.button, self.docked and 10 or Theme.number("RadiusSm", 3) + 2)
    Util.new("UIGradient", {
        Rotation = self.docked and 45 or 20,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(0.55, 0.42),
            NumberSequenceKeypoint.new(1, 0.8),
        }),
        Parent = self.button,
    })

    self.sweep = P.frame({
        Name = "Sweep",
        Size = UDim2.new(0.45, 0, 1, 0),
        Position = UDim2.fromScale(-0.5, 0),
        BackgroundTransparency = 1,
        ZIndex = 2,
        Parent = self.button,
    })
    self.maid:Add(Theme.bind(self.sweep, "BackgroundColor3", "Accent"))
    Util.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = self.sweep,
    })

    local textX = 10
    local iconName = config.Icon
    if self.docked and not iconName then
        iconName = "circle"
    end
    if iconName then
        local iconSize = self.docked and (window.DockIconSize or 17) or (window.TabIconSize or 13)
        local glyph, bindings = Icons.create(iconName, {
            size = iconSize,
            token = "Faint",
        })
        if glyph then
            if self.docked then
                glyph.AnchorPoint = Vector2.new(0.5, 0.5)
                glyph.Position = UDim2.fromScale(0.5, 0.5)
            else
                glyph.AnchorPoint = Vector2.new(0, 0.5)
                glyph.Position = UDim2.new(0, 8, 0.5, 0)
                textX = 8 + iconSize + 7
            end
            glyph.Parent = self.button
            self.icon = glyph
            self.iconBindings = bindings
            self.maid:AddAll(bindings)
        end
    end
    self.iconBindings = self.iconBindings or {}

    self.label = P.text({
        Name = "Label",
        Position = UDim2.fromOffset(textX, 0),
        Size = UDim2.new(1, -textX - 4, 1, 0),
        Text = self.Name,
        TextSize = P.Size.Label,
        FontFace = P.Font.Medium,
        Visible = not self.docked,
        Parent = self.button,
    })
    self.labelBinding = Theme.bind(self.label, "TextColor3", "Muted")
    self.maid:Add(self.labelBinding)

    self.badgeFrame = P.frame({
        Name = "Badge",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -8, 0.5, 0),
        Size = UDim2.fromOffset(18, 14),
        BackgroundTransparency = 0,
        Visible = false,
        Parent = self.button,
    })
    P.corner(self.badgeFrame, 3)
    self.maid:Add(Theme.bind(self.badgeFrame, "BackgroundColor3", "SurfaceAlt"))

    self.badgeLabel = P.text({
        Name = "Value",
        Size = UDim2.fromScale(1, 1),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextSize = P.Size.Micro,
        FontFace = P.Font.Mono,
        Parent = self.badgeFrame,
    })
    self.maid:Add(Theme.bind(self.badgeLabel, "TextColor3", "Muted"))

    self.hitbox = P.hitbox({ Parent = self.button, ZIndex = 6 })
    self.maid:Add(self.hitbox)
    if self.docked then
        self.maid:Add(window:Tooltip(self.hitbox, self.Name))
    end

    self.maid:Add(P.interactive(self.hitbox, {
        render = function(state)
            if isActive(self) or self.Disabled then
                return
            end
            Motion.hover(self.button, {
                BackgroundTransparency = state.hovered and (self.docked and 0.9 or 0.965) or 1,
            })
            if self.docked then
                Icons.recolour(self.iconBindings, state.hovered and "Text" or "Faint")
            end
        end,
        onClick = function()
            if self.Disabled then
                return
            end
            local ok = pcall(function()
                window:SelectTab(self)
            end)
            if not ok then
                task.spawn(function()
                    for _, other in ipairs(window.tabs) do
                        if other ~= self and other.page then
                            pcall(function()
                                other.page.Visible = false
                            end)
                        end
                    end
                    window.activeTab = nil
                    pcall(function()
                        window:SelectTab(self)
                    end)
                end)
            end
        end,
    }))

    if not parent then
        self.subContainer = P.frame({
            Name = "SubTabs",
            Size = UDim2.fromOffset(DOCK_BUTTON, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Visible = false,
            Parent = window.dockList,
        })
        self.maid:Add(self.subContainer)
        P.list(self.subContainer, {
            gap = 6,
            align = Enum.HorizontalAlignment.Center,
        })
    end

    self.page = P.frame({
        Name = "Page",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = window.pages.frame,
    })
    self.pageLayout = P.list(self.page, { gap = COLUMN_GAP, horizontal = true })
    self.maid:Add(self.page)

    self.Columns = math.clamp(math.floor(Util.num(config.Columns, 1)), 1, MAX_COLUMNS)
    self.MinColumn = math.max(140, Util.num(config.MinColumn, COLUMN_MIN))
    self.columns = {}
    self.activeColumns = 0
    for index = 1, self.Columns do
        self:_column(index)
    end

    self.maid:Add(self.page:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:_layoutColumns(false)
    end))
    task.defer(function()
        if not self.Destroyed then
            self:_layoutColumns(false)
        end
    end)

    if config.Badge then
        self:SetBadge(config.Badge)
    end
    if config.Disabled then
        self:SetDisabled(true)
    end

    table.insert(window.tabs, self)
    if parent then
        table.insert(parent.subs, self)
    end
    paint(self)
    return self
end

function Tab:_column(index)
    local existing = self.columns[index]
    if existing then
        return existing
    end
    local column = P.frame({
        Name = "Column" .. index,
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        LayoutOrder = index,
        Visible = index == 1,
        Parent = self.page,
    })
    P.list(column, { gap = 4 })
    self.columns[index] = column
    return column
end

function Tab:_requiredColumn()
    if self._columnNeed then
        return self._columnNeed
    end
    local widest = self.MinColumn
    for _, section in ipairs(self.sections) do
        for _, element in ipairs(section.elements) do
            if element.NeedWidth then
                local need = element:NeedWidth()
                if need > widest then
                    widest = need
                end
            end
        end
    end
    self._columnNeed = math.clamp(math.ceil(widest), self.MinColumn, COLUMN_MAX)
    return self._columnNeed
end

function Tab:_invalidateColumns()
    self._columnNeed = nil
    self.activeColumns = 0
    self:_layoutColumns(true)
    if self.window and self.window.activeTab == self then
        self.window:_ensureWidth(false)
    end
end

-- measured text can under-report, so widen once the labels are laid out
function Tab:_verifyColumns()
    if self.Destroyed or not self._columnNeed or self._columnNeed >= COLUMN_MAX then
        return
    end
    local deficit = 0
    for _, section in ipairs(self.sections) do
        if section.frame.Visible then
            for _, element in ipairs(section.elements) do
                local label = element.nameLabel
                if label and label.Visible and label.AbsoluteSize.X > 0 then
                    local over = label.TextBounds.X - label.AbsoluteSize.X
                    if over > deficit then
                        deficit = over
                    end
                end
            end
        end
    end
    if deficit <= 0.5 then
        return
    end
    self._columnNeed = math.min(COLUMN_MAX, self._columnNeed + math.ceil(deficit) + 2)
    self.activeColumns = 0
    self:_layoutColumns(true)
    if self.window and self.window.activeTab == self then
        self.window:_ensureWidth(false)
    end
end

function Tab:_columnTarget()
    local width = self.page.AbsoluteSize.X
    if width <= 0 and self.window then
        width = self.window.pages.frame.AbsoluteSize.X - 36
    end
    if width <= 0 then
        return self.Columns
    end
    local need = self:_requiredColumn()
    local fits = math.max(1, math.floor((width + COLUMN_GAP) / (need + COLUMN_GAP)))
    return math.clamp(fits, 1, self.Columns)
end

function Tab:_layoutColumns(force)
    if self.Destroyed then
        return self
    end
    local target = self:_columnTarget()
    if target == self.activeColumns and not force then
        return self
    end
    self.activeColumns = target

    for index, column in ipairs(self.columns) do
        local used = index <= target
        column.Visible = used
        if used then
            column.Size = UDim2.new(1 / target, -COLUMN_GAP * (target - 1) / target, 0, 0)
        end
    end

    local cursor = 0
    for _, section in ipairs(self.sections) do
        local index
        if section.Column then
            index = math.clamp(section.Column, 1, target)
        else
            index = (cursor % target) + 1
            cursor += 1
        end
        local column = self.columns[index] or self.columns[1]
        if column and section.frame.Parent ~= column then
            section.frame.Parent = column
        end
        section.frame.LayoutOrder = section.Order or 1
    end

    task.defer(function()
        if not self.Destroyed then
            self:_verifyColumns()
        end
    end)
    return self
end

function Tab:SetColumns(count)
    local value = math.clamp(math.floor(Util.num(count, 1)), 1, MAX_COLUMNS)
    if value == self.Columns then
        return self
    end
    self.Columns = value
    for index = 1, value do
        self:_column(index)
    end
    if self.window and self.window.activeTab == self then
        self.window:_ensureWidth(true)
    end
    self:_layoutColumns(true)
    return self
end

function Tab:ContentFloor()
    return self:_requiredColumn()
end

function Tab:ColumnsAt(width)
    if width <= 0 then
        return self.Columns
    end
    local need = self:_requiredColumn()
    local fits = math.max(1, math.floor((width + COLUMN_GAP) / (need + COLUMN_GAP)))
    return math.clamp(fits, 1, self.Columns)
end

function Tab:GetColumns()
    return self.Columns, self.activeColumns
end

function Tab:CreateSubTab(config)
    if self.Destroyed then
        Log.warn("tab", "adding a sub tab to a destroyed tab")
        return nil
    end
    if self.parent then
        Log.warn("tab", "sub tabs cannot be nested further")
        return nil
    end
    return Tab.new(self.window, config, self)
end

Tab.SubTab = Tab.CreateSubTab

function Tab:Root()
    return self.parent or self
end

function Tab:SetIconOnly(state)
    if self.docked then
        return self
    end
    local iconOnly = state == true
    if self._iconOnly == iconOnly then
        return self
    end
    self._iconOnly = iconOnly

    if self.icon then
        self.icon.AnchorPoint = iconOnly and Vector2.new(0.5, 0.5) or Vector2.new(0, 0.5)
        self.icon.Position = iconOnly and UDim2.fromScale(0.5, 0.5) or UDim2.new(0, 8, 0.5, 0)
    end
    if self.corner then
        self.corner.CornerRadius = UDim.new(0, iconOnly and 9 or (Theme.number("RadiusSm", 3) + 2))
    end

    if iconOnly then
        if not self.tip and self.window then
            self.tip = self.window:Tooltip(self.hitbox, self.Name)
            self.maid:Add(self.tip)
        end
    elseif self.tip then
        self.maid:Remove(self.tip)
        self.tip:Destroy()
        self.tip = nil
    end
    return self
end

function Tab:CreateSection(config)
    if self.Destroyed then
        Log.warn("tab", "adding a section to a destroyed tab")
        return nil
    end
    return Section.new(self, config)
end

function Tab:Reflow()
    return self:_layoutColumns(true)
end

Tab.Section = Tab.CreateSection

function Tab:SetName(name)
    self.Name = Util.str(name, self.Name)
    self.label.Text = self.Name
    return self
end

function Tab:SetDim(state)
    local dim = state == true
    if self._dimmed == dim then
        return self
    end
    self._dimmed = dim
    local alpha = dim and 0.6 or 0
    if self.icon then
        Motion.cancel(self.icon)
        if self.icon:IsA("ImageLabel") then
            self.icon.ImageTransparency = alpha
        elseif self.icon:IsA("TextLabel") then
            self.icon.TextTransparency = alpha
        end
    end
    self.label.TextTransparency = alpha
    return self
end

function Tab:SetBadgeDot(state)
    if not state then
        if self.badgeDotPulse then
            self.badgeDotPulse:Disconnect()
            self.badgeDotPulse = nil
        end
        if self.badgeDot then
            self.badgeDot:Destroy()
            self.badgeDot = nil
        end
        return self
    end
    if self.badgeDot then
        return self
    end
    local span = self.docked and 6 or 5
    local dot = P.frame({
        Name = "BadgeDot",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, self.docked and -4 or -6, 0, self.docked and 4 or 6),
        Size = UDim2.fromOffset(span, span),
        ZIndex = 9,
        Parent = self.button,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
    self.maid:Add(dot)
    self.maid:Add(Theme.bind(dot, "BackgroundColor3", "Danger"))
    self.badgeDot = dot
    local clock = 0
    self.badgeDotPulse = game:GetService("RunService").RenderStepped:Connect(function(delta)
        if not dot.Parent then
            return
        end
        clock += math.min(delta, 0.2)
        dot.BackgroundTransparency = 0.08 + ((math.sin(clock * 3.2) + 1) * 0.5) * 0.42
    end)
    self.maid:Add(self.badgeDotPulse)
    return self
end

function Tab:SetBadge(value)
    if value == nil or value == false or value == "" then
        self.badgeFrame.Visible = false
        self.label.Size = UDim2.new(1, -self.label.Position.X.Offset - 10, 1, 0)
        return self
    end
    local text = tostring(value)
    self.badgeLabel.Text = text
    self.badgeFrame.Size = UDim2.fromOffset(math.max(18, #text * 7 + 10), 14)
    self.badgeFrame.Visible = true
    self.label.Size = UDim2.new(1, -self.label.Position.X.Offset - self.badgeFrame.Size.X.Offset - 14, 1, 0)
    return self
end

function Tab:SetDisabled(state)
    self.Disabled = state == true
    paint(self)
    if self.Disabled and self.window.activeTab == self then
        for _, tab in ipairs(self.window.tabs) do
            if tab ~= self and not tab.Disabled and tab.parent == nil then
                self.window:SelectTab(tab)
                break
            end
        end
    end
    return self
end

function Tab:Select()
    self.window:SelectTab(self)
    return self
end

function Tab:Repaint()
    paint(self)
end

function Tab:PlaySelect()
    if self.Destroyed or not Motion.isEnabled() then
        return
    end
    Motion.cancel(self.sweep)
    self.sweep.Position = UDim2.fromScale(-0.5, 0)
    self.sweep.BackgroundTransparency = 0.82
    Motion.play(self.sweep, { Position = UDim2.fromScale(1.05, 0) }, {
        duration = 0.42,
        easing = Enum.EasingStyle.Quint,
    })
    Motion.play(self.sweep, { BackgroundTransparency = 1 }, {
        duration = 0.42,
        easing = Enum.EasingStyle.Sine,
    })

    if self.icon then
        Motion.cancel(self.icon)
        local base = self.icon.Position
        self.icon.Position = base - UDim2.fromOffset(3, 0)
        Motion.play(self.icon, { Position = base }, {
            duration = Motion.Duration.Slow,
            easing = Enum.EasingStyle.Back,
        })
    end
end

function Tab:Sections()
    return Util.list(self.sections)
end

function Tab:SubTabs()
    return Util.list(self.subs)
end

function Tab:Clear()
    for _, section in ipairs(Util.list(self.sections)) do
        section:Destroy()
    end
    table.clear(self.sections)
    return self
end

function Tab:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true

    for _, sub in ipairs(Util.list(self.subs)) do
        sub:Destroy()
    end
    table.clear(self.subs)
    if self.parent then
        Util.remove(self.parent.subs, self)
    end

    self:Clear()
    Util.remove(self.window.tabs, self)

    if self.window.activeTab == self then
        self.window.activeTab = nil
        for _, tab in ipairs(self.window.tabs) do
            if not tab.Disabled and tab.parent == nil then
                self.window:SelectTab(tab)
                break
            end
        end
    end
    self.maid:Destroy()
end

return Tab

end
Slate_modules["ui/Search"] = function(require)
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Registry = require("core/Registry")
local P = require("ui/Primitives")

local Search = {}

local DEBOUNCE = 0.05

local function ownedBy(window)
    return function(element)
        local section = element.section
        local tab = section and section.tab
        return tab ~= nil and tab.window == window
    end
end

local function restore(window)
    for _, tab in ipairs(window.tabs) do
        for _, section in ipairs(tab.sections) do
            section.frame.Visible = true
            for _, element in ipairs(section.elements) do
                element.row.Visible = element.Visible
            end
        end
        tab:SetDim(false)
    end
    window:SetStatus(window._statusBeforeSearch or "")
end

local function apply(window, query)
    if query == "" then
        restore(window)
        return
    end

    local hits = {}
    for _, element in ipairs(Registry.search(query, ownedBy(window))) do
        hits[element.Id] = true
    end

    local total = 0
    local firstTab
    local counts = {}

    for _, tab in ipairs(window.tabs) do
        local tabHits = 0
        for _, section in ipairs(tab.sections) do
            local sectionHits = 0
            for _, element in ipairs(section.elements) do
                local matched = hits[element.Id] == true
                element.row.Visible = matched and element.Visible
                if matched then
                    sectionHits += 1
                end
            end
            section.frame.Visible = sectionHits > 0
            tabHits += sectionHits
        end
        counts[tab] = (counts[tab] or 0) + tabHits
        if tab.parent then
            counts[tab.parent] = (counts[tab.parent] or 0) + tabHits
        end
        total += tabHits
        if tabHits > 0 and not firstTab then
            firstTab = tab
        end
    end

    for _, tab in ipairs(window.tabs) do
        tab:SetDim((counts[tab] or 0) == 0)
    end

    if firstTab and window.activeTab ~= firstTab then
        local current = window.activeTab
        local currentHasHits = false
        if current then
            for _, section in ipairs(current.sections) do
                if section.frame.Visible then
                    currentHasHits = true
                    break
                end
            end
        end
        if not currentHasHits then
            window:SelectTab(firstTab)
        end
    end

    window:SetStatus(
        total == 0 and "no matches"
        or (total == 1 and "1 match" or (total .. " matches"))
    )
end

function Search.close(window)
    if not window.searching then
        return
    end
    window.searching = false

    if window.searchBox then
        window.searchBox:ReleaseFocus()
        window.searchBox:Destroy()
        window.searchBox = nil
    end
    if window.searchPending then
        task.cancel(window.searchPending)
        window.searchPending = nil
    end

    restore(window)

    local titleHost = window.logo or window.titleLabel
    titleHost.Visible = true
    if window.subtitleLabel then
        window.subtitleLabel.Visible = true
    end
end

function Search.open(window)
    if window.searching then
        Search.close(window)
        return
    end
    window.searching = true
    window._statusBeforeSearch = window.statusLabel.Text

    local titleHost = window.logo or window.titleLabel
    titleHost.Visible = false
    if window.subtitleLabel then
        window.subtitleLabel.Visible = false
    end

    local left = titleHost.Position.X.Offset
    local box = Util.new("TextBox", {
        Name = "Search",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(left, 0),
        Size = UDim2.new(1, -left - 120, 1, 0),
        FontFace = P.Font.Regular,
        TextSize = P.Size.Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        PlaceholderText = "Search",
        Text = "",
        ClearTextOnFocus = false,
        ZIndex = 4,
        Parent = window.header,
    })
    window.maid:Add(Theme.bind(box, "TextColor3", "Text"))
    window.maid:Add(Theme.bind(box, "PlaceholderColor3", "Faint"))
    window.searchBox = box

    box.TextTransparency = 1
    Motion.play(box, { TextTransparency = 0 }, { duration = Motion.Duration.Fast })

    window.maid:Add(box:GetPropertyChangedSignal("Text"):Connect(function()
        if window.searchPending then
            task.cancel(window.searchPending)
        end
        local query = box.Text
        window.searchPending = task.delay(DEBOUNCE, function()
            window.searchPending = nil
            if window.searching and not window.Destroyed then
                apply(window, query)
            end
        end)
    end))

    window.maid:Add(box.FocusLost:Connect(function(enterPressed)
        if enterPressed and box.Text == "" then
            Search.close(window)
        end
    end))

    task.defer(function()
        if box.Parent then
            box:CaptureFocus()
        end
    end)
end

return Search

end
Slate_modules["ui/Window"] = function(require)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Util = require("core/Util")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Maid = require("core/Maid")
local Signal = require("core/Signal")
local Log = require("core/Log")
local Input = require("core/Input")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")
local Overlay = require("ui/Overlay")
local Scroller = require("ui/Scroller")
local Tab = require("ui/Tab")
local Launcher = require("ui/Launcher")

local Window = {}
Window.__index = Window

local DOCK_W = 48
local DOCK_GAP = 10
local DOCK_PAD = 7

local MODES = {
    Compact = { size = Vector2.new(560, 392), rail = 46, labels = false },
    Normal = { size = Vector2.new(716, 468), rail = 164, labels = true },
    Expanded = { size = Vector2.new(908, 568), rail = 188, labels = true },
}

local function host()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then
            return result
        end
    end
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok and core then
        return core
    end
    local player = Players.LocalPlayer
    return player and player:FindFirstChildOfClass("PlayerGui")
end

local CORNER_LAYERS = { 0.985, 0.972, 0.958, 0.94 }

local function cornerLight(parent, maid)
    local host = P.frame({
        Name = "CornerLight",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.06, 0.08),
        Size = UDim2.fromOffset(420, 420),
        ZIndex = 0,
        Parent = parent,
    })
    for index, transparency in ipairs(CORNER_LAYERS) do
        local scale = 1 - (index - 1) * 0.22
        local disc = P.frame({
            Name = "Layer" .. index,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(scale, scale),
            BackgroundTransparency = transparency,
            ZIndex = 0,
            Parent = host,
        })
        Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = disc })
        maid:Add(Theme.bind(disc, "BackgroundColor3", "Accent"))
    end
    return host
end

local WASHES = {
    {
        name = "WashWide",
        tokens = { "Accent", "Info", "Accent" },
        band = {
            { 0, 1 },
            { 0.24, 0.955 },
            { 0.5, 0.888 },
            { 0.76, 0.955 },
            { 1, 1 },
        },
        spin = 7,
        sway = 0,
        drift = 0,
    },
    {
        name = "WashSoft",
        tokens = { "Info", "Accent", "Info" },
        band = {
            { 0, 1 },
            { 0.38, 0.955 },
            { 0.62, 0.928 },
            { 1, 1 },
        },
        spin = 0,
        sway = 31,
        drift = 43,
        tilt = -28,
    },
}

local function wash(parent, spec, maid)
    local frame = P.frame({
        Name = spec.name,
        Size = UDim2.fromScale(1.6, 1.6),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BackgroundTransparency = 0,
        ZIndex = 0,
        Parent = parent,
    })

    local points = {}
    for _, entry in ipairs(spec.band) do
        table.insert(points, NumberSequenceKeypoint.new(entry[1], entry[2]))
    end

    local gradient = Util.new("UIGradient", {
        Transparency = NumberSequence.new(points),
        Rotation = spec.tilt or 0,
        Parent = frame,
    })

    local function repaint()
        local stops = {}
        local count = #spec.tokens
        for index, token in ipairs(spec.tokens) do
            local at = count == 1 and 0 or (index - 1) / (count - 1)
            table.insert(stops, ColorSequenceKeypoint.new(at, Theme.color(token)))
        end
        gradient.Color = ColorSequence.new(stops)
    end
    repaint()
    maid:Add(Theme.Changed:Connect(repaint))

    return gradient
end

local function buildBackdrop(window, mode)
    window.Backdrop = mode
    if window.backdropMaid then
        window.backdropMaid:Clean()
    else
        window.backdropMaid = window.maid:Extend()
    end
    local maid = window.backdropMaid

    if mode == "flat" then
        return
    end

    local sheen = P.frame({
        Name = "Sheen",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0,
        ZIndex = 0,
        Parent = window.root,
    })
    maid:Add(sheen)
    P.corner(sheen, Theme.number("Radius", 5) + 1)
    maid:Add(Theme.bind(sheen, "BackgroundColor3", "Text"))
    Util.new("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.965),
            NumberSequenceKeypoint.new(0.55, 0.995),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = sheen,
    })

    local edge = P.frame({
        Name = "TopEdge",
        Size = UDim2.new(1, -24, 0, 1),
        Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 0.9,
        ZIndex = 1,
        Parent = window.root,
    })
    maid:Add(edge)
    maid:Add(Theme.bind(edge, "BackgroundColor3", "Text"))
    Util.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = edge,
    })

    local field = P.canvas({
        Name = "Backdrop",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        ZIndex = 0,
        Parent = window.root,
    })
    maid:Add(field)
    P.corner(field, Theme.number("Radius", 5) + 1)

    if mode ~= "aurora" then
        cornerLight(field, maid)
        return
    end

    local gradients = {}
    for index, spec in ipairs(WASHES) do
        gradients[index] = wash(field, spec, maid)
    end
    cornerLight(field, maid)
    window.washes = gradients

    local clock = 0
    maid:Add(RunService.Heartbeat:Connect(function(delta)
        if window.Destroyed or not window.root.Visible or not Motion.isEnabled() then
            return
        end
        clock += math.min(delta, 0.1)
        for index, gradient in ipairs(gradients) do
            local spec = WASHES[index]
            if spec.spin > 0 then
                gradient.Rotation = (clock * spec.spin) % 360
            elseif spec.sway > 0 then
                gradient.Rotation = (spec.tilt or 0)
                    + math.sin(clock * math.pi * 2 / spec.sway) * 14
            end
            if spec.drift > 0 then
                gradient.Offset = Vector2.new(
                    math.sin(clock * math.pi * 2 / spec.drift) * 0.3,
                    math.cos(clock * math.pi * 2 / (spec.drift * 1.31)) * 0.16
                )
            end
        end
    end))
end

local function headerButton(window, parent, icon, order, onClick)
    local button = P.hitbox({
        Name = "HeaderButton",
        Size = UDim2.fromOffset(24, 24),
        LayoutOrder = order,
        BackgroundTransparency = 1,
        Parent = parent,
    })
    P.corner(button, Theme.number("RadiusSm", 3))
    window.maid:Add(Theme.bind(button, "BackgroundColor3", "Text"))

    local glyph, bindings = Icons.create(icon, { size = 11, token = "Muted" })
    if glyph then
        glyph.AnchorPoint = Vector2.new(0.5, 0.5)
        glyph.Position = UDim2.fromScale(0.5, 0.5)
        glyph.Parent = button
        window.maid:AddAll(bindings)
    end

    window.maid:Add(P.interactive(button, {
        render = function(state)
            Motion.hover(button, { BackgroundTransparency = state.hovered and 0.92 or 1 })
            Icons.recolour(bindings, state.hovered and "Text" or "Muted")
        end,
        onClick = onClick,
    }))
    return button, glyph
end

function Window.new(library, config)
    if type(config) ~= "table" then
        config = {}
    end

    local self = setmetatable({}, Window)
    self.library = library
    self.Id = Util.uid("window")
    self.Title = Util.str(config.Name or config.Title, "Slate")
    self.Subtitle = Util.str(config.Subtitle or config.Description, nil)
    self.tabs = {}
    self.activeTab = nil
    self.maid = Maid.new()
    self.Destroyed = false
    self.Minimised = false
    self.Hidden = false
    self.Mode = MODES[config.Mode] and config.Mode or "Normal"

    self.Closed = Signal.new()
    self.TabChanged = Signal.new()
    self._elementChanged = Signal.new()
    self.maid:Add(self.Closed)
    self.maid:Add(self.TabChanged)
    self.maid:Add(self._elementChanged)

    local parent = host()
    if not parent then
        Log.warn("window", "no gui host available")
        return nil
    end

    self.gui = Util.new("ScreenGui", {
        Name = Util.str(config.GuiName, "Slate"),
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = Util.num(config.DisplayOrder, 999),
        Parent = parent,
    })
    self.maid:Add(self.gui)
    P.trackRoot(self.gui)
    self.maid:Add(function()
        P.untrackRoot(self.gui)
    end)
    self.maid:Add(P.FontChanged:Connect(function()
        if self.Destroyed then
            return
        end
        self._railFloorCache = nil
        self._railWidth = nil
        self:_layoutRail(false)
    end))

    local mode = MODES[self.Mode]
    local size = config.Size
    if typeof(size) == "UDim2" then
        size = Vector2.new(size.X.Offset, size.Y.Offset)
    elseif typeof(size) ~= "Vector2" then
        size = mode.size
    end
    self.MinSize = typeof(config.MinSize) == "Vector2" and config.MinSize or Vector2.new(420, 300)
    self.Resizable = config.Resizable ~= false

    local screen = Util.viewport() + Util.guiInset()
    self.root = P.frame({
        Name = "Window",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(math.round(screen.X / 2), math.round(screen.Y / 2)),
        Size = UDim2.fromOffset(size.X, size.Y),
        BackgroundTransparency = Util.num(config.Transparency, 0),
        ClipsDescendants = true,
        Parent = self.gui,
    })
    self.maid:Add(Theme.bind(self.root, "BackgroundColor3", "Background"))
    P.corner(self.root, Theme.number("Radius", 5) + 1)
    local _, rootStroke = P.stroke(self.root, "Border", 1, Theme.number("BorderT", 0.9) - 0.04)
    self.maid:Add(rootStroke)

    self.scale = Util.new("UIScale", { Scale = 1, Parent = self.root })

    self.header = P.frame({
        Name = "Header",
        Size = UDim2.new(1, 0, 0, Theme.number("HeaderHeight", 48)),
        Parent = self.root,
    })
    local headerLine, headerLineBinding = P.hairline(self.header, { fade = true, edge = 0.12 })
    self.maid:Add(headerLineBinding)
    self.headerLine = headerLine

    local titleX = 16
    self.IconSize = math.clamp(Util.num(config.IconSize, 28), 14, 44)
    self.TabIconSize = math.clamp(Util.num(config.TabIconSize, 13), 10, 24)
    self.DockIconSize = math.clamp(Util.num(config.DockIconSize, 17), 12, 28)
    self.iconSlot = P.frame({
        Name = "Icon",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 15, 0.5, 0),
        Size = UDim2.fromOffset(self.IconSize, self.IconSize),
        BackgroundTransparency = 1,
        Visible = false,
        Parent = self.header,
    })
    if config.Icon then
        self:SetIcon(config.Icon)
        titleX = 15 + self.IconSize + 11
    end

    self.LogoStyle = config.Logo == true or config.TitleStyle == "logo"

    if self.LogoStyle then
        local logo, logoBindings, logoConnection = P.logo(self.header, {
            text = self.Title,
            size = Util.num(config.LogoSize, 21),
            depth = Util.num(config.LogoDepth, 4),
            accentFrom = Util.num(config.LogoAccentFrom, nil),
            position = UDim2.fromOffset(titleX, self.Subtitle and 5 or 12),
            frameSize = UDim2.new(1, -titleX - 120, 0, 26),
        })
        self.logo = logo
        self.maid:AddAll(logoBindings)
        self.maid:Add(logoConnection)
        self.titleLabel = logo:FindFirstChild("Face")
    else
        self.titleLabel = P.text({
            Name = "Title",
            Position = UDim2.fromOffset(titleX, self.Subtitle and 9 or 0),
            Size = self.Subtitle and UDim2.new(1, -titleX - 120, 0, 16) or UDim2.new(1, -titleX - 120, 1, 0),
            Text = self.Title,
            TextSize = P.Size.Title,
            FontFace = P.Font.Medium,
            Parent = self.header,
        })
        self.maid:Add(Theme.bind(self.titleLabel, "TextColor3", "Text"))
    end

    if self.Subtitle then
        self.subtitleLabel = P.text({
            Name = "Subtitle",
            Position = UDim2.fromOffset(titleX, self.LogoStyle and 30 or 26),
            Size = UDim2.new(1, -titleX - 120, 0, 13),
            Text = self.Subtitle,
            TextSize = P.Size.Small,
            Parent = self.header,
        })
        self.maid:Add(Theme.bind(self.subtitleLabel, "TextColor3", "Muted"))
    end

    self.actions = P.frame({
        Name = "Actions",
        AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0),
        Size = UDim2.fromOffset(110, 24),
        Parent = self.header,
    })
    P.list(self.actions, {
        horizontal = true,
        gap = 2,
        align = Enum.HorizontalAlignment.Right,
        valign = Enum.VerticalAlignment.Center,
    })

    headerButton(self, self.actions, "search", 1, function()
        self:Search()
    end)
    headerButton(self, self.actions, "layers", 2, function()
        self:CycleMode()
    end)
    headerButton(self, self.actions, "minus", 3, function()
        self:SetMinimised(not self.Minimised)
    end)
    headerButton(self, self.actions, "close", 4, function()
        self:Close()
    end)

    self.body = P.frame({
        Name = "Body",
        Position = UDim2.fromOffset(0, Theme.number("HeaderHeight", 48)),
        Size = UDim2.new(1, 0, 1, -Theme.number("HeaderHeight", 48) - Theme.number("FooterHeight", 24)),
        Parent = self.root,
    })

    self.railFrame = P.frame({
        Name = "Rail",
        Size = UDim2.new(0, mode.rail, 1, 0),
        BackgroundTransparency = 1,
        Parent = self.body,
    })
    local railLine, railLineBinding = P.hairline(self.railFrame, {
        vertical = true,
        fade = true,
        edge = 0.06,
        position = UDim2.fromScale(1, 0),
        anchor = Vector2.new(1, 0),
    })
    self.maid:Add(railLineBinding)
    self.railLine = railLine

    self.rail = Scroller.new({
        name = "Tabs",
        size = UDim2.new(1, -16, 1, -16),
        position = UDim2.fromOffset(10, 10),
        gap = 2,
    })
    self.rail.frame.Parent = self.railFrame
    self.maid:Add(self.rail)

    self.markerGlow = P.frame({
        Name = "MarkerGlow",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(22, 30),
        BackgroundTransparency = 1,
        Visible = false,
        ZIndex = 4,
        Parent = self.railFrame,
    })
    P.corner(self.markerGlow, 8)
    self.maid:Add(Theme.bind(self.markerGlow, "BackgroundColor3", "Accent"))
    Util.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.35),
            NumberSequenceKeypoint.new(1, 1),
        }),
        Parent = self.markerGlow,
    })

    self.marker = P.frame({
        Name = "TabMarker",
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromOffset(3, 0),
        Size = UDim2.fromOffset(3, 0),
        BackgroundTransparency = 0,
        ZIndex = 6,
        Parent = self.railFrame,
    })
    P.corner(self.marker, 2)
    self.maid:Add(Theme.bind(self.marker, "BackgroundColor3", "Accent"))

    self.maid:Add(self.rail.frame:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        self:_moveMarker(self.activeTab, false)
    end))
    self.maid:Add(self.root:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        self:_placeDock()
    end))
    self.maid:Add(self.root:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        self:_placeDock()
        self:_layoutRail(false)
    end))

    self.dock = P.frame({
        Name = "Dock",
        Size = UDim2.fromOffset(DOCK_W, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 0,
        Visible = false,
        ZIndex = 3,
        Parent = self.gui,
    })
    self.maid:Add(self.dock)
    P.corner(self.dock, 14)
    self.maid:Add(Theme.bind(self.dock, "BackgroundColor3", "Background"))
    local _, dockStroke = P.stroke(self.dock, "Border", 1, Theme.number("BorderT", 0.9) - 0.04)
    self.maid:Add(dockStroke)
    P.pad(self.dock, DOCK_PAD, DOCK_PAD, DOCK_PAD, DOCK_PAD)

    self.dockList = P.frame({
        Name = "List",
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        Parent = self.dock,
    })
    P.list(self.dockList, { gap = 6, align = Enum.HorizontalAlignment.Center })

    self.dockScale = Util.new("UIScale", { Scale = 1, Parent = self.dock })

    self.pages = Scroller.new({
        name = "Pages",
        size = UDim2.new(1, -mode.rail, 1, 0),
        position = UDim2.fromOffset(mode.rail, 0),
        padding = { top = 6, right = 18, bottom = 18, left = 18 },
    })
    self.pages.frame.Parent = self.body
    self.maid:Add(self.pages)

    self.footer = P.frame({
        Name = "Footer",
        AnchorPoint = Vector2.new(0, 1),
        Position = UDim2.fromScale(0, 1),
        Size = UDim2.new(1, 0, 0, Theme.number("FooterHeight", 24)),
        Parent = self.root,
    })
    local footerLine, footerLineBinding = P.hairline(self.footer, {
        fade = true,
        edge = 0.12,
        position = UDim2.fromScale(0, 0),
        anchor = Vector2.new(0, 0),
    })
    self.maid:Add(footerLineBinding)
    self.footerLine = footerLine

    local brand, brandVersion = Util.executor()
    self.Executor = brand

    self.statusGroup = P.frame({
        Name = "Status",
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(0.6, -16, 1, 0),
        Parent = self.footer,
    })

    self.statusGlow = P.frame({
        Name = "Glow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(3, math.floor(Theme.number("FooterHeight", 24) / 2)),
        Size = UDim2.fromOffset(14, 14),
        BackgroundTransparency = 0.82,
        Parent = self.statusGroup,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.statusGlow })
    self.statusGlowBinding = Theme.bind(self.statusGlow, "BackgroundColor3", "Accent")
    self.maid:Add(self.statusGlowBinding)

    self.statusDot = P.frame({
        Name = "Dot",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromOffset(3, math.floor(Theme.number("FooterHeight", 24) / 2)),
        Size = UDim2.fromOffset(5, 5),
        BackgroundTransparency = 0,
        ZIndex = 2,
        Parent = self.statusGroup,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = self.statusDot })
    self.statusDotBinding = Theme.bind(self.statusDot, "BackgroundColor3", "Accent")
    self.maid:Add(self.statusDotBinding)

    self.statusLabel = P.text({
        Name = "Label",
        Position = UDim2.fromOffset(14, 0),
        Size = UDim2.new(1, -14, 1, 0),
        Text = Util.str(config.Status, brand or "unknown"),
        TextSize = 11,
        FontFace = P.Font.Display,
        Parent = self.statusGroup,
    })
    self.statusBinding = Theme.bind(self.statusLabel, "TextColor3", "Accent")
    self.maid:Add(self.statusBinding)

    if brandVersion and not config.Status then
        self.statusVersion = P.text({
            Name = "Version",
            Position = UDim2.fromOffset(14, 0),
            Size = UDim2.new(1, -14, 1, 0),
            Text = "",
            TextSize = P.Size.Micro,
            FontFace = P.Font.Mono,
            Parent = self.statusGroup,
        })
        self.maid:Add(Theme.bind(self.statusVersion, "TextColor3", "Faint"))
        self.statusVersionText = brandVersion
        task.defer(function()
            if self.Destroyed or not self.statusVersion then
                return
            end
            self.statusVersion.Position = UDim2.fromOffset(
                14 + self.statusLabel.TextBounds.X + 7,
                0
            )
            self.statusVersion.Text = brandVersion
        end)
    end

    task.spawn(function()
        while not self.Destroyed do
            Motion.play(self.statusGlow, { BackgroundTransparency = 0.94 }, {
                duration = 1.1,
                easing = Enum.EasingStyle.Sine,
                direction = Enum.EasingDirection.InOut,
            })
            task.wait(1.1)
            if self.Destroyed then
                return
            end
            Motion.play(self.statusGlow, { BackgroundTransparency = 0.78 }, {
                duration = 1.1,
                easing = Enum.EasingStyle.Sine,
                direction = Enum.EasingDirection.InOut,
            })
            task.wait(1.1)
        end
    end)

    self.hintLabel = P.text({
        Name = "Hint",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -30, 0, 0),
        Size = UDim2.new(0.4, -30, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Right,
        Text = "",
        TextSize = P.Size.Micro,
        FontFace = P.Font.Mono,
        Parent = self.footer,
    })
    self.hintBinding = Theme.bind(self.hintLabel, "TextColor3", "Faint")
    self.maid:Add(self.hintBinding)
    self.maid:Add(self.root:GetPropertyChangedSignal("Size"):Connect(function()
        self:_updateHint()
    end))
    self:_updateHint()

    self.overlay = Overlay.new(self.gui)
    self.maid:Add(self.overlay)

    buildBackdrop(self, Util.str(config.Backdrop, "aurora"))

    self:_setupDrag(config)
    self:_setupResize(config)
    self:_setupViewport()

    local toggleKey = config.ToggleKey
    if typeof(toggleKey) == "EnumItem" then
        self.ToggleKey = toggleKey
    elseif type(toggleKey) == "string" then
        local ok, code = pcall(function()
            return Enum.KeyCode[toggleKey]
        end)
        self.ToggleKey = ok and code or Enum.KeyCode.RightShift
    else
        self.ToggleKey = Enum.KeyCode.RightShift
    end
    self:SetToggleKey(self.ToggleKey)

    if config.Launcher ~= false then
        self.launcher = Launcher.new(self, config)
        if self.launcher then
            self.maid:Add(self.launcher)
        end
    end

    self.scale.Scale = 0.94
    self.root.BackgroundTransparency = 1
    Motion.play(self.scale, { Scale = 1 }, {
        duration = 0.3,
        easing = Enum.EasingStyle.Quint,
    })
    Motion.play(self.root, { BackgroundTransparency = Util.num(config.Transparency, 0) }, {
        duration = 0.2,
        easing = Enum.EasingStyle.Sine,
    })

    return self
end

function Window:_setupDrag(config)
    if config.Draggable == false then
        return
    end
    local grip = P.hitbox({
        Name = "DragGrip",
        Size = UDim2.new(1, -130, 1, 0),
        ZIndex = 2,
        Parent = self.header,
    })
    self.maid:Add(grip)

    local dragMaid = self.maid:Extend()
    self.maid:Add(grip.MouseButton1Down:Connect(function()
        local start, origin
        dragMaid:Clean()
        dragMaid:Add(Input.PointerMoved:Connect(function(position)
            if not start then
                start = position
                origin = self.root.Position
                return
            end
            local delta = position - start
            self.root.Position = UDim2.new(
                origin.X.Scale, origin.X.Offset + delta.X,
                origin.Y.Scale, origin.Y.Offset + delta.Y
            )
        end))
        dragMaid:Add(Input.PointerUp:Connect(function()
            dragMaid:Clean()
            self:_clampToViewport()
        end))
    end))
end

function Window:_setupResize(config)
    if config.Resizable == false then
        return
    end
    local grip = P.hitbox({
        Name = "Resizer",
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.fromScale(1, 1),
        Size = UDim2.fromOffset(24, 24),
        ZIndex = 20,
        Parent = self.root,
    })
    self.maid:Add(grip)
    self.resizer = grip
    grip.Visible = self.Resizable ~= false

    local dots = {}
    local dotBindings = {}
    local spec = {
        { x = 0.76, y = 0.76 },
        { x = 0.52, y = 0.76 },
        { x = 0.76, y = 0.52 },
        { x = 0.28, y = 0.76 },
        { x = 0.52, y = 0.52 },
        { x = 0.76, y = 0.28 },
    }
    for index, entry in ipairs(spec) do
        local dot = P.frame({
            Name = "Dot" .. index,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(entry.x, entry.y),
            Size = UDim2.fromOffset(3, 3),
            BackgroundTransparency = 0.45,
            ZIndex = 21,
            Parent = grip,
        })
        Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = dot })
        local binding = Theme.bind(dot, "BackgroundColor3", "Muted")
        self.maid:Add(binding)
        dots[index] = dot
        dotBindings[index] = binding
    end

    self.maid:Add(P.interactive(grip, {
        render = function(state)
            local lit = state.hovered or state.pressed
            for index, dot in ipairs(dots) do
                Theme.rebind(dotBindings[index], lit and "Accent" or "Muted")
                Motion.hover(dot, {
                    BackgroundTransparency = lit and 0 or 0.45,
                    Size = UDim2.fromOffset(lit and 4 or 3, lit and 4 or 3),
                })
            end
        end,
    }))

    local dragMaid = self.maid:Extend()
    self.maid:Add(grip.MouseButton1Down:Connect(function()
        if self.Minimised or not self.Resizable then
            return
        end
        local start, origin
        dragMaid:Clean()
        self._resizing = true
        self:_updateHint()
        Theme.rebind(self.hintBinding, "Accent")
        dragMaid:Add(function()
            if not self.Destroyed then
                self._resizing = false
                Theme.rebind(self.hintBinding, "Faint")
                self:_updateHint()
            end
        end)
        dragMaid:Add(Input.PointerMoved:Connect(function(position)
            if not start then
                start = position
                origin = Vector2.new(self.root.Size.X.Offset, self.root.Size.Y.Offset)
                return
            end
            local delta = (position - start) / math.max(0.01, self.scale.Scale)
            local screen = Util.viewport() + Util.guiInset()
            local width = Util.clamp(origin.X + delta.X, self:_contentFloor(), screen.X - 20)
            local height = Util.clamp(origin.Y + delta.Y, self.MinSize.Y, screen.Y - 20)
            self.root.Size = UDim2.fromOffset(width, height)
        end))
        dragMaid:Add(Input.PointerUp:Connect(function()
            dragMaid:Clean()
        end))
    end))
end

function Window:_setupViewport()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end
    self.maid:Add(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        self:_clampToViewport()
    end))
    self:_clampToViewport()
end

function Window:_clampToViewport()
    local viewport = Util.viewport()
    local screen = viewport + Util.guiInset()
    local size = Vector2.new(self.root.Size.X.Offset, self.root.Size.Y.Offset)
    if size.X <= 0 or size.Y <= 0 then
        size = self.root.AbsoluteSize
    end

    local fit = 1
    if size.X > screen.X - 24 or size.Y > screen.Y - 24 then
        fit = math.min((screen.X - 24) / size.X, (screen.Y - 24) / size.Y)
    end
    self.scale.Scale = Util.clamp(fit, 0.55, 1)

    local scaled = size * self.scale.Scale
    local half = scaled / 2
    local centre = Vector2.new(self.root.Position.X.Offset, self.root.Position.Y.Offset)
    local x = Util.clamp(centre.X, half.X + 8, math.max(half.X + 8, screen.X - half.X - 8))
    local y = Util.clamp(centre.Y, half.Y + 8, math.max(half.Y + 8, screen.Y - half.Y - 8))
    self.root.Position = UDim2.fromOffset(x, y)
end

local MARKER_H = 18
local RAIL_ICON = 46
local RAIL_SIDE = 16
local RAIL_TEXT_X = 28
local RAIL_RIGHT = 12

function Window:_railFloor()
    if self._railFloorCache then
        return self._railFloorCache
    end
    local widest = 0
    for _, tab in ipairs(self.tabs) do
        if not tab.parent then
            local bounds = P.measure(tab.Name, P.Font.Medium, P.Size.Label)
            local width = bounds.X
            if tab.badgeFrame.Visible then
                width += tab.badgeFrame.Size.X.Offset + 8
            end
            if width > widest then
                widest = width
            end
        end
    end
    if widest <= 0 then
        return 120
    end
    self._railFloorCache = math.ceil(widest) + RAIL_SIDE + RAIL_TEXT_X + RAIL_RIGHT
    return self._railFloorCache
end

local PAGE_INSET = 44
local RAIL_SCALE = 0.23

function Window:_contentFloor()
    local floor = self.MinSize.X
    local tab = self.activeTab
    if not tab or not tab.ContentFloor then
        return floor
    end
    local content = tab:ContentFloor()
    if content <= 0 then
        return floor
    end

    local mode = MODES[self.Mode]
    local railFloor = self:_railFloor()
    local body = content + PAGE_INSET
    local needed

    if not mode.labels then
        needed = body + RAIL_ICON
    else
        local scaled = body / (1 - RAIL_SCALE)
        if scaled * RAIL_SCALE <= railFloor then
            needed = body + railFloor
        elseif scaled * RAIL_SCALE >= mode.rail then
            needed = body + mode.rail
        else
            needed = scaled
        end
    end

    local screen = Util.viewport() + Util.guiInset()
    return math.clamp(math.max(floor, math.ceil(needed)), floor, math.max(floor, screen.X - 20))
end

function Window:_ensureWidth(animate)
    if self.Destroyed or self.Minimised then
        return self
    end
    local floor = self:_contentFloor()
    local current = self.root.Size.X.Offset
    if current >= floor then
        return self
    end
    Motion.play(self.root, {
        Size = UDim2.fromOffset(floor, self.root.Size.Y.Offset),
    }, {
        duration = animate and Motion.Duration.Slow or 0,
        easing = Enum.EasingStyle.Quint,
    })
    task.delay(animate and Motion.Duration.Slow or 0, function()
        if not self.Destroyed then
            self:_clampToViewport()
        end
    end)
    return self
end

-- text measurement can under-report, so confirm against the laid out labels
function Window:_verifyRail()
    if self.Destroyed or not self._railWidth then
        return
    end
    local deficit = 0
    for _, tab in ipairs(self.tabs) do
        if not tab.parent and tab.label.Visible then
            local need = tab.label.TextBounds.X - tab.label.AbsoluteSize.X
            if need > deficit then
                deficit = need
            end
        end
    end
    if deficit <= 0.5 then
        return
    end
    self._railFloorCache = (self._railFloorCache or 120) + math.ceil(deficit) + 2
    self._railWidth = nil
    self:_layoutRail(false)
end

function Window:_layoutRail(animate)
    local mode = MODES[self.Mode]

    local width = self.root.Size.X.Offset
    if width <= 0 then
        width = self.root.AbsoluteSize.X
    end

    local floor = self:_railFloor()
    local iconOnly = not mode.labels or width < floor * 3.6
    local target = iconOnly and RAIL_ICON
        or Util.clamp(math.floor(width * RAIL_SCALE), floor, mode.rail)

    if self._railWidth == target then
        return
    end
    self._railWidth = target

    for _, entry in ipairs(self.tabs) do
        if not entry.parent then
            entry.label.Visible = not iconOnly
            entry.badgeFrame.Visible = not iconOnly and entry.badgeLabel.Text ~= ""
            entry:SetIconOnly(iconOnly)
        end
    end

    local duration = animate and Motion.Duration.Fast or 0
    Motion.play(self.railFrame, { Size = UDim2.new(0, target, 1, 0) }, {
        duration = duration,
        easing = Enum.EasingStyle.Quint,
    })
    Motion.play(self.pages.frame, {
        Size = UDim2.new(1, -target, 1, 0),
        Position = UDim2.fromOffset(target, 0),
    }, { duration = duration, easing = Enum.EasingStyle.Quint })

    task.defer(function()
        if not self.Destroyed then
            self:_moveMarker(self.activeTab, false)
            self:_verifyRail()
        end
    end)
end


function Window:_placeDock()
    if not self.dock or not self.dock.Visible then
        return
    end
    local origin = self.root.AbsolutePosition
    local size = self.root.AbsoluteSize
    local height = self.dock.AbsoluteSize.Y
    local viewport = Util.viewport()

    local left = origin.X - DOCK_W - DOCK_GAP
    if left < 8 then
        left = origin.X + size.X + DOCK_GAP
    end
    left = Util.clamp(left, 8, math.max(8, viewport.X - DOCK_W - 8))

    local top = Util.clamp(
        origin.Y + 4,
        8,
        math.max(8, viewport.Y - height - 8)
    )

    local inset = Util.guiInset()
    self.dock.Position = UDim2.fromOffset(left + inset.X, top + inset.Y)
end

function Window:_showDock(root, animate)
    local wanted = root ~= nil and #root.subs > 0 and not self.Minimised and not self.loader
    for _, tab in ipairs(self.tabs) do
        if tab.subContainer then
            tab.subContainer.Visible = wanted and tab == root
        end
    end

    if not wanted then
        if self.dock.Visible then
            Motion.play(self.dockScale, { Scale = 0.9 }, {
                duration = Motion.Duration.Fast,
                onDone = function()
                    if not self.Destroyed then
                        self.dock.Visible = false
                    end
                end,
            })
            Motion.play(self.dock, { BackgroundTransparency = 1 }, { duration = Motion.Duration.Fast })
        end
        return
    end

    self.dock.Visible = true
    self:_placeDock()
    task.defer(function()
        if not self.Destroyed then
            self:_placeDock()
        end
    end)

    if animate then
        Motion.set(self.dockScale, { Scale = 0.9 })
        Motion.play(self.dockScale, { Scale = 1 }, {
            duration = Motion.Duration.Slow,
            easing = Enum.EasingStyle.Back,
        })
    else
        Motion.set(self.dockScale, { Scale = 1 })
    end
    Motion.play(self.dock, { BackgroundTransparency = 0 }, { duration = Motion.Duration.Fast })
end

function Window:_moveMarker(tab, animate)
    if not self.marker then
        return
    end
    tab = tab and tab:Root() or nil
    if not tab or tab.Destroyed or not tab.button.Parent then
        Motion.play(self.marker, { Size = UDim2.fromOffset(3, 0) }, { duration = Motion.Duration.Fast })
        Motion.play(self.markerGlow, { BackgroundTransparency = 1 }, { duration = Motion.Duration.Fast })
        return
    end

    if tab.button.AbsoluteSize.Y <= 0 then
        task.defer(function()
            if not self.Destroyed and self.activeTab == tab then
                self:_moveMarker(tab, false)
            end
        end)
        return
    end

    local railTop = self.railFrame.AbsolutePosition.Y
    local target = tab.button.AbsolutePosition.Y + tab.button.AbsoluteSize.Y / 2 - railTop
    local current = self.marker.Position.Y.Offset

    if not animate or not Motion.isEnabled() or self.marker.Size.Y.Offset == 0 then
        Motion.set(self.marker, {
            Position = UDim2.fromOffset(3, target),
            Size = UDim2.fromOffset(3, MARKER_H),
        })
        Motion.set(self.markerGlow, {
            Position = UDim2.fromOffset(0, target),
            BackgroundTransparency = 0.86,
        })
        return
    end

    local distance = math.abs(target - current)
    if distance < 1 then
        Motion.play(self.marker, {
            Position = UDim2.fromOffset(3, target),
            Size = UDim2.fromOffset(3, MARKER_H),
        }, { duration = Motion.Duration.Fast })
        Motion.play(self.markerGlow, { Position = UDim2.fromOffset(0, target) }, {
            duration = Motion.Duration.Fast,
        })
        return
    end
    local midpoint = (target + current) / 2

    Motion.cancel(self.marker)
    Motion.play(self.marker, {
        Position = UDim2.fromOffset(3, midpoint),
        Size = UDim2.fromOffset(2, MARKER_H + distance),
    }, {
        duration = 0.16,
        easing = Enum.EasingStyle.Quint,
        onDone = function()
            if self.Destroyed then
                return
            end
            local current = self.activeTab and self.activeTab:Root() or nil
            if current ~= tab then
                return
            end
            Motion.play(self.marker, {
                Position = UDim2.fromOffset(3, target),
                Size = UDim2.fromOffset(3, MARKER_H),
            }, { duration = 0.22, easing = Enum.EasingStyle.Quint })
        end,
    })

    Motion.cancel(self.markerGlow)
    Motion.play(self.markerGlow, { Position = UDim2.fromOffset(0, target) }, {
        duration = 0.26,
        easing = Enum.EasingStyle.Quint,
    })
    Motion.play(self.markerGlow, { BackgroundTransparency = 0.58 }, {
        duration = 0.14,
        easing = Enum.EasingStyle.Sine,
        onDone = function()
            if self.Destroyed then
                return
            end
            local current = self.activeTab and self.activeTab:Root() or nil
            if current ~= tab then
                return
            end
            Motion.play(self.markerGlow, { BackgroundTransparency = 0.86 }, {
                duration = 0.34,
                easing = Enum.EasingStyle.Sine,
            })
        end,
    })
end

function Window:CreateTab(config)
    if self.Destroyed then
        Log.warn("window", "adding a tab to a destroyed window")
        return nil
    end
    local tab = Tab.new(self, config)
    self._railWidth = nil
    self._railFloorCache = nil
    self:_layoutRail(false)
    if not self.activeTab and not tab.Disabled then
        task.defer(function()
            if not self.Destroyed and not self.activeTab then
                self:SelectTab(tab)
            end
        end)
    end
    return tab
end

Window.Tab = Window.CreateTab

function Window:SelectTab(target)
    if type(target) == "string" then
        local needle = Util.normalise(target)
        for _, tab in ipairs(self.tabs) do
            if Util.normalise(tab.Name) == needle then
                target = tab
                break
            end
        end
    end
    if type(target) ~= "table" or target.Destroyed or target.Disabled then
        return self
    end
    if self.activeTab == target then
        return self
    end

    if #target.subs > 0 then
        for _, sub in ipairs(target.subs) do
            if not sub.Disabled then
                target = sub
                break
            end
        end
    end

    local previous = self.activeTab
    if previous == target then
        return self
    end
    self.activeTab = target

    local from = previous and Util.indexOf(self.tabs, previous) or 0
    local to = Util.indexOf(self.tabs, target) or 0
    local downwards = to >= from

    if previous then
        previous.page.Visible = false
        previous:Repaint()
        if previous.parent then
            previous.parent:Repaint()
        end
    end

    self:_showDock(target:Root(), previous ~= nil)

    target.page.Visible = true
    Motion.cancel(target.page)
    target.page.Position = UDim2.fromOffset(0, downwards and 14 or -14)
    Motion.play(target.page, { Position = UDim2.fromOffset(0, 0) }, {
        duration = Motion.Duration.Slow,
        easing = Enum.EasingStyle.Quint,
    })

    target:Repaint()
    if target.parent then
        target.parent:Repaint()
    end
    target:PlaySelect()
    self:_moveMarker(target, previous ~= nil)
    self.pages:ScrollToTop()
    self.TabChanged:Fire(target, previous)
    return self
end

function Window:SetTabOrder(names)
    if type(names) ~= "table" then
        Log.warn("window", "SetTabOrder expects a list of names")
        return self
    end

    local rank = {}
    for index, name in ipairs(names) do
        rank[Util.normalise(name)] = index
    end

    local function rankOf(tab)
        local key = Util.normalise(tab.Name)
        local exact = rank[key]
        if exact then
            return exact
        end
        for listed, index in pairs(rank) do
            if #listed > 0 and string.sub(key, 1, #listed) == listed then
                return index
            end
        end
        return nil
    end

    local tail = #names
    for _, tab in ipairs(self.tabs) do
        if not tab.parent and tab.button then
            local at = rankOf(tab)
            if at then
                tab.button.LayoutOrder = at
            else
                tail += 1
                tab.button.LayoutOrder = tail
            end
        end
    end

    task.defer(function()
        if not self.Destroyed then
            self:_moveMarker(self.activeTab, false)
        end
    end)
    return self
end

function Window:GetTab(name)
    local needle = Util.normalise(name)
    for _, tab in ipairs(self.tabs) do
        if Util.normalise(tab.Name) == needle then
            return tab
        end
    end
    return nil
end

function Window:SetMode(mode)
    local preset = MODES[mode]
    if not preset then
        Log.warn("window", "unknown mode '" .. tostring(mode) .. "'")
        return self
    end
    self.Mode = mode
    self._railWidth = nil
    self._railFloorCache = nil
    local width = math.max(preset.size.X, self:_contentFloor())
    Motion.play(self.root, { Size = UDim2.fromOffset(width, preset.size.Y) }, {
        duration = Motion.Duration.Slow,
    })

    task.delay(Motion.Duration.Slow, function()
        if not self.Destroyed then
            self:_clampToViewport()
            self._railWidth = nil
            self:_layoutRail(true)
            if self.activeTab and self.activeTab._layoutColumns then
                self.activeTab:_layoutColumns(true)
            end
            self:_moveMarker(self.activeTab, false)
            self:_placeDock()
        end
    end)
    return self
end

function Window:CycleMode()
    local order = { "Compact", "Normal", "Expanded" }
    local index = Util.indexOf(order, self.Mode) or 2
    return self:SetMode(order[index % #order + 1])
end

function Window:SetMinimised(state)
    local minimised = state == true
    if self.Minimised == minimised then
        return self
    end
    self.Minimised = minimised
    local headerHeight = Theme.number("HeaderHeight", 48)

    if minimised then
        self.restoreSize = self.root.Size
        self.body.Visible = false
        self.footer.Visible = false
        if self.resizer then
            self.resizer.Visible = false
        end
        if self.dock then
            self.dock.Visible = false
        end
        Motion.play(self.root, { Size = UDim2.new(self.root.Size.X.Scale, self.root.Size.X.Offset, 0, headerHeight) }, {
            duration = Motion.Duration.Base,
        })
    else
        Motion.play(self.root, { Size = self.restoreSize or UDim2.fromOffset(716, 468) }, {
            duration = Motion.Duration.Base,
            onDone = function()
                if self.Destroyed then
                    return
                end
                self.body.Visible = true
                self.footer.Visible = true
                if self.resizer then
                    self.resizer.Visible = self.Resizable
                end
                self:_showDock(self.activeTab and self.activeTab:Root() or nil, false)
                self:_placeDock()
            end,
        })
    end
    return self
end

function Window:SetLoading(state, text)
    local wanted = state == true

    if not wanted then
        if not self.loader then
            return self
        end
        local veil = self.loader
        self.loader = nil
        self.loaderTrack = nil
        self.loaderFill = nil
        self.loaderDetail = nil
        if self.loaderTick then
            self.loaderTick:Disconnect()
            self.loaderTick = nil
        end
        Motion.play(veil, { GroupTransparency = 1 }, {
            duration = Motion.Duration.Slow,
            easing = Enum.EasingStyle.Sine,
            onDone = function()
                veil:Destroy()
                if not self.Destroyed then
                    self:_showDock(self.activeTab and self.activeTab:Root() or nil, true)
                end
            end,
        })
        return self
    end

    if self.loader then
        if text and self.loaderLabel then
            self.loaderLabel.Text = Util.str(text, self.loaderLabel.Text)
        end
        return self
    end

    local veil = P.canvas({
        Name = "Loader",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 0,
        ZIndex = 40,
        Parent = self.body,
    })
    self.maid:Add(veil)
    self.maid:Add(Theme.bind(veil, "BackgroundColor3", "Background"))
    self.loader = veil
    if self.dock then
        self.dock.Visible = false
    end

    local washes = {}
    local WASH = {
        {
            tokens = { "Accent", "Info", "Accent" },
            band = { { 0, 1 }, { 0.24, 0.92 }, { 0.5, 0.79 }, { 0.76, 0.92 }, { 1, 1 } },
            spin = 9,
        },
        {
            tokens = { "Info", "Accent", "Info" },
            band = { { 0, 1 }, { 0.36, 0.93 }, { 0.64, 0.85 }, { 1, 1 } },
            spin = -6,
            tilt = 40,
        },
    }
    for index, spec in ipairs(WASH) do
        local frame = P.frame({
            Name = "Wash" .. index,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1.8, 1.8),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0,
            Parent = veil,
        })
        local points = {}
        for _, entry in ipairs(spec.band) do
            table.insert(points, NumberSequenceKeypoint.new(entry[1], entry[2]))
        end
        local gradient = Util.new("UIGradient", {
            Transparency = NumberSequence.new(points),
            Rotation = spec.tilt or 0,
            Parent = frame,
        })
        local function repaint()
            local stops = {}
            for at, token in ipairs(spec.tokens) do
                table.insert(stops, ColorSequenceKeypoint.new(
                    (at - 1) / (#spec.tokens - 1), Theme.color(token)))
            end
            gradient.Color = ColorSequence.new(stops)
        end
        repaint()
        self.maid:Add(Theme.Changed:Connect(repaint))
        washes[index] = { gradient = gradient, spin = spec.spin, tilt = spec.tilt or 0 }
    end

    local ring = P.frame({
        Name = "Ring",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, -14),
        Size = UDim2.fromOffset(34, 34),
        BackgroundTransparency = 1,
        Parent = veil,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = ring })

    local track = Util.new("UIStroke", {
        Thickness = 3,
        Transparency = 0.86,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = ring,
    })
    self.maid:Add(Theme.bind(track, "Color", "Faint"))

    local sweep = P.frame({
        Name = "Sweep",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Parent = ring,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sweep })
    local arc = Util.new("UIStroke", {
        Thickness = 3,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = sweep,
    })
    self.maid:Add(Theme.bind(arc, "Color", "Accent"))
    local spin = Util.new("UIGradient", {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.42, 1),
            NumberSequenceKeypoint.new(0.72, 0.1),
            NumberSequenceKeypoint.new(1, 0),
        }),
        Parent = arc,
    })

    self.loaderLabel = P.text({
        Name = "Caption",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5, 16),
        Size = UDim2.new(1, -40, 0, 16),
        Text = Util.str(text, "Loading"),
        TextSize = P.Size.Small,
        FontFace = P.Font.Medium,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = veil,
    })
    self.maid:Add(Theme.bind(self.loaderLabel, "TextColor3", "Muted"))

    local track = P.frame({
        Name = "Track",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5, 42),
        Size = UDim2.fromOffset(208, 3),
        BackgroundTransparency = 0.92,
        Parent = veil,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = track })
    self.maid:Add(Theme.bind(track, "BackgroundColor3", "Text"))
    self.loaderTrack = track

    local fill = P.frame({
        Name = "Fill",
        Size = UDim2.new(0, 0, 1, 0),
        BackgroundTransparency = 0,
        Parent = track,
    })
    Util.new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = fill })
    self.maid:Add(Theme.bind(fill, "BackgroundColor3", "Accent"))
    self.loaderFill = fill

    self.loaderDetail = P.text({
        Name = "Detail",
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 0.5, 56),
        Size = UDim2.new(1, -40, 0, 14),
        Text = "",
        TextSize = P.Size.Small,
        FontFace = P.Font.Mono,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = veil,
    })
    self.maid:Add(Theme.bind(self.loaderDetail, "TextColor3", "Muted"))

    veil.GroupTransparency = 1
    Motion.play(veil, { GroupTransparency = 0 }, {
        duration = Motion.Duration.Base,
        easing = Enum.EasingStyle.Sine,
    })

    local clock = 0
    self.loaderTick = RunService.Heartbeat:Connect(function(delta)
        if self.Destroyed or not veil.Parent then
            return
        end
        clock += math.min(delta, 0.1)
        spin.Rotation = (clock * 260) % 360
        for _, wash in ipairs(washes) do
            wash.gradient.Rotation = (wash.tilt + clock * wash.spin) % 360
        end
    end)

    return self
end

function Window:SetLoadingProgress(alpha, detail)
    if not self.loader then
        return self
    end
    local value = Util.clamp(Util.num(alpha, 0), 0, 1)
    if self.loaderFill then
        Motion.play(self.loaderFill, { Size = UDim2.new(value, 0, 1, 0) }, {
            duration = Motion.Duration.Fast,
            easing = Enum.EasingStyle.Sine,
        })
    end
    if self.loaderDetail and detail ~= nil then
        self.loaderDetail.Text = Util.str(detail, "")
    end
    return self
end

function Window:MoveTab(tab, index)
    if tab == nil or tab.parent ~= nil then
        return self
    end
    local roots = {}
    for _, entry in ipairs(self.tabs) do
        if entry.parent == nil then
            roots[#roots + 1] = entry
        end
    end
    local from = Util.indexOf(roots, tab)
    if not from then
        return self
    end
    local target = math.clamp(math.floor(tonumber(index) or from), 1, #roots)
    table.remove(roots, from)
    table.insert(roots, target, tab)
    for order, entry in ipairs(roots) do
        if entry.button then
            entry.button.LayoutOrder = order
        end
    end
    return self
end

function Window:SetVisible(state)
    local visible = state ~= false
    self.Hidden = not visible
    if visible then
        self.gui.Enabled = true
        self.root.Visible = true
        self:_placeDock()
        Motion.play(self.root, { BackgroundTransparency = 0 }, { duration = Motion.Duration.Fast })
    else
        self.overlay:CloseAll()
        self.root.Visible = false
        self.gui.Enabled = false
    end
    if self.launcher then
        self.launcher:_paint()
    end
    return self
end

function Window:SetLauncherVisible(state)
    if self.launcher then
        self.launcher:SetVisible(state)
    end
    return self
end

function Window:SetLauncherIcon(name)
    if self.launcher then
        self.launcher:SetIcon(name)
    end
    return self
end

function Window:SetLauncherPosition(position)
    if self.launcher then
        self.launcher:SetPosition(position)
    end
    return self
end

function Window:Toggle()
    return self:SetVisible(self.Hidden)
end

function Window:SetToggleKey(key)
    if self.hotkey then
        Input.unbindHotkey(self.hotkey)
        self.hotkey = nil
    end
    if typeof(key) ~= "EnumItem" then
        return self
    end
    self.ToggleKey = key
    self.hotkey = Input.bindHotkey(key, function()
        if not self.Destroyed then
            self:Toggle()
        end
    end)
    self.maid:Add(function()
        if self.hotkey then
            Input.unbindHotkey(self.hotkey)
        end
    end)
    self.ToggleHint = Input.describe(key) .. "  toggle"
    self:_updateHint()
    return self
end

function Window:_updateHint()
    if self.Destroyed or not self.hintLabel then
        return
    end
    local mode = self.HintMode or "size"
    if mode == "keybind" or (mode == "size" and not self._resizing) then
        self.hintLabel.Text = self.ToggleHint or ""
        return
    end
    local size = self.root.Size
    self.hintLabel.Text = string.format("%d x %d", size.X.Offset, size.Y.Offset)
end

function Window:SetHintMode(mode)
    self.HintMode = mode == "keybind" and "keybind" or "size"
    self:_updateHint()
    return self
end

function Window:SetIconSize(size)
    self.IconSize = math.clamp(Util.num(size, 28), 14, 44)
    if self.iconSlot then
        self.iconSlot.Size = UDim2.fromOffset(self.IconSize, self.IconSize)
        if self.Icon then
            self:SetIcon(self.Icon)
        end
    end
    return self
end

function Window:SetIcon(name)
    if not self.iconSlot then
        return self
    end
    if self.iconBindings then
        for _, binding in ipairs(self.iconBindings) do
            Theme.unbind(binding)
        end
    end
    self.iconBindings = nil
    for _, child in ipairs(self.iconSlot:GetChildren()) do
        child:Destroy()
    end

    if name == nil or name == false or name == "" then
        self.iconSlot.Visible = false
        return self
    end

    local box = self.IconSize or 28
    local glyph, bindings = Icons.create(name, { size = math.floor(box * 0.72), token = "Text" })
    if not glyph then
        self.iconSlot.Visible = false
        return self
    end

    glyph.AnchorPoint = Vector2.new(0.5, 0.5)
    glyph.Position = UDim2.fromScale(0.5, 0.5)
    glyph.Parent = self.iconSlot
    if glyph:IsA("ImageLabel") then
        glyph.Size = UDim2.fromScale(1, 1)
        glyph.ScaleType = Enum.ScaleType.Crop
        P.corner(glyph, math.max(4, math.floor(box * 0.28)))
        local _, stroke = P.stroke(glyph, "Border", 1, Theme.number("BorderT", 0.9) - 0.2)
        self.maid:Add(stroke)
    end
    self.iconBindings = bindings
    self.maid:AddAll(bindings)
    self.iconSlot.Visible = true
    self.Icon = name
    return self
end

function Window:SetTitle(text)
    self.Title = Util.str(text, self.Title)
    if self.logo then
        for _, child in ipairs(self.logo:GetChildren()) do
            if child:IsA("TextLabel") and child.Name ~= "Face" then
                child.Text = self.Title
            end
        end
    end
    self.titleLabel.Text = self.Title
    return self
end

function Window:SetSubtitle(text)
    local value = Util.str(text, "")
    if self.subtitleLabel then
        self.subtitleLabel.Text = value
    end
    return self
end

function Window:SetStatus(text, tone)
    local label = Util.str(text, self.statusLabel.Text)
    self.statusLabel.Text = label
    if self.statusVersion then
        local sameBrand = self.Executor ~= nil and label == self.Executor
        self.statusVersion.Text = sameBrand and (self.statusVersionText or "") or ""
    end
    Theme.rebind(self.statusBinding, tone or "Accent")
    Theme.rebind(self.statusDotBinding, tone or "Accent")
    Theme.rebind(self.statusGlowBinding, tone or "Accent")
    return self
end

function Window:ShowExecutor()
    if self.Executor then
        self:SetStatus(self.Executor)
        if self.statusVersion and self.statusVersionText then
            self.statusVersion.Text = self.statusVersionText
        end
    end
    return self
end

function Window:Tooltip(target, text)
    local Tooltip = require("ui/Tooltip")
    return Tooltip.attach(self, target, text)
end

function Window:SetResizable(state)
    self.Resizable = state ~= false
    if self.resizer then
        self.resizer.Visible = self.Resizable
    end
    return self
end

function Window:SetBackdrop(mode)
    local name = Util.str(mode, "aurora")
    if name ~= "flat" and name ~= "bloom" and name ~= "aurora" then
        Log.warn("window", "unknown backdrop '" .. tostring(mode) .. "'")
        return self
    end
    buildBackdrop(self, name)
    return self
end

function Window:Search()
    local Search = require("ui/Search")
    return Search.open(self)
end

function Window:CloseSearch()
    local Search = require("ui/Search")
    return Search.close(self)
end

function Window:Close()
    if self.Destroyed then
        return
    end
    self.overlay:CloseAll()
    local base = self.scale.Scale
    Motion.play(self.scale, { Scale = base * 0.92 }, {
        duration = 0.18,
        easing = Enum.EasingStyle.Quint,
    })
    Motion.play(self.root, { BackgroundTransparency = 1 }, {
        duration = 0.18,
        easing = Enum.EasingStyle.Sine,
        onDone = function()
            self:Destroy()
        end,
    })
    for _, child in ipairs(self.root:GetDescendants()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            Motion.play(child, { TextTransparency = 1 }, { duration = 0.12 })
        elseif child:IsA("ImageLabel") then
            Motion.play(child, { ImageTransparency = 1 }, { duration = 0.12 })
        elseif child:IsA("Frame") and child.BackgroundTransparency < 1 then
            Motion.play(child, { BackgroundTransparency = 1 }, { duration = 0.14 })
        elseif child:IsA("UIStroke") then
            Motion.play(child, { Transparency = 1 }, { duration = 0.12 })
        end
    end
end

function Window:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    self.searching = false
    self.Closed:Fire(self)
    self.overlay:CloseAll()
    for _, tab in ipairs(Util.list(self.tabs)) do
        tab:Destroy()
    end
    table.clear(self.tabs)
    self.maid:Destroy()
    if self.library then
        Util.remove(self.library.windows, self)
    end
end

return Window

end
Slate_modules["init"] = function(require)
local Util = require("core/Util")
local Log = require("core/Log")
local Theme = require("core/Theme")
local Motion = require("core/Motion")
local Input = require("core/Input")
local Signal = require("core/Signal")
local Registry = require("core/Registry")
local Config = require("core/Config")
local P = require("ui/Primitives")
local Icons = require("ui/Icons")
local Overlay = require("ui/Overlay")
local Notify = require("ui/Notify")
local Modal = require("ui/Modal")
local Tooltip = require("ui/Tooltip")
local ContextMenu = require("ui/ContextMenu")
local Window = require("ui/Window")

local Slate = {}
Slate.Version = "1.0.0"
Slate.Theme = Theme
Slate.Icons = Icons
Slate.Motion = Motion
Slate.Registry = Registry
Slate.windows = {}
Slate.Destroyed = false
Slate.WindowCreated = Signal.new()

function Slate:CreateWindow(config)
    if self.Destroyed then
        Log.warn("slate", "library has been destroyed")
        return nil
    end
    local window = Window.new(self, config or {})
    if window then
        table.insert(self.windows, window)
        self.WindowCreated:Fire(window)
    end
    return window
end

function Slate:Notify(config)
    return Notify.push(config)
end

function Slate:Modal(window, config)
    return Modal.open(window, config)
end

function Slate:Confirm(window, config)
    return Modal.confirm(window, config)
end

function Slate:Prompt(window, config)
    return Modal.prompt(window, config)
end

function Slate:ContextMenu(window, items, position)
    return ContextMenu.open(window, items, position)
end

function Slate:Tooltip(window, target, text)
    return Tooltip.attach(window, target, text)
end

function Slate:Config(options)
    return Config.new(options)
end

function Slate:SetDebug(state)
    Log.setEnabled(state == true)
    return self
end

function Slate:SetMotion(state)
    Motion.setEnabled(state ~= false)
    return self
end

function Slate:SetIconPack(name)
    Icons.setPack(name)
    return self
end

function Slate:PreloadIcons(names)
    Icons.preload(names)
    return self
end

function Slate:IconPacks()
    return Icons.sources()
end

function Slate:SetFont(sans, mono)
    P.setFamily(sans, mono)
    return self
end

function Slate:Fonts()
    return P.families()
end

function Slate:FontOptions(weight)
    local options = {}
    for _, family in ipairs(P.families()) do
        table.insert(options, {
            Name = family,
            Value = family,
            Font = P.fontFor(family, weight),
        })
    end
    return options
end

function Slate:FontSlots()
    return P.slots()
end

function Slate:SetFontFamily(name)
    P.setSlot("Sans", name)
    return self
end

function Slate:SetMonoFamily(name)
    P.setSlot("Mono", name)
    return self
end

function Slate:SetDisplayFamily(name)
    P.setSlot("Display", name)
    return self
end

function Slate:SetNotificationLimit(limit)
    Notify.setLimit(limit)
    return self
end

local place = nil
local placeWaiters = {}
local placePending = false

function Slate:PlaceInfo(callback)
    if place then
        if callback then
            task.spawn(callback, place)
        end
        return place
    end
    if callback then
        table.insert(placeWaiters, callback)
    end
    if placePending then
        return nil
    end
    placePending = true
    task.spawn(function()
        local ok, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        local resolved = {
            PlaceId = game.PlaceId,
            Name = "Place " .. tostring(game.PlaceId),
            Icon = "rbxthumb://type=Asset&id=" .. tostring(game.PlaceId) .. "&w=150&h=150",
        }
        if ok and type(info) == "table" then
            if type(info.Name) == "string" and info.Name ~= "" then
                resolved.Name = info.Name
            end
            local iconId = tonumber(info.IconImageAssetId)
            if iconId and iconId > 0 then
                resolved.Icon = "rbxassetid://" .. tostring(iconId)
            end
            if type(info.Description) == "string" then
                resolved.Description = info.Description
            end
            if type(info.Creator) == "table" and type(info.Creator.Name) == "string" then
                resolved.Creator = info.Creator.Name
            end
        end
        place = resolved
        placePending = false
        for _, waiter in ipairs(placeWaiters) do
            task.spawn(waiter, resolved)
        end
        table.clear(placeWaiters)
    end)
    return nil
end

function Slate:PlaceName(callback)
    local info = self:PlaceInfo(callback and function(resolved)
        callback(resolved.Name, resolved)
    end or nil)
    return info and info.Name or nil
end

function Slate:Session()
    local players = game:GetService("Players")
    local player = players.LocalPlayer
    local brand, version = Util.executor()
    local membership = "None"
    if player then
        local ok, value = pcall(function()
            return player.MembershipType.Name
        end)
        if ok and type(value) == "string" then
            membership = value
        end
    end
    return {
        Executor = brand,
        ExecutorVersion = version,
        User = player and player.Name or "unknown",
        DisplayName = player and player.DisplayName or "unknown",
        UserId = player and player.UserId or 0,
        Membership = membership,
        Premium = membership == "Premium",
        PlaceId = game.PlaceId,
        PlaceName = place and place.Name or self:PlaceName(),
        PlaceIcon = place and place.Icon or nil,
        JobId = game.JobId,
        Players = #players:GetPlayers(),
        MaxPlayers = players.MaxPlayers,
    }
end

function Slate:Diagnostics()
    return {
        version = Slate.Version,
        windows = #self.windows,
        theme = Theme.stats(),
        motion = Motion.stats(),
        input = Input.stats(),
        elements = Registry.stats(),
        log = Log.stats(),
        notifications = Notify.count(),
    }
end

function Slate.Cleanup()
    local parent
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok then
            parent = result
        end
    end
    if not parent then
        local ok, core = pcall(function()
            return game:GetService("CoreGui")
        end)
        parent = ok and core or nil
    end
    if not parent then
        return 0
    end
    local removed = 0
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("ScreenGui") and (child.Name == "Slate" or child.Name == "SlateToasts" or child.Name == "SlateLauncher") then
            child:Destroy()
            removed += 1
        end
    end
    return removed
end

function Slate:Destroy()
    if self.Destroyed then
        return
    end
    self.Destroyed = true
    for _, window in ipairs(Util.list(self.windows)) do
        window:Destroy()
    end
    table.clear(self.windows)
    Notify.destroy()
    self.WindowCreated:Destroy()
end

Slate.Unload = Slate.Destroy

return Slate

end
return Slate_require("init")
