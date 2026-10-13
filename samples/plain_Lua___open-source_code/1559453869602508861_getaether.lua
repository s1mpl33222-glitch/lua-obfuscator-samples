if not game:IsLoaded()then game.Loaded:Wait()end;do ("JNKIE Game Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);do local c={PlaceId=game.PlaceId,GameId=game.GameId,Key=getgenv().SCRIPT_KEY or SCRIPT_KEY};local a,r=pcall(function(...)
--[[
    AETHER PRE-CHECK (universal)
    Pipeline: Pre-check -> game check -> Post-check -> key check -> Core -> your script

    Game-agnostic. It does two things:
      1. Tears down the previous run (its session), so re-executing in the same server is safe.
      2. Creates a fresh session that Post-check, Core and your script register into.

    Session API (getgenv().AetherSession), usable from every later chunk:
      Session:Track(x)            -- RBXScriptConnection | thread | Instance | function(cleanup); returns x
      Session:Spawn(fn, ...)      -- task.spawn, but cancelled on the next run
      Session:Delay(t, fn, ...)   -- task.delay, tracked
      Session:Service(name)       -- service proxy whose signal :Connect()s are tracked automatically
      Session:Global(name, value) -- sets getgenv/_G/shared[name], cleared on the next run
      Session:OnCleanup(fn)       -- runs when the next execution (or Session:Destroy) tears down
      Session:Alive()             -- false once this session has been torn down (use in loops)
      Session.task                -- drop-in `task` replacement: `local task = Session.task`
      Session:Destroy()

    Game-specific cleanup belongs in your script (Session:OnCleanup), not here.
--]]

local ctx = ...

local genv = (typeof(getgenv) == "function" and getgenv()) or _G

-- Names of UIs created by Post-check / Core. Anything else should be tracked via Session:Track.
local KNOWN_GUIS = {
    Aether = true,
    AetherKeySystem = true,
    AetherDropdownSelect = true,
    AetherColorpickBar = true,
    AetherNotification = true,
}
local KNOWN_SOUNDS = { AetherClickSound = true, AetherBackgroundMusic = true }

-- =========================================================================
-- RUNTIME (shared constructor; installed once, reused by later chunks)
-- =========================================================================
local Runtime = {}

function Runtime.new()
    local S = {
        Id = tick(),
        _alive = true,
        _conns = {},
        _threads = setmetatable({}, { __mode = "k" }),
        _instances = {},
        _cleanups = {},
        _globals = {},
    }

    function S:Alive()
        return self._alive
    end

    function S:Track(x)
        if not self._alive then
            -- Session already torn down: kill late registrations immediately
            local t = typeof(x)
            if t == "RBXScriptConnection" then pcall(function() x:Disconnect() end)
            elseif t == "thread" then pcall(task.cancel, x)
            elseif t == "Instance" then pcall(function() x:Destroy() end) end
            return x
        end
        local t = typeof(x)
        if t == "RBXScriptConnection" then
            table.insert(self._conns, x)
        elseif t == "thread" then
            self._threads[x] = true
        elseif t == "Instance" then
            table.insert(self._instances, x)
        elseif t == "function" then
            table.insert(self._cleanups, x)
        end
        return x
    end

    function S:OnCleanup(fn)
        return self:Track(fn)
    end

    function S:Spawn(fn, ...)
        return self:Track(task.spawn(fn, ...))
    end

    function S:Defer(fn, ...)
        return self:Track(task.defer(fn, ...))
    end

    function S:Delay(t, fn, ...)
        return self:Track(task.delay(t, fn, ...))
    end

    function S:Global(name, value)
        self._globals[name] = true
        genv[name] = value
        if typeof(_G) == "table" then _G[name] = value end
        if typeof(shared) == "table" then shared[name] = value end
        return value
    end

    -- Signal wrapper: :Connect / :Once are tracked, everything else passes through
    local function wrapSignal(sig)
        return setmetatable({}, {
            __index = function(_, k)
                if k == "Connect" or k == "ConnectParallel" or k == "Once" then
                    return function(_, fn)
                        return S:Track(sig[k](sig, fn))
                    end
                end
                local v = sig[k]
                if type(v) == "function" then
                    return function(_, ...) return v(sig, ...) end
                end
                return v
            end,
        })
    end

    local proxies = {}
    function S:Service(name)
        if proxies[name] then return proxies[name] end
        local svc = game:GetService(name)
        local proxy = setmetatable({}, {
            __index = function(_, k)
                local v = svc[k]
                if typeof(v) == "RBXScriptSignal" then
                    return wrapSignal(v)
                elseif type(v) == "function" then
                    return function(_, ...)
                        local r = table.pack(v(svc, ...))
                        if typeof(r[1]) == "RBXScriptSignal" then r[1] = wrapSignal(r[1]) end
                        return table.unpack(r, 1, r.n)
                    end
                end
                return v
            end,
            __newindex = function(_, k, v) svc[k] = v end,
        })
        proxies[name] = proxy
        return proxy
    end

    -- Drop-in `task` library whose spawned threads die with the session
    S.task = setmetatable({
        spawn = function(fn, ...) return S:Track(task.spawn(fn, ...)) end,
        defer = function(fn, ...) return S:Track(task.defer(fn, ...)) end,
        delay = function(t, fn, ...) return S:Track(task.delay(t, fn, ...)) end,
    }, { __index = task })

    function S:Destroy()
        if not self._alive then return end
        self._alive = false

        -- 1. user cleanups first (they may still need connections/instances)
        for i = #self._cleanups, 1, -1 do
            pcall(self._cleanups[i])
        end
        table.clear(self._cleanups)

        -- 2. connections
        for _, c in ipairs(self._conns) do
            pcall(function() if c.Connected then c:Disconnect() end end)
        end
        table.clear(self._conns)

        -- 3. threads (never cancel the thread doing the cleanup)
        local current = coroutine.running()
        for th in pairs(self._threads) do
            if th ~= current and coroutine.status(th) ~= "dead" then
                pcall(task.cancel, th)
            end
        end
        table.clear(self._threads)

        -- 4. instances
        for _, inst in ipairs(self._instances) do
            pcall(function() inst:Destroy() end)
        end
        table.clear(self._instances)

        -- 5. globals
        for name in pairs(self._globals) do
            genv[name] = nil
            if typeof(_G) == "table" then _G[name] = nil end
            if typeof(shared) == "table" then shared[name] = nil end
        end
        table.clear(self._globals)
    end

    return S
end

genv.AetherRuntime = Runtime

-- =========================================================================
-- 1. TEAR DOWN THE PREVIOUS SESSION
-- =========================================================================
local old = genv.AetherSession
if type(old) == "table" and type(old.Destroy) == "function" then
    pcall(old.Destroy, old)
end
genv.AetherSession = nil

-- Legacy state from older builds of your script.
-- Old builds "unhooked" HttpGet with hookfunction(game.HttpGet, original), which makes
-- HttpGet recurse into itself and freezes/crashes the client. Restore it properly first.
pcall(function()
    if genv._OriginalHttpGet then
        if typeof(restorefunction) == "function" then pcall(restorefunction, game.HttpGet) end
        genv._OriginalHttpGet = nil -- stops the legacy cleanup from re-hooking
    end
    if type(genv._AetherCleanup) == "function" then pcall(genv._AetherCleanup) end
    genv._AetherCleanup = nil
    genv._AetherUnloaded, genv._AetherUnloading, genv._AetherSession = nil, nil, nil
end)
-- Legacy registries from older builds
for _, key in ipairs({ "_AetherConnections", "_AetherThreads" }) do
    local list = genv[key]
    if type(list) == "table" then
        for _, x in pairs(list) do
            pcall(function()
                if typeof(x) == "RBXScriptConnection" then x:Disconnect()
                elseif typeof(x) == "thread" then task.cancel(x) end
            end)
        end
    end
    genv[key] = nil
end

-- =========================================================================
-- 2. REMOVE LEFTOVER LOADER UIs / SOUNDS (generic, name-based)
-- =========================================================================
pcall(function()
    local parents = {}
    local function add(p) if p and not table.find(parents, p) then table.insert(parents, p) end end
    pcall(function() add(game:GetService("CoreGui")) end)
    pcall(function() if typeof(gethui) == "function" then add(gethui()) end end)
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        add(lp and lp:FindFirstChildOfClass("PlayerGui"))
    end)
    for _, parent in ipairs(parents) do
        pcall(function()
            for _, child in ipairs(parent:GetChildren()) do
                if KNOWN_GUIS[child.Name] or child:GetAttribute("AetherUI") == true then
                    pcall(function() child:Destroy() end)
                end
            end
        end)
    end
end)

pcall(function()
    for _, s in ipairs(game:GetService("SoundService"):GetChildren()) do
        if KNOWN_SOUNDS[s.Name] then
            pcall(function() s:Stop(); s:Destroy() end)
        end
    end
end)

-- =========================================================================
-- 3. FORGET ANY KEY FROM A PREVIOUS RUN
--    A stale SCRIPT_KEY makes other Jnkie key UIs report "key invalid".
--    The key UI sets a fresh one right before the loader authenticates,
--    and Core wipes it again once authentication is done.
-- =========================================================================
-- getgenv().SCRIPT_KEY is NOT touched here: Jnkie reads it during its key check, and
-- wiping it here broke authentication ("No key provided"). It is wiped by your script
-- (Original Code) instead, which only ever runs after authentication succeeded.
-- Copies in _G/shared are never read by Jnkie, so remove those leftovers.
if typeof(_G) == "table" then _G.SCRIPT_KEY = nil; _G.KEYLESS = nil end
if typeof(shared) == "table" then shared.SCRIPT_KEY = nil; shared.KEYLESS = nil end
if type(ctx) == "table" and type(ctx.Key) == "string" and ctx.Key ~= "" then
    genv.SCRIPT_KEY = ctx.Key
end

-- =========================================================================
-- 4. FRESH SESSION FOR THIS RUN
-- =========================================================================
genv.AetherSession = Runtime.new()

task.wait() -- let the engine process the destroys before continuing
return true
end,c);if not a then warn(r)elseif r==false then return end end;local S,P,G={"cfeeb8fc58343adf68f049831ebba05ff2190b91582571099f0feedf2528cd26","d9ad4042218d4b3771726868a684a03fde7d59fdfc8e7bcccb2f57285fd202fb"},{[3260590327]=1,[5591597781]=1,[9192423027]=2,[9312740628]=2},{};local i=P[game.PlaceId]or G[game.GameId];if not i then error("Unsupported game [LDR-NOMAP]",0)end;--[[
    ╔═════════════════════════════════════════════════════════════════════╗
    ║                         AETHER KEY SYSTEM                           ║
    ║        Sleek, Modern & High-Performance Authentication UI           ║
    ║               Built for Aether Studios & Jnkie API                  ║
    ╚═════════════════════════════════════════════════════════════════════╝
--]]

