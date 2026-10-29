local mirrors = {
    'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/',
    'https://cdn.jsdelivr.net/gh/violin-suzutsuki/LinoriaLib@main/',
    'https://fastly.jsdelivr.net/gh/violin-suzutsuki/LinoriaLib@main/',
}

local function loadLibFile(file)
    for _, mirror in ipairs(mirrors) do
        local success, result = pcall(function()
            local content = game:HttpGet(mirror .. file)
            if content and #content > 100 then
                local fn = loadstring(content)
                if fn then return fn() end
            end
        end)
        if success and result then return result end
    end
    error('Failed to load ' .. file .. ' from all mirrors')
end

local Library = loadLibFile('Library.lua')
local ThemeManager = loadLibFile('addons/ThemeManager.lua')
local SaveManager = loadLibFile('addons/SaveManager.lua')

local Players = game:GetService('Players')
local RunService = game:GetService('RunService')
local UserInputService = game:GetService('UserInputService')
local Debris = game:GetService('Debris')
local Teams = game:GetService('Teams')
local Workspace = game:GetService('Workspace')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local CollectionService = game:GetService('CollectionService')
local Lighting = game:GetService('Lighting')

local GunRemotes = ReplicatedStorage:WaitForChild('GunRemotes')
local ShootEvent = GunRemotes:WaitForChild('ShootEvent')
local FuncReload = GunRemotes:WaitForChild('FuncReload')

local LP = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local isAlive, getConfig, updateHudAmmo

local Window = Library:CreateWindow({
    Title = 'boars.hit BETA https://discord.gg/PZRvrEVdFF',
    Center = true,
    AutoShow = true,
})

local Tabs = {
    Combat = Window:AddTab('Combat'),
    Visuals = Window:AddTab('Visuals'),
    Movement = Window:AddTab('Movement'),
    Misc = Window:AddTab('Misc'),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}

do

local CombatBox = Tabs.Combat:AddLeftTabbox()
local SA_Tab = CombatBox:AddTab('Silent Aim')
local Rage_Tab = CombatBox:AddTab('Rage')
local GunMods_Tab = CombatBox:AddTab('Gun Mods')
local Vis_Tab = CombatBox:AddTab('FOV')

-- Silent Aim
Toggles.SilentAim = SA_Tab:AddToggle('SilentAim', { Text = 'Enabled', Default = false })

-- Fix & enhance KeyPicker <-> Toggle synchronization (supports Toggle, Hold, Always modes)
do
    local baseAddons = getmetatable(Toggles.SilentAim)
    local funcs = baseAddons and baseAddons.__index
    if funcs and funcs.AddKeyPicker then
        local origAddKeyPicker = funcs.AddKeyPicker
        funcs.AddKeyPicker = function(self, Idx, Info)
            Info = Info or {}
            local parentToggle = (self.Type == 'Toggle') and self or nil

            -- Prevent Linoria from wiping Hold/Always modes from context menu
            Info.SyncToggleState = false

            local res = origAddKeyPicker(self, Idx, Info)

            local kp = Options[Idx]
            if kp and parentToggle then
                local syncing = false

                local oldUpdate = kp.Update
                kp.Update = function(kpSelf)
                    if oldUpdate then oldUpdate(kpSelf) end
                    if syncing then return end
                    local state = kp:GetState()
                    if parentToggle.Value ~= state then
                        syncing = true
                        parentToggle:SetValue(state)
                        syncing = false
                    end
                end

                if not parentToggle._keyPickerHooked then
                    parentToggle._keyPickerHooked = true
                    local oldToggleSet = parentToggle.SetValue
                    parentToggle.SetValue = function(toggleSelf, val)
                        oldToggleSet(toggleSelf, val)
                        if syncing then return end
                        syncing = true
                        for _, addon in ipairs(toggleSelf.Addons or {}) do
                            if addon.Type == 'KeyPicker' and addon.Mode == 'Toggle' and addon.Toggled ~= val then
                                addon.Toggled = val
                                if addon.Update then addon:Update() end
                            end
                        end
                        syncing = false
                    end
                end
            end
            return res
        end
    end
end

Toggles.SilentAim:AddKeyPicker('SilentAimBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Silent Aim' })
Options.AimPart = SA_Tab:AddDropdown('AimPart', { Values = { 'Head', 'HumanoidRootPart', 'UpperTorso', 'LowerTorso' }, Default = 1, Multi = false, Text = 'Aim Part' })
Options.MaxDistance = SA_Tab:AddSlider('MaxDistance', { Text = 'Max Distance', Default = 1500, Min = 100, Max = 3000, Rounding = 1, Compact = false })
Options.FOVRadius = SA_Tab:AddSlider('FOVRadius', { Text = 'FOV Radius', Default = 200, Min = 10, Max = 1000, Rounding = 1, Compact = false })
SA_Tab:AddDivider()
Toggles.SilentAim360 = SA_Tab:AddToggle('SilentAim360', { Text = '360 Mode', Default = false })
Toggles.SilentAimVisibleCheck = SA_Tab:AddToggle('SilentAimVisibleCheck', { Text = 'Visible Check', Default = true })
Toggles.SilentAimTeamCheck = SA_Tab:AddToggle('SilentAimTeamCheck', { Text = 'Team Safety Check', Default = true })

-- Rage
Toggles.RageBot = Rage_Tab:AddToggle('RageBot', { Text = 'Enabled', Default = false })
Toggles.RageBot:AddKeyPicker('RageBotBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Rage Bot' })
Rage_Tab:AddDivider()
Toggles.RageBotAutoEquip = Rage_Tab:AddToggle('RageBotAutoEquip', { Text = 'Auto Equip Weapon', Default = true })
Toggles.RageBotAutoWeapon = Rage_Tab:AddToggle('RageBotAutoWeapon', { Text = 'Auto Pickup Weapon', Default = false })
Toggles.RageBotTargetInmatesAsCrim = Rage_Tab:AddToggle('RageBotTargetInmatesAsCrim', { Text = 'Target Inmates (as Criminal)', Default = false })
Rage_Tab:AddDivider()
Toggles.RageBotShootThroughCars = Rage_Tab:AddToggle('RageBotShootThroughCars', { Text = 'Shoot Through Cars', Default = true })
Options.RageBotCarPenetration = Rage_Tab:AddDropdown('RageBotCarPenetration', { Text = 'Car Penetration Mode', Values = { 'Windows & Non-Solid', 'All Car Parts' }, Default = 1 })
Toggles.RageBotDisableInVehicle = Rage_Tab:AddToggle('RageBotDisableInVehicle', { Text = 'Disable In Vehicle', Default = true })
Rage_Tab:AddDivider()
Toggles.AutoDetectCheaters = Rage_Tab:AddToggle('AutoDetectCheaters', { Text = 'Auto Detect Cheaters', Default = false, Tooltip = 'Scans players for speedhack, fly, teleportation, and void survival' })
Toggles.RageBotPrioritizeCheaters = Rage_Tab:AddToggle('RageBotPrioritizeCheaters', { Text = 'Prioritize Cheaters', Default = false, Tooltip = 'Automatically targets and locks onto detected cheaters first' })
Toggles.CheaterNotify = Rage_Tab:AddToggle('CheaterNotify', { Text = 'Cheater Notification', Default = false, Tooltip = 'Shows on-screen notification alert when a cheater is detected' })
Rage_Tab:AddDivider()
Toggles.Resolver = Rage_Tab:AddToggle('Resolver', { Text = 'HvH Resolver', Default = false, Tooltip = 'Advanced HvH Resolver: counters Anti-Aim (Spin/Jitter), CFrame desync, and fake hitboxes' })
Options.ResolverMode = Rage_Tab:AddDropdown('ResolverMode', { Text = 'Resolver Mode', Values = { 'Adaptive Auto', 'Axis Pivot (Anti-Spin)', 'Velocity Prediction', 'Bruteforce' }, Default = 1 })
Toggles.ResolverLog = Rage_Tab:AddToggle('ResolverLog', { Text = 'Resolver Notification', Default = false, Tooltip = 'Notifies on-screen when enemy Anti-Aim is detected and resolved' })

-- Gun Mods / Rapid Fire
GunMods_Tab:AddDivider()
Toggles.FireRateChanger = GunMods_Tab:AddToggle('FireRateChanger', { Text = 'FireRate Changer', Default = false })
Toggles.FireRateChanger:AddKeyPicker('FireRateBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'FireRate Changer' })
Options.FireRateMode = GunMods_Tab:AddDropdown('FireRateMode', { Text = 'Mode', Values = { 'Multiplier', 'Custom Delay', 'Instant (0s)' }, Default = 1 })
Options.FireRateMultiplier = GunMods_Tab:AddSlider('FireRateMultiplier', { Text = 'Speed Multiplier', Default = 3, Min = 1.5, Max = 25, Rounding = 1, Compact = false })
Options.CustomFireRate = GunMods_Tab:AddSlider('CustomFireRate', { Text = 'Custom Delay (s)', Default = 0.02, Min = 0.001, Max = 0.5, Rounding = 3, Compact = false })
GunMods_Tab:AddDivider()
Toggles.AlwaysAutomatic = GunMods_Tab:AddToggle('AlwaysAutomatic', { Text = 'Always Automatic (Full-Auto)', Default = false })
Toggles.FireRateApplyManual = GunMods_Tab:AddToggle('FireRateApplyManual', { Text = 'Apply To Manual Shoot', Default = true })
Toggles.FireRateApplyRage = GunMods_Tab:AddToggle('FireRateApplyRage', { Text = 'Apply To RageBot', Default = true })


GunMods_Tab:AddDivider()
Toggles.VoidReload = GunMods_Tab:AddToggle('VoidReload', {
    Text = 'Void Reload (Safe Underground)',
    Default = false,
    Tooltip = 'Teleports deep into the void (-250 Y) during reload so enemies cannot hit you, returning once reloaded'
})

Options.VoidReloadDepth = GunMods_Tab:AddSlider('VoidReloadDepth', {
    Text = 'Void Reload Depth (Y)',
    Default = -250,
    Min = -450,
    Max = -100,
    Rounding = 0,
    Compact = false
})

GunMods_Tab:AddDivider()
Toggles.DoubleTap = GunMods_Tab:AddToggle('DoubleTap', { Text = 'Double Tap', Default = false, Tooltip = 'Instantly fires a second shot burst for double damage' })
Toggles.DoubleTap:AddKeyPicker('DoubleTapBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Double Tap' })

local DoubleTapDep = GunMods_Tab:AddDependencyBox()
DoubleTapDep:SetupDependencies({ { Toggles.DoubleTap, true } })

Options.DoubleTapWeapon = DoubleTapDep:AddDropdown('DoubleTapWeapon', {
    Text = 'Weapon',
    Values = { 'Remington 870 Only', 'All Guns' },
    Default = 1,
    Multi = false
})

Options.DoubleTapDelay = DoubleTapDep:AddSlider('DoubleTapDelay', {
    Text = 'Burst Delay (s)',
    Default = 0.02,
    Min = 0.00,
    Max = 0.15,
    Rounding = 2,
    Compact = false
})

Toggles.DoubleTapManual = DoubleTapDep:AddToggle('DoubleTapManual', {
    Text = 'Apply To Manual Shooting',
    Default = true
})
Toggles.DoubleTapRage = Toggles.DoubleTap

GunMods_Tab:AddDivider()
Toggles.ShieldBypass = GunMods_Tab:AddToggle('ShieldBypass', { Text = 'Bypass Riot Shield', Default = false, Tooltip = 'Ignores Riot Shield collision and penetrates directly to target' })
Toggles.ShieldBypassRiot = Toggles.ShieldBypass

-- Combat Visual
Toggles.FOVCircle = Vis_Tab:AddToggle('FOVCircle', { Text = 'Show FOV Circle', Default = false })
Options.FOVRotSpeed = Vis_Tab:AddSlider('FOVRotSpeed', { Text = 'Rotation Speed', Default = 0, Min = -5, Max = 5, Rounding = 1, Compact = false })
Options.FOVThickness = Vis_Tab:AddSlider('FOVThickness', { Text = 'Outline Thickness', Default = 1.5, Min = 0.5, Max = 8, Rounding = 1, Compact = false })
Vis_Tab:AddLabel('Outline')
do
    local L = Vis_Tab:AddLabel('Colors')
    L:AddColorPicker('FOVColor1', { Default = Color3.fromRGB(255, 255, 255), Title = 'Outline Color 1' })
    L:AddColorPicker('FOVColor2', { Default = Color3.fromRGB(0, 170, 255), Title = 'Outline Color 2' })
    L:AddColorPicker('FOVColor3', { Default = Color3.fromRGB(255, 0, 0), Title = 'Outline Color 3' })
end
Vis_Tab:AddDivider()
Vis_Tab:AddLabel('Fill')
Toggles.FOVFill = Vis_Tab:AddToggle('FOVFill', { Text = 'Enable Fill', Default = false })
Options.FOVFillDensity = Vis_Tab:AddSlider('FOVFillDensity', { Text = 'Fill Density', Default = 0.85, Min = 0, Max = 1, Rounding = 2, Compact = false })
do
    local L = Vis_Tab:AddLabel('Fill Colors')
    L:AddColorPicker('FOVFillColor1', { Default = Color3.fromRGB(255, 255, 255), Title = 'Fill Color 1' })
    L:AddColorPicker('FOVFillColor2', { Default = Color3.fromRGB(0, 170, 255), Title = 'Fill Color 2' })
    L:AddColorPicker('FOVFillColor3', { Default = Color3.fromRGB(255, 0, 0), Title = 'Fill Color 3' })
end

-- Crosshair (right side, next to combat tabs)
local CrosshairBox = Tabs.Combat:AddRightTabbox()
local CH_Tab = CrosshairBox:AddTab('Crosshair')
CH_Tab:AddDivider()
Toggles.CustomCrosshair = CH_Tab:AddToggle('CustomCrosshair', { Text = 'Custom Crosshair', Default = false })
Options.CrosshairLength = CH_Tab:AddSlider('CrosshairLength', { Text = 'Length', Default = 10, Min = 2, Max = 40, Rounding = 0, Compact = false })
Options.CrosshairGap = CH_Tab:AddSlider('CrosshairGap', { Text = 'Gap', Default = 4, Min = 0, Max = 30, Rounding = 0, Compact = false })
Options.CrosshairThickness = CH_Tab:AddSlider('CrosshairThickness', { Text = 'Thickness', Default = 2, Min = 1, Max = 8, Rounding = 0, Compact = false })
Options.CrosshairRotation = CH_Tab:AddSlider('CrosshairRotation', { Text = 'Rotation', Default = 0, Min = -180, Max = 180, Rounding = 1, Compact = false })
do
    local L = CH_Tab:AddLabel('Colors')
    L:AddColorPicker('CH1Color', { Default = Color3.fromRGB(255, 255, 255), Title = 'Line 1' })
    L:AddColorPicker('CH2Color', { Default = Color3.fromRGB(255, 255, 255), Title = 'Line 2' })
    L:AddColorPicker('CH3Color', { Default = Color3.fromRGB(255, 255, 255), Title = 'Line 3' })
    L:AddColorPicker('CH4Color', { Default = Color3.fromRGB(255, 255, 255), Title = 'Line 4' })
end

-- Hitmarkers Tab
local HM_Tab = CrosshairBox:AddTab('Hitmarkers')
HM_Tab:AddDivider()
Toggles.Hitmarkers = HM_Tab:AddToggle('Hitmarkers', { Text = 'Enabled', Default = false })
Options.HitmarkerMode = HM_Tab:AddDropdown('HitmarkerMode', { Text = 'Mode', Default = 1, Values = { 'Weapon Crosshair', 'Screen Center', '3D Hit Position' } })
Options.HitmarkerAnimation = HM_Tab:AddDropdown('HitmarkerAnimation', { Text = 'Animation', Default = 2, Values = { 'Static Fade', 'Expand & Fade', 'Bounce' } })
Options.HitmarkerSize = HM_Tab:AddSlider('HitmarkerSize', { Text = 'Line Length', Default = 8, Min = 3, Max = 25, Rounding = 0, Compact = false })
Options.HitmarkerGap = HM_Tab:AddSlider('HitmarkerGap', { Text = 'Center Gap', Default = 5, Min = 1, Max = 20, Rounding = 0, Compact = false })
Options.HitmarkerThickness = HM_Tab:AddSlider('HitmarkerThickness', { Text = 'Thickness', Default = 1.5, Min = 1, Max = 5, Rounding = 1, Compact = false })
Options.HitmarkerDuration = HM_Tab:AddSlider('HitmarkerDuration', { Text = 'Duration (s)', Default = 0.35, Min = 0.1, Max = 1.0, Rounding = 2, Compact = false })
HM_Tab:AddDivider()
Toggles.HitmarkerCritColor = HM_Tab:AddToggle('HitmarkerCritColor', { Text = 'Headshot/Crit Color', Default = true })
do
    local L = HM_Tab:AddLabel('Colors')
    L:AddColorPicker('HitmarkerColor', { Default = Color3.fromRGB(255, 255, 255), Title = 'Hit Color' })
    L:AddColorPicker('HitmarkerCritCol', { Default = Color3.fromRGB(255, 45, 45), Title = 'Crit Color' })
    L:AddColorPicker('HitmarkerTaserCol', { Default = Color3.fromRGB(0, 230, 255), Title = 'Taser Color' })
end
Toggles.HitmarkerRainbow = HM_Tab:AddToggle('HitmarkerRainbow', { Text = 'Rainbow', Default = false })

-- Hit Numbers Tab
local HN_Tab = CrosshairBox:AddTab('Hit Numbers')
HN_Tab:AddDivider()
Toggles.HitNumbers = HN_Tab:AddToggle('HitNumbers', { Text = 'Enabled', Default = false })
Options.HitNumberAnimation = HN_Tab:AddDropdown('HitNumberAnimation', { Text = 'Animation', Default = 1, Values = { 'Pop & Bounce', 'Float Up', 'Scatter (3D)', 'Rise & Fade' } })
Options.HitNumberSize = HN_Tab:AddSlider('HitNumberSize', { Text = 'Base Size', Default = 18, Min = 12, Max = 32, Rounding = 0, Compact = false })
Options.HitNumberDuration = HN_Tab:AddSlider('HitNumberDuration', { Text = 'Duration (s)', Default = 1.0, Min = 0.4, Max = 2.5, Rounding = 1, Compact = false })
Options.HitNumberFont = HN_Tab:AddDropdown('HitNumberFont', { Text = 'Font', Default = 2, Values = { 'UI', 'System', 'Plex', 'Monospace' } })
HN_Tab:AddDivider()
Toggles.HitNumberCritColor = HN_Tab:AddToggle('HitNumberCritColor', { Text = 'Headshot/Crit Color', Default = true })
do
    local L = HN_Tab:AddLabel('Colors')
    L:AddColorPicker('HitNumberColor', { Default = Color3.fromRGB(255, 235, 100), Title = 'Hit Color' })
    L:AddColorPicker('HitNumberCritCol', { Default = Color3.fromRGB(255, 50, 50), Title = 'Crit Color' })
    L:AddColorPicker('HitNumberTaserCol', { Default = Color3.fromRGB(0, 230, 255), Title = 'Taser Color' })
end
Toggles.HitNumberRainbow = HN_Tab:AddToggle('HitNumberRainbow', { Text = 'Rainbow', Default = false })

-- Arrest Aura (right side)
local ArrestBox = Tabs.Combat:AddRightTabbox()
local AR_Tab = ArrestBox:AddTab('Arrest Aura')
Toggles.ArrestAura = AR_Tab:AddToggle('ArrestAura', { Text = 'Arrest Aura', Default = false })
Toggles.ArrestAura:AddKeyPicker('ArrestAuraBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Arrest Aura' })
AR_Tab:AddDivider()
Toggles.ArrestAuraRange = AR_Tab:AddToggle('ArrestAuraRange', { Text = 'Show Range', Default = false })
Options.ArrestAuraThickness = AR_Tab:AddSlider('ArrestAuraThickness', { Text = 'Range Thickness', Default = 1.5, Min = 0.5, Max = 8, Rounding = 1, Compact = false })
do
    local L = AR_Tab:AddLabel('Range Color')
    L:AddColorPicker('ArrestAuraColor1', { Default = Color3.fromRGB(255, 0, 0), Title = 'Range Color 1' })
    L:AddColorPicker('ArrestAuraColor2', { Default = Color3.fromRGB(255, 100, 0), Title = 'Range Color 2' })
    L:AddColorPicker('ArrestAuraColor3', { Default = Color3.fromRGB(255, 200, 0), Title = 'Range Color 3' })
end
AR_Tab:AddDivider()
Toggles.ArrestAuraFill = AR_Tab:AddToggle('ArrestAuraFill', { Text = 'Range Fill', Default = false })
Options.ArrestAuraFillDensity = AR_Tab:AddSlider('ArrestAuraFillDensity', { Text = 'Fill Density', Default = 0.85, Min = 0, Max = 1, Rounding = 2, Compact = false })
do
    local L = AR_Tab:AddLabel('Fill Color')
    L:AddColorPicker('ArrestAuraFillColor1', { Default = Color3.fromRGB(255, 0, 0), Title = 'Fill Color 1' })
    L:AddColorPicker('ArrestAuraFillColor2', { Default = Color3.fromRGB(255, 100, 0), Title = 'Fill Color 2' })
    L:AddColorPicker('ArrestAuraFillColor3', { Default = Color3.fromRGB(255, 200, 0), Title = 'Fill Color 3' })
end

-- Void Aura Tab (HvH Edition)
local Void_Tab = ArrestBox:AddTab('Void Aura')

Toggles.VoidAura = Void_Tab:AddToggle('VoidAura', { Text = 'Void Aura', Default = false })
Toggles.VoidAura:AddKeyPicker('VoidAuraBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Void Aura' })

local VoidDep = Void_Tab:AddDependencyBox()
VoidDep:SetupDependencies({ { Toggles.VoidAura, true } })

Options.VoidPositionType = VoidDep:AddDropdown('VoidPositionType', {
    Values = {
        '3D Cyclone Orbit (HvH)',
        '3D Helix / Corkscrew (HvH)',
        'Spherical Chaos / Evasive',
        'Behind Target (Backstab Flank)',
        'Above Target (Sky Stomp)',
        'Jitter Random Flank',
        'Underground (Void Floor)',
        'Stay At Enable Position'
    },
    Default = 1,
    Multi = false,
    Text = 'Void Position'
})

Options.VoidStrikeMethod = VoidDep:AddDropdown('VoidStrikeMethod', {
    Values = { 'Instant Teleport (0ms HvH Snap)', 'Smooth Ultra-Glide', 'Blink Flank (In & Out)' },
    Default = 1,
    Multi = false,
    Text = 'Strike Method'
})

Options.VoidTargetMode = VoidDep:AddDropdown('VoidTargetMode', {
    Values = { 'Nearest Enemy', 'Lowest HP (Executer)', 'All Enemies (Carnage Cycle)', 'RageBot / Current', 'Selected Player' },
    Default = 1,
    Multi = false,
    Text = 'Target Mode'
})

Options.VoidSelectedPlayer = VoidDep:AddDropdown('VoidSelectedPlayer', {
    Values = { 'None' },
    Default = 1,
    Multi = false,
    Text = 'Target Player'
})

Options.VoidAttackType = VoidDep:AddDropdown('VoidAttackType', {
    Values = { 'Gun & Melee', 'Melee Only (Punch)', 'Gun Only' },
    Default = 1,
    Multi = false,
    Text = 'Attack Mode'
})

VoidDep:AddDivider()

Options.VoidDistance = VoidDep:AddSlider('VoidDistance', {
    Text = 'Offset Distance',
    Default = 4,
    Min = 1,
    Max = 25,
    Rounding = 0,
    Compact = false
})

Options.VoidHeight = VoidDep:AddSlider('VoidHeight', {
    Text = 'Height / Vertical Offset',
    Default = 2,
    Min = -15,
    Max = 50,
    Rounding = 0,
    Compact = false
})

Options.VoidOrbitSpeed = VoidDep:AddSlider('VoidOrbitSpeed', {
    Text = 'Orbit Speed',
    Default = 16,
    Min = 4,
    Max = 60,
    Rounding = 0,
    Compact = false
})

Options.VoidAttackDelay = VoidDep:AddSlider('VoidAttackDelay', {
    Text = 'Attack Delay (s)',
    Default = 0.03,
    Min = 0.01,
    Max = 0.50,
    Rounding = 2,
    Compact = false
})

Options.VoidCycleDelay = VoidDep:AddSlider('VoidCycleDelay', {
    Text = 'Carnage Switch Speed (s)',
    Default = 0.12,
    Min = 0.02,
    Max = 0.80,
    Rounding = 2,
    Compact = false
})

VoidDep:AddDivider()

Toggles.VoidLoSSolver = VoidDep:AddToggle('VoidLoSSolver', {
    Text = 'Wall LoS Breach (RageBot Hit)',
    Default = true,
    Tooltip = 'Automatically navigates through walls and adjusts distance when enemy is behind cover so RageBot raycast always hits'
})

Toggles.VoidAuraReloadInVoid = VoidDep:AddToggle('VoidAuraReloadInVoid', {
    Text = 'Teleport To Void On Reload',
    Default = true,
    Tooltip = 'Teleports deep into the void while reloading during Void Aura'
})

Toggles.VoidAutoEquip = VoidDep:AddToggle('VoidAutoEquip', {
    Text = 'Auto Equip Best Weapon',
    Default = true
})

Toggles.VoidNoclip = VoidDep:AddToggle('VoidNoclip', {
    Text = 'Full Character Noclip',
    Default = true
})

Toggles.VoidAntiTargetLock = VoidDep:AddToggle('VoidAntiTargetLock', {
    Text = 'Anti-Aim Prediction Desync',
    Default = true,
    Tooltip = 'Rapidly micro-jitters position to break enemy aimbot prediction'
})

-- ====================== VISUALS ======================

-- Left Column 1: Player & Target ESP
local PlayersBox = Tabs.Visuals:AddLeftTabbox()
local ESP_Tab = PlayersBox:AddTab('ESP')
local TargetESP_Tab = PlayersBox:AddTab('Target ESP')

-- Left Column 2: Self & Character Models
local ModelBox = Tabs.Visuals:AddLeftTabbox()
local Chinahat_Tab = ModelBox:AddTab('China Hat')
local Viewmodel_Tab = ModelBox:AddTab('Viewmodel')

-- Right Column 1: World & Visual Effects
local EffectsBox = Tabs.Visuals:AddRightTabbox()
local World_Tab = EffectsBox:AddTab('World')
local Bullet_Tab = EffectsBox:AddTab('Tracers')
local Particles_Tab = EffectsBox:AddTab('Particles')

-- Right Column 2: Interface & HUD
local HUDBox = Tabs.Visuals:AddRightTabbox()
local TargetHUD_Tab = HUDBox:AddTab('Target HUD')
local Killfeed_Tab = HUDBox:AddTab('Killfeed')

-- --- ESP ---
-- ESP
Toggles.ESP = ESP_Tab:AddToggle('ESP', { Text = 'Enabled', Default = false })
ESP_Tab:AddDivider()

ESP_Tab:AddLabel('Inmates')
Toggles.ESPInmates = ESP_Tab:AddToggle('ESPInmates', { Text = 'Enabled', Default = false })
Toggles.ESPInmates:AddColorPicker('ESPInmatesColor', { Default = Color3.fromRGB(0, 170, 255), Title = 'Inmates Color' })
Toggles.ESPInmatesRainbow = ESP_Tab:AddToggle('ESPInmatesRainbow', { Text = 'Rainbow', Default = false })

ESP_Tab:AddLabel('Guards')
Toggles.ESPGuards = ESP_Tab:AddToggle('ESPGuards', { Text = 'Enabled', Default = false })
Toggles.ESPGuards:AddColorPicker('ESPGuardsColor', { Default = Color3.fromRGB(255, 50, 50), Title = 'Guards Color' })
Toggles.ESPGuardsRainbow = ESP_Tab:AddToggle('ESPGuardsRainbow', { Text = 'Rainbow', Default = false })

ESP_Tab:AddLabel('Hostile')
Toggles.ESPHostile = ESP_Tab:AddToggle('ESPHostile', { Text = 'Enabled', Default = false })
Toggles.ESPHostile:AddColorPicker('ESPHostileColor', { Default = Color3.fromRGB(255, 0, 0), Title = 'Hostile Color' })
Toggles.ESPHostileRainbow = ESP_Tab:AddToggle('ESPHostileRainbow', { Text = 'Rainbow', Default = false })

ESP_Tab:AddLabel('Criminals')
Toggles.ESPCriminals = ESP_Tab:AddToggle('ESPCriminals', { Text = 'Enabled', Default = false })
Toggles.ESPCriminals:AddColorPicker('ESPCriminalsColor', { Default = Color3.fromRGB(255, 170, 0), Title = 'Criminals Color' })
Toggles.ESPCriminalsRainbow = ESP_Tab:AddToggle('ESPCriminalsRainbow', { Text = 'Rainbow', Default = false })

ESP_Tab:AddDivider()
ESP_Tab:AddLabel('ESP Types')
Toggles.ESPHighlight = ESP_Tab:AddToggle('ESPHighlight', { Text = 'Highlight', Default = false })
Toggles.ESPBox = ESP_Tab:AddToggle('ESPBox', { Text = 'Box', Default = false })
Toggles.ESPName = ESP_Tab:AddToggle('ESPName', { Text = 'Name', Default = false })
Toggles.ESPSkeleton = ESP_Tab:AddToggle('ESPSkeleton', { Text = 'Skeleton', Default = false })
Toggles.ESPHealthBar = ESP_Tab:AddToggle('ESPHealthBar', { Text = 'Health Bar', Default = false })
Toggles.ESPHPCounter = ESP_Tab:AddToggle('ESPHPCounter', { Text = 'HP Counter', Default = false })
Toggles.ESPWeapon = ESP_Tab:AddToggle('ESPWeapon', { Text = 'Weapon', Default = false })
Toggles.ESPShield = ESP_Tab:AddToggle('ESPShield', { Text = 'Shield', Default = false })
Toggles.ESPShield:AddColorPicker('ESPShieldColor', { Default = Color3.fromRGB(0, 180, 255), Title = 'Shield Color' })
Toggles.ESPShieldRainbow = ESP_Tab:AddToggle('ESPShieldRainbow', { Text = 'Shield Rainbow', Default = false })

Toggles.WeaponChams = ESP_Tab:AddToggle('WeaponChams', { Text = 'Weapon Chams', Default = false })
Options.WeaponChamsMaterial = ESP_Tab:AddDropdown('WeaponChamsMaterial', { Text = 'Material', Default = 1, Values = { 'Neon', 'ForceField', 'Glass', 'Ice', 'Metal', 'Cobblestone', 'Brick', 'DiamondPlate' } })
ESP_Tab:AddLabel('Color'):AddColorPicker('WeaponChamsColor', { Default = Color3.fromRGB(0, 170, 255), Title = 'Chams Color' })

-- --- Target ESP ---
Toggles.TargetESP = TargetESP_Tab:AddToggle('TargetESP', { Text = 'Enabled', Default = false })
Toggles.TargetESP:AddColorPicker('TargetESPColor', { Default = Color3.fromRGB(255, 255, 255), Title = 'Target ESP Color' })
Toggles.TargetESPRainbow = TargetESP_Tab:AddToggle('TargetESPRainbow', { Text = 'Rainbow', Default = false })

local TargetESPDep = TargetESP_Tab:AddDependencyBox()
TargetESPDep:SetupDependencies({ { Toggles.TargetESP, true } })

Options.TargetESPMode = TargetESPDep:AddDropdown('TargetESPMode', {
    Values = { 'Client', 'Wexside', 'Призраки' },
    Default = 1,
    Multi = false,
    Text = 'Mode'
})

Options.TargetESPSpeed = TargetESPDep:AddSlider('TargetESPSpeed', { Text = 'Speed', Default = 3.0, Min = 0.7, Max = 9.0, Rounding = 1, Compact = false })
Options.TargetESPSize = TargetESPDep:AddSlider('TargetESPSize', { Text = 'Size', Default = 70, Min = 10, Max = 140, Rounding = 0, Compact = false })
Options.TargetESPBrightness = TargetESPDep:AddSlider('TargetESPBrightness', { Text = 'Brightness', Default = 255, Min = 1, Max = 255, Rounding = 0, Compact = false })

TargetESPDep:AddDivider()
Toggles.TargetESPVisibleCheck = TargetESPDep:AddToggle('TargetESPVisibleCheck', { Text = 'Visible Check', Default = false })

-- --- China Hat ---
-- China Hat
Toggles.ChinaHat = Chinahat_Tab:AddToggle('ChinaHat', { Text = 'Enable China Hat', Default = false, Tooltip = 'Renders a conical China Hat above player heads' })
Toggles.ChinaHat:AddKeyPicker('ChinaHatBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'China Hat' })

local CHDep = Chinahat_Tab:AddDependencyBox()
CHDep:SetupDependencies({ { Toggles.ChinaHat, true } })

CHDep:AddDivider()
CHDep:AddLabel('General & Animation')
Toggles.ChinaHatSpin = CHDep:AddToggle('ChinaHatSpin', { Text = 'Spin Animation', Default = true })
Options.ChinaHatSpinSpeed = CHDep:AddSlider('ChinaHatSpinSpeed', { Text = 'Spin Speed', Default = 2, Min = 0.5, Max = 10, Rounding = 1, Compact = false })
Toggles.ChinaHatFollowHead = CHDep:AddToggle('ChinaHatFollowHead', { Text = 'Follow Head Tilt', Default = true })
Toggles.ChinaHatOutline = CHDep:AddToggle('ChinaHatOutline', { Text = 'Rim Outline', Default = true })
Toggles.ChinaHatOutline:AddColorPicker('ChinaHatOutlineColor', { Default = Color3.fromRGB(255, 255, 255), Title = 'Outline Color' })
Options.ChinaHatOutlineThick = CHDep:AddSlider('ChinaHatOutlineThick', { Text = 'Outline Thickness', Default = 1.5, Min = 1, Max = 4, Rounding = 1, Compact = false })

CHDep:AddDivider()
CHDep:AddLabel('Local Player (Self)')
Toggles.ChinaHatSelf = CHDep:AddToggle('ChinaHatSelf', { Text = 'Render on Self', Default = true, Tooltip = 'Displays hat over your head in third person' })
Toggles.ChinaHatSelf:AddColorPicker('ChinaHatColorSelf', { Default = Color3.fromRGB(100, 150, 200), Title = 'Self Hat Color' })
Toggles.ChinaHatRainbowSelf = CHDep:AddToggle('ChinaHatRainbowSelf', { Text = 'Rainbow Color (Self)', Default = false })
Options.ChinaHatAlphaSelf = CHDep:AddSlider('ChinaHatAlphaSelf', { Text = 'Opacity (Self)', Default = 0.65, Min = 0.1, Max = 1.0, Rounding = 2, Compact = false })
Options.ChinaHatRadiusSelf = CHDep:AddSlider('ChinaHatRadiusSelf', { Text = 'Radius / Width (Self)', Default = 2.0, Min = 0.5, Max = 4.5, Rounding = 1, Compact = false })
Options.ChinaHatHeightSelf = CHDep:AddSlider('ChinaHatHeightSelf', { Text = 'Height (Self)', Default = 0.8, Min = 0.2, Max = 3.0, Rounding = 1, Compact = false })
Options.ChinaHatOffsetSelf = CHDep:AddSlider('ChinaHatOffsetSelf', { Text = 'Height Offset (Self)', Default = 0.15, Min = -0.5, Max = 1.5, Rounding = 2, Compact = false })

CHDep:AddDivider()
CHDep:AddLabel('Other Players')
Toggles.ChinaHatOthers = CHDep:AddToggle('ChinaHatOthers', { Text = 'Render on Others', Default = true, Tooltip = 'Displays hat over other players' })
Toggles.ChinaHatOthers:AddColorPicker('ChinaHatColorOthers', { Default = Color3.fromRGB(200, 100, 150), Title = 'Others Hat Color' })
Toggles.ChinaHatTeamColor = CHDep:AddToggle('ChinaHatTeamColor', { Text = 'Use Team Color (Others)', Default = true })
Toggles.ChinaHatRainbowOthers = CHDep:AddToggle('ChinaHatRainbowOthers', { Text = 'Rainbow Color (Others)', Default = false })
Options.ChinaHatAlphaOthers = CHDep:AddSlider('ChinaHatAlphaOthers', { Text = 'Opacity (Others)', Default = 0.65, Min = 0.1, Max = 1.0, Rounding = 2, Compact = false })
Options.ChinaHatRadiusOthers = CHDep:AddSlider('ChinaHatRadiusOthers', { Text = 'Radius / Width (Others)', Default = 2.0, Min = 0.5, Max = 4.5, Rounding = 1, Compact = false })
Options.ChinaHatHeightOthers = CHDep:AddSlider('ChinaHatHeightOthers', { Text = 'Height (Others)', Default = 0.8, Min = 0.2, Max = 3.0, Rounding = 1, Compact = false })
Options.ChinaHatMaxDist = CHDep:AddSlider('ChinaHatMaxDist', { Text = 'Max Distance (Others)', Default = 250, Min = 50, Max = 800, Rounding = 0, Compact = false })

-- --- Viewmodel ---
Toggles.CustomViewmodel = Viewmodel_Tab:AddToggle('CustomViewmodel', { Text = 'Custom Viewmodel', Default = false })
local VMDep = Viewmodel_Tab:AddDependencyBox()
VMDep:SetupDependencies({ { Toggles.CustomViewmodel, true } })

Options.ViewmodelOffsetX = VMDep:AddSlider('ViewmodelOffsetX', { Text = 'Offset X (Left / Right)', Default = 0, Min = -50, Max = 50, Rounding = 1, Compact = false })
Options.ViewmodelOffsetY = VMDep:AddSlider('ViewmodelOffsetY', { Text = 'Offset Y (Down / Up)', Default = 0, Min = -50, Max = 50, Rounding = 1, Compact = false })
Options.ViewmodelOffsetZ = VMDep:AddSlider('ViewmodelOffsetZ', { Text = 'Offset Z (Back / Forward)', Default = 0, Min = -50, Max = 50, Rounding = 1, Compact = false })
VMDep:AddDivider()

Options.ViewmodelRotX = VMDep:AddSlider('ViewmodelRotX', { Text = 'Pitch (X)', Default = 0, Min = -180, Max = 180, Rounding = 0, Compact = false })
Options.ViewmodelRotY = VMDep:AddSlider('ViewmodelRotY', { Text = 'Yaw (Y)', Default = 0, Min = -180, Max = 180, Rounding = 0, Compact = false })
Options.ViewmodelRotZ = VMDep:AddSlider('ViewmodelRotZ', { Text = 'Roll (Z)', Default = 0, Min = -180, Max = 180, Rounding = 0, Compact = false })
VMDep:AddDivider()

Toggles.ViewmodelSpin = VMDep:AddToggle('ViewmodelSpin', { Text = 'Weapon Spin', Default = false })
Options.ViewmodelSpinSpeed = VMDep:AddSlider('ViewmodelSpinSpeed', { Text = 'Spin Speed', Default = 10, Min = 1, Max = 50, Rounding = 0, Compact = false })
Options.ViewmodelSpinAxis = VMDep:AddDropdown('ViewmodelSpinAxis', { Values = { 'Y (Yaw)', 'X (Pitch)', 'Z (Roll)', 'All Axes' }, Default = 1, Multi = false, Text = 'Spin Axis' })
VMDep:AddDivider()

Toggles.ViewmodelShowArms = VMDep:AddToggle('ViewmodelShowArms', { Text = 'Show Arms in First Person', Default = true })
Toggles.ViewmodelFirstPersonOnly = VMDep:AddToggle('ViewmodelFirstPersonOnly', { Text = 'First Person Only', Default = true })
VMDep:AddDivider()

VMDep:AddButton({
    Text = 'Reset Viewmodel',
    Func = function()
        if Options.ViewmodelOffsetX then Options.ViewmodelOffsetX:SetValue(0) end
        if Options.ViewmodelOffsetY then Options.ViewmodelOffsetY:SetValue(0) end
        if Options.ViewmodelOffsetZ then Options.ViewmodelOffsetZ:SetValue(0) end
        if Options.ViewmodelRotX then Options.ViewmodelRotX:SetValue(0) end
        if Options.ViewmodelRotY then Options.ViewmodelRotY:SetValue(0) end
        if Options.ViewmodelRotZ then Options.ViewmodelRotZ:SetValue(0) end
    end
})

-- --- World ---
-- World
Toggles.Ambience = World_Tab:AddToggle('Ambience', { Text = 'Custom Ambience', Default = false })
Toggles.Ambience:AddColorPicker('AmbienceColor', { Default = Color3.fromRGB(150, 150, 200), Title = 'Ambience Color' })
Options.AmbienceBrightness = World_Tab:AddSlider('AmbienceBrightness', { Text = 'Brightness', Default = 2, Min = 0, Max = 5, Rounding = 1, Compact = false })
Toggles.AmbienceRainbow = World_Tab:AddToggle('AmbienceRainbow', { Text = 'Rainbow', Default = false })
World_Tab:AddDivider()
Toggles.CustomTime = World_Tab:AddToggle('CustomTime', { Text = 'Custom Time', Default = false })
Options.CustomTimeValue = World_Tab:AddSlider('CustomTimeValue', { Text = 'Time', Default = 12, Min = 0, Max = 24, Rounding = 1, Compact = false })
World_Tab:AddDivider()
World_Tab:AddLabel('Stretch Resolution')
Toggles.StretchResolution = World_Tab:AddToggle('StretchResolution', { Text = 'Stretch Resolution', Default = false })
Toggles.StretchResolution:AddKeyPicker('StretchResolutionBind', { Default = 'None', SyncToggleState = true, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Stretch Resolution' })
Options.StretchResolutionValue = World_Tab:AddSlider('StretchResolutionValue', { Text = 'Resolution (Y-Stretch)', Default = 0.80, Min = 0.10, Max = 2.00, Rounding = 2, Compact = false })

-- --- Bullet / Tracers ---
-- Bullet
Toggles.Tracers = Bullet_Tab:AddToggle('Tracers', { Text = 'Custom Tracers', Default = false })

local TracersDep = Bullet_Tab:AddDependencyBox()
TracersDep:SetupDependencies({ { Toggles.Tracers, true } })

TracersDep:AddDivider()
TracersDep:AddLabel('Global Mode & Style')
Options.TracerMode = TracersDep:AddDropdown('TracerMode', { Text = 'Tracer Style', Default = 1, Values = { 'Solid Beam', 'Laser Cylinder', 'Flying Bullet', 'Camera Facing Beam', 'Pulse Fade' } })
Options.TracerMaterial = TracersDep:AddDropdown('TracerMaterial', { Text = 'Material', Default = 1, Values = { 'Neon', 'ForceField', 'Glass', 'Ice', 'SmoothPlastic' } })
Options.TracerTransparency = TracersDep:AddSlider('TracerTransparency', { Text = 'Transparency', Default = 0.2, Min = 0, Max = 1, Rounding = 2, Compact = false })
Options.TracerColorMode = TracersDep:AddDropdown('TracerColorMode', { Text = 'Color Mode', Default = 1, Values = { 'Solid Color', 'Gradient (Muzzle -> Hit)' } })
Options.RainbowSpeed = TracersDep:AddSlider('RainbowSpeed', { Text = 'Rainbow Speed', Default = 1, Min = 0.1, Max = 10, Rounding = 1, Compact = false })
Options.RainbowSpeed.Visible = false

TracersDep:AddDivider()
TracersDep:AddLabel('Flying Bullet')
Options.FlyingBulletSpeed = TracersDep:AddSlider('FlyingBulletSpeed', { Text = 'Bullet Speed', Default = 1200, Min = 200, Max = 4000, Rounding = 0, Compact = false })
Options.FlyingBulletLength = TracersDep:AddSlider('FlyingBulletLength', { Text = 'Bullet Length', Default = 4, Min = 1, Max = 20, Rounding = 1, Compact = false })

TracersDep:AddDivider()
TracersDep:AddLabel('Hit Impact & Glow')
Toggles.TracersImpact = TracersDep:AddToggle('TracersImpact', { Text = 'Hit Impact Spark', Default = true })
Options.TracerImpactSize = TracersDep:AddSlider('TracerImpactSize', { Text = 'Impact Size', Default = 0.8, Min = 0.2, Max = 3.0, Rounding = 2, Compact = false })
Toggles.TracersGlow = TracersDep:AddToggle('TracersGlow', { Text = 'Light Glow', Default = false })

local GlowDep = TracersDep:AddDependencyBox()
GlowDep:SetupDependencies({ { Toggles.TracersGlow, true } })
Options.TracerGlowRange = GlowDep:AddSlider('TracerGlowRange', { Text = 'Glow Range', Default = 7, Min = 1, Max = 20, Rounding = 0, Compact = false })
Options.TracerGlowBrightness = GlowDep:AddSlider('TracerGlowBrightness', { Text = 'Glow Brightness', Default = 5, Min = 1, Max = 15, Rounding = 0, Compact = false })

TracersDep:AddDivider()
TracersDep:AddLabel('Bullet Global')
Toggles.ShowBulletTracers = TracersDep:AddToggle('ShowBulletTracers', { Text = 'Bullet Tracers', Default = true })
local BulletTracerDep = TracersDep:AddDependencyBox()
BulletTracerDep:SetupDependencies({ { Toggles.ShowBulletTracers, true } })
BulletTracerDep:AddLabel('Color'):AddColorPicker('BulletColor', { Default = Color3.fromRGB(255, 255, 0), Title = 'Bullet Color' })
Options.BulletThickness = BulletTracerDep:AddSlider('BulletThickness', { Text = 'Thickness', Default = 0.1, Min = 0.02, Max = 2, Rounding = 3, Compact = false })
Options.BulletLifetime = BulletTracerDep:AddSlider('BulletLifetime', { Text = 'Lifetime (s)', Default = 0.3, Min = 0.01, Max = 5, Rounding = 2, Compact = false })
Toggles.BulletRainbow = BulletTracerDep:AddToggle('BulletRainbow', { Text = 'Rainbow', Default = false })
TracersDep:AddDivider()
TracersDep:AddLabel('Sniper')
Toggles.ShowSniperTracers = TracersDep:AddToggle('ShowSniperTracers', { Text = 'Sniper Tracers', Default = true })
local SniperTracerDep = TracersDep:AddDependencyBox()
SniperTracerDep:SetupDependencies({ { Toggles.ShowSniperTracers, true } })
SniperTracerDep:AddLabel('Color'):AddColorPicker('SniperColor', { Default = Color3.fromRGB(190, 190, 190), Title = 'Sniper Color' })
Options.SniperThickness = SniperTracerDep:AddSlider('SniperThickness', { Text = 'Thickness', Default = 0.17, Min = 0.02, Max = 2, Rounding = 3, Compact = false })
Options.SniperLifetime = SniperTracerDep:AddSlider('SniperLifetime', { Text = 'Lifetime (s)', Default = 4, Min = 0.01, Max = 10, Rounding = 2, Compact = false })
Toggles.SniperRainbow = SniperTracerDep:AddToggle('SniperRainbow', { Text = 'Rainbow', Default = false })
TracersDep:AddDivider()
TracersDep:AddLabel('Taser')
Toggles.ShowTaserTracers = TracersDep:AddToggle('ShowTaserTracers', { Text = 'Taser Tracers', Default = true })
local TaserTracerDep = TracersDep:AddDependencyBox()
TaserTracerDep:SetupDependencies({ { Toggles.ShowTaserTracers, true } })
TaserTracerDep:AddLabel('Color'):AddColorPicker('TaserColor', { Default = Color3.fromRGB(0, 234, 255), Title = 'Taser Color' })
Options.TaserThickness = TaserTracerDep:AddSlider('TaserThickness', { Text = 'Thickness', Default = 0.2, Min = 0.02, Max = 2, Rounding = 3, Compact = false })
Options.TaserLifetime = TaserTracerDep:AddSlider('TaserLifetime', { Text = 'Lifetime (s)', Default = 2, Min = 0.01, Max = 10, Rounding = 2, Compact = false })
Toggles.TaserRainbow = TaserTracerDep:AddToggle('TaserRainbow', { Text = 'Rainbow', Default = false })
TracersDep:AddDivider()
Toggles.TracersFilters = TracersDep:AddToggle('TracersFilters', { Text = 'Filters', Default = false })

local FiltersDep = TracersDep:AddDependencyBox()
FiltersDep:SetupDependencies({ { Toggles.TracersFilters, true } })
Toggles.TracersTeammates = FiltersDep:AddToggle('TracersTeammates', { Text = 'Teammates', Default = true })
Toggles.TracersGuards = FiltersDep:AddToggle('TracersGuards', { Text = 'Guards', Default = true })
Toggles.TracersInmates = FiltersDep:AddToggle('TracersInmates', { Text = 'Inmates', Default = true })
Toggles.TracersHostile = FiltersDep:AddToggle('TracersHostile', { Text = 'Hostile', Default = true })
Toggles.TracersCriminals = FiltersDep:AddToggle('TracersCriminals', { Text = 'Criminals', Default = true })

local function updateRainbowSpeed()
    Options.RainbowSpeed.Visible = Toggles.BulletRainbow.Value or Toggles.SniperRainbow.Value or Toggles.TaserRainbow.Value
end
Toggles.BulletRainbow:OnChanged(updateRainbowSpeed)
Toggles.SniperRainbow:OnChanged(updateRainbowSpeed)
Toggles.TaserRainbow:OnChanged(updateRainbowSpeed)

-- --- Particles ---
Toggles.Particles = Particles_Tab:AddToggle('Particles', { Text = 'Enabled', Default = false })
Toggles.Particles:AddColorPicker('ParticleColor', { Default = Color3.fromRGB(255, 100, 200), Title = 'Particle Color' })
Toggles.ParticleRainbow = Particles_Tab:AddToggle('ParticleRainbow', { Text = 'Rainbow', Default = false })

local ParticlesDep = Particles_Tab:AddDependencyBox()
ParticlesDep:SetupDependencies({ { Toggles.Particles, true } })

local particleStyleList = { 'Default', 'Bloom', 'Star', 'Heart', 'Dollar', 'Snow', 'Star 2', 'Kronex', 'Random' }
local particleModeList = { 'Normal', 'Bounce', 'Fountain', 'Vortex', 'Burst' }

Options.ParticleType = ParticlesDep:AddDropdown('ParticleType', {
    Values = { 'Bloom', 'Star', 'Heart', 'Dollar', 'Snow', 'Star 2', 'Kronex', 'Random' },
    Default = 1,
    Multi = false,
    Text = 'Default Global Style'
})

Options.ParticleSpawnEvents = ParticlesDep:AddDropdown('ParticleSpawnEvents', {
    Values = { 'Attack', 'Totem', 'Move', 'Idle', 'Throw' },
    Default = { Attack = true, Totem = true, Move = true, Throw = true },
    Multi = true,
    Text = 'Spawn On Events'
})

Options.ParticleSpeed = ParticlesDep:AddSlider('ParticleSpeed', { Text = 'Speed', Default = 1.5, Min = 0.1, Max = 5, Rounding = 1, Compact = false })
Options.ParticleSize = ParticlesDep:AddSlider('ParticleSize', { Text = 'Size', Default = 1.2, Min = 0.2, Max = 5, Rounding = 1, Compact = false })

Toggles.ParticleRotation = ParticlesDep:AddToggle('ParticleRotation', { Text = 'Rotation', Default = true })
Toggles.ParticleGlow = ParticlesDep:AddToggle('ParticleGlow', { Text = 'Glow Effect', Default = true })
Toggles.ParticleThroughWalls = ParticlesDep:AddToggle('ParticleThroughWalls', { Text = 'Through Walls', Default = true })

-- Attack
ParticlesDep:AddDivider('Attack Action')
Options.AttackParticleStyle = ParticlesDep:AddDropdown('AttackParticleStyle', { Values = particleStyleList, Default = 3, Text = 'Attack Style' })
Options.AttackParticleMode = ParticlesDep:AddDropdown('AttackParticleMode', { Values = particleModeList, Default = 2, Text = 'Attack Mode' })
Options.ParticleAttackCount = ParticlesDep:AddSlider('ParticleAttackCount', { Text = 'Attack Count', Default = 15, Min = 3, Max = 40, Rounding = 0, Compact = false })
Toggles.AttackCustomColor = ParticlesDep:AddToggle('AttackCustomColor', { Text = 'Attack Custom Color', Default = false })
Toggles.AttackCustomColor:AddColorPicker('AttackColor', { Default = Color3.fromRGB(255, 70, 70), Title = 'Attack Color' })

-- Totem
ParticlesDep:AddDivider('Totem Action')
Options.TotemParticleStyle = ParticlesDep:AddDropdown('TotemParticleStyle', { Values = particleStyleList, Default = 8, Text = 'Totem Style' })
Options.TotemParticleMode = ParticlesDep:AddDropdown('TotemParticleMode', { Values = particleModeList, Default = 3, Text = 'Totem Mode' })
Options.ParticleTotemCount = ParticlesDep:AddSlider('ParticleTotemCount', { Text = 'Totem Count', Default = 18, Min = 4, Max = 40, Rounding = 0, Compact = false })
Toggles.TotemCustomColor = ParticlesDep:AddToggle('TotemCustomColor', { Text = 'Totem Custom Color', Default = false })
Toggles.TotemCustomColor:AddColorPicker('TotemColor', { Default = Color3.fromRGB(127, 221, 144), Title = 'Totem Color' })

-- Move
ParticlesDep:AddDivider('Move Action')
Options.MoveParticleStyle = ParticlesDep:AddDropdown('MoveParticleStyle', { Values = particleStyleList, Default = 6, Text = 'Move Style' })
Options.MoveParticleMode = ParticlesDep:AddDropdown('MoveParticleMode', { Values = particleModeList, Default = 1, Text = 'Move Mode' })
Options.ParticleMoveCount = ParticlesDep:AddSlider('ParticleMoveCount', { Text = 'Move Count', Default = 3, Min = 1, Max = 10, Rounding = 0, Compact = false })
Toggles.MoveCustomColor = ParticlesDep:AddToggle('MoveCustomColor', { Text = 'Move Custom Color', Default = false })
Toggles.MoveCustomColor:AddColorPicker('MoveColor', { Default = Color3.fromRGB(100, 200, 255), Title = 'Move Color' })

-- Idle
ParticlesDep:AddDivider('Idle Action')
Options.IdleParticleStyle = ParticlesDep:AddDropdown('IdleParticleStyle', { Values = particleStyleList, Default = 4, Text = 'Idle Style' })
Options.IdleParticleMode = ParticlesDep:AddDropdown('IdleParticleMode', { Values = particleModeList, Default = 4, Text = 'Idle Mode' })
Options.ParticleIdleCount = ParticlesDep:AddSlider('ParticleIdleCount', { Text = 'Idle Count', Default = 3, Min = 1, Max = 15, Rounding = 0, Compact = false })
Options.ParticleIdleRange = ParticlesDep:AddSlider('ParticleIdleRange', { Text = 'Idle Range', Default = 16, Min = 4, Max = 32, Rounding = 0, Compact = false })
Toggles.IdleCustomColor = ParticlesDep:AddToggle('IdleCustomColor', { Text = 'Idle Custom Color', Default = false })
Toggles.IdleCustomColor:AddColorPicker('IdleColor', { Default = Color3.fromRGB(255, 120, 220), Title = 'Idle Color' })

-- Throw
ParticlesDep:AddDivider('Throw Action')
Options.ThrowParticleStyle = ParticlesDep:AddDropdown('ThrowParticleStyle', { Values = particleStyleList, Default = 2, Text = 'Throw Style' })
Options.ThrowParticleMode = ParticlesDep:AddDropdown('ThrowParticleMode', { Values = particleModeList, Default = 1, Text = 'Throw Mode' })
Options.ParticleThrowCount = ParticlesDep:AddSlider('ParticleThrowCount', { Text = 'Throw Count', Default = 4, Min = 1, Max = 12, Rounding = 0, Compact = false })
Toggles.ThrowCustomColor = ParticlesDep:AddToggle('ThrowCustomColor', { Text = 'Throw Custom Color', Default = false })
Toggles.ThrowCustomColor:AddColorPicker('ThrowColor', { Default = Color3.fromRGB(255, 210, 80), Title = 'Throw Color' })

-- --- Target HUD ---
Toggles.TargetHUD = TargetHUD_Tab:AddToggle('TargetHUD', { Text = 'Target HUD', Default = false })
Toggles.TargetHUD:AddKeyPicker('TargetHUDBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Target HUD' })
TargetHUD_Tab:AddDivider()

Toggles.TargetHUDCustomColor = TargetHUD_Tab:AddToggle('TargetHUDCustomColor', { Text = 'Custom Accent Color', Default = false })
Toggles.TargetHUDCustomColor:AddColorPicker('TargetHUDAccentColor', { Default = Color3.fromRGB(0, 170, 255), Title = 'Accent Color' })

Options.TargetHUDStyle = TargetHUD_Tab:AddDropdown('TargetHUDStyle', {
    Values = { 'Linoria Modern', 'Linoria Accent' },
    Default = 1,
    Multi = false,
    Text = 'Style'
})

TargetHUD_Tab:AddDivider()
Toggles.TargetHUDShowAvatar = TargetHUD_Tab:AddToggle('TargetHUDShowAvatar', { Text = 'Show Avatar', Default = true })
Toggles.TargetHUDShowChance = TargetHUD_Tab:AddToggle('TargetHUDShowChance', { Text = 'Show Kill Chance', Default = true })
Toggles.TargetHUDShowWeapon = TargetHUD_Tab:AddToggle('TargetHUDShowWeapon', { Text = 'Show Weapon', Default = true })
Toggles.TargetHUDShowDistance = TargetHUD_Tab:AddToggle('TargetHUDShowDistance', { Text = 'Show Distance', Default = true })
TargetHUD_Tab:AddDivider()
TargetHUD_Tab:AddButton({
    Text = 'Reset Position',
    Func = function()
        if _G.BoarsResetTargetHUD then
            _G.BoarsResetTargetHUD()
        end
    end
})

-- --- Killfeed ---
Toggles.Killfeed = Killfeed_Tab:AddToggle('Killfeed', { Text = 'Killfeed', Default = false })
Toggles.Killfeed:AddKeyPicker('KillfeedBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Killfeed' })

local KillfeedDep = Killfeed_Tab:AddDependencyBox()
KillfeedDep:SetupDependencies({ { Toggles.Killfeed, true } })

Toggles.KillfeedOnlyLocal = KillfeedDep:AddToggle('KillfeedOnlyLocal', {
    Text = 'Only My Kills',
    Default = false,
    Tooltip = 'Only display kills and deaths involving you'
})

Toggles.KillfeedHighlightMine = KillfeedDep:AddToggle('KillfeedHighlightMine', {
    Text = 'Highlight My Kills',
    Default = true,
    Tooltip = 'Highlight your kills with custom accent border'
})

Toggles.KillfeedShowWeapon = KillfeedDep:AddToggle('KillfeedShowWeapon', {
    Text = 'Show Weapon',
    Default = true
})

Toggles.KillfeedShowHeadshot = KillfeedDep:AddToggle('KillfeedShowHeadshot', {
    Text = 'Show Headshot Icon',
    Default = true
})

Toggles.KillfeedShowDistance = KillfeedDep:AddToggle('KillfeedShowDistance', {
    Text = 'Show Distance',
    Default = true
})

KillfeedDep:AddDivider()

Options.KillfeedMaxItems = KillfeedDep:AddSlider('KillfeedMaxItems', {
    Text = 'Max Displayed',
    Default = 5,
    Min = 2,
    Max = 10,
    Rounding = 0,
    Compact = false
})

Options.KillfeedDuration = KillfeedDep:AddSlider('KillfeedDuration', {
    Text = 'Duration (s)',
    Default = 5,
    Min = 2,
    Max = 12,
    Rounding = 1,
    Compact = false
})

KillfeedDep:AddDivider()

KillfeedDep:AddButton({
    Text = 'Test Killfeed (Preview)',
    Func = function()
        if _G.BoarsTestKillfeed then
            _G.BoarsTestKillfeed()
        end
    end
})

-- ====================== MOVEMENT ======================

-- Left Column: Player Movement & Flight
local MoveBox = Tabs.Movement:AddLeftTabbox()
local Main_Tab = MoveBox:AddTab('Movement')
local Fly_Tab = MoveBox:AddTab('Player Fly')

-- Movement (On Foot)
Toggles.Noclip = Main_Tab:AddToggle('Noclip', { Text = 'Noclip', Default = false })
Toggles.Noclip:AddKeyPicker('NoclipBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Noclip' })

Main_Tab:AddDivider()
Toggles.KillbrickBypass = Main_Tab:AddToggle('KillbrickBypass', { Text = 'Killbrick Bypass', Default = false })
Toggles.KillbrickBypass:AddKeyPicker('KillbrickBypassBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Killbrick Bypass' })

local KillbrickDep = Main_Tab:AddDependencyBox()
KillbrickDep:SetupDependencies({ { Toggles.KillbrickBypass, true } })
Toggles.KillbrickRemoveBoundary = KillbrickDep:AddToggle('KillbrickRemoveBoundary', { Text = 'Remove Map Boundary', Default = true })
Toggles.KillbrickDisableTouch = KillbrickDep:AddToggle('KillbrickDisableTouch', { Text = 'Disable Touch Kill Transmitters', Default = true })
Toggles.KillbrickCharTouchProtect = KillbrickDep:AddToggle('KillbrickCharTouchProtect', { Text = 'Character Touch Protection', Default = false })

Main_Tab:AddDivider()
Toggles.InfiniteStamina = Main_Tab:AddToggle('InfiniteStamina', { Text = 'Infinite Stamina', Default = false })

Main_Tab:AddDivider()
Toggles.AirStrafe = Main_Tab:AddToggle('AirStrafe', { Text = 'Air Strafe', Default = false })
Toggles.AirStrafe:AddKeyPicker('AirStrafeBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Air Strafe' })

Main_Tab:AddDivider()
Toggles.SpeedRegions = Main_Tab:AddToggle('SpeedRegions', { Text = 'Speed Zones', Default = false })
Toggles.SpeedRegions:AddKeyPicker('SpeedRegionsBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Speed Zones' })

-- Player Fly (Flight)
Toggles.PlayerFly = Fly_Tab:AddToggle('PlayerFly', { Text = 'Fly', Default = false })
Toggles.PlayerFly:AddKeyPicker('PlayerFlyBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Player Fly' })

local FlyDep = Fly_Tab:AddDependencyBox()
FlyDep:SetupDependencies({ { Toggles.PlayerFly, true } })
Toggles.PlayerFlySafe = FlyDep:AddToggle('PlayerFlySafe', { Text = 'Safe Bypass (Anti-Kick)', Default = true })
Options.PlayerFlySpeed = FlyDep:AddSlider('PlayerFlySpeed', { Text = 'Fly Speed', Default = 22, Min = 10, Max = 150, Rounding = 0, Compact = false })
Options.PlayerFlyVertSpeed = FlyDep:AddSlider('PlayerFlyVertSpeed', { Text = 'Vertical Speed', Default = 20, Min = 5, Max = 80, Rounding = 0, Compact = false })
Options.PlayerFlyMode = FlyDep:AddDropdown('PlayerFlyMode', { Values = { 'Camera Relative', 'Flat / Level' }, Default = 1, Multi = false, Text = 'Fly Mode' })
Toggles.PlayerFlyNoclip = FlyDep:AddToggle('PlayerFlyNoclip', { Text = 'Fly Noclip', Default = false })

-- Right Column: Combat Movement & Vehicles
local CombatMoveBox = Tabs.Movement:AddRightTabbox()
local AntiAim_Tab = CombatMoveBox:AddTab('Anti-Aim')
local Car_Tab = CombatMoveBox:AddTab('Vehicle')

-- Anti-Aim
Toggles.AntiAim = AntiAim_Tab:AddToggle('AntiAim', { Text = 'Anti Aim', Default = false })
Toggles.AntiAim:AddKeyPicker('AntiAimBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Anti Aim' })

local AntiAimDep = AntiAim_Tab:AddDependencyBox()
AntiAimDep:SetupDependencies({ { Toggles.AntiAim, true } })
Options.AntiAimMode = AntiAimDep:AddDropdown('AntiAimMode', { Values = { 'Spin', 'Jitter' }, Default = 1, Multi = false, Text = 'Mode' })
Toggles.AntiAimDisableInVehicle = AntiAimDep:AddToggle('AntiAimDisableInVehicle', { Text = 'Disable in Vehicle', Default = true })
Options.SpinSpeed = AntiAimDep:AddSlider('SpinSpeed', { Text = 'Spin Speed', Default = 20, Min = 1, Max = 100, Rounding = 0, Compact = false })
Options.JitterRange = AntiAimDep:AddSlider('JitterRange', { Text = 'Jitter Range', Default = 30, Min = 5, Max = 90, Rounding = 0, Compact = false })

local function updateAntiAimUI()
    task.defer(function()
        local mode = Options.AntiAimMode.Value
        Options.SpinSpeed.Visible = (mode == 'Spin')
        Options.JitterRange.Visible = (mode == 'Jitter')
    end)
end
Options.AntiAimMode:OnChanged(updateAntiAimUI)
Toggles.AntiAim:OnChanged(updateAntiAimUI)
updateAntiAimUI()

-- Vehicle
Toggles.CarFly = Car_Tab:AddToggle('CarFly', { Text = 'Car Fly', Default = false })
Toggles.CarFly:AddKeyPicker('CarFlyBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Car Fly' })
Car_Tab:AddDivider()
Options.CarFlySpeed = Car_Tab:AddSlider('CarFlySpeed', { Text = 'Fly Speed', Default = 100, Min = 20, Max = 300, Rounding = 0, Compact = false })
Options.CarFlyVertSpeed = Car_Tab:AddSlider('CarFlyVertSpeed', { Text = 'Vertical Speed', Default = 50, Min = 10, Max = 150, Rounding = 0, Compact = false })
Options.CarFlyMode = Car_Tab:AddDropdown('CarFlyMode', { Values = { 'Camera Relative', 'Flat / Level' }, Default = 1, Multi = false, Text = 'Fly Mode' })
Car_Tab:AddDivider()
Toggles.CarFlyNoclip = Car_Tab:AddToggle('CarFlyNoclip', { Text = 'Vehicle Noclip (Fly Through Walls)', Default = false })
end


-- ====================== LOGIC ======================

-- Noclip
do
    local noclipBypassed = false
    local function bypassNoclip()
        if noclipBypassed then return end
        local charCollision = ReplicatedStorage:FindFirstChild('Scripts') and ReplicatedStorage.Scripts:FindFirstChild('CharacterCollision')
        if charCollision then
            charCollision:Destroy()
        end
        local char = LP.Character
        if char then
            local head = char:FindFirstChild('Head')
            if head then
                for _, conn in getconnections(head:GetPropertyChangedSignal('CanCollide')) do
                    conn:Disable()
                end
            end
        end
        noclipBypassed = true
    end

    RunService.Stepped:Connect(function()
        if Toggles.Noclip.Value then
            bypassNoclip()
            local char = LP.Character
            if not char then return end
            for _, part in char:GetDescendants() do
                if part:IsA('BasePart') then
                    part.CanCollide = false
                end
            end
        end
    end)
end

-- Killbrick & Boundary Bypass (Anti-Death Barrier)
do
    local function neutralizePart(part)
        if not part or not part:IsA('BasePart') then return end
        pcall(function()
            part.CanTouch = false
            part.CanCollide = false
            part.CanQuery = false
            for _, child in ipairs(part:GetChildren()) do
                if child:IsA('TouchTransmitter') then
                    child:Destroy()
                end
            end
            part:Destroy()
        end)
    end

    local function clearBoundary()
        local boundary = Workspace:FindFirstChild('BOUNDARY')
        if boundary then
            pcall(function()
                for _, part in ipairs(boundary:GetChildren()) do
                    if part:IsA('BasePart') then
                        neutralizePart(part)
                    end
                end
                boundary:Destroy()
            end)
        end
    end

    local function scanAndNeutralize()
        if not (Toggles.KillbrickBypass and Toggles.KillbrickBypass.Value) then return end

        -- 1. Remove Workspace.BOUNDARY
        if not Toggles.KillbrickRemoveBoundary or Toggles.KillbrickRemoveBoundary.Value then
            clearBoundary()
        end

        -- 2. Neutralize any boundary/killbrick parts in Workspace
        if not Toggles.KillbrickDisableTouch or Toggles.KillbrickDisableTouch.Value then
            for _, obj in ipairs(Workspace:GetChildren()) do
                if obj.Name:lower() == 'boundary' then
                    pcall(function()
                        for _, p in ipairs(obj:GetChildren()) do
                            neutralizePart(p)
                        end
                        obj:Destroy()
                    end)
                elseif obj:IsA('BasePart') and (obj.Name:lower():find('boundary') or obj.Name:lower():find('killbrick')) then
                    neutralizePart(obj)
                end
            end
        end
    end

    -- Initial sweep on load
    clearBoundary()
    scanAndNeutralize()

    -- Toggle change handler
    if Toggles.KillbrickBypass then
        Toggles.KillbrickBypass:OnChanged(function()
            if Toggles.KillbrickBypass.Value then
                scanAndNeutralize()
            end
        end)
    end

    -- Watch for newly spawned / streaming boundary parts
    Workspace.ChildAdded:Connect(function(child)
        if Toggles.KillbrickBypass and Toggles.KillbrickBypass.Value then
            local low = child.Name:lower()
            if low == 'boundary' or low:find('killbrick') then
                task.defer(function()
                    if child and child.Parent then
                        pcall(function()
                            for _, p in ipairs(child:GetChildren()) do
                                neutralizePart(p)
                            end
                            child:Destroy()
                        end)
                    end
                end)
            end
        end
    end)

    -- Periodic background maintenance sweep
    task.spawn(function()
        while true do
            task.wait(2.5)
            if Toggles.KillbrickBypass and Toggles.KillbrickBypass.Value then
                pcall(scanAndNeutralize)
            end
        end
    end)

    -- Character Touch Protection (prevents touching hazards while moving/flying)
    RunService.Stepped:Connect(function()
        if not (Toggles.KillbrickBypass and Toggles.KillbrickBypass.Value) then return end
        if Toggles.KillbrickCharTouchProtect and Toggles.KillbrickCharTouchProtect.Value then
            local char = LP.Character
            if char then
                for _, part in ipairs(char:GetChildren()) do
                    if part:IsA('BasePart') and part.Name ~= 'HumanoidRootPart' then
                        part.CanTouch = false
                    end
                end
            end
        end
    end)
end

-- Vehicle Detection Helpers
local function getVehicleFromSeat(seat)
    if not seat then return nil end
    local carContainer = Workspace:FindFirstChild('CarContainer')
    if carContainer and seat:IsDescendantOf(carContainer) then
        local curr = seat
        while curr.Parent and curr.Parent ~= carContainer and curr.Parent ~= Workspace do
            curr = curr.Parent
        end
        return curr
    end
    local model = seat:FindFirstAncestorOfClass('Model')
    if model then
        if CollectionService:HasTag(model, 'Vehicle') or model.Name == 'Squad' or (carContainer and model:IsDescendantOf(carContainer)) then
            return model
        end
    end
    if seat:IsA('VehicleSeat') or seat:IsA('Seat') then
        return model or seat
    end
    return nil
end

local function isInVehicle(player)
    local char = player and player.Character
    if not char then return false, nil end
    local hum = char:FindFirstChildOfClass('Humanoid')
    local seat = hum and hum.SeatPart
    if seat then
        local vehicle = getVehicleFromSeat(seat)
        return true, vehicle or seat
    end
    return false, nil
end

-- Anti Aim
do
    local antiAngle = 0
    local antiJitterDir = 1
    RunService.RenderStepped:Connect(function(dt)
        if Toggles.AntiAim.Value then
            local disableInVehicle = (Toggles.AntiAimDisableInVehicle == nil) or Toggles.AntiAimDisableInVehicle.Value
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            if disableInVehicle and (isInVehicle(LP) or (hum and hum.SeatPart)) then
                return
            end

            local root = char and char:FindFirstChild('HumanoidRootPart')
            if root then
                local mode = Options.AntiAimMode.Value
                if mode == 'Spin' then
                    antiAngle = (antiAngle + (Options.SpinSpeed.Value or 20) * 0.15) % 360
                    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(antiAngle), 0)
                elseif mode == 'Jitter' then
                    local range = Options.JitterRange.Value or 30
                    antiAngle = math.random(-range, range)
                    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(antiAngle), 0)
                end
            end
        end
    end)
end

-- Car Fly
do
    local carFlyActive = false
    local carFlyBV = nil
    local carFlyBG = nil
    local currentCarModel = nil
    local originalCanCollide = {}

    local function stopCarFly()
        if carFlyBV then
            pcall(function() carFlyBV:Destroy() end)
            carFlyBV = nil
        end
        if carFlyBG then
            pcall(function() carFlyBG:Destroy() end)
            carFlyBG = nil
        end
        if next(originalCanCollide) then
            for part, canCollide in pairs(originalCanCollide) do
                if part and part.Parent and part:IsA('BasePart') then
                    pcall(function() part.CanCollide = canCollide end)
                end
            end
            table.clear(originalCanCollide)
        end
        currentCarModel = nil
        carFlyActive = false
    end

    local function getFlyDirection(mode)
        if UserInputService:GetFocusedTextBox() then
            return Vector3.zero, 0
        end

        local camCF = Camera.CFrame
        local forward = camCF.LookVector
        local right = camCF.RightVector

        local vertDir = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertDir = vertDir + 1
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertDir = vertDir - 1
        end

        if mode == 'Flat / Level' then
            forward = Vector3.new(forward.X, 0, forward.Z)
            if forward.Magnitude > 0.001 then
                forward = forward.Unit
            else
                forward = Vector3.new(0, 0, -1)
            end
            right = Vector3.new(right.X, 0, right.Z)
            if right.Magnitude > 0.001 then
                right = right.Unit
            end
        end

        local hDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            hDir = hDir + forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            hDir = hDir - forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            hDir = hDir + right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            hDir = hDir - right
        end

        if hDir.Magnitude > 0.001 then
            hDir = hDir.Unit
        end

        return hDir, vertDir
    end

    if Toggles.CarFly then
        Toggles.CarFly:OnChanged(function()
            if not Toggles.CarFly.Value then
                stopCarFly()
            end
        end)
    end

    RunService.RenderStepped:Connect(function()
        if not (Toggles.CarFly and Toggles.CarFly.Value) then
            if carFlyActive then
                stopCarFly()
            end
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local seat = hum and hum.SeatPart

        if not seat or not seat.Parent then
            if carFlyActive then
                stopCarFly()
            end
            return
        end

        local rootPart = seat.AssemblyRootPart or seat
        local carModel = getVehicleFromSeat(seat) or (seat:IsA('Model') and seat or seat.Parent)

        if not carFlyBV or carFlyBV.Parent ~= rootPart then
            if carFlyBV then pcall(function() carFlyBV:Destroy() end) end
            carFlyBV = Instance.new('BodyVelocity')
            carFlyBV.Name = 'BoarsCarFlyVelocity'
            carFlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            carFlyBV.Velocity = Vector3.zero
            carFlyBV.Parent = rootPart
        end

        if not carFlyBG or carFlyBG.Parent ~= rootPart then
            if carFlyBG then pcall(function() carFlyBG:Destroy() end) end
            carFlyBG = Instance.new('BodyGyro')
            carFlyBG.Name = 'BoarsCarFlyGyro'
            carFlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            carFlyBG.P = 10000
            carFlyBG.D = 500
            carFlyBG.CFrame = rootPart.CFrame
            carFlyBG.Parent = rootPart
        end

        carFlyActive = true
        currentCarModel = carModel

        -- Vehicle Noclip (Fly through walls, fences and gates)
        if Toggles.CarFlyNoclip and Toggles.CarFlyNoclip.Value and carModel and carModel:IsA('Instance') then
            for _, part in ipairs(carModel:GetDescendants()) do
                if part:IsA('BasePart') and part ~= seat then
                    if originalCanCollide[part] == nil then
                        originalCanCollide[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        elseif next(originalCanCollide) and not (Toggles.CarFlyNoclip and Toggles.CarFlyNoclip.Value) then
            for part, canCollide in pairs(originalCanCollide) do
                if part and part.Parent and part:IsA('BasePart') then
                    pcall(function() part.CanCollide = canCollide end)
                end
            end
            table.clear(originalCanCollide)
        end

        local mode = (Options.CarFlyMode and Options.CarFlyMode.Value) or 'Camera Relative'
        local speed = (Options.CarFlySpeed and Options.CarFlySpeed.Value) or 100
        local vertSpeed = (Options.CarFlyVertSpeed and Options.CarFlyVertSpeed.Value) or 60

        local hDir, vertDir = getFlyDirection(mode)
        local camCF = Camera.CFrame

        if mode == 'Camera Relative' then
            carFlyBG.CFrame = camCF
        else
            local look = camCF.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude > 0.001 then
                carFlyBG.CFrame = CFrame.lookAt(rootPart.Position, rootPart.Position + flatLook.Unit)
            end
        end

        local targetVelocity = (hDir * speed) + (Vector3.new(0, 1, 0) * (vertDir * vertSpeed))

        if targetVelocity.Magnitude > 0.1 then
            carFlyBV.Velocity = targetVelocity
        else
            carFlyBV.Velocity = Vector3.zero
            pcall(function()
                rootPart.AssemblyLinearVelocity = Vector3.zero
                rootPart.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
end

-- Player Fly (with Anti-Cheat & Fall Damage Bypass)
do
    local flyActive = false
    local flyBV = nil
    local flyBG = nil
    local currentVelocity = Vector3.zero
    local noclipParts = {}

    local function getFlyDirection(mode)
        if UserInputService:GetFocusedTextBox() then
            return Vector3.zero, 0
        end

        local camCF = Camera.CFrame
        local forward = camCF.LookVector
        local right = camCF.RightVector

        local vertDir = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            vertDir = vertDir + 1
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            vertDir = vertDir - 1
        end

        if mode == 'Flat / Level' then
            forward = Vector3.new(forward.X, 0, forward.Z)
            if forward.Magnitude > 0.001 then
                forward = forward.Unit
            else
                forward = Vector3.new(0, 0, -1)
            end
            right = Vector3.new(right.X, 0, right.Z)
            if right.Magnitude > 0.001 then
                right = right.Unit
            end
        end

        local hDir = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            hDir = hDir + forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            hDir = hDir - forward
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            hDir = hDir + right
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            hDir = hDir - right
        end

        if hDir.Magnitude > 0.001 then
            hDir = hDir.Unit
        end

        return hDir, vertDir
    end

    local function restoreNoclip(char)
        if char then
            for part, origState in pairs(noclipParts) do
                if part and part.Parent and part:IsDescendantOf(char) then
                    pcall(function() part.CanCollide = origState end)
                end
            end
        end
        table.clear(noclipParts)
    end

    local function stopPlayerFly()
        if flyBV then
            pcall(function() flyBV:Destroy() end)
            flyBV = nil
        end
        if flyBG then
            pcall(function() flyBG:Destroy() end)
            flyBG = nil
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')

        restoreNoclip(char)

        if hum then
            pcall(function()
                hum.PlatformStand = false
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
            end)
        end
        if root then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, math.clamp(root.AssemblyLinearVelocity.Y, -5, 0), 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
        currentVelocity = Vector3.zero
        flyActive = false
    end

    if Toggles.PlayerFly then
        Toggles.PlayerFly:OnChanged(function()
            if not Toggles.PlayerFly.Value then
                stopPlayerFly()
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        stopPlayerFly()
    end)

    -- Handle safe noclip during Stepped
    RunService.Stepped:Connect(function()
        if not (Toggles.PlayerFly and Toggles.PlayerFly.Value) then
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')

        if not char or not hum or not root or hum.Health <= 0 then
            return
        end

        if hum.Sit or hum.SeatPart then
            return
        end

        -- Safe noclip: exclude Head (monitored by game CharacterCollision.lua)
        if Toggles.PlayerFlyNoclip and Toggles.PlayerFlyNoclip.Value then
            for _, part in ipairs(char:GetChildren()) do
                if part:IsA('BasePart') and part.Name ~= 'Head' then
                    if noclipParts[part] == nil then
                        noclipParts[part] = part.CanCollide
                    end
                    part.CanCollide = false
                end
            end
        elseif next(noclipParts) then
            restoreNoclip(char)
        end
    end)

    local lastFlyTick = tick()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = math.clamp(now - lastFlyTick, 0.001, 0.1)
        lastFlyTick = now

        if not (Toggles.PlayerFly and Toggles.PlayerFly.Value) then
            if flyActive then
                stopPlayerFly()
            end
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')

        if not char or not hum or not root or hum.Health <= 0 then
            if flyActive then
                stopPlayerFly()
            end
            return
        end

        -- If sitting in a vehicle or chair, do not interfere with car controls
        if hum.Sit or hum.SeatPart then
            if flyActive then
                stopPlayerFly()
            end
            return
        end

        -- ANTI-CHEAT BYPASS:
        -- Use PlatformStand = true instead of forcing Running in mid-air.
        -- Running in mid-air with FloorMaterial == Air triggers "Anomalous behavior detected"!
        pcall(function()
            hum.PlatformStand = true
        end)

        -- Setup calibrated BodyMovers (4e4 force instead of 9e8 to avoid physics engine anomaly detection)
        if not flyBV or flyBV.Parent ~= root then
            if flyBV then pcall(function() flyBV:Destroy() end) end
            flyBV = Instance.new('BodyVelocity')
            flyBV.Name = 'BoarsFlyVelocity'
            flyBV.MaxForce = Vector3.new(4e4, 4e4, 4e4)
            flyBV.Velocity = Vector3.zero
            flyBV.Parent = root
        end

        if not flyBG or flyBG.Parent ~= root then
            if flyBG then pcall(function() flyBG:Destroy() end) end
            flyBG = Instance.new('BodyGyro')
            flyBG.Name = 'BoarsFlyGyro'
            flyBG.MaxTorque = Vector3.new(4e4, 4e4, 4e4)
            flyBG.P = 4000
            flyBG.D = 400
            flyBG.CFrame = root.CFrame
            flyBG.Parent = root
        end

        flyActive = true

        local mode = (Options.PlayerFlyMode and Options.PlayerFlyMode.Value) or 'Camera Relative'
        local speed = (Options.PlayerFlySpeed and Options.PlayerFlySpeed.Value) or 22
        local vertSpeed = (Options.PlayerFlyVertSpeed and Options.PlayerFlyVertSpeed.Value) or 20

        -- SAFE MODE BYPASS:
        -- Server checks displacement per tick. Normal sprint speed is 24 studs/s.
        -- If Safe Mode is enabled, clamp horizontal speed to 23 and vertical to 20.
        if Toggles.PlayerFlySafe and Toggles.PlayerFlySafe.Value then
            speed = math.clamp(speed, 5, 23)
            vertSpeed = math.clamp(vertSpeed, 5, 20)
        end

        local hDir, vertDir = getFlyDirection(mode)
        local camCF = Camera.CFrame

        -- Orient player
        if mode == 'Camera Relative' then
            flyBG.CFrame = camCF
        else
            local look = camCF.LookVector
            local flatLook = Vector3.new(look.X, 0, look.Z)
            if flatLook.Magnitude > 0.001 then
                flyBG.CFrame = CFrame.lookAt(root.Position, root.Position + flatLook.Unit)
            end
        end

        local desiredVelocity = (hDir * speed) + (Vector3.new(0, 1, 0) * (vertDir * vertSpeed))

        -- Smooth acceleration to prevent infinite-acceleration physics spikes
        currentVelocity = currentVelocity:Lerp(desiredVelocity, math.clamp(dt * 12, 0.1, 1))

        if desiredVelocity.Magnitude > 0.1 or currentVelocity.Magnitude > 0.1 then
            flyBV.Velocity = currentVelocity
        else
            flyBV.Velocity = Vector3.zero
            currentVelocity = Vector3.zero
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end

        -- Fall damage bypass: Keep downward velocity clamped so player never accumulates fatal fall speed
        pcall(function()
            if root.AssemblyLinearVelocity.Y < -15 then
                root.AssemblyLinearVelocity = Vector3.new(root.AssemblyLinearVelocity.X, -5, root.AssemblyLinearVelocity.Z)
            end
        end)
    end)
end

-- Infinite Stamina
Toggles.InfiniteStamina:OnChanged(function()
    if Toggles.InfiniteStamina.Value then
        local char = LP.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                for _, conn in getconnections(hum:GetPropertyChangedSignal("Jump")) do
                    conn:Disable()
                end
            end
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    task.wait(1)
    if Toggles.InfiniteStamina.Value then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, conn in getconnections(hum:GetPropertyChangedSignal("Jump")) do
                conn:Disable()
            end
        end
    end
end)

-- Air Strafe
do
    local airStrafeConn
    Toggles.AirStrafe:OnChanged(function()
        if Toggles.AirStrafe.Value then
            if airStrafeConn then return end
            airStrafeConn = RunService.RenderStepped:Connect(function()
                local char = LP.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if not hum or not root or hum.Health <= 0 then return end

                local state = hum:GetState()
                if state == Enum.HumanoidStateType.Freefall or state == Enum.HumanoidStateType.Jumping then
                    local moveDir = hum.MoveDirection
                    if moveDir.Magnitude > 0.001 then
                        local vel = root.AssemblyLinearVelocity
                        local speed = hum.WalkSpeed * 1.0
                        root.AssemblyLinearVelocity = Vector3.new(moveDir.X * speed, vel.Y, moveDir.Z * speed)
                    end
                end
            end)
        else
            if airStrafeConn then
                airStrafeConn:Disconnect()
                airStrafeConn = nil
            end
        end
    end)
end

-- Speed Zones
do
local subRegions = {
    {cx=752.77,  cz=2571.80, hx=109.93/2, hz=13.60/2},
    {cx=701.15,  cz=2313.70, hx=69.10/2,  hz=163.00/2},
    {cx=917.30,  cz=2392.60, hx=107.00/2, hz=28.00/2},
    {cx=830.30,  cz=2242.55, hx=58.00/2,  hz=34.10/2},
    {cx=748.90,  cz=2340.60, hx=59.40/2,  hz=109.20/2},
    {cx=799.10,  cz=2299.00, hx=14.00/2,  hz=33.99/2},
    {cx=826.69,  cz=2338.60, hx=51.19/2,  hz=12.00/2},
    {cx=799.65,  cz=2269.23, hx=12.90/2,  hz=21.50/2},
    {cx=765.36,  cz=2247.57, hx=59.32/2,  hz=64.82/2},
    {cx=850.20,  cz=2571.80, hx=23.20/2,  hz=13.60/2},
    {cx=779.80,  cz=2479.80, hx=164.00/2, hz=170.40/2},
    {cx=983.35,  cz=2315.15, hx=31.10/2,  hz=58.90/2},
    {cx=916.50,  cz=2225.40, hx=99.00/2,  hz=38.00/2},
    {cx=889.80,  cz=2361.60, hx=220.00/2, hz=34.00/2},
    {cx=915.80,  cz=2456.60, hx=64.00/2,  hz=100.00/2},
    {cx=820.80,  cz=2386.60, hx=82.00/2,  hz=16.00/2},
    {cx=916.90,  cz=2294.50, hx=98.20/2,  hz=100.20/2},
    {cx=836.95,  cz=2296.10, hx=61.70/2,  hz=73.00/2},
    {cx=872.30,  cz=2463.60, hx=19.00/2,  hz=62.00/2},
    {cx=959.30,  cz=2463.60, hx=19.00/2,  hz=62.00/2},
}
local prison = {cx=773.62, cz=2327.43, hx=563.37/2, hz=540.30/2}

local function inBox(x, z, r)
    return math.abs(x - r.cx) <= r.hx and math.abs(z - r.cz) <= r.hz
end

local function isInSubRegion(x, z)
    for _, r in ipairs(subRegions) do
        if inBox(x, z, r) then return true end
    end
    return false
end

local speedConn
Toggles.SpeedRegions:OnChanged(function()
    if Toggles.SpeedRegions.Value then
        if speedConn then return end
        speedConn = RunService.RenderStepped:Connect(function()
            local char = LP.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            local root = char:FindFirstChild("HumanoidRootPart")
            if not hum or not root or hum.Health <= 0 then return end

            local x, z = root.Position.X, root.Position.Z
            if isInSubRegion(x, z) then
                hum.WalkSpeed = 32
                hum.JumpHeight = 7.2
            elseif inBox(x, z, prison) then
                hum.WalkSpeed = 50
                hum.JumpHeight = 25
            else
                hum.WalkSpeed = 100
                hum.JumpHeight = 50
            end
        end)
    else
        if speedConn then
            speedConn:Disconnect()
            speedConn = nil
        end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.WalkSpeed = 16
            hum.JumpHeight = 7.2
        end
    end
end)
end

-- Weapon Chams
do
    local chamsConn
    Toggles.WeaponChams:OnChanged(function()
        if chamsConn then chamsConn:Disconnect(); chamsConn = nil end
        if not Toggles.WeaponChams.Value then return end
        chamsConn = RunService.RenderStepped:Connect(function()
            local tool = LP.Character and LP.Character:FindFirstChildOfClass('Tool')
            if not tool then return end
            local matName = Options.WeaponChamsMaterial.Value
            local mat = Enum.Material[matName]
            local col = Options.WeaponChamsColor and Options.WeaponChamsColor.Value or Color3.fromRGB(0, 170, 255)

            for _, part in tool:GetDescendants() do
                if not part:IsA('BasePart') then continue end
                pcall(function()
                    part.Color = col
                    part.MaterialVariant = ""
                    part.Material = mat
                    part.Transparency = 0
                    part.Reflectance = 0
                    part.CastShadow = true
                    if part:IsA('MeshPart') then
                        part.TextureID = ""
                        part.RenderFidelity = Enum.RenderFidelity.Performance
                    end
                    for _, child in part:GetChildren() do
                        if child:IsA('SurfaceAppearance') or child:IsA('Texture') or child:IsA('Decal') then
                            child:Destroy()
                        elseif child:IsA('DataModelMesh') then
                            child.TextureId = ""
                        end
                    end
                end)
            end
        end)
    end)
end

-- Arrest Aura
local ArrestPlayer = ReplicatedStorage:WaitForChild('Remotes'):WaitForChild('ArrestPlayer')
local ARREST_RANGE = 7.5

local function isArrestable(player)
    if player.Team == Teams.Criminals then return true end
    if player.Team == Teams.Inmates then
        local char = player.Character
        if not char then return false end
        local attrs = char:GetAttributes()
        if attrs.Hostile and attrs.Tased then return true end
        if attrs.Trespassing then return true end
    end
    return false
end

local lastArrestTime = 0
local arrestConn = nil

-- Arrest range visual (segmented circle like FOV)
local AR_SEG = 60
local arLines = {}
local arTris = {}

for i = 1, AR_SEG do
    local l = Drawing.new('Line')
    l.Visible = false
    l.Thickness = 1.5
    l.ZIndex = 10
    arLines[i] = l

    local t = Drawing.new('Triangle')
    t.Visible = false
    t.Filled = true
    t.ZIndex = 5
    arTris[i] = t
end

local function lerpColor3(a, b, t)
    return Color3.new(a.R + (b.R - a.R) * t, a.G + (b.G - a.G) * t, a.B + (b.B - a.B) * t)
end

local function smoothstep(t)
    t = math.clamp(t, 0, 1)
    return t * t * (3 - 2 * t)
end

local function getARSegColor(i, c1, c2, c3)
    local p = (i - 1) / AR_SEG
    local scaled = p * 3
    local idx = math.floor(scaled)
    local frac = smoothstep(scaled - idx)
    local colors = {c1, c2, c3}
    return lerpColor3(colors[(idx % 3) + 1], colors[((idx + 1) % 3) + 1], frac)
end

local function getARFillSegColor(i, c1, c2, c3)
    local p = (i - 0.5) / AR_SEG
    local scaled = p * 3
    local idx = math.floor(scaled)
    local frac = smoothstep(scaled - idx)
    local colors = {c1, c2, c3}
    return lerpColor3(colors[(idx % 3) + 1], colors[((idx + 1) % 3) + 1], frac)
end

local function updateArrestRange()
    local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
    if not root then
        for i = 1, AR_SEG do arLines[i].Visible = false; arTris[i].Visible = false end
        return
    end

    local rootPos = root.Position - Vector3.new(0, root.Size.Y / 2 + 0.1, 0)
    local cam = Camera

    local showOutline = Toggles.ArrestAuraRange.Value and Toggles.ArrestAura.Value
    local showFill = Toggles.ArrestAuraFill.Value and showOutline
    local thick = Options.ArrestAuraThickness.Value
    local c1, c2, c3 = Options.ArrestAuraColor1.Value, Options.ArrestAuraColor2.Value, Options.ArrestAuraColor3.Value
    local fc1, fc2, fc3 = Options.ArrestAuraFillColor1.Value, Options.ArrestAuraFillColor2.Value, Options.ArrestAuraFillColor3.Value
    local fillAlpha = 1 - Options.ArrestAuraFillDensity.Value

    local projected = {}
    for i = 1, AR_SEG do
        local angle = (i - 1) / AR_SEG * math.pi * 2
        local worldPt = rootPos + Vector3.new(math.cos(angle) * ARREST_RANGE, 0, math.sin(angle) * ARREST_RANGE)
        local screenPt = cam:WorldToViewportPoint(worldPt)
        projected[i] = Vector2.new(screenPt.X, screenPt.Y)
    end

    local center2D, centerVis = cam:WorldToViewportPoint(rootPos)
    if not centerVis then
        for i = 1, AR_SEG do arLines[i].Visible = false; arTris[i].Visible = false end
        return
    end

    local center = Vector2.new(center2D.X, center2D.Y)

    for i = 1, AR_SEG do
        local j = (i % AR_SEG) + 1

        local line = arLines[i]
        line.From = projected[i]
        line.To = projected[j]
        line.Color = getARSegColor(i, c1, c2, c3)
        line.Thickness = thick
        line.Visible = showOutline

        local tri = arTris[i]
        tri.PointA = center
        tri.PointB = projected[i]
        tri.PointC = projected[j]
        tri.Color = getARFillSegColor(i, fc1, fc2, fc3)
        tri.Transparency = fillAlpha
        tri.Visible = showFill
    end
end

Toggles.ArrestAura:OnChanged(function()
    if Toggles.ArrestAura.Value then
        if arrestConn then return end
        arrestConn = RunService.RenderStepped:Connect(function()
            if tick() - lastArrestTime < 7 then return end
            local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
            if not root then return end
    local rootPos = root.Position - Vector3.new(0, root.Size.Y / 2 + 0.05, 0)
            local bestTarget, bestDist = nil, ARREST_RANGE
            for _, player in Players:GetPlayers() do
                if player == LP then continue end
                if not isArrestable(player) then continue end
                local char = player.Character
                local hrp = char and char:FindFirstChild('HumanoidRootPart')
                if hrp then
                    local dist = (hrp.Position - rootPos).Magnitude
                    if dist <= bestDist then
                        bestDist = dist
                        bestTarget = player
                    end
                end
            end
            if bestTarget then
                local ok = pcall(function()
                    return ArrestPlayer:InvokeServer(bestTarget, 1)
                end)
                if ok then
                    lastArrestTime = tick()
                end
            end
        end)
    else
        if arrestConn then
            arrestConn:Disconnect()
            arrestConn = nil
        end
        for i = 1, AR_SEG do arLines[i].Visible = false; arTris[i].Visible = false end
    end
end)

-- Target validation & finder
local function IsValidTarget(player)
    if player == LP then return false end
    local pTeam = player.Team
    if pTeam == LP.Team then return false end
    local char = player.Character
    if not char then return false end
    if char:FindFirstChildOfClass('ForceField') then return false end
    if Toggles.SilentAimTeamCheck.Value then
        if LP.Team == Teams.Guards and pTeam == Teams.Inmates and not char:GetAttribute('Hostile') then
            return false
        end
        if LP.Team == Teams.Criminals and pTeam == Teams.Inmates and (Toggles.RageBotTargetInmatesAsCrim and not Toggles.RageBotTargetInmatesAsCrim.Value) then
            return false
        end
    end
    local hum = char:FindFirstChild('Humanoid')
    if not hum or hum.Health <= 0 then return false end
    return true
end

-- Vehicle & Penetration System
local wallParams = RaycastParams.new()
wallParams.FilterType = Enum.RaycastFilterType.Exclude

local function isVehiclePart(part)
    if not part then return false end
    local carContainer = Workspace:FindFirstChild('CarContainer')
    if carContainer and part:IsDescendantOf(carContainer) then
        return true
    end
    if part.CollisionGroup == 'Vehicles' or part.CollisionGroup == 'Wheels' then
        return true
    end
    local model = part:FindFirstAncestorOfClass('Model')
    if model and (CollectionService:HasTag(model, 'Vehicle') or model.Name == 'Squad') then
        return true
    end
    return false
end

local function isPenetrableVehiclePart(part, mode)
    if not isVehiclePart(part) then return false end
    if mode == 'All Car Parts' then return true end

    -- Mode 'Windows & Non-Solid':
    -- 1. Non-collidable parts (seats, interior, open cabin, sirens, decorations)
    if not part.CanCollide then return true end

    -- 2. Transparent parts (windows, windshield, rear glass)
    if part.Transparency > 0.1 then return true end

    -- 3. Seats & VehicleSeats
    if part:IsA('Seat') or part:IsA('VehicleSeat') then return true end

    -- 4. Glass material
    if part.Material == Enum.Material.Glass then return true end

    -- 5. Window / glass / windshield naming
    local name = part.Name:lower()
    if name:find('window') or name:find('glass') or name:find('windshield') or name:find('screen') then
        return true
    end

    return false
end

local function getNetworkPingSeconds()
    local ping = 0.07
    pcall(function()
        if LP.GetNetworkPing then
            local p = LP:GetNetworkPing()
            if p and p > 0 then
                ping = p
                return
            end
        end
        local stats = game:GetService('Stats')
        local item = stats and stats.Network and stats.Network.ServerStatsItem and stats.Network.ServerStatsItem['Data Ping']
        if item then
            ping = item:GetValue() / 1000
        end
    end)
    return math.clamp(ping, 0.02, 0.35)
end

local function getLagCompensatedOrigin()
    local char = LP.Character
    if not char then return Vector3.zero end
    local head = char:FindFirstChild('Head')
    local root = char:FindFirstChild('HumanoidRootPart')
    if not head and not root then return Vector3.zero end

    local basePos = head and head.Position or (root.Position + Vector3.new(0, 1.5, 0))
    if not root then return basePos end

    local vel = root.AssemblyLinearVelocity
    if vel.Magnitude < 2 then
        return basePos
    end

    local ping = getNetworkPingSeconds()
    -- Physics replication delay: half round-trip time + Roblox replication interpolation buffer (~35ms)
    local delay = (ping * 0.5) + 0.035
    local predictedServerPos = basePos - (vel * delay)

    -- Ensure predicted origin doesn't clip behind a solid wall
    local displacement = predictedServerPos - basePos
    if displacement.Magnitude > 0.1 then
        local exclude = { char }
        local _, myVeh = isInVehicle(LP)
        if myVeh then table.insert(exclude, myVeh) end
        wallParams.FilterDescendantsInstances = exclude
        local rayCheck = Workspace:Raycast(basePos, displacement, wallParams)
        if rayCheck then
            predictedServerPos = rayCheck.Position - displacement.Unit * 0.2
        end
    end

    return predictedServerPos
end

local function hasLineOfSight(from, to, targetPlayer)
    local targetChar = targetPlayer and targetPlayer.Character
    local targetInVeh, targetVeh = targetPlayer and isInVehicle(targetPlayer)
    local myInVeh, myVeh = isInVehicle(LP)

    local shootThroughCars = (Toggles.RageBotShootThroughCars == nil) or Toggles.RageBotShootThroughCars.Value
    local penMode = (Options.RageBotCarPenetration and Options.RageBotCarPenetration.Value) or 'Windows & Non-Solid'

    local excludeList = { LP.Character }
    if myVeh then
        table.insert(excludeList, myVeh)
    end
    if shootThroughCars and targetInVeh and targetVeh then
        table.insert(excludeList, targetVeh)
    end
    if targetChar and Toggles.ShieldBypass and Toggles.ShieldBypass.Value and (Toggles.ShieldBypassRiot == nil or Toggles.ShieldBypassRiot.Value) then
        local rsp = targetChar:FindFirstChild('RiotShieldPart')
        if rsp then table.insert(excludeList, rsp) end
        for _, item in ipairs(targetChar:GetChildren()) do
            if item:IsA('Tool') and string.find(string.lower(item.Name), 'shield') then
                table.insert(excludeList, item)
            end
        end
    end

    local pierces = 0
    local maxPierces = 10

    while pierces < maxPierces do
        local dir = to - from
        local dist = dir.Magnitude
        if dist < 0.2 then
            return true
        end

        wallParams.FilterDescendantsInstances = excludeList
        local result = Workspace:Raycast(from, dir, wallParams)
        if not result then
            return true
        end

        local hitPart = result.Instance

        -- Hit target character directly
        if targetChar and hitPart:IsDescendantOf(targetChar) then
            return true
        end

        -- Check if hit close to target and hit a player character
        local hitDist = (result.Position - to).Magnitude
        if hitDist < 3.5 then
            for _, p in Players:GetPlayers() do
                if p.Character and hitPart:IsDescendantOf(p.Character) then
                    if not targetPlayer or p == targetPlayer then
                        return true
                    end
                end
            end
        end

        -- Check if hit vehicle part that can be penetrated
        if shootThroughCars and isPenetrableVehiclePart(hitPart, penMode) then
            table.insert(excludeList, hitPart)
            if penMode == 'All Car Parts' then
                local vehicleModel = hitPart:FindFirstAncestorOfClass('Model')
                if vehicleModel and (vehicleModel.Name == 'Squad' or vehicleModel:IsDescendantOf(Workspace:FindFirstChild('CarContainer') or Workspace)) then
                    table.insert(excludeList, vehicleModel)
                end
            end
            pierces = pierces + 1
        else
            -- Hit an impenetrable obstacle (wall, terrain, or solid car part in strict mode)
            return false
        end
    end

    return false
end

local detectedCheaters = setmetatable({}, { __mode = 'k' })

local function FindNearestTarget()
    if not Toggles.SilentAim.Value and not Toggles.RageBot.Value and not (Toggles.TargetESP and Toggles.TargetESP.Value) then return nil end
    local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
    if not root then return nil end

    local bestFOV = Options.FOVRadius.Value
    local bestPart = nil
    local aimPartName = Options.AimPart.Value
    local mousePos = UserInputService:GetMouseLocation()
    local rootPos = root.Position

    local tool = LP.Character and LP.Character:FindFirstChildOfClass('Tool')
    local maxDist = (Toggles.RageBot.Value and tool and tool:GetAttribute('Range')) or Options.MaxDistance.Value

    local prioritizeCheaters = Toggles.RageBotPrioritizeCheaters and Toggles.RageBotPrioritizeCheaters.Value
    local bestCheaterPart, bestCheaterMetric = nil, math.huge

    for _, player in Players:GetPlayers() do
        if IsValidTarget(player) then
            local char = player.Character
            local inVeh = isInVehicle(player)
            local part = (inVeh and (char:FindFirstChild('Head') or char:FindFirstChild('HumanoidRootPart')))
                or char:FindFirstChild(aimPartName)
                or char:FindFirstChild('HumanoidRootPart')
            if part then
                local dist = (part.Position - rootPos).Magnitude
                if dist > maxDist then continue end
                if Toggles.SilentAimVisibleCheck.Value then
                    if not hasLineOfSight(Camera.CFrame.Position, part.Position, player) then
                        continue
                    end
                end
                local isCheater = prioritizeCheaters and (detectedCheaters[player] ~= nil)
                if Toggles.SilentAim360.Value or Toggles.RageBot.Value then
                    if isCheater and dist < bestCheaterMetric then
                        bestCheaterMetric = dist
                        bestCheaterPart = part
                    end
                    if dist < bestFOV then
                        bestFOV = dist
                        bestPart = part
                    end
                else
                    local sp, onScreen = Camera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local fov = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
                        if isCheater and fov < bestCheaterMetric then
                            bestCheaterMetric = fov
                            bestCheaterPart = part
                        end
                        if fov < bestFOV then
                            bestFOV = fov
                            bestPart = part
                        end
                    end
                end
            end
        end
    end
    if bestCheaterPart then
        return bestCheaterPart
    end
    return bestPart
end

-- ====================== HVH RESOLVER ENGINE ======================
local resolveTarget = nil

do
    local resolverData = setmetatable({}, { __mode = 'k' })

    -- Background tracker for players (velocity derivation & spin/jitter detection)
    RunService.Heartbeat:Connect(function()
        if not (Toggles.Resolver and Toggles.Resolver.Value) then return end
        local now = tick()
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Parent == Players then
                local char = p.Character
                local hrp = char and char:FindFirstChild('HumanoidRootPart')
                local head = char and char:FindFirstChild('Head')

                if hrp and head and isAlive(p) then
                    local hrpPos = hrp.Position
                    local headPos = head.Position

                    local data = resolverData[p]
                    if not data or data.char ~= char then
                        data = {
                            char = char,
                            lastPos = hrpPos,
                            lastTick = now,
                            derivedVel = Vector3.zero,
                            lastHeadRel = Vector2.new(headPos.X - hrpPos.X, headPos.Z - hrpPos.Z),
                            lastAngle = math.atan2(headPos.Z - hrpPos.Z, headPos.X - hrpPos.X),
                            angularVelocity = 0,
                            isSpinbot = false,
                            isDesync = false,
                            missCount = 0,
                            hitCount = 0,
                            stage = 1,
                            lastShotTick = 0,
                            pendingHit = false,
                            statusText = 'Tracking',
                        }
                        resolverData[p] = data
                    else
                        local dt = now - data.lastTick
                        if dt >= 0.015 and dt <= 0.25 then
                            -- 1. True velocity derivation
                            local delta = hrpPos - data.lastPos
                            local instVel = delta / dt
                            data.derivedVel = data.derivedVel:Lerp(instVel, 0.4)

                            -- 2. Spinbot & Jitter Anti-Aim Detection
                            local headRel = Vector2.new(headPos.X - hrpPos.X, headPos.Z - hrpPos.Z)
                            local curAngle = math.atan2(headRel.Y, headRel.X)
                            local deltaAngle = curAngle - data.lastAngle
                            while deltaAngle > math.pi do deltaAngle = deltaAngle - (math.pi * 2) end
                            while deltaAngle < -math.pi do deltaAngle = deltaAngle + (math.pi * 2) end

                            local angSpeed = math.abs(deltaAngle) / dt
                            data.angularVelocity = (data.angularVelocity * 0.7) + (angSpeed * 0.3)

                            -- Over 3.5 rad/s indicates artificial spinbot/anti-aim
                            if data.angularVelocity > 3.5 then
                                data.isSpinbot = true
                            elseif data.angularVelocity < 1.0 then
                                data.isSpinbot = false
                            end

                            -- 3. CFrame / Void Desync check
                            local isUnderground = hrpPos.Y < -40
                            local isCheater = detectedCheaters and (detectedCheaters[p] ~= nil)
                            data.isDesync = isUnderground or isCheater

                            data.lastAngle = curAngle
                            data.lastHeadRel = headRel
                            data.lastPos = hrpPos
                            data.lastTick = now

                            -- 4. Check pending miss timeout (no hit registered after 0.35s)
                            if data.pendingHit and (now - data.lastShotTick) > 0.35 then
                                data.pendingHit = false
                                data.missCount = data.missCount + 1
                                data.stage = (data.stage % 4) + 1
                                data.statusText = string.format('Bruteforce [Stage %d]', data.stage)
                            end
                        end
                    end
                end
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(p)
        resolverData[p] = nil
    end)

    -- Hook confirmed hits from damage/hitmarkers to reward successful stage
    _G.BoarsResolverConfirmHit = function(targetPlayer)
        if targetPlayer and resolverData[targetPlayer] then
            local data = resolverData[targetPlayer]
            data.pendingHit = false
            data.hitCount = data.hitCount + 1
            data.missCount = 0
            data.statusText = 'Resolved [Hit Confirmed]'
        end
    end

    resolveTarget = function(targetPlayer, targetPart, origin)
        if not (Toggles.Resolver and Toggles.Resolver.Value) then
            return targetPart.Position, targetPart
        end
        if not targetPlayer or not targetPlayer.Character or not targetPart then
            return targetPart and targetPart.Position or Vector3.zero, targetPart
        end

        local char = targetPlayer.Character
        local hrp = char:FindFirstChild('HumanoidRootPart')
        local head = char:FindFirstChild('Head')
        if not hrp then
            return targetPart.Position, targetPart
        end

        local data = resolverData[targetPlayer]
        if data then
            data.pendingHit = true
            data.lastShotTick = tick()
        end

        local mode = Options.ResolverMode and Options.ResolverMode.Value or 'Adaptive Auto'
        local ping = 0.05
        pcall(function()
            local pingVal = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
            if pingVal and pingVal > 0 then
                ping = math.clamp(pingVal / 1000, 0.02, 0.3)
            end
        end)

        local resolvedPos = targetPart.Position
        local resolvedPart = targetPart

        local isSpin = data and (data.isSpinbot or data.angularVelocity > 3.0)

        -- 1. Axis Pivot Resolution (Anti-Spinbot)
        if mode == 'Axis Pivot (Anti-Spin)' or (mode == 'Adaptive Auto' and isSpin and (data and data.missCount or 0) == 0) then
            if targetPart.Name == 'Head' and hrp then
                resolvedPos = Vector3.new(hrp.Position.X, head and head.Position.Y or (hrp.Position.Y + 1.5), hrp.Position.Z)
                resolvedPart = targetPart
                if data then data.statusText = 'Resolved [Axis Pivot]' end
            else
                resolvedPos = hrp.Position
                resolvedPart = hrp
                if data then data.statusText = 'Resolved [Center Mass]' end
            end

        -- 2. Velocity Prediction Resolution
        elseif mode == 'Velocity Prediction' then
            local vel = (data and data.derivedVel) or (hrp.AssemblyLinearVelocity or hrp.Velocity)
            if vel.Magnitude < 200 then
                resolvedPos = targetPart.Position + (vel * (ping + 0.03))
                resolvedPart = targetPart
                if data then data.statusText = 'Resolved [Velocity Extrapolate]' end
            end

        -- 3. Bruteforce / Adaptive Cycle Resolution
        else
            local stage = (data and data.stage) or 1
            local missCount = (data and data.missCount) or 0

            if missCount > 0 or mode == 'Bruteforce' then
                if stage == 1 then
                    -- Stage 1: Absolute Center Mass (HRP)
                    resolvedPos = hrp.Position
                    resolvedPart = hrp
                    if data then data.statusText = 'Resolved [Bruteforce HRP]' end
                elseif stage == 2 then
                    -- Stage 2: Head Axis Alignment
                    resolvedPos = Vector3.new(hrp.Position.X, head and head.Position.Y or (hrp.Position.Y + 1.5), hrp.Position.Z)
                    resolvedPart = head or hrp
                    if data then data.statusText = 'Resolved [Bruteforce Axis]' end
                elseif stage == 3 then
                    -- Stage 3: Inverted Yaw Projection (Anti-Backward / Anti-Fake)
                    if head then
                        local offset = head.Position - hrp.Position
                        resolvedPos = hrp.Position - Vector3.new(offset.X, -offset.Y, offset.Z)
                        resolvedPart = head
                    else
                        resolvedPos = hrp.Position
                        resolvedPart = hrp
                    end
                    if data then data.statusText = 'Resolved [Inverted Yaw]' end
                elseif stage == 4 then
                    -- Stage 4: Velocity Lead Clamped
                    local vel = (data and data.derivedVel) or Vector3.zero
                    resolvedPos = targetPart.Position + (vel * ping)
                    resolvedPart = targetPart
                    if data then data.statusText = 'Resolved [Lead Extrapolate]' end
                end
            else
                -- Zero misses: smart default
                if isSpin then
                    resolvedPos = Vector3.new(hrp.Position.X, head and head.Position.Y or (hrp.Position.Y + 1.5), hrp.Position.Z)
                    resolvedPart = head or targetPart
                    if data then data.statusText = 'Resolved [Anti-Spin]' end
                elseif data and data.derivedVel.Magnitude > 12 then
                    resolvedPos = targetPart.Position + (data.derivedVel * (ping + 0.02))
                    resolvedPart = targetPart
                    if data then data.statusText = 'Resolved [Tracking]' end
                else
                    resolvedPos = targetPart.Position
                    resolvedPart = targetPart
                end
            end
        end

        -- Line-of-sight safety check on resolved position
        if not hasLineOfSight(origin, resolvedPos, targetPlayer) then
            resolvedPos = targetPart.Position
            resolvedPart = targetPart
        end

        if data and Toggles.ResolverLog and Toggles.ResolverLog.Value then
            if (data.isSpinbot or (data.missCount or 0) > 0) and (tick() - (data.lastNotify or 0)) > 6 then
                data.lastNotify = tick()
                pcall(function()
                    Library:Notify(string.format('[RESOLVER] %s -> %s', targetPlayer.DisplayName or targetPlayer.Name, data.statusText), 3)
                end)
            end
        end

        return resolvedPos, resolvedPart
    end
end

-- Custom Crosshair
local crosshairLines = {}
local crosshairAngles = { -90, 0, 90, 180 }
local CrosshairGui = LP.PlayerGui:WaitForChild("CrosshairGui")
local ScopeFrame = CrosshairGui.ScopeFrame
local DefaultCursor = ScopeFrame.Cursor
local hasGun = false

for i = 1, 4 do
    local l = Drawing.new('Line')
    l.Visible = false
    l.Thickness = 2
    l.ZIndex = 20
    crosshairLines[i] = l
end

local crosshairDot = Drawing.new('Circle')
crosshairDot.Filled = true
crosshairDot.Visible = false
crosshairDot.Radius = 2
crosshairDot.NumSides = 16
crosshairDot.ZIndex = 21

local crosshairRing = Drawing.new('Circle')
crosshairRing.Filled = false
crosshairRing.Visible = false
crosshairRing.Radius = 20
crosshairRing.Thickness = 1
crosshairRing.NumSides = 48
crosshairRing.Transparency = 0.4
crosshairRing.ZIndex = 19

local function updateCrosshair()
    local center = UserInputService:GetMouseLocation()
    local rot = math.rad(Options.CrosshairRotation.Value)
    local gap = Options.CrosshairGap.Value
    local len = Options.CrosshairLength.Value
    local thick = Options.CrosshairThickness.Value
    local vis = Toggles.CustomCrosshair.Value

    for i = 1, 4 do
        local angle = math.rad(crosshairAngles[i]) + rot
        local dx, dy = math.cos(angle), math.sin(angle)
        local line = crosshairLines[i]
        line.From = center + Vector2.new(dx, dy) * gap
        line.To = center + Vector2.new(dx, dy) * (gap + len)
        line.Color = Options['CH' .. i .. 'Color'].Value
        line.Thickness = thick
        line.Visible = vis
    end

    crosshairDot.Position = center
    crosshairDot.Color = Options.CH1Color.Value
    crosshairDot.Radius = math.clamp(thick * 0.7, 1, 4)
    crosshairDot.Visible = vis

    crosshairRing.Position = center
    crosshairRing.Radius = gap + len * 0.5
    crosshairRing.Color = Options.CH1Color.Value
    crosshairRing.Visible = vis
end

local function hideCrosshair()
    for i = 1, 4 do
        crosshairLines[i].Visible = false
    end
    crosshairDot.Visible = false
    crosshairRing.Visible = false
end

local function killDefaultCrosshair()
    pcall(function()
        ScopeFrame.Visible = false
        ScopeFrame.Size = UDim2.new(0, 0, 0, 0)
        DefaultCursor.Visible = false
        DefaultCursor.Size = UDim2.new(0, 0, 0, 0)
        for _, v in ScopeFrame:GetDescendants() do
            if v:IsA("GuiObject") then
                v.Visible = false
                v.Size = UDim2.new(0, 0, 0, 0)
            elseif v:IsA("ImageLabel") or v:IsA("Image") then
                v.Visible = false
            end
        end
    end)
end

local function onGunEquipped(tool)
    if not tool or not tool:IsA("Tool") then return end
    if tool:GetAttribute("ToolType") ~= "Gun" then
        hasGun = false
        if Toggles.CustomCrosshair.Value then hideCrosshair() end
        return
    end
    hasGun = true
end

local function onGunRemoved()
    hasGun = false
    if Toggles.CustomCrosshair.Value then hideCrosshair() end
end

local function hookCharacter(char)
    if not char then return end
    char.ChildAdded:Connect(function(child)
        if Toggles.CustomCrosshair.Value then onGunEquipped(child) end
    end)
    char.ChildRemoved:Connect(function(child)
        if Toggles.CustomCrosshair.Value then onGunRemoved() end
    end)
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and Toggles.CustomCrosshair.Value then onGunEquipped(tool) end
end

if LP.Character then hookCharacter(LP.Character) end
LP.CharacterAdded:Connect(hookCharacter)

ScopeFrame:GetPropertyChangedSignal("Visible"):Connect(function()
    if Toggles.CustomCrosshair.Value then killDefaultCrosshair() end
end)
DefaultCursor:GetPropertyChangedSignal("Visible"):Connect(function()
    if Toggles.CustomCrosshair.Value then killDefaultCrosshair() end
end)
ScopeFrame.DescendantAdded:Connect(function()
    if Toggles.CustomCrosshair.Value then killDefaultCrosshair() end
end)

Toggles.CustomCrosshair:OnChanged(function()
    if Toggles.CustomCrosshair.Value then
        UserInputService.MouseIconEnabled = false
        killDefaultCrosshair()
    else
        hideCrosshair()
        if _G.BoarsCleanupInvisibleAndSit then pcall(_G.BoarsCleanupInvisibleAndSit) end
    UserInputService.MouseIconEnabled = true
    end
end)

-- FOV Circle (3-color segmented outline + fill)
local FOV_SEG = 72
local fovLines = {}
local fovTris = {}
local fovRotOffset = 0

for i = 1, FOV_SEG do
    local l = Drawing.new('Line')
    l.Visible = false
    l.Thickness = Options.FOVThickness.Value
    l.ZIndex = 10
    fovLines[i] = l

    local t = Drawing.new('Triangle')
    t.Visible = false
    t.Filled = true
    t.ZIndex = 5
    fovTris[i] = t
end

local function lerpColor3(a, b, t)
    return Color3.new(
        a.R + (b.R - a.R) * t,
        a.G + (b.G - a.G) * t,
        a.B + (b.B - a.B) * t
    )
end

local function smoothstep(t)
    t = math.clamp(t, 0, 1)
    return t * t * (3 - 2 * t)
end

local function getSegmentColor(i, c1, c2, c3)
    local p = (i - 1) / FOV_SEG
    local scaled = p * 3
    local idx = math.floor(scaled)
    local frac = smoothstep(scaled - idx)
    local colors = {c1, c2, c3}
    return lerpColor3(colors[(idx % 3) + 1], colors[((idx + 1) % 3) + 1], frac)
end

local function getFillSegmentColor(i, c1, c2, c3)
    local p = (i - 0.5) / FOV_SEG
    local scaled = p * 3
    local idx = math.floor(scaled)
    local frac = smoothstep(scaled - idx)
    local colors = {c1, c2, c3}
    return lerpColor3(colors[(idx % 3) + 1], colors[((idx + 1) % 3) + 1], frac)
end

local function updateFOVCircle()
    local mousePos = UserInputService:GetMouseLocation()
    local radius = Options.FOVRadius.Value
    local thick = Options.FOVThickness.Value
    local c1, c2, c3 = Options.FOVColor1.Value, Options.FOVColor2.Value, Options.FOVColor3.Value
    local fc1, fc2, fc3 = Options.FOVFillColor1.Value, Options.FOVFillColor2.Value, Options.FOVFillColor3.Value
    local fillAlpha = 1 - Options.FOVFillDensity.Value
    local showOutline = Toggles.FOVCircle.Value
    local showFill = Toggles.FOVFill.Value and showOutline

    for i = 1, FOV_SEG do
        local a1 = (i - 1) / FOV_SEG * math.pi * 2 + fovRotOffset
        local a2 = i / FOV_SEG * math.pi * 2 + fovRotOffset
        local p1 = mousePos + Vector2.new(math.cos(a1), math.sin(a1)) * radius
        local p2 = mousePos + Vector2.new(math.cos(a2), math.sin(a2)) * radius

        local line = fovLines[i]
        line.From = p1
        line.To = p2
        line.Color = getSegmentColor(i, c1, c2, c3)
        line.Thickness = thick
        line.Visible = showOutline

        local tri = fovTris[i]
        tri.PointA = mousePos
        tri.PointB = p1
        tri.PointC = p2
        tri.Color = getFillSegmentColor(i, fc1, fc2, fc3)
        tri.Transparency = fillAlpha
        tri.Visible = showFill
    end
end

local function hideFOVCircle()
    for i = 1, FOV_SEG do
        fovLines[i].Visible = false
        fovTris[i].Visible = false
    end
end

Toggles.FOVCircle:OnChanged(function()
    if not Toggles.FOVCircle.Value then hideFOVCircle() end
end)
Toggles.FOVFill:OnChanged(function()
    if not Toggles.FOVFill.Value then
        for i = 1, FOV_SEG do fovTris[i].Visible = false end
    end
end)

local targetPartCache = nil
local rageTargetPart = nil

-- ====================== TARGET ESP SYSTEM (MINECRAFT STYLE) ======================
local function getCustomOrLocal(name, absPath, fallback)
    local result = nil
    if getcustomasset then
        pcall(function()
            if isfile and isfile(name) then
                result = getcustomasset(name)
            elseif absPath and isfile and isfile(absPath) then
                result = getcustomasset(absPath)
            end
        end)
    elseif getsynasset then
        pcall(function()
            if isfile and isfile(name) then
                result = getsynasset(name)
            end
        end)
    end
    return result or fallback
end

pcall(function()
    if isfile and not isfile('skull.png') and isfile('C:\\Users\\kapca\\Downloads\\skull.png') then
        writefile('skull.png', readfile('C:\\Users\\kapca\\Downloads\\skull.png'))
    end
    if isfile and not isfile('target.png') and isfile('C:\\Users\\kapca\\Downloads\\target.png') then
        writefile('target.png', readfile('C:\\Users\\kapca\\Downloads\\target.png'))
    end
end)

local skullAsset = getCustomOrLocal('skull.png', 'C:\\Users\\kapca\\Downloads\\skull.png', 'rbxasset://textures/ui/ErrorIcon.png')
local targetAsset = getCustomOrLocal('target.png', 'C:\\Users\\kapca\\Downloads\\target.png', 'rbxasset://textures/ui/VR/circleWhite.png')
local glowAsset = 'rbxasset://textures/glow.png'

local targetEspGui = Instance.new('ScreenGui')
targetEspGui.Name = 'BoarsTargetESP'
targetEspGui.ResetOnSpawn = false
targetEspGui.IgnoreGuiInset = true
targetEspGui.DisplayOrder = 9999

if gethui then
    targetEspGui.Parent = gethui()
elseif game:GetService('CoreGui'):FindFirstChild('RobloxGui') then
    targetEspGui.Parent = game:GetService('CoreGui')
else
    targetEspGui.Parent = LP:WaitForChild('PlayerGui')
end

-- Client mode image (target.png)
local targetClientImg = Instance.new('ImageLabel')
targetClientImg.Name = 'TargetClient'
targetClientImg.BackgroundTransparency = 1
targetClientImg.BorderSizePixel = 0
targetClientImg.AnchorPoint = Vector2.new(0.5, 0.5)
targetClientImg.Image = targetAsset
targetClientImg.Visible = false
targetClientImg.ZIndex = 50
targetClientImg.Parent = targetEspGui

-- Wexside mode image (skull.png)
local targetSkullImg = Instance.new('ImageLabel')
targetSkullImg.Name = 'TargetSkull'
targetSkullImg.BackgroundTransparency = 1
targetSkullImg.BorderSizePixel = 0
targetSkullImg.AnchorPoint = Vector2.new(0.5, 0.5)
targetSkullImg.Image = skullAsset
targetSkullImg.Visible = false
targetSkullImg.ZIndex = 50
targetSkullImg.Parent = targetEspGui

-- Ghosts mode labels pool (40 upper, 40 lower)
local GHOST_COUNT = 40
local ghostsUpper = {}
local ghostsLower = {}

for j = 1, GHOST_COUNT do
    local imgU = Instance.new('ImageLabel')
    imgU.Name = 'GhostUpper_' .. j
    imgU.BackgroundTransparency = 1
    imgU.BorderSizePixel = 0
    imgU.AnchorPoint = Vector2.new(0.5, 0.5)
    imgU.Image = glowAsset
    imgU.Visible = false
    imgU.ZIndex = 48
    imgU.Parent = targetEspGui
    table.insert(ghostsUpper, imgU)

    local imgL = Instance.new('ImageLabel')
    imgL.Name = 'GhostLower_' .. j
    imgL.BackgroundTransparency = 1
    imgL.BorderSizePixel = 0
    imgL.AnchorPoint = Vector2.new(0.5, 0.5)
    imgL.Image = glowAsset
    imgL.Visible = false
    imgL.ZIndex = 48
    imgL.Parent = targetEspGui
    table.insert(ghostsLower, imgL)
end

local function hideAllTargetESP()
    targetClientImg.Visible = false
    targetSkullImg.Visible = false
    for j = 1, GHOST_COUNT do
        ghostsUpper[j].Visible = false
        ghostsLower[j].Visible = false
    end
end

local function updateTargetESP(dt)
    if not Toggles.TargetESP or not Toggles.TargetESP.Value then
        hideAllTargetESP()
        return
    end

    local targetPart = (Toggles.RageBot and Toggles.RageBot.Value and rageTargetPart and rageTargetPart.Parent and rageTargetPart)
        or (targetPartCache and targetPartCache.Parent and targetPartCache)

    if not targetPart then
        hideAllTargetESP()
        return
    end

    local targetChar = targetPart.Parent
    if not targetChar then
        hideAllTargetESP()
        return
    end
    local targetHum = targetChar:FindFirstChildOfClass('Humanoid')
    if targetHum and targetHum.Health <= 0 then
        hideAllTargetESP()
        return
    end

    local rootPart = targetChar:FindFirstChild('HumanoidRootPart') or targetPart
    local targetCenterPos = rootPart.Position

    if Toggles.TargetESPVisibleCheck and Toggles.TargetESPVisibleCheck.Value then
        local tPlayer = Players:GetPlayerFromCharacter(targetChar)
        if not hasLineOfSight(Camera.CFrame.Position, targetCenterPos, tPlayer) then
            hideAllTargetESP()
            return
        end
    end

    local mode = Options.TargetESPMode and Options.TargetESPMode.Value or 'Client'
    local speed = Options.TargetESPSpeed and Options.TargetESPSpeed.Value or 3.0
    local baseSize = Options.TargetESPSize and Options.TargetESPSize.Value or 70
    local brightness = Options.TargetESPBrightness and Options.TargetESPBrightness.Value or 255
    local isRainbow = Toggles.TargetESPRainbow and Toggles.TargetESPRainbow.Value
    local baseCol = isRainbow and Color3.fromHSV((tick() * 0.5) % 1, 0.8, 1)
        or (Options.TargetESPColor and Options.TargetESPColor.Value or Color3.fromRGB(255, 255, 255))

    if mode == 'Client' then
        targetSkullImg.Visible = false
        for j = 1, GHOST_COUNT do
            ghostsUpper[j].Visible = false
            ghostsLower[j].Visible = false
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(targetCenterPos)
        if onScreen then
            local rotAngle = (math.sin(tick() * speed) * 360) % 360
            targetClientImg.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
            targetClientImg.Size = UDim2.new(0, baseSize, 0, baseSize)
            targetClientImg.Rotation = rotAngle
            targetClientImg.ImageColor3 = baseCol
            targetClientImg.ImageTransparency = 1 - (brightness / 255)
            targetClientImg.Visible = true
        else
            targetClientImg.Visible = false
        end

    elseif mode == 'Wexside' then
        targetClientImg.Visible = false
        for j = 1, GHOST_COUNT do
            ghostsUpper[j].Visible = false
            ghostsLower[j].Visible = false
        end

        local screenPos, onScreen = Camera:WorldToViewportPoint(targetCenterPos)
        if onScreen then
            targetSkullImg.Position = UDim2.new(0, screenPos.X, 0, screenPos.Y)
            targetSkullImg.Size = UDim2.new(0, baseSize, 0, baseSize)
            targetSkullImg.Rotation = 0
            targetSkullImg.ImageColor3 = baseCol
            local alpha = (brightness / 255) * (150 / 255)
            targetSkullImg.ImageTransparency = 1 - alpha
            targetSkullImg.Visible = true
        else
            targetSkullImg.Visible = false
        end

    elseif mode == 'Призраки' then
        targetClientImg.Visible = false
        targetSkullImg.Visible = false

        local bodyPos = rootPart.Position + Vector3.new(0, 0.8, 0)
        local legPos = rootPart.Position - Vector3.new(0, 1.2, 0)
        local time = tick() * (speed * 2.5)
        local orbitRadius = 1.8

        for j = 0, GHOST_COUNT - 1 do
            local idx = j + 1
            local alpha = math.clamp((brightness - j * 5) / 255, 0, 1)
            if alpha <= 0.01 then
                ghostsUpper[idx].Visible = false
                ghostsLower[idx].Visible = false
            else
                local trailSize = math.max(4, baseSize * (1.0 - j * 0.02))
                local trailTime = time - j * 0.09
                local trailSin = math.sin(trailTime)
                local trailCos = math.cos(trailTime)
                local angleOffset = j * 7.2

                local col = isRainbow and Color3.fromHSV((tick() * 0.5 + j * 0.02) % 1, 0.85, 1) or baseCol

                -- Upper ghost
                local posUpper = bodyPos + Vector3.new(trailCos * orbitRadius, trailSin * 0.35, trailSin * orbitRadius)
                local spU, onScreenU = Camera:WorldToViewportPoint(posUpper)
                if onScreenU then
                    local gu = ghostsUpper[idx]
                    gu.Position = UDim2.new(0, spU.X, 0, spU.Y)
                    gu.Size = UDim2.new(0, trailSize, 0, trailSize)
                    gu.Rotation = (trailSin * 360 + angleOffset) % 360
                    gu.ImageColor3 = col
                    gu.ImageTransparency = 1 - alpha
                    gu.Visible = true
                else
                    ghostsUpper[idx].Visible = false
                end

                -- Lower ghost
                local posLower = legPos + Vector3.new(-trailCos * orbitRadius, trailSin * 0.35, -trailSin * orbitRadius)
                local spL, onScreenL = Camera:WorldToViewportPoint(posLower)
                if onScreenL then
                    local gl = ghostsLower[idx]
                    gl.Position = UDim2.new(0, spL.X, 0, spL.Y)
                    gl.Size = UDim2.new(0, trailSize, 0, trailSize)
                    gl.Rotation = (-trailSin * 360 + angleOffset) % 360
                    gl.ImageColor3 = col
                    gl.ImageTransparency = 1 - alpha
                    gl.Visible = true
                else
                    ghostsLower[idx].Visible = false
                end
            end
        end
    end
end

local rageIndicatorText = Drawing.new('Text')
rageIndicatorText.Size = 16
rageIndicatorText.Color = Color3.new(1, 1, 1)
rageIndicatorText.Center = true
rageIndicatorText.Outline = true
rageIndicatorText.OutlineColor = Color3.new(0, 0, 0)
rageIndicatorText.Font = 2
rageIndicatorText.Position = Vector2.new(0, 0)
rageIndicatorText.Visible = false
rageIndicatorText.ZIndex = 31

RunService.RenderStepped:Connect(function(dt)
    fovRotOffset = fovRotOffset + Options.FOVRotSpeed.Value * dt
    if Toggles.FOVCircle.Value then
        updateFOVCircle()
    end
    if Toggles.CustomCrosshair.Value then
        killDefaultCrosshair()
        if hasGun then
            updateCrosshair()
        end
    end
    if Toggles.ArrestAura.Value then
        updateArrestRange()
    end
    targetPartCache = (Toggles.SilentAim.Value or Toggles.RageBot.Value or (Toggles.TargetESP and Toggles.TargetESP.Value) or (Toggles.TargetHUD and Toggles.TargetHUD.Value)) and FindNearestTarget() or nil
    updateTargetESP(dt)

    if Toggles.RageBot.Value and rageIndicatorText then
        local mousePos = UserInputService:GetMouseLocation()
        rageIndicatorText.Position = Vector2.new(mousePos.X, mousePos.Y + 25)

        local tool = LP.Character and LP.Character:FindFirstChildOfClass('Tool')
        local isGun = tool and (
            tool:GetAttribute('ToolType') == 'Gun'
            or (gunConfigs and gunConfigs[tool.Name])
            or tool:FindFirstChild('Muzzle')
        )
        if tool and isGun then
            local ammo = tool:GetAttribute('Local_CurrentAmmo') or tool:GetAttribute('CurrentAmmo') or 0
            local isReloading = ((tool:GetAttribute('Local_ReloadSession') or 0) > 0) and (ammo <= 0)
            if isReloading then
                rageIndicatorText.Text = tool.Name .. "  Reloading..."
                rageIndicatorText.Color = Color3.fromRGB(255, 200, 50)
            else
                local cfg = gunConfigs and gunConfigs[tool.Name]
                local maxAmmo = tool:GetAttribute('MaxAmmo') or (cfg and cfg.maxAmmo) or 0
                local stored = tool:GetAttribute('StoredAmmo')
                if cfg and cfg.behavior == 'Sniper' and stored then
                    rageIndicatorText.Text = tool.Name .. "  " .. ammo .. " | " .. stored
                else
                    rageIndicatorText.Text = tool.Name .. "  " .. ammo .. " / " .. maxAmmo
                end
                if ammo <= 0 then
                    rageIndicatorText.Color = Color3.fromRGB(255, 70, 70)
                elseif ammo <= maxAmmo * 0.25 then
                    rageIndicatorText.Color = Color3.fromRGB(255, 200, 50)
                else
                    rageIndicatorText.Color = Color3.fromRGB(100, 255, 130)
                end
            end
        elseif tool then
            rageIndicatorText.Text = tool.Name
            rageIndicatorText.Color = Color3.fromRGB(180, 180, 180)
        else
            rageIndicatorText.Text = "No Weapon"
            rageIndicatorText.Color = Color3.fromRGB(120, 120, 120)
        end
    end
end)

-- ====================== PARTICLES SYSTEM (MINECRAFT STYLE) ======================
local spawnAttackParticles
local spawnTotemParticles
local spawnThrowParticles
local cleanupParticles

do
local particleTextures = {
    ['Bloom']   = 'rbxasset://textures/glow.png',
    ['Star']    = 'rbxasset://textures/sparkle.png',
    ['Heart']   = 'rbxasset://textures/ui/Moments/Reactions/heart-large.png',
    ['Dollar']  = 'rbxasset://textures/ui/RobuxIcon.png',
    ['Snow']    = 'rbxasset://textures/ui/VR/circleWhite.png',
    ['Star 2']  = 'rbxasset://textures/ui/PlayerList/StarIcon.png',
    ['Kronex']  = 'rbxasset://textures/ui/icon_placeowner.png',
}
local particleNamesList = { 'Bloom', 'Star', 'Heart', 'Dollar', 'Snow', 'Star 2', 'Kronex' }

local TOTEM_COLOR_GREEN = Color3.fromRGB(127, 221, 144)
local TOTEM_COLOR_YELLOW = Color3.fromRGB(221, 218, 127)

local particlesFolder = Workspace:FindFirstChild('KronexParticles')
if not particlesFolder then
    particlesFolder = Instance.new('Folder')
    particlesFolder.Name = 'KronexParticles'
    particlesFolder.Parent = Workspace
end

local activeParticles = {}
local particlePool = {}
local MAX_PARTICLES = 180

local function isParticleEventEnabled(eventName)
    if not Toggles.Particles or not Toggles.Particles.Value then return false end
    if not Options.ParticleSpawnEvents then return true end
    local val = Options.ParticleSpawnEvents.Value
    if type(val) == 'table' then
        if val[eventName] == true then return true end
        for k, v in pairs(val) do
            if v == eventName or k == eventName then return true end
        end
        local count = 0
        for _ in pairs(val) do count = count + 1 end
        if count == 0 then
            return eventName == 'Attack' or eventName == 'Totem' or eventName == 'Move' or eventName == 'Throw'
        end
        return false
    elseif type(val) == 'string' then
        return val == eventName or val == 'All'
    end
    return true
end

local function getParticleInstance()
    local p = table.remove(particlePool)
    if p and p.Part and p.Part.Parent then
        p.Part.Parent = particlesFolder
        p.Billboard.Enabled = true
        return p
    end

    local part = Instance.new('Part')
    part.Name = 'KParticle'
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Transparency = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.Anchored = true
    part.CastShadow = false

    local bb = Instance.new('BillboardGui')
    bb.Name = 'ParticleGui'
    bb.Size = UDim2.new(2, 0, 2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.ResetOnSpawn = false
    bb.Adornee = part
    bb.Parent = part

    local img = Instance.new('ImageLabel')
    img.Name = 'Icon'
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.ZIndex = 10
    img.Parent = bb

    part.Parent = particlesFolder
    return {
        Part = part,
        Billboard = bb,
        Image = img,
    }
end

local function releaseParticle(p)
    if not p then return end
    if p.Billboard then p.Billboard.Enabled = false end
    if p.Part then p.Part.Parent = nil end
    if #particlePool < MAX_PARTICLES then
        table.insert(particlePool, p)
    else
        if p.Part then p.Part:Destroy() end
    end
end

local function getSelectedParticleTexture(style)
    local mode = style or (Options.ParticleType and Options.ParticleType.Value)
    if not mode or mode == 'Default' then
        mode = Options.ParticleType and Options.ParticleType.Value or 'Bloom'
    end
    if mode == 'Random' then
        local rnd = particleNamesList[math.random(1, #particleNamesList)]
        return particleTextures[rnd] or particleTextures['Bloom']
    end
    return particleTextures[mode] or particleTextures['Bloom']
end

local function spawnCustomParticle(pos, vel, color, sizeMultiplier, lifetime, mode, style, centerPos)
    if not Toggles.Particles or not Toggles.Particles.Value then return end
    if #activeParticles >= MAX_PARTICLES then
        local oldest = table.remove(activeParticles, 1)
        if oldest then releaseParticle(oldest.Obj) end
    end

    local obj = getParticleInstance()
    obj.Image.Image = getSelectedParticleTexture(style)

    local mult = (sizeMultiplier or 1)
    local userSize = (Options.ParticleSize and Options.ParticleSize.Value or 1.2) * mult
    local studSize = math.max(0.4, userSize * 1.8)
    obj.Billboard.Size = UDim2.new(studSize, 0, studSize, 0)
    obj.Billboard.AlwaysOnTop = (Toggles.ParticleThroughWalls == nil or Toggles.ParticleThroughWalls.Value == true)
    obj.Billboard.LightInfluence = (Toggles.ParticleGlow and Toggles.ParticleGlow.Value) and 0 or 1
    local pColor = color or (Options.ParticleColor and Options.ParticleColor.Value) or Color3.fromRGB(255, 100, 200)
    obj.Image.ImageColor3 = pColor
    obj.Image.ImageTransparency = 0
    obj.Part.CFrame = CFrame.new(pos)

    local rotSpeed = (Toggles.ParticleRotation and Toggles.ParticleRotation.Value) and (math.random(-240, 240)) or 0
    local speedMult = (Options.ParticleSpeed and Options.ParticleSpeed.Value or 1.5)
    local pData = {
        Obj = obj,
        Pos = pos,
        Center = centerPos or pos,
        Mode = mode or 'Normal',
        Vel = vel * (speedMult * 10),
        Age = 0,
        Lifetime = lifetime or (math.random(60, 110) / 100),
        FadeIn = 0.08,
        FadeOutStart = (lifetime or 0.8) * 0.65,
        Rot = math.random(0, 360),
        RotSpeed = rotSpeed,
        Color = pColor,
        Seed = math.random(),
    }
    table.insert(activeParticles, pData)
end

spawnAttackParticles = function(targetPos)
    if not isParticleEventEnabled('Attack') then return end
    local count = Options.ParticleAttackCount and Options.ParticleAttackCount.Value or 15
    local style = Options.AttackParticleStyle and Options.AttackParticleStyle.Value or 'Star'
    local mode = Options.AttackParticleMode and Options.AttackParticleMode.Value or 'Bounce'
    local col = (Toggles.AttackCustomColor and Toggles.AttackCustomColor.Value and Options.AttackColor and Options.AttackColor.Value)
        or (Options.ParticleColor and Options.ParticleColor.Value)

    for _ = 1, count do
        local offset = Vector3.new((math.random() - 0.5) * 1.2, (math.random() - 0.5) * 1.5, (math.random() - 0.5) * 1.2)
        local vel
        if mode == 'Fountain' then
            vel = Vector3.new((math.random() - 0.5) * 2.2, math.random() * 3.5 + 3.0, (math.random() - 0.5) * 2.2)
        elseif mode == 'Vortex' then
            vel = Vector3.new((math.random() - 0.5) * 2.8, math.random() * 2.0 + 0.5, (math.random() - 0.5) * 2.8)
        elseif mode == 'Burst' then
            vel = Vector3.new((math.random() - 0.5) * 5.0, (math.random() - 0.5) * 5.0, (math.random() - 0.5) * 5.0)
        else -- Normal or Bounce
            vel = Vector3.new((math.random() - 0.5) * 3.2, (math.random() - 0.5) * 2.8 + 0.8, (math.random() - 0.5) * 3.2)
        end
        spawnCustomParticle(targetPos + offset, vel, col, 1.0, math.random(6, 12) / 10, mode, style, targetPos)
    end
end

spawnTotemParticles = function(targetPos)
    if not isParticleEventEnabled('Totem') then return end
    local count = Options.ParticleTotemCount and Options.ParticleTotemCount.Value or 18
    local style = Options.TotemParticleStyle and Options.TotemParticleStyle.Value or 'Kronex'
    local mode = Options.TotemParticleMode and Options.TotemParticleMode.Value or 'Fountain'
    local useCustomCol = Toggles.TotemCustomColor and Toggles.TotemCustomColor.Value

    for _ = 1, count do
        local col
        if useCustomCol and Options.TotemColor then
            col = Options.TotemColor.Value
        else
            col = (math.random() > 0.5) and TOTEM_COLOR_YELLOW or TOTEM_COLOR_GREEN
        end
        local offset = Vector3.new((math.random() - 0.5) * 1.2, (math.random() - 0.5) * 1.5 + 1.0, (math.random() - 0.5) * 1.2)
        local vel
        if mode == 'Fountain' then
            vel = Vector3.new((math.random() - 0.5) * 3.5, math.random() * 3.5 + 2.0, (math.random() - 0.5) * 3.5)
        elseif mode == 'Vortex' then
            vel = Vector3.new((math.random() - 0.5) * 3.0, math.random() * 2.5 + 1.0, (math.random() - 0.5) * 3.0)
        elseif mode == 'Burst' then
            vel = Vector3.new((math.random() - 0.5) * 5.5, (math.random() - 0.5) * 5.5 + 1.0, (math.random() - 0.5) * 5.5)
        else -- Normal or Bounce
            vel = Vector3.new((math.random() - 0.5) * 3.5, math.random() * 2.5 + 1.2, (math.random() - 0.5) * 3.5)
        end
        spawnCustomParticle(targetPos + offset, vel, col, 1.2, math.random(10, 18) / 10, mode, style, targetPos)
    end
end

spawnThrowParticles = function(p1, p2)
    if not isParticleEventEnabled('Throw') then return end
    local count = Options.ParticleThrowCount and Options.ParticleThrowCount.Value or 4
    local style = Options.ThrowParticleStyle and Options.ThrowParticleStyle.Value or 'Bloom'
    local mode = Options.ThrowParticleMode and Options.ThrowParticleMode.Value or 'Normal'
    local col = (Toggles.ThrowCustomColor and Toggles.ThrowCustomColor.Value and Options.ThrowColor and Options.ThrowColor.Value)
        or (Options.ParticleColor and Options.ParticleColor.Value)

    local dir = p2 - p1
    local dist = dir.Magnitude
    if dist < 1 then return end
    for i = 1, count do
        local frac = i / (count + 1)
        local pos = p1 + dir * frac + Vector3.new((math.random() - 0.5) * 0.5, (math.random() - 0.5) * 0.5, (math.random() - 0.5) * 0.5)
        local vel
        if mode == 'Vortex' then
            vel = Vector3.new((math.random() - 0.5) * 1.5, math.random() * 1.5, (math.random() - 0.5) * 1.5)
        elseif mode == 'Burst' then
            vel = Vector3.new((math.random() - 0.5) * 3.0, (math.random() - 0.5) * 3.0, (math.random() - 0.5) * 3.0)
        elseif mode == 'Fountain' then
            vel = Vector3.new((math.random() - 0.5) * 1.0, math.random() * 2.0 + 1.0, (math.random() - 0.5) * 1.0)
        else -- Normal or Bounce
            vel = Vector3.new((math.random() - 0.5) * 0.8, (math.random() - 0.5) * 0.8, (math.random() - 0.5) * 0.8)
        end
        spawnCustomParticle(pos, vel, col, 0.6, math.random(4, 8) / 10, mode, style, pos)
    end
end

local particleRayParams = RaycastParams.new()
particleRayParams.FilterType = Enum.RaycastFilterType.Exclude

local lastPlayerPos = nil
local lastMoveParticleTick = 0
local lastIdleParticleTick = 0

local function updateParticles(dt)
    if not Toggles.Particles or not Toggles.Particles.Value then
        if #activeParticles > 0 then
            for i = #activeParticles, 1, -1 do
                releaseParticle(activeParticles[i].Obj)
                table.remove(activeParticles, i)
            end
        end
        return
    end

    if LP.Character then
        particleRayParams.FilterDescendantsInstances = { LP.Character, particlesFolder }
    else
        particleRayParams.FilterDescendantsInstances = { particlesFolder }
    end

    local throughWalls = (Toggles.ParticleThroughWalls == nil or Toggles.ParticleThroughWalls.Value == true)
    local glow = Toggles.ParticleGlow and Toggles.ParticleGlow.Value
    local isRainbow = Toggles.ParticleRainbow and Toggles.ParticleRainbow.Value
    local mainColor = Options.ParticleColor and Options.ParticleColor.Value or Color3.fromRGB(255, 100, 200)

    for i = #activeParticles, 1, -1 do
        local p = activeParticles[i]
        p.Age = p.Age + dt
        if p.Age >= p.Lifetime then
            releaseParticle(p.Obj)
            table.remove(activeParticles, i)
        else
            local pMode = p.Mode or 'Normal'
            if pMode == 'Bounce' then
                local nextPos = p.Pos + p.Vel * dt
                local rayResult = Workspace:Raycast(p.Pos, p.Vel * dt, particleRayParams)
                if rayResult then
                    local normal = rayResult.Normal
                    p.Vel = (p.Vel - 2 * p.Vel:Dot(normal) * normal) * 0.65
                    p.Pos = rayResult.Position + normal * 0.08
                else
                    p.Pos = nextPos
                end
                p.Vel = p.Vel * (0.95 ^ (dt * 60)) - Vector3.new(0, 9.8 * 0.6 * dt, 0)

            elseif pMode == 'Fountain' then
                local nextPos = p.Pos + p.Vel * dt
                local rayResult = Workspace:Raycast(p.Pos, p.Vel * dt, particleRayParams)
                if rayResult then
                    local normal = rayResult.Normal
                    p.Vel = (p.Vel - 2 * p.Vel:Dot(normal) * normal) * 0.55
                    p.Pos = rayResult.Position + normal * 0.08
                else
                    p.Pos = nextPos
                end
                p.Vel = p.Vel * (0.96 ^ (dt * 60)) - Vector3.new(0, 12 * 0.5 * dt, 0)

            elseif pMode == 'Vortex' then
                local rel = p.Pos - (p.Center or p.Pos)
                local tangent = Vector3.new(-rel.Z, 0, rel.X)
                if tangent.Magnitude > 0.01 then
                    p.Vel = p.Vel + tangent.Unit * (18 * dt)
                end
                p.Pos = p.Pos + p.Vel * dt
                p.Vel = p.Vel * (0.96 ^ (dt * 60)) + Vector3.new(0, 1.5 * dt, 0)

            elseif pMode == 'Burst' then
                p.Pos = p.Pos + p.Vel * dt
                p.Vel = p.Vel * (0.89 ^ (dt * 60))

            else -- 'Normal'
                p.Pos = p.Pos + p.Vel * dt
                p.Vel = p.Vel * (0.94 ^ (dt * 60)) - Vector3.new(0, 2.0 * dt, 0)
            end

            p.Obj.Part.CFrame = CFrame.new(p.Pos)

            if p.RotSpeed ~= 0 then
                p.Rot = (p.Rot + p.RotSpeed * dt) % 360
                p.Obj.Image.Rotation = p.Rot
            end

            local alpha = 1
            if p.Age < p.FadeIn then
                alpha = p.Age / p.FadeIn
            elseif p.Age > p.FadeOutStart then
                alpha = math.clamp((p.Lifetime - p.Age) / (p.Lifetime - p.FadeOutStart), 0, 1)
            end
            p.Obj.Image.ImageTransparency = 1 - alpha

            if isRainbow then
                p.Obj.Image.ImageColor3 = Color3.fromHSV((tick() * 0.5 + p.Seed) % 1, 0.8, 1)
            else
                p.Obj.Image.ImageColor3 = p.Color or mainColor
            end

            p.Obj.Billboard.AlwaysOnTop = throughWalls
            p.Obj.Billboard.LightInfluence = glow and 0 or 1
        end
    end

    -- Move particles check
    if isParticleEventEnabled('Move') and LP.Character then
        local hrp = LP.Character:FindFirstChild('HumanoidRootPart')
        local hum = LP.Character:FindFirstChildOfClass('Humanoid')
        if hrp and hum and hum.Health > 0 then
            local curPos = hrp.Position
            if lastPlayerPos then
                local dist = (curPos - lastPlayerPos).Magnitude
                if dist > 0.05 and (tick() - lastMoveParticleTick > 0.05) then
                    lastMoveParticleTick = tick()
                    local moveCount = Options.ParticleMoveCount and Options.ParticleMoveCount.Value or 3
                    local style = Options.MoveParticleStyle and Options.MoveParticleStyle.Value or 'Snow'
                    local mode = Options.MoveParticleMode and Options.MoveParticleMode.Value or 'Normal'
                    local col = (Toggles.MoveCustomColor and Toggles.MoveCustomColor.Value and Options.MoveColor and Options.MoveColor.Value)
                        or (Options.ParticleColor and Options.ParticleColor.Value)

                    local moveDir = (curPos - lastPlayerPos).Unit
                    for _ = 1, moveCount do
                        local spawnPos = curPos - Vector3.new(0, 1.5, 0) + Vector3.new((math.random() - 0.5) * 1.0, (math.random() - 0.5) * 0.6, (math.random() - 0.5) * 1.0)
                        local vel
                        if mode == 'Vortex' then
                            vel = -moveDir * 1.2 + Vector3.new((math.random() - 0.5) * 2.0, math.random() * 1.5 + 0.5, (math.random() - 0.5) * 2.0)
                        elseif mode == 'Fountain' then
                            vel = -moveDir * 1.0 + Vector3.new((math.random() - 0.5) * 1.0, math.random() * 2.5 + 2.0, (math.random() - 0.5) * 1.0)
                        elseif mode == 'Burst' then
                            vel = -moveDir * 2.0 + Vector3.new((math.random() - 0.5) * 3.0, (math.random() - 0.5) * 2.0, (math.random() - 0.5) * 3.0)
                        else -- Normal or Bounce
                            vel = -moveDir * 1.8 + Vector3.new((math.random() - 0.5) * 1.2, math.random() * 0.8 + 0.4, (math.random() - 0.5) * 1.2)
                        end
                        spawnCustomParticle(spawnPos, vel, col, 0.8, math.random(6, 11) / 10, mode, style, curPos)
                    end
                end
            end
            lastPlayerPos = curPos
        end
    end

    -- Idle particles check
    if isParticleEventEnabled('Idle') and LP.Character then
        if tick() - lastIdleParticleTick > 0.35 then
            lastIdleParticleTick = tick()
            local hrp = LP.Character:FindFirstChild('HumanoidRootPart')
            local hum = LP.Character:FindFirstChildOfClass('Humanoid')
            if hrp and hum and hum.Health > 0 then
                local idleCount = Options.ParticleIdleCount and Options.ParticleIdleCount.Value or 3
                local range = Options.ParticleIdleRange and Options.ParticleIdleRange.Value or 12
                local style = Options.IdleParticleStyle and Options.IdleParticleStyle.Value or 'Heart'
                local mode = Options.IdleParticleMode and Options.IdleParticleMode.Value or 'Vortex'
                local col = (Toggles.IdleCustomColor and Toggles.IdleCustomColor.Value and Options.IdleColor and Options.IdleColor.Value)
                    or (Options.ParticleColor and Options.ParticleColor.Value)

                for _ = 1, idleCount do
                    local offsetX = (math.random() - 0.5) * range
                    local offsetZ = (math.random() - 0.5) * range
                    local offsetY = (math.random() - 0.5) * 4 + 0.5
                    local spawnPos = hrp.Position + Vector3.new(offsetX, offsetY, offsetZ)
                    local vel
                    if mode == 'Vortex' then
                        vel = Vector3.new((math.random() - 0.5) * 1.5, math.random() * 1.2 + 0.4, (math.random() - 0.5) * 1.5)
                    elseif mode == 'Fountain' then
                        vel = Vector3.new((math.random() - 0.5) * 0.8, math.random() * 2.5 + 1.5, (math.random() - 0.5) * 0.8)
                    elseif mode == 'Burst' then
                        vel = Vector3.new((math.random() - 0.5) * 2.5, (math.random() - 0.5) * 2.0, (math.random() - 0.5) * 2.5)
                    else -- Normal or Bounce
                        vel = Vector3.new((math.random() - 0.5) * 0.6, math.random() * 0.5 + 0.2, (math.random() - 0.5) * 0.6)
                    end
                    spawnCustomParticle(spawnPos, vel, col, 0.8, math.random(15, 25) / 10, mode, style, hrp.Position)
                end
            end
        end
    end
end

RunService.RenderStepped:Connect(updateParticles)

-- Death / Totem listener
local function hookDeathForTotem(player)
    local function onChar(char)
        local hum = char:WaitForChild('Humanoid', 5)
        if hum then
            hum.Died:Connect(function()
                local hrp = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Head')
                if hrp then
                    local myHrp = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
                    if myHrp and (hrp.Position - myHrp.Position).Magnitude < 250 then
                        spawnTotemParticles(hrp.Position)
                    end
                end
            end)
        end
    end
    if player.Character then onChar(player.Character) end
    player.CharacterAdded:Connect(onChar)
end

for _, pl in ipairs(Players:GetPlayers()) do
    if pl ~= LP then hookDeathForTotem(pl) end
end
Players.PlayerAdded:Connect(function(pl)
    if pl ~= LP then hookDeathForTotem(pl) end
end)

cleanupParticles = function()
    for _, p in ipairs(activeParticles) do
        if p.Obj and p.Obj.Part then p.Obj.Part:Destroy() end
    end
    activeParticles = {}
    for _, p in ipairs(particlePool) do
        if p.Part then p.Part:Destroy() end
    end
    particlePool = {}
    if particlesFolder then
        particlesFolder:Destroy()
        particlesFolder = nil
    end
end


end

-- Shot tracking for Real Hitsound & Hit Numbers Confirmation
local lastShotInfo = {
    targetPlayer = nil,
    targetChar = nil,
    targetPart = nil,
    hitPos = nil,
    tick = 0,
    toolName = nil,
    behavior = nil,
    recentAttacks = setmetatable({}, { __mode = 'k' }),
    lastAttackTick = 0,
}

lastShotInfo.recordAttack = function(player, hitPart, hitPos, weaponName)
    if not player or player == LP then return end
    local now = tick()
    lastShotInfo.recentAttacks[player] = {
        tick = now,
        part = hitPart,
        pos = hitPos,
        weapon = weaponName or 'Weapon'
    }
    lastShotInfo.lastAttackTick = now

    lastShotInfo.targetPlayer = player
    lastShotInfo.targetChar = player.Character
    lastShotInfo.targetPart = hitPart
    lastShotInfo.hitPos = hitPos or (hitPart and hitPart.Position)
    lastShotInfo.tick = now
    lastShotInfo.toolName = weaponName or 'Weapon'
    lastShotInfo.behavior = 'Standard'
end

-- Silent Aim & Hit Registration Hook
local isDoubleTapping = false
local oldNamecall
oldNamecall = hookmetamethod(game, '__namecall', function(self, ...)
    local method = getnamecallmethod()
    if (method == 'Kick' or method == 'kick') and (self == LP or self == Players.LocalPlayer) then
        return nil
    end

    if method == 'FireServer' and self == ShootEvent then
        local now = tick()
        lastShotInfo.tick = now
        lastShotInfo.lastAttackTick = now
        local callArgs = { ... }
        local bullets = callArgs[1]
        if typeof(bullets) == 'table' then
            for _, bullet in pairs(bullets) do
                if typeof(bullet) == 'table' then
                    local hitPart = nil
                    local hitPos = nil
                    for _, val in pairs(bullet) do
                        if typeof(val) == 'Instance' and game.IsA(val, 'BasePart') then
                            hitPart = val
                        elseif typeof(val) == 'Vector3' then
                            hitPos = val
                        end
                    end
                    if hitPart then
                        local hitChar = hitPart.Parent
                        local targetPlayer = hitChar and Players.GetPlayerFromCharacter(Players, hitChar)
                        if not targetPlayer and hitChar and hitChar.Parent then
                            targetPlayer = Players.GetPlayerFromCharacter(Players, hitChar.Parent)
                        end
                        if targetPlayer and targetPlayer ~= LP then
                            local char = LP.Character
                            local tool = char and game.FindFirstChildOfClass(char, 'Tool')
                            local wName = tool and tool.Name or 'Gun'
                            if lastShotInfo.recordAttack then
                                lastShotInfo.recordAttack(targetPlayer, hitPart, hitPos or hitPart.Position, wName)
                            end
                        end
                    end
                end
            end
        end

        if not isDoubleTapping and Toggles.DoubleTap and Toggles.DoubleTap.Value and (Toggles.DoubleTapManual == nil or Toggles.DoubleTapManual.Value) then
            local char = LP.Character
            local tool = char and game.FindFirstChildOfClass(char, 'Tool')
            local isRemington = tool and tool.Name == 'Remington 870'
            local mode = Options.DoubleTapWeapon and Options.DoubleTapWeapon.Value or 'Remington 870 Only'
            if mode == 'All Guns' or isRemington then
                isDoubleTapping = true
                local argsCopy = { ... }
                local burstDelay = (Options.DoubleTapDelay and Options.DoubleTapDelay.Value) or 0.02
                task.delay(burstDelay, function()
                    pcall(function()
                        if tool and tool.Parent == char then
                            ShootEvent:FireServer(unpack(argsCopy))
                            local curAmmo = tool:GetAttribute('Local_CurrentAmmo')
                            if curAmmo and curAmmo > 0 then
                                tool:SetAttribute('Local_CurrentAmmo', curAmmo - 1)
                                updateHudAmmo(tool, curAmmo - 1, getConfig(tool))
                            end
                        end
                    end)
                    isDoubleTapping = false
                end)
            end
        end
    end

    if method == 'FireServer' and typeof(self) == 'Instance' and (self.Name == 'meleeEvent' or self.Name == 'Punch') then
        local now = tick()
        lastShotInfo.tick = now
        lastShotInfo.lastAttackTick = now
        local callArgs = { ... }
        local target = callArgs[1]
        local targetPlayer = nil
        local hitPart = nil
        if typeof(target) == 'Instance' then
            if game.IsA(target, 'Player') then
                targetPlayer = target
                hitPart = target.Character and (game.FindFirstChild(target.Character, 'HumanoidRootPart') or game.FindFirstChild(target.Character, 'Head'))
            elseif game.IsA(target, 'Model') then
                targetPlayer = Players.GetPlayerFromCharacter(Players, target)
                hitPart = game.FindFirstChild(target, 'HumanoidRootPart') or game.FindFirstChild(target, 'Head')
            elseif game.IsA(target, 'BasePart') then
                targetPlayer = Players.GetPlayerFromCharacter(Players, target.Parent)
                if not targetPlayer and target.Parent and target.Parent.Parent then
                    targetPlayer = Players.GetPlayerFromCharacter(Players, target.Parent.Parent)
                end
                hitPart = target
            end
        end
        if targetPlayer and targetPlayer ~= LP then
            local char = LP.Character
            local tool = char and game.FindFirstChildOfClass(char, 'Tool')
            local wName = tool and tool.Name or 'Melee'
            if lastShotInfo.recordAttack then
                lastShotInfo.recordAttack(targetPlayer, hitPart, hitPart and hitPart.Position or Vector3.zero, wName)
            end
        end
    end

    if method == 'Raycast' and self == Workspace and Toggles.SilentAim.Value then
        local args = {...}
        local raycastParams = args[3]
        if raycastParams and typeof(raycastParams) == 'RaycastParams' and raycastParams.CollisionGroup == 'ClientBullet' then
            if targetPartCache then
                local targetPlayer = targetPartCache.Parent and Players.GetPlayerFromCharacter(Players, targetPartCache.Parent)
                local aimPos = targetPartCache.Position
                if resolveTarget and Toggles.Resolver and Toggles.Resolver.Value and targetPlayer then
                    aimPos, targetPartCache = resolveTarget(targetPlayer, targetPartCache, args[1])
                end
                local dir = (aimPos - args[1]).Unit * args[2].Magnitude
                local inVeh, veh = targetPlayer and isInVehicle(targetPlayer)
                local origFilter = raycastParams.FilterDescendantsInstances
                local newFilter = table.clone(origFilter)
                if inVeh and veh then
                    table.insert(newFilter, veh)
                end
                if Toggles.ShieldBypass and Toggles.ShieldBypass.Value and (Toggles.ShieldBypassRiot == nil or Toggles.ShieldBypassRiot.Value) and targetPartCache.Parent then
                    local rsp = game.FindFirstChild(targetPartCache.Parent, 'RiotShieldPart')
                    if rsp then table.insert(newFilter, rsp) end
                    for _, item in ipairs(game.GetChildren(targetPartCache.Parent)) do
                        if game.IsA(item, 'Tool') and string.find(string.lower(item.Name), 'shield') then
                            table.insert(newFilter, item)
                        end
                    end
                end
                raycastParams.FilterDescendantsInstances = newFilter
                if setnamecallmethod then setnamecallmethod('Raycast') end
                local result = oldNamecall(self, args[1], dir, raycastParams)
                raycastParams.FilterDescendantsInstances = origFilter
                if result then
                    if targetPlayer then
                        if lastShotInfo.recordAttack then
                            lastShotInfo.recordAttack(targetPlayer, targetPartCache, targetPartCache.Position, 'SilentAim')
                        else
                            lastShotInfo.targetPlayer = targetPlayer
                            lastShotInfo.targetChar = targetPartCache.Parent
                            lastShotInfo.targetPart = targetPartCache
                            lastShotInfo.hitPos = targetPartCache.Position
                            lastShotInfo.tick = tick()
                            lastShotInfo.toolName = 'SilentAim'
                            lastShotInfo.behavior = 'Standard'
                        end
                    end
                    spawnAttackParticles(targetPartCache.Position)
                    return result
                end
            end
        end
    end

    if setnamecallmethod then setnamecallmethod(method) end
    return oldNamecall(self, ...)
end)

pcall(function()
    hookfunction(LP.Kick, function() end)
end)

-- Tracers Override
local GunTracers = require(ReplicatedStorage.SharedModules.GunTracers)

local function isOurBullet(origin)
    local char = LP.Character
    if not char then return false end
    local root = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Head')
    return root and (origin - root.Position).Magnitude < 30
end

local function getShooterFromOrigin(origin)
    local best, bestDist = nil, 15
    for _, player in Players:GetPlayers() do
        if player == LP then continue end
        local char = player.Character
        if not char then continue end
        local root = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Head')
        if root then
            local d = (origin - root.Position).Magnitude
            if d < bestDist then
                bestDist = d
                best = player
            end
        end
    end
    return best
end

local function shouldShowTracer(origin)
    if isOurBullet(origin) then return true end
    if not Toggles.TracersFilters.Value then return true end
    local shooter = getShooterFromOrigin(origin)
    if not shooter or shooter == LP then return true end
    if shooter.Team == LP.Team then return Toggles.TracersTeammates.Value end
    if shooter.Team == Teams.Guards then return Toggles.TracersGuards.Value end
    local isHostile = shooter.Character and shooter.Character:GetAttribute('Hostile')
    if shooter.Team == Teams.Inmates and isHostile then
        return Toggles.TracersHostile.Value
    end
    if shooter.Team == Teams.Inmates then return Toggles.TracersInmates.Value end
    if shooter.Team == Teams.Criminals then return Toggles.TracersCriminals.Value end
    return true
end

local rainbowHue = 0

local function spawnImpactEffect(pos, color)
    if not (Toggles.TracersImpact and Toggles.TracersImpact.Value) then return end
    local sz = Options.TracerImpactSize and Options.TracerImpactSize.Value or 0.8
    local part = Instance.new('Part')
    part.Name = 'TracerImpact'
    part.Material = Enum.Material.Neon
    part.Shape = Enum.PartType.Ball
    part.Size = Vector3.new(sz, sz, sz)
    part.CFrame = CFrame.new(pos)
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.CastShadow = false
    part.Color = color
    part.Parent = workspace.CurrentCamera

    local TweenService = game:GetService('TweenService')
    local tw = TweenService:Create(part, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = Vector3.new(sz * 1.6, sz * 1.6, sz * 1.6),
        Transparency = 1
    })
    tw:Play()
    tw.Completed:Connect(function()
        part:Destroy()
    end)
    Debris:AddItem(part, 0.35)
end

local function makeTracer(p1, p2, color1, color2, thickness, lifetime)
    color2 = color2 or color1
    local mode = Options.TracerMode and Options.TracerMode.Value or 'Solid Beam'
    local matName = Options.TracerMaterial and Options.TracerMaterial.Value or 'Neon'
    local mat = Enum.Material[matName] or Enum.Material.Neon
    local trans = Options.TracerTransparency and Options.TracerTransparency.Value or 0.2
    local magn = (p1 - p2).Magnitude
    local mid = (p1 + p2) / 2
    local TweenService = game:GetService('TweenService')

    spawnImpactEffect(p2, color2)

    if mode == 'Camera Facing Beam' then
        local p0 = Instance.new('Part')
        p0.Size = Vector3.zero
        p0.CFrame = CFrame.new(p1)
        p0.Anchored = true
        p0.CanCollide = false
        p0.Transparency = 1
        p0.Parent = workspace.CurrentCamera

        local p1part = Instance.new('Part')
        p1part.Size = Vector3.zero
        p1part.CFrame = CFrame.new(p2)
        p1part.Anchored = true
        p1part.CanCollide = false
        p1part.Transparency = 1
        p1part.Parent = workspace.CurrentCamera

        local a0 = Instance.new('Attachment', p0)
        local a1 = Instance.new('Attachment', p1part)

        local beam = Instance.new('Beam', p0)
        beam.Attachment0 = a0
        beam.Attachment1 = a1
        beam.Width0 = thickness
        beam.Width1 = thickness
        beam.FaceCamera = true
        beam.Color = ColorSequence.new(color1, color2)
        beam.Transparency = NumberSequence.new(trans)
        beam.LightInfluence = 0
        beam.LightEmission = 1

        local tw = TweenService:Create(beam, TweenInfo.new(lifetime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Width0 = 0,
            Width1 = 0,
            Transparency = NumberSequence.new(1)
        })
        tw:Play()
        tw.Completed:Connect(function()
            p0:Destroy()
            p1part:Destroy()
        end)
        Debris:AddItem(p0, lifetime + 0.15)
        Debris:AddItem(p1part, lifetime + 0.15)
        return
    end

    if mode == 'Flying Projectile' then
        local bLen = Options.FlyingBulletLength and Options.FlyingBulletLength.Value or 4
        local spd = Options.FlyingBulletSpeed and Options.FlyingBulletSpeed.Value or 1200
        local travelTime = math.clamp(magn / spd, 0.02, 1.5)

        local bullet = Instance.new('Part')
        bullet.Name = 'FlyingTracer'
        bullet.Material = mat
        bullet.Anchored = true
        bullet.CanCollide = false
        bullet.CanQuery = false
        bullet.CanTouch = false
        bullet.CastShadow = false
        bullet.Color = color1
        bullet.Transparency = trans
        bullet.Size = Vector3.new(thickness * 1.2, thickness * 1.2, math.min(bLen, magn))
        bullet.CFrame = CFrame.new(p1, p2)
        bullet.Parent = workspace.CurrentCamera

        local tw = TweenService:Create(bullet, TweenInfo.new(travelTime, Enum.EasingStyle.Linear), {
            CFrame = CFrame.new(p2, p2 + (p2 - p1).Unit)
        })
        tw:Play()
        tw.Completed:Connect(function()
            bullet:Destroy()
        end)
        Debris:AddItem(bullet, travelTime + 0.1)
        return
    end

    -- Part-based Tracers (Solid Beam, Laser Cylinder, Pulse Fade)
    local part = Instance.new('Part')
    part.Name = 'RayPart'
    part.Material = mat
    part.Anchored = true
    part.Transparency = trans
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.CastShadow = false
    part.Color = color1

    if mode == 'Laser Cylinder' then
        part.Shape = Enum.PartType.Cylinder
        part.Size = Vector3.new(magn, thickness, thickness)
        part.CFrame = CFrame.new(mid, p2) * CFrame.Angles(0, math.rad(90), 0)
    else
        part.Size = Vector3.new(thickness, thickness, magn)
        part.CFrame = CFrame.new(mid, p2)
    end

    local colorMode = Options.TracerColorMode and Options.TracerColorMode.Value or 'Solid Color'
    if colorMode == 'Gradient (Muzzle -> Hit)' and color1 ~= color2 then
        local gui = Instance.new('SurfaceGui', part)
        gui.Face = Enum.NormalId.Front
        gui.LightInfluence = 0
        gui.AlwaysOnTop = true
        local frame = Instance.new('Frame', gui)
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundColor3 = Color3.new(1, 1, 1)
        frame.BorderSizePixel = 0
        frame.BackgroundTransparency = trans
        local gradient = Instance.new('UIGradient', frame)
        gradient.Color = ColorSequence.new(color1, color2)

        local gui2 = Instance.new('SurfaceGui', part)
        gui2.Face = Enum.NormalId.Back
        gui2.LightInfluence = 0
        gui2.AlwaysOnTop = true
        local frame2 = Instance.new('Frame', gui2)
        frame2.Size = UDim2.new(1, 0, 1, 0)
        frame2.BackgroundColor3 = Color3.new(1, 1, 1)
        frame2.BorderSizePixel = 0
        frame2.BackgroundTransparency = trans
        local gradient2 = Instance.new('UIGradient', frame2)
        gradient2.Color = ColorSequence.new(color1, color2)
    end

    if Toggles.TracersGlow and Toggles.TracersGlow.Value then
        local light = Instance.new('SurfaceLight', part)
        light.Color = color1
        light.Range = Options.TracerGlowRange and Options.TracerGlowRange.Value or 7
        light.Face = Enum.NormalId.Bottom
        light.Brightness = Options.TracerGlowBrightness and Options.TracerGlowBrightness.Value or 5
        light.Angle = 180
    end

    if mode == 'Pulse Fade' then
        local tw = TweenService:Create(part, TweenInfo.new(lifetime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 1,
            Size = part.Size + Vector3.new(thickness * 0.6, thickness * 0.6, 0)
        })
        tw:Play()
    end

    Debris:AddItem(part, lifetime)
    part.Parent = workspace.CurrentCamera
end

local function getColor(colorKey, rainbowKey)
    if Toggles[rainbowKey] and Toggles[rainbowKey].Value then
        local h1 = rainbowHue
        local h2 = (rainbowHue + 0.3) % 1
        return Color3.fromHSV(h1, 1, 1), Color3.fromHSV(h2, 1, 1)
    end
    local opt = Options[colorKey]
    local c = opt and opt.Value or Color3.new(1, 1, 1)
    return c, c
end

local oldCreateBullet = GunTracers.createBullet
local oldCreateSniper = GunTracers.createSniper
local oldCreateTaser = GunTracers.createTaser

GunTracers.createBullet = function(p1, p2)
    if isOurBullet(p1) then
        spawnThrowParticles(p1, p2)
        spawnAttackParticles(p2)
    end
    if Toggles.Tracers.Value and Toggles.ShowBulletTracers.Value then
        if shouldShowTracer(p1) then
            local c1, c2 = getColor('BulletColor', 'BulletRainbow')
            makeTracer(p1, p2, c1, c2, Options.BulletThickness.Value, Options.BulletLifetime.Value)
        end
        return
    end
    return oldCreateBullet(p1, p2)
end

GunTracers.createSniper = function(p1, p2)
    if isOurBullet(p1) then
        spawnThrowParticles(p1, p2)
        spawnAttackParticles(p2)
    end
    if Toggles.Tracers.Value and Toggles.ShowSniperTracers.Value then
        if shouldShowTracer(p1) then
            local c1, c2 = getColor('SniperColor', 'SniperRainbow')
            makeTracer(p1, p2, c1, c2, Options.SniperThickness.Value, Options.SniperLifetime.Value)
        end
        return
    end
    return oldCreateSniper(p1, p2)
end

GunTracers.createTaser = function(p1, p2)
    if isOurBullet(p1) then
        spawnThrowParticles(p1, p2)
        spawnAttackParticles(p2)
    end
    if Toggles.Tracers.Value and Toggles.ShowTaserTracers.Value then
        if shouldShowTracer(p1) then
            local c1, c2 = getColor('TaserColor', 'TaserRainbow')
            makeTracer(p1, p2, c1, c2, Options.TaserThickness.Value, Options.TaserLifetime.Value)
        end
        return
    end
    return oldCreateTaser(p1, p2)
end

-- Rage Bot (v2)
local rageBotRunning = false
local rageBotLastShot = 0

local calculateModifiedFireRate

do
    local originalFireRates = {
        ['AK-47']         = { fireRate = 0.1,   auto = true },
        ['M4A1']          = { fireRate = 0.09,  auto = true },
        ['FAL']           = { fireRate = 0.095, auto = true },
        ['MP5']           = { fireRate = 0.1,   auto = true },
        ['M9']            = { fireRate = 0.12,  auto = false },
        ['Revolver']      = { fireRate = 0.3,   auto = false },
        ['M700']          = { fireRate = 0.2,   auto = false },
        ['Remington 870'] = { fireRate = 0.7,   auto = false },
        ['Taser']         = { fireRate = 0.1,   auto = false },
    }

    calculateModifiedFireRate = function(toolName, baseRate)
        if not (Toggles.FireRateChanger and Toggles.FireRateChanger.Value) then
            return baseRate
        end
        if toolName == 'Remington 870' then
            return baseRate
        end
        local mode = Options.FireRateMode and Options.FireRateMode.Value or 'Multiplier'
        if mode == 'Instant (0s)' then
            return 0.001
        elseif mode == 'Custom Delay' then
            local customVal = Options.CustomFireRate and Options.CustomFireRate.Value or 0.02
            return math.max(0.001, customVal)
        elseif mode == 'Multiplier' then
            local mult = Options.FireRateMultiplier and Options.FireRateMultiplier.Value or 3
            mult = math.max(1, mult)
            return math.max(0.001, baseRate / mult)
        end
        return baseRate
    end

    local function patchToolFireRate(tool)
        if not tool or not tool:IsA('Tool') then return end
        local isGun = tool:GetAttribute('ToolType') == 'Gun' or originalFireRates[tool.Name]
        if not isGun then return end

        local orig = originalFireRates[tool.Name]
        local baseRate = orig and orig.fireRate or (tool:GetAttribute('FireRate') or 0.1)
        local baseAuto = orig and orig.auto or (tool:GetAttribute('AutoFire') ~= false)

        if tool.Name == 'Remington 870' then
            if orig then
                tool:SetAttribute('FireRate', orig.fireRate)
                tool:SetAttribute('AutoFire', orig.auto)
            end
            return
        end

        if Toggles.FireRateChanger and Toggles.FireRateChanger.Value and (Toggles.FireRateApplyManual == nil or Toggles.FireRateApplyManual.Value) then
            local newRate = calculateModifiedFireRate(tool.Name, baseRate)
            local forceAuto = Toggles.AlwaysAutomatic and Toggles.AlwaysAutomatic.Value
            tool:SetAttribute('FireRate', newRate)
            if forceAuto then
                tool:SetAttribute('AutoFire', true)
            end
        else
            if orig then
                tool:SetAttribute('FireRate', orig.fireRate)
                tool:SetAttribute('AutoFire', orig.auto)
            end
        end
    end

    local function updateGunControllerInternal()
        if not (getgc and getupvalues) then return end
        pcall(function()
            local isEnabled = Toggles.FireRateChanger and Toggles.FireRateChanger.Value and (Toggles.FireRateApplyManual == nil or Toggles.FireRateApplyManual.Value)
            local forceAuto = Toggles.AlwaysAutomatic and Toggles.AlwaysAutomatic.Value

            for _, obj in ipairs(getgc(true)) do
                if type(obj) == 'function' and (not isexecutorclosure or not isexecutorclosure(obj)) then
                    local uvs = getupvalues(obj)
                    for _, val in pairs(uvs) do
                        if type(val) == 'table' and rawget(val, 'FireRate') ~= nil then
                            local toolName = rawget(val, 'ToolName') or rawget(val, 'Name')
                            local orig = toolName and originalFireRates[toolName]
                            local baseRate = orig and orig.fireRate or 0.1
                            if toolName == 'Remington 870' then
                                if orig then
                                    val.FireRate = orig.fireRate
                                    val.AutoFire = orig.auto
                                end
                            elseif isEnabled then
                                val.FireRate = calculateModifiedFireRate(toolName, baseRate)
                                if forceAuto then
                                    val.AutoFire = true
                                end
                            else
                                if orig then
                                    val.FireRate = orig.fireRate
                                    val.AutoFire = orig.auto
                                end
                            end
                        end
                    end
                end
            end
        end)
    end

    local function updateAllGunsFireRate()
        local bp = LP:FindFirstChild('Backpack')
        if bp then
            for _, child in bp:GetChildren() do
                patchToolFireRate(child)
            end
        end
        local char = LP.Character
        if char then
            for _, child in char:GetChildren() do
                patchToolFireRate(child)
            end
        end
        updateGunControllerInternal()
    end

    Toggles.FireRateChanger:OnChanged(updateAllGunsFireRate)
    Options.FireRateMode:OnChanged(updateAllGunsFireRate)
    Options.FireRateMultiplier:OnChanged(updateAllGunsFireRate)
    Options.CustomFireRate:OnChanged(updateAllGunsFireRate)
    Toggles.AlwaysAutomatic:OnChanged(updateAllGunsFireRate)
    Toggles.FireRateApplyManual:OnChanged(updateAllGunsFireRate)

    local bp = LP:FindFirstChild('Backpack')
    if bp then
        bp.ChildAdded:Connect(patchToolFireRate)
    end
    if LP.Character then
        LP.Character.ChildAdded:Connect(patchToolFireRate)
    end
    LP.CharacterAdded:Connect(function(char)
        char.ChildAdded:Connect(patchToolFireRate)
        local newBp = LP:WaitForChild('Backpack', 5)
        if newBp then
            newBp.ChildAdded:Connect(patchToolFireRate)
        end
        task.delay(1, updateAllGunsFireRate)
    end)
end

local gunConfigs = {
    ['AK-47']        = { fireRate=0.1,  auto=true,  range=1100, reloadTime=2,   projectiles=1, behavior='Standard', maxAmmo=30 },
    ['M4A1']         = { fireRate=0.09, auto=true,  range=1100, reloadTime=2,   projectiles=1, behavior='Standard', maxAmmo=30 },
    ['FAL']          = { fireRate=0.095,auto=true,  range=1100, reloadTime=2,   projectiles=1, behavior='Standard', maxAmmo=20 },
    ['MP5']          = { fireRate=0.1,  auto=true,  range=1100, reloadTime=2,   projectiles=1, behavior='Standard', maxAmmo=30 },
    ['M9']           = { fireRate=0.12, auto=false, range=1500, reloadTime=2,   projectiles=1, behavior='Standard', maxAmmo=15 },
    ['Revolver']     = { fireRate=0.3,  auto=false, range=1500, reloadTime=3,   projectiles=1, behavior='Standard', maxAmmo=6 },
    ['M700']         = { fireRate=0.2,  auto=false, range=1300, reloadTime=3,   projectiles=1, behavior='Sniper',    chargeTime=0.3, storedAmmo=15, maxAmmo=1 },
    ['Remington 870']= { fireRate=0.7,  auto=false, range=350,  reloadTime=2.0, projectiles=5, behavior='Shotgun',  maxAmmo=6 },
    ['Taser']        = { fireRate=0.1,  auto=false, range=52,   reloadTime=3.4, projectiles=1, behavior='Taser',     chargeTime=0.15, maxAmmo=1 },
}

getConfig = function(tool)
    if not tool then return nil end
    local cfg = gunConfigs[tool.Name]
    if not cfg then
        cfg = {
            fireRate = tool:GetAttribute('FireRate') or 0.1,
            auto = tool:GetAttribute('AutoFire'),
            range = tool:GetAttribute('Range') or 1100,
            reloadTime = tool:GetAttribute('ReloadTime') or 2,
            projectiles = tool:GetAttribute('ProjectileCount') or 1,
            behavior = tool:GetAttribute('Behavior') or 'Standard',
            chargeTime = tool:GetAttribute('ChargeTime'),
            storedAmmo = tool:GetAttribute('MaxStoredAmmo') or tool:GetAttribute('StoredAmmo'),
            maxAmmo = tool:GetAttribute('MaxAmmo') or 30,
        }
        if cfg.auto == nil then cfg.auto = true end
    else
        if not cfg.maxAmmo then
            cfg.maxAmmo = tool:GetAttribute('MaxAmmo') or 30
        end
    end
    return cfg
end

local hitsoundIds = {
    ['Fatality'] = 115982072912004,
    ['Skeet'] = 83717596220569,
    ['Bell'] = 83641156499511,
    ['COD'] = 77082587278347,
    ['Metal'] = 2868331684,
    ['TF2 Critical'] = 6405267300,
    ['TF2'] = 118731928809041,
    ['Rust'] = 121566025787365,
}

local playHitsound = nil
local playKillsound = nil
do
    local lastHitsoundTick = 0
    local lastKillsoundTick = 0

    playHitsound = function(ignoreToggle)
        if not ignoreToggle and not (Toggles.Hitsound and Toggles.Hitsound.Value) then return end
        local sName = Options.HitsoundSelect and Options.HitsoundSelect.Value
        local id = hitsoundIds[sName]
        if id then
            local now = tick()
            if not ignoreToggle and (now - lastHitsoundTick) < 0.04 then return end
            lastHitsoundTick = now

            local vol = ((Options.HitsoundVolume and Options.HitsoundVolume.Value) or 60) / 100
            local snd = Instance.new('Sound')
            snd.Name = 'Hitsound'
            snd.SoundId = 'rbxassetid://' .. id
            snd.Volume = math.clamp(vol, 0.05, 1)
            snd.Parent = workspace
            snd:Play()
            Debris:AddItem(snd, 2)
        end
    end

    playKillsound = function(ignoreToggle)
        if not ignoreToggle and not (Toggles.Killsound and Toggles.Killsound.Value) then return end
        local sName = Options.KillsoundSelect and Options.KillsoundSelect.Value
        local id = hitsoundIds[sName]
        if id then
            local now = tick()
            if not ignoreToggle and (now - lastKillsoundTick) < 0.08 then return end
            lastKillsoundTick = now

            local vol = ((Options.KillsoundVolume and Options.KillsoundVolume.Value) or 80) / 100
            local snd = Instance.new('Sound')
            snd.Name = 'Killsound'
            snd.SoundId = 'rbxassetid://' .. id
            snd.Volume = math.clamp(vol, 0.05, 1)
            snd.Parent = workspace
            snd:Play()
            Debris:AddItem(snd, 2)
        end
    end
end

local function onDamageConfirmed(player)
    playHitsound()
end

-- ====================== HITMARKERS ======================
local spawnHitmarker = nil
local cleanupHitmarkers = nil

do
    local hitmarkerLines = {}
    for i = 1, 4 do
        local l = Drawing.new('Line')
        l.Visible = false
        l.Thickness = 1.5
        l.Transparency = 1
        l.Color = Color3.new(1, 1, 1)
        l.ZIndex = 50
        table.insert(hitmarkerLines, l)
    end

    local hmState = {
        active = false,
        startTime = 0,
        isCrit = false,
        isTaser = false,
        hitPos = nil,
    }

    spawnHitmarker = function(isCrit, isTaser, hitPos)
        if not (Toggles.Hitmarkers and Toggles.Hitmarkers.Value) then return end
        hmState.active = true
        hmState.startTime = tick()
        hmState.isCrit = isCrit
        hmState.isTaser = isTaser
        hmState.hitPos = hitPos or (Camera and Camera.CFrame.Position + Camera.CFrame.LookVector * 10)
    end

    local function hideHitmarker()
        for i = 1, 4 do
            hitmarkerLines[i].Visible = false
        end
    end

    local function updateHitmarkers()
        if not (Toggles.Hitmarkers and Toggles.Hitmarkers.Value) or not hmState.active then
            hideHitmarker()
            return
        end

        local dur = Options.HitmarkerDuration and Options.HitmarkerDuration.Value or 0.35
        local elapsed = tick() - hmState.startTime
        if elapsed >= dur then
            hmState.active = false
            hideHitmarker()
            return
        end

        local centerScreen
        local mode = Options.HitmarkerMode and Options.HitmarkerMode.Value or 'Weapon Crosshair'
        if mode == '3D Hit Position' and hmState.hitPos then
            local sp, onScreen = Camera:WorldToViewportPoint(hmState.hitPos)
            if not onScreen or sp.Z <= 0 then
                hideHitmarker()
                return
            end
            centerScreen = Vector2.new(sp.X, sp.Y)
        elseif mode == 'Screen Center' then
            centerScreen = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        else -- 'Weapon Crosshair'
            local crosshairPos = nil
            pcall(function()
                if DefaultCursor and DefaultCursor.Visible and DefaultCursor.Parent and DefaultCursor.Parent.Visible then
                    local inset = game:GetService('GuiService'):GetGuiInset()
                    crosshairPos = DefaultCursor.AbsolutePosition + inset + (DefaultCursor.AbsoluteSize / 2)
                end
            end)
            centerScreen = crosshairPos or UserInputService:GetMouseLocation()
        end

        local progress = elapsed / dur
        local alpha = math.clamp(1 - progress, 0, 1)

        local anim = Options.HitmarkerAnimation and Options.HitmarkerAnimation.Value or 'Expand & Fade'
        local baseLen = Options.HitmarkerSize and Options.HitmarkerSize.Value or 8
        local baseGap = Options.HitmarkerGap and Options.HitmarkerGap.Value or 5
        local thick = Options.HitmarkerThickness and Options.HitmarkerThickness.Value or 1.5

        local curGap = baseGap
        local curLen = baseLen

        if anim == 'Expand & Fade' then
            curGap = baseGap + progress * 6
        elseif anim == 'Bounce' then
            local bounce = math.sin(progress * math.pi) * 4
            curGap = baseGap + bounce
            curLen = baseLen + bounce * 0.5
        end

        local col = Options.HitmarkerColor and Options.HitmarkerColor.Value or Color3.fromRGB(255, 255, 255)
        if hmState.isTaser then
            col = Options.HitmarkerTaserCol and Options.HitmarkerTaserCol.Value or Color3.fromRGB(0, 230, 255)
        elseif hmState.isCrit and (Toggles.HitmarkerCritColor == nil or Toggles.HitmarkerCritColor.Value) then
            col = Options.HitmarkerCritCol and Options.HitmarkerCritCol.Value or Color3.fromRGB(255, 45, 45)
        end

        if Toggles.HitmarkerRainbow and Toggles.HitmarkerRainbow.Value then
            col = Color3.fromHSV((tick() * 1.5) % 1, 0.9, 1)
        end

        local cx, cy = centerScreen.X, centerScreen.Y

        hitmarkerLines[1].From = Vector2.new(cx - curGap - curLen, cy - curGap - curLen)
        hitmarkerLines[1].To = Vector2.new(cx - curGap, cy - curGap)

        hitmarkerLines[2].From = Vector2.new(cx + curGap + curLen, cy - curGap - curLen)
        hitmarkerLines[2].To = Vector2.new(cx + curGap, cy - curGap)

        hitmarkerLines[3].From = Vector2.new(cx - curGap - curLen, cy + curGap + curLen)
        hitmarkerLines[3].To = Vector2.new(cx - curGap, cy + curGap)

        hitmarkerLines[4].From = Vector2.new(cx + curGap + curLen, cy + curGap + curLen)
        hitmarkerLines[4].To = Vector2.new(cx + curGap, cy + curGap)

        for i = 1, 4 do
            hitmarkerLines[i].Thickness = thick
            hitmarkerLines[i].Color = col
            hitmarkerLines[i].Transparency = alpha
            hitmarkerLines[i].Visible = true
        end
    end

    local hmConn = RunService.RenderStepped:Connect(updateHitmarkers)

    cleanupHitmarkers = function()
        if hmConn then
            hmConn:Disconnect()
            hmConn = nil
        end
        for i = 1, 4 do
            pcall(function() hitmarkerLines[i]:Remove() end)
        end
    end
end

-- ====================== HIT NUMBERS (DAMAGE INDICATORS) ======================
local activeHitNumbers = {}
local spawnHitNumber

do

local fontMap = {
    ['UI'] = 0,
    ['System'] = 1,
    ['Plex'] = 2,
    ['Monospace'] = 3,
}

local function getHitNumberSpawnPos(player, char)
    local hitPos = lastShotInfo.hitPos
    if hitPos and lastShotInfo.targetChar == char then
        return hitPos + Vector3.new((math.random() - 0.5) * 1.0, (math.random() - 0.5) * 0.6, (math.random() - 0.5) * 1.0)
    end
    local head = char and char:FindFirstChild('Head')
    local hrp = char and char:FindFirstChild('HumanoidRootPart')
    local base = head or hrp
    if base then
        return base.Position + Vector3.new((math.random() - 0.5) * 1.4, 1.2 + (math.random() - 0.5) * 0.5, (math.random() - 0.5) * 1.4)
    end
    return Vector3.zero
end

spawnHitNumber = function(player, value, isCrit, isTaser)
    if not Toggles.HitNumbers or not Toggles.HitNumbers.Value then return end
    local char = player and player.Character
    if not char then return end

    local spawnPos = getHitNumberSpawnPos(player, char)
    local text = tostring(value)
    if not isTaser and type(value) == 'number' then
        text = "-" .. tostring(value)
    end

    local drawing = Drawing.new('Text')
    drawing.Text = text
    drawing.Center = true
    drawing.Outline = true
    drawing.OutlineColor = Color3.new(0, 0, 0)
    local fontName = (Options.HitNumberFont and Options.HitNumberFont.Value) or 'Plex'
    drawing.Font = fontMap[fontName] or 2
    drawing.Visible = false
    drawing.ZIndex = 40

    local baseSize = (Options.HitNumberSize and Options.HitNumberSize.Value) or 18
    if isCrit then
        baseSize = baseSize * 1.3
    end

    local col = (Options.HitNumberColor and Options.HitNumberColor.Value) or Color3.fromRGB(255, 235, 100)
    if isTaser then
        col = (Options.HitNumberTaserCol and Options.HitNumberTaserCol.Value) or Color3.fromRGB(0, 230, 255)
    elseif isCrit and (not Toggles.HitNumberCritColor or Toggles.HitNumberCritColor.Value) then
        col = (Options.HitNumberCritCol and Options.HitNumberCritCol.Value) or Color3.fromRGB(255, 50, 50)
    end

    local animStyle = (Options.HitNumberAnimation and Options.HitNumberAnimation.Value) or 'Pop & Bounce'
    local duration = (Options.HitNumberDuration and Options.HitNumberDuration.Value) or 1.0

    local randAngle = math.random() * math.pi * 2
    local randSpread = math.random() * 2.5 + 1.2
    local vx = math.cos(randAngle) * randSpread
    local vz = math.sin(randAngle) * randSpread
    local vy = math.random() * 3 + 5.5

    local velocity = Vector3.new(vx, vy, vz)
    local gravity = Vector3.new(0, -13, 0)

    if animStyle == 'Scatter (3D)' then
        velocity = Vector3.new(math.cos(randAngle) * (randSpread + 3.5), vy + 2.5, math.sin(randAngle) * (randSpread + 3.5))
        gravity = Vector3.new(0, -17, 0)
    elseif animStyle == 'Float Up' then
        velocity = Vector3.new(vx * 0.25, 4.0, vz * 0.25)
        gravity = Vector3.zero
    elseif animStyle == 'Rise & Fade' then
        velocity = Vector3.new(0, 3.0, 0)
        gravity = Vector3.zero
    end

    table.insert(activeHitNumbers, {
        drawing = drawing,
        startPos = spawnPos,
        velocity = velocity,
        gravity = gravity,
        startTime = tick(),
        duration = duration,
        baseSize = baseSize,
        color = col,
        text = text,
        animStyle = animStyle,
        seed = math.random(),
    })
end

local function updateHitNumbers()
    if #activeHitNumbers == 0 then return end
    local now = tick()
    local cam = workspace.CurrentCamera
    if not cam then return end

    local i = 1
    while i <= #activeHitNumbers do
        local hn = activeHitNumbers[i]
        local elapsed = now - hn.startTime
        local progress = elapsed / hn.duration

        if progress >= 1 then
            pcall(function() hn.drawing:Remove() end)
            table.remove(activeHitNumbers, i)
        else
            local currentWorldPos = hn.startPos
            local animMode = hn.animStyle

            if animMode == 'Pop & Bounce' then
                local t = elapsed
                currentWorldPos = hn.startPos + hn.velocity * t + 0.5 * hn.gravity * (t * t)
            elseif animMode == 'Float Up' then
                local riseDist = 4.2 * (1 - math.exp(-2.5 * elapsed))
                currentWorldPos = hn.startPos + Vector3.new(hn.velocity.X * elapsed * 0.5, riseDist, hn.velocity.Z * elapsed * 0.5)
            elseif animMode == 'Scatter (3D)' then
                local t = elapsed
                currentWorldPos = hn.startPos + hn.velocity * t + 0.5 * hn.gravity * (t * t)
            else -- 'Rise & Fade'
                currentWorldPos = hn.startPos + Vector3.new(0, 2.5 * elapsed, 0)
            end

            local screenPos, onScreen = cam:WorldToViewportPoint(currentWorldPos)

            if onScreen and screenPos.Z > 0 then
                local currentSize = hn.baseSize
                if progress < 0.2 then
                    local p = progress / 0.2
                    currentSize = hn.baseSize * (1 + 0.45 * math.sin(p * math.pi))
                else
                    currentSize = hn.baseSize * (1 - (progress - 0.2) * 0.15)
                end

                local alpha = 1
                if progress > 0.55 then
                    alpha = math.clamp((1 - progress) / 0.45, 0, 1)
                end

                local col = hn.color
                if Toggles.HitNumberRainbow and Toggles.HitNumberRainbow.Value then
                    local hue = (tick() * 0.8 + hn.seed) % 1
                    col = Color3.fromHSV(hue, 0.85, 1)
                end

                hn.drawing.Text = hn.text
                hn.drawing.Size = math.max(10, math.floor(currentSize))
                hn.drawing.Position = Vector2.new(screenPos.X, screenPos.Y)
                hn.drawing.Color = col
                hn.drawing.Transparency = alpha
                hn.drawing.Visible = true
            else
                hn.drawing.Visible = false
            end

            i = i + 1
        end
    end
end

RunService.RenderStepped:Connect(updateHitNumbers)


end

-- Real hit confirmation: listen to all players' Humanoid.HealthChanged and Taser stun
local victimHealths = setmetatable({}, { __mode = 'k' })
local lastTaserHitNum = 0

local function hookDamageTracker(player)
    if player == LP then return end
    local function onChar(char)
        local hum = char:WaitForChild('Humanoid', 5)
        if not hum then return end
        victimHealths[hum] = hum.Health

        hum.HealthChanged:Connect(function(newHealth)
            local prevHealth = victimHealths[hum] or newHealth
            victimHealths[hum] = newHealth
            if newHealth < prevHealth then
                local now = tick()
                local attackData = lastShotInfo.recentAttacks and lastShotInfo.recentAttacks[player]
                local isOurHit = (attackData and (now - attackData.tick) <= 1.25)
                    or (lastShotInfo.targetPlayer == player and (now - lastShotInfo.tick) <= 1.25)
                    or ((now - (lastShotInfo.lastAttackTick or 0)) <= 0.65)

                if isOurHit then
                    if _G.BoarsResolverConfirmHit then pcall(_G.BoarsResolverConfirmHit, player) end
                    local isKill = (newHealth <= 0 and prevHealth > 0)
                    if isKill and Toggles.Killsound and Toggles.Killsound.Value then
                        if not hum:GetAttribute('KillSoundFired') then
                            hum:SetAttribute('KillSoundFired', true)
                            playKillsound()
                        end
                    else
                        onDamageConfirmed(player)
                    end

                    if isKill and _G.BoarsAddKillfeed then
                        if not hum:GetAttribute('KillfeedFired') then
                            hum:SetAttribute('KillfeedFired', true)
                            local hitPart = (attackData and attackData.part) or lastShotInfo.targetPart
                            local isHead = (hitPart and hitPart.Name == 'Head')
                            local dist = 0
                            local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
                            local vRoot = char and char:FindFirstChild('HumanoidRootPart')
                            if root and vRoot then
                                dist = math.round((root.Position - vRoot.Position).Magnitude)
                            end
                            local wName = (attackData and attackData.weapon) or lastShotInfo.toolName or 'Gun'
                            _G.BoarsAddKillfeed(LP, player, wName, isHead, dist)
                        end
                    end
                    local dmg = math.round(prevHealth - newHealth)
                    if dmg <= 0 then dmg = 1 end
                    local hitPart = (attackData and attackData.part) or lastShotInfo.targetPart
                    local hitPos = (attackData and attackData.pos) or lastShotInfo.hitPos
                    local isHead = (hitPart and hitPart.Name == 'Head') or isKill
                    spawnHitNumber(player, dmg, isHead, false)
                    if spawnHitmarker then
                        spawnHitmarker(isHead, false, hitPos)
                    end
                end
            end
        end)

        hum.Died:Connect(function()
            local now = tick()
            local attackData = lastShotInfo.recentAttacks and lastShotInfo.recentAttacks[player]
            local isOurKill = (attackData and (now - attackData.tick) <= 1.5)
                or (lastShotInfo.targetPlayer == player and (now - lastShotInfo.tick) <= 1.5)
                or ((now - (lastShotInfo.lastAttackTick or 0)) <= 0.9)

            if isOurKill then
                if not hum:GetAttribute('KillSoundFired') then
                    hum:SetAttribute('KillSoundFired', true)
                    playKillsound()
                end
            end
        end)

        hum:GetPropertyChangedSignal('WalkSpeed'):Connect(function()
            if hum.WalkSpeed == 0 then
                local now = tick()
                if lastShotInfo.targetPlayer == player and lastShotInfo.behavior == 'Taser' and (now - lastShotInfo.tick) <= 0.65 then
                    onDamageConfirmed(player)
                    if (now - lastTaserHitNum) > 0.5 then
                        lastTaserHitNum = now
                        spawnHitNumber(player, '⚡ TASED', false, true)
                    end
                    if spawnHitmarker then
                        spawnHitmarker(false, true, lastShotInfo.hitPos)
                    end
                end
            end
        end)

        local function checkTrack(track)
            if track.Animation and string.find(track.Animation.AnimationId, '287112271') then
                local now = tick()
                if lastShotInfo.targetPlayer == player and lastShotInfo.behavior == 'Taser' and (now - lastShotInfo.tick) <= 0.65 then
                    onDamageConfirmed(player)
                    if (now - lastTaserHitNum) > 0.5 then
                        lastTaserHitNum = now
                        spawnHitNumber(player, '⚡ TASED', false, true)
                    end
                    if spawnHitmarker then
                        spawnHitmarker(false, true, lastShotInfo.hitPos)
                    end
                end
            end
        end

        local animator = hum:FindFirstChildOfClass('Animator')
        if animator then
            animator.AnimationPlayed:Connect(checkTrack)
        else
            hum.ChildAdded:Connect(function(c)
                if c:IsA('Animator') then
                    c.AnimationPlayed:Connect(checkTrack)
                end
            end)
        end
    end

    if player.Character then task.spawn(onChar, player.Character) end
    player.CharacterAdded:Connect(function(c) task.spawn(onChar, c) end)
end

for _, p in Players:GetPlayers() do hookDamageTracker(p) end
Players.PlayerAdded:Connect(hookDamageTracker)

isAlive = function(player)
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass('Humanoid')
    if not hum or hum.Health <= 0 then return false end
    if player ~= LP and char:FindFirstChildOfClass('ForceField') then
        return false
    end
    return true
end

-- Taser stun tracking (3.5s duration in Prison Life)
local tasedPlayers = setmetatable({}, { __mode = 'k' })

local function isPlayerTased(player)
    local t = tasedPlayers[player]
    if t and (tick() - t) < 3.5 then return true end
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass('Humanoid')
    if hum and (hum.WalkSpeed <= 1 or hum.PlatformStand) then return true end
    return false
end

-- Threat classification: Lethal threat vs Ordinary inmate
local function isLethalThreat(targetPlayer)
    if targetPlayer == LP then return false end
    if not isAlive(targetPlayer) then return false end
    if not isAlive(LP) then return false end

    local myTeam = LP.Team
    local theirTeam = targetPlayer.Team
    if myTeam == theirTeam then return false end

    if myTeam == Teams.Guards then
        if theirTeam == Teams.Criminals or (theirTeam and theirTeam.Name == 'Criminals') then
            return true
        end
        if theirTeam == Teams.Inmates and targetPlayer.Character and targetPlayer.Character:GetAttribute('Hostile') then
            return true
        end
        return false
    elseif myTeam == Teams.Criminals then
        if theirTeam == Teams.Guards then
            return true
        end
        if theirTeam == Teams.Inmates then
            local attackInmates = (Toggles.RageBotTargetInmatesAsCrim and Toggles.RageBotTargetInmatesAsCrim.Value)
            return attackInmates == true
        end
        return true
    else
        if theirTeam == Teams.Guards then
            return true
        end
        if theirTeam == Teams.Criminals then
            local attackCrims = (Toggles.RageBotTargetInmatesAsCrim and Toggles.RageBotTargetInmatesAsCrim.Value)
            return attackCrims == true
        end
        return true
    end
end

local knownGunNames = {
    ['AK-47']=true, ['M4A1']=true, ['MP5']=true, ['M9']=true,
    ['Revolver']=true, ['Remington 870']=true, ['M700']=true,
    ['FAL']=true, ['Taser']=true,
}

local function getInventoryGun(name)
    if LP.Character then
        local t = LP.Character:FindFirstChild(name)
        if t and t:IsA('Tool') then return t end
    end
    local bp = LP:FindFirstChildOfClass('Backpack') or LP:FindFirstChild('Backpack')
    if bp then
        local t = bp:FindFirstChild(name)
        if t and t:IsA('Tool') then return t end
    end
    return nil
end

local function canBeDamaged(targetPlayer)
    return isLethalThreat(targetPlayer)
end

-- Quick threat checks
local function findQuickLethalThreat()
    local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
    if not root then return nil end
    local myPos = root.Position
    local origin = getLagCompensatedOrigin()
    for _, p in Players:GetPlayers() do
        if isLethalThreat(p) then
            local char = p.Character
            local hrp = char and char:FindFirstChild('HumanoidRootPart')
            local head = char and char:FindFirstChild('Head')
            if hrp then
                local dist = (hrp.Position - myPos).Magnitude
                if dist <= 1200 then
                    if hasLineOfSight(origin, hrp.Position, p) or (head and hasLineOfSight(origin, head.Position, p)) then
                        return p
                    end
                end
            end
        end
    end
    return nil
end

-- Auto Detect Cheaters Background Engine
do
    local playerTrack = {}
    local cheaterRayParams = RaycastParams.new()
    cheaterRayParams.FilterType = Enum.RaycastFilterType.Exclude
    cheaterRayParams.IgnoreWater = true

    task.spawn(function()
        while true do
            task.wait(0.25)
            if Toggles.AutoDetectCheaters and Toggles.AutoDetectCheaters.Value then
                local now = tick()
                local myChar = LP.Character
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and p.Parent == Players then
                        local char = p.Character
                        local hrp = char and char:FindFirstChild('HumanoidRootPart')
                        local hum = char and char:FindFirstChildOfClass('Humanoid')

                        if hrp and hum and hum.Health > 0 and isAlive(p) then
                            local inVeh = isInVehicle(p)
                            local pos = hrp.Position
                            local vel = hrp.AssemblyLinearVelocity or hrp.Velocity

                            local track = playerTrack[p]
                            if not track or track.char ~= char then
                                track = {
                                    char = char,
                                    lastPos = pos,
                                    lastTick = now,
                                    airTime = 0,
                                    speedStrikes = 0,
                                    lastNotify = 0,
                                    wasInVeh = inVeh,
                                }
                                playerTrack[p] = track
                            else
                                local dt = now - track.lastTick
                                if dt >= 0.15 and dt <= 1.5 then
                                    local flagReason = nil

                                    -- 1. Void / Underground godmode check
                                    if pos.Y < -65 then
                                        flagReason = 'Void / Underground Bypass'
                                    end

                                    -- 2. Teleportation check (instant distance skip)
                                    local totalDist = (pos - track.lastPos).Magnitude
                                    if not flagReason and not inVeh and not track.wasInVeh and pos.Y > -50 and track.lastPos.Y > -50 then
                                        if totalDist > 140 and dt <= 0.6 then
                                            flagReason = 'Teleportation'
                                        end
                                    end

                                    -- 3. Speedhack check (horizontal displacement speed > 110 studs/s)
                                    if not flagReason and not inVeh and not track.wasInVeh then
                                        local horizDist = Vector2.new(pos.X - track.lastPos.X, pos.Z - track.lastPos.Z).Magnitude
                                        local horizSpeed = horizDist / dt
                                        if horizSpeed > 110 then
                                            track.speedStrikes = track.speedStrikes + 1
                                            if track.speedStrikes >= 2 or horizSpeed > 160 then
                                                flagReason = 'Speedhack (' .. math.floor(horizSpeed) .. ' studs/s)'
                                            end
                                        else
                                            track.speedStrikes = math.max(0, track.speedStrikes - 1)
                                        end
                                    end

                                    -- 4. Air Fly / Zero-G Hover check
                                    if not flagReason and not inVeh and pos.Y > -30 then
                                        local filterList = { char }
                                        if myChar then table.insert(filterList, myChar) end
                                        cheaterRayParams.FilterDescendantsInstances = filterList
                                        local groundRay = Workspace:Raycast(pos, Vector3.new(0, -32, 0), cheaterRayParams)
                                        if not groundRay then
                                            if vel.Y > -8 then
                                                track.airTime = track.airTime + dt
                                                if track.airTime >= 2.5 then
                                                    flagReason = 'Fly / Air Hover'
                                                end
                                            else
                                                track.airTime = 0
                                            end
                                        else
                                            track.airTime = 0
                                        end
                                    else
                                        track.airTime = 0
                                    end

                                    -- Flagging and Notification
                                    if flagReason then
                                        local isNew = not detectedCheaters[p]
                                        detectedCheaters[p] = { reason = flagReason, time = now }
                                        if (isNew or (now - track.lastNotify) > 15) and Toggles.CheaterNotify and Toggles.CheaterNotify.Value then
                                            track.lastNotify = now
                                            pcall(function()
                                                Library:Notify(string.format('[CHEATER DETECTED] %s flagged for %s!', p.DisplayName or p.Name, flagReason), 5)
                                            end)
                                        end
                                    end
                                end

                                track.lastPos = pos
                                track.lastTick = now
                                track.wasInVeh = inVeh
                            end
                        end
                    end
                end
            end
        end
    end)

    Players.PlayerRemoving:Connect(function(p)
        detectedCheaters[p] = nil
        playerTrack[p] = nil
    end)

    if Toggles.AutoDetectCheaters then
        Toggles.AutoDetectCheaters:OnChanged(function()
            if not Toggles.AutoDetectCheaters.Value then
                table.clear(detectedCheaters)
            end
        end)
    end
end

local function findRageBotTargets(scanRange)
    local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
    if not root then return nil, nil, nil end
    local myPos = root.Position
    local origin = getLagCompensatedOrigin()

    local prioritizeCheaters = Toggles.RageBotPrioritizeCheaters and Toggles.RageBotPrioritizeCheaters.Value
    local bestCheater, bestCheaterDist, bestCheaterPart = nil, scanRange or 1500, nil
    local bestLethal, bestLethalDist, bestLethalPart = nil, scanRange or 1500, nil

    for _, player in Players:GetPlayers() do
        local char = player.Character
        if char and isAlive(player) then
            local hrp = char:FindFirstChild('HumanoidRootPart')
            local head = char:FindFirstChild('Head')
            if hrp then
                local dist = (hrp.Position - myPos).Magnitude
                local inVeh = isInVehicle(player)
                local hrpPos = hrp.Position
                local headPos = head and head.Position

                local targetPart = nil
                if inVeh then
                    if headPos and hasLineOfSight(origin, headPos, player) then
                        targetPart = head
                    elseif hasLineOfSight(origin, hrpPos, player) then
                        targetPart = hrp
                    end
                else
                    if hasLineOfSight(origin, hrpPos, player) then
                        targetPart = hrp
                    elseif headPos and hasLineOfSight(origin, headPos, player) then
                        targetPart = head
                    end
                end

                if targetPart then
                    local isLethal = isLethalThreat(player)
                    local isCheater = detectedCheaters[player] ~= nil

                    if prioritizeCheaters and isCheater and (isLethal or (player.Team ~= LP.Team and LP.Team ~= Teams.Guards)) then
                        if dist < bestCheaterDist then
                            bestCheaterDist = dist
                            bestCheater = player
                            bestCheaterPart = targetPart
                        end
                    end

                    if isLethal and dist < bestLethalDist then
                        bestLethalDist = dist
                        bestLethal = player
                        bestLethalPart = targetPart
                    end
                end
            end
        end
    end

    if bestCheater then
        return bestCheater, bestCheaterDist, bestCheaterPart
    end
    return bestLethal, bestLethalDist, bestLethalPart
end

local lastShotTick = 0

updateHudAmmo = function(tool, ammo, cfg)
    pcall(function()
        local hud = LP.PlayerGui and LP.PlayerGui:FindFirstChild('Home') and LP.PlayerGui.Home:FindFirstChild('hud')
        local gunFrame = hud and hud:FindFirstChild('BottomRightFrame') and hud.BottomRightFrame:FindFirstChild('GunFrame')
        local bulletsLabel = gunFrame and gunFrame:FindFirstChild('BulletsLabel')
        if bulletsLabel then
            if cfg and cfg.behavior == 'Sniper' then
                local stored = tool:GetAttribute('StoredAmmo') or 0
                bulletsLabel.Text = ammo .. " | " .. stored
            else
                local maxA = tool:GetAttribute('MaxAmmo') or (cfg and cfg.maxAmmo) or 0
                bulletsLabel.Text = ammo .. "/" .. maxA
            end
        end
    end)
end

local function fire(tool, targetPart, cfg)
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass('Humanoid')
    if (Toggles.RageBotDisableInVehicle == nil or Toggles.RageBotDisableInVehicle.Value) and (isInVehicle(LP) or (hum and hum.SeatPart)) then
        return
    end

    local origin = getLagCompensatedOrigin()
    local muzzle = tool:FindFirstChild('Muzzle')
    local visualOrigin = muzzle and muzzle.Position or origin

    local targetPos = targetPart.Position
    local targetPlayer = Players:GetPlayerFromCharacter(targetPart.Parent)

    if resolveTarget and Toggles.Resolver and Toggles.Resolver.Value and targetPlayer then
        targetPos, targetPart = resolveTarget(targetPlayer, targetPart, origin)
    end

    if not hasLineOfSight(origin, targetPos, targetPlayer) then
        if targetPlayer and targetPlayer.Character then
            local altPart = (targetPart.Name == 'Head') and targetPlayer.Character:FindFirstChild('HumanoidRootPart')
                or targetPlayer.Character:FindFirstChild('Head')
            if altPart and hasLineOfSight(origin, altPart.Position, targetPlayer) then
                targetPart = altPart
                targetPos = altPart.Position
            else
                return
            end
        else
            return
        end
    end

    local projectiles = cfg.projectiles
    local t = {}
    for _ = 1, projectiles do
        table.insert(t, { origin, targetPos, targetPart })
    end

    ShootEvent:FireServer(t)
    spawnAttackParticles(targetPos)

    -- Double Tap in RageBot / Void Aura
    if Toggles.DoubleTap and Toggles.DoubleTap.Value then
        local isRemington = tool and tool.Name == 'Remington 870'
        local mode = Options.DoubleTapWeapon and Options.DoubleTapWeapon.Value or 'Remington 870 Only'
        if mode == 'All Guns' or isRemington then
            local burstDelay = (Options.DoubleTapDelay and Options.DoubleTapDelay.Value) or 0.02
            task.delay(burstDelay, function()
                pcall(function()
                    if tool and tool.Parent == LP.Character and targetPart and targetPart.Parent then
                        ShootEvent:FireServer(t)
                        local curA = tool:GetAttribute('Local_CurrentAmmo')
                        if curA and curA > 0 then
                            local newA = math.max(0, curA - 1)
                            tool:SetAttribute('Local_CurrentAmmo', newA)
                            updateHudAmmo(tool, newA, cfg)
                        end
                    end
                end)
            end)
        end
    end


    -- Track shot for confirmed hit sound & hit numbers
    if lastShotInfo.recordAttack then
        lastShotInfo.recordAttack(targetPlayer, targetPart, targetPos, tool.Name)
        lastShotInfo.behavior = cfg.behavior
    else
        lastShotInfo.targetPlayer = targetPlayer
        lastShotInfo.targetChar = targetPart and targetPart.Parent
        lastShotInfo.targetPart = targetPart
        lastShotInfo.hitPos = targetPos
        lastShotInfo.tick = tick()
        lastShotInfo.toolName = tool.Name
        lastShotInfo.behavior = cfg.behavior
    end

    local curAmmo = tool:GetAttribute('Local_CurrentAmmo')
    if curAmmo == nil then
        curAmmo = tool:GetAttribute('CurrentAmmo') or tool:GetAttribute('MaxAmmo') or (cfg and cfg.maxAmmo) or 0
    end
    local newAmmo = math.max(0, curAmmo - 1)
    tool:SetAttribute('Local_CurrentAmmo', newAmmo)
    lastShotTick = tick()

    updateHudAmmo(tool, newAmmo, cfg)

    pcall(function()
        local handle = tool:FindFirstChild('Handle')
        if handle and handle:FindFirstChild('Flare') then
            handle.Flare.Enabled = true
            task.delay(0.05, function()
                if handle and handle:FindFirstChild('Flare') then
                    handle.Flare.Enabled = false
                end
            end)
        end
    end)

    if cfg.behavior == 'Sniper' then
        GunTracers.createSniper(visualOrigin, targetPos)
    elseif cfg.behavior == 'Taser' then
        GunTracers.createTaser(visualOrigin, targetPos)
    else
        GunTracers.createBullet(visualOrigin, targetPos)
    end

    local waitDelay = cfg.fireRate
    if Toggles.FireRateChanger and Toggles.FireRateChanger.Value and (Toggles.FireRateApplyRage == nil or Toggles.FireRateApplyRage.Value) then
        waitDelay = calculateModifiedFireRate(tool.Name, cfg.fireRate)
    end
    task.wait(waitDelay)
end

local function doReload(tool, cfg)
    if not tool or not tool.Parent then return end
    local maxAmmo = tool:GetAttribute('MaxAmmo') or (cfg and cfg.maxAmmo) or 0
    local curAmmo = tool:GetAttribute('Local_CurrentAmmo') or tool:GetAttribute('CurrentAmmo') or 0
    if curAmmo >= maxAmmo and curAmmo > 0 then
        tool:SetAttribute('Local_ReloadSession', 0)
        return
    end

    if (tool:GetAttribute('Local_ReloadSession') or 0) > 0 and curAmmo <= 0 then
        return
    end

    local reloadSession = tick()
    tool:SetAttribute('Local_ReloadSession', reloadSession)

    local isVoidReloadActive = (Toggles.VoidReload == nil or Toggles.VoidReload.Value)
    local char = LP.Character
    local root = char and char:FindFirstChild('HumanoidRootPart')
    local savedPreReloadCF = nil
    local reloadBV = nil

    if isVoidReloadActive and root and not (Toggles.VoidAura and Toggles.VoidAura.Value) then
        savedPreReloadCF = root.CFrame
        local voidY = (Options.VoidReloadDepth and Options.VoidReloadDepth.Value) or -250
        local voidCF = CFrame.new(savedPreReloadCF.X, voidY, savedPreReloadCF.Z)

        reloadBV = Instance.new('BodyVelocity')
        reloadBV.Name = 'CombatVoidReloadBV'
        reloadBV.MaxForce = Vector3.new(1e8, 1e8, 1e8)
        reloadBV.Velocity = Vector3.zero
        reloadBV.Parent = root

        root.CFrame = voidCF
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    pcall(function()
        local hud = LP.PlayerGui and LP.PlayerGui:FindFirstChild('Home') and LP.PlayerGui.Home:FindFirstChild('hud')
        local gunFrame = hud and hud:FindFirstChild('BottomRightFrame') and hud.BottomRightFrame:FindFirstChild('GunFrame')
        local bulletsLabel = gunFrame and gunFrame:FindFirstChild('BulletsLabel')
        if bulletsLabel then bulletsLabel.Text = "..." end
    end)

    pcall(function()
        local handle = tool:FindFirstChild('Handle')
        local reloadSnd = handle and handle:FindFirstChild('ReloadSound')
        if reloadSnd then
            local clone = reloadSnd:Clone()
            clone.Parent = handle
            clone:Play()
            Debris:AddItem(clone, 5)
        end
    end)

    task.spawn(function()
        pcall(function() FuncReload:InvokeServer() end)
    end)

    local reloadDuration = cfg.reloadTime or tool:GetAttribute('ReloadTime') or 2
    if tool.Name == 'Remington 870' then
        reloadDuration = 2.0
    end

    local startTime = tick()
    while (tick() - startTime) < reloadDuration do
        if not tool or not tool.Parent or tool:GetAttribute('Local_ReloadSession') ~= reloadSession then
            break
        end
        local serverAmmo = tool:GetAttribute('CurrentAmmo')
        if serverAmmo and serverAmmo >= maxAmmo and serverAmmo > 0 then
            break
        end
        if isVoidReloadActive and root and root.Parent and savedPreReloadCF and not (Toggles.VoidAura and Toggles.VoidAura.Value) then
            local voidY = (Options.VoidReloadDepth and Options.VoidReloadDepth.Value) or -250
            root.CFrame = CFrame.new(savedPreReloadCF.X, voidY, savedPreReloadCF.Z)
            root.AssemblyLinearVelocity = Vector3.zero
        end
        task.wait(0.03)
    end

    if savedPreReloadCF and root and root.Parent and not (Toggles.VoidAura and Toggles.VoidAura.Value) then
        root.CFrame = savedPreReloadCF
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        if reloadBV and reloadBV.Parent then
            pcall(function() reloadBV:Destroy() end)
        end
    end

    if tool and tool.Parent and tool:GetAttribute('Local_ReloadSession') == reloadSession then
        if cfg.behavior == 'Sniper' then
            local stored = tool:GetAttribute('StoredAmmo') or 0
            if stored > 0 then
                tool:SetAttribute('Local_CurrentAmmo', 1)
                tool:SetAttribute('StoredAmmo', math.max(0, stored - 1))
            end
        else
            local sAmmo = tool:GetAttribute('CurrentAmmo')
            local finalAmmo = (sAmmo and sAmmo > 0) and sAmmo or maxAmmo
            tool:SetAttribute('Local_CurrentAmmo', finalAmmo)
        end
        tool:SetAttribute('Local_ReloadSession', 0)
        local cur = tool:GetAttribute('Local_CurrentAmmo') or maxAmmo
        updateHudAmmo(tool, cur, cfg)
    else
        pcall(function()
            if tool then tool:SetAttribute('Local_ReloadSession', 0) end
        end)
    end
end



local function getAllInventoryGuns()
    local guns = {}
    local seen = {}
    if LP.Character then
        for _, item in LP.Character:GetChildren() do
            if item:IsA('Tool') and (knownGunNames[item.Name] or item:GetAttribute('ToolType') == 'Gun') then
                if not seen[item] then
                    seen[item] = true
                    table.insert(guns, { tool = item, equipped = true })
                end
            end
        end
    end
    local bp = LP:FindFirstChildOfClass('Backpack') or LP:FindFirstChild('Backpack')
    if bp then
        for _, item in bp:GetChildren() do
            if item:IsA('Tool') and (knownGunNames[item.Name] or item:GetAttribute('ToolType') == 'Gun') then
                if not seen[item] then
                    seen[item] = true
                    table.insert(guns, { tool = item, equipped = false })
                end
            end
        end
    end
    return guns
end

local function equipGun(tool)
    if not tool or not tool.Parent then return false end
    if tool.Parent == LP.Character then return true end
    local hum = LP.Character and LP.Character:FindFirstChildOfClass('Humanoid')
    if hum then
        hum:EquipTool(tool)
        return true
    end
    return false
end

local function unequipGuns()
    local hum = LP.Character and LP.Character:FindFirstChildOfClass('Humanoid')
    if hum then
        hum:UnequipTools()
    end
end

local function scoreLethalGun(tool, dist, isCurrentlyEquipped)
    local cfg = getConfig(tool)
    if not cfg then return -100 end
    if tool.Name == 'Taser' then return -100 end
    if dist > (cfg.range or 1100) then return -100 end

    local curAmmo = tool:GetAttribute('Local_CurrentAmmo') or tool:GetAttribute('CurrentAmmo') or 0
    local isReloading = ((tool:GetAttribute('Local_ReloadSession') or 0) > 0) and (curAmmo <= 0)

    local score = 100

    -- Heavy penalty if out of ammo or reloading
    if curAmmo <= 0 or isReloading then
        score = score - 70
    end

    -- Distance matching
    if tool.Name == 'Remington 870' then
        if dist <= 65 then
            score = score + 90
        elseif dist <= 120 then
            score = score + 45
        elseif dist <= 250 then
            score = score + 10
        else
            score = score - 30
        end
    elseif tool.Name == 'AK-47' or tool.Name == 'M4A1' or tool.Name == 'FAL' or tool.Name == 'MP5' then
        score = score + 65
        if dist > 60 and dist <= 350 then
            score = score + 30
        end
    elseif tool.Name == 'M700' then
        if dist > 250 then
            score = score + 70
        else
            score = score + 15
        end
    elseif tool.Name == 'Revolver' then
        score = score + 35
    elseif tool.Name == 'M9' then
        score = score + 25
    else
        score = score + 20
    end

    if isCurrentlyEquipped and curAmmo > 0 then
        score = score + 15
    end

    return score
end

local function selectBestLethalGun(dist, currentTool)
    local allGuns = getAllInventoryGuns()
    local bestGun = nil
    local bestScore = -50

    for _, entry in ipairs(allGuns) do
        local tool = entry.tool
        local isEquipped = (tool == currentTool or entry.equipped)
        local score = scoreLethalGun(tool, dist, isEquipped)
        if score > bestScore then
            bestScore = score
            bestGun = tool
        end
    end

    return bestGun
end

local givePlayerWeapon = nil
local grabSpecificGuns = nil
local grabAllSelectedWeapons = nil
local isGunGiver = nil
local findNearestGun = nil

do
    local knownGunNamesLower = {}
    for k in pairs(knownGunNames) do
        knownGunNamesLower[string.lower(k)] = k
    end
    knownGunNamesLower['riot shield'] = 'Riot Shield'
    knownGunNamesLower['shield'] = 'Riot Shield'
    knownGunNamesLower['taser'] = 'Taser'

    isGunGiver = function(model)
        if not model then return false end
        if knownGunNames[model.Name] then return true end
        if model:GetAttribute('ToolType') == 'Gun' or model:GetAttribute('ToolName') then return true end
        if model:FindFirstChild('Muzzle') then return true end
        for _, child in ipairs(model:GetChildren()) do
            if child:IsA('Tool') and (child:GetAttribute('ToolType') == 'Gun' or knownGunNames[child.Name]) then
                return true
            end
        end
        return false
    end

    local function getGiverToolName(giver)
        if not giver then return nil end
        local attr = giver:GetAttribute('ToolName')
        if attr and attr ~= '' then return attr end

        local tool = giver:FindFirstChildOfClass('Tool')
        if tool then return tool.Name end

        local nameLower = string.lower(giver.Name)
        for kLower, origName in pairs(knownGunNamesLower) do
            if string.find(nameLower, kLower, 1, true) then
                return origName
            end
        end

        return giver.Name
    end

    local function getGiverTouchPart(giver)
        if not giver then return nil end
        if giver:IsA('BasePart') then return giver end
        local tg = giver:FindFirstChild('TouchGiver') or giver:FindFirstChild('ITEMPICKUP') or giver:FindFirstChild('Giver') or giver:FindFirstChild('Handle')
        if tg and tg:IsA('BasePart') then return tg end
        if giver.PrimaryPart and giver.PrimaryPart:IsA('BasePart') then return giver.PrimaryPart end
        for _, child in ipairs(giver:GetChildren()) do
            if child:IsA('BasePart') then return child end
        end
        return nil
    end

    local function getAllGivers()
        local list = {}
        local seen = {}

        local function addGiver(obj)
            if not obj or seen[obj] then return end
            seen[obj] = true
            table.insert(list, obj)
        end

        -- CollectionService tags
        pcall(function()
            for _, obj in ipairs(CollectionService:GetTagged('Giver')) do
                addGiver(obj)
            end
            for _, obj in ipairs(CollectionService:GetTagged('TouchGiver')) do
                addGiver(obj)
            end
        end)

        -- Workspace models
        pcall(function()
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA('Model') and (obj:FindFirstChild('TouchGiver') or obj:FindFirstChild('Giver') or isGunGiver(obj)) then
                    addGiver(obj)
                end
            end
        end)

        -- Classic Prison_ITEMS
        pcall(function()
            local pi = workspace:FindFirstChild('Prison_ITEMS')
            if pi then
                local g = pi:FindFirstChild('giver') or pi
                for _, obj in ipairs(g:GetChildren()) do
                    addGiver(obj)
                end
            end
        end)

        return list
    end

    local function playerHasWeapon(weaponName)
        local char = LP.Character
        if char and char:FindFirstChild(weaponName) then return true end
        local bp = LP:FindFirstChild('Backpack')
        if bp and bp:FindFirstChild(weaponName) then return true end
        return false
    end

    givePlayerWeapon = function(giver, useTeleport)
        if not giver then return false end
        local touchPart = getGiverTouchPart(giver)
        local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')

        -- 1. Try Remote: GiverPressed & InteractWithItem
        pcall(function()
            local remotes = ReplicatedStorage:FindFirstChild('Remotes')
            local gp = remotes and remotes:FindFirstChild('GiverPressed')
            if gp then
                gp:FireServer(giver)
            end
            local iwi = remotes and remotes:FindFirstChild('InteractWithItem')
            if iwi and touchPart then
                iwi:InvokeServer(touchPart)
            end
        end)

        -- 2. Try classic ItemHandler
        pcall(function()
            local ih = workspace:FindFirstChild('Remote') and workspace.Remote:FindFirstChild('ItemHandler')
            if ih and touchPart then
                ih:InvokeServer(touchPart)
            end
        end)

        -- 3. Try firetouchinterest (executor touch packet simulation - instant, no teleport)
        if firetouchinterest and root and touchPart then
            pcall(function()
                firetouchinterest(root, touchPart, 0)
                task.wait(0.01)
                firetouchinterest(root, touchPart, 1)
            end)
        end

        -- 4. Micro-teleport & return if requested
        if useTeleport and root and touchPart then
            pcall(function()
                local oldCF = root.CFrame
                root.CFrame = touchPart.CFrame + Vector3.new(0, 1.5, 0)
                task.wait(0.04)
                if firetouchinterest then
                    firetouchinterest(root, touchPart, 0)
                    firetouchinterest(root, touchPart, 1)
                end
                root.CFrame = oldCF
            end)
        end

        return true
    end

    findNearestGun = function()
        local root = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
        if not root then return nil end
        local best, bestDist = nil, math.huge
        local givers = getAllGivers()
        for _, obj in ipairs(givers) do
            local tp = getGiverTouchPart(obj)
            if tp then
                local d = (tp.Position - root.Position).Magnitude
                if d < bestDist then
                    bestDist = d
                    best = obj
                end
            end
        end
        return best
    end

    grabSpecificGuns = function(gunNameList, force)
        local givers = getAllGivers()
        local useTeleport = Options.AutoGetWeaponMethod and Options.AutoGetWeaponMethod.Value == 'Teleport & Return'
        for _, giver in ipairs(givers) do
            local toolName = getGiverToolName(giver)
            if toolName then
                local shouldGrab = false
                for _, targetName in ipairs(gunNameList) do
                    if targetName == 'All Available' or string.lower(toolName) == string.lower(targetName) then
                        shouldGrab = true
                        break
                    end
                end
                if shouldGrab and (force or not playerHasWeapon(toolName)) then
                    givePlayerWeapon(giver, useTeleport)
                    task.wait(0.04)
                end
            end
        end
    end

    grabAllSelectedWeapons = function(force)
        local selected = (Options.AutoGetWeaponList and Options.AutoGetWeaponList.Value) or { ['All Available'] = true }
        local targets = {}
        if selected['All Available'] then
            table.insert(targets, 'All Available')
        else
            for name, isSel in pairs(selected) do
                if isSel then table.insert(targets, name) end
            end
        end
        if #targets > 0 then
            grabSpecificGuns(targets, force)
        end
    end

    -- Auto Get Weapons background task loop
    task.spawn(function()
        while true do
            task.wait(1.2)
            if Toggles.AutoGetWeapon and Toggles.AutoGetWeapon.Value and isAlive(LP) then
                pcall(function()
                    grabAllSelectedWeapons(false)
                end)
            end
        end
    end)

    -- Auto Get on Respawn
    LP.CharacterAdded:Connect(function()
        if Toggles.AutoGetOnSpawn and Toggles.AutoGetOnSpawn.Value then
            task.wait(0.8)
            pcall(function()
                grabAllSelectedWeapons(true)
            end)
        end
    end)
end

local function rageBotLoop()
    while Toggles.RageBot.Value do
        if not isAlive(LP) then task.wait(0.2); continue end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        if (Toggles.RageBotDisableInVehicle == nil or Toggles.RageBotDisableInVehicle.Value) and (isInVehicle(LP) or (hum and hum.SeatPart)) then
            rageTargetPart = nil
            task.wait(0.2)
            continue
        end

        local curEquippedTool = LP.Character and LP.Character:FindFirstChildOfClass('Tool')
        local isHoldingGun = curEquippedTool and (knownGunNames[curEquippedTool.Name] or curEquippedTool:GetAttribute('ToolType') == 'Gun')

        local scanRange = 1500
        if not Toggles.RageBotAutoEquip.Value then
            if isHoldingGun then
                local c = getConfig(curEquippedTool)
                scanRange = (c and c.range) or 1100
            else
                scanRange = 0
            end
        end

        local lethalTarget, lethalDist, lethalPart = findRageBotTargets(scanRange)

        -- LETHAL THREAT (Criminal, Hostile Inmate, Enemy Guard)
        if lethalTarget then
            local activeGun = curEquippedTool
            if Toggles.RageBotAutoEquip.Value then
                local bestGun = selectBestLethalGun(lethalDist, curEquippedTool)
                if bestGun then
                    if curEquippedTool ~= bestGun then
                        equipGun(bestGun)
                        task.wait(0.04)
                        activeGun = bestGun
                    end
                end
            end

            if not activeGun or not activeGun.Parent or (not knownGunNames[activeGun.Name] and activeGun:GetAttribute('ToolType') ~= 'Gun') or activeGun.Name == 'Taser' then
                if Toggles.RageBotAutoWeapon.Value then
                    local gun = findNearestGun()
                    if gun then
                        givePlayerWeapon(gun, false)
                    end
                end
                task.wait(0.1)
                continue
            end

            local cfg = getConfig(activeGun)
            if not cfg then task.wait(0.05); continue end

            if lethalDist > (cfg.range or 1100) then
                task.wait(0.05)
                continue
            end

            local curAmmo = activeGun:GetAttribute('Local_CurrentAmmo') or activeGun:GetAttribute('CurrentAmmo') or 0
            if curAmmo > 0 and (activeGun:GetAttribute('Local_ReloadSession') or 0) > 0 then
                activeGun:SetAttribute('Local_ReloadSession', 0)
            end
            local isReloading = ((activeGun:GetAttribute('Local_ReloadSession') or 0) > 0) and (curAmmo <= 0)

            if isReloading then
                task.wait(0.05)
                continue
            end

            if curAmmo <= 0 then
                if Toggles.RageBotAutoEquip.Value then
                    local altGun = selectBestLethalGun(lethalDist, activeGun)
                    local altAmmo = altGun and (altGun:GetAttribute('Local_CurrentAmmo') or altGun:GetAttribute('CurrentAmmo') or 0)
                    if altGun and altGun ~= activeGun and altAmmo > 0 then
                        equipGun(altGun)
                        task.wait(0.04)
                        continue
                    end
                end
                task.spawn(doReload, activeGun, cfg)
                task.wait(0.05)
                continue
            end

            if cfg.chargeTime then
                local ct = cfg.chargeTime
                if Toggles.FireRateChanger and Toggles.FireRateChanger.Value and (Toggles.FireRateApplyRage == nil or Toggles.FireRateApplyRage.Value) then
                    ct = calculateModifiedFireRate(activeGun.Name, ct)
                end
                task.wait(ct)
            end

            rageTargetPart = lethalPart
            fire(activeGun, lethalPart, cfg)
            task.wait(0.01)
            continue

        -- NO TARGETS FOUND
        else
            rageTargetPart = nil
            if not isHoldingGun and Toggles.RageBotAutoWeapon.Value then
                local gun = findNearestGun()
                if gun then
                    givePlayerWeapon(gun, false)
                end
            end
            task.wait(0.05)
            continue
        end
    end
    rageTargetPart = nil
    rageBotRunning = false
end

-- Ragebot Indicator
Toggles.RageBot:OnChanged(function()
    if Toggles.RageBot.Value and not rageBotRunning then
        rageBotRunning = true
        task.spawn(rageBotLoop)
    end
    rageIndicatorText.Visible = Toggles.RageBot.Value
end)

-- Tool ammo synchronization & tracking
local currentToolConnection = nil
local function hookToolAmmo(tool)
    if currentToolConnection then
        currentToolConnection:Disconnect()
        currentToolConnection = nil
    end
    if not tool or not tool:IsA('Tool') then return end

    local sAmmo = tool:GetAttribute('CurrentAmmo')
    if sAmmo ~= nil and tool:GetAttribute('Local_CurrentAmmo') == nil then
        tool:SetAttribute('Local_CurrentAmmo', sAmmo)
    end

    local conn = tool:GetAttributeChangedSignal('CurrentAmmo'):Connect(function()
        local serverAmmo = tool:GetAttribute('CurrentAmmo')
        if serverAmmo == nil then return end
        local localAmmo = tool:GetAttribute('Local_CurrentAmmo')
        if serverAmmo > 0 then
            tool:SetAttribute('Local_ReloadSession', 0)
        end
        if localAmmo == nil or serverAmmo <= localAmmo or serverAmmo > (localAmmo or 0) or (tick() - lastShotTick > 0.5) then
            tool:SetAttribute('Local_CurrentAmmo', serverAmmo)
            local cfg = getConfig(tool)
            updateHudAmmo(tool, serverAmmo, cfg)
        end
    end)
    currentToolConnection = conn
end

local function setupCharToolTracking(char)
    if not char then return end
    local curTool = char:FindFirstChildOfClass('Tool')
    if curTool then hookToolAmmo(curTool) end
    char.ChildAdded:Connect(function(child)
        if child:IsA('Tool') then hookToolAmmo(child) end
    end)
    char.ChildRemoved:Connect(function(child)
        if child:IsA('Tool') then
            if currentToolConnection then
                currentToolConnection:Disconnect()
                currentToolConnection = nil
            end
        end
    end)
end

if LP.Character then
    setupCharToolTracking(LP.Character)
end
LP.CharacterAdded:Connect(setupCharToolTracking)

-- ====================== VOID AURA (HVH EDITION) ======================
do
    local voidRunning = false
    local voidBV = nil
    local voidCycleIndex = 1
    local initialGroundCF = nil
    local orbitAngle = 0
    local lastAttackTick = 0
    local lastCycleTick = 0
    local lastMeleeTick = 0
    local blinkTimer = 0
    local blinkPhase = 'strike'
    local currentVoidTargetPlayer = nil
    local currentVoidTargetPart = nil
    local noclipParts = {}
    local voidHeartbeatConn = nil
    local voidSteppedConn = nil

    local function getMeleeRemote()
        return ReplicatedStorage:FindFirstChild('meleeEvent')
            or (ReplicatedStorage:FindFirstChild('Remotes') and ReplicatedStorage.Remotes:FindFirstChild('meleeEvent'))
    end

    local function cleanupVoidMovers()
        if voidBV then
            pcall(function() voidBV:Destroy() end)
            voidBV = nil
        end
    end

    local function ensureVoidBodyVelocity(root)
        if not root or not root.Parent then return end
        if not voidBV or voidBV.Parent ~= root then
            cleanupVoidMovers()
            local existing = root:FindFirstChild('VoidHoldBV')
            if existing and existing:IsA('BodyVelocity') then
                voidBV = existing
            else
                local bv = Instance.new('BodyVelocity')
                bv.Name = 'VoidHoldBV'
                bv.MaxForce = Vector3.new(1e8, 1e8, 1e8)
                bv.Velocity = Vector3.zero
                bv.Parent = root
                voidBV = bv
            end
        end
        if voidBV then
            voidBV.MaxForce = Vector3.new(1e8, 1e8, 1e8)
            voidBV.Velocity = Vector3.zero
        end
    end

    local function restoreVoidNoclip(char)
        if char then
            for part, origState in pairs(noclipParts) do
                if part and part.Parent and part:IsDescendantOf(char) then
                    pcall(function() part.CanCollide = origState end)
                end
            end
        end
        table.clear(noclipParts)
    end

    local function applyVoidNoclip(char)
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA('BasePart') then
                if noclipParts[part] == nil then
                    noclipParts[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end

    local function autoEquipBestWeapon(char, hum)
        local bp = LP:FindFirstChild('Backpack')
        if not bp or not hum then return nil end

        local priority = { 'Remington 870', 'AK-47', 'M4A1', 'M9', 'Crude Knife', 'Hammer' }
        for _, gunName in ipairs(priority) do
            local item = bp:FindFirstChild(gunName)
            if item and item:IsA('Tool') then
                hum:EquipTool(item)
                return item
            end
        end

        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA('Tool') then
                hum:EquipTool(item)
                return item
            end
        end
        return nil
    end

    -- 3D Flight Position Generator
    local function calculateHvHPosition(targetPart, posMode, dist, height, dt)
        local targetPos = targetPart.Position
        local targetCF = targetPart.CFrame
        local look = targetCF.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.001 then
            flatLook = flatLook.Unit
        else
            flatLook = Vector3.new(0, 0, -1)
        end
        local flatRight = Vector3.new(-flatLook.Z, 0, flatLook.X)

        local orbitSpeed = (Options.VoidOrbitSpeed and Options.VoidOrbitSpeed.Value) or 16
        orbitAngle = (orbitAngle + (dt * orbitSpeed)) % (math.pi * 2)

        if posMode == '3D Cyclone Orbit (HvH)' or posMode == 'Orbit / Cyclone (HvH)' then
            local waveY = math.sin(orbitAngle * 2.2) * 2.0
            local offset = Vector3.new(math.cos(orbitAngle) * dist, (height or 2) + waveY, math.sin(orbitAngle) * dist)
            return targetPos + offset

        elseif posMode == '3D Helix / Corkscrew (HvH)' then
            local vPhase = math.sin(orbitAngle * 1.8) * 3.5
            local rPhase = 1 + 0.2 * math.cos(orbitAngle * 2.6)
            local offset = Vector3.new(math.cos(orbitAngle) * (dist * rPhase), (height or 2) + vPhase, math.sin(orbitAngle) * (dist * rPhase))
            return targetPos + offset

        elseif posMode == 'Spherical Chaos / Evasive' then
            local pitch = math.sin(orbitAngle * 0.75) * 0.85
            local r = dist
            local x = r * math.cos(pitch) * math.cos(orbitAngle)
            local z = r * math.cos(pitch) * math.sin(orbitAngle)
            local y = (height or 1) + (r * math.sin(pitch))
            return targetPos + Vector3.new(x, y, z)

        elseif posMode == 'Behind Target (Backstab Flank)' or posMode == 'Behind Target (Backstab)' then
            local weave = math.sin(tick() * 5.5) * (dist * 0.45)
            local behindPos = targetPos - (flatLook * dist) + (flatRight * weave) + Vector3.new(0, height or 1, 0)
            return behindPos

        elseif posMode == 'Above Target (Sky Stomp)' then
            local wobbleX = math.cos(orbitAngle) * math.min(dist, 4)
            local wobbleZ = math.sin(orbitAngle) * math.min(dist, 4)
            local abovePos = targetPos + Vector3.new(wobbleX, math.max(5, height or 10), wobbleZ)
            return abovePos

        elseif posMode == 'Underground (Void Floor)' then
            local belowPos = targetPos - Vector3.new(0, math.max(2, math.abs(height or 7)), 0)
            return belowPos

        elseif posMode == 'Jitter Random Flank' then
            local ang = math.random() * math.pi * 2
            local rndDist = math.clamp(dist + math.random(-1, 1), 2, 20)
            local rndY = (height or 0) + math.random(-1, 2)
            local jitterPos = targetPos + Vector3.new(math.cos(ang) * rndDist, rndY, math.sin(ang) * rndDist)
            return jitterPos

        elseif posMode == 'Stay At Enable Position' then
            local safePos = (initialGroundCF and initialGroundCF.Position or targetPos) + Vector3.new(0, math.max(10, height or 25), 0)
            return safePos
        end

        local defaultOffset = Vector3.new(math.cos(orbitAngle) * dist, height or 2, math.sin(orbitAngle) * dist)
        return targetPos + defaultOffset
    end

    -- Wall LoS Solver for RageBot
    local function checkLoSToTarget(originPos, tPart, tPlayer)
        if hasLineOfSight(originPos, tPart.Position, tPlayer) then
            return true, tPart
        end
        if tPlayer and tPlayer.Character then
            local altPart = (tPart.Name == 'Head') and tPlayer.Character:FindFirstChild('HumanoidRootPart') or tPlayer.Character:FindFirstChild('Head')
            if altPart and hasLineOfSight(originPos, altPart.Position, tPlayer) then
                return true, altPart
            end
        end
        return false, tPart
    end

    local function solveLineOfSightPosition(targetPlayer, targetPart, candPos, baseDist, baseHeight)
        local targetPos = targetPart.Position
        local candHeadPos = candPos + Vector3.new(0, 1.5, 0)
        local losOk, validPart = checkLoSToTarget(candHeadPos, targetPart, targetPlayer)
        if losOk then
            return candPos, validPart
        end

        if Toggles.VoidLoSSolver and not Toggles.VoidLoSSolver.Value then
            return candPos, targetPart
        end

        -- Target is behind a wall or obstacle!
        -- 1. Try 8 radial angles around the target at baseDist
        local curAng = math.atan2(candPos.Z - targetPos.Z, candPos.X - targetPos.X)
        for i = 1, 7 do
            local sign = (i % 2 == 1) and 1 or -1
            local step = math.ceil(i / 2)
            local testAng = curAng + (sign * step * (math.pi / 4))
            local testPos = targetPos + Vector3.new(math.cos(testAng) * baseDist, baseHeight, math.sin(testAng) * baseDist)
            local testHead = testPos + Vector3.new(0, 1.5, 0)
            local ok, p = checkLoSToTarget(testHead, targetPart, targetPlayer)
            if ok then
                return testPos, p
            end
        end

        -- 2. Pull inward towards target to phase inside room/barrier
        local closeDistances = { 4.5, 3.2, 2.4, 1.8 }
        for _, d in ipairs(closeDistances) do
            if d < baseDist then
                local testPos = targetPos + Vector3.new(math.cos(curAng) * d, math.clamp(baseHeight, -0.2, 2.0), math.sin(curAng) * d)
                local testHead = testPos + Vector3.new(0, 1.5, 0)
                local ok, p = checkLoSToTarget(testHead, targetPart, targetPlayer)
                if ok then
                    return testPos, p
                end

                for i = 1, 7 do
                    local sign = (i % 2 == 1) and 1 or -1
                    local step = math.ceil(i / 2)
                    local testAng = curAng + (sign * step * (math.pi / 4))
                    local angPos = targetPos + Vector3.new(math.cos(testAng) * d, math.clamp(baseHeight, -0.2, 2.0), math.sin(testAng) * d)
                    local angHead = angPos + Vector3.new(0, 1.5, 0)
                    local aOk, aP = checkLoSToTarget(angHead, targetPart, targetPlayer)
                    if aOk then
                        return angPos, aP
                    end
                end
            end
        end

        -- 3. Point-blank fallbacks
        local tCF = targetPart.CFrame
        local flatLook = Vector3.new(tCF.LookVector.X, 0, tCF.LookVector.Z)
        if flatLook.Magnitude > 0.001 then flatLook = flatLook.Unit else flatLook = Vector3.new(0, 0, -1) end

        local pointBlankBehind = targetPos - (flatLook * 2.0) + Vector3.new(0, 0.5, 0)
        local ok1, p1 = checkLoSToTarget(pointBlankBehind + Vector3.new(0, 1.5, 0), targetPart, targetPlayer)
        if ok1 then return pointBlankBehind, p1 end

        local pointBlankAbove = targetPos + Vector3.new(0, 2.4, 0)
        local ok2, p2 = checkLoSToTarget(pointBlankAbove + Vector3.new(0, 1.5, 0), targetPart, targetPlayer)
        if ok2 then return pointBlankAbove, p2 end

        local pointBlankFront = targetPos + (flatLook * 2.0) + Vector3.new(0, 0.5, 0)
        local ok3, p3 = checkLoSToTarget(pointBlankFront + Vector3.new(0, 1.5, 0), targetPart, targetPlayer)
        if ok3 then return pointBlankFront, p3 end

        return pointBlankBehind, targetPart
    end

    local function snapToPosition(root, targetCF, method, dt)
        if not root or not root.Parent then return end

        local finalCF = targetCF
        if Toggles.VoidAntiTargetLock and Toggles.VoidAntiTargetLock.Value then
            local microJitter = Vector3.new(
                (math.random() - 0.5) * 0.45,
                (math.random() - 0.5) * 0.35,
                (math.random() - 0.5) * 0.45
            )
            finalCF = finalCF + microJitter
        end

        if method == 'Instant Teleport (0ms HvH Snap)' then
            root.CFrame = finalCF
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

        elseif method == 'Smooth Ultra-Glide' then
            local curPos = root.Position
            local targetPos = finalCF.Position
            local delta = targetPos - curPos
            local dist = delta.Magnitude
            if dist <= 0.8 or dist > 180 then
                root.CFrame = finalCF
            else
                local glideSpeed = 380
                local step = math.min(dist, glideSpeed * (dt or 0.016))
                local newPos = curPos + (delta.Unit * step)
                root.CFrame = CFrame.lookAt(newPos, targetPos + finalCF.LookVector * 2)
            end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

        elseif method == 'Blink Flank (In & Out)' then
            blinkTimer = blinkTimer + (dt or 0.016)
            if blinkPhase == 'strike' then
                root.CFrame = finalCF
                if blinkTimer >= 0.08 then
                    blinkPhase = 'evade'
                    blinkTimer = 0
                end
            else
                local evadeCF = finalCF + Vector3.new(0, 28, 0)
                root.CFrame = evadeCF
                if blinkTimer >= 0.12 then
                    blinkPhase = 'strike'
                    blinkTimer = 0
                end
            end
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        else
            root.CFrame = finalCF
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end

    local function performHvHAttack(targetPlayer, targetPart)
        if not targetPlayer or not targetPart then return end
        if not IsValidTarget(targetPlayer) then return end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        local root = char and char:FindFirstChild('HumanoidRootPart')
        if not char or not hum or hum.Health <= 0 or not root then return end

        local atkMode = (Options.VoidAttackType and Options.VoidAttackType.Value) or 'Gun & Melee'

        -- 1. Rapid Melee Punch (when within strike range)
        if atkMode == 'Gun & Melee' or atkMode == 'Melee Only (Punch)' then
            local myPos = root.Position
            local theirPos = targetPart.Position
            local dist = (myPos - theirPos).Magnitude

            if dist <= 9 and (tick() - lastMeleeTick >= 0.05) then
                lastMeleeTick = tick()
                local melee = getMeleeRemote()
                if melee then
                    pcall(function()
                        melee:FireServer(targetPlayer, 1, 1)
                    end)
                end
            end
        end

        -- 2. Gun Shot (Hitscan headshot with double tap and rapid fire integration)
        if atkMode == 'Gun & Melee' or atkMode == 'Gun Only' then
            local tool = char:FindFirstChildOfClass('Tool')
            if not tool and Toggles.VoidAutoEquip and Toggles.VoidAutoEquip.Value then
                tool = autoEquipBestWeapon(char, hum)
            end

            if tool and (gunConfigs[tool.Name] or tool:FindFirstChild('Muzzle')) then
                local cfg = getConfig(tool)
                if cfg then
                    local curAmmo = tool:GetAttribute('Local_CurrentAmmo') or tool:GetAttribute('CurrentAmmo') or 0
                    local isReloading = ((tool:GetAttribute('Local_ReloadSession') or 0) > 0) and (curAmmo <= 0)

                    if curAmmo <= 0 and not isReloading then
                        task.spawn(doReload, tool, cfg)
                    elseif not isReloading then
                        local minDelay = cfg.chargeTime or 0.12
                        if Toggles.FireRateChanger and Toggles.FireRateChanger.Value and (Toggles.FireRateApplyRage == nil or Toggles.FireRateApplyRage.Value) then
                            minDelay = calculateModifiedFireRate(tool.Name, minDelay)
                        end

                        if tick() - lastShotTick >= minDelay then
                            pcall(function()
                                fire(tool, targetPart, cfg)
                            end)
                        end
                    end
                end
            end
        end
    end

    local function getVoidTarget()
        local mode = (Options.VoidTargetMode and Options.VoidTargetMode.Value) or 'Nearest Enemy'
        local char = LP.Character
        local root = char and char:FindFirstChild('HumanoidRootPart')
        local myPos = root and root.Position or Vector3.zero

        if mode == 'Selected Player' then
            local selName = Options.VoidSelectedPlayer and Options.VoidSelectedPlayer.Value
            if selName and selName ~= 'None' then
                local p = Players:FindFirstChild(selName)
                if p and IsValidTarget(p) then
                    local pChar = p.Character
                    local part = pChar and (pChar:FindFirstChild('Head') or pChar:FindFirstChild('HumanoidRootPart'))
                    if part then return p, part end
                end
            end
            return nil, nil
        end

        if mode == 'Lowest HP (Executer)' then
            local bestP, bestPart, minHp = nil, nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and IsValidTarget(p) then
                    local pChar = p.Character
                    local hum = pChar and pChar:FindFirstChildOfClass('Humanoid')
                    local part = pChar and (pChar:FindFirstChild('Head') or pChar:FindFirstChild('HumanoidRootPart'))
                    if hum and part and hum.Health > 0 then
                        if hum.Health < minHp then
                            minHp = hum.Health
                            bestP = p
                            bestPart = part
                        end
                    end
                end
            end
            return bestP, bestPart
        end

        if mode == 'All Enemies (Carnage Cycle)' then
            local validList = {}
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and IsValidTarget(p) then
                    local pChar = p.Character
                    local part = pChar and (pChar:FindFirstChild('Head') or pChar:FindFirstChild('HumanoidRootPart'))
                    if part then
                        table.insert(validList, { player = p, part = part })
                    end
                end
            end
            if #validList == 0 then return nil, nil end

            local cycleDelay = (Options.VoidCycleDelay and Options.VoidCycleDelay.Value) or 0.12
            if tick() - lastCycleTick >= cycleDelay then
                lastCycleTick = tick()
                voidCycleIndex = (voidCycleIndex % #validList) + 1
            end

            if voidCycleIndex > #validList then voidCycleIndex = 1 end
            local entry = validList[voidCycleIndex]
            if entry then
                return entry.player, entry.part
            end
            return nil, nil
        end

        if mode == 'RageBot / Current' then
            if rageTargetPart and rageTargetPart.Parent then
                local p = Players:GetPlayerFromCharacter(rageTargetPart.Parent)
                if p and IsValidTarget(p) then return p, rageTargetPart end
            end
            if targetPartCache and targetPartCache.Parent then
                local p = Players:GetPlayerFromCharacter(targetPartCache.Parent)
                if p and IsValidTarget(p) then return p, targetPartCache end
            end
            local near = FindNearestTarget()
            if near and near.Parent then
                local p = Players:GetPlayerFromCharacter(near.Parent)
                if p and IsValidTarget(p) then return p, near end
            end
        end

        -- Default: Nearest Enemy
        local bestP, bestPart, minDist = nil, nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and IsValidTarget(p) then
                local pChar = p.Character
                local part = pChar and (pChar:FindFirstChild('Head') or pChar:FindFirstChild('HumanoidRootPart'))
                if part then
                    local d = (part.Position - myPos).Magnitude
                    if d < minDist then
                        minDist = d
                        bestP = p
                        bestPart = part
                    end
                end
            end
        end
        return bestP, bestPart
    end

    -- Continuous 60 FPS Flight Loop (No task.wait stutters, no gravity fall)
    local function onVoidHeartbeat(dt)
        if not voidRunning or not (Toggles.VoidAura and Toggles.VoidAura.Value) then
            return
        end

        local char = LP.Character
        local root = char and char:FindFirstChild('HumanoidRootPart')
        local hum = char and char:FindFirstChildOfClass('Humanoid')

        if not root or not hum or hum.Health <= 0 then
            return
        end

        ensureVoidBodyVelocity(root)
        pcall(function() hum.PlatformStand = true end)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        -- Void Reload Handler (teleports into void during weapon reload)
        local tool = char:FindFirstChildOfClass('Tool')
        local isReloading = false
        if tool then
            local session = tool:GetAttribute('Local_ReloadSession') or 0
            local curAmmo = tool:GetAttribute('Local_CurrentAmmo') or tool:GetAttribute('CurrentAmmo') or 0
            local maxAmmo = tool:GetAttribute('MaxAmmo') or 1
            if session > 0 and curAmmo < maxAmmo then
                isReloading = true
            end
        end

        local voidReloadEnabled = (Toggles.VoidReload == nil or Toggles.VoidReload.Value) and (Toggles.VoidAuraReloadInVoid == nil or Toggles.VoidAuraReloadInVoid.Value)
        if isReloading and voidReloadEnabled then
            local voidY = (Options.VoidReloadDepth and Options.VoidReloadDepth.Value) or -250
            local basePos = (currentVoidTargetPart and currentVoidTargetPart.Position) or (initialGroundCF and initialGroundCF.Position) or root.Position
            local voidCF = CFrame.new(basePos.X, voidY, basePos.Z)
            snapToPosition(root, voidCF, 'Instant Teleport (0ms HvH Snap)', dt)
            return
        end

        local targetPlayer, targetPart = getVoidTarget()
        currentVoidTargetPlayer = targetPlayer
        currentVoidTargetPart = targetPart

        local posMode = (Options.VoidPositionType and Options.VoidPositionType.Value) or '3D Cyclone Orbit (HvH)'
        local strikeMethod = (Options.VoidStrikeMethod and Options.VoidStrikeMethod.Value) or 'Instant Teleport (0ms HvH Snap)'
        local dist = (Options.VoidDistance and Options.VoidDistance.Value) or 4
        local height = (Options.VoidHeight and Options.VoidHeight.Value) or 2

        if targetPlayer and targetPart then
            -- 1. 3D Dynamic Flight Generator
            local idealPos = calculateHvHPosition(targetPart, posMode, dist, height, dt)

            -- 2. Wall LoS Solver (adjusts angle or breaches closer to ensure RageBot raycast hits)
            local finalPos, bestPart = solveLineOfSightPosition(targetPlayer, targetPart, idealPos, dist, height)
            currentVoidTargetPart = bestPart

            local targetCF = CFrame.lookAt(finalPos, targetPart.Position)
            snapToPosition(root, targetCF, strikeMethod, dt)
        else
            if initialGroundCF then
                local safeCF = initialGroundCF + Vector3.new(0, 30, 0)
                snapToPosition(root, safeCF, 'Instant Teleport (0ms HvH Snap)', dt)
            end
        end
    end

    -- Continuous Collision Bypass
    local function onVoidStepped()
        if voidRunning and Toggles.VoidNoclip and Toggles.VoidNoclip.Value then
            local char = LP.Character
            if char then
                applyVoidNoclip(char)
            end
        end
    end

    -- Dedicated Attack Loop (Decoupled from 60 FPS flight positioning)
    task.spawn(function()
        while true do
            local delayTime = (Options.VoidAttackDelay and Options.VoidAttackDelay.Value) or 0.03
            task.wait(math.clamp(delayTime, 0.01, 0.5))

            if not voidRunning or not (Toggles.VoidAura and Toggles.VoidAura.Value) then
                continue
            end

            if currentVoidTargetPlayer and currentVoidTargetPart then
                performHvHAttack(currentVoidTargetPlayer, currentVoidTargetPart)
            end
        end
    end)

    Toggles.VoidAura:OnChanged(function()
        if Toggles.VoidAura.Value then
            if voidRunning then return end
            voidRunning = true
            blinkTimer = 0
            blinkPhase = 'strike'
            local char = LP.Character
            local root = char and char:FindFirstChild('HumanoidRootPart')
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            if root then
                initialGroundCF = root.CFrame
                ensureVoidBodyVelocity(root)
            end
            if hum then
                pcall(function() hum.PlatformStand = true end)
            end
            if char and Toggles.VoidNoclip and Toggles.VoidNoclip.Value then
                applyVoidNoclip(char)
            end

            if not voidHeartbeatConn then
                voidHeartbeatConn = RunService.Heartbeat:Connect(onVoidHeartbeat)
            end
            if not voidSteppedConn then
                voidSteppedConn = RunService.Stepped:Connect(onVoidStepped)
            end
        else
            voidRunning = false
            currentVoidTargetPlayer = nil
            currentVoidTargetPart = nil

            if voidHeartbeatConn then
                voidHeartbeatConn:Disconnect()
                voidHeartbeatConn = nil
            end
            if voidSteppedConn then
                voidSteppedConn:Disconnect()
                voidSteppedConn = nil
            end

            cleanupVoidMovers()
            local char = LP.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            local root = char and char:FindFirstChild('HumanoidRootPart')
            if hum then
                pcall(function()
                    hum.PlatformStand = false
                    hum:ChangeState(Enum.HumanoidStateType.Freefall)
                end)
            end
            if root and initialGroundCF then
                root.CFrame = initialGroundCF
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
            end
            restoreVoidNoclip(char)
            initialGroundCF = nil
        end
    end)

    LP.CharacterAdded:Connect(function(newChar)
        if voidRunning and Toggles.VoidAura and Toggles.VoidAura.Value then
            task.wait(0.1)
            local root = newChar:WaitForChild('HumanoidRootPart', 3)
            local hum = newChar:WaitForChild('Humanoid', 3)
            if root then
                ensureVoidBodyVelocity(root)
            end
            if hum then
                pcall(function() hum.PlatformStand = true end)
            end
            if Toggles.VoidNoclip and Toggles.VoidNoclip.Value then
                applyVoidNoclip(newChar)
            end
        end
    end)

    local function updateVoidPlayers()
        if not Options.VoidSelectedPlayer then return end
        local names = { 'None' }
        for _, p in Players:GetPlayers() do
            if p ~= LP then
                table.insert(names, p.Name)
            end
        end
        Options.VoidSelectedPlayer.Values = names
        if Options.VoidSelectedPlayer.SetValues then
            Options.VoidSelectedPlayer:SetValues(names)
        end
    end
    Players.PlayerAdded:Connect(updateVoidPlayers)
    Players.PlayerRemoving:Connect(updateVoidPlayers)
    task.spawn(function()
        task.wait(1)
        updateVoidPlayers()
    end)
end

-- ESP
local espObjects = {}
local ESPFolder = Instance.new("Folder")
ESPFolder.Name = "CustomESP"
ESPFolder.Parent = game:GetService("CoreGui")

local function getPlayerCategory(player)
    if not player or player == LP then return nil end
    if player.Team == Teams.Inmates and player:GetAttribute('Hostile') then
        return 'Hostile'
    elseif player.Team == Teams.Inmates then
        return 'Inmate'
    elseif player.Team == Teams.Guards then
        return 'Guard'
    elseif player.Team == Teams.Criminals then
        return 'Criminal'
    end
    return nil
end

local function espColorForCategory(cat)
    if cat == 'Inmate' then return Options.ESPInmatesColor.Value end
    if cat == 'Guard' then return Options.ESPGuardsColor.Value end
    if cat == 'Hostile' then return Options.ESPHostileColor.Value end
    if cat == 'Criminal' then return Options.ESPCriminalsColor.Value end
    return Color3.new(1, 1, 1)
end

local function rainbowToggleForCategory(cat)
    if cat == 'Inmate' then return Toggles.ESPInmatesRainbow.Value end
    if cat == 'Guard' then return Toggles.ESPGuardsRainbow.Value end
    if cat == 'Hostile' then return Toggles.ESPHostileRainbow.Value end
    if cat == 'Criminal' then return Toggles.ESPCriminalsRainbow.Value end
    return false
end

local function playerHasShield(player, char)
    if not char then return false end
    if char:FindFirstChildOfClass("ForceField") then
        return true
    end
    if char:FindFirstChild("RiotShieldPart") or char:FindFirstChild("Riot Shield") then
        return true
    end
    local bp = player and player:FindFirstChild("Backpack")
    if bp and bp:FindFirstChild("Riot Shield") then
        return true
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and string.find(string.lower(child.Name), "shield") then
            return true
        end
    end
    return false
end

local function removeESP(player)
    local obj = espObjects[player]
    if obj then obj.cleanup() end
    espObjects[player] = nil
end

local function createESP(player)
    if espObjects[player] then return end
    local hl = nil
    local skeletonLines = {}
    local boxLines = {}
    local weaponText = nil
    local nameText = nil
    local hpCounter = nil
    local shieldText = nil

    local function makeLine()
        local l = Drawing.new("Line")
        l.Visible = false l.Color = Color3.new(1,1,1) l.Thickness = 1 l.Transparency = 1
        return l
    end

    local function worldToScreen(pos)
        local s, v = workspace.CurrentCamera:WorldToViewportPoint(pos)
        if v then return Vector2.new(s.X, s.Y) end
        return nil
    end

    local function getBoxBounds(char)
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        if not root or not head then return nil end
        local topLeft3D = root.Position + Vector3.new(-2, 3, 0)
        local topRight3D = root.Position + Vector3.new(2, 3, 0)
        local bottomLeft3D = root.Position + Vector3.new(-2, -3, 0)
        local bottomRight3D = root.Position + Vector3.new(2, -3, 0)
        local topScreen = worldToScreen(topLeft3D)
        local topRightScreen = worldToScreen(topRight3D)
        local bottomScreen = worldToScreen(bottomLeft3D)
        local bottomRightScreen = worldToScreen(bottomRight3D)
        if not topScreen or not topRightScreen or not bottomScreen or not bottomRightScreen then return nil end
        local minX = math.min(topScreen.X, topRightScreen.X, bottomScreen.X, bottomRightScreen.X)
        local maxX = math.max(topScreen.X, topRightScreen.X, bottomScreen.X, bottomRightScreen.X)
        local minY = math.min(topScreen.Y, topRightScreen.Y, bottomScreen.Y, bottomRightScreen.Y)
        local maxY = math.max(topScreen.Y, topRightScreen.Y, bottomScreen.Y, bottomRightScreen.Y)
        return Vector2.new(minX, minY), Vector2.new(maxX, maxY)
    end

    local function cleanupAll()
        if hl and hl.Parent then hl:Destroy() hl = nil end
        for _, l in pairs(skeletonLines) do pcall(function() l:Remove() end) end
        for _, l in pairs(boxLines) do pcall(function() l:Remove() end) end
        if weaponText then pcall(function() weaponText:Remove() end) weaponText = nil end
        if nameText then pcall(function() nameText:Remove() end) nameText = nil end
        if hpCounter then pcall(function() hpCounter:Remove() end) hpCounter = nil end
        if shieldText then pcall(function() shieldText:Remove() end) shieldText = nil end
        local obj = espObjects[player]
        if obj then
            if obj.healthBarBg then pcall(function() obj.healthBarBg:Remove() end) end
            if obj.healthBarFill then pcall(function() obj.healthBarFill:Remove() end) end
        end
        espObjects[player] = nil
    end

    espObjects[player] = {
        cleanup = cleanupAll,
        update = function()
            pcall(function()
                local char = player.Character
                if not char then cleanupAll() return end
                local hum = char:FindFirstChild("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                local head = char:FindFirstChild("Head")
                if not hum or not root or not head or hum.Health <= 0 then cleanupAll() return end

                local cat = getPlayerCategory(player)
                local ec = espColorForCategory(cat)
                if not ec then ec = Color3.new(1,1,1) end
                if cat and rainbowToggleForCategory(cat) then ec = Color3.fromHSV(rainbowHue, 1, 1) end

                -- Highlight
                if Toggles.ESPHighlight.Value then
                    if not hl or not hl.Parent then
                        hl = Instance.new("Highlight") hl.FillTransparency = 0.6 hl.OutlineTransparency = 0
                        hl.FillColor = ec hl.OutlineColor = ec hl.Adornee = char hl.Parent = ESPFolder
                    end
                    hl.FillColor = ec hl.OutlineColor = ec
                elseif hl and hl.Parent then hl:Destroy() hl = nil end

                -- Box ESP
                if Toggles.ESPBox.Value then
                    local tl, br = getBoxBounds(char)
                    if tl and br then
                        if not boxLines[1] then for i = 1, 4 do boxLines[i] = makeLine() end end
                        boxLines[1].From = Vector2.new(tl.X, tl.Y) boxLines[1].To = Vector2.new(br.X, tl.Y) boxLines[1].Color = ec boxLines[1].Thickness = 1.5 boxLines[1].Visible = true
                        boxLines[2].From = Vector2.new(tl.X, br.Y) boxLines[2].To = Vector2.new(br.X, br.Y) boxLines[2].Color = ec boxLines[2].Thickness = 1.5 boxLines[2].Visible = true
                        boxLines[3].From = Vector2.new(tl.X, tl.Y) boxLines[3].To = Vector2.new(tl.X, br.Y) boxLines[3].Color = ec boxLines[3].Thickness = 1.5 boxLines[3].Visible = true
                        boxLines[4].From = Vector2.new(br.X, tl.Y) boxLines[4].To = Vector2.new(br.X, br.Y) boxLines[4].Color = ec boxLines[4].Thickness = 1.5 boxLines[4].Visible = true
                    else for _, l in pairs(boxLines) do l.Visible = false end end
                else for _, l in pairs(boxLines) do l.Visible = false end end

                -- Name ESP
                if Toggles.ESPName.Value then
                    local tl2, br2 = getBoxBounds(char)
                    if tl2 and br2 then
                        if not nameText then
                            nameText = Drawing.new("Text")
                            nameText.Size = 14 nameText.Center = true nameText.Outline = true nameText.Font = 2
                        end
                        nameText.Position = Vector2.new((tl2.X + br2.X) / 2, tl2.Y - 16)
                        nameText.Text = (detectedCheaters and detectedCheaters[player]) and ('[CHEATER] ' .. player.Name) or player.Name
                        nameText.Color = ec
                        nameText.Visible = true
                    elseif nameText then nameText.Visible = false end
                elseif nameText then nameText.Visible = false end

                -- Skeleton ESP
                if Toggles.ESPSkeleton.Value then
                    local bones = {
                        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
                        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"LeftLowerArm", "LeftHand"},
                        {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
                        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LeftLowerLeg", "LeftFoot"},
                        {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"},
                    }
                    for i, pair in ipairs(bones) do
                        if not skeletonLines[i] then skeletonLines[i] = makeLine() end
                        local from = char:FindFirstChild(pair[1])
                        local to = char:FindFirstChild(pair[2])
                        if from and to then
                            local fs = worldToScreen(from.Position)
                            local ts = worldToScreen(to.Position)
                            if fs and ts then
                                skeletonLines[i].From = fs skeletonLines[i].To = ts
                                skeletonLines[i].Color = ec skeletonLines[i].Thickness = 1.5 skeletonLines[i].Visible = true
                            else skeletonLines[i].Visible = false end
                        else skeletonLines[i].Visible = false end
                    end
                else for _, l in pairs(skeletonLines) do l.Visible = false end end

                -- Health Bar
                if Toggles.ESPHealthBar.Value then
                    local tl2, br2 = getBoxBounds(char)
                    if tl2 and br2 then
                        local bw = 3
                        local bx = tl2.X - bw - 2
                        local bH = br2.Y - tl2.Y
                        if not espObjects[player].healthBarBg then
                            espObjects[player].healthBarBg = Drawing.new("Line")
                            espObjects[player].healthBarBg.ZIndex = 26
                        end
                        local bg = espObjects[player].healthBarBg
                        bg.From = Vector2.new(bx, tl2.Y)
                        bg.To = Vector2.new(bx, br2.Y)
                        bg.Color = Color3.new(0, 0, 0)
                        bg.Thickness = bw + 1
                        bg.Visible = true
                        local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        if not espObjects[player].healthBarFill then
                            espObjects[player].healthBarFill = Drawing.new("Line")
                            espObjects[player].healthBarFill.ZIndex = 27
                        end
                        local fill = espObjects[player].healthBarFill
                        fill.From = Vector2.new(bx, br2.Y)
                        fill.To = Vector2.new(bx, br2.Y - bH * hp)
                        fill.Color = ec
                        fill.Thickness = bw
                        fill.Visible = true
                    else
                        if espObjects[player].healthBarBg then espObjects[player].healthBarBg.Visible = false end
                        if espObjects[player].healthBarFill then espObjects[player].healthBarFill.Visible = false end
                    end
                else
                    if espObjects[player] and espObjects[player].healthBarBg then espObjects[player].healthBarBg.Visible = false end
                    if espObjects[player] and espObjects[player].healthBarFill then espObjects[player].healthBarFill.Visible = false end
                end

                -- HP Counter
                if Toggles.ESPHPCounter.Value then
                    local tl2, br2 = getBoxBounds(char)
                    if tl2 and br2 then
                        if not hpCounter then
                            hpCounter = Drawing.new("Text")
                            hpCounter.Size = 12 hpCounter.Center = true hpCounter.Outline = true hpCounter.Font = 2
                        end
                        hpCounter.Text = math.floor(hum.Health) .. "/" .. math.floor(hum.MaxHealth)
                        hpCounter.Position = Vector2.new(tl2.X - 25, (tl2.Y + br2.Y) / 2)
                        hpCounter.Color = ec
                        hpCounter.Visible = true
                    elseif hpCounter then hpCounter.Visible = false end
                elseif hpCounter then hpCounter.Visible = false end

                -- Weapon ESP
                if Toggles.ESPWeapon.Value then
                    local tl2, br2 = getBoxBounds(char)
                    if tl2 and br2 then
                        local tool = char:FindFirstChildOfClass("Tool")
                        local wName = tool and tool.Name or ""
                        if not weaponText then
                            weaponText = Drawing.new("Text")
                            weaponText.Size = 13 weaponText.Center = true weaponText.Outline = true weaponText.Font = 2
                        end
                        weaponText.Position = Vector2.new((tl2.X + br2.X) / 2, br2.Y + 5)
                        weaponText.Text = wName
                        weaponText.Color = ec
                        weaponText.Visible = wName ~= ""
                    elseif weaponText then weaponText.Visible = false end
                elseif weaponText then weaponText.Visible = false end

                -- Shield ESP
                if Toggles.ESPShield and Toggles.ESPShield.Value then
                    local hasShield = playerHasShield(player, char)
                    if hasShield then
                        local tl2, br2 = getBoxBounds(char)
                        if tl2 and br2 then
                            if not shieldText then
                                shieldText = Drawing.new("Text")
                                shieldText.Size = 13
                                shieldText.Center = false
                                shieldText.Outline = true
                                shieldText.Font = 2
                            end
                            local shieldCol = (Options.ESPShieldColor and Options.ESPShieldColor.Value) or Color3.fromRGB(0, 180, 255)
                            if Toggles.ESPShieldRainbow and Toggles.ESPShieldRainbow.Value then
                                shieldCol = Color3.fromHSV(rainbowHue, 1, 1)
                            end
                            shieldText.Position = Vector2.new(br2.X + 6, (tl2.Y + br2.Y) / 2 - 6)
                            shieldText.Text = "Shield"
                            shieldText.Color = shieldCol
                            shieldText.Visible = true
                        elseif shieldText then
                            shieldText.Visible = false
                        end
                    elseif shieldText then
                        shieldText.Visible = false
                    end
                elseif shieldText then
                    shieldText.Visible = false
                end
            end)
        end
    }
end

Players.PlayerRemoving:Connect(removeESP)

RunService.RenderStepped:Connect(function()
    if not Toggles.ESP.Value then
        local players = {}
        for player, _ in pairs(espObjects) do table.insert(players, player) end
        for _, player in ipairs(players) do removeESP(player) end
        for _, child in ESPFolder:GetChildren() do child:Destroy() end
        return
    end
    for _, player in Players:GetPlayers() do
        if player ~= LP then
            if not espObjects[player] then createESP(player) end
            if espObjects[player] then espObjects[player].update() end
        end
    end
end)



-- Ambience & Stretch Resolution
do
local origAmbient = Lighting.Ambient
local origBrightness = Lighting.Brightness
local origClockTime = Lighting.ClockTime

local ambienceHue = 0
RunService.RenderStepped:Connect(function()
    if Toggles.Ambience.Value then
        local ambColor = Options.AmbienceColor.Value
        if Toggles.AmbienceRainbow.Value then
            ambColor = Color3.fromHSV(ambienceHue, 1, 1)
        end
        Lighting.Ambient = ambColor
        Lighting.Brightness = Options.AmbienceBrightness.Value
        Lighting.OutdoorAmbient = ambColor
    else
        Lighting.Ambient = origAmbient
        Lighting.Brightness = origBrightness
    end
    if Toggles.CustomTime.Value then
        Lighting.ClockTime = Options.CustomTimeValue.Value
    else
        Lighting.ClockTime = origClockTime
    end
    ambienceHue = (ambienceHue + Options.RainbowSpeed.Value * 0.005) % 1
    rainbowHue = (rainbowHue + Options.RainbowSpeed.Value * 0.005) % 1
end)

-- Stretch Resolution
local stretchConn
local function updateStretch()
    if Toggles.StretchResolution.Value then
        if stretchConn then return end
        stretchConn = RunService.RenderStepped:Connect(function()
            local cam = Workspace.CurrentCamera
            if not cam then return end
            local res = (Options.StretchResolutionValue and Options.StretchResolutionValue.Value) or 0.80
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, res, 0, 0, 0, 1)
        end)
    else
        if stretchConn then
            stretchConn:Disconnect()
            stretchConn = nil
        end
    end
end
Toggles.StretchResolution:OnChanged(updateStretch)


end

do
-- ====================== MISC ======================
local SoundsGroup = Tabs.Misc:AddLeftGroupbox('Sounds')

Toggles.Hitsound = SoundsGroup:AddToggle('Hitsound', { Text = 'Hitsound', Default = false })
Options.HitsoundSelect = SoundsGroup:AddDropdown('HitsoundSelect', { Text = 'Hit Sound', Default = 5, Values = { 'Fatality', 'Skeet', 'Bell', 'COD', 'Metal', 'TF2 Critical', 'TF2', 'Rust' } })
Options.HitsoundVolume = SoundsGroup:AddSlider('HitsoundVolume', { Text = 'Hit Sound Volume', Default = 60, Min = 1, Max = 100, Rounding = 0, Compact = false })
SoundsGroup:AddButton('Test Hitsound', function()
    if playHitsound then playHitsound(true) end
end)

SoundsGroup:AddDivider()

Toggles.Killsound = SoundsGroup:AddToggle('Killsound', { Text = 'Kill Sound', Default = false })
Options.KillsoundSelect = SoundsGroup:AddDropdown('KillsoundSelect', { Text = 'Kill Sound', Default = 1, Values = { 'Fatality', 'Skeet', 'Bell', 'COD', 'Metal', 'TF2 Critical', 'TF2', 'Rust' } })
Options.KillsoundVolume = SoundsGroup:AddSlider('KillsoundVolume', { Text = 'Kill Sound Volume', Default = 80, Min = 1, Max = 100, Rounding = 0, Compact = false })
SoundsGroup:AddButton('Test Kill Sound', function()
    if playKillsound then playKillsound(true) end
end)

local MiscGroup = Tabs.Misc:AddLeftGroupbox('Misc')
Toggles.Invisible = MiscGroup:AddToggle('Invisible', { Text = 'Invisible', Default = false, Tooltip = 'Desyncs character CFrame to make you invisible to other players' })
Toggles.Invisible:AddKeyPicker('InvisibleBind', { Default = 'None', SyncToggleState = false, Modes = { 'Toggle', 'Hold', 'Always' }, Text = 'Invisible' })
Toggles.AntiInvisible = MiscGroup:AddToggle('AntiInvisible', { Text = 'Anti Invisible', Default = false, Tooltip = 'Reveals invisible exploiters by nullifying desync animation weight' })
Toggles.AntiSit = MiscGroup:AddToggle('AntiSit', { Text = 'Anti Sit', Default = false, Tooltip = 'Prevents sitting in chairs/benches while keeping vehicle seats usable' })

MiscGroup:AddDivider()
Toggles.FPSUnlocker = MiscGroup:AddToggle('FPSUnlocker', { Text = 'FPS Unlocker', Default = false })
Options.FPSTarget = MiscGroup:AddSlider('FPSTarget', { Text = 'FPS Target', Default = 240, Min = 240, Max = 1000, Rounding = 0, Compact = false })

Toggles.FPSUnlocker:OnChanged(function()
    if Toggles.FPSUnlocker.Value then
        setfpscap(Options.FPSTarget.Value)
    else
        setfpscap(60)
    end
end)

Options.FPSTarget:OnChanged(function()
    if Toggles.FPSUnlocker.Value then
        setfpscap(Options.FPSTarget.Value)
    end
end)

    -- Tabs.Misc Right Tabbox (Roblox Optimizer)
    local OptimizerBox = Tabs.Misc:AddRightTabbox()
    local OptTab = OptimizerBox:AddTab('Optimizer')

    Toggles.Optimizer = OptTab:AddToggle('Optimizer', { Text = 'Enable Optimizer', Default = false, Tooltip = 'Boosts FPS by reducing heavy graphics & effects' })

    local OptDep = OptTab:AddDependencyBox()
    OptDep:SetupDependencies({ { Toggles.Optimizer, true } })

    Options.OptimizerPreset = OptDep:AddDropdown('OptimizerPreset', {
        Values = { 'Max FPS (Potato)', 'Balanced Boost', 'Custom' },
        Default = 2,
        Multi = false,
        Text = 'Preset'
    })

    OptDep:AddDivider()

    Toggles.OptGlobalShadows = OptDep:AddToggle('OptGlobalShadows', { Text = 'Disable Global Shadows', Default = true })
    Toggles.OptSmoothMaterials = OptDep:AddToggle('OptSmoothMaterials', { Text = 'Smooth Materials (Plastic)', Default = true, Tooltip = 'Replaces heavy surface materials with SmoothPlastic' })
    Toggles.OptRemoveTextures = OptDep:AddToggle('OptRemoveTextures', { Text = 'Disable Decals & Textures', Default = false, Tooltip = 'Makes decals and textures invisible' })
    Toggles.OptDisableParticles = OptDep:AddToggle('OptDisableParticles', { Text = 'Disable Particles & Effects', Default = true, Tooltip = 'Disables ParticleEmitters, Smoke, Fire, Trails, Beams' })
    Toggles.OptDisablePostEffects = OptDep:AddToggle('OptDisablePostEffects', { Text = 'Disable Post-FX (Blur/Bloom)', Default = true, Tooltip = 'Disables Blur, Bloom, SunRays, Atmosphere' })
    Toggles.OptLowTerrain = OptDep:AddToggle('OptLowTerrain', { Text = 'Low Quality Terrain / Water', Default = true, Tooltip = 'Disables water waves, reflections, and grass' })
    Toggles.OptOptimizeNew = OptDep:AddToggle('OptOptimizeNew', { Text = 'Auto-Optimize New Objects', Default = true, Tooltip = 'Applies optimization to newly spawned objects' })

    OptDep:AddDivider()

    OptDep:AddButton({
        Text = 'Force Optimize Workspace',
        Func = function()
            if _G.BoarsForceOptimize then
                _G.BoarsForceOptimize()
            end
        end
    })

    OptDep:AddButton({
        Text = 'Restore Original Graphics',
        Func = function()
            if _G.BoarsRestoreGraphics then
                _G.BoarsRestoreGraphics()
            end
        end
    })

-- ====================== INVISIBLE, ANTI-INVISIBLE & ANTI-SIT ======================
do
    -- ============ INVISIBLE (A2Flacko Precision Method) ============
    local InvisibleRealCFrame = nil
    local InvisibleAnimationTrack = nil
    local InvisibleRenderKey = "BoarsInvisibleRender"
    local InvisibleOriginalTransparency = {}
    local InvisibleOriginalCanCollide = {}

    local function loadInvisibleAnimation(character)
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return nil end
        local animator = humanoid:FindFirstChildOfClass("Animator")
        if not animator then return nil end
        local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
        local animation = Instance.new("Animation")
        animation.AnimationId = isR15 and "rbxassetid://18665825805" or "rbxassetid://215384594"
        local track = animator:LoadAnimation(animation)
        track.Priority = Enum.AnimationPriority.Action4
        track:Play(0, 0.001, 0)
        animation:Destroy()
        task.delay(0, function()
            if track and track.IsPlaying then
                track.TimePosition = isR15 and 1.95 or 0.4
            end
        end)
        return track
    end

    local function stopInvisible()
        pcall(function()
            RunService:UnbindFromRenderStep(InvisibleRenderKey)
        end)
        if InvisibleAnimationTrack then
            pcall(function()
                InvisibleAnimationTrack:Stop()
                InvisibleAnimationTrack:Destroy()
            end)
            InvisibleAnimationTrack = nil
        end
        local character = LP.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if rootPart and InvisibleRealCFrame then
            rootPart.CFrame = InvisibleRealCFrame
            local currentVelocity = rootPart.AssemblyLinearVelocity or rootPart.Velocity
            pcall(function()
                rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
            end)
        end
        InvisibleRealCFrame = nil

        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part ~= rootPart then
                    if InvisibleOriginalTransparency[part] ~= nil then
                        part.Transparency = InvisibleOriginalTransparency[part]
                    end
                    if InvisibleOriginalCanCollide[part] ~= nil then
                        part.CanCollide = InvisibleOriginalCanCollide[part]
                    end
                end
            end
            if rootPart then
                rootPart.Transparency = 1
            end
        end
        table.clear(InvisibleOriginalTransparency)
        table.clear(InvisibleOriginalCanCollide)
    end

    local function startInvisible()
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        InvisibleAnimationTrack = loadInvisibleAnimation(character)
        InvisibleRealCFrame = nil

        table.clear(InvisibleOriginalTransparency)
        table.clear(InvisibleOriginalCanCollide)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= rootPart then
                InvisibleOriginalTransparency[part] = part.Transparency
                InvisibleOriginalCanCollide[part] = part.CanCollide
                part.Transparency = 0.5
                part.CanCollide = false
            end
        end
        rootPart.Transparency = 1

        pcall(function()
            RunService:UnbindFromRenderStep(InvisibleRenderKey)
        end)

        RunService:BindToRenderStep(InvisibleRenderKey, Enum.RenderPriority.Camera.Value - 1, function()
            if Toggles.Invisible and Toggles.Invisible.Value and InvisibleRealCFrame and rootPart.Parent then
                rootPart.CFrame = InvisibleRealCFrame
                if InvisibleAnimationTrack then
                    InvisibleAnimationTrack:AdjustWeight(0.001)
                end
            end
        end)
    end

    RunService.Heartbeat:Connect(function()
        if not (Toggles.Invisible and Toggles.Invisible.Value) then return end
        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not rootPart then return end

        local isR15 = humanoid.RigType == Enum.HumanoidRigType.R15
        local dropOffset = humanoid.HipHeight + (rootPart.Size.Y / 2) - 1
        InvisibleRealCFrame = rootPart.CFrame
        rootPart.CFrame = (rootPart.CFrame - Vector3.new(0, dropOffset, 0)) * CFrame.Angles(math.rad(isR15 and 180 or 90), 0, 0)
        local currentVelocity = rootPart.AssemblyLinearVelocity or rootPart.Velocity
        pcall(function()
            rootPart.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
        end)
        if InvisibleAnimationTrack then
            InvisibleAnimationTrack:AdjustWeight(100)
        end
    end)

    LP.CharacterAdded:Connect(function(character)
        if Toggles.Invisible and Toggles.Invisible.Value then
            task.wait(0.5)
            startInvisible()
        end
    end)

    Toggles.Invisible:OnChanged(function()
        if Toggles.Invisible.Value then
            startInvisible()
        else
            stopInvisible()
        end
    end)

    getgenv().SetInvisibleEnabled = function(v)
        if Toggles.Invisible then
            Toggles.Invisible:SetValue(v == true)
        end
    end

    -- ============ ANTI INVISIBLE ============
    local AntiInvisibleThreads = {}
    local AntiInvisibleConnections = {}
    local AntiInvisibleWhitelist = {
        ["http://www.roblox.com/asset/?id=125750702"] = true,
        ["http://www.roblox.com/asset/?id=128777973"] = true,
        ["http://www.roblox.com/asset/?id=128853357"] = true,
        ["http://www.roblox.com/asset/?id=129423030"] = true,
        ["http://www.roblox.com/asset/?id=129423131"] = true,
        ["http://www.roblox.com/asset/?id=129967390"] = true,
        ["http://www.roblox.com/asset/?id=129967478"] = true,
        ["http://www.roblox.com/asset/?id=178130996"] = true,
        ["http://www.roblox.com/asset/?id=180426354"] = true,
        ["http://www.roblox.com/asset/?id=180435571"] = true,
        ["http://www.roblox.com/asset/?id=180435792"] = true,
        ["http://www.roblox.com/asset/?id=180436148"] = true,
        ["http://www.roblox.com/asset/?id=180436334"] = true,
        ["http://www.roblox.com/asset/?id=182393478"] = true,
        ["http://www.roblox.com/asset/?id=182435998"] = true,
        ["http://www.roblox.com/asset/?id=182436842"] = true,
        ["http://www.roblox.com/asset/?id=182436935"] = true,
        ["http://www.roblox.com/asset/?id=182491037"] = true,
        ["http://www.roblox.com/asset/?id=182491065"] = true,
        ["http://www.roblox.com/asset/?id=182491248"] = true,
        ["http://www.roblox.com/asset/?id=182491277"] = true,
        ["http://www.roblox.com/asset/?id=182491368"] = true,
        ["http://www.roblox.com/asset/?id=182491423"] = true,
        ["rbxassetid://279227693"] = true,
        ["rbxassetid://279229192"] = true,
        ["rbxassetid://287112271"] = true,
        ["rbxassetid://388723916"] = true,
        ["rbxassetid://388726667"] = true,
        ["rbxassetid://389472570"] = true,
        ["rbxassetid://405194080"] = true,
        ["rbxassetid://405212265"] = true,
        ["rbxassetid://481088553"] = true,
        ["rbxassetid://481089053"] = true,
        ["rbxassetid://484200742"] = true,
        ["rbxassetid://484926359"] = true,
        ["rbxassetid://83690472549256"] = true,
        ["rbxassetid://107176344504758"] = true,
        ["rbxassetid://111090572475133"] = true,
        ["rbxassetid://113267949064300"] = true,
        ["rbxassetid://131326339350805"] = true,
    }

    pcall(function()
        for _, animation in ipairs(ReplicatedStorage:GetDescendants()) do
            if animation:IsA("Animation") then
                AntiInvisibleWhitelist[animation.AnimationId] = true
            end
        end
    end)

    local function watchAnimationTrack(track)
        local animationId = track.Animation and track.Animation.AnimationId
        if not animationId then return end
        local isExploitAnim = (animationId == "rbxassetid://18665825805" or animationId == "rbxassetid://215384594")
        if not isExploitAnim and AntiInvisibleWhitelist[animationId] then return end

        if AntiInvisibleThreads[track] then
            task.cancel(AntiInvisibleThreads[track])
        end
        AntiInvisibleThreads[track] = task.spawn(function()
            repeat
                track:AdjustWeight(0, 0)
                task.wait()
            until not (track.IsPlaying and Toggles.AntiInvisible and Toggles.AntiInvisible.Value)
            AntiInvisibleThreads[track] = nil
        end)
    end

    local function hookCharacterAnimations(character)
        local humanoid = character:WaitForChild("Humanoid", 5)
        if not humanoid then return end
        local animator = humanoid:WaitForChild("Animator", 5)
        if not animator then return end

        local connection = animator.AnimationPlayed:Connect(function(track)
            if Toggles.AntiInvisible and Toggles.AntiInvisible.Value then
                watchAnimationTrack(track)
            end
        end)
        AntiInvisibleConnections[character] = connection

        for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
            if Toggles.AntiInvisible and Toggles.AntiInvisible.Value then
                watchAnimationTrack(track)
            end
        end
    end

    local function hookPlayerAnimations(plr)
        if plr == LP then return end
        if plr.Character then
            task.spawn(hookCharacterAnimations, plr.Character)
        end
        plr.CharacterAdded:Connect(function(character)
            task.spawn(hookCharacterAnimations, character)
        end)
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        hookPlayerAnimations(plr)
    end
    Players.PlayerAdded:Connect(hookPlayerAnimations)

    Toggles.AntiInvisible:OnChanged(function()
        if Toggles.AntiInvisible.Value then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local anim = hum and hum:FindFirstChildOfClass("Animator")
                    if anim then
                        for _, track in ipairs(anim:GetPlayingAnimationTracks()) do
                            watchAnimationTrack(track)
                        end
                    end
                end
            end
        end
    end)

    getgenv().SetAntiInvisibleEnabled = function(v)
        if Toggles.AntiInvisible then
            Toggles.AntiInvisible:SetValue(v == true)
        end
    end

    -- ============ ANTI SIT ============
    local antiSitConnections = {}

    local function disconnectAntiSit()
        for _, connection in ipairs(antiSitConnections) do
            pcall(function() connection:Disconnect() end)
        end
        table.clear(antiSitConnections)
    end

    local function hookAntiSit(char)
        disconnectAntiSit()
        if not char then return end

        local humanoid = char:WaitForChild("Humanoid", 5)
        if not humanoid then return end

        local conn = humanoid.Seated:Connect(function(active, seatPart)
            if not (Toggles.AntiSit and Toggles.AntiSit.Value) then return end
            if active and seatPart and not seatPart:IsA("VehicleSeat") then
                humanoid.Jump = true
                humanoid.Sit = false
            end
        end)
        table.insert(antiSitConnections, conn)

        local propConn = humanoid:GetPropertyChangedSignal("Sit"):Connect(function()
            if not (Toggles.AntiSit and Toggles.AntiSit.Value) then return end
            if humanoid.Sit and humanoid.SeatPart and not humanoid.SeatPart:IsA("VehicleSeat") then
                humanoid.Jump = true
                humanoid.Sit = false
            end
        end)
        table.insert(antiSitConnections, propConn)
    end

    if LP.Character then
        hookAntiSit(LP.Character)
    end
    LP.CharacterAdded:Connect(hookAntiSit)

    Toggles.AntiSit:OnChanged(function()
        if Toggles.AntiSit.Value and LP.Character then
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Sit and hum.SeatPart and not hum.SeatPart:IsA("VehicleSeat") then
                hum.Jump = true
                hum.Sit = false
            end
        end
    end)

    getgenv().SetAntiSitEnabled = function(v)
        if Toggles.AntiSit then
            Toggles.AntiSit:SetValue(v == true)
        end
    end

    _G.BoarsCleanupInvisibleAndSit = function()
        pcall(stopInvisible)
        disconnectAntiSit()
        for _, thread in pairs(AntiInvisibleThreads) do
            pcall(function() task.cancel(thread) end)
        end
        for _, conn in pairs(AntiInvisibleConnections) do
            pcall(function() conn:Disconnect() end)
        end
    end
end


-- UI Settings
local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')
MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'RightShift', NoUI = true, Text = 'Menu keybind' })


Library.ToggleKeybind = Options.MenuKeybind

Library.KeybindFrame.Visible = true

Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local FPS = 60

RunService.RenderStepped:Connect(function()
    FrameCounter += 1
    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter
        FrameTimer = tick()
        FrameCounter = 0
    end
    pcall(function()
        Library:SetWatermark(('boars.hit | %s fps | %s ms'):format(
            math.floor(FPS),
            math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
        ))
    end)
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('Boars')
SaveManager:SetFolder('Boars/PrisonLife')

-- Custom Config Section
local ConfigBox = Tabs['UI Settings']:AddRightGroupbox('Configuration')
ConfigBox:AddInput('SaveManager_ConfigName', { Text = 'Config name' })
ConfigBox:AddDropdown('SaveManager_ConfigList', { Text = 'Config list', Values = SaveManager:RefreshConfigList(), AllowNull = true })
ConfigBox:AddDivider()

ConfigBox:AddButton('Create config', function()
    local name = Options.SaveManager_ConfigName.Value
    if name:gsub(' ', '') == '' then return Library:Notify('Invalid config name', 2) end
    local ok, err = SaveManager:Save(name)
    if not ok then return Library:Notify('Failed: ' .. err, 2) end
    Library:Notify('Created config "' .. name .. '"')
    Options.SaveManager_ConfigList:SetValues(SaveManager:RefreshConfigList())
    Options.SaveManager_ConfigList:SetValue(nil)
end):AddButton('Load config', function()
    local name = Options.SaveManager_ConfigList.Value
    local ok, err = SaveManager:Load(name)
    if not ok then return Library:Notify('Failed: ' .. err, 2) end
    Library:Notify('Loaded config "' .. name .. '"')
end)

ConfigBox:AddButton({
    Text = 'Overwrite config',
    DoubleClick = true,
    Func = function()
        local name = Options.SaveManager_ConfigList.Value
        if not name then return Library:Notify('Select a config first', 2) end
        local ok, err = SaveManager:Save(name)
        if not ok then return Library:Notify('Failed: ' .. err, 2) end
        Library:Notify('Overwrote config "' .. name .. '"')
    end
})

ConfigBox:AddButton('Refresh list', function()
    Options.SaveManager_ConfigList:SetValues(SaveManager:RefreshConfigList())
    Options.SaveManager_ConfigList:SetValue(nil)
end)

ConfigBox:AddButton('Set as autoload', function()
    local name = Options.SaveManager_ConfigList.Value
    if not name then return Library:Notify('Select a config first', 2) end
    writefile(SaveManager.Folder .. '/settings/autoload.txt', name)
    SaveManager.AutoloadLabel:SetText('Autoload: ' .. name)
    Library:Notify('Set "' .. name .. '" to autoload')
end)

SaveManager.AutoloadLabel = ConfigBox:AddLabel('Autoload: none', true)
if isfile(SaveManager.Folder .. '/settings/autoload.txt') then
    local name = readfile(SaveManager.Folder .. '/settings/autoload.txt')
    SaveManager.AutoloadLabel:SetText('Autoload: ' .. name)
end

SaveManager:SetIgnoreIndexes({ 'SaveManager_ConfigList', 'SaveManager_ConfigName' })

ThemeManager:ApplyToTab(Tabs['UI Settings'])
end


-- Target HUD (Linoria Style)
do
    local hudGui = Instance.new('ScreenGui')
    hudGui.Name = 'BoarsTargetHUD'
    hudGui.ResetOnSpawn = false
    hudGui.DisplayOrder = 9500
    hudGui.IgnoreGuiInset = true

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(hudGui)
            hudGui.Parent = game:GetService('CoreGui')
        elseif gethui then
            hudGui.Parent = gethui()
        else
            hudGui.Parent = game:GetService('CoreGui')
        end
    end)
    if not hudGui.Parent then
        pcall(function() hudGui.Parent = LP:WaitForChild('PlayerGui') end)
    end

    local defaultPos = UDim2.new(0.5, -135, 0.68, 0)
    local hudContainer
    local isCanvasGroup = false
    pcall(function()
        hudContainer = Instance.new('CanvasGroup')
        isCanvasGroup = true
    end)
    if not hudContainer then
        hudContainer = Instance.new('Frame')
        isCanvasGroup = false
    end

    hudContainer.Name = 'HUDContainer'
    hudContainer.Size = UDim2.new(0, 270, 0, 88)
    hudContainer.Position = defaultPos
    hudContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    hudContainer.BorderColor3 = Color3.fromRGB(45, 45, 45)
    hudContainer.BorderSizePixel = 1
    hudContainer.Visible = false
    hudContainer.Parent = hudGui

    _G.BoarsResetTargetHUD = function()
        if hudContainer then
            hudContainer.Position = defaultPos
        end
    end

    -- Outer 1px black border for Linoria dual-border aesthetic
    local outerBorder = Instance.new('UIStroke')
    outerBorder.Color = Color3.fromRGB(10, 10, 10)
    outerBorder.Thickness = 1
    outerBorder.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    outerBorder.Parent = hudContainer

    -- Top Accent Bar (Signature Linoria 2px bar)
    local accentBar = Instance.new('Frame')
    accentBar.Name = 'AccentBar'
    accentBar.Size = UDim2.new(1, 0, 0, 2)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BorderSizePixel = 0
    accentBar.BackgroundColor3 = Library.AccentColor or Color3.fromRGB(0, 170, 255)
    accentBar.Parent = hudContainer

    -- Top Header Row
    local headerTitle = Instance.new('TextLabel')
    headerTitle.Name = 'HeaderTitle'
    headerTitle.Size = UDim2.new(0.5, 0, 0, 14)
    headerTitle.Position = UDim2.new(0, 6, 0, 4)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Font = Enum.Font.Code
    headerTitle.TextSize = 10
    headerTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Text = 'TARGET HUD'
    headerTitle.Parent = hudContainer

    local distLabel = Instance.new('TextLabel')
    distLabel.Name = 'DistLabel'
    distLabel.Size = UDim2.new(0.5, -12, 0, 14)
    distLabel.Position = UDim2.new(0.5, 0, 0, 4)
    distLabel.BackgroundTransparency = 1
    distLabel.Font = Enum.Font.Code
    distLabel.TextSize = 10
    distLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    distLabel.TextXAlignment = Enum.TextXAlignment.Right
    distLabel.Text = ''
    distLabel.Parent = hudContainer

    -- Avatar Box
    local avatarFrame = Instance.new('Frame')
    avatarFrame.Name = 'AvatarFrame'
    avatarFrame.Size = UDim2.new(0, 52, 0, 52)
    avatarFrame.Position = UDim2.new(0, 6, 0, 22)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    avatarFrame.BorderColor3 = Color3.fromRGB(40, 40, 40)
    avatarFrame.BorderSizePixel = 1
    avatarFrame.Parent = hudContainer

    local avatarImg = Instance.new('ImageLabel')
    avatarImg.Name = 'AvatarImg'
    avatarImg.Size = UDim2.new(1, -2, 1, -2)
    avatarImg.Position = UDim2.new(0, 1, 0, 1)
    avatarImg.BackgroundTransparency = 1
    avatarImg.BorderSizePixel = 0
    avatarImg.Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png'
    avatarImg.ScaleType = Enum.ScaleType.Fit
    avatarImg.Parent = avatarFrame

    -- Info Container (right of avatar)
    local infoContainer = Instance.new('Frame')
    infoContainer.Name = 'InfoContainer'
    infoContainer.Size = UDim2.new(1, -70, 0, 60)
    infoContainer.Position = UDim2.new(0, 64, 0, 20)
    infoContainer.BackgroundTransparency = 1
    infoContainer.BorderSizePixel = 0
    infoContainer.Parent = hudContainer

    -- Row 1: Target Name & Team Badge
    local nameLabel = Instance.new('TextLabel')
    nameLabel.Name = 'NameLabel'
    nameLabel.Size = UDim2.new(1, -60, 0, 15)
    nameLabel.Position = UDim2.new(0, 0, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Font = Enum.Font.Code
    nameLabel.TextSize = 12
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    nameLabel.Text = 'Target'
    nameLabel.Parent = infoContainer

    local teamBadge = Instance.new('TextLabel')
    teamBadge.Name = 'TeamBadge'
    teamBadge.Size = UDim2.new(0, 58, 0, 15)
    teamBadge.Position = UDim2.new(1, -58, 0, 0)
    teamBadge.BackgroundTransparency = 1
    teamBadge.Font = Enum.Font.Code
    teamBadge.TextSize = 10
    teamBadge.TextColor3 = Color3.fromRGB(200, 200, 200)
    teamBadge.TextXAlignment = Enum.TextXAlignment.Right
    teamBadge.Text = ''
    teamBadge.Parent = infoContainer

    -- Row 2: Weapon
    local weaponLabel = Instance.new('TextLabel')
    weaponLabel.Name = 'WeaponLabel'
    weaponLabel.Size = UDim2.new(1, 0, 0, 14)
    weaponLabel.Position = UDim2.new(0, 0, 0, 15)
    weaponLabel.BackgroundTransparency = 1
    weaponLabel.Font = Enum.Font.Code
    weaponLabel.TextSize = 10
    weaponLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    weaponLabel.TextXAlignment = Enum.TextXAlignment.Left
    weaponLabel.TextTruncate = Enum.TextTruncate.AtEnd
    weaponLabel.Text = 'Weapon: None'
    weaponLabel.Parent = infoContainer

    -- Row 3: Health Bar Background & Fill
    local hpBarBack = Instance.new('Frame')
    hpBarBack.Name = 'HPBarBack'
    hpBarBack.Size = UDim2.new(1, 0, 0, 6)
    hpBarBack.Position = UDim2.new(0, 0, 0, 31)
    hpBarBack.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
    hpBarBack.BorderColor3 = Color3.fromRGB(38, 38, 38)
    hpBarBack.BorderSizePixel = 1
    hpBarBack.Parent = infoContainer

    local hpBarFill = Instance.new('Frame')
    hpBarFill.Name = 'HPBarFill'
    hpBarFill.Size = UDim2.new(1, 0, 1, 0)
    hpBarFill.BorderSizePixel = 0
    hpBarFill.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    hpBarFill.Parent = hpBarBack

    -- Row 4: Health Text & Kill Chance
    local hpText = Instance.new('TextLabel')
    hpText.Name = 'HPText'
    hpText.Size = UDim2.new(0.55, 0, 0, 14)
    hpText.Position = UDim2.new(0, 0, 0, 39)
    hpText.BackgroundTransparency = 1
    hpText.Font = Enum.Font.Code
    hpText.TextSize = 10
    hpText.TextColor3 = Color3.fromRGB(210, 210, 210)
    hpText.TextXAlignment = Enum.TextXAlignment.Left
    hpText.Text = '100 / 100 HP'
    hpText.Parent = infoContainer

    local killChanceLabel = Instance.new('TextLabel')
    killChanceLabel.Name = 'KillChanceLabel'
    killChanceLabel.Size = UDim2.new(0.45, 0, 0, 14)
    killChanceLabel.Position = UDim2.new(0.55, 0, 0, 39)
    killChanceLabel.BackgroundTransparency = 1
    killChanceLabel.Font = Enum.Font.Code
    killChanceLabel.TextSize = 10
    killChanceLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
    killChanceLabel.TextXAlignment = Enum.TextXAlignment.Right
    killChanceLabel.Text = 'Chance: 95%'
    killChanceLabel.Parent = infoContainer

    -- Draggable Controller
    local isDragging = false
    local dragStartPos = nil
    local dragStartFramePos = nil

    hudContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            dragStartPos = input.Position
            dragStartFramePos = hudContainer.Position
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartPos
            hudContainer.Position = UDim2.new(
                dragStartFramePos.X.Scale,
                dragStartFramePos.X.Offset + delta.X,
                dragStartFramePos.Y.Scale,
                dragStartFramePos.Y.Offset + delta.Y
            )
        end
    end)

    -- Avatar Thumbnail Cache
    local avatarCache = {}
    local currentAvatarId = nil

    local function updateAvatar(userId)
        if currentAvatarId == userId then return end
        currentAvatarId = userId
        if avatarCache[userId] then
            avatarImg.Image = avatarCache[userId]
            return
        end
        avatarImg.Image = 'rbxasset://textures/ui/GuiImagePlaceholder.png'
        task.spawn(function()
            local success, result = pcall(function()
                return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
            end)
            if success and result then
                avatarCache[userId] = result
                if currentAvatarId == userId then
                    avatarImg.Image = result
                end
            end
        end)
    end

    -- Tactical Kill Chance Calculator
    local function calculateKillChance(targetPlayer, targetChar)
        if not targetPlayer or not targetChar then return 0 end
        local targetHum = targetChar:FindFirstChildOfClass('Humanoid')
        if not targetHum or targetHum.Health <= 0 then return 0 end

        local myChar = LP.Character
        local myHum = myChar and myChar:FindFirstChildOfClass('Humanoid')
        if not myHum or myHum.Health <= 0 then return 0 end

        -- Target stunned on floor = guaranteed kill
        if isPlayerTased and isPlayerTased(targetPlayer) then
            return 100
        end

        local hpPercent = math.clamp(targetHum.Health / math.max(targetHum.MaxHealth, 100), 0, 1)
        local hpScore = (1 - hpPercent) * 45

        local myHpPercent = math.clamp(myHum.Health / math.max(myHum.MaxHealth, 100), 0, 1)
        local myHpScore = myHpPercent * 15

        local myTool = myChar:FindFirstChildOfClass('Tool')
        local myToolName = myTool and myTool.Name
        local myGunScore = 5
        if myToolName then
            if myToolName == 'Remington 870' or myToolName == 'FAL' or myToolName == 'AK-47' or myToolName == 'M4A1' then
                myGunScore = 25
            elseif myToolName == 'M9' or myToolName == 'Taser' then
                myGunScore = 18
            elseif (knownGunNames and knownGunNames[myToolName]) or myTool:GetAttribute('ToolType') == 'Gun' then
                myGunScore = 20
            end
        end

        local targetTool = targetChar:FindFirstChildOfClass('Tool')
        local targetToolName = targetTool and targetTool.Name
        local targetThreatScore = 0
        if not targetToolName or targetToolName == 'Fists' or targetToolName == 'Handcuffs' or targetToolName == 'Snack' then
            targetThreatScore = 15
        elseif targetToolName == 'Remington 870' or targetToolName == 'FAL' then
            targetThreatScore = -10
        elseif targetToolName == 'AK-47' or targetToolName == 'M4A1' then
            targetThreatScore = -5
        end

        local statusScore = 0
        if playerHasShield and playerHasShield(targetPlayer, targetChar) then
            statusScore = statusScore - 15
        end

        local myHrp = myChar:FindFirstChild('HumanoidRootPart')
        local targetHrp = targetChar:FindFirstChild('HumanoidRootPart')
        local distScore = 5
        if myHrp and targetHrp then
            local dist = (myHrp.Position - targetHrp.Position).Magnitude
            if dist < 40 then
                distScore = 10
            elseif dist < 150 then
                distScore = 7
            elseif dist < 400 then
                distScore = 4
            else
                distScore = 1
            end
        end

        local baseScore = 20
        local totalChance = math.floor(baseScore + hpScore + myHpScore + myGunScore + targetThreatScore + statusScore + distScore)
        return math.clamp(totalChance, 5, 99)
    end

    -- Main Update Loop
    local lastTargetPlayer = nil
    local lastTargetTime = 0
    local displayTarget = nil
    local currentHPDisplay = 100
    local currentAlpha = 0

    local hudConn = RunService.RenderStepped:Connect(function(dt)
        if not (Toggles.TargetHUD and Toggles.TargetHUD.Value) then
            hudContainer.Visible = false
            currentAlpha = 0
            return
        end

        -- 1. Identify active target
        local activeTarget = nil
        if rageTargetPart and rageTargetPart.Parent then
            activeTarget = Players:GetPlayerFromCharacter(rageTargetPart.Parent)
        end
        if not activeTarget and targetPartCache and targetPartCache.Parent then
            activeTarget = Players:GetPlayerFromCharacter(targetPartCache.Parent)
        end
        if not activeTarget and lastShotInfo.targetPlayer and (tick() - (lastShotInfo.tick or 0) < 2.2) then
            local char = lastShotInfo.targetPlayer.Character
            local hum = char and char:FindFirstChildOfClass('Humanoid')
            if hum and hum.Health > 0 then
                activeTarget = lastShotInfo.targetPlayer
            end
        end
        if not activeTarget then
            local nearest = FindNearestTarget()
            if nearest and nearest.Parent then
                activeTarget = Players:GetPlayerFromCharacter(nearest.Parent)
            end
        end

        if activeTarget and activeTarget.Character and activeTarget.Character:FindFirstChildOfClass('Humanoid') and activeTarget.Character:FindFirstChildOfClass('Humanoid').Health > 0 then
            displayTarget = activeTarget
            lastTargetTime = tick()
        end

        local timeSinceTarget = tick() - lastTargetTime
        local shouldShow = displayTarget and (timeSinceTarget < 1.8)

        if shouldShow then
            currentAlpha = math.clamp(currentAlpha + dt * 7, 0, 1)
        else
            currentAlpha = math.clamp(currentAlpha - dt * 4, 0, 1)
        end

        if currentAlpha <= 0.01 then
            hudContainer.Visible = false
            return
        else
            hudContainer.Visible = true
        end

        if isCanvasGroup then
            hudContainer.GroupTransparency = 1 - currentAlpha
        end

        -- Accent Color
        local accentCol = (Toggles.TargetHUDCustomColor and Toggles.TargetHUDCustomColor.Value and Options.TargetHUDAccentColor and Options.TargetHUDAccentColor.Value)
            or Library.AccentColor
            or Color3.fromRGB(0, 170, 255)
        accentBar.BackgroundColor3 = accentCol

        if not displayTarget or not displayTarget.Parent then return end
        local char = displayTarget.Character
        local hum = char and char:FindFirstChildOfClass('Humanoid')
        if not hum then return end

        -- Avatar
        if Toggles.TargetHUDShowAvatar and Toggles.TargetHUDShowAvatar.Value then
            avatarFrame.Visible = true
            infoContainer.Position = UDim2.new(0, 64, 0, 20)
            infoContainer.Size = UDim2.new(1, -70, 0, 60)
            updateAvatar(displayTarget.UserId)
        else
            avatarFrame.Visible = false
            infoContainer.Position = UDim2.new(0, 8, 0, 20)
            infoContainer.Size = UDim2.new(1, -16, 0, 60)
        end

        -- Name & Team
        nameLabel.Text = displayTarget.DisplayName or displayTarget.Name
        local team = displayTarget.Team
        local teamName = team and team.Name or 'None'
        local teamCol = Color3.fromRGB(200, 200, 200)
        if team == Teams:FindFirstChild('Criminals') then
            teamCol = Color3.fromRGB(255, 65, 65)
            teamName = 'CRIM'
        elseif team == Teams:FindFirstChild('Inmates') then
            teamCol = Color3.fromRGB(255, 175, 20)
            teamName = 'INMATE'
        elseif team == Teams:FindFirstChild('Guards') then
            teamCol = Color3.fromRGB(0, 160, 255)
            teamName = 'GUARD'
        end
        teamBadge.Text = '[' .. teamName .. ']'
        teamBadge.TextColor3 = teamCol

        -- Weapon
        if Toggles.TargetHUDShowWeapon and Toggles.TargetHUDShowWeapon.Value then
            weaponLabel.Visible = true
            local tool = char:FindFirstChildOfClass('Tool')
            local toolName = tool and tool.Name or 'None'
            local ammoStr = ''
            if tool then
                local ammo = tool:GetAttribute('Local_CurrentAmmo') or tool:GetAttribute('CurrentAmmo')
                if ammo then
                    ammoStr = string.format(' [%d]', ammo)
                end
            end
            weaponLabel.Text = 'Weapon: ' .. toolName .. ammoStr
        else
            weaponLabel.Visible = false
        end

        -- Health Bar & Numbers
        local maxHp = math.max(hum.MaxHealth, 100)
        local realHp = math.clamp(hum.Health, 0, maxHp)
        currentHPDisplay = currentHPDisplay + (realHp - currentHPDisplay) * math.clamp(dt * 12, 0, 1)
        local hpRatio = math.clamp(currentHPDisplay / maxHp, 0, 1)

        hpBarFill.Size = UDim2.new(hpRatio, 0, 1, 0)
        local hpColor
        if hpRatio > 0.5 then
            local t = (hpRatio - 0.5) * 2
            hpColor = Color3.fromRGB(240, 200, 50):Lerp(Color3.fromRGB(46, 204, 113), t)
        else
            local t = hpRatio * 2
            hpColor = Color3.fromRGB(230, 50, 50):Lerp(Color3.fromRGB(240, 200, 50), t)
        end

        if Options.TargetHUDStyle and Options.TargetHUDStyle.Value == 'Linoria Accent' then
            hpBarFill.BackgroundColor3 = accentCol
        else
            hpBarFill.BackgroundColor3 = hpColor
        end

        hpText.Text = string.format('%d / %d HP', math.floor(realHp + 0.5), math.floor(maxHp))

        -- Kill Chance
        if Toggles.TargetHUDShowChance and Toggles.TargetHUDShowChance.Value then
            killChanceLabel.Visible = true
            local chance = calculateKillChance(displayTarget, char)
            killChanceLabel.Text = string.format('Chance: %d%%', chance)
            if chance >= 70 then
                killChanceLabel.TextColor3 = Color3.fromRGB(46, 204, 113)
            elseif chance >= 40 then
                killChanceLabel.TextColor3 = Color3.fromRGB(240, 200, 50)
            else
                killChanceLabel.TextColor3 = Color3.fromRGB(230, 50, 50)
            end
        else
            killChanceLabel.Visible = false
        end

        -- Distance
        if Toggles.TargetHUDShowDistance and Toggles.TargetHUDShowDistance.Value then
            distLabel.Visible = true
            local myRoot = LP.Character and LP.Character:FindFirstChild('HumanoidRootPart')
            local targetRoot = char:FindFirstChild('HumanoidRootPart')
            if myRoot and targetRoot then
                local dist = math.floor((myRoot.Position - targetRoot.Position).Magnitude)
                distLabel.Text = dist .. ' studs'
            else
                distLabel.Text = ''
            end
        else
            distLabel.Visible = false
        end
    end)

    _G.BoarsCleanupTargetHUD = function()
        if hudConn then
            hudConn:Disconnect()
            hudConn = nil
        end
        if hudGui then
            pcall(function() hudGui:Destroy() end)
        end
    end
end

-- ====================== KILLFEED ======================
do
    local TweenService = game:GetService('TweenService')
    local feedGui = Instance.new('ScreenGui')
    feedGui.Name = 'BoarsKillfeed'
    feedGui.ResetOnSpawn = false
    feedGui.DisplayOrder = 9600
    feedGui.IgnoreGuiInset = true

    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(feedGui)
            feedGui.Parent = game:GetService('CoreGui')
        elseif gethui then
            feedGui.Parent = gethui()
        else
            feedGui.Parent = game:GetService('CoreGui')
        end
    end)
    if not feedGui.Parent then
        pcall(function() feedGui.Parent = LP:WaitForChild('PlayerGui') end)
    end

    local feedContainer = Instance.new('Frame')
    feedContainer.Name = 'FeedContainer'
    feedContainer.Size = UDim2.new(0, 320, 0, 350)
    feedContainer.Position = UDim2.new(1, -330, 0, 35)
    feedContainer.BackgroundTransparency = 1
    feedContainer.ClipsDescendants = false
    feedContainer.Parent = feedGui

    local listLayout = Instance.new('UIListLayout')
    listLayout.Name = 'Layout'
    listLayout.FillDirection = Enum.FillDirection.Vertical
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    listLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = feedContainer

    local activeEntries = {}
    local entryOrder = 0

    local function getPlayerTeamColor(player)
        if not player then return Color3.fromRGB(180, 180, 180) end
        if player.Team == Teams.Guards then
            return Color3.fromRGB(0, 160, 255)
        elseif player.Team == Teams.Inmates then
            return Color3.fromRGB(255, 150, 20)
        elseif player.Team == Teams.Criminals then
            return Color3.fromRGB(255, 55, 55)
        end
        return Color3.fromRGB(220, 220, 220)
    end

    local function trimName(name, maxLen)
        if not name then return 'Unknown' end
        if #name > (maxLen or 12) then
            return string.sub(name, 1, maxLen or 12) .. '..'
        end
        return name
    end

    local function formatWeaponName(weapon)
        if not weapon or weapon == '' or weapon == 'Gun' or weapon == 'Combat' then
            return 'Killed'
        end
        return weapon
    end

    local function pushKillfeedEntry(killer, victim, weaponName, isHeadshot, distanceStuds)
        if not (Toggles.Killfeed and Toggles.Killfeed.Value) then return end

        local isMyKill = (killer == LP)
        local isMyDeath = (victim == LP)

        if Toggles.KillfeedOnlyLocal and Toggles.KillfeedOnlyLocal.Value then
            if not isMyKill and not isMyDeath then
                return
            end
        end

        local maxItems = (Options.KillfeedMaxItems and Options.KillfeedMaxItems.Value) or 5
        local duration = (Options.KillfeedDuration and Options.KillfeedDuration.Value) or 5

        -- Remove oldest if limit reached
        while #activeEntries >= maxItems do
            local oldest = table.remove(activeEntries, 1)
            if oldest and oldest.frame and oldest.frame.Parent then
                oldest.frame:Destroy()
            end
        end

        entryOrder = entryOrder + 1

        local entry = Instance.new('Frame')
        entry.Name = 'Entry_' .. entryOrder
        entry.LayoutOrder = entryOrder
        entry.AutomaticSize = Enum.AutomaticSize.X
        entry.Size = UDim2.new(0, 0, 0, 26)
        entry.BackgroundColor3 = Color3.fromRGB(16, 16, 18)
        entry.BackgroundTransparency = 1
        entry.BorderSizePixel = 0

        local corner = Instance.new('UICorner')
        corner.CornerRadius = UDim.new(0, 4)
        corner.Parent = entry

        local stroke = Instance.new('UIStroke')
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Thickness = 1
        if isMyKill and (Toggles.KillfeedHighlightMine == nil or Toggles.KillfeedHighlightMine.Value) then
            stroke.Color = Color3.fromRGB(240, 60, 60)
            stroke.Thickness = 1.4
        elseif isMyDeath then
            stroke.Color = Color3.fromRGB(180, 40, 40)
        else
            stroke.Color = Color3.fromRGB(42, 42, 48)
        end
        stroke.Transparency = 1
        stroke.Parent = entry

        local padding = Instance.new('UIPadding')
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 2)
        padding.PaddingBottom = UDim.new(0, 2)
        padding.Parent = entry

        local hLayout = Instance.new('UIListLayout')
        hLayout.FillDirection = Enum.FillDirection.Horizontal
        hLayout.VerticalAlignment = Enum.VerticalAlignment.Center
        hLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        hLayout.Padding = UDim.new(0, 5)
        hLayout.SortOrder = Enum.SortOrder.LayoutOrder
        hLayout.Parent = entry

        local labelOrder = 0

        -- 1. Killer Name
        labelOrder = labelOrder + 1
        local killerLabel = Instance.new('TextLabel')
        killerLabel.Name = 'Killer'
        killerLabel.LayoutOrder = labelOrder
        killerLabel.AutomaticSize = Enum.AutomaticSize.XY
        killerLabel.BackgroundTransparency = 1
        killerLabel.Font = Enum.Font.GothamBold
        killerLabel.TextSize = 13
        killerLabel.Text = (killer and trimName(killer.DisplayName or killer.Name, 12)) or 'Unknown'
        killerLabel.TextColor3 = getPlayerTeamColor(killer)
        killerLabel.TextTransparency = 1
        killerLabel.Parent = entry

        -- 2. Weapon Badge
        if Toggles.KillfeedShowWeapon == nil or Toggles.KillfeedShowWeapon.Value then
            labelOrder = labelOrder + 1
            local wepLabel = Instance.new('TextLabel')
            wepLabel.Name = 'Weapon'
            wepLabel.LayoutOrder = labelOrder
            wepLabel.AutomaticSize = Enum.AutomaticSize.XY
            wepLabel.BackgroundTransparency = 1
            wepLabel.Font = Enum.Font.GothamMedium
            wepLabel.TextSize = 11
            wepLabel.Text = '[' .. formatWeaponName(weaponName) .. ']'
            wepLabel.TextColor3 = Color3.fromRGB(205, 205, 210)
            wepLabel.TextTransparency = 1
            wepLabel.Parent = entry
        end

        -- 3. Headshot Icon
        if isHeadshot and (Toggles.KillfeedShowHeadshot == nil or Toggles.KillfeedShowHeadshot.Value) then
            labelOrder = labelOrder + 1
            local hsLabel = Instance.new('TextLabel')
            hsLabel.Name = 'Headshot'
            hsLabel.LayoutOrder = labelOrder
            hsLabel.AutomaticSize = Enum.AutomaticSize.XY
            hsLabel.BackgroundTransparency = 1
            hsLabel.Font = Enum.Font.GothamBold
            hsLabel.TextSize = 11
            hsLabel.Text = '💀'
            hsLabel.TextColor3 = Color3.fromRGB(255, 60, 60)
            hsLabel.TextTransparency = 1
            hsLabel.Parent = entry
        end

        -- 4. Distance
        if distanceStuds and distanceStuds > 0 and (Toggles.KillfeedShowDistance and Toggles.KillfeedShowDistance.Value) then
            labelOrder = labelOrder + 1
            local distLabel = Instance.new('TextLabel')
            distLabel.Name = 'Distance'
            distLabel.LayoutOrder = labelOrder
            distLabel.AutomaticSize = Enum.AutomaticSize.XY
            distLabel.BackgroundTransparency = 1
            distLabel.Font = Enum.Font.Gotham
            distLabel.TextSize = 10
            distLabel.Text = '(' .. math.round(distanceStuds * 0.28) .. 'm)'
            distLabel.TextColor3 = Color3.fromRGB(140, 140, 145)
            distLabel.TextTransparency = 1
            distLabel.Parent = entry
        end

        -- 5. Victim Name
        labelOrder = labelOrder + 1
        local victimLabel = Instance.new('TextLabel')
        victimLabel.Name = 'Victim'
        victimLabel.LayoutOrder = labelOrder
        victimLabel.AutomaticSize = Enum.AutomaticSize.XY
        victimLabel.BackgroundTransparency = 1
        victimLabel.Font = Enum.Font.GothamBold
        victimLabel.TextSize = 13
        victimLabel.Text = (victim and trimName(victim.DisplayName or victim.Name, 12)) or 'Unknown'
        victimLabel.TextColor3 = getPlayerTeamColor(victim)
        victimLabel.TextTransparency = 1
        victimLabel.Parent = entry

        entry.Parent = feedContainer

        local entryData = { frame = entry, created = tick() }
        table.insert(activeEntries, entryData)

        -- Fade In Animation
        local fadeInInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(entry, fadeInInfo, { BackgroundTransparency = 0.25 }):Play()
        TweenService:Create(stroke, fadeInInfo, { Transparency = 0.2 }):Play()
        for _, child in ipairs(entry:GetChildren()) do
            if child:IsA('TextLabel') then
                TweenService:Create(child, fadeInInfo, { TextTransparency = 0 }):Play()
            end
        end

        -- Auto Expire
        task.delay(duration, function()
            if entry and entry.Parent then
                local fadeOutInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
                TweenService:Create(entry, fadeOutInfo, { BackgroundTransparency = 1 }):Play()
                TweenService:Create(stroke, fadeOutInfo, { Transparency = 1 }):Play()
                for _, child in ipairs(entry:GetChildren()) do
                    if child:IsA('TextLabel') then
                        TweenService:Create(child, fadeOutInfo, { TextTransparency = 1 }):Play()
                    end
                end
                task.wait(0.32)
                for idx, item in ipairs(activeEntries) do
                    if item == entryData then
                        table.remove(activeEntries, idx)
                        break
                    end
                end
                if entry and entry.Parent then
                    entry:Destroy()
                end
            end
        end)
    end

    _G.BoarsAddKillfeed = function(killer, victim, weapon, isHead, dist)
        pcall(function()
            pushKillfeedEntry(killer, victim, weapon, isHead, dist)
        end)
    end

    _G.BoarsTestKillfeed = function()
        local testGuns = { 'M4A1', 'Remington 870', 'AK-47', 'M9', 'Taser' }
        local randomGun = testGuns[math.random(1, #testGuns)]
        local randomDist = math.random(15, 120)
        local isHead = (math.random(1, 2) == 1)

        local otherPlayers = {}
        for _, p in Players:GetPlayers() do
            if p ~= LP then table.insert(otherPlayers, p) end
        end
        local mockVictim = (#otherPlayers > 0 and otherPlayers[math.random(1, #otherPlayers)])
        pushKillfeedEntry(LP, mockVictim, randomGun, isHead, randomDist)
    end

    _G.BoarsCleanupKillfeed = function()
        if feedGui then
            pcall(function() feedGui:Destroy() end)
        end
    end
end

-- ====================== CUSTOM VIEWMODEL & SPIN ======================
do
    local origC0Map = setmetatable({}, { __mode = 'k' })
    local spinAngle = 0
    local vmConn = nil

    local function restoreViewmodel()
        for grip, c0 in pairs(origC0Map) do
            if grip and grip.Parent then
                pcall(function() grip.C0 = c0 end)
            end
        end
    end

    if Toggles.CustomViewmodel then
        Toggles.CustomViewmodel:OnChanged(function()
            if not Toggles.CustomViewmodel.Value then
                restoreViewmodel()
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        table.clear(origC0Map)
        spinAngle = 0
    end)

    local lastVMTick = tick()
    vmConn = RunService.RenderStepped:Connect(function()
        local now = tick()
        local dt = math.clamp(now - lastVMTick, 0.001, 0.1)
        lastVMTick = now

        if not (Toggles.CustomViewmodel and Toggles.CustomViewmodel.Value) then
            return
        end

        local char = LP.Character
        if not char then return end

        local isFirstPerson = false
        local head = char:FindFirstChild('Head')
        if head and Camera then
            isFirstPerson = (Camera.CFrame.Position - head.Position).Magnitude < 1.5
        end
        if LP.CameraMode == Enum.CameraMode.LockFirstPerson then
            isFirstPerson = true
        end

        if Toggles.ViewmodelFirstPersonOnly and Toggles.ViewmodelFirstPersonOnly.Value and not isFirstPerson then
            restoreViewmodel()
            return
        end

        local rightArm = char:FindFirstChild('Right Arm')
        local leftArm = char:FindFirstChild('Left Arm')

        -- Show arms in first person if enabled
        if isFirstPerson and Toggles.ViewmodelShowArms and Toggles.ViewmodelShowArms.Value then
            pcall(function()
                if rightArm then rightArm.LocalTransparencyModifier = 0 end
                if leftArm then leftArm.LocalTransparencyModifier = 0 end
            end)
        end

        local rightGrip = rightArm and rightArm:FindFirstChild('RightGrip')
        if not rightGrip then return end

        if not origC0Map[rightGrip] then
            origC0Map[rightGrip] = rightGrip.C0
        end

        local origC0 = origC0Map[rightGrip]
        if not origC0 then return end

        local offX = ((Options.ViewmodelOffsetX and Options.ViewmodelOffsetX.Value) or 0) / 20
        local offY = ((Options.ViewmodelOffsetY and Options.ViewmodelOffsetY.Value) or 0) / 20
        local offZ = ((Options.ViewmodelOffsetZ and Options.ViewmodelOffsetZ.Value) or 0) / 20

        local rotX = math.rad((Options.ViewmodelRotX and Options.ViewmodelRotX.Value) or 0)
        local rotY = math.rad((Options.ViewmodelRotY and Options.ViewmodelRotY.Value) or 0)
        local rotZ = math.rad((Options.ViewmodelRotZ and Options.ViewmodelRotZ.Value) or 0)

        if Toggles.ViewmodelSpin and Toggles.ViewmodelSpin.Value then
            local spd = ((Options.ViewmodelSpinSpeed and Options.ViewmodelSpinSpeed.Value) or 10) * 15
            spinAngle = (spinAngle + spd * dt) % 360
            local rad = math.rad(spinAngle)
            local axis = (Options.ViewmodelSpinAxis and Options.ViewmodelSpinAxis.Value) or 'Y (Yaw)'
            if axis == 'Y (Yaw)' then
                rotY = rotY + rad
            elseif axis == 'X (Pitch)' then
                rotX = rotX + rad
            elseif axis == 'Z (Roll)' then
                rotZ = rotZ + rad
            elseif axis == 'All Axes' then
                rotX = rotX + rad
                rotY = rotY + rad * 0.7
                rotZ = rotZ + rad * 1.3
            end
        end

        -- Compute delta in Camera space and map into Right Arm object space
        local camCF = Camera.CFrame
        local deltaWorld = (camCF.RightVector * offX) + (camCF.UpVector * offY) + (camCF.LookVector * offZ)
        local armOffset = rightArm.CFrame:VectorToObjectSpace(deltaWorld)

        local rotCF = CFrame.Angles(rotX, rotY, rotZ)

        pcall(function()
            rightGrip.C0 = CFrame.new(origC0.Position + armOffset) * origC0.Rotation * rotCF
        end)
    end)

    _G.BoarsCleanupViewmodel = function()
        if vmConn then
            vmConn:Disconnect()
            vmConn = nil
        end
        restoreViewmodel()
    end
end

-- ====================== ROBLOX OPTIMIZER ======================
do
    local origPartProps = setmetatable({}, { __mode = 'k' })
    local origTextureProps = setmetatable({}, { __mode = 'k' })
    local origEffectProps = setmetatable({}, { __mode = 'k' })
    local origPostFXProps = setmetatable({}, { __mode = 'k' })
    local origLighting = {
        GlobalShadows = nil
    }
    local origTerrain = {
        WaterWaveSize = nil,
        WaterWaveSpeed = nil,
        WaterReflectance = nil,
        Decoration = nil
    }

    local descendantConn = nil
    local lightingConn = nil
    local isOptimizingBatch = false

    local function isCharacterOrTool(inst)
        local cur = inst
        while cur and cur ~= Workspace and cur ~= game do
            if cur:IsA('Model') then
                if cur:FindFirstChildOfClass('Humanoid') then
                    return true
                end
            end
            if cur:IsA('Tool') or cur:IsA('Accoutrement') then
                return true
            end
            cur = cur.Parent
        end
        if Workspace.CurrentCamera and inst:IsDescendantOf(Workspace.CurrentCamera) then
            return true
        end
        return false
    end

    local function optimizeInstance(inst)
        if not inst or not inst.Parent then return end
        if isCharacterOrTool(inst) then return end

        if inst:IsA('BasePart') then
            if not origPartProps[inst] then
                origPartProps[inst] = {
                    Material = inst.Material,
                    Reflectance = inst.Reflectance,
                    CastShadow = inst.CastShadow
                }
            end
            if Toggles.OptGlobalShadows and Toggles.OptGlobalShadows.Value then
                inst.CastShadow = false
            end
            if Toggles.OptSmoothMaterials and Toggles.OptSmoothMaterials.Value then
                inst.Material = Enum.Material.SmoothPlastic
                inst.Reflectance = 0
            end
        elseif inst:IsA('Decal') or inst:IsA('Texture') then
            if not origTextureProps[inst] then
                origTextureProps[inst] = {
                    Transparency = inst.Transparency
                }
            end
            if Toggles.OptRemoveTextures and Toggles.OptRemoveTextures.Value then
                inst.Transparency = 1
            end
        elseif inst:IsA('ParticleEmitter') or inst:IsA('Smoke') or inst:IsA('Fire') or inst:IsA('Sparkles') or inst:IsA('Trail') or inst:IsA('Beam') then
            if not origEffectProps[inst] then
                origEffectProps[inst] = {
                    Enabled = inst.Enabled
                }
            end
            if Toggles.OptDisableParticles and Toggles.OptDisableParticles.Value then
                inst.Enabled = false
            end
        elseif inst:IsA('Light') then
            if not origEffectProps[inst] then
                origEffectProps[inst] = {
                    Shadows = inst.Shadows
                }
            end
            if Toggles.OptGlobalShadows and Toggles.OptGlobalShadows.Value then
                inst.Shadows = false
            end
        end
    end

    local function optimizeLighting()
        if origLighting.GlobalShadows == nil then
            origLighting.GlobalShadows = Lighting.GlobalShadows
        end
        if Toggles.OptGlobalShadows and Toggles.OptGlobalShadows.Value then
            pcall(function() Lighting.GlobalShadows = false end)
        else
            if origLighting.GlobalShadows ~= nil then
                pcall(function() Lighting.GlobalShadows = origLighting.GlobalShadows end)
            end
        end

        if Toggles.OptDisablePostEffects and Toggles.OptDisablePostEffects.Value then
            local function checkFX(parent)
                for _, child in ipairs(parent:GetChildren()) do
                    if child:IsA('PostEffect') or child:IsA('Atmosphere') or child:IsA('BloomEffect') or child:IsA('BlurEffect') or child:IsA('SunRaysEffect') or child:IsA('ColorCorrectionEffect') or child:IsA('DepthOfFieldEffect') then
                        if origPostFXProps[child] == nil then
                            origPostFXProps[child] = child.Enabled
                        end
                        pcall(function() child.Enabled = false end)
                    end
                end
            end
            checkFX(Lighting)
            if Workspace.CurrentCamera then
                checkFX(Workspace.CurrentCamera)
            end
        end
    end

    local function optimizeTerrain()
        local terrain = Workspace.Terrain
        if not terrain then return end
        if origTerrain.WaterWaveSize == nil then
            pcall(function()
                origTerrain.WaterWaveSize = terrain.WaterWaveSize
                origTerrain.WaterWaveSpeed = terrain.WaterWaveSpeed
                origTerrain.WaterReflectance = terrain.WaterReflectance
                origTerrain.Decoration = terrain.Decoration
            end)
        end
        if Toggles.OptLowTerrain and Toggles.OptLowTerrain.Value then
            pcall(function()
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.Decoration = false
            end)
        end
    end

    local function optimizeAllAsync()
        if isOptimizingBatch then return end
        isOptimizingBatch = true
        optimizeLighting()
        optimizeTerrain()
        local descs = Workspace:GetDescendants()
        local batchSize = 1000
        for i = 1, #descs do
            if not Toggles.Optimizer or not Toggles.Optimizer.Value then
                break
            end
            local d = descs[i]
            pcall(optimizeInstance, d)
            if i % batchSize == 0 then
                task.wait()
            end
        end
        isOptimizingBatch = false
    end

    local function restoreAll()
        isOptimizingBatch = false

        if origLighting.GlobalShadows ~= nil then
            pcall(function() Lighting.GlobalShadows = origLighting.GlobalShadows end)
            origLighting.GlobalShadows = nil
        end

        local terrain = Workspace.Terrain
        if terrain and origTerrain.WaterWaveSize ~= nil then
            pcall(function()
                terrain.WaterWaveSize = origTerrain.WaterWaveSize or 0.15
                terrain.WaterWaveSpeed = origTerrain.WaterWaveSpeed or 10
                terrain.WaterReflectance = origTerrain.WaterReflectance or 1
                terrain.Decoration = (origTerrain.Decoration ~= nil) and origTerrain.Decoration or true
            end)
            origTerrain.WaterWaveSize = nil
            origTerrain.WaterWaveSpeed = nil
            origTerrain.WaterReflectance = nil
            origTerrain.Decoration = nil
        end

        for fx, origEnabled in pairs(origPostFXProps) do
            pcall(function()
                if fx and fx.Parent then
                    fx.Enabled = origEnabled
                end
            end)
        end
        table.clear(origPostFXProps)

        for part, props in pairs(origPartProps) do
            pcall(function()
                if part and part.Parent then
                    if props.Material ~= nil then part.Material = props.Material end
                    if props.Reflectance ~= nil then part.Reflectance = props.Reflectance end
                    if props.CastShadow ~= nil then part.CastShadow = props.CastShadow end
                end
            end)
        end
        table.clear(origPartProps)

        for tex, props in pairs(origTextureProps) do
            pcall(function()
                if tex and tex.Parent then
                    if props.Transparency ~= nil then tex.Transparency = props.Transparency end
                end
            end)
        end
        table.clear(origTextureProps)

        for eff, props in pairs(origEffectProps) do
            pcall(function()
                if eff and eff.Parent then
                    if props.Enabled ~= nil then eff.Enabled = props.Enabled end
                    if props.Shadows ~= nil then eff.Shadows = props.Shadows end
                end
            end)
        end
        table.clear(origEffectProps)
    end

    local function startListening()
        if not descendantConn then
            descendantConn = Workspace.DescendantAdded:Connect(function(desc)
                if Toggles.Optimizer and Toggles.Optimizer.Value and Toggles.OptOptimizeNew and Toggles.OptOptimizeNew.Value then
                    task.defer(function()
                        pcall(optimizeInstance, desc)
                    end)
                end
            end)
        end
        if not lightingConn then
            lightingConn = Lighting.ChildAdded:Connect(function(child)
                if Toggles.Optimizer and Toggles.Optimizer.Value and Toggles.OptDisablePostEffects and Toggles.OptDisablePostEffects.Value then
                    task.defer(function()
                        if child:IsA('PostEffect') or child:IsA('Atmosphere') or child:IsA('BloomEffect') or child:IsA('BlurEffect') or child:IsA('SunRaysEffect') or child:IsA('ColorCorrectionEffect') or child:IsA('DepthOfFieldEffect') then
                            if origPostFXProps[child] == nil then
                                origPostFXProps[child] = child.Enabled
                            end
                            pcall(function() child.Enabled = false end)
                        end
                    end)
                end
            end)
        end
    end

    local function stopListening()
        if descendantConn then
            descendantConn:Disconnect()
            descendantConn = nil
        end
        if lightingConn then
            lightingConn:Disconnect()
            lightingConn = nil
        end
    end

    if Toggles.Optimizer then
        Toggles.Optimizer:OnChanged(function()
            if Toggles.Optimizer.Value then
                startListening()
                task.spawn(optimizeAllAsync)
                pcall(function() Library:Notify('Roblox Optimizer: Enabled', 2) end)
            else
                stopListening()
                restoreAll()
                pcall(function() Library:Notify('Roblox Optimizer: Disabled (Restored)', 2) end)
            end
        end)
    end

    if Options.OptimizerPreset then
        Options.OptimizerPreset:OnChanged(function()
            local p = Options.OptimizerPreset.Value
            if p == 'Max FPS (Potato)' then
                if Toggles.OptGlobalShadows then Toggles.OptGlobalShadows:SetValue(true) end
                if Toggles.OptSmoothMaterials then Toggles.OptSmoothMaterials:SetValue(true) end
                if Toggles.OptRemoveTextures then Toggles.OptRemoveTextures:SetValue(true) end
                if Toggles.OptDisableParticles then Toggles.OptDisableParticles:SetValue(true) end
                if Toggles.OptDisablePostEffects then Toggles.OptDisablePostEffects:SetValue(true) end
                if Toggles.OptLowTerrain then Toggles.OptLowTerrain:SetValue(true) end
                if Toggles.OptOptimizeNew then Toggles.OptOptimizeNew:SetValue(true) end
            elseif p == 'Balanced Boost' then
                if Toggles.OptGlobalShadows then Toggles.OptGlobalShadows:SetValue(true) end
                if Toggles.OptSmoothMaterials then Toggles.OptSmoothMaterials:SetValue(true) end
                if Toggles.OptRemoveTextures then Toggles.OptRemoveTextures:SetValue(false) end
                if Toggles.OptDisableParticles then Toggles.OptDisableParticles:SetValue(true) end
                if Toggles.OptDisablePostEffects then Toggles.OptDisablePostEffects:SetValue(true) end
                if Toggles.OptLowTerrain then Toggles.OptLowTerrain:SetValue(true) end
                if Toggles.OptOptimizeNew then Toggles.OptOptimizeNew:SetValue(true) end
            end
            if Toggles.Optimizer and Toggles.Optimizer.Value then
                task.spawn(optimizeAllAsync)
            end
        end)
    end

    local function onSubToggleChanged()
        if Toggles.Optimizer and Toggles.Optimizer.Value then
            task.spawn(optimizeAllAsync)
        end
    end

    if Toggles.OptGlobalShadows then Toggles.OptGlobalShadows:OnChanged(onSubToggleChanged) end
    if Toggles.OptSmoothMaterials then Toggles.OptSmoothMaterials:OnChanged(onSubToggleChanged) end
    if Toggles.OptRemoveTextures then Toggles.OptRemoveTextures:OnChanged(onSubToggleChanged) end
    if Toggles.OptDisableParticles then Toggles.OptDisableParticles:OnChanged(onSubToggleChanged) end
    if Toggles.OptDisablePostEffects then Toggles.OptDisablePostEffects:OnChanged(onSubToggleChanged) end
    if Toggles.OptLowTerrain then Toggles.OptLowTerrain:OnChanged(onSubToggleChanged) end

    _G.BoarsForceOptimize = function()
        task.spawn(optimizeAllAsync)
        pcall(function() Library:Notify('Workspace optimization completed', 2) end)
    end

    _G.BoarsRestoreGraphics = function()
        restoreAll()
        if Toggles.Optimizer and Toggles.Optimizer.Value then
            Toggles.Optimizer:SetValue(false)
        end
        pcall(function() Library:Notify('Graphics fully restored', 2) end)
    end

    _G.BoarsCleanupOptimizer = function()
        stopListening()
        restoreAll()
    end
end


-- ====================== CHINAHAT MODULE ======================
do
    local NUM_SEGMENTS = 24
    local MAX_OTHER_HATS = 10
    local projectedBuffer = table.create(NUM_SEGMENTS)

    local function createHatDrawings(numSegments)
        local tris = table.create(numSegments)
        local lines = table.create(numSegments)
        for i = 1, numSegments do
            local t = Drawing.new('Triangle')
            t.Visible = false
            t.Filled = true
            t.Thickness = 1
            t.ZIndex = 8
            tris[i] = t

            local l = Drawing.new('Line')
            l.Visible = false
            l.Thickness = 1.5
            l.ZIndex = 9
            lines[i] = l
        end
        return { tris = tris, lines = lines, count = numSegments }
    end

    local function destroyHatDrawings(hat)
        if not hat then return end
        for _, t in ipairs(hat.tris) do
            pcall(function() t:Remove() end)
        end
        for _, l in ipairs(hat.lines) do
            pcall(function() l:Remove() end)
        end
        hat.tris = {}
        hat.lines = {}
    end

    local function hideHat(hat)
        if not hat then return end
        for i = 1, hat.count do
            if hat.tris[i].Visible then hat.tris[i].Visible = false end
            if hat.lines[i].Visible then hat.lines[i].Visible = false end
        end
    end

    local function renderHat(hat, head, cfg, spinAngle)
        if not head or not head.Parent then
            hideHat(hat)
            return
        end

        local headPos = head.Position
        local headScreen, headVis = Camera:WorldToViewportPoint(headPos)
        if not headVis or headScreen.Z <= 1 then
            hideHat(hat)
            return
        end

        local radius = cfg.radius or 2.0
        local height = cfg.height or 0.8
        local color = cfg.color or Color3.fromRGB(100, 150, 200)
        local alpha = cfg.alpha or 0.65
        local showOutline = cfg.showOutline ~= false
        local outlineColor = cfg.outlineColor or Color3.fromRGB(255, 255, 255)
        local outlineThick = cfg.outlineThickness or 1.5

        local headSizeY = (head.Size and head.Size.Y) or 2
        local yOffset = (headSizeY * 0.5) + (cfg.yOffset or 0.15)

        local baseCF
        if cfg.followHead then
            baseCF = head.CFrame * CFrame.new(0, yOffset, 0)
        else
            baseCF = CFrame.new(headPos + Vector3.new(0, yOffset, 0))
        end

        if spinAngle and spinAngle ~= 0 then
            baseCF = baseCF * CFrame.Angles(0, spinAngle, 0)
        end

        local apexPos = baseCF:PointToWorldSpace(Vector3.new(0, height, 0))
        local apexScreen, apexVis = Camera:WorldToViewportPoint(apexPos)
        if not apexVis or apexScreen.Z <= 0.5 then
            hideHat(hat)
            return
        end

        local apex2D = Vector2.new(apexScreen.X, apexScreen.Y)
        local numSeg = hat.count

        for i = 1, numSeg do
            local angle = (i - 1) / numSeg * (2 * math.pi)
            local localPt = Vector3.new(radius * math.cos(angle), 0, radius * math.sin(angle))
            local worldPt = baseCF:PointToWorldSpace(localPt)
            local screenPt, vis = Camera:WorldToViewportPoint(worldPt)
            if not vis or screenPt.Z <= 0.5 then
                hideHat(hat)
                return
            end
            projectedBuffer[i] = Vector2.new(screenPt.X, screenPt.Y)
        end

        for i = 1, numSeg do
            local nextI = (i % numSeg) + 1
            local p1 = projectedBuffer[i]
            local p2 = projectedBuffer[nextI]

            local tri = hat.tris[i]
            tri.PointA = apex2D
            tri.PointB = p1
            tri.PointC = p2
            tri.Color = color
            tri.Transparency = alpha
            tri.Visible = true

            local line = hat.lines[i]
            if showOutline then
                line.From = p1
                line.To = p2
                line.Color = outlineColor
                line.Thickness = outlineThick
                line.Transparency = 1
                line.Visible = true
            else
                line.Visible = false
            end
        end
    end

    local selfHat = createHatDrawings(NUM_SEGMENTS)
    local otherHatsPool = table.create(MAX_OTHER_HATS)
    for i = 1, MAX_OTHER_HATS do
        otherHatsPool[i] = createHatDrawings(NUM_SEGMENTS)
    end

    local chinahatConn = nil

    local function onRenderChinahat()
        if not Toggles.ChinaHat or not Toggles.ChinaHat.Value then
            hideHat(selfHat)
            for i = 1, MAX_OTHER_HATS do
                hideHat(otherHatsPool[i])
            end
            return
        end

        local rainbowColor = Color3.fromHSV((tick() * 0.25) % 1, 0.75, 1)
        local spinAngle = 0
        if Toggles.ChinaHatSpin and Toggles.ChinaHatSpin.Value then
            local speed = (Options.ChinaHatSpinSpeed and Options.ChinaHatSpinSpeed.Value) or 2
            spinAngle = (tick() * speed) % (2 * math.pi)
        end

        local followHead = Toggles.ChinaHatFollowHead and Toggles.ChinaHatFollowHead.Value
        local showOutline = Toggles.ChinaHatOutline and Toggles.ChinaHatOutline.Value
        local outlineColor = (Options.ChinaHatOutlineColor and Options.ChinaHatOutlineColor.Value) or Color3.fromRGB(255, 255, 255)
        local outlineThick = (Options.ChinaHatOutlineThick and Options.ChinaHatOutlineThick.Value) or 1.5

        -- Render on Self
        if Toggles.ChinaHatSelf and Toggles.ChinaHatSelf.Value then
            local char = LP.Character
            local head = char and char:FindFirstChild('Head')
            local hum = char and char:FindFirstChildOfClass('Humanoid')

            local isFirstPerson = false
            if head then
                local camPos = Camera.CFrame.Position
                if (camPos - head.Position).Magnitude < 1.5 then
                    isFirstPerson = true
                elseif (Camera.Focus.Position - camPos).Magnitude < 0.6 then
                    isFirstPerson = true
                elseif LP.CameraMode == Enum.CameraMode.LockFirstPerson then
                    isFirstPerson = true
                end
            end

            if head and hum and hum.Health > 0 and not isFirstPerson then
                local selfColor = (Toggles.ChinaHatRainbowSelf and Toggles.ChinaHatRainbowSelf.Value) and rainbowColor or ((Options.ChinaHatColorSelf and Options.ChinaHatColorSelf.Value) or Color3.fromRGB(100, 150, 200))
                local selfCfg = {
                    radius = (Options.ChinaHatRadiusSelf and Options.ChinaHatRadiusSelf.Value) or 2.0,
                    height = (Options.ChinaHatHeightSelf and Options.ChinaHatHeightSelf.Value) or 0.8,
                    yOffset = (Options.ChinaHatOffsetSelf and Options.ChinaHatOffsetSelf.Value) or 0.15,
                    color = selfColor,
                    alpha = (Options.ChinaHatAlphaSelf and Options.ChinaHatAlphaSelf.Value) or 0.65,
                    followHead = followHead,
                    showOutline = showOutline,
                    outlineColor = outlineColor,
                    outlineThickness = outlineThick
                }
                renderHat(selfHat, head, selfCfg, spinAngle)
            else
                hideHat(selfHat)
            end
        else
            hideHat(selfHat)
        end

        -- Render on Others
        if Toggles.ChinaHatOthers and Toggles.ChinaHatOthers.Value then
            local maxDist = (Options.ChinaHatMaxDist and Options.ChinaHatMaxDist.Value) or 250
            local camPos = Camera.CFrame.Position
            local nearby = {}

            for _, player in ipairs(Players:GetPlayers()) do
                if player == LP then continue end
                local char = player.Character
                local head = char and char:FindFirstChild('Head')
                local hum = char and char:FindFirstChildOfClass('Humanoid')
                if head and hum and hum.Health > 0 then
                    local dist = (camPos - head.Position).Magnitude
                    if dist <= maxDist then
                        local _, vis = Camera:WorldToViewportPoint(head.Position)
                        if vis then
                            table.insert(nearby, { player = player, head = head, dist = dist })
                        end
                    end
                end
            end

            table.sort(nearby, function(a, b) return a.dist < b.dist end)

            local othersRadius = (Options.ChinaHatRadiusOthers and Options.ChinaHatRadiusOthers.Value) or 2.0
            local othersHeight = (Options.ChinaHatHeightOthers and Options.ChinaHatHeightOthers.Value) or 0.8
            local othersAlpha = (Options.ChinaHatAlphaOthers and Options.ChinaHatAlphaOthers.Value) or 0.65
            local useTeam = Toggles.ChinaHatTeamColor and Toggles.ChinaHatTeamColor.Value
            local useRainbow = Toggles.ChinaHatRainbowOthers and Toggles.ChinaHatRainbowOthers.Value
            local fallbackColor = (Options.ChinaHatColorOthers and Options.ChinaHatColorOthers.Value) or Color3.fromRGB(200, 100, 150)

            for slot = 1, MAX_OTHER_HATS do
                local entry = nearby[slot]
                if entry then
                    local pColor = fallbackColor
                    if useRainbow then
                        pColor = rainbowColor
                    elseif useTeam and entry.player.TeamColor then
                        pColor = entry.player.TeamColor.Color
                    end

                    local oCfg = {
                        radius = othersRadius,
                        height = othersHeight,
                        yOffset = 0.15,
                        color = pColor,
                        alpha = othersAlpha,
                        followHead = followHead,
                        showOutline = showOutline,
                        outlineColor = outlineColor,
                        outlineThickness = outlineThick
                    }
                    renderHat(otherHatsPool[slot], entry.head, oCfg, spinAngle)
                else
                    hideHat(otherHatsPool[slot])
                end
            end
        else
            for i = 1, MAX_OTHER_HATS do
                hideHat(otherHatsPool[i])
            end
        end
    end

    chinahatConn = RunService.RenderStepped:Connect(onRenderChinahat)

    _G.BoarsCleanupChinahat = function()
        if chinahatConn then
            chinahatConn:Disconnect()
            chinahatConn = nil
        end
        destroyHatDrawings(selfHat)
        for i = 1, MAX_OTHER_HATS do
            destroyHatDrawings(otherHatsPool[i])
        end
    end
end


Library:OnUnload(function()
    Library.Unloaded = true
    if _G.BoarsCleanupChinahat then pcall(_G.BoarsCleanupChinahat) end
    if _G.BoarsCleanupOptimizer then pcall(_G.BoarsCleanupOptimizer) end
    if _G.BoarsCleanupTargetHUD then pcall(_G.BoarsCleanupTargetHUD) end
    if _G.BoarsCleanupKillfeed then pcall(_G.BoarsCleanupKillfeed) end
    if _G.BoarsCleanupViewmodel then pcall(_G.BoarsCleanupViewmodel) end
    for i = 1, FOV_SEG do
        fovLines[i]:Remove()
        fovTris[i]:Remove()
    end
    for i = 1, 4 do
        crosshairLines[i]:Remove()
    end
    for i = 1, AR_SEG do
        arLines[i]:Remove()
        arTris[i]:Remove()
    end
    for _, obj in pairs(espObjects) do
        if obj.cleanup then pcall(obj.cleanup) end
    end
    for k in pairs(espObjects) do espObjects[k] = nil end
    if ESPFolder then for _, child in ESPFolder:GetChildren() do child:Destroy() end end
    crosshairDot:Remove()
    crosshairRing:Remove()
    if rageIndicatorText then rageIndicatorText:Remove() end
    if cleanupParticles then pcall(cleanupParticles) end
    if cleanupHitmarkers then pcall(cleanupHitmarkers) end
    if targetEspGui then pcall(function() targetEspGui:Destroy() end) end
    if activeHitNumbers then
        for _, hn in ipairs(activeHitNumbers) do
            pcall(function() hn.drawing:Remove() end)
        end
        activeHitNumbers = {}
    end
    UserInputService.MouseIconEnabled = true
end)