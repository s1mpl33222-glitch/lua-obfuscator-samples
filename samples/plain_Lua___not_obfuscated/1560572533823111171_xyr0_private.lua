local _RP, _RW = print, warn
_G.xyr0StealWhy = "boot"
_G.xyr0StealLog = {}
_G.xyr0StealSay = function(msg)
    msg = tostring(msg)
    _G.xyr0StealWhy = msg
    local L = _G.xyr0StealLog
    local now = os.clock()
    local last = L[#L]
    if last and last.msg == msg then
        last.n = last.n + 1
        last.t = now
    else
        L[#L + 1] = { msg = msg, t = now, t0 = now, n = 1 }
        while #L > 8 do table.remove(L, 1) end
    end
    if _G.xyr0StealDebug then
        if now - (_G._mkLastSay or 0) >= (tonumber(_G.xyr0StealDebugGap) or 0.5) then
            _G._mkLastSay = now
            pcall(_RP, "[steal] " .. msg)
        end
    end
end

_G.xyr0ScanProfile = function(mode)
    if mode == "fast" then
        _G.xyr0ScanMode     = "fast"
        _G.xyr0PanelScanGap = tonumber(_G.xyr0FastPanelGap)    or 0.12
        _G.xyr0RepickGap    = tonumber(_G.xyr0FastRepickGap)   or 0.10
        _G.xyr0InRangeGap   = tonumber(_G.xyr0FastInRangeGap)  or 0.10
        _G.xyr0WatchdogTick = tonumber(_G.xyr0FastWatchdogTick) or 0.15
        _G.xyr0SyncScanGap  = tonumber(_G.xyr0FastSyncGap)     or 0.05
        _G.xyr0AutoTPPoll   = tonumber(_G.xyr0FastTPPoll)      or 0.03
    else
        _G.xyr0ScanMode     = "normal"
        _G.xyr0PanelScanGap = tonumber(_G.xyr0NormPanelGap)    or 0.6
        _G.xyr0RepickGap    = tonumber(_G.xyr0NormRepickGap)   or 0.5
        _G.xyr0InRangeGap   = tonumber(_G.xyr0NormInRangeGap)  or 0.3
        _G.xyr0WatchdogTick = tonumber(_G.xyr0NormWatchdogTick) or 0.3
        _G.xyr0SyncScanGap  = tonumber(_G.xyr0NormSyncGap)     or 0.25
        _G.xyr0AutoTPPoll   = tonumber(_G.xyr0NormTPPoll)      or 0.05
    end
    if _G.xyr0StealSay then _G.xyr0StealSay("scan profile -> " .. tostring(_G.xyr0ScanMode)) end
end
_G.xyr0ScanProfile("fast")
task.delay(tonumber(_G.xyr0FastWindow) or 60, function()
    if _G.xyr0ScanMode == "fast" then _G.xyr0ScanProfile("normal") end
end)
local print = function() end
local warn  = function() end
_G.xyr0InvisAuto = false
_G.xyr0AutoKickOnSteal = false
_G.xyr0AutoBuy = false
if _G.xyr0StealMode == nil then _G.xyr0StealMode = "priority" end
if _G.xyr0AutoTP == nil then _G.xyr0AutoTP = true end

-- TP safety: prefer a slightly slower, more stable route over hard misses/deaths.
if _G.xyr0TPSafeMode == nil then _G.xyr0TPSafeMode = true end
if _G.xyr0TPSafeSpeed == nil then _G.xyr0TPSafeSpeed = 300 end
if _G.xyr0TPSafeVerticalSpeed == nil then _G.xyr0TPSafeVerticalSpeed = 110 end
if _G.xyr0TPReachTolerance == nil then _G.xyr0TPReachTolerance = 4.5 end
if _G.xyr0TPRetryCount == nil then _G.xyr0TPRetryCount = 2 end
if _G.xyr0TPRetryDelay == nil then _G.xyr0TPRetryDelay = 0.08 end
if _G.xyr0VoidRecover == nil then _G.xyr0VoidRecover = true end

if not game:IsLoaded() then game.Loaded:Wait() end

--[[ Net env-spoof: DISABLED (Elite parity) ------------------------------------
     This used to require ReplicatedStorage.Packages.Net and then write into the
     game module's own environment:
         env.getfenv                  = <our function>
         setreadonly(env.debug, false)
         env.debug.getmemorycategory  = function() return "--" end
     re-applied 80x over 8 seconds.

     That is the loudest signal in this script, and it is self-defeating. The
     Net wrapper calls debug.getmemorycategory() to identify its caller. Legit
     game code returns a real script category; this returned the literal "--",
     which is not a valid category -- so anything validating the returned value
     against a known set sees "--" and flags immediately. Leaving env.debug
     writable via setreadonly is independently checkable (table.isfrozen).

     Elite never requires the module at all, so it never meets this check.
     xyr0 no longer needs it either: the grapple now resolves the UseItem
     RemoteEvent structurally and calls FireServer on the raw Instance, which
     never enters the Net wrapper.

     Set _G.xyr0NetSpoofEnable = true to restore the old behaviour.
--------------------------------------------------------------------------- ]]
do
    local RS = game:GetService("ReplicatedStorage")
    local _spoofOk = false
    local function _applySpoof()
        if _G.xyr0NetSpoofEnable ~= true then return false end
        local ok = pcall(function()
            local Net = require(RS:WaitForChild("Packages"):WaitForChild("Net"))
            local og = getfenv
            if type(og) ~= "function" then return end
            for _, fname in ipairs({ "RemoteEvent", "RemoteFunction", "UnreliableRemoteEvent" }) do
                local f = rawget(Net, fname)
                if type(f) == "function" then
                    local env = og(f)
                    if type(env) == "table" then
                        env.getfenv = function() return og(f) end
                        if type(env.debug) == "table" then
                            if setreadonly then pcall(setreadonly, env.debug, false) end
                            env.debug.getmemorycategory = function() return "--" end
                        end
                    end
                end
            end
            _spoofOk = true
        end)
        return ok and _spoofOk
    end
    _G.xyr0NetSpoof = _applySpoof
    _G.xyr0NetSpoofReady = function() return _spoofOk end
    if _G.xyr0NetSpoofEnable == true then
        _applySpoof()
        task.spawn(function()
            for _ = 1, 80 do
                if _applySpoof() then end
                task.wait(0.1)
            end
        end)
    end
end

pcall(function() if setfpscap then setfpscap(9999) end end)


task.spawn(function()
    local Workspace = game:GetService("Workspace")
    local LocalPlayer = game:GetService("Players").LocalPlayer
    if not Workspace.StreamingEnabled then return end
    local plots
    local t0 = os.clock()
    repeat plots = Workspace:FindFirstChild("Plots"); if not plots then task.wait(0.1) end
    until plots or (os.clock() - t0) > 25
    if not plots then return end
    local function plotPos(plot)
        local ok, pv = pcall(function() return plot:GetPivot().Position end)
        if ok and pv and pv.Magnitude > 1 then return pv end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local bp = plot:FindFirstChildWhichIsA("BasePart", true)
        return bp and bp.Position or nil
    end
    local pending = 0
    for _, plot in ipairs(plots:GetChildren()) do
        local pos = plotPos(plot)
        if pos then
            pending = pending + 1
            task.spawn(function()
                pcall(function() LocalPlayer:RequestStreamAroundAsync(pos) end)
                pending = pending - 1
            end)
        end
    end
    local sw = os.clock()
    while pending > 0 and os.clock() - sw < 10 do task.wait(0.05) end
end)

_G.xyr0BootDelay = tonumber(_G.xyr0BootDelay) or 6
if _G.xyr0WaitForTools == nil then _G.xyr0WaitForTools = true end
_G.xyr0ToolWait = tonumber(_G.xyr0ToolWait) or 35
do
    local _bootT0 = os.clock()
    local _BOOT_TOOLS = {
        "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings",
        "Grapple Hook", "Grappling Hook", "Grapple", "Hook", "Web Slinger", "Grapple Gun", "GrappleHook",
    }
    local function _hasTool(n)
        local plr = game:GetService("Players").LocalPlayer
        if not plr then return false end
        local char = plr.Character
        local bp = plr:FindFirstChild("Backpack")
        local t = (char and char:FindFirstChild(n)) or (bp and bp:FindFirstChild(n))
        return t ~= nil and t:IsA("Tool")
    end
    local function _toolsReady()
        if type(_G.xyr0CarpetTool) == "string" and _G.xyr0CarpetTool ~= "" and _hasTool(_G.xyr0CarpetTool) then return true end
        for _, n in ipairs(_BOOT_TOOLS) do
            if _hasTool(n) then return true end
        end
        return false
    end
    _G.xyr0ToolsReady = _toolsReady
    _G.xyr0BootWait = function()
        local d = tonumber(_G.xyr0BootDelay) or 8
        while os.clock() - _bootT0 < d do task.wait(0.25) end
        if _G.xyr0WaitForTools == false then return end
        local cap = tonumber(_G.xyr0ToolWait) or 30
        local t0 = os.clock()
        while os.clock() - t0 < cap do
            local ok, ready = pcall(_toolsReady)
            if ok and ready then
                task.wait(0.35)
                return
            end
            task.wait(0.2)
        end
        warn("[xyr0TP] tools never loaded within " .. cap .. "s, continuing anyway")
    end
end

_G.xyr0PriVersion = _G.xyr0PriVersion or 0
if type(_G.xyr0PriorityDefault) ~= "table" then _G.xyr0PriorityDefault = {} end
if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" then _G.SHARED_PRIORITY_ITEMS = {} end

if LPH_OBFUSCATED == nil then
    local env = getfenv()
    env["LPH_NO_" .. "VIRTUALIZE"] = function(...) return ... end
    env["LPH_JIT_" .. "MAX"]       = function(...) return ... end
end

do
    local _HS = game:GetService("HttpService")
    local _TS = game:GetService("TeleportService")
    local fileData, tpData
    if readfile then
        pcall(function()
            local raw = readfile("SideTP.json")
            if type(raw) == "string" and #raw > 0 then fileData = _HS:JSONDecode(raw) end
        end)
    end
    pcall(function()
        local td = _TS:GetLocalPlayerTeleportData()
        if td and td.SideTP then tpData = td.SideTP end
    end)
    local merged = {}
    if type(tpData) == "table" then for k, v in pairs(tpData) do merged[k] = v end end
    if type(fileData) == "table" then for k, v in pairs(fileData) do merged[k] = v end end

    if type(merged.tpDelay) == "number" then _G._stp_tpDelay = merged.tpDelay end
    if type(merged.tpVelocity) == "number" then _G.TPVelocity = math.clamp(merged.tpVelocity, 200, 750) end
    if type(merged.climbSpeed) == "number" then _G.xyr0Climb = math.clamp(merged.climbSpeed, 100, 250) end
    if type(merged.cframeSpeed) == "number" then _G.xyr0CFrameSpeed = math.clamp(merged.cframeSpeed, 100, 900) end
    if type(merged.walkSpeed) == "number" then _G.xyr0WalkSpeed = math.clamp(merged.walkSpeed, 16, 29) end
    if type(merged.carpetTool) == "string" then _G.xyr0CarpetTool = merged.carpetTool end
    if type(merged.landingDelay) == "number" then _G.LandingDelay = math.clamp(merged.landingDelay, 0.05, 0.75) end
    if type(merged.closeSpeed) == "number" then _G.xyr0CloseSpeed = math.clamp(merged.closeSpeed, 20, 400) end
    if type(merged.tpSafeMode) == "boolean" then _G.xyr0TPSafeMode = merged.tpSafeMode end
    if type(merged.tpSafeSpeed) == "number" then _G.xyr0TPSafeSpeed = math.clamp(merged.tpSafeSpeed, 180, 400) end
    if type(merged.tpSafeVerticalSpeed) == "number" then _G.xyr0TPSafeVerticalSpeed = math.clamp(merged.tpSafeVerticalSpeed, 60, 160) end
    if type(merged.tpRetryCount) == "number" then _G.xyr0TPRetryCount = math.clamp(merged.tpRetryCount, 0, 4) end
    if type(merged.tpKey) == "string" then _G._stp_tpKeyName = merged.tpKey end
    if type(merged.nearestKey) == "string" then _G.xyr0NearestKey = merged.nearestKey end
    if type(merged.prioritySoundID) == "string" then _G.xyr0PrioritySoundID = merged.prioritySoundID end
    _G.xyr0StealMode = "priority"
    _G._stealUserOff = false
    if type(merged.priorityList) == "table" then
        local clean = {}
        for _, v in ipairs(merged.priorityList) do
            if type(v) == "string" and v ~= "" then clean[#clean + 1] = v end
        end
        if #clean > 0 then
            local L = _G.SHARED_PRIORITY_ITEMS
            table.clear(L)
            for i = 1, #clean do L[i] = clean[i] end
            _G.xyr0PriVersion = _G.xyr0PriVersion + 1
        end
    end
    if type(merged.priorityDefault) == "table" then
        local d = {}
        for _, v in ipairs(merged.priorityDefault) do
            if type(v) == "string" and v ~= "" then d[#d + 1] = v end
        end
        if #d > 0 then _G.xyr0PriorityDefault = d end
    end
    if type(merged.invisAuto) == "boolean" then _G.xyr0InvisAuto = merged.invisAuto end
    if type(merged.invisDepth) == "number" then _G.xyr0InvisDepth = math.clamp(merged.invisDepth, 0, 10) end
    if type(merged.invisAngle) == "number" then _G.xyr0InvisAngle = math.clamp(merged.invisAngle, 0, 360) end
    if type(merged.autoTp) == "boolean" then _G.xyr0AutoTP = merged.autoTp end
    if type(merged.autoBuy) == "boolean" then _G.xyr0AutoBuy = merged.autoBuy end
    if type(merged.autoBuyRange) == "number" then _G.xyr0AutoBuyRange = math.clamp(merged.autoBuyRange, 5, 40) end
    if type(merged.autoBuyHover) == "number" then _G.xyr0AutoBuyHover = math.clamp(merged.autoBuyHover, 0, 20) end
    if type(merged.panelX) == "number" then _G._stp_panelX = merged.panelX end
    if type(merged.panelY) == "number" then _G._stp_panelY = merged.panelY end
    if type(merged.panelPos) == "table" then _G._stp_pos = merged.panelPos end
    if type(merged.tgtX) == "number" then _G._xyr0_tgtX = merged.tgtX end
    if type(merged.tgtY) == "number" then _G._xyr0_tgtY = merged.tgtY end
    if type(merged.tgtW) == "number" then _G._xyr0_tgtW = merged.tgtW end
    if type(merged.tgtH) == "number" then _G._xyr0_tgtH = merged.tgtH end
    if type(merged.autoKickOnSteal) == "boolean" then _G.xyr0AutoKickOnSteal     = merged.autoKickOnSteal end
    if type(merged.resetKey)        == "string"  then _G.xyr0ResetKeyName        = merged.resetKey end
    if type(merged.cloneKey)        == "string"  then _G.xyr0CloneKeyName        = merged.cloneKey end
    if type(merged.carpetSpeedKey)  == "string"  then _G.xyr0CarpetSpeedKeyName  = merged.carpetSpeedKey end
    if type(merged.kickKey)         == "string"  then _G.xyr0KickKeyName         = merged.kickKey end
    if type(merged.stopTpKey)       == "string"  then _G.xyr0StopTPKeyName       = merged.stopTpKey end
    if type(merged.dropKey)         == "string"  then _G.xyr0DropKeyName         = merged.dropKey end
    if type(merged.goSpeed)      == "number"  then _G.xyr0GoSpeed            = math.clamp(merged.goSpeed, 80, 600) end
    if type(merged.kickToPS)     == "boolean" then _G.xyr0KickToPS           = merged.kickToPS end
    if type(merged.psLink)       == "string"  then _G.xyr0PrivateServerLink  = merged.psLink end
    if type(merged.priAlert)     == "boolean" then _G.xyr0PriAlert           = merged.priAlert end
    if type(merged.alertSound)   == "string"  then _G.xyr0AlertSound         = merged.alertSound end
    if type(merged.alertMinGen)  == "number"  then _G.xyr0AlertMinGen        = merged.alertMinGen end
    if type(merged.walkSpeedOn)  == "boolean" then _G.xyr0WalkSpeedOn        = merged.walkSpeedOn end
    if type(merged.xray)         == "boolean" then _G.xyr0Xray               = merged.xray end
    if type(merged.antiFlash)    == "boolean" then _G.xyr0AntiFlash          = merged.antiFlash end
    if type(merged.faceAway)        == "boolean" then _G.xyr0FaceAway        = merged.faceAway end
    if type(merged.faceAwayNearest) == "boolean" then _G.xyr0FaceAwayNearest = merged.faceAwayNearest end
    if type(merged.faceAwayDelay)   == "number"  then _G.xyr0FaceAwayDelay   = merged.faceAwayDelay end
    if type(merged.antiBee)      == "boolean" then _G.xyr0AntiBee            = merged.antiBee end
    if type(merged.infJump)      == "boolean" then _G.xyr0InfJump            = merged.infJump end
    if type(merged.antiDie)      == "boolean" then _G.AntiDieDisabled          = not merged.antiDie end
    if type(merged.carpetSpeedValue) == "number" then _G.xyr0CarpetSpeedValue = merged.carpetSpeedValue end
    if type(merged.exX) == "number" then _G._xyr0_exX = merged.exX end
    if type(merged.exY) == "number" then _G._xyr0_exY = merged.exY end
    if type(merged.fX)  == "number" then _G._xyr0_fX  = merged.fX  end
    if type(merged.fY)  == "number" then _G._xyr0_fY  = merged.fY  end
    if type(merged.kX)  == "number" then _G._xyr0_kX  = merged.kX  end
    if type(merged.kY)  == "number" then _G._xyr0_kY  = merged.kY  end

    _G.xyr0AutoTP = true
    if writefile then
        pcall(function()
            local t = type(fileData) == "table" and fileData or {}
            t.autoTp = true
            writefile("SideTP.json", _HS:JSONEncode(t))
        end)
    end
end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local RS         = game:GetService("ReplicatedStorage")

local LP = Players.LocalPlayer

if _G.xyr0NoZeroVel == nil then _G.xyr0NoZeroVel = false end
function _vzOK()
    if _G.xyr0NoZeroVel == true then return false end
    if _G.xyr0ZeroWhileStealing ~= true and LP:GetAttribute("Stealing") == true then return false end
    return true
end
function _vzL(p)
    if p and _vzOK() then
        p.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end
function _vzA(p)
    if p and _vzOK() then
        p.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end

_BLOCKING_MACHINE_TYPES = {
    Fuse     = true,
    Duel     = true,
    Trade    = true,
    Crafting = true,
}
function _xyr0IsFusing(animalData)
    if type(animalData) ~= "table" then return false end
    local m = animalData.Machine
    if type(m) ~= "table" then return false end
    return _BLOCKING_MACHINE_TYPES[m.Type] == true
end

do
local RS = game:GetService("ReplicatedStorage")
local _netFolder = RS:WaitForChild("Packages"):WaitForChild("Net")
local _net, _spoofed
-- Requiring the Net module is now opt-in. Without it _get() returns nil and
-- callers fall back to structural resolution / the UI path, same as Elite.
local function _getNet()
    if _G.xyr0NetSpoofEnable ~= true then return nil end
    if _net then return _net end
    local ok, m = pcall(require, _netFolder)
    if ok and type(m) == "table" then _net = m end
    return _net
end
local function _spoofFn(Net, fname)
    local f = rawget(Net, fname)
    if type(f) ~= "function" then return end
    local og = getfenv
    if type(og) ~= "function" then return end
    local env = og(f)
    if type(env) ~= "table" then return end
    env.getfenv = function() return og(f) end
    if type(env.debug) == "table" then
        if setreadonly then pcall(setreadonly, env.debug, false) end
        env.debug.getmemorycategory = function() return "--" end
    end
end
local function _spoof()
    if _G.xyr0NetSpoofEnable ~= true then return false end
    if _G.xyr0NetSpoof then return _G.xyr0NetSpoof() end
    if _spoofed then return true end
    local Net = _getNet()
    if not Net then return false end
    pcall(function()
        _spoofFn(Net, "RemoteEvent")
        _spoofFn(Net, "RemoteFunction")
        _spoofFn(Net, "UnreliableRemoteEvent")
    end)
    _spoofed = true
    return true
end
local _cache = {}
local function _get(name, kind)
    kind = (kind == "RemoteFunction" and "RemoteFunction")
        or (kind == "UnreliableRemoteEvent" and "UnreliableRemoteEvent")
        or "RemoteEvent"
    if type(name) ~= "string" or name == "" then return nil end
    local logical = name:match("^R[EF]/(.+)$") or name:match("^URE/(.+)$") or name
    local ck = kind .. "|" .. logical
    local hit = _cache[ck]
    if hit and hit.Parent then return hit end
    _cache[ck] = nil
    local Net = _getNet()
    if not Net then return nil end
    _spoof()
    local ok, inst = pcall(function()
        if kind == "RemoteFunction" then return Net:RemoteFunction(logical) end
        if kind == "UnreliableRemoteEvent" then return Net:UnreliableRemoteEvent(logical) end
        return Net:RemoteEvent(logical)
    end)
    if ok and typeof(inst) == "Instance" then
        _cache[ck] = inst
        return inst
    end
    return nil
end
_G.xyr0Net = {
    RemoteEvent = function(_, name) return _get(name, "RemoteEvent") end,
    RemoteFunction = function(_, name) return _get(name, "RemoteFunction") end,
    UnreliableRemoteEvent = function(_, name) return _get(name, "UnreliableRemoteEvent") end,
}
_G.xyr0GetRemote = _get
_G.Resolve = _get
_G.__secureGetRemote = function(method, name) return _get(name, method) end
do
    local _dummy = Instance.new("RemoteEvent")
    local _rawFire = (clonefunction and clonefunction(_dummy.FireServer)) or _dummy.FireServer
    _G.RawFire = function(name, ...)
        local r = _get(name)
        if not r then return false end
        _rawFire(r, ...)
        return true
    end
end
end

do
local _xchan
local _lastTry, _attempts = 0, 0
local _deepScans, _lastDeep = 0, 0
local _mod

local MAX_ATTEMPTS, RETRY_GAP = 40, 0.5
local BOOT_T0, BOOT_BURST, BOOT_GAP = os.clock(), 3.0, 0.10
local MAX_DEEP, DEEP_GAP = 3, 1.5

local RS_SYNC = game:GetService("ReplicatedStorage")
local _mask_sc
local function _getMask()
    if _mask_sc and _mask_sc.Parent then return _mask_sc end
    local c = RS_SYNC:FindFirstChild("Controllers")
    _mask_sc = c and c:FindFirstChild("PlotController")
    return _mask_sc
end
local secure_call = _G.secure_call
if type(secure_call) ~= "function" then
    local LAYERS = 2
    local TEMPLATE do
        local lines = {
            "return function(__renv, __func, ...)",
            "\tsetfenv(0, __renv)",
            ("\tlocal function l%d(...) return __func(...) end"):format(LAYERS),
        }
        for c = LAYERS - 1, 1, -1 do
            lines[#lines + 1] = ("\tlocal function l%d(...) return l%d(...) end"):format(c, c + 1)
        end
        lines[#lines + 1] = "\treturn l1(...)"
        lines[#lines + 1] = "end"
        TEMPLATE = table.concat(lines, string.char(10))
    end
    local _gti = getthreadidentity or get_thread_identity or getidentity
    local _sti = setthreadidentity or set_thread_identity or setidentity
    local _sentinel
    secure_call = function(func, mask, ...)
        if type(func) ~= "function" or typeof(mask) ~= "Instance" then return nil end
        if not (_gti and _sti and getrenv and loadstring and setfenv) then return nil end
        local renv = getrenv()
        if not _sentinel then
            local ok, env = pcall(getsenv, mask)
            if not ok or type(env) ~= "table" then
                env = setmetatable({ script = mask, _G = {}, shared = {} }, { __index = renv, __newindex = renv })
            end
            local loader = loadstring(TEMPLATE, "=" .. mask:GetFullName())
            if not loader then return nil end
            setfenv(loader, env)
            _sentinel = loader()
        end
        local level = _gti()
        local changed = {}
        local okU, snap = pcall(debug.getupvalues, func)
        if okU and type(snap) == "table" then
            for i, v in pairs(snap) do
                if typeof(v) == "Instance" and v:IsA("LuaSourceContainer") then
                    if pcall(debug.setupvalue, func, i, mask) then changed[i] = v end
                end
            end
        end
        _sti(2)
        local co, args = coroutine.create(_sentinel), table.pack(renv, func, ...)
        local response, err
        while true do
            local r = table.pack(coroutine.resume(co, table.unpack(args, 1, args.n)))
            if not r[1] then err = r[2] break end
            if coroutine.status(co) == "dead" then response = table.pack(table.unpack(r, 2, r.n)) break end
            args = table.pack(coroutine.yield(table.unpack(r, 2, r.n)))
        end
        _sti(level)
        for i, orig in pairs(changed) do pcall(debug.setupvalue, func, i, orig) end
        if err or not response then return nil end
        return table.unpack(response, 1, response.n)
    end
    _G.secure_call = secure_call
end
local _syncMod_sc, _nextTry_sc = nil, 0
local function _getSyncMod()
    if _syncMod_sc then return _syncMod_sc end
    local p = RS_SYNC:FindFirstChild("Packages")
    local m = p and p:FindFirstChild("Synchronizer")
    if not m then return nil end
    local ok, mod = pcall(require, m)
    if ok and type(mod) == "table" then _syncMod_sc = mod end
    return _syncMod_sc
end
_G.__secureChans = function()
    if os.clock() < _nextTry_sc then return _xchan end
    local sync = _getSyncMod()
    if not sync then _nextTry_sc = os.clock() + 0.1; return _xchan end
    if type(sync.GetAllChannels) ~= "function" then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local mask = _getMask()
    if not mask then _nextTry_sc = os.clock() + 0.1; return _xchan end
    local ok, reg = pcall(secure_call, sync.GetAllChannels, mask)
    if ok and type(reg) == "table" then
        _xchan = reg; _nextTry_sc = os.clock() + 1.5
        _G.xyr0SyncDiag = "GetAllChannels (secure_call) - undetect/instant"
    else
        _nextTry_sc = os.clock() + 0.1
    end
    return _xchan
end

local function _retryGap()
    if (os.clock() - BOOT_T0) < BOOT_BURST then return BOOT_GAP end
    return RETRY_GAP
end

local function _channelCount(t)
    if type(t) ~= "table" then return 0 end
    local ok, hits = pcall(function()
        local h, n = 0, 0
        for _, v in next, t do
            n = n + 1
            if type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                h = h + 1
            end
            
            if n >= 50 then break end
        end
        return h
    end)
    return (ok and hits) or 0
end

local function _module()
    if _mod then return _mod end
    local ok, m = pcall(function()
        return require(game:GetService("ReplicatedStorage").Packages.Synchronizer)
    end)
    if ok and type(m) == "table" then _mod = m; return _mod end
    local ok2, m2 = pcall(function()
        local pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        local sync = pkgs and pkgs:FindFirstChild("Synchronizer")
        if not sync then return nil end
        return require(sync)
    end)
    if ok2 and type(m2) == "table" then _mod = m2 end
    return _mod
end

local function _probe(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    local cands = {
        { mod.Get, 10, 4, "Get/10/4" },
        { mod.GetAllChannels, 10, 1, "GetAll/10/1" },
        { mod.Wait, 10, 1, "Wait/10/1" },
    }
    for _, c in ipairs(cands) do
        if type(c[1]) == "function" then
            local o, u = pcall(gu, c[1], c[2])
            if o and type(u) == "table" then
                consider(rawget(u, c[3]), c[4])
                if bestN > 0 then return best, bestN, where end
            end
        end
    end
    for _, fn in ipairs({ mod.Get, mod.GetAllChannels, mod.Wait, mod.WaitAndCall, mod.GetTableFromChannel }) do
        if type(fn) == "function" then
            for i = 8, 12 do
                local o, u = pcall(gu, fn, i)
                if o and type(u) == "table" then
                    consider(u, "up" .. i)
                    for j = 1, 4 do consider(rawget(u, j), "up" .. i .. "/" .. j) end
                    if bestN > 0 then return best, bestN, where end
                end
            end
        end
    end
    local ok, up = pcall(gu, mod.Get, 9)
    if ok and type(up) == "table" then
        consider(rawget(up, 3), "Get/9/3")
        if bestN > 0 then return best, bestN, where end
        consider(up, "Get/9")
        if bestN > 0 then return best, bestN, where end
    end
    return best, bestN, where
end

local function _deepScan(mod)
    local gu = (debug and debug.getupvalue) or getupvalue
    if type(gu) ~= "function" then return nil, 0, nil end
    local best, bestN, where = nil, 0, nil
    local function consider(t, tag)
        local n = _channelCount(t)
        if n > bestN then best, bestN, where = t, n, tag end
    end
    for fname, fn in next, mod do
        if type(fn) == "function" then
            for i = 1, 24 do
                local o, u = pcall(gu, fn, i)
                if not o then break end
                if type(u) == "table" then
                    consider(u, tostring(fname) .. "/" .. i)
                    for j = 1, 4 do
                        consider(rawget(u, j), tostring(fname) .. "/" .. i .. "/" .. j)
                    end
                end
            end
        end
    end
    return best, bestN, where
end

local _gcFound, _gcFoundN, _gcState = nil, 0, "idle"

local function _gcScanOnce()
    if type(getgc) ~= "function" then return end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    local live, nLive = {}, 0
    for _, p in ipairs(plots:GetChildren()) do live[p.Name] = true; nLive = nLive + 1 end
    if nLive == 0 then return end

    local best, bestN = nil, 0
    pcall(function()
        local gc = getgc(true)
        for i = 1, #gc do
            local t = gc[i]
            if type(t) == "table" then
                pcall(function()
                    
                    local pk = 0
                    for k in next, t do
                        if type(k) == "string" and live[k] then pk = pk + 1; if pk >= 2 then break end end
                    end
                    if pk < 2 then return end
                    local hits, seen = 0, 0
                    for k, v in next, t do
                        seen = seen + 1
                        if type(k) == "string" and live[k]
                            and type(v) == "table" and type(rawget(v, "CacheTable")) == "table" then
                            hits = hits + 1
                        end
                        if seen >= 64 then break end
                    end
                    if hits > bestN and hits >= 2 then best, bestN = t, hits end
                end)
                if bestN >= nLive then break end
            end
        end
    end)
    if best and bestN > _gcFoundN then _gcFound, _gcFoundN = best, bestN end
end

local _gcLastScan = 0
local _gcRescans = 0
local function _gcChans()
    if _gcFound then
        local _pl = workspace:FindFirstChild("Plots")
        local _nLive = _pl and #_pl:GetChildren() or 0
        if _G.xyr0SyncRescan == true and _gcFoundN < _nLive
            and _gcRescans < (tonumber(_G.xyr0SyncMaxRescan) or 20)
            and (os.clock() - _gcLastScan) >= (tonumber(_G.xyr0SyncRescanGap) or 3) then
            _gcLastScan = os.clock()
            _gcRescans = _gcRescans + 1
            _gcScanOnce()
        end
        return _gcFound, _gcFoundN, "getgc/plot-key+CacheTable"
    end
    if os.clock() - _gcLastScan < (tonumber(_G.xyr0SyncScanGap) or 0.2) then return nil, 0, nil end
    _gcLastScan = os.clock()
    _gcScanOnce()
    if _gcFound then return _gcFound, _gcFoundN, "getgc/plot-key+CacheTable" end
    return nil, 0, nil
end

local function _apiChans(mod)
    if type(mod) ~= "table" then return nil, 0, nil end
    local fn = rawget(mod, "GetAllChannels")
    if type(fn) ~= "function" then return nil, 0, nil end
    local function _accept(reg, tag)
        if type(reg) ~= "table" then return nil, 0, nil end
        local n = _channelCount(reg)
        if n > 0 then return reg, n, tag end
        return nil, 0, nil
    end
    local mask = _getMask()
    if _G.xyr0AllowSecureSyncCall and mask and type(secure_call) == "function" then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return secure_call(fn, mask, mod) end
                return secure_call(fn, mask)
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/secure_call(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    if _G.xyr0AllowRawSyncCall then
        for _, form in ipairs({ "self", "plain" }) do
            local ok, reg = pcall(function()
                if form == "self" then return fn(mod) end
                return fn()
            end)
            if ok then
                local r, n, t = _accept(reg, "GetAllChannels/RAW(" .. form .. ")")
                if r then return r, n, t end
            end
        end
    end
    return nil, 0, nil
end

local _xchan2, _nextTry2, _attempts2 = nil, 0, 0
local _xchan2Until = 0
local function _chans()
    if _xchan2 then
        local now = os.clock()
        if now < _xchan2Until then return _xchan2 end
        if _channelCount(_xchan2) > 0 then _xchan2Until = now + 2 return _xchan2 end
    end
    if os.clock() < _nextTry2 then return _xchan2 end
    _attempts2 = _attempts2 + 1

    local best, n, where = _gcChans()

    if (not best or n == 0) and _attempts2 <= 400
        and (_G.xyr0AllowUpvalueProbe or _G.xyr0AllowSecureSyncCall or _G.xyr0AllowRawSyncCall) then
        local mod = _getSyncMod()
        if mod then
            if _G.xyr0AllowUpvalueProbe then
                best, n, where = _probe(mod)
                if (not best or n == 0) and os.clock() - _lastDeep > 1 then
                    _lastDeep = os.clock()
                    _deepScans = _deepScans + 1
                    best, n, where = _deepScan(mod)
                end
            end
            if not best or n == 0 then best, n, where = _apiChans(mod) end
        end
    end
    if best and n > 0 then
        _xchan2 = best
        _G.xyr0SyncDiag = string.format("rawget/CacheTable scoring via %s - %d channels", tostring(where), n)
        return _xchan2
    end
    _nextTry2 = os.clock() + 0.1
    return _xchan2
end
_G.__secureChans = _chans

_G.xyr0SyncAll=function()return _chans()end
_G.xyr0SyncGet=function(idx)
local t=_chans()
if not t or idx==nil then return nil end
local ok,cd=pcall(rawget,t,idx)
if ok and type(cd)=="table" then return cd end
local ok2,cd2=pcall(function() return t[idx] end)
if ok2 and type(cd2)=="table" then return cd2 end
return nil
end
_G.sProp=function(ch,key)
if type(ch)~="table" or key==nil then return nil end
local ct=rawget(ch,"CacheTable")
if type(ct)~="table" then
local okC,c2=pcall(function() return ch.CacheTable end)
if okC and type(c2)=="table" then ct=c2 end
end
if type(ct)~="table" then return nil end
local v=rawget(ct,key)
if v~=nil then return v end
local okV,v2=pcall(function() return ct[key] end)
if okV then return v2 end
return nil
end
_G._xyr0RawCT=function(plotName)
local c=_G.xyr0SyncGet(plotName)
if not c then return nil end
return rawget(c,"CacheTable")
end
local _AD,_MD,_TD
local function _data()
if _AD then return true end
local ok=pcall(function()
local d=game:GetService("ReplicatedStorage"):WaitForChild("Datas")
_AD=require(d:WaitForChild("Animals"))
_MD=require(d:WaitForChild("Mutations"))
_TD=require(d:WaitForChild("Traits"))
end)
return ok and _AD~=nil
end
_G._xyr0Gen=function(index,mutation,traits)
if not _data() then return 0 end
local info=_AD[index]
if not info or not info.Generation then return 0 end
local mult=1
if mutation and mutation~="None" and mutation~="" then
local m=_MD[mutation]
if m and m.Modifier then mult=mult+m.Modifier end
end
if type(traits)=="table" then
for _,tr in ipairs(traits)do
local t=_TD[tr]
if t and t.MultiplierModifier then mult=mult+t.MultiplierModifier end
end
end
return info.Generation*mult
end
_G._xyr0AnimShim=setmetatable({GetGeneration=function(_,index,mutation,traits)return _G._xyr0Gen(index,mutation,traits)end},{
__index=function(_,k)
local ok,real=pcall(function()return require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Animals"))end)
if ok and type(real)=="table" then return rawget(real,k) end
return nil
end})
_G.xyr0_GetPlotChannel=function(plotName)return _G.xyr0SyncGet(plotName)end
_G.xyr0_GetAllPlots=function()return _G.xyr0SyncAll() or {} end
_G.xyr0_GetPlotAnimalList=function(plotName)
local ct=_G._xyr0RawCT(plotName)
local al=ct and ct.AnimalList
return type(al)=="table" and al or nil
end
end

_G.xyr0SyncAll  = _G.xyr0SyncAll
_G.xyr0SyncGet  = _G.xyr0SyncGet
_G.xyr0RawCT    = _G._xyr0RawCT
_G.xyr0Gen      = _G._xyr0Gen
_G.xyr0AnimShim = _G._xyr0AnimShim
_G.stealthGet    = function(n) return _G.xyr0SyncGet(n) end
_G.SyncInt       = {_cache={},_data=nil}

task.spawn(function() for _=1,150 do if _G.xyr0SyncAll() then break end task.wait(0.04) end end)

_G.xyr0GetSyncData = _G.xyr0GetSyncData or function(plot)
    local plotName = type(plot) == "string" and plot or (plot and plot.Name)
    if not plotName then return nil end
    local Pkgs = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
    local Sync = Pkgs and Pkgs:FindFirstChild("Synchronizer")
    if not Sync then return nil end
    local okMod, mod = pcall(require, Sync)
    if not okMod or type(mod) ~= "table" then return nil end

    local okT, data = pcall(function() return _G.xyr0RawCT(plotName) end)
    if okT and type(data) == "table" then return data end

    local okC, ch = pcall(function() return _G.xyr0SyncGet(plotName) end)
    if okC and ch then
        local synth = { __channel = ch }
        pcall(function() local ct = rawget(ch, "CacheTable"); if type(ct)=="table" then synth.AnimalList = ct.AnimalList; synth.Owner = ct.Owner end end)
        return synth
    end
    return nil
end


_mkNextModTry = 0
function loadModules()
    if AnimalsData then return true end
    if os.clock() < _mkNextModTry then return false end
    _mkNextModTry = os.clock() + (tonumber(_G.xyr0ModRetry) or 3)
    pcall(function()
        local Datas = RS:FindFirstChild("Datas") or RS:WaitForChild("Datas", 5)
        if Datas then
            local a = Datas:FindFirstChild("Animals") or Datas:WaitForChild("Animals", 5)
            if a then AnimalsData = require(a) end
        end
    end)
    AnimalsShared = _G.xyr0AnimShim
    if not NumberUtils then
        pcall(function()
            local Utils = RS:FindFirstChild("Utils")
            local n = Utils and Utils:FindFirstChild("NumberUtils")
            if n then NumberUtils = require(n) end
        end)
    end
    return AnimalsData ~= nil
end

function loadNet() return false end

function getRemote(method, name)
    return _G.__secureGetRemote(method, name)
end
_G.xyr0GetRemote = getRemote

GRAPPLE_ARG = 0.8

--[[ Grapple: Elite method ----------------------------------------------------
     Old xyr0 method: require ReplicatedStorage.Packages.Net, spoof getfenv +
     debug.getmemorycategory inside it, ask it for "UseItem", then blind-fire
     both candidate remotes with a bare constant (0.8) and no target.

     Elite method (implemented below):
       * resolve UseItem by INSTANCE STRUCTURE, never requiring the Net module
         (no getfenv / setreadonly / debug tampering = no detection surface)
       * gate on the tool's own cooldown (Tool.Enabled) before firing
       * fire (amount, position) with a real raycast target, amount scaled to
         distance, instead of a constant with no target
       * quiet mode: mute the hook's Sounds/Beams, drop the server-side
         FlightPower, and hold velocity down so the pull does not fight the TP
       * invalidate + re-resolve automatically if FireServer errors

     Set _G.xyr0GrappleLegacy = true to restore the old blind-fire path.
--------------------------------------------------------------------------- ]]

do
local _WSg = game:GetService("Workspace")

-- Grapple remote resolver: uses rymogs' Net-hook approach (hookfunction on the
-- game's own Heartbeat listener) to resolve remotes through the Net module
-- without any getfenv/setreadonly detection surface.
local getGrappleRemote
do
    local netFolder, netModule, queue, hooked, original = nil, nil, {}, false, nil
    local function netDirectory()
        if netFolder then return netFolder end
        local packages = RS:FindFirstChild("Packages") or RS:WaitForChild("Packages", 10)
        if not packages then return nil end
        netFolder = packages:FindFirstChild("Net") or packages:WaitForChild("Net", 10)
        return netFolder
    end
    local function getNet()
        if netModule then return netModule end
        local directory = netDirectory()
        if not directory then return nil end
        local ok, module = pcall(require, directory)
        if ok and type(module) == "table" then netModule = module end
        return netModule
    end
    local function host()
        for _, signal in ipairs({ RunService.Heartbeat, RunService.RenderStepped, RunService.PostSimulation }) do
            local ok, connections = pcall(getconnections, signal)
            if ok then
                for _, connection in ipairs(connections) do
                    local fn = connection.Function
                    if fn and islclosure(fn) and not isexecutorclosure(fn) then
                        local source = select(2, pcall(debug.info, fn, "s"))
                        if type(source) == "string" and source:find("^ReplicatedStorage%.")
                            and not source:find("ReplicatedFirst") then
                            return fn
                        end
                    end
                end
            end
        end
    end
    local function install()
        if hooked then return true end
        if not getNet() then return false end
        local fn = host()
        if not fn then return false end
        local wrapper = function(...)
            local job = table.remove(queue, 1)
            if job then
                local ok, remote = pcall(netModule[job.kind], netModule, job.name)
                job.result = (ok and typeof(remote) == "Instance") and remote or nil
                job.done = true
            end
            return original(...)
        end
        local ok, env = pcall(getfenv, fn)
        if ok and type(env) == "table" then pcall(setfenv, wrapper, env) end
        original = hookfunction(fn, wrapper)
        hooked = true
        return true
    end
    local cache = {}
    getGrappleRemote = function(method, name)
        local kind = method == "RemoteFunction" and "RemoteFunction"
            or method == "UnreliableRemoteEvent" and "UnreliableRemoteEvent" or "RemoteEvent"
        if type(name) ~= "string" or name == "" then return nil end
        local cacheKey = kind .. "|" .. name
        local cached = cache[cacheKey]
        if cached and cached.Parent then return cached end
        cache[cacheKey] = nil
        if not getNet() or not install() then return nil end
        local job = { kind = kind, name = name }
        table.insert(queue, job)
        local expires = os.clock() + 5
        while not job.done and os.clock() < expires do RunService.Heartbeat:Wait() end
        if job.result and job.result.Parent then cache[cacheKey] = job.result; return job.result end
        return nil
    end
end

function _grappleInvalidate()
    _G.__xyr0UseItem, _G.__xyr0UseItemJob = nil, nil
end
_G.xyr0GrappleInvalidate = _grappleInvalidate

task.spawn(function() _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem") end)
task.spawn(function() _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42") end)
function _grappleRemoteGet()
    if not (_grappleUseItem and _grappleUseItem.Parent) then
        _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem")
    end
    if not (_grappleItemUse and _grappleItemUse.Parent) then
        _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
    end
    return (_grappleUseItem and _grappleUseItem.Parent and _grappleUseItem)
        or (_grappleItemUse and _grappleItemUse.Parent and _grappleItemUse)
end
_G.xyr0GrappleRemote = _grappleRemoteGet

local _gMuteCache = setmetatable({}, { __mode = "k" })
local function _gCollectMutes(tool)
    local e = _gMuteCache[tool]
    if e and (os.clock() - e.t) < 8 and tool.Parent then return e end
    local snd, bm = {}, {}
    pcall(function()
        local scanned = 0
        for _, s in ipairs(tool:GetDescendants()) do
            scanned = scanned + 1
            if scanned > 500 then break end
            if s:IsA("Sound") then snd[#snd + 1] = s
            elseif s:IsA("Beam") then bm[#bm + 1] = s end
        end
    end)
    e = { t = os.clock(), snd = snd, bm = bm }
    _gMuteCache[tool] = e
    return e
end

local function _gMuteAndStopPull(tool, hrp)
    if tool and tool.Parent then
        local e = _gCollectMutes(tool)
        for _, s in ipairs(e.snd) do
            if s.Parent then pcall(function() s.Volume = 0; s:Stop() end) end
        end
        for _, b in ipairs(e.bm) do
            if b.Parent then pcall(function() b.Enabled = false; b.Attachment0 = nil end) end
        end
    end
    if hrp and hrp.Parent then
        local fp = hrp:FindFirstChild("FlightPower")
        if fp then pcall(function() fp:Destroy() end) end
        -- never fight velMoveThrough / cframeStepThrough while a TP is running
        if not isTeleporting and not _G.xyr0TPBusy then
            _vzL(hrp)
            _vzA(hrp)
        end
    end
end

-- one hold loop at a time; re-firing the hook just extends the existing one so
-- the 0.3s in-TP fire cadence cannot stack Heartbeat connections
local _gHoldUntil, _gHoldConn = 0, nil
local function _gHoldNoPull(tool, hrp, seconds)
    _gHoldUntil = os.clock() + seconds
    if _gHoldConn then return end
    local last = 0
    _gHoldConn = RunService.Heartbeat:Connect(function()
        local now = os.clock()
        if now - last >= 0.03 then
            last = now
            _gMuteAndStopPull(tool, hrp)
        end
        if now > _gHoldUntil then
            if _gHoldConn then _gHoldConn:Disconnect(); _gHoldConn = nil end
            _gMuteAndStopPull(tool, hrp)
        end
    end)
end

function _grappleToolReady(tool, waitS)
    if not tool or not tool.Parent then return false end
    local t0 = os.clock()
    while true do
        local ok, en = pcall(function() return tool.Enabled end)
        if not ok or en ~= false then return true end
        if os.clock() - t0 > (tonumber(waitS) or 0) then return false end
        RunService.Heartbeat:Wait()
        if not tool.Parent then return false end
    end
end
_G.xyr0ToolReady = _grappleToolReady

function _grappleDo(tool, pos, target, char)
    if not tool or not pos then return false end
    if typeof(pos) == "Instance" then pos = pos.Position end
    if typeof(pos) == "CFrame"   then pos = pos.Position end
    if typeof(pos) ~= "Vector3" then
        _G.xyr0GrappleWhy = "bad target position"
        return false
    end
    char = char or LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        _G.xyr0GrappleWhy = "no hrp"
        return false
    end
    if not _grappleToolReady(tool, tonumber(_G.xyr0GrappleCooldownWait) or 0.35) then
        _G.xyr0GrappleWhy = "hook on cooldown (Enabled=false)"
        return false
    end
    if not (_grappleUseItem and _grappleUseItem.Parent) then
        _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem")
    end
    if not (_grappleItemUse and _grappleItemUse.Parent) then
        _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
    end
    if not (_grappleUseItem and _grappleUseItem.Parent)
        and not (_grappleItemUse and _grappleItemUse.Parent) then
        _G.xyr0GrappleWhy = "unresolved"
        return false
    end
    local mag = (pos - hrp.Position).Magnitude
    local amt = math.clamp(mag / 120, 0, 2)
    local quiet = (_G.xyr0GrappleQuiet ~= false)
    if quiet then _gMuteAndStopPull(tool, hrp) end
    local fired = false
    if _grappleUseItem and _grappleUseItem.Parent then
        pcall(function() _grappleUseItem:FireServer(amt, pos) end); fired = true
    end
    if _grappleItemUse and _grappleItemUse.Parent then
        pcall(function() _grappleItemUse:FireServer(amt, pos) end); fired = true
    end
    if quiet then
        _gMuteAndStopPull(tool, hrp)
        _gHoldNoPull(tool, hrp, tonumber(_G.xyr0GrappleQuietFor) or 0.6)
    end
    _G.xyr0GrappleWhy = fired and "ok" or "no remote fired"
    return fired
end
_G.xyr0GrappleDo = _grappleDo

local function _grappleLegacyFire()
    local fired = false
    if not (_grappleUseItem and _grappleUseItem.Parent) then
        _grappleUseItem = getGrappleRemote("RemoteEvent", "UseItem")
    end
    if not (_grappleItemUse and _grappleItemUse.Parent) then
        _grappleItemUse = getGrappleRemote("RemoteEvent", "75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
    end
    if _grappleUseItem and _grappleUseItem.Parent then
        pcall(function() _grappleUseItem:FireServer(GRAPPLE_ARG) end); fired = true
    end
    if _grappleItemUse and _grappleItemUse.Parent then
        pcall(function() _grappleItemUse:FireServer(GRAPPLE_ARG) end); fired = true
    end
    _G.xyr0GrappleWhy = fired and "ok (legacy)" or "legacy: no remote"
    return fired
end

local _GFAN  = { 9, 10, 11, 12, 13, 14, 16, 18, 21, 24, 28, 32, 36, 40, 45 }
local _GFAN2 = { 11, 14, 18, 24, 32, 42, 48 }
local _GCOMPASS = {
    Vector3.new( 1, 0,  0), Vector3.new(-1, 0,  0),
    Vector3.new( 0, 0,  1), Vector3.new( 0, 0, -1),
    Vector3.new( 0.7, 0,  0.7), Vector3.new( 0.7, 0, -0.7),
    Vector3.new(-0.7, 0,  0.7), Vector3.new(-0.7, 0, -0.7),
}

-- _fireGrapple()            -> pick a target in front / around and hook it
-- _fireGrapple(vec3)        -> aim toward that point, still snapped to real geometry
-- _fireGrapple(vec3, true)  -> hook exactly that point (must be 10-50 studs out)
function _fireGrapple(value, exact)
    if _G.xyr0GrappleLegacy == true then return _grappleLegacyFire() end

    local char = LP.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    if LP:GetAttribute("Stealing") and _G.xyr0NoGrappleWhileCarrying == true then
        _G.xyr0GrappleWhy = "refused: carrying a brainrot"
        return false
    end

    local tool = char:FindFirstChild("Grapple Hook") or (findGrapple())
    if tool and tool.Parent ~= char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        pcall(function() hum:EquipTool(tool) end)
        local t0 = os.clock()
        repeat
            RunService.Heartbeat:Wait()
            char = LP.Character
            tool = char and (char:FindFirstChild("Grapple Hook") or (findGrapple()))
        until (tool and tool.Parent == char) or os.clock() - t0 > 0.5
        hrp = char and char:FindFirstChild("HumanoidRootPart")
    end
    if not tool or not hrp then return false end

    local par = RaycastParams.new()
    par.FilterType = Enum.RaycastFilterType.Exclude
    par.FilterDescendantsInstances = { char }

    if exact and typeof(value) == "Vector3" then
        local m = (value - hrp.Position).Magnitude
        if m < 10 or m > 50 then return false end
        local target
        local hit = _WSg:Raycast(hrp.Position, value - hrp.Position, par)
        if hit then target = hit.Instance end
        if not target then
            local okb, parts = pcall(function() return _WSg:GetPartBoundsInRadius(value, 6) end)
            if okb and parts then
                for _, p in ipairs(parts) do
                    if p:IsA("BasePart") and not p:IsDescendantOf(char) then target = p; break end
                end
            end
        end
        if not target then return false end
        return _grappleDo(tool, value, target, char)
    end

    local dest
    if typeof(value) == "Vector3" then dest = value
    elseif typeof(value) == "Instance" and value:IsA("BasePart") then dest = value.Position end

    local dir
    if dest then
        local d = dest - hrp.Position
        dir = Vector3.new(d.X, 0, d.Z)
    end
    if not dir or dir.Magnitude < 1 then
        local lv = hrp.CFrame.LookVector
        dir = Vector3.new(lv.X, 0, lv.Z)
    end
    if dir.Magnitude < 0.01 then return false end
    dir = dir.Unit

    local pos, target, bestM
    for _, d in ipairs(_GFAN) do
        local origin = hrp.Position + dir * d + Vector3.new(0, 3, 0)
        local hit = _WSg:Raycast(origin, Vector3.new(0, -60, 0), par)
        if hit then
            local m = (hit.Position - hrp.Position).Magnitude
            if m >= 10 and m <= 50 and (not bestM or m < bestM) then
                pos, target, bestM = hit.Position, hit.Instance, m
            end
        end
    end
    if not pos then
        for _, d in ipairs(_GFAN2) do
            local hit = _WSg:Raycast(hrp.Position, dir * d, par)
            if hit then
                local m = (hit.Position - hrp.Position).Magnitude
                if m >= 10 and m <= 50 and (not bestM or m < bestM) then
                    pos, target, bestM = hit.Position, hit.Instance, m
                end
            end
        end
    end
    if not pos then
        for _, cd in ipairs(_GCOMPASS) do
            for _, d in ipairs(_GFAN) do
                local origin = hrp.Position + cd * d + Vector3.new(0, 3, 0)
                local hit = _WSg:Raycast(origin, Vector3.new(0, -70, 0), par)
                if hit then
                    local m = (hit.Position - hrp.Position).Magnitude
                    if m >= 10 and m <= 50 and (not bestM or m < bestM) then
                        pos, target, bestM = hit.Position, hit.Instance, m
                    end
                end
            end
        end
    end
    if not pos or not target then
        _G.xyr0GrappleWhy = "no anchor within 10-50 studs"
        return false
    end
    return _grappleDo(tool, pos, target, char)
end
_G.xyr0FireGrappleBoth = _fireGrapple

function fireGrapple(value, exact)
    local char = LP.Character
    if not char then return false end
    return _fireGrapple(value, exact)
end
_G.xyr0FireGrapple = fireGrapple
_G.xyr0GrappleReady = function()
    return findGrapple() ~= nil and _grappleRemoteGet() ~= nil
end
end
-- === end Elite-method grapple ==============================================

CARPET_SPEED = 280
INBASE_SPEED = 450
SKY_CLONE_WAIT = 0.35
CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
function findTool(name)
    local char = LP.Character
    local bp = LP:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end
GRAPPLE_NAMES = { "Grapple Hook", "Grappling Hook", "Grapple", "Hook", "Web Slinger", "Grapple Gun", "GrappleHook" }
function findGrapple()
    for _, n in ipairs(GRAPPLE_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then return t, n end
    end
    return nil
end
function listTools()
    local out, char, bp = {}, LP.Character, LP:FindFirstChild("Backpack")
    if char then for _, t in ipairs(char:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then out[#out + 1] = t.Name end end end
    return table.concat(out, ", ")
end
_lastCarpetName = nil
function equipCarpet()
    local char = LP.Character
    if not char then return nil end
    if _lastCarpetName then
        local t = char:FindFirstChild(_lastCarpetName)
        if t and t.Parent == char then return _lastCarpetName end
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return nil end
    for _, n in ipairs(CARPET_NAMES) do
        local t = findTool(n)
        if t and t:IsA("Tool") then
            if t.Parent ~= char then pcall(function() hum:EquipTool(t) end) end
            _lastCarpetName = n
            return n
        end
    end
    return nil
end
function setCarpetTool(name)
    if type(name) ~= "string" or name == "" then return end
    _G.xyr0CarpetTool = name
    for i = #CARPET_NAMES, 1, -1 do
        if CARPET_NAMES[i] == name then table.remove(CARPET_NAMES, i) end
    end
    table.insert(CARPET_NAMES, 1, name)
end
_G.xyr0SetCarpetTool = setCarpetTool
if type(_G.xyr0CarpetTool) == "string" and _G.xyr0CarpetTool ~= "" then
    setCarpetTool(_G.xyr0CarpetTool)
end
_carpetEngaging = false
function carpetEngage(force)
    if not force then
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then
                    _G.TPEngage = "carpet=" .. tostring(n)
                    return n
                end
            end
        end
    end
    if _carpetEngaging then
        local _tw = os.clock()
        repeat RunService.Heartbeat:Wait() until (not _carpetEngaging) or os.clock() - _tw > 6
        local c = LP.Character
        if c then
            for _, n in ipairs(CARPET_NAMES) do
                local t = c:FindFirstChild(n)
                if t and t:IsA("Tool") then return n end
            end
        end
    end
    _carpetEngaging = true
    local _t0 = os.clock()
    while not findTool("Grapple Hook") and os.clock() - _t0 < 5 do
        RunService.Heartbeat:Wait()
    end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then _carpetEngaging = false; return nil end

    if not char:FindFirstChild("Grapple Hook") then
        local g = findTool("Grapple Hook")
        if g then pcall(function() hum:EquipTool(g) end) end
    end
    local _te = os.clock()
    while not (LP.Character and LP.Character:FindFirstChild("Grapple Hook")) and os.clock() - _te < 1.5 do
        local c = LP.Character
        local h2 = c and c:FindFirstChildOfClass("Humanoid")
        local g = findTool("Grapple Hook")
        if g and h2 then pcall(function() h2:EquipTool(g) end) end
        RunService.Heartbeat:Wait()
    end
    if LP.Character and LP.Character:FindFirstChild("Grapple Hook") then
        _fireGrapple()
    end
    task.wait(0.05)
    local h = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if h then pcall(function() h:UnequipTools() end) end
    task.wait(0.05)
    local cn
    local _tc = os.clock()
    repeat
        cn = equipCarpet()
        local c = LP.Character
        if cn and c and c:FindFirstChild(cn) then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _tc > 0.5
    _G.TPEngage = "carpet=" .. tostring(cn)
    _carpetEngaging = false
    return cn
end

_G.xyr0EquipCarpet = equipCarpet
_G.xyr0CarpetEngaging = function() return _carpetEngaging end

if _G.xyr0KeepCarpet == nil then _G.xyr0KeepCarpet = true end
LP.CharacterAdded:Connect(function(c)
    if _G.xyr0KeepCarpet == false then return end
    task.spawn(function()
        c:WaitForChild("Humanoid", 10)
        task.wait(tonumber(_G.xyr0CarpetRespawnDelay) or 0.6)
        if _G.xyr0KeepCarpet == false then return end
        if _carpetEngaging or LP.Character ~= c then return end
        if LP:GetAttribute("Stealing") == true then return end
        for _, n in ipairs(CARPET_NAMES) do
            if c:FindFirstChild(n) then return end
        end
        pcall(equipCarpet)
    end)
end)

PET_PRIORITY_TIERS = {
    [1] = { pets = {"Headless Horseman"}, threshold = 0 },
    [2] = { pets = {"Signore Carapace"}, threshold = 0 },
    [3] = { pets = {"John Pork"}, threshold = 0 },
    [4] = { pets = {"Strawberry Elephant"}, threshold = 0 },
    [5] = { pets = {"Arcadragon"}, threshold = 5e9 },
    [6] = { pets = {"Elefanto Frigo"}, threshold = 10e9 },
    [7] = { pets = {"Meowl"}, threshold = 5e9 },
    [8] = { pets = {"Skibidi Toilet"}, threshold = 5e9 },
    [9] = { pets = {"Love Love Bear"}, threshold = 0 },
    [10] = { pets = {"Antonio"}, threshold = 0 },
    [11] = { pets = {"Pancake and Syrup"}, threshold = 0 },
    [12] = { pets = {"Griffin"}, threshold = 0 },
    [13] = { pets = {"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako"}, threshold = 5e9 },
    [14] = { pets = {"Ginger Gerat","Pet"}, threshold = 10e9 },
    [15] = { pets = {"Hydra Bunny","Digi Narwhal","Kalika Bros"}, threshold = 3e9 },
    [16] = { pets = {"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"}, threshold = 3e9 },
    [17] = { pets = {"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"}, threshold = 3e9 },
    [18] = { pets = {"Fragola La La La","Cerberus","Guest 666","Los Hackers"}, threshold = 1e9 },
    [19] = { pets = {"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus"}, threshold = 750e6 },
    [20] = { pets = {"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"}, threshold = 1e9 },
}

TIER_LOOKUP = {}
for tier, data in pairs(PET_PRIORITY_TIERS) do
    for _, name in ipairs(data.pets) do TIER_LOOKUP[name] = tier end
end

LOCKED_TIERS = { [1]=true, [2]=true, [3]=true, [4]=true }

DIRECT_THRESHOLDS = {
    [3] = { [4] = 10e9 },
    [4] = {},
    [5] = { [6] = math.huge },
    [6] = { [9] = math.huge, [10] = math.huge, [12] = 15e9 },
    [10] = { [12] = 20e9 },
    [11] = { [12] = 10e9 },
}

MUTATION_PRIORITY = {
    ["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,
    ["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,
}

MUTATED_BEATS_GRIFFIN = {
    ["Fishino Clownino"]=true,["Globa Steppa"]=true,
    ["La Supreme Combinasion"]=true,["Tirilikalika Tirilikalako"]=true,
}

function getMutPrio(m)
    if not m or m == "" or m == "None" then return 0 end
    if MUTATION_PRIORITY[m] then return MUTATION_PRIORITY[m] end
    local n = tostring(m):lower():gsub("[%s%-_]","")
    if n == "bloodrot" then return 2 end
    if n == "yinyang" or n == "galaxy" or n == "candy" or n == "divine"
        or n == "cursed" or n == "lava" or n == "radioactive" or n == "cyber"
        or n == "rainbow" then return 1 end
    return 0
end

function getCumThreshold(hi, lo)
    if DIRECT_THRESHOLDS[hi] and DIRECT_THRESHOLDS[hi][lo] then return DIRECT_THRESHOLDS[hi][lo] end
    if LOCKED_TIERS[hi] then return math.huge end
    local total = 0
    for t = hi + 1, lo do
        local td = PET_PRIORITY_TIERS[t]
        if td and td.threshold > 0 then total = total + td.threshold end
    end
    return total
end

function _normName(s)
    return tostring(s):lower():gsub("[%s%-_'%.]", "")
end
_priCacheVer, _priCache = -1, {}
function _priLookup()
    local ver = _G.xyr0PriVersion or 0
    if _priCacheVer ~= ver then
        table.clear(_priCache)
        local plist = _G.SHARED_PRIORITY_ITEMS
        if type(plist) == "table" then
            for i = #plist, 1, -1 do _priCache[_normName(plist[i])] = i end
        end
        _priCacheVer = ver
    end
    return _priCache
end
_G.xyr0PriLookup = _priLookup
function _priIndexOf(name)
    if not name then return nil end
    return _priLookup()[_normName(name)]
end

function petOutranks(aName, bName, aMut, bMut, aMPS, bMPS)
    local iA = _priIndexOf(aName)
    local iB = _priIndexOf(bName)
    if iA ~= nil and iB ~= nil then return iA < iB end
    if (iA ~= nil) ~= (iB ~= nil) then return iA ~= nil end
    return (aMPS or 0) > (bMPS or 0)
end

function getPlotChannel(plotName)
    local channel
    pcall(function() channel = _G.xyr0SyncGet(plotName) end)
    return channel
end

function channelGet(channel, key)
    if not channel then return nil end
    local v
    pcall(function()
        local ct = rawget(channel, "CacheTable")
        if type(ct) == "table" then v = ct[key] end
    end)
    if v ~= nil then return v end
    pcall(function()
        local d = rawget(channel, "Data")
        if type(d) == "table" then v = d[key] end
    end)
    if v ~= nil then return v end
    pcall(function() v = rawget(channel, key) end)
    return v
end

function isMyPlot(channel)
    if not channel then return false end
    local owner = channelGet(channel, "Owner")
    if not owner then return false end
    local result = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            result = owner.UserId == LP.UserId
        elseif type(owner) == "table" and owner.UserId then
            result = owner.UserId == LP.UserId
        elseif typeof(owner) == "Instance" then
            result = owner == LP
        elseif type(owner) == "string" then
            
            result = owner:lower() == LP.Name:lower()
                or owner:lower() == (LP.DisplayName or LP.Name):lower()
        end
    end)
    return result
end

function ownerInGame(channel)
    if not channel then return false end
    local owner = channelGet(channel, "Owner")
    if not owner then return false end
    local inGame = false
    pcall(function()
        if typeof(owner) == "Instance" and owner:IsA("Player") then
            inGame = Players:FindFirstChild(owner.Name) ~= nil
        elseif type(owner) == "number" then
            inGame = Players:GetPlayerByUserId(owner) ~= nil
        elseif type(owner) == "table" and owner.Name then
            inGame = Players:FindFirstChild(tostring(owner.Name)) ~= nil
        elseif typeof(owner) == "Instance" and owner.Name then
            inGame = Players:FindFirstChild(owner.Name) ~= nil
        elseif type(owner) == "string" then
            
            if Players:FindFirstChild(owner) then
                inGame = true
            else
                local lo = owner:lower()
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.Name:lower() == lo or (pl.DisplayName or ""):lower() == lo then inGame = true break end
                end
            end
        end
    end)
    return inGame
end

_petModelCache = setmetatable({}, { __mode = "v" })
_genCache = {}
-- read the brainrot's own overhead "$3.5M/s" label when the data lookup comes up empty
local _MPS_SUFFIX = { K = 1e3, M = 1e6, B = 1e9, T = 1e12, Q = 1e15 }
function _worldMPS(plot, slot)
    local podiums = plot and plot:FindFirstChild("AnimalPodiums")
    local podium = podiums and podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end
    local best = nil
    for _, d in ipairs(podium:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local txt = d.Text
            if type(txt) == "string" and txt ~= "" then
                local num, suf = txt:match("%$%s*([%d%.]+)%s*([KMBTQ]?)%s*/s")
                if num then
                    local v = tonumber(num)
                    if v then
                        v = v * (_MPS_SUFFIX[suf] or 1)
                        if not best or v > best then best = v end
                    end
                end
            end
        end
    end
    return best
end
function getPetPosition(plot, slot, strict)
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(tostring(slot))
    if not podium then return nil end

    
    local key = plot.Name .. "\0" .. tostring(slot)
    local cached = _petModelCache[key]
    if cached and cached.Parent and cached:IsDescendantOf(podium) then
        local ok, cf = pcall(function() return cached:GetBoundingBox() end)
        if ok then return cf.Position end
    end
    _petModelCache[key] = nil

    for _, desc in ipairs(podium:GetDescendants()) do
        if desc:IsA("Model") and desc.Name ~= "Claim" and desc.Name ~= "Base" and desc.Name ~= "Decorations" then
            if desc:FindFirstChildWhichIsA("MeshPart", true) then
                local ok, cf = pcall(function() return desc:GetBoundingBox() end)
                if ok then
                    _petModelCache[key] = desc
                    return cf.Position
                end
            end
        end
    end

    if strict then return nil end
    local ok, cf = pcall(function() return podium:GetPivot() end)
    if ok then return cf.Position end
    return podium.Position
end

function scanAllPets()
    local pets = {}
    if not loadModules() then return pets end

    local Plots = workspace:FindFirstChild("Plots")
    if not Plots then return pets end

    local _mkSeen, _mkUse, _mkTotal = 0, 0, 0
    local _mkTags = {}
    for _, plot in ipairs(Plots:GetChildren()) do
        _mkTotal = _mkTotal + 1
        local channel = getPlotChannel(plot.Name)
        if not channel then _mkTags[#_mkTags + 1] = "nochan" continue end
        _mkSeen = _mkSeen + 1
        if isMyPlot(channel) then _G.xyr0MyPlot = plot.Name _mkTags[#_mkTags + 1] = "MINE" continue end
        if _G.xyr0MyPlot == plot.Name then _mkTags[#_mkTags + 1] = "MINE" continue end
        if not _G.xyr0MyPlot and channelGet(channel, "Owner") == nil then _mkTags[#_mkTags + 1] = "noowner?" continue end
        if _G.xyr0RequireOwner ~= false and not ownerInGame(channel) then _mkTags[#_mkTags + 1] = "left" continue end
        _mkUse = _mkUse + 1

        local animalList = channelGet(channel, "AnimalList")
        if not animalList then _mkTags[#_mkTags + 1] = "nolist" continue end
        local _mkPlotN = 0

        for slot, animalData in pairs(animalList) do
            if type(animalData) ~= "table" then continue end
            local animalName = animalData.Index
            if not animalName then continue end
            local animalInfo = AnimalsData and AnimalsData[animalName]
            if not animalInfo and _G.xyr0RequireKnown == true then continue end
            if _xyr0IsFusing(animalData) then continue end

            local mutation = animalData.Mutation or "None"

            local genValue
            local _gk = plot.Name .. "\0" .. tostring(slot)
            local _gc = _genCache[_gk]
            if _gc and _gc.n == animalName and _gc.m == animalData.Mutation and _gc.t == animalData.Traits then
                genValue = _gc.g
            else
                genValue = 0
                pcall(function()
                    genValue = AnimalsShared:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil)
                end)
                if genValue and genValue > 0 then
                    _genCache[_gk] = { n = animalName, m = animalData.Mutation, t = animalData.Traits, g = genValue }
                end
            end
            if (not genValue or genValue <= 0) and _G.xyr0WorldMPS ~= false then
                local wm = _worldMPS(plot, slot)
                if wm and wm > 0 then genValue = wm end
            end

            local displayName = (animalInfo and animalInfo.DisplayName) or animalName

            local pos = getPetPosition(plot, slot, (_G.xyr0RequireOwner == false) or (_G.xyr0RequireModel == true))

            if pos then
                if genValue >= (tonumber(_G.xyr0MinMPS) or 0) then
                    table.insert(pets, {
                        name = displayName,
                        index = animalName,
                        mps = genValue,
                        mutation = mutation,
                        traits = type(animalData.Traits) == "table" and animalData.Traits or {},
                        position = pos,
                        plot = plot.Name,
                        slot = tostring(slot),
                    })
                    _mkPlotN = _mkPlotN + 1
                end
            end
        end
        _mkTags[#_mkTags + 1] = tostring(_mkPlotN)
    end

    _G.xyr0ScanInfo = string.format("plots %d scanned of %d  pets %d  [%s]  %s", _mkUse, _mkTotal, #pets, table.concat(_mkTags, " "), tostring(_G.xyr0ScanMode))
    local _priLk = _priLookup()
    for _, p in ipairs(pets) do
        p._pri = _priLk[_normName(p.name)] or (p.index and _priLk[_normName(p.index)]) or nil
    end

    local mode = _G.xyr0StealMode
    if mode == "highest" then
        table.sort(pets, function(a, b) return (a.mps or 0) > (b.mps or 0) end)
        return pets
    end

    table.sort(pets, function(a, b)
        local ia, ib = a._pri, b._pri
        if ia and ib then
            if ia ~= ib then return ia < ib end
            return (a.mps or 0) > (b.mps or 0)
        end
        if (ia ~= nil) ~= (ib ~= nil) then return ia ~= nil end
        return (a.mps or 0) > (b.mps or 0)
    end)

    return pets
end
_G.xyr0ScanAllPets = scanAllPets  

function scanForTP()
    local full = scanAllPets()
    if type(full) ~= "table" then full = {} end
    if _G.xyr0ScanTiered and _G.xyr0UseTiered ~= false then
        local ok, tiered = pcall(_G.xyr0ScanTiered)
        if ok and type(tiered) == "table" and #tiered > 0 then
            local seen = {}
            for _, p in ipairs(full) do
                if p and p.plot and p.slot ~= nil then
                    seen[tostring(p.plot) .. "_" .. tostring(p.slot)] = true
                end
            end
            for _, p in ipairs(tiered) do
                if p and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    if not seen[uid] then
                        seen[uid] = true
                        full[#full + 1] = p
                    end
                end
            end
        end
    end
    return full
end

function _petUid(p)
    if not p then return nil end
    return tostring(p.plot) .. "_" .. tostring(p.slot)
end
function _pickPetOnFoot(pets, myPos)
    if not pets or #pets == 0 then return nil end
    local best
    if _G.xyr0StealMode == "nearest" and myPos then
        local bestD = math.huge
        for _, p in ipairs(pets) do
            if not p.conveyor and p.position then
                local d = (p.position - myPos).Magnitude
                if d < bestD then bestD = d; best = p end
            end
        end
    else
        for _, p in ipairs(pets) do
            if not p.conveyor then best = p; break end
        end
    end
    return best or pets[1]
end
function _findTPSyncedPet(pets)
    local uid = _G.xyr0StealTargetUID
    if type(uid) ~= "string" or uid == "" then return nil end
    for _, p in ipairs(pets) do
        if _petUid(p) == uid then return p end
    end
    return nil
end
function _clearTPSync()
    _G.xyr0TPSyncActive = false
    _G.xyr0StealTargetUID = nil
    _G.xyr0StealTarget = nil
end
function _armTPSync(pet)
    if not pet then return end
    _G.xyr0StealTargetUID = _petUid(pet)
    _G.xyr0StealTarget = pet
    _G.xyr0TPSyncActive = true
    local gen = (_G._xyr0TPSyncGen or 0) + 1
    _G._xyr0TPSyncGen = gen
    task.delay(12, function()
        if _G._xyr0TPSyncGen == gen then _clearTPSync() end
    end)
end
_G.xyr0ClearTPSync = _clearTPSync
function _findStealTarget(pets)
    if not _G.xyr0TPSyncActive then return nil end
    return _findTPSyncedPet(pets)
end
function _publishStealTarget(pet)
    if not pet then return end
    _G.xyr0StealTargetUID = _petUid(pet)
    _G.xyr0StealTarget = pet
end

MK_UPPER = {
    B = {{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},{coord=Vector3.new(-332.379730,16.850722,-75.762100),facing="NORTH"},{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"}},
    C = {{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},{coord=Vector3.new(-502.989349,16.850713,31.172430),facing="NORTH"},{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"}},
    D = {{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"}},
}
MK_LOWER = {
    B = {{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},{coord=Vector3.new(-483.619385,-3.718430,-18.844337),facing="SOUTH"},{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"}},
    C = {{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},{coord=Vector3.new(-483.749390,-3.048218,88.147003),facing="SOUTH"},{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"}},
    D = {{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"}},
}
UPPER_Y_THRESHOLD = 7
TALL_PETS = { ["La Secret Combinasion"]=true, ["La Jolly Grande"]=true }
TALL_OFFSET = 3

BASES_LOW = {
    [1] = Vector3.new(-476.52, -2, 220.94090270996094),
    [2] = Vector3.new(-476.52, -2, 113.77315521240234),
    [3] = Vector3.new(-476.52, -2, 6.178487777709961),
    [4] = Vector3.new(-476.52, -2, -101.07275390625),
    [5] = Vector3.new(-342.66, -2, 221.44737243652344),
    [6] = Vector3.new(-342.66, -2, 113.41409301757812),
    [7] = Vector3.new(-342.66, -2, 6.249461650848389),
    [8] = Vector3.new(-342.66, -2, -99.73458862304688),
}
BASES_HIGH = {
    [1] = Vector3.new(-479.51, 18, 220.94090270996094),
    [2] = Vector3.new(-479.51, 18, 113.77315521240234),
    [3] = Vector3.new(-479.51, 18, 6.178487777709961),
    [4] = Vector3.new(-479.51, 18, -101.07275390625),
    [5] = Vector3.new(-339.48, 18, 221.44737243652344),
    [6] = Vector3.new(-339.48, 18, 113.41409301757812),
    [7] = Vector3.new(-339.48, 18, 6.249461650848389),
    [8] = Vector3.new(-339.48, 18, -99.73458862304688),
}
FRONT_Y_LOW   = -3.048217
FRONT_Y_HIGH  = 16.850713
COLUMN_SPLIT_X = -410
FRONT_Z_CLAMP  = 18
SIDE_NEAR_Z    = 45

function getClosestBaseIdx(pos)
    local closest, dist = 1, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (pos.X - b.X)^2 + (pos.Z - b.Z)^2
        if d < dist then dist = d; closest = i end
    end
    return closest
end

function buildFrontCandidate(idx, isUpper, playerZ)
    local base = isUpper and BASES_HIGH[idx] or BASES_LOW[idx]
    local frontY = isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
    local frontZ = math.clamp(playerZ - base.Z, -FRONT_Z_CLAMP, FRONT_Z_CLAMP) + base.Z
    local coord = Vector3.new(base.X, frontY, frontZ)
    local faceDir = (idx <= 4) and Vector3.new(-1, 0, 0) or Vector3.new(1, 0, 0)
    return coord, faceDir
end

function plotSides(coordTable, idx)
    local base = BASES_LOW[idx]
    local isWest = idx <= 4
    local out = {}
    for _, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            if ((data.coord.X < COLUMN_SPLIT_X) == isWest)
               and math.abs(data.coord.Z - base.Z) < SIDE_NEAR_Z then
                out[#out + 1] = data
            end
        end
    end
    return out
end

function _floor1LaserSolid(plotName)
    local solid = false
    pcall(function()
        local Plots = workspace:FindFirstChild("Plots")
        local plot = Plots and Plots:FindFirstChild(plotName)
        if not plot then return end
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("BasePart") and (d.Name == "LaserHitbox" or d.Name == "Laser")
                and d.CanCollide and d.Position.Y <= 9 then
                solid = true
                break
            end
        end
    end)
    return solid
end

function isPlotUnlocked(plotName)
    local ok, res = pcall(function()
        local channel = getPlotChannel(plotName)
        if not channel then return false end
        if channelGet(channel, "BlockEndTimeFirstFloor") ~= nil then return false end
        return not _floor1LaserSolid(plotName)
    end)
    return ok and (res == true)
end

function findClosest(petPos, coordTable)
    local best, bestKey, bestDist = nil, nil, math.huge
    for skyKey, coords in pairs(coordTable) do
        for _, data in ipairs(coords) do
            local c = data.coord
            local d = math.sqrt((petPos.X - c.X)^2 + (petPos.Z - c.Z)^2)
            if d < bestDist then bestDist = d; best = data; bestKey = skyKey end
        end
    end
    return best, bestKey
end

do
_vizParts = {}
_vizGen = 0

function _vizEnsure()
    if _vizFolder and _vizFolder.Parent then return end
    _vizFolder = Instance.new("Folder")
    -- was "xyr0PathViz": Workspace is readable by the game's own LocalScripts,
    -- so a self-identifying name is a free detection. Cleanup is by reference.
    _vizFolder.Name = "Effects"
    _vizFolder.Parent = workspace
    _vizAnchor = Instance.new("Part")
    _vizAnchor.Name = "Anchor"
    _vizAnchor.Anchored = true; _vizAnchor.CanCollide = false; _vizAnchor.CanQuery = false
    _vizAnchor.CanTouch = false; _vizAnchor.Transparency = 1; _vizAnchor.Size = Vector3.one
    _vizAnchor.CFrame = CFrame.new()
    _vizAnchor.Parent = _vizFolder
end
clearViz = function()
    if _vizFolder then pcall(function() _vizFolder:Destroy() end) end
    _vizFolder, _vizAnchor = nil, nil
    table.clear(_vizParts)
end
local function _ghost(cf, size, color, op)
    _vizEnsure()
    local a = Instance.new("BoxHandleAdornment")
    a.Adornee = _vizAnchor
    a.AlwaysOnTop = true
    a.ZIndex = 0
    pcall(function() a.Shading = Enum.AdornShading.XRayShaded end)
    a.Color3 = color
    a.Transparency = 1 - op
    a.Size = size
    a.CFrame = cf
    a.Parent = _vizAnchor
end
local function _neon(cf, size, color, ball, transp)
    _vizEnsure()
    local p = Instance.new("Part")
    p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false; p.CastShadow = false
    p.Material = Enum.Material.Neon; p.Color = color
    p.Transparency = transp or 0
    if ball then p.Shape = Enum.PartType.Ball end
    p.Size = size; p.CFrame = cf; p.Parent = _vizFolder
end
function vizLine(a, b, color)
    local d = b - a
    if d.Magnitude < 0.05 then return end
    _neon(CFrame.lookAt((a + b) * 0.5, b), Vector3.new(0.25, 0.25, d.Magnitude), color, false, 0)
end
function vizDot(pos, color, sz)
    _neon(CFrame.new(pos), Vector3.new(sz, sz, sz), color, true, 0)
end
vizPath = function(fromPos, waypoints)
    if _G.xyr0ShowPath ~= true then return end
    if #waypoints == 0 then return end
    local COL = Color3.fromRGB(255, 195, 45)
    local prev = fromPos
    for _, wp in ipairs(waypoints) do
        vizLine(prev, wp, COL)
        prev = wp
    end
    vizDot(waypoints[#waypoints], COL, 1.6)
end
end

MK_SPEED = 125
MK_ARRIVE = 3
_STRIP_OK = (type(getconnections) == "function")
function _climbCap()
    local v = math.clamp(tonumber(_G.xyr0Climb) or 200, 100, 250)
    if not _STRIP_OK then v = 55 end
    return v
end

function vZero(hrp)
    if hrp then _vzL(hrp); _vzA(hrp) end
end


function _setFlightVel(hrp, vel)
    local char = hrp and hrp.Parent
    local part = (char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))) or hrp
    if part then part.AssemblyLinearVelocity = vel end
end

function velMoveThrough(hrp, waypoints, speedOverride, allowJump, quickStart)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    local _runSpeed = speedOverride or (_G.TPVelocity and math.clamp(_G.TPVelocity, 200, 750)) or CARPET_SPEED
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local done = false
    local conn
    local function finish()
        if done then return end
        done = true
        if hrp and hrp.Parent then
            _vzL(hrp)
            _vzA(hrp)
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(waypoints[#waypoints]) * CFrame.Angles(0, y, 0)
        end
        if conn then conn:Disconnect() end
    end
    local lastDist, stall = math.huge, 0

    local _stStart = os.clock()
    local _lastJump = 0

    local _routeLen = 0
    do
        local _p = hrp.Position
        for _, wp in ipairs(waypoints) do
            _routeLen = _routeLen + (_p - wp).Magnitude
            _p = wp
        end
    end
    local _mayJump = _routeLen >= (tonumber(_G.xyr0JumpMinDist) or 100)

    local _ = quickStart

    conn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent or done then
            if conn then conn:Disconnect() end
            return
        end
        if _G.xyr0TPStop then finish() return end
        equipCarpet()
        if _mayJump and _G.xyr0JumpEachStep ~= false then
            local _now = os.clock()
            if _now - _lastJump >= (tonumber(_G.xyr0JumpGap) or 0.2) then
                _lastJump = _now
                local _jh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _jh then
                    pcall(function() _jh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() _jh.Jump = true end)
                end
            end
        end
        local target = waypoints[wpIdx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local _spd = _runSpeed
        if wpIdx < #waypoints and mag < 26 then
            local nxt = waypoints[wpIdx + 1]
            local b = nxt - target
            if mag > 0.1 and b.Magnitude > 0.1 and diff.Unit:Dot(b.Unit) < 0.9 then
                _spd = math.min(_spd, 240)
            end
        end
        local _arr = math.max(MK_ARRIVE, _spd / 60 * 1.25)
        if mag < _arr then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then finish() return end
            lastDist, stall = math.huge, 0
            if _G.xyr0ZeroEachStep ~= false and _vzOK() then
                pcall(function()
                    local _v = hrp.AssemblyLinearVelocity
                    local _keepY = (_G.xyr0ZeroStepKeepY == false) and 0 or math.max(_v.Y, 0)
                    hrp.AssemblyLinearVelocity = Vector3.new(0, _keepY, 0)
                    hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                end)
            end
            if _mayJump and _G.xyr0JumpEachStep ~= false then
                local _wh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _wh then
                    _lastJump = os.clock()
                    pcall(function() _wh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                    pcall(function() _wh.Jump = true end)
                end
            end
            target = waypoints[wpIdx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end

        if mag > lastDist - 0.05 then stall = stall + 1 else stall = 0 end
        lastDist = mag
        if stall >= (tonumber(_G.xyr0StallFrames) or 18) then finish() return end

        if mag >= 0.1 then
            local dir = diff.Unit
            if (allowJump or diff.Y > 10) and diff.Y > 5 and wpIdx < #waypoints then
                local hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if hum then
                    local st = hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() hum.Jump = true end)
                    end
                end
            end
            local _sp = _spd
            if _G.xyr0TPSafeMode ~= false then
                _sp = math.min(_sp, tonumber(_G.xyr0TPSafeSpeed) or 300)
            end
            local _mc = _climbCap()
            local _vCap = tonumber(_G.xyr0TPSafeVerticalSpeed) or 110
            if dir.Y > 0 and dir.Y * _sp > math.min(_mc, _vCap) then
                _sp = math.min(_mc, _vCap) / dir.Y
            elseif dir.Y < 0 and math.abs(dir.Y * _sp) > _vCap then
                _sp = _vCap / math.abs(dir.Y)
            end
            _setFlightVel(hrp, Vector3.new(dir.X * _sp, dir.Y * _sp, dir.Z * _sp))
        end
    end))

    local totalDist = 0
    do
        local prev = hrp.Position
        for _, wp in ipairs(waypoints) do
            totalDist = totalDist + (prev - wp).Magnitude
            prev = wp
        end
    end
    local timeout = totalDist / math.min(MK_SPEED, _runSpeed) + (tonumber(_G.xyr0FlightGrace) or 2)
    local elapsed = 0
    while not done and elapsed < timeout do
        task.wait(0.05)
        elapsed = elapsed + 0.05
        if not (hrp and hrp.Parent) then break end
    end
    finish()
    vZero(hrp)
end

_OTHER_CLONES = {}
do
    local _MY_CLONE = tostring(LP.UserId) .. "_Clone"
    local _seen = {}
    local function _isOtherClone(inst)
        if not inst then return false end
        local n = inst.Name
        if n == _MY_CLONE then return false end
        if n:match("^%d+_Clone$") then return true end
        if not n:find("lone", 1, true) then return false end
        if not inst:IsA("Model") then return false end
        if inst == LP.Character then return false end
        if not inst:FindFirstChild("HumanoidRootPart") then return false end
        if not inst:FindFirstChildOfClass("Humanoid") then return false end
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl.Character == inst then return false end
        end
        return true
    end
    local function _neutralize(inst)
        if not inst or _seen[inst] then return end
        _seen[inst] = true
        _OTHER_CLONES[#_OTHER_CLONES + 1] = inst
        local function declaw(d)
            if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
        end
        for _, d in ipairs(inst:GetDescendants()) do declaw(d) end
        inst.DescendantAdded:Connect(declaw)
        inst.Destroying:Connect(function()
            _seen[inst] = nil
            for i = #_OTHER_CLONES, 1, -1 do
                if _OTHER_CLONES[i] == inst then table.remove(_OTHER_CLONES, i); break end
            end
        end)
    end
    local function _scan(inst)
        if _isOtherClone(inst) then _neutralize(inst) end
    end
    for _, c in ipairs(workspace:GetChildren()) do _scan(c) end
    workspace.ChildAdded:Connect(function(c)
        _scan(c)
        task.defer(function() if c and c.Parent == workspace then _scan(c) end end)
    end)
end

do
    local _pSeen = setmetatable({}, { __mode = "k" })
    local function _declaw(d)
        if d:IsA("BasePart") and d.CanCollide then pcall(function() d.CanCollide = false end) end
    end
    local function _declawChar(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do _declaw(d) end
        if not _pSeen[char] then
            _pSeen[char] = true
            char.DescendantAdded:Connect(_declaw)
        end
    end
    local function _hookPlayer(pl)
        if pl == LP then return end
        if pl.Character then _declawChar(pl.Character) end
        pl.CharacterAdded:Connect(function(c) task.wait(0.15); _declawChar(c) end)
    end
    for _, pl in ipairs(Players:GetPlayers()) do _hookPlayer(pl) end
    Players.PlayerAdded:Connect(_hookPlayer)
    task.spawn(function()
        _G.xyr0BootWait()
        while true do
            task.wait(3)
            local myHrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl ~= LP and pl.Character then
                    local h = pl.Character:FindFirstChild("HumanoidRootPart")
                    if not myHrp or (h and (h.Position - myHrp.Position).Magnitude <= 150) then
                        for _, d in ipairs(pl.Character:GetDescendants()) do _declaw(d) end
                        task.wait() 
                    end
                end
            end
        end
    end)
end

local _len
do
local _DIRS = { Vector3.new(1,0,0), Vector3.new(-1,0,0), Vector3.new(0,0,1), Vector3.new(0,0,-1) }
local _STRUCT = { ["structure base home"] = true, ["Wall"] = true, ["Floor"] = true, ["Roof"] = true }
local _SKIP_NAME = { ["DeliveryHitbox"]=true, ["StealHitbox"]=true, ["LaserHitbox"]=true,
    ["AnimalTarget"]=true, ["Multiplier"]=true, ["Laser"]=true, ["Hitbox"]=true,
    ["Spawn"]=true, ["MainRoot"]=true, ["SecondFloor"]=true, ["ThirdFloor"]=true, ["Slope"]=true }
local function _blocks(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 150 then return true end
    return false
end
local function _blocksWide(inst)
    if not inst then return false end
    if _SKIP_NAME[inst.Name] then return false end
    if inst.CanCollide then return true end
    local _par = inst.Parent
    if _par and (_par.Name == "ObstacleVolumes" or _par.Name == "ObstacleVolume") then return false end
    if _STRUCT[inst.Name] then return true end
    local s = inst.Size
    if s and math.max(s.X * s.Y, s.X * s.Z, s.Y * s.Z) > 30 then return true end
    return false
end
local function _block(origin, target, blockFn)
    blockFn = blockFn or _blocks
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = origin
    for _ = 1, 16 do
        rp.FilterDescendantsInstances = skip
        local d = target - o
        if d.Magnitude < 0.05 then return nil end
        local res = workspace:Raycast(o, d, rp)
        if not res then return nil end
        if blockFn(res.Instance) then return res end
        skip[#skip + 1] = res.Instance
        o = res.Position + d.Unit * 0.3
    end
    return nil
end
local function _clear(a, b) return _block(a, b) == nil end
local function _clearDist(origin, dir, maxD)
    local res = _block(origin, origin + dir.Unit * maxD)
    if not res then return maxD end
    return (res.Position - origin).Magnitude
end
function _len(pts)
    local s, prev = 0, pts[1]
    for k = 2, #pts do s = s + (pts[k] - prev).Magnitude; prev = pts[k] end
    return s
end
local function _pull(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    while i < #pts do
        local j = #pts
        while j > i + 1 and not _clear(out[#out], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end
local function _stages(toPos)
    local st = {}
    for _, dr in ipairs(_DIRS) do
        local cd = _clearDist(toPos, dr, 46)
        if cd >= 12 then st[#st + 1] = toPos + dr * math.min(cd - 5, 38) end
    end
    return st
end
local function _routeClear(pts)
    for i = 1, #pts - 1 do
        if not _clear(pts[i], pts[i + 1]) then return false end
    end
    return true
end
local function _peakY(pts)
    local m = -math.huge
    for _, p in ipairs(pts) do if p.Y > m then m = p.Y end end
    return m
end
local function _starts(fromPos)
    local pts = { fromPos }
    if _block(fromPos, fromPos + Vector3.new(0, 40, 0)) then
        for _, dr in ipairs(_DIRS) do
            local cd = _clearDist(fromPos, dr, 40)
            if cd >= 12 then pts[#pts + 1] = fromPos + dr * math.min(cd - 5, 34) end
        end
    end
    return pts
end

local function _candidates(sp, stage, toPos)
    local list = {}
    local function add(mid)
        if mid then list[#list + 1] = { sp, mid, stage, toPos }
        else list[#list + 1] = { sp, stage, toPos } end
    end
    add(nil)
    add(Vector3.new(stage.X, sp.Y, stage.Z))
    add(Vector3.new(sp.X, stage.Y, sp.Z))
    local dir = Vector3.new(stage.X - sp.X, 0, stage.Z - sp.Z)
    if dir.Magnitude > 0.1 then
        dir = dir.Unit
        local perp = Vector3.new(-dir.Z, 0, dir.X)
        for _, off in ipairs({ 20, -20, 40, -40 }) do
            add(sp + perp * off)
        end
    end
    return list
end

local PathfindingService = game:GetService("PathfindingService")
local _CLEARANCE = 16
local function _clearWideRay(a, b)
    return _block(a, b, _blocksWide) == nil
end

local _SWEEP_R = 4
local _ENDPOINT_SLACK = 6
local _canSphere = nil
local function _sweepBlockFn(inst)
    if _G.xyr0StrictSweep == false then return _blocks(inst) end
    return _blocksWide(inst)
end
local function _sweepDir(a, b)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.IgnoreWater = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    for _, cl in ipairs(_OTHER_CLONES) do skip[#skip + 1] = cl end
    local o = a
    for _ = 1, 24 do
        rp.FilterDescendantsInstances = skip
        local d = b - o
        if d.Magnitude < 0.05 then return false end
        local res
        local ok = pcall(function() res = workspace:Spherecast(o, _SWEEP_R, d, rp) end)
        if not ok then _canSphere = false; return nil end
        if not res then return false end
        if _sweepBlockFn(res.Instance) then return true end
        skip[#skip + 1] = res.Instance
        local adv = (res.Distance or 0) - 0.05
        if adv > 0 then o = o + d.Unit * math.min(adv, d.Magnitude) end
    end
    return true
end
local function _sweepBlocked(a, b, slackA, slackB)
    if _canSphere == nil then
        _canSphere = pcall(function()
            workspace:Spherecast(Vector3.new(0, 10000, 0), 1, Vector3.new(0, -1, 0), RaycastParams.new())
        end)
    end
    if not _canSphere then return nil end
    local d = b - a
    local len = d.Magnitude
    if len < 0.1 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or _ENDPOINT_SLACK, len * 0.4)
    local b2 = b - u * math.min(slackB or _ENDPOINT_SLACK, len * 0.4)
    local fwd = _sweepDir(a2, b2)
    if fwd == nil then return nil end
    if fwd then return true end
    local rev = _sweepDir(b2, a2)
    if rev == nil then return nil end
    return rev
end

local function _clearWide(a, b, slackA, slackB)
    if not _clear(a, b) then return false end
    local sw = _sweepBlocked(a, b, slackA, slackB)
    if sw ~= nil then return not sw end
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        local ox = Vector3.new(_CLEARANCE, 0, 0)
        local oz = Vector3.new(0, 0, _CLEARANCE)
        return _clearWideRay(a + ox, b + ox) and _clearWideRay(a - ox, b - ox)
            and _clearWideRay(a + oz, b + oz) and _clearWideRay(a - oz, b - oz)
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * _CLEARANCE
    local up = Vector3.new(0, _CLEARANCE, 0)
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + up, b + up)
        and _clearWideRay(a - up, b - up)
end

local function _crestClear(a, b)
    if not _clear(a, b) then return false end
    local cl = tonumber(_G.xyr0CrestClearance) or 6
    local d = Vector3.new(b.X - a.X, 0, b.Z - a.Z)
    if d.Magnitude < 0.1 then
        return true
    end
    local perp = Vector3.new(-d.Z, 0, d.X).Unit * cl
    return _clearWideRay(a + perp, b + perp)
        and _clearWideRay(a - perp, b - perp)
        and _clearWideRay(a + Vector3.new(0, cl, 0), b + Vector3.new(0, cl, 0))
end

local function _pullWide(pts)
    if #pts <= 2 then return pts end
    local out = { pts[1] }
    local i = 1
    local n = #pts
    while i < n do
        local j = n
        while j > i + 1 do
            local a, b = out[#out], pts[j]
            local sA = (i == 1) and _ENDPOINT_SLACK or 0
            local sB = (j == n) and _ENDPOINT_SLACK or 0
            if _clearWide(a, b, sA, sB) then break end
            j = j - 1
        end
        out[#out + 1] = pts[j]
        i = j
    end
    return out
end

local function _pushOffWalls(pts)
    if #pts <= 2 then return pts end
    local MARGIN = 8
    local MAX_PUSH = 12
    local out = { pts[1] }
    for i = 2, #pts - 1 do
        local p = pts[i]
        local shift = Vector3.zero
        for _, dr in ipairs(_DIRS) do
            local res = _block(p, p + dr * MARGIN, _blocks)
            if res then
                local dist = (res.Position - p).Magnitude
                if dist < MARGIN then
                    shift = shift - dr * (MARGIN - dist)
                end
            end
        end
        do
            local resUp = _block(p, p + Vector3.new(0, MARGIN, 0), _blocks)
            if resUp then
                local dist = (resUp.Position - p).Magnitude
                if dist < 4 then shift = shift + Vector3.new(0, -(4 - dist), 0) end
            end
        end
        if shift.Magnitude > 0.1 then
            if shift.Magnitude > MAX_PUSH then shift = shift.Unit * MAX_PUSH end
            local moved = p + shift
            if _clear(out[#out], moved) then
                out[#out + 1] = moved
            else
                out[#out + 1] = p
            end
        else
            out[#out + 1] = p
        end
    end
    out[#out + 1] = pts[#pts]
    return out
end


do
local _vxFloor, _vxSqrt = math.floor, math.sqrt
local _vxMin, _vxMax = math.min, math.max
local function _vxAbs(n) return n < 0 and -n or n end

local _vxOverlap = OverlapParams.new()
_vxOverlap.FilterType = Enum.RaycastFilterType.Exclude
_vxOverlap.RespectCanCollide = true

local _vxCast = RaycastParams.new()
_vxCast.FilterType = Enum.RaycastFilterType.Exclude
_vxCast.RespectCanCollide = true
_vxCast.IgnoreWater = true

local _vxOrigin
local _vxDimX, _vxDimY, _vxDimZ = 0, 0, 0
local _vxSz, _vxInflate = 4, 2.5
local _vxSolid = {}
local _vxHeight = 5

local function _vxWorld(sz, x, y, z)
    local h = sz * 0.5
    return Vector3.new(_vxOrigin.X + x * sz + h, _vxOrigin.Y + y * sz + h, _vxOrigin.Z + z * sz + h)
end
local function _vxKey(x, y, z) return x + y * 1024 + z * 1048576 end

local function _vxIsSolid(x, y, z)
    if x < 0 or y < 0 or z < 0 or x >= _vxDimX or y >= _vxDimY or z >= _vxDimZ then return true end
    local k = _vxKey(x, y, z)
    local c = _vxSolid[k]
    if c ~= nil then return c end
    local h = _vxSz * 0.5
    local cx = _vxOrigin.X + x * _vxSz + h
    local cy = _vxOrigin.Y + y * _vxSz + h
    local cz = _vxOrigin.Z + z * _vxSz + h
    local sxz = _vxSz + _vxInflate
    local vy = _vxHeight > _vxSz and _vxHeight or _vxSz
    local vcy = cy - h + vy * 0.5
    local parts = workspace:GetPartBoundsInBox(CFrame.new(cx, vcy, cz), Vector3.new(sxz, vy, sxz), _vxOverlap)
    local solid = #parts > 0
    _vxSolid[k] = solid
    return solid
end

local function _vxSegClear(from, to, radius, height, sample)
    local dir = to - from
    local mag = dir.Magnitude
    if mag < 0.05 then return true end
    if workspace:Raycast(from, dir, _vxCast) then return false end
    local r = radius > 1 and radius or 1
    if workspace:Blockcast(CFrame.new(from), Vector3.new(r * 2, height, r * 2), dir, _vxCast) ~= nil then return false end
    local n = _vxFloor(mag)
    if sample ~= false and n >= 2 then
        local step = dir / n
        local torso = Vector3.new(r * 2, 3, r * 2)
        for i = 1, n - 1 do
            local pt = from + step * i
            if #workspace:GetPartBoundsInBox(CFrame.new(pt), torso, _vxOverlap) > 0 then return false end
        end
    end
    return true
end

local _vxNeigh = {}
do
    for dx = -1, 1 do
        for dy = -1, 1 do
            for dz = -1, 1 do
                if dx ~= 0 or dy ~= 0 or dz ~= 0 then
                    local nz = (dx ~= 0 and 1 or 0) + (dy ~= 0 and 1 or 0) + (dz ~= 0 and 1 or 0)
                    local kd = dx + dy * 1024 + dz * 1048576
                    _vxNeigh[#_vxNeigh + 1] = { dx, dy, dz, _vxSqrt(dx * dx + dy * dy + dz * dz), nz, kd }
                end
            end
        end
    end
end

local function _vxNoCorner(cx, cy, cz, off)
    if off[5] < 2 then return true end
    if off[1] ~= 0 and _vxIsSolid(cx + off[1], cy, cz) then return false end
    if off[2] ~= 0 and _vxIsSolid(cx, cy + off[2], cz) then return false end
    if off[3] ~= 0 and _vxIsSolid(cx, cy, cz + off[3]) then return false end
    return true
end

local function _vxSnapGoal(goalPos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and (_vxWorld(_vxSz, nx, ny, nz) - goalPos).Magnitude <= 8 then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end
local function _vxSnapStart(pos, x, y, z)
    if not _vxIsSolid(x, y, z) then return x, y, z end
    for r = 1, 16 do
        for dx = -r, r do
            for dy = -r, r do
                for dz = -r, r do
                    if _vxMax(_vxAbs(dx), _vxAbs(dy), _vxAbs(dz)) == r then
                        local nx, ny, nz = x + dx, y + dy, z + dz
                        if not _vxIsSolid(nx, ny, nz) and not workspace:Raycast(pos, _vxWorld(_vxSz, nx, ny, nz) - pos, _vxCast) then
                            return nx, ny, nz
                        end
                    end
                end
            end
        end
    end
    return x, y, z
end

local function _vxPush(h, f, key)
    local i = #h + 1
    h[i] = { f, key }
    while i > 1 do
        local p = _vxFloor(i * 0.5)
        if h[p][1] <= h[i][1] then break end
        h[p], h[i] = h[i], h[p]
        i = p
    end
end
local function _vxPop(h)
    local n = #h
    if n == 0 then return nil end
    local top = h[1]
    h[1] = h[n]
    h[n] = nil
    n -= 1
    local i = 1
    while true do
        local l, r, s = i + i, i + i + 1, i
        if l <= n and h[l][1] < h[s][1] then s = l end
        if r <= n and h[r][1] < h[s][1] then s = r end
        if s == i then break end
        h[i], h[s] = h[s], h[i]
        i = s
    end
    return top[2]
end

local _vxHeurW = 2
local function _vxAStar(sz, startCell, goalCell, startPos, goalPos)
    local sx, sy, sz2 = _vxSnapStart(startPos, startCell.x, startCell.y, startCell.z)
    local gx, gy, gz = _vxSnapGoal(goalPos, goalCell.x, goalCell.y, goalCell.z)
    local goalKey = _vxKey(gx, gy, gz)
    local startKey = _vxKey(sx, sy, sz2)

    local nodes = { [startKey] = { x = sx, y = sy, z = sz2, g = 0, parent = nil } }
    local closed = {}
    local heap = {}
    _vxPush(heap, 0, startKey)

    local function Heur(x, y, z)
        local ax, ay, az = x - gx, y - gy, z - gz
        return _vxSqrt(ax * ax + ay * ay + az * az)
    end

    local pops = 0
    while #heap > 0 do
        local curKey = _vxPop(heap)
        if closed[curKey] then continue end
        closed[curKey] = true
        pops += 1
        if pops > 300000 then break end

        local cur = nodes[curKey]
        if curKey == goalKey then
            local path = {}
            local n = cur
            while n do
                path[#path + 1] = _vxWorld(sz, n.x, n.y, n.z)
                n = n.parent and nodes[n.parent]
            end
            local rev = {}
            for i = #path, 1, -1 do rev[#rev + 1] = path[i] end
            return rev
        end

        local cx, cy, cz = cur.x, cur.y, cur.z
        local cg = cur.g
        for _, off in _vxNeigh do
            local nk = curKey + off[6]
            if closed[nk] then continue end
            local nx, ny, nz = cx + off[1], cy + off[2], cz + off[3]
            if _vxIsSolid(nx, ny, nz) then continue end
            if not _vxNoCorner(cx, cy, cz, off) then continue end
            local tg = cg + off[4]
            local ex = nodes[nk]
            if not ex or tg < ex.g then
                if ex then
                    ex.g, ex.parent, ex.x, ex.y, ex.z = tg, curKey, nx, ny, nz
                else
                    nodes[nk] = { x = nx, y = ny, z = nz, g = tg, parent = curKey }
                end
                _vxPush(heap, tg + _vxHeurW * Heur(nx, ny, nz), nk)
            end
        end
    end
    return nil
end

local function _vxSimplify(path, radius, height)
    if not path or #path < 3 then return path end
    local out = { path[1] }
    local anchor = 1
    local i = 2
    while i <= #path do
        if not _vxSegClear(path[anchor], path[i + 1] or path[i], radius, height, false) then
            out[#out + 1] = path[i]
            anchor = i
        end
        i += 1
    end
    out[#out + 1] = path[#path]
    return out
end

voxelRoute = function(fromPos, toPos)
    local char = LP.Character
    local _flt = char and { char } or {}
    for _, cl in ipairs(_OTHER_CLONES) do _flt[#_flt + 1] = cl end
    _vxOverlap.FilterDescendantsInstances = _flt
    _vxCast.FilterDescendantsInstances = _flt

    local sz      = tonumber(_G.xyr0PathCell)   or 4
    local inflate = tonumber(_G.xyr0PathRadius) or 2.5
    local height  = tonumber(_G.xyr0PathHeight) or 5
    local pad     = tonumber(_G.xyr0PathPad)    or 40

    _vxSz, _vxInflate, _vxHeight = sz, inflate, height
    table.clear(_vxSolid)

    local mn = Vector3.new(_vxMin(fromPos.X, toPos.X), _vxMin(fromPos.Y, toPos.Y), _vxMin(fromPos.Z, toPos.Z)) - Vector3.new(pad, pad, pad)
    local mx = Vector3.new(_vxMax(fromPos.X, toPos.X), _vxMax(fromPos.Y, toPos.Y), _vxMax(fromPos.Z, toPos.Z)) + Vector3.new(pad, pad, pad)
    _vxOrigin = mn
    local size = mx - mn
    _vxDimX = _vxFloor(size.X / sz) + 1
    _vxDimY = _vxFloor(size.Y / sz) + 1
    _vxDimZ = _vxFloor(size.Z / sz) + 1
    if _vxDimX * _vxDimY * _vxDimZ > 200000 then return nil end

    local startCell = {
        x = _vxFloor((fromPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((fromPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((fromPos.Z - _vxOrigin.Z) / sz),
    }
    local goalCell = {
        x = _vxFloor((toPos.X - _vxOrigin.X) / sz),
        y = _vxFloor((toPos.Y - _vxOrigin.Y) / sz),
        z = _vxFloor((toPos.Z - _vxOrigin.Z) / sz),
    }

    local path = _vxAStar(sz, startCell, goalCell, fromPos, toPos)
    if not path then return nil end
    path = _vxSimplify(path, inflate, height)
    if not path or #path == 0 then return nil end

    local route = {}
    for idx = 2, #path do route[#route + 1] = path[idx] end
    if #route == 0 or (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return route
end

end

_G.xyr0VoxelRoute = voxelRoute

local _MAP_CENTER = { minX = -458, maxX = -362, minZ = -40, maxZ = 185 }
local _BYPASS_Z_NORTH, _BYPASS_Z_SOUTH = 205, -95
local _BYPASS_X_WEST,  _BYPASS_X_EAST  = -525, -295

local function _inCenterZone(x, z)
    return x >= _MAP_CENTER.minX and x <= _MAP_CENTER.maxX
       and z >= _MAP_CENTER.minZ and z <= _MAP_CENTER.maxZ
end

local function _segmentCrossesCenter(a, b)
    if _inCenterZone(a.X, a.Z) or _inCenterZone(b.X, b.Z) then return true end
    for i = 1, 10 do
        local t = i / 11
        if _inCenterZone(a.X + (b.X - a.X) * t, a.Z + (b.Z - a.Z) * t) then return true end
    end
    return false
end

local function _findBestCenterDetour(fromPos, toPos, y)
    local candidates = {
        { Vector3.new(fromPos.X, y, _BYPASS_Z_NORTH), Vector3.new(toPos.X, y, _BYPASS_Z_NORTH) },
        { Vector3.new(fromPos.X, y, _BYPASS_Z_SOUTH), Vector3.new(toPos.X, y, _BYPASS_Z_SOUTH) },
        { Vector3.new(_BYPASS_X_WEST, y, fromPos.Z), Vector3.new(_BYPASS_X_WEST, y, toPos.Z) },
        { Vector3.new(_BYPASS_X_EAST, y, fromPos.Z), Vector3.new(_BYPASS_X_EAST, y, toPos.Z) },
    }
    local best, bestLen = nil, math.huge
    for _, pair in ipairs(candidates) do
        local w1, w2 = pair[1], pair[2]
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.xyr0SegmentCrossesCenter = _segmentCrossesCenter
_G.xyr0FindCenterDetour     = _findBestCenterDetour

local function _rowBoxX() return tonumber(_G.xyr0RowBoxX) or 26 end
local function _rowBoxZ() return tonumber(_G.xyr0RowBoxZ) or 30 end
local function _rowLane() return tonumber(_G.xyr0RowLane) or 30 end

local function _nearestBase(p)
    local bi, bd = nil, math.huge
    for i = 1, 8 do
        local b = BASES_LOW[i]
        local d = (p.X - b.X) ^ 2 + (p.Z - b.Z) ^ 2
        if d < bd then bd = d; bi = i end
    end
    if bd > 70 * 70 then return nil end
    return bi
end

local function _segmentHitsOtherBase(a, b, ignA, ignB)
    local hx, hz = _rowBoxX(), _rowBoxZ()
    for i = 0, 24 do
        local t = i / 24
        local px = a.X + (b.X - a.X) * t
        local pz = a.Z + (b.Z - a.Z) * t
        for k = 1, 8 do
            if k ~= ignA and k ~= ignB then
                local bs = BASES_LOW[k]
                if math.abs(px - bs.X) <= hx and math.abs(pz - bs.Z) <= hz then
                    return true
                end
            end
        end
    end
    return false
end

local function _findRowDetour(fromPos, toPos, y)
    local iFrom, iTo = _nearestBase(fromPos), _nearestBase(toPos)
    if not _segmentHitsOtherBase(fromPos, toPos, iFrom, iTo) then return nil end

    local colX = BASES_LOW[iTo or 1].X
    local off  = _rowLane()
    local lanes = {}
    local outer = (colX < COLUMN_SPLIT_X) and (colX - off) or (colX + off)
    lanes[#lanes + 1] = outer
    local inner = (colX < COLUMN_SPLIT_X) and (colX + off) or (colX - off)
    if not _inCenterZone(inner, (fromPos.Z + toPos.Z) * 0.5) then
        lanes[#lanes + 1] = inner
    end

    local best, bestLen = nil, math.huge
    for _, laneX in ipairs(lanes) do
        local w1 = Vector3.new(laneX, y, fromPos.Z)
        local w2 = Vector3.new(laneX, y, toPos.Z)
        if _clearWide(fromPos, w1) and _clearWide(w1, w2) and _clearWide(w2, toPos)
           and not _segmentHitsOtherBase(w1, w2, iFrom, iTo) then
            local len = (fromPos - w1).Magnitude + (w1 - w2).Magnitude + (w2 - toPos).Magnitude
            if len < bestLen then bestLen = len; best = { w1, w2 } end
        end
    end
    return best
end
_G.xyr0FindRowDetour = _findRowDetour

local _hopRP = RaycastParams.new()
_hopRP.FilterType = Enum.RaycastFilterType.Exclude

local function _partTopY(inst)
    local ok, t = pcall(function()
        local cf, sz = inst.CFrame, inst.Size
        local half = (math.abs(cf.RightVector.Y) * sz.X
            + math.abs(cf.UpVector.Y) * sz.Y
            + math.abs(cf.LookVector.Y) * sz.Z) / 2
        return cf.Position.Y + half
    end)
    if ok and t then return t end
    return inst.Position.Y + (inst.Size.Y / 2)
end

local function _hopBlockerTop(a, b)
    local ignore = { LP.Character }
    for _, cl in ipairs(_OTHER_CLONES) do ignore[#ignore + 1] = cl end
    local top = nil
    for _ = 1, 10 do
        _hopRP.FilterDescendantsInstances = ignore
        local r = workspace:Raycast(a, b - a, _hopRP)
        if not r then break end
        if _blocks(r.Instance) then
            local t = _partTopY(r.Instance)
            if not top or t > top then top = t end
        end
        ignore[#ignore + 1] = r.Instance
    end
    return top
end

local function _hopRoute(fromPos, toPos)
    local flat = Vector3.new(toPos.X - fromPos.X, 0, toPos.Z - fromPos.Z)
    local dist = flat.Magnitude
    if dist < 8 then return nil end
    local dir = flat.Unit
    local step = tonumber(_G.xyr0HopStep) or 8
    local clear = tonumber(_G.xyr0HopClear) or 4
    local maxUp = tonumber(_G.xyr0HopMaxUp) or 22
    local groundY = fromPos.Y
    local route = {}
    local inHop, hopY, hopStart = false, nil, nil
    local i = step
    while i <= dist do
        local a = fromPos + dir * (i - step)
        local b = fromPos + dir * math.min(i, dist)
        local ga = Vector3.new(a.X, groundY, a.Z)
        local gb = Vector3.new(b.X, groundY, b.Z)
        if not _clear(ga, gb) then
            local top = _hopBlockerTop(ga, gb) or (groundY + 6)
            local want = top + clear
            if want - groundY > maxUp then return nil end
            if not inHop then
                inHop, hopY, hopStart = true, want, ga
                route[#route + 1] = Vector3.new(a.X, want, a.Z)
            elseif want > hopY then
                hopY = want
                route[#route + 1] = Vector3.new(a.X, want, a.Z)
            end
        elseif inHop then
            inHop = false
            route[#route + 1] = Vector3.new(b.X, hopY, b.Z)
            route[#route + 1] = gb
        end
        i = i + step
    end
    if inHop then
        route[#route + 1] = Vector3.new(toPos.X, hopY, toPos.Z)
    end
    route[#route + 1] = toPos
    return route
end
_G.xyr0HopRoute = _hopRoute

function computeRoute(fromPos, toPos, facingDir, maxLift, preferCrest)
    local _ = maxLift

    if _G.xyr0HopFirst == true and not _clearWide(fromPos, toPos) then
        local hop = _hopRoute(fromPos, toPos)
        if hop and #hop > 0 then return hop end
    end

    if _G.xyr0CrestFirst == true and not _clearWide(fromPos, toPos) then
        local baseY = math.max(fromPos.Y, toPos.Y, 26)
        local lifts = { tonumber(_G.xyr0CrestLift) or 12, 20, 30, 44, 60 }
        for _, lift in ipairs(lifts) do
            local cruiseY = baseY + lift
            local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
            local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
            local crest = { fromPos, up, over, toPos }
            local ok = true
            for i = 1, #crest - 1 do
                local a, b = crest[i], crest[i + 1]
                if (a - b).Magnitude > 0.5 then
                    if not _crestClear(a, b) then ok = false; break end
                end
            end
            if ok then return crest end
        end
    end

    local centerPatch = nil
    if _segmentCrossesCenter(fromPos, toPos) and not _clearWide(fromPos, toPos) then
        centerPatch = _findBestCenterDetour(fromPos, toPos, fromPos.Y)
        if centerPatch and #centerPatch > 0 then
            fromPos = centerPatch[#centerPatch]
        end
    end
    local rowPatch = _findRowDetour(fromPos, toPos, fromPos.Y)
    if rowPatch and #rowPatch > 0 then
        fromPos = rowPatch[#rowPatch]
    end

    local function _withPatch(route)
        if (not centerPatch or #centerPatch == 0)
           and (not rowPatch or #rowPatch == 0) then return route end
        local merged = {}
        if centerPatch then for _, p in ipairs(centerPatch) do merged[#merged + 1] = p end end
        if rowPatch    then for _, p in ipairs(rowPatch)    do merged[#merged + 1] = p end end
        for _, p in ipairs(route) do merged[#merged + 1] = p end
        return merged
    end

    if _clearWide(fromPos, toPos) then return _withPatch({ toPos }) end

    if preferCrest then
        local cruiseY = math.max(fromPos.Y, toPos.Y, 26) + 12
        local up   = Vector3.new(fromPos.X, cruiseY, fromPos.Z)
        local over = Vector3.new(toPos.X,   cruiseY, toPos.Z)
        local crest = { fromPos, up, over, toPos }
        local ok = true
        for i = 1, #crest - 1 do
            local a, b = crest[i], crest[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == #crest - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then ok = false; break end
            end
        end
        if ok then return _withPatch(crest) end
    end

    do
        local vr = voxelRoute(fromPos, toPos)
        if vr and #vr > 0 then return _withPatch(vr) end
    end

    local entry = facingDir and (toPos - facingDir * 14) or toPos

    local best, bestLen = nil, math.huge
    local function consider(pts)
        if not pts or #pts < 2 then return end
        local n = #pts
        for i = 1, n - 1 do
            local a, b = pts[i], pts[i + 1]
            if (a - b).Magnitude > 0.5 then
                local sA = (i == 1) and _ENDPOINT_SLACK or 0
                local sB = (i == n - 1) and _ENDPOINT_SLACK or 0
                if not _clearWide(a, b, sA, sB) then return end
            end
        end
        local pulled = _pullWide(pts)
        local L = _len(pulled)
        if L < bestLen then best, bestLen = pulled, L end
    end

    do
        local dirF = Vector3.new(entry.X - fromPos.X, 0, entry.Z - fromPos.Z)
        if dirF.Magnitude > 0.1 then
            dirF = dirF.Unit
            local perp = Vector3.new(-dirF.Z, 0, dirF.X)
            local midBase = (fromPos + entry) * 0.5
            for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
                consider({ fromPos, midBase + perp * off, entry })
                consider({ fromPos, fromPos + perp * off, entry + perp * off, entry })
            end
        end
    end

    local navRaw
    if not best then
        local groundTo = Vector3.new(entry.X, fromPos.Y, entry.Z)
        local path = PathfindingService:CreatePath({
            AgentRadius = 16, AgentHeight = 5, AgentCanJump = true, AgentJumpHeight = 10, AgentMaxSlope = 89,
        })
        local FLOAT = 5
        local nav = { fromPos }
        local ok = pcall(function()
            path:ComputeAsync(Vector3.new(fromPos.X, fromPos.Y, fromPos.Z), groundTo)
        end)
        if ok and path.Status == Enum.PathStatus.Success then
            local last = fromPos
            for _, wp in ipairs(path:GetWaypoints()) do
                if (wp.Position - last).Magnitude >= 8 then
                    nav[#nav + 1] = wp.Position + Vector3.new(0, FLOAT, 0)
                    last = wp.Position
                end
            end
        end
        nav[#nav + 1] = entry + Vector3.new(0, FLOAT, 0)
        nav = _pushOffWalls(nav)
        navRaw = nav
        consider(nav)
    end

    local route = best
    if not route and _clear(fromPos, toPos) then route = { toPos } end
    if not route and navRaw then route = _pullWide(navRaw) end
    if not route then route = { toPos } end
    if (route[#route] - toPos).Magnitude > 0.5 then
        route[#route + 1] = toPos
    end
    return _withPatch(route)
end
end

function equipTool(name)
    local char = LP.Character
    if not char or char:FindFirstChild(name) then return char ~= nil end
    local bp = LP:FindFirstChild("Backpack")
    if not bp then return false end
    local tool = bp:FindFirstChild(name)
    if tool and tool:IsA("Tool") then tool.Parent = char; return true end
    return false
end

function unequipAll()
    local char, bp = LP.Character, LP.Backpack
    if not char or not bp then return end
    for _, t in pairs(char:GetChildren()) do
        if t:IsA("Tool") then t.Parent = bp end
    end
end

function doClone()
    local char = LP.Character or LP.CharacterAdded:Wait()
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum then return false end

    local cloner = (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Quantum Cloner"))
                or char:FindFirstChild("Quantum Cloner")
    if not cloner then return false end

    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    pcall(function() hum:UnequipTools() end)
    task.wait()
    if cloner.Parent ~= char then
        pcall(function() hum:EquipTool(cloner) end)
        task.wait()
    end

    local pg = LP:FindFirstChild("PlayerGui")
    local tf = pg and pg:FindFirstChild("ToolsFrames")
    local qc = tf and tf:FindFirstChild("QuantumCloner")
    local tb = qc and qc:FindFirstChild("TeleportToClone")

    _G.isCloning = true
    pcall(function() cloner:Activate() end)
    task.wait(0.05)

    local fired = false
    if tb then
        tb.Visible = true
        pcall(function() firesignal(tb.MouseButton1Click) end)
        pcall(function() firesignal(tb.MouseButton1Up) end)
        pcall(function() firesignal(tb.Activated) end)
        fired = true
    end

    task.delay(0.55, function() _G.isCloning = false end)
    return fired
end

_TweenTS = game:GetService("TweenService")
function xyr0Tween(rootPart, hum, targetPos, lookDir)
    if not rootPart or not rootPart.Parent then return end
    local STEP = 20
    local speed = (_G.TPTravelSpeed or 100)
    local hasLook = lookDir ~= nil and lookDir.Magnitude > 0.001
    local prevAnchored = rootPart.Anchored
    _vzL(rootPart)
    _vzA(rootPart)
    pcall(function() rootPart.Anchored = true end)
    local deadline = os.clock() + 12
    while rootPart and rootPart.Parent and os.clock() < deadline do
        local pos = rootPart.Position
        local toTarget = targetPos - pos
        local d = toTarget.Magnitude
        if d < 0.5 then break end
        local stepDist = math.min(STEP, d)
        local stepGoal = pos + toTarget.Unit * stepDist
        local stepCF
        if hasLook then
            stepCF = CFrame.lookAt(stepGoal, stepGoal + lookDir)
        else
            stepCF = (rootPart.CFrame - rootPart.CFrame.Position) + stepGoal
        end
        local dur = math.clamp(stepDist / speed, 0.02, 1)
        local tw = _TweenTS:Create(rootPart, TweenInfo.new(dur, Enum.EasingStyle.Linear), { CFrame = stepCF })
        tw:Play()
        tw.Completed:Wait()
    end
    pcall(function() rootPart.Anchored = prevAnchored end)
    if rootPart and rootPart.Parent then _vzL(rootPart) end
end

function _makeOneWay(plat)
    if not plat then return end
    local rsConn
    local lastY = nil
    rsConn = RunService.Stepped:Connect(function()
        if not plat or not plat.Parent then
            if rsConn then rsConn:Disconnect() end
            return
        end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local currentY = hrp.Position.Y
            if not lastY then lastY = currentY end
            local deltaY = currentY - lastY
            local isMovingUp = (hrp.AssemblyLinearVelocity.Y > 1) or (deltaY > 0.01 and deltaY < 5)
            if isMovingUp then
                plat.CanCollide = false
            else
                plat.CanCollide = (currentY > plat.Position.Y + 0.1)
            end
            lastY = currentY
        end
    end)
end

function goToBrainrot(petPos, slot)
    if not petPos then return end
    local char, hrp, hum
    local _t0 = os.clock()
    repeat
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then break end
        RunService.Heartbeat:Wait()
    until os.clock() - _t0 > 3
    if not hrp or not hum then return end
    pcall(function() hrp.Anchored = false end)
    local _equipped = false
    do
        local _e0 = os.clock()
        repeat
            char = LP.Character
            for _, _cn in ipairs(CARPET_NAMES) do
                if char and char:FindFirstChild(_cn) then _equipped = true; break end
            end
            if _equipped then break end
            equipCarpet()
            RunService.Heartbeat:Wait()
        until _equipped or os.clock() - _e0 > (tonumber(_G.xyr0GoCarpetWait) or 1.5)
        if _equipped then task.wait(tonumber(_G.xyr0GoCarpetSettle) or 0.03) end
    end
    char = LP.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp then return end
    pcall(function() hrp.Anchored = false end)
    local _plotRad = (petPos.Y <= 8.9) and 26 or 25
    do
        local _t0b = os.clock()
        repeat
            local p = hrp.Position
            local inRad = false
            local plotsFolder = workspace:FindFirstChild("Plots")
            if plotsFolder then
                for _, plot in ipairs(plotsFolder:GetChildren()) do
                    pcall(function()
                        local pp = plot:GetPivot().Position
                        if math.abs(p.X - pp.X) < _plotRad and math.abs(p.Z - pp.Z) < _plotRad then inRad = true end
                    end)
                    if inRad then break end
                end
            end
            if inRad then break end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0b > (tonumber(_G.xyr0GoPlotWait) or 0.4)
    end
    local h = petPos.Y
    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)
    local _wentUnder = false
    local _slot = tonumber(slot)
    local _under = tonumber(_G.xyr0UnderOffset) or 6
    local targetY = hrp.Position.Y
    if (_slot and _slot >= 19) or (not _slot and h > 23.15) then
        targetY = h - (tonumber(_G.xyr0UnderOffset3) or 4)
        _wentUnder = true
    elseif (_slot and _slot >= 11) or (not _slot and h >= 11 and h <= 23.15) then
        targetY = h - _under
        _wentUnder = true
    elseif (_slot and _slot >= 1) or (not _slot and h >= -6.9 and h <= 8.9) then
        targetY = tonumber(_G.xyr0Floor1Y) or -4
        if _G.xyr0Floor1Platform ~= false then _wentUnder = true end
    else
        targetY = h - _under
        _wentUnder = true
    end
    local _to = Vector3.new(petPos.X, targetY, petPos.Z)
    if hrp and hrp.Parent then
        -- Keep whatever direction we were already facing after cloning in;
        -- only move the position. (CFrame.new(_to) alone would reset the
        -- rotation and snap us to face the plot/brainrot.)
        do
            local _s1 = tonumber(_G.xyr0GoGlideSpeed1) or 150
            local _t1 = tonumber(_G.xyr0GoGlideTime1) or 0.03
            local _s2 = tonumber(_G.xyr0GoGlideSpeed2) or 400
            local _cap = tonumber(_G.xyr0GoGlideMax) or 2.5
            local _g0 = os.clock()
            while os.clock() - _g0 < _cap do
                if not (hrp and hrp.Parent) then break end
                if LP:GetAttribute("Stealing") or _G.xyr0TPStop then break end
                local d = _to - hrp.Position
                if d.Magnitude <= 3 then break end
                equipCarpet()
                if _G.xyr0GoJump == true then
                    local _gh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    if _gh then
                        pcall(function() _gh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _gh.Jump = true end)
                    end
                end
                if _G.xyr0GoZeroEachFrame ~= false then
                    pcall(function()
                        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end)
                end
                local _v = d.Unit * (((os.clock() - _g0) < _t1) and _s1 or _s2)
                if _G.xyr0GoNoRise ~= false and hrp.Position.Y >= _to.Y - 0.5 and _v.Y > 0 then
                    _v = Vector3.new(_v.X, 0, _v.Z)
                end
                _setFlightVel(hrp, _v)
                RunService.Heartbeat:Wait()
            end
        end
        if _G.xyr0GoJump == true then
            local _gh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
            if _gh then
                pcall(function() _gh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                pcall(function() _gh.Jump = true end)
            end
        end
        local _snapCF = CFrame.new(_to) * (hrp.CFrame - hrp.CFrame.Position)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            hrp.CFrame = _snapCF
        end)
        -- Hold it for a few frames: a single write can be undone by the
        -- humanoid's own physics step or a server correction landing in the
        -- same tick, which would drop us back where we came from.
        for _ = 1, (tonumber(_G.xyr0SnapHoldFrames) or 8) do
            RunService.Heartbeat:Wait()
            if not (hrp and hrp.Parent) then break end
            if (hrp.Position - _to).Magnitude > 4 then
                pcall(function()
                    hrp.CFrame = _snapCF
                end)
                if _G.xyr0GoJump == true then
                    local _gh = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                    if _gh then
                        pcall(function() _gh:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _gh.Jump = true end)
                    end
                end
            end
        end
    end
    if _wentUnder and _G.xyr0Platform ~= false then
        local _platPos = (hrp and hrp.Parent and hrp.Position) or _to
        local _feetY = _platPos.Y - 3
        local _sz = tonumber(_G.xyr0PlatSize) or 10
        -- was named "ANGVELSTempPlatform" and found again by that name; both the
        -- name and the name-lookup are visible to the game. Track it by reference.
        local _old = _G.__xyr0Plat
        if _old and _old.Parent then pcall(function() _old:Destroy() end) end
        local _plat = Instance.new("Part")
        _G.__xyr0Plat = _plat
        _plat.Size = Vector3.new(_sz, 1, _sz)
        _plat.Position = Vector3.new(petPos.X, _feetY - (tonumber(_G.xyr0PlatDrop) or 1.5), petPos.Z)
        _plat.Anchored = true; _plat.CanCollide = false; pcall(_makeOneWay, _plat); _plat.Transparency = 1
        _plat.Material = Enum.Material.SmoothPlastic; _plat.Parent = workspace
        task.spawn(function()
            local _s = tick()
            while tick() - _s < (tonumber(_G.xyr0PlatLife) or 20) do
                if LP:GetAttribute("Stealing") then break end
                task.wait(0.1)
            end
            if _plat and _plat.Parent then _plat:Destroy() end
        end)
    end
end

_Stats = game:GetService("Stats")
function _pingMs()
    local ok, p = pcall(function() return LP:GetNetworkPing() * 1000 end)
    if ok and type(p) == "number" and p > 0 then return p end
    local ok2, p2 = pcall(function()
        return _Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    if ok2 and type(p2) == "number" and p2 > 0 then return p2 end
    return 0
end
_G.xyr0PingMs = _pingMs
function _pingAdjustSpeed(spd)
    local thresh = tonumber(_G.xyr0PingThresh) or 170
    local capped = tonumber(_G.xyr0HighPingSpeed) or 400
    if _pingMs() >= thresh and spd > capped then return capped end
    return spd
end

function _inVoid(hrp)
    if not hrp or not hrp.Parent then return true end
    local voidY = tonumber(_G.xyr0VoidY) or -50
    return hrp.Position.Y < voidY
end
function _waitOutOfVoid(timeout)
    local t0 = os.clock()
    local good = 0
    while os.clock() - t0 < (timeout or 12) do
        if _G.xyr0TPStop then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and hrp.Parent and not _inVoid(hrp) and math.abs(hrp.AssemblyLinearVelocity.Y) < 12 then
            good += 1
            if good >= 4 then return true end
        else
            good = 0
        end
        RunService.Heartbeat:Wait()
    end
    return false
end

do
    local lastSafe = nil
    local recovering = false
    RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if _G.xyr0VoidRecover == false then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hrp.Parent then return end
        local voidY = tonumber(_G.xyr0VoidY) or -50
        if hrp.Position.Y >= voidY then
            if math.abs(hrp.AssemblyLinearVelocity.Y) < 40 then
                lastSafe = hrp.Position
            end
            return
        end
        if recovering or not lastSafe then return end
        recovering = true

        pcall(function()
            _vzL(hrp)
            _vzA(hrp)
            hrp.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
        end)
        task.spawn(function()
            local delay = tonumber(_G.xyr0VoidRecoverDelay) or 0
            if delay > 0 then task.wait(delay) end
            local vy = tonumber(_G.xyr0VoidY) or -50
            local tries = 0
            while tries < 80 do
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if not h or not h.Parent then break end
                if h.Position.Y >= vy and math.abs(h.AssemblyLinearVelocity.Y) < 18 then
                    break
                end
                if lastSafe then
                    pcall(function()
                        _vzL(h)
                        _vzA(h)
                        h.CFrame = CFrame.new(lastSafe + Vector3.new(0, 5, 0))
                    end)
                end
                tries = tries + 1
                RunService.Heartbeat:Wait()
            end
            recovering = false
        end)
    end))
end

isTeleporting = false

task.spawn(function()
    local _since = nil
    while true do
        task.wait(1)
        if isTeleporting then
            _since = _since or os.clock()
            if os.clock() - _since > (tonumber(_G.xyr0TPWatchdog) or 25) then
                isTeleporting = false
                _G.xyr0StealHold = false
                _since = nil
                if _G.xyr0TPDebug ~= false then
                    warn("[xyr0TP] watchdog: isTeleporting was stuck -> cleared")
                end
            end
        else
            _since = nil
        end
    end
end)

_G.xyr0DoClone = doClone
_G.xyr0IsTeleporting = function() return isTeleporting end

function cframeStepThrough(hrp, waypoints, stepSize)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    stepSize = stepSize or 24
    local lockY = hrp.Position.Y
    vizPath(hrp.Position, waypoints)
    local wpIdx = 1
    local deadline = os.clock() + 10
    local _lastFire = 0
    while hrp and hrp.Parent and os.clock() < deadline do
        if _G.xyr0TPStop then break end
        do
            local char = hrp.Parent
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and char and not char:FindFirstChild("Grapple Hook") then
                local g = findGrapple()
                if g then pcall(function() hum:EquipTool(g) end) end
            end
            if os.clock() - _lastFire > 0.3 then
                _lastFire = os.clock()
                if char and char:FindFirstChild("Grapple Hook") then
                    -- Elite-method fire can yield (cooldown gate / equip wait);
                    -- spawn it so the 24-stud step cadence stays on Heartbeat
                    task.spawn(_fireGrapple)
                end
            end
        end
        local target = waypoints[wpIdx]
        local flat = Vector3.new(target.X - hrp.Position.X, 0, target.Z - hrp.Position.Z)
        local mag = flat.Magnitude
        if mag < 2 then
            wpIdx = wpIdx + 1
            if wpIdx > #waypoints then break end
            RunService.Heartbeat:Wait()
        else
            local hop = math.min(stepSize, mag)
            local nextPos = hrp.Position + flat.Unit * hop
            local _, y = hrp.CFrame:ToEulerAnglesYXZ()
            hrp.CFrame = CFrame.new(Vector3.new(nextPos.X, lockY, nextPos.Z)) * CFrame.Angles(0, y, 0)
            _vzL(hrp)
            _vzA(hrp)
            task.wait(hop / math.clamp(tonumber(_G.xyr0CFrameSpeed) or 450, 60, 900))
        end
    end
    do
        local hum = hrp and hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:UnequipTools() end) end
        task.wait(0.05)
        equipCarpet()
    end
    if hrp and hrp.Parent then
        _vzL(hrp)
        _vzA(hrp)
    end
end

function _isStraightRoute(fromPos, route)
    if not route or #route <= 1 then return true end
    local turns, lastDir, prev = 0, nil, fromPos
    for _, wp in ipairs(route) do
        local seg = wp - prev
        if seg.Magnitude > 1 then
            local dir = seg.Unit
            if lastDir and dir:Dot(lastDir) < 0.94 then turns = turns + 1 end
            lastDir = dir
        end
        prev = wp
    end
    return turns <= (tonumber(_G.xyr0StraightMaxTurns) or 1)
end

function doVelocityTP(forceGrapple)
    if isTeleporting then return end
    if LP:GetAttribute("Stealing") == true then return end
    isTeleporting = true
    if _G.xyr0DisarmSteal then _G.xyr0DisarmSteal() end
    _G.xyr0TPStop = false
    clearViz()
    if not NetModule then pcall(loadNet) end

    local char = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then isTeleporting = false; return end

    pcall(function()
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end)

    if _inVoid(hrp) or hrp.AssemblyLinearVelocity.Y < -40 then
        _waitOutOfVoid(12)
        if _G.xyr0TPStop then isTeleporting = false; return end
        char = LP.Character
        hrp = char and char:FindFirstChild("HumanoidRootPart")
        hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then isTeleporting = false; return end
    end

    local allPets = scanForTP()
    if #allPets == 0 then
        local _t0 = os.clock()
        while #allPets == 0 and os.clock() - _t0 < (tonumber(_G.xyr0TPScanWait) or 10) do
            task.wait(0.05)
            allPets = scanForTP()
        end
    end
    if #allPets == 0 then isTeleporting = false; return end

    if not (type(_G.xyr0StealTargetUID) == "string" and _G.xyr0StealTargetUID ~= "") then
        local pool, seen = {}, {}
        local function _absorb(list)
            if type(list) ~= "table" then return end
            for _, p in ipairs(list) do
                if not p.conveyor and p.plot and p.slot ~= nil then
                    local uid = tostring(p.plot) .. "_" .. tostring(p.slot)
                    local ex = seen[uid]
                    if not ex then
                        seen[uid] = p
                        pool[#pool + 1] = p
                    elseif (p.mps or 0) > (ex.mps or 0) then
                        for i = 1, #pool do
                            if pool[i] == ex then pool[i] = p break end
                        end
                        seen[uid] = p
                    end
                end
            end
        end
        _absorb(allPets)
        for _ = 1, (tonumber(_G.xyr0TPScans) or 2) do
            task.wait(tonumber(_G.xyr0TPScanGap) or 0.05)
            local _ok, _more = pcall(scanForTP)
            if _ok then _absorb(_more) end
        end
        if #pool > 0 then allPets = pool end
    end

    local pet
    if type(_G.xyr0StealTargetUID) == "string" and _G.xyr0StealTargetUID ~= "" then
        pet = _findStealTarget(allPets)
        if not pet then isTeleporting = false; return end
    else
        local prio, best
        for _, p in ipairs(allPets) do
            if not p.conveyor then
                if p._pri and (not prio or p._pri < prio._pri) then prio = p end
                if not best or (p.mps or 0) > (best.mps or 0) then best = p end
            end
        end
        pet = prio or best or allPets[1]
    end
    local petPos = pet.position
    local petName = pet.name
    if _G.xyr0ArmSteal then pcall(_G.xyr0ArmSteal, pet) end
    _G.xyr0StealSay(string.format("TP start -> %s [%s/%s] mps=%s pri=%s of %d", tostring(pet and pet.name), tostring(pet and pet.plot), tostring(pet and pet.slot), tostring(pet and pet.mps), tostring(pet and pet._pri), #allPets))

    _G.xyr0StealHold = true

    pcall(fireGrapple)

    local adjY = petPos.Y
    if TALL_PETS[petName] then adjY = petPos.Y - TALL_OFFSET end
    local coordTable = adjY > 23.15 and MK_UPPER or MK_LOWER

    if petPos.Y <= 8.9 and isPlotUnlocked(pet.plot) then
        carpetEngage(forceGrapple)
        vZero(hrp)
        local _to = Vector3.new(petPos.X, -4, petPos.Z)
        local route = computeRoute(hrp.Position, _to, nil)
        if not route or #route == 0 then route = { _to } end
        local _straight = _isStraightRoute(hrp.Position, route)
        local _obSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
        if _straight then
            _obSpeed = math.clamp(tonumber(_G.xyr0StraightSpeed) or 300, 100, 500)
        end
        do
            local _len, _prev = 0, hrp.Position
            for _, wp in ipairs(route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
            if _len < 100 then
                _obSpeed = math.clamp(tonumber(_G.xyr0CloseSpeed) or 80, 20, 400)
            end
        end
        _obSpeed = _pingAdjustSpeed(_obSpeed)
        velMoveThrough(hrp, route, _obSpeed, true, true)
        if hrp and hrp.Parent then
            _vzL(hrp)
            _vzA(hrp)
        end
        _G.xyr0StealHold = false
        isTeleporting = false
        if _G.xyr0TPStop then return end
        return
    end

    local closestData, skyKey = findClosest(petPos, coordTable)
    if not closestData or not skyKey then _G.xyr0StealHold = false; isTeleporting = false; return end

    local destPos = closestData.coord

    local _carpet = carpetEngage(forceGrapple)
    vZero(hrp)

    local facingDir = closestData.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)

    local _frontApproach = false
    do
        local isUpper = (coordTable == MK_UPPER)
        local idx = getClosestBaseIdx(petPos)
        local frontCoord, frontFace = buildFrontCandidate(idx, isUpper, hrp.Position.Z)
        local bestCoord, bestFace = frontCoord, frontFace
        local bestDist = (hrp.Position - frontCoord).Magnitude
        local pickedFront = true

        -- 1st floor (MK_LOWER) approaches from the side only.
        -- The front candidate is still built and left in bestCoord as a
        -- fallback: plotSides() can legitimately return nothing for a plot,
        -- and without it there would be no destination at all.
        local _sideOnly = (not isUpper) and (_G.xyr0FirstFloorSideOnly ~= false)

        local _tb = BASES_LOW[idx]
        local _isWest = idx <= 4
        local _rowBlocked = false
        local _dx, _dz = hrp.Position.X - _tb.X, hrp.Position.Z - _tb.Z
        local _distToBase = math.sqrt(_dx * _dx + _dz * _dz)
        local _sideRange = tonumber(_G.xyr0SideTPRange) or 100
        -- _rowBlocked forces the front approach, so it must not run in side-only mode
        if not _sideOnly and _G.xyr0PreferFrontOnRow ~= false and _distToBase > _sideRange then
            for i = 1, 8 do
                if i ~= idx and (i <= 4) == _isWest then
                    local bz = BASES_LOW[i].Z
                    if (bz - hrp.Position.Z) * (bz - _tb.Z) < 0 then _rowBlocked = true; break end
                end
            end
        end

        -- drop the front's distance so the nearest side always wins the compare
        if _sideOnly then bestDist = math.huge end

        if not _rowBlocked then
            for _, d in ipairs(plotSides(coordTable, idx)) do
                local dd = (hrp.Position - d.coord).Magnitude
                if dd < bestDist then
                    bestDist = dd
                    bestCoord = d.coord
                    bestFace = d.facing == "NORTH" and Vector3.new(0, 0, -1) or Vector3.new(0, 0, 1)
                    pickedFront = false
                end
            end
        end
        destPos = bestCoord
        facingDir = bestFace
        _frontApproach = pickedFront
        if _G.xyr0TPDebug ~= false then
            local _mode = pickedFront and "FRONT" or "SIDE"
            if _sideOnly then
                -- pickedFront still true here means no side coord existed
                _mode = pickedFront and "FRONT(sideonly-fallback)" or "SIDE(sideonly)"
            end
            warn(string.format(
                "[xyr0TP] PICK baseIdx=%d %s floor=%s | pet=(%.0f,%.0f,%.0f) plot=%s | dest=(%.0f,%.0f,%.0f) | me=(%.0f,%.0f,%.0f) | sides=%d",
                idx, _mode, isUpper and "2nd" or "1st",
                petPos.X, petPos.Y, petPos.Z, tostring(pet.plot),
                destPos.X, destPos.Y, destPos.Z,
                hrp.Position.X, hrp.Position.Y, hrp.Position.Z,
                #plotSides(coordTable, idx)))
        end
    end

    if facingDir and facingDir.Magnitude > 0.1 then
        local axis = facingDir.Unit
        local toPlayer = hrp.Position - destPos
        local sign = (axis:Dot(toPlayer) >= 0) and 1 or -1
        destPos = destPos + axis * sign * (tonumber(_G.xyr0CloneBackoff) or 0.5)
    end

    local _route = computeRoute(hrp.Position, destPos, facingDir, nil, true)

    local ASCEND_STEP = 10
    local _stepped = {}
    do
        local prev = hrp.Position
        for _, wp in ipairs(_route) do
            local dy = wp.Y - prev.Y
            if dy > ASCEND_STEP * 1.5 then
                local n = math.ceil(dy / ASCEND_STEP)
                for s = 1, n - 1 do
                    local t = s / n
                    _stepped[#_stepped + 1] = Vector3.new(
                        prev.X + (wp.X - prev.X) * t,
                        prev.Y + dy * t,
                        prev.Z + (wp.Z - prev.Z) * t
                    )
                end
            end
            _stepped[#_stepped + 1] = wp
            prev = wp
        end
    end
    local _mainSpeed = math.clamp(tonumber(_G.TPVelocity) or 400, 200, 750)
    do
        local _len, _prev = 0, hrp.Position
        for _, wp in ipairs(_route) do _len = _len + (wp - _prev).Magnitude; _prev = wp end
        if _len < 100 then
            _mainSpeed = math.clamp(tonumber(_G.xyr0CloseSpeed) or 80, 20, 400)
        end
    end
    _mainSpeed = _pingAdjustSpeed(_mainSpeed)
    velMoveThrough(hrp, _stepped, _mainSpeed, true, true)
    if _G.xyr0TPStop then
        if hrp and hrp.Parent then vZero(hrp) end
        _G.xyr0StealHold = false
        isTeleporting = false
        return
    end

    do
        local above = destPos + Vector3.new(0, 16, 0)
        local _t0 = os.clock()
        while os.clock() - _t0 < 1.5 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.xyr0TPStop then break end
            equipCarpet()
            local d = above - hrp.Position
            local flat = Vector3.new(d.X, 0, d.Z).Magnitude
            if flat <= 3 and hrp.Position.Y >= destPos.Y then break end
            if d.Y > 3 then
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _hum then
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                    end
                end
            end
            _setFlightVel(hrp, d.Unit * math.min(math.max(d.Magnitude * 8, 55), 320))
            _vzA(hrp)
            RunService.Heartbeat:Wait()
        end
    end

    do
        local _runCap = _frontApproach and (tonumber(_G.xyr0FrontRunIn) or 120) or 320
        if _G.xyr0TPSafeMode ~= false then
            _runCap = math.min(_runCap, tonumber(_G.xyr0TPSafeSpeed) or 300)
        end
        local _t0 = os.clock()
        local _bestMag, _bestT = math.huge, os.clock()
        while os.clock() - _t0 < 4 do
            if not hrp or not hrp.Parent then break end
            if LP:GetAttribute("Stealing") or _G.xyr0TPStop then break end
            equipCarpet()
            local diff = destPos - hrp.Position
            local mag = diff.Magnitude
            if mag <= 3 then break end
            if mag < _bestMag - 0.5 then _bestMag = mag; _bestT = os.clock()
            elseif os.clock() - _bestT > 0.6 then break end
            if diff.Y > 3 then
                local _hum = hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
                if _hum then
                    local st = _hum:GetState()
                    if st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall then
                        pcall(function() _hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
                        pcall(function() _hum.Jump = true end)
                    end
                end
            end
            _setFlightVel(hrp, diff.Unit * math.min(math.max(mag * 8, 55), _runCap))
            _vzA(hrp)
            RunService.Heartbeat:Wait()
        end
    end

    if hrp and hrp.Parent and not _G.xyr0TPStop then
        local _tol = tonumber(_G.xyr0TPReachTolerance) or 4.5
        local _retryMax = math.clamp(tonumber(_G.xyr0TPRetryCount) or 2, 0, 4)
        for _retry = 1, _retryMax do
            if not (hrp and hrp.Parent) or _G.xyr0TPStop then break end
            local _flatOff = Vector3.new(destPos.X - hrp.Position.X, 0, destPos.Z - hrp.Position.Z).Magnitude
            local _yOff = math.abs(destPos.Y - hrp.Position.Y)
            if _flatOff <= _tol and _yOff <= 6 then break end
            if _G.xyr0TPDebug ~= false then
                warn(string.format("[xyr0TP] REACH retry %d/%d: flat=%.1f y=%.1f -> fresh route", _retry, _retryMax, _flatOff, _yOff))
            end
            task.wait(tonumber(_G.xyr0TPRetryDelay) or 0.08)
            local _fresh = computeRoute(hrp.Position, destPos, facingDir, nil, true)
            if not _fresh or #_fresh == 0 then _fresh = { destPos } end
            local _freshStepped = {}
            local _prev = hrp.Position
            for _, _wp in ipairs(_fresh) do
                local _dy = _wp.Y - _prev.Y
                if _dy > 15 then
                    local _n = math.ceil(_dy / 10)
                    for _s = 1, _n - 1 do
                        local _t = _s / _n
                        _freshStepped[#_freshStepped + 1] = Vector3.new(
                            _prev.X + (_wp.X - _prev.X) * _t,
                            _prev.Y + _dy * _t,
                            _prev.Z + (_wp.Z - _prev.Z) * _t)
                    end
                end
                _freshStepped[#_freshStepped + 1] = _wp
                _prev = _wp
            end
            local _retrySpeed = _mainSpeed
            if _G.xyr0TPSafeMode ~= false then
                _retrySpeed = math.min(_retrySpeed, tonumber(_G.xyr0TPSafeSpeed) or 300)
            end
            velMoveThrough(hrp, _freshStepped, _retrySpeed, true, true)
            if hrp and hrp.Parent then
                _vzL(hrp); _vzA(hrp)
            end
        end
    end

    if hrp and hrp.Parent then
        hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + facingDir)
    end
    vZero(hrp)

    local syncFrames = (_G.xyr0TPSafeMode ~= false) and 8 or 5
    local syncConn
    syncConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
        if not hrp or not hrp.Parent then syncConn:Disconnect(); return end
        syncFrames = syncFrames - 1
        hrp.CFrame = CFrame.new(destPos, destPos + facingDir)
        _vzL(hrp)
        _vzA(hrp)
        if syncFrames <= 0 then syncConn:Disconnect() end
    end))

    for _ = 1, 20 do
        task.wait(0.05)
        if hum.FloorMaterial ~= Enum.Material.Air then break end
    end

    do
        local stable, _st0 = 0, os.clock()
        while os.clock() - _st0 < 3 do
            if _G.xyr0TPStop then break end
            local _hrp = char and char:FindFirstChild("HumanoidRootPart")
            if not _hrp or not _hrp.Parent then break end
            local flat = (Vector3.new(_hrp.Position.X, 0, _hrp.Position.Z) - Vector3.new(destPos.X, 0, destPos.Z)).Magnitude
            if flat <= 3.5 and math.abs(_hrp.Position.Y - destPos.Y) <= 4 then
                stable = stable + 1
                if stable >= 4 then break end
            else
                stable = 0
                pcall(function() _hrp.CFrame = CFrame.new(destPos, destPos + facingDir) end)
                _vzL(_hrp)
                _vzA(_hrp)
            end
            RunService.Heartbeat:Wait()
        end
    end
    local _ahrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    local _clonePos = (_ahrp and _ahrp.Parent and _ahrp.Position) or destPos

    local _clonePlat = Instance.new("Part")
    -- was "xyr0HubClonePlatform"; an unnamed Part is indistinguishable from
    -- the thousands the game already has in Workspace.
    _clonePlat.Size = Vector3.new(12, 1, 12)
    _clonePlat.Position = Vector3.new(_clonePos.X, _clonePos.Y - 3, _clonePos.Z)
    _clonePlat.Anchored = true
    _clonePlat.CanCollide = true
    _clonePlat.Transparency = 1
    _clonePlat.Material = Enum.Material.SmoothPlastic
    _clonePlat.Parent = workspace

    if _ahrp and _ahrp.Parent then
        _vzL(_ahrp)
        _vzA(_ahrp)
    end

    local _preClonePos, _preCloneChar
    do
        _preCloneChar = LP.Character
        local _h = _preCloneChar and _preCloneChar:FindFirstChild("HumanoidRootPart")
        _preClonePos = _h and _h.Position or destPos
    end
    local _charAdded = false
    local _caConn = LP.CharacterAdded:Connect(function() _charAdded = true end)

    _G.xyr0StealHold = false

    task.wait(tonumber(_G.LandingDelay) or tonumber(_G.TPCloneDelay) or 0.35)

    if facingDir and facingDir.Magnitude > 0.1 then
        local _pinHum = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _pinHum then pcall(function() _pinHum.AutoRotate = false end) end
        for _ = 1, 4 do
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not _h or not _h.Parent then break end
            pcall(function()
                _h.CFrame = CFrame.new(_h.Position, _h.Position + facingDir)
                _vzL(_h)
                _vzA(_h)
            end)
            RunService.Heartbeat:Wait()
        end
    end

    local _cloneOk = doClone()
    if _clonePlat then
        local _plat = _clonePlat
        _clonePlat = nil
        task.delay(1.5, function() pcall(function() _plat:Destroy() end) end)
    end
    do
        local _t0 = os.clock()
        repeat
            if _charAdded then break end
            if LP.Character ~= _preCloneChar then break end
            local _h = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if _h then
                local _dx = _h.Position.X - _preClonePos.X
                local _dz = _h.Position.Z - _preClonePos.Z
                if (_dx * _dx + _dz * _dz) > 1 then break end
            end
            RunService.Heartbeat:Wait()
        until os.clock() - _t0 > (tonumber(_G.xyr0CloneSettle) or 0.5)
    end
    if _caConn then _caConn:Disconnect() end

    pcall(function()
        local _rh = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if _rh then _rh.AutoRotate = true end
    end)

    goToBrainrot(petPos, pet and pet.slot)
    isTeleporting = false
    if _G.xyr0TPStop then return end
    if _G.xyr0ArmSteal then pcall(_G.xyr0ArmSteal, pet) end
    _G.xyr0StealSay("TP arrive -> " .. tostring(pet and pet.name) .. " [" .. tostring(pet and pet.plot) .. "/" .. tostring(pet and pet.slot) .. "]")
end

_manualTPBusy = false
function manualFullTP()
    if _manualTPBusy or isTeleporting then return end
    if LP:GetAttribute("Stealing") == true then return end
    _manualTPBusy = true
    if _G.xyr0ScanProfile and _G.xyr0ScanMode == "fast" then _G.xyr0ScanProfile("normal") end
    local okAll = pcall(function()
        local _t0 = os.clock()
        local _lastN, _lastTop = -1, nil
        repeat
            local ok, pets = pcall(scanForTP)
            if ok and pets and #pets > 0 then
                local top = tostring(pets[1].plot) .. "_" .. tostring(pets[1].slot)
                if #pets == _lastN and top == _lastTop then break end
                _lastN, _lastTop = #pets, top
                task.wait(tonumber(_G.xyr0ScanSettle) or 0.06)
            else
                task.wait(0.05)
            end
        until os.clock() - _t0 > (tonumber(_G.xyr0TPMaxWait) or 4)
        doVelocityTP(true)
    end)
    _manualTPBusy = false
    return okAll
end
_G.xyr0StartSideTP = manualFullTP

if type(_G.SHARED_PRIORITY_ITEMS) ~= "table" or #_G.SHARED_PRIORITY_ITEMS == 0 then
_G.SHARED_PRIORITY_ITEMS = {
    "Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl",
    "Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio",
    "Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros",
    "Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal",
    "Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino",
    "Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros",
    "Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero",
    "Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers",
    "Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro",
    "Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch",
    "Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon",
    "Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah",
    "Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos",
    "Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso",
    "Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas",
    "Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros",
    "Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion",
    "Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande",
    "Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta",
    "Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti",
    "Los Bros","Gobblino Uniciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis",
    "Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande",
    "Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67",
    "Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito",
    "Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy",
    "Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni",
    "Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda",
    "Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion",
    "Esok Sekolah",
}
end

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == Enum.KeyCode.V then
        task.spawn(function() pcall(doClone) end)
    end
    local want = _G._stp_tpKeyName
    if type(want) ~= "string" or want == "" then want = "T" end
    if input.KeyCode.Name == want then
        task.spawn(function() pcall(manualFullTP) end)
    end
end)

task.spawn(function() pcall(loadModules) pcall(loadNet) end)

_G.xyr0ChannelsReady = false

task.spawn(function()
    local char = LP.Character or LP.CharacterAdded:Wait()

    local hrpReady, humReady = false, false
    task.spawn(function() char:WaitForChild("HumanoidRootPart", 20); hrpReady = true end)
    task.spawn(function() char:WaitForChild("Humanoid", 20); humReady = true end)
    local _tw0 = os.clock()
    while (not hrpReady or not humReady) and os.clock() - _tw0 < 20 do
        RunService.Heartbeat:Wait()
    end
    pcall(loadModules); pcall(loadNet)
    if _G.xyr0AutoTP == false then return end

    if _G.xyr0WaitForTools ~= false and type(_G.xyr0ToolsReady) == "function" then
        local _tt0 = os.clock()
        local _tcap = tonumber(_G.xyr0ToolWait) or 30
        while os.clock() - _tt0 < _tcap do
            local ok, ready = pcall(_G.xyr0ToolsReady)
            if ok and ready then break end
            if _G.xyr0AutoTP == false then return end
            task.wait(0.2)
        end
    end
    pcall(carpetEngage)
    do
        local _d = tonumber(_G._stp_tpDelay) or tonumber(_G.TPDelay) or 0
        if _d > 0 then task.wait(_d) end
    end

    local _w0 = os.clock()
    local _wMax = tonumber(_G.xyr0AutoTPWait) or 20
    while os.clock() - _w0 < _wMax do
        if _G.xyr0AutoTP == false then return end
        if LP:GetAttribute("Stealing") == true then return end
        local ok, pets = pcall(scanForTP)
        if ok and pets and #pets > 0 then break end
        task.wait(tonumber(_G.xyr0AutoTPPoll) or 0.05)
    end
    pcall(doVelocityTP)
    if _G.xyr0ScanProfile then _G.xyr0ScanProfile("normal") end
end)

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local LP = Players.LocalPlayer
    local PG = LP:WaitForChild("PlayerGui")

    local function diag()
        pcall(loadModules)
        local Plots = workspace:FindFirstChild("Plots")
        local nPlots = Plots and #Plots:GetChildren() or 0
        local nCh, nOwn, nAl = 0,0,0
        if Plots then
            for _, plot in ipairs(Plots:GetChildren()) do
                local ch = getPlotChannel(plot.Name)
                if ch then
                    nCh = nCh + 1
                    if ownerInGame(ch) then nOwn = nOwn + 1 end
                    if channelGet(ch, "AnimalList") then nAl = nAl + 1 end
                end
            end
        end
        local ok, pets = pcall(scanAllPets)
        local nPets = (ok and pets and #pets) or 0
        local msg = string.format("plots=%d ch=%d owner=%d animals=%d PETS=%d", nPlots, nCh, nOwn, nAl, nPets)
        print("[TP TEST] " .. msg)
        if nPets > 0 and pets[1] then
            print("[TP TEST] top=", pets[1].name, pets[1].plot, pets[1].slot)
        end
        return nPets
    end

    local function findStealPrompt(pet)
        if not pet then return nil end
        if pet.plot and pet.slot then
            local plots = workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(pet.plot)
            local podiums = plot and plot:FindFirstChild("AnimalPodiums")
            local podium = podiums and podiums:FindFirstChild(tostring(pet.slot))
            if podium then
                local base = podium:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                local attach = spawn and spawn:FindFirstChild("PromptAttachment")
                if attach then
                    for _, p in ipairs(attach:GetChildren()) do
                        if p:IsA("ProximityPrompt") then return p end
                    end
                end
                for _, d in ipairs(podium:GetDescendants()) do
                    if d:IsA("ProximityPrompt") then return d end
                end
            end
        end
        return nil
    end

    local InternalStealCache = {}
    local STEAL_HOLD_DURATION = 1.3
    local STEAL_PROXIMITY = tonumber(_G.xyr0StealProximity) or 28
    local _stealHoldStart, _stealHoldActive = 0, false
    local _stealTarget, _stealArmedAt = nil, 0
    local _lastTargetPick, _lastPickUid, _currentTargetName = 0, nil, nil
    local _stealLastScan, _autoLastScan = 0, 0
    local _inRangeLast = 0
    local _armCheckAt = 0
    local _petsCache, _petsCacheAt = nil, 0

    -- one scan shared by the picker, the in-range check and the watchdog
    local function _scanCached(now, maxAge)
        if _petsCache and (now - _petsCacheAt) <= (maxAge or 0.15) then return _petsCache end
        local ok, pets = pcall(scanAllPets)
        if ok and type(pets) == "table" then
            _petsCache, _petsCacheAt = pets, now
            return pets
        end
        return nil
    end

    -- is the brainrot still on that podium, per the game's own data
    local function _petListed(plot, slot)
        local ch = getPlotChannel(plot)
        local al = ch and channelGet(ch, "AnimalList")
        if type(al) ~= "table" then return true, false end
        local e = al[slot]
        if e == nil then e = al[tonumber(slot) or -1] end
        if e == nil then e = al[tostring(slot)] end
        return e ~= nil, true
    end

    local function _prox()
        return tonumber(_G.xyr0StealProximity) or STEAL_PROXIMITY
    end
    local function _holdDur()
        return tonumber(_G.xyr0StealHoldDuration) or STEAL_HOLD_DURATION
    end

    -- after each attempt: did the brainrot actually leave that podium?
    -- one in-range miss flips the method, so the next grab already uses the other one
    local _cooldownUntil = 0
    local function _verifyFire(pet, path, judge)
        task.delay(tonumber(_G.xyr0VerifyDelay) or 0.5, function()
            if not (pet and pet.plot and pet.slot ~= nil) then return end
            local listed, known = true, false
            pcall(function() listed, known = _petListed(pet.plot, pet.slot) end)
            if not known then return end
            if not listed then
                _G.xyr0StealFails = 0
                _cooldownUntil = 0
                _G.xyr0StealSay("steal landed (" .. tostring(path) .. ")")
                return
            end
            if not judge then _cooldownUntil = 0 return end
            if _G.xyr0AutoSwapMethod ~= true then return end
            _G.xyr0StealFails = (_G.xyr0StealFails or 0) + 1
            if _G.xyr0StealFails >= (tonumber(_G.xyr0FailsBeforeSwap) or 1) then
                _G.xyr0StealFails = 0
                if path == "remote" then
                    _G.xyr0RemoteStealOn = false
                    _G.xyr0StealSay("remote missed -> prompt mode")
                else
                    _G.xyr0RemoteStealOn = true
                    _G.xyr0StealSay("prompt missed -> remote mode")
                end
            end
        end)
    end
    local function _holdBusy()
        if _stealHoldActive
            and (tick() - _stealHoldStart) < (_holdDur() + (tonumber(_G.xyr0StealRetryGap) or 0.15)) then
            return true
        end
        return tick() < _cooldownUntil
    end

    local _armedPet, _armLostSince = nil, 0
    local function _armLivePos(p)
        if not (p and p.plot and p.slot ~= nil) then return nil end
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(p.plot)
        if not plot then return nil end
        local ok, pos = pcall(getPetPosition, plot, p.slot)
        if ok then return pos end
        return nil
    end
    _G.xyr0ArmSteal = function(pet)
        if type(pet) ~= "table" or type(pet.plot) ~= "string" or pet.slot == nil then return end
        _armedPet = {
            name = pet.name, index = pet.index, mps = pet.mps, _pri = pet._pri,
            plot = pet.plot, slot = tostring(pet.slot), position = pet.position,
        }
        _armLostSince = 0
        _stealTarget = _armedPet
        _stealArmedAt = os.clock()
        if type(pet.name) == "string" and pet.name ~= "" then _currentTargetName = pet.name end
    end
    _G.xyr0DisarmSteal = function()
        _armedPet, _armLostSince = nil, 0
    end
    _G.xyr0ArmedName = function() return _armedPet and _armedPet.name or nil end

    local UIC = {
        bg   = Color3.fromRGB(68, 68, 68),
        bg2  = Color3.fromRGB(78, 78, 78),
        card = Color3.fromRGB(92, 92, 92),
        track = Color3.fromRGB(112, 112, 112),
        line = Color3.fromRGB(135, 135, 135),
        acc  = Color3.fromRGB(155, 155, 155),
        acc2 = Color3.fromRGB(190, 190, 190),
        txt  = Color3.fromRGB(255, 255, 255),
        dim  = Color3.fromRGB(215, 215, 215),
    }
    local UIF, UIFB = Enum.Font.Gotham, Enum.Font.GothamBold

    local function mk(class, parent, props)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function corner(o, r) mk("UICorner", o, { CornerRadius = UDim.new(0, r or 8) }) return o end
    local function stroke(o, col) mk("UIStroke", o, { Color = col or UIC.line, Thickness = 1 }) return o end

    pcall(function()
        local _oldDbg = LP:FindFirstChild("PlayerGui")
        _oldDbg = _oldDbg and _oldDbg:FindFirstChild("xyr0StealDbg")
        if _oldDbg then _oldDbg:Destroy() end
    end)

    -- This bar was the one piece of UI parented straight into PlayerGui under a
    -- self-identifying name, so the game could both see it and name it. Prefer
    -- the executor's hidden container; fall back to PlayerGui under a native-
    -- looking name, and track it by reference rather than re-finding by name.
    local stealBarSg, stealBarFill, stealBarTitle, stealBarPct, stealBarKey, stealBarCd
    local function ensureStealBar()
        if stealBarSg and stealBarSg.Parent then return end
        local host = (gethui and gethui()) or PG
        stealBarSg = mk("ScreenGui", host, {
            Name = "hudProgressLayer", ResetOnSpawn = false,
            IgnoreGuiInset = true, DisplayOrder = 120,
        })
        -- wider wrap to fit bar + two pill buttons on the right
        local wrap = mk("Frame", stealBarSg, {
            Name = "Wrap", AnchorPoint = Vector2.new(0.5, 1),
            Position = UDim2.new(0.5, 0, 1, -120), Size = UDim2.fromOffset(340, 34),
            BackgroundTransparency = 1,
        })
        stealBarTitle = mk("TextLabel", wrap, {
            Size = UDim2.new(0, 200, 0, 12), Position = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "STEAL",
        })
        mk("UIStroke", stealBarTitle, {
            Color = Color3.new(0, 0, 0), Thickness = 2, Transparency = 0.55,
        })
        stealBarPct = mk("TextLabel", wrap, {
            Size = UDim2.fromOffset(42, 12), Position = UDim2.new(0, 200, 0, 0),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.acc, TextXAlignment = Enum.TextXAlignment.Left, Text = "0%",
        })
        mk("UIStroke", stealBarPct, {
            Color = Color3.new(0, 0, 0), Thickness = 2, Transparency = 0.55,
        })
        -- keybind pill (e.g. "C")
        local keyPill = corner(mk("Frame", wrap, {
            Size = UDim2.fromOffset(28, 18), Position = UDim2.new(0, 256, 1, -22),
            BackgroundColor3 = Color3.fromRGB(30, 30, 38), BorderSizePixel = 0,
        }), 4)
        stroke(keyPill, UIC.line)
        stealBarKey = mk("TextLabel", keyPill, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Font = UIFB, TextSize = 11, TextColor3 = UIC.txt, Text = "C",
        })
        -- cooldown pill (e.g. "2.6s")
        local cdPill = corner(mk("Frame", wrap, {
            Size = UDim2.fromOffset(46, 18), Position = UDim2.new(0, 290, 1, -22),
            BackgroundColor3 = Color3.fromRGB(30, 30, 38), BorderSizePixel = 0,
        }), 4)
        stroke(cdPill, UIC.line)
        stealBarCd = mk("TextLabel", cdPill, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Font = UIFB, TextSize = 11, TextColor3 = UIC.dim, Text = "--",
        })
        local track = corner(mk("Frame", wrap, {
            Position = UDim2.new(0, 0, 1, -6), Size = UDim2.fromOffset(248, 6),
            BackgroundColor3 = UIC.track, BackgroundTransparency = 0.25, BorderSizePixel = 0,
        }), 3)
        stroke(track, Color3.fromRGB(10, 8, 4))
        stealBarFill = corner(mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = UIC.acc, BorderSizePixel = 0,
        }), 3)
        mk("UIGradient", stealBarFill, {
            Color = ColorSequence.new(UIC.acc, UIC.acc2),
        })
        -- update keybind label and cooldown countdown every frame
        RunService.Heartbeat:Connect(function()
            if not stealBarSg or not stealBarSg.Parent then return end
            local key = tostring(_G.xyr0NearestKey or "C")
            if stealBarKey and stealBarKey.Parent then stealBarKey.Text = key end
            if stealBarCd and stealBarCd.Parent then
                local remaining = (_cooldownUntil or 0) - tick()
                if remaining > 0.05 then
                    stealBarCd.Text = string.format("%.1fs", remaining)
                    stealBarCd.TextColor3 = UIC.acc
                else
                    stealBarCd.Text = "rdy"
                    stealBarCd.TextColor3 = UIC.dim
                end
            end
        end)
        stealBarSg.Enabled = true
    end
    local function showStealBar(name, pct)
        pcall(function()
            ensureStealBar()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarSg.Enabled = true
            stealBarTitle.Text = name and ("STEAL  " .. tostring(name)) or "STEAL"
            stealBarPct.Text = math.floor(pct * 100 + 0.5) .. "%"
            stealBarFill.Size = UDim2.new(pct, 0, 1, 0)
        end)
    end
    local function setStealBarPct(pct)
        if not stealBarSg or not stealBarSg.Enabled then return end
        pcall(function()
            pct = math.clamp(tonumber(pct) or 0, 0, 1)
            stealBarPct.Text = tostring(math.floor(pct * 100 + 0.5)) .. "%"
            stealBarFill.Size = UDim2.new(pct, 0, 1, 0)
        end)
    end
    local function hideStealBar()
        pcall(function()
            ensureStealBar()
            stealBarSg.Enabled = true
            stealBarTitle.Text = "STEAL"
            stealBarPct.Text = "0%"
            stealBarFill.Size = UDim2.new(0, 0, 1, 0)
        end)
    end
    task.defer(hideStealBar)

    local function buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then return end
        if not prompt or not prompt.Parent then return end
        local data = { holdCallbacks = {}, triggerCallbacks = {}, holdEndCallbacks = {}, ready = true }
        local function grab(sig, into)
            local ok, conns = pcall(getconnections, sig)
            if ok and type(conns) == "table" then
                for _, c in ipairs(conns) do
                    if type(c.Function) == "function" then table.insert(into, c.Function) end
                end
            end
        end
        grab(prompt.PromptButtonHoldBegan, data.holdCallbacks)
        grab(prompt.Triggered, data.triggerCallbacks)
        grab(prompt.PromptButtonHoldEnded, data.holdEndCallbacks)
        if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 or #data.holdEndCallbacks > 0 then
            InternalStealCache[prompt] = data
        end
    end

    local _rawFireServer = Instance.new("RemoteEvent").FireServer
    local _reBegin, _reCommit = nil, nil
    local _reState, _reRetryAt = {}, {}
    local function _re(cache, hash)
        if cache and cache.Parent then return cache end
        local st = _reState[hash]
        if typeof(st) == "Instance" then
            if st.Parent then return st end
            _reState[hash] = nil
            st = nil
        end
        if st == "pending" then return nil end
        if st == "failed" and os.clock() < (_reRetryAt[hash] or 0) then return nil end
        _reState[hash] = "pending"
        task.spawn(function()
            local got
            pcall(function()
                if _G.xyr0GetRemote then got = _G.xyr0GetRemote("RemoteEvent", hash) end
            end)
            if typeof(got) == "Instance" then
                _reState[hash] = got
                _G.xyr0StealSay("remote resolved " .. tostring(hash):sub(1, 8))
            else
                _reState[hash] = "failed"
                _reRetryAt[hash] = os.clock() + (tonumber(_G.xyr0RemoteRetry) or 5)
                _G.xyr0StealSay("remote resolve FAILED " .. tostring(hash):sub(1, 8))
            end
        end)
        task.delay(tonumber(_G.xyr0RemoteResolveWait) or 3, function()
            if _reState[hash] == "pending" then
                _reState[hash] = "failed"
                _reRetryAt[hash] = os.clock() + (tonumber(_G.xyr0RemoteRetry) or 5)
                _G.xyr0StealSay("remote resolve TIMEOUT " .. tostring(hash):sub(1, 8))
            end
        end)
        return nil
    end

    local function _stealBegin()
        _reBegin = _re(_reBegin, "f40f7d9e-2f0d-4167-b250-899273f46874")
        if not _reBegin then return false end
        local t = workspace:GetServerTimeNow() + 124
        pcall(_rawFireServer, _reBegin, t, "68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0")
        pcall(function() _rawFireServer(_reBegin, t, "07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd") end)
        return true
    end

    local function _stealCommit(plot, slot)
        _reCommit = _re(_reCommit, "3ba148c9-7ed6-4675-93f8-9f7c356a2c54")
        if not _reCommit then return false end
        if type(plot) ~= "string" or slot == nil then return false end
        local sl = tonumber(slot) or slot
        local t = workspace:GetServerTimeNow() + 31
        pcall(_rawFireServer, _reCommit, t, "cda5c764-d4e3-45c4-94e4-53a538347590", plot, sl)
        pcall(function()
            _rawFireServer(_reCommit, t, "8c852fbf-d542-4ef4-aa28-612e24db8d4a", plot, sl)
        end)
        return true
    end
    _G.xyr0StealBegin, _G.xyr0StealCommit = _stealBegin, _stealCommit

    -- fire the same two remotes (4) does; have them resolved before the first grab
    local _RE_BEGIN  = "f40f7d9e-2f0d-4167-b250-899273f46874"
    local _RE_COMMIT = "3ba148c9-7ed6-4675-93f8-9f7c356a2c54"
    local _reWarmT0 = os.clock()
    local function _remotesReady()
        return typeof(_reState[_RE_BEGIN]) == "Instance"
            and typeof(_reState[_RE_COMMIT]) == "Instance"
    end
    task.spawn(function()
        for _ = 1, 60 do
            if _remotesReady() then _G.xyr0StealSay("steal remotes ready") return end
            _re(nil, _RE_BEGIN)
            _re(nil, _RE_COMMIT)
            task.wait(0.25)
        end
    end)

    local function remoteStealAsync(pet, judge)
        if not (pet and type(pet.plot) == "string" and pet.slot ~= nil) then return false end
        if _holdBusy() then
            return false
        end
        if not _stealBegin() then return false end
        _stealHoldStart = tick()
        _stealHoldActive = true
        showStealBar(pet.name, 0)
        task.spawn(function()
            local hold = tonumber(_G.xyr0StealHoldDuration) or STEAL_HOLD_DURATION
            while true do
                local el = tick() - _stealHoldStart
                if el >= hold then break end
                setStealBarPct(el / hold)
                RunService.Heartbeat:Wait()
            end
            setStealBarPct(1)
            _stealCommit(pet.plot, pet.slot)
            _verifyFire(pet, "remote", judge)
            _stealHoldActive = false
            task.wait(0.2)
            hideStealBar()
        end)
        task.delay(STEAL_HOLD_DURATION + 0.6, hideStealBar)
        return true
    end

    local function executeStealAsync(prompt, petName, restoreMax)
        if _holdBusy() then
            return false
        end
        local data = InternalStealCache[prompt]
        if not data or not data.ready then return false end
        data.ready = false
        _stealHoldStart = tick()
        _stealHoldActive = true
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        showStealBar(petName, 0)
        task.spawn(function()
            for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
            local hold = tonumber(_G.xyr0StealHoldDuration) or STEAL_HOLD_DURATION
            pcall(function()
                local hd = prompt.HoldDuration
                if type(hd) == "number" and hd > 0 then
                    hold = math.max(hold, hd + 0.05)
                end
            end)
            while true do
                local el = tick() - _stealHoldStart
                if el >= hold then break end
                setStealBarPct(el / hold)
                RunService.Heartbeat:Wait()
            end
            setStealBarPct(1)
            if prompt and prompt.Parent then
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
            end
            for _, fn in ipairs(data.holdEndCallbacks) do task.spawn(fn) end
            _stealHoldActive = false
            if restoreMax ~= nil then
                pcall(function()
                    if prompt and prompt.Parent then prompt.MaxActivationDistance = restoreMax end
                end)
            end
            task.wait(0.05)
            data.ready = true
            task.wait(0.2)
            hideStealBar()
        end)
        task.delay(STEAL_HOLD_DURATION + 0.6, hideStealBar)
        return true
    end

    local function timeUntilCanSteal()
        if LP:GetAttribute("Stealing") or LP:GetAttribute("IsTrading")
            or LP:GetAttribute("IsDuelSelecting") or LP:GetAttribute("Web") then
            return -1
        end
        local ragdoll = LP:GetAttribute("RagdollEndTime")
        if ragdoll then
            local r = ragdoll - workspace:GetServerTimeNow()
            if r > 0 then return r end
        end
        return 0
    end

    local stealOn = (_G.xyr0StealMode ~= nil)
    local _emptyScans = 0
    local function _fireSteal(pet)
        if not pet then return false end
        if _holdBusy() then _G.xyr0StealSay("hold already running") return false end
        local _fhrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        local _fd = (_fhrp and pet.position) and (pet.position - _fhrp.Position).Magnitude or nil
        local _judge = (_fd ~= nil) and (_fd <= _prox() + 2) or false
        local _cd = _holdDur() + (tonumber(_G.xyr0VerifyDelay) or 0.5) + 0.15
        _G.xyr0StealSay("gates ok -> firing on " .. tostring(pet.name))
        if _G.xyr0RemoteStealOn ~= false then
            if remoteStealAsync(pet, _judge) then
                _G.xyr0LastFire = os.clock()
                _cooldownUntil = tick() + _cd
                _G.xyr0StealSay("FIRE remote -> " .. tostring(pet.name))
                return true
            end
            _G.xyr0StealSay("remote not ready -> prompt path")
        end
        local prompt = findStealPrompt(pet)
        if not prompt or not prompt.Parent then
            _G.xyr0StealSay("no prompt at " .. tostring(pet.plot) .. "/" .. tostring(pet.slot))
            return false
        end
        local oldMax
        pcall(function() oldMax = prompt.MaxActivationDistance end)
        pcall(function() prompt.MaxActivationDistance = math.huge end)
        buildStealCallbacks(prompt)
        if InternalStealCache[prompt] then
            if executeStealAsync(prompt, pet.name, oldMax) then
                _G.xyr0LastFire = os.clock()
                _cooldownUntil = tick() + _cd
                _verifyFire(pet, "prompt", _judge)
                _G.xyr0StealSay("FIRE prompt-callback -> " .. tostring(pet.name))
                return true
            end
            _G.xyr0StealSay("prompt-callback not ready")
            if oldMax ~= nil then pcall(function() prompt.MaxActivationDistance = oldMax end) end
            return false
        elseif fireproximityprompt then
            pcall(function() prompt.MaxActivationDistance = math.huge end)
            showStealBar(pet.name, 1)
            pcall(function() fireproximityprompt(prompt) end)
            _G.xyr0LastFire = os.clock()
            _cooldownUntil = tick() + (tonumber(_G.xyr0VerifyDelay) or 0.5) + 0.5
            _verifyFire(pet, "prompt", _judge)
            _G.xyr0StealSay("FIRE proximityprompt -> " .. tostring(pet.name))
            task.delay(0.4, hideStealBar)
            pcall(function() if oldMax ~= nil then prompt.MaxActivationDistance = oldMax end end)
            return true
        end
        _G.xyr0StealSay("no steal method available")
        return false
    end
    _G.xyr0FireSteal = _fireSteal
    local function _stealTick()
        _G.xyr0TickN = (_G.xyr0TickN or 0) + 1
        stealOn = (_G.xyr0StealMode ~= nil)
        if not stealOn then _G.xyr0StealSay("steal mode OFF") return end
        local now = os.clock()
        local _lockUid = _G.xyr0StealTargetUID
        local _lockChanged = (type(_lockUid) == "string" and _lockUid ~= "" and _lockUid ~= _lastPickUid)
        local _needPick = (not _stealTarget) or _lockChanged or (now - _lastTargetPick) >= (tonumber(_G.xyr0RepickGap) or 0.35)
        if _armedPet then
            local _lp = _armLivePos(_armedPet)
            if _lp then
                _armedPet.position = _lp
                _armLostSince = 0
            elseif _armLostSince == 0 then
                _armLostSince = now
            elseif now - _armLostSince > (tonumber(_G.xyr0ArmLostGrace) or 1.5) then
                _armedPet, _armLostSince = nil, 0
            end
            if _armedPet and (now - _armCheckAt) >= (tonumber(_G.xyr0ArmCheckGap) or 0.5) then
                _armCheckAt = now
                local okL, listed = pcall(_petListed, _armedPet.plot, _armedPet.slot)
                if okL and not listed then
                    _G.xyr0StealSay("armed pet gone -> repicking")
                    _armedPet, _armLostSince = nil, 0
                end
            end
            if _armedPet then
                _stealTarget = _armedPet
                if type(_armedPet.name) == "string" then _currentTargetName = _armedPet.name end
                _needPick = false
            end
        end
        local _scanGap = (_emptyScans >= 3) and (tonumber(_G.xyr0StealIdleGap) or 0.3) or 0.01
        if not LP:GetAttribute("Stealing") and _needPick and (now - _autoLastScan) >= _scanGap then
            _autoLastScan = now
            _lastTargetPick = now
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local pets = _scanCached(now, 0.05)
                local ok = pets ~= nil
                if ok and pets and #pets > 0 then _emptyScans = 0 else _emptyScans = _emptyScans + 1 end
                if ok and pets and #pets > 0 then
                    local best
                    if type(_lockUid) == "string" and _lockUid ~= "" then
                        for _, p in ipairs(pets) do
                            if not p.conveyor and _petUid(p) == _lockUid then best = p break end
                        end
                    end
                    if not best and _G.xyr0StealMode == "nearest" then
                        local myPos = hrp.Position
                        local bestD = math.huge
                        for _, p in ipairs(pets) do
                            if not p.conveyor and p.position then
                                local d = (p.position - myPos).Magnitude
                                if d < bestD then bestD = d; best = p end
                            end
                        end
                    elseif not best then
                        for _, p in ipairs(pets) do if not p.conveyor then best = p; break end end
                    end
                    best = best or pets[1]
                    if best then
                        _stealTarget = best
                        _stealArmedAt = now
                        _lastPickUid = _lockUid
                        if type(best.name) == "string" and best.name ~= "" then
                            _currentTargetName = best.name
                        end
                    end
                end
            end
        end
        if _G.xyr0StealInRangeFirst ~= false
            and not (_armedPet and _G.xyr0TPTargetWins ~= false)
            and not (type(_lockUid) == "string" and _lockUid ~= "") then
            local _c2 = LP.Character
            local _h2 = _c2 and _c2:FindFirstChild("HumanoidRootPart")
            if _h2 then
                local _cur = _stealTarget
                local _curD = (_cur and _cur.position) and (_cur.position - _h2.Position).Magnitude or math.huge
                if _curD > _prox() and (now - _inRangeLast) >= (tonumber(_G.xyr0InRangeGap) or 0.25) then
                    _inRangeLast = now
                    local _pets2 = _scanCached(now, 0.15)
                    local _ok2 = _pets2 ~= nil
                    if _ok2 and type(_pets2) == "table" then
                        local _near, _nd = nil, math.huge
                        local _mp = _h2.Position
                        for _, p in ipairs(_pets2) do
                            if not p.conveyor and p.position then
                                local d = (p.position - _mp).Magnitude
                                if d < _nd then _nd, _near = d, p end
                            end
                        end
                        if _near and _nd <= _prox() then
                            _stealTarget = _near
                            _armedPet, _armLostSince = nil, 0
                            _lastTargetPick = now
                            if type(_near.name) == "string" then _currentTargetName = _near.name end
                            _G.xyr0StealSay(string.format("switch to in-range %s d=%.0f", tostring(_near.name), _nd))
                        end
                    end
                end
            end
        end
        local pet = _stealTarget
        if not pet then _G.xyr0StealSay("no target") return end

        if now - _stealLastScan < 0.033 then _G.xyr0ThrN = (_G.xyr0ThrN or 0) + 1 return end
        _stealLastScan = now
        local t = timeUntilCanSteal()
        if t == -1 then
            if LP:GetAttribute("Stealing") then _stealTarget = nil; _armedPet, _armLostSince = nil, 0 end
            _G.xyr0StealSay("busy: stealing/trading/web")
            return
        end
        if t > 0 and t > _holdDur() then _G.xyr0StealSay(string.format("cooldown %.1fs", t)) return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then _G.xyr0StealSay("no character") return end

        if pet.position then
            local toPet = pet.position - hrp.Position
            local dist = toPet.Magnitude
            _G.xyr0StealTgt = string.format("%s [%s/%s] d=%.0f", tostring(pet.name), tostring(pet.plot), tostring(pet.slot), dist)
            local hold = tonumber(_G.xyr0StealHoldDuration) or STEAL_HOLD_DURATION

            local lead = tonumber(_G.xyr0StealLead) or 0.27

            local closing = dist > 0.001 and (hrp.AssemblyLinearVelocity:Dot(toPet) / dist) or 0

            local _nearBase = false
            do
                local _bi = getClosestBaseIdx(pet.position)
                local _b = _bi and BASES_LOW[_bi]
                if _b then
                    local _bx, _bz = hrp.Position.X - _b.X, hrp.Position.Z - _b.Z
                    if math.sqrt(_bx * _bx + _bz * _bz) <= (tonumber(_G.xyr0CloseBaseRange) or 100) then
                        _nearBase = true
                    end
                end
            end

            if _nearBase then
                if dist > (tonumber(_G.xyr0NearBaseStealStart) or 55) then _G.xyr0StealSay(string.format("nearbase far d=%.0f", dist)) return end
            elseif closing > (tonumber(_G.xyr0FastApproach) or 150) then

                if dist > (tonumber(_G.xyr0StealLeadMax) or 223) then _G.xyr0StealSay(string.format("lead far d=%.0f", dist)) return end
                if (dist / closing) > hold * lead then _G.xyr0StealSay(string.format("lead wait d=%.0f c=%.0f", dist, closing)) return end
            elseif closing > 5 then

                if dist > (tonumber(_G.xyr0CloseProximity) or 24) then _G.xyr0StealSay(string.format("moving far d=%.0f c=%.0f", dist, closing)) return end
            else
                
                if dist > _prox() then _G.xyr0StealSay(string.format("far d=%.0f", dist)) return end
            end
        end
        _fireSteal(pet)
    end
    RunService.Heartbeat:Connect(function()
        local _ok, _err = pcall(_stealTick)
        if not _ok then _G.xyr0StealSay("ERROR " .. tostring(_err)) end
    end)

    task.spawn(function()
        while true do
            task.wait(tonumber(_G.xyr0WatchdogTick) or 0.2)
            if _G.xyr0StealMode ~= nil and _G.xyr0StealWatchdog ~= false
                and not LP:GetAttribute("Stealing")
                and not _holdBusy()
                and (os.clock() - (_G.xyr0LastFire or 0)) > (tonumber(_G.xyr0WatchdogGap) or 1.5) then
                local c = LP.Character
                local h = c and c:FindFirstChild("HumanoidRootPart")
                if h then
                    local pets = _scanCached(os.clock(), 0.15)
                    local ok = pets ~= nil
                    if ok and type(pets) == "table" then
                        local near, nd = nil, math.huge
                        local mp = h.Position
                        for _, p in ipairs(pets) do
                            if not p.conveyor and p.position then
                                local d = (p.position - mp).Magnitude
                                if d < nd then nd, near = d, p end
                            end
                        end
                        if near and nd <= _prox() then
                            _G.xyr0StealSay(string.format("WATCHDOG in range %s d=%.0f", tostring(near.name), nd))
                            pcall(_fireSteal, near)
                        end
                    end
                end
            end
        end
    end)

    do
        local function applyUnwalkAlways(char)
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local animator = hum and hum:FindFirstChildOfClass("Animator")
            local animate = char:FindFirstChild("Animate")
            if animate then animate.Disabled = true end
            if animator then
                local ok, tracks = pcall(function() return animator:GetPlayingAnimationTracks() end)
                if ok and tracks then for _, t in ipairs(tracks) do pcall(function() t:Stop(0) end) end end
            end
        end
        local function hook(char)
            task.spawn(function()
                char:WaitForChild("Humanoid", 10); task.wait(0.05)
                for i = 1, 8 do
                    if LP.Character ~= char then break end
                    applyUnwalkAlways(char); task.wait(0.25)
                end
            end)
        end
        if LP.Character then hook(LP.Character) end
        LP.CharacterAdded:Connect(hook)
        local _unwalkLast = 0
        RunService.Heartbeat:Connect(function()
            local now = os.clock()
            if now - _unwalkLast < 1.5 then return end
            _unwalkLast = now
            if LP.Character then applyUnwalkAlways(LP.Character) end
        end)
    end

    local HS = game:GetService("HttpService")
    local UIS = game:GetService("UserInputService")
    local CFG_FILE = "SideTP.json"

    local function loadCfgTable()
        local t = {}
        if readfile then
            pcall(function()
                local raw = readfile(CFG_FILE)
                if type(raw) == "string" and #raw > 0 then
                    local ok, d = pcall(HS.JSONDecode, HS, raw)
                    if ok and type(d) == "table" then t = d end
                end
            end)
        end
        return t
    end

    local function saveTpSettings()
        if not writefile then return end
        local t = loadCfgTable()
        t.tpVelocity = tonumber(_G.TPVelocity) or 400
        t.climbSpeed = tonumber(_G.xyr0Climb) or 160
        t.goSpeed = tonumber(_G.xyr0GoSpeed) or 200
        t.cframeSpeed = tonumber(_G.xyr0CFrameSpeed) or 450
        t.walkSpeed = tonumber(_G.xyr0WalkSpeed) or 27
        t.landingDelay = tonumber(_G.LandingDelay) or 0.35
        t.closeSpeed = tonumber(_G.xyr0CloseSpeed) or 80
        t.tpSafeMode = _G.xyr0TPSafeMode ~= false
        t.tpSafeSpeed = tonumber(_G.xyr0TPSafeSpeed) or 300
        t.tpSafeVerticalSpeed = tonumber(_G.xyr0TPSafeVerticalSpeed) or 110
        t.tpRetryCount = tonumber(_G.xyr0TPRetryCount) or 2
        t.autoTp = _G.xyr0AutoTP ~= false
        t.autoKickOnSteal = _G.xyr0AutoKickOnSteal == true
        t.kickToPS = _G.xyr0KickToPS == true
        t.psLink = tostring(_G.xyr0PrivateServerLink or "")
        t.priAlert = _G.xyr0PriAlert == true
        t.alertSound = tostring(_G.xyr0AlertSound or "111786441593851")
        t.alertMinGen = tonumber(_G.xyr0AlertMinGen) or 80e6
        t.walkSpeedOn = _G.xyr0WalkSpeedOn ~= false
        t.xray = _G.xyr0Xray ~= false
        t.invisAuto = _G.xyr0InvisAuto == true
        t.invisDepth = tonumber(_G.xyr0InvisDepth) or 4.2
        t.invisAngle = tonumber(_G.xyr0InvisAngle) or 180
        t.autoSteal = stealOn
        t.stealMode = _G.xyr0StealMode
        t.priorityList = _G.SHARED_PRIORITY_ITEMS
        t.panelX = tonumber(_G._stp_panelX)
        t.panelY = tonumber(_G._stp_panelY)
        t.panelPos = _G._stp_pos
        t.tgtX = tonumber(_G._xyr0_tgtX)
        t.tgtY = tonumber(_G._xyr0_tgtY)
        t.tgtW = tonumber(_G._xyr0_tgtW)
        t.tgtH = tonumber(_G._xyr0_tgtH)
        
        if type(_G.xyr0CloneKeyName)  == "string" then t.cloneKey  = _G.xyr0CloneKeyName  else t.cloneKey  = nil end
        if type(_G.xyr0KickKeyName)   == "string" then t.kickKey   = _G.xyr0KickKeyName   else t.kickKey   = nil end
        if type(_G.xyr0StopTPKeyName) == "string" then t.stopTpKey = _G.xyr0StopTPKeyName else t.stopTpKey = nil end
        if type(_G.xyr0NearestKey)    == "string" then t.nearestKey= _G.xyr0NearestKey    else t.nearestKey= nil end
        if type(_G.xyr0DropKeyName)   == "string" then t.dropKey   = _G.xyr0DropKeyName   else t.dropKey   = nil end
        if type(_G.xyr0ResetKeyName)  == "string" then t.resetKey  = _G.xyr0ResetKeyName  else t.resetKey  = nil end
        t.antiFlash = _G.xyr0AntiFlash ~= false
        t.faceAway = _G.xyr0FaceAway == true
        t.faceAwayNearest = _G.xyr0FaceAwayNearest == true
        t.faceAwayDelay = tonumber(_G.xyr0FaceAwayDelay) or 2
        t.antiBee   = _G.xyr0AntiBee ~= false
        t.infJump   = _G.xyr0InfJump ~= false
        t.antiDie   = _G.AntiDieDisabled ~= true
        t.carpetSpeedValue = tonumber(_G.xyr0CarpetSpeedValue) or 140
        t.autoBuy = _G.xyr0AutoBuy == true
        t.autoBuyRange = tonumber(_G.xyr0AutoBuyRange) or 17
        t.autoBuyHover = tonumber(_G.xyr0AutoBuyHover) or 9
        t.exX = tonumber(_G._xyr0_exX); t.exY = tonumber(_G._xyr0_exY)
        t.fX  = tonumber(_G._xyr0_fX);  t.fY  = tonumber(_G._xyr0_fY)
        t.kX  = tonumber(_G._xyr0_kX);  t.kY  = tonumber(_G._xyr0_kY)
        pcall(function() writefile(CFG_FILE, HS:JSONEncode(t)) end)
    end
    _G.xyr0SaveSettings = saveTpSettings  

    if _G.TPVelocity == nil then _G.TPVelocity = 400 end
    if _G.xyr0Climb == nil then _G.xyr0Climb = 160 end
    if _G.xyr0GoSpeed == nil then _G.xyr0GoSpeed = 200 end
    if _G.xyr0CFrameSpeed == nil then _G.xyr0CFrameSpeed = 450 end
    if _G.xyr0WalkSpeed == nil then _G.xyr0WalkSpeed = 27 end
    if _G.LandingDelay == nil then _G.LandingDelay = 0.35 end
    if _G.xyr0CloseSpeed == nil then _G.xyr0CloseSpeed = 80 end
    if _G.xyr0InvisDepth == nil then _G.xyr0InvisDepth = 4.2 end
    if _G.xyr0InvisAngle == nil then _G.xyr0InvisAngle = 180 end

    local TS = game:GetService("TweenService")
    local EASE = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tween(o, props) TS:Create(o, EASE, props):Play() end

    local guiParent = (gethui and gethui()) or game:GetService("CoreGui") or PG
    for _, par in ipairs({ guiParent, PG }) do
        pcall(function()
            local old = par:FindFirstChild("uiMainLayer")
            if old then old:Destroy() end
        end)
    end

    local sg = mk("ScreenGui", nil, {
        Name = "uiMainLayer", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 999999, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = guiParent end)
    if not sg.Parent then sg.Parent = PG end

    sg.Enabled = false

    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.RightControl then
            sg.Enabled = not sg.Enabled
        end
    end)

    do
        local hudAlways = mk("ScreenGui", nil, {
            Name = "uiHudAlways", ResetOnSpawn = false, IgnoreGuiInset = true,
            DisplayOrder = 1000000, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        })
        pcall(function() hudAlways.Parent = guiParent end)
        if not hudAlways.Parent then hudAlways.Parent = PG end

        -- Minimal flat-grey status bar: real client FPS and network ping.
        local hdr = corner(mk("Frame", hudAlways, {
            Name = "Bar", AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0, 10), Size = UDim2.fromOffset(360, 28),
            BackgroundColor3 = Color3.fromRGB(64, 64, 64), BorderSizePixel = 0, ZIndex = 50,
        }), 7)
        local hrim = mk("UIStroke", hdr, {
            Thickness = 1, Transparency = 0.25, Color = Color3.fromRGB(125, 125, 125),
        })

        local function seg(x, w, txt, col, font)
            return mk("TextLabel", hdr, {
                Size = UDim2.fromOffset(w, 26), Position = UDim2.fromOffset(x, 0),
                BackgroundTransparency = 1, Text = txt, Font = font, TextSize = 11,
                TextColor3 = col, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 51,
            })
        end
        local function div(x)
            mk("Frame", hdr, {
                Size = UDim2.fromOffset(1, 14), Position = UDim2.fromOffset(x, 7),
                BackgroundColor3 = Color3.fromRGB(135, 135, 135), BorderSizePixel = 0, ZIndex = 51,
            })
        end
        seg(12, 150, "xyr0z private", Color3.fromRGB(245, 245, 245), UIFB)
        div(164)
        local fpsLbl = seg(178, 62, "FPS: --", Color3.fromRGB(240, 240, 240), UIF)
        local pingLbl = seg(248, 100, "PING: --", Color3.fromRGB(240, 240, 240), UIF)

        local frames, since, pingItem = 0, 0, nil
        RunService.RenderStepped:Connect(function(dt)
            frames, since = frames + 1, since + dt
            if since < 0.5 then return end
            fpsLbl.Text = "FPS: " .. math.floor(frames / since + 0.5)
            frames, since = 0, 0
            if not pingItem then
                pcall(function()
                    pingItem = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
                end)
            end
            local ok, v = pcall(function() return pingItem:GetValue() end)
            pingLbl.Text = "PING: " .. ((ok and math.floor(v + 0.5)) or "--") .. " ms"
        end)
    end

    -- Slightly larger layout with wider navigation and more breathing room.
    local W, H, RAIL, PAD = 500, 360, 144, 18

    local root = mk("Frame", sg, {
        Name = "Root", Active = true, BackgroundTransparency = 1,
        Size = UDim2.fromOffset(W, H),
        Position = UDim2.fromOffset(tonumber(_G._stp_panelX) or 40, tonumber(_G._stp_panelY) or 160),
    })

    local shadow = mk("Frame", root, {
        Size = UDim2.new(1, 12, 1, 12), Position = UDim2.fromOffset(-6, -6),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.75,
        ZIndex = -1, BorderSizePixel = 0,
    })
    corner(shadow, 20)

    local card = corner(mk("Frame", root, {
        BackgroundColor3 = UIC.bg, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), ZIndex = 1,
    }), 20)
    mk("UIGradient", card, {
        Rotation = 135,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, UIC.bg2), ColorSequenceKeypoint.new(1, UIC.bg)}),
    })
    local rim = mk("UIStroke", card, { Thickness = 1.5, Transparency = 0.25, Color = UIC.acc })
    mk("UIGradient", rim, {
        Rotation = 135,
        Color = ColorSequence.new({ColorSequenceKeypoint.new(0, UIC.acc), ColorSequenceKeypoint.new(1, UIC.acc2)}),
    })

    local rail = mk("Frame", card, {
        Size = UDim2.new(0, RAIL, 1, 0), BackgroundTransparency = 1, ZIndex = 2,
    })
    mk("TextLabel", rail, {
        Size = UDim2.new(1, -PAD * 2, 0, 18), Position = UDim2.fromOffset(PAD, 20),
        BackgroundTransparency = 1, Text = "XYR0Z PRIV", Font = UIFB, TextSize = 14,
        TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    mk("TextLabel", rail, {
        Size = UDim2.new(1, -PAD * 2, 0, 12), Position = UDim2.fromOffset(PAD, 40),
        BackgroundTransparency = 1, Text = "TELEPORT", Font = UIF, TextSize = 9,
        TextColor3 = UIC.acc, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 2,
    })
    mk("Frame", rail, {
        Position = UDim2.fromOffset(PAD, 58), Size = UDim2.new(1, -PAD * 2, 0, 2),
        BackgroundColor3 = UIC.line, BorderSizePixel = 0,
    })

    local body = mk("Frame", card, {
        Position = UDim2.fromOffset(RAIL, 0), Size = UDim2.new(1, -RAIL, 1, 0),
        BackgroundTransparency = 1, ZIndex = 2,
    })

    local pages, tabs = {}, {}
    local tabOpenHook = {}
    local function selectTab(name)
        local _h = tabOpenHook[name]
        if _h then tabOpenHook[name] = nil; pcall(_h) end
        for n, p in pairs(pages) do p.Visible = (n == name) end
        for n, t in pairs(tabs) do
            local on = (n == name)
            tween(t.bg, { BackgroundTransparency = on and 0 or 1 })
            tween(t.lbl, { TextColor3 = on and UIC.txt or UIC.dim })
            tween(t.btn, { BackgroundTransparency = on and 0.2 or 0.5 })
        end
    end

    local function tab(name, order)
        local b = corner(mk("TextButton", rail, {
            Size = UDim2.new(1, -PAD * 2, 0, 32), Position = UDim2.fromOffset(PAD, 72 + (order - 1) * 38),
            BackgroundColor3 = UIC.card, BackgroundTransparency = 0.5, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 2,
        }), 12)
        local bg = mk("Frame", b, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(bg, 12)
        local lbl = mk("TextLabel", b, {
            Size = UDim2.new(1, 0, 1, 0), Position = UDim2.fromOffset(0, 0),
            BackgroundTransparency = 1, Text = name, Font = UIFB, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        mk("UIPadding", lbl, { PaddingLeft = UDim.new(0, 12) })
        local page = mk("ScrollingFrame", body, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
            Visible = false, ScrollBarThickness = 0, ScrollBarImageColor3 = UIC.line,
            CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, ZIndex = 2,
        })
        mk("UIPadding", page, {
            PaddingLeft = UDim.new(0, PAD), PaddingRight = UDim.new(0, PAD + 6),
            PaddingTop = UDim.new(0, PAD + 6), PaddingBottom = UDim.new(0, PAD + 2),
        })
        mk("UIListLayout", page, { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder })
        tabs[name], pages[name] = { btn = b, bg = bg, lbl = lbl }, page
        b.MouseButton1Click:Connect(function() selectTab(name) end)
        b.MouseEnter:Connect(function()
            if not pages[name].Visible then
                tween(b, { BackgroundTransparency = 0.3 })
            end
        end)
        b.MouseLeave:Connect(function()
            if not pages[name].Visible then
                tween(b, { BackgroundTransparency = 0.5 })
            end
        end)
        return page
    end

    local function label(parent, txt, first)
        local l = mk("TextLabel", parent, {
            Size = UDim2.new(1, 0, 0, first and 14 or 26), BackgroundTransparency = 1,
            Text = string.upper(txt), Font = UIFB, TextSize = 10, TextColor3 = UIC.dim,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Bottom, ZIndex = 2,
        })
        return l
    end

    local function shell(parent, h)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = UIC.card,
            BorderSizePixel = 0, Active = true, ZIndex = 2,
        }), 12)
        local bg = mk("Frame", card, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = UIC.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        corner(bg, 12)
        return card
    end

    local function action(parent, txt, fn)
        local card2 = shell(parent, 36)
        local b = mk("TextButton", card2, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = txt,
            Font = UIFB, TextSize = 12, TextColor3 = UIC.txt,
            Active = true, AutoButtonColor = false, ZIndex = 3,
        })
        b.MouseEnter:Connect(function() 
            tween(card2:FindFirstChildOfClass("Frame"), { BackgroundTransparency = 0.3 })
        end)
        b.MouseLeave:Connect(function() 
            tween(card2:FindFirstChildOfClass("Frame"), { BackgroundTransparency = 1 })
        end)
        b.MouseButton1Click:Connect(fn)
    end

    local function toggle(parent, txt, get, fn)
        local card2 = shell(parent, 36)
        local hit = mk("TextButton", card2, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            Active = true, AutoButtonColor = false, ZIndex = 4,
        })
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(14, 0),
            BackgroundTransparency = 1, Text = txt, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local pill = corner(mk("Frame", card2, {
            Size = UDim2.fromOffset(40, 20), Position = UDim2.new(1, -52, 0.5, -10),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0, ZIndex = 3,
        }), 10)
        local knob = corner(mk("Frame", pill, {
            Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = UIC.dim, BorderSizePixel = 0, ZIndex = 4,
        }), 8)
        local function paint(instant)
            local v = get()
            local pc = v and UIC.acc or UIC.track
            local kc = v and UIC.txt or UIC.dim
            local kp = UDim2.fromOffset(v and 22 or 2, 2)
            if instant then
                pill.BackgroundColor3, knob.BackgroundColor3, knob.Position = pc, kc, kp
            else
                tween(pill, { BackgroundColor3 = pc })
                tween(knob, { BackgroundColor3 = kc, Position = kp })
            end
        end
        hit.MouseButton1Click:Connect(function() fn(); paint() end)
        paint(true)
        return paint
    end

    local function input(parent, txt, hint, get, set)
        local card2 = shell(parent, 52)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -24, 0, 12), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local box = mk("TextBox", card2, {
            Size = UDim2.new(1, -24, 0, 20), Position = UDim2.fromOffset(14, 24),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12,
            TextColor3 = UIC.txt, TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = hint, PlaceholderColor3 = UIC.line,
            ClearTextOnFocus = false, Text = tostring(get() or ""),
            TextTruncate = Enum.TextTruncate.AtEnd, Active = true, ZIndex = 4,
        })
        box.FocusLost:Connect(function() set(box.Text) end)
        return box
    end

    local function slider(parent, txt, min, max, get, set, step)
        step = step or 1
        local card2 = shell(parent, 50)
        mk("TextLabel", card2, {
            Size = UDim2.new(1, -76, 0, 14), Position = UDim2.fromOffset(14, 8),
            BackgroundTransparency = 1, Text = txt, Font = UIF, TextSize = 11,
            TextColor3 = UIC.dim, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 3,
        })
        local val = mk("TextLabel", card2, {
            Size = UDim2.fromOffset(52, 14), Position = UDim2.new(1, -64, 0, 8),
            BackgroundTransparency = 1, Font = UIFB, TextSize = 12, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 3,
        })
        local track = corner(mk("TextButton", card2, {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(14, 32),
            BackgroundColor3 = UIC.track, Text = "", AutoButtonColor = false,
            Active = true, BorderSizePixel = 0, ZIndex = 3,
        }), 3)
        local fill = corner(mk("Frame", track, {
            Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = UIC.acc,
            BorderSizePixel = 0, ZIndex = 4,
        }), 3)
        local knob = corner(mk("Frame", track, {
            Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0), BackgroundColor3 = UIC.txt,
            BorderSizePixel = 0, ZIndex = 5,
        }), 7)

        local function refresh()
            local v = math.clamp(tonumber(get()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, 0, 0.5, 0)
            val.Text = step < 1 and string.format("%.2f", v) or tostring(math.floor(v + 0.5))
        end
        local function applyAt(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            set(math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max))
            refresh()
        end

        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                sliding = true; tween(knob, { Size = UDim2.fromOffset(14, 14) }); applyAt(i.Position.X)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch) then applyAt(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch) then
                sliding = false; tween(knob, { Size = UDim2.fromOffset(10, 10) }); saveTpSettings()
            end
        end)
        refresh()
    end

    do
        local dragging, dragStart, startPos, dragInput
        card.Active = true
        rail.Active, body.Active = true, true

        local function begin(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            dragging, dragStart, startPos = true, i.Position, root.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    _G._stp_panelX = root.Position.X.Offset
                    _G._stp_panelY = root.Position.Y.Offset
                    saveTpSettings()
                end
            end)
        end
        local function track(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then dragInput = i end
        end
        for _, o in ipairs({ card, rail, body }) do
            o.InputBegan:Connect(begin)
            o.InputChanged:Connect(track)
        end
        UIS.InputChanged:Connect(function(i)
            if not dragging or i ~= dragInput then return end
            local d = i.Position - dragStart
            root.Position = UDim2.fromOffset(startPos.X.Offset + d.X, startPos.Y.Offset + d.Y)
        end)
    end

    local home = tab("Home", 1)
    local tune = tab("Tuning", 2)

    label(home, "actions", true)
    action(home, "MANUAL TP", function()
        task.spawn(function()
            if diag() == 0 then return end
            if _G.xyr0StartSideTP then pcall(_G.xyr0StartSideTP)
            else pcall(doVelocityTP, true) end
        end)
    end)

    label(home, "general")
    _G.xyr0RepaintAutoTP = toggle(home, "AUTO TP",
        function() return _G.xyr0AutoTP ~= false end,
        function() _G.xyr0AutoTP = not (_G.xyr0AutoTP ~= false); saveTpSettings() end)

    label(tune, "movement", true)
    _G.xyr0RepaintTPSafe = toggle(tune, "TP SAFE MODE",
        function() return _G.xyr0TPSafeMode ~= false end,
        function() _G.xyr0TPSafeMode = not (_G.xyr0TPSafeMode ~= false); saveTpSettings() end)
    for _, s in ipairs({
        { "TP Velocity",          200,  750, "TPVelocity",        5    },
        { "Rise Speed",           100,  250, "xyr0Climb",       5    },
        { "Go To Brainrot Speed",  80,  600, "xyr0GoSpeed",     5    },
        { "Walk Speed",            16,   29, "xyr0WalkSpeed",   1    },
        { "Landing Delay",       0.05, 0.75, "LandingDelay",      0.05 },
        { "100 Studs Base Speed",  20,  400, "xyr0CloseSpeed",  5    },
    }) do
        slider(tune, s[1], s[2], s[3],
            function() return _G[s[4]] end, function(v) _G[s[4]] = v end, s[5])
    end

    local pri = tab("Priority", 3)
    local refreshPri

    label(pri, "add animal", true)
    do
        local card2 = shell(pri, 36)
        stroke(card2)
        local box = mk("TextBox", card2, {
            Size = UDim2.new(1, -74, 0, 24), Position = UDim2.fromOffset(10, 6),
            BackgroundColor3 = UIC.track, BorderSizePixel = 0,
            Font = UIF, TextSize = 12, TextColor3 = UIC.txt,
            TextXAlignment = Enum.TextXAlignment.Left,
            PlaceholderText = "type a name, then Enter", PlaceholderColor3 = UIC.dim,
            ClearTextOnFocus = false, Text = "", Active = true, ZIndex = 4,
        })
        corner(box, 10)
        mk("UIPadding", box, { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8) })
        local addBtn = corner(mk("TextButton", card2, {
            Size = UDim2.fromOffset(52, 24), Position = UDim2.new(1, -60, 0, 6),
            BackgroundColor3 = UIC.acc, Text = "ADD", Font = UIFB, TextSize = 11,
            TextColor3 = UIC.bg, AutoButtonColor = false, Active = true, ZIndex = 4,
        }), 12)
        local function doAdd()
            local name = (box.Text or ""):match("^%s*(.-)%s*$")
            if name and name ~= "" then
                table.insert(_G.SHARED_PRIORITY_ITEMS, name)
                _G.xyr0PriVersion = (_G.xyr0PriVersion or 0) + 1
                pcall(saveTpSettings)
                box.Text = ""
                if refreshPri then refreshPri() end
            end
        end
        addBtn.MouseButton1Click:Connect(doAdd)
        addBtn.MouseEnter:Connect(function() tween(addBtn, { BackgroundColor3 = UIC.txt }) end)
        addBtn.MouseLeave:Connect(function() tween(addBtn, { BackgroundColor3 = UIC.acc }) end)
        box.FocusLost:Connect(function(enter) if enter then doAdd() end end)
    end

    label(pri, "priority  -  top = highest")
    local rowsHost = mk("Frame", pri, {
        Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.Y, ZIndex = 2,
    })
    mk("UIListLayout", rowsHost, { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

    refreshPri = function()
        for _, c in ipairs(rowsHost:GetChildren()) do
            if c:IsA("GuiObject") then c:Destroy() end
        end
        local L = _G.SHARED_PRIORITY_ITEMS
        for i = 1, #L do
            local nm = tostring(L[i])
            local row = corner(mk("Frame", rowsHost, {
                Size = UDim2.new(1, 0, 0, 30), BackgroundColor3 = UIC.card,
                BorderSizePixel = 0, LayoutOrder = i, ZIndex = 2,
            }), 12)
            stroke(row)
            mk("TextLabel", row, {
                Size = UDim2.new(1, -104, 1, 0), Position = UDim2.fromOffset(12, 0),
                BackgroundTransparency = 1, Text = i .. ".  " .. nm,
                Font = UIF, TextSize = 12, TextColor3 = UIC.txt,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3,
            })
            local function commit()
                _G.xyr0PriVersion = (_G.xyr0PriVersion or 0) + 1
                pcall(saveTpSettings)
                refreshPri()
            end
            local function mini(xoff, sym, act)
                local b = corner(mk("TextButton", row, {
                    Size = UDim2.fromOffset(26, 22), Position = UDim2.new(1, xoff, 0.5, -11),
                    BackgroundColor3 = UIC.track, Text = sym, Font = UIFB, TextSize = 12,
                    TextColor3 = UIC.txt, AutoButtonColor = false, Active = true, ZIndex = 3,
                }), 11)
                b.MouseEnter:Connect(function() tween(b, { BackgroundColor3 = UIC.line }) end)
                b.MouseLeave:Connect(function() tween(b, { BackgroundColor3 = UIC.track }) end)
                b.MouseButton1Click:Connect(act)
                return b
            end
            mini(-98, "\u{25B2}", function() if i > 1 then L[i], L[i - 1] = L[i - 1], L[i]; commit() end end)
            mini(-68, "\u{25BC}", function() if i < #L then L[i], L[i + 1] = L[i + 1], L[i]; commit() end end)
            mini(-36, "\u{2715}", function() table.remove(L, i); commit() end)
        end
    end
    tabOpenHook["Priority"] = refreshPri

    selectTab("Home")
    task.delay(1.5, diag)
end

do
    local RunService = game:GetService("RunService")
    local Lighting   = game:GetService("Lighting")
    local RS         = game:GetService("ReplicatedStorage")
    local LP         = game:GetService("Players").LocalPlayer

    local RAG_STATES = {
        [Enum.HumanoidStateType.Physics]     = true,
        [Enum.HumanoidStateType.Ragdoll]     = true,
        [Enum.HumanoidStateType.FallingDown] = true,
        [Enum.HumanoidStateType.GettingUp]   = true,
    }
    local KILL = {
        BallSocketConstraint = true, NoCollisionConstraint = true, HingeConstraint = true,
        BodyVelocity = true, BodyPosition = true, BodyGyro = true,
    }

    local conns, char, hum, hrp, anim, lastVel = {}, nil, nil, nil, nil, Vector3.zero

    local function ragdolled()
        return hum ~= nil and RAG_STATES[hum:GetState()] == true
    end

    local function cleanup()
        if not char then return end
        pcall(function()
            for _, o in ipairs(char:GetDescendants()) do
                if KILL[o.ClassName] then o:Destroy()
                elseif o:IsA("Motor6D") then o.Enabled = true
                elseif o:IsA("Attachment") and (o.Name == "A" or o.Name == "B") then o:Destroy() end
            end
        end)
        if anim then
            for _, t in pairs(anim:GetPlayingAnimationTracks()) do
                local n = t.Animation and t.Animation.Name:lower() or ""
                if n:find("rag") or n:find("fall") or n:find("hurt") or n:find("down") then t:Stop(0) end
            end
        end
    end

    local function recover()
        hum:ChangeState(Enum.HumanoidStateType.Running)
        cleanup()
        pcall(function() workspace.CurrentCamera.CameraSubject = hum end)
        pcall(function()
            require(LP:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10)):GetControls():Enable()
        end)
    end

    local function bind(c)
        for _, v in pairs(conns) do pcall(function() v:Disconnect() end) end
        conns = {}
        char = c
        hum  = c:WaitForChild("Humanoid", 10)
        hrp  = c:WaitForChild("HumanoidRootPart", 10)
        anim = hum and hum:WaitForChild("Animator", 10)
        lastVel = Vector3.zero
        if not hum then return end

        conns[#conns + 1] = hum.StateChanged:Connect(function()
            if ragdolled() then recover() end
        end)
        conns[#conns + 1] = c.DescendantAdded:Connect(function()
            if ragdolled() then cleanup() end
        end)
        local f = 0
        conns[#conns + 1] = RunService.Heartbeat:Connect(function()
            f = f + 1
            if f < 6 then return end
            f = 0
            if not (ragdolled() and hrp) then return end
            cleanup()
            local v = hrp.AssemblyLinearVelocity
            if (v - lastVel).Magnitude > 40 and v.Magnitude > 25 then
                hrp.AssemblyLinearVelocity = v.Unit * math.min(v.Magnitude, 15)
            end
            lastVel = v
        end)
    end

    LP.CharacterAdded:Connect(function(c) pcall(bind, c) end)
    if LP.Character then pcall(bind, LP.Character) end

    local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true, ColorCorrection = true }
    local function nuke(o) if o and o.Parent and BAD[o.Name] then pcall(function() o:Destroy() end) end end

    local buzz
    local function muteBuzz()
        pcall(function()
            if not (buzz and buzz.Parent) then
                local ctl = RS:FindFirstChild("Controllers")
                local item = ctl and ctl:FindFirstChild("ItemController")
                local bee = item and item:FindFirstChild("BeeLauncherController")
                local s = bee and bee:FindFirstChild("Buzzing")
                if s and s:IsA("Sound") then buzz = s end
            end
            if buzz then
                buzz.Volume = 0
                if buzz.IsPlaying then buzz:Stop() end
            end
        end)
    end

    task.spawn(function()
        LP:WaitForChild("PlayerScripts", 8)
        _G.xyr0BootWait()
        Lighting.DescendantAdded:Connect(nuke)
        do local n = 0
            for _, o in ipairs(Lighting:GetDescendants()) do
                n = n + 1; if n % 150 == 0 then task.wait() end
                nuke(o)
            end
        end
        muteBuzz()
        local acc = 0
        RunService.Heartbeat:Connect(function(dt)
            local cam = workspace.CurrentCamera
            if cam and math.abs(cam.FieldOfView - 20) < 0.01 then
                cam.FieldOfView = tonumber(_G.xyr0FOV) or 70
            end
            acc = acc + dt
            if acc >= 0.5 then acc = 0; muteBuzz() end
        end)
    end)
end

;(function()
    local C = {
        bg   = Color3.fromRGB(18, 18, 18),
        bg2  = Color3.fromRGB(28, 28, 28),
        row  = Color3.fromRGB(42, 42, 42),
        rowH = Color3.fromRGB(58, 58, 58),
        line = Color3.fromRGB(82, 82, 82),
        acc  = Color3.fromRGB(115, 115, 115),
        acc2 = Color3.fromRGB(165, 165, 165),
        txt  = Color3.fromRGB(245, 245, 245),
        dim  = Color3.fromRGB(185, 185, 185),
    }
    local FB, FR = Enum.Font.GothamBold, Enum.Font.Gotham
    local TS = game:GetService("TweenService")
    local EASE = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local function tw(o, p) TS:Create(o, EASE, p):Play() end

    local function mk(cls, parent, props)
        local o = Instance.new(cls)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function round(o, r) mk("UICorner", o, { CornerRadius = UDim.new(0, r or 8) }) return o end

    local host = (gethui and gethui()) or game:GetService("CoreGui")
        or LP:WaitForChild("PlayerGui")
    pcall(function()
        local old = host:FindFirstChild("uiListLayer")
        if old then old:Destroy() end
    end)

    local sg = mk("ScreenGui", nil, {
        Name = "uiListLayer", ResetOnSpawn = false,
        IgnoreGuiInset = true, DisplayOrder = 999998,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = host end)
    if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end

    -- Compact target panel: flat black, no outer rim or shadow.
    local root = mk("Frame", sg, {
        Name = "Root", Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
        -- Wide / tall target panel to match the reference layout.
        Size = UDim2.fromOffset(
            tonumber(_G._xyr0_tgtW) or 245,
            tonumber(_G._xyr0_tgtH) or 300
        ),
        Position = UDim2.fromOffset(tonumber(_G._xyr0_tgtX) or 0,
            tonumber(_G._xyr0_tgtY) or 184),
    })

    mk("UICorner", root, { CornerRadius = UDim.new(0, 12) })

    local head = mk("TextLabel", root, {
        Position = UDim2.fromOffset(10, 6), Size = UDim2.new(1, -46, 0, 24),
        BackgroundTransparency = 1, Text = "TARGETS", Font = FB, TextSize = 14,
        TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
    })
    local count = mk("TextLabel", root, {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -10, 0, 7),
        Size = UDim2.fromOffset(24, 18), BackgroundTransparency = 1,
        Text = "0", Font = FB, TextSize = 11, TextColor3 = C.acc,
        TextXAlignment = Enum.TextXAlignment.Right,
    })
    local modeContainer = mk("Frame", root, {
        Position = UDim2.fromOffset(10, 43), Size = UDim2.new(1, -20, 0, 29),
        BackgroundTransparency = 1,
    })
    mk("UIListLayout", modeContainer, {
        Padding = UDim.new(0, 14), FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
    })
    
    local modeButtons = {}
    local lastModeState = nil
    local function updateAllModes()
        local currentState = _G.xyr0StealMode
        if currentState == lastModeState then return end
        lastModeState = currentState
        for _, btnData in ipairs(modeButtons) do
            local on = currentState == btnData.mode
            tw(btnData.bg, { BackgroundTransparency = on and 0 or 1 })
            tw(btnData.btn, { TextColor3 = on and C.txt or C.dim })
        end
    end
    
    local function modeBtn(txt, mode)
        local btnBg = mk("Frame", modeContainer, {
            Size = UDim2.fromOffset(96, 28), BackgroundColor3 = C.row,
            BorderSizePixel = 0, ZIndex = 1,
        })
        mk("UICorner", btnBg, { CornerRadius = UDim.new(0, 12) })
        local bg = mk("Frame", btnBg, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
        })
        mk("UICorner", bg, { CornerRadius = UDim.new(0, 12) })
        local btn = mk("TextButton", btnBg, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = txt, Font = FB, TextSize = 10, TextColor3 = C.dim,
            AutoButtonColor = false, Active = true, ZIndex = 3,
        })
        btn.MouseButton1Click:Connect(function()
            if _G.xyr0StealMode == mode then
                _G.xyr0StealMode = nil
            else
                _G.xyr0StealMode = mode
            end
            stealOn = _G.xyr0StealMode ~= nil
            saveTpSettings()
            updateAllModes()
        end)
        btn.MouseEnter:Connect(function()
            if _G.xyr0StealMode ~= mode then
                tw(btnBg, { BackgroundColor3 = C.rowH })
            end
        end)
        btn.MouseLeave:Connect(function()
            if _G.xyr0StealMode ~= mode then
                tw(btnBg, { BackgroundColor3 = C.row })
            end
        end)
        table.insert(modeButtons, { btn = btn, bg = bg, mode = mode })
        return btn
    end
    modeBtn("PRIORITY", "priority")
    modeBtn("NEAREST", "nearest")

    task.spawn(function()
        while sg.Parent do
            updateAllModes()
            task.wait(0.2)
        end
    end)

    local list = mk("ScrollingFrame", root, {
        Position = UDim2.fromOffset(7, 82), Size = UDim2.new(1, -14, 1, -88),
        BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 0,
        CanvasSize = UDim2.new(),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
    })
    mk("UIListLayout", list, { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder })

    do
        local on, from, base, tracked
        head.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            on, from, base = true, i.Position, root.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    on = false
                    _G._xyr0_tgtX = root.Position.X.Offset
                    _G._xyr0_tgtY = root.Position.Y.Offset
                    pcall(saveTpSettings)
                end
            end)
        end)
        head.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then tracked = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if not on or i ~= tracked then return end
            local d = i.Position - from
            root.Position = UDim2.fromOffset(base.X.Offset + d.X, base.Y.Offset + d.Y)
        end)
    end

    -- Bottom-right resize handle: drag to change the TARGETS panel size.
    -- Size is kept inside safe bounds and saved in globals for this session.
    local resize = mk("TextButton", root, {
        Name = "ResizeHandle", AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(18, 18),
        BackgroundTransparency = 1, BorderSizePixel = 0, Text = "",
        AutoButtonColor = false, Active = true, ZIndex = 20,
    })
    local resizeMark = mk("Frame", resize, {
        AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0),
        Size = UDim2.fromOffset(10, 2), Rotation = -45,
        BackgroundColor3 = C.dim, BorderSizePixel = 0, ZIndex = 21,
    })

    do
        local resizing, from, baseSize
        resize.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1
                and i.UserInputType ~= Enum.UserInputType.Touch then return end
            resizing = true
            from = i.Position
            baseSize = root.AbsoluteSize
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    resizing = false
                    _G._xyr0_tgtW = root.AbsoluteSize.X
                    _G._xyr0_tgtH = root.AbsoluteSize.Y
                    pcall(saveTpSettings)
                end
            end)
        end)
        resize.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement
                or i.UserInputType == Enum.UserInputType.Touch then
                tracked = i
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if not resizing or i ~= tracked then return end
            local d = i.Position - from
            local w = math.clamp(baseSize.X + d.X, 205, 520)
            local h = math.clamp(baseSize.Y + d.Y, 205, 700)
            root.Size = UDim2.fromOffset(math.floor(w), math.floor(h))
        end)
    end

    local function short(n)
        n = tonumber(n) or 0
        if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
        if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
        if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
        return string.format("%d", n)
    end

    local _CTP_TOL_X, _CTP_TOL_Z = 62, 58
    local function _ctpFloorFromY(y)
        if y >= -6.9 and y <= 8.9 then return 1 end
        if y >= 11 and y <= 23.15 then return 2 end
        if y > 23.15 then return 3 end
        return nil
    end
    local function _ctpFloorFromSlot(slot, py)
        local s = tonumber(slot)
        if s then
            if s >= 19 then return 3 end
            if s >= 11 then return 2 end
            if s >= 1 then return 1 end
        end
        if py then return _ctpFloorFromY(py) end
        return nil
    end
    local function _ctpSameBase(petPos, myPos)
        local pIdx = getClosestBaseIdx(petPos)
        local mIdx = getClosestBaseIdx(myPos)
        if pIdx ~= mIdx then return false end
        local b = BASES_LOW[mIdx]
        if not b then return false end
        return math.abs(myPos.X - b.X) <= _CTP_TOL_X
           and math.abs(myPos.Z - b.Z) <= _CTP_TOL_Z
    end
    local function _ctpAllowed(pet)
        if not pet or not pet.position then return false end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        local myPos = hrp.Position
        if not _ctpSameBase(pet.position, myPos) then return false end
        local myFloor = _ctpFloorFromY(myPos.Y)
        if not myFloor then return false end
        local tgtFloor = _ctpFloorFromSlot(pet.slot, pet.position.Y)
        if not tgtFloor then return false end
        local diff = tgtFloor - myFloor
        local up = tonumber(_G.xyr0ClickTPMaxUp) or 3
        local down = tonumber(_G.xyr0ClickTPMaxDown) or 3
        return diff <= up and diff >= -down
    end

    local rows = {}

    -- Resolve icon IDs from the game's Mutation/Trait data.
    local _iconDataCache = {}
    local function _iconId(v)
        if v == nil then return nil end
        if type(v) == "number" then
            return "rbxassetid://" .. tostring(math.floor(v))
        end
        if type(v) == "string" and v ~= "" then
            if v:match("^rbxassetid://") or v:match("^rbxasset://") or v:match("^https?://") then
                return v
            end
            local n = tonumber(v)
            if n then return "rbxassetid://" .. tostring(math.floor(n)) end
        end
        return nil
    end

    local function _dataModule(name)
        if _iconDataCache[name] ~= nil then
            return _iconDataCache[name] or nil
        end
        local ok, result = pcall(function()
            local d = RS:FindFirstChild("Datas")
            local m = d and d:FindFirstChild(name)
            return m and require(m)
        end)
        if ok and type(result) == "table" then
            _iconDataCache[name] = result
            return result
        end
        _iconDataCache[name] = false
        return nil
    end

    local function _findIcon(data)
        if type(data) ~= "table" then return nil end
        for _, key in ipairs({
            "Icon", "IconId", "IconID", "Image", "ImageId", "ImageID",
            "Texture", "TextureId", "TextureID", "Thumbnail", "ThumbnailId",
        }) do
            local id = _iconId(data[key])
            if id then return id end
        end
        return nil
    end

    local function _mutationIcon(name)
        if not name or name == "" or name == "None" then return nil end
        local md = _dataModule("Mutations")
        return md and _findIcon(md[name]) or nil
    end

    local function _traitIcon(name)
        if not name or name == "" then return nil end
        local td = _dataModule("Traits")
        return td and _findIcon(td[name]) or nil
    end

    local function _clearIcons(holder)
        for _, child in ipairs(holder:GetChildren()) do
            if child:IsA("ImageLabel") then child:Destroy() end
        end
    end

    local function _addIcon(holder, image, order)
        if not image then return end
        mk("ImageLabel", holder, {
            Size = UDim2.fromOffset(13, 13),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Image = image,
            ScaleType = Enum.ScaleType.Fit,
            LayoutOrder = order or 1,
        })
    end

    local function rowFor(uid)
        local r = rows[uid]
        if r and r.card.Parent then return r end

        local card = mk("Frame", list, {
            Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.row,
            BorderSizePixel = 0, Active = true,
        })
        mk("UICorner", card, { CornerRadius = UDim.new(0, 4) })

        local idx = mk("TextLabel", card, {
            Position = UDim2.fromOffset(7, 0), Size = UDim2.fromOffset(14, 38),
            BackgroundTransparency = 1, Text = "1", Font = FR, TextSize = 9,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Center,
            TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 2,
        })

        local bg = mk("Frame", card, {
            Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.acc,
            BackgroundTransparency = 1, BorderSizePixel = 0,
        })
        

        local bar = nil

        local nm = mk("TextLabel", card, {
            Position = UDim2.fromOffset(28, 4), Size = UDim2.new(1, -100, 0, 15),
            BackgroundTransparency = 1, Font = FB, TextSize = 11, TextColor3 = C.txt,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd, Text = "", ZIndex = 2,
        })

        local iconHolder = mk("Frame", card, {
            Position = UDim2.fromOffset(28, 20), Size = UDim2.new(1, -100, 0, 14),
            BackgroundTransparency = 1, ZIndex = 2,
        })
        mk("UIListLayout", iconHolder, {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 2),
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local sub = mk("TextLabel", card, {
            AnchorPoint = Vector2.new(1, 0.5),
            Position = UDim2.new(1, -9, 0, 19),
            Size = UDim2.fromOffset(72, 16),
            BackgroundTransparency = 1, Font = FB, TextSize = 10, TextColor3 = C.acc,
            TextXAlignment = Enum.TextXAlignment.Right, Text = "", ZIndex = 2,
        })

        local hit = mk("TextButton", card, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 3,
        })

        r = {
            card = card, bg = bg, bar = bar, idx = idx, name = nm, sub = sub,
            icons = iconHolder, hit = hit, lastLocked = false,
        }
        rows[uid] = r
        return r
    end

    task.spawn(function()
        local _pd = tonumber(_G.xyr0PanelStartDelay) or 0
        if _pd > 0 then task.wait(_pd) end
        local _filled = false
        local _panelT0 = os.clock()
        while sg.Parent do
            local _pw = os.clock()
            while _filled
                and (_G.xyr0StealHold or (_G.xyr0IsTeleporting and _G.xyr0IsTeleporting()))
                and os.clock() - _pw < (tonumber(_G.xyr0PanelPauseMax) or 3) do
                task.wait(0.2)
            end
            local ok, pets = pcall(scanAllPets)
            if ok and type(pets) == "table" then
                local seen = {}
                for i, p in ipairs(pets) do
                    if not p.conveyor then
                        local uid = _petUid(p)
                        seen[uid] = true
                        local r = rowFor(uid)
                        r.pet = p
                        r.card.LayoutOrder = i
                        if r.idx then r.idx.Text = tostring(i) end
                        r.name.Text = tostring(p.name or "?")
                        r.sub.Text = "$" .. short(p.mps or 0) .. "/s"

                        -- Mutation + Traits: icons only, shown below the brainrot name.
                        _clearIcons(r.icons)
                        local _io = 0
                        local _mi = _mutationIcon(p.mutation)
                        if _mi then
                            _io = _io + 1
                            _addIcon(r.icons, _mi, _io)
                        end
                        if type(p.traits) == "table" then
                            for _, tr in ipairs(p.traits) do
                                local _ti = _traitIcon(tr)
                                if _ti then
                                    _io = _io + 1
                                    _addIcon(r.icons, _ti, _io)
                                end
                            end
                        end
                        local locked = (_G.xyr0StealTargetUID == uid)
                        if locked ~= r.lastLocked then
                            r.lastLocked = locked
                            tw(r.bg, { BackgroundTransparency = 1 })
                            -- No left accent bar.
                            tw(r.card, { BackgroundColor3 = C.row })
                        end
                        if not r.wired then
                            r.wired = true
                            local myUid = uid
                            local _crow = r
                            r.hit.MouseButton1Click:Connect(function()
                                if _G.xyr0StealTargetUID == myUid then
                                    _G.xyr0StealTargetUID = nil
                                    _G.xyr0StealTarget = nil
                                else
                                    _G.xyr0StealTargetUID = myUid
                                    local pet = _crow.pet
                                    do
                                        local okS, fresh = pcall(scanAllPets)
                                        if okS and type(fresh) == "table" then
                                            for _, fp in ipairs(fresh) do
                                                if _petUid(fp) == myUid then pet = fp break end
                                            end
                                        end
                                    end
                                    if pet and pet.position and not isTeleporting
                                        and not _G.xyr0ClickTPBusy
                                        and _ctpAllowed(pet) then
                                        _G.xyr0ClickTPBusy = true
                                        isTeleporting = true
                                        if _G.xyr0ArmSteal then pcall(_G.xyr0ArmSteal, pet) end
                                        task.spawn(function()
                                            pcall(function()
                                                goToBrainrot(pet.position, pet.slot)
                                            end)
                                            isTeleporting = false
                                            _G.xyr0ClickTPBusy = false
                                        end)
                                    end
                                end
                            end)
                            r.hit.MouseEnter:Connect(function()
                                if _G.xyr0StealTargetUID ~= myUid then
                                    tw(r.card, { BackgroundColor3 = C.rowH })
                                end
                            end)
                            r.hit.MouseLeave:Connect(function()
                                if _G.xyr0StealTargetUID ~= myUid then
                                    tw(r.card, { BackgroundColor3 = C.row })
                                end
                            end)
                        end
                    end
                end
                local n = 0
                for uid, r in pairs(rows) do
                    if seen[uid] then n = n + 1
                    else r.card:Destroy() rows[uid] = nil end
                end
                count.Text = tostring(n)
                if n > 0 then _filled = true end
            end
            if not _filled and (os.clock() - _panelT0) < (tonumber(_G.xyr0PanelRush) or 10) then
                task.wait(tonumber(_G.xyr0PanelRushGap) or 0.05)
            else
                task.wait(tonumber(_G.xyr0PanelScanGap) or 0.4)
            end
        end
    end)

    _G.xyr0ToggleTargets = function() sg.Enabled = not sg.Enabled end
end)()

-- ===== MERGED FILE: xyr0z_priv_extras =====

task.wait(3)

local Players         = game:GetService("Players")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local RS              = game:GetService("ReplicatedStorage")
local Lighting        = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local LP              = Players.LocalPlayer

do
    local t0 = os.clock()
    while type(_G.xyr0BootWait) ~= "function" and os.clock() - t0 < 20 do task.wait(0.1) end
end
if type(_G.xyr0BootWait)      ~= "function" then _G.xyr0BootWait = function() end end
if type(_G.xyr0CarpetEngaging) ~= "function" then _G.xyr0CarpetEngaging = function() return false end end
if type(_G.xyr0SaveSettings)   ~= "function" then _G.xyr0SaveSettings = function() end end

local function equipCarpet() if _G.xyr0EquipCarpet then return _G.xyr0EquipCarpet() end end
local function scanAllPets() if _G.xyr0ScanAllPets then return _G.xyr0ScanAllPets() end return {} end

if _G.xyr0AntiFlash        == nil then _G.xyr0AntiFlash        = true end
if _G.xyr0AntiBee          == nil then _G.xyr0AntiBee          = true end
if _G.xyr0InfJump          == nil then _G.xyr0InfJump          = true end
if _G.xyr0InvisDepth       == nil then _G.xyr0InvisDepth       = 4.2  end
if _G.xyr0InvisAngle       == nil then _G.xyr0InvisAngle       = 180  end
if _G.xyr0AlertMinGen      == nil then _G.xyr0AlertMinGen      = 80e6 end
if _G.xyr0CarpetSpeedValue == nil then _G.xyr0CarpetSpeedValue = 140  end
if _G.xyr0FOVEnabled       == nil then _G.xyr0FOVEnabled       = false end

-- FOV enforcement: fully independent of every other feature toggle (it was
-- previously piggybacking on the Anti Bee heartbeat loop, so if that was
-- off, the custom FOV never applied at all and the camera just sat at the
-- game's own default -- which happened to be 70, giving the impression it
-- was "resetting" when really it just never got set in the first place).
task.spawn(function()
    while true do
        if _G.xyr0FOVEnabled then
            local cam = workspace.CurrentCamera
            local target = tonumber(_G.xyr0FOV) or 70
            if cam and math.abs(cam.FieldOfView - target) > 0.1 then
                cam.FieldOfView = target
            end
        end
        task.wait(0.2)
    end
end)

;(function()
    local FX = { ParticleEmitter = true, Beam = true, Trail = true, Fire = true,
        Smoke = true, Sparkles = true, Explosion = true, PointLight = true,
        SpotLight = true, SurfaceLight = true }

    local function kill(item)
        if pcall(function() item:Destroy() end) then return end
        pcall(function()
            for _, d in ipairs(item:GetDescendants()) do
                if d:IsA("BasePart") then
                    d.Transparency = 1
                    d.CanCollide = false
                    d.CanQuery = false
                    d.CastShadow = false
                    d.LocalTransparencyModifier = 1
                elseif FX[d.ClassName] then
                    d.Enabled = false
                elseif d:IsA("Sound") then
                    d.Volume = 0
                    d:Stop()
                end
            end
        end)
    end

    local function strip(char)
        if not char or _G.xyr0AntiFlash == false then return end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Accessory") then kill(item) end
        end
    end

    local hooked = setmetatable({}, { __mode = "k" })
    local function hookChar(char)
        if not char or hooked[char] then return end
        hooked[char] = true
        strip(char)
        char.ChildAdded:Connect(function(c)
            if c:IsA("Accessory") and _G.xyr0AntiFlash ~= false then
                task.defer(kill, c)
            end
        end)
    end
    local function hookPlayer(p)
        if p.Character then task.spawn(hookChar, p.Character) end
        p.CharacterAdded:Connect(hookChar)
    end
    for _, p in ipairs(Players:GetPlayers()) do pcall(hookPlayer, p) end
    Players.PlayerAdded:Connect(hookPlayer)

    workspace.DescendantAdded:Connect(function(d)
        if _G.xyr0AntiFlash == false then return end
        if d.ClassName == "Accessory" then
            local par = d.Parent
            if par and par:FindFirstChildOfClass("Humanoid") then task.defer(kill, d) end
        end
    end)

    task.spawn(function()
        while true do
            if _G.xyr0AntiFlash ~= false then
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character then strip(p.Character) end
                end
                for _, m in ipairs(workspace:GetChildren()) do
                    if m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") then strip(m) end
                end
            end
            task.wait(6) 
        end
    end)
end)()

;(function()
    local TeleportService = game:GetService("TeleportService")
    if _G.xyr0CleanErrStop then pcall(_G.xyr0CleanErrStop) end

    local _ref = cloneref or function(x) return x end
    local GS = _ref(game:GetService("GuiService"))
    local running, conns = true, {}

    task.spawn(function()
        while running do
            pcall(function() GS:ClearError() end)
            task.wait(0.1)
        end
    end)

    conns[#conns + 1] = TeleportService.TeleportInitFailed:Connect(function(plr, result, message, placeId)
        if plr ~= LP then return end
        local name = "Unknown"
        pcall(function() name = result and result.Name or tostring(result) end)
        _G.xyr0CleanErrLast = {
            result = name, message = tostring(message or ""),
            placeId = placeId, at = os.clock(),
        }
    end)

    _G.xyr0CleanErrStop = function()
        running = false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        _G.xyr0CleanErrStop = nil
    end
end)()

;(function()
    local held = false
    local function hop()
        local c = LP.Character
        local hrp = c and c:FindFirstChild("HumanoidRootPart")
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower or 50, hrp.Velocity.Z)
    end
    local function on() return _G.xyr0InfJump ~= false end
    UIS.JumpRequest:Connect(function() if on() then hop() end end)
    UIS.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.Space then held = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space then held = false end
    end)
    RunService.Heartbeat:Connect(function() if held and on() then hop() end end)
end)()




if _G.AntiDieDisabled == nil then _G.AntiDieDisabled = false end
task.spawn(function()
local __P = game:GetService("Players")
while not __P.LocalPlayer do task.wait() end
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
            
            if _G.xyr0StealHold and hum.Health < hum.MaxHealth then
                pcall(function() hum.Health = hum.MaxHealth end)
            end
            local char = hum.Parent
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if char and hrp then
                local state = hum:GetState()
                local _rag = (state == Enum.HumanoidStateType.Physics
                    or state == Enum.HumanoidStateType.Ragdoll
                    or state == Enum.HumanoidStateType.FallingDown)
                if not _rag then
                    local _et = tonumber(LP:GetAttribute("RagdollEndTime"))
                    if _et and (_et - workspace:GetServerTimeNow()) > 0 then _rag = true end
                end
                if _rag then
                    pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
                    pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                    if not _G.__xyr0ResetBusy and LP:GetAttribute("Stealing") ~= true then
                        pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end)
                    end
                    local cam = workspace.CurrentCamera
                    if cam and cam.CameraSubject ~= hum then
                        pcall(function() cam.CameraSubject = hum end)
                    end
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("BallSocketConstraint") or (obj.Name and obj.Name:find("RagdollAttachment")) then
                            pcall(function() obj:Destroy() end)
                        end
                    end
                end
            end
            if hum:GetState() == Enum.HumanoidStateType.Dead then
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

;(function()
    local Lighting = game:GetService("Lighting")
    local BAD = { Blue = true, DiscoEffect = true, BeeBlur = true,
        Flashbang = true, ColorCorrection = true }
    local function on() return _G.xyr0AntiBee ~= false end

    local function nuke(o)
        if on() and o and o.Parent and BAD[o.Name] then pcall(function() o:Destroy() end) end
    end

    local buzz
    local function muteBuzz()
        if not on() then return end
        pcall(function()
            if not (buzz and buzz.Parent) then
                local ctl = RS:FindFirstChild("Controllers")
                local item = ctl and ctl:FindFirstChild("ItemController")
                local bee = item and item:FindFirstChild("BeeLauncherController")
                local s = bee and bee:FindFirstChild("Buzzing")
                if s and s:IsA("Sound") then buzz = s end
            end
            if buzz then
                buzz.Volume = 0
                if buzz.IsPlaying then buzz:Stop() end
            end
        end)
    end

    local guarded = {}
    local function guard(Controls, original)
        if not Controls or guarded[Controls] then return end
        local base = original or Controls.moveFunction
        if not base then return end
        local function safeMove(self, mv, rtc) return base(self, mv, rtc) end
        guarded[Controls] = safeMove
        Controls.moveFunction = safeMove
        RunService.Heartbeat:Connect(function()
            if not on() then return end
            if Controls.moveFunction ~= safeMove then Controls.moveFunction = safeMove end
        end)
    end
    local function protect()
        pcall(function()
            local cc = RS:FindFirstChild("Controllers")
            local mod = cc and cc:FindFirstChild("CharacterController")
            local m = mod and require(mod)
            if type(m) == "table" then guard(m.Controls, m.originalMoveFunction) end
        end)
        pcall(function()
            local ps = LP:WaitForChild("PlayerScripts", 5)
            local pm = ps and ps:FindFirstChild("PlayerModule")
            if pm then guard(require(pm):GetControls()) end
        end)
    end

    task.spawn(function()
        LP:WaitForChild("PlayerScripts", 8)
        _G.xyr0BootWait()
        Lighting.DescendantAdded:Connect(nuke)
        do local n = 0
            for _, o in ipairs(Lighting:GetDescendants()) do
                n = n + 1; if n % 150 == 0 then task.wait() end
                nuke(o)
            end
        end
        protect()
        local acc = 1
        RunService.Heartbeat:Connect(function(dt)
            if not on() then return end
            local cam = workspace.CurrentCamera
            if cam and math.abs(cam.FieldOfView - 20) < 0.01 then
                cam.FieldOfView = tonumber(_G.xyr0FOV) or 70
            end
            acc = acc + dt
            if acc < 0.5 then return end
            acc = 0
            muteBuzz()
            
        end)
    end)
    LP.CharacterAdded:Connect(function() task.delay(1, protect) end)
end)()

;(function()
    local active, conns = false, {}
    local realHRP, cloneHRP, track, hip, origT
    local stuck, restarting = false, false
    local start, stop

    local function depth()
        return 0.01 + (math.clamp(tonumber(_G.xyr0InvisDepth) or 4.2, 0, 10) / 10) * 0.19
    end
    local function angle()
        return math.clamp(tonumber(_G.xyr0InvisAngle) or 0, 0, 360)
    end
    local function add(c) conns[#conns + 1] = c end
    local function rewire(char, from, to)
        for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("Weld") or v:IsA("Motor6D") then
                if v.Part0 == from then v.Part0 = to end
                if v.Part1 == from then v.Part1 = to end
            end
        end
    end

    stop = function()
        active, stuck = false, false
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns = {}
        if origT then
            for p, v in pairs(origT) do
                if p and p.Parent then pcall(function() p.LocalTransparencyModifier = v end) end
            end
            origT = nil
        end
        if track then
            pcall(function() track:AdjustSpeed(1) track:Stop(0) track:Destroy() end)
            track = nil
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if realHRP and realHRP:IsDescendantOf(game) and hum then
            local tmp = Instance.new("Model")
            tmp.Parent = game
            char.Parent = tmp
            realHRP.Parent = char
            char.PrimaryPart = realHRP
            char.Parent = workspace
            realHRP.CanCollide = true
            rewire(char, cloneHRP, realHRP)
            if cloneHRP then
                local at = cloneHRP.CFrame
                cloneHRP:Destroy()
                cloneHRP = nil
                realHRP.CFrame = at
            end
            hum.HipHeight = hip or 0
            tmp:Destroy()
        end
        realHRP, cloneHRP = nil, nil
        _G.xyr0InvisActive = false
    end

    local function animTrick(char, hum)
        if not (char and hum and hum.Health > 0) then return end
        local a = Instance.new("Animation")
        a.AnimationId = "http://www.roblox.com/asset/?id=18537363391"
        local animator = hum:FindFirstChildOfClass("Animator") or Instance.new("Animator", hum)
        track = animator:LoadAnimation(a)
        track.Priority = Enum.AnimationPriority.Action4
        track.Looped = true
        track:Play(0, 1, 0)
        a:Destroy()
        add(track.Stopped:Connect(function()
            if active then animTrick(char, hum) end
        end))
        task.defer(function()
            if not track then return end
            track.TimePosition = 0.7
            task.delay(0.1, function() if track then track:AdjustSpeed(math.huge) end end)
        end)
    end

    start = function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum or active then return false end

        local folder = workspace:FindFirstChild(LP.Name)
        if folder then
            for _, n in ipairs({ "DoubleRig", "Constraints" }) do
                local x = folder:FindFirstChild(n)
                if x then x:Destroy() end
            end
            add(folder.ChildAdded:Connect(function(c)
                if c.Name == "DoubleRig" or c.Name == "Constraints" then c:Destroy() end
            end))
        end
        for _, s in ipairs({ "Dead", "FallingDown", "Ragdoll" }) do
            hum:SetStateEnabled(Enum.HumanoidStateType[s], false)
        end

        hip = hum.HipHeight
        realHRP = char:FindFirstChild("HumanoidRootPart")
        if not (realHRP and realHRP.Parent) then return false end

        local tmp = Instance.new("Model")
        tmp.Parent = game
        char.Parent = tmp
        cloneHRP = realHRP:Clone()
        cloneHRP.Parent = char
        realHRP.Parent = workspace.CurrentCamera
        cloneHRP.CFrame = realHRP.CFrame
        char.PrimaryPart = cloneHRP
        char.Parent = workspace
        rewire(char, realHRP, cloneHRP)
        tmp:Destroy()

        active = true
        animTrick(char, hum)

        origT = {}
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                origT[p] = p.LocalTransparencyModifier
                p.LocalTransparencyModifier = 1
            end
        end
        add(char.DescendantAdded:Connect(function(d)
            if not (active and d:IsA("BasePart")) then return end
            if origT and origT[d] == nil then origT[d] = d.LocalTransparencyModifier end
            pcall(function() d.LocalTransparencyModifier = 1 end)
        end))

        add(RunService.Heartbeat:Connect(function()
            if not active or not hum.Parent then return end
            hum.Health = hum.MaxHealth
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            local st = hum:GetState()
            if st == Enum.HumanoidStateType.Dead or st == Enum.HumanoidStateType.FallingDown
                or st == Enum.HumanoidStateType.Ragdoll then
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end
        end))

        -- Keep the hidden root perfectly aligned with the visible character.
        -- Do not rotate it upside-down or apply a vertical offset: those were
        -- the main causes of the "head hitting the ground" / abnormal movement.
        add(RunService.PreSimulation:Connect(function()
            if not (active and realHRP and realHRP.Parent and hum.Parent and hum.Health > 0) then
                return
            end

            local base = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
            if not (base and base:IsA("BasePart")) then return end

            -- Keep the real/hidden root slightly below the visible body,
            -- matching the original pet-on-ground placement, but do NOT
            -- rotate the character upside-down.
            local groundOffset = hum.HipHeight + (base.Size.Y / 2) - 1 + depth()
            local cf = base.CFrame - Vector3.new(0, groundOffset, 0)
            realHRP.CFrame = cf * CFrame.Angles(math.rad(angle()), 0, 0)
            realHRP.AssemblyLinearVelocity = base.AssemblyLinearVelocity
            realHRP.AssemblyAngularVelocity = base.AssemblyAngularVelocity
            realHRP.CanCollide = false

            if realHRP.Parent ~= workspace.CurrentCamera then
                realHRP.Parent = workspace.CurrentCamera
            end
        end))

        add(LP.CharacterAdded:Connect(function() if active then stop() end end))
        _G.xyr0InvisActive = true
        return true
    end

    _G.xyr0InvisStart, _G.xyr0InvisStop = start, stop
    _G.xyr0InvisToggle = function()
        if active then stop() else start() end
    end

    local armed, autoOn = false, false
    local function syncAuto()
        local want = (_G.xyr0InvisAuto == true) and (LP:GetAttribute("Stealing") == true)
        if not want then
            armed = false
            if active and autoOn then autoOn = false pcall(stop) end
            return
        end
        if active or armed then return end
        armed = true
        task.delay(tonumber(_G.xyr0InvisAutoDelay) or 1.5, function()
            armed = false
            if _G.xyr0InvisAuto == true and not active
                and LP:GetAttribute("Stealing") == true then
                autoOn = true
                pcall(start)
            end
        end)
    end
    _G.xyr0InvisSync = syncAuto
    LP:GetAttributeChangedSignal("Stealing"):Connect(syncAuto)
end)()

;(function()
    local function strip()
        local c = LP.Character
        local h = c and c:FindFirstChild("HumanoidRootPart")
        if not h or not getconnections or not getinfo then return end
        for _, s in ipairs({ "CFrame", "Position" }) do
            pcall(function()
                for _, cn in ipairs(getconnections(h:GetPropertyChangedSignal(s))) do
                    if cn.Function and cn.Enabled then
                        local ok, info = pcall(getinfo, cn.Function)
                        if ok and info and tostring(info.source) == "=ReplicatedFirst.test" then
                            pcall(function() cn:Disable() end)
                        end
                    end
                end
            end)
        end
    end
    _G.xyr0StripAC = strip
    task.spawn(function() _G.xyr0BootWait() while true do pcall(strip) task.wait(3) end end) 
    LP.CharacterAdded:Connect(function() task.wait(0.3) pcall(strip) end)
end)()

;(function()
    local wsConn

    _G.xyr0SetWalkSpeed = function(enabled)
        _G.xyr0WalkSpeedOn = enabled == true
        if wsConn then pcall(function() wsConn:Disconnect() end) wsConn = nil end
        if not _G.xyr0WalkSpeedOn then return end

        wsConn = RunService.Heartbeat:Connect(function(dt)
            if not _G.xyr0WalkSpeedOn then return end
            pcall(function()
                if LP:GetAttribute("Stealing") ~= true then return end

                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not char or not hum or hum.Health <= 0 then return end

                -- Invisible creates a visible clone as Character.PrimaryPart while
                -- the real HumanoidRootPart is temporarily moved to the camera.
                -- Always move the active body root, never a stale HRP reference.
                local root = char.PrimaryPart or char:FindFirstChild("HumanoidRootPart")
                if not root or not root:IsA("BasePart") or not root.Parent then return end

                local move = hum.MoveDirection
                if move.Magnitude <= 0.001 then return end

                local speed = math.clamp(tonumber(_G.xyr0WalkSpeed) or 29, 5, 32)
                local current = math.max(tonumber(hum.WalkSpeed) or 0, 0)
                local extra = math.max(speed - current, 0)
                if extra <= 0 then return end

                local step = math.min(tonumber(dt) or 0.016, 0.05)
                local delta = move.Unit * extra * step
                root.CFrame = root.CFrame + delta

                -- Keep the real root at the same position during Invisible so
                -- carried pets/items do not remain at the old position.
                if _G.xyr0InvisActive == true then
                    local real = char:FindFirstChild("HumanoidRootPart")
                    if real and real ~= root and real:IsA("BasePart") and real.Parent then
                        real.CFrame = root.CFrame
                        real.AssemblyLinearVelocity = root.AssemblyLinearVelocity
                    end
                end
            end)
        end)
    end

    if _G.xyr0WalkSpeedOn == nil then _G.xyr0WalkSpeedOn = true end
    if _G.xyr0WalkSpeedOn == true then
        task.defer(function() pcall(_G.xyr0SetWalkSpeed, true) end)
    end
end)()

;(function()
    local conn
    _G.xyr0SetCarpetSpeed = function(enabled)
        _G.xyr0CarpetSpeed = enabled and true or false
        if conn then conn:Disconnect() conn = nil end
        if not _G.xyr0CarpetSpeed then return end
        task.spawn(function() pcall(equipCarpet) end)
        conn = RunService.Heartbeat:Connect(function()
            if LP:GetAttribute("Stealing") == true then
                _G.xyr0SetCarpetSpeed(false)
                return
            end
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            local part = c and (c:FindFirstChild("UpperTorso")
                or c:FindFirstChild("Torso")
                or c:FindFirstChild("HumanoidRootPart"))
            if not hum or not part then return end
            if not _G.xyr0CarpetEngaging() then pcall(equipCarpet) end
            local spd = math.clamp(tonumber(_G.xyr0CarpetSpeedValue) or 140, 20, 400)
            local md, keepY = hum.MoveDirection, part.Velocity.Y
            if md.Magnitude > 0 then
                part.Velocity = Vector3.new(md.X * spd, keepY, md.Z * spd)
            else
                part.Velocity = Vector3.new(0, keepY, 0)
            end
        end)
    end

    UIS.InputBegan:Connect(function(i, g)
        if g or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
        if i.KeyCode.Name ~= (_G.xyr0CarpetSpeedKeyName or "Q") then return end
        if LP:GetAttribute("Stealing") == true then return end
        local on = not (_G.xyr0CarpetSpeed == true)
        _G.xyr0SetCarpetSpeed(on)
        if on then task.spawn(function() pcall(equipCarpet) end) end
    end)
end)()

;(function()
    local FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser",
        "Decorations", "Skin", "Unlock", "Purchases" }
    local orig = setmetatable({}, { __mode = "k" })
    local conns, gen = {}, 0

    local function paint(o, a)
        if not o:IsA("BasePart") then return end
        if orig[o] == nil then orig[o] = (o.Transparency == a) and 0 or o.Transparency end
        local base = orig[o]
        if base >= 1 then return end
        local want = base + (1 - base) * a
        if math.abs(o.Transparency - want) > 0.01 then o.Transparency = want end
    end

    local function calm()
        while _G.xyr0StealHold do task.wait(0.15) end
    end

    local function track(root, a, id)
        if not root or id ~= gen then return end
        paint(root, a)
        local n = 0
        for _, d in ipairs(root:GetDescendants()) do
            if id ~= gen then return end
            paint(d, a)
            n = n + 1
            if n % 250 == 0 then task.wait() end
        end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(d)
            if id == gen then paint(d, a) end
        end)
    end

    local function doPlot(plot, a, id)
        if not plot or id ~= gen then return end
        for _, fname in ipairs(FOLDERS) do
            if id ~= gen then return end
            track(plot:FindFirstChild(fname), a, id)
        end
        if id ~= gen then return end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
            if id ~= gen then return end
            for _, fname in ipairs(FOLDERS) do
                if c.Name == fname then track(c, a, id) break end
            end
        end)
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return end
        local function pod(pd)
            for _, c in ipairs(pd:GetChildren()) do
                if c.Name == "Claim" then track(c, a, id)
                elseif c.Name == "Base" then track(c:FindFirstChild("Decorations"), a, id) end
            end
        end
        for _, pd in ipairs(pods:GetChildren()) do pod(pd) end
        conns[#conns + 1] = pods.ChildAdded:Connect(function(pd)
            if id ~= gen then return end
            task.wait(0.1)
            if id == gen then pod(pd) end
        end)
    end

    local function stop()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        conns, gen = {}, gen + 1
    end

    _G.xyr0EnableXray = function()
        stop()
        local id = gen
        local a = math.clamp(tonumber(_G.xyr0XrayAlpha) or 0.9, 0, 1)
        task.spawn(function()
            while id == gen and not workspace:FindFirstChild("Plots") do task.wait(0.5) end
            local plots = workspace:FindFirstChild("Plots")
            if id ~= gen or not plots then return end
            calm()
            for _, p in ipairs(plots:GetChildren()) do
                if id ~= gen then return end
                pcall(doPlot, p, a, id)
                task.wait()
                calm()
            end
            conns[#conns + 1] = plots.ChildAdded:Connect(function(p)
                if id ~= gen then return end
                task.wait(0.2)
                pcall(doPlot, p, a, id)
            end)
        end)
    end

    _G.xyr0DisableXray = function()
        stop()
        local snap = orig
        orig = setmetatable({}, { __mode = "k" })
        for o, t in pairs(snap) do
            pcall(function() if o:IsA("BasePart") then o.Transparency = t end end)
        end
    end

    _G.xyr0ToggleXray = function()
        _G.xyr0Xray = not (_G.xyr0Xray ~= false)
        if _G.xyr0Xray then _G.xyr0EnableXray() else _G.xyr0DisableXray() end
        return _G.xyr0Xray
    end

    task.spawn(function()
        _G.xyr0BootWait()
        task.wait(tonumber(_G.xyr0XrayDelay) or 1)
        if _G.xyr0Xray ~= false then _G.xyr0EnableXray() end
    end)
end)()

;(function()
    local function psCode(link)
        link = tostring(link or ""):match("^%s*(.-)%s*$")
        if link == "" then return nil end
        if not link:find("://", 1, true) then return link end
        return link:match("[?&]privateServerLinkCode=([^&]+)")
            or link:match("[?&]linkCode=([^&]+)")
            or link:match("[?&]code=([^&]+)")
    end

    local function kickOut()
        if _G.xyr0KickToPS == true then
            local code = psCode(_G.xyr0PrivateServerLink)
            if code and code ~= "" then
                local ok = pcall(function()
                    game:GetService("ExperienceService"):LaunchExperience({
                        placeId = tonumber(_G.xyr0PrivateServerPlaceId) or game.PlaceId,
                        linkCode = code,
                    })
                end)
                if ok then return end
            end
        end
        if pcall(function() game:Shutdown() end) then return end
        pcall(function() LP:Kick("") end)
    end
    _G.xyr0KickOut = kickOut

    task.spawn(function()
        local PG2 = LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 10)
        if not PG2 then return end
        local hooked = setmetatable({}, { __mode = "k" })
        local function hit(t)
            return type(t) == "string" and t:lower():find("you stole", 1, true) ~= nil
        end
        local function isText(o)
            return o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")
        end
        local function watch(o)
            if hooked[o] then return end
            hooked[o] = true
            if _G.xyr0AutoKickOnSteal == true and hit(o.Text) then kickOut() return end
            o:GetPropertyChangedSignal("Text"):Connect(function()
                if _G.xyr0AutoKickOnSteal == true and hit(o.Text) then kickOut() end
            end)
        end
        local function root(g)
            g.DescendantAdded:Connect(function(d) if isText(d) then watch(d) end end)
            local n = 0
            for _, d in ipairs(g:GetDescendants()) do
                n = n + 1
                if n % 200 == 0 then task.wait() end
                if isText(d) then watch(d) end
            end
        end

        while _G.xyr0AutoKickOnSteal ~= true do task.wait(1) end
        PG2.ChildAdded:Connect(root)
        for _, g in ipairs(PG2:GetChildren()) do root(g) end
    end)
end)()

;(function()
    local seen, snd, lastAt = {}, nil, 0

    _G.xyr0AlertCheck = function(pets)
        if _G.xyr0PriAlert ~= true then
            if next(seen) then seen = {} end
            return
        end
        local minGen = tonumber(_G.xyr0AlertMinGen) or 80e6
        local live, fresh = {}, false
        for _, p in ipairs(pets) do
            if p._pri or (tonumber(p.mps) or 0) >= minGen then
                local k = tostring(p.plot) .. "_" .. tostring(p.slot)
                live[k] = true
                if not seen[k] then fresh = true end
            end
        end
        seen = live
        if not fresh or os.clock() - lastAt < 3 then return end
        lastAt = os.clock()
        pcall(function()
            local id = tostring(_G.xyr0AlertSound or "111786441593851"):match("%d+")
            if not id then return end
            if not (snd and snd.Parent) then
                snd = Instance.new("Sound")
                snd.Name = "xyr0Alert"
                snd.Parent = game:GetService("SoundService")
            end
            snd.SoundId = "rbxassetid://" .. id
            snd.Volume = math.clamp(tonumber(_G.xyr0AlertVolume) or 1, 0, 10)
            snd:Play()
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if _G.xyr0PriAlert == true then
                local ok, pets = pcall(scanAllPets)
                if ok and type(pets) == "table" then pcall(_G.xyr0AlertCheck, pets) end
            end
        end
    end)
end)()



pcall(function() game:GetService("Players").RespawnTime = 0 end)  

do
    local RunService = game:GetService("RunService")
    local Players    = game:GetService("Players")
    local Workspace  = game:GetService("Workspace")
    local _wfConns, _wfActive = {}, false
    local function stopWalkFling()
        _wfActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c) == "RBXScriptConnection" then pcall(function() c:Disconnect() end) end
        end
        _wfConns = {}
    end
    local function startWalkFling()
        _wfActive = true
        local ch = LP.Character
        if not ch then return end
        local rr = ch:FindFirstChild("HumanoidRootPart")
        for _, o in pairs(Workspace.CurrentCamera:GetChildren()) do
            if o.Name == "HumanoidRootPart" then rr = o break end
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
                RunService.Heartbeat:Wait()
                if not rr or not rr.Parent then break end
                local v = rr.Velocity
                rr.Velocity = v * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if rr then rr.Velocity = v end
                RunService.Stepped:Wait()
                if rr then rr.Velocity = v + Vector3.new(0, 0.1, 0) end
            end
        end)
        coroutine.resume(co)
        table.insert(_wfConns, co)
    end
    _G.DropBrainrot = function()
        if _wfActive then return end
        startWalkFling()
        task.delay(0.4, stopWalkFling)
    end
    _G.stopWalkFling = stopWalkFling
end


local CARPET_NAMES = { "Flying Carpet", "Waverider", "Santa's Sleigh", "Witch's Broom", "Cupid's Wings" }
_G.__xyr0ResetBusy = false
_G.xyr0ResetCooldown = tonumber(_G.xyr0ResetCooldown) or 2.5
_G.xyr0ResetFlingTime = tonumber(_G.xyr0ResetFlingTime) or 5
_G.xyr0InstaReset = function()
    local _now = os.clock()
    if _G.__xyr0ResetBusy
        and (_now - (tonumber(_G.__xyr0ResetAt) or 0)) < (tonumber(_G.xyr0ResetCooldown) or 2.5) then
        return
    end
    _G.__xyr0ResetBusy = true
    _G.__xyr0ResetAt = _now
    task.spawn(function()
        local RunService = game:GetService("RunService")
        local _prevAntiDie = _G.AntiDieDisabled
        _G.AntiDieDisabled = true
        _G.xyr0StealHold = false
        local _restored, _holding = false, true
        local function _restore()
            if _restored then return end
            _restored = true
            _holding = false
            _G.AntiDieDisabled = _prevAntiDie
            _G.__xyr0ResetBusy = false
        end
        local _conn
        _conn = LP.CharacterAdded:Connect(function(newChar)
            if _conn then _conn:Disconnect(); _conn = nil end
            task.defer(function()
                pcall(function() newChar:WaitForChild("Humanoid", 12) end)
                RunService.Heartbeat:Wait()
                _restore()
            end)
        end)
        task.delay(8, function() if _conn then _conn:Disconnect(); _conn = nil end _restore() end)

        pcall(function()
            local char = LP.Character
            if not char then return end
            local _isCarpet = {}
            for _, n in ipairs(CARPET_NAMES) do _isCarpet[n] = true end
            pcall(equipCarpet)
            local _origChar = char
            task.spawn(function()
                local RS2 = game:GetService("RunService")
                while _holding and LP.Character == _origChar do
                    pcall(equipCarpet)
                    RS2.Heartbeat:Wait()
                end
            end)
            local bp = LP:FindFirstChild("Backpack")
            if bp then
                for _, ch in ipairs(char:GetChildren()) do
                    if ch:IsA("Tool") and not _isCarpet[ch.Name] then pcall(function() ch.Parent = bp end) end
                end
            end
            local function _flingPart()
                local c = LP.Character
                if not c then return nil end
                return c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso")
                    or c:FindFirstChild("HumanoidRootPart")
            end
            local _t0 = os.clock()
            while os.clock() - _t0 < (tonumber(_G.xyr0ResetFlingTime) or 5) do
                if LP.Character ~= _origChar then break end
                local _h = _origChar:FindFirstChildOfClass("Humanoid")
                if not _h or _h.Health <= 0 or _h:GetState() == Enum.HumanoidStateType.Dead then break end
                local part = _flingPart()
                if not part then break end
                pcall(function()
                    for _, o in ipairs(part:GetChildren()) do
                        if o:IsA("BodyPosition") or o:IsA("BodyVelocity") or o:IsA("BodyGyro")
                            or o:IsA("AlignPosition") or o:IsA("LinearVelocity") then
                            o:Destroy()
                        end
                    end
                end)
                pcall(function() part.Velocity = Vector3.new(0, 9999999, 0) end)
                RunService.Heartbeat:Wait()
            end
        end)
    end)
end

task.spawn(function()
    local _fired = false
    while true do
        if _G.xyr0AutoClone == true then
            if not _fired
                and LP:GetAttribute("Stealing") ~= true
                and not (_G.xyr0IsTeleporting and _G.xyr0IsTeleporting()) then
                _fired = true
                if _G.xyr0DoClone then pcall(_G.xyr0DoClone) end
                if _G.xyr0AutoCloneOneShot ~= false then
                    _G.xyr0AutoClone = false
                    if _G.xyr0RepaintAutoClone then pcall(_G.xyr0RepaintAutoClone) end
                end
            end
        else
            _fired = false
        end
        task.wait(0.15)
    end
end)

_G.xyr0AutoTPKeyName = _G.xyr0AutoTPKeyName or "T"
_G.xyr0AutoBuyKeyName = _G.xyr0AutoBuyKeyName or "Y"

local function _kb(input, name)
    return type(name) == "string" and name ~= "" and input.KeyCode.Name == name
end
UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if _G.xyr0BindListening then return end   

    if _kb(input, _G.xyr0CloneKeyName) then
        _G.xyr0AutoClone = not (_G.xyr0AutoClone == true)
    end
    
    if _kb(input, _G.xyr0KickKeyName) then
        task.spawn(function()
            _G.xyr0KickToPS = true
            if _G.xyr0KickOut then pcall(_G.xyr0KickOut) end
        end)
    end
    
    if _kb(input, _G.xyr0StopTPKeyName) then
        _G.xyr0TPStop = true
        _G.xyr0AutoTP = false
        if _G.xyr0RepaintAutoTP then pcall(_G.xyr0RepaintAutoTP) end
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if hrp then pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero end) end
    end
    
    if _kb(input, _G.xyr0NearestKey) then
        _G.xyr0StealMode = (_G.xyr0StealMode == "nearest") and "priority" or "nearest"
    end
    
    if _kb(input, _G.xyr0DropKeyName) then
        task.spawn(function() if _G.DropBrainrot then pcall(_G.DropBrainrot) end end)
    end
    
    if _kb(input, _G.xyr0ResetKeyName) then
        task.spawn(function()
            if _G.xyr0InstaReset then
                pcall(_G.xyr0InstaReset)
            end
        end)
    end

    -- AUTO TELEPORT keybind
    if _kb(input, _G.xyr0AutoTPKeyName) then
        _G.xyr0AutoTP = not (_G.xyr0AutoTP == true)
        if _G.xyr0RepaintAutoTP then pcall(_G.xyr0RepaintAutoTP) end
        pcall(_G.xyr0SaveSettings)
    end

    -- AUTO BUY keybind
    if _kb(input, _G.xyr0AutoBuyKeyName) then
        _G.xyr0AutoBuy = not (_G.xyr0AutoBuy == true)
        if _G.xyr0RepaintAutoBuy then pcall(_G.xyr0RepaintAutoBuy) end
        pcall(_G.xyr0SaveSettings)
    end
end)


if _G.xyr0AutoBuy == nil then _G.xyr0AutoBuy = false end
if _G.xyr0AutoBuyRange == nil then _G.xyr0AutoBuyRange = 17 end
if _G.xyr0AutoBuyHover == nil then _G.xyr0AutoBuyHover = 9 end
_G.xyr0RepaintAutoBuy = _G.xyr0RepaintAutoBuy or function() end


do
    local Workspace = game:GetService("Workspace")
    local lockedPrompt, lockedPart, lockedModel
    local bodyPos, purchaseRemote

    local function resolvePurchaseRemote()
        if purchaseRemote and purchaseRemote.Parent then return purchaseRemote end
        pcall(function()
            local net = RS:FindFirstChild("Packages") and RS.Packages:FindFirstChild("Net")
            if not net then return end
            for _, v in ipairs(net:GetChildren()) do
                local nl = (v.Name or ""):lower()
                for _, kw in ipairs({ "buy", "purchase", "animal", "shop", "acquire", "conveyor" }) do
                    if nl:find(kw) then purchaseRemote = v; return end
                end
            end
        end)
        return purchaseRemote
    end

    local function firePurchase(prompt)
        if not (prompt and prompt.Parent and prompt.Enabled) then return false end
        local fired = false
        pcall(function() prompt.HoldDuration = 0 end)
        if fireproximityprompt then
            for _ = 1, 2 do
                local ok = pcall(function() fireproximityprompt(prompt) end)
                if ok then fired = true end
                task.wait()
                if not (prompt.Parent and prompt.Enabled) then break end
            end
        end
        -- Only use a discovered purchase remote when the game exposes one;
        -- do not assume an unrelated RemoteEvent's argument shape.
        local r = resolvePurchaseRemote()
        if r and prompt.Parent then
            pcall(function()
                if r:IsA("RemoteFunction") then
                    local ok = pcall(function() r:InvokeServer(prompt.Parent) end)
                    fired = fired or ok
                elseif r:IsA("RemoteEvent") then
                    local ok = pcall(function() r:FireServer(prompt.Parent) end)
                    fired = fired or ok
                end
            end)
        end
        return fired
    end

    local function partAlive()
        return lockedPart and lockedPart.Parent and lockedModel and lockedModel.Parent
    end
    local function promptAlive()
        return lockedPrompt and lockedPrompt.Parent and lockedPrompt.Enabled
    end

    local function hoverPart(char)
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end
    local function ensureBodyPos(part)
        if bodyPos and bodyPos.Parent == part then return bodyPos end
        if bodyPos then bodyPos:Destroy() end
        local bp = Instance.new("BodyPosition")
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.P = 20000
        bp.D = 1200
        bp.Position = part.Position
        bp.Parent = part
        bodyPos = bp
        return bp
    end
    local function destroyBodyPos()
        if bodyPos then pcall(function() bodyPos:Destroy() end); bodyPos = nil end
    end

    local _promptCache, _promptCacheAt = nil, 0
    local function allPrompts()
        if _promptCache and os.clock() - _promptCacheAt < 5 then return _promptCache end
        local out, n = {}, 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            n = n + 1
            if n % 3000 == 0 then task.wait() end
            if obj:IsA("ProximityPrompt") then out[#out + 1] = obj end
        end
        _promptCache, _promptCacheAt = out, os.clock()
        return out
    end
    Workspace.DescendantAdded:Connect(function(d)
        if _G.xyr0AutoBuy ~= true or not _promptCache then return end
        if d:IsA("ProximityPrompt") then _promptCache[#_promptCache + 1] = d end
    end)

    local function scanConveyor()
        local results = {}
        for _, obj in ipairs(allPrompts()) do
            if obj.Parent and obj.Enabled then
                local tx = (obj.ActionText or ""):lower()
                if tx:find("purchase") or tx:find("comprar") or tx:find("buy") then
                    local part = obj.Parent
                    local realPart = (part and part:IsA("Attachment") and part.Parent) or part
                    if realPart and realPart:IsA("BasePart") then
                        local model, cur = nil, realPart
                        for _ = 1, 8 do
                            if cur and cur:IsA("Model") then model = cur; break end
                            cur = cur and cur.Parent
                        end
                        results[#results + 1] = { prompt = obj, part = realPart, model = model }
                    end
                end
            end
        end
        return results
    end

    local _abRag = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    local _abSweep, _abHarden = 0, 0
    RunService.Heartbeat:Connect(function()
        if _G.xyr0AutoBuy ~= true or not partAlive() then destroyBodyPos(); return end
        local char = LP.Character
        local part = char and hoverPart(char)
        if not part then destroyBodyPos(); return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local ragged = false
        if hum then
            local now = os.clock()
            if now - _abHarden > 0.5 then
                _abHarden = now
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false) end)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false) end)
                pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
                pcall(function() hum.BreakJointsOnDeath = false end)
            end
            ragged = _abRag[hum:GetState()] == true
            local et = tonumber(LP:GetAttribute("RagdollEndTime"))
            if et and (et - workspace:GetServerTimeNow()) > 0 then ragged = true end
            if ragged then
                pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
                local cam = workspace.CurrentCamera
                if cam and cam.CameraSubject ~= hum then
                    pcall(function() cam.CameraSubject = hum end)
                end
                if now - _abSweep > 0.25 then
                    _abSweep = now
                    for _, o in ipairs(char:GetDescendants()) do
                        if o:IsA("BallSocketConstraint") or o.Name == "RagdollAttachment" then
                            pcall(function() o:Destroy() end)
                        end
                    end
                end
            end
        end
        local hover = tonumber(_G.xyr0AutoBuyHover) or 9
        if _G.__xyr0ResetBusy then return end
        local goal = lockedPart.Position + Vector3.new(0, hover, 0)
        if ragged then
            pcall(function() part.AssemblyAngularVelocity = Vector3.zero end)
        end
        local bp = ensureBodyPos(part)
        bp.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bp.P = 20000
        bp.D = 1000
        bp.Position = goal
        if (part.Position - goal).Magnitude > (tonumber(_G.xyr0AutoBuySnap) or 60) then
            pcall(function()
                part.CFrame = CFrame.new(goal)
                part.AssemblyLinearVelocity = Vector3.zero
                part.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)

    RunService.Heartbeat:Connect(function()
        if _G.xyr0AutoBuy ~= true or not partAlive() or not promptAlive() then return end
        firePurchase(lockedPrompt)
    end)

    task.spawn(function()
        while true do
            task.wait(0.1)
            if _G.xyr0AutoBuy ~= true then
                lockedPrompt, lockedPart, lockedModel = nil, nil, nil
                destroyBodyPos()
            elseif lockedPart or lockedModel then
                if not partAlive() then lockedPrompt, lockedPart, lockedModel = nil, nil, nil end
            else
                local ok, found = pcall(scanConveyor)
                local list = (ok and found) or {}
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local best, bestDist = nil, math.huge
                    local radius = tonumber(_G.xyr0AutoBuyRange) or 17
                    for _, e in ipairs(list) do
                        if e.prompt and e.prompt.Parent and e.prompt.Enabled and e.part and e.part.Parent then
                            local d = (hrp.Position - e.part.Position).Magnitude
                            if d <= radius and d < bestDist then bestDist = d; best = e end
                        end
                    end
                    if best then
                        lockedPrompt, lockedPart, lockedModel = best.prompt, best.part, best.model or best.part.Parent
                        pcall(function() best.prompt.HoldDuration = 0 end)
                        resolvePurchaseRemote()
                        firePurchase(best.prompt)
                    end
                end
            end
        end
    end)
end

if _G.xyr0FaceAway == nil then _G.xyr0FaceAway = false end
if _G.xyr0FaceAwayNearest == nil then _G.xyr0FaceAwayNearest = false end

do
    local Workspace = game:GetService("Workspace")
    local function getRoot(pl)
        local c = pl and pl.Character
        return c and c:FindFirstChild("HumanoidRootPart")
    end
    local function findNearest(myRoot)
        local best, bestD = nil, math.huge
        for _, pl in ipairs(Players:GetPlayers()) do
            if pl ~= LP then
                local r = getRoot(pl)
                if r then
                    local d = (r.Position - myRoot.Position).Magnitude
                    if d < bestD then best, bestD = pl, d end
                end
            end
        end
        return best
    end
    local function getPlotAtPosition(pos)
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local best, bestD = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            local pp
            if plot:IsA("Model") then
                pp = (plot.PrimaryPart and plot.PrimaryPart.Position) or plot:GetPivot().Position
            else
                pp = plot.Position
            end
            if pp then
                local dx, dz = pos.X - pp.X, pos.Z - pp.Z
                local d = math.sqrt(dx * dx + dz * dz)
                if d < bestD then bestD, best = d, plot end
            end
        end
        return (best and bestD < 72) and best or nil
    end
    local function getPlotOwner(plot)
        if not plot then return nil end
        local sign = plot:FindFirstChild("PlotSign")
        local lbl = sign
            and sign:FindFirstChild("SurfaceGui")
            and sign.SurfaceGui:FindFirstChild("Frame")
            and sign.SurfaceGui.Frame:FindFirstChild("TextLabel")
        if lbl then
            local nick = (lbl.Text and lbl.Text:match("^(.-)'")) or lbl.Text
            if nick and nick ~= "" then
                for _, pl in ipairs(Players:GetPlayers()) do
                    if pl.DisplayName == nick or pl.Name == nick then return pl end
                end
            end
        end
        return nil
    end
    local _ownerCache, _ownerAt = nil, 0
    local function resolveTarget(myRoot)
        if _G.xyr0FaceAwayNearest == true then
            return findNearest(myRoot)
        end
        if os.clock() - _ownerAt > 0.5 then
            _ownerAt = os.clock()
            local owner = getPlotOwner(getPlotAtPosition(myRoot.Position))
            _ownerCache = (owner ~= LP) and owner or nil
        end
        return _ownerCache
    end
    local _faceWasOn, _stealSince = false, nil
    local function faceActive()
        if _G.xyr0FaceAway ~= true then
            _stealSince = nil
            return false
        end
        if LP:GetAttribute("Stealing") ~= true then
            _stealSince = nil
            return false
        end
        if not _stealSince then
            _stealSince = os.clock()
            return false
        end
        return (os.clock() - _stealSince) >= (tonumber(_G.xyr0FaceAwayDelay) or 2)
    end
    local function faceAwayStep()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not faceActive() then
            if _faceWasOn then
                _faceWasOn = false
                if hum then pcall(function() hum.AutoRotate = true end) end
            end
            return
        end
        _faceWasOn = true
        local myRoot = getRoot(LP)
        if not myRoot then return end
        if hum and hum.AutoRotate then pcall(function() hum.AutoRotate = false end) end
        local tRoot = getRoot(resolveTarget(myRoot))
        if not tRoot then return end
        local flat = Vector3.new(
            tRoot.Position.X - myRoot.Position.X,
            0,
            tRoot.Position.Z - myRoot.Position.Z
        )
        if flat.Magnitude < 0.05 then return end
        myRoot.CFrame = CFrame.lookAt(myRoot.Position, myRoot.Position + Vector3.new(-flat.Z, 0, flat.X).Unit)
        local av = myRoot.AssemblyAngularVelocity
        if av.Y ~= 0 then
            myRoot.AssemblyAngularVelocity = Vector3.new(av.X, 0, av.Z)
        end
    end
    RunService.RenderStepped:Connect(faceAwayStep)
    RunService.Heartbeat:Connect(faceAwayStep)
end

do
    local TweenService = game:GetService("TweenService")
    -- xyr0 Extras palette matched to the reference image:
    -- dark charcoal panels + teal/green accent + light Gotham typography.
    local C = {
        bg = Color3.fromRGB(18, 18, 18),
        card = Color3.fromRGB(40, 40, 40),
        line = Color3.fromRGB(82, 82, 82),
        acc = Color3.fromRGB(115, 115, 115),
        txt = Color3.fromRGB(245, 245, 245),
        dim = Color3.fromRGB(185, 185, 185),
        track = Color3.fromRGB(62, 62, 62),
        acc2 = Color3.fromRGB(165, 165, 165),
    }
    local FB, FR = Enum.Font.GothamBold, Enum.Font.Gotham
    local EASE = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local function tw(o, p) TweenService:Create(o, EASE, p):Play() end
    local function mk(cls, parent, props)
        local o = Instance.new(cls)
        for k, v in pairs(props or {}) do o[k] = v end
        o.Parent = parent
        return o
    end
    local function corner(o, r) mk("UICorner", o, { CornerRadius = UDim.new(0, r or 4) }) return o end

    local host = (gethui and gethui()) or game:GetService("CoreGui")
    pcall(function()
        local old = host:FindFirstChild("xyr0Extras")
        if old then old:Destroy() end
    end)
    local sg = mk("ScreenGui", nil, {
        Name = "xyr0Extras", ResetOnSpawn = false, IgnoreGuiInset = true,
        DisplayOrder = 999997, ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    })
    pcall(function() sg.Parent = host end)
    if not sg.Parent then sg.Parent = LP:WaitForChild("PlayerGui") end

    local function makeDrag(frame, handle, keyX, keyY)
        local on, from, base, tracked
        handle.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
            on, from, base = true, i.Position, frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    on = false
                    if keyX then _G[keyX] = frame.Position.X.Offset end
                    if keyY then _G[keyY] = frame.Position.Y.Offset end
                    pcall(_G.xyr0SaveSettings)
                end
            end)
        end)
        handle.InputChanged:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then tracked = i end
        end)
        UIS.InputChanged:Connect(function(i)
            if not on or i ~= tracked then return end
            local d = i.Position - from
            frame.Position = UDim2.fromOffset(base.X.Offset + d.X, base.Y.Offset + d.Y)
        end)
    end

    local _ord = 0
    local function nextOrd() _ord = _ord + 1 return _ord end
    local _toggleRepaints = {}

    local function toggle(parent, label, get, set)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 12,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local pill = corner(mk("Frame", card, {
            Size = UDim2.fromOffset(38, 18), Position = UDim2.new(1, -48, 0.5, -9),
            BackgroundColor3 = C.track, BorderSizePixel = 0,
        }), 9)
        local knob = corner(mk("Frame", pill, {
            Size = UDim2.fromOffset(14, 14), Position = UDim2.fromOffset(2, 2),
            BackgroundColor3 = C.dim, BorderSizePixel = 0,
        }), 7)
        local hit = mk("TextButton", card, { Size = UDim2.fromScale(1,1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, Active = true })
        local _last
        local function paint(instant)
            local v = get() and true or false
            if v == _last and not instant then return end
            _last = v
            local pc = v and C.acc or C.track
            local kc = v and C.bg or C.dim
            local kp = UDim2.fromOffset(v and 22 or 2, 2)
            if instant then pill.BackgroundColor3, knob.BackgroundColor3, knob.Position = pc, kc, kp
            else tw(pill, { BackgroundColor3 = pc }); tw(knob, { BackgroundColor3 = kc, Position = kp }) end
        end
        hit.MouseButton1Click:Connect(function() set(); paint(); pcall(_G.xyr0SaveSettings) end)
        paint(true)
        _toggleRepaints[#_toggleRepaints + 1] = paint
    end

    local function slider(parent, label, min, max, get, set, step)
        step = step or 1
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 44), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -60, 0, 14), Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 11,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local val = mk("TextLabel", card, {
            Size = UDim2.fromOffset(48, 14), Position = UDim2.new(1, -56, 0, 6),
            BackgroundTransparency = 1, Font = Enum.Font.Code, TextSize = 12, TextColor3 = C.acc2,
            TextXAlignment = Enum.TextXAlignment.Right,
        })
        local track = corner(mk("TextButton", card, {
            Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 30),
            BackgroundColor3 = C.track, Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        }), 3)
        local fill = corner(mk("Frame", track, { Size = UDim2.new(0,0,1,0), BackgroundColor3 = C.acc, BorderSizePixel = 0 }), 3)
        local function refresh()
            local v = math.clamp(tonumber(get()) or min, min, max)
            local rel = (v - min) / math.max(max - min, 1e-6)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            val.Text = step < 1 and string.format("%.2f", v) or tostring(math.floor(v + 0.5))
        end
        local function apply(x)
            local rel = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            set(math.clamp(math.floor((min + (max - min) * rel) / step + 0.5) * step, min, max))
            refresh()
        end
        local sliding = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then sliding = true; apply(i.Position.X) end
        end)
        UIS.InputChanged:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then apply(i.Position.X) end
        end)
        UIS.InputEnded:Connect(function(i)
            if sliding and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then sliding = false; pcall(_G.xyr0SaveSettings) end
        end)
        refresh()
    end

    local function input(parent, label, hint, get, set)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 46), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -20, 0, 12), Position = UDim2.fromOffset(12, 6),
            BackgroundTransparency = 1, Text = label, Font = FR, TextSize = 10,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local box = mk("TextBox", card, {
            Size = UDim2.new(1, -20, 0, 18), Position = UDim2.fromOffset(12, 22),
            BackgroundTransparency = 1, Font = FB, TextSize = 12, TextColor3 = C.txt,
            TextXAlignment = Enum.TextXAlignment.Left, PlaceholderText = hint, PlaceholderColor3 = C.line,
            ClearTextOnFocus = false, Text = tostring(get() or ""), TextTruncate = Enum.TextTruncate.AtEnd,
        })
        box.FocusLost:Connect(function() set(box.Text); pcall(_G.xyr0SaveSettings) end)
    end

    local function keybind(parent, labelTxt, getName, setName)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        mk("TextLabel", card, {
            Size = UDim2.new(1, -104, 1, 0), Position = UDim2.fromOffset(12, 0),
            BackgroundTransparency = 1, Text = labelTxt, Font = FR, TextSize = 12,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local btn = corner(mk("TextButton", card, {
            Size = UDim2.fromOffset(84, 22), Position = UDim2.new(1, -96, 0.5, -11),
            BackgroundColor3 = C.track, Text = "", Font = FB, TextSize = 11,
            TextColor3 = C.txt, AutoButtonColor = false, Active = true,
        }), 4)
        local listening, conn = false, nil
        local function repaint()
            if listening then btn.Text = "..."; return end
            local k = getName()
            btn.Text = (type(k) == "string" and k ~= "") and k or "NONE"
        end
        local function stop()
            listening = false
            _G.xyr0BindListening = false
            if conn then conn:Disconnect(); conn = nil end
            tw(btn, { BackgroundColor3 = C.track })
            repaint()
        end
        btn.MouseButton1Click:Connect(function()
            if listening then stop(); return end
            listening = true
            _G.xyr0BindListening = true
            tw(btn, { BackgroundColor3 = C.line })
            repaint()
            conn = UIS.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                local kn = inp.KeyCode.Name
                if kn == "Escape" or kn == "Backspace" or kn == "Delete" then setName(nil) else setName(kn) end
                stop()
                pcall(_G.xyr0SaveSettings)
            end)
        end)
        btn.MouseButton2Click:Connect(function()
            if listening then stop(); return end
            setName(nil); repaint(); pcall(_G.xyr0SaveSettings)
        end)
        repaint()
    end

    local function action(parent, label, fn)
        local card = corner(mk("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 32), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)
        local btn = mk("TextButton", card, {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = label,
            Font = FB, TextSize = 12, TextColor3 = C.acc, AutoButtonColor = false, Active = true,
        })
        btn.MouseEnter:Connect(function() tw(card, { BackgroundColor3 = C.track }) end)
        btn.MouseLeave:Connect(function() tw(card, { BackgroundColor3 = C.card }) end)
        btn.MouseButton1Click:Connect(fn)
    end

    local function makeSub(titleText, sx, sy, keyX, keyY)
        local frame = corner(mk("Frame", sg, {
            Name = titleText, Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
            Size = UDim2.fromOffset(248, 380), Visible = false,
            Position = UDim2.fromOffset(tonumber(_G[keyX]) or sx, tonumber(_G[keyY]) or sy),
        }), 6)
        mk("UIStroke", frame, { Thickness = 1, Transparency = 0.4, Color = C.acc })
        local head = mk("TextLabel", frame, {
            Position = UDim2.fromOffset(14, 12), Size = UDim2.new(1, -52, 0, 18),
            BackgroundTransparency = 1, Text = titleText, Font = FB, TextSize = 13,
            TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left,
        })
        local close = corner(mk("TextButton", frame, {
            Size = UDim2.fromOffset(24, 20), Position = UDim2.new(1, -32, 0, 11),
            BackgroundColor3 = C.card, Text = "X", Font = FB, TextSize = 11,
            TextColor3 = C.txt, AutoButtonColor = false, Active = true,
        }), 4)
        close.MouseButton1Click:Connect(function() frame.Visible = false end)
        local list = mk("ScrollingFrame", frame, {
            Position = UDim2.fromOffset(0, 40), Size = UDim2.new(1, 0, 1, -48),
            BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
            ScrollBarImageColor3 = C.line, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        })
        mk("UIListLayout", list, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })
        mk("UIPadding", list, { PaddingTop = UDim.new(0,4), PaddingBottom = UDim.new(0,10), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) })
        makeDrag(frame, head, keyX, keyY)
        return frame, list
    end

    local featFrame, featList = makeSub("FEATURES", 560, 250, "_xyr0_fX", "_xyr0_fY")
    local keysFrame, keysList = makeSub("KEYBINDS", 560, 250, "_xyr0_kX", "_xyr0_kY")

    local main = corner(mk("Frame", sg, {
        Name = "Main", Active = true, BackgroundColor3 = C.bg, BorderSizePixel = 0,
        Size = UDim2.fromOffset(240, 0), AutomaticSize = Enum.AutomaticSize.Y,
        Position = UDim2.fromOffset(tonumber(_G._xyr0_exX) or 300, tonumber(_G._xyr0_exY) or 250),
    }), 6)
    mk("UIStroke", main, { Thickness = 1, Transparency = 0.4, Color = C.acc })
    mk("UIListLayout", main, { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, HorizontalAlignment = Enum.HorizontalAlignment.Center })
    mk("UIPadding", main, { PaddingTop = UDim.new(0,12), PaddingBottom = UDim.new(0,12), PaddingLeft = UDim.new(0,12), PaddingRight = UDim.new(0,12) })
    local mHead = mk("TextLabel", main, {
        Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Text = "XYR0Z PRIV",
        Font = FB, TextSize = 12, TextColor3 = C.txt, TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = nextOrd(),
    })
    makeDrag(main, mHead, "_xyr0_exX", "_xyr0_exY")

    local navRow = mk("Frame", main, { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, LayoutOrder = nextOrd() })
    mk("UIListLayout", navRow, { Padding = UDim.new(0, 8), FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Center, VerticalAlignment = Enum.VerticalAlignment.Center })
    local function navBtn(txt)
        local b = corner(mk("TextButton", navRow, {
            Size = UDim2.fromOffset(100, 28), BackgroundColor3 = C.card, Text = txt,
            Font = FB, TextSize = 11, TextColor3 = C.txt, AutoButtonColor = false, Active = true,
        }), 4)
        b.MouseEnter:Connect(function() tw(b, { BackgroundColor3 = C.track }) end)
        b.MouseLeave:Connect(function() tw(b, { BackgroundColor3 = C.card }) end)
        return b
    end
    local featBtn = navBtn("FEATURES")
    local keysBtn = navBtn("KEYBINDS")
    featBtn.MouseButton1Click:Connect(function() keysFrame.Visible = false; featFrame.Visible = not featFrame.Visible end)
    keysBtn.MouseButton1Click:Connect(function() featFrame.Visible = false; keysFrame.Visible = not keysFrame.Visible end)

    toggle(main, "AUTO INVIS ON STEAL",
        function() return _G.xyr0InvisAuto == true end,
        function() _G.xyr0InvisAuto = not (_G.xyr0InvisAuto == true); if _G.xyr0InvisSync then pcall(_G.xyr0InvisSync) end end)
    slider(main, "Invis Depth", 0, 10, function() return _G.xyr0InvisDepth end, function(v) _G.xyr0InvisDepth = v end, 0.1)
    slider(main, "Invis Rotation", 0, 360, function() return _G.xyr0InvisAngle end, function(v) _G.xyr0InvisAngle = v end, 1)
    toggle(main, "AUTO KICK ON STEAL",
        function() return _G.xyr0AutoKickOnSteal == true end,
        function() _G.xyr0AutoKickOnSteal = not (_G.xyr0AutoKickOnSteal == true) end)
    toggle(main, "AUTO BUY",
        function() return _G.xyr0AutoBuy == true end,
        function()
            _G.xyr0AutoBuy = not (_G.xyr0AutoBuy == true)
            if _G.xyr0RepaintAutoBuy then pcall(_G.xyr0RepaintAutoBuy) end
            pcall(_G.xyr0SaveSettings)
        end)

    -- ============================================================
    -- WALK SPEED: 24 / 29 buttons
    -- Two large buttons, evenly split across the card width, with
    -- the active speed highlighted in the teal accent colour.
    -- ============================================================
    if _G.xyr0WalkSpeed == nil then _G.xyr0WalkSpeed = 24 end
    if _G.xyr0WalkSpeedOn == nil then _G.xyr0WalkSpeedOn = true end
    do
        local card = corner(mk("Frame", main, {
            Size = UDim2.new(1, 0, 0, 54), BackgroundColor3 = C.card,
            BorderSizePixel = 0, LayoutOrder = nextOrd(),
        }), 4)

        mk("TextLabel", card, {
            Size = UDim2.new(1, -20, 0, 14), Position = UDim2.fromOffset(10, 7),
            BackgroundTransparency = 1, Text = "WALKSPEED", Font = FB, TextSize = 11,
            TextColor3 = C.dim, TextXAlignment = Enum.TextXAlignment.Left,
        })

        -- Container row: stretches across the card with 8px side padding,
        -- buttons split via UIListLayout so both stay perfectly even.
        local row = mk("Frame", card, {
            Size = UDim2.new(1, -16, 0, 26), Position = UDim2.fromOffset(8, 24),
            BackgroundTransparency = 1,
        })
        mk("UIListLayout", row, {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
        })

        local btns = {}
        local function paintSpeeds()
            local cur = tonumber(_G.xyr0WalkSpeed) or 24
            local on  = _G.xyr0WalkSpeedOn ~= false
            for v, b in pairs(btns) do
                local active = on and (v == cur)
                b.BackgroundColor3 = active and C.acc or C.track
                b.TextColor3     = active and C.bg  or C.txt
            end
        end

        local function speedButton(txt)
            local v = tonumber(txt) or 24
            -- 0.5 scale width minus half of the 8px gap => perfectly even split
            local b = corner(mk("TextButton", row, {
                Size = UDim2.new(0.5, -4, 1, 0),
                BackgroundColor3 = C.track, Text = txt,
                Font = FB, TextSize = 14, TextColor3 = C.txt,
                AutoButtonColor = false, BorderSizePixel = 0,
                LayoutOrder = v,
            }), 4)
            b.MouseEnter:Connect(function()
                if not ((_G.xyr0WalkSpeedOn ~= false) and ((tonumber(_G.xyr0WalkSpeed) or 24) == v)) then
                    tw(b, { BackgroundColor3 = C.line })
                end
            end)
            b.MouseLeave:Connect(function() paintSpeeds() end)
            b.MouseButton1Click:Connect(function()
                _G.xyr0WalkSpeed = v
                _G.xyr0WalkSpeedOn = true
                if _G.xyr0SetWalkSpeed then pcall(_G.xyr0SetWalkSpeed, true) end
                paintSpeeds()
                pcall(_G.xyr0SaveSettings)
            end)
            btns[v] = b
            return b
        end

        speedButton("24")
        speedButton("29")
        paintSpeeds()

        -- Keep the buttons visually in sync if anything else changes the value.
        _toggleRepaints[#_toggleRepaints + 1] = paintSpeeds
    end

    action(main, "KICK", function()
        task.spawn(function() if _G.xyr0KickOut then pcall(_G.xyr0KickOut) end end)
    end)

    toggle(featList, "ANTI FLASH",             function() return _G.xyr0AntiFlash ~= false end,      function() _G.xyr0AntiFlash = not (_G.xyr0AntiFlash ~= false) end)
    toggle(featList, "ANTI BEE",               function() return _G.xyr0AntiBee ~= false end,        function() _G.xyr0AntiBee = not (_G.xyr0AntiBee ~= false) end)
    toggle(featList, "INF JUMP",               function() return _G.xyr0InfJump ~= false end,        function() _G.xyr0InfJump = not (_G.xyr0InfJump ~= false) end)
    toggle(featList, "ANTI DIE",               function() return _G.AntiDieDisabled ~= true end,       function() _G.AntiDieDisabled = (_G.AntiDieDisabled ~= true) end)
    toggle(featList, "WALK SPEED",             function() return _G.xyr0WalkSpeedOn ~= false end,    function() if _G.xyr0SetWalkSpeed then _G.xyr0SetWalkSpeed(_G.xyr0WalkSpeedOn == false) end end)
    toggle(featList, "CARPET SPEED",           function() return _G.xyr0CarpetSpeed == true end,     function() if _G.xyr0SetCarpetSpeed then _G.xyr0SetCarpetSpeed(not (_G.xyr0CarpetSpeed == true)) end end)
    toggle(featList, "XRAY BASES",             function() return _G.xyr0Xray ~= false end,           function() if _G.xyr0ToggleXray then _G.xyr0ToggleXray() end end)
    toggle(featList, "AUTO KICK ON STEAL",     function() return _G.xyr0AutoKickOnSteal == true end, function() _G.xyr0AutoKickOnSteal = not (_G.xyr0AutoKickOnSteal == true) end)
    toggle(featList, "KICK TO PRIVATE SERVER", function() return _G.xyr0KickToPS == true end,        function() _G.xyr0KickToPS = not (_G.xyr0KickToPS == true) end)
    toggle(featList, "PRIORITY ALERT",         function() return _G.xyr0PriAlert == true end,        function() _G.xyr0PriAlert = not (_G.xyr0PriAlert == true) end)
    toggle(featList, "FACE AWAY",              function() return _G.xyr0FaceAway == true end,        function() _G.xyr0FaceAway = not (_G.xyr0FaceAway == true) end)
    toggle(featList, "FACE AWAY: NEAREST",     function() return _G.xyr0FaceAwayNearest == true end, function() _G.xyr0FaceAwayNearest = not (_G.xyr0FaceAwayNearest == true) end)
    toggle(featList, "FOV",                    function() return _G.xyr0FOVEnabled == true end,      function() _G.xyr0FOVEnabled = not (_G.xyr0FOVEnabled == true) end)
    slider(featList, "FOV Value", 50, 120, function() return tonumber(_G.xyr0FOV) or 70 end, function(v) _G.xyr0FOV = v end, 1)
    slider(featList, "Auto Buy Range", 5, 40, function() return _G.xyr0AutoBuyRange end, function(v) _G.xyr0AutoBuyRange = v end, 1)
    slider(featList, "Auto Buy Float", 0, 20, function() return _G.xyr0AutoBuyHover end, function(v) _G.xyr0AutoBuyHover = v end, 1)
    slider(featList, "Carpet Speed", 20, 400, function() return _G.xyr0CarpetSpeedValue end, function(v) _G.xyr0CarpetSpeedValue = v end, 5)
    slider(featList, "Alert Min M/s", 0, 500, function() return (tonumber(_G.xyr0AlertMinGen) or 80e6)/1e6 end, function(v) _G.xyr0AlertMinGen = v * 1e6 end, 5)
    input(featList, "PRIVATE SERVER LINK", "paste link or share code", function() return _G.xyr0PrivateServerLink end, function(v) _G.xyr0PrivateServerLink = (v or ""):match("^%s*(.-)%s*$") end)
    input(featList, "ALERT SOUND ID", "111786441593851", function() return _G.xyr0AlertSound end, function(v) _G.xyr0AlertSound = (v or ""):match("%d+") or "111786441593851" end)

    keybind(keysList, "AUTO CLONE",             function() return _G.xyr0CloneKeyName end,   function(k) _G.xyr0CloneKeyName = k end)
    keybind(keysList, "KICK TO PRIVATE SERVER", function() return _G.xyr0KickKeyName end,    function(k) _G.xyr0KickKeyName = k end)
    keybind(keysList, "STOP TP",                function() return _G.xyr0StopTPKeyName end,  function(k) _G.xyr0StopTPKeyName = k end)
    keybind(keysList, "PRIORITY / NEAREST",     function() return _G.xyr0NearestKey end,     function(k) _G.xyr0NearestKey = k end)
    keybind(keysList, "DROP BRAINROT",          function() return _G.xyr0DropKeyName end,    function(k) _G.xyr0DropKeyName = k end)
    keybind(keysList, "INSTA RESET",            function() return _G.xyr0ResetKeyName end,   function(k) _G.xyr0ResetKeyName = k end)
    keybind(keysList, "AUTO TELEPORT",          function() return _G.xyr0AutoTPKeyName end,  function(k) _G.xyr0AutoTPKeyName = k end)
    keybind(keysList, "AUTO BUY",               function() return _G.xyr0AutoBuyKeyName end, function(k) _G.xyr0AutoBuyKeyName = k end)

    task.spawn(function()
        while sg.Parent do
            for _, r in ipairs(_toggleRepaints) do pcall(r) end
            task.wait(0.3)
        end
    end)
end