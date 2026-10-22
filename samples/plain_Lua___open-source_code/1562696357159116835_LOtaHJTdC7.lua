--[[
    M10RU Duels - SPEED NUMBER ONLY / CLEAN ANTI DIE / NON-DESTRUCTIVE PATH OVERRIDE
    Auto Left/Right use Normal Speed without disabling the selected Carry/Lagger mode.
    Overhead: speed number only. Header Discord link removed.
    Clean_anti_die.lua.txt logic only; no donor UI, billboard, keybind or external loader.
    All previous UI, audio and scoped-highlight fixes are retained.
    INTRO: pure black space, small white stars flying with a purple glow, the word
    "M10RU Duels" enters with a clean purple animation, and a purple charge line
    fills under it; when it is full the intro dissolves smoothly (one click/tap
    skips it at any moment).
    REMOVED: TP Bat Height Offset, TP Bat camera spin (mode + speed) and the whole
    PANELS category together with the Ping Lagger / Anti TP Bat launchers.
    TP BAT: the attached file contains one engine. V1 / V2 / V3 selectors
    were described in comments but were not implemented in the source.
    INTRO: a "Skip Intro" button sits at the top of the screen.
    Syntax checked with Luau; live Roblox / Delta behavior still needs testing.
]]

repeat task.wait() until game:IsLoaded()

-- ========================================================================
-- UNIVERSAL EXECUTOR COMPATIBILITY LAYER
-- ========================================================================
local function getSafeGuiParent()
    -- Reading CoreGui.Name does NOT prove we can parent a GUI there.
    -- Test the actual operation and prefer PlayerGui as the safe fallback.
    local function canParentGui(parent)
        if typeof(parent) ~= "Instance" then return false end
        local probe = Instance.new("ScreenGui")
        probe.Name = "M10RUGuiAccessProbe"
        probe.Enabled = false
        local ok = pcall(function() probe.Parent = parent end)
        pcall(function() probe:Destroy() end)
        return ok
    end

    if type(gethui) == "function" then
        local ok, parent = pcall(gethui)
        if ok and canParentGui(parent) then return parent end
    end

    local player = game:GetService("Players").LocalPlayer
    local playerGui = player and (
        player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui", 10)
    )
    if canParentGui(playerGui) then return playerGui end

    local ok, coreGui = pcall(function() return game:GetService("CoreGui") end)
    if ok and canParentGui(coreGui) then return coreGui end

    error("[M10RU Duels] No writable GUI parent. Run this on the Roblox client after joining a game.", 2)
end

local function protectGuiObject(gui)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        elseif protectgui then
            protectgui(gui)
        end
    end)
end

-- File System Safe Wrappers
local function safeWriteFile(filename, content)
    if writefile then
        pcall(writefile, filename, content)
    end
end

local function safeReadFile(filename)
    if not (isfile and readfile) then return nil end
    local aliases = {
        ["m10ru_duels_config.json"] = "fluxhub_config.json",
        ["m10ru_duels_backup.json"] = "fluxhubPC.json",
        ["m10ruDuelsIntroSong"] = "fluxHubIntroSong",
    }
    local candidates = {filename}
    local legacy = aliases[filename] or (filename:match("^m10ru") and filename:gsub("^m10ru", "flux"))
    if legacy then table.insert(candidates, legacy) end
    for _, candidate in ipairs(candidates) do
        local existsOk, exists = pcall(isfile, candidate)
        if existsOk and exists then
            local readOk, result = pcall(readfile, candidate)
            if readOk and result then return result end
        end
    end
    return nil
end

local function safeIsFile(filename)
    if isfile then
        local ok, res = pcall(isfile, filename)
        return ok and res
    end
    return false
end

-- HTTP Request Safe Wrapper
local httpRequest = request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
local function safeHttpGet(url)
    if game.HttpGet then
        local ok, res = pcall(function() return game:HttpGet(url) end)
        if ok and res then return res end
    end
    if httpRequest then
        local ok, res = pcall(function()
            local response = httpRequest({Url = url, Method = "GET"})
            return response and (response.Body or response.body)
        end)
        if ok and res then return res end
    end
    return nil
end

-- Proximity Prompt Trigger Wrapper
local function triggerPromptUniversal(prompt, holdDuration)
    if not prompt or not prompt:IsA("ProximityPrompt") then return end
    
    if type(fireproximityprompt) == "function" then
        local ok, result = pcall(fireproximityprompt, prompt, holdDuration or 0)
        if ok and result ~= false then return end
    end

    if type(getconnections) == "function" then
        local holdOk, holdConns = pcall(getconnections, prompt.PromptButtonHoldBegan)
        local trigOk, trigConns = pcall(getconnections, prompt.Triggered)
        holdConns = holdOk and type(holdConns) == "table" and holdConns or {}
        trigConns = trigOk and type(trigConns) == "table" and trigConns or {}
        if #holdConns > 0 or #trigConns > 0 then
            task.spawn(function()
                for _, c in ipairs(holdConns) do
                    if c.Function then pcall(c.Function) end
                end
                if holdDuration and holdDuration > 0 then
                    task.wait(holdDuration)
                end
                for _, c in ipairs(trigConns) do
                    if c.Function then pcall(c.Function) end
                end
            end)
            return
        end
    end

    pcall(function()
        prompt:InputHoldBegin()
        if holdDuration and holdDuration > 0 then
            task.wait(holdDuration)
        end
        prompt:InputHoldEnd()
    end)
end

-- Custom Asset Wrapper
local function safeGetAsset(filepath)
    if getsynasset then
        local ok, res = pcall(getsynasset, filepath)
        if ok and res then return res end
    end
    if getcustomasset then
        local ok, res = pcall(getcustomasset, filepath)
        if ok and res then return res end
    end
    return ""
end

-- Roblox image/decal formatter used by UI artwork asset IDs.
local function formatAssetId(assetId)
    local value = tostring(assetId or "")
    if value:match("^rbxthumb://") or value:match("^rbxassetid://") then return value end
    return "rbxassetid://" .. value
end

-- ========================================================================
-- SERVICES & LOCAL PLAYER
-- ========================================================================
local Players           = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local Lighting         = game:GetService("Lighting")
local HttpService      = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local InsertService = game:GetService("InsertService")

if not RunService:IsClient() then
    warn("[M10RU Duels] This script must run on the Roblox client, not the server.")
    return
end

local LP = Players.LocalPlayer

-- ========================================================================
-- M10RU INTERNAL ANTI DROP (from 404 Anti Drop)
-- Always ON / no UI / no toggle / no keybind.
-- The anti-drop logic is kept inside this script and starts automatically.
-- ========================================================================
do
    -- This hook must filter the key BEFORE reading any Instance property.
    -- Reading LP.Character unconditionally from __index recursively re-enters
    -- __index and can close Roblox on Android (bug in the earlier patch).
    local mt
    if type(getrawmetatable) == "function" then
        local ok, value = pcall(getrawmetatable, game)
        if ok then mt = value end
    end
    if mt and type(newcclosure) == "function" and type(setreadonly) == "function"
        and type(checkcaller) == "function" then
        local oldIdx, oldNewIdx
        local writable = false
        local spoofedVelocity = Vector3.zero
        local ok, err = pcall(function()
            oldIdx, oldNewIdx = mt.__index, mt.__newindex
            if type(oldIdx) ~= "function" or type(oldNewIdx) ~= "function" then
                error("unsupported game metatable")
            end
            local indexHook = newcclosure(function(self, key)
                -- Non-velocity properties delegate immediately, without any
                -- LP.Character / self property access from the hook.
                if key == "AssemblyLinearVelocity" or key == "Velocity" then
                    if not checkcaller() and typeof(self) == "Instance"
                        and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then
                        local character = LP and LP.Character
                        if character and self:IsDescendantOf(character) then
                            return spoofedVelocity
                        end
                    end
                end
                return oldIdx(self, key)
            end)
            local newIndexHook = newcclosure(function(self, key, value)
                if key == "AssemblyLinearVelocity" or key == "Velocity" then
                    if not checkcaller() and typeof(self) == "Instance"
                        and self:IsA("BasePart") and self.Name == "HumanoidRootPart" then
                        local character = LP and LP.Character
                        if character and self:IsDescendantOf(character) then
                            spoofedVelocity = value
                            return
                        end
                    end
                end
                return oldNewIdx(self, key, value)
            end)
            setreadonly(mt, false)
            writable = true
            mt.__index = indexHook
            mt.__newindex = newIndexHook
        end)
        if not ok and writable and oldIdx and oldNewIdx then
            pcall(function()
                mt.__index, mt.__newindex = oldIdx, oldNewIdx
            end)
        end
        if writable then pcall(setreadonly, mt, true) end
        if not ok then warn("[M10RU Duels] Anti Drop hook unavailable: " .. tostring(err)) end
    else
        warn("[M10RU Duels] Anti Drop executor functions unavailable; other features will load.")
    end
end

local Camera = workspace.CurrentCamera
do
    local deadline = os.clock() + 15
    while (not LP or not Camera) and os.clock() < deadline do
        task.wait(0.1)
        LP = Players.LocalPlayer
        Camera = workspace.CurrentCamera
    end
end
if not LP or not Camera then
    warn("[M10RU Duels] LocalPlayer or CurrentCamera is unavailable. Wait for the game to load and try again.")
    return
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    if workspace.CurrentCamera then Camera = workspace.CurrentCamera end
end)

-- Helper to safely get character components
local function getCharData()
    local char = LP and LP.Character
    if not char then return nil, nil, nil end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local hrp  = char:FindFirstChild("HumanoidRootPart")
    return char, hum, hrp
end

-- ========================================================================
-- SHARED PURPLE THEME + INTERRUPTIBLE UI MOTION (visuals only, never physics)
-- ========================================================================

local DEFAULT_THEME = {
    background = Color3.fromRGB(11, 8, 18),
    panel = Color3.fromRGB(18, 14, 28),
    button = Color3.fromRGB(28, 20, 44),
    track = Color3.fromRGB(36, 25, 58),
    border = Color3.fromRGB(92, 45, 165),
    deep = Color3.fromRGB(123, 44, 191),
    accent = Color3.fromRGB(157, 78, 221),
    light = Color3.fromRGB(224, 170, 255),
    text = Color3.fromRGB(250, 248, 255),
    muted = Color3.fromRGB(185, 170, 215),
    dim = Color3.fromRGB(120, 105, 155),
    hover = Color3.fromRGB(45, 30, 72),
}

local UI = {
    alive = true, ready = false, cleanup = {}, root = nil,
    tweens = setmetatable({}, {__mode = "k"}),
    visibility = setmetatable({}, {__mode = "k"}),
    rows = setmetatable({}, {__mode = "k"}),
    theme = setmetatable({
        -- Legendary Modern Purple palette matching sleek dark card layout
        -- Deep dark background with glowing neon purple accents and high-contrast text
        background = Color3.fromRGB(11, 8, 18),
        panel = Color3.fromRGB(18, 14, 28),
        button = Color3.fromRGB(28, 20, 44),
        track = Color3.fromRGB(36, 25, 58),
        border = Color3.fromRGB(92, 45, 165),
        deep = Color3.fromRGB(123, 44, 191),
        accent = Color3.fromRGB(157, 78, 221),
        light = Color3.fromRGB(224, 170, 255),
        text = Color3.fromRGB(250, 248, 255),
        muted = Color3.fromRGB(185, 170, 215),
        dim = Color3.fromRGB(120, 105, 155),
        hover = Color3.fromRGB(45, 30, 72),
    }, {__index = function(t, k) return DEFAULT_THEME[k] or Color3.fromRGB(157, 78, 221) end}),
}
do
    local runtimeEnvironment = _G
    if type(getgenv) == "function" then
        local ok, environment = pcall(getgenv)
        if ok and type(environment) == "table" then runtimeEnvironment = environment end
    end
    local runtimeKey = "__M10RU_DUELS_RUNTIME"
    local previous = runtimeEnvironment[runtimeKey] or runtimeEnvironment["__FLUX_PURPLE_SMOOTH_RUNTIME"]
    if type(previous) == "table" and type(previous.destroy) == "function" then pcall(previous.destroy) end
    runtimeEnvironment[runtimeKey] = UI

    function UI.addCleanup(callback) table.insert(UI.cleanup, callback) end

    function UI.goal(object, property)
        local states = UI.tweens[object]
        local record = states and states[property]
        if record and record.tween then return record.goal end
        return object[property]
    end

    function UI.cancel(object, property)
        local states = UI.tweens[object]
        local record = states and states[property]
        if record then
            states[property] = nil
            if record.tween then pcall(function() record.tween:Cancel() end) end
        end
    end

    function UI.animate(object, goals, duration)
        if not UI.alive or not object then return end
        local states = UI.tweens[object]
        if not states then states = {}; UI.tweens[object] = states end
        for property, value in pairs(goals) do
            local current = states[property]
            -- Repeated refresh/Heartbeat calls must not restart the same tween.
            if current and current.goal == value and (current.tween or object[property] == value) then continue end
            UI.cancel(object, property)
            if not UI.ready or duration == 0 or object[property] == value then
                object[property] = value
                states[property] = {goal = value}
            else
                local tween = TweenService:Create(object,
                    TweenInfo.new(duration or 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                    {[property] = value})
                local record = {goal = value, tween = tween}
                states[property] = record
                tween.Completed:Connect(function()
                    if states[property] == record then record.tween = nil end
                end)
                tween:Play()
            end
        end
    end

    local function opacityTargets(object)
        if object:IsA("CanvasGroup") then return {{object = object, property = "GroupTransparency", value = 0}} end
        local targets = {}
        local objects = {object}
        for _, child in ipairs(object:GetDescendants()) do table.insert(objects, child) end
        for _, child in ipairs(objects) do
            if child:IsA("GuiObject") then
                table.insert(targets, {object = child, property = "BackgroundTransparency", value = child.BackgroundTransparency})
                if child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("TextBox") then
                    table.insert(targets, {object = child, property = "TextTransparency", value = child.TextTransparency})
                elseif child:IsA("ImageLabel") or child:IsA("ImageButton") then
                    table.insert(targets, {object = child, property = "ImageTransparency", value = child.ImageTransparency})
                end
            elseif child:IsA("UIStroke") then
                table.insert(targets, {object = child, property = "Transparency", value = child.Transparency})
            end
        end
        return targets
    end

    function UI.show(object, show, instant)
        if not UI.alive or not object then return end
        local state = UI.visibility[object]
        if state and state.wanted == show and not instant then return end
        if not state then
            state = {generation = 0, targets = opacityTargets(object)}
            UI.visibility[object] = state
        end
        state.wanted = show
        state.generation += 1
        local generation = state.generation
        local immediate = instant or not UI.ready
        if show then
            local wasHidden = not object.Visible
            object.Visible = true
            if wasHidden and not immediate then
                for _, target in ipairs(state.targets) do
                    UI.cancel(target.object, target.property)
                    target.object[target.property] = 1
                end
            end
        end
        for _, target in ipairs(state.targets) do
            UI.animate(target.object, {[target.property] = show and target.value or 1}, immediate and 0 or 0.20)
        end
        if immediate then
            object.Visible = show
        elseif not show then
            task.delay(0.21, function()
                if UI.alive and state.generation == generation and not state.wanted and object.Parent then
                    object.Visible = false
                end
            end)
        end
    end

    function UI.isShown(object)
        local state = UI.visibility[object]
        if state then return state.wanted end
        return object.Visible
    end

    function UI.row(object, show, height)
        if not UI.alive then return end
        local old = UI.rows[object]
        if old == show then return end
        UI.rows[object] = show
        UI.animate(object, {Size = UDim2.new(1, 0, 0, show and height or 0)}, 0.22)
        UI.show(object, show)
    end

    function UI.text(object, text)
        if not UI.alive or object.Text == text then return end
        object.Text = text
        if UI.ready then
            UI.cancel(object, "TextTransparency")
            object.TextTransparency = 0.40
            UI.animate(object, {TextTransparency = 0}, 0.13)
        end
    end

    -- This lock freezes dragging only; all buttons remain clickable.
    UI.dragTargets = setmetatable({}, {__mode = "k"})
    UI.dragLocked = false
    function UI.trackDrag(frame, cancel)
        UI.dragTargets[frame] = cancel
    end
    function UI.setDragLocked(locked)
        UI.dragLocked = locked == true
        if UI.dragLocked then
            for frame, cancel in pairs(UI.dragTargets) do
                if not frame:GetAttribute("M10RUAlwaysDraggable") then
                    cancel()
                    UI.cancel(frame, "Position")
                end
            end
        end
    end
    function UI.drag(frame, handle, ignoreLock)
        handle = handle or frame
        handle.Active = true
        local active, pointer, start, position = false, nil, nil, nil
        local function cancel() active, pointer, start, position = false, nil, nil, nil end
        UI.trackDrag(frame, cancel)
        local connections = {}
        table.insert(connections, handle.InputBegan:Connect(function(input)
            if not UI.alive or (UI.dragLocked and not ignoreLock) then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            UI.cancel(frame, "Position")
            active, pointer, start, position = true, input, input.Position, frame.Position
        end))
        table.insert(connections, UserInputService.InputChanged:Connect(function(input)
            if not UI.alive or (UI.dragLocked and not ignoreLock) or not active or not pointer then return end
            local matches = input == pointer or (pointer.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseMovement)
            if not matches then return end
            local delta = input.Position - start
            local destination = UDim2.new(position.X.Scale, position.X.Offset + delta.X,
                position.Y.Scale, position.Y.Offset + delta.Y)
            if UI.constrainDrag then destination = UI.constrainDrag(frame, destination) end
            UI.animate(frame, {Position = destination}, 0.08)
        end))
        table.insert(connections, UserInputService.InputEnded:Connect(function(input)
            if input == pointer or (pointer and pointer.UserInputType == Enum.UserInputType.MouseButton1
                and input.UserInputType == Enum.UserInputType.MouseButton1) then cancel() end
        end))
        UI.addCleanup(function()
            cancel()
            for _, connection in ipairs(connections) do connection:Disconnect() end
            UI.dragTargets[frame] = nil
        end)
    end

    function UI.destroy()
        if not UI.alive then return end
        UI.alive = false
        for index = #UI.cleanup, 1, -1 do pcall(UI.cleanup[index]) end
        table.clear(UI.cleanup)
        for object, states in pairs(UI.tweens) do
            for property in pairs(states) do UI.cancel(object, property) end
        end
        if UI.root then pcall(function() UI.root:Destroy() end) end
        if runtimeEnvironment[runtimeKey] == UI then runtimeEnvironment[runtimeKey] = nil end
    end
end


-- ========================================================================
-- CONSTANTS & VARIABLES
-- ========================================================================
-- Keep shared state in one local table instead of 67 long-lived locals.
-- This avoids Luau's 200-local-register limit without creating globals.
local State = {}

State.NS                  = 60
State.CS                  = 30
State.LAGGER_SPEED        = 15
State.LAGGER_CARRY_SPEED  = 24.5

State.speedMode           = false
State.autoCarrySpeedEnabled = false
State.autoCarryLastSpeed    = 0
-- Auto Switch Carry Speed state, ported from Horizon's Auto Carry logic.
State.autoCarryFromSteal    = false
State.autoCarryGraceUntil   = 0
State.autoCarryReturnMode   = nil
State.autoCarryWaitingForPickup = false
State.autoCarryPickupWatchUntil = 0
State.stealAttrWasActive    = false
State.laggerToggled       = false
State.laggerPhase         = 0

State.antiRagdollEnabled  = false
State.antiRagdollMode     = "Off"
State.infJumpEnabled      = false
State.infJumpMode         = "manual"

_G.AdaptAntiVoidEnabled = true
_G.AdaptAntiVoidConnection = _G.AdaptAntiVoidConnection or nil
_G.AdaptAntiVoidSafeCFrame = _G.AdaptAntiVoidSafeCFrame or nil

function _G.AdaptAntiVoidSaveSafe()
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    if hum.FloorMaterial ~= Enum.Material.Air then
        _G.AdaptAntiVoidSafeCFrame = root.CFrame
    end
end

function _G.AdaptAntiVoidStop()
    if _G.AdaptAntiVoidConnection then
        pcall(function() _G.AdaptAntiVoidConnection:Disconnect() end)
        _G.AdaptAntiVoidConnection = nil
    end
end

function _G.AdaptAntiVoidSet(on)
    _G.AdaptAntiVoidEnabled = on == true
    _G.AdaptAntiVoidStop()
    if not _G.AdaptAntiVoidEnabled then return end

    _G.AdaptAntiVoidSaveSafe()

    _G.AdaptAntiVoidConnection = RunService.Heartbeat:Connect(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not _G.AdaptAntiVoidEnabled or not hum or not root or hum.Health <= 0 then return end

        local voidY = workspace.FallenPartsDestroyHeight + 30
        if hum.FloorMaterial ~= Enum.Material.Air and root.Position.Y > voidY + 12 then
            _G.AdaptAntiVoidSafeCFrame = root.CFrame
        elseif root.Position.Y <= voidY and _G.AdaptAntiVoidSafeCFrame then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = _G.AdaptAntiVoidSafeCFrame + Vector3.new(0, 4, 0)
            hum.PlatformStand = false
            hum.Sit = false
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)
end

-- Always-on Anti Void: no menu/toggle is created.
pcall(function() _G.AdaptAntiVoidSet(true) end)
if not _G.__M10RU_AntiVoidCharacterHook then
    _G.__M10RU_AntiVoidCharacterHook = true
    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if _G.AdaptAntiVoidEnabled then
            pcall(function() _G.AdaptAntiVoidSaveSafe() end)
        end
    end)
end
State.medusaCounterEnabled= false
State.batCounterEnabled   = false
State.unwalkEnabled       = false
State.autoBatEnabled      = false
State.antiDieEnabled      = false
State.instantResetOnDieEnabled = false
State.antiFlingEnabled    = false
State.bodyLockEnabled     = false
State.bodyLockRange       = 20
State.tpBatEnabled        = false
State.autoSwingEnabled    = true
State.animPack            = "OFF"
State.antiLagEnabled      = false
State.fpsBoostEnabled     = false
State.espEnabled          = false
State.tracersEnabled      = false
State.stretchRezEnabled   = false
State.autoTPEnabled       = false
State.autoTPHeight        = 20
State.introEnabled        = true

State.autoLeftEnabled     = false
State.autoRightEnabled    = false

-- Auto Play Mode:
-- Half = the existing two-button Auto Left / Auto Right system.
-- Auto = the Auto Play route taken from EclipseHub.
State.autoPlayMode        = "Half"
State.autoPlayEnabled     = false
State.autoPlayRoute       = "none"
State.autoPlayWPIndex     = 1

State.dropActive          = false
State.medusaDebounce      = false
State.medusaLastUsed      = 0
State.batCounterDebounce  = false
State.isStealing          = false
State.stealStartTime      = nil

State.HIT_DIST               = 8
State.MEDUSA_COOLDOWN        = 25
State.DROP_ASCEND_DURATION   = 0.2
State.DROP_ASCEND_SPEED      = 150


State.AP_L1 = Vector3.new(-476.47, -6.28, 92.73)
State.AP_L2 = Vector3.new(-483.12, -4.95, 94.81)
State.AP_R1 = Vector3.new(-476.16, -6.52, 25.62)
State.AP_R2 = Vector3.new(-483.06, -5.03, 25.48)

State.PLOT3_POS = Vector3.new(-476.75, 10.46, 7.11)
State.PLOT7_POS = Vector3.new(-476.75, 10.46, 114.11)
State.TP_PLOT3  = Vector3.new(-475.34, -6.81, 32.33)
State.TP_PLOT7  = Vector3.new(-474.24, -6.81, 87.08)

-- AUTO GRAB settings: engine selection is independent of appearance.
State.SemiMode       = "V1" -- Normal engine: V1 or V2
State.SemiEnabled    = false -- SEMI instant engine from the second file
State.SemiNormalOpen = false -- Normal engine ON/OFF AND category visibility
State.AutoGrabStyle  = {V1 = 2, V2 = 2, SEMI = 2}
State.v1Scale        = 1.0
State.v2Scale        = 1.0
State.semiScale      = 1.0

State.StealV1 = {
    AutoStealEnabled = false,
    StealRadius      = 61, -- LOCKED, cannot be changed
    StealDuration    = 1.3,
    StealDelay       = 0.25,
    Data             = {}
}
State.autoGrabSetDelayRadius = 9
State.autoGrabStopTime       = 0.975
State.autoGrabStopEnabled    = true
State.autoGrabMode            = 75

State.StealV2 = {
    AutoStealEnabled = false,
    StealRadius      = 61, -- Yout AutoSteal radius is fixed; no radius control in the UI.
    StealDuration    = 0.3,
    Mode             = "half",
    HalfFireRange    = 10,
    HalfHoldMin      = 1.3,
    HalfHoldMax      = 2.6,
    HalfEntryDelay   = 0.3,
    Data             = {}
}
State.isStealingV1   = false
State.isStealingV2   = false
State.stealStartTimeV2 = nil

local KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    TpBat        = {kb = Enum.KeyCode.T, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    SpeedToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    -- Horizon uses R for Instant Reset; move Lagger off the same key.
    LaggerToggle = {kb = Enum.KeyCode.G, gp = nil},
    InstantReset = {kb = Enum.KeyCode.R, gp = nil}
}

local MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true
}

-- Connection Management Table
local Conns = {
    autoStealV1 = nil,
    autoStealV2 = nil,
    autoStealSemi = nil,
    antiRag = nil,
    batCounter = nil,
    anchor = {},
    progress = nil,
    autoTP = nil,
    autoLeft = nil,
    autoRight = nil,
    autoPlay = nil,
    stretchRez = nil,
    antiLagDesc = nil,
    fpsBoostDesc = nil
}

-- UI Callback Setters
local setInfJumpVisual, setAntiRagVisual, setMedusaVisual, setJumpModeVisual
local setUnwalkVisual, setAntiLagVisual, setAutoSwingVisual, setBatCounterVisual
local setStretchRezVisual, setAutoTPVisual, setFPSBoostVisual
local setESPVisual, setTracersVisual, applyESPState, applyTracersState
local setAutoBatVisual, setAutoGrabVisual, setAutoSwitchSpeedVisual, autoLeftSetVisual, autoRightSetVisual, autoPlayLeftSetVisual, autoPlayRightSetVisual
local setBodyLockVisual, setAntiFlingVisual, setInstantResetOnDieVisual
local setSkyVisual, setIntroVisual
local normalBox, carryBox, laggerCarryBox, autoTPHeightBox, bodyLockRangeBox
local speedLabel, modeValLbl
-- One shared controller avoids extra long-lived locals / Luau register pressure.
local Combat = {}
local AntiDie
local InstantReset

local Grab = {
    alive = true, epoch = 0, uiTarget = "V1", appearanceOpen = false,
    views = {}, connections = {}, displayed = 0, progressV1 = 0, v2Ready = false,
    phaseV1 = "idle", phaseV2 = "idle",
    -- Performance is sampled over real RenderStepped frames, not 1/dt from
    -- the last frame. The fill is capped before the opaque stats plate.
    perf = {elapsed = 0, frames = 0, fps = 0, ping = 0, pingAt = 0},
    visualFillLimit = 0.70,
    purple = UI.theme,
}
local refreshSemiUI = nil

-- ========================================================================
-- ARABI SPEED: supplied PreSimulation / normalized XZ AssemblyLinearVelocity.
-- The supplied Arabi file updates a spoof vector but contains NO velocity read
-- hook. No Haze LinearVelocity constraint, hook, loader or unrelated Arabi code.
-- ========================================================================
local function isRagdollState(hum)
    if not hum then return true end
    local state = hum:GetState()
    return hum.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

local Speed = {alive = true, connections = {}, lastMoveDir = Vector3.zero, spoofedVelocity = Vector3.zero}
function Speed.pathActive() return State.autoLeftEnabled or State.autoRightEnabled or State.autoPlayEnabled end

-- Horizon Auto Switch Carry Speed port. It only switches speed while a steal /
-- carry handoff is active; enabling the button does not force Carry forever.
local AutoCarry = {
    nearAt = 0, nearValue = false,
}

local function isCarryName(name)
    local value = tostring(name or ""):lower()
    return value:find("brainrot") or value:find("animal") or value:find("carry")
        or value:find("grab") or value:find("steal") or value:find("hold")
end

local function isIgnoredCarryTool(name)
    local value = tostring(name or ""):lower()
    return value:find("bat") or value:find("slap") or value:find("medusa")
        or value:find("head") or value:find("stone")
end

local function isCarryingBrainrot(char)
    if not char then return false end
    for _, name in ipairs({"Carrying", "IsCarrying", "Grabbed", "Holding", "StealHold", "HasGrab"}) do
        local value = char:FindFirstChild(name, true)
        if value then
            if value:IsA("BoolValue") and value.Value then return true end
            if value:IsA("ObjectValue") and value.Value then return true end
            if value:IsA("StringValue") and value.Value ~= "" then return true end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true) then
            if child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then return true end
            if isCarryName(child.Name) then return true end
        elseif child:IsA("Tool") and not isIgnoredCarryTool(child.Name) then
            return true
        end
    end
    return false
end

local function isNearBrainrot(char)
    local now = tick()
    if now - AutoCarry.nearAt < 0.15 then return AutoCarry.nearValue end
    AutoCarry.nearAt, AutoCarry.nearValue = now, false
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local holder = prompt.Parent
            local part = holder and holder:IsA("BasePart") and holder
                or holder and holder:FindFirstAncestorWhichIsA("BasePart")
            if part and (part.Position - root.Position).Magnitude <= 11 then
                AutoCarry.nearValue = true
                return true
            end
        end
    end
    return false
end

local function setAutoCarryBaseMode(on)
    State.speedMode = on == true
end

-- Horizon Auto Switch Carry Speed logic. The selected speed family is saved
-- before switching, then restored exactly when the prompt/steal/carry ends.
local function enableAutoCarrySpeed()
    State.autoCarryWaitingForPickup = false
    State.autoCarryPickupWatchUntil = 0
    if not State.autoCarryFromSteal then
        State.autoCarryReturnMode = (State.laggerToggled and State.laggerPhase == 2 and "Lagger Carry")
            or (State.laggerToggled and "Lagger")
            or (State.speedMode and "Carry")
            or "Normal"
    end
    State.autoCarryFromSteal = true
    State.autoCarryGraceUntil = tick() + 0.75

    if State.autoCarryReturnMode == "Lagger" or State.autoCarryReturnMode == "Lagger Carry" then
        State.laggerToggled, State.laggerPhase, State.speedMode = true, 2, false
    else
        setAutoCarryBaseMode(true)
    end
    if Speed.refreshVisuals then Speed.refreshVisuals() end
end

local function disableAutoCarrySpeed()
    if not State.autoCarryFromSteal and not State.autoCarryWaitingForPickup then return end
    local wasAutoApplied = State.autoCarryFromSteal
    local returnMode = State.autoCarryReturnMode
    State.autoCarryFromSteal = false
    State.autoCarryWaitingForPickup = false
    State.autoCarryPickupWatchUntil = 0
    State.autoCarryReturnMode = nil
    if not wasAutoApplied then return end

    if returnMode == "Lagger Carry" then
        State.laggerToggled, State.laggerPhase, State.speedMode = true, 2, false
    elseif returnMode == "Lagger" then
        State.laggerToggled, State.laggerPhase, State.speedMode = true, 1, false
    elseif returnMode == "Carry" then
        State.laggerToggled, State.laggerPhase, State.speedMode = false, 0, true
    else
        State.laggerToggled, State.laggerPhase, State.speedMode = false, 0, false
    end
    State.autoCarryLastSpeed = 0
    if Speed.refreshVisuals then Speed.refreshVisuals() end
end

function Speed.updateAutoCarry(char, hum)
    -- Unwalk only removes the walk animation; Auto Switch Carry must continue
    -- to detect real steal/carry handoffs while it is enabled.
    if not State.autoCarrySpeedEnabled then
        if State.autoCarryFromSteal or State.autoCarryWaitingForPickup then disableAutoCarrySpeed() end
        return
    end

    -- Same detection/order as Horizon Hub: prompt nearby, Stealing attribute,
    -- and actual carry state. State.isStealing is deliberately not used here;
    -- it can outlive a finished grab and was making Carry Speed stick on.
    local gotHit = isRagdollState(hum)
    local stealingAttr = LP:GetAttribute("Stealing") == true
    local nearBrainrot = isNearBrainrot(char)
    local carryingBrainrot = isCarryingBrainrot(char) or nearBrainrot

    if nearBrainrot and not State.autoCarryFromSteal then enableAutoCarrySpeed() end
    if stealingAttr and not State.stealAttrWasActive then
        State.stealAttrWasActive = true
        enableAutoCarrySpeed()
    elseif not stealingAttr then
        State.stealAttrWasActive = false
    end
    if State.autoCarryWaitingForPickup then
        if gotHit or tick() > (State.autoCarryPickupWatchUntil or 0) then
            State.autoCarryWaitingForPickup = false
        elseif carryingBrainrot then
            enableAutoCarrySpeed()
        end
    end
    if carryingBrainrot and not State.autoCarryFromSteal then enableAutoCarrySpeed() end
    if State.autoCarryFromSteal and (gotHit
        or (tick() > State.autoCarryGraceUntil and not carryingBrainrot and not stealingAttr)) then
        disableAutoCarrySpeed()
    end
end

local function getActiveMoveSpeed()
    if Speed.pathActive() then return State.NS end
    if State.autoCarryFromSteal then
        if State.autoCarryReturnMode == "Lagger" or State.autoCarryReturnMode == "Lagger Carry" then
            return State.LAGGER_CARRY_SPEED
        end
        return State.CS
    end
    local carry = State.speedMode or (State.laggerToggled and State.laggerPhase == 2)
    if State.laggerToggled and carry then return State.LAGGER_CARRY_SPEED end
    if State.laggerToggled then return State.LAGGER_SPEED end
    if carry then return State.CS end
    return State.NS
end
local function getAutoPathSpeed()
    return State.NS
end
do
    function Speed.readVelocity(root) return root.AssemblyLinearVelocity end
    function Speed.writeVelocity(root, value) root.AssemblyLinearVelocity = value end
    function Speed.suspend() Speed.lastMoveDir = Vector3.zero end
    function Speed.blocked()
        return State.autoBatEnabled or State.autoLeftEnabled or State.autoRightEnabled
            or State.tpBatEnabled or State.dropActive
    end
    -- Exact Arabi-style drive: real X/Z velocity is set to the selected speed.
    -- Anti Drop may spoof reads, but it does not replace this movement calculation.
    function Speed.syncSpoofFromReal(root)
        local v = root.AssemblyLinearVelocity
        local flat = Vector3.new(v.X, 0, v.Z)
        if flat.Magnitude > 1 then
            local u = flat.Unit
            Speed.spoofedVelocity = Vector3.new(u.X * 16, v.Y, u.Z * 16)
        else
            Speed.spoofedVelocity = Vector3.new(0, v.Y, 0)
        end
    end
    function Speed.applyDrive(root, flat, speed)
        local realY = root.AssemblyLinearVelocity.Y
        root.AssemblyLinearVelocity = Vector3.new(flat.X * speed, realY, flat.Z * speed)
    end
    function Speed.step()
        if not Speed.alive then return end
        local char, hum, root = getCharData()
        if not char or not hum or not root or hum.Health <= 0 then return end
        Speed.updateAutoCarry(char, hum)

        if isRagdollState(hum) then
            Speed.lastMoveDir = Vector3.zero
            Speed.syncSpoofFromReal(root)
            return
        end

        local busy = Speed.blocked()
        if busy then
            if State.autoBatEnabled then Speed.lastMoveDir = Vector3.zero end
            Speed.syncSpoofFromReal(root)
        else
            local direction = hum.MoveDirection
            if direction.Magnitude > 0 then
                Speed.lastMoveDir = direction
            elseif State.antiRagdollEnabled and Speed.lastMoveDir.Magnitude > 0 then
                local anyHeld = false
                for key in pairs(MOVE_KEYS) do
                    if UserInputService:IsKeyDown(key) then
                        anyHeld = true
                        break
                    end
                end
                if anyHeld then direction = Speed.lastMoveDir end
            end

            if direction and direction.Magnitude > 0 then
                local flat = Vector3.new(direction.X, 0, direction.Z)
                if flat.Magnitude > 0 then flat = flat.Unit end
                pcall(function()
                    if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
                end)

                -- IMPORTANT: this is the actual selected speed, not the display value.
                -- Carry Speed 30 therefore drives X/Z at 30 while Carry is active.
                local activeSpeed = getActiveMoveSpeed()
                Speed.applyDrive(root, flat, activeSpeed)
            else
                Speed.syncSpoofFromReal(root)
            end
        end

        -- Match Arabi: display the actual X/Z velocity produced by the drive.
        if speedLabel and not State.isStealing then
            speedLabel.Text = string.format("%.1f",
                Vector3.new(root.AssemblyLinearVelocity.X, 0, root.AssemblyLinearVelocity.Z).Magnitude)
        end
    end
    function Speed.destroy()
        if not Speed.alive then return end
        Speed.alive = false
        for _, connection in ipairs(Speed.connections) do connection:Disconnect() end
        table.clear(Speed.connections)
        Speed.lastMoveDir, Speed.spoofedVelocity = Vector3.zero, Vector3.zero
    end
    local connected, speedConnection = pcall(function()
        return RunService.PreSimulation:Connect(Speed.step)
    end)
    if not connected then
        connected, speedConnection = pcall(function()
            return RunService.Heartbeat:Connect(Speed.step)
        end)
    end
    if connected and speedConnection then
        table.insert(Speed.connections, speedConnection)
    else
        warn("[M10RU Duels] Speed update signal unavailable: " .. tostring(speedConnection))
    end
    table.insert(Speed.connections, LP.CharacterRemoving:Connect(function()
        Speed.lastMoveDir, Speed.spoofedVelocity = Vector3.zero, Vector3.zero
    end))
    UI.addCleanup(Speed.destroy)
end
local function applyPathMovement(hum, root, moveDir, speed)
    if not hum or not root then return end
    Speed.applyDrive(root, moveDir, speed)
end

-- ========================================================================
-- TP BAT (High-Power Engine from tpbat.txt with Jump Restoration)
-- ========================================================================
local TpBat = {alive = true, generation = 0, connections = {}}
do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer

    local TP_BAT_CONFIG = {
        Range = 250,
        LoopDelay = 0.02,
        PredictMovement = true,
        PredictionFactor = 0.15,
        HealthCheck = true,
        TeamCheck = false,
        AutoBatDelay = 0.08,
    }

    local Engine = {
        running = false,
        thread = nil,
        hittingCooldown = false,
        humanoid = nil,
        hrp = nil,
        oldWalkSpeed = nil,
        oldJumpPower = nil,
        oldJumpHeight = nil,
        oldAutoRotate = nil,
    }

    local function getMyHRP()
        local char = LP.Character
        return char and char:FindFirstChild("HumanoidRootPart")
    end

    local function getMyHumanoid()
        local char = LP.Character
        return char and char:FindFirstChildOfClass("Humanoid")
    end

    local function getBat()
        local char = LP.Character
        if not char then return nil end
        local tool = char:FindFirstChild("Bat")
        if tool then return tool end
        local bp = LP:FindFirstChild("Backpack")
        if bp then
            tool = bp:FindFirstChild("Bat")
            if tool then
                tool.Parent = char
                return tool
            end
        end
        return nil
    end

    local function tryHitBat()
        if Engine.hittingCooldown then return end
        Engine.hittingCooldown = true
        pcall(function()
            local bat = getBat()
            if bat then
                bat:Activate()
                local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
            end
        end)
        task.delay(TP_BAT_CONFIG.AutoBatDelay, function()
            Engine.hittingCooldown = false
        end)
    end

    local function isValidEnemy(player)
        if player == LP or not player.Character then return false end
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if not hum or (TP_BAT_CONFIG.HealthCheck and hum.Health <= 0) then return false end
        if TP_BAT_CONFIG.TeamCheck and player.Team and player.Team == LP.Team then return false end
        local hrp = player.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        return true, hrp, hum
    end

    local function findNearestEnemy()
        local myHRP = getMyHRP()
        if not myHRP then return nil end
        local nearestHRP, shortestDist = nil, TP_BAT_CONFIG.Range
        for _, player in ipairs(Players:GetPlayers()) do
            local valid, hrp = isValidEnemy(player)
            if valid then
                local dist = (hrp.Position - myHRP.Position).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    nearestHRP = hrp
                end
            end
        end
        return nearestHRP
    end

    local function restoreCharacterMovement()
        local hum = Engine.humanoid or getMyHumanoid()
        if hum and hum.Parent then
            pcall(function()
                -- Restore WalkSpeed
                if Engine.oldWalkSpeed ~= nil and Engine.oldWalkSpeed > 0 then
                    hum.WalkSpeed = Engine.oldWalkSpeed
                else
                    hum.WalkSpeed = 16
                end

                -- Restore JumpPower and JumpHeight
                if Engine.oldJumpPower ~= nil and Engine.oldJumpPower > 0 then
                    hum.JumpPower = Engine.oldJumpPower
                else
                    hum.JumpPower = 50
                end

                if Engine.oldJumpHeight ~= nil and Engine.oldJumpHeight > 0 then
                    hum.JumpHeight = Engine.oldJumpHeight
                else
                    hum.JumpHeight = 7.2
                end

                -- Re-enable Jumping State explicitly so the mobile jump button and spacebar ALWAYS work!
                hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)

                if Engine.oldAutoRotate ~= nil then
                    hum.AutoRotate = Engine.oldAutoRotate
                else
                    hum.AutoRotate = true
                end

                hum.PlatformStand = false
                hum.Sit = false
            end)
        end

        Engine.oldWalkSpeed = nil
        Engine.oldJumpPower = nil
        Engine.oldJumpHeight = nil
        Engine.oldAutoRotate = nil
        Engine.humanoid = nil
        Engine.hrp = nil
    end

    local function teleportToTarget(targetHRP)
        local myHRP = getMyHRP()
        local myHum = getMyHumanoid()
        if not myHRP or not myHum or not targetHRP then return end

        pcall(function()
            myHum.WalkSpeed = 0
            myHum.JumpPower = 0
            myHum.AutoRotate = false
            myHum:Move(Vector3.zero)
            myHum.PlatformStand = false
            myHum.Sit = false

            -- Exact Body-Lock onto target HumanoidRootPart
            myHRP.CFrame = targetHRP.CFrame

            myHRP.Velocity = Vector3.zero
            myHRP.AssemblyLinearVelocity = Vector3.zero
            myHRP.RotVelocity = Vector3.zero
            myHRP.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    local function startTpBatEngine()
        if Engine.running then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end

        Engine.humanoid = hum
        Engine.hrp = hrp
        Engine.oldWalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        Engine.oldJumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        Engine.oldJumpHeight = hum.JumpHeight > 0 and hum.JumpHeight or 7.2
        Engine.oldAutoRotate = hum.AutoRotate
        Engine.running = true

        pcall(function()
            hum.WalkSpeed = 0
            hum.JumpPower = 0
            hum.AutoRotate = true
            hum:Move(Vector3.zero)
            hrp.Velocity = Vector3.zero
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.RotVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        Engine.thread = task.spawn(function()
            while Engine.running and State.tpBatEnabled do
                local target = findNearestEnemy()
                if target then
                    teleportToTarget(target)
                    tryHitBat()
                else
                    local curHRP = getMyHRP()
                    local curHum = getMyHumanoid()
                    if curHRP and curHum then
                        pcall(function()
                            curHum.WalkSpeed = 0
                            curHum.JumpPower = 0
                            curHum.AutoRotate = false
                            curHum:Move(Vector3.zero)
                            curHRP.Velocity = Vector3.zero
                            curHRP.AssemblyLinearVelocity = Vector3.zero
                            curHRP.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end
                task.wait(TP_BAT_CONFIG.LoopDelay)
            end
        end)
    end

    local function stopTpBatEngine()
        if not Engine.running then return end
        Engine.running = false

        if Engine.thread then
            pcall(function() task.cancel(Engine.thread) end)
            Engine.thread = nil
        end

        restoreCharacterMovement()
        Engine.hittingCooldown = false
    end

    function TpBat.refresh()
        if TpBat.uiSet then TpBat.uiSet(State.tpBatEnabled) end
        if TpBat.mobileSet then TpBat.mobileSet(State.tpBatEnabled) end
    end

    function TpBat.setEnabled(on)
        if not TpBat.alive then return false end
        on = (on == true)

        if State.tpBatEnabled == on then
            TpBat.refresh()
            return on
        end

        TpBat.generation += 1
        State.tpBatEnabled = on

        if on then
            -- The old file referenced missing suspend/restore functions.
            -- Stop only conflicting movement modes; keep their UI/features.
            if State.autoPlayEnabled and TpBat.stopAutoPlay then TpBat.stopAutoPlay() end
            if State.autoBatEnabled and Combat.stopGood then Combat.stopGood() end
            State.autoLeftEnabled, State.autoRightEnabled = false, false
            if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end
            if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if State.autoTPEnabled then
                State.autoTPEnabled = false
                if Conns.autoTP then pcall(task.cancel, Conns.autoTP); Conns.autoTP = nil end
                if setAutoTPVisual then setAutoTPVisual(false) end
            end
            Speed.suspend()
            startTpBatEngine()
        else
            stopTpBatEngine()
            -- Other movement modes can be turned on again normally in the UI.
        end

        TpBat.refresh()
        return on
    end

    function TpBat.toggle()
        return TpBat.setEnabled(not State.tpBatEnabled)
    end

    function TpBat.destroy()
        if not TpBat.alive then return end
        TpBat.setEnabled(false)
        TpBat.alive = false
        for _, connection in ipairs(TpBat.connections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(TpBat.connections)
    end

    table.insert(TpBat.connections, LP.CharacterRemoving:Connect(function()
        if State.tpBatEnabled then stopTpBatEngine() end
    end))
    table.insert(TpBat.connections, LP.CharacterAdded:Connect(function(character)
        task.delay(0.5, function()
            if TpBat.alive and State.tpBatEnabled and LP.Character == character then
                startTpBatEngine()
            end
        end)
    end))
    UI.addCleanup(TpBat.destroy)
end

-- Optimized Player Collision (Safe & Real Mass Preserved)
task.spawn(function()
    while true do
        task.wait(0.5)
        if not State.tpBatEnabled then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end
end)

-- ========================================================================
-- PLOT DETECTION
-- ========================================================================
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

local function getMyPlot()
    for plotNum, plotPos in pairs({[3] = State.PLOT3_POS, [7] = State.PLOT7_POS}) do
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name == "PlotSign" then
                if (obj.Position - plotPos).Magnitude < 5 then
                    for _, child in ipairs(obj:GetDescendants()) do
                        if child:IsA("SurfaceGui") then
                            for _, label in ipairs(child:GetDescendants()) do
                                if label:IsA("TextLabel") and label.Text ~= "" then
                                    if string.find(label.Text, LP.Name) or string.find(label.Text, LP.DisplayName) then
                                        return plotNum
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function getMyPlotPosition()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then
            local sign = plot:FindFirstChild("PlotSign")
            if sign then return sign.Position + Vector3.new(0, 5, 0) end
            local ok, cf = pcall(function() return plot:GetModelCFrame() end)
            if ok and cf then return cf.Position + Vector3.new(0, 5, 0) end
        end
    end
    return nil
end

-- ========================================================================
-- AUTO GRAB: independent engines, shared skins, single active owner.
-- Normal V1/V2 keep their supplied ranges/timing. SEMI uses the second file.
-- Generation checks cancel old holds BEFORE another engine is enabled.
-- ========================================================================
do
    -- CLEAN Y/OUT AUTO GRAB ENGINE
    -- Ported only from the safe steal portion of the supplied file:
    -- 61-stud prompt targeting, hold/stop/range/final-trigger sequence and
    -- the 75/80/85/90 timing modes. No donor GUI, HTTP/loadstring code,
    -- teleport/CFrame behaviour, hidden loader, or unrelated remote logic.
    local function disconnect(connection)
        if connection then pcall(function() connection:Disconnect() end) end
    end

    function Grab.currentEngine()
        return (State.SemiNormalOpen and State.StealV1.AutoStealEnabled) and "YOUT" or nil
    end

    function Grab.uiEngine() return "YOUT" end

    function Grab.getStyle()
        return State.AutoGrabStyle.V1 or 2
    end

    function Grab.getScale()
        return State.v1Scale
    end

    function Grab.applyScale()
        local scale = Grab.getScale()
        for _, view in pairs(Grab.views) do
            UI.animate(view.scale, {Scale = scale}, 0.28)
        end
        if Grab.linkScale then UI.animate(Grab.linkScale, {Scale = math.max(scale, 0.9)}, 0.28) end
        if Grab.linkSync then Grab.linkSync() end
    end

    function Grab.updateBars()
        local active = Grab.currentEngine() ~= nil
        local style = active and Grab.getStyle() or nil
        Grab.visibleStyle = style
        if not active then Grab.displayed = 0 end
        for number, view in pairs(Grab.views) do
            UI.show(view.frame, active and style == number)
        end
        if Grab.linkFrame then UI.show(Grab.linkFrame, active and style == 2) end
        Grab.applyScale()
    end

    function Grab.refresh()
        Grab.updateBars()
        if refreshSemiUI then refreshSemiUI() end
    end

    function Grab.setStyle(style)
        if not Grab.alive then return end
        -- Any skin request resolves to the screenshot pill (skin 2).
        State.AutoGrabStyle.V1 = 2
        Grab.refresh()
    end

    function Grab.changeScale(delta)
        if not Grab.alive or type(delta) ~= "number" or delta ~= delta then return end
        State.v1Scale = math.clamp(math.floor((State.v1Scale + delta) * 10 + 0.5) / 10, 0.5, 2)
        Grab.refresh()
    end

    local function promptDistance(prompt)
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not prompt then return math.huge end
        local node = prompt.Parent
        while node and node ~= workspace do
            if node:IsA("BasePart") then return (root.Position - node.Position).Magnitude end
            node = node.Parent
        end
        return math.huge
    end

    -- The Y/out target selection is restricted to steal prompts in other plots.
    local function findNearestYoutPrompt()
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local plots = workspace:FindFirstChild("Plots")
        if not root or not plots then return nil, nil end

        local nearestPrompt, nearestDistance, nearestName = nil, math.huge, nil
        for _, plot in ipairs(plots:GetChildren()) do
            if isMyPlotByName(plot.Name) then continue end
            local podiums = plot:FindFirstChild("AnimalPodiums")
            if not podiums then continue end
            for _, podium in ipairs(podiums:GetChildren()) do
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attachment = spawn and spawn:FindFirstChild("PromptAttachment")
                if spawn and attachment then
                    local distance = (spawn.Position - root.Position).Magnitude
                    if distance <= State.StealV1.StealRadius and distance < nearestDistance then
                        for _, prompt in ipairs(attachment:GetChildren()) do
                            if prompt:IsA("ProximityPrompt") and tostring(prompt.ActionText):find("Steal") then
                                nearestPrompt, nearestDistance, nearestName = prompt, distance, podium.Name
                                break
                            end
                        end
                    end
                end
            end
        end
        return nearestPrompt, nearestName
    end

    local function callbacksFor(prompt)
        local data = State.StealV1.Data[prompt]
        if data then return data end
        data = {hold = {}, trigger = {}, ready = true}
        State.StealV1.Data[prompt] = data
        if getconnections then
            for _, pair in ipairs({{prompt.PromptButtonHoldBegan, data.hold}, {prompt.Triggered, data.trigger}}) do
                local ok, connections = pcall(getconnections, pair[1])
                if ok and type(connections) == "table" then
                    for _, connection in ipairs(connections) do
                        if type(connection.Function) == "function" then table.insert(pair[2], connection.Function) end
                    end
                end
            end
        end
        return data
    end

    local function dispatch(callbacks, current)
        for _, callback in ipairs(callbacks) do
            task.spawn(function()
                if current() then pcall(callback) end
            end)
        end
    end

    local function clearYoutSession(session)
        if session then session.active = false end
        if Grab.yout == session then Grab.yout = nil end
        State.isStealingV1, State.isStealingV2, State.isStealing = false, false, false
        Grab.progressV1, Grab.phaseV1 = 0, "idle"
        if session and session.data then session.data.ready = true end
        Grab.refresh()
    end

    local function fireYoutSteal(session)
        if session.fired or not session.active then return end
        session.fired = true
        dispatch(session.data.trigger, session.current)
        pcall(function()
            if not session.current() then return end
            local prompt = session.prompt
            if prompt then
                pcall(function() if prompt.InputHoldEnd then prompt:InputHoldEnd() end end)
                pcall(function() if fireproximityprompt then fireproximityprompt(prompt) end end)
            end
            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
            if remote and session.podName then remote:FireServer(session.podName) end
            if session.current() and prompt and prompt.Fire then prompt:Fire() end
        end)
    end

    local function executeYoutSteal(prompt, podName)
        if not Grab.alive or not State.StealV1.AutoStealEnabled or Grab.yout then return end
        if not prompt or not prompt.Parent then return end
        local data = callbacksFor(prompt)
        if not data.ready then return end

        local epoch, character = Grab.epoch, LP.Character
        if not character then return end
        local session = {
            epoch = epoch, character = character, prompt = prompt, podName = podName,
            data = data, active = true, fired = false, phase = "holding", progress = 0,
            startedAt = tick(),
        }
        function session.current()
            return Grab.alive and Grab.yout == session and session.active and Grab.epoch == epoch
                and State.SemiNormalOpen and State.StealV1.AutoStealEnabled
                and LP.Character == character and character.Parent and prompt.Parent
        end

        data.ready = false
        Grab.yout = session
        Grab.phaseV1, Grab.progressV1 = "holding", 0
        State.isStealingV1, State.isStealing = true, true
        Grab.refresh()

        task.spawn(function()
            local ok, err = pcall(function()
                -- Printed Auto Grab: captured hold callbacks, with a prompt fallback
                -- for executors that do not expose getconnections.
                dispatch(data.hold, session.current)
                if #data.hold == 0 then
                    pcall(function() if prompt.InputHoldBegin then prompt:InputHoldBegin() end end)
                end
                local duration = math.max(tonumber(State.StealV1.StealDuration) or 1.3, 0.05)
                local stopAt = math.clamp(State.autoGrabStopTime, 0, duration)

                if State.autoGrabStopEnabled then
                    while session.current() do
                        if promptDistance(prompt) > State.StealV1.StealRadius then return end
                        local elapsed = tick() - session.startedAt
                        if elapsed >= stopAt then break end
                        session.progress = math.clamp(elapsed / duration, 0, 1)
                        Grab.progressV1 = session.progress
                        task.wait()
                    end
                    if not session.current() then return end

                    local stopProgress = math.clamp(stopAt / duration, 0, 1)
                    session.progress, Grab.progressV1 = stopProgress, stopProgress
                    session.phase, Grab.phaseV1 = "waitingRange", "waitingRange"
                    local timeout = math.max(2.99 - stopAt - math.max(duration - stopAt, 0), 0.05)
                    local waitStarted = tick()
                    while session.current() do
                        local distance = promptDistance(prompt)
                        if distance <= State.autoGrabSetDelayRadius then break end
                        if distance > State.StealV1.StealRadius or tick() - waitStarted >= timeout then return end
                        task.wait()
                    end
                    if not session.current() then return end

                    session.phase, Grab.phaseV1 = "finishing", "finishing"
                    local fillStarted = tick()
                    local fillDuration = math.max(duration - stopAt, 0.05)
                    while session.current() do
                        local fillProgress = math.clamp((tick() - fillStarted) / fillDuration, 0, 1)
                        session.progress = stopProgress + fillProgress * (1 - stopProgress)
                        Grab.progressV1 = session.progress
                        if fillProgress >= 1 then fireYoutSteal(session); return end
                        task.wait()
                    end
                else
                    while session.current() do
                        if promptDistance(prompt) > State.StealV1.StealRadius then return end
                        local elapsed = tick() - session.startedAt
                        session.progress = math.clamp(elapsed / duration, 0, 1)
                        Grab.progressV1 = session.progress
                        if elapsed >= duration then fireYoutSteal(session); return end
                        task.wait()
                    end
                end
            end)
            if not ok then warn("[M10RU Duels Yout Auto Grab] " .. tostring(err)) end
            clearYoutSession(session)
        end)
    end

    function Grab.stopAll()
        -- Invalidate first: no old hold/trigger task may fire after Off.
        Grab.epoch += 1
        disconnect(Conns.autoStealV1); Conns.autoStealV1 = nil
        disconnect(Conns.autoStealV2); Conns.autoStealV2 = nil
        disconnect(Conns.autoStealSemi); Conns.autoStealSemi = nil
        if Grab.yout then Grab.yout.active = false end
        Grab.yout = nil
        State.SemiNormalOpen, State.SemiEnabled = false, false
        State.StealV1.AutoStealEnabled = false
        State.StealV2.AutoStealEnabled = false
        State.StealV1.Data, State.StealV2.Data = {}, {}
        State.isStealingV1, State.isStealingV2, State.isStealing = false, false, false
        Grab.progressV1, Grab.phaseV1, Grab.phaseV2, Grab.v2Ready = 0, "idle", "idle", false
        Grab.refresh()
    end

    function Grab.startNormal()
        if not Grab.alive then return end
        Grab.stopAll()
        State.SemiNormalOpen, State.SemiEnabled = true, false
        State.StealV1.AutoStealEnabled = true
        Grab.uiTarget = "YOUT"
        Conns.autoStealV1 = RunService.Heartbeat:Connect(function()
            if not Grab.alive or not State.StealV1.AutoStealEnabled or Grab.yout then return end
            local prompt, podName = findNearestYoutPrompt()
            if prompt then executeYoutSteal(prompt, podName) end
        end)
        Grab.refresh()
    end

    -- Old saved SEMI/V2 selections safely map to the new single Y/out engine.
    function Grab.startSemi() Grab.startNormal() end
    function Grab.toggleNormal()
        if State.SemiNormalOpen then Grab.stopAll() else Grab.startNormal() end
    end
    function Grab.toggleSemi() Grab.toggleNormal() end
    function Grab.switchMode(mode)
        if mode == "V1" or mode == "V2" then State.SemiMode = mode end
        Grab.refresh()
    end

    function Grab.getProgress()
        return Grab.yout and math.clamp(Grab.yout.progress or 0, 0, 1) or 0
    end

    function Grab.isReady()
        local session = Grab.yout
        return session ~= nil and session.active
            and (session.phase == "waitingRange" or session.phase == "finishing")
    end

    function Grab.loadSettings(cfg)
        -- Retain only display scale/style and the request to restore Auto Grab.
        if type(cfg.v1Scale) == "number" and cfg.v1Scale == cfg.v1Scale then
            State.v1Scale = math.clamp(cfg.v1Scale, 0.5, 2)
        end
        -- The reference-screenshot pill (skin 2) is the only appearance now.
        -- Older configs saved "skin 1"; always force the new pill instead.
        State.AutoGrabStyle.V1 = 2
        Grab.restoreRequested = (cfg.semiNormalOpen == true or cfg.semiEnabled == true) and "YOUT" or nil
    end

    function Grab.restore()
        if Grab.restoreRequested == "YOUT" then Grab.startNormal() else Grab.refresh() end
    end

    function Grab.destroy()
        if not Grab.alive then return end
        if Grab.linkFrame then
            pcall(function() Grab.linkFrame.Visible = false end)
        end
        Grab.stopAll()
        Grab.alive = false
        disconnect(Grab.renderConnection)
        Grab.renderConnection = nil
        for _, connection in ipairs(Grab.connections) do disconnect(connection) end
        table.clear(Grab.connections)
    end
end

UI.addCleanup(Grab.destroy)

-- ========================================================================
-- AUTO LEFT & AUTO RIGHT PATHRUNNERS
-- ========================================================================
local alPhase, arPhase = 1, 1

local function stopAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end
    alPhase = 1
    local char, hum = getCharData()
    if hum then hum:Move(Vector3.zero, false) end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
end

local function stopAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end
    arPhase = 1
    local char, hum = getCharData()
    if hum then hum:Move(Vector3.zero, false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
end

local function startAutoLeft()
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    alPhase = 1
    Conns.autoLeft = RunService.Heartbeat:Connect(function()
        if not State.autoLeftEnabled then return end
        local char, hum, hrp = getCharData()
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        
        -- Half uses Normal/boost speed going out, then Carry Speed for the
        -- complete return leg (no final switch back to Normal Speed).
        local spd = (alPhase == 2) and (State.CS or getAutoPathSpeed()) or getAutoPathSpeed()
        if alPhase == 1 then
            local tgt = Vector3.new(State.AP_L1.X, hrp.Position.Y, State.AP_L1.Z)
            if (tgt - hrp.Position).Magnitude < 1.2 then
                alPhase = 2
                local d = State.AP_L2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                applyPathMovement(hum, hrp, mv, spd)
                return
            end
            local d = State.AP_L1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            applyPathMovement(hum, hrp, mv, spd)
        elseif alPhase == 2 then
            local tgt = Vector3.new(State.AP_L2.X, hrp.Position.Y, State.AP_L2.Z)
            if (tgt - hrp.Position).Magnitude < 1.2 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                State.autoLeftEnabled = false
                stopAutoLeft()
                return
            end
            local d = State.AP_L2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            applyPathMovement(hum, hrp, mv, spd)
        end
    end)
end

local function startAutoRight()
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    arPhase = 1
    Conns.autoRight = RunService.Heartbeat:Connect(function()
        if not State.autoRightEnabled then return end
        local char, hum, hrp = getCharData()
        if not hrp or not hum then return end
        if isRagdollState(hum) then hum:Move(Vector3.zero, false); return end
        
        -- Half uses Normal/boost speed going out, then Carry Speed for the
        -- complete return leg (no final switch back to Normal Speed).
        local spd = (arPhase == 2) and (State.CS or getAutoPathSpeed()) or getAutoPathSpeed()
        if arPhase == 1 then
            local tgt = Vector3.new(State.AP_R1.X, hrp.Position.Y, State.AP_R1.Z)
            if (tgt - hrp.Position).Magnitude < 1.2 then
                arPhase = 2
                local d = State.AP_R2 - hrp.Position
                local mv = Vector3.new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                applyPathMovement(hum, hrp, mv, spd)
                return
            end
            local d = State.AP_R1 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            applyPathMovement(hum, hrp, mv, spd)
        elseif arPhase == 2 then
            local tgt = Vector3.new(State.AP_R2.X, hrp.Position.Y, State.AP_R2.Z)
            if (tgt - hrp.Position).Magnitude < 1.2 then
                hum:Move(Vector3.zero, false)
                hrp.AssemblyLinearVelocity = Vector3.zero
                State.autoRightEnabled = false
                stopAutoRight()
                return
            end
            local d = State.AP_R2 - hrp.Position
            local mv = Vector3.new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            applyPathMovement(hum, hrp, mv, spd)
        end
    end)
end

local function queueAutoLeftStart()
    State.autoLeftEnabled = true
    if State.autoRightEnabled then State.autoRightEnabled = false; stopAutoRight() end
    if State.autoBatEnabled then Combat.stopGood() end
    startAutoLeft()
end

local function queueAutoRightStart()
    State.autoRightEnabled = true
    if State.autoLeftEnabled then State.autoLeftEnabled = false; stopAutoLeft() end
    if State.autoBatEnabled then Combat.stopGood() end
    startAutoRight()
end

-- ========================================================================
-- AUTO PLAY: EclipseHub route, exposed as one button when Mode = Auto.
-- Half mode keeps the original Auto Left / Auto Right buttons untouched.
-- ========================================================================
local AutoPlay = {
    alive = true, active = false, route = "none", wpIndex = 1, conn = nil,
    autoCarryOwned = false,
}

-- EclipseHub AutoPlay waypoints (kept exactly for the Auto mode).
local AUTO_PLAY_LEFT = {
    Vector3.new(-475.86,-7,91.97), Vector3.new(-485.83,-7,97.37),
    Vector3.new(-475.86,-7,91.97), Vector3.new(-476.35,-7,27.88), Vector3.new(-477.09,-7,19.85),
}
local AUTO_PLAY_RIGHT = {
    Vector3.new(-475.84,-7,28.81), Vector3.new(-486.04,-7,23.32),
    Vector3.new(-475.51,-7,29.01), Vector3.new(-476.43,-7,91.61), Vector3.new(-476.27,-7,98.86),
}
_G.__autoLeftWaypoints = AUTO_PLAY_LEFT
_G.__autoRightWaypoints = AUTO_PLAY_RIGHT
_G.__autoplayMode = _G.__autoplayMode or "Full"

local function getAutoPlayRouteForMyBase()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return "left" end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        if yourBase and yourBase.Enabled then
            local target = plot:FindFirstChild("AnimalTarget", true)
            local refPos = target and target.Position
            if not refPos then
                local delivery = plot:FindFirstChild("DeliveryHitbox")
                refPos = delivery and delivery.Position
            end
            if refPos then
                local leftDist = (refPos - AUTO_PLAY_LEFT[1]).Magnitude
                local rightDist = (refPos - AUTO_PLAY_RIGHT[1]).Magnitude
                return (leftDist <= rightDist) and "right" or "left"
            end
            local pivotPos
            pcall(function() pivotPos = plot:GetPivot().Position end)
            if pivotPos then return (pivotPos.Z >= 60) and "right" or "left" end
            local _, _, root = getCharData()
            if root then return (root.Position.Z >= 60) and "right" or "left" end
            return "left"
        end
    end
    return "left"
end

local function getAutoPlaySpeed(wpIndex)
    -- EclipseHub AutoPlay changes to carry/steal speed after waypoint 2.
    -- Do not wait for the Stealing attribute: the return leg must stay at
    -- Carry Speed all the way to the final waypoint.
    if wpIndex > 2 then
        if State.autoCarryReturnMode == "Lagger" or State.autoCarryReturnMode == "Lagger Carry" then
            return State.LAGGER_CARRY_SPEED or State.CS
        end
        return State.CS
    end
    return getAutoPathSpeed()
end

local function stopAutoPlay(keepToggle)
    AutoPlay.active = false
    State.autoPlayEnabled = false
    AutoPlay.route = "none"
    State.autoPlayRoute = "none"
    AutoPlay.wpIndex = 1
    State.autoPlayWPIndex = 1
    if Conns.autoPlay then Conns.autoPlay:Disconnect(); Conns.autoPlay = nil end
    if AutoPlay.autoCarryOwned then
        AutoPlay.autoCarryOwned = false
        pcall(disableAutoCarrySpeed)
    end
    local _, hum, root = getCharData()
    if hum then hum:Move(Vector3.zero, false) end
    if root then
        local v = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(0, v.Y, 0)
    end
    -- The route is stopped, so the shared AUTO button must also show OFF.
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if autoPlayLeftSetVisual then autoPlayLeftSetVisual(false) end
    if autoPlayRightSetVisual then autoPlayRightSetVisual(false) end
    if autoPlaySetVisual then autoPlaySetVisual(false) end
end
TpBat.stopAutoPlay = stopAutoPlay

local function startAutoPlay()
    if State.autoPlayMode ~= "Auto" then return end
    if AutoPlay.active then stopAutoPlay(true) end

    -- AutoPlay takes control of movement just like EclipseHub.
    if State.autoLeftEnabled then State.autoLeftEnabled = false; stopAutoLeft() end
    if State.autoRightEnabled then State.autoRightEnabled = false; stopAutoRight() end
    if State.autoBatEnabled and Combat and Combat.stopGood then pcall(Combat.stopGood) end
    if State.tpBatEnabled and TpBat and TpBat.setEnabled then pcall(function() TpBat.setEnabled(false) end) end

    if AutoPlay.route ~= "left" and AutoPlay.route ~= "right" then
        AutoPlay.route = getAutoPlayRouteForMyBase()
    end
    State.autoPlayRoute = AutoPlay.route
    AutoPlay.wpIndex = 1
    State.autoPlayWPIndex = 1
    AutoPlay.active = true
    State.autoPlayEnabled = true

    -- EclipseHub keeps Auto Carry Speed active while AutoPlay is running.
    if not State.autoCarryFromSteal then
        AutoPlay.autoCarryOwned = true
        pcall(enableAutoCarrySpeed)
    end

    if AutoPlay.route == "left" then
        if autoLeftSetVisual then autoLeftSetVisual(true) end
        if autoRightSetVisual then autoRightSetVisual(false) end
    else
        if autoRightSetVisual then autoRightSetVisual(true) end
        if autoLeftSetVisual then autoLeftSetVisual(false) end
    end

    Conns.autoPlay = RunService.Heartbeat:Connect(function(dt)
        if not AutoPlay.active or State.autoPlayMode ~= "Auto" then return end
        local char, hum, root = getCharData()
        if not char or not hum or not root or hum.Health <= 0 then return end

        local waypoints = (AutoPlay.route == "left") and AUTO_PLAY_LEFT or AUTO_PLAY_RIGHT
        local stopIdx = (_G.__autoplayMode == "Semi") and 2 or #waypoints
        local wp = waypoints[AutoPlay.wpIndex]
        if not wp then stopAutoPlay(); return end

        local myPos = root.Position
        local targetXZ = Vector3.new(wp.X, 0, wp.Z)
        local myXZ = Vector3.new(myPos.X, 0, myPos.Z)
        local delta = targetXZ - myXZ
        local dXZ = delta.Magnitude

        if dXZ <= 1.1 then
            root.Velocity = Vector3.new(0, root.Velocity.Y, 0)

            if AutoPlay.wpIndex >= stopIdx then
                -- Full mode waits at the final point until the steal ends.
                if State.isStealing ~= true and LP:GetAttribute("Stealing") ~= true then
                    stopAutoPlay()
                end
                return
            end
            AutoPlay.wpIndex += 1
            State.autoPlayWPIndex = AutoPlay.wpIndex
            return
        end

        local dir = delta
        if dir.Magnitude > 0.001 then dir = dir.Unit end
        local speed = getAutoPlaySpeed(AutoPlay.wpIndex) + 1
        if dXZ < 1.5 then speed = speed * math.clamp(dXZ / 1.5, 0.6, 1) end
        speed = math.min(speed, dXZ / math.max(dt or (1/60), 1/240))

        -- Match EclipseHub: horizontal velocity drives the route.
        root.Velocity = Vector3.new(dir.X * speed, root.Velocity.Y, dir.Z * speed)
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if AutoPlay.active and State.autoPlayMode == "Auto" then startAutoPlay() end
end)

UI.addCleanup(function()
    AutoPlay.alive = false
    stopAutoPlay()
end)


-- ========================================================================
-- ANTI RAGDOLL: OFF / ORIGINAL NORMAL (V1) / Unpatched Old Anti rag (V2).
-- V1 stays on RenderStepped. V2 uses the donor Heartbeat + 0.15s reset gate.
-- The old V2 constraint-destruction/attribute/yaw reset is not used by V2.
-- ========================================================================
local Ragdoll = {alive = true, open = false, cameraRecord = nil,
    generation = 0, lastReset = 0, resetBusy = false}
do
    local function releaseCamera()
        local record = Ragdoll.cameraRecord
        Ragdoll.cameraRecord = nil
        if record then
            pcall(function()
                if record.camera.CameraSubject == record.humanoid then record.camera.CameraSubject = record.previous end
            end)
        end
    end
    local function bindCamera(humanoid)
        local camera = workspace.CurrentCamera
        if not camera then return end
        local record = Ragdoll.cameraRecord
        if not record or record.camera ~= camera or record.humanoid ~= humanoid then
            releaseCamera()
            Ragdoll.cameraRecord = {camera = camera, humanoid = humanoid, previous = camera.CameraSubject}
        end
        camera.CameraSubject = humanoid
    end
    local function removeConstraintsV1(character)
        for _, item in ipairs(character:GetDescendants()) do
            if item:IsA("BallSocketConstraint") or (item:IsA("Attachment") and item.Name:find("RagdollAttachment")) then
                pcall(function() item:Destroy() end)
            end
        end
    end
    local function isDonorRagdoll(state)
        return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
    end
    function Ragdoll.resetV2(character, humanoid, root)
        local generation = Ragdoll.generation
        local function current()
            return Ragdoll.alive and State.antiRagdollMode == "Custom" and Ragdoll.generation == generation
                and LP.Character == character and character.Parent and humanoid.Parent and root.Parent and humanoid.Health > 0
        end
        if not current() or Ragdoll.resetBusy then return end
        Ragdoll.resetBusy = true
        local ok, err = pcall(function()
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
            -- Deprecated and current velocity properties are both in the donor.
            pcall(function() root.Velocity = Vector3.zero; root.RotVelocity = Vector3.zero end)
            root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
            for _, object in ipairs(character:GetDescendants()) do
                if object:IsA("Motor6D") or object:IsA("Constraint") then
                    pcall(function() object.Enabled = true end)
                end
            end
            bindCamera(humanoid)
            local playerScripts = LP:FindFirstChild("PlayerScripts")
            local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
            local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
            if controlModule then
                local loaded, controls = pcall(require, controlModule)
                if not current() then return end
                if loaded and controls and type(controls.Enable) == "function" then
                    pcall(function() controls:Enable() end)
                end
            end
            if not current() then return end
            humanoid.AutoRotate = true
            humanoid.PlatformStand = false
            humanoid.Sit = false
        end)
        if Ragdoll.generation == generation then
            Ragdoll.resetBusy = false
            if not ok then warn("[M10RU Duels Anti Ragdoll V2] " .. tostring(err)) end
        end
    end
    function Ragdoll.step()
        if not Ragdoll.alive or State.antiRagdollMode == "Off" then return end
        local character, humanoid, root = getCharData()
        if not character or not humanoid or not root or not humanoid.Parent or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        if State.antiRagdollMode == "Custom" then
            if isDonorRagdoll(state) then
                local now = tick()
                if not Ragdoll.resetBusy and now - Ragdoll.lastReset > 0.15 then
                    Ragdoll.lastReset = now
                    Ragdoll.resetV2(character, humanoid, root)
                end
            end
            return
        end
        -- Original V1 behavior, preserved separately.
        local ragdolled = isRagdollState(humanoid)
        local endTime = LP:GetAttribute("RagdollEndTime")
        if not ragdolled and type(endTime) == "number" then ragdolled = endTime > workspace:GetServerTimeNow() end
        if not ragdolled then return end
        removeConstraintsV1(character)
        pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
        humanoid.PlatformStand = false
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        pcall(function() humanoid:ChangeState(Enum.HumanoidStateType.Running) end)
        root.Anchored = false
        root.AssemblyLinearVelocity, root.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        bindCamera(humanoid)
    end
    function Ragdoll.refresh()
        if Ragdoll.refreshUI then Ragdoll.refreshUI() end
    end
    function Ragdoll.setMode(mode)
        if not Ragdoll.alive or (mode ~= "Off" and mode ~= "Normal" and mode ~= "Custom") then return end
        if State.antiRagdollMode == mode and (mode == "Off" or Conns.antiRag) then Ragdoll.refresh(); return end
        Ragdoll.generation += 1
        if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end
        releaseCamera()
        Ragdoll.resetBusy, Ragdoll.lastReset = false, 0
        State.antiRagdollMode, State.antiRagdollEnabled = mode, mode ~= "Off"
        if mode == "Normal" then Conns.antiRag = RunService.RenderStepped:Connect(Ragdoll.step)
        elseif mode == "Custom" then Conns.antiRag = RunService.Heartbeat:Connect(Ragdoll.step) end
        Ragdoll.refresh()
    end
    function Ragdoll.destroy()
        if not Ragdoll.alive then return end
        Ragdoll.setMode("Off")
        Ragdoll.alive = false
    end
    UI.addCleanup(Ragdoll.destroy)
end
local function startAntiRagdoll()
    Ragdoll.setMode(State.antiRagdollMode ~= "Off" and State.antiRagdollMode or "Normal")
end
local function stopAntiRagdoll() Ragdoll.setMode("Off") end

-- ========================================================================
-- INFINITE JUMP
-- ========================================================================
UserInputService.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    local char, hum, root = getCharData()
    if root then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

RunService.Heartbeat:Connect(function()
    if not State.infJumpEnabled then return end
    local char, hum, root = getCharData()
    if not root or not hum then return end
    
    if State.infJumpMode == "hold" then
        local jumpHeld = UserInputService:IsKeyDown(Enum.KeyCode.Space) or hum.Jump == true
        if jumpHeld and root.Velocity.Y < 30 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    elseif State.infJumpMode == "manual" then
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) and root.Velocity.Y < 30 then
            root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
        end
    end
    if root.Velocity.Y < -120 then
        root.Velocity = Vector3.new(root.Velocity.X, -120, root.Velocity.Z)
    end
end)

-- ========================================================================
-- UNWALK & DROP & TP FLOOR
-- ========================================================================
local unwalkSavedAnimate = nil
local function startUnwalk()
    -- Unwalk is visual/animation-only. Do not cancel Auto Switch Carry here:
    -- when a real steal prompt/carry is detected it must still use Carry Speed.
    Speed.suspend()

    local char, hum, root = getCharData()
    if root then
        local velocity = root.AssemblyLinearVelocity
        root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
    end
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop() end)
        end
    end
    if char then
        local anim = char:FindFirstChild("Animate")
        if anim then
            unwalkSavedAnimate = anim:Clone()
            anim:Destroy()
        end
    end
end

local function stopUnwalk()
    local char = LP.Character
    if char and unwalkSavedAnimate then
        unwalkSavedAnimate:Clone().Parent = char
        unwalkSavedAnimate = nil
    end
end

local function runDrop()
    if State.dropActive then return end
    if State.autoBatEnabled then Combat.stopGood() end
    local char, hum, root = getCharData()
    if not root then return end
    
    State.dropActive = true
    local startTime = tick()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local c, h, r = getCharData()
        if not r then
            conn:Disconnect()
            State.dropActive = false
            return
        end
        if tick() - startTime >= State.DROP_ASCEND_DURATION then
            conn:Disconnect()
            local rp = RaycastParams.new()
            rp.FilterDescendantsInstances = {c}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rayResult = workspace:Raycast(r.Position, Vector3.new(0, -2000, 0), rp)
            if rayResult then
                local hum2 = c:FindFirstChildOfClass("Humanoid")
                local offset = (hum2 and hum2.HipHeight or 2) + (r.Size.Y / 2)
                r.CFrame = CFrame.new(r.Position.X, rayResult.Position.Y + offset, r.Position.Z)
                r.AssemblyLinearVelocity = Vector3.zero
            end
            State.dropActive = false
            return
        end
        r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, State.DROP_ASCEND_SPEED, r.AssemblyLinearVelocity.Z)
    end)
end

local function doAutoTPDown(force)
    local char, hum, hrp = getCharData()
    if not hrp or not hum then return end
    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if hrp.Position.Y < State.autoTPHeight then return end
    end
    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {char}
    rp.FilterType = Enum.RaycastFilterType.Exclude
    local ray = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rp)
    local targetY = ray and (ray.Position.Y + (hum.HipHeight or 2) + 1.5) or 2.5
    hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z) * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
    hrp.AssemblyLinearVelocity = Vector3.zero
end

local function startAutoTP()
    if Conns.autoTP then task.cancel(Conns.autoTP); Conns.autoTP = nil end
    Conns.autoTP = task.spawn(function()
        while State.autoTPEnabled do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
    end)
end

local function stopAutoTP()
    State.autoTPEnabled = false
    if Conns.autoTP then task.cancel(Conns.autoTP); Conns.autoTP = nil end
end

local function runTPFloor()
    pcall(function() doAutoTPDown(true) end)
end


-- ========================================================================
-- HORIZON ANIMATION PACK PORT
-- Local Animate-object replacement only: all Horizon pack IDs, Unwalk and
-- Hit Harder mappings are retained. No Horizon GUI, network, movement, target,
-- remote-event or loader behavior is included.
-- ========================================================================
local HORIZON_ANIMATION_PACK_LIST = {
    "OFF",
    "Unwalk",
    "Hit Harder",
    "Crazy",
    "Adidas Sports",
    "Adidas Community",
    "Adidas Aura",
    "Wicked Popular",
    "Elder",
    "Zombie",
    "Mage",
    "Catwalk Glam",
    "Astronaut",
    "Wicked \"Dancing Through Life\"",
    "Werewolf",
    "Superhero",
    "Toy",
    "No Boundaries",
    "NFL",
    "Amazon Unboxed",
    "Vampire",
    "Ninja",
    "Robot",
    "Levitation",
    "Stylish",
    "Bubbly",
    "Cartoon"
}
local HORIZON_ANIMATION_PACKS = {
    ["Crazy"] = {
        WalkAnim = 134824450619865,
        RunAnim = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 121454505477205,
        Swim = 121454505477205,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
        ClimbAnim = 121454505477205,
    },
    ["Adidas Sports"] = {
        WalkAnim = 18537392113,
        RunAnim  = 18537384940,
        JumpAnim = 18537380791,
        FallAnim = 18537367238,
        SwimIdle = 18537387180,
        Swim     = 18537389531,
        Animation1 = 18537376492,
        Animation2 = 18537371272,
        ClimbAnim = 18537363391,
    },
    ["Adidas Community"] = {
        WalkAnim = 122150855457006,
        RunAnim  = 82598234841035,
        JumpAnim = 75290611992385,
        FallAnim = 98600215928904,
        SwimIdle = 109346520324160,
        Swim     = 133308483266208,
        Animation1 = 122257458498464,
        Animation2 = 102357151005774,
        ClimbAnim = 88763136693023,
    },
    ["Adidas Aura"] = {
        WalkAnim = 83842218823011,
        RunAnim  = 118320322718866,
        JumpAnim = 109996626521204,
        FallAnim = 95603166884636,
        SwimIdle = 94922130551805,
        Swim     = 134530128383903,
        Animation1 = 110211186840347,
        Animation2 = 114191137265065,
        ClimbAnim = 97824616490448,
    },
    ["Wicked Popular"] = {
        WalkAnim = 92072849924640,
        RunAnim = 72301599441680,
        JumpAnim = 104325245285198,
        FallAnim = 121152442762481,
        Animation1 = 118832222982049,
        ClimbAnim = 131326830509784,
        SwimIdle = 113199415118199,
        Swim = 99384245425157,
        Animation2 = 76049494037641,
    },
    Elder = {
        WalkAnim = 10921111375,
        RunAnim  = 10921104374,
        JumpAnim = 10921107367,
        FallAnim = 10921105765,
        SwimIdle = 10921110146,
        Swim     = 10921108971,
        ClimbAnim = 10921100400,
        Animation1 = 10921101664,
        Animation2 = 10921102574,
    },
    Zombie = {
        WalkAnim = 10921355261,
        RunAnim  = 616163682,
        JumpAnim = 10921351278,
        FallAnim = 10921350320,
        SwimIdle = 10921353442,
        Swim     = 10921352344,
        Animation1 = 10921344533,
        Animation2 = 10921345304,
        ClimbAnim = 10921343576,
    },
    Mage = {
        WalkAnim = 10921152678,
        RunAnim  = 10921148209,
        JumpAnim = 10921149743,
        FallAnim = 10921148939,
        SwimIdle = 10921151661,
        Swim     = 10921150788,
        ClimbAnim = 10921143404,
        Animation1 = 10921144709,
        Animation2 = 10921145797,
    },
    ["Catwalk Glam"] = {
        WalkAnim = 109168724482748,
        RunAnim  = 81024476153754,
        JumpAnim = 116936326516985,
        FallAnim = 92294537340807,
        SwimIdle = 98854111361360,
        Swim     = 134591743181628,
        ClimbAnim = 119377220967554,
        Animation1 = 133806214992291,
        Animation2 = 94970088341563,
    },
    Astronaut = {
        WalkAnim = 10921046031,
        RunAnim  = 10921039308,
        JumpAnim = 10921042494,
        FallAnim = 10921040576,
        SwimIdle = 10921045006,
        Swim     = 10921044000,
        ClimbAnim = 10921032124,
        Animation1 = 10921034824,
        Animation2 = 10921036806,
    },
    ['Wicked "Dancing Through Life"'] = {
        WalkAnim = 73718308412641,
        RunAnim  = 135515454877967,
        JumpAnim = 78508480717326,
        FallAnim = 78147885297412,
        SwimIdle = 129183123083281,
        Swim     = 110657013921774,
        ClimbAnim = 129447497744818,
        Animation1 = 92849173543269,
        Animation2 = 132238900951109,
    },
    Werewolf = {
        WalkAnim = 10921342074,
        RunAnim  = 10921336997,
        JumpAnim = nil,
        FallAnim = 10921337907,
        SwimIdle = 10921341319,
        Swim     = 10921340419,
        ClimbAnim = 10921329322,
        Animation1 = 10921330408,
        Animation2 = 10921333667,
    },
    Superhero = {
        WalkAnim = 10921298616,
        RunAnim  = 10921291831,
        JumpAnim = 10921294559,
        FallAnim = 10921293373,
        SwimIdle = 10921297391,
        Swim     = 10921295495,
        ClimbAnim = 10921286911,
        Animation1 = 10921288909,
        Animation2 = 10921290167,
    },
    Toy = {
        WalkAnim = 10921312010,
        RunAnim  = 10921306285,
        JumpAnim = 10921308158,
        FallAnim = 10921307241,
        SwimIdle = 10921310341,
        Swim     = 10921309319,
        ClimbAnim = 10921300839,
        Animation1 = 10921301576,
        Animation2 = nil,
    },
    ["No Boundaries"] = {
        WalkAnim = 18747074203,
        RunAnim  = 18747070484,
        JumpAnim = 18747069148,
        FallAnim = 18747062535,
        SwimIdle = 18747071682,
        Swim     = 18747073181,
        ClimbAnim = 18747060903,
        Animation1 = 18747067405,
        Animation2 = 18747063918,
    },
    NFL = {
        WalkAnim = 110358958299415,
        RunAnim  = 117333533048078,
        JumpAnim = 119846112151352,
        FallAnim = 129773241321032,
        SwimIdle = 79090109939093,
        Swim     = 132697394189921,
        ClimbAnim = 134630013742019,
        Animation1 = 92080889861410,
        Animation2 = 74451233229259,
    },
    ["Amazon Unboxed"] = {
        WalkAnim = 90478085024465,
        RunAnim  = 134824450619865,
        JumpAnim = 121454505477205,
        FallAnim = 94788218468396,
        SwimIdle = 129126268464847,
        Swim     = 105962919001086,
        ClimbAnim = 121145883950231,
        Animation1 = 98281136301627,
        Animation2 = nil,
    },
    Vampire = {
        WalkAnim = 10921326949,
        RunAnim  = 10921320299,
        JumpAnim = 10921322186,
        FallAnim = 10921321317,
        SwimIdle = 10921325443,
        Swim     = 10921324408,
        ClimbAnim = 10921314188,
        Animation1 = 10921315373,
        Animation2 = nil,
    },
    Ninja = {
        Run=656118852, Walk=656121766, Jump=656117878, Fall=656115606,
        Swim=656119721, SwimIdle=656121397, Climb=656114359,
        Idle={656117400,656118341,886742569}
    },
    Robot = {
        Run=616091570, Walk=616095330, Jump=616090535, Fall=616087089,
        Swim=616092998, SwimIdle=616094091, Climb=616086039,
        Idle={616088211,616089559,885531463}
    },
    Levitation = {
        Run=616010382, Walk=616013216, Jump=616008936, Fall=616005863,
        Swim=616011509, SwimIdle=616012453, Climb=616003713,
        Idle={616006778,616008087,886862142}
    },
    Stylish = {
        Run=616140816, Walk=616146177, Jump=616139451, Fall=616134815,
        Swim=616143378, SwimIdle=616144772, Climb=616133594,
        Idle={616136790,616138447,886888594}
    },
    Bubbly = {
        Run=910025107, Walk=910034870, Jump=910016857, Fall=910001910,
        Swim=910028158, SwimIdle=910030921, Climb=909997997,
        Idle={910004836,910009958,1018536639}
    },
    Cartoon = {
        Run=742638842, Walk=742640026, Jump=742637942, Fall=742637151,
        Swim=742639220, SwimIdle=742639812, Climb=742636889,
        Idle={742637544,742638445,885477856}
    },
}

local AnimPack = {alive = true, selected = "OFF", originals = setmetatable({}, {__mode = "k"}), connections = {}}
do
    local HIT_HARDER = {
        idle1 = "rbxassetid://133806214992291", idle2 = "rbxassetid://94970088341563",
        walk = "rbxassetid://707897309", run = "rbxassetid://707861613",
        jump = "rbxassetid://116936326516985", fall = "rbxassetid://116936326516985",
    }

    local function isKnownPack(name)
        return type(name) == "string" and table.find(HORIZON_ANIMATION_PACK_LIST, name) ~= nil
    end
    local function getAnimate(character)
        return character and character:FindFirstChild("Animate") or nil
    end
    local function stopTracks(character)
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end
    local function rememberOriginal(character)
        if not character or AnimPack.originals[character] then return end
        local animate = getAnimate(character)
        if animate then AnimPack.originals[character] = animate:Clone() end
    end
    local function refreshAnimate(animate)
        if not animate then return end
        pcall(function()
            animate.Disabled = true
            task.wait(0.03)
            if animate.Parent then animate.Disabled = false end
        end)
    end
    local function restoreOriginal(character)
        if not character then return end
        local original = AnimPack.originals[character]
        if not original then return end
        stopTracks(character)
        local current = getAnimate(character)
        if current then current:Destroy() end
        local restored = original:Clone()
        restored.Parent = character
        refreshAnimate(restored)
    end
    local function setAnim(animation, id)
        if not animation or not id then return end
        local value = tostring(id)
        if not value:find("rbxassetid://", 1, true) then value = "rbxassetid://" .. value end
        pcall(function() animation.AnimationId = value end)
    end
    local function ensureAnimation(folder, name)
        if not folder then return nil end
        local animation = folder:FindFirstChild(name)
        if not animation then
            animation = Instance.new("Animation")
            animation.Name = name
            animation.Parent = folder
        end
        return animation
    end
    local function pick(pack, ...)
        for i = 1, select("#", ...) do
            local value = pack[select(i, ...)]
            if value ~= nil then return value end
        end
        return nil
    end
    local function releaseUnwalk()
        if AnimPack.selected == "Unwalk" and State.unwalkEnabled then
            stopUnwalk()
            State.unwalkEnabled = false
            if setUnwalkVisual then setUnwalkVisual(false) end
        end
    end
    local function applyHitHarder(character)
        local animate = getAnimate(character)
        if not animate then return end
        rememberOriginal(character)
        stopTracks(character)
        setAnim(animate.idle and animate.idle:FindFirstChild("Animation1"), HIT_HARDER.idle1)
        setAnim(animate.idle and animate.idle:FindFirstChild("Animation2"), HIT_HARDER.idle2)
        setAnim(animate.walk and animate.walk:FindFirstChild("WalkAnim"), HIT_HARDER.walk)
        setAnim(animate.run and animate.run:FindFirstChild("RunAnim"), HIT_HARDER.run)
        setAnim(animate.jump and animate.jump:FindFirstChild("JumpAnim"), HIT_HARDER.jump)
        setAnim(animate.fall and animate.fall:FindFirstChild("FallAnim"), HIT_HARDER.fall)
        refreshAnimate(animate)
    end
    local function applyDataPack(character, pack)
        local animate = getAnimate(character)
        if not animate or not pack then return end
        rememberOriginal(character)
        stopTracks(character)
        local run = ensureAnimation(animate:FindFirstChild("run"), "RunAnim")
        local walk = ensureAnimation(animate:FindFirstChild("walk"), "WalkAnim")
        local jump = ensureAnimation(animate:FindFirstChild("jump"), "JumpAnim")
        local fall = ensureAnimation(animate:FindFirstChild("fall"), "FallAnim")
        local climb = ensureAnimation(animate:FindFirstChild("climb"), "ClimbAnim")
        local swim = ensureAnimation(animate:FindFirstChild("swim"), "Swim")
        local swimIdle = ensureAnimation(animate:FindFirstChild("swimidle"), "SwimIdle")
        setAnim(walk, pick(pack, "WalkAnim", "Walk", "walk"))
        setAnim(run, pick(pack, "RunAnim", "Run", "run"))
        setAnim(jump, pick(pack, "JumpAnim", "Jump", "jump"))
        setAnim(fall, pick(pack, "FallAnim", "Fall", "fall"))
        setAnim(climb, pick(pack, "ClimbAnim", "Climb", "climb"))
        setAnim(swim, pick(pack, "Swim", "swim"))
        setAnim(swimIdle, pick(pack, "SwimIdle", "swimidle") or pick(pack, "Swim", "swim"))
        local idle = animate:FindFirstChild("idle")
        if idle then
            local first, second = pick(pack, "Animation1"), pick(pack, "Animation2")
            if first or second then
                local one = ensureAnimation(idle, "Animation1")
                local two = ensureAnimation(idle, "Animation2")
                setAnim(one, first or second)
                setAnim(two, second or first or second)
            elseif pack.Idle and #pack.Idle > 0 then
                local one = ensureAnimation(idle, "Animation1")
                local two = ensureAnimation(idle, "Animation2")
                setAnim(one, pack.Idle[1])
                setAnim(two, pack.Idle[2] or pack.Idle[1])
                for index = 3, #pack.Idle do setAnim(ensureAnimation(idle, "Animation" .. index), pack.Idle[index]) end
            end
        end
        refreshAnimate(animate)
    end

    function AnimPack.apply(name)
        if not AnimPack.alive then return end
        name = isKnownPack(name) and name or "OFF"
        local previous = AnimPack.selected
        if previous == "Unwalk" and name ~= "Unwalk" then releaseUnwalk() end
        AnimPack.selected, State.animPack = name, name
        local character = LP.Character
        if name == "OFF" then
            restoreOriginal(character)
        elseif name == "Unwalk" then
            restoreOriginal(character)
            State.unwalkEnabled = true
            if setUnwalkVisual then setUnwalkVisual(true) end
            startUnwalk()
        elseif name == "Hit Harder" then
            applyHitHarder(character)
        else
            applyDataPack(character, HORIZON_ANIMATION_PACKS[name])
        end
        if AnimPack.visual then AnimPack.visual(name) end
    end
    function AnimPack.destroy()
        if not AnimPack.alive then return end
        if AnimPack.selected == "Unwalk" then releaseUnwalk() end
        restoreOriginal(LP.Character)
        AnimPack.alive = false
        for _, connection in ipairs(AnimPack.connections) do connection:Disconnect() end
        table.clear(AnimPack.connections)
    end
    table.insert(AnimPack.connections, LP.CharacterAdded:Connect(function(character)
        task.delay(0.35, function()
            if AnimPack.alive and LP.Character == character and AnimPack.selected ~= "OFF" then
                AnimPack.apply(AnimPack.selected)
            end
        end)
    end))
    UI.addCleanup(AnimPack.destroy)
end

-- ========================================================================
-- CLEAN ANTI DIE: local health/death-state logic only.
-- No donor GUI, overhead text, hotkeys, images, config or external loader.
-- Local client protection is not a guarantee against server-authoritative death.
-- ========================================================================
AntiDie = {alive = true, generation = 0, connections = {},
    deathLocks = setmetatable({}, {__mode = "k"}), healing = false}
do
    local function disconnect(connection) if connection then connection:Disconnect() end end
    -- Both the existing aimbot and this toggle use the Dead state. Neither may
    -- restore it while the other still owns it; restore the original once last.
    function AntiDie.acquireDead(humanoid, owner)
        local record = AntiDie.deathLocks[humanoid]
        if not record then
            local original = true
            pcall(function() original = humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead) end)
            record = {original = original, owners = {}}
            AntiDie.deathLocks[humanoid] = record
        end
        record.owners[owner] = true
        pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
    end
    function AntiDie.releaseDead(humanoid, owner)
        local record = AntiDie.deathLocks[humanoid]
        if not record then return end
        record.owners[owner] = nil
        if next(record.owners) then
            pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        else
            AntiDie.deathLocks[humanoid] = nil
            pcall(function() humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, record.original) end)
        end
    end
    local function unprotect()
        local record = AntiDie.owner
        AntiDie.owner = nil
        AntiDie.healing = false
        if not record then return end
        for _, connection in ipairs(record.connections) do disconnect(connection) end
        -- Default Roblox health restores to 100 like the donor, but custom
        -- games retain their original MaxHealth rather than being forced to 100.
        pcall(function()
            record.humanoid.MaxHealth = record.maxHealth
            record.humanoid.Health = record.maxHealth
        end)
        AntiDie.releaseDead(record.humanoid, "toggle")
    end
    local function refill(record)
        if not AntiDie.alive or not State.antiDieEnabled or AntiDie.owner ~= record
            or not record.humanoid.Parent or AntiDie.healing then return end
        AntiDie.healing = true
        pcall(function()
            if record.humanoid.Health < record.humanoid.MaxHealth then record.humanoid.Health = math.huge end
        end)
        AntiDie.healing = false
    end
    function AntiDie.protectCharacter(character, generation)
        if not AntiDie.alive or not State.antiDieEnabled or LP.Character ~= character or not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
        if not humanoid or not AntiDie.alive or not State.antiDieEnabled or generation ~= AntiDie.generation
            or LP.Character ~= character or not character.Parent then return end
        if AntiDie.owner and AntiDie.owner.humanoid == humanoid then return end
        unprotect()
        local record = {humanoid = humanoid, character = character, maxHealth = humanoid.MaxHealth, connections = {}}
        AntiDie.owner = record
        AntiDie.acquireDead(humanoid, "toggle")
        pcall(function() humanoid.MaxHealth = math.huge; humanoid.Health = math.huge end)
        table.insert(record.connections, humanoid.StateChanged:Connect(function(_, state)
            if not AntiDie.alive or not State.antiDieEnabled or AntiDie.owner ~= record then return end
            if state == Enum.HumanoidStateType.Dead then
                pcall(function() humanoid.Health = math.huge end)
                AntiDie.acquireDead(humanoid, "toggle")
            end
        end))
        table.insert(record.connections, humanoid:GetPropertyChangedSignal("Health"):Connect(function() refill(record) end))
    end
    function AntiDie.refresh()
        if AntiDie.visual then AntiDie.visual(State.antiDieEnabled) end
    end
    function AntiDie.setEnabled(on)
        if not AntiDie.alive then return end
        on = on == true
        if State.antiDieEnabled == on and (not on or AntiDie.heartbeat) then AntiDie.refresh(); return end
        AntiDie.generation += 1
        State.antiDieEnabled = on
        for _, connection in ipairs(AntiDie.connections) do disconnect(connection) end
        table.clear(AntiDie.connections)
        disconnect(AntiDie.heartbeat); AntiDie.heartbeat = nil
        unprotect()
        if on then
            local generation = AntiDie.generation
            task.spawn(AntiDie.protectCharacter, LP.Character, generation)
            table.insert(AntiDie.connections, LP.CharacterRemoving:Connect(function()
                AntiDie.generation += 1
                unprotect()
            end))
            table.insert(AntiDie.connections, LP.CharacterAdded:Connect(function(character)
                local currentGeneration = AntiDie.generation
                task.delay(0.1, function() AntiDie.protectCharacter(character, currentGeneration) end)
            end))
            AntiDie.heartbeat = RunService.Heartbeat:Connect(function()
                local record = AntiDie.owner
                if record then refill(record) end
            end)
        end
        AntiDie.refresh()
    end
    function AntiDie.destroy()
        if not AntiDie.alive then return end
        AntiDie.setEnabled(false)
        AntiDie.alive = false
    end
    UI.addCleanup(AntiDie.destroy)
end


-- ========================================================================
-- INSTANT RESET: action shared by the UI and keybind.
-- It never puts the camera in Scriptable mode; the camera is always restored
-- to Custom and attached to the current/new humanoid.
-- ========================================================================
InstantReset = {
    alive = true, resetCooldown = false, lastResetAt = 0, generation = 0,
    respawnConn = nil, cameraConn = nil, connections = {},
}
do
    -- Reset must never use a Scriptable camera. Scriptable is what left the
    -- view parked at the old position whenever the character respawn event was
    -- delayed or cancelled by the game.
    local function disconnect(connection)
        if connection then pcall(function() connection:Disconnect() end) end
    end

    local function restoreCamera(character)
        local camera = workspace.CurrentCamera or Camera
        if not camera then return end
        Camera = camera
        local humanoid = character and (character:FindFirstChildOfClass("Humanoid")
            or character:FindFirstChild("Humanoid", true))
        pcall(function()
            camera.CameraType = Enum.CameraType.Custom
            if humanoid then camera.CameraSubject = humanoid end
        end)
    end

    local function finishReset(generation, character)
        if not InstantReset.alive or generation ~= InstantReset.generation then return end
        restoreCamera(character or LP.Character)
        disconnect(InstantReset.respawnConn)
        disconnect(InstantReset.cameraConn)
        InstantReset.respawnConn, InstantReset.cameraConn = nil, nil
        InstantReset.resetCooldown = false
    end

    function InstantReset.reset()
        -- Only block an accidental double-tap. Do not wait for CharacterAdded:
        -- some games delay/suppress it, which previously made the second reset
        -- look permanently disabled.
        if not InstantReset.alive or tick() - InstantReset.lastResetAt < 0.35 then return false end
        InstantReset.lastResetAt = tick()
        local character = LP.Character
        if not character then return false end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not humanoid then return false end

        InstantReset.resetCooldown = true
        InstantReset.generation += 1
        local generation = InstantReset.generation
        disconnect(InstantReset.respawnConn)
        disconnect(InstantReset.cameraConn)
        InstantReset.respawnConn, InstantReset.cameraConn = nil, nil

        -- Keep following the current character even if the reset never makes
        -- Roblox create a new one.
        restoreCamera(character)
        InstantReset.cameraConn = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            if InstantReset.alive and generation == InstantReset.generation then
                restoreCamera(LP.Character)
            end
        end)
        InstantReset.respawnConn = LP.CharacterAdded:Connect(function(newCharacter)
            task.delay(0.1, function()
                finishReset(generation, newCharacter)
            end)
        end)

        -- The existing launch action is retained. It no longer takes ownership
        -- of the camera, so the camera cannot become a fixed cinematic view.
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, 3e6, 0)
        end)
        task.defer(function()
            if InstantReset.alive and generation == InstantReset.generation then
                restoreCamera(LP.Character)
            end
        end)
        -- Re-enable the action after a short tap debounce rather than waiting
        -- for a respawn callback. The long camera failsafe remains independent.
        task.delay(0.35, function()
            if InstantReset.alive and generation == InstantReset.generation then
                InstantReset.resetCooldown = false
            end
        end)
        -- Failsafe for games that cancel the respawn or take too long to fire:
        -- restore normal camera control regardless.
        task.delay(1.5, function()
            finishReset(generation, LP.Character)
        end)
        return true
    end

    function InstantReset.stop()
        InstantReset.generation += 1
        disconnect(InstantReset.respawnConn)
        disconnect(InstantReset.cameraConn)
        InstantReset.respawnConn, InstantReset.cameraConn = nil, nil
        InstantReset.resetCooldown = false
        restoreCamera(LP.Character)
    end

    function InstantReset.destroy()
        if not InstantReset.alive then return end
        InstantReset.alive = false
        InstantReset.stop()
        for _, connection in ipairs(InstantReset.connections) do disconnect(connection) end
        table.clear(InstantReset.connections)
    end
    UI.addCleanup(InstantReset.destroy)
end

-- ========================================================================
-- COMBAT PROTECTION: Horizon Body Lock / Anti Fling / Instant Reset on Die.
-- Ports only local combat safety behaviour. No loaders, teleports or unrelated
-- Horizon features are included.
-- ========================================================================
local BodyLock = {alive = true, connection = nil}
do
    local function stop()
        if BodyLock.connection then BodyLock.connection:Disconnect(); BodyLock.connection = nil end
        local _, hum, root = getCharData()
        if hum then hum.AutoRotate = true end
        if root then root.AssemblyAngularVelocity = Vector3.zero end
    end

    local function step()
        if not BodyLock.alive or not State.bodyLockEnabled then return end
        local _, hum, root = getCharData()
        if not hum or not root or hum.Health <= 0 or State.tpBatEnabled then
            if hum then hum.AutoRotate = true end
            if root then root.AssemblyAngularVelocity = Vector3.zero end
            return
        end
        local target, distance = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
                if targetRoot and targetHum and targetHum.Health > 0 then
                    local d = (targetRoot.Position - root.Position).Magnitude
                    if d < distance then target, distance = targetRoot, d end
                end
            end
        end
        if not target or distance > State.bodyLockRange then
            hum.AutoRotate = true
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end
        -- Horizon prediction/yaw-force body lock.
        hum.AutoRotate = false
        local velocity = target.AssemblyLinearVelocity
        local predicted = target.Position + velocity * math.clamp(velocity.Magnitude / 80, 0.08, 0.35)
        local head = target.Parent and target.Parent:FindFirstChild("Head")
        local targetY = head and head.Position.Y or target.Position.Y
        local correction = math.clamp((targetY - (root.Position.Y + (hum.HipHeight or 0))) * 0.15, -1.5, 1.5)
        local flat = Vector3.new(predicted.X, root.Position.Y + correction, predicted.Z)
        if (flat - root.Position).Magnitude > 0.1 then
            local goal = CFrame.lookAt(root.Position, flat)
            local diff = root.CFrame:Inverse() * goal
            local _, yaw = diff:ToEulerAnglesXYZ()
            yaw = math.clamp(yaw, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(0, yaw * 42, 0))
        end
    end

    function BodyLock.setEnabled(on)
        on = on == true
        State.bodyLockEnabled = on
        stop()
        if on then BodyLock.connection = RunService.RenderStepped:Connect(step) end
        if BodyLock.visual then BodyLock.visual(on) end
    end
    function BodyLock.destroy()
        if not BodyLock.alive then return end
        BodyLock.setEnabled(false)
        BodyLock.alive = false
    end
    LP.CharacterAdded:Connect(function()
        task.delay(0.2, function()
            if BodyLock.alive and State.bodyLockEnabled then BodyLock.setEnabled(true) end
        end)
    end)
    UI.addCleanup(BodyLock.destroy)
end

local AntiFling = {alive = true, connection = nil, fixing = false, untilAt = 0}
do
    function AntiFling.step()
        if not AntiFling.alive or not State.antiFlingEnabled or State.tpBatEnabled or State.dropActive then
            AntiFling.fixing = false
            return
        end
        local _, _, root = getCharData()
        if not root then return end
        -- Horizon thresholds: cancel a strong linear/angular fling for 0.15s.
        if AntiFling.fixing then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            if os.clock() >= AntiFling.untilAt then AntiFling.fixing = false end
        elseif root.AssemblyLinearVelocity.Magnitude >= 140 or root.AssemblyAngularVelocity.Magnitude >= 90 then
            AntiFling.fixing = true
            AntiFling.untilAt = os.clock() + 0.15
        end
    end
    function AntiFling.setEnabled(on)
        State.antiFlingEnabled = on == true
        AntiFling.fixing = false
        if AntiFling.visual then AntiFling.visual(State.antiFlingEnabled) end
    end
    function AntiFling.destroy()
        if not AntiFling.alive then return end
        AntiFling.alive = false
        if AntiFling.connection then AntiFling.connection:Disconnect(); AntiFling.connection = nil end
    end
    AntiFling.connection = RunService.Heartbeat:Connect(AntiFling.step)
    UI.addCleanup(AntiFling.destroy)
end

local DeathReset = {
    alive = true, enabled = false, connections = {}, monitor = nil,
    resetThread = nil, resetCooldown = false, resetStop = false, lastAt = 0,
    activeCharacter = nil, activeHumanoid = nil, originalHipHeight = nil
}
do
    local RESET_STEP, MAX_ATTEMPTS = 0.05, 40

    local function disconnectAll()
        for _, connection in ipairs(DeathReset.connections) do connection:Disconnect() end
        table.clear(DeathReset.connections)
    end
    local function restoreCamera(character)
        local camera = workspace.CurrentCamera or Camera
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if camera then
            pcall(function()
                -- Keep the prior M10RU reset fix: never leave the client in
                -- Scriptable/camera-lock mode after a death reset.
                camera.CameraType = Enum.CameraType.Custom
                if humanoid then camera.CameraSubject = humanoid end
            end)
        end
    end
    local function restoreParts(character, humanoid, originalHipHeight)
        if not character then return end
        pcall(function()
            if humanoid and humanoid.Parent then humanoid.HipHeight = originalHipHeight end
            for _, part in ipairs(character:GetChildren()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end)
    end

    -- Local adaptation of Horizon's Nexus/Lord reset path: collision strip,
    -- repeated giant HipHeight reset, then a Health=0 fallback after 40 passes.
    -- It does not load anything or change server state except the local humanoid.
    local function resetPlayer()
        if not DeathReset.alive or not DeathReset.enabled or DeathReset.resetCooldown then return end
        DeathReset.resetCooldown = true
        DeathReset.resetStop = false
        DeathReset.lastAt = tick()

        -- Anti Die captures/replaces death signals. Horizon turns it off before
        -- a reset; retain that explicit conflict handling in this architecture.
        if State.antiDieEnabled then
            AntiDie.setEnabled(false)
            if AntiDie.visual then AntiDie.visual(false) end
        end

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not humanoid then
            DeathReset.resetCooldown = false
            restoreCamera(LP.Character)
            return
        end
        local originalHipHeight = humanoid.HipHeight
        DeathReset.activeCharacter = character
        DeathReset.activeHumanoid = humanoid
        DeathReset.originalHipHeight = originalHipHeight
        local succeeded = false
        DeathReset.resetThread = task.spawn(function()
            local attempts = 0
            while DeathReset.alive and DeathReset.enabled and not DeathReset.resetStop
                and character.Parent and LP.Character == character
                and humanoid.Parent and humanoid.Health > 0 do
                pcall(function()
                    humanoid.HipHeight = 1e30
                    humanoid.AutoRotate = true
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end)
                attempts += 1
                if attempts >= MAX_ATTEMPTS then break end
                task.wait(RESET_STEP)
            end

            if not DeathReset.resetStop and character.Parent and LP.Character == character
                and humanoid.Parent and humanoid.Health > 0 then
                pcall(function() humanoid.Health = 0 end)
                task.wait(0.1)
            end
            succeeded = (not character.Parent) or LP.Character ~= character or humanoid.Health <= 0
            if not succeeded then restoreParts(character, humanoid, originalHipHeight) end
            DeathReset.activeCharacter, DeathReset.activeHumanoid, DeathReset.originalHipHeight = nil, nil, nil
            DeathReset.resetThread = nil
            DeathReset.resetCooldown = false
            DeathReset.resetStop = false
            restoreCamera(LP.Character)
        end)
    end

    local function onDeath(character)
        if not DeathReset.alive or not DeathReset.enabled or tick() - DeathReset.lastAt < 0.10 then return end
        -- The exact Horizon automatic trigger is a dead/absent character. This
        -- call also restores client camera ownership immediately during respawn.
        restoreCamera(character)
        resetPlayer()
    end
    local function bindCharacter(character)
        disconnectAll()
        if not DeathReset.enabled or not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
        if not humanoid or not DeathReset.enabled then return end
        table.insert(DeathReset.connections, humanoid.Died:Connect(function() onDeath(character) end))
        table.insert(DeathReset.connections, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if humanoid.Health <= 0 then onDeath(character) end
        end))
    end
    local function startMonitor()
        if DeathReset.monitor then return end
        DeathReset.monitor = task.spawn(function()
            local absentCooldown = 0
            while DeathReset.alive and DeathReset.enabled do
                task.wait(0.1)
                local character = LP.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if not character then
                    if tick() - absentCooldown > 2 then
                        absentCooldown = tick()
                        resetPlayer()
                    end
                elseif humanoid and humanoid.Health <= 0 then
                    onDeath(character)
                end
            end
            DeathReset.monitor = nil
        end)
    end
    local function stopSequence()
        DeathReset.resetStop = true
        if DeathReset.resetThread then pcall(task.cancel, DeathReset.resetThread); DeathReset.resetThread = nil end
        -- Cleanup if the toggle is turned off halfway through a HipHeight pass.
        restoreParts(DeathReset.activeCharacter, DeathReset.activeHumanoid, DeathReset.originalHipHeight)
        DeathReset.activeCharacter, DeathReset.activeHumanoid, DeathReset.originalHipHeight = nil, nil, nil
        DeathReset.resetCooldown = false
        restoreCamera(LP.Character)
    end
    function DeathReset.setEnabled(on)
        DeathReset.enabled = on == true
        State.instantResetOnDieEnabled = DeathReset.enabled
        disconnectAll()
        stopSequence()
        if DeathReset.enabled then
            if State.antiDieEnabled then
                AntiDie.setEnabled(false)
                if AntiDie.visual then AntiDie.visual(false) end
            end
            bindCharacter(LP.Character)
            startMonitor()
        end
        if DeathReset.visual then DeathReset.visual(DeathReset.enabled) end
    end
    function DeathReset.destroy()
        if not DeathReset.alive then return end
        DeathReset.setEnabled(false)
        DeathReset.alive = false
    end
    LP.CharacterAdded:Connect(function(character)
        task.delay(0.1, function()
            if not DeathReset.alive then return end
            stopSequence()
            restoreCamera(character)
            if DeathReset.enabled then bindCharacter(character) end
        end)
    end)
    UI.addCleanup(DeathReset.destroy)
end

-- ========================================================================
-- HORIZON AUTO SWING PORT
-- Horizon's swingCurrentBat() is called on every RenderStepped pass and only
-- activates a Bat/Slap Tool when it is already equipped in the character.
-- This independent controller preserves that timing/strength without importing
-- Horizon's unrelated Aimbot target, movement, remote-event or loader code.
-- ========================================================================
local AutoSwing = {alive = true, connection = nil}
do
    local function findEquippedBat(character)
        if not character then return nil end
        for _, tool in ipairs(character:GetChildren()) do
            local name = tool.Name:lower()
            if tool:IsA("Tool") and (name:find("bat") or name:find("slap")) then
                return tool
            end
        end
        return nil
    end

    function AutoSwing.step()
        if not AutoSwing.alive or not State.autoSwingEnabled then return end
        if Combat.good and Combat.good.alive and Combat.good.enabled and State.autoBatEnabled then return end
        local character = LP.Character
        -- Exact effective Horizon swing behavior: equipped tool only, no delay
        -- or artificial cooldown between RenderStepped activations.
        local bat = findEquippedBat(character)
        if bat and bat.Parent == character and bat:IsA("Tool") then
            pcall(function() bat:Activate() end)
        end
    end
    function AutoSwing.setEnabled(on)
        State.autoSwingEnabled = on == true
        if setAutoSwingVisual then setAutoSwingVisual(State.autoSwingEnabled) end
    end
    function AutoSwing.destroy()
        if not AutoSwing.alive then return end
        AutoSwing.alive = false
        State.autoSwingEnabled = false
        if AutoSwing.connection then AutoSwing.connection:Disconnect(); AutoSwing.connection = nil end
    end
    AutoSwing.connection = RunService.RenderStepped:Connect(AutoSwing.step)
    UI.addCleanup(AutoSwing.destroy)
end

-- ========================================================================
-- DONOR COMBAT ENGINE: good.aimbot.txt (Insta Reset is a separate action).
-- Existing hub controls call these APIs; superseded motion loops are removed.
-- ========================================================================
do
    local G = {alive = true, enabled = false, generation = 0, connections = {}, antiDie = {},
        speed = 56.5, meleeOffset = 2, autoDropBrainrot = true, highlightEnabled = true}
    Combat.good = G

    local slapNames = {"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap", "Ruby Slap",
        "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap"}
    local function disconnect(connection) if connection then connection:Disconnect() end end
    local function findGoodBat()
        local char = LP.Character
        if not char then return nil end
        local backpack = LP:FindFirstChildOfClass("Backpack")
        for _, container in ipairs(backpack and {char, backpack} or {char}) do
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
            end
        end
        for _, name in ipairs(slapNames) do
            local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
            if tool then return tool end
        end
    end
    -- Shared utility for the unchanged Bat Counter feature, not an aim engine.
    function Combat.swingCounter()
        local char, hum = getCharData()
        if not char or not hum then return end
        local bat = findGoodBat()
        if not bat then return end
        if bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
        local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
        if remote and remote:IsA("RemoteEvent") then pcall(function() remote:FireServer() end)
        else pcall(function() bat:Activate() end) end
    end

    -- good.aimbot: locked target, speed 56.5, prediction /150 (0.05..0.2),
    -- 2-stud behind offset, +2.6 height, -15 degree pitch, optional jump-drop.
    -- Repair the previous version's unscoped workspace highlight only.
    -- Never remove highlights belonging to the game or to other scripts.
    for _, effect in ipairs(workspace:GetChildren()) do
        if effect:IsA("Highlight") and effect.Name == "M10RUAimbotTarget" then
            effect.Enabled = false
            effect:Destroy()
        elseif effect:IsA("Folder") and effect.Name == "M10RUDuelsEffects"
            and effect:GetAttribute("M10RUDuelsOwned") == true then
            effect:Destroy()
        end
    end
    G.effects = Instance.new("Folder")
    G.effects.Name = "M10RUDuelsEffects"
    G.effects:SetAttribute("M10RUDuelsOwned", true)
    G.effects.Parent = workspace
    G.highlight = Instance.new("Highlight")
    -- Highlight defaults to its parent when Adornee is nil. Disable it BEFORE
    -- parenting and use a geometry-free holder, NEVER Workspace as its parent.
    G.highlight.Enabled = false
    G.highlight.Name = "M10RUAimbotTarget"
    G.highlight.FillColor, G.highlight.OutlineColor = UI.theme.accent, UI.theme.light
    G.highlight.FillTransparency, G.highlight.OutlineTransparency = 0.5, 0
    G.highlight.Adornee = nil
    G.highlight.Parent = G.effects
    function G.setHighlightTarget(character)
        local valid = G.alive and G.enabled and State.autoBatEnabled and G.highlightEnabled
            and typeof(character) == "Instance" and character ~= workspace and character ~= LP.Character
            and character:IsA("Model") and character.Parent ~= nil
            and character:FindFirstChildOfClass("Humanoid") and character:FindFirstChild("HumanoidRootPart")
        if not valid then character = nil end
        if G.highlightTarget ~= character then
            disconnect(G.highlightTargetGone)
            G.highlightTargetGone = nil
            G.highlightTarget = character
            if character then
                G.highlightTargetGone = character.Destroying:Connect(function()
                    if G.highlightTarget == character then G.setHighlightTarget(nil) end
                end)
            end
        end
        if character then
            if G.highlight.Adornee ~= character then
                G.highlight.Enabled = false
                G.highlight.Adornee = character
            end
            G.highlight.Enabled = true
        else
            G.highlight.Enabled = false
            G.highlight.Adornee = nil
        end
    end
    -- Printed V1 target selection: choose the closest living player's HumanoidRootPart
    -- on every RenderStepped update (no sticky target lock).
    local function getGoodTarget(root)
        local bestPart, bestCharacter, bestDistance = nil, nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local character = player.Character
                local part = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if part and humanoid and humanoid.Health > 0 then
                    local distance = (part.Position - root.Position).Magnitude
                    if distance < bestDistance then
                        bestPart, bestCharacter, bestDistance = part, character, distance
                    end
                end
            end
        end
        return bestPart, bestCharacter
    end
    local function restoreGoodOwner()
        for _, connection in ipairs(G.antiDie) do disconnect(connection) end
        table.clear(G.antiDie)
        if G.owner then
            local owner = G.owner
            pcall(function()
                owner.humanoid.BreakJointsOnDeath = owner.breakJoints
                AntiDie.releaseDead(owner.humanoid, "aimbot")
                owner.humanoid.AutoRotate = owner.autoRotate
                if G.dropping then owner.humanoid.Jump = false end
            end)
            pcall(function() owner.root.AssemblyLinearVelocity = Vector3.zero end)
        end
        G.owner, G.dropping = nil, false
    end
    local function bindGood(humanoid, root)
        if G.owner and G.owner.humanoid == humanoid then return end
        restoreGoodOwner()
        local enabled = true
        pcall(function() enabled = humanoid:GetStateEnabled(Enum.HumanoidStateType.Dead) end)
        G.owner = {humanoid = humanoid, root = root, breakJoints = humanoid.BreakJointsOnDeath,
            deadEnabled = enabled, autoRotate = humanoid.AutoRotate}
        humanoid.BreakJointsOnDeath = false
        AntiDie.acquireDead(humanoid, "aimbot")
        table.insert(G.antiDie, humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if G.alive and G.enabled and State.autoBatEnabled and G.owner and G.owner.humanoid == humanoid and humanoid.Health <= 0 then
                humanoid.Health = humanoid.MaxHealth
            end
        end))
    end
    local function holdingBrainrot(char)
        for _, tool in ipairs(char:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if not name:find("bat") and not name:find("slap") and not name:find("medusa") then return true end
            end
        end
        return false
    end
    -- Printed V1 Aimbot movement logic, transplanted to M10RU's existing toggle/UI.
    -- Target selection, prediction, velocity and angular movement mirror Printed V1.
    -- This V1 mode does not set Humanoid.Jump or run an automatic jump/drop routine.
    G.savedAutoRotate = nil
    function G.step()
        if not G.alive or not G.enabled or not State.autoBatEnabled then
            G.setHighlightTarget(nil)
            return
        end

        local character = LP.Character
        if not character then G.setHighlightTarget(nil); return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then
            G.setHighlightTarget(nil)
            return
        end

        if G.savedAutoRotate == nil then G.savedAutoRotate = humanoid.AutoRotate end
        humanoid.AutoRotate = false

        if not character:FindFirstChildOfClass("Tool") then
            local bat = findGoodBat()
            if bat then pcall(function() humanoid:EquipTool(bat) end) end
        end

        local target, targetCharacter = getGoodTarget(root)
        if not target or not target.Parent or not targetCharacter or not targetCharacter.Parent then
            G.setHighlightTarget(nil)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            return
        end

        G.setHighlightTarget(targetCharacter)
        local targetVelocity = target.AssemblyLinearVelocity
        local position = root.Position
        local targetPosition = target.Position
        local offset = targetPosition + targetVelocity * 0.14 + target.CFrame.LookVector * 0.3 - position
        local horizontal = Vector3.new(offset.X, 0, offset.Z)
        if horizontal.Magnitude > 0.001 then
            local moveSpeed = State.laggerToggled and 40 or 58
            local verticalValue = (targetPosition.Y + 3.7 - position.Y) * 19.5 + targetVelocity.Y * 0.8
            local vertical
            if humanoid.FloorMaterial ~= Enum.Material.Air then
                vertical = math.max(verticalValue, 13)
            else
                vertical = verticalValue
            end
            local desiredVelocity = Vector3.new(horizontal.Unit.X * moveSpeed,
                math.clamp(vertical, -70, 110), horizontal.Unit.Z * moveSpeed)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVelocity, 0.8)
        end

        local predicted = targetPosition + targetVelocity * math.clamp(targetVelocity.Magnitude / 150, 0.05, 0.2)
        if (predicted - position).Magnitude > 0.1 then
            local targetCFrame = CFrame.lookAt(position, predicted)
            local rx, ry, rz = (root.CFrame:Inverse() * targetCFrame):ToEulerAnglesXYZ()
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(
                math.clamp(rx, -2.5, 2.5) * 42,
                math.clamp(ry, -2.5, 2.5) * 42,
                math.clamp(rz, -2.5, 2.5) * 42))
        end

        -- Printed V1 swings from this same loop when Auto Swing is enabled.
        if State.autoSwingEnabled then
            local tool = character:FindFirstChildOfClass("Tool")
            if tool then pcall(function() tool:Activate() end) end
        end
    end
    function G.stopLoop()
        G.generation += 1
        disconnect(G.heartbeat); G.heartbeat = nil
        restoreGoodOwner()
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if humanoid and G.savedAutoRotate ~= nil then humanoid.AutoRotate = G.savedAutoRotate end
        G.savedAutoRotate = nil
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
        G.locked, G.noTargetSince = nil, nil
        G.setHighlightTarget(nil)
    end
    function G.startLoop()
        G.stopLoop()
        G.heartbeat = RunService.RenderStepped:Connect(G.step)
    end
    function G.setEnabled(on)
        on = on == true
        if not G.alive then return end
        G.enabled, State.autoBatEnabled = on, on
        if on then
            if not G.heartbeat then G.startLoop() end
        else G.stopLoop() end
    end

    function Combat.refresh()
        if setAutoBatVisual then setAutoBatVisual(State.autoBatEnabled) end
        if Combat.mobileGood then Combat.mobileGood(State.autoBatEnabled) end
    end
    function Combat.stopGood()
        G.setEnabled(false)
        if Combat.autoTPWasEnabled then
            Combat.autoTPWasEnabled = false
            State.autoTPEnabled = true
            if setAutoTPVisual then setAutoTPVisual(true) end
            startAutoTP()
        end
        Combat.refresh()
    end
    function Combat.startGood()
        if State.autoLeftEnabled then State.autoLeftEnabled = false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end end
        if State.autoRightEnabled then State.autoRightEnabled = false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end end
        if not G.enabled and State.autoTPEnabled then Combat.autoTPWasEnabled = true; stopAutoTP() end
        G.setEnabled(true)
        Combat.refresh()
    end
    function Combat.destroy()
        G.setEnabled(false)
        G.alive = false
        for _, connection in ipairs(G.connections) do disconnect(connection) end
        table.clear(G.connections)
        G.effects:Destroy()
    end
    table.insert(G.connections, LP.CharacterRemoving:Connect(function() G.stopLoop() end))
    table.insert(G.connections, LP.CharacterAdded:Connect(function(character)
        task.delay(0.5, function()
            if LP.Character ~= character or not G.alive then return end
            if G.enabled and State.autoBatEnabled then G.startLoop() end
        end)
    end))
    UI.addCleanup(Combat.destroy)
end
local function equipAndSwingBat() Combat.swingCounter() end
local function resetAutoBatMotion() Combat.good.stopLoop() end
local function enableAutoBat() Combat.startGood() end
local function disableAutoBat() Combat.stopGood() end
local function queueAutoBatStart() Combat.startGood() end

-- ========================================================================
-- MEDUSA & BAT COUNTER
-- ========================================================================
local function findMedusa()
    local char = LP.Character
    if char then
        for _, t in ipairs(char:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
                return t
            end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
                return t
            end
        end
    end
    return nil
end

local function useMedusaCounter()
    if State.medusaDebounce or tick() - State.medusaLastUsed < State.MEDUSA_COOLDOWN then return end
    local char, hum = getCharData()
    if not char or not hum then return end
    
    State.medusaDebounce = true
    local med = findMedusa()
    if not med then State.medusaDebounce = false; return end
    if med.Parent ~= char then pcall(function() hum:EquipTool(med) end) end
    pcall(function() med:Activate() end)
    State.medusaLastUsed = tick()
    State.medusaDebounce = false
end

local function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if part.Anchored and part.Transparency == 1 then
            useMedusaCounter()
        end
    end)
end

local function setupMedusa(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end))
end

local function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled or State.batCounterDebounce then return end
        local char, hum = getCharData()
        if not hum then return end
        local st = hum:GetState()
        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
            State.batCounterDebounce = true
            task.spawn(function()
                equipAndSwingBat()
                task.wait(0.5)
                State.batCounterDebounce = false
            end)
        end
    end)
end

local function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    State.batCounterDebounce = false
end



-- ========================================================================
-- BILLBOARDS: SPEED INDICATOR & HIT COUNTDOWN
-- ========================================================================
local function setupSpeedIndicator(char)
    if not Speed.alive or not char then return end
    local head = char:WaitForChild("Head", 5)
    if not head or not Speed.alive or char ~= LP.Character then return end
    if Speed.billboard then pcall(function() Speed.billboard:Destroy() end) end
    for _, name in ipairs({"M10RUOverheadBB", "M10RUSpeedOnly"}) do
        local old = head:FindFirstChild(name)
        if old then old:Destroy() end
    end
    -- Invisible attachment container; its ONLY visible child is the number.
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "M10RUSpeedOnly"
    bb.Size = UDim2.fromOffset(90, 26)
    bb.StudsOffset = Vector3.new(0, 2.8, 0)
    bb.AlwaysOnTop = true
    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedValue"
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.BorderSizePixel = 0
    speedLabel.Text = "0.0"
    speedLabel.TextColor3 = UI.theme.accent
    speedLabel.TextStrokeColor3 = UI.theme.background
    speedLabel.TextStrokeTransparency = 0.5
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 18
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    Speed.billboard = bb
end
UI.addCleanup(function()
    if Speed.billboard then pcall(function() Speed.billboard:Destroy() end); Speed.billboard = nil end
    speedLabel = nil
end)

local countdownBB = nil
local countdownLabel = nil
local countdownActive = false
local countdownStateConn = nil

local function createCountdownBB(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    if countdownBB then pcall(function() countdownBB:Destroy() end) end
    
    countdownBB = Instance.new("BillboardGui", head)
    countdownBB.Name = "M10RUCountdownBB"
    countdownBB.Size = UDim2.new(0, 140, 0, 60)
    countdownBB.StudsOffset = Vector3.new(0, 5.5, 0)
    countdownBB.AlwaysOnTop = true
    countdownBB.Enabled = false
    
    countdownLabel = Instance.new("TextLabel", countdownBB)
    countdownLabel.Size = UDim2.new(1, 0, 1, 0)
    countdownLabel.BackgroundTransparency = 1
    countdownLabel.Text = ""
    countdownLabel.Font = Enum.Font.GothamBlack
    countdownLabel.TextScaled = true
    countdownLabel.TextStrokeTransparency = 0
    countdownLabel.TextStrokeColor3 = UI.theme.background
    countdownLabel.TextColor3 = UI.theme.text
end

local function runCountdown()
    if countdownActive then return end
    countdownActive = true
    if not countdownBB or not countdownLabel then
        createCountdownBB(LP.Character)
    end
    if not countdownBB or not countdownLabel then countdownActive = false; return end
    
    countdownBB.Enabled = true
    local steps = {
        {text = "3", color = UI.theme.deep},
        {text = "2", color = UI.theme.accent},
        {text = "1", color = UI.theme.light},
        {text = "GRAB!", color = UI.theme.text},
    }
    for _, step in ipairs(steps) do
        if not countdownLabel or not countdownLabel.Parent then break end
        countdownLabel.Text = step.text
        countdownLabel.TextColor3 = step.color
        task.wait(1)
    end
    if countdownBB then countdownBB.Enabled = false end
    if countdownLabel then countdownLabel.Text = "" end
    countdownActive = false
end

local function setupCountdown(char)
    if countdownStateConn then countdownStateConn:Disconnect() end
    task.wait(0.3)
    createCountdownBB(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    countdownStateConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics
            or newState == Enum.HumanoidStateType.Ragdoll
            or newState == Enum.HumanoidStateType.FallingDown then
            task.spawn(runCountdown)
        end
    end)
end

-- Connect Character Events
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    setupCountdown(char)
    if State.medusaCounterEnabled then setupMedusa(char) end
    if State.batCounterEnabled then startBatCounter() end
    if State.unwalkEnabled then task.wait(0.5); startUnwalk() end
    if State.antiRagdollEnabled then startAntiRagdoll() end
end)
if LP.Character then
    setupSpeedIndicator(LP.Character)
    setupCountdown(LP.Character)
end

-- ========================================================================
-- SKY THEMES ENGINE
-- ========================================================================
local M10RU_SKY_TAG = "M10RUDuelsSkyTheme"
local currentSkyTheme = "Off"
local m10ruOriginalLighting = nil

local M10RU_SKY_PRESETS = {
    ["Off"] = {kind = "off"},
    ["Night"] = {clock = 22, brightness = 2, ambient = {110, 100, 130}, outAmb = {120, 110, 140}, sky = {stars = 4000, moon = 18, sun = 0, moonTex = true}, atm = {dens = 0.45, color = {120, 60, 180}, decay = {60, 20, 100}, glare = 0.5, haze = 1.2}},
    ["Aurora"] = {clock = 14, brightness = 3, ambient = {150, 120, 150}, outAmb = {160, 130, 160}, atm = {dens = 0.55, color = {255, 80, 200}, decay = {255, 20, 150}, glare = 2.5, haze = 3}, clouds = {cover = 0.7, dens = 0.7, color = {255, 240, 250}}},
    ["Sunset"] = {clock = 17.2, brightness = 2.5, ambient = {170, 120, 100}, outAmb = {180, 130, 110}, sky = {stars = 0, sun = 25, moon = 0}, atm = {dens = 0.5, color = {255, 130, 60}, decay = {255, 80, 30}, glare = 2, haze = 2.5}, clouds = {cover = 0.55, dens = 0.55, color = {255, 200, 140}}},
    ["Galaxy"] = {clock = 0, brightness = 1.5, ambient = {70, 60, 100}, outAmb = {80, 70, 110}, sky = {stars = 10000, moon = 30, sun = 0}, atm = {dens = 0.15, color = {40, 20, 80}, decay = {20, 10, 50}, glare = 0.3, haze = 0.5}},
    ["Blood Moon"] = {clock = 22.5, brightness = 1.6, ambient = {130, 40, 40}, outAmb = {150, 50, 50}, sky = {stars = 1500, moon = 28, sun = 0, moonTex = true}, atm = {dens = 0.6, color = {220, 30, 30}, decay = {120, 10, 10}, glare = 1.4, haze = 2}, clouds = {cover = 0.5, dens = 0.7, color = {120, 30, 30}}},
    ["Volcanic"] = {clock = 19, brightness = 2, ambient = {180, 80, 40}, outAmb = {200, 90, 50}, sky = {stars = 200, sun = 12, moon = 0}, atm = {dens = 0.75, color = {255, 60, 0}, decay = {180, 20, 0}, glare = 3, haze = 3.5}, clouds = {cover = 0.8, dens = 0.9, color = {120, 40, 20}}},
    ["Vaporwave"] = {clock = 19.5, brightness = 2.4, ambient = {180, 120, 200}, outAmb = {190, 130, 210}, sky = {stars = 1000, moon = 14}, atm = {dens = 0.45, color = {255, 100, 220}, decay = {120, 60, 255}, glare = 2.2, haze = 2.4}, clouds = {cover = 0.5, dens = 0.55, color = {200, 150, 255}}},
    ["Heaven"] = {clock = 12, brightness = 4, ambient = {240, 235, 210}, outAmb = {250, 245, 220}, sky = {sun = 16, moon = 0, stars = 0}, atm = {dens = 0.25, color = {255, 250, 220}, decay = {255, 240, 200}, glare = 3, haze = 1.5}, clouds = {cover = 0.85, dens = 0.5, color = {255, 255, 255}}},
    ["Storm"] = {clock = 15, brightness = 1.4, ambient = {90, 90, 110}, outAmb = {100, 100, 120}, sky = {stars = 0, sun = 6, moon = 0}, atm = {dens = 0.65, color = {80, 90, 120}, decay = {40, 50, 80}, glare = 0.5, haze = 3}, clouds = {cover = 0.95, dens = 0.95, color = {60, 65, 80}}},
    ["Deep Space"] = {clock = 0, brightness = 1, ambient = {30, 25, 50}, outAmb = {40, 35, 60}, sky = {stars = 15000, moon = 0, sun = 0}, atm = {dens = 0.08, color = {15, 5, 40}, decay = {5, 0, 20}, glare = 0.2, haze = 0.3}}
}

local M10RU_SKY_ORDER = {"Off", "Night", "Aurora", "Sunset", "Galaxy", "Blood Moon", "Volcanic", "Vaporwave", "Heaven", "Storm", "Deep Space"}

local function m10ruSaveOriginalLighting()
    if m10ruOriginalLighting then return end
    m10ruOriginalLighting = {
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        Brightness = Lighting.Brightness,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        GlobalShadows = Lighting.GlobalShadows,
        LightingChildren = {},
        TerrainChildren = {}
    }
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("Sky") or child:IsA("Atmosphere") then
            table.insert(m10ruOriginalLighting.LightingChildren, child:Clone())
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:IsA("Clouds") then
                table.insert(m10ruOriginalLighting.TerrainChildren, child:Clone())
            end
        end
    end
end
m10ruSaveOriginalLighting()

local function m10ruClearSky(removeAll)
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(M10RU_SKY_TAG) or (removeAll and (child:IsA("Sky") or child:IsA("Atmosphere"))) then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(M10RU_SKY_TAG) or (removeAll and child:IsA("Clouds")) then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

local function m10ruSkyInstance(className, parent, props)
    local inst = Instance.new(className)
    inst:SetAttribute(M10RU_SKY_TAG, true)
    for k, v in pairs(props or {}) do
        pcall(function() inst[k] = v end)
    end
    inst.Parent = parent
    return inst
end

local function m10ruColor(rgb)
    return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

local function m10ruApplySky(mode)
    m10ruSaveOriginalLighting()
    m10ruClearSky(true)
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    local preset = M10RU_SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        if m10ruOriginalLighting then
            for k, v in pairs(m10ruOriginalLighting) do
                if k ~= "LightingChildren" and k ~= "TerrainChildren" then
                    pcall(function() Lighting[k] = v end)
                end
            end
            for _, child in ipairs(m10ruOriginalLighting.LightingChildren or {}) do
                pcall(function() child:Clone().Parent = Lighting end)
            end
            local offTerrain = workspace:FindFirstChildOfClass("Terrain")
            if offTerrain then
                for _, child in ipairs(m10ruOriginalLighting.TerrainChildren or {}) do
                    pcall(function() child:Clone().Parent = offTerrain end)
                end
            end
        end
        return
    end

    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200, 200, 200)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = m10ruColor(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = m10ruColor(preset.ambient) end
    if preset.sky then
        local skyProps = {}
        if preset.sky.stars then skyProps.StarCount = preset.sky.stars end
        if preset.sky.moon then skyProps.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyProps.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyProps.MoonTextureId = "rbxasset://sky/moon.jpg" end
        m10ruSkyInstance("Sky", Lighting, skyProps)
    end
    if preset.atm then
        m10ruSkyInstance("Atmosphere", Lighting, {
            Density = preset.atm.dens or 0.3,
            Color = m10ruColor(preset.atm.color),
            Decay = m10ruColor(preset.atm.decay),
            Glare = preset.atm.glare or 1,
            Haze = preset.atm.haze or 1
        })
    end
    if preset.clouds and terrain then
        m10ruSkyInstance("Clouds", terrain, {
            Cover = preset.clouds.cover or 0.5,
            Density = preset.clouds.dens or 0.5,
            Color = m10ruColor(preset.clouds.color)
        })
    end
end

-- ========================================================================

-- ========================================================================
-- SKIN CHANGER SYSTEM & FULLSCREEN 3D CAROUSEL
-- ========================================================================

-- Best Outfits module ported from Rival Hub; exposed through the existing Skin Changer.
local function createBestOutfitsModule()
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local huiOk, huiResult = pcall(function() return gethui and gethui() end)
local CoreGui = huiOk and huiResult or game:GetService("CoreGui")
local LP = Players.LocalPlayer
local OUTFITS = {
{
id = 10997283529,
label = "Outfit 1",
hideOriginal = false,
hideOriginalHead = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {10997283529, 125085889448130},
},
{
label = "Outfit 2",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {125157548394108, 123231522991173, 74827642361405},
},
{
label = "Outfit 3",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
face = 86109936998865,
faceMode = "decal",
items = {136644276218918, 132022106987543, 131740907052260},
},
{
label = "Outfit 4",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {119331031817124, 84952305140948},
},
{
label = "Outfit 5",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
},
{
label = "Outfit 6",
hideOriginal = false,
clearOriginalWearables = true,
items = {13935333090, 16110951997, 10632503818},
},
{
label = "Outfit 7",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
},
{
label = "Outfit 8",
hideOriginal = false,
headless = true,
hideRightLeg = true,
localOnly = true,
clearOriginalWearables = true,
items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
},
{
label = "Outfit 9",
localOnly = true,
preserveRig = true,
hideOriginal = false,
hideLeftLeg = true,
hideRightLeg = true,
clearOriginalWearables = true,
items = {70414871864071,14863917259,133498027006138,82277826177074},
accessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,
[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
},
}
local BODY_PART_NAMES = {
Head = true, UpperTorso = true, LowerTorso = true, Torso = true,
LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
RightUpperArm = true, RightLowerArm = true, RightHand = true,
LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
["Left Arm"] = true, ["Right Arm"] = true,
["Left Leg"] = true, ["Right Leg"] = true,
}
local PART_NAME_ALIASES = {
["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",
}
local state = {
enabled = false,
selected = 1,
visuals = {},
hidden = {},
wearableConn = nil,
headlessConn = nil,
headlessLoop = nil,
statsLoop = nil,
savedWalkSpeed = nil,
savedJumpPower = nil,
originalDescription = nil,
descriptionCharacter = nil,
connections = {},
}
local function currentCharacter()
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
return character, humanoid, root
end
local function restoreOriginalBody()
for object, saved in pairs(state.hidden) do
if object and object.Parent then
pcall(function()
if type(saved) == "table" and saved.basePart then
object.LocalTransparencyModifier = saved.localTransparency
object.Transparency = saved.transparency
elseif type(saved) == "table" and saved.properties then
for property, value in pairs(saved.properties) do object[property] = value end
elseif type(saved) == "table" and saved.property then
object[saved.property] = saved.value
elseif object:IsA("BasePart") then
object.LocalTransparencyModifier = saved
elseif object:IsA("Decal") or object:IsA("Texture") then
object.Transparency = saved
end
end)
end
end
state.hidden = {}
end
local stopHeadless
local enforceHeadless
local enforceStats
local function clearVisuals()
stopHeadless()
if state.wearableConn then
state.wearableConn:Disconnect()
state.wearableConn = nil
end
for _, object in ipairs(state.visuals) do
if object and object.Parent then pcall(function() object:Destroy() end) end
end
state.visuals = {}
restoreOriginalBody()
end
local function belongsToLocalVisual(object)
for _, visual in ipairs(state.visuals) do
if object == visual or object:IsDescendantOf(visual) then return true end
end
return false
end
local function hideOriginalBody(character)
restoreOriginalBody()
for _, object in ipairs(character:GetDescendants()) do
if not belongsToLocalVisual(object) then
if object:IsA("BasePart") then
state.hidden[object] = object.LocalTransparencyModifier
object.LocalTransparencyModifier = 1
elseif object:IsA("Decal") or object:IsA("Texture") then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
end
local function hideOriginalHead(character)
local head = character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
if state.hidden[head] == nil then
state.hidden[head] = {
basePart = true,
localTransparency = head.LocalTransparencyModifier,
transparency = head.Transparency,
}
elseif type(state.hidden[head]) ~= "table" then
state.hidden[head] = {
basePart = true,
localTransparency = state.hidden[head],
transparency = head.Transparency,
}
end
head.LocalTransparencyModifier = 1
head.Transparency = 1
for _, object in ipairs(head:GetDescendants()) do
if (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
local function hideLegSide(character, side)
local names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}
for _, name in ipairs(names) do
local part = character:FindFirstChild(name)
if part and part:IsA("BasePart") then
if state.hidden[part] == nil then
state.hidden[part] = {
basePart = true,
localTransparency = part.LocalTransparencyModifier,
transparency = part.Transparency,
}
elseif type(state.hidden[part]) ~= "table" then
state.hidden[part] = {
basePart = true,
localTransparency = state.hidden[part],
transparency = part.Transparency,
}
end
part.LocalTransparencyModifier = 1
part.Transparency = 1
end
end
end
local function hideLeftLeg(character)
hideLegSide(character, "Left")
end
local function hideRightLeg(character)
hideLegSide(character, "Right")
end
stopHeadless = function()
if state.headlessConn then
pcall(state.headlessConn.Disconnect, state.headlessConn)
state.headlessConn = nil
end
if state.headlessLoop then
pcall(task.cancel, state.headlessLoop)
state.headlessLoop = nil
end
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
end
enforceHeadless = function(character, option)
stopHeadless()
if not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end
if option.headless then hideOriginalHead(character) end
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
state.headlessConn = character.ChildAdded:Connect(function(child)
if child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then
task.defer(function()
if state.enabled and LP.Character==character then
local active=OUTFITS[state.selected]
if active.hideLeftLeg then hideLeftLeg(character) end
if active.hideRightLeg then hideRightLeg(character) end end end) end
if child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then
task.defer(function()
if state.enabled and LP.Character == character and OUTFITS[state.selected].headless then
pcall(hideOriginalHead, character)
end
end)
end
end)
state.headlessLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local opt = OUTFITS[state.selected]
if opt and opt.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") and head.LocalTransparencyModifier < 1 then
pcall(hideOriginalHead, character)
end
end
if opt and opt.hideLeftLeg then
pcall(hideLeftLeg, character)
end
if opt and opt.hideRightLeg then
pcall(hideRightLeg, character)
end
task.wait(0.6)
end
end)
end
enforceStats = function(character)
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
state.statsLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
if state.savedWalkSpeed ~= nil and humanoid.WalkSpeed ~= state.savedWalkSpeed then
humanoid.WalkSpeed = state.savedWalkSpeed
end
if state.savedJumpPower ~= nil and humanoid.JumpPower ~= state.savedJumpPower then
humanoid.JumpPower = state.savedJumpPower
end
end
task.wait(0.4)
end
end)
end
local function hideOriginalWearables(character, watchForNew)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
if not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then
local property = child:IsA("Shirt") and "ShirtTemplate"
or child:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[child] = {property = property, value = child[property]}
child[property] = ""
end
end
end
for _, child in ipairs(character:GetDescendants()) do
if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then
local objects = child:GetDescendants()
if child:IsA("BasePart") then table.insert(objects, child) end
for _, object in ipairs(objects) do
if object:IsA("BasePart") then
local saved = state.hidden[object]
if saved == nil then
state.hidden[object] = {
basePart = true,
localTransparency = object.LocalTransparencyModifier,
transparency = object.Transparency,
}
elseif type(saved) ~= "table" then
state.hidden[object] = {
basePart = true,
localTransparency = saved,
transparency = object.Transparency,
}
end
object.LocalTransparencyModifier = 1
object.Transparency = 1
elseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
elseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then
state.hidden[object] = {property = "Enabled", value = object.Enabled}
object.Enabled = false
end
end
end
end
if watchForNew and not state.wearableConn then
state.wearableConn = character.DescendantAdded:Connect(function(object)
if not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end
if object:IsA("Accessory") or object:IsA("Accoutrement")
or object:FindFirstAncestorWhichIsA("Accessory")
or object:FindFirstAncestorWhichIsA("Accoutrement") then
task.defer(function()
if state.enabled and character.Parent then hideOriginalWearables(character, false) end
end)
end
end)
end
end
local function loadAssetObjects(assetId)
local insertOk, inserted = pcall(function() return InsertService:LoadAsset(assetId) end)
if insertOk and inserted then return {inserted}, "InsertService" end
local objectOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
if objectOk and objects and #objects > 0 then return objects, "GetObjects" end
return nil, tostring(inserted or objects or "unknown loading error")
end
local faceTextureCache = {}
local function resolveFaceTexture(faceId)
if faceTextureCache[faceId] then return faceTextureCache[faceId] end
local objects = loadAssetObjects(faceId)
if objects then
local texture
for _, root in ipairs(objects) do
local candidates = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end
for _, object in ipairs(candidates) do
if object:IsA("Decal") or object:IsA("Texture") then
texture = object.Texture
if texture and texture ~= "" then break end
end
end
pcall(function() root:Destroy() end)
if texture and texture ~= "" then break end
end
if texture and texture ~= "" then
faceTextureCache[faceId] = texture
return texture
end
end
return "rbxassetid://" .. tostring(faceId)
end
local function applyLocalFace(character, faceId)
local head = character:FindFirstChild("Head")
if not head then return false end
local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
if face and not face:IsA("Decal") then face = nil end
-- Remove duplicate face decals that can cover the selected outfit's face.
for _, child in ipairs(head:GetChildren()) do
if child:IsA("Decal") and child ~= face then
pcall(function() child:Destroy() end)
end
end
if face then
if state.hidden[face] == nil then
state.hidden[face] = {
properties = {Texture = face.Texture, Transparency = face.Transparency},
}
end
else
face = Instance.new("Decal")
face.Name = "face"
face.Face = Enum.NormalId.Front
face:SetAttribute("VX7LocalOnly", true)
face.Parent = head
table.insert(state.visuals, face)
end
face.Texture = resolveFaceTexture(faceId)
face.Transparency = 0
return true
end
local function applyLocalFaceStable(character, faceId)
pcall(applyLocalFace, character, faceId)
for _, delayTime in ipairs({0.2, 0.8}) do
task.delay(delayTime, function()
local option = OUTFITS[state.selected]
if state.enabled and LP.Character == character and option and option.face == faceId then
pcall(applyLocalFace, character, faceId)
end
end)
end
end
local function findCharacterAttachment(character, name)
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then
return object
end
end
end
local function sanitizeVisual(container)
local objects = container:GetDescendants()
if container:IsA("BasePart") then table.insert(objects, container) end
for _, object in ipairs(objects) do
if object:IsA("LuaSourceContainer") then
object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored = false
object.CanCollide = false
object.CanTouch = false
object.CanQuery = false
object.Massless = true
object.CastShadow = false
elseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then
object:Destroy()
end
end
end
local function weldPart(part, target)
local weld = Instance.new("WeldConstraint")
weld.Name = "VX7LocalVisualWeld"
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
end
local function countStackedAccessories(character, attachmentName)
local count = 0
for _, visual in ipairs(state.visuals) do
if visual:IsA("Accessory") then
local h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
if h then
for _, child in ipairs(h:GetChildren()) do
if child:IsA("Attachment") and child.Name == attachmentName then
count = count + 1
break
end
end
end
end
end
return count
end
local function attachAccessoryLocal(accessory, character, rootPart, assetId)
local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
if not handle then return false end
sanitizeVisual(accessory)
accessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)
accessory:SetAttribute("VX7AssetId", assetId)
accessory:SetAttribute("VX7LocalOnly", true)
local option=OUTFITS[state.selected]
local slot=option and option.accessorySlots and option.accessorySlots[assetId]
if slot then pcall(function() accessory.AccessoryType=slot end) end
accessory.Parent = character
local sourceAttachment
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then
sourceAttachment = child
break
end
end
local targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)
local targetPart = targetAttachment and targetAttachment.Parent
if targetAttachment and targetPart and targetPart:IsA("BasePart") then
handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
local stacked = countStackedAccessories(character, sourceAttachment.Name)
if stacked > 0 then
handle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)
end
else
targetPart = character:FindFirstChild("LowerTorso")
or character:FindFirstChild("Torso")
or rootPart
if not targetPart then accessory:Destroy(); return false end
handle.CFrame = rootPart.CFrame
end
weldPart(handle, targetPart)
table.insert(state.visuals, accessory)
return true
end
local function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)
local clone = rootObject:Clone()
sanitizeVisual(clone)
clone.Name = "VX7_LocalOutfit_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone.Parent = character
local parts = {}
if clone:IsA("BasePart") then table.insert(parts, clone) end
for _, object in ipairs(clone:GetDescendants()) do
if object:IsA("BasePart") then table.insert(parts, object) end
end
if #parts == 0 then clone:Destroy(); return false end
local anchor = targetPart or rootPart
if textureId then
for _, part in ipairs(parts) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
end
end
local pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame
for _, part in ipairs(parts) do
local offset = pivot:ToObjectSpace(part.CFrame)
part.CFrame = anchor.CFrame * offset
weldPart(part, anchor)
end
table.insert(state.visuals, clone)
return true
end
local function attachClassicClothingLocal(rootObject, character, assetId)
local candidates = {}
if rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
table.insert(candidates, rootObject)
end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(candidates, object)
end
end
local added = 0
for _, source in ipairs(candidates) do
for _, existing in ipairs(character:GetChildren()) do
if existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then
local property = existing:IsA("Shirt") and "ShirtTemplate"
or existing:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[existing] = {property = property, value = existing[property]}
existing[property] = ""
end
end
local clone = source:Clone()
clone.Name = "VX7_LocalClothing_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone:SetAttribute("VX7LocalOnly", true)
clone.Parent = character
table.insert(state.visuals, clone)
added = added + 1
end
return added
end
local function attachBodyPartsLocal(rootObject, character, assetId, textureId)
local holder = Instance.new("Model")
holder.Name = "VX7_LocalBody_" .. tostring(assetId)
holder:SetAttribute("VX7AssetId", assetId)
holder:SetAttribute("VX7LocalOnly", true)
holder.Parent = character
local bodyColors = rootObject:FindFirstChildOfClass("BodyColors")
local colorProperties = {
Head = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",
LeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",
RightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",
LeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",
RightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",
}
local added = 0
local candidates = {}
if rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, source in ipairs(candidates) do
local partName = source.Name
if BODY_PART_NAMES[partName] then
local target = character:FindFirstChild(partName)
if not target then
local alias = PART_NAME_ALIASES[partName]
if alias then target = character:FindFirstChild(alias) end
end
if target and target:IsA("BasePart") then
local clone = source:Clone()
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then
child:Destroy()
end
end
sanitizeVisual(clone)
clone.Name = source.Name
if clone:IsA("MeshPart") and textureId then
pcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
if bodyColors and colorProperties[source.Name] then
pcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)
end
clone.CFrame = target.CFrame
clone.Parent = holder
weldPart(clone, target)
added = added + 1
end
end
end
if added == 0 then holder:Destroy(); return 0 end
table.insert(state.visuals, holder)
return added
end
local assetInfoCache = {}
local ASSET_INFO_CACHE_FILE="RivalHubAvatarAssets.json"
pcall(function()
if isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then
local decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))
if type(decoded)=="table" then for id,assetType in pairs(decoded) do
local numericId=tonumber(id);local numericType=tonumber(assetType)
if numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)
local assetInfoSaveQueued=false
local function saveAssetInfoCache()
if assetInfoSaveQueued or not writefile then return end
assetInfoSaveQueued=true;task.delay(.4,function()
assetInfoSaveQueued=false;pcall(function()
local encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end
writefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end
local bodyPropertyByType = {
[17] = "Head", [27] = "Torso", [28] = "RightArm",
[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
}
local bodyPartAnchorNames = {
[17] = {"Head"}, [79] = {"Head"},
[27] = {"UpperTorso", "Torso"},
[28] = {"RightUpperArm", "Right Arm"},
[29] = {"LeftUpperArm", "Left Arm"},
[30] = {"LeftUpperLeg", "Left Leg"},
[31] = {"RightUpperLeg", "Right Leg"},
}
local accessoryTypeByAssetType = {
[8] = Enum.AccessoryType.Hat,
[41] = Enum.AccessoryType.Hair,
[42] = Enum.AccessoryType.Face,
[43] = Enum.AccessoryType.Neck,
[44] = Enum.AccessoryType.Shoulder,
[45] = Enum.AccessoryType.Front,
[46] = Enum.AccessoryType.Back,
[47] = Enum.AccessoryType.Waist,
[64] = Enum.AccessoryType.TShirt,
[65] = Enum.AccessoryType.Shirt,
[66] = Enum.AccessoryType.Pants,
[67] = Enum.AccessoryType.Jacket,
[68] = Enum.AccessoryType.Sweater,
[69] = Enum.AccessoryType.Shorts,
[70] = Enum.AccessoryType.LeftShoe,
[71] = Enum.AccessoryType.RightShoe,
[72] = Enum.AccessoryType.DressSkirt,
[76] = Enum.AccessoryType.Eyebrow,
[77] = Enum.AccessoryType.Eyelash,
}
local function getAssetTypeId(assetId)
if assetInfoCache[assetId] then return assetInfoCache[assetId] end
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)
if ok and info and info.AssetTypeId then
assetInfoCache[assetId] = info.AssetTypeId
saveAssetInfoCache()
return info.AssetTypeId
end
end
local accessoryDescriptionProperties = {
"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",
"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",
"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",
"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",
"EyebrowAccessory", "EyelashAccessory",
}
local function createDirectDescription(option, humanoid)
local directOutfitId = option.outfitId
local completeOutfitDescription
if directOutfitId then
local ok, outfitDescription = pcall(
Players.GetHumanoidDescriptionFromOutfitId,
Players,
directOutfitId
)
if not ok or not outfitDescription then return nil end
completeOutfitDescription = outfitDescription
if not option.items and not option.face and not option.head then return outfitDescription end
end
local source = completeOutfitDescription or state.originalDescription
if not source then
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
source = applied
end
local description = source:Clone()
if completeOutfitDescription then completeOutfitDescription:Destroy() end
if not directOutfitId then
description.Shirt = 0
description.Pants = 0
description.GraphicTShirt = 0
for _, property in ipairs(accessoryDescriptionProperties) do
pcall(function() description[property] = "" end)
end
pcall(function() description:SetAccessories({}, true) end)
end
local accessories = {}
if directOutfitId then
pcall(function() accessories = description:GetAccessories(true) end)
end
local allItems = {}
for _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end
for _, id in ipairs(option.items or {}) do table.insert(allItems, id) end
for _, id in ipairs(allItems) do
local assetTypeId = getAssetTypeId(id)
if not assetTypeId then description:Destroy(); return nil end
local bodyProperty = bodyPropertyByType[assetTypeId]
local accessoryType = accessoryTypeByAssetType[assetTypeId]
if bodyProperty then
description[bodyProperty] = id
elseif assetTypeId == 11 then
description.Shirt = id
elseif assetTypeId == 12 then
description.Pants = id
elseif assetTypeId == 1 then
description.GraphicTShirt = id
elseif assetTypeId == 18 then
description.Face = id
elseif accessoryType then
local accessory = {
AssetId = id,
AccessoryType = accessoryType,
Order = #accessories + 1,
}
if assetTypeId >= 64 and assetTypeId <= 72 then
accessory.IsLayered = true
accessory.Puffiness = option.layeredPuffiness or 0
end
table.insert(accessories, accessory)
else
description:Destroy()
return nil
end
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
local faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]
local faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]
if option.faceMode == "decal" then
if faceTypeId == 18 then description.Face = option.face end
elseif faceBodyProperty then
description[faceBodyProperty] = option.face
elseif faceAccessoryType then
table.insert(accessories, {
AssetId = option.face,
AccessoryType = faceAccessoryType,
Order = #accessories + 1,
})
elseif faceTypeId == 18 then
description.Face = option.face
end
end
if option.head then description.Head = option.head end
for property, value in pairs(option.scales or {}) do
pcall(function() description[property] = value end)
end
if option.skinColor then
for _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do
description[property] = option.skinColor
end
end
if #accessories > 0 then
local ok = pcall(function() description:SetAccessories(accessories, true) end)
if not ok then description:Destroy(); return nil end
end
return description
end
local statusText
local function setStatus(text, good)
if not statusText or not statusText.Parent then return end
statusText.Text = text
statusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)
end
local function applyOutfit()
local character, humanoid, rootPart = currentCharacter()
if not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end
if state.descriptionCharacter ~= character or not state.originalDescription then
state.descriptionCharacter = character
state.originalDescription = nil
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if ok and applied then state.originalDescription = applied:Clone() end
end
clearVisuals()
setStatus("Loading local visual...", false)
local option = OUTFITS[state.selected]
local assetId = option.id or option.outfitId
state.skipDescriptionRestore=option.preserveRig==true
if option.forceBodyParts or option.localOnly then
setStatus("Local visual only (no rig change)...", false)
end
if (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then
setStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)
local description = createDirectDescription(option, humanoid)
if description then
local savedHead = character:FindFirstChild("Head")
local savedHealth = humanoid.Health
state.savedWalkSpeed = humanoid.WalkSpeed
state.savedJumpPower = humanoid.JumpPower
local savedCFrame = rootPart.CFrame
local savedVelocity = rootPart.AssemblyLinearVelocity
local ok = pcall(function() humanoid:ApplyDescription(description) end)
if not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end
description:Destroy()
if ok then
local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
local currentRoot = character:FindFirstChild("HumanoidRootPart")
if currentHumanoid and savedHealth > 0 then
currentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)
end
if currentRoot then
currentRoot.CFrame = savedCFrame
currentRoot.AssemblyLinearVelocity = savedVelocity
currentRoot.AssemblyAngularVelocity = Vector3.zero
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
if option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then
applyLocalFaceStable(character, option.face)
end
end
state.enabled = true
enforceStats(character)
enforceHeadless(character, option)
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
if option.head and character:FindFirstChild("Head") == savedHead then
hideOriginalHead(character)
end
setStatus(option.label .. " applied - native avatar method", true)
return true
end
end
setStatus("Native apply failed; using visual fallback...", false)
end
local assetIds = {}
-- Load every body asset in the local fallback too. The native HumanoidDescription
-- path can fail when even one catalog asset cannot be classified by GetProductInfo.
for _, id in ipairs(option.bodyItems or {}) do table.insert(assetIds, id) end
for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
if option.head then table.insert(assetIds, option.head) end
if #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end
local fallbackFaceType = option.face and getAssetTypeId(option.face)
local faceIsAccessory = option.faceMode ~= "decal"
and fallbackFaceType
and accessoryTypeByAssetType[fallbackFaceType] ~= nil
if faceIsAccessory then table.insert(assetIds, option.face) end
local attached, expected = 0, 0
local lastError
expected = expected + (option.face and not faceIsAccessory and 1 or 0)
for _, currentAssetId in ipairs(assetIds) do
local objects, method = loadAssetObjects(currentAssetId)
if objects then
for _, loadedRoot in ipairs(objects) do
local rootAttached = false
local bodyPartsAttached = false
local classics = {}
if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
table.insert(classics, loadedRoot)
end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(classics, object)
end
end
local accessories = {}
if loadedRoot:IsA("Accessory") then
table.insert(accessories, loadedRoot)
else
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Accessory") then table.insert(accessories, object:Clone()) end
end
end
local assetTypeId = getAssetTypeId(currentAssetId)
local isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil
local bodyCandidates = 0
local isDeclaredBodyItem = table.find(option.bodyItems or {}, currentAssetId) ~= nil
local wantsBodyParts = not loadedRoot:IsA("Accessory")
and (isDeclaredBodyItem or option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))
if wantsBodyParts then
local candidates = {}
if loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, object in ipairs(candidates) do
if BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end
end
end
expected = expected + #classics + #accessories + bodyCandidates
if #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end
if #classics > 0 then
local ok, result = pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)
if ok and result and result > 0 then attached = attached + result; rootAttached = true end
end
if wantsBodyParts and bodyCandidates > 0 then
local ok, result = pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)
if ok and result and result > 0 then
attached = attached + result
rootAttached = true
bodyPartsAttached = true
end
end
for _, accessory in ipairs(accessories) do
local ok, result = pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)
if ok and result then
attached = attached + 1
rootAttached = true
else
pcall(function() accessory:Destroy() end)
end
end
if not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then
local headAnchor = character:FindFirstChild("Head")
local anchor = rootPart
if currentAssetId == option.head then
anchor = headAnchor
elseif isBodyPartAsset then
local anchorNames = bodyPartAnchorNames[assetTypeId]
if anchorNames then
for _, name in ipairs(anchorNames) do
local target = character:FindFirstChild(name)
if target and target:IsA("BasePart") then anchor = target; break end
end
end
end
local ok, result = pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)
if ok and result then attached = attached + 1 end
end
if loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then
pcall(function() loadedRoot:Destroy() end)
end
end
else
lastError = method
end
end
local faceApplied = false
if option.face and not faceIsAccessory then
local ok, result = pcall(applyLocalFace, character, option.face)
faceApplied = ok and result == true
end
local headlessApplied = false
if option.headless then
enforceHeadless(character, option)
headlessApplied = true
end
local legApplied = false
if option.hideLeftLeg then
hideLeftLeg(character)
legApplied = true
end
if option.hideRightLeg then
hideRightLeg(character)
legApplied = true
end
local totalItems = expected
local loadedItems = attached + (faceApplied and 1 or 0)
state.enabled = attached > 0 or faceApplied or headlessApplied or legApplied
if state.enabled then
if option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end
if option.hideOriginal then hideOriginalBody(character) end
if option.hideOriginalHead then hideOriginalHead(character) end
if option.head then hideOriginalHead(character) end
if option.clearOriginalWearables then hideOriginalWearables(character, true) end
setStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)
else
setStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)
end
return state.enabled
end
local function restoreOriginalDescription()
local description = state.originalDescription
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then
local clone = description:Clone()
local ok = pcall(function() humanoid:ApplyDescription(clone) end)
if not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end
clone:Destroy()
end
if state.originalDescription then state.originalDescription:Destroy() end
state.originalDescription = nil
state.descriptionCharacter = nil
state.skipDescriptionRestore=false
end
local function removeOutfit()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
setStatus("Local visual removed", true)
end
return {
outfits = OUTFITS,
apply = function(index)
state.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
return applyOutfit()
end,
remove = removeOutfit,
description = function(index)
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]
if not humanoid or not option then return nil end
local strict = createDirectDescription(option, humanoid)
if strict then return strict end
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
local description = applied:Clone(); applied:Destroy()
description.Shirt=0; description.Pants=0; description.GraphicTShirt=0
for _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end
pcall(function() description:SetAccessories({},true) end)
local accessories={}; local all={}
for _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end
for _,id in ipairs(option.items or {}) do table.insert(all,id) end
for _,id in ipairs(all) do
local assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]
if bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then
table.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end
end
if option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end
if option.head then description.Head=option.head end
for property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end
if #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end
return description
end,
previewModel = function(index)
    local outfitIndex = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
    local option = OUTFITS[outfitIndex]
    if not option then return nil end

    -- Build the preview from a HumanoidDescription instead of cloning the live
    -- avatar and manually welding catalog assets (which caused giant gray slabs).
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return nil end

    local desc = nil
    local okDesc, resultDesc = pcall(function()
        return createDirectDescription(option, humanoid)
    end)
    if okDesc then desc = resultDesc end
    if not desc then return nil end

    local model = nil
    local okModel, resultModel = pcall(function()
        return Players:CreateHumanoidModelFromDescription(desc, Enum.HumanoidRigType.R15)
    end)
    pcall(function() desc:Destroy() end)
    if not okModel or not resultModel then return nil end

    model.Name = "RivalOutfitPreview_" .. tostring(option.label or outfitIndex)
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("BasePart") then
            object.Anchored = true
            object.CanCollide = false
            object.CastShadow = false
            object.LocalTransparencyModifier = 0
            if object.Name == "HumanoidRootPart" then
                object.Transparency = 1
            end
        elseif object:IsA("LuaSourceContainer") then
            object:Destroy()
        end
    end
    local previewHumanoid = model:FindFirstChildOfClass("Humanoid")
    if previewHumanoid then
        previewHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    end
    return model
end,
-- Preview that does NOT depend on MarketplaceService / HumanoidDescription.
-- createDirectDescription() aborts as soon as ONE catalog asset cannot be
-- classified by GetProductInfo, so on executors where that call is blocked the
-- description preview is nil and the carousel fell back to the blocky dummy.
-- This clones the local avatar, strips it, then dresses it with exactly the
-- same local attachment helpers used when the outfit is really applied.
previewRigModel = function(index)
    local outfitIndex = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
    local option = OUTFITS[outfitIndex]
    local character = LP.Character
    if not option or not character then return nil end

    local okClone, rig = pcall(function()
        character.Archivable = true
        local clone = character:Clone()
        character.Archivable = false
        return clone
    end)
    if not (okClone and rig) then return nil end

    -- Strip the clone down to a clean mannequin (scripts, clothes, accessories).
    for _, object in ipairs(rig:GetDescendants()) do
        if object:IsA("LuaSourceContainer") then
            pcall(function() object:Destroy() end)
        end
    end
    for _, object in ipairs(rig:GetChildren()) do
        if object:IsA("Accessory") or object:IsA("Accoutrement")
            or object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic")
            or object:IsA("BodyColors") then
            pcall(function() object:Destroy() end)
        end
    end

    local humanoid = rig:FindFirstChildOfClass("Humanoid")
    local rootPart = rig:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then
        pcall(function() rig:Destroy() end)
        return nil
    end
    humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None

    local assetIds = {}
    for _, id in ipairs(option.bodyItems or {}) do table.insert(assetIds, id) end
    for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
    if option.head then table.insert(assetIds, option.head) end

    local attached = 0
    for _, assetId in ipairs(assetIds) do
        local okAssets, objects = pcall(loadAssetObjects, assetId)
        if okAssets and objects then
            for _, loadedRoot in ipairs(objects) do
                local rootAttached = false
                local classics = {}
                if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
                    table.insert(classics, loadedRoot)
                end
                for _, object in ipairs(loadedRoot:GetDescendants()) do
                    if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
                        table.insert(classics, object)
                    end
                end
                local accessories = {}
                if loadedRoot:IsA("Accessory") then
                    table.insert(accessories, loadedRoot)
                else
                    for _, object in ipairs(loadedRoot:GetDescendants()) do
                        if object:IsA("Accessory") then
                            local okCopy, copy = pcall(function() return object:Clone() end)
                            if okCopy and copy then table.insert(accessories, copy) end
                        end
                    end
                end

                if #classics > 0 then
                    local okClassic, count = pcall(attachClassicClothingLocal, loadedRoot, rig, assetId)
                    if okClassic and type(count) == "number" and count > 0 then
                        attached = attached + count
                        rootAttached = true
                    end
                end

                local isDeclaredBodyItem = table.find(option.bodyItems or {}, assetId) ~= nil
                if (isDeclaredBodyItem or assetId == option.head) and not loadedRoot:IsA("Accessory") then
                    local okBody, count = pcall(attachBodyPartsLocal, loadedRoot, rig, assetId, option.headTexture)
                    if okBody and type(count) == "number" and count > 0 then
                        attached = attached + count
                        rootAttached = true
                    end
                end

                for _, accessory in ipairs(accessories) do
                    local okAcc, result = pcall(attachAccessoryLocal, accessory, rig, rootPart, assetId)
                    if okAcc and result then
                        attached = attached + 1
                        rootAttached = true
                    else
                        pcall(function() accessory:Destroy() end)
                    end
                end

                if not rootAttached then
                    local anchor = rootPart
                    if assetId == option.head then anchor = rig:FindFirstChild("Head") or rootPart end
                    local okLoose, result = pcall(attachLooseVisual, loadedRoot, rig, rootPart, assetId, option.headTexture, anchor)
                    if okLoose and result then attached = attached + 1 end
                end

                if loadedRoot.Parent == nil then pcall(function() loadedRoot:Destroy() end) end
            end
        end
    end

    if option.face then pcall(applyLocalFace, rig, option.face) end

    if attached == 0 then
        pcall(function() rig:Destroy() end)
        return nil
    end

    -- Static, clean rig for the ViewportFrame.
    for _, object in ipairs(rig:GetDescendants()) do
        if object:IsA("BasePart") then
            object.Anchored = true
            object.CanCollide = false
            object.CastShadow = false
            object.LocalTransparencyModifier = 0
        elseif object:IsA("LuaSourceContainer") then
            pcall(function() object:Destroy() end)
        end
    end
    local root = rig:FindFirstChild("HumanoidRootPart")
    if root then root.Transparency = 1 end
    rig.Name = "RivalOutfitPreviewRig_" .. tostring(option.label or outfitIndex)
    return rig
end,
cleanup = function()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
end,
}

end

local SkinChanger = {}
do
    local originalHumanoidDesc = nil
    local originalClothes = {shirt = nil, pants = nil, tShirt = nil}
    local originalAccessories = {}

    local function cacheOriginalPlayerAvatar()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- Cache HumanoidDescription if possible (guarantees 100% exact player avatar restore!)
        if hum and not originalHumanoidDesc then
            pcall(function()
                originalHumanoidDesc = hum:GetAppliedDescription()
            end)
            if not originalHumanoidDesc then
                pcall(function()
                    originalHumanoidDesc = Players:GetHumanoidDescriptionFromUserId(LP.UserId)
                end)
            end
        end

        -- Cache direct clothing instances
        if not originalClothes.cached then
            originalClothes.cached = true
            local s = char:FindFirstChildWhichIsA("Shirt")
            local p = char:FindFirstChildWhichIsA("Pants")
            local t = char:FindFirstChildWhichIsA("ShirtGraphic")
            originalClothes.shirt = s and s.ShirtTemplate or nil
            originalClothes.pants = p and p.PantsTemplate or nil
            originalClothes.tShirt = t and t.Graphic or nil
        end

        -- Cache original accessories
        if #originalAccessories == 0 then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Accessory") or item:IsA("Hat") then
                    pcall(function()
                        table.insert(originalAccessories, item:Clone())
                    end)
                end
            end
        end
    end

    local BLEED_PACKS = {
        ["Off"] = {
            name = "Default Skin",
            shirt = nil,
            pants = nil,
            headMesh = nil,
            headTexture = nil,
            headColor = Color3.fromRGB(253, 234, 141),
            torsoColor = Color3.fromRGB(13, 105, 172),
            limbColor = Color3.fromRGB(218, 134, 122),
            hatId = nil,
        },
        ["1"] = {
            name = "Outfit 1",
            accessory = 306969564,
            offset = Vector3.new(0, 0.3, 0),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=10632503795",
            pants = "http://www.roblox.com/asset/?id=123161592384863",
            headColor = Color3.fromRGB(240, 240, 240),
            torsoColor = Color3.fromRGB(25, 25, 30),
            limbColor = Color3.fromRGB(20, 20, 25),
            hatId = 306969564,
        },
        ["2"] = {
            name = "Outfit 2",
            accessory = 1744060292,
            offset = Vector3.new(0, 1.4, -0.2),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=11526718530",
            pants = "http://www.roblox.com/asset/?id=93710523210027",
            headColor = Color3.fromRGB(20, 20, 30),
            torsoColor = Color3.fromRGB(15, 35, 60),
            limbColor = Color3.fromRGB(15, 25, 45),
            hatId = 1744060292,
        },
        ["3"] = {
            name = "Outfit 3",
            accessory = 112564966849233,
            offset = Vector3.new(0, 0.6, 0),
            headMesh = "http://www.roblox.com/asset/?id=134079402",
            headTexture = "http://www.roblox.com/asset/?id=133940918",
            shirt = "http://www.roblox.com/asset/?id=11849088376",
            pants = "http://www.roblox.com/asset/?id=16534673928",
            headColor = Color3.fromRGB(30, 30, 35),
            torsoColor = Color3.fromRGB(20, 20, 22),
            limbColor = Color3.fromRGB(18, 18, 20),
            hatId = 112564966849233,
        },
        ["Best1"] = {
            name = "Outfit 4",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(75, 90, 140),
            limbColor = Color3.fromRGB(65, 80, 130),
            hatId = nil,
            bestOutfitIndex = 1,
        },
        ["Best2"] = {
            name = "Outfit 5",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(85, 55, 125),
            limbColor = Color3.fromRGB(75, 45, 115),
            hatId = nil,
            bestOutfitIndex = 2,
        },
        ["Best3"] = {
            name = "Outfit 6",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(45, 75, 115),
            limbColor = Color3.fromRGB(35, 65, 105),
            hatId = nil,
            bestOutfitIndex = 3,
        },
        ["Best4"] = {
            name = "Outfit 7",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(40, 40, 55),
            limbColor = Color3.fromRGB(30, 30, 45),
            hatId = nil,
            bestOutfitIndex = 4,
        },
        ["Best5"] = {
            name = "Outfit 8",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(130, 80, 120),
            limbColor = Color3.fromRGB(120, 70, 110),
            hatId = nil,
            bestOutfitIndex = 5,
        },
        ["Best6"] = {
            name = "Outfit 9",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(45, 45, 65),
            limbColor = Color3.fromRGB(35, 35, 55),
            hatId = nil,
            bestOutfitIndex = 6,
        },
        ["Best7"] = {
            name = "Outfit 10",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(25, 25, 35),
            limbColor = Color3.fromRGB(15, 15, 25),
            hatId = nil,
            bestOutfitIndex = 7,
        },
        ["Best8"] = {
            name = "Outfit 11",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(30, 70, 100),
            limbColor = Color3.fromRGB(20, 60, 90),
            hatId = nil,
            bestOutfitIndex = 8,
        },
        ["Best9"] = {
            name = "Outfit 12",
            headColor = Color3.fromRGB(225, 205, 190),
            torsoColor = Color3.fromRGB(70, 45, 90),
            limbColor = Color3.fromRGB(60, 35, 80),
            hatId = nil,
            bestOutfitIndex = 9,
        },
    }

    local PACK_ORDER = {"Off", "1", "2", "3", "Best1", "Best2", "Best3", "Best4", "Best5", "Best6", "Best7", "Best8", "Best9"}

    local function clearCurrentOutfit(char)
        if not char then return end
        for _, obj in ipairs(char:GetChildren()) do
            if obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("Accessory") or obj:IsA("Hat") then
                pcall(function() obj:Destroy() end)
            end
        end
    end

    local function restoreOriginalAvatar()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")

        -- Attempt official HumanoidDescription restore
        local appliedDesc = false
        if hum and originalHumanoidDesc then
            pcall(function()
                hum:ApplyDescription(originalHumanoidDesc)
                appliedDesc = true
            end)
        end

        if not appliedDesc then
            -- Fallback restore via cached clothing and accessories
            clearCurrentOutfit(char)

            if originalClothes.shirt then
                local s = Instance.new("Shirt", char)
                s.ShirtTemplate = originalClothes.shirt
            end
            if originalClothes.pants then
                local p = Instance.new("Pants", char)
                p.PantsTemplate = originalClothes.pants
            end
            if originalClothes.tShirt then
                local t = Instance.new("ShirtGraphic", char)
                t.Graphic = originalClothes.tShirt
            end

            -- Restore original accessories
            for _, acc in ipairs(originalAccessories) do
                pcall(function()
                    local clone = acc:Clone()
                    if hum then
                        hum:AddAccessory(clone)
                    else
                        clone.Parent = char
                    end
                end)
            end
        end

        -- Guarantee head mesh and face are fully visible
        local head = char:FindFirstChild("Head")
        if head then
            head.Transparency = 0
            local sm = head:FindFirstChildWhichIsA("SpecialMesh")
            if sm then
                sm.MeshType = Enum.MeshType.Head
                sm.Scale = Vector3.new(1.25, 1.25, 1.25)
            end
            local face = head:FindFirstChild("face")
            if face then face.Transparency = 0 end
        end
    end

    local function applyBleedSkin(packKey)
        local config = BLEED_PACKS[packKey]
        if not config then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head") or char:WaitForChild("Head", 5)
        if not head then return end

        clearCurrentOutfit(char)

        -- Apply head mesh
        if config.headMesh then
            pcall(function()
                if head:IsA("MeshPart") then
                    head.MeshId = config.headMesh
                    if config.headTexture then head.TextureID = config.headTexture end
                else
                    local sm = head:FindFirstChildWhichIsA("SpecialMesh") or Instance.new("SpecialMesh", head)
                    sm.MeshType = Enum.MeshType.FileMesh
                    sm.MeshId = config.headMesh
                    sm.TextureId = config.headTexture or ""
                end
            end)
        end

        -- Apply shirt
        if config.shirt then
            pcall(function()
                local s = Instance.new("Shirt", char)
                s.Name = "Shirt"
                s.ShirtTemplate = config.shirt
            end)
        end

        -- Apply pants
        if config.pants then
            pcall(function()
                local p = Instance.new("Pants", char)
                p.Name = "Pants"
                p.PantsTemplate = config.pants
            end)
        end

        -- Apply accessory
        if config.accessory then
            task.spawn(function()
                local asset = nil
                pcall(function() asset = InsertService:LoadAsset(config.accessory) end)
                if not asset then
                    pcall(function()
                        local objs = game:GetObjects("rbxassetid://" .. tostring(config.accessory))
                        if objs and #objs > 0 then asset = objs[1] end
                    end)
                end
                if asset then
                    local acc = asset:IsA("Accessory") and asset or asset:FindFirstChildWhichIsA("Accessory")
                    if acc then
                        acc.Name = "BleedHat"
                        local handle = acc:FindFirstChild("Handle")
                        if handle and config.offset then
                            local att = handle:FindFirstChildWhichIsA("Attachment") or Instance.new("Attachment", handle)
                            att.Position = att.Position + config.offset
                        end
                        if hum then hum:AddAccessory(acc) else acc.Parent = char end
                    end
                end
            end)
        end
    end

    local bestOutfitsModule = nil
    local bestOutfitsBusy = false
    -- Keep the selected skin key so it can be restored after respawn.
    local activeSkinPackKey = "Off"
    local skinRespawnToken = 0

    function SkinChanger.apply(packKey)
        activeSkinPackKey = tostring(packKey or "Off")
        skinRespawnToken = skinRespawnToken + 1
        cacheOriginalPlayerAvatar()
        local bestIndex = tostring(packKey):match("^Best(%d+)$")
        if bestIndex then
            if bestOutfitsBusy then return end
            bestOutfitsBusy = true
            task.spawn(function()
                if not bestOutfitsModule then
                    local ok, module = pcall(createBestOutfitsModule)
                    if ok and type(module) == "table" then bestOutfitsModule = module end
                end
                if bestOutfitsModule and type(bestOutfitsModule.apply) == "function" then
                    local ok, applied = pcall(bestOutfitsModule.apply, tonumber(bestIndex))
                    if not ok then
                        warn("[M10RU Skin Changer] Best Outfit failed: " .. tostring(applied))
                    elseif applied == false then
                        warn("[M10RU Skin Changer] Best Outfit " .. tostring(bestIndex) .. " could not fully apply; check asset loading/permissions in the executor console.")
                    end
                else
                    warn("[M10RU Skin Changer] Could not initialize Best Outfits module.")
                end
                bestOutfitsBusy = false
            end)
            return
        end

        if bestOutfitsModule and type(bestOutfitsModule.remove) == "function" then
            pcall(bestOutfitsModule.remove)
        end
        if packKey == "Off" then
            restoreOriginalAvatar()
        else
            applyBleedSkin(packKey)
        end
    end

    -- Reapply the last selected skin after Roblox creates the new character.
    if not _G.__M10RUSkinChangerRespawnHook then
        _G.__M10RUSkinChangerRespawnHook = true
        LP.CharacterAdded:Connect(function(newCharacter)
            local token = skinRespawnToken
            task.spawn(function()
                -- Give Roblox time to create the Humanoid, head and body parts.
                for _ = 1, 20 do
                    task.wait(0.25)
                    if LP.Character ~= newCharacter then return end
                    local hum = newCharacter:FindFirstChildOfClass("Humanoid")
                    local root = newCharacter:FindFirstChild("HumanoidRootPart")
                    if hum and root and hum.Health > 0 then break end
                end
                task.wait(0.35)
                if LP.Character ~= newCharacter or token ~= skinRespawnToken then return end
                local key = activeSkinPackKey
                if not key or key == "Off" then return end
                if key:match("^Best%d+$") then
                    bestOutfitsBusy = false
                    if not bestOutfitsModule then
                        local ok, module = pcall(createBestOutfitsModule)
                        if ok and type(module) == "table" then bestOutfitsModule = module end
                    end
                    if bestOutfitsModule and type(bestOutfitsModule.apply) == "function" then
                        local index = tonumber(key:match("^Best(%d+)$"))
                        if index then
                            local ok, err = pcall(bestOutfitsModule.apply, index)
                            if not ok then warn("[M10RU Skin Changer] Respawn reapply failed: " .. tostring(err)) end
                        end
                    end
                else
                    pcall(function() applyBleedSkin(key) end)
                end
            end)
        end)
    end

    -- -------------------------------------------------------------
    -- FULLSCREEN 3D CAROUSEL VIEWER
    -- -------------------------------------------------------------
    local viewerGui = nil
    local currentSelectedIndex = 1
    local isFocusedOnSelected = false
    local rotateConns = {}

    local function cleanupViewer()
        for _, c in ipairs(rotateConns) do pcall(function() c:Disconnect() end) end
        rotateConns = {}
        if viewerGui then
            viewerGui:Destroy()
            viewerGui = nil
        end
        isFocusedOnSelected = false
    end

    function SkinChanger.openViewer()
        cacheOriginalPlayerAvatar()
        if viewerGui then cleanupViewer() end

        local parent = getSafeGuiParent()
        viewerGui = Instance.new("ScreenGui")
        viewerGui.Name = "M10RUSkinViewer"
        viewerGui.ResetOnSpawn = false
        viewerGui.DisplayOrder = 1000
        viewerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        viewerGui.Parent = parent

        local backdrop = Instance.new("Frame")
        backdrop.Size = UDim2.fromScale(1, 1)
        backdrop.BackgroundColor3 = Color3.fromRGB(8, 5, 14)
        backdrop.BackgroundTransparency = 0.25
        backdrop.Parent = viewerGui

        -- Top Header
        local topBar = Instance.new("Frame")
        topBar.Size = UDim2.new(1, 0, 0, 56)
        topBar.BackgroundColor3 = Color3.fromRGB(18, 12, 28)
        topBar.BorderSizePixel = 0
        topBar.Parent = backdrop

        local headerTitle = Instance.new("TextLabel")
        headerTitle.Size = UDim2.new(0, 300, 1, 0)
        headerTitle.Position = UDim2.new(0, 24, 0, 0)
        headerTitle.BackgroundTransparency = 1
        headerTitle.Text = "SKIN CHANGER"
        headerTitle.TextColor3 = Color3.fromRGB(240, 220, 255)
        headerTitle.Font = Enum.Font.GothamBlack
        headerTitle.TextSize = 16
        headerTitle.TextXAlignment = Enum.TextXAlignment.Left
        headerTitle.Parent = topBar

        local closeXBtn = Instance.new("TextButton")
        closeXBtn.Size = UDim2.new(0, 34, 0, 34)
        closeXBtn.Position = UDim2.new(1, -48, 0.5, -17)
        closeXBtn.BackgroundColor3 = Color3.fromRGB(85, 25, 40)
        closeXBtn.Text = "X"
        closeXBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        closeXBtn.TextSize = 14
        closeXBtn.Font = Enum.Font.GothamBold
        closeXBtn.Parent = topBar
        Instance.new("UICorner", closeXBtn).CornerRadius = UDim.new(0, 8)
        closeXBtn.MouseButton1Click:Connect(cleanupViewer)

        -- Central Carousel Area
        local carousel = Instance.new("Frame")
        carousel.Name = "CarouselArea"
        carousel.Size = UDim2.new(1, -80, 1, -160)
        carousel.Position = UDim2.new(0, 40, 0, 70)
        carousel.BackgroundTransparency = 1
        carousel.Parent = backdrop

        -- Navigation Arrows
        local leftArrow = Instance.new("TextButton")
        leftArrow.Size = UDim2.new(0, 52, 0, 52)
        leftArrow.Position = UDim2.new(0, 14, 0.5, -26)
        leftArrow.BackgroundColor3 = Color3.fromRGB(40, 20, 68)
        leftArrow.Text = "◀"
        leftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
        leftArrow.TextSize = 22
        leftArrow.Font = Enum.Font.GothamBold
        leftArrow.ZIndex = 60
        leftArrow.Parent = backdrop
        Instance.new("UICorner", leftArrow).CornerRadius = UDim.new(1, 0)
        local lStroke = Instance.new("UIStroke", leftArrow)
        lStroke.Color = Color3.fromRGB(175, 92, 255)
        lStroke.Thickness = 1.5

        local rightArrow = Instance.new("TextButton")
        rightArrow.Size = UDim2.new(0, 52, 0, 52)
        rightArrow.Position = UDim2.new(1, -66, 0.5, -26)
        rightArrow.BackgroundColor3 = Color3.fromRGB(40, 20, 68)
        rightArrow.Text = "▶"
        rightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
        rightArrow.TextSize = 22
        rightArrow.Font = Enum.Font.GothamBold
        rightArrow.ZIndex = 60
        rightArrow.Parent = backdrop
        Instance.new("UICorner", rightArrow).CornerRadius = UDim.new(1, 0)
        local rStroke = Instance.new("UIStroke", rightArrow)
        rStroke.Color = Color3.fromRGB(175, 92, 255)
        rStroke.Thickness = 1.5

        -- Bottom Actions (Back & Confirm)
        local bottomActions = Instance.new("Frame")
        bottomActions.Size = UDim2.new(1, 0, 0, 70)
        bottomActions.Position = UDim2.new(0, 0, 1, -78)
        bottomActions.BackgroundTransparency = 1
        bottomActions.Visible = false
        bottomActions.ZIndex = 70
        bottomActions.Parent = backdrop

        local backBtn = Instance.new("TextButton")
        backBtn.Size = UDim2.new(0, 150, 0, 44)
        backBtn.Position = UDim2.new(0.5, -165, 0.5, -22)
        backBtn.BackgroundColor3 = Color3.fromRGB(60, 30, 80)
        backBtn.Text = "◀ BACK"
        backBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        backBtn.Font = Enum.Font.GothamBold
        backBtn.TextSize = 14
        backBtn.Parent = bottomActions
        Instance.new("UICorner", backBtn).CornerRadius = UDim.new(0, 8)

        local confirmBtn = Instance.new("TextButton")
        confirmBtn.Size = UDim2.new(0, 160, 0, 44)
        confirmBtn.Position = UDim2.new(0.5, 15, 0.5, -22)
        confirmBtn.BackgroundColor3 = Color3.fromRGB(35, 160, 75)
        confirmBtn.Text = "CONFIRM ✔"
        confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        confirmBtn.Font = Enum.Font.GothamBlack
        confirmBtn.TextSize = 14
        confirmBtn.Parent = bottomActions
        Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 8)

        -- Helper to create 3D avatar preview with accurate clothes & accessories
        local function createSkin3DModel(packKey)
            local packData = BLEED_PACKS[packKey]

            -- Best Outfits use a real preview assembled from Rival's outfit asset IDs,
            -- rather than M10RU's generic colored dummy.
            -- Preview model generation from catalog descriptions is unreliable in some
            -- executor environments. Keep the existing M10RU preview builder as a safe
            -- fallback so the carousel never receives a nil/blank model. Actual outfit
            -- application still uses the Rival module when the user confirms.
            if packData and packData.bestOutfitIndex and not bestOutfitsModule then
                local ok, module = pcall(createBestOutfitsModule)
                if ok and type(module) == "table" then bestOutfitsModule = module end
            end

            local model = Instance.new("Model")
            model.Name = "SkinModel_" .. packKey

            local hum = Instance.new("Humanoid")
            hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
            hum.Parent = model

            local torso = Instance.new("Part", model)
            torso.Name = "Torso"
            torso.Size = Vector3.new(2, 2, 1)
            torso.Position = Vector3.new(0, 0, 0)
            torso.Color = packData.torsoColor
            torso.Material = Enum.Material.SmoothPlastic
            torso.Anchored = true
            torso.CanCollide = false

            local head = Instance.new("Part", model)
            head.Name = "Head"
            head.Size = Vector3.new(1.2, 1.2, 1.2)
            head.Position = Vector3.new(0, 1.5, 0)
            head.Color = packData.headColor
            head.Material = Enum.Material.SmoothPlastic
            head.Anchored = true
            head.CanCollide = false

            local sm = Instance.new("SpecialMesh", head)
            if packData.headMesh then
                sm.MeshType = Enum.MeshType.FileMesh
                sm.MeshId = packData.headMesh
                sm.TextureId = packData.headTexture or ""
            else
                sm.MeshType = Enum.MeshType.Head
                sm.Scale = Vector3.new(1.25, 1.25, 1.25)
            end

            local function makeLimb(name, pos, color)
                local part = Instance.new("Part", model)
                part.Name = name
                part.Size = Vector3.new(1, 2, 1)
                part.Position = pos
                part.Color = color
                part.Material = Enum.Material.SmoothPlastic
                part.Anchored = true
                part.CanCollide = false
                return part
            end

            makeLimb("Left Arm", Vector3.new(-1.5, 0, 0), packData.limbColor)
            makeLimb("Right Arm", Vector3.new(1.5, 0, 0), packData.limbColor)
            makeLimb("Left Leg", Vector3.new(-0.5, -2, 0), packData.limbColor)
            makeLimb("Right Leg", Vector3.new(0.5, -2, 0), packData.limbColor)

            if packData.shirt then
                local s = Instance.new("Shirt", model)
                s.ShirtTemplate = packData.shirt
            end
            if packData.pants then
                local p = Instance.new("Pants", model)
                p.PantsTemplate = packData.pants
            end

            if packData.hatId then
                local hatPart = Instance.new("Part", model)
                hatPart.Name = "Hat"
                hatPart.Size = Vector3.new(1.5, 1, 1.5)
                hatPart.Position = head.Position + (packData.offset or Vector3.new(0, 0.4, 0))
                hatPart.Color = Color3.fromRGB(240, 190, 40)
                hatPart.Anchored = true
                hatPart.CanCollide = false
                local hatMesh = Instance.new("SpecialMesh", hatPart)
                hatMesh.MeshType = Enum.MeshType.FileMesh
                hatMesh.MeshId = "rbxassetid://" .. tostring(packData.hatId)
            end

            return model
        end

        local skinCards = {}
        local numSkins = #PACK_ORDER

        for i, packKey in ipairs(PACK_ORDER) do
            local packData = BLEED_PACKS[packKey]

            local card = Instance.new("Frame")
            card.Name = "SkinCard_" .. packKey
            card.Size = UDim2.new(0, 220, 0, 290)
            card.AnchorPoint = Vector2.new(0.5, 0.5)
            card.BackgroundColor3 = Color3.fromRGB(20, 12, 34)
            card.BorderSizePixel = 0
            card.ZIndex = 40
            card.Parent = carousel
            Instance.new("UICorner", card).CornerRadius = UDim.new(0, 14)

            local cardStroke = Instance.new("UIStroke", card)
            cardStroke.Color = Color3.fromRGB(175, 92, 255)
            cardStroke.Thickness = 1.5
            cardStroke.Transparency = 0.4

            local viewport = Instance.new("ViewportFrame")
            viewport.Size = UDim2.new(1, -20, 0, 220)
            viewport.Position = UDim2.new(0, 10, 0, 10)
            viewport.BackgroundTransparency = 1
            viewport.BackgroundColor3 = Color3.fromRGB(20, 12, 34)
            viewport.BorderSizePixel = 0
            viewport.LightColor = Color3.fromRGB(255, 255, 255)
            viewport.LightDirection = Vector3.new(-1, -2, -1)
            viewport.Ambient = Color3.fromRGB(210, 210, 210)
            viewport.ZIndex = 42
            viewport.Parent = card
            Instance.new("UICorner", viewport).CornerRadius = UDim.new(0, 10)

            local vpCamera = Instance.new("Camera")
            vpCamera.FieldOfView = 48
            viewport.CurrentCamera = vpCamera
            vpCamera.Parent = viewport

            local char3D = createSkin3DModel(packKey)
            char3D.Parent = viewport

            local previewCenter = Vector3.new(0, -0.3, 0)
            local previewDist = 6.4
            pcall(function()
                local boundsCFrame, boundsSize = char3D:GetBoundingBox()
                previewCenter = boundsCFrame.Position + Vector3.new(0, boundsSize.Y * 0.03, 0)
                local largest = math.max(boundsSize.X, boundsSize.Y, boundsSize.Z, 3)
                previewDist = (largest * 0.62) / math.tan(math.rad(vpCamera.FieldOfView / 2))
                previewDist = math.clamp(previewDist, 4.0, 10.5)
            end)

            -- SKINS 4-12 (Best outfits): the blocky dummy cannot show what the
            -- outfit really looks like, so build the true rig from its
            -- HumanoidDescription in the background and swap it in when ready.
            -- The dummy stays on screen until then, and is kept if it fails.
            if packData and packData.bestOutfitIndex then
                local loadingLbl = Instance.new("TextLabel")
                loadingLbl.Name = "PreviewLoading"
                loadingLbl.Size = UDim2.new(1, 0, 0, 20)
                loadingLbl.Position = UDim2.new(0, 0, 0.5, -10)
                loadingLbl.BackgroundTransparency = 1
                loadingLbl.Text = "LOADING..."
                loadingLbl.TextColor3 = Color3.fromRGB(224, 170, 255)
                loadingLbl.Font = Enum.Font.GothamBlack
                loadingLbl.TextSize = 12
                loadingLbl.ZIndex = 46
                loadingLbl.Parent = viewport

                task.spawn(function()
                    -- Stagger the background builds so the loader is not hit
                    -- by nine outfits at the exact same moment.
                    task.wait(0.12 * (i - 1))
                    local function finish()
                        if loadingLbl.Parent then pcall(function() loadingLbl:Destroy() end) end
                    end
                    if not bestOutfitsModule then
                        local okModule, module = pcall(createBestOutfitsModule)
                        if okModule and type(module) == "table" then bestOutfitsModule = module end
                    end
                    local module = bestOutfitsModule
                    local function tryBuild(builder)
                        if type(builder) ~= "function" then return nil end
                        local ok, model = pcall(builder, packData.bestOutfitIndex)
                        if ok and typeof(model) == "Instance" and model:IsA("Model") then return model end
                        if typeof(model) == "Instance" then pcall(function() model:Destroy() end) end
                        return nil
                    end
                    -- 1) HumanoidDescription rig (needs MarketplaceService,
                    --    which some executors block).
                    local realModel = module and tryBuild(module.previewModel)
                    -- 2) Local rig: clone the avatar and dress it with the same
                    --    loaders used when the outfit is really applied.
                    if not realModel then
                        realModel = module and tryBuild(module.previewRigModel)
                    end
                    if not realModel then finish(); return end

                    -- Clean rig for the ViewportFrame: no scripts, no physics.
                    for _, object in ipairs(realModel:GetDescendants()) do
                        if object:IsA("BasePart") then
                            object.Anchored = true
                            object.CanCollide = false
                            object.CastShadow = false
                            object.LocalTransparencyModifier = 0
                        elseif object:IsA("LuaSourceContainer") then
                            pcall(function() object:Destroy() end)
                        end
                    end
                    local realHumanoid = realModel:FindFirstChildOfClass("Humanoid")
                    if realHumanoid then
                        realHumanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    end
                    realModel.Name = "SkinModel_" .. tostring(packKey)

                    if not viewport.Parent then
                        pcall(function() realModel:Destroy() end)
                        finish(); return
                    end
                    pcall(function() char3D:Destroy() end)
                    realModel.Parent = viewport
                    -- Re-frame the orbiting camera on the real rig.
                    pcall(function()
                        local boundsCFrame, boundsSize = realModel:GetBoundingBox()
                        previewCenter = boundsCFrame.Position + Vector3.new(0, boundsSize.Y * 0.03, 0)
                        local largest = math.max(boundsSize.X, boundsSize.Y, boundsSize.Z, 3)
                        previewDist = (largest * 0.62) / math.tan(math.rad(vpCamera.FieldOfView / 2))
                        previewDist = math.clamp(previewDist, 4.0, 10.5)
                    end)
                    finish()
                end)
            end

            local rotAngle = 0
            local rotConn = RunService.RenderStepped:Connect(function(dt)
                rotAngle = (rotAngle + dt * 28) % 360
                local rad = math.rad(rotAngle)
                local dist = (isFocusedOnSelected and currentSelectedIndex == i) and previewDist * 0.88 or previewDist
                local camPos = previewCenter + Vector3.new(math.sin(rad) * dist, 0.15 * dist, math.cos(rad) * dist)
                vpCamera.CFrame = CFrame.new(camPos, previewCenter)
            end)
            table.insert(rotateConns, rotConn)

            -- Clean Title Only (No description text!)
            local titleLbl = Instance.new("TextLabel")
            titleLbl.Size = UDim2.new(1, -20, 0, 36)
            titleLbl.Position = UDim2.new(0, 10, 0, 240)
            titleLbl.BackgroundTransparency = 1
            titleLbl.Text = packData.name
            titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            titleLbl.Font = Enum.Font.GothamBlack
            titleLbl.TextSize = 14
            titleLbl.ZIndex = 43
            titleLbl.Parent = card

            local selectHit = Instance.new("TextButton")
            selectHit.Size = UDim2.fromScale(1, 1)
            selectHit.BackgroundTransparency = 1
            selectHit.Text = ""
            selectHit.ZIndex = 45
            selectHit.Parent = card

            skinCards[i] = {
                card = card,
                viewport = viewport,
                stroke = cardStroke,
                packKey = packKey,
            }

            selectHit.MouseButton1Click:Connect(function()
                if not isFocusedOnSelected then
                    currentSelectedIndex = i
                    SkinChanger.focusSelected()
                end
            end)
        end

        local function updateCarouselPositions(animated)
            local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            local centerOffset = 0.5
            
            for i, item in ipairs(skinCards) do
                local offsetIndex = i - currentSelectedIndex
                local targetScaleX = centerOffset + (offsetIndex * 0.32)
                local targetSize = UDim2.new(0, 220, 0, 290)
                local targetTransp = math.abs(offsetIndex) > 1 and 0.6 or 0
                local isCurrent = (i == currentSelectedIndex)

                item.card.ZIndex = isCurrent and 48 or 35
                item.card.Visible = math.abs(offsetIndex) <= 2

                if animated then
                    TweenService:Create(item.card, tweenInfo, {
                        Position = UDim2.fromScale(targetScaleX, 0.5),
                        Size = targetSize,
                        BackgroundTransparency = targetTransp,
                    }):Play()
                    TweenService:Create(item.stroke, tweenInfo, {
                        Transparency = isCurrent and 0.1 or 0.6,
                        Color = isCurrent and Color3.fromRGB(255, 175, 50) or Color3.fromRGB(175, 92, 255),
                        Thickness = isCurrent and 2 or 1,
                    }):Play()
                else
                    item.card.Position = UDim2.fromScale(targetScaleX, 0.5)
                    item.card.Size = targetSize
                    item.card.BackgroundTransparency = targetTransp
                    item.stroke.Transparency = isCurrent and 0.1 or 0.6
                end
            end
        end

        function SkinChanger.focusSelected()
            isFocusedOnSelected = true
            bottomActions.Visible = true
            leftArrow.Visible = false
            rightArrow.Visible = false

            local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            for i, item in ipairs(skinCards) do
                if i == currentSelectedIndex then
                    item.card.Visible = true
                    item.card.ZIndex = 50
                    TweenService:Create(item.card, tweenInfo, {
                        Position = UDim2.fromScale(0.5, 0.46),
                        Size = UDim2.new(0, 290, 0, 370),
                        BackgroundTransparency = 0,
                    }):Play()
                    TweenService:Create(item.viewport, tweenInfo, {
                        Size = UDim2.new(1, -24, 0, 290),
                    }):Play()
                    TweenService:Create(item.stroke, tweenInfo, {
                        Transparency = 0.05,
                        Thickness = 2.5,
                        Color = Color3.fromRGB(255, 180, 50),
                    }):Play()
                else
                    TweenService:Create(item.card, TweenInfo.new(0.2), {
                        BackgroundTransparency = 1,
                    }):Play()
                    task.delay(0.2, function()
                        if isFocusedOnSelected and i ~= currentSelectedIndex then
                            item.card.Visible = false
                        end
                    end)
                end
            end
        end

        function SkinChanger.unfocusSelected()
            isFocusedOnSelected = false
            bottomActions.Visible = false
            leftArrow.Visible = true
            rightArrow.Visible = true

            local tweenInfo = TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
            for i, item in ipairs(skinCards) do
                item.card.Visible = true
                TweenService:Create(item.viewport, tweenInfo, {
                    Size = UDim2.new(1, -20, 0, 220),
                }):Play()
                TweenService:Create(item.stroke, tweenInfo, {
                    Color = Color3.fromRGB(175, 92, 255),
                }):Play()
            end
            updateCarouselPositions(true)
        end

        leftArrow.MouseButton1Click:Connect(function()
            if not isFocusedOnSelected then
                currentSelectedIndex = math.max(1, currentSelectedIndex - 1)
                updateCarouselPositions(true)
            end
        end)

        rightArrow.MouseButton1Click:Connect(function()
            if not isFocusedOnSelected then
                currentSelectedIndex = math.min(numSkins, currentSelectedIndex + 1)
                updateCarouselPositions(true)
            end
        end)

        backBtn.MouseButton1Click:Connect(function()
            SkinChanger.unfocusSelected()
        end)

        confirmBtn.MouseButton1Click:Connect(function()
            local chosenPack = PACK_ORDER[currentSelectedIndex]
            SkinChanger.apply(chosenPack)
            cleanupViewer()
        end)

        updateCarouselPositions(false)
    end
end

-- VISUALS: PRINTED-compatible ANTI-LAG, FPS BOOST, STRETCH REZ
-- ========================================================================
-- PRINTED-style Stretch Rez: 120 FOV plus the camera aspect stretch.
-- Keep FOV ownership centralized so POV and Stretch cannot fight each other.
local stretchRezConn
local function enableStretchRez()
    State.stretchRezEnabled = true
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not State.stretchRezEnabled then return end
        local camera = workspace.CurrentCamera
        if not camera then return end
        pcall(function()
            camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
        end)
    end)
end

local function disableStretchRez()
    State.stretchRezEnabled = false
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
    -- Hand the camera back: an armed POV value wins instead of a hard 70.
    local pov = State.povValue or 70
    local camera = workspace.CurrentCamera
    if camera then camera.FieldOfView = pov > 70 and pov or 70 end
end

Conns.fovControl = RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local fov = State.stretchRezEnabled and 120 or (State.povValue or 70)
    if fov > 70 and camera.FieldOfView ~= fov then camera.FieldOfView = fov end
end)
UI.addCleanup(function()
    if Conns.fovControl then Conns.fovControl:Disconnect(); Conns.fovControl = nil end
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
end)

local function isLocalCharacterAsset(obj)
    -- Never strip accessories, faces, textures, or outfit visuals from the local
    -- character. Best Outfits are assembled from local body/accessory instances.
    local character = LP.Character
    if not character or not obj then return false end
    local ok, inside = pcall(function()
        return obj == character or obj:IsDescendantOf(character)
    end)
    return ok and inside == true
end

local function applyAntiLagDerender(obj)
    if isLocalCharacterAsset(obj) then return end
    pcall(function()
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            obj:Destroy()
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

local defLightBrightness, defLightClock, defLightAmbient
local function enableAntiLag()
    State.antiLagEnabled = true
    defLightBrightness = defLightBrightness or Lighting.Brightness
    defLightClock = defLightClock or Lighting.ClockTime
    defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
    Lighting.GlobalShadows = false
    Lighting.FogEnd = 1e10
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
                e.Enabled = false
            end
        end)
    end
    for _, obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end
    if Conns.antiLagDesc then Conns.antiLagDesc:Disconnect() end
    Conns.antiLagDesc = workspace.DescendantAdded:Connect(function(obj)
        if State.antiLagEnabled then applyAntiLagDerender(obj) end
    end)
end

local function disableAntiLag()
    State.antiLagEnabled = false
    if Conns.antiLagDesc then Conns.antiLagDesc:Disconnect(); Conns.antiLagDesc = nil end
    pcall(function()
        if defLightBrightness then Lighting.Brightness = defLightBrightness end
        if defLightClock then Lighting.ClockTime = defLightClock end
        if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
        Lighting.ExposureCompensation = 0
    end)
end

local function applyFPSBoost()
    State.fpsBoostEnabled = true
    pcall(function() if setfpscap then setfpscap(999999) end end)
    local function optimizeObj(v)
        -- FPS Boost may optimize the world, but must not erase the chosen skin:
        -- keep character accessories, faces, SpecialMesh textures and body overlays.
        if isLocalCharacterAsset(v) then return end
        pcall(function()
            if v:IsA("Model") then
                v.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled
            elseif v:IsA("MeshPart") then
                v.CastShadow = false
                v.DoubleSided = false
                v.RenderFidelity = Enum.RenderFidelity.Performance
            elseif v:IsA("BasePart") then
                v.CastShadow = false
                v.Material = Enum.Material.Plastic
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") then
                v.Transparency = 1
            elseif v:IsA("SpecialMesh") then
                v.TextureId = ""
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                v.Enabled = false
            elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then
                v:Destroy()
            elseif v:IsA("Attachment") then
                v.Visible = false
            end
        end)
    end
    for _, v in pairs(workspace:GetDescendants()) do optimizeObj(v) end
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
        Lighting.Brightness = 0
        local ter = workspace:FindFirstChildOfClass("Terrain")
        if ter then
            ter.WaterReflectance = 0
            ter.WaterTransparency = 0.7
            ter.WaterWaveSize = 0
            ter.WaterWaveSpeed = 0
        end
    end)
    if Conns.fpsBoostDesc then Conns.fpsBoostDesc:Disconnect() end
    Conns.fpsBoostDesc = workspace.DescendantAdded:Connect(function(v)
        if State.fpsBoostEnabled then task.spawn(optimizeObj, v) end
    end)
end

local function disableFPSBoost()
    State.fpsBoostEnabled = false
    if Conns.fpsBoostDesc then Conns.fpsBoostDesc:Disconnect(); Conns.fpsBoostDesc = nil end
end

-- ========================================================================
-- CONFIGURATION SYSTEM (JSON SAVING / LOADING)
-- ========================================================================
local function saveConfig()
    local function ks(e)
        return {kb = e.kb and e.kb.Name or nil, gp = e.gp and e.gp.Name or nil}
    end
    local cfg = {
        normalSpeed       = State.NS,
        carrySpeed        = State.CS,
        autoSwitchCarrySpeed = State.autoCarrySpeedEnabled,
        dropBrainrotKey   = ks(KB.DropBrainrot),
        autoLeftKey       = ks(KB.AutoLeft),
        autoRightKey      = ks(KB.AutoRight),
        autoBatKey        = ks(KB.AutoBat),
        laggerToggleKey   = ks(KB.LaggerToggle),
        tpFloorKey        = ks(KB.TPFloor),
        tpBatKey          = ks(KB.TpBat),
        tpBatEnabled      = State.tpBatEnabled,
        guiHideKey        = ks(KB.GuiHide),
        speedToggleKey    = ks(KB.SpeedToggle),
        autoGrabSchema    = 2,
        semiMode          = State.SemiMode,
        semiEnabled       = State.SemiEnabled,
        semiNormalOpen    = State.SemiNormalOpen,
        autoGrabStyle     = State.AutoGrabStyle,
        -- Yout AutoSteal radius is fixed at 61; the old editable radius control is gone.
        autoGrabRadius    = 61,
        autoGrabMode      = State.autoGrabMode,
        v1Scale           = State.v1Scale,
        v2Scale           = State.v2Scale,
        semiScale         = State.semiScale,
        antiRagdoll       = State.antiRagdollEnabled,
        antiRagdollMode   = State.antiRagdollMode,
        speedEngine      = "Arabi",
        infiniteJump      = State.infJumpEnabled,
        infJumpMode       = State.infJumpMode,
        medusaCounter     = State.medusaCounterEnabled,
        batCounter        = State.batCounterEnabled,
        carryMode         = State.speedMode,
        laggerMode        = State.laggerToggled,
        laggerCarryMode   = (State.laggerPhase == 2),
        laggerSpeed       = State.LAGGER_SPEED,
        laggerCarrySpeed  = State.LAGGER_CARRY_SPEED,
        autoBat           = State.autoBatEnabled,
        antiDie          = State.antiDieEnabled,
        instantResetOnDie = State.instantResetOnDieEnabled,
        antiFling         = State.antiFlingEnabled,
        bodyLockEnabled   = State.bodyLockEnabled,
        bodyLockRange     = State.bodyLockRange,
        autoSwing         = State.autoSwingEnabled,
        animPack          = State.animPack,
        unwalkEnabled     = State.unwalkEnabled,
        antiLag           = State.antiLagEnabled,
        fpsBoost          = State.fpsBoostEnabled,
        espEnabled        = State.espEnabled,
        tracersEnabled    = State.tracersEnabled,
        autoGrabStopEnabled = State.autoGrabStopEnabled,
        stretchRez        = State.stretchRezEnabled,
        autoTPEnabled     = State.autoTPEnabled,
        autoTPHeight      = State.autoTPHeight,
        autoPlayMode      = State.autoPlayMode,
        instantResetKey   = ks(KB.InstantReset),
        introEnabled      = State.introEnabled,
        skyTheme          = currentSkyTheme
    }
    local ok, json = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and json then
        safeWriteFile("m10ru_duels_config.json", json)
        safeWriteFile("m10ru_duels_backup.json", json)
    end
end
task.spawn(function()
    while task.wait(6) do
        saveConfig()
    end
end)

local function refreshSpeedModeLabel()
    if modeValLbl then
        if State.laggerToggled then
            if State.laggerPhase == 2 then
                UI.text(modeValLbl, "LAGGER CARRY")
            else
                UI.text(modeValLbl, "LAGGER NORM")
            end
        else
            if State.speedMode then
                UI.text(modeValLbl, "CARRY")
            else
                UI.text(modeValLbl, "NORMAL")
            end
        end
    end
    if Speed.laggerVisual then Speed.laggerVisual(State.laggerToggled) end
    if Speed.carryVisual then Speed.carryVisual(State.speedMode and not State.laggerToggled) end
    if Speed.mobileRefresh then Speed.mobileRefresh() end
end
Speed.refreshVisuals = refreshSpeedModeLabel

local function toggleCarryMode()
    local combined = State.laggerToggled and State.laggerPhase == 2
    if combined then
        State.laggerToggled, State.laggerPhase, State.speedMode = false, 0, true
    else
        State.speedMode = not State.speedMode
        if State.speedMode then State.laggerToggled, State.laggerPhase = false, 0 end
    end
    refreshSpeedModeLabel()
end
local function toggleLaggerMode()
    local combined = State.laggerToggled and State.laggerPhase == 2
    if combined then
        State.laggerToggled, State.laggerPhase, State.speedMode = true, 1, false
    else
        State.laggerToggled = not State.laggerToggled
        State.laggerPhase = State.laggerToggled and 1 or 0
        if State.laggerToggled then State.speedMode = false end
    end
    refreshSpeedModeLabel()
end

-- ========================================================================
-- USER INTERFACE (M10RU DUELS PURPLE / SMOOTH UI)
-- ========================================================================
local mbContainers = {}
local mbLocked = false

local function buildGui()
    local resetMobilePositions = nil
    local _setMbLockVisual = nil
    
    local BG     = UI.theme.background
    local BG2    = UI.theme.panel
    local CARD   = UI.theme.panel
    local HOV    = UI.theme.hover
    local RED    = UI.theme.accent
    local REDDIM = UI.theme.deep
    local STROKE = UI.theme.track
    local W      = UI.theme.text
    local DIM    = UI.theme.dim
    local INP    = UI.theme.panel
    local OFF    = UI.theme.track

    local targetParent = getSafeGuiParent()

    -- An inaccessible CoreGui must not stop the PlayerGui fallback.
    do
        local function removeOldGui(parent)
            if not parent then return end
            pcall(function()
                for _, name in ipairs({"M10RUDuels", "fluxduels"}) do
                    local old = parent:FindFirstChild(name)
                    if old then old:Destroy() end
                end
            end)
        end
        removeOldGui(targetParent)
        removeOldGui(LP:FindFirstChild("PlayerGui"))
        pcall(function() removeOldGui(game:GetService("CoreGui")) end)
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "M10RUDuels"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    protectGuiObject(gui)
    gui.Parent = targetParent
    UI.root = gui
    gui.Destroying:Connect(UI.destroy)

    local main = Instance.new("CanvasGroup", gui)
    main.Name = "M10RUDuelsSettings"
    main.Size = UDim2.new(0, 310, 0, 520)
    main.AnchorPoint = Vector2.new(0.5, 0.5)
    main.Position = UDim2.new(0.5, 0, 0.5, 0)
    main.BackgroundColor3 = BG
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(157, 78, 221)
    mainStroke.Thickness = 1.6
    mainStroke.Transparency = 0.15

    -- ==================== WINDOW LAYOUT / NUMERIC SCALE ====================
    -- Scale keeps the existing window-size behavior, now in smooth 10% steps.
    local Layout = {mainFactor = 1, mobileFactor = 1, controls = {}}
    do
        local function finite(value) return type(value) == "number" and value == value and math.abs(value) < math.huge end
        function Layout.normalize(value, minimum, maximum)
            value = finite(value) and value or 1
            return math.clamp(math.floor(value * 10 + 0.5) / 10, minimum, maximum)
        end
        local function readScale(path, legacy, presets, minimum, maximum)
            local value = tonumber(safeReadFile(path))
            if not finite(value) then value = presets[tonumber(safeReadFile(legacy)) or 2] or 1 end
            return Layout.normalize(value, minimum, maximum)
        end
        Layout.mainFactor = readScale("m10ruUIScaleFactor.txt", "m10ruUIScale.txt", {0.8, 1, 1.2, 1.5}, 0.8, 1.5)
        Layout.mobileFactor = readScale("m10ruMobScaleFactor.txt", "m10ruMobScale.txt", {0.7, 1, 1.3, 1.6}, 0.7, 1.6)
        function Layout.viewport()
            local camera = workspace.CurrentCamera or Camera
            local size = camera and camera.ViewportSize
            if size and size.X > 0 and size.Y > 0 then return size end
            return Vector2.new(1280, 720)
        end
        function Layout.mainSize(factor)
            local view = Layout.viewport()
            return UDim2.fromOffset(math.min(math.floor(310 * factor + 0.5), math.max(100, view.X - 24)),
                math.min(math.floor(520 * factor + 0.5), math.max(140, view.Y - 24)))
        end
        function Layout.clampMain(position, size)
            local view = Layout.viewport()
            local width, height = size.X.Offset, size.Y.Offset
            local x = position.X.Scale * view.X + position.X.Offset
            local y = position.Y.Scale * view.Y + position.Y.Offset
            local marginX = 14
            local marginY = 14
            local halfW = width / 2
            local halfH = height / 2
            x = math.clamp(x, marginX + halfW, math.max(marginX + halfW, view.X - marginX - halfW))
            y = math.clamp(y, marginY + halfH, math.max(marginY + halfH, view.Y - marginY - halfH))
            return UDim2.fromOffset(x, y)
        end
        function Layout.refresh()
            for key, control in pairs(Layout.controls) do
                local value = key == "main" and Layout.mainFactor or Layout.mobileFactor
                local minimum, maximum = key == "main" and 0.8 or 0.7, key == "main" and 1.5 or 1.6
                UI.text(control.value, tostring(math.floor(value * 100 + 0.5)) .. "%")
                UI.animate(control.minus, {TextTransparency = value <= minimum and 0.55 or 0})
                UI.animate(control.plus, {TextTransparency = value >= maximum and 0.55 or 0})
            end
        end
        function Layout.applyMain(value, save)
            Layout.mainFactor = Layout.normalize(value, 0.8, 1.5)
            local size = Layout.mainSize(Layout.mainFactor)
            UI.animate(main, {Size = size, Position = Layout.clampMain(UI.goal(main, "Position"), size)}, 0.28)
            if save then safeWriteFile("m10ruUIScaleFactor.txt", tostring(Layout.mainFactor)) end
            Layout.refresh()
        end
        -- Keep the fixed title/close button on-screen while dragging or resizing.
        local previousFilter = UI.constrainDrag
        UI.constrainDrag = function(frame, position)
            if frame == main then return Layout.clampMain(position, UI.goal(main, "Size")) end
            return previousFilter and previousFilter(frame, position) or position
        end
        local camera = workspace.CurrentCamera or Camera
        if camera and type(camera.GetPropertyChangedSignal) == "function" then
            local connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                if not UI.alive then return end
                Layout.applyMain(Layout.mainFactor, false)
                if Layout.applyMobile then Layout.applyMobile(Layout.mobileFactor, false) end
            end)
            UI.addCleanup(function() connection:Disconnect() end)
        end
        Layout.applyMain(Layout.mainFactor, false)
    end

    -- M10RU Duels Header: outside the scrolling content.
    local uiHeader = Instance.new("Frame", main)
    uiHeader.Name = "SettingsHeader"
    uiHeader.Size = UDim2.new(1, 0, 0, 114)
    uiHeader.Position = UDim2.fromOffset(0, 0)
    uiHeader.BackgroundColor3 = UI.theme.background
    uiHeader.BorderSizePixel = 0
    uiHeader.ZIndex = 20
    uiHeader.ClipsDescendants = true
    Instance.new("UICorner", uiHeader).CornerRadius = UDim.new(0, 18)
    local headerPatch = Instance.new("Frame", uiHeader)
    headerPatch.Size = UDim2.new(1, 0, 0, 18)
    headerPatch.Position = UDim2.new(0, 0, 1, -18)
    headerPatch.BackgroundColor3 = UI.theme.background
    headerPatch.BorderSizePixel = 0
    headerPatch.ZIndex = 20
    local headerLine = Instance.new("Frame", uiHeader)
    headerLine.Size = UDim2.new(1, -20, 0, 1)
    headerLine.Position = UDim2.new(0, 10, 1, -1)
    headerLine.BackgroundColor3 = UI.theme.border
    headerLine.BorderSizePixel = 0
    headerLine.ZIndex = 21

    -- Header artwork: Prominently centered in header
    local headerImage = Instance.new("ImageLabel", uiHeader)
    headerImage.Name = "HeaderAsset"
    headerImage.AnchorPoint = Vector2.new(0.5, 0)
    headerImage.Size = UDim2.new(0, 190, 0, 58)
    headerImage.Position = UDim2.new(0.5, 0, 0, 6)
    headerImage.BackgroundTransparency = 1
    headerImage.BorderSizePixel = 0
    headerImage.ZIndex = 22
    local headerAssetId = "106675514881814"
    local headerTextureId = "83382076665161"
    headerImage:SetAttribute("M10RUAssetId", headerAssetId)
    headerImage:SetAttribute("M10RUTextureId", headerTextureId)
    headerImage.Visible = false

    local headerFallback = Instance.new("TextLabel", uiHeader)
    headerFallback.Name = "HeaderTextFallback"
    headerFallback.AnchorPoint = Vector2.new(0.5, 0)
    headerFallback.Size = headerImage.Size
    headerFallback.Position = headerImage.Position
    headerFallback.BackgroundTransparency = 1
    headerFallback.Text = "M10RU"
    headerFallback.TextColor3 = UI.theme.light
    headerFallback.TextStrokeColor3 = UI.theme.accent
    headerFallback.TextStrokeTransparency = 0.15
    headerFallback.Font = Enum.Font.GothamBlack
    headerFallback.TextScaled = true
    headerFallback.ZIndex = headerImage.ZIndex

    local M10RU_HEADER_PNG_BASE64 = [[
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
wRadAAAAAElFTkSuQmCC
]]
    local function decodeBase64(value)
        local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
        value = tostring(value or ""):gsub("[^" .. alphabet .. "=]", "")
        local bits = value:gsub(".", function(char)
            if char == "=" then return "" end
            local index = alphabet:find(char, 1, true)
            if not index then return "" end
            local number = index - 1
            local output = ""
            for power = 6, 1, -1 do
                output = output .. (((number % (2 ^ power)) - (number % (2 ^ (power - 1))) > 0) and "1" or "0")
            end
            return output
        end)
        return bits:gsub("%d%d%d%d%d%d%d%d", function(byte)
            local number = 0
            for index = 1, 8 do
                if byte:sub(index, index) == "1" then number += 2 ^ (8 - index) end
            end
            return string.char(number)
        end)
    end
    task.spawn(function()
        local cacheFile = "m10ru_header_embedded.png"
        if not safeIsFile(cacheFile) then
            safeWriteFile(cacheFile, decodeBase64(M10RU_HEADER_PNG_BASE64))
        end
        local localHeaderAsset = safeGetAsset(cacheFile)
        if localHeaderAsset ~= "" and headerImage.Parent then
            headerImage.Image = localHeaderAsset
            headerImage.Visible = true
            headerFallback.Visible = false
        end
    end)
    -- The supplied logo PNG is tightly trimmed, so Fit preserves its artwork
    -- proportions while keeping all of the violet effects in the header.
    headerImage.ScaleType = Enum.ScaleType.Fit
    headerImage.ImageTransparency = 0

    -- Dedicated header handle sits above the scrolling settings content.
    local function drag(frame, handle, ignoreLock) UI.drag(frame, handle, ignoreLock) end
    local settingsDragHandle = Instance.new("Frame", uiHeader)
    settingsDragHandle.Name = "SettingsDragHandle"
    settingsDragHandle.BackgroundTransparency = 1
    settingsDragHandle.BorderSizePixel = 0
    settingsDragHandle.Position = UDim2.fromOffset(10, 0)
    settingsDragHandle.Size = UDim2.new(1, -65, 0, 68)
    settingsDragHandle.ZIndex = 24
    drag(main, settingsDragHandle)

    local menuBtn = Instance.new("TextButton", gui)
    menuBtn.Name = "OpenM10RUMenu"
    menuBtn.Size = UDim2.fromOffset(124, 44)
    menuBtn.AnchorPoint = Vector2.new(0, 0)
    menuBtn.Position = UDim2.new(0.067, 0, 0.135, 0) -- fixed top-left, matching the screenshot
    menuBtn.BackgroundColor3 = UI.theme.panel
    menuBtn.BorderSizePixel = 0
    menuBtn.Text = ""
    menuBtn.ZIndex = 21
    -- The hub logo artwork fills the whole open button (no text caption).
    local menuLogo = Instance.new("ImageLabel", menuBtn)
    menuLogo.Name = "MenuLogo"
    menuLogo.AnchorPoint = Vector2.new(0.5, 0.5)
    menuLogo.Position = UDim2.fromScale(0.5, 0.5)
    menuLogo.Size = UDim2.new(1, -6, 1, -4)
    menuLogo.BackgroundTransparency = 1
    menuLogo.ScaleType = Enum.ScaleType.Fit
    menuLogo.ZIndex = 22
    task.spawn(function()
        local attempts = 0
        while attempts < 8 do
            local assetPath = safeGetAsset("m10ru_header_embedded.png")
            if assetPath ~= "" then
                if menuLogo.Parent then menuLogo.Image = assetPath end
                return
            end
            attempts += 1
            task.wait(0.6)
        end
    end)
    menuBtn:SetAttribute("M10RUAlwaysDraggable", true)
    menuBtn.Visible = false
    Instance.new("UICorner", menuBtn).CornerRadius = UDim.new(0, 10)
    local menuStroke = Instance.new("UIStroke", menuBtn)
    menuStroke.Color = UI.theme.border
    menuStroke.Thickness = 1

    menuBtn.MouseEnter:Connect(function()
        TweenService:Create(menuBtn, TweenInfo.new(0.1), {BackgroundColor3 = UI.theme.button}):Play()
    end)
    menuBtn.MouseLeave:Connect(function()
        TweenService:Create(menuBtn, TweenInfo.new(0.1), {BackgroundColor3 = UI.theme.panel}):Play()
    end)

    local guiAnimating = false
    local lastMainPosition = UDim2.new(0, 14, 0.5, 0)

    local function showGui()
        if guiAnimating then return end
        guiAnimating = true
        UI.show(menuBtn, false)

        local targetPos = lastMainPosition or UDim2.new(0, 14, 0.5, 0)
        -- Start position: off-screen to the left (-360 pixels)
        local startPos = UDim2.new(0, -360, targetPos.Y.Scale, targetPos.Y.Offset)
        
        if UI.visibility[main] then UI.visibility[main].wanted = true end
        main.Position = startPos
        main.GroupTransparency = 1
        main.Visible = true

        -- Ultra-smooth slide in from the left side
        local tweenPos = TweenService:Create(main, TweenInfo.new(0.36, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
            Position = targetPos
        })
        local tweenFade = TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            GroupTransparency = 0
        })

        tweenPos:Play()
        tweenFade:Play()

        tweenPos.Completed:Connect(function()
            guiAnimating = false
        end)
    end

    local function hideGui()
        if guiAnimating or not main.Visible then return end
        guiAnimating = true
        lastMainPosition = main.Position

        -- Ultra-smooth slide out to the left side
        local exitPos = UDim2.new(0, -360, main.Position.Y.Scale, main.Position.Y.Offset)
        local tweenPos = TweenService:Create(main, TweenInfo.new(0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
            Position = exitPos
        })
        local tweenFade = TweenService:Create(main, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            GroupTransparency = 1
        })

        tweenPos:Play()
        tweenFade:Play()

        if UI.visibility[main] then UI.visibility[main].wanted = false end
        tweenPos.Completed:Connect(function()
            main.Visible = false
            main.Position = lastMainPosition
            guiAnimating = false
            UI.show(menuBtn, true)
        end)
    end

    local closeBtn = Instance.new("TextButton", uiHeader)
    closeBtn.Size = UDim2.new(0, 28, 0, 28)
    closeBtn.Position = UDim2.new(1, -38, 0, 8)
    closeBtn.BackgroundColor3 = UI.theme.button
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = UI.theme.muted
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 26
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)
    local closeStroke = Instance.new("UIStroke", closeBtn)
    closeStroke.Color = UI.theme.border
    closeStroke.Thickness = 1
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = UI.theme.deep, TextColor3 = UI.theme.text}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = UI.theme.button, TextColor3 = UI.theme.muted}):Play()
    end)
    closeBtn.MouseButton1Click:Connect(hideGui)
    menuBtn.MouseButton1Click:Connect(showGui)
    -- The open button remains movable even while the main panel is hidden.
    UI.drag(menuBtn, menuBtn, true)

    -- The player identity badge (avatar + name) was removed: the character
    -- avatar now lives on the Auto Grab card, centred above the progress line.

    local sf = Instance.new("ScrollingFrame", main)
    sf.Name = "SettingsContent"
    sf.Size = UDim2.new(1, 0, 1, -122)
    sf.Position = UDim2.new(0, 0, 0, 120)
    sf.BackgroundTransparency = 1
    sf.BorderSizePixel = 0
    sf.ClipsDescendants = true
    sf.ScrollBarThickness = 0
    sf.ScrollBarImageTransparency = 1
    sf.CanvasSize = UDim2.new(0, 0, 0, 0)
    sf.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local ll = Instance.new("UIListLayout", sf)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Padding = UDim.new(0, 3)

    local pad = Instance.new("UIPadding", sf)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 0)
    pad.PaddingBottom = UDim.new(0, 14)

    local lo = 0
    local sectionRefs = {}
    local function LO() lo = lo + 1; return lo end

    local function mkSect(txt)
        local f = Instance.new("Frame", sf)
        sectionRefs[txt:upper()] = f
        f:SetAttribute("M10RUSection", true)
        f.Size = UDim2.new(1, 0, 0, 32)
        f.BackgroundColor3 = UI.theme.panel
        f.BorderSizePixel = 0
        f.LayoutOrder = LO()
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", f)
        stroke.Color = UI.theme.border
        stroke.Thickness = 1
        stroke.Transparency = 0.4
        local accent = Instance.new("Frame", f)
        accent.Size = UDim2.new(0, 3, 0, 16)
        accent.Position = UDim2.new(0, 8, 0.5, -8)
        accent.BackgroundColor3 = UI.theme.accent
        accent.BorderSizePixel = 0
        Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(1, -24, 1, 0)
        l.Position = UDim2.new(0, 18, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = UI.theme.light
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
    end

    local function mkRow(h)
        local f = Instance.new("Frame", sf)
        f.Size = UDim2.new(1, 0, 0, h or 38)
        f.BackgroundColor3 = CARD
        f.BorderSizePixel = 0
        f.LayoutOrder = LO()
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
        local st = Instance.new("UIStroke", f)
        st.Color = UI.theme.border
        st.Thickness = 1
        st.Transparency = 0.6
        f.MouseEnter:Connect(function()
            TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = HOV}):Play()
            TweenService:Create(st, TweenInfo.new(0.12), {Transparency = 0.2}):Play()
        end)
        f.MouseLeave:Connect(function()
            TweenService:Create(f, TweenInfo.new(0.12), {BackgroundColor3 = CARD}):Play()
            TweenService:Create(st, TweenInfo.new(0.12), {Transparency = 0.6}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.58, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = W
        l.Font = Enum.Font.GothamBold
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Size = UDim2.new(0, 38, 0, 20)
        pill.Position = UDim2.new(1, -(offset or 44), 0.5, -10)
        pill.BackgroundColor3 = OFF
        pill.BorderSizePixel = 0
        pill.ZIndex = 3
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local pillStroke = Instance.new("UIStroke", pill)
        pillStroke.Color = UI.theme.border
        pillStroke.Thickness = 1
        pillStroke.Transparency = 0.4
        local dot = Instance.new("Frame", pill)
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.Position = UDim2.new(0, 3, 0.5, -7)
        dot.BackgroundColor3 = DIM
        dot.BorderSizePixel = 0
        dot.ZIndex = 4
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        TweenService:Create(pill, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = on and UI.theme.deep or OFF
        }):Play()
        local pStroke = pill:FindFirstChildOfClass("UIStroke")
        if pStroke then
            TweenService:Create(pStroke, TweenInfo.new(0.2), {
                Color = on and UI.theme.accent or UI.theme.border,
                Transparency = on and 0.1 or 0.4
            }):Play()
        end
        TweenService:Create(dot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = on and UI.theme.text or DIM
        }):Play()
    end

    local function mkToggle(txt, cb)
        local row = mkRow(32)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 42)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 5
        clk.Activated:Connect(function() on = not on; sv(on); cb(on) end)
        pill.ZIndex = 3
        dot.ZIndex = 4
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        tb.Size = UDim2.new(0, w or 50, 0, 22)
        tb.Position = UDim2.new(1, -(xOff or 56), 0.5, -11)
        tb.BackgroundColor3 = INP
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = W
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 5
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 5)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = UI.theme.border
        bs.Thickness = 1
        tb.Focused:Connect(function() TweenService:Create(bs, TweenInfo.new(0.12), {Color = REDDIM}):Play() end)
        tb.FocusLost:Connect(function()
            TweenService:Create(bs, TweenInfo.new(0.12), {Color = UI.theme.border}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
            end
        end)
        return tb
    end

    local GAMEPAD_KEYS = {
        [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
        [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
        [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
        [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
        [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
        [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
        [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
        [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true
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

    local _anyKeyListening = false
    local function mkKB(parent, kbEntry, cb)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 46, 0, 22)
        btn.Position = UDim2.new(1, -50, 0.5, -11)
        btn.BackgroundColor3 = INP
        btn.BorderSizePixel = 0
        local function getLabel()
            return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None"
        end
        btn.Text = getLabel()
        btn.TextColor3 = W
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 5
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 5)

        local li = false
        local lc = nil
        local pv = btn.Text
        local listenStart = 0

        btn.Activated:Connect(function()
            if li then
                li = false
                _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                btn.Text = pv
                btn.TextColor3 = W
                return
            end
            pv = btn.Text
            li = true
            _anyKeyListening = true
            listenStart = tick()
            btn.Text = "..."
            btn.TextColor3 = W
            lc = UserInputService.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then
                    li = false
                    _anyKeyListening = false
                    if lc then lc:Disconnect(); lc = nil end
                    btn.Text = pv
                    btn.TextColor3 = W
                    return
                end
                local isGp = isGamepadInput(inp)
                if isGp and tick() - listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name
                pv = inp.KeyCode.Name
                btn.TextColor3 = W
                li = false
                _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                if cb then cb(inp.KeyCode, isGp) end
            end)
        end)
        return btn
    end

    local function mkToggleKB(txt, kbEntry, onToggle, onKB)
        local row = mkRow(32)
        mkLabel(row, txt)
        if kbEntry then
            mkKB(row, kbEntry, function(k, isGp)
                if isGp then kbEntry.gp = k; kbEntry.kb = nil
                else kbEntry.kb = k; kbEntry.gp = nil end
                if onKB then onKB(k, isGp) end
            end)
        end
        local pill, dot = mkPill(row, kbEntry and 102 or 42)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 5
        clk.Activated:Connect(function() on = not on; sv(on); onToggle(on) end)
        pill.ZIndex = 3
        dot.ZIndex = 4
        return sv
    end

    local function mkAction(txt, callback, btnTxt)
        local row = mkRow(32)
        mkLabel(row, txt)
        local button = Instance.new("TextButton", row)
        button.Size = UDim2.fromOffset(86, 22)
        button.Position = UDim2.new(1, -96, 0.5, -11)
        button.BackgroundColor3 = (UI and UI.theme and UI.theme.button) or Color3.fromRGB(28, 20, 44)
        button.BorderSizePixel = 0
        button.AutoButtonColor = false
        button.Text = btnTxt or "RESET"
        button.TextColor3 = (UI and UI.theme and UI.theme.light) or Color3.fromRGB(224, 170, 255)
        button.Font = Enum.Font.GothamBlack
        button.TextSize = 10
        button.ZIndex = 5
        Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
        local stroke = Instance.new("UIStroke", button)
        stroke.Color = (UI and UI.theme and UI.theme.border) or Color3.fromRGB(92, 45, 165)
        stroke.Thickness = 1
        button.Activated:Connect(function()
            local acc = (UI and UI.theme and UI.theme.accent) or Color3.fromRGB(157, 78, 221)
            local txtc = (UI and UI.theme and UI.theme.text) or Color3.fromRGB(250, 248, 255)
            local btnc = (UI and UI.theme and UI.theme.button) or Color3.fromRGB(28, 20, 44)
            local lgt = (UI and UI.theme and UI.theme.light) or Color3.fromRGB(224, 170, 255)
            UI.animate(button, {BackgroundColor3 = acc, TextColor3 = txtc}, 0.08)
            if callback then callback() end
            task.delay(0.18, function()
                if button.Parent then UI.animate(button, {BackgroundColor3 = btnc, TextColor3 = lgt}, 0.12) end
            end)
        end)
        return button
    end

    local function handleAutoSwitchCarrySpeed(on)
        State.autoCarrySpeedEnabled = on == true
        State.autoCarryLastSpeed = 0
        State.stealAttrWasActive = false
        if not on then disableAutoCarrySpeed() end
        if setAutoSwitchSpeedVisual then setAutoSwitchSpeedVisual(on) end
        refreshSpeedModeLabel()
        saveConfig()
    end

    -- ==================== MOVEMENT SECTION ====================
    mkSect("SPEED")
    do
        local row = mkRow(32); mkLabel(row, "Normal Speed")
        normalBox = mkBox(row, State.NS, 50, 56, function(v) State.NS = v; saveConfig() end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Carry Speed")
        carryBox = mkBox(row, State.CS, 50, 56, function(v)
            State.CS = tonumber(v) or State.CS
            if State.speedMode then State.autoCarryLastSpeed = 0 end
            if Speed.refreshVisuals then Speed.refreshVisuals() end
            saveConfig()
        end)
    end
    do
        setAutoSwitchSpeedVisual = mkToggle("Auto Switch Carry Speed", handleAutoSwitchCarrySpeed)
        if State.autoCarrySpeedEnabled then setAutoSwitchSpeedVisual(true) end
    end
    do
        local row = mkRow(32); mkLabel(row, "Lagger Speed")
        mkBox(row, State.LAGGER_SPEED, 50, 56, function(v) State.LAGGER_SPEED = v; saveConfig() end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Lagger Carry Speed")
        laggerCarryBox = mkBox(row, State.LAGGER_CARRY_SPEED, 50, 56, function(v) State.LAGGER_CARRY_SPEED = v; saveConfig() end)
    end
    do
        Speed.laggerVisual = mkToggleKB("Lagger Mode", KB.LaggerToggle,
            function(on)
                if on ~= State.laggerToggled then toggleLaggerMode() end
                refreshSpeedModeLabel()
                saveConfig()
            end,
            function(k, isGp)
                if isGp then KB.LaggerToggle.gp = k; KB.LaggerToggle.kb = nil
                else KB.LaggerToggle.kb = k; KB.LaggerToggle.gp = nil end
                saveConfig()
            end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Carry Mode")
        mkKB(row, KB.SpeedToggle, function(k, isGp)
            if isGp then KB.SpeedToggle.gp = k; KB.SpeedToggle.kb = nil
            else KB.SpeedToggle.kb = k; KB.SpeedToggle.gp = nil end
            saveConfig()
        end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Auto Play Mode")
        local modeValue = Instance.new("TextLabel", row)
        modeValue.Size = UDim2.new(0, 80, 1, 0)
        modeValue.Position = UDim2.new(1, -130, 0, 0)
        modeValue.BackgroundTransparency = 1
        modeValue.Text = State.autoPlayMode
        modeValue.TextColor3 = UI.theme.accent
        modeValue.Font = Enum.Font.GothamBlack
        modeValue.TextSize = 11
        modeValue.TextXAlignment = Enum.TextXAlignment.Right

        local function refreshAutoPlayMode()
            modeValue.Text = State.autoPlayMode
        end

        local click = Instance.new("TextButton", row)
        click.Size = UDim2.new(1, 0, 1, 0)
        click.BackgroundTransparency = 1
        click.Text = ""
        click.ZIndex = 2
        click.Activated:Connect(function()
            if _anyKeyListening then return end

            if AutoPlay.active then
                stopAutoPlay()
            end

            if State.autoPlayMode == "Half" then
                State.autoPlayMode = "Auto"
            else
                State.autoPlayMode = "Half"
            end

            refreshAutoPlayMode()

            local left = gui:FindFirstChild("MB_AUTO_LEFT", true)
            local right = gui:FindFirstChild("MB_AUTO_RIGHT", true)
            if left then UI.show(left, true, true) end
            if right then UI.show(right, true, true) end

            safeWriteFile("m10ruAutoPlayMode.txt", State.autoPlayMode)
            saveConfig()
        end)
    end

    -- ==================== COMBAT SECTION ====================
    mkSect("COMBAT")
    -- TP BAT ROW: the supplied file places its control in KEYBINDS.
    -- Picking a mode requires mode code that was not present in this source.
    setBodyLockVisual = mkToggle("Body Lock", function(on)
        BodyLock.setEnabled(on)
        saveConfig()
    end)
    -- Wire the pill: without this, silently re-armed Body Lock ran while the
    -- toggle still looked Off (character staring at a player with pill Off).
    BodyLock.visual = setBodyLockVisual
    -- Reflect the restored saved state on the pill itself.
    if setBodyLockVisual then setBodyLockVisual(State.bodyLockEnabled) end
    do
        local row = mkRow(32); mkLabel(row, "Body Lock Radius")
        bodyLockRangeBox = mkBox(row, State.bodyLockRange, 50, 56, function(value)
            State.bodyLockRange = math.clamp(math.floor(value), 5, 200)
            saveConfig()
        end)
    end
    setMedusaVisual = mkToggle("Medusa Counter", function(on)
        State.medusaCounterEnabled = on
        if on then setupMedusa(LP.Character) else stopMedusaCounter() end
        saveConfig()
    end)
    setBatCounterVisual = mkToggle("Bat Counter", function(on)
        State.batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        saveConfig()
    end)
    setInfJumpVisual = mkToggle("Infinite Jump", function(on)
        State.infJumpEnabled = on
        saveConfig()
    end)
    setAutoTPVisual = mkToggle("Auto TP", function(on)
        State.autoTPEnabled = on
        if on then startAutoTP() else stopAutoTP() end
        saveConfig()
    end)
    do
        local row = mkRow(32); mkLabel(row, "Auto TP Height")
        autoTPHeightBox = mkBox(row, State.autoTPHeight, 50, 56, function(v) State.autoTPHeight = v; saveConfig() end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Jump Mode")
        local modeVal = Instance.new("TextLabel", row)
        modeVal.Size = UDim2.new(0, 80, 1, 0)
        modeVal.Position = UDim2.new(1, -130, 0, 0)
        modeVal.BackgroundTransparency = 1
        modeVal.Text = State.infJumpMode:upper()
        modeVal.TextColor3 = RED
        modeVal.Font = Enum.Font.GothamBlack
        modeVal.TextSize = 11
        modeVal.TextXAlignment = Enum.TextXAlignment.Right
        setJumpModeVisual = function(m) State.infJumpMode = m; modeVal.Text = m:upper() end
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 2
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            if State.infJumpMode == "manual" then
                State.infJumpMode = "hold"
            else
                State.infJumpMode = "manual"
            end
            if setJumpModeVisual then setJumpModeVisual(State.infJumpMode) end
            saveConfig()
        end)
    end
    setAutoBatVisual = mkToggle("Aimbot", function(on)
        if on then queueAutoBatStart() else disableAutoBat() end
        saveConfig()
    end)
    -- Horizon's Instant Reset is a one-shot action, not an aimbot toggle.
    mkAction("Insta Reset", function()
        InstantReset.reset()
    end)
    setAutoSwingVisual = mkToggle("Auto Swing", function(on)
        AutoSwing.setEnabled(on)
        saveConfig()
    end)
    -- Standalone anti die; no donor window or overhead display.
    AntiDie.visual = mkToggle("anti die", function(on)
        -- Selecting Anti Die explicitly stops Instant Reset on Die, because
        -- Anti Die suppresses the death signal the reset monitor requires.
        if on and State.instantResetOnDieEnabled then DeathReset.setEnabled(false) end
        AntiDie.setEnabled(on)
        saveConfig()
    end)
    AntiDie.refresh()
    setInstantResetOnDieVisual = function(on) end
    setAntiFlingVisual = mkToggle("Anti Fling", function(on)
        AntiFling.setEnabled(on)
        saveConfig()
    end)

    -- ==================== VISUAL SECTION ====================
    mkSect("VISUAL")

    -- PRINTED-style ESP / Tracers, recolored to M10RU purple.
    -- These are isolated to player characters and clean up when disabled.
    do
        local visualPurple = Color3.fromRGB(157, 78, 221)
        local visualLight = Color3.fromRGB(224, 170, 255)
        local espEnabled, tracersEnabled = State.espEnabled == true, State.tracersEnabled == true
        local espObjects, tracerLines = {}, {}
        local visualConn

        local function clearESP(player)
            local item = espObjects[player]
            if not item then return end
            if item.highlight then pcall(function() item.highlight:Destroy() end) end
            if item.tag then pcall(function() item.tag:Destroy() end) end
            espObjects[player] = nil
        end

        local function setupESP(player)
            clearESP(player)
            if not espEnabled or player == LP then return end
            local character = player.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            local head = character and character:FindFirstChild("Head")
            local humanoid = character and character:FindFirstChildOfClass("Humanoid")
            if not root or not head or not humanoid or humanoid.Health <= 0 then return end
            local highlight = Instance.new("Highlight")
            highlight.Name = "M10RUPrintedESP"
            highlight.Adornee = character
            highlight.FillColor = visualPurple
            highlight.OutlineColor = visualLight
            highlight.FillTransparency = 0.72
            highlight.OutlineTransparency = 0.05
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Parent = character
            local billboard = Instance.new("BillboardGui")
            billboard.Name = "M10RUPrintedESPTag"
            billboard.Adornee = head
            billboard.Size = UDim2.fromOffset(150, 22)
            billboard.StudsOffset = Vector3.new(0, 2.5, 0)
            billboard.AlwaysOnTop = true
            billboard.Parent = head
            local label = Instance.new("TextLabel")
            label.BackgroundTransparency = 1
            label.Size = UDim2.fromScale(1, 1)
            label.Font = Enum.Font.GothamBold
            label.TextSize = 11
            label.TextColor3 = visualLight
            label.TextStrokeTransparency = 0.35
            label.Text = player.DisplayName
            label.Parent = billboard
            espObjects[player] = {highlight = highlight, tag = billboard, character = character}
        end

        local function clearTracer(player)
            local line = tracerLines[player]
            if line then pcall(function() line:Destroy() end) end
            tracerLines[player] = nil
        end

        local function ensureTracer(player)
            if player == LP or tracerLines[player] then return end
            local line = Instance.new("Frame")
            line.Name = "M10RUPrintedTracer"
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.BorderSizePixel = 0
            line.BackgroundColor3 = visualPurple
            line.BackgroundTransparency = 0.08
            line.Visible = false
            line.ZIndex = 80
            line.Parent = gui
            local stroke = Instance.new("UIStroke")
            stroke.Color = visualLight
            stroke.Thickness = 1
            stroke.Transparency = 0.15
            stroke.Parent = line
            tracerLines[player] = line
        end

        local function refreshPlayerVisuals()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP then
                    if espEnabled then
                        local item = espObjects[player]
                        if not item or item.character ~= player.Character or not item.highlight or not item.highlight.Parent then setupESP(player) end
                    else
                        clearESP(player)
                    end
                    if tracersEnabled then ensureTracer(player) else clearTracer(player) end
                end
            end
            for player in pairs(espObjects) do if not player.Parent then clearESP(player) end end
            for player in pairs(tracerLines) do if not player.Parent then clearTracer(player) end end
        end

        visualConn = RunService.RenderStepped:Connect(function()
            if not espEnabled and not tracersEnabled then return end
            refreshPlayerVisuals()
            local camera = workspace.CurrentCamera
            if not camera then return end
            local viewport = camera.ViewportSize
            local origin = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            for player, line in pairs(tracerLines) do
                local character = player.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                if tracersEnabled and root and humanoid and humanoid.Health > 0 then
                    local point, onScreen = camera:WorldToViewportPoint(root.Position)
                    if onScreen and point.Z > 0 then
                        local target = Vector2.new(point.X, point.Y)
                        local delta = target - origin
                        line.Position = UDim2.fromOffset((origin.X + target.X) * 0.5, (origin.Y + target.Y) * 0.5)
                        line.Size = UDim2.fromOffset(delta.Magnitude, 2)
                        line.Rotation = math.deg(math.atan2(delta.Y, delta.X))
                        line.Visible = true
                    else line.Visible = false end
                else line.Visible = false end
            end
        end)
        UI.addCleanup(function()
            if visualConn then visualConn:Disconnect() end
            for player in pairs(espObjects) do clearESP(player) end
            for player in pairs(tracerLines) do clearTracer(player) end
        end)
        Players.PlayerRemoving:Connect(function(player) clearESP(player); clearTracer(player) end)

        applyESPState = function(on)
            espEnabled = on == true
            State.espEnabled = espEnabled
            if espEnabled then
                refreshPlayerVisuals()
            else
                for player in pairs(espObjects) do clearESP(player) end
            end
            if setESPVisual then setESPVisual(espEnabled) end
        end
        applyTracersState = function(on)
            tracersEnabled = on == true
            State.tracersEnabled = tracersEnabled
            if tracersEnabled then
                refreshPlayerVisuals()
            else
                for player, line in pairs(tracerLines) do line.Visible = false; clearTracer(player) end
            end
            if setTracersVisual then setTracersVisual(tracersEnabled) end
        end
        setESPVisual = mkToggle("ESP", function(on)
            applyESPState(on)
            saveConfig()
        end)
        setTracersVisual = mkToggle("Tracers", function(on)
            applyTracersState(on)
            saveConfig()
        end)
        -- Apply previously saved states after the UI rows and cleanup hooks exist.
        if espEnabled then task.defer(function() applyESPState(true) end) end
        if tracersEnabled then task.defer(function() applyTracersState(true) end) end
    end
    do
        local row = mkRow(36)
        local label = mkLabel(row, "Anim Pack")
        label.Size = UDim2.new(0.36, 0, 1, 0)
        local value = Instance.new("TextLabel", row)
        value.Name = "AnimPackValue"
        -- Keep the selected pack entirely to the left of the arrow. The old
        -- 1-wide value box extended behind it, hiding longer animation names.
        value.Position = UDim2.new(0.38, 0, 0, 0)
        value.Size = UDim2.new(0.62, -62, 1, 0)
        value.BackgroundTransparency = 1
        value.TextColor3 = UI.theme.light
        value.Font = Enum.Font.GothamBold
        value.TextSize = 10
        value.TextTruncate = Enum.TextTruncate.AtEnd
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.ZIndex = 5
        local arrow = Instance.new("TextButton", row)
        arrow.Name = "AnimPackArrow"
        arrow.Size = UDim2.fromOffset(30, 24)
        arrow.Position = UDim2.new(1, -42, 0.5, -12)
        arrow.BackgroundColor3 = UI.theme.button
        arrow.BorderSizePixel = 0
        arrow.AutoButtonColor = false
        arrow.Text = "▼"
        arrow.TextColor3 = UI.theme.light
        arrow.Font = Enum.Font.GothamBlack
        arrow.TextSize = 12
        arrow.ZIndex = 5
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Color = UI.theme.border

        local open = false
        local optionRows = {}
        local optionButtons = {}
        local dropdownGeneration = 0
        local optionOpenSize = UDim2.new(1, 0, 0, 27)
        local optionClosedSize = UDim2.new(1, 0, 0, 0)
        local function refresh(name)
            value.Text = name
            for pack, button in pairs(optionButtons) do
                local selected = pack == name
                button.TextColor3 = selected and UI.theme.text or UI.theme.muted
                button.BackgroundColor3 = selected and UI.theme.accent or UI.theme.button
            end
        end
        local function setOpen(state)
            open = state == true
            dropdownGeneration += 1
            local generation = dropdownGeneration
            arrow.Text = open and "▲" or "▼"
            UI.animate(arrow, {BackgroundColor3 = open and UI.theme.accent or UI.theme.button}, 0.16)
            -- During GUI construction, close instantly so the list cannot
            -- flash before the first category selection finishes.
            if not UI.ready then
                for _, option in ipairs(optionRows) do
                    option:SetAttribute("M10RUManualVisible", open)
                    option.Size = open and optionOpenSize or optionClosedSize
                    option.Visible = open and UI.activeSection == "VISUAL"
                end
                return
            end
            if open then
                -- Fade + expand each option in a short cascade instead of
                -- dropping the complete list into view at once.
                for index, option in ipairs(optionRows) do
                    option:SetAttribute("M10RUManualVisible", true)
                    option.Size = optionClosedSize
                    option.Visible = false
                    task.delay((index - 1) * 0.012, function()
                        if generation ~= dropdownGeneration or not open or not option.Parent then return end
                        UI.show(option, true)
                        UI.animate(option, {Size = optionOpenSize}, 0.18)
                    end)
                end
            else
                -- Collapse and fade in reverse order; UI.show's generation
                -- guard prevents old close tweens from hiding a reopened list.
                for index = #optionRows, 1, -1 do
                    local option = optionRows[index]
                    option:SetAttribute("M10RUManualVisible", false)
                    if option.Visible then
                        task.delay((#optionRows - index) * 0.008, function()
                            if generation ~= dropdownGeneration or open or not option.Parent then return end
                            UI.animate(option, {Size = optionClosedSize}, 0.16)
                            UI.show(option, false)
                        end)
                    else
                        option.Size = optionClosedSize
                        option.Visible = false
                    end
                end
            end
        end
        for _, pack in ipairs(HORIZON_ANIMATION_PACK_LIST) do
            local option = mkRow(27)
            option.Name = "AnimPack_" .. pack:gsub("%W", "")
            option:SetAttribute("M10RUManualVisible", false)
            local button = Instance.new("TextButton", option)
            button.Size = UDim2.new(1, -12, 1, -4)
            button.Position = UDim2.new(0, 6, 0, 2)
            button.BackgroundColor3 = UI.theme.button
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = pack
            button.TextColor3 = UI.theme.muted
            button.Font = Enum.Font.GothamBold
            button.TextSize = 10
            button.ZIndex = 5
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = UI.theme.border
            stroke.Transparency = 0.25
            button.Activated:Connect(function()
                if _anyKeyListening then return end
                AnimPack.apply(pack)
                saveConfig()
                setOpen(false) -- selecting a pack closes the list immediately.
            end)
            table.insert(optionRows, option)
            optionButtons[pack] = button
        end
        AnimPack.visual = refresh
        refresh(State.animPack)
        arrow.Activated:Connect(function()
            if _anyKeyListening then return end
            setOpen(not open)
        end)
        setOpen(false)
    end
    -- Three-way Anti Ragdoll selector. Opening it never enables an engine.
    do
        local row = mkRow(34)
        row.Name = "AntiRagdollRow"
        mkLabel(row, "Anti Ragdoll")
        local value = Instance.new("TextLabel", row)
        value.Name = "SelectedMode"
        value.BackgroundTransparency = 1
        value.Position = UDim2.new(0.48, 0, 0, 0)
        value.Size = UDim2.new(0.52, -42, 1, 0)
        value.TextColor3 = UI.theme.light
        value.Font = Enum.Font.GothamBold
        value.TextSize = 10
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.ZIndex = 5
        local arrow = Instance.new("TextButton", row)
        arrow.Name = "AntiRagdollArrow"
        arrow.Size = UDim2.fromOffset(28, 24)
        arrow.Position = UDim2.new(1, -33, 0.5, -12)
        arrow.BackgroundColor3 = UI.theme.button
        arrow.BorderSizePixel = 0
        arrow.AutoButtonColor = false
        arrow.Text = "^"
        arrow.Font = Enum.Font.GothamBlack
        arrow.TextSize = 18
        arrow.TextColor3 = UI.theme.text
        arrow.ZIndex = 6
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 6)
        local options = Instance.new("CanvasGroup", sf)
        options.Name = "AntiRagdollOptions"
        options.Size = UDim2.new(1, 0, 0, 104)
        options.LayoutOrder = LO()
        options.BackgroundColor3 = UI.theme.panel
        options.BorderSizePixel = 0
        options.ClipsDescendants = true
        Instance.new("UICorner", options).CornerRadius = UDim.new(0, 6)
        local buttons = {}
        local labels = {Off = "Off", Normal = "V1", Custom = "V2"}
        for index, mode in ipairs({"Off", "Normal", "Custom"}) do
            local button = Instance.new("TextButton", options)
            button.Name = "AntiRagdoll" .. mode
            button.Size = UDim2.new(1, -10, 0, 28)
            button.Position = UDim2.fromOffset(5, 5 + (index - 1) * 33)
            button.BackgroundColor3 = UI.theme.button
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = labels[mode]
            button.TextColor3 = UI.theme.text
            button.Font = Enum.Font.GothamBold
            button.TextSize = 11
            button.ZIndex = 5
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 5)
            buttons[mode] = button
            button.Activated:Connect(function()
                if _anyKeyListening or not Ragdoll.alive then return end
                Ragdoll.setMode(mode)
                saveConfig()
            end)
        end
        Ragdoll.refreshUI = function()
            if not Ragdoll.alive then return end
            UI.text(value, labels[State.antiRagdollMode] or "Off")
            UI.animate(arrow, {Rotation = Ragdoll.open and 180 or 0, BackgroundColor3 = Ragdoll.open and UI.theme.accent or UI.theme.button})
            for mode, button in pairs(buttons) do
                UI.animate(button, {BackgroundColor3 = mode == State.antiRagdollMode and UI.theme.accent or UI.theme.button})
            end
            UI.row(options, Ragdoll.open, 104)
        end
        arrow.Activated:Connect(function()
            if _anyKeyListening or not Ragdoll.alive then return end
            Ragdoll.open = not Ragdoll.open
            Ragdoll.refresh()
        end)
        setAntiRagVisual = function() Ragdoll.refresh() end
        Ragdoll.refresh()
    end
    setUnwalkVisual = mkToggle("Unwalk", function(on)
        State.unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
        saveConfig()
    end)
    mkAction("Skin Changer", function()
        SkinChanger.openViewer()
    end, "OPEN")
    setAntiLagVisual = mkToggle("Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        saveConfig()
    end)
    setStretchRezVisual = mkToggle("Stretch Rez", function(on)
        if on then enableStretchRez() else disableStretchRez() end
        saveConfig()
    end)
    -- POV: each tap raises the camera FOV by 10 (70 -> 120), then wraps to 70.
    -- State.povValue feeds the single FOV owner, so Stretch toggles restore
    -- this value instead of killing it.
    do
        local row = mkRow(32); mkLabel(row, "POV")
        local povFov = tonumber(safeReadFile("m10ruPOV.txt")) or 70
        povFov = math.clamp(math.floor(povFov / 10 + 0.5) * 10, 70, 120)
        State.povValue = povFov
        if povFov > 70 and not State.stretchRezEnabled then
            Camera.FieldOfView = povFov
        end
        local povVal = Instance.new("TextLabel", row)
        povVal.Size = UDim2.new(0, 110, 1, 0)
        povVal.Position = UDim2.new(1, -118, 0, 0)
        povVal.BackgroundTransparency = 1
        povVal.Text = tostring(povFov)
        povVal.TextColor3 = RED
        povVal.Font = Enum.Font.GothamBlack
        povVal.TextSize = 11
        povVal.TextXAlignment = Enum.TextXAlignment.Right
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 2
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            povFov += 10
            if povFov > 120 then povFov = 70 end
            State.povValue = povFov
            povVal.Text = tostring(povFov)
            safeWriteFile("m10ruPOV.txt", tostring(povFov))
            if not State.stretchRezEnabled then
                Camera.FieldOfView = povFov
            end
        end)
    end
    do
        setFPSBoostVisual = mkToggle("FPS Boost", function(on)
            if on then applyFPSBoost() else disableFPSBoost() end
            saveConfig()
        end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Sky Theme")
        local skyIndex = 1
        for i, name in ipairs(M10RU_SKY_ORDER) do
            if name == currentSkyTheme then skyIndex = i; break end
        end
        local skyVal = Instance.new("TextLabel", row)
        skyVal.Size = UDim2.new(0, 110, 1, 0)
        skyVal.Position = UDim2.new(1, -118, 0, 0)
        skyVal.BackgroundTransparency = 1
        skyVal.Text = M10RU_SKY_ORDER[skyIndex]
        skyVal.TextColor3 = RED
        skyVal.Font = Enum.Font.GothamBlack
        skyVal.TextSize = 11
        skyVal.TextXAlignment = Enum.TextXAlignment.Right
        setSkyVisual = function(name)
            for i, n in ipairs(M10RU_SKY_ORDER) do
                if n == name then skyIndex = i; break end
            end
            skyVal.Text = M10RU_SKY_ORDER[skyIndex]
        end
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 2
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            skyIndex = skyIndex % #M10RU_SKY_ORDER + 1
            local name = M10RU_SKY_ORDER[skyIndex]
            skyVal.Text = name
            currentSkyTheme = name
            m10ruApplySky(name)
            saveConfig()
        end)
    end

    -- ==================== KEYBINDS SECTION ====================
    mkSect("KEYBINDS")
    do
        local row = mkRow(32); mkLabel(row, "Auto Left")
        mkKB(row, KB.AutoLeft, function(k, isGp)
            if isGp then KB.AutoLeft.gp = k; KB.AutoLeft.kb = nil else KB.AutoLeft.kb = k; KB.AutoLeft.gp = nil end
            saveConfig()
        end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Auto Right")
        mkKB(row, KB.AutoRight, function(k, isGp)
            if isGp then KB.AutoRight.gp = k; KB.AutoRight.kb = nil else KB.AutoRight.kb = k; KB.AutoRight.gp = nil end
            saveConfig()
        end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Auto Bat")
        mkKB(row, KB.AutoBat, function(k, isGp)
            if isGp then KB.AutoBat.gp = k; KB.AutoBat.kb = nil else KB.AutoBat.kb = k; KB.AutoBat.gp = nil end
            saveConfig()
        end)
    end
    do
        local row = mkRow(32); mkLabel(row, "Drop Brainrot")
        mkKB(row, KB.DropBrainrot, function(k, isGp)
            if isGp then KB.DropBrainrot.gp = k; KB.DropBrainrot.kb = nil else KB.DropBrainrot.kb = k; KB.DropBrainrot.gp = nil end
            saveConfig()
        end)
    end
    do
        local row = mkRow(32); mkLabel(row, "TP Floor")
        mkKB(row, KB.TPFloor, function(k, isGp)
            if isGp then KB.TPFloor.gp = k; KB.TPFloor.kb = nil else KB.TPFloor.kb = k; KB.TPFloor.gp = nil end
            saveConfig()
        end)
    end
    do
        TpBat.uiSet = mkToggleKB("Tp Bat", KB.TpBat,
            function(on) TpBat.setEnabled(on); saveConfig() end,
            function(k, isGp)
                if isGp then KB.TpBat.gp = k; KB.TpBat.kb = nil else KB.TpBat.kb = k; KB.TpBat.gp = nil end
                saveConfig()
            end)
        TpBat.refresh()
    end
    do
        local row = mkRow(32); mkLabel(row, "Insta Reset")
        mkKB(row, KB.InstantReset, function(k, isGp)
            if isGp then KB.InstantReset.gp = k; KB.InstantReset.kb = nil else KB.InstantReset.kb = k; KB.InstantReset.gp = nil end
            saveConfig()
        end)
    end

    -- ==================== MISC SECTION ====================
    mkSect("MISC")
    -- Intro screen: plays the animated black-space intro on script load.
    setIntroVisual = mkToggle("Intro", function(on)
        State.introEnabled = on
        saveConfig()
    end)
    if setIntroVisual then setIntroVisual(State.introEnabled) end
    -- BUTTON STYLE: three shapes. Square = sharp square corners, Rounded =
    -- the usual soft corner, Circle = fully round (affects hub + mobile buttons).
    do
        local row = mkRow(32); mkLabel(row, "Button Style")
        local styleLabels = {"Square", "Rounded", "Circle"}
        local styleRadii = {UDim.new(0, 0), UDim.new(0, 4), UDim.new(1, 0)}
        local styleRadiiMB = {UDim.new(0, 0), UDim.new(0, 14), UDim.new(1, 0)}
        local styleBtns = {}
        local currentStyle = 1
        -- Old saves were 1 = rounded-ish "Square", 2 = Circle; keep their look.
        local savedStyle = tonumber(safeReadFile("m10ruButtonStyle.txt"))
        if savedStyle == 1 then currentStyle = 2
        elseif savedStyle and savedStyle >= 2 and savedStyle <= 3 then currentStyle = 3 end

        local allButtons = {}
        local function applyButtonStyle(idx)
            currentStyle = idx
            for i, b in ipairs(styleBtns) do
                UI.animate(b, {BackgroundColor3 = (i == idx) and UI.theme.accent or UI.theme.button})
                UI.animate(b, {TextColor3 = (i == idx) and UI.theme.text or UI.theme.muted})
            end
            local cornerRadius = styleRadii[idx] or styleRadii[1]
            local mbRadius = styleRadiiMB[idx] or styleRadiiMB[1]
            for _, btn in ipairs(allButtons) do
                local corner = btn:FindFirstChildOfClass("UICorner")
                if corner then UI.animate(corner, {CornerRadius = cornerRadius}, 0.25) end
            end
            for _, mbFrame in ipairs(mbContainers or {}) do
                local corner = mbFrame:FindFirstChildOfClass("UICorner")
                if corner then UI.animate(corner, {CornerRadius = mbRadius}, 0.25) end
            end
            safeWriteFile("m10ruButtonStyle.txt", tostring(idx))
        end
        local totalW = 60 * #styleLabels + 6 * (#styleLabels - 1)
        local startX = -(totalW + 4)
        for i, lbl in ipairs(styleLabels) do
            local b = Instance.new("TextButton", row)
            b.Size = UDim2.new(0, 60, 0, 22)
            b.Position = UDim2.new(1, startX + (i - 1) * 66, 0.5, -11)
            b.BackgroundColor3 = (i == currentStyle) and UI.theme.accent or UI.theme.button
            b.BorderSizePixel = 0
            b.Text = lbl
            b.TextColor3 = (i == currentStyle) and UI.theme.text or UI.theme.muted
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.ZIndex = 5
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 4)
            Instance.new("UIStroke", b).Color = UI.theme.border
            table.insert(styleBtns, b)
            b.Activated:Connect(function() applyButtonStyle(i) end)
        end
        task.defer(function()
            for _, desc in ipairs(sf:GetDescendants()) do
                if desc:IsA("TextButton") then table.insert(allButtons, desc) end
            end
            for _, btn in ipairs(styleBtns or {}) do table.insert(allButtons, btn) end
            applyButtonStyle(currentStyle)
        end)
    end
    -- AUTO GRAB CONTROLS (moved from the former GRAB category)
    -- The fixed 61-stud targeting and 75/80/85/90 modes remain unchanged.
    do
        setAutoGrabVisual = mkToggle("Auto Grab", function(on)
            if on then
                Grab.startNormal()
            else
                Grab.stopAll()
                Grab.refresh()
            end
            saveConfig()
        end)

        local modesRow = mkRow(44)
        local modesLabel = mkLabel(modesRow, "Modes")
        modesLabel.Size = UDim2.new(0.27, 0, 1, 0)
        local modeButtons = {}
        local modeValues = {75, 80, 85, 90}
        local function refreshModes()
            for i, button in ipairs(modeButtons) do
                local selected = State.autoGrabMode == modeValues[i]
                UI.animate(button, {BackgroundColor3 = selected and UI.theme.accent or UI.theme.button})
                UI.animate(button, {TextColor3 = selected and UI.theme.text or UI.theme.muted})
            end
        end
        for i, value in ipairs(modeValues) do
            local button = Instance.new("TextButton", modesRow)
            button.Name = "AutoGrabMode" .. tostring(value)
            button.Size = UDim2.new(0.17, -4, 0, 28)
            button.Position = UDim2.new(0.28 + (i - 1) * 0.18, 0, 0.5, -14)
            button.BackgroundColor3 = UI.theme.button
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = tostring(value) .. "%"
            button.TextColor3 = UI.theme.muted
            button.Font = Enum.Font.GothamBlack
            button.TextSize = 12
            button.ZIndex = 5
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
            local stroke = Instance.new("UIStroke", button)
            stroke.Color = UI.theme.border
            stroke.Transparency = 0.15
            button.Activated:Connect(function()
                State.autoGrabMode = value
                State.autoGrabStopEnabled = true
                State.autoGrabStopTime = (math.clamp(value, 0, 100) / 100) * math.max(tonumber(State.StealV1.StealDuration) or 1.3, 0.05)
                if Grab.yout and Grab.yout.active then
                    -- The active session reads its selected stop time only at its start;
                    -- the next attempt will use this selection without corrupting its current timer.
                end
                Grab.refresh()
                refreshModes()
                saveConfig()
            end)
            modeButtons[i] = button
        end
        refreshModes()

        local zoomRow = mkRow(40)
        local zoomLabel = mkLabel(zoomRow, "Auto Grab Size")
        zoomLabel.Size = UDim2.new(1, -150, 1, 0)
        local zoomValue = Instance.new("TextLabel", zoomRow)
        zoomValue.Name = "AutoGrabScaleValue"
        zoomValue.Position = UDim2.new(1, -116, 0, 0)
        zoomValue.Size = UDim2.fromOffset(58, 40)
        zoomValue.BackgroundTransparency = 1
        zoomValue.TextColor3 = UI.theme.light
        zoomValue.Font = Enum.Font.GothamBold
        zoomValue.TextSize = 12
        zoomValue.TextXAlignment = Enum.TextXAlignment.Center
        local function zoomButton(text, offset, delta)
            local button = Instance.new("TextButton", zoomRow)
            button.Size = UDim2.fromOffset(30, 28)
            button.Position = UDim2.new(1, offset, 0.5, -14)
            button.BackgroundColor3 = UI.theme.button
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.Text = text
            button.TextColor3 = UI.theme.text
            button.Font = Enum.Font.GothamBlack
            button.TextSize = 17
            button.ZIndex = 5
            Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)
            button.Activated:Connect(function()
                Grab.changeScale(delta, "V1")
                zoomValue.Text = tostring(math.floor(Grab.getScale("V1") * 100 + 0.5)) .. "%"
                saveConfig()
            end)
        end
        zoomButton("-", -70, -0.1)
        zoomButton("+", -34, 0.1)
        zoomValue.Text = tostring(math.floor(Grab.getScale("V1") * 100 + 0.5)) .. "%"
        if setAutoGrabVisual then setAutoGrabVisual(State.SemiNormalOpen) end
        Grab.refresh()
    end

    do
        local row = mkRow(40); mkLabel(row, "Hide GUI")
        mkKB(row, KB.GuiHide, function(k, isGp)
            if isGp then KB.GuiHide.gp = k; KB.GuiHide.kb = nil else KB.GuiHide.kb = k; KB.GuiHide.gp = nil end
            saveConfig()
        end)
    end

    local mbToggleSv = nil
    do
        local row = mkRow(32); mkLabel(row, "Mobile Buttons")
        local pill, dot = mkPill(row, 42); animPill(pill, dot, true)
        local on = true
        local function sv(s) on = s; animPill(pill, dot, s) end
        mbToggleSv = sv
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 5
        clk.Activated:Connect(function()
            on = not on
            sv(on)
            for _, c in ipairs(mbContainers) do UI.show(c, on) end
            safeWriteFile("m10ruMobileVis.txt", tostring(on))
        end)
        pill.ZIndex = 3; dot.ZIndex = 4
    end
    do
        local row = mkRow(32); mkLabel(row, "Lock Mobile + UI")
        local pill, dot = mkPill(row, 42)
        local on = false
        local function sv(s)
            on = s
            animPill(pill, dot, s)
            mbLocked = s
            UI.setDragLocked(s)
            safeWriteFile("m10ruMobileLock.txt", tostring(s))
        end
        _setMbLockVisual = sv
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.ZIndex = 5
        clk.Activated:Connect(function() sv(not on) end)
        pill.ZIndex = 3; dot.ZIndex = 4
        local savedLock = safeReadFile("m10ruMobileLock.txt")
        if savedLock == "true" then sv(true) end
    end
    do
        local row = mkRow(32); mkLabel(row, "Reset Panel")
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(0, 80, 0, 24)
        resetBtn.Position = UDim2.new(1, -90, 0.5, -12)
        resetBtn.BackgroundColor3 = UI.theme.button
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "Reset"
        resetBtn.TextColor3 = UI.theme.text
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 11
        resetBtn.ZIndex = 5
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 5)
        Instance.new("UIStroke", resetBtn).Color = UI.theme.border
        resetBtn.Activated:Connect(function()
            local orig = resetBtn.Text
            resetBtn.Text = "..."
            if resetMobilePositions then resetMobilePositions() end
            task.delay(0.2, function() resetBtn.Text = orig end)
        end)
    end
    -- ==================== NUMERIC SCALE CONTROLS: - / VALUE / + ====================
    do
        local function scaleRow(label, key)
            local row = mkRow(34)
            row.Name = key == "main" and "InterfaceScaleRow" or "MobileScaleRow"
            local title = mkLabel(row, label)
            title.Size = UDim2.new(1, -146, 1, 0)
            title.TextTruncate = Enum.TextTruncate.AtEnd
            local function button(name, text, offset)
                local control = Instance.new("TextButton", row)
                control.Name = name
                control.Size = UDim2.fromOffset(26, 26)
                control.Position = UDim2.new(1, offset, 0.5, -13)
                control.BackgroundColor3 = UI.theme.button
                control.BorderSizePixel = 0
                control.AutoButtonColor = false
                control.Text = text
                control.Font = Enum.Font.GothamBold
                control.TextSize = 17
                control.TextColor3 = UI.theme.text
                control.ZIndex = 5
                Instance.new("UICorner", control).CornerRadius = UDim.new(0, 6)
                return control
            end
            local prefix = key == "main" and "InterfaceScale" or "MobileScale"
            local minus = button(prefix .. "Minus", "-", -130)
            local value = Instance.new("TextLabel", row)
            value.Name = prefix .. "Value"
            value.Position = UDim2.new(1, -104, 0, 0)
            value.Size = UDim2.new(0, 72, 1, 0)
            value.BackgroundTransparency = 1
            value.Text = "100%"
            value.TextColor3 = UI.theme.light
            value.Font = Enum.Font.GothamBold
            value.TextSize = 12
            value.TextXAlignment = Enum.TextXAlignment.Center
            local plus = button(prefix .. "Plus", "+", -32)
            Layout.controls[key] = {minus = minus, value = value, plus = plus}
            local function change(delta)
                if _anyKeyListening then return end
                if key == "main" then Layout.applyMain(Layout.mainFactor + delta, true)
                elseif Layout.applyMobile then Layout.applyMobile(Layout.mobileFactor + delta, true) end
            end
            minus.Activated:Connect(function() change(-0.1) end)
            plus.Activated:Connect(function() change(0.1) end)
        end
        scaleRow("UI Scale", "main")
        scaleRow("Mobile Scale", "mobile")
        Layout.refresh()
    end

    -- PC & Gamepad Input Dispatcher
    UserInputService.InputBegan:Connect(function(input, gpe)
        if _anyKeyListening then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            if gpe or UserInputService:GetFocusedTextBox() then return end
        elseif not isGamepadInput(input) then return end
        if not isBindableInput(input) then return end
        
        local kc = input.KeyCode
        if kbMatch(KB.LaggerToggle, kc) then toggleLaggerMode(); saveConfig()
        elseif kbMatch(KB.SpeedToggle, kc) then toggleCarryMode(); saveConfig()
        elseif kbMatch(KB.DropBrainrot, kc) then runDrop()
        elseif kbMatch(KB.TPFloor, kc) then runTPFloor()
        elseif kbMatch(KB.TpBat, kc) then TpBat.toggle(); saveConfig()
        elseif kbMatch(KB.AutoLeft, kc) and State.autoPlayMode == "Half" then
            State.autoLeftEnabled = not State.autoLeftEnabled
            if State.autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end
            if autoLeftSetVisual then autoLeftSetVisual(State.autoLeftEnabled) end
        elseif kbMatch(KB.AutoRight, kc) and State.autoPlayMode == "Half" then
            State.autoRightEnabled = not State.autoRightEnabled
            if State.autoRightEnabled then queueAutoRightStart() else stopAutoRight() end
            if autoRightSetVisual then autoRightSetVisual(State.autoRightEnabled) end
        elseif kbMatch(KB.AutoBat, kc) then
            if not State.autoBatEnabled then
                queueAutoBatStart()
                if setAutoBatVisual then setAutoBatVisual(true) end
            else
                State.autoBatEnabled = false
                disableAutoBat()
                if setAutoBatVisual then setAutoBatVisual(false) end
            end
        elseif kbMatch(KB.InstantReset, kc) then
            InstantReset.reset()
        elseif kbMatch(KB.GuiHide, kc) then
            if UI.isShown(main) then hideGui() else showGui() end
        end
    end)

    -- ============================================================
    -- MOBILE BUTTONS
    -- ============================================================
    local MB_OFF     = UI.theme.background
    local MB_ON_C    = UI.theme.accent
    local MB_TEXT    = UI.theme.text
    local MB_TEXT_ON = UI.theme.text
    -- Edge color: always purple (no red edge on activation).
    local MB_EDGE_OFF = Color3.fromRGB(139, 92, 246)
    local BTN_W, BTN_H, GAP, CORNER = 68, 68, 4, 14

    local _sw = Camera.ViewportSize.X
    local _sh = Camera.ViewportSize.Y
    local _totalH = 5 * BTN_H + 4 * GAP
    local _startY = math.floor((_sh - _totalH) / 2)
    local _col1X = _sw - (BTN_W * 2 + GAP + 10)
    local _col2X = _sw - (BTN_W + 10)

    local DEFAULT_POSITIONS = {
        ["DROP_BR"]      = {x = _col1X, y = _startY},
        ["AUTO_LEFT"]    = {x = _col2X, y = _startY},
        ["BAT_AIMBOT"]   = {x = _col1X, y = _startY + (BTN_H + GAP) * 1},
        ["AUTO_RIGHT"]   = {x = _col2X, y = _startY + (BTN_H + GAP) * 1},
        ["TP_DOWN"]      = {x = _col1X, y = _startY + (BTN_H + GAP) * 2},
        ["CARRY_SPD"]    = {x = _col2X, y = _startY + (BTN_H + GAP) * 2},
        ["LAGGER_CARRY"] = {x = _col1X, y = _startY + (BTN_H + GAP) * 3},
        ["LAGGER_MODE"]  = {x = _col2X, y = _startY + (BTN_H + GAP) * 3},
        ["TP_BAT"]          = {x = _col1X, y = _startY + (BTN_H + GAP) * 4},
        ["INSTANT_RESET"]   = {x = _col2X, y = _startY + (BTN_H + GAP) * 4},
    }

    local mbBtnFrames = {}
    local _lastBtnSave = {}
    -- Versioned layout migration: old saved coordinates are ignored exactly
    -- once, so every button starts in its own slot after this update.
    local MOBILE_LAYOUT_VERSION = "8"
    local resetSavedMobileLayout = safeReadFile("m10ruMobileLayoutVersion.txt") ~= MOBILE_LAYOUT_VERSION
    if resetSavedMobileLayout then
        safeWriteFile("m10ruMobileLayoutVersion.txt", MOBILE_LAYOUT_VERSION)
    end

    local function saveBtnPos(key, frame)
        local now = tick()
        if _lastBtnSave[key] and now - _lastBtnSave[key] < 0.3 then return end
        _lastBtnSave[key] = now
        local position = UI.goal(frame, "Position")
        safeWriteFile("m10ruMB_" .. key .. ".txt",
            tostring(math.floor(position.X.Offset)) .. "," ..
            tostring(math.floor(position.Y.Offset)))
    end

    local function loadBtnPos(key)
        local def = DEFAULT_POSITIONS[key] or {x = 10, y = 200}
        -- Do not reuse coordinates from the old layout: those are what caused
        -- Carry Speed to appear on Lagger Mode. Future user drag positions are
        -- still saved and restored normally.
        if resetSavedMobileLayout then return def end
        local saved = safeReadFile("m10ruMB_" .. key .. ".txt")
        if not saved and key == "INSTANT_RESET" then
            saved = safeReadFile("m10ruMB_INSTA_RESET.txt")
        end
        if saved then
            local px, py = saved:match("([^,]+),([^,]+)")
            if px and py then
                def = {x = tonumber(px) or def.x, y = tonumber(py) or def.y}
            end
        end
        return def
    end

    local function makeMB(topTxt, botTxt, key, isToggle, onAction)
        local pos = loadBtnPos(key)
        local entry

        local frame = Instance.new("CanvasGroup", gui)
        frame.Name = "MB_" .. key
        frame.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        frame.Position = UDim2.new(0, pos.x, 0, pos.y)
        UI.animate(frame, {BackgroundColor3 = MB_OFF})
        frame.BorderSizePixel = 0
        frame.ZIndex = 100
        frame.Active = true
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, CORNER)
        -- Purple edge while idle; it turns red while the feature stays active.
        local frameStroke = Instance.new("UIStroke", frame)
        frameStroke.Color = MB_EDGE_OFF
        frameStroke.Thickness = 1.6
        frameStroke.Transparency = 0.03

        local tL = Instance.new("TextLabel", frame)
        -- Both words are centered as one compact label (for example TP / BAT),
        -- rather than being separated across the mobile button.
        tL.Size = UDim2.new(1, -4, 0.34, 0); tL.Position = UDim2.new(0, 2, 0.18, 0)
        tL.BackgroundTransparency = 1; tL.Text = topTxt; tL.TextColor3 = MB_TEXT
        tL.Font = Enum.Font.GothamBlack; tL.TextSize = 13
        tL.TextXAlignment = Enum.TextXAlignment.Center; tL.TextYAlignment = Enum.TextYAlignment.Center
        tL.TextWrapped = false; tL.ZIndex = 103

        local bL = Instance.new("TextLabel", frame)
        bL.Size = UDim2.new(1, -4, 0.34, 0); bL.Position = UDim2.new(0, 2, 0.48, 0)
        bL.BackgroundTransparency = 1; bL.Text = botTxt; bL.TextColor3 = MB_TEXT
        bL.Font = Enum.Font.GothamBlack; bL.TextSize = 13
        bL.TextXAlignment = Enum.TextXAlignment.Center; bL.TextYAlignment = Enum.TextYAlignment.Center
        bL.TextWrapped = false; bL.ZIndex = 103

        local btn = Instance.new("TextButton", frame)
        btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1
        btn.Text = ""; btn.ZIndex = 104; btn.BorderSizePixel = 0
        btn.AutoButtonColor = false

        local dragActive = false
        local dragInputObj = nil
        local dragStart = nil
        local dragStartPos = nil
        local hasDragged = false
        UI.trackDrag(frame, function()
            dragActive, dragInputObj, dragStart, dragStartPos = false, nil, nil, nil
        end)

        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                -- A locked button is still a normal working button: only its
                -- drag behavior is disabled. Reset the old drag flag first so
                -- a previous drag never eats this tap.
                hasDragged = false
                if mbLocked then
                    dragActive, dragInputObj, dragStart, dragStartPos = false, nil, nil, nil
                    return
                end
                dragActive = true
                dragInputObj = inp
                dragStart = Vector2.new(inp.Position.X, inp.Position.Y)
                dragStartPos = Vector2.new(frame.Position.X.Offset, frame.Position.Y.Offset)
            end
        end)

        UserInputService.InputChanged:Connect(function(inp)
            if not dragActive or mbLocked or not dragInputObj then return end
            local samePointer = inp == dragInputObj or (inp.UserInputType == Enum.UserInputType.MouseMovement
                and dragInputObj.UserInputType == Enum.UserInputType.MouseButton1)
            if not samePointer then return end
            if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
                local delta = Vector2.new(inp.Position.X, inp.Position.Y) - dragStart
                if delta.Magnitude > 10 then hasDragged = true end
                if hasDragged then
                    UI.animate(frame, {Position = UDim2.new(0, dragStartPos.X + delta.X, 0, dragStartPos.Y + delta.Y)}, 0.08)
                end
            end
        end)

        UserInputService.InputEnded:Connect(function(inp)
            if inp ~= dragInputObj then return end
            if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                if dragActive then
                    if hasDragged then
                        if entry then entry.autoPlaced = false end
                        saveBtnPos(key, frame)
                    end
                    dragActive = false
                    dragInputObj = nil
                end
            end
        end)

        local isOn = false
        local function setActive(s)
            isOn = s
            if s then
                UI.animate(frame, {BackgroundColor3 = MB_ON_C})
                UI.animate(tL, {TextColor3 = MB_TEXT_ON})
                UI.animate(bL, {TextColor3 = MB_TEXT_ON})
            else
                UI.animate(frame, {BackgroundColor3 = MB_OFF})
                UI.animate(tL, {TextColor3 = MB_TEXT})
                UI.animate(bL, {TextColor3 = MB_TEXT})
            end
        end

        if not isToggle then
            btn.MouseButton1Down:Connect(function()
                if hasDragged then return end
                UI.animate(frame, {BackgroundColor3 = MB_ON_C})
                UI.animate(tL, {TextColor3 = MB_TEXT_ON})
                UI.animate(bL, {TextColor3 = MB_TEXT_ON})
            end)
            btn.MouseButton1Up:Connect(function()
                if not isOn then
                    UI.animate(frame, {BackgroundColor3 = MB_OFF})
                    UI.animate(tL, {TextColor3 = MB_TEXT})
                    UI.animate(bL, {TextColor3 = MB_TEXT})
                end
            end)
        end

        btn.MouseButton1Click:Connect(function()
            if hasDragged then return end
            if isToggle then isOn = not isOn; setActive(isOn) end
            if onAction then onAction(setActive, isOn) end
        end)

        table.insert(mbContainers, frame)
        entry = {frame = frame, topLbl = tL, botLbl = bL, key = key}
        table.insert(mbBtnFrames, entry)

        return setActive, frame, tL, bL
    end

    local mbVisible = true
    local savedMbVis = safeReadFile("m10ruMobileVis.txt")
    if savedMbVis == "false" then mbVisible = false end

    task.defer(function()
        if mbToggleSv then mbToggleSv(mbVisible) end
        for _, c in ipairs(mbContainers) do UI.show(c, mbVisible, true) end
    end)

    makeMB("DROP", "BR", "DROP_BR", false, function(setActive)
        runDrop()
        task.delay(0.3, function() setActive(false) end)
    end)

    autoLeftSetVisual = makeMB("AUTO", "LEFT", "AUTO_LEFT", false, function(setActive)
        if State.autoPlayMode == "Auto" then
            if AutoPlay.active and AutoPlay.route == "left" then
                stopAutoPlay()
                setActive(false)
            else
                AutoPlay.route = "left"
                startAutoPlay()
                setActive(true)
            end
            return
        end
        State.autoLeftEnabled = not State.autoLeftEnabled
        if State.autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end
        task.delay(0.2, function() setActive(false) end)
    end)

    -- Same two buttons are used by both Half and Auto modes.
    autoPlayLeftSetVisual = autoLeftSetVisual
    autoPlayRightSetVisual = nil

    local setABmb = makeMB("BAT", "AIMBOT", "BAT_AIMBOT", true, function(setActive, isOn)
        if isOn then
            queueAutoBatStart()
            if setAutoBatVisual then setAutoBatVisual(true) end
        else
            State.autoBatEnabled = false
            disableAutoBat()
            if setAutoBatVisual then setAutoBatVisual(false) end
        end
    end)

    Combat.mobileGood = setABmb

    autoRightSetVisual = makeMB("AUTO", "RIGHT", "AUTO_RIGHT", false, function(setActive)
        if State.autoPlayMode == "Auto" then
            if AutoPlay.active and AutoPlay.route == "right" then
                stopAutoPlay()
                setActive(false)
            else
                AutoPlay.route = "right"
                startAutoPlay()
                setActive(true)
            end
            return
        end
        State.autoRightEnabled = not State.autoRightEnabled
        if State.autoRightEnabled then queueAutoRightStart() else stopAutoRight() end
        task.delay(0.2, function() setActive(false) end)
    end)

    makeMB("TP", "DOWN", "TP_DOWN", false, function(setActive)
        runTPFloor()
        task.delay(0.3, function() setActive(false) end)
    end)

    local setCarrymb = makeMB("CARRY", "SPD", "CARRY_SPD", true, function(setActive, isOn)
        if State.laggerToggled then State.laggerToggled = false; State.laggerPhase = 0 end
        State.speedMode = isOn
        refreshSpeedModeLabel()
    end)

    Speed.carryVisual = setCarrymb

    local setLagCarrymb = makeMB("LAGGER", "CARRY", "LAGGER_CARRY", false, function(setActive)
        State.speedMode = false
        if not State.laggerToggled then
            State.laggerToggled = true; State.laggerPhase = 2
        elseif State.laggerPhase == 2 then
            State.laggerPhase = 1
        else
            State.laggerPhase = 2
        end
        refreshSpeedModeLabel()
    end)

    local setLagModemb, _lagModFrame, _lagModTL, _lagModBL
    setLagModemb, _lagModFrame, _lagModTL, _lagModBL = makeMB("LAGGER", "MODE", "LAGGER_MODE", false, function(setActive)
        toggleLaggerMode()
    end)

    TpBat.mobileSet = makeMB("TP", "BAT", "TP_BAT", true, function(setActive, isOn)
        TpBat.setEnabled(isOn)
        saveConfig()
    end)
    TpBat.refresh()

    makeMB("INSTA", "RESET", "INSTANT_RESET", false, function(setActive)
        InstantReset.reset()
        task.delay(0.3, function() setActive(false) end)
    end)

    -- Independent visual states; never recolor the aimbot from a lagger phase.
    Speed.mobileRefresh = function()
        if not UI.alive then return end
        setABmb(State.autoBatEnabled)
        setCarrymb(State.speedMode and not State.laggerToggled and not State.autoCarryFromSteal)
        setLagCarrymb(State.laggerToggled and State.laggerPhase == 2)
        local normalLagger = State.laggerToggled and State.laggerPhase == 1
        setLagModemb(normalLagger)
        if _lagModBL then UI.text(_lagModBL, normalLagger and "SPEED" or "MODE") end
    end
    Speed.mobileRefresh()

    -- Show exactly one layout for the selected Auto Play Mode.
    task.defer(function()
        local left = gui:FindFirstChild("MB_AUTO_LEFT", true)
        local right = gui:FindFirstChild("MB_AUTO_RIGHT", true)
        if left then UI.show(left, true, true) end
        if right then UI.show(right, true, true) end
    end)

    do
        local connection = RunService.Heartbeat:Connect(Speed.mobileRefresh)
        UI.addCleanup(function()
            connection:Disconnect()
            Speed.mobileRefresh = nil
        end)
    end

    -- Continuous mobile size control. Reflow untouched default buttons so they
    -- do not pile on each other; preserve custom dragged placements.
    do
        -- Five compact rows, two buttons per row; no overlapping or hidden
        -- placeholder slots are kept between Carry Speed and the Lagger buttons.
        local slots = {DROP_BR=1, AUTO_LEFT=2, BAT_AIMBOT=3, AUTO_RIGHT=4,
            TP_DOWN=5, CARRY_SPD=6, LAGGER_CARRY=7, LAGGER_MODE=8,
            TP_BAT=9, INSTANT_RESET=10}
        local function geometry(factor)
            local view = Layout.viewport()
            local width = math.floor(68 * factor + 0.5)
            local gap = math.max(3, math.floor(4 * factor + 0.5))
            local rows = math.max(1, math.floor((view.Y - 24 + gap) / (width + gap)))
            local maxColumns = math.max(1, math.floor((view.X - 24 + gap) / (width + gap)))
            local columns = math.min(maxColumns, math.max(2, math.ceil(10 / rows)))
            return view, width, gap, columns, rows, maxColumns
        end
        function Layout.defaultMobilePosition(key, factor)
            local view, width, gap, columns = geometry(factor)
            local slot = (slots[key] or 1) - 1
            local rows = math.ceil(10 / columns)
            local totalWidth = columns * width + (columns - 1) * gap
            local totalHeight = rows * width + (rows - 1) * gap
            local x = view.X - totalWidth - 10 + (slot % columns) * (width + gap)
            local y = math.max(12, (view.Y - totalHeight) / 2) + math.floor(slot / columns) * (width + gap)
            return UDim2.fromOffset(x, y)
        end
        function Layout.applyMobile(value, save)
            local factor = Layout.normalize(value, 0.7, 1.6)
            -- A very small viewport may need a lower limit to keep all ten controls usable.
            while factor > 0.7 do
                local _, _, _, _, rows, columns = geometry(factor)
                if rows * columns >= 10 then break end
                factor = Layout.normalize(factor - 0.1, 0.7, 1.6)
            end
            Layout.mobileFactor = factor
            local view, width = geometry(factor)
            for _, entry in ipairs(mbBtnFrames) do
                local position = UI.goal(entry.frame, "Position")
                local scaledDefault = Layout.defaultMobilePosition(entry.key, factor)
                if entry.autoPlaced == nil then
                    local original = DEFAULT_POSITIONS[entry.key]
                    entry.autoPlaced = original and
                        ((math.abs(position.X.Offset - original.x) < 2 and math.abs(position.Y.Offset - original.y) < 2)
                        or (math.abs(position.X.Offset - scaledDefault.X.Offset) < 2 and math.abs(position.Y.Offset - scaledDefault.Y.Offset) < 2)) or false
                end
                if entry.autoPlaced then position = scaledDefault end
                local x = math.clamp(position.X.Offset, 4, math.max(4, view.X - width - 4))
                local y = math.clamp(position.Y.Offset, 4, math.max(4, view.Y - width - 4))
                UI.animate(entry.frame, {Size = UDim2.fromOffset(width, width), Position = UDim2.fromOffset(x, y)}, 0.28)
                local textSize = math.max(9, math.floor(width / 5.2))
                UI.animate(entry.topLbl, {TextSize = textSize}, 0.28)
                UI.animate(entry.botLbl, {TextSize = textSize}, 0.28)
            end
            if save then safeWriteFile("m10ruMobScaleFactor.txt", tostring(factor)) end
            Layout.refresh()
        end
        Layout.applyMobile(Layout.mobileFactor, false)
    end

    resetMobilePositions = function()
        for _, entry in ipairs(mbBtnFrames) do
            entry.autoPlaced = true
            local destination = Layout.defaultMobilePosition(entry.key, Layout.mobileFactor)
            UI.animate(entry.frame, {Position = destination}, 0.24)
            safeWriteFile("m10ruMB_" .. entry.key .. ".txt", tostring(destination.X.Offset) .. "," .. tostring(destination.Y.Offset))
        end
    end

    -- ============================================================
    -- TWO PURPLE SKINS, shared by Normal V1, Normal V2 and instant SEMI.
    -- No floating names, RAD fields, or ON/OFF buttons; skin 2 has its readiness state.
    -- Shape 1: slim rail + percentage. Shape 2: rounded full-width fill.
    -- ============================================================
    do
        local P = Grab.purple
        local function corner(object, radius)
            Instance.new("UICorner", object).CornerRadius = UDim.new(0, radius)
        end
        local function gradient(parent, first, last)
            local object = Instance.new("UIGradient", parent)
            object.Color = ColorSequence.new(first, last)
            return object
        end
        local function makeView(number, width, height, radius)
            local frame = Instance.new("CanvasGroup", gui)
            frame.Name = "AutoGrabSkin" .. number
            frame.Size = UDim2.fromOffset(width, height)
            frame.AnchorPoint = Vector2.new(0.5, 1)
            frame.Position = UDim2.new(0.5, 0, 1, -88)
            frame.BackgroundColor3 = P.background
            frame.BackgroundTransparency = 0.06
            frame.BorderSizePixel = 0
            frame.Active = true
            frame:SetAttribute("M10RUAlwaysDraggable", true)
            frame.Visible = false
            frame.ZIndex = 10
            corner(frame, radius)
            local stroke = Instance.new("UIStroke", frame)
            stroke.Color = P.light
            stroke.Thickness = 1.3
            stroke.Transparency = 0.12
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local scale = Instance.new("UIScale", frame)
            scale.Name = "AutoGrabScale"
            scale.Scale = 1
            local view = {frame = frame, scale = scale, stroke = stroke, baseSize = UDim2.fromOffset(width, height)}
            Grab.views[number] = view
            drag(frame, frame, true)
            return view
        end
        local function zoomButtons(view)
            for _, item in ipairs({{name="ZoomOut", text="-", x=-58, delta=-0.1},
                {name="ZoomIn", text="+", x=-32, delta=0.1}}) do
                local object = Instance.new("TextButton", view.frame)
                object.Name = item.name
                object.Size = UDim2.fromOffset(22, 22)
                object.Position = UDim2.new(1, item.x, 0.5, -11)
                object.BackgroundColor3 = P.button
                object.BackgroundTransparency = 0.04
                object.BorderSizePixel = 0
                object.AutoButtonColor = false
                object.Text = item.text
                object.TextColor3 = P.text
                object.Font = Enum.Font.GothamBlack
                object.TextSize = 14
                object.ZIndex = 16
                corner(object, 6)
                local stroke = Instance.new("UIStroke", object)
                stroke.Color = P.border
                stroke.Transparency = 0.1
                object.Activated:Connect(function()
                    if _anyKeyListening or not Grab.alive then return end
                    -- zoom controls are retained internally but not exposed on the bar
                    return
                end)
            end
        end

        local one = makeView(1, 250, 34, 6)
        local track = Instance.new("Frame", one.frame)
        track.Name = "ProgressTrack"
        track.Position = UDim2.new(0, 42, 0.5, -7)
        track.Size = UDim2.new(1, -50, 0, 14)
        track.BackgroundColor3 = P.track
        track.BorderSizePixel = 0
        track.ClipsDescendants = true
        track.ZIndex = 11
        corner(track, 7)
        one.fill = Instance.new("Frame", track)
        one.fill.Name = "ProgressFill"
        one.fill.Size = UDim2.new(0, 0, 1, 0)
        one.fill.BackgroundColor3 = P.light
        one.fill.BorderSizePixel = 0
        one.fill.ZIndex = 12
        corner(one.fill, 7)
        gradient(one.fill, P.accent, P.light)
        one.percent = Instance.new("TextLabel", one.frame)
        one.percent.Name = "Percentage"
        one.percent.Position = UDim2.new(0, 7, 0.5, -8)
        one.percent.Size = UDim2.fromOffset(30, 16)
        one.percent.BackgroundTransparency = 1
        one.percent.Text = "0%"
        one.percent.TextColor3 = P.text
        one.percent.Font = Enum.Font.GothamBlack
        one.percent.TextSize = 12
        one.percent.TextXAlignment = Enum.TextXAlignment.Left
        one.percent.ZIndex = 13
        -- no visible V1/V2 zoom controls

        -- Shape 2 rebuilt to the requested layout:
        --   * a THIN rounded-rectangle progress LINE near the bottom of the
        --     card (no more fat circular / pill-shaped fill),
        --   * the small character AVATAR centred ABOVE that line,
        --   * the counter numbers (live % and MAX) on the LEFT, above the line,
        --   * the FPS / PING plate on the RIGHT, kept as it was but without
        --     the old "|" divider.
        -- Card size is driven by these three values - edit them to resize it.
        local GRAB_W, GRAB_H, GRAB_R = 320, 58, 14   -- width, height, corner radius
        local LINE_H, LINE_R = 7, 3                   -- progress line: thickness, corner radius

        local two = makeView(2, GRAB_W, GRAB_H, GRAB_R)
        -- No clipping: the small link card is parented here and sits above it.
        -- (The progress fill is clipped by its own rail, so nothing spills.)
        two.frame.ClipsDescendants = false
        two.frame.BackgroundColor3 = Color3.fromRGB(12, 11, 24)
        two.stroke.Color = Color3.fromRGB(139, 92, 246)
        two.stroke.Thickness = 1.5
        two.stroke.Transparency = 0
        -- Racing light: a bright violet comet chases around the card border
        -- while the rest of the edge stays a dim purple.
        two.outlineGradient = gradient(two.stroke, Color3.fromRGB(58, 22, 112), Color3.fromRGB(58, 22, 112))
        two.outlineGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(58, 22, 112)),
            ColorSequenceKeypoint.new(0.34, Color3.fromRGB(58, 22, 112)),
            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(224, 184, 255)),
            ColorSequenceKeypoint.new(0.66, Color3.fromRGB(58, 22, 112)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(58, 22, 112)),
        })

        -- THIN PROGRESS LINE --------------------------------------------------
        -- A low rectangle with rounded corners (NOT a circle / pill). The fill
        -- grows inside this rail, so it can never run under the avatar or the
        -- FPS / PING text.
        two.track = Instance.new("Frame", two.frame)
        two.track.Name = "ProgressTrack"
        two.track.Position = UDim2.new(0, 12, 1, -15)
        two.track.Size = UDim2.new(1, -24, 0, LINE_H)
        two.track.BackgroundColor3 = P.track
        two.track.BackgroundTransparency = 0.25
        two.track.BorderSizePixel = 0
        two.track.ClipsDescendants = true
        two.track.ZIndex = 11
        corner(two.track, LINE_R)
        local lineStroke = Instance.new("UIStroke", two.track)
        lineStroke.Color = Color3.fromRGB(139, 92, 246)
        lineStroke.Thickness = 1
        lineStroke.Transparency = 0.5
        two.fill = Instance.new("Frame", two.track)
        two.fill.Name = "ProgressFill"
        -- Hard-anchored to the rail's LEFT edge: the fill starts at x = 0 and
        -- grows to the right. Nothing may mirror it.
        two.fill.AnchorPoint = Vector2.new(0, 0)
        two.fill.Position = UDim2.fromOffset(0, 0)
        two.fill.Size = UDim2.fromOffset(0, LINE_H)
        two.fill.BackgroundColor3 = P.light
        two.fill.BackgroundTransparency = 0.10
        two.fill.BorderSizePixel = 0
        two.fill.ZIndex = 12
        corner(two.fill, LINE_R)
        two.fillGradient = gradient(two.fill, P.deep, Color3.fromRGB(154, 108, 255))

        -- CHARACTER AVATAR (moved out of the settings identity badge) ---------
        -- Small head-shot, centred above the progress line.
        two.avatar = Instance.new("ImageLabel", two.frame)
        two.avatar.Name = "GrabAvatar"
        two.avatar.AnchorPoint = Vector2.new(0.5, 0)
        two.avatar.Position = UDim2.new(0.5, 0, 0, 4)
        two.avatar.Size = UDim2.fromOffset(26, 26)
        two.avatar.BackgroundColor3 = Color3.fromRGB(20, 17, 38)
        two.avatar.BorderSizePixel = 0
        two.avatar.ScaleType = Enum.ScaleType.Crop
        two.avatar.ZIndex = 14
        corner(two.avatar, 13)
        local avatarStroke = Instance.new("UIStroke", two.avatar)
        avatarStroke.Color = Color3.fromRGB(139, 92, 246)
        avatarStroke.Thickness = 1.5
        avatarStroke.Transparency = 0.15
        task.spawn(function()
            local ok, thumbnail = pcall(function()
                local players = game:GetService("Players")
                return players:GetUserThumbnailAsync(players.LocalPlayer.UserId,
                    Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
            end)
            if ok and thumbnail and two.avatar.Parent then two.avatar.Image = thumbnail end
        end)

        -- LEFT SIDE: counter numbers ------------------------------------------
        -- Slim violet tick that brightens while a steal target is ready.
        two.accent = Instance.new("Frame", two.frame)
        two.accent.Name = "Accent"
        two.accent.Size = UDim2.fromOffset(3, 34)
        two.accent.Position = UDim2.fromOffset(4, 12)
        two.accent.BackgroundColor3 = Color3.fromRGB(139, 92, 246)
        two.accent.BorderSizePixel = 0
        two.accent.ZIndex = 13
        corner(two.accent, 2)

        -- The number and the state word live in one horizontal row and both
        -- size themselves to their text, so WAIT / STEAL! always sits right
        -- next to the counter instead of floating far to its right.
        local counterRow = Instance.new("Frame", two.frame)
        counterRow.Name = "CounterRow"
        counterRow.Position = UDim2.fromOffset(12, 2)
        counterRow.Size = UDim2.fromOffset(128, 18)
        counterRow.BackgroundTransparency = 1
        counterRow.BorderSizePixel = 0
        counterRow.ZIndex = 14
        local counterLayout = Instance.new("UIListLayout", counterRow)
        counterLayout.FillDirection = Enum.FillDirection.Horizontal
        counterLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        counterLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        counterLayout.SortOrder = Enum.SortOrder.LayoutOrder
        counterLayout.Padding = UDim.new(0, 4)

        two.counter = Instance.new("TextLabel", counterRow)
        two.counter.Name = "GrabCounter"
        two.counter.LayoutOrder = 1
        two.counter.Size = UDim2.new(0, 0, 1, 0)
        two.counter.AutomaticSize = Enum.AutomaticSize.X
        two.counter.BackgroundTransparency = 1
        two.counter.Text = "0%"
        two.counter.TextColor3 = P.text
        two.counter.Font = Enum.Font.GothamBlack
        two.counter.TextSize = 15
        two.counter.TextXAlignment = Enum.TextXAlignment.Left
        two.counter.ZIndex = 14

        two.status = Instance.new("TextLabel", counterRow)
        two.status.Name = "Readiness"
        two.status.LayoutOrder = 2
        two.status.Size = UDim2.new(0, 0, 0, 12)
        two.status.AutomaticSize = Enum.AutomaticSize.X
        two.status.BackgroundTransparency = 1
        two.status.Text = "WAIT"
        two.status.TextColor3 = Color3.fromRGB(167, 139, 250)
        two.status.Font = Enum.Font.GothamBold
        two.status.TextSize = 10
        two.status.TextXAlignment = Enum.TextXAlignment.Left
        two.status.ZIndex = 14

        two.limit = Instance.new("TextLabel", two.frame)
        two.limit.Name = "ProgressLimit"
        two.limit.Position = UDim2.fromOffset(12, 20)
        two.limit.Size = UDim2.fromOffset(84, 12)
        two.limit.BackgroundTransparency = 1
        two.limit.Text = "MAX: 75%"
        two.limit.TextColor3 = Color3.fromRGB(196, 181, 255)
        two.limit.Font = Enum.Font.GothamBlack
        two.limit.TextSize = 9
        two.limit.TextXAlignment = Enum.TextXAlignment.Left
        two.limit.ZIndex = 14

        -- RIGHT SIDE: FPS / PING plate (unchanged, "|" divider removed) ------
        local statsPlate = Instance.new("Frame", two.frame)
        statsPlate.Name = "PerformancePlate"
        statsPlate.Position = UDim2.new(1, -108, 0, 8)
        statsPlate.Size = UDim2.fromOffset(100, 18)
        -- Opaque dark capsule: nothing can bleed through the FPS/PING text.
        statsPlate.BackgroundColor3 = Color3.fromRGB(20, 17, 38)
        statsPlate.BackgroundTransparency = 0
        statsPlate.BorderSizePixel = 0
        statsPlate.ZIndex = 13
        corner(statsPlate, 9)
        local statsStroke = Instance.new("UIStroke", statsPlate)
        statsStroke.Color = Color3.fromRGB(139, 92, 246)
        statsStroke.Transparency = 0.10
        statsStroke.Thickness = 1
        two.stats = Instance.new("TextLabel", statsPlate)
        two.stats.Name = "Performance"
        two.stats.Position = UDim2.fromOffset(0, 0)
        two.stats.Size = UDim2.new(1, 0, 1, 0)
        two.stats.BackgroundTransparency = 1
        two.stats.Text = "FPS --   PING --ms"
        two.stats.TextColor3 = Color3.fromRGB(196, 181, 255)
        two.stats.Font = Enum.Font.GothamSemibold
        two.stats.TextSize = 9
        two.stats.TextXAlignment = Enum.TextXAlignment.Center
        two.stats.ZIndex = 14

        -- EXTRA LINK CARD ----------------------------------------------------
        -- A small companion panel pinned directly ABOVE the Auto Grab card.
        -- NOTE: it cannot be parented to the card - a CanvasGroup always clips
        -- its children to its own rectangle, so it would stay invisible. It is
        -- parented to the same ScreenGui and bound to the card instead: it
        -- follows the card while dragging, scales with it and fades in/out with
        -- it, so it behaves as one attached widget.
        local GRAB_LINK = ".gg/xefq3VrMet"
        local linkPlate = Instance.new("Frame", gui)
        linkPlate.Name = "GrabLinkPlate"
        linkPlate.AnchorPoint = Vector2.new(0.5, 1)
        linkPlate.Size = UDim2.fromOffset(132, 20)
        linkPlate.BackgroundColor3 = Color3.fromRGB(12, 11, 24)
        linkPlate.BackgroundTransparency = 0.06
        linkPlate.BorderSizePixel = 0
        linkPlate.Visible = false
        linkPlate.ZIndex = 12
        corner(linkPlate, 8)
        local linkScale = Instance.new("UIScale", linkPlate)
        linkScale.Name = "GrabLinkScale"
        -- The link must stay readable: it never shrinks below 0.9 even when
        -- the Auto Grab card itself is scaled further down.
        linkScale.Scale = math.max(Grab.getScale(), 0.9)
        local linkStroke = Instance.new("UIStroke", linkPlate)
        linkStroke.Color = Color3.fromRGB(139, 92, 246)
        linkStroke.Thickness = 1.2
        linkStroke.Transparency = 0.15
        local linkButton = Instance.new("TextButton", linkPlate)
        linkButton.Name = "GrabLink"
        linkButton.Size = UDim2.new(1, 0, 1, 0)
        linkButton.BackgroundTransparency = 1
        linkButton.BorderSizePixel = 0
        linkButton.AutoButtonColor = false
        linkButton.Text = GRAB_LINK
        linkButton.TextColor3 = Color3.fromRGB(224, 170, 255)
        linkButton.Font = Enum.Font.GothamBold
        linkButton.TextSize = 11
        linkButton.TextXAlignment = Enum.TextXAlignment.Center
        linkButton.ZIndex = 13
        -- Tapping it copies the link when the executor exposes a clipboard.
        linkButton.Activated:Connect(function()
            if _anyKeyListening or not Grab.alive then return end
            local copied = false
            pcall(function()
                if type(setclipboard) == "function" then setclipboard(GRAB_LINK); copied = true
                elseif type(toclipboard) == "function" then toclipboard(GRAB_LINK); copied = true
                elseif type(clipboard) == "function" then clipboard.set(GRAB_LINK); copied = true end
            end)
            if not copied then return end
            UI.text(linkButton, "COPIED!")
            task.delay(1.2, function()
                if linkButton.Parent then UI.text(linkButton, GRAB_LINK) end
            end)
        end)
        -- Bind the link card to the Auto Grab card: same centre, flush against
        -- the card's top edge (2px overlap kills the seam, so they read as one
        -- attached widget). The card's OWN scale drives the height.
        local function syncLinkPlate()
            local cardScale = two.scale and two.scale.Scale or 1
            local cardTop = two.frame.Position.Y.Offset - (two.frame.Size.Y.Offset * cardScale)
            linkPlate.Position = UDim2.new(
                two.frame.Position.X.Scale, two.frame.Position.X.Offset,
                two.frame.Position.Y.Scale, cardTop + 2)
        end
        Grab.linkFrame, Grab.linkScale, Grab.linkSync = linkPlate, linkScale, syncLinkPlate
        syncLinkPlate()
        two.frame:GetPropertyChangedSignal("Position"):Connect(syncLinkPlate)
        linkScale:GetPropertyChangedSignal("Scale"):Connect(syncLinkPlate)

        -- no visible V1/V2 zoom controls

        Grab.renderConnection = RunService.RenderStepped:Connect(function(dt)
            if not Grab.alive then return end
            local target = Grab.currentEngine() and Grab.getProgress() or 0
            Grab.displayed = Grab.displayed + (target - Grab.displayed) * (1 - math.exp(-dt * 12))
            local progress = math.clamp(Grab.displayed, 0, 1)
            one.fill.Size = UDim2.new(progress, 0, 1, 0)
            one.percent.Text = tostring(math.floor(progress * 100 + 0.5)) .. "%"
            -- The fill lives on its own thin row now, so it shows the true
            -- percentage across the whole rail (no right-side reservation).
            -- Width is computed in PIXELS from the rail's left edge (x = 0),
            -- so the bar can only ever start on the left and grow rightwards.
            do
                local rail = two.track.AbsoluteSize
                local railW = rail.X > 0 and rail.X or (GRAB_W - 24)
                local railH = rail.Y > 0 and rail.Y or LINE_H
                two.fill.Position = UDim2.fromOffset(0, 0)
                two.fill.Size = UDim2.fromOffset(math.max(0, railW * progress), railH)
            end
            if Grab.visibleStyle == 2 then
                local ready = Grab.isReady()
                local phase = Grab.phaseV1
                -- WAIT while the bar fills; STEAL! the moment it reaches the
                -- configured MAX (that is the point where the grab fires).
                local maxFraction = math.clamp((tonumber(State.autoGrabMode) or 100) / 100, 0, 1)
                local stealNow = phase == "finishing"
                    or (maxFraction > 0 and progress >= maxFraction - 0.004)
                    or (maxFraction <= 0 and ready)
                local statusWord = stealNow and "STEAL!" or "WAIT"
                local percentText = tostring(math.floor(progress * 100 + 0.5)) .. "%"
                local bright = stealNow or ready
                UI.text(two.counter, percentText)
                UI.text(two.status, statusWord)
                UI.animate(two.counter, {TextColor3 = bright and Color3.fromRGB(226, 216, 255) or P.text}, 0.16)
                UI.animate(two.status, {TextColor3 = bright and Color3.fromRGB(226, 216, 255) or Color3.fromRGB(167, 139, 250)}, 0.16)
                UI.animate(two.accent, {BackgroundColor3 = bright and P.light or Color3.fromRGB(139, 92, 246)}, 0.16)
                two.outlineGradient.Rotation = (two.outlineGradient.Rotation + dt * 135) % 360
                two.fillGradient.Offset = Vector2.new(math.sin(os.clock() * 1.8) * 0.15, 0)
                -- Real render FPS: count frames over a quarter-second window
                -- and smooth the result, rather than displaying one noisy dt.
                local perf = Grab.perf
                perf.elapsed += dt
                perf.frames += 1
                if perf.elapsed >= 0.25 then
                    local measured = perf.frames / math.max(perf.elapsed, 0.001)
                    perf.fps = perf.fps <= 0 and measured or (perf.fps * 0.65 + measured * 0.35)
                    perf.elapsed, perf.frames = 0, 0
                end
                if tick() - perf.pingAt >= 0.35 then
                    perf.pingAt = tick()
                    local ping = 0
                    pcall(function()
                        ping = math.floor(LP:GetNetworkPing() * 1000 + 0.5)
                    end)
                    if ping <= 0 then
                        pcall(function()
                            local item = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
                            ping = item and math.floor(item:GetValue() + 0.5) or 0
                        end)
                    end
                    perf.ping = ping
                end
                two.stats.Text = string.format("FPS%d   PING %dms", math.floor(perf.fps + 0.5), perf.ping)
                two.limit.Text = "MAX: " .. tostring(math.floor(State.autoGrabMode + 0.5)) .. "%"
            end
        end)
        table.insert(Grab.connections, gui.Destroying:Connect(Grab.destroy))
        Grab.refresh()
    end
    -- Sticky category navigation. Only the selected section is shown. SPEED is
    -- selected at launch so the sections never pile up in one long view.
    do
        -- Top Category Bar: Positioned prominently at the top below the header logo
        local categoryBar = Instance.new("Frame", main)
        categoryBar.Name = "StickyCategoryBar"
        categoryBar.Size = UDim2.new(1, -16, 0, 32)
        categoryBar.Position = UDim2.new(0, 8, 0, 74)
        categoryBar.BackgroundColor3 = UI.theme.panel
        categoryBar.BorderSizePixel = 0
        categoryBar.ZIndex = 30
        Instance.new("UICorner", categoryBar).CornerRadius = UDim.new(0, 8)
        local catBarStroke = Instance.new("UIStroke", categoryBar)
        catBarStroke.Color = UI.theme.border
        catBarStroke.Thickness = 1
        catBarStroke.Transparency = 0.5

        local categories = {"SPEED", "COMBAT", "VISUAL", "MISC", "KEYBINDS"}
        local categoryButtons = {}
        local layout = Instance.new("UIListLayout", categoryBar)
        layout.FillDirection = Enum.FillDirection.Horizontal
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        layout.VerticalAlignment = Enum.VerticalAlignment.Center
        layout.Padding = UDim.new(0, 3)

        local pad = Instance.new("UIPadding", categoryBar)
        pad.PaddingLeft = UDim.new(0, 3)
        pad.PaddingRight = UDim.new(0, 3)
        pad.PaddingTop = UDim.new(0, 2)
        pad.PaddingBottom = UDim.new(0, 2)

        local function selectCategory(target)
            local ref = sectionRefs[target]
            if not ref then return end
            UI.activeSection = target
            local startOrder = ref.LayoutOrder
            local nextOrder = math.huge
            for _, other in ipairs(sf:GetChildren()) do
                if other:IsA("GuiObject") and other:GetAttribute("M10RUSection") == true
                    and other.LayoutOrder > startOrder then
                    nextOrder = math.min(nextOrder, other.LayoutOrder)
                end
            end
            for _, child in ipairs(sf:GetChildren()) do
                if child:IsA("GuiObject") then
                    local order = child.LayoutOrder
                    local visible = order >= startOrder and order < nextOrder
                    local manuallyVisible = child:GetAttribute("M10RUManualVisible")
                    if manuallyVisible ~= nil then visible = visible and manuallyVisible == true end
                    child.Visible = visible
                end
            end
            sf.CanvasPosition = Vector2.new(0, 0)

            for category, record in pairs(categoryButtons) do
                local selected = category == target
                UI.animate(record.button, {
                    BackgroundColor3 = selected and UI.theme.deep or Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = selected and 0 or 1,
                    TextColor3 = selected and UI.theme.text or UI.theme.muted,
                    TextSize = selected and 11 or 10,
                }, 0.18)
                UI.animate(record.stroke, {
                    Color = selected and UI.theme.accent or UI.theme.border,
                    Thickness = selected and 1.5 or 0,
                    Transparency = selected and 0 or 1,
                }, 0.18)
            end
        end

        for categoryIndex, category in ipairs(categories) do
            local target = category
            local b = Instance.new("TextButton", categoryBar)
            b.Name = "Category_" .. target:gsub("%s", "")
            b.Size = UDim2.new(1 / #categories, -3, 1, -2)
            b.LayoutOrder = categoryIndex
            b.BackgroundColor3 = UI.theme.button
            b.BackgroundTransparency = 1
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Text = target == "KEYBINDS" and "BINDS" or target:sub(1, 4)
            b.TextColor3 = UI.theme.muted
            b.Font = Enum.Font.GothamBold
            b.TextSize = 10
            b.ZIndex = 31
            Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
            local st = Instance.new("UIStroke", b)
            st.Color = UI.theme.border
            st.Thickness = 0
            st.Transparency = 1
            categoryButtons[target] = {button = b, stroke = st}
            b.Activated:Connect(function()
                selectCategory(target)
            end)
        end

        -- Initial state: open directly on SPEED, never on every section at once.
        selectCategory("SPEED")
    end

    UI.ready = true

end

-- ========================================================================
-- CONFIGURATION RESTORATION
-- ========================================================================
local _savedCfg = nil

local function loadConfigKeys()
    local raw = safeReadFile("m10ru_duels_config.json") or safeReadFile("m10ru_duels_backup.json")
    if not raw then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or not cfg then return end
    _savedCfg = cfg
    -- Restored here (synchronously, before the intro thread fires) so turning
    -- the Intro toggle OFF really keeps the intro from playing on the next run.
    if cfg.introEnabled ~= nil then State.introEnabled = cfg.introEnabled == true end
    if cfg.espEnabled ~= nil then State.espEnabled = cfg.espEnabled == true end
    if cfg.tracersEnabled ~= nil then State.tracersEnabled = cfg.tracersEnabled == true end
    if cfg.fpsBoost ~= nil then State.fpsBoostEnabled = cfg.fpsBoost == true end
    if cfg.autoGrabStopEnabled ~= nil then State.autoGrabStopEnabled = cfg.autoGrabStopEnabled == true end

    local function lk(e, d)
        if type(d) ~= "table" then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end

    lk(KB.DropBrainrot, cfg.dropBrainrotKey)
    lk(KB.AutoLeft, cfg.autoLeftKey)
    lk(KB.AutoRight, cfg.autoRightKey)
    lk(KB.AutoBat, cfg.autoBatKey)
    lk(KB.LaggerToggle, cfg.laggerToggleKey)
    lk(KB.TPFloor, cfg.tpFloorKey)
    lk(KB.TpBat, cfg.tpBatKey or cfg.tpBatNormalKey)
    lk(KB.InstantReset, cfg.instantResetKey or cfg.instaResetKey)
    lk(KB.GuiHide, cfg.guiHideKey)
    lk(KB.SpeedToggle, cfg.speedToggleKey)
    if (KB.LaggerToggle.kb and KB.InstantReset.kb and KB.LaggerToggle.kb == KB.InstantReset.kb)
        or (KB.LaggerToggle.gp and KB.InstantReset.gp and KB.LaggerToggle.gp == KB.InstantReset.gp) then
        KB.LaggerToggle.kb, KB.LaggerToggle.gp = Enum.KeyCode.G, nil
    end

    if cfg.normalSpeed and type(cfg.normalSpeed) == "number" then State.NS = cfg.normalSpeed end
    if cfg.carrySpeed and type(cfg.carrySpeed) == "number" then State.CS = cfg.carrySpeed end
    if cfg.autoSwitchCarrySpeed ~= nil then
        State.autoCarrySpeedEnabled = cfg.autoSwitchCarrySpeed == true
    elseif cfg.autoCarrySpeed ~= nil then
        State.autoCarrySpeedEnabled = cfg.autoCarrySpeed == true
    end
    -- Radius is intentionally not loaded from old configs. Yout's 61-stud
    -- limit is authoritative for both visual and normal grab targeting.
    State.StealV1.StealRadius, State.StealV2.StealRadius = 61, 61
    if type(cfg.autoGrabMode) == "number" then
        State.autoGrabMode = math.clamp(math.round(cfg.autoGrabMode), 0, 100)
        State.autoGrabStopTime = State.autoGrabMode == 0 and 0 or (State.autoGrabMode / 100) * State.StealV1.StealDuration
    end
    Grab.loadSettings(cfg)
    if cfg.antiRagdollMode == "Off" or cfg.antiRagdollMode == "Normal" or cfg.antiRagdollMode == "Custom" then
        State.antiRagdollMode = cfg.antiRagdollMode
    else
        State.antiRagdollMode = cfg.antiRagdoll == true and "Normal" or "Off"
    end
    if cfg.laggerSpeed and type(cfg.laggerSpeed) == "number" then State.LAGGER_SPEED = cfg.laggerSpeed end
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed) == "number" then State.LAGGER_CARRY_SPEED = cfg.laggerCarrySpeed end
    if cfg.speedEngine ~= "Arabi" then
        if cfg.laggerSpeed == 40 then State.LAGGER_SPEED = 15 end
        if cfg.laggerCarrySpeed == 20 then State.LAGGER_CARRY_SPEED = 24.5 end
    end
    if cfg.autoTPHeight and type(cfg.autoTPHeight) == "number" then State.autoTPHeight = cfg.autoTPHeight end
    if type(cfg.bodyLockRange) == "number" then State.bodyLockRange = math.clamp(math.floor(cfg.bodyLockRange), 5, 200) end
    -- Body Lock now restores its saved state: the pill is wired to the engine
    -- (BodyLock.visual), so a re-armed lock shows as ON instead of silently
    -- running while the pill looked Off.
    if cfg.bodyLockEnabled ~= nil then State.bodyLockEnabled = cfg.bodyLockEnabled == true end
    if cfg.antiFling ~= nil then State.antiFlingEnabled = cfg.antiFling == true end
    if cfg.instantResetOnDie ~= nil then State.instantResetOnDieEnabled = cfg.instantResetOnDie == true end
    if cfg.autoSwing ~= nil then State.autoSwingEnabled = cfg.autoSwing == true end
    if type(cfg.animPack) == "string" and table.find(HORIZON_ANIMATION_PACK_LIST, cfg.animPack) then
        State.animPack = cfg.animPack
    end
end

local function loadConfigState()
    local cfg = _savedCfg
    if not cfg then return end

    if cfg.autoPlayMode == "Auto" or cfg.autoPlayMode == "Half" then
        State.autoPlayMode = cfg.autoPlayMode
    else
        local savedMode = safeReadFile("m10ruAutoPlayMode.txt")
        if savedMode == "Auto" or savedMode == "Half" then
            State.autoPlayMode = savedMode
        end
    end

    if normalBox then normalBox.Text = tostring(State.NS) end
    if carryBox then carryBox.Text = tostring(State.CS) end
    if laggerCarryBox then laggerCarryBox.Text = tostring(State.LAGGER_CARRY_SPEED) end
    if autoTPHeightBox then autoTPHeightBox.Text = tostring(State.autoTPHeight) end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(State.bodyLockRange) end

    task.spawn(function()
        task.wait(0.15)
        if cfg.infJumpMode then
            State.infJumpMode = cfg.infJumpMode
            if setJumpModeVisual then setJumpModeVisual(State.infJumpMode) end
        end
        AntiDie.setEnabled(cfg.antiDie == true)
        BodyLock.setEnabled(State.bodyLockEnabled)
        AntiFling.setEnabled(State.antiFlingEnabled)
        DeathReset.setEnabled(State.instantResetOnDieEnabled)
        AnimPack.apply(State.animPack)
        if State.instantResetOnDieEnabled and State.antiDieEnabled then
            AntiDie.setEnabled(false)
            if AntiDie.visual then AntiDie.visual(false) end
        end
        Ragdoll.setMode(State.antiRagdollMode)
        Grab.applyScale()
        Grab.restore()
        if setAutoGrabVisual then setAutoGrabVisual(State.SemiNormalOpen) end

        if TpBat.refreshModeUI then TpBat.refreshModeUI() end
        if cfg.tpBatEnabled == true then TpBat.setEnabled(true) end
        if cfg.infiniteJump then
            State.infJumpEnabled = true
            if setInfJumpVisual then setInfJumpVisual(true) end
        end
        if cfg.medusaCounter then
            State.medusaCounterEnabled = true
            if setMedusaVisual then setMedusaVisual(true) end
            setupMedusa(LP.Character)
        end
        if cfg.batCounter then
            State.batCounterEnabled = true
            if setBatCounterVisual then setBatCounterVisual(true) end
            startBatCounter()
        end
        if cfg.laggerMode then
            State.laggerToggled = true
            State.speedMode = false
            if cfg.laggerCarryMode then
                State.laggerPhase = 2
            else
                State.laggerPhase = 1
            end
            refreshSpeedModeLabel()
        elseif cfg.carryMode then
            State.speedMode = false
            toggleCarryMode()
        end
        if State.autoCarrySpeedEnabled then
            -- Keep the SPEED switch armed; Horizon's logic selects Carry only
            -- when a prompt/steal/carry handoff is actually detected.
            if setAutoSwitchSpeedVisual then setAutoSwitchSpeedVisual(true) end
            refreshSpeedModeLabel()
        end
        if cfg.autoTPEnabled then
            State.autoTPEnabled = true
            if setAutoTPVisual then setAutoTPVisual(true) end
            startAutoTP()
        end
        AutoSwing.setEnabled(State.autoSwingEnabled)
        if cfg.autoBat then
            State.autoBatEnabled = true
            if setAutoBatVisual then setAutoBatVisual(true) end
            queueAutoBatStart()
        end
        if cfg.unwalkEnabled then
            State.unwalkEnabled = true
            if setUnwalkVisual then setUnwalkVisual(true) end
            task.spawn(function() task.wait(0.5); startUnwalk() end)
        end
        if cfg.antiLag then
            enableAntiLag()
            if setAntiLagVisual then setAntiLagVisual(true) end
        end
        if cfg.fpsBoost then
            applyFPSBoost()
            if setFPSBoostVisual then setFPSBoostVisual(true) end
        end
        if cfg.espEnabled and applyESPState then applyESPState(true) end
        if cfg.tracersEnabled and applyTracersState then applyTracersState(true) end
        if cfg.stretchRez then
            enableStretchRez()
            if setStretchRezVisual then setStretchRezVisual(true) end
        end

        if cfg.introEnabled ~= nil then
            State.introEnabled = cfg.introEnabled == true
            if setIntroVisual then setIntroVisual(State.introEnabled) end
        end
        if cfg.skyTheme and M10RU_SKY_PRESETS[cfg.skyTheme] then
            currentSkyTheme = cfg.skyTheme
            if currentSkyTheme ~= "Off" then m10ruApplySky(currentSkyTheme) end
            if setSkyVisual then setSkyVisual(currentSkyTheme) end
        end
    end)
end

-- ========================================================================
-- INTRO SCREEN - BLACK SPACE / FLYING STARS / PURPLE "M10RU DUELS" + CHARGE LINE
-- ========================================================================
local function playM10RUIntro()
    if not State.introEnabled then return end

    local parent = getSafeGuiParent()

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "M10RUDuelsIntro"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 5000
    protectGuiObject(screenGui)
    screenGui.Parent = parent

    local PURPLE_ACCENT = UI.theme.accent
    local PURPLE_DEEP   = Color3.fromRGB(74, 22, 128)
    local PURPLE_LIGHT  = UI.theme.light
    local PURPLE_FILL   = Color3.fromRGB(178, 102, 255)

    local rng = Random.new(os.clock() * 9973)

    local finished = false
    local starConnection = nil

    local function tween(object, duration, style, direction, goal)
        if finished then return end
        pcall(function()
            TweenService:Create(object, TweenInfo.new(duration, style, direction), goal):Play()
        end)
    end

    -- --------------------------------------------------------------------
    -- PURE BLACK SPACE
    -- --------------------------------------------------------------------
    local space = Instance.new("Frame")
    space.Name = "Space"
    space.Size = UDim2.fromScale(1, 1)
    space.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    space.BorderSizePixel = 0
    space.ZIndex = 1
    space.Parent = screenGui

    -- Everything that animates lives inside one CanvasGroup, so the intro can
    -- dissolve in a single smooth step (exactly like a skip).
    local content = Instance.new("CanvasGroup")
    content.Name = "IntroContent"
    content.Size = UDim2.fromScale(1, 1)
    content.BackgroundTransparency = 1
    content.GroupTransparency = 1
    content.ZIndex = 2
    content.Parent = screenGui

    -- --------------------------------------------------------------------
    -- PURPLE NEBULA GLOW (built from frames, no external assets)
    -- --------------------------------------------------------------------
    for index = 1, 3 do
        local blob = Instance.new("Frame")
        blob.Name = "Nebula" .. index
        blob.AnchorPoint = Vector2.new(0.5, 0.5)
        blob.Position = UDim2.fromScale(0.16 + index * 0.26, 0.2 + (index % 2) * 0.55)
        blob.Size = UDim2.fromScale(0.64, 0.64)
        blob.Rotation = index * 26
        blob.BackgroundColor3 = index == 2 and PURPLE_DEEP or PURPLE_ACCENT
        blob.BackgroundTransparency = 0.9
        blob.BorderSizePixel = 0
        blob.ZIndex = 2
        Instance.new("UICorner", blob).CornerRadius = UDim.new(1, 0)
        local gradient = Instance.new("UIGradient", blob)
        gradient.Rotation = index * 70
        gradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.25),
            NumberSequenceKeypoint.new(0.55, 0.92),
            NumberSequenceKeypoint.new(1, 1),
        })
        blob.Parent = content
    end

    -- --------------------------------------------------------------------
    -- FLYING STARFIELD: small white stars with a purple hue
    -- --------------------------------------------------------------------
    local starLayer = Instance.new("Frame")
    starLayer.Name = "StarField"
    starLayer.BackgroundTransparency = 1
    starLayer.Size = UDim2.fromScale(1, 1)
    starLayer.ZIndex = 3
    starLayer.Parent = content

    local stars = {}
    for index = 1, 96 do
        local size = rng:NextInteger(1, 3)
        local star = Instance.new("Frame")
        star.Name = "Star"
        star.AnchorPoint = Vector2.new(0.5, 0.5)
        star.BorderSizePixel = 0
        star.BackgroundTransparency = 0.2
        star.Size = UDim2.fromOffset(size, size)
        star.ZIndex = 3
        Instance.new("UICorner", star).CornerRadius = UDim.new(1, 0)

        -- Mostly pure white stars, with a purple minority for the purple space.
        local roll = rng:NextNumber()
        if roll > 0.84 then
            star.BackgroundColor3 = PURPLE_LIGHT
        elseif roll > 0.68 then
            star.BackgroundColor3 = PURPLE_FILL
        else
            star.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end

        local angle = rng:NextNumber(-0.5, 0.5)
        local speed = rng:NextNumber(0.05, 0.2)
        local startX = rng:NextNumber()
        local startY = rng:NextNumber()
        star.Position = UDim2.fromScale(startX, startY)
        star.Parent = starLayer

        stars[index] = {
            object = star,
            x = startX,
            y = startY,
            vx = math.cos(angle) * speed * (rng:NextNumber() < 0.5 and -1 or 1),
            vy = math.sin(angle) * speed,
            phase = rng:NextNumber(0, math.pi * 2),
            twinkle = rng:NextNumber(1.5, 4),
            base = rng:NextNumber(0.15, 0.55),
            bright = size >= 3,
        }
    end

    -- A few fast streaks for depth.
    local streaks = {}
    for index = 1, 4 do
        local streak = Instance.new("Frame")
        streak.Name = "Streak" .. index
        streak.AnchorPoint = Vector2.new(0.5, 0.5)
        streak.BackgroundColor3 = PURPLE_LIGHT
        streak.BackgroundTransparency = 0.3
        streak.BorderSizePixel = 0
        streak.Rotation = 18
        streak.Size = UDim2.fromOffset(rng:NextInteger(18, 42), 1)
        streak.ZIndex = 3
        Instance.new("UICorner", streak).CornerRadius = UDim.new(1, 0)
        streak.Position = UDim2.fromScale(rng:NextNumber(-0.1, 1), rng:NextNumber())
        streak.Parent = starLayer

        streaks[index] = {
            object = streak,
            x = rng:NextNumber(-0.1, 1),
            y = rng:NextNumber(0, 0.9),
            speed = rng:NextNumber(0.32, 0.58),
        }
    end

    local clock = 0
    starConnection = RunService.RenderStepped:Connect(function(delta)
        if finished or not screenGui.Parent then return end
        clock = clock + delta

        for _, record in ipairs(stars) do
            local object = record.object
            if object and object.Parent then
                record.x = record.x + record.vx * delta
                record.y = record.y + record.vy * delta
                if record.x > 1.08 then
                    record.x = -0.08
                    record.y = rng:NextNumber()
                elseif record.x < -0.08 then
                    record.x = 1.08
                    record.y = rng:NextNumber()
                end
                if record.y > 1.08 then
                    record.y = -0.08
                    record.x = rng:NextNumber()
                elseif record.y < -0.08 then
                    record.y = 1.08
                    record.x = rng:NextNumber()
                end
                object.Position = UDim2.fromScale(record.x, record.y)

                local shimmer = (math.sin(clock * record.twinkle + record.phase) + 1) * 0.5
                local transparency = record.base + (1 - shimmer) * 0.45
                if record.bright then transparency = transparency - 0.22 end
                object.BackgroundTransparency = math.clamp(transparency, 0, 0.96)
            end
        end

        for _, record in ipairs(streaks) do
            local object = record.object
            if object and object.Parent then
                record.x = record.x + record.speed * delta
                if record.x > 1.15 then
                    record.x = -0.15
                    record.y = rng:NextNumber(0, 0.85)
                end
                object.Position = UDim2.fromScale(record.x, record.y)
                object.BackgroundTransparency = 0.2 + 0.35 * math.abs(math.sin(clock * 1.5 + record.y * 6))
            end
        end
    end)

    -- --------------------------------------------------------------------
    -- TITLE: "M10RU Duels" in purple
    -- --------------------------------------------------------------------
    local titleHolder = Instance.new("Frame")
    titleHolder.Name = "TitleHolder"
    titleHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    titleHolder.Position = UDim2.fromScale(0.5, 0.5)
    titleHolder.Size = UDim2.fromScale(0.5, 0.11)
    titleHolder.BackgroundTransparency = 1
    titleHolder.ZIndex = 6
    titleHolder.Parent = content

    local titleGlow = Instance.new("TextLabel")
    titleGlow.Name = "TitleGlow"
    titleGlow.Size = UDim2.fromScale(1, 1)
    titleGlow.BackgroundTransparency = 1
    titleGlow.Text = "M10RU Duels"
    titleGlow.Font = Enum.Font.GothamBlack
    titleGlow.TextScaled = true
    titleGlow.TextColor3 = PURPLE_DEEP
    titleGlow.TextTransparency = 1
    titleGlow.ZIndex = 5
    local glowStroke = Instance.new("UIStroke", titleGlow)
    glowStroke.Color = PURPLE_FILL
    glowStroke.Thickness = 2.5
    glowStroke.Transparency = 1
    titleGlow.Parent = titleHolder

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.fromScale(1, 1)
    title.BackgroundTransparency = 1
    title.Text = "M10RU Duels"
    title.Font = Enum.Font.GothamBlack
    title.TextScaled = true
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextTransparency = 1
    title.ZIndex = 6
    local titleGradient = Instance.new("UIGradient", title)
    titleGradient.Rotation = 90
    titleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PURPLE_LIGHT),
        ColorSequenceKeypoint.new(0.45, PURPLE_FILL),
        ColorSequenceKeypoint.new(1, PURPLE_ACCENT),
    })
    title.Parent = titleHolder

    -- --------------------------------------------------------------------
    -- CHARGE LINE: keeps filling with purple under the word
    -- --------------------------------------------------------------------
    local track = Instance.new("Frame")
    track.Name = "ChargeTrack"
    track.AnchorPoint = Vector2.new(0.5, 0.5)
    track.Position = UDim2.fromScale(0.5, 0.6)
    track.Size = UDim2.new(0.4, 0, 0, 4)
    track.BackgroundColor3 = Color3.fromRGB(38, 22, 62)
    track.BackgroundTransparency = 1
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.ZIndex = 6
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)
    local trackStroke = Instance.new("UIStroke", track)
    trackStroke.Color = PURPLE_FILL
    trackStroke.Thickness = 1
    trackStroke.Transparency = 1
    track.Parent = content

    local fill = Instance.new("Frame")
    fill.Name = "ChargeFill"
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = PURPLE_ACCENT
    fill.BorderSizePixel = 0
    fill.ZIndex = 7
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillGradient = Instance.new("UIGradient", fill)
    fillGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, PURPLE_DEEP),
        ColorSequenceKeypoint.new(0.65, PURPLE_ACCENT),
        ColorSequenceKeypoint.new(1, PURPLE_LIGHT),
    })
    fill.Parent = track

    local fillHead = Instance.new("Frame")
    fillHead.Name = "ChargeHead"
    fillHead.AnchorPoint = Vector2.new(0.5, 0.5)
    fillHead.Position = UDim2.fromScale(0, 0.5)
    fillHead.Size = UDim2.new(0, 10, 0, 10)
    fillHead.BackgroundColor3 = PURPLE_LIGHT
    fillHead.BackgroundTransparency = 1
    fillHead.BorderSizePixel = 0
    fillHead.ZIndex = 8
    Instance.new("UICorner", fillHead).CornerRadius = UDim.new(1, 0)
    fillHead.Parent = track

    -- --------------------------------------------------------------------
    -- EXIT (also used by the one click/tap skip)
    -- --------------------------------------------------------------------
    local function finishIntro()
        if finished then return end
        finished = true
        if starConnection then
            pcall(function() starConnection:Disconnect() end)
            starConnection = nil
        end
        pcall(function()
            TweenService:Create(content, TweenInfo.new(0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {GroupTransparency = 1}):Play()
            TweenService:Create(space, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 1}):Play()
        end)
        task.delay(0.55, function()
            pcall(function() screenGui:Destroy() end)
        end)
    end

    -- Skip button removed

    -- --------------------------------------------------------------------
    -- ANIMATION TIMELINE
    -- --------------------------------------------------------------------
    task.spawn(function()
        -- Intro music (unchanged asset).
        pcall(function()
            local asset = safeGetAsset("m10ruDuelsIntro_iyw1cb.mp3")
            if asset and asset ~= "" then
                local sound = Instance.new("Sound")
                sound.Name = "M10RUDuelsIntroSong"
                sound.SoundId = asset
                sound.Volume = 1
                sound.Parent = parent
                sound:Play()
            end
        end)

        if finished or not screenGui.Parent then return end

        -- Space fades in, then the word rises into place with a purple glow.
        tween(content, 0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {GroupTransparency = 0})
        tween(titleGlow, 0.95, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {TextTransparency = 0.55})
        tween(glowStroke, 0.95, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {Transparency = 0.5})
        tween(title, 0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 0})
        tween(titleHolder, 0.95, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
            Size = UDim2.fromScale(0.62, 0.142),
            Position = UDim2.fromScale(0.5, 0.45),
        })

        -- Breathing purple glow while the intro is on screen.
        task.spawn(function()
            local dim = false
            while not finished and screenGui.Parent do
                dim = not dim
                tween(glowStroke, 1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {
                    Transparency = dim and 0.75 or 0.5,
                })
                task.wait(1.1)
            end
        end)

        task.wait(0.45)
        if finished then return end

        -- The charge line appears and keeps filling with purple.
        tween(track, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundTransparency = 0})
        tween(trackStroke, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {Transparency = 0.35})
        tween(fillHead, 0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {BackgroundTransparency = 0})
        tween(fill, 4.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {Size = UDim2.fromScale(1, 1)})
        tween(fillHead, 4.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, {Position = UDim2.fromScale(1, 0.5)})

        task.spawn(function()
            local big = false
            while not finished and screenGui.Parent do
                big = not big
                tween(fillHead, 0.34, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, {
                    Size = UDim2.new(0, big and 16 or 10, 0, big and 16 or 10),
                })
                task.wait(0.34)
            end
        end)

        task.wait(4.8)
        if finished then return end

        -- Charge complete: the intro dissolves smoothly, like a skip.
        tween(title, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 1})
        tween(titleGlow, 0.3, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, {TextTransparency = 1})
        tween(titleHolder, 0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.Out, {
            Size = UDim2.fromScale(0.68, 0.156),
            Position = UDim2.fromScale(0.5, 0.44),
        })
        task.wait(0.14)
        finishIntro()
    end)
end

-- Song Preload (Failsafe)
task.spawn(function()
    pcall(function()
        if not safeIsFile("m10ruDuelsIntro_iyw1cb.mp3") then
            local songData = safeHttpGet("https://files.catbox.moe/iyw1cb.mp3")
            if songData then
                safeWriteFile("m10ruDuelsIntro_iyw1cb.mp3", songData)
            end
        end
    end)
    task.wait(0.3)
    playM10RUIntro()
end)

-- ========================================================================
-- INITIALIZATION (protected: shows error on screen if boot fails)
-- ========================================================================
local function m10ruShowBootError(where, err)
    pcall(function()
        local parent = getSafeGuiParent()
        local old = parent:FindFirstChild("M10RUBootError")
        if old then old:Destroy() end
        local g = Instance.new("ScreenGui")
        g.Name = "M10RUBootError"
        g.ResetOnSpawn = false
        g.DisplayOrder = 9999
        g.Parent = parent
        local t = Instance.new("TextLabel")
        t.Size = UDim2.new(1, -20, 0, 140)
        t.Position = UDim2.new(0, 10, 0, 120)
        t.BackgroundColor3 = UI.theme.panel
        t.BackgroundTransparency = 0.2
        t.BorderSizePixel = 0
        t.TextColor3 = UI.theme.text
        t.Font = Enum.Font.GothamBold
        t.TextSize = 13
        t.TextWrapped = true
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.TextYAlignment = Enum.TextYAlignment.Top
        t.Text = "M10RU Duels BOOT ERROR [" .. tostring(where) .. "]: " .. tostring(err)
        t.Parent = g
    end)
    warn("[M10RU Duels] Boot failed at " .. tostring(where) .. ": " .. tostring(err))
end

local tracebackHandler = type(debug) == "table" and type(debug.traceback) == "function"
    and debug.traceback or function(err) return tostring(err) end
local okKeys, errKeys = xpcall(loadConfigKeys, tracebackHandler)
if not okKeys then m10ruShowBootError("loadConfigKeys", errKeys) end
local okBuild, errBuild = xpcall(buildGui, tracebackHandler)
if not okBuild then
    m10ruShowBootError("buildGui", errBuild)
else
    local okState, errState = xpcall(loadConfigState, tracebackHandler)
    if not okState then
        m10ruShowBootError("loadConfigState", errState)
    elseif okKeys then
        print("[M10RU Duels] Interface loaded successfully (purple auto grab).")
    else
        warn("[M10RU Duels] Interface loaded, but configuration could not be fully restored. See M10RUBootError.")
    end
end
