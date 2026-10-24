local function createDmcConfigStore(d)
    local A = { Accent = "DEC173", RainbowUI = false, Selected = "", Storage = "Session only", Notice = "" }
    local document = { schema = 1, profiles = {}, accent = A.Accent, rainbowUI = false, selected = "" }
    local blockedFile = false
    local boolKeys = { "Enabled", "CloseRangeRush", "HighBallJumps", "JumpThenDive",
        "BackwardRecovery", "PositionAssist", "PreShotCoverage", "RespectManualMovement" }
    local diveModes = { SMART = true, FORWARD = true, LEFT = true, RIGHT = true, SIDES = true }
    local function copy(value)
        if type(value) ~= "table" then return value end
        local result = {}
        for key, item in pairs(value) do result[key] = copy(item) end
        return result
    end
    function A.Color(value)
        if type(value) ~= "string" then return nil end
        local hex = value:match("^%s*#?([%x]+)%s*$")
        return hex and #hex == 6 and string.upper(hex) or nil
    end
    local function name(value)
        if type(value) ~= "string" then return nil end
        value = value:match("^%s*(.-)%s*$")
        if #value < 1 or #value > 40 or value:find("[%c]") then return nil end
        return value
    end
    function A.Validate(value)
        if type(value) ~= "table" or type(value.goalkeeper) ~= "table"
            or type(value.striker) ~= "table" or type(value.misc) ~= "table" then return nil end
        local gk, striker, misc = {}, {}, {}
        for _, key in ipairs(boolKeys) do
            if type(value.goalkeeper[key]) ~= "boolean" then return nil end
            gk[key] = value.goalkeeper[key]
        end
        if not diveModes[value.goalkeeper.DiveFilter] then return nil end
        if value.goalkeeper.PositionMode ~= "THREATS"
            and value.goalkeeper.PositionMode ~= "HOME_AND_THREATS" then return nil end
        gk.DiveFilter, gk.PositionMode = value.goalkeeper.DiveFilter, value.goalkeeper.PositionMode
        for _, key in ipairs({ "Enabled", "AutoCurve", "SmartRelease" }) do
            if type(value.striker[key]) ~= "boolean" then return nil end
            striker[key] = value.striker[key]
        end
        local range = value.striker.Range
        if type(range) ~= "number" or range ~= range or range < 40 or range > 100 then return nil end
        striker.Range = math.floor(range + 0.5)
        for _, key in ipairs({ "AutoDribble" }) do
            if type(value.misc[key]) ~= "boolean" then return nil end
            misc[key] = value.misc[key]
        end
        local accent = A.Color(value.accent)
        if not accent then return nil end
        if value.rainbowUI ~= nil and type(value.rainbowUI) ~= "boolean" then return nil end
        return { goalkeeper = gk, striker = striker, misc = misc, accent = accent, rainbowUI = value.rainbowUI == true }
    end
    local function decode(raw)
        if type(raw) ~= "string" or #raw > 262144 then return false end
        local ok, value = pcall(d.decode, raw)
        if not ok or type(value) ~= "table" or value.schema ~= 1 or type(value.profiles) ~= "table" then return false end
        local profiles, count = {}, 0
        for key, profile in pairs(value.profiles) do
            local validName, validProfile = name(key), A.Validate(profile)
            if validName == key and validProfile and count < 50 then
                profiles[key], count = validProfile, count + 1
            else A.Notice = "Some invalid configs were skipped." end
        end
        document = { schema = 1, profiles = profiles, accent = A.Color(value.accent) or A.Accent,
            rainbowUI = value.rainbowUI == true,
            selected = name(value.selected) or "",
            acknowledgedVersion = type(value.acknowledgedVersion) == "string" and value.acknowledgedVersion or nil }
        if not profiles[document.selected] then document.selected = "" end
        return true
    end
    local canFile = type(d.read) == "function" and type(d.write) == "function"
    if type(d.cache) == "string" then decode(d.cache) end
    if canFile then
        local exists = true
        if type(d.exists) == "function" then
            local ok, result = pcall(d.exists, d.path)
            if ok then exists = result == true end
        end
        if exists then
            local ok, raw = pcall(d.read, d.path)
            if ok and not decode(raw) then
                blockedFile = true
                A.Notice = "Settings file is unreadable; saved configs in that file were kept untouched."
            elseif not ok and type(d.exists) == "function" then
                blockedFile = true
                A.Notice = "Settings file could not be read; using this session."
            end
        end
        A.Storage = blockedFile and "Session only · file unavailable" or "Local file · " .. d.path
    end
    A.Accent, A.RainbowUI, A.Selected = document.accent, document.rainbowUI, document.selected
    local function persist()
        document.accent, document.rainbowUI, document.selected = A.Accent, A.RainbowUI, A.Selected
        local ok, encoded = pcall(d.encode, document)
        if not ok then return false, "Could not encode settings." end
        d.remember(encoded)
        if canFile and not blockedFile then
            local written, result = pcall(d.write, d.path, encoded)
            if written and result ~= false then A.Storage = "Local file · " .. d.path; return true, "Saved to local file." end
            A.Storage = "Session only · file write failed"
            return true, "Saved for this session; the executor could not write the file."
        end
        return true, "Saved for this session; file storage is unavailable."
    end
    function A.List()
        local names = {}
        for key in pairs(document.profiles) do names[#names + 1] = key end
        table.sort(names, function(a, b)
            if string.lower(a) == string.lower(b) then return a < b end
            return string.lower(a) < string.lower(b)
        end)
        return names
    end
    function A.Select(value)
        if not document.profiles[value] then return false end
        A.Selected = value
        return true
    end
    function A.Save(value, profile, creating)
        local validName, validProfile = name(value), A.Validate(profile)
        if not validName then return false, "Enter a config name (1–40 characters)." end
        if not validProfile then return false, "Current settings could not be saved." end
        if creating and document.profiles[validName] then return false, "Name already exists. Select it and press Save." end
        if not creating and not document.profiles[validName] then return false, "Select a config before saving." end
        if creating and #A.List() >= 50 then return false, "Config limit reached (50)." end
        local previous, selected = document.profiles[validName], A.Selected
        document.profiles[validName], A.Selected = validProfile, validName
        local ok, detail = persist()
        if not ok then document.profiles[validName], A.Selected = previous, selected end
        return ok, detail
    end
    function A.Get(value)
        return copy(document.profiles[value])
    end
    function A.SetAppearance(value, rainbow)
        local hex = A.Color(value)
        if not hex then return false, "Use a six-digit hex color, for example #DEC173." end
        if type(rainbow) ~= "boolean" then return false, "Rainbow UI must be on or off." end
        local previousAccent, previousRainbow = A.Accent, A.RainbowUI
        A.Accent, A.RainbowUI = hex, rainbow
        local ok, detail = persist()
        if not ok then A.Accent, A.RainbowUI = previousAccent, previousRainbow end
        return ok, detail
    end
    function A.SetAccent(value)
        return A.SetAppearance(value, A.RainbowUI)
    end
    function A.SetRainbowUI(value)
        return A.SetAppearance(A.Accent, value)
    end
    function A.ShouldPrompt(previousBuild, currentBuild)
        if document.acknowledgedVersion then return document.acknowledgedVersion ~= d.version end
        return type(previousBuild) == "string" and previousBuild ~= currentBuild
    end
    function A.Acknowledge()
        if document.acknowledgedVersion == d.version then return true end
        document.acknowledgedVersion = d.version
        return persist()
    end
    return A
end

-- Configs use the same feature setters as the controls. A refused native setter
-- rolls settings back instead of displaying a successful load.
local function createDmcSettingsController(d)
    local A = {}
    function A.Snapshot()
        local gk = {}
        for _, key in ipairs({ "CloseRangeRush", "HighBallJumps", "JumpThenDive", "BackwardRecovery",
            "PositionAssist", "PreShotCoverage", "RespectManualMovement", "PositionMode" }) do gk[key] = d.config[key] end
        gk.Enabled = d.gkEnabled()
        gk.DiveFilter = d.config.DiveFilter == "ALL" and "SMART" or d.config.DiveFilter
        return { goalkeeper = gk,
            striker = { Enabled = d.striker.Enabled, AutoCurve = d.striker.AutoCurve,
                SmartRelease = d.striker.SmartRelease, Range = d.striker.GetAssistRange() },
            misc = { AutoDribble = d.misc.AutoDribble },
            accent = d.accent(), rainbowUI = d.rainbow and d.rainbow() == true or false }
    end
    local function apply(profile)
        local function feature(object, key, value)
            if object[key] == value then return end
            assert(object["Set" .. key](value) ~= false, key .. " could not be changed")
            assert(object[key] == value, key .. " did not accept the setting")
        end
        feature(d.striker, "AutoCurve", profile.striker.AutoCurve)
        feature(d.striker, "SmartRelease", profile.striker.SmartRelease)
        feature(d.striker, "Enabled", profile.striker.Enabled)
        assert(d.striker.SetAssistRange(profile.striker.Range) ~= false, "Shot range could not be changed")
        feature(d.misc, "AutoDribble", profile.misc.AutoDribble)
        for key, value in pairs(profile.goalkeeper) do if key ~= "Enabled" then d.config[key] = value end end
        d.resetGoalkeeper()
        if d.gkEnabled() ~= profile.goalkeeper.Enabled then d.setGK(profile.goalkeeper.Enabled) end
        d.theme(profile.accent)
        if d.setRainbow then d.setRainbow(profile.rainbowUI == true) end
    end
    function A.Load(profile)
        local valid = d.validate(profile)
        if not valid then return false, "Config is invalid; settings were not changed." end
        local previous = A.Snapshot()
        local ok, err = pcall(apply, valid)
        if ok then return true, "Config loaded." end
        local restored = pcall(apply, previous)
        return false, "Config load failed: " .. tostring(err)
            .. (restored and ". Previous settings restored." or ". Some settings could not be restored; check the toggles.")
    end
    return A
end

local function showDmcUpdatePrompt(parent, hex)
    local gui = Instance.new("ScreenGui")
    gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "DmcUpdate", false, 1001
    gui.IgnoreGuiInset = true
    local shade = Instance.new("Frame")
    shade.Size, shade.BackgroundColor3, shade.BackgroundTransparency = UDim2.fromScale(1, 1), Color3.fromRGB(0, 0, 0), 0.45
    shade.Active, shade.BorderSizePixel, shade.Parent = true, 0, gui
    local accent = Color3.fromRGB(tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16))
    local panel = Instance.new("Frame")
    panel.AnchorPoint, panel.Position = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.4)
    panel.Size, panel.BackgroundColor3, panel.BorderSizePixel = UDim2.new(0.9, 0, 0, 200), Color3.fromRGB(16, 16, 15), 0
    panel.Parent = shade
    local limit = Instance.new("UISizeConstraint")
    limit.MaxSize, limit.Parent = Vector2.new(460, 200), panel
    local heading = Instance.new("TextLabel")
    heading.Position, heading.Size = UDim2.fromOffset(14, 8), UDim2.new(1, -28, 0, 28)
    heading.BackgroundTransparency, heading.TextSize, heading.Font = 1, 18, Enum.Font.FredokaOne
    heading.TextXAlignment, heading.TextColor3, heading.Text, heading.Parent = Enum.TextXAlignment.Left, accent, "Dmc | Script updated", panel
    local message = Instance.new("TextLabel")
    message.Position, message.Size = UDim2.fromOffset(14, 52), UDim2.new(1, -28, 0, 56)
    message.BackgroundTransparency, message.TextWrapped, message.TextSize = 1, true, 16
    message.Font, message.TextColor3 = Enum.Font.Nunito, Color3.fromRGB(242, 243, 240)
    message.Text, message.Parent = "Script updated press OK to continue", panel
    local okButton = Instance.new("TextButton")
    okButton.AnchorPoint, okButton.Position, okButton.Size = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 1, -58), UDim2.fromOffset(100, 36)
    okButton.Name, okButton.Text, okButton.TextSize, okButton.Font = "OK", "OK", 16, Enum.Font.FredokaOne
    okButton.BackgroundColor3, okButton.TextColor3, okButton.BorderSizePixel = accent, Color3.fromRGB(16, 16, 15), 0
    okButton.Modal, okButton.Parent = true, panel
    local acknowledged = false
    local connection = okButton.Activated:Connect(function() acknowledged = true end)
    gui.Parent = parent
    local waited, err = pcall(function()
        while gui.Parent and not acknowledged do task.wait(0.05) end
    end)
    connection:Disconnect()
    gui:Destroy()
    assert(waited, err)
    return acknowledged
end


-- Small, dependency-free startup controller. Game modules are loaded only after
-- its status panel is visible. No executor-specific GUI or identity API is needed.
local function createDmcStartup(d)
    local B = {
        stage = "Waiting for the game", finished = false,
        cleanup = nil :: (() -> (boolean?, string?))?,
        error = nil :: string?,
    }
    function B.Status(text)
        B.stage = text
        if not B.finished then pcall(d.show, "Dmc | Starting", text) end
    end
    function B.Load(path)
        B.Status("Loading " .. path)
        local object = d.resolve(path)
        local result, closed
        d.spawn(function()
            local values = table.pack(pcall(d.require, object))
            if not closed then result = values end
        end)
        local deadline = d.now() + 30
        while not result and d.now() < deadline do d.wait() end
        closed = true
        assert(result, "Timed out loading " .. path .. ". The game module did not return within 30 seconds.")
        assert(result[1], "Cannot load " .. path .. ": " .. tostring(result[2]))
        assert(type(result[2]) == "table", "Unexpected module result: " .. path)
        return result[2]
    end
    function B.Run(main)
        B.Status(B.stage)
        local ok, err = pcall(function() d.ready(); main(B) end)
        B.finished = true
        if ok then
            pcall(d.hide)
        else
            local message = tostring(err)
            local cleanup = B.cleanup
            if cleanup then
                local cleaned, released = pcall(cleanup)
                if not cleaned or released == false then message = message .. "\nCleanup incomplete; rejoin before retrying." end
            end
            B.error = message
            d.warn("[Dmc startup] " .. message)
            pcall(d.show, "Dmc | Startup failed", message .. "\n\nSend this error and your executor name when reporting the problem.")
        end
        return ok, err
    end
    return B
end

local function createDmcStartupDisplay()
    local gui, label, heading, closeConnection
    local function hide()
        if closeConnection then closeConnection:Disconnect(); closeConnection = nil end
        if gui then gui:Destroy(); gui = nil end
    end
    local function show(title, message)
        if not gui then
            local player = game:GetService("Players").LocalPlayer
            local parent = player and player:FindFirstChildOfClass("PlayerGui")
            if not parent then return end
            gui = Instance.new("ScreenGui")
            gui.Name, gui.ResetOnSpawn, gui.DisplayOrder = "DmcStartup", false, 1000
            local panel = Instance.new("Frame")
            panel.AnchorPoint = Vector2.new(0.5, 0.5)
            panel.Position, panel.Size = UDim2.new(0.5, 0, 0.4, 0), UDim2.new(0.9, 0, 0, 200)
            panel.BackgroundColor3, panel.BorderSizePixel = Color3.fromRGB(16, 16, 15), 0
            panel.Parent = gui
            local size = Instance.new("UISizeConstraint")
            size.MaxSize = Vector2.new(460, 200); size.Parent = panel
            heading = Instance.new("TextLabel")
            heading.Position, heading.Size = UDim2.new(0, 14, 0, 8), UDim2.new(1, -58, 0, 28)
            heading.BackgroundTransparency, heading.TextSize = 1, 16
            heading.TextXAlignment, heading.Font = Enum.TextXAlignment.Left, Enum.Font.GothamMedium
            heading.TextColor3 = Color3.fromRGB(222, 193, 115); heading.Parent = panel
            label = Instance.new("TextBox")
            label.Position, label.Size = UDim2.new(0, 14, 0, 44), UDim2.new(1, -28, 1, -54)
            label.BackgroundTransparency, label.TextSize, label.TextWrapped = 1, 13, true
            label.ClearTextOnFocus, label.TextEditable, label.MultiLine = false, false, true
            label.TextXAlignment, label.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Top
            label.Font, label.TextColor3 = Enum.Font.Code, Color3.fromRGB(233, 231, 220)
            label.Parent = panel
            local close = Instance.new("TextButton")
            close.Text, close.TextSize = "X", 14
            close.Position, close.Size = UDim2.new(1, -38, 0, 8), UDim2.new(0, 28, 0, 28)
            close.BackgroundColor3, close.TextColor3 = Color3.fromRGB(39, 37, 30), heading.TextColor3
            close.Parent = panel
            closeConnection = close.Activated:Connect(hide)
            gui.Parent = parent
        end
        heading.Text, label.Text = title, message
    end
    return show, hide
end

local startupShow, startupHide = createDmcStartupDisplay()
local BOOT = createDmcStartup({
    now = os.clock, wait = function() task.wait(0.05) end, spawn = task.spawn,
    require = require, warn = warn, show = startupShow, hide = startupHide,
    ready = function()
        local players = game:GetService("Players")
        local deadline = os.clock() + 30
        while (not game:IsLoaded() or not players.LocalPlayer) and os.clock() < deadline do
            startupShow("Dmc | Starting", "Waiting for the game to finish loading...")
            task.wait(0.1)
        end
        assert(game:IsLoaded() and players.LocalPlayer, "Game client was not ready after 30 seconds. Join the game before running Dmc.")
        assert(players.LocalPlayer:WaitForChild("PlayerGui", 30), "PlayerGui is unavailable.")
        startupShow("Dmc | Starting", "Loading game modules...")
    end,
    resolve = function(path)
        local object = game:GetService("ReplicatedStorage")
        local deadline = os.clock() + 30
        for name in string.gmatch(path, "[^.]+") do
            object = object:WaitForChild(name, math.max(0.01, deadline - os.clock()))
            assert(object, "Missing dependency: " .. path .. ". Run Dmc in the supported game after it loads.")
        end
        return object
    end,
})

BOOT.Run(function()
-- DMC MAIN BEGIN
--==============================================================
-- SERVICES
--==============================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = assert(Players.LocalPlayer, "Run this on the client")
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 10)
-- Bump the release ID for every shipped update to trigger the one-time OK prompt.
local RELEASE_VERSION = "2026.10.02.1"
local BUILD = "Dmc Settings 1.5.2 | GK 3.2.7 | STR 0.16.3 | Misc 0.18.0 | Evaluation 0.2"
local ENV = _G
if type(getgenv) == "function" then
    local ok, environment = pcall(getgenv)
    if ok and type(environment) == "table" then ENV = environment end
end

local settingsHttp = game:GetService("HttpService")
local SettingsStore = createDmcConfigStore({
    version = RELEASE_VERSION, path = "Dmc_settings.json", cache = ENV.__DMC_CONFIG_CACHE,
    read = readfile, write = writefile, exists = isfile,
    encode = function(value) return settingsHttp:JSONEncode(value) end,
    decode = function(value) return settingsHttp:JSONDecode(value) end,
    remember = function(value) ENV.__DMC_CONFIG_CACHE = value end,
})

-- Keep the current instance running until all dependencies have loaded.

--==============================================================
-- MODULES
--==============================================================

local function resolve(path)
    local object = ReplicatedStorage
    for name in string.gmatch(path, "[^.]+") do
        object = object:WaitForChild(name, 5)
        assert(object, "Missing dependency: " .. path)
    end
    return object
end

local function module(path)
    return BOOT.Load(path)
end

local M = {
    Dive = module("Modules.Actions.GoalkeeperDive"),
    Assist = module("Modules.Actions.GoalkeeperDiveAssist"),
    Actions = module("Modules.Actions.ActionCommands"),
    Protocol = module("Modules.Actions.ActionRemoteProtocol"),
    Locks = module("Modules.Actions.ActionLocks"),
    Contacts = module("Modules.Actions.GoalkeeperActions"),
    Physics = module("Modules.Ball.Physics"),
    Hitboxes = module("Modules.Gameplay.HitboxSettings"),
    Prediction = module("Modules.Gameplay.GoalkeeperPrediction"),
    Match = module("Modules.Gameplay.MatchSettings"),
    Controllers = module("Modules.Characters.CharacterControllers"),
    Grounding = module("Modules.Characters.Grounding"),
    Ragdoll = module("Modules.Characters.Ragdoll"),
    Renderer = module("Client.Gameplay.Ball.Renderer"),
    Teams = module("Client.Gameplay.ActorTeams"),
    Practice = module("Client.Gameplay.PracticeSession"),
    Movement = module("Client.Gameplay.Player.Movement"),
    Presentation = module("Client.Gameplay.Actions.GoalkeeperDivePresentation"),
    Slide = module("Client.Gameplay.Actions.SlideTackleInput"),
    Dodge = module("Client.Gameplay.Actions.Dodge"),
    Freeze = module("Client.Gameplay.KickoffFreeze"),
    Replay = module("Client.Gameplay.Replay.GoalReplay"),
    Clock = module("Client.Player.CharacterMotionSmoothing"),
    Keybinds = module("Modules.Gameplay.Keybinds"),
    Role = module("Client.Gameplay.Player.GoalkeeperRole"),
    Actors = module("Modules.Characters.Actors"),
    Motion = module("Modules.Characters.CharacterMotion"),
}

local BallRemotes = resolve("Remotes.Ball")
local TackleRemote = BallRemotes:WaitForChild("Tackle", 5)
local StateRemote = BallRemotes:WaitForChild("State", 5)

assert(TackleRemote and StateRemote and PlayerGui, "Client is not ready")

if SettingsStore.ShouldPrompt(ENV.AutoGKBuild, BUILD) then
    BOOT.Status("Waiting for update confirmation")
    assert(showDmcUpdatePrompt(PlayerGui, SettingsStore.Accent), "Update confirmation was closed before OK.")
    SettingsStore.Acknowledge()
end

if type(ENV.__AUTO_GK_CLEANUP) == "function" then
    local called, released, detail = pcall(ENV.__AUTO_GK_CLEANUP)
    assert(called, "Previous Auto GK cleanup threw: " .. tostring(released))
    assert(released == true,
        "Previous Auto GK cleanup was not confirmed: "
            .. tostring(detail or "Older cleanup has no success result; rejoin once before loading this version"))
end

--==============================================================
-- CONFIGURATION
--==============================================================

local Config = {
    Enabled = true,
    PositionAssist = true,
    PreShotCoverage = true,
    CoverageRange = 65,
    CoverageMinimumDepth = 3,
    CoverageLeadSeconds = 0.10,
    CoverageMaximumLead = 2,
    CoverageStartRadius = 0.90,
    CoverageStopRadius = 0.45,
    CoverageUpdateHz = 20,
    UrgentShotSeconds = 0.55,
    PositionMode = "THREATS",
    RespectManualMovement = true,
    HighBallJumps = true,
    JumpThenDive = true,
    DiveFilter = "SMART",
    BackwardRecovery = true,
    PlannerHz = 12,
    CloseShotPlannerHz = 30,
    UISampleHz = 4,
    SampleStep = 0.01,
    PredictionHorizon = 1.10,
    GoalMarginSeconds = 0.045,
    JumpQueueEstimate = 0.05,
    JumpQueueTimeout = 0.45,
    JumpDiveMinimumAge = 0.07,
    JumpRetrySeconds = 0.65,
    HomeDepth = 8,
    HomeRadius = 2.5,
    PositionDeadzone = 0.65,
    SafeLateralReach = 14,
    PositionResponseSeconds = 0.14,
    PositionStartDeadzone = 1.15,
    HomeStopRadius = 1.25,
    TargetChangeDeadzone = 0.20,
    TargetResponseSeconds = 0.16,
    ManualReleaseGrace = 0.18,
    CachedFrameMaxAge = 0.12,
    MissingStateDisplayDelay = 0.40,
    UIStatusDebounce = 0.18,
    UIEventHoldSeconds = 0.50,
    MaxFinalCandidates = 14,
    RuntimeErrorRetrySeconds = 0.25,
    RuntimeErrorLimit = 3,
    Debug = false,
}

local Stats = {
    Requests = 0,
    JumpRequests = 0,
    DiveRequests = 0,
    FlightsActedOn = 0,
    CatchesObserved = 0,
    ActionMatches = 0,
    Rejected = 0,
}

ENV.AutoGKConfig = Config
ENV.AutoGKStats = Stats
ENV.AUTO_GK_ENABLED = true
ENV.AutoGKBuild = BUILD

--==============================================================
-- LIFECYCLE
--==============================================================

local S = {
    alive = true,
    cleanupComplete = false,
    cleaningUp = false,
    cleanupError = nil,
    closeDropdown = nil,
    cancelUITweens = nil,
    releaseOwnedState = nil,
    releaseStriker = nil,
    releaseMisc = nil,
    releaseEvaluation = nil,
    connections = {},
    status = "STARTING",
    detail = "",
    nextActionAt = 0,
    nextJumpAt = 0,
    nextPlanAt = 0,
    queueEstimate = Config.JumpQueueEstimate,
    jump = nil,
    controller = nil,
    ownedMove = nil,
    moveCharacter = nil,
    lastChar = nil,
    lastFrame = nil,
    nextUIAt = 0,
    pending = nil,
    lastWarning = {},
    catches = {},
    coverageFrame = nil,
    coverageNextAt = 0,
    coverageWrites = 0,
    plannerMilliseconds = 0,
    immediatePlansChecked = 0,
    delayedPlansChecked = 0,
    lastPlanReason = "NONE",
    loopBusy = false,
    runtimeFailures = 0,
    runtimeRetryAt = 0,
    runtimeError = nil,
    countedFlights = {},
    wasKeeper = false,
    manualActionUntil = 0,
    motionLease = nil,
    nextLeaseId = 0,
    orphanedLease = nil,
    uiBusy = false,
    retiredLocks = {},
    retiredMotions = {},
    jumpBlockOwned = false,
    uiClosers = {},
    ownLockAcquires = 0,
    ownLockReleases = 0,
    goalBasis = setmetatable({}, { __mode = "k" }),
    stick = Vector2.zero,
    touches = {},
    focused = true,
    ui = nil,
    allowPositioning = false,
    positionActive = false,
    positionTarget = nil,
    positionKey = nil,
    positionChangedAt = 0,
    manualUntil = 0,
    positionWrites = 0,
    releaseWrites = 0,
    releaseReasons = {},
    lastReleaseReason = "NONE",
    holdStops = 0,
    holdRechecks = 0,
    holdRecheckMisses = 0,
    followupBlocks = 0,
    lastFollowupBlock = nil,
    ballPhase = "STARTING",
    ballInfo = "",
    ballSignature = nil,
    missingSince = nil,
    currentContext = nil,
    observedBallId = nil,
    displayName = "STARTING",
    displayDetail = "",
    displayUntil = 0,
    displayCandidate = nil,
    displayCandidateSince = 0,
    moveLock = "AutoGK.ContactTest."
        .. tostring(math.floor(os.clock() * 1000000)),
}

-- Installed before listeners so partial initialization has the same cleanup contract.
local function cleanup()
    if S.cleanupComplete then return true end
    if S.cleaningUp then return false, "Cleanup is already running" end

    S.cleaningUp = true
    S.alive = false
    ENV.AUTO_GK_ENABLED = false
    local failures = {}

    local function attempt(label, fn, ...)
        local ok, result, detail = pcall(fn, ...)
        if not ok or result == false then
            failures[#failures + 1] = label .. ": "
                .. tostring(ok and (detail or "release refused") or result)
            return false
        end
        return true
    end

    if S.closeDropdown then attempt("UI close", S.closeDropdown) end
    if S.cancelUITweens then attempt("UI tweens", S.cancelUITweens) end

    if S.releaseMisc then attempt("Miscellaneous", S.releaseMisc) end
    if S.releaseStriker then attempt("Striker hooks", S.releaseStriker) end
    if S.releaseEvaluation then attempt("Evaluation observers", S.releaseEvaluation) end

    if S.releaseOwnedState then
        attempt("Owned state", S.releaseOwnedState, true)
    end

    -- Retain failed handles so a later call can retry them.
    local remaining = {}
    for _, connection in ipairs(S.connections) do
        if not attempt("Disconnect", function() connection:Disconnect() end) then
            remaining[#remaining + 1] = connection
        end
    end
    S.connections = remaining

    if S.ui and attempt("UI destroy", function() S.ui:Destroy() end) then
        S.ui = nil
        S.closeDropdown = nil
        S.cancelUITweens = nil
        S.isUIInput = nil
    end

    if S.loopBusy then
        failures[#failures + 1] = "Main update is still finishing; retry cleanup"
    end

    if S.ownedMove or S.jump or S.jumpBlockOwned or S.motionLease
        or S.controller or next(S.retiredLocks) or next(S.retiredMotions) then
        failures[#failures + 1] = "Owned movement resources remain"
    end

    S.cleanupComplete = #failures == 0
    S.cleanupError = #failures > 0 and table.concat(failures, "; ") or nil
    S.cleaningUp = false

    if S.cleanupComplete then
        ENV.__AUTO_GK_CONTROLLER = nil
    else
        warn("[Auto GK] Cleanup incomplete: " .. S.cleanupError)
    end

    return S.cleanupComplete, S.cleanupError
end

ENV.__AUTO_GK_CLEANUP = cleanup
ENV.StopAutoGK = cleanup
BOOT.cleanup = cleanup

local function connect(signal, fn)
    local c = signal:Connect(fn)
    table.insert(S.connections, c)
    return c
end

local function log(message)
    if Config.Debug then
        print("[Auto GK] " .. message)
    end
end

local function report(key, message)
    if os.clock() >= (S.lastWarning[key] or 0) then
        S.lastWarning[key] = os.clock() + 4
        warn("[Auto GK] " .. key .. ": " .. tostring(message))
    end
end

local function flushStatusDisplay()
    if not S.displayCandidate then return end

    local clock = os.clock()

    if clock >= S.displayUntil
        and clock - S.displayCandidateSince
            >= Config.UIStatusDebounce then

        S.displayName = S.status
        S.displayDetail = S.detail
        S.displayCandidate = nil
    end
end

local function status(name: string, detail)
    S.status = name
    S.detail = detail or ""

    if S.displayName == name then
        S.displayDetail = S.detail
        S.displayCandidate = nil
        return
    end

    local event =
        name == "CATCH OBSERVED"
        or name == "SERVER REJECTED"
        or name == "JUMP QUEUED"
        or name == "CLOSE-RANGE RUSH"
        or string.sub(name, 1, 9) == "DIVE SENT"

    local immediate =
        event
        or name == "OFF"
        or name == "NO CHARACTER"
        or name == "WAITING FOR GK"
        or name == "RUNTIME ERROR"
        or name == "MANUAL SLIDE"
        or name == "MANUAL DODGE"
        or name == "RAGDOLL"
        or name == "ROUND TRANSITION"
        or name == "WINDOW UNFOCUSED"

    if immediate then
        S.displayName = name
        S.displayDetail = S.detail
        S.displayCandidate = nil
        S.displayUntil = os.clock()
            + (event and Config.UIEventHoldSeconds or 0)
        return
    end

    if S.displayCandidate ~= name then
        S.displayCandidate = name
        S.displayCandidateSince = os.clock()
    end

    flushStatusDisplay()
end

local function flat(v)
    return Vector3.new(v.X, 0, v.Z)
end

local function finite(n)
    return type(n) == "number"
        and n == n
        and math.abs(n) < math.huge
end

local function finiteVector(v)
    return typeof(v) == "Vector3"
        and finite(v.X)
        and finite(v.Y)
        and finite(v.Z)
end

local function unit(v, fallback)
    v = flat(v)

    return v.Magnitude > 0.0001
        and v.Unit
        or (fallback or Vector3.new(0, 0, -1))
end

local function now()
    return M.Clock.GetSmoothedServerTime()
end

local function inputActive()
    if not S.focused
        or UserInputService:GetFocusedTextBox() then
        return true
    end

    for _, key in ipairs({
        Enum.KeyCode.W,
        Enum.KeyCode.A,
        Enum.KeyCode.S,
        Enum.KeyCode.D,
        Enum.KeyCode.Up,
        Enum.KeyCode.Down,
        Enum.KeyCode.Left,
        Enum.KeyCode.Right,
    }) do
        if UserInputService:IsKeyDown(key) then
            return true
        end
    end

    return S.stick.Magnitude > 0.12
        or next(S.touches) ~= nil
end

connect(UserInputService.InputChanged, function(input)
    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
        S.stick = Vector2.new(input.Position.X, input.Position.Y)
    end
end)

connect(UserInputService.InputBegan, function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        S.touches[input] = true
    end
end)

connect(UserInputService.InputEnded, function(input)
    S.touches[input] = nil

    if input.KeyCode == Enum.KeyCode.Thumbstick1 then
        S.stick = Vector2.zero
    end
end)

connect(UserInputService.WindowFocusReleased, function()
    S.focused = false
    S.stick = Vector2.zero
    table.clear(S.touches)
end)

connect(UserInputService.WindowFocused, function()
    S.focused = true
    S.manualUntil = os.clock() + Config.ManualReleaseGrace
    S.nextPlanAt = 0
end)

--==============================================================
-- ACTION ACCOUNTING
--==============================================================

local function recordRequest(kind, frame)
    Stats.Requests = Stats.Requests + 1

    if kind == "JUMP" then
        Stats.JumpRequests = Stats.JumpRequests + 1
    elseif kind == "DIVE" then
        Stats.DiveRequests = Stats.DiveRequests + 1
    end

    local key = frame and frame.flightKey

    if key and not S.countedFlights[key] then
        S.countedFlights[key] = true
        Stats.FlightsActedOn = Stats.FlightsActedOn + 1
    end
end

--==============================================================
-- MOVEMENT OWNERSHIP
--==============================================================

local function resetPositionTarget()
    S.positionActive = false
    S.positionTarget = nil
    S.positionKey = nil
end

local function noteMoveRelease(reason)
    S.lastReleaseReason = reason
    S.releaseReasons[reason] =
        (S.releaseReasons[reason] or 0) + 1

    return reason
end

local function releaseMove(allowWrite)
    local character, owned = S.moveCharacter, S.ownedMove
    resetPositionTarget()

    local function released(reason)
        if S.moveCharacter == character and S.ownedMove == owned then
            S.ownedMove = nil
            S.moveCharacter = nil
        end
        return reason == "NONE" and reason or noteMoveRelease(reason)
    end

    if not owned or owned.Magnitude == 0 then return released("NONE") end
    if not character or not character.Parent then return released("CHARACTER_GONE") end
    if not allowWrite then return released("YIELD_WITHOUT_WRITE") end

    if inputActive() and S.focused
        and not UserInputService:GetFocusedTextBox() then
        return released("MANUAL_INPUT")
    end

    local current = M.Controllers.GetMoveCommand(character)
    if current.Magnitude == 0 then return released("ALREADY_ZERO") end
    if current.Unit:Dot(owned.Unit) <= 0.999 then return released("COMMAND_CHANGED") end

    -- Do not discard ownership until the write succeeds.
    assert(M.Controllers.SetMoveCommand(character, Vector3.zero) ~= false,
        "Automatic movement stop was refused")
    S.releaseWrites = S.releaseWrites + 1
    return released("STOPPED")
end

local function invalidateFrame(allowWrite)
    S.lastFrame = nil
    S.keeperWait = nil
    S.keeperContact = nil
    S.allowPositioning = false
    S.coverageFrame = nil
    S.coverageNextAt = 0
    S.nextPlanAt = 0

    releaseMove(allowWrite)
end

local function releaseMotionLock(lease)
    if not lease or not lease.lockHeld then
        return true
    end

    local ok, err = pcall(
        M.Movement.UnlockMovement,
        lease.lockName
    )

    ok = ok and err ~= false

    if ok then
        lease.lockHeld = false
        S.ownLockReleases = S.ownLockReleases + 1
        S.retiredLocks[lease.lockName] = nil
    else
        S.retiredLocks[lease.lockName] = lease
        report("OWN LOCK RELEASE", err)
    end

    return ok
end

local function releaseMotionController(lease)
    if not lease or not lease.cancelPending then return true end

    local ok, result = pcall(lease.controller.Cancel)
    if ok and result ~= false then
        lease.cancelPending = false
        S.retiredMotions[lease] = nil
        return true
    end

    S.retiredMotions[lease] = true
    report("OWN MOTION CANCEL", result)
    return false
end

local function finishMotion(cancel, expected)
    local lease = S.motionLease

    if not lease or (expected and lease ~= expected) then
        return false
    end

    S.motionLease = nil

    local active = lease.controller

    if S.controller == active then
        S.controller = nil
    end

    lease.closed = true

    local canceled = true
    if active and cancel then
        lease.cancelPending = true
        canceled = releaseMotionController(lease)
    end

    local unlocked = releaseMotionLock(lease)
    return canceled and unlocked
end

local function serviceOwnedMotion()
    for lease in pairs(S.retiredMotions) do
        if os.clock() >= (lease.cancelRetryAt or 0) then
            lease.cancelRetryAt = os.clock() + 1
            releaseMotionController(lease)
        end
    end

    for _, lease in pairs(S.retiredLocks) do
        if os.clock() >= (lease.retryAt or 0) then
            lease.retryAt = os.clock() + 1
            releaseMotionLock(lease)
        end
    end

    local lease = S.motionLease

    if not lease then return end

    if not lease.root.Parent
        or LocalPlayer.Character ~= lease.character then
        finishMotion(true, lease)
        return
    end

    if lease.controller
        and type(lease.controller.IsActive) == "function" then

        local ok, active = pcall(lease.controller.IsActive)

        if ok and active == false then
            finishMotion(false, lease)
            return
        end
    end

    if os.clock() >= lease.deadline then
        report(
            "OWN MOTION TIMEOUT",
            "Releasing an unfinished automatic dive"
        )

        finishMotion(true, lease)
    end
end

local function manualJumpHeld()
    local ok, held = pcall(function()
        local binding = M.Keybinds.Get("Jump")

        for _, key in ipairs(binding.KeyCodes or {}) do
            for _, linked in ipairs(
                M.Keybinds.GetLinkedKeyCodes(key)
            ) do
                if M.Keybinds.IsGamepadKeyCode(linked) then
                    if UserInputService:IsGamepadButtonDown(
                        Enum.UserInputType.Gamepad1,
                        linked
                    ) then
                        return true
                    end
                elseif UserInputService:IsKeyDown(linked) then
                    return true
                end
            end
        end

        for _, inputType in ipairs(binding.InputTypes or {}) do
            if inputType == Enum.UserInputType.MouseButton1
                or inputType == Enum.UserInputType.MouseButton2
                or inputType == Enum.UserInputType.MouseButton3 then

                if UserInputService:IsMouseButtonPressed(inputType) then
                    return true
                end
            end
        end

        return false
    end)

    if not ok then
        report("JUMP INPUT READ", held)
    end

    return not ok or held == true
end

local function releaseJumpLatch()
    local jump = S.jump
    if jump and jump.latch then
        if not manualJumpHeld() then
            assert(M.Movement.ReleaseJump() ~= false, "Jump latch release was refused")
        end
        jump.latch = false
    end
    return true
end

local function cancelOwnedJumpQueue()
    local queued = S.jump and S.jump.phase == "QUEUED"

    if not queued then
        return false
    end

    if not manualJumpHeld() then
        S.jumpBlockOwned = true

        local ok, err = pcall(
            M.Movement.SetJumpStateBlocked,
            S.moveLock .. ".Queue",
            true
        )

        local released, releaseError = pcall(
            M.Movement.SetJumpStateBlocked,
            S.moveLock .. ".Queue",
            false
        )

        ok = ok and err ~= false
        released = released and releaseError ~= false
        S.jumpBlockOwned = not released

        if not ok then
            report("JUMP QUEUE CANCEL", err)
        end

        if not released then
            report("JUMP QUEUE RELEASE", releaseError)
        end

        assert(ok and released, "Queued jump cancellation was not confirmed")
    end

    releaseJumpLatch()
    S.jump = nil

    if S.pending and S.pending.kind == "JUMP" then
        S.pending = nil
    end

    return true
end

local function authorizedFrame(frame)
    return S.alive
        and Config.Enabled
        and ENV.AUTO_GK_ENABLED
        and S.focused
        and not S.uiBusy
        and frame
        and LocalPlayer.Character == frame.character
        and frame.humanoid.Health > 0
        and M.Match.IsGoalkeeperCharacter(frame.character)
        and os.clock() >= S.manualActionUntil
end

local function blocked(character, root)
    if next(S.retiredMotions) or next(S.retiredLocks) then
        return "OWN CLEANUP PENDING"
    end

    if M.Controllers.IsSuspended(character) then
        return "CONTROLLER SUSPENDED"
    end

    local isRagdolled

    if type(M.Ragdoll.IsLocallyRagdolled) == "function" then
        isRagdolled = M.Ragdoll.IsLocallyRagdolled(LocalPlayer)
    elseif type(M.Ragdoll.IsEnabled) == "function" then
        -- CharacterControllers uses this character-based check in the supplied
        -- game build. Preserve the player-based API on builds that provide it.
        isRagdolled = M.Ragdoll.IsEnabled(character)
    else
        report("RAGDOLL API", "Missing IsLocallyRagdolled / IsEnabled; automatic actions paused")
        return "RAGDOLL CHECK UNAVAILABLE"
    end

    if isRagdolled then
        return "RAGDOLL"
    end

    if M.Freeze.IsFrozen() or M.Replay.IsActive() then
        return "ROUND TRANSITION"
    end

    if M.Slide.IsSlideTackling() then
        return "MANUAL SLIDE"
    end

    if M.Dodge.IsDribbling() then
        return "MANUAL DODGE"
    end

    if M.Dive.IsDiveConstraintActive(root) then
        return "DIVE IN PROGRESS"
    end

    if M.Locks.HasGoalkeeperDiveBlock(
        LocalPlayer,
        M.Renderer.GetVolleyLockUserId()
    ) then
        return "ACTION LOCK"
    end

    if #M.Movement.GetZeroWalkSpeedSources() > 0 then
        return "MOVEMENT LOCK"
    end

    return nil
end

--==============================================================
-- DEFENDED GOAL
--==============================================================

local function contextFor(root, state)
    local goal = M.Practice.GetDefendedGoalPart()
    local mode, team, attack = "PRACTICE", nil, nil

    if not goal then
        team = M.Teams.GetActorTeamName(LocalPlayer)
        if not team then return nil end

        local map = workspace:FindFirstChild("Map")
        local data = map and map:FindFirstChild("Data")
        local home = data and data:FindFirstChild(team)

        local opponent = data and data:FindFirstChild(
            M.Match.GetOpposingTeamName(team)
        )

        goal = home and home:FindFirstChild("Goal")
        attack = opponent and opponent:FindFirstChild("Goal")
        mode = "MATCH"
    end

    if not (goal and goal:IsA("BasePart")) then
        return nil
    end

    local forward

    if attack and attack:IsA("BasePart") then
        forward = unit(attack.Position - goal.Position)
    else
        local cached = S.goalBasis[goal]

        if cached and cached.frame == goal.CFrame then
            forward = cached.forward
        else
            local axis = goal.Size.X < goal.Size.Z * 0.5
                and goal.CFrame.RightVector
                or goal.CFrame.LookVector

            forward = unit(axis)

            local reference = root.Position - goal.Position

            if math.abs(flat(reference):Dot(forward)) < 0.3
                and state
                and state.Position then
                reference = state.Position - goal.Position
            end

            if reference:Dot(forward) < 0 then
                forward = -forward
            end

            if cached and cached.forward:Dot(forward) < 0 then
                forward = -forward
            end

            S.goalBasis[goal] = {
                frame = goal.CFrame,
                forward = forward,
            }
        end
    end

    return {
        goal = goal,
        team = team,
        mode = mode,
        forward = forward,
        right = Vector3.new(-forward.Z, 0, forward.X),
    }
end

local function goalHalfWidth(context)
    local goal = context.goal
    local frame, size, axis =
        goal.CFrame, goal.Size, context.right

    return math.max(0.5, (
        math.abs(frame.RightVector:Dot(axis)) * size.X
        + math.abs(frame.UpVector:Dot(axis)) * size.Y
        + math.abs(frame.LookVector:Dot(axis)) * size.Z
    ) * 0.5)
end

--==============================================================
-- BALL SNAPSHOT
--==============================================================

local function readBall()
    local ballId = M.Renderer.GetMatchBallId()
    local owner = M.Renderer.GetOwnedUserId()

    if owner ~= nil then
        return {
            phase = "OWNED",
            ballId = ballId,
            owner = owner,
        }
    end

    local state, world = M.Renderer.GetAuthoritativeMovementState()

    if not state or not world then
        local source = M.Renderer.GetTerminalVisualSourceKind()

        return {
            phase = "UNAVAILABLE",
            ballId = ballId,
            source = source,
        }
    end

    if not finiteVector(state.Position)
        or not finiteVector(state.Velocity) then
        return {
            phase = "INVALID",
            ballId = ballId,
        }
    end

    return {
        phase = state.VolleyUserId and "VOLLEY" or "MOVEMENT",
        state = state,
        world = world,
        ballId = ballId,

        flightKey = tostring(ballId)
            .. ":"
            .. (finite(state.FlightStartedAt)
                and ("flight:" .. tostring(state.FlightStartedAt))
                or finite(state.ActionId) and ("action:" .. tostring(state.ActionId))
                or ("legacy:" .. tostring(state.StartedAt))),
    }
end

local function unavailableStatus(ball, context)
    local mode = context and context.mode or "CLIENT"

    if ball.phase == "OWNED" then
        S.missingSince = nil

        S.ballInfo = ball.owner == LocalPlayer.UserId
            and "Held by you"
            or "Held by another actor"

        status(
            "READY / " .. mode,
            "Ball: " .. S.ballInfo .. "; positioning paused"
        )

    elseif ball.phase == "VOLLEY" then
        S.missingSince = nil
        S.ballInfo = "Volley locked"

        status("VOLLEY LOCK / " .. mode, "No automatic action")

    else
        S.missingSince = S.missingSince or os.clock()

        S.ballInfo = ball.phase == "INVALID"
            and "Invalid trajectory"
            or "No movement trajectory"

        if os.clock() - S.missingSince
            >= Config.MissingStateDisplayDelay then

            status(
                "NO BALL STATE / " .. mode,
                S.ballInfo .. "; actions paused"
            )
        else
            status(
                "READY / " .. mode,
                "Ball state transition; actions paused"
            )
        end
    end
end

-- Renderer advances/rebases position, velocity and timestamps while drawing.
-- These scalar identifiers are explicitly preserved by its sampleStateAtTime.
-- Actual Movement events remain the fallback when identifiers are unavailable.
local function trajectoryStamp(state)
    if not state or not finiteVector(state.Position) or not finiteVector(state.Velocity) then
        return nil
    end
    return {
        movementSequence = finite(state.MovementSequence) and state.MovementSequence or nil,
        actionId = finite(state.ActionId) and state.ActionId or nil,
        flightStartedAt = finite(state.FlightStartedAt) and state.FlightStartedAt or nil,
        radius = finite(state.Radius) and state.Radius or nil,
        blockedGoalTeam = state.BlockedGoalTeamName,
    }
end

local function sameTrajectory(a, b)
    if a == b then return true end
    if not a or not b then return false end
    return a.movementSequence == b.movementSequence
        and a.actionId == b.actionId
        and a.flightStartedAt == b.flightStartedAt
        and a.radius == b.radius
        and a.blockedGoalTeam == b.blockedGoalTeam
end

local function trajectoryChanged(frame, ball)
    local before, state = frame.sourceTrajectory, ball.state
    if not before or not state then return false end
    if not finiteVector(state.Position) or not finiteVector(state.Velocity) then return true end
    local sequence = finite(state.MovementSequence) and state.MovementSequence or nil
    local actionId = finite(state.ActionId) and state.ActionId or nil
    local flightStartedAt = finite(state.FlightStartedAt) and state.FlightStartedAt or nil
    local radius = finite(state.Radius) and state.Radius or nil
    return before.movementSequence ~= sequence or before.actionId ~= actionId
        or before.flightStartedAt ~= flightStartedAt
        or before.radius ~= radius or before.blockedGoalTeam ~= state.BlockedGoalTeamName
end

local function plannerSetting(value, fallback, low, high)
    return math.clamp(finite(value) and value or fallback, low, high)
end

local function plannerDeadline(frame)
    -- Match the original cadence from snapshot completion. Modelled launch
    -- deadlines still belong to the time at which that snapshot was read.
    local anchor = frame.plannerAnchor or frame.readClock
    local normalHz = plannerSetting(Config.PlannerHz, 12, 1, 120)
    local urgentHz = math.max(normalHz, plannerSetting(Config.CloseShotPlannerHz, 30, 1, 120))
    local urgentWindow = plannerSetting(Config.UrgentShotSeconds, 0.55, 0.01, 2)
    local hz = finite(frame.eta) and frame.eta <= urgentWindow and urgentHz or normalHz
    local deadline = anchor + 1 / hz
    if finite(frame.launchAt) then deadline = math.min(deadline, frame.launchAt) end
    return deadline
end

local function trackPlanWindow(frame, plan)
    frame.launchAt = plan and plan.kind == "DIVE" and finite(plan.delay)
        and plan.delay > 0 and frame.readClock + plan.delay or nil
end

local function snapshot(character, root, humanoid)
    local readClock = os.clock()
    local ball = readBall()

    if ball.phase ~= "MOVEMENT" then
        return nil, ball.phase, ball
    end

    local state, world = ball.state, ball.world
    local sourceTrajectory = trajectoryStamp(state)
    local context = contextFor(root, state)

    if not context then
        return nil, "WAITING FOR TEAM / GOAL"
    end

    local timestamp = now()

    if not finite(timestamp) then
        return nil, "CLOCK UNAVAILABLE"
    end

    if finite(state.UpdatedAt)
        and state.UpdatedAt > timestamp + 0.10 then
        return nil, "WAITING FOR STATE TIME"
    end

    if finite(state.UpdatedAt) then
        timestamp = math.max(timestamp, state.UpdatedAt)
    end

    local current = M.Physics.GetStateAtTime(
        state,
        timestamp,
        world,
        {}
    )

    if typeof(current) ~= "table"
        or not finiteVector(current.Position)
        or not finiteVector(current.Velocity) then
        return nil, "INVALID PREDICTED STATE"
    end

    local radius = current.Radius or M.Physics.BallRadius

    if not finite(radius) or radius <= 0 then
        return nil, "INVALID BALL RADIUS"
    end

    local position, crossingTime

    if not (
        context.team
        and state.BlockedGoalTeamName == context.team
        and type(M.Match.AreOwnGoalsEnabled) == "function"
        and not M.Match.AreOwnGoalsEnabled()
    ) then
        position, crossingTime = M.Prediction.GetGoalCrossing(
            current,
            world,
            context.goal,
            timestamp,
            M.Prediction.Constants.GoalCrossingMaximumPredictionSeconds
        )
    end

    if position ~= nil
        and (not finiteVector(position) or not finite(crossingTime)) then
        return nil, "INVALID GOAL CROSSING"
    end

    local landed = M.Controllers.IsLanded(character, humanoid)
    local humanoidState = M.Controllers.GetHumanoidState(character, humanoid)
    local receiveAirborne = humanoidState == Enum.HumanoidStateType.Jumping
        or humanoidState == Enum.HumanoidStateType.Freefall
    local floorY = M.Grounding.GetStandingY(humanoid, root)

    if not finite(floorY) then
        floorY = root.Position.Y
    end

    local jumpSpeed = humanoid.UseJumpPower
        and humanoid.JumpPower
        or math.sqrt(math.max(
            0,
            2 * workspace.Gravity * humanoid.JumpHeight
        ))

    local movementVelocity = flat(
        M.Controllers.GetLocomotionVelocity(character, humanoid)
    )

    return {
        character = character,
        root = root,
        humanoid = humanoid,
        rootCF = root.CFrame,
        velocity = root.AssemblyLinearVelocity,
        movementVelocity = movementVelocity,
        floorY = floorY,
        landed = landed,
        receiveAirborne = receiveAirborne,
        jumpSpeed = jumpSpeed,
        gravity = workspace.Gravity,
        state = current,
        world = world,
        at = timestamp,
        readClock = readClock,
        sourceTrajectory = sourceTrajectory,
        lastKickerUserId = state.LastKickerUserId,
        launchAt = nil,
        context = context,
        ballId = ball.ballId,
        flightKey = ball.flightKey,
        goalPosition = position,
        goalTime = crossingTime,

        eta = position
            and finite(crossingTime)
            and crossingTime - timestamp
            or nil,

        radius = radius,
    }
end

--==============================================================
-- TRAJECTORY MODELS
--==============================================================

local function naturalRoot(f, t)
    local dy = 0

    if not f.landed then
        dy = math.max(
            f.floorY - f.rootCF.Position.Y,
            f.velocity.Y * t - 0.5 * f.gravity * t * t
        )
    end

    return f.rootCF
        + f.movementVelocity * t
        + Vector3.new(0, dy, 0)
end

-- Use the same ballistic/floor model as naturalRoot to end airborne receiving.
-- The actual native state is read again on every fresh snapshot.
local function holdLandingTime(f)
    if not f.receiveAirborne then return 0 end

    local height = math.max(0, f.rootCF.Position.Y - f.floorY)
    local velocity = f.velocity.Y

    if f.gravity > 0 then
        local speed = math.sqrt(velocity * velocity + 2 * f.gravity * height)

        -- Avoid subtracting nearly equal values on a fast downward approach.
        if velocity < 0 then
            return 2 * height / (speed - velocity)
        end

        return (velocity + speed) / f.gravity
    end

    return velocity < 0 and height / -velocity or math.huge
end

local function jumpedRoot(f, t, queueDelay)
    local elapsed = math.max(0, t - queueDelay)

    local rise = math.max(
        0,
        f.jumpSpeed * elapsed
            - 0.5 * f.gravity * elapsed * elapsed
    )

    return f.rootCF
        + f.movementVelocity * t
        + Vector3.new(0, rise, 0)
end

local function diveRoot(f, plan, t)
    local elapsed = math.max(0, t - plan.delay)
    local assist = plan.assist

    local distance = M.Dive.Constants.Distance
        + (assist and assist.ExtraDistance or 0)

    local scale = assist and assist.TravelScale or 1

    local vertical = assist
        and assist.InitialVerticalVelocity
        or M.Dive.Constants.InitialVerticalVelocity

    local gravity = assist
        and assist.Gravity
        or M.Dive.Constants.GravityStudsPerSecondSquared

    local direction = plan.direction

    if assist and assist.YawRadians ~= 0 then
        direction = M.Dive.RotateFlatDirection(
            direction,
            assist.YawRadians
        )
    end

    local travel = M.Dive.GetTravel(elapsed * scale, distance)

    local rise = vertical * elapsed
        + 0.5 * gravity * elapsed * elapsed

    rise = math.max(
        f.floorY - plan.origin.Position.Y,
        rise
    )

    return plan.origin
        + direction * travel
        + Vector3.new(0, rise, 0)
end

local function rootAt(f, plan, t)
    if plan.kind == "HOLD" then
        return naturalRoot(f, t)
    end

    if plan.kind == "JUMP" then
        return jumpedRoot(f, t, plan.queueDelay)
    end

    return diveRoot(f, plan, t)
end

local function sampleFlight(f, horizon)
    local points = {
        { t = 0, p = f.state.Position },
    }

    if not finite(horizon) or horizon <= 0 then
        return points
    end

    local step = math.clamp(
        Config.SampleStep,
        0.0025,
        0.025
    )

    if f.eta and f.eta <= Config.UrgentShotSeconds then
        step = math.min(step, 0.005)
    end

    local a, b, state = {}, {}, f.state
    local settled = false
    local t = 0

    while t < horizon - 0.000001 do
        t = math.min(horizon, t + step)

        if not settled then
            local output = state == a and b or a

            state = M.Physics.GetStateAtTime(
                state,
                f.at + t,
                f.world,
                output
            )

            -- Match native FlightSampling: only freeze positions after the
            -- physics module confirms support/boundary conditions are settled.
            settled = state.Mode == "Resting"
                and type(M.Physics.IsStateSettled) == "function"
                and M.Physics.IsStateSettled(state, f.world)
        end

        points[#points + 1] = {
            t = t,
            p = state.Position,
        }
    end

    return points
end

local function paddedBox(source, amount)
    return {
        Size = source.Size
            + Vector3.new(amount, amount, amount),

        CFrameOffset = source.CFrameOffset,
        Shape = source.Shape,
    }
end

local function receiveBox(f, plan, airborne)
    if plan.kind == "HOLD" then
        return M.Hitboxes.ExtendToFeet(
            airborne and M.Hitboxes.AirReceive or M.Hitboxes.Receive,
            f.humanoid,
            f.root
        )
    end

    if plan.kind == "JUMP" then
        return paddedBox(
            M.Hitboxes.AirReceive,
            f.radius * 2
        )
    end

    local padding = math.max(
        M.Contacts.Constants.ContactPadding or 1.25,
        f.radius * 2
    )

    return paddedBox(M.Hitboxes.AirReceive, padding)
end

--==============================================================
-- THREE-DIMENSIONAL CONTACT VALIDATION
--==============================================================

-- Enclose both the ranking box and the native contact box in world axes.
-- diveRoot only translates plan.origin, so these extents stay valid throughout
-- this single inspection, including assisted yaw/travel and a tilted root.
-- This rejects impossible work only; possible contacts still use the native API.
local function diveContactBounds(f, plan)
    local box = M.Hitboxes.AirReceive
    local padding = M.Contacts.Constants.ContactPadding or 1.25
    if not box or not finiteVector(box.Size)
        or box.Size.X <= 0 or box.Size.Y <= 0 or box.Size.Z <= 0
        or not finite(padding) or padding < 0
        or not finite(f.radius) or f.radius <= 0
        or typeof(box.CFrameOffset) ~= "CFrame"
        or not finiteVector(box.CFrameOffset.Position)
        or typeof(plan.origin) ~= "CFrame"
        or not finiteVector(plan.origin.Position) then
        return nil, nil
    end

    padding = math.max(1.25, padding, f.radius * 2)
    local half = (box.Size + Vector3.new(padding, padding, padding)) * 0.5
    local basis = plan.origin * box.CFrameOffset
    local right, up, look = basis.RightVector, basis.UpVector, basis.LookVector
    local offset = plan.origin:VectorToWorldSpace(box.CFrameOffset.Position)
    if not finiteVector(right) or not finiteVector(up)
        or not finiteVector(look) or not finiteVector(offset) then
        return nil, nil
    end

    -- Expand for native floating-point arithmetic, especially far from origin.
    local p = plan.origin.Position
    local margin = 0.01 + math.max(math.abs(p.X), math.abs(p.Y), math.abs(p.Z)) * 0.000001
    local extent = Vector3.new(
        math.abs(right.X) * half.X + math.abs(up.X) * half.Y + math.abs(look.X) * half.Z + margin,
        math.abs(right.Y) * half.X + math.abs(up.Y) * half.Y + math.abs(look.Y) * half.Z + margin,
        math.abs(right.Z) * half.X + math.abs(up.Z) * half.Y + math.abs(look.Z) * half.Z + margin
    )
    if not finiteVector(extent) then return nil, nil end
    return offset, extent
end

local function inspectPath(f, plan, points, requireContact)
    local first =
        (plan.kind == "DIVE" or plan.kind == "JUMP_DIVE")
            and plan.delay
        or (
            plan.kind == "JUMP"
                and plan.queueDelay + Config.SampleStep
                or 0
        )

    local last = math.min(
        f.eta - Config.GoalMarginSeconds,

        (plan.kind == "DIVE" or plan.kind == "JUMP_DIVE")
            and plan.delay + M.Dive.Constants.HitboxCurveSeconds
            or Config.PredictionHorizon
    )

    if plan.kind == "JUMP" and f.gravity > 0 then
        last = math.min(
            last,
            plan.queueDelay + 2 * f.jumpSpeed / f.gravity
        )
    end

    if last <= first then return nil end

    local groundBox = receiveBox(f, plan)
    local landingAt = plan.kind == "HOLD" and holdLandingTime(f) or 0
    local airBox = landingAt > 0 and receiveBox(f, plan, true) or nil
    local contact, nearest, deepest = nil, math.huge, 0
    local previousRoot, previousTime
    local isDive = plan.kind == "DIVE" or plan.kind == "JUMP_DIVE"
    local boundOffset, boundExtent
    local contactOptions
    if isDive then
        boundOffset, boundExtent = diveContactBounds(f, plan)
        -- The native checker only reads these options; reuse them within this call.
        contactOptions = { BallRadius = f.radius }
    end

    for i = 2, #points do
        local left, right = points[i - 1], points[i]

        if right.t > first and left.t < last then
            local t0 = math.max(first, left.t)
            local stop = math.min(last, right.t)

            while t0 < stop do
                local airborne = airBox ~= nil and t0 < landingAt
                local t1 = airborne and math.min(stop, landingAt) or stop
                local box = airborne and airBox or groundBox
                -- Split a segment at landing so the tall airborne box cannot
                -- authorize a HOLD after the standing receive box takes over.
                local width = right.t - left.t

                local p0 = left.p:Lerp(
                    right.p,
                    (t0 - left.t) / width
                )

                local p1 = left.p:Lerp(
                    right.p,
                    (t1 - left.t) / width
                )

                local r0 = previousTime == t0 and previousRoot or rootAt(f, plan, t0)
                local r1 = rootAt(f, plan, t1)
                previousRoot, previousTime = r1, t1
                local relativeHeight = p1.Y - r1.Position.Y
                local relativeEnd
                local measureMiss = true
                -- Distance to an enclosing box is a lower bound on miss distance.
                -- Keep the exact native miss/clearance calculation whenever it
                -- could improve the ranking, including every near/interior point.
                if boundExtent and boundOffset then
                    relativeEnd = p1 - r1.Position - boundOffset
                    local dx = math.max(math.abs(relativeEnd.X) - boundExtent.X, 0)
                    local dy = math.max(math.abs(relativeEnd.Y) - boundExtent.Y, 0)
                    local dz = math.max(math.abs(relativeEnd.Z) - boundExtent.Z, 0)
                    local threshold = math.max(nearest, 0.0001)
                    measureMiss = not (dx * dx + dy * dy + dz * dz > threshold * threshold)
                end

                if measureMiss and (not isDive
                    or relativeHeight
                        <= M.Dive.Constants.MaximumSaveHeight) then

                    local miss, localPoint =
                        M.Hitboxes.GetMissVector(
                            r1 * box.CFrameOffset,
                            box,
                            p1
                        )

                    nearest = math.min(nearest, miss.Magnitude)

                    if miss.Magnitude < 0.0001 then
                        local h = box.Size * 0.5

                        local radial = math.sqrt(
                            (localPoint.X / h.X) ^ 2
                            + (localPoint.Z / h.Z) ^ 2
                        )

                        deepest = math.max(
                            deepest,
                            1 - math.max(
                                radial,
                                math.abs(localPoint.Y / h.Y)
                            )
                        )
                    end
                end

                local alpha

                if isDive then
                    -- Later segments cannot improve an already earlier contact.
                    -- Continue measuring clearance above: it still affects ranking.
                    local possible = not contact or t0 < contact
                    if possible and boundExtent and boundOffset and relativeEnd then
                        local a = p0 - r0.Position - boundOffset
                        local b, h = relativeEnd, boundExtent
                        -- Test the entire swept segment, not just its endpoints
                        -- individually. Opposite-side endpoints can cross the box.
                        possible = not (
                            (a.X > h.X and b.X > h.X) or (a.X < -h.X and b.X < -h.X)
                            or (a.Y > h.Y and b.Y > h.Y) or (a.Y < -h.Y and b.Y < -h.Y)
                            or (a.Z > h.Z and b.Z > h.Z) or (a.Z < -h.Z and b.Z < -h.Z)
                        )
                    end
                    if possible and contactOptions then
                        contactOptions.StartRootCFrame = r0
                        contactOptions.EndRootCFrame = r1
                        local hit = M.Contacts.FindDiveSaveContact(
                            LocalPlayer,
                            p0,
                            p1,
                            contactOptions
                        )
                        alpha = hit and hit.Alpha
                    end
                else
                    alpha = M.Hitboxes.GetSegmentEnterAlpha(
                        { CFrame = r1 },
                        box,
                        p0 + r1.Position - r0.Position,
                        p1
                    )
                end

                if finite(alpha) and alpha >= 0 and alpha <= 1 then
                    local time = t0 + (t1 - t0) * alpha

                    if (not airborne or time < landingAt)
                        and time < f.eta
                            - Config.GoalMarginSeconds
                            - 0.000001 then

                        contact = contact
                            and math.min(contact, time)
                            or time

                        nearest = 0
                    end
                end

                t0 = t1
            end
        end

        if right.t >= last then
            break
        end
    end

    if requireContact and not contact then
        return nil
    end

    if nearest == math.huge then
        return nil
    end

    return {
        time = contact,
        miss = nearest,
        clearance = math.max(0, deepest),
    }
end

local function allowedDirections(f)
    local filter = Config.DiveFilter
    local result

    if filter == "FORWARD" then
        result = { "F" }
    elseif filter == "LEFT" then
        result = { "L", "LF" }
    elseif filter == "RIGHT" then
        result = { "R", "RF" }
    elseif filter == "SIDES" then
        result = { "L", "R", "LF", "RF" }
    else
        result = { "F", "L", "R", "LF", "RF" }
    end

    if Config.BackwardRecovery
        and (filter == "SMART" or filter == "ALL") then

        local passed =
            (f.state.Position - f.rootCF.Position)
                :Dot(f.context.forward) < -1

        local high =
            f.state.Position.Y - f.rootCF.Position.Y
                > M.Hitboxes.AirReceive.Size.Y * 0.5

        if passed
            or high
            or (f.eta and f.eta <= Config.UrgentShotSeconds) then

            table.insert(result, "B")
            table.insert(result, "LB")
            table.insert(result, "RB")
        end
    end

    return result
end

local function makeDive(f, kind, delay, name)
    local basis = CFrame.lookAt(
        f.rootCF.Position,
        f.rootCF.Position + f.context.forward
    )

    local choice = M.Dive.GetDirectionChoiceByName(name)

    local origin = kind == "JUMP_DIVE"
        and jumpedRoot(f, delay, S.queueEstimate)
        or naturalRoot(f, delay)

    return {
        kind = kind,
        delay = delay,
        name = name,
        choice = choice,

        direction = M.Dive.GetWorldDirection(
            choice,
            basis,
            f.context.forward
        ),

        origin = origin,
        basis = basis,
        queueDelay = S.queueEstimate,
    }
end

local function actionCost(plan, hit)
    if plan.kind == "HOLD" then
        return -10
    end

    local cost = plan.kind == "JUMP_DIVE"
        and 2
        or (plan.kind == "JUMP" and 0.9 or 1)

    if plan.name == "B"
        or plan.name == "LB"
        or plan.name == "RB" then
        cost = cost + 0.18
    end

    return cost
        + plan.delay * 0.8
        - hit.clearance * 0.7
        + hit.time * 0.05
end

local function prepareAssist(f, plan)
    local proxy = {
        CFrame = plan.origin,
        Position = plan.origin.Position,
    }

    local assist = M.Assist.GetAssist(
        f.state,
        f.world,
        proxy,
        plan.direction,
        f.at + plan.delay
    )

    if not assist then return nil end

    assist = table.clone(assist)

    if plan.kind == "DIVE" and plan.delay == 0 then
        M.Assist.DropBlockedLaunchYaw(
            f.root,
            plan.direction,
            assist
        )
    end

    return assist
end

local function evaluateDive(f, kind, delay, name, points, prepared)
    local base = prepared or makeDive(f, kind, delay, name)
    base.useAssist = false

    local hit
    if prepared then
        -- The ranking pass already ran the identical native contact checks on
        -- this unassisted plan and snapshot. Its miss-only result isn't a catch.
        hit = base.rawContact
        base.rawContact = nil
        if hit and not hit.time then hit = nil end
    else
        hit = inspectPath(f, base, points, true)
    end
    local best

    if hit then
        base.contact = hit
        base.score = actionCost(base, hit)
        best = base
    end

    local assist = prepareAssist(f, base)

    if assist then
        local corrected = table.clone(base)

        corrected.assist = assist
        corrected.useAssist = true

        local correctedHit = inspectPath(
            f,
            corrected,
            points,
            true
        )

        if correctedHit then
            corrected.contact = correctedHit
            corrected.score = actionCost(corrected, correctedHit)

            if not best
                or corrected.score < best.score - 0.001 then
                best = corrected
            end
        end
    end

    return best
end

local function choosePlan(candidates)
    table.sort(candidates, function(a, b)
        if a.score ~= b.score then
            return a.score < b.score
        end

        if a.contact.time ~= b.contact.time then
            return a.contact.time < b.contact.time
        end

        return tostring(a.name or a.kind)
            < tostring(b.name or b.kind)
    end)

    return candidates[1]
end

-- A broad bound for every dive direction/delay in this search. It encloses
-- full assisted travel, the rotated contact box, and pre-launch locomotion.
-- The bounds include ALL sampled segments; being outside the goal area alone
-- never disables a save. Missing/invalid bounds fall back to the full search.
local function divePathMayReach(f, points, horizon)
    local assist = M.Assist and M.Assist.Constants
    local dive = M.Dive.Constants
    local box = M.Hitboxes.AirReceive
    local extra = assist and assist.MaximumExtraReachStuds
    local distance = dive and dive.Distance
    local padding = M.Contacts.Constants.ContactPadding or 1.25

    if not finite(extra) or extra < 0
        or not finite(distance) or distance < 0
        or not finite(padding) or padding < 0
        or not finite(f.radius) or f.radius <= 0
        or not finite(horizon) or horizon <= 0
        or not finiteVector(f.rootCF.Position)
        or not finiteVector(f.movementVelocity)
        or not box or not finiteVector(box.Size)
        or box.Size.X <= 0 or box.Size.Y <= 0 or box.Size.Z <= 0
        or typeof(box.CFrameOffset) ~= "CFrame"
        or not finiteVector(box.CFrameOffset.Position)
        or #points < 2 then
        return true
    end

    -- Include native contact's minimum padding as well as this build's setting.
    padding = math.max(1.25, padding, f.radius * 2)
    local contactSize = box.Size + Vector3.new(padding, padding, padding)
    local reach = distance + extra + contactSize.Magnitude * 0.5
        + box.CFrameOffset.Position.Magnitude + 0.05
    local start = f.rootCF.Position
    local finish = start + f.movementVelocity * horizon
    if not finite(reach) or not finiteVector(finish) then return true end

    local minX, maxX = math.huge, -math.huge
    local minZ, maxZ = math.huge, -math.huge
    for _, point in ipairs(points) do
        local p = point.p
        if not finiteVector(p) then return true end
        minX, maxX = math.min(minX, p.X), math.max(maxX, p.X)
        minZ, maxZ = math.min(minZ, p.Z), math.max(maxZ, p.Z)
    end

    -- Every line segment lies inside its endpoints' combined bounding box.
    -- Ignore height to retain high balls, airborne saves and landing recovery.
    return not (maxX < math.min(start.X, finish.X) - reach
        or minX > math.max(start.X, finish.X) + reach
        or maxZ < math.min(start.Z, finish.Z) - reach
        or minZ > math.max(start.Z, finish.Z) + reach)
end

-- Receiver/blocker forecasts only postpone an already verified dive. They
-- never suppress a goal-bound ball or authorize a contact on a guessed bounce.
local KeeperTiming = {
    ForecastSeconds = 0.35,
    LaunchReserveSeconds = 0.10,
    ContactOrderMarginSeconds = 0.035,
    MinimumWaitSeconds = 0.015,
    UrgentGoalSeconds = 0.25,
    Delays = { 0.05, 0.10, 0.15, 0.20, 0.25, 0.30, 0.40, 0.50 },
}

function KeeperTiming.RootAt(body, t)
    local dy = body.airborne and math.max(body.floor - body.cf.Position.Y,
        body.velocity.Y * t - 0.5 * body.gravity * t * t) or 0
    return body.cf + body.horizontal * t + Vector3.new(0, dy, 0)
end

function KeeperTiming.PlayerContact(f, character, actor, points, limit)
    if character == f.character or not character.Parent
        or M.Motion.GetContext(character) ~= M.Motion.GetContext(f.character) then return nil end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = type(M.Motion.GetQueryRoot) == "function" and M.Motion.GetQueryRoot(character)
        or character:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health <= 0 or not root or not root.Parent then return nil end
    local cf = M.Motion.GetCFrame(character)
    local velocity = M.Motion.GetVelocity(character) or root.AssemblyLinearVelocity
    if typeof(cf) ~= "CFrame" or not finiteVector(cf.Position)
        or not finiteVector(velocity) then return nil end
    local state = M.Controllers.GetHumanoidState(character, humanoid)
    local airborne = state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall
    local floor = M.Grounding.GetStandingY(humanoid, root)
    if not finite(floor) then floor = cf.Position.Y end
    local body = { cf = cf, velocity = velocity, horizontal = flat(velocity),
        floor = floor, airborne = airborne, gravity = math.max(0, f.gravity) }
    local landing = airborne and holdLandingTime({ receiveAirborne = true,
        rootCF = cf, velocity = velocity, floorY = floor, gravity = body.gravity }) or 0
    -- Match Receiving.GetReceiveHitbox, including the transition at landing.
    -- Use its exact oval, without inflating proximity into a predicted touch.
    local groundBox = M.Hitboxes.ExtendToFeet(M.Hitboxes.Receive, humanoid, root)
    local airBox = airborne and M.Hitboxes.ExtendToFeet(M.Hitboxes.AirReceive, humanoid, root) or nil
    local initialBox = airBox or groundBox
    actor = actor or M.Actors.GetFromCharacter(character)
    local kicker = actor and finite(actor.UserId) and actor.UserId == f.lastKickerUserId
    local leavingKicker = kicker and M.Hitboxes.ContainsPoint({ CFrame = cf }, initialBox, points[1].p)

    -- Reject distant bodies before running native swept-oval intersection.
    local reach = initialBox.Size.Magnitude * 0.5 + initialBox.CFrameOffset.Position.Magnitude
    local endRoot = KeeperTiming.RootAt(body, limit).Position
    local lowX, highX = math.min(cf.Position.X, endRoot.X) - reach, math.max(cf.Position.X, endRoot.X) + reach
    local lowZ, highZ = math.min(cf.Position.Z, endRoot.Z) - reach, math.max(cf.Position.Z, endRoot.Z) + reach
    local possible = false
    for i = 2, #points do
        local a, b = points[i - 1], points[i]
        if a.t >= limit then break end
        if math.max(a.p.X, b.p.X) >= lowX and math.min(a.p.X, b.p.X) <= highX
            and math.max(a.p.Z, b.p.Z) >= lowZ and math.min(a.p.Z, b.p.Z) <= highZ then
            possible = true; break
        end
    end
    if not possible then return nil end

    for i = 2, #points do
        local left, right = points[i - 1], points[i]
        if left.t >= limit then break end
        local start, stop = left.t, math.min(limit, right.t)
        while start < stop do
            local inAir = airBox ~= nil and start < landing
            local finish = inAir and math.min(stop, landing) or stop
            local box = inAir and airBox or groundBox
            local width = right.t - left.t
            local a = left.p:Lerp(right.p, (start - left.t) / width)
            local b = left.p:Lerp(right.p, (finish - left.t) / width)
            local r0, r1 = KeeperTiming.RootAt(body, start), KeeperTiming.RootAt(body, finish)
            if leavingKicker then
                -- The ball leaving its shooter is not a future reception.
                -- A later re-entry after it leaves the oval is still checked.
                leavingKicker = M.Hitboxes.ContainsPoint({ CFrame = r1 }, box, b)
            else
                local alpha = M.Hitboxes.GetSegmentEnterAlpha({ CFrame = r1 }, box,
                    a + r1.Position - r0.Position, b)
                if finite(alpha) and alpha >= 0 and alpha <= 1 then
                    local time = start + (finish - start) * alpha
                    if time < limit and (not inAir or time < landing) then
                        return { character = character, time = time }
                    end
                end
            end
            start = finish
        end
    end
    return nil
end

function KeeperTiming.FindContact(f, plan, points)
    local limit = math.min(KeeperTiming.ForecastSeconds,
        plan.contact.time - KeeperTiming.ContactOrderMarginSeconds,
        f.eta - Config.GoalMarginSeconds)
    if limit <= 0 or M.Motion.GetContext(f.character) == nil then return nil end
    local seen, best = {}, nil
    local function add(character, actor)
        if not character or character == f.character or seen[character] then return end
        seen[character] = true
        -- A missing/incompatible opponent rig cannot disable goalkeeper saves.
        local ok, hit = pcall(KeeperTiming.PlayerContact, f, character, actor, points,
            best and math.min(limit, best.time) or limit)
        if ok and hit then best = hit
        elseif not ok then
            S.keeperTimingErrors = (S.keeperTimingErrors or 0) + 1
            S.keeperTimingError = tostring(hit)
        end
    end
    for _, player in ipairs(Players:GetPlayers()) do add(player.Character, player) end
    local characters = workspace:FindFirstChild("Characters")
    local function addChildren(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Model") then add(child) end
        end
    end
    addChildren(characters)
    addChildren(characters and characters:FindFirstChild("Players"))
    addChildren(characters and characters:FindFirstChild("NPCs"))
    return best
end

function KeeperTiming.SameWindow(f, window)
    return window and window.character == f.character and window.root == f.root
        and window.ballId == f.ballId and window.flightKey == f.flightKey and window.world == f.world
        and window.goal == f.context.goal and window.team == f.context.team
        and sameTrajectory(window.trajectory, f.sourceTrajectory)
end

function KeeperTiming.Refine(f, immediate, points)
    if not KeeperTiming.SameWindow(f, S.keeperWait) then S.keeperWait = nil end
    S.keeperContact = nil
    if not immediate or immediate.kind ~= "DIVE" or immediate.delay ~= 0 then return immediate end
    local reserve = KeeperTiming.LaunchReserveSeconds
    local clock = math.max(f.readClock, os.clock())
    if f.eta <= KeeperTiming.UrgentGoalSeconds or immediate.contact.time <= reserve
        or (S.keeperWait and clock >= S.keeperWait.deadline - KeeperTiming.MinimumWaitSeconds) then
        return immediate
    end
    local hit = KeeperTiming.FindContact(f, immediate, points)
    S.keeperContact = hit
    if not hit then return immediate end

    -- Compare actual native contact paths. Do not infer that reachability is
    -- monotonic: curves and airborne contacts can have separate valid windows.
    local latest, candidates = nil, {}
    local minimumClearance = math.min(0.12, immediate.contact.clearance)
    for _, delay in ipairs(KeeperTiming.Delays) do
        if delay < f.eta - Config.GoalMarginSeconds - reserve then
            S.delayedPlansChecked = (S.delayedPlansChecked or 0) + 1
            local candidate = evaluateDive(f, "DIVE", delay, immediate.name, points)
            if candidate and candidate.contact.clearance >= minimumClearance then
                candidates[#candidates + 1] = candidate
                latest = candidate
            end
        end
    end
    if not latest then return immediate end
    local safeDelay = latest.delay - reserve
    if S.keeperWait then safeDelay = math.min(safeDelay, S.keeperWait.deadline - f.readClock) end
    if safeDelay <= KeeperTiming.MinimumWaitSeconds or safeDelay <= clock - f.readClock then return immediate end

    -- Validate the reserved launch itself; an earlier launch is not necessarily
    -- valid just because a later launch was. Fall back to another verified path.
    S.delayedPlansChecked = (S.delayedPlansChecked or 0) + 1
    local selected = evaluateDive(f, "DIVE", safeDelay, immediate.name, points)
    if not selected or selected.contact.clearance < minimumClearance then
        selected = nil
        for i = #candidates, 1, -1 do
            if candidates[i].delay <= safeDelay + 0.000001 then selected = candidates[i]; break end
        end
    end
    if not selected or selected.delay <= KeeperTiming.MinimumWaitSeconds
        or selected.delay <= clock - f.readClock then return immediate end

    local deadline = f.readClock + selected.delay
    if deadline <= os.clock() + KeeperTiming.MinimumWaitSeconds then return immediate end
    if not S.keeperWait then
        S.keeperWait = { character = f.character, root = f.root, ballId = f.ballId,
            flightKey = f.flightKey, world = f.world, goal = f.context.goal, team = f.context.team,
            trajectory = f.sourceTrajectory, deadline = deadline }
        S.keeperWaits = (S.keeperWaits or 0) + 1
    else
        -- The deadline may tighten, but never slides later on repeated samples.
        S.keeperWait.deadline = math.min(S.keeperWait.deadline, deadline)
    end
    selected.waitForContact = true
    return selected
end

function KeeperTiming.Protect(f, plan, points)
    local ok, result = pcall(KeeperTiming.Refine, f, plan, points)
    if ok then return result end
    S.keeperTimingErrors = (S.keeperTimingErrors or 0) + 1
    S.keeperTimingError = tostring(result)
    return plan
end

local function planSave(f)
    local began = os.clock()

    S.immediatePlansChecked = 0
    S.delayedPlansChecked = 0

    local function finish(plan, reason)
        S.plannerMilliseconds = (os.clock() - began) * 1000

        S.lastPlanReason = reason
            or (plan and plan.kind)
            or "NO PRE-GOAL CONTACT"

        return plan, reason
    end

    local horizon = math.min(
        Config.PredictionHorizon,
        f.eta - Config.GoalMarginSeconds
    )

    if horizon <= 0.0001 then
        return finish(nil, "TOO LATE")
    end

    local points = sampleFlight(f, horizon)
    local hold = { kind = "HOLD", delay = 0 }
    local holdFrame = f

    if S.ownedMove then
        holdFrame = table.clone(f)
        holdFrame.movementVelocity = Vector3.zero
    end

    local holdContact = inspectPath(
        holdFrame,
        hold,
        points,
        true
    )

    if holdContact then
        hold.contact = holdContact
        hold.score = actionCost(hold, holdContact)

        return finish(hold)
    end

    if S.jump and not Config.JumpThenDive then
        return finish(nil, "JUMP ONLY / RECOVERY")
    end

    local candidates = {}

    local jumpAvailable =
        Config.HighBallJumps
        and not S.jump
        and f.landed
        and os.clock() >= S.nextJumpAt
        and f.jumpSpeed > 0

    if jumpAvailable then
        local jump = {
            kind = "JUMP",
            delay = 0,
            queueDelay = S.queueEstimate,
        }

        local hit = inspectPath(f, jump, points, true)

        if hit then
            jump.contact = hit
            jump.score = actionCost(jump, hit)
            candidates[#candidates + 1] = jump
        end
    end

    if not divePathMayReach(f, points, horizon) then
        local plan = choosePlan(candidates)
        return finish(plan, not plan and "OUTSIDE DIVE REACH" or nil)
    end

    local directions = allowedDirections(f)

    for _, name in ipairs(directions) do
        S.immediatePlansChecked =
            S.immediatePlansChecked + 1

        local plan = evaluateDive(
            f,
            "DIVE",
            0,
            name,
            points,
            nil
        )

        if plan then
            candidates[#candidates + 1] = plan
        end
    end

    if #candidates > 0 then
        return finish(KeeperTiming.Protect(f, choosePlan(candidates), points))
    end

    local possible = {}

    local function consider(kind, delay, name)
        if delay >= horizon - 0.005 then
            return
        end

        local plan = makeDive(f, kind, delay, name)
        local raw = inspectPath(f, plan, points, false)

        if raw then
            plan.rawMiss = raw.miss
            plan.rawContact = raw
            possible[#possible + 1] = plan
        end
    end

    for _, name in ipairs(directions) do
        for _, delay in ipairs({ 0.05, 0.10, 0.20, 0.30 }) do
            consider("DIVE", delay, name)
        end

        if jumpAvailable and Config.JumpThenDive then
            for _, age in ipairs({ 0.10, 0.18, 0.26 }) do
                consider(
                    "JUMP_DIVE",
                    S.queueEstimate + age,
                    name
                )
            end
        end
    end

    table.sort(possible, function(a, b)
        local av = a.rawMiss
            + (a.kind == "JUMP_DIVE" and 0.10 or 0)
            + a.delay * 0.2

        local bv = b.rawMiss
            + (b.kind == "JUMP_DIVE" and 0.10 or 0)
            + b.delay * 0.2

        if av ~= bv then
            return av < bv
        end

        return a.name < b.name
    end)

    local budgetHit = false

    for _, candidate in ipairs(possible) do
        if S.delayedPlansChecked >= Config.MaxFinalCandidates then
            budgetHit = true
            break
        end

        S.delayedPlansChecked = S.delayedPlansChecked + 1

        local plan = evaluateDive(
            f,
            candidate.kind,
            candidate.delay,
            candidate.name,
            points,
            candidate
        )

        if plan then
            candidates[#candidates + 1] = plan
        end
    end

    if #candidates > 0 then
        return finish(choosePlan(candidates))
    end

    return finish(
        nil,
        budgetHit
            and "NO CONTACT / SEARCH LIMIT"
            or "NO PRE-GOAL CONTACT"
    )
end

--==============================================================
-- NATIVE JUMP STATE
--==============================================================

local function requestJump(f, plan)
    if not Config.HighBallJumps then return false end

    if plan.kind == "JUMP_DIVE"
        and not Config.JumpThenDive then
        return false
    end

    if not authorizedFrame(f) or manualJumpHeld() then
        return false
    end

    if S.ownedMove then
        releaseMove(true)
        S.nextPlanAt = 0

        status(
            "SETTLING FOR JUMP",
            "Rechecking position after walking"
        )

        return false
    end

    local fresh = snapshot(f.character, f.root, f.humanoid)

    if fresh and not sameTrajectory(f.sourceTrajectory, fresh.sourceTrajectory) then
        S.lastFrame = nil
        S.nextPlanAt = 0
        status("REPLAN JUMP", "Trajectory changed before launch")
        return false
    end

    if not fresh
        or not fresh.eta
        or fresh.eta <= 0
        or fresh.flightKey ~= f.flightKey
        or fresh.context.goal ~= f.context.goal
        or fresh.context.team ~= f.context.team
        or not fresh.landed
        or fresh.jumpSpeed <= 0
        or S.jump
        or os.clock() < S.nextJumpAt then
        return false
    end

    local recheck

    if plan.kind == "JUMP_DIVE" then
        recheck = makeDive(
            fresh,
            "JUMP_DIVE",
            plan.delay,
            plan.name
        )

        if plan.useAssist then
            recheck.assist = prepareAssist(fresh, recheck)
        end
    else
        recheck = {
            kind = "JUMP",
            delay = 0,
            queueDelay = S.queueEstimate,
        }
    end

    local horizon = math.min(
        Config.PredictionHorizon,
        fresh.eta - Config.GoalMarginSeconds
    )

    if horizon <= 0.0001 then return false end

    local hit = inspectPath(
        fresh,
        recheck,
        sampleFlight(fresh, horizon),
        true
    )

    if not hit then
        status("REPLAN JUMP", "No modeled pre-goal contact")
        return false
    end

    f, plan = fresh, recheck
    plan.contact = hit

    local reader =
        M.Controllers.CreateNativeJumpImpulseReader(f.character)

    if not Config.HighBallJumps
        or (
            plan.kind == "JUMP_DIVE"
            and not Config.JumpThenDive
        ) then
        return false
    end

    if not authorizedFrame(f)
        or blocked(f.character, f.root)
        or manualJumpHeld()
        or S.jump
        or os.clock() < S.nextJumpAt
        or not M.Controllers.IsLanded(f.character, f.humanoid) then
        return false
    end

    local jumpOK, requested = pcall(M.Movement.Jump)

    S.nextJumpAt = os.clock() + Config.JumpRetrySeconds

    if not jumpOK or not requested then
        if not manualJumpHeld() then
            pcall(M.Movement.ReleaseJump)
        end

        if not jumpOK then
            report("JUMP REQUEST", requested)
        end

        status(
            "JUMP REFUSED",
            "Existing jump state or input block"
        )

        return false
    end

    S.jump = {
        phase = "QUEUED",
        requested = os.clock(),
        reader = reader,
        character = f.character,
        root = f.root,
        initialY = f.root.Position.Y,
        flightKey = f.flightKey,
        latch = true,
        planned = plan.kind,
    }

    recordRequest("JUMP", f)

    S.pending = {
        kind = "JUMP",
        at = os.clock(),
        ballId = f.ballId,
        flight = f.flightKey,
    }

    status("JUMP QUEUED", "Waiting for actual takeoff")

    log(string.format(
        "JUMP QUEUED | %s | modeled contact %.3fs | goal %.3fs",
        plan.kind,
        plan.contact.time,
        f.eta
    ))

    return true
end

local function updateJump(character, root, humanoid)
    local j = S.jump
    if not j then return false end

    if j.character ~= character or not root.Parent then
        releaseJumpLatch()
        S.jump = nil
        return false
    end

    if j.phase == "QUEUED" then
        local impulse

        if j.reader then
            impulse = j.reader()
        else
            impulse =
                root.AssemblyLinearVelocity.Y > 1
                and root.Position.Y > j.initialY + 0.035
                and not M.Controllers.IsLanded(
                    character,
                    humanoid
                )
        end

        if impulse then
            j.phase = "AIRBORNE"
            j.launched = os.clock()

            local observedDelay = math.max(
                0,
                j.launched - j.requested
            )

            local boundedDelay = math.clamp(
                observedDelay,
                0.015,
                0.20
            )

            S.queueEstimate =
                S.queueEstimate * 0.7
                + boundedDelay * 0.3

            releaseJumpLatch()

            log(string.format(
                "JUMP AIRBORNE | sampled delay %.3fs"
                    .. " | planning estimate %.3fs",
                observedDelay,
                S.queueEstimate
            ))

        elseif (j.reader and impulse == nil)
            or os.clock() - j.requested
                > Config.JumpQueueTimeout then

            cancelOwnedJumpQueue()

            status("JUMP NOT LAUNCHED", "No dive started")
            log("JUMP NOT LAUNCHED | request timed out or was canceled")
        end

        return true
    end

    if M.Controllers.IsLanded(character, humanoid) then
        releaseJumpLatch()
        S.jump = nil
    end

    return false
end

--==============================================================
-- HOLD COMMIT VALIDATION
--==============================================================

local function confirmHold(f)
    if not authorizedFrame(f) then return false end

    S.allowPositioning = false

    if S.ownedMove then
        local released = releaseMove(true)

        S.lastFrame = nil
        S.nextPlanAt = 0

        if released == "STOPPED" then
            S.holdStops = S.holdStops + 1

            status(
                "RECHECK HOLD",
                "Own movement stopped; waiting for a fresh update"
            )

            return false
        end
    end

    local fresh = snapshot(f.character, f.root, f.humanoid)

    if not fresh
        or not finite(fresh.eta)
        or fresh.eta <= 0
        or fresh.flightKey ~= f.flightKey
        or fresh.root ~= f.root
        or fresh.context.goal ~= f.context.goal then

        S.lastFrame = nil
        S.nextPlanAt = 0

        status("REPLAN HOLD", "Ball, role, or goal state changed")
        return false
    end

    if not authorizedFrame(fresh)
        or blocked(fresh.character, fresh.root) then
        return false
    end

    S.holdRechecks = S.holdRechecks + 1

    local horizon = math.min(
        Config.PredictionHorizon,
        fresh.eta - Config.GoalMarginSeconds
    )

    local hit

    if horizon > 0.0001 then
        hit = inspectPath(
            fresh,
            { kind = "HOLD", delay = 0 },
            sampleFlight(fresh, horizon),
            true
        )
    end

    if not hit then
        S.holdRecheckMisses = S.holdRecheckMisses + 1
        S.lastFrame = nil
        S.nextPlanAt = 0

        status(
            "REPLAN HOLD",
            "Current retained movement no longer predicts contact"
        )

        return false
    end

    trackPlanWindow(fresh, { kind = "HOLD", contact = hit })
    fresh.plannerAnchor = os.clock()
    S.lastFrame = fresh
    S.nextPlanAt = math.min(S.nextPlanAt, plannerDeadline(fresh))

    status(
        "HOLD",
        string.format("Rechecked receive in %.3fs", hit.time)
    )

    return true
end

--==============================================================
-- INPUT AND FRAME RESET
--==============================================================

local function cancelQueuedJump()
    return cancelOwnedJumpQueue()
end

local function queuedJumpMustCancel(ball)
    local jump = S.jump

    if not jump or jump.phase ~= "QUEUED" then
        return false
    end

    return not Config.HighBallJumps
        or (jump.planned == "JUMP_DIVE" and not Config.JumpThenDive)
        or not S.focused
        or S.uiBusy
        or UserInputService:GetFocusedTextBox() ~= nil
        or os.clock() < S.manualActionUntil
        or (ball ~= nil and (
            ball.phase ~= "MOVEMENT"
            or jump.flightKey ~= ball.flightKey
        ))
end

local function releaseOwnedState(allowWrite)
    local failures = {}
    local function attempt(label, fn, ...)
        local ok, result = pcall(fn, ...)
        if not ok or result == false then
            failures[#failures + 1] = label .. ": " .. tostring(result)
            report(label, result)
        end
    end

    attempt("OWN POSITION RELEASE", invalidateFrame, allowWrite)

    if S.jump and S.jump.phase == "QUEUED" then
        attempt("OWN JUMP CANCEL", function()
            local j = S.jump
            if not j or j.phase ~= "QUEUED" then return true end

            -- OFF, unload and early-return paths can arrive before updateJump.
            -- Observe the existing request before pulsing the queue-cancel block.
            -- Reader errors stay inside attempt: retain the request for retry.
            local impulse
            if j.reader then
                impulse = j.reader()
            else
                local root, character = j.root, j.character
                local humanoid = character
                    and character:FindFirstChildOfClass("Humanoid")
                impulse = root and root.Parent and humanoid
                    and finite(j.initialY)
                    and root.AssemblyLinearVelocity.Y > 1
                    and root.Position.Y > j.initialY + 0.035
                    and not M.Controllers.IsLanded(character, humanoid)
            end

            if S.jump ~= j then return true end
            if impulse then
                j.phase = "AIRBORNE"
                j.launched = os.clock()
                -- No planning-delay update during shutdown; just release our latch.
                return true
            end
            return cancelQueuedJump()
        end)
    end
    attempt("OWN JUMP RELEASE", releaseJumpLatch)

    if S.jump and S.jump.phase ~= "QUEUED" and not S.jump.latch then
        S.jump = nil
    end

    for lease in pairs(S.retiredMotions) do
        attempt("OWN MOTION RETRY", releaseMotionController, lease)
    end
    for _, lease in pairs(S.retiredLocks) do
        attempt("OWN LOCK RETRY", releaseMotionLock, lease)
    end
    if S.motionLease then
        attempt("OWN MOTION RELEASE", finishMotion, true)
    end

    if S.jumpBlockOwned then
        local ok, result = pcall(M.Movement.SetJumpStateBlocked,
            S.moveLock .. ".Queue", false)
        S.jumpBlockOwned = not (ok and result ~= false)
        if S.jumpBlockOwned then
            failures[#failures + 1] = "OWN JUMP BLOCK RELEASE: " .. tostring(result)
        end
    end

    S.currentContext = nil
    S.pending = nil
    S.lastFollowupBlock = nil
    S.wasKeeper = false

    if S.ownedMove or S.jump or S.jumpBlockOwned or S.motionLease
        or S.controller or next(S.retiredLocks) or next(S.retiredMotions) then
        failures[#failures + 1] = "Owned movement resources remain"
    end

    return #failures == 0, table.concat(failures, "; ")
end

S.releaseOwnedState = releaseOwnedState

local function hasOwnedState()
    return S.wasKeeper
        or S.motionLease ~= nil
        or S.jump ~= nil
        or S.ownedMove ~= nil
        or S.jumpBlockOwned
        or next(S.retiredLocks) ~= nil
        or next(S.retiredMotions) ~= nil
end

connect(UserInputService.InputBegan, function(input, processed)
    if not S.alive or processed or not S.wasKeeper then
        return
    end

    for _, name in ipairs({
        "Dive",
        "Tackle",
        "Dribble",
        "Jump",
        "RainbowFlick",
    }) do
        local ok, matched = pcall(
            M.Keybinds.Matches,
            name,
            input
        )

        if ok and matched then
            S.manualActionUntil = os.clock() + 0.30
            S.allowPositioning = false
            releaseMove(false)
            return
        end
    end
end)

--==============================================================
-- DIVE REQUEST AND RECOVERY
--==============================================================

local function requestDive(f, plan)
    if not authorizedFrame(f) then return false end

    if plan.kind ~= "DIVE" or plan.delay ~= 0 then
        return false
    end

    if S.jump and not Config.JumpThenDive then
        if S.lastFollowupBlock ~= S.jump then
            S.lastFollowupBlock = S.jump
            S.followupBlocks = S.followupBlocks + 1
        end

        status(
            "JUMP ONLY / RECOVERY",
            "Automatic follow-up dives are disabled"
        )

        return false
    end

    if os.clock() - f.readClock > 0.09 then
        status("REPLAN", "Planner sample expired")
        return false
    end

    if S.jump and (
        S.jump.phase ~= "AIRBORNE"
        or os.clock() - S.jump.launched
            < Config.JumpDiveMinimumAge
    ) then
        return false
    end

    local reason = blocked(f.character, f.root)

    if reason or os.clock() < S.nextActionAt then
        return false
    end

    releaseMove(true)

    local fresh = snapshot(f.character, f.root, f.humanoid)

    if fresh and not sameTrajectory(f.sourceTrajectory, fresh.sourceTrajectory) then
        S.lastFrame = nil
        S.nextPlanAt = 0
        status("REPLAN", "Trajectory changed before launch")
        return false
    end

    if not fresh
        or not fresh.eta
        or fresh.flightKey ~= f.flightKey
        or fresh.context.goal ~= f.context.goal
        or fresh.context.team ~= f.context.team then
        return false
    end

    local commit = makeDive(
        fresh,
        "DIVE",
        0,
        plan.name
    )

    if plan.useAssist then
        commit.assist = prepareAssist(fresh, commit)
    end

    local horizon = math.min(
        M.Dive.Constants.HitboxCurveSeconds,
        fresh.eta - Config.GoalMarginSeconds
    )

    if horizon <= 0.0001 then return false end

    local flight = sampleFlight(fresh, horizon)
    local hit = inspectPath(fresh, commit, flight, true)

    if not hit and commit.assist then
        commit.assist = nil
        hit = inspectPath(fresh, commit, flight, true)
    end

    if not hit then
        status(
            "REPLAN",
            "Final assisted motion has no contact"
        )

        return false
    end

    commit.contact = hit
    local timed = KeeperTiming.Protect(fresh, commit, flight)
    if timed.delay > 0 then
        S.lastFrame = fresh
        trackPlanWindow(fresh, timed)
        S.nextPlanAt = plannerDeadline(fresh)
        S.allowPositioning = true
        status("TIMING DIVE " .. timed.name, "Rechecking receiver/blocker before committing")
        return false
    end
    if os.clock() - fresh.readClock > 0.09 then
        S.nextPlanAt = 0
        status("REPLAN", "Final contact sample expired")
        return false
    end

    local exclusions = { fresh.character }
    local renderedBall = M.Renderer.GetBall()

    if renderedBall then
        table.insert(exclusions, renderedBall)
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = exclusions
    params.RespectCanCollide = true

    local targetCF = diveRoot(fresh, commit, hit.time)
    local travel = targetCF.Position - fresh.root.Position

    if travel.Magnitude > 0.05
        and workspace:Raycast(
            fresh.root.Position,
            travel,
            params
        ) then

        status("PATH BLOCKED", "No forced dive")
        return false
    end

    if not authorizedFrame(fresh) or S.motionLease then
        return false
    end

    if S.jump and not Config.JumpThenDive then
        return false
    end

    S.nextLeaseId = S.nextLeaseId + 1

    local lease = {
        id = S.nextLeaseId,
        character = fresh.character,
        root = fresh.root,

        lockName = S.moveLock
            .. "."
            .. tostring(S.nextLeaseId),

        lockHeld = false,
        controller = nil,
        closed = false,

        deadline = os.clock()
            + M.Dive.Constants.DurationSeconds
            + 2,
    }

    S.motionLease = lease

    local controller
    local sentActionId
    local sendFailed = false
    local request

    S.nextActionAt =
        os.clock() + M.Dive.Constants.RepeatDelaySeconds

    local ok, err = pcall(function()
        lease.lockHeld = true

        M.Movement.LockMovement(lease.lockName)
        S.ownLockAcquires = S.ownLockAcquires + 1

        controller = M.Dive.Run(
            fresh.root,
            fresh.humanoid,
            commit.choice,

            function()
                return commit.basis
            end,

            {
                Assist = commit.assist,
                StartedAt = fresh.at,

                Finish = function(_, finished)
                    if S.motionLease == lease
                        and (
                            not lease.controller
                            or lease.controller == finished
                        ) then
                        finishMotion(false, lease)
                    end
                end,
            }
        )

        assert(controller, "Dive controller refused to start")

        assert(
            S.motionLease == lease and not lease.closed,
            "Dive completed before registration"
        )

        lease.controller = controller
        S.controller = controller

        assert(
            authorizedFrame(fresh),
            "Action canceled before send"
        )

        local motion = assert(
            M.Dive.GetMotionSample(fresh.root),
            "Missing motion sample"
        )

        local command = M.Actions.GoalkeeperDive({
            AimDirection = commit.direction,
            DirectionName = commit.name,
            DiveMotion = motion,
            ShotTime = fresh.at,
        })

        request = {
            kind = "DIVE",
            command = command,
            at = os.clock(),
            ballId = fresh.ballId,
            flight = fresh.flightKey,
        }

        S.pending = request

        local sent, result = pcall(M.Protocol.Send, command)

        if not sent then
            sendFailed = true

            error(
                "Native action sender failed: " .. tostring(result),
                0
            )
        end

        if not finite(result) or command.ActionId ~= result then
            sendFailed = true

            error(
                "Native action sender returned an unexpected action ID",
                0
            )
        end

        sentActionId = result
        request.id = result

        recordRequest("DIVE", fresh)

        if S.motionLease == lease and not lease.closed then
            local shown, presentationError = pcall(
                M.Presentation.Play,
                fresh.character,
                commit.name,
                fresh.at
            )

            if not shown then
                report("PRESENTATION", presentationError)
            end
        end
    end)

    S.nextActionAt = math.max(
        S.nextActionAt,

        os.clock() + (
            ok
                and M.Dive.Constants.RepeatDelaySeconds
                or 0.4
        )
    )

    if not ok then
        local registered = lease.controller ~= nil

        finishMotion(true, lease)

        if controller and not registered then
            pcall(controller.Cancel)
        end

        if S.pending == request then
            S.pending = nil
        end

        if sendFailed then
            ENV.AUTO_GK_ENABLED = false
            S.transportError = tostring(err)

            releaseOwnedState(true)
            report("NATIVE SENDER", err)

            status(
                "OFF",
                "Native sender failed; automatic actions disabled"
            )
        else
            report("DIVE REQUEST", err)
            status("DIVE ERROR", tostring(err))
        end

        return false
    end

    releaseJumpLatch()
    S.jump = nil

    if S.pending == request then
        status(
            "DIVE SENT " .. commit.name,

            string.format(
                "contact %.3fs / goal %.3fs",
                hit.time,
                fresh.eta
            )
        )
    end

    log(string.format(
        "DIVE SENT | %s | corrected contact %.3fs"
            .. " | goal %.3fs | margin %.3fs | id %.0f",
        commit.name,
        hit.time,
        fresh.eta,
        fresh.eta - hit.time,
        sentActionId
    ))

    return true
end

--==============================================================
-- POSITION ASSIST
--==============================================================

local function position(f, dt)
    if not S.allowPositioning or not Config.PositionAssist then
        releaseMove(true)
        return
    end

    if S.jump or S.controller then
        releaseMove(false)
        return
    end

    if Config.RespectManualMovement and inputActive() then
        S.manualUntil = os.clock() + Config.ManualReleaseGrace
        releaseMove(false)
        return
    end

    if os.clock() < S.manualUntil then
        releaseMove(true)
        return
    end

    if os.clock() - f.readClock >= Config.CachedFrameMaxAge then
        releaseMove(true)
        return
    end

    if blocked(f.character, f.root) then
        releaseMove(false)
        return
    end

    if not M.Controllers.IsLanded(f.character, f.humanoid) then
        releaseMove(false)
        return
    end

    local remaining = f.eta
        and f.eta - math.max(0, os.clock() - f.readClock)
        or nil

    local threat =
        remaining ~= nil
        and remaining > 0
        and f.goalPosition ~= nil

    local coverage = f.isCoverage == true

    if coverage and not Config.PreShotCoverage then
        releaseMove(true)
        return
    end

    if not coverage
        and not threat
        and Config.PositionMode == "THREATS" then
        releaseMove(true)
        return
    end

    if f.eta and not threat then
        releaseMove(true)
        return
    end

    local c = f.context
    local origin = c.goal.Position
    local depth = Config.HomeDepth
    local ballOffset = f.state.Position - origin

    local halfWidth = math.max(
        0.5,
        goalHalfWidth(c) - 2
    )

    local lateral = ballOffset:Dot(c.right)
        * depth
        / math.max(depth, ballOffset:Dot(c.forward))

    if threat then
        local crossing =
            (f.goalPosition - origin):Dot(c.right)

        local current =
            (f.root.Position - origin):Dot(c.right)

        lateral = math.clamp(
            current,
            crossing - Config.SafeLateralReach,
            crossing + Config.SafeLateralReach
        )

        if f.state.Position.Y - f.root.Position.Y > 5 then
            depth = math.max(3.5, depth - 2.5)
        end
    end

    lateral = math.clamp(lateral, -halfWidth, halfWidth)

    local goalTarget = coverage
        and f.coverageTarget
        or origin + c.forward * depth + c.right * lateral

    local key = (coverage and "COVER:" or "SHOT:")
        .. tostring(c.goal)
        .. ":"
        .. f.flightKey
        .. ":"
        .. Config.PositionMode

    if S.positionKey ~= key then
        resetPositionTarget()
        S.positionKey = key
        S.positionTarget = goalTarget

    elseif flat(goalTarget - S.positionTarget).Magnitude
        > Config.TargetChangeDeadzone then

        local response = math.max(
            0.01,
            Config.TargetResponseSeconds
        )

        local alpha = threat and remaining < 0.35
            and 1
            or 1 - math.exp(
                -math.clamp(dt, 0, 0.10) / response
            )

        S.positionTarget = S.positionTarget:Lerp(
            goalTarget,
            alpha
        )
    end

    local errorVector = flat(
        S.positionTarget - f.root.Position
    )

    local startRadius = coverage
        and Config.CoverageStartRadius
        or (
            threat
                and Config.PositionStartDeadzone
                or Config.HomeRadius
        )

    local stopRadius = coverage
        and Config.CoverageStopRadius
        or (
            threat
                and Config.PositionDeadzone
                or Config.HomeStopRadius
        )

    startRadius = math.max(startRadius, stopRadius + 0.05)

    local distance = errorVector.Magnitude
    -- Finish pre-shot coverage instead of chasing sub-stud error with tiny
    -- walk commands. Keep the original restart radius and approach speed.
    local settleRadius = coverage
        and (stopRadius + math.min(0.15, (startRadius - stopRadius) * 0.5))
        or stopRadius

    if S.positionActive then
        if distance <= settleRadius then
            releaseMove(true)
            return
        end
    elseif distance < startRadius then
        if S.ownedMove then
            releaseMove(true)
        end
        return
    else
        S.positionActive = true
        S.positionChangedAt = os.clock()
    end

    local depthError = errorVector:Dot(c.forward)
    local sideError = errorVector:Dot(c.right)
    local vector = errorVector

    if not coverage and (not threat or remaining > 1.3) then
        if math.abs(depthError) > 1.4 then
            vector = c.forward * depthError
                + c.right * sideError * 0.2
        elseif math.abs(sideError) > stopRadius then
            vector = c.right * sideError
        else
            vector = c.forward * depthError
        end
    elseif not coverage and remaining > 0.65 then
        vector = c.forward * depthError * 0.6
            + c.right * sideError
    end

    if vector.Magnitude < 0.05 then
        releaseMove(true)
        return
    end

    local scale = math.clamp(
        (distance - stopRadius) / 3,
        0,
        1
    )

    local desired = vector.Unit * scale

    if S.ownedMove then
        local old = S.ownedMove

        if old.Magnitude > 0.001 and old:Dot(desired) < 0 then
            old = Vector3.zero
        end

        desired = old:Lerp(
            desired,

            1 - math.exp(
                -math.clamp(dt, 0, 0.10)
                    / math.max(
                        0.01,
                        Config.PositionResponseSeconds
                    )
            )
        )
    end

    if desired.Magnitude < 0.005 then
        releaseMove(true)
        return
    end

    if coverage then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.FilterDescendantsInstances = { f.character }
        params.RespectCanCollide = true

        local probe = desired.Unit * math.min(distance, 3)

        local shoulder = c.right
            * math.max(0.5, f.root.Size.X * 0.4)

        for _, shift in ipairs({
            Vector3.zero,
            shoulder,
            -shoulder,
        }) do
            if workspace:Raycast(
                f.root.Position + shift,
                probe,
                params
            ) then
                releaseMove(true)
                S.allowPositioning = false

                status(
                    "COVERAGE BLOCKED",
                    "Walking path is obstructed"
                )

                return
            end
        end

        S.coverageWrites = S.coverageWrites + 1
    end

    M.Controllers.SetMoveCommand(f.character, desired)

    S.ownedMove = desired
    S.moveCharacter = f.character
    S.positionWrites = S.positionWrites + 1
end

--==============================================================
-- OBSERVATIONS
--==============================================================

local function pendingActionId()
    local pending = S.pending

    if not pending then
        return nil
    end

    return pending.id
        or (pending.command and pending.command.ActionId)
end

connect(StateRemote.OnClientEvent, function(payload)
    if not S.alive or typeof(payload) ~= "table" then
        return
    end

    local key = tostring(payload.BallId)

    if payload.Kind == "Movement" or payload.Kind == "Removed" then
        S.catches[key] = nil

        if payload.BallId == M.Renderer.GetMatchBallId() then
            S.nextPlanAt = 0
            local revision = payload.Kind == "Movement" and trajectoryStamp(payload.State) or nil
            local identified = revision and (revision.movementSequence ~= nil
                or revision.actionId ~= nil or revision.flightStartedAt ~= nil)
            -- A rebased copy of the same server trajectory may wake the planner,
            -- but must not restart its absolute launch deadline.
            if not (identified and S.keeperWait and sameTrajectory(S.keeperWait.trajectory, revision)) then
                S.keeperWait = nil
                S.keeperContact = nil
            end
        end

        return
    end

    if payload.Kind ~= "Owned"
        or payload.OwnerUserId ~= LocalPlayer.UserId then
        return
    end

    if not (
        payload.IsDiveCatch
        or payload.IsGoalkeeperJumpCatch
    ) then
        return
    end

    if S.catches[key] == payload.OwnerUserId then
        return
    end

    S.catches[key] = payload.OwnerUserId
    Stats.CatchesObserved = Stats.CatchesObserved + 1

    local expectedId = pendingActionId()

    local matched =
        expectedId ~= nil
        and payload.ActionId == expectedId
        and S.pending ~= nil
        and payload.BallId == S.pending.ballId

    if matched then
        Stats.ActionMatches = Stats.ActionMatches + 1
    end

    log(string.format(
        "CATCH OBSERVED | %s | action-match %s",
        payload.IsDiveCatch and "dive" or "jump",
        tostring(matched == true)
    ))

    status(
        "CATCH OBSERVED",
        matched
            and "Matching action ID"
            or "No action attribution supplied"
    )

    if S.pending and payload.BallId == S.pending.ballId then
        S.pending = nil
    end
end)

connect(TackleRemote.OnClientEvent, function(packet)
    if not S.alive
        or typeof(packet) ~= "table"
        or typeof(packet.Command) ~= "table" then
        return
    end

    if packet.Protocol ~= "ActionCommand"
        or packet.Phase ~= "ExecuteRejected" then
        return
    end

    local expectedId = pendingActionId()

    if expectedId == nil
        or packet.Command.ActionId ~= expectedId then

        report(
            "UNMATCHED ACTION REJECTION",

            string.format(
                "mode %s | id %s | cooldown %s",
                tostring(packet.Command.Mode),
                tostring(packet.Command.ActionId),
                tostring(packet.CooldownRemainingSeconds)
            )
        )

        return
    end

    Stats.Rejected = Stats.Rejected + 1

    local delay = math.max(
        0.25,
        tonumber(packet.CooldownRemainingSeconds) or 0.25
    )

    if finite(packet.CooldownEndsAt) then
        delay = math.max(
            delay,
            packet.CooldownEndsAt - workspace:GetServerTimeNow()
        )
    end

    S.nextActionAt = math.max(
        S.nextActionAt,
        os.clock() + delay
    )

    local ownedMotion = S.controller ~= nil

    finishMotion(true)

    if ownedMotion and LocalPlayer.Character then
        M.Presentation.Stop(LocalPlayer.Character)
    end

    S.pending = nil

    status(
        "SERVER REJECTED",
        string.format("Wait %.2fs", delay)
    )

    log(
        "SERVER REJECTED | "
            .. tostring(packet.Command.ActionId)
    )
end)

--==============================================================
-- CLOSE-RANGE RUSH
--==============================================================

Config.CloseRangeRush = true
Stats.RushRequests = 0

local Rush = {
    Role = M.Role,
    Actors = M.Actors,
    Motion = M.Motion,

    Range = 12,
    GoalDepth = 28,
    ContactHorizon = 0.30,
    ScanInterval = 0.05,
    ConfirmSeconds = 0.05,

    nextScan = 0,
    candidate = nil,
    candidateSince = 0,
    lastSeenAt = 0,
}

local function rushVector(v)
    return finiteVector(v)
end

local function rushSnapshot(character, root, humanoid)
    if not Config.CloseRangeRush
        or S.jump
        or S.motionLease
        or S.controller then
        return nil
    end

    if not authorizedFrame({
        character = character,
        humanoid = humanoid,
    }) then
        return nil
    end

    if inputActive()
        or manualJumpHeld()
        or os.clock() < S.manualUntil then
        return nil
    end

    if os.clock() < S.nextActionAt
        or blocked(character, root) then
        return nil
    end

    if not Rush.Role.IsGoalkeeper()
        or not M.Controllers.IsLanded(character, humanoid) then
        return nil
    end

    local ball = readBall()

    if ball.phase ~= "OWNED"
        or not finite(ball.owner)
        or ball.owner == LocalPlayer.UserId then
        return nil
    end

    local actor = Rush.Actors.GetByUserId(ball.owner)
    local target = actor and Rush.Actors.GetCharacter(actor)

    local targetRoot =
        target and target:FindFirstChild("HumanoidRootPart")

    local targetHumanoid =
        target and target:FindFirstChildOfClass("Humanoid")

    if not targetRoot
        or not targetHumanoid
        or targetHumanoid.Health <= 0 then
        return nil
    end

    local ownTeam = M.Teams.GetActorTeamName(LocalPlayer)
    local otherTeam = M.Teams.GetActorTeamName(actor)

    if ownTeam == nil
        or otherTeam == nil
        or ownTeam == otherTeam then
        return nil
    end

    if M.Match.IsGoalkeeperCharacter(target)
        or not M.Controllers.IsLanded(target, targetHumanoid) then
        return nil
    end

    local context = contextFor(root)
    if not context then return nil end

    local targetPosition = Rush.Motion.GetPosition(target)
    local velocity = Rush.Motion.GetVelocity(target)
    local ballPosition = M.Renderer.GetPosition()

    if not rushVector(targetPosition)
        or not rushVector(velocity)
        or not rushVector(ballPosition) then
        return nil
    end

    if (ballPosition - targetPosition).Magnitude > 7 then
        return nil
    end

    if math.abs(velocity.Y) > 6 then return nil end

    velocity = flat(velocity)

    local offset = flat(targetPosition - root.Position)
    local distance = offset.Magnitude

    if distance < 0.25 or distance > Rush.Range then
        return nil
    end

    local goalPosition = context.goal.Position

    local keeperDepth =
        (root.Position - goalPosition):Dot(context.forward)

    local targetDepth =
        (targetPosition - goalPosition):Dot(context.forward)

    local halfWidth = goalHalfWidth(context)

    if keeperDepth < 0 or keeperDepth > Rush.GoalDepth then
        return nil
    end

    if targetDepth < keeperDepth - 1
        or targetDepth > Rush.GoalDepth
        or targetDepth < 0 then
        return nil
    end

    if math.abs(
        (targetPosition - goalPosition):Dot(context.right)
    ) > halfWidth + 2 then
        return nil
    end

    if velocity:Dot(context.forward) > 2 then
        return nil
    end

    local closing = -velocity:Dot(offset.Unit)
    local goalDirection = unit(goalPosition - targetPosition)

    local facingGoal =
        unit(targetRoot.CFrame.LookVector):Dot(goalDirection)
            > 0.40

    if distance > 6 and closing < 1 and not facingGoal then
        return nil
    end

    local floorY = M.Grounding.GetStandingY(humanoid, root)
    if not finite(floorY) then return nil end

    local camera = workspace.CurrentCamera
    local cameraCF = camera and camera.CFrame or root.CFrame

    return {
        character = character,
        root = root,
        humanoid = humanoid,
        rootCF = root.CFrame,
        floorY = floorY,
        context = context,
        target = target,
        owner = ball.owner,
        ballId = ball.ballId,
        ballPosition = ballPosition,
        targetPosition = targetPosition,
        targetVelocity = velocity,
        cameraCF = cameraCF,
        readClock = os.clock(),
        halfWidth = halfWidth,
    }
end

local function rushDirectionAllowed(direction, context)
    local forward = direction:Dot(context.forward)
    local right = direction:Dot(context.right)

    if forward < -0.20 then return false end

    local filter = Config.DiveFilter

    if filter == "FORWARD" then
        return forward > 0.90
    end

    if filter == "LEFT" then
        return right < -0.35
    end

    if filter == "RIGHT" then
        return right > 0.35
    end

    if filter == "SIDES" then
        return math.abs(right) > 0.35
    end

    return true
end

local function rushContact(f, plan)
    local horizon = math.min(
        Rush.ContactHorizon,
        M.Dive.Constants.HitboxCurveSeconds
    )

    local box = M.Hitboxes.AirReceive

    local previousTime = 0
    local previousBall = f.ballPosition
    local previousRoot = f.rootCF
    local time = 0

    while time < horizon - 0.000001 do
        time = math.min(horizon, time + 0.01)

        local ballPosition =
            f.ballPosition + f.targetVelocity * time

        local rootCF = diveRoot(f, plan, time)

        local hit = M.Contacts.FindDiveSaveContact(
            LocalPlayer,
            previousBall,
            ballPosition,
            {
                StartRootCFrame = previousRoot,
                EndRootCFrame = rootCF,
                BallRadius = M.Physics.BallRadius,
            }
        )

        local coreAlpha = M.Hitboxes.GetSegmentEnterAlpha(
            { CFrame = rootCF },
            box,
            previousBall + rootCF.Position - previousRoot.Position,
            ballPosition
        )

        if hit and coreAlpha then
            local contactTime = previousTime
                + (time - previousTime)
                * math.max(hit.Alpha, coreAlpha)

            if contactTime >= 0.03 then
                return contactTime
            end
        end

        previousTime = time
        previousBall = ballPosition
        previousRoot = rootCF
    end

    return nil
end

local function rushPathClear(f, plan)
    local exclusions = { f.character, f.target }
    local renderedBall = M.Renderer.GetBall()

    if renderedBall then
        exclusions[#exclusions + 1] = renderedBall
    end

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = exclusions
    params.RespectCanCollide = true

    local side = Vector3.new(
        -plan.direction.Z,
        0,
        plan.direction.X
    )

    local shoulder =
        side * math.max(0.5, f.root.Size.X * 0.4)

    local origin = f.context.goal.Position
    local previous = f.root.Position
    local duration = M.Dive.Constants.DurationSeconds
    local time = 0

    while time < duration - 0.000001 do
        time = math.min(duration, time + 0.05)

        local position = diveRoot(f, plan, time).Position
        local offset = position - origin
        local depth = offset:Dot(f.context.forward)

        if depth < -0.5 or depth > Rush.GoalDepth then
            return false
        end

        if math.abs(offset:Dot(f.context.right))
            > f.halfWidth + 2 then
            return false
        end

        local travel = position - previous

        if travel.Magnitude > 0.001 then
            for _, shift in ipairs({
                Vector3.zero,
                shoulder,
                -shoulder,
            }) do
                if workspace:Raycast(
                    previous + shift,
                    travel,
                    params
                ) then
                    return false
                end
            end
        end

        previous = position
    end

    return true
end

local function rushPlan(f)
    local best

    local toward = unit(
        f.targetPosition - f.root.Position,
        f.context.forward
    )

    for _, name in ipairs({
        "F", "LF", "L", "LB",
        "RF", "R", "RB", "B",
    }) do
        local choice = M.Dive.GetDirectionChoiceByName(name)

        local direction = M.Dive.GetWorldDirection(
            choice,
            f.cameraCF,
            unit(f.rootCF.LookVector)
        )

        if rushDirectionAllowed(direction, f.context)
            and direction:Dot(toward) > 0.50 then

            local plan = {
                kind = "DIVE",
                name = name,
                choice = choice,
                direction = direction,
                origin = f.rootCF,
                delay = 0,
                assist = nil,
            }

            local contact = rushContact(f, plan)

            if contact then
                plan.contact = contact

                plan.score = contact
                    + 0.08 * (1 - direction:Dot(toward))

                if (not best or plan.score < best.score)
                    and rushPathClear(f, plan) then
                    best = plan
                end
            end
        end
    end

    return best
end

local function tryCloseRush(character, root, humanoid)
    if os.clock() < Rush.nextScan then return false end

    Rush.nextScan = os.clock() + Rush.ScanInterval

    if os.clock() - Rush.lastSeenAt > 0.15 then
        Rush.candidate = nil
    end

    local f = rushSnapshot(character, root, humanoid)

    if not f then
        Rush.candidate = nil
        return false
    end

    Rush.lastSeenAt = os.clock()

    local key =
        tostring(f.ballId) .. ":" .. tostring(f.owner)

    if Rush.candidate ~= key then
        Rush.candidate = key
        Rush.candidateSince = os.clock()
        return false
    end

    if os.clock() - Rush.candidateSince
        < Rush.ConfirmSeconds then
        return false
    end

    local plan = rushPlan(f)

    if not plan or os.clock() - f.readClock > 0.05 then
        return false
    end

    local current = readBall()

    if current.phase ~= "OWNED"
        or current.owner ~= f.owner
        or current.ballId ~= f.ballId then
        return false
    end

    if LocalPlayer.Character ~= character
        or not Config.CloseRangeRush then
        return false
    end

    if not authorizedFrame(f)
        or blocked(character, root)
        or inputActive() then
        return false
    end

    if Rush.Actors.GetCharacter(
        Rush.Actors.GetByUserId(f.owner)
    ) ~= f.target then
        return false
    end

    local camera = workspace.CurrentCamera
    local cameraCF = camera and camera.CFrame or root.CFrame

    if unit(cameraCF.LookVector):Dot(
        unit(f.cameraCF.LookVector)
    ) < 0.999 then
        return false
    end

    local actualChoice = M.Dive.GetDirectionChoice(
        plan.direction,
        cameraCF,
        unit(root.CFrame.LookVector)
    )

    if actualChoice.Name ~= plan.choice.Name then
        return false
    end

    if S.ownedMove then
        releaseMove(true)
    end

    local previousMove =
        M.Controllers.GetMoveCommand(character)

    if not rushVector(previousMove) then
        return false
    end

    local wrote = false

    local ok, started = pcall(function()
        wrote = true

        M.Controllers.SetMoveCommand(
            character,
            plan.direction
        )

        local selected = M.Dive.GetDirectionChoice(
            M.Controllers.GetMoveCommand(character),
            cameraCF,
            unit(root.CFrame.LookVector)
        )

        if selected.Name ~= plan.choice.Name then
            return false
        end

        local finalBall = readBall()

        if finalBall.phase ~= "OWNED"
            or finalBall.owner ~= f.owner
            or finalBall.ballId ~= f.ballId
            or not Config.CloseRangeRush then
            return false
        end

        return Rush.Role.Dive()
    end)

    local restored, restoreError = pcall(function()
        if not wrote
            or LocalPlayer.Character ~= character
            or not character.Parent then
            return
        end

        local move = M.Controllers.GetMoveCommand(character)

        if not rushVector(move) then
            error("Cannot read movement after rush")
        end

        if move.Magnitude > 0.01
            and move.Unit:Dot(plan.direction) > 0.999 then

            M.Controllers.SetMoveCommand(
                character,
                previousMove
            )
        end
    end)

    Rush.candidate = nil

    if not restored then
        ENV.AUTO_GK_ENABLED = false
        report("CLOSE RUSH MOVEMENT", restoreError)
    end

    if not ok then
        Config.CloseRangeRush = false

        local cleaned, cleanupError =
            pcall(Rush.Role.Cleanup)

        if not cleaned then
            report("CLOSE RUSH CLEANUP", cleanupError)
        end

        report("CLOSE RUSH", started)

        status(
            "RUSH DISABLED",
            "Native dive failed; shot saves unchanged"
        )

        return false
    end

    if started ~= true then return false end

    S.nextActionAt = math.max(
        S.nextActionAt,
        os.clock() + M.Dive.Constants.RepeatDelaySeconds
    )

    S.nextPlanAt = 0
    S.allowPositioning = false

    S.pending = {
        kind = "RUSH",
        at = os.clock(),
        ballId = f.ballId,
    }

    recordRequest("DIVE", nil)
    Stats.RushRequests = Stats.RushRequests + 1

    status(
        "CLOSE-RANGE RUSH",
        "Native dive; interception predicted, outcome not confirmed"
    )

    log(string.format(
        "CLOSE-RANGE RUSH | %s | modeled contact %.3fs",
        plan.name,
        plan.contact
    ))

    return true
end

--==============================================================
-- PRE-SHOT ANGLE COVERAGE
--==============================================================

local function coverageTarget(context, ballPosition, ballVelocity)
    local lead = flat(ballVelocity) * Config.CoverageLeadSeconds

    if lead.Magnitude > Config.CoverageMaximumLead then
        lead = lead.Unit * Config.CoverageMaximumLead
    end

    local offset =
        ballPosition + lead - context.goal.Position

    local x = offset:Dot(context.right)
    local z = offset:Dot(context.forward)
    local width = goalHalfWidth(context)

    if z <= 2
        or z > Config.CoverageRange
        or math.abs(x) > width + 22 then
        return nil
    end

    local depth = math.min(
        math.clamp(
            z * 0.30,
            Config.CoverageMinimumDepth,

            math.max(
                Config.CoverageMinimumDepth,
                Config.HomeDepth
            )
        ),

        z - 1.25
    )

    local left = Vector3.new(-width - x, 0, -z)
    local right = Vector3.new(width - x, 0, -z)
    local bisector = left.Unit + right.Unit

    if math.abs(bisector.Z) < 0.0001 then
        return nil
    end

    local lateral =
        x + (depth - z) * bisector.X / bisector.Z

    local limit = math.max(0.5, width - 1.5)

    lateral = math.clamp(lateral, -limit, limit)

    return context.goal.Position
        + context.forward * depth
        + context.right * lateral
end

local function coverageSnapshot(
    character,
    root,
    humanoid,
    ball,
    context
)
    if ball.phase ~= "OWNED"
        or not finite(ball.owner)
        or ball.owner == LocalPlayer.UserId then
        return nil
    end

    local actor = Rush.Actors.GetByUserId(ball.owner)
    local target = actor and Rush.Actors.GetCharacter(actor)

    local targetHumanoid =
        target and target:FindFirstChildOfClass("Humanoid")

    if not targetHumanoid or targetHumanoid.Health <= 0 then
        return nil
    end

    local ownTeam = M.Teams.GetActorTeamName(LocalPlayer)
    local otherTeam = M.Teams.GetActorTeamName(actor)

    if ownTeam == nil
        or otherTeam == nil
        or ownTeam == otherTeam then
        return nil
    end

    if M.Match.IsGoalkeeperCharacter(target) then
        return nil
    end

    local ballPosition = M.Renderer.GetPosition()
    local actorPosition = Rush.Motion.GetPosition(target)
    local velocity = Rush.Motion.GetVelocity(target)

    if not rushVector(ballPosition)
        or not rushVector(actorPosition)
        or not rushVector(velocity) then
        return nil
    end

    if (ballPosition - actorPosition).Magnitude > 7 then
        return nil
    end

    local rootOffset = root.Position - context.goal.Position
    local depth = rootOffset:Dot(context.forward)

    if depth < -1
        or depth > Rush.GoalDepth
        or math.abs(rootOffset:Dot(context.right))
            > goalHalfWidth(context) + 2 then
        return nil
    end

    local destination = coverageTarget(
        context,
        ballPosition,
        velocity
    )

    if not destination then
        return nil
    end

    return {
        isCoverage = true,
        character = character,
        root = root,
        humanoid = humanoid,
        context = context,
        target = target,
        targetHumanoid = targetHumanoid,
        owner = ball.owner,
        ballId = ball.ballId,
        coverageTarget = destination,
        state = { Position = ballPosition },
        flightKey = "OWNER:" .. tostring(ball.owner),
        readClock = os.clock(),
        goalFrame = context.goal.CFrame,
    }
end

local function coverCarrier(
    character,
    root,
    humanoid,
    ball,
    context,
    dt
)
    if not Config.PreShotCoverage
        or not Config.PositionAssist
        or S.jump
        or S.controller
        or not M.Controllers.IsLanded(character, humanoid) then

        S.coverageFrame = nil
        S.allowPositioning = false
        releaseMove(true)
        return false
    end

    if Config.RespectManualMovement and inputActive() then
        S.manualUntil = os.clock() + Config.ManualReleaseGrace
        S.coverageFrame = nil
        S.allowPositioning = false
        releaseMove(false)
        return false
    end

    local frame = S.coverageFrame
    local clock = os.clock()

    if not frame
        or clock >= S.coverageNextAt
        or frame.owner ~= ball.owner
        or frame.root ~= root
        or frame.context.goal ~= context.goal
        or frame.goalFrame ~= context.goal.CFrame then

        frame = coverageSnapshot(
            character,
            root,
            humanoid,
            ball,
            context
        )

        S.coverageFrame = frame

        S.coverageNextAt =
            clock + 1 / Config.CoverageUpdateHz
    end

    if not frame
        or clock - frame.readClock > Config.CachedFrameMaxAge
        or not frame.target.Parent
        or frame.targetHumanoid.Health <= 0 then

        S.allowPositioning = false
        releaseMove(true)
        return false
    end

    local current = readBall()

    if current.phase ~= "OWNED"
        or current.owner ~= frame.owner
        or current.ballId ~= frame.ballId then

        invalidateFrame(true)
        return false
    end

    S.allowPositioning = true
    position(frame, dt)

    if S.allowPositioning then
        status(
            "COVERING ANGLE",
            S.positionActive
                and "Adjusting before the shot"
                or "Holding the covered angle"
        )
    end

    return true
end

--==============================================================
-- MAIN LOOP
--==============================================================

local function tick(dt)
    if not S.alive then return end

    serviceOwnedMotion()

    if not ENV.AUTO_GK_ENABLED or not Config.Enabled then
        if hasOwnedState() then
            releaseOwnedState(true)
        end

        status("OFF", S.runtimeError
            and "Repeated runtime error; inspect AutoGKDebug() before retrying"
            or nil)
        return
    end

    local character = LocalPlayer.Character

    local humanoid =
        character and character:FindFirstChildOfClass("Humanoid")

    local root =
        character and character:FindFirstChild("HumanoidRootPart")

    if not root or not humanoid or humanoid.Health <= 0 then
        if hasOwnedState() then
            releaseOwnedState(false)
        end

        status("NO CHARACTER")
        return
    end

    if character ~= S.lastChar then
        if hasOwnedState() then
            releaseOwnedState(false)
        else
            invalidateFrame(false)
        end

        S.jump = nil
        S.pending = nil
        S.lastChar = character
        S.ballSignature = nil
        S.currentContext = nil
        S.missingSince = nil
    end

    if not M.Match.IsGoalkeeperCharacter(character) then
        if hasOwnedState() then
            releaseOwnedState(true)
        end

        status("WAITING FOR GK", "Manual controls untouched")
        return
    end

    S.wasKeeper = true

    -- Observe takeoff once before deciding whether this request is still queued.
    local jumpWasQueued = updateJump(character, root, humanoid)

    if queuedJumpMustCancel(nil) then
        cancelQueuedJump()
    end

    if not S.focused then
        invalidateFrame(true)
        cancelQueuedJump()
        status("WINDOW UNFOCUSED")
        return
    end

    if S.uiBusy or os.clock() < S.manualActionUntil then
        invalidateFrame(false)

        status(
            S.uiBusy and "INTERFACE OPEN" or "MANUAL ACTION",
            "Automatic requests paused"
        )

        return
    end

    local ball = readBall()
    S.ballPhase = ball.phase

    local signature = tostring(ball.ballId)
        .. ":"
        .. ball.phase
        .. ":"
        .. tostring(ball.flightKey or ball.owner)

    if signature ~= S.ballSignature then
        invalidateFrame(true)
        S.ballSignature = signature
        S.observedBallId = ball.ballId
    end

    local context = contextFor(root, ball.state)

    if not context then
        invalidateFrame(true)
        cancelQueuedJump()
        S.currentContext = nil
        status("WAITING FOR TEAM / GOAL")
        return
    end

    if S.currentContext and (
        S.currentContext.goal ~= context.goal
        or S.currentContext.team ~= context.team
    ) then
        invalidateFrame(true)
        cancelQueuedJump()
    end

    S.currentContext = context

    if queuedJumpMustCancel(ball) then
        cancelQueuedJump()
    end

    if jumpWasQueued and S.jump then
        S.allowPositioning = false

        if S.jump and S.jump.phase == "QUEUED" then
            status("JUMP QUEUED", "Waiting for takeoff")
        end

        return
    end

    if S.controller then
        S.allowPositioning = false
        releaseMove(false)
        return
    end

    local why = blocked(character, root)

    if why then
        invalidateFrame(false)
        status(why)
        return
    end

    if UserInputService:GetFocusedTextBox() then
        invalidateFrame(true)
        status("TEXT INPUT")
        return
    end

    if ball.phase ~= "MOVEMENT" then
        S.lastFrame = nil

        if ball.phase == "OWNED" then
            S.ballInfo = ball.owner == LocalPlayer.UserId
                and "Held by you"
                or "Held by another actor"

            S.missingSince = nil

            local rushOK, rushed = pcall(
                tryCloseRush,
                character,
                root,
                humanoid
            )

            if not rushOK then
                Config.CloseRangeRush = false
                Rush.candidate = nil
                report("CLOSE RUSH DISABLED", rushed)

            elseif rushed then
                S.coverageFrame = nil
                return
            end

            local coverageOK, covered = pcall(
                coverCarrier,
                character,
                root,
                humanoid,
                ball,
                context,
                dt
            )

            if not coverageOK then
                Config.PreShotCoverage = false
                invalidateFrame(true)

                report(
                    "PRE-SHOT COVERAGE DISABLED",
                    covered
                )

            elseif covered then
                return
            end
        else
            Rush.candidate = nil
            invalidateFrame(true)
        end

        S.allowPositioning = false
        releaseMove(true)
        unavailableStatus(ball, context)
        return
    end

    Rush.candidate = nil
    S.missingSince = nil
    S.ballInfo = "Movement trajectory available"

    if S.lastFrame and (
        S.lastFrame.flightKey ~= ball.flightKey
        or S.lastFrame.world ~= ball.world
        or S.lastFrame.root ~= root
    ) then
        invalidateFrame(true)
    end

    if S.lastFrame and trajectoryChanged(S.lastFrame, ball) then
        -- Cover a renderer revision applied after our Movement listener ran.
        -- Ordinary local extrapolation never counts as a new server revision.
        S.nextPlanAt = 0
    end

    if os.clock() < S.nextPlanAt then
        if S.allowPositioning and S.lastFrame then
            position(S.lastFrame, dt)
        end

        return
    end

    local f, reason, unavailable = snapshot(
        character,
        root,
        humanoid
    )

    S.lastFrame = f

    if not f then
        invalidateFrame(true)

        if unavailable then
            unavailableStatus(unavailable, context)
        else
            status(reason or "NO STATE")
        end

        return
    end

    S.currentContext = f.context

    f.plannerAnchor = os.clock()
    S.nextPlanAt = plannerDeadline(f)

    if not f.eta or f.eta <= 0 then
        S.allowPositioning = Config.PositionMode ~= "THREATS"

        position(f, dt)

        status(
            "READY / " .. f.context.mode,

            S.allowPositioning
                and "No goal-bound shot; home positioning enabled"
                or "No goal-bound shot; idle movement off"
        )

        return
    end

    if f.eta > Config.PredictionHorizon then
        S.allowPositioning = true
        position(f, dt)

        status(
            "TRACKING",
            string.format("Goal in %.2fs", f.eta)
        )

        return
    end

    S.allowPositioning = false

    local plan, noPlan = planSave(f)
    trackPlanWindow(f, plan)
    S.nextPlanAt = plannerDeadline(f)

    if plan and plan.kind == "HOLD" then
        confirmHold(f)
        return
    end

    if not plan then
        S.allowPositioning = true
        position(f, dt)

        status(
            noPlan or "NO VERIFIED CONTACT",
            "No blind emergency dive"
        )

        return
    end

    if os.clock() < S.nextActionAt then
        S.allowPositioning = true
        position(f, dt)
        status("ACTION COOLDOWN")
        return
    end

    if plan.kind == "JUMP" or plan.kind == "JUMP_DIVE" then
        requestJump(f, plan)

    elseif plan.delay > 0 then
        -- Recheck by the modeled launch time, even between normal planner ticks.
        -- The next update still validates fresh contact before any action.
        S.nextPlanAt = math.min(S.nextPlanAt, f.readClock + plan.delay)
        S.allowPositioning = true
        position(f, dt)

        status(
            "TIMING DIVE " .. plan.name,

            string.format(
                "Replan in %.2fs",
                math.max(0, S.nextPlanAt - os.clock())
            )
        )
    else
        requestDive(f, plan)
    end
end

connect(RunService.Heartbeat, function(dt)
    if not S.alive or S.loopBusy
        or os.clock() < S.runtimeRetryAt then return end

    S.loopBusy = true

    local ok, err = xpcall(function()
        tick(dt)
    end, debug.traceback)

    S.loopBusy = false

    if not ok then
        S.runtimeFailures = S.runtimeFailures + 1
        S.runtimeError = tostring(err)
        S.runtimeRetryAt = os.clock() + Config.RuntimeErrorRetrySeconds
        pcall(releaseOwnedState, true)

        if S.runtimeFailures >= Config.RuntimeErrorLimit then
            ENV.AUTO_GK_ENABLED = false
        end

        status(
            ENV.AUTO_GK_ENABLED and "RUNTIME ERROR" or "OFF",
            S.runtimeError:match("[^\n]+")
        )

        report("RUNTIME", err)
    elseif ENV.AUTO_GK_ENABLED and Config.Enabled then
        S.runtimeFailures = 0
        S.runtimeRetryAt = 0
        S.runtimeError = nil
    end
end)

-- STR: native aim input, bounded search, keeper and defender reach estimates.
local function createStriker(d)
    local A = { Enabled = false, AutoCurve = false, SmartRelease = false, Ready = false, Status = "OFF", Detail = "", LastError = nil }
    local C = { SliceMs = 2.5, CallsPerSlice = 4, Horizon = 2.2, Step = 0.035,
        SampleHz = 30, CandidateAge = 0.35, NetworkMargin = 0.10, EdgeMargin = 0.65, TargetSlack = 0.35,
        MaxAssistDistance = 55, ClearGapThreshold = 0.75, VolleyPrepareSeconds = 0.30,
        ReleaseInterval = 0.05, ReleaseMargin = 0.35, ReleaseBudgetMs = 2.5 }
    local stats = { shots = 0, assisted = 0, redirected = 0, confirmed = 0, rejected = 0, candidates = 0, evaluations = 0,
        errors = 0, maxSliceMs = 0, maxAimMs = 0, lastCharge = 0, lastCurve = 0,
        releaseChecks = 0, releaseBudgetSkips = 0, releaseRequests = 0, autoReleases = 0, maxReleaseMs = 0 }
    local recentShots = {}
    -- Native modules are populated by name during lazy installation.
    local N: { [string]: any } = {}
    local session, hooks = nil, {}
    local ownerSnapshot = nil
    local scopes = setmetatable({}, { __mode = "k" })
    local nativeLaunches = setmetatable({}, { __mode = "k" })
    local mainThread = {}
    local alive, busy, installing = true, false, false
    local V0, UP = Vector3.zero, Vector3.new(0, 1, 0)
    local function num(n) return type(n) == "number" and n == n and math.abs(n) < math.huge end
    local function vec(v) return typeof(v) == "Vector3" and num(v.X) and num(v.Y) and num(v.Z) end
    local function flat(v) return Vector3.new(v.X, 0, v.Z) end
    local function thread() return coroutine.running() or mainThread end
    local function setStatus(name, detail) A.Status, A.Detail = name, detail or "" end
    local function fail(err)
        stats.errors += 1
        A.LastError = tostring(err)
        local pair = session and session.pair
        if pair and math.abs(pair.curve - pair.manualCurve) > 1e-5 and N.Client then
            local ok, cancelError = pcall(function()
                if N.Client.IsCharging() then N.Client.CancelCharge() end
            end)
            if not ok then A.LastError ..= " | Curve charge cancellation: " .. tostring(cancelError) end
        end
        A.Enabled = false
        session = nil
        table.clear(nativeLaunches)
        setStatus("STR ERROR", "Normal shooting remains available; run AutoSTRDebug().")
        warn("[Auto STR] " .. A.LastError)
    end
    local function guarded(fn, ...)
        local result = table.pack(pcall(fn, ...))
        if not result[1] then fail(result[2]); return nil end
        return table.unpack(result, 2, result.n)
    end
    local function scopeCall(fn, ...)
        if not alive or not A.Enabled then return fn(...) end
        local key = thread()
        local previous = scopes[key]
        scopes[key] = { applied = false }
        local result = table.pack(pcall(fn, ...))
        scopes[key] = previous
        -- An original game error must retain its original failure semantics.
        if not result[1] then error(result[2], 0) end
        return table.unpack(result, 2, result.n)
    end
    local function ballId()
        return type(d.M.Renderer.GetMatchBallId) == "function" and d.M.Renderer.GetMatchBallId() or nil
    end
    local function ownsBall()
        local ch = d.Player.Character
        -- Follow the owner notifications used by native ChargedKick when available.
        -- Renderer state may briefly disagree during network/prediction transitions.
        if ownerSnapshot and ownerSnapshot.character == ch and ownerSnapshot.ballId == ballId()
            and ownerSnapshot.context == d.M.Motion.GetContext(ch) then
            return ownerSnapshot.userId == d.Player.UserId
        end
        return d.M.Renderer.GetOwnedUserId() == d.Player.UserId
    end
    local skipDetails = {
        suspended = "Input or UI is busy", no_character = "Waiting for a live character",
        goalkeeper = "GK role is active", forced_clear = "Native goalkeeper clear is active",
        no_possession = "Waiting for native ball possession or a confirmed volley",
        invalid_sample = "Waiting for a valid camera aim", no_world = "Shot boundary data unavailable",
        no_launch = "Ball launch point unavailable", no_goal = "Attacking goal unavailable",
        invalid_goal = "Outside the attacking side of the goal",
    }
    local function skipFrame(reason)
        if session then session.reason = reason end
        setStatus(reason == "no_possession" and "WAITING FOR BALL" or "NORMAL AIM", skipDetails[reason])
        return nil
    end
    local function eligible()
        if not (alive and A.Enabled and d.alive()) or d.uiBusy() then return false, "suspended" end
        if d.Input:GetFocusedTextBox() then return false, "suspended" end
        local ch = d.Player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return false, "no_character" end
        if d.M.Match.IsGoalkeeperCharacter(ch) then return false, "goalkeeper" end
        if N.Client.IsForcedClearCharging() then return false, "forced_clear" end
        if not (ownsBall() or N.Client.IsVolleyCharging()) then return false, "no_possession" end
        return true
    end
    local function goalFor(origin)
        local tutorialGoal = N.Tutorial.GetGoalPart()
        local practiceGoals = not tutorialGoal and d.M.Practice.GetGoalParts() or nil
        local goals = tutorialGoal and { tutorialGoal } or practiceGoals
        local team = d.M.Teams.GetActorTeamName(d.Player)
        if not goals then
            if not d.M.Match.Constants.TeamDisplayNames[team] then return nil end
            local map = workspace:FindFirstChild("Map")
            local data = map and map:FindFirstChild("Data")
            local side = data and data:FindFirstChild(d.M.Match.GetOpposingTeamName(team))
            local goal = side and side:FindFirstChild("Goal")
            goals = goal and { goal } or nil
        end
        local best, distance
        for _, goal in ipairs(goals or {}) do
            if goal:IsA("BasePart") then
                local delta = (goal.Position - origin).Magnitude
                if not distance or delta < distance then best, distance = goal, delta end
            end
        end
        return best, team, practiceGoals
    end
    local function mouthFor(goal, origin)
        -- Use the physical goal plane, including rotated goals and goal depth.
        local cf, size = goal.CFrame, goal.Size
        local forward = size.X < size.Z and cf.RightVector or cf.LookVector
        forward = flat(forward)
        if forward.Magnitude < 0.9 then return nil end
        forward = forward.Unit
        if (origin - goal.Position):Dot(forward) < 0 then forward = -forward end
        local lateral = forward:Cross(UP)
        local depth = math.abs(forward:Dot(cf.RightVector)) * size.X / 2
            + math.abs(forward:Dot(cf.LookVector)) * size.Z / 2
        return { center = goal.Position, plane = goal.Position + forward * depth, depth = depth * 2,
            forward = forward, lateral = lateral,
            halfWidth = (math.abs(lateral:Dot(cf.RightVector)) * size.X
                + math.abs(lateral:Dot(cf.LookVector)) * size.Z) / 2,
            bottom = goal.Position.Y - size.Y / 2, top = goal.Position.Y + size.Y / 2 }
    end
    local function mouthDistance(mouth, origin)
        -- Measure close range to the nearest point across the opening, including wide match goals.
        local offset = math.clamp((origin - mouth.plane):Dot(mouth.lateral), -mouth.halfWidth, mouth.halfWidth)
        return flat(origin - (mouth.plane + mouth.lateral * offset)).Magnitude
    end
    local function defenderSnapshot(character, root, hum, cf, velocity)
        local state = d.M.Controllers.GetHumanoidState(character, hum)
        local airborne = state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall
        local floor = d.M.Grounding.GetStandingY(hum, root)
        local gravity = math.max(workspace.Gravity, 1)
        local jump = hum.UseJumpPower and hum.JumpPower or math.sqrt(2 * gravity * hum.JumpHeight)
        local landAt = airborne and math.max(0, (velocity.Y + math.sqrt(velocity.Y ^ 2
            + 2 * gravity * math.max(0, cf.Position.Y - floor))) / gravity) or 0
        local runSpeed = N.ActionMovement.GetRunWalkSpeed(N.ActionMovement.GetBaseWalkSpeed(), false)
        local receive = N.Receiving.GetReceiveHitbox(character, false)
        local airReceive = N.Receiving.GetReceiveHitbox(character, true)
        local slide = N.Tackle.Constants
        local untilTime = N.Tackle.GetSlidingUntil(character)
        -- SlidingUntil uses the workspace server clock, not the smoothed ball clock.
        local slideAge = untilTime and math.max(0, workspace:GetServerTimeNow() - (untilTime - slide.TotalMotionSeconds)) or nil
        local direction = flat(velocity)
        if direction.Magnitude <= 0.5 then direction = flat(cf.LookVector) end
        direction = direction.Magnitude > 1e-5 and direction.Unit or Vector3.new(0, 0, -1)
        local function padded(box)
            return { Size = box.Size + Vector3.new(1, 1, 1) * (d.M.Physics.BallRadius * 2),
                CFrameOffset = box.CFrameOffset, Shape = box.Shape }
        end
        return { character = character, position = cf.Position, cf = cf, root = { CFrame = cf },
            tilted = cf.UpVector.Y < 0.98,
            velocity = velocity, speed = math.max(runSpeed, hum.WalkSpeed, slideAge and 0 or flat(velocity).Magnitude),
            jump = math.max(0, jump), floor = floor, gravity = gravity, landAt = landAt,
            receive = padded(receive), airReceive = padded(airReceive), tackle = padded(d.M.Hitboxes.SlideTackle),
            slideAge = slideAge, slideDirection = direction, slideConstants = table.clone(slide) }
    end
    local function keepersFor(ch, team, goal, practiceGoals)
        local found, defenders, seen = {}, {}, {}
        local context = d.M.Motion.GetContext(ch)
        local opposing = not practiceGoals and d.M.Match.Constants.TeamDisplayNames[team]
            and type(d.M.Match.GetOpposingTeamName) == "function"
            and d.M.Match.GetOpposingTeamName(team) or nil
        local function add(character, actor)
            if not character or character == ch or seen[character] then return end
            seen[character] = true
            if d.M.Motion.GetContext(character) ~= context then return end
            local keeper = d.M.Match.IsGoalkeeperCharacter(character)
            local otherTeam = d.M.Teams.GetActorTeamName(actor or character)
            if not keeper and (not opposing or otherTeam ~= opposing) then return end
            -- Practice actors share a neutral Practice label. Match teams are adversarial.
            if not practiceGoals then
                if team and otherTeam == team then return end
            end
            local root = character:FindFirstChild("HumanoidRootPart")
            local hum = character:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 or (root.Position - goal.Position).Magnitude > 150 then return end
            local cf = d.M.Motion.GetCFrame(character) or root.CFrame
            if not vec(cf.Position) then return end
            if practiceGoals then
                -- Practice has several nearby goals, including two with identical names.
                -- Associate by position and Instance identity, not names or shared team labels.
                -- This is a nearest-goal heuristic; retain ties within one stud.
                local selectedDistance = (cf.Position - goal.Position).Magnitude
                for _, otherGoal in ipairs(practiceGoals) do
                    if otherGoal ~= goal and otherGoal:IsA("BasePart")
                        and (cf.Position - otherGoal.Position).Magnitude + 1 < selectedDistance then
                        return
                    end
                end
            end
            local velocity = d.M.Motion.GetVelocity(character) or root.AssemblyLinearVelocity
            if not vec(velocity) then velocity = V0 end
            if not keeper then
                table.insert(defenders, defenderSnapshot(character, root, hum, cf, velocity))
                return
            end
            local jump = hum.UseJumpPower and hum.JumpPower or math.sqrt(2 * workspace.Gravity * hum.JumpHeight)
            table.insert(found, { position = cf.Position, velocity = velocity,
                speed = math.max(24, hum.WalkSpeed, flat(velocity).Magnitude),
                jump = math.max(0, jump), character = character,
                upright = cf.UpVector.Y > 0.98 })
        end
        for _, player in ipairs(d.Players:GetPlayers()) do add(player.Character, player) end
        -- The live practice bots are direct children of Characters.NPCs.
        -- Enumerate only these two small containers, never all workspace descendants per aim read.
        local folder = workspace:FindFirstChild("Characters")
        local function addChildren(container)
            if not container then return end
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Model") then add(child) end
            end
        end
        addChildren(folder)
        addChildren(folder and folder:FindFirstChild("NPCs"))
        return found, defenders
    end
    local function frame(sample, releaseDelay)
        local timing = releaseDelay ~= nil
        if not session or (session.locked and not timing) then return nil end
        local allowed, reason = eligible()
        if not allowed then return skipFrame(reason) end
        local ch = d.Player.Character
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not root then return skipFrame("no_character") end
        if typeof(sample) ~= "table" or not vec(sample.Origin)
            or not vec(sample.Direction) or typeof(sample.CameraCFrame) ~= "CFrame" then return skipFrame("invalid_sample") end
        local world = N.Preview.GetChargeBoundaryWorld(d.Player)
        local origin = N.Carry.GetLaunchPosition(ch)
        if not world then return skipFrame("no_world") end
        if not vec(origin) then return skipFrame("no_launch") end
        origin = d.M.Physics.GetContainedGroundPosition(origin, d.M.Physics.BallRadius, world)
        local goal, team, practiceGoals = goalFor(origin)
        if not goal then return skipFrame("no_goal") end
        local mouth = mouthFor(goal, origin)
        if not mouth or (origin - mouth.plane):Dot(mouth.forward) <= 0.2 then return skipFrame("invalid_goal") end
        session.distance = mouthDistance(mouth, origin)
        if session.distance > C.MaxAssistDistance then
            session.reason = "out_of_range"
            setStatus("OUT OF RANGE", string.format("%.2f / %d studs | Normal aim", session.distance, C.MaxAssistDistance))
            return nil
        end
        local constants = session.constants or N.Power.GetChargeConstants(ch, N.Shoot.Constants.Kick)
        session.constants = constants
        local elapsed = math.max(0, os.clock() - session.started)
        if timing then
            -- Use the native charge epoch and its clock, not the wrapper's entry time.
            if not num(session.chargeStartedAt) then return nil end
            elapsed = d.M.Clock.GetSmoothedServerTime() - session.chargeStartedAt
            if not num(elapsed) or elapsed < 0 then return nil end
        end
        local minimum = N.Core.GetMinimumReleaseSeconds(constants)
        local maximum = constants.MaximumChargeSeconds
        local charge = math.clamp(math.max(minimum, elapsed), minimum, maximum)
        local lockCharge = math.max(minimum, maximum - N.Core.Constants.AimLockSeconds)
        -- Before the native lock, prefer an aim tested across the remaining charge range.
        local volley = not ownsBall() and N.Client.IsVolleyCharging()
        session.volley = volley
        local remaining, imminent = 0, true
        if volley then
            if session.volleyRefused or not N.Volley.CanPredictVolleyLaunch(d.Player) then
                session.reason = "waiting_volley"
                setStatus("WAITING FOR PASS", "Native volley claim is not confirmed | Normal aim")
                return nil
            end
            remaining = N.Volley.GetReleaseRemainingSeconds(d.Player, session.volleyArrival)
            if not num(remaining) or remaining > C.VolleyPrepareSeconds then
                session.reason = "waiting_volley"
                setStatus("WAITING FOR PASS", "Aim will be checked near the native volley arrival")
                return nil
            end
            remaining = math.max(0, remaining)
            imminent = N.Volley.IsStrikeImminent(d.Player, session.volleyArrival)
            charge = math.clamp(math.max(minimum, elapsed + remaining), minimum, maximum)
        end
        -- Non-owner volleys keep updating aim while waiting; they do not use the owned-ball lock.
        local approachingLock = not timing and not volley and not session.releasing and elapsed >= lockCharge - 0.08
        local charges = approachingLock and { lockCharge, (lockCharge + maximum) / 2, maximum } or { charge }
        local velocity = flat(root.AssemblyLinearVelocity)
        local lead = volley and math.max(remaining, minimum - elapsed, 0)
            or (approachingLock and math.max(0, maximum - elapsed) or math.max(0, minimum - elapsed))
        if timing then
            if volley then return nil end
            charge = math.clamp(elapsed + releaseDelay, minimum, maximum)
            charges = { charge }
            lead = math.max(releaseDelay, minimum - elapsed, 0)
        end
        local nowOrigin = origin
        local delta = velocity * lead
        local airborneProjection
        if sample.IsAirborne and lead > 0 then
            local hum = ch:FindFirstChildOfClass("Humanoid")
            local floor = d.M.Grounding.GetStandingY(hum, root)
            airborneProjection = { y = root.Position.Y, velocityY = root.AssemblyLinearVelocity.Y, floor = floor }
            local y = math.max(floor, root.Position.Y + root.AssemblyLinearVelocity.Y * lead - workspace.Gravity * lead * lead / 2)
            delta += Vector3.new(0, y - root.Position.Y, 0)
        end
        -- The native release launches from Carry.GetLaunchPosition, including volleys.
        -- Extrapolate that carry point for the short wait, without changing the outgoing camera metadata.
        origin = d.M.Physics.GetContainedGroundPosition(origin + delta, d.M.Physics.BallRadius, world)
        delta = origin - nowOrigin
        session.distance = math.max(session.distance, mouthDistance(mouth, origin))
        if session.distance > C.MaxAssistDistance then
            session.reason = "out_of_range"
            setStatus("OUT OF RANGE", "Predicted release leaves the close-range zone | Normal aim")
            return nil
        end
        local curve = N.Curves.IsEnabled() and (session.curve or 0) or 0
        local keepers, defenders = keepersFor(ch, team, goal, practiceGoals)
        return { character = ch, root = root, origin = origin, velocity = velocity,
            verticalSpeed = math.abs(root.AssemblyLinearVelocity.Y),
            sample = sample, goal = goal, goalCF = goal.CFrame, world = world, mouth = mouth,
            charge = approachingLock and maximum or charge, charges = charges,
            minimumCharge = minimum, maximumCharge = maximum,
            elapsed = elapsed,
            lead = lead, aimOffset = delta, volley = volley, canApply = imminent,
            releaseProjection = approachingLock and { origin = nowOrigin, airborne = airborneProjection, reachProfiles = {} } or nil,
            distance = session.distance, arrivalRemaining = remaining,
            curve = curve, autoCurve = session.autoCurve == true and N.Curves.IsEnabled() and N.Curves.GetPower() > 0,
            boost = N.Power.GetMultiplier(ch), curvePower = N.Curves.GetPower(),
            keepers = keepers, defenders = defenders, at = d.M.Clock.GetSmoothedServerTime(),
            radius = d.M.Physics.BallRadius, clock = os.clock(), team = team,
            context = d.M.Motion.GetContext(ch), ballId = ballId() }
    end
    local function aimAt(f, yaw, pitch)
        local aim = table.clone(f.sample)
        aim.Direction = Vector3.new(math.sin(yaw) * math.cos(pitch), math.sin(pitch), math.cos(yaw) * math.cos(pitch))
        -- Keep real camera/origin metadata; this is a camera aim, not a reported hit.
        aim.ClientHit, aim.TargetPosition = nil, nil
        return aim
    end
    local function angles(direction)
        return math.atan2(direction.X, direction.Z), math.atan2(direction.Y, flat(direction).Magnitude)
    end
    local function launch(f, aim, charge)
        local kick = flat(aim.Direction)
        if kick.Magnitude < 1e-6 then return nil end
        stats.evaluations += 1
        local predictedAim = table.clone(aim)
        predictedAim.Origin += f.aimOffset or V0
        predictedAim.CameraCFrame += f.aimOffset or V0
        local velocity = N.RawLaunch(f.character, charge or f.charge,
            d.M.Actions.PassTypes.Shot, predictedAim, f.origin, f.velocity, kick.Unit, nil,
            f.boost, f.world, nil, f.curve)
        if not vec(velocity) then return nil end
        local spin = N.RawSpin(f.character, velocity, f.velocity, f.curve, charge or f.charge)
        if not vec(spin) then return nil end
        return velocity, spin
    end
    local function freeCross(f, velocity, spin)
        local mouth = f.mouth
        local startDistance = (f.origin - mouth.plane):Dot(mouth.forward)
        local lastT, lastD = 0, startDistance
        for t = 0.10, C.Horizon + 0.001, 0.10 do
            local pos = d.M.Physics.GetAirFlight(f.origin, velocity, spin, t)
            local distance = (pos - mouth.plane):Dot(mouth.forward)
            if lastD > 0 and distance <= 0 then
                local lo, hi = lastT, t
                for _ = 1, 9 do
                    local mid = (lo + hi) / 2
                    local p = d.M.Physics.GetAirFlight(f.origin, velocity, spin, mid)
                    if (p - mouth.plane):Dot(mouth.forward) > 0 then lo = mid else hi = mid end
                end
                local hit = d.M.Physics.GetAirFlight(f.origin, velocity, spin, (lo + hi) / 2)
                return Vector2.new((hit - mouth.center):Dot(mouth.lateral), hit.Y), (lo + hi) / 2
            end
            lastT, lastD = t, distance
        end
        return nil
    end
    local function planeEval(f, yaw, pitch)
        local aim = aimAt(f, yaw, pitch)
        local velocity, spin = launch(f, aim)
        local hit = velocity and freeCross(f, velocity, spin)
        coroutine.yield()
        return hit
    end
    local function solve(f, target, seed)
        local point = f.mouth.center + f.mouth.lateral * target.X
        point = Vector3.new(point.X, target.Y, point.Z)
        local direction = point - (f.sample.Origin + (f.aimOffset or V0))
        if direction.Magnitude < 1e-4 then return nil end
        local yaw, pitch = angles(direction.Unit)
        local directYaw, directPitch = yaw, pitch
        local seeded = false
        -- Reuse a local aim-to-goal derivative from this job to start nearby targets.
        -- This is only a starting guess; native flight and goal-entry checks still decide validity.
        if seed and seed.hit and (target - seed.hit).Magnitude <= 8 then
            local error2 = target - seed.hit
            local determinant = seed.dx.X * seed.dy.Y - seed.dy.X * seed.dx.Y
            if math.abs(determinant) > 1e-5 then
                yaw = seed.yaw + math.clamp((error2.X * seed.dy.Y - seed.dy.X * error2.Y) / determinant, -0.6, 0.6)
                pitch = math.clamp(seed.pitch + math.clamp((seed.dx.X * error2.Y - error2.X * seed.dx.Y) / determinant, -0.45, 0.45), -1.25, 1.25)
                seeded = true
            end
        end
        local bestError, bestAim = math.huge, nil
        for _ = 1, 4 do
            local hit = planeEval(f, yaw, pitch)
            if not hit and seeded then
                yaw, pitch, seeded = directYaw, directPitch, false
                hit = planeEval(f, yaw, pitch)
            end
            if not hit then return bestAim end
            local error2 = target - hit
            if error2.Magnitude < bestError then bestError, bestAim = error2.Magnitude, aimAt(f, yaw, pitch) end
            if bestError < 0.30 then break end
            local epsilon = 0.012
            local hx, hy = planeEval(f, yaw + epsilon, pitch), planeEval(f, yaw, pitch + epsilon)
            if not hx or not hy then break end
            local dx, dy = (hx - hit) / epsilon, (hy - hit) / epsilon
            local determinant = dx.X * dy.Y - dy.X * dx.Y
            if math.abs(determinant) < 1e-5 then break end
            if seed then
                seed.hit, seed.yaw, seed.pitch, seed.dx, seed.dy = hit, yaw, pitch, dx, dy
            end
            yaw += math.clamp((error2.X * dy.Y - dy.X * error2.Y) / determinant, -0.25, 0.25)
            pitch = math.clamp(pitch + math.clamp((dx.X * error2.Y - error2.X * dx.Y) / determinant, -0.2, 0.2), -1.25, 1.25)
        end
        return bestAim
    end
    local function horizontalReach(seconds, speed)
        local dive, assist = d.M.Dive.Constants, d.M.Assist.Constants
        local distance = dive.Distance + assist.MaximumExtraReachStuds
        local scale, duration = assist.MaximumTravelScale, dive.DurationSeconds
        -- Maximize runTime * speed + cubicDive(diveTime), subject to runTime + diveTime = seconds.
        -- Unlike 0.2 this never credits a full run and full dive over the same time interval.
        local peak = duration / scale * (1 - math.sqrt(speed * duration / (3 * distance * scale)))
        local diveSeconds = math.clamp(peak, 0, math.min(seconds, dive.HitboxCurveSeconds))
        return math.max(speed * seconds,
            d.M.Dive.GetTravel(diveSeconds * scale, distance) + speed * (seconds - diveSeconds))
    end
    local function keeperGap(f, first, second, t)
        local gap = math.huge
        local dive = d.M.Dive.Constants
        local assist = d.M.Assist.Constants
        local box = d.M.Hitboxes.AirReceive
        local padding = math.max(d.M.Contacts.Constants.ContactPadding, f.radius * 2)
        -- Sphere enclosing the padded box and offset, including tilted dive roots.
        local horizontalBox = (box.Size + Vector3.new(padding, padding, padding)).Magnitude / 2
            + box.CFrameOffset.Position.Magnitude
        local verticalBox = horizontalBox
        for _, keeper in ipairs(f.keepers) do
            -- Expanded reachable volume: any dive direction plus locomotion, jump and latency.
            -- This is a conservative estimate, not an exact future keeper action.
            local lead = t + f.lead + C.NetworkMargin
            local radius = horizontalBox + horizontalReach(lead, keeper.speed)
            local delta = flat(second - first)
            local toKeeper = flat(keeper.position - first)
            local alpha = delta:Dot(delta) > 1e-8 and math.clamp(toKeeper:Dot(delta) / delta:Dot(delta), 0, 1) or 0
            local closest = first:Lerp(second, alpha)
            local horizontal = flat(closest - keeper.position).Magnitude - radius
            local jumpHeight = keeper.jump ^ 2 / math.max(2 * workspace.Gravity, 1)
            local top = keeper.position.Y + verticalBox + jumpHeight
                + math.max(0, keeper.velocity.Y) * lead
                + (dive.InitialVerticalVelocity + assist.MaximumVerticalVelocityChange) * math.min(t, dive.HitboxCurveSeconds)
            local bottom = keeper.position.Y - verticalBox - workspace.Gravity * lead * lead / 2
            local vertical = math.max(math.min(first.Y, second.Y) - top, bottom - math.max(first.Y, second.Y))
            gap = math.min(gap, math.max(horizontal, vertical))
        end
        return gap
    end
    local function reachProfile(f, keeper, t)
        local dive, assist = d.M.Dive.Constants, d.M.Assist.Constants
        local box = d.M.Hitboxes.AirReceive
        local padding = math.max(d.M.Contacts.Constants.ContactPadding, f.radius * 2)
        local offset = box.CFrameOffset.Position
        local halfWidth = math.max(box.Size.X, box.Size.Z) / 2 + padding / 2 + flat(offset).Magnitude
        local topOffset = offset.Y + (box.Size.Y + padding) / 2
        local gravity = math.max(workspace.Gravity, 1)
        local available = math.max(0, t + f.lead + C.NetworkMargin)
        local diveLimit = math.min(available, dive.HitboxCurveSeconds)
        local distance = dive.Distance + assist.MaximumExtraReachStuds
        local scale = assist.MaximumTravelScale
        local function jumpRise(seconds)
            -- Allow an optimally delayed jump or an already rising keeper.
            local speed = math.max(keeper.jump, keeper.velocity.Y, 0)
            local elapsed = math.min(seconds, speed / gravity)
            return math.max(0, speed * elapsed - 0.5 * gravity * elapsed * elapsed)
        end
        local profile = { halfWidth + keeper.speed * available, topOffset + jumpRise(available) }
        local function add(diveSeconds)
            local before = available - diveSeconds
            local radius = halfWidth + keeper.speed * before + d.M.Dive.GetTravel(diveSeconds * scale, distance)
            local rise = math.max(0, dive.InitialVerticalVelocity * diveSeconds
                + 0.5 * (dive.GravityStudsPerSecondSquared or -65) * diveSeconds * diveSeconds)
            -- Same maximum lift/time relationship as native GetReachableContactHeight.
            local lift = assist.MaximumVerticalVelocityChange * diveSeconds
                / (1 + 0.5 * (assist.LiftGravityPerStud or 15) * diveSeconds * diveSeconds)
            profile[#profile + 1] = radius
            profile[#profile + 1] = topOffset + jumpRise(before) + rise + lift
        end
        for i = 0, 6 do add(diveLimit * i / 6) end
        -- Include the exact horizontal run/dive optimum between the uniform samples.
        local peak = dive.DurationSeconds / scale
            * (1 - math.sqrt(keeper.speed * dive.DurationSeconds / (3 * distance * scale)))
        add(math.clamp(peak, 0, diveLimit))
        return profile
    end
    local function reachDemand(f, first, second, t)
        -- Comparative difficulty only. The larger keeperGap envelope remains the
        -- conservative reach diagnostic; this sampled model cannot certify a goal.
        -- Frames contain immutable keeper snapshots. Share only movement envelopes
        -- at identical times; every trajectory still receives its own collision check.
        local cache = f.reachProfiles
        if not cache then cache = {}; f.reachProfiles = cache end
        local profiles = cache[t]
        if not profiles then profiles = {}; cache[t] = profiles end
        local segment = flat(second - first)
        local lengthSquared = segment:Dot(segment)
        local lowY = math.min(first.Y, second.Y)
        local minimum, difficulty = math.huge, math.huge
        for _, keeper in ipairs(f.keepers) do
            if keeper.upright == false then
                local fallback = math.max(0, 1 + keeperGap(f, first, second, t) / d.M.Dive.Constants.Distance)
                return fallback, fallback
            end
            local alpha = lengthSquared > 1e-8
                and math.clamp(flat(keeper.position - first):Dot(segment) / lengthSquared, 0, 1) or 0
            local separation = flat(first:Lerp(second, alpha) - keeper.position).Magnitude
            local profile = profiles[keeper]
            if not profile then profile = reachProfile(f, keeper, t); profiles[keeper] = profile end
            local best = math.huge
            local height = math.max(0, lowY - keeper.position.Y)
            for i = 1, #profile, 2 do
                -- Fraction of horizontal/vertical reach required together. A signed
                -- box penetration would saturate on low-ball height and could prefer
                -- an easy central shot over a further corner.
                local horizontal = separation / math.max(profile[i], 0.01)
                local vertical = height / math.max(profile[i + 1], 0.01)
                best = math.min(best, math.max(horizontal, vertical))
                -- Ranking only: simultaneous sideways and upward effort is harder than
                -- either alone. Keep this separate from the conservative reach verdict.
                -- The old max-only score treated height below the horizontal demand as free.
                difficulty = math.min(difficulty, math.max(horizontal, vertical)
                    + 0.20 * math.min(horizontal, vertical))
            end
            minimum = math.min(minimum, best)
        end
        return minimum, difficulty
    end
    local function defenderOffset(defender, seconds)
        local horizontal = flat(defender.velocity) * seconds
        if defender.slideAge then
            local c = defender.slideConstants
            local travel = N.Tackle.GetMaximumTravelBetween(defender.slideAge,
                defender.slideAge + seconds, c.StartupDashDistance, c.Distance)
            horizontal = defender.slideDirection * travel
        end
        local y = defender.floor
        if seconds < defender.landAt then
            y = math.max(y, defender.position.Y + defender.velocity.Y * seconds - defender.gravity * seconds * seconds / 2)
        end
        return horizontal + UP * (y - defender.position.Y)
    end
    local function defenderProfile(f, defender, t0, t1)
        local cache = f.defenderProfiles
        if not cache then cache = {}; f.defenderProfiles = cache end
        local atTime = cache[t1]
        if not atTime then atTime = {}; cache[t1] = atTime end
        local cached = atTime[defender]
        if cached and cached.t0 == t0 then return cached end
        local a, b = f.lead + t0, f.lead + t1
        local offset0, offset1 = defenderOffset(defender, a), defenderOffset(defender, b)
        local airborne0, airborne1 = a < defender.landAt, b < defender.landAt
        local box0 = airborne0 and defender.airReceive or defender.receive
        local box1 = airborne1 and defender.airReceive or defender.receive
        local available = math.max(0, b + C.NetworkMargin)
        local jumpTime = math.min(math.max(0, available - defender.landAt), defender.jump / defender.gravity)
        local jumpRise = math.max(0, defender.jump * jumpTime - defender.gravity * jumpTime * jumpTime / 2)
        local receiveTop = defender.receive.CFrameOffset.Y + defender.receive.Size.Y / 2
        local airTop = defender.airReceive.CFrameOffset.Y + defender.airReceive.Size.Y / 2
        local groundBottom = defender.receive.CFrameOffset.Y - defender.receive.Size.Y / 2
        local airBottom = defender.airReceive.CFrameOffset.Y - defender.airReceive.Size.Y / 2
        local low = math.min(defender.position.Y + offset0.Y + (airborne0 and airBottom or groundBottom),
            defender.position.Y + offset1.Y + (airborne1 and airBottom or groundBottom))
        local high = math.max(defender.position.Y + offset0.Y + (airborne0 and airTop or receiveTop),
            defender.position.Y + offset1.Y + (airborne1 and airTop or receiveTop))
        if available > defender.landAt then high = math.max(high, defender.floor + airTop + jumpRise) end
        local halfWidth = math.max(defender.receive.Size.X, defender.receive.Size.Z,
            defender.airReceive.Size.X, defender.airReceive.Size.Z) / 2
        local horizontal = defender.speed * available
        local slideReach, slideWindow0, slideWindow1
        local c = defender.slideConstants
        if defender.slideAge then
            -- Existing slide: use its replicated phase and bounded native travel.
            -- Do not credit a second full dash in the same available interval.
            horizontal = math.max(horizontal, flat(offset1).Magnitude)
            slideWindow0 = math.max(a, c.HitboxDelaySeconds - defender.slideAge)
            slideWindow1 = math.min(b, c.HitboxDelaySeconds + c.HitboxSeconds - defender.slideAge)
            if slideWindow0 <= slideWindow1 then
                slideReach = N.Tackle.GetMaximumTravelBetween(defender.slideAge,
                    defender.slideAge + slideWindow1, c.StartupDashDistance, c.Distance)
            end
        else
            -- Possible new tackle: run BEFORE starting it, then travel during its
            -- actual hitbox window. Unknown future input/stamina remains an estimate.
            local maxAge = math.min(c.HitboxDelaySeconds + c.HitboxSeconds, available - defender.landAt)
            if maxAge >= c.HitboxDelaySeconds then
                for i = 0, 4 do
                    local age = c.HitboxDelaySeconds + (maxAge - c.HitboxDelaySeconds) * i / 4
                    local travel = N.Tackle.GetMaximumTravelBetween(0, age, c.StartupDashDistance, c.Distance)
                    slideReach = math.max(slideReach or 0, defender.speed * (available - age) + travel)
                end
            end
        end
        if slideReach then
            local box = defender.tackle
            slideReach += flat(box.CFrameOffset.Position).Magnitude + math.sqrt(box.Size.X ^ 2 + box.Size.Z ^ 2) / 2
        end
        cached = { t0 = t0, a = a, b = b, offset0 = offset0, offset1 = offset1,
            box0 = box0, box1 = box1, radius = horizontal + halfWidth, low = low, high = high,
            slideReach = slideReach, slideLow = defender.floor + defender.tackle.CFrameOffset.Y - defender.tackle.Size.Y / 2,
            slideHigh = defender.floor + defender.tackle.CFrameOffset.Y + defender.tackle.Size.Y / 2,
            slideWindow0 = slideWindow0, slideWindow1 = slideWindow1 }
        atTime[defender] = cached
        return cached
    end
    local function defenderDemand(f, first, second, t0, t1)
        if not f.defenders or #f.defenders == 0 then return math.huge, 0 end
        local dx, dz = second.X - first.X, second.Z - first.Z
        local lengthSquared = dx * dx + dz * dz
        local lowY, highY = math.min(first.Y, second.Y), math.max(first.Y, second.Y)
        local minimum, risk = math.huge, 0
        for _, defender in ipairs(f.defenders) do
            local p = defenderProfile(f, defender, t0, t1)
            local x, z = first.X - defender.position.X, first.Z - defender.position.Z
            local alpha = lengthSquared > 1e-8
                and math.clamp(-(x * dx + z * dz) / lengthSquared, 0, 1) or 0
            x, z = x + dx * alpha, z + dz * alpha
            local distance = math.sqrt(x * x + z * z)
            local vertical = math.max(lowY - p.high, p.low - highY, 0)
            local value = math.max(distance / math.max(p.radius, 0.01), vertical > 0 and 1 + vertical / 4 or 0)
            if p.slideReach then
                vertical = math.max(lowY - p.slideHigh, p.slideLow - highY, 0)
                value = math.min(value, math.max(distance / math.max(p.slideReach, 0.01), vertical > 0 and 1 + vertical / 4 or 0))
            end
            minimum = math.min(minimum, value)
            if value <= 1 then risk = math.max(risk, 1) end
            -- Relative swept segments catch a moving defender crossing the ball
            -- between samples. Use native oval/box tests, not endpoint proximity.
            local direct = false
            if risk < 2 and (value <= 1 or defender.tilted) then
                local from, to = first - p.offset0, second - p.offset1
                if p.box1 ~= p.box0 then
                    -- Split at landing: the taller airborne box must not extend
                    -- into the grounded part of this sample interval.
                    local alphaAtLanding = math.clamp((defender.landAt - p.a) / math.max(p.b - p.a, 1e-8), 0, 1)
                    local landing = first:Lerp(second, alphaAtLanding) - defenderOffset(defender, defender.landAt)
                    direct = d.M.Hitboxes.GetSegmentEnterAlpha(defender.root, p.box0, from, landing) ~= nil
                        or d.M.Hitboxes.GetSegmentEnterAlpha(defender.root, p.box1, landing, to) ~= nil
                else
                    direct = d.M.Hitboxes.GetSegmentEnterAlpha(defender.root, p.box0, from, to) ~= nil
                end
                if not direct and p.slideWindow0 and p.slideWindow0 <= p.slideWindow1 then
                    local duration = math.max(p.b - p.a, 1e-8)
                    local slideFrom = first:Lerp(second, (p.slideWindow0 - p.a) / duration) - defenderOffset(defender, p.slideWindow0)
                    local slideTo = first:Lerp(second, (p.slideWindow1 - p.a) / duration) - defenderOffset(defender, p.slideWindow1)
                    direct = d.M.Hitboxes.GetSegmentEnterAlpha(defender.root, defender.tackle, slideFrom, slideTo) ~= nil
                end
            end
            if direct then risk = 2 end
        end
        return minimum, risk
    end
    local function betterRating(a, b)
        if not a then return false end
        if not b then return true end
        local ar, br = a.defenderRisk or 0, b.defenderRisk or 0
        if ar ~= br then return ar < br end
        return a.score > b.score
    end
    local function hasObstruction(f, hits)
        if not hits then return false end
        -- Goal-volume entry can happen AFTER a post/wall rebound. Only contacts
        -- on the native ground surfaces are allowed before the shot reaches goal.
        local ground = f.groundParts
        if not ground then
            ground = {}
            for _, solid in ipairs(f.world.GroundSolids or {}) do
                if solid.Part then ground[solid.Part] = true end
            end
            f.groundParts = ground
        end
        local constants = d.M.Physics.Constants
        local minimumY = constants and constants.Solver and constants.Solver.MinimumGroundNormalY or 0.55
        for _, hit in ipairs(hits) do
            local normal = hit.FaceNormal or hit.Normal
            if not ground[hit.Part] or not vec(normal) or normal.Y < minimumY then return true end
        end
        return false
    end
    local function cornerPreference(mouth, position)
        -- Small tie preference for safe upper corners, subordinate to modeled
        -- interception difficulty and the separate defender-risk ordering.
        local height = math.clamp((position.Y - mouth.bottom) / math.max(mouth.top - mouth.bottom, 0.01), 0, 1)
        local width = math.clamp(math.abs((position - mouth.center):Dot(mouth.lateral)) / math.max(mouth.halfWidth, 0.01), 0, 1)
        return 0.20 * height * width
    end
    local function crossbarMargin(f)
        if not (f.volley or f.sample.IsAirborne) then return C.EdgeMargin end
        -- Airborne carry/camera samples and the actual strike can land on different
        -- update ticks. Reserve one aim-update interval of vertical travel, with
        -- bounded extra headroom; do not lower ordinary grounded shot targets.
        local dt = 1 / C.SampleHz
        local motion = (f.verticalSpeed or 0) * dt + workspace.Gravity * dt * dt / 2
        return C.EdgeMargin + math.clamp(C.TargetSlack + motion, C.TargetSlack, 1.5)
    end
    local function crossbarSweep(f, first, second)
        -- Clip the swept segment to the frame vicinity. On approach only the
        -- spherical cap overlaps the front plane: a steep descending volley can
        -- strike the bar before its center reaches the otherwise-safe entry.
        local mouth, radius = f.mouth, f.radius
        local a = (first - mouth.plane):Dot(mouth.forward)
        local b = (second - mouth.plane):Dot(mouth.forward)
        local rear = -(math.min(mouth.depth or 0, 2 * radius) + radius)
        local lo, hi = 0, 1
        local delta = b - a
        if math.abs(delta) < 1e-6 then
            if a > radius or a < rear then return nil end
        else
            local frontT, rearT = (radius - a) / delta, (rear - a) / delta
            lo, hi = math.max(0, math.min(frontT, rearT)), math.min(1, math.max(frontT, rearT))
            if lo > hi then return nil end
        end
        local best
        local function consider(t)
            if t < lo or t > hi then return end
            local p = first:Lerp(second, t)
            local depth = math.max(0, a + delta * t)
            local cap = math.sqrt(math.max(0, radius * radius - depth * depth))
            local adjusted = Vector3.new(p.X, p.Y + cap - radius, p.Z)
            if not best or adjusted.Y > best.Y then best = adjusted end
        end
        consider(lo); consider(hi)
        if math.abs(delta) > 1e-6 then
            consider(-a / delta)
            local slope = (second.Y - first.Y) / delta
            if slope > 0 then
                local peakDepth = radius * slope / math.sqrt(1 + slope * slope)
                consider((peakDepth - a) / delta)
            end
        end
        return best
    end
    local function validate(f, aim, charge, yielding)
        local velocity, spin = launch(f, aim, charge)
        if yielding then coroutine.yield() end
        if not velocity then return nil end
        local launchAt = f.at + f.lead
        local state = d.M.Physics.NewState(f.origin, velocity, f.radius, launchAt, spin)
        local position, time = d.M.Prediction.GetGoalCrossing(state, f.world, f.goal, launchAt, C.Horizon)
        if yielding then coroutine.yield() end
        if not vec(position) or not num(time) then return nil end
        local eta = time - launchAt
        if eta <= 0 or eta > C.Horizon then return nil end
        local mouth = f.mouth
        local topLimit = mouth.top - f.radius - crossbarMargin(f)
        local edge = math.min(mouth.halfWidth - math.abs((position - mouth.center):Dot(mouth.lateral)), mouth.top - position.Y)
        -- Keep the whole ball inside the opening, not just its centre. The same
        -- check is used for current aim, searched candidates and smart release.
        if position.Y < mouth.bottom then return nil end
        if edge - f.radius < C.EdgeMargin then return nil, position end
        if position.Y > topLimit then return nil, position end
        local minGap, minDemand, minDifficulty, previous = math.huge, math.huge, math.huge, f.origin
        local defenderReach, defenderRisk, previousT = math.huge, 0, 0
        local cursor = state
        local count = math.ceil(eta / C.Step)
        for i = 1, count do
            -- Common sample times reuse the frame's keeper envelopes across aims and
            -- charges. The final sample is still the exact goal-entry time.
            local t = math.min(C.Step * i, eta)
            cursor = d.M.Physics.GetStateAtTime(cursor, launchAt + t, f.world, {})
            if not cursor or not vec(cursor.Position) then return nil end
            if hasObstruction(f, cursor.BoundaryHits) then return nil end
            local barPoint = crossbarSweep(f, previous, cursor.Position)
            if barPoint and barPoint.Y > topLimit then return nil, barPoint end
            minGap = math.min(minGap, keeperGap(f, previous, cursor.Position, t))
            local demand, difficulty = reachDemand(f, previous, cursor.Position, t)
            minDemand, minDifficulty = math.min(minDemand, demand), math.min(minDifficulty, difficulty)
            local defenderRequired, risk = defenderDemand(f, previous, cursor.Position, previousT, t)
            defenderReach, defenderRisk = math.min(defenderReach, defenderRequired), math.max(defenderRisk, risk)
            previousT = t
            previous = cursor.Position
            if yielding and i % 8 == 0 then coroutine.yield() end
        end
        -- The native entry observer interpolates between physics positions. Also
        -- check the actual sampled position at its reported crossing time.
        edge = math.min(edge, mouth.halfWidth - math.abs((cursor.Position - mouth.center):Dot(mouth.lateral)),
            mouth.top - cursor.Position.Y)
        if edge - f.radius < C.EdgeMargin then return nil, cursor.Position end
        if cursor.Position.Y > topLimit then return nil, cursor.Position end
        -- FirstBoxEntry reports the center entering the scoring volume. The ball
        -- can still rise into the bar or bend into a post immediately afterward.
        -- Follow it through the mouth (at most one ball diameter of goal depth)
        -- until its trailing edge clears. Do not simulate on to the back net.
        local clearanceDepth = math.min(mouth.depth or 0, 2 * f.radius) + f.radius
        local passageTime = eta
        for _ = 1, 8 do
            local remaining = (cursor.Position - mouth.plane):Dot(mouth.forward) + clearanceDepth
            if remaining <= 1e-4 then break end
            local motion = vec(cursor.Velocity) and cursor.Velocity or velocity
            local inward = -motion:Dot(mouth.forward)
            if inward <= 1e-4 then return nil end
            local dt = math.min(C.Step, math.max(0.001, remaining / inward))
            passageTime += dt
            local passageStart = cursor.Position
            cursor = d.M.Physics.GetStateAtTime(cursor, launchAt + passageTime, f.world, {})
            if not cursor or not vec(cursor.Position) then return nil end
            if hasObstruction(f, cursor.BoundaryHits) then
                -- Use the unreflected flight only as a repair hint. The repaired
                -- direction must pass the complete native collision check again.
                return nil, d.M.Physics.GetAirFlight(f.origin, velocity, spin, passageTime)
            end
            -- Do not depend on the preview world including the crossbar solid.
            -- A rising volley must stay below it throughout the frame passage,
            -- not merely at the first center-entry sample.
            local barPoint = crossbarSweep(f, passageStart, cursor.Position)
            if barPoint and barPoint.Y > topLimit then return nil, barPoint end
        end
        if (cursor.Position - mouth.plane):Dot(mouth.forward) + clearanceDepth > 1e-4 then return nil end
        if #f.keepers == 0 then minGap, minDemand, minDifficulty = nil, nil, nil end
        return { gap = minGap, reachDemand = minDemand, difficulty = minDifficulty, predictionCharge = charge,
            score = (minDifficulty and (minDifficulty - 1) * d.M.Dive.Constants.Distance or 0)
                - eta * 0.35 + math.min(edge, 2) * 0.08
                + cornerPreference(mouth, position)
                - math.clamp(1 - defenderReach, 0, 1) * d.M.Dive.Constants.Distance,
            defenderDemand = defenderReach < math.huge and defenderReach or nil, defenderRisk = defenderRisk,
            eta = eta, position = position, keepers = #f.keepers, edgeClearance = edge - f.radius }
    end
    local function releaseFrame(f, charge)
        local projection = f.releaseProjection
        if not projection then return f end
        local lead = math.max(0, charge - f.elapsed)
        if math.abs(lead - f.lead) < 1e-8 then return f end
        local at = table.clone(f)
        local delta = f.velocity * lead
        local air = projection.airborne
        if air then
            local y = math.max(air.floor, air.y + air.velocityY * lead - workspace.Gravity * lead * lead / 2)
            delta += Vector3.new(0, y - air.y, 0)
        end
        at.origin = d.M.Physics.GetContainedGroundPosition(projection.origin + delta, f.radius, f.world)
        at.aimOffset, at.lead = at.origin - projection.origin, lead
        -- Reach envelopes include waiting time; another release time needs its own cache.
        local profiles = projection.reachProfiles[lead]
        if not profiles then profiles = {}; projection.reachProfiles[lead] = profiles end
        at.reachProfiles = profiles
        return at
    end
    local function rate(f, aim, yielding)
        local ranked, conservativeGap, clearance, defenderReach, defenderRisk
        for _, charge in ipairs(f.charges) do
            -- Earlier releases move the carrier/camera less and give the keeper less
            -- preparation time than the full-charge release in this same aim window.
            local result, edgePosition = validate(releaseFrame(f, charge), aim, charge, yielding)
            if not result then return nil, edgePosition end
            if result.gap ~= nil then conservativeGap = math.min(conservativeGap or math.huge, result.gap) end
            clearance = math.min(clearance or math.huge, result.edgeClearance)
            if result.defenderDemand then defenderReach = math.min(defenderReach or math.huge, result.defenderDemand) end
            defenderRisk = math.max(defenderRisk or 0, result.defenderRisk or 0)
            -- Every possible locked release must still enter the goal safely.
            -- Rank difficulty at the intended charge, rather than letting a slower
            -- early-release forecast dominate a held, full-power shot.
            if not ranked or math.abs(charge - f.charge) < math.abs(ranked.predictionCharge - f.charge) then ranked = result end
        end
        if ranked then
            ranked.gap, ranked.edgeClearance = conservativeGap, clearance
            ranked.defenderDemand, ranked.defenderRisk = defenderReach, defenderRisk
        end
        return ranked
    end
    local function compatible(a, b)
        return a and b and a.character == b.character and a.goal == b.goal and a.goalCF == b.goalCF
            -- World tables are proposal inputs, not reusable collision verdicts.
            -- Every chosen direction is validated again against b.world before it is applied.
            and a.context == b.context and a.ballId == b.ballId and a.team == b.team
            and a.curve == b.curve and a.autoCurve == b.autoCurve and a.boost == b.boost and a.curvePower == b.curvePower
            and a.volley == b.volley and a.sample.IsAirborne == b.sample.IsAirborne and (a.origin - b.origin).Magnitude < 8
            -- Sprint/charge slowdown changes velocity abruptly. Let proposals finish;
            -- fresh validation uses b.velocity and b.world before any direction is applied.
    end
    local function candidateAim(entry, f)
        local direction = entry.direction
        local oldOrigin = entry.frame.sample.Origin + (entry.frame.aimOffset or V0)
        local origin = f.sample.Origin + (f.aimOffset or V0)
        local denominator = direction:Dot(f.mouth.forward)
        -- Preserve the candidate's camera-ray point on the goal plane as the shooter moves.
        -- This transports a starting direction, not a contact result: rate() must still validate it now.
        if (origin - oldOrigin).Magnitude > 1e-5 and math.abs(denominator) > 1e-5 then
            local distance = (f.mouth.plane - oldOrigin):Dot(f.mouth.forward) / denominator
            local delta = oldOrigin + direction * distance - origin
            if distance > 0 and vec(delta) and delta.Magnitude > 1e-5 then direction = delta.Unit end
        end
        local yaw, pitch = angles(direction)
        return aimAt(f, yaw, pitch)
    end
    local function insetAim(f, aim, position)
        -- A transported corner proposal can drift towards a post. Use its fresh
        -- crossing as a correction hint, then validate again within the existing
        -- two-proposal limit. This approximation never authorizes an aim by itself.
        local mouth = f.mouth
        local inset = f.radius + C.EdgeMargin + C.TargetSlack
        local topInset = f.radius + crossbarMargin(f) + C.TargetSlack
        local half = mouth.halfWidth - inset
        if half <= 0 or mouth.top - topInset <= mouth.bottom + f.radius then return nil end
        local x = (position - mouth.center):Dot(mouth.lateral)
        local shift = mouth.lateral * (math.clamp(x, -half, half) - x)
            + UP * math.min(0, mouth.top - topInset - position.Y)
        local origin = f.sample.Origin + (f.aimOffset or V0)
        local distance = (origin - mouth.plane):Dot(mouth.forward)
        local ballDistance = (f.origin - mouth.plane):Dot(mouth.forward)
        local toward = -aim.Direction:Dot(mouth.forward)
        if distance <= 0 or ballDistance <= 0 or toward <= 1e-5 or shift.Magnitude < 1e-5 then return nil end
        local direction = aim.Direction * (distance / toward) + shift * (distance / ballDistance)
        if not vec(direction) or direction.Magnitude < 1e-5 then return nil end
        local yaw, pitch = angles(direction.Unit)
        return aimAt(f, yaw, pitch)
    end
    local function targetPoint(mouth, target)
        local point = mouth.center + mouth.lateral * target.X
        return Vector3.new(point.X, target.Y, point.Z)
    end
    local function shotZone(mouth, point)
        local x = (point - mouth.center):Dot(mouth.lateral)
        local height = (point.Y - mouth.bottom) / math.max(mouth.top - mouth.bottom, 0.01)
        local level = height < 1 / 3 and "LOW" or (height > 2 / 3 and "HIGH" or "MID")
        -- mouth.lateral points left when looking into the goal.
        local side = x > mouth.halfWidth / 3 and "LEFT" or (x < -mouth.halfWidth / 3 and "RIGHT" or "CENTER")
        return level .. " " .. side
    end
    local function searchTargets(f)
        local mouth = f.mouth
        -- Leave room for the iterative solver's 0.30-stud target tolerance.
        local inset = f.radius + C.EdgeMargin + C.TargetSlack
        local half = mouth.halfWidth - inset
        local low = mouth.bottom + f.radius + 0.4
        local high = mouth.top - f.radius - crossbarMargin(f) - C.TargetSlack
        if half <= 0 or high <= low then return {} end
        local middle = (low + high) / 2
        local targets = {}
        -- Cover all nine height/side combinations, plus the lanes between center and posts.
        -- Use a cheap reach estimate only to order work; it never authorizes an aim change.
        local speed = (N.Shoot.Constants.Shot and N.Shoot.Constants.Shot.MaximumSpeed) or 123
        for level, height in ipairs({ middle, high, low }) do
            for _, x in ipairs({ -half, half, 0, -half * 0.5, half * 0.5 }) do
                local target = Vector2.new(x, height)
                local point = targetPoint(mouth, target)
                local eta = (point - f.origin).Magnitude / math.max(speed, 1)
                local _, difficulty = reachDemand(f, point, point, eta)
                local priority = (difficulty - 1) * d.M.Dive.Constants.Distance - eta * 0.35 + cornerPreference(mouth, point)
                local _, risk = defenderDemand(f, f.origin, point, 0, eta)
                targets[#targets + 1] = { target = target, priority = priority, order = #targets + 1, level = level, defenderRisk = risk }
            end
        end
        table.sort(targets, function(a, b)
            if a.defenderRisk ~= b.defenderRisk then return a.defenderRisk < b.defenderRisk end
            if a.priority == b.priority then return a.order < b.order end
            return a.priority > b.priority
        end)
        -- Solve both upper corners early, then cover mid/low lanes. A short charge
        -- must not spend its whole search budget on bends around an easy low seed.
        -- Priority affects search order only; every proposal still needs native validation.
        local ordered, seen = {}, {}
        for _, entry in ipairs(targets) do
            if entry.level == 2 and math.abs(entry.target.X) == half then
                ordered[#ordered + 1] = entry
                seen[entry.level] = true
            end
        end
        for _, entry in ipairs(targets) do
            if not seen[entry.level] then seen[entry.level] = true; ordered[#ordered + 1] = entry end
        end
        for _, entry in ipairs(targets) do
            if not table.find(ordered, entry) then ordered[#ordered + 1] = entry end
        end
        return ordered
    end
    local function startJob(f, owner)
        owner.jobFrame = f
        owner.job = coroutine.create(function()
            -- Prepare an early tap option, then full-charge options before the native aim lock.
            -- Every selected sample is independently revalidated at actual release powers.
            local solveFrame = table.clone(f)
            solveFrame.charge = f.maximumCharge
            solveFrame.charges = { f.maximumCharge }
            local function retain(atPower, lane, aim)
                local retained = false
                if aim then
                    local rating, edgePosition = rate(atPower, aim, true)
                    if not rating and edgePosition then
                        local corrected = insetAim(atPower, aim, edgePosition)
                        if corrected then
                            rating = rate(atPower, corrected, true)
                            if rating then aim = corrected end
                        end
                    end
                    stats.candidates += 1
                    owner.candidateEvaluations = (owner.candidateEvaluations or 0) + 1
                    if rating and session == owner and A.Enabled then
                        local candidate = { direction = aim.Direction, frame = f, rating = rating,
                            at = os.clock(), lane = lane, power = atPower.charge, curve = atPower.curve }
                        -- Refresh a lane/power pair, retaining the early tap and full-power options.
                        for i = #owner.candidates, 1, -1 do
                            local previous = owner.candidates[i]
                            if previous.lane == candidate.lane and previous.power == candidate.power
                                and previous.curve == candidate.curve then table.remove(owner.candidates, i) end
                        end
                        table.insert(owner.candidates, candidate)
                        retained = true
                        table.sort(owner.candidates, function(a, b) return betterRating(a.rating, b.rating) end)
                        while #owner.candidates > 15 do table.remove(owner.candidates) end
                    end
                end
                coroutine.yield()
                return retained
            end
            local targets = searchTargets(solveFrame)
            -- Establish inexpensive left/right proposals before the iterative height solves.
            -- Preserve the user's camera pitch as a seed; the native full flight still has
            -- to enter the goal, and choose() checks the real charge again before using it.
            local sides = {}
            local _, pitch = angles(f.sample.Direction)
            for _, entry in ipairs(owner.rawRating and targets or {}) do
                local side = entry.target.X < 0 and -1 or (entry.target.X > 0 and 1 or 0)
                if side ~= 0 and (not sides[side] or math.abs(entry.target.X) > math.abs(sides[side].target.X)) then
                    sides[side] = entry
                end
            end
            -- Height priority must not pull these same-pitch corner seeds inward.
            for _, side in ipairs({ -1, 1 }) do
                local entry = sides[side]
                if entry then
                    local direction = targetPoint(f.mouth, entry.target) - (f.sample.Origin + (f.aimOffset or V0))
                    local yaw = angles(direction)
                    if retain(f, side == -1 and -1 or -2, aimAt(f, yaw, pitch))
                        and f.charge <= f.minimumCharge + 0.025 then owner.tapPrepared = true end
                end
            end
            local function prepare(atPower, entry, seed)
                retain(atPower, entry.order, solve(atPower, entry.target, seed))
            end
            local seeds = {}
            if not owner.tapPrepared and f.charge <= f.minimumCharge + 0.025 then
                local tapFrame = table.clone(f)
                tapFrame.charge, tapFrame.charges = f.minimumCharge, { f.minimumCharge }
                for _, entry in ipairs(targets) do
                    if entry.level == 3 then prepare(tapFrame, entry, {}); break end
                end
                owner.tapPrepared = true
            end
            -- Compare straight and both bends at each upper corner before spending
            -- time on more low variants. Each bend gets its own ballistic solve.
            local curves, seenCurves = { f.curve }, { [f.curve] = true }
            if f.autoCurve then
                for _, curve in ipairs({ -1, 1, 0 }) do
                    if not seenCurves[curve] then curves[#curves + 1] = curve; seenCurves[curve] = true end
                end
            end
            -- The exposed corner gets all three routes first, so a short charge
            -- can compare a bend with its straight rival before solving the
            -- keeper's covered corner. Target priority includes keeper reach.
            for index = 1, math.min(2, #targets) do
                for _, curve in ipairs(curves) do
                    local at = table.clone(solveFrame); at.curve = curve
                    seeds[curve] = seeds[curve] or {}
                    prepare(at, targets[index], seeds[curve])
                end
            end
            -- A lower bend can be harder when the keeper is well off-center. Give
            -- the strongest middle lane the same three-curve comparison as the
            -- upper corners, rather than assigning its bend by list position.
            local middlePrepared
            if f.autoCurve then
                for _, entry in ipairs(targets) do
                    if entry.level == 1 then
                        local seen = {}
                        for _, curve in ipairs({ f.curve, -1, 1, 0 }) do
                            if not seen[curve] then
                                seen[curve] = true
                                local at = table.clone(solveFrame); at.curve = curve
                                seeds[curve] = seeds[curve] or {}
                                prepare(at, entry, seeds[curve])
                            end
                        end
                        middlePrepared = entry
                        break
                    end
                end
            end
            for index, entry in ipairs(targets) do
                -- Rotate curve variants through later height solves within the same
                -- coroutine budget. With auto curve off, this is the original search.
                local curveVariants = f.autoCurve and { f.curve, -1, 1, 0 } or { f.curve }
                local curve = curveVariants[(index - 1) % #curveVariants + 1]
                local candidateFrame = table.clone(solveFrame); candidateFrame.curve = curve
                seeds[curve] = seeds[curve] or {}
                if index > 2 and entry ~= middlePrepared then prepare(candidateFrame, entry, seeds[curve]) end
            end
        end)
    end
    local function work(f, owner)
        if busy then return end
        busy = true
        local began, calls = os.clock(), 0
        if not owner.job or coroutine.status(owner.job) == "dead" or not compatible(owner.jobFrame, f)
            or os.clock() - owner.jobFrame.clock > C.CandidateAge then startJob(f, owner) end
        -- Use otherwise idle slice capacity to cover both corners. The wall-time
        -- deadline remains 2.5 ms, with no additional loop or update connection.
        local callLimit = C.CallsPerSlice * 6
        while owner.job and coroutine.status(owner.job) ~= "dead" and calls < callLimit do
            local ok, err = coroutine.resume(owner.job)
            if not ok then busy = false; error(err) end
            calls += 1
            if (os.clock() - began) * 1000 >= C.SliceMs then break end
        end
        stats.maxSliceMs = math.max(stats.maxSliceMs, (os.clock() - began) * 1000)
        busy = false
    end
    local function decisionDetail(owner)
        local distance = owner.distance and string.format("%.2f / %d studs", owner.distance, C.MaxAssistDistance) or ""
        if owner.reason == "out_of_range" then return "Out of range | " .. distance .. " | Normal aim" end
        if owner.reason == "waiting_volley" then return "Normal aim | Waiting for native volley timing" end
        if skipDetails[owner.reason] then return "Normal aim | " .. skipDetails[owner.reason] end
        local rating = owner.rating
        local count = owner.frame and #owner.frame.keepers or 0
        if not owner.frame then return "Normal aim | Keeper data unavailable" end
        if count == 0 then return "No keeper tracked | Reach unknown" end
        if rating and rating.gap ~= nil then
            local suffix = owner.autoCurve and (owner.frame.autoCurve
                and string.format(" | Curve %+.1f", owner.selectedCurve or owner.frame.curve)
                or " | Curve unavailable") or ""
            local defenders = owner.frame.defenders and #owner.frame.defenders or 0
            local coverage = defenders > 0 and string.format("%d GK / %d DEF", count, defenders) or string.format("%d GK tracked", count)
            return string.format("%s | %s\n%s | Estimated gap %.1f\n%d alternatives evaluated%s", distance,
                shotZone(owner.frame.mouth, rating.position), coverage, rating.gap, owner.candidateEvaluations or 0, suffix)
        end
        return string.format("%s | %d GK tracked | Searching", distance, count)
    end
    local function choose(sample)
        local owner = session
        if not owner or owner.locked then return sample end
        owner.pair = nil
        owner.reason = nil
        owner.bestGap = nil
        owner.redirected = false
        owner.decisionAudit = nil
        owner.completedAlternatives, owner.checkedAlternatives = 0, 0
        local f = frame(sample)
        if not f then
            owner.applied, owner.rating, owner.frame, owner.job = false, nil, nil, nil
            owner.curveChoice = nil
            table.clear(owner.candidates)
            owner.reason = owner.reason or "ineligible"
            return sample
        end
        owner.sample = table.clone(sample)
        owner.frame = f
        if #f.keepers == 0 then
            owner.applied, owner.rating, owner.job, owner.reason = false, nil, nil, "no_keeper"
            owner.curveChoice = nil
            table.clear(owner.candidates)
            setStatus("NO GK DATA", "Normal aim | Keeper reach is unknown")
            return sample
        end
        local normal = rate(f, sample, false)
        owner.rawRating = normal
        local audit = { scope = "current aim and freshly checked proposals", checked = {}, duplicatesSkipped = 0,
            rawScore = normal and normal.score, rawDefenderRisk = normal and normal.defenderRisk,
            rawCurve = f.curve, frameAt = f.clock, predictionCharge = f.charge }
        owner.decisionAudit = audit
        local clock = os.clock()
        if clock >= (owner.nextWork or 0) then
            owner.nextWork = clock + 1 / C.SampleHz
            work(f, owner)
        end
        if not f.canApply then
            owner.applied, owner.rating, owner.reason = false, nil, "waiting_volley"
            setStatus("PREPARING VOLLEY", "Waiting for the native strike window | Normal aim")
            return sample
        end
        local best, chosen, selectedCandidate, selectedCurve
        local choice = owner.curveChoice
        if choice and (not f.autoCurve or not compatible(choice.frame, f)) then
            owner.curveChoice, choice = nil, nil
        end
        -- Keep the early preview at the player's curve while the alternatives solve.
        -- Compare curves in the pre-lock window, or immediately for a release/
        -- imminent volley. The native lock is the commitment boundary; a curve
        -- chosen early must not exclude a stronger solution completed before it.
        local decideCurve = f.autoCurve and (#f.charges > 1 or owner.releasing or f.volley)
        local requiredCurve = choice and choice.curve
        if decideCurve then requiredCurve = nil end
        if f.autoCurve and not decideCurve and not choice then requiredCurve = f.curve end
        do
            local stage = f.volley and (f.canApply and "strike" or "prepare")
                or (#f.charges > 1 and "lock" or (owner.releasing and "release" or "early"))
            if owner.validationStage ~= stage then
                owner.validationStage = stage
                -- Native curve strength changes with charge. Revisit the strongest
                -- full-power proposals when entering the lock/volley window, then
                -- continue the existing fair rotation with the same two-check limit.
                for _, entry in ipairs(owner.candidates) do entry.checkedAt = nil end
            end
        end
        -- Recheck a completed candidate using current power, launch position and keeper state.
        -- Invalid/stale work never supplies a direction to native shooting.
        local checked, seenAims = 0, {}
        local shortlist = table.clone(owner.candidates)
        -- Preserve the chosen route even if the bounded search pool evicts its seed.
        -- It is a proposal only: revalidate it below with current power/world/keeper data.
        local incumbent = choice and choice.candidate or owner.selectedCandidate
        if incumbent then table.insert(shortlist, 1, incumbent) end
        owner.validationPass = (owner.validationPass or 0) + 1
        local priorities = {}
        local keeperMoved = false
        for _, entry in ipairs(shortlist) do
            local previous = entry.frame and entry.frame.keepers
            local changed = not previous or #previous ~= #f.keepers
            for i, keeper in ipairs(f.keepers) do
                local old = previous and previous[i]
                if not old or old.character ~= keeper.character or old.position ~= keeper.position
                    or old.velocity ~= keeper.velocity or old.speed ~= keeper.speed or old.jump ~= keeper.jump
                    or old.upright ~= keeper.upright then
                    changed = true; break
                end
            end
            local rating = entry.rating
            if changed and previous and #previous > 0 and rating and rating.position and rating.eta then
                -- Refresh ordering after keeper movement without rerunning every trajectory.
                -- Preserve each route's flight score, adjusting its endpoint reach estimate.
                -- This is only a proposal priority; the full current flight is checked below.
                local before = table.clone(f); before.keepers = previous; before.reachProfiles = nil
                local _, oldDemand = reachDemand(before, rating.position, rating.position, rating.eta)
                local _, newDemand = reachDemand(f, rating.position, rating.position, rating.eta)
                local priority = table.clone(rating)
                priority.score += (newDemand - oldDemand) * d.M.Dive.Constants.Distance
                priorities[entry] = priority
                keeperMoved = true
            elseif entry.checkedStage == owner.validationStage then
                priorities[entry] = entry.checkedRating or false
            else
                priorities[entry] = rating
            end
        end
        -- Changed coverage needs a fresh rival now; stationary scenes retain fair rotation.
        local prioritizeBest = keeperMoved or owner.validationPass % 2 == 0
        table.sort(shortlist, function(a, b)
            -- Revalidate the previous winner, then fairly visit alternatives. Two stale
            -- top-ranked proposals must not hide every other lane until aim lock.
            local incumbent = choice and choice.candidate or owner.selectedCandidate
            if a == incumbent then return b ~= incumbent end
            if b == incumbent then return false end
            -- Alternate strength and age: refresh a strong finished corner promptly,
            -- while stale or invalid leaders cannot permanently hide other lanes.
            if prioritizeBest then
                local ar, br = priorities[a], priorities[b]
                if betterRating(ar, br) then return true end
                if betterRating(br, ar) then return false end
            end
            local ac, bc = a.checkedAt or 0, b.checkedAt or 0
            if ac ~= bc then return ac < bc end
            local ad = math.abs((a.power or f.charge) - f.charge)
            local bd = math.abs((b.power or f.charge) - f.charge)
            if math.abs(ad - bd) > 1e-5 then return ad < bd end
            return betterRating(a.rating, b.rating)
        end)
        for _, entry in ipairs(shortlist) do
            if (requiredCurve == nil or entry.curve == requiredCurve)
                and compatible(entry.frame, f) and clock - entry.at <= C.CandidateAge then
                local aim = candidateAim(entry, f)
                local candidateFrame = f
                if f.autoCurve and entry.curve ~= nil then
                    candidateFrame = table.clone(f); candidateFrame.curve = entry.curve
                end
                -- A committed winner may also remain in the search pool. Identical
                -- current rays with the same curve share a validation; keep the
                -- second physics check available for a different proposal.
                local duplicate
                for _, seen in ipairs(seenAims) do
                    -- Rebuilding yaw/pitch can change the last float bits of the
                    -- same ray. Do not spend both slots checking that ray twice.
                    if (seen.direction - aim.Direction).Magnitude <= 1e-6 and seen.curve == candidateFrame.curve then
                        duplicate = seen
                        break
                    end
                end
                if duplicate then
                    entry.checkedAt = duplicate.checkedAt
                    audit.duplicatesSkipped += 1
                    continue
                end
                checked += 1
                owner.validationSequence = (owner.validationSequence or 0) + 1
                entry.checkedAt = owner.validationSequence
                seenAims[#seenAims + 1] = { direction = aim.Direction, curve = candidateFrame.curve,
                    checkedAt = entry.checkedAt }
                local rating, edgePosition = rate(candidateFrame, aim, false)
                local correctedEdge = false
                if not rating and edgePosition and checked < 2 then
                    local corrected = insetAim(candidateFrame, aim, edgePosition)
                    if corrected then
                        checked += 1
                        rating = rate(candidateFrame, corrected, false)
                        if rating then
                            correctedEdge = true
                            aim = corrected
                            entry.direction, entry.frame, entry.at = aim.Direction, f, clock
                            entry.rating, entry.power = rating, f.charge
                        end
                    end
                end
                audit.checked[#audit.checked + 1] = { valid = rating ~= nil, curve = candidateFrame.curve,
                    score = rating and rating.score, defenderRisk = rating and rating.defenderRisk,
                    gap = rating and rating.gap, flightSeconds = rating and rating.eta,
                    ageSeconds = math.max(0, os.clock() - entry.at), correctedEdge = correctedEdge }
                -- A full-power search score must not keep a proposal that failed
                -- the real charge window ahead of every untested alternative.
                -- These values order work only; selection always uses rate() above.
                entry.checkedStage, entry.checkedRating = owner.validationStage, rating
                if betterRating(rating, best) then
                    chosen, best, selectedCandidate, selectedCurve = aim, rating, entry, candidateFrame.curve
                end
                if checked >= 2 then break end
            end
        end
        -- A valid current aim is also a candidate, including while alternatives are still solving.
        -- Retain it under the same scoped correction guard instead of giving it back to another aim helper.
        local confirmed = normal and (requiredCurve == nil or f.curve == requiredCurve)
            and not betterRating(best, normal)
        if confirmed then chosen, best, selectedCandidate, selectedCurve = table.clone(sample), normal, nil, f.curve end
        if choice and not chosen then
            -- A commitment is not a cached collision verdict. If no checked route
            -- with this curve is valid now, allow the validated ordinary fallback.
            owner.curveChoice, choice = nil, nil
            if normal then chosen, best, selectedCandidate, selectedCurve = table.clone(sample), normal, nil, f.curve end
        end
        owner.selectedCandidate = selectedCandidate
        owner.completedAlternatives = #owner.candidates
        owner.checkedAlternatives = checked
        audit.proposalPool = #owner.candidates
        audit.requiredCurve = requiredCurve
        audit.selectedScore = best and best.score
        audit.selectedDefenderRisk = best and best.defenderRisk
        audit.selectedCurve = selectedCurve
        audit.confirmedOriginalAim = confirmed == true
        if not chosen then
            owner.applied, owner.rating, owner.reason = false, nil, "searching"
            setStatus(#f.keepers == 0 and "SEARCHING / NO GK DATA" or "SEARCHING", decisionDetail(owner))
            return sample
        end
        owner.bestGap = best.gap
        owner.selectedCurve = selectedCurve
        if f.autoCurve and (choice or decideCurve) then
            owner.curveChoice = { curve = selectedCurve, frame = f,
                candidate = { direction = chosen.Direction, frame = f, at = clock,
                    power = f.charge, curve = selectedCurve, rating = best } }
        end
        if f.autoCurve then
            owner.pair = { aim = chosen, direction = chosen.Direction, curve = selectedCurve,
                manualCurve = f.curve, character = f.character, context = f.context, ballId = f.ballId }
        end
        owner.applied, owner.rating, owner.direction = true, best, chosen.Direction
        owner.appliedAim = table.clone(chosen)
        owner.redirected = (chosen.Direction - sample.Direction).Magnitude > 1e-5 or math.abs(selectedCurve - f.curve) > 1e-5
        owner.reason = owner.redirected and "assisted" or "confirmed_aim"
        stats.lastCharge, stats.lastCurve = f.charge, selectedCurve
        setStatus(best.defenderRisk == 2 and "DEFENDER IN SHOT PATH"
            or (best.defenderRisk == 1 and "DEFENDERS COVER SHOT")
            or (not owner.redirected and "AIM CONFIRMED" or (best.gap >= C.ClearGapThreshold and "OUTSIDE MODELED REACH" or "BEST AVAILABLE SHOT")),
            decisionDetail(owner))
        local scope = scopes[thread()]
        if scope then scope.applied = true end
        return chosen
    end
    local function observe(command, locked)
        if session and command and command.PassType == d.M.Actions.PassTypes.Shot then
            session.curve = command.Curve or 0
            if A.SmartRelease and session.smartRelease and typeof(command.AimDirection) == "table" then
                session.nativeAimRevision = (session.nativeAimRevision or 0) + 1
                session.nativeAim = table.clone(command.AimDirection)
                local root = d.Player.Character and d.Player.Character:FindFirstChild("HumanoidRootPart")
                session.nativeAimRoot = root and root.Position or nil
            end
            if locked then
                session.locked = true
                session.job = nil
                local count = session.frame and #session.frame.keepers or 0
                local manual = not session.applied
                setStatus(manual and "NATIVE AIM LOCKED" or (count == 0 and "AIM LOCKED / NO GK DATA" or "AIM LOCKED"), decisionDetail(session))
            end
        end
    end
    local function pairedCurve(aim)
        local pair = session and session.pair
        if not (alive and A.Enabled and pair and typeof(aim) == "table") then return nil end
        -- Native aim lock clones/translates the ray but preserves its direction.
        -- Never attach this curve to a different aim, actor, ball or context.
        if aim.Direction ~= pair.direction or pair.character ~= d.Player.Character
            or pair.ballId ~= ballId() or pair.context ~= d.M.Motion.GetContext(pair.character)
            or not N.Curves.IsEnabled() then return nil end
        return pair.curve, pair
    end
    local function releaseDecision(owner)
        if not owner.applied or not owner.frame or owner.input == nil or not num(owner.chargeStartedAt)
            or N.Client.IsVolleyCharging() or not ownsBall() then return nil end
        local sample = owner.nativeAim
        if typeof(sample) ~= "table" or not owner.appliedAim
            or sample.Direction ~= owner.appliedAim.Direction then return nil end
        sample = table.clone(sample)
        if owner.locked then
            local root = d.Player.Character and d.Player.Character:FindFirstChild("HumanoidRootPart")
            if not root or not vec(owner.nativeAimRoot) then return nil end
            local delta = root.Position - owner.nativeAimRoot
            sample.Origin += delta
            sample.CameraCFrame += delta
        end
        local f = frame(sample, 0)
        if not f or #f.keepers == 0 or not compatible(owner.frame, f)
            or f.elapsed < f.minimumCharge + 0.005 or f.elapsed >= f.maximumCharge - 0.015 then return nil end
        -- Let auto curve make its per-shot choice before choosing its release time.
        if f.autoCurve and not owner.curveChoice then return nil end
        local curve = f.curve
        if f.autoCurve then curve = pairedCurve(sample) end
        if curve == nil then return nil end
        local function evaluate(delay)
            local at = delay == 0 and f or frame(sample, delay)
            if not at or not compatible(f, at) then return nil, false end
            at = table.clone(at)
            at.curve = curve
            return rate(at, sample, false), true
        end
        -- Compare the already selected trajectory now, halfway to full charge,
        -- and at full charge. Forecasts include the keeper's extra waiting time.
        -- This never changes a native locked direction or invents a charge value.
        local began = os.clock()
        local function inBudget()
            if (os.clock() - began) * 1000 <= C.ReleaseBudgetMs then return true end
            stats.releaseBudgetSkips += 1
            owner.releaseTiming = { decision = "budget" }
            return false
        end
        stats.releaseChecks += 1
        local now = evaluate(0)
        if not inBudget() or not now then return nil end
        local remaining = f.maximumCharge - f.elapsed
        local laterBest
        local function worthReleasing(later)
            return not later
                or ((now.defenderRisk or 0) ~= (later.defenderRisk or 0) and betterRating(now, later))
                or ((now.defenderRisk or 0) == (later.defenderRisk or 0) and now.score >= later.score + C.ReleaseMargin)
        end
        for _, delay in ipairs({ remaining / 2, remaining }) do
            local later, valid = evaluate(delay)
            if not inBudget() or not valid then return nil end
            if betterRating(later, laterBest) then laterBest = later end
            -- One better future option is enough to keep holding. Only an early
            -- release requires all comparisons; avoid an unnecessary full-power
            -- simulation when the halfway option already rules release out.
            if not worthReleasing(laterBest) then break end
        end
        local release = worthReleasing(laterBest)
        owner.releaseTiming = { decision = release and "release" or "wait", charge = f.charge,
            nowScore = now.score, laterScore = laterBest and laterBest.score or nil,
            nowDefenderRisk = now.defenderRisk, laterDefenderRisk = laterBest and laterBest.defenderRisk or nil }
        if release then return now end
        return nil
    end
    local function smartReleaseStep()
        local owner = session
        if not (alive and A.Enabled and A.SmartRelease and owner and owner.smartRelease)
            or owner.releasing or owner.smartDispatched or not N.Client.IsCharging() then return end
        local clock = os.clock()
        if clock < (owner.nextReleaseCheck or 0) then return end
        owner.nextReleaseCheck = clock + C.ReleaseInterval
        local began = os.clock()
        local rating = releaseDecision(owner)
        stats.maxReleaseMs = math.max(stats.maxReleaseMs, (os.clock() - began) * 1000)
        if not rating or session ~= owner or not (A.Enabled and A.SmartRelease and eligible())
            or not N.Client.IsCharging() or N.Client.IsVolleyCharging() or not ownsBall() then return end
        -- End the actual user-started press only once, after native UpdateAim has
        -- stored its ray. Its own release path still enforces minimums and locks.
        owner.smartDispatched = true
        owner.rating = rating
        stats.releaseRequests += 1
        N.Client.HandleInputEnded(owner.input)
    end
    local function curveCommand(command)
        if not command or command.PassType ~= d.M.Actions.PassTypes.Shot then return command end
        local curve = pairedCurve(command.AimDirection)
        if curve == nil then return command end
        local result = table.clone(command)
        result.Curve = curve ~= 0 and curve or nil
        return result
    end
    local function forwardCommand(original, source, outgoing, ...)
        if source == outgoing then return original(source, ...) end
        local result = table.pack(pcall(original, outgoing, ...))
        -- Native protocol functions stamp session/sequence/lock fields on the
        -- caller's table. Preserve those writes while keeping its manual curve.
        for key in pairs(source) do
            if key ~= "Curve" and outgoing[key] == nil then source[key] = nil end
        end
        for key, value in pairs(outgoing) do if key ~= "Curve" then source[key] = value end end
        if not result[1] then error(result[2], 0) end
        return table.unpack(result, 2, result.n)
    end
    local function hook(object, key, build)
        local original = object[key]
        assert(type(original) == "function", "Missing native function: " .. key)
        local wrapper = build(original)
        object[key] = wrapper
        table.insert(hooks, { object = object, key = key, original = original, wrapper = wrapper })
    end
    local function restore()
        local failed = {}
        for i = #hooks, 1, -1 do
            local entry = hooks[i]
            local ok = pcall(function()
                if entry.object[entry.key] == entry.wrapper then entry.object[entry.key] = entry.original end
            end)
            if not ok then table.insert(failed, entry) end
        end
        hooks = failed
        return #failed == 0
    end
    local function install()
        local paths = { Client = "Client.Gameplay.Actions.Shoot", Reticle = "Client.Interface.Reticle",
            Preview = "Client.Gameplay.Actions.ChargePathPreview", Velocity = "Modules.Actions.ChargePathVelocity",
            Shoot = "Modules.Actions.Shoot", Core = "Modules.Actions.KickCore", Power = "Modules.Actions.KickPowerups",
            Carry = "Modules.Ball.Carry", Curves = "Modules.CurvedKicks", Tutorial = "Client.Gameplay.TutorialSession",
            ShotAssist = "Modules.Actions.ShotAimAssist", Follow = "Client.Gameplay.Visual.TrajectoryPreviewFollow",
            Controls = "Modules.Gameplay.Controls", Volley = "Client.Gameplay.Actions.VolleyOpportunity",
            Receiving = "Modules.Ball.Receiving", Tackle = "Modules.Actions.SlideTackle", ActionMovement = "Modules.Actions.ActionMovement" }
        for name, path in pairs(paths) do
            assert(alive and d.alive(), "STR was unloaded while dependencies were loading")
            N[name] = d.load(path)
        end
        assert(alive and d.alive(), "STR was unloaded while dependencies were loading")
        N.RawLaunch, N.RawSpin = N.Velocity.GetLaunchVelocity, N.Shoot.GetSpin
        assert(type(N.RawLaunch) == "function" and type(N.RawSpin) == "function", "Native shot prediction is unavailable")
        hook(N.Velocity, "GetLaunchVelocity", function(original) return function(...)
            if not (session and session.pair) then return original(...) end
            local args = table.pack(...)
            local key = thread()
            nativeLaunches[key] = nil
            local curve, pair
            if args[1] == d.Player.Character and args[3] == d.M.Actions.PassTypes.Shot then
                curve, pair = pairedCurve(args[4])
            end
            if curve == nil then return original(table.unpack(args, 1, args.n)) end
            args[12], args.n = curve, math.max(args.n, 12)
            local result = table.pack(original(table.unpack(args, 1, args.n)))
            if vec(result[1]) then nativeLaunches[key] = { pair = pair, velocity = result[1], character = args[1] } end
            return table.unpack(result, 1, result.n)
        end end)
        hook(N.Shoot, "GetSpin", function(original) return function(character, velocity, playerVelocity, curve, charge)
            local record = nativeLaunches[thread()]
            if record and character == record.character and velocity == record.velocity
                and session and session.pair == record.pair then
                local selected = pairedCurve(record.pair.aim)
                if selected ~= nil then curve = selected end
            end
            return original(character, velocity, playerVelocity, curve, charge)
        end end)
        if type(N.Client.SetOwnerUserId) == "function" then
            hook(N.Client, "SetOwnerUserId", function(original) return function(userId, ...)
                local result = table.pack(original(userId, ...))
                if alive then
                    ownerSnapshot = nil
                    guarded(function()
                        local ch = d.Player.Character
                        ownerSnapshot = ch and { userId = userId, character = ch, ballId = ballId(),
                            context = d.M.Motion.GetContext(ch) } or nil
                    end)
                end
                return table.unpack(result, 1, result.n)
            end end)
        end
        hook(N.Client, "HandleInputBegan", function(original) return function(input, processed, transfer)
            if not alive or not A.Enabled then return original(input, processed, transfer) end
            if not processed and N.Controls.IsInput("Kick", input) and not N.Client.IsCharging() then
                session = { started = os.clock(), curve = 0, candidates = {}, locked = false, autoCurve = A.AutoCurve,
                    input = input, smartRelease = A.SmartRelease,
                    volleyArrival = transfer and transfer.VolleyArrivalTime or nil }
            end
            local result = table.pack(scopeCall(original, input, processed, transfer))
            if not N.Client.IsCharging() then session = nil end
            return table.unpack(result, 1, result.n)
        end end)
        hook(N.Volley, "GetPredictedArrivalTime", function(original) return function(...)
            local result = table.pack(original(...))
            if alive and A.Enabled and session and scopes[thread()] and num(result[1]) then
                session.volleyArrival = result[1]
            end
            return table.unpack(result, 1, result.n)
        end end)
        hook(N.Volley, "PredictLock", function(original) return function(userId, arrival, ...)
            local result = table.pack(original(userId, arrival, ...))
            if alive and A.Enabled and session and userId == d.Player.UserId and num(arrival) then
                session.volleyArrival, session.volleyRefused = arrival, false
            end
            return table.unpack(result, 1, result.n)
        end end)
        if type(N.Client.HandleVolleyRefused) == "function" then
            hook(N.Client, "HandleVolleyRefused", function(original) return function(...)
                if alive and A.Enabled and session then
                    session.volleyArrival, session.volleyRefused, session.job = nil, true, nil
                    table.clear(session.candidates)
                end
                return original(...)
            end end)
        end
        for _, key in ipairs({ "UpdateAim", "UpdateChargePath" }) do
            hook(N.Client, key, function(original) return function(...)
                if key ~= "UpdateAim" or not (A.SmartRelease and session and session.smartRelease)
                    or session.releasing or session.smartDispatched then return scopeCall(original, ...) end
                local owner = session
                local revision = owner and owner.nativeAimRevision
                local result = table.pack(scopeCall(original, ...))
                -- Native aim updates are throttled. Only consider release after this
                -- call reports its current ray/curve, not a previous update's sample.
                if key == "UpdateAim" and owner and session == owner and owner.nativeAimRevision ~= revision
                    and not scopes[thread()] and alive and A.Enabled and A.SmartRelease then
                    guarded(smartReleaseStep)
                end
                return table.unpack(result, 1, result.n)
            end end)
        end
        hook(N.Client, "HandleInputEnded", function(original) return function(input)
            if alive and A.Enabled and session and N.Controls.IsInput("Kick", input) then
                session.releasing = true
                if not session.locked and not session.smartDispatched then scopeCall(N.Client.UpdateAim) end
            end
            return scopeCall(original, input)
        end end)
        hook(N.Reticle, "GetCameraAimRayWithoutHit", function(original) return function(...)
            local sample = original(...)
            if not alive or not A.Enabled or not scopes[thread()] then return sample end
            local scope = scopes[thread()]
            scope.source = sample
            scope.applied = false
            local began = os.clock()
            local result = guarded(choose, sample) or sample
            stats.maxAimMs = math.max(stats.maxAimMs, (os.clock() - began) * 1000)
            return result
        end end)
        hook(N.Velocity, "Get", function(original) return function(...)
            if not alive or not A.Enabled or not scopes[thread()] then return original(...) end
            local args = table.pack(...)
            local scope = scopes[thread()]
            if alive and A.Enabled and scope and session
                and args[1] == d.Player.Character and args[3] == d.M.Actions.PassTypes.Shot then
                local curve = args[10] or 0
                if math.abs(curve - (session.curve or 0)) > 1e-5 then
                    session.curve = curve
                    session.job = nil
                    session.pair = nil
                    -- A newly changed curve invalidates the earlier solve before native aim is stored.
                    if scope.applied and scope.source and typeof(args[4]) == "table" then
                        args[4].Direction = scope.source.Direction
                        scope.applied, session.applied, session.rating = false, false, nil
                    end
                end
            end
            return original(table.unpack(args, 1, args.n))
        end end)
        -- The native helper normally smooths another aim correction after Reticle.
        -- For a validated STR sample, keep that correction at identity inside this call only.
        hook(N.ShotAssist, "GetAssistedDirection", function(original) return function(...)
            local scope = scopes[thread()]
            if alive and A.Enabled and scope and scope.applied then return nil, nil end
            return original(...)
        end end)
        hook(N.Follow, "StepAimSampleCFrame", function(original) return function(...)
            local scope = scopes[thread()]
            if alive and A.Enabled and scope and scope.applied then return CFrame.identity end
            return original(...)
        end end)
        hook(d.M.Protocol, "Start", function(original) return function(command)
            if alive and A.Enabled then
                guarded(observe, command, false)
                if session and command and command.PassType == d.M.Actions.PassTypes.Shot then
                    session.chargeStartedAt = command.ShotTime
                end
            end
            return forwardCommand(original, command, curveCommand(command))
        end end)
        hook(d.M.Protocol, "Update", function(original) return function(command)
            if alive and A.Enabled then guarded(observe, command, false) end
            return forwardCommand(original, command, curveCommand(command))
        end end)
        hook(d.M.Protocol, "LockAim", function(original) return function(command, at)
            if alive and A.Enabled then guarded(observe, command, true) end
            return forwardCommand(original, command, curveCommand(command), at)
        end end)
        hook(d.M.Protocol, "Release", function(original) return function(command)
            local source = command
            local evaluationRecord, evaluationFrame, evaluationPosition
            command = curveCommand(command)
            if alive and A.Enabled and session and command.PassType == d.M.Actions.PassTypes.Shot then
                stats.shots += 1
                if session.smartDispatched then stats.autoReleases += 1 end
                if session.applied then stats.assisted += 1 end
                if session.applied and session.redirected then stats.redirected += 1 end
                if session.applied and not session.redirected then stats.confirmed += 1 end
                stats.lastCharge, stats.lastCurve = command.ChargeSeconds or 0, command.Curve or 0
                table.insert(recentShots, { charge = stats.lastCharge, curve = stats.lastCurve,
                    assisted = session.applied == true, aimLocked = session.locked == true,
                    redirected = session.applied == true and session.redirected == true,
                    decision = session.reason or "native", bestCandidateGap = session.bestGap,
                    completedAlternatives = session.completedAlternatives or 0,
                    checkedAlternatives = session.checkedAlternatives or 0,
                    evaluatedAlternatives = session.candidateEvaluations or 0,
                    autoCurve = session.autoCurve == true,
                    smartReleased = session.smartDispatched == true,
                    releaseTiming = session.releaseTiming,
                    curveChanged = session.pair ~= nil and math.abs(session.pair.curve - session.pair.manualCurve) > 1e-5,
                    distance = session.distance, shotKind = session.volley and "volley" or "owned",
                    team = session.frame and session.frame.team or nil,
                    context = session.frame and session.frame.context or nil,
                    ballId = session.frame and session.frame.ballId or nil,
                    volleyRemaining = session.frame and session.frame.arrivalRemaining or nil,
                    estimatedGap = session.rating and session.rating.gap or nil,
                    reachDemand = session.rating and session.rating.reachDemand or nil,
                    estimatedKeeperDifficulty = session.rating and session.rating.difficulty or nil,
                    predictionCharge = session.rating and session.rating.predictionCharge or nil,
                    estimatedFlightSeconds = session.rating and session.rating.eta or nil,
                    estimatedEdgeClearance = session.rating and session.rating.edgeClearance or nil,
                    trackedDefenders = session.frame and session.frame.defenders and #session.frame.defenders or 0,
                    defenderDemand = session.rating and session.rating.defenderDemand or nil,
                    defenderRisk = session.rating and session.rating.defenderRisk or nil,
                    targetZone = session.rating and session.frame and shotZone(session.frame.mouth, session.rating.position) or nil,
                    outsideModeledReach = session.rating ~= nil and session.rating.gap ~= nil
                        and session.rating.gap >= C.ClearGapThreshold and (session.rating.defenderRisk or 0) == 0,
                    trackedKeepers = session.frame and #session.frame.keepers or 0 })
                evaluationRecord, evaluationFrame = recentShots[#recentShots], session.frame
                evaluationRecord.selectionAudit = session.decisionAudit
                evaluationRecord.predictionAgeSeconds = session.frame and math.max(0, os.clock() - session.frame.clock) or nil
                evaluationPosition = session.rating and session.rating.position
                if #recentShots > 12 then table.remove(recentShots, 1) end
                local outcome = session.smartDispatched and "smart release | "
                    or (session.applied and (session.redirected and "assisted | " or "aim confirmed | ") or "normal | ")
                setStatus("READY", "Last shot: " .. outcome .. decisionDetail(session))
                session.job = nil
                session = nil
                table.clear(nativeLaunches)
            end
            local result = table.pack(forwardCommand(original, source, command))
            if d.evaluation and evaluationRecord then
                d.evaluation.Call("ShotSent", evaluationRecord, evaluationFrame, command, evaluationPosition)
            end
            return table.unpack(result, 1, result.n)
        end end)
        for _, key in ipairs({ "HandleStartRejected", "HandleReleaseRejected" }) do
            if type(N.Client[key]) == "function" then
                hook(N.Client, key, function(original) return function(...)
                    if alive and A.Enabled then stats.rejected += 1 end
                    return original(...)
                end end)
            end
        end
        hook(N.Client, "CancelCharge", function(original) return function(...)
            local result = table.pack(original(...))
            if alive and A.Enabled then
                session = nil
                table.clear(nativeLaunches)
                setStatus("READY", "Charge canceled. Shoot normally.")
            end
            return table.unpack(result, 1, result.n)
        end end)
        hook(N.Client, "Cleanup", function(original) return function(...)
            session, ownerSnapshot = nil, nil
            table.clear(nativeLaunches)
            if alive and A.Enabled then setStatus("READY", "Shoot normally. Hold for charge.") end
            return original(...)
        end end)
        A.Ready = true
    end
    local function cancelPairedCharge()
        local pair = session and session.pair
        if pair and math.abs(pair.curve - pair.manualCurve) > 1e-5 and N.Client.IsCharging() then
            -- Removing the curve hooks while this aimed charge is live would launch
            -- a different trajectory. Cancel only this pending auto-curved charge.
            local ok, err = pcall(N.Client.CancelCharge)
            if not ok then A.LastError = tostring(err); return false end
        end
        return true
    end
    function A.SetEnabled(value)
        if not alive or installing then return false end
        if value and A.Enabled then return true end
        if not value and not cancelPairedCharge() then return false end
        if value and not A.Ready then
            installing = true
            local ok, err = pcall(install)
            installing = false
            if not ok then restore(); fail(err); return false end
        end
        A.Enabled = value == true
        if A.Enabled then A.LastError = nil end
        session = nil
        setStatus(A.Enabled and "READY" or "OFF", A.Enabled and "Shoot normally. Hold for charge." or "")
        return true
    end
    function A.SetAutoCurve(value)
        if not alive or installing then return false end
        if (value == true) == A.AutoCurve and (not value or A.Enabled) then return true end
        if not value and not cancelPairedCharge() then return false end
        A.AutoCurve = value == true
        if A.AutoCurve and not A.Enabled and not A.SetEnabled(true) then return false end
        if session and not session.locked then
            session.autoCurve, session.job = A.AutoCurve, nil
            session.curveChoice = nil
            table.clear(session.candidates)
        end
        return true
    end
    function A.SetSmartRelease(value)
        if not alive or installing then return false end
        if value and not A.Enabled and not A.SetEnabled(true) then return false end
        A.SmartRelease = value == true
        -- Enabling applies to the next user press. Disabling stops an active check.
        if session and not A.SmartRelease then session.smartRelease = false end
        return true
    end
    function A.GetAssistRange()
        return C.MaxAssistDistance
    end
    function A.SetAssistRange(value)
        if not alive or not num(value) then return false end
        C.MaxAssistDistance = math.clamp(math.floor(value + 0.5), 40, 100)
        return true
    end
    function A.Cleanup()
        if not cancelPairedCharge() then return false end
        alive, A.Enabled = false, false
        session, ownerSnapshot = nil, nil
        table.clear(nativeLaunches)
        setStatus("OFF", "")
        return restore()
    end
    function A.Debug()
        return { enabled = A.Enabled, autoCurve = A.AutoCurve, smartRelease = A.SmartRelease, ready = A.Ready, status = A.Status, detail = A.Detail,
            lastError = A.LastError, stats = table.clone(stats), active = session ~= nil,
            locked = session and session.locked or false, recentShots = table.clone(recentShots), prototype = "STR 0.16.3",
            defenderAwareness = true,
            releaseTiming = session and session.releaseTiming or nil,
            maxAssistDistance = C.MaxAssistDistance, clearGapThreshold = C.ClearGapThreshold }
    end
    if d.test then A.Test = { mouthFor = mouthFor, mouthDistance = mouthDistance, keeperGap = keeperGap,
        reachDemand = reachDemand, validate = validate, defenderDemand = defenderDemand, defenderProfile = defenderProfile,
        betterRating = betterRating,
        solve = solve, frame = frame, scopeCall = scopeCall, choose = choose, native = N,
        compatible = compatible, launch = launch, rate = rate, stats = stats, keepersFor = keepersFor, candidateAim = candidateAim,
        horizontalReach = horizontalReach, searchTargets = searchTargets, shotZone = shotZone, insetAim = insetAim,
        setSession = function(value) session = value end, getSession = function() return session end } end
    return A
end

-- Auto dribble uses the game's native input, cooldowns and stamina rules.
local function createStrikerMisc(d)
    local A = { AutoDribble = false, DribbleStatus = "OFF" }
    local N: { [string]: any } = {}
    local alive, loadingDribble = true, false
    local generation = 0
    local heartbeat, inputConnection = nil, nil
    local controlConnection, pickupWindow = nil, nil
    local scanning, manualHadBall = false, true
    local attackConnections = {}
    local characterConnections = {}
    local characterIndex = setmetatable({}, { __mode = "k" })
    local characterIndexReady = false
    local attacks = setmetatable({}, { __mode = "k" })
    local ownershipHook, nativeOwner = nil, nil
    local queuedScan, requestScan = nil, nil
    local nextPingSample, networkLead = 0, 0
    local nextTick, nextDiscovery, manualUntil, retryAt = 0, 0, 0, 0
    local candidates, cachedCharacter = {}, nil
    local stats = { scans = 0, threats = 0, proximityTriggers = 0, tackleTriggers = 0, kickTriggers = 0,
        attempts = 0, started = 0, nativeBlocked = 0,
        observerErrors = 0, errors = 0, maxTickMs = 0, readyTicks = 0, blockedTicks = 0,
        motionAligned = 0, kickStateWithoutPresentation = 0, earlyAttackSamples = 0,
        pickupReadinessWakes = 0, pickupInputResets = 0 }
    local recent = {}
    local blockedBy, recentGates = {}, {}
    local lastScan = nil
    local C = { Interval = 1 / 60, DiscoverySeconds = 0.15, Range = 40, Lookahead = 0.22, KickLookahead = 0.12,
        RetrySeconds = 0.25, Step = 0.025, Padding = 1.0, ManualGrace = 0.15, MaximumDisplayLead = 0.20,
        ChargeStateGrace = 0.10, MaximumNetworkLead = 0.12, PingSampleSeconds = 0.5,
        PickupReadySeconds = 0.35 }
    local function flat(v) return Vector3.new(v.X, 0, v.Z) end
    local function finite(n) return type(n) == "number" and n == n and math.abs(n) < math.huge end
    local function vector(v) return typeof(v) == "Vector3" and finite(v.X) and finite(v.Y) and finite(v.Z) end
    local function attackDirection(value)
        if typeof(value) == "table" or typeof(value) == "Ray" then value = value.Direction end
        if not vector(value) then return nil end
        local direction = flat(value)
        return direction.Magnitude > 1e-5 and direction.Unit or nil
    end
    local function problem(err)
        A.LastError = tostring(err)
        stats.errors += 1
        warn("[Dmc Misc] " .. A.LastError)
    end
    local function stopWatch()
        queuedScan = nil
        nextPingSample, networkLead = 0, 0
        if heartbeat then heartbeat:Disconnect(); heartbeat = nil end
        if inputConnection then inputConnection:Disconnect(); inputConnection = nil end
        if controlConnection then controlConnection:Disconnect(); controlConnection = nil end
        pickupWindow = nil
        for _, connection in ipairs(attackConnections) do connection:Disconnect() end
        table.clear(attackConnections)
        for _, connection in ipairs(characterConnections) do connection:Disconnect() end
        table.clear(characterConnections)
        table.clear(characterIndex)
        characterIndexReady = false
        table.clear(attacks)
        if ownershipHook then
            ownershipHook.active = false
            if d.M.Dodge.SetOwnerUserId == ownershipHook.wrapper then
                d.M.Dodge.SetOwnerUserId = ownershipHook.original
            end
            ownershipHook = nil
        end
        nativeOwner = nil
        candidates, cachedCharacter = {}, nil
        nextDiscovery = 0
    end
    local function stopDribbleWatch(err)
        A.AutoDribble = false
        generation += 1
        stopWatch()
        A.DribbleStatus = "ERROR"
        problem(err)
    end
    local function loadDribble()
        local paths = { Controls = "Modules.Gameplay.Controls", Input = "Libraries.Input",
            Tackle = "Modules.Actions.SlideTackle", Sprint = "Client.Gameplay.Player.Sprint",
            Shoot = "Client.Gameplay.Actions.Shoot", ChargeState = "Modules.Actions.ActionChargeState",
            Effects = "Client.Gameplay.Actions.TackleEffects", KickCore = "Modules.Actions.KickCore",
            Power = "Modules.Actions.KickPowerups" }
        for name, path in pairs(paths) do
            if not N[name] then N[name] = d.load(path) end
        end
        for _, item in ipairs({ { N.Controls, "CreateInput" }, { N.Controls, "IsInput" },
            { N.Controls, "IsAvailable" }, { N.Controls, "IsOnCooldown" }, { N.Controls, "IsActive" },
            { N.Input, "ShouldIgnoreKeybind" }, { N.Tackle, "GetSlidingUntil" },
            { N.Tackle, "GetMaximumTravelBetween" }, { N.Sprint, "CanSpendStamina" },
            { N.Shoot, "IsCharging" }, { N.ChargeState, "IsCharging" }, { N.Effects, "GetObservedChargeFill" },
            { N.KickCore, "GetMinimumReleaseDelaySeconds" }, { N.Power, "GetChargeConstants" },
            { d.M.Dodge, "HandleInputBegan" }, { d.M.Dodge, "IsDribbling" },
            { d.M.Dodge, "UpdateControlState" } }) do
            assert(type(item[1][item[2]]) == "function", "Missing native dribble API: " .. item[2])
        end
        N.Dodge = N.Dodge or d.load("Modules.Actions.Dodge")
        assert(finite(N.Dodge.Constants.StaminaCost), "Missing dribble stamina cost")
        local box = d.M.Hitboxes.Kick
        assert(box and vector(box.Size) and typeof(box.CFrameOffset) == "CFrame", "Missing native kick hitbox")
    end
    local function currentBallId()
        return type(d.M.Renderer.GetMatchBallId) == "function" and d.M.Renderer.GetMatchBallId() or nil
    end
    local function watchNativeOwner()
        local hook = { original = d.M.Dodge.SetOwnerUserId, active = true }
        assert(type(hook.original) == "function", "Native dribble ownership unavailable")
        hook.wrapper = function(userId, ...)
            local previous = nativeOwner
            if hook.active then nativeOwner = nil end
            local result = table.pack(hook.original(userId, ...))
            if hook.active and alive and A.AutoDribble and d.alive() then
                local ok = pcall(function()
                    local ch = d.Player.Character
                    nativeOwner = ch and { character = ch, ballId = currentBallId(),
                        context = d.M.Motion.GetContext(ch), userId = userId } or nil
                    if nativeOwner and userId == d.Player.UserId and (not previous
                        or previous.userId ~= userId or previous.character ~= ch
                        or previous.ballId ~= nativeOwner.ballId or previous.context ~= nativeOwner.context) then
                        -- Receipt can follow a refused attempt or a roster refresh.
                        -- Finish the native handoff before evaluating the packet batch.
                        pickupWindow = { character = ch, ballId = nativeOwner.ballId,
                            context = nativeOwner.context, expires = os.clock() + C.PickupReadySeconds }
                        -- A press made while chasing the loose ball must not carry
                        -- its grace delay into the newly owned ball. Active native
                        -- strikes, slides and jumps still enforce their own gates.
                        if not manualHadBall and manualUntil > os.clock() then
                            manualUntil = 0
                            stats.pickupInputResets += 1
                        end
                        nextTick, nextDiscovery, retryAt = 0, 0, 0
                        requestScan()
                    elseif userId ~= d.Player.UserId then
                        pickupWindow = nil
                    end
                end)
                if not ok then nativeOwner = nil; stats.observerErrors += 1 end
            end
            return table.unpack(result, 1, result.n)
        end
        ownershipHook = hook
        d.M.Dodge.SetOwnerUserId = hook.wrapper
    end
    local function ownsBall(ch)
        -- Follow the same handoff as native Dodge; the renderer may lag on receipt.
        if nativeOwner and nativeOwner.character == ch and nativeOwner.ballId == currentBallId()
            and nativeOwner.context == d.M.Motion.GetContext(ch) then
            return nativeOwner.userId == d.Player.UserId
        end
        return d.M.Renderer.GetOwnedUserId() == d.Player.UserId
    end
    local function watchPickupReadiness()
        if type(N.Controls.OnStateChanged) ~= "function" then return end
        local function changed(name, field, active, available, _, cooldown)
            if scanning or not (alive and A.AutoDribble and d.alive()) then return end
            local pickup = pickupWindow
            if not pickup then return end
            local ch = d.Player.Character
            if os.clock() > pickup.expires or ch ~= pickup.character or not ch or not ch.Parent
                or currentBallId() ~= pickup.ballId or d.M.Motion.GetContext(ch) ~= pickup.context then
                pickupWindow = nil
                return
            end
            local becameReady = name == "Dribble" and available == true and cooldown ~= true
                and (field == "Available" or field == "Cooldown")
            local strikeEnded = field == "Active" and active == false
                and (name == "Kick" or name == "Pass" or name == "Lob" or name == "RainbowFlick")
            if not (becameReady or strikeEnded) or not ownsBall(ch) or d.M.Dodge.IsDribbling() then return end
            -- The ownership scan may have run before the native pickup/landing
            -- handoff cleared Unready. Wake on that transition rather than wait
            -- for another heartbeat; defer so the entire native callback finishes.
            stats.pickupReadinessWakes += 1
            nextTick = 0
            requestScan()
        end
        controlConnection = N.Controls.OnStateChanged(function(...)
            local ok = pcall(changed, ...)
            if not ok then stats.observerErrors += 1 end
        end)
    end
    local function eligible()
        if not (alive and A.AutoDribble and d.alive()) then return nil, "OFF" end
        local suspended, suspendReason = d.suspended()
        if suspended then return nil, suspendReason or "INPUT PAUSED" end
        if d.Gui.MenuIsOpen then return nil, "MENU OPEN" end
        if N.Input.ShouldIgnoreKeybind(false) then return nil, "TEXT / KEYBIND" end
        if os.clock() < manualUntil then return nil, "MANUAL INPUT" end
        local ch = d.Player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local root = ch and ch:FindFirstChild("HumanoidRootPart")
        if not ch or not ch.Parent or not root or not hum or hum.Health <= 0 then return nil, "WAITING" end
        if d.M.Match.IsGoalkeeperCharacter(ch) then return nil, "GK ROLE" end
        if d.M.Freeze.IsFrozen() then return nil, "FROZEN" end
        if d.M.Replay.IsActive() then return nil, "REPLAY" end
        if d.M.Controllers.IsSuspended(ch) then return nil, "RECOVERING" end
        if not ownsBall(ch) then return nil, "NO BALL" end
        if N.Shoot.IsCharging() then return nil, "SHOOTING" end
        for _, name in ipairs({ "Kick", "Pass", "Lob", "RainbowFlick" }) do
            if N.Controls.IsActive(name) then return nil, "STRIKING" end
        end
        if d.M.Dodge.IsDribbling() then return nil, "DRIBBLING" end
        -- Native availability/HandleInputBegan own the action override. A slide's
        -- presentation can outlast that override after a grounded ball pickup.
        if not d.M.Controllers.IsLanded(ch, hum) then return nil, "MOVING" end
        if not N.Controls.IsAvailable("Dribble") or N.Controls.IsOnCooldown("Dribble") then return nil, "COOLDOWN / BLOCKED" end
        if not N.Sprint.CanSpendStamina(N.Dodge.Constants.StaminaCost, true) then return nil, "LOW STAMINA" end
        if os.clock() < retryAt then return nil, "RETRY WAIT" end
        return ch, root
    end
    local function noteGate(reason)
        local gate = reason or "READY"
        if gate == "COOLDOWN / BLOCKED" then
            gate = N.Controls.IsOnCooldown("Dribble") and "COOLDOWN" or "NATIVE UNREADY"
        end
        if reason then
            stats.blockedTicks += 1
            blockedBy[gate] = (blockedBy[gate] or 0) + 1
        else
            stats.readyTicks += 1
        end
        local last = recentGates[#recentGates]
        if not last or last.reason ~= gate then
            recentGates[#recentGates + 1] = { reason = gate, clock = os.clock() }
            if #recentGates > 12 then table.remove(recentGates, 1) end
        end
    end
    local function resolveCharacter(character)
        return character and type(d.M.Motion.ResolveCharacter) == "function"
            and d.M.Motion.ResolveCharacter(character) or character
    end
    local function actorFor(character, actor)
        if actor and actor ~= character and resolveCharacter(actor.Character) == character then return actor end
        if type(d.M.Actors.GetFromCharacter) == "function" then
            actor = d.M.Actors.GetFromCharacter(character)
        else
            local userId = character:GetAttribute("UserId")
            actor = finite(userId) and d.M.Actors.GetByUserId(userId) or nil
        end
        return actor and resolveCharacter(actor.Character) == character and actor or nil
    end
    local function characterTeam(character, actor)
        if actor then return d.M.Teams.GetActorTeamName(actor) end
        if type(d.M.Teams.GetCharacterTeamName) == "function" then
            return d.M.Teams.GetCharacterTeamName(character)
        end
        return d.M.Teams.GetActorTeamName(character)
    end
    local function watchCharacters()
        if not workspace.DescendantAdded or not workspace.DescendantRemoving then return end
        local function added(node)
            local model
            if node:IsA("Model") then
                if node:FindFirstChildOfClass("Humanoid") or node:FindFirstChild("HumanoidRootPart") then model = node end
            elseif node:IsA("Humanoid") or (node:IsA("BasePart") and node.Name == "HumanoidRootPart") then
                model = node.Parent
            end
            if model and model:IsA("Model") then
                characterIndex[model] = true
                nextDiscovery, nextTick = 0, 0
            end
        end
        characterConnections[#characterConnections + 1] = workspace.DescendantAdded:Connect(added)
        characterConnections[#characterConnections + 1] = workspace.DescendantRemoving:Connect(function(node)
            if characterIndex[node] then
                characterIndex[node] = nil
                nextDiscovery, nextTick = 0, 0
            end
        end)
        for _, node in ipairs(workspace:GetDescendants()) do added(node) end
        characterIndexReady = true
    end
    local function observeAttack(kind, userId, ...)
        if kind ~= "TackleStarted" and kind ~= "KickChargeStarted" and kind ~= "KickChargeUpdated"
            and kind ~= "KickReleased" and kind ~= "KickChargeCanceled" then return end
        if not finite(userId) or userId == d.Player.UserId then return end
        local actor = d.M.Actors.GetByUserId(userId)
        local character = resolveCharacter(actor and actor.Character)
        if not character or not character.Parent then return end
        local now, context = workspace:GetServerTimeNow(), d.M.Motion.GetContext(character)
        local state = attacks[character]
        if not state or state.context ~= context then state = { context = context }; attacks[character] = state end
        local started = select(7, ...)
        if kind == "TackleStarted" then
            if not finite(started) then return end
            if started > now or now - started > N.Tackle.Constants.HitboxDelaySeconds + N.Tackle.Constants.HitboxSeconds then return end
            if state.slideStarted and started <= state.slideStarted then return end
            state.slideStarted = started
            state.slideDirection = attackDirection(select(2, ...))
        else
            local actionId, presentationId, sequence = select(9, ...), select(11, ...), select(13, ...)
            local previous = state.kick
            if previous then
                if finite(presentationId) and finite(previous.presentationId) then
                    if presentationId < previous.presentationId then return end
                elseif actionId ~= nil and previous.actionId ~= nil and actionId ~= previous.actionId
                    and kind ~= "KickChargeStarted" then return end
            end
            local same = previous and ((presentationId ~= nil and presentationId == previous.presentationId)
                or (presentationId == nil and actionId ~= nil and actionId == previous.actionId))
            local terminal = kind == "KickReleased" or kind == "KickChargeCanceled"
            if same and not terminal then
                if previous.ended then return end
                if finite(sequence) and finite(previous.sequence) and sequence <= previous.sequence then return end
            end
            if terminal then
                state.kick = { ended = true, actionId = actionId, presentationId = presentationId }
            else
                local passType, charge = select(1, ...), select(3, ...)
                if not finite(charge) or charge < 0 or not finite(started) or started > now then return end
                if previous and finite(previous.started) and started < previous.started then return end
                if passType ~= "Shot" then
                    state.kick = { ended = true, actionId = actionId, presentationId = presentationId }
                    return
                end
                local constants = N.Power.GetChargeConstants(actor, N.KickCore.Constants)
                if not constants or not finite(constants.MaximumChargeSeconds) then return end
                if now - started > constants.MaximumChargeSeconds + 0.25 then return end
                state.kick = { started = started, charge = charge, at = now,
                    actionId = actionId, presentationId = presentationId, sequence = sequence,
                    -- p274 is the launch aim, p285 its flat kick direction.
                    -- p272 is animation direction and must not substitute for aim.
                    direction = attackDirection(select(4, ...)) or attackDirection(select(15, ...)),
                    sawCharging = N.ChargeState.IsCharging(actor) or (same and previous.sawCharging) or false,
                    expires = started + constants.MaximumChargeSeconds + 0.25 }
            end
        end
        stats.earlyAttackSamples += 1
        nextTick, nextDiscovery = 0, 0
        requestScan()
    end
    local function watchAttacks()
        -- TackleEffects queues these same packets through ReplayEvents.PresentAt.
        -- Read timing on receipt so presentation delay cannot hide the windup.
        -- Ordered start/update packets supply charge evidence before attributes
        -- replicate. Cancellation/end packets and predicted contact still gate it.
        for _, remote in ipairs(d.AttackRemotes or {}) do
            attackConnections[#attackConnections + 1] = remote.OnClientEvent:Connect(function(...)
                if not (alive and A.AutoDribble and d.alive()) then return end
                local ok = pcall(observeAttack, ...)
                if not ok then stats.observerErrors += 1 end
            end)
        end
    end
    local function discover(ch)
        local seen, list = {}, {}
        local function add(character, actor)
            character = resolveCharacter(character)
            if not character or character == ch or seen[character] then return end
            seen[character] = true
            list[#list + 1] = { character = character, actor = actorFor(character, actor) }
        end
        for _, player in ipairs(d.Players:GetPlayers()) do add(player.Character, player) end
        for character in pairs(characterIndex) do
            if character:IsDescendantOf(workspace) then add(character) end
        end
        -- An attack packet also identifies its actor even if its model has just
        -- streamed in or has not appeared in a discovery snapshot yet.
        for character in pairs(attacks) do if character.Parent then add(character) end end
        local folder = workspace:FindFirstChild("Characters")
        local function children(container)
            if not container then return end
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("Model") then add(child) end
            end
        end
        if not characterIndexReady then
            children(folder)
            children(folder and folder:FindFirstChild("NPCs"))
        end
        candidates, cachedCharacter = list, ch
        nextDiscovery = os.clock() + C.DiscoverySeconds
    end
    local function segmentBox(a, b, half)
        local low, high = 0, 1
        for _, axis in ipairs({ "X", "Y", "Z" }) do
            local origin: number = a[axis]
            local delta: number = b[axis] - origin
            local extent: number = half[axis]
            if math.abs(delta) < 1e-8 then
                if math.abs(origin) > extent then return false end
            else
                local enter, leave = (-extent - origin) / delta, (extent - origin) / delta
                if enter > leave then enter, leave = leave, enter end
                low, high = math.max(low, enter), math.min(high, leave)
                if low > high then return false end
            end
        end
        return true
    end
    local function alignDisplayedMotion(character, cf: CFrame, velocity: Vector3, slideAge: number?, slideDirection: Vector3?): (CFrame, number)
        local motion = d.M.Motion
        if type(motion.GetDisplayDelaySeconds) ~= "function"
            or type(motion.GetSimulationRoot) == "function" and motion.GetSimulationRoot(character) then return cf, 0 end
        local delay: number = motion.GetDisplayDelaySeconds(character)
        if not finite(delay) or delay <= 0 then return cf, 0 end
        delay = math.min(delay, C.MaximumDisplayLead)
        local displacement = velocity * delay
        if slideAge then
            local direction = slideDirection or flat(velocity)
            if not slideDirection and direction.Magnitude < 1 then direction = flat(cf.LookVector) end
            if direction.Magnitude > 1e-5 then
                local constants = N.Tackle.Constants
                local motionSeconds = math.min(delay, slideAge)
                local travel = N.Tackle.GetMaximumTravelBetween(slideAge - motionSeconds, slideAge,
                    constants.StartupDashDistance, constants.Distance)
                displacement = flat(velocity) * (delay - motionSeconds) + direction.Unit * travel
                    + Vector3.new(0, velocity.Y * delay, 0)
            end
        end
        -- GetCFrame may be an interpolated display pose. Attack age is server time:
        -- bring the pose onto that timeline before predicting future contact.
        -- This is a bounded estimate, never a character movement write.
        return cf + displacement, delay
    end
    local function contactEnvelope(rootCF, box, observedPosition, ownCF, ownSize)
        local extent = Vector3.new(C.Padding, C.Padding, C.Padding)
        if ownCF and vector(ownSize) and ownSize.X > 0 and ownSize.Y > 0 and ownSize.Z > 0 then
            -- Sweep the carrier's root volume, not just its center. Project its
            -- oriented half-extents into the attack box's axes so rear/side grazes
            -- remain visible as either character turns. This is a conservative
            -- contact estimate; it never changes either character's hitbox.
            local attackCF = rootCF * box.CFrameOffset
            local right = attackCF:VectorToObjectSpace(ownCF.RightVector) * (ownSize.X * 0.5)
            local up = attackCF:VectorToObjectSpace(ownCF.UpVector) * (ownSize.Y * 0.5)
            local forward = attackCF:VectorToObjectSpace(ownCF.LookVector) * (ownSize.Z * 0.5)
            -- The existing margin already covered the unrotated root. Replace it
            -- only where the projected body is larger; do not stack two margins
            -- and turn a nearby kick that misses into a dribble trigger.
            extent = Vector3.new(math.max(C.Padding, math.abs(right.X) + math.abs(up.X) + math.abs(forward.X)),
                math.max(C.Padding, math.abs(right.Y) + math.abs(up.Y) + math.abs(forward.Y)),
                math.max(C.Padding, math.abs(right.Z) + math.abs(up.Z) + math.abs(forward.Z)))
        end
        local half = box.Size * 0.5 + extent
        if observedPosition then
            -- Extrapolation is an estimate. Cover the bounded space between the
            -- displayed and estimated pose rather than throwing the display pose
            -- away. Otherwise compensation can advance a close attack past us.
            local delta = observedPosition - rootCF.Position
            local offset = (rootCF * box.CFrameOffset):VectorToObjectSpace(delta)
            half += Vector3.new(math.abs(offset.X), math.abs(offset.Y), math.abs(offset.Z)) * 0.5
            rootCF += delta * 0.5
        end
        return rootCF, half
    end
    local function reactionLead()
        local clock = os.clock()
        if clock >= nextPingSample then
            nextPingSample = clock + C.PingSampleSeconds
            -- GetNetworkPing reports round-trip seconds. Half is a bounded
            -- estimate of the outbound dodge request's travel time. Display
            -- alignment corrects the opponent pose; it does not cover this trip.
            local ok, ping = pcall(function() return d.Player:GetNetworkPing() end)
            networkLead = ok and finite(ping) and ping >= 0 and math.min(ping * 0.5, C.MaximumNetworkLead) or 0
        end
        return networkLead
    end
    local function contactTime(ownCF, ownVelocity, otherCF, otherVelocity, age, slideDirection, observedPosition, ownSize, horizon)
        local constants = N.Tackle.Constants
        local first = math.max(0, constants.HitboxDelaySeconds - age)
        local last = math.min(horizon or C.Lookahead, constants.HitboxDelaySeconds + constants.HitboxSeconds - age)
        if last < first then return nil end
        -- A start packet reports the committed dash direction before motion
        -- interpolation necessarily catches up with a turn into the tackle.
        local direction = slideDirection or flat(otherVelocity)
        if not slideDirection and direction.Magnitude < 1 then direction = flat(otherCF.LookVector) end
        if direction.Magnitude < 1e-5 then return nil end
        direction = direction.Unit
        -- The native maximum is conservative through the startup/main-dash handoff.
        -- Recompute from the observed root every scan; never integrate a stale origin.
        local box = d.M.Hitboxes.SlideTackle
        local facing = CFrame.lookAt(otherCF.Position, otherCF.Position + direction)
        local half
        facing, half = contactEnvelope(facing, box, observedPosition, ownCF, ownSize)
        local function point(t)
            local travel = N.Tackle.GetMaximumTravelBetween(age, age + t,
                constants.StartupDashDistance, constants.Distance)
            local rootCF = facing + direction * travel
            return (rootCF * box.CFrameOffset):PointToObjectSpace(ownCF.Position + ownVelocity * t)
        end
        local previous = point(first)
        if segmentBox(previous, previous, half) then return first end
        local steps = math.max(1, math.ceil((last - first) / C.Step))
        for i = 1, steps do
            local t = first + (last - first) * i / steps
            local current = point(t)
            if segmentBox(previous, current, half) then return t end
            previous = current
        end
        return nil
    end
    local function kickWindow(candidate, horizon)
        local other = candidate.character
        local actor = actorFor(other, candidate.actor)
        if not actor or not finite(actor.UserId) or d.M.Match.IsGoalkeeperCharacter(other) then return nil end
        local charging = N.ChargeState.IsCharging(actor)
        -- Presentation alone can linger after cancellation. It must have native
        -- charge state or a still-live, ordered server start/update packet.
        -- This fill is elapsed / maximum, NOT KickCore's power alpha.
        local fill, compact = N.Effects.GetObservedChargeFill(actor.UserId)
        local attack = attacks[other]
        local early = attack and attack.context == d.M.Motion.GetContext(other) and attack.kick
        if early then
            local now = workspace:GetServerTimeNow()
            if early.ended or now > early.expires then return nil end
            if charging then early.sawCharging = true
            elseif early.sawCharging and now - early.at > C.ChargeStateGrace then
                -- Attribute replication and ordered presentation packets can
                -- disagree briefly. Only an explicit release/cancel is terminal.
                -- A stale packet cannot keep a dropped charge live, but it must
                -- not poison newer updates for the same action either.
                return nil
            end
            local constants = N.Power.GetChargeConstants(actor, N.KickCore.Constants)
            local maximum = constants and constants.MaximumChargeSeconds
            if not finite(maximum) or maximum <= 0 then return nil end
            fill = math.clamp(math.max(now - early.started, early.charge + now - early.at) / maximum, 0, 1)
            compact = false
        elseif not charging then return nil end
        if not finite(fill) or fill < 0 or fill > 1 or compact ~= false then
            if fill == nil then stats.kickStateWithoutPresentation += 1 end
            return nil
        end
        local constants = N.Power.GetChargeConstants(actor, N.KickCore.Constants)
        local maximum = constants and constants.MaximumChargeSeconds
        if not finite(maximum) or maximum <= 0 then return nil end
        local first = N.KickCore.GetMinimumReleaseDelaySeconds(fill * maximum, constants)
        if not finite(first) or first < 0 or first > (horizon or C.KickLookahead) then return nil end
        return { first = first, fill = fill, direction = early and early.direction or nil }
    end
    local function kickContactTime(ownCF, ownVelocity, otherCF, otherVelocity, first, direction, observedPosition, ownSize, horizon)
        local box = d.M.Hitboxes.Kick
        local last = horizon or C.KickLookahead
        if last < first then return nil end
        -- Predict the aimed hitbox from the received launch aim. The displayed
        -- torso may still face the previous direction when that packet arrives.
        if direction then otherCF = CFrame.lookAt(otherCF.Position, otherCF.Position + direction) end
        local half
        otherCF, half = contactEnvelope(otherCF, box, observedPosition, ownCF, ownSize)
        -- Standing kicks retain ordinary movement, not slide travel.
        -- Release can happen any time after minimum charge: this is a threat estimate.
        local function point(t)
            local rootCF = otherCF + otherVelocity * t
            return (rootCF * box.CFrameOffset):PointToObjectSpace(ownCF.Position + ownVelocity * t)
        end
        local previous = point(first)
        if segmentBox(previous, previous, half) then return first end
        local steps = math.max(1, math.ceil((last - first) / C.Step))
        for i = 1, steps do
            local t = first + (last - first) * i / steps
            local current = point(t)
            if segmentBox(previous, current, half) then return t end
            previous = current
        end
        return nil
    end
    local function tick()
        local character = d.Player.Character
        if character and character.Parent and ownsBall(character) and not d.M.Dodge.IsDribbling() then
            -- SetOwnerUserId updates NotOwner, but Unready/Recovery are refreshed
            -- separately. Use the native refresh before reading those flags.
            d.M.Dodge.UpdateControlState()
        end
        local ch, rootOrReason = eligible()
        noteGate(not ch and rootOrReason or nil)
        if not ch then
            A.DribbleStatus = rootOrReason
            if rootOrReason == "COOLDOWN / BLOCKED" then
                if N.Controls.IsOnCooldown("Dribble") then
                    local remaining = type(N.Controls.GetCooldownRemaining) == "function"
                        and N.Controls.GetCooldownRemaining("Dribble") or nil
                    A.DribbleStatus = finite(remaining) and string.format("COOLDOWN %.1fs", math.max(0, remaining)) or "COOLDOWN"
                else
                    A.DribbleStatus = "NOT READY"
                end
            end
            return
        end
        local root = rootOrReason
        local team = d.M.Teams.GetActorTeamName(d.Player)
        -- Neutral practice actors share one team; do not guess which is hostile.
        local opposing = d.M.Match.Constants.TeamDisplayNames[team] and d.M.Match.GetOpposingTeamName(team)
        if not opposing then A.DribbleStatus = "WAITING FOR OPPONENT"; return end
        local context = d.M.Motion.GetContext(ch)
        local ownCF = d.M.Motion.GetCFrame(ch) or root.CFrame
        local velocity = d.M.Motion.GetVelocity(ch) or root.AssemblyLinearVelocity
        if not vector(ownCF.Position) or not vector(velocity) then return end
        if cachedCharacter ~= ch or os.clock() >= nextDiscovery then discover(ch) end
        stats.scans += 1
        A.DribbleStatus = "WATCHING"
        local lead = reactionLead()
        local tackleHorizon, kickHorizon = C.Lookahead + lead, C.KickLookahead + lead
        lastScan = { clock = os.clock(), activeSlides = 0, activeKicks = 0, contacts = 0, maximumDisplayLead = 0,
            networkLeadSeconds = lead, tackleHorizonSeconds = tackleHorizon, kickHorizonSeconds = kickHorizon }
        local now, best = workspace:GetServerTimeNow(), nil
        for _, candidate in ipairs(candidates) do
            local other = candidate.character
            candidate.actor = actorFor(other, candidate.actor)
            if other.Parent and d.M.Motion.GetContext(other) == context
                and characterTeam(other, candidate.actor) == opposing then
                -- Require an observed slide or a live native kick charge, never proximity alone.
                local untilTime = N.Tackle.GetSlidingUntil(other)
                local constants = N.Tackle.Constants
                local attack = attacks[other]
                if attack and attack.context == context and attack.slideStarted then
                    untilTime = math.max(finite(untilTime) and untilTime or 0, attack.slideStarted + constants.TotalMotionSeconds)
                end
                local age = finite(untilTime) and now - (untilTime - constants.TotalMotionSeconds) or nil
                local hitboxEndsAt = constants.HitboxDelaySeconds + constants.HitboxSeconds
                local sliding = age ~= nil and age >= 0 and age <= hitboxEndsAt
                -- Do not attach an old packet's direction to a newer replicated slide.
                local slideDirection = sliding and attack and attack.context == context and attack.slideStarted
                    and math.abs(untilTime - (attack.slideStarted + constants.TotalMotionSeconds)) < 1e-4
                    and attack.slideDirection or nil
                local kick = kickWindow(candidate, kickHorizon)
                if not sliding and not kick then continue end
                if sliding then lastScan.activeSlides += 1 end
                if kick then lastScan.activeKicks += 1 end
                local hum = other:FindFirstChildOfClass("Humanoid")
                local otherRoot = other:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and otherRoot then
                    local otherCF = d.M.Motion.GetCFrame(other) or otherRoot.CFrame
                    local otherVelocity = d.M.Motion.GetVelocity(other) or otherRoot.AssemblyLinearVelocity
                    if vector(otherCF.Position) and vector(otherVelocity)
                        and (otherCF.Position - ownCF.Position).Magnitude <= C.Range then
                        local observedPosition = otherCF.Position
                        local displayLead
                        otherCF, displayLead = alignDisplayedMotion(other, otherCF, otherVelocity, sliding and age or nil, slideDirection)
                        if displayLead > 0 then stats.motionAligned += 1 end
                        lastScan.maximumDisplayLead = math.max(lastScan.maximumDisplayLead, displayLead)
                        local uncertainPosition = displayLead > 0 and observedPosition or nil
                        local eta = sliding and contactTime(ownCF, velocity, otherCF, otherVelocity, age, slideDirection, uncertainPosition, root.Size, tackleHorizon) or nil
                        local kickEta = kick and kickContactTime(ownCF, velocity, otherCF, otherVelocity, kick.first, kick.direction, uncertainPosition, root.Size, kickHorizon) or nil
                        local reason = "tackle"
                        if kickEta and (not eta or kickEta < eta) then eta, reason = kickEta, "kick" end
                        local distance = flat(otherCF.Position - ownCF.Position).Magnitude
                        local observedDistance = flat(observedPosition - ownCF.Position).Magnitude
                        if not lastScan.nearestThreat or observedDistance < lastScan.nearestThreat.observedDistance then
                            -- One bounded, read-only sample makes future misses diagnosable
                            -- without inferring exact geometry from a video or contact count.
                            lastScan.nearestThreat = { target = other.Name, observedDistance = observedDistance,
                                alignedDistance = distance, displayLeadSeconds = displayLead,
                                poseShiftStuds = (otherCF.Position - observedPosition).Magnitude,
                                slideAgeSeconds = sliding and age or nil,
                                hitboxRemainingSeconds = sliding and hitboxEndsAt - age or nil,
                                kickEarliestReleaseSeconds = kick and kick.first or nil,
                                predictedContactSeconds = eta, contactPredicted = eta ~= nil,
                                ownPosition = { ownCF.Position.X, ownCF.Position.Y, ownCF.Position.Z },
                                ownVelocity = { velocity.X, velocity.Y, velocity.Z },
                                observedPosition = { observedPosition.X, observedPosition.Y, observedPosition.Z },
                                alignedPosition = { otherCF.Position.X, otherCF.Position.Y, otherCF.Position.Z },
                                opponentVelocity = { otherVelocity.X, otherVelocity.Y, otherVelocity.Z },
                                observedFacing = { otherCF.LookVector.X, otherCF.LookVector.Y, otherCF.LookVector.Z },
                                slideDirection = slideDirection and { slideDirection.X, slideDirection.Y, slideDirection.Z } or nil,
                                kickDirection = kick and kick.direction and { kick.direction.X, kick.direction.Y, kick.direction.Z } or nil }
                        end
                        if eta then lastScan.contacts += 1 end
                        if eta and (not best or eta < best.eta or eta == best.eta and (distance or math.huge) < (best.distance or math.huge)) then
                            best = { character = other, eta = eta, distance = distance, reason = reason,
                                tackleAge = reason == "tackle" and age or nil,
                                hitboxRemaining = reason == "tackle" and hitboxEndsAt - age or nil,
                                kickChargeFill = reason == "kick" and kick.fill or nil,
                                earliestRelease = reason == "kick" and kick.first or nil, displayLead = displayLead }
                        end
                    end
                end
            end
        end
        if not best or not eligible() then return end
        stats.threats += 1
        local input = N.Controls.CreateInput("Dribble")
        assert(input and N.Controls.IsInput("Dribble", input), "Native dribble binding unavailable")
        retryAt = os.clock() + C.RetrySeconds
        stats.attempts += 1
        -- This owns cooldown, stamina, local movement and the action request together.
        -- Do not call Init/Cleanup or synthesize a separate remote request.
        local attempt = { target = best.character.Name, contactSeconds = best.eta, distance = best.distance, reason = best.reason,
            tackleAgeSeconds = best.tackleAge, hitboxRemainingSeconds = best.hitboxRemaining,
            kickChargeFill = best.kickChargeFill, earliestReleaseSeconds = best.earliestRelease,
            displayLeadSeconds = best.displayLead,
            networkLeadSeconds = lead,
            serverConfirmed = false }
        if d.evaluation then
            d.evaluation.Dribble(attempt, function() d.M.Dodge.HandleInputBegan(input, false) end, best.character)
        else
            d.M.Dodge.HandleInputBegan(input, false)
        end
        local started = d.M.Dodge.IsDribbling() == true
        if started then
            pickupWindow = nil
            stats.started += 1
            if best.reason == "kick" then stats.kickTriggers += 1 else stats.tackleTriggers += 1 end
        else
            stats.nativeBlocked += 1
        end
        A.DribbleStatus = started and "DRIBBLING" or "NATIVE BLOCKED"
        attempt.localStarted = started
        recent[#recent + 1] = attempt
        if #recent > 8 then table.remove(recent, 1) end
    end
    local function runScan()
        queuedScan = nil
        local start = os.clock()
        scanning = true
        local succeeded, tickError = pcall(tick)
        scanning = false
        stats.maxTickMs = math.max(stats.maxTickMs, (os.clock() - start) * 1000)
        if not succeeded then stopDribbleWatch(tickError) end
    end
    requestScan = function()
        if queuedScan or not (alive and A.AutoDribble and d.alive()) then return end
        local ticket = {}
        queuedScan = ticket
        task.defer(function()
            if queuedScan ~= ticket or not (alive and A.AutoDribble and d.alive()) then return end
            -- Evaluate every attacker using the latest packet batch. Coalesce
            -- simultaneous starts/cancellations and never dispatch inside a
            -- native ownership callback or recursively from our own input.
            nextTick = os.clock() + C.Interval
            runScan()
        end)
    end
    -- Read only; used at 10 Hz exclusively during an explicit comparison run.
    function A.ObserveDribbleGate()
        if not (alive and A.AutoDribble and d.alive()) then return nil end
        local ch, rootOrReason = eligible()
        -- Readiness alone does not imply a qualifying incoming attack.
        local gate = ch and "ready" or rootOrReason
        if not ch then
            if gate ~= "COOLDOWN / BLOCKED" and gate ~= "DRIBBLING"
                and gate ~= "LOW STAMINA" and gate ~= "RETRY WAIT" then return nil end
            ch = d.Player.Character
        end
        if gate == "COOLDOWN / BLOCKED" then
            gate = N.Controls.IsOnCooldown("Dribble") and "cooldown" or "native_blocked"
        elseif gate == "DRIBBLING" then gate = "active"
        elseif gate == "LOW STAMINA" then gate = "low_stamina"
        elseif gate == "RETRY WAIT" then gate = "retry_wait" end
        return ch, gate
    end
    function A.SetAutoDribble(value)
        value = value == true
        generation += 1
        local request = generation
        if not value then
            A.AutoDribble = false
            stopWatch()
            A.DribbleStatus = "OFF"
            return true
        end
        if not alive or not d.alive() or loadingDribble then return false end
        if A.AutoDribble then return true end
        loadingDribble = true
        local ok, err = pcall(loadDribble)
        loadingDribble = false
        if request ~= generation or not alive or not d.alive() then return false end
        if not ok then stopDribbleWatch(err); return false end
        A.AutoDribble, A.DribbleStatus, nextTick = true, "WATCHING", 0
        local connected, connectionError = pcall(function()
            watchNativeOwner()
            watchPickupReadiness()
            watchCharacters()
            watchAttacks()
            inputConnection = d.Input.InputBegan:Connect(function(input, processed)
                if not A.AutoDribble then return end
                local checked, inputError = pcall(function()
                    -- A GUI click can share the Kick binding without starting
                    -- a native strike. Do not give it a manual-action grace.
                    if N.Input.ShouldIgnoreKeybind(processed)
                        or (d.ignoreManualInput and d.ignoreManualInput(input)) then return end
                    for _, name in ipairs({ "Kick", "Pass", "Lob", "RainbowFlick", "Dribble", "Tackle", "Jump" }) do
                        if N.Controls.IsInput(name, input) then
                            manualUntil = os.clock() + C.ManualGrace
                            local ch = d.Player.Character
                            manualHadBall = ch ~= nil and ownsBall(ch)
                            break
                        end
                    end
                end)
                if not checked then stopDribbleWatch(inputError) end
            end)
            heartbeat = d.Run.Heartbeat:Connect(function()
                local start = os.clock()
                if not (alive and A.AutoDribble and d.alive()) or start < nextTick then return end
                -- Keep the deadline cadence through uneven mobile frames. Never
                -- run a catch-up loop or send multiple requests in one heartbeat.
                if nextTick == 0 then nextTick = start + C.Interval
                else nextTick += (math.floor((start - nextTick) / C.Interval) + 1) * C.Interval end
                runScan()
            end)
        end)
        if not connected then stopDribbleWatch(connectionError); return false end
        return true
    end
    function A.Cleanup()
        alive = false
        A.SetAutoDribble(false)
        return true
    end
    function A.Debug()
        return { autoDribble = A.AutoDribble, dribbleStatus = A.DribbleStatus,
            lastError = A.LastError, version = "Misc 0.18.0",
            dribbleTrigger = "incoming_tackle_or_kick", tackleLookaheadSeconds = C.Lookahead,
            kickLookaheadSeconds = C.KickLookahead,
            inputMode = N.Input and type(N.Input.GetLastInputType) == "function" and N.Input.GetLastInputType() or nil,
            cooldownRemaining = N.Controls and type(N.Controls.GetCooldownRemaining) == "function"
                and N.Controls.GetCooldownRemaining("Dribble") or nil,
            blockedBy = table.clone(blockedBy), recentGates = table.clone(recentGates),
            lastScan = lastScan and table.clone(lastScan) or nil,
            stats = table.clone(stats), recent = table.clone(recent) }
    end
    if d.test then A.Test = { contactTime = contactTime, segmentBox = segmentBox, kickContactTime = kickContactTime,
        alignDisplayedMotion = alignDisplayedMotion } end
    return A
end

-- Bounded, passive evidence collection. No aim, physics, stamina or action decisions.
local function createStrikerEvaluation(d)
    local A = {}
    local alive, sequence, heartbeat = true, 0, nil
    local shots, dribbles, connections = {}, {}, {}
    local pending, dribbleScopes = {}, setmetatable({}, { __mode = "k" })
    local mainThread, hooks = {}, {}
    local trial, trialSequence, probe, settingsProbe = nil, 0, nil, nil
    local trials, encounters, activeEncounters, roster = {}, {}, {}, {}
    local nextRoster, encounterSequence = 0, 0
    local encounterOwner, encounterBall, encounterContext = nil, nil, nil
    local sampleEncounters
    local nextTick = 0
    local stats = { shots = 0, dribbles = 0, exactFlightMatches = 0, shotRejections = 0,
        dribbleRejections = 0, attributeDribbles = 0, unmatchedMovements = 0,
        unreadableMovements = 0, errors = 0, maxMaintenanceMs = 0, maxCallbackMs = 0,
        proximitySamples = 0, encounters = 0, droppedShots = 0, droppedDribbles = 0, droppedEncounters = 0 }
    local lastError, movementFields = nil, nil
    local function finite(n) return type(n) == "number" and n == n and math.abs(n) < math.huge end
    local function scalar(v) return type(v) == "string" or type(v) == "boolean" or finite(v) end
    local function vector(v) return typeof(v) == "Vector3" and finite(v.X) and finite(v.Y) and finite(v.Z) end
    local function plain(value, depth)
        if scalar(value) then return value end
        if type(value) ~= "table" or (depth or 0) >= 5 then return nil end
        local out = {}
        for k, v in pairs(value) do
            if type(k) == "string" or type(k) == "number" then out[k] = plain(v, (depth or 0) + 1) end
        end
        return out
    end
    local function protect(fn, ...)
        local began = os.clock()
        local result = table.pack(pcall(fn, ...))
        stats.maxCallbackMs = math.max(stats.maxCallbackMs, (os.clock() - began) * 1000)
        if not result[1] then
            stats.errors += 1
            lastError = tostring(result[2])
            return nil
        end
        return table.unpack(result, 2, result.n)
    end
    local function close(record, reason)
        if record.closed then return end
        record.closed = true
        record.observationEnd = reason
        pending[record] = nil
        if record.attributeConnection then
            record.attributeConnection:Disconnect()
            record.attributeConnection = nil
        end
        record.character, record.goal, record.mouth = nil, nil, nil
        record.predictedPosition, record.lastPosition = nil, nil
    end
    local function sameContext(record)
        return record.character == d.Player.Character
            and record.context == d.M.Motion.GetContext(d.Player.Character)
            and record.ballId == d.M.Renderer.GetMatchBallId()
    end
    local function step()
        local now = os.clock()
        for record in pairs(pending) do
            if not sameContext(record) then
                close(record, "context_changed")
            elseif now >= record.deadline then
                if record.kind == "dribble" then
                    record.localOwnerAtWindowEnd = d.M.Renderer.GetOwnedUserId() == d.Player.UserId
                end
                close(record, "window_ended")
            end
        end
        if trial and sampleEncounters then sampleEncounters(now) end
        if not trial and not next(pending) and heartbeat then heartbeat:Disconnect(); heartbeat = nil end
    end
    local function watch(record)
        if record then pending[record] = true end
        if heartbeat then return end
        nextTick = 0
        heartbeat = d.Run.Heartbeat:Connect(function()
            if not alive or not d.alive() then return end
            local now = os.clock()
            if now < nextTick then return end
            nextTick = now + 0.1
            local began = now
            protect(step)
            stats.maxMaintenanceMs = math.max(stats.maxMaintenanceMs, (os.clock() - began) * 1000)
        end)
    end
    local function newRecord(kind, detail)
        if not alive or not d.alive() then return nil end
        sequence += 1
        local r = plain(detail or {})
        r.id, r.kind, r.observedAt = sequence, kind, os.clock()
        r.build, r.trialId = d.build or "unlabelled_build", trial and trial.id or nil
        r.sessionIdTag = d.sessionId
        r.trialLabel, r.scenario = trial and trial.label or nil, trial and trial.scenario or nil
        r.settings = trial and settingsProbe and plain(protect(settingsProbe)) or nil
        r.recordedAtMilliseconds = d.timestamp and d.timestamp() or nil
        r.context = d.M.Motion.GetContext(d.Player.Character)
        r.ballId = d.M.Renderer.GetMatchBallId()
        r.character = d.Player.Character
        r.deadline = r.observedAt + (kind == "shot" and 8 or 1.5)
        r.serverStatus = "unconfirmed"
        if trial then trial[kind == "shot" and "shots" or "dribbles"] += 1 end
        local list = kind == "shot" and shots or dribbles
        list[#list + 1] = r
        if #list > 40 then
            close(table.remove(list, 1), "record_limit")
            local key = kind == "shot" and "droppedShots" or "droppedDribbles"
            stats[key] += 1
        end
        if kind == "shot" then stats.shots += 1 else stats.dribbles += 1 end
        watch(r)
        return r
    end
    local function endEncounters(reason)
        for character, record in pairs(activeEncounters) do
            record.observationEnd = reason
            activeEncounters[character] = nil
        end
    end
    local function encounter(character, gate, distance, now)
        if not trial or not character then return nil end
        local r = activeEncounters[character]
        local context, ball = d.M.Motion.GetContext(d.Player.Character), d.M.Renderer.GetMatchBallId()
        if encounterOwner ~= d.Player.Character or encounterBall ~= ball or encounterContext ~= context then
            endEncounters("context_changed")
            encounterOwner, encounterBall, encounterContext = d.Player.Character, ball, context
            r = nil
        end
        if r and (now - r.lastObservedAt > 0.35 or r.context ~= context or r.ballId ~= ball) then
            r.observationEnd = "separated_or_context_changed"
            activeEncounters[character], r = nil, nil
        end
        if not r then
            encounterSequence += 1
            r = { id = encounterSequence, build = d.build or "unlabelled_build", trialId = trial.id,
                sessionIdTag = d.sessionId,
                trialLabel = trial.label, scenario = trial.scenario, target = character.Name,
                context = context, ballId = ball, observedAt = now, firstGate = gate,
                gates = {}, attemptIds = {} }
            activeEncounters[character] = r
            encounters[#encounters + 1] = r
            stats.encounters += 1
            if #encounters > 60 then
                local old = table.remove(encounters, 1)
                for key, value in pairs(activeEncounters) do if value == old then activeEncounters[key] = nil end end
                stats.droppedEncounters += 1
            end
        end
        r.lastObservedAt = now
        r.gates[gate] = true
        if gate == "eligible" then r.firstEligibleAt = r.firstEligibleAt or now end
        if finite(distance) then r.minimumDistance = math.min(r.minimumDistance or math.huge, distance) end
        return r
    end
    sampleEncounters = function(now)
        if not probe or not d.Players then return end
        -- Report() can be called freely without increasing sampling frequency.
        if trial.nextSample and now < trial.nextSample then return end
        trial.nextSample = now + 0.1
        local ch, gate = probe()
        if not ch then endEncounters("not_observing"); return end
        local team = d.M.Teams.GetActorTeamName(d.Player)
        local opposing = d.M.Match.Constants.TeamDisplayNames[team] and d.M.Match.GetOpposingTeamName(team)
        local ownCF = d.M.Motion.GetCFrame(ch)
        if not opposing or not ownCF or not vector(ownCF.Position) then endEncounters("unavailable_context"); return end
        if now >= nextRoster then
            local seen = {}
            roster = {}
            local function add(character, actor)
                if not character or character == ch or seen[character] then return end
                seen[character] = true
                if #roster >= 128 then trial.rosterTruncated = true; return end
                roster[#roster + 1] = { character = character, actor = actor or character }
            end
            for _, player in ipairs(d.Players:GetPlayers()) do add(player.Character, player) end
            local folder = workspace:FindFirstChild("Characters")
            for _, container in ipairs({ folder, folder and folder:FindFirstChild("NPCs") }) do
                for _, child in ipairs(container:GetChildren()) do if child:IsA("Model") then add(child) end end
            end
            nextRoster = now + 0.5
        end
        stats.proximitySamples += 1
        for _, entry in ipairs(roster) do
            local other = entry.character
            local hum = other.Parent and other:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and d.M.Motion.GetContext(other) == d.M.Motion.GetContext(ch)
                and d.M.Teams.GetActorTeamName(entry.actor) == opposing then
                local otherCF = d.M.Motion.GetCFrame(other)
                if otherCF and vector(otherCF.Position) then
                    local delta = otherCF.Position - ownCF.Position
                    local distance = Vector3.new(delta.X, 0, delta.Z).Magnitude
                    local radius = activeEncounters[other] and 10.5 or 9
                    if math.abs(delta.Y) <= 5 and distance <= radius then encounter(other, gate, distance, now) end
                end
            end
        end
        for character, r in pairs(activeEncounters) do
            if now - r.lastObservedAt > 0.35 then
                r.observationEnd = "left_proximity"
                activeEncounters[character] = nil
            end
        end
    end
    function A.ConfigureComparison(readGate, readSettings)
        probe, settingsProbe = readGate, readSettings
    end
    function A.BeginTrial(label, scenario)
        if not alive or not d.alive() then return false, "Script is unloaded" end
        if trial then return false, "End and export the current run first" end
        if type(label) ~= "string" or not label:find("%S") or #label > 64
            or type(scenario) ~= "string" or not scenario:find("%S") or #scenario > 64 then
            return false, "Use a run label and scenario, each 1-64 characters"
        end
        local settings = settingsProbe and protect(settingsProbe) or nil
        if settingsProbe and type(settings) ~= "table" then return false, "Settings snapshot unavailable" end
        trialSequence += 1
        trial = { id = trialSequence, label = label, scenario = scenario, build = d.build or "unlabelled_build",
            startedAt = os.clock(), settings = plain(settings), firstAttemptId = sequence + 1, shots = 0, dribbles = 0 }
        trials[#trials + 1] = trial
        if #trials > 12 then table.remove(trials, 1) end
        nextRoster = 0
        watch(nil)
        return true, trial.id
    end
    function A.EndTrial()
        if not trial then return false, "No active comparison run" end
        local id = trial.id
        trial.endedAt, trial.lastAttemptId = os.clock(), sequence
        endEncounters("run_ended")
        trial, roster = nil, {}
        protect(step)
        return true, id
    end
    local function noteStrike(command)
        if type(command) ~= "table" then return end
        local strike = command.Kind == "Kick" or command.Kind == "RainbowFlick"
            or command.Kind == "Tackle" and (command.Mode == "Kick" or command.Mode == "Volley")
        if not strike then return end
        for r in pairs(pending) do
            if r.kind == "dribble" and sameContext(r) then
                r.strikeIntent = command.PassType or command.Kind
                r.strikeActionId, r.strikeSessionId = command.ActionId, command.SessionId
                close(r, "strike_intent")
            end
        end
    end
    local function shotSent(detail, frame, command, predictedPosition)
        local r = newRecord("shot", detail)
        if not r then return end
        -- Native Release has already stamped its identifiers; never guess by timing alone.
        r.sessionId, r.actionId = command.SessionId, command.ActionId
        r.charge = command.ChargeSeconds
        r.curve = command.Curve or 0
        r.predictionComparable = frame ~= nil and frame.character == r.character
            and frame.context == r.context and frame.ballId == r.ballId
        if r.predictionComparable then
            r.goal = frame.goal
            -- Engine vectors are private; the public report contains only scalar errors.
            r.predictedPosition = predictedPosition
            r.mouth = frame.mouth
        end
        detail.evaluationId = r.id
    end
    local function beginDribble(detail, target)
        local r = newRecord("dribble", detail)
        if not r then return end
        detail.evaluationId = r.id
        local episode = encounter(target, "eligible", detail.distance, os.clock())
        if episode then
            r.encounterId = episode.id
            if #episode.attemptIds == 0 then r.observedEligibleDelaySeconds = os.clock() - episode.firstEligibleAt end
            episode.attemptIds[#episode.attemptIds + 1] = r.id
        end
        local character = r.character
        if character and type(character.GetAttributeChangedSignal) == "function" then
            -- An already-active attribute is not evidence for this attempt.
            local seenInactive = character:GetAttribute("Dribbling") ~= true
            r.attributeConnection = character:GetAttributeChangedSignal("Dribbling"):Connect(function()
                protect(function()
                    if r.closed or not alive or not sameContext(r) or os.clock() > r.deadline then return end
                    local active = character:GetAttribute("Dribbling") == true
                    if not active then seenInactive = true end
                    if active and seenInactive and not r.dribblingAttributeObserved then
                        r.dribblingAttributeObserved = true
                        stats.attributeDribbles += 1
                    end
                end)
            end)
        end
        return r
    end
    function A.Dribble(detail, invoke, target)
        local r = protect(beginDribble, detail, target)
        local key = coroutine.running() or mainThread
        local previous = dribbleScopes[key]
        dribbleScopes[key] = r
        local result = table.pack(pcall(invoke))
        dribbleScopes[key] = previous
        protect(function()
            if not r then return end
            r.localStarted = result[1] and d.M.Dodge.IsDribbling() == true
            if not r.localStarted then close(r, result[1] and "native_did_not_start" or "native_error") end
        end)
        -- Only a native error propagates. Evidence failures never cancel an action.
        if not result[1] then error(result[2], 0) end
        return table.unpack(result, 2, result.n)
    end
    local function reject(packet)
        if type(packet) ~= "table" or type(packet.Command) ~= "table" then return end
        if not ((packet.Protocol == "ActionCommand" and packet.Phase == "ExecuteRejected")
            or (packet.Protocol == "ActionSession" and packet.Phase == "StartRejected")) then return end
        local command = packet.Command
        for _, list in ipairs({ shots, dribbles }) do
            for _, r in ipairs(list) do
                local matched = r.kind == "dribble" and command.Mode == "Dodge"
                    and r.actionId ~= nil and command.ActionId == r.actionId
                    or r.kind == "shot" and command.PassType == "Shot"
                    and ((r.sessionId ~= nil and command.SessionId == r.sessionId)
                        or (r.actionId ~= nil and command.ActionId == r.actionId))
                if matched and not r.rejected then
                    r.rejected, r.serverStatus = true, "rejected"
                    if r.kind == "shot" then stats.shotRejections += 1 else stats.dribbleRejections += 1 end
                    close(r, "server_rejected")
                end
            end
        end
    end
    local function matchesFlight(r, state)
        return state.ActionId ~= nil and (state.ActionId == r.actionId or state.ActionId == r.sessionId)
            and state.LastKickerUserId == d.Player.UserId and state.LastPassType == "Shot"
    end
    local function ballState(packet)
        if type(packet) ~= "table" or packet.BallId == nil then return end
        if packet.Kind == "Movement" then
            local relevant = false
            for r in pairs(pending) do
                if r.kind == "shot" and r.ballId == packet.BallId then relevant = true; break end
            end
            if not relevant then return end
            -- Only raw server packets qualify, never locally predicted Renderer states.
            local state = type(packet.State) == "table" and packet.State or packet
            if not vector(state.Position) or not finite(state.UpdatedAt or state.StartedAt) then
                stats.unreadableMovements += 1
                if not movementFields then
                    local fields = {}
                    for key in pairs(packet) do fields[#fields + 1] = tostring(key) end
                    table.sort(fields); movementFields = table.concat(fields, ",")
                end
                return
            end
            local matched = false
            for r in pairs(pending) do
                if r.kind == "shot" and r.ballId == packet.BallId and sameContext(r) then
                    if matchesFlight(r, state) then
                        matched = true
                        if not r.flightMatched then
                            r.flightMatched, r.serverStatus = true, "flight_observed"
                            stats.exactFlightMatches += 1
                        end
                        local stamp = state.UpdatedAt or state.StartedAt
                        if not r.lastStateTime or stamp > r.lastStateTime then
                            -- Bracketed goal-plane crossing is an observation, not a score event.
                            local mouth, old = r.mouth, r.lastPosition
                            if mouth and old and not r.crossingObserved then
                                local a, b = (old - mouth.plane):Dot(mouth.forward), (state.Position - mouth.plane):Dot(mouth.forward)
                                if a > 0 and b <= 0 then
                                    local crossing = old:Lerp(state.Position, a / (a - b))
                                    r.crossingObserved = true
                                    r.crossingInsideOpening = math.abs((crossing - mouth.center):Dot(mouth.lateral)) <= mouth.halfWidth
                                        and crossing.Y >= mouth.bottom and crossing.Y <= mouth.top
                                    r.crossingSampleGapSeconds = stamp - r.lastStateTime
                                    if vector(r.predictedPosition) then r.crossingPredictionErrorStuds = (crossing - r.predictedPosition).Magnitude end
                                end
                            end
                            r.lastPosition, r.lastStateTime = state.Position, stamp
                        end
                    elseif r.flightMatched and state.ActionId ~= nil and state.ActionId ~= r.actionId and state.ActionId ~= r.sessionId
                        and (state.UpdatedAt or state.StartedAt) > (r.lastStateTime or -math.huge) then
                        close(r, "different_flight")
                    end
                end
            end
            if not matched then stats.unmatchedMovements += 1 end
        elseif packet.Kind == "Owned" then
            if not finite(packet.OwnerUserId) then return end
            for r in pairs(pending) do
                if r.ballId == packet.BallId and sameContext(r) then
                    if r.kind == "shot" and r.flightMatched then
                        r.ownerAfterFlight = packet.OwnerUserId
                        r.catchFlagObserved = packet.IsDiveCatch == true or packet.IsGoalkeeperJumpCatch == true
                        r.serverStatus = r.catchFlagObserved and "catch_after_flight" or "ownership_after_flight"
                        close(r, "ownership_changed")
                    elseif r.kind == "dribble" and packet.OwnerUserId ~= d.Player.UserId then
                        r.serverPossessionLost = true
                        r.ownerAfterDribble = packet.OwnerUserId
                        close(r, "possession_changed")
                    end
                end
            end
        elseif packet.Kind == "Removed" then
            for r in pairs(pending) do if r.ballId == packet.BallId then close(r, "ball_removed") end end
        end
    end
    local allowed = { shot = { goal = true, saved = true, blocked = true, miss = true, unclear = true },
        dribble = { kept_ball = true, lost_ball = true, interrupted = true, unclear = true } }
    function A.Mark(kind, outcome, id)
        if not allowed[kind] or not allowed[kind][outcome] then return false, "Unknown kind or outcome" end
        local list = kind == "shot" and shots or dribbles
        for i = #list, 1, -1 do
            local r = list[i]
            if id == nil or r.id == id then
                r.userOutcome, r.outcomeSource = outcome, "user_reported"
                return true, r.id
            end
        end
        return false, "No matching recorded attempt"
    end
    function A.MarkTrial(kind, labels, trialId)
        if not allowed[kind] or type(labels) ~= "string" then return false, "Use shot/dribble and a space-separated result list" end
        local run = nil
        for i = #trials, 1, -1 do
            if trialId == nil or trials[i].id == trialId then run = trials[i]; break end
        end
        if not run or not run.endedAt then return false, "End the run before labelling it" end
        local values, records = {}, {}
        for value in labels:gmatch("%S+") do
            if not allowed[kind][value] then return false, "Unknown outcome: " .. value end
            values[#values + 1] = value
        end
        for _, r in ipairs(kind == "shot" and shots or dribbles) do
            if r.trialId == run.id then records[#records + 1] = r end
        end
        if #records ~= run[kind == "shot" and "shots" or "dribbles"] then
            return false, "Some records expired; label retained attempts by ID instead"
        end
        if #records == 0 or #records ~= #values then
            return false, "Expected " .. tostring(#records) .. " outcomes in attempt order; no labels changed"
        end
        for i, r in ipairs(records) do r.userOutcome, r.outcomeSource = values[i], "user_reported" end
        return true, #records
    end
    local function public(list)
        local out = {}
        for _, r in ipairs(list) do
            local item = {}
            for key, value in pairs(r) do
                if key ~= "character" and key ~= "goal" and key ~= "mouth" and key ~= "attributeConnection"
                    and key ~= "predictedPosition" and key ~= "lastPosition" then item[key] = plain(value) end
            end
            out[#out + 1] = item
        end
        return out
    end
    function A.Report()
        protect(step)
        local outcomes = { shots = {}, dribbles = {} }
        for _, entry in ipairs({ { shots, outcomes.shots }, { dribbles, outcomes.dribbles } }) do
            for _, r in ipairs(entry[1]) do
                local label = r.userOutcome or "unlabelled"
                entry[2][label] = (entry[2][label] or 0) + 1
            end
        end
        local evidence = { localStarts = 0, localRetainedAtWindowEnd = 0, ownershipLossObserved = 0,
            strikeInterruptions = 0, rejected = 0, unresolved = 0 }
        for _, r in ipairs(dribbles) do
            if r.localStarted then evidence.localStarts += 1 end
            if r.rejected then evidence.rejected += 1
            elseif r.strikeIntent then evidence.strikeInterruptions += 1
            elseif r.serverPossessionLost then evidence.ownershipLossObserved += 1
            elseif r.localOwnerAtWindowEnd == true then evidence.localRetainedAtWindowEnd += 1
            else evidence.unresolved += 1 end
        end
        return { version = "Evaluation 0.2", build = d.build or "unlabelled_build", sessionIdTag = d.sessionId,
            stats = table.clone(stats), lastError = lastError,
            rawMovementFields = movementFields, recentShots = public(shots), recentDribbles = public(dribbles),
            recentEncounters = plain(encounters), trials = plain(trials), activeTrialId = trial and trial.id or nil,
            dribbleObservations = evidence, encounterSampling = "10 Hz during a run; 9-stud entry, 10.5-stud exit, 0.35s separation; sampled proximity, not every tackle",
            userReportedOutcomes = outcomes, outcomeWindow = "last 40 of each kind",
            automaticGoalConfirmation = false, globalBestShotProven = false }
    end
    function A.Call(name, ...)
        if name == "ShotSent" then return protect(shotSent, ...) end
        return nil
    end
    function A.Cleanup()
        alive = false
        if trial then A.EndTrial() end
        for r in pairs(pending) do protect(close, r, "unloaded") end
        if heartbeat then heartbeat:Disconnect(); heartbeat = nil end
        for _, c in ipairs(connections) do c:Disconnect() end
        table.clear(connections)
        for name, hook in pairs(hooks) do
            if d.M.Protocol[name] == hook.wrapper then d.M.Protocol[name] = hook.original end
        end
        return true
    end
    protect(function()
        for _, name in ipairs({ "Send", "Release" }) do
            local hook = { original = d.M.Protocol[name] }
            if type(hook.original) ~= "function" then continue end
            hook.wrapper = function(command, ...)
                if not alive or not d.alive() then return hook.original(command, ...) end
                local r = dribbleScopes[coroutine.running() or mainThread]
                if not r and not next(pending) then return hook.original(command, ...) end
                local result = table.pack(hook.original(command, ...))
                protect(function()
                    if r and command.Mode == "Dodge" then r.actionId = command.ActionId or result[1] end
                    noteStrike(command)
                end)
                return table.unpack(result, 1, result.n)
            end
            hooks[name] = hook
            d.M.Protocol[name] = hook.wrapper
        end
        connections[#connections + 1] = d.State.OnClientEvent:Connect(function(packet)
            if alive and d.alive() and next(pending) then protect(ballState, packet) end
        end)
        for _, remote in ipairs(d.CommandRemotes) do
            connections[#connections + 1] = remote.OnClientEvent:Connect(function(packet)
                if alive and d.alive() then protect(reject, packet) end
            end)
        end
    end)
    return A
end

local evaluationRemotes = {}
for _, remote in ipairs(BallRemotes:GetChildren()) do
    if remote ~= StateRemote and (remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent")) then
        evaluationRemotes[#evaluationRemotes + 1] = remote
    end
end
local EVALUATION = createStrikerEvaluation({
    M = M, Player = LocalPlayer, Players = Players, Run = RunService, State = StateRemote,
    build = "Dmc 2026.10.02.1",
    sessionId = game:GetService("HttpService"):GenerateGUID(false),
    CommandRemotes = evaluationRemotes, alive = function() return S.alive end,
    timestamp = function() return DateTime.now().UnixTimestampMillis end,
})
S.releaseEvaluation = EVALUATION.Cleanup
ENV.DmcEvaluationReport = function()
    local result = EVALUATION.Report()
    local http = game:GetService("HttpService")
    local summary = table.clone(result)
    summary.recentShots, summary.recentDribbles, summary.recentEncounters = nil, nil, nil
    print("[Dmc Evaluation]", http:JSONEncode(summary))
    for _, record in ipairs(result.recentShots) do print("[Dmc Shot]", http:JSONEncode(record)) end
    for _, record in ipairs(result.recentDribbles) do print("[Dmc Dribble]", http:JSONEncode(record)) end
    for _, record in ipairs(result.recentEncounters) do print("[Dmc Encounter]", http:JSONEncode(record)) end
    return result
end
ENV.DmcBeginTrial = function(label, scenario)
    local ok, detail = EVALUATION.BeginTrial(label, scenario)
    print("[Dmc Evaluation]", ok and "Run started" or "Not started", detail)
    return ok, detail
end
ENV.DmcEndTrial = function()
    local ok, detail = EVALUATION.EndTrial()
    print("[Dmc Evaluation]", ok and "Run ended" or "Not ended", detail)
    return ENV.DmcEvaluationReport()
end
ENV.DmcMarkTrial = function(kind, outcomes, trialId)
    local ok, detail = EVALUATION.MarkTrial(kind, outcomes, trialId)
    print("[Dmc Evaluation]", ok and "Run outcomes recorded" or "Not recorded", detail)
    if ok then return ENV.DmcEvaluationReport() end
    return ok, detail
end
ENV.DmcMarkOutcome = function(kind, outcome, id)
    local ok, detail = EVALUATION.Mark(kind, outcome, id)
    print("[Dmc Evaluation]", ok and "Outcome recorded" or "Not recorded", detail)
    return ok, detail
end
local STR = createStriker({
    M = M, Player = LocalPlayer, Players = Players, Input = UserInputService,
    load = module, alive = function() return S.alive end,
    uiBusy = function() return S.uiBusy end, evaluation = EVALUATION,
})
S.releaseStriker = STR.Cleanup
ENV.AutoSTR = STR
ENV.AutoSTRDebug = function()
    local result = STR.Debug()
    print("[Auto STR]", game:GetService("HttpService"):JSONEncode(result))
    return result
end
local MISC = createStrikerMisc({
    M = M, Player = LocalPlayer, Players = Players, Input = UserInputService,
    Run = RunService, Gui = game:GetService("GuiService"), load = module,
    id = game:GetService("HttpService"):GenerateGUID(false),
    alive = function() return S.alive end,
    -- Visual UI interactions do not suspend the defensive threat watcher.
    -- Native text/chat, menu, strike and recovery gates still apply.
    suspended = function() return not S.focused end, evaluation = EVALUATION,
    ignoreManualInput = function(input) return S.isUIInput and S.isUIInput(input) or false end,
    AttackRemotes = evaluationRemotes,
})
S.releaseMisc = MISC.Cleanup
EVALUATION.ConfigureComparison(MISC.ObserveDribbleGate, function()
    return { bestShot = STR.Enabled, autoCurve = STR.AutoCurve, smartRelease = STR.SmartRelease,
        autoDribble = MISC.AutoDribble }
end)
ENV.DmcMisc = MISC
ENV.DmcMiscDebug = function()
    local result = MISC.Debug()
    print("[Dmc Misc]", game:GetService("HttpService"):JSONEncode(result))
    return result
end

--==============================================================
-- INTERFACE CONTROLS
--==============================================================

local function toggleEnabled(value)
    ENV.AUTO_GK_ENABLED = value == true
    S.nextPlanAt = 0

    if ENV.AUTO_GK_ENABLED then
        S.runtimeFailures = 0
        S.runtimeRetryAt = 0
        S.runtimeError = nil
    end

    if not ENV.AUTO_GK_ENABLED then
        releaseOwnedState(true)
        status("OFF", "Manual controls untouched")
    end
end

--==============================================================
-- INTERFACE
--==============================================================

do
    local oldGui = PlayerGui:FindFirstChild("AutoGKInterface")
    if oldGui then oldGui:Destroy() end

    local C = {
        background = Color3.fromRGB(16, 16, 15),
        surface = Color3.fromRGB(23, 23, 21),
        control = Color3.fromRGB(29, 29, 26),
        hover = Color3.fromRGB(39, 37, 30),
        pressed = Color3.fromRGB(53, 47, 32),
        stroke = Color3.fromRGB(49, 47, 39),
        text = Color3.fromRGB(242, 243, 240),
        muted = Color3.fromRGB(178, 181, 175),
        accent = Color3.fromRGB(222, 193, 115),
        accentDim = Color3.fromRGB(131, 111, 61),
        active = Color3.fromRGB(43, 39, 27),
    }

    local readableFont = Font.new(Font.fromEnum(Enum.Font.Nunito).Family, Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    local themeBindings = {}
    local function trackTheme(object, properties)
        local bindings = themeBindings[object] or {}
        for _, property in ipairs({ "BackgroundColor3", "TextColor3", "PlaceholderColor3", "Color", "ScrollBarImageColor3" }) do
            local value = properties[property]
            if value ~= nil then
                bindings[property] = nil
                for key, color in pairs(C) do
                    if value == color then bindings[property] = key; break end
                end
            end
        end
        themeBindings[object] = bindings
    end
    local function setThemed(object, property, value)
        trackTheme(object, { [property] = value })
        object[property] = value
    end
    local function setPalette(hex)
        local r, g, b = tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
        C.accent = Color3.fromRGB(r, g, b)
        if hex == "DEC173" then
            C.accentDim, C.active = Color3.fromRGB(131, 111, 61), Color3.fromRGB(43, 39, 27)
            C.hover, C.pressed, C.stroke = Color3.fromRGB(39, 37, 30), Color3.fromRGB(53, 47, 32), Color3.fromRGB(49, 47, 39)
        else
            local function blend(base, weight)
                return Color3.fromRGB(math.floor(base + (r - base) * weight + 0.5),
                    math.floor(base + (g - base) * weight + 0.5), math.floor(base + (b - base) * weight + 0.5))
            end
            C.accentDim, C.active = blend(16, 0.55), blend(16, 0.13)
            C.hover, C.pressed, C.stroke = blend(24, 0.08), blend(24, 0.16), blend(35, 0.09)
        end
    end

    local function create(class, properties, parent)
        local object = Instance.new(class)
        for key, value in pairs(properties) do object[key] = value end
        if properties.Font == Enum.Font.Nunito then object.FontFace = readableFont end
        trackTheme(object, properties)
        object.Parent = parent
        return object
    end

    local function round(object, radius)
        create("UICorner", { CornerRadius = UDim.new(0, radius) }, object)
        return object
    end

    local function stroke(object, color, thickness)
        return create("UIStroke", {
            Color = color or C.stroke,
            Thickness = thickness or 1,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        }, object)
    end

    local function frame(parent, name, x, y, w, h, color)
        return create("Frame", {
            Name = name, Position = UDim2.fromOffset(x, y),
            Size = UDim2.fromOffset(w, h), BackgroundColor3 = color or C.surface,
            BorderSizePixel = 0,
        }, parent)
    end

    local function text(parent, value, size, properties)
        local p = {
            Text = value, TextSize = math.max(13, size + 3), Font = Enum.Font.Nunito,
            TextColor3 = C.text, BackgroundTransparency = 1,
            TextXAlignment = Enum.TextXAlignment.Left,
            BorderSizePixel = 0,
        }
        for key, v in pairs(properties or {}) do p[key] = v end
        return create("TextLabel", p, parent)
    end

    local function button(parent, properties)
        local p = {
            Text = "", TextSize = 14, Font = Enum.Font.FredokaOne,
            TextColor3 = C.text, BackgroundColor3 = C.control,
            BorderSizePixel = 0, AutoButtonColor = false,
            Modal = false, Selectable = true,
        }
        for key, value in pairs(properties) do p[key] = value end
        return round(create("TextButton", p, parent), 5)
    end

    local function chevron(parent, name, x, y)
        local icon = frame(parent, name, x, y, 14, 14)
        icon.BackgroundTransparency, icon.Visible = 1, true
        icon.ZIndex = parent.ZIndex + 1
        local white = Color3.fromRGB(255, 255, 255)
        local left = round(frame(icon, "Left", 1, 6, 8, 3, white), 2)
        local right = round(frame(icon, "Right", 6, 6, 8, 3, white), 2)
        left.Rotation, right.Rotation = 45, -45
        left.ZIndex, right.ZIndex = icon.ZIndex + 1, icon.ZIndex + 1
        left.BackgroundTransparency, right.BackgroundTransparency = 0, 0
        themeBindings[left].BackgroundColor3, themeBindings[right].BackgroundColor3 = nil, nil
        return icon
    end

    local Gui = create("ScreenGui", {
        Name = "AutoGKInterface", ResetOnSpawn = false, Enabled = true,
        IgnoreGuiInset = true, DisplayOrder = 20,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, PlayerGui)
    S.ui = Gui

    -- Host position is in screen pixels; only the panel and its children scale.
    local host = create("Frame", {
        Name = "WindowHost", Position = UDim2.fromOffset(20, 138),
        Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, Gui)
    local panel = round(frame(host, "Panel", 0, 0, 316, 494, C.background), 9)
    panel.Active = true
    stroke(panel, C.accentDim)
    local uiScale = create("UIScale", { Scale = 1 }, panel)
    local header = frame(panel, "DragHandle", 12, 0, 224, 40)
    header.BackgroundTransparency = 1
    header.Active = true
    text(header, "Dmc", 13, {
        Name = "PageTitle", Size = UDim2.fromScale(1, 1),
        Font = Enum.Font.FredokaOne,
    })
    local minimize = button(panel, {
        Name = "Minimize", Text = "-", TextSize = 18,
        Position = UDim2.new(1, -68, 0, 8), Size = UDim2.fromOffset(24, 24),
    })
    local unload = button(panel, {
        Name = "Unload", Text = "x", TextSize = 12,
        Position = UDim2.new(1, -36, 0, 8), Size = UDim2.fromOffset(24, 24),
    })
    local tabBar = frame(panel, "Tabs", 12, 44, 292, 26)
    tabBar.BackgroundTransparency = 1
    -- STR is independent of the goalkeeper automation toggle.
    local strikerContent = frame(panel, "STRContent", 12, 76, 292, 333)
    strikerContent.BackgroundTransparency = 1
    strikerContent.Visible = false
    local live = round(frame(panel, "LiveStatus", 12, 76, 292, 28, C.surface), 5)
    local dot = round(frame(live, "StatusDot", 10, 11, 6, 6, C.muted), 3)
    local stateText = text(live, "STARTING", 10, {
        Name = "Status", Position = UDim2.fromOffset(24, 0),
        Size = UDim2.new(1, -34, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd,
    })
    -- GK retains its existing controls in one scroll surface below the tabs.
    local content = create("ScrollingFrame", {
        Name = "MainContent", Position = UDim2.fromOffset(12, 114),
        Size = UDim2.fromOffset(292, 368), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 2, ScrollBarImageColor3 = C.accentDim,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, panel)
    create("UIListLayout", {
        Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
    }, content)
    local refreshers = {}
    local animations = {}
    local animationEnds = {}
    local animationGoals = {}
    local dropdowns = {}
    local expanded = nil
    local dragging = false
    local rangeInput = nil
    local minimized = false
    local activeTab = "GK"
    local settingsBusy = false
    local editingField = nil
    local colorPickerOpen = false
    local closeColorPicker: (() -> ())? = nil
    -- Hit-test the current visible panel rather than hover state: the global
    -- InputBegan observer may run before a control's own callback.
    S.isUIInput = function(input)
        if not S.alive or not Gui.Parent or not Gui.Enabled or not panel.Visible then return false end
        local kind = input.UserInputType
        if kind ~= Enum.UserInputType.MouseButton1 and kind ~= Enum.UserInputType.MouseButton2
            and kind ~= Enum.UserInputType.MouseButton3 and kind ~= Enum.UserInputType.Touch then return false end
        local point, position, size = input.Position, panel.AbsolutePosition, panel.AbsoluteSize
        return point.X >= position.X and point.X < position.X + size.X
            and point.Y >= position.Y and point.Y < position.Y + size.Y
    end
    local function updateUIBusy()
        S.uiBusy = dragging or rangeInput ~= nil or expanded ~= nil or settingsBusy or editingField ~= nil or colorPickerOpen
    end
    local activeBody = nil
    local order = 0

    local function cancelAnimation(object)
        if animationEnds[object] then animationEnds[object]:Disconnect() end
        animationEnds[object] = nil
        if animations[object] then animations[object]:Cancel() end
        animations[object] = nil
        animationGoals[object] = nil
    end

    local function animate(object, goals, immediate, duration, onComplete)
        cancelAnimation(object)
        trackTheme(object, goals)
        if immediate then
            for k, v in pairs(goals) do object[k] = v end
            if onComplete then onComplete() end
            return
        end
        local tween = TweenService:Create(object,
            TweenInfo.new(duration or 0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goals)
        animations[object] = tween
        animationGoals[object] = goals
        animationEnds[object] = tween.Completed:Connect(function(playbackState)
            -- Cancellation also fires Completed; only the current finished tween owns this callback.
            if animations[object] ~= tween then return end
            local connection = animationEnds[object]
            if connection then connection:Disconnect() end
            animationEnds[object] = nil
            animations[object] = nil
            animationGoals[object] = nil
            if playbackState == Enum.PlaybackState.Completed and S.alive then
                for property, key in pairs(themeBindings[object] or {}) do
                    if goals[property] ~= nil then object[property] = C[key] end
                end
            end
            if playbackState == Enum.PlaybackState.Completed and S.alive and onComplete then
                onComplete()
            end
        end)
        tween:Play()
    end

    S.cancelUITweens = function()
        for object in pairs(animations) do
            cancelAnimation(object)
        end
    end

    local function hover(object, baseColor)
        local hovered, held, previous = false, nil, nil
        local function draw(immediate)
            local color = held and C.pressed or hovered and C.hover
                or (baseColor and baseColor() or C.control)
            if color == previous then return end
            previous = color
            animate(object, { BackgroundColor3 = color }, immediate, held and 0.07 or 0.14)
        end
        local function reset()
            hovered, held = false, nil
            if S.alive then draw(false) end
        end
        connect(object.MouseEnter, function()
            if not S.alive then return end
            hovered = true
            draw(false)
        end)
        connect(object.MouseLeave, reset)
        connect(object.InputBegan, function(input)
            if not S.alive or object.Interactable == false then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                held = input
                draw(false)
            end
        end)
        connect(UserInputService.InputEnded, function(input)
            if not S.alive or not held then return end
            if input == held or (held.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseButton1) then
                held = nil
                draw(false)
            end
        end)
        connect(UserInputService.WindowFocusReleased, reset)
        draw(true)
        return draw, reset
    end
    hover(minimize)
    hover(unload)

    local function closeDropdown(immediate)
        rangeInput = nil
        local previous = expanded
        expanded = nil
        if immediate then
            for _, entry in ipairs(dropdowns) do entry.setOpen(false, true) end
        elseif previous then
            previous.setOpen(false, false)
        end
        if editingField then
            local field = editingField
            editingField = nil
            field:ReleaseFocus()
        end
        local closePicker = closeColorPicker
        if closePicker then closePicker() end
        updateUIBusy()
    end
    S.closeDropdown = function() closeDropdown(true) end

    local function inside(point, object)
        local p, size = object.AbsolutePosition, object.AbsoluteSize
        return point.X >= p.X and point.X <= p.X + size.X
            and point.Y >= p.Y and point.Y <= p.Y + size.Y
    end

    local function section(name)
        local card = frame(content, name, 0, 0, 0, 22)
        card.Size = UDim2.new(1, -4, 0, 22)
        card.BackgroundTransparency = 1
        card.AutomaticSize = Enum.AutomaticSize.Y
        card.LayoutOrder = name == "AUTOMATION" and 1 or 2
        text(card, name, 9, {
            Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, 0, 0, 16),
            Font = Enum.Font.FredokaOne, TextColor3 = C.muted,
        })
        activeBody = frame(card, "Options", 0, 22, 0, 0)
        activeBody.Size = UDim2.new(1, 0, 0, 0)
        activeBody.BackgroundTransparency = 1
        activeBody.AutomaticSize = Enum.AutomaticSize.Y
        create("UIListLayout", {
            Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder,
        }, activeBody)
        order = 0
    end

    local function toggle(label, getter, setter)
        order = order + 1
        local control = button(activeBody, {
            Name = label, Size = UDim2.new(1, 0, 0, 32), LayoutOrder = order,
        })
        text(control, label, 11, {
            Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -82, 1, 0),
        })
        local state = text(control, "", 9, {
            Name = "Value", Position = UDim2.new(1, -69, 0, 0),
            Size = UDim2.fromOffset(30, 32), TextXAlignment = Enum.TextXAlignment.Right,
        })
        -- One solid square owns the fill; no rounded mask or inset layer leaves dark corner cutouts.
        local box = frame(control, "Checkbox", 0, 7, 18, 18, C.control)
        box.Position = UDim2.new(1, -30, 0, 7)
        local border = stroke(box, C.accentDim)
        local check = frame(box, "Check", 0, 0, 18, 18)
        check.BackgroundTransparency = 1
        local short = frame(check, "Short", 3, 9, 6, 2, C.background)
        short.Rotation = 45
        local long = frame(check, "Long", 6, 7, 9, 2, C.background)
        long.Rotation = -45
        local previous = nil
        local function refresh(immediate)
            local enabled = getter() == true
            if enabled == previous then return end
            previous = enabled
            state.Text = enabled and "ON" or "OFF"
            border.Transparency = enabled and 1 or 0
            animate(state, { TextColor3 = enabled and C.accent or C.muted }, immediate)
            animate(short, { BackgroundTransparency = enabled and 0 or 1 }, immediate)
            animate(long, { BackgroundTransparency = enabled and 0 or 1 }, immediate)
            animate(box, { BackgroundColor3 = enabled and C.accent or C.control }, immediate)
        end
        hover(control)
        connect(control.Activated, function()
            if not S.alive then return end
            closeDropdown()
            setter(not getter())
            refresh(false)
        end)
        refresh(true)
        table.insert(refreshers, function() refresh(false) end)
        return refresh
    end

    local function dropdown(label, choices, getter, setter)
        order = order + 1
        local body = activeBody
        local row = frame(body, label, 0, 0, 0, 34)
        row.BackgroundTransparency = 1
        row.Size = UDim2.new(1, 0, 0, 34)
        row.LayoutOrder = order
        row.ClipsDescendants = true
        text(row, label, 11, {
            Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(110, 34),
            TextColor3 = C.muted,
        })
        local selectButton = button(row, {
            Name = "Select", Position = UDim2.fromOffset(128, 2),
            Size = UDim2.new(1, -128, 0, 30),
        })
        stroke(selectButton)
        local selected = text(selectButton, "", 11, {
            Name = "SelectedValue", Position = UDim2.fromOffset(12, 0),
            Size = UDim2.new(1, -45, 1, 0),
        })
        local arrow = chevron(selectButton, "Arrow", 0, 8)
        arrow.Position = UDim2.new(1, -28, 0, 8)
        local menuHeight = #choices * 32 - 4
        local menu = frame(row, "Choices", 0, 38, 0, menuHeight)
        menu.Size = UDim2.new(1, 0, 0, menuHeight)
        menu.BackgroundTransparency = 1
        menu.Visible = false
        create("UIListLayout", {
            Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
        }, menu)
        local entry = { row = row, menu = menu, arrow = arrow, body = body, open = false }
        local items = {}
        entry.setOpen = function(open, immediate)
            entry.open = open
            if open then menu.Visible = true end
            for _, item in ipairs(items) do
                item.button.Interactable = open
                item.marker.Visible = getter() == item.value
                if not open then item.reset() end
            end
            animate(arrow, { Rotation = open and 180 or 0 }, immediate, 0.18)
            animate(row, { Size = UDim2.new(1, 0, 0, open and (42 + menuHeight) or 34) },
                immediate, open and 0.18 or 0.14, function()
                    if not entry.open then
                        menu.Visible = false
                        -- The parent scroll surface retains its position as the row closes.
                    end
                end)
        end
        table.insert(dropdowns, entry)
        local previousValue, selectionInitialized = nil, false
        local function refresh(immediate)
            local value = getter()
            if selectionInitialized and value == previousValue then return end
            previousValue, selectionInitialized = value, true
            for _, item in ipairs(items) do
                local active = value == item.value
                if active then selected.Text = item.label end
                item.text.Text = item.label
                item.marker.Visible = active
                setThemed(item.text, "TextColor3", active and C.accent or C.text)
                item.repaint(immediate)
            end
        end
        for index, choice in ipairs(choices) do
            local option = button(menu, {
                Name = choice.value, TextXAlignment = Enum.TextXAlignment.Left,
                Size = UDim2.new(1, 0, 0, 28), LayoutOrder = index,
                Interactable = false,
            })
            local optionText = text(option, choice.label, 11, {
                Name = "Label", Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -44, 1, 0),
                TextTruncate = Enum.TextTruncate.AtEnd,
            })
            local marker = chevron(option, "SelectedChevron", 10, 7)
            marker.Rotation = -90
            local repaint, reset = hover(option, function()
                return getter() == choice.value and C.active or C.control
            end)
            table.insert(items, {
                button = option, text = optionText, marker = marker, value = choice.value, label = choice.label,
                repaint = repaint, reset = reset,
            })
            connect(option.Activated, function()
                if not S.alive or expanded ~= entry then return end
                setter(choice.value)
                refresh()
                closeDropdown()
            end)
        end
        hover(selectButton)
        connect(selectButton.Activated, function()
            if not S.alive then return end
            local wasOpen = expanded == entry
            closeDropdown(not wasOpen)
            if not wasOpen then
                expanded = entry
                S.uiBusy = true
                entry.setOpen(true, false)
                invalidateFrame(true)
            end
        end)
        refresh(true)
        table.insert(refreshers, refresh)
    end

    -- Existing settings and their original setters are inserted here verbatim.
    section("AUTOMATION")

    toggle(
        "Auto save",
        function()
            return ENV.AUTO_GK_ENABLED
        end,
        toggleEnabled
    )

    toggle(
        "Close-range rush",

        function()
            return Config.CloseRangeRush
        end,

        function(value)
            Config.CloseRangeRush = value
            Rush.candidate = nil
        end
    )

    toggle(
        "High-ball jumps",

        function()
            return Config.HighBallJumps
        end,

        function(value)
            Config.HighBallJumps = value
        end
    )

    toggle(
        "Jump then dive",

        function()
            return Config.JumpThenDive
        end,

        function(value)
            Config.JumpThenDive = value
        end
    )

    dropdown(
        "Dive direction",

        {
            { value = "SMART", label = "Smart" },
            { value = "FORWARD", label = "Forward" },
            { value = "LEFT", label = "Left" },
            { value = "RIGHT", label = "Right" },
            { value = "SIDES", label = "Sides" },
        },

        function()
            return Config.DiveFilter == "ALL"
                and "SMART"
                or Config.DiveFilter
        end,

        function(value)
            Config.DiveFilter = value
        end
    )

    toggle(
        "Lob / back recovery",

        function()
            return Config.BackwardRecovery
        end,

        function(value)
            Config.BackwardRecovery = value
        end
    )

    section("POSITIONING")

    toggle(
        "Position assist",

        function()
            return Config.PositionAssist
        end,

        function(value)
            Config.PositionAssist = value

            if not value then
                invalidateFrame(true)
            end
        end
    )

    toggle(
        "Pre-shot coverage",

        function()
            return Config.PreShotCoverage
        end,

        function(value)
            Config.PreShotCoverage = value
            invalidateFrame(true)
        end
    )

    dropdown(
        "Position mode",

        {
            { value = "THREATS", label = "Threats only" },
            {
                value = "HOME_AND_THREATS",
                label = "Home + threats",
            },
        },

        function()
            return Config.PositionMode
        end,

        function(value)
            Config.PositionMode = value
            invalidateFrame(true)
        end
    )

    toggle(
        "Manual movement first",

        function()
            return Config.RespectManualMovement
        end,

        function(value)
            Config.RespectManualMovement = value
        end
    )

    local gkRefresherCount = #refreshers
    local shootingSection = frame(strikerContent, "Shooting", 0, 0, 292, 179)
    shootingSection.BackgroundTransparency = 1
    text(shootingSection, "SHOOTING", 9, {
        Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(292, 16),
        Font = Enum.Font.FredokaOne, TextColor3 = C.muted,
    })
    activeBody = frame(shootingSection, "Options", 0, 22, 292, 157)
    activeBody.BackgroundTransparency = 1
    create("UIListLayout", {
        Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder,
    }, activeBody)
    order = 0
    toggle("Best shot assist", function() return STR.Enabled end, STR.SetEnabled)
    toggle("Auto curve ball", function() return STR.AutoCurve end, STR.SetAutoCurve)
    toggle("Smart shot release", function() return STR.SmartRelease end, STR.SetSmartRelease)
    do
        order += 1
        local row = frame(activeBody, "ShotRange", 0, 0, 292, 49, C.control)
        row.Size = UDim2.new(1, 0, 0, 49)
        row.LayoutOrder = order
        text(row, "Shot range  40–100", 10, {
            Position = UDim2.fromOffset(12, 0), Size = UDim2.fromOffset(174, 24),
        })
        local value = text(row, "", 10, {
            Name = "Value", Position = UDim2.new(1, -92, 0, 0),
            Size = UDim2.fromOffset(80, 24), TextXAlignment = Enum.TextXAlignment.Right,
            TextColor3 = C.accent,
        })
        local handle = button(row, {
            Name = "RangeInput", Position = UDim2.fromOffset(12, 23),
            Size = UDim2.new(1, -24, 0, 24), BackgroundTransparency = 1, Text = "",
        })
        local track = round(frame(handle, "Track", 7, 10, 0, 4, C.accentDim), 2)
        track.Size = UDim2.new(1, -14, 0, 4)
        local fill = round(frame(track, "Fill", 0, 0, 0, 4, C.accent), 2)
        local knob = round(frame(track, "Knob", 0, -5, 14, 14, C.accent), 7)
        knob.AnchorPoint = Vector2.new(0.5, 0)
        local previous
        local function drawRange()
            local range = STR.GetAssistRange()
            if range == previous then return end
            previous = range
            local alpha = (range - 40) / 60
            value.Text = tostring(range) .. " studs"
            fill.Size = UDim2.new(alpha, 0, 1, 0)
            knob.Position = UDim2.new(alpha, 0, 0, -5)
        end
        local function setFromPoint(point)
            local width = track.AbsoluteSize.X
            if width <= 0 then return end
            local alpha = math.clamp((point.X - track.AbsolutePosition.X) / width, 0, 1)
            STR.SetAssistRange(40 + alpha * 60)
            drawRange()
        end
        connect(handle.InputBegan, function(input)
            if not S.alive or not Gui.Enabled or minimized or activeTab ~= "STR" or dragging or rangeInput then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                closeDropdown(true)
                rangeInput = input
                S.uiBusy = true
                setFromPoint(input.Position)
            end
        end)
        connect(UserInputService.InputChanged, function(input)
            if not S.alive or not rangeInput then return end
            if input == rangeInput or (rangeInput.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseMovement) then setFromPoint(input.Position) end
        end)
        connect(UserInputService.InputEnded, function(input)
            if rangeInput and (input == rangeInput or (rangeInput.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseButton1)) then
                rangeInput = nil
                updateUIBusy()
            end
        end)
        drawRange()
        table.insert(refreshers, drawRange)
    end
    local miscellaneousSection = frame(strikerContent, "Miscellaneous", 0, 193, 292, 54)
    miscellaneousSection.BackgroundTransparency = 1
    text(miscellaneousSection, "MISCELLANEOUS", 9, {
        Position = UDim2.fromOffset(0, 0), Size = UDim2.fromOffset(292, 16),
        Font = Enum.Font.FredokaOne, TextColor3 = C.muted,
    })
    activeBody = frame(miscellaneousSection, "Options", 0, 22, 292, 32)
    activeBody.BackgroundTransparency = 1
    create("UIListLayout", {
        Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder,
    }, activeBody)
    order = 0
    toggle("Auto dribble", function() return MISC.AutoDribble end, MISC.SetAutoDribble)
    local strikerStatus = text(strikerContent, "OFF", 11, {
        Name = "StrikerStatus", Position = UDim2.fromOffset(8, 257),
        Size = UDim2.fromOffset(276, 30), TextWrapped = true,
        Font = Enum.Font.FredokaOne, TextColor3 = C.accent,
    })
    local miscellaneousStatus = text(strikerContent, "", 9, {
        Name = "MiscStatus", Position = UDim2.fromOffset(8, 291), Size = UDim2.fromOffset(276, 28),
        TextWrapped = true, TextColor3 = C.muted,
    })

    local fit
    local settingsContent
    do
    settingsContent = create("ScrollingFrame", {
        Name = "SettingsContent", Position = UDim2.fromOffset(12, 76),
        Size = UDim2.fromOffset(292, 296), BackgroundTransparency = 1,
        BorderSizePixel = 0, ClipsDescendants = true, Visible = false,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        ScrollBarThickness = 2, ScrollBarImageColor3 = C.accentDim,
        CanvasSize = UDim2.fromOffset(0, 335),
    }, panel)
    -- The saved accent stays static; only the displayed palette cycles.
    local currentAccent = SettingsStore.Accent
    local rainbowUI = SettingsStore.RainbowUI == true
    local rainbowHue, rainbowElapsed = 0, 0
    local refreshColorUI, refreshRainbowToggle
    local cyclingKeys = { accent = true, accentDim = true, active = true,
        hover = true, pressed = true, stroke = true }
    local function rainbowAccent()
        local color = Color3.fromHSV(rainbowHue, 0.68, 1)
        return string.format("%02X%02X%02X", math.floor(color.R * 255 + 0.5),
            math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
    end
    local function repaintPalette(hex, settleColors)
        setPalette(hex)
        if settleColors then
            -- Color-only hover tweens may end at an older hue. Size and arrow
            -- animations keep running when the rainbow switch changes.
            for object, goals in pairs(animationGoals) do
                local bindings, colorOnly = themeBindings[object] or {}, true
                for property in pairs(goals) do
                    if not bindings[property] then colorOnly = false; break end
                end
                if colorOnly then cancelAnimation(object) end
            end
        end
        for object, properties in pairs(themeBindings) do
            if object.Parent then
                local goals = animationGoals[object]
                for property, key in pairs(properties) do
                    if cyclingKeys[key] and not (goals and goals[property] ~= nil)
                        and object[property] ~= C[key] then object[property] = C[key] end
                end
            end
        end
    end
    local function setRainbowUI(value)
        rainbowUI = value == true
        rainbowElapsed = 0
        repaintPalette(rainbowUI and not colorPickerOpen and rainbowAccent() or currentAccent, true)
        if refreshRainbowToggle then refreshRainbowToggle(false) end
    end
    local function applyTheme(hex)
        currentAccent = hex
        for object, goals in pairs(animationGoals) do
            for property, value in pairs(goals) do object[property] = value end
        end
        S.cancelUITweens()
        repaintPalette(rainbowUI and not colorPickerOpen and rainbowAccent() or hex, false)
        if refreshColorUI then refreshColorUI() end
    end
    applyTheme(currentAccent)
    connect(RunService.Heartbeat, function(dt)
        if not S.alive or not rainbowUI or not Gui.Parent or not Gui.Enabled
            or minimized or S.focused == false or colorPickerOpen then return end
        rainbowHue = (rainbowHue + dt / 12) % 1
        rainbowElapsed += dt
        if rainbowElapsed < 1 / 30 then return end
        rainbowElapsed %= 1 / 30
        repaintPalette(rainbowAccent(), false)
    end)
    local settingsController = createDmcSettingsController({
        config = Config, striker = STR, misc = MISC,
        gkEnabled = function() return ENV.AUTO_GK_ENABLED == true end,
        setGK = toggleEnabled, validate = SettingsStore.Validate,
        accent = function() return currentAccent end, theme = applyTheme,
        rainbow = function() return rainbowUI end, setRainbow = setRainbowUI,
        resetGoalkeeper = function() Rush.candidate = nil; invalidateFrame(true); S.nextPlanAt = 0 end,
    })
    local configCard = frame(settingsContent, "Configs", 0, 0, 288, 196)
    configCard.BackgroundTransparency = 1
    text(configCard, "CONFIGS", 9, {
        Size = UDim2.fromOffset(288, 16), Font = Enum.Font.FredokaOne, TextColor3 = C.muted,
    })
    local function field(parent, name, value, placeholder, x, y, w)
        local box = round(create("TextBox", {
            Name = name, Text = value, PlaceholderText = placeholder,
            Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(w, 32),
            TextSize = 14, Font = Enum.Font.Nunito, TextColor3 = C.text,
            PlaceholderColor3 = C.muted, BackgroundColor3 = C.control,
            BorderSizePixel = 0, ClearTextOnFocus = false, TextEditable = true,
            TextXAlignment = Enum.TextXAlignment.Left,
        }, parent), 5)
        create("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }, box)
        stroke(box)
        connect(box.Focused, function()
            if not S.alive then return end
            editingField = box
            updateUIBusy()
        end)
        connect(box.FocusLost, function()
            if editingField == box then editingField = nil end
            updateUIBusy()
        end)
        return box
    end
    local configName = field(configCard, "ConfigName", "", "New config name", 0, 22, 288)
    text(configCard, "SAVED CONFIGS", 9, {
        Name = "SavedConfigsHeading", Position = UDim2.fromOffset(0, 106), Size = UDim2.fromOffset(288, 16), TextColor3 = C.muted,
    })
    local function action(name, x)
        local control = button(configCard, {
            Name = name, Text = name, Position = UDim2.fromOffset(x, 64), Size = UDim2.fromOffset(92, 32),
        })
        hover(control)
        return control
    end
    local createConfig, saveConfig, loadConfig = action("Create", 0), action("Save", 98), action("Load", 196)
    local configMessage = text(configCard, SettingsStore.Notice, 10, {
        Name = "ConfigMessage", Position = UDim2.fromOffset(0, 168), Size = UDim2.fromOffset(288, 28),
        TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top, TextColor3 = C.muted,
    })
    local colorCard = frame(settingsContent, "Appearance", 0, 212, 288, 93)
    colorCard.BackgroundTransparency = 1
    text(colorCard, "UI COLOR", 9, {
        Size = UDim2.fromOffset(288, 16), Font = Enum.Font.FredokaOne, TextColor3 = C.muted,
    })
    local rainbowOptions = frame(colorCard, "Options", 0, 22, 288, 32)
    rainbowOptions.BackgroundTransparency = 1
    local previousBody, previousOrder = activeBody, order
    activeBody, order = rainbowOptions, 0
    refreshRainbowToggle = toggle("Rainbow UI", function() return rainbowUI end, function(value)
        if settingsBusy then return end
        local ok, detail = SettingsStore.SetRainbowUI(value)
        if ok then setRainbowUI(value)
        else configMessage.Text = detail; setThemed(configMessage, "TextColor3", C.accent) end
    end)
    activeBody, order = previousBody, previousOrder
    local openColor = button(colorCard, {
        Name = "ChangeColor", Text = "Change UI color", TextXAlignment = Enum.TextXAlignment.Left,
        Position = UDim2.fromOffset(0, 57), Size = UDim2.fromOffset(288, 36),
    })
    create("UIPadding", { PaddingLeft = UDim.new(0, 12) }, openColor)
    local swatch = round(frame(openColor, "Swatch", 0, 7, 22, 22, C.accent), 4)
    swatch.Position = UDim2.new(1, -34, 0, 7)
    hover(openColor)
    local configExtra, colorExtra = 0, 0
    local function layoutSettings(immediate, duration, scrollToColor)
        if fit then fit() end
        animate(configCard, { Size = UDim2.fromOffset(288, 196 + configExtra) }, immediate, duration)
        animate(configMessage, { Position = UDim2.fromOffset(0, 168 + configExtra) }, immediate, duration)
        animate(colorCard, { Position = UDim2.fromOffset(0, 212 + configExtra),
            Size = UDim2.fromOffset(288, 93 + colorExtra) }, immediate, duration)
        local canvas = { CanvasSize = UDim2.fromOffset(0, 335 + configExtra + colorExtra) }
        if scrollToColor then canvas.CanvasPosition = Vector2.new(0, 212 + configExtra)
        elseif configExtra == 0 and colorExtra == 0 then canvas.CanvasPosition = Vector2.zero end
        animate(settingsContent, canvas, immediate, duration)
    end
    local updateSettingsList
    local function buildConfigDropdown()
        local row = frame(configCard, "SavedConfigs", 0, 128, 288, 30)
        row.BackgroundTransparency, row.ClipsDescendants = 1, true
        local selectButton = button(row, { Name = "Select", Size = UDim2.fromOffset(288, 30) })
        stroke(selectButton)
        local selected = text(selectButton, "No saved configs", 11, {
            Name = "SelectedValue", Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -48, 1, 0),
            TextTruncate = Enum.TextTruncate.AtEnd,
        })
        local arrow = chevron(selectButton, "Arrow", 0, 8)
        arrow.Position = UDim2.new(1, -28, 0, 8)
        local menu = create("ScrollingFrame", {
            Name = "Choices", Position = UDim2.fromOffset(0, 36), Size = UDim2.fromOffset(288, 0),
            BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, ClipsDescendants = true,
            ScrollingDirection = Enum.ScrollingDirection.Y, ScrollBarThickness = 2,
            ScrollBarImageColor3 = C.accentDim, CanvasSize = UDim2.fromOffset(0, 0),
        }, row)
        create("UIListLayout", { Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, menu)
        local entry = { row = row, menu = menu, arrow = arrow, open = false }
        local options, menuHeight, count = {}, 0, 0
        entry.setOpen = function(open, immediate)
            entry.open = open and count > 0
            configExtra = entry.open and menuHeight + 8 or 0
            if entry.open then menu.Visible = true end
            for _, option in pairs(options) do
                option.button.Interactable = entry.open
                option.marker.Visible = SettingsStore.Selected == option.button.Name
                if not entry.open then option.reset() end
            end
            animate(arrow, { Rotation = entry.open and 180 or 0 }, immediate, 0.18)
            local duration = entry.open and 0.18 or 0.14
            animate(row, { Size = UDim2.fromOffset(288, 30 + configExtra) }, immediate, duration, function()
                if not entry.open then menu.Visible = false end
            end)
            layoutSettings(immediate, duration)
        end
        table.insert(dropdowns, entry)
        entry.Refresh = function(names)
            count = #names
            selected.Text = count > 0 and SettingsStore.Selected or "No saved configs"
            selectButton.Interactable = count > 0 and not settingsBusy
            menuHeight = math.min(156, math.max(0, count * 32 - 4))
            menu.Size, menu.CanvasSize = UDim2.fromOffset(288, menuHeight), UDim2.fromOffset(0, math.max(0, count * 32 - 4))
            for index, name in ipairs(names) do
                local option = options[name]
                if not option then
                    local control = button(menu, {
                        Name = name, Text = "", TextXAlignment = Enum.TextXAlignment.Left,
                        TextTruncate = Enum.TextTruncate.AtEnd, Size = UDim2.new(1, -4, 0, 28), Interactable = false,
                    })
                    local label = text(control, name, 11, {
                        Name = "Label", Position = UDim2.fromOffset(34, 0), Size = UDim2.new(1, -44, 1, 0),
                        TextTruncate = Enum.TextTruncate.AtEnd,
                    })
                    local marker = chevron(control, "SelectedChevron", 10, 7)
                    marker.Rotation = -90
                    local repaint, reset = hover(control, function()
                        return SettingsStore.Selected == name and C.active or C.control
                    end)
                    option = { button = control, text = label, marker = marker, repaint = repaint, reset = reset }
                    options[name] = option
                    connect(control.Activated, function()
                        if not S.alive or settingsBusy or expanded ~= entry or not entry.open then return end
                        SettingsStore.Select(name)
                        updateSettingsList()
                        closeDropdown()
                    end)
                end
                option.button.LayoutOrder, option.button.Interactable = index, entry.open
                option.marker.Visible = SettingsStore.Selected == name
                setThemed(option.text, "TextColor3", SettingsStore.Selected == name and C.accent or C.text)
                option.repaint(true)
            end
        end
        hover(selectButton)
        connect(selectButton.Activated, function()
            if not S.alive or settingsBusy or count == 0 then return end
            local wasOpen = expanded == entry
            closeDropdown(not wasOpen)
            if not wasOpen then
                expanded = entry
                entry.setOpen(true, false)
                updateUIBusy()
            end
        end)
        return entry
    end
    local configDropdown = buildConfigDropdown()
    updateSettingsList = function()
        local names = SettingsStore.List()
        local selected = table.find(names, SettingsStore.Selected)
        if not selected and #names > 0 then SettingsStore.Select(names[1]); selected = 1 end
        configDropdown.Refresh(names)
        saveConfig.Interactable, loadConfig.Interactable = selected ~= nil and not settingsBusy, selected ~= nil and not settingsBusy
        createConfig.Interactable = not settingsBusy
    end
    local function settingsAction(callback)
        if not S.alive or settingsBusy then return end
        closeDropdown(true)
        settingsBusy = true
        updateUIBusy()
        updateSettingsList()
        local called, ok, detail = pcall(callback)
        settingsBusy = false
        updateUIBusy()
        if not S.alive then return end
        configMessage.Text = called and tostring(detail) or ("Settings error: " .. tostring(ok))
        setThemed(configMessage, "TextColor3", called and ok and C.muted or C.accent)
        updateSettingsList()
    end
    connect(createConfig.Activated, function()
        settingsAction(function()
            local ok, detail = SettingsStore.Save(configName.Text, settingsController.Snapshot(), true)
            if ok then configName.Text = "" end
            return ok, ok and (SettingsStore.Storage:sub(1, 10) == "Local file" and "Created." or "Created for this session.") or detail
        end)
    end)
    connect(saveConfig.Activated, function()
        settingsAction(function()
            local ok, detail = SettingsStore.Save(SettingsStore.Selected, settingsController.Snapshot(), false)
            return ok, ok and (SettingsStore.Storage:sub(1, 10) == "Local file" and "Saved." or "Saved for this session.") or detail
        end)
    end)
    connect(loadConfig.Activated, function()
        settingsAction(function()
            local profile = SettingsStore.Get(SettingsStore.Selected)
            if not profile then return false, "Select a saved config first." end
            local ok, detail = settingsController.Load(profile)
            if not ok then return false, detail end
            SettingsStore.SetAppearance(profile.accent, profile.rainbowUI == true)
            return true, "Loaded."
        end)
    end)
    -- The spectrum expands inside Settings and previews without writing storage.
    local function buildColorPicker()
        local body = round(frame(colorCard, "ColorPicker", 0, 103, 288, 0, C.surface), 5)
        body.Visible, body.ClipsDescendants = false, true
        local spectrum = button(body, {
            Name = "Spectrum", Position = UDim2.fromOffset(12, 12), Size = UDim2.fromOffset(224, 174),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })
        themeBindings[spectrum].BackgroundColor3 = nil
        local hueGradient = create("UIGradient", { Rotation = 0 }, spectrum)
        local saturation = frame(spectrum, "SaturationFade", 0, 0, 224, 174, Color3.fromRGB(255, 255, 255))
        themeBindings[saturation].BackgroundColor3 = nil
        create("UIGradient", {
            Rotation = 90, Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0),
            }),
        }, saturation)
        local cursor = frame(spectrum, "Cursor", 0, 0, 16, 16)
        cursor.BackgroundTransparency, cursor.AnchorPoint = 1, Vector2.new(0.5, 0.5)
        local cursorH = frame(cursor, "Horizontal", 0, 7, 16, 2, Color3.fromRGB(0, 0, 0))
        local cursorV = frame(cursor, "Vertical", 7, 0, 2, 16, Color3.fromRGB(0, 0, 0))
        themeBindings[cursorH].BackgroundColor3, themeBindings[cursorV].BackgroundColor3 = nil, nil
        local brightness = button(body, {
            Name = "Brightness", Position = UDim2.fromOffset(250, 12), Size = UDim2.fromOffset(14, 174),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        })
        themeBindings[brightness].BackgroundColor3 = nil
        local brightnessGradient = create("UIGradient", { Rotation = 90 }, brightness)
        local valueMarker = frame(brightness, "Marker", 0, 0, 22, 3, Color3.fromRGB(255, 255, 255))
        themeBindings[valueMarker].BackgroundColor3 = nil
        valueMarker.AnchorPoint = Vector2.new(0.5, 0.5)
        local patch = round(frame(body, "Preview", 12, 198, 62, 86, C.accent), 3)
        themeBindings[patch].BackgroundColor3 = nil
        local values: { [string]: TextBox } = {}
        local h, s, v, updatingHSV = 0, 0, 0, false
        local colorOriginal, colorDrag, dragSurface = nil, nil, nil
        local function rgb(hex)
            return { tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16) }
        end
        local function readHSV(hex)
            local channels = rgb(hex)
            h, s, v = Color3.fromRGB(channels[1], channels[2], channels[3]):ToHSV()
        end
        local function draw()
            local channels = rgb(currentAccent)
            patch.BackgroundColor3 = Color3.fromRGB(channels[1], channels[2], channels[3])
            cursor.Position = UDim2.fromScale(1 - h, 1 - s)
            valueMarker.Position = UDim2.fromScale(0.5, 1 - v)
            local points = {}
            for index = 0, 6 do
                points[#points + 1] = ColorSequenceKeypoint.new(index / 6, Color3.fromHSV(1 - index / 6, 1, v))
            end
            hueGradient.Color = ColorSequence.new(points)
            saturation.BackgroundColor3 = Color3.fromHSV(0, 0, v)
            brightnessGradient.Color = ColorSequence.new(Color3.fromHSV(h, s, 1), Color3.fromRGB(0, 0, 0))
            local luminance = channels[1] * 0.299 + channels[2] * 0.587 + channels[3] * 0.114
            local cursorColor = luminance > 145 and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)
            cursorH.BackgroundColor3, cursorV.BackgroundColor3 = cursorColor, cursorColor
            local numbers = { Hue = math.floor(h * 360 + 0.5), Saturation = math.floor(s * 100 + 0.5),
                Value = math.floor(v * 100 + 0.5), Red = channels[1], Green = channels[2], Blue = channels[3] }
            for key, number in pairs(numbers) do
                if values[key] then values[key].Text = tostring(number) end
            end
            if values.Hex then values.Hex.Text = "#" .. currentAccent end
        end
        refreshColorUI = function()
            if not updatingHSV then readHSV(currentAccent) end
            draw()
        end
        local function setHSV(hue, sat, value)
            h, s, v = math.clamp(hue, 0, 1), math.clamp(sat, 0, 1), math.clamp(value, 0, 1)
            local color = Color3.fromHSV(h, s, v)
            local hex = string.format("%02X%02X%02X", math.floor(color.R * 255 + 0.5),
                math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
            -- Preserve the chosen hue through grey/black and RGB rounding.
            updatingHSV = true
            if hex ~= currentAccent then applyTheme(hex) else draw() end
            updatingHSV = false
        end
        for index, key in ipairs({ "Hue", "Saturation", "Value", "Red", "Green", "Blue" }) do
            local hsv = index <= 3
            local row = (index - 1) % 3
            text(body, ({ "Hue", "Sat %", "Val %", "R", "G", "B" })[index], 10, {
                Position = UDim2.fromOffset(hsv and 82 or 180, 194 + row * 30),
                Size = UDim2.fromOffset(hsv and 36 or 24, 26), TextColor3 = C.muted,
            })
            local input = field(body, key, "", "0", hsv and 120 or 212, 194 + row * 30, hsv and 44 or 64)
            input.Size = UDim2.fromOffset(hsv and 44 or 64, 26)
            values[key] = input
            connect(input.FocusLost, function()
                if not colorPickerOpen or not S.alive then return end
                local number = tonumber(input.Text)
                if not number or number ~= number or math.abs(number) == math.huge then draw(); return end
                if hsv then
                    if key == "Hue" then setHSV(math.clamp(number, 0, 360) / 360, s, v)
                    elseif key == "Saturation" then setHSV(h, math.clamp(number, 0, 100) / 100, v)
                    else setHSV(h, s, math.clamp(number, 0, 100) / 100) end
                else
                    local channels = rgb(currentAccent)
                    channels[index - 3] = math.clamp(math.floor(number + 0.5), 0, 255)
                    local hex = string.format("%02X%02X%02X", channels[1], channels[2], channels[3])
                    if hex ~= currentAccent then applyTheme(hex) else draw() end
                end
            end)
        end
        text(body, "HTML", 10, {
            Position = UDim2.fromOffset(12, 294), Size = UDim2.fromOffset(62, 28), TextColor3 = C.muted,
        })
        values.Hex = field(body, "Hex", "", "#DEC173", 80, 294, 196)
        values.Hex.Size, values.Hex.Font = UDim2.fromOffset(196, 28), Enum.Font.Code
        connect(values.Hex.FocusLost, function()
            if not colorPickerOpen or not S.alive then return end
            local hex = SettingsStore.Color(values.Hex.Text)
            if hex and hex ~= currentAccent then applyTheme(hex) else draw() end
        end)
        local function fromColorPoint(point)
            if dragSurface == spectrum then
                local size, position = spectrum.AbsoluteSize, spectrum.AbsolutePosition
                if size.X > 0 and size.Y > 0 then
                    setHSV(1 - (point.X - position.X) / size.X, 1 - (point.Y - position.Y) / size.Y, v)
                end
            elseif dragSurface == brightness then
                local size, position = brightness.AbsoluteSize, brightness.AbsolutePosition
                if size.Y > 0 then setHSV(h, s, 1 - (point.Y - position.Y) / size.Y) end
            end
        end
        for _, surface in ipairs({ spectrum, brightness }) do
            connect(surface.InputBegan, function(input)
                if not S.alive or not colorPickerOpen or colorDrag then return end
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    if editingField then editingField:ReleaseFocus() end
                    colorDrag, dragSurface = input, surface
                    settingsContent.ScrollingEnabled = false
                    fromColorPoint(input.Position)
                end
            end)
        end
        local function expandPicker(open, immediate)
            colorExtra = open and 384 or 0
            if open then body.Visible = true end
            local duration = open and 0.18 or 0.14
            animate(body, { Size = UDim2.fromOffset(288, open and 374 or 0) }, immediate, duration, function()
                if not colorPickerOpen then body.Visible = false end
            end)
            layoutSettings(immediate, duration, open)
        end
        local function dismissColorPicker(keepPreview, immediate)
            if not colorPickerOpen then return end
            if editingField then editingField:ReleaseFocus() end
            colorPickerOpen, colorDrag, dragSurface = false, nil, nil
            settingsContent.ScrollingEnabled = true
            if not keepPreview and colorOriginal then applyTheme(colorOriginal) end
            colorOriginal = nil
            repaintPalette(rainbowUI and rainbowAccent() or currentAccent, true)
            expandPicker(false, immediate)
            updateUIBusy()
        end
        closeColorPicker = function() dismissColorPicker(false, true) end
        connect(openColor.Activated, function()
            if not S.alive or settingsBusy then return end
            if colorPickerOpen then dismissColorPicker(false, false); return end
            closeDropdown(true)
            colorOriginal, colorPickerOpen = currentAccent, true
            repaintPalette(currentAccent, true)
            refreshColorUI()
            expandPicker(true, false)
            updateUIBusy()
        end)
        local cancelColor = button(body, {
            Name = "Cancel", Text = "Cancel", Position = UDim2.fromOffset(12, 334), Size = UDim2.fromOffset(126, 30),
        })
        local applyColor = button(body, {
            Name = "Apply", Text = "Apply", Position = UDim2.fromOffset(150, 334), Size = UDim2.fromOffset(126, 30),
        })
        hover(cancelColor); hover(applyColor)
        connect(cancelColor.Activated, function() dismissColorPicker(false, false) end)
        connect(applyColor.Activated, function()
            if not S.alive or not colorPickerOpen then return end
            dismissColorPicker(true, false)
            settingsAction(function()
                local ok, detail = SettingsStore.SetAccent(currentAccent)
                return ok, ok and (SettingsStore.Storage:sub(1, 10) == "Local file" and "Color applied." or "Color applied for this session.") or detail
            end)
        end)
        connect(UserInputService.InputChanged, function(input)
            if not S.alive or not colorPickerOpen or not colorDrag then return end
            if input == colorDrag or (colorDrag.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseMovement) then fromColorPoint(input.Position) end
        end)
        connect(UserInputService.InputEnded, function(input)
            if colorDrag and (input == colorDrag or (colorDrag.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseButton1)) then
                colorDrag, dragSurface = nil, nil
                settingsContent.ScrollingEnabled = true
            end
        end)
        refreshColorUI()
    end
    buildColorPicker()

    updateSettingsList()


    end

    local dragInput, dragStart, hostStart
    local lastViewport = nil
    local lastMinimized = nil
    local lastTab = nil
    local lastHeight = nil
    local refresh
    local function viewportSize()
        local camera = workspace.CurrentCamera
        return camera and camera.ViewportSize or Vector2.new(1280, 720)
    end

    fit = function(requestedX, requestedY)
        local viewport = viewportSize()
        local top = math.min(48, viewport.Y * 0.1)
        local width, height = 316, minimized and 40 or (activeTab == "GK" and 494 or (activeTab == "STR" and 421 or (colorPickerOpen and 581 or 419)))
        local scale = math.min(1, math.max(1, viewport.X - 32) / width,
            math.max(1, viewport.Y - top - 16) / height)
        if viewport ~= lastViewport or minimized ~= lastMinimized or activeTab ~= lastTab or height ~= lastHeight then
            uiScale.Scale = scale
            panel.Size = UDim2.fromOffset(width, height)
            tabBar.Visible = not minimized
            content.Visible = not minimized and activeTab == "GK"
            live.Visible = not minimized and activeTab == "GK"
            strikerContent.Visible = not minimized and activeTab == "STR"
            settingsContent.Visible = not minimized and activeTab == "Settings"
            lastViewport, lastMinimized, lastTab, lastHeight = viewport, minimized, activeTab, height
            settingsContent.Size = UDim2.fromOffset(292, height - 88)
        end
        local x = math.clamp(requestedX or host.Position.X.Offset, 16,
            math.max(16, viewport.X - width * scale - 16))
        local y = math.clamp(requestedY or host.Position.Y.Offset, top,
            math.max(top, viewport.Y - height * scale - 16))
        if x ~= host.Position.X.Offset or y ~= host.Position.Y.Offset then
            host.Position = UDim2.fromOffset(x, y)
        end
    end

    connect(minimize.Activated, function()
        if not S.alive then return end
        dragging = false
        closeDropdown(true)
        minimized = not minimized
        minimize.Text = minimized and "+" or "-"
        fit()
        if not minimized then refresh() end
    end)
    connect(unload.Activated, function()
        if S.alive and type(ENV.StopAutoGK) == "function" then ENV.StopAutoGK() end
    end)
    connect(header.InputBegan, function(input)
        if not S.alive or dragging then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            closeDropdown(true)
            dragging = true
            S.uiBusy = true
            dragInput, dragStart, hostStart = input, input.Position, host.Position
            invalidateFrame(true)
        end
    end)
    connect(UserInputService.InputEnded, function(input)
        if input == dragInput or (dragInput
            and dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseButton1) then
            dragging = false
            dragInput = nil
            updateUIBusy()
        end
    end)
    connect(UserInputService.InputChanged, function(input)
        if not S.alive or not dragging then return end
        if input == dragInput or (dragInput
            and dragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            fit(hostStart.X.Offset + delta.X, hostStart.Y.Offset + delta.Y)
        end
    end)
    connect(UserInputService.InputBegan, function(input, processed)
        if not S.alive then return end
        if expanded and (input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch)
            and not inside(input.Position, expanded.row) then
            closeDropdown()
        end
        if input.KeyCode == Enum.KeyCode.Escape then closeDropdown() end
        if not processed and input.KeyCode == Enum.KeyCode.RightShift then
            dragging = false
            dragInput = nil
            closeDropdown(true)
            Gui.Enabled = not Gui.Enabled
            if Gui.Enabled then refresh() end
        end
    end)
    connect(UserInputService.WindowFocusReleased, function()
        dragging = false
        dragInput = nil
        closeDropdown(true)
    end)

    local function writeChanged(object, property, value)
        if object[property] ~= value then setThemed(object, property, value) end
    end
    refresh = function()
        if not Gui.Enabled or not Gui.Parent then return end
        if viewportSize() ~= lastViewport then fit() end
        if minimized then return end
        if activeTab == "Settings" then return end
        if activeTab == "STR" then
            for i = gkRefresherCount + 1, #refreshers do refreshers[i]() end
            writeChanged(strikerStatus, "Text", STR.Status)
            writeChanged(miscellaneousStatus, "Text", "Dribble: " .. MISC.DribbleStatus)
            return
        end
        for i = 1, gkRefresherCount do refreshers[i]() end
        flushStatusDisplay()
        writeChanged(stateText, "Text", S.displayName)
        writeChanged(dot, "BackgroundColor3", S.wasKeeper and Config.Enabled and ENV.AUTO_GK_ENABLED
            and C.accent or C.muted)
    end

    local tabRefreshers = {}
    local function addTab(name, labelText, x, width)
        local control = button(tabBar, {
            Name = name, Position = UDim2.fromOffset(x, 0),
            Size = UDim2.fromOffset(width, 26),
        })
        local label = text(control, labelText, 11, {
            Name = "Label", Size = UDim2.fromScale(1, 1),
            Font = Enum.Font.FredokaOne,
            TextXAlignment = Enum.TextXAlignment.Center,
        })
        local border = stroke(control)
        local repaint = hover(control, function()
            return activeTab == name and C.active or C.control
        end)
        local function draw(immediate)
            local selected = activeTab == name
            animate(label, { TextColor3 = selected and C.accent or C.muted }, immediate)
            animate(border, { Color = selected and C.accentDim or C.stroke }, immediate)
            repaint(immediate)
        end
        table.insert(tabRefreshers, draw)
        connect(control.Activated, function()
            if not S.alive or activeTab == name then return end
            closeDropdown(true)
            activeTab = name
            for _, redraw in ipairs(tabRefreshers) do redraw(false) end
            fit()
            refresh()
        end)
        draw(true)
    end
    addTab("GK", "Goalkeeper", 0, 108)
    addTab("STR", "Striker", 114, 82)
    addTab("Settings", "Settings", 202, 90)

    connect(RunService.Heartbeat, function()
        if not S.alive or not Gui.Enabled or not Gui.Parent then return end
        local clock = os.clock()
        if clock < S.nextUIAt then return end
        S.nextUIAt = clock + 1 / Config.UISampleHz
        local ok, err = pcall(refresh)
        if not ok then report("UI", err) end
    end)
    refresh()
end

--==============================================================
-- SHUTDOWN
--==============================================================


ENV.__AUTO_GK_CLEANUP = cleanup
ENV.StopAutoGK = cleanup

ENV.ToggleAutoGK = function(value)
    toggleEnabled(
        value == nil and not ENV.AUTO_GK_ENABLED
            or value == true
    )
end

ENV.AutoGKDebug = function()
    print(
        "[Auto GK] consecutive runtime failures:", S.runtimeFailures,
        "| last runtime error:", S.runtimeError or "none"
    )
    print("[Auto GK] cleanup:", S.cleanupComplete == true,
        "| last cleanup error:", S.cleanupError or "none")

    print(
        "[Auto GK] name:", BUILD,
        "| alive:", S.alive,
        "| effective enabled:",
        S.alive and Config.Enabled and ENV.AUTO_GK_ENABLED
    )

    print(
        "[Auto GK] focus:", S.focused,
        "| UI busy:", S.uiBusy
    )

    print(
        "[Auto GK] sender error:",
        S.transportError or "none"
    )

    print(
        "[Auto GK] raw:", S.status, S.detail,
        "| display:", S.displayName
    )

    print(
        "[Auto GK] actions:", Stats.Requests,
        "| jumps:", Stats.JumpRequests,
        "| dives:", Stats.DiveRequests,
        "| distinct flights acted on:", Stats.FlightsActedOn
    )

    print(
        "[Auto GK] pre-shot coverage:", Config.PreShotCoverage,
        "| movement writes:", S.coverageWrites
    )

    print(
        "[Auto GK] planner:", S.lastPlanReason,
        "| immediate directions:", S.immediatePlansChecked,
        "| delayed candidates:", S.delayedPlansChecked,
        "| milliseconds:", S.plannerMilliseconds
    )
    print("[Auto GK] contact timing waits:", S.keeperWaits or 0,
        "| deadline:", S.keeperWait and math.max(0, S.keeperWait.deadline - os.clock()) or 0,
        "| intervening contact:", S.keeperContact and S.keeperContact.time or "none",
        "| timing errors:", S.keeperTimingErrors or 0,
        "| last timing error:", S.keeperTimingError or "none")

    print(
        "[Auto GK] close-range rush:", Config.CloseRangeRush,
        "| requests:", Stats.RushRequests,
        "| native controller owns rush recovery"
    )

    print(
        "[Auto GK] own lock acquisitions:", S.ownLockAcquires,
        "| releases:", S.ownLockReleases,
        "| current lease:",
        S.motionLease and S.motionLease.id or "none"
    )

    print(
        "[Auto GK] ball:", S.ballPhase,
        "|", S.ballInfo,
        "| id:", S.observedBallId
    )

    print(
        "[Auto GK] position:", Config.PositionMode,
        "| allowed:", S.allowPositioning,
        "| active:", S.positionActive,
        "| movement writes:", S.positionWrites,
        "| releases:", S.releaseWrites
    )

    print(
        "[Auto GK] frame age:",
        S.lastFrame and os.clock() - S.lastFrame.readClock or "none",
        "| jump delay estimate:", S.queueEstimate
    )

    print(
        "[Auto GK] HOLD:",
        "movement stops", S.holdStops,
        "| fresh checks", S.holdRechecks,
        "| checks without contact", S.holdRecheckMisses,
        "| follow-ups blocked", S.followupBlocks
    )

    local releaseSummary = {}

    for name, count in pairs(S.releaseReasons) do
        releaseSummary[#releaseSummary + 1] =
            name .. "=" .. tostring(count)
    end

    table.sort(releaseSummary)

    print(
        "[Auto GK] movement release reasons:",
        table.concat(releaseSummary, ", "),
        "| last:", S.lastReleaseReason
    )

    if LocalPlayer.Character then
        local character = LocalPlayer.Character
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")

        local okSuspended, suspended = pcall(
            M.Controllers.IsSuspended,
            character
        )

        local okDive, diveActive = pcall(
            M.Dive.IsDiveConstraintActive,
            root
        )

        local okSlide, slideActive =
            pcall(M.Slide.IsSlideTackling)

        local okDodge, dodgeActive =
            pcall(M.Dodge.IsDribbling)

        print(
            "[Auto GK] controller checks:",
            "suspended",
            okSuspended and tostring(suspended) or "unavailable",
            "| dive rig",
            okDive and tostring(diveActive) or "unavailable",
            "| slide",
            okSlide and tostring(slideActive) or "unavailable",
            "| dodge",
            okDodge and tostring(dodgeActive) or "unavailable"
        )

        if humanoid then
            print(
                "[Auto GK] humanoid:",
                humanoid:GetState().Name,
                "| speed", humanoid.WalkSpeed,
                "| jump height", humanoid.JumpHeight
            )
        end

        print(
            "[Auto GK] movement blocks:",
            table.concat(
                M.Movement.GetZeroWalkSpeedSources(),
                ", "
            )
        )

        for _, name in ipairs({
            "GoalkeeperDive",
            "SlideTackle",
            "TackleKick",
            "ItemBallControls",
        }) do
            local ok, value = pcall(
                M.Locks.IsLocked,
                LocalPlayer,
                name
            )

            print(
                "[Auto GK] game lock",
                name,
                ok and tostring(value) or "unavailable"
            )
        end
    end
end

SettingsStore.Acknowledge()
print("[Dmc] Loaded | " .. RELEASE_VERSION .. " | RightShift: show / hide")

-- DMC MAIN END
end)