local KeySystem = {
    _version = "2.1.0",
    _title = "Aether",
    _subtitle = "Studios",
    _tag = "KEY SYSTEM",
    _service = "Aether Studios",
    _identifier = "1001263",
    _provider = "Free Key",
    _buyLink = "https://discord.gg/getaether",
    _discordLink = "https://discord.gg/getaether",
    _saveKey = true,
    _keyFile = nil, -- defaults to one file per service, see Init
    _keyless = false,
    _callback = nil,
    _isVerifying = false,
}

-- Session (created by Pre-check); everything connected/spawned here dies on the next execution
local genv = (typeof(getgenv) == "function" and getgenv()) or _G
local Session = genv.AetherSession
if type(Session) ~= "table" then
    Session = genv.AetherRuntime and genv.AetherRuntime.new()
    if not Session then
        Session = { task = task }
        function Session:Track(x) return x end
        function Session:Service(n) return game:GetService(n) end
    end
    genv.AetherSession = Session
end
local task = Session.task

-- Services
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local UserInputService = Session:Service("UserInputService")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local RunService = Session:Service("RunService")
local StatsService = game:GetService("Stats")
local LocalPlayer = Players.LocalPlayer

-- Theme definitions (Pure Black & White modern minimalist aesthetic matching Aether)
local Theme = {
    Shadow = Color3.fromRGB(0, 0, 0),
    Background = Color3.fromRGB(12, 12, 14),
    Header = Color3.fromRGB(14, 14, 17),
    Card = Color3.fromRGB(19, 19, 23),
    CardBorder = Color3.fromRGB(36, 36, 44),
    CardHover = Color3.fromRGB(26, 26, 32),
    InputBackground = Color3.fromRGB(15, 15, 18),
    InputBorder = Color3.fromRGB(44, 44, 54),
    Main = Color3.fromRGB(255, 255, 255),
    MainDark = Color3.fromRGB(14, 14, 17),
    MainLight = Color3.fromRGB(230, 230, 235),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(140, 140, 150),
    Placeholder = Color3.fromRGB(100, 100, 115),
    Success = Color3.fromRGB(34, 197, 94),
    Error = Color3.fromRGB(255, 60, 70),
    Warning = Color3.fromRGB(255, 175, 40),
}

-- Helper functions
local function tw(info)
    if type(info) ~= "table" then
        return { Play = function() end, Cancel = function() end, Completed = { Connect = function() end } }
    end

    local target = info.v
    if not target or typeof(target) ~= "Instance" then
        return { Play = function() end, Cancel = function() end, Completed = { Connect = function() end } }
    end

    local t = tonumber(info.t) or 0.2

    local s = Enum.EasingStyle.Quad
    if typeof(info.s) == "EnumItem" then
        s = info.s
    elseif type(info.s) == "string" then
        local styleName = info.s:sub(1, 1):upper() .. info.s:sub(2)
        local ok, res = pcall(function() return Enum.EasingStyle[styleName] end)
        if ok and res then
            s = res
        else
            local ok2, res2 = pcall(function() return Enum.EasingStyle[info.s] end)
            if ok2 and res2 then s = res2 end
        end
    end

    local d = Enum.EasingDirection.Out
    if typeof(info.d) == "EnumItem" then
        d = info.d
    elseif type(info.d) == "string" then
        local dirLower = info.d:lower()
        if dirLower == "in" then
            d = Enum.EasingDirection.In
        elseif dirLower == "out" then
            d = Enum.EasingDirection.Out
        elseif dirLower == "inout" then
            d = Enum.EasingDirection.InOut
        else
            local ok, res = pcall(function() return Enum.EasingDirection[info.d] end)
            if ok and res then d = res end
        end
    end

    local g = (type(info.g) == "table") and info.g or {}

    local success, tween = pcall(function()
        return TweenService:Create(
            target,
            TweenInfo.new(t, s, d, info.repeatCount or 0, info.reverses or false, info.delayTime or 0),
            g
        )
    end)

    if success and tween then
        return tween
    end

    return { Play = function() end, Cancel = function() end, Completed = { Connect = function() end } }
end

-- Responsive scaling: shrinks a window to fit small screens (phones/tablets) via UIScale.
-- baseW/baseH is the design size; the window never grows above 1x.
local function attachAutoScale(frame, baseW, baseH, fill)
    fill = fill or 0.9
    local scale = Instance.new("UIScale")
    scale.Name = "AutoScale"
    scale.Parent = frame
    local cam
    local camConn
    local function update()
        local c = workspace.CurrentCamera
        local vp = c and c.ViewportSize or Vector2.new(1920, 1080)
        if vp.X < 2 or vp.Y < 2 then return end
        scale.Scale = math.clamp(math.min((vp.X * fill) / baseW, (vp.Y * fill) / baseH, 1), 0.35, 1)
    end
    local function bindCamera()
        if camConn then camConn:Disconnect() end
        cam = workspace.CurrentCamera
        if cam then
            camConn = Session:Track(cam:GetPropertyChangedSignal("ViewportSize"):Connect(update))
        end
        update()
    end
    Session:Track(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindCamera))
    frame.Destroying:Connect(function() if camConn then camConn:Disconnect() end end)
    bindCamera()
    return scale
end

local function getGuiParent()
    local success, _ = pcall(function() return CoreGui:GetChildren() end)
    if success then return CoreGui end
    return LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui") or game:GetService("StarterGui")
end

-- Sound system
local ClickSound = Instance.new("Sound")
ClickSound.Name = "AetherClickSound"
ClickSound.Parent = SoundService
ClickSound.Volume = 0.55
ClickSound.SoundId = "rbxassetid://6895079853"

local function playClickSound()
    pcall(function()
        SoundService:PlayLocalSound(ClickSound)
    end)
end

-- Icons helper (with fallback asset IDs)
local IconList = nil
pcall(function()
    IconList = loadstring(game:HttpGet("https://raw.githubusercontent.com/DuxiiT/Aether/refs/heads/main/Icons.lua"))()
end)

local FallbackAssetIcons = {
    ["key"] = "rbxassetid://10709790387",
    ["key-round"] = "rbxassetid://10709790387",
    ["shield-check"] = "rbxassetid://10734952480",
    ["shield"] = "rbxassetid://10734952480",
    ["copy"] = "rbxassetid://10709790387",
    ["check"] = "rbxassetid://10709790202",
    ["external-link"] = "rbxassetid://10709810817",
    ["shopping-cart"] = "rbxassetid://10747373176",
    ["shopping-bag"] = "rbxassetid://10747373176",
    ["sparkles"] = "rbxassetid://10709819266",
    ["lock"] = "rbxassetid://10709790387",
    ["discord"] = "rbxassetid://119690296342461",
    ["user"] = "rbxassetid://10747373176",
    ["clock"] = "rbxassetid://10709789965",
    ["arrow-right"] = "rbxassetid://10709791437",
    ["x"] = "rbxassetid://15082305656",
    ["minus"] = "rbxassetid://10734896206",
}

local function gl(name)
    if type(name) == "string" then
        local key = string.lower(name)
        if key == "discord" then
            return { Image = "rbxassetid://119690296342461", ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) }
        end
        if IconList and IconList.Icons and IconList.Icons[key] then
            local iconData = IconList.Icons[key]
            local spriteSheet = IconList.Spritesheets and IconList.Spritesheets[tostring(iconData.Image)]
            if spriteSheet then
                return { Image = spriteSheet, ImageRectSize = iconData.ImageRectSize, ImageRectPosition = iconData.ImageRectPosition }
            end
        end
        if FallbackAssetIcons[key] then
            return { Image = FallbackAssetIcons[key], ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) }
        end
    end
    if type(name) == "number" or (type(name) == "string" and tonumber(name)) then
        return { Image = "rbxassetid://" .. tostring(name), ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) }
    end
    return { Image = (type(name) == "string" and name ~= "") and name or "rbxassetid://10709790387", ImageRectSize = Vector2.new(0, 0), ImageRectPosition = Vector2.new(0, 0) }
end

-- Draggable implementation
local function makeDraggable(dragHandle, targetFrame)
    local isDragging = false
    local dragInput = nil
    local dragStart = nil
    local startPos = nil

    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStart = input.Position
            startPos = targetFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    isDragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and isDragging then
            local delta = input.Position - dragStart
            tw({
                v = targetFrame,
                t = 0.04,
                s = Enum.EasingStyle.Linear,
                d = "InOut",
                g = { Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) }
            }):Play()
        end
    end)
end

-- Ripple effect
local function createRipple(container, targetFrame)
    pcall(function()
        local mouse = LocalPlayer and LocalPlayer:GetMouse()
        local relativeX = container.AbsoluteSize.X / 2
        local relativeY = container.AbsoluteSize.Y / 2
        if mouse then
            local mx = mouse.X - container.AbsolutePosition.X
            local my = mouse.Y - container.AbsolutePosition.Y
            if mx >= 0 and my >= 0 and mx <= container.AbsoluteSize.X and my <= container.AbsoluteSize.Y then
                relativeX = mx
                relativeY = my
            end
        end

        local ripple = Instance.new("Frame")
        ripple.Parent = targetFrame or container
        ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ripple.BackgroundTransparency = 0.72
        ripple.BorderSizePixel = 0
        ripple.AnchorPoint = Vector2.new(0.5, 0.5)
        ripple.Position = UDim2.new(0, relativeX, 0, relativeY)
        ripple.Size = UDim2.new(0, 0, 0, 0)
        ripple.ZIndex = 25

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = ripple

        local tween = TweenService:Create(
            ripple,
            TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {
                Size = UDim2.new(0, container.AbsoluteSize.X * 1.5, 0, container.AbsoluteSize.X * 1.5),
                BackgroundTransparency = 1
            }
        )
        tween.Completed:Connect(function() ripple:Destroy() end)
        tween:Play()
    end)
end

-- Clipboard utilities
local function setClip(text)
    if setclipboard then
        setclipboard(text)
        return true
    elseif toclipboard then
        toclipboard(text)
        return true
    end
    return false
end

-- Filesystem utilities
local function saveKeyToFile(path, key)
    pcall(function()
        if type(writefile) == "function" then
            local folder = string.match(path, "^(.-)/")
            if folder and type(makefolder) == "function" and type(isfolder) == "function" then
                if not isfolder(folder) then makefolder(folder) end
            end
            writefile(path, key)
        end
    end)
end

local function loadKeyFromFile(path)
    local key = nil
    pcall(function()
        if type(readfile) == "function" and type(isfile) == "function" then
            if isfile(path) then
                key = readfile(path)
            end
        end
    end)
    return key
end

-- Identify executor name
local function getExecutorName()
    local name = nil
    pcall(function()
        if type(identifyexecutor) == "function" then
            name = identifyexecutor()
        elseif type(getexecutorname) == "function" then
            name = getexecutorname()
        end
    end)
    return name or "Universal"
