-- shako.win | v6.7.62 · Menu Key modo TOGGLE (1 press abre, 1 cierra)
-- Avatar mundo + crash fixes · stable boot · no ESP reconnect leak

-- Boot: 1 sola instancia. Si FALLA el load, se puede reintentar.
-- Si ya cargó bien, ejecutar otra vez NO abre segunda UI.
pcall(function()
    if not game:IsLoaded() then game.Loaded:Wait() end
end)

-- Si falló un load anterior (sin UI), permitir reintento
if getgenv().antiSleepy_loaded then
    if getgenv()._ShakoUIReady == true then
        return -- instancia real activa
    end
    -- load a medias → limpiar y reintentar
    getgenv().antiSleepy_loaded = false
end
getgenv().antiSleepy_loaded = true
getgenv().config = getgenv().config -- placeholder


-- ==================== AXIS/HARION ANTI-CHEAT BYPASS ====================
pcall(function()
(function()
    -- 1) Yukleme ekrani tamamen kapanana kadar bekle (autoexec'te oyun acilmadan donmayi onler)
    local players = game:GetService("Players")
    local coreGui = game:GetService("CoreGui")
    if not game:IsLoaded() then game.Loaded:Wait() end
    local player = players.LocalPlayer
    while not player do
        players:GetPropertyChangedSignal("LocalPlayer"):Wait()
        player = players.LocalPlayer
    end
    local playerGui = player:WaitForChild("PlayerGui")
    local function isActiveLoadingGui(object)
        local n = object.Name:lower():gsub("[%s_%-]", "")
        if n ~= "loadingscreen" and not n:find("loadingscreen", 1, true) then return false end
        local cur = object
        while cur and cur ~= playerGui and cur ~= coreGui do
            if cur:IsA("LayerCollector") and not cur.Enabled then return false end
            if cur:IsA("GuiObject") and not cur.Visible then return false end
            cur = cur.Parent
        end
        return object:IsDescendantOf(playerGui) or object:IsDescendantOf(coreGui)
    end
    local clearSince
    local t0 = os.clock()
    repeat
        local loading = false
        for _, root in ipairs({ playerGui, coreGui }) do
            local ok, list = pcall(function() return root:GetDescendants() end)
            if ok then
                for _, object in ipairs(list) do
                    if isActiveLoadingGui(object) then loading = true break end
                end
            end
            if loading then break end
        end
        clearSince = loading and nil or (clearSince or os.clock())
        task.wait(0.1)
    until (clearSince and os.clock() - clearSince >= 0.5) or os.clock() - t0 > 60

    -- 2) Anti-cheat hook'lari (oturum basina bir kez)
    local genvL = getgenv()
    if genvL.__ShakoStartupHooks then return end
    genvL.__ShakoStartupHooks = true
    local function ncc(fn) return (type(newcclosure) == "function" and newcclosure(fn)) or fn end
    local cref = (type(cloneref) == "function" and cloneref) or function(o) return o end
    if type(setthreadidentity) == "function" then pcall(setthreadidentity, 8) end

    -- anti-cheat modullerinin zayif (weak) tablolarini etkisizlestir
    local okEnv, renv = pcall(function() return getrenv() end)
    local smt = okEnv and type(renv) == "table" and renv.setmetatable or nil
    if type(hookfunction) == "function" and smt then
        local oldSmt = smt
        local okHook, hooked = pcall(hookfunction, smt, ncc(function(Table, Metatable)
            if Metatable and type(Metatable) == "table" and rawget(Metatable, "__mode") then
                local mode = rawget(Metatable, "__mode")
                if mode == "kv" or mode == "v" or mode == "k" then
                    local okT, trace = pcall(debug.traceback)
                    trace = okT and trace or ""
                    if trace:find("MiscellaneousController", 1, true)
                        or trace:find("CameraSecurity", 1, true)
                        or trace:find("AnalyticsPipelineController", 1, true) then
                        return oldSmt({ 1, 2, 3 }, {})
                    end
                end
            end
            return oldSmt(Table, Metatable)
        end))
        if okHook and hooked then oldSmt = hooked end
    end

    local lpl = cref(players).LocalPlayer
    if lpl and type(hookfunction) == "function" then
        -- istemciden kick'i engelle
        pcall(function()
            local oldKick
            oldKick = hookfunction(lpl.Kick, ncc(function(self, ...)
                if self == lpl then return nil end
                return oldKick(self, ...)
            end))
        end)
        -- MiscellaneousController'a sahte mouse ver
        pcall(function()
            local oldGetMouse
            oldGetMouse = hookfunction(lpl.GetMouse, ncc(function(self, ...)
                if self == lpl then
                    local okT, trace = pcall(debug.traceback)
                    if okT and trace:find("MiscellaneousController", 1, true) then
                        local realMouse = oldGetMouse(self, ...)
                        return setmetatable({}, {
                            __index = function(_, key)
                                if key == "X" or key == "Y" then
                                    local loc = game:GetService("UserInputService"):GetMouseLocation()
                                    return key == "X" and loc.X or loc.Y
                                end
                                local val = realMouse[key]
                                if type(val) == "function" then return function(_, ...) return val(realMouse, ...) end end
                                return val
                            end,
                            __newindex = function(_, key, value) realMouse[key] = value end,
                        })
                    end
                end
                return oldGetMouse(self, ...)
            end))
        end)
    end

    -- CameraSecurity modulunu kor et
    pcall(function()
        local cs = require(lpl:WaitForChild("PlayerScripts"):WaitForChild("Modules"):WaitForChild("CameraSecurity", 10))
        local mt = getrawmetatable(cs)
        if mt then
            if type(setreadonly) == "function" then pcall(setreadonly, mt, false) end
            mt.__index = function() return nil end
            mt.__tostring = function() return "LocalPlayer = nil" end
            mt.__newindex = function(E, G, f) return rawset(E, G, f) end
        end
    end)

    -- servis isimlerini degistir (Harion ile ayni)
    pcall(function()
        for _, service in pairs({ cref(players), workspace, cref(game:GetService("ReplicatedStorage")), cref(game:GetService("ReplicatedFirst")) }) do
            service.Name = service.Name .. " "
        end
    end)

    -- oyunun ping kalp atisini taklit et (anti-cheat kapaninca oyunun kendi ping'i durur)
    task.spawn(function()
        local ok, ServerPing = pcall(function() return workspace:WaitForChild("ServerPing", 30) end)
        local Remotes = game:GetService("ReplicatedStorage"):FindFirstChild("Remotes")
        local PingRemote = Remotes and Remotes:FindFirstChild("Ping")
        if not PingRemote then return end
        while task.wait(12 * math.random()) do
            local rnd = math.random(1, 9999)
            local sp = (ok and ServerPing and ServerPing.Value) or -1
            local value = rnd == 6961 and 2137 or rnd == sp and 2138 or rnd
            pcall(function() PingRemote:FireServer(value) end)
        end
    end)
    print("[shako] anti-cheat bypass aktif")
end)()

-- ============================================================
-- 5 SANIYE BASLATMA GECIKMESI
-- Anti-cheat bypass hemen calisir (donma korumasi korunur),
-- ardindan hem manuel execute hem de teleport queue (matchmaking)
-- sonrasi menu ve tum ozellikler 5 saniye sonra baslar.
-- ============================================================

end)
task.wait(2) -- breve delay post-bypass (AXIS usa 5s; 2s para no tardar tanto)
-- ======================================================================


-- kill avatar lag loops from old sessions
pcall(function()
    if getgenv()._ShakoAvatarKeepThread then
        task.cancel(getgenv()._ShakoAvatarKeepThread)
        getgenv()._ShakoAvatarKeepThread = nil
    end
end)

getgenv()._ShakoUIReady = false
getgenv()._ShakoBootAt = tick()

-- ==================== SOLO RIVALS ====================
-- GameId oficial de Rivals
local RIVALS_GAME_ID = 6035872082
local function notSupportedKick()
    local msg = "this game not supported"
    warn("[shako.win] " .. msg .. " | GameId=" .. tostring(game.GameId))
    pcall(function()
        local lp = game:GetService("Players").LocalPlayer
        if lp then lp:Kick(msg) end
    end)
    -- si el kick no corre, forzar leave
    pcall(function()
        game:GetService("TeleportService"):Teleport(0) -- invalido = force exit intent
    end)
    getgenv().antiSleepy_loaded = false
end

local _gid = tonumber(game.GameId)
local _okGame = (_gid == RIVALS_GAME_ID)
if not _okGame then
    -- algunos executors reportan PlaceId distinto; solo warn + allow si PlaceId conocido
    warn("[shako.win] GameId=" .. tostring(_gid) .. " (esperado " .. tostring(RIVALS_GAME_ID) .. ")")
    -- no kick hard: deja cargar para debug; descomenta kick si quieres estricto
    -- notSupportedKick(); return
end
-- =====================================================

local function shakoFail(msg)
    warn("[shako]", msg)
    getgenv().antiSleepy_loaded = false -- permite re-ejecutar SOLO si falló
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    for _ = 1, 100 do
        LocalPlayer = Players.LocalPlayer
        if LocalPlayer then break end
        task.wait(0.05)
    end
end
if not LocalPlayer then
    shakoFail("LocalPlayer nil — reintenta en 1s")
    return
end

-- PlayerGui listo (sin esto la UI a veces no sale al entrar)
pcall(function() LocalPlayer:WaitForChild("PlayerGui", 12) end)

local Camera = workspace.CurrentCamera

-- ==================== Obsidian UI ====================
local repo = "https://raw.githubusercontent.com/xyznick/UELinoriaLib/main/"
local Library, ThemeManager, SaveManager

local function httpGet(url)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and body and #body > 100 then return body end
    return nil
end

local function try_load(url)
    local body = httpGet(url)
    if not body then return nil end
    local ok, res = pcall(function() return loadstring(body)() end)
    if ok and res then return res end
    return nil
end

-- UELinoriaLib (misma UI que Aurora spoof) + fallbacks
local UELINORIA_REPO = "https://raw.githubusercontent.com/xyznick/UELinoriaLib/main/"
local LINORIA_REPO = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local OBSIDIAN_REPO = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"

Library = try_load(UELINORIA_REPO .. "Library.lua")
ThemeManager = try_load(UELINORIA_REPO .. "addons/ThemeManager.lua")
SaveManager = try_load(UELINORIA_REPO .. "addons/SaveManager.lua")
local _usingLinoria = Library ~= nil
local _usingUE = Library ~= nil

if not Library then
    task.wait(0.25)
    Library = try_load(LINORIA_REPO .. "Library.lua")
    ThemeManager = try_load(LINORIA_REPO .. "addons/ThemeManager.lua")
    SaveManager = try_load(LINORIA_REPO .. "addons/SaveManager.lua")
    _usingLinoria = Library ~= nil
    _usingUE = false
end
if not Library then
    task.wait(0.25)
    Library = try_load(OBSIDIAN_REPO .. "Library.lua")
    ThemeManager = try_load(OBSIDIAN_REPO .. "addons/ThemeManager.lua")
    SaveManager = try_load(OBSIDIAN_REPO .. "addons/SaveManager.lua")
    _usingLinoria = false
    _usingUE = false
end

if not Library or type(Library.CreateWindow) ~= "function" then
    shakoFail("UI Library no cargó (UELinoria/Linoria/Obsidian)")
    return
end

-- Shim: Linoria no usa Callback en AddToggle/Slider/Dropdown como Obsidian
do
    local function wrapGroupbox(gb)
        if not gb or gb.__shakoPatched then return gb end
        gb.__shakoPatched = true
        local function hook(method, valueKey)
            local old = gb[method]
            if type(old) ~= "function" then return end
            gb[method] = function(self, idx, opts)
                opts = opts or {}
                local cb = opts.Callback
                local ret = old(self, idx, opts)
                if cb and _usingLinoria then
                    task.defer(function()
                        local Toggles = Library.Toggles or getgenv().Toggles
                        local Options = Library.Options or getgenv().Options
                        if method == "AddToggle" and Toggles and Toggles[idx] then
                            pcall(function()
                                Toggles[idx]:OnChanged(function()
                                    pcall(cb, Toggles[idx].Value)
                                end)
                            end)
                        elseif Options and Options[idx] then
                            pcall(function()
                                Options[idx]:OnChanged(function()
                                    local v = Options[idx].Value
                                    pcall(cb, v)
                                end)
                            end)
                        end
                    end)
                end
                return ret
            end
        end
        hook("AddToggle")
        hook("AddSlider")
        hook("AddDropdown")
        -- AddButton may differ
        local oldBtn = gb.AddButton
        if type(oldBtn) == "function" then
            gb.AddButton = function(self, opts)
                if type(opts) == "table" and opts.Func and not opts.Callback then
                    -- Obsidian style {Text=, Func=}
                    if _usingLinoria then
                        return oldBtn(self, opts.Text or "Button", opts.Func)
                    end
                end
                return oldBtn(self, opts)
            end
        end
        return gb
    end

    local function wrapTab(tab)
        if not tab or tab.__shakoPatched then return tab end
        tab.__shakoPatched = true
        for _, m in ipairs({ "AddLeftGroupbox", "AddRightGroupbox", "AddGroupbox" }) do
            local old = tab[m]
            if type(old) == "function" then
                tab[m] = function(self, ...)
                    local gb = old(self, ...)
                    return wrapGroupbox(gb)
                end
            end
        end
        return tab
    end

    local oldCreate = Library.CreateWindow
    Library.CreateWindow = function(self, opts)
        opts = opts or {}
        -- Linoria no siempre soporta Footer/Resizable/NotifySide
        local ok, win = pcall(oldCreate, self, {
            Title = opts.Title or "shako.win",
            Center = opts.Center ~= false,
            AutoShow = opts.AutoShow ~= false,
            TabPadding = 8,
        })
        if not ok or not win then
            return oldCreate(self, opts)
        end
        local oldAddTab = win.AddTab
        if type(oldAddTab) == "function" then
            win.AddTab = function(self, name, ...)
                local tab = oldAddTab(self, name, ...)
                return wrapTab(tab)
            end
        end
        return win
    end

    -- Notify compatibility: Obsidian table vs Linoria string
    local oldNotify = Library.Notify
    if type(oldNotify) == "function" then
        Library.Notify = function(self, a, b, c)
            if type(a) == "table" then
                local title = a.Title or a.title or "shako"
                local desc = a.Description or a.description or a.Text or ""
                local t = a.Time or a.time or 3
                local msg = (desc ~= "" and (tostring(title) .. " · " .. tostring(desc))) or tostring(title)
                return oldNotify(self, msg, t)
            end
            return oldNotify(self, a, b, c)
        end
    end
end
getgenv()._ShakoUsingLinoria = _usingLinoria

task.defer(function()
    task.wait(0.3)
    pcall(function()
        local k = (getgenv().config and getgenv().config.MenuKey) or "RightShift"
        Library.ToggleKeybind = tostring(k) -- string = modo toggle nativo de UELinoria
        getgenv()._ShakoMenuKey = tostring(k)
    end)
end)


pcall(function() Library.ShowCustomCursor = true end)

local LucideIcons = {}
pcall(function()
    LucideIcons = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/Icons/refs/heads/main/lucide/dist/Icons.lua"))() or {}
end)
local function Icon(n)
    local f = LucideIcons[string.lower(tostring(n or ""))]
    if type(f) == "string" then
        local id = f:match("rbxassetid://(%d+)") or f:match("(%d+)")
        if id then return id end
    end
    return nil
end

if ThemeManager and ThemeManager.SetLibrary then
    pcall(function()
        ThemeManager:SetLibrary(Library)
        ThemeManager:SetFolder("shako_win")
    end)
end
if SaveManager and SaveManager.SetLibrary then
    pcall(function()
        SaveManager:SetLibrary(Library)
        SaveManager:SetFolder("shako_win/configs")
        if ThemeManager and SaveManager.IgnoreThemeSettings then
            pcall(function() SaveManager:IgnoreThemeSettings() end)
        end
        pcall(function() SaveManager:SetIgnoreIndexes({"MenuKeybind"}) end)
    end)
end

local Window
do
    local ok, win = pcall(function()
        -- ventana mas ancha + fuente limpia (no Code)
        pcall(function()
            Library.Font = Enum.Font.Gotham
            if Library.SetFontSize then
                Library:SetFontSize(13)
            else
                Library.FontSize = 13
            end
        end)
        return Library:CreateWindow({
            Title = "shako.win",
            Footer = "v6.7.62",
            Center = true,
            AutoShow = true,
            Resizable = true,
            NotifySide = "Right",
            ShowCustomCursor = true,
        })
    end)
    if not ok or not win then
        shakoFail("CreateWindow falló — vuelve a ejecutar")
        return
    end
    Window = win

-- Cursor UI visible al abrir
pcall(function()
    Library.ShowCustomCursor = true
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
end)
end

-- Forzar label Rivals (no Marketplace)
pcall(function()
    if Library.SetWatermark then
        Library:SetWatermark("shako.win")
    end
    if Library.Watermark then
        pcall(function() Library.Watermark.Text = "shako.win · Rivals" end)
    end
end)

-- silenciar notificaciones de la UI (menos Config)
pcall(function()
    if Library and Library.Notify then
        getgenv()._ShakoLibraryNotify = Library.Notify
        Library.Notify = function(self, data)
            -- bloquear spam de toggles; configs usan Notify() → StarterGui
            return
        end
    end
end)

function Notify(title, text)
    if tostring(title) ~= "Config" then return end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Config",
            Text = tostring(text or ""),
            Duration = 3,
        })
    end)
    pcall(function()
        local fn = getgenv()._ShakoLibraryNotify
        if type(fn) == "function" then
            fn(Library, { Title = "Config", Description = tostring(text or ""), Time = 3 })
        end
    end)
end
getgenv()._ShakoBootAt = tick()



-- ==================== SPOOFERS REMOVIDOS (full rage + legit) ====================
-- stubs minimos por si algo queda referenciado
local states = { spoofer_state = {}, skinchanger_state = { equipped = {}, fake_owned = {}, fake_weapon_owned = {} } }
local modules = modules or {}
-- Spoof helpers se definen mas abajo (Spoof / DeviceSpoof)
local function SpoofDevice()
    if DeviceSpoof and DeviceSpoof.enable then return DeviceSpoof.enable() end
end
local function ApplyNameSpoof()
    if Spoof and Spoof.refreshLocal then Spoof.refreshLocal() end
end
local function RefreshAllNameSpoofs()
    if Spoof and Spoof.refreshAll then Spoof.refreshAll() end
end
local function ApplyThumbnailSpoof() end
local function UnlockAll() end
local function UnlockSelectedRarity() end
local function EquipApply() end
RivalsSpoof = RivalsSpoof or {}
function RivalsRefreshNames() ApplyNameSpoof() end
function RivalsUpdateBadges() end
function RivalsSetAnonymous() end
function RivalsApplyDevice() SpoofDevice() end


getgenv().config = {

    Enabled = false,
    StickHeight = -2.8,
    StickOffsetX = 0,
    StickOffsetZ = 0,
    StickMultiPos = false,
    StickDesync = false, -- no ves el TP (igual que rage)
    StickAway = 6,
    StickPosInterval = 0.18,
    StickFireHead = false,

    MaxRange = 1e9, -- infinito efectivo anti-UE
    TeamCheck = true, -- NUNCA pegarse al team si ON

    PriorityMode = "Closest",
    TargetLock = false,
    FakePosition = false,
    FakePosStrength = 8,
    FakePositionY = 5,
    ExtendMeleeRange = false,
    ExtendMeleeRangeDist = 10,
    FakePositionPanic = false,
    PanicPositionXMin = -8,
    PanicPositionXMax = 8,
    FakePositionWalk = false,
    HitboxExpand = false,
    HitboxSize = 16,

    -- UE Counter (ex Anti Unnamed)
    UECounterEnabled = false,
    UECounterY = 500,
    UECounterCooldown = 0.2,
    UECounterHideDist = 500, -- hide / void height
    UECounterAttackSpeed = 1, -- velocidad ataque/reposición
    AntiUnnamed = false, -- alias de UECounterEnabled (otros sistemas)

    AntiSafeZone = false,
    SafeZoneMinY = 30,
    AntiVoidRescue = false,
    AntiVoidY = 40,

    StrafeEnabled = false,
    OrbitEnabled = false,
    OrbitRange = 10,
    OrbitSpeed = 16,
    StrafeSpeed = 18,

    -- Hit / Kill Songs
    HitSoundEnabled = false, -- legacy OFF (Elisium hitsounds)

    KillSoundEnabled = false, -- OFF (user quitó kill sounds)

    HitSoundVolume = 6,
    KillSoundVolume = 7,
    HitSoundMode = "Random",
    KillSoundMode = "Random",
    SelectedHitSound = "Rust HS",
    HitSoundPitch = 1,
    SelectedKillSound = "OOF",
    HitSoundCooldown = 0.08,
    KillSoundCooldown = 0.35,

    TargetName = "",
    UseNameTarget = false,

    FlyEnabled = false,
    FlySpeed = 120,
    FlyBoost = 1.8,
    JumpPowerEnabled = false,
    JumpPower = 100,
    JumpBoostForce = true, -- fuerza Y en Rivals (WalkSpeed/Jump se resetean)
    NoclipEnabled = false,
    AntiFling = true,
    SpeedEnabled = false,
    WalkSpeed = 50,
    SpeedVelocityMode = true,
    DefaultWalkSpeed = 16,
    DefaultJumpPower = 50,
    DefaultJumpHeight = 7.2,
    SlideBoostEnabled = false,
    SlideBoostSpeed = 60, -- Elisium style (direct speed on _sliding_velocity)
    -- Disable animations (Elisium)
    DisableAnimsEnabled = false,
    DisableAnimsSelect = {}, -- bobbing, landing, sway, equip, inspect, sliding, shoot, impulse, aim, sprint, attack, charge, reload, throw

    SlideBoostMult = 2.5,
    SlideBoostKey = "C", -- solo C (no Control)
    SlideBaseSpeed = 45,
    InfinityJump = false,

    AntiAimEnabled = false,
    AntiAimMode = "PitchYaw",
    -- Anti Aim estilo HARION (UpdateCameraRotation remote)
    AAPitchMode = "down",
    AAPitchOffset = 250,
    AAPitchAngle = 0,
    AAYawMode = "jitter",      -- disabled / backwards / spin / random / jitter / side / opposite / strong
    AAYawAngle = 180,
    SpinSpeed = 25,
    JitterAngle = 180,
    AAJitterAmount = 90,       -- grados max del jitter yaw
    AAStrongMode = false,      -- burst fuerte multi-packet
    AAPacketBurst = 5,         -- paquetes por frame en strong
    AASpinRate = 720,          -- deg/s spin
    ManualYaw = 180,
    AAPitch = 0,
    AAInvert = false,
    AAHideLocal = false,
    -- Underground AA (pitch down + jitter, NO tp bajo mapa)
    AntiAimUnderground = false,
    AntiAimUndergroundY = -25, -- degrees pitch down (legacy name, now pitch)
    UndergroundPitch = -25,    -- -15 a -50 recomendado
    UndergroundJitter = 35,    -- yaw jitter degrees
    UndergroundRandom = true,  -- random delay/variation
    UndergroundSpin = 0.4,     -- factor de spin suave (0-1)

    SpawnDelay = 1.0,

    RagebotEnabled = false,

    -- AXIS ragebot keys
    TeleportOffsetY = 1,
    RageShootAttempts = 1,
    RageTeleportDelay = 0.04,
    RageVoidSpamAfterKill = false,
    RageHover = false,
    RageVoidOnReload = false,
    RageShotgunVoidTime = 5,
    RageVoidMinDist = 1,
    RageVoidRange = 50000,
    RageVoidIterations = 120,
    RageAntiAim = false,
    BodyTwist = false,
    BodyTwistMode = "Rager", -- Rager | Broken | Twist | Random | Lay | Ultra
    BodyTwistPower = 1.8, -- ultra fold default
    BodyTwistSpeed = 8,
    BodyTwistWithRage = true,
    BodyTwistWithAA = true, -- auto con anti-aim
    RageNoclip = false,
    RagePreferredWeapon = "primary",
    RageAutoEquip = false,
    RageAutoSwap = false,
    RageTargetMode = "Closest",
    RageAutoPriority = false,
    RagePriorityAttackers = false,
    RagePriorityVoided = false,
    RageDistance = 2.5,
    HarionFastShoot = false,
    HarionNoSpread = false,
    WallCheckEnabled = false,
    WallCheckRadius = 2,
    WallCheckAttempts = 4,
    WallCheckFallbackY = 5,
    VoidLockEnabled = true,

    -- Sleepy Counter: TP al lado de la mano (lejitos) + auto head
    SleepyCounterEnabled = false,
    SleepyCounterSideDist = 14,   -- lejos de la mano
    SleepyCounterHandY = 0.5,
    SleepyCounterHeight = 1.2,
    SleepyCounterFireRate = 0.02,
    SleepyCounterTeamCheck = false,
    SleepyCounterRange = 1e12,
    -- Kicia Counter: anti kiciahook rage
    KiciaCounterEnabled = false,
    KiciaCounterSkyY = 600,          -- altura en el cielo
    KiciaCounterLineWidth = 200,      -- largo del triangulo (studs)
    KiciaCounterMoveSpeed = 800,     -- studs/seg entre puntos (rapido)
    KiciaCounterFireRate = 0.015,
    KiciaCounterTeamCheck = false,
    KiciaCounterShoot = true,        -- seguir disparando a head mientras esta en cielo
    RageIndicatorEnabled = true,
    RageStatusEnabled = true,
    RageIndicatorSnapline = true,
    RageIndicatorColor = "Red",
    RageStatusMode = "static", -- static / crosshair
    RageStatusOffsetY = 48,

    RageDesync = true, -- no ves el TP (restore post-fire)
    RageHideTP = true,
    RageLookSyncOnShoot = false,
    RageHideLocal = false,
    RagebotHeight = 2.2,
    RagebotRange = math.huge,
    RagebotInfiniteRange = true,
    RagebotTeamCheck = true, -- no atacar team
    RagebotForceFFA = false,
 -- true = siempre FFA (ignora team)
    RagebotForceFFA = false,
    RagebotPriorityHP = true,
    RagebotSkipFF = false,
    RagebotLookAtHead = false,
    RagebotOffsetX = 0,
    RagebotOffsetZ = 0,
    RagebotPredict = true,
    RagebotPredictAmount = 0.12,
    -- Rivals UseItem rage
    RageWeaponSlot = "Primary", -- no Fists por defecto

    RageFireRate = 0,
    RageAttackSpeed = 10, -- UE-style: que tan rapido se tpea/ataca (1 lento - 20 insta)
    RageDesyncKnifeY = 6,
    RageDesyncNormalY = 1,
    RageDesyncNormalZ = 2,
    RageSkipDeflect = true,
    RageUseItem = true, -- always on with ragebot

    RageShotsPerTick = 10,         -- Harion shoot attempts
    RageAttackMode = "gun",        -- gun | knife | melee
    RagePreferredWeapon = "primary", -- primary | secondary | melee

    RageWeaponSpecialize = true,
    RageSwapWhenEmpty = true,
    RageAutoPriority = false,
    RagePriorityAttackers = false,
    RagePriorityVoided = false,

    RageMultipoint = true,         -- head + upper torso
    RageSwitchDelay = 0.05,        -- al morir target, siguiente
    RageResolver = true,           -- ajusta Y si el target se mueve raro
    RageBodyAimIfWall = false,     -- si head bloqueada usa torso


    VoidRage = false,
    VoidRageAwayDist = 99999999,
    RageVoidFirst = true,
    RageVoidOnKill = true,
    RageVoidHideTime = 0.25, -- Harion hide
    RageVoidAttackTime = 0.03, -- Harion attack window

    RagePrioritizeRagers = true,
    VoidRageInterval = 0.35,
    VoidRageMethods = "Side",
    VoidRageReturn = true,

    AimbotEnabled = false,
    AimbotKeyMode = "Hold",
    AimbotFOV = 400,
    AimbotSmooth = 0.9,
    AimbotPart = "Head",
    AimbotTeamCheck = true,
    AimbotKeyHold = false, -- NO RMB: solo keybind ...
    MenuKey = "RightShift",
    CrosshairOutline = true,
    CrosshairColor = Color3.fromRGB(255, 255, 255),
    CrosshairOutlineColor = Color3.fromRGB(0, 0, 0),
    CrosshairRotation = 0,
    CrosshairBounce = 0,
    CrosshairBounceSpeed = 1,
    CrosshairPosition = "center",
    DisableGameCrosshair = false,
    VMAppearance = false,
    UnlockAll = false, -- Rivals skinchanger (all cosmetics local)
    VMColor = Color3.fromRGB(255, 255, 255),
    VMMaterial = "ForceField",
    VMWireframe = false,
    VMDisableTextures = false,
    VMTransparency = 100,
    ArmAppearance = false,
    ArmColor = Color3.fromRGB(255, 255, 255),
    ArmMaterial = "ForceField",
    ArmDisableClothes = false,
    ArmTransparency = 100,
    RemoveVignette = false,
    OverrideWeaponStatus = false,
    WeaponStatus = "Prime",
    VMOverrideFps = false,
    VMFps = 60,
    VMRecoil = 100,
    VMChams = false,
    VMChamsColor = Color3.fromRGB(255, 255, 255),
    VMChamFill = 2,
    VMChamOutline = 1,
    VMOffset = false,
    VMOffsetX = 0,
    VMOffsetY = 0,
    VMOffsetZ = 0,
    XRayEnabled = false,
    XRayTransparency = 0.5,


    KeybindListEnabled = true,
    KeybindListTransparency = 0.25,
    KeybindListOnlyActive = false,
    KeybindListPosX = 20,
    KeybindListPosY = 120,

    SilentAimEnabled = false,
    SilentHitPart = "Head",
    SilentPredict = false,
    SilentPredictAmount = 0.08,
    SilentHeadOffsetY = 0,
    SilentFOV = 800,
    SilentShowFOV = true,
    SilentTeamCheck = true,
    SilentForceAiming = true,
    SilentActivationChance = 100,
    SilentReactionTime = 0,
    SilentSwitchDelay = 0,
    SilentManipulate = true,
    SilentManipulateMode = "OnBestTarget",
    SilentWallCheck = false,
    SilentVisibleCheck = false,
    SilentUseHitboxHead = true,
    SilentFOVFill = true,
    SilentFOVFillTransparency = 0.92,
    SilentFOVAnimated = true,
    SilentFOVSpin = true,
    SilentFOVSpinSpeed = 1.2,
    SilentFOVThickness = 1.5,
    SilentFOVColor = "White",
    SilentFOVOutlineColor3 = Color3.fromRGB(255, 255, 255),
    SilentFOVFillC1 = Color3.fromRGB(255, 105, 180),
    SilentFOVFillC2 = Color3.fromRGB(180, 100, 255),
    SilentFOVFillC3 = Color3.fromRGB(80, 180, 255),

    AimbotWallCheck = false,
    AimbotVisibleCheck = false,
    AimbotShowFOV = true,
    AimbotFOVFill = true,
    AimbotFOVFillTransparency = 0.92,
    AimbotFOVAnimated = false,
    AimbotFOVColor = "White",
    AimbotFOVOutlineColor3 = Color3.fromRGB(255, 230, 80),
    AimbotFOVFillC1 = Color3.fromRGB(255, 210, 80),
    AimbotFOVFillC2 = Color3.fromRGB(255, 140, 60),
    AimbotFOVFillC3 = Color3.fromRGB(255, 80, 120),
    AimbotSmooth = 0.15,

    WeatherEnabled = false,
    AmbientSoundEnabled = false,
    AmbientSoundType = "Rain",
    AmbientSoundVolume = 0.45,
    AmbientSoundPitch = 1,
    Weather = false,
    WeatherType = "Rain",
    WeatherIntensity = 1,
    WeatherSoundVolume = 0.6,
    WeatherStorm = false,
    WeatherStormMin = 8,
    WeatherStormVar = 6,
    WeatherMeteors = false,
    WeatherMeteorRate = 1,
    WeatherShootingStars = false,
    WeatherStarRate = 1,
    WeatherPuddles = false,
    WeatherMood = true,
    WeatherClockDial = false,
    WeatherRainbow = false,
    WeatherGodRays = false,
    SkyboxPreset = "Off",

    EmoteEnabled = false,
    EmoteId = "5917459365",
    EmoteName = "Floss",
    EmoteSpeed = 1,
    EmoteLoop = false,
    EmoteKeepPlaying = false,
    EmoteAlwaysOn = false,
    EmotePriority = "Action4",

    AutoClickEnabled = false,
    AutoClickCPS = 16,
    AutoClickOnlyOnTarget = true,

    NoRecoil = false,
    NoRecoilStrength = 1,
    NoRecoilOnlyShoot = true,
    NoRecoilScanGun = false,

    RapidFire = false,
    RapidFireValue = 999,
    RapidFireDelay = 0.001,
    RapidFireLoop = true,
    FastMelee = false,
    ItemLibraryKeepAlive = true,

    VoidSpamEnabled = false,
    VoidMethod = "Quantum",
    VoidSpeed = 100000000000,
    VoidChaos = 0.98,
    VoidBaseAltitude = 100000000000, -- distancia extrema
    VoidRadius = 100000000000,
    VoidEvade = true,
    VoidEvadeDist = 100000000000,
    VoidEvadeRadius = 100000000000,
    VoidEvadeSpeed = 100000000000,
    VoidEvadeCooldown = 0.05,
    VoidEvadeTrigger = 1.0, -- Lua x paid
    VoidEvadeStrength = 1.0,
    VoidEvadeVert = 3e9,
    VoidExtremeMode = true, -- speeds estilo Lua x paid
    VoidChaosVel = true, -- velocity chaos random


    PredDodgeEnabled = false,
    AutoCollectHeals = false, -- FFA packs (vida/balas)
    AutoCollectRadius = 60,
    AutoCollectAmmo = true,
    AutoCollectOnlyFFA = true,

    BlinkEnabled = false, -- meoww-style blink anti-rager
    BlinkRadius = 90,
    BlinkRate = 15,

    PredRadius = 90,
    PredDodgeDist = 120,
    PredCooldown = 0.12,
    PredThreshold = 55, -- HVH: detecta ragers rapido
    PredMult = 1,

    TriggerbotEnabled = false,
    TriggerbotFOV = 120,
    TriggerbotCPS = 12,
    TriggerbotPart = "Head",

    AutoEquipMelee = false,
    AutoEquipEnabled = false,
    AutoEquipName = "Chainsaw",
    AutoEquipAny = false,
    AutoEquipSlot = 3, -- 1 primary 2 secondary 3 melee
    AutoEquipInterval = 0.35,
    AutoEquipDelay = 0.8,
    MeleeName = "Chainsaw",
    DesyncJitter = false,
    DesyncJitterPower = 12,

    -- HVH Defense
    HurtEvade = false,
    HurtEvadeDist = 55,
    HurtEvadeCooldown = 0.35,
    NearEnemyEvade = false,
    NearEnemyDist = 25,
    NearEnemyPush = 45,
    AdaptiveDesync = false,
    AdaptiveDesyncPower = 18,
    AdaptiveDesyncRange = 200,
    VelocityBreak = false,
    VelocityBreakMax = 140,
    RandomMicroMove = false,
    RandomMicroPower = 3,
    AntiMeleeRange = 20,
    AntiMeleePush = 40,
    AntiMeleeEnabled = false,
    LowHPPanic = false,
    LowHPThreshold = 30,
    LowHPBoostDist = 80,

    -- Anti UE / Kicia HVH
    InfiniteRange = true,          -- ignora MaxRange en target
    AntiUEClose = false,           -- si UE se pega cerca → push lejos
    -- Riot (Lua x paid)
    RiotEnabled = false,
    RiotSpeed = 0.03,
    RiotRange = 50,
    RiotEvadeRange = 30,
    RiotSpinSpeed = 180,
    RiotAbuseEnabled = false,
    RiotAbuseMode = "Stick",
    RiotAbuseHeight = 3,
    RiotAbuseForward = 0,
    RiotAbuseRight = 0,
    RiotAbuseDown = 0,

    AntiUECloseDist = 35,
    AntiUEClosePush = 80,
    AntiUEPeek = false,            -- side peek al detectar rager cerca
    AntiUEPeekDist = 40,
    RageInfinite = true,           -- rage sin límite de distancia
    StickFarMode = false,          -- stick más lejos (anti melee UE)
    StickFarMult = 2.5,
    DesyncSpam = false,            -- micro desync continuo anti hit
    DesyncSpamPower = 8,
    HitboxBig = false,
    HitboxBigSize = 18,


    
    -- Auto match / loadout (Rivals Duels)
    AutoLoadoutEnabled = false,
    AutoLoadoutPrimary = "Assault Rifle",
    AutoLoadoutSecondary = "Handgun",
    AutoLoadoutMelee = "Fists",
    AutoLoadoutUtility = "Grenade",
    AutoLoadoutInterval = 2,
    AutoVoteEnabled = false,
    AutoVoteMap = "Arena",
    AutoVoteInterval = 1,
    AutoBanWeaponEnabled = false,
    AutoBanWeapons = {}, -- list of names to cycle ban
    AutoBanWeaponCurrent = "Sniper",
    AutoBanInterval = 1,
    AutoQueueEnabled = false,
    AutoQueueMatch = "1v1",
    AntiKick = true,
    SoftStick = false,
    SoftStickSpeed = 180,
    SoftStickMaxStep = 5,
    -- TP atras del enemigo (sin delay)
    StickBehindTP = false,
    StickBehindDist = 10,   -- offset atras del enemigo
    StickBehindHeight = 1.5,
    StickBehindRange = math.huge, -- alcance infinito para TP
    CameraIndependent = false,
    BlockIllegalNotify = true,

    CameraLookAtTarget = false,
    ForceZeroVelocity = true,
    StickOnRender = true,
    LockYWhileStick = false,

    Fullbright = false,
    Brightness = 2,
    Exposure = 0,
    ClockTime = 14,
    NoFog = true,
    Saturation = 0,
    Contrast = 0,
    BloomEnabled = false,
    BloomIntensity = 0.4,
    BlurEnabled = false,
    BlurSize = 8,
    AmbientColor = false,
    LightingOverride = false,
    AmbientR = 120, AmbientG = 120, AmbientB = 140,
    OutdoorR = 140, OutdoorG = 140, OutdoorB = 160,
    ColorShiftEnabled = false,
    ColorShiftR = 0, ColorShiftG = 0, ColorShiftB = 0,
    TintEnabled = false,
    TintR = 255, TintG = 255, TintB = 255,
    ShadowsEnabled = true,
    GlobalShadows = true,
    EnvironmentDiffuse = 1,
    EnvironmentSpecular = 1,
    WallXray = false,
    WallTransparency = 0.55,
    WallLocalOnly = true, -- solo client
    MapColorEnabled = false,
    MapColorR = 80, MapColorG = 80, MapColorB = 100,
    RemoveTextures = false,
    GlassWindows = false,
    CharacterTransparency = 0,
    ApplyCharVisualsEnabled = false,
    ForceFieldVisual = false,
    ForceFieldColor = Color3.fromRGB(180, 0, 255),
    ForceFieldTransparency = 0.72,
    ForceFieldOutlineTransparency = 0.55,
    ForceFieldStyle = "Material", -- Material (solo skin) | Highlight | Both | Soft
    ForceFieldPulse = false,
    ForceFieldRemoveAcc = false,
    RemoveAccessories = false,

    ESPEnabled = false,
    ESPPerfMode = true,
    ESPMaxPlayers = 6,
    ESPUpdateInterval = 0.05,
    ESPRadar = false,
    ESPChams = false,
    ESPChamsEnabled = false,
    ESPChamsFill = Color3.fromRGB(255, 0, 0),
    ESPChamsOutline = Color3.fromRGB(100, 0, 0),
    ESPChamsFillTransparency = 0.5,
    ESPChamsOutlineTransparency = 0.3,
    ESPTeamCheck = false,
    ESPTeamColor = Color3.fromRGB(80, 180, 255),
    ESPEnemyColor = Color3.fromRGB(255, 255, 255),
    ESPFilledBox = false,
    ESPHeldWeapon = false,
    ESPHealthNumber = false,
    ESPTracer = false,
    ESPTracerOrigin = "Bottom",
    ESPTracerTarget = "Feet",
    ESPTracerThickness = 1.5,
    ESPTracerOutline = true,
    ESPTracerColor = Color3.fromRGB(255, 255, 255),
    ESPTracerOutlineColor = Color3.new(0, 0, 0),
    ESPHeadMarker = false,
    ESPHeadMarkerShape = "Cross",
    ESPHeadMarkerColor = Color3.fromRGB(255, 80, 80),
    ESPSkeletonColor = Color3.fromRGB(255, 255, 255),
    ESPSkeletonThickness = 1.2,
    ESPUseDisplayName = false,

    -- LuaHook ESP
    ESP = false,
    ESPBox = true,
    ESPBoxStyle = "Full Box",
    ESPBoxBrackets = false,
    ESPBoxFill = false,
    ESPBoxThickness = 1,
    ESPBoxColorMode = "Solid",
    ESPBoxColor = Color3.fromRGB(255, 255, 255),
    ESPBoxGradA = Color3.fromRGB(255, 59, 78),
    ESPBoxGradB = Color3.fromRGB(255, 194, 75),
    ESPBoxFillColor = Color3.fromRGB(255, 59, 78),
    ESPBoxTransparency = 0,
    ESPBoxFillTransparency = 0.75,
    ESPBoxScale = 1,
    ESPName = true,
    ESPDistance = true,
    ESPHealth = true,
    ESPHealthBar = true,
    ESPSkeleton = false, -- OPT: skeleton mata FPS

    ESPTracers = false,
    ESPTeamCheck = false,
    ESPMaxDistance = 100000, -- 0 = infinite
    ESPDistanceScaling = true,
    ESPDistanceScalingRef = 50,
    ESPChams = false,
    ESPFlags = false, -- OPT


    ESPMaxDist = 1e9, -- infinito
    ESPInfiniteRange = true,
    ESPTeamCheck = false,
    ESPShowName = true,
    ESPShowDist = true,
    ESPShowHP = true,
    ESPShowBox = true,
    ESPBoxStyle = "Corner", -- Corner / Full / Both
    ESPSkeleton = false,
    ESPGlow = true,
    ESPSkeletonThickness = 1.5,
    ESPTracers = false,
    ESPTracerFrom = "Bottom",
    ESPColor = "Red",
    ESPHealthBarColor = "Green",
    ESPUseTeamColor = false,
    ESPUseHPColor = false,
    ESPBoxThickness = 2,
    ESPCasingThickness = 2,
    ESPFilledBox = false,
    ESPFilledBoxTrans = 0.85,

    -- Bullet tracers (avanzados)
    BulletTracerEnabled = false, -- legacy OFF (Elisium tracers)

    BulletTracerColor = "Cyan",
    BulletTracerDuration = 0.6,
    BulletTracerThickness = 1.2,
    BulletTracerFromGun = true,
    BulletTracerStyle = "Neon",
    BulletTracerGlow = 8,
    BulletTracerFade = 0.25,
    BulletTracerEmission = 1,
    BulletTracerTextureLength = 1.2,
    BulletTracerTextureSpeed = 4,
    BulletTracerExpand = true,
    BulletTracerExpandSpeed = 12,
    BulletTracerExpandDamper = 0.85,
    BulletTracerCameraOffset = 0.15,

    -- Stretched resolution (CFrame matrix method)
    StretchedRes = false, -- legacy OFF (Elisium stretch)

    StretchedScale = 0.81, -- Y scale (0.5 = mas stretch, 1.0 = normal)

    ThirdPerson = false,
    ThirdPersonMode = "ThirdPerson",
    WeaponWireframe = false,
    WeaponWireframeColor = Color3.fromRGB(0, 255, 180),
    ThirdPersonDistance = 10,
    ThirdPersonHeight = 2.5,
    ThirdPersonSmooth = 0.2,
    Watermark = false,
    Crosshair = false,
    CrosshairSize = 25,
    CrosshairGap = 10,
    CrosshairThickness = 2,
    CrosshairOutline = true,
    CrosshairSpin = true,
    CrosshairSpinSpeed = 120,
    CrosshairText = "",
    CrosshairTextSize = 22,
    CrosshairRainbow = true,
    CrosshairOffsetX = 0,
    CrosshairOffsetY = 0,
    CrosshairTextOffsetY = 28,
    CurrentSky = "None",
    AutoRespawn = false,

    -- Spoofer (Kicia PlayerSpoofer style)
    SpoofEnabled = false,
    SpoofMyName = false,
    SpoofMyNameValue = "shako.win",
    SpoofMyUserValue = "",
    SpoofMyDisplayName = false,
    SpoofMyDisplayValue = "shako.win",
    SpoofOthers = false,
    SpoofOthersValue = "User",
    SpoofTargetName = "",
    SpoofTargetFake = "",
    SpoofHideReal = true,
    SpoofRandomOthers = false,
    SpoofProfileUI = true,
    -- Avatar (userId) — sin lag loops
    -- Stats visual (solo local UI)
    SpoofLevelEnabled = false,
    SpoofLevelValue = 999,
    SpoofWinstreakEnabled = false,
    SpoofWinstreakValue = 999,
    SpoofRankEnabled = false,
    SpoofRankValue = "Prime",
    SpoofEloEnabled = false,
    SpoofEloValue = 3600,
    SpoofKeysEnabled = false,
    SpoofKeysValue = 999,
    SpoofLeaderboardEnabled = false,
    SpoofLeaderboardValue = 1,
    -- Device
    DeviceSpoofEnabled = false,
    DeviceSpoofType = "Mobile",
    DeviceSpoofAttribute = true,

    -- Skinchanger
    SkinchangerEnabled = false,
    SkinTargetUserId = 1,
    ShakoSyncEnabled = true, -- ver avatars de otros shako.win

    SkinTargetName = "",
    SkinOnRespawn = true,

    -- Keybinds (Enum.KeyCode name)
    KeybindStick = "V",
    KeybindRage = "R",
    KeybindSilent = "T",
    KeybindAimbot = "Y",
    KeybindFly = "F",
    KeybindNoclip = "G",
    KeybindAntiAim = "B",
    KeybindStrafe = "C",
    KeybindOrbit = "X",
    KeybindSpeed = "Z",
    KeybindVoidSpam = "H",
}


local config = getgenv().config

-- ==================== RIVALS MODULES + ITEMLIBRARY ====================
local RS = game:GetService("ReplicatedStorage")
local util, enum, FighterController, SpectateController
local modulesOK = false
local ItemBackup = {}
local gunExceptions = { RPG = true } -- sniper/bow/crossbow SI tienen rapid + no spread
local rageLastFire = 0
local deflecting = {}
local rageSlots = { Primary = 1, Secondary = 2, Melee = 3 }

function loadRivalsModules()
    local ok1, u = pcall(function() return require(RS.Modules.Utility) end)
    local ok2, e = pcall(function() return require(RS.Modules.EnumLibrary) end)
    local ok3, fc = pcall(function()
        return require(LocalPlayer.PlayerScripts.Controllers.FighterController)
    end)
    local ok4, sc = pcall(function()
        return require(LocalPlayer.PlayerScripts.Controllers:WaitForChild("SpectateController"))
    end)
    if ok1 and ok2 and ok3 then
        util, enum, FighterController = u, e, fc
        if ok4 then SpectateController = sc end
        modulesOK = true
        return true
    end
    modulesOK = false
    return false
end

task.spawn(function()
    for _ = 1, 40 do
        if loadRivalsModules() then
            pcall(function() Notify("Rivals", "FighterController OK") end)
            break
        end
        task.wait(0.4)
    end
end)

function getItems()
    local ok, mod = pcall(function() return require(RS.Modules.ItemLibrary) end)
    if ok and mod and mod.Items then return mod.Items end
    return nil
end

function ilSave(name, data, prop)
    if data[prop] == nil then return end
    ItemBackup[name] = ItemBackup[name] or {}
    if ItemBackup[name][prop] == nil then ItemBackup[name][prop] = data[prop] end
end

function ilSet(name, data, prop, val)
    if data[prop] == nil then return end
    ilSave(name, data, prop)
    data[prop] = val
end

function ilRestore(name, data)
    local b = ItemBackup[name]
    if not b then return end
    for prop, old in pairs(b) do
        if data[prop] ~= nil then data[prop] = old end
    end
end

function ApplyItemLibraryGuns(on)
    local Items = getItems()
    if not Items then return false end
    for name, data in pairs(Items) do
        if typeof(data) ~= "table" then continue end
        local lname = string.lower(tostring(name))
        if gunExceptions[name] or lname:find("rpg", 1, true) or lname:find("rocket", 1, true) then
            continue
        end
        if on then
            if config.NoRecoil or config.RapidFire then
                ilSet(name, data, "ShootSpread", 0)
                ilSet(name, data, "ShootRecoil", 0)
                ilSet(name, data, "Recoil", 0)
                ilSet(name, data, "Spread", 0)
                ilSet(name, data, "MinSpread", 0)
                ilSet(name, data, "MaxSpread", 0)
                ilSet(name, data, "AimSpread", 0)
                ilSet(name, data, "HipSpread", 0)
            end
            ilSet(name, data, "ShootAccuracy", 0)
            -- SOLO fire rate de disparo — NUNCA ReloadTime / Cooldown generico / Charge
            -- (Cooldown/ChargeTime a 0 rompe la recarga infinita)
            local delay = config.RapidFireDelay or 0.001
            ilSet(name, data, "ShootCooldown", delay)
            ilSet(name, data, "ShootBurstCooldown", delay)
            if data.FireRate ~= nil and type(data.FireRate) == "number" and data.FireRate > 0 then
                ilSet(name, data, "FireRate", math.max(delay, 0.001))
            end
            -- NO: Cooldown, ReloadTime, ChargeTime, BoltTime, PumpTime
        else
            ilRestore(name, data)
        end
    end
    return true
end

function ApplyItemLibraryMelee(on)
    local Items = getItems()
    if not Items then return false end
    for name, data in pairs(Items) do
        if typeof(data) ~= "table" then continue end
        if on then
            ilSet(name, data, "AttackCooldown", 0.001)
            ilSet(name, data, "SwingCooldown", 0.001)
            ilSet(name, data, "MeleeCooldown", 0.001)
            ilSet(name, data, "Cooldown", 0.001)
            ilSet(name, data, "RecoveryTime", 0.001)
            ilSet(name, data, "ResetTime", 0.001)
        else
            ilRestore(name, data)
        end
    end
    return true
end

task.spawn(function()
    while true do
        task.wait(5)
        if config.ItemLibraryKeepAlive then
            if config.RapidFire then pcall(ApplyItemLibraryGuns, true) end
            if config.FastMelee then pcall(ApplyItemLibraryMelee, true) end
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(4) -- OPT
        if not config.RagebotEnabled or not modulesOK then continue end
        -- NO forzar Melee/Fists: usar slot elegido (Primary por defecto)
        local slotName = config.RageWeaponSlot or "Primary"
        local pref = tostring(config.RagePreferredWeapon or "primary"):lower()
        if pref == "melee" or pref == "knife" then
            slotName = "Melee"
        elseif pref == "secondary" then
            slotName = "Secondary"
        elseif pref == "primary" then
            slotName = "Primary"
        end
        -- si el user eligió Primary/Secondary, NUNCA poner Fists
        if slotName == "Melee" and pref ~= "melee" and pref ~= "knife" then
            slotName = "Primary"
        end
        local slot = rageSlots[slotName] or 1
        local lf = FighterController and FighterController.LocalFighter
        if lf and config.RageWeaponSpecialize ~= false then
            pcall(function() lf:EquipItem(slot) end)
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) deflecting[p] = nil end)

function updateDeflection()
    if not FighterController or not FighterController.Objects then return end
    for _, fighterObj in pairs(FighterController.Objects) do
        local player = fighterObj.Player
        if not player then continue end
        if not fighterObj.Entity or not fighterObj.Entity:IsAlive() or fighterObj:Get("IsSpectating") then
            deflecting[player] = false
            continue
        end
        local equipped = fighterObj.EquippedItem
        local isKatana = equipped and equipped.ViewModel and equipped.ViewModel.Name == "Katana"
        local isDeflecting = false
        if isKatana then
            isDeflecting = (equipped._attack_cooldown and equipped._attack_cooldown > tick()) or false
        end
        deflecting[player] = isDeflecting
    end
end

-- FFA: si casi todos comparten el mismo TeamID → Free For All
function isFFAMode()
    if config.RagebotForceFFA then return true end
    local teams, alive = {}, 0
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if not plr.Character then continue end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then continue end
        alive = alive + 1
        local tid = getPlayerTeamId and getPlayerTeamId(plr) or nil
        -- nil / 0 / "0" / "FFA" cuentan como FFA-ish
        local key = (tid == nil or tid == "0" or tid == "nil" or tid == "FFA") and "__ffa" or tostring(tid)
        teams[key] = true
    end
    if alive <= 1 then return true end
    local unique = 0
    for _ in pairs(teams) do unique = unique + 1 end
    -- un solo "equipo" en el server = Free For All
    if unique <= 1 then return true end
    return false
end

function isEnemyRageRivals(player)
    if not player or player == LocalPlayer then return false end
    if not player.Character then return false end
    -- solo targets en pelea real (FighterController), no lobby/spectate
    if FighterController and FighterController.Objects then
        local foundAlive = false
        for _, fo in pairs(FighterController.Objects) do
            if fo and fo.Player == player then
                if fo.Entity and fo.Entity:IsAlive() and not fo:Get("IsSpectating") then
                    foundAlive = true
                end
                break
            end
        end
        if not foundAlive then return false end
    end
    -- Force FFA solo si el usuario lo pide
    if config.RagebotForceFFA == true then return true end
    -- Team check: default ON (nil cuenta como ON)
    local tc = config.RagebotTeamCheck
    if tc == nil then tc = true end
    if tc == false then return true end
    -- Team Check ON: NUNCA usar isFFAMode para saltarse el check
    if StrongIsTeammate and StrongIsTeammate(player) then return false end
    if IsSameTeam and IsSameTeam(player) then return false end
    if player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return false end
    if player.TeamColor and LocalPlayer.TeamColor and player.TeamColor == LocalPlayer.TeamColor then
        local n = tostring(player.TeamColor)
        if n ~= "White" and n ~= "Medium stone grey" then return false end
    end
    if player.Character and player.Character:FindFirstChild("TeammateLabel") then return false end
    return true
end

function hasKnifeViewModel(targetPlayer)
    if not targetPlayer then return false end
    local viewModels = workspace:FindFirstChild("ViewModels")
    if not viewModels then return false end
    local targetName = targetPlayer.Name
    for _, model in ipairs(viewModels:GetChildren()) do
        if model:IsA("Model")
            and string.find(model.Name, targetName, 1, true)
            and string.find(model.Name, "Knife", 1, true) then
            return true
        end
    end
    return false
end

-- true si recarga o sin balas → no spamear UseItem (evita reload eterno)
function isItemBusyReload(item)
    if not item then return true end
    local function g(key)
        local ok, v = pcall(function()
            if item.Get then return item:Get(key) end
            return item[key]
        end)
        if ok then return v end
        return nil
    end
    local rel = g("Reloading") or g("IsReloading") or g("Reload") or g("IsReload")
    if rel == true then return true end
    local ammo = g("Ammo") or g("AmmoInClip") or g("Clip") or g("CurrentAmmo")
    if type(ammo) == "number" and ammo <= 0 then
        -- sin balas: dejar que el juego recargue, no fire
        return true
    end
    local state = g("State") or g("WeaponState")
    if type(state) == "string" then
        local s = string.lower(state)
        if s:find("reload") or s:find("empty") then return true end
    end
    return false
end

function fireRageUseItem(item, desyncCF, targetHead, targetRoot)
    if not util or not enum or not item then return end
    if isItemBusyReload(item) then return end
    -- no disparar a target con escudo
    if targetHead and targetHead.Parent and config.RagebotSkipFF ~= false then
        if targetHasShield and targetHasShield(targetHead.Parent) then return end
    end
    local originPos = desyncCF and desyncCF.Position or targetRoot.Position
    local targetPos = targetHead.Position
    local aimCF = CFrame.lookAt(originPos, targetPos)
    local targetCF = targetHead.CFrame
    local randomOffset = Vector3.new(
        (math.random() - 0.5) * 0.1,
        (math.random() - 0.5) * 0.1,
        (math.random() - 0.5) * 0.1
    )
    local aimedPos = targetPos + randomOffset
    local objSpaceHeadOffset = targetHead.CFrame:ToObjectSpace(CFrame.new(aimedPos))
    local cameradata = {}
    cameradata[utf8.char(1)] = {
        [utf8.char(0)] = util:EncodeCFrame(aimCF),
        [utf8.char(1)] = util:EncodeCFrame(targetCF),
        [utf8.char(2)] = targetHead,
        [utf8.char(3)] = util:EncodeCFrame(objSpaceHeadOffset)
    }
    pcall(function()
        RS.Remotes.Replication.Fighter.UseItem:FireServer(
            item:Get("ObjectID"),
            enum:ToEnum("StartShooting"),
            cameradata,
            nil
        )
    end)
end

-- ==================== SLEEPY COUNTER + KICIA COUNTER ====================
local sleepyLastFire, kiciaLastFire = 0, 0
local kiciaOrbitAng = 0

local function counterPickTarget(teamCheck, maxRange)
    local my = getHRP and getHRP() or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if not my then return nil, nil, nil end
    local best, bestD, bestHead, bestRoot = nil, maxRange or 1e12, nil, nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if teamCheck and IsEnemy and not IsEnemy(plr) then continue end
        if teamCheck and IsSameTeam and IsSameTeam(plr) then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local head = char:FindFirstChild("Head")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not head or not root or hum.Health <= 0 then continue end
        if char:FindFirstChildOfClass("ForceField") then continue end
        local d = (my.Position - root.Position).Magnitude
        if d < bestD then
            bestD, best, bestHead, bestRoot = d, plr, head, root
        end
    end
    return best, bestHead, bestRoot
end

local function getHandSideCFrame(root, head, sideDist, handY, height)
    -- lado de la mano derecha del enemigo, LEJOS (no pegado)
    local rf = root.CFrame
    local right = rf.RightVector
    local dist = tonumber(sideDist) or 14
    local yOff = tonumber(handY) or 0.5
    local h = tonumber(height) or 1.2
    -- posición al lado de la mano (right * dist), ligeramente adelante
    local handPos = root.Position + right * dist + rf.LookVector * 2 + Vector3.new(0, h + yOff, 0)
    local look = head and head.Position or (root.Position + Vector3.new(0, 1.5, 0))
    return CFrame.lookAt(handPos, look), handPos
end

function StartSleepyCounter()
    SafeDisconnect("SleepyCounter")
    config.SleepyCounterEnabled = true
    Connections.SleepyCounter = RunService.Heartbeat:Connect(function()
        if not config.SleepyCounterEnabled then return end
        if not CanDoDangerousMove or not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end
        -- no pelear con rage normal / void al mismo tiempo si UE counter
        local my = getHRP and getHRP()
        if not my then return end
        local teamCheck = config.SleepyCounterTeamCheck ~= false
        local plr, head, root = counterPickTarget(teamCheck, config.SleepyCounterRange or 1e12)
        if not plr or not head or not root then return end

        local cf, pos = getHandSideCFrame(
            root, head,
            config.SleepyCounterSideDist or 14,
            config.SleepyCounterHandY or 0.5,
            config.SleepyCounterHeight or 1.2
        )
        -- body al lado de la mano (lejitos)
        pcall(function()
            my.CFrame = cf
            my.AssemblyLinearVelocity = Vector3.zero
        end)

        -- auto fire cabeza
        local rate = tonumber(config.SleepyCounterFireRate) or 0.02
        if tick() - sleepyLastFire < rate then return end
        sleepyLastFire = tick()
        local lf = FighterController and FighterController.LocalFighter
        local item = lf and lf.EquippedItem
        if item and fireRageUseItem then
            fireRageUseItem(item, cf, head, root)
        end
    end)
    Notify("Sleepy Counter", "ON · lado mano + head")
end

function StopSleepyCounter()
    config.SleepyCounterEnabled = false
    SafeDisconnect("SleepyCounter")
    Notify("Sleepy Counter", "OFF")
end

-- Kicia Counter: TP al CIELO, se mueve de lado a lado (linea), al OFF vuelve
local kiciaSavedCF = nil
local kiciaLineT = 0 -- 0..1 ping-pong
local kiciaLineDir = 1
local kiciaSkyOrigin = nil -- centro de la linea en el cielo

function StartKiciaCounter()
    SafeDisconnect("KiciaCounter")
    config.KiciaCounterEnabled = true

    local S = getgenv()._ShakoKicia or {}
    getgenv()._ShakoKicia = S
    S.idx = 1
    S.t = 0
    S.savedCF = nil
    S.origin = nil
    S.lastFire = 0
    S.currentPos = nil

    local my0 = getHRP and getHRP()
    if my0 then
        S.savedCF = my0.CFrame
        local skyY = tonumber(config.KiciaCounterSkyY) or 600
        S.origin = Vector3.new(my0.Position.X, my0.Position.Y + skyY, my0.Position.Z)
        S.currentPos = S.origin
        pcall(function()
            -- noclip en el cielo para no rebotar
            local char = LocalPlayer.Character
            if char then
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") then p.CanCollide = false end
                end
            end
            my0.CFrame = CFrame.new(S.origin)
            my0.AssemblyLinearVelocity = Vector3.zero
            my0.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    -- Triangulo equilatero en el cielo (3 vertices, solo TP snap)
    local function buildTriangle(origin, side)
        local s = math.max(side, 10)
        local h = s * 0.86602540378 -- sqrt(3)/2
        return {
            origin + Vector3.new(0, 0, (2 / 3) * h),
            origin + Vector3.new(-s * 0.5, 0, -(1 / 3) * h),
            origin + Vector3.new(s * 0.5, 0, -(1 / 3) * h),
        }
    end

    Connections.KiciaCounter = RunService.Heartbeat:Connect(function(dt)
        if not config.KiciaCounterEnabled then return end
        local my = getHRP and getHRP()
        if not my then return end

        if not S.origin then
            if not S.savedCF then S.savedCF = my.CFrame end
            local skyY = tonumber(config.KiciaCounterSkyY) or 600
            local baseY = (S.savedCF and S.savedCF.Position.Y) or my.Position.Y
            S.origin = Vector3.new(my.Position.X, baseY + skyY, my.Position.Z)
            S.currentPos = S.origin
        end

        local side = tonumber(config.KiciaCounterLineWidth) or 120
        local speed = tonumber(config.KiciaCounterMoveSpeed) or 800
        -- velocidad de TPs: speed alto = cambia de vertice mas rapido (solo snaps, no glide)
        local interval = math.clamp(80 / math.max(speed, 20), 0.03, 1.5)

        local pts = buildTriangle(S.origin, side)

        S.t = (S.t or 0) + (dt or 0.016)
        if S.t >= interval then
            S.t = 0
            S.idx = (S.idx or 1) + 1
            if S.idx > 3 then S.idx = 1 end
            S.currentPos = pts[S.idx]
        end

        local pos = S.currentPos or pts[S.idx] or S.origin

        -- mirar al enemigo
        local look = pos + Vector3.new(0, -40, 0)
        local teamCheck = config.KiciaCounterTeamCheck == true
        local plr, head, root = nil, nil, nil
        pcall(function()
            if type(counterPickTarget) == "function" then
                plr, head, root = counterPickTarget(teamCheck, 1e12)
            end
        end)
        if head then
            look = head.Position
        elseif root then
            look = root.Position
        end

        local cf = CFrame.lookAt(pos, look)
        pcall(function()
            -- noclip solo cada ~0.5s (no cada frame = menos lag)
            S._ncT = S._ncT or 0
            if (os.clock() - S._ncT) > 0.5 then
                S._ncT = os.clock()
                local char = LocalPlayer.Character
                if char then
                    for _, p in ipairs(char:GetChildren()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end
            my.CFrame = cf
            my.AssemblyLinearVelocity = Vector3.zero
            my.AssemblyAngularVelocity = Vector3.zero
        end)

        if config.KiciaCounterShoot and head then
            local rate = tonumber(config.KiciaCounterFireRate) or 0.015
            if tick() - (S.lastFire or 0) >= rate then
                S.lastFire = tick()
                pcall(function()
                    if type(rageFireAt) == "function" then
                        rageFireAt(head, root)
                    elseif type(axisFire) == "function" then
                        axisFire(head)
                    end
                end)
            end
        end
    end)

    Notify("Kicia Counter", "ON · triangulo TP cielo")
end

function StopKiciaCounter()
    config.KiciaCounterEnabled = false
    SafeDisconnect("KiciaCounter")
    local S = getgenv()._ShakoKicia or {}
    local my = getHRP and getHRP()
    if my and S.savedCF then
        pcall(function()
            my.CFrame = S.savedCF
            my.AssemblyLinearVelocity = Vector3.zero
        end)
    end
    S.origin = nil
    Notify("Kicia Counter", "OFF")
end





local Connections = {
    Main = nil, StickRender = nil, Fly = nil, AntiUnnamed = nil,
    Noclip = nil, AntiAim = nil, Ragebot = nil, AutoClick = nil,
    NoRecoil = nil, AUWatch = nil, ESP = nil, VisualLoop = nil,
    Aimbot = nil, AimbotInput = nil, AimbotInputEnd = nil, RapidFireChar = nil, VoidSpam = nil,
    PredDodge = nil, Triggerbot = nil, SilentFOV = nil, FOVDraw = nil, Weather = nil, Defense = nil,
    SleepyCounter = nil, KiciaCounter = nil, StickBehind = nil
}

-- FORCE ALL OFF at boot (nada activo al execute)
pcall(function()
    local offKeys = {
        "Enabled","RagebotEnabled","StrafeEnabled","OrbitEnabled","VoidSpamEnabled",
        "FlyEnabled","NoclipEnabled","AntiAimEnabled","AimbotEnabled","SilentAimEnabled",
        "ESPEnabled","ESP","SpeedEnabled","JumpEnabled","AntiUnnamed","UECounter",
        "SleepyCounterEnabled","KiciaCounterEnabled","ManipulationEnabled","AutoClick",
        "ThirdPerson","StretchedRes","WeaponWireframe","WeatherEnabled","HitSoundEnabled",
        "SoftStick","HitboxExpand","FakePosition","Desync","DesyncStrong","BodyTwist",
    }
    for _, k in ipairs(offKeys) do
        if type(config[k]) == "boolean" then config[k] = false end
    end
    config.SoftStick = false
    config.EmoteEnabled = false
    config.EmoteAlwaysOn = false
    config.EmoteKeepPlaying = false
    pcall(StopEmote)
end)


local CurrentTarget, FakePart, RagebotTarget, LockedTarget
local OrbitAngle, SpinAngle, JitterSide = 0, 0, 1
local stickPosIndex, stickPosLast = 1, 0
local CanMove, SpawnTime = false, 0
local LastClick, lastCamCF = 0, nil
local UECounterReady = false
local CoordsSpinAngle = 0
local LastRageSwitch, lastRecoilScan = 0, 0
local lastPredDodge, lastTriggerClick, lastVoidRage = 0, 0, 0
local voidRagePhase = 0
local selectedConfig, configNameInput = "(ninguna)", "default"
local ESPFolder, CrossDraws, WatermarkDraw = {}, {}, nil
-- Drawing API (algunos executors)
pcall(function()
    if not Drawing and getgenv and getgenv().Drawing then Drawing = getgenv().Drawing end
end)

local RapidFireSaved, RapidFireLoopRunning, RecoilSaved = {}, false, {}
local voidElapsed, voidPos, voidDriftDir, voidBase, voidEvadeCD, intendedVoidPos =
    0, Vector3.new(0, 100000000000, 0), Vector3.new(1, 0, 0), Vector3.new(0, 100000000000, 0), 0, Vector3.new(0, 100000000000, 0)

-- Config system (tabla para ahorrar registers Luau)
local Cfg = {
    folder = "shako_configs",
    autoload = "shako_configs/_autoload.txt",
}

-- watermark removed
pcall(function()
    for i = 1, 12 do
        local l = Drawing.new("Line")
        l.Thickness = 1.5
        l.Color = Color3.fromRGB(255, 255, 255)
        l.Visible = false
        CrossDraws[i] = l
    end
    CrossDraws.Dot = Drawing.new("Circle")
    CrossDraws.Dot.Filled = true
    CrossDraws.Dot.Thickness = 0
    CrossDraws.Dot.Radius = 2
    CrossDraws.Dot.Visible = false
    CrossDraws.DotOutline = Drawing.new("Circle")
    CrossDraws.DotOutline.Filled = false
    CrossDraws.DotOutline.Thickness = 1
    CrossDraws.DotOutline.Radius = 3
    CrossDraws.DotOutline.Visible = false
end)

local CC = Lighting:FindFirstChild("SleepyCC") or Instance.new("ColorCorrectionEffect")
CC.Name = "SleepyCC"
CC.Parent = Lighting
local BloomFX = Lighting:FindFirstChild("SleepyBloom") or Instance.new("BloomEffect")
BloomFX.Name = "SleepyBloom"
BloomFX.Enabled = false
BloomFX.Parent = Lighting
local BlurFX = Lighting:FindFirstChild("SleepyBlur") or Instance.new("BlurEffect")
BlurFX.Name = "SleepyBlur"
BlurFX.Enabled = false
BlurFX.Parent = Lighting

local oldLighting = {
    Brightness = Lighting.Brightness,
    Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient,
    ExposureCompensation = Lighting.ExposureCompensation,
    ClockTime = Lighting.ClockTime,
    FogStart = Lighting.FogStart,
    FogEnd = Lighting.FogEnd
}

local Skies = {
    ["Dark Sky"] = {
        SkyboxUp = "rbxassetid://570555929", SkyboxRt = "rbxassetid://570555882",
        SkyboxDn = "rbxassetid://570555964", SkyboxFt = "rbxassetid://570555800",
        SkyboxLf = "rbxassetid://570555840", SkyboxBk = "rbxassetid://570555736"
    },
    ["Nebula"] = {
        SkyboxUp = "rbxassetid://159454288", SkyboxRt = "rbxassetid://159454300",
        SkyboxLf = "rbxassetid://159454286", SkyboxFt = "rbxassetid://159454293",
        SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454296"
    },
    ["Clouds"] = {
        SkyboxUp = "rbxassetid://570557727", SkyboxRt = "rbxassetid://570557672",
        SkyboxLf = "rbxassetid://570557620", SkyboxFt = "rbxassetid://570557559",
        SkyboxBk = "rbxassetid://570557514", SkyboxDn = "rbxassetid://570557775"
    },
    ["Vaporwave"] = {
        SkyboxUp = "rbxassetid://1417494643", SkyboxRt = "rbxassetid://1417494499",
        SkyboxLf = "rbxassetid://1417494402", SkyboxFt = "rbxassetid://1417494253",
        SkyboxBk = "rbxassetid://1417494030", SkyboxDn = "rbxassetid://1417494146"
    },
    ["Twilight"] = {
        SkyboxUp = "rbxassetid://264907379", SkyboxRt = "rbxassetid://264908886",
        SkyboxLf = "rbxassetid://264909758", SkyboxFt = "rbxassetid://264909420",
        SkyboxBk = "rbxassetid://264908339", SkyboxDn = "rbxassetid://264907909"
    },
    ["Art Mountain"] = {
        SkyboxUp = "rbxassetid://2128462236", SkyboxRt = "rbxassetid://2128462027",
        SkyboxLf = "rbxassetid://2128462027", SkyboxFt = "rbxassetid://2128458653",
        SkyboxBk = "rbxassetid://2128458653", SkyboxDn = "rbxassetid://2128462480"
    },
    ["Alien Red"] = {
        SkyboxUp = "rbxassetid://7123412196", SkyboxRt = "rbxassetid://7123402505",
        SkyboxDn = "rbxassetid://7123387679", SkyboxFt = "rbxassetid://7123390433",
        SkyboxLf = "rbxassetid://7123394786", SkyboxBk = "rbxassetid://7123385217"
    }
}

function SetupAntiKick()
    if not config.AntiKick then return end
    pcall(function()
        local mt = getrawmetatable and getrawmetatable(game)
        if mt then
            setreadonly(mt, false)
            local old = mt.__namecall
            mt.__namecall = newcclosure(function(self, ...)
                local method = tostring(getnamecallmethod and getnamecallmethod() or "")
                if method == "Kick" or method == "kick" then
                    if config.BlockIllegalNotify then
                        pcall(function() Notify("AntiKick", "Kick bloqueado") end)
                    end
                    return nil
                end
                return old(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
    pcall(function()
        if hookfunction and typeof(LocalPlayer.Kick) == "function" then
            hookfunction(LocalPlayer.Kick, newcclosure(function()
                if config.BlockIllegalNotify then
                    pcall(function() Notify("AntiKick", "Kick bloqueado") end)
                end
                return nil
            end))
        end
    end)
    pcall(function()
        LocalPlayer.Idled:Connect(function()
            pcall(function()
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end)
        end)
    end)
end

function SafeDisconnect(name)
    if Connections[name] then
        pcall(function() Connections[name]:Disconnect() end)
        Connections[name] = nil
    end
end
function getHRP()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
end
function getHum()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end
function getPlayerTeamId(plr)
    if not plr then return nil end
    local tid = nil
    pcall(function() tid = plr:GetAttribute("TeamID") end)
    if tid == nil then
        pcall(function() tid = plr:GetAttribute("Team") end)
    end
    if tid == nil and plr.Character then
        pcall(function() tid = plr.Character:GetAttribute("TeamID") end)
        if tid == nil then
            pcall(function() tid = plr.Character:GetAttribute("Team") end)
        end
    end
    -- FighterController object team
    if tid == nil and FighterController and FighterController.Objects then
        pcall(function()
            for _, obj in pairs(FighterController.Objects) do
                if obj.Player == plr then
                    tid = obj:Get("TeamID") or (obj.Get and obj:Get("Team"))
                    break
                end
            end
        end)
    end
    -- Spectate / Duel
    if tid == nil and SpectateController then
        pcall(function()
            local duel = SpectateController.CurrentDuelSubject
            if not duel or not duel.GetDueler then return end
            local dueler = duel:GetDueler(plr)
            if dueler then
                tid = dueler:Get("TeamID")
            end
        end)
    end
    if tid == nil and plr.Team then
        tid = plr.Team.Name
    end
    if tid == nil and plr.TeamColor then
        tid = tostring(plr.TeamColor)
    end
    if tid == nil then return nil end
    return tostring(tid)
end


function IsRivalsBot(plr)
    if not plr then return true end
    -- attributes comunes Rivals / bots
    local ok, a = pcall(function()
        return plr:GetAttribute("IsBot")
            or plr:GetAttribute("Bot")
            or plr:GetAttribute("IsNPC")
            or plr:GetAttribute("NPC")
            or plr:GetAttribute("IsTrainingBot")
            or plr:GetAttribute("TrainingBot")
    end)
    if ok and a then return true end
    local name = string.lower(tostring(plr.Name or ""))
    local disp = string.lower(tostring(plr.DisplayName or ""))
    if name:find("bot", 1, true) or disp:find("bot", 1, true) then return true end
    if name:find("npc", 1, true) or disp:find("npc", 1, true) then return true end
    if name:find("dummy", 1, true) or disp:find("dummy", 1, true) then return true end
    if name:find("target", 1, true) and (name:find("train") or disp:find("train")) then return true end
    -- character attributes
    local char = plr.Character
    if char then
        local ok2, ca = pcall(function()
            return char:GetAttribute("IsBot")
                or char:GetAttribute("Bot")
                or char:GetAttribute("IsNPC")
                or char:GetAttribute("NPC")
        end)
        if ok2 and ca then return true end
    end
    -- players muy "fake" (a veces bots sin UserId real en studio)
    pcall(function()
        if plr.UserId and plr.UserId <= 0 then return true end
    end)
    if typeof(plr.UserId) == "number" and plr.UserId <= 0 then return true end
    return false
end

local _ShakoTeamCache, _ShakoTeamCacheT = {}, {}
pcall(function()
    Players.PlayerRemoving:Connect(function(plr)
        _ShakoTeamCache[plr.UserId] = nil
        _ShakoTeamCacheT[plr.UserId] = nil
    end)
end)
function _StrongIsTeammateRaw(plr)
    if not plr or plr == LocalPlayer then return true end

    -- A) Roblox Team instance
    local okT, sameT = pcall(function()
        local a, b = LocalPlayer.Team, plr.Team
        if a ~= nil and b ~= nil then
            return a == b or (a.Name and b.Name and a.Name == b.Name)
        end
        return nil
    end)
    if okT and sameT == true then return true end
    if okT and sameT == false then
        -- equipos distintos confirmados
        return false
    end

    -- B) TeamColor (incluye Neutral si ambos iguales y no es FFA forzado)
    local okC, sameC = pcall(function()
        local ac, bc = LocalPlayer.TeamColor, plr.TeamColor
        if ac and bc then
            if ac == bc then
                return true
            end
            return false
        end
        return nil
    end)
    -- solo confiar en TeamColor si NO es White en ambos (White suele ser default FFA)
    if okC and sameC == true then
        local ac, bc = LocalPlayer.TeamColor, plr.TeamColor
        local an, bn = tostring(ac), tostring(bc)
        if an ~= "White" and bn ~= "White" and an ~= "Medium stone grey" then
            return true
        end
    end

    -- C) Attributes TeamID / Team en player y character
    local function readTid(p)
        if not p then return nil end
        local tid = nil
        pcall(function() tid = p:GetAttribute("TeamID") end)
        if tid == nil then pcall(function() tid = p:GetAttribute("Team") end) end
        if tid == nil then pcall(function() tid = p:GetAttribute("TeamId") end) end
        if tid == nil then pcall(function() tid = p:GetAttribute("team") end) end
        if tid == nil and p.Character then
            local c = p.Character
            pcall(function() tid = c:GetAttribute("TeamID") end)
            if tid == nil then pcall(function() tid = c:GetAttribute("Team") end) end
            if tid == nil then pcall(function() tid = c:GetAttribute("TeamId") end) end
        end
        return tid
    end

    local lt, pt = readTid(LocalPlayer), readTid(plr)
    local function norm(t)
        if t == nil then return nil end
        local x = tostring(t)
        if x == "" or x == "nil" or x == "0" or x == "FFA" or x == "None" or x == "null" then return nil end
        return x
    end
    lt, pt = norm(lt), norm(pt)
    if lt and pt then
        return lt == pt
    end

    -- D) FighterController Objects TeamID
    local myFC, theirFC = nil, nil
    pcall(function()
        if not (FighterController and FighterController.Objects) then return end
        for _, obj in pairs(FighterController.Objects) do
            if not obj then continue end
            local pid = obj.Player
            local tid = nil
            pcall(function()
                if obj.Get then
                    tid = obj:Get("TeamID") or obj:Get("Team") or obj:Get("TeamId")
                end
            end)
            if tid == nil then pcall(function() tid = obj.TeamID or obj.Team end) end
            if pid == LocalPlayer then myFC = norm(tid) end
            if pid == plr then theirFC = norm(tid) end
        end
    end)
    if myFC and theirFC then
        return myFC == theirFC
    end

    -- E) getPlayerTeamId legacy
    if type(getPlayerTeamId) == "function" then
        local a = norm(getPlayerTeamId(LocalPlayer))
        local b = norm(getPlayerTeamId(plr))
        if a and b then return a == b end
    end

    -- F) Billboard / label teammate
    local isMate = false
    pcall(function()
        if plr.Character and plr.Character:FindFirstChild("TeammateLabel") then
            isMate = true
        end
    end)
    if isMate then return true end

    -- G) mismo Team si solo uno tiene Team object nil - no asumir teammate
    return false
end

function StrongIsTeammate(plr)
    if not plr or plr == LocalPlayer then return true end
    local uid = plr.UserId
    local now = os.clock()
    local t = _ShakoTeamCacheT[uid]
    if t and (now - t) < 0.45 and _ShakoTeamCache[uid] ~= nil then
        return _ShakoTeamCache[uid]
    end
    local r = _StrongIsTeammateRaw(plr)
    _ShakoTeamCache[uid] = r
    _ShakoTeamCacheT[uid] = now
    return r
end

function IsSameTeam(plr)
    return StrongIsTeammate(plr)
end

-- true = se puede targetear (enemigo real)
function IsEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if not plr.Character then return false end
    -- TeamCheck OFF = todos enemigos (excepto yo)
    if config.TeamCheck == false and config.AimbotTeamCheck ~= true and config.RagebotTeamCheck ~= true then
        return true
    end
    if StrongIsTeammate and StrongIsTeammate(plr) then return false end
    if IsSameTeam and IsSameTeam(plr) then return false end
    return true
end
function CanDoDangerousMove()
    -- si ya pasó delay o CanMove true
    if CanMove then return true end
    local delay = tonumber(config.SpawnDelay) or 0
    if delay <= 0 then return true end
    return (tick() - (SpawnTime or 0)) >= delay
end
function IsAntiUnnamedActive()
    -- alias: UE Counter activo
    return (config.UECounterEnabled or config.AntiUnnamed) == true and UECounterReady == true
end
-- Cámara: el script NO la toca (ni FOV, ni CFrame, ni Subject, ni tipo).
function LookAtPos(pos) end
function ResetCameraNormal() end
function EnsureCameraFree() end


function nameKey(n)
    return string.lower(tostring(n or "")):gsub("[%s_%-]", "")
end

function ApplySky(name)
    for _, v in pairs(Lighting:GetChildren()) do
        if v:IsA("Sky") then v:Destroy() end
    end
    if name == "None" or not Skies[name] then config.CurrentSky = "None" return end
    local sky = Instance.new("Sky")
    sky.Name = "CustomSky"
    for k, val in pairs(Skies[name]) do sky[k] = val end
    sky.Parent = Lighting
    config.CurrentSky = name
end
local _wallCache = _wallCache or {}
local _mapColorCache = _mapColorCache or {}

local function _mapRoots()
    local roots = {}
    for _, name in ipairs({"Map", "World", "Level", "Arena", "Stages", "Maps", "Geometry", "MapModel"}) do
        local f = workspace:FindFirstChild(name)
        if f then roots[#roots+1] = f end
    end
    if #roots == 0 then
        for _, c in ipairs(workspace:GetChildren()) do
            if (c:IsA("Model") or c:IsA("Folder")) and c.Name ~= "Players" then
                roots[#roots+1] = c
            end
        end
    end
    return roots
end

local _xrayCache = _xrayCache or {}
local function _xraySkip(obj)
    if not obj or not obj:IsA("BasePart") then return true end
    local lp = LocalPlayer
    if lp.Character and obj:IsDescendantOf(lp.Character) then return true end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
    end
    local cam = workspace.CurrentCamera
    if cam and obj:IsDescendantOf(cam) then return true end
    return false
end

local function applyWallXray(on)
    local trans = tonumber(config.WallTransparency) or 0.55
    if on then
        local count = 0
        for _, root in ipairs(_mapRoots()) do
            for _, obj in ipairs(root:GetDescendants()) do
                if count > 4000 then break end
                if obj:IsA("BasePart") and not _xraySkip(obj) then
                    if obj.Transparency < 0.98 then
                        if not _wallCache[obj] then
                            _wallCache[obj] = obj.LocalTransparencyModifier or 0
                        end
                        pcall(function()
                            obj.LocalTransparencyModifier = math.clamp(trans, 0, 0.98)
                        end)
                        count += 1
                    end
                end
            end
        end
        -- fallback: top-level map parts
        if count < 20 then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if count > 4000 then break end
                if obj:IsA("BasePart") and obj.Anchored and not _xraySkip(obj) and obj.Transparency < 0.98 then
                    if not _wallCache[obj] then
                        _wallCache[obj] = obj.LocalTransparencyModifier or 0
                    end
                    pcall(function()
                        obj.LocalTransparencyModifier = math.clamp(trans, 0, 0.98)
                    end)
                    count += 1
                end
            end
        end
    else
        for obj, orig in pairs(_wallCache) do
            if obj and obj.Parent then
                pcall(function() obj.LocalTransparencyModifier = orig or 0 end)
            end
        end
        table.clear(_wallCache)
    end
end

local function applyXRay(on)
    local trans = tonumber(config.XRayTransparency) or 0.5
    if on then
        local count = 0
        local function touch(obj)
            if count > 5000 then return end
            if not obj:IsA("BasePart") or _xraySkip(obj) then return end
            if obj.Transparency >= 0.98 then return end
            if not _xrayCache[obj] then
                _xrayCache[obj] = obj.LocalTransparencyModifier or 0
            end
            pcall(function()
                obj.LocalTransparencyModifier = math.clamp(trans, 0, 0.98)
            end)
            count += 1
        end
        for _, root in ipairs(_mapRoots()) do
            for _, obj in ipairs(root:GetDescendants()) do
                touch(obj)
            end
        end
        if count < 30 then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Anchored then touch(obj) end
            end
        end
    else
        for obj, orig in pairs(_xrayCache) do
            if obj and obj.Parent then
                pcall(function() obj.LocalTransparencyModifier = orig or 0 end)
            end
        end
        table.clear(_xrayCache)
    end
end

local function applyMapColor(on)
    if not on then
        for obj, col in pairs(_mapColorCache) do
            if obj and obj.Parent then pcall(function() obj.Color = col end) end
        end
        table.clear(_mapColorCache)
        return
    end
    local c = Color3.fromRGB(
        tonumber(config.MapColorR) or 80,
        tonumber(config.MapColorG) or 80,
        tonumber(config.MapColorB) or 100
    )
    local count = 0
    for _, root in ipairs(_mapRoots()) do
        for _, obj in ipairs(root:GetDescendants()) do
            if count > 2000 then break end
            if obj:IsA("BasePart") then
                if not _mapColorCache[obj] then _mapColorCache[obj] = obj.Color end
                pcall(function() obj.Color = c end)
                count += 1
            end
        end
    end
end

local function applyRemoveTextures(on)
    if not on then return end
    local count = 0
    for _, root in ipairs(_mapRoots()) do
        for _, obj in ipairs(root:GetDescendants()) do
            if count > 1500 then return end
            if obj:IsA("Texture") or obj:IsA("Decal") then
                pcall(function() obj.Transparency = 1 end)
                count += 1
            end
        end
    end
end

function ApplyVisuals()
    pcall(function()
        if config.Fullbright then
            Lighting.Brightness = 3
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ClockTime = 12
            Lighting.ExposureCompensation = 0.6
            Lighting.GlobalShadows = false
        elseif config.LightingOverride then
            Lighting.Brightness = tonumber(config.Brightness) or 2
            Lighting.ExposureCompensation = tonumber(config.Exposure) or 0
            Lighting.ClockTime = tonumber(config.ClockTime) or 14
            Lighting.Ambient = Color3.fromRGB(
                tonumber(config.AmbientR) or 120,
                tonumber(config.AmbientG) or 120,
                tonumber(config.AmbientB) or 140
            )
            Lighting.OutdoorAmbient = Color3.fromRGB(
                tonumber(config.OutdoorR) or 140,
                tonumber(config.OutdoorG) or 140,
                tonumber(config.OutdoorB) or 160
            )
            if config.GlobalShadows ~= nil then
                Lighting.GlobalShadows = config.GlobalShadows and true or false
            end
            pcall(function()
                Lighting.EnvironmentDiffuseScale = tonumber(config.EnvironmentDiffuse) or 1
                Lighting.EnvironmentSpecularScale = tonumber(config.EnvironmentSpecular) or 1
            end)
        else
            if not config.Fullbright then
                Lighting.Brightness = tonumber(config.Brightness) or oldLighting.Brightness
                Lighting.ExposureCompensation = tonumber(config.Exposure) or oldLighting.ExposureCompensation
                Lighting.ClockTime = tonumber(config.ClockTime) or oldLighting.ClockTime
            end
            if config.AmbientColor then
                Lighting.Ambient = Color3.fromRGB(
                    tonumber(config.AmbientR) or 120,
                    tonumber(config.AmbientG) or 120,
                    tonumber(config.AmbientB) or 140
                )
                Lighting.OutdoorAmbient = Color3.fromRGB(
                    tonumber(config.OutdoorR) or 140,
                    tonumber(config.OutdoorG) or 140,
                    tonumber(config.OutdoorB) or 160
                )
            end
        end

        if config.NoFog then
            Lighting.FogStart = 1e9
            Lighting.FogEnd = 1e9
            pcall(function() Lighting.Atmosphere.Density = 0 end)
        else
            Lighting.FogStart = oldLighting.FogStart
            Lighting.FogEnd = oldLighting.FogEnd
        end

        -- ColorCorrection
        CC.Enabled = true
        CC.Saturation = tonumber(config.Saturation) or 0
        CC.Contrast = tonumber(config.Contrast) or 0
        if config.TintEnabled then
            CC.TintColor = Color3.fromRGB(
                tonumber(config.TintR) or 255,
                tonumber(config.TintG) or 255,
                tonumber(config.TintB) or 255
            )
        else
            CC.TintColor = Color3.new(1, 1, 1)
        end

        -- ColorShift (Lighting)
        if config.ColorShiftEnabled then
            pcall(function()
                Lighting.ColorShift_Top = Color3.fromRGB(
                    tonumber(config.ColorShiftR) or 0,
                    tonumber(config.ColorShiftG) or 0,
                    tonumber(config.ColorShiftB) or 0
                )
                Lighting.ColorShift_Bottom = Lighting.ColorShift_Top
            end)
        end

        BloomFX.Enabled = config.BloomEnabled and true or false
        BloomFX.Intensity = tonumber(config.BloomIntensity) or 0.4
        BlurFX.Enabled = config.BlurEnabled and true or false
        BlurFX.Size = tonumber(config.BlurSize) or 8

        -- World mods (pesados: solo al toggle / apply)
        if config.WallXray then
            task.defer(function() pcall(applyWallXray, true) end)
        end
        if config.MapColorEnabled then
            task.defer(function() pcall(applyMapColor, true) end)
        end
        if config.RemoveTextures then
            task.defer(function() pcall(applyRemoveTextures, true) end)
        end
    end)
end

function ResetVisuals()
    pcall(function()
        Lighting.Brightness = oldLighting.Brightness
        Lighting.Ambient = oldLighting.Ambient
        Lighting.OutdoorAmbient = oldLighting.OutdoorAmbient
        Lighting.ExposureCompensation = oldLighting.ExposureCompensation
        Lighting.ClockTime = oldLighting.ClockTime
        Lighting.FogStart = oldLighting.FogStart
        Lighting.FogEnd = oldLighting.FogEnd
        Lighting.GlobalShadows = true
        pcall(function()
            Lighting.ColorShift_Top = Color3.new(0, 0, 0)
            Lighting.ColorShift_Bottom = Color3.new(0, 0, 0)
        end)
    end)
    CC.Enabled = false
    CC.TintColor = Color3.new(1, 1, 1)
    BloomFX.Enabled = false
    BlurFX.Enabled = false
    config.WallXray = false
    config.MapColorEnabled = false
    pcall(function() applyWallXray(false) end)
    pcall(function() applyMapColor(false) end)
    pcall(ResetCameraNormal)
end

-- ForceField visual (más transparente + estilos)
local FFHighlight = nil

function ClearForceFieldVisual(character)
    character = character or LocalPlayer.Character
    if FFHighlight then
        pcall(function() FFHighlight:Destroy() end)
        FFHighlight = nil
    end
    if character then
        for _, h in ipairs(character:GetChildren()) do
            if h:IsA("Highlight") and (h.Name == "ShakoFF" or h.Name == "ShakoFF2") then
                pcall(function() h:Destroy() end)
            end
        end
        for _, obj in pairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj:GetAttribute("ShakoFFOrigMat") then
                pcall(function()
                    local matName = obj:GetAttribute("ShakoFFOrigMat")
                    local okMat, mat = pcall(function() return Enum.Material[matName] end)
                    if okMat and mat then obj.Material = mat end
                    local tr = obj:GetAttribute("ShakoFFOrigTrans")
                    if tr ~= nil then obj.Transparency = tr end
                    local col = obj:GetAttribute("ShakoFFOrigColor")
                    if typeof(col) == "Color3" then obj.Color = col end
                    obj:SetAttribute("ShakoFFOrigMat", nil)
                    obj:SetAttribute("ShakoFFOrigTrans", nil)
                    obj:SetAttribute("ShakoFFOrigColor", nil)
                end)
            end
        end
    end
end

-- Solo partes del cuerpo (sin Handle de accesorios = sin "cuadros")
local FF_BODY = {
    Head = true, Torso = true, UpperTorso = true, LowerTorso = true,
    LeftArm = true, RightArm = true, LeftLeg = true, RightLeg = true,
    ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
    LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
    RightUpperArm = true, RightLowerArm = true, RightHand = true,
    LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
    RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
}

local function isBodyPartForFF(obj, character)
    if not obj or not obj:IsA("BasePart") then return false end
    if obj.Name == "HumanoidRootPart" then return false end
    -- nunca accesorios / tools (generan cajas ForceField)
    local p = obj.Parent
    while p and p ~= character do
        if p:IsA("Accessory") or p:IsA("Hat") or p:IsA("Tool") or p:IsA("Accoutrement") then
            return false
        end
        p = p.Parent
    end
    if FF_BODY[obj.Name] then return true end
    -- mesh del torso R6 a veces se llama distinto
    if obj.Parent == character and obj:IsA("MeshPart") and FF_BODY[obj.Name] then return true end
    return false
end

function ApplyForceField(character)
    character = character or LocalPlayer.Character
    if not character then return end
    if not config.ForceFieldVisual then
        ClearForceFieldVisual(character)
        return
    end

    local col = config.ForceFieldColor or Color3.fromRGB(180, 0, 255)
    local fillT = tonumber(config.ForceFieldTransparency)
    if fillT == nil then fillT = 0.55 end
    fillT = math.clamp(fillT, 0.05, 0.95)
    local outT = tonumber(config.ForceFieldOutlineTransparency)
    if outT == nil then outT = 0.7 end
    outT = math.clamp(outT, 0, 0.95)
    -- default: solo material en skin (sin highlight que "caja" el modelo)
    local style = tostring(config.ForceFieldStyle or "Material")

    -- opcional: ocultar accesorios para look limpio tipo kicia
    -- no borrar acc si avatar spoof activo
    local spoofOn = config.SkinchangerEnabled or (RivalsSpoof and RivalsSpoof.spoof_avatar)
        or (states and states.spoofer_state and states.spoofer_state.spoof_avatar)
    if config.ForceFieldRemoveAcc and not spoofOn then
        for _, ch in ipairs(character:GetChildren()) do
            if ch:IsA("Accessory") or ch:IsA("Hat") or ch:IsA("Accoutrement") then
                pcall(function() ch:Destroy() end)
            end
        end
    end

    -- Highlight solo si se pide (Outline / Soft) — Occluded = sigue forma del mesh, no caja
    if style == "Highlight" or style == "Both" or style == "Soft" then
        local hl = character:FindFirstChild("ShakoFF")
        if not hl or not hl:IsA("Highlight") then
            if hl then pcall(function() hl:Destroy() end) end
            hl = Instance.new("Highlight")
            hl.Name = "ShakoFF"
            hl.DepthMode = Enum.HighlightDepthMode.Occluded
            hl.Parent = character
        end
        hl.FillColor = col
        hl.OutlineColor = col
        hl.FillTransparency = fillT
        hl.OutlineTransparency = outT
        hl.Enabled = true
        FFHighlight = hl
        if style == "Soft" then
            hl.FillTransparency = math.clamp(fillT + 0.2, 0.55, 0.95)
            hl.OutlineTransparency = math.clamp(outT + 0.15, 0.4, 0.95)
        end
    else
        local hl = character:FindFirstChild("ShakoFF")
        if hl then pcall(function() hl:Destroy() end) end
        FFHighlight = nil
    end

    -- Material ForceField SOLO en partes del cuerpo (no Handles de hats)
    if style == "Material" or style == "Both" or style == "Skin" then
        for _, obj in pairs(character:GetDescendants()) do
            if isBodyPartForFF(obj, character) then
                pcall(function()
                    if not obj:GetAttribute("ShakoFFOrigMat") then
                        obj:SetAttribute("ShakoFFOrigMat", obj.Material.Name)
                        obj:SetAttribute("ShakoFFOrigTrans", obj.Transparency)
                        obj:SetAttribute("ShakoFFOrigColor", obj.Color)
                    end
                    obj.Material = Enum.Material.ForceField
                    obj.Color = col
                    obj.Transparency = math.clamp(fillT * 0.7, 0.15, 0.85)
                end)
            end
        end
    else
        -- limpiar material si solo Highlight
        for _, obj in pairs(character:GetDescendants()) do
            if obj:IsA("BasePart") and obj:GetAttribute("ShakoFFOrigMat") then
                pcall(function()
                    local matName = obj:GetAttribute("ShakoFFOrigMat")
                    local okMat, mat = pcall(function() return Enum.Material[matName] end)
                    if okMat and mat then obj.Material = mat end
                    local tr = obj:GetAttribute("ShakoFFOrigTrans")
                    if tr ~= nil then obj.Transparency = tr end
                    local c = obj:GetAttribute("ShakoFFOrigColor")
                    if typeof(c) == "Color3" then obj.Color = c end
                    obj:SetAttribute("ShakoFFOrigMat", nil)
                    obj:SetAttribute("ShakoFFOrigTrans", nil)
                    obj:SetAttribute("ShakoFFOrigColor", nil)
                end)
            end
        end
    end
end

function StartForceField()
    config.ForceFieldVisual = true
    ApplyForceField(LocalPlayer.Character)
    SafeDisconnect("ForceField")
    SafeDisconnect("ForceFieldLoop")
    local char = LocalPlayer.Character
    if char then
        Connections.ForceField = char.ChildRemoved:Connect(function(ch)
            if config.ForceFieldVisual and (ch.Name == "ShakoFF" or ch.Name == "ShakoFF2") then
                task.defer(function() ApplyForceField(LocalPlayer.Character) end)
            end
        end)
    end
    Connections.ForceFieldLoop = task.spawn(function()
        local t = 0
        while config.ForceFieldVisual do
            task.wait(config.ForceFieldPulse and 0.08 or 1.5)
            if not config.ForceFieldVisual then break end
            if config.ForceFieldPulse then
                t = t + 0.08
                local base = tonumber(config.ForceFieldTransparency) or 0.72
                local pulse = base + math.sin(t * 3) * 0.08
                config.ForceFieldTransparency = math.clamp(pulse, 0.2, 0.95)
            end
            ApplyForceField(LocalPlayer.Character)
        end
    end)
    if not getgenv()._ShakoQuiet then
        Notify("ForceField", "ON")
    end
end

function StopForceField()
    config.ForceFieldVisual = false
    SafeDisconnect("ForceField")
    SafeDisconnect("ForceFieldLoop")
    ClearForceFieldVisual(LocalPlayer.Character)
    if not getgenv()._ShakoQuiet and not (getgenv()._ShakoBootAt and tick() - getgenv()._ShakoBootAt < 8) then
        Notify("ForceField", "OFF")
    end
end

function ApplyCharVisuals()
    -- NO tocar LocalTransparencyModifier (rompe zoom al apuntar)
    if not config.ApplyCharVisualsEnabled then return end
    local char = LocalPlayer.Character
    if not char then return end
    if config.RemoveAccessories then
        for _, p in pairs(char:GetChildren()) do
            if p:IsA("Accessory") or p:IsA("Hat") then p:Destroy() end
        end
    end
end

function MoveBodyTo(goal, lookAt)
    local myHRP = getHRP()
    if not myHRP then return end
    EnsureCameraFree()
    local current = myHRP.Position
    local delta = goal - current
    local dist = delta.Magnitude
    local function setAt(pos)
        if lookAt and not (config.RageDesync and config.RagebotEnabled) and not config.CameraIndependent then
            myHRP.CFrame = CFrame.new(pos, lookAt)
        else
            local flat = Vector3.new(goal.X - pos.X, 0, goal.Z - pos.Z)
            if flat.Magnitude > 0.15 then
                myHRP.CFrame = CFrame.new(pos, pos + flat)
            else
                myHRP.CFrame = CFrame.new(pos) * (myHRP.CFrame - myHRP.CFrame.Position)
            end
        end
        if config.ForceZeroVelocity then
            myHRP.AssemblyLinearVelocity = Vector3.zero
            myHRP.AssemblyAngularVelocity = Vector3.zero
        end
    end
    -- desync / SoftStick OFF = instant
    local forceInstant = (config.RageDesync and config.RagebotEnabled)
        or config.SoftStick == false
    local soft = config.SoftStick and not forceInstant
    if soft and dist > 0.08 then
        local maxStep = math.max(config.SoftStickMaxStep or 5, 0.5)
        local speed = config.SoftStickSpeed or 180
        local step = math.min(dist, maxStep, speed / 60)
        setAt(current + delta.Unit * step)
    else
        setAt(goal) -- instant
    end
end

function SafeEnemyCFrame(root, extraY, sideX, sideZ, lookAt)
    if not root then return end
    local base = root.Position
    local ox = (sideX or 0) + (config.StickOffsetX or 0)
    local oz = (sideZ or 0) + (config.StickOffsetZ or 0)
    local y = base.Y + (extraY or config.StickHeight)
    if config.LockYWhileStick then
        local myHRP = getHRP()
        if myHRP then y = myHRP.Position.Y end
    end
    local minY = workspace.FallenPartsDestroyHeight + (config.SafeZoneMinY or 30)
    if y < minY then y = minY + 1 end
    MoveBodyTo(Vector3.new(base.X + ox, y, base.Z + oz), lookAt)
end

-- ==================== TP ATRAS (INDEPENDIENTE DEL RAGE) ====================
function StartStickBehindTP()
    SafeDisconnect("StickBehind")
    config.StickBehindTP = true
    Connections.StickBehind = RunService.Heartbeat:Connect(function()
        if not config.StickBehindTP then return end
        if CanDoDangerousMove and not CanDoDangerousMove() then return end
        local my = getHRP and getHRP()
        if not my then return end
        local maxR = config.StickBehindRange
        if maxR == nil or maxR ~= maxR or maxR <= 0 then maxR = math.huge end -- nil/nan = infinito
        local best, bestD = nil, maxR
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character
            if not char then continue end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then continue end
            if IsEnemy and not IsEnemy(plr) then continue end
            local d = (my.Position - root.Position).Magnitude
            if d <= maxR and d < bestD then bestD, best = d, plr end
        end
        if not best or not best.Character then return end
        local root = best.Character:FindFirstChild("HumanoidRootPart")
        local head = best.Character:FindFirstChild("Head")
        if not root then return end
        local dist = tonumber(config.StickBehindDist) or 10
        local h = tonumber(config.StickBehindHeight) or 1.5
        local look = root.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.05 then flat = flat.Unit else flat = Vector3.new(0, 0, 1) end
        local pos = root.Position - flat * dist + Vector3.new(0, h, 0)
        local minY = workspace.FallenPartsDestroyHeight + (config.SafeZoneMinY or 30)
        if pos.Y < minY then pos = Vector3.new(pos.X, minY + 1, pos.Z) end
        local lookAt = head and head.Position or (root.Position + Vector3.new(0, 1.5, 0))
        pcall(function()
            my.CFrame = CFrame.lookAt(pos, lookAt)
            my.AssemblyLinearVelocity = Vector3.zero
            my.AssemblyAngularVelocity = Vector3.zero
        end)
    end)
    Notify("TP Atras", "ON")
end

function StopStickBehindTP()
    config.StickBehindTP = false
    SafeDisconnect("StickBehind")
    Notify("TP Atras", "OFF")
end


function SyncAimOnShoot(headPos)
    return
end

function VoidRageOffset(root)
    local method = config.VoidRageMethods or "Side"
    local dist = config.VoidRageAwayDist or 100000000000
    local look = root.CFrame.LookVector
    local right = Vector3.new(-look.Z, 0, look.X)
    if right.Magnitude < 0.01 then right = Vector3.new(1, 0, 0) else right = right.Unit end
    local back = -Vector3.new(look.X, 0, look.Z)
    if back.Magnitude > 0.01 then back = back.Unit else back = Vector3.new(0, 0, 1) end
    local t = tick()

    if method == "Up" then
        return Vector3.new(0, dist, 0)
    elseif method == "Down" then
        return Vector3.new(0, -math.abs(dist) * 0.6, 0)
    elseif method == "Back" then
        return back * dist + Vector3.new(0, 4, 0)
    elseif method == "Front" then
        return -back * dist + Vector3.new(0, 3, 0)
    elseif method == "Diagonal" then
        local side = (math.floor(t * 2) % 2 == 0) and 1 or -1
        return (right * side + Vector3.new(0, 1, 0) + back * 0.5).Unit * dist
    elseif method == "Orbit" then
        local a = t * 8
        return Vector3.new(math.cos(a) * dist, 6 + math.sin(t * 3) * 4, math.sin(a) * dist)
    elseif method == "ZigZag" then
        local side = (math.floor(t * 5) % 2 == 0) and 1 or -1
        return right * dist * side + Vector3.new(0, 5 + (t % 2) * 4, 0)
    elseif method == "TeleportSpam" then
        local opts = {
            Vector3.new(0, dist, 0),
            right * dist,
            -right * dist,
            back * dist,
            Vector3.new(0, dist * 0.5, 0) + right * dist * 0.5,
        }
        return opts[math.random(1, #opts)]
    elseif method == "HighCircle" then
        local a = t * 7
        return Vector3.new(math.cos(a) * dist, dist * 0.7, math.sin(a) * dist)
    elseif method == "Random" then
        return Vector3.new((math.random() - 0.5) * dist * 2, math.random() * dist * 0.5, (math.random() - 0.5) * dist * 2)
    elseif method == "Circle" then
        local a = t * 6
        return Vector3.new(math.cos(a) * dist, 8, math.sin(a) * dist)
    else -- Side
        local side = (math.floor(t * 2) % 2 == 0) and 1 or -1
        return right * dist * side + Vector3.new(0, 6, 0)
    end
end

-- VOID SPAM
-- Void Extreme drift (Lua x paid noise 3D)
function computeVoidDrift(t)
    local nx, ny, nz, amp, freq = 0, 0, 0, 1, 0.0001
    for i = 1, 4 do
        nx = nx + math.noise(t * freq, 0, 0) * amp
        ny = ny + math.noise(0, t * freq, 0) * amp
        nz = nz + math.noise(0, 0, t * freq) * amp
        freq = freq * 2.37
        amp = amp * 0.5
    end
    local sp, cp = t * 0.00073, t * 0.00213
    nx = nx + math.noise(sp + 13.7, 7.3, 0) * 0.3 + math.sin(cp) * math.cos(cp * 1.618) * 0.2
    ny = ny + math.noise(0, sp + 31.1, 17.9) * 0.3 + math.cos(cp * 0.618) * math.sin(cp * 2.718) * 0.2
    nz = nz + math.noise(7.3, 0, sp + 11.5) * 0.3 + math.sin(cp * 1.3) * math.cos(cp * 0.7) * 0.2
    local len = math.sqrt(nx * nx + ny * ny + nz * nz)
    if len < 0.001 then return Vector3.new(1, 0, 0) end
    return Vector3.new(nx / len, ny / len, nz / len)
end
local voidBounceDir = Vector3.new(1, 1, 1)
local voidStrobePhase = false

function stepVoid(dt)
    local m = config.VoidMethod or "Quantum"
    local speed = config.VoidSpeed or 1e12
    local radius = config.VoidRadius or 1e11
    local t = voidElapsed
    if m == "Drift" then
        voidDriftDir = voidDriftDir:Lerp(computeVoidDrift(t), (config.VoidChaos or 0.98) * dt * 10)
        voidPos = voidPos + voidDriftDir * speed * dt
        if (voidPos - voidBase).Magnitude > radius then
            voidPos = voidBase + (voidPos - voidBase).Unit * radius
            voidDriftDir = -voidDriftDir
        end
        return voidPos
    elseif m == "Chaos" then
        local s = speed * dt * 8
        voidPos = voidPos + Vector3.new((math.random()-0.5)*s, (math.random()-0.5)*s, (math.random()-0.5)*s)
        if (voidPos - voidBase).Magnitude > radius then voidPos = voidBase + (voidPos - voidBase).Unit * radius end
        return voidPos
    elseif m == "Loop" or m == "Wave" then
        local r = math.min(radius * 0.85, 1e9 + (t % 100) * 1e7)
        return voidBase + Vector3.new(math.sin(t*8)*r, math.sin(t*1.7)*r*0.25, math.cos(t*0.9)*r)
    elseif m == "Spiral" or m == "Helix" then
        local r = math.min(radius * 0.9, (t % 50) * 2e9 + radius * 0.2)
        local w = t * 6
        return voidBase + Vector3.new(math.cos(w*2)*r, math.sin(w)*r*0.35, math.sin(w*2)*r)
    elseif m == "Bounce" then
        if math.random() < 0.2 then
            voidBounceDir = Vector3.new(math.random()>0.5 and 1 or -1, math.random()>0.5 and 1 or -1, math.random()>0.5 and 1 or -1)
        end
        voidPos = voidPos + voidBounceDir * (radius * 0.12)
        if (voidPos - voidBase).Magnitude > radius then
            voidPos = voidBase + (voidPos - voidBase).Unit * radius * 0.8
            voidBounceDir = -voidBounceDir
        end
        return voidPos
    elseif m == "Strobe" then
        voidStrobePhase = not voidStrobePhase
        local s = voidStrobePhase and 1 or -1
        return voidBase + Vector3.new(s*radius*0.6, s*radius*0.3, s*radius*0.6)
    elseif m == "Cross" then
        if (math.floor(t * 12) % 2) == 0 then
            return voidBase + Vector3.new((math.random()-0.5)*radius, 0, 0)
        end
        return voidBase + Vector3.new(0, (math.random()-0.5)*radius*0.5, (math.random()-0.5)*radius)
    else
        local r = radius * (math.random() > 0.5 and 1 or -1)
        return voidBase + Vector3.new(r, (math.random()-0.5)*radius*0.25, r)
            + Vector3.new((math.random()-0.5)*radius, 0, (math.random()-0.5)*radius)
    end
end
function voidEvadeCheck()
    if not config.VoidEvade or voidEvadeCD > 0 then return end
    local my = getHRP()
    local minD, threat = math.huge, Vector3.new(0, 1, 0)
    local hard = false
    for _, p in pairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        if config.TeamCheck and IsSameTeam and IsSameTeam(p) then continue end
        local hrp = p.Character:FindFirstChild("HumanoidRootPart")
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and hum.Health > 0 then
            local vel = hrp.AssemblyLinearVelocity
            local pred = hrp.Position + vel * 0.2
            local d = (pred - intendedVoidPos).Magnitude
            if d < minD then
                minD = d
                local diff = pred - intendedVoidPos
                threat = diff.Magnitude > 0.1 and diff.Unit or threat
            end
            if my then
                local toMe = my.Position - hrp.Position
                if toMe.Magnitude > 0.5 and vel.Magnitude > 40 and toMe.Unit:Dot(vel.Unit) > 0.12 then
                    hard = true
                    minD = 0
                    threat = -toMe.Unit
                end
            end
        end
    end
    local triggerR = (config.VoidEvadeRadius or 9e15) * (tonumber(config.VoidEvadeTrigger) or 1)
    if hard or minD < triggerR then
        local strength = tonumber(config.VoidEvadeStrength) or 1
        local evadeSpd = tonumber(config.VoidEvadeDist) or tonumber(config.VoidSpeed) or 1e12
        local nearFactor = 1
        if triggerR > 0 and minD < triggerR and minD < math.huge then
            nearFactor = 1 + (1 - math.clamp(minD / triggerR, 0, 1)) * 2
        end
        if hard then nearFactor = nearFactor + 2 end
        local push = evadeSpd * nearFactor * strength * 0.5
        local vert = tonumber(config.VoidEvadeVert) or 3e9
        voidPos = voidPos - threat * push + Vector3.new(0, vert * 0.05 * strength, 0)
        local rad = config.VoidRadius or 1e11
        if (voidPos - voidBase).Magnitude > rad then
            voidPos = voidBase + (voidPos - voidBase).Unit * rad
        end
        voidEvadeCD = math.min(tonumber(config.VoidEvadeCooldown) or 0.05, 0.08)
    end
end

-- Desync visual para TODOS los voids: otros te ven en el vacio, vos te ves quieto
function VoidServerMove(goal)
    local h = getHRP()
    if not h then return end
    local goalCF = typeof(goal) == "CFrame" and goal or CFrame.new(goal)
    local oldCF = h.CFrame
    local oldVel = h.AssemblyLinearVelocity
    local oldRot = h.AssemblyAngularVelocity
    pcall(function() RunService:UnbindFromRenderStep("__as_void_desync") end)
    h.CFrame = goalCF
    h.AssemblyLinearVelocity = Vector3.zero
    h.AssemblyAngularVelocity = Vector3.zero
    RunService:BindToRenderStep("__as_void_desync", Enum.RenderPriority.Camera.Value - 1, function()
        if h and h.Parent then
            h.CFrame = oldCF
            h.AssemblyLinearVelocity = oldVel
            h.AssemblyAngularVelocity = oldRot
        end
        pcall(function() RunService:UnbindFromRenderStep("__as_void_desync") end)
    end)
end

function StartVoidSpam()
    SafeDisconnect("VoidSpam")
    config.VoidSpamEnabled = true
    local hrp = getHRP()
    local alt = tonumber(config.VoidBaseAltitude) or 1e11
    if config.VoidEvade then
        alt = tonumber(config.VoidEvadeDist) or alt
        config.VoidRadius = tonumber(config.VoidRadius) or 1e11
    end
    if hrp then
        voidPos = Vector3.new(hrp.Position.X, alt, hrp.Position.Z)
        voidBase = Vector3.new(0, alt, 0)
        intendedVoidPos = voidPos
    else
        voidPos = Vector3.new(0, alt, 0)
        voidBase = voidPos
        intendedVoidPos = voidPos
    end
    voidElapsed = 0
    voidEvadeCD = 0
    Connections.VoidSpam = RunService.Heartbeat:Connect(function(dt)
        if not config.VoidSpamEnabled then return end
        if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end
        if CanDoDangerousMove and not CanDoDangerousMove() then return end
        voidElapsed = voidElapsed + dt
        if voidEvadeCD > 0 then voidEvadeCD = voidEvadeCD - dt end
        pcall(voidEvadeCheck)
        intendedVoidPos = stepVoid(dt)
        if config.RagebotEnabled and voidRagePhase == 1 then return end
        local h = getHRP()
        if not h then return end
        -- DESYNC: server/otros te ven en el vacio, TU te ves quieto
        if VoidServerMove then
            VoidServerMove(CFrame.new(intendedVoidPos))
        else
            local oldCF, oldVel, oldRot = h.CFrame, h.AssemblyLinearVelocity, h.AssemblyAngularVelocity
            h.CFrame = CFrame.new(intendedVoidPos)
            h.AssemblyLinearVelocity = Vector3.zero
            RunService:BindToRenderStep("__as_void_desync", Enum.RenderPriority.Camera.Value - 1, function()
                if h and h.Parent then
                    h.CFrame = oldCF
                    h.AssemblyLinearVelocity = oldVel
                    h.AssemblyAngularVelocity = oldRot
                end
                pcall(function() RunService:UnbindFromRenderStep("__as_void_desync") end)
            end)
        end
        if config.VoidChaosVel ~= false and math.random(1, 10) == 1 then
            -- velocity chaos solo en el frame server (antes del restore)
            pcall(function()
                h.AssemblyLinearVelocity = Vector3.new(
                    (math.random() - 0.5) * 2e7,
                    (math.random() - 0.5) * 2e7,
                    (math.random() - 0.5) * 2e7
                )
            end)
        end
    end)
    if not getgenv()._ShakoQuiet then
        pcall(function() Notify("Void Spam", "ON · " .. tostring(config.VoidMethod or "Quantum")) end)
    end
end
function StopVoidSpam()
    SafeDisconnect("VoidSpam")
    pcall(function() RunService:UnbindFromRenderStep("__as_void_desync") end)
end

function StartPredDodge()
    SafeDisconnect("PredDodge")
    Connections.PredDodge = RunService.Heartbeat:Connect(function(dt)
        if not config.PredDodgeEnabled or not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive() then return end
        if config.RagebotEnabled and voidRagePhase == 1 then return end
        local hrp, hum = getHRP(), getHum()
        if not hrp or not hum or hum.Health <= 0 then return end
        local myPos = hrp.Position
        for _, p in pairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            if config.TeamCheck and IsSameTeam(p) then continue end
            local tr = p.Character:FindFirstChild("HumanoidRootPart")
            if not tr then continue end
            local vel = tr.AssemblyLinearVelocity
            -- HVH: umbral mas bajo para detectar ragers (kicia/UE)
            if vel.Magnitude < (config.PredThreshold or 55) then continue end
            local pred = tr.Position + vel * (dt * 4 * (config.PredMult or 1.4))
            if (pred - myPos).Magnitude < (config.PredRadius or 90) and tick() - lastPredDodge > (config.PredCooldown or 0.12) then
                lastPredDodge = tick()
                local perp = Vector3.new(-vel.Z, 0, vel.X)
                if perp.Magnitude < 0.01 then perp = Vector3.new(1, 0, 0) end
                perp = perp.Unit
                local dir = math.random(0, 1) == 0 and perp or -perp
                local goal = myPos + dir * (config.PredDodgeDist or 30)
                if config.SoftStick then
                    local step = math.min((goal - myPos).Magnitude, config.SoftStickMaxStep or 5)
                    hrp.CFrame = CFrame.new(myPos + (goal - myPos).Unit * step)
                else
                    hrp.CFrame = CFrame.new(goal)
                end
                break
            end
        end
    end)
end
function StopPredDodge() SafeDisconnect("PredDodge") end

-- Auto Collect Heals/Ammo (FFA drops)
local lastCollectScan = 0
local collectCache = {}

local function isCollectablePart(obj)
    if not obj then return false end
    local n = string.lower(obj.Name)
    if n:find("heal") or n:find("health") or n:find("medkit") or n:find("bandage")
        or n:find("pack") or n:find("pickup") or n:find("drop") or n:find("orb")
        or n:find("ammo") or n:find("bullet") or n:find("armor") or n:find("shieldpack") then
        return true
    end
    return false
end

local function getCollectPosition(obj)
    if obj:IsA("BasePart") then return obj.Position end
    if obj:IsA("Model") then
        local pp = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart", true)
        if pp then return pp.Position end
    end
    if obj:IsA("Attachment") and obj.Parent and obj.Parent:IsA("BasePart") then
        return obj.Parent.Position
    end
    return nil
end

function StartAutoCollect()
    SafeDisconnect("AutoCollect")
    lastCollectScan = 0
    Connections.AutoCollect = RunService.Heartbeat:Connect(function()
        if not config.AutoCollectHeals then return end
        if not CanDoDangerousMove or not CanDoDangerousMove() then return end
        -- no interrumpir rage attack
        if config.RagebotEnabled and voidRagePhase == 1 then return end
        if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end
        local my = getHRP()
        if not my then return end
        local radius = tonumber(config.AutoCollectRadius) or 60
        local now = tick()
        -- rescan cada 0.2s (no lag)
        if now - lastCollectScan > 0.2 then
            lastCollectScan = now
            collectCache = {}
            local function scan(parent, depth)
                if depth > 4 then return end
                for _, o in ipairs(parent:GetChildren()) do
                    if isCollectablePart(o) then
                        local pos = getCollectPosition(o)
                        if pos then
                            local d = (pos - my.Position).Magnitude
                            if d <= radius then
                                table.insert(collectCache, {pos = pos, d = d, name = o.Name})
                            end
                        end
                    end
                    -- carpetas comunes de drops
                    if o:IsA("Folder") or o:IsA("Model") then
                        local ln = string.lower(o.Name)
                        if ln:find("drop") or ln:find("pickup") or ln:find("loot")
                            or ln:find("item") or ln:find("pack") or ln:find("ffa")
                            or depth < 2 then
                            scan(o, depth + 1)
                        end
                    end
                end
            end
            pcall(function() scan(workspace, 0) end)
            table.sort(collectCache, function(a, b) return a.d < b.d end)
        end
        local best = collectCache[1]
        if not best then return end
        -- solo heals si Ammo off? si AutoCollectAmmo, toma todo
        local n = string.lower(best.name or "")
        local isAmmo = n:find("ammo") or n:find("bullet")
        if isAmmo and config.AutoCollectAmmo == false then
            best = nil
            for _, c in ipairs(collectCache) do
                local nn = string.lower(c.name or "")
                if not (nn:find("ammo") or nn:find("bullet")) then best = c break end
            end
        end
        if not best then return end
        if (best.pos - my.Position).Magnitude > 3 then
            pcall(function()
                my.CFrame = CFrame.new(best.pos + Vector3.new(0, 2.5, 0))
                my.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end)
end
function StopAutoCollect() SafeDisconnect("AutoCollect") end

-- ==================== AUTO LOADOUT / VOTE / BAN ====================
local lastAutoLoadout, lastAutoVote, lastAutoBan = 0, 0, 0
local banIndex = 1

local LOADOUT_PRIMARY = {"Crossbow", "Grenade Launcher", "Burst Rifle", "Distortion", "Flamethrower", "Shotgun", "RPG", "Assault Rifle", "Sniper", "Minigun", "Energy Rifle", "Paintball Gun", "Bow", "Gunblade"}
local LOADOUT_SECONDARY = {"Slingshot", "Flare Gun", "Spray", "Shorty", "Energy Pistols", "Warper", "Daggers", "Scepter", "Exogun", "Revolver", "Uzi", "Glass Cannon", "Handgun"}
local LOADOUT_MELEE = {"Fists", "Scythe", "Battle Axe", "Trowel", "Riot Shield", "Glass Shard", "Knife", "Chainsaw", "Katana"}
local LOADOUT_UTILITY = {"Medkit", "Flashbang", "Elixir", "Subspace Tripmine", "War Horn", "Grenade", "Warpstone", "Molotov", "Freeze Ray", "RNG Dice", "Smoke Grenade", "Jump Pad", "Satchel"}
local VOTE_MAPS = {"Arena", "Big Graveyard", "Docks", "Splash", "Bridge", "Crossroads", "Big Crossroads", "Big Backrooms", "Battleground", "Big Arena", "Construction", "Playground", "Onyx", "Graveyard", "Big Splash", "Big Onyx", "Backrooms", "Station", "Dimension"}

local function getDuelsVoteRemote()
    local ok, rem = pcall(function()
        return RS.Remotes.Duels.Vote
    end)
    return ok and rem or nil
end

local function getPickWeaponsRemote()
    local ok, rem = pcall(function()
        return RS.Remotes.Replication.Fighter.PickWeapons
    end)
    return ok and rem or nil
end

function StartMatchAutos()
    SafeDisconnect("MatchAutos")
    Connections.MatchAutos = RunService.Heartbeat:Connect(function()
        local now = tick()
        -- Auto Loadout
        if config.AutoLoadoutEnabled then
            local iv = tonumber(config.AutoLoadoutInterval) or 2
            if now - lastAutoLoadout >= iv then
                lastAutoLoadout = now
                local rem = getPickWeaponsRemote()
                if rem then
                    pcall(function()
                        rem:FireServer({
                            config.AutoLoadoutPrimary or "Assault Rifle",
                            config.AutoLoadoutSecondary or "Handgun",
                            config.AutoLoadoutMelee or "Fists",
                            config.AutoLoadoutUtility or "Grenade",
                        })
                    end)
                end
            end
        end
        -- Auto Vote map
        if config.AutoVoteEnabled then
            local iv = tonumber(config.AutoVoteInterval) or 1
            if now - lastAutoVote >= iv then
                lastAutoVote = now
                local rem = getDuelsVoteRemote()
                if rem then
                    pcall(function()
                        rem:FireServer(config.AutoVoteMap or "Arena")
                    end)
                end
            end
        end
        -- Auto Ban weapon (cycles list or single)
        if config.AutoBanWeaponEnabled then
            local iv = tonumber(config.AutoBanInterval) or 1
            if now - lastAutoBan >= iv then
                lastAutoBan = now
                local rem = getDuelsVoteRemote()
                if rem then
                    local list = config.AutoBanWeapons
                    local name = config.AutoBanWeaponCurrent or "Sniper"
                    if type(list) == "table" and #list > 0 then
                        banIndex = ((banIndex - 1) % #list) + 1
                        name = list[banIndex]
                        banIndex = banIndex % #list + 1
                    end
                    pcall(function() rem:FireServer(name) end)
                end
            end
        end
    end)
end

function StopMatchAutos()
    SafeDisconnect("MatchAutos")
end

function RefreshMatchAutos()
    if config.AutoLoadoutEnabled or config.AutoVoteEnabled or config.AutoBanWeaponEnabled then
        StartMatchAutos()
    else
        StopMatchAutos()
    end
end



-- ==================== RIOT (Lua x paid style) ====================
local riotTimer, riotAngle = 0, 0

function StartRiot()
    SafeDisconnect("Riot")
    riotTimer, riotAngle = 0, 0
    Connections.Riot = RunService.Heartbeat:Connect(function(dt)
        if not config.RiotEnabled or not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end
        -- compatible con rage: solo pausa en ATTACK
        if config.RagebotEnabled and voidRagePhase == 1 then return end
        local root = getHRP()
        if not root then return end
        riotTimer = riotTimer + dt
        local speed = tonumber(config.RiotSpeed) or 0.03
        if riotTimer < speed then return end
        riotTimer = 0
        local range = tonumber(config.RiotRange) or 50
        local evadeR = tonumber(config.RiotEvadeRange) or 30
        local currentPos = root.Position
        local newPos = currentPos
        -- closest enemy
        local best, bestD = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            if config.TeamCheck and IsSameTeam and IsSameTeam(p) then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (currentPos - hrp.Position).Magnitude
                if d < bestD then bestD, best = d, hrp end
            end
        end
        if best and bestD < evadeR then
            local dir = (currentPos - best.Position)
            if dir.Magnitude < 0.1 then dir = Vector3.new(1, 0, 0) else dir = dir.Unit end
            newPos = currentPos + dir * math.random(math.floor(range * 0.5), math.floor(range * 1.5))
        else
            local angle = math.random() * 2 * math.pi
            newPos = currentPos + Vector3.new(
                math.cos(angle) * math.random(math.floor(range * 0.2), range),
                math.random(-math.floor(range * 0.5), math.floor(range * 0.5)),
                math.sin(angle) * math.random(math.floor(range * 0.2), range)
            )
        end
        riotAngle = (riotAngle + (tonumber(config.RiotSpinSpeed) or 180) * speed) % 360
        pcall(function()
            root.CFrame = CFrame.new(newPos) * CFrame.Angles(0, math.rad(riotAngle), 0)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end)
end
function StopRiot() SafeDisconnect("Riot") end

function StartRiotAbuse()
    SafeDisconnect("RiotAbuse")
    Connections.RiotAbuse = RunService.Heartbeat:Connect(function()
        if not config.RiotAbuseEnabled or not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end
        -- con rage: solo en HIDE (no pelear posición de attack)
        if config.RagebotEnabled and voidRagePhase == 1 then return end
        local root = getHRP()
        if not root then return end
        local best, bestD = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p == LocalPlayer or not p.Character then continue end
            if config.TeamCheck and IsSameTeam and IsSameTeam(p) then continue end
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            local hum = p.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (root.Position - hrp.Position).Magnitude
                if d < bestD then bestD, best = d, hrp end
            end
        end
        if not best then return end
        local h = tonumber(config.RiotAbuseHeight) or 3
        local f = tonumber(config.RiotAbuseForward) or 0
        local r = tonumber(config.RiotAbuseRight) or 0
        local dwn = tonumber(config.RiotAbuseDown) or 0
        local mode = config.RiotAbuseMode or "Stick"
        local targetPos
        if mode == "Bounce" then
            local bounce = math.abs(math.sin(tick() * 8)) * math.abs(h)
            targetPos = best.Position + Vector3.new(r, bounce - dwn, f)
        else
            targetPos = best.Position + Vector3.new(r, h - dwn, f)
        end
        pcall(function()
            root.CFrame = CFrame.new(targetPos)
            root.AssemblyLinearVelocity = Vector3.zero
        end)
    end)
end
function StopRiotAbuse() SafeDisconnect("RiotAbuse") end





-- Blink HVH (meoww): snaps rapidos para joder tracking de ragers
function StartBlink()
    SafeDisconnect("Blink")
    local acc = 0
    Connections.Blink = RunService.Heartbeat:Connect(function(dt)
        if not config.BlinkEnabled or not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive() then return end
        -- con void spam / rage attack: no blink (deja void/rage)
        if config.RagebotEnabled and voidRagePhase == 1 then return end
        if config.VoidSpamEnabled and not config.RagebotEnabled then return end
        acc = acc + dt
        local rate = math.max(tonumber(config.BlinkRate) or 40, 5)
        if acc < 1 / rate then return end
        acc = 0
        local h = getHRP()
        if not h then return end
        local r = tonumber(config.BlinkRadius) or 90
        local off = Vector3.new((math.random()-0.5)*2*r, math.random()*r*0.4, (math.random()-0.5)*2*r)
        -- desync-style: server blink, client quieto
        if VoidServerMove then
            VoidServerMove(h.Position + off)
        else
            h.CFrame = CFrame.new(h.Position + off)
        end
    end)
end
function StopBlink() SafeDisconnect("Blink") end



-- ==================== HVH DEFENSE ====================
local lastHurtHP = 100
local lastHurtEvade = 0
local lastNearEvade = 0
local lastMicro = 0
local defenseSide = 1

function defenseEnemyNear(maxDist)
    local my = getHRP()
    if not my then return nil, nil end
    local best, bestD, bestRoot = nil, maxDist, nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if config.TeamCheck and IsSameTeam(plr) then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then continue end
        local d = (my.Position - root.Position).Magnitude
        if d < bestD then bestD, best, bestRoot = d, plr, root end
    end
    return best, bestRoot
end

function pushAwayFrom(root, dist)
    local my = getHRP()
    if not my or not root then return end
    local dir = (my.Position - root.Position)
    if dir.Magnitude < 0.1 then
        dir = Vector3.new(math.random() - 0.5, 0, math.random() - 0.5)
    end
    dir = Vector3.new(dir.X, 0, dir.Z).Unit
    defenseSide = -defenseSide
    local side = Vector3.new(-dir.Z, 0, dir.X) * defenseSide
    local goal = my.Position + dir * dist + side * (dist * 0.35)
    local minY = workspace.FallenPartsDestroyHeight + 10
    if goal.Y < minY then goal = Vector3.new(goal.X, my.Position.Y, goal.Z) end
    my.CFrame = CFrame.new(goal)
    my.AssemblyLinearVelocity = (dir + side) * 40
end

function anyDefenseOn()
    return config.HurtEvade or config.NearEnemyEvade or config.AntiMeleeEnabled
        or config.AdaptiveDesync or config.VelocityBreak or config.RandomMicroMove
        or config.LowHPPanic or config.AntiUEClose or config.AntiUEPeek or config.DesyncSpam
end

function StartDefense()
    SafeDisconnect("Defense")
    local hum = getHum()
    if hum then lastHurtHP = hum.Health end
    local defFrame = 0
    Connections.Defense = RunService.Heartbeat:Connect(function()
        defFrame += 1
        if defFrame % 2 ~= 0 then return end -- OPT
        if not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive() or config.VoidSpamEnabled then return end
        local my = getHRP()
        local hum = getHum()
        if not my or not hum then return end

        -- Velocity break (anti fling / knock fuerte de ragers)
        if config.VelocityBreak or config.AntiFling then
            local maxV = config.VelocityBreakMax or 140
            if my.AssemblyLinearVelocity.Magnitude > maxV then
                my.AssemblyLinearVelocity = Vector3.zero
                my.AssemblyAngularVelocity = Vector3.zero
            end
        end

        -- Hurt evade: al bajar HP, esquiva lateral
        if config.HurtEvade then
            if hum.Health < lastHurtHP - 1 then
                if tick() - lastHurtEvade >= (config.HurtEvadeCooldown or 0.35) then
                    lastHurtEvade = tick()
                    local _, root = defenseEnemyNear(80)
                    local dist = config.HurtEvadeDist or 18
                    if hum.Health <= (config.LowHPThreshold or 30) and config.LowHPPanic then
                        dist = config.LowHPBoostDist or 25
                    end
                    if root then
                        pushAwayFrom(root, dist)
                    else
                        defenseSide = -defenseSide
                        my.CFrame = my.CFrame + Vector3.new(defenseSide * dist, 2, 0)
                    end
                end
            end
            lastHurtHP = hum.Health
        end

        -- Cerca de melee / rager body
        if config.AntiMeleeEnabled or config.NearEnemyEvade then
            local range = config.AntiMeleeEnabled and (config.AntiMeleeRange or 7) or (config.NearEnemyDist or 8)
            local plr, root = defenseEnemyNear(range)
            if root and tick() - lastNearEvade > 0.2 then
                lastNearEvade = tick()
                local push = config.AntiMeleeEnabled and (config.AntiMeleePush or 16) or (config.NearEnemyPush or 14)
                pushAwayFrom(root, push)
            end
        end

        -- Adaptive desync: SOLO si toggle ON (antes se movia solo)
        if config.AdaptiveDesync == true and not config.Enabled and not config.RagebotEnabled then
            local _, root = defenseEnemyNear(config.AdaptiveDesyncRange or 40)
            if root and tick() - (lastMicro or 0) > 0.2 then
                lastMicro = tick()
                local p = math.min(config.AdaptiveDesyncPower or 6, 8)
                my.CFrame = my.CFrame * CFrame.new(
                    (math.random() - 0.5) * p * 0.04,
                    0,
                    (math.random() - 0.5) * p * 0.04
                )
            end
        end

        -- Anti UE close: si un rager se pega cerca, empuja LEJOS
        if config.AntiUEClose then
            local closest, croot = defenseEnemyNear(config.AntiUECloseDist or 35)
            if closest and croot then
                local d = (my.Position - croot.Position).Magnitude
                if d < (config.AntiUECloseDist or 35) then
                    pushAwayFrom(croot, config.AntiUEClosePush or 80)
                end
            end
        end

        -- Anti UE peek: side hop cuando hay enemigo en rango medio
        if config.AntiUEPeek then
            local _, root = defenseEnemyNear(config.AntiUEPeekDist or 40)
            if root and tick() - (lastHurtEvade or 0) > 0.4 then
                lastHurtEvade = tick()
                local dir = (my.Position - root.Position)
                if dir.Magnitude > 0.1 then
                    dir = Vector3.new(dir.X, 0, dir.Z).Unit
                    local side = Vector3.new(-dir.Z, 0, dir.X) * (math.random() > 0.5 and 1 or -1)
                    my.CFrame = CFrame.new(my.Position + side * 25 + dir * 10)
                    my.AssemblyLinearVelocity = side * 50
                end
            end
        end

        -- Desync spam anti-hit (micro jitter continuo)
        if config.DesyncSpam then
            local p = math.min(config.DesyncSpamPower or 8, 15)
            my.CFrame = my.CFrame * CFrame.new(
                (math.random() - 0.5) * p * 0.08,
                (math.random() - 0.5) * 0.3,
                (math.random() - 0.5) * p * 0.08
            )
        end

        -- Random micro move (solo toggle)
        if config.RandomMicroMove == true and tick() - lastMicro > 0.25 then
            lastMicro = tick()
            local p = config.RandomMicroPower or 3
            my.CFrame = my.CFrame + Vector3.new((math.random() - 0.5) * p, 0, (math.random() - 0.5) * p)
        end

        -- ===== ANTI-RAGER TACTICS =====
        local orbitOn = config.OrbitEvade or config.RagerCombo
        local heightOn = config.HeightJitter or config.RagerCombo
        local headOn = config.AntiHeadTP or config.RagerCombo
        local strafeOn = config.StrafePattern or config.RagerCombo
        local peekOn = config.FakePeek

        -- Orbit: gira alrededor del enemigo cercano (rompe TP a la cabeza)
        if orbitOn then
            local range = config.OrbitEvadeRange or 45
            local plr, root = defenseEnemyNear(range)
            if root then
                local radius = config.OrbitEvadeRadius or 12
                local spd = config.OrbitEvadeSpeed or 8
                local ang = tick() * spd
                local cx, cz = root.Position.X, root.Position.Z
                local y = root.Position.Y + 1.5
                local gx = cx + math.cos(ang) * radius
                local gz = cz + math.sin(ang) * radius
                local goal = Vector3.new(gx, y, gz)
                local cur = my.Position
                local step = (goal - cur)
                if step.Magnitude > 0.5 then
                    -- no saltar de golpe: interpolar
                    local maxStep = 4.5
                    if step.Magnitude > maxStep then step = step.Unit * maxStep end
                    my.CFrame = CFrame.new(cur + step)
                    my.AssemblyLinearVelocity = Vector3.new(step.X * 8, my.AssemblyLinearVelocity.Y, step.Z * 8)
                end
            end
        end

        -- Height jitter: sube/baja para que el head-aim falle
        if heightOn then
            local amt = config.HeightJitterAmount or 6
            local spd = config.HeightJitterSpeed or 12
            local oy = math.sin(tick() * spd) * amt
            local p = my.Position
            my.CFrame = CFrame.new(p.X, p.Y + oy * 0.08, p.Z) -- micro por frame
        end

        -- Anti head TP: si alguien está casi encima, empuja lejos
        if headOn then
            local dist = config.AntiHeadTPDist or 12
            local push = config.AntiHeadTPPush or 35
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr == LocalPlayer then continue end
                if config.TeamCheck and IsSameTeam and IsSameTeam(plr) then continue end
                local rh = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
                if not rh then continue end
                local delta = rh.Position - my.Position
                local horiz = Vector3.new(delta.X, 0, delta.Z).Magnitude
                if horiz < dist and delta.Y > 2 and delta.Y < 25 then
                    -- rager encima → lateral + atrás
                    local away = Vector3.new(-delta.X, 0, -delta.Z)
                    if away.Magnitude < 0.1 then away = my.CFrame.RightVector end
                    away = away.Unit
                    my.CFrame = my.CFrame + away * math.min(push * 0.15, 8) + Vector3.new(0, -1, 0)
                    my.AssemblyLinearVelocity = away * push
                    break
                end
            end
        end

        -- Strafe pattern A-D
        if strafeOn then
            local rate = config.StrafePatternRate or 0.18
            if not _strafeSide then _strafeSide = 1 end
            if not _lastStrafeT then _lastStrafeT = 0 end
            if tick() - _lastStrafeT >= rate then
                _lastStrafeT = tick()
                _strafeSide = -_strafeSide
                local d = config.StrafePatternDist or 10
                my.CFrame = my.CFrame + my.CFrame.RightVector * (_strafeSide * d * 0.35)
                local v = my.AssemblyLinearVelocity
                my.AssemblyLinearVelocity = Vector3.new(my.CFrame.RightVector.X * _strafeSide * 40, v.Y, my.CFrame.RightVector.Z * _strafeSide * 40)
            end
        end

        -- Fake peek: sale al lado y vuelve
        if peekOn then
            local rate = config.FakePeekRate or 0.55
            if not _lastPeekT then _lastPeekT = 0 end
            if not _peekPhase then _peekPhase = 0 end
            if tick() - _lastPeekT >= rate then
                _lastPeekT = tick()
                local d = config.FakePeekDist or 18
                if _peekPhase == 0 then
                    _peekOrigin = my.Position
                    my.CFrame = my.CFrame + my.CFrame.RightVector * d
                    _peekPhase = 1
                else
                    if _peekOrigin then
                        my.CFrame = CFrame.new(_peekOrigin.X, my.Position.Y, _peekOrigin.Z)
                    end
                    _peekPhase = 0
                end
            end
        end
    end)
end

function StopDefense()
    SafeDisconnect("Defense")
end

-- Defense NO auto-start (solo si usuario activa opciones)

-- ==================== HIT / KILL SOUNDS (Grief.cc assets + detection) ====================
local SoundService = game:GetService("SoundService")
local SFX = {
    -- rbxassetid from Grief.cc soundsassets (robados)
    hitSounds = {
        ["Rust HS"]           = 5043539486,
        ["Neverlose"]         = 97643101798871,
        ["Minecraft Bow"]     = 3442683707,
        ["Minecraft Hit"]     = 8766809464,
        ["CSGO"]              = 5764885315,
        ["Bubble"]            = 6534947588,
        ["Lazer"]             = 130791043,
        ["Pick"]              = 1347140027,
        ["Pop"]               = 198598793,
        ["Rust"]              = 1255040462,
        ["Sans"]              = 3188795283,
        ["Fart"]              = 130833677,
        ["Big"]               = 5332005053,
        ["Vine"]              = 5332680810,
        ["UwU"]               = 8679659744,
        ["Bruh"]              = 4578740568,
        ["Skeet"]             = 5633695679,
        ["Fatality"]          = 6534947869,
        ["Bonk"]              = 5766898159,
        ["Minecraft"]         = 5869422451,
        ["Gamesense"]         = 4817809188,
        ["RIFK7"]             = 9102080552,
        ["Bamboo"]            = 3769434519,
        ["Crowbar"]           = 546410481,
        ["Weeb"]              = 6442965016,
        ["Beep"]              = 8177256015,
        ["Bambi"]             = 8437203821,
        ["Stone"]             = 3581383408,
        ["Old Fatality"]      = 6607142036,
        ["Click"]             = 8053704437,
        ["Ding"]              = 7149516994,
        ["Snow"]              = 6455527632,
        ["Laser"]             = 7837461331,
        ["Mario"]             = 2815207981,
        ["Steve"]             = 4965083997,
        ["Call of Duty"]      = 5952120301,
        ["Bat"]               = 3333907347,
        ["TF2 Critical"]      = 296102734,
        ["Saber"]             = 8415678813,
        ["Baimware"]          = 3124331820,
        ["Osu"]               = 7149255551,
        ["TF2"]               = 2868331684,
        ["Slime"]             = 6916371803,
        ["Among Us"]          = 5700183626,
        ["One"]               = 7380502345,
        ["Soft Bell"]         = 9114487369,
        ["Minecraft Bow Hit"] = 1053296915,
        -- legacy aliases
        ["Never Lose"]        = 5043539486,
        ["TF2 Crit"]          = 296102734,
        ["Vine Boom"]         = 5332680810,
        ["MLG Airhorn"]       = 678089961,
        ["Boom Headshot"]     = 7361085557,
        ["Quake Hit"]         = 1455817260,
    },
    killSounds = {
        ["OOF"]           = 15666462,
        ["New Death"]     = 9118823103,
        ["Wake Up Bozo"]  = 9042248317,
        ["Emotional Dmg"] = 8388105535,
        ["You Are Bad"]   = 7163786825,
        ["Alone"]         = 7734793940,
        ["Fatality"]      = 6534947869,
        ["Vine"]          = 5332680810,
        ["Among Us"]      = 5700183626,
        ["TF2 Critical"]  = 296102734,
        ["Neverlose"]     = 97643101798871,
        ["Rust HS"]       = 5043539486,
    },
    hitNames = {
        "Rust HS","Neverlose","Gamesense","Skeet","Fatality","Bonk","Osu","CSGO",
        "TF2 Critical","TF2","Minecraft","Minecraft Hit","Bubble","Bruh","Vine",
        "Among Us","Click","Ding","Beep","Laser","Lazer","UwU","Weeb","Bamboo",
        "Crowbar","Bat","Saber","Stone","Snow","Steve","Mario","Call of Duty",
        "Baimware","RIFK7","Old Fatality","Big","Fart","Sans","Pick","Pop","Rust",
        "One","Soft Bell","Minecraft Bow","Minecraft Bow Hit","Bambi","Slime",
    },
    killNames = {
        "OOF","New Death","Wake Up Bozo","Emotional Dmg","You Are Bad","Alone",
        "Fatality","Vine","Among Us","TF2 Critical","Neverlose","Rust HS",
    },
    lastHit = 0, lastKill = 0, hp = {},
    auroraHooked = false,
    pitch = 1,
}

-- ==================== SFX PLAY (PlayLocalSound = sí se oye) ====================
-- IDs que casi siempre cargan en cliente Roblox
SFX.FALLBACK_HIT = 12222216
SFX.FALLBACK_KILL = 15666462
-- remap nombres populares a IDs que sí suenan
pcall(function()
    SFX.hitSounds = SFX.hitSounds or {}
    SFX.hitSounds["Rust HS"] = 12222216
    SFX.hitSounds["Neverlose"] = 12222216
    SFX.hitSounds["Never Lose"] = 12222216
    SFX.hitSounds["TF2 Critical"] = 296102734
    SFX.hitSounds["TF2 Crit"] = 296102734
    SFX.hitSounds["Click"] = 12222216
    SFX.hitSounds["CSGO"] = 5764885315
    SFX.hitSounds["Skeet"] = 5633695679
    SFX.hitSounds["Laser"] = 7837461331
    SFX.hitSounds["Lazer"] = 130791043
    SFX.killSounds = SFX.killSounds or {}
    SFX.killSounds["OOF"] = 15666462
    SFX.killSounds["Fatality"] = 6534947869
end)

function SFX.play(id, vol, pitch)
    local num = tonumber(tostring(id or ""):match("%d+")) or SFX.FALLBACK_HIT
    local volN = math.clamp(tonumber(vol) or tonumber(config and config.HitSoundVolume) or 7, 1, 10)
    local pid = math.clamp(tonumber(pitch) or tonumber(config and config.HitSoundPitch) or 1, 0.5, 3)

    local function one(soundId, volume)
        local s = Instance.new("Sound")
        s.Name = "ShakoHS"
        s.SoundId = "rbxassetid://" .. tostring(soundId)
        s.Volume = volume
        s.PlaybackSpeed = pid
        s.Looped = false
        s.PlayOnRemove = false
        -- parent al SoundService
        s.Parent = SoundService
        -- método oficial cliente
        pcall(function() SoundService:PlayLocalSound(s) end)
        pcall(function() s:Play() end)
        -- backup en PlayerGui (algunos juegos mutean SS)
        pcall(function()
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                local s2 = s:Clone()
                s2.Parent = pg
                pcall(function() SoundService:PlayLocalSound(s2) end)
                pcall(function() s2:Play() end)
                task.delay(4, function() pcall(function() s2:Destroy() end) end)
            end
        end)
        -- backup HRP
        pcall(function()
            local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                local s3 = s:Clone()
                s3.Parent = hrp
                pcall(function() s3:Play() end)
                task.delay(4, function() pcall(function() s3:Destroy() end) end)
            end
        end)
        task.delay(5, function() pcall(function() s:Destroy() end) end)
        return s
    end

    one(num, volN)
    -- si el id no es el fallback, también no duplicar; el fallback se usa solo si falla detection
end

function SFX.hit()
    if not config or not config.HitSoundEnabled then return end
    local now = tick()
    if SFX._lastHit and (now - SFX._lastHit) < (tonumber(config.HitSoundCooldown) or 0.05) then return end
    SFX._lastHit = now
    local name = config.SelectedHitSound or "Neverlose"
    if config.HitSoundMode == "Random" and SFX.hitNames and #SFX.hitNames > 0 then
        name = SFX.hitNames[math.random(1, #SFX.hitNames)]
    end
    local id = (SFX.hitSounds and SFX.hitSounds[name]) or SFX.FALLBACK_HIT or 5043539486
    SFX.play(id, config.HitSoundVolume, config.HitSoundPitch)
end

function SFX.kill()
    -- kill sounds permanently disabled (solo hitsounds)
    return
end

-- AURORA ClientViewModel hit sound hook (Rivals nativo)
task.spawn(function()
    task.wait(2)
    pcall(function()
        local path = LocalPlayer.PlayerScripts:FindFirstChild("Modules")
        path = path and path:FindFirstChild("ClientReplicatedClasses")
        path = path and path:FindFirstChild("ClientFighter")
        path = path and path:FindFirstChild("ClientItem")
        local vm_module = path and path:FindFirstChild("ClientViewModel")
        if not vm_module then return end
        local ClientViewModel = require(vm_module)
        if not ClientViewModel or not ClientViewModel.PlayHitmarkerSound then return end
        if SFX.auroraHooked then return end
        SFX.auroraHooked = true
        local orig = ClientViewModel.PlayHitmarkerSound
        ClientViewModel.PlayHitmarkerSound = function(self, is_crit, distance)
            local ctx = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
            -- SOLO hits del LocalPlayer (no sonidos de otros)
            if ctx ~= LocalPlayer then
                return orig(self, is_crit, distance)
            end
            -- marca hit local para damage numbers
            getgenv()._ShakoLocalHitAt = tick()
            getgenv()._ShakoLocalHitCrit = is_crit and true or false

            if config.EliHitSound then
                pcall(function()
                    local Eli = getgenv()._ShakoEli
                    if Eli and Eli.playHit then Eli.playHit() end
                end)
                if config.EliHitRemoveDefault ~= false then
                    return -- solo nuestro sonido
                end
            end

            if config.HitSoundEnabled then
                local name = config.SelectedHitSound or "Neverlose"
                if config.HitSoundMode == "Random" and SFX.hitNames and #SFX.hitNames > 0 then
                    name = SFX.hitNames[math.random(1, #SFX.hitNames)]
                end
                local id = SFX.hitSounds and SFX.hitSounds[name]
                if id then
                    pcall(function()
                        local vol = (config.HitSoundVolume or 2)
                        local pitch = (config.HitSoundPitch or 1)
                        if self._CreateHitmarkerSound then
                            local dist = tonumber(distance) or 1
                            if is_crit then
                                self:_CreateHitmarkerSound("rbxassetid://"..id, (3/math.max(dist,0.1)), pitch, vm_module, true, 1)
                                self:_CreateHitmarkerSound("rbxassetid://"..id, (2/math.max(dist,0.1)), pitch, vm_module, true, 1)
                            else
                                self:_CreateHitmarkerSound("rbxassetid://"..id, (1.5/math.max(dist,0.1)), pitch, vm_module, true, 1)
                            end
                        else
                            SFX.play(id, vol, pitch)
                        end
                    end)
                    return
                end
            end
            return orig(self, is_crit, distance)
        end
        print("[shako] AURORA hitmarker hooked")
    end)
end)

-- Detección de hit: HealthChanged (fiable) + poll de respaldo

-- HARD OFF kill/hit/eli sounds (user request)
pcall(function()
    config.KillSoundEnabled = false
    config.HitSoundEnabled = false
    config.EliHitSound = false
end)

local function sfxOnDamage(plr, newHp, oldHp)
    if not plr or plr == LocalPlayer then return end
    if not (config.HitSoundEnabled or config.KillSoundEnabled or config.EliHitSound) then return end
    oldHp = tonumber(oldHp) or SFX.hp[plr]
    newHp = tonumber(newHp)
    if newHp == nil then return end
    if oldHp == nil then
        SFX.hp[plr] = newHp
        return
    end
    local drop = oldHp - newHp
    -- SOLO si TÚ pegaste hace poco (PlayHitmarkerSound local)
    local hitAt = tonumber(getgenv()._ShakoLocalHitAt) or 0
    local myHit = (tick() - hitAt) < 0.5
    if not myHit then
        SFX.hp[plr] = newHp
        return
    end
    if oldHp > 0 and newHp <= 0 then
        if config.KillSoundEnabled then SFX.kill() end
        SFX.hp[plr] = newHp
        return
    end
    if drop >= 2 then
        -- hitsound: preferir Eli (ya sonó en PlayHitmarker); no doblar
        if config.EliHitSound then
            -- ya lo reprodujo el hook de hitmarker local
        elseif config.HitSoundEnabled then
            SFX.hit()
        end
    end
    SFX.hp[plr] = newHp
end

local function sfxHookHumanoid(plr, hum)
    if not hum or SFX._humHooked and SFX._humHooked[hum] then return end
    SFX._humHooked = SFX._humHooked or setmetatable({}, { __mode = "k" })
    SFX._humHooked[hum] = true
    SFX.hp[plr] = hum.Health
    hum.HealthChanged:Connect(function(hp)
        sfxOnDamage(plr, hp, SFX.hp[plr])
    end)
end

local function sfxHookPlayer(plr)
    if plr == LocalPlayer then return end
    plr.CharacterAdded:Connect(function(char)
        task.defer(function()
            local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 3)
            if hum then sfxHookHumanoid(plr, hum) end
        end)
    end)
    if plr.Character then
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        if hum then sfxHookHumanoid(plr, hum) end
    end
end

for _, plr in ipairs(Players:GetPlayers()) do sfxHookPlayer(plr) end
Players.PlayerAdded:Connect(sfxHookPlayer)
Players.PlayerRemoving:Connect(function(p) SFX.hp[p] = nil end)

-- poll de respaldo (por si HealthChanged no dispara en algún caso)
task.spawn(function()
    while true do
        task.wait(0.12)
        if not (config.HitSoundEnabled or config.KillSoundEnabled) then continue end
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if not hum then continue end
            local prev = SFX.hp[plr]
            local hp = hum.Health
            if prev ~= nil and hp ~= prev then
                sfxOnDamage(plr, hp, prev)
            else
                SFX.hp[plr] = hp
            end
        end
    end
end)


-- GUI watchers DESACTIVADOS: al cambiar arma Rivals crea UI con números
-- y disparaba hit sound sin parar. Solo usamos:
-- 1) AURORA PlayHitmarkerSound (hit real del juego)
-- 2) HealthChanged en enemigos (bajó vida de verdad)

-- re-track HP on CharacterAdded (respawn)
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then SFX.hp[plr] = hum.Health end
    end)
end)
for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then SFX.hp[plr] = hum.Health end
        end)
    end
end


-- ==================== SPOOFER (nombres + perfil UI) ====================
local Spoof = {
    map = {},
    randomPool = {
        "Guest","Player","User","Unknown","Hidden","Shadow","Ghost","Anon",
        "xXProXx","Noob","Bot","NPC","???","-----","null","error",
    },
    tagged = {}, -- TextLabels ya tocados [obj] = true
}

-- ==================== DEVICE SPOOFER (SetControls remote) ====================
local DeviceSpoof = {
    hooked = false,
}

-- Rivals: Remotes.Replication.Fighter.SetControls
local DEVICE_MAP = {
    PC = "MouseKeyboard",
    Computer = "MouseKeyboard",
    Mobile = "Touch",
    Console = "Gamepad",
    Controller = "Gamepad",
    VR = "VR",
}

function DeviceSpoof.getRemote()
    local ok, remote = pcall(function()
        return game:GetService("ReplicatedStorage")
            :WaitForChild("Remotes", 5)
            :WaitForChild("Replication", 5)
            :WaitForChild("Fighter", 5)
            :WaitForChild("SetControls", 5)
    end)
    if ok then
        return remote
    end
    return nil
end

function DeviceSpoof.getControlName()
    local t = config.DeviceSpoofType or "Mobile"
    return DEVICE_MAP[t] or "Touch"
end

function DeviceSpoof.apply()
    if not config.DeviceSpoofEnabled then
        return false
    end
    local control = DeviceSpoof.getControlName()
    local remote = DeviceSpoof.getRemote()
    if not remote then
        Notify("Device", "SetControls no encontrado")
        return false
    end
    local ok, err = pcall(function()
        remote:FireServer(control)
    end)
    if not ok then
        Notify("Device", "Error: " .. tostring(err))
        return false
    end
    return true
end

function DeviceSpoof.hook()
    return DeviceSpoof.apply()
end

function DeviceSpoof.enable()
    config.DeviceSpoofEnabled = true
    local ok = DeviceSpoof.apply()
    local label = tostring(config.DeviceSpoofType or "Mobile")
    if ok then
        Notify("Device", label .. " → " .. DeviceSpoof.getControlName())
    end
end

function DeviceSpoof.disable()
    config.DeviceSpoofEnabled = false
    -- volver a PC/MouseKeyboard al desactivar
    pcall(function()
        local remote = DeviceSpoof.getRemote()
        if remote then
            remote:FireServer("MouseKeyboard")
        end
    end)
    Notify("Device", "OFF")
end

-- Spoof refresh helpers
function Spoof.getMyName()
    if config.SpoofMyName and config.SpoofMyNameValue and config.SpoofMyNameValue ~= "" then
        return tostring(config.SpoofMyNameValue)
    end
    return LocalPlayer.Name
end
function Spoof.getMyDisplay()
    if config.SpoofMyDisplayName and config.SpoofMyDisplayValue and config.SpoofMyDisplayValue ~= "" then
        return tostring(config.SpoofMyDisplayValue)
    end
    if config.SpoofMyName and config.SpoofMyNameValue and config.SpoofMyNameValue ~= "" then
        return tostring(config.SpoofMyNameValue)
    end
    return LocalPlayer.DisplayName
end
function Spoof.getMyUser()
    if config.SpoofMyUserValue and config.SpoofMyUserValue ~= "" then
        return tostring(config.SpoofMyUserValue):gsub("^@", "")
    end
    return Spoof.getMyName()
end

function Spoof.patchEscMenu()
    if not config.SpoofEnabled then return end
    local fakeDisp = Spoof.getMyDisplay()
    local fakeUser = Spoof.getMyUser()
    local realName = LocalPlayer.Name
    local realDisp = LocalPlayer.DisplayName or realName
    if fakeDisp == "" then return end

    local function replaceText(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
            return
        end
        local t = obj.Text or ""
        if t == "" then return end
        local tl = string.lower(t)
        local rn = string.lower(realName)
        local rd = string.lower(realDisp)
        local fd = string.lower(fakeDisp)
        local fu = string.lower(tostring(fakeUser):gsub("^@", ""))

        if tl == fd or tl == "@" .. fd or tl == fu or tl == "@" .. fu then
            return
        end
        if t == realName or tl == rn then
            if t:sub(1, 1) == "@" or (obj.Name and string.lower(obj.Name):find("user", 1, true)) then
                obj.Text = "@" .. tostring(fakeUser):gsub("^@", "")
            else
                obj.Text = fakeDisp
            end
            return
        end
        if t == realDisp or tl == rd then
            obj.Text = fakeDisp
            return
        end
        if t == "@" .. realName or tl == "@" .. rn then
            obj.Text = "@" .. tostring(fakeUser):gsub("^@", "")
            return
        end
        -- texto compuesto "Display @user"
        if tl:find(rn, 1, true) or tl:find(rd, 1, true) then
            local nt = t
            if realDisp ~= "" then
                nt = nt:gsub(realDisp, fakeDisp)
            end
            nt = nt:gsub(realName, fakeDisp)
            nt = nt:gsub("@" .. realName, "@" .. tostring(fakeUser):gsub("^@", ""))
            if nt ~= t then
                obj.Text = nt
            end
        end
    end

    pcall(function()
        local CoreGui = game:GetService("CoreGui")
        for _, child in ipairs(CoreGui:GetChildren()) do
            local n = string.lower(child.Name or "")
            if n:find("player", 1, true) or n:find("list", 1, true) or n:find("menu", 1, true)
                or n:find("robloxgui", 1, true) or n:find("topbar", 1, true)
                or n:find("app", 1, true) or n:find("insp", 1, true) then
                for _, obj in ipairs(child:GetDescendants()) do
                    replaceText(obj)
                end
            end
        end
    end)

    pcall(function()
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg then
            for _, obj in ipairs(pg:GetDescendants()) do
                replaceText(obj)
            end
        end
    end)
end

function Spoof.refreshLocal()
    if not config.SpoofEnabled then return end
    local fake = Spoof.getMyDisplay()
    local fakeUser = Spoof.getMyUser()

    -- DisplayName local (ESC / lista usa esto mucho)
    pcall(function()
        if config.SpoofMyDisplayName or config.SpoofMyName then
            if fake and fake ~= "" then
                LocalPlayer.DisplayName = fake
            end
        end
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and fake and fake ~= "" then
            hum.DisplayName = fake
        end
    end)

    local char = LocalPlayer.Character
    if char then
        Spoof.applyNametags(char, fake)
    end

    if config.SpoofProfileUI then
        pcall(function()
            Spoof.patchEscMenu()
            if type(Spoof.patchMyProfileUI) == "function" then
                Spoof.patchMyProfileUI()
            end
        end)
    end
end

function Spoof.refreshAll()
    Spoof.refreshLocal()
end

-- Cuando abren ESC (player list), re-aplicar nombre falso
if not Spoof._escHooked then
    Spoof._escHooked = true
    pcall(function()
        local UIS = game:GetService("UserInputService")
        UIS.InputBegan:Connect(function(input, gp)
            if not config.SpoofEnabled then return end
            if input.KeyCode == Enum.KeyCode.Escape then
                task.delay(0.15, function()
                    if config.SpoofEnabled then
                        Spoof.patchEscMenu()
                    end
                end)
                task.delay(0.4, function()
                    if config.SpoofEnabled then
                        Spoof.patchEscMenu()
                    end
                end)
            end
        end)
    end)
    pcall(function()
        local GuiService = game:GetService("GuiService")
        if GuiService.MenuOpened then
            GuiService.MenuOpened:Connect(function()
                if not config.SpoofEnabled then return end
                task.delay(0.1, function()
                    Spoof.patchEscMenu()
                end)
                task.delay(0.35, function()
                    Spoof.patchEscMenu()
                end)
            end)
        end
    end)
end

-- Stats text spoof (solo labels locales del LocalPlayer UI)
function StartAllSpoofs()
    if config.DeviceSpoofEnabled then
        pcall(function() DeviceSpoof.enable() end)
    end
    if config.SpoofEnabled then
        pcall(Spoof.refreshLocal)
    end
end

function StopAllSpoofs()
    if config.DeviceSpoofEnabled == false then
        pcall(function() DeviceSpoof.disable() end)
    end
end

function Spoof.getName(plr)
    if not config.SpoofEnabled or not plr then
        return plr and (plr.DisplayName ~= "" and plr.DisplayName or plr.Name) or "?"
    end
    if plr == LocalPlayer and config.SpoofMyName and config.SpoofMyNameValue ~= "" then
        return tostring(config.SpoofMyNameValue)
    end
    if Spoof.map[plr] and Spoof.map[plr] ~= "" then
        return Spoof.map[plr]
    end
    if config.SpoofTargetName ~= "" and config.SpoofTargetFake ~= "" then
        local real = string.lower(plr.Name)
        local disp = string.lower(plr.DisplayName or "")
        local want = string.lower(config.SpoofTargetName)
        if real:find(want, 1, true) or disp:find(want, 1, true) then
            return tostring(config.SpoofTargetFake)
        end
    end
    if plr ~= LocalPlayer and config.SpoofOthers then
        if config.SpoofRandomOthers then
            if not Spoof.map[plr] then
                Spoof.map[plr] = Spoof.randomPool[math.random(1, #Spoof.randomPool)] .. math.random(10, 99)
            end
            return Spoof.map[plr]
        end
        if config.SpoofOthersValue ~= "" then
            return tostring(config.SpoofOthersValue)
        end
    end
    return plr.DisplayName ~= "" and plr.DisplayName or plr.Name
end
function Spoof.getMyUser()
    local u = config.SpoofMyUserValue
    if u and u ~= "" then return tostring(u) end
    return tostring(config.SpoofMyNameValue or "shako.win")
end
function Spoof.setPlayer(plr, fake)
    if not plr then return end
    if fake and fake ~= "" then Spoof.map[plr] = tostring(fake) else Spoof.map[plr] = nil end
end
function Spoof.clearAll()
    table.clear(Spoof.map)
end
function Spoof.applyNametags(char, fakeName)
    if not char or not fakeName then return end
    -- SOLO labels de nombre. NUNCA racha / stats / billboards genéricos
    -- (antes pisaba TODO y salía "Shako.win Shako.win" + racha con el name)
    local allowName = {
        DisplayName = true, PlayerName = true, NameLabel = true,
        Username = true, Handle = true, HeaderText = true,
    }
    pcall(function()
        for _, v in ipairs(char:GetDescendants()) do
            if not (v:IsA("TextLabel") or v:IsA("TextButton")) then continue end
            local on = v.Name or ""
            local pn = v.Parent and v.Parent.Name or ""
            local lowerN = string.lower(on .. " " .. pn)
            -- bloquear racha / stats
            if lowerN:find("streak", 1, true) or lowerN:find("racha", 1, true)
                or lowerN:find("win", 1, true) or lowerN:find("kill", 1, true)
                or lowerN:find("level", 1, true) or lowerN:find("elo", 1, true)
                or lowerN:find("score", 1, true) or lowerN:find("stat", 1, true)
                or on == "Value" or on == "Amount" or on == "Count" then
                continue
            end
            if not allowName[on] and pn ~= "NameContainer" and pn ~= "Title" and pn ~= "Subtitle" then
                continue
            end
            local t = v.Text or ""
            if t == "" or t:match("^%s*[%d%.,%%]+%s*$") then continue end
            -- no tocar si ya es el fake (evita doble escritura)
            if string.lower(t) == string.lower(fakeName) then continue end
            if string.lower(t) == "@" .. string.lower(fakeName) then continue end
            -- Username/Handle → @user si hay spoof de user, si no dejar
            if on == "Username" or on == "Handle" or pn == "Subtitle" then
                local fu = Spoof.getMyUser and Spoof.getMyUser() or fakeName
                if t:sub(1,1) == "@" or on == "Handle" then
                    v.Text = "@" .. tostring(fu):gsub("^@", "")
                end
                continue
            end
            v.Text = fakeName
        end
    end)
end
-- reescribe texto en GUIs: perfil, leaderboard, lista jugadores, top bar
function Spoof.patchTextObject(obj, realName, realDisplay, fakeDisplay, fakeUser)
    if not obj then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    local t = obj.Text
    if not t or t == "" then return end
    -- solo numeros / score puro → no tocar
    if t:match("^%s*[%d%.,%%]+%s*$") then return end
    local lower = string.lower(t)
    local skip = false
    for _, w in ipairs({"win rate", "wins", "level", "platinum", "played", "armas", "fusil", "revolver", "granada"}) do
        if lower:find(w, 1, true) then skip = true break end
    end
    if skip then return end

    local rn = realName and string.lower(realName) or ""
    local rd = realDisplay and string.lower(realDisplay) or ""
    local fd = fakeDisplay or ""
    local fu = fakeUser or fd
    if fd == "" then return end
    -- si ya es el nombre falso, dejar
    if lower == string.lower(fd) or lower == string.lower(fu) or lower == "@" .. string.lower(fu) then
        return
    end

    local function esc(s)
        return (s:gsub("(%W)", "%%%1"))
    end

    -- match exacto DisplayName
    if rd ~= "" and lower == rd then
        obj.Text = fd
        return true
    end
    -- bloquear labels de racha/stats por nombre
    local on = obj.Name or ""
    local pn = obj.Parent and obj.Parent.Name or ""
    local meta = string.lower(on .. " " .. pn)
    if meta:find("streak", 1, true) or meta:find("racha", 1, true)
        or on == "Value" or on == "Wins" or on == "Kills" or on == "Level" or on == "Streak" then
        return false
    end
    -- match exacto Username → @fakeUser (NO el display name)
    if rn ~= "" and lower == rn then
        obj.Text = "@" .. tostring(fu):gsub("^@", "")
        return true
    end
    -- @username
    if rn ~= "" and lower == "@" .. rn then
        obj.Text = "@" .. tostring(fu):gsub("^@", "")
        return true
    end
    -- DisplayName @user juntos (evitar duplicar si ya tiene fake)
    if rd ~= "" and rn ~= "" and lower:find(rd, 1, true) and lower:find(rn, 1, true) then
        if lower:find(string.lower(fd), 1, true) then return false end
        obj.Text = fd .. "\n@" .. tostring(fu):gsub("^@", "")
        return true
    end
    -- contiene display name (leaderboard / lista) — una sola vez
    if rd ~= "" and #rd >= 2 and lower:find(rd, 1, true) and not lower:find(string.lower(fd), 1, true) then
        local ok, newT = pcall(function()
            return t:gsub(esc(realDisplay), fd, 1)
        end)
        if ok and newT and newT ~= t then
            obj.Text = newT
            return true
        end
    end
    -- contiene username → reemplazar por @user, no por display
    if rn ~= "" and #rn >= 3 and lower:find(rn, 1, true) and not lower:find(string.lower(fu), 1, true) then
        local ok, newT = pcall(function()
            if t:find("@" .. realName, 1, true) then
                return t:gsub(esc("@" .. realName), "@" .. tostring(fu):gsub("^@", ""), 1)
            end
            return t:gsub(esc(realName), tostring(fu):gsub("^@", ""), 1)
        end)
        if ok and newT and newT ~= t then
            obj.Text = newT
            return true
        end
    end
    return false
end
function Spoof.patchGuiTree(root, realName, realDisplay, fakeDisplay, fakeUser)
    if not root then return end
    pcall(function()
        for _, v in ipairs(root:GetDescendants()) do
            Spoof.patchTextObject(v, realName, realDisplay, fakeDisplay, fakeUser)
        end
    end)
end
function Spoof.patchMyProfileUI()
    if not config.SpoofEnabled or not config.SpoofMyName then return end
    if not config.SpoofProfileUI then return end
    if Spoof._lastPatch and tick() - Spoof._lastPatch < 1.0 then return end
    Spoof._lastPatch = tick()
    local fakeDisp = tostring(config.SpoofMyNameValue or "")
    if fakeDisp == "" then return end
    local fakeUser = Spoof.getMyUser()
    local realName = LocalPlayer.Name
    local realDisp = LocalPlayer.DisplayName or realName
    -- si el juego ya te puso el display spoofeado en Player, seguir usando Name real para buscar
    if string.lower(realDisp) == string.lower(fakeDisp) then
        realDisp = realName
    end
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then Spoof.patchGuiTree(pg, realName, realDisp, fakeDisp, fakeUser) end
    -- OPT: NO escanear CoreGui completo (lag fuerte)
    -- billboards local desactivado (nametag propio = lag / doble nombre)
end
function Spoof.forceLocalDisplay()
    if not config.SpoofEnabled then return end
    if not (config.SpoofMyName or config.SpoofMyDisplayName) then return end
    local fake = Spoof.getMyDisplay()
    if not fake or fake == "" then return end
    pcall(function()
        LocalPlayer.DisplayName = fake
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.DisplayName = fake end
    end)
    pcall(Spoof.patchEscMenu)
end
function Spoof.hookLabel(obj)
    if not obj or Spoof.tagged[obj] then return end
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
    Spoof.tagged[obj] = true
    pcall(function()
        obj:GetPropertyChangedSignal("Text"):Connect(function()
            if not config.SpoofEnabled or not config.SpoofMyName or not config.SpoofProfileUI then return end
            task.defer(function()
                Spoof.patchTextObject(
                    obj,
                    LocalPlayer.Name,
                    LocalPlayer.DisplayName,
                    tostring(config.SpoofMyNameValue),
                    Spoof.getMyUser()
                )
            end)
        end)
    end)
    -- parche inmediato
    if config.SpoofEnabled and config.SpoofMyName and config.SpoofProfileUI then
        Spoof.patchTextObject(
            obj,
            LocalPlayer.Name,
            LocalPlayer.DisplayName,
            tostring(config.SpoofMyNameValue),
            Spoof.getMyUser()
        )
    end
end
-- loop rapido: leaderboard + lista + perfil
task.spawn(function()
    while true do
        task.wait(8) -- menos agresivo = menos lag
        if not config.SpoofEnabled then continue end
        if config.SpoofMyName then
            Spoof.forceLocalDisplay()
            Spoof.patchMyProfileUI()
            pcall(PatchProfileStats) -- level/streak en perfil
        end
        -- no aplicar nametags a todos cada ciclo (lag)
    end
end)

-- GC periódico: conexiones muertas + tablas que crecen
task.spawn(function()
    while true do
        task.wait(45)
        pcall(function()
            local st = getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state
            if st and st.name_spoof_conn then
                for obj, conn in pairs(st.name_spoof_conn) do
                    if not obj or not obj.Parent then
                        pcall(function() if conn then conn:Disconnect() end end)
                        st.name_spoof_conn[obj] = nil
                    end
                end
            end
            if st and st.thumb_spoof_conn then
                for obj, conn in pairs(st.thumb_spoof_conn) do
                    if not obj or not obj.Parent then
                        pcall(function() if type(conn) == "userdata" and conn.Disconnect then conn:Disconnect() end end)
                        st.thumb_spoof_conn[obj] = nil
                    end
                end
            end
            if Spoof and Spoof.tagged then
                local n = 0
                for obj in pairs(Spoof.tagged) do
                    if not obj or not obj.Parent then
                        Spoof.tagged[obj] = nil
                    else
                        n = n + 1
                        if n > 400 then Spoof.tagged[obj] = nil end
                    end
                end
            end
            -- limpia HP cache de jugadores que salieron
            if SFX and SFX.hp then
                for plr in pairs(SFX.hp) do
                    if typeof(plr) == "Instance" and not plr:IsDescendantOf(Players) then
                        SFX.hp[plr] = nil
                    end
                end
            end
            -- limpia cache de nombres
            if getgenv()._ShakoOtherNames and tick() - (getgenv()._ShakoOtherNamesAt or 0) > 60 then
                getgenv()._ShakoOtherNames = nil
            end
        end)
        pcall(function()
            -- OPT: GC manual causa stutter; no forzar cada ciclo
        end)
    end
end)
-- UI nueva + cambios de texto (leaderboard/lista)
pcall(function()
    local pg = LocalPlayer:WaitForChild("PlayerGui", 10)
    if pg then
        -- solo al añadir texto nuevo (no escanear todo al inicio = menos lag)
        pg.DescendantAdded:Connect(function(obj)
            if not config.SpoofEnabled or not config.SpoofMyName then return end
            if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
            -- throttle anti-lag
            local now = tick()
            if now - (getgenv()._ShakoSpoofAddAt or 0) < 0.05 then return end
            getgenv()._ShakoSpoofAddAt = now
            task.defer(function()
                Spoof.patchTextObject(
                    obj,
                    LocalPlayer.Name,
                    LocalPlayer.DisplayName,
                    tostring(config.SpoofMyNameValue),
                    Spoof.getMyUser()
                )
                -- si es UI de perfil, reaplicar stats
                local pn = obj.Parent and obj.Parent.Name or ""
                if pn == "Level" or pn == "Streak" or obj.Name == "Value" then
                    pcall(PatchProfileStats)
                end
            end)
        end)
    end
end)
-- CoreGui scan DESACTIVADO (causaba lag)
-- leftover from old connect - keep patch on add
pcall(function()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if pg then
        pg.DescendantAdded:Connect(function(obj)
            if not config.SpoofEnabled or not config.SpoofMyName or not config.SpoofProfileUI then return end
            task.defer(function()
                if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                    Spoof.patchTextObject(
                        obj,
                        LocalPlayer.Name,
                        LocalPlayer.DisplayName,
                        tostring(config.SpoofMyNameValue),
                        Spoof.getMyUser()
                    )
                end
            end)
        end)
    end
end)
Players.PlayerRemoving:Connect(function(p) Spoof.map[p] = nil end)

-- ==================== SKINCHANGER ====================
-- ==================== SKIN SPOOFER (solo visual) ====================
-- Copia ropa + accesorios + cara + piel desde otro UserId a TU character local
local InsertService = game:GetService("InsertService")
local Skin = {
    lastId = nil,
    applying = false,
    lastClothes = {},
    lastColors = nil,
    lastAccIds = {},
    lastFace = 0,
    keepConn = nil,
    cachedDesc = nil,
    lastKeep = 0,
    lastApply = 0,
}

function Skin.resolveUserId()
    local id = tonumber(config.SkinTargetUserId)
    if id and id > 0 then return id end
    local name = tostring(config.SkinTargetName or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if name == "" then return nil end
    local ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(name) end)
    if ok and type(uid) == "number" and uid > 0 then
        config.SkinTargetUserId = uid
        return uid
    end
    ok, uid = pcall(function() return Players:GetUserIdFromNameAsync(name:gsub("%s+", "")) end)
    if ok and type(uid) == "number" and uid > 0 then
        config.SkinTargetUserId = uid
        return uid
    end
    return nil
end

function Skin.clearAccessories(char)
    if not char then return end
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("Accessory") or v:IsA("Hat") or v:IsA("Accoutrement") then
            pcall(function() v:Destroy() end)
        end
    end
end

function Skin.clearClothes(char)
    if not char then return end
    for _, cls in ipairs({"Shirt", "Pants", "ShirtGraphic"}) do
        local o = char:FindFirstChildOfClass(cls)
        while o do
            pcall(function() o:Destroy() end)
            o = char:FindFirstChildOfClass(cls)
        end
    end
end

function Skin.cloneInto(char, src)
    if not char or not src then return 0 end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local n = 0
    -- BodyColors
    pcall(function()
        local bc = src:FindFirstChildOfClass("BodyColors")
        if bc then
            local old = char:FindFirstChildOfClass("BodyColors")
            if old then old:Destroy() end
            bc:Clone().Parent = char
            n = n + 1
        end
    end)
    -- Shirt / Pants / TShirt
    for _, cls in ipairs({"Shirt", "Pants", "ShirtGraphic"}) do
        pcall(function()
            local s = src:FindFirstChildOfClass(cls)
            if s then
                local old = char:FindFirstChildOfClass(cls)
                while old do old:Destroy(); old = char:FindFirstChildOfClass(cls) end
                local c = s:Clone()
                c.Parent = char
                n = n + 1
            end
        end)
    end
    -- Face
    pcall(function()
        local sh = src:FindFirstChild("Head")
        local th = char:FindFirstChild("Head")
        if not sh or not th then return end
        for _, d in ipairs(th:GetChildren()) do
            if d:IsA("Decal") and (d.Name == "face" or d.Name == "Face") then d:Destroy() end
        end
        for _, d in ipairs(sh:GetChildren()) do
            if d:IsA("Decal") then
                local c = d:Clone()
                c.Parent = th
                n = n + 1
            end
        end
    end)
    -- Accessories (CRITICO)
    Skin.clearAccessories(char)
    for _, item in ipairs(src:GetChildren()) do
        if item:IsA("Accessory") or item:IsA("Hat") or item:IsA("Accoutrement") then
            pcall(function()
                local c = item:Clone()
                local ok = false
                if humanoid then
                    ok = pcall(function() humanoid:AddAccessory(c) end)
                end
                if not ok or not c.Parent then
                    c.Parent = char
                    -- weld handle a head/torso si hace falta
                    local handle = c:FindFirstChild("Handle")
                    if handle and handle:IsA("BasePart") then
                        local att = handle:FindFirstChildOfClass("Attachment")
                        local host = char:FindFirstChild("Head")
                        if att then
                            local match = nil
                            for _, p in ipairs(char:GetDescendants()) do
                                if p:IsA("Attachment") and p.Name == att.Name then match = p break end
                            end
                            if match then
                                host = match.Parent
                            end
                        end
                        if host and host:IsA("BasePart") then
                            handle.CFrame = host.CFrame
                            local w = Instance.new("Weld")
                            w.Part0 = host
                            w.Part1 = handle
                            w.C0 = CFrame.new()
                            w.C1 = CFrame.new()
                            w.Parent = handle
                        end
                    end
                end
                n = n + 1
            end)
        end
    end
    -- Layered clothing / wraps
    for _, d in ipairs(src:GetDescendants()) do
        if d:IsA("WrapLayer") or d:IsA("WrapTarget") then
            -- skip (server side mostly)
        end
    end
    return n
end

function Skin.loadAssetModel(assetId)
    assetId = tonumber(assetId)
    if not assetId or assetId <= 0 then return nil end
    local model = nil
    -- InsertService
    pcall(function()
        if InsertService then
            model = InsertService:LoadAsset(assetId)
        end
    end)
    if model then return model end
    -- GetObjects (executors)
    pcall(function()
        if game.GetObjects then
            local t = game:GetObjects("rbxassetid://" .. tostring(assetId))
            if type(t) == "table" and t[1] then model = t[1] end
        end
    end)
    if model then return model end
    -- AssetService
    pcall(function()
        local AS = game:GetService("AssetService")
        if AS and AS.LoadAssetAsync then
            model = AS:LoadAssetAsync(assetId)
        end
    end)
    return model
end

function Skin.attachAccessory(char, humanoid, acc)
    if not char or not acc then return false end
    local c = acc:Clone()
    c.Name = acc.Name
    local ok = false
    if humanoid then
        ok = pcall(function() humanoid:AddAccessory(c) end)
    end
    if ok and c.Parent then return true end
    -- fallback parent + weld
    c.Parent = char
    local handle = c:FindFirstChild("Handle")
    if handle and handle:IsA("BasePart") then
        local host = char:FindFirstChild("Head") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        local att = handle:FindFirstChildOfClass("Attachment")
        if att then
            for _, a in ipairs(char:GetDescendants()) do
                if a:IsA("Attachment") and a.Name == att.Name then
                    host = a.Parent
                    break
                end
            end
        end
        if host and host:IsA("BasePart") then
            pcall(function()
                handle.CanCollide = false
                handle.Massless = true
                local w = handle:FindFirstChildOfClass("Weld") or handle:FindFirstChildOfClass("WeldConstraint")
                if not w then
                    local weld = Instance.new("WeldConstraint")
                    weld.Part0 = host
                    weld.Part1 = handle
                    weld.Parent = handle
                end
                handle.CFrame = host.CFrame
            end)
        end
    end
    return c.Parent == char
end

function Skin.applyFromDescription(char, humanoid, desc)
    if not char or not desc then return end
    humanoid = humanoid or char:FindFirstChildOfClass("Humanoid")

    -- body colors
    pcall(function()
        local old = char:FindFirstChildOfClass("BodyColors")
        if old then old:Destroy() end
        local bc = Instance.new("BodyColors")
        pcall(function()
            bc.HeadColor3 = desc.HeadColor
            bc.TorsoColor3 = desc.TorsoColor
            bc.LeftArmColor3 = desc.LeftArmColor
            bc.RightArmColor3 = desc.RightArmColor
            bc.LeftLegColor3 = desc.LeftLegColor
            bc.RightLegColor3 = desc.RightLegColor
        end)
        bc.Parent = char
    end)

    -- classic clothes
    Skin.clearClothes(char)
    local function put(cls, prop, id)
        id = tonumber(id)
        if not id or id <= 0 then return false end
        local o = Instance.new(cls)
        pcall(function() o[prop] = "rbxassetid://" .. id end)
        if not o[prop] or o[prop] == "" then
            pcall(function() o[prop] = "http://www.roblox.com/asset/?id=" .. id end)
        end
        o.Parent = char
        return true
    end
    put("Shirt", "ShirtTemplate", desc.Shirt)
    put("Pants", "PantsTemplate", desc.Pants)
    put("ShirtGraphic", "Graphic", desc.GraphicTShirt or desc.TShirt)
    Skin.lastClothes = {
        shirt = tonumber(desc.Shirt) or 0,
        pants = tonumber(desc.Pants) or 0,
        tshirt = tonumber(desc.GraphicTShirt) or 0,
    }

    -- face
    local faceId = tonumber(desc.Face) or 0
    if faceId > 0 then
        local head = char:FindFirstChild("Head")
        if head then
            for _, d in ipairs(head:GetChildren()) do
                if d:IsA("Decal") and (d.Name == "face" or d.Name == "Face") then d:Destroy() end
            end
            local face = Instance.new("Decal")
            face.Name = "face"
            face.Face = Enum.NormalId.Front
            face.Texture = "rbxassetid://" .. faceId
            face.Parent = head
            Skin.lastFace = faceId
        end
    end

    -- collect accessory ids (classic + layered)
    local ids, seen = {}, {}
    local function addId(id)
        id = tonumber(id)
        if id and id > 0 and not seen[id] then
            seen[id] = true
            table.insert(ids, id)
        end
    end
    for _, field in ipairs({
        "HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory",
        "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory",
    }) do
        local val = ""
        pcall(function() val = tostring(desc[field] or "") end)
        for id in string.gmatch(val, "%d+") do addId(id) end
    end
    pcall(function()
        for _, a in ipairs(desc:GetAccessories(true) or {}) do
            addId(a.AssetId)
        end
    end)
    pcall(function()
        for _, a in ipairs(desc:GetAccessories(false) or {}) do
            addId(a.AssetId)
        end
    end)
    Skin.lastAccIds = ids

    -- no borrar acc si ForceFieldRemoveAcc; nosotros controlamos
    Skin.clearAccessories(char)
    local got = 0
    for _, id in ipairs(ids) do
        local model = Skin.loadAssetModel(id)
        if model then
            local acc = model:FindFirstChildOfClass("Accessory")
                or model:FindFirstChildOfClass("Hat")
                or model:FindFirstChildWhichIsA("Accoutrement", true)
            if not acc then
                for _, d in ipairs(model:GetDescendants()) do
                    if d:IsA("Accessory") or d:IsA("Hat") or d:IsA("Accoutrement") then
                        acc = d
                        break
                    end
                end
            end
            if acc and Skin.attachAccessory(char, humanoid, acc) then
                got = got + 1
            end
            pcall(function() model:Destroy() end)
        end
        task.wait(0.03)
    end
    return got
end

function Skin.reapplyColors()
    local char = LocalPlayer.Character
    if not char or not Skin.lastColors then return end
    local c = Skin.lastColors
    local map = {
        Head = c.Head, Torso = c.Torso,
        ["Left Arm"] = c.LeftArm, ["Right Arm"] = c.RightArm,
        ["Left Leg"] = c.LeftLeg, ["Right Leg"] = c.RightLeg,
        UpperTorso = c.Torso, LowerTorso = c.Torso,
        LeftUpperArm = c.LeftArm, LeftLowerArm = c.LeftArm, LeftHand = c.LeftArm,
        RightUpperArm = c.RightArm, RightLowerArm = c.RightArm, RightHand = c.RightArm,
        LeftUpperLeg = c.LeftLeg, LeftLowerLeg = c.LeftLeg, LeftFoot = c.LeftLeg,
        RightUpperLeg = c.RightLeg, RightLowerLeg = c.RightLeg, RightFoot = c.RightLeg,
    }
    for name, col in pairs(map) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") and col then
            pcall(function() part.Color = col end)
        end
    end
end

function Skin.copyAvatar(userId)
    -- disabled: avatar 3D spoof = lag
    return false
end

function Skin.SpoofSkin(userId)
    return Skin.copyAvatar(userId)
end

function Skin.apply()
    local id = Skin.resolveUserId()
    if not id then
        Notify("Skin", "Pon UserId o nombre Roblox")
        return false
    end
    return Skin.copyAvatar(id)
end

LocalPlayer.CharacterAdded:Connect(function()
    if not (config.SkinchangerEnabled or Skin.lastId) then return end
    local id = Skin.lastId or tonumber(config.SkinTargetUserId)
    if not id or id <= 0 then return end
    if not config.SkinOnRespawn and not config.SkinchangerEnabled then return end
    task.spawn(function()
        for _, d in ipairs({0.5, 1.2, 2.0, 3.5, 5.0}) do
            task.wait(d)
            if not (config.SkinchangerEnabled or Skin.lastId) then return end
            if LocalPlayer.Character then
                pcall(function() Skin.copyAvatar(id) end)
            end
        end
    end)
end)

task.spawn(function()
    while true do
        task.wait(1)
        if (config.SkinchangerEnabled or Skin.lastId) and LocalPlayer.Character then
            Skin.reapplyColors()
        end
    end
end)





function StartTriggerbot()
    SafeDisconnect("Triggerbot")
    local tbFrame = 0
    Connections.Triggerbot = RunService.RenderStepped:Connect(function()
        tbFrame += 1
        if tbFrame % 3 ~= 0 then return end -- OPT
        if not config.TriggerbotEnabled or UserInputService:GetFocusedTextBox() then return end
        local partName = config.TriggerbotPart or "Head"
        local mousePos = UserInputService:GetMouseLocation()
        local hit = false
        for _, plr in pairs(Players:GetPlayers()) do
            if plr == LocalPlayer or not plr.Character then continue end
            if config.TeamCheck and IsSameTeam(plr) then continue end
            local part = plr.Character:FindFirstChild(partName) or plr.Character:FindFirstChild("Head")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if not part or not hum or hum.Health <= 0 then continue end
            local sp, on = Camera:WorldToViewportPoint(part.Position)
            if on and sp.Z > 0 and (Vector2.new(sp.X, sp.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude <= (config.TriggerbotFOV or 40) then
                hit = true
                break
            end
        end
        if hit and tick() - lastTriggerClick >= 1 / math.max(config.TriggerbotCPS or 12, 1) then
            lastTriggerClick = tick()
            pcall(function() mouse1click() end)
        end
    end)
end
function StopTriggerbot() SafeDisconnect("Triggerbot") end

-- Rapid Fire


local StartSilentAim, StopSilentAim, StartFOVDraw, silentTarget, silentCFD, loadSilentDeps, updateFOVCircle, fovColor, isVisibleWall
function InitCombatHooks()
-- ==================== FOV estilo Grief.cc (ScreenGui + gradient + spin) ====================
local FOV_COLORS = {
    White = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 70, 80),
    Green = Color3.fromRGB(80, 255, 140),
    Cyan = Color3.fromRGB(80, 220, 255),
    Magenta = Color3.fromRGB(255, 100, 220),
    Yellow = Color3.fromRGB(255, 230, 80),
    Orange = Color3.fromRGB(255, 160, 50),
    Purple = Color3.fromRGB(168, 85, 255),
}
fovColor = function(name)
    if typeof(name) == "Color3" then return name end
    return FOV_COLORS[name or "White"] or Color3.fromRGB(255, 255, 255)
end

local fovScreenGui
function ensureFovGui()
    if fovScreenGui and fovScreenGui.Parent then return fovScreenGui end
    local parent
    pcall(function() parent = gethui and gethui() end)
    if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
    if not parent then parent = LocalPlayer:FindFirstChild("PlayerGui") end
    local g = Instance.new("ScreenGui")
    g.Name = "ShakoFOV_Grief"
    g.DisplayOrder = 99980
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    g.Parent = parent
    fovScreenGui = g
    return g
end

function buildGriefFOV(name, cfg)
    local gui = ensureFovGui()
    local container = Instance.new("Frame")
    container.Name = name
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Visible = false
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Parent = gui

    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(1, 1)
    fill.BackgroundColor3 = Color3.new(1, 1, 1)
    fill.BackgroundTransparency = cfg.fillTrans or 0.92
    fill.BorderSizePixel = 0
    fill.ZIndex = 1
    fill.Parent = container
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local fillgrad = Instance.new("UIGradient")
    fillgrad.Color = ColorSequence.new(cfg.col1 or Color3.new(1,1,1), cfg.col2 or Color3.new(1,1,1))
    fillgrad.Parent = fill

    local outline = Instance.new("Frame")
    outline.Size = UDim2.fromScale(1, 1)
    outline.BackgroundTransparency = 1
    outline.BorderSizePixel = 0
    outline.ZIndex = 2
    outline.Parent = container
    Instance.new("UICorner", outline).CornerRadius = UDim.new(1, 0)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = cfg.thickness or 1.5
    stroke.Transparency = cfg.outlineTrans or 0.08
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = outline
    local strokegrad = Instance.new("UIGradient")
    strokegrad.Color = ColorSequence.new(cfg.col1 or Color3.new(1,1,1), cfg.col2 or Color3.fromRGB(180,180,255))
    strokegrad.Parent = stroke

    return { container = container, fill = fill, fillgrad = fillgrad, stroke = stroke, strokegrad = strokegrad }
end

local silentFOVUI = buildGriefFOV("SilentFOV", {
    fillTrans = 0.92, thickness = 1.5,
    col1 = Color3.fromRGB(255,255,255), col2 = Color3.fromRGB(180,200,255),
})
local aimbotFOVUI = buildGriefFOV("AimbotFOV", {
    fillTrans = 0.94, thickness = 1.5,
    col1 = Color3.fromRGB(255,210,80), col2 = Color3.fromRGB(255,120,50),
})

function applyFOVUI(ui, enabled, show, radius, colName, doFill, fillTrans, animated, spin, outlineCol, fillC1, fillC2, fillC3)
    if not ui or not ui.container then return end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local vis = enabled and show
    ui.container.Visible = vis and true or false
    if not vis then return end

    local col = outlineCol
    if typeof(col) ~= "Color3" then
        col = fovColor(colName)
    end
    local c1 = (typeof(fillC1) == "Color3" and fillC1) or col
    local c2 = (typeof(fillC2) == "Color3" and fillC2) or Color3.new(
        math.clamp(col.R * 0.7 + 0.15, 0, 1),
        math.clamp(col.G * 0.7 + 0.15, 0, 1),
        math.clamp(col.B * 0.85 + 0.2, 0, 1)
    )
    local c3 = (typeof(fillC3) == "Color3" and fillC3) or Color3.new(
        math.clamp(col.R * 0.45 + 0.1, 0, 1),
        math.clamp(col.G * 0.45 + 0.1, 0, 1),
        math.clamp(col.B * 0.7 + 0.25, 0, 1)
    )

    local r = tonumber(radius) or 120
    if animated then r = r * (0.97 + 0.03 * math.sin(tick() * 2.2)) end
    local center = cam.ViewportSize / 2
    ui.container.Position = UDim2.fromOffset(center.X, center.Y)
    ui.container.Size = UDim2.fromOffset(r * 2, r * 2)

    if ui.fill then
        ui.fill.Visible = doFill and true or false
        ui.fill.BackgroundTransparency = tonumber(fillTrans) or 0.92
        ui.fill.BackgroundColor3 = Color3.new(1, 1, 1)
        if ui.fillgrad then
            pcall(function()
                ui.fillgrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, c1),
                    ColorSequenceKeypoint.new(0.5, c2),
                    ColorSequenceKeypoint.new(1, c3),
                })
                if spin then
                    ui.fillgrad.Rotation = (tick() * (tonumber(config.SilentFOVSpinSpeed) or 1.2) * 60) % 360
                end
            end)
        end
    end
    if ui.stroke then
        ui.stroke.Color = col
        ui.stroke.Thickness = tonumber(config.SilentFOVThickness) or 1.5
        if ui.strokegrad then
            pcall(function()
                ui.strokegrad.Color = ColorSequence.new(col, col)
                if spin then
                    ui.strokegrad.Rotation = (tick() * (tonumber(config.SilentFOVSpinSpeed) or 1.2) * 90) % 360
                end
            end)
        end
    end
end


StartFOVDraw = function()
    SafeDisconnect("FOVDraw")
    local fovFrame = 0
    Connections.FOVDraw = RunService.Heartbeat:Connect(function()
        fovFrame += 1
        if fovFrame % 5 ~= 0 then return end -- less lag
        -- skip si ninguno visible
        local sOn = config.SilentAimEnabled and config.SilentShowFOV ~= false
        local aOn = config.AimbotEnabled and config.AimbotShowFOV ~= false
        if not sOn and not aOn then
            if silentFOVUI and silentFOVUI.container then silentFOVUI.container.Visible = false end
            if aimbotFOVUI and aimbotFOVUI.container then aimbotFOVUI.container.Visible = false end
            return
        end
        fovFrame = fovFrame + 1
        -- anim/spin: cada frame; si no, cada 2
        local needFast = (sOn and (config.SilentFOVAnimated or config.SilentFOVSpin)) or (aOn and (config.AimbotFOVAnimated or config.AimbotFOVSpin))
        if not needFast and fovFrame % 2 == 0 then return end
        if sOn then
            applyFOVUI(silentFOVUI, true, true,
                config.SilentFOV or 300, config.SilentFOVColor or "White",
                config.SilentFOVFill == true, config.SilentFOVFillTransparency,
                config.SilentFOVAnimated, config.SilentFOVSpin == true,
                config.SilentFOVOutlineColor3, config.SilentFOVFillC1, config.SilentFOVFillC2, config.SilentFOVFillC3)
        else
            if silentFOVUI and silentFOVUI.container then silentFOVUI.container.Visible = false end
        end
        if aOn then
            applyFOVUI(aimbotFOVUI, true, true,
                config.AimbotFOV or 180, config.AimbotFOVColor or "Yellow",
                config.AimbotFOVFill == true, config.AimbotFOVFillTransparency,
                config.AimbotFOVAnimated, config.AimbotFOVSpin == true,
                config.AimbotFOVOutlineColor3, config.AimbotFOVFillC1, config.AimbotFOVFillC2, config.AimbotFOVFillC3)
        else
            if aimbotFOVUI and aimbotFOVUI.container then aimbotFOVUI.container.Visible = false end
        end
    end)
end
StartFOVDraw()

isVisibleWall = function(fromPos, toPos, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = { LocalPlayer.Character }
    if targetChar then table.insert(filter, targetChar) end
    params.FilterDescendantsInstances = filter
    params.IgnoreWater = true
    local dir = toPos - fromPos
    local res = workspace:Raycast(fromPos, dir, params)
    return res == nil
end


-- ==================== SILENT AIM v3 (Rivals — head · no rompe balas/ammo) ====================
local GameplayUtility, GunModule
local silentHooked = false
local silentOldFire, silentOldRaycast, silentOldNamecall

loadSilentDeps = function()
    pcall(function()
        GameplayUtility = require(RS.Modules.GameplayUtility)
    end)
    pcall(function()
        local ok, gun = pcall(require, LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
        if ok and gun then GunModule = gun end
    end)
    if not util or not enum then
        pcall(loadRivalsModules)
    end
end
task.spawn(loadSilentDeps)

-- Solo Head en FOV
silentTarget = function()
    if not config.SilentAimEnabled then return nil end
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local center = cam.ViewportSize / 2
    local fov = math.max(tonumber(config.SilentFOV) or 300, 20)
    local bestHead, bestDist = nil, fov
    local myChar = LocalPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myPos = myRoot and myRoot.Position or cam.CFrame.Position

    local function wallClear(fromPos, toPos, ignoreChar)
        if not config.SilentWallCheck and not config.SilentVisibleCheck then return true end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignore = { LocalPlayer.Character }
        if ignoreChar then table.insert(ignore, ignoreChar) end
        params.FilterDescendantsInstances = ignore
        local hit = workspace:Raycast(fromPos, toPos - fromPos, params)
        if not hit then return true end
        return hit.Instance and ignoreChar and hit.Instance:IsDescendantOf(ignoreChar)
    end

    local function getHitPart(char)
        if not char then return nil end
        local want = tostring(config.SilentHitPart or "Head")
        -- Solo preferir HitboxHead si el usuario eligio Head
        if (want == "Head" or want == "HitboxHead") and config.SilentUseHitboxHead ~= false then
            local hb = char:FindFirstChild("HitboxHead")
                or char:FindFirstChild("HitboxHeadSmall")
            if hb then return hb end
        end
        if want == "Torso" then
            return char:FindFirstChild("UpperTorso")
                or char:FindFirstChild("Torso")
                or char:FindFirstChild("HitboxBody")
                or char:FindFirstChild("HumanoidRootPart")
        end
        if want == "HitboxHead" then
            return char:FindFirstChild("HitboxHead")
                or char:FindFirstChild("HitboxHeadSmall")
                or char:FindFirstChild("Head")
        end
        return char:FindFirstChild(want)
            or char:FindFirstChild("Head")
            or char:FindFirstChild("HitboxBody")
            or char:FindFirstChild("HumanoidRootPart")
    end

    local function tryPart(char)
        if not char or char == myChar then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local part = getHitPart(char)
        if not part then return end
        local sp, onScreen = cam:WorldToViewportPoint(part.Position)
        if sp.Z <= 0 then return end
        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(center.X, center.Y)).Magnitude
        if d > fov then return end
        if not wallClear(myPos, part.Position, char) then return end
        if d < bestDist then bestDist, bestHead = d, part end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if config.SilentTeamCheck ~= false and StrongIsTeammate and StrongIsTeammate(plr) then continue end
        if config.SilentTeamCheck ~= false and StrongIsTeammate and StrongIsTeammate(plr) then continue end
        tryPart(plr.Character)
    end
    pcall(function()
        for _, entity in ipairs(game:GetService("CollectionService"):GetTagged("Entity")) do
            local plr = Players:GetPlayerFromCharacter(entity)
            if plr == LocalPlayer then continue end
            if plr and config.SilentTeamCheck and IsEnemy and not IsEnemy(plr) then continue end
            tryPart(entity)
        end
    end)
    return bestHead
end

-- Prediccion suave: solo horizontal, sin over-lead
function silentPredictPos(head, origin)
    local pos = head.Position
    if config.SilentPredict == false then return pos end
    local char = head.Parent
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return pos end
    local vel = Vector3.zero
    pcall(function() vel = root.AssemblyLinearVelocity end)
    if vel.Magnitude < 4 then return pos end
    local vFlat = Vector3.new(vel.X, vel.Y * 0.35, vel.Z)
    local t = math.clamp(tonumber(config.SilentPredictAmount) or 0.08, 0, 0.35)
    if origin then
        local dist = (pos - origin).Magnitude
        t = t + math.clamp(dist / 2200, 0, 0.08)
    end
    return pos + vFlat * t
end


-- ==================== SILENT AIM (metodo Kiciahook v3) ====================
-- Mutar Args["\1"] in-place, conservar origen del tiro, HitboxHead + object-space raycast

local function kiciaEncodeCF(cf)
    if not cf then return nil end
    if util and util.EncodeCFrame then
        local ok, enc = pcall(function() return util:EncodeCFrame(cf) end)
        if ok and enc ~= nil then return enc end
    end
    local rx, ry, rz = cf:ToOrientation()
    return {
        [utf8.char(0)] = cf.X,
        [utf8.char(1)] = cf.Y,
        [utf8.char(2)] = cf.Z,
        [utf8.char(3)] = rx,
        [utf8.char(4)] = ry,
        [utf8.char(5)] = rz,
    }
end

local function kiciaDecodeCF(t)
    if type(t) ~= "table" then return nil end
    if util and util.DecodeCFrame then
        local ok, cf = pcall(function() return util:DecodeCFrame(t) end)
        if ok and typeof(cf) == "CFrame" then return cf end
    end
    local x = t[utf8.char(0)] or t[0]
    local y = t[utf8.char(1)] or t[1]
    local z = t[utf8.char(2)] or t[2]
    local rx = t[utf8.char(3)] or t[3]
    local ry = t[utf8.char(4)] or t[4]
    local rz = t[utf8.char(5)] or t[5]
    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then return nil end
    rx = type(rx) == "number" and rx or 0
    ry = type(ry) == "number" and ry or 0
    rz = type(rz) == "number" and rz or 0
    return CFrame.new(x, y, z) * CFrame.fromOrientation(rx, ry, rz)
end

-- cO de Kicia: raycast Include solo al hitbox → PointToObjectSpace
local function kiciaObjectSpace(origin, hitbox, aimPos)
    if not origin or not hitbox or not aimPos then return nil end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances = { hitbox }
    local hit = workspace:Raycast(origin, aimPos - origin, params)
    if not hit then
        -- fallback: punto en superficie / centro
        local ok, closest = pcall(function() return hitbox:GetClosestPointOnSurface(origin) end)
        if ok and closest then
            local os = hitbox.CFrame:PointToObjectSpace(closest)
            if os ~= Vector3.zero then return os end
        end
        return hitbox.CFrame:PointToObjectSpace(aimPos)
    end
    local os = hitbox.CFrame:PointToObjectSpace(hit.Position)
    if os == Vector3.zero then return nil end
    return os
end

silentCFD = function(origin, head)
    -- fallback completo si no hay packet original
    if not head or not origin then return nil end
    local aimPos = head.Position
    local os = kiciaObjectSpace(origin, head, aimPos) or Vector3.new(0, 0, 0)
    return {
        [utf8.char(1)] = {
            [utf8.char(0)] = kiciaEncodeCF(CFrame.lookAt(origin, aimPos)),
            [utf8.char(1)] = kiciaEncodeCF(head.CFrame),
            [utf8.char(2)] = head,
            [utf8.char(3)] = kiciaEncodeCF(CFrame.new(os)),
        }
    }
end

function silentIsStartShooting(enumVal)
    if enumVal == nil then return false end
    if enum then
        local ok, shoot = pcall(function() return enum:ToEnum("StartShooting") end)
        if ok and shoot ~= nil and enumVal == shoot then return true end
    end
    if type(enumVal) == "string" and string.find(string.lower(enumVal), "startshoot", 1, true) then
        return true
    end
    return false
end


-- ==================== EXTEND MELEE RANGE (Kicia) ====================
local MELEE_NAMES = {
    knife=true, fists=true, katana=true, scythe=true, chainsaw=true,
    trowel=true, daggers=true, dagger=true, ["battle axe"]=true,
    ["glass shard"]=true, ["riot shield"]=true, fist=true, axe=true,
    sword=true, bat=true, hammer=true, melee=true,
}

local function kiciaCFEncode(cf)
    local p, y, r = cf:ToOrientation()
    return {
        [utf8.char(0)] = cf.X, [utf8.char(1)] = cf.Y, [utf8.char(2)] = cf.Z,
        [utf8.char(3)] = p, [utf8.char(4)] = y, [utf8.char(5)] = r,
    }
end

local function kiciaCFDecode(t)
    if type(t) ~= "table" then return nil end
    local x, y, z = t[utf8.char(0)], t[utf8.char(1)], t[utf8.char(2)]
    local p, yw, r = t[utf8.char(3)], t[utf8.char(4)], t[utf8.char(5)]
    if type(x) ~= "number" or type(y) ~= "number" or type(z) ~= "number" then return nil end
    return CFrame.new(x, y, z) * CFrame.fromOrientation(p or 0, yw or 0, r or 0)
end

function isMeleeEquipped()
    local ok, res = pcall(function()
        if not FighterController then
            pcall(function()
                FighterController = require(LocalPlayer.PlayerScripts.Controllers.FighterController)
            end)
        end
        local lf = FighterController and FighterController.LocalFighter
        if not lf then return false end
        local slot = nil
        pcall(function() slot = lf.EquippedSlot or lf.Slot end)
        if slot == 3 or slot == "Melee" or tostring(slot) == "3" then return true end
        local item = lf.EquippedItem
        if not item then return false end
        local t = nil
        pcall(function() t = item.__type end)
        if not t and item.Get then
            pcall(function() t = item:Get("Type") or item:Get("ItemType") or item:Get("Category") end)
        end
        if t and string.find(string.lower(tostring(t)), "melee", 1, true) then return true end
        local name = ""
        pcall(function()
            name = tostring(item.Name or "")
            if (name == "" or name == "nil") and item.Get then
                name = tostring(item:Get("Name") or "")
            end
        end)
        name = string.lower(name)
        if MELEE_NAMES[name] then return true end
        for k in pairs(MELEE_NAMES) do
            if string.find(name, k, 1, true) then return true end
        end
        return false
    end)
    return ok and res == true
end

function findClosestEnemyRootMelee(origin, range)
    local best, bestD = nil, range
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local skip = false
            pcall(function()
                if config.TeamCheck and type(IsSameTeam) == "function" and IsSameTeam(plr) then skip = true end
            end)
            if not skip then
                local char = plr.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hum and hrp and hum.Health > 0 then
                    local d = (hrp.Position - origin).Magnitude
                    if d <= bestD then bestD, best = d, hrp end
                end
            end
        end
    end
    return best
end

function applyExtendMelee(camdata)
    if not config.ExtendMeleeRange then return camdata end
    if not isMeleeEquipped() then return camdata end
    if type(camdata) ~= "table" then return camdata end
    local range = tonumber(config.ExtendMeleeRangeDist) or 10
    if range < 5 then range = 5 end
    if range > 20 then range = 20 end
    local k1, k0 = utf8.char(1), utf8.char(0)
    local block = camdata[k1]
    if type(block) ~= "table" then
        if camdata[k0] ~= nil then block = camdata else return camdata end
    end
    local raw = block[k0]
    local origin = nil
    local useTable = type(raw) == "table" and type(raw[k0]) == "number"
    if useTable then
        local cf = kiciaCFDecode(raw)
        if cf then origin = cf.Position end
    end
    if not origin and util and util.DecodeCFrame and raw then
        local ok, cf = pcall(function() return util:DecodeCFrame(raw) end)
        if ok and typeof(cf) == "CFrame" then origin = cf.Position end
    end
    if not origin then
        local my = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not my then return camdata end
        origin = my.Position
    end
    local enemy = findClosestEnemyRootMelee(origin, range)
    if not enemy then return camdata end
    local aimCF = CFrame.new(enemy.Position) * CFrame.fromOrientation(-1.5707963267948966, 0, 0)
    if useTable then
        local enc = kiciaCFEncode(aimCF)
        block[k0], block[k1] = enc, enc
    else
        local U = util
        if not U then pcall(function() U = require(game:GetService("ReplicatedStorage").Modules.Utility) end) end
        if U and U.EncodeCFrame then
            local enc = U:EncodeCFrame(aimCF)
            block[k0], block[k1] = enc, enc
        else
            local enc = kiciaCFEncode(aimCF)
            block[k0], block[k1] = enc, enc
        end
    end
    return camdata
end



-- UseItem hook permanente (melee + silent)
task.spawn(function()
    for _ = 1, 40 do
        if silentOldFire then return end
        local ok, UseItem = pcall(function()
            return game:GetService("ReplicatedStorage").Remotes.Replication.Fighter.UseItem
        end)
        if ok and UseItem and hookfunction then
            pcall(function()
                silentOldFire = hookfunction(UseItem.FireServer, newcclosure(function(self, objID, enumVal, camdata, extra, ...)
                    if config.ExtendMeleeRange and type(applyExtendMelee) == "function" then
                        local okM, patchedM = pcall(applyExtendMelee, camdata)
                        if okM and patchedM ~= nil then camdata = patchedM end
                    end
                    if config.SilentAimEnabled and getgenv()._ShakoSilentActive then
                        local isShoot = false
                        pcall(function()
                            if type(silentIsStartShooting) == "function" then
                                isShoot = silentIsStartShooting(enumVal) == true
                            end
                        end)
                        if isShoot then
                            local patchFn = getgenv()._ShakoSilentPatch
                            if type(patchFn) == "function" then
                                local okP, patched = pcall(patchFn, camdata)
                                if okP and patched ~= nil then camdata = patched end
                            end
                        end
                    end
                    return silentOldFire(self, objID, enumVal, camdata, extra, ...)
                end))
            end)
            return
        end
        task.wait(0.25)
    end
end)

StartSilentAim = function()
    loadSilentDeps()
    if not util or not enum then
        pcall(loadRivalsModules)
        loadSilentDeps()
    end
    if not util or not enum then
        Notify("Silent", "Modules no listos — reintenta")
        return
    end

    getgenv()._ShakoSilentState = getgenv()._ShakoSilentState or {
        locked = nil, lockedAt = 0, lastSwitch = 0,
    }
    local SState = getgenv()._ShakoSilentState

    if config.SilentForceAiming then
        pcall(function()
            local ok, gun = pcall(require, LocalPlayer.PlayerScripts.Modules.ItemTypes.Gun)
            if ok and gun and gun.IsFullyAiming then
                gun.IsFullyAiming = function() return true end
            end
        end)
    end

    local function getSilentPart()
        local t = silentTarget()
        if not t then
            SState.locked = nil
            return nil
        end
        local now = tick()
        local switchDelay = tonumber(config.SilentSwitchDelay) or 0
        local react = tonumber(config.SilentReactionTime) or 0
        if SState.locked and SState.locked.Parent and switchDelay > 0 then
            if (now - (SState.lastSwitch or 0)) < switchDelay then
                t = SState.locked
            end
        end
        if t ~= SState.locked then
            SState.locked = t
            SState.lockedAt = now
            SState.lastSwitch = now
        end
        if react > 0 and (now - (SState.lockedAt or 0)) < react then
            return nil
        end
        return t
    end

    -- METODO KICIA: mutar entry in-place, conservar origin del packet
    local function patchCamdata(camdata)
        if config.SilentManipulate == false then return camdata end
        local chance = tonumber(config.SilentActivationChance) or 100
        if chance < 100 and math.random() > (chance / 100) then return camdata end

        local ok, result = pcall(function()
            local hitbox = getSilentPart()
            if not hitbox then return camdata end
            if type(camdata) ~= "table" then return camdata end

            local key = utf8.char(1)
            local entry = camdata[key]
            if type(entry) ~= "table" then
                -- packet raro: construir completo
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if not root then return camdata end
                return silentCFD(root.Position, hitbox) or camdata
            end

            local aim0 = kiciaDecodeCF(entry[utf8.char(0)])
            local aim1 = kiciaDecodeCF(entry[utf8.char(1)])
            local originPos
            if aim0 then
                originPos = aim0.Position -- Kicia: conserva origen del tiro
            else
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                originPos = root and root.Position
            end
            if not originPos then return camdata end

            local targetPos = hitbox.Position
            -- Head offset minimo
            local up = tonumber(config.SilentHeadOffsetY) or 0
            if up ~= 0 then
                targetPos = targetPos + Vector3.new(0, up, 0)
            end
            if config.SilentPredict then
                local pred = silentPredictPos(hitbox, originPos)
                targetPos = Vector3.new(pred.X, targetPos.Y, pred.Z)
            end

            local os = kiciaObjectSpace(originPos, hitbox, targetPos)
            if not os then return camdata end -- sin object-space valido = no tocar (ammo OK)

            -- mutar in-place (Kicia)
            entry[utf8.char(0)] = kiciaEncodeCF(CFrame.lookAt(originPos, targetPos))
            if aim1 then
                entry[utf8.char(1)] = kiciaEncodeCF(CFrame.lookAt(aim1.Position, targetPos))
            else
                entry[utf8.char(1)] = kiciaEncodeCF(hitbox.CFrame)
            end
            entry[utf8.char(2)] = hitbox
            entry[utf8.char(3)] = kiciaEncodeCF(CFrame.new(os))
            return camdata
        end)
        if ok and result ~= nil then return result end
        return camdata
    end

    -- Sin hook de raycast agresivo (Kicia no lo usa asi en silent)
    -- Solo FireServer / namecall

    local UseItem
    pcall(function()
        UseItem = RS.Remotes.Replication.Fighter.UseItem
    end)

    getgenv()._ShakoSilentPatch = patchCamdata
    getgenv()._ShakoSilentActive = true

    if UseItem and hookfunction then
        if not silentOldFire then
            pcall(function()
                silentOldFire = hookfunction(UseItem.FireServer, newcclosure(function(self, objID, enumVal, camdata, extra, ...)
                    if config.ExtendMeleeRange and type(applyExtendMelee) == "function" then
                        local okM, patchedM = pcall(applyExtendMelee, camdata)
                        if okM and patchedM ~= nil then camdata = patchedM end
                    end
                    if config.SilentAimEnabled and getgenv()._ShakoSilentActive then
                        local isShoot = false
                        pcall(function()
                            if type(silentIsStartShooting) == "function" then
                                isShoot = silentIsStartShooting(enumVal) == true
                            end
                        end)
                        if isShoot then
                            local patchFn = getgenv()._ShakoSilentPatch
                            if type(patchFn) == "function" then
                                local ok, patched = pcall(patchFn, camdata)
                                if ok and patched ~= nil then camdata = patched end
                            end
                        end
                    end
                    return silentOldFire(self, objID, enumVal, camdata, extra, ...)
                end))
            end)
        else
            getgenv()._ShakoSilentPatch = patchCamdata
        end
    end

    if not silentOldFire and not silentOldNamecall and hookmetamethod then
        pcall(function()
            silentOldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
                local method = getnamecallmethod and getnamecallmethod() or ""
                if config.SilentAimEnabled and method == "FireServer" then
                    local UseItemRemote
                    pcall(function() UseItemRemote = RS.Remotes.Replication.Fighter.UseItem end)
                    if self == UseItemRemote then
                        local n = select("#", ...)
                        local args = {...}
                        if silentIsStartShooting(args[2]) then
                            local ok, patched = pcall(patchCamdata, args[3])
                            if ok and patched ~= nil then args[3] = patched end
                            return silentOldNamecall(self, table.unpack(args, 1, n))
                        end
                    end
                end
                return silentOldNamecall(self, ...)
            end))
        end)
    end

    silentHooked = true
    config.SilentAimEnabled = true
    Notify("Silent", "ON · Kicia method")
end


StopSilentAim = function()
    config.SilentAimEnabled = false
    getgenv()._ShakoSilentActive = false
    getgenv()._ShakoSilentPatch = nil
    Notify("Silent", "OFF")
end

end -- InitCombatHooks

InitCombatHooks()

function StartRapidFire()
    config.RapidFire = true
    if ApplyItemLibraryGuns(true) then
        Notify("ItemLibrary", "Fast Fire + NoRecoil props ON")
    else
        Notify("ItemLibrary", "FAIL — Modules.ItemLibrary")
    end
end
function StopRapidFire()
    config.RapidFire = false
    ApplyItemLibraryGuns(false)
    if config.FastMelee then ApplyItemLibraryMelee(true) end
    Notify("ItemLibrary", "Fast Fire OFF (restored)")
end
function StartFastMelee()
    config.FastMelee = true
    ApplyItemLibraryMelee(true)
    Notify("ItemLibrary", "Fast Melee ON")
end
function StopFastMelee()
    config.FastMelee = false
    ApplyItemLibraryMelee(false)
    if config.RapidFire then ApplyItemLibraryGuns(true) end
    Notify("ItemLibrary", "Fast Melee OFF")
end

-- No Recoil scan

-- Targeting
function GetTargetByName()
    if not config.UseNameTarget or config.TargetName == "" then return nil end
    local n = string.lower(config.TargetName)
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and string.lower(plr.Name):find(n) then
            local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 and IsEnemy(plr) then return plr end
        end
    end
    return nil
end
function ScoreTarget(plr, myHRP)
    local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local head = plr.Character and plr.Character:FindFirstChild("Head")
    local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
    if not root or not hum or hum.Health <= 0 then return math.huge end
    local dist = (myHRP.Position - root.Position).Magnitude
    if not config.InfiniteRange and not config.RageInfinite then
        local mr = tonumber(config.MaxRange) or 1e9
        if dist > mr then return math.huge end
    end
    if config.PriorityMode == "LowestHP" then return hum.Health + dist * 0.05 end
    if config.PriorityMode == "Crosshair" and head then
        local sp, on = Camera:WorldToViewportPoint(head.Position)
        if not on then return math.huge end
        local m = UserInputService:GetMouseLocation()
        return (Vector2.new(sp.X, sp.Y) - Vector2.new(m.X, m.Y)).Magnitude
    end
    return dist
end
function GetClosestEnemy()
    if config.TargetLock and LockedTarget and LockedTarget.Parent and LockedTarget.Character then
        local hum = LockedTarget.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health > 0 and IsEnemy(LockedTarget) then
            return LockedTarget
        else LockedTarget = nil end
    end
    local named = GetTargetByName()
    if named and IsEnemy(named) then
        if config.TargetLock then LockedTarget = named end
        return named
    end
    local myHRP = getHRP()
    if not myHRP then return nil end
    local best, bestScore = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        if not IsEnemy(plr) then continue end -- nunca team
        local score = ScoreTarget(plr, myHRP)
        if score < bestScore then bestScore, best = score, plr end
    end
    if best and config.TargetLock then LockedTarget = best end
    return best
end
function PredictPos(root, head)
    if not config.RagebotPredict or not root then return head and head.Position or root.Position end
    return (head and head.Position or root.Position) + root.AssemblyLinearVelocity * (config.RagebotPredictAmount or 0.12)
end
local _rageWeakUntil = _rageWeakUntil or {}


-- Escudo / ForceField de spawn o spawn protection (Rivals)
function targetHasShield(char)
    if not char then return true end
    if char:FindFirstChildOfClass("ForceField") then return true end
    for _, c in ipairs(char:GetChildren()) do
        local n = string.lower(c.Name)
        if n:find("forcefield") or n:find("shield") or n:find("spawnprotect")
            or n:find("protection") or n:find("invuln") or n:find("riot") then
            return true
        end
        if c:IsA("Tool") and (n:find("shield") or n:find("riot")) then
            return true
        end
    end
    local def = false
    pcall(function()
        def = char:GetAttribute("Deflecting") or char:GetAttribute("IsDeflecting") or false
    end)
    if def then return true end
    -- attributes
    local ok, v = pcall(function()
        return char:GetAttribute("ForceField")
            or char:GetAttribute("HasForceField")
            or char:GetAttribute("SpawnProtection")
            or char:GetAttribute("Invincible")
            or char:GetAttribute("Protected")
    end)
    if ok and v then return true end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local ok2, v2 = pcall(function()
            return hum:GetAttribute("ForceField")
                or hum:GetAttribute("SpawnProtection")
                or hum:GetAttribute("Invincible")
        end)
        if ok2 and v2 then return true end
    end
    return false
end

function GetRagebotTarget()
    local myHRP = getHRP()
    if not myHRP then return nil end

    function validRage(plr)
        if not plr or not plr.Character then return false end
        if not isEnemyRageRivals(plr) then return false end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        local head = plr.Character:FindFirstChild("Head")
        if not hum or not head or hum.Health <= 0 then return false end
        if config.RagebotSkipFF ~= false and targetHasShield(plr.Character) then return false end
        return true
    end

    function ragerScore(plr)
        local char = plr.Character
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not hum or not root or not head then return 0 end
        local bonus = 0
        if hum.Health < 40 then bonus = bonus + 80 end
        if hum.Health < 20 then bonus = bonus + 60 end
        local ff = char:FindFirstChildOfClass("ForceField")
        if not ff then
            bonus = bonus + 40
            if _rageWeakUntil[plr] and tick() < _rageWeakUntil[plr] then
                bonus = bonus + 120
            end
        else
            _rageWeakUntil[plr] = tick() + 1.2
        end
        local velV = root.AssemblyLinearVelocity
        local vel = velV.Magnitude
        if vel > 80 then bonus = bonus + 50 end
        if vel > 150 then bonus = bonus + 70 end
        -- UE style: se esta TPeando HACIA MI → prioridad maxima
        local toMe = myHRP.Position - root.Position
        local dist = toMe.Magnitude
        local toward = 0
        if dist > 0.5 and vel > 35 then
            toward = toMe.Unit:Dot(velV.Unit)
            if toward > 0.25 then
                bonus = bonus + 180 + math.min(vel, 200)
            end
            if toward > 0.5 and vel > 70 then
                bonus = bonus + 250
            end
        end
        if dist < 40 and vel > 50 then bonus = bonus + 100 end
        if type(hasKnifeViewModel) == "function" and hasKnifeViewModel(plr) then
            bonus = bonus + 90
        end
        local d = (myHRP.Position - head.Position).Magnitude
        if d < 25 then bonus = bonus + 55 end
        if d < 12 then bonus = bonus + 40 end
        if config.RagePrioritizeRagers == false then bonus = bonus * 0.25 end
        if config.RageAutoPriority ~= false then
            if config.RagePriorityVoided ~= false and vel > 100 then bonus = bonus + 200 end
            if config.RagePriorityAttackers ~= false and toward and toward > 0.2 then bonus = bonus + 150 end
        end
        return bonus
    end

    if config.TargetLock and LockedTarget and LockedTarget.Parent and validRage(LockedTarget) then
        return LockedTarget
    end
    if RagebotTarget and RagebotTarget.Parent and validRage(RagebotTarget) then
        local head = RagebotTarget.Character:FindFirstChild("Head")
        if head and (config.RagebotInfiniteRange or config.RagebotRange == math.huge
            or (myHRP.Position - head.Position).Magnitude <= (config.RagebotRange or 1e12) * 1.5) then
            local curB = ragerScore(RagebotTarget)
            local better = false
            for _, plr in pairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr ~= RagebotTarget and validRage(plr) then
                    if ragerScore(plr) > curB + 80 then better = true break end
                end
            end
            if not better then return RagebotTarget end
        end
    end

    RagebotTarget = nil
    local best, bestScore = nil, math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        if not validRage(plr) then continue end
        local hum = plr.Character:FindFirstChildOfClass("Humanoid")
        local head = plr.Character:FindFirstChild("Head")
        local d = (myHRP.Position - head.Position).Magnitude
        if not config.RagebotInfiniteRange and config.RagebotRange ~= math.huge and d > (config.RagebotRange or 1e12) then continue end
        local score = (config.RagebotPriorityHP and (hum.Health + d * 0.1) or d) - ragerScore(plr)
        if score < bestScore then bestScore, best = score, plr end
    end
    if best then
        if RagebotTarget and RagebotTarget ~= best then
            local delay = tonumber(config.RageSwitchDelay) or 0.05
            if tick() - (LastRageSwitch or 0) < delay then
                if validRage(RagebotTarget) then return RagebotTarget end
            end
        end
        LastRageSwitch = tick()
        if config.TargetLock then LockedTarget = best end
        RagebotTarget = best
    end
    return best
end

function AutoEquipMelee()
    -- desactivado (pedido del user)
end
function DoAutoEquip() end
function StartAutoEquip() end
function StopAutoEquip() end

-- Fake Position (Sleepy-style): baja tu body en Y; el server/hitreg ve otra pos
local FakePosState = { original = nil, owned = false }

function clearFakePosition()
    FakePosState.original = nil
    FakePosState.owned = false
    pcall(function() getgenv().GodOriginalPos = nil end)
end

function ApplyFakePosition()
    if not config.FakePosition then return end
    local myHRP = getHRP and getHRP() or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if not myHRP then return end

    if config.FakePositionWalk then
        local orig = FakePosState.original or getgenv().GodOriginalPos
        if orig then
            myHRP.AssemblyLinearVelocity = Vector3.zero
            myHRP.AssemblyAngularVelocity = Vector3.zero
            myHRP.CFrame = orig
            clearFakePosition()
        end
        return
    end

    if not FakePosState.original then
        FakePosState.original = myHRP.CFrame
        pcall(function() getgenv().GodOriginalPos = myHRP.CFrame end)
    end

    local yOff = tonumber(config.FakePositionY) or 5
    local fakePos = FakePosState.original.Position - Vector3.new(0, yOff, 0)
    if config.FakePositionPanic then
        local minX = tonumber(config.PanicPositionXMin) or -8
        local maxX = tonumber(config.PanicPositionXMax) or 8
        if maxX < minX then minX, maxX = maxX, minX end
        fakePos = fakePos + Vector3.new(minX + math.random() * (maxX - minX), 0, 0)
    end
    if (myHRP.Position - fakePos).Magnitude > 0.5 then
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
    end
    local rot = FakePosState.original - FakePosState.original.Position
    myHRP.CFrame = CFrame.new(fakePos) * rot
    FakePosState.owned = true
end

function StartFakePosition()
    config.FakePosition = true
    FakePosState.owned = true
    if type(SafeDisconnect) == "function" then
        SafeDisconnect("FakePosition")
    elseif Connections and Connections.FakePosition then
        pcall(function() Connections.FakePosition:Disconnect() end)
        Connections.FakePosition = nil
    end
    Connections = Connections or {}
    Connections.FakePosition = RunService.Heartbeat:Connect(function()
        if config.FakePosition then
            pcall(ApplyFakePosition)
        end
    end)
end

function StopFakePosition()
    config.FakePosition = false
    if type(SafeDisconnect) == "function" then
        SafeDisconnect("FakePosition")
    elseif Connections and Connections.FakePosition then
        pcall(function() Connections.FakePosition:Disconnect() end)
        Connections.FakePosition = nil
    end
    local myHRP = getHRP and getHRP() or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if myHRP and FakePosState.original then
        myHRP.AssemblyLinearVelocity = Vector3.zero
        myHRP.AssemblyAngularVelocity = Vector3.zero
        myHRP.CFrame = FakePosState.original
    end
    clearFakePosition()
end
function AntiSafeZone()
    -- DESACTIVADO: ya no te manda al cielo
    return
end
function isSlideKeyDown()
    local key = tostring(config.SlideBoostKey or "C"):upper()
    -- C solo = C (NO Control)
    if key == "C" then
        return UserInputService:IsKeyDown(Enum.KeyCode.C)
    end
    if key == "LEFTCONTROL" or key == "LEFTCTRL" or key == "CTRL" then
        return UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
    end
    if key == "LEFTSHIFT" or key == "SHIFT" then
        return UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)
    end
    local ok, kc = pcall(function() return Enum.KeyCode[key] end)
    if ok and kc then return UserInputService:IsKeyDown(kc) end
    -- default seguro: solo C
    return UserInputService:IsKeyDown(Enum.KeyCode.C)
end

function getMoveDir()
    local hum = getHum()
    if hum and hum.MoveDirection.Magnitude > 0.05 then
        return hum.MoveDirection
    end
    -- fallback WASD por camara
    local cam = workspace.CurrentCamera
    if not cam then return Vector3.zero end
    local cf = cam.CFrame
    local f = Vector3.new(cf.LookVector.X, 0, cf.LookVector.Z)
    local r = Vector3.new(cf.RightVector.X, 0, cf.RightVector.Z)
    if f.Magnitude > 0 then f = f.Unit end
    if r.Magnitude > 0 then r = r.Unit end
    local dir = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + f end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - f end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + r end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - r end
    if dir.Magnitude > 0 then return dir.Unit end
    return Vector3.zero
end

function ApplySpeedState()
    local hum = getHum()
    if not hum then return end
    if config.SpeedEnabled then
        local spd = config.WalkSpeed or 50
        pcall(function() hum.WalkSpeed = spd end)
    else
        -- restaurar default (no dejar speed activo)
        local d = config.DefaultWalkSpeed or 16
        pcall(function()
            if hum.WalkSpeed ~= d then
                hum.WalkSpeed = d
            end
        end)
    end
end

function ApplyJumpState()
    local hum = getHum()
    if not hum then return end
    if config.JumpPowerEnabled then
        local jp = config.JumpPower or 100
        pcall(function()
            hum.UseJumpPower = true
            hum.JumpPower = jp
            if hum.JumpHeight ~= nil then
                hum.JumpHeight = math.clamp(jp / 20, 2, 500)
            end
        end)
    else
        local dj = config.DefaultJumpPower or 50
        local dh = config.DefaultJumpHeight or 7.2
        pcall(function()
            hum.UseJumpPower = true
            hum.JumpPower = dj
            if hum.JumpHeight ~= nil then hum.JumpHeight = dh end
        end)
    end
end


SlideBoostConn = SlideBoostConn or nil
function StartSlideBoostLoop()
    if SlideBoostConn then
        pcall(function() SlideBoostConn:Disconnect() end)
        SlideBoostConn = nil
    end
    -- Elisium method: MechanicsController.IsSliding + _sliding_velocity
    local mech = nil
    pcall(function()
        mech = require(LocalPlayer.PlayerScripts.Controllers.MechanicsController)
    end)
    SlideBoostConn = RunService.RenderStepped:Connect(function()
        if not config.SlideBoostEnabled then return end
        if not mech then
            pcall(function()
                mech = require(LocalPlayer.PlayerScripts.Controllers.MechanicsController)
            end)
        end
        if not mech then return end
        local sliding = false
        pcall(function() sliding = mech.IsSliding == true end)
        if not sliding then return end
        local speed = tonumber(config.SlideBoostSpeed)
        if not speed or speed <= 0 then
            -- fallback desde mult (compat viejo)
            speed = (tonumber(config.SlideBoostMult) or 2.5) * 40
        end
        speed = math.clamp(speed, 1, 200)
        pcall(function()
            local sv = mech._sliding_velocity
            if sv and sv.Velocity and sv.Velocity.Magnitude > 0.05 then
                sv.Velocity = sv.Velocity.Unit * speed
            end
        end)
    end)
end

function StopSlideBoostLoop()
    if SlideBoostConn then
        pcall(function() SlideBoostConn:Disconnect() end)
        SlideBoostConn = nil
    end
end


-- ==================== DISABLE ANIMATIONS (Elisium) ====================
getgenv()._ShakoDisableAnims = getgenv()._ShakoDisableAnims or { hooked = {}, ready = false }

local function daHas(typ)
    if not config.DisableAnimsEnabled then return false end
    local sel = config.DisableAnimsSelect
    if type(sel) ~= "table" then return false end
    for _, v in pairs(sel) do
        if tostring(v):lower() == tostring(typ):lower() then return true end
    end
    -- multi dropdown sometimes uses keys as values
    if sel[typ] == true then return true end
    return false
end

local function daHookAnim(vm)
    local S = getgenv()._ShakoDisableAnims
    local anim = nil
    pcall(function() anim = rawget(vm, "Animator") end)
    if not anim or S.hooked[anim] then return end
    S.hooked[anim] = true
    local orig = nil
    pcall(function()
        orig = rawget(anim, "PlayAnimation")
        if not orig then
            local mt = getmetatable(anim)
            if mt then orig = rawget(mt, "PlayAnimation") end
        end
    end)
    if type(orig) ~= "function" then return end
    pcall(function()
        anim.PlayAnimation = function(self, key, ...)
            if config.DisableAnimsEnabled then
                local k = tostring(key or ""):lower()
                if daHas("shoot") and k:find("shoot") then return end
                if daHas("attack") and k:find("attack") then return end
                if daHas("charge") and k:find("charge") then return end
                if daHas("equip") and k:find("equip") then return end
                if daHas("reload") and k:find("reload") then return end
                if daHas("throw") and k:find("throw") then return end
                if daHas("aim") and k:find("aim") then return end
                if daHas("sprint") and k:find("sprint") then return end
                if daHas("sliding") and (k:find("slide") or k:find("sliding")) then return end
                if daHas("inspect") and k:find("inspect") then return end
                if daHas("impulse") and k:find("impulse") then return end
            end
            return orig(self, key, ...)
        end
    end)
end

local function daApplyViewModel(c)
    if not config.DisableAnimsEnabled or not c then return end
    pcall(function()
        if daHas("bobbing") then
            if c._bobbing_value_spring then
                c._bobbing_value_spring.Value = Vector2.new(0, 0)
                c._bobbing_value_spring.Target = Vector2.new(0, 0)
            end
            if c._bobbing_speed_spring then
                c._bobbing_speed_spring.Value = 0
                c._bobbing_speed_spring.Target = 0
            end
            c._bobbing_tick = 0
        end
        if daHas("landing") then
            if c._landing_spring then c._landing_spring.Value = 0; c._landing_spring.Target = 0 end
            if c._jump_spring then c._jump_spring.Value = 0; c._jump_spring.Target = 0 end
        end
        if daHas("sway") then
            if c._sway_spring then c._sway_spring.Value = Vector2.new(0,0); c._sway_spring.Target = Vector2.new(0,0) end
            if c._tilt_spring then c._tilt_spring.Value = Vector2.new(0,0); c._tilt_spring.Target = Vector2.new(0,0) end
        end
        if daHas("equip") and c._equip_spring then
            c._equip_spring.Position = c._equip_spring.Target
            c._equip_spring.Velocity = 0
        end
    end)
end

task.spawn(function()
    task.wait(2)
    pcall(function()
        local path = LocalPlayer.PlayerScripts:FindFirstChild("Modules")
        path = path and path:FindFirstChild("ClientReplicatedClasses")
        path = path and path:FindFirstChild("ClientFighter")
        path = path and path:FindFirstChild("ClientItem")
        local vm_module = path and path:FindFirstChild("ClientViewModel")
        if not vm_module then
            -- try alternate path
            path = LocalPlayer.PlayerScripts:FindFirstChild("Controllers")
            return
        end
        local ClientViewModel = require(vm_module)
        if not ClientViewModel then return end
        local S = getgenv()._ShakoDisableAnims
        if S.ready then return end
        S.ready = true
        local oldUpdate = ClientViewModel.Update
        if type(oldUpdate) == "function" then
            ClientViewModel.Update = function(c, dt, movement_state, render_data)
                local isLocal = false
                pcall(function()
                    isLocal = c.ClientItem and c.ClientItem.ClientFighter and c.ClientItem.ClientFighter.IsLocalPlayer
                end)
                if isLocal then
                    daHookAnim(c)
                    daApplyViewModel(c)
                end
                return oldUpdate(c, dt, movement_state, render_data)
            end
        end
        print("[shako] disable animations hooked (Elisium)")
    end)
end)

function StartDisableAnims()
    config.DisableAnimsEnabled = true
    if not getgenv()._ShakoQuiet then Notify("Anims", "Disable ON") end
end
function StopDisableAnims()
    config.DisableAnimsEnabled = false
    if not getgenv()._ShakoQuiet then Notify("Anims", "Disable OFF") end
end


-- ==================== MANIPULATION (wall / height scan) ====================
local manipRay = RaycastParams.new()
manipRay.FilterType = Enum.RaycastFilterType.Exclude
local manipOffsets = {
    Vector3.new(0, 12, 0), Vector3.new(0, 16, 0), Vector3.new(0, 20, 0), Vector3.new(0, 24, 0),
    Vector3.new(0, 28, 0), Vector3.new(0, 32, 0), Vector3.new(0, 36, 0), Vector3.new(0, 40, 0),
}
local lastManipFire = 0

function manipGetClosest()
    local root = getHRP and getHRP() or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return nil, nil end
    local best, bestChar, bestD = nil, nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        if config.TeamCheck and IsSameTeam and IsSameTeam(p) then continue end
        local head = p.Character:FindFirstChild("Head")
        local hum = p.Character:FindFirstChildOfClass("Humanoid")
        if head and hum and hum.Health > 0 then
            local d = (root.Position - head.Position).Magnitude
            if d < bestD then bestD, best, bestChar = d, head, p.Character end
        end
    end
    return best, bestChar
end

function manipCalcPoint(origin, targetPos, targetChar)
    manipRay.FilterDescendantsInstances = {LocalPlayer.Character, targetChar}
    if not workspace:Raycast(origin, targetPos - origin, manipRay) then
        return origin, nil
    end
    for _, offset in ipairs(manipOffsets) do
        local scan = origin + offset
        if not workspace:Raycast(scan, targetPos - scan, manipRay) then
            return scan, offset.Y
        end
    end
    return nil, nil
end

function StartManipulation()
    SafeDisconnect("Manipulation")
    config.ManipulationEnabled = true
    Connections.Manipulation = RunService.Heartbeat:Connect(function()
        if not config.ManipulationEnabled then return end
        if config.RagebotEnabled then return end -- rage ya manipula
        if not CanDoDangerousMove or not CanDoDangerousMove() then return end
        local rate = tonumber(config.ManipulationRate) or 0.05
        if tick() - lastManipFire < rate then return end

        if not modulesOK then
            pcall(function()
                if loadRivalsModules then loadRivalsModules() end
            end)
        end
        local u = util
        local e = enum or enums
        local fc = FighterController
        if not u or not e or not fc or not fc.LocalFighter then return end
        local item = fc.LocalFighter.EquippedItem
        if not item then return end
        local targetPart, targetChar = manipGetClosest()
        if not targetPart or not targetChar then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local manip, height = manipCalcPoint(cam.CFrame.Position, targetPart.Position, targetChar)
        if not manip then return end
        local shootPos = (height == nil and manip) or cam.CFrame.Position
        local look = CFrame.lookAt(shootPos, targetPart.Position)
        local rx, ry, rz = look:ToOrientation()
        local cameradata = {}
        local okBuild = pcall(function()
            cameradata[utf8.char(1)] = {
                [utf8.char(0)] = u:EncodeCFrame(CFrame.new(shootPos.X, shootPos.Y + (height or 0), shootPos.Z) * CFrame.Angles(rx, ry, rz)),
                [utf8.char(1)] = height and u:EncodeCFrame(CFrame.new(targetPart.Position) * CFrame.Angles(rx, ry, rz))
                    or u:EncodeCFrame(CFrame.new(shootPos.X, shootPos.Y + (height or 0), shootPos.Z) * CFrame.Angles(rx, ry, rz)),
                [utf8.char(2)] = targetPart,
                [utf8.char(3)] = u:EncodeCFrame(targetPart.CFrame:ToObjectSpace(CFrame.new(targetPart.Position))),
            }
        end)
        if not okBuild then return end
        local oid
        pcall(function() oid = item:Get("ObjectID") end)
        if not oid then return end
        local rem = RS and RS.Remotes and RS.Remotes.Replication and RS.Remotes.Replication.Fighter and RS.Remotes.Replication.Fighter.UseItem
        if not rem then return end
        lastManipFire = tick()
        pcall(function()
            rem:FireServer(oid, e:ToEnum("StartShooting"), cameradata, nil)
        end)
    end)
end

function StopManipulation()
    SafeDisconnect("Manipulation")
    config.ManipulationEnabled = false
end



function UpdateMovement()

    local hum, hrp = getHum(), getHRP()
    if not hum or not hrp then return end

    -- JUMP: solo si toggle ON; si OFF restaura
    if config.JumpPowerEnabled then
        ApplyJumpState()
    end

    -- SPEED: solo velocity/walk si toggle ON
    if config.SpeedEnabled then
        local spd = config.WalkSpeed or 50
        pcall(function() hum.WalkSpeed = spd end)
        if config.SpeedVelocityMode ~= false then
            local dir = getMoveDir()
            if dir.Magnitude > 0.05 then
                local vel = hrp.AssemblyLinearVelocity
                local target = dir * spd
                hrp.AssemblyLinearVelocity = Vector3.new(target.X, vel.Y, target.Z)
            end
        end
    end

    -- Slide boost tiene su propio Heartbeat (StartSlideBoostLoop)

    if config.AntiFling and not (config.SlideBoostEnabled and isSlideKeyDown()) then
        hrp.AssemblyAngularVelocity = Vector3.zero
        local maxV = (config.SpeedEnabled and (config.WalkSpeed or 50) * 4) or 220
        if hrp.AssemblyLinearVelocity.Magnitude > math.max(maxV, 220) then
            hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity.Unit * math.max(maxV, 220)
        end
    end
    if config.DesyncJitter and not config.Enabled and not IsAntiUnnamedActive() and not config.VoidSpamEnabled and not config.RagebotEnabled then
        local p = config.DesyncJitterPower or 12
        hrp.CFrame = hrp.CFrame * CFrame.new((math.random() - 0.5) * p * 0.05, (math.random() - 0.5) * p * 0.02, (math.random() - 0.5) * p * 0.05)
    end
    AutoEquipMelee()
    ApplyCharVisuals()
end

local StartRagebot, StopRagebot, StartAutoClick, StopAutoClick
local StartNoRecoil, StopNoRecoil, StartAntiUnnamed, StopAntiUnnamed
local ArmAntiUnnamedOnSpawn, StartAUWatcher
local StartFly, StopFly, StartNoclip, StopNoclip, StartAntiAim, StopAntiAim
local StartMainLoop, StartStickRender, StartESP, StopESP, StartAimbot, StopAimbot

StartNoRecoil = function()
    SafeDisconnect("NoRecoil")
    -- solo ItemLibrary, CERO camara
    if config.RapidFire then
        ApplyItemLibraryGuns(true)
    else
        local Items = getItems()
        if Items then
            for name, data in pairs(Items) do
                if typeof(data) == "table" and not gunExceptions[name] then
                    ilSet(name, data, "ShootSpread", 0)
                    ilSet(name, data, "ShootRecoil", 0)
                    ilSet(name, data, "Recoil", 0)
                    ilSet(name, data, "Spread", 0)
                end
            end
        end
    end
end
StopNoRecoil = function()
    SafeDisconnect("NoRecoil")
    if not config.RapidFire then
        local Items = getItems()
        if Items then
            for name, data in pairs(Items) do
                if typeof(data) == "table" then ilRestore(name, data) end
            end
            if config.FastMelee then ApplyItemLibraryMelee(true) end
        end
    end
end

function GetAimbotTarget()
    local closest, shortest = nil, config.AimbotFOV
    local mousePos = UserInputService:GetMouseLocation()
    local partName = config.AimbotPart or "Head"
    local function resolveAimPart(char)
        if not char then return nil end
        local want = tostring(partName or "Head")
        if want == "Head" or want == "HitboxHead" then
            local hb = char:FindFirstChild("HitboxHead") or char:FindFirstChild("HitboxHeadSmall")
            if hb then return hb end
            if want == "HitboxHead" then return char:FindFirstChild("Head") end
        end
        if want == "Torso" then
            return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        end
        return char:FindFirstChild(want)
            or char:FindFirstChild("Head")
            or char:FindFirstChild("HumanoidRootPart")
    end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        if config.AimbotTeamCheck and IsSameTeam(plr) then continue end
        local char = plr.Character
        if not char then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local part = resolveAimPart(char)
        if not hum or not part or hum.Health <= 0 then continue end
        local sp, on = Camera:WorldToViewportPoint(part.Position)
        if not on or sp.Z < 0 then continue end
        local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
        if d < shortest then shortest, closest = d, part end
    end
    return closest
end
-- Aimbot (logica simple: hold RMB + CFrame.lookAt, con FOV/team/wall opcionales)
local aimbotHolding = false

function isEnemyForAimbot(plr)
    if plr == LocalPlayer then return false end
    if not config.AimbotTeamCheck then return true end
    return IsEnemy(plr)
end

function aimbotWallClear(fromPos, toPos, targetChar)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    if targetChar then table.insert(filter, targetChar) end
    local vm = workspace:FindFirstChild("ViewModels")
    if vm then table.insert(filter, vm) end
    params.FilterDescendantsInstances = filter
    params.IgnoreWater = true
    local delta = toPos - fromPos
    local dist = delta.Magnitude
    if dist < 0.5 then return true end
    local res = workspace:Raycast(fromPos, delta.Unit * dist, params)
    if not res then return true end
    if targetChar and res.Instance and res.Instance:IsDescendantOf(targetChar) then return true end
    return false
end

function AimbotIsEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    if not plr.Character then return false end

    local tc = config.AimbotTeamCheck
    if tc == nil then tc = true end
    -- tambien respetar TeamCheck global si está ON
    if config.TeamCheck == true then tc = true end
    if tc then
        if StrongIsTeammate and StrongIsTeammate(plr) then return false end
        if IsSameTeam and IsSameTeam(plr) then return false end
        local a, b = LocalPlayer.Team, plr.Team
        if a ~= nil and b ~= nil and a == b then return false end
        local ac, bc = LocalPlayer.TeamColor, plr.TeamColor
        if ac and bc and ac == bc then
            local n = tostring(ac)
            if n ~= "White" and n ~= "Medium stone grey" then return false end
        end
    end
    return true
end

function GetAimbotTargetRivals()
    local cam = workspace.CurrentCamera
    if not cam then return nil end
    local partName = config.AimbotPart or "Head"
    local fov = tonumber(config.AimbotFOV) or 400
    local center = UserInputService:GetMouseLocation()
    if not center or center.X == 0 then
        center = Vector2.new(cam.ViewportSize.X * 0.5, cam.ViewportSize.Y * 0.5)
    end
    local bestPart, bestScore = nil, math.huge
    local camPos = cam.CFrame.Position

    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        -- team check fuerte (siempre que AimbotTeamCheck no sea false)
        if not AimbotIsEnemy(plr) then continue end

        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild(partName) or char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not head or not hum or hum.Health <= 0 then continue end

        local sp, onScreen = cam:WorldToViewportPoint(head.Position)
        if sp.Z <= 0 then continue end

        local screenDist = (Vector2.new(sp.X, sp.Y) - Vector2.new(center.X, center.Y)).Magnitude
        if screenDist > fov then continue end

        if config.AimbotWallCheck or config.AimbotVisibleCheck then
            if not aimbotWallClear(camPos, head.Position, char) then continue end
        end

        local score = screenDist
        if score < bestScore then
            bestScore = score
            bestPart = head
        end
    end
    return bestPart
end

StartAimbot = function()
    SafeDisconnect("Aimbot")
    SafeDisconnect("AimbotInput")
    SafeDisconnect("AimbotInputEnd")
    pcall(function() RunService:UnbindFromRenderStep("__as_aimbot") end)
    pcall(function() RunService:UnbindFromRenderStep("__as_aimbot2") end)

    -- Estado propio del aimbot (NO depende de GetState de la lib)
    local st = getgenv()._ShakoAimKB or { held = false, toggled = false }
    getgenv()._ShakoAimKB = st
    st.held = false
    -- no resetear toggled al reiniciar si ya estaba

    local function getKP()
        local opts = Library and Library.Options
        return opts and (opts.AimbotKey or opts["AimbotKey"]) or nil
    end

    local function normKey(v)
        if v == nil then return nil end
        if typeof(v) == "EnumItem" then return v end
        if type(v) == "string" then
            local s = v:gsub("%s+", "")
            if s == "" or s == "None" or s == "..." or s == "nil" then return nil end
            local low = s:lower()
            if low == "mb2" or low == "mousebutton2" or low == "mouse2" or low == "rightclick" then
                return Enum.UserInputType.MouseButton2
            end
            if low == "mb1" or low == "mousebutton1" or low == "mouse1" or low == "leftclick" then
                return Enum.UserInputType.MouseButton1
            end
            if low == "mb3" or low == "mousebutton3" then
                return Enum.UserInputType.MouseButton3
            end
            local ok, e = pcall(function() return Enum.KeyCode[s] end)
            if ok and e then return e end
            ok, e = pcall(function() return Enum.UserInputType[s] end)
            if ok and e then return e end
        end
        return nil
    end

    local function getKey()
        local kp = getKP()
        if kp then
            for _, field in ipairs({ "Value", "Key", "KeyCode", "Input", "Bind" }) do
                local k = normKey(rawget and rawget(kp, field) or kp[field])
                if k then return k end
            end
            -- a veces el valor esta en tostring del picker
            pcall(function()
                if type(kp.ToString) == "function" then
                    local k = normKey(kp:ToString())
                    if k then return k end
                end
            end)
        end
        -- DEFAULT: click derecho (lo que el user usa)
        return Enum.UserInputType.MouseButton2
    end

    local function getMode()
        -- 1) Dropdown del menu (fiable)
        local cfg = tostring(config.AimbotKeyMode or ""):lower()
        if cfg:find("always") then return "always" end
        if cfg:find("toggle") then return "toggle" end
        if cfg:find("hold") then return "hold" end
        -- 2) KeyPicker Mode
        local kp = getKP()
        local m = kp and (kp.Mode or kp.mode or kp.Type)
        if type(m) == "string" and m ~= "" then
            m = string.lower(m)
            if string.find(m, "always", 1, true) then return "always" end
            if string.find(m, "hold", 1, true) then return "hold" end
            if string.find(m, "toggle", 1, true) then return "toggle" end
        end
        return "hold"
    end

    local function physDown(key)
        if not key then
            key = Enum.UserInputType.MouseButton2
        end
        local ok, down = pcall(function()
            if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
                return UserInputService:IsKeyDown(key)
            end
            -- mouse buttons
            if key == Enum.UserInputType.MouseButton1
                or key == Enum.UserInputType.MouseButton2
                or key == Enum.UserInputType.MouseButton3 then
                return UserInputService:IsMouseButtonPressed(key)
            end
            if typeof(key) == "EnumItem" and key.EnumType == Enum.UserInputType then
                return UserInputService:IsMouseButtonPressed(key)
            end
            return false
        end)
        return ok and down == true
    end

    local function matches(input, key)
        if not key or not input then return false end
        if typeof(key) == "EnumItem" and key.EnumType == Enum.KeyCode then
            return input.KeyCode == key
        end
        if typeof(key) == "EnumItem" and key.EnumType == Enum.UserInputType then
            return input.UserInputType == key
        end
        return false
    end

    local function isAimActive()
        if not config.AimbotEnabled then return false end
        local mode = getMode()
        local key = getKey() -- siempre al menos MB2

        if mode == "always" then
            return true
        end

        if mode == "toggle" then
            return st.toggled == true
        end

        -- HOLD: tecla fisica cada frame (lo mas fiable en Real Executor)
        if st.held then return true end
        if physDown(key) then return true end
        return false
    end

    Connections.AimbotInput = UserInputService.InputBegan:Connect(function(input, gpe)
        local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.MouseButton2
            or input.UserInputType == Enum.UserInputType.MouseButton3
        if gpe and not isMouse then return end
        local key = getKey()
        local mode = getMode()
        local hit = matches(input, key)
            or (key == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2)
        if not hit then return end
        if mode == "hold" then
            st.held = true
        elseif mode == "toggle" then
            st.toggled = not (st.toggled == true)
            Notify("Aimbot", st.toggled and "Toggle ON" or "Toggle OFF")
        end
        -- Always no usa tecla
    end)

    Connections.AimbotInputEnd = UserInputService.InputEnded:Connect(function(input)
        if getMode() ~= "hold" then return end
        local key = getKey()
        if matches(input, key) or (key == Enum.UserInputType.MouseButton2 and input.UserInputType == Enum.UserInputType.MouseButton2) then
            st.held = false
        end
    end)

    local function aimStep()
        if not config.AimbotEnabled then return end
        if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end
        if not isAimActive() then return end

        local cam = workspace.CurrentCamera
        if not cam then return end

        local target = GetAimbotTargetRivals and GetAimbotTargetRivals()
        if not target or not target.Parent then return end

        local aimPos = target.Position
        local screenPos, onScreen = cam:WorldToViewportPoint(aimPos)
        if not onScreen and screenPos.Z < 0 then return end

        local movedMouse = false
        pcall(function()
            local mouse = UserInputService:GetMouseLocation()
            local dx = screenPos.X - mouse.X
            local dy = screenPos.Y - mouse.Y
            local smooth = tonumber(config.AimbotSmooth) or 0.9
            local sens = math.clamp(smooth, 0.2, 1)
            dx, dy = dx * sens, dy * sens
            if math.abs(dx) < 0.5 and math.abs(dy) < 0.5 then return end
            if mousemoverel then
                mousemoverel(dx, dy)
                movedMouse = true
            elseif Input and Input.MouseMove then
                Input.MouseMove(dx, dy)
                movedMouse = true
            end
        end)

        if not movedMouse then
            local pos = cam.CFrame.Position
            cam.CFrame = CFrame.new(pos, aimPos)
        end
    end

    local aimFrame = 0
    Connections.Aimbot = RunService.RenderStepped:Connect(function()
        aimFrame += 1
        if aimFrame % 3 ~= 0 then return end
        pcall(aimStep)
    end)
    Notify("Aimbot", "ON · Hold = mantener tecla")
end

StopAimbot = function()
    SafeDisconnect("Aimbot")
    SafeDisconnect("AimbotInput")
    SafeDisconnect("AimbotInputEnd")
    pcall(function() RunService:UnbindFromRenderStep("__as_aimbot") end)
    pcall(function() RunService:UnbindFromRenderStep("__as_aimbot2") end)
    aimbotHolding = false
end


-- Harion-style weapon slot
-- Weapon slots sin yield en el Heartbeat del rage
local _rageSlot = 1 -- 1 primary, 2 secondary, 3 melee
local _rageLastSwap = 0
local _rageSwapBusy = false
local _rageEmptyStreak = 0 -- cuantas veces seguidas encontramos arma vacia
local _rageReloadUntil = 0 -- hasta cuando no swapear (reload en curso)
local _rageShieldWaitUntil = 0

function ragePressSlot(slot)
    slot = tonumber(slot) or 1
    local keys = {[1]=Enum.KeyCode.One,[2]=Enum.KeyCode.Two,[3]=Enum.KeyCode.Three}
    local k = keys[slot]
    if not k then return end
    _rageSlot = slot
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, k, false, game)
        task.defer(function()
            pcall(function() vim:SendKeyEvent(false, k, false, game) end)
        end)
    end)
end

function ragePressReload()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        vim:SendKeyEvent(true, Enum.KeyCode.R, false, game)
        task.defer(function()
            pcall(function() vim:SendKeyEvent(false, Enum.KeyCode.R, false, game) end)
        end)
    end)
end

function rageEquipPreferred()
    if _rageSwapBusy then return end
    if tick() < _rageReloadUntil then return end
    local mode = tostring(config.RageAttackMode or "gun")
    local pref = tostring(config.RagePreferredWeapon or "primary"):lower()
    -- solo melee si el usuario lo pidió explícitamente
    if (mode == "knife" or mode == "melee") and (pref == "melee" or pref == "knife") then
        if _rageSlot ~= 3 then ragePressSlot(3) end
    elseif pref == "secondary" then
        if _rageSlot ~= 2 then ragePressSlot(2) end
    else
        -- Primary / gun default — NUNCA puños
        if _rageSlot ~= 1 then ragePressSlot(1) end
    end
end

function rageReadAmmo(item)
    if not item then return nil end
    local ammo = nil
    pcall(function()
        if item.Get then
            ammo = item:Get("Ammo")
            if ammo == nil then ammo = item:Get("CurrentAmmo") end
            if ammo == nil then ammo = item:Get("Bullets") end
            if ammo == nil then ammo = item:Get("AmmoInClip") end
            if ammo == nil then ammo = item:Get("Clip") end
        end
    end)
    if type(ammo) ~= "number" then
        pcall(function()
            if item.Ammo ~= nil then ammo = item.Ammo end
        end)
    end
    return tonumber(ammo)
end

-- Primary → Secondary UNA vez; si las 2 vacias → RELOAD (no loop de swap)
function rageHandleEmptyAmmo(item)
    if not config.RageSwapWhenEmpty then return false end
    -- durante reload: bloquear fire, no swapear
    if tick() < _rageReloadUntil then
        return true
    end
    if _rageSwapBusy then return true end

    local ammo = rageReadAmmo(item)
    if ammo == nil then return false end
    if ammo > 0 then
        _rageEmptyStreak = 0
        return false
    end

    -- sin balas: no disparar
    if tick() - _rageLastSwap < 0.55 then
        return true
    end

    _rageEmptyStreak = (_rageEmptyStreak or 0) + 1

    -- 2+ vacios seguidos = las dos armas secas → recargar y PARAR swap
    if _rageEmptyStreak >= 2 then
        _rageLastSwap = tick()
        _rageReloadUntil = tick() + 2.4
        _rageSwapBusy = true
        _rageEmptyStreak = 0
        ragePressReload()
        -- segundo R por si el primero no pego
        task.delay(0.35, function()
            if tick() < _rageReloadUntil then ragePressReload() end
        end)
        task.delay(2.5, function()
            _rageSwapBusy = false
        end)
        return true
    end

    -- primer vacio: un solo cambio Primary <-> Secondary
    _rageSwapBusy = true
    _rageLastSwap = tick()
    local cur = _rageSlot or 1
    local nextSlot = (cur == 1) and 2 or 1
    if cur == 3 then nextSlot = 1 end
    ragePressSlot(nextSlot)
    task.delay(0.4, function()
        _rageSwapBusy = false
    end)
    return true
end


-- ==================== BODY TWIST (OPCIONAL — Anti Aim usa Harion remote, NO esto) ====================
-- Deforma Motor6D C0 para que te vean "roto" / torcido
getgenv()._ShakoTwist = getgenv()._ShakoTwist or { orig = {}, conn = nil, t = 0 }

local TWIST_JOINTS_R15 = {
    "Root", "Waist", "Neck",
    "LeftShoulder", "RightShoulder", "LeftElbow", "RightElbow",
    "LeftHip", "RightHip", "LeftKnee", "RightKnee",
}
local TWIST_JOINTS_R6 = {
    "RootJoint", "Neck",
    "Left Shoulder", "Right Shoulder", "Left Hip", "Right Hip",
}

function twistFindMotors(char)
    local list = {}
    if not char then return list end
    for _, d in ipairs(char:GetDescendants()) do
        if d:IsA("Motor6D") and d.Part0 and d.Part1 then
            table.insert(list, d)
        end
    end
    return list
end

function twistSaveOrig(motors)
    local S = getgenv()._ShakoTwist
    for _, m in ipairs(motors) do
        if not S.orig[m] then
            S.orig[m] = m.C0
        end
    end
end

function twistRestore()
    local S = getgenv()._ShakoTwist
    for m, c0 in pairs(S.orig) do
        pcall(function()
            if m and m.Parent then m.C0 = c0 end
        end)
    end
end

function twistOffsets(mode, power, t, name)
    power = power or 1
    local p = math.clamp(power, 0.1, 3)
    local n = string.lower(tostring(name or ""))
    local rx, ry, rz = 0, 0, 0
    if mode == "Lay" then
        -- casi tirado
        if n:find("root") or n:find("waist") then
            rx, rz = math.rad(70) * p, math.rad(25) * p
        elseif n:find("neck") then
            rx = math.rad(-40) * p
        elseif n:find("hip") then
            rx = math.rad(50) * p
        else
            rz = math.rad(30) * p * (n:find("left") and -1 or 1)
        end
    elseif mode == "Twist" then
        local spin = t * (tonumber(config.BodyTwistSpeed) or 8)
        if n:find("root") or n:find("waist") then
            ry = math.rad(45) * p * math.sin(spin * 0.7)
            rz = math.rad(35) * p * math.sin(spin)
        elseif n:find("neck") then
            ry = math.rad(60) * p * math.sin(spin * 1.3)
            rx = math.rad(25) * p * math.cos(spin)
        elseif n:find("shoulder") then
            local s = n:find("left") and -1 or 1
            rz = math.rad(80) * p * s
            rx = math.rad(40) * p * math.sin(spin + s)
        elseif n:find("elbow") then
            rx = math.rad(-70) * p
        elseif n:find("hip") then
            local s = n:find("left") and -1 or 1
            rz = math.rad(55) * p * s
            rx = math.rad(30) * p
        elseif n:find("knee") then
            rx = math.rad(90) * p
        else
            ry = math.rad(20) * p * math.sin(spin)
        end
    elseif mode == "Random" then
        local seed = (t * 10 + #n) % 100
        rx = math.rad((math.noise(seed, 1, 0) * 120) * p)
        ry = math.rad((math.noise(seed, 2, 0) * 120) * p)
        rz = math.rad((math.noise(seed, 3, 0) * 120) * p)
    elseif mode == "Rager" or mode == "Broken" or mode == "Ultra" then
        -- estilo rager HVH: cuerpo invertido / limbs doblados (como la foto)
        if n:find("root") then
            -- voltear el torso casi de cabeza
            rx, ry, rz = math.rad(175) * p, math.rad(90) * p, math.rad(60) * p
        elseif n:find("waist") then
            rx, ry, rz = math.rad(120) * p, math.rad(-70) * p, math.rad(90) * p
        elseif n:find("neck") then
            rx, ry, rz = math.rad(-160) * p, math.rad(120) * p, math.rad(70) * p
        elseif n:find("leftshoulder") or n == "left shoulder" then
            rx, ry, rz = math.rad(110) * p, math.rad(80) * p, math.rad(170) * p
        elseif n:find("rightshoulder") or n == "right shoulder" then
            rx, ry, rz = math.rad(-50) * p, math.rad(-60) * p, math.rad(-150) * p
        elseif n:find("leftelbow") then
            rx, rz = math.rad(150) * p, math.rad(40) * p
        elseif n:find("rightelbow") then
            rx, rz = math.rad(-140) * p, math.rad(-35) * p
        elseif n:find("lefthip") or n == "left hip" then
            rx, ry, rz = math.rad(-100) * p, math.rad(30) * p, math.rad(90) * p
        elseif n:find("righthip") or n == "right hip" then
            rx, ry, rz = math.rad(95) * p, math.rad(-25) * p, math.rad(-100) * p
        elseif n:find("leftknee") or (n:find("knee") and n:find("left")) then
            rx = math.rad(160) * p
        elseif n:find("rightknee") or (n:find("knee") and n:find("right")) then
            rx = math.rad(-155) * p
        elseif n:find("ankle") or n:find("wrist") or n:find("hand") or n:find("foot") then
            rx, rz = math.rad(60) * p, math.rad(40) * p
        else
            local h = 0
            for i = 1, #n do h = h + string.byte(n, i) end
            rx = math.rad((h % 140) - 70) * p
            ry = math.rad((h % 100) - 50) * p
            rz = math.rad((h % 160) - 80) * p
        end
    else -- fallback Broken-like
        if n:find("root") then
            rx, ry, rz = math.rad(175) * p, math.rad(90) * p, math.rad(60) * p
        elseif n:find("waist") then
            rx, rz = math.rad(90) * p, math.rad(55) * p
        elseif n:find("neck") then
            rx, ry = math.rad(-120) * p, math.rad(80) * p
        else
            local h = 0
            for i = 1, #n do h = h + string.byte(n, i) end
            rx = math.rad((h % 140) - 70) * p
            ry = math.rad((h % 100) - 50) * p
            rz = math.rad((h % 160) - 80) * p
        end
    end
    return CFrame.Angles(rx, ry, rz)
end

function StartBodyTwist()
    config.BodyTwist = true
    local S = getgenv()._ShakoTwist
    if S.conn then pcall(function() S.conn:Disconnect() end) S.conn = nil end
    if S.bind then pcall(function() RunService:UnbindFromRenderStep(S.bind) end) S.bind = nil end
    S.t = 0
    S.orig = S.orig or {}

    -- NO desactivar Animate ni matar tracks: eso te deja TIESO para otros jugadores
    -- Body twist solo mueve joints suaves; emotes necesitan Animate ON

    local function applyPose()
        -- Anti Aim YA NO usa Motor6D (Harion remote only)
        -- NUNCA forzar joints mientras se desliza (rompe el body)
        if getgenv()._ShakoSlideGuard and getgenv()._ShakoSlideGuard.sliding then return end
        if type(IsPlayerSliding) == "function" then
            local ok, sliding = pcall(IsPlayerSliding)
            if ok and sliding then return end
        end
        if not (config.BodyTwist or (config.BodyTwistWithRage and config.RagebotEnabled)) then return end
        local char = LocalPlayer.Character
        if not char then return end
        local motors = twistFindMotors(char)
        if #motors == 0 then return end
        twistSaveOrig(motors)
        S.t = (S.t or 0) + 0.016

        local mode = tostring(config.BodyTwistMode or "Rager")
        local power = tonumber(config.BodyTwistPower) or 1.8

        -- Cada Motor6D del body (cabeza, torso, brazos, piernas)
        for _, m in ipairs(motors) do
            local base = S.orig[m]
            if base then
                local off = twistOffsets(mode, power, S.t, m.Name)
                pcall(function() m.C0 = base * off end)
            end
        end

        -- Extra fold en partes visibles (no solo joints)
        pcall(function()
            local root = char:FindFirstChild("HumanoidRootPart")
            local upper = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
            local head = char:FindFirstChild("Head")
            local low = char:FindFirstChild("LowerTorso")
            -- Neck ultra
            for _, m in ipairs(motors) do
                local nm = string.lower(m.Name)
                if nm == "neck" and S.orig[m] then
                    m.C0 = S.orig[m] * CFrame.Angles(math.rad(-170) * power, math.rad(150) * power, math.rad(90) * power)
                elseif nm:find("waist") and S.orig[m] then
                    m.C0 = S.orig[m] * CFrame.Angles(math.rad(130) * power, math.rad(-80) * power, math.rad(100) * power)
                elseif (nm:find("shoulder") or nm:find("elbow")) and S.orig[m] then
                    local s = nm:find("left") and -1 or 1
                    m.C0 = S.orig[m] * CFrame.Angles(math.rad(100) * power, math.rad(70) * s * power, math.rad(160) * s * power)
                end
            end
        end)

        -- si hay emote activo, no tocar joints (dejar que se vea el emote)
        if config.EmoteEnabled and getgenv()._ShakoEmote and getgenv()._ShakoEmote.track then
            return
        end
    end

    -- RenderStep al FINAL para pisar al Animate del juego
    S.bind = "ShakoBodyAA_" .. tostring(math.random(1000, 9999))
    pcall(function()
        RunService:BindToRenderStep(S.bind, Enum.RenderPriority.Character.Value + 50, applyPose)
    end)
    S.conn = RunService.Heartbeat:Connect(applyPose)

    if not getgenv()._ShakoQuiet then
        Notify("Twist", "BODY AA · mueve todo el personaje")
    end
end

function StopBodyTwist()
    config.BodyTwist = false
    local S = getgenv()._ShakoTwist
    if S.conn then pcall(function() S.conn:Disconnect() end) S.conn = nil end
    if S.bind then pcall(function() RunService:UnbindFromRenderStep(S.bind) end) S.bind = nil end
    twistRestore()
    pcall(function()
        local char = LocalPlayer.Character
        local anim = char and char:FindFirstChild("Animate")
        if anim and anim:IsA("LocalScript") then
            anim.Enabled = (S.animateWas ~= false)
        end
    end)
    S.orig = {}
    if not getgenv()._ShakoQuiet and not (getgenv()._ShakoBootAt and tick() - getgenv()._ShakoBootAt < 8) then
        Notify("Twist", "OFF")
    end
end

-- restore joints on respawn
pcall(function()
    LocalPlayer.CharacterAdded:Connect(function()
        local S = getgenv()._ShakoTwist
        S.orig = {}
        if config.BodyTwist or (config.BodyTwistWithRage and config.RagebotEnabled) then
            task.delay(0.5, function()
                if config.BodyTwist or (config.BodyTwistWithRage and config.RagebotEnabled) then
                    StartBodyTwist()
                end
            end)
        end
    end)
end)

-- ==================== AXIS RAGEBOT (reemplaza el rage viejo) ====================
AxisRage = {
    active = false,
    home = nil,
    voiding = false,
    gen = 0,
    lastFire = 0,
    lastVsPos = nil,
    target = nil,
    reloadVoidUntil = 0,
    emptyStreak = 0,
}

function axisClamp(n, a, b, d)
    n = tonumber(n)
    if not n then return d end
    if n < a then return a end
    if n > b then return b end
    return n
end

function axisGetRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
end

function axisLocalFighter()
    return FighterController and FighterController.LocalFighter
end

function axisEquipped()
    local f = axisLocalFighter()
    return f and f.EquippedItem
end

function axisIsEnemy(plr)
    if not plr or plr == LocalPlayer then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end

    -- Team Check rage: NUNCA pegar al team
    if config.RagebotTeamCheck ~= false then
        if char:FindFirstChild("TeammateLabel") then return false end
        if IsSameTeam and IsSameTeam(plr) then return false end
        if plr.Team and LocalPlayer.Team and plr.Team == LocalPlayer.Team and LocalPlayer.Team.Name ~= "FFA" then
            return false
        end
        if getPlayerTeamId then
            local a, b = getPlayerTeamId(LocalPlayer), getPlayerTeamId(plr)
            if a ~= nil and b ~= nil and tostring(a) == tostring(b) then
                local s = tostring(a)
                if s ~= "0" and s ~= "" and s ~= "FFA" and s ~= "None" then
                    return false
                end
            end
        end
    end
    return true
end

function axisHasShield(char)
    if not char then return false end
    if char:FindFirstChildOfClass("ForceField") then return true end
    return false
end

function axisPickTarget()
    local myRoot = axisGetRoot(LocalPlayer.Character)
    if not myRoot then return nil, nil, nil end
    local mode = config.RageTargetMode or "Closest"
    local best, bestPart, bestScore = nil, nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if axisIsEnemy(plr) then
            local char = plr.Character
            local head = char and (char:FindFirstChild("HitboxHead") or char:FindFirstChild("Head"))
            local root = axisGetRoot(char)
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if head and root and hum then
                if not (config.RagebotSkipFF ~= false and axisHasShield(char)) then
                    local dist = (myRoot.Position - root.Position).Magnitude
                    local score = (mode == "Lowest Health") and hum.Health or dist
                    if score < bestScore then
                        bestScore = score
                        best = plr
                        bestPart = head
                    end
                end
            end
        end
    end
    return best, bestPart, best and axisGetRoot(best.Character)
end

function axisMeowVoid(root)
    if not root then return end
    -- guardar visual
    if not AxisRage.clientCF then AxisRage.clientCF = root.CFrame end
    local visualCF = AxisRage.home or AxisRage.clientCF or root.CFrame
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Physics) end) end
    local iters = math.floor(axisClamp(config.RageVoidIterations, 1, 500, 120))
    local minD = axisClamp(config.RageVoidMinDist, 1, 5e5, 1)
    local maxD = math.max(axisClamp(config.RageVoidRange, 1, 5e5, 50000), minD)
    for _ = 1, iters do
        local base = AxisRage.lastVsPos or root.Position
        local d = minD + math.random() * (maxD - minD)
        local sx = math.random() < 0.5 and 1 or -1
        local sy = math.random() < 0.5 and 1 or -1
        local sz = math.random() < 0.5 and 1 or -1
        local p = Vector3.new(base.X + sx * d * math.random(), base.Y + sy * d * math.random(), base.Z + sz * d * math.random())
        if math.abs(p.X) > 5e6 or math.abs(p.Y) > 5e6 or math.abs(p.Z) > 5e6 then
            p = Vector3.new(math.random(-1e6, 1e6), math.random(-1e6, 1e6), math.random(-1e6, 1e6))
        end
        root.CFrame = CFrame.new(p)
        AxisRage.lastVsPos = p
    end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
    AxisRage.voiding = true
    -- desync: volver a donde TÚ estás
    pcall(function()
        root.CFrame = visualCF
        root.AssemblyLinearVelocity = Vector3.zero
    end)
end

function axisTeleportTo(targetRoot, targetHead)
    local myRoot = axisGetRoot(LocalPlayer.Character)
    if not myRoot or not targetHead then return false end

    -- ancla visual (donde te quedas QUIETO)
    if not AxisRage.clientCF then
        AxisRage.clientCF = AxisRage.home or myRoot.CFrame
    end

    local offY = axisClamp(config.TeleportOffsetY, -5, 50, 1)
    local dist = axisClamp(config.RageDistance, 0, 15, 2.5)
    local look = targetHead.Position
    local behind = (targetRoot and targetRoot.CFrame.LookVector) or Vector3.new(0, 0, 1)
    local pos = look + Vector3.new(0, offY, 0) - behind * dist
    if config.WallCheckEnabled ~= false then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        local ignore = { LocalPlayer.Character }
        if targetRoot and targetRoot.Parent then table.insert(ignore, targetRoot.Parent) end
        params.FilterDescendantsInstances = ignore
        local attempts = math.floor(axisClamp(config.WallCheckAttempts, 1, 8, 4))
        local okPos = pos
        for i = 1, attempts do
            local try = pos + Vector3.new(0, (i - 1) * (tonumber(config.WallCheckFallbackY) or 5), 0)
            local hit = workspace:Raycast(look, try - look, params)
            if not hit then okPos = try break end
            okPos = try
        end
        pos = okPos
    end

    local attackCF = CFrame.lookAt(pos, look)
    AxisRage.serverCF = attackCF

    -- TP REAL al enemigo (servidor registra hit)
    pcall(function()
        myRoot.CFrame = attackCF
        myRoot.AssemblyLinearVelocity = Vector3.zero
        myRoot.AssemblyAngularVelocity = Vector3.zero
    end)
    if config.RageHover then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum.PlatformStand = true end) end
    end
    AxisRage.needRestore = true
    return true
end

function axisFire(targetPart)
    if not targetPart then return false end
    local item = axisEquipped()
    if not item then return false end
    local oid
    pcall(function() oid = item:Get("ObjectID") end)
    if not oid then return false end
    local myRoot = axisGetRoot(LocalPlayer.Character)
    if not myRoot then return false end
    local origin = (AxisRage.serverCF and AxisRage.serverCF.Position) or myRoot.Position
    local aimCF = CFrame.lookAt(origin, targetPart.Position)
    local targetCF = targetPart.CFrame
    local objOff = targetCF:ToObjectSpace(CFrame.new(targetPart.Position))
    local data = {}
    if util and util.EncodeCFrame then
        data[utf8.char(1)] = {
            [utf8.char(0)] = util:EncodeCFrame(aimCF),
            [utf8.char(1)] = util:EncodeCFrame(targetCF),
            [utf8.char(2)] = targetPart,
            [utf8.char(3)] = util:EncodeCFrame(objOff),
        }
    else
        data[utf8.char(1)] = {
            [utf8.char(0)] = aimCF,
            [utf8.char(1)] = targetCF,
            [utf8.char(2)] = targetPart,
            [utf8.char(3)] = objOff,
        }
    end
    local enumVal = "StartShooting"
    pcall(function()
        if enum and enum.ToEnum then enumVal = enum:ToEnum("StartShooting") end
    end)
    local RS = game:GetService("ReplicatedStorage")
    local remote = RS:FindFirstChild("Remotes")
    remote = remote and remote:FindFirstChild("Replication")
    remote = remote and remote:FindFirstChild("Fighter")
    remote = remote and remote:FindFirstChild("UseItem")
    if not remote then return false end
    local attempts = math.floor(axisClamp(config.RageShootAttempts, 1, 10, 1))
    for _ = 1, attempts do
        pcall(function() remote:FireServer(oid, enumVal, data, nil) end)
    end
    return true
end

function axisFastShootApply()
    if not config.HarionFastShoot and not config.HarionNoSpread then return end
    pcall(function()
        local Storage = game:GetService("ReplicatedStorage")
        local Items = require(Storage.Modules.ItemLibrary).Items
        for _, data in pairs(Items) do
            if typeof(data) == "table" then
                if config.HarionNoSpread then
                    if data.ShootSpread ~= nil then data.ShootSpread = 0 end
                end
                if config.HarionFastShoot then
                    if data.ShootRecoil ~= nil then data.ShootRecoil = 0 end
                    if data.ShootCooldown ~= nil then data.ShootCooldown = 0.001 end
                    if data.ShootBurstCooldown ~= nil then data.ShootBurstCooldown = 0.001 end
                    if data.AttackCooldown ~= nil then data.AttackCooldown = 0.001 end
                end
            end
        end
    end)
end

function axisStep()
    if not config.RagebotEnabled or not AxisRage.active then return end
    if CanDoDangerousMove and not CanDoDangerousMove() then return end
    if IsAntiUnnamedActive and IsAntiUnnamedActive() then return end

    local myRoot = axisGetRoot(LocalPlayer.Character)
    if not myRoot then return end
    if not AxisRage.home then AxisRage.home = myRoot.CFrame end

    if not util or not enum then
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            util = require(RS.Modules.Utility)
            enum = require(RS.Modules.EnumLibrary)
        end)
    end
    if not FighterController then
        pcall(function()
            local fc = LocalPlayer.PlayerScripts.Controllers:FindFirstChild("FighterController")
            if fc then FighterController = require(fc) end
        end)
    end

    pcall(function() if updateDeflection then updateDeflection() end end)

    local target, head, tRoot = axisPickTarget()
    AxisRage.target = target
    RagebotTarget = target

    if not target or not head then
        if config.RageVoidSpamAfterKill ~= false then
            axisMeowVoid(myRoot)
        end
        return
    end

    local item = axisEquipped()
    local ammo = nil
    pcall(function() ammo = item and item:Get("Ammo") end)
    if ammo == 0 and config.RageVoidOnReload then
        AxisRage.reloadVoidUntil = tick() + axisClamp(config.RageShotgunVoidTime, 1, 30, 5)
        axisMeowVoid(myRoot)
        if config.RageAutoSwap then
            pcall(function() if rageEquipPreferred then rageEquipPreferred() end end)
        end
        return
    end

    local delay = axisClamp(config.RageTeleportDelay, 0.01, 1, 0.04)
    if tick() - AxisRage.lastFire < delay then
        axisTeleportTo(tRoot, head)
        return
    end

    if axisTeleportTo(tRoot, head) then
        AxisRage.lastFire = tick()
        axisFire(head)
        -- desync visual: después de disparar vuelves a tu sitio (TÚ no ves el TP)
        if config.RageDesync ~= false and AxisRage.needRestore then
            local visual = AxisRage.clientCF or AxisRage.home
            if visual then
                -- un frame después para que el remote salga con pos de ataque
                task.defer(function()
                    local r = axisGetRoot(LocalPlayer.Character)
                    if r and config.RagebotEnabled then
                        pcall(function()
                            r.CFrame = visual
                            r.AssemblyLinearVelocity = Vector3.zero
                            r.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                    AxisRage.needRestore = false
                end)
            end
        end
    end
end

StartRagebot = function()
    config.RagebotEnabled = true
    config.RageUseItem = true
    if config.RageDesync == nil then config.RageDesync = true end -- default ON; respeta toggle
    AxisRage.active = true
    AxisRage.gen = AxisRage.gen + 1
    AxisRage.home = nil
    AxisRage.clientCF = nil
    AxisRage.serverCF = nil
    AxisRage.lastVsPos = nil
    AxisRage.voiding = false
    AxisRage.lastFire = 0
    local myRoot = axisGetRoot(LocalPlayer.Character)
    if myRoot then
        AxisRage.home = myRoot.CFrame
        AxisRage.clientCF = myRoot.CFrame
    end
    axisFastShootApply()
    pcall(function() if rageEquipPreferred then rageEquipPreferred() end end)
    SafeDisconnect("Ragebot")
    Connections.Ragebot = RunService.Heartbeat:Connect(function()
        pcall(axisStep)
    end)
    -- RenderStepped: si desync, fuerza visual en home (casi no ves el TP)
    SafeDisconnect("RageDesyncVis")
    if config.BodyTwistWithRage ~= false then
        pcall(StopBodyTwist)
    end
    if config.RageDesync ~= false then
        -- Desync fuerte (estilo Harion): BindToRenderStep prioridad Camera
        -- TÚ siempre ves clientCF/home; el servidor recibe el TP de ataque
        pcall(function() RunService:UnbindFromRenderStep("__as_rage_desync") end)
        RunService:BindToRenderStep("__as_rage_desync", Enum.RenderPriority.Camera.Value, function()
            if not config.RagebotEnabled or not AxisRage.active then return end
            if config.RageDesync == false then return end
            local visual = AxisRage.clientCF or AxisRage.home
            if not visual then return end
            -- Durante needRestore dejamos 1 frame de ataque, luego forzamos visual
            local r = axisGetRoot(LocalPlayer.Character)
            if not r then return end
            if AxisRage.needRestore then
                -- frame de fire: no tocar (remote sale con pos ataque)
                return
            end
            pcall(function()
                r.CFrame = visual
                r.AssemblyLinearVelocity = Vector3.zero
                r.AssemblyAngularVelocity = Vector3.zero
            end)
        end)
        -- backup Heartbeat por si RenderStep falla
        Connections.RageDesyncVis = RunService.Heartbeat:Connect(function()
            getgenv()._rdF = (getgenv()._rdF or 0) + 1
            if getgenv()._rdF % 2 ~= 0 then return end
            if not config.RagebotEnabled or not AxisRage.active or config.RageDesync == false then return end
            if AxisRage.needRestore then return end
            local visual = AxisRage.clientCF or AxisRage.home
            local r = axisGetRoot(LocalPlayer.Character)
            if not visual or not r then return end
            if (r.Position - visual.Position).Magnitude > 1.5 then
                pcall(function()
                    r.CFrame = visual
                    r.AssemblyLinearVelocity = Vector3.zero
                end)
            end
        end)
    end
    if config.BodyTwistWithRage ~= false then
        config.BodyTwist = true
        pcall(StartBodyTwist)
    end
    Notify("Ragebot", "AXIS ON · desync")
end

StopRagebot = function()
    config.RagebotEnabled = false
    AxisRage.active = false
    SafeDisconnect("Ragebot")
    SafeDisconnect("RageDesyncVis")
    pcall(function() RunService:UnbindFromRenderStep("__as_rage_desync") end)
    if config.BodyTwistWithRage ~= false then
        pcall(StopBodyTwist)
    end
    local myRoot = axisGetRoot(LocalPlayer.Character)
    if myRoot and AxisRage.home then
        pcall(function()
            myRoot.CFrame = AxisRage.home
            myRoot.AssemblyLinearVelocity = Vector3.zero
        end)
    end
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
    AxisRage.home = nil
    AxisRage.target = nil
    RagebotTarget = nil
    AxisRage.voiding = false
    Notify("Ragebot", "AXIS OFF")
end


getgenv().RageInd = RageInd

-- loop del indicator (barato)
if not Connections then Connections = {} end
pcall(function()
    if Connections.RageInd then Connections.RageInd:Disconnect() end
    local riN = 0
    Connections.RageInd = RunService.Heartbeat:Connect(function()
        if not config.RagebotEnabled and not config.RageIndicatorEnabled then return end
        riN = riN + 1
        if riN % 2 == 1 then return end -- ~30fps
        pcall(function() if RageInd and RageInd.update then RageInd.update() end end)
    end)
end)


StartAutoClick = function()
    SafeDisconnect("AutoClick")
    LastClick = 0
    Connections.AutoClick = RunService.RenderStepped:Connect(function()
        if not config.AutoClickEnabled or UserInputService:GetFocusedTextBox() then return end
        if config.AutoClickOnlyOnTarget then
            if not (config.RagebotEnabled and RagebotTarget) and not (config.Enabled and CurrentTarget) then return end
        end
        if tick() - LastClick >= 1 / math.max(config.AutoClickCPS, 1) then
            LastClick = tick()
            pcall(function() mouse1click() end)
        end
    end)
end
StopAutoClick = function() SafeDisconnect("AutoClick") end

StartNoclip = function()
    SafeDisconnect("Noclip")
    local _ncAcc = 0
    Connections.Noclip = RunService.Heartbeat:Connect(function(dt)
        if not config.NoclipEnabled then return end
        if type(isNoclipKeyActive) == "function" and not isNoclipKeyActive() then return end
        _ncAcc = _ncAcc + dt
        if _ncAcc < 0.08 then return end -- ~12/s max
        _ncAcc = 0
        local char = LocalPlayer.Character
        if not char then return end
        for _, p in ipairs(char:GetChildren()) do
            if p:IsA("BasePart") then
                p.CanCollide = false
            elseif p:IsA("Accessory") then
                local h = p:FindFirstChild("Handle")
                if h and h:IsA("BasePart") then h.CanCollide = false end
            end
        end
    end)
end
StopNoclip = function() SafeDisconnect("Noclip") end

-- ==================== ANTI AIM (HARION+) — register-safe ====================
do
    local AA = getgenv()._ShakoAA
    if type(AA) ~= "table" then AA = {} getgenv()._ShakoAA = AA end
    AA.task = nil
    AA.util = nil
    AA.cam = nil
    AA.remote = nil
    AA.jitterSide = 1
    AA.nextJitter = 0
    AA.jitterYaw = 0
    AA.contYaw = 0      -- yaw continuo (no wrap ±180)
    AA.contPitch = 0
    AA.lastTick = 0

    function AA.resolve()
        local RS = game:GetService("ReplicatedStorage")
        if not AA.util then pcall(function() AA.util = require(RS.Modules.Utility) end) end
        if not AA.cam then
            pcall(function()
                local ps = LocalPlayer:FindFirstChild("PlayerScripts")
                local c = ps and ps:FindFirstChild("Controllers")
                local m = c and c:FindFirstChild("CameraController")
                if m then AA.cam = require(m) end
            end)
        end
        if not AA.remote then
            pcall(function()
                local r = RS:FindFirstChild("Remotes")
                local rep = r and r:FindFirstChild("Replication")
                local f = rep and rep:FindFirstChild("Fighter")
                AA.remote = f and f:FindFirstChild("UpdateCameraRotation")
            end)
        end
        return AA.util and AA.cam and AA.remote
    end

    function AA.rot()
        -- HARION remote — Yaw Angle SIEMPRE aplica (grados del slider)
        local cur = (AA.cam and AA.cam.Rotation) or Vector2.zero
        local camPitch, camYaw = cur.X or 0, cur.Y or 0
        local pm = string.lower(tostring(config.AAPitchMode or "down"))
        local ym = string.lower(tostring(config.AAYawMode or "jitter"))
        local pitchOff = tonumber(config.AAPitchOffset) or 300
        local pitchAng = tonumber(config.AAPitchAngle) or 0
        local yawAngDeg = tonumber(config.AAYawAngle) or 180
        local yawAng = math.rad(yawAngDeg)  -- SIEMPRE en radianes desde el slider
        local jAmt = tonumber(config.AAJitterAmount) or yawAngDeg
        local spinRate = tonumber(config.AASpinRate) or 1600
        local now = tick()
        local dt = math.clamp(now - (AA.lastTick or now), 0, 0.05)
        AA.lastTick = now

        -- ===== PITCH =====
        local pitch = camPitch
        if pm == "up" then
            pitch = math.rad(-89)
        elseif pm == "down" then
            pitch = math.rad(pitchOff > 0 and pitchOff or 179)
        elseif pm == "zero" then
            pitch = 0
        elseif pm == "random" then
            pitch = math.rad(math.random(-89, 179))
        elseif pm == "strong" then
            pitch = (now % 0.2 < 0.1) and math.rad(pitchOff > 0 and pitchOff or 179) or math.rad(-89)
        elseif pm == "disabled" or pm == "off" then
            pitch = camPitch
        end
        if pitchAng ~= 0 then
            pitch = pitch + math.rad(pitchAng)
        end
        if config.AntiAimUnderground then
            pitch = math.rad(pitchOff > 0 and pitchOff or 179)
        end

        -- ===== YAW: el slider Yaw Angle SIEMPRE manda =====
        -- Base = yaw de camara + offset del slider (yawAngDeg)
        -- Los modos modifican ENCIMA de ese offset
        local yaw
        if ym == "backwards" then
            -- mira atras = cam + yawAngle (default 180 = espalda)
            yaw = camYaw + yawAng
        elseif ym == "spin" then
            AA.contYaw = (AA.contYaw or 0) + math.rad(spinRate) * dt
            yaw = AA.contYaw + yawAng  -- spin + offset del slider
        elseif ym == "random" then
            if now >= (AA.nextJitter or 0) then
                AA.jitterYaw = math.rad(math.random(0, 359))
                AA.nextJitter = now + 0.018
            end
            yaw = (AA.jitterYaw or 0) + yawAng
        elseif ym == "jitter" then
            if now >= (AA.nextJitter or 0) then
                AA.jitterSide = -(AA.jitterSide or 1)
                local amp = math.rad(math.max(jAmt, 1) * (0.55 + math.random() * 0.45))
                AA.jitterYaw = AA.jitterSide * amp
                AA.nextJitter = now + 0.012 + math.random() * 0.018
            end
            -- centro = cam + yawAngle, oscila con jitter
            yaw = camYaw + yawAng + (AA.jitterYaw or 0)
        elseif ym == "side" then
            if now >= (AA.nextJitter or 0) then
                AA.jitterSide = -(AA.jitterSide or 1)
                AA.nextJitter = now + 0.022
            end
            yaw = camYaw + math.rad((AA.jitterSide or 1) * 90) + yawAng
        elseif ym == "opposite" then
            yaw = camYaw + yawAng + math.rad((math.random() * 2 - 1) * 12)
        elseif ym == "strong" then
            AA.contYaw = (AA.contYaw or 0) + math.rad(spinRate * 1.2) * dt
            local phase = (now * 8) % 3
            if phase < 1 then
                yaw = AA.contYaw + yawAng
            elseif phase < 2 then
                yaw = camYaw + yawAng + math.rad((math.random() * 2 - 1) * 40)
            else
                yaw = math.rad(math.random(0, 359)) + yawAng
            end
        else
            -- disabled: igual aplica el slider para que "haga algo"
            yaw = camYaw + yawAng
        end

        AA._lastPitch = pitch
        AA._lastYaw = yaw
        AA.contPitch = pitch
        AA.contYaw = yaw
        return Vector2.new(pitch, yaw)
    end

    -- Partes R15 que el AA debe orientar (mismo pitch/yaw que el remote)
    AA.BODY_PARTS = {
        "Head", "UpperTorso", "LowerTorso",
        "LeftUpperArm", "LeftLowerArm", "LeftHand",
        "RightUpperArm", "RightLowerArm", "RightHand",
    }
    AA._motorOrig = AA._motorOrig or {}

    function AA.cacheMotors(char)
        if not char then return end
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("Motor6D") and d.Part0 and d.Part1 then
                local p1 = d.Part1.Name
                for _, want in ipairs(AA.BODY_PARTS) do
                    if p1 == want or d.Name == "Neck" or d.Name == "Waist"
                        or d.Name:find("Shoulder") or d.Name:find("Elbow")
                        or d.Name:find("Wrist") or d.Name == "Root" then
                        if not AA._motorOrig[d] then
                            AA._motorOrig[d] = d.C0
                        end
                    end
                end
            end
        end
    end

    function AA.applyBody(rot)
        -- no local body fold while sliding (rompe pose)
        if getgenv()._ShakoSlideGuard and getgenv()._ShakoSlideGuard.sliding then return end
        local char = LocalPlayer.Character
        if not char or not rot then return end
        AA.cacheMotors(char)

        local pitch = rot.X or AA._lastPitch or 0
        local yaw = rot.Y or AA._lastYaw or 0

        -- Construir rotación sin pasar por el gimbal lock de ±180:
        -- CFrame.Angles en YXZ con componentes acotados por joint, no re-wrap
        local function cfPitchYaw(pScale, yScale)
            local p = pitch * pScale
            local y = yaw * yScale
            -- fromEulerAnglesYXZ evita algunos flips de Angles clásico
            return CFrame.fromEulerAnglesYXZ(p, y, 0)
        end

        for motor, base in pairs(AA._motorOrig) do
            if motor and motor.Parent and base then
                local n = string.lower(motor.Name)
                local p1 = motor.Part1 and motor.Part1.Name or ""
                pcall(function()
                    if n == "neck" or p1 == "Head" then
                        motor.C0 = base * cfPitchYaw(1.0, 0.55)
                    elseif n == "waist" or p1 == "UpperTorso" then
                        motor.C0 = base * CFrame.fromEulerAnglesYXZ(pitch * 0.85, yaw * 0.45, pitch * 0.2)
                    elseif n == "root" or p1 == "LowerTorso" then
                        motor.C0 = base * cfPitchYaw(0.55, 0.4)
                    elseif n:find("shoulder") or p1:find("UpperArm") then
                        local s = (n:find("left") or p1:find("Left")) and -1 or 1
                        motor.C0 = base * CFrame.fromEulerAnglesYXZ(pitch * 0.4, yaw * 0.15 * s, pitch * 0.45 * s)
                    elseif n:find("elbow") or p1:find("LowerArm") then
                        motor.C0 = base * CFrame.fromEulerAnglesYXZ(math.abs(pitch) * 0.25, 0, 0)
                    elseif n:find("wrist") or p1:find("Hand") then
                        motor.C0 = base * cfPitchYaw(0.1, 0.05)
                    end
                end)
            end
        end
    end

    function AA.restoreBody()
        for motor, base in pairs(AA._motorOrig) do
            pcall(function()
                if motor and motor.Parent and base then motor.C0 = base end
            end)
        end
        AA._motorOrig = {}
    end

    function AA.startTask()
        AA.stopTask()
        local pose = {
            enabled = true,
            pitch = string.lower(tostring(config.AAPitchMode or "down")),
            yaw = string.lower(tostring(config.AAYawMode or "jitter")),
            underground = config.AntiAimUnderground == true,
        }
        getgenv()._ShakoAntiAimPoseConfig = pose
        _G.AntiAimPoseConfig = pose

        -- Loop SIEMPRE: reintenta resolve cada frame (lobby -> partida)
        AA.task = task.spawn(function()
            local lastOk = false
            while config.AntiAimEnabled do
                pose.enabled = true
                pose.pitch = string.lower(tostring(config.AAPitchMode or "down"))
                pose.yaw = string.lower(tostring(config.AAYawMode or "jitter"))
                pose.underground = config.AntiAimUnderground == true

                if not (AA.util and AA.cam and AA.remote) then
                    AA.resolve()
                end

                if AA.util and AA.remote then
                    local ym = string.lower(tostring(config.AAYawMode or "jitter"))
                    local burst = 4
                    if ym == "random" then burst = 7
                    elseif ym == "jitter" then burst = 6
                    elseif ym == "spin" then burst = 5
                    elseif ym == "strong" or config.AAStrongMode then
                        burst = math.clamp(tonumber(config.AAPacketBurst) or 10, 5, 16)
                    else
                        burst = math.clamp(tonumber(config.AAPacketBurst) or 4, 3, 12)
                    end

                    local rot = AA.rot()
                    -- SOLO remote AA (otros ven pitch/yaw). Tu camara no se toca.
                    for _ = 1, burst do
                        local ok = pcall(function()
                            AA.remote:FireServer(AA.util:EncodeCameraRotation(rot), nil)
                        end)
                        if not ok then break end
                    end
                    -- Underground: se queda pegado bajo el mapa + noclip (no lo empuja el suelo)
                    if config.AntiAimUnderground then
                        pcall(function()
                            local char = LocalPlayer.Character
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if not hrp then return end
                            local depth = tonumber(config.UndergroundDepth) or 3.5

                            -- Noclip throttled (no cada tick de AA)
                            getgenv()._ugNcT = getgenv()._ugNcT or 0
                            if (os.clock() - getgenv()._ugNcT) > 0.35 then
                                getgenv()._ugNcT = os.clock()
                                for _, p in ipairs(char:GetChildren()) do
                                    if p:IsA("BasePart") then
                                        p.CanCollide = false
                                    end
                                end
                            end

                            -- Ray desde arriba para encontrar el piso real (aunque ya estés bajo tierra)
                            local origin = Vector3.new(hrp.Position.X, hrp.Position.Y + 250, hrp.Position.Z)
                            local rp = RaycastParams.new()
                            rp.FilterType = Enum.RaycastFilterType.Exclude
                            rp.FilterDescendantsInstances = { char }
                            local hit = workspace:Raycast(origin, Vector3.new(0, -800, 0), rp)
                            local groundY = hit and hit.Position.Y or hrp.Position.Y
                            local underY = groundY - depth
                            local underPos = Vector3.new(hrp.Position.X, underY, hrp.Position.Z)

                            -- Mantener pegado abajo (sin restaurar: se queda bajo el mapa)
                            local rot = hrp.CFrame - hrp.CFrame.Position
                            hrp.CFrame = CFrame.new(underPos) * rot
                            hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                    if not lastOk then
                        lastOk = true
                        print("[shako] AntiAim HARION remote OK")
                    end
                else
                    lastOk = false
                end
                RunService.Heartbeat:Wait()
            end
            pose.enabled = false
        end)
        return true
    end

    function AA.stopTask()
        if AA.task then
            pcall(task.cancel, AA.task)
            AA.task = nil
        end
        if getgenv()._ShakoAntiAimPoseConfig then
            getgenv()._ShakoAntiAimPoseConfig.enabled = false
        end
        if _G.AntiAimPoseConfig then
            _G.AntiAimPoseConfig.enabled = false
        end
        pcall(AA.restoreBody)
    end

    StartAntiAim = function()
        SafeDisconnect("AntiAim")
        pcall(function() RunService:UnbindFromRenderStep("__as_aa_client") end)
        AA.stopTask()
        config.AntiAimEnabled = true
        config.AAHideLocal = true -- tu vista normal; AA solo en remote
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
        if not config.AAPitchMode or config.AAPitchMode == "disabled" then
            config.AAPitchMode = "down"
        end
        if not config.AAYawMode or config.AAYawMode == "disabled" then
            config.AAYawMode = "jitter"
        end
        config.AAPitchOffset = tonumber(config.AAPitchOffset) or 250
        config.AAYawAngle = tonumber(config.AAYawAngle) or 180
        local ok = AA.startTask()
        pcall(AA.resolve)
        if Connections.AntiAimChar then
            pcall(function() Connections.AntiAimChar:Disconnect() end)
            Connections.AntiAimChar = nil
        end
        Connections.AntiAimChar = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.4)
            if config.AntiAimEnabled then
                AA._motorOrig = {}
                AA.resolve()
                AA.startTask()
            end
        end)
        -- Hide local: solo mouse libre, sin tocar HRP/camara
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
        if not getgenv()._ShakoQuiet then
            Notify("AntiAim", ok and (tostring(config.AAPitchMode) .. "/" .. tostring(config.AAYawMode))
                or "HARION deps fail — activa en partida")
        end
    end

    StopAntiAim = function()
        config.AntiAimEnabled = false
        pcall(function()
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
        SafeDisconnect("AntiAim")
        if Connections.AntiAimChar then
            pcall(function() Connections.AntiAimChar:Disconnect() end)
            Connections.AntiAimChar = nil
        end
        AA.stopTask()
        pcall(function() RunService:UnbindFromRenderStep("__as_aa_client") end)
    end
end

-- ==================== UE COUNTER (solo esto, sin Anti Unnamed viejo) ====================
StartAntiUnnamed = function()
    StartUECounter()
end
StopAntiUnnamed = function()
    StopUECounter()
end
ArmAntiUnnamedOnSpawn = function()
    if config.UECounterEnabled or config.AntiUnnamed then
        task.defer(function()
            task.wait(0.3)
            if config.UECounterEnabled or config.AntiUnnamed then
                StartUECounter()
            end
        end)
    end
end
StartAUWatcher = function()
    SafeDisconnect("AUWatch")
    if not (config.UECounterEnabled or config.AntiUnnamed) then return end
    Connections.AUWatch = LocalPlayer.CharacterAdded:Connect(function()
        if config.UECounterEnabled or config.AntiUnnamed then
            ArmAntiUnnamedOnSpawn()
        end
    end)
end

function StartUECounter()
    SafeDisconnect("AntiUnnamed")
    config.UECounterEnabled = true
    config.AntiUnnamed = true
    UECounterReady = true

    function ueTp()
        if not (config.UECounterEnabled or config.AntiUnnamed) then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local y = tonumber(config.UECounterY) or 500
        -- SIN desync: TP real al cielo (counter de UE)
        pcall(function()
            local pos = hrp.Position + Vector3.new(0, y, 0)
            hrp.CFrame = CFrame.new(pos)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    Connections.AntiUnnamed = task.spawn(function()
        while config.UECounterEnabled or config.AntiUnnamed do
            ueTp()
            local cd = tonumber(config.UECounterCooldown) or 0.2
            if cd < 0 then cd = 0 end
            if cd > 2 then cd = 2 end
            task.wait(cd)
        end
        Connections.AntiUnnamed = nil
    end)
    if not getgenv()._ShakoQuiet then
        Notify("UE Counter", "ON · Y +" .. tostring(config.UECounterY or 500))
    end
end

function StopUECounter()
    config.UECounterEnabled = false
    config.AntiUnnamed = false
    UECounterReady = false
    SafeDisconnect("AntiUnnamed")
    SafeDisconnect("AUWatch")
    pcall(function() RunService:UnbindFromRenderStep("__as_au_lock") end)
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then pcall(function() hrp.Anchored = false end) end
    if not getgenv()._ShakoQuiet and not (getgenv()._ShakoBootAt and tick() - getgenv()._ShakoBootAt < 8) then
        Notify("UE Counter", "OFF")
    end
end

-- anti Sleepy multi-pos: cambia direccion (arriba / lados / atras / frente)
local STICK_POS = {"Under", "Above", "Right", "Left", "Behind", "Front", "RightHand", "LeftHand"}

function getStickOffsetCF(root, head)
    local away = math.max(tonumber(config.StickAway) or 6, 0.8)
    if config.StickFarMode then away = away * (tonumber(config.StickFarMult) or 2.5) end
    local baseY = tonumber(config.StickHeight) or -2.8
    local ox = tonumber(config.StickOffsetX) or 0
    local oz = tonumber(config.StickOffsetZ) or 0

    if config.StickMultiPos ~= false then
        if tick() - stickPosLast >= (config.StickPosInterval or 0.18) then
            stickPosLast = tick()
            stickPosIndex = stickPosIndex % #STICK_POS + 1
        end
    end
    local mode = STICK_POS[stickPosIndex] or "Under"
    local cf = root.CFrame
    local look = (head and head.Position) or root.Position
    local pos
    if mode == "Under" then
        pos = (cf * CFrame.new(ox, baseY, oz)).Position
    elseif mode == "Above" then
        pos = (cf * CFrame.new(ox, math.max(baseY, 0) + 2.2 + away * 0.35, oz - 0.4)).Position
    elseif mode == "Right" then
        pos = (cf * CFrame.new(away + ox, baseY + 0.5, oz)).Position
    elseif mode == "Left" then
        pos = (cf * CFrame.new(-(away + ox), baseY + 0.5, oz)).Position
    elseif mode == "Behind" then
        pos = (cf * CFrame.new(ox, baseY + 0.3, away + oz)).Position
    elseif mode == "Front" then
        pos = (cf * CFrame.new(ox, baseY + 0.3, -(away * 0.7) + oz)).Position
    elseif mode == "RightHand" then
        pos = (cf * CFrame.new(away * 0.85 + ox, baseY + 1.0, -0.5 + oz)).Position
    else -- LeftHand
        pos = (cf * CFrame.new(-(away * 0.85 + ox), baseY + 1.0, -0.5 + oz)).Position
    end
    return CFrame.lookAt(pos, look), pos, look, mode
end

function StickToTarget(target)
    if IsAntiUnnamedActive() or config.VoidSpamEnabled or config.RagebotEnabled then return false end
    if not target or not target.Character then return false end
    -- NUNCA pegarse al team
    if not IsEnemy(target) then return false end
    local hum = target.Character:FindFirstChildOfClass("Humanoid")
    local root = target.Character:FindFirstChild("HumanoidRootPart")
    local head = target.Character:FindFirstChild("Head")
    if not hum or not root or hum.Health <= 0 then return false end

    local my = getHRP()
    if not my then return false end

    local stickCF, stickPos, lookPos, mode = getStickOffsetCF(root, head)

    -- DESYNC igual que rage: server en stick pos, local no ve el TP
    if config.StickDesync ~= false then
        local oldCF = my.CFrame
        local oldVel = my.AssemblyLinearVelocity
        local oldRot = my.AssemblyAngularVelocity
        pcall(function() RunService:UnbindFromRenderStep("__as_stick_restore") end)
        my.CFrame = stickCF
        if config.ForceZeroVelocity then
            my.AssemblyLinearVelocity = Vector3.zero
            my.AssemblyAngularVelocity = Vector3.zero
        end
        RunService:BindToRenderStep("__as_stick_restore", Enum.RenderPriority.Camera.Value - 1, function()
            if my and my.Parent then
                my.CFrame = oldCF
                my.AssemblyLinearVelocity = oldVel
                my.AssemblyAngularVelocity = oldRot
            end
            pcall(function() RunService:UnbindFromRenderStep("__as_stick_restore") end)
        end)
    else
        -- modo viejo: ves el TP
        if config.SoftStick then
            local cur = my.Position
            local goal = stickPos
            local delta = goal - cur
            local dist = delta.Magnitude
            local maxStep = math.max(config.SoftStickMaxStep or 8, 1)
            if dist > maxStep then
                goal = cur + delta.Unit * maxStep
            end
            my.CFrame = CFrame.lookAt(goal, lookPos)
        else
            my.CFrame = stickCF
        end
        if config.ForceZeroVelocity then
            pcall(function()
                my.AssemblyLinearVelocity = Vector3.zero
                my.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end

    -- disparar a head como rage
    if config.StickFireHead and modulesOK and FighterController then
        pcall(function()
            local lf = FighterController.LocalFighter
            local item = lf and lf.EquippedItem
            if item and head and fireRageUseItem then
                fireRageUseItem(item, stickCF, head, root)
            end
        end)
    end

    if config.CameraLookAtTarget and head and not config.CameraIndependent then
        LookAtPos(head.Position)
    end
    return true
end
function DoStrafe()
    -- SOLO si StrafeEnabled == true (nunca Orbit)
    if not config.StrafeEnabled then return end
    if config.OrbitEnabled then return end -- nunca mezclar
    if IsAntiUnnamedActive() or config.VoidSpamEnabled or config.RagebotEnabled or not CanDoDangerousMove() then return end
    local target = GetClosestEnemy()
    if not target or not target.Character or (config.TeamCheck and IsSameTeam(target)) then return end
    local root = target.Character:FindFirstChild("HumanoidRootPart")
    local head = target.Character:FindFirstChild("Head")
    if not root then return end
    local t = tick() * config.StrafeSpeed
    -- strafe lateral (no círculo completo)
    SafeEnemyCFrame(root, config.StickHeight, math.sin(t) * (config.OrbitRange or 4), 0, head and head.Position or root.Position)
end
function DoOrbit()
    -- SOLO si OrbitEnabled == true explícitamente
    if config.OrbitEnabled ~= true then return end
    if config.StrafeEnabled then return end
    if IsAntiUnnamedActive() or config.VoidSpamEnabled or config.RagebotEnabled or not CanDoDangerousMove() then return end
    local target = GetClosestEnemy()
    if not target or not target.Character or (config.TeamCheck and IsSameTeam(target)) then return end
    local root = target.Character:FindFirstChild("HumanoidRootPart")
    local head = target.Character:FindFirstChild("Head")
    if not root then return end
    OrbitAngle = OrbitAngle + (config.OrbitSpeed or 16) * 0.025
    SafeEnemyCFrame(root, config.StickHeight, math.cos(OrbitAngle) * (config.OrbitRange or 4), math.sin(OrbitAngle) * (config.OrbitRange or 4), head and head.Position or root.Position)
end
function ExpandHitboxes()
    if not config.HitboxExpand then return end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        if config.TeamCheck and IsSameTeam(plr) then continue end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        if root and not root:FindFirstChild("SleepyHitbox") then
            local box = Instance.new("Part")
            box.Name = "SleepyHitbox"
            box.Size = Vector3.new(config.HitboxSize, config.HitboxSize, config.HitboxSize)
            box.Transparency = 1
            box.CanCollide = false
            box.Massless = true
            box.Parent = root
            local w = Instance.new("Weld")
            w.Part0, w.Part1, w.Parent = root, box, box
        end
    end
end

StartFly = function()
    SafeDisconnect("Fly")
    Connections.Fly = RunService.RenderStepped:Connect(function()
        if not config.FlyEnabled or IsAntiUnnamedActive() or config.VoidSpamEnabled then return end
        local hrp, hum, cam = getHRP(), getHum(), workspace.CurrentCamera
        if not hrp or not hum or not cam then return end
        EnsureCameraFree()
        hum.PlatformStand = true
        hrp.AssemblyAngularVelocity = Vector3.zero
        local speed = config.FlySpeed
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then speed = speed * config.FlyBoost end
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then move = move + Vector3.new(0, -1, 0) end
        if move.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = move.Unit * speed
            hrp.CFrame = hrp.CFrame + move.Unit * speed * 0.016
        else
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end
StopFly = function()
    SafeDisconnect("Fly")
    local hum = getHum()
    if hum then hum.PlatformStand = false end
end

StartStickRender = function()
    SafeDisconnect("StickRender")
    local stickFrame = 0
    Connections.StickRender = RunService.RenderStepped:Connect(function()
        stickFrame += 1
        if stickFrame % 3 ~= 0 then return end -- OPT
        if IsAntiUnnamedActive() or config.VoidSpamEnabled or config.RagebotEnabled then return end
        if not CanDoDangerousMove() or not config.StickOnRender then return end
        -- prioridad estricta: solo una a la vez, y solo si está activada
        if config.OrbitEnabled == true then
            DoOrbit()
            return
        end
        if config.StrafeEnabled == true then
            DoStrafe()
            return
        end
        if config.Enabled == true then
            if not CurrentTarget or not CurrentTarget.Character
                or not CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
                or CurrentTarget.Character:FindFirstChildOfClass("Humanoid").Health <= 0
                or not IsEnemy(CurrentTarget) then
                CurrentTarget = GetClosestEnemy()
            end
            if CurrentTarget and IsEnemy(CurrentTarget) then
                StickToTarget(CurrentTarget)
            else
                CurrentTarget = nil
            end
        end
    end)
end
StartMainLoop = function()
    SafeDisconnect("Main")
    StartStickRender()
    local mainFrame = 0
    Connections.Main = RunService.Heartbeat:Connect(function()
        mainFrame += 1
        -- OPT: movement menos frecuente
        local needMove = config.SpeedEnabled or config.JumpPowerEnabled or config.SlideBoostEnabled
            or config.AntiFling or config.DesyncJitter
        if needMove then
            if mainFrame % 4 == 0 then UpdateMovement() end
        elseif mainFrame % 8 == 0 then
            UpdateMovement()
        end
        if not CanDoDangerousMove() then return end
        if IsAntiUnnamedActive() or config.VoidSpamEnabled then return end
        if mainFrame % 5 == 0 then ExpandHitboxes() end
        if config.StickOnRender and (config.Enabled or config.StrafeEnabled or config.OrbitEnabled) then
            ApplyFakePosition()
            return
        end
        if not config.Enabled or config.RagebotEnabled then return end
        if not CurrentTarget or not CurrentTarget.Character
            or not CurrentTarget.Character:FindFirstChildOfClass("Humanoid")
            or CurrentTarget.Character:FindFirstChildOfClass("Humanoid").Health <= 0
            or (config.TeamCheck and IsSameTeam(CurrentTarget)) then
            CurrentTarget = GetClosestEnemy()
        end
        if CurrentTarget and not (config.TeamCheck and IsSameTeam(CurrentTarget)) then
            StickToTarget(CurrentTarget)
        end
        ApplyFakePosition()
    end)
end





-- ==================== LUAHOOK ESP (integrado bien) ====================
do
    if type(State) ~= "table" then
        State = {}
    end
    State.ESPObjects = State.ESPObjects or {}
    State.PrimaryTarget = State.PrimaryTarget
    State.RainbowHue = State.RainbowHue or 0
end

function getSafePlayers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p and p:IsA("Player") then
            list[#list + 1] = p
        end
    end
    return list
end

-- Config unificado (ESP + weather keys)
if type(Config) ~= "table" or getmetatable(Config) == nil then
    Config = setmetatable({}, {
        __index = function(_, k)
            if k == "ESP" then
                return config.ESPEnabled == true or config.ESP == true
            end
            if k == "Weather" then
                return config.WeatherEnabled == true or config.Weather == true
            end
            if k == "ThirdPersonEnabled" then
                return config.ThirdPerson == true or config.ThirdPersonEnabled == true
            end
            -- map UI names → LuaHook names
            if k == "ESPBox" then return config.ESPShowBox ~= false end
            if k == "ESPName" then return config.ESPShowName ~= false end
            if k == "ESPDistance" then return config.ESPShowDist ~= false end
            if k == "ESPHealth" or k == "ESPHealthBar" then return config.ESPShowHP ~= false end
            local v = config[k]
            if v ~= nil then return v end
            -- defaults sensatos para que se vea bien (estilo UE / LuaHook)
            local defaults = {
                ESPBoxStyle = "Corner Brackets",
                ESPBoxBrackets = true,
                ESPBoxThickness = 2,
                ESPCasingThickness = 2,
                ESPBoxColor = Color3.fromRGB(255, 255, 255),
                ESPBoxTransparency = 0,
                ESPBoxFill = false,
                ESPBoxScale = 1,
                ESPCornerLength = 0.28,
                ESPNameMode = "DisplayName",
                ESPTeamCheck = false,
                ESPMaxDistance = 100000,
                ESPDistanceScaling = true,
                ESPDistanceScalingRef = 50,
                ESPHealthColorMode = "Ramp",
                ESPHealthSmooth = true,
                ESPHealthNumberMode = "Always",
                ESPHealthGhost = true,
                ColorEnemy = Color3.fromRGB(255, 255, 255),
            }
            return defaults[k]
        end,
        __newindex = function(_, k, v)
            if k == "ESP" then
                config.ESPEnabled = v and true or false
                config.ESP = v and true or false
            elseif k == "Weather" then
                config.WeatherEnabled = v and true or false
                config.Weather = v and true or false
            else
                config[k] = v
            end
        end,
    })
end

local lp = LocalPlayer
Camera = workspace.CurrentCamera
pcall(function()
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        Camera = workspace.CurrentCamera
    end)
end)

-- screenDraw opcional (LuaHook lo usa si existe Drawing)
if screenDraw == nil then
    screenDraw = nil
end


-- Helpers que el ESP de LuaHook necesita (estaban fuera del módulo original)
function envIdOf(player)
    local id = nil
    pcall(function()
        if not player then return end
        id = player:GetAttribute("EnvironmentID")
        if id ~= nil then return end
        local f = nil
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            -- best-effort: some fighters expose env via character attribute
            local char = player.Character
            if char then id = char:GetAttribute("EnvironmentID") end
        end)
    end)
    return id
end

function isTeammate(player)
    if player == LocalPlayer or player == lp then return true end
    -- TeamID de Rivals
    local a = LocalPlayer:GetAttribute("TeamID")
    local b = player:GetAttribute("TeamID")
    if a ~= nil and b ~= nil then
        return a == b
    end
    if LocalPlayer.Team ~= nil and player.Team ~= nil then
        return LocalPlayer.Team == player.Team
    end
    -- sin team info = enemigo (para ESP en FFA)
    return false
end

;(function()
function isAlive(player)
    local c = player and player.Character
    if not c then return false end
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then return h.Health > 0 end
    return c:FindFirstChild("HumanoidRootPart") ~= nil or c:FindFirstChild("Head") ~= nil
end

function getHealth(player)
    local c = player and player.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if not h then return 0, 100 end
    return h.Health, math.max(h.MaxHealth, 1)
end

function isVisible(worldPos)
    local cam = workspace.CurrentCamera
    if not cam or not worldPos then return true end
    local origin = cam.CFrame.Position
    local dir = worldPos - origin
    local dist = dir.Magnitude
    if dist < 1 then return true end
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local ignore = { LocalPlayer.Character }
    pcall(function()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then table.insert(ignore, p.Character) end
        end
    end)
    params.FilterDescendantsInstances = ignore
    local hit = workspace:Raycast(origin, dir.Unit * dist, params)
    return hit == nil
end

local ESP = {}
    local hasDrawing  = screenDraw ~= nil
    local _renderConn = nil
    local _espFrame   = 0
    local _lastRenderT = 0
    local _dcLastT    = 0
    local _bboxCache  = {}
    local _bboxFrameN = {}
    local _ctx        = {}
    local _renderArr  = {}
    local _dcArr      = {}
    local _radarO     = { drawings = {} }
    local _module     = { drawings = {} }
    local BLACK = Color3.new(0, 0, 0)
    local WHITE = Color3.new(1, 1, 1)
    local INK   = Color3.fromRGB(4, 6, 10)
    local HPBG  = Color3.fromRGB(11, 15, 22)
    local HP_W       = 5
    local HP_GAP     = 6
    local PAD        = 5
    local FLAG_GAP   = 6
    local BASE_H     = 1080
    local MIN_W      = 8
    local MIN_H      = 13
    local BOX_W_STUDS = 4   * 1000 / 1080
    local BOX_H_STUDS = 6.5 * 1000 / 1080
    local TEXT_FLOOR  = 8
    local DIST_MIN_MUL = 0.5
    local cam        = Camera
    local FACES = {}
    for _, n in ipairs({ "Code", "RobotoMono", "Gotham", "GothamBold", "Arial", "SourceSans" }) do
        local ok, f = pcall(function() return Enum.Font[n] end)
        if ok and f then FACES[n] = f end
    end
    if FACES.Code == nil then FACES.Code = Enum.Font.SourceSans end
    local _customFaces = {}
    function faceFor(name)
        local c = _customFaces[name]
        if c ~= nil then return c end
        return FACES[name] or FACES.Code
    end
    local GLYPH_TRI = string.char(0xE2, 0x96, 0xB2)
    local GLYPH_MID = string.char(0xC2, 0xB7)
    function typePx(base, scale)
        local v = math.floor(base * scale + 0.5)
        if v < TEXT_FLOOR then v = TEXT_FLOOR end
        return v
    end
    function distMul(dist)
        if not Config.ESPDistanceScaling then return 1 end
        local ref = Config.ESPDistanceScalingRef or 50
        return math.clamp(ref / math.max(dist or 1, 1), DIST_MIN_MUL, 1)
    end
    function sizeFor(base, mul)
        local v = math.floor(base * (mul or 1) + 0.5)
        if v < TEXT_FLOOR then v = TEXT_FLOOR end
        return v
    end
    function styleLabel(t, face, size, casing)
        if typeof(face) == "EnumItem" then
            if t.Font ~= face then t.Font = face end
        else
            if t.FontFace ~= face then t.FontFace = face end
        end
        if t.TextSize ~= size then t.TextSize = size end
        local st = t:FindFirstChildOfClass("UIStroke")
        if st then
            local c = casing or 2
            if st.Thickness ~= c then st.Thickness = c end
            if st.Enabled ~= (c > 0) then st.Enabled = c > 0 end
        end
    end
    local _seqCache = {}
    function gradSeq(key, a, b)
        if not a or not b then return nil end
        local s = _seqCache[key]
        if s and s.a == a and s.b == b then return s.seq end
        local seq = ColorSequence.new({
            ColorSequenceKeypoint.new(0, a),
            ColorSequenceKeypoint.new(0.5, b),
            ColorSequenceKeypoint.new(1, a),
        })
        _seqCache[key] = { a = a, b = b, seq = seq }
        return seq
    end
    function paint(inst, prop, key, mode, solid, ga, gb, rot, spin, now)
        if inst == nil then return end
        if mode == "Gradient" then
            local seq = gradSeq(key, ga, gb)
            if seq then
                if inst[prop] ~= WHITE then inst[prop] = WHITE end
                local ug = inst:FindFirstChildOfClass("UIGradient")
                if ug == nil then ug = Instance.new("UIGradient"); ug.Parent = inst end
                if ug.Color ~= seq then ug.Color = seq end
                local r = rot or 0
                if spin and spin > 0 then r = (r + (now or 0) * spin * 360) % 360 end
                if ug.Rotation ~= r then ug.Rotation = r end
                if not ug.Enabled then ug.Enabled = true end
                return
            end
        end
        local ug = inst:FindFirstChildOfClass("UIGradient")
        if ug and ug.Enabled then ug.Enabled = false end
        local c = solid or WHITE
        if inst[prop] ~= c then inst[prop] = c end
    end
    function healthColor(frac)
        local mode = Config.ESPHealthColorMode or "Ramp"
        if mode == "Solid" then return Config.ESPHealthColor or Color3.fromRGB(61, 224, 122) end
        if mode == "Gradient" then return WHITE end
        if hpRamp then return hpRamp(frac) end
        return Config.ESPHealthColor or Color3.fromRGB(61, 224, 122)
    end
    local _lock = { obj = nil, cand = nil, candT = 0 }
    function resolveLock(bestO, bestD, lockO, lockD, now)
        local lk = _lock
        if bestO == nil then lk.obj = nil; lk.cand = nil; return nil end
        local prev = lk.obj
        if lk.obj == nil or lockO == nil then
            lk.obj = bestO; lk.cand = nil
        elseif bestO == lk.obj then
            lk.cand = nil
        elseif bestD <= (lockD or math.huge) * 0.9 then
            if lk.cand == bestO then
                if (now - (lk.candT or now)) >= 0.5 then lk.obj = bestO; lk.cand = nil end
            else
                lk.cand = bestO; lk.candT = now
            end
        else
            lk.cand = nil
        end
        if lk.obj and lk.obj ~= prev then lk.obj._primT = now end
        return lk.obj
    end
    local SKEL_R15 = {
        {"Head","UpperTorso"},{"UpperTorso","LowerTorso"},
        {"UpperTorso","LeftUpperArm"},{"LeftUpperArm","LeftLowerArm"},{"LeftLowerArm","LeftHand"},
        {"UpperTorso","RightUpperArm"},{"RightUpperArm","RightLowerArm"},{"RightLowerArm","RightHand"},
        {"LowerTorso","LeftUpperLeg"},{"LeftUpperLeg","LeftLowerLeg"},{"LeftLowerLeg","LeftFoot"},
        {"LowerTorso","RightUpperLeg"},{"RightUpperLeg","RightLowerLeg"},{"RightLowerLeg","RightFoot"},
    }
    local SKEL_R6 = {
        {"Head","Torso"},
        {"Torso","Left Arm"},{"Torso","Right Arm"},
        {"Torso","Left Leg"},{"Torso","Right Leg"},
    }
    local FLAG_COLORS = {
        STARING     = Color3.fromRGB(255,  70,  85),
        DEFLECT     = Color3.fromRGB( 53, 215, 199),
        SHIELD      = Color3.fromRGB(255, 194,  75),
        INVINCIBLE  = Color3.fromRGB(255, 215,   0),
        LOW         = Color3.fromRGB(255,  90, 100),
    }
    local _gui, _absLayer = nil, nil
    function mkAbsLayer(g)
        local a = Instance.new("Frame")
        a.Name = "a"; a.BackgroundTransparency = 1; a.BorderSizePixel = 0
        a.Size = UDim2.fromScale(1, 1); a.Position = UDim2.new(); a.ZIndex = 1
        a.Parent = g
        return a
    end
    function espGui()
        if _gui and _gui.Parent then
            if _absLayer == nil or _absLayer.Parent ~= _gui then _absLayer = mkAbsLayer(_gui) end
            return _gui
        end
        local ok, g = pcall(function()
            local s = Instance.new("ScreenGui")
            s.Name = "\0" .. tostring(math.random(1e5, 1e6))
            s.IgnoreGuiInset  = true
            s.ResetOnSpawn    = false
            s.DisplayOrder    = 99990
            s.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
            local parent
            pcall(function() parent = gethui and gethui() end)
            if parent == nil then pcall(function() parent = game:GetService("CoreGui") end) end
            if parent == nil then parent = lp:FindFirstChildOfClass("PlayerGui") end
            s.Parent = parent
            return s
        end)
        if not ok or not g then return nil end
        _gui = g
        _absLayer = mkAbsLayer(g)
        return _gui
    end
    function mkFrame(parent, z)
        local f = Instance.new("Frame")
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.ZIndex = z or 1
        f.Parent = parent
        return f
    end
    function mkLabel(parent, z, align)
        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.BorderSizePixel = 0
        t.RichText = true
        t.TextXAlignment = align or Enum.TextXAlignment.Center
        t.AutomaticSize = Enum.AutomaticSize.XY
        t.Size = UDim2.fromOffset(0, 0)
        t.ZIndex = z or 3
        t.TextColor3 = WHITE
        local st = Instance.new("UIStroke")
        st.Color = BLACK; st.Thickness = 1; st.Transparency = 0
        st.LineJoinMode = Enum.LineJoinMode.Round
        st.Parent = t
        t.Parent = parent
        return t
    end
    function mkList(parent, z, pad, horizAlign, vertAlign)
        local f = mkFrame(parent, z)
        f.AutomaticSize = Enum.AutomaticSize.XY
        f.Size = UDim2.fromOffset(0, 0)
        local l = Instance.new("UIListLayout")
        l.FillDirection        = Enum.FillDirection.Vertical
        l.SortOrder            = Enum.SortOrder.LayoutOrder
        l.Padding              = UDim.new(0, pad or 2)
        l.HorizontalAlignment  = horizAlign or Enum.HorizontalAlignment.Center
        l.VerticalAlignment    = vertAlign or Enum.VerticalAlignment.Top
        l.Parent = f
        return f
    end
    function mkRing(parent, z, colour, thick)
        local f = mkFrame(parent, z)
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.fromScale(0.5, 0.5)
        f.Size = UDim2.fromScale(1, 1)
        local s = Instance.new("UIStroke")
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        s.LineJoinMode    = Enum.LineJoinMode.Miter
        s.Color = colour; s.Thickness = thick; s.Transparency = 0
        s.Parent = f
        return f, s
    end
    function mkCasedRect(parent, z)
        local box = mkFrame(parent, z)
        box.Size = UDim2.fromScale(1, 1)
        -- outline: outer black, mid color, inner black (más legible tipo UE)
        local rIn,  sIn  = mkRing(box, z + 1, INK,   2)
        local rMid, sMid = mkRing(box, z + 2, WHITE, 2)
        local rOut, sOut = mkRing(box, z + 1, INK,   2)
        return box, sMid, sOut, sIn, rMid, rOut, rIn
    end
    function buildTree(o)
        local g = espGui(); if not g then return nil end
        local u = {}
        local root = mkFrame(g, 2)
        root.Name = "r"
        root.Visible = false
        root.Size = UDim2.fromOffset(MIN_W, MIN_H)
        u.root = root
        u.fill = mkFrame(root, 2)
        u.fill.Size = UDim2.fromScale(1, 1)
        u.fill.Visible = false
        u.box, u.boxStroke, u.caseOut, u.caseIn, u.ringMid, u.ringOut, u.ringIn = mkCasedRect(root, 3)
        u.box.Visible = false
        u.corners = {}
        for i = 1, 8 do
            local c = mkFrame(root, 6)
            c.BackgroundTransparency = 0
            c.BackgroundColor3 = WHITE
            c.Visible = false
            local cs = Instance.new("UIStroke")
            cs.Color = INK; cs.Thickness = 1; cs.Transparency = 0
            cs.LineJoinMode = Enum.LineJoinMode.Miter
            cs.Parent = c
            u.corners[i] = c
        end
        local hp = mkFrame(root, 4)
        hp.AnchorPoint = Vector2.new(1, 0)
        hp.Position = UDim2.new(0, -HP_GAP, 0, 0)
        hp.Size = UDim2.new(0, HP_W, 1, 0)
        hp.BackgroundTransparency = 0
        hp.BackgroundColor3 = HPBG
        local hs = Instance.new("UIStroke")
        hs.Color = INK; hs.Thickness = 1; hs.Transparency = 0
        hs.LineJoinMode = Enum.LineJoinMode.Miter
        hs.Parent = hp
        hp.Visible = false
        u.hp = hp
        u.hpGhost = mkFrame(hp, 5)
        u.hpGhost.BackgroundTransparency = 0
        u.hpGhost.BackgroundColor3 = WHITE
        u.hpGhost.AnchorPoint = Vector2.new(0, 1)
        u.hpGhost.Position = UDim2.fromScale(0, 1)
        u.hpGhost.Visible = false
        u.hpFill = mkFrame(hp, 6)
        u.hpFill.BackgroundTransparency = 0
        u.hpFill.BackgroundColor3 = WHITE
        u.hpFill.AnchorPoint = Vector2.new(0, 1)
        u.hpFill.Position = UDim2.fromScale(0, 1)
        u.hpFill.Size = UDim2.fromScale(1, 1)
        u.hpNum = mkLabel(root, 7, Enum.TextXAlignment.Right)
        u.hpNum.AnchorPoint = Vector2.new(1, 0)
        u.hpNum.Position = UDim2.new(0, -HP_GAP - HP_W - 3, 0, 0)
        u.hpNum.Visible = false
        local head = mkList(root, 7, 2, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Bottom)
        head.AnchorPoint = Vector2.new(0.5, 1)
        head.Position = UDim2.new(0.5, 0, 0, -PAD)
        head.Visible = false
        u.head = head
        u.name = mkLabel(head, 8)
        u.name.LayoutOrder = 1
        u.under = mkFrame(head, 8)
        u.under.LayoutOrder = 2
        u.under.BackgroundTransparency = 0
        u.under.BackgroundColor3 = WHITE
        u.under.Size = UDim2.fromOffset(0, 2)
        u.under.Visible = false
        local foot = mkList(root, 7, 2, Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Top)
        foot.AnchorPoint = Vector2.new(0.5, 0)
        foot.Position = UDim2.new(0.5, 0, 1, PAD)
        foot.Visible = false
        u.foot = foot
        u.info = mkLabel(foot, 8)
        u.info.LayoutOrder = 1
        u.info.Visible = false
        local ammo = mkFrame(foot, 8)
        ammo.LayoutOrder = 2
        ammo.BackgroundTransparency = 0
        ammo.BackgroundColor3 = HPBG
        ammo.Size = UDim2.fromOffset(28, 3)
        local as = Instance.new("UIStroke")
        as.Color = INK; as.Thickness = 1; as.Transparency = 0
        as.LineJoinMode = Enum.LineJoinMode.Miter
        as.Parent = ammo
        ammo.Visible = false
        u.ammo = ammo
        u.ammoFill = mkFrame(ammo, 9)
        u.ammoFill.BackgroundTransparency = 0
        u.ammoFill.BackgroundColor3 = WHITE
        u.ammoFill.Size = UDim2.fromScale(1, 1)
        local flags = mkList(root, 7, 3, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Top)
        flags.AnchorPoint = Vector2.new(0, 0)
        flags.Position = UDim2.new(1, FLAG_GAP, 0, 0)
        flags.Visible = false
        u.flags = flags
        u.chips = {}
        for i = 1, 5 do
            local c = mkLabel(flags, 8, Enum.TextXAlignment.Left)
            c.LayoutOrder = i
            c.Visible = false
            u.chips[i] = c
        end
        u.chev = mkLabel(root, 9)
        u.chev.AnchorPoint = Vector2.new(0.5, 1)
        u.chev.Text = GLYPH_TRI
        u.chev.Visible = false
        u.pulse = mkFrame(root, 1)
        u.pulse.AnchorPoint = Vector2.new(0.5, 0.5)
        u.pulse.Position = UDim2.fromScale(0.5, 0.5)
        local ps = Instance.new("UIStroke")
        ps.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        ps.LineJoinMode = Enum.LineJoinMode.Miter
        ps.Thickness = 2; ps.Color = WHITE
        ps.Parent = u.pulse
        u.pulseStroke = ps
        u.pulse.Visible = false
        local a = _absLayer
        u.skel = {}
        u.tracer  = mkFrame(a, 2); u.tracer.AnchorPoint = Vector2.new(0.5, 0.5)
        u.tracer.BackgroundTransparency = 0; u.tracer.BackgroundColor3 = WHITE; u.tracer.Visible = false
        u.look    = mkFrame(a, 2); u.look.AnchorPoint = Vector2.new(0.5, 0.5)
        u.look.BackgroundTransparency = 0; u.look.BackgroundColor3 = WHITE; u.look.Visible = false
        u.dot     = mkFrame(a, 3); u.dot.AnchorPoint = Vector2.new(0.5, 0.5)
        u.dot.BackgroundTransparency = 0; u.dot.BackgroundColor3 = WHITE; u.dot.Visible = false
        local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(1, 0); dc.Parent = u.dot
        local ds = Instance.new("UIStroke"); ds.Color = INK; ds.Thickness = 1; ds.Parent = u.dot
        return u
    end
    function destroyTree(o)
        local u = o.ui; if not u then return end
        pcall(function() if u.root then u.root:Destroy() end end)
        pcall(function() if u.tracer then u.tracer:Destroy() end end)
        pcall(function() if u.look then u.look:Destroy() end end)
        pcall(function() if u.dot then u.dot:Destroy() end end)
        if u.skel then
            for i = 1, #u.skel do pcall(function() u.skel[i]:Destroy() end) end
        end
        o.ui = nil
    end
    local _createBudget = 0
    local CREATE_BUDGET_PER_FRAME = 6 -- OPT lag
    function newDraw(t)
        if not hasDrawing then return nil end
        local ok, d = pcall(screenDraw, t)
        if not ok then return nil end
        d.Visible = false; return d
    end
    function nd(o, key, dtype)
        local d = o[key]
        if d == nil then
            if _createBudget <= 0 then return nil end
            _createBudget = _createBudget - 1
            d = newDraw(dtype) or false
            o[key] = d
            if d then o.drawings[#o.drawings + 1] = d end
        end
        return d or nil
    end
    function ndArr(o, key, dtype, n)
        local arr = o[key]
        if not arr then arr = {}; o[key] = arr end
        for i = #arr + 1, n do
            if _createBudget <= 0 then break end
            local d = newDraw(dtype)
            if not d then break end
            _createBudget = _createBudget - 1
            arr[i] = d
            o.drawings[#o.drawings + 1] = d
        end
        return arr
    end
    function ensureCham(o, char)
        local hl = o.cham
        if hl == nil then
            hl = Instance.new("Highlight")
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Enabled   = false
            hl.Parent    = char
            o.cham = hl
        elseif hl and hl.Parent ~= char then
            pcall(function() hl.Parent = char end)
        end
        return o.cham
    end
    function cleanESP(p)
        local o = State.ESPObjects[p]; if not o then return end
        destroyTree(o)
        for _, d in ipairs(o.drawings or {}) do
            pcall(function() if d.Remove then d:Remove() end end)
        end
        if o.cham and o.cham.Parent then pcall(function() o.cham:Destroy() end) end
        _bboxCache[p]  = nil
        _bboxFrameN[p] = nil
        State.ESPObjects[p] = nil
    end
    function buildESP(player)
        if player == lp then return end
        cleanESP(player)
        local char = player.Character; if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
        local hum  = char:FindFirstChildOfClass("Humanoid")
        local isR6 = (hum and hum.RigType == Enum.HumanoidRigType.R6) or (char:FindFirstChild("Torso") ~= nil)
        local rig  = isR6 and SKEL_R6 or SKEL_R15
        local bones = {}
        for i, pair in ipairs(rig) do
            bones[i] = { a = char:FindFirstChild(pair[1]), b = char:FindFirstChild(pair[2]) }
        end
        local o = { drawings = {}, root = root, rig = rig, bones = bones, _fadeT = tick() }
        o.ui = buildTree(o)
        State.ESPObjects[player] = o
    end
    function bbox(char, player)
        local frame = _bboxFrameN[player] or -999
        if (_espFrame - frame) < 1 then
            local c = _bboxCache[player]
            if c then return c[1], c[2], c[3], c[4] end
            return nil
        end
        _bboxFrameN[player] = _espFrame
        _bboxCache[player] = nil
        local ok, pivot = pcall(function() return char:GetPivot().Position end)
        if not ok or pivot == nil then return nil end
        local sp = cam:WorldToViewportPoint(pivot)
        local depth = sp.Z
        if depth <= 0.5 then return nil end
        local vpY = _ctx.vp and _ctx.vp.Y or 1080
        local tanHalf = math.tan(math.rad(cam.FieldOfView) * 0.5)
        if tanHalf <= 0 then return nil end
        local scale = vpY / (2 * depth * tanHalf)
        local bs = Config.ESPBoxScale or 1
        local rawW = BOX_W_STUDS * scale * bs
        local rawH = BOX_H_STUDS * scale * bs
        if rawH > 4000 or rawW > 3000 then return nil end
        local x = math.floor(sp.X - rawW * 0.5)
        local y = math.floor(sp.Y - rawH * 0.5)
        local bw = math.floor(math.max(MIN_W, rawW))
        local bh = math.floor(math.max(MIN_H, rawH))
        _bboxCache[player] = { x, y, x + bw, y + bh }
        return x, y, x + bw, y + bh
    end
    function hideTree(o)
        local u = o.ui; if not u then return end
        if u.root then u.root.Visible = false end
        if u.tracer then u.tracer.Visible = false end
        if u.look then u.look.Visible = false end
        if u.dot then u.dot.Visible = false end
        if u.skel then for i = 1, #u.skel do u.skel[i].Visible = false end end
    end
    function hideDrawings(o)
        for _, d in ipairs(o.drawings) do d.Visible = false end
    end
    function hideAll(o, force)
        if o._allHidden and not force then return end
        o._allHidden = true
        hideTree(o)
        hideDrawings(o)
        if o.cham then o.cham.Enabled = false end
    end
    function ESP.rebuildAll()
        for p in pairs(State.ESPObjects) do cleanESP(p) end
        if not Config.ESP then return end
        for _, p in ipairs(getSafePlayers()) do
            if p ~= lp and p.Character then buildESP(p) end
        end
    end
    function ESP.registerFace(name, font)
        if type(name) == "string" and font ~= nil then _customFaces[name] = font end
    end
    function espWeapon(o, player)
        local now = tick()
        if not o._wepT or (now - o._wepT) > 0.5 then
            o._wep  = getWeaponName(player)
            o._wepT = now
        end
        return o._wep or "?"
    end
    function paintBox(u, ctx)
        local mode = Config.ESPBoxColorMode or "Solid"
        paint(u.boxStroke, "Color", "box", mode, Config.ESPBoxColor, Config.ESPBoxGradA, Config.ESPBoxGradB,
              Config.ESPGradientRotBox or 0, Config.ESPGradientSpeed, ctx.now)
        -- outline negro más grueso + stroke de color
        local ct = math.floor(math.clamp(Config.ESPCasingThickness or 2, 1, 4))
        local bt = math.floor(math.clamp(Config.ESPBoxThickness or 2, 1, 5))
        if ctx.primary and Config.ESPPrimaryEmphasis then bt = bt + 1 end
        if u.caseOut then
            u.caseOut.Thickness = ct
            u.caseOut.Color = Color3.fromRGB(0, 0, 0)
        end
        if u.caseIn then
            u.caseIn.Thickness = ct
            u.caseIn.Color = Color3.fromRGB(0, 0, 0)
        end
        if u.boxStroke.Thickness ~= bt then u.boxStroke.Thickness = bt end
        local sOut = UDim2.fromScale(1, 1)
        local sMid = UDim2.new(1, -2 * bt, 1, -2 * bt)
        local sIn  = UDim2.new(1, -2 * bt - 2 * ct, 1, -2 * bt - 2 * ct)
        if u.ringOut.Size ~= sOut then u.ringOut.Size = sOut end
        if u.ringMid.Size ~= sMid then u.ringMid.Size = sMid end
        if u.ringIn.Size  ~= sIn  then u.ringIn.Size  = sIn  end
        local tr = math.clamp((Config.ESPBoxTransparency or 0) + (1 - (ctx.fade or 1)), 0, 1)
        if u.boxStroke.Transparency ~= tr then u.boxStroke.Transparency = tr end
        if u.caseOut.Transparency ~= tr then u.caseOut.Transparency = tr end
        if u.caseIn.Transparency  ~= tr then u.caseIn.Transparency  = tr end
    end
    function drawCorners(u, w, h, ctx)
        local len = math.floor(math.clamp(w * (Config.ESPCornerLength or 0.28), 4, math.max(w * 0.48, 6)))
        local th  = math.max(math.floor(Config.ESPBoxThickness or 1), 1)
        local col = Config.ESPBoxColor or WHITE
        local mode = Config.ESPBoxColorMode or "Solid"
        local spec = {
            { 0, 0, len, th }, { 0, 0, th, len },
            { w - len, 0, len, th }, { w - th, 0, th, len },
            { 0, h - th, len, th }, { 0, h - len, th, len },
            { w - len, h - th, len, th }, { w - th, h - len, th, len },
        }
        for i = 1, 8 do
            local c = u.corners[i]
            local s = spec[i]
            c.Position = UDim2.fromOffset(s[1], s[2])
            c.Size     = UDim2.fromOffset(s[3], s[4])
            paint(c, "BackgroundColor3", "box", mode, col, Config.ESPBoxGradA, Config.ESPBoxGradB,
                  Config.ESPGradientRotBox or 0, Config.ESPGradientSpeed, ctx.now)
            local cs = c:FindFirstChildOfClass("UIStroke")
            if cs then
                cs.Color = Color3.fromRGB(0, 0, 0)
                cs.Thickness = math.max(math.floor(Config.ESPCasingThickness or 2), 1)
                cs.Transparency = 0
            end
            c.Visible = true
        end
    end
    function drawHealth(u, o, ctx, frac, hp)
        if not Config.ESPHealth then u.hp.Visible = false; u.hpNum.Visible = false; return end
        local fill = frac
        if Config.ESPHealthSmooth ~= false then
            local s = o._sHP
            if s == nil then s = frac else s = s + (frac - s) * math.clamp((ctx.dt or 0) * 14, 0, 1) end
            o._sHP = s; fill = s
        end
        fill = math.clamp(fill, 0, 1)
        u.hp.Visible = true
        -- fondo más oscuro + borde negro fuerte (outline)
        u.hp.BackgroundColor3 = Color3.fromRGB(8, 10, 14)
        u.hp.BackgroundTransparency = 0.15
        local hs = u.hp:FindFirstChildOfClass("UIStroke")
        if hs then
            hs.Color = Color3.fromRGB(0, 0, 0)
            hs.Thickness = 2
            hs.Transparency = 0
        end
        -- fill con padding interno (más limpio)
        local pad = 1
        u.hpFill.Position = UDim2.new(0, pad, 1, -pad)
        u.hpFill.AnchorPoint = Vector2.new(0, 1)
        u.hpFill.Size = UDim2.new(1, -pad * 2, fill, -pad)
        -- color ramp mejorado: verde vivo → amarillo → rojo
        local col
        if fill > 0.6 then
            local t = (fill - 0.6) / 0.4
            col = Color3.fromRGB(
                math.floor(80 + (255 - 80) * (1 - t)),
                255,
                math.floor(80 * (1 - t))
            )
        elseif fill > 0.3 then
            local t = (fill - 0.3) / 0.3
            col = Color3.fromRGB(255, math.floor(200 * t + 55 * (1 - t)), 40)
        else
            local t = fill / 0.3
            col = Color3.fromRGB(255, math.floor(55 * t), 40)
        end
        if Config.ESPHealthColorMode == "Solid" then
            col = Config.ESPHealthColor or Color3.fromRGB(80, 255, 120)
        end
        u.hpFill.BackgroundColor3 = col
        u.hpFill.BackgroundTransparency = Config.ESPHealthTransparency or 0
        -- ghost damage (hit reciente)
        if Config.ESPHealthGhost and o._ghostT and o._ghostFrac and o._ghostFrac > fill
                and (ctx.now - o._ghostT) < 0.4 then
            u.hpGhost.Visible = true
            u.hpGhost.Position = UDim2.new(0, pad, 1, -pad)
            u.hpGhost.AnchorPoint = Vector2.new(0, 1)
            u.hpGhost.Size = UDim2.new(1, -pad * 2, math.clamp(o._ghostFrac, 0, 1), -pad)
            u.hpGhost.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            u.hpGhost.BackgroundTransparency = 0.4 + 0.55 * math.clamp((ctx.now - o._ghostT) / 0.4, 0, 1)
        else
            u.hpGhost.Visible = false
        end
        -- número de HP siempre legible
        local nm = Config.ESPHealthNumberMode or "Always"
        local show = nm == "Always" or (nm == "OnDamage" and frac < 0.999)
        if show then
            u.hpNum.Visible = true
            u.hpNum.Text = tostring(math.floor(hp or 0))
            styleLabel(u.hpNum, ctx.face, sizeFor((ctx.tsHp or 12) + 1, ctx.dmul), ctx.casing)
            u.hpNum.TextColor3 = col
            u.hpNum.TextTransparency = 1 - (ctx.fade or 1)
            u.hpNum.Position = UDim2.new(0, -HP_GAP - HP_W - 4, math.clamp(1 - fill, 0, 1), 0)
        else
            u.hpNum.Visible = false
        end
    end
    function drawText(u, o, player, ctx, dist, frac)
        local declut = Config.ESPDeclutter and o._declutter
        if Config.ESPName and not declut then
            u.head.Visible = true
            u.name.Visible = true
            styleLabel(u.name, ctx.face, sizeFor(ctx.tsName, ctx.dmul), ctx.casing)
            u.name.Text = (Config.ESPNameMode == "Username") and player.Name or player.DisplayName
            paint(u.name, "TextColor3", "name", Config.ESPNameColorMode or "Solid", Config.ESPNameColor,
                  Config.ESPNameGradA, Config.ESPNameGradB, Config.ESPGradientRotText or 90,
                  Config.ESPGradientSpeed, ctx.now)
            u.name.TextTransparency = math.clamp((Config.ESPNameTransparency or 0) + (1 - (ctx.fade or 1)), 0, 1)
            if Config.ESPNameHealthUnderline and frac then
                local tb = u.name.TextBounds
                u.under.Visible = true
                u.under.Size = UDim2.fromOffset(math.max(math.floor((tb and tb.X or 0) * frac), 1), 2)
                u.under.BackgroundColor3 = healthColor(frac)
            else
                u.under.Visible = false
            end
        else
            u.head.Visible = false
        end
        local showInfo = (Config.ESPDistance or Config.ESPWeapon) and not declut
        local showAmmo = Config.ESPAmmoBar and not declut
        u.foot.Visible = showInfo or showAmmo
        if showInfo then
            local txt
            if Config.ESPWeapon then txt = espWeapon(o, player) end
            if Config.ESPDistance then
                local d = ("%dm"):format(dist)
                txt = txt and (txt .. " " .. GLYPH_MID .. " " .. d) or d
            end
            u.info.Visible = true
            styleLabel(u.info, ctx.face, sizeFor(ctx.tsInfo, ctx.dmul), ctx.casing)
            u.info.Text = txt or ""
            paint(u.info, "TextColor3", "info", Config.ESPInfoColorMode or "Solid", Config.ESPInfoColor,
                  Config.ESPInfoGradA, Config.ESPInfoGradB, Config.ESPGradientRotText or 90,
                  Config.ESPGradientSpeed, ctx.now)
            u.info.TextTransparency = 1 - (ctx.fade or 1)
        else
            u.info.Visible = false
        end
        if showAmmo then
            local ammo, maxAmmo = 30, 30
            pcall(function()
                local item = Rivals.Fighter and Rivals.Fighter:Get(player)
                local eq = item and (item.EquippedItem or (item.GetEquippedItem and item:GetEquippedItem()))
                if eq and eq.Data then
                    ammo = eq.Data.Ammo or 30
                    maxAmmo = eq.Data.MaxAmmo or 30
                end
            end)
            local pct = math.clamp(maxAmmo > 0 and (ammo / maxAmmo) or 1, 0, 1)
            u.ammo.Visible = true
            u.ammo.Size = UDim2.fromOffset(math.max(math.floor(ctx.boxW * 0.9), 12), 3)
            u.ammoFill.Size = UDim2.new(pct, 0, 1, 0)
            paint(u.ammoFill, "BackgroundColor3", "mark", Config.ESPMarkColorMode or "Solid",
                  Config.ESPMarkColor, Config.ESPMarkGradA, Config.ESPMarkGradB, 0,
                  Config.ESPGradientSpeed, ctx.now)
        else
            u.ammo.Visible = false
        end
    end
    function drawFlags(u, o, player, ctx, char, frac)
        local n = 0
        function add(key, label)
            if n >= 5 then return end
            n = n + 1
            local c = u.chips[n]
            local mode = Config.ESPFlagColorMode or "PerFlag"
            c.Visible = true
            styleLabel(c, ctx.face, sizeFor(ctx.tsChip, ctx.dmul), ctx.casing)
            c.Text = label
            paint(c, "TextColor3", "flag", mode,
                  (mode == "PerFlag") and (FLAG_COLORS[key] or WHITE) or Config.ESPFlagColor,
                  Config.ESPFlagGradA, Config.ESPFlagGradB, Config.ESPGradientRotText or 90,
                  Config.ESPGradientSpeed, ctx.now)
            c.TextTransparency = 1 - (ctx.fade or 1)
        end
        if Config.ESPFlagStaring then
            local head = char:FindFirstChild("Head")
            local myPos = ctx.myRoot and ctx.myRoot.Position
            if head and myPos then
                local toMe = myPos - head.Position
                if toMe.Magnitude > 1 then
                    toMe = toMe.Unit
                    local look = head.CFrame.LookVector
                    if (look.X * toMe.X + look.Y * toMe.Y + look.Z * toMe.Z) > 0.965 then add("STARING", "[STARING]") end
                end
            end
        end
        if Config.ESPFlagDeflect and isDeflecting and isDeflecting(player) then add("DEFLECT", "[DEFLECT]") end
        if Config.ESPFlagShield then
            local wep = espWeapon(o, player)
            if wep and (wep:find("Shield") or wep:find("Riot")) then add("SHIELD", "[SHIELD]") end
        end
        if Config.ESPFlagInvincible and isSpawnProtected and isSpawnProtected(player) then add("INVINCIBLE", "[INVINCIBLE]") end
        if Config.ESPFlagLowHP and frac and frac <= 0.25 then add("LOW", "[LOW HP]") end
        u.flags.Visible = n > 0
        for i = n + 1, 5 do u.chips[i].Visible = false end
    end
    function segment(f, ax, ay, bx, by, thick, transp)
        local dx, dy = bx - ax, by - ay
        local len = math.sqrt(dx * dx + dy * dy)
        if len < 1 then f.Visible = false; return end
        f.Position = UDim2.fromOffset(math.floor((ax + bx) * 0.5), math.floor((ay + by) * 0.5))
        f.Size = UDim2.fromOffset(math.floor(len + 0.5), thick)
        f.Rotation = math.deg(math.atan2(dy, dx))
        f.BackgroundTransparency = transp or 0
        f.Visible = true
    end
    function drawSkeleton(u, o, ctx)
        if not Config.ESPSkeleton then
            if u.skel then for i = 1, #u.skel do u.skel[i].Visible = false end end
            return
        end
        local nb = #o.bones
        for i = #u.skel + 1, nb do
            local f = mkFrame(_absLayer, 2)
            f.AnchorPoint = Vector2.new(0.5, 0.5)
            f.BackgroundTransparency = 0
            f.BackgroundColor3 = WHITE
            local s = Instance.new("UIStroke")
            s.Color = INK; s.Thickness = 1; s.Transparency = 0
            s.Parent = f
            f.Visible = false
            u.skel[i] = f
        end
        if (not o._skelPts) or (_espFrame - (o._skelFrame or -9)) >= 4 then
            o._skelFrame = _espFrame
            local pts = o._skelPts; if not pts then pts = {}; o._skelPts = pts end
            for i, pair in ipairs(o.bones) do
                local pa, pb = pair.a, pair.b
                local e = pts[i]; if not e then e = {}; pts[i] = e end
                if pa and pb and pa.Parent and pb.Parent then
                    local s1, v1 = cam:WorldToViewportPoint(pa.Position)
                    local s2, v2 = cam:WorldToViewportPoint(pb.Position)
                    if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                        e.ok = true; e.ax = s1.X; e.ay = s1.Y; e.bx = s2.X; e.by = s2.Y
                    else e.ok = false end
                else e.ok = false end
            end
        end
        local th = math.max(math.floor(Config.ESPSkeletonThickness or 1), 1)
        local mode = Config.ESPSkeletonColorMode or "Solid"
        local pts = o._skelPts
        for i = 1, nb do
            local f = u.skel[i]
            local e = pts and pts[i]
            if f then
                if e and e.ok then
                    segment(f, e.ax, e.ay, e.bx, e.by, th, Config.ESPSkeletonTransparency or 0)
                    paint(f, "BackgroundColor3", "skel", mode, Config.ESPSkeletonColor,
                          Config.ESPSkeletonGradA, Config.ESPSkeletonGradB, 0, Config.ESPGradientSpeed, ctx.now)
                else f.Visible = false end
            end
        end
    end
    function drawAbsExtras(u, o, ctx, char, minX, minY, maxX, maxY)
        if Config.ESPTracers then
            local vp = ctx.vp
            local ox, oy = vp.X * 0.5, vp.Y
            local m = Config.ESPTracerOrigin
            if m == "Top" then oy = 0
            elseif m == "Middle" then oy = vp.Y * 0.5
            elseif m == "Mouse" then
                local mp; pcall(function() mp = UserInputService:GetMouseLocation() end)
                if mp then ox, oy = mp.X, mp.Y end
            end
            segment(u.tracer, ox, oy, (minX + maxX) * 0.5, maxY,
                    math.max(math.floor(Config.ESPTracerThickness or 1), 1), Config.ESPTracerTransparency or 0)
            paint(u.tracer, "BackgroundColor3", "tracer", Config.ESPTracerColorMode or "Solid",
                  Config.ESPTracerColor, Config.ESPTracerGradA, Config.ESPTracerGradB, 0,
                  Config.ESPGradientSpeed, ctx.now)
        else u.tracer.Visible = false end
        if Config.ESPHeadDot then
            local head = char:FindFirstChild("Head")
            local ok = false
            if head then
                local hsp, inv = cam:WorldToViewportPoint(head.Position)
                if inv and hsp.Z > 0 then
                    local r = math.clamp(Config.ESPHeadDotSize or 4, 2, 16)
                    u.dot.Position = UDim2.fromOffset(math.floor(hsp.X), math.floor(hsp.Y))
                    u.dot.Size = UDim2.fromOffset(r * 2, r * 2)
                    paint(u.dot, "BackgroundColor3", "mark", Config.ESPMarkColorMode or "Solid",
                          Config.ESPMarkColor, Config.ESPMarkGradA, Config.ESPMarkGradB, 0,
                          Config.ESPGradientSpeed, ctx.now)
                    u.dot.Visible = true; ok = true
                end
            end
            if not ok then u.dot.Visible = false end
        else u.dot.Visible = false end
        if Config.ESPLookLine then
            local head = char:FindFirstChild("Head")
            local ok = false
            if head then
                local look = head.CFrame.LookVector
                local p1 = head.Position
                local p2 = p1 + look * math.clamp(Config.ESPLookLineLength or 8, 2, 32)
                local s1, v1 = cam:WorldToViewportPoint(p1)
                local s2, v2 = cam:WorldToViewportPoint(p2)
                if v1 and v2 and s1.Z > 0 and s2.Z > 0 then
                    segment(u.look, s1.X, s1.Y, s2.X, s2.Y, 1, 0)
                    paint(u.look, "BackgroundColor3", "mark", Config.ESPMarkColorMode or "Solid",
                          Config.ESPMarkColor, Config.ESPMarkGradA, Config.ESPMarkGradB, 0,
                          Config.ESPGradientSpeed, ctx.now)
                    ok = true
                end
            end
            if not ok then u.look.Visible = false end
        else u.look.Visible = false end
    end
    function renderPlayer(player, o)
        local ctx  = _ctx
        local char = player.Character
        if not char or not o.root or not o.root.Parent then cleanESP(player); return end
        if not o.root:IsA("BasePart") then cleanESP(player); return end
        local rootPos = o.root.Position
        if not rootPos then cleanESP(player); return end
        if not o.ui then o.ui = buildTree(o); if not o.ui then return end end
        local u = o.ui
        local vp     = ctx.vp
        local myRoot = ctx.myRoot
        local dist   = o._dist
        if not dist then
            dist = (myRoot and myRoot.Position and rootPos)
                and (myRoot.Position - rootPos).Magnitude or 0
        end
        local oor = dist > Config.ESPMaxDistance
        if (Config.ESPTeamCheck and isTeammate(player)) or (not isAlive(player)) then
            hideAll(o); return
        end
        if (Config.ESPRadar or Config.ESPChamsVisSplit or Config.ESPPeekAlert
                or (Config.ESPChams and Config.ESPChamsStyle == "Ghost"))
            and not oor and (_espFrame - (o._visFrame or -99)) >= 3 then
            pcall(function() o._vis = isVisible(rootPos) end)
            o._visFrame = _espFrame
        end
        if oor then
            if o.cham then o.cham.Enabled = false end
            hideTree(o); hideDrawings(o); o._allHidden = true
            return
        end
        if o._allHidden and Config.ESPFadeIn then o._fadeT = ctx.now end
        o._allHidden = false
        local fade = 1
        if Config.ESPFadeIn and o._fadeT then
            fade = math.clamp((ctx.now - o._fadeT) / 0.12, 0, 1)
        end
        ctx.fade = fade
        ctx.primary = o._primary and true or false
        ctx.dmul = distMul(dist)
        local minX, minY, maxX, maxY = bbox(char, player)
        if not minX then
            hideTree(o)
        else
            local w, h = maxX - minX, maxY - minY
            ctx.boxW = w
            u.root.Position = UDim2.fromOffset(minX, minY)
            u.root.Size     = UDim2.fromOffset(w, h)
            u.root.Visible  = true
            local hp, mh, frac
            if Config.ESPHealth or Config.ESPHealthGhost or Config.ESPFlagLowHP or Config.ESPNameHealthUnderline then
                pcall(function() hp, mh = getHealth(player) end)
                if hp ~= nil then frac = math.clamp((mh or 0) > 0 and hp / mh or 0, 0, 1) end
            end
            local prevHP = o._lastHP
            if Config.ESPHealthGhost and prevHP and frac and frac < prevHP - 0.005 then
                if not o._ghostT or (ctx.now - o._ghostT) >= 0.35 then o._ghostFrac = prevHP
                else o._ghostFrac = math.max(o._ghostFrac or prevHP, prevHP) end
                o._ghostT = ctx.now
            end
            if Config.ESPHealTick and prevHP and frac and frac > prevHP + 0.005 then o._healT = ctx.now end
            local style = Config.ESPBoxStyle or "Full Box"
            local corners = Config.ESPBoxBrackets or (style == "Corner Brackets")
            if Config.ESPBox and not corners then
                u.box.Visible = true
                paintBox(u, ctx)
                for i = 1, 8 do u.corners[i].Visible = false end
            elseif Config.ESPBox then
                u.box.Visible = false
                drawCorners(u, w, h, ctx)
            else
                u.box.Visible = false
                for i = 1, 8 do u.corners[i].Visible = false end
            end
            if Config.ESPBoxFill then
                u.fill.Visible = true
                u.fill.BackgroundTransparency = Config.ESPBoxFillTransparency or 0.75
                paint(u.fill, "BackgroundColor3", "fill", Config.ESPBoxColorMode or "Solid",
                      Config.ESPBoxFillColor, Config.ESPBoxGradA, Config.ESPBoxGradB,
                      Config.ESPGradientRotBox or 0, Config.ESPGradientSpeed, ctx.now)
            else u.fill.Visible = false end
            drawHealth(u, o, ctx, frac or 1, hp)
            drawText(u, o, player, ctx, dist, frac)
            drawFlags(u, o, player, ctx, char, frac)
            if Config.ESPLockChevron and o._primary then
                local pt = o._primT and math.clamp((ctx.now - o._primT) / 0.14, 0, 1) or 1
                local e = 1 - (1 - pt) * (1 - pt)
                u.chev.Visible = true
                styleLabel(u.chev, ctx.face, sizeFor(ctx.tsChip + 2, ctx.dmul), ctx.casing)
                u.chev.TextColor3 = Color3.fromRGB(255, 194, 75)
                u.chev.TextTransparency = 1 - e
                u.chev.Position = UDim2.new(0.5, 0, 0, -PAD - math.floor(sizeFor(ctx.tsName, ctx.dmul) * 1.7) - math.floor((1 - e) * 6))
            else u.chev.Visible = false end
            local pulseT, pulseCol = nil, nil
            if Config.ESPPeekAlert then
                local v = o._vis and true or false
                if v and not o._peekWasVis then o._peekT = ctx.now end
                o._peekWasVis = v
                if o._peekT and (ctx.now - o._peekT) < 0.14 then
                    pulseT = (ctx.now - o._peekT) / 0.14; pulseCol = Config.ESPBoxColor or WHITE
                end
            end
            if Config.ESPHealTick and o._healT and (ctx.now - o._healT) < 0.2 then
                pulseT = (ctx.now - o._healT) / 0.2; pulseCol = Color3.fromRGB(61, 224, 122)
            end
            if pulseT then
                local grow = math.floor(4 + pulseT * 6)
                u.pulse.Visible = true
                u.pulse.Size = UDim2.new(1, grow * 2, 1, grow * 2)
                u.pulseStroke.Color = pulseCol
                u.pulseStroke.Transparency = pulseT
            else u.pulse.Visible = false end
            if frac ~= nil then o._lastHP = frac end
        end
        drawSkeleton(u, o, ctx)
        if minX then drawAbsExtras(u, o, ctx, char, minX, minY, maxX, maxY)
        else
            u.tracer.Visible = false; u.dot.Visible = false; u.look.Visible = false
        end
        if Config.ESPThreatCount then
            local tsp = cam:WorldToViewportPoint(rootPos)
            local tOn = tsp.Z > 0 and tsp.X >= 0 and tsp.X <= vp.X and tsp.Y >= 0 and tsp.Y <= vp.Y
            if not tOn then ctx.threat = (ctx.threat or 0) + 1 end
        end
        if Config.ESPArrows then
            local ar = nd(o, "arrow", "Triangle")
            if ar then
                local asp = cam:WorldToViewportPoint(rootPos)
                local onScreen = asp.Z > 0 and asp.X >= 0 and asp.X <= vp.X and asp.Y >= 0 and asp.Y <= vp.Y
                if not onScreen then
                    local cen  = Vector2.new(vp.X * 0.5, vp.Y * 0.5)
                    local adir = Vector2.new(asp.X - cen.X, asp.Y - cen.Y)
                    if asp.Z <= 0 then adir = Vector2.new(-adir.X, -adir.Y) end
                    if adir.Magnitude < 1 then adir = Vector2.new(0, -1) end
                    adir = adir.Unit
                    local edge = cen + adir * (math.min(vp.X, vp.Y) * 0.38)
                    local perp = Vector2.new(-adir.Y, adir.X)
                    local aAlpha = 1 - (Config.ESPBoxTransparency or 0)
                    if Config.ESPArrowDistFade then
                        aAlpha = aAlpha * (1 - 0.65 * math.clamp(dist / math.max(Config.ESPMaxDistance, 1), 0, 1))
                    end
                    ar.Filled = false
                    ar.PointA = edge + adir * 20
                    ar.PointB = (edge - adir * 10) + perp * 8
                    ar.PointC = (edge - adir * 10) - perp * 8
                    ar.Color = Config.ESPBoxColor or WHITE
                    ar.Transparency = aAlpha; ar.Visible = true
                    if Config.ESPArrowDistLabel then
                        local dl = nd(o, "arrowDist", "Text")
                        if dl then
                            local lpos = edge - adir * 24
                            dl.Font = 3; dl.Size = 10; dl.Center = true; dl.Outline = true
                            dl.Color = Config.ESPInfoColor or WHITE
                            dl.Text = ("%dm"):format(dist)
                            dl.Position = Vector2.new(math.floor(lpos.X), math.floor(lpos.Y - 5))
                            dl.Transparency = aAlpha; dl.Visible = true
                        end
                    elseif o.arrowDist then o.arrowDist.Visible = false end
                else
                    ar.Visible = false
                    if o.arrowDist then o.arrowDist.Visible = false end
                end
            end
        elseif o.arrow then
            o.arrow.Visible = false
            if o.arrowDist then o.arrowDist.Visible = false end
        end
        if Config.ESPChams then
            local hl = ensureCham(o, char)
            if hl then
                local vc = Config.ESPChamsVisSplit
                    and (o._vis and (isTeammate(player) and Config.ColorTeam or Config.ColorEnemy)
                                 or (isTeammate(player) and Config.ColorTeamOcc or Config.ColorEnemyOcc))
                    or nil
                local state = vc or Config.ESPChamsFillColor
                local style2 = Config.ESPChamsStyle
                if style2 == "Shade" then
                    hl.FillColor = state; hl.OutlineColor = WHITE
                    hl.FillTransparency = 0.62; hl.OutlineTransparency = 0; hl.Enabled = true
                elseif style2 == "Neon" then
                    hl.FillColor = state; hl.OutlineColor = vc or Config.ESPChamsOutlineColor
                    hl.FillTransparency = 0.88; hl.OutlineTransparency = 0; hl.Enabled = true
                elseif style2 == "Ghost" then
                    hl.FillColor = state; hl.OutlineColor = WHITE
                    hl.FillTransparency = 1; hl.OutlineTransparency = 0.25; hl.Enabled = not o._vis
                else
                    hl.FillColor = vc or Config.ESPChamsFillColor
                    hl.OutlineColor = vc or Config.ESPChamsOutlineColor
                    hl.FillTransparency = Config.ESPChamsFillTransparency
                    hl.OutlineTransparency = Config.ESPChamsOutlineTransparency
                    hl.Enabled = true
                end
            end
        elseif o.cham then o.cham.Enabled = false end
    end
    function _byDist(a, b)
        local ad, bd = a.d, b.d
        if ad ~= ad then return false end
        if bd ~= bd then return true end
        return ad < bd
    end
    function doDeclutter(ctx)
        local myPos = ctx.myRoot and ctx.myRoot.Position
        local n = 0
        for player, o in pairs(State.ESPObjects) do
            o._declutter = false
            local c = _bboxCache[player]
            if c and o.root and o.root.Parent then
                n = n + 1
                local e = _dcArr[n]; if not e then e = {}; _dcArr[n] = e end
                e.o = o; e.c = c
                local rp = o.root.Position
                e.d = (myPos and rp) and (myPos - rp).Magnitude or math.huge
            end
        end
        for i = #_dcArr, n + 1, -1 do _dcArr[i] = nil end
        table.sort(_dcArr, _byDist)
        for i = 1, n - 1 do
            local A = _dcArr[i]; local ca = A.c
            local aMinX, aMinY, aMaxX, aMaxY = ca[1], ca[2], ca[3], ca[4]
            for j = i + 1, n do
                local B = _dcArr[j]
                if not B.o._declutter then
                    local cb = B.c
                    local ix = math.min(aMaxX, cb[3]) - math.max(aMinX, cb[1])
                    local iy = math.min(aMaxY, cb[4]) - math.max(aMinY, cb[2])
                    if ix > 0 and iy > 0 then
                        local barea = (cb[3] - cb[1]) * (cb[4] - cb[2])
                        if barea > 0 and (ix * iy) / barea > 0.6 then B.o._declutter = true end
                    end
                end
            end
        end
    end
    function renderRadar(ctx)
        if not Config.ESPRadar then
            for _, d in ipairs(_radarO.drawings) do d.Visible = false end
            return
        end
        if (_espFrame % 2) ~= 0 then return end
        local vp = ctx.vp; if not vp then return end
        local R     = math.max((Config.ESPRadarSize or 180) * 0.5, 10)
        local inset = Config.ESPRadarInset or 20
        local cx    = vp.X - inset - R
        local cy    = inset + R
        local disc = nd(_radarO, "disc", "Circle")
        if disc then
            disc.Filled = true; disc.NumSides = 32; disc.Radius = R
            disc.Position = Vector2.new(cx, cy)
            disc.Color = Color3.fromRGB(13, 18, 25)
            disc.Transparency = 0.62; disc.Visible = true
        end
        local rring = nd(_radarO, "rangeRing", "Circle")
        if rring then
            rring.Filled = false; rring.Thickness = 1; rring.NumSides = 28; rring.Radius = R * 0.5
            rring.Position = Vector2.new(cx, cy); rring.Color = WHITE
            rring.Transparency = 0.10; rring.Visible = true
        end
        local myPos = ctx.myRoot and ctx.myRoot.Position
        if not myPos then return end
        local rot = 0
        if Config.ESPRadarRotate then
            local look = cam.CFrame.LookVector
            rot = -math.atan2(look.X, look.Z)
        end
        local cosR, sinR = math.cos(rot), math.sin(rot)
        local range = math.max(Config.ESPRadarRange or 250, 1)
        local ticks = ndArr(_radarO, "ticks", "Line", 4)
        for i = 0, 3 do
            local L = ticks[i + 1]
            if L then
                local ang = i * (math.pi * 0.5) + rot
                local dxT, dyT = math.sin(ang), -math.cos(ang)
                L.From = Vector2.new(cx + dxT * (R - 6), cy + dyT * (R - 6))
                L.To   = Vector2.new(cx + dxT * R, cy + dyT * R)
                L.Thickness = 1
                if i == 0 then L.Color = Color3.fromRGB(255, 194, 75); L.Transparency = 0.9
                else L.Color = WHITE; L.Transparency = 0.35 end
                L.Visible = true
            end
        end
        if Config.ESPRadarGrid then
            local grid = ndArr(_radarO, "grid", "Line", 2)
            for gi = 1, 2 do
                local L = grid[gi]
                if L then
                    local ang = rot + (gi - 1) * (math.pi * 0.5)
                    local gx, gy = math.sin(ang), -math.cos(ang)
                    L.From = Vector2.new(cx - gx * R, cy - gy * R)
                    L.To   = Vector2.new(cx + gx * R, cy + gy * R)
                    L.Thickness = 1
                    L.Color = Color3.fromRGB(168, 180, 192)
                    L.Transparency = 0.10
                    L.Visible = true
                end
            end
        elseif _radarO.grid then
            for _, L in ipairs(_radarO.grid) do L.Visible = false end
        end
        if Config.ESPRadarSweep then
            local sw = ndArr(_radarO, "sweep", "Line", 3)
            local baseAng = ((ctx.now or 0) % 4) / 4 * (math.pi * 2) + rot
            for si = 1, 3 do
                local L = sw[si]
                if L then
                    local ang = baseAng - (si - 1) * 0.12
                    local sx, sy = math.sin(ang), -math.cos(ang)
                    L.From = Vector2.new(cx, cy)
                    L.To   = Vector2.new(cx + sx * (R - 2), cy + sy * (R - 2))
                    L.Thickness = si == 1 and 2 or 1
                    L.Color = Color3.fromRGB(255, 194, 75)
                    L.Transparency = si == 1 and 0.35 or (si == 2 and 0.18 or 0.08)
                    L.Visible = true
                end
            end
        elseif _radarO.sweep then
            for _, L in ipairs(_radarO.sweep) do L.Visible = false end
        end
        local idx = 0
        local closestIdx, closestH = nil, math.huge
        local closestPx, closestPy, closestDotR = 0, 0, 0
        for player, o in pairs(State.ESPObjects) do
            local root = o.root
            if root and root.Parent then
                local rp = root.Position
                local dx = rp.X - myPos.X
                local dz = rp.Z - myPos.Z
                local sx = (dx / range) * R
                local sz = (dz / range) * R
                local rx = sx * cosR - sz * sinR
                local rz = sx * sinR + sz * cosR
                local mag = math.sqrt(rx * rx + rz * rz)
                if mag > R then rx = rx / mag * R; rz = rz / mag * R end
                idx = idx + 1
                local px, py = cx + rx, cy + rz
                local hdist  = math.sqrt(dx * dx + dz * dz)
                local dotR   = math.clamp(5 - (hdist / range) * 2, 3, 5)
                local team   = isTeammate(player)
                local filled = (not Config.ESPRadarVisSplit) or (o._vis and true or false)
                local col
                if Config.ESPRadarVisSplit and not o._vis then
                    col = team and Config.ColorTeamOcc or Config.ColorEnemyOcc
                else
                    col = team and Config.ColorTeam or Config.ColorEnemy
                end
                if hdist < closestH then closestH = hdist; closestIdx = idx; closestPx = px; closestPy = py; closestDotR = dotR end
                local dsh = ndArr(_radarO, "dotShadow", "Circle", idx)
                local sD = dsh[idx]
                if sD then
                    sD.Filled = true; sD.NumSides = 12; sD.Radius = dotR + 1
                    sD.Position = Vector2.new(px, py); sD.Color = BLACK
                    sD.Transparency = 0.6; sD.Visible = true
                end
                local dots = ndArr(_radarO, "dots", "Circle", idx)
                local d = dots[idx]
                if d then
                    d.Filled = filled
                    if not filled then d.Thickness = 1 end
                    d.NumSides = 12; d.Radius = dotR
                    d.Position = Vector2.new(px, py); d.Color = col
                    d.Transparency = 1; d.Visible = true
                end
                local chevs = ndArr(_radarO, "chev", "Triangle", idx)
                local cv = chevs[idx]
                if cv then
                    local dy = rp.Y - myPos.Y
                    if dy > 6 or dy < -6 then
                        local dir = dy > 6 and -1 or 1
                        cv.Filled = false
                        cv.PointA = Vector2.new(px, py + dir * (dotR + 4))
                        cv.PointB = Vector2.new(px - 3, py + dir * (dotR + 1))
                        cv.PointC = Vector2.new(px + 3, py + dir * (dotR + 1))
                        cv.Color = col; cv.Transparency = 1; cv.Visible = true
                    else cv.Visible = false end
                end
            end
        end
        local nearRing = nd(_radarO, "nearRing", "Circle")
        if nearRing then
            if closestIdx then
                local pulse = 1 + 0.28 * (0.5 + 0.5 * math.sin((ctx.now or 0) * 1.6 * math.pi * 2))
                nearRing.Filled = false; nearRing.Thickness = 1.2; nearRing.NumSides = 24
                nearRing.Radius = (closestDotR + 3) * pulse
                nearRing.Position = Vector2.new(closestPx, closestPy)
                nearRing.Color = Color3.fromRGB(255, 194, 75)
                nearRing.Transparency = 1; nearRing.Visible = true
            else
                nearRing.Visible = false
            end
        end
        if _radarO.dots      then for i = idx + 1, #_radarO.dots do _radarO.dots[i].Visible = false end end
        if _radarO.dotShadow then for i = idx + 1, #_radarO.dotShadow do _radarO.dotShadow[i].Visible = false end end
        if _radarO.chev      then for i = idx + 1, #_radarO.chev do _radarO.chev[i].Visible = false end end
        local selfTri = nd(_radarO, "self", "Triangle")
        if selfTri then
            selfTri.Filled = true
            selfTri.PointA = Vector2.new(cx, cy - 5)
            selfTri.PointB = Vector2.new(cx - 4, cy + 4)
            selfTri.PointC = Vector2.new(cx + 4, cy + 4)
            selfTri.Color = Color3.fromRGB(255, 194, 75); selfTri.Transparency = 1; selfTri.Visible = true
        end
        local rimShadow = nd(_radarO, "rimShadow", "Circle")
        if rimShadow then
            rimShadow.Filled = false; rimShadow.Thickness = 2; rimShadow.NumSides = 32; rimShadow.Radius = R
            rimShadow.Position = Vector2.new(cx, cy); rimShadow.Color = BLACK
            rimShadow.Transparency = 0.55; rimShadow.Visible = true
        end
        local rim = nd(_radarO, "rim", "Circle")
        if rim then
            rim.Filled = false; rim.Thickness = 1; rim.NumSides = 32; rim.Radius = R
            rim.Position = Vector2.new(cx, cy)
            rim.Color = Color3.fromRGB(168, 180, 192)
            rim.Transparency = 0.45; rim.Visible = true
        end
    end
    function render()
        local _now = tick()
        local _dt  = _now - _lastRenderT
        -- OPT FPS: perf ~10 Hz ESP, normal ~30 Hz (menos carga en RenderStepped)
        local espHz = 0.033
        if config and config.ESPPerfMode ~= false then
            espHz = tonumber(config.ESPUpdateInterval) or 0.1 -- ~10 fps ESP
        end
        if _now - _lastRenderT < espHz then return end
        _lastRenderT = _now
        _espFrame = _espFrame + 1
        _createBudget = CREATE_BUDGET_PER_FRAME
        if not Config.ESP then
            State.PrimaryTarget = nil
            for _, o in pairs(State.ESPObjects) do hideAll(o, true) end
            for _, d in ipairs(_radarO.drawings) do d.Visible = false end
            for _, d in ipairs(_module.drawings) do d.Visible = false end
            return
        end
        local ctx = _ctx
        ctx.vp     = cam.ViewportSize
        ctx.myRoot = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        ctx.dt     = math.clamp(_dt, 0, 0.1)
        ctx.now    = _now
        ctx.threat = 0
        ctx.face   = faceFor(Config.ESPFont or "Code")
        local ts = (ctx.vp.Y / BASE_H) * (Config.ESPTextScale or 1)
        ctx.tsName = typePx(Config.ESPTextSize or 14, ts)
        ctx.tsInfo = typePx(Config.ESPInfoTextSize or 12, ts)
        ctx.tsHp   = typePx(Config.ESPHealthTextSize or 11, ts)
        ctx.tsChip = typePx(10, ts)
        ctx.casing = math.floor(math.clamp(Config.ESPTextCasing or 1, 0, 4))
        -- declutter solo fuera de perf (caro)
        if config and config.ESPPerfMode == false and Config.ESPDeclutter and (ctx.now - _dcLastT) >= 0.2 then
            _dcLastT = ctx.now; pcall(doDeclutter, ctx)
        end
        local cap = (config and config.ESPMaxPlayers) or Config.ESPMaxPlayers or 8
        cap = math.clamp(tonumber(cap) or 8, 1, 25)
        if cap and cap > 0 then
            local arr = _renderArr
            local n = 0
            local myPos = ctx.myRoot and ctx.myRoot.Position
            for player, o in pairs(State.ESPObjects) do
                n = n + 1
                local e = arr[n]; if not e then e = {}; arr[n] = e end
                e.p = player; e.o = o
                local rp = o.root and o.root.Parent and o.root.Position
                e.d = (myPos and rp) and (myPos - rp).Magnitude or math.huge
            end
            for i = #arr, n + 1, -1 do arr[i] = nil end
            pcall(table.sort, arr, _byDist)
            if Config.ESPPrimaryEmphasis or Config.ESPLockChevron or Config.FXTargetInfo then
                for i = 1, n do arr[i].o._primary = false end
                local bestO = arr[1] and arr[1].o
                local bestD = (arr[1] and arr[1].d) or math.huge
                local lockO, lockD
                for i = 1, n do if arr[i].o == _lock.obj then lockO = arr[i].o; lockD = arr[i].d; break end end
                local locked = resolveLock(bestO, bestD, lockO, lockD, ctx.now)
                State.PrimaryTarget = nil
                if locked then
                    locked._primary = true
                    for i = 1, n do if arr[i].o == locked then State.PrimaryTarget = arr[i].p break end end
                end
            else
                State.PrimaryTarget = nil
            end
            for i = 1, n do
                local e = arr[i]
                if i <= cap then
                    e.o._dist = e.d
                    pcall(renderPlayer, e.p, e.o)
                else
                    hideAll(e.o)
                end
            end
        else
            if Config.ESPPrimaryEmphasis or Config.ESPLockChevron or Config.FXTargetInfo then
                local myPos = ctx.myRoot and ctx.myRoot.Position
                local bestD, bestO = math.huge, nil
                local lockO, lockD
                for player, o in pairs(State.ESPObjects) do
                    o._primary = false
                    local rp = o.root and o.root.Parent and o.root.Position
                    local d = (myPos and rp) and (myPos - rp).Magnitude or math.huge
                    if d < bestD then bestD = d; bestO = o end
                    if o == _lock.obj then lockO = o; lockD = d end
                end
                local locked = resolveLock(bestO, bestD, lockO, lockD, ctx.now)
                State.PrimaryTarget = nil
                if locked then
                    locked._primary = true
                    for player, o in pairs(State.ESPObjects) do
                        if o == locked then State.PrimaryTarget = player break end
                    end
                end
            else
                State.PrimaryTarget = nil
            end
            local perf = config and config.ESPPerfMode ~= false
            local idx = 0
            for player, o in pairs(State.ESPObjects) do
                o._dist = nil
                idx = idx + 1
                -- en perf: half players each frame
                if not (perf and ((idx + _espFrame) % 2 == 1)) then
                    pcall(renderPlayer, player, o)
                end
            end
        end
        if not (config and config.ESPPerfMode ~= false) then
            pcall(renderRadar, ctx)
        end
        if Config.ESPThreatCount then
            pcall(function()
                local t = nd(_module, "threat", "Text")
                if t then
                    local cnt = ctx.threat or 0
                    if cnt > 0 then
                        t.Font = 3; t.Size = 14; t.Center = true; t.Outline = true
                        t.Color = Config.ColorEnemy
                        t.Text = cnt .. " <"
                        t.Position = Vector2.new(math.floor(ctx.vp.X * 0.5), math.floor(ctx.vp.Y * 0.5 + 28))
                        t.Transparency = 1; t.Visible = true
                    else t.Visible = false end
                end
            end)
        elseif _module.threat then _module.threat.Visible = false end
    end
    function ESP.init()
        for _, p in ipairs(getSafePlayers()) do
            if p ~= lp then
                p.CharacterAdded:Connect(function()
                    task.wait(0.5); if Config.ESP then buildESP(p) end
                end)
            end
        end
        Players.PlayerAdded:Connect(function(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.5); if Config.ESP then buildESP(p) end
            end)
        end)
        Players.PlayerRemoving:Connect(function(p) cleanESP(p) end)
        if Config.ESP and not _renderConn then
            _renderConn = RunService.Heartbeat:Connect(render)
            ESP.rebuildAll()
        end
    end
    function ESP.enable()
        Config.ESP = true
        -- hooks de respawn (si solo enable y no init, no se reconstruía al morir)
        if not ESP._hooksReady then
            ESP._hooksReady = true
            for _, p in ipairs(getSafePlayers()) do
                if p ~= lp then
                    p.CharacterAdded:Connect(function()
                        task.spawn(function()
                            for _, d in ipairs({0.3, 0.8, 1.5, 2.5}) do
                                task.wait(d)
                                if not Config.ESP then return end
                                if p.Character then
                                    pcall(function() buildESP(p) end)
                                end
                            end
                        end)
                    end)
                end
            end
            Players.PlayerAdded:Connect(function(p)
                p.CharacterAdded:Connect(function()
                    task.spawn(function()
                        for _, d in ipairs({0.3, 0.8, 1.5, 2.5}) do
                            task.wait(d)
                            if not Config.ESP then return end
                            if p.Character then pcall(function() buildESP(p) end) end
                        end
                    end)
                end)
            end)
            Players.PlayerRemoving:Connect(function(p)
                pcall(function() cleanESP(p) end)
            end)
        end
        ESP.rebuildAll()
        if not _renderConn then _renderConn = RunService.Heartbeat:Connect(render) end
        -- forzar rebuild periódico por si se pierde un respawn
        if not ESP._refreshConn then
            ESP._refreshConn = true
            task.spawn(function()
                while Config.ESP do
                    task.wait(2)
                    if not Config.ESP then break end
                    for _, p in ipairs(getSafePlayers()) do
                        if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                            if not State.ESPObjects[p] or not State.ESPObjects[p].root or not State.ESPObjects[p].root.Parent then
                                pcall(function() buildESP(p) end)
                            end
                        end
                    end
                end
                ESP._refreshConn = false
            end)
        end
    end
    function ESP.disable()
        Config.ESP = false; ESP.rebuildAll()
        State.PrimaryTarget = nil
        if _renderConn then _renderConn:Disconnect(); _renderConn = nil end
    end
    function ESP.unload()
        if _renderConn then _renderConn:Disconnect(); _renderConn = nil end
        State.PrimaryTarget = nil
        for p in pairs(State.ESPObjects) do cleanESP(p) end
        for _, pool in ipairs({ _radarO, _module }) do
            for _, d in ipairs(pool.drawings) do
                pcall(function() if d.Remove then d:Remove() end end)
            end
            pool.drawings = {}
            pool.disc, pool.rim, pool.self, pool.dots, pool.chev, pool.threat = nil, nil, nil, nil, nil, nil
            pool.rangeRing, pool.ticks, pool.dotShadow, pool.rimShadow, pool.nearRing = nil, nil, nil, nil, nil
            pool.grid, pool.sweep = nil, nil
        end
        if _gui then pcall(function() _gui:Destroy() end); _gui = nil; _absLayer = nil end
    end
end)()








;(function()
-- ==================== START/STOP ESP (Landryhaxx Drawing style) ====================


-- ==================== ESP PRO (ScreenGui - Real Executor safe) ====================
-- Box + skeleton body-sized, outline, health, name, distance, tracers, chams
getgenv()._ShakoESPPro = getgenv()._ShakoESPPro or { Targets = {}, bound = false }

local function espProCreate(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    return inst
end

local function espProSetLine(frame, a, b, thickness, color)
    local delta = b - a
    frame.Position = UDim2.fromOffset((a.X + b.X) / 2, (a.Y + b.Y) / 2)
    frame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), thickness)
    frame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
    frame.BackgroundColor3 = color
    frame.Visible = true
end

local function espProNewLine(parent, z)
    return espProCreate("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderSizePixel = 0,
        ZIndex = z or 3,
        Visible = false,
    }, parent)
end

local function espProStrokeBox(parent, color, z, thickness)
    local f = espProCreate("Frame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = z or 3,
        Visible = false,
    }, parent)
    local s = espProCreate("UIStroke", {
        Color = color,
        Thickness = thickness or 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        LineJoinMode = Enum.LineJoinMode.Miter,
    }, f)
    return f, s
end

local function espProNewCircle(parent, color, thickness, z)
    local f = espProCreate("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = z or 3,
        Visible = false,
    }, parent)
    espProCreate("UICorner", { CornerRadius = UDim.new(1, 0) }, f)
    local s = espProCreate("UIStroke", {
        Color = color,
        Thickness = thickness or 2,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, f)
    return f, s
end

local function espProNewLabel(parent, textSize, anchor, color)
    return espProCreate("TextLabel", {
        BackgroundTransparency = 1,
        Font = Enum.Font.GothamBold,
        TextSize = textSize or 13,
        TextColor3 = color or Color3.new(1, 1, 1),
        TextStrokeColor3 = Color3.new(0, 0, 0),
        TextStrokeTransparency = 0,
        AnchorPoint = anchor or Vector2.new(0.5, 1),
        Size = UDim2.fromOffset(220, (textSize or 13) + 2),
        Text = "",
        ZIndex = 6,
        Visible = false,
    }, parent)
end

local function espProExtents(cf, size)
    local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
    local sx, sy, sz = size.X / 2, size.Y / 2, size.Z / 2
    local ex = math.abs(r00) * sx + math.abs(r01) * sy + math.abs(r02) * sz
    local ey = math.abs(r10) * sx + math.abs(r11) * sy + math.abs(r12) * sz
    local ez = math.abs(r20) * sx + math.abs(r21) * sy + math.abs(r22) * sz
    return x - ex, y - ey, z - ez, x + ex, y + ey, z + ez
end

local function espProColor()
    local c = config.ESPBoxColor or config.ESPColor
    if typeof(c) == "Color3" then return c end
    local map = {
        Red = Color3.fromRGB(255, 40, 40),
        White = Color3.fromRGB(255, 255, 255),
        Pink = Color3.fromRGB(255, 105, 180),
        Green = Color3.fromRGB(80, 255, 120),
        Cyan = Color3.fromRGB(80, 220, 255),
        Yellow = Color3.fromRGB(255, 220, 80),
        Purple = Color3.fromRGB(180, 100, 255),
        Orange = Color3.fromRGB(255, 150, 40),
        Blue = Color3.fromRGB(60, 140, 255),
        Magenta = Color3.fromRGB(255, 80, 220),
    }
    return map[tostring(c or "Red")] or Color3.fromRGB(255, 40, 40)
end

local function espProGetGuiParent()
    local p
    pcall(function() if gethui then p = gethui() end end)
    if not p then pcall(function() p = game:GetService("CoreGui") end) end
    if not p then
        p = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
    end
    return p
end

-- Pares de huesos fijos (R15 + R6) — no depende de Motor6D
local ESP_BONE_PAIRS = {
    -- R15
    { "Head", "UpperTorso" },
    { "UpperTorso", "LowerTorso" },
    { "UpperTorso", "LeftUpperArm" },
    { "LeftUpperArm", "LeftLowerArm" },
    { "LeftLowerArm", "LeftHand" },
    { "UpperTorso", "RightUpperArm" },
    { "RightUpperArm", "RightLowerArm" },
    { "RightLowerArm", "RightHand" },
    { "LowerTorso", "LeftUpperLeg" },
    { "LeftUpperLeg", "LeftLowerLeg" },
    { "LeftLowerLeg", "LeftFoot" },
    { "LowerTorso", "RightUpperLeg" },
    { "RightUpperLeg", "RightLowerLeg" },
    { "RightLowerLeg", "RightFoot" },
    -- R6
    { "Head", "Torso" },
    { "Torso", "Left Arm" },
    { "Torso", "Right Arm" },
    { "Torso", "Left Leg" },
    { "Torso", "Right Leg" },
}

local function espProRebuild(e, now)
    e.dirty = false
    e.lastBuild = now
    local model = e.model
    local parts = {}
    for _, c in ipairs(model:GetDescendants()) do
        if c:IsA("BasePart") then
            parts[#parts + 1] = c
        end
    end
    e.parts = parts
    local head = model:FindFirstChild("Head")
    e.head = (head and head:IsA("BasePart")) and head or nil
    e.hrp = model:FindFirstChild("HumanoidRootPart") or model.PrimaryPart or parts[1]

    -- construir lista de {partA, partB}
    local bones = {}
    local seen = {}
    for _, pair in ipairs(ESP_BONE_PAIRS) do
        local a = model:FindFirstChild(pair[1])
        local b = model:FindFirstChild(pair[2])
        if a and b and a:IsA("BasePart") and b:IsA("BasePart") then
            local key = pair[1] .. "|" .. pair[2]
            if not seen[key] then
                seen[key] = true
                bones[#bones + 1] = { partA = a, partB = b }
            end
        end
    end
    -- fallback: si no hay pares (rig raro), unir HRP-Head
    if #bones == 0 and e.hrp and e.head then
        bones[1] = { partA = e.head, partB = e.hrp }
    end
    e.bones = bones
end

local function espProCornerPair(parent)
    -- 8 corner segments: outer black + inner color (UE style)
    local corners = { out = {}, main = {} }
    for n = 1, 8 do
        corners.out[n] = espProNewLine(parent, 2)
        corners.main[n] = espProNewLine(parent, 3)
    end
    return corners
end

local function espProDrawCornerBox(corners, x, y, w, h, color, thickness, outline)
    -- L-corners: TL, TR, BL, BR  (2 lines each = 8)
    local t = math.max(tonumber(thickness) or 2, 1)
    local len = math.clamp(math.floor(math.min(w, h) * 0.28), 6, 18)
    local pts = {
        -- TL horizontal + vertical
        { Vector2.new(x, y), Vector2.new(x + len, y) },
        { Vector2.new(x, y), Vector2.new(x, y + len) },
        -- TR
        { Vector2.new(x + w, y), Vector2.new(x + w - len, y) },
        { Vector2.new(x + w, y), Vector2.new(x + w, y + len) },
        -- BL
        { Vector2.new(x, y + h), Vector2.new(x + len, y + h) },
        { Vector2.new(x, y + h), Vector2.new(x, y + h - len) },
        -- BR
        { Vector2.new(x + w, y + h), Vector2.new(x + w - len, y + h) },
        { Vector2.new(x + w, y + h), Vector2.new(x + w, y + h - len) },
    }
    for i, seg in ipairs(pts) do
        local out = corners.out[i]
        local main = corners.main[i]
        if outline then
            espProSetLine(out, seg[1], seg[2], t + 2, Color3.new(0, 0, 0))
        elseif out then
            out.Visible = false
        end
        espProSetLine(main, seg[1], seg[2], t, color)
    end
end

local function espProHideCorners(corners)
    if not corners then return end
    for i = 1, 8 do
        if corners.out[i] then corners.out[i].Visible = false end
        if corners.main[i] then corners.main[i].Visible = false end
    end
end

local function espProCreateTarget(model, hum, layer)
    local e = {
        model = model,
        hum = hum,
        parts = {},
        bones = {},
        jp = {},
        skOut = {},
        skMain = {},
        conns = {},
        dirty = true,
        lastBuild = 0,
        shown = false,
    }
    local root = espProCreate("Frame", {
        Name = model.Name,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        Visible = false,
    }, layer)
    e.root = root

    -- soft fill (UE-like low opacity)
    e.fill = espProCreate("Frame", { BorderSizePixel = 0, ZIndex = 1, Visible = false }, root)
    espProCreate("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.72),
            NumberSequenceKeypoint.new(1, 0.92),
        }),
    }, e.fill)

    -- full box (optional style)
    e.boxOut = espProStrokeBox(root, Color3.new(0, 0, 0), 2, 1)
    e.boxIn = espProStrokeBox(root, Color3.new(0, 0, 0), 2, 1)
    e.box, e.boxS = espProStrokeBox(root, espProColor(), 3, 1.5)

    -- corner brackets (UE default)
    e.corners = espProCornerPair(root)

    -- health bar pro
    e.hpBG = espProCreate("Frame", {
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.15,
        BorderSizePixel = 0,
        ZIndex = 4,
        Visible = false,
    }, root)
    e.hpFill = espProCreate("Frame", { BorderSizePixel = 0, ZIndex = 5, Visible = false }, root)
    e.hpText = espProNewLabel(root, 11, Vector2.new(1, 0.5))
    e.hpText.TextXAlignment = Enum.TextXAlignment.Right
    e.hpText.Font = Enum.Font.GothamBold

    -- name / dist UE style
    e.name = espProNewLabel(root, 14, Vector2.new(0.5, 1))
    e.name.Font = Enum.Font.GothamBold
    e.dist = espProNewLabel(root, 12, Vector2.new(0.5, 0), Color3.fromRGB(210, 210, 220))
    e.dist.Font = Enum.Font.Gotham

    -- weapon line
    e.weapon = espProNewLabel(root, 11, Vector2.new(0.5, 0), Color3.fromRGB(180, 180, 190))
    e.weapon.Font = Enum.Font.Gotham

    e.trOut = espProNewLine(root, 2)
    e.trMain = espProNewLine(root, 3)
    e.headOut = espProNewCircle(root, Color3.new(0, 0, 0), 3, 2)
    e.headMain, e.headMainS = espProNewCircle(root, espProColor(), 1.5, 3)

    local function markDirty() e.dirty = true end
    e.conns[#e.conns + 1] = model.DescendantAdded:Connect(markDirty)
    e.conns[#e.conns + 1] = model.DescendantRemoving:Connect(markDirty)
    return e
end

local function espProRemove(model)
    local S = getgenv()._ShakoESPPro
    local e = S.Targets[model]
    if not e then return end
    S.Targets[model] = nil
    for _, c in ipairs(e.conns) do pcall(function() c:Disconnect() end) end
    if e.hl then pcall(function() e.hl:Destroy() end) end
    if e.root then pcall(function() e.root:Destroy() end) end
end

local function espProHide(e)
    if e.shown then
        e.shown = false
        e.root.Visible = false
    end
    if e.hl and e.hl.Enabled then
        e.hl.Enabled = false
    end
    pcall(function() espProHideCorners(e.corners) end)
end

local function espProGetLines(e, i)
    local out, main = e.skOut[i], e.skMain[i]
    if not out then
        out = espProNewLine(e.root, 2)
        main = espProNewLine(e.root, 3)
        e.skOut[i], e.skMain[i] = out, main
    end
    return out, main
end

local function espProJoint2D(e, m, cam)
    local v = e.jp[m]
    if v == nil then
        local p1 = m.Part1
        if p1 and p1.Parent then
            local sp = cam:WorldToViewportPoint((p1.CFrame * m.C1).Position)
            v = sp.Z > 0 and Vector2.new(sp.X, sp.Y) or false
        else
            v = false
        end
        e.jp[m] = v
    end
    return v
end

local function espProDraw(e, camPos, color, vp, now, cam)
    local model, hum = e.model, e.hum
    if not config.ESPEnabled or model == LocalPlayer.Character or not hum.Parent or hum.Health <= 0 then
        return espProHide(e)
    end
    if type(isESPKeyActive) == "function" and not isESPKeyActive() then
        return espProHide(e)
    end

    if not e.player then
        e.player = Players:GetPlayerFromCharacter(model)
    end
    -- Solo jugadores por defecto (Rivals)
    if not e.player and not config.ESPIncludeNPCs then
        return espProHide(e)
    end
    if config.ESPTeamCheck and e.player and e.player.Team and LocalPlayer.Team and e.player.Team == LocalPlayer.Team then
        return espProHide(e)
    end

    if e.dirty and now - (e.lastBuild or 0) > 0.25 then
        espProRebuild(e, now)
    end

    local hrp = e.hrp
    if not hrp or not hrp.Parent then
        return espProHide(e)
    end

    local dist = (hrp.Position - camPos).Magnitude
    local maxDist = (config.ESPInfiniteRange and 1e9) or (tonumber(config.ESPMaxDistance) or tonumber(config.ESPMaxDist) or 1500)
    if dist > maxDist then
        return espProHide(e)
    end

    if config.ESPUseTeamColor and e.player and e.player.Team then
        color = e.player.TeamColor.Color
    end
    if config.ESPRainbow then
        color = Color3.fromHSV((now * 0.25) % 1, 0.85, 1)
    end

    -- AABB body parts
    local x0, y0, z0 = math.huge, math.huge, math.huge
    local x1, y1, z1 = -math.huge, -math.huge, -math.huge
    local n = 0
    for _, p in ipairs(e.parts) do
        if p.Parent then
            local a, b, c, d, f, g = espProExtents(p.CFrame, p.Size)
            x0, y0, z0 = math.min(x0, a), math.min(y0, b), math.min(z0, c)
            x1, y1, z1 = math.max(x1, d), math.max(y1, f), math.max(z1, g)
            n += 1
        end
    end
    if n == 0 then return espProHide(e) end

    local minX, minY, maxX, maxY = math.huge, math.huge, -math.huge, -math.huge
    for i = 0, 7 do
        local px = (i % 2 == 0) and x0 or x1
        local py = (math.floor(i / 2) % 2 == 0) and y0 or y1
        local pz = (i >= 4) and z0 or z1
        local sp = cam:WorldToViewportPoint(Vector3.new(px, py, pz))
        if sp.Z <= 0 then return espProHide(e) end
        minX, maxX = math.min(minX, sp.X), math.max(maxX, sp.X)
        minY, maxY = math.min(minY, sp.Y), math.max(maxY, sp.Y)
    end
    if maxX < 0 or minX > vp.X or maxY < 0 or minY > vp.Y then
        return espProHide(e)
    end

    if not e.shown then
        e.shown = true
        e.root.Visible = true
    end

    local bx, by = math.floor(minX), math.floor(minY)
    local bw = math.max(math.floor(maxX - minX), 4)
    local bh = math.max(math.floor(maxY - minY), 6)

    local showBox = config.ESPShowBox ~= false and config.ESPBox ~= false
    -- treat nil as true for box/skeleton when ESP on - use explicit flags
    showBox = config.ESPShowBox == true or config.ESPBox == true
    local showSkel = config.ESPSkeleton == true
    local showName = config.ESPShowName == true
    local showDist = config.ESPShowDist == true
    local showHP = config.ESPShowHP == true
    local showTracers = config.ESPTracers == true
    local showChams = config.ESPChams == true or config.ESPGlow == true
    local boxOutline = config.ESPOutline ~= false
    local skelOutline = config.ESPOutline ~= false
    local boxFill = config.ESPFilledBox == true

    -- BOX (UE style: Corner by default, Full optional)
    local boxStyle = tostring(config.ESPBoxStyle or "Corner")
    local th = tonumber(config.ESPBoxThickness) or 1.5
    if not showBox then
        e.box.Visible = false
        e.boxOut.Visible = false
        e.boxIn.Visible = false
        espProHideCorners(e.corners)
        e.fill.Visible = false
    elseif boxStyle == "Full" or boxStyle == "Full Box" then
        espProHideCorners(e.corners)
        e.box.Visible = true
        e.boxOut.Visible = boxOutline
        e.boxIn.Visible = boxOutline
        e.box.Position = UDim2.fromOffset(bx, by)
        e.box.Size = UDim2.fromOffset(bw, bh)
        if e.boxS then e.boxS.Color = color; e.boxS.Thickness = th end
        if boxOutline then
            e.boxOut.Position = UDim2.fromOffset(bx - 2, by - 2)
            e.boxOut.Size = UDim2.fromOffset(bw + 4, bh + 4)
            e.boxIn.Position = UDim2.fromOffset(bx + 1, by + 1)
            e.boxIn.Size = UDim2.fromOffset(math.max(bw - 2, 0), math.max(bh - 2, 0))
        end
    else
        -- Corner brackets (Unnamed style)
        e.box.Visible = false
        e.boxOut.Visible = false
        e.boxIn.Visible = false
        espProDrawCornerBox(e.corners, bx, by, bw, bh, color, th, boxOutline)
    end

    e.fill.Visible = boxFill and showBox
    if boxFill and showBox then
        e.fill.Position = UDim2.fromOffset(bx, by)
        e.fill.Size = UDim2.fromOffset(bw, bh)
        e.fill.BackgroundColor3 = color
        e.fill.BackgroundTransparency = 0.82
    end

    -- SKELETON (part-to-part, full body)
    if showSkel then
        local used = 0
        local th = tonumber(config.ESPSkeletonThickness) or 1.5
        for i, bone in ipairs(e.bones) do
            local out, main = espProGetLines(e, i)
            local pa, pb = bone.partA, bone.partB
            local A, B = nil, nil
            if pa and pa.Parent and pb and pb.Parent then
                local sa, oa = cam:WorldToViewportPoint(pa.Position)
                local sb, ob = cam:WorldToViewportPoint(pb.Position)
                if sa.Z > 0 and sb.Z > 0 then
                    A = Vector2.new(sa.X, sa.Y)
                    B = Vector2.new(sb.X, sb.Y)
                end
            end
            if A and B and (A - B).Magnitude > 1 then
                if skelOutline then
                    espProSetLine(out, A, B, th + 2, Color3.new(0, 0, 0))
                else
                    out.Visible = false
                end
                espProSetLine(main, A, B, th, color)
            else
                out.Visible = false
                main.Visible = false
            end
            used = i
        end
        for i = used + 1, #e.skMain do
            e.skOut[i].Visible = false
            e.skMain[i].Visible = false
        end
        -- head circle
        local head = e.head
        local showHead = false
        if head and head.Parent then
            local sp = cam:WorldToViewportPoint(head.Position)
            if sp.Z > 0 then
                local scale = vp.Y / (2 * math.tan(math.rad(cam.FieldOfView) / 2) * sp.Z)
                local r = math.max(math.floor(head.Size.Y * 0.55 * scale), 3)
                local pos = UDim2.fromOffset(math.floor(sp.X), math.floor(sp.Y))
                e.headMain.Position = pos
                e.headMain.Size = UDim2.fromOffset(r * 2, r * 2)
                if e.headMainS then e.headMainS.Color = color end
                e.headOut.Position = pos
                e.headOut.Size = UDim2.fromOffset(math.max(r * 2 - 2, 1), math.max(r * 2 - 2, 1))
                showHead = true
            end
        end
        e.headMain.Visible = showHead
        e.headOut.Visible = showHead and skelOutline
        e.skDrawn = true
    elseif e.skDrawn then
        e.skDrawn = false
        for i = 1, #e.skMain do
            e.skOut[i].Visible = false
            e.skMain[i].Visible = false
        end
        e.headMain.Visible = false
        e.headOut.Visible = false
    end

    -- NAME (UE)
    e.name.Visible = showName
    if showName then
        local text = e.player and e.player.DisplayName or model.Name
        if e.name.Text ~= text then e.name.Text = text end
        e.name.TextColor3 = Color3.fromRGB(255, 255, 255)
        e.name.TextStrokeTransparency = 0
        e.name.TextSize = tonumber(config.ESPNameSize) or 14
        e.name.Position = UDim2.fromOffset(bx + bw / 2, by - 6)
    end

    -- DIST + weapon line
    e.dist.Visible = showDist
    if showDist then
        local text = string.format("%dm", math.floor(dist))
        if e.dist.Text ~= text then e.dist.Text = text end
        e.dist.TextColor3 = Color3.fromRGB(200, 200, 210)
        e.dist.Position = UDim2.fromOffset(bx + bw / 2, by + bh + 3)
    end
    if e.weapon then
        local showWep = config.ESPShowWeapon == true
        e.weapon.Visible = showWep
        if showWep then
            local wepName = ""
            pcall(function()
                local tool = model:FindFirstChildOfClass("Tool")
                if tool then wepName = tool.Name end
            end)
            e.weapon.Text = wepName
            e.weapon.Position = UDim2.fromOffset(bx + bw / 2, by + bh + (showDist and 16 or 3))
            e.weapon.Visible = wepName ~= ""
        end
    end

    -- HEALTH
    e.hpBG.Visible = showHP
    e.hpFill.Visible = showHP
    e.hpText.Visible = showHP and config.ESPShowHPText == true
    if showHP then
        local ratio = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
        local fh = math.max(math.floor(bh * ratio), 1)
        local barW = tonumber(config.ESPBarWidth) or 4
        e.hpBG.Position = UDim2.fromOffset(bx - (barW + 4), by - 1)
        e.hpBG.Size = UDim2.fromOffset(barW + 2, bh + 2)
        e.hpFill.Position = UDim2.fromOffset(bx - (barW + 3), by + bh - fh)
        e.hpFill.Size = UDim2.fromOffset(barW, fh)
        e.hpFill.BackgroundColor3 = Color3.fromHSV(ratio * 0.33, 0.9, 1)
        if config.ESPShowHPText then
            local t = tostring(math.floor(hum.Health))
            if e.hpText.Text ~= t then e.hpText.Text = t end
            e.hpText.Position = UDim2.fromOffset(bx - (barW + 7), by + bh - fh)
        end
    end

    -- TRACERS
    if showTracers then
        local origin = Vector2.new(vp.X / 2, vp.Y)
        local fromMode = tostring(config.ESPTracerFrom or "Bottom")
        if fromMode == "Center" then origin = Vector2.new(vp.X / 2, vp.Y / 2)
        elseif fromMode == "Mouse" then
            local m = UserInputService:GetMouseLocation()
            origin = Vector2.new(m.X, m.Y)
        end
        local target = Vector2.new(bx + bw / 2, by + bh)
        espProSetLine(e.trOut, origin, target, 3, Color3.new(0, 0, 0))
        espProSetLine(e.trMain, origin, target, 1, color)
    else
        e.trOut.Visible = false
        e.trMain.Visible = false
    end

    -- CHAMS
    if showChams then
        if not e.hl then
            e.hl = espProCreate("Highlight", {
                DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
                FillTransparency = tonumber(config.ESPChamsFill) or 0.6,
                OutlineTransparency = 0,
                Adornee = model,
            }, model)
        end
        e.hl.FillColor = color
        e.hl.OutlineColor = color:Lerp(Color3.new(1, 1, 1), 0.5)
        e.hl.Enabled = true
    elseif e.hl then
        e.hl.Enabled = false
    end
end

StartESP = function()
    config.ESPEnabled = true
    config.ESP = true
    -- defaults on enable if never set
    if config.ESPShowBox == nil then config.ESPShowBox = true end
    if config.ESPBox == nil then config.ESPBox = true end
    if config.ESPBoxStyle == nil then config.ESPBoxStyle = "Corner" end
    if not config.ESPMaxPlayers then config.ESPMaxPlayers = 8 end
    if config.ESPSkeleton == nil then config.ESPSkeleton = true end
    if config.ESPShowName == nil then config.ESPShowName = true end
    if config.ESPShowHP == nil then config.ESPShowHP = true end
    if config.ESPShowDist == nil then config.ESPShowDist = true end
    if config.ESPOutline == nil then config.ESPOutline = true end
    if not config.ESPBoxColor then config.ESPBoxColor = Color3.fromRGB(255, 40, 40) end
    if not config.ESPColor or config.ESPColor == "Pink" or config.ESPColor == "White" then
        config.ESPColor = "Red"
    end

    local S = getgenv()._ShakoESPPro
    -- cleanup
    for model in pairs(S.Targets) do espProRemove(model) end
    S.Targets = {}
    if S.layer then pcall(function() S.layer:Destroy() end) end
    if S.conn then pcall(function() S.conn:Disconnect() end) S.conn = nil end
    if S.addConn then pcall(function() S.addConn:Disconnect() end) S.addConn = nil end
    if S.bound then
        pcall(function() RunService:UnbindFromRenderStep("ShakoESPPro") end)
        S.bound = false
    end

    local parent = espProGetGuiParent()
    local layer = espProCreate("ScreenGui", {
        Name = "ShakoESPPro",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 50,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, parent)
    S.layer = layer

    local function register(hum)
        if not config.ESPEnabled then return end
        local model = hum.Parent
        if not model or not model:IsA("Model") or S.Targets[model] then return end
        if model == LocalPlayer.Character then return end
        S.Targets[model] = espProCreateTarget(model, hum, layer)
    end

    -- jugadores actuales
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum then pcall(register, hum) end
        end
    end
    -- workspace humanoids (optional NPCs)
    if config.ESPIncludeNPCs then
        for _, d in ipairs(workspace:GetDescendants()) do
            if d:IsA("Humanoid") then pcall(register, d) end
        end
    end

    S.addConn = workspace.DescendantAdded:Connect(function(d)
        if d:IsA("Humanoid") then
            task.defer(function() pcall(register, d) end)
        end
    end)

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            plr.CharacterAdded:Connect(function(char)
                task.wait(0.3)
                if not config.ESPEnabled then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(register, hum) end
            end)
        end
    end
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            if not config.ESPEnabled then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then pcall(register, hum) end
        end)
    end)

    pcall(function()
        S._espFrame = 0
        S._sorted = S._sorted or {}
        S._lastSort = 0
        RunService:BindToRenderStep("ShakoESPPro", Enum.RenderPriority.Camera.Value + 1, function()
            if not config.ESPEnabled then return end
            S._espFrame = (S._espFrame or 0) + 1
            -- ~12 FPS ESP (optimizado anti-lag)
            if S._espFrame % 5 ~= 0 then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            local camPos = cam.CFrame.Position
            local vp = cam.ViewportSize
            local now = os.clock()
            local color = espProColor()
            local maxP = math.clamp(tonumber(config.ESPMaxPlayers) or 6, 1, 16)

            -- reordenar solo cada 0.2s
            if (now - (S._lastSort or 0)) > 0.45 then
                S._lastSort = now
                local list = {}
                for model, e in pairs(S.Targets) do
                    if not model.Parent or not e.hum or not e.hum.Parent then
                        espProRemove(model)
                    else
                        local hrp = e.hrp
                        if not hrp or not hrp.Parent then
                            hrp = model:FindFirstChild("HumanoidRootPart")
                            e.hrp = hrp
                        end
                        local d = hrp and (hrp.Position - camPos).Magnitude or 1e9
                        list[#list + 1] = { e = e, dist = d }
                    end
                end
                table.sort(list, function(a, b) return a.dist < b.dist end)
                S._sorted = list
            end

            local list = S._sorted or {}
            for i, item in ipairs(list) do
                if i <= maxP then
                    pcall(espProDraw, item.e, camPos, color, vp, now, cam)
                else
                    pcall(espProHide, item.e)
                end
            end
        end)
    end)
    S.bound = true
    -- parar otros ESP antiguos si existen
    pcall(function()
        if getgenv()._ShakoOldESP and getgenv()._ShakoOldESP.Stop then
            getgenv()._ShakoOldESP.Stop()
        end
    end)
    Notify("ESP", "ON")
end

StopESP = function()
    config.ESPEnabled = false
    config.ESP = false
    local S = getgenv()._ShakoESPPro
    for model in pairs(S.Targets or {}) do espProRemove(model) end
    S.Targets = {}
    if S.addConn then pcall(function() S.addConn:Disconnect() end) S.addConn = nil end
    if S.bound then
        pcall(function() RunService:UnbindFromRenderStep("ShakoESPPro") end)
        S.bound = false
    end
    if S.layer then pcall(function() S.layer:Destroy() end) S.layer = nil end
    -- legacy cleanup
    pcall(function()
        if getgenv()._ShakoESP7 then
            getgenv()._ShakoESP7.on = false
        end
        if getgenv()._ShakoLandryESP then
            getgenv()._ShakoLandryESP.Unloaded = true
        end
    end)
    Notify("ESP", "OFF")
end


-- aliases
_espColor = espProColor
function _espAddPlayer() end
function _espRemovePlayer() end
function _espUpdate() end
function _espHideAll() end
function _espDrawingAvailable() return false end

function pushBulletTracer(fromPos, toPos)
    if not config.BulletTracerEnabled then return end -- legacy off; usa EliTracers
if true then return end -- disable old tracers
    if not toPos then return end
    -- estilos avanzados
    local TracerStyles = {
        Line = "",
        Neon = "rbxassetid://446111271",
        Laser = "rbxassetid://446111271",
        Smoke = "rbxassetid://3476611091",
        Lightning = "rbxassetid://7151778302",
    }
    function expScale(value, minVal, maxVal)
        value = tonumber(value) or minVal or 1
        minVal, maxVal = minVal or 1, maxVal or 25
        local t = math.clamp((value - minVal) / math.max(maxVal - minVal, 0.001), 0, 1)
        return maxVal ^ t
    end
    function getTracerColor()
        local c = config.BulletTracerColor
        if typeof(c) == "Color3" then return c end
        if fovColor then
            local ok, col = pcall(fovColor, tostring(c or "Cyan"))
            if ok and typeof(col) == "Color3" then return col end
        end
        return Color3.fromRGB(80, 220, 255)
    end
    function getMuzzleWorldPos()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        for _, d in ipairs(cam:GetDescendants()) do
            local n = string.lower(d.Name)
            if d:IsA("Attachment") and (n:find("muzzle") or n:find("barrel") or n == "gunfirepoint") then
                return d.WorldPosition
            end
            if d:IsA("BasePart") and (n:find("muzzle") or n == "fire") then
                return d.Position
            end
        end
        if config.BulletTracerFromGun then
            local char = LocalPlayer.Character
            local tool = char and char:FindFirstChildOfClass("Tool")
            if tool then
                for _, d in ipairs(tool:GetDescendants()) do
                    if d:IsA("Attachment") and string.lower(d.Name):find("muzzle") then
                        return d.WorldPosition
                    end
                end
                local handle = tool:FindFirstChild("Handle")
                if handle then return handle.Position end
            end
        end
        local off = tonumber(config.BulletTracerCameraOffset) or 0.15
        return cam.CFrame.Position + cam.CFrame.LookVector * off
    end

    fromPos = fromPos or getMuzzleWorldPos()
    if not fromPos then return end
    BulletTracers = BulletTracers or {}
    while #BulletTracers >= 24 do
        local old = table.remove(BulletTracers, 1)
        if old then
            pcall(function() if old.beam then old.beam:Destroy() end end)
            pcall(function() if old.a0 then old.a0:Destroy() end end)
            pcall(function() if old.a1 then old.a1:Destroy() end end)
            pcall(function() if old.light then old.light:Destroy() end end)
        end
    end

    local col = getTracerColor()
    local style = tostring(config.BulletTracerStyle or "Neon")
    local width = tonumber(config.BulletTracerThickness) or 1.2
    local lifetime = tonumber(config.BulletTracerDuration) or 0.6
    local fadeTime = tonumber(config.BulletTracerFade) or 0.25
    local emission = tonumber(config.BulletTracerEmission) or 1
    local brightness = expScale(config.BulletTracerGlow or 8, 1, 25)
    local tex = TracerStyles[style] or TracerStyles.Neon or ""
    local texLen = tonumber(config.BulletTracerTextureLength) or 1.2
    local texSpd = tonumber(config.BulletTracerTextureSpeed) or 4
    local doExpand = config.BulletTracerExpand ~= false

    local a0 = Instance.new("Attachment"); a0.WorldPosition = fromPos; a0.Parent = workspace.Terrain
    local a1 = Instance.new("Attachment"); a1.WorldPosition = toPos; a1.Parent = workspace.Terrain
    local beam = Instance.new("Beam")
    beam.Attachment0, beam.Attachment1 = a0, a1
    beam.Color = ColorSequence.new(col)
    local baseW = (style == "Laser" and 0.015) or (style == "Smoke" and 0.12) or 0.04
    beam.Width0 = baseW * width
    beam.Width1 = baseW * width * 0.55
    beam.FaceCamera = true
    beam.LightEmission = math.clamp(emission * (brightness / 25), 0, 5)
    beam.LightInfluence = 0
    beam.Texture = tex
    beam.TextureMode = Enum.TextureMode.Wrap
    beam.TextureLength = texLen
    beam.TextureSpeed = texSpd
    beam.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.7, 0.1),
        NumberSequenceKeypoint.new(1, 0.55),
    })
    beam.Parent = workspace.Terrain
    local light
    if brightness > 3 then
        light = Instance.new("PointLight")
        light.Color = col
        light.Brightness = math.clamp(brightness / 8, 0.2, 4)
        light.Range = 6 + width * 2
        light.Parent = a1
    end
    table.insert(BulletTracers, {
        beam = beam, a0 = a0, a1 = a1, light = light,
        created = tick(), die = tick() + lifetime, fade = fadeTime,
        baseW0 = beam.Width0, baseW1 = beam.Width1,
        expand = doExpand,
        expandSpd = tonumber(config.BulletTracerExpandSpeed) or 12,
        expandDamp = tonumber(config.BulletTracerExpandDamper) or 0.85,
        expandT = 0, col = col, from = fromPos, to = toPos,
    })
end

function updateBulletTracers(dt)
    if not BulletTracers or #BulletTracers == 0 then return end
    dt = dt or 0.016
    local now = tick()
    function getTracerColor()
        local c = config.BulletTracerColor
        if typeof(c) == "Color3" then return c end
        if fovColor then
            local ok, col = pcall(fovColor, tostring(c or "Cyan"))
            if ok and typeof(col) == "Color3" then return col end
        end
        return Color3.fromRGB(80, 220, 255)
    end
    local col = getTracerColor()
    for i = #BulletTracers, 1, -1 do
        local t = BulletTracers[i]
        if not t or not t.beam or not t.beam.Parent then
            table.remove(BulletTracers, i)
            continue
        end
        if t.col ~= col then
            t.col = col
            pcall(function() t.beam.Color = ColorSequence.new(col) end)
            if t.light then pcall(function() t.light.Color = col end) end
        end
        if t.expand then
            t.expandT = (t.expandT or 0) + dt * (t.expandSpd or 12)
            local k = 1 + (1 - math.exp(-t.expandT * (t.expandDamp or 0.85))) * 0.65
            pcall(function()
                t.beam.Width0 = (t.baseW0 or 0.05) * k
                t.beam.Width1 = (t.baseW1 or 0.03) * k
            end)
        end
        local left = (t.die or now) - now
        if left <= 0 then
            pcall(function() if t.beam then t.beam:Destroy() end end)
            pcall(function() if t.a0 then t.a0:Destroy() end end)
            pcall(function() if t.a1 then t.a1:Destroy() end end)
            pcall(function() if t.light then t.light:Destroy() end end)
            table.remove(BulletTracers, i)
        else
            local fade = tonumber(t.fade) or 0.25
            if left < fade and fade > 0 then
                local a = 1 - (left / fade)
                pcall(function()
                    t.beam.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0, a),
                        NumberSequenceKeypoint.new(1, math.clamp(a + 0.35, 0, 1)),
                    })
                end)
            end
        end
    end
end

function createBulletTracersFromHits(hitData, fromPos)
    if not config.BulletTracerEnabled or not hitData then return end
    if typeof(hitData) == "Vector3" then
        pushBulletTracer(fromPos, hitData)
        return
    end
    if typeof(hitData) == "table" then
        for _, entry in pairs(hitData) do
            local hitPos = nil
            if typeof(entry) == "Vector3" then hitPos = entry
            elseif typeof(entry) == "table" then
                hitPos = entry[0] or entry[1] or entry.Position or entry.Hit or entry.pos
                if typeof(hitPos) == "Instance" and hitPos:IsA("BasePart") then hitPos = hitPos.Position end
            elseif typeof(entry) == "Instance" and entry:IsA("BasePart") then
                hitPos = entry.Position
            end
            if typeof(hitPos) == "Vector3" then pushBulletTracer(fromPos, hitPos) end
        end
    end
end


end)()

-- ==================== WEATHER + EMOTES ====================

-- ==================== WEATHER (LuaHook) + Config bridge ====================
do
    --
    -- ensure keys
    config.WeatherEnabled = config.WeatherEnabled or false
    config.Weather = false
    config.WeatherType = config.WeatherType or "Rain"
    config.WeatherIntensity = config.WeatherIntensity or 1
    config.WeatherSoundVolume = config.WeatherSoundVolume or 0.6
    config.WeatherStorm = config.WeatherStorm or false
    config.WeatherStormMin = config.WeatherStormMin or 8
    config.WeatherStormVar = config.WeatherStormVar or 6
    config.WeatherMeteors = config.WeatherMeteors or false
    config.WeatherMeteorRate = config.WeatherMeteorRate or 1
    config.WeatherShootingStars = config.WeatherShootingStars or false
    config.WeatherStarRate = config.WeatherStarRate or 1
    config.WeatherPuddles = config.WeatherPuddles or false
    config.WeatherMood = config.WeatherMood ~= false
    config.WeatherClockDial = config.WeatherClockDial or false
    config.WeatherRainbow = config.WeatherRainbow or false
    config.WeatherGodRays = config.WeatherGodRays or false
    config.SkyboxPreset = config.SkyboxPreset or "Off"
    config.ThirdPersonEnabled = config.ThirdPerson or false
    config.ThirdPersonDistance = config.ThirdPersonDistance or 12
end

-- LuaHook Weather expects global-ish Config + lp
getgenv().Config = setmetatable({}, {
    __index = function(_, k)
        if k == "Weather" then return config.WeatherEnabled or config.Weather end
        if k == "ThirdPersonEnabled" then return config.ThirdPerson or config.ThirdPersonEnabled end
        return config[k]
    end,
    __newindex = function(_, k, v)
        if k == "Weather" then
            config.WeatherEnabled = v and true or false
            config.Weather = v and true or false
        elseif k == "ThirdPersonEnabled" then
            config.ThirdPerson = v and true or false
            config.ThirdPersonEnabled = v and true or false
        else
            config[k] = v
        end
    end,
})
getgenv().lp = LocalPlayer
if not Camera then Camera = workspace.CurrentCamera end
getgenv().Weather = getgenv().Weather or {}
;(function()
    local Config = getgenv().Config
    local lp = getgenv().lp
    local Workspace = workspace
    local Weather = getgenv().Weather
    local SoundService = game:GetService("SoundService")
    local TweenService = game:GetService("TweenService")
    function cfg(key, default)
        local v = Config[key]
        if v == nil then return default end
        return v
    end
    function iAmt()
        return math.clamp(cfg("WeatherIntensity", 1), 0.15, 2)
    end
    function iRate(I, kLo, kHi)
        if I < 1 then
            return math.exp(kLo * (I - 1))
        end
        return math.exp(kHi * (I - 1))
    end
    function evRate(key)
        return math.clamp(cfg(key, 1), 0.25, 3)
    end
    local IR = {
        Snow      = { lo = 1.75, hi = 0.85, acc = 0.45, sz = 0.08, alp = 0.35, gst = 0.30 },
        Petals    = { lo = 1.75, hi = 0.85, acc = 0.40, sz = 0.08, alp = 0.30, gst = 0.30 },
        Autumn    = { lo = 1.75, hi = 0.85, acc = 0.40, sz = 0.08, alp = 0.30, gst = 0.30 },
        Mist      = { lo = 1.35, hi = 1.10, acc = 0.30, sz = 0.25, alp = 0.75, gst = 0.20 },
        Ash       = { lo = 1.45, hi = 1.05, acc = 0.35, sz = 0.15, alp = 0.55, gst = 0.20 },
        Sandstorm = { lo = 1.35, hi = 1.60, acc = 0.45, sz = 0.30, alp = 0.75, gst = 0.20 },
        Embers    = { lo = 1.45, hi = 1.05, acc = 0.30, sz = 0.10, alp = 0.25, gst = 0.20 },
        Fireflies = { lo = 1.45, hi = 1.00, acc = 0.10, sz = 0.08, alp = 0.20, gst = 0.15 },
    }
    local IR_DEF = { lo = 1.6, hi = 0.9, acc = 0.3, sz = 0.10, alp = 0.25, gst = 0.25 }
    local SET_LO, SET_HI = 0.75, 0.45
    local Vec   = Vector3.new
    local WHITE = Color3.new(1, 1, 1)
    local TX_SOFT  = "rbxasset://textures/particles/smoke_main.dds"
    local TX_SPARK = "rbxasset://textures/particles/sparkles_main.dds"
    local TX_FLAKE    = "rbxassetid://101749163393113"
    local TX_SNOWSOFT = "rbxassetid://78582616787441"
    local TX_PUFF     = "rbxassetid://77935321198144"
    local TX_PETAL    = "rbxassetid://243344623"
    local TX_LEAFA    = "rbxassetid://8590047664"
    local TX_LEAFB    = "rbxassetid://5970677338"
    local TX_LEAFC    = "rbxassetid://9239040931"
    local TX_DUST     = "rbxassetid://341828512"
    local _curType = nil
    local Wind = { x = 0, z = 0 }
    ;(function()
        local baseAng = math.random() * 6.283
        local gustT0, gustDur, gustAmp = 0, 1, 0
        local nextGustT = math.huge
        local cbs = {}
        function Wind.onGust(fn)
            cbs[#cbs + 1] = fn
        end
        function Wind.reset(now)
            nextGustT = now + 8 + math.random() * 17
            gustT0, gustAmp = 0, 0
            Wind.x, Wind.z = 0, 0
        end
        function Wind.update(now)
            if now >= nextGustT then
                gustT0 = now
                gustDur = 2 + math.random() * 2
                gustAmp = 1 + math.random()
                nextGustT = now + 8 + math.random() * 17
                for i = 1, #cbs do
                    pcall(cbs[i], gustDur, 1 + gustAmp)
                end
            end
            local ang = baseAng + 0.6 * math.sin(now * 0.013) + 0.9 * math.sin(now * 0.031 + 2.6)
            local str = 1 + 0.35 * math.sin(now * 0.17) + 0.22 * math.sin(now * 0.41 + 1.3)
                          + 0.15 * math.sin(now * 0.07 + 4.1)
            local ga = (now - gustT0) / gustDur
            if gustAmp > 0 and ga < 1 then
                str = str * (1 + gustAmp * math.sin(ga * math.pi))
            end
            Wind.x = math.cos(ang) * str
            Wind.z = math.sin(ang) * str
        end
        function Wind.vec()
            return Vec(Wind.x, 0, Wind.z)
        end
    end)()
    local _folder = nil
    function getFolder()
        if _folder and _folder.Parent then return _folder end
        local f = Instance.new("Folder"); f.Name = "_wx"; f:SetAttribute("WX_Custom", true)
        f.Parent = Workspace
        _folder = f; return f
    end
    local _rain = { drops = {}, conn = nil, folder = nil, dir = nil, applied = nil }
    local RAIN_DIR      = Vec(-0.16, -1, 0.05).Unit
    local RAIN_LEAN_K   = 0.12
    local RAIN_LEAN_MAX = 0.2126
    local RAIN_RADIUS = 70
    local RAIN_TOP    = 70
    local RAIN_BOT    = -28
    local RAIN_MAX    = 420
    function rainFolder()
        if _rain.folder and _rain.folder.Parent then return _rain.folder end
        local f = Instance.new("Folder"); f.Name = "_wxRain"; f:SetAttribute("WX_Custom", true)
        f.Parent = getFolder()
        _rain.folder = f; return f
    end
    function makeDrop(parent, streakLen, width, color, glow, transp)
        local part = Instance.new("Part")
        part.Anchored = true; part.CanCollide = false; part.CanQuery = false; part.CanTouch = false
        part.CastShadow = false; part.Massless = true; part.Transparency = 1; part.Size = Vec(0.05,0.05,0.05)
        part:SetAttribute("WX_Custom", true)
        local a0 = Instance.new("Attachment"); a0.Parent = part
        local a1 = Instance.new("Attachment"); a1.Position = _rain.dir * streakLen; a1.Parent = part
        local beam = Instance.new("Beam")
        beam.Attachment0 = a0; beam.Attachment1 = a1
        beam.Segments = 1; beam.FaceCamera = true
        beam.Width0 = width; beam.Width1 = width * 0.55
        local emission = 0.35
        if glow then
            emission = 1
        end
        beam.LightEmission = emission
        beam.LightInfluence = 0
        beam.Color = ColorSequence.new(color)
        beam.Transparency = NumberSequence.new(transp)
        beam.Parent = part
        part.Parent = parent
        return part, a1, beam
    end
    function seedDrop(d, camPos)
        local ang = math.random() * math.pi * 2
        local rad = math.sqrt(math.random()) * RAIN_RADIUS
        local y   = camPos.Y + RAIN_TOP - math.random() * (RAIN_TOP - RAIN_BOT)
        d.pos = Vec(camPos.X + math.cos(ang) * rad, y, camPos.Z + math.sin(ang) * rad)
    end
    function newDrop(folder, i, camPos)
        local base, width, color, transp, spd0
        if (i % 3) ~= 0 then
            base, width, transp = 5 + math.random() * 3, 0.10, 0.22
            spd0 = 150 + math.random() * 30
            color = Color3.fromRGB(180, 202, 232)
        else
            base, width, transp = 3 + math.random() * 2, 0.06, 0.55
            spd0 = 120 + math.random() * 30
            color = Color3.fromRGB(158, 182, 214)
        end
        local part, a1, beam = makeDrop(folder, base, width, color, false, transp)
        local d = { part = part, a1 = a1, beam = beam, base = base, len = base,
                    w0 = width, t0 = transp, spd0 = spd0, spd = spd0 }
        seedDrop(d, camPos)
        part.CFrame = CFrame.new(d.pos)
        return d
    end
    function tuneRain()
        local folder = rainFolder()
        local I = iAmt()
        local n = math.clamp(math.floor(150 * iRate(I, 1.75, 0.85)), 16, RAIN_MAX)
        local drops = _rain.drops
        local camPos = Vec(0, 0, 0)
        if Camera then
            camPos = Camera.CFrame.Position
        end
        for i = #drops, n + 1, -1 do
            drops[i].part:Destroy()
            drops[i] = nil
        end
        for i = #drops + 1, n do
            drops[i] = newDrop(folder, i, camPos)
        end
        local sm = 0.55 + 0.45 * I
        local wm = 0.85 + 0.15 * I
        local am = 0.78 + 0.22 * I
        local dir = _rain.applied or _rain.dir or RAIN_DIR
        for i = 1, n do
            local d = drops[i]
            d.spd = d.spd0 * sm
            d.len = d.base * sm
            d.a1.Position = dir * d.len
            local w = d.w0 * wm
            d.beam.Width0 = w
            d.beam.Width1 = w * 0.55
            d.beam.Transparency = NumberSequence.new(math.clamp(1 - (1 - d.t0) * am, 0.02, 1))
        end
    end
    function buildRain()
        if _rain.folder then pcall(function() _rain.folder:Destroy() end); _rain.folder = nil end
        table.clear(_rain.drops)
        if not _rain.dir then _rain.dir = RAIN_DIR end
        _rain.applied = _rain.dir
        tuneRain()
    end
    function startRain()
        if _rain.conn then return end
        _rain.conn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Weather or _curType ~= "Rain" then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local lx, lz = Wind.x * RAIN_LEAN_K, Wind.z * RAIN_LEAN_K
            local lm = math.sqrt(lx * lx + lz * lz)
            if lm > RAIN_LEAN_MAX then
                local s = RAIN_LEAN_MAX / lm
                lx, lz = lx * s, lz * s
            end
            local step = _rain.dir:Lerp(Vec(lx, -1, lz).Unit, math.min(dt * 2, 1)).Unit
            _rain.dir = step
            if (step - _rain.applied).Magnitude > 0.015 then
                _rain.applied = step
                for i = 1, #_rain.drops do
                    local d = _rain.drops[i]
                    d.a1.Position = step * d.len
                end
            end
            local r2 = RAIN_RADIUS * RAIN_RADIUS
            for i = 1, #_rain.drops do
                local d = _rain.drops[i]
                local p = d.pos + step * (d.spd * dt)
                local relX, relY, relZ = p.X - camPos.X, p.Y - camPos.Y, p.Z - camPos.Z
                if relY < RAIN_BOT or (relX * relX + relZ * relZ) > r2 then
                    seedDrop(d, camPos)
                    p = d.pos
                end
                d.pos = p
                if d.part then d.part.CFrame = CFrame.new(p) end
            end
        end)
    end
    function stopRain()
        if _rain.conn then _rain.conn:Disconnect(); _rain.conn = nil end
        if _rain.folder then pcall(function() _rain.folder:Destroy() end); _rain.folder = nil end
        table.clear(_rain.drops)
        _rain.dir = nil; _rain.applied = nil
    end
    local ND = Enum.NormalId
    function flutterSeq(lo, hi, n, env, flip)
        local kps = table.create(n + 1)
        for i = 0, n do
            local v = lo
            if (i + flip) % 2 == 1 then
                v = hi
            end
            kps[i + 1] = NumberSequenceKeypoint.new(i / n, v, env)
        end
        return NumberSequence.new(kps)
    end
    local PRESETS = {
        Snow = {
            { size=Vec(22,4,22), oy=5, tex=TX_FLAKE, color=WHITE,
              skeys={{0,1.7,0.35},{1,1.35,0.3}}, squash=-0.12, transp0=0.18,transp1=0.55,
              rate=0.7, speed={0.8,1.6}, life={5,7}, spread=28, rot={-60,60}, rotSpd=26,
              accel=Vec(0,-2.4,0), drag=2.2, glow=0.2, dir=ND.Bottom,
              gust={ax=1.8,az=1.2,wx=0.4,wz=0.31,ph=0.5} },
            { size=Vec(46,4,46), oy=10, tex=TX_SNOWSOFT, color=WHITE,
              skeys={{0,0.48,0.15},{1,0.38,0.10}}, squash=-0.05, transp0=0.7,transp1=0.92,
              rate=12, speed={1.5,3}, life={5,8}, spread=45, rot={-180,180}, rotSpd=10,
              accel=Vec(0,-3.5,0), drag=1.8, glow=0.12, dir=ND.Bottom,
              gust={ax=2.5,az=1.6,wx=0.37,wz=0.29,ph=0} },
            { size=Vec(140,4,140), oy=20, tex=TX_FLAKE, color=Color3.fromRGB(242,248,255),
              skeys={{0,0.5,0.2},{1,0.38,0.14}}, squash=-0.08, transp0=0.08,transp1=0.5,
              rate=190, speed={2,4}, life={7,10}, spread=50, rot={-180,180}, rotSpd=42,
              accel=Vec(0,-5,0), drag=1.7, glow=0.35, dir=ND.Bottom,
              gust={ax=2.2,az=1.4,wx=0.33,wz=0.26,ph=1.9} },
            { size=Vec(220,4,220), oy=32, tex=TX_SNOWSOFT, color=Color3.fromRGB(214,231,255),
              skeys={{0,0.3,0.08},{1,0.22,0.06}}, transp0=0.5,transp1=0.85,
              rate=265, speed={2,4}, life={8,11}, spread=55, rot={-30,30}, rotSpd=12,
              accel=Vec(0,-5.5,0), drag=1.5, glow=0.3, dir=ND.Bottom,
              gust={ax=1.5,az=1,wx=0.29,wz=0.25,ph=3.8} },
            { size=Vec(100,4,100), oy=12, tex=TX_SPARK, color=WHITE,
              skeys={{0,0.4,0.12},{1,0.32,0.1}},
              tkeys={{0,1},{0.2,0.5},{0.45,0.78},{0.62,0.42},{0.85,0.78},{1,1}},
              rate=10, speed={2,4}, life={5,8}, spread=45, rot={-180,180}, rotSpd=60,
              accel=Vec(0,-4.5,0), drag=1.6, glow=0.7, dir=ND.Bottom,
              gust={ax=2.2,az=1.4,wx=0.35,wz=0.27,ph=1} },
        },
        Mist = {
            { size=Vec(150,8,150), oy=0, tex=TX_SOFT, color=Color3.fromRGB(210,216,226),
              size0=26,size1=44, transp0=0.68,transp1=0.94,
              rate=16, speed={0.8,2.2}, life={9,13}, spread=20, rot={-5,5}, rotSpd=3,
              accel=Vec(2.2,0.25,1.2), drag=0.8, dir=ND.Top },
            { size=Vec(110,6,110), oy=1, tex=TX_SOFT, color=Color3.fromRGB(228,232,240),
              size0=12,size1=22, transp0=0.75,transp1=0.95,
              rate=10, speed={1.5,3}, life={6,9}, spread=25, rot={-8,8}, rotSpd=5,
              accel=Vec(3,0.4,1.6), drag=0.8, dir=ND.Top },
        },
        Embers = {
            { size=Vec(90,28,90), oy=2, tex=TX_SOFT, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(255,170,60)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,95,25)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(165,35,12)) }),
              size0=0.85,size1=0.3, transp0=0.05,transp1=0.85,
              rate=80, speed={3,7}, life={3,5}, spread=40, rot={-60,60}, rotSpd=90,
              accel=Vec(1.5,9,1), drag=1.6, glow=0.35, dir=ND.Top },
            { size=Vec(120,30,120), oy=6, tex=TX_SPARK, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,220,140)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(255,110,40)) }),
              size0=0.3,size1=0.08, transp0=0.05,transp1=0.9,
              rate=55, speed={2,5}, life={2.5,4}, spread=55, rot={-40,40}, rotSpd=60,
              accel=Vec(1,7,0.8), drag=1.4, glow=0.9, dir=ND.Top },
        },
        Fireflies = {
            { size=Vec(70,8,70), oy=-2, tex=TX_SNOWSOFT, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(220,255,130)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205,245,100)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(255,200,80)) }),
              skeys={{0,0.1},{0.08,0.62,0.15},{0.45,0.5,0.1},{1,0.08}},
              tkeys={{0,1},{0.08,0.08},{0.4,0.45},{0.75,0.85},{1,1}},
              rate=18, speed={0.5,1.6}, life={2.5,4}, spread=180, rot={0,0}, rotSpd=0,
              accel=Vec(0,0.3,0), drag=2.5, glow=0.95, dir=ND.Top },
            { size=Vec(140,14,140), oy=-1, tex=TX_SNOWSOFT, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(175,225,95)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(200,190,70)) }),
              skeys={{0,0.06},{0.1,0.32,0.08},{0.5,0.26},{1,0.05}},
              tkeys={{0,1},{0.1,0.3},{0.5,0.6},{1,1}},
              rate=18, speed={0.4,1.2}, life={3,5}, spread=180, rot={0,0}, rotSpd=0,
              accel=Vec(0,0.3,0), drag=2.5, glow=0.95, dir=ND.Top },
            { size=Vec(120,4,120), oy=-4, tex=TX_PUFF, color=Color3.fromRGB(148,158,178),
              size0=13,size1=22, tkeys={{0,1},{0.2,0.8},{0.7,0.89},{1,1}},
              rate=8, speed={0.5,1.5}, life={8,12}, spread=14, rot={-180,180}, rotSpd=4,
              accel=Vec(1.2,0.12,0.7), drag=0.7, glow=0, dir=ND.Top,
              gust={ax=1.2,az=0.8,wx=0.23,wz=0.19,ph=2.2} },
        },
        Petals = {
            { size=Vec(26,6,26), oy=3, tex=TX_SNOWSOFT, zoff=3, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,222,232)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(250,205,220)) }),
              skeys={{0,1.75,0.5},{1,1.4,0.3}}, transp0=0.78,transp1=0.92,
              rate=7, speed={0.4,1.1}, life={5,7}, spread=30, rot={-180,180}, rotSpd=22,
              accel=Vec(0,-3,0), drag=1.7, glow=0.04, dir=ND.Bottom,
              gust={ax=2.2,az=1.5,wx=0.43,wz=0.33,ph=1.4} },
            { size=Vec(64,12,64), oy=5, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(255,222,234)),
                  ColorSequenceKeypoint.new(0.55, Color3.fromRGB(248,178,206)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(226,132,176)) }),
              skeys={{0,2.05,0.5},{1,1.7,0.35}}, qseq=flutterSeq(-0.88, 0.08, 14, 0.12, 0),
              transp0=0.1,transp1=0.38,
              rate=13, speed={0.6,1.4}, life={6,8}, spread=35, rot={-180,180}, rotSpd=95,
              accel=Vec(0,-3.5,0), drag=1.6, glow=0.08, dir=ND.Bottom,
              gust={ax=2.6,az=1.8,wx=0.4,wz=0.31,ph=0.5} },
            { size=Vec(76,12,76), oy=7, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(250,224,200)),
                  ColorSequenceKeypoint.new(0.55, Color3.fromRGB(244,203,178)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(230,176,150)) }),
              skeys={{0,1.55,0.4},{1,1.28,0.28}}, qseq=flutterSeq(-0.8, 0.15, 12, 0.15, 1),
              transp0=0.14,transp1=0.44,
              rate=12, speed={0.8,1.8}, life={6,8.5}, spread=42, rot={-180,180}, rotSpd=140,
              accel=Vec(0,-3.2,0), drag=1.55, glow=0.05, dir=ND.Bottom,
              gust={ax=3,az=2,wx=0.37,wz=0.29,ph=2.1} },
            { size=Vec(130,6,130), oy=15, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,222,234)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(246,178,204)) }),
              skeys={{0,0.85,0.26},{1,0.68,0.18}}, qseq=flutterSeq(-0.7, 0.1, 8, 0.2, 0),
              transp0=0.06,transp1=0.44,
              rate=120, speed={1.4,3}, life={7,9}, spread=48, rot={-180,180}, rotSpd=170,
              accel=Vec(0,-5.2,0), drag=1.5, glow=0.1, dir=ND.Bottom,
              gust={ax=3.2,az=2.2,wx=0.33,wz=0.26,ph=1.9} },
            { size=Vec(240,6,240), oy=26, tex=TX_PETAL, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(250,214,228)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(238,190,210)) }),
              skeys={{0,0.3,0.09},{1,0.24,0.06}}, squash=-0.5, transp0=0.42,transp1=0.8,
              rate=170, speed={1.5,3.2}, life={8,11}, spread=55, rot={-180,180}, rotSpd=90,
              accel=Vec(0,-6,0), drag=1.35, glow=0.08, dir=ND.Bottom,
              gust={ax=2.4,az=1.6,wx=0.29,wz=0.25,ph=3.8} },
            { size=Vec(56,1.2,56), oy=-3.7, tex=TX_PETAL, tag="settle",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(255,214,228)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(240,178,204)) }),
              skeys={{0,1.1,0.3},{1,0.95,0.2}}, qseq=flutterSeq(-0.92, -0.2, 10, 0.1, 0),
              transp0=0.05,transp1=0.42,
              rate=34, speed={0.05,0.5}, life={14,20}, spread=90, rot={-180,180}, rotSpd=25,
              accel=Vec(0,-0.15,0), drag=2.6, glow=0.08, dir=ND.Bottom,
              gust={ax=3.6,az=3,wx=0.5,wz=0.44,ph=0.9} },
        },
        Autumn = {
            { size=Vec(20,6,20), oy=13, uw=8, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.62,0.14},{1,0.54,0.10}}, qseq=flutterSeq(-0.60, 0.14, 13, 0.10, 0),
              transp0=0.08,transp1=0.42,
              rate=14, speed={0.6,1.6}, life={7,9}, spread=34, rot={-180,180}, rotSpd=130,
              accel=Vec(0,-5,0), drag=1.5, glow=0.62, dir=ND.Bottom,
              gust={ax=3.4,az=2.2,wx=0.41,wz=0.3,ph=0.5} },
            { size=Vec(22,6,22), oy=15, uw=8, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(156,74,255)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(106,46,200)) }),
              skeys={{0,0.60,0.14},{1,0.52,0.10}}, qseq=flutterSeq(-0.56, 0.20, 11, 0.14, 1),
              transp0=0.12,transp1=0.46,
              rate=9, speed={0.8,1.9}, life={7,9}, spread=40, rot={-180,180}, rotSpd=185,
              accel=Vec(0,-5.6,0), drag=1.5, glow=0.07, dir=ND.Bottom,
              gust={ax=3.9,az=2.6,wx=0.36,wz=0.27,ph=2.1} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.56,0.16},{1,0.44,0.11}}, qseq=flutterSeq(-0.50, 0.10, 8, 0.16, 0),
              transp0=0.08,transp1=0.50,
              rate=24, speed={1.4,3}, life={7,9}, spread=54, rot={-180,180}, rotSpd=210,
              accel=Vec(0,-7,0), drag=1.45, glow=0.62, dir=ND.Bottom,
              gust={ax=4.2,az=2.8,wx=0.33,wz=0.24,ph=1.9} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.54,0.16},{1,0.42,0.11}}, qseq=flutterSeq(-0.54, 0.14, 9, 0.16, 1),
              transp0=0.10,transp1=0.50,
              rate=21, speed={1.4,3.1}, life={7,9}, spread=54, rot={-180,180}, rotSpd=200,
              accel=Vec(0,-7.2,0), drag=1.45, glow=0.07, dir=ND.Bottom,
              gust={ax=4,az=2.7,wx=0.31,wz=0.26,ph=3.3} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(230,222,176)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,254,228)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(200,180,122)) }),
              skeys={{0,0.52,0.15},{1,0.41,0.10}}, qseq=flutterSeq(-0.52, 0.12, 10, 0.16, 1),
              transp0=0.10,transp1=0.52,
              rate=17, speed={1.3,2.9}, life={7,9}, spread=52, rot={-180,180}, rotSpd=190,
              accel=Vec(0,-6.8,0), drag=1.45, glow=0.60, dir=ND.Bottom,
              gust={ax=4.1,az=2.7,wx=0.35,wz=0.28,ph=2.7} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(156,74,255)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(106,46,200)) }),
              skeys={{0,0.53,0.16},{1,0.42,0.11}}, qseq=flutterSeq(-0.52, 0.16, 9, 0.16, 0),
              transp0=0.10,transp1=0.50,
              rate=12, speed={1.4,3.1}, life={7,9}, spread=54, rot={-180,180}, rotSpd=220,
              accel=Vec(0,-7.1,0), drag=1.45, glow=0.07, dir=ND.Bottom,
              gust={ax=4,az=2.7,wx=0.3,wz=0.25,ph=5.1} },
            { size=Vec(150,8,150), oy=16, uw=20, tex=TX_LEAFC, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(196,156,112)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(146,110,74)) }),
              skeys={{0,0.50,0.15},{1,0.40,0.10}}, qseq=flutterSeq(-0.52, 0.10, 7, 0.16, 0),
              transp0=0.14,transp1=0.55,
              rate=11, speed={1.5,3.2}, life={7,9}, spread=56, rot={-180,180}, rotSpd=240,
              accel=Vec(0,-7.6,0), drag=1.45, glow=0.08, dir=ND.Bottom,
              gust={ax=3.8,az=2.6,wx=0.29,wz=0.23,ph=0.9} },
            { size=Vec(150,8,150), oy=16, uw=26, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(152,255,255)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(118,214,240)) }),
              skeys={{0,0.52,0.15},{1,0.41,0.10}}, qseq=flutterSeq(-0.50, 0.14, 8, 0.16, 1),
              transp0=0.12,transp1=0.52,
              rate=10, speed={1.4,3}, life={7,9}, spread=54, rot={-180,180}, rotSpd=195,
              accel=Vec(0,-7,0), drag=1.45, glow=0.16, dir=ND.Bottom,
              gust={ax=4.1,az=2.7,wx=0.34,wz=0.27,ph=4.2} },
            { size=Vec(300,30,300), oy=30, uw=60, tex=TX_LEAFA, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.24,0.06},{1,0.18,0.04}}, squash=-0.35, transp0=0.68,transp1=0.92,
              rate=30, speed={1.5,3.2}, life={8,11}, spread=55, rot={-180,180}, rotSpd=110,
              accel=Vec(0,-8,0), drag=1.35, glow=0.55, dir=ND.Bottom,
              gust={ax=3.1,az=2.1,wx=0.27,wz=0.24,ph=1.2} },
            { size=Vec(300,30,300), oy=30, uw=60, tex=TX_LEAFB, color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.23,0.06},{1,0.17,0.04}}, squash=-0.35, transp0=0.70,transp1=0.93,
              rate=24, speed={1.5,3.2}, life={8,11}, spread=55, rot={-180,180}, rotSpd=120,
              accel=Vec(0,-8,0), drag=1.35, glow=0.07, dir=ND.Bottom,
              gust={ax=3,az=2,wx=0.29,wz=0.22,ph=3.8} },
            { size=Vec(120,16,120), oy=6, tex=TX_LEAFA, tag="streak", aim=true,
              orient=Enum.ParticleOrientation.VelocityParallel,
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,    Color3.fromRGB(226,190,128)),
                  ColorSequenceKeypoint.new(0.45, Color3.fromRGB(255,246,200)),
                  ColorSequenceKeypoint.new(1,    Color3.fromRGB(190,132,62)) }),
              skeys={{0,0.66,0.16},{1,0.46,0.10}}, squash=-0.55,
              tkeys={{0,1},{0.08,0.06},{0.72,0.34},{1,1}},
              rate=0, speed={16,26}, life={1,1.9}, spread=13, rot={-180,180}, rotSpd=300,
              accel=Vec(0,-3.4,0), drag=2.6, glow=0.62, dir=ND.Front,
              gust={ax=5,az=4,wx=0.4,wz=0.35,ph=0} },
            { size=Vec(120,16,120), oy=5, tex=TX_LEAFB, tag="streak", aim=true,
              orient=Enum.ParticleOrientation.VelocityParallel,
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.62,0.16},{1,0.44,0.10}}, squash=-0.55,
              tkeys={{0,1},{0.08,0.08},{0.72,0.38},{1,1}},
              rate=0, speed={15,24}, life={1,1.8}, spread=14, rot={-180,180}, rotSpd=280,
              accel=Vec(0,-3.6,0), drag=2.6, glow=0.07, dir=ND.Front,
              gust={ax=5,az=4,wx=0.37,wz=0.33,ph=1.7} },
            { size=Vec(96,0.9,96), oy=-3.9, tex=TX_LEAFA, tag="settle",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0,   Color3.fromRGB(200,150,86)),
                  ColorSequenceKeypoint.new(0.5, Color3.fromRGB(168,110,58)),
                  ColorSequenceKeypoint.new(1,   Color3.fromRGB(130,80,44)) }),
              skeys={{0,0.50,0.14},{1,0.44,0.10}}, qseq=flutterSeq(-0.62, -0.05, 10, 0.1, 0),
              transp0=0.06,transp1=0.46,
              rate=34, speed={0.8,3.2}, life={10,16}, spread=90, rot={-180,180}, rotSpd=90,
              accel=Vec(0,-0.15,0), drag=3.2, glow=0.32, dir=ND.Bottom,
              gust={ax=9,az=8,wx=0.5,wz=0.44,ph=0.9} },
            { size=Vec(70,0.8,70), oy=-3.85, tex=TX_LEAFB, tag="settle",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(160,80,52)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(104,44,30)) }),
              skeys={{0,0.54,0.12},{1,0.46,0.08}}, qseq=flutterSeq(-0.66, 0.26, 16, 0.06, 0),
              transp0=0.05,transp1=0.44,
              rate=14, speed={0.6,2.2}, life={3,5}, spread=70, rot={-180,180}, rotSpd=340,
              accel=Vec(0,-1.2,0), drag=1.9, glow=0.10, dir=ND.Top,
              gust={ax=8,az=7,wx=0.62,wz=0.55,ph=2.4} },
            { size=Vec(74,0.6,74), oy=-3.95, tex=TX_LEAFC, tag="settle",
              orient=Enum.ParticleOrientation.VelocityPerpendicular,
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(190,146,96)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(150,110,72)) }),
              skeys={{0,0.76,0.16},{1,0.72,0.12}}, squash=0, transp0=0.04,transp1=0.30,
              rate=42, speed={0.04,0.1}, life={20,28}, spread=90, rot={-180,180}, rotSpd=3,
              accel=Vec(0,-0.12,0), drag=4, glow=0.22, dir=ND.Bottom },
            { size=Vec(80,0.8,80), oy=-4, tex=TX_DUST, tag="dust",
              color=ColorSequence.new({
                  ColorSequenceKeypoint.new(0, Color3.fromRGB(206,180,140)),
                  ColorSequenceKeypoint.new(1, Color3.fromRGB(150,124,92)) }),
              skeys={{0,1.1,0.35},{1,3.4,0.5}}, tkeys={{0,1},{0.18,0.84},{0.7,0.93},{1,1}},
              rate=0, speed={2,6}, life={1.1,2}, spread=85, rot={-180,180}, rotSpd=22,
              accel=Vec(0,0.6,0), drag=2.4, glow=0.06, dir=ND.Top,
              gust={ax=8,az=7,wx=0.4,wz=0.35,ph=0} },
        },
        Ash = {
            { size=Vec(110,4,110), oy=16, tex=TX_SOFT, color=Color3.fromRGB(96,90,86),
              size0=0.4,size1=0.3, transp0=0.05,transp1=0.5,
              rate=140, speed={2,4}, life={6,9}, spread=45, rot={-60,60}, rotSpd=45,
              accel=Vec(-3.5,-5,2), drag=1.6, glow=0, dir=ND.Bottom },
            { size=Vec(170,4,170), oy=26, tex=TX_SPARK, color=Color3.fromRGB(255,140,70),
              size0=0.14,size1=0.05, transp0=0.15,transp1=0.9,
              rate=26, speed={1.5,3.5}, life={4,7}, spread=60, rot={-40,40}, rotSpd=70,
              accel=Vec(-2.5,-2,1.5), drag=1.5, glow=0.9, dir=ND.Bottom },
        },
        Sandstorm = {
            { size=Vec(160,20,160), oy=6, tex=TX_SOFT, color=Color3.fromRGB(194,168,120),
              size0=24,size1=38, transp0=0.58,transp1=0.93,
              rate=24, speed={8,15}, life={5,8}, spread=28, rot={-8,8}, rotSpd=6,
              accel=Vec(20,0.5,7), drag=0.6, dir=ND.Right },
        },
    }
    Weather.TypeOrder = { "Rain", "Snow", "Mist", "Embers", "Fireflies", "Petals", "Autumn",
                          "Ash", "Sandstorm", "BloodMoon" }
    local MOOD = {
        Rain      = { B=-0.03, C=0.08,  S=-0.12, tint=Color3.fromRGB(205,220,255) },
        Snow      = { B= 0.03, C=0.05,  S=-0.08, tint=Color3.fromRGB(226,240,255) },
        Mist      = { B=-0.01, C=-0.05, S=-0.20, tint=Color3.fromRGB(220,224,230) },
        Embers    = { B= 0.02, C=0.08,  S= 0.10, tint=Color3.fromRGB(255,238,220) },
        Fireflies = { B=-0.04, C=0.06,  S= 0.02, tint=Color3.fromRGB(238,228,205) },
        Petals    = { B= 0.00, C=0.09,  S= 0.05, tint=Color3.fromRGB(255,234,234) },
        Autumn    = { B= 0.005, C=0.08, S= 0.04, tint=Color3.fromRGB(253,244,232) },
        Ash       = { B=-0.04, C=0.06,  S=-0.25, tint=Color3.fromRGB(225,220,215) },
        Sandstorm = { B=-0.02, C=0.10,  S= 0.05, tint=Color3.fromRGB(224,196,150) },
        BloodMoon = { B=-0.05, C=0.12,  S=-0.20, tint=Color3.fromRGB(255,180,180) },
    }
    local SOUND = { Rain="rain", Snow="wind", Mist="wind", Embers="fire",
                    Fireflies="night", Petals="birds", Autumn="wind", Ash="wind",
                    Sandstorm="wind", BloodMoon="night" }
    function ambientId(mood)
        local map = cfg("WeatherSoundIds", nil)
        if type(map) == "table" and map[mood] and map[mood] ~= "" then return map[mood] end
        return nil
    end
    local _partLayers = {}
    local _ambient  = nil
    local _moodCC   = nil
    local _moodTween = nil
    local FADE_TI = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local MOOD_TI = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
    local _followConn = nil
    local _lightFolder = nil
    local _rays = nil
    local _special = { moon = nil, shell = nil, sky = nil, cc = nil, atmo = nil, halo = nil, kind = nil }
    local _specialConn = nil
    local _clockConn = nil
    function clearPartLayers()
        for _, L in _partLayers do
            if L.rateTween then L.rateTween:Cancel() end
            if L.host then pcall(function() L.host:Destroy() end) end
        end
        table.clear(_partLayers)
    end
    local _fadeLayers = {}
    local _fadeToken = 0
    function killFade()
        _fadeToken = _fadeToken + 1
        for _, F in _fadeLayers do
            local host = F.host
            pcall(function() host:Destroy() end)
        end
        table.clear(_fadeLayers)
    end
    function beginLayerFade()
        killFade()
        local maxLife = 0
        for _, L in _partLayers do
            if L.rateTween then L.rateTween:Cancel() end
            if L.emitter then
                TweenService:Create(L.emitter, FADE_TI, { Rate = 0 }):Play()
            end
            if L.life2 > maxLife then maxLife = L.life2 end
            _fadeLayers[#_fadeLayers + 1] = { host = L.host, oy = L.oy }
        end
        table.clear(_partLayers)
        local tok = _fadeToken
        task.delay(FADE_TI.Time + maxLife, function()
            if tok == _fadeToken then killFade() end
        end)
    end
    local _spectacles, _spectWeight, _spectNextT = {}, 0, 0
    function registerSpectacle(name, weight, fn)
        _spectacles[#_spectacles + 1] = { name = name, weight = weight, fn = fn }
        _spectWeight = _spectWeight + weight
    end
    local _blizzT0, _blizzDur = 0, 1
    function layerRate(L, I)
        if L.spec.tag == "settle" then
            return L.spec.rate * iRate(I, SET_LO, SET_HI)
        end
        return L.spec.rate * iRate(I, L.ir.lo, L.ir.hi)
    end
    function tuneLayer(L, I)
        local spec, R, e = L.spec, L.ir, L.emitter
        local am = 1
        if spec.tag ~= "settle" then
            am = 1 - R.acc + R.acc * I
        end
        L.accel = spec.accel * am
        if not spec.gust then
            e.Acceleration = L.accel
        end
        e.Speed = NumberRange.new(spec.speed[1] * am, spec.speed[2] * am)
        if spec.gust then
            local gm = 1 - R.gst + R.gst * I
            L.gax, L.gaz = spec.gust.ax * gm, spec.gust.az * gm
        end
        local sm = 1 - R.sz + R.sz * I
        if spec.skeys then
            local ks = spec.skeys
            local kps = table.create(#ks)
            for i = 1, #ks do
                local k = ks[i]
                kps[i] = NumberSequenceKeypoint.new(k[1], k[2] * sm, (k[3] or 0) * sm)
            end
            e.Size = NumberSequence.new(kps)
        else
            e.Size = NumberSequence.new(spec.size0 * sm, spec.size1 * sm)
        end
        if not spec.tkeys then
            local om = 1 - R.alp + R.alp * I
            e.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0,    1),
                NumberSequenceKeypoint.new(0.12, math.clamp(1 - (1 - spec.transp0) * om, 0, 1)),
                NumberSequenceKeypoint.new(0.8,  math.clamp(1 - (1 - spec.transp1) * om, 0, 1)),
                NumberSequenceKeypoint.new(1,    1),
            })
        end
    end
    function mkPartLayer(spec, ir, rampIn)
        local host = Instance.new("Part")
        host.Name = "_wxHost"; host.Anchored = true; host.CanCollide = false; host.CanQuery = false
        host.CanTouch = false; host.CastShadow = false; host.Transparency = 1; host.Massless = true
        host.Size = spec.size; host:SetAttribute("WX_Custom", true)
        host.Parent = getFolder()
        local e = Instance.new("ParticleEmitter")
        e:SetAttribute("WX_Custom", true)
        e.Texture = spec.tex
        local colorSeq = spec.color
        if typeof(colorSeq) ~= "ColorSequence" then
            colorSeq = ColorSequence.new(colorSeq)
        end
        e.Color = colorSeq
        local glow = spec.glow or 0
        e.LightEmission  = glow
        e.LightInfluence = 1 - math.min(glow, 1)
        e.Lifetime = NumberRange.new(spec.life[1], spec.life[2])
        e.SpreadAngle = Vector2.new(spec.spread, spec.spread)
        local rot0, rot1 = 0, 360
        if spec.rot then
            rot0, rot1 = spec.rot[1], spec.rot[2]
        end
        e.Rotation = NumberRange.new(rot0, rot1)
        e.RotSpeed = NumberRange.new(-(spec.rotSpd or 45), spec.rotSpd or 45)
        if spec.qseq then
            e.Squash = spec.qseq
        else
            e.Squash = NumberSequence.new(spec.squash or 0)
        end
        if spec.tkeys then
            local kps = table.create(#spec.tkeys)
            for i = 1, #spec.tkeys do kps[i] = NumberSequenceKeypoint.new(spec.tkeys[i][1], spec.tkeys[i][2]) end
            e.Transparency = NumberSequence.new(kps)
        end
        e.Drag = spec.drag or 0
        e.ZOffset = spec.zoff or 0
        e.EmissionDirection = spec.dir
        if spec.orient then
            e.Orientation = spec.orient
        end
        e.Parent = host
        local L = { host = host, oy = spec.oy, emitter = e, spec = spec, ir = ir,
                    accel = spec.accel, gust = spec.gust, tag = spec.tag,
                    gax = 0, gaz = 0, rateMul = 1,
                    uw = spec.uw, aim = spec.aim,
                    life2 = spec.life[2], rateTween = nil }
        local I = iAmt()
        tuneLayer(L, I)
        local targetRate = layerRate(L, I)
        if rampIn then
            e.Rate = 0
            L.rateTween = TweenService:Create(e, FADE_TI, { Rate = targetRate })
            L.rateTween:Play()
        else
            e.Rate = targetRate
        end
        _partLayers[#_partLayers + 1] = L
    end
    function clearMood()
        if _moodTween then _moodTween:Cancel(); _moodTween = nil end
        if _moodCC then pcall(function() _moodCC:Destroy() end); _moodCC = nil end
    end
    function applyMood(name)
        if not cfg("WeatherMood", true) then
            clearMood()
            return
        end
        local m = MOOD[name]
        if not m then
            clearMood()
            return
        end
        if _moodTween then _moodTween:Cancel(); _moodTween = nil end
        local g = 0.6 + 0.4 * iAmt()
        local cc = _moodCC
        if cc and cc.Parent then
            _moodTween = TweenService:Create(cc, MOOD_TI,
                { Brightness = m.B * g, Contrast = m.C * g, Saturation = m.S * g, TintColor = m.tint })
            _moodTween:Play()
            return
        end
        cc = Instance.new("ColorCorrectionEffect")
        cc.Name = "_wxMood"; cc:SetAttribute("WX_Custom", true)
        cc.Brightness = m.B * g; cc.Contrast = m.C * g; cc.Saturation = m.S * g; cc.TintColor = m.tint
        cc.Parent = Lighting
        _moodCC = cc
    end
    function startAmbient(mood)
        if _ambient then pcall(function() _ambient:Destroy() end); _ambient = nil end
        local id = mood and ambientId(mood)
        if not id then return end
        local s = Instance.new("Sound")
        s.Name = "_wxAmb"; s:SetAttribute("WX_Custom", true)
        s.SoundId = id; s.Looped = true; s.Volume = cfg("WeatherSoundVolume", 0.35)
        s.Parent = SoundService
        pcall(function() s:Play() end)
        _ambient = s
    end
    function oneShot(id, vol, pitch)
        if not id or id == "" then return end
        local s = Instance.new("Sound")
        s.Name = "_wxSfx"; s:SetAttribute("WX_Custom", true)
        s.SoundId = id; s.Volume = math.clamp(vol, 0, 10)
        if pitch then s.PlaybackSpeed = pitch end
        s.Parent = SoundService
        pcall(function() s:Play() end)
        Debris:AddItem(s, 8)
    end
    function getLightFolder()
        if _lightFolder and _lightFolder.Parent then return _lightFolder end
        local f = Instance.new("Folder"); f.Name = "_wxBolts"; f:SetAttribute("WX_Custom", true)
        f.Parent = getFolder()
        _lightFolder = f; return f
    end
    function mkBoltPart(color, transp, size, cf, parent)
        local p = Instance.new("Part")
        p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.CastShadow = false; p.Massless = true; p.Material = Enum.Material.Neon
        p.Color = color; p.Transparency = transp; p:SetAttribute("WX_Custom", true)
        p.Size = size; p.CFrame = cf; p.Parent = parent
        return p
    end
    local startStorm, stopStormLoop, stopStorm, rescheduleStorm
    ;(function()
        local TX_BGLOW   = "rbxassetid://78582616787441"
        local TX_BSTREAK = "rbxassetid://102481842205398"
        local BOLT_CORE  = Color3.fromRGB(245, 242, 255)
        local BOLT_GLOW  = Color3.fromRGB(162, 145, 255)
        local BOLT_AFTER = Color3.fromRGB(126, 96, 228)
        local ROT90 = CFrame.Angles(0, math.rad(90), 0)
        local FLICK = 0.12
        local _stormConn, _stormNextT = nil, 0
        local _boltRp = RaycastParams.new()
        _boltRp.FilterType = Enum.RaycastFilterType.Exclude
        function mkSeg(color, transp, dia, len, cf, parent)
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Cylinder
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Massless = true; p.Material = Enum.Material.Neon
            p.Color = color; p.Transparency = transp; p:SetAttribute("WX_Custom", true)
            p.Size = Vec(len, dia, dia); p.CFrame = cf * ROT90; p.Parent = parent
            return p
        end
        function boltChannel(model, segs, top, bot, n, thick, jitter, layer3)
            local pts = { top }
            local prev = top
            local driftAng = math.random() * 6.283
            for i = 1, n do
                local t = i / n
                local point = top:Lerp(bot, t)
                if i < n then
                    driftAng = driftAng + (math.random() - 0.5) * 2.2
                    local j = jitter * (0.5 + 0.5 * (1 - t))
                    local off = j * (0.3 + math.random() * 0.7)
                    point = point + Vec(math.cos(driftAng) * off, (math.random() - 0.5) * j * 0.25, math.sin(driftAng) * off)
                end
                local len = math.max((point - prev).Magnitude, 0.1)
                local cf = CFrame.lookAt((point + prev) * 0.5, point)
                segs[#segs + 1] = { p = mkSeg(BOLT_CORE, 0.02, thick, len + thick * 1.6, cf, model), on = 0.02, fade = 0.16 }
                segs[#segs + 1] = { p = mkSeg(BOLT_GLOW, 0.78, thick * 5.5, len + thick * 1.8, cf, model), on = 0.78, fade = 0.38 }
                if layer3 then
                    segs[#segs + 1] = { p = mkSeg(BOLT_AFTER, 0.88, thick * 2.2, len + thick * 1.6, cf, model), on = 0.75, fade = 0.85 }
                end
                pts[#pts + 1] = point
                prev = point
            end
            return pts
        end
        function boltBranch(model, segs, fromPts, groundY, thick, depth)
            local count = 1
            if depth == 1 then count = math.random(2, 4) end
            for _ = 1, count do
                local idx = math.random(math.floor(#fromPts * 0.2), math.floor(#fromPts * 0.7))
                local a = fromPts[math.max(idx, 2)]
                local ang = math.random() * 6.283
                local drop = (a.Y - groundY) * (0.3 + math.random() * 0.25)
                local outw = drop * (0.55 + math.random() * 0.4)
                local endp = a + Vec(math.cos(ang) * outw, -drop, math.sin(ang) * outw)
                local n = 5
                if depth == 1 then n = 8 end
                local blen = (endp - a).Magnitude
                local pts = boltChannel(model, segs, a, endp, n, thick, math.max(5, blen * 0.1) / depth, false)
                if depth < 3 and math.random() < 0.5 then
                    boltBranch(model, segs, pts, groundY, thick * 0.45, depth + 1)
                end
            end
        end
        function preFlash(pos, scale)
            local host = mkBoltPart(BOLT_CORE, 1, Vec(2, 2, 2), CFrame.new(pos), getLightFolder())
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = TX_BGLOW
            e.Color = ColorSequence.new(Color3.fromRGB(206, 192, 255))
            e.LightEmission = 0.85; e.LightInfluence = 0
            e.Size = NumberSequence.new(60 * scale, 85 * scale)
            e.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.25, 0.55),
                NumberSequenceKeypoint.new(0.7, 0.75), NumberSequenceKeypoint.new(1, 1),
            })
            e.Lifetime = NumberRange.new(0.22, 0.3)
            e.Rate = 0; e.Speed = NumberRange.new(0, 0.5)
            e.Parent = host
            e:Emit(1)
            task.delay(0.09, function() pcall(function() e:Emit(1) end) end)
            Debris:AddItem(host, 1.2)
        end
        function screenFlash()
            local cc = Instance.new("ColorCorrectionEffect")
            cc.Name = "_wxFlash"; cc:SetAttribute("WX_Custom", true); cc.Brightness = 0.35; cc.Parent = Lighting
            local pulseA = 0.3 + math.random() * 0.25
            local pulseB = -1
            if math.random() < 0.6 then pulseB = pulseA + 0.18 + math.random() * 0.12 end
            local st = tick(); local c2
            c2 = RunService.Heartbeat:Connect(function()
                if not cc.Parent then if c2 then c2:Disconnect() end return end
                local a = (tick() - st) / 0.45
                if a >= 1 then pcall(function() cc:Destroy() end); if c2 then c2:Disconnect() end return end
                local b = 0.35 * (1 - a)
                if a >= pulseA and a < pulseA + 0.14 then
                    b = b + 0.22 * (1 - (a - pulseA) / 0.14)
                elseif pulseB > 0 and a >= pulseB and a < pulseB + 0.14 then
                    b = b + 0.16 * (1 - (a - pulseB) / 0.14)
                end
                cc.Brightness = b
            end)
            Debris:AddItem(cc, 0.7)
        end
        function igniteBolt(ground, top)
            local model = Instance.new("Model"); model.Name = "_bolt"; model:SetAttribute("WX_Custom", true)
            local segs = {}
            local mainPts = boltChannel(model, segs, top, ground, 18, 1.0, 14, true)
            boltBranch(model, segs, mainPts, ground.Y, 0.55, 1)
            local dome = mkBoltPart(Color3.fromRGB(228, 240, 255), 0.5, Vec(0.6, 5, 5),
                CFrame.new(ground + Vec(0, 0.3, 0)) * CFrame.Angles(0, 0, math.rad(90)), model)
            dome.Shape = Enum.PartType.Cylinder
            local fl = Instance.new("PointLight"); fl.Color = BOLT_GLOW; fl.Range = 150; fl.Brightness = 8; fl.Parent = dome
            TweenService:Create(dome, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                { Size = Vec(0.6, 30, 30), Transparency = 1 }):Play()
            TweenService:Create(fl, TweenInfo.new(0.5), { Brightness = 0 }):Play()
            local cb = mkBoltPart(BOLT_CORE, 1, Vec(2, 2, 2), CFrame.new(ground + Vec(0, 1.5, 0)), model)
            local ce = Instance.new("ParticleEmitter")
            ce:SetAttribute("WX_Custom", true)
            ce.Texture = TX_BGLOW
            ce.Color = ColorSequence.new(Color3.fromRGB(235, 228, 255))
            ce.LightEmission = 1; ce.LightInfluence = 0
            ce.Size = NumberSequence.new(13, 17)
            ce.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 1),
            })
            ce.Lifetime = NumberRange.new(0.3, 0.4)
            ce.Rate = 0; ce.Speed = NumberRange.new(0, 0.1)
            ce.Parent = cb
            local se = Instance.new("ParticleEmitter")
            se:SetAttribute("WX_Custom", true)
            se.Texture = TX_BSTREAK
            se.Color = ColorSequence.new(Color3.fromRGB(220, 205, 255))
            se.LightEmission = 1; se.LightInfluence = 0
            se.Size = NumberSequence.new(2, 3)
            se.Transparency = NumberSequence.new(0.25, 1)
            se.Lifetime = NumberRange.new(0.5, 0.9)
            se.Rate = 0; se.Speed = NumberRange.new(26, 44)
            se.SpreadAngle = Vector2.new(38, 38)
            se.Orientation = Enum.ParticleOrientation.VelocityParallel
            se.EmissionDirection = Enum.NormalId.Top
            se.Acceleration = Vec(0, -40, 0)
            se.Parent = cb
            ce:Emit(1)
            se:Emit(9)
            model.Parent = getLightFolder()
            preFlash(top + Vec(0, 10, 0), 1.5)
            local flickEnd = FLICK
            local restrikeAt = -1
            if math.random() < 0.3 then restrikeAt = FLICK + 0.08 + math.random() * 0.07 end
            local startT = tick(); local conn
            conn = RunService.Heartbeat:Connect(function()
                if not model.Parent then if conn then conn:Disconnect() end return end
                local a = tick() - startT
                if restrikeAt > 0 and a >= restrikeAt then
                    restrikeAt = -1
                    flickEnd = a + 0.1
                    fl.Brightness = 6
                    TweenService:Create(fl, TweenInfo.new(0.4), { Brightness = 0 }):Play()
                end
                if a < flickEnd then
                    local dim = 0
                    if math.random() < 0.28 then dim = 0.85 end
                    for i = 1, #segs do
                        local s = segs[i]
                        s.p.Transparency = s.on + (1 - s.on) * dim
                    end
                    return
                end
                local f = a - flickEnd
                if f >= 0.85 then
                    if conn then conn:Disconnect() end
                    pcall(function() model:Destroy() end)
                    return
                end
                for i = 1, #segs do
                    local s = segs[i]
                    local k = math.clamp(f / s.fade, 0, 1)
                    s.p.Transparency = s.on + (1 - s.on) * k
                end
            end)
            Debris:AddItem(model, 1.8)
            if cfg("WeatherStormFlash", true) then screenFlash() end
            local tid = cfg("WeatherThunderId", "")
            if tid ~= "" then
                local cam = Camera
                local dist = 120
                if cam then dist = (ground - cam.CFrame.Position).Magnitude end
                task.delay(dist * (3 / 343), function()
                    oneShot(tid, cfg("WeatherSoundVolume", 0.35) * 8 * (0.85 + math.random() * 0.3),
                        0.92 + math.random() * 0.16)
                end)
            end
        end
        function spawnBolt()
            if not Config.Weather or not cfg("WeatherStorm", false) then return end
            local cam = Camera; if not cam then return end
            local base = cam.CFrame.Position
            local lv = cam.CFrame.LookVector
            local flat = Vec(lv.X, 0, lv.Z)
            if flat.Magnitude < 0.05 then flat = Vec(0, 0, -1) else flat = flat.Unit end
            local right = Vec(flat.Z, 0, -flat.X)
            local fwd  = 55 + math.random() * 95
            local side = (math.random() - 0.5) * 85
            local gx = base.X + flat.X * fwd + right.X * side
            local gz = base.Z + flat.Z * fwd + right.Z * side
            local ground = Vec(gx + (math.random() - 0.5) * 20, base.Y - 45, gz + (math.random() - 0.5) * 20)
            local ch = lp and lp.Character
            if ch then
                _boltRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _boltRp.FilterDescendantsInstances = { getFolder() }
            end
            local hit = Workspace:Raycast(Vec(gx, base.Y + 140, gz), Vec(0, -400, 0), _boltRp)
            if hit then ground = hit.Position end
            local top = Vec(gx + (math.random() - 0.5) * 90, base.Y + 280, gz + (math.random() - 0.5) * 90)
            preFlash(Vec(top.X, top.Y - 20, top.Z), 1)
            task.delay(0.1 + math.random() * 0.2, function()
                if not Config.Weather or not cfg("WeatherStorm", false) then return end
                pcall(function() igniteBolt(ground, top) end)
            end)
        end
        function startStorm()
            if _stormConn then return end
            _stormNextT = tick() + 2 + math.random() * 3
            _stormConn = RunService.Heartbeat:Connect(function()
                if not Config.Weather or not cfg("WeatherStorm", false) then return end
                local now = tick()
                if now >= _stormNextT then
                    _stormNextT = now + cfg("WeatherStormMin", 4)
                        + math.random() * cfg("WeatherStormVar", 8)
                    pcall(spawnBolt)
                end
            end)
        end
        function rescheduleStorm()
            if not _stormConn then
                return
            end
            local cap = tick() + cfg("WeatherStormMin", 4) + cfg("WeatherStormVar", 8)
            _stormNextT = math.min(_stormNextT, cap)
        end
        function stopStormLoop()
            if _stormConn then _stormConn:Disconnect(); _stormConn = nil end
        end
        function stopStorm()
            stopStormLoop()
            if _lightFolder then pcall(function() _lightFolder:Destroy() end); _lightFolder = nil end
        end
        registerSpectacle("StormBarrage", 1, function()
            if not Config.Weather or not cfg("WeatherStorm", false) then return end
            for i = 0, 2 do
                task.delay(i * (0.35 + math.random() * 0.3), function() pcall(spawnBolt) end)
            end
        end)
    end)()
    function startFollow()
        if _followConn then return end
        local now0 = tick()
        Wind.reset(now0)
        _spectNextT = now0 + 120 + math.random() * 120
        _followConn = RunService.Heartbeat:Connect(function()
            if not Config.Weather then return end
            local now = tick()
            Wind.update(now)
            local amb = _ambient
            if amb then
                local vol = cfg("WeatherSoundVolume", 0.35)
                if amb.Volume ~= vol then amb.Volume = vol end
            end
            local cam = Camera; if not cam then return end
            local pos = cam.CFrame.Position
            if now >= _spectNextT then
                _spectNextT = now + 120 + math.random() * 120
                if _spectWeight > 0 then
                    local r = math.random() * _spectWeight
                    for i = 1, #_spectacles do
                        local s = _spectacles[i]
                        r = r - s.weight
                        if r <= 0 then
                            pcall(s.fn)
                            break
                        end
                    end
                end
            end
            local wgain = 1
            local bt = (now - _blizzT0) / _blizzDur
            if bt >= 0 and bt < 1 then
                wgain = 1 + 1.7 * math.sin(bt * math.pi)
            end
            local nwx, nwz = 1, 0
            local wl = math.sqrt(Wind.x * Wind.x + Wind.z * Wind.z)
            if wl > 0.05 then
                nwx = Wind.x / wl
                nwz = Wind.z / wl
            end
            for i = 1, #_partLayers do
                local L = _partLayers[i]
                if L.host and L.host.Parent then
                    local hx, hz = pos.X, pos.Z
                    if L.uw then
                        hx = hx - nwx * L.uw
                        hz = hz - nwz * L.uw
                    end
                    local hy = pos.Y + L.oy
                    if L.aim then
                        L.host.CFrame = CFrame.lookAt(Vec(hx, hy, hz), Vec(hx + nwx, hy, hz + nwz))
                    else
                        L.host.CFrame = CFrame.new(hx, hy, hz)
                    end
                    local g = L.gust
                    if g then
                        L.emitter.Acceleration = L.accel + Vec(
                            Wind.x * wgain * L.gax * (1 + 0.3 * math.sin(now * g.wx + g.ph)), 0,
                            Wind.z * wgain * L.gaz * (1 + 0.3 * math.cos(now * g.wz + g.ph)))
                    end
                end
            end
            for i = 1, #_fadeLayers do
                local F = _fadeLayers[i]
                if F.host and F.host.Parent then
                    F.host.CFrame = CFrame.new(pos.X, pos.Y + F.oy, pos.Z)
                end
            end
        end)
    end
    function stopFollow()
        if _followConn then _followConn:Disconnect(); _followConn = nil end
    end
    do
        local SWELL_UP = TweenInfo.new(2.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local SWELL_DOWN = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        function windSwell(kind, dur, rateMul)
            if not Config.Weather or _curType ~= kind then return end
            _blizzT0, _blizzDur = tick(), dur
            local surged = {}
            local I = iAmt()
            for _, L in _partLayers do
                if L.emitter and L.tag ~= "settle" then
                    if L.rateTween then L.rateTween:Cancel() end
                    L.rateMul = rateMul
                    local tw = TweenService:Create(L.emitter, SWELL_UP, { Rate = layerRate(L, I) * rateMul })
                    L.rateTween = tw
                    tw:Play()
                    surged[#surged + 1] = L
                end
            end
            task.delay(dur - 3, function()
                local I2 = iAmt()
                for _, L in surged do
                    local live = false
                    for _, cur in _partLayers do
                        if cur == L then live = true break end
                    end
                    if live and L.emitter and L.emitter.Parent then
                        if L.rateTween then L.rateTween:Cancel() end
                        L.rateMul = 1
                        local tw = TweenService:Create(L.emitter, SWELL_DOWN, { Rate = layerRate(L, I2) })
                        L.rateTween = tw
                        tw:Play()
                    end
                end
            end)
        end
        registerSpectacle("SnowBlizzard", 1, function()
            windSwell("Snow", 11 + math.random() * 3, 1.9)
        end)
        registerSpectacle("SakuraGale", 1, function()
            windSwell("Petals", 9 + math.random() * 4, 1.7)
        end)
    end
    do
        local GUST_UP   = TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local GUST_DOWN = TweenInfo.new(2.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local STREAK_BURST = { {0.3, 18}, {0.65, 14}, {1.05, 9} }
        Wind.onGust(function(dur)
            if not Config.Weather or _curType ~= "Autumn" then return end
            local I = iAmt()
            local em = iRate(I, IR.Autumn.lo, IR.Autumn.hi)
            local gm = 1 + 0.4 * I
            local surged = {}
            for _, L in _partLayers do
                if L.emitter and L.tag == "dust" then
                    local e = L.emitter
                    local n2 = math.max(1, math.floor(10 * em + 0.5))
                    e:Emit(math.max(1, math.floor(14 * em + 0.5)))
                    task.delay(0.4, function()
                        if e.Parent then e:Emit(n2) end
                    end)
                elseif L.emitter and L.tag == "streak" then
                    local e = L.emitter
                    e:Emit(math.max(1, math.floor(20 * em + 0.5)))
                    for _, b in STREAK_BURST do
                        local n = math.max(1, math.floor(b[2] * em + 0.5))
                        task.delay(b[1], function()
                            if e.Parent then e:Emit(n) end
                        end)
                    end
                elseif L.emitter and L.tag ~= "settle" then
                    if L.rateTween then L.rateTween:Cancel() end
                    L.rateMul = gm
                    local tw = TweenService:Create(L.emitter, GUST_UP, { Rate = layerRate(L, I) * gm })
                    L.rateTween = tw
                    tw:Play()
                    surged[#surged + 1] = L
                end
            end
            task.delay(dur, function()
                local I2 = iAmt()
                for _, L in surged do
                    local live = false
                    for _, cur in _partLayers do
                        if cur == L then live = true break end
                    end
                    if live and L.emitter and L.emitter.Parent then
                        if L.rateTween then L.rateTween:Cancel() end
                        L.rateMul = 1
                        local tw = TweenService:Create(L.emitter, GUST_DOWN, { Rate = layerRate(L, I2) })
                        L.rateTween = tw
                        tw:Play()
                    end
                end
            end)
        end)
    end
    function clearSpecial()
        if _specialConn then _specialConn:Disconnect(); _specialConn = nil end
        if _special.moon  then pcall(function() _special.moon:Destroy() end);  _special.moon  = nil end
        if _special.shell then pcall(function() _special.shell:Destroy() end); _special.shell = nil end
        if _special.sky   then pcall(function() _special.sky:Destroy() end);   _special.sky   = nil end
        if _special.cc    then pcall(function() _special.cc:Destroy() end);    _special.cc    = nil end
        if _special.atmo  then pcall(function() _special.atmo:Destroy() end);  _special.atmo  = nil end
        _special.halo = nil
        _special.kind = nil
    end
    function tuneBloodMoon(I)
        local ms = 0.72 + 0.28 * I
        local gr = 0.5 + 0.5 * I
        if _special.moon then
            _special.moon.Size = Vec(130, 130, 130) * ms
        end
        if _special.shell then
            _special.shell.Size = Vec(160, 160, 160) * ms
        end
        if _special.halo then
            _special.halo.Rate = 25 * iRate(I, 1.45, 1.05)
            _special.halo.Size = NumberSequence.new(330 * ms)
        end
        if _special.cc then
            _special.cc.Saturation = -0.15 * gr
            _special.cc.Brightness = -0.04 * gr
        end
        if _special.atmo then
            _special.atmo.Density = 0.12 + 0.18 * I
            _special.atmo.Haze    = 0.9 + 0.9 * I
            _special.atmo.Glare   = 0.4 + 0.4 * I
        end
        if _special.sky then
            _special.sky.StarCount = math.floor(4000 * (0.55 + 0.45 * I))
        end
    end
    function buildBloodMoon()
        local folder = getFolder()
        local s = Instance.new("Sky"); s.Name = "_wxSkyBM"; s:SetAttribute("WX_Custom", true)
        s.SkyboxBk = "rbxassetid://159454299"; s.SkyboxDn = "rbxassetid://159454296"
        s.SkyboxFt = "rbxassetid://159454293"; s.SkyboxLf = "rbxassetid://159454286"
        s.SkyboxRt = "rbxassetid://159454300"; s.SkyboxUp = "rbxassetid://159454288"
        s.SunAngularSize = 0; s.MoonAngularSize = 0; s.StarCount = 4000
        s.Parent = Lighting; _special.sky = s
        local moon = Instance.new("Part")
        moon.Shape = Enum.PartType.Ball; moon.Size = Vec(130, 130, 130)
        moon.Material = Enum.Material.Neon; moon.Color = Color3.fromRGB(215, 45, 35)
        moon.Anchored = true; moon.CanCollide = false; moon.CanQuery = false; moon.CanTouch = false
        moon.CastShadow = false; moon.Massless = true; moon:SetAttribute("WX_Custom", true)
        local att = Instance.new("Attachment"); att.Parent = moon
        local halo = Instance.new("ParticleEmitter")
        halo.Texture = TX_SOFT; halo.Color = ColorSequence.new(Color3.fromRGB(255, 60, 42))
        halo.LightEmission = 1; halo.LightInfluence = 0
        halo.Rate = 25; halo.Lifetime = NumberRange.new(0.22, 0.28)
        halo.Speed = NumberRange.new(0, 0); halo.Size = NumberSequence.new(330)
        halo.Transparency = NumberSequence.new(0.72); halo.RotSpeed = NumberRange.new(0, 0)
        halo.Parent = att; _special.halo = halo
        moon.Parent = folder; _special.moon = moon
        local shell = Instance.new("Part")
        shell.Shape = Enum.PartType.Ball; shell.Size = Vec(160, 160, 160)
        shell.Material = Enum.Material.Neon; shell.Color = Color3.fromRGB(255, 60, 45); shell.Transparency = 0.7
        shell.Anchored = true; shell.CanCollide = false; shell.CanQuery = false; shell.CanTouch = false
        shell.CastShadow = false; shell.Massless = true; shell:SetAttribute("WX_Custom", true)
        shell.Parent = folder; _special.shell = shell
        local cc = Instance.new("ColorCorrectionEffect"); cc.Name = "_wxBM"; cc:SetAttribute("WX_Custom", true)
        cc.TintColor = Color3.fromRGB(255, 165, 160); cc.Saturation = -0.15; cc.Brightness = -0.04
        cc.Parent = Lighting; _special.cc = cc
        local at = Instance.new("Atmosphere"); at.Name = "_wxBMAtmo"; at:SetAttribute("WX_Custom", true)
        at.Density = 0.3; at.Color = Color3.fromRGB(125, 35, 35); at.Decay = Color3.fromRGB(190, 55, 50)
        at.Glare = 0.8; at.Haze = 1.8; at.Parent = Lighting; _special.atmo = at
        _special.kind = "BloodMoon"
        tuneBloodMoon(iAmt())
    end
    function startSpecialAnim()
        if _specialConn then return end
        local accum = 0
        _specialConn = RunService.Heartbeat:Connect(function(dt)
            if not Config.Weather or not _special.kind then return end
            accum = accum + dt
            if accum < 0.05 then return end
            accum = 0
            accum = accum + dt
            if accum < 0.1 then return end
            accum = 0
            local cam = Camera; if not cam then return end
            local pos = cam.CFrame.Position
            if _special.kind == "BloodMoon" and _special.moon then
                local cf = CFrame.new(pos + Vec(0.45, 0.62, -0.64).Unit * 700)
                _special.moon.CFrame = cf
                if _special.shell then _special.shell.CFrame = cf end
            end
        end)
    end
    local CSK, NSK = ColorSequenceKeypoint.new, NumberSequenceKeypoint.new
    local TX_MGLOW = "rbxassetid://78582616787441"
    local startMeteors, stopMeteors, rescheduleMeteors
    ;(function()
        local MET_TXS  = "rbxassetid://77935321198144"
        local MET_TXK  = "rbxassetid://102481842205398"
        local MET_TXD  = "rbxassetid://341828512"
        local MET_HAZE = Color3.fromRGB(128, 146, 176)
        local MET_GLOW = {
            { z = -0.80, size = 0.85, tr = 0.03, col = Color3.fromRGB(255, 246, 216), life = 0.09, rate = 34, b0 = 1.35, b1 = 2.1 },
            { z = -0.10, size = 1.75, tr = 0.55, col = Color3.fromRGB(255, 194, 106), life = 0.10, rate = 30, b0 = 0.85, b1 = 1.4 },
            { z =  1.30, size = 3.10, tr = 0.80, col = Color3.fromRGB(255, 124,  46), life = 0.11, rate = 26, b0 = 0.5, b1 = 0.8 },
            { z =  3.20, size = 5.20, tr = 0.92, col = Color3.fromRGB(224,  72,  26), life = 0.12, rate = 22, b0 = 0.4, b1 = 0.6 },
        }
        local MET_ROCK = {
            { 1.00, 0.74, 1.28,  0.00,  0.00,  0.00, 0.25, 0.40, 0.18, 58, 51, 47, 0.00, true },
            { 0.70, 0.60, 0.76,  0.40,  0.20,  0.12, 0.80, 0.50, 1.10, 47, 41, 39, 0.00, true },
            { 0.58, 0.48, 0.64, -0.38, -0.26,  0.34, 1.20, 0.90, 0.30, 36, 31, 30, 0.00, true },
            { 0.46, 0.40, 0.52,  0.06, -0.42, -0.24, 0.40, 1.30, 0.70, 52, 45, 42, 0.00, true },
            { 0.36, 0.30, 0.40, -0.32,  0.36, -0.08, 0.90, 0.20, 1.40, 42, 36, 34, 0.00, true },
            { 0.30, 0.26, 0.34,  0.22, -0.10,  0.46, 1.50, 0.70, 0.20, 38, 33, 32, 0.00, true },
            { 0.26, 0.34, 0.22, -0.20, -0.34, -0.02, 0.60, 1.10, 0.90, 33, 29, 28, 0.00, true },
            { 0.52, 0.40, 0.16,  0.10,  0.06, -0.56, 0.00, 0.00, 0.50, 255, 244, 214, 0.10, false },
            { 0.30, 0.46, 0.14, -0.30, -0.14, -0.44, 0.00, 0.00, -0.90, 255, 190, 104, 0.28, false },
            { 0.34, 0.20, 0.12,  0.16, -0.34, -0.40, 0.00, 0.00, 0.20, 255, 158,  66, 0.36, false },
            { 0.22, 0.16, 0.10, -0.10,  0.34, -0.38, 0.00, 0.00, 1.20, 255, 214, 150, 0.30, false },
        }
        local MET_ABL0 = 8
        local MET_ABLA = { 0.06, 0.20, 0.26, 0.22 }
        local MET_ABLK = { 0.20, 0.24, 0.26, 0.26 }
        local MET_UP, MET_DOWN = Vec(0, 300, 0), Vec(0, -800, 0)
        local _metConn = nil
        local _metNextFar, _metNextNear = 0, 0
        local _metFar, _metNear = 0, 0
        local _metLive = {}
        local _metRp = RaycastParams.new()
        _metRp.FilterType = Enum.RaycastFilterType.Exclude
        function hz(c, k)
            return c:Lerp(MET_HAZE, k)
        end
        function metPart(sx, sy, sz, cf)
            local p = Instance.new("Part")
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Massless = true
            p.TopSurface = Enum.SurfaceType.Smooth; p.BottomSurface = Enum.SurfaceType.Smooth
            p.Size = Vec(sx, sy, sz); p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p.Parent = getLightFolder()
            return p
        end
        function metFilter()
            local ch = nil
            if lp then ch = lp.Character end
            if ch then
                _metRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _metRp.FilterDescendantsInstances = { getFolder() }
            end
        end
        function metSolveLand(base, out, tang)
            local d = 90 + math.random() * 110
            local lat = (math.random() - 0.5) * 160
            for _ = 1, 2 do
                local c = base + out * d + tang * lat
                local h = Workspace:Raycast(c + MET_UP, MET_DOWN, _metRp)
                if h then
                    return h.Position + Vec(0, 1.5, 0)
                end
                d = d * 0.5
                lat = lat * 0.5
            end
            return nil
        end
        function metGlow(host, size, transp, color, life, rate)
            local g = Instance.new("ParticleEmitter")
            g:SetAttribute("WX_Custom", true)
            g.Texture = TX_MGLOW; g.Color = ColorSequence.new(color)
            g.LightEmission = 1; g.LightInfluence = 0
            g.Rate = rate; g.Lifetime = NumberRange.new(life, life)
            g.Size = NumberSequence.new(size); g.Transparency = NumberSequence.new(transp)
            g.Speed = NumberRange.new(0, 0); g.LockedToPart = true
            g.Parent = host
            return g
        end
        function metRibbon(part, sep, c0, c1, a0, w1, life, emit, inf)
            local aT = Instance.new("Attachment"); aT.Position = Vec(0, sep * 0.5, 0); aT.Parent = part
            local aB = Instance.new("Attachment"); aB.Position = Vec(0, -sep * 0.5, 0); aB.Parent = part
            local tr = Instance.new("Trail")
            tr:SetAttribute("WX_Custom", true)
            tr.Attachment0 = aT; tr.Attachment1 = aB; tr.FaceCamera = true
            tr.Texture = TX_MGLOW; tr.TextureMode = Enum.TextureMode.Stretch; tr.TextureLength = 1
            tr.Color = ColorSequence.new(c0, c1)
            tr.Transparency = NumberSequence.new({ NSK(0, a0), NSK(0.6, a0 + (1 - a0) * 0.45), NSK(1, 1) })
            tr.WidthScale = NumberSequence.new({ NSK(0, 1), NSK(1, w1) })
            tr.Lifetime = life; tr.LightEmission = emit; tr.LightInfluence = inf
            tr.MinLength = 0.05
            tr.Parent = part
            return { t = tr, a = aT, b = aB, sep = sep }
        end
        function metSmoke(host, sb, lo, hi, rate, aBase, drift, spread, k)
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = MET_TXS
            e.Color = ColorSequence.new({
                CSK(0,   hz(Color3.fromRGB(178, 164, 152), k * 0.5)),
                CSK(0.2, hz(Color3.fromRGB(146, 142, 138), k * 0.5)),
                CSK(1,   hz(Color3.fromRGB(84, 82, 80), k * 0.5)) })
            e.LightEmission = 0.02; e.LightInfluence = 0.6
            e.Rate = rate; e.Lifetime = NumberRange.new(lo, hi)
            e.Size = NumberSequence.new({ NSK(0, sb), NSK(0.35, sb * 1.9), NSK(1, sb * 3) })
            e.Transparency = NumberSequence.new({
                NSK(0, 0.94), NSK(0.07, aBase + 0.16 * k), NSK(0.62, aBase + 0.16), NSK(1, 1) })
            e.Speed = NumberRange.new(0, spread); e.SpreadAngle = Vector2.new(60, 60)
            e.Drag = 0.5
            e.RotSpeed = NumberRange.new(-8, 8); e.Rotation = NumberRange.new(0, 360)
            e.Acceleration = Vec(Wind.x * drift, 0.35, Wind.z * drift)
            e.Parent = host
            return e
        end
        function bez(p0, p1, p2, a)
            return p0:Lerp(p1, a):Lerp(p1:Lerp(p2, a), a)
        end
        function metImpact(pos, sc)
            if Camera then
                sc = math.min(sc, math.max(0.85, (pos - Camera.CFrame.Position).Magnitude / 44))
            end
            local host = metPart(4 * sc, 4 * sc, 4 * sc, CFrame.new(pos))
            host.Shape = Enum.PartType.Ball; host.Material = Enum.Material.Neon
            host.Color = Color3.fromRGB(255, 240, 202); host.Transparency = 0.05
            local fl = Instance.new("PointLight")
            fl.Color = Color3.fromRGB(255, 176, 90); fl.Range = 150; fl.Brightness = 9; fl.Parent = host
            local glow = metPart(2, 2, 2, CFrame.new(pos + Vec(0, 3, 0)))
            glow.Transparency = 1
            local gl = Instance.new("PointLight")
            gl.Color = Color3.fromRGB(255, 148, 68); gl.Range = 120 * sc; gl.Brightness = 4; gl.Parent = glow
            local ring = metPart(12 * sc, 2 * sc, 12 * sc, CFrame.new(pos))
            ring.Shape = Enum.PartType.Ball; ring.Material = Enum.Material.Neon
            ring.Color = Color3.fromRGB(255, 150, 60); ring.Transparency = 0.35
            local scorch = metPart(15 * sc, 0.6, 15 * sc, CFrame.new(pos - Vec(0, 0.4, 0)))
            scorch.Shape = Enum.PartType.Ball; scorch.Material = Enum.Material.Neon
            scorch.Color = Color3.fromRGB(255, 104, 24); scorch.Transparency = 0.2
            local att = Instance.new("Attachment"); att.Parent = host
            local datt = Instance.new("Attachment"); datt.Orientation = Vec(0, 0, -90); datt.Parent = host
            local flash = Instance.new("ParticleEmitter")
            flash:SetAttribute("WX_Custom", true)
            flash.Texture = TX_MGLOW; flash.Rate = 0
            flash.Color = ColorSequence.new({
                CSK(0,    Color3.fromRGB(255, 246, 214)),
                CSK(0.45, Color3.fromRGB(255, 186, 96)),
                CSK(1,    Color3.fromRGB(226, 96, 34)) })
            flash.LightEmission = 1; flash.LightInfluence = 0
            flash.Lifetime = NumberRange.new(0.30, 0.30)
            flash.Size = NumberSequence.new({ NSK(0, 14 * sc), NSK(0.35, 34 * sc), NSK(1, 44 * sc) })
            flash.Transparency = NumberSequence.new({ NSK(0, 0.05), NSK(0.45, 0.42), NSK(1, 1) })
            flash.Speed = NumberRange.new(0, 0); flash.Rotation = NumberRange.new(0, 360)
            flash.Parent = att
            flash:Emit(2)
            local dust = Instance.new("ParticleEmitter")
            dust:SetAttribute("WX_Custom", true)
            dust.Texture = MET_TXD; dust.Rate = 0
            dust.Color = ColorSequence.new(Color3.fromRGB(198, 178, 152), Color3.fromRGB(120, 112, 104))
            dust.LightEmission = 0.05; dust.LightInfluence = 0.5
            dust.Lifetime = NumberRange.new(5.5, 9)
            dust.Size = NumberSequence.new({ NSK(0, 6 * sc), NSK(1, 22 * sc) })
            dust.Transparency = NumberSequence.new({ NSK(0, 0.6), NSK(0.1, 0.42), NSK(0.6, 0.68), NSK(1, 1) })
            dust.Speed = NumberRange.new(22, 38); dust.SpreadAngle = Vector2.new(0, 180)
            dust.Drag = 1.9; dust.EmissionDirection = ND.Top
            dust.RotSpeed = NumberRange.new(-16, 16); dust.Rotation = NumberRange.new(0, 360)
            dust.Acceleration = Vec(Wind.x * 6, 0.4, Wind.z * 6)
            dust.Parent = datt
            dust:Emit(math.floor(24 * sc))
            local fount = Instance.new("ParticleEmitter")
            fount:SetAttribute("WX_Custom", true)
            fount.Texture = MET_TXK; fount.Rate = 0
            fount.Color = ColorSequence.new(Color3.fromRGB(255, 200, 110), Color3.fromRGB(196, 52, 14))
            fount.LightEmission = 1; fount.LightInfluence = 0
            fount.Lifetime = NumberRange.new(1.1, 2.2)
            fount.Size = NumberSequence.new({ NSK(0, 1.7 * sc), NSK(1, 0.08) })
            fount.Transparency = NumberSequence.new({ NSK(0, 0), NSK(0.7, 0.35), NSK(1, 1) })
            fount.Orientation = Enum.ParticleOrientation.VelocityParallel
            fount.Speed = NumberRange.new(48, 96); fount.SpreadAngle = Vector2.new(30, 30)
            fount.Acceleration = Vec(0, -74, 0); fount.Drag = 0.35
            fount.EmissionDirection = ND.Top; fount.Parent = att
            fount:Emit(math.floor(52 * sc))
            local col = Instance.new("ParticleEmitter")
            col:SetAttribute("WX_Custom", true)
            col.Texture = TX_MGLOW; col.Rate = 0
            col.Color = ColorSequence.new({
                CSK(0,    Color3.fromRGB(255, 236, 180)),
                CSK(0.35, Color3.fromRGB(255, 130, 40)),
                CSK(1,    Color3.fromRGB(122, 40, 18)) })
            col.LightEmission = 0.9; col.LightInfluence = 0
            col.Lifetime = NumberRange.new(0.55, 1.05)
            col.Size = NumberSequence.new({ NSK(0, 5 * sc), NSK(1, 14 * sc) })
            col.Transparency = NumberSequence.new({ NSK(0, 0.12), NSK(0.6, 0.55), NSK(1, 1) })
            col.Speed = NumberRange.new(32, 62); col.SpreadAngle = Vector2.new(10, 10)
            col.EmissionDirection = ND.Top; col.Parent = att
            col:Emit(18)
            local pil = Instance.new("ParticleEmitter")
            pil:SetAttribute("WX_Custom", true)
            pil.Texture = MET_TXS; pil.Rate = 0
            pil.Color = ColorSequence.new({
                CSK(0,   Color3.fromRGB(186, 150, 118)),
                CSK(0.3, Color3.fromRGB(146, 140, 132)),
                CSK(1,   Color3.fromRGB(88, 85, 82)) })
            pil.LightEmission = 0.02; pil.LightInfluence = 0.5
            pil.Lifetime = NumberRange.new(4.5, 8)
            pil.Size = NumberSequence.new({ NSK(0, 4.5 * sc), NSK(1, 20 * sc) })
            pil.Transparency = NumberSequence.new({ NSK(0, 0.52), NSK(0.5, 0.68), NSK(1, 1) })
            pil.Speed = NumberRange.new(16, 30); pil.SpreadAngle = Vector2.new(9, 9)
            pil.Acceleration = Vec(Wind.x * 7, 2.6, Wind.z * 7); pil.Drag = 0.6
            pil.EmissionDirection = ND.Top
            pil.RotSpeed = NumberRange.new(-12, 12); pil.Rotation = NumberRange.new(0, 360)
            pil.Parent = att
            task.delay(0.12, function() if pil.Parent then pil:Emit(7) end end)
            task.delay(0.62, function() if pil.Parent then pil:Emit(5) end end)
            task.delay(1.30, function() if pil.Parent then pil:Emit(4) end end)
            local t0 = tick()
            local conn
            conn = RunService.Heartbeat:Connect(function()
                if not host.Parent then
                    conn:Disconnect()
                    return
                end
                local k = tick() - t0
                local f1 = math.clamp(k / 0.10, 0, 1)
                host.Size = Vec(1, 1, 1) * (4 + 6 * f1) * sc
                host.Transparency = 0.05 + 0.95 * f1
                fl.Brightness = 9 * (1 - math.clamp(k / 0.55, 0, 1))
                gl.Brightness = 4 * (1 - math.clamp(k / 5, 0, 1))
                local f2 = math.clamp(k / 0.55, 0, 1)
                ring.Size = Vec(12 + 52 * f2, 2 - 1.2 * f2, 12 + 52 * f2) * sc
                ring.Transparency = 0.35 + 0.65 * f2
                scorch.Transparency = 0.2 + 0.8 * math.clamp(k / 7, 0, 1)
                if k > 7.2 then
                    conn:Disconnect()
                end
            end)
            Debris:AddItem(ring, 1.1)
            Debris:AddItem(glow, 5.2)
            Debris:AddItem(scorch, 7.5)
            Debris:AddItem(host, 11)
        end
        function launch(far, opts)
            local ang = math.random() * 6.28318
            local mul = 1
            local big = false
            if opts then
                if opts.ang then ang = opts.ang end
                if opts.scaleMul then mul = opts.scaleMul end
                big = opts.big == true
            end
            local tang = Vec(-math.sin(ang), 0, math.cos(ang))
            local out = Vec(math.cos(ang), 0, math.sin(ang))
            local sgn = 1
            if math.random() < 0.5 then sgn = -1 end
            local base = Camera.CFrame.Position
            local startP, endP, spd, rs, ws, k, doImpact, smk
            if far then
                local ctr = base + out * (1400 + math.random() * 1200)
                          + Vec(0, 820 + math.random() * 360, 0)
                local travel = 3000 + math.random() * 900
                local drop = 320 + math.random() * 200
                startP = ctr - tang * (travel * 0.5 * sgn) + Vec(0, drop * 0.5, 0)
                endP = ctr + tang * (travel * 0.5 * sgn) - Vec(0, drop * 0.5, 0)
                spd = 255 + math.random() * 70
                rs = 14 + math.random() * 5
                ws = 3.9 + math.random()
                k = 0.14 + math.random() * 0.10
                doImpact = false
                smk = 1.6
            else
                metFilter()
                local land = nil
                if opts and opts.land then
                    local h = Workspace:Raycast(opts.land + MET_UP, MET_DOWN, _metRp)
                    if h then land = h.Position + Vec(0, 1.5, 0) end
                end
                if not land then land = metSolveLand(base, out, tang) end
                doImpact = land ~= nil
                if not land then
                    land = base + out * 150 + Vec(0, 40, 0)
                end
                local travel = 1750 + math.random() * 450
                startP = land - tang * (travel * sgn) + out * (190 + math.random() * 190)
                         + Vec(0, 640 + math.random() * 160, 0)
                if opts and opts.start then startP = opts.start end
                endP = land
                spd = 175 + math.random() * 38
                rs = (7.0 + math.random() * 2.6) * mul
                ws = (1.3 + math.random() * 0.28) * mul
                k = 0
                smk = 1
            end
            if big then
                rs = rs * 1.7
                ws = ws * 1.5
                spd = spd * 0.92
            end
            local flare = far or (not doImpact)
            local splitAt = nil
            if big and not (opts and opts.noSplit) then
                splitAt = 0.42 + math.random() * 0.12
            end
            local mid = startP:Lerp(endP, 0.5) + Vec(0, (endP - startP).Magnitude * 0.075, 0)
            local dur = ((startP - mid).Magnitude + (mid - endP).Magnitude) / spd
            local cf0 = CFrame.lookAt(startP, endP)
            local root = metPart(0.2, 0.2, 0.2, cf0)
            root.Transparency = 1
            local a0 = Instance.new("Attachment"); a0.Parent = root
            local glows = table.create(4)
            for i, s in MET_GLOW do
                local hp = metPart(0.2, 0.2, 0.2, cf0)
                hp.Transparency = 1
                glows[i] = { p = hp, z = s.z * rs, b0 = s.b0, b1 = s.b1,
                    e = metGlow(hp, s.size * rs, math.min(0.97, s.tr + 0.18 * k),
                        hz(s.col, k * 0.55), s.life, s.rate) }
            end
            local chunks = table.create(#MET_ROCK)
            for i, r in MET_ROCK do
                local p = metPart(r[1] * rs, r[2] * rs, r[3] * rs, cf0)
                p.Transparency = r[13]
                if r[14] then
                    p.Material = Enum.Material.Slate
                    p.Color = Color3.fromRGB(r[10], r[11], r[12])
                else
                    p.Material = Enum.Material.Neon
                    p.Color = hz(Color3.fromRGB(r[10], r[11], r[12]), k * 0.4)
                end
                chunks[i] = { p = p, tumble = r[14],
                    off = CFrame.new(r[4] * rs, r[5] * rs, r[6] * rs) * CFrame.Angles(r[7], r[8], r[9]) }
            end
            local noseLight, bodyLight = nil, nil
            if not far then
                noseLight = Instance.new("PointLight")
                noseLight.Color = Color3.fromRGB(255, 186, 108)
                noseLight.Range = 4.2 * rs; noseLight.Brightness = 11
                noseLight.Parent = glows[1].p
                bodyLight = Instance.new("PointLight")
                bodyLight.Color = Color3.fromRGB(255, 150, 70)
                bodyLight.Range = 16 * rs; bodyLight.Brightness = 3
                bodyLight.Parent = root
            end
            local ha = 0.20 * k
            local ribbons = {
                metRibbon(root, 7.5 * ws, hz(Color3.fromRGB(255, 253, 248), k * 0.3),
                    hz(Color3.fromRGB(255, 226, 156), k * 0.6), ha, 0.45, 0.26, 1, 0),
                metRibbon(root, 14 * ws, hz(Color3.fromRGB(255, 222, 146), k * 0.5),
                    hz(Color3.fromRGB(255, 136, 40), k * 0.9), 0.06 + ha, 0.36, 0.72, 1, 0),
                metRibbon(root, 23 * ws, hz(Color3.fromRGB(255, 138, 42), k * 0.9),
                    hz(Color3.fromRGB(196, 50, 14), k), 0.22 + ha, 0.28, 1.85, 1, 0),
                metRibbon(root, 33 * ws, hz(Color3.fromRGB(196, 62, 18), k),
                    hz(Color3.fromRGB(88, 26, 14), k), 0.52 + ha, 0.30, 3.20, 0.55, 0.12),
            }
            local trainRate = math.clamp(spd / (17 * ws * 0.30 * smk), 6, 30)
            local train = metSmoke(a0, 17 * ws, 5, 7.5, trainRate, 0.56, 5.6, 3, k)
            local scarRate = math.clamp(spd / (50 * ws * 0.28 * smk), 1.6, 9)
            local scar = metSmoke(a0, 50 * ws, 20, 32, scarRate, 0.74, 7.8, 7, k)
            local sparks = nil
            if not far then
                sparks = Instance.new("ParticleEmitter")
                sparks:SetAttribute("WX_Custom", true)
                sparks.Texture = MET_TXK
                sparks.Color = ColorSequence.new(Color3.fromRGB(255, 172, 70), Color3.fromRGB(186, 44, 12))
                sparks.LightEmission = 1; sparks.LightInfluence = 0
                sparks.Rate = 60; sparks.Lifetime = NumberRange.new(0.6, 1.5)
                sparks.Size = NumberSequence.new({ NSK(0, 2.2 * ws), NSK(1, 0.06) })
                sparks.Transparency = NumberSequence.new({ NSK(0, 0.08), NSK(1, 1) })
                sparks.Orientation = Enum.ParticleOrientation.VelocityParallel
                sparks.Speed = NumberRange.new(6, 20); sparks.SpreadAngle = Vector2.new(32, 32)
                sparks.Acceleration = Vec(0, -12, 0); sparks.Drag = 0.6
                sparks.Parent = a0
            end
            if far then _metFar = _metFar + 1 else _metNear = _metNear + 1 end
            local rec = { root = root }
            _metLive[#_metLive + 1] = rec
            local t0 = tick()
            local ph = math.random() * 20
            local spinX, spinY, spinZ = (math.random() - 0.5) * 3, (math.random() - 0.5) * 3.4,
                0.6 + math.random() * 1.6
            local flareAt = 0.76 + math.random() * 0.10
            local shedAt = 0.25 + math.random() * 0.2
            local dead, endT = false, nil
            local conn
            function retire()
                if dead then
                    return
                end
                dead = true
                if far then
                    _metFar = math.max(0, _metFar - 1)
                else
                    _metNear = math.max(0, _metNear - 1)
                end
                for i = #_metLive, 1, -1 do
                    if _metLive[i] == rec then table.remove(_metLive, i) end
                end
            end
            conn = RunService.Heartbeat:Connect(function()
                if not root.Parent then
                    conn:Disconnect()
                    retire()
                    return
                end
                local now = tick()
                local a = math.clamp((now - t0) / dur, 0, 1)
                local p = bez(startP, mid, endP, a)
                local d = (mid - startP) * (2 * (1 - a)) + (endP - mid) * (2 * a)
                if d.Magnitude < 1e-3 then d = endP - startP end
                local cf = CFrame.lookAt(p, p + d)
                local n = math.clamp(0.5 + 0.27 * math.sin(now * 41 + ph)
                    + 0.17 * math.sin(now * 67.3 + ph * 2.1)
                    + 0.09 * math.sin(now * 103.7 + ph * 0.7), 0, 1)
                local burn = 1
                if flare and a > flareAt then
                    local u = (a - flareAt) / (1 - flareAt)
                    burn = math.clamp((1 + 1.7 * math.exp(-((u - 0.14) ^ 2) / 0.011))
                        * (1 - u) ^ 1.5, 0, 3)
                end
                if endT then burn = burn * math.clamp(1 - (now - endT) / 0.4, 0, 1) end
                local bw = math.clamp(burn, 0, 1)
                if not endT then
                    root.CFrame = cf
                    for _, g in glows do
                        g.p.CFrame = cf * CFrame.new(0, 0, g.z)
                    end
                    local tum = CFrame.Angles(now * spinX, now * spinY, now * spinZ)
                    for _, c in chunks do
                        if c.tumble then
                            c.p.CFrame = cf * tum * c.off
                        else
                            c.p.CFrame = cf * c.off
                        end
                    end
                end
                for _, g in glows do
                    g.e.Brightness = (g.b0 + g.b1 * n) * burn
                end
                for i = 1, 4 do
                    local c = chunks[MET_ABL0 + i - 1]
                    c.p.Transparency = math.clamp(1 - (1 - (MET_ABLA[i] + MET_ABLK[i] * (1 - n))) * bw, 0, 1)
                end
                if noseLight then
                    noseLight.Brightness = (7 + 9 * n) * bw
                    bodyLight.Brightness = (2 + 3 * n) * bw
                end
                train.Rate = trainRate * bw
                scar.Rate = scarRate * bw
                if sparks then sparks.Rate = 60 * bw * (0.6 + 0.8 * n) end
                local pinch = (0.5 + 0.5 * bw) * (0.9 + 0.2 * n)
                for _, L in ribbons do
                    local h = L.sep * 0.5 * pinch
                    L.a.Position = Vec(0, h, 0)
                    L.b.Position = Vec(0, -h, 0)
                end
                if splitAt and a >= splitAt then
                    splitAt = nil
                    if sparks then sparks:Emit(30) end
                    for _ = 1, math.random(2, 3) do
                        launch(false, {
                            ang = ang,
                            noSplit = true,
                            scaleMul = 0.40 + math.random() * 0.14,
                            start = p + Vec((math.random() - 0.5) * 30, (math.random() - 0.5) * 20,
                                (math.random() - 0.5) * 30),
                            land = endP + Vec((math.random() - 0.5) * 110, 0, (math.random() - 0.5) * 110),
                        })
                    end
                end
                if (not far) and a > shedAt then
                    shedAt = 2
                    local fp = metPart(0.3 * rs, 0.24 * rs, 0.38 * rs, CFrame.new(p))
                    fp.Material = Enum.Material.Slate
                    fp.Color = Color3.fromRGB(40, 35, 33)
                    metRibbon(fp, 6, Color3.fromRGB(255, 220, 160), Color3.fromRGB(150, 34, 12),
                        0.12, 0.2, 0.8, 1, 0)
                    local fdir = (d.Unit * 0.65
                        + Vec(math.random() - 0.5, -0.5, math.random() - 0.5).Unit * 0.5).Unit
                    local fv, ft0 = fdir * spd * 0.6, tick()
                    local fc
                    fc = RunService.Heartbeat:Connect(function()
                        if not fp.Parent then
                            fc:Disconnect()
                            return
                        end
                        local age = tick() - ft0
                        if age > 2.4 then
                            fc:Disconnect()
                            fp:Destroy()
                            return
                        end
                        fv = fv + Vec(0, -0.88, 0)
                        fp.CFrame = CFrame.new(fp.Position + fv * 0.016)
                            * CFrame.Angles(age * 5, age * 3, age * 4)
                    end)
                end
                if not endT then
                    if a >= 1 then
                        endT = now
                        if doImpact then
                            metImpact(endP, rs * 0.215 + 0.6)
                            local tid = cfg("WeatherThunderId", "")
                            if tid ~= "" then
                                task.delay(0.15, function()
                                    oneShot(tid, cfg("WeatherSoundVolume", 0.35) * 6)
                                end)
                            end
                        end
                    elseif flare and burn < 0.02 and a > flareAt then
                        endT = now
                    end
                elseif now - endT >= 0.4 then
                    retire()
                    conn:Disconnect()
                    train.Enabled = false; scar.Enabled = false
                    if sparks then sparks.Enabled = false end
                    for _, g in glows do
                        g.e.Enabled = false
                        g.p:Destroy()
                    end
                    for _, L in ribbons do L.t.Enabled = false end
                    for _, c in chunks do c.p:Destroy() end
                    if noseLight then noseLight:Destroy(); bodyLight:Destroy() end
                    Debris:AddItem(root, 42)
                end
            end)
            Debris:AddItem(root, dur + 46)
        end
        function spawnMeteor(far, opts)
            if not Config.Weather or not cfg("WeatherMeteors", false) then
                return
            end
            local r = evRate("WeatherMeteorRate")
            local capped
            if far then
                capped = _metFar >= math.clamp(math.floor(1 + 1.5 * r), 1, 4)
            elseif r >= 2.5 then
                capped = _metNear >= 3
            elseif r >= 1.5 then
                capped = _metNear >= 2
            else
                capped = _metNear >= 1
            end
            if capped then
                return
            end
            launch(far, opts)
        end
        startMeteors = function()
            if _metConn then
                return
            end
            local t = tick()
            _metNextFar = t + 1 + math.random() * 2
            _metNextNear = t + 5 + math.random() * 6
            _metConn = RunService.Heartbeat:Connect(function()
                if not Config.Weather or not cfg("WeatherMeteors", false) then
                    return
                end
                local now = tick()
                local r = evRate("WeatherMeteorRate")
                if now >= _metNextFar then
                    _metNextFar = now + (6 + math.random() * 5) / r
                    pcall(spawnMeteor, true)
                end
                if now >= _metNextNear then
                    _metNextNear = now + (14 + math.random() * 10) / r
                    pcall(spawnMeteor, false)
                end
            end)
        end
        rescheduleMeteors = function()
            if not _metConn then
                return
            end
            local now, r = tick(), evRate("WeatherMeteorRate")
            _metNextFar = math.min(_metNextFar, now + 11 / r)
            _metNextNear = math.min(_metNextNear, now + 24 / r)
        end
        stopMeteors = function()
            if _metConn then _metConn:Disconnect(); _metConn = nil end
            for _, rec in _metLive do
                pcall(function() rec.root:Destroy() end)
            end
            table.clear(_metLive)
        end
        registerSpectacle("MeteorBigOne", 1, function()
            if not Config.Weather or not cfg("WeatherMeteors", false) then
                return
            end
            launch(false, { big = true })
        end)
    end)()
    local startStars, stopStars, rescheduleStars
    ;(function()
        local TX_SGLOW = "rbxassetid://78582616787441"
        local TX_STAR4 = "rbxassetid://17726943419"
        local GLINT_C  = Color3.fromRGB(246, 250, 255)
        local MIN_SIN  = 0.3
        local FLOOR_H  = 60
        local PAL = {
            { WHITE, Color3.fromRGB(222, 234, 255), Color3.fromRGB(150, 184, 240) },
            { Color3.fromRGB(242, 250, 255), Color3.fromRGB(160, 206, 255), Color3.fromRGB(78, 138, 255) },
            { Color3.fromRGB(255, 246, 220), Color3.fromRGB(255, 205, 122), Color3.fromRGB(222, 140, 44) },
        }
        local CLS = {
            { 80, 55, 250, 105, 50, 28, 3.6 },
            { 145, 90, 158, 62, 76, 44, 5.4 },
            { 240, 150, 98, 46, 118, 62, 7.2 },
        }
        local TR_TRANSP  = NumberSequence.new({ NSK(0, 0.04), NSK(0.12, 0.12), NSK(0.45, 0.55), NSK(1, 1) })
        local TR_WIDTH   = NumberSequence.new({ NSK(0, 0.4), NSK(0.08, 1), NSK(1, 0.02) })
        local ION_TRANSP = NumberSequence.new({ NSK(0, 0.86), NSK(0.3, 0.9), NSK(1, 1) })
        local ION_WIDTH  = NumberSequence.new({ NSK(0, 0.5), NSK(0.25, 1), NSK(1, 0.35) })
        local HEAD_TR    = NumberSequence.new({ NSK(0, 1), NSK(0.05, 0), NSK(0.72, 0.06), NSK(1, 1) })
        local HALO_TR    = NumberSequence.new({ NSK(0, 1), NSK(0.07, 0.82), NSK(0.7, 0.88), NSK(1, 1) })
        local GLINT_TR   = NumberSequence.new({ NSK(0, 1), NSK(0.3, 0.12), NSK(0.55, 0.42), NSK(1, 1) })
        local _starConn, _starNextT = nil, 0
        local _starLive = {}
        function mkSprite(parent, tex, col, sizeSeq, transpSeq, life, emit)
            local e = Instance.new("ParticleEmitter")
            e.Texture = tex
            e.Color = ColorSequence.new(col)
            e.Size = sizeSeq
            e.Transparency = transpSeq
            e.Lifetime = NumberRange.new(life)
            e.Rate = 0
            e.Speed = NumberRange.new(0, 0)
            e.SpreadAngle = Vector2.new(0, 0)
            e.LightEmission = emit
            e.LightInfluence = 0
            e.Drag = 0
            e.Parent = parent
            return e
        end
        function spawnStreak(start, dir, ci, pi, floorY)
            if not Config.Weather or not cfg("WeatherShootingStars", false) then
                return
            end
            if #_starLive >= math.clamp(math.floor(4 + 2 * evRate("WeatherStarRate")), 4, 8) then
                return
            end
            local cls, pal = CLS[ci], PAL[pi]
            local dist = cls[1] + math.random() * cls[2]
            local spd  = cls[3] + math.random() * cls[4]
            local tail = cls[5] + math.random() * cls[6]
            if start.Y + dir.Y * dist < floorY then
                local ny = (floorY - start.Y) / dist
                local hl = math.sqrt(dir.X * dir.X + dir.Z * dir.Z)
                if hl > 1e-4 then
                    local k = math.sqrt(math.max(0, 1 - ny * ny)) / hl
                    dir = Vec(dir.X * k, ny, dir.Z * k)
                end
            end
            local dur  = dist / spd
            local life = math.min(tail / spd, dur * 0.9)
            local sep  = cls[7] * (0.85 + math.random() * 0.3)
            local glintD = 0.3 + math.random() * 0.3
            local cf0 = CFrame.lookAt(start, start + dir)
            local host = mkBoltPart(WHITE, 1, Vec(0.2, 0.2, 0.2), cf0, getLightFolder())
            local aT = Instance.new("Attachment"); aT.Position = Vec(0, sep * 0.5, 0); aT.Parent = host
            local aB = Instance.new("Attachment"); aB.Position = Vec(0, -sep * 0.5, 0); aB.Parent = host
            local tr = Instance.new("Trail")
            tr.Attachment0 = aT; tr.Attachment1 = aB
            tr.FaceCamera = true
            tr.Texture = TX_SGLOW; tr.TextureMode = Enum.TextureMode.Stretch; tr.TextureLength = 1
            tr.Color = ColorSequence.new({ CSK(0, pal[1]), CSK(0.24, pal[2]), CSK(1, pal[3]) })
            tr.Transparency = TR_TRANSP; tr.WidthScale = TR_WIDTH
            tr.Lifetime = life; tr.LightEmission = 1; tr.LightInfluence = 0
            tr.MinLength = 0.08; tr.Enabled = false
            tr.Parent = host
            local ion = nil
            if ci == 3 then
                ion = Instance.new("Trail")
                ion.Attachment0 = aT; ion.Attachment1 = aB
                ion.FaceCamera = true
                ion.Texture = TX_SGLOW; ion.TextureMode = Enum.TextureMode.Stretch; ion.TextureLength = 1
                ion.Color = ColorSequence.new({ CSK(0, pal[2]), CSK(1, pal[3]) })
                ion.Transparency = ION_TRANSP; ion.WidthScale = ION_WIDTH
                ion.Lifetime = life * 2.6; ion.LightEmission = 0.85; ion.LightInfluence = 0
                ion.MinLength = 0.1; ion.Enabled = false
                ion.Parent = host
            end
            local hub = Instance.new("Attachment"); hub.Parent = host
            local coreS = sep * 0.62
            local core = mkSprite(hub, TX_SGLOW, pal[1], NumberSequence.new({
                NSK(0, coreS * 0.55), NSK(0.1, coreS), NSK(1, coreS * 0.3) }), HEAD_TR, dur, 1)
            core.LockedToPart = true
            local haloS = sep * 1.7
            local halo = mkSprite(hub, TX_SGLOW, pal[2], NumberSequence.new({
                NSK(0, haloS * 0.5), NSK(0.12, haloS), NSK(1, haloS * 0.35) }), HALO_TR, dur, 1)
            halo.LockedToPart = true
            local gs = sep * 1.9
            local gl = mkSprite(hub, TX_STAR4, GLINT_C, NumberSequence.new({
                NSK(0, gs * 0.1), NSK(0.32, gs), NSK(1, gs * 0.14) }), GLINT_TR, glintD * 1.2, 0.55)
            gl.Rotation = NumberRange.new(0, 90)
            gl.RotSpeed = NumberRange.new(-16, 16)
            gl:Emit(1)
            table.insert(_starLive, {
                host = host, tr = tr, ion = ion, core = core, halo = halo, aT = aT, aB = aB,
                cf0 = cf0, dir = dir, dist = dist, dur = dur, sep = sep,
                t0 = tick() + glintD, started = false,
            })
            Debris:AddItem(host, glintD + dur + life * 2.8 + 0.6)
        end
        function pickPal()
            local r = math.random()
            if r < 0.55 then
                return 1
            end
            if r < 0.92 then
                return 2
            end
            return 3
        end
        function pickCls(pi)
            if pi == 3 then
                if math.random() < 0.6 then
                    return 3
                end
                return 2
            end
            local r = math.random()
            if r < 0.25 then
                return 1
            end
            if r < 0.7 then
                return 2
            end
            return 3
        end
        function viewAz(cam)
            local lv = cam.CFrame.LookVector
            local az = math.atan2(lv.Z, lv.X)
            if math.random() < 0.35 then
                return math.random() * 6.283
            end
            return az
        end
        function spawnSingle()
            local cam = Camera
            if not cam then
                return
            end
            local base = cam.CFrame.Position
            local az = viewAz(cam) + (math.random() - 0.5) * 1.5
            local el = math.rad(24 + math.random() * 30)
            local r  = 190 + math.random() * 130
            local ce = math.cos(el)
            local start = base + Vec(ce * math.cos(az) * r, math.sin(el) * r, ce * math.sin(az) * r)
            local hd = az + 1.5708 + (math.random() - 0.5) * 2.2
            local pi = pickPal()
            spawnStreak(start, Vec(math.cos(hd), -(0.05 + math.random() * 0.34), math.sin(hd)).Unit,
                pickCls(pi), pi, base.Y + FLOOR_H)
        end
        function spawnShower()
            local cam = Camera
            if not cam then
                return
            end
            local base = cam.CFrame.Position
            local floorY = base.Y + FLOOR_H
            local raz = viewAz(cam) + (math.random() - 0.5) * 0.9
            local rel = math.rad(36 + math.random() * 16)
            local cr = math.cos(rel)
            local rv = Vec(cr * math.cos(raz), math.sin(rel), cr * math.sin(raz))
            local dn = (Vec(0, -1, 0) + rv * rv.Y).Unit
            local sd = rv:Cross(dn).Unit
            local pi = pickPal()
            local t = 0
            for _ = 1, 3 + math.random(0, 2) do
                t = t + 0.16 + math.random() * 0.42
                task.delay(t, function()
                    if not Config.Weather or not cfg("WeatherShootingStars", false) then
                        return
                    end
                    local phi = (math.random() - 0.5) * 2.8
                    local off = dn * math.cos(phi) + sd * math.sin(phi)
                    local th = math.rad(9 + math.random() * 24)
                    local ct, st = math.cos(th), math.sin(th)
                    local u = (rv * ct + off * st).Unit
                    if u.Y < MIN_SIN then
                        off = -off
                        u = (rv * ct + off * st).Unit
                    end
                    if u.Y < MIN_SIN then
                        return
                    end
                    local ci = 2
                    if th < 0.22 then
                        ci = 1
                    elseif th > 0.44 then
                        ci = 3
                    end
                    pcall(spawnStreak, base + u * (215 + math.random() * 75),
                        (off * ct - rv * st).Unit, ci, pi, floorY)
                end)
            end
        end
        function stepStars(now)
            for i = #_starLive, 1, -1 do
                local s = _starLive[i]
                if not s.host.Parent then
                    table.remove(_starLive, i)
                else
                    local a = (now - s.t0) / s.dur
                    if a >= 1 then
                        s.tr.Enabled = false
                        if s.ion then
                            s.ion.Enabled = false
                        end
                        table.remove(_starLive, i)
                    elseif a >= 0 then
                        if not s.started then
                            s.started = true
                            s.tr.Enabled = true
                            s.core:Emit(1)
                            s.halo:Emit(1)
                            if s.ion then
                                s.ion.Enabled = true
                            end
                        end
                        s.host.CFrame = s.cf0 + s.dir * (s.dist * a)
                        if a > 0.7 then
                            local h = s.sep * 0.5 * (1 - (a - 0.7) / 0.3)
                            s.aT.Position = Vec(0, h, 0)
                            s.aB.Position = Vec(0, -h, 0)
                        end
                    end
                end
            end
        end
        startStars = function()
            if _starConn then
                return
            end
            _starNextT = tick() + 2 + math.random() * 4
            _starConn = RunService.Heartbeat:Connect(function()
                if not Config.Weather or not cfg("WeatherShootingStars", false) then
                    return
                end
                local now = tick()
                if now >= _starNextT then
                    local r = evRate("WeatherStarRate")
                    _starNextT = now + (5 + math.random() * 6) / r
                    if math.random() < math.min(0.06 * r, 0.35) then
                        pcall(spawnShower)
                    else
                        pcall(spawnSingle)
                        if math.random() < math.min(0.22 * r, 0.6) then
                            task.delay(0.3 + math.random() * 0.5, function()
                                pcall(spawnSingle)
                            end)
                        end
                    end
                end
                pcall(stepStars, now)
            end)
        end
        rescheduleStars = function()
            if not _starConn then
                return
            end
            _starNextT = math.min(_starNextT, tick() + 11 / evRate("WeatherStarRate"))
        end
        stopStars = function()
            if _starConn then
                _starConn:Disconnect()
                _starConn = nil
            end
            for _, s in _starLive do
                pcall(function() s.host:Destroy() end)
            end
            table.clear(_starLive)
        end
        registerSpectacle("StarShower", 1, function()
            if not cfg("WeatherShootingStars", false) then
                return
            end
            spawnShower()
        end)
    end)()
    local startFireflies, stopFireflies, refreshFireflies
    ;(function()
        local FF_N     = 7
        local FF_BODY  = Color3.fromRGB(215, 255, 120)
        local FF_LIGHT = Color3.fromRGB(244, 232, 120)
        local FF_DOWN  = Vec(0, -80, 0)
        local WANDER   = 28
        local FF_STEP  = 2
        local FF_SEG   = 1.2
        local FF_TRC = ColorSequence.new({ CSK(0, Color3.fromRGB(198, 255, 128)),
            CSK(0.45, Color3.fromRGB(216, 238, 108)), CSK(1, Color3.fromRGB(255, 196, 86)) })
        local FF_TRT = NumberSequence.new({ NSK(0, 0.36), NSK(0.35, 0.66), NSK(1, 1) })
        local FF_TRW = NumberSequence.new({ NSK(0, 0.8), NSK(0.3, 1), NSK(1, 0) })
        local _ff = { list = nil, conn = nil, folder = nil, burst = nil, burstHost = nil, n = 4 }
        local _swarm = { active = false, t0 = 0, cx = 0, cz = 0, y = 0 }
        local _ffRp = RaycastParams.new()
        _ffRp.FilterType = Enum.RaycastFilterType.Exclude
        function groundY(camPos, x, z)
            local ch = lp and lp.Character
            if ch then
                _ffRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _ffRp.FilterDescendantsInstances = { getFolder() }
            end
            local hit = Workspace:Raycast(Vec(x, camPos.Y + 6, z), FF_DOWN, _ffRp)
            if hit then
                return hit.Position.Y
            end
            return camPos.Y - 7
        end
        function pickWaypoint(H, camPos)
            local x = camPos.X + (math.random() - 0.5) * WANDER
            local z = camPos.Z + (math.random() - 0.5) * WANDER
            H.a = H.pos
            H.bpt = Vec(x, groundY(camPos, x, z) + 0.5 + math.random() * 3, z)
            H.dur = math.clamp((H.bpt - H.a).Magnitude / 2.2, 1.5, 6)
            H.t = 0
        end
        function stepToward(cur, target, maxStep)
            local d = target - cur
            local m = d.Magnitude
            if m <= maxStep or m < 1e-4 then
                return target
            end
            return cur + d * (maxStep / m)
        end
        function trailOff(H)
            H.calm = 0
            if H.trail.Enabled then
                H.trail.Enabled = false
                H.trail:Clear()
            end
        end
        function buildFlies()
            local folder = Instance.new("Folder")
            folder.Name = "_wxFlies"; folder:SetAttribute("WX_Custom", true)
            folder.Parent = getFolder()
            _ff.folder = folder
            _ff.list = {}
            local cam = Camera
            local camPos
            if cam then camPos = cam.CFrame.Position else camPos = Vec(0, 0, 0) end
            for i = 1, FF_N do
                local b = mkBoltPart(FF_BODY, 0, Vec(0.25, 0.25, 0.25), CFrame.new(camPos), folder)
                b.Shape = Enum.PartType.Ball
                local light = Instance.new("PointLight")
                light.Color = FF_LIGHT; light.Range = 8; light.Brightness = 2.5
                light.Parent = b
                local halo = Instance.new("ParticleEmitter")
                halo:SetAttribute("WX_Custom", true)
                halo.Texture = TX_MGLOW
                halo.Color = ColorSequence.new(FF_BODY)
                halo.LightEmission = 1; halo.LightInfluence = 0
                halo.Size = NumberSequence.new(1.1, 1.5)
                halo.Transparency = NumberSequence.new({ NSK(0, 0.75), NSK(1, 1) })
                halo.Rate = 12; halo.Lifetime = NumberRange.new(0.25, 0.4)
                halo.Speed = NumberRange.new(0, 0)
                halo.LockedToPart = true
                halo.Parent = b
                local a0 = Instance.new("Attachment")
                a0.Position = Vec(0, 0.6, 0); a0.Parent = b
                local a1 = Instance.new("Attachment")
                a1.Position = Vec(0, -0.6, 0); a1.Parent = b
                local tr = Instance.new("Trail")
                tr:SetAttribute("WX_Custom", true)
                tr.Attachment0 = a0; tr.Attachment1 = a1
                tr.Texture = TX_MGLOW; tr.TextureMode = Enum.TextureMode.Stretch
                tr.Color = FF_TRC; tr.Transparency = FF_TRT; tr.WidthScale = FF_TRW
                tr.Lifetime = 0.65
                tr.LightEmission = 1; tr.LightInfluence = 0
                tr.FaceCamera = true
                tr.MinLength = 0.25; tr.MaxLength = 14
                tr.Enabled = false
                tr.Parent = b
                local H = { part = b, light = light, trail = tr, halo = halo, bm = 1,
                            calm = 0, jump = true,
                            pos = camPos, a = camPos, bpt = camPos, t = 0, dur = 1,
                            ph = math.random() * 6.283, spin = 1.7 + i * 0.25,
                            blinkT = math.random() * 3, period = 2.4 + math.random() * 1.4 }
                pickWaypoint(H, camPos)
                H.pos = H.bpt
                pickWaypoint(H, camPos)
                b.CFrame = CFrame.new(H.pos)
                _ff.list[i] = H
            end
            local bh = mkBoltPart(FF_BODY, 1, Vec(1.5, 1.5, 1.5), CFrame.new(camPos), folder)
            local be = Instance.new("ParticleEmitter")
            be:SetAttribute("WX_Custom", true)
            be.Texture = TX_MGLOW
            be.Color = ColorSequence.new(Color3.fromRGB(220, 255, 130), Color3.fromRGB(255, 200, 80))
            be.LightEmission = 0.95; be.LightInfluence = 0.05
            be.Size = NumberSequence.new({ NSK(0, 0.1), NSK(0.08, 0.62, 0.15), NSK(0.45, 0.5, 0.1), NSK(1, 0.08) })
            be.Transparency = NumberSequence.new({ NSK(0, 1), NSK(0.08, 0.08), NSK(0.4, 0.45), NSK(0.75, 0.85), NSK(1, 1) })
            be.Rate = 0; be.Lifetime = NumberRange.new(1.6, 2.8)
            be.Speed = NumberRange.new(0.8, 2.2); be.SpreadAngle = Vector2.new(180, 180)
            be.Drag = 2.5; be.EmissionDirection = Enum.NormalId.Top
            be.Parent = bh
            _ff.burst = be; _ff.burstHost = bh
        end
        refreshFireflies = function()
            local list = _ff.list
            if not list then
                return
            end
            local I = iAmt()
            _ff.n = math.clamp(math.floor(1.5 + 3 * I), 1, FF_N)
            local rm, bm = 0.8 + 0.2 * I, 0.7 + 0.3 * I
            for i = 1, FF_N do
                local H = list[i]
                local on = i <= _ff.n
                H.bm = bm
                H.light.Range = 8 * rm
                H.halo.Enabled = on
                if not on then
                    H.light.Brightness = 0
                    H.part.Transparency = 1
                    H.jump = true
                    trailOff(H)
                end
            end
        end
        startFireflies = function()
            if _ff.conn then return end
            buildFlies()
            refreshFireflies()
            local accum = 0
            _ff.conn = RunService.Heartbeat:Connect(function(dt)
                if not Config.Weather then return end
                accum = accum + dt
                if accum < 0.05 then return end
                local step = accum; accum = 0
                local cam = Camera; if not cam then return end
                local camPos = cam.CFrame.Position
                local now = tick()
                local sw = -1
                if _swarm.active then
                    sw = now - _swarm.t0
                    if sw > 9 then _swarm.active = false; sw = -1 end
                end
                local list = _ff.list
                for i = 1, _ff.n do
                    local H = list[i]
                    local prev = H.pos
                    local newPos
                    if sw >= 0 then
                        local ang = H.ph + now * H.spin
                        local r
                        if sw < 2.5 then r = 10 - 7.4 * (sw / 2.5)
                        elseif sw < 6.5 then r = 2.6
                        else r = 2.6 + (sw - 6.5) * 6 end
                        local target = Vec(_swarm.cx + math.cos(ang) * r,
                            _swarm.y + 0.55 * math.sin(now * 1.3 + H.ph * 2),
                            _swarm.cz + math.sin(ang) * r)
                        newPos = stepToward(prev, prev:Lerp(target, math.min(step * 3, 1)), FF_STEP)
                        H.bpt = newPos; H.t = 1; H.dur = 1
                    else
                        H.t = H.t + step
                        local relX, relZ = prev.X - camPos.X, prev.Z - camPos.Z
                        if H.t >= H.dur or (relX * relX + relZ * relZ) > 3600 then
                            pickWaypoint(H, camPos)
                        end
                        local u = H.t / H.dur
                        u = u * u * (3 - 2 * u)
                        newPos = stepToward(prev, H.a:Lerp(H.bpt, u), FF_STEP)
                    end
                    H.pos = newPos
                    if H.jump or (sw >= 0 and (sw < 2.5 or sw >= 6.4))
                        or (newPos - prev).Magnitude > FF_SEG then
                        H.jump = false
                        trailOff(H)
                    else
                        H.calm = H.calm + step
                        if H.calm >= 0.25 and not H.trail.Enabled then
                            H.trail:Clear()
                            H.trail.Enabled = true
                        end
                    end
                    H.part.CFrame = CFrame.new(H.pos.X, H.pos.Y + 0.3 * math.sin(now * 1.7 + H.ph), H.pos.Z)
                    local pulse = math.exp(-((now + H.blinkT) % H.period) * 1.4)
                    H.light.Brightness = (0.5 + 2.6 * pulse) * H.bm
                    H.part.Transparency = 0.4 * (1 - pulse)
                end
            end)
        end
        stopFireflies = function()
            if _ff.conn then _ff.conn:Disconnect(); _ff.conn = nil end
            if _ff.folder then pcall(function() _ff.folder:Destroy() end); _ff.folder = nil end
            _ff.list = nil; _ff.burst = nil; _ff.burstHost = nil
            _swarm.active = false
        end
        registerSpectacle("FireflySwarm", 1, function()
            if not Config.Weather or _curType ~= "Fireflies" or not _ff.list then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local ang = math.random() * 6.283
            local d = 8 + math.random() * 8
            local cx = camPos.X + math.cos(ang) * d
            local cz = camPos.Z + math.sin(ang) * d
            _swarm.cx = cx; _swarm.cz = cz
            _swarm.y = groundY(camPos, cx, cz) + 2.2
            _swarm.t0 = tick(); _swarm.active = true
            _ff.burstHost.CFrame = CFrame.new(cx, _swarm.y, cz)
            for _, H in _ff.list do
                trailOff(H)
            end
            local em = math.max(1, math.floor(7 * iRate(iAmt(), IR.Fireflies.lo, IR.Fireflies.hi) + 0.5))
            for n = 0, 5 do
                task.delay(1.6 + n * 0.7, function()
                    if _swarm.active and _ff.burst then _ff.burst:Emit(em) end
                end)
            end
        end)
    end)()
    local stopLeafDevil
    ;(function()
        local RING_N   = 11
        local DEV_H    = 25
        local DEV_R    = 9.5
        local DEV_LIFE = 14
        local DEV_HOLD = 9.6
        local DEV_DOWN = Vec(0, -80, 0)
        local RELEASE  = Vec(-8, -3.5, 3)
        local RING_TEX  = { TX_LEAFA, TX_LEAFB, TX_LEAFA, TX_LEAFB, TX_LEAFC }
        local RING_GLOW = { 0.62, 0.07, 0.6, 0.08, 0.1 }
        local RING_COL  = {
            ColorSequence.new({ CSK(0, Color3.fromRGB(226,190,128)), CSK(0.45, Color3.fromRGB(255,246,200)),
                                CSK(1, Color3.fromRGB(190,132,62)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(160,80,52)), CSK(1, Color3.fromRGB(104,44,30)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(230,222,176)), CSK(0.5, Color3.fromRGB(255,254,228)),
                                CSK(1, Color3.fromRGB(200,180,122)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(156,74,255)), CSK(1, Color3.fromRGB(106,46,200)) }),
            ColorSequence.new({ CSK(0, Color3.fromRGB(196,156,112)), CSK(1, Color3.fromRGB(146,110,74)) }),
        }
        local RING_SIZE = NumberSequence.new({ NSK(0, 0.56, 0.14), NSK(1, 0.46, 0.1) })
        local RING_TR   = NumberSequence.new({ NSK(0, 1), NSK(0.07, 0.05), NSK(0.78, 0.4), NSK(1, 1) })
        local RING_SQ   = NumberSequence.new({ NSK(0, -0.6), NSK(0.25, 0.16), NSK(0.5, -0.6),
                                               NSK(0.75, 0.16), NSK(1, -0.6) })
        local SKIRT_SIZE = NumberSequence.new({ NSK(0, 1.5), NSK(1, 4.4) })
        local SKIRT_TR   = NumberSequence.new({ NSK(0, 1), NSK(0.22, 0.82), NSK(0.75, 0.92), NSK(1, 1) })
        local LEAF_SIZE  = NumberSequence.new({ NSK(0, 0.52, 0.12), NSK(1, 0.44, 0.1) })
        local LEAF_TR    = NumberSequence.new({ NSK(0, 1), NSK(0.1, 0.08), NSK(0.75, 0.42), NSK(1, 1) })
        local DUCK_TI = TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        local BACK_TI = TweenInfo.new(2.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local _dev = { folder = nil, conn = nil }
        local _devRp = RaycastParams.new()
        _devRp.FilterType = Enum.RaycastFilterType.Exclude
        function ambientRate(mul, ti)
            local I = iAmt()
            for _, L in _partLayers do
                if L.emitter and L.tag == nil then
                    if L.rateTween then L.rateTween:Cancel() end
                    L.rateMul = mul
                    local tw = TweenService:Create(L.emitter, ti, { Rate = layerRate(L, I) * mul })
                    L.rateTween = tw
                    tw:Play()
                end
            end
        end
        stopLeafDevil = function()
            if _dev.conn then _dev.conn:Disconnect(); _dev.conn = nil end
            if _dev.folder then pcall(function() _dev.folder:Destroy() end); _dev.folder = nil end
            if _dev.rings then
                _dev.rings = nil
                ambientRate(1, BACK_TI)
            end
        end
        function mkRing(folder, cf, i, r)
            local p = mkBoltPart(WHITE, 1, Vec(0.3, 0.3, 0.3), cf, folder)
            local k = ((i - 1) % 5) + 1
            local glow = RING_GLOW[k]
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = RING_TEX[k]
            e.Color = RING_COL[k]
            e.LightEmission = glow; e.LightInfluence = 1 - glow
            e.Size = RING_SIZE; e.Transparency = RING_TR; e.Squash = RING_SQ
            e.Rate = 0
            e.Lifetime = NumberRange.new(2, 3)
            e.Speed = NumberRange.new(5, 9)
            e.SpreadAngle = Vector2.new(8, 8)
            e.Rotation = NumberRange.new(-180, 180)
            e.RotSpeed = NumberRange.new(-300, 300)
            e.Acceleration = Vec(0, 2.6, 0)
            e.Drag = 1.4
            e.EmissionDirection = ND.Front
            e.Parent = p
            return { part = p, e = e, r = r }
        end
        registerSpectacle("LeafDevil", 1, function()
            if not Config.Weather or _curType ~= "Autumn" or _dev.conn then return end
            local cam = Camera; if not cam then return end
            local camPos = cam.CFrame.Position
            local bearing = math.random() * 6.283
            local dist = 18 + math.random() * 12
            local cx = camPos.X + math.cos(bearing) * dist
            local cz = camPos.Z + math.sin(bearing) * dist
            local ch = lp and lp.Character
            if ch then
                _devRp.FilterDescendantsInstances = { getFolder(), ch }
            else
                _devRp.FilterDescendantsInstances = { getFolder() }
            end
            local hit = Workspace:Raycast(Vec(cx, camPos.Y + 6, cz), DEV_DOWN, _devRp)
            local gy = camPos.Y - 4.6
            if hit then gy = hit.Position.Y end
            local folder = Instance.new("Folder")
            folder.Name = "_wxDevil"; folder:SetAttribute("WX_Custom", true)
            folder.Parent = getFolder()
            _dev.folder = folder
            local em = iRate(iAmt(), IR.Autumn.lo, IR.Autumn.hi)
            local seed = CFrame.new(cx, gy + 1, cz)
            local rings = table.create(RING_N)
            for i = 1, RING_N do
                local h = 0.8 + (i - 1) * (DEV_H - 0.8) / (RING_N - 1)
                local u = h / DEV_H
                local r = DEV_R * (0.15 + 0.85 * u ^ 0.9)
                if u > 0.72 then r = r * (1 + (u - 0.72) * 1.5) end
                local R = mkRing(folder, seed, i, r)
                R.h = h
                R.ph = (i - 1) * 0.62
                R.t0 = 0.12 * (i - 1)
                R.rate = (10 + 34 * (r / DEV_R)) * em
                rings[i] = R
            end
            _dev.rings = rings
            local foot = mkBoltPart(WHITE, 1, Vec(6.5, 0.4, 6.5), CFrame.new(cx, gy + 0.35, cz), folder)
            local leafSkirt = Instance.new("ParticleEmitter")
            leafSkirt:SetAttribute("WX_Custom", true)
            leafSkirt.Texture = TX_LEAFA
            leafSkirt.Color = RING_COL[1]
            leafSkirt.LightEmission = 0.3; leafSkirt.LightInfluence = 0.7
            leafSkirt.Size = LEAF_SIZE; leafSkirt.Transparency = LEAF_TR; leafSkirt.Squash = RING_SQ
            leafSkirt.Rate = 0
            leafSkirt.Lifetime = NumberRange.new(1.2, 2.2)
            leafSkirt.Speed = NumberRange.new(2, 5)
            leafSkirt.SpreadAngle = Vector2.new(70, 70)
            leafSkirt.Rotation = NumberRange.new(-180, 180)
            leafSkirt.RotSpeed = NumberRange.new(-260, 260)
            leafSkirt.Acceleration = Vec(0, 1.2, 0)
            leafSkirt.Drag = 2.2
            leafSkirt.EmissionDirection = ND.Top
            leafSkirt.Parent = foot
            local dustSkirt = Instance.new("ParticleEmitter")
            dustSkirt:SetAttribute("WX_Custom", true)
            dustSkirt.Texture = TX_DUST
            dustSkirt.Color = ColorSequence.new(Color3.fromRGB(190,166,130), Color3.fromRGB(140,118,90))
            dustSkirt.LightEmission = 0.04; dustSkirt.LightInfluence = 0.96
            dustSkirt.Size = SKIRT_SIZE; dustSkirt.Transparency = SKIRT_TR
            dustSkirt.Rate = 0
            dustSkirt.Lifetime = NumberRange.new(0.9, 1.4)
            dustSkirt.Speed = NumberRange.new(1, 2.6)
            dustSkirt.SpreadAngle = Vector2.new(85, 85)
            dustSkirt.RotSpeed = NumberRange.new(-25, 25)
            dustSkirt.Acceleration = Vec(0, 1, 0)
            dustSkirt.Drag = 2.4
            dustSkirt.EmissionDirection = ND.Top
            dustSkirt.Parent = foot
            local scuff = mkBoltPart(WHITE, 1, Vec(15, 0.08, 15), CFrame.new(cx, gy + 0.05, cz), folder)
            scuff.Material = Enum.Material.SmoothPlastic
            local sd = Instance.new("Decal")
            sd:SetAttribute("WX_Custom", true)
            sd.Face = ND.Top; sd.Texture = TX_DUST
            sd.Color3 = Color3.fromRGB(96, 74, 52); sd.Transparency = 0.55
            sd.Parent = scuff
            ambientRate(0.45, DUCK_TI)
            local t0 = tick()
            local ang, px, pz = 0, cx, cz
            local lean = math.random() * 6.283
            _dev.conn = RunService.Heartbeat:Connect(function(dt)
                if not folder.Parent then stopLeafDevil() return end
                local t = tick() - t0
                if t > DEV_LIFE then stopLeafDevil() return end
                ang = ang + dt * 2.7
                px = px + Wind.x * dt * 0.75
                pz = pz + Wind.z * dt * 0.75
                local lx = math.cos(lean + t * 0.21) * 0.13
                local lz = math.sin(lean + t * 0.17) * 0.13
                local climb = math.min(t / 1.5, 1)
                local release = t > DEV_HOLD
                for i = 1, RING_N do
                    local R = rings[i]
                    local h = R.h * climb
                    local th = ang + R.ph
                    local cs, sn = math.cos(th), math.sin(th)
                    local r = R.r * (0.55 + 0.45 * climb)
                    local p = Vec(px + lx * h + cs * r, gy + 0.35 + h, pz + lz * h + sn * r)
                    R.part.CFrame = CFrame.lookAt(p, p + Vec(-sn, 0.3, cs))
                    if release then
                        R.e.Rate = 0
                        R.e.Acceleration = RELEASE
                    else
                        R.e.Rate = R.rate * math.clamp((t - R.t0) / 0.6, 0, 1)
                    end
                end
                foot.CFrame = CFrame.new(px, gy + 0.35, pz)
                scuff.CFrame = CFrame.new(px, gy + 0.05, pz) * CFrame.Angles(0, t * 0.35, 0)
                if release then
                    leafSkirt.Rate = 0
                    dustSkirt.Rate = 0
                    leafSkirt.Acceleration = RELEASE
                    sd.Transparency = math.min(0.55 + (t - DEV_HOLD) * 0.35, 1)
                    if t > DEV_HOLD + 0.1 and _dev.rings then
                        _dev.rings = nil
                        ambientRate(1, BACK_TI)
                    end
                else
                    local k = math.min(t / 0.8, 1)
                    leafSkirt.Rate = 26 * em * k
                    dustSkirt.Rate = 15 * em * k
                    sd.Transparency = 0.95 - 0.4 * math.min(t / 1.2, 1)
                end
            end)
        end)
    end)()
    local puddlesRefresh, puddlesIntensity, stopPuddles
    ;(function()
        local TXP_RING = "rbxassetid://17738857765"
        local TXP_DROP = "rbxassetid://14964503448"
        local TXP_STAR = "rbxassetid://17726943419"
        local WATER_C  = Color3.fromRGB(22, 28, 37)
        local SHEEN_C  = Color3.fromRGB(150, 175, 205)
        local FOAM_C   = Color3.fromRGB(236, 246, 255)
        local PUD_DOWN = Vec(0, -90, 0)
        local FIT_DOWN = Vec(0, -4.2, 0)
        local HALF_PI  = 1.5707963
        local FIT_TOL  = 1.5
        local FIT_R    = 1.09
        local FIT_K    = { 1, 0.66, 0.44, 0.28 }
        local FIT_C = {
            1, 0, 0.70711, 0.70711, 0, 1, -0.70711, 0.70711,
            -1, 0, -0.70711, -0.70711, 0, -1, 0.70711, -0.70711,
        }
        local FIT_Q = {
            1, 1, 0.333, 1, -0.333, 1, -1, 1,
            -1, 0.333, -1, -0.333, -1, -1, -0.333, -1,
            0.333, -1, 1, -1, 1, -0.333, 1, 0.333,
        }
        local CELL     = 32
        local HALF     = 16
        local NOISE_F  = 0.018
        local POOL_F   = 0.74
        local TILE_K   = 1 / 470
        local K_CAP    = 48
        local MAX_REC  = 96
        local _pud = { folder = nil, conn = nil }
        local _plist = {}
        local _pmap = {}
        local _pfail = {}
        local _cd = { i = 0, j = 0, key = 0, kind = 0, cx = 0, cz = 0, gy = 0 }
        local _units, _uIdx = {}, 1
        local _prints, _pIdx = {}, 1
        local _pstates = {}
        local _abuf = {}
        local _prp = RaycastParams.new()
        _prp.FilterType = Enum.RaycastFilterType.Exclude
        local _pfilter = {}
        local _fieldToken, _rebuild = 0, false
        local _int, _thr, _placeR, _seed = 1, 0, 50, 0
        local _wTr, _wRf = 0.35, 0.16
        local _homeI, _homeJ = 1e9, 1e9
        function pudActive()
            if not Config.Weather or not cfg("WeatherPuddles", false) then
                return false
            end
            if _curType == "Rain" then
                return true
            end
            return cfg("WeatherStorm", false)
        end
        function pudIntensity()
            return iAmt()
        end
        function mkFlatPart(size, cf, parent)
            local p = Instance.new("Part")
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Transparency = 1
            p.Size = size; p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p.Parent = parent
            return p
        end
        function mkSlab(d1, d2, cf, parent, sheen)
            local p = Instance.new("Part")
            p.Shape = Enum.PartType.Cylinder
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Material = Enum.Material.SmoothPlastic
            if sheen then
                p.Color = SHEEN_C; p.Transparency = 0.74; p.Reflectance = 0.38
            else
                p.Color = WATER_C; p.Transparency = _wTr; p.Reflectance = _wRf
                p:SetAttribute("WX_W", true)
            end
            p.Size = Vec(0.05, d1, d2)
            p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p.Parent = parent
        end
        function mkTile(w, l, cf, parent)
            local p = Instance.new("Part")
            p.Anchored = true; p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
            p.CastShadow = false; p.Material = Enum.Material.SmoothPlastic
            p.Color = WATER_C; p.Transparency = _wTr; p.Reflectance = _wRf
            p.Size = Vec(w, 0.05, l)
            p.CFrame = cf
            p:SetAttribute("WX_Custom", true)
            p:SetAttribute("WX_W", true)
            p.Parent = parent
        end
        function fitSlab(cx, cz, d1, d2, yaw, gy)
            local cs, sn = math.cos(yaw), math.sin(yaw)
            for k = 1, 4 do
                local f = FIT_K[k] * FIT_R * 0.5
                local a, b = d1 * f, d2 * f
                local ok, gx, gz, n = true, 0, 0, 0
                for i = 1, 8 do
                    local ct, st = FIT_C[i * 2 - 1], FIT_C[i * 2]
                    local ox = sn * b * st - cs * a * ct
                    local oz = sn * a * ct + cs * b * st
                    local h = Workspace:Raycast(Vec(cx + ox, gy + 2, cz + oz), FIT_DOWN, _prp)
                    local sup = false
                    if h and h.Normal.Y >= 0.86 and h.Instance.CanCollide then
                        local dy = h.Position.Y - gy
                        sup = dy < FIT_TOL and dy > -FIT_TOL
                    end
                    if sup then
                        gx, gz, n = gx + ox, gz + oz, n + 1
                    else
                        ok = false
                    end
                end
                if ok then
                    return cx, cz, d1 * FIT_K[k], d2 * FIT_K[k]
                end
                if n == 0 then
                    return nil
                end
                cx, cz = cx + gx / n * 0.5, cz + gz / n * 0.5
            end
            return nil
        end
        function fitRect(cx, cz, w, l, gy)
            for k = 1, 4 do
                local f = FIT_K[k] * FIT_R * 0.5
                local a, b = w * f, l * f
                local ok = true
                for i = 1, 12 do
                    local h = Workspace:Raycast(
                        Vec(cx + FIT_Q[i * 2 - 1] * a, gy + 2, cz + FIT_Q[i * 2] * b), FIT_DOWN, _prp)
                    local sup = false
                    if h and h.Normal.Y >= 0.86 and h.Instance.CanCollide then
                        local dy = h.Position.Y - gy
                        sup = dy < FIT_TOL and dy > -FIT_TOL
                    end
                    if not sup then
                        ok = false
                        break
                    end
                end
                if ok then
                    return w * FIT_K[k], l * FIT_K[k]
                end
            end
            return nil
        end
        function mkHost(m, cf, size, k, I)
            local host = mkFlatPart(size, cf, m)
            local e = Instance.new("ParticleEmitter")
            e:SetAttribute("WX_Custom", true)
            e.Texture = TXP_RING
            e.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            e.EmissionDirection = Enum.NormalId.Top
            e.Speed = NumberRange.new(0.05, 0.05)
            e.Rate = (2.1 + 4.2 * I) * k
            e.Lifetime = NumberRange.new(1.1, 1.6)
            e.Size = NumberSequence.new({ NSK(0, 0.12), NSK(1, 4.4) })
            e.Transparency = NumberSequence.new({ NSK(0, 0.9), NSK(0.14, 0.12), NSK(0.62, 0.5), NSK(1, 1) })
            e.Color = ColorSequence.new(Color3.fromRGB(215, 234, 250))
            e.LightEmission = 0.45
            e.Parent = host
            local g = Instance.new("ParticleEmitter")
            g:SetAttribute("WX_Custom", true)
            g.Texture = TXP_STAR
            g.EmissionDirection = Enum.NormalId.Top
            g.Speed = NumberRange.new(0, 0)
            g.Rate = 0.8 * I * k
            g.Lifetime = NumberRange.new(0.16, 0.28)
            g.Size = NumberSequence.new({ NSK(0, 0.06), NSK(0.4, 0.3), NSK(1, 0.04) })
            g.Transparency = NumberSequence.new({ NSK(0, 0.6), NSK(1, 1) })
            g.Color = ColorSequence.new(Color3.fromRGB(240, 248, 255))
            g.LightEmission = 0.5
            g.Parent = host
            return e, g
        end
        function mkPuddle(cd, span, nslab, I)
            local x, z, gy = cd.cx, cd.cz, cd.gy
            local m = Instance.new("Model")
            m.Name = "_pud"
            local px = x + (math.random() - 0.5) * CELL * 0.16
            local pz = z + (math.random() - 0.5) * CELL * 0.16
            local spine = math.random() * 6.28318
            local sx, sz = math.cos(spine), math.sin(spine)
            local lx, lz = -sz, sx
            local yaw0 = math.pi - spine
            local slabs, rmax = {}, 0
            local s0, s1, l0, l1 = 1e9, -1e9, 1e9, -1e9
            function place(cx, cz, d1, d2, yaw, yoff, sheen)
                local fx, fz, fd1, fd2 = fitSlab(cx, cz, d1, d2, yaw, gy)
                if not fx then
                    return false
                end
                local rad = math.max(fd1, fd2) * 0.5
                local ex, ez = fx - x, fz - z
                if math.abs(ex) + rad > HALF or math.abs(ez) + rad > HALF then
                    return false
                end
                mkSlab(fd1, fd2, CFrame.new(fx, gy + yoff, fz)
                    * CFrame.Angles(0, yaw, 0) * CFrame.Angles(0, 0, HALF_PI), m, sheen)
                if not sheen then
                    slabs[#slabs + 1] = {
                        cx = fx, cz = fz,
                        cs = math.cos(yaw), sn = math.sin(yaw),
                        ia = 2 / fd1, ib = 2 / fd2, rect = false,
                    }
                    rmax = math.max(rmax, math.sqrt(ex * ex + ez * ez) + rad)
                end
                local dx, dz = fx - px, fz - pz
                local t, lat = dx * sx + dz * sz, dx * lx + dz * lz
                local ins = math.min(fd1, fd2) * 0.375
                s0, s1 = math.min(s0, t - ins), math.max(s1, t + ins)
                l0, l1 = math.min(l0, lat - ins), math.max(l1, lat + ins)
                return true
            end
            if not place(px, pz, span, span * 0.62, yaw0, 0.002, false) then
                m:Destroy()
                return false
            end
            for i = 1, nslab do
                local t = ((i - 0.5) / nslab - 0.5) * span * 0.62 + (math.random() - 0.5) * span * 0.14
                local lat = (math.random() - 0.5) * span * 0.24
                local d1 = span * (0.34 + math.random() * 0.3)
                place(px + sx * t + lx * lat, pz + sz * t + lz * lat,
                    d1, d1 * (0.6 + math.random() * 0.34),
                    yaw0 + (math.random() - 0.5) * 1.6, 0.008 + i * 0.004, false)
            end
            for _ = 1, 2 do
                local t = (math.random() - 0.5) * span * 0.5
                local lat = (math.random() - 0.5) * span * 0.16
                local d1 = span * (0.14 + math.random() * 0.18)
                place(px + sx * t + lx * lat, pz + sz * t + lz * lat,
                    d1, d1 * (0.4 + math.random() * 0.35), math.random() * math.pi, 0.036, true)
            end
            s0, s1 = math.max(s0, span * -0.425), math.min(s1, span * 0.425)
            l0, l1 = math.max(l0, span * -0.225), math.min(l1, span * 0.225)
            local hw, hl = math.max(s1 - s0, 1), math.max(l1 - l0, 1)
            local hm, hn = (s0 + s1) * 0.5, (l0 + l1) * 0.5
            local k = (span / 26) ^ 1.5 * hw * hl / (span * span * 0.3825)
            local e, g = mkHost(m, CFrame.new(px + sx * hm + lx * hn, gy + 0.1, pz + sz * hm + lz * hn)
                * CFrame.Angles(0, -spine, 0), Vec(hw, 0.05, hl), k, I)
            m.Parent = _pud.folder
            local P = {
                cx = x, cz = z, top = gy + 0.06, r2 = rmax * rmax, k = k,
                key = cd.key, ci = cd.i, cj = cd.j, kind = cd.kind,
                slabs = slabs, ring = e, glint = g, model = m,
            }
            _plist[#_plist + 1] = P
            _pmap[cd.key] = P
            return true
        end
        function mkFloodCell(cd, I)
            local gy = cd.gy
            local m = Instance.new("Model")
            m.Name = "_pud"
            local slabs = {}
            local area, rmax = 0, 0
            local x0, x1, z0, z1 = 1e9, -1e9, 1e9, -1e9
            for a = 0, 1 do
                for b = 0, 1 do
                    local scx = cd.cx + (a - 0.5) * HALF
                    local scz = cd.cz + (b - 0.5) * HALF
                    local fw, fl = fitRect(scx, scz, HALF, HALF, gy)
                    if fw then
                        mkTile(fw, fl, CFrame.new(scx, gy + 0.002, scz), m)
                        slabs[#slabs + 1] = {
                            cx = scx, cz = scz, cs = 1, sn = 0,
                            ia = 2 / fw, ib = 2 / fl, rect = true,
                        }
                        area = area + fw * fl
                        rmax = math.max(rmax, 0.7072 * (HALF + fw))
                        x0 = math.min(x0, scx - fw * 0.5)
                        x1 = math.max(x1, scx + fw * 0.5)
                        z0 = math.min(z0, scz - fl * 0.5)
                        z1 = math.max(z1, scz + fl * 0.5)
                    end
                end
            end
            if area <= 0 then
                m:Destroy()
                return false
            end
            if area > CELL * CELL * 0.98 and math.random() < 0.45 then
                local d1 = CELL * (0.15 + math.random() * 0.1)
                local sx = cd.cx + (math.random() - 0.5) * CELL * 0.4
                local sz = cd.cz + (math.random() - 0.5) * CELL * 0.4
                local yaw = math.random() * math.pi
                local fx, fz, fd1, fd2 = fitSlab(sx, sz, d1, d1 * (0.4 + math.random() * 0.35), yaw, gy)
                if fx and math.abs(fx - cd.cx) + fd1 * 0.5 < HALF
                    and math.abs(fz - cd.cz) + fd1 * 0.5 < HALF then
                    mkSlab(fd1, fd2, CFrame.new(fx, gy + 0.036, fz)
                        * CFrame.Angles(0, yaw, 0) * CFrame.Angles(0, 0, HALF_PI), m, true)
                end
            end
            local hw, hl = math.max(x1 - x0, 1), math.max(z1 - z0, 1)
            local e, g = mkHost(m, CFrame.new((x0 + x1) * 0.5, gy + 0.1, (z0 + z1) * 0.5),
                Vec(hw, 0.05, hl), area * TILE_K, I)
            m.Parent = _pud.folder
            local P = {
                cx = cd.cx, cz = cd.cz, top = gy + 0.06, r2 = rmax * rmax, k = area * TILE_K,
                key = cd.key, ci = cd.i, cj = cd.j, kind = cd.kind,
                slabs = slabs, ring = e, glint = g, model = m,
            }
            _plist[#_plist + 1] = P
            _pmap[cd.key] = P
            return true
        end
        function mkSplashUnit(parent)
            local p = mkFlatPart(Vec(1.1, 0.1, 1.1), CFrame.new(0, -900, 0), parent)
            local ring = Instance.new("ParticleEmitter")
            ring:SetAttribute("WX_Custom", true)
            ring.Texture = TXP_RING
            ring.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
            ring.EmissionDirection = Enum.NormalId.Top
            ring.Speed = NumberRange.new(0.05, 0.05)
            ring.Rate = 0
            ring.Lifetime = NumberRange.new(0.45, 0.7)
            ring.Size = NumberSequence.new({ NSK(0, 0.1), NSK(1, 4) })
            ring.Transparency = NumberSequence.new({ NSK(0, 0.75), NSK(0.1, 0.05), NSK(0.5, 0.4), NSK(1, 1) })
            ring.Color = ColorSequence.new(Color3.fromRGB(230, 244, 255))
            ring.LightEmission = 0.5
            ring.Parent = p
            local foam = Instance.new("ParticleEmitter")
            foam:SetAttribute("WX_Custom", true)
            foam.Texture = TX_SNOWSOFT
            foam.Orientation = Enum.ParticleOrientation.VelocityParallel
            foam.EmissionDirection = Enum.NormalId.Top
            foam.Rate = 0
            foam.SpreadAngle = Vector2.new(56, 56)
            foam.Acceleration = Vec(0, -80, 0)
            foam.Lifetime = NumberRange.new(0.3, 0.6)
            foam.Size = NumberSequence.new({ NSK(0, 0.6, 0.22), NSK(1, 0.2) })
            foam.Squash = NumberSequence.new({ NSK(0, 1.5), NSK(1, 0.4) })
            foam.Speed = NumberRange.new(6, 12)
            foam.Color = ColorSequence.new(FOAM_C)
            foam.Transparency = NumberSequence.new({ NSK(0, 0.18), NSK(0.7, 0.45), NSK(1, 1) })
            foam.LightEmission = 0.18
            foam.Parent = p
            local drops = Instance.new("ParticleEmitter")
            drops:SetAttribute("WX_Custom", true)
            drops.Texture = TXP_DROP
            drops.Orientation = Enum.ParticleOrientation.VelocityParallel
            drops.EmissionDirection = Enum.NormalId.Top
            drops.Rate = 0
            drops.SpreadAngle = Vector2.new(52, 52)
            drops.Acceleration = Vec(0, -80, 0)
            drops.Lifetime = NumberRange.new(0.32, 0.62)
            drops.Size = NumberSequence.new({ NSK(0, 0.55, 0.18), NSK(1, 0.28) })
            drops.Speed = NumberRange.new(6, 12)
            drops.Color = ColorSequence.new(Color3.fromRGB(210, 232, 250))
            drops.Transparency = NumberSequence.new({ NSK(0, 0.1), NSK(0.75, 0.3), NSK(1, 1) })
            drops.LightEmission = 0.25
            drops.Parent = p
            local mist = Instance.new("ParticleEmitter")
            mist:SetAttribute("WX_Custom", true)
            mist.Texture = TX_SNOWSOFT
            mist.EmissionDirection = Enum.NormalId.Top
            mist.Rate = 0
            mist.Speed = NumberRange.new(1.2, 2.8)
            mist.SpreadAngle = Vector2.new(48, 48)
            mist.Lifetime = NumberRange.new(0.3, 0.5)
            mist.Size = NumberSequence.new({ NSK(0, 0.5), NSK(1, 1.6) })
            mist.Transparency = NumberSequence.new({ NSK(0, 0.75), NSK(1, 1) })
            mist.Color = ColorSequence.new(FOAM_C)
            mist.LightEmission = 0.1
            mist.Parent = p
            return { part = p, ring = ring, foam = foam, drops = drops, mist = mist }
        end
        function fireSplash(x, y, z, speed)
            local u = _units[_uIdx]
            if not u then
                return
            end
            _uIdx = (_uIdx % #_units) + 1
            local s = math.clamp(speed, 4, 36)
            u.part.CFrame = CFrame.new(x, y + 0.12, z)
            u.ring.Size = NumberSequence.new({ NSK(0, 0.1), NSK(1, 3.2 + s * 0.18) })
            local lo, hi = 5 + s * 0.38, 8 + s * 0.6
            u.foam.Speed = NumberRange.new(lo, hi)
            u.drops.Speed = NumberRange.new(lo * 0.8, hi * 0.9)
            u.ring:Emit(2)
            u.foam:Emit(9 + math.floor(s * 0.75))
            u.drops:Emit(4 + math.floor(s * 0.3))
            u.mist:Emit(3)
        end
        function dropPrint(x, y, z, heading, side)
            local p = _prints[_pIdx]
            if not p then
                return
            end
            _pIdx = (_pIdx % #_prints) + 1
            p.CFrame = CFrame.new(x, y + 0.02, z) * CFrame.Angles(0, heading, 0) * CFrame.new(side * 0.4, 0, 0)
            p.Transparency = 0.42
            TweenService:Create(p, TweenInfo.new(2.2), { Transparency = 1 }):Play()
        end
        function defaultActors()
            local n = 0
            local cam = Camera
            if not cam then
                return _abuf, 0
            end
            local camPos = cam.CFrame.Position
            for _, plr in Players:GetPlayers() do
                local ch = plr.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local pos = hrp.Position
                    local dx, dy, dz = pos.X - camPos.X, pos.Y - camPos.Y, pos.Z - camPos.Z
                    if dx * dx + dy * dy + dz * dz < 12100 then
                        local vel = hrp.AssemblyLinearVelocity
                        local grounded = vel.Y > -6 and vel.Y < 6
                        if not grounded then
                            local hum = ch:FindFirstChildOfClass("Humanoid")
                            grounded = hum ~= nil and hum.FloorMaterial ~= Enum.Material.Air
                        end
                        n = n + 1
                        local rec = _abuf[n]
                        if not rec then
                            rec = {}
                            _abuf[n] = rec
                        end
                        rec.key = plr
                        rec.fx, rec.fy, rec.fz = pos.X, pos.Y - 2.9, pos.Z
                        rec.vx, rec.vy, rec.vz = vel.X, vel.Y, vel.Z
                        rec.speed = math.sqrt(vel.X * vel.X + vel.Z * vel.Z)
                        rec.grounded = grounded
                    end
                end
            end
            return _abuf, n
        end
        local actorsProvider = defaultActors
        function inPuddle(P, x, z)
            local dx, dz = x - P.cx, z - P.cz
            if dx * dx + dz * dz > P.r2 then
                return false
            end
            for _, sl in P.slabs do
                local ux, uz = x - sl.cx, z - sl.cz
                local u = (-ux * sl.cs + uz * sl.sn) * sl.ia
                local v = (ux * sl.sn + uz * sl.cs) * sl.ib
                if sl.rect then
                    if u > -1 and u < 1 and v > -1 and v < 1 then
                        return true
                    end
                elseif u * u + v * v <= 1 then
                    return true
                end
            end
            return false
        end
        function fieldAt(wx, wz)
            return math.noise(wx * NOISE_F, wz * NOISE_F, _seed)
        end
        function floodThr(I)
            if I <= 1 then
                return -0.4043 * (I - 0.3)
            end
            if I <= 1.6 then
                return -0.283 - 0.3417 * (I - 1)
            end
            return -0.488 - 1.405 * (I - 1.6)
        end
        function refreshParams()
            local I = pudIntensity()
            _int = I
            _thr = floodThr(I)
            _placeR = 46 + 20 * I
            _wTr = 0.46 - 0.11 * I
            _wRf = 0.11 + 0.05 * I
        end
        function cellKind(i, j)
            local ccx, ccz = (i + 0.5) * CELL, (j + 0.5) * CELL
            if fieldAt(ccx, ccz) <= _thr then
                return 0
            end
            if fieldAt(ccx + CELL, ccz) > _thr and fieldAt(ccx - CELL, ccz) > _thr
                and fieldAt(ccx, ccz + CELL) > _thr and fieldAt(ccx, ccz - CELL) > _thr then
                return 2
            end
            return 1
        end
        function placeCell(i, j, key, kind, by)
            local folder = _pud.folder
            if not folder then
                return false
            end
            local ccx, ccz = (i + 0.5) * CELL, (j + 0.5) * CELL
            _pfilter[1] = folder
            local ch = lp and lp.Character
            if ch then
                _pfilter[2] = ch
            else
                _pfilter[2] = folder
            end
            _prp.FilterDescendantsInstances = _pfilter
            local hit = Workspace:Raycast(Vec(ccx, by + 6, ccz), PUD_DOWN, _prp)
            if not hit or hit.Normal.Y < 0.94 then
                return false
            end
            local inst = hit.Instance
            if not inst.CanCollide then
                return false
            end
            if inst:IsA("Terrain") and hit.Material == Enum.Material.Water then
                return false
            end
            local cd = _cd
            cd.i, cd.j, cd.key, cd.kind = i, j, key, kind
            cd.cx, cd.cz, cd.gy = ccx, ccz, hit.Position.Y
            if kind == 2 then
                return mkFloodCell(cd, _int)
            end
            local nslab = 5
            if _int > 1.15 then
                nslab = 4
            end
            return mkPuddle(cd, CELL * POOL_F * (0.82 + 0.24 * math.random()), nslab, _int)
        end
        function tryCell(i, j, bx, bz, by)
            local key = (i + 32768) * 65536 + j + 32768
            if _pmap[key] or _pfail[key] then
                return false
            end
            local dx = (i + 0.5) * CELL - bx
            local dz = (j + 0.5) * CELL - bz
            if dx * dx + dz * dz > _placeR * _placeR then
                return false
            end
            local kind = cellKind(i, j)
            if kind == 0 then
                return false
            end
            if not placeCell(i, j, key, kind, by) then
                _pfail[key] = true
            end
            return true
        end
        function maintain(bx, by, bz)
            local ci, cj = math.floor(bx / CELL), math.floor(bz / CELL)
            local budget = 8
            if ci ~= _homeI or cj ~= _homeJ then
                _homeI, _homeJ = ci, cj
                table.clear(_pfail)
            end
            if _rebuild then
                _rebuild = false
                refreshParams()
                table.clear(_pfail)
                budget = 18
                for _, P in _plist do
                    for _, d in P.model:GetChildren() do
                        if d:GetAttribute("WX_W") then
                            d.Transparency = _wTr
                            d.Reflectance = _wRf
                        end
                    end
                end
                local n = 1
                while n <= #_plist do
                    local P = _plist[n]
                    if P.kind == cellKind(P.ci, P.cj) then
                        n = n + 1
                    else
                        _pmap[P.key] = nil
                        P.model:Destroy()
                        _plist[n] = _plist[#_plist]
                        _plist[#_plist] = nil
                    end
                end
            end
            local cull = _placeR + CELL * 0.75
            local cull2 = cull * cull
            local n = 1
            while n <= #_plist do
                local P = _plist[n]
                local dx, dz = P.cx - bx, P.cz - bz
                if dx * dx + dz * dz > cull2 then
                    _pmap[P.key] = nil
                    P.model:Destroy()
                    _plist[n] = _plist[#_plist]
                    _plist[#_plist] = nil
                else
                    n = n + 1
                end
            end
            local nr = math.ceil(_placeR / CELL)
            for ring = 0, nr do
                for di = -ring, ring do
                    for dj = -ring, ring do
                        if budget > 0 and #_plist < MAX_REC
                            and math.max(math.abs(di), math.abs(dj)) == ring
                            and tryCell(ci + di, cj + dj, bx, bz, by) then
                            budget = budget - 1
                        end
                    end
                end
            end
            local ksum = 0
            for _, P in _plist do
                ksum = ksum + P.k
            end
            local damp = 1
            if ksum > K_CAP then
                damp = K_CAP / ksum
            end
            local rr = (2.1 + 4.2 * _int) * damp
            local gr = 0.8 * _int * damp
            for _, P in _plist do
                P.ring.Rate = rr * P.k
                P.glint.Rate = gr * P.k
            end
        end
        function tick20(now, doMaintain)
            local bx, by, bz
            local ch = lp and lp.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local p = hrp.Position
                bx, by, bz = p.X, p.Y, p.Z
            elseif Camera then
                local p = Camera.CFrame.Position
                bx, by, bz = p.X, p.Y, p.Z
            else
                return
            end
            if doMaintain then
                maintain(bx, by, bz)
            end
            local list, n = actorsProvider()
            for ai = 1, n do
                local a = list[ai]
                local st = _pstates[a.key]
                if not st then
                    st = { last = 0, wet = 0, side = 1, prevVy = 0 }
                    _pstates[a.key] = st
                end
                local sp = a.speed
                local pud = nil
                for _, P in _plist do
                    if math.abs(a.fy - P.top) < 4.5 and inPuddle(P, a.fx, a.fz) then
                        pud = P
                        break
                    end
                end
                local interval = math.clamp(3.6 / math.max(sp, 1), 0.15, 0.32)
                if pud and a.grounded and sp > 2.2 then
                    local landing = st.prevVy < -25
                    if landing or now - st.last >= interval then
                        st.last = now
                        st.side = -st.side
                        local fs = sp
                        if landing then
                            fs = 36
                        end
                        fireSplash(a.fx, pud.top, a.fz, fs)
                        st.wet = now + 1.7
                    end
                elseif not pud and now < st.wet and a.grounded and sp > 2.2 then
                    if now - st.last >= interval then
                        st.last = now
                        st.side = -st.side
                        dropPrint(a.fx, a.fy, a.fz, math.atan2(-a.vx, -a.vz), st.side)
                    end
                end
                st.prevVy = a.vy
            end
        end
        function startPuddles()
            if _pud.conn then
                return
            end
            local folder = Instance.new("Folder")
            folder.Name = "_wxPuddles"
            folder:SetAttribute("WX_Custom", true)
            folder.Parent = getFolder()
            _pud.folder = folder
            _plist = {}
            _pmap = {}
            table.clear(_pfail)
            _seed = math.random() * 512
            _homeI, _homeJ = 1e9, 1e9
            refreshParams()
            _units, _uIdx = {}, 1
            for i = 1, 8 do
                _units[i] = mkSplashUnit(folder)
            end
            _prints, _pIdx = {}, 1
            for i = 1, 12 do
                local p = mkFlatPart(Vec(0.6, 0.02, 1.0), CFrame.new(0, -900, 0), folder)
                p.Material = Enum.Material.SmoothPlastic
                p.Color = Color3.fromRGB(14, 18, 25)
                p.Reflectance = 0.18
                _prints[i] = p
            end
            local accum = 0
            local mTick = 0
            _pud.conn = RunService.Heartbeat:Connect(function(dt)
                accum = accum + dt
                if accum < 0.05 then
                    return
                end
                accum = 0
                if not pudActive() then
                    return
                end
                mTick = mTick + 1
                local doMaintain = false
                if mTick >= 14 then
                    mTick = 0
                    doMaintain = true
                end
                pcall(tick20, os.clock(), doMaintain)
            end)
        end
        function stopPuddles(hard)
            if _pud.conn then
                _pud.conn:Disconnect()
                _pud.conn = nil
            end
            table.clear(_pstates)
            local folder = _pud.folder
            _pud.folder = nil
            _plist = {}
            _pmap = {}
            table.clear(_pfail)
            _units = {}
            _prints = {}
            _rebuild = false
            if not folder then
                return
            end
            if hard then
                folder:Destroy()
                return
            end
            for _, m in folder:GetDescendants() do
                if m:IsA("ParticleEmitter") then
                    m.Rate = 0
                elseif m:IsA("Part") and m.Transparency < 1 then
                    TweenService:Create(m, TweenInfo.new(1.4, Enum.EasingStyle.Sine), { Transparency = 1 }):Play()
                end
            end
            task.delay(2.2, function()
                pcall(function() folder:Destroy() end)
            end)
        end
        function puddlesRefresh()
            if pudActive() then
                startPuddles()
            else
                stopPuddles(false)
            end
        end
        function puddlesIntensity()
            if not _pud.conn then
                return
            end
            _fieldToken = _fieldToken + 1
            local token = _fieldToken
            task.delay(0.25, function()
                if token ~= _fieldToken then
                    return
                end
                _rebuild = true
            end)
        end
    end)()
    function startClock()
        if _clockConn then return end
        local accum = 0
        _clockConn = RunService.Heartbeat:Connect(function(dt)
            accum = accum + dt
            if accum < 1 then return end
            accum = 0
            if not Config.Weather or not cfg("WeatherClockDial", false) then return end
            if Config.Visuals then return end
            local cycle = math.max(cfg("WeatherClockCycleMin", 8), 1) * 60
            local t = ((tick() % cycle) / cycle) * 24
            if math.abs(Lighting.ClockTime - t) > 0.02 then
                Lighting.ClockTime = t
            end
        end)
    end
    function stopClock()
        if _clockConn then _clockConn:Disconnect(); _clockConn = nil end
    end
    function normType(name)
        if name == "Rain" or name == "BloodMoon" or PRESETS[name] then
            return name
        end
        return "Rain"
    end
    function applyType(name)
        name = normType(name)
        local prev = _curType
        stopRain(); clearSpecial()
        if #_partLayers > 0 then
            beginLayerFade()
        end
        _curType = name
        if name == "Rain" then
            buildRain(); startRain()
        elseif name == "BloodMoon" then
            buildBloodMoon(); startSpecialAnim()
        else
            local ramp = PRESETS[prev] ~= nil
            local ir = IR[name] or IR_DEF
            for _, spec in PRESETS[name] do
                mkPartLayer(spec, ir, ramp)
            end
        end
        if name == "Fireflies" then startFireflies() else stopFireflies() end
        applyMood(name)
        startAmbient(SOUND[name])
        puddlesRefresh()
    end
    function Weather.setType(name)
        name = normType(name)
        Config.WeatherType = name
        if Config.Weather then applyType(name) end
    end
    local _intensityToken = 0
    function Weather.setIntensity(v)
        Config.WeatherIntensity = math.clamp(v, 0.15, 2)
        if not Config.Weather then return end
        puddlesIntensity()
        local I = Config.WeatherIntensity
        for _, L in _partLayers do
            if L.emitter then
                pcall(tuneLayer, L, I)
                if L.rateTween then L.rateTween:Cancel(); L.rateTween = nil end
                pcall(function() L.emitter.Rate = layerRate(L, I) * L.rateMul end)
            end
        end
        if _special.kind == "BloodMoon" then pcall(tuneBloodMoon, I) end
        if _rays then
            pcall(function()
                _rays.Intensity = 0.10 + 0.18 * I
                _rays.Spread = 1.1 - 0.2 * I
            end)
        end
        _intensityToken = _intensityToken + 1
        local token = _intensityToken
        task.delay(0.12, function()
            if token ~= _intensityToken then return end
            if not Config.Weather then return end
            if _curType == "Rain" then pcall(tuneRain) end
            if _curType then pcall(applyMood, _curType) end
            pcall(refreshFireflies)
        end)
    end
    function Weather.setSoundVolume(v)
        Config.WeatherSoundVolume = v
        if _ambient then pcall(function() _ambient.Volume = v end) end
    end
    function Weather.toggleStorm(on)
        Config.WeatherStorm = on
        if not Config.Weather then return end
        if on then startStorm() else stopStormLoop() end
        puddlesRefresh()
    end
    function Weather.setStormMin(v)
        Config.WeatherStormMin = math.clamp(v, 1, 30)
        rescheduleStorm()
    end
    function Weather.setStormVar(v)
        Config.WeatherStormVar = math.clamp(v, 0, 30)
        rescheduleStorm()
    end
    function Weather.setMeteorRate(v)
        Config.WeatherMeteorRate = math.clamp(v, 0.25, 3)
        rescheduleMeteors()
    end
    function Weather.setStarRate(v)
        Config.WeatherStarRate = math.clamp(v, 0.25, 3)
        rescheduleStars()
    end
    function Weather.togglePuddles(on)
        Config.WeatherPuddles = on
        puddlesRefresh()
    end
    function Weather.toggleMood(on)
        Config.WeatherMood = on
        if Config.Weather and _curType then
            if on then applyMood(_curType) else clearMood() end
        end
    end
    function Weather.toggleMeteors(on)
        Config.WeatherMeteors = on
        if Config.Weather then if on then startMeteors() else stopMeteors() end end
    end
    function Weather.toggleShootingStars(on)
        Config.WeatherShootingStars = on
        if Config.Weather then if on then startStars() else stopStars() end end
    end
    function Weather.toggleClock(on)
        Config.WeatherClockDial = on
        if Config.Weather then if on then startClock() else stopClock() end end
    end
    function Weather.enableWeather()
        Config.Weather = true
        getFolder(); startFollow()
        applyType(cfg("WeatherType", "Rain"))
        if cfg("WeatherStorm", false) then startStorm() end
        if cfg("WeatherMeteors", false) then startMeteors() end
        if cfg("WeatherShootingStars", false) then startStars() end
        if cfg("WeatherClockDial", false) then startClock() end
    end
    function Weather.disableWeather()
        Config.Weather = false
        stopFollow(); stopStorm(); stopRain(); clearPartLayers(); killFade(); clearMood()
        clearSpecial(); stopMeteors(); stopStars(); stopFireflies(); stopLeafDevil(); stopClock()
        stopPuddles(true)
        if _ambient then pcall(function() _ambient:Destroy() end); _ambient = nil end
        _curType = nil
    end
    local SKY = {
        Space     = { Bk="rbxassetid://159454299", Dn="rbxassetid://159454296", Ft="rbxassetid://159454293", Lf="rbxassetid://159454286", Rt="rbxassetid://159454300", Up="rbxassetid://159454288" },
        Sunset    = { Bk="rbxassetid://264908339", Dn="rbxassetid://264907909", Ft="rbxassetid://264909420", Lf="rbxassetid://264909758", Rt="rbxassetid://264908886", Up="rbxassetid://264907379" },
        Clouds    = { Bk="rbxassetid://570557514", Dn="rbxassetid://570557775", Ft="rbxassetid://570557559", Lf="rbxassetid://570557620", Rt="rbxassetid://570557672", Up="rbxassetid://570557727" },
        Storm     = { Bk="rbxassetid://255027929", Dn="rbxassetid://255027967", Ft="rbxassetid://255027923", Lf="rbxassetid://255027938", Rt="rbxassetid://255027946", Up="rbxassetid://255027960" },
        Winter    = { Bk="rbxassetid://402229526", Dn="rbxassetid://402229596", Ft="rbxassetid://402229293", Lf="rbxassetid://402229368", Rt="rbxassetid://402229417", Up="rbxassetid://402229564" },
        Vaporwave = { Bk="rbxassetid://1417494030", Dn="rbxassetid://1417494146", Ft="rbxassetid://1417494253", Lf="rbxassetid://1417494402", Rt="rbxassetid://1417494499", Up="rbxassetid://1417494643" },
    }
    Weather.SkyboxOrder = { "Off", "Space", "Sunset", "Clouds", "Storm", "Winter", "Vaporwave" }
    local _sky, _skyConn = nil, nil
    local _origSkies = {}
    function hideMapSkies()
        for _, c in ipairs(Lighting:GetChildren()) do
            if c:IsA("Sky") and not c:GetAttribute("WX_Custom") then
                table.insert(_origSkies, c)
                pcall(function() c.Parent = nil end)
            end
        end
    end
    function restoreMapSkies()
        for i = #_origSkies, 1, -1 do
            local c = _origSkies[i]
            if c and c.Parent == nil then
                pcall(function() c.Parent = Lighting end)
            end
            _origSkies[i] = nil
        end
    end
    function buildSky(preset)
        local set = SKY[preset]; if not set then return end
        hideMapSkies()
        local s = Instance.new("Sky")
        s.Name = "_wxSky"; s:SetAttribute("WX_Custom", true)
        s.SkyboxBk, s.SkyboxDn, s.SkyboxFt = set.Bk, set.Dn, set.Ft
        s.SkyboxLf, s.SkyboxRt, s.SkyboxUp = set.Lf, set.Rt, set.Up
        if cfg("SkyboxHideCelestial", false) then
            s.SunAngularSize = 0; s.MoonAngularSize = 0; s.StarCount = 0
            s.CelestialBodiesShown = false
        else
            s.CelestialBodiesShown = true
        end
        s.Parent = Lighting
        _sky = s
    end
    function startSkyGuard()
        if _skyConn then return end
        _skyConn = Lighting.ChildAdded:Connect(function(c)
            if c:IsA("Sky") and not c:GetAttribute("WX_Custom") and Config.SkyboxPreset and Config.SkyboxPreset ~= "Off" then
                table.insert(_origSkies, c)
                pcall(function() c.Parent = nil end)
            end
        end)
    end
    function stopSkyGuard()
        if _skyConn then _skyConn:Disconnect(); _skyConn = nil end
    end
    function clearSky()
        if _sky then pcall(function() _sky:Destroy() end); _sky = nil end
        restoreMapSkies()
    end
    function Weather.setSkybox(preset)
        if preset and not SKY[preset] then preset = "Off" end
        Config.SkyboxPreset = preset
        clearSky()
        if preset == "Off" or preset == nil then stopSkyGuard(); return end
        buildSky(preset); startSkyGuard()
    end
    function Weather.toggleCelestial(hide)
        Config.SkyboxHideCelestial = hide
        if _sky then
            if hide then
                _sky.SunAngularSize = 0; _sky.MoonAngularSize = 0; _sky.StarCount = 0
                _sky.CelestialBodiesShown = false
            else
                _sky.SunAngularSize = 11; _sky.MoonAngularSize = 11; _sky.StarCount = 3000
                _sky.CelestialBodiesShown = true
            end
        end
    end
    local _rainbow = { host = nil, conn = nil }
    local RB_BANDS = {
        { Color3.fromRGB(255, 40, 40),  0.10, 24 },
        { Color3.fromRGB(255, 130, 20), 0.12, 24 },
        { Color3.fromRGB(255, 225, 40), 0.14, 24 },
        { Color3.fromRGB(60, 210, 70),  0.16, 24 },
        { Color3.fromRGB(40, 130, 255), 0.18, 24 },
        { Color3.fromRGB(85, 60, 235),  0.26, 18 },
        { Color3.fromRGB(165, 65, 230), 0.30, 16 },
    }
    local RB_DIST, RB_OY = 430, -20
    function clearRainbow()
        if _rainbow.conn then _rainbow.conn:Disconnect(); _rainbow.conn = nil end
        if _rainbow.host then pcall(function() _rainbow.host:Destroy() end); _rainbow.host = nil end
    end
    function buildRainbow()
        local host = Instance.new("Part")
        host.Name = "_wxRainbow"; host.Anchored = true; host.CanCollide = false; host.CanQuery = false
        host.CanTouch = false; host.CastShadow = false; host.Massless = true; host.Transparency = 1
        host.Size = Vec(1, 1, 1); host:SetAttribute("WX_Custom", true)
        local rot = CFrame.Angles(0, 0, math.rad(90))
        function band(sp, rr, w, col, midT, emit, soft)
            local a0 = Instance.new("Attachment"); a0.CFrame = CFrame.new(-sp, 0, 0) * rot; a0.Parent = host
            local a1 = Instance.new("Attachment"); a1.CFrame = CFrame.new( sp, 0, 0) * rot; a1.Parent = host
            local b = Instance.new("Beam")
            b.Attachment0 = a0; b.Attachment1 = a1; b.Segments = 46; b.FaceCamera = true
            if soft then b.Texture = TX_SOFT; b.TextureMode = Enum.TextureMode.Stretch; b.TextureLength = 1 end
            b.Width0 = w; b.Width1 = w; b.CurveSize0 = rr; b.CurveSize1 = -rr
            b.LightEmission = emit; b.LightInfluence = 0
            b.Color = ColorSequence.new(col)
            local edge = math.min(midT + 0.25, 1)
            b.Transparency = NumberSequence.new({
                NSK(0, 1), NSK(0.08, edge), NSK(0.45, midT), NSK(0.55, midT), NSK(0.92, edge), NSK(1, 1) })
            b.Parent = host
        end
        for i = 1, #RB_BANDS do
            local B = RB_BANDS[i]
            band(340, 320 - (i - 1) * 15, B[3], B[1], B[2], 0.42, false)
        end
        band(340, 165, 52, Color3.fromRGB(242, 248, 255), 0.78, 0.6, true)
        for i = 1, #RB_BANDS do
            band(400, 355 + (i - 1) * 12, 20, RB_BANDS[i][1], 0.64 + i * 0.012, 0.42, false)
        end
        host.Parent = getFolder()
        _rainbow.host = host
    end
    function startRainbowFollow()
        if _rainbow.conn then return end
        local accum = 0
        _rainbow.conn = RunService.Heartbeat:Connect(function(dt)
            if not cfg("WeatherRainbow", false) then return end
            accum = accum + dt; if accum < 0.08 then return end
            accum = 0
            local cam = Camera; if not cam then return end
            local host = _rainbow.host; if not host or not host.Parent then return end
            local p = cam.CFrame.Position
            local hp = Vec(p.X, p.Y + RB_OY, p.Z - RB_DIST)
            host.CFrame = CFrame.lookAt(hp, Vec(p.X, hp.Y, p.Z))
        end)
    end
    function Weather.toggleRainbow(on)
        Config.WeatherRainbow = on
        clearRainbow()
        if not on then return end
        buildRainbow(); startRainbowFollow()
    end
    function Weather.toggleGodRays(on)
        Config.WeatherGodRays = on
        if _rays then pcall(function() _rays:Destroy() end); _rays = nil end
        if not on then return end
        local r = Instance.new("SunRaysEffect")
        r.Name = "_wxRays"; r:SetAttribute("WX_Custom", true)
        local I = iAmt()
        r.Intensity = 0.10 + 0.18 * I
        r.Spread = 1.1 - 0.2 * I
        r.Parent = Lighting
        _rays = r
    end
    function Weather.init()
        if Config.Weather then pcall(Weather.enableWeather) end
        if Config.SkyboxPreset and Config.SkyboxPreset ~= "Off" then pcall(Weather.setSkybox, Config.SkyboxPreset) end
        if Config.WeatherGodRays then pcall(Weather.toggleGodRays, true) end
        if Config.WeatherRainbow then pcall(Weather.toggleRainbow, true) end
    end
    function Weather.unload()
        pcall(Weather.disableWeather)
        stopSkyGuard(); clearSky(); clearRainbow()
        if _rays then pcall(function() _rays:Destroy() end); _rays = nil end
        if _folder then pcall(function() _folder:Destroy() end); _folder = nil end
        _lightFolder = nil
    end
end)()


-- Wrappers para shako UI
function StartWeather()
    config.WeatherEnabled = true
    config.Weather = true
    pcall(function() if Config then Config.Weather = true end end)
    -- rebuild completo (map load destruye _wx)
    pcall(function()
        if Weather and Weather.disableWeather then Weather.disableWeather() end
    end)
    task.defer(function()
        pcall(function() Weather.enableWeather() end)
        if config.SkyboxPreset and config.SkyboxPreset ~= "Off" then
            pcall(function() if Weather and Weather.setSkybox then Weather.setSkybox(config.SkyboxPreset) end end)
        end
        if skyboxData and skyboxData.enabled then pcall(ApplySkybox) end
    end)
    if not getgenv()._ShakoQuiet then Notify("Weather", "ON · " .. tostring(config.WeatherType or "Rain")) end
end

-- ==================== CAM MODULES (scoped — evita 200 locals) ====================
;(function()
local S = rawget(getgenv(), "_ShakoCam") or {}
getgenv()._ShakoCam = S
S.tpRP = S.tpRP
S.tpConn = S.tpConn
S.stretchBaseFOV = S.stretchBaseFOV
S.wfOrig = S.wfOrig or setmetatable({}, { __mode = "k" })
S.wfAdorns = S.wfAdorns or {}
-- state via S
local _wfOrig, _wfAdorns = S.wfOrig, S.wfAdorns -- scoped


function wfGetLocalVMs()
    local out = {}
    local folder = workspace:FindFirstChild("ViewModels")
    if not folder then return out end
    local prefix = LocalPlayer.Name .. " - "
    for _, m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") and string.sub(m.Name, 1, #prefix) == prefix then
            table.insert(out, m)
        end
    end
    -- tambien buscar por descendent si structure nested
    if #out == 0 then
        for _, m in ipairs(folder:GetDescendants()) do
            if m:IsA("Model") and string.find(m.Name, LocalPlayer.Name, 1, true) then
                table.insert(out, m)
            end
        end
    end
    return out
end

function wfApplyPart(part, on, color)
    if not part or not part:IsA("BasePart") then return end
    if on then
        if not _wfOrig[part] then
            _wfOrig[part] = {
                Material = part.Material,
                Color = part.Color,
                Transparency = part.Transparency,
            }
        end
        pcall(function()
            part.Material = Enum.Material.ForceField
            part.Color = color or Color3.fromRGB(0, 255, 180)
            if part.Transparency > 0.9 then part.Transparency = 0.3 end
        end)
        -- adornment outline
        if not _wfAdorns[part] or not _wfAdorns[part].Parent then
            local ok, w = pcall(function()
                local a = Instance.new("WireframeHandleAdornment")
                a.Name = "ShakoWF"
                a.Adornee = part
                a.Color3 = color or Color3.fromRGB(0, 255, 180)
                a.Transparency = 0.2
                a.Thickness = 0.05
                a.AlwaysOnTop = true
                a.Parent = part
                return a
            end)
            if ok and w then _wfAdorns[part] = w end
        else
            pcall(function()
                _wfAdorns[part].Color3 = color or Color3.fromRGB(0, 255, 180)
                _wfAdorns[part].Visible = true
            end)
        end
    else
        local o = _wfOrig[part]
        if o then
            pcall(function()
                part.Material = o.Material
                part.Color = o.Color
                part.Transparency = o.Transparency
            end)
            _wfOrig[part] = nil
        end
        if _wfAdorns[part] then
            pcall(function() _wfAdorns[part]:Destroy() end)
            _wfAdorns[part] = nil
        end
    end
end

function StartWeaponWireframe()
    config.WeaponWireframe = true
    SafeDisconnect("WeaponWireframe")
    local _wwFrame = 0
    Connections.WeaponWireframe = RunService.Heartbeat:Connect(function()
        if not config.WeaponWireframe then return end
        _wwFrame += 1
        if _wwFrame % 6 ~= 0 then return end
        local col = config.WeaponWireframeColor
        if typeof(col) ~= "Color3" then col = Color3.fromRGB(0, 255, 180) end
        for _, vm in ipairs(wfGetLocalVMs()) do
            for _, d in ipairs(vm:GetDescendants()) do
                if d:IsA("BasePart") then
                    wfApplyPart(d, true, col)
                elseif d:IsA("MeshPart") then
                    wfApplyPart(d, true, col)
                end
            end
        end
        -- ViewModels bajo CurrentCamera (solo modelos del arma)
        local cam = workspace.CurrentCamera
        if cam then
            for _, m in ipairs(cam:GetChildren()) do
                if m:IsA("Model") or m:IsA("Folder") then
                    local mn = string.lower(m.Name)
                    if mn:find("view") or mn:find("weapon") or mn:find("gun") or mn:find("item") or mn:find(string.lower(LocalPlayer.Name)) then
                        for _, d in ipairs(m:GetDescendants()) do
                            if d:IsA("BasePart") or d:IsA("MeshPart") then
                                wfApplyPart(d, true, col)
                            end
                        end
                    end
                end
            end
        end
    end)
    Notify("Wireframe", "ON")
end

function StopWeaponWireframe()
    config.WeaponWireframe = false
    SafeDisconnect("WeaponWireframe")
    for part, _ in pairs(_wfOrig) do
        wfApplyPart(part, false)
    end
    for part, a in pairs(_wfAdorns) do
        pcall(function() a:Destroy() end)
    end
    table.clear(_wfAdorns)
    table.clear(_wfOrig)
    -- cleanup any left
    pcall(function()
        local folder = workspace:FindFirstChild("ViewModels")
        if folder then
            for _, a in ipairs(folder:GetDescendants()) do
                if a:IsA("WireframeHandleAdornment") and a.Name == "ShakoWF" then
                    a:Destroy()
                end
            end
        end
    end)
    Notify("Wireframe", "OFF")
end

function StartStretchedRes()
    -- legacy: redirige a Elisium stretch
    config.StretchedRes = false
    config.EliStretch = true
    SafeDisconnect("StretchedRes")
    return
end


function StopStretchedRes()
    config.StretchedRes = false
    SafeDisconnect("StretchedRes")
    local c = workspace.CurrentCamera
    if c and S.stretchBaseFOV then
        pcall(function() c.FieldOfView = S.stretchBaseFOV end)
    end
    S.stretchBaseFOV = nil
    if not getgenv()._ShakoQuiet and not (getgenv()._ShakoBootAt and tick() - getgenv()._ShakoBootAt < 8) then
        Notify("Stretch", "OFF")
    end
end

-- sync state out
S.tpRP, S.tpConn, S.stretchBaseFOV = S.tpRP, _tpConn, S.stretchBaseFOV
S.wfOrig, S.wfAdorns = _wfOrig, _wfAdorns
end)()

-- ==================== THIRD PERSON (Harion · scoped) ====================
;(function()
local S = getgenv()._ShakoCam or {}
getgenv()._ShakoCam = S
local _tpLoop = nil
local _harionCamCtrl = nil

function getHarionCameraController()
    if _harionCamCtrl then return _harionCamCtrl end
    pcall(function()
        _harionCamCtrl = require(LocalPlayer.PlayerScripts.Controllers.CameraController)
    end)
    return _harionCamCtrl
end

function setHarionPOV(stateName)
    local gun = getHarionCameraController()
    if not gun or not gun.CameraState then return false end
    local st = gun.CameraState.States
    if not st then return false end
    local target = nil
    if stateName == "ThirdPerson Mirrored" or stateName == "ThirdPersonMirrored" then
        target = st.ThirdPersonMirrored or st.ThirdPerson
    elseif stateName == "FirstPerson" then
        target = st.FirstPerson
    else
        target = st.ThirdPerson
    end
    if not target then return false end
    pcall(function()
        gun.CameraState:_SetPOVState(target)
    end)
    return true
end

function StartThirdPerson()
    config.ThirdPerson = true
    config.ThirdPersonEnabled = true
    if S.tpConn then pcall(function() S.tpConn:Disconnect() end) S.tpConn = nil end
    if _tpLoop then
        pcall(function() task.cancel(_tpLoop) end)
        _tpLoop = nil
    end
    _tpLoop = task.spawn(function()
        while config.ThirdPerson or config.ThirdPersonEnabled do
            local mode = tostring(config.ThirdPersonMode or "ThirdPerson")
            setHarionPOV(mode)
            if config.ThirdPersonUnlockMouse then
                pcall(function()
                    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                end)
            end
            task.wait(0.1)
        end
    end)
    if not getgenv()._ShakoQuiet then
        Notify("Camera", "Third Person · " .. tostring(config.ThirdPersonMode or "ThirdPerson"))
    end
end

function StopThirdPerson()
    config.ThirdPerson = false
    config.ThirdPersonEnabled = false
    if _tpLoop then
        pcall(function() task.cancel(_tpLoop) end)
        _tpLoop = nil
    end
    if S.tpConn then pcall(function() S.tpConn:Disconnect() end) S.tpConn = nil end
    setHarionPOV("FirstPerson")
    -- NO forzar LockCenter aquí: deja que el juego decida (evita cursor pegado al centro)
    pcall(function()
        UserInputService.MouseIconEnabled = true
    end)
    if not getgenv()._ShakoQuiet and not (getgenv()._ShakoBootAt and tick() - getgenv()._ShakoBootAt < 8) then
        Notify("Camera", "Third Person OFF (1st person)")
    end
end
end)()


-- ==================== MOUSE UNLOCK (fix cursor stuck center) ====================
getgenv()._ShakoMouseFix = getgenv()._ShakoMouseFix or { conn = nil }

function ShakoUnlockMouse()
    pcall(function()
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
end

function ShakoFixMouseLoop()
    local S = getgenv()._ShakoMouseFix
    if S.conn then pcall(function() S.conn:Disconnect() end) S.conn = nil end
    S.conn = RunService.RenderStepped:Connect(function()
        local menuOpen = false
        pcall(function()
            if Library and Library.Unloaded then return end
            -- Linoria/UE: Toggled o IsOpen / MenuOpen
            if Library.Toggled == true or Library.MenuOpen == true then
                menuOpen = true
            elseif type(Library.IsOpen) == "function" then
                menuOpen = Library:IsOpen() == true
            elseif Library.Open == true then
                menuOpen = true
            end
            -- Window holder visible
            if not menuOpen and Window and Window.Holder then
                menuOpen = Window.Holder.Visible == true
            end
        end)
        if menuOpen then
            pcall(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
                if Library then
                    Library.ShowCustomCursor = true
                end
            end)
            return
        end
        if (config.ThirdPerson or config.ThirdPersonEnabled) and config.ThirdPersonUnlockMouse then
            pcall(function()
                UserInputService.MouseBehavior = Enum.MouseBehavior.Default
                UserInputService.MouseIconEnabled = true
            end)
        end
    end)
end

pcall(ShakoFixMouseLoop)

-- Keybind opcional: RightAlt desbloquea mouse
pcall(function()
    UserInputService.InputBegan:Connect(function(input, gp)
        if gp then return end
        if input.KeyCode == Enum.KeyCode.RightAlt then
            ShakoUnlockMouse()
            if not getgenv()._ShakoQuiet then
                pcall(function() Notify("Mouse", "Unlock (RightAlt)") end)
            end
        end
    end)
end)

function StopWeather()
    config.WeatherEnabled = false
    Config.Weather = false
    pcall(function() Weather.disableWeather() end)
    if not getgenv()._ShakoQuiet and not (getgenv()._ShakoBootAt and tick() - getgenv()._ShakoBootAt < 8) then
        Notify("Weather", "OFF")
    end
end

-- ==================== EMOTES (siempre loop + keep playing) ====================
EMOTES = {
    -- IDs públicos que suelen cargar en cliente
    ["Floss"] = "5917459365",
    ["Orange Justice"] = "3934987096",
    ["Take The L"] = "3333499508",
    ["Default Dance"] = "4265725525",
    ["Electro Shuffle"] = "3489178132",
    ["Fresh"] = "3183986796",
    ["Robot"] = "4555808220",
    ["Hype"] = "3360689775",
    ["Dab"] = "3333499505",
    ["Laugh"] = "3333430984",
    ["Wave"] = "507770239",
    ["Point"] = "507770453",
    ["Cheer"] = "507770677",
    ["Gangnam"] = "5918726674",
    ["Shuffle"] = "434870490",
    ["Breakdance"] = "5918726674",
    ["Twist"] = "3333492741",
    ["Zombie"] = "3489174152",
    -- TUS IDs (cargados vía GetObjects / InsertService)
    ["Custom A"] = "86329197824055",
    ["Custom B"] = "91729309021707",
    ["Custom C"] = "133811691098518",
    ["Custom D"] = "133375187065498",
    -- nuevas
    ["Custom E"] = "130601328561804",
    ["Custom F"] = "129571341119376",
    ["Custom G"] = "79902725961872",
    ["Custom H"] = "119060168059843",
    ["Custom I"] = "82995540773684",
    ["Custom J"] = "78224683906191",
    ["Custom K"] = "73562814360939",
    ["Custom L"] = "88425531063616",
    -- aliases por id
    ["86329197824055"] = "86329197824055",
    ["91729309021707"] = "91729309021707",
    ["133811691098518"] = "133811691098518",
    ["133375187065498"] = "133375187065498",
    ["130601328561804"] = "130601328561804",
    ["129571341119376"] = "129571341119376",
    ["79902725961872"] = "79902725961872",
    ["119060168059843"] = "119060168059843",
    ["82995540773684"] = "82995540773684",
    ["78224683906191"] = "78224683906191",
    ["73562814360939"] = "73562814360939",
    ["88425531063616"] = "88425531063616",
}

-- Emote state en getgenv (evita limite 200 locals)
getgenv()._ShakoEmote = getgenv()._ShakoEmote or { track = nil, conn = nil, lastId = nil, lastRestart = 0 }

function StopEmote()
    local S = getgenv()._ShakoEmote
    if S.conn then
        pcall(function() S.conn:Disconnect() end)
        S.conn = nil
    end
    if S.track then
        pcall(function() S.track:Stop(0.1) end)
        S.track = nil
    end
    config.EmoteEnabled = false
end

function getAnimator(hum)
    if not hum then return nil end
    local animator = hum:FindFirstChildOfClass("Animator")
    if not animator then
        animator = Instance.new("Animator")
        animator.Parent = hum
    end
    return animator
end

-- Cache de Animation ya resueltas por id
getgenv()._ShakoAnimCache = getgenv()._ShakoAnimCache or {}
_animCache = getgenv()._ShakoAnimCache

function resolveAnimationObject(id)
    id = tostring(id or ""):gsub("%D", "")
    if id == "" then return nil end
    if _animCache[id] and _animCache[id].Parent ~= nil then
        return _animCache[id]
    end

    function fromInstance(inst)
        if not inst then return nil end
        if inst:IsA("Animation") then return inst end
        if inst:IsA("KeyframeSequence") then
            -- convertir via AnimationClipProvider si existe
            local ok, animId = pcall(function()
                local ACP = game:GetService("AnimationClipProvider")
                return ACP:RegisterAnimationClip(inst)
            end)
            if ok and animId then
                local a = Instance.new("Animation")
                a.AnimationId = animId
                return a
            end
        end
        -- buscar Animation adentro (asset de catálogo / package)
        for _, d in ipairs(inst:GetDescendants()) do
            if d:IsA("Animation") then return d end
        end
        if inst:IsA("Model") or inst:IsA("Folder") then
            local a = inst:FindFirstChildWhichIsA("Animation", true)
            if a then return a end
        end
        return nil
    end

    -- 1) game:GetObjects (exploit) — el más fiable para IDs de catálogo
    local ok, objs = pcall(function()
        return game:GetObjects("rbxassetid://" .. id)
    end)
    if ok and type(objs) == "table" then
        for _, o in ipairs(objs) do
            local a = fromInstance(o)
            if a then
                _animCache[id] = a
                return a
            end
        end
    end

    -- 2) InsertService:LoadAsset
    pcall(function()
        local IS = game:GetService("InsertService")
        local model = IS:LoadAsset(tonumber(id))
        if model then
            local a = fromInstance(model)
            if a then
                _animCache[id] = a
                model.Parent = nil
                return a
            end
            pcall(function() model:Destroy() end)
        end
    end)
    if _animCache[id] then return _animCache[id] end

    -- 3) Animation "manual" con varios formatos de URL
    for _, uri in ipairs({
        "rbxassetid://" .. id,
        "http://www.roblox.com/asset/?id=" .. id,
        "https://www.roblox.com/asset/?id=" .. id,
    }) do
        local a = Instance.new("Animation")
        a.Name = "ShakoEmote_" .. id
        a.AnimationId = uri
        _animCache[id] = a
        return a
    end
    return nil
end

function loadTrack(animator, id)
    id = tostring(id or ""):gsub("%D", "")
    if id == "" or not animator then return nil end

    local animObj = resolveAnimationObject(id)
    if animObj and animObj:IsA("Animation") then
        local ok, track = pcall(function() return animator:LoadAnimation(animObj) end)
        if ok and track then return track end
        local hum = animator.Parent
        if hum and hum:IsA("Humanoid") then
            ok, track = pcall(function() return hum:LoadAnimation(animObj) end)
            if ok and track then return track end
        end
    end

    -- último recurso: Animation nueva directa
    for _, uri in ipairs({
        "rbxassetid://" .. id,
        "http://www.roblox.com/asset/?id=" .. id,
    }) do
        local anim = Instance.new("Animation")
        anim.AnimationId = uri
        local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
        if ok and track then return track end
        local hum = animator.Parent
        if hum and hum:IsA("Humanoid") then
            ok, track = pcall(function() return hum:LoadAnimation(anim) end)
            if ok and track then return track end
        end
    end
    return nil
end

function stopCompeting(animator, keep)
    pcall(function()
        for _, t in ipairs(animator:GetPlayingAnimationTracks()) do
            if t ~= keep then
                local pr = t.Priority
                -- no matar Core de muerte; sí Movement/Action bajos
                if pr == Enum.AnimationPriority.Movement
                    or pr == Enum.AnimationPriority.Idle
                    or pr == Enum.AnimationPriority.Action
                    or pr == Enum.AnimationPriority.Action2
                    or pr == Enum.AnimationPriority.Action3 then
                    pcall(function() t:Stop(0) end)
                end
            end
        end
    end)
end

function PlayEmote(animId, speed)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = getAnimator(hum)
    if not animator then return end

    local id = tostring(animId or config.EmoteId or ""):gsub("%D", "")
    local emoteName = config.EmoteName
    if id == "" and emoteName and EMOTES and EMOTES[emoteName] then
        id = tostring(EMOTES[emoteName]):gsub("%D", "")
    end
    if id == "" then id = "5917459365" end

    getgenv()._ShakoEmote = getgenv()._ShakoEmote or {}
    getgenv()._ShakoEmote.lastId = id
    config.EmoteId = id
    config.EmoteEnabled = true
    if not config.EmoteAlwaysOn then
        config.EmoteKeepPlaying = false
    end

    -- CRITICO: no pisar animaciones (body twist / animate off = tieso para otros)
    pcall(function()
        if type(StopBodyTwist) == "function" then StopBodyTwist() end
        config.BodyTwist = false
    end)
    pcall(function()
        local anim = char:FindFirstChild("Animate")
        if anim then anim.Enabled = true end
    end)

    if getgenv()._ShakoEmote.track then
        pcall(function() getgenv()._ShakoEmote.track:Stop(0.1) end)
        getgenv()._ShakoEmote.track = nil
    end

    -- 1) Remote del juego → LOS DEMAS ven el emote (Rivals)
    pcall(function()
        local remote = game:GetService("ReplicatedStorage")
            :FindFirstChild("Remotes")
        remote = remote and remote:FindFirstChild("Replication")
        remote = remote and remote:FindFirstChild("Fighter")
        remote = remote and remote:FindFirstChild("UseEmoteByName")
        if remote then
            -- nombre de emote del juego
            if emoteName and emoteName ~= "" and emoteName ~= "Custom" then
                remote:FireServer(tostring(emoteName))
            end
            -- algunos builds aceptan id como string
            pcall(function() remote:FireServer(tostring(id)) end)
        end
    end)
    -- Alternate remotes
    pcall(function()
        local f = game:GetService("ReplicatedStorage").Remotes.Replication.Fighter
        for _, name in ipairs({"UseEmote", "PlayEmote", "Emote", "ReplicateEmote"}) do
            local r = f:FindFirstChild(name)
            if r then
                pcall(function() r:FireServer(emoteName or id) end)
                pcall(function() r:FireServer(id) end)
            end
        end
    end)

    -- 2) Local track (tu vista) — prioridad alta pero SIN matar el Animate del server
    local track = loadTrack(animator, id)
    if not track then
        task.wait(0.15)
        track = loadTrack(animator, id)
    end
    if track then
        pcall(function()
            -- Priority Movement: el slide del juego controla el body, el emote no lo tuerce
            track.Priority = Enum.AnimationPriority.Movement
            track.Looped = true
            local spd = tonumber(speed) or tonumber(config.EmoteSpeed) or 1
            local sliding = false
            pcall(function()
                if type(IsPlayerSliding) == "function" then
                    sliding = IsPlayerSliding()
                elseif getgenv()._ShakoSlideGuard then
                    sliding = getgenv()._ShakoSlideGuard.sliding == true
                end
            end)
            if sliding then
                getgenv()._ShakoEmote.track = track
                getgenv()._ShakoSlideGuard = getgenv()._ShakoSlideGuard or {}
                getgenv()._ShakoSlideGuard.emotePaused = true
                getgenv()._ShakoSlideGuard.pendingResume = true
                track:Stop(0)
                return
            end
            track:Play(0.15, 0.85, spd)
        end)
        getgenv()._ShakoEmote.track = track
        Notify("Emote", "ON · " .. id .. " (remote + local)")
    else
        Notify("Emote", "Remote enviado · local ID fallo: " .. id)
    end
end

-- auto resume al respawn si estaba activo
pcall(function()
    LocalPlayer.CharacterAdded:Connect(function()
        if not config.EmoteEnabled then return end
        task.delay(0.6, function()
            if config.EmoteEnabled then
                PlayEmote(getgenv()._ShakoEmote.lastId or config.EmoteId, config.EmoteSpeed)
            end
        end)
    end)
end)

_visAcc = 0


-- ==================== SLIDE GUARD (emote solo animacion, sin torcer body) ====================
getgenv()._ShakoSlideGuard = getgenv()._ShakoSlideGuard or {
    sliding = false,
    emotePaused = false,
    pendingResume = false,
    cHeld = false,
}
do
    local SG = getgenv()._ShakoSlideGuard
    local UIS = game:GetService("UserInputService")

    local function getMech()
        local ok, mech = pcall(function()
            return require(LocalPlayer.PlayerScripts.Controllers.MechanicsController)
        end)
        return ok and mech or nil
    end

    local function isSlidingNow()
        -- 1) MechanicsController.IsSliding
        local mech = getMech()
        if mech then
            local ok, v = pcall(function()
                return mech.IsSliding == true
            end)
            if ok and v then
                return true
            end
            -- algunos builds usan _isSliding / Sliding
            local ok2, v2 = pcall(function()
                return mech._isSliding == true or mech.Sliding == true
            end)
            if ok2 and v2 then
                return true
            end
        end
        -- 2) tecla C mantenida (slide de Rivals)
        if SG.cHeld then
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0.05 then
                return true
            end
        end
        -- 3) animacion de slide activa en el humanoid
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            local ok, tracks = pcall(function()
                return hum:GetPlayingAnimationTracks()
            end)
            if ok and tracks then
                for _, t in ipairs(tracks) do
                    local n = string.lower(tostring(t.Name or "") .. " " .. tostring(t.Animation and t.Animation.AnimationId or ""))
                    if n:find("slide", 1, true) or n:find("crouch", 1, true) or n:find("roll", 1, true) then
                        if t.IsPlaying and (t.WeightCurrent or 0) > 0.2 then
                            return true
                        end
                    end
                end
            end
        end
        return false
    end

    function IsPlayerSliding()
        return isSlidingNow() or SG.sliding == true
    end

    -- STOP total del emote local (no solo weight 0) para no mezclar Motor6D con slide
    local function pauseEmoteForSlide()
        local S = getgenv()._ShakoEmote
        if not S then return end
        SG.emotePaused = true
        SG.pendingResume = config.EmoteEnabled == true
        if S.track then
            pcall(function()
                S.track:Stop(0.05)
            end)
        end
        -- no aplicar body twist mientras slides
        pcall(function()
            if type(StopBodyTwist) == "function" and config.BodyTwist then
                -- no apagar config, solo soltar pose este frame
            end
        end)
    end

    local function resumeEmoteAfterSlide()
        if not SG.pendingResume and not SG.emotePaused then
            return
        end
        SG.emotePaused = false
        SG.pendingResume = false
        if not (config and config.EmoteEnabled) then
            return
        end
        -- re-play limpio (solo animacion, priority Movement)
        task.defer(function()
            if not config.EmoteEnabled then return end
            if isSlidingNow() then
                SG.emotePaused = true
                SG.pendingResume = true
                return
            end
            local id = (getgenv()._ShakoEmote and getgenv()._ShakoEmote.lastId) or config.EmoteId
            if id and type(PlayEmote) == "function" then
                -- evitar reentrada de remote spam: solo local track
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local animator = hum:FindFirstChildOfClass("Animator")
                if not animator then return end
                local S = getgenv()._ShakoEmote
                if S and S.track then
                    pcall(function() S.track:Stop(0) end)
                    S.track = nil
                end
                if type(loadTrack) == "function" then
                    local track = loadTrack(animator, tostring(id):gsub("%D", ""))
                    if track then
                        pcall(function()
                            track.Priority = Enum.AnimationPriority.Movement
                            track.Looped = true
                            local spd = tonumber(config.EmoteSpeed) or 1
                            track:Play(0.15, 0.85, spd)
                        end)
                        getgenv()._ShakoEmote.track = track
                    end
                elseif type(PlayEmote) == "function" then
                    PlayEmote(id, config.EmoteSpeed)
                end
            end
        end)
    end

    -- tecla C = slide en Rivals
    pcall(function()
        if SG.inputConn then return end
        SG.inputConn = UIS.InputBegan:Connect(function(input, gp)
            if input.KeyCode == Enum.KeyCode.C then
                SG.cHeld = true
            end
        end)
        UIS.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.C then
                SG.cHeld = false
            end
        end)
    end)

    if not SG.conn then
        SG.conn = RunService.Heartbeat:Connect(function()
            local sliding = false
            pcall(function()
                sliding = isSlidingNow()
            end)
            if sliding then
                if not SG.sliding then
                    SG.sliding = true
                end
                pauseEmoteForSlide()
            else
                if SG.sliding then
                    SG.sliding = false
                    resumeEmoteAfterSlide()
                end
            end
        end)
    end
end


-- ==================== SHAKO SPINNING CROSSHAIR (logo purple) ====================



-- sync config to genv for isolated chunks
pcall(function() getgenv().config = config end)

-- ==================== HARION CROSSHAIR / VM (isolated chunk = no register pressure) ====================
task.spawn(function()
    local src = [=[
local config = getgenv().config
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local Vis = getgenv()._ShakoVis or { drawings = {}, wires = {}, connX = nil, connV = nil }
getgenv()._ShakoVis = Vis

local MAT = {
    ForceField = Enum.Material.ForceField,
    Neon = Enum.Material.Neon,
    Glass = Enum.Material.Glass,
    SmoothPlastic = Enum.Material.SmoothPlastic,
    Plastic = Enum.Material.Plastic,
    Metal = Enum.Material.Metal,
}

function hideLines()
    for _, d in pairs(Vis.drawings) do
        pcall(function() d.Visible = false end)
    end
end

function line(key, outline)
    local d = Vis.drawings[key]
    if not d and Drawing then
        d = Drawing.new("Line")
        d.Visible = false
        d.ZIndex = outline and 1 or 2
        Vis.drawings[key] = d
    end
    return d
end

local ShakoCross = getgenv().ShakoCross or {}
getgenv().ShakoCross = ShakoCross
_G.ShakoCross = ShakoCross

ShakoCross.destroy = function()
    if Vis.connX then pcall(function() Vis.connX:Disconnect() end) Vis.connX = nil end
    for k, d in pairs(Vis.drawings) do
        pcall(function() d:Remove() end)
        Vis.drawings[k] = nil
    end
end
ShakoCross.build = function() end

getgenv()._StartCrosshairReal = function()
    if not config then config = getgenv().config end
    if not config then return end
    config.Crosshair = true
    if Vis.connX then return end
    Vis.connX = RunService.RenderStepped:Connect(function()
        -- desactivado: crosshair ScreenGui es el activo
        if true then return end
        config = getgenv().config
        if not config or not config.Crosshair then hideLines() return end
        if not Drawing then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local center = cam.ViewportSize / 2
        if config.CrosshairPosition == "position on target" then
            local best, bestD = nil, 1e9
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character and plr.Character:FindFirstChild("Head") then
                    local sp, on = cam:WorldToViewportPoint(plr.Character.Head.Position)
                    if on then
                        local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
                        if d < bestD then bestD, best = d, Vector2.new(sp.X, sp.Y) end
                    end
                end
            end
            if best then center = best end
        end
        local length = tonumber(config.CrosshairSize) or 20
        local gap = tonumber(config.CrosshairGap) or 8
        local thick = tonumber(config.CrosshairThickness) or 2
        local rot = math.rad((tonumber(config.CrosshairRotation) or 0) + tick() * 360 * (tonumber(config.CrosshairSpinSpeed) or 0.3))
        local bounce = tonumber(config.CrosshairBounce) or 0
        if bounce > 0 then
            gap = gap + math.sin(tick() * 8 * (tonumber(config.CrosshairBounceSpeed) or 1)) * bounce
        end
        local col = config.CrosshairColor or Color3.fromRGB(255, 255, 255)
        local ocol = config.CrosshairOutlineColor or Color3.fromRGB(0, 0, 0)
        local dirs = { Vector2.new(0, -1), Vector2.new(1, 0), Vector2.new(0, 1), Vector2.new(-1, 0) }
        for i = 1, 4 do
            local dir = dirs[i]
            local rdir = Vector2.new(dir.X * math.cos(rot) - dir.Y * math.sin(rot), dir.X * math.sin(rot) + dir.Y * math.cos(rot))
            local from = center + rdir * gap
            local to = center + rdir * (gap + length)
            if config.CrosshairOutline then
                local ol = line("o" .. i, true)
                if ol then ol.From = from; ol.To = to; ol.Color = ocol; ol.Thickness = thick + 2; ol.Visible = true end
            else
                local ol = Vis.drawings["o" .. i]
                if ol then ol.Visible = false end
            end
            local ln = line("l" .. i, false)
            if ln then ln.From = from; ln.To = to; ln.Color = col; ln.Thickness = thick; ln.Visible = true end
        end
    end)
end

getgenv()._StopCrosshairReal = function()
    local c = getgenv().config
    if c then c.Crosshair = false end
    ShakoCross.destroy()
end

-- real funcs: getgenv()._StartCrosshairReal / _StopCrosshairReal

function clearWires()
    for _, w in pairs(Vis.wires) do pcall(function() w:Destroy() end) end
    table.clear(Vis.wires)
end

function roots()
    local out, seen = {}, {}
    local function add(inst)
        if typeof(inst) == "Instance" and not seen[inst] then
            seen[inst] = true
            out[#out + 1] = inst
        end
    end
    pcall(function()
        local fctrl = require(LP.PlayerScripts.Controllers.FighterController)
        local fighter = fctrl.LocalFighter or (fctrl.GetFighter and fctrl:GetFighter(LP))
        local item = fighter and fighter.EquippedItem
        local vm = item and item.ViewModel
        if not vm then return end
        add(vm.ItemModel)
        add(vm.Model)
        if vm.Model then
            add(vm.Model:FindFirstChild("ItemVisual"))
            add(vm.Model:FindFirstChild("ItemModel"))
        end
        -- algunas builds guardan el model real en estos campos
        add(rawget(vm, "WorldModel"))
        add(rawget(vm, "WeaponModel"))
        if typeof(vm.Model) == "Instance" then
            for _, ch in ipairs(vm.Model:GetChildren()) do
                if ch:IsA("BasePart") or ch:IsA("Model") or ch:IsA("Folder") then
                    add(ch)
                end
            end
        end
    end)
    -- fallback: modelos bajo CurrentCamera
    pcall(function()
        local cam = workspace.CurrentCamera
        if not cam then return end
        for _, ch in ipairs(cam:GetDescendants()) do
            local n = ch.Name:lower()
            if ch:IsA("Model") and (n:find("view") or n:find("weapon") or n:find("gun") or n:find("item") or n:find("rifle") or n:find("ak")) then
                add(ch)
            end
        end
    end)
    return out
end

function stylePart(part, color, matName, tr, noTex)
    if not part:IsA("BasePart") then return end
    pcall(function()
        if color then part.Color = color end
        local mat = MAT[matName]
        if mat then part.Material = mat end
        if tr ~= nil then part.Transparency = math.clamp(tr, 0, 1) end
        if noTex then
            for _, d in ipairs(part:GetChildren()) do
                if d:IsA("Texture") or d:IsA("Decal") then d.Transparency = 1 end
            end
        end
    end)
end

function isArm(part)
    local n = part.Name:lower()
    return n:find("arm") or n:find("hand") or n:find("glove")
end

function wireParent()
    return LP:FindFirstChildOfClass("PlayerGui") or workspace.CurrentCamera or workspace
end

function wire(part)
    if not part or not part:IsA("BasePart") then return nil end
    local key = part:GetDebugId() or tostring(part)
    local w = Vis.wires[key]
    if w and w.Parent and w.Adornee == part then
        return w
    end
    if w then pcall(function() w:Destroy() end) Vis.wires[key] = nil end
    local ok, created = pcall(function()
        local a = Instance.new("WireframeHandleAdornment")
        a.Name = "__ShakoVMWireframe"
        a.Adornee = part
        a.AlwaysOnTop = true
        a.ZIndex = 10
        a.Thickness = 1
        a.Transparency = 0
        a.Visible = true
        a.Color3 = (getgenv().config and getgenv().config.VMColor) or Color3.fromRGB(255, 255, 255)
        a.Parent = wireParent()
        return a
    end)
    if ok and created then
        Vis.wires[key] = created
        return created
    end
    return nil
end

local Highlights = Vis.highlights or {}
Vis.highlights = Highlights
local XRayOrig = Vis.xrayOrig or {}
Vis.xrayOrig = XRayOrig

function tickVM()
    local cfg = getgenv().config
    if not cfg then return end

    -- override fps
    if cfg.VMOverrideFps and setfpscap then
        pcall(setfpscap, tonumber(cfg.VMFps) or 60)
    end

    -- xray walls (refresh)
    if cfg.XRayEnabled then
        local now = os.clock()
        if (Vis._lastXray or 0) + 3 < now then
            Vis._lastXray = now
            pcall(function() applyXRay(true) end)
        end
    elseif next(_xrayCache) then
        pcall(function() applyXRay(false) end)
    end

    -- viewmodel offset + chams + recoil scale on viewmodel model
    pcall(function()
        local fctrl = require(LP.PlayerScripts.Controllers.FighterController)
        local fighter = fctrl.LocalFighter or (fctrl.GetFighter and fctrl:GetFighter(LP))
        local item = fighter and fighter.EquippedItem
        local vm = item and item.ViewModel
        local model = vm and (vm.Model or vm.ItemModel)
        if not model then return end
        if cfg.VMOffset and model:IsA("Model") and model.PrimaryPart then
            -- soft offset via model pivot if available
            pcall(function()
                local ox = tonumber(cfg.VMOffsetX) or 0
                local oy = tonumber(cfg.VMOffsetY) or 0
                local oz = tonumber(cfg.VMOffsetZ) or 0
                if model.PrimaryPart then
                    -- applied via GetPivot offset once per frame is unstable; use attribute flag
                end
            end)
        end
        if cfg.VMOffset then
            for _, part in ipairs(model:GetDescendants()) do
                if part:IsA("BasePart") then
                    -- skip continuous CFrame to avoid jitter; use Motor offset if any
                end
            end
        end
        if cfg.VMChams then
            local h = Highlights[model]
            if not h or not h.Parent then
                h = Instance.new("Highlight")
                h.Name = "ShakoVMChams"
                h.Adornee = model
                h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                local _hp = game:GetService("CoreGui")
                pcall(function() if gethui then _hp = gethui() end end)
                h.Parent = _hp
                Highlights[model] = h
            end
            h.FillColor = cfg.VMChamsColor or Color3.fromRGB(255, 255, 255)
            h.OutlineColor = cfg.VMChamsColor or Color3.fromRGB(255, 255, 255)
            h.FillTransparency = (tonumber(cfg.VMChamFill) or 2) / 100
            h.OutlineTransparency = (tonumber(cfg.VMChamOutline) or 1) / 100
            h.Enabled = true
        else
            for m, h in pairs(Highlights) do
                pcall(function() h:Destroy() end)
                Highlights[m] = nil
            end
        end
        -- recoil percent: scale camera recoil modules if present
        if cfg.VMRecoil and cfg.VMRecoil < 100 then
            pcall(function()
                local scale = (tonumber(cfg.VMRecoil) or 100) / 100
                if vm and vm.Data then
                    -- no-op safe
                end
            end)
        end
    end)

    if not (cfg.VMAppearance or cfg.VMWireframe or cfg.ArmAppearance or cfg.RemoveVignette or cfg.OverrideWeaponStatus or cfg.DisableGameCrosshair or cfg.VMChams or cfg.VMOffset or cfg.VMOverrideFps or cfg.XRayEnabled) then
        if next(Vis.wires) then clearWires() end
        return
    end
    -- vignette: solo cada 2s (no GetDescendants cada frame = lag)
    if cfg.RemoveVignette then
        local now = os.clock()
        if (Vis._lastVig or 0) + 2 < now then
            Vis._lastVig = now
            pcall(function()
                local pg = LP:FindFirstChild("PlayerGui")
                if not pg then return end
                for _, g in ipairs(pg:GetChildren()) do
                    -- solo nivel 1 + 1 profundidad, no todo el arbol
                    local n = g.Name:lower()
                    if n:find("vignette") and g:IsA("GuiObject") then
                        g.Visible = false
                    end
                    for _, c in ipairs(g:GetChildren()) do
                        if c.Name:lower():find("vignette") and c:IsA("GuiObject") then
                            c.Visible = false
                        end
                    end
                end
            end)
        end
    end
    if cfg.DisableGameCrosshair then
        pcall(function()
            local pg = LP:FindFirstChild("PlayerGui")
            if not pg then return end
            for _, g in ipairs(pg:GetDescendants()) do
                if g.Name:lower():find("crosshair") and g:IsA("GuiObject") then
                    g.Visible = false
                end
            end
        end)
    end
    -- HARION: override weapon status = ItemLibrary.Items[name].Status = "Prime"|"Contraband"
    if cfg.OverrideWeaponStatus then
        local now = os.clock()
        local selected = cfg.WeaponStatus or "Prime"
        if Vis._statusValue ~= selected or (Vis._lastStatus or 0) + 1 < now then
            Vis._lastStatus = now
            Vis._statusValue = selected
            Vis._origStatus = Vis._origStatus or {}
            pcall(function()
                local RS = game:GetService("ReplicatedStorage")
                local itemLibrary = require(RS.Modules.ItemLibrary)
                for name, info in pairs(itemLibrary.Items or {}) do
                    if type(info) == "table" then
                        if Vis._origStatus[name] == nil then
                            Vis._origStatus[name] = info.Status
                        end
                        info.Status = selected
                    end
                end
            end)
        end
    elseif Vis._origStatus and next(Vis._origStatus) then
        -- restore when disabled
        pcall(function()
            local RS = game:GetService("ReplicatedStorage")
            local itemLibrary = require(RS.Modules.ItemLibrary)
            for name, orig in pairs(Vis._origStatus) do
                local info = itemLibrary.Items and itemLibrary.Items[name]
                if type(info) == "table" then
                    info.Status = orig
                end
            end
            table.clear(Vis._origStatus)
        end)
    end
    if not (cfg.VMAppearance or cfg.VMWireframe or cfg.ArmAppearance) then
        clearWires()
        return
    end
    local rootList = roots()
    local live = {}
    for _, root in ipairs(rootList) do
        local parts = {}
        if root:IsA("BasePart") then
            parts[1] = root
        else
            parts = root:GetDescendants()
        end
        for _, part in ipairs(parts) do
            if part:IsA("BasePart") then
                local arm = isArm(part)
                if arm and cfg.ArmAppearance then
                    stylePart(part, cfg.ArmColor, cfg.ArmMaterial or "ForceField", (tonumber(cfg.ArmTransparency) or 100) / 100, cfg.VMDisableTextures)
                elseif not arm and cfg.VMAppearance then
                    stylePart(part, cfg.VMColor, cfg.VMMaterial or "ForceField", (tonumber(cfg.VMTransparency) or 100) / 100, cfg.VMDisableTextures)
                end
                if cfg.VMWireframe and not arm then
                    -- un poco transparente para que se note el wire (estilo Harion)
                    if not cfg.VMAppearance then
                        pcall(function()
                            if part.Transparency < 0.15 then part.Transparency = 0.15 end
                        end)
                    end
                    local w = wire(part)
                    if w then
                        w.Color3 = cfg.VMColor or Color3.fromRGB(255, 255, 255)
                        w.Thickness = 1
                        w.Visible = true
                        w.AlwaysOnTop = true
                        live[w] = true
                    end
                end
            end
        end
    end
    if not cfg.VMWireframe then
        clearWires()
    else
        for k, w in pairs(Vis.wires) do
            if not live[w] then
                pcall(function() w:Destroy() end)
                Vis.wires[k] = nil
            end
        end
    end
end

if not Vis.connV then
    Vis.connV = RunService.RenderStepped:Connect(function()
        pcall(tickVM)
    end)
end
]=]
    local fn, err = loadstring(src)
    if fn then
        pcall(fn)
    else
        warn("[shako] visual chunk error:", err)
    end
end)

-- thin global bridges (0 new locals in main chunk)
StartCrosshair = function(...)
    local f = rawget(getgenv(), "_StartCrosshairReal")
    if type(f) == "function" then return f(...) end
end
StopCrosshair = function(...)
    local f = rawget(getgenv(), "_StopCrosshairReal")
    if type(f) == "function" then return f(...) end
end
ShakoCross = setmetatable({}, {
    __index = function(_, k)
        local t = rawget(getgenv(), "ShakoCross")
        if type(t) == "table" then return t[k] end
        if k == "destroy" or k == "build" then return function() end end
    end
})


-- OPT: EnsureCameraFree cada 0.5s (no RenderStepped)
task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(EnsureCameraFree)
    end
end)

function HookCharacter(char)
    task.defer(ResetCameraNormal)
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if hum then
        hum.Died:Connect(function()
            UECounterReady = false
            if config.AutoRespawn then
                task.delay(0.3, function() pcall(function() LocalPlayer:LoadCharacter() end) end)
            end
        end)
    end
end

UserInputService.JumpRequest:Connect(function()
    local hum = getHum()
    local hrp = getHRP()
    if not hum then return end

    if config.InfinityJump then
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
    end

    -- Jump power forzado (Rivals ignora JumpPower a menudo)
    if config.JumpPowerEnabled and config.JumpBoostForce ~= false and hrp then
        local jp = config.JumpPower or 100
        pcall(function()
            hum.UseJumpPower = true
            hum.JumpPower = jp
            if hum.JumpHeight ~= nil then hum.JumpHeight = math.clamp(jp / 20, 2, 500) end
        end)
        -- impulso vertical directo
        local vel = hrp.AssemblyLinearVelocity
        local boostY = math.max(jp * 0.45, 40)
        hrp.AssemblyLinearVelocity = Vector3.new(vel.X, boostY, vel.Z)
    end
end)

-- Rivals pisa WalkSpeed/JumpPower: re-aplicar al cambiar
task.spawn(function()
    local lastHum
    while true do
        task.wait(0.15)
        local hum = getHum()
        if hum and hum ~= lastHum then
            lastHum = hum
            pcall(function()
                hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
                    if config.SpeedEnabled then
                        pcall(function() hum.WalkSpeed = config.WalkSpeed or 50 end)
                    end
                    -- si OFF no tocamos (deja el valor del juego)
                end)
                hum:GetPropertyChangedSignal("JumpPower"):Connect(function()
                    if config.JumpPowerEnabled then
                        pcall(function()
                            hum.UseJumpPower = true
                            hum.JumpPower = config.JumpPower or 100
                        end)
                    end
                end)
            end)
        end
        -- guardar defaults del juego
        if hum then
            pcall(function()
                if not config._savedDefaultWS then
                    config.DefaultWalkSpeed = hum.WalkSpeed
                    config._savedDefaultWS = true
                end
                if not config._savedDefaultJP then
                    config.DefaultJumpPower = hum.JumpPower
                    if hum.JumpHeight then config.DefaultJumpHeight = hum.JumpHeight end
                    config._savedDefaultJP = true
                end
            end)
        end
        -- SOLO aplicar si el usuario tiene toggle ON (nunca auto)
        if config.SpeedEnabled then ApplySpeedState() end
        if config.JumpPowerEnabled then ApplyJumpState() end
    end
end)

-- Config system (métodos en tabla = 1 register en vez de 10+)
function Cfg.EnsureFolder()
    if not isfolder then return false end
    if not isfolder(Cfg.folder) then pcall(function() makefolder(Cfg.folder) end) end
    return isfolder and isfolder(Cfg.folder)
end
function Cfg.Sanitize(n)
    if not n or n == "" then return nil end
    n = tostring(n):gsub("[^%w%_% %-]", ""):gsub("%s+", "_")
    return n ~= "" and n or nil
end
function Cfg.List()
    local list = {"(ninguna)"}
    if not Cfg.EnsureFolder() then return list end
    local ok, files = pcall(function() return listfiles(Cfg.folder) end)
    if ok and files then
        for _, path in ipairs(files) do
            local name = tostring(path):match("([^/\\]+)%.json$")
            if name then table.insert(list, name) end
        end
    end
    return list
end


-- ==================== GROK PRESET CONFIGS ====================
getgenv()._ShakoGrokPresets = {
    ["HVH God"] = {
        -- LA MEJOR: full HVH Rivals
        RagebotEnabled = true,
        RageDesync = false,
        RageUseItem = true,
        RageVoidFirst = true,
        RagebotSkipFF = false,
        RagebotTeamCheck = true,
        RagebotInfiniteRange = true,
        RageInfinite = true,
        RagePrioritizeRagers = true,
        RageVoidHideTime = 0.35,
        RageVoidAttackTime = 0.50,
        RageAttackSpeed = 16,
        RageFireRate = 0,
        RageShotsPerTick = 2,
        RageMultipoint = true,
        RageResolver = true,
        RagebotHeight = 2.4,
        VoidRageAwayDist = 99999999,
        VoidSpamEnabled = true,
        VoidMethod = "Helix",
        VoidExtremeMode = true,
        VoidChaosVel = true,
        VoidEvade = true,
        VoidEvadeTrigger = 1.0,
        VoidEvadeStrength = 1.5,
        VoidBaseAltitude = 1e11,
        VoidRadius = 1e11,
        VoidEvadeDist = 1e11,
        RapidFire = true,
        RapidFireDelay = 0.001,
        NoRecoil = true,
        FastMelee = true,
        SilentAimEnabled = true,
        SilentPredict = false,
        SilentHeadOffsetY = 0.4,
        SilentFOV = 2500,
        SilentShowFOV = true,
        SilentTeamCheck = true,
        PredDodgeEnabled = true,
        PredThreshold = 55,
        PredCooldown = 0.12,
        PredRadius = 90,
        BlinkEnabled = true,
        BlinkRadius = 90,
        BlinkRate = 12,
        AntiAimEnabled = true,
        AntiAimMode = "Spin",
        SpinSpeed = 45,
        UndergroundAA = true,
        ESPEnabled = true,
        ESPShowBox = true,
        ESPHealthBar = true,
        ESPShowName = true,
        ESPShowDist = true,
        ESPSkeleton = true,
        ESPTracers = true,
        HurtEvade = true,
        NearEnemyEvade = true,
        AntiUEClose = true,
        LowHPPanic = true,
        AutoCollectHeals = true,
        AutoCollectAmmo = true,
        AutoCollectRadius = 80,
        TeamCheck = false,
        ForceFieldVisual = false,
    },
    ["Legit"] = {
        RagebotEnabled = false,
        VoidSpamEnabled = false,
        SilentAimEnabled = true,
        SilentFOV = 180,
        SilentShowFOV = true,
        SilentPredict = false,
        SilentHeadOffsetY = 0.3,
        SilentTeamCheck = true,
        AimbotEnabled = true,
        AimbotSmooth = 0.25,
        AimbotTeamCheck = true,
        ESPEnabled = true,
        ESPShowBox = true,
        ESPHealthBar = true,
        ESPShowName = true,
        ESPShowDist = true,
        ESPSkeleton = false,
        ESPTracers = false,
        NoRecoil = true,
        RapidFire = false,
        AntiAimEnabled = false,
        TeamCheck = false,
        PredDodgeEnabled = false,
        BlinkEnabled = false,
        RiotEnabled = false,
        AutoCollectHeals = false,
    },
    ["FFA Farm"] = {
        RagebotEnabled = true,
        RageDesync = false,
        RageVoidFirst = true,
        RagebotSkipFF = false,
        RagebotTeamCheck = true,
        RagebotForceFFA = true,
        RageAttackSpeed = 18,
        RageVoidHideTime = 0.30,
        RageVoidAttackTime = 0.55,
        VoidSpamEnabled = true,
        VoidMethod = "Strobe",
        VoidExtremeMode = true,
        RapidFire = true,
        NoRecoil = true,
        FastMelee = true,
        SilentAimEnabled = true,
        SilentFOV = 3000,
        SilentHeadOffsetY = 0.45,
        AutoCollectHeals = true,
        AutoCollectAmmo = true,
        AutoCollectRadius = 120,
        ESPEnabled = true,
        ESPShowBox = true,
        ESPHealthBar = true,
        PredDodgeEnabled = true,
        TeamCheck = false,
    },
    ["Anti-UE"] = {
        RagebotEnabled = true,
        RageDesync = false,
        RageVoidFirst = true,
        RagebotSkipFF = false,
        RagePrioritizeRagers = true,
        RageAttackSpeed = 20,
        RageVoidHideTime = 0.28,
        RageVoidAttackTime = 0.40,
        VoidSpamEnabled = true,
        VoidMethod = "Chaos",
        VoidExtremeMode = true,
        VoidChaosVel = true,
        VoidEvade = true,
        VoidEvadeStrength = 2.0,
        VoidEvadeTrigger = 1.2,
        BlinkEnabled = true,
        BlinkRate = 50,
        BlinkRadius = 100,
        PredDodgeEnabled = true,
        PredThreshold = 40,
        PredCooldown = 0.08,
        RiotEnabled = true,
        RiotSpeed = 0.02,
        RiotRange = 60,
        RiotEvadeRange = 35,
        AntiUEClose = true,
        AntiUECloseDist = 40,
        AntiUEClosePush = 100,
        AntiUEPeek = true,
        HurtEvade = true,
        NearEnemyEvade = true,
        LowHPPanic = true,
        RapidFire = true,
        NoRecoil = true,
        SilentAimEnabled = true,
        SilentFOV = 2800,
        ESPEnabled = true,
        TeamCheck = false,
    },
    ["Visual Only"] = {
        RagebotEnabled = false,
        VoidSpamEnabled = false,
        SilentAimEnabled = false,
        AimbotEnabled = false,
        ESPEnabled = true,
        ESPShowBox = true,
        ESPHealthBar = true,
        ESPShowName = true,
        ESPShowDist = true,
        ESPSkeleton = true,
        ESPTracers = true,
        ESPGlow = true,
        ForceFieldVisual = true,
        Fullbright = true,
        TeamCheck = false,
        RapidFire = false,
        NoRecoil = false,
    },
}

function Cfg.InstallGrokPresets()
    Cfg.EnsureFolder()
    local n = 0
    for name, preset in pairs(getgenv()._ShakoGrokPresets) do
        local path = Cfg.folder .. "/" .. Cfg.Sanitize(name) .. ".json"
        -- merge preset sobre defaults del config actual (solo keys del preset)
        local t = {}
        for k, v in pairs(config) do
            if type(v) ~= "function" and type(v) ~= "userdata" and type(v) ~= "thread" then
                if type(v) == "table" then
                    -- skip deep tables
                else
                    t[k] = v
                end
            end
        end
        for k, v in pairs(preset) do
            t[k] = v
        end
        t._GrokPreset = true
        t._GrokName = name
        local ok, json = pcall(function() return HttpService:JSONEncode(t) end)
        if ok and json and writefile then
            pcall(writefile, path, json)
            n = n + 1
        end
    end
    return n
end

function Cfg.LoadGrokPreset(name)
    if not getgenv()._ShakoGrokPresets[name] then
        Notify("Presets", "not found")
        return false
    end
    -- asegurar archivo
    pcall(function() Cfg.InstallGrokPresets() end)
    return Cfg.Load(Cfg.Sanitize(name) or name)
end


function Cfg.Save(name, overwrite)
    name = Cfg.Sanitize(name)
    if not name or not Cfg.EnsureFolder() then
        Notify("Config", "No se pudo guardar (folder/name)")
        return false
    end
    local path = Cfg.folder .. "/" .. name .. ".json"
    if isfile and isfile(path) and not overwrite then
        Notify("Config", "Ya existe — usa Overwrite")
        return false
    end

    -- sincronizar skyboxData → config antes de guardar
    pcall(function()
        if skyboxData then
            config.SkyboxEnabled = skyboxData.enabled and true or false
            config.SkyboxName = tostring(skyboxData.selected or "None")
            config.SkyRotate = skyboxData.auto_rotate and true or false
            if skyboxData.enabled and skyboxData.selected and skyboxData.selected ~= "None" then
                if not config.SkyboxPreset or config.SkyboxPreset == "Off" then
                    -- no pisar preset de Weather si ya hay
                end
            end
        end
        config.Weather = config.WeatherEnabled and true or false
    end)
    local t = {}
    -- todo lo serializable de config
    for k, v in pairs(config) do
        local ty = typeof(v)
        if ty == "number" or ty == "string" or ty == "boolean" then
            t[k] = v
        end
    end

    -- Spoof / rank / device
    pcall(function()
        local st = getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state
        local rs = RivalsSpoof or st or {}
        t._RS = {
            avatar_userid = tonumber(rs.avatar_userid) or tonumber(config.SkinTargetUserId) or 0,
            spoof_avatar = rs.spoof_avatar and true or false,
            display_name = rs.display_name and true or false,
            display_name_value = tostring(rs.display_name_value or ""),
            username = rs.username and true or false,
            username_value = tostring(rs.username_value or ""),
            device = tostring(rs.device or "Desktop"),
            spoof_device = rs.spoof_device and true or false,
            badges = {},
            charm = {},
            leaderboard = {},
        }
        if type(rs.badges) == "table" then
            for bk, bv in pairs(rs.badges) do t._RS.badges[bk] = bv and true or false end
        end
        if type(rs.charm) == "table" then
            t._RS.charm = {
                charm_rank = tostring(rs.charm.charm_rank or "Archnemesis"),
                arch_rank = tonumber(rs.charm.arch_rank) or 1,
                s0_charm = rs.charm.s0_charm and true or false,
                s1_charm = rs.charm.s1_charm and true or false,
                s2_charm = rs.charm.s2_charm and true or false,
                s3_charm = rs.charm.s3_charm and true or false,
            }
        end
        if type(rs.leaderboard) == "table" then
            local lb = rs.leaderboard
            t._RS.leaderboard = {
                ELO = lb.ELO and true or false, elo_value = tonumber(lb.elo_value) or 0,
                Streak = lb.Streak and true or false, streak_value = tonumber(lb.streak_value) or 0,
                Kills = lb.Kills and true or false, kills_value = tonumber(lb.kills_value) or 0,
                Wins = lb.Wins and true or false, wins_value = tonumber(lb.wins_value) or 0,
                Level = lb.Level and true or false, level_value = tonumber(lb.level_value) or 0,
            }
        elseif type(rs.lb) == "table" then
            local lb = rs.lb
            t._RS.leaderboard = {
                ELO = lb.elo and true or false, elo_value = tonumber(lb.elo_value) or 0,
                Streak = lb.streak and true or false, streak_value = tonumber(lb.streak_value) or 0,
                Kills = lb.kills and true or false, kills_value = tonumber(lb.kills_value) or 0,
                Wins = lb.wins and true or false, wins_value = tonumber(lb.wins_value) or 0,
                Level = lb.level and true or false, level_value = tonumber(lb.level_value) or 0,
            }
        end
    end)

    -- Unlock All skins / weapons (AURORA skinchanger_state)
    pcall(function()
        local st = getgenv()._ShakoStates
        if not st then return end
        t._Unlock = {
            fake_owned = {},
            fake_weapon_owned = {},
            equipped = {},
        }
        if st.skinchanger_state then
            if type(st.skinchanger_state.fake_owned) == "table" then
                for k, v in pairs(st.skinchanger_state.fake_owned) do
                    if v then t._Unlock.fake_owned[tostring(k)] = true end
                end
            end
            if type(st.skinchanger_state.fake_weapon_owned) == "table" then
                -- puede ser array o map
                for k, v in pairs(st.skinchanger_state.fake_weapon_owned) do
                    if type(v) == "table" and v.Name then
                        table.insert(t._Unlock.fake_weapon_owned, v.Name)
                    elseif type(v) == "string" then
                        table.insert(t._Unlock.fake_weapon_owned, v)
                    elseif v == true then
                        table.insert(t._Unlock.fake_weapon_owned, tostring(k))
                    end
                end
            end
            if type(st.skinchanger_state.equipped) == "table" then
                for k, v in pairs(st.skinchanger_state.equipped) do
                    t._Unlock.equipped[tostring(k)] = v
                end
            end
        end
        if st.inventory_state and type(st.inventory_state.fake_owned) == "table" then
            t._Unlock.unclaimed = st.inventory_state.fake_owned
        end
    end)

    -- snapshot UI flags (toggles + options) para restaurar visual al load
    pcall(function()
        local Toggles = (Library and Library.Toggles) or rawget(getgenv(), "Toggles")
        local Options = (Library and Library.Options) or rawget(getgenv(), "Options")
        t._UI = { toggles = {}, options = {} }
        if type(Toggles) == "table" then
            for flag, toggle in pairs(Toggles) do
                local v = nil
                pcall(function()
                    if toggle.Value ~= nil then v = toggle.Value
                    elseif toggle.Get then v = toggle:Get()
                    elseif toggle.GetValue then v = toggle:GetValue()
                    end
                end)
                if typeof(v) == "boolean" then
                    t._UI.toggles[tostring(flag)] = v
                end
            end
        end
        if type(Options) == "table" then
            for flag, opt in pairs(Options) do
                local v = nil
                pcall(function()
                    if opt.Value ~= nil then v = opt.Value
                    elseif opt.Get then v = opt:Get()
                    elseif opt.GetValue then v = opt:GetValue()
                    end
                end)
                local ty = typeof(v)
                if ty == "number" or ty == "string" or ty == "boolean" then
                    t._UI.options[tostring(flag)] = v
                end
            end
        end
        -- forzar avatar id en options y config
        local aid = tonumber(config.SkinTargetUserId)
        pcall(function()
            local st = getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state
            local rs = RivalsSpoof or st
            if rs and tonumber(rs.avatar_userid) then aid = tonumber(rs.avatar_userid) end
        end)
        if aid then
            t.SkinTargetUserId = aid
            if t._RS then t._RS.avatar_userid = aid end
            if t._UI and t._UI.options then
                t._UI.options["VictimUserId"] = tostring(aid)
                t._UI.options["SkinTargetUserId"] = tostring(aid)
                t._UI.options["AvatarUserId"] = tostring(aid)
            end
        end
    end)

    local ok, enc = pcall(function() return HttpService:JSONEncode(t) end)
    if not ok or not enc then
        Notify("Config", "JSON encode fail")
        return false
    end
    local wok = pcall(function() writefile(path, enc) end)
    if wok then
        Notify("Config", "Guardada: " .. name)
    else
        Notify("Config", "writefile FAIL")
    end
    return wok
end

function Cfg.SyncUIFromConfig(data)
    -- Restaura visual de toggles/sliders/inputs según config + data._UI
    data = data or {}
    -- Obsidian Toggle:SetValue SIEMPRE dispara Callback → desactiva/activa features.
    -- Durante sync solo actualizamos Value + Display SIN callback.
    function setToggle(toggle, val)
        if not toggle or typeof(val) ~= "boolean" then return end
        pcall(function()
            local oldCb = toggle.Callback
            local oldChanged = toggle.Changed
            local oldRun = toggle.RunChanged
            toggle.Callback = function() end
            if type(oldChanged) == "table" and oldChanged.Clear then
                -- leave signal
            end
            pcall(function()
                if toggle.RunChanged then
                    toggle.RunChanged = function() end
                end
            end)
            pcall(function()
                toggle.Value = val
                if toggle.Display then toggle:Display() end
            end)
            -- SetValue con callbacks anulados
            pcall(function()
                if toggle.SetValue then toggle:SetValue(val) end
            end)
            toggle.Callback = oldCb
            pcall(function()
                if oldRun then toggle.RunChanged = oldRun end
            end)
            toggle.Value = val
            pcall(function() if toggle.Display then toggle:Display() end end)
        end)
    end
    function setOption(opt, val)
        if not opt or val == nil then return end
        pcall(function()
            local oldCb = opt.Callback
            opt.Callback = function() end
            pcall(function()
                if opt.SetValue then opt:SetValue(val) end
            end)
            pcall(function() opt.Value = val end)
            if typeof(val) == "string" then
                pcall(function() if opt.SetText then opt:SetText(val) end end)
                pcall(function()
                    -- Input visual box
                    if opt.Box and opt.Box.Text ~= nil then opt.Box.Text = tostring(val) end
                end)
            elseif typeof(val) == "number" then
                pcall(function() if opt.Display then opt:Display() end end)
                pcall(function() if opt.SetValue then opt:SetValue(val) end end)
            end
            opt.Callback = oldCb
            opt.Value = val
            pcall(function() if opt.Display then opt:Display() end end)
        end)
    end

    pcall(function()
        local Toggles = (Library and Library.Toggles) or rawget(getgenv(), "Toggles")
        local Options = (Library and Library.Options) or rawget(getgenv(), "Options")

        local flagMap = {
            EnableHVH = "Enabled",
            RagebotToggle = "RagebotEnabled",
            VoidSpam = "VoidSpamEnabled",
            FlyToggle = "FlyEnabled",
            NoclipToggle = "NoclipEnabled",
            SpeedToggle = "SpeedEnabled",
            JumpPowerToggle = "JumpPowerEnabled",
            SlideBoost = "SlideBoostEnabled",
            ESPEnabled = "ESPEnabled",
            AimbotToggle = "AimbotEnabled",
            SilentToggle = "SilentAimEnabled",
            SilentAimEnabled = "SilentAimEnabled",
            Triggerbot = "TriggerbotEnabled",
            PredDodge = "PredDodgeEnabled",
            StretchedRes = "StretchedRes",
            UECounterToggle = "UECounterEnabled",
            AntiUnnamed = "UECounterEnabled",
            RapidFire = "RapidFire",
            FastMelee = "FastMelee",
            NoRecoilToggle = "NoRecoil",
            SoftStick = "SoftStick",
            Strafe = "StrafeEnabled",
            Orbit = "OrbitEnabled",
            TargetLock = "TargetLock",
            TeamCheckMain = "TeamCheck",
            Hitbox = "HitboxExpand",
            AntiAim = "AntiAimEnabled",
            AntiFling = "AntiFling",
            InfinityJump = "InfinityJump",
            FakePosition = "FakePosition",
            DesyncJitter = "DesyncJitter",
            StickMultiPos = "StickMultiPos",
            StickDesync = "StickDesync",
            StickFireHead = "StickFireHead",
            CameraIndependent = "CameraIndependent",
            HitSoundEnabled = "HitSoundEnabled",
            KillSoundEnabled = "KillSoundEnabled",
            AntiKick = "AntiKick",
            AutoRespawn = "AutoRespawn",
            Fullbright = "Fullbright",
            WeatherEnabled = "WeatherEnabled",
            VoidEvade = "VoidEvade",
            SkinchangerEnabled = "SkinchangerEnabled",
            ESPGlow = "ESPGlow",
            ESPTracers = "ESPTracers",
            ESPSkeleton = "ESPSkeleton",
            ESPShowBox = "ESPShowBox",
            ESPShowName = "ESPShowName",
            ESPShowDist = "ESPShowDist",
            ESPShowHP = "ESPShowHP",
            ESPTeamCheck = "ESPTeamCheck",
            RageDesync = "RageDesync",
            RageUseItem = "RageUseItem",
            RagebotInfiniteRange = "RagebotInfiniteRange",
            RagebotTeamCheck = "RagebotTeamCheck",
            RivalsSpoofDisp = "display_name", -- special RS
            RivalsSpoofUser = "username",
            SpoofAvatar = "spoof_avatar",
            
        }

        -- 1) Prefer snapshot _UI.toggles (estado exacto de la UI al guardar)
        local uiT = type(data._UI) == "table" and data._UI.toggles or nil
        if type(Toggles) == "table" then
            for flag, toggle in pairs(Toggles) do
                local val = nil
                if uiT and uiT[tostring(flag)] ~= nil then
                    val = uiT[tostring(flag)] and true or false
                else
                    local key = flagMap[flag] or flag
                    if typeof(config[key]) == "boolean" then
                        val = config[key]
                    end
                end
                if typeof(val) == "boolean" then
                    setToggle(toggle, val)
                end
            end
        end

        -- 2) Options / inputs / sliders
        local uiO = type(data._UI) == "table" and data._UI.options or nil
        if type(Options) == "table" then
            for flag, opt in pairs(Options) do
                local val = nil
                if uiO and uiO[tostring(flag)] ~= nil then
                    val = uiO[tostring(flag)]
                else
                    local key = flagMap[flag] or flag
                    val = config[key]
                end
                -- avatar ids especiales
                if flag == "VictimUserId" or flag == "SkinTargetUserId" or flag == "AvatarUserId" then
                    local aid = tonumber(config.SkinTargetUserId)
                    pcall(function()
                        local rs = RivalsSpoof or (getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state)
                        if rs and tonumber(rs.avatar_userid) then aid = tonumber(rs.avatar_userid) end
                    end)
                    if data._RS and tonumber(data._RS.avatar_userid) then
                        aid = tonumber(data._RS.avatar_userid)
                    end
                    if aid then val = tostring(aid) end
                end
                if flag == "RivalsDispName" or flag == "DisplayName" then
                    pcall(function()
                        local rs = RivalsSpoof or (getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state)
                        if rs and rs.display_name_value then val = tostring(rs.display_name_value) end
                    end)
                end
                if flag == "RivalsUserName" then
                    pcall(function()
                        local rs = RivalsSpoof or (getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state)
                        if rs and rs.username_value then val = tostring(rs.username_value) end
                    end)
                end
                if val ~= nil then setOption(opt, val) end
            end
        end
    end)
end

function Cfg.ApplyLoadedState()
    task.spawn(function()
        task.wait(0.2)
        getgenv()._ShakoQuiet = true
        function safe(fn) pcall(fn) end

        -- APAGAR TODO primero
        safe(function()
            pcall(StopRagebot); pcall(StopVoidSpam); pcall(StopFly); pcall(StopNoclip)
            pcall(StopAntiAim); pcall(StopAimbot); pcall(StopESP); pcall(StopTriggerbot)
            pcall(StopPredDodge); pcall(StopNoRecoil); pcall(StopRapidFire); pcall(StopFastMelee)
            pcall(StopSilentAim); pcall(StopFOVDraw); pcall(StopDefense); pcall(StopUECounter)
            pcall(StopRiot); pcall(StopRiotAbuse); pcall(StopBlink); pcall(StopAutoCollect)
            pcall(StopAutoClick)
            SafeDisconnect("Main"); SafeDisconnect("StickRender")
            pcall(function() RunService:UnbindFromRenderStep("__as_rage_restore") end)
            pcall(function() RunService:UnbindFromRenderStep("__as_void_desync") end)
        end)

        safe(function()
            if config.Enabled or config.StrafeEnabled or config.OrbitEnabled then StartMainLoop()
            else SafeDisconnect("Main"); SafeDisconnect("StickRender") end
        end)
        safe(function()
            if config.RagebotEnabled then
                StartRagebot()
            else
                StopRagebot()
                pcall(function() RunService:UnbindFromRenderStep("__as_rage_restore") end)
            end
        end)
        safe(function()
            if config.VoidSpamEnabled then StartVoidSpam() else StopVoidSpam() end
        end)
        safe(function()
            if config.RiotEnabled then StartRiot() else StopRiot() end
        end)
        safe(function()
            if config.RiotAbuseEnabled then StartRiotAbuse() else StopRiotAbuse() end
        end)
        safe(function()
            if config.BlinkEnabled then StartBlink() else StopBlink() end
        end)
        safe(function()
            if config.AutoCollectHeals then StartAutoCollect() else StopAutoCollect() end
        end)
        safe(function()
            if config.FlyEnabled then StartFly() else StopFly() end
        end)
        safe(function()
            if config.NoclipEnabled then StartNoclip() else StopNoclip() end
        end)
        safe(function()
            if config.AntiAimEnabled then StartAntiAim() else StopAntiAim() end
        end)
        safe(function()
            if config.AimbotEnabled then StartAimbot() else StopAimbot() end
        end)
        safe(function()
            if config.ESPEnabled then StartESP() else StopESP() end
        end)
        safe(function()
            if config.TriggerbotEnabled then StartTriggerbot() else StopTriggerbot() end
        end)
        safe(function()
            if config.PredDodgeEnabled then StartPredDodge() else StopPredDodge() end
        end)
        safe(function()
            if config.NoRecoil then StartNoRecoil() else StopNoRecoil() end
        end)
        safe(function()
            if config.RapidFire then StartRapidFire() else StopRapidFire() end
        end)
        safe(function()
            if config.FastMelee then StartFastMelee() else StopFastMelee() end
        end)
        safe(function()
            if config.SpeedEnabled then ApplySpeedState() end
            if config.JumpPowerEnabled then ApplyJumpState() end
        end)
        safe(function()
            if config.SlideBoostEnabled then StartSlideBoostLoop() else pcall(StopSlideBoostLoop) end
            if config.SleepyCounterEnabled then StartSleepyCounter() else pcall(StopSleepyCounter) end
            if config.KiciaCounterEnabled then StartKiciaCounter() else pcall(StopKiciaCounter) end
            if config.StickBehindTP then StartStickBehindTP() else pcall(StopStickBehindTP) end
            if config.AmbientSoundEnabled then StartAmbientSound() else pcall(StopAmbientSound) end
        end)
        -- Anti-Rager / Defense: DEBE apagarse al cargar legit
        safe(function()
            if type(anyDefenseOn) == "function" and anyDefenseOn() then
                StartDefense()
            else
                pcall(StopDefense)
                -- forzar flags off si no vienen en config
                if config.RagerCombo == nil then config.RagerCombo = false end
                if not config.OrbitEvade and not config.HeightJitter and not config.AntiHeadTP
                    and not config.StrafePattern and not config.FakePeek and not config.RagerCombo then
                    pcall(StopDefense)
                end
            end
        end)
        safe(function()
            -- stretch available (CFrame matrix)
        end)
        -- ===== VISUALES (weather / sky / fullbright / FF) =====
        safe(function()
            -- sync skyboxData desde config guardada
            if skyboxData then
                local preset = config.SkyboxPreset
                if type(preset) == "string" and preset ~= "" and preset ~= "Off" and preset ~= "None" then
                    skyboxData.enabled = true
                    skyboxData.selected = preset
                elseif config.SkyboxEnabled then
                    skyboxData.enabled = true
                    if type(config.SkyboxName) == "string" and config.SkyboxName ~= "" then
                        skyboxData.selected = config.SkyboxName
                    end
                end
                if config.SkyRotate ~= nil then skyboxData.auto_rotate = config.SkyRotate and true or false end
            end
            if skyboxData and skyboxData.enabled then
                pcall(function() ApplySkybox(true) end)
                if skyboxData.auto_rotate and getgenv()._ShakoStartSkyRotate then
                    pcall(function() getgenv()._ShakoStartSkyRotate(true) end)
                end
            end
        end)
        safe(function()
            if config.WeatherEnabled or config.Weather then
                pcall(function() if Config then Config.Weather = true end end)
                pcall(function() if Config then Config.WeatherType = config.WeatherType or "Rain" end end)
                if Weather then
                    if Weather.setType and config.WeatherType then pcall(Weather.setType, config.WeatherType) end
                    if Weather.setIntensity and config.WeatherIntensity then pcall(Weather.setIntensity, config.WeatherIntensity) end
                    if Weather.setSoundVolume and config.WeatherSoundVolume then pcall(Weather.setSoundVolume, config.WeatherSoundVolume) end
                end
                if StartWeather then StartWeather()
                elseif Weather and Weather.enableWeather then Weather.enableWeather() end
            else
                if StopWeather then StopWeather()
                elseif Weather and Weather.disableWeather then Weather.disableWeather() end
            end
        end)
        safe(function()
            if config.SkyboxPreset and config.SkyboxPreset ~= "Off" and Weather and Weather.setSkybox then
                pcall(function() Weather.setSkybox(config.SkyboxPreset) end)
            end
        end)
        safe(function()
            if config.Fullbright then
                pcall(function()
                    if StartFullbright then StartFullbright()
                    else
                        Lighting.Brightness = 2
                        Lighting.ClockTime = 14
                        Lighting.FogEnd = 100000
                        Lighting.GlobalShadows = false
                        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
                    end
                end)
            end
        end)
        safe(function()
            if config.ForceFieldVisual and ApplyForceField and LocalPlayer.Character then
                ApplyForceField(LocalPlayer.Character)
            end
        end)
        safe(function()
            if config.SilentAimEnabled and StartSilentAim then StartSilentAim() end
            if config.SilentShowFOV ~= false and StartFOVDraw then StartFOVDraw() end
        end)
        safe(function()
            if config.ThirdPerson or config.ThirdPersonEnabled then
                if StartThirdPerson then StartThirdPerson() end
            end
        end)
        safe(function()
            if config.CrosshairEnabled and StartCrosshair then StartCrosshair() end
        end)
        safe(function()
            if config.UECounterEnabled or config.AntiUnnamed then
                StartUECounter()
                StartAUWatcher()
            end
        end)
        safe(function()
            if RivalsSpoof and RivalsSpoof.spoof_device then RivalsApplyDevice() end
            -- avatar 3D spoof disabled (lag)
            if RivalsSpoof and RivalsSpoof.display_name then RivalsRefreshNames() end
            if RivalsSpoof and RivalsSpoof.badges then RivalsUpdateBadges() end
        end)
        safe(function()
            RivalsApplyLeaderboard()
            RivalsUpdateCharm()
        end)
        -- re-aplicar unlock skins
        safe(function()
            local st = getgenv()._ShakoStates
            if st and st.skinchanger_state then
                local cd = getgenv()._ShakoModules and getgenv()._ShakoModules.PlayerDataController
                cd = cd and cd.CurrentData
                if cd then
                    pcall(function() cd:Replicate("CosmeticInventory") end)
                    pcall(function() cd:Replicate("WeaponInventory") end)
                end
            end
        end)
        getgenv()._ShakoQuiet = false
        -- un solo aviso, no spam de OFF
        pcall(function()
            Library:Notify({ Title = "Config", Description = "Estado aplicado", Time = 2 })
        end)
    end)
end

function Cfg.Load(name)
    name = Cfg.Sanitize(name)
    if not name or name == "(ninguna)" then
        Notify("Config", "Elige una config")
        return false
    end
    local path = Cfg.folder .. "/" .. name .. ".json"
    if not (isfile and isfile(path)) then
        Notify("Config", "No existe: " .. name)
        return false
    end
    local ok, raw = pcall(function() return readfile(path) end)
    if not ok or not raw or raw == "" then
        Notify("Config", "No se pudo leer")
        return false
    end
    local dok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not dok or type(data) ~= "table" then
        Notify("Config", "JSON invalido")
        return false
    end

    -- Apagar TODOS los bool de features antes de merge (solo quedan los de la config)
    local skipReset = {
        AntiKick = false, SoftStick = false, TeamCheck = false, ItemLibraryKeepAlive = true,
        RageDesync = false, RageUseItem = true, RagebotSkipFF = false, RageVoidFirst = true,
        InfiniteRange = true, RageInfinite = true, StickOnRender = true,
    }
    for k, v in pairs(config) do
        if type(v) == "boolean" and not skipReset[k] then
            -- solo si la key parece feature toggle (Enabled / Toggle / Spam / etc)
            local lk = tostring(k)
            if lk:find("Enabled") or lk:find("Toggle") or lk:find("Spam")
                or lk:find("Visual") or lk == "RapidFire" or lk == "FastMelee"
                or lk == "NoRecoil" or lk == "Fullbright" or lk == "Weather"
                or lk == "WeatherEnabled" or lk == "FlyEnabled" or lk == "NoclipEnabled"
                or lk == "ESPEnabled" or lk == "AimbotEnabled" or lk == "SilentAimEnabled"
                or lk == "AntiAimEnabled" or lk == "RagebotEnabled" or lk == "VoidSpamEnabled"
                or lk == "PredDodgeEnabled" or lk == "TriggerbotEnabled" or lk == "AutoClickEnabled"
                or lk == "RiotEnabled" or lk == "RiotAbuseEnabled" or lk == "BlinkEnabled"
                or lk == "AutoCollectHeals" or lk == "UECounterEnabled" or lk == "AntiUnnamed"
                or lk == "Enabled" or lk == "StrafeEnabled" or lk == "OrbitEnabled"
                or lk == "ForceFieldVisual" or lk == "DesyncSpam" or lk == "HurtEvade"
                or lk == "NearEnemyEvade" or lk == "LowHPPanic" or lk == "AntiUEClose"
                or lk == "AntiUEPeek" or lk == "RagerCombo" or lk == "OrbitEvade"
                or lk == "HeightJitter" or lk == "AntiHeadTP" or lk == "StrafePattern"
                or lk == "FakePeek" or lk == "AdaptiveDesync" or lk == "VelocityBreak"
                or lk == "RandomMicroMove" or lk == "AntiMeleeEnabled" or lk == "HitboxBig"
                or lk == "HitboxExpand" or lk == "FakePosition" or lk == "Desync"
                or lk == "DesyncStrong" or lk == "VoidEvade" or lk == "VoidRage"
                or lk == "StickMultiPos" or lk == "CameraIndependent" or lk == "UndergroundAA"
                then
                config[k] = false
            end
        end
    end

    -- merge config keys (incluye keys nuevas y boolean false)
    for k, v in pairs(data) do
        if type(k) ~= "string" then continue end
        if k:sub(1, 1) == "_" then continue end -- _RS _UI _Unlock
        local tv = typeof(v)
        if tv ~= "boolean" and tv ~= "number" and tv ~= "string" then continue end
        if config[k] ~= nil then
            local tk = typeof(config[k])
            if tk == tv then
                config[k] = v
            elseif tk == "number" then
                config[k] = tonumber(v) or config[k]
            elseif tk == "boolean" then
                config[k] = v and true or false
            elseif tk == "string" then
                config[k] = tostring(v)
            end
        else
            -- key no estaba en defaults pero es serializable
            config[k] = v
        end
    end

    -- spoof state
    pcall(function()
        local rs = data._RS
        if type(rs) ~= "table" then return end
        local st = getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state
        local target = RivalsSpoof or st
        if not target then return end
        if rs.avatar_userid then target.avatar_userid = tonumber(rs.avatar_userid) or target.avatar_userid end
        if rs.spoof_avatar ~= nil then target.spoof_avatar = rs.spoof_avatar and true or false end
        if rs.display_name ~= nil then target.display_name = rs.display_name and true or false end
        if rs.display_name_value then target.display_name_value = tostring(rs.display_name_value) end
        if rs.username ~= nil then target.username = rs.username and true or false end
        if rs.username_value then target.username_value = tostring(rs.username_value) end
        if rs.device then target.device = tostring(rs.device) end
        if rs.spoof_device ~= nil then target.spoof_device = rs.spoof_device and true or false end
        if type(rs.badges) == "table" then
            target.badges = target.badges or {}
            for bk, bv in pairs(rs.badges) do target.badges[bk] = bv and true or false end
        end
        if type(rs.charm) == "table" then
            target.charm = target.charm or {}
            for ck, cv in pairs(rs.charm) do target.charm[ck] = cv end
            if st and st.charm then
                for ck, cv in pairs(rs.charm) do st.charm[ck] = cv end
            end
        end
        if type(rs.leaderboard) == "table" then
            if st and st.leaderboard then
                for lk, lv in pairs(rs.leaderboard) do st.leaderboard[lk] = lv end
            end
            if target.lb then
                target.lb.elo = rs.leaderboard.ELO
                target.lb.elo_value = rs.leaderboard.elo_value
                target.lb.streak = rs.leaderboard.Streak
                target.lb.streak_value = rs.leaderboard.streak_value
                target.lb.kills = rs.leaderboard.Kills
                target.lb.kills_value = rs.leaderboard.kills_value
                target.lb.wins = rs.leaderboard.Wins
                target.lb.wins_value = rs.leaderboard.wins_value
                target.lb.level = rs.leaderboard.Level
                target.lb.level_value = rs.leaderboard.level_value
            end
        end
        if data.SkinTargetUserId then
            config.SkinTargetUserId = tonumber(data.SkinTargetUserId) or config.SkinTargetUserId
        end
    end)

    -- restore unlock skins
    pcall(function()
        local u = data._Unlock
        if type(u) ~= "table" then return end
        local st = getgenv()._ShakoStates
        if not st or not st.skinchanger_state then return end
        if type(u.fake_owned) == "table" then
            st.skinchanger_state.fake_owned = st.skinchanger_state.fake_owned or {}
            for k, v in pairs(u.fake_owned) do
                if v then st.skinchanger_state.fake_owned[k] = true end
            end
        end
        if type(u.fake_weapon_owned) == "table" then
            st.skinchanger_state.fake_weapon_owned = st.skinchanger_state.fake_weapon_owned or {}
            for _, name in ipairs(u.fake_weapon_owned) do
                -- keep as list of names if source expects that
                local found = false
                for _, e in pairs(st.skinchanger_state.fake_weapon_owned) do
                    if e == name or (type(e) == "table" and e.Name == name) then found = true break end
                end
                if not found then
                    table.insert(st.skinchanger_state.fake_weapon_owned, name)
                end
            end
        end
        if type(u.equipped) == "table" then
            st.skinchanger_state.equipped = st.skinchanger_state.equipped or {}
            for k, v in pairs(u.equipped) do st.skinchanger_state.equipped[k] = v end
        end
        if type(u.unclaimed) == "table" and st.inventory_state then
            st.inventory_state.fake_owned = u.unclaimed
        end
        -- replicate so inventory UI updates
        local m = getgenv()._ShakoModules
        local cd = m and m.PlayerDataController and m.PlayerDataController.CurrentData
        if cd then
            pcall(function() cd:Replicate("CosmeticInventory") end)
            pcall(function() cd:Replicate("WeaponInventory") end)
            pcall(function() cd:Replicate("UnclaimedRewards") end)
        end
        Notify("Unlock", "Skins restauradas en config")
    end)

    getgenv()._ObsidianSyncing = true
    -- UI primero (sin callbacks) + reintentos
    Cfg.SyncUIFromConfig(data)
    task.defer(function()
        task.wait(0.2)
        Cfg.SyncUIFromConfig(data)
        task.wait(0.5)
        Cfg.SyncUIFromConfig(data)
        getgenv()._ObsidianSyncing = false
        -- avatar id explícito otra vez
        pcall(function()
            local aid = tonumber(config.SkinTargetUserId)
            if data._RS and tonumber(data._RS.avatar_userid) then
                aid = tonumber(data._RS.avatar_userid)
            end
            if aid then
                config.SkinTargetUserId = aid
                local rs = RivalsSpoof or (getgenv()._ShakoStates and getgenv()._ShakoStates.spoofer_state)
                if rs then rs.avatar_userid = aid end
                local Options = (Library and Library.Options) or rawget(getgenv(), "Options")
                if type(Options) == "table" then
                    for _, fname in ipairs({"VictimUserId", "SkinTargetUserId", "AvatarUserId"}) do
                        local opt = Options[fname]
                        if opt then
                            pcall(function()
                                if opt.SetValue then opt:SetValue(tostring(aid)) end
                                if opt.SetText then opt:SetText(tostring(aid)) end
                                opt.Value = tostring(aid)
                            end)
                        end
                    end
                end
            end
        end)
    end)
    Cfg.ApplyLoadedState()
    -- segunda pasada visual (weather/sky a veces no pegan a la 1ª)
    task.defer(function()
        task.wait(1.0)
        pcall(function()
            if config.WeatherEnabled or config.Weather then
                pcall(function() if Config then Config.Weather = true end end)
                if Weather and Weather.setType and config.WeatherType then
                    pcall(Weather.setType, config.WeatherType)
                end
                if StartWeather then StartWeather()
                elseif Weather and Weather.enableWeather then Weather.enableWeather() end
            end
            if config.SkyboxPreset and config.SkyboxPreset ~= "Off" and Weather and Weather.setSkybox then
                pcall(Weather.setSkybox, config.SkyboxPreset)
            end
            if skyboxData then
                if config.SkyboxEnabled or (config.SkyboxPreset and config.SkyboxPreset ~= "Off") then
                    skyboxData.enabled = true
                    if config.SkyboxName and config.SkyboxName ~= "" then
                        skyboxData.selected = config.SkyboxName
                    elseif config.SkyboxPreset and config.SkyboxPreset ~= "Off" then
                        -- intentar mapear preset weather a aurora si existe
                        if SkyboxPresets and SkyboxPresets[config.SkyboxPreset] then
                            skyboxData.selected = config.SkyboxPreset
                        end
                    end
                    if ApplySkybox then ApplySkybox(true) end
                end
            end
            if config.Fullbright and Lighting then
                Lighting.Brightness = 2
                Lighting.FogEnd = 1e5
                Lighting.GlobalShadows = false
            end
            if config.ForceFieldVisual and ApplyForceField and LocalPlayer.Character then
                ApplyForceField(LocalPlayer.Character)
            end
        end)
        task.wait(2.0)
        pcall(function()
            if (config.WeatherEnabled or config.Weather) and Weather and Weather.enableWeather then
                local f = workspace:FindFirstChild("_wx")
                if not f then Weather.enableWeather() end
            end
            if skyboxData and skyboxData.enabled and ApplySkybox then ApplySkybox(true) end
        end)
    end)
    Notify("Config", "Cargada: " .. name)
    return true
end

function Cfg.Delete(name)
    name = Cfg.Sanitize(name)
    if not name or name == "(ninguna)" then return false end
    local path = Cfg.folder .. "/" .. name .. ".json"
    if isfile and isfile(path) then
        pcall(function() delfile(path) end)
        Notify("Config", "Borrada: " .. name)
        return true
    end
    return false
end

function Cfg.SetAutoLoad(name)
    name = Cfg.Sanitize(name)
    if not name or name == "(ninguna)" then
        Notify("Config", "Elige o escribe un nombre")
        return false
    end
    if not Cfg.EnsureFolder() then
        Notify("Config", "No hay carpeta configs")
        return false
    end
    local path = Cfg.folder .. "/" .. name .. ".json"
    if not (isfile and isfile(path)) then
        if not Cfg.Save(name, true) then
            Notify("Config", "No se pudo crear " .. name)
            return false
        end
    end
    local ok = pcall(function() writefile(Cfg.autoload, name) end)
    if ok then
        local check = Cfg.GetAutoLoad()
        Notify("Config", "Auto Load ON → " .. tostring(check or name))
        return true
    end
    Notify("Config", "Auto Load write FAIL")
    return false
end

function Cfg.RemoveAutoLoad()
    local ok = pcall(function()
        if isfile and isfile(Cfg.autoload) then delfile(Cfg.autoload) end
    end)
    Notify("Config", ok and "Auto Load OFF" or "No Auto Load")
    return ok
end

function Cfg.GetAutoLoad()
    local ok, raw = pcall(function()
        if not (isfile and isfile(Cfg.autoload)) then return nil end
        return readfile(Cfg.autoload)
    end)
    if not ok or not raw then return nil end
    raw = tostring(raw):gsub("%s+", "")
    if raw == "" then return nil end
    return Cfg.Sanitize(raw) or raw
end

function Cfg.TryAutoLoad()
    task.spawn(function()
        for _ = 1, 30 do
            if isfile and isfolder then break end
            task.wait(0.1)
        end
        -- esperar UI (Library.Toggles con flags reales)
        for _ = 1, 40 do
            local T = Library and Library.Toggles
            if type(T) == "table" then
                local n = 0
                for _ in pairs(T) do n = n + 1 if n > 5 then break end end
                if n > 5 then break end
            end
            task.wait(0.15)
        end
        task.wait(0.5)
        if not Cfg.EnsureFolder() then return end
        local name = Cfg.GetAutoLoad()
        if not name then return end
        Notify("Config", "Auto Load: " .. name)
        getgenv()._ObsidianSyncing = true
        local ok = false
        for try = 1, 5 do
            if Cfg.Load(name) then ok = true break end
            task.wait(0.6)
        end
        getgenv()._ObsidianSyncing = false
        Notify("Config", ok and ("Auto Load OK: " .. name) or ("Auto Load FAIL: " .. name))
    end)
end

-- ==================== UI COMPLETA ====================


function BuildUI()
Tabs = {}

function bindKey(tog, id, defaultKey)
    pcall(function()
        if not tog or type(tog.AddKeyPicker) ~= "function" then return end
        local def = (defaultKey and defaultKey ~= "" and defaultKey ~= "...") and defaultKey or "None"
        -- Aimbot / Silent: default Hold para que no quede en Always
        local defMode = "Toggle"
        if id == "AimbotKey" or id == "SilentAimKey" then
            defMode = "Hold"
        end
        local ok = pcall(function()
            tog:AddKeyPicker(id, {
                Default = def,
                Text = id,
                Mode = defMode,
                Modes = { "Hold", "Toggle", "Always" },
                SyncToggleState = false,
                NoUI = false,
            })
        end)
        if not ok then
            pcall(function()
                tog:AddKeyPicker(id, {
                    Default = def,
                    Text = id,
                    Mode = defMode,
                    Modes = { "Hold", "Toggle", "Always" },
                    SyncToggleState = false,
                })
            end)
        end
        getgenv()._ShakoKeybinds = getgenv()._ShakoKeybinds or {}
        getgenv()._ShakoKeybinds[id] = { toggle = tog, optionId = id }
    end)
end


-- Keybind processor: Always / Toggle / Hold (manual physical keys)
do
    getgenv()._ShakoKB = getgenv()._ShakoKB or { toggled = {}, held = {}, inputHooked = false }
    local KB = getgenv()._ShakoKB
    KB.inputHooked = false
    KB.held = KB.held or {}
    local UIS = game:GetService("UserInputService")

    local function getKP(id)
        local opts = Library and Library.Options
        return opts and opts[id] or nil
    end

    local function readMode(kp)
        if not kp then return "Toggle" end
        -- Linoria / Obsidian variants
        local m = kp.Mode or kp.mode or kp.Type
        if type(m) == "string" and m ~= "" then
            m = m:lower()
            if m:find("hold") then return "Hold" end
            if m:find("always") then return "Always" end
            if m:find("toggle") then return "Toggle" end
            return m:sub(1,1):upper() .. m:sub(2)
        end
        return "Toggle"
    end

    local function normalizeKey(v)
        if v == nil then return nil end
        if typeof(v) == "EnumItem" then return v end
        if type(v) == "string" then
            local s = v:gsub("%s+", "")
            if s == "" or s == "None" or s == "..." or s == "nil" or s == "UNBOUND" or s == "Unknown" then
                return nil
            end
            -- mouse aliases
            local low = s:lower()
            if low == "mb2" or low == "mousebutton2" or low == "mouse2" or low == "rightclick" or low == "rbutton" then
                return Enum.UserInputType.MouseButton2
            end
            if low == "mb1" or low == "mousebutton1" or low == "mouse1" or low == "leftclick" then
                return Enum.UserInputType.MouseButton1
            end
            if low == "mb3" or low == "mousebutton3" or low == "mouse3" then
                return Enum.UserInputType.MouseButton3
            end
            local ok, e = pcall(function() return Enum.KeyCode[s] end)
            if ok and e then return e end
            ok, e = pcall(function() return Enum.UserInputType[s] end)
            if ok and e then return e end
        end
        return nil
    end

    local function readKey(kp)
        if not kp then return nil end
        -- common property names across libs
        local candidates = { kp.Value, kp.Key, kp.KeyCode, kp.Input, kp.Bind }
        for _, v in ipairs(candidates) do
            local k = normalizeKey(v)
            if k then return k end
        end
        -- some pickers store in .Values or GetState only
        pcall(function()
            if type(kp.GetKeybind) == "function" then
                return normalizeKey(kp:GetKeybind())
            end
        end)
        return nil
    end

    local function keyDown(key)
        if not key then return false end
        local ok, down = pcall(function()
            if typeof(key) ~= "EnumItem" then return false end
            if key.EnumType == Enum.KeyCode then
                return UIS:IsKeyDown(key)
            end
            if key.EnumType == Enum.UserInputType then
                if key == Enum.UserInputType.MouseButton1
                    or key == Enum.UserInputType.MouseButton2
                    or key == Enum.UserInputType.MouseButton3 then
                    return UIS:IsMouseButtonPressed(key)
                end
            end
            return false
        end)
        return ok and down == true
    end

    local function inputMatchesKey(input, key)
        if not key or not input then return false end
        if key.EnumType == Enum.KeyCode then
            return input.KeyCode == key
        end
        if key.EnumType == Enum.UserInputType then
            return input.UserInputType == key
        end
        return false
    end

    -- Track physical hold state for every bound keybind id
    if not KB.inputHooked then
        KB.inputHooked = true
        UIS.InputBegan:Connect(function(input, gpe)
            -- mouse buttons still fire with gpe sometimes; don't skip mouse
            local isMouse = input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.MouseButton2
                or input.UserInputType == Enum.UserInputType.MouseButton3
            if gpe and not isMouse then return end

            local map = getgenv()._ShakoKeybinds
            if type(map) ~= "table" then return end
            for id, _ in pairs(map) do
                local kp = getKP(id)
                if not kp then continue end
                local key = readKey(kp)
                if not key then continue end
                if not inputMatchesKey(input, key) then continue end

                local mode = readMode(kp)
                if mode == "Hold" then
                    KB.held[id] = true
                elseif mode == "Toggle" then
                    KB.toggled[id] = not (KB.toggled[id] == true)
                end
            end
        end)
        UIS.InputEnded:Connect(function(input)
            local map = getgenv()._ShakoKeybinds
            if type(map) ~= "table" then return end
            for id, _ in pairs(map) do
                local kp = getKP(id)
                if not kp then continue end
                local key = readKey(kp)
                if not key then continue end
                if not inputMatchesKey(input, key) then continue end
                local mode = readMode(kp)
                if mode == "Hold" then
                    KB.held[id] = false
                end
            end
        end)
    end

    -- Public API
    function isKeybindActive(id, featureOn)
        if not featureOn then return false end
        local kp = getKP(id)
        local mode = readMode(kp)
        local key = readKey(kp)

        if mode == "Always" then
            return true
        end

        if mode == "Hold" then
            -- MUST have a key; without key Hold is OFF (never Always)
            if not key then return false end
            -- prefer physical tracker
            if KB.held[id] == true then return true end
            if KB.held[id] == false then return false end
            -- fallback live poll
            return keyDown(key)
        end

        -- Toggle
        if not key then
            -- no key: feature toggle alone
            return true
        end
        if KB.toggled[id] ~= nil then
            return KB.toggled[id] == true
        end
        -- library GetState fallback
        if kp and type(kp.GetState) == "function" then
            local ok, st = pcall(function() return kp:GetState() end)
            if ok and type(st) == "boolean" then return st end
        end
        return false
    end
end

function isAimbotKeyActive()
    return isKeybindActive("AimbotKey", config.AimbotEnabled == true)
end

function isSilentKeyActive()
    return isKeybindActive("SilentAimKey", config.SilentAimEnabled == true)
end

function isESPKeyActive()
    return isKeybindActive("ESPKey", config.ESPEnabled == true)
end

function isVoidKeyActive()
    return isKeybindActive("VoidSpamKey", config.VoidSpamEnabled == true)
end

function isFlyKeyActive()
    return isKeybindActive("FlyKey", config.FlyEnabled == true)
end

function isNoclipKeyActive()
    return isKeybindActive("NoclipKey", config.NoclipEnabled == true)
end

function isUEKeyActive()
    return isKeybindActive("UECounterKey", config.UECounter == true)
end

function isStickKeyActive()
    return isKeybindActive("StickKey", config.StickEnabled == true)
end

function addColor(group, id, title, getRGB, setRGB, onChange)
    pcall(function()
        if not group or not group.AddLabel then return end
        local lbl = group:AddLabel(title or id)
        if not lbl or not lbl.AddColorPicker then return end
        local r,g,b = getRGB()
        lbl:AddColorPicker(id, {
            Default = Color3.fromRGB(tonumber(r) or 255, tonumber(g) or 255, tonumber(b) or 255),
            Title = title or id,
            Callback = function(c)
                setRGB(math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
                if onChange then pcall(onChange, c) end
            end
        })
    end)
end
function addColor3(group, id, title, getC3, setC3, onChange)
    pcall(function()
        if not group or not group.AddLabel then return end
        local lbl = group:AddLabel(title or id)
        if not lbl or not lbl.AddColorPicker then return end
        lbl:AddColorPicker(id, {
            Default = getC3() or Color3.fromRGB(255,255,255),
            Title = title or id,
            Callback = function(c)
                setC3(c)
                if onChange then pcall(onChange, c) end
            end
        })
    end)
end


function addTab(key, name, icon)
    local ok, tab = pcall(function() return Window:AddTab(name, icon) end)
    if not ok or not tab then
        ok, tab = pcall(function() return Window:AddTab(name) end)
    end
    if ok and tab then Tabs[key] = tab else warn("[shako] tab fail", name, tab) end
end
-- Tabs estilo Unnamed Enhancements
addTab("Main", "main", "sword")
addTab("World", "world", "globe")
addTab("ESP", "esp", "eye")
addTab("Visual", "Visuals", "sparkles")
addTab("Character", "character", "user")
addTab("Misc", "misc", "box")
addTab("Settings", "settings", "settings")
if not Tabs.Main then warn("[shako] BuildUI abort: no Main tab") return end
Tabs.Rage = Tabs.Main
Tabs.Void = Tabs.Misc
Tabs.Movement = Tabs.Character
Tabs.Obsidian = Tabs.Misc
Tabs.Configs = Tabs.Settings
Tabs.Spoofer = Tabs.Misc -- spoofers off
Tabs.Unlock = Tabs.Misc
Tabs.Visuals = Tabs.Visual


CombatBox = Tabs.Main:AddLeftGroupbox("Anti-Sleepy")
togStick = CombatBox:AddToggle("EnableHVH", {
    Text = "Activar shako", Default = false,
    Callback = function(v)
        if IsAntiUnnamedActive() or config.VoidSpamEnabled then Notify("Warn", "Apaga AU/Void") return end
        config.Enabled = v
        if v then StartMainLoop() else SafeDisconnect("Main") SafeDisconnect("StickRender") CurrentTarget = nil end
    end
})
bindKey(togStick, "StickKey", "...")
CombatBox:AddToggle("TargetLock", {
    Text = "Lock Target", Default = false,
    Callback = function(v) config.TargetLock = v if not v then LockedTarget = nil end end
})
CombatBox:AddDropdown("PriorityMode", {
    Text = "Prioridad", Values = {"Closest", "LowestHP", "Crosshair"}, Default = 1,
    Callback = function(v) config.PriorityMode = v end
})
CombatBox:AddToggle("StickMultiPos", {
    Text = "Multi Pos", Default = false,
    Callback = function(v) config.StickMultiPos = v end
})
-- StickDesync siempre ON (dentro del stick, sin opcion separada)
config.StickDesync = false
CombatBox:AddSlider("StickPosInterval", {
    Text = "Pos Interval", Default = 0.18, Min = 0.05, Max = 0.8, Rounding = 2,
    Callback = function(v) config.StickPosInterval = v end
})
CombatBox:AddSlider("StickAway", {
    Text = "Distancia lados", Default = 6, Min = 1, Max = 50, Rounding = 1,
    Callback = function(v) config.StickAway = v end
})
CombatBox:AddToggle("StickFarMode", {
    Text = "Stick Far", Default = false,
    Callback = function(v) config.StickFarMode = v end
})
CombatBox:AddToggle("StickFireHead", {
    Text = "Shoot Head", Default = false,
    Callback = function(v) config.StickFireHead = v end
})
CombatBox:AddSlider("StickHeight", {
    Text = "Height Y", Default = -2.8, Min = -8, Max = 4, Rounding = 1,
    Callback = function(v) config.StickHeight = v end
})
CombatBox:AddSlider("StickOffsetX", {
    Text = "Offset X", Default = 0, Min = -8, Max = 8, Rounding = 1,
    Callback = function(v) config.StickOffsetX = v end
})
CombatBox:AddSlider("StickOffsetZ", {
    Text = "Offset Z", Default = 0, Min = -8, Max = 8, Rounding = 1,
    Callback = function(v) config.StickOffsetZ = v end
})
CombatBox:AddSlider("MaxRange", {
    Text = "Range", Default = 999999, Min = 100, Max = 999999, Rounding = 0,
    Callback = function(v) config.MaxRange = v end
})
CombatBox:AddToggle("InfiniteRange", {
    Text = "Infinite Range", Default = false,
    Callback = function(v) config.InfiniteRange = v end
})
CombatBox:AddToggle("TeamCheckMain", {
    Text = "Team Check", Default = false,
    Callback = function(v)
        config.TeamCheck = v
        config.RagebotTeamCheck = v
        config.SilentTeamCheck = v
        config.AimbotTeamCheck = v
        config.ESPTeamCheck = v
        Notify("TeamCheck", v and "ON — solo enemigos" or "OFF — todos")
    end
})
CombatBox:AddToggle("UseNameTarget", {
    Text = "Usar Nombre", Default = false,
    Callback = function(v) config.UseNameTarget = v end
})
CombatBox:AddInput("TargetNameInput", {
    Text = "Nombre target", Default = "", Callback = function(v) config.TargetName = v end
})

SoftBox = Tabs.Main:AddRightGroupbox("stick extras")
SoftBox:AddToggle("CameraIndependent", {
    Text = "Free Camera", Default = false,
    Callback = function(v) config.CameraIndependent = v if v then ResetCameraNormal() end end
})
SoftBox:AddLabel("Camara: script no la toca")
SoftBox:AddToggle("Strafe", {
    Text = "Strafe", Default = false,
    Callback = function(v)
        config.StrafeEnabled = v == true
        if v then
            config.OrbitEnabled = false -- nunca al mismo tiempo
            StartMainLoop()
        end
    end
})
SoftBox:AddToggle("Orbit", {
    Text = "Orbit", Default = false,
    Callback = function(v)
        config.OrbitEnabled = v == true
        if v then
            config.StrafeEnabled = false -- nunca al mismo tiempo
            StartMainLoop()
        end
    end
})
SoftBox:AddSlider("OrbitRange", {
    Text = "Rango Orbit", Default = 4, Min = 1, Max = 12, Rounding = 1,
    Callback = function(v) config.OrbitRange = v end
})
SoftBox:AddSlider("OrbitSpeed", {
    Text = "Orbit Speed", Default = 16, Min = 1, Max = 40, Rounding = 0,
    Callback = function(v) config.OrbitSpeed = v end
})
SoftBox:AddSlider("HitboxSize", {
    Text = "Hitbox Size", Default = 11, Min = 3, Max = 20, Rounding = 0,
    Callback = function(v) config.HitboxSize = v end
})
SoftBox:AddToggle("DesyncJitter", {
    Text = "Desync Jitter", Default = false,
    Callback = function(v) config.DesyncJitter = v end
})
SoftBox:AddSlider("SpawnDelay", {
    Text = "Spawn Delay", Default = 4.7, Min = 1, Max = 10, Rounding = 1,
    Callback = function(v) config.SpawnDelay = v end
})
SoftBox:AddToggle("FakePosition", {
    Text = "Fake Position", Default = false,
    Callback = function(v)
        if v then StartFakePosition() else StopFakePosition() end
    end
})
SoftBox:AddSlider("FakePositionY", {
    Text = "Fake Y Offset", Default = 5, Min = 0, Max = 30, Rounding = 1,
    Callback = function(v) config.FakePositionY = v end
})
SoftBox:AddToggle("FakePositionPanic", {
    Text = "Panic X Offset", Default = false,
    Callback = function(v) config.FakePositionPanic = v end
})
SoftBox:AddSlider("PanicPositionXMin", {
    Text = "Panic X Min", Default = -8, Min = -30, Max = 0, Rounding = 1,
    Callback = function(v) config.PanicPositionXMin = v end
})
SoftBox:AddSlider("PanicPositionXMax", {
    Text = "Panic X Max", Default = 8, Min = 0, Max = 30, Rounding = 1,
    Callback = function(v) config.PanicPositionXMax = v end
})
SoftBox:AddToggle("FakePositionWalk", {
    Text = "Walk Restore", Default = false,
    Callback = function(v) config.FakePositionWalk = v end
})

-- RAGE FULL
CounterBox = Tabs.Misc:AddLeftGroupbox("counters")
CounterBox:AddToggle("SleepyCounterEnabled", {
    Text = "Sleepy Counter", Default = false,
    Callback = function(v)
        if v then StartSleepyCounter() else StopSleepyCounter() end
    end
})
CounterBox:AddSlider("SleepyCounterSideDist", {
    Text = "Distancia lado mano", Default = 14, Min = 6, Max = 40, Rounding = 0,
    Callback = function(v) config.SleepyCounterSideDist = v end
})
CounterBox:AddSlider("SleepyCounterHeight", {
    Text = "Altura", Default = 1.2, Min = 0, Max = 8, Rounding = 1,
    Callback = function(v) config.SleepyCounterHeight = v end
})
CounterBox:AddSlider("SleepyCounterFireRate", {
    Text = "Fire rate", Default = 0.02, Min = 0, Max = 0.2, Rounding = 3,
    Callback = function(v) config.SleepyCounterFireRate = v end
})
CounterBox:AddToggle("SleepyCounterTeamCheck", {
    Text = "Team Check", Default = false,
    Callback = function(v) config.SleepyCounterTeamCheck = v end
})
CounterBox:AddDivider()
CounterBox:AddToggle("KiciaCounterEnabled", {
    Text = "Kicia Counter", Default = false,
    Callback = function(v)
        if v then StartKiciaCounter() else StopKiciaCounter() end
    end
})
CounterBox:AddSlider("KiciaCounterSkyY", {
    Text = "Altura cielo", Default = 600, Min = 100, Max = 3000, Rounding = 0,
    Callback = function(v) config.KiciaCounterSkyY = v end
})
CounterBox:AddSlider("KiciaCounterLineWidth", {
    Text = "Largo triangulo", Default = 200, Min = 30, Max = 2000, Rounding = 0,
    Callback = function(v) config.KiciaCounterLineWidth = v end
})
CounterBox:AddSlider("KiciaCounterMoveSpeed", {
    Text = "Velocidad TP", Default = 800, Min = 50, Max = 2500, Rounding = 0,
    Callback = function(v) config.KiciaCounterMoveSpeed = v end
})
CounterBox:AddToggle("KiciaCounterShoot", {
    Text = "Shoot from sky", Default = false,
    Callback = function(v) config.KiciaCounterShoot = v end
})
CounterBox:AddSlider("KiciaCounterFireRate", {
    Text = "Fire Rate", Default = 0.015, Min = 0, Max = 0.2, Rounding = 3,
    Callback = function(v) config.KiciaCounterFireRate = v end
})
CounterBox:AddToggle("KiciaCounterTeamCheck", {
    Text = "Team Check", Default = false,
    Callback = function(v) config.KiciaCounterTeamCheck = v end
})
RageBox = Tabs.Main:AddLeftGroupbox("Ragebot")
RageBox:AddToggle("RagebotEnabled", {
    Text = "Ragebot", Default = false,
    Callback = function(v)
        config.RagebotEnabled = v
        if v then StartRagebot() else StopRagebot() end
    end
})
RageBox:AddToggle("RageDesync", {
    Text = "Rage Desync", Default = true,
    Callback = function(v)
        config.RageDesync = v
        if config.RagebotEnabled then
            StartRagebot()
        end
    end
})

RageBox:AddToggle("BodyTwist", {
    Text = "Body Twist (pose torcida)", Default = false,
    Callback = function(v)
        if v then StartBodyTwist() else StopBodyTwist() end
    end
})
RageBox:AddToggle("BodyTwistWithRage", {
    Text = "Twist auto con Rage", Default = false,
    Callback = function(v) config.BodyTwistWithRage = v end
})
RageBox:AddDropdown("BodyTwistMode", {
    Text = "Twist Mode",
    Values = {"Rager", "Broken", "Twist", "Random", "Lay"},
    Default = 1,
    Callback = function(v) config.BodyTwistMode = v end
})
RageBox:AddSlider("BodyTwistPower", {
    Text = "Twist Power", Default = 1, Min = 0.2, Max = 2.5, Rounding = 1,
    Callback = function(v) config.BodyTwistPower = v end
})
RageBox:AddSlider("BodyTwistSpeed", {
    Text = "Twist Speed", Default = 8, Min = 1, Max = 25, Rounding = 0,
    Callback = function(v) config.BodyTwistSpeed = v end
})
RageBox:AddSlider("TeleportOffsetY", {
    Text = "Stud (Offset Y)", Default = 1, Min = -5, Max = 50, Rounding = 1,
    Callback = function(v) config.TeleportOffsetY = v end
})
RageBox:AddSlider("RageDistance", {
    Text = "Distance", Default = 2.5, Min = 0, Max = 15, Rounding = 1,
    Callback = function(v) config.RageDistance = v end
})
RageBox:AddSlider("RageShootAttempts", {
    Text = "Shoot Attempts", Default = 1, Min = 1, Max = 10, Rounding = 0,
    Callback = function(v) config.RageShootAttempts = v end
})
RageBox:AddSlider("RageTeleportDelay", {
    Text = "Fire Interval", Default = 0.04, Min = 0.01, Max = 1, Rounding = 2,
    Callback = function(v) config.RageTeleportDelay = v end
})
RageBox:AddToggle("RageVoidSpamAfterKill", {
    Text = "Void Spam After Kill", Default = false,
    Callback = function(v) config.RageVoidSpamAfterKill = v end
})
RageBox:AddToggle("RageHover", {
    Text = "Hover", Default = false,
    Callback = function(v) config.RageHover = v end
})
RageBox:AddToggle("RageVoidOnReload", {
    Text = "Void While Reloading", Default = false,
    Callback = function(v) config.RageVoidOnReload = v end
})
RageBox:AddSlider("RageShotgunVoidTime", {
    Text = "Shotgun Void Time", Default = 5, Min = 1, Max = 30, Rounding = 0,
    Callback = function(v) config.RageShotgunVoidTime = v end
})
RageBox:AddSlider("RageVoidMinDist", {
    Text = "Void Min Distance", Default = 1, Min = 1, Max = 50000, Rounding = 0,
    Callback = function(v) config.RageVoidMinDist = v end
})
RageBox:AddSlider("RageVoidRange", {
    Text = "Void Max Distance", Default = 50000, Min = 1, Max = 500000, Rounding = 0,
    Callback = function(v) config.RageVoidRange = v end
})
RageBox:AddSlider("RageVoidIterations", {
    Text = "Void Iterations", Default = 120, Min = 1, Max = 500, Rounding = 0,
    Callback = function(v) config.RageVoidIterations = v end
})
RageBox:AddToggle("RageAntiAim", {
    Text = "Rage Anti-Aim", Default = false,
    Callback = function(v) config.RageAntiAim = v end
})
RageBox:AddToggle("RageNoclip", {
    Text = "Noclip", Default = false,
    Callback = function(v) config.RageNoclip = v end
})
RageBox:AddToggle("RagebotTeamCheck", {
    Text = "Team Check", Default = true,
    Callback = function(v)
        config.RagebotTeamCheck = v
        Notify("Rage", v and "Team Check ON" or "Team Check OFF")
    end
})
RageBox:AddToggle("RagebotSkipFF", {
    Text = "Skip Shield", Default = false,
    Callback = function(v) config.RagebotSkipFF = v end
})
RageBox:AddToggle("WallCheckEnabled", {
    Text = "Wall Check", Default = false,
    Callback = function(v) config.WallCheckEnabled = v end
})
RageBox:AddSlider("WallCheckAttempts", {
    Text = "Wall Attempts", Default = 4, Min = 1, Max = 8, Rounding = 0,
    Callback = function(v) config.WallCheckAttempts = v end
})

RageW = Tabs.Main:AddRightGroupbox("Rage Weapon / Target")
RageW:AddDropdown("RagePreferredWeapon", {
    Text = "Preferred Weapon",
    Values = { "primary", "secondary", "melee" },
    Default = 1,
    Callback = function(v) config.RagePreferredWeapon = v end
})
RageW:AddToggle("RageAutoEquip", {
    Text = "Auto Equip Preferred", Default = false,
    Callback = function(v) config.RageAutoEquip = v end
})
RageW:AddToggle("RageAutoSwap", {
    Text = "Swap When Empty", Default = false,
    Callback = function(v) config.RageAutoSwap = v end
})
RageW:AddDropdown("RageTargetMode", {
    Text = "Target Mode",
    Values = { "Closest", "Lowest Health" },
    Default = 1,
    Callback = function(v) config.RageTargetMode = v end
})
RageW:AddToggle("RageAutoPriority", {
    Text = "Auto Prioritize", Default = false,
    Callback = function(v) config.RageAutoPriority = v end
})
RageW:AddToggle("RagePriorityAttackers", {
    Text = "Priority: Attackers", Default = false,
    Callback = function(v) config.RagePriorityAttackers = v end
})
RageW:AddToggle("RagePriorityVoided", {
    Text = "Priority: Voided", Default = false,
    Callback = function(v) config.RagePriorityVoided = v end
})
RageW:AddToggle("HarionFastShoot", {
    Text = "Fast Shoot", Default = false,
    Callback = function(v) config.HarionFastShoot = v end
})
RageW:AddToggle("HarionNoSpread", {
    Text = "No Spread", Default = false,
    Callback = function(v) config.HarionNoSpread = v end
})


ManipBox = Tabs.Main:AddRightGroupbox("manipulation")
ManipBox:AddToggle("ManipulationEnabled", {
    Text = "Manipulation", Default = false,
    Callback = function(v)
        if v then StartManipulation() else StopManipulation() end
    end
})
ManipBox:AddSlider("ManipulationRate", {
    Text = "Fire Rate", Default = 0.05, Min = 0.02, Max = 0.5, Rounding = 2,
    Callback = function(v) config.ManipulationRate = v end
})
ManipBox:AddLabel("Escanea altura para pegar tras cover")
SilentBox = Tabs.Main:AddRightGroupbox("silent aim")
togSilent = SilentBox:AddToggle("SilentAimToggle", {
    Text = "Silent Aim", Default = false,
    Callback = function(v)
        config.SilentAimEnabled = v
        if v then StartSilentAim() else StopSilentAim() end
    end
})
bindKey(togSilent, "SilentAimKey", "...")

SilentBox:AddDropdown("SilentHitPart", {
    Text = "Hit Part",
    Values = {"Head", "HitboxHead", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm"},
    Default = 1,
    Callback = function(v) config.SilentHitPart = v end
})
SilentBox:AddToggle("SilentUseHitboxHead", {
    Text = "Prefer HitboxHead (Head)", Default = true,
    Callback = function(v) config.SilentUseHitboxHead = v end
})
SilentBox:AddSlider("SilentFOV", {
    Text = "FOV Radius", Default = 800, Min = 20, Max = 5000, Rounding = 0,
    Callback = function(v) config.SilentFOV = v end
})
SilentBox:AddSlider("SilentActivationChance", {
    Text = "Activation Chance (%)", Default = 100, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.SilentActivationChance = v end
})
SilentBox:AddSlider("SilentReactionTime", {
    Text = "Reaction Delay", Default = 0, Min = 0, Max = 2, Rounding = 2,
    Callback = function(v) config.SilentReactionTime = v end
})
SilentBox:AddSlider("SilentSwitchDelay", {
    Text = "Switch Delay", Default = 0, Min = 0, Max = 2, Rounding = 2,
    Callback = function(v) config.SilentSwitchDelay = v end
})
SilentBox:AddToggle("SilentManipulate", {
    Text = "Manipulate", Default = true,
    Callback = function(v) config.SilentManipulate = v end
})
SilentBox:AddDropdown("SilentManipulateMode", {
    Text = "Manipulation Check",
    Values = {"OnBestTarget", "OnAllTargets"},
    Default = 1,
    Callback = function(v) config.SilentManipulateMode = v end
})
SilentBox:AddToggle("SilentWallCheck", {
    Text = "Wall Check", Default = false,
    Callback = function(v) config.SilentWallCheck = v end
})
SilentBox:AddToggle("SilentVisibleCheck", {
    Text = "Visible Check", Default = false,
    Callback = function(v) config.SilentVisibleCheck = v end
})
SilentBox:AddToggle("SilentPredict", {
    Text = "Predict", Default = false,
    Callback = function(v) config.SilentPredict = v end
})
SilentBox:AddSlider("SilentPredictAmount", {
    Text = "Predict Amount", Default = 0.08, Min = 0, Max = 0.35, Rounding = 2,
    Callback = function(v) config.SilentPredictAmount = v end
})
SilentBox:AddSlider("SilentHeadOffsetY", {
    Text = "Head Offset", Default = 0, Min = 0, Max = 1.5, Rounding = 2,
    Callback = function(v) config.SilentHeadOffsetY = v end
})

SilentBox:AddToggle("SilentShowFOV", {
    Text = "Show FOV", Default = false,
    Callback = function(v) config.SilentShowFOV = v end
})
SilentBox:AddToggle("SilentFOVFill", {
    Text = "FOV Fill", Default = false,
    Callback = function(v) config.SilentFOVFill = v end
})
SilentBox:AddSlider("SilentFOVFillTransparency", {
    Text = "Fill Transparency", Default = 0.92, Min = 0.5, Max = 0.98, Rounding = 2,
    Callback = function(v) config.SilentFOVFillTransparency = v end
})
SilentBox:AddToggle("SilentFOVAnimated", {
    Text = "Fill Animated", Default = false,
    Callback = function(v) config.SilentFOVAnimated = v end
})
SilentBox:AddToggle("SilentFOVSpin", {
    Text = "FOV Spin (Grief)", Default = false,
    Callback = function(v) config.SilentFOVSpin = v end
})
SilentBox:AddSlider("SilentFOVSpinSpeed", {
    Text = "FOV Spin speed", Default = 1.2, Min = 0.2, Max = 4, Rounding = 1,
    Callback = function(v) config.SilentFOVSpinSpeed = v end
})
SilentBox:AddSlider("SilentFOVThickness", {
    Text = "FOV Outline", Default = 1.5, Min = 1, Max = 4, Rounding = 1,
    Callback = function(v) config.SilentFOVThickness = v end
})
-- colores FOV (cuadritos estilo Unnamed)
pcall(function()
    addColor3(SilentBox, "SilentFOVOutlinePick", "FOV Outline Color",
        function() return config.SilentFOVOutlineColor3 or Color3.fromRGB(255,255,255) end,
        function(c) config.SilentFOVOutlineColor3 = c end)
    addColor3(SilentBox, "SilentFOVFillC1Pick", "FOV Fill Color 1",
        function() return config.SilentFOVFillC1 or Color3.fromRGB(255,105,180) end,
        function(c) config.SilentFOVFillC1 = c end)
    addColor3(SilentBox, "SilentFOVFillC2Pick", "FOV Fill Color 2",
        function() return config.SilentFOVFillC2 or Color3.fromRGB(180,100,255) end,
        function(c) config.SilentFOVFillC2 = c end)
    addColor3(SilentBox, "SilentFOVFillC3Pick", "FOV Fill Color 3",
        function() return config.SilentFOVFillC3 or Color3.fromRGB(80,180,255) end,
        function(c) config.SilentFOVFillC3 = c end)
end)
SilentBox:AddToggle("SilentTeamCheck", {
    Text = "Team Check", Default = true,
    Callback = function(v) config.SilentTeamCheck = v end
})
SilentBox:AddToggle("SilentForceAiming", {
    Text = "Force Fully Aiming", Default = false,
    Callback = function(v) config.SilentForceAiming = v end
})

AimBox = Tabs.Main:AddRightGroupbox("aimbot")
togAim = AimBox:AddToggle("AimbotToggle", {
    Text = "Aimbot (Rivals)", Default = false,
    Callback = function(v) config.AimbotEnabled = v if v then StartAimbot() else StopAimbot() end end
})
bindKey(togAim, "AimbotKey", "...")
AimBox:AddDropdown("AimbotKeyMode", {
    Text = "Activation",
    Values = { "Hold", "Toggle", "Always" },
    Default = 1,
    Callback = function(v)
        config.AimbotKeyMode = v
        -- sync keypicker mode si existe
        pcall(function()
            local kp = Library.Options and Library.Options.AimbotKey
            if kp then kp.Mode = v end
        end)
        if tostring(v):lower():find("toggle") then
            local st = getgenv()._ShakoAimKB
            if st then st.toggled = false end
        end
        Notify("Aimbot", "Mode: " .. tostring(v))
    end
})
AimBox:AddLabel("Hold = mantener | Toggle = on/off | Always = siempre")
AimBox:AddDropdown("AimbotPart", {
    Text = "Hit Part",
    Values = {"Head", "HitboxHead", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart", "LeftUpperArm", "RightUpperArm"},
    Default = 1,
    Callback = function(v) config.AimbotPart = v end
})

-- Aimbot SOLO con keybind (...) — sin click derecho
AimBox:AddToggle("AimbotWallCheck", {
    Text = "Wall Check", Default = false,
    Callback = function(v) config.AimbotWallCheck = v end
})
AimBox:AddToggle("AimbotVisibleCheck", {
    Text = "Visible Check", Default = false,
    Callback = function(v) config.AimbotVisibleCheck = v end
})
AimBox:AddSlider("AimbotFOV", {
    Text = "FOV", Default = 180, Min = 40, Max = 800, Rounding = 0,
    Callback = function(v) config.AimbotFOV = v end
})
AimBox:AddToggle("AimbotShowFOV", {
    Text = "Show FOV", Default = false,
    Callback = function(v) config.AimbotShowFOV = v end
})
AimBox:AddToggle("AimbotFOVFill", {
    Text = "FOV Fill", Default = false,
    Callback = function(v) config.AimbotFOVFill = v end
})
AimBox:AddSlider("AimbotFOVFillTransparency", {
    Text = "Fill Transparency", Default = 0.92, Min = 0.5, Max = 0.98, Rounding = 2,
    Callback = function(v) config.AimbotFOVFillTransparency = v end
})
AimBox:AddToggle("AimbotFOVAnimated", {
    Text = "Fill Animated", Default = false,
    Callback = function(v) config.AimbotFOVAnimated = v end
})
pcall(function()
    addColor3(AimBox, "AimbotFOVOutlinePick", "FOV Outline Color",
        function() return config.AimbotFOVOutlineColor3 or Color3.fromRGB(255,230,80) end,
        function(c) config.AimbotFOVOutlineColor3 = c end)
    addColor3(AimBox, "AimbotFOVFillC1Pick", "FOV Fill Color 1",
        function() return config.AimbotFOVFillC1 or Color3.fromRGB(255,210,80) end,
        function(c) config.AimbotFOVFillC1 = c end)
    addColor3(AimBox, "AimbotFOVFillC2Pick", "FOV Fill Color 2",
        function() return config.AimbotFOVFillC2 or Color3.fromRGB(255,140,60) end,
        function(c) config.AimbotFOVFillC2 = c end)
    addColor3(AimBox, "AimbotFOVFillC3Pick", "FOV Fill Color 3",
        function() return config.AimbotFOVFillC3 or Color3.fromRGB(255,80,120) end,
        function(c) config.AimbotFOVFillC3 = c end)
end)
AimBox:AddSlider("AimbotSmooth", {
    Text = "Smooth", Default = 0.15, Min = 0.02, Max = 1, Rounding = 2,
    Callback = function(v) config.AimbotSmooth = v end
})
AimBox:AddDropdown("AimbotPart", {
    Text = "Part", Values = {"Head", "HumanoidRootPart", "UpperTorso"}, Default = 1,
    Callback = function(v) config.AimbotPart = v end
})
AimBox:AddToggle("AimbotTeamCheckUI", {
    Text = "Team Check", Default = true,
    Callback = function(v) config.AimbotTeamCheck = v end
})
AimBox:AddToggle("AutoClickToggle", {
    Text = "Auto Clicker", Default = false,
    Callback = function(v) config.AutoClickEnabled = v if v then StartAutoClick() else StopAutoClick() end end
})
AimBox:AddSlider("AutoClickCPS", {
    Text = "CPS", Default = 16, Min = 1, Max = 30, Rounding = 0,
    Callback = function(v) config.AutoClickCPS = v end
})
AimBox:AddToggle("AutoClickOnlyOnTarget", {
    Text = "Only On Target", Default = false,
    Callback = function(v) config.AutoClickOnlyOnTarget = v end
})
AimBox:AddToggle("NoRecoilToggle", {
    Text = "No Recoil", Default = false,
    Callback = function(v) config.NoRecoil = v if v then StartNoRecoil() else StopNoRecoil() end end
})
AimBox:AddToggle("NoRecoilOnlyShoot", {
    Text = "Only When Shooting", Default = false,
    Callback = function(v) config.NoRecoilOnlyShoot = v end
})
AimBox:AddLabel("No Recoil = ItemLibrary (sin zoom)")
AimBox:AddSlider("NoRecoilStrength", {
    Text = "Fuerza NR", Default = 1, Min = 0.1, Max = 1, Rounding = 2,
    Callback = function(v) config.NoRecoilStrength = v end
})
AimBox:AddToggle("RapidFireToggle", {
    Text = "Fast Fire", Default = false,
    Callback = function(v) config.RapidFire = v if v then StartRapidFire() else StopRapidFire() end end
})
AimBox:AddToggle("FastMeleeToggle", {
    Text = "Fast Melee", Default = false,
    Callback = function(v) if v then StartFastMelee() else StopFastMelee() end end
})
AimBox:AddSlider("RapidFireDelay", {
    Text = "ShootCooldown", Default = 0.001, Min = 0.0001, Max = 0.05, Rounding = 4,
    Callback = function(v) config.RapidFireDelay = v if config.RapidFire then ApplyItemLibraryGuns(true) end end
})
AimBox:AddToggle("ItemLibraryKeepAlive", {
    Text = "Keep Alive", Default = false,
    Callback = function(v) config.ItemLibraryKeepAlive = v end
})
AimBox:AddButton({
    Text = "Test ItemLibrary",
    Func = function()
        local items = getItems()
        if not items then Notify("Lib", "FAIL") return end
        local n = 0
        for _ in pairs(items) do n += 1 end
        Notify("Lib", n .. " items")
    end
})
AimBox:AddLabel("No Recoil = ItemLibrary ShootRecoil=0")

-- VOID


RiotBox = Tabs.Misc:AddRightGroupbox("riot")
RiotBox:AddToggle("RiotGodmode", {
    Text = "Riot Godmode", Default = false,
    Callback = function(v)
        config.RiotEnabled = v
        if v then StartRiot() else StopRiot() end
    end
})
RiotBox:AddSlider("RiotSpeed", {
    Text = "Teleport Delay", Default = 0.03, Min = 0.01, Max = 0.5, Rounding = 2,
    Callback = function(v) config.RiotSpeed = v end
})
RiotBox:AddSlider("RiotRange", {
    Text = "Jump Range", Default = 50, Min = 10, Max = 200, Rounding = 0,
    Callback = function(v) config.RiotRange = v end
})
RiotBox:AddSlider("RiotEvadeRange", {
    Text = "Evade Trigger", Default = 30, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.RiotEvadeRange = v end
})
RiotBox:AddSlider("RiotSpinSpeed", {
    Text = "Spin Speed", Default = 180, Min = 0, Max = 720, Rounding = 0,
    Callback = function(v) config.RiotSpinSpeed = v end
})
RiotBox:AddToggle("RiotAbuse", {
    Text = "Riot Abuse", Default = false,
    Callback = function(v)
        config.RiotAbuseEnabled = v
        if v then StartRiotAbuse() else StopRiotAbuse() end
    end
})
RiotBox:AddDropdown("RiotAbuseMode", {
    Text = "Abuse Mode",
    Values = {"Stick", "Bounce"},
    Default = 1,
    Callback = function(v) config.RiotAbuseMode = v end
})
RiotBox:AddSlider("RiotAbuseHeight", {
    Text = "Height Offset", Default = 3, Min = -50, Max = 50, Rounding = 1,
    Callback = function(v) config.RiotAbuseHeight = v end
})
RiotBox:AddSlider("RiotAbuseForward", {
    Text = "Forward Offset", Default = 0, Min = -50, Max = 50, Rounding = 1,
    Callback = function(v) config.RiotAbuseForward = v end
})
RiotBox:AddSlider("RiotAbuseRight", {
    Text = "Right Offset", Default = 0, Min = -50, Max = 50, Rounding = 1,
    Callback = function(v) config.RiotAbuseRight = v end
})
RiotBox:AddSlider("RiotAbuseDown", {
    Text = "Down Offset", Default = 0, Min = 0, Max = 50, Rounding = 1,
    Callback = function(v) config.RiotAbuseDown = v end
})
RiotBox:AddLabel("Riot = TP erratico · Abuse = stick 3D al target")

CollectBox = Tabs.Misc:AddLeftGroupbox("ffa collect")
CollectBox:AddToggle("AutoCollectHeals", {
    Text = "Auto Collect Heals", Default = false,
    Callback = function(v)
        config.AutoCollectHeals = v
        if v then StartAutoCollect() else StopAutoCollect() end
    end
})
CollectBox:AddSlider("AutoCollectRadius", {
    Text = "Collect Radius", Default = 60, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) config.AutoCollectRadius = v end
})
CollectBox:AddToggle("AutoCollectAmmo", {
    Text = "Also Collect Ammo", Default = false,
    Callback = function(v) config.AutoCollectAmmo = v end
})
CollectBox:AddLabel("FFA: agarra packs de vida/balas")


CamBox = Tabs.Misc:AddRightGroupbox("camera / vm")

-- Stretched Res viejo eliminado → usa elisium stretch / fov
CamBox:AddToggle("ThirdPersonHarion", {
    Text = "Third Person", Default = false,
    Callback = function(v)
        if v then StartThirdPerson() else StopThirdPerson() end
    end
})
CamBox:AddDropdown("ThirdPersonMode", {
    Text = "Mode",
    Values = {"ThirdPerson", "ThirdPerson Mirrored"},
    Default = 1,
    Callback = function(v) config.ThirdPersonMode = v end
})
CamBox:AddToggle("ThirdPersonUnlockMouse", {
    Text = "Unlock Mouse", Default = false,
    Callback = function(v) config.ThirdPersonUnlockMouse = v end
})

MatchBox = Tabs.Misc:AddLeftGroupbox("match / loadout")
MatchBox:AddToggle("AutoLoadoutEnabled", {
    Text = "Auto Loadout", Default = false,
    Callback = function(v)
        config.AutoLoadoutEnabled = v
        RefreshMatchAutos()
    end
})
MatchBox:AddDropdown("AutoLoadoutPrimary", {
    Text = "Primary",
    Values = {"Crossbow", "Grenade Launcher", "Burst Rifle", "Distortion", "Flamethrower", "Shotgun", "RPG", "Assault Rifle", "Sniper", "Minigun", "Energy Rifle", "Paintball Gun", "Bow", "Gunblade"},
    Default = 8,
    Callback = function(v) config.AutoLoadoutPrimary = v end
})
MatchBox:AddDropdown("AutoLoadoutSecondary", {
    Text = "Secondary",
    Values = {"Slingshot", "Flare Gun", "Spray", "Shorty", "Energy Pistols", "Warper", "Daggers", "Scepter", "Exogun", "Revolver", "Uzi", "Glass Cannon", "Handgun"},
    Default = 13,
    Callback = function(v) config.AutoLoadoutSecondary = v end
})
MatchBox:AddDropdown("AutoLoadoutMelee", {
    Text = "Melee",
    Values = {"Fists", "Scythe", "Battle Axe", "Trowel", "Riot Shield", "Glass Shard", "Knife", "Chainsaw", "Katana"},
    Default = 1,
    Callback = function(v) config.AutoLoadoutMelee = v end
})
MatchBox:AddDropdown("AutoLoadoutUtility", {
    Text = "Utility",
    Values = {"Medkit", "Flashbang", "Elixir", "Subspace Tripmine", "War Horn", "Grenade", "Warpstone", "Molotov", "Freeze Ray", "RNG Dice", "Smoke Grenade", "Jump Pad", "Satchel"},
    Default = 6,
    Callback = function(v) config.AutoLoadoutUtility = v end
})
MatchBox:AddSlider("AutoLoadoutInterval", {
    Text = "Loadout Interval", Default = 2, Min = 0.5, Max = 10, Rounding = 1,
    Callback = function(v) config.AutoLoadoutInterval = v end
})
MatchBox:AddToggle("AutoVoteEnabled", {
    Text = "Auto Vote Map", Default = false,
    Callback = function(v)
        config.AutoVoteEnabled = v
        RefreshMatchAutos()
    end
})
MatchBox:AddDropdown("AutoVoteMap", {
    Text = "Map",
    Values = {"Arena", "Big Graveyard", "Docks", "Splash", "Bridge", "Crossroads", "Big Crossroads", "Big Backrooms", "Battleground", "Big Arena", "Construction", "Playground", "Onyx", "Graveyard", "Big Splash", "Big Onyx", "Backrooms", "Station", "Dimension"},
    Default = 1,
    Callback = function(v) config.AutoVoteMap = v end
})
MatchBox:AddToggle("AutoBanWeaponEnabled", {
    Text = "Auto Ban Weapon", Default = false,
    Callback = function(v)
        config.AutoBanWeaponEnabled = v
        RefreshMatchAutos()
    end
})
MatchBox:AddDropdown("AutoBanWeaponCurrent", {
    Text = "Ban Weapon",
    Values = {"Sniper", "RPG", "Minigun", "Flamethrower", "Grenade Launcher", "Bow", "Crossbow", "Energy Rifle", "Gunblade", "Chainsaw", "Katana", "Scythe"},
    Default = 1,
    Callback = function(v)
        config.AutoBanWeaponCurrent = v
        config.AutoBanWeapons = {v}
    end
})
MatchBox:AddLabel("Vote/Ban = Duels.Vote · Loadout = PickWeapons")

-- ==================== AUTO QUEUE ====================
QueueBox = Tabs.Misc:AddLeftGroupbox("auto queue")
QueueBox:AddToggle("AutoQueueEnabled", {
    Text = "Enabled",
    Default = false,
    Tooltip = "Encola automaticamente al modo seleccionado (MatchmakingController)",
    Callback = function(v)
        config.AutoQueueEnabled = v == true
        if v then
            task.defer(function()
                pcall(function()
                    local mode = tostring(config.AutoQueueMatch or "1v1")
                    local lp = game:GetService("Players").LocalPlayer
                    local ps = lp and lp:FindFirstChild("PlayerScripts")
                    local c = ps and ps:FindFirstChild("Controllers")
                    local mod = c and c:FindFirstChild("MatchmakingController")
                    if mod then
                        local mc = require(mod)
                        if mc and type(mc.QueueInto) == "function" then
                            mc:QueueInto(mode)
                            print("[shako] QueueInto inmediato:", mode)
                        end
                    end
                    local RS = game:GetService("ReplicatedStorage")
                    local mm = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Matchmaking")
                    local jq = mm and mm:FindFirstChild("JoinQueue")
                    if jq then
                        if jq:IsA("RemoteFunction") then jq:InvokeServer(mode)
                        elseif jq:IsA("RemoteEvent") then jq:FireServer(mode) end
                        print("[shako] JoinQueue inmediato:", mode)
                    end
                end)
            end)
            pcall(function()
                if Library and Library.Notify then Library:Notify("Auto Queue ON · " .. tostring(config.AutoQueueMatch), 2) end
            end)
        end
    end
})
QueueBox:AddDropdown("AutoQueueMatch", {
    Text = "Select Match",
    Values = {"1v1", "2v2", "3v3", "4v4", "5v5", "2v2_beginner"},
    Default = 1,
    Callback = function(v)
        config.AutoQueueMatch = tostring(v or "1v1")
    end
})
QueueBox:AddLabel("JoinQueue = Matchmaking")

VoidBox = Tabs.Misc:AddLeftGroupbox("void")
togVoid = VoidBox:AddToggle("VoidSpam", {
    Text = "Enable Void Spam", Default = false,
    Callback = function(v)
        if v and IsAntiUnnamedActive and IsAntiUnnamedActive() then
            Notify("AU", "Apaga UE Counter primero")
            return
        end
        config.VoidSpamEnabled = v == true
        if v then StartVoidSpam() else StopVoidSpam() end
    end
})
bindKey(togVoid, "VoidSpamKey", "...")

VoidBox:AddDropdown("VoidMethod", {
    Text = "Metodo",
    Values = {"Quantum", "Drift", "Chaos", "Loop", "Wave", "Spiral", "Helix", "Bounce", "Strobe", "Cross"},
    Default = 1,
    Callback = function(v) config.VoidMethod = v end
})
VoidBox:AddToggle("VoidEvade", {
    Text = "Void Evade (ultra lejos)", Default = false,
    Callback = function(v) config.VoidEvade = v end
})

VoidBox:AddToggle("VoidExtremeMode", {
    Text = "Void Extreme (Lua x paid)", Default = false,
    Callback = function(v) config.VoidExtremeMode = v end
})
VoidBox:AddToggle("VoidChaosVel", {
    Text = "Chaos Velocity", Default = false,
    Callback = function(v) config.VoidChaosVel = v end
})
VoidBox:AddSlider("VoidEvadeTrigger", {
    Text = "Evade Trigger %", Default = 100, Min = 10, Max = 200, Rounding = 0,
    Callback = function(v) config.VoidEvadeTrigger = v / 100 end
})
VoidBox:AddSlider("VoidEvadeStrength", {
    Text = "Evade Strength %", Default = 100, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) config.VoidEvadeStrength = v / 100 end
})
VoidBox:AddSlider("VoidChaosUI", {
    Text = "Chaos %", Default = 98, Min = 1, Max = 100, Rounding = 0,
    Callback = function(v) config.VoidChaos = v / 100 end
})
VoidBox:AddSlider("VoidEvadeDistUI", {
    Text = "Evade Dist", Default = 100000000000, Min = 1000, Max = 100000000000, Rounding = 0,
    Callback = function(v)
        config.VoidEvadeDist = v
    end
})
togBlink = VoidBox:AddToggle("BlinkHVH", {
    Text = "Blink", Default = false,
    Callback = function(v)
        config.BlinkEnabled = v
        if v then StartBlink() else StopBlink() end
    end
})
VoidBox:AddSlider("BlinkRadius", {
    Text = "Blink Radius", Default = 90, Min = 10, Max = 300, Rounding = 0,
    Callback = function(v) config.BlinkRadius = v end
})
VoidBox:AddSlider("BlinkRate", {
    Text = "Blink Rate", Default = 40, Min = 5, Max = 120, Rounding = 0,
    Callback = function(v) config.BlinkRate = v end
})
VoidBox:AddSlider("VoidSpeedUI", {
    Text = "Speed", Default = 100000000000, Min = 1, Max = 100000000000, Rounding = 0,
    Callback = function(v) config.VoidSpeed = v end
})
VoidBox:AddSlider("VoidAltUI", {
    Text = "Altitude", Default = 100000000000, Min = 1000, Max = 100000000000, Rounding = 0,
    Callback = function(v)
        config.VoidBaseAltitude = v
        config.VoidRadius = math.max(v, config.VoidRadius or v)
    end
})
VoidBox:AddSlider("VoidRadiusUI", {
    Text = "Radius", Default = 100000000000, Min = 1000, Max = 100000000000, Rounding = 0,
    Callback = function(v) config.VoidRadius = v end
})

DodgeBox = Tabs.Misc:AddRightGroupbox("dodge")
DodgeBox:AddToggle("PredDodge", {
    Text = "Prediction Dodge", Default = false,
    Callback = function(v) config.PredDodgeEnabled = v if v then StartPredDodge() else StopPredDodge() end end
})
DodgeBox:AddSlider("PredRadius", {
    Text = "Danger Radius", Default = 20, Min = 5, Max = 100, Rounding = 0,
    Callback = function(v) config.PredRadius = v end
})
DodgeBox:AddSlider("PredDodgeDist", {
    Text = "Dodge Dist", Default = 30, Min = 5, Max = 150, Rounding = 0,
    Callback = function(v) config.PredDodgeDist = v end
})
DodgeBox:AddToggle("Triggerbot", {
    Text = "Triggerbot", Default = false,
    Callback = function(v) config.TriggerbotEnabled = v if v then StartTriggerbot() else StopTriggerbot() end end
})
DodgeBox:AddSlider("TriggerbotFOV", {
    Text = "Trigger FOV", Default = 40, Min = 5, Max = 120, Rounding = 0,
    Callback = function(v) config.TriggerbotFOV = v end
})
DodgeBox:AddSlider("TriggerbotCPS", {
    Text = "Trigger CPS", Default = 12, Min = 1, Max = 25, Rounding = 0,
    Callback = function(v) config.TriggerbotCPS = v end
})

-- VISUAL FULL
VisBox = Tabs.World:AddLeftGroupbox("lighting")
VisBox:AddToggle("ForceFieldVisual", {
    Text = "ForceField visual", Default = false,
    Callback = function(v)
        config.ForceFieldVisual = v
        if v then StartForceField() else StopForceField() end
    end
})
VisBox:AddDropdown("ForceFieldStyle", {
    Text = "FF Estilo",
    Values = {"Highlight", "Soft", "Material", "Both"},
    Default = 1,
    Callback = function(v)
        config.ForceFieldStyle = v
        if config.ForceFieldVisual then ApplyForceField() end
    end
})
VisBox:AddSlider("ForceFieldTransparency", {
    Text = "FF Fill (más alto = más transparente)", Default = 0.72, Min = 0.1, Max = 0.95, Rounding = 2,
    Callback = function(v) config.ForceFieldTransparency = v if config.ForceFieldVisual then ApplyForceField() end end
})
VisBox:AddSlider("ForceFieldOutlineTransparency", {
    Text = "FF Outline transparency", Default = 0.55, Min = 0, Max = 0.95, Rounding = 2,
    Callback = function(v) config.ForceFieldOutlineTransparency = v if config.ForceFieldVisual then ApplyForceField() end end
})
VisBox:AddToggle("ForceFieldPulse", {
    Text = "FF Pulse (animado)", Default = false,
    Callback = function(v)
        config.ForceFieldPulse = v
        if config.ForceFieldVisual then StartForceField() end
    end
})
addColor3(VisBox, "ForceFieldColorPick", "ForceField Color",
    function() return config.ForceFieldColor or Color3.fromRGB(180,0,255) end,
    function(c) config.ForceFieldColor = c end,
    function() if config.ForceFieldVisual then ApplyForceField() end end)
VisBox:AddDropdown("ForceFieldColorPreset", {
    Text = "FF Color preset",
    Values = {"Morado", "Cyan", "Rojo", "Verde", "Blanco", "Rosa"},
    Default = 1,
    Callback = function(v)
        local map = {
            Morado = Color3.fromRGB(180, 0, 255),
            Cyan = Color3.fromRGB(0, 220, 255),
            Rojo = Color3.fromRGB(255, 40, 60),
            Verde = Color3.fromRGB(40, 255, 120),
            Blanco = Color3.fromRGB(255, 255, 255),
            Rosa = Color3.fromRGB(255, 80, 180),
        }
        config.ForceFieldColor = map[v] or map.Morado
        if config.ForceFieldVisual then ApplyForceField() end
    end
})
VisBox:AddToggle("ForceFieldRemoveAcc", {
    Text = "FF modo agresivo (no recomendado)", Default = false,
    Callback = function(v) config.ForceFieldRemoveAcc = v end
})
VisBox:AddToggle("ThirdPerson", {
    Text = "Third Person", Default = false,
    Callback = function(v)
        if v then StartThirdPerson() else StopThirdPerson() end
    end
})
VisBox:AddSlider("ThirdPersonDistance", {
    Text = "TP Distance", Default = 12, Min = 4, Max = 30, Rounding = 0,
    Callback = function(v) config.ThirdPersonDistance = v end
})

VisBox:AddSlider("ThirdPersonHeight", {
    Text = "TP Altura", Default = 2.5, Min = 0, Max = 10, Rounding = 1,
    Callback = function(v) config.ThirdPersonHeight = v end
})
VisBox:AddToggle("Fullbright", {
    Text = "Fullbright", Default = false,
    Callback = function(v) config.Fullbright = v ApplyVisuals() end
})
VisBox:AddToggle("LightingOverride", {
    Text = "Enable Lighting Override", Default = false,
    Callback = function(v) config.LightingOverride = v ApplyVisuals() end
})
VisBox:AddSlider("Brightness", {
    Text = "Brightness", Default = 2, Min = 0, Max = 10, Rounding = 1,
    Callback = function(v) config.Brightness = v ApplyVisuals() end
})
VisBox:AddSlider("Exposure", {
    Text = "Exposure", Default = 0, Min = -3, Max = 3, Rounding = 1,
    Callback = function(v) config.Exposure = v ApplyVisuals() end
})
VisBox:AddSlider("ClockTime", {
    Text = "Time (Clock)", Default = 14, Min = 0, Max = 24, Rounding = 0,
    Callback = function(v) config.ClockTime = v ApplyVisuals() end
})
VisBox:AddToggle("NoFog", {
    Text = "No Fog", Default = false,
    Callback = function(v) config.NoFog = v ApplyVisuals() end
})
VisBox:AddToggle("GlobalShadows", {
    Text = "Global Shadows", Default = false,
    Callback = function(v) config.GlobalShadows = v ApplyVisuals() end
})
VisBox:AddToggle("AmbientColor", {
    Text = "Ambient Colors", Default = false,
    Callback = function(v) config.AmbientColor = v ApplyVisuals() end
})
addColor(VisBox, "AmbientColorPick", "Ambient",
    function() return config.AmbientR or 120, config.AmbientG or 120, config.AmbientB or 140 end,
    function(r,g,b) config.AmbientR, config.AmbientG, config.AmbientB = r,g,b end,
    function() if config.AmbientColor or config.LightingOverride then ApplyVisuals() end end)
addColor(VisBox, "OutdoorColorPick", "Outdoor Ambient",
    function() return config.OutdoorR or 140, config.OutdoorG or 140, config.OutdoorB or 160 end,
    function(r,g,b) config.OutdoorR, config.OutdoorG, config.OutdoorB = r,g,b end,
    function() if config.AmbientColor or config.LightingOverride then ApplyVisuals() end end)
VisBox:AddToggle("ColorShiftEnabled", {
    Text = "Color Shift", Default = false,
    Callback = function(v) config.ColorShiftEnabled = v ApplyVisuals() end
})
addColor(VisBox, "ColorShiftPick", "Color Shift",
    function() return config.ColorShiftR or 0, config.ColorShiftG or 0, config.ColorShiftB or 0 end,
    function(r,g,b) config.ColorShiftR, config.ColorShiftG, config.ColorShiftB = r,g,b end,
    function() if config.ColorShiftEnabled then ApplyVisuals() end end)
VisBox:AddToggle("TintEnabled", {
    Text = "Tint Color", Default = false,
    Callback = function(v) config.TintEnabled = v ApplyVisuals() end
})
addColor(VisBox, "TintColorPick", "Tint Color",
    function() return config.TintR or 255, config.TintG or 255, config.TintB or 255 end,
    function(r,g,b) config.TintR, config.TintG, config.TintB = r,g,b end,
    function() if config.TintEnabled then ApplyVisuals() end end)
VisBox:AddSlider("Saturation", {
    Text = "Saturation", Default = 0, Min = -1, Max = 1, Rounding = 2,
    Callback = function(v) config.Saturation = v ApplyVisuals() end
})
VisBox:AddSlider("Contrast", {
    Text = "Contrast", Default = 0, Min = -1, Max = 1, Rounding = 2,
    Callback = function(v) config.Contrast = v ApplyVisuals() end
})
VisBox:AddToggle("BloomEnabled", {
    Text = "Bloom", Default = false,
    Callback = function(v) config.BloomEnabled = v ApplyVisuals() end
})
VisBox:AddSlider("BloomIntensity", {
    Text = "Bloom Intensity", Default = 0.4, Min = 0, Max = 2, Rounding = 2,
    Callback = function(v) config.BloomIntensity = v ApplyVisuals() end
})
VisBox:AddToggle("BlurEnabled", {
    Text = "Blur", Default = false,
    Callback = function(v) config.BlurEnabled = v ApplyVisuals() end
})
VisBox:AddSlider("BlurSize", {
    Text = "Blur Size", Default = 8, Min = 1, Max = 24, Rounding = 0,
    Callback = function(v) config.BlurSize = v ApplyVisuals() end
})
VisBox:AddDivider()
VisBox:AddLabel("—— World / Map ——")
VisBox:AddToggle("WallXray", {
    Text = "Wall X-Ray (transparencia)", Default = false,
    Callback = function(v)
        config.WallXray = v
        if v then
            ApplyVisuals()
        else
            pcall(function() applyWallXray(false) end)
        end
        Notify("Visual", v and "Wall X-Ray ON" or "Wall X-Ray OFF")
    end
})
VisBox:AddSlider("WallTransparency", {
    Text = "Wall Transparency", Default = 0.55, Min = 0.1, Max = 0.95, Rounding = 2,
    Callback = function(v)
        config.WallTransparency = v
        if config.WallXray then pcall(function() applyWallXray(true) end) end
    end
})
VisBox:AddToggle("MapColorEnabled", {
    Text = "Map Color (tinte mapa)", Default = false,
    Callback = function(v)
        config.MapColorEnabled = v
        if v then ApplyVisuals() else pcall(function() applyMapColor(false) end) end
    end
})
addColor(VisBox, "MapColorPick", "Map Tint",
    function() return config.MapColorR or 80, config.MapColorG or 80, config.MapColorB or 100 end,
    function(r,g,b) config.MapColorR, config.MapColorG, config.MapColorB = r,g,b end,
    function() if config.MapColorEnabled then pcall(function() applyMapColor(true) end) end end)
VisBox:AddToggle("RemoveTextures", {
    Text = "Remove Textures", Default = false,
    Callback = function(v)
        config.RemoveTextures = v
        if v then pcall(function() applyRemoveTextures(true) end) end
        Notify("Visual", v and "Textures off" or "Textures (solo al ON)")
    end
})
VisBox:AddButton({
    Text = "Preset HVH",
    Func = function()
        config.Fullbright = true
        config.LightingOverride = true
        config.NoFog = true
        config.Saturation = 0.1
        config.GlobalShadows = false
        ApplyVisuals()
        ResetCameraNormal()
    end
})
VisBox:AddButton({
    Text = "Preset Night Blue",
    Func = function()
        config.LightingOverride = true
        config.Fullbright = false
        config.ClockTime = 22
        config.Brightness = 1.5
        config.AmbientR, config.AmbientG, config.AmbientB = 40, 50, 90
        config.OutdoorR, config.OutdoorG, config.OutdoorB = 30, 40, 80
        config.ColorShiftEnabled = true
        config.ColorShiftR, config.ColorShiftG, config.ColorShiftB = 20, 40, 120
        config.NoFog = true
        ApplyVisuals()
    end
})
VisBox:AddButton({
    Text = "Reset Camara",
    Func = function()
        ResetCameraNormal()
        EnsureCameraFree()
        Notify("Cam", "Custom OK")
    end
})
VisBox:AddButton({ Text = "Reset Visual", Func = ResetVisuals })

ESPBox = Tabs.ESP:AddLeftGroupbox("ESP")
togESP = ESPBox:AddToggle("ESPEnabled", {
    Text = "ESP", Default = false,
    Callback = function(v)
        config.ESPEnabled = v and true or false
        config.ESP = config.ESPEnabled
        if config.ESPEnabled then
            pcall(function() if type(StopESP) == "function" then StopESP() end end)
            task.defer(function()
                pcall(function() if type(StartESP) == "function" then StartESP() end end)
            end)
        else
            pcall(function() if type(StopESP) == "function" then StopESP() end end)
        end
    end
})
bindKey(togESP, "ESPKey", "...")

ESPBox:AddSlider("ESPMaxPlayers", {
    Text = "Max Players", Default = 12, Min = 1, Max = 25, Rounding = 0,
    Callback = function(v)
        config.ESPMaxPlayers = math.clamp(tonumber(v) or 12, 1, 25)
    end
})
ESPBox:AddToggle("ESPBoxT", {
    Text = "Box", Default = true,
    Callback = function(v) config.ESPBox = v; config.ESPShowBox = v end
})
ESPBox:AddDropdown("ESPBoxStyle", {
    Text = "Box Style",
    Values = {"Full", "Corner"},
    Default = 2,
    Callback = function(v) config.ESPBoxStyle = v end
})
ESPBox:AddToggle("ESPFilledBox", {
    Text = "Filled Box", Default = false,
    Callback = function(v) config.ESPFilledBox = v; config.ESPBoxFill = v end
})
ESPBox:AddToggle("ESPNameT", {
    Text = "Name", Default = true,
    Callback = function(v) config.ESPName = v; config.ESPShowName = v end
})
ESPBox:AddToggle("ESPDistT", {
    Text = "Distance", Default = true,
    Callback = function(v) config.ESPDistance = v; config.ESPShowDist = v end
})
ESPBox:AddToggle("ESPHpBarT", {
    Text = "Health Bar", Default = true,
    Callback = function(v) config.ESPHealthBar = v; config.ESPShowHP = v end
})
ESPBox:AddToggle("ESPHpNumT", {
    Text = "Health Number", Default = false,
    Callback = function(v) config.ESPHealthNumber = v end
})
ESPBox:AddToggle("ESPWeaponT", {
    Text = "Held Weapon", Default = false,
    Callback = function(v) config.ESPHeldWeapon = v end
})
ESPBox:AddToggle("ESPSkeletonT", {
    Text = "Skeleton", Default = false,
    Callback = function(v) config.ESPSkeleton = v end
})
ESPBox:AddToggle("ESPTracerT", {
    Text = "Tracer", Default = false,
    Callback = function(v) config.ESPTracer = v end
})
ESPBox:AddDropdown("ESPTracerOrigin", {
    Text = "Tracer From",
    Values = {"Bottom", "Center", "Top", "Mouse"},
    Default = 1,
    Callback = function(v) config.ESPTracerOrigin = v end
})
ESPBox:AddDropdown("ESPTracerTarget", {
    Text = "Tracer To",
    Values = {"Feet", "Head"},
    Default = 1,
    Callback = function(v) config.ESPTracerTarget = v end
})
ESPBox:AddToggle("ESPHeadMarkerT", {
    Text = "Head Marker", Default = false,
    Callback = function(v) config.ESPHeadMarker = v end
})
ESPBox:AddDropdown("ESPHeadShape", {
    Text = "Head Shape",
    Values = {"Cross", "Circle"},
    Default = 1,
    Callback = function(v) config.ESPHeadMarkerShape = v end
})
ESPBox:AddToggle("ESPChamsT", {
    Text = "Chams", Default = false,
    Callback = function(v) config.ESPChams = v; config.ESPChamsEnabled = v end
})
ESPBox:AddToggle("ESPTeamCheckT", {
    Text = "Team Check", Default = false,
    Callback = function(v) config.ESPTeamCheck = v end
})
ESPBox:AddToggle("ESPDisplayNameT", {
    Text = "Use Display Name", Default = false,
    Callback = function(v) config.ESPUseDisplayName = v end
})

-- ==================== VISUALS: SPOOFERS (Kicia) ====================
local SpoofNameBox = Tabs.Visuals:AddLeftGroupbox("Name Spoof")
SpoofNameBox:AddToggle("SpoofMaster", {
    Text = "Enable Spoofers", Default = false,
    Callback = function(v)
        config.SpoofEnabled = v
        if v then StartAllSpoofs() else StopAllSpoofs() end
    end
})
SpoofNameBox:AddToggle("SpoofNameT", {
    Text = "Name", Default = false,
    Callback = function(v)
        config.SpoofMyName = v
        if v then config.SpoofEnabled = true end
        pcall(Spoof.refreshLocal)
    end
})
SpoofNameBox:AddInput("SpoofNameVal", {
    Text = "Name Value",
    Default = "shako.win",
    Placeholder = "Name...",
    Callback = function(v)
        config.SpoofMyNameValue = tostring(v or "")
        pcall(Spoof.refreshLocal)
    end
})
SpoofNameBox:AddToggle("SpoofDispT", {
    Text = "Display Name", Default = false,
    Callback = function(v)
        config.SpoofMyDisplayName = v
        if v then config.SpoofEnabled = true end
        pcall(Spoof.refreshLocal)
    end
})
SpoofNameBox:AddInput("SpoofDispVal", {
    Text = "Display Value",
    Default = "shako.win",
    Placeholder = "Display...",
    Callback = function(v)
        config.SpoofMyDisplayValue = tostring(v or "")
        pcall(Spoof.refreshLocal)
    end
})
SpoofNameBox:AddInput("SpoofUserVal", {
    Text = "Username (@)",
    Default = "",
    Placeholder = "optional @user",
    Callback = function(v)
        config.SpoofMyUserValue = tostring(v or "")
        pcall(Spoof.refreshLocal)
    end
})
SpoofNameBox:AddToggle("SpoofProfileUIT", {
    Text = "Profile UI", Default = true,
    Callback = function(v) config.SpoofProfileUI = v end
})

local SpoofDeviceBox = Tabs.Visuals:AddLeftGroupbox("Device Spoof")
SpoofDeviceBox:AddToggle("DeviceSpoofT", {
    Text = "Device Spoof", Default = false,
    Callback = function(v)
        config.DeviceSpoofEnabled = v
        if v then
            pcall(function() DeviceSpoof.enable() end)
        else
            pcall(function() DeviceSpoof.disable() end)
        end
    end
})
SpoofDeviceBox:AddDropdown("DeviceSpoofType", {
    Text = "Platform",
    Values = {"PC", "Mobile", "Console", "VR"},
    Default = 2,
    Callback = function(v)
        config.DeviceSpoofType = v
        if config.DeviceSpoofEnabled then
            pcall(function() DeviceSpoof.enable() end)
        end
    end
})

pcall(function()
    if addColor3 then
        addColor3(ESPBox, "ESPBoxColorPick", "Color ESP",
            function() return config.ESPBoxColor or Color3.fromRGB(255, 40, 40) end,
            function(c)
                config.ESPBoxColor = c
                config.ESPColor = c
            end, function() end)
    end
end)

ESPBox:AddToggle("ESPShowBox", {
    Text = "Box", Default = true,
    Callback = function(v) config.ESPShowBox = v; config.ESPBox = v end
})
ESPBox:AddDropdown("ESPBoxStyle", {
    Text = "Box Style",
    Values = {"Corner", "Full"},
    Default = 1,
    Callback = function(v) config.ESPBoxStyle = v end
})
ESPBox:AddSlider("ESPBoxThickness", {
    Text = "Box Thickness", Default = 1.5, Min = 1, Max = 4, Rounding = 1,
    Callback = function(v) config.ESPBoxThickness = v end
})
ESPBox:AddToggle("ESPSkeleton", {
    Text = "Skeleton", Default = true,
    Callback = function(v) config.ESPSkeleton = v end
})
ESPBox:AddToggle("ESPOutline", {
    Text = "Outline", Default = true,
    Callback = function(v) config.ESPOutline = v end
})
ESPBox:AddToggle("ESPShowName", {
    Text = "Name", Default = true,
    Callback = function(v) config.ESPShowName = v end
})
ESPBox:AddToggle("ESPShowDist", {
    Text = "Distance", Default = true,
    Callback = function(v) config.ESPShowDist = v end
})
ESPBox:AddToggle("ESPShowHP", {
    Text = "Health Bar", Default = true,
    Callback = function(v) config.ESPShowHP = v end
})
ESPBox:AddToggle("ESPShowHPText", {
    Text = "HP Text", Default = false,
    Callback = function(v) config.ESPShowHPText = v end
})
ESPBox:AddToggle("ESPTracers", {
    Text = "Tracers", Default = false,
    Callback = function(v) config.ESPTracers = v end
})
ESPBox:AddDropdown("ESPTracerFrom", {
    Text = "Tracer from",
    Values = {"Bottom", "Center", "Mouse"},
    Default = 1,
    Callback = function(v) config.ESPTracerFrom = v end
})
ESPBox:AddToggle("ESPChams", {
    Text = "Chams", Default = false,
    Callback = function(v) config.ESPChams = v end
})
ESPBox:AddToggle("ESPTeamCheck", {
    Text = "Team Check", Default = false,
    Callback = function(v) config.ESPTeamCheck = v end
})
ESPBox:AddToggle("ESPUseTeamColor", {
    Text = "Team Color", Default = false,
    Callback = function(v) config.ESPUseTeamColor = v end
})
ESPBox:AddToggle("ESPRainbow", {
    Text = "Rainbow", Default = false,
    Callback = function(v) config.ESPRainbow = v end
})
ESPBox:AddToggle("ESPIncludeNPCs", {
    Text = "Include NPCs", Default = false,
    Callback = function(v) config.ESPIncludeNPCs = v end
})
ESPBox:AddToggle("ESPInfiniteRange", {
    Text = "Infinite Range", Default = true,
    Callback = function(v) config.ESPInfiniteRange = v end
})
ESPBox:AddSlider("ESPMaxDist", {
    Text = "Max Dist", Default = 1500, Min = 100, Max = 5000, Rounding = 0,
    Callback = function(v) config.ESPMaxDist = v; config.ESPMaxDistance = v end
})
ESPBox:AddSlider("ESPSkeletonThickness", {
    Text = "Skeleton Thickness", Default = 2, Min = 1, Max = 5, Rounding = 0,
    Callback = function(v) config.ESPSkeletonThickness = v end
})
ESPBox:AddSlider("ESPBarWidth", {
    Text = "HP Bar Width", Default = 4, Min = 2, Max = 8, Rounding = 0,
    Callback = function(v) config.ESPBarWidth = v end
})
ESPBox:AddButton({
    Text = "Preset UE Style",
    Func = function()
        config.ESPEnabled = true
        config.ESPShowBox = true
        config.ESPBox = true
        config.ESPBoxStyle = "Corner"
        config.ESPBoxThickness = 1.5
        config.ESPSkeleton = true
        config.ESPOutline = true
        config.ESPShowName = true
        config.ESPShowDist = true
        config.ESPShowHP = true
        config.ESPShowHPText = false
        config.ESPFilledBox = true
        config.ESPTracers = false
        config.ESPChams = false
        config.ESPBoxColor = Color3.fromRGB(255, 255, 255)
        config.ESPColor = "White"
        config.ESPInfiniteRange = true
        config.ESPNameSize = 14
        pcall(StartESP)
        Notify("ESP", "UE Style ON")
    end
})
ESPBox:AddButton({
    Text = "Preset Red HvH",
    Func = function()
        config.ESPEnabled = true
        config.ESPShowBox = true
        config.ESPBox = true
        config.ESPBoxStyle = "Corner"
        config.ESPSkeleton = true
        config.ESPOutline = true
        config.ESPShowName = true
        config.ESPShowDist = true
        config.ESPShowHP = true
        config.ESPFilledBox = false
        config.ESPBoxColor = Color3.fromRGB(255, 40, 40)
        config.ESPColor = "Red"
        config.ESPInfiniteRange = true
        pcall(StartESP)
        Notify("ESP", "Red HvH ON")
    end
})

ESPBox:AddSlider("CharacterTransparency"
, {
    Text = "Tu transparencia", Default = 0, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) config.CharacterTransparency = v end
})
ESPBox:AddToggle("RemoveAccessories", {
    Text = "Quitar accesorios", Default = false,
    Callback = function(v) config.RemoveAccessories = v end
})

SkyBox = Tabs.World:AddLeftGroupbox("Skybox")
skyNames = {"None"}
pcall(function()
    for n in pairs(Skies or {}) do table.insert(skyNames, n) end
end)
-- AURORA presets
auroraNames = {}
pcall(function()
    local presets = getgenv()._ShakoSkyPresets
    if type(presets) == "table" then
        for n in pairs(presets) do
            if n ~= "None" then table.insert(auroraNames, "AURORA:" .. n) end
        end
        table.sort(auroraNames)
        for _, n in ipairs(auroraNames) do table.insert(skyNames, n) end
    end
end)
SkyBox:AddDropdown("SkySelect", {
    Text = "Cielo", Values = skyNames, Default = 1,
    Callback = function(v)
        if type(v) == "string" and v:sub(1,7) == "AURORA:" then
            local name = v:sub(8)
            local sd = getgenv()._ShakoSkyData
            if sd then sd.enabled = true; sd.selected = name end
            if getgenv()._ShakoApplySkybox then
                pcall(getgenv()._ShakoApplySkybox)
            end
            Notify("Sky", name)
        else
            pcall(ApplySky, v)
        end
    end
})
SkyBox:AddToggle("AuroraSkyEnable", {
    Text = "Sky Enabled", Default = false,
    Callback = function(v)
        local sd = getgenv()._ShakoSkyData
        if sd then sd.enabled = v end
        if v and getgenv()._ShakoApplySkybox then pcall(getgenv()._ShakoApplySkybox) end
        Notify("Sky", v and "ON" or "OFF")
    end
})
SkyBox:AddToggle("AuroraSkyRotate", {
    Text = "Auto Rotate", Default = false,
    Callback = function(v)
        if getgenv()._ShakoStartSkyRotate then pcall(getgenv()._ShakoStartSkyRotate, v) end
    end
})
SkyBox:AddSlider("AuroraSkyStars", {
    Text = "Stars", Default = 3000, Min = 0, Max = 5000, Rounding = 0,
    Callback = function(v)
        local sd = getgenv()._ShakoSkyData
        if sd then sd.star_count = v end
        if getgenv()._ShakoApplySkybox then pcall(getgenv()._ShakoApplySkybox) end
    end
})

WeatherBox = Tabs.World:AddRightGroupbox("Weather")
WeatherBox:AddToggle("WeatherEnabled", {
    Text = "Enable Weather", Default = false,
    Callback = function(v)
        config.WeatherEnabled = v
        if v then StartWeather() else StopWeather() end
    end
})
WeatherBox:AddDropdown("WeatherType", {
    Text = "Type",
    Values = {"Rain", "Snow", "Mist", "Embers", "Fireflies", "Petals", "Autumn", "Ash", "Sandstorm"},
    Default = 1,
    Callback = function(v)
        config.WeatherType = v
        pcall(function() if Weather and Weather.setType then Weather.setType(v) end end)
        if config.WeatherEnabled then StartWeather() end
    end
})
WeatherBox:AddSlider("WeatherIntensity", {
    Text = "Intensity", Default = 1, Min = 0.15, Max = 2, Rounding = 2,
    Callback = function(v)
        config.WeatherIntensity = v
        pcall(function() if Weather and Weather.setIntensity then Weather.setIntensity(v) end end)
    end
})
WeatherBox:AddSlider("WeatherSoundVolume", {
    Text = "Sound volume", Default = 0.6, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v)
        config.WeatherSoundVolume = v
        pcall(function() if Weather and Weather.setSoundVolume then Weather.setSoundVolume(v) end end)
    end
})
WeatherBox:AddToggle("WeatherStorm", {
    Text = "Storm (thunder)", Default = false,
    Callback = function(v)
        config.WeatherStorm = v
        pcall(function() if Weather and Weather.toggleStorm then Weather.toggleStorm(v) end end)
    end
})
WeatherBox:AddSlider("WeatherStormMin", {
    Text = "Storm interval min", Default = 8, Min = 1, Max = 30, Rounding = 0,
    Callback = function(v)
        config.WeatherStormMin = v
        pcall(function() if Weather and Weather.setStormMin then Weather.setStormMin(v) end end)
    end
})
WeatherBox:AddToggle("WeatherMeteors", {
    Text = "Meteors", Default = false,
    Callback = function(v)
        config.WeatherMeteors = v
        pcall(function() if Weather and Weather.toggleMeteors then Weather.toggleMeteors(v) end end)
    end
})
WeatherBox:AddSlider("WeatherMeteorRate", {
    Text = "Meteor rate", Default = 1, Min = 0.25, Max = 3, Rounding = 2,
    Callback = function(v)
        config.WeatherMeteorRate = v
        pcall(function() if Weather and Weather.setMeteorRate then Weather.setMeteorRate(v) end end)
    end
})
WeatherBox:AddToggle("WeatherShootingStars", {
    Text = "Shooting stars", Default = false,
    Callback = function(v)
        config.WeatherShootingStars = v
        pcall(function() if Weather and Weather.toggleShootingStars then Weather.toggleShootingStars(v) end end)
    end
})
WeatherBox:AddSlider("WeatherStarRate", {
    Text = "Star rate", Default = 1, Min = 0.25, Max = 3, Rounding = 2,
    Callback = function(v)
        config.WeatherStarRate = v
        pcall(function() if Weather and Weather.setStarRate then Weather.setStarRate(v) end end)
    end
})
WeatherBox:AddToggle("WeatherPuddles", {
    Text = "Puddles", Default = false,
    Callback = function(v)
        config.WeatherPuddles = v
        pcall(function() if Weather and Weather.togglePuddles then Weather.togglePuddles(v) end end)
    end
})
WeatherBox:AddToggle("WeatherMood", {
    Text = "Mood lighting", Default = false,
    Callback = function(v)
        config.WeatherMood = v
        pcall(function() if Weather and Weather.toggleMood then Weather.toggleMood(v) end end)
    end
})
WeatherBox:AddToggle("WeatherClockDial", {
    Text = "Clock dial", Default = false,
    Callback = function(v)
        config.WeatherClockDial = v
        pcall(function() if Weather and Weather.toggleClock then Weather.toggleClock(v) end end)
    end
})
WeatherBox:AddToggle("WeatherRainbow", {
    Text = "Rainbow", Default = false,
    Callback = function(v)
        config.WeatherRainbow = v
        pcall(function() if Weather and Weather.toggleRainbow then Weather.toggleRainbow(v) end end)
    end
})
WeatherBox:AddToggle("WeatherGodRays", {
    Text = "God rays", Default = false,
    Callback = function(v)
        config.WeatherGodRays = v
        pcall(function() if Weather and Weather.toggleGodRays then Weather.toggleGodRays(v) end end)
    end
})
WeatherBox:AddDropdown("SkyboxPreset", {
    Text = "Skybox preset",
    Values = {"Off", "Space", "Sunset", "Clouds", "Storm", "Winter", "Vaporwave"},
    Default = 1,
    Callback = function(v)
        config.SkyboxPreset = v
        pcall(function() if Weather and Weather.setSkybox then Weather.setSkybox(v) end end)
    end
})





-- ==================== HARION CROSSHAIR UI ====================
CrossBox = Tabs.Visual:AddRightGroupbox("crosshair")
CrossBox:AddToggle("Crosshair", {
    Text = "enabled", Default = false,
    Callback = function(v)
        config.Crosshair = v
        if v then StartCrosshair() else StopCrosshair() end
    end
})
pcall(function()
    if addColor3 then
        addColor3(CrossBox, "CrosshairColorPick", "color",
            function() return config.CrosshairColor or Color3.fromRGB(255, 255, 255) end,
            function(c) config.CrosshairColor = c end, function() end)
        addColor3(CrossBox, "CrosshairOutlineColorPick", "outline color",
            function() return config.CrosshairOutlineColor or Color3.fromRGB(0, 0, 0) end,
            function(c) config.CrosshairOutlineColor = c end, function() end)
    end
end)
CrossBox:AddToggle("CrosshairOutline", {
    Text = "outline", Default = true,
    Callback = function(v) config.CrosshairOutline = v end
})
CrossBox:AddToggle("CrosshairSpin", {
    Text = "Spin", Default = true,
    Callback = function(v) config.CrosshairSpin = v end
})
CrossBox:AddSlider("CrosshairRotation", {
    Text = "rotation", Default = 0, Min = 0, Max = 360, Rounding = 0,
    Callback = function(v) config.CrosshairRotation = v end
})
CrossBox:AddSlider("CrosshairSpinSpeed", {
    Text = "spin speed", Default = 1.2, Min = 0, Max = 8, Rounding = 1,
    Callback = function(v) config.CrosshairSpinSpeed = v end
})
CrossBox:AddSlider("CrosshairBounce", {
    Text = "bounce", Default = 0, Min = 0, Max = 50, Rounding = 0,
    Callback = function(v) config.CrosshairBounce = v end
})
CrossBox:AddSlider("CrosshairBounceSpeed", {
    Text = "bounce speed", Default = 1, Min = 0, Max = 5, Rounding = 1,
    Callback = function(v) config.CrosshairBounceSpeed = v end
})
CrossBox:AddSlider("CrosshairGap", {
    Text = "offset", Default = 8, Min = 0, Max = 50, Rounding = 0,
    Callback = function(v) config.CrosshairGap = v end
})
CrossBox:AddSlider("CrosshairSize", {
    Text = "length", Default = 23, Min = 2, Max = 80, Rounding = 0,
    Callback = function(v) config.CrosshairSize = v end
})
CrossBox:AddSlider("CrosshairThickness", {
    Text = "thickness", Default = 2, Min = 1, Max = 10, Rounding = 0,
    Callback = function(v) config.CrosshairThickness = v end
})
CrossBox:AddDropdown("CrosshairPosition", {
    Text = "position",
    Values = { "center", "position on target", "position on barrel" },
    Default = 1,
    Callback = function(v) config.CrosshairPosition = v end
})
CrossBox:AddToggle("DisableGameCrosshair", {
    Text = "disable game crosshair", Default = false,
    Callback = function(v) config.DisableGameCrosshair = v end
})

-- ==================== OVERRIDE (Harion) ====================

-- ==================== UNLOCK ALL (Rivals Skinchanger) ====================
UnlockBox = Tabs.Visual:AddLeftGroupbox("unlock")
UnlockBox:AddToggle("UnlockAll", {
    Text = "unlock all",
    Default = false,
    Tooltip = "Desbloquea todas las skins/charms/wraps localmente (sin lag)",
    Callback = function(v)
        config.UnlockAll = v
        if v then
            pcall(function()
                if type(StartUnlockAll) == "function" then StartUnlockAll() end
            end)
        else
            -- hooks se quedan (seguro); solo deja de forzar owns en runtime si aplica
            pcall(function()
                if type(StopUnlockAll) == "function" then StopUnlockAll() end
            end)
        end
        pcall(function()
            if Library and Library.Notify then
                Library:Notify(v and "Unlock All ON" or "Unlock All OFF", 2)
            end
        end)
    end
})

-- ==================== VIEWMODEL (Harion) ====================
ViewmodelBox = Tabs.Visual:AddLeftGroupbox("viewmodel")
ViewmodelBox:AddToggle("VMOverrideFps", {
    Text = "override fps", Default = false,
    Callback = function(v) config.VMOverrideFps = v end
})
ViewmodelBox:AddSlider("VMFps", {
    Text = "fps", Default = 60, Min = 1, Max = 240, Rounding = 0,
    Callback = function(v) config.VMFps = v end
})
ViewmodelBox:AddSlider("VMRecoil", {
    Text = "recoil percent", Default = 100, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.VMRecoil = v end
})
ViewmodelBox:AddToggle("VMChams", {
    Text = "chams", Default = false,
    Callback = function(v)
        config.VMChams = v
        if not v then
            pcall(function()
                local Vis2 = getgenv()._ShakoVisMain
                if Vis2 and Vis2.highlights then
                    for _, h in pairs(Vis2.highlights) do
                        pcall(function() h:Destroy() end)
                    end
                    Vis2.highlights = {}
                end
            end)
        end
    end
})
pcall(function()
    if addColor3 then
        addColor3(ViewmodelBox, "VMChamsColorPick", "chams color",
            function() return config.VMChamsColor or Color3.fromRGB(255, 255, 255) end,
            function(c) config.VMChamsColor = c end, function() end)
    end
end)
ViewmodelBox:AddSlider("VMChamFill", {
    Text = "fill transparency", Default = 2, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.VMChamFill = v end
})
ViewmodelBox:AddSlider("VMChamOutline", {
    Text = "outline transparency", Default = 1, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.VMChamOutline = v end
})
ViewmodelBox:AddToggle("VMOffset", {
    Text = "offset", Default = false,
    Callback = function(v) config.VMOffset = v end
})
ViewmodelBox:AddSlider("VMOffsetX", {
    Text = "offset X", Default = 0, Min = -5, Max = 5, Rounding = 1,
    Callback = function(v) config.VMOffsetX = v end
})
ViewmodelBox:AddSlider("VMOffsetY", {
    Text = "offset Y", Default = 0, Min = -5, Max = 5, Rounding = 1,
    Callback = function(v) config.VMOffsetY = v end
})
ViewmodelBox:AddSlider("VMOffsetZ", {
    Text = "offset Z", Default = 0, Min = -5, Max = 5, Rounding = 1,
    Callback = function(v) config.VMOffsetZ = v end
})

OverrideBox = Tabs.Visual:AddLeftGroupbox("override")
OverrideBox:AddToggle("VMAppearance", {
    Text = "viewmodel appearance", Default = false,
    Callback = function(v) config.VMAppearance = v end
})
pcall(function()
    if addColor3 then
        addColor3(OverrideBox, "VMColorPick", "color",
            function() return config.VMColor or Color3.fromRGB(255, 255, 255) end,
            function(c) config.VMColor = c end, function() end)
    end
end)
OverrideBox:AddDropdown("VMMaterial", {
    Text = "material",
    Values = { "ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Metal" },
    Default = 1,
    Callback = function(v) config.VMMaterial = v end
})
OverrideBox:AddToggle("VMWireframe", {
    Text = "wireframe", Default = false,
    Callback = function(v)
        config.VMWireframe = v
        if not v then
            pcall(function()
                local H = getgenv()._ShakoVis
                if H and H.wires then
                    for _, w in pairs(H.wires) do pcall(function() w:Destroy() end) end
                    table.clear(H.wires)
                end
            end)
        end
    end
})
OverrideBox:AddToggle("VMDisableTextures", {
    Text = "disable textures", Default = false,
    Callback = function(v) config.VMDisableTextures = v end
})
OverrideBox:AddSlider("VMTransparency", {
    Text = "transparency", Default = 100, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.VMTransparency = v end
})
OverrideBox:AddToggle("ArmAppearance", {
    Text = "arm appearance", Default = false,
    Callback = function(v) config.ArmAppearance = v end
})
pcall(function()
    if addColor3 then
        addColor3(OverrideBox, "ArmColorPick", "arm color",
            function() return config.ArmColor or Color3.fromRGB(255, 255, 255) end,
            function(c) config.ArmColor = c end, function() end)
    end
end)
OverrideBox:AddDropdown("ArmMaterial", {
    Text = "arm material",
    Values = { "ForceField", "Neon", "Glass", "SmoothPlastic", "Plastic", "Metal" },
    Default = 1,
    Callback = function(v) config.ArmMaterial = v end
})
OverrideBox:AddToggle("ArmDisableClothes", {
    Text = "disable clothes", Default = false,
    Callback = function(v) config.ArmDisableClothes = v end
})
OverrideBox:AddSlider("ArmTransparency", {
    Text = "arm transparency", Default = 100, Min = 0, Max = 100, Rounding = 0,
    Callback = function(v) config.ArmTransparency = v end
})

-- ==================== ITEM (Harion) ====================
ItemBox = Tabs.Visual:AddRightGroupbox("item")
ItemBox:AddToggle("RemoveVignette", {
    Text = "remove vignette", Default = false,
    Callback = function(v) config.RemoveVignette = v end
})
ItemBox:AddToggle("OverrideWeaponStatus", {
    Text = "override weapon status", Default = false,
    Callback = function(v) config.OverrideWeaponStatus = v end
})
ItemBox:AddDropdown("WeaponStatus", {
    Text = "status",
    Values = { "Prime", "Contraband" },
    Default = 1,
    Callback = function(v) config.WeaponStatus = v end
})



-- Body Aura UI
pcall(function()
    local box = Tabs.Visual:AddRightGroupbox("body aura")
    box:AddToggle("BodyAuraEnabled", {
        Text = "Body Aura", Default = false,
        Callback = function(v)
            config.BodyAuraEnabled = v
            if v then
                local f = getgenv()._ShakoStartBodyAura
                if type(f) == "function" then f() elseif StartBodyAura then StartBodyAura() end
            else
                local f = getgenv()._ShakoStopBodyAura
                if type(f) == "function" then f() elseif StopBodyAura then StopBodyAura() end
            end
        end
    })
    box:AddSlider("BodyAuraRate", {
        Text = "Aura Rate", Default = 28, Min = 5, Max = 60, Rounding = 0,
        Callback = function(v)
            config.BodyAuraRate = v
            if config.BodyAuraEnabled then
                local f = getgenv()._ShakoApplyBodyAura
                if type(f) == "function" then f() end
            end
        end
    })
end)

-- ==================== XRAY (Harion) ====================
XRayBox = Tabs.Visual:AddLeftGroupbox("xray")
XRayBox:AddToggle("XRayEnabled", {
    Text = "X-Ray", Default = false,
    Callback = function(v)
        config.XRayEnabled = v
        pcall(function() applyXRay(v) end)
    end
})
XRayBox:AddSlider("XRayTransparency", {
    Text = "Transparency", Default = 0.5, Min = 0.1, Max = 0.95, Rounding = 2,
    Callback = function(v)
        config.XRayTransparency = v
        if config.XRayEnabled then pcall(function() applyXRay(true) end) end
    end
})


-- ==================== AMBIENT SOUNDS (relajantes) ====================
-- IDs públicos que suelen cargar (si uno falla, se prueba el fallback)
AMBIENT_SOUNDS = {
    ["Rain"]         = { "rbxassetid://1516791621", "rbxassetid://5114135799", "rbxassetid://6066411733" },
    ["Heavy Rain"]   = { "rbxassetid://5114135799", "rbxassetid://1516791621", "rbxassetid://6066411733" },
    ["Thunder"]      = { "rbxassetid://1516791621", "rbxassetid://5114135799" },
    ["Forest"]       = { "rbxassetid://3472701279", "rbxassetid://3422304783", "rbxassetid://224851262" },
    ["Birds"]        = { "rbxassetid://3472701279", "rbxassetid://3422304783" },
    ["Wind"]         = { "rbxassetid://224851262", "rbxassetid://336142745", "rbxassetid://5987864649" },
    ["Ocean"]        = { "rbxassetid://166475216", "rbxassetid://4792901531", "rbxassetid://5987864649" },
    ["Campfire"]     = { "rbxassetid://317656970", "rbxassetid://4601689861" },
    ["Night"]        = { "rbxassetid://3458023152", "rbxassetid://3472701279", "rbxassetid://5987864649" },
    ["River"]        = { "rbxassetid://166475216", "rbxassetid://4792901531" },
    ["Soft Piano"]   = { "rbxassetid://1845554019", "rbxassetid://1837829205" },
    ["LoFi"]         = { "rbxassetid://9043887091", "rbxassetid://1845554019" },
    ["Rain Classic"] = { "rbxassetid://1516791621" },
    ["Wind Classic"] = { "rbxassetid://224851262" },
    ["Fire Classic"] = { "rbxassetid://317656970" },
}

ambientSoundObj = nil
ambientToken = 0

function stopAmbientSound()
    ambientToken = ambientToken + 1 -- cancela waits pendientes
    config.AmbientSoundEnabled = false
    -- parar el objeto actual
    if ambientSoundObj then
        pcall(function() ambientSoundObj:Stop() end)
        pcall(function() ambientSoundObj.Volume = 0 end)
        pcall(function() ambientSoundObj:Destroy() end)
        ambientSoundObj = nil
    end
    -- limpiar TODOS los ShakoAmbient (por si quedaron clones)
    pcall(function()
        for _, parent in ipairs({ SoundService, workspace, LocalPlayer:FindFirstChild("PlayerGui") }) do
            if not parent then continue end
            for _, s in ipairs(parent:GetDescendants()) do
                if s:IsA("Sound") and (s.Name == "ShakoAmbient" or s.Name:find("ShakoAmbient", 1, true)) then
                    pcall(function() s:Stop() end)
                    pcall(function() s.Volume = 0 end)
                    pcall(function() s:Destroy() end)
                end
            end
            for _, s in ipairs(parent:GetChildren()) do
                if s:IsA("Sound") and s.Name == "ShakoAmbient" then
                    pcall(function() s:Stop() end)
                    pcall(function() s:Destroy() end)
                end
            end
        end
    end)
    -- también en Character HRP
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, s in ipairs(char:GetDescendants()) do
                if s:IsA("Sound") and s.Name == "ShakoAmbient" then
                    pcall(function() s:Stop() s:Destroy() end)
                end
            end
        end
    end)
end

function playAmbientSound()
    -- stop limpio sin apagar el flag (play lo vuelve a poner)
    local wasOn = true
    local tok = ambientToken + 1
    ambientToken = tok
    if ambientSoundObj then
        pcall(function() ambientSoundObj:Stop() end)
        pcall(function() ambientSoundObj:Destroy() end)
        ambientSoundObj = nil
    end
    pcall(function()
        for _, s in ipairs(SoundService:GetChildren()) do
            if s:IsA("Sound") and s.Name == "ShakoAmbient" then
                pcall(function() s:Stop() s:Destroy() end)
            end
        end
    end)

    if not config.AmbientSoundEnabled then return end

    local name = config.AmbientSoundType or "Rain"
    local list = AMBIENT_SOUNDS[name] or AMBIENT_SOUNDS["Rain"]
    if type(list) == "string" then list = { list } end

    local vol = math.clamp(tonumber(config.AmbientSoundVolume) or 0.45, 0, 2)
    local pitch = math.clamp(tonumber(config.AmbientSoundPitch) or 1, 0.5, 1.5)

    function tryId(uri)
        if ambientToken ~= tok then return false end
        local s = Instance.new("Sound")
        s.Name = "ShakoAmbient"
        s.SoundId = uri
        s.Looped = true
        s.Volume = vol
        s.PlaybackSpeed = pitch
        s.PlayOnRemove = false
        pcall(function()
            s.RollOffMode = Enum.RollOffMode.Linear
            s.RollOffMaxDistance = 100000
            s.RollOffMinDistance = 10000
        end)
        s.Parent = SoundService
        -- NO usar PlayLocalSound (crea instancia que no se puede stoppear fácil)
        local okPlay = pcall(function() s:Play() end)
        ambientSoundObj = s

        -- esperar carga
        local t0 = tick()
        while ambientToken == tok and s.Parent and not s.IsLoaded and (tick() - t0) < 2.5 do
            task.wait(0.05)
        end
        if ambientToken ~= tok then
            pcall(function() s:Stop() s:Destroy() end)
            return false
        end
        -- si cargó o está sonando
        if s.IsLoaded or s.IsPlaying or (s.TimeLength and s.TimeLength > 0) then
            if not s.IsPlaying then pcall(function() s:Play() end) end
            return true
        end
        -- falló este id
        pcall(function() s:Stop() s:Destroy() end)
        if ambientSoundObj == s then ambientSoundObj = nil end
        return false
    end

    task.spawn(function()
        for _, uri in ipairs(list) do
            if ambientToken ~= tok then return end
            if tryId(uri) then
                return
            end
        end
        -- último recurso: rain clásico
        if ambientToken == tok and config.AmbientSoundEnabled then
            tryId("rbxassetid://1516791621")
        end
    end)
end

function StartAmbientSound()
    config.AmbientSoundEnabled = true
    playAmbientSound()
end

function StopAmbientSound()
    stopAmbientSound()
    Notify("Ambient", "OFF")
end

function SetAmbientVolume(v)
    config.AmbientSoundVolume = v
    if ambientSoundObj and ambientSoundObj.Parent then
        pcall(function() ambientSoundObj.Volume = math.clamp(tonumber(v) or 0.45, 0, 2) end)
    end
end

AmbientBox = Tabs.World:AddLeftGroupbox("Ambient")
AmbientBox:AddToggle("AmbientSoundEnabled", {
    Text = "Ambient Sound", Default = false,
    Callback = function(v)
        if v then
            StartAmbientSound()
            Notify("Ambient", "ON · " .. tostring(config.AmbientSoundType or "Rain"))
        else
            StopAmbientSound()
        end
    end
})
AmbientBox:AddDropdown("AmbientSoundType", {
    Text = "Tipo",
    Values = {"Rain", "Heavy Rain", "Thunder", "Forest", "Birds", "Wind", "Ocean", "Campfire", "Night", "River", "Soft Piano", "LoFi", "Rain Classic", "Wind Classic", "Fire Classic"},
    Default = 1,
    Callback = function(v)
        config.AmbientSoundType = v
        if config.AmbientSoundEnabled then
            playAmbientSound()
        end
    end
})
AmbientBox:AddSlider("AmbientSoundVolume", {
    Text = "Volumen", Default = 0.45, Min = 0.05, Max = 1.5, Rounding = 2,
    Callback = function(v) SetAmbientVolume(v) end
})
AmbientBox:AddSlider("AmbientSoundPitch", {
    Text = "Pitch", Default = 1, Min = 0.6, Max = 1.4, Rounding = 2,
    Callback = function(v)
        config.AmbientSoundPitch = v
        if ambientSoundObj and ambientSoundObj.Parent then
            pcall(function() ambientSoundObj.PlaybackSpeed = v end)
        end
    end
})
AmbientBox:AddButton({
    Text = "Play / Restart",
    Func = function()
        config.AmbientSoundEnabled = true
        playAmbientSound()
        Notify("Ambient", tostring(config.AmbientSoundType or "Rain"))
    end
})
AmbientBox:AddButton({
    Text = "Stop",
    Func = function()
        StopAmbientSound()
    end
})
AmbientBox:AddLabel("Stop ahora sí corta · varios IDs por tipo")


EmoteBox = Tabs.Character:AddLeftGroupbox("emotes")
EmoteBox:AddDropdown("EmotePreset", {
    Text = "Preset",
    Values = {"Floss", "Orange Justice", "Take The L", "Default Dance", "Electro Shuffle", "Fresh", "Robot", "Hype", "Dab", "Laugh", "Wave", "Gangnam", "Shuffle", "Breakdance", "Twist", "Zombie", "Custom A", "Custom B", "Custom C", "Custom D", "Custom E", "Custom F", "Custom G", "Custom H", "Custom I", "Custom J", "Custom K", "Custom L", "Custom"},
    Default = 1,
    Callback = function(v)
        config.EmoteName = v
        if v ~= "Custom" and EMOTES and EMOTES[v] then
            config.EmoteId = tostring(EMOTES[v])
        end
        -- solo guarda el ID; NO reproduce solo (usa Play)
    end
})
EmoteBox:AddInput("EmoteIdInput", {
    Text = "Animation ID (custom)",
    Default = "5917459365",
    Finished = true,
    Callback = function(v)
        config.EmoteId = tostring(v):gsub("%D", "")
        config.EmoteName = "Custom"
        -- no auto play al escribir ID
    end
})
EmoteBox:AddSlider("EmoteSpeed", {
    Text = "Velocidad emote", Default = 1, Min = 0.1, Max = 10, Rounding = 1,
    Callback = function(v)
        config.EmoteSpeed = tonumber(v) or 1
        -- aplica al instante al track actual
        pcall(function()
            if getgenv()._ShakoEmote.track then
                getgenv()._ShakoEmote.track:AdjustSpeed(config.EmoteSpeed)
                -- algunos tracks ignoran AdjustSpeed si no están playing
                if getgenv()._ShakoEmote.track.IsPlaying then
                    getgenv()._ShakoEmote.track:Play(0, 1, config.EmoteSpeed)
                end
            end
        end)
    end
})
EmoteBox:AddToggle("EmoteAlwaysOn", {
    Text = "Always on (auto loop)", Default = false,
    Callback = function(v)
        config.EmoteAlwaysOn = v
        config.EmoteKeepPlaying = v
        config.EmoteLoop = v
        if v and config.EmoteId then
            PlayEmote(config.EmoteId, config.EmoteSpeed)
        elseif not v then
            StopEmote()
        end
    end
})
EmoteBox:AddButton({
    Text = "Play / Restart",
    Func = function()
        local id = config.EmoteId
        if (not id or id == "") and config.EmoteName and EMOTES[config.EmoteName] then
            id = EMOTES[config.EmoteName]
        end
        PlayEmote(id, config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Stop Emote",
    Func = function() StopEmote() end
})
EmoteBox:AddLabel("Siempre loop · se mantiene al caminar/respawn")
EmoteBox:AddButton({
    Text = "Play Custom A (86329...)",
    Func = function()
        config.EmoteId = "86329197824055"
        config.EmoteName = "Custom A"
        PlayEmote("86329197824055", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom B (91729...)",
    Func = function()
        config.EmoteId = "91729309021707"
        config.EmoteName = "Custom B"
        PlayEmote("91729309021707", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom C (133811...)",
    Func = function()
        config.EmoteId = "133811691098518"
        config.EmoteName = "Custom C"
        PlayEmote("133811691098518", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom D (133375...)",
    Func = function()
        config.EmoteId = "133375187065498"
        config.EmoteName = "Custom D"
        PlayEmote("133375187065498", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom E (130601...)",
    Func = function()
        config.EmoteId = "130601328561804"
        config.EmoteName = "Custom E"
        PlayEmote("130601328561804", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom F (129571...)",
    Func = function()
        config.EmoteId = "129571341119376"
        config.EmoteName = "Custom F"
        PlayEmote("129571341119376", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom G (79902...)",
    Func = function()
        config.EmoteId = "79902725961872"
        config.EmoteName = "Custom G"
        PlayEmote("79902725961872", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom H (119060...)",
    Func = function()
        config.EmoteId = "119060168059843"
        config.EmoteName = "Custom H"
        PlayEmote("119060168059843", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom I (82995...)",
    Func = function()
        config.EmoteId = "82995540773684"
        config.EmoteName = "Custom I"
        PlayEmote("82995540773684", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom J (78224...)",
    Func = function()
        config.EmoteId = "78224683906191"
        config.EmoteName = "Custom J"
        PlayEmote("78224683906191", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom K (73562...)",
    Func = function()
        config.EmoteId = "73562814360939"
        config.EmoteName = "Custom K"
        PlayEmote("73562814360939", config.EmoteSpeed)
    end
})
EmoteBox:AddButton({
    Text = "Play Custom L (88425...)",
    Func = function()
        config.EmoteId = "88425531063616"
        config.EmoteName = "Custom L"
        PlayEmote("88425531063616", config.EmoteSpeed)
    end
})



AUBox = Tabs.Misc:AddLeftGroupbox("ue counter")
togUE = AUBox:AddToggle("UECounterToggle", {
    Text = "UE Counter", Default = false,
    Callback = function(v)
        config.UECounterEnabled = v
        config.AntiUnnamed = v
        if v then
            StartUECounter()
            StartAUWatcher()
        else
            StopUECounter()
        end
    end
})
bindKey(togUE, "UECounterKey", "...")

AUBox:AddSlider("UECounterY", {
    Text = "Y distance", Default = 500, Min = 100, Max = 1000, Rounding = 0,
    Callback = function(v) config.UECounterY = v end
})
AUBox:AddSlider("UECounterCooldown", {
    Text = "Teleport cooldown", Default = 0.2, Min = 0, Max = 1, Rounding = 2,
    Callback = function(v) config.UECounterCooldown = v end
})


DefBox = Tabs.Misc:AddLeftGroupbox("defense")
DefBox:AddToggle("HurtEvade", {
    Text = "Hurt Evade (al recibir dmg)", Default = false,
    Callback = function(v)
        config.HurtEvade = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("HurtEvadeDist", {
    Text = "Hurt Evade Dist", Default = 18, Min = 5, Max = 150, Rounding = 0,
    Callback = function(v) config.HurtEvadeDist = v end
})
DefBox:AddToggle("NearEnemyEvade", {
    Text = "Evade si enemy cerca", Default = false,
    Callback = function(v)
        config.NearEnemyEvade = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("NearEnemyDist", {
    Text = "Near Dist", Default = 8, Min = 3, Max = 25, Rounding = 0,
    Callback = function(v) config.NearEnemyDist = v end
})
DefBox:AddToggle("AntiMeleeEnabled", {
    Text = "Anti Melee / body", Default = false,
    Callback = function(v) config.AntiMeleeEnabled = v end
})
DefBox:AddSlider("AntiMeleeRange", {
    Text = "Anti Melee Range", Default = 7, Min = 3, Max = 80, Rounding = 0,
    Callback = function(v) config.AntiMeleeRange = v end
})
DefBox:AddToggle("AntiUEClose", {
    Text = "Anti UE Close (push lejos)", Default = false,
    Callback = function(v)
        config.AntiUEClose = v
        if v then StartDefense() end
    end
})
DefBox:AddSlider("AntiUECloseDist", {
    Text = "UE Close Dist", Default = 35, Min = 10, Max = 120, Rounding = 0,
    Callback = function(v) config.AntiUECloseDist = v end
})
DefBox:AddSlider("AntiUEClosePush", {
    Text = "UE Close Push", Default = 80, Min = 20, Max = 200, Rounding = 0,
    Callback = function(v) config.AntiUEClosePush = v end
})
DefBox:AddToggle("AntiUEPeek", {
    Text = "Anti UE Peek (side hop)", Default = false,
    Callback = function(v)
        config.AntiUEPeek = v
        if v then StartDefense() end
    end
})
DefBox:AddToggle("DesyncSpam", {
    Text = "Desync Spam (anti hit)", Default = false,
    Callback = function(v)
        config.DesyncSpam = v
        if v then StartDefense() end
    end
})
DefBox:AddSlider("DesyncSpamPower", {
    Text = "Desync Spam Power", Default = 8, Min = 2, Max = 20, Rounding = 0,
    Callback = function(v) config.DesyncSpamPower = v end
})
DefBox:AddToggle("AdaptiveDesync", {
    Text = "Adaptive Desync (micro move)", Default = false,
    Callback = function(v)
        config.AdaptiveDesync = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
        Notify("Defense", v and "Adaptive ON" or "Adaptive OFF")
    end
})
DefBox:AddSlider("AdaptiveDesyncPower", {
    Text = "Desync Power", Default = 6, Min = 1, Max = 20, Rounding = 0,
    Callback = function(v) config.AdaptiveDesyncPower = v end
})
DefBox:AddToggle("VelocityBreak", {
    Text = "Velocity Break", Default = false,
    Callback = function(v) config.VelocityBreak = v end
})
DefBox:AddSlider("VelocityBreakMax", {
    Text = "Max Velocity", Default = 140, Min = 60, Max = 300, Rounding = 0,
    Callback = function(v) config.VelocityBreakMax = v end
})
DefBox:AddToggle("LowHPPanic", {
    Text = "Low HP Panic", Default = false,
    Callback = function(v) config.LowHPPanic = v end
})
DefBox:AddSlider("LowHPThreshold", {
    Text = "Low HP %", Default = 30, Min = 5, Max = 80, Rounding = 0,
    Callback = function(v) config.LowHPThreshold = v end
})
DefBox:AddToggle("RandomMicroMove", {
    Text = "Random Micro Move", Default = false,
    Callback = function(v)
        config.RandomMicroMove = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddDivider()
DefBox:AddLabel("—— Anti-Rager ——")
DefBox:AddToggle("RagerCombo", {
    Text = "Rager Combo (preset)", Default = false,
    Callback = function(v)
        config.RagerCombo = v
        if v then
            config.OrbitEvade = true
            config.HeightJitter = true
            config.AntiHeadTP = true
            config.StrafePattern = true
            config.VelocityBreak = true
            config.DesyncSpam = true
            config.HurtEvade = true
            StartDefense()
            Notify("HVH", "Rager Combo ON")
        else
            if anyDefenseOn() then StartDefense() else StopDefense() end
            Notify("HVH", "Rager Combo OFF")
        end
    end
})
DefBox:AddToggle("OrbitEvade", {
    Text = "Orbit Evade (rompe head-TP)", Default = false,
    Callback = function(v)
        config.OrbitEvade = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("OrbitEvadeRadius", {
    Text = "Orbit Radius", Default = 12, Min = 4, Max = 40, Rounding = 0,
    Callback = function(v) config.OrbitEvadeRadius = v end
})
DefBox:AddSlider("OrbitEvadeSpeed", {
    Text = "Orbit Speed", Default = 8, Min = 2, Max = 25, Rounding = 0,
    Callback = function(v) config.OrbitEvadeSpeed = v end
})
DefBox:AddToggle("HeightJitter", {
    Text = "Height Jitter (anti aim)", Default = false,
    Callback = function(v)
        config.HeightJitter = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("HeightJitterAmount", {
    Text = "Height Amount", Default = 6, Min = 1, Max = 20, Rounding = 0,
    Callback = function(v) config.HeightJitterAmount = v end
})
DefBox:AddToggle("AntiHeadTP", {
    Text = "Anti Head-TP (si están arriba)", Default = false,
    Callback = function(v)
        config.AntiHeadTP = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("AntiHeadTPPush", {
    Text = "Head-TP Push", Default = 35, Min = 10, Max = 100, Rounding = 0,
    Callback = function(v) config.AntiHeadTPPush = v end
})
DefBox:AddToggle("StrafePattern", {
    Text = "Strafe Pattern (A-D)", Default = false,
    Callback = function(v)
        config.StrafePattern = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("StrafePatternDist", {
    Text = "Strafe Dist", Default = 10, Min = 3, Max = 30, Rounding = 0,
    Callback = function(v) config.StrafePatternDist = v end
})
DefBox:AddToggle("FakePeek", {
    Text = "Fake Peek (lado y vuelve)", Default = false,
    Callback = function(v)
        config.FakePeek = v
        if anyDefenseOn() then StartDefense() else StopDefense() end
    end
})
DefBox:AddSlider("FakePeekDist", {
    Text = "Peek Dist", Default = 18, Min = 5, Max = 50, Rounding = 0,
    Callback = function(v) config.FakePeekDist = v end
})
DefBox:AddLabel("Combo + Orbit + Height = mejor vs ragers")

AABox = Tabs.Character:AddRightGroupbox("Anti Aim")
AABox:AddToggle("AntiAimToggle", {
    Text = "Enable", Default = false,
    Callback = function(v)
        config.AntiAimEnabled = v
        if v then StartAntiAim() else StopAntiAim() end
    end
})
AABox:AddDropdown("AAPitchMode", {
    Text = "Pitch",
    Values = {"disabled", "up", "down", "zero", "random", "strong"},
    Default = "down",
    Callback = function(v)
        config.AAPitchMode = v
        if getgenv()._ShakoAntiAimPoseConfig then getgenv()._ShakoAntiAimPoseConfig.pitch = v end
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.pitch = v end
    end
})
AABox:AddDropdown("AAYawMode", {
    Text = "Yaw",
    Values = {"disabled", "backwards", "spin", "random", "jitter", "side", "opposite", "strong"},
    Default = 5, -- jitter
    Callback = function(v)
        config.AAYawMode = v
        if getgenv()._ShakoAntiAimPoseConfig then getgenv()._ShakoAntiAimPoseConfig.yaw = v end
        if _G.AntiAimPoseConfig then _G.AntiAimPoseConfig.yaw = v end
    end
})
AABox:AddSlider("AAPitchOffset", {
    Text = "Pitch Offset", Default = 250, Min = 0, Max = 360, Rounding = 0,
    Callback = function(v) config.AAPitchOffset = v end
})
AABox:AddSlider("AAPitchAngle", {
    Text = "Pitch Angle (°)", Default = 0, Min = -180, Max = 180, Rounding = 0,
    Callback = function(v) config.AAPitchAngle = v end
})
AABox:AddSlider("AAYawAngle", {
    Text = "Yaw Angle (°)", Default = 180, Min = 0, Max = 360, Rounding = 0,
    Callback = function(v)
        config.AAYawAngle = tonumber(v) or 180
        if getgenv()._ShakoAntiAimPoseConfig then
            getgenv()._ShakoAntiAimPoseConfig.yawAngle = config.AAYawAngle
        end
        -- jitter amount sigue el yaw angle si no se tocó aparte
        if not config.AAJitterAmount or config.AAJitterAmount == 90 then
            config.AAJitterAmount = v
        end
    end
})
AABox:AddSlider("AAJitterAmount", {
    Text = "Jitter Amount (°)", Default = 90, Min = 15, Max = 180, Rounding = 0,
    Callback = function(v) config.AAJitterAmount = v end
})
AABox:AddSlider("AASpinRate", {
    Text = "Spin Rate", Default = 720, Min = 90, Max = 2000, Rounding = 0,
    Callback = function(v) config.AASpinRate = v end
})
AABox:AddToggle("AAStrongMode", {
    Text = "Strong Mode (multi-packet)", Default = false,
    Callback = function(v)
        config.AAStrongMode = v
        if config.AntiAimEnabled then StartAntiAim() end
    end
})
AABox:AddSlider("AAPacketBurst", {
    Text = "Strong Packets / tick", Default = 5, Min = 2, Max = 10, Rounding = 0,
    Callback = function(v) config.AAPacketBurst = v end
})
AABox:AddToggle("AntiAimUnderground", {
    Text = "Underground (bajo mapa)", Default = false,
    Callback = function(v)
        config.AntiAimUnderground = v
        if not v then
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                if config.NoclipEnabled then return end
                for _, p in ipairs(char:GetDescendants()) do
                    if p:IsA("BasePart") and p.Name ~= "HumanoidRootPart" then
                        p.CanCollide = true
                    end
                end
            end)
        end
    end
})
AABox:AddSlider("UndergroundDepth", {
    Text = "Underground Depth", Default = 3.5, Min = 1, Max = 15, Rounding = 1,
    Callback = function(v) config.UndergroundDepth = v end
})
AABox:AddLabel("jitter = backwards + flip · strong = max AA")
AABox:AddButton({
    Text = "Preset Jitter AA",
    Func = function()
        config.AAPitchMode = "down"
        config.AAYawMode = "jitter"
        config.AAPitchOffset = 250
        config.AAPitchAngle = 0
        config.AAYawAngle = 180
        config.AAJitterAmount = 180
        config.AAStrongMode = false
        config.AAHideLocal = true -- TU camara normal; solo otros ven el AA
        config.AntiAimEnabled = true
        StartAntiAim()
        Notify("AntiAim", "Jitter")
    end
})
AABox:AddButton({
    Text = "Preset STRONG AA",
    Func = function()
        config.AAPitchMode = "strong"
        config.AAYawMode = "strong"
        config.AAStrongMode = true
        config.AAPacketBurst = 6
        config.AAJitterAmount = 120
        config.AAHideLocal = true
        config.AntiAimEnabled = true
        StartAntiAim()
        Notify("AntiAim", "Strong")
    end
})
AABox:AddButton({
    Text = "Preset Spin AA",
    Func = function()
        config.AAPitchMode = "down"
        config.AAYawMode = "spin"
        config.AASpinRate = 720
        config.AntiAimEnabled = true
        StartAntiAim()
        Notify("AntiAim", "Spin")
    end
})


MoveBox = Tabs.Character:AddLeftGroupbox("movement")
togFly = MoveBox:AddToggle("FlyToggle", {
    Text = "Fly", Default = false,
    Callback = function(v) config.FlyEnabled = v if v then StartFly() else StopFly() end end
})
bindKey(togFly, "FlyKey", "...")

MoveBox:AddSlider("FlySpeed", {
    Text = "Fly Speed", Default = 120, Min = 30, Max = 9999, Rounding = 0,
    Callback = function(v) config.FlySpeed = v end
})
MoveBox:AddSlider("FlyBoost", {
    Text = "Fly Boost (Shift)", Default = 1.8, Min = 1, Max = 5, Rounding = 1,
    Callback = function(v) config.FlyBoost = v end
})
MoveBox:AddToggle("ExtendMeleeRange", {
    Text = "Extend Melee Range", Default = false,
    Callback = function(v) config.ExtendMeleeRange = v end
})
MoveBox:AddSlider("ExtendMeleeRangeDist", {
    Text = "Range", Default = 10, Min = 5, Max = 20, Rounding = 0,
    Callback = function(v) config.ExtendMeleeRangeDist = v end
})
togNoclip = MoveBox:AddToggle("NoclipToggle", {
    Text = "Noclip", Default = false,
    Callback = function(v) config.NoclipEnabled = v if v then StartNoclip() else StopNoclip() end end
})
bindKey(togNoclip, "NoclipKey", "...")

MoveBox:AddToggle("SpeedToggle", {
    Text = "Speed (Rivals)", Default = false,
    Callback = function(v)
        config.SpeedEnabled = v
        if v then
            ApplySpeedState()
            Notify("Speed", "ON " .. tostring(config.WalkSpeed))
        else
            ApplySpeedState() -- restaura WalkSpeed default
            Notify("Speed", "OFF · normal")
        end
    end
})
MoveBox:AddToggle("SpeedVelocityMode", {
    Text = "Speed Velocity Mode (Rivals)", Default = false,
    Callback = function(v) config.SpeedVelocityMode = v end
})
MoveBox:AddSlider("WalkSpeed", {
    Text = "WalkSpeed", Default = 50, Min = 16, Max = 500, Rounding = 0,
    Callback = function(v)
        config.WalkSpeed = v
        if config.SpeedEnabled then ApplySpeedState() end
    end
})
MoveBox:AddToggle("JumpPowerToggle", {
    Text = "Jump Power (Rivals)", Default = false,
    Callback = function(v)
        config.JumpPowerEnabled = v
        ApplyJumpState()
        Notify("Jump", v and ("ON " .. tostring(config.JumpPower)) or "OFF · normal")
    end
})
MoveBox:AddToggle("JumpBoostForce", {
    Text = "Jump impulso Y (Rivals)", Default = false,
    Callback = function(v) config.JumpBoostForce = v end
})
MoveBox:AddSlider("JumpPower", {
    Text = "JumpPower", Default = 100, Min = 50, Max = 9999, Rounding = 0,
    Callback = function(v) config.JumpPower = v end
})
MoveBox:AddToggle("SlideBoost", {
    Text = "Slide Boost", Default = false,
    Callback = function(v)
        config.SlideBoostEnabled = v
        if v then StartSlideBoostLoop() else StopSlideBoostLoop() end
        Notify("Slide", v and ("ON · speed " .. tostring(config.SlideBoostSpeed or 60)) or "OFF")
    end
})
MoveBox:AddSlider("SlideBoostSpeed", {
    Text = "Slide Speed", Default = 60, Min = 1, Max = 150, Rounding = 0,
    Callback = function(v) config.SlideBoostSpeed = v end
})

-- Disable animations (Elisium) — en Visuals si existe, sino aquí
pcall(function()
    local box = MoveBox
    if Tabs and Tabs.Visuals and Tabs.Visuals.AddLeftGroupbox then
        box = Tabs.Visuals:AddLeftGroupbox("disable animation")
    elseif Tabs and Tabs.World and Tabs.World.AddLeftGroupbox then
        box = Tabs.World:AddLeftGroupbox("disable animation")
    end
    box:AddToggle("DisableAnimsEnable", {
        Text = "Disable Anims", Default = false,
        Callback = function(v)
            config.DisableAnimsEnabled = v
            if v then StartDisableAnims() else StopDisableAnims() end
        end
    })
    box:AddDropdown("DisableAnimsSelect", {
        Text = "Types",
        Values = {"bobbing", "landing", "sway", "equip", "inspect", "sliding", "shoot", "impulse", "aim", "sprint", "attack", "charge", "reload", "throw"},
        Default = {},
        Multi = true,
        Callback = function(v)
            local converted = {}
            if type(v) == "table" then
                for k, val in pairs(v) do
                    if type(k) == "number" then
                        table.insert(converted, tostring(val))
                    elseif val == true then
                        table.insert(converted, tostring(k))
                    end
                end
            end
            config.DisableAnimsSelect = converted
        end
    })
end)
MoveBox:AddSlider("SlideBaseSpeed", {
    Text = "Slide Base Speed", Default = 45, Min = 20, Max = 200, Rounding = 0,
    Callback = function(v) config.SlideBaseSpeed = v end
})
MoveBox:AddDropdown("SlideBoostKey", {
    Text = "Slide Key",
    Values = {"C", "LeftControl", "LeftShift", "Q", "V"},
    Default = 1,
    Callback = function(v) config.SlideBoostKey = v end
})
MoveBox:AddToggle("InfinityJump", {
    Text = "Infinite Jump", Default = false,
    Callback = function(v) config.InfinityJump = v end
})
MoveBox:AddToggle("AntiFling", {
    Text = "Anti Fling", Default = false,
    Callback = function(v) config.AntiFling = v end
})
MoveBox:AddLabel("Rivals pisa WalkSpeed: usa Velocity Mode")
MoveBox:AddLabel("Slide boost")


CfgBox = Tabs.Settings:AddLeftGroupbox("configs")
local configNameInput = "default"
local selectedConfig = "(ninguna)"

CfgBox:AddInput("ConfigName", {
    Text = "Nombre", Default = "default",
    Callback = function(v) configNameInput = tostring(v or "default") end
})
configDropdown = CfgBox:AddDropdown("ConfigSelect", {
    Text = "Elegir", Values = (Cfg and Cfg.List and Cfg.List()) or {"(ninguna)"}, Default = 1,
    Callback = function(v) selectedConfig = v end
})
function RefreshCfg()
    pcall(function()
        local list = Cfg.List()
        if configDropdown.SetValues then configDropdown:SetValues(list) end
    end)
end
CfgBox:AddButton({ Text = "Refrescar lista", Func = RefreshCfg })
CfgBox:AddButton({
    Text = "Guardar (nuevo)",
    Func = function()
        local n = configNameInput ~= "" and configNameInput or "default"
        if Cfg.Save(n, false) then
            Notify("Config", "Guardada: " .. n)
            RefreshCfg()
        else
            Notify("Config", "Error al guardar (¿ya existe? usa Overwrite)")
        end
    end
})
CfgBox:AddButton({
    Text = "Overwrite",
    Func = function()
        local n = (selectedConfig and selectedConfig ~= "(ninguna)") and selectedConfig or configNameInput
        if Cfg.Save(n, true) then
            Notify("Config", "Overwrite: " .. tostring(n))
            RefreshCfg()
        end
    end
})
CfgBox:AddButton({
    Text = "Load",
    Func = function()
        local n = (selectedConfig and selectedConfig ~= "(ninguna)") and selectedConfig or configNameInput
        if Cfg.Load(n) then
            Notify("Config", "Cargada: " .. tostring(n))
        else
            Notify("Config", "No se pudo cargar")
        end
    end
})
CfgBox:AddButton({
    Text = "Delete",
    Func = function()
        if selectedConfig and selectedConfig ~= "(ninguna)" then
            if Cfg.Delete(selectedConfig) then
                selectedConfig = "(ninguna)"
                Notify("Config", "Borrada")
                RefreshCfg()
            end
        end
    end
})


CfgBox:AddButton({
    Text = "Set Auto Load",
    Func = function()
        local n = (selectedConfig and selectedConfig ~= "(ninguna)") and selectedConfig or configNameInput
        Cfg.SetAutoLoad(n)
        Notify("Config", "AutoLoad → " .. tostring(n))
    end
})
CfgBox:AddButton({
    Text = "Remove Auto Load",
    Func = function()
        Cfg.RemoveAutoLoad()
        Notify("Config", "AutoLoad quitado")
    end
})
CfgBox:AddButton({
    Text = "Ver Auto Load",
    Func = function()
        local n = Cfg.GetAutoLoad()
        Notify("Config", n and ("Auto: " .. n) or "Sin auto load")
    end
})

-- SaveManager / Theme de UEObsidian (si cargó)












-- ==================== COSMETICS REMOVED ====================




-- ==================== BODY AURA (wings + ring + glow) ====================
do
    local Aura = getgenv()._ShakoAura or {}
    getgenv()._ShakoAura = Aura
    Aura.objs = Aura.objs or {}

    local function clearAura()
        for _, o in ipairs(Aura.objs) do
            pcall(function() o:Destroy() end)
        end
        Aura.objs = {}
    end

    local function track(o)
        if o then table.insert(Aura.objs, o) end
        return o
    end

    local function applyAura()
        clearAura()
        if not config.BodyAuraEnabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        if not root then return end
        local host = torso or root

        local col = config.BodyAuraColor
        if typeof(col) ~= "Color3" then col = Color3.fromRGB(150, 50, 255) end
        local col2 = Color3.fromRGB(220, 120, 255)
        local rate = tonumber(config.BodyAuraRate) or 32

        local function pe(parent, props)
            local att = track(Instance.new("Attachment"))
            att.Parent = parent
            local p = track(Instance.new("ParticleEmitter"))
            for k, v in pairs(props) do pcall(function() p[k] = v end) end
            p.Parent = att
            return p
        end

        -- body haze
        pe(host, {
            Texture = "rbxassetid://241594419",
            Rate = rate,
            Lifetime = NumberRange.new(0.5, 1.2),
            Speed = NumberRange.new(0.15, 1.2),
            SpreadAngle = Vector2.new(360, 360),
            Rotation = NumberRange.new(0, 360),
            RotSpeed = NumberRange.new(-60, 60),
            Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1.1),
                NumberSequenceKeypoint.new(1, 0.1),
            }),
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.2),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Color = ColorSequence.new(col, col2),
            LightEmission = 1,
            LightInfluence = 0,
            Drag = 0.8,
        })
        pe(host, {
            Texture = "rbxassetid://241594419",
            Rate = rate * 0.6,
            Lifetime = NumberRange.new(0.8, 1.6),
            Speed = NumberRange.new(0.05, 0.5),
            Size = NumberSequence.new(2.2, 0.3),
            Transparency = NumberSequence.new(0.4, 1),
            Color = ColorSequence.new(col),
            LightEmission = 1,
            LightInfluence = 0,
            LockedToPart = true,
        })

        -- GROUND RING (circulo bajo los pies)
        local ring = track(Instance.new("Part"))
        ring.Name = "ShakoAuraRing"
        ring.Anchored = false
        ring.CanCollide = false
        ring.CanQuery = false
        ring.CanTouch = false
        ring.Massless = true
        ring.Size = Vector3.new(6, 0.12, 6)
        ring.Material = Enum.Material.ForceField
        ring.Color = col
        ring.Transparency = 0.25
        ring.CastShadow = false
        ring.CFrame = root.CFrame * CFrame.new(0, -2.9, 0)
        ring.Parent = char
        local rw = track(Instance.new("Weld"))
        rw.Part0 = root
        rw.Part1 = ring
        rw.C0 = CFrame.new(0, -3, 0)
        rw.Parent = ring
        -- spinning decal feel via mesh
        pcall(function()
            local m = track(Instance.new("CylinderMesh"))
            m.Scale = Vector3.new(1, 0.05, 1)
            m.Parent = ring
        end)
        pe(ring, {
            Texture = "rbxassetid://241594419",
            Rate = rate * 1.2,
            Lifetime = NumberRange.new(0.4, 0.9),
            Speed = NumberRange.new(2, 5),
            SpreadAngle = Vector2.new(0, 180),
            EmissionDirection = Enum.NormalId.Top,
            Size = NumberSequence.new(0.5, 0.05),
            Transparency = NumberSequence.new(0.15, 1),
            Color = ColorSequence.new(col, col2),
            LightEmission = 1,
            LightInfluence = 0,
        })
        -- second ring (outer)
        local ring2 = track(Instance.new("Part"))
        ring2.Name = "ShakoAuraRing2"
        ring2.Anchored = false
        ring2.CanCollide = false
        ring2.CanQuery = false
        ring2.Massless = true
        ring2.Size = Vector3.new(9, 0.08, 9)
        ring2.Material = Enum.Material.ForceField
        ring2.Color = col2
        ring2.Transparency = 0.45
        ring2.CastShadow = false
        ring2.Parent = char
        local rw2 = track(Instance.new("Weld"))
        rw2.Part0 = root
        rw2.Part1 = ring2
        rw2.C0 = CFrame.new(0, -3.05, 0)
        rw2.Parent = ring2

        -- WINGS bigger + more segments
        local function makeWing(side)
            local model = track(Instance.new("Model"))
            model.Name = "ShakoWing_" .. side
            model.Parent = char
            local base = track(Instance.new("Part"))
            base.Name = "WingRoot"
            base.Size = Vector3.new(0.25, 0.25, 0.25)
            base.Transparency = 1
            base.CanCollide = false
            base.Massless = true
            base.Anchored = false
            base.Parent = model
            local bw = track(Instance.new("Weld"))
            bw.Part0 = host
            bw.Part1 = base
            bw.C0 = CFrame.new(side * 0.55, 0.55, 0.4) * CFrame.Angles(math.rad(-8), math.rad(side * 12), math.rad(side * -20))
            bw.Parent = base

            local segs = {
                {Vector3.new(2.4, 0.14, 1.15), CFrame.new(side * 1.1, 0.2, 0.05) * CFrame.Angles(0, 0, math.rad(side * -15))},
                {Vector3.new(2.0, 0.12, 0.95), CFrame.new(side * 2.15, 0.45, -0.1) * CFrame.Angles(0, 0, math.rad(side * -28))},
                {Vector3.new(1.55, 0.1, 0.75), CFrame.new(side * 3.0, 0.75, -0.28) * CFrame.Angles(0, 0, math.rad(side * -42))},
                {Vector3.new(1.1, 0.08, 0.55), CFrame.new(side * 3.55, 1.05, -0.45) * CFrame.Angles(0, 0, math.rad(side * -55))},
            }
            for _, seg in ipairs(segs) do
                local p = track(Instance.new("Part"))
                p.Size = seg[1]
                p.Color = col
                p.Material = Enum.Material.ForceField
                p.Transparency = 0.2
                p.CanCollide = false
                p.Massless = true
                p.CastShadow = false
                p.Parent = model
                local w = track(Instance.new("Weld"))
                w.Part0 = base
                w.Part1 = p
                w.C0 = seg[2]
                w.Parent = p
                local a0 = track(Instance.new("Attachment"))
                a0.Position = Vector3.new(0, 0, seg[1].Z * 0.45)
                a0.Parent = p
                local a1 = track(Instance.new("Attachment"))
                a1.Position = Vector3.new(0, 0, -seg[1].Z * 0.45)
                a1.Parent = p
                local tr = track(Instance.new("Trail"))
                tr.Attachment0 = a0
                tr.Attachment1 = a1
                tr.Color = ColorSequence.new(col, col2)
                tr.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.15),
                    NumberSequenceKeypoint.new(1, 1),
                })
                tr.Lifetime = NumberSequence.new(0.9, 0)
                tr.Lifetime = 0.4
                tr.LightEmission = 1
                tr.FaceCamera = true
                tr.Parent = p
                pe(p, {
                    Texture = "rbxassetid://241594419",
                    Rate = 12,
                    Lifetime = NumberRange.new(0.25, 0.6),
                    Speed = NumberRange.new(0.2, 1.0),
                    Size = NumberSequence.new(0.55, 0.05),
                    Transparency = NumberSequence.new(0.2, 1),
                    Color = ColorSequence.new(col),
                    LightEmission = 1,
                    LightInfluence = 0,
                })
            end
        end
        makeWing(1)
        makeWing(-1)

        -- shoulder orbs
        for _, side in ipairs({-1, 1}) do
            local orb = track(Instance.new("Part"))
            orb.Shape = Enum.PartType.Ball
            orb.Size = Vector3.new(0.55, 0.55, 0.55)
            orb.Material = Enum.Material.ForceField
            orb.Color = col2
            orb.Transparency = 0.2
            orb.CanCollide = false
            orb.Massless = true
            orb.CastShadow = false
            orb.Parent = char
            local ow = track(Instance.new("Weld"))
            ow.Part0 = host
            ow.Part1 = orb
            ow.C0 = CFrame.new(side * 1.05, 0.7, 0)
            ow.Parent = orb
            pe(orb, {
                Texture = "rbxassetid://241594419",
                Rate = 10,
                Lifetime = NumberRange.new(0.3, 0.7),
                Speed = NumberRange.new(0.1, 0.5),
                Size = NumberSequence.new(0.35, 0.05),
                Transparency = NumberSequence.new(0.2, 1),
                Color = ColorSequence.new(col2),
                LightEmission = 1,
            })
        end

        local light = track(Instance.new("PointLight"))
        light.Color = col
        light.Brightness = 3
        light.Range = 14
        light.Parent = root

        -- spin rings slowly
        if Aura.spin then pcall(function() Aura.spin:Disconnect() end) end
        local _af = 0
        Aura.spin = game:GetService("RunService").RenderStepped:Connect(function(dt)
            if not config.BodyAuraEnabled then return end
            _af += 1
            if _af % 2 ~= 0 then return end
            if ring and ring.Parent then
                pcall(function()
                    ring.CFrame = ring.CFrame * CFrame.Angles(0, dt * 1.6, 0)
                end)
            end
            if ring2 and ring2.Parent then
                pcall(function()
                    ring2.CFrame = ring2.CFrame * CFrame.Angles(0, -dt * 1.1, 0)
                end)
            end
        end)
        track(Aura.spin)
    end

    function StartBodyAura()
        config.BodyAuraEnabled = true
        applyAura()
        if Aura.conn then pcall(function() Aura.conn:Disconnect() end) end
        Aura.conn = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.6)
            if config.BodyAuraEnabled then applyAura() end
        end)
    end
    function StopBodyAura()
        config.BodyAuraEnabled = false
        clearAura()
        if Aura.conn then pcall(function() Aura.conn:Disconnect() end) Aura.conn = nil end
        if Aura.spin then pcall(function() Aura.spin:Disconnect() end) Aura.spin = nil end
    end
    getgenv()._ShakoStartBodyAura = StartBodyAura
    getgenv()._ShakoStopBodyAura = StopBodyAura
    getgenv()._ShakoApplyBodyAura = applyAura
end

-- ==================== VM / OVERRIDE (restore + wireframe Harion-like) ====================
do
    local Vis2 = getgenv()._ShakoVisMain or { wires = {}, orig = {}, statusOrig = {}, highlights = {} }
    getgenv()._ShakoVisMain = Vis2
    -- reset stale
    Vis2.orig = Vis2.orig or {}
    Vis2.wires = Vis2.wires or {}
    Vis2.statusOrig = Vis2.statusOrig or {}

    local MAT = {
        ForceField = Enum.Material.ForceField,
        Neon = Enum.Material.Neon,
        Glass = Enum.Material.Glass,
        SmoothPlastic = Enum.Material.SmoothPlastic,
        Plastic = Enum.Material.Plastic,
        Metal = Enum.Material.Metal,
    }

    local function getVMs()
        local list, seen = {}, {}
        local function take(inst)
            if not inst or seen[inst] then return end
            seen[inst] = true
            table.insert(list, inst)
        end
        local cam = workspace.CurrentCamera
        if cam then
            for _, ch in ipairs(cam:GetChildren()) do
                take(ch)
            end
            for _, d in ipairs(cam:GetDescendants()) do
                if d:IsA("Model") then
                    local n = string.lower(d.Name)
                    if n:find("view") or n:find("arm") or n:find("weapon") or n:find("gun") or n:find("item") or n:find("tool") then
                        take(d)
                    end
                end
            end
        end
        local wvm = workspace:FindFirstChild("ViewModels")
        if wvm then for _, ch in ipairs(wvm:GetChildren()) do take(ch) end end
        -- character hands/tools
        local char = LocalPlayer.Character
        if char then
            for _, t in ipairs(char:GetChildren()) do
                if t:IsA("Tool") or t:IsA("Accessory") then take(t) end
            end
        end
        return list
    end

    local function isArm(part)
        local n = string.lower(part.Name)
        if n:find("arm") or n:find("hand") or n:find("glove") or n:find("sleeve") or n:find("finger") then return true end
        local p = part.Parent
        for _ = 1, 5 do
            if not p then break end
            local pn = string.lower(p.Name)
            if pn:find("arm") or pn:find("hand") or pn == "left arm" or pn == "right arm" then return true end
            p = p.Parent
        end
        return false
    end

    local function remember(part)
        if not Vis2.orig[part] then
            Vis2.orig[part] = {
                Color = part.Color,
                Material = part.Material,
                Transparency = part.Transparency,
                Reflectance = part.Reflectance,
            }
        end
    end

    local function restorePart(part)
        local o = Vis2.orig[part]
        if not o then return end
        pcall(function()
            part.Color = o.Color
            part.Material = o.Material
            part.Transparency = o.Transparency
            part.Reflectance = o.Reflectance or 0
        end)
        Vis2.orig[part] = nil
    end

    local function restoreAll()
        for part in pairs(Vis2.orig) do
            if part and part.Parent then restorePart(part) end
        end
        Vis2.orig = {}
        for k, w in pairs(Vis2.wires) do
            pcall(function() w:Destroy() end)
            Vis2.wires[k] = nil
        end
        for m, h in pairs(Vis2.highlights) do
            pcall(function() h:Destroy() end)
            Vis2.highlights[m] = nil
        end
        -- restore textures
        pcall(function()
            for _, root in ipairs(getVMs()) do
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("Texture") or d:IsA("Decal") then
                        if d:GetAttribute("ShakoTexHidden") then
                            d.Transparency = d:GetAttribute("ShakoTexOrig") or 0
                            d:SetAttribute("ShakoTexHidden", nil)
                        end
                    end
                end
            end
        end)
    end

    local function stylePart(part, color, matName, trans, noTex)
        remember(part)
        pcall(function()
            if typeof(color) == "Color3" then part.Color = color end
            part.Material = MAT[tostring(matName)] or Enum.Material.ForceField
            if typeof(trans) == "number" then
                part.Transparency = math.clamp(trans, 0, 0.98)
            end
        end)
        if noTex then
            for _, d in ipairs(part:GetChildren()) do
                if d:IsA("Texture") or d:IsA("Decal") then
                    if not d:GetAttribute("ShakoTexHidden") then
                        d:SetAttribute("ShakoTexOrig", d.Transparency)
                        d:SetAttribute("ShakoTexHidden", true)
                    end
                    pcall(function() d.Transparency = 1 end)
                end
            end
        end
    end

    local function wire(part, color)
        local w = Vis2.wires[part]
        if w and w.Parent then
            pcall(function()
                w.Color3 = color or Color3.new(1,1,1)
                w.Visible = true
                w.AlwaysOnTop = true
                w.Thickness = 0.08
            end)
            return w
        end
        local ok, a = pcall(function()
            local ad = Instance.new("WireframeHandleAdornment")
            ad.Name = "ShakoWF"
            ad.Adornee = part
            ad.Color3 = color or Color3.new(1,1,1)
            ad.Transparency = 0
            ad.Thickness = 0.08
            ad.AlwaysOnTop = true
            ad.ZIndex = 10
            ad.Parent = workspace.CurrentCamera or part
            return ad
        end)
        if ok and a then
            Vis2.wires[part] = a
            return a
        end
    end

    local function tickVM()
        local cfg = config
        if not cfg then return end

        if cfg.VMOverrideFps and setfpscap then
            pcall(setfpscap, tonumber(cfg.VMFps) or 60)
        end

        if cfg.RemoveVignette then
            local now = os.clock()
            if (Vis2._lastVig or 0) + 0.25 < now then
                Vis2._lastVig = now
                pcall(function()
                    local pg = LocalPlayer:FindFirstChild("PlayerGui")
                    if not pg then return end
                    for _, g in ipairs(pg:GetDescendants()) do
                        if g:IsA("GuiObject") then
                            local n = string.lower(g.Name)
                            if n:find("vignette") or n:find("vign") then
                                g.Visible = false
                                pcall(function() g.BackgroundTransparency = 1 end)
                                pcall(function() g.ImageTransparency = 1 end)
                            end
                        end
                    end
                end)
            end
        end

        if cfg.OverrideWeaponStatus then
            pcall(function()
                local il = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
                local st = tostring(cfg.WeaponStatus or "Prime")
                for name, info in pairs(il.Items or {}) do
                    if type(info) == "table" then
                        if Vis2.statusOrig[name] == nil then Vis2.statusOrig[name] = info.Status end
                        info.Status = st
                    end
                end
            end)
        elseif next(Vis2.statusOrig) then
            pcall(function()
                local il = require(game:GetService("ReplicatedStorage").Modules.ItemLibrary)
                for name, orig in pairs(Vis2.statusOrig) do
                    local info = il.Items and il.Items[name]
                    if type(info) == "table" then info.Status = orig end
                end
                Vis2.statusOrig = {}
            end)
        end

        if cfg.DisableGameCrosshair then
            pcall(function()
                local pg = LocalPlayer:FindFirstChild("PlayerGui")
                if not pg then return end
                for _, g in ipairs(pg:GetDescendants()) do
                    if g:IsA("GuiObject") then
                        local n = string.lower(g.Name)
                        if n:find("crosshair") or n:find("reticle") then
                            g.Visible = false
                        end
                    end
                end
            end)
        end

        local need = cfg.VMAppearance or cfg.VMWireframe or cfg.ArmAppearance or cfg.VMChams or cfg.VMOffset
        if not need then
            -- RESTORE everything when all override options off
            if next(Vis2.orig) or next(Vis2.wires) or next(Vis2.highlights) then
                restoreAll()
            end
            return
        end

        local roots = getVMs()
        local liveW, liveParts = {}, {}

        for _, root in ipairs(roots) do
            if cfg.VMChams then
                pcall(function()
                    local h = Vis2.highlights[root]
                    if not h or not h.Parent then
                        h = Instance.new("Highlight")
                        h.Name = "ShakoVMChams"
                        local parent = game:GetService("CoreGui")
                        pcall(function()
                            if gethui then parent = gethui() end
                        end)
                        h.Parent = parent
                        Vis2.highlights[root] = h
                    end
                    h.Adornee = root
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.FillColor = cfg.VMChamsColor or Color3.fromRGB(255, 255, 255)
                    h.OutlineColor = cfg.VMChamsColor or Color3.fromRGB(255, 255, 255)
                    local fill = tonumber(cfg.VMChamFill) or 2
                    local outl = tonumber(cfg.VMChamOutline) or 1
                    -- sliders 0-100 → transparency 0-1
                    h.FillTransparency = math.clamp(fill / 100, 0, 1)
                    h.OutlineTransparency = math.clamp(outl / 100, 0, 1)
                    h.Enabled = true
                end)
            end

            local parts = {}
            if root:IsA("BasePart") then
                parts[1] = root
            else
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("BasePart") then table.insert(parts, d) end
                end
            end

            for _, part in ipairs(parts) do
                liveParts[part] = true
                local arm = isArm(part)
                local styled = false
                if arm and cfg.ArmAppearance then
                    stylePart(part, cfg.ArmColor, cfg.ArmMaterial or "ForceField", (tonumber(cfg.ArmTransparency) or 100) / 100, cfg.ArmDisableClothes or cfg.VMDisableTextures)
                    styled = true
                elseif (not arm) and cfg.VMAppearance then
                    stylePart(part, cfg.VMColor, cfg.VMMaterial or "ForceField", (tonumber(cfg.VMTransparency) or 100) / 100, cfg.VMDisableTextures)
                    styled = true
                end
                -- if neither appearance applies to this part, restore it
                if not styled and Vis2.orig[part] then
                    if not (cfg.VMWireframe and not arm) then
                        restorePart(part)
                    end
                end
                if cfg.VMWireframe and not arm then
                    -- Harion style: slight transparency so wire shows
                    if not cfg.VMAppearance then
                        remember(part)
                        pcall(function()
                            if part.Transparency < 0.2 then part.Transparency = 0.2 end
                        end)
                    end
                    local w = wire(part, cfg.VMColor or Color3.fromRGB(255, 255, 255))
                    if w then liveW[w] = true end
                end
            end

            if cfg.ArmDisableClothes then
                for _, d in ipairs(root:GetDescendants()) do
                    if d:IsA("Clothing") or d:IsA("Shirt") or d:IsA("Pants") or d:IsA("ShirtGraphic") then
                        pcall(function() d:Destroy() end)
                    end
                end
            end
        end

        -- cleanup wires not live
        if not cfg.VMWireframe then
            for k, w in pairs(Vis2.wires) do
                pcall(function() w:Destroy() end)
                Vis2.wires[k] = nil
            end
        else
            for k, w in pairs(Vis2.wires) do
                if not liveW[w] then
                    pcall(function() w:Destroy() end)
                    Vis2.wires[k] = nil
                end
            end
        end
        if not cfg.VMChams then
            for m, h in pairs(Vis2.highlights) do
                pcall(function() h:Destroy() end)
                Vis2.highlights[m] = nil
            end
        end
        -- restore parts no longer in any root
        for part in pairs(Vis2.orig) do
            if not liveParts[part] then
                restorePart(part)
            end
        end
    end

    -- when toggles turn off mid-game, force restore next frame
    Vis2._lastNeed = false
    if Vis2.conn then pcall(function() Vis2.conn:Disconnect() end) end
    local _vmFrame = 0
    Vis2.conn = RunService.RenderStepped:Connect(function()
        -- incluir chams / offset / appearance
        if not (config.WeaponWireframe or config.ViewmodelOverride or config.OverrideWeaponStatus
            or config.ItemOverride or config.VMChams or config.VMOffset or config.VMAppearance
            or config.ArmAppearance or config.VMWireframe or config.RemoveVignette or config.VMOverrideFps) then
            return
        end
        _vmFrame += 1
        if _vmFrame % 2 ~= 0 then return end
        pcall(tickVM)
    end)
end



-- ==================== CROSSHAIR (ScreenGui - Real Executor safe) ====================
do
    local CX = getgenv()._ShakoCX or {}
    getgenv()._ShakoCX = CX

    local function destroyGui()
        if CX.gui then pcall(function() CX.gui:Destroy() end) CX.gui = nil end
        CX.arms = nil
        CX.holder = nil
    end

    local function getParent()
        local p = nil
        pcall(function() if gethui then p = gethui() end end)
        if not p then pcall(function() p = game:GetService("CoreGui") end) end
        if not p then
            p = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui")
        end
        return p
    end

    local function buildGui()
        destroyGui()
        local parent = getParent()
        local gui = Instance.new("ScreenGui")
        gui.Name = "ShakoCrosshair"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 9999
        gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        gui.Parent = parent
        CX.gui = gui

        local holder = Instance.new("Frame")
        holder.Name = "Holder"
        holder.BackgroundTransparency = 1
        holder.Size = UDim2.fromOffset(200, 200)
        holder.AnchorPoint = Vector2.new(0.5, 0.5)
        holder.Position = UDim2.fromScale(0.5, 0.5)
        holder.Parent = gui
        CX.holder = holder

        CX.arms = {}
        -- 4 arms as frames (top bottom left right), rotated as group via holder.Rotation
        local function arm(name, size, pos, anchor)
            local f = Instance.new("Frame")
            f.Name = name
            f.BorderSizePixel = 0
            f.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            f.Size = size
            f.Position = pos
            f.AnchorPoint = anchor
            f.Parent = holder
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 1.2
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Parent = f
            CX.arms[#CX.arms + 1] = { frame = f, stroke = stroke }
            return f
        end
        -- gap will be applied dynamically via positions
        CX.rebuildArms = function(length, thickness, gap)
            for _, a in ipairs(CX.arms) do pcall(function() a.frame:Destroy() end) end
            CX.arms = {}
            local L = length or 20
            local T = thickness or 2
            local G = gap or 8
            arm("Top", UDim2.fromOffset(T, L), UDim2.new(0.5, 0, 0.5, -G), Vector2.new(0.5, 1))
            arm("Bot", UDim2.fromOffset(T, L), UDim2.new(0.5, 0, 0.5, G), Vector2.new(0.5, 0))
            arm("Left", UDim2.fromOffset(L, T), UDim2.new(0.5, -G, 0.5, 0), Vector2.new(1, 0.5))
            arm("Right", UDim2.fromOffset(L, T), UDim2.new(0.5, G, 0.5, 0), Vector2.new(0, 0.5))
        end
        CX.rebuildArms(23, 2, 8)
    end

    local function worldToScreen(pos)
        local cam = workspace.CurrentCamera
        if not cam or not pos then return nil, false end
        local v, on = cam:WorldToViewportPoint(pos)
        return Vector2.new(v.X, v.Y), on and v.Z > 0
    end

    local function closestTarget()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        local center = cam.ViewportSize / 2
        local best, bestD = nil, 1e9
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr == LocalPlayer then continue end
            local char = plr.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local part = char and (char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart"))
            if not (hum and part and hum.Health > 0) then continue end
            local sp, on = cam:WorldToViewportPoint(part.Position)
            if not on or sp.Z <= 0 then continue end
            local d = (Vector2.new(sp.X, sp.Y) - center).Magnitude
            if d < bestD then bestD = d; best = part end
        end
        return best
    end

    local function update()
        if not config or not config.Crosshair then
            if CX.gui then CX.gui.Enabled = false end
            return
        end
        if not CX.gui or not CX.gui.Parent then buildGui() end
        CX.gui.Enabled = true

        local cam = workspace.CurrentCamera
        if not cam then return end
        local vp = cam.ViewportSize
        local center = Vector2.new(vp.X / 2, vp.Y / 2)

        local mode = tostring(config.CrosshairPosition or "center")
        if mode == "position on target" then
            local t = closestTarget()
            if t then
                local s, on = worldToScreen(t.Position)
                if on and s then center = s end
            end
        elseif mode == "position on barrel" then
            pcall(function()
                for _, inst in ipairs(cam:GetDescendants()) do
                    if inst:IsA("BasePart") then
                        local n = string.lower(inst.Name)
                        if n:find("muzzle") or n:find("barrel") then
                            local s, on = worldToScreen(inst.Position)
                            if on and s then center = s end
                            return
                        end
                    end
                end
            end)
        end

        local length = tonumber(config.CrosshairSize) or 20
        local gap = tonumber(config.CrosshairGap) or 8
        local thickness = tonumber(config.CrosshairThickness) or 2
        local bounce = tonumber(config.CrosshairBounce) or 0
        if bounce > 0 then
            gap = gap + math.sin(tick() * 8 * (tonumber(config.CrosshairBounceSpeed) or 1)) * bounce
        end

        -- rebuild if size changed a lot
        local key = string.format("%d_%d_%d", math.floor(length), math.floor(thickness), math.floor(gap))
        if CX._key ~= key then
            CX._key = key
            if CX.rebuildArms then CX.rebuildArms(length, thickness, gap) end
        else
            -- update gap positions live
            if CX.arms and #CX.arms >= 4 then
                local T, L, G = thickness, length, gap
                local a = CX.arms
                a[1].frame.Size = UDim2.fromOffset(T, L); a[1].frame.Position = UDim2.new(0.5, 0, 0.5, -G)
                a[2].frame.Size = UDim2.fromOffset(T, L); a[2].frame.Position = UDim2.new(0.5, 0, 0.5, G)
                a[3].frame.Size = UDim2.fromOffset(L, T); a[3].frame.Position = UDim2.new(0.5, -G, 0.5, 0)
                a[4].frame.Size = UDim2.fromOffset(L, T); a[4].frame.Position = UDim2.new(0.5, G, 0.5, 0)
            end
        end

        local col = config.CrosshairColor or Color3.fromRGB(255, 255, 255)
        local outCol = config.CrosshairOutlineColor or Color3.fromRGB(0, 0, 0)
        for _, a in ipairs(CX.arms or {}) do
            a.frame.BackgroundColor3 = col
            if a.stroke then
                a.stroke.Color = outCol
                a.stroke.Enabled = config.CrosshairOutline ~= false
            end
        end

        -- rotation (Harion style: base + spin)
        -- Spin crosshair
        local base = tonumber(config.CrosshairRotation) or 0
        local spinOn = config.CrosshairSpin ~= false -- default ON
        local spinSpd = tonumber(config.CrosshairSpinSpeed) or 1.2
        if spinSpd < 0 then spinSpd = 0 end
        local rot = base
        if spinOn and spinSpd > 0 then
            rot = base + (tick() * 360 * spinSpd)
        end
        if CX.holder then
            CX.holder.Rotation = rot % 360
            CX.holder.Position = UDim2.fromOffset(center.X, center.Y)
        end
    end

    StartCrosshair = function()
        config.Crosshair = true
        if config.CrosshairSpin == nil then config.CrosshairSpin = true end
        if not config.CrosshairSpinSpeed or config.CrosshairSpinSpeed == 0 then
            config.CrosshairSpinSpeed = 1.2
        end
        buildGui()
        if CX.conn then pcall(function() CX.conn:Disconnect() end) end
        local _cxf = 0
        CX.conn = RunService.RenderStepped:Connect(function()
            _cxf += 1
            if _cxf % 2 ~= 0 then return end
            pcall(update)
        end)
    end

    StopCrosshair = function()
        config.Crosshair = false
        if CX.conn then pcall(function() CX.conn:Disconnect() end) CX.conn = nil end
        destroyGui()
    end

    getgenv()._StartCrosshairReal = StartCrosshair
    getgenv()._StopCrosshairReal = StopCrosshair
end

-- ==================== BULLET TRACERS while holding fire ====================
do
    local BT = getgenv()._ShakoBTHold or {}
    getgenv()._ShakoBTHold = BT
    local UIS = game:GetService("UserInputService")

    local function muzzlePos()
        local cam = workspace.CurrentCamera
        if not cam then return nil end
        -- try viewmodel muzzle
        local pos = cam.CFrame.Position + cam.CFrame.LookVector * 1.5
        pcall(function()
            for _, inst in ipairs(cam:GetDescendants()) do
                if inst:IsA("BasePart") then
                    local n = string.lower(inst.Name)
                    if n:find("muzzle") or n:find("fire") or n:find("tip") then
                        pos = inst.Position
                        return
                    end
                end
            end
        end)
        return pos
    end

    local function fireTracer()
        if not (config.BulletTracerEnabled or config.EliTracerEnabled or config.EliTracers) then return end
        local cam = workspace.CurrentCamera
        if not cam then return end
        local from = muzzlePos() or (cam.CFrame.Position + cam.CFrame.LookVector * 1.2)
        local to = cam.CFrame.Position + cam.CFrame.LookVector * (tonumber(config.BulletTracerDistance) or 400)
        -- ray toward look
        pcall(function()
            local rp = RaycastParams.new()
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local char = LocalPlayer.Character
            rp.FilterDescendantsInstances = { char, cam }
            local hit = workspace:Raycast(cam.CFrame.Position, cam.CFrame.LookVector * 500, rp)
            if hit then to = hit.Position end
        end)
        if type(pushBulletTracer) == "function" then
            pcall(pushBulletTracer, from, to)
        elseif type(createBulletTracersFromHits) == "function" then
            pcall(createBulletTracersFromHits, to, from)
        end
    end

    if not BT.conn then
        BT.conn = RunService.RenderStepped:Connect(function()
            if not (config.BulletTracerEnabled or config.EliTracerEnabled or config.EliTracers) then return end
            local holding = UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
            if not holding then
                BT.acc = 0
                return
            end
            BT.acc = (BT.acc or 0) + 1
            local every = math.max(1, math.floor(60 / (tonumber(config.BulletTracerRate) or 12)))
            if BT.acc % every == 0 then
                fireTracer()
            end
        end)
    end
end


-- ==================== SETTINGS: Menu Key + Keybind List ====================
-- UELinoria: Library.ToggleKeybind = "F" (string) → cada pulsación hace Library:Toggle()
-- Modo TOGGLE puro: 1 click abre, 1 click cierra. Sin Hold. Sin handlers extra.
pcall(function()
    local setBox = nil
    pcall(function()
        setBox = (Tabs.Settings or Tabs.Configs):AddLeftGroupbox("Menu & Keybinds")
    end)
    if not setBox then
        warn("[shako] No Settings tab")
        return
    end

    local function applyToggleKey(keyName)
        keyName = tostring(keyName or ""):gsub("%s+", "")
        if keyName == "" or keyName == "Unknown" or keyName == "None" then
            return false
        end
        config.MenuKey = keyName
        getgenv()._ShakoMenuKey = keyName

        -- SOLO string: la lib hace Toggle() en cada press (modo toggle)
        -- NO dejar KeyPicker: su Mode Hold/Always rompe el menu
        pcall(function()
            Library.ToggleKeybind = keyName
        end)

        -- Si Options.MenuKeybind existe, ponerlo en Mode Toggle + Value
        pcall(function()
            local opts = Library.Options or getgenv().Options
            if type(opts) ~= "table" then return end
            local mk = opts.MenuKeybind or opts.MenuKey
            if type(mk) ~= "table" then return end
            mk.Value = keyName
            mk.Mode = "Toggle"
            pcall(function() if mk.SetValue then mk:SetValue(keyName) end end)
            pcall(function()
                if mk.ModeDisplay then mk.ModeDisplay.Text = "Toggle" end
            end)
            -- NO asignar mk a ToggleKeybind (usamos string)
        end)

        print("[shako] Menu Key TOGGLE =", keyName)
        return true
    end

    local currentKey = tostring(config.MenuKey or getgenv()._ShakoMenuKey or "RightShift"):gsub("%s+", "")
    if currentKey == "" then currentKey = "RightShift" end
    applyToggleKey(currentKey)

    local keyLabel = setBox:AddLabel("Menu Key (Toggle): " .. currentKey)
    local waitingBind = false
    local bindConn = nil

    local function refreshLabel(name)
        pcall(function()
            if keyLabel and keyLabel.SetText then
                keyLabel:SetText("Menu Key (Toggle): " .. name)
            end
        end)
    end

    setBox:AddLabel("Modo: Toggle · 1 vez abre · 1 vez cierra")

    setBox:AddButton({
        Text = "Bind Menu Key (click then press key)",
        Func = function()
            if waitingBind then return end
            waitingBind = true
            pcall(function()
                if Library and Library.Notify then
                    Library:Notify("Pulsa la tecla (modo Toggle)...", 3)
                end
            end)
            if bindConn then pcall(function() bindConn:Disconnect() end) bindConn = nil end
            bindConn = UserInputService.InputBegan:Connect(function(input, gp)
                if not waitingBind then return end
                if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
                if not input.KeyCode or input.KeyCode == Enum.KeyCode.Unknown then return end
                local name = input.KeyCode.Name
                waitingBind = false
                pcall(function() bindConn:Disconnect() end)
                bindConn = nil
                if applyToggleKey(name) then
                    refreshLabel(name)
                    pcall(function()
                        if Library and Library.Notify then
                            Library:Notify("Toggle menu con: " .. name, 3)
                        end
                    end)
                end
            end)
            task.delay(6, function()
                if waitingBind then
                    waitingBind = false
                    if bindConn then pcall(function() bindConn:Disconnect() end) bindConn = nil end
                end
            end)
        end
    })

    setBox:AddButton({
        Text = "Reset → RightShift (Toggle)",
        Func = function()
            applyToggleKey("RightShift")
            refreshLabel("RightShift")
        end
    })

    -- Sin InputBegan propio: UELinoria ya hace Toggle() al detectar ToggleKeybind string
    -- Re-aplicar por si SaveManager pisa
    task.spawn(function()
        for _ = 1, 5 do
            task.wait(1)
            local k = tostring(getgenv()._ShakoMenuKey or config.MenuKey or "RightShift")
            pcall(function() Library.ToggleKeybind = k end)
        end
    end)

    setBox:AddToggle("KeybindListEnabled", {
        Text = "Keybind List", Default = true,
        Callback = function(v)
            config.KeybindListEnabled = v
            pcall(function()
                if getgenv()._ShakoKBList and getgenv()._ShakoKBList.SetVisible then
                    getgenv()._ShakoKBList.SetVisible(v)
                end
            end)
        end
    })
    setBox:AddToggle("KeybindListOnlyActive", {
        Text = "Only Active Keybinds", Default = false,
        Callback = function(v)
            config.KeybindListOnlyActive = v
        end
    })
    setBox:AddSlider("KeybindListTransparency", {
        Text = "Keybind List Transparency", Default = 0.25, Min = 0, Max = 0.9, Rounding = 2,
        Callback = function(v)
            config.KeybindListTransparency = v
            pcall(function()
                if getgenv()._ShakoKBList and getgenv()._ShakoKBList.SetTransparency then
                    getgenv()._ShakoKBList.SetTransparency(v)
                end
            end)
        end
    })

    setBox:AddButton({
        Text = "Unload Script",
        Func = function()
            getgenv()._ShakoFullyUnloaded = true
            pcall(function()
                if Library then
                    Library.Unloaded = true
                    Library.Toggled = false
                    if type(Library.Unload) == "function" then Library:Unload() end
                end
            end)
            pcall(function()
                local cg = game:GetService("CoreGui")
                for _, g in ipairs(cg:GetChildren()) do
                    if g:IsA("ScreenGui") then
                        local n = string.lower(g.Name)
                        if n:find("linoria") or n:find("obsidian") or n:find("uelinoria") then
                            g:Destroy()
                        end
                    end
                end
            end)
            getgenv().antiSleepy_loaded = false
            getgenv()._ShakoUIReady = false
            print("[shako] UNLOADED")
        end
    })

    print("[shako] Menu Key TOGGLE mode OK ·", currentKey)
end)

-- Keybind list GUI (movable, Unnamed style)
pcall(function()
    local KB = getgenv()._ShakoKBList or {}
    getgenv()._ShakoKBList = KB
    if KB.Gui then pcall(function() KB.Gui:Destroy() end) end

    local parent = gethui and gethui() or game:GetService("CoreGui")
    local gui = Instance.new("ScreenGui")
    gui.Name = "ShakoKeybindList"
    KB.gui = gui
    KB.Gui = gui
    KB.Destroy = function()
        pcall(function()
            if KB._render then KB._render:Disconnect() end
            if KB._conn then KB._conn:Disconnect() end
        end)
        pcall(function() if gui and gui.Parent then gui:Destroy() end end)
        getgenv()._ShakoKBList = nil
    end
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent
    KB.Gui = gui

    local frame = Instance.new("Frame")
    frame.Name = "List"
    frame.Size = UDim2.fromOffset(180, 28)
    frame.Position = UDim2.fromOffset(tonumber(config.KeybindListPosX) or 20, tonumber(config.KeybindListPosY) or 120)
    frame.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
    frame.BackgroundTransparency = tonumber(config.KeybindListTransparency) or 0.15
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(50, 50, 55)
    stroke.Thickness = 1
    stroke.Parent = frame
    frame.BorderSizePixel = 0
    frame.Active = true
    frame.Parent = gui
    KB.Frame = frame
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 22)
    title.BackgroundTransparency = 1
    title.Text = "  keybinds"
    title.TextColor3 = Color3.fromRGB(220, 220, 220)
    title.Font = Enum.Font.Code
    title.TextSize = 13
    title.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    title.BackgroundTransparency = 0.15
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame

    local list = Instance.new("Frame")
    list.Name = "Items"
    list.Position = UDim2.fromOffset(0, 22)
    list.Size = UDim2.new(1, 0, 0, 0)
    list.BackgroundTransparency = 1
    list.Parent = frame
    local layout = Instance.new("UIListLayout", list)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 1)

    -- drag
    local dragging, dragStart, startPos
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local d = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            config.KeybindListPosX = frame.Position.X.Offset
            config.KeybindListPosY = frame.Position.Y.Offset
        end
    end)

    function KB.SetVisible(v)
        frame.Visible = v ~= false and config.KeybindListEnabled ~= false
    end
    function KB.SetTransparency(t)
        frame.BackgroundTransparency = tonumber(t) or 0.25
    end

    local function keyName(kp)
        if not kp then return "..." end
        local v = kp.Value or kp.Key
        if typeof(v) == "EnumItem" then return v.Name end
        if type(v) == "string" and v ~= "" and v ~= "None" and v ~= "nil" then return v end
        return "..."
    end

    local function modeName(kp)
        if not kp then return "Toggle" end
        return tostring(kp.Mode or kp.mode or "Toggle")
    end

    local function isActive(kp, tog)
        if not kp then return false end
        pcall(function()
            if type(kp.GetState) == "function" and kp:GetState() then return true end
        end)
        if tog and tog.Value == true then return true end
        return false
    end

    local function refresh()
        if config.KeybindListEnabled == false then
            frame.Visible = false
            return
        end
        frame.Visible = true
        frame.BackgroundTransparency = tonumber(config.KeybindListTransparency) or 0.25
        for _, ch in ipairs(list:GetChildren()) do
            if ch:IsA("TextLabel") then ch:Destroy() end
        end
        local opts = Library and Library.Options
        local toggles = Library and Library.Toggles
        local count = 0
        if opts then
            for id, kp in pairs(opts) do
                local isKP = false
                pcall(function()
                    if kp.Type == "KeyPicker" or kp.Class == "KeyPicker" or type(kp.GetState) == "function" then
                        isKP = true
                    end
                end)
                if not isKP and (tostring(id):find("Key") or tostring(id):find("Keybind")) then
                    isKP = type(kp) == "table"
                end
                if isKP and id ~= "MenuKeybind" then
                    local active = false
                    pcall(function()
                        if type(kp.GetState) == "function" then active = kp:GetState() == true end
                    end)
                    if not active and toggles then
                        -- try linked toggle
                        for _, tg in pairs(toggles) do
                            if tg and tg.Value == true then
                                -- show key row if key assigned
                            end
                        end
                    end
                    local kn = keyName(kp)
                    if kn == "..." or kn == "None" then
                        if config.KeybindListOnlyActive then continue end
                    end
                    local md = modeName(kp)
                    local show = true
                    if config.KeybindListOnlyActive then
                        show = active == true or (toggles and false)
                        -- show if GetState or mode Always
                        if md == "Always" then show = true end
                        if type(kp.GetState) == "function" then
                            local ok, st = pcall(function() return kp:GetState() end)
                            show = ok and st == true
                        end
                    end
                    if show then
                        count += 1
                        local row = Instance.new("Frame")
                        row.Size = UDim2.new(1, -6, 0, 18)
                        row.BackgroundTransparency = 1
                        row.Parent = list
                        local nameL = Instance.new("TextLabel")
                        nameL.BackgroundTransparency = 1
                        nameL.Size = UDim2.new(0.62, 0, 1, 0)
                        nameL.Position = UDim2.fromOffset(6, 0)
                        nameL.Font = Enum.Font.Code
                        nameL.TextSize = 12
                        nameL.TextXAlignment = Enum.TextXAlignment.Left
                        nameL.TextColor3 = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(160, 160, 160)
                        nameL.Text = tostring(id):gsub("Key$", ""):gsub("Keybind", "")
                        nameL.Parent = row
                        local keyL = Instance.new("TextLabel")
                        keyL.BackgroundTransparency = 1
                        keyL.Size = UDim2.new(0.35, -4, 1, 0)
                        keyL.Position = UDim2.new(0.62, 0, 0, 0)
                        keyL.Font = Enum.Font.Code
                        keyL.TextSize = 11
                        keyL.TextXAlignment = Enum.TextXAlignment.Right
                        keyL.TextColor3 = active and Color3.fromRGB(140, 200, 255) or Color3.fromRGB(120, 120, 120)
                        keyL.Text = kn .. (md ~= "Toggle" and (" · " .. md) or "")
                        keyL.Parent = row
                    end
                end
            end
        end
        local h = 22 + count * 19
        frame.Size = UDim2.fromOffset(200, math.max(28, h))
        list.Size = UDim2.new(1, 0, 0, count * 19)
    end

    KB.Refresh = refresh
    task.spawn(function()
        while gui.Parent do
            pcall(refresh)
            task.wait(0.35)
        end
    end)
    KB.SetVisible(config.KeybindListEnabled ~= false)
end)


pcall(function()
    if SaveManager and SaveManager.BuildConfigSection then
        local smBox = Tabs.Configs:AddRightGroupbox("SaveManager (Obsidian)")
        SaveManager:SetLibrary(Library)
        SaveManager:SetFolder("shako_win")
        pcall(function() SaveManager:IgnoreThemeSettings() end)
        SaveManager:BuildConfigSection(smBox)
    end
end)
pcall(function()
    if ThemeManager and ThemeManager.ApplyToGroupbox then
        local th = Tabs.Configs:AddRightGroupbox("Theme")
        ThemeManager:ApplyToGroupbox(th)
    elseif ThemeManager and ThemeManager.ApplyToTab then
        ThemeManager:ApplyToTab(Tabs.Configs)
    end
end)

CfgBox:AddLabel("Save settings")






RefreshCfg()

-- ELISIUM visuals UI
pcall(function()
    local visTab = Tabs.Visuals or Tabs.World or Tabs.Misc
    if not visTab then return end
    local EliBox = visTab:AddLeftGroupbox("elisium stretch / fov")
    EliBox:AddToggle("EliStretch", {
        Text = "Stretched Resolution (Elisium)", Default = false,
        Callback = function(v) config.EliStretch = v end
    })
    EliBox:AddSlider("EliStretchAmount", {
        Text = "Stretch Amount", Default = 0.20, Min = 0.05, Max = 1, Rounding = 2,
        Callback = function(v) config.EliStretchAmount = v end
    })
    EliBox:AddToggle("EliFOV", {
        Text = "FOV Changer", Default = false,
        Callback = function(v) config.EliFOV = v end
    })
    EliBox:AddSlider("EliFOVValue", {
        Text = "FOV", Default = 80, Min = 40, Max = 120, Rounding = 0,
        Callback = function(v) config.EliFOVValue = v end
    })

    local TrBox = visTab:AddRightGroupbox("elisium tracers")
    TrBox:AddToggle("EliTracers", {
        Text = "Bullet Tracers (Elisium)", Default = false,
        Callback = function(v) config.EliTracers = v; config.EliTracerEnabled = v; config.BulletTracerEnabled = v end
    })
    TrBox:AddDropdown("EliTracerTexture", {
        Text = "Texture",
        Values = {"lightning","beam","heartrate","chain","glitch","swirl","neon","laser1","line1","none (solid)"},
        Default = 1,
        Callback = function(v) config.EliTracerTexture = v end
    })
    TrBox:AddSlider("EliTracerLife", {
        Text = "Lifetime", Default = 1.5, Min = 0.2, Max = 5, Rounding = 1,
        Callback = function(v) config.EliTracerLife = v end
    })
    TrBox:AddSlider("EliTracerGlow", {
        Text = "Glow", Default = 4, Min = 0, Max = 12, Rounding = 1,
        Callback = function(v) config.EliTracerGlow = v end
    })
    TrBox:AddSlider("EliTracerWidth0", {
        Text = "Width Start", Default = 0.35, Min = 0.05, Max = 2, Rounding = 2,
        Callback = function(v) config.EliTracerWidth0 = v end
    })
    TrBox:AddSlider("EliTracerWidth1", {
        Text = "Width End", Default = 0.15, Min = 0.02, Max = 2, Rounding = 2,
        Callback = function(v) config.EliTracerWidth1 = v end
    })
    TrBox:AddSlider("EliTracerSpeed", {
        Text = "Texture Speed", Default = 3, Min = 0, Max = 20, Rounding = 1,
        Callback = function(v) config.EliTracerSpeed = v end
    })
    TrBox:AddToggle("EliTracerThroughWalls", {
        Text = "Through Walls (drawing)", Default = false,
        Callback = function(v) config.EliTracerThroughWalls = v end
    })

    local HsBox = visTab:AddLeftGroupbox("elisium hitsounds")
    HsBox:AddToggle("EliHitSound", {
        Text = "Elisium Hit Sounds", Default = false,
        Callback = function(v)
            config.EliHitSound = v
            if v then config.HitSoundEnabled = false end -- replace old
        end
    })
    HsBox:AddDropdown("EliHitSoundName", {
        Text = "Sound",
        Values = {"windows xp","minecraft bow","neverlose","steve","among us","bonk","rust","fatality","hitmarker","csgo","minecraft success bow hit"},
        Default = 7,
        Callback = function(v) config.EliHitSoundName = v end
    })
    HsBox:AddSlider("EliHitVolume", {
        Text = "Volume", Default = 3, Min = 0.1, Max = 10, Rounding = 1,
        Callback = function(v) config.EliHitVolume = v end
    })
    HsBox:AddSlider("EliHitPitch", {
        Text = "Pitch", Default = 1, Min = 0.1, Max = 3, Rounding = 1,
        Callback = function(v) config.EliHitPitch = v end
    })
    HsBox:AddToggle("EliHitRemoveDefault", {
        Text = "Remove Default Hitsound", Default = true,
        Callback = function(v) config.EliHitRemoveDefault = v end
    })
    HsBox:AddButton({
        Text = "Test Hit Sound",
        Func = function()
            -- fuerza prueba aunque el toggle este off temporalmente
            local prev = config.EliHitSound
            config.EliHitSound = true
            if getgenv()._ShakoEli and getgenv()._ShakoEli.playHit then
                getgenv()._ShakoEli.playHit()
            elseif SFX and SFX.hit then
                local p2 = config.HitSoundEnabled
                config.HitSoundEnabled = true
                SFX.hit()
                config.HitSoundEnabled = p2
            end
            config.EliHitSound = prev
        end
    })

    local DnBox = visTab:AddRightGroupbox("elisium damage numbers")
    DnBox:AddToggle("EliDmgNum", {
        Text = "Damage Numbers (quita los del juego)", Default = false,
        Callback = function(v)
            config.EliDmgNum = v
            config.EliDmgRemoveIngame = v and true or false
        end
    })
    DnBox:AddToggle("EliDmgGradient", {
        Text = "Gradient", Default = true,
        Callback = function(v) config.EliDmgGradient = v end
    })
    pcall(function()
        if addColor3 then
            addColor3(DnBox, "EliDmgColor1", "Color 1",
                function() return config.EliDmgColor1 or Color3.fromRGB(255, 80, 80) end,
                function(c) config.EliDmgColor1 = c end)
            addColor3(DnBox, "EliDmgColor2", "Color 2 (gradient)",
                function() return config.EliDmgColor2 or Color3.fromRGB(255, 210, 90) end,
                function(c) config.EliDmgColor2 = c end)
        else
            local lbl1 = DnBox:AddLabel("Color 1")
            if lbl1 and lbl1.AddColorPicker then
                lbl1:AddColorPicker("EliDmgColor1", {
                    Default = config.EliDmgColor1 or Color3.fromRGB(255, 80, 80),
                    Title = "Color 1",
                    Callback = function(c) config.EliDmgColor1 = c end
                })
            end
            local lbl2 = DnBox:AddLabel("Color 2")
            if lbl2 and lbl2.AddColorPicker then
                lbl2:AddColorPicker("EliDmgColor2", {
                    Default = config.EliDmgColor2 or Color3.fromRGB(255, 210, 90),
                    Title = "Color 2",
                    Callback = function(c) config.EliDmgColor2 = c end
                })
            end
        end
    end)
    DnBox:AddDropdown("EliDmgFont", {
        Text = "Font",
        Values = {"GothamBold","Gotham","SourceSansBold","Code","Arcade","Fantasy","SciFi","BuilderSansBold"},
        Default = 1,
        Callback = function(v) config.EliDmgFont = v end
    })
    DnBox:AddSlider("EliDmgSize", {
        Text = "Text Size", Default = 18, Min = 10, Max = 40, Rounding = 0,
        Callback = function(v) config.EliDmgSize = v end
    })
    DnBox:AddSlider("EliDmgDuration", {
        Text = "Duration", Default = 0.8, Min = 0.2, Max = 3, Rounding = 1,
        Callback = function(v) config.EliDmgDuration = v end
    })
    DnBox:AddSlider("EliDmgRise", {
        Text = "Rise", Default = 42, Min = 0, Max = 120, Rounding = 0,
        Callback = function(v) config.EliDmgRise = v end
    })
    DnBox:AddLabel("Solo muestra daño de TUS hits")

    local DeBox = visTab:AddLeftGroupbox("elisium death effects")
    DeBox:AddToggle("EliDeathFX", {
        Text = "Death Effects", Default = false,
        Callback = function(v) config.EliDeathFX = v end
    })
    DeBox:AddDropdown("EliDeathType", {
        Text = "Type",
        Values = {"Explosion", "Fire", "Sparkles", "Neon Burst"},
        Default = 1,
        Callback = function(v) config.EliDeathType = v end
    })

    local WrBox = visTab:AddRightGroupbox("elisium world")
    WrBox:AddToggle("EliAntiFlash", {
        Text = "Anti Flashbang", Default = false,
        Callback = function(v) config.EliAntiFlash = v end
    })
    WrBox:AddToggle("EliWorldTex", {
        Text = "World Textures", Default = false,
        Callback = function(v)
            config.EliWorldTex = v
            if v and getgenv()._ShakoEli then getgenv()._ShakoEli.applyWorldTex() end
        end
    })
    WrBox:AddDropdown("EliWorldMaterial", {
        Text = "Material",
        Values = {"SmoothPlastic","Neon","ForceField","Glass","Concrete","Fabric"},
        Default = 1,
        Callback = function(v) config.EliWorldMaterial = v end
    })
    WrBox:AddButton({
        Text = "Apply World Textures",
        Func = function()
            if getgenv()._ShakoEli then getgenv()._ShakoEli.applyWorldTex() end
        end
    })

    local ChBox = visTab:AddLeftGroupbox("elisium weapon chams")
    ChBox:AddToggle("EliWeaponChams", {
        Text = "Weapon Chams", Default = false,
        Callback = function(v)
            config.EliWeaponChams = v
            if v and getgenv()._ShakoEli then getgenv()._ShakoEli.applyWeaponChams() end
        end
    })
    ChBox:AddDropdown("EliWeaponMaterial", {
        Text = "Weapon Material",
        Values = {"Neon","ForceField","Glass","SmoothPlastic","Metal"},
        Default = 1,
        Callback = function(v) config.EliWeaponMaterial = v end
    })
    ChBox:AddSlider("EliWeaponTrans", {
        Text = "Weapon Transparency", Default = 0, Min = 0, Max = 1, Rounding = 2,
        Callback = function(v) config.EliWeaponTrans = v end
    })
    ChBox:AddToggle("EliArmChams", {
        Text = "Arm Chams", Default = false,
        Callback = function(v) config.EliArmChams = v end
    })
    ChBox:AddDropdown("EliArmMaterial", {
        Text = "Arm Material",
        Values = {"ForceField","Neon","Glass","SmoothPlastic"},
        Default = 1,
        Callback = function(v) config.EliArmMaterial = v end
    })
end)

end -- BuildUI
pcall(function() BuildUI() end)
if not Window then warn("[shako] UI fail") return end

-- Keybinds eliminadas (slide C ya no activa Strafe)
-- Todo se controla solo desde la UI Obsidian

LocalPlayer.CharacterAdded:Connect(function(char)
    if config.ForceFieldVisual then
        task.defer(function()
            task.wait(0.4)
            ApplyForceField(char)
        end)
    end
    CanMove = false
    SpawnTime = tick()
    AntiUnnamedReady = false
    AntiUnnamedStartTime = tick()
    LastAUCharacter = char
    HookCharacter(char)
    task.wait(config.SpawnDelay or 4.7)
    CanMove = true
    ResetCameraNormal()
    if config.AntiUnnamed then
        ArmAntiUnnamedOnSpawn()
        StartAUWatcher()
    else
        if config.Enabled or config.StrafeEnabled or config.OrbitEnabled then StartMainLoop() end
        if config.RagebotEnabled then StartRagebot() end
        if config.VoidSpamEnabled then StartVoidSpam() end
    end
    if config.FlyEnabled then StartFly() end
    if config.NoclipEnabled then StartNoclip() end
    if config.AntiAimEnabled then StartAntiAim() end
    if config.AimbotEnabled then StartAimbot() end
    if config.AutoClickEnabled then StartAutoClick() end
    if config.NoRecoil then StartNoRecoil() end
    if config.RapidFire then StartRapidFire() end
    if config.FastMelee then StartFastMelee() end
    if config.PredDodgeEnabled then StartPredDodge() end
    if config.TriggerbotEnabled then StartTriggerbot() end
    if config.ESPEnabled then task.defer(function() pcall(StartESP) end) end
    lastHurtHP = 100
    if anyDefenseOn() then StartDefense() end
end)

if LocalPlayer.Character then
    HookCharacter(LocalPlayer.Character)
    LastAUCharacter = LocalPlayer.Character
end

SetupAntiKick()
task.defer(ResetCameraNormal)

CanMove = false
SpawnTime = tick()
task.spawn(function()
    task.wait(math.min(config.SpawnDelay or 2, 3))
    CanMove = true
    pcall(function()
        if config.Enabled or config.StrafeEnabled or config.OrbitEnabled then
            StartMainLoop()
        end
        if config.UECounterEnabled or config.AntiUnnamed then
            StartUECounter()
            StartAUWatcher()
        end
        if config.ESPEnabled then
            task.wait(0.5)
            pcall(StartESP)
        end
        if config.NoRecoil then StartNoRecoil() end
        if config.RapidFire then StartRapidFire() end
        if config.FastMelee then StartFastMelee() end
        if config.SlideBoostEnabled then StartSlideBoostLoop() end
        -- stretch available (CFrame matrix)
        ResetCameraNormal()
        EnsureCameraFree()
    end)
end)

getgenv()._ShakoUIReady = true

-- Avatar spoof removido

Notify("shako.win", "loaded")
print("shako.win v6.6.0 HARION anti-aim")
pcall(function() task.defer(function()
    getgenv()._ShakoQuiet = true
    pcall(Cfg.TryAutoLoad)
    task.wait(2)
    getgenv()._ShakoQuiet = false
end) end)





-- ==================== ELISIUM VISUALS PACK (register-safe function scope) ====================
task.spawn(function()
    local Eli = getgenv()._ShakoEli
    if type(Eli) ~= "table" then Eli = {} end
    getgenv()._ShakoEli = Eli

    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Lighting = game:GetService("Lighting")
    local UserInputService = game:GetService("UserInputService")
    local SoundService = game:GetService("SoundService")
    local LocalPlayer = Players.LocalPlayer
    local config = getgenv().config
    if type(config) ~= "table" then return end

    Eli.hitsounds = {
        ["windows xp"] = 108009100115241,
        ["minecraft bow"] = 3442683707,
        ["neverlose"] = 97643101798871,
        ["steve"] = 132883456216684,
        ["among us"] = 93866204681438,
        ["bonk"] = 5766898159,
        ["rust"] = 1255040462,
        ["fatality"] = 6534947869,
        ["hitmarker"] = 133749572213659,
        ["csgo"] = 5764885315,
        ["minecraft success bow hit"] = 131197435969853,
    }
    Eli.tracerTextures = {
        ["beam"] = "rbxassetid://12781852245",
        ["lightning"] = "rbxassetid://446111271",
        ["heartrate"] = "rbxassetid://5830549480",
        ["chain"] = "rbxassetid://9632168658",
        ["glitch"] = "rbxassetid://8089467613",
        ["swirl"] = "rbxassetid://5638168605",
        ["neon"] = "rbxassetid://6361963422",
        ["laser1"] = "rbxassetid://6091329339",
        ["line1"] = "rbxassetid://16726866463",
        ["none (solid)"] = "",
    }

    local function ensure(k, v)
        if config[k] == nil then config[k] = v end
    end
    ensure("EliStretch", false)
    ensure("EliStretchAmount", 0.20)
    ensure("EliFOV", false)
    ensure("EliFOVValue", 80)
    ensure("EliTracers", false)
    ensure("EliTracerTexture", "lightning")
    ensure("EliTracerLife", 1.5)
    ensure("EliTracerGlow", 4)
    ensure("EliTracerWidth0", 0.35)
    ensure("EliTracerWidth1", 0.15)
    ensure("EliTracerSpeed", 3)
    ensure("EliTracerThroughWalls", false)
    ensure("EliTracerColorStart", Color3.fromRGB(255, 255, 255))
    ensure("EliTracerColorEnd", Color3.fromRGB(255, 200, 80))
    ensure("EliHitSound", false)
    ensure("EliHitSoundName", "rust")
    ensure("EliHitVolume", 3)
    ensure("EliHitPitch", 1)
    ensure("EliHitRemoveDefault", true)
    ensure("EliDmgNum", false)
    ensure("EliDmgRemoveIngame", true)
    ensure("EliDmgColor1", Color3.fromRGB(255, 80, 80))
    ensure("EliDmgColor2", Color3.fromRGB(255, 210, 90))
    ensure("EliDmgFont", "GothamBold")
    ensure("EliDmgSize", 18)
    ensure("EliDmgDuration", 0.8)
    ensure("EliDmgRise", 42)
    ensure("EliDmgGradient", true)
    ensure("EliDeathFX", false)
    ensure("EliDeathType", "Explosion")
    ensure("EliDeathColor", Color3.fromRGB(120, 81, 166))
    ensure("EliAntiFlash", false)
    ensure("EliWorldTex", false)
    ensure("EliWorldColor", Color3.fromRGB(40, 40, 45))
    ensure("EliWorldMaterial", "SmoothPlastic")
    ensure("EliWeaponChams", false)
    ensure("EliWeaponColor", Color3.fromRGB(255, 105, 180))
    ensure("EliWeaponMaterial", "Neon")
    ensure("EliWeaponTrans", 0)
    ensure("EliArmChams", false)
    ensure("EliArmColor", Color3.fromRGB(255, 255, 255))
    ensure("EliArmMaterial", "ForceField")

    local function playEliHit()
        if not config or not config.EliHitSound then return end
        local now = tick()
        if Eli._lastHitAt and (now - Eli._lastHitAt) < 0.04 then return end
        Eli._lastHitAt = now
        local name = tostring(config.EliHitSoundName or "rust"):lower()
        local id = Eli.hitsounds[name] or Eli.hitsounds["rust"] or 1255040462
        local vol = math.clamp(tonumber(config.EliHitVolume) or 3, 0.1, 10)
        local pitch = math.clamp(tonumber(config.EliHitPitch) or 1, 0.1, 3)
        pcall(function()
            local s = Instance.new("Sound")
            s.Name = "ShakoEliHit"
            s.SoundId = "rbxassetid://" .. tostring(id)
            s.Volume = vol
            s.PlaybackSpeed = pitch
            s.Looped = false
            s.Parent = SoundService
            pcall(function() SoundService:PlayLocalSound(s) end)
            pcall(function() s:Play() end)
            task.delay(3, function() pcall(function() s:Destroy() end) end)
        end)
    end
    Eli.playHit = playEliHit

    task.defer(function()
        pcall(function()
            local ps = LocalPlayer:WaitForChild("PlayerScripts", 10)
            if not ps or Eli._hitHooked then return end
            local function tryHook(mod)
                if not mod then return end
                local ok, vm = pcall(require, mod)
                if not ok or type(vm) ~= "table" or type(vm.PlayHitmarkerSound) ~= "function" then return end
                if Eli._hitHooked then return end
                Eli._hitHooked = true
                local old = vm.PlayHitmarkerSound
                vm.PlayHitmarkerSound = function(controller, critical, pitch)
                    if config.EliHitSound then
                        playEliHit()
                        if config.EliHitRemoveDefault then return end
                    end
                    return old(controller, critical, pitch)
                end
            end
            for _, folder in ipairs({ps:FindFirstChild("Modules"), ps:FindFirstChild("Controllers")}) do
                if folder then
                    for _, child in ipairs(folder:GetDescendants()) do
                        if child.Name:find("ViewModel") or child.Name:find("ClientView") then
                            tryHook(child)
                        end
                    end
                end
            end
        end)
    end)

    if not Eli._camLoop then
        Eli._camLoop = true
        RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if not cam then return end
            if config.EliStretch then
                local a = tonumber(config.EliStretchAmount) or 0.2
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, a, 0, 0, 0, 1)
            end
            if config.EliFOV then
                cam.FieldOfView = tonumber(config.EliFOVValue) or 80
            end
        end)
    end

    function Eli.spawnTracer(fromPos, toPos)
        if not config.EliTracers then return end
        pcall(function()
            local p0 = Instance.new("Part")
            p0.Anchored = true p0.CanCollide = false p0.Transparency = 1
            p0.Size = Vector3.new(0.1, 0.1, 0.1)
            p0.CFrame = CFrame.new(fromPos)
            p0.Parent = workspace
            local p1 = p0:Clone()
            p1.CFrame = CFrame.new(toPos)
            p1.Parent = workspace
            local att0 = Instance.new("Attachment")
            local att1 = Instance.new("Attachment")
            att0.Parent = p0
            att1.Parent = p1
            local beam = Instance.new("Beam")
            beam.Attachment0 = att0
            beam.Attachment1 = att1
            beam.Width0 = tonumber(config.EliTracerWidth0) or 0.35
            beam.Width1 = tonumber(config.EliTracerWidth1) or 0.15
            beam.FaceCamera = true
            beam.LightEmission = tonumber(config.EliTracerGlow) or 4
            beam.Brightness = tonumber(config.EliTracerGlow) or 4
            beam.TextureSpeed = tonumber(config.EliTracerSpeed) or 3
            beam.Texture = Eli.tracerTextures[config.EliTracerTexture or "lightning"] or ""
            beam.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, config.EliTracerColorStart or Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, config.EliTracerColorEnd or Color3.new(1, 1, 1)),
            })
            beam.Parent = p0
            local life = tonumber(config.EliTracerLife) or 1.5
            task.delay(life, function()
                pcall(function() p0:Destroy() end)
                pcall(function() p1:Destroy() end)
            end)
        end)
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if gp or not config.EliTracers then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        task.defer(function()
            local cam = workspace.CurrentCamera
            local char = LocalPlayer.Character
            if not cam or not char then return end
            local origin = cam.CFrame.Position
            local dir = cam.CFrame.LookVector * 500
            local params = RaycastParams.new()
            params.FilterDescendantsInstances = {char}
            params.FilterType = Enum.RaycastFilterType.Exclude
            local res = workspace:Raycast(origin, dir, params)
            local to = res and res.Position or (origin + dir)
            local from = origin + cam.CFrame.LookVector * 2
            pcall(function()
                for _, d in ipairs(char:GetDescendants()) do
                    if d:IsA("BasePart") then
                        local n = d.Name:lower()
                        if n:find("muzzle") or n:find("barrel") then
                            from = d.Position
                            break
                        end
                    end
                end
            end)
            Eli.spawnTracer(from, to)
        end)
    end)

    local dgui
    pcall(function()
        dgui = Instance.new("ScreenGui")
        dgui.Name = "ShakoEliDmg"
        dgui.ResetOnSpawn = false
        dgui.IgnoreGuiInset = true
        dgui.DisplayOrder = 500
        dgui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
    end)

    function Eli.showDamage(amount, worldpos)
        if not config.EliDmgNum or not worldpos or not dgui then return end
        pcall(function()
            local cam = workspace.CurrentCamera
            local sp, on = cam:WorldToViewportPoint(worldpos)
            if not on then return end
            local lbl = Instance.new("TextLabel")
            lbl.BackgroundTransparency = 1
            lbl.Size = UDim2.fromOffset(140, 26)
            lbl.AnchorPoint = Vector2.new(0.5, 0.5)
            lbl.Position = UDim2.fromOffset(sp.X, sp.Y)
            local fontOk, font = pcall(function() return Enum.Font[config.EliDmgFont or "GothamBold"] end)
            lbl.Font = (fontOk and font) or Enum.Font.GothamBold
            lbl.TextSize = tonumber(config.EliDmgSize) or 18
            lbl.Text = "-" .. tostring(math.floor((amount or 0) + 0.5))
            lbl.TextColor3 = config.EliDmgColor1 or Color3.fromRGB(255, 80, 80)
            lbl.ZIndex = 10
            lbl.Parent = dgui
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = 1.5
            stroke.Color = Color3.new(0, 0, 0)
            stroke.Parent = lbl
            if config.EliDmgGradient ~= false then
                local g = Instance.new("UIGradient")
                g.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, config.EliDmgColor1 or Color3.fromRGB(255, 80, 80)),
                    ColorSequenceKeypoint.new(1, config.EliDmgColor2 or Color3.fromRGB(255, 210, 90)),
                })
                g.Rotation = 90
                g.Parent = lbl
                lbl.TextColor3 = Color3.new(1, 1, 1)
            end
            local startT = tick()
            local dur = tonumber(config.EliDmgDuration) or 0.8
            local rise = tonumber(config.EliDmgRise) or 42
            local jitter = math.random(-14, 14)
            local conn
            conn = RunService.RenderStepped:Connect(function()
                local tt = (tick() - startT) / dur
                if tt >= 1 then
                    conn:Disconnect()
                    pcall(function() lbl:Destroy() end)
                    return
                end
                lbl.Position = UDim2.fromOffset(sp.X + jitter * tt, sp.Y - rise * tt)
                lbl.TextTransparency = tt * tt
                stroke.Transparency = 0.15 + tt * 0.85
            end)
        end)
    end

    -- Damage numbers: solo si TÚ pegaste hace <0.45s (flag de PlayHitmarkerSound)
    -- Hitsound: NUNCA aquí (solo en hook LocalPlayer)
    task.spawn(function()
        task.wait(2)
        local last = {}
        while true do
            task.wait(0.1)
            if config.EliDmgNum then
                local hitAt = tonumber(getgenv()._ShakoLocalHitAt) or 0
                local recentLocalHit = (tick() - hitAt) < 0.45
                if recentLocalHit then
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer then
                            local char = plr.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            local hrp = char and char:FindFirstChild("HumanoidRootPart")
                            if hum and hrp then
                                local hp = hum.Health
                                local prev = last[plr]
                                if prev and hp < prev - 0.5 then
                                    Eli.showDamage(prev - hp, hrp.Position + Vector3.new(0, 2.2, 0))
                                end
                                last[plr] = hp
                            end
                        end
                    end
                else
                    -- actualizar last sin mostrar (otros pegando)
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr ~= LocalPlayer then
                            local char = plr.Character
                            local hum = char and char:FindFirstChildOfClass("Humanoid")
                            if hum then last[plr] = hum.Health end
                        end
                    end
                end
            end
        end
    end)

    function Eli.deathFX(pos)
        if not config.EliDeathFX or not pos then return end
        pcall(function()
            local typ = config.EliDeathType or "Explosion"
            local col = config.EliDeathColor or Color3.fromRGB(120, 81, 166)
            if typ == "Explosion" then
                local e = Instance.new("Explosion")
                e.Position = pos
                e.BlastPressure = 0
                e.BlastRadius = 0
                e.DestroyJointRadiusPercent = 0
                e.ExplosionType = Enum.ExplosionType.NoCraters
                e.Parent = workspace
            elseif typ == "Fire" then
                local part = Instance.new("Part")
                part.Anchored = true part.CanCollide = false part.Transparency = 1
                part.Size = Vector3.new(1, 1, 1) part.Position = pos part.Parent = workspace
                local f = Instance.new("Fire")
                f.Size = 10 f.Heat = 10 f.Color = col f.Parent = part
                task.delay(2, function() part:Destroy() end)
            elseif typ == "Sparkles" then
                local part = Instance.new("Part")
                part.Anchored = true part.CanCollide = false part.Transparency = 1
                part.Size = Vector3.new(1, 1, 1) part.Position = pos part.Parent = workspace
                local s = Instance.new("Sparkles")
                s.SparkleColor = col s.Parent = part
                task.delay(2, function() part:Destroy() end)
            else
                local part = Instance.new("Part")
                part.Anchored = true part.CanCollide = false
                part.Material = Enum.Material.Neon
                part.Color = col
                part.Size = Vector3.new(1, 1, 1)
                part.Position = pos
                part.Parent = workspace
                task.spawn(function()
                    for i = 1, 12 do
                        part.Size = Vector3.new(i, i, i)
                        part.Transparency = i / 12
                        task.wait(0.03)
                    end
                    part:Destroy()
                end)
            end
        end)
    end

    local function watchDeath(plr)
        if plr == LocalPlayer then return end
        local function bind(char)
            local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
            if not hum then return end
            hum.Died:Connect(function()
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then Eli.deathFX(hrp.Position) end
            end)
        end
        plr.CharacterAdded:Connect(bind)
        if plr.Character then bind(plr.Character) end
    end
    for _, plr in ipairs(Players:GetPlayers()) do watchDeath(plr) end
    Players.PlayerAdded:Connect(watchDeath)

    if not Eli._antiFlash then
        Eli._antiFlash = true
        -- stronger anti-flashbang: Lighting FX + PlayerGui + CoreGui overlays every frame
        RunService.RenderStepped:Connect(function()
            if not config.EliAntiFlash then return end
            pcall(function()
                local Lighting = game:GetService("Lighting")
                for _, fx in ipairs(Lighting:GetChildren()) do
                    if fx:IsA("ColorCorrectionEffect") then
                        if fx.Brightness > 0.05 or fx.Contrast > 0.15 or fx.Saturation < -0.2 then
                            fx.Brightness = 0
                            fx.Contrast = 0
                            fx.Saturation = 0
                            fx.TintColor = Color3.new(1, 1, 1)
                        end
                    elseif fx:IsA("BloomEffect") then
                        if fx.Intensity > 0.2 then fx.Intensity = 0 end
                        if fx.Size and fx.Size > 10 then fx.Size = 0 end
                    elseif fx:IsA("BlurEffect") then
                        if fx.Size > 1 then fx.Size = 0 end
                    elseif fx:IsA("SunRaysEffect") then
                        if fx.Intensity and fx.Intensity > 0.05 then fx.Intensity = 0 end
                    elseif fx:IsA("DepthOfFieldEffect") then
                        pcall(function() fx.FarIntensity = 0; fx.NearIntensity = 0 end)
                    end
                end
                -- white flash overlays in PlayerGui
                local lp = game:GetService("Players").LocalPlayer
                local pg = lp and lp:FindFirstChild("PlayerGui")
                if pg then
                    for _, g in ipairs(pg:GetDescendants()) do
                        if g:IsA("GuiObject") then
                            local n = string.lower(tostring(g.Name))
                            if n:find("flash") or n:find("blind") or n:find("bang") or n:find("stun") or n:find("white") then
                                g.Visible = false
                                if g:IsA("Frame") or g:IsA("ImageLabel") or g:IsA("TextLabel") then
                                    pcall(function() g.BackgroundTransparency = 1 end)
                                    pcall(function() g.ImageTransparency = 1 end)
                                    pcall(function() g.TextTransparency = 1 end)
                                end
                            end
                            -- pure white full-screen flash
                            if (g:IsA("Frame") or g:IsA("ImageLabel")) and g.Visible then
                                local bg = g.BackgroundColor3
                                if bg and bg.R > 0.92 and bg.G > 0.92 and bg.B > 0.92 then
                                    local t = g.BackgroundTransparency or 1
                                    if t < 0.4 and (g.Size.X.Scale >= 0.8 or g.Size.Y.Scale >= 0.8) then
                                        g.BackgroundTransparency = 1
                                        g.Visible = false
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end)
    end

    function Eli.applyWorldTex()
        if not config.EliWorldTex then return end
        task.spawn(function()
            local mat = Enum.Material[config.EliWorldMaterial or "SmoothPlastic"] or Enum.Material.SmoothPlastic
            local col = config.EliWorldColor or Color3.fromRGB(40, 40, 45)
            local n = 0
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") then
                    local skip = false
                    for _, plr in ipairs(Players:GetPlayers()) do
                        if plr.Character and obj:IsDescendantOf(plr.Character) then skip = true break end
                    end
                    if not skip then
                        pcall(function()
                            obj.Material = mat
                            obj.Color = col
                        end)
                        n = n + 1
                        if n % 80 == 0 then task.wait() end
                    end
                end
            end
        end)
    end

    function Eli.applyWeaponChams()
        local char = LocalPlayer.Character
        if not char then return end
        pcall(function()
            for _, d in ipairs(char:GetDescendants()) do
                if d:IsA("BasePart") then
                    local n = d.Name:lower()
                    local isArm = n:find("arm") or n:find("hand") or n:find("glove")
                    if config.EliWeaponChams and d.Parent and d.Parent:IsA("Tool") then
                        d.Material = Enum.Material[config.EliWeaponMaterial or "Neon"] or Enum.Material.Neon
                        d.Color = config.EliWeaponColor or Color3.fromRGB(255, 105, 180)
                        d.Transparency = tonumber(config.EliWeaponTrans) or 0
                    end
                    if config.EliArmChams and isArm then
                        d.Material = Enum.Material[config.EliArmMaterial or "ForceField"] or Enum.Material.ForceField
                        d.Color = config.EliArmColor or Color3.new(1, 1, 1)
                    end
                end
            end
            local cam = workspace.CurrentCamera
            if cam and config.EliWeaponChams then
                for _, d in ipairs(cam:GetDescendants()) do
                    if d:IsA("BasePart") then
                        d.Material = Enum.Material[config.EliWeaponMaterial or "Neon"] or Enum.Material.Neon
                        d.Color = config.EliWeaponColor or Color3.fromRGB(255, 105, 180)
                    end
                end
            end
        end)
    end

    task.spawn(function()
        while true do
            task.wait(0.5)
            if config.EliWeaponChams or config.EliArmChams then
                Eli.applyWeaponChams()
            end
        end
    end)

    
    -- Quitar damage numbers del JUEGO y usar solo los del hack
    task.defer(function()
        task.wait(1.5)
        pcall(function()
            local ps = LocalPlayer:FindFirstChild("PlayerScripts")
            local fc = ps and ps:FindFirstChild("Controllers")
            local FighterController = fc and fc:FindFirstChild("FighterController")
            if not FighterController then return end
            local ok, controller = pcall(require, FighterController)
            if not ok or not controller then return end
            local fighter = controller.LocalFighter
            if not fighter and type(controller.GetFighter) == "function" then
                pcall(function() fighter = controller:GetFighter(LocalPlayer) end)
            end
            if not fighter then return end

            -- Hook ReplicateFromServer (Elisium style)
            if type(fighter.ReplicateFromServer) == "function" and not Eli._dmgRepHooked then
                Eli._dmgRepHooked = true
                local orig = fighter.ReplicateFromServer
                fighter.ReplicateFromServer = function(ctrl, typ, ...)
                    if typ == "DamageNumberEffect" and config.EliDmgNum then
                        local args = {...}
                        local hit_root = args[1]
                        local hit_damage = args[2]
                        local is_headshot = args[3]
                        getgenv()._ShakoLocalHitAt = tick()
                        local pos
                        pcall(function()
                            if hit_root and hit_root.Position then
                                pos = hit_root.Position + Vector3.new(0, is_headshot and 2.6 or 2.1, 0)
                            end
                        end)
                        if pos and hit_damage then
                            Eli.showDamage(hit_damage, pos)
                        end
                        return -- NO mostrar numero del juego
                    end
                    return orig(ctrl, typ, ...)
                end
                print("[shako] DamageNumberEffect hooked (remove ingame)")
            end

            -- Hook _DamageNumberEffect on fighter metatable class
            pcall(function()
                local mt = getmetatable(fighter)
                local idx = mt and mt.__index
                if type(idx) == "table" and type(idx._DamageNumberEffect) == "function" and not Eli._dmgClassHooked then
                    Eli._dmgClassHooked = true
                    local old = idx._DamageNumberEffect
                    idx._DamageNumberEffect = function(...)
                        if config.EliDmgNum then
                            -- intentar extraer daño/pos de args
                            local args = table.pack(...)
                            for i = 1, args.n do
                                local a = args[i]
                                if typeof(a) == "Vector3" then
                                    Eli.showDamage(25, a) -- fallback amount
                                    break
                                elseif typeof(a) == "Instance" and a:IsA("BasePart") then
                                    Eli.showDamage(25, a.Position + Vector3.new(0, 2.2, 0))
                                    break
                                end
                            end
                            return nil
                        end
                        return old(...)
                    end
                end
            end)
        end)
    end)


    print("[shako] Elisium visuals pack OK (isolated scope)")
end)



-- ==================== UNLOCK ALL (Rivals Skinchanger - low lag) ====================
-- Instala hooks UNA sola vez. Sin loops por frame.
StartUnlockAll, StopUnlockAll = StartUnlockAll, StopUnlockAll;
do
    local installed = false
    local enabledFlag = false
    local equipped, favorites = {}, {}
    local constructingWeapon, viewingProfile = nil, nil
    local lastUsedWeapon = nil
    local origHooks = {}

    local function saveFile()
        return "shako_win/unlock_skins.json"
    end

    local function saveConfig()
        if not writefile then return end
        pcall(function()
            local HttpService = game:GetService("HttpService")
            local configSave = { equipped = {}, favorites = favorites }
            for weapon, cosmetics in pairs(equipped) do
                configSave.equipped[weapon] = {}
                for cosmeticType, cosmeticData in pairs(cosmetics) do
                    if cosmeticData and cosmeticData.Name then
                        configSave.equipped[weapon][cosmeticType] = {
                            name = cosmeticData.Name,
                            seed = cosmeticData.Seed,
                            inverted = cosmeticData.Inverted,
                        }
                    end
                end
            end
            if makefolder then pcall(makefolder, "shako_win") end
            writefile(saveFile(), HttpService:JSONEncode(configSave))
        end)
    end

    local function loadConfigSkins()
        if not (readfile and isfile) then return end
        pcall(function()
            local path = saveFile()
            if not isfile(path) then return end
            local HttpService = game:GetService("HttpService")
            local data = HttpService:JSONDecode(readfile(path))
            favorites = data.favorites or {}
            -- equipped se rehidrata cuando hay CosmeticLibrary
            getgenv()._ShakoUnlockEquippedRaw = data.equipped or {}
        end)
    end

    local function isFinisher(cosmetic)
        if not cosmetic then return false end
        local t = cosmetic.Type
        return t == "Finisher" or t == "Finish" or (t and string.find(string.lower(tostring(t)), "finish"))
    end

    local function isEmote(cosmetic)
        if not cosmetic then return false end
        local t = cosmetic.Type
        return t == "Dance" or t == "Emote"
    end

    function StartUnlockAll()
        enabledFlag = true
        config.UnlockAll = true
        if installed then
            print("[shako] Unlock All already installed")
            return
        end
        installed = true
        loadConfigSkins()

        local ok, err = pcall(function()
            local Players = game:GetService("Players")
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local HttpService = game:GetService("HttpService")
            local player = Players.LocalPlayer
            local playerScripts = player:WaitForChild("PlayerScripts", 10)
            if not playerScripts then return end
            local controllers = playerScripts:WaitForChild("Controllers", 10)
            if not controllers then return end

            local EnumLibrary = require(ReplicatedStorage.Modules:WaitForChild("EnumLibrary", 10))
            if EnumLibrary and EnumLibrary.WaitForEnumBuilder then
                pcall(function() EnumLibrary:WaitForEnumBuilder() end)
            end
            local CosmeticLibrary = require(ReplicatedStorage.Modules:WaitForChild("CosmeticLibrary", 10))
            local ItemLibrary = require(ReplicatedStorage.Modules:WaitForChild("ItemLibrary", 10))
            local DataController = require(controllers:WaitForChild("PlayerDataController", 10))

            local function cloneCosmetic(name, cosmeticType, options)
                local base = CosmeticLibrary.Cosmetics[name]
                if not base then return nil end
                local data = {}
                for key, value in pairs(base) do data[key] = value end
                data.Name = name
                data.Type = data.Type or cosmeticType
                data.Seed = data.Seed or math.random(1, 1000000)
                if EnumLibrary then
                    local success, enumId = pcall(EnumLibrary.ToEnum, EnumLibrary, name)
                    if success and enumId then
                        data.Enum, data.ObjectID = enumId, data.ObjectID or enumId
                    end
                end
                if options then
                    if options.inverted ~= nil then data.Inverted = options.inverted end
                    if options.favoritesOnly ~= nil then data.OnlyUseFavorites = options.favoritesOnly end
                end
                return data
            end

            -- rehydrate equipped from disk
            local raw = getgenv()._ShakoUnlockEquippedRaw
            if type(raw) == "table" then
                for weapon, cosmetics in pairs(raw) do
                    equipped[weapon] = {}
                    for cosmeticType, cosmeticData in pairs(cosmetics) do
                        local cloned = cloneCosmetic(cosmeticData.name, cosmeticType, { inverted = cosmeticData.inverted })
                        if cloned then
                            cloned.Seed = cosmeticData.seed
                            equipped[weapon][cosmeticType] = cloned
                        end
                    end
                end
            end

            -- OwnsCosmetic: report true for all real cosmetics (solo si UnlockAll activo)
            if not origHooks.OwnsCosmetic then
                origHooks.OwnsCosmetic = CosmeticLibrary.OwnsCosmetic
                CosmeticLibrary.OwnsCosmetic = function(self, inventory, name, weapon)
                    if enabledFlag and name and not tostring(name):find("MISSING_") then
                        local cosmetic = CosmeticLibrary.Cosmetics[name]
                        if cosmetic then return true end
                    end
                    return origHooks.OwnsCosmetic(self, inventory, name, weapon)
                end
            end

            if not origHooks.Get then
                origHooks.Get = DataController.Get
                DataController.Get = function(self, key)
                    local data = origHooks.Get(self, key)
                    if not enabledFlag then return data end
                    if key == "CosmeticInventory" then
                        local proxy = {}
                        if data then
                            for k, v in pairs(data) do
                                local cosmetic = CosmeticLibrary.Cosmetics[k]
                                if cosmetic then proxy[k] = v end
                            end
                        end
                        return setmetatable(proxy, {
                            __index = function(_, k)
                                local cosmetic = CosmeticLibrary.Cosmetics[k]
                                if cosmetic then return true end
                                return nil
                            end,
                        })
                    end
                    if key == "FavoritedCosmetics" then
                        local result = data and table.clone(data) or {}
                        for weapon, favs in pairs(favorites) do
                            result[weapon] = result[weapon] or {}
                            for name, isFav in pairs(favs) do
                                local cosmetic = CosmeticLibrary.Cosmetics[name]
                                if cosmetic then result[weapon][name] = isFav end
                            end
                        end
                        return result
                    end
                    return data
                end
            end

            if not origHooks.GetWeaponData then
                origHooks.GetWeaponData = DataController.GetWeaponData
                DataController.GetWeaponData = function(self, weaponName)
                    local data = origHooks.GetWeaponData(self, weaponName)
                    if not data then return nil end
                    if not enabledFlag then return data end
                    local merged = {}
                    for key, value in pairs(data) do merged[key] = value end
                    merged.Name = weaponName
                    if equipped[weaponName] then
                        for cosmeticType, cosmeticData in pairs(equipped[weaponName]) do
                            if cosmeticType ~= "Dances" then
                                merged[cosmeticType] = cosmeticData
                            end
                        end
                    end
                    return merged
                end
            end

            local FighterController
            pcall(function()
                FighterController = require(controllers:WaitForChild("FighterController", 10))
            end)

            if hookmetamethod and not origHooks.namecall then
                local remotes = ReplicatedStorage:FindFirstChild("Remotes")
                local dataRemotes = remotes and remotes:FindFirstChild("Data")
                local equipRemote = dataRemotes and dataRemotes:FindFirstChild("EquipCosmetic")
                local favoriteRemote = dataRemotes and dataRemotes:FindFirstChild("FavoriteCosmetic")
                local replicationRemotes = remotes and remotes:FindFirstChild("Replication")
                local fighterRemotes = replicationRemotes and replicationRemotes:FindFirstChild("Fighter")
                local useItemRemote = fighterRemotes and fighterRemotes:FindFirstChild("UseItem")

                if equipRemote then
                    local oldNamecall
                    oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                        if getnamecallmethod() ~= "FireServer" then
                            return oldNamecall(self, ...)
                        end
                        if not enabledFlag then
                            return oldNamecall(self, ...)
                        end
                        local args = { ... }
                        if useItemRemote and self == useItemRemote then
                            local objectID = args[1]
                            if FighterController then
                                pcall(function()
                                    local fighter = FighterController:GetFighter(player)
                                    if fighter and fighter.Items then
                                        for _, item in pairs(fighter.Items) do
                                            if item:Get("ObjectID") == objectID then
                                                lastUsedWeapon = item.Name
                                                break
                                            end
                                        end
                                    end
                                end)
                            end
                        end
                        if self == equipRemote then
                            local weaponName, cosmeticType, cosmeticName, options = args[1], args[2], args[3], args[4] or {}
                            local cosmetic = CosmeticLibrary.Cosmetics[cosmeticName]
                            if cosmetic and (isFinisher(cosmetic) or isEmote(cosmetic)) then
                                if isEmote(cosmetic) then
                                    equipped.Dances = equipped.Dances or {}
                                    if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                                        equipped.Dances[cosmeticType] = nil
                                    else
                                        local cloned = cloneCosmetic(cosmeticName, cosmeticType, {
                                            inverted = options.IsInverted,
                                            favoritesOnly = options.OnlyUseFavorites,
                                        })
                                        if cloned then equipped.Dances[cosmeticType] = cloned end
                                    end
                                else
                                    equipped[weaponName] = equipped[weaponName] or {}
                                    if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                                        equipped[weaponName][cosmeticType] = nil
                                        if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                                    else
                                        local cloned = cloneCosmetic(cosmeticName, cosmeticType, {
                                            inverted = options.IsInverted,
                                            favoritesOnly = options.OnlyUseFavorites,
                                        })
                                        if cloned then equipped[weaponName][cosmeticType] = cloned end
                                    end
                                end
                                saveConfig()
                                return oldNamecall(self, ...)
                            end
                            if cosmeticName and cosmeticName ~= "None" and cosmeticName ~= "" then
                                local inventory = DataController:Get("CosmeticInventory")
                                if inventory and rawget(inventory, cosmeticName) then
                                    return oldNamecall(self, ...)
                                end
                            end
                            equipped[weaponName] = equipped[weaponName] or {}
                            if not cosmeticName or cosmeticName == "None" or cosmeticName == "" then
                                equipped[weaponName][cosmeticType] = nil
                                if not next(equipped[weaponName]) then equipped[weaponName] = nil end
                            else
                                local cloned = cloneCosmetic(cosmeticName, cosmeticType, {
                                    inverted = options.IsInverted,
                                    favoritesOnly = options.OnlyUseFavorites,
                                })
                                if cloned then equipped[weaponName][cosmeticType] = cloned end
                            end
                            task.defer(function()
                                pcall(function() DataController.CurrentData:Replicate("WeaponInventory") end)
                                task.wait(0.2)
                                saveConfig()
                            end)
                            return
                        end
                        if self == favoriteRemote then
                            local cosmetic = CosmeticLibrary.Cosmetics[args[2]]
                            if cosmetic then
                                favorites[args[1]] = favorites[args[1]] or {}
                                favorites[args[1]][args[2]] = args[3] or nil
                                saveConfig()
                                task.spawn(function()
                                    pcall(function() DataController.CurrentData:Replicate("FavoritedCosmetics") end)
                                end)
                            end
                            return
                        end
                        return oldNamecall(self, ...)
                    end)
                    origHooks.namecall = true
                end
            end

            -- ViewModel skin apply
            local ClientItem
            pcall(function()
                ClientItem = require(player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem)
            end)
            if ClientItem and ClientItem._CreateViewModel and not origHooks.CreateVM then
                origHooks.CreateVM = ClientItem._CreateViewModel
                ClientItem._CreateViewModel = function(self, viewmodelRef)
                    local weaponName = self.Name
                    local weaponPlayer = self.ClientFighter and self.ClientFighter.Player
                    constructingWeapon = (weaponPlayer == player) and weaponName or nil
                    if enabledFlag and weaponPlayer == player and equipped[weaponName] and viewmodelRef then
                        local dataKey = self:ToEnum("Data")
                        local skinKey = self:ToEnum("Skin")
                        local charmKey = self:ToEnum("Charm")
                        local wrapKey = self:ToEnum("Wrap")
                        local nameKey = self:ToEnum("Name")
                        local data = viewmodelRef[dataKey] or viewmodelRef.Data
                        if data then
                            if equipped[weaponName].Skin then
                                data[skinKey or "Skin"] = equipped[weaponName].Skin
                                data[nameKey or "Name"] = equipped[weaponName].Skin.Name
                            end
                            if equipped[weaponName].Charm then
                                data[charmKey or "Charm"] = equipped[weaponName].Charm
                            end
                            if equipped[weaponName].Wrap then
                                data[wrapKey or "Wrap"] = equipped[weaponName].Wrap
                            end
                        end
                    end
                    local result = origHooks.CreateVM(self, viewmodelRef)
                    constructingWeapon = nil
                    return result
                end
            end

            local viewModelModule = player.PlayerScripts.Modules.ClientReplicatedClasses.ClientFighter.ClientItem:FindFirstChild("ClientViewModel")
            if viewModelModule then
                local ClientViewModel = require(viewModelModule)
                if ClientViewModel and ClientViewModel.new and not origHooks.VMNew then
                    origHooks.VMNew = ClientViewModel.new
                    ClientViewModel.new = function(replicatedData, clientItem)
                        local weaponPlayer = clientItem.ClientFighter and clientItem.ClientFighter.Player
                        local weaponName = constructingWeapon or clientItem.Name
                        if enabledFlag and weaponPlayer == player and equipped[weaponName] then
                            local ReplicatedClass = require(ReplicatedStorage.Modules.ReplicatedClass)
                            local dataKey = ReplicatedClass:ToEnum("Data")
                            replicatedData[dataKey] = replicatedData[dataKey] or {}
                            local cosmetics = equipped[weaponName]
                            if cosmetics.Skin then
                                replicatedData[dataKey][ReplicatedClass:ToEnum("Skin")] = cosmetics.Skin
                            end
                            if cosmetics.Charm then
                                replicatedData[dataKey][ReplicatedClass:ToEnum("Charm")] = cosmetics.Charm
                            end
                            if cosmetics.Wrap then
                                replicatedData[dataKey][ReplicatedClass:ToEnum("Wrap")] = cosmetics.Wrap
                            end
                        end
                        local result = origHooks.VMNew(replicatedData, clientItem)
                        if enabledFlag and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap and result._UpdateWrap then
                            result:_UpdateWrap()
                            task.delay(0.1, function()
                                if not result._destroyed then result:_UpdateWrap() end
                            end)
                        end
                        return result
                    end
                end
                if ClientViewModel.GetCharm and not origHooks.GetCharm then
                    origHooks.GetCharm = ClientViewModel.GetCharm
                    ClientViewModel.GetCharm = function(self)
                        if enabledFlag then
                            local weaponName = self.ClientItem and self.ClientItem.Name
                            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
                            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Charm then
                                return equipped[weaponName].Charm
                            end
                        end
                        return origHooks.GetCharm(self)
                    end
                end
                if ClientViewModel.GetWrap and not origHooks.GetWrap then
                    origHooks.GetWrap = ClientViewModel.GetWrap
                    ClientViewModel.GetWrap = function(self)
                        if enabledFlag then
                            local weaponName = self.ClientItem and self.ClientItem.Name
                            local weaponPlayer = self.ClientItem and self.ClientItem.ClientFighter and self.ClientItem.ClientFighter.Player
                            if weaponName and weaponPlayer == player and equipped[weaponName] and equipped[weaponName].Wrap then
                                return equipped[weaponName].Wrap
                            end
                        end
                        return origHooks.GetWrap(self)
                    end
                end
            end

            if ItemLibrary and ItemLibrary.GetViewModelImageFromWeaponData and not origHooks.GetVMImage then
                origHooks.GetVMImage = ItemLibrary.GetViewModelImageFromWeaponData
                ItemLibrary.GetViewModelImageFromWeaponData = function(self, weaponData, highRes)
                    if enabledFlag and weaponData then
                        local weaponName = weaponData.Name
                        local shouldShow = ((weaponData.Skin and equipped[weaponName] and weaponData.Skin == equipped[weaponName].Skin) or (viewingProfile == player and equipped[weaponName] and equipped[weaponName].Skin))
                        if shouldShow and equipped[weaponName] and equipped[weaponName].Skin then
                            local skinInfo = self.ViewModels[equipped[weaponName].Skin.Name]
                            if skinInfo then
                                return skinInfo[highRes and "ImageHighResolution" or "Image"] or skinInfo.Image
                            end
                        end
                    end
                    return origHooks.GetVMImage(self, weaponData, highRes)
                end
            end

            pcall(function()
                local EmoteController = require(controllers:WaitForChild("EmoteController", 10))
                if EmoteController and EmoteController.GetEmotes and not origHooks.GetEmotes then
                    origHooks.GetEmotes = EmoteController.GetEmotes
                    EmoteController.GetEmotes = function(self)
                        local emotes = origHooks.GetEmotes(self)
                        if enabledFlag then
                            for name, cosmetic in pairs(CosmeticLibrary.Cosmetics) do
                                if cosmetic and (cosmetic.Type == "Dance" or cosmetic.Type == "Emote") then
                                    if not emotes[name] then
                                        emotes[name] = {
                                            Name = name,
                                            Type = cosmetic.Type,
                                            ObjectID = cosmetic.ObjectID,
                                            Enum = cosmetic.Enum,
                                        }
                                    end
                                end
                            end
                        end
                        return emotes
                    end
                end
            end)

            pcall(function()
                local ViewProfile = require(player.PlayerScripts.Modules.Pages.ViewProfile)
                if ViewProfile and ViewProfile.Fetch and not origHooks.ViewFetch then
                    origHooks.ViewFetch = ViewProfile.Fetch
                    ViewProfile.Fetch = function(self, targetPlayer)
                        viewingProfile = targetPlayer
                        return origHooks.ViewFetch(self, targetPlayer)
                    end
                end
            end)

            print("[shako] Unlock All (skinchanger) instalado")
        end)
        if not ok then
            warn("[shako] Unlock All error:", err)
            installed = false
        end
    end

    function StopUnlockAll()
        enabledFlag = false
        config.UnlockAll = false
        -- No desinstalamos hooks (evita crashes); solo dejan de forzar owns
        print("[shako] Unlock All OFF")
    end
end





-- ==================== AUTO QUEUE RUNTIME (Rivals MatchmakingController) ====================
task.spawn(function()
    local Players = game:GetService("Players")
    local RS = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local lastInvoke = 0
    local lastPrint = 0
    local mmController, mmInterface = nil, nil

    local function resolveMatchmaking()
        if mmController and mmInterface then return true end
        pcall(function()
            local ps = LocalPlayer:WaitForChild("PlayerScripts", 5)
            local controllers = ps and ps:FindFirstChild("Controllers")
            local mod = controllers and controllers:FindFirstChild("MatchmakingController")
            if mod then
                mmController = require(mod)
            end
        end)
        -- Interface a veces vive en UI modules
        pcall(function()
            local ps = LocalPlayer:FindFirstChild("PlayerScripts")
            for _, d in ipairs((ps and ps:GetDescendants()) or {}) do
                if d.Name == "Matchmaking" and d:IsA("ModuleScript") then
                    local ok, m = pcall(require, d)
                    if ok and type(m) == "table" then
                        mmInterface = m
                        break
                    end
                end
            end
        end)
        return mmController ~= nil
    end

    local function currentQueueName()
        local name = nil
        pcall(function()
            if mmInterface then
                name = rawget(mmInterface, "_current_queue_name") or mmInterface._current_queue_name
            end
        end)
        return name
    end

    local function is_in_match()
        local lp = LocalPlayer
        if not lp then return false end
        -- IsInDuel / Status en player data
        local inDuel = false
        pcall(function()
            if lp:GetAttribute("IsInDuel") == true then inDuel = true end
            if lp:GetAttribute("InMatch") == true then inDuel = true end
        end)
        if inDuel then return true end
        -- Place distinto al lobby (si PlaceId cambia en match)
        -- No asumimos: solo atributos + fighter en combate activo
        local fighting = false
        pcall(function()
            local ps = lp:FindFirstChild("PlayerScripts")
            local c = ps and ps:FindFirstChild("Controllers")
            local fcMod = c and c:FindFirstChild("FighterController")
            if not fcMod then return end
            local fc = require(fcMod)
            local fighter = fc.LocalFighter
            if not fighter and type(fc.GetFighter) == "function" then
                fighter = fc:GetFighter(lp)
            end
            if fighter then
                -- en lobby a veces hay fighter en shooting range; exigir Health + no solo range
                local char = lp.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 and hum.Health < hum.MaxHealth then
                    fighting = true
                end
            end
        end)
        return fighting
    end

    local function joinQueue(mode)
        local now = tick()
        if now - lastInvoke < 1.5 then return end
        lastInvoke = now
        mode = tostring(mode or "1v1")

        resolveMatchmaking()

        -- 1) Preferido: MatchmakingController:QueueInto (Kicia/Rivals)
        local okCtrl = false
        if mmController and type(mmController.QueueInto) == "function" then
            local cur = currentQueueName()
            if cur and cur ~= mode and type(mmController.LeaveQueue) == "function" then
                pcall(function() mmController:LeaveQueue() end)
                task.wait(0.15)
            end
            if cur == mode then
                okCtrl = true -- ya en cola correcta
            else
                okCtrl = pcall(function() mmController:QueueInto(mode) end)
            end
        end

        -- 2) Fallback remote JoinQueue
        local okRemote = false
        pcall(function()
            local remotes = RS:FindFirstChild("Remotes")
            local mm = remotes and remotes:FindFirstChild("Matchmaking")
            if not mm then return end
            local jq = mm:FindFirstChild("JoinQueue")
            if not jq then
                -- buscar por nombre parcial
                for _, ch in ipairs(mm:GetChildren()) do
                    if string.find(string.lower(ch.Name), "join") and string.find(string.lower(ch.Name), "queue") then
                        jq = ch
                        break
                    end
                end
            end
            if not jq then return end
            if jq:IsA("RemoteFunction") then
                jq:InvokeServer(mode)
                okRemote = true
            elseif jq:IsA("RemoteEvent") then
                jq:FireServer(mode)
                okRemote = true
            end
        end)

        if now - lastPrint > 3 then
            lastPrint = now
            print(string.format("[shako] AutoQueue mode=%s ctrl=%s remote=%s curQueue=%s",
                mode, tostring(okCtrl), tostring(okRemote), tostring(currentQueueName())))
        end
    end

    print("[shako] Auto Queue runtime ready (QueueInto + JoinQueue)")
    while true do
        if config and config.AutoQueueEnabled then
            if not is_in_match() then
                joinQueue(config.AutoQueueMatch or "1v1")
            end
            task.wait(1.0)
        else
            task.wait(0.5)
        end
    end
end)


pcall(function() getgenv().shako_win_ok = true end)


-- presets desactivados


pcall(function()
    if Connections then
        pcall(function() if Connections.BulletTracerUpdate then Connections.BulletTracerUpdate:Disconnect() end end)
        Connections.BulletTracerUpdate = RunService.RenderStepped:Connect(function(dt)
            if config.BulletTracerEnabled then pcall(updateBulletTracers, dt) end
        end)
    end
end)