end

-- Jnkie API Handler
local Jnkie = {
    SDK = nil,
    Loaded = false
}

function Jnkie:Init(service, identifier, provider)
    if self.Loaded and self.SDK then return self.SDK end
    local success, sdk = pcall(function()
        return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
    end)
    if success and type(sdk) == "table" then
        sdk.service = service or "Aether Studios"
        sdk.identifier = identifier or "1001263"
        sdk.provider = provider or "Free Key"
        self.SDK = sdk
        self.Loaded = true
        return sdk
    else
        warn("[Aether KeySystem] Failed to load Jnkie SDK from https://jnkie.com/sdk/library.lua")
        return nil
    end
end

function Jnkie:CheckKey(key)
    if not self.SDK then
        self:Init()
    end
    if not self.SDK then
        return false, "Jnkie SDK not initialized"
    end
    local s, result = pcall(function()
        return self.SDK.check_key(key)
    end)
    if s and type(result) == "table" then
        if result.valid then
            if result.message == "KEYLESS" then
                return true, "KEYLESS"
            elseif result.message == "KEY_VALID" then
                return true, "KEY_VALID"
            else
                return true, result.message or "Valid"
            end
        else
            return false, result.error or "Invalid key"
        end
    end
    return false, "Network or verification error"
end

function Jnkie:GetKeyLink()
    if not self.SDK then
        self:Init()
    end
    if not self.SDK then return nil end
    local s, link = pcall(function()
        return self.SDK.get_key_link()
    end)
    if s and type(link) == "string" and link ~= "" then
        return link
    end
    return nil
end

-- Notification Manager
local NotificationContainer = nil

local function showNotification(params)
    params = params or {}
    local title = params.Title or "Aether"
    local desc = params.Desc or ""
    local duration = params.Time or 3.5
    local nType = params.Type or "normal" -- normal, success, warning, error

    if not NotificationContainer or not NotificationContainer.Parent then return end

    local accentColor = Theme.Main
    if nType == "success" then
        accentColor = Theme.Success
    elseif nType == "error" then
        accentColor = Theme.Error
    elseif nType == "warning" then
        accentColor = Theme.Warning
    end

    local notifCard = Instance.new("Frame")
    local cardCorner = Instance.new("UICorner")
    local cardStroke = Instance.new("UIStroke")
    local indicator = Instance.new("Frame")
    local indicatorCorner = Instance.new("UICorner")
    local titleLabel = Instance.new("TextLabel")
    local descLabel = Instance.new("TextLabel")
    local progressBar = Instance.new("Frame")

    notifCard.Name = "NotifCard"
    notifCard.Parent = NotificationContainer
    notifCard.BackgroundColor3 = Theme.Card
    notifCard.BorderSizePixel = 0
    notifCard.Size = UDim2.new(1, 0, 0, (desc ~= "" and 54 or 38))
    notifCard.ClipsDescendants = true
    notifCard.BackgroundTransparency = 1

    cardCorner.CornerRadius = UDim.new(0, 6)
    cardCorner.Parent = notifCard

    cardStroke.Color = Theme.CardBorder
    cardStroke.Thickness = 1.2
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = notifCard

    indicator.Name = "Indicator"
    indicator.Parent = notifCard
    indicator.BackgroundColor3 = accentColor
    indicator.BorderSizePixel = 0
    indicator.Position = UDim2.new(0, 0, 0, 0)
    indicator.Size = UDim2.new(0, 3, 1, 0)

    indicatorCorner.CornerRadius = UDim.new(0, 2)
    indicatorCorner.Parent = indicator

    titleLabel.Name = "Title"
    titleLabel.Parent = notifCard
    titleLabel.BackgroundTransparency = 1
    titleLabel.Position = UDim2.new(0, 12, 0, 8)
    titleLabel.Size = UDim2.new(1, -20, 0, 15)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Text = tostring(title)
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextSize = 12
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    if desc ~= "" then
        descLabel.Name = "Desc"
        descLabel.Parent = notifCard
        descLabel.BackgroundTransparency = 1
        descLabel.Position = UDim2.new(0, 12, 0, 26)
        descLabel.Size = UDim2.new(1, -20, 0, 20)
        descLabel.Font = Enum.Font.Gotham
        descLabel.Text = tostring(desc)
        descLabel.TextColor3 = Theme.SubText
        descLabel.TextSize = 10.5
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.TextWrapped = true
    end

    progressBar.Name = "ProgressBar"
    progressBar.Parent = notifCard
    progressBar.BackgroundColor3 = accentColor
    progressBar.BorderSizePixel = 0
    progressBar.Position = UDim2.new(0, 0, 1, -2)
    progressBar.Size = UDim2.new(1, 0, 0, 2)

    tw({
        v = progressBar,
        t = duration,
        s = Enum.EasingStyle.Linear,
        d = "Out",
        g = { Size = UDim2.new(0, 0, 0, 2) }
    }):Play()

    notifCard.Position = UDim2.new(1, 30, 0, 0)
    tw({
        v = notifCard,
        t = 0.25,
        s = Enum.EasingStyle.Cubic,
        d = "Out",
        g = { BackgroundTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }
    }):Play()

    task.delay(duration, function()
        if notifCard and notifCard.Parent then
            local close = tw({
                v = notifCard,
                t = 0.25,
                s = Enum.EasingStyle.Quad,
                d = "In",
                g = { BackgroundTransparency = 1, Position = UDim2.new(1, 30, 0, 0) }
            })
            close:Play()
            close.Completed:Connect(function()
                if notifCard then notifCard:Destroy() end
            end)
        end
    end)
end

-- =========================================================================
-- MAIN KEY SYSTEM UI BUILDER
-- =========================================================================
function KeySystem:Init(config)
    config = config or {}
    self._title = config.Title or self._title
    self._subtitle = config.SubTitle or self._subtitle
    self._tag = config.Tag or self._tag
    self._service = config.Service or self._service
    self._identifier = config.Identifier or self._identifier
    self._provider = config.Provider or self._provider
    self._buyLink = config.BuyLink or self._buyLink
    self._discordLink = config.DiscordLink or self._discordLink
    self._saveKey = (config.SaveKey ~= nil) and config.SaveKey or self._saveKey
    self._keyFile = config.KeyFile or self._keyFile
        or ("Aether/Key_" .. tostring(self._service):gsub("[^%w]", "") .. ".txt")
    self._keyless = (config.Keyless ~= nil) and config.Keyless or self._keyless
    self._callback = config.Callback or self._callback

    local isKeyVerified = false
    local isCancelled = false
    getgenv().UI_CLOSED = false

    -- =========================================================================
    -- 1. FAST-PATH: EXPLICIT KEYLESS CHECK (Config / Environment Globals)
    -- =========================================================================
    -- Only trust this run's config; globals may be left over from another script
    local isExplicitKeyless = (self._keyless == true) or (config.Keyless == true)

    if isExplicitKeyless then
        getgenv().SCRIPT_KEY = "KEYLESS"
        if self._callback and type(self._callback) == "function" then
            task.spawn(self._callback, "KEYLESS")
        end
        return {
            ScreenGui = nil,
            Success = true,
            Key = "KEYLESS",
            IsKeyless = true
        }
    end

    -- =========================================================================
    -- 2. FAST-PATH: JNKIE SERVICE KEYLESS AUTO-DETECTION
    -- =========================================================================
    -- If the service is configured to be keyless on Jnkie, check_key("KEYLESS")
    -- returns valid = true, message = "KEYLESS". If so, skip the Key UI entirely!
    local isJnkieKeyless = false
    pcall(function()
        Jnkie:Init(self._service, self._identifier, self._provider)
        local validKeyless, msgKeyless = Jnkie:CheckKey("KEYLESS")
        if validKeyless and (msgKeyless == "KEYLESS" or msgKeyless == "KEY_VALID") then
            isJnkieKeyless = true
        end
    end)

    if isJnkieKeyless then
        getgenv().SCRIPT_KEY = "KEYLESS"
        if self._callback and type(self._callback) == "function" then
            task.spawn(self._callback, "KEYLESS")
        end
        return {
            ScreenGui = nil,
            Success = true,
            Key = "KEYLESS",
            IsKeyless = true
        }
    end

    -- =========================================================================
    -- 3. FAST-PATH: PRESET SCRIPT_KEY (e.g. from ctx / external loader)
    -- =========================================================================
    if getgenv().SCRIPT_KEY and type(getgenv().SCRIPT_KEY) == "string" and getgenv().SCRIPT_KEY ~= "" then
        Jnkie:Init(self._service, self._identifier, self._provider)
        local isValid, message = Jnkie:CheckKey(getgenv().SCRIPT_KEY)
        if isValid then
            if self._saveKey and getgenv().SCRIPT_KEY ~= "KEYLESS" then
                saveKeyToFile(self._keyFile, getgenv().SCRIPT_KEY)
            end
            if self._callback and type(self._callback) == "function" then
                task.spawn(self._callback, getgenv().SCRIPT_KEY)
            end
            return {
                ScreenGui = nil,
                Success = true,
                Key = getgenv().SCRIPT_KEY,
                IsKeyless = (message == "KEYLESS" or getgenv().SCRIPT_KEY == "KEYLESS")
            }
        else
            -- Preset key was invalid; reset to nil so Jnkie won't kick immediately
            getgenv().SCRIPT_KEY = nil
        end
    end

    -- =========================================================================
    -- 4. FAST-PATH: SAVED KEY IN LOCAL FILE
    -- =========================================================================
    local savedKey = loadKeyFromFile(self._keyFile)
    if savedKey and type(savedKey) == "string" and savedKey ~= "" then
        Jnkie:Init(self._service, self._identifier, self._provider)
        local isValid, message = Jnkie:CheckKey(savedKey)
        if isValid then
            getgenv().SCRIPT_KEY = savedKey
            if self._callback and type(self._callback) == "function" then
                task.spawn(self._callback, savedKey)
            end
            return {
                ScreenGui = nil,
                Success = true,
                Key = savedKey,
                IsKeyless = (message == "KEYLESS")
            }
        end
    end

    -- Clean up existing Key UI
    local parentGui = getGuiParent()
    pcall(function()
        local parentsToSearch = {parentGui}
        if CoreGui and not table.find(parentsToSearch, CoreGui) then table.insert(parentsToSearch, CoreGui) end
        if typeof(gethui) == "function" then
            local h = gethui()
            if h and not table.find(parentsToSearch, h) then table.insert(parentsToSearch, h) end
        end
        local lp = Players.LocalPlayer
        local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
        if pg and not table.find(parentsToSearch, pg) then table.insert(parentsToSearch, pg) end

        for _, p in ipairs(parentsToSearch) do
            local existing = p:FindFirstChild("AetherKeySystem")
            if existing then
                pcall(function() existing:Destroy() end)
            end
        end
    end)

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "AetherKeySystem"
    Session:Track(ScreenGui)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 1000
    ScreenGui:SetAttribute("AetherUI", true)
    ScreenGui.Parent = parentGui

    -- Notification Area (Top Right)
    NotificationContainer = Instance.new("Frame")
    local notifLayout = Instance.new("UIListLayout")
    local notifPadding = Instance.new("UIPadding")

    NotificationContainer.Name = "Notifications"
    NotificationContainer.Parent = ScreenGui
    NotificationContainer.AnchorPoint = Vector2.new(1, 0)
    NotificationContainer.Position = UDim2.new(1, -20, 0, 20)
    NotificationContainer.Size = UDim2.new(0, 270, 1, -40)
    NotificationContainer.BackgroundTransparency = 1
    NotificationContainer.BorderSizePixel = 0
    NotificationContainer.ZIndex = 200

    notifLayout.Parent = NotificationContainer
    notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
    notifLayout.Padding = UDim.new(0, 8)

    notifPadding.Parent = NotificationContainer
    notifPadding.PaddingRight = UDim.new(0, 4)
    notifPadding.PaddingTop = UDim.new(0, 4)

    -- Window Outer Shadow (Crisp, modern drop shadow)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.Image = "rbxassetid://1316045217"
    Shadow.ImageColor3 = Theme.Shadow
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
    Shadow.ImageTransparency = 0.5
    Shadow.Parent = ScreenGui
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Shadow.Size = UDim2.new(0, 460, 0, 360)
    Shadow.Visible = true
    attachAutoScale(Shadow, 460, 360)

    local shadowPadding = Instance.new("UIPadding")
    shadowPadding.Parent = Shadow
    shadowPadding.PaddingBottom = UDim.new(0, 8)
    shadowPadding.PaddingLeft = UDim.new(0, 8)
    shadowPadding.PaddingRight = UDim.new(0, 8)
    shadowPadding.PaddingTop = UDim.new(0, 8)

    -- Main Container (CanvasGroup for clean clipping & fade animations)
    local MainFrame = Instance.new("CanvasGroup")
    local mainCorner = Instance.new("UICorner")
    local mainStroke = Instance.new("UIStroke")

    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Shadow
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(1, 0, 1, 0)
    MainFrame.ClipsDescendants = true
    MainFrame.GroupTransparency = 1

    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = MainFrame

    mainStroke.Color = Theme.CardBorder
    mainStroke.Thickness = 1.2
    mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    mainStroke.Parent = MainFrame

    -- Drag Header / Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Parent = MainFrame
    Topbar.BackgroundColor3 = Theme.Header
    Topbar.BorderSizePixel = 0
    Topbar.Position = UDim2.new(0, 0, 0, 0)
    Topbar.Size = UDim2.new(1, 0, 0, 46)
    Topbar.ZIndex = 10

    local topbarBorder = Instance.new("Frame")
    topbarBorder.Name = "Border"
    topbarBorder.Parent = Topbar
    topbarBorder.BackgroundColor3 = Theme.CardBorder
    topbarBorder.BorderSizePixel = 0
    topbarBorder.Position = UDim2.new(0, 0, 1, -1)
    topbarBorder.Size = UDim2.new(1, 0, 0, 1)

    makeDraggable(Topbar, Shadow)

    -- Logo & Title Area
    local LogoContainer = Instance.new("Frame")
    local logoLayout = Instance.new("UIListLayout")
    local LogoTitle = Instance.new("TextLabel")
    local LogoSub = Instance.new("TextLabel")
    local TagBadge = Instance.new("Frame")
    local tagCorner = Instance.new("UICorner")
    local tagStroke = Instance.new("UIStroke")
    local TagLabel = Instance.new("TextLabel")

    LogoContainer.Name = "LogoContainer"
    LogoContainer.Parent = Topbar
    LogoContainer.BackgroundTransparency = 1
    LogoContainer.Position = UDim2.new(0, 16, 0, 0)
    LogoContainer.Size = UDim2.new(1, -80, 1, 0)

    logoLayout.Parent = LogoContainer
    logoLayout.FillDirection = Enum.FillDirection.Horizontal
    logoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    logoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    logoLayout.Padding = UDim.new(0, 6)

    LogoTitle.Name = "Title"
    LogoTitle.Parent = LogoContainer
    LogoTitle.BackgroundTransparency = 1
    LogoTitle.Size = UDim2.new(0, 0, 1, 0)
    LogoTitle.AutomaticSize = Enum.AutomaticSize.X
    LogoTitle.Font = Enum.Font.GothamBold
    LogoTitle.Text = tostring(self._title)
    LogoTitle.TextColor3 = Theme.Text
    LogoTitle.TextSize = 16
    LogoTitle.TextXAlignment = Enum.TextXAlignment.Left
    LogoTitle.LayoutOrder = 1

    LogoSub.Name = "SubTitle"
    LogoSub.Parent = LogoContainer
    LogoSub.BackgroundTransparency = 1
    LogoSub.Size = UDim2.new(0, 0, 1, 0)
    LogoSub.AutomaticSize = Enum.AutomaticSize.X
    LogoSub.Font = Enum.Font.GothamBold
    LogoSub.Text = tostring(self._subtitle)
    LogoSub.TextColor3 = Color3.fromRGB(180, 180, 195)
    LogoSub.TextSize = 16
    LogoSub.TextXAlignment = Enum.TextXAlignment.Left
    LogoSub.LayoutOrder = 2

    TagBadge.Name = "TagBadge"
    TagBadge.Parent = LogoContainer
    TagBadge.BackgroundColor3 = Theme.Card
    TagBadge.BorderSizePixel = 0
    TagBadge.Size = UDim2.new(0, 78, 0, 19)
    TagBadge.LayoutOrder = 3

    tagCorner.CornerRadius = UDim.new(0, 4)
    tagCorner.Parent = TagBadge

    tagStroke.Color = Theme.CardBorder
    tagStroke.Thickness = 1
    tagStroke.Parent = TagBadge

    TagLabel.Name = "Label"
    TagLabel.Parent = TagBadge
    TagLabel.BackgroundTransparency = 1
    TagLabel.Size = UDim2.new(1, 0, 1, 0)
    TagLabel.Font = Enum.Font.GothamBold
    TagLabel.Text = tostring(self._tag)
    TagLabel.TextColor3 = Theme.SubText
    TagLabel.TextSize = 8.5
    TagLabel.TextXAlignment = Enum.TextXAlignment.Center

    -- Window Controls (Minimize & Close)
    local WindowControls = Instance.new("Frame")
    local winControlsLayout = Instance.new("UIListLayout")
    local MinButton = Instance.new("ImageButton")
    local CloseButton = Instance.new("ImageButton")

    WindowControls.Name = "Controls"
    WindowControls.Parent = Topbar
    WindowControls.AnchorPoint = Vector2.new(1, 0.5)
    WindowControls.BackgroundTransparency = 1
    WindowControls.Position = UDim2.new(1, -14, 0.5, 0)
    WindowControls.Size = UDim2.new(0, 44, 0, 24)

    winControlsLayout.Parent = WindowControls
    winControlsLayout.FillDirection = Enum.FillDirection.Horizontal
    winControlsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    winControlsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    winControlsLayout.Padding = UDim.new(0, 12)

    MinButton.Name = "Minimize"
    MinButton.Parent = WindowControls
    MinButton.BackgroundTransparency = 1
    MinButton.Size = UDim2.new(0, 14, 0, 14)
    MinButton.Image = "rbxassetid://10734896206"
    MinButton.ImageColor3 = Theme.SubText

    CloseButton.Name = "Close"
    CloseButton.Parent = WindowControls
    CloseButton.BackgroundTransparency = 1
    CloseButton.Size = UDim2.new(0, 14, 0, 14)
    CloseButton.Image = "rbxassetid://15082305656"
    CloseButton.ImageColor3 = Theme.SubText

    MinButton.MouseEnter:Connect(function()
        tw({ v = MinButton, t = 0.15, g = { ImageColor3 = Theme.Text } }):Play()
    end)
    MinButton.MouseLeave:Connect(function()
        tw({ v = MinButton, t = 0.15, g = { ImageColor3 = Theme.SubText } }):Play()
    end)

    CloseButton.MouseEnter:Connect(function()
        tw({ v = CloseButton, t = 0.15, g = { ImageColor3 = Theme.Error } }):Play()
    end)
    CloseButton.MouseLeave:Connect(function()
        tw({ v = CloseButton, t = 0.15, g = { ImageColor3 = Theme.SubText } }):Play()
    end)

    -- Draggable Reopen Pill (HUD when minimized, with live FPS and Ping!)
    local ReopenPill = Instance.new("CanvasGroup")
    local reopenCorner = Instance.new("UICorner")
    local reopenStroke = Instance.new("UIStroke")
    local reopenContent = Instance.new("Frame")
    local reopenLayout = Instance.new("UIListLayout")
    local reopenPadding = Instance.new("UIPadding")

    local statusDot = Instance.new("Frame")
    local statusDotCorner = Instance.new("UICorner")
    local reopenPlayerLabel = Instance.new("TextLabel")
    local reopenDiv1 = Instance.new("Frame")
    local reopenStats = Instance.new("TextLabel")
    local reopenDiv2 = Instance.new("Frame")

    local reopenBadge = Instance.new("Frame")
    local reopenBadgeCorner = Instance.new("UICorner")
    local reopenBadgeStroke = Instance.new("UIStroke")
    local reopenBadgeText = Instance.new("TextLabel")
    local reopenClick = Instance.new("TextButton")

    ReopenPill.Name = "ReopenPill"
    ReopenPill.Parent = ScreenGui
    ReopenPill.AnchorPoint = Vector2.new(0.5, 0)
    ReopenPill.Position = UDim2.new(0.5, 0, 0, 14)
    ReopenPill.Size = UDim2.new(0, 270, 0, 28)
    ReopenPill.BackgroundColor3 = Theme.Card
    ReopenPill.BorderSizePixel = 0
    ReopenPill.GroupTransparency = 1
    ReopenPill.Visible = false
    ReopenPill.ZIndex = 150
    ReopenPill.ClipsDescendants = true

    reopenCorner.CornerRadius = UDim.new(0, 8)
    reopenCorner.Parent = ReopenPill

    reopenStroke.Color = Theme.CardBorder
    reopenStroke.Thickness = 1.2
    reopenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    reopenStroke.Parent = ReopenPill

    reopenContent.Name = "Content"
    reopenContent.Parent = ReopenPill
    reopenContent.BackgroundTransparency = 1
    reopenContent.Size = UDim2.new(1, 0, 1, 0)

    reopenLayout.Parent = reopenContent
    reopenLayout.FillDirection = Enum.FillDirection.Horizontal
    reopenLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    reopenLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    reopenLayout.SortOrder = Enum.SortOrder.LayoutOrder
    reopenLayout.Padding = UDim.new(0, 8)

    reopenPadding.Parent = reopenContent
    reopenPadding.PaddingLeft = UDim.new(0, 10)
    reopenPadding.PaddingRight = UDim.new(0, 10)

    statusDot.Name = "StatusDot"
    statusDot.Parent = reopenContent
    statusDot.BackgroundColor3 = Theme.Success
    statusDot.BorderSizePixel = 0
    statusDot.Size = UDim2.new(0, 6, 0, 6)
    statusDot.LayoutOrder = 1
    statusDotCorner.CornerRadius = UDim.new(1, 0)
    statusDotCorner.Parent = statusDot

    local playerNameStr = (LocalPlayer and (LocalPlayer.DisplayName or LocalPlayer.Name)) or "Player"
    reopenPlayerLabel.Name = "PlayerLabel"
    reopenPlayerLabel.Parent = reopenContent
    reopenPlayerLabel.BackgroundTransparency = 1
    reopenPlayerLabel.Size = UDim2.new(0, 54, 0, 16)
    reopenPlayerLabel.Font = Enum.Font.GothamBold
    reopenPlayerLabel.Text = playerNameStr
    reopenPlayerLabel.TextColor3 = Theme.Text
    reopenPlayerLabel.TextSize = 10.5
    reopenPlayerLabel.TextXAlignment = Enum.TextXAlignment.Left
    reopenPlayerLabel.TextTruncate = Enum.TextTruncate.AtEnd
    reopenPlayerLabel.LayoutOrder = 2

    reopenDiv1.Name = "Div1"
    reopenDiv1.Parent = reopenContent
    reopenDiv1.BackgroundColor3 = Theme.CardBorder
    reopenDiv1.BorderSizePixel = 0
    reopenDiv1.Size = UDim2.new(0, 1, 0, 12)
    reopenDiv1.LayoutOrder = 3

    reopenStats.Name = "Stats"
    reopenStats.Parent = reopenContent
    reopenStats.BackgroundTransparency = 1
    reopenStats.Size = UDim2.new(0, 92, 0, 16)
    reopenStats.Font = Enum.Font.GothamMedium
    reopenStats.RichText = true
    reopenStats.Text = '<font color="rgb(34,197,94)"><b>60</b></font> <font color="rgb(150,150,165)">FPS</font> <font color="rgb(70,70,85)">•</font> <font color="rgb(255,255,255)"><b>0</b></font><font color="rgb(150,150,165)">ms</font>'
    reopenStats.TextSize = 10
    reopenStats.TextXAlignment = Enum.TextXAlignment.Center
    reopenStats.LayoutOrder = 4

    reopenDiv2.Name = "Div2"
    reopenDiv2.Parent = reopenContent
    reopenDiv2.BackgroundColor3 = Theme.CardBorder
    reopenDiv2.BorderSizePixel = 0
    reopenDiv2.Size = UDim2.new(0, 1, 0, 12)
    reopenDiv2.LayoutOrder = 5

    reopenBadge.Name = "KeyBadge"
    reopenBadge.Parent = reopenContent
    reopenBadge.BackgroundColor3 = Theme.InputBackground
    reopenBadge.BorderSizePixel = 0
    reopenBadge.Size = UDim2.new(0, 44, 0, 18)
    reopenBadge.LayoutOrder = 6

    reopenBadgeCorner.CornerRadius = UDim.new(0, 4)
    reopenBadgeCorner.Parent = reopenBadge

    reopenBadgeStroke.Color = Theme.CardBorder
    reopenBadgeStroke.Thickness = 1
    reopenBadgeStroke.Parent = reopenBadge

    reopenBadgeText.Name = "Text"
    reopenBadgeText.Parent = reopenBadge
    reopenBadgeText.BackgroundTransparency = 1
    reopenBadgeText.Size = UDim2.new(1, 0, 1, 0)
    reopenBadgeText.Font = Enum.Font.GothamBold
    reopenBadgeText.Text = "[Key]"
    reopenBadgeText.TextColor3 = Theme.Main
    reopenBadgeText.TextSize = 9.5
    reopenBadgeText.TextXAlignment = Enum.TextXAlignment.Center

    reopenClick.Name = "Click"
    reopenClick.Parent = ReopenPill
    reopenClick.BackgroundTransparency = 1
    reopenClick.Size = UDim2.new(1, 0, 1, 0)
    reopenClick.Text = ""
    reopenClick.ZIndex = 25

    -- Live Stats updater for reopen HUD
    local fpsVal, fpsFrames, fpsLastTime = 60, 0, tick()
    local pingVal = 0

    local statsConn
    statsConn = RunService.RenderStepped:Connect(function()
        fpsFrames = fpsFrames + 1
        local now = tick()
        if now - fpsLastTime >= 0.5 then
            fpsVal = math.round(fpsFrames / (now - fpsLastTime))
            fpsFrames = 0
            fpsLastTime = now
        end
    end)
    ScreenGui.Destroying:Connect(function()
        pcall(function()
            if statsConn and statsConn.Connected then
                statsConn:Disconnect()
            end
        end)
    end)

    task.spawn(function()
        while ScreenGui and ScreenGui.Parent do
            pcall(function()
                local netItem = StatsService and StatsService.Network and StatsService.Network.ServerStatsItem and StatsService.Network.ServerStatsItem["Data Ping"]
                if netItem then pingVal = math.round(netItem:GetValue()) end
            end)
            if reopenStats and reopenStats.Parent then
                local fpsColor = (fpsVal >= 50 and "rgb(34,197,94)") or (fpsVal >= 30 and "rgb(234,179,8)") or "rgb(239,68,68)"
                reopenStats.Text = string.format(
                    '<font color="%s"><b>%d</b></font> <font color="rgb(150,150,165)">FPS</font> <font color="rgb(70,70,85)">•</font> <font color="rgb(255,255,255)"><b>%d</b></font><font color="rgb(150,150,165)">ms</font>',
                    fpsColor, fpsVal, pingVal
                )
            end
            task.wait(0.5)
        end
    end)

    -- Reopen drag and toggle logic
    local function setWindowMinimized(minimized)
        if minimized then
            tw({ v = MainFrame, t = 0.16, g = { GroupTransparency = 1 } }):Play()
            task.delay(0.16, function() Shadow.Visible = false end)
            ReopenPill.Visible = true
            tw({ v = ReopenPill, t = 0.22, s = Enum.EasingStyle.Back, d = "Out", g = { GroupTransparency = 0 } }):Play()
        else
            tw({ v = ReopenPill, t = 0.14, g = { GroupTransparency = 1 } }):Play()
            task.delay(0.14, function() ReopenPill.Visible = false end)
            Shadow.Visible = true
            tw({ v = MainFrame, t = 0.18, g = { GroupTransparency = 0 } }):Play()
        end
    end

    do
        local isPillDragging = false
        local pDragStart, pStartPos = nil, nil
        local hasPillMoved = false

        reopenClick.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isPillDragging = true
                hasPillMoved = false
                pDragStart = input.Position
                pStartPos = ReopenPill.Position
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if isPillDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - pDragStart
                if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then hasPillMoved = true end
                ReopenPill.Position = UDim2.new(pStartPos.X.Scale, pStartPos.X.Offset + delta.X, pStartPos.Y.Scale, pStartPos.Y.Offset + delta.Y)
            end
        end)

        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                isPillDragging = false
            end
        end)

        local function onReopenClick()
            if not hasPillMoved then
                playClickSound()
                setWindowMinimized(false)
            end
        end

        reopenClick.MouseButton1Click:Connect(onReopenClick)
        reopenClick.Activated:Connect(onReopenClick)
    end

    local function onMinimizeClicked()
        playClickSound()
        setWindowMinimized(true)
    end
    MinButton.MouseButton1Click:Connect(onMinimizeClicked)
    MinButton.Activated:Connect(onMinimizeClicked)

    local function onCloseClicked()
        playClickSound()
        local closeTween = tw({ v = MainFrame, t = 0.18, g = { GroupTransparency = 1 } })
        closeTween:Play()
        closeTween.Completed:Connect(function()
            isCancelled = true
            getgenv().UI_CLOSED = true
            pcall(function() ScreenGui:Destroy() end)
        end)
    end
    CloseButton.MouseButton1Click:Connect(onCloseClicked)
    CloseButton.Activated:Connect(onCloseClicked)

    -- Window Body (Compact, perfectly proportioned container)
    local Body = Instance.new("Frame")
    local bodyLayout = Instance.new("UIListLayout")
    local bodyPadding = Instance.new("UIPadding")

    Body.Name = "Body"
    Body.Parent = MainFrame
    Body.BackgroundTransparency = 1
    Body.BorderSizePixel = 0
    Body.Position = UDim2.new(0, 0, 0, 46)
    Body.Size = UDim2.new(1, 0, 1, -46)

    bodyLayout.Parent = Body
    bodyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    bodyLayout.Padding = UDim.new(0, 12)

    bodyPadding.Parent = Body
    bodyPadding.PaddingLeft = UDim.new(0, 16)
    bodyPadding.PaddingRight = UDim.new(0, 16)
    bodyPadding.PaddingTop = UDim.new(0, 14)
    bodyPadding.PaddingBottom = UDim.new(0, 14)

    -- =====================================================================
    -- 1. USER INFORMATION CARD (Avatar, DisplayName, @Username, Executor)
    -- =====================================================================
    local ProfileCard = Instance.new("Frame")
    local profCorner = Instance.new("UICorner")
    local profStroke = Instance.new("UIStroke")
    local profAvatarCircle = Instance.new("Frame")
    local profAvatarCorner = Instance.new("UICorner")
    local profAvatarStroke = Instance.new("UIStroke")
    local profAvatarImg = Instance.new("ImageLabel")
    local profAvatarImgCorner = Instance.new("UICorner")
    local profOnlineDot = Instance.new("Frame")
    local profOnlineDotCorner = Instance.new("UICorner")

    local profInfo = Instance.new("Frame")
    local profInfoLayout = Instance.new("UIListLayout")
    local profDisplayName = Instance.new("TextLabel")
    local profUsername = Instance.new("TextLabel")

    local execBadge = Instance.new("Frame")
    local execCorner = Instance.new("UICorner")
    local execStroke = Instance.new("UIStroke")
    local execLayout = Instance.new("UIListLayout")
    local execPadding = Instance.new("UIPadding")
    local execIcon = Instance.new("ImageLabel")
    local execLabel = Instance.new("TextLabel")

    ProfileCard.Name = "ProfileCard"
    ProfileCard.Parent = Body
    ProfileCard.BackgroundColor3 = Theme.Card
    ProfileCard.BorderSizePixel = 0
    ProfileCard.Size = UDim2.new(1, 0, 0, 60)
    ProfileCard.LayoutOrder = 1

    profCorner.CornerRadius = UDim.new(0, 8)
    profCorner.Parent = ProfileCard

    profStroke.Color = Theme.CardBorder
    profStroke.Thickness = 1
    profStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    profStroke.Parent = ProfileCard

    -- Avatar Circle with subtle stroke & online dot
    profAvatarCircle.Name = "AvatarCircle"
    profAvatarCircle.Parent = ProfileCard
    profAvatarCircle.BackgroundColor3 = Theme.InputBackground
    profAvatarCircle.BorderSizePixel = 0
    profAvatarCircle.Position = UDim2.new(0, 12, 0.5, -20)
    profAvatarCircle.Size = UDim2.new(0, 40, 0, 40)

    profAvatarCorner.CornerRadius = UDim.new(1, 0)
    profAvatarCorner.Parent = profAvatarCircle

    profAvatarStroke.Color = Theme.CardBorder
    profAvatarStroke.Thickness = 1.2
    profAvatarStroke.Parent = profAvatarCircle

    profAvatarImg.Name = "Avatar"
    profAvatarImg.Parent = profAvatarCircle
    profAvatarImg.BackgroundTransparency = 1
    profAvatarImg.Size = UDim2.new(1, 0, 1, 0)
    local userId = LocalPlayer and LocalPlayer.UserId or 1
    profAvatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(userId) .. "&w=150&h=150"

    profAvatarImgCorner.CornerRadius = UDim.new(1, 0)
    profAvatarImgCorner.Parent = profAvatarImg

    profOnlineDot.Name = "OnlineDot"
    profOnlineDot.Parent = profAvatarCircle
    profOnlineDot.AnchorPoint = Vector2.new(1, 1)
    profOnlineDot.BackgroundColor3 = Theme.Success
    profOnlineDot.BorderSizePixel = 0
    profOnlineDot.Position = UDim2.new(1, 1, 1, 1)
    profOnlineDot.Size = UDim2.new(0, 10, 0, 10)
    profOnlineDot.ZIndex = 5

    profOnlineDotCorner.CornerRadius = UDim.new(1, 0)
    profOnlineDotCorner.Parent = profOnlineDot

    -- Player Details: DisplayName & @Username
    profInfo.Name = "Info"
    profInfo.Parent = ProfileCard
    profInfo.BackgroundTransparency = 1
    profInfo.Position = UDim2.new(0, 60, 0.5, -18)
    profInfo.Size = UDim2.new(1, -190, 0, 36)

    profInfoLayout.Parent = profInfo
    profInfoLayout.SortOrder = Enum.SortOrder.LayoutOrder
    profInfoLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    profInfoLayout.Padding = UDim.new(0, 2)

    profDisplayName.Name = "DisplayName"
    profDisplayName.Parent = profInfo
    profDisplayName.BackgroundTransparency = 1
    profDisplayName.Size = UDim2.new(1, 0, 0, 16)
    profDisplayName.Font = Enum.Font.GothamBold
    profDisplayName.Text = (LocalPlayer and LocalPlayer.DisplayName) or "Player"
    profDisplayName.TextColor3 = Theme.Text
    profDisplayName.TextSize = 13.5
    profDisplayName.TextXAlignment = Enum.TextXAlignment.Left
    profDisplayName.TextTruncate = Enum.TextTruncate.AtEnd
    profDisplayName.LayoutOrder = 1

    profUsername.Name = "Username"
    profUsername.Parent = profInfo
    profUsername.BackgroundTransparency = 1
    profUsername.Size = UDim2.new(1, 0, 0, 14)
    profUsername.Font = Enum.Font.Gotham
    profUsername.Text = "@" .. ((LocalPlayer and LocalPlayer.Name) or "Player")
    profUsername.TextColor3 = Theme.SubText
    profUsername.TextSize = 10.5
    profUsername.TextXAlignment = Enum.TextXAlignment.Left
    profUsername.TextTruncate = Enum.TextTruncate.AtEnd
    profUsername.LayoutOrder = 2

    -- Executor Badge (Right side of profile card)
    execBadge.Name = "ExecutorBadge"
    execBadge.Parent = ProfileCard
    execBadge.AnchorPoint = Vector2.new(1, 0.5)
    execBadge.Position = UDim2.new(1, -12, 0.5, 0)
    execBadge.BackgroundColor3 = Theme.InputBackground
    execBadge.BorderSizePixel = 0
    execBadge.Size = UDim2.new(0, 0, 0, 24)
    execBadge.AutomaticSize = Enum.AutomaticSize.X

    execCorner.CornerRadius = UDim.new(0, 5)
    execCorner.Parent = execBadge

    execStroke.Color = Theme.CardBorder
    execStroke.Thickness = 1
    execStroke.Parent = execBadge

    execLayout.Parent = execBadge
    execLayout.FillDirection = Enum.FillDirection.Horizontal
    execLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    execLayout.SortOrder = Enum.SortOrder.LayoutOrder
    execLayout.Padding = UDim.new(0, 5)

    execPadding.Parent = execBadge
    execPadding.PaddingLeft = UDim.new(0, 8)
    execPadding.PaddingRight = UDim.new(0, 8)

    execIcon.Name = "Icon"
    execIcon.Parent = execBadge
    execIcon.BackgroundTransparency = 1
    execIcon.Size = UDim2.new(0, 12, 0, 12)
    local shieldData = gl("shield")
    execIcon.Image = shieldData.Image
    execIcon.ImageRectSize = shieldData.ImageRectSize
    execIcon.ImageRectOffset = shieldData.ImageRectPosition
    execIcon.ImageColor3 = Theme.SubText
    execIcon.LayoutOrder = 1

    execLabel.Name = "Label"
    execLabel.Parent = execBadge
    execLabel.BackgroundTransparency = 1
    execLabel.Size = UDim2.new(0, 0, 1, 0)
    execLabel.AutomaticSize = Enum.AutomaticSize.X
    execLabel.Font = Enum.Font.GothamMedium
    execLabel.Text = getExecutorName()
    execLabel.TextColor3 = Theme.Text
    execLabel.TextSize = 10.5
    execLabel.TextXAlignment = Enum.TextXAlignment.Center
    execLabel.LayoutOrder = 2

    -- Hover effect on profile card
    ProfileCard.MouseEnter:Connect(function()
        tw({ v = ProfileCard, t = 0.15, g = { BackgroundColor3 = Theme.CardHover } }):Play()
        tw({ v = profStroke, t = 0.15, g = { Color = Theme.CardBorder:Lerp(Theme.Main, 0.25) } }):Play()
    end)
    ProfileCard.MouseLeave:Connect(function()
        tw({ v = ProfileCard, t = 0.2, g = { BackgroundColor3 = Theme.Card } }):Play()
        tw({ v = profStroke, t = 0.2, g = { Color = Theme.CardBorder } }):Play()
    end)

    -- =====================================================================
    -- 2. KEY INPUT CARD (Clean, no paste button)
    -- =====================================================================
    local InputCard = Instance.new("Frame")
    local inputCorner = Instance.new("UICorner")
    local inputStroke = Instance.new("UIStroke")
    local inputCardLayout = Instance.new("UIListLayout")
    local inputCardPadding = Instance.new("UIPadding")

    local inputHeader = Instance.new("Frame")
    local inputHeaderLayout = Instance.new("UIListLayout")
    local inputHeaderTitle = Instance.new("TextLabel")
    local inputHeaderSub = Instance.new("TextLabel")

    InputCard.Name = "InputCard"
    InputCard.Parent = Body
    InputCard.BackgroundColor3 = Theme.Card
    InputCard.BorderSizePixel = 0
    InputCard.Size = UDim2.new(1, 0, 0, 102)
    InputCard.LayoutOrder = 2

    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = InputCard

    inputStroke.Color = Theme.CardBorder
    inputStroke.Thickness = 1
    inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    inputStroke.Parent = InputCard

    inputCardLayout.Parent = InputCard
    inputCardLayout.SortOrder = Enum.SortOrder.LayoutOrder
    inputCardLayout.Padding = UDim.new(0, 8)

    inputCardPadding.Parent = InputCard
    inputCardPadding.PaddingLeft = UDim.new(0, 14)
    inputCardPadding.PaddingRight = UDim.new(0, 14)
    inputCardPadding.PaddingTop = UDim.new(0, 11)
    inputCardPadding.PaddingBottom = UDim.new(0, 11)

    -- Header inside input card
    inputHeader.Name = "Header"
    inputHeader.Parent = InputCard
    inputHeader.BackgroundTransparency = 1
    inputHeader.Size = UDim2.new(1, 0, 0, 28)
    inputHeader.LayoutOrder = 1

    inputHeaderLayout.Parent = inputHeader
    inputHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    inputHeaderLayout.Padding = UDim.new(0, 2)

    inputHeaderTitle.Name = "Title"
    inputHeaderTitle.Parent = inputHeader
    inputHeaderTitle.BackgroundTransparency = 1
    inputHeaderTitle.Size = UDim2.new(1, 0, 0, 15)
    inputHeaderTitle.Font = Enum.Font.GothamBold
    inputHeaderTitle.Text = "Authentication Key"
    inputHeaderTitle.TextColor3 = Theme.Text
    inputHeaderTitle.TextSize = 12
    inputHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    inputHeaderTitle.LayoutOrder = 1

    inputHeaderSub.Name = "Desc"
    inputHeaderSub.Parent = inputHeader
    inputHeaderSub.BackgroundTransparency = 1
    inputHeaderSub.Size = UDim2.new(1, 0, 0, 13)
    inputHeaderSub.Font = Enum.Font.Gotham
    inputHeaderSub.Text = "Enter your key below to authenticate and continue"
    inputHeaderSub.TextColor3 = Theme.SubText
    inputHeaderSub.TextSize = 10
    inputHeaderSub.TextXAlignment = Enum.TextXAlignment.Left
    inputHeaderSub.LayoutOrder = 2

    -- Input Box Container (Clean, full width text field)
    local TextBoxFrame = Instance.new("Frame")
    local tbCorner = Instance.new("UICorner")
    local tbStroke = Instance.new("UIStroke")
    local keyIcon = Instance.new("ImageLabel")
    local KeyTextBox = Instance.new("TextBox")
    local ClearBtn = Instance.new("ImageButton")

    TextBoxFrame.Name = "TextBoxFrame"
    TextBoxFrame.Parent = InputCard
    TextBoxFrame.BackgroundColor3 = Theme.InputBackground
    TextBoxFrame.BorderSizePixel = 0
    TextBoxFrame.Size = UDim2.new(1, 0, 0, 38)
    TextBoxFrame.LayoutOrder = 2

    tbCorner.CornerRadius = UDim.new(0, 6)
    tbCorner.Parent = TextBoxFrame

    tbStroke.Color = Theme.InputBorder
    tbStroke.Thickness = 1
    tbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    tbStroke.Parent = TextBoxFrame

    keyIcon.Name = "KeyIcon"
    keyIcon.Parent = TextBoxFrame
    keyIcon.AnchorPoint = Vector2.new(0, 0.5)
    keyIcon.BackgroundTransparency = 1
    keyIcon.Position = UDim2.new(0, 10, 0.5, 0)
    keyIcon.Size = UDim2.new(0, 16, 0, 16)
    local kIconData = gl("key")
    keyIcon.Image = kIconData.Image
    keyIcon.ImageRectSize = kIconData.ImageRectSize
    keyIcon.ImageRectOffset = kIconData.ImageRectPosition
    keyIcon.ImageColor3 = Theme.SubText

    ClearBtn.Name = "Clear"
    ClearBtn.Parent = TextBoxFrame
    ClearBtn.AnchorPoint = Vector2.new(1, 0.5)
    ClearBtn.Position = UDim2.new(1, -10, 0.5, 0)
    ClearBtn.BackgroundTransparency = 1
    ClearBtn.Size = UDim2.new(0, 15, 0, 15)
    ClearBtn.Image = "rbxassetid://15082305656"
    ClearBtn.ImageColor3 = Theme.SubText
    ClearBtn.Visible = false
    ClearBtn.ZIndex = 15

    KeyTextBox.Name = "KeyInput"
    KeyTextBox.Parent = TextBoxFrame
    KeyTextBox.BackgroundTransparency = 1
    KeyTextBox.Position = UDim2.new(0, 34, 0, 0)
    KeyTextBox.Size = UDim2.new(1, -68, 1, 0)
    KeyTextBox.Font = Enum.Font.Gotham
    KeyTextBox.Text = ""
    KeyTextBox.PlaceholderText = "Enter your key..."
    KeyTextBox.PlaceholderColor3 = Theme.Placeholder
    KeyTextBox.TextColor3 = Theme.Text
    KeyTextBox.TextSize = 12
    KeyTextBox.TextXAlignment = Enum.TextXAlignment.Left
    KeyTextBox.ClearTextOnFocus = false

    -- Auto-show clear button when text exists
    KeyTextBox:GetPropertyChangedSignal("Text"):Connect(function()
        ClearBtn.Visible = (KeyTextBox.Text ~= "")
    end)

    local function onClearClicked()
        playClickSound()
        KeyTextBox.Text = ""
    end
    ClearBtn.MouseButton1Click:Connect(onClearClicked)
    ClearBtn.Activated:Connect(onClearClicked)

    ClearBtn.MouseEnter:Connect(function()
        tw({ v = ClearBtn, t = 0.15, g = { ImageColor3 = Theme.Text } }):Play()
    end)
    ClearBtn.MouseLeave:Connect(function()
        tw({ v = ClearBtn, t = 0.15, g = { ImageColor3 = Theme.SubText } }):Play()
    end)

    -- Focus animations
    KeyTextBox.Focused:Connect(function()
        tw({ v = tbStroke, t = 0.15, g = { Color = Theme.Main } }):Play()
        tw({ v = keyIcon, t = 0.15, g = { ImageColor3 = Theme.Main } }):Play()
    end)
    KeyTextBox.FocusLost:Connect(function()
        tw({ v = tbStroke, t = 0.15, g = { Color = Theme.InputBorder } }):Play()
        tw({ v = keyIcon, t = 0.15, g = { ImageColor3 = Theme.SubText } }):Play()
    end)

    -- Check if saved key exists and pre-fill seamlessly
    local savedKey = loadKeyFromFile(self._keyFile)
    if savedKey and savedKey ~= "" then
        KeyTextBox.Text = savedKey
    end

    -- =====================================================================
    -- 3. PRIMARY BUTTON: VERIFY KEY
    -- =====================================================================
    local VerifyButton = Instance.new("Frame")
    local verifyCorner = Instance.new("UICorner")
    local verifyStroke = Instance.new("UIStroke")
    local verifyContent = Instance.new("Frame")
    local verifyLayout = Instance.new("UIListLayout")
    local verifyIcon = Instance.new("ImageLabel")
    local verifyLabel = Instance.new("TextLabel")
    local verifyClick = Instance.new("TextButton")

    VerifyButton.Name = "VerifyButton"
    VerifyButton.Parent = Body
    VerifyButton.BackgroundColor3 = Theme.Main
    VerifyButton.BorderSizePixel = 0
    VerifyButton.Size = UDim2.new(1, 0, 0, 42)
    VerifyButton.LayoutOrder = 3
    VerifyButton.ClipsDescendants = true

    verifyCorner.CornerRadius = UDim.new(0, 8)
    verifyCorner.Parent = VerifyButton

    verifyStroke.Color = Color3.fromRGB(255, 255, 255)
    verifyStroke.Thickness = 1
    verifyStroke.Parent = VerifyButton

    verifyContent.Name = "Content"
    verifyContent.Parent = VerifyButton
    verifyContent.BackgroundTransparency = 1
    verifyContent.Size = UDim2.new(1, 0, 1, 0)

    verifyLayout.Parent = verifyContent
    verifyLayout.FillDirection = Enum.FillDirection.Horizontal
    verifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    verifyLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    verifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    verifyLayout.Padding = UDim.new(0, 8)

    verifyIcon.Name = "Icon"
    verifyIcon.Parent = verifyContent
    verifyIcon.BackgroundTransparency = 1
    verifyIcon.Size = UDim2.new(0, 16, 0, 16)
    local sIcon = gl("shield-check")
    verifyIcon.Image = sIcon.Image
    verifyIcon.ImageRectSize = sIcon.ImageRectSize
    verifyIcon.ImageRectOffset = sIcon.ImageRectPosition
    verifyIcon.ImageColor3 = Theme.MainDark

    verifyLabel.Name = "Label"
    verifyLabel.Parent = verifyContent
    verifyLabel.BackgroundTransparency = 1
    verifyLabel.Size = UDim2.new(0, 0, 1, 0)
    verifyLabel.AutomaticSize = Enum.AutomaticSize.X
    verifyLabel.Font = Enum.Font.GothamBold
    verifyLabel.Text = "Verify Key"
    verifyLabel.TextColor3 = Theme.MainDark
    verifyLabel.TextSize = 13
    verifyLabel.TextXAlignment = Enum.TextXAlignment.Center

    verifyClick.Name = "Click"
    verifyClick.Parent = VerifyButton
    verifyClick.BackgroundTransparency = 1
    verifyClick.Size = UDim2.new(1, 0, 1, 0)
    verifyClick.Text = ""
    verifyClick.ZIndex = 20

    -- Verify hover effects
    verifyClick.MouseEnter:Connect(function()
        if not self._isVerifying then
            tw({ v = VerifyButton, t = 0.15, g = { BackgroundColor3 = Theme.MainLight } }):Play()
        end
    end)
    verifyClick.MouseLeave:Connect(function()
        if not self._isVerifying then
            tw({ v = VerifyButton, t = 0.2, g = { BackgroundColor3 = Theme.Main } }):Play()
        end
    end)

    -- Shake animation helper for invalid input
    local function shakeCard(target)
        task.spawn(function()
            local originalPos = target.Position
            for i = 1, 4 do
                tw({ v = target, t = 0.04, g = { Position = originalPos + UDim2.new(0, (i % 2 == 0 and 6 or -6), 0, 0) } }):Play()
                task.wait(0.04)
            end
            tw({ v = target, t = 0.05, g = { Position = originalPos } }):Play()
        end)
    end

    -- =====================================================================
    -- 4. SECONDARY BUTTONS (GET KEY, BUY KEY, DISCORD)
    -- =====================================================================
    local SecondaryRow = Instance.new("Frame")
    local secLayout = Instance.new("UIListLayout")

    SecondaryRow.Name = "SecondaryRow"
    SecondaryRow.Parent = Body
    SecondaryRow.BackgroundTransparency = 1
    SecondaryRow.Size = UDim2.new(1, 0, 0, 38)
    SecondaryRow.LayoutOrder = 4

    secLayout.Parent = SecondaryRow
    secLayout.FillDirection = Enum.FillDirection.Horizontal
    secLayout.SortOrder = Enum.SortOrder.LayoutOrder
    secLayout.Padding = UDim.new(0, 8)

    local function createSecondaryButton(title, iconName, layoutOrder, onClick)
        local btnFrame = Instance.new("Frame")
        local btnCorner = Instance.new("UICorner")
        local btnStroke = Instance.new("UIStroke")
        local content = Instance.new("Frame")
        local cLayout = Instance.new("UIListLayout")
        local icon = Instance.new("ImageLabel")
        local label = Instance.new("TextLabel")
        local clickBtn = Instance.new("TextButton")

        btnFrame.Name = "Btn_" .. title
        btnFrame.Parent = SecondaryRow
        btnFrame.BackgroundColor3 = Theme.Card
        btnFrame.BorderSizePixel = 0
        btnFrame.Size = UDim2.new(0.333, -5, 1, 0)
        btnFrame.LayoutOrder = layoutOrder
        btnFrame.ClipsDescendants = true

        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btnFrame

        btnStroke.Color = Theme.CardBorder
        btnStroke.Thickness = 1
        btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        btnStroke.Parent = btnFrame

        content.Name = "Content"
        content.Parent = btnFrame
        content.BackgroundTransparency = 1
        content.Size = UDim2.new(1, 0, 1, 0)

        cLayout.Parent = content
        cLayout.FillDirection = Enum.FillDirection.Horizontal
        cLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        cLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        cLayout.SortOrder = Enum.SortOrder.LayoutOrder
        cLayout.Padding = UDim.new(0, 6)

        icon.Name = "Icon"
        icon.Parent = content
        icon.BackgroundTransparency = 1
        icon.Size = UDim2.new(0, 14, 0, 14)
        local icData = gl(iconName)
        icon.Image = icData.Image
        icon.ImageRectSize = icData.ImageRectSize
        icon.ImageRectOffset = icData.ImageRectPosition
        icon.ImageColor3 = Theme.Text

        label.Name = "Label"
        label.Parent = content
        label.BackgroundTransparency = 1
        label.Size = UDim2.new(0, 0, 1, 0)
        label.AutomaticSize = Enum.AutomaticSize.X
        label.Font = Enum.Font.GothamMedium
        label.Text = tostring(title)
        label.TextColor3 = Theme.Text
        label.TextSize = 11
        label.TextXAlignment = Enum.TextXAlignment.Center

        clickBtn.Name = "Click"
        clickBtn.Parent = btnFrame
        clickBtn.BackgroundTransparency = 1
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.Text = ""
        clickBtn.ZIndex = 15

        clickBtn.MouseEnter:Connect(function()
            tw({ v = btnFrame, t = 0.15, g = { BackgroundColor3 = Theme.CardHover } }):Play()
            tw({ v = btnStroke, t = 0.15, g = { Color = Theme.CardBorder:Lerp(Theme.Main, 0.4) } }):Play()
        end)
        clickBtn.MouseLeave:Connect(function()
            tw({ v = btnFrame, t = 0.2, g = { BackgroundColor3 = Theme.Card } }):Play()
            tw({ v = btnStroke, t = 0.2, g = { Color = Theme.CardBorder } }):Play()
        end)

        local lastClickTime = 0
        local function onBtnClicked()
            local now = tick()
            if now - lastClickTime < 0.25 then return end
            lastClickTime = now
            playClickSound()
            createRipple(btnFrame)
            if onClick then onClick() end
        end

        clickBtn.MouseButton1Click:Connect(onBtnClicked)
        clickBtn.Activated:Connect(onBtnClicked)

        return btnFrame
    end

    -- 1. "Get Key" Button
    createSecondaryButton("Get Key", "key-round", 1, function()
        showNotification({
            Title = "Retrieving Link...",
            Desc = "Connecting to Jnkie service...",
            Time = 2,
            Type = "normal"
        })

        task.spawn(function()
            Jnkie:Init(self._service, self._identifier, self._provider)
            local keyLink = Jnkie:GetKeyLink()
            if keyLink and keyLink ~= "" then
                setClip(keyLink)
                showNotification({
                    Title = "Key Link Copied",
                    Desc = "Checkpoint URL copied to clipboard! Complete it to get your key.",
                    Time = 4,
                    Type = "success"
                })
            else
                showNotification({
                    Title = "Failed to Get Link",
                    Desc = "Could not fetch key link from Jnkie. Please check connection.",
                    Time = 3.5,
                    Type = "error"
                })
            end
        end)
    end)

    -- 2. "Buy Key" Button
    createSecondaryButton("Buy Key", "shopping-cart", 2, function()
        local buyUrl = self._buyLink or self._discordLink
        setClip(buyUrl)
        showNotification({
            Title = "Store Link Copied",
            Desc = "Premium purchase link copied to clipboard!",
            Time = 3.5,
            Type = "success"
        })
    end)

    -- 3. "Discord" Button
    createSecondaryButton("Discord", "discord", 3, function()
        setClip(self._discordLink)
        showNotification({
            Title = "Discord Copied",
            Desc = "Discord invite copied to clipboard! Join our community for updates.",
            Time = 3.5,
            Type = "normal"
        })
    end)

    -- =====================================================================
    -- 5. VERIFICATION LOGIC HANDLER
    -- =====================================================================
    local function performVerification()
        if self._isVerifying then return end
        local inputKey = KeyTextBox.Text:gsub("^%s*(.-)%s*$", "%1") -- trim whitespace

        if inputKey == "" then
            showNotification({
                Title = "Missing Key",
                Desc = "Please enter your key to continue.",
                Time = 2.5,
                Type = "warning"
            })
            shakeCard(InputCard)
            return
        end

        self._isVerifying = true
        verifyLabel.Text = "Verifying..."
        tw({ v = VerifyButton, t = 0.15, g = { BackgroundColor3 = Theme.MainDark } }):Play()
        tw({ v = verifyStroke, t = 0.15, g = { Color = Theme.Main } }):Play()
        tw({ v = verifyLabel, t = 0.15, g = { TextColor3 = Theme.Main } }):Play()
        tw({ v = verifyIcon, t = 0.15, g = { ImageColor3 = Theme.Main } }):Play()

        task.spawn(function()
            Jnkie:Init(self._service, self._identifier, self._provider)
            local isValid, message = Jnkie:CheckKey(inputKey)

            if isValid then
                -- Key Valid!
                if message == "KEYLESS" then
                    getgenv().SCRIPT_KEY = "KEYLESS"
                else
                    getgenv().SCRIPT_KEY = inputKey
                end

                if self._saveKey then
                    saveKeyToFile(self._keyFile, inputKey)
                end

                verifyLabel.Text = "Verified!"
                tw({ v = VerifyButton, t = 0.2, g = { BackgroundColor3 = Theme.Success } }):Play()
                tw({ v = verifyStroke, t = 0.2, g = { Color = Theme.Success } }):Play()
                tw({ v = verifyLabel, t = 0.2, g = { TextColor3 = Theme.MainDark } }):Play()
                tw({ v = verifyIcon, t = 0.2, g = { ImageColor3 = Theme.MainDark } }):Play()

                showNotification({
                    Title = "Access Granted",
                    Desc = "Key authenticated successfully! Welcome to " .. tostring(self._title) .. ".",
                    Time = 3,
                    Type = "success"
                })

                -- Smooth closing sequence & callback execution
                task.wait(0.6)
                local fadeOut = tw({ v = MainFrame, t = 0.25, s = Enum.EasingStyle.Quad, d = "In", g = { GroupTransparency = 1 } })
                fadeOut:Play()
                fadeOut.Completed:Connect(function()
                    pcall(function() ScreenGui:Destroy() end)
                    if self._callback and type(self._callback) == "function" then
                        task.spawn(self._callback, inputKey)
                    end
                    isKeyVerified = true
                end)
                task.delay(0.8, function()
                    isKeyVerified = true
                end)
            else
                -- Key Invalid!
                self._isVerifying = false
                verifyLabel.Text = "Verify Key"
                tw({ v = VerifyButton, t = 0.2, g = { BackgroundColor3 = Theme.Main } }):Play()
                tw({ v = verifyStroke, t = 0.2, g = { Color = Theme.Main } }):Play()
                tw({ v = verifyLabel, t = 0.2, g = { TextColor3 = Theme.MainDark } }):Play()
                tw({ v = verifyIcon, t = 0.2, g = { ImageColor3 = Theme.MainDark } }):Play()

                -- Flash red border and shake
                tw({ v = inputStroke, t = 0.1, g = { Color = Theme.Error } }):Play()
                shakeCard(InputCard)
                task.delay(0.6, function()
                    tw({ v = inputStroke, t = 0.3, g = { Color = Theme.CardBorder } }):Play()
                end)

                showNotification({
                    Title = "Authentication Failed",
                    Desc = tostring(message or "The key entered is invalid or expired."),
                    Time = 3.5,
                    Type = "error"
                })
            end
        end)
    end

    local lastVerifyClick = 0
    local function onVerifyTriggered()
        local now = tick()
        if now - lastVerifyClick < 0.25 then return end
        lastVerifyClick = now
        playClickSound()
        createRipple(VerifyButton)
        performVerification()
    end

    verifyClick.MouseButton1Click:Connect(onVerifyTriggered)
    verifyClick.Activated:Connect(onVerifyTriggered)

    KeyTextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            performVerification()
        end
    end)

    -- If a saved key was pre-filled, attempt auto-verification in background
    local savedKey = loadKeyFromFile(self._keyFile)
    if savedKey and savedKey ~= "" then
        task.spawn(function()
            task.wait(0.3)
            if not isKeyVerified and not isCancelled then
                performVerification()
            end
        end)
    end

    -- Window Opening Animation
    local targetSize = Shadow.Size
    Shadow.Size = targetSize - UDim2.fromOffset(10, 10)
    MainFrame.GroupTransparency = 1
    tw({
        v = Shadow,
        t = 0.24,
        s = Enum.EasingStyle.Quad,
        d = "Out",
        g = { Size = targetSize }
    }):Play()
    tw({
        v = MainFrame,
        t = 0.22,
        s = Enum.EasingStyle.Quad,
        d = "Out",
        g = { GroupTransparency = 0 }
    }):Play()

    local controller = {
        ScreenGui = ScreenGui,
        Notify = showNotification,
        Verify = performVerification,
        Close = function()
            isCancelled = true
            getgenv().UI_CLOSED = true
            pcall(function() ScreenGui:Destroy() end)
        end
    }

    -- While loop: block execution until the user authenticates a valid key or closes the UI.
    -- This prevents premature execution of the protected loader and ensures the user is NEVER kicked!
    local shouldWait = (config.WaitForKey ~= false)
    if shouldWait then
        while not isKeyVerified and not isCancelled do
            if not ScreenGui or not ScreenGui.Parent then
                isCancelled = true
                break
            end
            task.wait(0.1)
        end

        if isCancelled then
            pcall(function() ScreenGui:Destroy() end)
            -- Gracefully suspend execution so the script NEVER falls through to the Jnkie loader without a valid key.
            -- This guarantees the player is NEVER kicked from the game!
            -- Park this thread forever without a timer; Pre-check of the next run starts a fresh pipeline.
            coroutine.yield()
            return controller
        end
    end

    return controller
end

-- If executed directly as standalone script, initialize automatically
local defaultInstance = KeySystem:Init({
    Title = "Aether",
    SubTitle = "Studios",
    Tag = "KEY SYSTEM",
    Service = "Aether Studios",
    Identifier = "1001263",
    Provider = "Free Key",
    BuyLink = "https://discord.gg/getaether",
    DiscordLink = "https://discord.gg/getaether",
    SaveKey = true,
    WaitForKey = true,
    Callback = function(key)
        print("Authenticated, enjoy the script!")
        -- Only getgenv().SCRIPT_KEY is read by the Jnkie loader; Core clears it after auth.
        getgenv().SCRIPT_KEY = key
    end
})
do local k=getgenv().SCRIPT_KEY or SCRIPT_KEY or"";if type(k)~="string"then k=""end;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table"and type(syn.request)=="function"and syn.request)or(type(request)=="function"and request)or(type(http_request)=="function"and http_request)or(type(http)=="table"and type(http.request)=="function"and http.request);if type(r)~="function"then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/"..S[i].."?v=2&errors=text&core=521a8ec19a3661f781b963c6f484c91b511f5df1cd0de22437c8ddcf6160d1d2.55IAzFIz0SBbPgBAZL-9UCo7Jznl6vtUc4_Av66SvVs",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table"and type(x.Body)=="string"and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"then warn(m);return end;local cu,su=x.Body:match("^([^\n]+)\n([^\n]+)$");if not cu or not (string.sub(cu,1,8)=="https://")or not (string.sub(su,1,8)=="https://")then warn(m);return end;local cf;do local ca,cx=q({Url=cu,Method="GET"});if not ca or type(cx)~="table"or cx.StatusCode~=200 or type(cx.Body)~="string"or#cx.Body==0 then warn(m);return end;cf=loadstring(cx.Body);cx=nil;if type(cf)~="function"then warn(m);return end end;a,x=q({Url=su,Method="GET"});if not a or type(x)~="table"or x.StatusCode~=200 or type(x.Body)~="string"or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function"then warn(m);return end;do local o,e=pcall(cf);if not o then warn(e);return end end;f()end end