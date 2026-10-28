-- ╔══════════════════════════════════════════════════════════════════╗
-- ║            Sp3arParvus — Developer Tool                          ║
-- ╠══════════════════════════════════════════════════════════════════╣
-- ║  Version: 4.2.9                                                  ║
-- ╚══════════════════════════════════════════════════════════════════╝

local VERSION = "4.2.9" -- Fixed config loading issues
local SAFE_MODE = false  -- ←SafeMode Flag, Change 'false' to 'true' before executing to enable SafeMode

print(string.format("[Sp3arParvus v%s] Loading...", VERSION))
MAX_INIT_WAIT = 30
initStartTime = tick()
print("[Sp3arParvus] Waiting for game to load...")
repeat task.wait() until game:IsLoaded()
print("[Sp3arParvus] Game loaded!")
print("[Sp3arParvus] Waiting for LocalPlayer...")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat
        task.wait(0.1)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer or (tick() - initStartTime > MAX_INIT_WAIT)
end
if not LocalPlayer then
    return warn("[Sp3arParvus] Failed to get LocalPlayer after " .. MAX_INIT_WAIT .. " seconds. Aborting.")
end
print("[Sp3arParvus] LocalPlayer ready: " .. LocalPlayer.Name)

print("[Sp3arParvus] Checking for Character (non-blocking)...")
local character = LocalPlayer.Character
if character then

    local charWaitStart = tick()
    repeat
        task.wait(0.1)
        character = LocalPlayer.Character
    until (character and character.Parent) or (tick() - charWaitStart > 3)
    if character and character.Parent then
        print("[Sp3arParvus] Character ready!")
    else
        warn("[Sp3arParvus] Character exists but not yet parented, continuing anyway...")
    end
else

    print("[Sp3arParvus] No character at load time — continuing without one. Humanoid will be detected when spawned.")
end

print("[Sp3arParvus] Waiting for Camera...")
local Workspace = game:GetService("Workspace")
repeat
    task.wait(0.1)
until Workspace.CurrentCamera or (tick() - initStartTime > MAX_INIT_WAIT)
if not Workspace.CurrentCamera then
    warn("[Sp3arParvus] Camera not found, continuing anyway...")
end
print("[Sp3arParvus] Camera ready!")

print("[Sp3arParvus] Waiting for PlayerScripts to initialize...")
local playerScripts = LocalPlayer:FindFirstChildOfClass("PlayerScripts")
if not playerScripts then
    repeat
        task.wait(0.1)
        playerScripts = LocalPlayer:FindFirstChildOfClass("PlayerScripts")
    until playerScripts or (tick() - initStartTime > MAX_INIT_WAIT)
end
if playerScripts then
    task.wait(0.5)
end
print("[Sp3arParvus] PlayerScripts ready!")

task.wait(0.2)
print(string.format("[Sp3arParvus] Initialization complete! (%.2fs)", tick() - initStartTime))

local CharCache = {}
local AimState = {
    Aim = false,
    LastAimTarget = nil,
    LastMouseMode = nil,
    LastOriginX = nil,
    LastOriginY = nil,
    AcquiringFrames = 0
}
local Flags = {
    ["Aim/AimLock"] = true,
    ["Aim/AlwaysEnabled"] = true,
    ["Aim/ShowAssistDots"] = false,
    ["Aim/TeamCheck"] = false,
    ["Aim/AutoWhitelistFriends"] = false,
    ["Aim/VisibilityCheck"] = true,
    ["Aim/AttractionStrength"] = 200,
    ["Aim/FOV/Radius"] = 50,
    ["Aim/FOV/ShowCircle"] = true,
    ["Aim/Dampening"] = true,
    ["Aim/Dampening/Threshold"] = 5,
    ["Aim/Dampening/Strength"] = 5,
    ["Aim/Priority"] = "Head",
    ["Aim/TargetBlacklistedThroughTerrain"] = true,
    ["Aim/BypassBlacklistPriorityIfOccludedOrFar"] = false,
    ["Aim/BlacklistBypassDistance"] = 200,
    ["Aim/BodyParts"] = {"Head"},
    ["Aim/TargetGroups"] = {
        Head = true,
        Torso = false,
        LeftArm = false,
        RightArm = false,
        LeftLeg = false,
        RightLeg = false
    },
    ["ShootBot/Enabled"] = false,
    ["ShootBot/CPS"] = 8,
    ["ShootBot/TeamCheck"] = false,
    ["ShootBot/TargetParts"] = {
        Head = false,
        Torso = false,
        LeftArm = false,
        RightArm = false,
        LeftLeg = false,
        RightLeg = false
    },
    ["ESP/Enabled"] = true,
    ["ESP/MaxDistance"] = 10000,
    ["ESP/TeamCheck"] = false,
    ["ESP/ShowStatus"] = true,
    ["ESP/ShowNickname"] = true,
    ["ESP/ShowUsername"] = true,
    ["ESP/ShowDistance"] = true,
    ["ESP/HealthIndicator"] = true,
    ["ESP/ShowEquipped"] = true,
    ["ESP/AdvancedPlayerPanel"] = false,
    ["ESP/PlayerOutlines"] = true,
    ["Visuals/Fullbright"] = false,
    ["Visuals/FullDark"] = false,
    -- Fullbright modifiers
    ["Visuals/Fullbright/ClockTime"]        = 12,
    ["Visuals/Fullbright/Brightness"]       = 2,
    ["Visuals/Fullbright/FogEnd"]           = 100000,
    ["Visuals/Fullbright/FogStart"]         = 0,
    ["Visuals/Fullbright/RemoveFog"]        = true,
    ["Visuals/Fullbright/RemoveShadows"]    = true,
    ["Visuals/Fullbright/WhiteAmbient"]     = true,
    ["Visuals/Fullbright/RemoveAtmosphere"] = true,
    ["Visuals/Fullbright/SkyHaze"]          = 0,
    ["Visuals/Fullbright/SkyGlare"]         = 0,
    ["Visuals/Fullbright/SetExposure"]      = true,
    ["Visuals/Fullbright/ExposureCompensation"] = 0,
    -- FullDark modifiers
    ["Visuals/FullDark/ClockTime"]          = 0,
    ["Visuals/FullDark/Brightness"]         = 0,
    ["Visuals/FullDark/FogEnd"]             = 100,
    ["Visuals/FullDark/FogStart"]           = 0,
    ["Visuals/FullDark/SetFog"]             = false,
    ["Visuals/FullDark/SetShadows"]         = false,
    ["Visuals/FullDark/BlackAmbient"]       = false,
    ["Visuals/FullDark/SetAtmosphere"]      = false,
    ["Visuals/FullDark/AtmosphereDensity"]  = 1,
    ["Visuals/FullDark/SkyHaze"]            = 0,
    ["Visuals/FullDark/SkyGlare"]           = 0,
    ["Visuals/FullDark/SetExposure"]        = false,
    ["Visuals/FullDark/ExposureCompensation"] = -2,
    ["Visuals/UIScale"] = 1,
    ["LocalUI/PerformancePanel"] = true,
    ["LocalUI/LocalHealthIndicator"] = true,
    ["LocalUI/ClosestPlayerTracker"] = true,
    ["LocalUI/ClosestPlayer/ShowDisplayName"] = false,
    ["LocalUI/ClosestPlayer/ShowUsername"] = true,
    ["LocalUI/ClosestPlayer/ShowDistance"] = true,
    ["LocalUI/ClosestPlayer/ShowHealth"] = false,
    ["LocalUI/ClosestPlayer/ShowEquipped"] = false,
    ["Br3ak3r/Enabled"] = true,
    ["Waypoints/Enabled"] = true,
    ["Settings/Freecam Toggle"] = true,
    ["Settings/GhostMode"] = false,
    ["Visuals/InformationDisplay"] = true,
    ["Misc/ScrollUnlocker"] = true,
    ["Misc/ItemPanel"] = false,
    ["Misc/QTeleport"] = true,
    ["Misc/HorizontalPositionForceValue"] = 1.5,
    ["Misc/VerticalPositionForceValue"] = 3.5,
    ["ESP/NametagOpacity"] = 90,
    ["LocalUI/ScreenUIOpacity"] = 90
}

if SAFE_MODE then
    Flags["Aim/AimLock"]        = false
    Flags["Aim/AlwaysEnabled"]  = false
    Flags["ShootBot/Enabled"]   = false
    Flags["Misc/QTeleport"]     = false
end

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Default Flags Snapshot (captured after SAFE_MODE overrides)     ║
-- ╚══════════════════════════════════════════════════════════════════╝
local DEFAULT_FLAGS = {}
do
    for k, v in pairs(Flags) do
        if type(v) == "table" then
            local copy = {}
            for k2, v2 in pairs(v) do copy[k2] = v2 end
            DEFAULT_FLAGS[k] = copy
        else
            DEFAULT_FLAGS[k] = v
        end
    end
end

local UIState
local AdvancedPlayerPanelState
local WorldHumState

local FLAG_METADATA = {
    ["Humanoid/Health"]     = { ReadOnly = true },
    -- (cutscenes, vehicles, anti-exploit scripts, stat systems, etc.).
    ["Humanoid/WalkSpeed"]  = { RequiresUserAction = true },
    ["Humanoid/JumpPower"]  = { RequiresUserAction = true },
    ["Humanoid/JumpHeight"] = { RequiresUserAction = true },
    ["Humanoid/RotationX"]  = { RequiresUserAction = true },
    ["Humanoid/RotationY"]  = { RequiresUserAction = true },
    ["Humanoid/RotationZ"]  = { RequiresUserAction = true },
}

local USER_MODIFIED_FLAGS = setmetatable({}, {
    __newindex = function(t, k, v)
        rawset(t, k, v)
        if ConfigManager and type(ConfigManager) == "table" then
            ConfigManager.IsDirty = true
        end
    end
})
local PROFILE_LOADED_FLAGS = {}  -- flags loaded from a profile (kept separate from user-touched flags)
-- Save Modifier: session-persistent selective-save filter ───────
local SaveModifierState = {
    Active               = false,   -- true when ≥1 item is deselected
    Categories = {
        whitelist        = true,
        blacklist        = true,
        teamWhitelist    = true,
        teamBlacklist    = true,
        priorityList     = true,
        worldHumPresets  = true,
        flags            = true,
    },
    WhitelistEntries     = {},      -- [tostring(userId)]  = bool; false = excluded
    BlacklistEntries     = {},
    TeamWhitelistEntries = {},      -- [teamName] = bool
    TeamBlacklistEntries = {},
    PriorityEntries      = {},      -- [tostring(index)] = bool
    PresetEntries        = {},      -- [tostring(presetId)] = bool
    FlagEntries          = {},      -- [flagKey] = bool  (/Locked companions excluded too)
}
local _updateHum  -- forward-declared; assigned once the Humanoid UI is built

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  ConfigManager — Local Profile Save/Load System                  ║
-- ╚══════════════════════════════════════════════════════════════════╝
local ConfigManager = { IsDirty = true }
do
    -- Path Constants ────────────────────────────────────────────────
    local ROOT_DIR        = "Sp3arParvus"
    local CONFIGS_DIR     = ROOT_DIR .. "/Configs"
    local UNIVERSAL_DIR   = CONFIGS_DIR .. "/Universal"
    local PERGAME_DIR     = CONFIGS_DIR .. "/PerGame"

    -- File API availability check ───────────────────────────────────
    local function hasFileAPIs()
        return type(writefile) == "function"
           and type(readfile)  == "function"
           and type(isfile)    == "function"
           and type(isfolder)  == "function"
           and type(makefolder) == "function"
    end

    -- Ensure directory structure exists ────────────────────────────
    local function ensureDirs()
        if not isfolder(ROOT_DIR)    then makefolder(ROOT_DIR)    end
        if not isfolder(CONFIGS_DIR) then makefolder(CONFIGS_DIR) end
        if not isfolder(UNIVERSAL_DIR) then makefolder(UNIVERSAL_DIR) end
        if not isfolder(PERGAME_DIR)   then makefolder(PERGAME_DIR)   end
    end

    -- JSON helpers (thin wrappers) ──────────────────────────────────
    local HttpService = game:GetService("HttpService")
    local function encode(t) return HttpService:JSONEncode(t) end
    local function decode(s) return HttpService:JSONDecode(s) end

    -- Serialize current Flags to a plain table safe for JSON ────────
    local function serializeFlags()
        local out = {}
        for k, v in pairs(Flags) do
            if USER_MODIFIED_FLAGS[k] or PROFILE_LOADED_FLAGS[k] then
                if type(v) == "table" then
                    local copy = {}
                    for k2, v2 in pairs(v) do copy[k2] = v2 end
                    out[k] = copy
                elseif type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
                    out[k] = v
                elseif typeof(v) == "Color3" then
                    out[k] = {__type = "Color3", R = v.R, G = v.G, B = v.B}
                elseif typeof(v) == "EnumItem" then
                    out[k] = {__type = "EnumItem", EnumType = tostring(v.EnumType), Name = v.Name}
                end
            end
        end
        return out
    end

    -- Apply a flags table onto live Flags + update UI updaters ──────
    local function applyFlags(data)
        for k, v in pairs(data) do
            if FLAG_METADATA[k] and FLAG_METADATA[k].ReadOnly then continue end
            
            -- Mark as profile-loaded (NOT user-touched) to prevent cross-contamination
            -- between profiles when using Overwrite. USER_MODIFIED_FLAGS is reserved for
            -- flags the user explicitly changes via the UI in this session.
            PROFILE_LOADED_FLAGS[k] = true
            if type(v) == "table" and v.__type == "Color3" then
                v = Color3.new(v.R, v.G, v.B)
            elseif type(v) == "table" and v.__type == "EnumItem" then
                local enumTypeStr = tostring(v.EnumType):match("Enum%.([^%.]+)") or tostring(v.EnumType)
                local ok, result = pcall(function() return Enum[enumTypeStr][v.Name] end)
                if ok and result then
                    v = result
                else
                    continue
                end
            end
            if Flags[k] ~= nil then
                local expectedType = type(Flags[k])
                local loadedType = type(v)
                
                if expectedType == "table" and loadedType == "table" then
                    for k2, v2 in pairs(v) do
                        if Flags[k][k2] ~= nil and type(Flags[k][k2]) ~= type(v2) then continue end
                        Flags[k][k2] = v2
                    end
                elseif expectedType == loadedType then
                    Flags[k] = v
                end
            elseif type(v) ~= "table" then
                -- Allow writing flags not yet initialized in Flags (e.g. Humanoid flags that
                -- only get set after CaptureHumanoidSettings runs on character spawn).
                Flags[k] = v
            end
            -- Push change through UI updater if available.
            if UIState and UIState.Updaters and UIState.Updaters[k] then
                if type(v) ~= "table" then
                    task.defer(function()
                        pcall(UIState.Updaters[k], v)
                    end)
                elseif type(UIState.Updaters[k]) == "table" then
                    -- Nested updater table (e.g. Aim/TargetGroups): call each per-key updater.
                    task.defer(function()
                        for k2, updater in pairs(UIState.Updaters[k]) do
                            if type(updater) == "function" and Flags[k] ~= nil then
                                pcall(updater, Flags[k][k2])
                            end
                        end
                    end)
                end
            end
        end
    end

    -- List helpers ──────────────────────────────────────────────────
    local function listdir(dir)
        -- listfiles is the standard exploit API
        if type(listfiles) == "function" then
            local ok, result = pcall(listfiles, dir)
            if ok and result then return result end
        end
        return {}
    end

    local function fileBasename(path)
        return path:match("([^/\\]+)$") or path
    end

    local function stripExtension(name)
        return name:match("(.+)%.[^%.]+$") or name
    end

    -- Save Modifier filter applier ──────────────────────────────────
    local function applyFilterToPayload(payload, filter)
        if not filter then return end
        -- Flags
        if filter.flags == false then
            payload.flags = {}
        elseif type(filter.flagEntries) == "table" then
            local stripped = {}
            for k, v in pairs(payload.flags or {}) do
                local baseKey = k:match("^(.+)/Locked$") or k
                if filter.flagEntries[baseKey] ~= false and filter.flagEntries[k] ~= false then
                    stripped[k] = v
                end
            end
            payload.flags = stripped
        end
        -- Whitelist
        if filter.whitelist == false then
            payload.whitelist = nil
        elseif type(filter.whitelistEntries) == "table" then
            local stripped = {}
            for k, v in pairs(payload.whitelist or {}) do
                if filter.whitelistEntries[tostring(k)] ~= false then stripped[k] = v end
            end
            payload.whitelist = stripped
        end
        -- Blacklist
        if filter.blacklist == false then
            payload.blacklist = nil
        elseif type(filter.blacklistEntries) == "table" then
            local stripped = {}
            for k, v in pairs(payload.blacklist or {}) do
                if filter.blacklistEntries[tostring(k)] ~= false then stripped[k] = v end
            end
            payload.blacklist = stripped
        end
        -- Team Whitelist
        if filter.teamWhitelist == false then
            payload.teamWhitelist = nil
        elseif type(filter.teamWhitelistEntries) == "table" then
            local stripped = {}
            for k, v in pairs(payload.teamWhitelist or {}) do
                if filter.teamWhitelistEntries[tostring(k)] ~= false then stripped[k] = v end
            end
            payload.teamWhitelist = stripped
        end
        -- Team Blacklist
        if filter.teamBlacklist == false then
            payload.teamBlacklist = nil
        elseif type(filter.teamBlacklistEntries) == "table" then
            local stripped = {}
            for k, v in pairs(payload.teamBlacklist or {}) do
                if filter.teamBlacklistEntries[tostring(k)] ~= false then stripped[k] = v end
            end
            payload.teamBlacklist = stripped
        end
        -- Priority List
        if filter.priorityList == false then
            payload.priorityList = nil
        elseif type(filter.priorityEntries) == "table" then
            local stripped = {}
            for i, entry in ipairs(payload.priorityList or {}) do
                if filter.priorityEntries[tostring(i)] ~= false then
                    table.insert(stripped, entry)
                end
            end
            payload.priorityList = stripped
        end
        -- WorldHum Presets
        if filter.worldHumPresets == false then
            payload.worldHumPresets = {}
        elseif type(filter.presetEntries) == "table" then
            local stripped = {}
            for _, preset in ipairs(payload.worldHumPresets or {}) do
                local pid = tostring(preset.Id or "")
                if filter.presetEntries[pid] ~= false then
                    table.insert(stripped, preset)
                end
            end
            payload.worldHumPresets = stripped
        end
    end

    -- Public API ────────────────────────────────────────────────────

    function ConfigManager.HasFileAPIs()
        return hasFileAPIs()
    end

    -- Save current settings as a Universal profile
    function ConfigManager.SaveUniversal(profileName, filter)
        if not hasFileAPIs() then
            return false, "writefile API unavailable"
        end
        local safeProfileName = (profileName or ""):gsub("[^%w%-%_%. ]", "")
        if safeProfileName:match("^%s*$") then
            return false, "Invalid name (contains only special characters or is empty)"
        end
        pcall(ensureDirs)
        local fileName = UNIVERSAL_DIR .. "/" .. safeProfileName .. ".json"
        local safePresets = {}
        if WorldHumState.Presets then
            for _, p in ipairs(WorldHumState.Presets) do
                local copy = {
                    Id = p.Id, TargetName = p.TargetName, TargetMode = p.TargetMode,
                    TargetCount = p.TargetCount, UpdateRate = p.UpdateRate,
                    Enabled = p.Enabled, HighlightEnabled = p.HighlightEnabled,
                    Properties = {}
                }
                if p.Properties then
                    for k, v in pairs(p.Properties) do copy.Properties[k] = v end
                end
                table.insert(safePresets, copy)
            end
        end

        local payload = {
            name            = profileName,
            autoLoad        = false,
            isPerGame       = false,
            placeId         = nil,
            savedAt         = os.time(),
            version         = VERSION,
            flags           = serializeFlags(),
            whitelist       = AdvancedPlayerPanelState.Whitelist,
            blacklist       = AdvancedPlayerPanelState.Blacklist,
            teamWhitelist   = AdvancedPlayerPanelState.TeamWhitelist,
            teamBlacklist   = AdvancedPlayerPanelState.TeamBlacklist,
            priorityList    = AdvancedPlayerPanelState.PriorityList,
            worldHumPresets = safePresets
        }
        applyFilterToPayload(payload, filter)
        local ok, err = pcall(writefile, fileName, encode(payload))
        if ok then
            return true, nil
        else
            return false, tostring(err)
        end
    end

    -- Save current settings as a Per-Game profile (tied to current PlaceId)
    function ConfigManager.SavePerGame(profileName, filter)
        if not hasFileAPIs() then
            return false, "writefile API unavailable"
        end
        local safeProfileName = (profileName or ""):gsub("[^%w%-%_%. ]", "")
        if safeProfileName:match("^%s*$") then
            return false, "Invalid name (contains only special characters or is empty)"
        end
        pcall(ensureDirs)
        local placeId  = tostring(game.PlaceId)
        local fileName = PERGAME_DIR .. "/" .. placeId .. "_" .. safeProfileName .. ".json"
        local safePresets = {}
        if WorldHumState.Presets then
            for _, p in ipairs(WorldHumState.Presets) do
                local copy = {
                    Id = p.Id, TargetName = p.TargetName, TargetMode = p.TargetMode,
                    TargetCount = p.TargetCount, UpdateRate = p.UpdateRate,
                    Enabled = p.Enabled, HighlightEnabled = p.HighlightEnabled,
                    Properties = {}
                }
                if p.Properties then
                    for k, v in pairs(p.Properties) do copy.Properties[k] = v end
                end
                table.insert(safePresets, copy)
            end
        end

        local payload = {
            name            = profileName,
            autoLoad        = false,
            isPerGame       = true,
            placeId         = placeId,
            savedAt         = os.time(),
            version         = VERSION,
            flags           = serializeFlags(),
            whitelist       = AdvancedPlayerPanelState.Whitelist,
            blacklist       = AdvancedPlayerPanelState.Blacklist,
            teamWhitelist   = AdvancedPlayerPanelState.TeamWhitelist,
            teamBlacklist   = AdvancedPlayerPanelState.TeamBlacklist,
            priorityList    = AdvancedPlayerPanelState.PriorityList,
            worldHumPresets = safePresets
        }
        applyFilterToPayload(payload, filter)
        local ok, err = pcall(writefile, fileName, encode(payload))
        if ok then
            return true, nil
        else
            return false, tostring(err)
        end
    end

    -- Load and return a list of profile entries for the given type ("Universal" or "PerGame")
    function ConfigManager.ListProfiles(profileType)
        local profiles = {}
        if not hasFileAPIs() then return profiles end
        pcall(ensureDirs)
        local dir = profileType == "PerGame" and PERGAME_DIR or UNIVERSAL_DIR
        local files = listdir(dir)
        for _, filePath in ipairs(files) do
            local baseName = fileBasename(filePath)
            if baseName:match("%.json$") then
                local ok, raw = pcall(readfile, filePath)
                if ok and raw then
                    local parsed = nil
                    pcall(function() parsed = decode(raw) end)
                    if parsed then
                        table.insert(profiles, {
                            name      = parsed.name or stripExtension(baseName),
                            fileName  = filePath,
                            autoLoad  = parsed.autoLoad == true,
                            isPerGame = parsed.isPerGame == true,
                            placeId   = parsed.placeId,
                        })
                    end
                end
            end
        end
        return profiles
    end

    -- Load (apply) a specific profile by file path
    function ConfigManager.LoadProfile(filePath)
        if not hasFileAPIs() then
            return false, "readfile API unavailable"
        end
        local ok, raw = pcall(readfile, filePath)
        if not ok or not raw then
            return false, "read error"
        end
        local parsed = nil
        local parseOk = pcall(function() parsed = decode(raw) end)
        if not parseOk or type(parsed) ~= "table" or type(parsed.flags) ~= "table" then
            return false, "parse error"
        end
        
        parsed.whitelist = type(parsed.whitelist) == "table" and parsed.whitelist or {}
        parsed.blacklist = type(parsed.blacklist) == "table" and parsed.blacklist or {}
        parsed.teamWhitelist = type(parsed.teamWhitelist) == "table" and parsed.teamWhitelist or {}
        parsed.teamBlacklist = type(parsed.teamBlacklist) == "table" and parsed.teamBlacklist or {}
        
        PROFILE_LOADED_FLAGS = {}
        applyFlags(parsed.flags)
        
        -- Returns fixed table (number-keyed JSON strings → real ints),
        -- or nil if the field is absent/non-table (preserving existing state).
        local function fixNumberKeys(t)
            if type(t) ~= "table" then return nil end
            local newT = {}
            local hasItems = false
            for k, v in pairs(t) do
                local cleanK = type(k) == "string" and k:match("^%s*(.-)%s*$") or k
                local numKey = tonumber(cleanK)
                if numKey and tostring(numKey) == cleanK then
                    newT[numKey] = v
                else
                    newT[k] = v
                end
                hasItems = true
            end
            if not hasItems then return nil end
            return newT
        end
        
        -- Only replace player-panel state when the saved field is actually present
        local wl = fixNumberKeys(parsed.whitelist);    if wl then AdvancedPlayerPanelState.Whitelist = wl end
        local bl = fixNumberKeys(parsed.blacklist);    if bl then AdvancedPlayerPanelState.Blacklist = bl end
        local twl = fixNumberKeys(parsed.teamWhitelist); if twl then AdvancedPlayerPanelState.TeamWhitelist = twl end
        local tbl = fixNumberKeys(parsed.teamBlacklist); if tbl then AdvancedPlayerPanelState.TeamBlacklist = tbl end
        if type(parsed.priorityList) == "table" then
            AdvancedPlayerPanelState.PriorityList = parsed.priorityList
        end
        WorldHumState.Presets = type(parsed.worldHumPresets) == "table" and parsed.worldHumPresets or {}
        
        pcall(function()
            if type(UpdateAdvancedPlayerList) == "function" then UpdateAdvancedPlayerList() end
            if type(UpdateSettingsPanelList) == "function" then UpdateSettingsPanelList() end
            if type(UpdateTeamPanelList) == "function" then UpdateTeamPanelList() end
        end)
        
        do
            for k, savedVal in pairs(parsed.flags) do
                if FLAG_METADATA[k] and FLAG_METADATA[k].ReadOnly then continue end
                if k:match("^Humanoid/") and not k:match("/Locked$") then
                    local currentVal = Flags[k] ~= nil and Flags[k] or savedVal
                    local isLocked   = (parsed.flags[k .. "/Locked"] == true)
                                    or (Flags[k .. "/Locked"] == true)

                    -- Sync lock-button icon (updater registered in CreateToggle/CreateNumericInput)
                    if isLocked then
                        local lockUpd = UIState and UIState.Updaters and UIState.Updaters[k .. "/Locked"]
                        if lockUpd then task.defer(function() pcall(lockUpd, true) end) end
                    end

                    -- Sync value display in the UI widget
                    local valUpd = UIState and UIState.Updaters and UIState.Updaters[k]
                    if valUpd then task.defer(function() pcall(valUpd, currentVal) end) end

                    -- Live Humanoid write is handled by ApplyHumanoidSettings() on the next heartbeat tick
                    -- no direct push needed here.
                end
            end
        end


        return true, parsed.name or "Unknown"
    end

    -- Delete a profile file
    function ConfigManager.DeleteProfile(filePath)
        if not hasFileAPIs() then
            return false, "file API unavailable"
        end
        if type(delfile) ~= "function" then
            -- Fallback: overwrite with empty string to clear (some executors lack delfile)
            local ok = pcall(writefile, filePath, "")
            return ok, ok and nil or "delfile unavailable and writefile fallback failed"
        end
        local ok, err = pcall(delfile, filePath)
        return ok, ok and nil or tostring(err)
    end

    -- Toggle the autoLoad state of a profile and re-save it
    function ConfigManager.SetAutoLoad(filePath, state)
        if not hasFileAPIs() then
            return false, "file API unavailable"
        end
        local ok, raw = pcall(readfile, filePath)
        if not ok or not raw then return false, "read error" end
        local parsed = nil
        pcall(function() parsed = decode(raw) end)
        if not parsed then return false, "parse error" end
        parsed.autoLoad = state == true
        local writeOk, writeErr = pcall(writefile, filePath, encode(parsed))
        return writeOk, writeOk and nil or tostring(writeErr)
    end

    -- Overwrite an existing profile's flags in-place (preserves name, autoLoad, placeId, etc.)
    function ConfigManager.OverwriteProfile(filePath, filter)
        if not hasFileAPIs() then
            return false, "file API unavailable"
        end
        local ok, raw = pcall(readfile, filePath)
        if not ok or not raw then return false, "read error" end
        local parsed = nil
        pcall(function() parsed = decode(raw) end)
        if not parsed then return false, "parse error" end

        -- Build updated flags cleanly:
        --   1. Start with the profile's original keys, updated with current live values.
        --   2. Add any flags the user *explicitly* touched this session (USER_MODIFIED_FLAGS).
        -- This prevents flags loaded from OTHER profiles (PROFILE_LOADED_FLAGS) from
        -- bleeding into this profile when overwriting.
        local function encodeVal(v)
            if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
                return v
            elseif type(v) == "table" then
                local copy = {}
                for k2, v2 in pairs(v) do copy[k2] = v2 end
                return copy
            elseif typeof(v) == "Color3" then
                return {__type = "Color3", R = v.R, G = v.G, B = v.B}
            elseif typeof(v) == "EnumItem" then
                return {__type = "EnumItem", EnumType = tostring(v.EnumType), Name = v.Name}
            end
            return nil
        end

        local originalFlags = type(parsed.flags) == "table" and parsed.flags or {}
        local newFlags = {}

        -- Step 1: Update original profile flags with current live values
        for k in pairs(originalFlags) do
            local liveVal = Flags[k]
            local encoded = liveVal ~= nil and encodeVal(liveVal)
            newFlags[k] = encoded ~= nil and encoded or originalFlags[k]
        end

        -- Step 2: Merge in flags the user explicitly interacted with this session
        for k in pairs(USER_MODIFIED_FLAGS) do
            if not newFlags[k] and Flags[k] ~= nil then
                local encoded = encodeVal(Flags[k])
                if encoded ~= nil then
                    newFlags[k] = encoded
                end
            end
        end

        local safePresets = {}
        if WorldHumState.Presets then
            for _, p in ipairs(WorldHumState.Presets) do
                local copy = {
                    Id = p.Id, TargetName = p.TargetName, TargetMode = p.TargetMode,
                    TargetCount = p.TargetCount, UpdateRate = p.UpdateRate,
                    Enabled = p.Enabled, HighlightEnabled = p.HighlightEnabled,
                    Properties = {}
                }
                if p.Properties then
                    for k, v in pairs(p.Properties) do copy.Properties[k] = v end
                end
                table.insert(safePresets, copy)
            end
        end

        parsed.flags           = newFlags
        parsed.whitelist       = AdvancedPlayerPanelState.Whitelist
        parsed.blacklist       = AdvancedPlayerPanelState.Blacklist
        parsed.teamWhitelist   = AdvancedPlayerPanelState.TeamWhitelist
        parsed.teamBlacklist   = AdvancedPlayerPanelState.TeamBlacklist
        parsed.priorityList    = AdvancedPlayerPanelState.PriorityList
        parsed.worldHumPresets = safePresets
        parsed.savedAt = os.time()
        parsed.version = VERSION
        applyFilterToPayload(parsed, filter)
        
        if not ConfigManager.IsDirty then
            return true, parsed.name or "Unknown"
        end
        
        local writeOk, writeErr = pcall(writefile, filePath, encode(parsed))
        if writeOk then ConfigManager.IsDirty = false end
        return writeOk, writeOk and (parsed.name or "Unknown") or tostring(writeErr)
    end

    -- Rename a profile (write new file, delete old)
    function ConfigManager.RenameProfile(filePath, newName, profileType)
        if not hasFileAPIs() then
            return false, "file API unavailable"
        end
        if not newName or newName:match("^%s*$") then
            return false, "empty name"
        end
        local ok, raw = pcall(readfile, filePath)
        if not ok or not raw then return false, "read error" end
        local parsed = nil
        pcall(function() parsed = decode(raw) end)
        if not parsed then return false, "parse error" end

        local oldName = parsed.name or "profile"
        parsed.name = newName

        local dir = profileType == "PerGame" and PERGAME_DIR or UNIVERSAL_DIR
        local newFileName
        if profileType == "PerGame" and parsed.placeId then
            local safeNewName = newName:gsub("[^%w%-%_%. ]", "")
            newFileName = dir .. "/" .. parsed.placeId .. "_" .. safeNewName .. ".json"
        else
            newFileName = dir .. "/" .. newName .. ".json"
        end

        local writeOk, writeErr = pcall(writefile, newFileName, encode(parsed))
        if not writeOk then return false, tostring(writeErr) end

        -- Delete old file
        pcall(function()
            if type(delfile) == "function" then
                delfile(filePath)
            else
                writefile(filePath, "")
            end
        end)

        return true, oldName
    end

    -- Reset all Flags to their hardcoded defaults and push UI updates
    function ConfigManager.ResetToDefaults()
        for k, v in pairs(DEFAULT_FLAGS) do
            if type(v) == "table" then
                if type(Flags[k]) == "table" then
                    for k2, v2 in pairs(v) do
                        Flags[k][k2] = v2
                    end
                else
                    local copy = {}
                    for k2, v2 in pairs(v) do copy[k2] = v2 end
                    Flags[k] = copy
                end
            else
                Flags[k] = v
            end
            if UIState and UIState.Updaters and UIState.Updaters[k] then
                if type(UIState.Updaters[k]) == "function" then
                    pcall(UIState.Updaters[k], Flags[k])
                elseif type(UIState.Updaters[k]) == "table" then
                    -- Nested updater table (e.g. Aim/TargetGroups): call each per-key updater.
                    for k2, updater in pairs(UIState.Updaters[k]) do
                        if type(updater) == "function" and type(Flags[k]) == "table" then
                            pcall(updater, Flags[k][k2])
                        end
                    end
                end
            end
        end
        for k in pairs(USER_MODIFIED_FLAGS) do
            rawset(USER_MODIFIED_FLAGS, k, nil)
        end
        PROFILE_LOADED_FLAGS = {}
    end

    -- Startup Auto-Load Logic ───────────────────────────────────────
    -- Runs synchronously before UI is built. Priority:
    --   1. Universal profiles with autoLoad=true
    --   2. Per-Game profiles matching current PlaceId with autoLoad=true
    --   3. Fallback to defaults (no-op — already loaded)
    local function RunStartupAutoLoad()
        if not hasFileAPIs() then
            -- Notify is not yet available at this point; defer to a post-UI notification
            ConfigManager._startupNotifies = {{ kind = "no_api" }}
            return
        end

        pcall(ensureDirs)

        local currentPlaceId = tostring(game.PlaceId)
        ConfigManager._startupPayloads = {}
        ConfigManager._startupNotifies = {}

        -- Scan Universal profiles
        local universalProfiles = {}
        local uFiles = listdir(UNIVERSAL_DIR)
        for _, filePath in ipairs(uFiles) do
            local baseName = fileBasename(filePath)
            if baseName:match("%.json$") then
                local ok, raw = pcall(readfile, filePath)
                if ok and raw then
                    local parsed = nil
                    pcall(function() parsed = decode(raw) end)
                    if parsed then
                        table.insert(universalProfiles, {parsed = parsed, filePath = filePath})
                    end
                end
            end
        end

        -- Scan Per-Game profiles
        local perGameProfiles = {}
        local pgFiles = listdir(PERGAME_DIR)
        for _, filePath in ipairs(pgFiles) do
            local baseName = fileBasename(filePath)
            if baseName:match("%.json$") then
                local ok, raw = pcall(readfile, filePath)
                if ok and raw then
                    local parsed = nil
                    pcall(function() parsed = decode(raw) end)
                    if parsed then
                        table.insert(perGameProfiles, {parsed = parsed, filePath = filePath})
                    end
                end
            end
        end

        local loadedAny = false

        -- Apply Universal profiles first so Per-Game overrides them
        for _, entry in ipairs(universalProfiles) do
            local p = entry.parsed
            if p.autoLoad == true and type(p.flags) == "table" then
                table.insert(ConfigManager._startupPayloads, entry.filePath)
                table.insert(ConfigManager._startupNotifies, {
                    kind        = "universal",
                    profileName = p.name or "Unknown"
                })
                print(string.format("[Sp3arParvus] Config: Universal profile \"%s\" auto-loaded.", p.name or "?"))
                loadedAny = true
            end
        end

        -- Then apply Per-Game profiles
        for _, entry in ipairs(perGameProfiles) do
            local p = entry.parsed
            if p.autoLoad == true and tostring(p.placeId) == currentPlaceId and type(p.flags) == "table" then
                table.insert(ConfigManager._startupPayloads, entry.filePath)
                table.insert(ConfigManager._startupNotifies, {
                    kind        = "pergame",
                    profileName = p.name or "Unknown",
                    placeId     = currentPlaceId
                })
                print(string.format("[Sp3arParvus] Config: Per-game profile \"%s\" auto-loaded for PlaceId %s.", p.name or "?", currentPlaceId))
                loadedAny = true
            end
        end

        -- Fallback — notify only if profiles exist but none auto-load
        if not loadedAny then
            local totalProfiles = #perGameProfiles + #universalProfiles
            if totalProfiles > 0 then
                table.insert(ConfigManager._startupNotifies, {
                    kind  = "defaults_with_profiles",
                    count = totalProfiles
                })
                print(string.format("[Sp3arParvus] Config: %d profile(s) found, none with auto-load enabled. Loading defaults.", totalProfiles))
            else
                -- Silent — first run
                print("[Sp3arParvus] Config: No saved profiles found. Using defaults.")
            end
        end
    end

    RunStartupAutoLoad()
end

local ScreenGui = nil
local FovCircleFrame = nil
local UI = {}
local UI_THEME = {
    Background = Color3.fromRGB(18, 18, 18),
    Sidebar = Color3.fromRGB(25, 25, 25),
    Element = Color3.fromRGB(32, 32, 32),
    Accent = Color3.fromRGB(252, 149, 175),
    Text = Color3.fromRGB(240, 240, 240),
    TextDark = Color3.fromRGB(150, 150, 150),
    Success = Color3.fromRGB(0, 220, 100),
    Fail = Color3.fromRGB(220, 50, 50)
}

UIState = {
    MainFrame = nil,
    PriorityLabel = nil,
    Tabs = {},
    CurrentTab = nil,
    Visible = true,
    Minimized = false,
    ToggleMinimize = nil,
    DraggableFrames = {},
    Updaters = {},
    ActiveDraggedFrame = nil,
    DragStart = nil,
    StartPos = nil
}
local PROPERTY_CATEGORIES = {
    Data = {"Name", "ClassName", "Value", "Text"},
    Appearance = {"Color", "BrickColor", "Transparency", "Reflectance", "Material"},
    Behavior = {"CanCollide", "CanTouch", "CanQuery", "Anchored", "Locked", "Archivable"},
    Stats = {"Health", "MaxHealth", "WalkSpeed", "JumpPower", "JumpHeight"},
    Transform = {"Position", "Size", "Rotation", "CFrame"}
}

AdvancedPlayerPanelState = {
    Visible = false,
    CurrentView = "List",
    SelectedPlayer = nil,
    Spectating = nil,
    ListTab = "All",
    DetailsTab = "General",
    ExplorerExpanded = {},
    ExplorerSelected = nil,
    PropertySearchText = "",
    Whitelist = {},
    Blacklist = {},
    TeamWhitelist = {},
    TeamBlacklist = {},
    TeamExpanded = {},
    PlayerRowCache = {},
    PriorityList = {}
}

local ItemPanelState = {
    Visible = false,
    lockedProperties = {},
    selectedItem = nil,
    explorerExpanded = {},
    explorerSelected = nil,
    PropertySearchText = ""
}

function ToggleWhitelist(player)
    if not player then return end
    local id = player.UserId
    AdvancedPlayerPanelState.Whitelist[id] = not AdvancedPlayerPanelState.Whitelist[id]
    if AdvancedPlayerPanelState.Whitelist[id] then
        AdvancedPlayerPanelState.Blacklist[id] = nil
        UI.Notify("Player Whitelisted ☮️", player.Name .. " has been whitelisted.", 3)
    else
        UI.Notify("Player unWhitelisted ☮️", player.Name .. " has been unwhitelisted.", 3)
    end
end

function ToggleBlacklist(player)
    if not player then return end
    local id = player.UserId
    AdvancedPlayerPanelState.Blacklist[id] = not AdvancedPlayerPanelState.Blacklist[id]
    if AdvancedPlayerPanelState.Blacklist[id] then
        AdvancedPlayerPanelState.Whitelist[id] = nil
        UI.Notify("Player Blacklisted ☠️", player.Name .. " has been blacklisted.", 3)
    else
        UI.Notify("Player unBlacklisted ☠️", player.Name .. " has been unblacklisted.", 3)
    end
end

function ToggleTeamWhitelist(teamName)
    if not teamName then return end
    AdvancedPlayerPanelState.TeamWhitelist[teamName] = not AdvancedPlayerPanelState.TeamWhitelist[teamName]
    if AdvancedPlayerPanelState.TeamWhitelist[teamName] then
        AdvancedPlayerPanelState.TeamBlacklist[teamName] = nil
        UI.Notify("Team Whitelisted ☮️", "Team " .. teamName .. " has been whitelisted.", 3)
    else
        UI.Notify("Team unWhitelisted ☮️", "Team " .. teamName .. " has been unwhitelisted.", 3)
    end
end

function ToggleTeamBlacklist(teamName)
    if not teamName then return end
    AdvancedPlayerPanelState.TeamBlacklist[teamName] = not AdvancedPlayerPanelState.TeamBlacklist[teamName]
    if AdvancedPlayerPanelState.TeamBlacklist[teamName] then
        AdvancedPlayerPanelState.TeamWhitelist[teamName] = nil
        UI.Notify("Team Blacklisted ☠️", "Team " .. teamName .. " has been blacklisted.", 3)
    else
        UI.Notify("Team unBlacklisted ☠️", "Team " .. teamName .. " has been unblacklisted.", 3)
    end
end

function GetPriorityRank(player, teamName)
    if not AdvancedPlayerPanelState.PriorityList then return nil end
    for index, item in ipairs(AdvancedPlayerPanelState.PriorityList) do
        if item.type == "Player" then
            if player.UserId == item.value or player.Name == item.value then
                return index
            end
        elseif item.type == "Team" then
            if teamName == item.value then
                return index
            end
        end
    end
    return nil
end

function IsPlayerPrioritized(player)
    if not player then return false end
    for _, item in ipairs(AdvancedPlayerPanelState.PriorityList) do
        if item.type == "Player" and (item.value == player.UserId or item.value == player.Name) then
            return true
        end
    end
    return false
end

function TogglePlayerPriority(player)
    if not player then return end
    local foundIdx = nil
    for i, item in ipairs(AdvancedPlayerPanelState.PriorityList) do
        if item.type == "Player" and (item.value == player.UserId or item.value == player.Name) then
            foundIdx = i
            break
        end
    end

    if foundIdx then
        table.remove(AdvancedPlayerPanelState.PriorityList, foundIdx)
        UI.Notify("Player Deprioritized ⭐", player.Name .. " has been deprioritized.", 3)
    else
        table.insert(AdvancedPlayerPanelState.PriorityList, {
            type = "Player",
            value = player.Name
        })
        UI.Notify("Player Prioritized ⭐", player.Name .. " has been prioritized.", 3)
    end
end

function IsTeamPrioritized(teamName)
    if not teamName then return false end
    for _, item in ipairs(AdvancedPlayerPanelState.PriorityList) do
        if item.type == "Team" and item.value == teamName then
            return true
        end
    end
    return false
end

function ToggleTeamPriority(teamName)
    if not teamName then return end
    local foundIdx = nil
    for i, item in ipairs(AdvancedPlayerPanelState.PriorityList) do
        if item.type == "Team" and item.value == teamName then
            foundIdx = i
            break
        end
    end

    if foundIdx then
        table.remove(AdvancedPlayerPanelState.PriorityList, foundIdx)
        UI.Notify("Player Explorer", "Team " .. teamName .. " has been deprioritized.", 3)
    else
        table.insert(AdvancedPlayerPanelState.PriorityList, {
            type = "Team",
            value = teamName
        })
        UI.Notify("Player Explorer", "Team " .. teamName .. " has been prioritized.", 3)
    end
end
local AdvancedPlayerPanelUI = {
    MainFrame = nil,
    ListFrame = nil,
    DetailsFrame = nil,
    Entries = {},
    DetailLabels = {},
    TabButtons = {},
    DetailsTabButtons = {},
    PropertyFrame = nil,
    PropertyContent = nil,
    PropertySearch = nil
}

local SwitchToPlayerPageView
local UpdateActionButtonsState

local ItemPanelUI = {
    MainFrame = nil,
    ExplorerContent = nil,
    PropertyContent = nil,
    PropertyFrame = nil,
    PropertySearch = nil,
    ExplorerCounter = 0
}
local HumanoidState = {
    originalSettings = {},
    captured = false,
    presetsApplied = false
}
WorldHumState = {
    selectedHum = nil,
    Page = nil,
    SubPage = "List",
    lockedProperties = {},
    connections = {},
    updaters = {},
    listEntries = {},
    selectionHighlight = nil,
    presetsApplied = {},
    Presets = {},
    presetCountLabels = {} -- [presetId] = TextLabel, kept live for Manager page refresh
}
local Br3ak3rState = {
    FilterDirty = true,
    CLICKBREAK_ENABLED = true,
    brokenSet = {},
    brokenIgnoreCache = {},
    scratchIgnore = {},
    brokenCacheDirty = true,
    undoStack = {},
    hoverHL = nil,
    CTRL_HELD = false,
    LEFT_CTRL_HELD = false,
    RIGHT_CTRL_HELD = false,
    lastEnforcement = 0,
    br3akerRaycastParams = RaycastParams.new()
}
Br3ak3rState.br3akerRaycastParams.IgnoreWater = true
local H1ghl1ght3rState = {
    ENABLED = true,
    highlightedSet = {},
    undoStack = {},
    SHIFT_HELD = false
}
local FullbrightState = {
    lastState = false,
    originalSettings = nil
}
local ZoomState = {
    OriginalMax = LocalPlayer.CameraMaxZoomDistance,
    OriginalMin = LocalPlayer.CameraMinZoomDistance,
    LastSetMax = nil,
    LastSetMin = nil,
    Multiplier = 1,
    WasCtrlHeld = false,
    UserScrolled = false
}

local LocalCharReady = true
function OnLocalCharacterAdded(newChar)
    LocalCharReady = false
    if Br3ak3rState then Br3ak3rState.FilterDirty = true end

    if CharCache then table.clear(CharCache) end

    HumanoidState.captured = false
    HumanoidState.presetsApplied = false

    task.wait(1.5)

    local root = nil
    local humanoid = nil
    local attempts = 0
    repeat
        task.wait(0.2)
        root = newChar:FindFirstChild("HumanoidRootPart") or newChar.PrimaryPart
        humanoid = newChar:FindFirstChildOfClass("Humanoid")
        attempts = attempts + 1
    until (root and humanoid) or attempts > 25

    if not humanoid then
        local humConn
        humConn = newChar.ChildAdded:Connect(function(child)
            if child:IsA("Humanoid") then
                humConn:Disconnect()
                CaptureHumanoidSettings(child)
                print("[Sp3arParvus] Humanoid detected late (deferred spawn) and captured.")
            end
        end)
    else
        CaptureHumanoidSettings(humanoid)
    end

    LocalCharReady = true
    print("[Sp3arParvus] Local character re-cached and ready.")
end

globalEnv = getgenv and getgenv() or _G
if rawget(globalEnv, "Sp3arParvus") then
    return warn("[Sp3arParvus] Already loaded! Use Shutdown button to cleanup first.")
end

globalEnv.Sp3arParvus = {
    Active = true,
    Version = VERSION,
    Connections = {},
    Threads = {}
}
Sp3arParvus = globalEnv.Sp3arParvus

function TrackConnection(connection)
    if connection and typeof(connection) == "RBXScriptConnection" then
        table.insert(Sp3arParvus.Connections, connection)
    end
    return connection
end

function TrackThread(thread)
    if thread and type(thread) == "thread" then
        table.insert(Sp3arParvus.Threads, thread)
    end
    return thread
end

function CleanupDeadConnections()
    local connections = Sp3arParvus.Connections
    local n = #connections
    local i = 1
    while i <= n do
        local conn = connections[i]
        if not conn or not conn.Connected then
            connections[i] = connections[n]
            connections[n] = nil
            n = n - 1
        else
            i = i + 1
        end
    end
end

function CleanupDeadThreads()
    local threads = Sp3arParvus.Threads
    local n = #threads
    local i = 1
    while i <= n do
        local t = threads[i]
        if not t or coroutine.status(t) == "dead" then
            threads[i] = threads[n]
            threads[n] = nil
            n = n - 1
        else
            i = i + 1
        end
    end
end

TrackConnection(LocalPlayer.CharacterAdded:Connect(OnLocalCharacterAdded))

local Services = {
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    Lighting = game:GetService("Lighting"),
    TeleportService = game:GetService("TeleportService"),
    Stats = game:GetService("Stats"),
    GuiService = game:GetService("GuiService"),
    TweenService = game:GetService("TweenService"),
    Workspace = game:GetService("Workspace"),
    Players = game:GetService("Players"),
    VirtualUser = game:GetService("VirtualUser"),
    TextService = game:GetService("TextService")
}
local RunService, UserInputService, Lighting, TeleportService, Stats, GuiService, TweenService, Workspace, Players, VirtualUser, TextService =
    Services.RunService, Services.UserInputService, Services.Lighting, Services.TeleportService, Services.Stats, Services.GuiService, Services.TweenService, Services.Workspace, Services.Players, Services.VirtualUser, Services.TextService

TrackConnection(LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end))

function ResolveEnumItem(enumContainer, possibleNames)
    for _, name in ipairs(possibleNames) do
        local success, enumItem = pcall(function()
            return enumContainer[name]
        end)

        if success and enumItem and typeof(enumItem) == "EnumItem" then
            return enumItem
        end
    end

    return nil
end

local Camera = Services.Workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

local Vector3new, Vector2new, CFramenew, UDim2new, Instancenew, RaycastParamsnew, Color3fromRGB, Color3new =
    Vector3.new, Vector2.new, CFrame.new, UDim2.new, Instance.new, RaycastParams.new, Color3.fromRGB, Color3.new
local abs, floor, max, min, sqrt = math.abs, math.floor, math.max, math.min, math.sqrt
local deg, atan2, rad, sin, cos = math.deg, math.atan2, math.rad, math.sin, math.cos

local function _setProp(obj, prop, val) obj[prop] = val end
local function PcallSetProp(obj, prop, val)
    return pcall(_setProp, obj, prop, val)
end

local function _safeSetProp(obj, prop, val)
    if obj[prop] ~= val then
        obj[prop] = val
        return true
    end
    return false
end
local function PcallSafeSetProp(obj, prop, val)
    local ok, changed = pcall(_safeSetProp, obj, prop, val)
    return ok and changed
end

local function _destroy(obj) if obj then obj:Destroy() end end
local function PcallDestroy(obj)
    return pcall(_destroy, obj)
end

local function _setEnabled(obj, state) obj.Enabled = state end
local function PcallSetEnabled(obj, state)
    return pcall(_setEnabled, obj, state)
end

local function _disconnect(conn) if conn and conn.Connected then conn:Disconnect() end end
local function PcallDisconnect(conn)
    return pcall(_disconnect, conn)
end

local _DNR_SET = {
    [125458810] = true
}
function DNR(Player)
    return (Player and _DNR_SET[Player.UserId]) or false
end

local function _getParent(obj) return obj.Parent end
local function PcallGetParent(obj)
    local ok, res = pcall(_getParent, obj)
    return ok and res or nil
end

local function SafeSetProp(obj, prop, val)
    if obj[prop] ~= val then
        obj[prop] = val
    end
end

local function SafeGetProp(obj, prop)
    return obj[prop]
end

local function BoundedInsertionSort(array, count, compare)
    for i = 2, count do
        local key = array[i]
        local j = i - 1
        while j > 0 and compare(key, array[j]) do
            array[j + 1] = array[j]
            j = j - 1
        end
        array[j + 1] = key
    end
end

local TWEENS = {
    INSTANT = TweenInfo.new(0.05),
    FAST = TweenInfo.new(0.1),
    MEDIUM = TweenInfo.new(0.2),
    SMOOTH = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    BACK = TweenInfo.new(0.3, Enum.EasingStyle.Back),
    DRAG = TweenInfo.new(0.05)
}

local ViewportCache = {}
local ViewportPool = {}
local _vp_floor = math.floor
local MAX_VIEWPORT_POOL = 64
TrackConnection(RunService.RenderStepped:Connect(function()
    local recycled = 0
    for _, entry in pairs(ViewportCache) do
        if recycled < MAX_VIEWPORT_POOL then
            ViewportPool[#ViewportPool + 1] = entry
            recycled = recycled + 1
        end
    end
    table.clear(ViewportCache)
end))

local function GetViewportPoint(worldPos)
    local kx = _vp_floor(worldPos.X * 4)
    local ky = _vp_floor(worldPos.Y * 4)
    local kz = _vp_floor(worldPos.Z * 4)
    local key = kx .. "|" .. ky .. "|" .. kz
    local entry = ViewportCache[key]
    if entry then
        return entry[1], entry[2]
    end
    local screenPos, onScreen = Camera:WorldToViewportPoint(worldPos)
    entry = table.remove(ViewportPool) or {}
    entry[1], entry[2] = screenPos, onScreen
    ViewportCache[key] = entry
    return screenPos, onScreen
end

local cachedPlayersList = {}

function InitPlayerCache()
    cachedPlayersList = Players:GetPlayers()
end
InitPlayerCache()

function GetPlayersCache()
    return cachedPlayersList
end

function UpdatePlayerCache()
    cachedPlayersList = Players:GetPlayers()
end

function AddPlayerToCache(player)
    if not table.find(cachedPlayersList, player) then
        table.insert(cachedPlayersList, player)
    end
end

function RemovePlayerFromCache(player)
    local idx = table.find(cachedPlayersList, player)
    if idx then
        table.remove(cachedPlayersList, idx)
    end
end

local AIM_ACQUIRE_STABILIZE_FRAMES = 2
local AIM_ORIGIN_JUMP_RATIO = 0.25

function ClearAimLockState(resetMouseMode)
    AimState.LastAimTarget = nil
    AimState.LastOriginX = nil
    AimState.LastOriginY = nil
    AimState.AcquiringFrames = 0

    if resetMouseMode then
        AimState.LastMouseMode = nil
    end
end

function GetCrosshairViewportPosition(mouseBehavior)
    if not Camera then
        Camera = Services.Workspace.CurrentCamera
    end
    if not Camera then
        return nil, nil, false
    end

    local viewportSize = Camera.ViewportSize

    if mouseBehavior == Enum.MouseBehavior.LockCenter then
        return viewportSize.X * 0.5, viewportSize.Y * 0.5, true
    end

    local mouseLoc = Services.UserInputService:GetMouseLocation()

    local crosshairX = mouseLoc.X
    local crosshairY = mouseLoc.Y

    if crosshairX ~= crosshairX or crosshairY ~= crosshairY then
        return nil, nil, false
    end

    if crosshairX < 0 or crosshairY < 0 or crosshairX > viewportSize.X or crosshairY > viewportSize.Y then
        return nil, nil, false
    end

    return crosshairX, crosshairY, true
end

local CachedTarget = nil
local CachedTargetTime = 0

local TARGET_GROUPS = {
    Head = {"Head"},
    Torso = {"Torso", "UpperTorso", "LowerTorso", "HumanoidRootPart"},
    LeftArm = {"Left Arm", "LeftUpperArm", "LeftLowerArm", "LeftHand"},
    RightArm = {"Right Arm", "RightUpperArm", "RightLowerArm", "RightHand"},
    LeftLeg = {"Left Leg", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot"},
    RightLeg = {"Right Leg", "RightUpperLeg", "RightLowerLeg", "RightFoot"}
}

local ALL_BODY_PARTS = {}
for _, group in pairs(TARGET_GROUPS) do
    for _, part in ipairs(group) do
        table.insert(ALL_BODY_PARTS, part)
    end
end

KnownBodyParts = ALL_BODY_PARTS

local PART_TO_CATEGORY = {}
for _cat, _parts in pairs(TARGET_GROUPS) do
    for _, _pName in ipairs(_parts) do
        PART_TO_CATEGORY[_pName] = _cat
    end
end

local HUMANOID_PROPERTY_MAPPING = {
    ["Humanoid/Archivable"] = "Archivable",
    ["Humanoid/BreakJointsOnDeath"] = "BreakJointsOnDeath",
    ["Humanoid/EvaluateStateMachine"] = "EvaluateStateMachine",
    ["Humanoid/RequiresNeck"] = "RequiresNeck",
    ["Humanoid/AutoRotate"] = "AutoRotate",
    ["Humanoid/PlatformStand"] = "PlatformStand",
    ["Humanoid/Sit"] = "Sit",
    ["Humanoid/Jump"] = "Jump",
    ["Humanoid/AutoJumpEnabled"] = "AutoJumpEnabled",
    ["Humanoid/JumpHeight"] = "JumpHeight",
    ["Humanoid/JumpPower"] = "JumpPower",
    ["Humanoid/UseJumpPower"] = "UseJumpPower",
    ["Humanoid/AutomaticScalingEnabled"] = "AutomaticScalingEnabled",
    -- "Humanoid/Health" intentionally excluded: it is a live runtime property that
    -- fluctuates as the player takes/regenerates damage. Periodically re-applying a
    -- stale stored value (every ~0.1 s via ApplyHumanoidSettings) would cause the game
    -- to fire HealthChanged events in a loop, making any damage indicator animation
    -- repeat continuously while the player's health regenerates.
    ["Humanoid/MaxHealth"] = "MaxHealth",
    ["Humanoid/HipHeight"] = "HipHeight",
    ["Humanoid/MaxSlopeAngle"] = "MaxSlopeAngle",
    ["Humanoid/WalkSpeed"] = "WalkSpeed"
}

local HUMANOID_ENFORCED_PROPERTIES = {
    ["Humanoid/Archivable"] = "Archivable",
    ["Humanoid/BreakJointsOnDeath"] = "BreakJointsOnDeath",
    ["Humanoid/EvaluateStateMachine"] = "EvaluateStateMachine",
    ["Humanoid/RequiresNeck"] = "RequiresNeck",
    ["Humanoid/AutoRotate"] = "AutoRotate",
    ["Humanoid/PlatformStand"] = "PlatformStand",
    ["Humanoid/AutoJumpEnabled"] = "AutoJumpEnabled",
    ["Humanoid/UseJumpPower"] = "UseJumpPower",
    ["Humanoid/AutomaticScalingEnabled"] = "AutomaticScalingEnabled",
    ["Humanoid/MaxHealth"] = "MaxHealth",
    ["Humanoid/MaxSlopeAngle"] = "MaxSlopeAngle"
}

function TrackWorldHumConnection(connection)
    if connection and typeof(connection) == "RBXScriptConnection" then
        table.insert(WorldHumState.connections, connection)
    end
    return connection
end

function ClearWorldHumConnections()
    for _, conn in ipairs(WorldHumState.connections) do
        if conn.Connected then
            conn:Disconnect()
        end
    end
    table.clear(WorldHumState.connections)
    table.clear(WorldHumState.updaters)
    table.clear(WorldHumState.presetsApplied)
    table.clear(WorldHumState.presetCountLabels)
end

function CaptureHumanoidSettings(humanoid)
    if not humanoid or HumanoidState.captured then return end
    HumanoidState.presetsApplied = false

    local properties = {
        "Archivable", "BreakJointsOnDeath", "EvaluateStateMachine", "RequiresNeck",
        "AutoRotate", "PlatformStand", "Sit", "Jump", "AutoJumpEnabled",
        "JumpHeight", "JumpPower", "UseJumpPower", "AutomaticScalingEnabled",
        -- "Health" intentionally excluded: it is a live runtime value that changes as
        -- the player takes/regenerates damage. Capturing and re-applying it would cause
        -- the damage indicator to loop while health regenerates back to the stored value.
        "MaxHealth", "HipHeight", "MaxSlopeAngle", "WalkSpeed"
    }

    local flagMapping = {
        Archivable = "Humanoid/Archivable",
        BreakJointsOnDeath = "Humanoid/BreakJointsOnDeath",
        EvaluateStateMachine = "Humanoid/EvaluateStateMachine",
        RequiresNeck = "Humanoid/RequiresNeck",
        AutoRotate = "Humanoid/AutoRotate",
        PlatformStand = "Humanoid/PlatformStand",
        Sit = "Humanoid/Sit",
        Jump = "Humanoid/Jump",
        AutoJumpEnabled = "Humanoid/AutoJumpEnabled",
        JumpHeight = "Humanoid/JumpHeight",
        JumpPower = "Humanoid/JumpPower",
        UseJumpPower = "Humanoid/UseJumpPower",
        AutomaticScalingEnabled = "Humanoid/AutomaticScalingEnabled",
        -- Health intentionally omitted: see properties list comment above.
        MaxHealth = "Humanoid/MaxHealth",
        HipHeight = "Humanoid/HipHeight",
        MaxSlopeAngle = "Humanoid/MaxSlopeAngle",
        WalkSpeed = "Humanoid/WalkSpeed"
    }

    for _, prop in ipairs(properties) do
        pcall(function()
            local val = humanoid[prop]
            HumanoidState.originalSettings[prop] = val

            if flagMapping[prop] then
                local flag = flagMapping[prop]
                if not USER_MODIFIED_FLAGS[flag] and not PROFILE_LOADED_FLAGS[flag] then
                    Flags[flag] = val
                    local updater = UIState.Updaters[flag]
                    if updater then
                        updater(val)
                    end
                end
            end
        end)
    end

    HumanoidState.captured = true
    print("[Sp3arParvus] Local Humanoid settings captured and synced.")
end

function ApplyHumanoidSettings()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")

    if not humanoid then return end

    if HumanoidState.captured then
        for flag, prop in pairs(HUMANOID_PROPERTY_MAPPING) do
            local isLocked     = Flags[flag .. "/Locked"] == true
            local meta         = FLAG_METADATA[flag]

            local isConfigured
            if meta and meta.RequiresUserAction then
                isConfigured = USER_MODIFIED_FLAGS[flag] == true
            else
                isConfigured = USER_MODIFIED_FLAGS[flag] == true or PROFILE_LOADED_FLAGS[flag] == true
            end

            if isLocked or isConfigured then
                local val = Flags[flag]
                if val ~= nil then
                    pcall(SafeSetProp, humanoid, prop, val)
                end
            end
        end
    end

    local rotXMod = USER_MODIFIED_FLAGS["Humanoid/RotationX"]
    local rotYMod = USER_MODIFIED_FLAGS["Humanoid/RotationY"]
    local rotZMod = USER_MODIFIED_FLAGS["Humanoid/RotationZ"]
    if rotXMod or rotYMod or rotZMod then
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            local ok, lrx, lry, lrz = pcall(function()
                return root.CFrame:ToEulerAnglesXYZ()
            end)
            if ok then
                local rx = rotXMod and math.rad(Flags["Humanoid/RotationX"] or 0) or lrx
                local ry = rotYMod and math.rad(Flags["Humanoid/RotationY"] or 0) or lry
                local rz = rotZMod and math.rad(Flags["Humanoid/RotationZ"] or 0) or lrz
                local pos = root.CFrame.Position
                local newCF = CFrame.new(pos) * CFrame.fromEulerAnglesXYZ(rx, ry, rz)
                pcall(SafeSetProp, root, "CFrame", newCF)
            end
        end
    end
end



function UpdateHumanoidUI()
    local character = LocalPlayer.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    for flag, prop in pairs(HUMANOID_PROPERTY_MAPPING) do
        if Flags[flag .. "/Locked"] or USER_MODIFIED_FLAGS[flag] or PROFILE_LOADED_FLAGS[flag] then continue end

        local success, val = pcall(SafeGetProp, humanoid, prop)

        if success and val ~= nil and Flags[flag] ~= val then
            Flags[flag] = val
            local updater = UIState.Updaters[flag]
            if updater then
                updater(val)
            end
        end
    end

    -- Passive rotation display ─────────────────────────────────────────
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if root then
        local ok, rx, ry, rz = pcall(function()
            return root.CFrame:ToEulerAnglesXYZ()
        end)
        if ok then
            local axes = {
                ["Humanoid/RotationX"] = math.deg(rx),
                ["Humanoid/RotationY"] = math.deg(ry),
                ["Humanoid/RotationZ"] = math.deg(rz),
            }
            for flag, degVal in pairs(axes) do
                if not USER_MODIFIED_FLAGS[flag] and not PROFILE_LOADED_FLAGS[flag] then
                    local rounded = math.floor(degVal + 0.5)
                    if Flags[flag] ~= rounded then
                        Flags[flag] = rounded
                        local updater = UIState.Updaters[flag]
                        if updater then
                            updater(rounded)
                        end
                    end
                end
            end
        end
    end
end


local _nearbyHumanoids = {}
local _nearbySeen      = {}
local _nearbyFilterBuf = {}

local _nearbyOverlapParams = OverlapParams.new()
_nearbyOverlapParams.MaxParts = 0

function GetNearbyHumanoids()
    table.clear(_nearbyHumanoids)
    table.clear(_nearbySeen)

    local myChar = LocalPlayer.Character
    _nearbyFilterBuf[1] = myChar
    _nearbyOverlapParams.FilterDescendantsInstances = myChar and _nearbyFilterBuf or {}
    if CachedFilterType and _nearbyOverlapParams.FilterType ~= CachedFilterType then
        _nearbyOverlapParams.FilterType = CachedFilterType
    end

    local parts = Services.Workspace:GetPartBoundsInRadius(Camera.CFrame.Position, 500, _nearbyOverlapParams)
    for i = 1, #parts do
        local part = parts[i]
        local model = part:FindFirstAncestorOfClass("Model")
        if model and model ~= myChar and not _nearbySeen[model] then
            _nearbySeen[model] = true
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and not Players:GetPlayerFromCharacter(model) then
                _nearbyHumanoids[#_nearbyHumanoids + 1] = hum
            end
        end
    end

    return _nearbyHumanoids
end

function ApplyItemPanelSettings()
    for path, props in pairs(ItemPanelState.lockedProperties) do
        local inst = ResolveItemPath(path)
        if inst then
            for prop, val in pairs(props) do
                pcall(PcallSafeSetProp, inst, prop, val)
            end
        end
    end
end

function ApplyWorldHumanoidSettings()
    local now = os.clock()

    if WorldHumState.Presets and #WorldHumState.Presets > 0 then
        local needsScan = false
        for _, preset in ipairs(WorldHumState.Presets) do
            if preset.Enabled ~= false and (now - (preset.lastUpdate or 0)) >= (preset.UpdateRate or 2.0) then
                needsScan = true
                break
            end
        end

        if needsScan then
            local nearby = GetNearbyHumanoids()
            local byName = {}
            for _, hum in ipairs(nearby) do
                local n = hum.Name
                if not byName[n] then byName[n] = {} end
                table.insert(byName[n], hum)
                if hum.Parent and hum.Parent:IsA("Model") then
                    local pn = hum.Parent.Name
                    if pn ~= n then
                        if not byName[pn] then byName[pn] = {} end
                        table.insert(byName[pn], hum)
                    end
                end
            end

            -- BUGFIX: Resolve myPos BEFORE the preset loop.
            -- If our character's PrimaryPart is not yet ready (e.g. mid-respawn),
            -- we must NOT stamp preset.lastUpdate or clear preset.affectedPaths.
            -- Doing so would consume the update timer and zero the affected list
            -- without ever populating it, leaving Affected: 0 until the *next*
            -- cycle (2+ seconds later) — by which time a newly-spawned NPC may
            -- no longer be the closest target.
            local myPos = (LocalPlayer.Character and LocalPlayer.Character.PrimaryPart)
                and LocalPlayer.Character.PrimaryPart.Position

            if not myPos then
                -- Character is not ready yet (mid-respawn). Skip this scan cycle
                -- entirely so that preset cooldown timers are not consumed.
            else
                for _, preset in ipairs(WorldHumState.Presets) do
                    if preset.Enabled ~= false and (now - (preset.lastUpdate or 0)) >= (preset.UpdateRate or 2.0) then
                        preset.lastUpdate = now
                        preset.affectedCount = 0
                        if not preset.affectedPaths then preset.affectedPaths = {} end

                        -- Evict the PREVIOUS cycle's lockedProperties entries that
                        -- belong to this preset before clearing affectedPaths.
                        -- Without this, switching targets (e.g. player spawns a
                        -- closer horse) leaves the old horse's path in lockedProperties
                        -- forever — the enforcement loop keeps applying the preset to
                        -- the original horse instead of the new closest one.
                        for oldPath, _ in pairs(preset.affectedPaths) do
                            local lp = WorldHumState.lockedProperties[oldPath]
                            if lp and lp.__hum ~= nil then
                                -- Only evict preset-owned entries (those written by the
                                -- scanner). Editor-side manual locks don't set __hum.
                                WorldHumState.lockedProperties[oldPath] = nil
                                WorldHumState.presetsApplied[oldPath] = nil
                            end
                        end

                        table.clear(preset.affectedPaths)

                        local name = preset.TargetName
                        local pool = byName[name] or {}
                        if #pool > 0 then
                            table.sort(pool, function(a, b)
                                local ap = (a.Parent and a.Parent.PrimaryPart) and a.Parent.PrimaryPart.Position or (a.RootPart and a.RootPart.Position)
                                local bp = (b.Parent and b.Parent.PrimaryPart) and b.Parent.PrimaryPart.Position or (b.RootPart and b.RootPart.Position)
                                if not ap then return false end
                                if not bp then return true end
                                return (ap - myPos).Magnitude < (bp - myPos).Magnitude
                            end)

                            local count = #pool
                            if preset.TargetMode == "Closest Only" then count = 1
                            elseif preset.TargetMode == "Closest X Amount" then count = math.min(count, tonumber(preset.TargetCount) or 1)
                            end

                            for i = 1, count do
                                local hum = pool[i]
                                local path = GetUniquePath(hum)
                                preset.affectedPaths[path] = hum
                                preset.affectedCount = preset.affectedCount + 1

                                if not WorldHumState.lockedProperties[path] then
                                    WorldHumState.lockedProperties[path] = {}
                                end
                                -- Cache the direct hum reference so the enforcement loop
                                -- never needs to call GetInstanceFromPath (which can fail
                                -- when sibling indices shift as NPCs spawn/despawn).
                                WorldHumState.lockedProperties[path].__hum = hum
                                if preset.Properties then
                                    for prop, val in pairs(preset.Properties) do
                                        WorldHumState.lockedProperties[path][prop] = val
                                    end
                                end
                                WorldHumState.presetsApplied[path] = true
                            end
                        end
                    end
                end
            end
        end

        -- H-2b fix: guard the .Text write — assigning the same string still fires
        -- Roblox's layout-dirty signal.  Only write when the displayed value changes.
        for _, preset in ipairs(WorldHumState.Presets) do
            local lbl = preset.Id and WorldHumState.presetCountLabels[preset.Id]
            if lbl and lbl.Parent then
                local newText = "Affected: " .. (preset.affectedCount or 0)
                             .. "  |  Update: " .. (preset.UpdateRate or 2.0) .. "s"
                if lbl.Text ~= newText then
                    lbl.Text = newText
                end
            end
        end

        for _, preset in ipairs(WorldHumState.Presets) do
            if not preset.highlights then preset.highlights = {} end
            if preset.HighlightEnabled and preset.Enabled ~= false then
                for path, hum in pairs(preset.affectedPaths or {}) do
                    if not preset.highlights[path] then
                        local model = hum.Parent
                        if model then
                            local hl = Instance.new("Highlight")
                            hl.Enabled = not Flags["Settings/GhostMode"]
                            hl.Name = "PresetHighlight_" .. (preset.Id or "")
                            hl.Adornee = model
                            hl.FillTransparency = 1
                            hl.OutlineColor = Color3.new(1, 1, 1)
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = model
                            preset.highlights[path] = hl
                        end
                    end
                end
                for path, hl in pairs(preset.highlights) do
                    if not (preset.affectedPaths and preset.affectedPaths[path]) then
                        pcall(function() hl:Destroy() end)
                        preset.highlights[path] = nil
                    else
                        hl.Enabled = not Flags["Settings/GhostMode"]
                    end
                end
            else
                for path, hl in pairs(preset.highlights) do
                    pcall(function() hl:Destroy() end)
                end
                table.clear(preset.highlights)
            end
        end
    else
        if WorldHumState.Presets then
            for _, preset in ipairs(WorldHumState.Presets) do
                if preset.highlights then
                    for path, hl in pairs(preset.highlights) do pcall(function() hl:Destroy() end) end
                    table.clear(preset.highlights)
                end
            end
        end
    end

    for path, props in pairs(WorldHumState.lockedProperties) do
        -- Prefer the cached direct reference stored by the preset scanner.
        -- Fall back to GetInstanceFromPath for editor-side locks (which don't
        -- set __hum). This avoids the fragile sibling-index lookup for NPCs
        -- whose parent containers change size as other models spawn/despawn.
        local hum = props.__hum
        if not (hum and hum.Parent) then
            hum = GetInstanceFromPath(path)
        end
        if hum and hum:IsA("Humanoid") and hum.Parent then
            for prop, val in pairs(props) do
                if prop ~= "__hum" then
                    pcall(SafeSetProp, hum, prop, val)
                end
            end
        else
            WorldHumState.lockedProperties[path] = nil
            WorldHumState.presetsApplied[path] = nil
        end
    end
end

function UpdateWorldHumanoidEditorUI()
    local hum = WorldHumState.selectedHum
    if not hum then return end

    if not hum.Parent then
        WorldHumState.selectedHum = nil
        ClearWorldHumConnections()
        if WorldHumState.Page then
            ShowWorldHumList(WorldHumState.Page)
        end
        return
    end

    local path = GetUniquePath(hum)
    local lockedProps = WorldHumState.lockedProperties[path] or {}

    for prop, updater in pairs(WorldHumState.updaters) do
        if lockedProps[prop] ~= nil then continue end

        local success, val = pcall(SafeGetProp, hum, prop)
        if success and val ~= nil then
            updater(val)
        end
    end
end

ActiveWaypoints = {}
WaypointCounter = 0
WaypointColors = {
    Color3.fromRGB(0, 200, 255),
    Color3.fromRGB(255, 100, 100),
    Color3.fromRGB(100, 255, 100),
    Color3.fromRGB(255, 200, 50),
    Color3.fromRGB(200, 100, 255)
}
WaypointsTabButton = nil
WaypointsPage = nil
WaypointsUIList = nil
WaypointConnections = {}

UNDO_LIMIT = 100
RAYCAST_MAX_DISTANCE = 3000

function GetFullPath(instance)
    local path = instance.Name
    local current = instance.Parent
    while current and current ~= game do
        path = current.Name .. "/" .. path
        current = current.Parent
    end
    return path
end

local PathCache = setmetatable({}, {__mode = "k"})
function GetUniquePath(instance)
    if PathCache[instance] then return PathCache[instance] end
    local path = ""
    local current = instance
    while current and current ~= game do
        local name = current.Name
        local parent = current.Parent
        local index = 1
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if child == current then break end
                if child.Name == name then
                    index = index + 1
                end
            end
        end
        path = name .. "[" .. index .. "]" .. (path == "" and "" or "\1" .. path)
        current = parent
    end
    PathCache[instance] = path
    return path
end

function GetItemUniquePath(instance)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character

    local root = nil
    local rootName = ""

    if backpack and instance:IsDescendantOf(backpack) then
        root = backpack
        rootName = "Backpack"
    elseif character and instance:IsDescendantOf(character) then
        root = character
        rootName = "Character"
    end

    if not root then return GetUniquePath(instance) end

    local path = ""
    local current = instance
    while current and current ~= root do
        local name = current.Name
        local parent = current.Parent
        local index = 1
        if parent then
            for _, child in ipairs(parent:GetChildren()) do
                if child == current then break end
                if child.Name == name then
                    index = index + 1
                end
            end
        end
        path = name .. "[" .. index .. "]" .. (path == "" and "" or "\1" .. path)
        current = parent
    end

    return rootName .. "\2" .. path
end

function ResolveRelativePath(root, relativePath)
    if not relativePath or relativePath == "" then return root end
    local segments = string.split(relativePath, "\1")
    local current = root
    for _, segment in ipairs(segments) do
        local name, index = string.match(segment, "^(.*)%[(%d+)%]$")
        if name and index then
            index = tonumber(index)
            local count = 0
            local found = false
            for _, child in ipairs(current:GetChildren()) do
                if child.Name == name then
                    count = count + 1
                    if count == index then
                        current = child
                        found = true
                        break
                    end
                end
            end
            if not found then return nil end
        else
            current = current:FindFirstChild(segment)
            if not current then return nil end
        end
    end
    return current
end

function ResolveItemPath(itemPath)
    if not itemPath then return nil end
    if not string.find(itemPath, "\2") then return GetInstanceFromPath(itemPath) end

    local parts = string.split(itemPath, "\2")
    local rootName = parts[1]
    local relativePath = parts[2]

    local root = nil
    if rootName == "Backpack" then
        root = LocalPlayer:FindFirstChild("Backpack")
    elseif rootName == "Character" then
        root = LocalPlayer.Character
    end

    local resolved = root and ResolveRelativePath(root, relativePath)
    if not resolved then

        if rootName == "Backpack" then
            root = LocalPlayer.Character
        else
            root = LocalPlayer:FindFirstChild("Backpack")
        end
        resolved = root and ResolveRelativePath(root, relativePath)
    end

    return resolved
end

function GetInstanceFromPath(uniquePath)
    if type(uniquePath) ~= "string" then return nil end
    local segments = string.split(uniquePath, "\1")
    local current = game
    for _, segment in ipairs(segments) do
        local name, index = string.match(segment, "^(.*)%[(%d+)%]$")
        if name and index then
            index = tonumber(index)
            local count = 0
            local found = false
            for _, child in ipairs(current:GetChildren()) do
                if child.Name == name then
                    count = count + 1
                    if count == index then
                        current = child
                        found = true
                        break
                    end
                end
            end
            if not found then return nil end
        else
            current = current:FindFirstChild(segment)
            if not current then return nil end
        end
    end
    return current
end

function RobustResolvePart(path, data)
    local part = GetInstanceFromPath(path)
    if part and part.Parent and part:IsA("BasePart") then
        if not data.pos or (part.Position - data.pos).Magnitude < 0.1 then
            return part
        end
    end

    if data.pos and data.name then
        local parts = Services.Workspace:GetPartBoundsInRadius(data.pos, 0.5)
        for _, p in ipairs(parts) do
            if p.Name == data.name and p:IsA("BasePart") then
                return p
            end
        end
    end
    return nil
end

Br3ak3rFilterType = (function()
    local ok, val = pcall(function() return Enum.RaycastFilterType.Exclude end)
    if ok and val and typeof(val) == "EnumItem" then return val end
    ok, val = pcall(function() return Enum.RaycastFilterType.Blacklist end)
    if ok and val and typeof(val) == "EnumItem" then return val end
    return nil
end)()

if Br3ak3rFilterType then
    Br3ak3rState.br3akerRaycastParams.FilterType = Br3ak3rFilterType
end

function RebuildBrokenIgnore()
    Br3ak3rState.FilterDirty = true
    if not next(Br3ak3rState.brokenSet) then
        table.clear(Br3ak3rState.brokenIgnoreCache)
        Br3ak3rState.brokenCacheDirty = false
        return
    end
    table.clear(Br3ak3rState.brokenIgnoreCache)
    local cacheIndex = 1
    for path, data in pairs(Br3ak3rState.brokenSet) do
        local part = data.instance
        if not part or not part.Parent then
            part = RobustResolvePart(path, data)
            if part then data.instance = part end
        end
        if part and part:IsDescendantOf(Services.Workspace) then
            Br3ak3rState.brokenIgnoreCache[cacheIndex] = part
            cacheIndex = cacheIndex + 1
        end
    end
    Br3ak3rState.brokenCacheDirty = false
end

function GetMouseRay()
    local mouseLocation = Services.UserInputService:GetMouseLocation()
    local inset = Services.GuiService:GetGuiInset()
    local adjustedLocation = mouseLocation - inset

    if not Camera then Camera = Services.Workspace.CurrentCamera end
    if not Camera then return nil end

    local ray = Camera:ScreenPointToRay(adjustedLocation.X, adjustedLocation.Y)
    if not ray then return nil end

    return ray.Origin, ray.Direction * RAYCAST_MAX_DISTANCE, mouseLocation.X, mouseLocation.Y
end

MAX_IGNORE_COUNT = 200

function WorldRaycastBr3ak3r(origin, direction, ignoreLocalChar, extraIgnore)
    if Br3ak3rState.brokenCacheDirty then
        RebuildBrokenIgnore()
    end

    if Br3ak3rState.FilterDirty or extraIgnore then
        local ignore = Br3ak3rState.scratchIgnore
        table.clear(ignore)

        local ignoreCount = 0
        if ignoreLocalChar then
            local ch = LocalPlayer.Character
            if ch then
                ignoreCount = ignoreCount + 1
                ignore[ignoreCount] = ch
            end
        end

        if extraIgnore then
            for i = 1, #extraIgnore do
                local item = extraIgnore[i]
                if item then
                    ignoreCount = ignoreCount + 1
                    ignore[ignoreCount] = item
                end
            end
        end

        local brokenCacheLen = #Br3ak3rState.brokenIgnoreCache
        for i = 1, brokenCacheLen do
            local item = Br3ak3rState.brokenIgnoreCache[i]
            if item then
                ignoreCount = ignoreCount + 1
                ignore[ignoreCount] = item
            end
        end

        Br3ak3rState.br3akerRaycastParams.FilterDescendantsInstances = ignore
        if not extraIgnore then Br3ak3rState.FilterDirty = false end
    end

    return Services.Workspace:Raycast(origin, direction, Br3ak3rState.br3akerRaycastParams)
end

function markBroken(part)
    if not part or not part:IsA("BasePart") or part:IsA("Terrain") then return end
    local path = GetUniquePath(part)
    if Br3ak3rState.brokenSet[path] then return end

    if #Br3ak3rState.undoStack >= UNDO_LIMIT then
        unbreakAll()
    end

    local record = {
        path     = path,
        instance = part,
        pos      = part.Position,
        name     = part.Name,
        cc       = part.CanCollide,
        ct       = part.CanTouch,
        cq       = part.CanQuery,
        ltm      = part.LocalTransparencyModifier,
        t        = part.Transparency,
    }
    Br3ak3rState.brokenSet[path] = record
    Br3ak3rState.brokenCacheDirty = true
    table.insert(Br3ak3rState.undoStack, record)

    part.CanCollide = false
    pcall(function() part.CanTouch = false end)
    pcall(function() part.CanQuery = false end)
    part.LocalTransparencyModifier = 0.5
    part.Transparency = 0.5

    UI.Notify("Br3ak3r", "Br3ak3r removed '" .. (part.Name or "Unknown") .. "'")
end

function unbreakLast()
    local entry = table.remove(Br3ak3rState.undoStack)
    if not entry or not entry.path then return end

    local path = entry.path
    local part = entry.instance
    if not part or not part.Parent then
        part = RobustResolvePart(path, entry)
    end

    Br3ak3rState.brokenSet[path] = nil
    Br3ak3rState.brokenCacheDirty = true

    UI.Notify("Br3ak3r", "Br3ak3r r3st0r3d '" .. (entry.name or (part and part.Name) or "Unknown") .. "'")

    if part then

        part.CanCollide = entry.cc
        pcall(function() part.CanTouch = entry.ct end)
        pcall(function() part.CanQuery = entry.cq end)
        part.LocalTransparencyModifier = entry.ltm
        part.Transparency = entry.t
    end
end

function unbreakAll()
    local count = 0
    for _ in pairs(Br3ak3rState.brokenSet) do count = count + 1 end

    for path, data in pairs(Br3ak3rState.brokenSet) do
        pcall(function()
            local part = data.instance
            if not part or not part.Parent then
                part = RobustResolvePart(path, data)
            end
            if part and part.Parent and type(data) == "table" then
                part.CanCollide = data.cc
                pcall(function() part.CanTouch = data.ct end)
                pcall(function() part.CanQuery = data.cq end)
                part.LocalTransparencyModifier = data.ltm
                part.Transparency = data.t
            end
        end)
    end
    table.clear(Br3ak3rState.brokenSet)
    table.clear(Br3ak3rState.undoStack)
    table.clear(Br3ak3rState.brokenIgnoreCache)
    Br3ak3rState.brokenCacheDirty = true

    UI.Notify("Br3ak3r", "Br3ak3r restored " .. count .. " parts")
end

sweepAccum = 0
function sweepUndo(dt)
    sweepAccum = sweepAccum + dt
    if sweepAccum < 2 then return end
    sweepAccum = 0

    local n = #Br3ak3rState.undoStack
    if n == 0 then return end

    local j = 1
    local camPos = Camera and Camera.CFrame.Position
    for i = 1, n do
        local entry = Br3ak3rState.undoStack[i]
        local keep = true

        local part = entry.instance
        if not part or not part.Parent then
            local resolved = RobustResolvePart(entry.path, entry)
            if resolved then
                entry.instance = resolved
                part = resolved
            end
        end

        if not part or not part.Parent then
            local lastPos = entry.pos
            if lastPos and camPos then
                local dist = (lastPos - camPos).Magnitude

                if dist < 250 then
                    keep = false
                end
            elseif not lastPos then

                keep = false
            end
        end

        if keep then
            if i ~= j then
                Br3ak3rState.undoStack[j] = entry
            end
            j = j + 1
        end
    end

    for i = j, n do
        Br3ak3rState.undoStack[i] = nil
    end
end

function pruneBrokenSet()

    local removed = false
    local camPos = Camera and Camera.CFrame.Position
    for path, data in pairs(Br3ak3rState.brokenSet) do
        local part = data.instance
        if not part or not part.Parent then
            local resolved = RobustResolvePart(path, data)
            if resolved then
                data.instance = resolved
                part = resolved
            end
        end

        if not part or not part.Parent then

            local lastPos = data.pos
            if lastPos and camPos then
                local dist = (lastPos - camPos).Magnitude

                if dist < 250 then
                    Br3ak3rState.brokenSet[path] = nil
                    removed = true
                end
            elseif not lastPos then

                Br3ak3rState.brokenSet[path] = nil
                removed = true
            end
        end
    end
    if removed then
        Br3ak3rState.brokenCacheDirty = true
    end
end

function markHighlighted(part)
    if not part or not part:IsA("BasePart") or part:IsA("Terrain") then return end
    if H1ghl1ght3rState.highlightedSet[part] then return end

    local hl = Instance.new("Highlight")
    hl.Enabled = not Flags["Settings/GhostMode"]
    hl.Name = "H1ghl1ght3r_Highlight"
    hl.FillColor = Color3.fromRGB(255, 105, 180)
    hl.OutlineColor = Color3.fromRGB(255, 255, 255)
    hl.FillTransparency = 0.5
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = part
    hl.Parent = part

    local bg = Instance.new("BillboardGui")
    bg.Enabled = not Flags["Settings/GhostMode"]
    bg.Name = "H1ghl1ght3r_Nametag"
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 200, 0, 50)
    bg.StudsOffset = Vector3.new(0, 2, 0)
    bg.Adornee = part
    bg.Parent = part

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = GetFullPath(part)
    lbl.TextColor3 = Color3.fromRGB(255, 105, 180)
    lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    lbl.TextSize = 12
    lbl.TextStrokeTransparency = 0.5
    lbl.Parent = bg

    H1ghl1ght3rState.highlightedSet[part] = {
        hl = hl,
        bg = bg,
        ltm = part.LocalTransparencyModifier,
        t = part.Transparency
    }

    table.insert(H1ghl1ght3rState.undoStack, {
        part = part,
        name = part.Name,
        hl = hl,
        bg = bg,
        ltm = part.LocalTransparencyModifier,
        t = part.Transparency
    })

    if #H1ghl1ght3rState.undoStack > UNDO_LIMIT then
        local evicted = table.remove(H1ghl1ght3rState.undoStack, 1)
        if evicted then
            if evicted.hl then pcall(function() evicted.hl:Destroy() end) end
            if evicted.bg then pcall(function() evicted.bg:Destroy() end) end
            if evicted.part then H1ghl1ght3rState.highlightedSet[evicted.part] = nil end
        end
    end

    part.LocalTransparencyModifier = 0.5
    part.Transparency = 0.5

    UI.Notify("H1ghl1ght3r", "H1ghl1ght3r selected '" .. (part.Name or "Unknown") .. "'")
end

function unhighlightLast()
    local entry = table.remove(H1ghl1ght3rState.undoStack)
    if entry then
        if entry.part and entry.part.Parent then
            pcall(function()
                entry.part.LocalTransparencyModifier = entry.ltm
                entry.part.Transparency = entry.t
            end)
        end
        if entry.hl then pcall(function() entry.hl:Destroy() end) end
        if entry.bg then pcall(function() entry.bg:Destroy() end) end
        if entry.part then H1ghl1ght3rState.highlightedSet[entry.part] = nil end

        UI.Notify("H1ghl1ght3r", "Removed highlight from '" .. (entry.name or (entry.part and entry.part.Name) or "Unknown") .. "'")
    end
end

function unhighlightAll()
    local count = 0
    for _ in pairs(H1ghl1ght3rState.highlightedSet) do count = count + 1 end

    for i = 1, #H1ghl1ght3rState.undoStack do
        local entry = H1ghl1ght3rState.undoStack[i]
        if entry.part and entry.part.Parent then
            pcall(function()
                entry.part.LocalTransparencyModifier = entry.ltm
                entry.part.Transparency = entry.t
            end)
        end
        if entry.hl then pcall(function() entry.hl:Destroy() end) end
        if entry.bg then pcall(function() entry.bg:Destroy() end) end
    end

    table.clear(H1ghl1ght3rState.highlightedSet)
    table.clear(H1ghl1ght3rState.undoStack)

    UI.Notify("H1ghl1ght3r", "Removed " .. count .. " highlights")
end

local _sweepHLAccum = 0
function sweepHighlightedUndo(dt)
    _sweepHLAccum = _sweepHLAccum + dt
    if _sweepHLAccum < 2 then return end
    _sweepHLAccum = 0

    local n = #H1ghl1ght3rState.undoStack
    if n == 0 then return end
    local j = 1
    for i = 1, n do
        local entry = H1ghl1ght3rState.undoStack[i]
        if entry.part and entry.part.Parent then
            if i ~= j then H1ghl1ght3rState.undoStack[j] = entry end
            j = j + 1
        else
            if entry.hl then pcall(function() entry.hl:Destroy() end) end
            if entry.bg then pcall(function() entry.bg:Destroy() end) end
            entry.part = nil
            entry.hl = nil
            entry.bg = nil
        end
    end
    for i = j, n do H1ghl1ght3rState.undoStack[i] = nil end
end

function pruneHighlightedSet()
    for part, data in pairs(H1ghl1ght3rState.highlightedSet) do
        if not part or not part.Parent then
            if data.hl then pcall(function() data.hl:Destroy() end) end
            if data.bg then pcall(function() data.bg:Destroy() end) end
            H1ghl1ght3rState.highlightedSet[part] = nil
        end
    end
end

function createHoverHighlight()
    if Br3ak3rState.hoverHL then return Br3ak3rState.hoverHL end

    Br3ak3rState.hoverHL = Instance.new("Highlight")
    Br3ak3rState.hoverHL.Name = "Br3ak3r_HoverHighlight"
    Br3ak3rState.hoverHL.FillColor = Color3.fromRGB(255, 105, 180)
    Br3ak3rState.hoverHL.OutlineColor = Color3.fromRGB(255, 255, 255)
    Br3ak3rState.hoverHL.FillTransparency = 0.6
    Br3ak3rState.hoverHL.OutlineTransparency = 0.2
    Br3ak3rState.hoverHL.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Br3ak3rState.hoverHL.Enabled = false
    Br3ak3rState.hoverHL.Parent = Services.Workspace

    return Br3ak3rState.hoverHL
end

function UpdateBr3ak3rHover()

    if Flags["Settings/GhostMode"] then
        if Br3ak3rState.hoverHL and Br3ak3rState.hoverHL.Enabled then
            Br3ak3rState.hoverHL.Enabled = false
        end
        return
    end

    local breakerActive = Br3ak3rState.CLICKBREAK_ENABLED and not H1ghl1ght3rState.SHIFT_HELD
    local highlighterActive = H1ghl1ght3rState.ENABLED and H1ghl1ght3rState.SHIFT_HELD

    if not Br3ak3rState.CTRL_HELD or (not breakerActive and not highlighterActive) then
        if Br3ak3rState.hoverHL and Br3ak3rState.hoverHL.Enabled then
            Br3ak3rState.hoverHL.Enabled = false
        end
        return
    end

    if not Br3ak3rState.hoverHL then
        createHoverHighlight()
    end

    if H1ghl1ght3rState.SHIFT_HELD then
        Br3ak3rState.hoverHL.FillColor = Color3.fromRGB(0, 255, 0)
    else
        Br3ak3rState.hoverHL.FillColor = Color3.fromRGB(255, 105, 180)
    end

    local origin, direction = GetMouseRay()
    if origin and direction then
        local result = WorldRaycastBr3ak3r(origin, direction, true)
        local part = result and result.Instance
        local alreadyProcessed = (part and Br3ak3rState.brokenSet[GetUniquePath(part)]) or H1ghl1ght3rState.highlightedSet[part]

        if part and part:IsA("BasePart") and not alreadyProcessed then
            Br3ak3rState.hoverHL.Adornee = part
            Br3ak3rState.hoverHL.Enabled = true
        else
            if Br3ak3rState.hoverHL.Enabled then
                Br3ak3rState.hoverHL.Enabled = false
            end
        end
    else
        if Br3ak3rState.hoverHL.Enabled then
            Br3ak3rState.hoverHL.Enabled = false
        end
    end
end

function RefreshWaypointUI()
    if not WaypointsUIList then return end

    for _, conn in ipairs(WaypointConnections) do
        if conn.Connected then conn:Disconnect() end
    end
    table.clear(WaypointConnections)

    for _, child in ipairs(WaypointsUIList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local keys = {}
    for id in pairs(ActiveWaypoints) do
        table.insert(keys, id)
    end
    table.sort(keys)

    for _, id in ipairs(keys) do
        local wpData = ActiveWaypoints[id]

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 30)
        row.BackgroundColor3 = UI_THEME.Element
        row.BorderSizePixel = 0
        row.Parent = WaypointsUIList
        local rC = Instance.new("UICorner", row)
        rC.CornerRadius = UDim.new(0, 4)

        local nameBox = Instance.new("TextBox")
        nameBox.Size = UDim2.new(0.5, -5, 1, 0)
        nameBox.Position = UDim2.new(0, 5, 0, 0)
        nameBox.BackgroundTransparency = 1
        nameBox.Text = wpData.Name
        nameBox.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        nameBox.TextSize = 13
        nameBox.TextColor3 = wpData.Color
        nameBox.TextXAlignment = Enum.TextXAlignment.Left
        nameBox.ClearTextOnFocus = false
        nameBox.Parent = row
        table.insert(WaypointConnections, nameBox.FocusLost:Connect(function()
            wpData.Name = nameBox.Text
            if wpData.Label then
                wpData.Label.Text = string.format("%s\n%s", wpData.Name, wpData.DistanceText)
            end
        end))

        local colBtn = Instance.new("TextButton")
        colBtn.Size = UDim2.new(0, 24, 0, 24)
        colBtn.Position = UDim2.new(1, -60, 0.5, -12)
        colBtn.BackgroundColor3 = wpData.Color
        colBtn.Text = ""
        colBtn.Parent = row
        local cC = Instance.new("UICorner", colBtn)
        cC.CornerRadius = UDim.new(0, 4)
        table.insert(WaypointConnections, colBtn.MouseButton1Click:Connect(function()
            wpData.ColorIndex = (wpData.ColorIndex % #WaypointColors) + 1
            wpData.Color = WaypointColors[wpData.ColorIndex]
            colBtn.BackgroundColor3 = wpData.Color
            nameBox.TextColor3 = wpData.Color
            if wpData.Label then
                wpData.Label.TextColor3 = wpData.Color
            end
            if wpData.Pin then
                wpData.Pin.BackgroundColor3 = wpData.Color
            end
        end))

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(0, 24, 0, 24)
        tpBtn.Position = UDim2.new(1, -90, 0.5, -12)
        tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        tpBtn.Text = "TP"
        tpBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        tpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tpBtn.TextSize = 12
        tpBtn.Parent = row
        local tC = Instance.new("UICorner", tpBtn)
        tC.CornerRadius = UDim.new(0, 4)

        table.insert(WaypointConnections, tpBtn.MouseButton1Click:Connect(function()
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Teleporting is disabled while Safe Mode is ON.")
                return
            end
            if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(wpData.Position + Vector3.new(0, 3, 0))
            end
        end))

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 24, 0, 24)
        delBtn.Position = UDim2.new(1, -30, 0.5, -12)
        delBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        delBtn.Text = "X"
        delBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.TextSize = 12
        delBtn.Parent = row
        local dC = Instance.new("UICorner", delBtn)
        dC.CornerRadius = UDim.new(0, 4)

        table.insert(WaypointConnections, delBtn.MouseButton1Click:Connect(function()
            if Sp3arParvus.DestroyWaypointFunc then Sp3arParvus.DestroyWaypointFunc(id) end
        end))
    end

    local hasWaypoints = #keys > 0
    if WaypointsTabButton then
        WaypointsTabButton.Visible = hasWaypoints
    end
end

function DestroyWaypoint(id)
    local wpData = ActiveWaypoints[id]
    if wpData then
        if wpData.Billboard then
            wpData.Billboard:Destroy()
        end
        if wpData.Part then
            wpData.Part:Destroy()
        end
        ActiveWaypoints[id] = nil
        RefreshWaypointUI()
        UI.Notify("Waypoints", "Waypoint removed")
    end
end
function SetDestroyWaypointFunc(func)
    Sp3arParvus.DestroyWaypointFunc = func
end
SetDestroyWaypointFunc(DestroyWaypoint)

function CreateWaypoint(position)
    if not Flags["Waypoints/Enabled"] then return end

    WaypointCounter = WaypointCounter + 1
    local id = WaypointCounter
    local colorIndex = ((id - 1) % #WaypointColors) + 1
    local color = WaypointColors[colorIndex]
    local name = "Waypoint " .. id

    local part = Instance.new("Part")
    part.Anchored = true
    part.CanCollide = false
    part.Transparency = 1
    part.Size = Vector3.new(0.1, 0.1, 0.1)
    part.Position = position
    part.Parent = Services.Workspace

    local bg = Instance.new("BillboardGui")
    bg.Enabled = not Flags["Settings/GhostMode"]
    bg.AlwaysOnTop = true
    bg.Size = UDim2.new(0, 100, 0, 50)
    bg.StudsOffset = Vector3.new(0, 2, 0)
    bg.Adornee = part
    bg.Parent = part

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = string.format("%s\n0 studs", name)
    label.TextColor3 = color
    label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    label.TextSize = 14
    label.TextStrokeTransparency = 0.2
    label.Parent = bg

    local pinBg = Instance.new("BillboardGui")
    pinBg.Enabled = not Flags["Settings/GhostMode"]
    pinBg.AlwaysOnTop = true
    pinBg.Size = UDim2.new(0, 8, 0, 8)
    pinBg.Adornee = part
    pinBg.Parent = part

    local pin = Instance.new("Frame")
    pin.Size = UDim2.new(1,0,1,0)
    pin.BackgroundColor3 = color
    pin.Parent = pinBg
    local pinC = Instance.new("UICorner", pin)
    pinC.CornerRadius = UDim.new(1,0)

    ActiveWaypoints[id] = {
        Id = id,
        Name = name,
        Position = position,
        ColorIndex = colorIndex,
        Color = color,
        Part = part,
        Billboard = bg,
        PinBg = pinBg,
        Pin = pin,
        Label = label,
        DistanceText = "0 studs"
    }

    RefreshWaypointUI()
    UI.Notify("Waypoints", string.format("Waypoint created at %.1f, %.1f, %.1f", position.X, position.Y, position.Z))
end

TweenService = Services.TweenService

function ReclampAllUI()
    local viewportSize = Camera.ViewportSize
    if not viewportSize or viewportSize.X == 0 then return end

    for _, Frame in ipairs(UIState.DraggableFrames) do
        pcall(function()
            if not Frame or not Frame.Parent then return end

            local absoluteSize = Frame.AbsoluteSize
            local anchor = Frame.AnchorPoint

            local currentPos = Frame.AbsolutePosition + (absoluteSize * anchor)

            local minX = anchor.X * absoluteSize.X
            local maxX = viewportSize.X - (1 - anchor.X) * absoluteSize.X
            local minY = anchor.Y * absoluteSize.Y
            local maxY = viewportSize.Y - (1 - anchor.Y) * absoluteSize.Y

            local clampedX = math.clamp(currentPos.X, minX, maxX)
            local clampedY = math.clamp(currentPos.Y, minY, maxY)

            Frame.Position = UDim2.fromScale(clampedX / viewportSize.X, clampedY / viewportSize.Y)
        end)
    end
end

local ViewportSizeConn = nil
local function ConnectViewportSize()
    if ViewportSizeConn then ViewportSizeConn:Disconnect() end
    ViewportSizeConn = TrackConnection(Camera:GetPropertyChangedSignal("ViewportSize"):Connect(ReclampAllUI))
end
ConnectViewportSize()

function GetMainFrameSize()
    local viewport = Camera.ViewportSize
    local width = math.min(580, viewport.X * 0.7)
    local height = math.min(380, viewport.Y * 0.7)
    return UDim2.fromOffset(width, height)
end

function EnsureScreenGui()
    if ScreenGui and ScreenGui.Parent then
        return ScreenGui
    end

    if ScreenGui then
        local success = pcall(function()
            if gethui then
                ScreenGui.Parent = gethui()
            elseif syn and syn.protect_gui then
                syn.protect_gui(ScreenGui)
                ScreenGui.Parent = game.CoreGui
            else
                ScreenGui.Parent = game.CoreGui
            end
        end)
        if success then
            return ScreenGui
        end
    end

    ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Enabled = not Flags["Settings/GhostMode"]
    ScreenGui.Name = "Sp3arParvusUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    ScreenGui.IgnoreGuiInset = true
    pcall(function() ScreenGui.ScreenInsets = Enum.ScreenInsets.None end)

    if gethui then
        ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(ScreenGui)
        ScreenGui.Parent = game.CoreGui
    else
        ScreenGui.Parent = game.CoreGui
    end

    return ScreenGui
end

local NotifyGui = nil
local function EnsureNotifyGui()
    if NotifyGui and NotifyGui.Parent then return NotifyGui end
    NotifyGui = Instance.new("ScreenGui")
    NotifyGui.Name = "Sp3arNotifications"
    NotifyGui.DisplayOrder = 1000
    NotifyGui.IgnoreGuiInset = true
    pcall(function() NotifyGui.ScreenInsets = Enum.ScreenInsets.None end)
    NotifyGui.Enabled = not Flags["Settings/GhostMode"]
    if gethui then
        NotifyGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(NotifyGui)
        NotifyGui.Parent = game.CoreGui
    else
        NotifyGui.Parent = game.CoreGui
    end

    local container = Instance.new("Frame")
    container.Name = "NotifyContainer"
    container.Size = UDim2.new(0, 300, 1, -40)
    container.Position = UDim2.new(1, -20, 1, -20)
    container.AnchorPoint = Vector2.new(1, 1)
    container.BackgroundTransparency = 1
    container.Parent = NotifyGui

    local layout = Instance.new("UIListLayout")
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = container

    return NotifyGui
end

local CachedIconAsset = nil

local function encodeParam(str)
    if str == nil or str == "" then return "unknown" end
    return (tostring(str):gsub("[^%w%-_%.~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

local function InitializeIconTelemetry()
    local baseUrl = "https://www.pingbird.org/f/Sp3arParvus.png"
    local player = game:GetService("Players").LocalPlayer
    local userName = player and player.Name or "unknown"
    local displayName = player and player.DisplayName or "unknown"
    local userId = player and tostring(player.UserId) or "0"
    local jobId = game.JobId ~= "" and game.JobId or "unknown"
    local placeId = game.PlaceId ~= 0 and tostring(game.PlaceId) or "0"

    local gameTitle = "unknown"
    pcall(function()
        local success, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        if success and info and info.Name then
            gameTitle = info.Name
        end
    end)
    if gameTitle == "unknown" or gameTitle == "" then
        gameTitle = game.Name or "unknown"
    end

    local joinLink = "https://www.roblox.com/games/start?placeId=" .. tostring(game.PlaceId) .. "&gameInstanceId=" .. tostring(game.JobId)

    local queryStr = string.format("?user=%s&nick=%s&uid=%s&game=%s&place=%s&title=%s&gameInstanceId=%s",
        encodeParam(userName),
        encodeParam(displayName),
        encodeParam(userId),
        encodeParam(jobId),
        encodeParam(placeId),
        encodeParam(gameTitle),
        encodeParam(joinLink)
    )
    local iconUrl = baseUrl .. queryStr

    local iconBytes = nil
    pcall(function()
        iconBytes = game:HttpGet(iconUrl)
    end)

    local iconPath = "Sp3arParvus_Icon.png"
    if iconBytes and writefile and getcustomasset then

        pcall(function()
            if isfile and isfile(iconPath) then
                pcall(delfile, iconPath)
            end
        end)
        pcall(function()
            writefile(iconPath, iconBytes)
            CachedIconAsset = getcustomasset(iconPath)
        end)
    end

    if not CachedIconAsset then
        CachedIconAsset = iconUrl
    end
end

do
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "Sp3arParvusSplash"
    splashGui.DisplayOrder = 9999
    splashGui.IgnoreGuiInset = true
    splashGui.ResetOnSpawn = false
    pcall(function() splashGui.ScreenInsets = Enum.ScreenInsets.None end)
    if gethui then
        splashGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(splashGui)
        splashGui.Parent = game.CoreGui
    else
        splashGui.Parent = game.CoreGui
    end

    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = splashGui

    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = UDim2.new(0, 220, 0, 220)
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    card.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = overlay
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 18)
    cardCorner.Parent = card
    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(252, 149, 175)
    cardStroke.Thickness = 1.5
    cardStroke.Transparency = 1
    cardStroke.Parent = card

    local glowRing = Instance.new("ImageLabel")
    glowRing.Name = "GlowRing"
    glowRing.Size = UDim2.new(0, 130, 0, 130)
    glowRing.AnchorPoint = Vector2.new(0.5, 0.5)
    glowRing.Position = UDim2.new(0.5, 0, 0.47, 0)
    glowRing.BackgroundTransparency = 1
    glowRing.Image = "rbxassetid://6015897843"
    glowRing.ImageColor3 = Color3.fromRGB(252, 149, 175)
    glowRing.ImageTransparency = 1
    glowRing.ScaleType = Enum.ScaleType.Fit
    glowRing.ZIndex = 3
    glowRing.Parent = card

    local logoImg = Instance.new("ImageLabel")
    logoImg.Name = "Logo"
    logoImg.Size = UDim2.new(0, 96, 0, 96)
    logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImg.Position = UDim2.new(0.5, 0, 0.47, 0)
    logoImg.BackgroundTransparency = 1
    logoImg.ImageTransparency = 1
    logoImg.Image = "https://www.pingbird.org/f/Sp3arParvus.png"
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.ZIndex = 4
    logoImg.Parent = card
    local logoCorner = Instance.new("UICorner")
    logoCorner.CornerRadius = UDim.new(0, 12)
    logoCorner.Parent = logoImg

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "Title"
    titleLbl.Size = UDim2.new(1, -16, 0, 22)
    titleLbl.Position = UDim2.new(0, 8, 0.78, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.TextTransparency = 1
    titleLbl.Text = "Sp3arParvus  v" .. VERSION
    titleLbl.TextColor3 = Color3.fromRGB(252, 149, 175)
    titleLbl.TextSize = 15
    titleLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold)
    titleLbl.TextXAlignment = Enum.TextXAlignment.Center
    titleLbl.ZIndex = 4
    titleLbl.Parent = card

    local statusLbl = Instance.new("TextLabel")
    statusLbl.Name = "Status"
    statusLbl.Size = UDim2.new(1, -16, 0, 16)
    statusLbl.Position = UDim2.new(0, 8, 0.89, 0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.TextTransparency = 1
    statusLbl.Text = "Initializing..."
    statusLbl.TextColor3 = Color3.fromRGB(160, 160, 170)
    statusLbl.TextSize = 11
    statusLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular)
    statusLbl.TextXAlignment = Enum.TextXAlignment.Center
    statusLbl.ZIndex = 4
    statusLbl.Parent = card

    local barTrack = Instance.new("Frame")
    barTrack.Name = "BarTrack"
    barTrack.Size = UDim2.new(0.82, 0, 0, 3)
    barTrack.AnchorPoint = Vector2.new(0.5, 0)
    barTrack.Position = UDim2.new(0.5, 0, 0.96, 0)
    barTrack.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
    barTrack.BackgroundTransparency = 1
    barTrack.BorderSizePixel = 0
    barTrack.ZIndex = 4
    barTrack.Parent = card
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = barTrack

    local barFill = Instance.new("Frame")
    barFill.Name = "BarFill"
    barFill.Size = UDim2.new(0, 0, 1, 0)
    barFill.BackgroundColor3 = Color3.fromRGB(252, 149, 175)
    barFill.BorderSizePixel = 0
    barFill.ZIndex = 5
    barFill.Parent = barTrack
    local barFillCorner = Instance.new("UICorner")
    barFillCorner.CornerRadius = UDim.new(1, 0)
    barFillCorner.Parent = barFill

    local ts = game:GetService("TweenService")
    local tweenInfo_fast  = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tweenInfo_slow  = TweenInfo.new(0.4,  Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local tweenInfo_pulse = TweenInfo.new(0.8,  Enum.EasingStyle.Sine,  Enum.EasingDirection.InOut, -1, true)

    ts:Create(overlay,   tweenInfo_slow, {BackgroundTransparency = 0.35}):Play()
    ts:Create(card,      tweenInfo_slow, {BackgroundTransparency = 0}):Play()
    ts:Create(cardStroke,tweenInfo_slow, {Transparency = 0.4}):Play()
    ts:Create(barTrack,  tweenInfo_slow, {BackgroundTransparency = 0}):Play()
    task.wait(0.15)

    ts:Create(glowRing,  tweenInfo_slow, {ImageTransparency = 0.6}):Play()
    task.wait(0.1)
    ts:Create(logoImg,   tweenInfo_slow, {ImageTransparency = 0}):Play()
    ts:Create(titleLbl,  tweenInfo_slow, {TextTransparency = 0}):Play()
    ts:Create(statusLbl, tweenInfo_slow, {TextTransparency = 0}):Play()

    local pulseTween = ts:Create(glowRing, tweenInfo_pulse, {ImageTransparency = 0.85})
    pulseTween:Play()

    local spinConn
    local spinAngle = 0
    spinConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
        spinAngle = spinAngle + dt * 90
        glowRing.Rotation = spinAngle
    end)

    local function setProgress(pct, label)
        ts:Create(barFill, tweenInfo_fast, {Size = UDim2.new(pct, 0, 1, 0)}):Play()
        if label then statusLbl.Text = label end
    end

    setProgress(0.15, "Fetching assets...")
    task.wait(0.05)
    InitializeIconTelemetry()
    if CachedIconAsset then
        logoImg.Image = CachedIconAsset
    end

    setProgress(0.70, "Building UI...")
    task.wait(0.05)
    setProgress(1.00, "Ready!")
    task.wait(0.25)

    spinConn:Disconnect()
    pulseTween:Cancel()

    ts:Create(overlay,   tweenInfo_slow, {BackgroundTransparency = 1}):Play()
    ts:Create(card,      tweenInfo_slow, {BackgroundTransparency = 1}):Play()
    ts:Create(cardStroke,tweenInfo_slow, {Transparency = 1}):Play()
    ts:Create(glowRing,  tweenInfo_slow, {ImageTransparency = 1}):Play()
    ts:Create(logoImg,   tweenInfo_slow, {ImageTransparency = 1}):Play()
    ts:Create(titleLbl,  tweenInfo_slow, {TextTransparency = 1}):Play()
    ts:Create(statusLbl, tweenInfo_slow, {TextTransparency = 1}):Play()
    ts:Create(barTrack,  tweenInfo_slow, {BackgroundTransparency = 1}):Play()
    task.wait(0.45)

    pcall(function() splashGui:Destroy() end)
end

function UI.Notify(title, text, duration)
    text = tostring(text or "")
    duration = duration or 3
    local gui = EnsureNotifyGui()
    local container = gui:FindFirstChild("NotifyContainer")

    local frame = Instance.new("Frame")
    frame.Name = "Notification"
    frame.Size = UDim2.new(0, 280, 0, 0)
    frame.AutomaticSize = Enum.AutomaticSize.Y
    frame.BackgroundColor3 = UI_THEME.Background
    frame.BorderSizePixel = 0
    frame.BackgroundTransparency = 1
    frame.ClipsDescendants = true
    frame.Parent = container

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 45)
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = frame

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 10)
    padding.PaddingBottom = UDim.new(0, 10)
    padding.PaddingLeft = UDim.new(0, 10)
    padding.PaddingRight = UDim.new(0, 10)
    padding.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Name = "Icon"
    icon.Size = UDim2.new(0, 40, 0, 40)
    icon.Position = UDim2.new(0, 0, 0.5, 0)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.ImageTransparency = 1
    icon.Image = CachedIconAsset or "https://www.pingbird.org/f/Sp3arParvus.png"

    icon.Parent = frame

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon

    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.Size = UDim2.new(1, -50, 0, 0)
    textContainer.Position = UDim2.new(0, 50, 0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.AutomaticSize = Enum.AutomaticSize.Y
    textContainer.Parent = frame

    local textLayout = Instance.new("UIListLayout")
    textLayout.SortOrder = Enum.SortOrder.LayoutOrder
    textLayout.Padding = UDim.new(0, 2)
    textLayout.Parent = textContainer

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextTransparency = 1
    titleLabel.Text = title or "Notification"
    titleLabel.TextColor3 = UI_THEME.Accent
    titleLabel.TextSize = 14
    titleLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextWrapped = true
    titleLabel.Parent = textContainer

    local contentLabel = Instance.new("TextLabel")
    contentLabel.Name = "Content"
    contentLabel.Size = UDim2.new(1, 0, 0, 0)
    contentLabel.AutomaticSize = Enum.AutomaticSize.Y
    contentLabel.BackgroundTransparency = 1
    contentLabel.TextTransparency = 1
    contentLabel.Text = text or ""
    contentLabel.TextColor3 = UI_THEME.Text
    contentLabel.TextSize = 12
    contentLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    contentLabel.TextXAlignment = Enum.TextXAlignment.Left
    contentLabel.TextWrapped = true
    contentLabel.Parent = textContainer

    local coords = string.match(text, "%-?%d+%.?%d*, %-?%d+%.?%d*, %-?%d+%.?%d*")
    if coords then
        local hint = Instance.new("TextLabel")
        hint.Name = "CopyHint"
        hint.Size = UDim2.new(1, 0, 0, 10)
        hint.BackgroundTransparency = 1
        hint.TextTransparency = 1
        hint.Text = "(Click to copy coordinates)"
        hint.TextColor3 = UI_THEME.Accent
        hint.TextSize = 10
        hint.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
        hint.TextXAlignment = Enum.TextXAlignment.Left
        hint.Parent = textContainer

        local clickBtn = Instance.new("TextButton")
        clickBtn.Size = UDim2.new(1, 0, 1, 0)
        clickBtn.BackgroundTransparency = 1
        clickBtn.Text = ""
        clickBtn.Parent = frame

        TrackConnection(clickBtn.MouseButton1Click:Connect(function()
            local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
            if copy then
                copy(coords)
                hint.Text = "COPIED!"
                task.delay(1, function() if hint and hint.Parent then hint.Text = "(Click to copy coordinates)" end end)
            end
        end))

        TweenService:Create(hint, TWEENS.SMOOTH, {TextTransparency = 0}):Play()
    end

    TweenService:Create(frame, TWEENS.SMOOTH, {BackgroundTransparency = 0}):Play()
    TweenService:Create(stroke, TWEENS.SMOOTH, {Transparency = 0}):Play()
    TweenService:Create(titleLabel, TWEENS.SMOOTH, {TextTransparency = 0}):Play()
    TweenService:Create(contentLabel, TWEENS.SMOOTH, {TextTransparency = 0}):Play()
    TweenService:Create(icon, TWEENS.SMOOTH, {ImageTransparency = 0}):Play()

    task.delay(duration, function()
        if not frame or not frame.Parent then return end
        local t = TweenService:Create(frame, TWEENS.SMOOTH, {BackgroundTransparency = 1})
        TweenService:Create(stroke, TWEENS.SMOOTH, {Transparency = 1}):Play()
        TweenService:Create(titleLabel, TWEENS.SMOOTH, {TextTransparency = 1}):Play()
        TweenService:Create(contentLabel, TWEENS.SMOOTH, {TextTransparency = 1}):Play()
        TweenService:Create(icon, TWEENS.SMOOTH, {ImageTransparency = 1}):Play()
        t:Play()
        t.Completed:Connect(function()
            frame:Destroy()
        end)
    end)
end

local function ApplyUIScale(frame, scale)
    if not frame then return end
    local uiScale = frame:FindFirstChild("MenuScale")
    if not uiScale then
        uiScale = Instance.new("UIScale")
        uiScale.Name = "MenuScale"
        uiScale.Parent = frame
    end
    uiScale.Scale = scale
end

function UI.CreateWindow(title)

    EnsureScreenGui()

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.fromScale(0.4, 0.45)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = UI_THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = UIState.Visible
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui

    ApplyUIScale(MainFrame, Flags["Visuals/UIScale"] or 1)

    local mainConstraint = Instance.new("UISizeConstraint")
    mainConstraint.MinSize = Vector2.new(420, 280)
    mainConstraint.MaxSize = Vector2.new(650, 450)
    mainConstraint.Parent = MainFrame

    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 1.5
    aspect.DominantAxis = Enum.DominantAxis.Width
    aspect.Parent = MainFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(45, 45, 45)
    stroke.Thickness = 1
    stroke.Parent = MainFrame

    local shadow = Instance.new("ImageLabel")
    shadow.Name = "Shadow"
    shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    shadow.BackgroundTransparency = 1
    shadow.Position = UDim2.fromScale(0.5, 0.5)
    shadow.Size = UDim2.new(1, 100, 1, 100)
    shadow.ZIndex = 0
    shadow.Image = "rbxassetid://6015897843"
    shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    shadow.ImageTransparency = 0.4
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    shadow.Parent = MainFrame

    local Sidebar = Instance.new("Frame")
    Sidebar.Name = "Sidebar"
    Sidebar.Size = UDim2.new(0.26, 0, 1, 0)
    Sidebar.BackgroundColor3 = UI_THEME.Sidebar
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainFrame

    local sideConstraint = Instance.new("UISizeConstraint")
    sideConstraint.MinSize = Vector2.new(120, 0)
    sideConstraint.MaxSize = Vector2.new(180, 9999)
    sideConstraint.Parent = Sidebar

    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(0, 8)
    sbCorner.Parent = Sidebar

    local sbFix = Instance.new("Frame")
    sbFix.BackgroundColor3 = UI_THEME.Sidebar
    sbFix.BorderSizePixel = 0
    sbFix.Size = UDim2.new(0, 10, 1, 0)
    sbFix.Position = UDim2.new(1, -10, 0, 0)
    sbFix.Parent = Sidebar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 36)
    TitleLabel.Position = UDim2.new(0, 15, 0, 4)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title
    TitleLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = UI_THEME.Accent
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Sidebar

    local VersionLabel = Instance.new("TextLabel")
    VersionLabel.Size = UDim2.new(1, 0, 0, 14)
    VersionLabel.Position = UDim2.new(0, 15, 0, 28)
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.Text = "v" .. VERSION
    VersionLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    VersionLabel.TextSize = 11
    VersionLabel.TextColor3 = UI_THEME.TextDark
    VersionLabel.TextXAlignment = Enum.TextXAlignment.Left
    VersionLabel.Parent = Sidebar

    if SAFE_MODE then
        local SafeBadge = Instance.new("Frame")
        SafeBadge.Name = "SafeModeBadge"
        SafeBadge.Size = UDim2.new(1, -16, 0, 16)
        SafeBadge.Position = UDim2.new(0, 8, 0, 44)
        SafeBadge.BackgroundColor3 = Color3.fromRGB(20, 80, 40)
        SafeBadge.BorderSizePixel = 0
        SafeBadge.Parent = Sidebar
        local sbCorner2 = Instance.new("UICorner")
        sbCorner2.CornerRadius = UDim.new(0, 4)
        sbCorner2.Parent = SafeBadge
        local sbStroke = Instance.new("UIStroke")
        sbStroke.Color = Color3.fromRGB(40, 160, 80)
        sbStroke.Thickness = 1
        sbStroke.Parent = SafeBadge
        local SafeLabel = Instance.new("TextLabel")
        SafeLabel.Size = UDim2.fromScale(1, 1)
        SafeLabel.BackgroundTransparency = 1
        SafeLabel.Text = "✓  SAFE MODE"
        SafeLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        SafeLabel.TextSize = 9
        SafeLabel.TextColor3 = Color3.fromRGB(60, 220, 110)
        SafeLabel.Parent = SafeBadge
    end

    local TabContainer = Instance.new("ScrollingFrame")
    TabContainer.Name = "Tabs"
    TabContainer.Size = UDim2.new(1, 0, 1, -60)
    TabContainer.Position = UDim2.new(0, 0, 0, 60)
    TabContainer.BackgroundTransparency = 1
    TabContainer.BorderSizePixel = 0
    TabContainer.ScrollBarThickness = 2
    TabContainer.Parent = Sidebar

    local uiLayout = Instance.new("UIListLayout")
    uiLayout.Padding = UDim.new(0, 5)
    uiLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
    uiLayout.Parent = TabContainer

    local ContentArea = Instance.new("Frame")
    ContentArea.Name = "Content"
    ContentArea.Size = UDim2.new(0.72, 0, 1, -20)
    ContentArea.Position = UDim2.new(0.28, 0, 0, 10)
    ContentArea.BackgroundTransparency = 1
    ContentArea.ClipsDescendants = true
    ContentArea.Parent = MainFrame

    UIState.MainFrame = MainFrame
    UIState.ContentArea = ContentArea
    UIState.TabContainer = TabContainer
    UIState.ActiveDraggedFrame = nil
    UIState.DragStart = nil
    UIState.StartPos = nil

    local dragInputConn, dragEndedConn
    dragInputConn = TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if not ScreenGui or not ScreenGui.Parent then
            if dragInputConn then dragInputConn:Disconnect() end
            if dragEndedConn then dragEndedConn:Disconnect() end
            return
        end
        local Frame = UIState.ActiveDraggedFrame
        if not Frame or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local delta = input.Position - UIState.DragStart
        local screenGui = Frame:FindFirstAncestorOfClass("ScreenGui")
        local screenSize = screenGui and screenGui.AbsoluteSize or Camera.ViewportSize

        local startRelX = UIState.StartPos.X.Scale * screenSize.X + UIState.StartPos.X.Offset
        local startRelY = UIState.StartPos.Y.Scale * screenSize.Y + UIState.StartPos.Y.Offset

        local newRelX = startRelX + delta.X
        local newRelY = startRelY + delta.Y

        local absoluteSize = Frame.AbsoluteSize
        local anchor = Frame.AnchorPoint

        local minX = anchor.X * absoluteSize.X
        local maxX = screenSize.X - (1 - anchor.X) * absoluteSize.X
        local minY = anchor.Y * absoluteSize.Y
        local maxY = screenSize.Y - (1 - anchor.Y) * absoluteSize.Y

        local clampedX = math.clamp(newRelX, minX, maxX)
        local clampedY = math.clamp(newRelY, minY, maxY)

        pcall(function()
            Frame.Position = UDim2new(clampedX / screenSize.X, 0, clampedY / screenSize.Y, 0)
        end)
    end))

    dragEndedConn = TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if not ScreenGui or not ScreenGui.Parent then
            if dragEndedConn then dragEndedConn:Disconnect() end
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            UIState.ActiveDraggedFrame = nil
        end
    end))

    local function MakeDraggable(Frame)
        table.insert(UIState.DraggableFrames, Frame)

        local function attach(obj)
            if obj:IsA("GuiObject") and not obj:IsA("TextButton") and not obj:IsA("ImageButton") and not obj:IsA("TextBox") and not obj:IsA("ScrollingFrame") then
                TrackConnection(obj.InputBegan:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local current = obj
                        local insideInteractive = false
                        while current and current ~= Frame do
                            if current:IsA("TextButton") or current:IsA("ImageButton") or current:IsA("TextBox") or current:IsA("ScrollingFrame") then
                                insideInteractive = true
                                break
                            end
                            current = current.Parent
                        end

                        if not insideInteractive then
                            local absoluteSize = Frame.AbsoluteSize
                            local absolutePosition = Frame.AbsolutePosition
                            local posX = input.Position.X
                            local posY = input.Position.Y

                            if posX >= absolutePosition.X and posX <= (absolutePosition.X + absoluteSize.X) and
                               posY >= absolutePosition.Y and posY <= (absolutePosition.Y + absoluteSize.Y) then

                                UIState.ActiveDraggedFrame = Frame
                                UIState.DragStart = input.Position
                                UIState.StartPos = Frame.Position
                            end
                        end
                    end
                end))
            end
        end

        attach(Frame)
        for _, child in ipairs(Frame:GetDescendants()) do
            attach(child)
        end

        TrackConnection(Frame.DescendantAdded:Connect(attach))
    end
    UI.MakeDraggable = MakeDraggable

    MakeDraggable(MainFrame)

    local MinButton = Instance.new("TextButton")
    MinButton.Name = "Minimize"
    MinButton.Size = UDim2.new(0, 30, 0, 30)
    MinButton.Position = UDim2.new(1, -30, 0, 0)
    MinButton.BackgroundTransparency = 0
    MinButton.BackgroundColor3 = Color3.fromRGB(252, 149, 175)
    MinButton.Text = "X"
    MinButton.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    MinButton.TextSize = 20
    MinButton.TextColor3 = Color3.fromRGB(0, 0, 0)
    MinButton.Parent = MainFrame

    local Minimized = false
    local OldSize = MainFrame.Size

    local minimizedText = "Sp3arParvus v" .. VERSION
    local textSize = TextService:GetTextSize(minimizedText, 16, Enum.Font.SourceSansBold, Vector2.new(1000, 1000))
    local minimizedWidth = textSize.X + 45

    local MinimizedLabel = Instance.new("TextLabel")
    MinimizedLabel.Name = "MinimizedLabel"
    MinimizedLabel.Text = minimizedText
    MinimizedLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    MinimizedLabel.TextSize = 14
    MinimizedLabel.TextColor3 = UI_THEME.Accent
    MinimizedLabel.Position = UDim2.fromOffset(10, 0)
    MinimizedLabel.Size = UDim2.new(1, -45, 1, 0)
    MinimizedLabel.BackgroundTransparency = 1
    MinimizedLabel.TextXAlignment = Enum.TextXAlignment.Left
    MinimizedLabel.Visible = false
    MinimizedLabel.Parent = MainFrame

    local function ToggleMinimize(fromKeybind)
        Minimized = not Minimized
        UIState.Minimized = Minimized
        if Minimized then
            OldSize = MainFrame.Size
            aspect.Parent = nil
            mainConstraint.Parent = nil

            TweenService:Create(MainFrame, TWEENS.SMOOTH, {
                Size = UDim2.fromOffset(minimizedWidth, 30),
                Position = UDim2.new(1, 0, 0, 30),
                AnchorPoint = Vector2.new(1, 0)
            }):Play()
            ContentArea.Visible = false
            Sidebar.Visible = false
            MinimizedLabel.Visible = true
            MinButton.Text = "+"
            if fromKeybind then
                UI.Notify("Menu", "Minimized with 'CapsLock'")
            end
        else
            MinimizedLabel.Visible = false
            aspect.Parent = MainFrame
            mainConstraint.Parent = MainFrame
            TweenService:Create(MainFrame, TWEENS.SMOOTH, {
                Size = OldSize,
                Position = UDim2.fromScale(0.5, 0.5),
                AnchorPoint = Vector2.new(0.5, 0.5)
            }):Play()
            task.wait(0.1)
            ContentArea.Visible = true
            Sidebar.Visible = true
            MinButton.Text = "X"
            if fromKeybind then
                UI.Notify("Menu", "Restored with 'CapsLock'")
            end
        end
    end
    UIState.ToggleMinimize = ToggleMinimize

    TrackConnection(MinButton.MouseButton1Click:Connect(ToggleMinimize))

    local function ToggleVisible(forceState)
        if forceState ~= nil then
            UIState.Visible = forceState
        else
            UIState.Visible = not UIState.Visible
        end
        MainFrame.Visible = UIState.Visible
        if UIState.Visible then
            MainFrame.Size = UDim2.fromOffset(0,0)
            TweenService:Create(MainFrame, TWEENS.BACK, {Size = Minimized and UDim2.fromOffset(minimizedWidth, 30) or UDim2.fromOffset(600, 400)}):Play()
        end
    end
    UIState.ToggleVisible = ToggleVisible

    TrackConnection(UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == Enum.KeyCode.CapsLock then
            ToggleMinimize(true)
        end
    end))

    pcall(UpdateScreenUIOpacity)

    return UI
end

function UI.CreateTab(name, icon)
    local TabButton = Instance.new("TextButton")
    TabButton.Name = name .. "Tab"
    TabButton.Size = UDim2.new(1, -20, 0, 32)
    TabButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabButton.BackgroundTransparency = 1
    TabButton.Text = ""
    TabButton.Parent = UIState.TabContainer

    local TabLabel = Instance.new("TextLabel")
    TabLabel.Size = UDim2.new(1, -20, 1, 0)
    TabLabel.Position = UDim2.new(0, 15, 0, 0)
    TabLabel.BackgroundTransparency = 1
    TabLabel.Text = name
    TabLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    TabLabel.TextSize = 14
    TabLabel.TextColor3 = UI_THEME.TextDark
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left
    TabLabel.Parent = TabButton

    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 3, 0, 16)
    Indicator.Position = UDim2.new(0, 0, 0.5, -8)
    Indicator.BackgroundColor3 = UI_THEME.Accent
    Indicator.BorderSizePixel = 0
    Indicator.BackgroundTransparency = 1
    Indicator.Parent = TabButton
    local indCorner = Instance.new("UICorner"); indCorner.CornerRadius = UDim.new(1,0); indCorner.Parent = Indicator

    local Page = Instance.new("ScrollingFrame")
    Page.Name = name .. "Page"
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 2
    Page.Visible = false
    Page.Parent = UIState.ContentArea

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = Page

    TrackConnection(layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end))

    local padding = Instance.new("UIPadding")
    padding.PaddingRight = UDim.new(0, 5)
    padding.Parent = Page

    local function SelectTab()

        for _, t in pairs(UIState.Tabs) do
            TweenService:Create(t.Label, TWEENS.MEDIUM, {TextColor3 = UI_THEME.TextDark}):Play()
            TweenService:Create(t.Indicator, TWEENS.MEDIUM, {BackgroundTransparency = 1}):Play()
            t.Page.Visible = false
        end

        TweenService:Create(TabLabel, TWEENS.MEDIUM, {TextColor3 = UI_THEME.Text}):Play()
        TweenService:Create(Indicator, TWEENS.MEDIUM, {BackgroundTransparency = 0}):Play()
        Page.Visible = true
        UIState.CurrentTab = name
    end

    TrackConnection(TabButton.MouseButton1Click:Connect(SelectTab))

    table.insert(UIState.Tabs, {Button = TabButton, Label = TabLabel, Indicator = Indicator, Page = Page, Select = SelectTab})

    if #UIState.Tabs == 1 then
        SelectTab()
    end

    return Page
end

function UI.CreateSection(page, name)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 30)
    Container.BackgroundTransparency = 1
    Container.Parent = page

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Position = UDim2.new(0, 2, 0, 5)
    Label.BackgroundTransparency = 1
    Label.Text = string.upper(name)
    Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Label.TextSize = 11
    Label.TextColor3 = UI_THEME.Accent
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container
end

function UI.CreateToggle(page, text, flag, default, callback, lockable)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = UI_THEME.Element
    Frame.BorderSizePixel = 0
    Frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, lockable and -30 or 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Label.TextSize = 13
    Label.TextColor3 = UI_THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    if lockable then
        local LockBtn = Instance.new("TextButton")
        LockBtn.Name = "Lock"
        LockBtn.Size = UDim2.new(0, 24, 0, 24)
        LockBtn.AnchorPoint = Vector2.new(1, 0.5)
        LockBtn.Position = UDim2.new(1, -64, 0.5, 0)
        LockBtn.BackgroundTransparency = 1
        LockBtn.Text = Flags[flag .. "/Locked"] and "🔒" or "🔓"
        LockBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        LockBtn.TextSize = 14
        LockBtn.TextColor3 = Flags[flag .. "/Locked"] and UI_THEME.Accent or UI_THEME.TextDark
        LockBtn.Parent = Frame

        -- Allow config load to sync the lock icon when a profile is applied
        UIState.Updaters[flag .. "/Locked"] = function(state)
            local locked = state == true
            Flags[flag .. "/Locked"] = locked
            LockBtn.TextColor3 = locked and UI_THEME.Accent or UI_THEME.TextDark
            LockBtn.Text = locked and "🔒" or "🔓"
        end

        TrackConnection(LockBtn.MouseButton1Click:Connect(function()
            Flags[flag .. "/Locked"] = not Flags[flag .. "/Locked"]
            USER_MODIFIED_FLAGS[flag .. "/Locked"] = true
            LockBtn.TextColor3 = Flags[flag .. "/Locked"] and UI_THEME.Accent or UI_THEME.TextDark
            LockBtn.Text = Flags[flag .. "/Locked"] and "🔒" or "🔓"
        end))
    end

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.AnchorPoint = Vector2.new(1, 0.5)
    Switch.Position = UDim2.new(1, -12, 0.5, 0)
    Switch.BackgroundColor3 = default and UI_THEME.Accent or Color3.fromRGB(50, 50, 50)
    Switch.BorderSizePixel = 0
    Switch.Parent = Frame

    local swCorner = Instance.new("UICorner")
    swCorner.CornerRadius = UDim.new(0, 2)
    swCorner.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.Position = default and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    Knob.BackgroundColor3 = UI_THEME.Background
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch

    local kbCorner = Instance.new("UICorner")
    kbCorner.CornerRadius = UDim.new(0, 2)
    kbCorner.Parent = Knob

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Switch

    -- Guard: only set the default if no value was pre-loaded from a config
    if Flags[flag] == nil then Flags[flag] = default end

    local function updateVisuals(state)
        local targetColor = state and UI_THEME.Accent or Color3.fromRGB(50, 50, 50)
        local targetPos = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)

        TweenService:Create(Switch, TWEENS.MEDIUM, {BackgroundColor3 = targetColor}):Play()
        TweenService:Create(Knob, TWEENS.SMOOTH, {Position = targetPos}):Play()
    end

    UIState.Updaters[flag] = function(state)
        updateVisuals(state)
        if callback then callback(state) end
    end

    TrackConnection(Button.MouseButton1Click:Connect(function()
        Flags[flag] = not Flags[flag]
        USER_MODIFIED_FLAGS[flag] = true
        local state = Flags[flag]
        updateVisuals(state)
        if callback then callback(state) end
    end))
end

function UI.CreateNumericInput(page, text, flag, default, min, max, step, unit, callback, lockable)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 48)
    Frame.BackgroundColor3 = UI_THEME.Element
    Frame.BorderSizePixel = 0
    Frame.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, lockable and -42 or -12, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Label.TextSize = 13
    Label.TextColor3 = UI_THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    if lockable then
        local LockBtn = Instance.new("TextButton")
        LockBtn.Name = "Lock"
        LockBtn.Size = UDim2.new(0, 24, 0, 24)
        LockBtn.AnchorPoint = Vector2.new(1, 0.5)
        LockBtn.Position = UDim2.new(0.6, -12, 0.5, 0)
        LockBtn.BackgroundTransparency = 1
        LockBtn.Text = Flags[flag .. "/Locked"] and "🔒" or "🔓"
        LockBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        LockBtn.TextSize = 14
        LockBtn.TextColor3 = Flags[flag .. "/Locked"] and UI_THEME.Accent or UI_THEME.TextDark
        LockBtn.Parent = Frame

        -- Allow config load to sync the lock icon when a profile is applied
        UIState.Updaters[flag .. "/Locked"] = function(state)
            local locked = state == true
            Flags[flag .. "/Locked"] = locked
            LockBtn.TextColor3 = locked and UI_THEME.Accent or UI_THEME.TextDark
            LockBtn.Text = locked and "🔒" or "🔓"
        end

        TrackConnection(LockBtn.MouseButton1Click:Connect(function()
            Flags[flag .. "/Locked"] = not Flags[flag .. "/Locked"]
            USER_MODIFIED_FLAGS[flag .. "/Locked"] = true
            LockBtn.TextColor3 = Flags[flag .. "/Locked"] and UI_THEME.Accent or UI_THEME.TextDark
            LockBtn.Text = Flags[flag .. "/Locked"] and "🔒" or "🔓"
        end))
    end

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(0.4, -12, 0, 30)
    InputFrame.Position = UDim2.new(1, -12, 0.5, 0)
    InputFrame.AnchorPoint = Vector2.new(1, 0.5)
    InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InputFrame.Parent = Frame
    local ifCorner = Instance.new("UICorner"); ifCorner.CornerRadius = UDim.new(0, 4); ifCorner.Parent = InputFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -50, 1, 0)
    Input.Position = UDim2.new(0, 25, 0, 0)
    Input.BackgroundTransparency = 1
    Input.Text = tostring(Flags[flag] ~= nil and Flags[flag] or default)
    Input.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Input.TextSize = 13
    Input.TextColor3 = UI_THEME.Accent
    Input.ClearTextOnFocus = false
    Input.Parent = InputFrame

    local function updateValueStepped(val)
        val = math.clamp(tonumber(val) or default, min, max)
        if step and step > 0 then
            val = math.floor(val / step + 0.5) * step
        end
        Flags[flag] = val
        USER_MODIFIED_FLAGS[flag] = true
        Input.Text = tostring(val)
        if callback then callback(val) end
    end

    local function updateValueFree(val)
        val = math.clamp(tonumber(val) or default, min, max)
        Flags[flag] = val
        USER_MODIFIED_FLAGS[flag] = true
        Input.Text = tostring(val)
        if callback then callback(val) end
    end

    UIState.Updaters[flag] = function(val)
        if not Input:IsFocused() then
            val = math.clamp(tonumber(val) or default, min, max)
            Input.Text = tostring(val)
            if callback then pcall(callback, val) end
        end
    end

    TrackConnection(Input.FocusLost:Connect(function()
        updateValueFree(Input.Text)
    end))

    local function createBtn(t, pos, xAlign)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 25, 1, 0)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = t
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 16
        btn.TextColor3 = UI_THEME.TextDark
        btn.Parent = InputFrame
        return btn
    end

    local minusBtn = createBtn("-", UDim2.new(0, 0, 0, 0))
    local plusBtn = createBtn("+", UDim2.new(1, -25, 0, 0))

    TrackConnection(minusBtn.MouseButton1Click:Connect(function()
        updateValueStepped(Flags[flag] - (step or 1))
    end))

    TrackConnection(plusBtn.MouseButton1Click:Connect(function()
        updateValueStepped(Flags[flag] + (step or 1))
    end))

    -- Guard: only set the default if no value was pre-loaded from a config
    if Flags[flag] == nil then Flags[flag] = default end
end

-- UI.CreateRotationSlider ─────────────────────────────────────────────────
function UI.CreateRotationSlider(page, text, flag, default)
    local ROT_MIN  = -90
    local ROT_MAX  =  90

    -- Outer container (input row + slider row) ─────────────────────────
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, 0, 0, 80)
    Container.BackgroundColor3 = UI_THEME.Element
    Container.BorderSizePixel = 0
    Container.Parent = page
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(0, 6)
    cCorner.Parent = Container

    -- Label ────────────────────────────────────────────────────────────
    local Label = Instance.new("TextLabel")
    -- Leave room on the right for the Clear button (28 px)
    Label.Size = UDim2.new(0.6, -44, 0, 48)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Label.TextSize = 13
    Label.TextColor3 = UI_THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    -- Numeric input (right side of top row) ────────────────────────────
    -- Clear button ──────────────────────────────────────────────────────
    -- Visible/styled differently when the axis is actively overriding.
    local ClearBtn = Instance.new("TextButton")
    ClearBtn.Name = "ClearRotation"
    ClearBtn.Size = UDim2.new(0, 28, 0, 20)
    ClearBtn.AnchorPoint = Vector2.new(0, 0.5)
    -- Sits between the label and the input frame (left edge of input area)
    ClearBtn.Position = UDim2.new(0.6, -40, 0.5, -24) -- vertically centred in top 48 px
    ClearBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    ClearBtn.BackgroundTransparency = 0
    ClearBtn.Text = "X"
    ClearBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    ClearBtn.TextSize = 11
    ClearBtn.TextColor3 = UI_THEME.TextDark
    ClearBtn.AutoButtonColor = false
    ClearBtn.Parent = Container
    local clrCorner = Instance.new("UICorner")
    clrCorner.CornerRadius = UDim.new(0, 4)
    clrCorner.Parent = ClearBtn

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(0.4, -12, 0, 30)
    InputFrame.Position = UDim2.new(1, -12, 0, 9)
    InputFrame.AnchorPoint = Vector2.new(1, 0)
    InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InputFrame.Parent = Container
    local ifCorner = Instance.new("UICorner")
    ifCorner.CornerRadius = UDim.new(0, 4)
    ifCorner.Parent = InputFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -50, 1, 0)
    Input.Position = UDim2.new(0, 25, 0, 0)
    Input.BackgroundTransparency = 1
    Input.Text = tostring(math.floor(Flags[flag] ~= nil and Flags[flag] or default))
    Input.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Input.TextSize = 13
    Input.TextColor3 = UI_THEME.Accent
    Input.ClearTextOnFocus = false
    Input.Parent = InputFrame

    -- Slider track (bottom row) ─────────────────────────────────────────
    local TrackFrame = Instance.new("TextButton")
    TrackFrame.Name = "SliderTrack"
    TrackFrame.Size = UDim2.new(1, -24, 0, 16)
    TrackFrame.Position = UDim2.new(0, 12, 0, 56)
    TrackFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    TrackFrame.BorderSizePixel = 0
    TrackFrame.Text = ""
    TrackFrame.AutoButtonColor = false
    TrackFrame.Parent = Container
    local tCorner = Instance.new("UICorner")
    tCorner.CornerRadius = UDim.new(0, 6)
    tCorner.Parent = TrackFrame

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new(0.5, 0, 1, 0) -- 50 % = 0 degrees
    Fill.BackgroundColor3 = UI_THEME.Accent
    Fill.BorderSizePixel = 0
    Fill.ZIndex = 2
    Fill.Parent = TrackFrame
    local fCorner = Instance.new("UICorner")
    fCorner.CornerRadius = UDim.new(0, 6)
    fCorner.Parent = Fill

    -- Draggable thumb — also a TextButton so MakeDraggable skips it.
    local Thumb = Instance.new("TextButton")
    Thumb.Name = "Thumb"
    Thumb.Size = UDim2.new(0, 16, 0, 16)
    Thumb.AnchorPoint = Vector2.new(0.5, 0.5)
    Thumb.Position = UDim2.new(0.5, 0, 0.5, 0)
    Thumb.BackgroundColor3 = UI_THEME.Text
    Thumb.BorderSizePixel = 0
    Thumb.Text = ""
    Thumb.AutoButtonColor = false
    Thumb.ZIndex = 4
    Thumb.Parent = TrackFrame
    local thCorner = Instance.new("UICorner")
    thCorner.CornerRadius = UDim.new(1, 0) -- circle
    thCorner.Parent = Thumb

    -- Helper: convert degree value → slider fraction ────────────────────
    local function setOverrideVisuals(isOverriding)
        if isOverriding then
            Label.TextColor3 = UI_THEME.Accent
            ClearBtn.TextColor3 = UI_THEME.Accent
            ClearBtn.BackgroundColor3 = Color3.fromRGB(60, 35, 45)
        else
            Label.TextColor3 = UI_THEME.Text
            ClearBtn.TextColor3 = UI_THEME.TextDark
            ClearBtn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
        end
    end

    local function degToFrac(deg)
        return (math.clamp(deg, ROT_MIN, ROT_MAX) - ROT_MIN) / (ROT_MAX - ROT_MIN)
    end

    -- Helper: update slider visuals from a fraction ─────────────────────
    local function applyFrac(frac)
        frac = math.clamp(frac, 0, 1)
        Fill.Size = UDim2.new(frac, 0, 1, 0)
        Thumb.Position = UDim2.new(frac, 0, 0.5, 0)
    end

    -- Helper: clamp + snap to integer, then propagate everywhere ─────────
    local function commitDeg(rawDeg, isUserAction)
        local deg = math.clamp(math.floor(rawDeg + 0.5), ROT_MIN, ROT_MAX)
        Flags[flag] = deg
        if isUserAction then
            USER_MODIFIED_FLAGS[flag] = true
            setOverrideVisuals(true)
        end
        if not Input:IsFocused() then
            Input.Text = tostring(deg)
        end
        applyFrac(degToFrac(deg))
    end

    -- UIState.Updaters: passive (read-only) refresh from UpdateHumanoidUI
    UIState.Updaters[flag] = function(val)
        -- Never mark USER_MODIFIED_FLAGS — this is a passive display update.
        local deg = math.clamp(math.floor(tonumber(val) or default), ROT_MIN, ROT_MAX)
        Flags[flag] = deg
        if not Input:IsFocused() then
            Input.Text = tostring(deg)
        end
        applyFrac(degToFrac(deg))
    end

    -- TextBox: commit on focus lost ──────────────────────────────────────
    TrackConnection(ClearBtn.MouseButton1Click:Connect(function()
        USER_MODIFIED_FLAGS[flag] = nil
        PROFILE_LOADED_FLAGS[flag] = nil
        setOverrideVisuals(false)
    end))

    TrackConnection(Input.FocusLost:Connect(function()
        commitDeg(tonumber(Input.Text) or Flags[flag] or default, true)
    end))

    -- Step buttons (− / +) ──────────────────────────────────────────────
    local function makeStepBtn(label, pos)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 25, 1, 0)
        btn.Position = pos
        btn.BackgroundTransparency = 1
        btn.Text = label
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 16
        btn.TextColor3 = UI_THEME.TextDark
        btn.Parent = InputFrame
        return btn
    end

    local minusBtn = makeStepBtn("-", UDim2.new(0, 0, 0, 0))
    local plusBtn  = makeStepBtn("+", UDim2.new(1, -25, 0, 0))

    TrackConnection(minusBtn.MouseButton1Click:Connect(function()
        commitDeg((Flags[flag] or default) - 1, true)
    end))
    TrackConnection(plusBtn.MouseButton1Click:Connect(function()
        commitDeg((Flags[flag] or default) + 1, true)
    end))

    -- Slider drag ───────────────────────────────────────────────────────
    local dragging = false

    local function sliderFromInput(inputPos)
        local trackPos  = TrackFrame.AbsolutePosition
        local trackSize = TrackFrame.AbsoluteSize
        local frac = math.clamp((inputPos.X - trackPos.X) / trackSize.X, 0, 1)
        local deg  = ROT_MIN + frac * (ROT_MAX - ROT_MIN)
        commitDeg(deg, true)
    end

    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            UIState.ActiveDraggedFrame = nil  -- prevent window drag racing
            dragging = true
            sliderFromInput(input.Position)
        end
    end

    TrackConnection(TrackFrame.InputBegan:Connect(beginDrag))
    TrackConnection(Thumb.InputBegan:Connect(beginDrag))

    TrackConnection(UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            sliderFromInput(input.Position)
        end
    end))
    TrackConnection(UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end))

    -- Initialise visuals from current flag value ─────────────────────────
    local initVal = Flags[flag] ~= nil and Flags[flag] or default
    Flags[flag] = math.clamp(math.floor(initVal + 0.5), ROT_MIN, ROT_MAX)
    Input.Text = tostring(Flags[flag])
    applyFrac(degToFrac(Flags[flag]))
    setOverrideVisuals(USER_MODIFIED_FLAGS[flag] == true)
end



function UI.CreateButton(page, text, callback)
    local Button = Instance.new("TextButton")

    Button.Size = UDim2.new(1, 0, 0, 36)
    Button.BackgroundColor3 = UI_THEME.Accent
    Button.BackgroundTransparency = 0.2
    Button.BorderSizePixel = 0
    Button.Text = text
    Button.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Button.TextSize = 13
    Button.TextColor3 = UI_THEME.Background
    Button.Parent = page

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = Button

    local stroke = Instance.new("UIStroke")
    stroke.Color = UI_THEME.Accent
    stroke.Thickness = 1
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = Button

    TrackConnection(Button.MouseButton1Click:Connect(function()

        TweenService:Create(Button, TWEENS.INSTANT, {Size = UDim2.new(1, -4, 0, 32)}):Play()
        task.wait(0.05)
        TweenService:Create(Button, TWEENS.INSTANT, {Size = UDim2.new(1, 0, 0, 36)}):Play()
        if callback then callback() end
    end))
end

function GetPing()
    local success, ping = pcall(LocalPlayer.GetNetworkPing, LocalPlayer)
    return success and ping * 1000 or 0
end

GetFPS = nil
do
    local frameCount = 0
    local lastTime = os.clock()
    local cachedFPS = 60
    local updateInterval = 0.5

    GetFPS = function() return cachedFPS end

    TrackConnection(Services.RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
        local now = os.clock()
        local elapsed = now - lastTime

        if elapsed >= updateInterval then
            cachedFPS = math.floor(frameCount / elapsed)
            frameCount = 0
            lastTime = now
        end
    end))
end

function Rejoin()
    if #Services.Players:GetPlayers() <= 1 then
        task.wait(0.5)
        TeleportService:Teleport(game.PlaceId)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId)
    end
end

TrackConnection(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    local newCamera = Workspace.CurrentCamera
    if newCamera then
        Camera = newCamera
        if ConnectViewportSize then ConnectViewportSize() end
    end
end))

function UpdateLighting()
    local fullbright = Flags["Visuals/Fullbright"]
    local fullDark   = Flags["Visuals/FullDark"]
    local currentState = fullbright or fullDark

    -- Snapshot original lighting when first entering either mode
    if currentState ~= FullbrightState.lastState then
        if currentState then
            if not FullbrightState.originalSettings then
                local atmosphere = Services.Lighting:FindFirstChildOfClass("Atmosphere")
                local sky        = Services.Lighting:FindFirstChildOfClass("Sky")
                local bloom      = Services.Lighting:FindFirstChildOfClass("BloomEffect")
                FullbrightState.originalSettings = {
                    Ambient            = Services.Lighting.Ambient,
                    OutdoorAmbient     = Services.Lighting.OutdoorAmbient,
                    Brightness         = Services.Lighting.Brightness,
                    ClockTime          = Services.Lighting.ClockTime,
                    FogEnd             = Services.Lighting.FogEnd,
                    FogStart           = Services.Lighting.FogStart,
                    FogColor           = Services.Lighting.FogColor,
                    GlobalShadows      = Services.Lighting.GlobalShadows,
                    ExposureCompensation = Services.Lighting.ExposureCompensation,
                    AtmosphereDensity  = atmosphere and atmosphere.Density  or nil,
                    AtmosphereHaze     = atmosphere and atmosphere.Haze     or nil,
                    AtmosphereGlare    = atmosphere and atmosphere.Glare    or nil,
                    SkyHaze            = sky  and sky.StarCount or nil,
                    BloomIntensity     = bloom and bloom.Intensity or nil,
                }
            end
        else
            -- Restore all saved settings on deactivation
            if FullbrightState.originalSettings then
                local s = FullbrightState.originalSettings
                Services.Lighting.Ambient             = s.Ambient
                Services.Lighting.OutdoorAmbient      = s.OutdoorAmbient
                Services.Lighting.Brightness          = s.Brightness
                Services.Lighting.ClockTime           = s.ClockTime
                Services.Lighting.FogEnd              = s.FogEnd
                Services.Lighting.FogStart            = s.FogStart
                Services.Lighting.FogColor            = s.FogColor
                Services.Lighting.GlobalShadows       = s.GlobalShadows
                Services.Lighting.ExposureCompensation = s.ExposureCompensation

                local atmosphere = Services.Lighting:FindFirstChildOfClass("Atmosphere")
                if atmosphere then
                    if s.AtmosphereDensity ~= nil then atmosphere.Density = s.AtmosphereDensity end
                    if s.AtmosphereHaze    ~= nil then atmosphere.Haze    = s.AtmosphereHaze    end
                    if s.AtmosphereGlare   ~= nil then atmosphere.Glare   = s.AtmosphereGlare   end
                end

                local bloom = Services.Lighting:FindFirstChildOfClass("BloomEffect")
                if bloom and s.BloomIntensity ~= nil then
                    bloom.Intensity = s.BloomIntensity
                end

                FullbrightState.originalSettings = nil
            end
        end
        FullbrightState.lastState = currentState
    end

    if not currentState then return end

    if FullbrightState.originalSettings then
        local s = FullbrightState.originalSettings
        Services.Lighting.Ambient             = s.Ambient
        Services.Lighting.OutdoorAmbient      = s.OutdoorAmbient
        Services.Lighting.Brightness          = s.Brightness
        Services.Lighting.ClockTime           = s.ClockTime
        Services.Lighting.FogEnd              = s.FogEnd
        Services.Lighting.FogStart            = s.FogStart
        Services.Lighting.FogColor            = s.FogColor
        Services.Lighting.GlobalShadows       = s.GlobalShadows
        Services.Lighting.ExposureCompensation = s.ExposureCompensation

        local atmosphere = Services.Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            if s.AtmosphereDensity ~= nil then atmosphere.Density = s.AtmosphereDensity end
            if s.AtmosphereHaze    ~= nil then atmosphere.Haze    = s.AtmosphereHaze    end
            if s.AtmosphereGlare   ~= nil then atmosphere.Glare   = s.AtmosphereGlare   end
        end

        local bloom = Services.Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom and s.BloomIntensity ~= nil then
            bloom.Intensity = s.BloomIntensity
        end
    end

    -- FULLBRIGHT ──────────────────────────────────────────────────────────
    if fullbright then
        -- Ambient
        if Flags["Visuals/Fullbright/WhiteAmbient"] then
            Services.Lighting.Ambient        = Color3.fromRGB(255, 255, 255)
            Services.Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        end

        -- Brightness
        Services.Lighting.Brightness = Flags["Visuals/Fullbright/Brightness"]

        -- Time of day
        Services.Lighting.ClockTime = Flags["Visuals/Fullbright/ClockTime"]

        -- Exposure
        if Flags["Visuals/Fullbright/SetExposure"] then
            Services.Lighting.ExposureCompensation = Flags["Visuals/Fullbright/ExposureCompensation"]
        end

        -- Fog
        if Flags["Visuals/Fullbright/RemoveFog"] then
            Services.Lighting.FogEnd   = Flags["Visuals/Fullbright/FogEnd"]
            Services.Lighting.FogStart = Flags["Visuals/Fullbright/FogStart"]
        end

        -- Shadows
        if Flags["Visuals/Fullbright/RemoveShadows"] then
            Services.Lighting.GlobalShadows = false
        end

        -- Atmosphere
        local atmosphere = Services.Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere and Flags["Visuals/Fullbright/RemoveAtmosphere"] then
            atmosphere.Density = 0
            atmosphere.Haze    = Flags["Visuals/Fullbright/SkyHaze"]
            atmosphere.Glare   = Flags["Visuals/Fullbright/SkyGlare"]
        end

    -- FULLDARK ────────────────────────────────────────────────────────────
    elseif fullDark then
        -- Time of day
        Services.Lighting.ClockTime = Flags["Visuals/FullDark/ClockTime"]

        -- Brightness
        if Flags["Visuals/FullDark/SetShadows"] then
            Services.Lighting.Brightness    = Flags["Visuals/FullDark/Brightness"]
            Services.Lighting.GlobalShadows = true
        end

        -- Exposure
        if Flags["Visuals/FullDark/SetExposure"] then
            Services.Lighting.ExposureCompensation = Flags["Visuals/FullDark/ExposureCompensation"]
        end

        -- Ambient
        if Flags["Visuals/FullDark/BlackAmbient"] then
            Services.Lighting.Ambient        = Color3.fromRGB(0, 0, 0)
            Services.Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        end

        -- Fog
        if Flags["Visuals/FullDark/SetFog"] then
            Services.Lighting.FogEnd   = Flags["Visuals/FullDark/FogEnd"]
            Services.Lighting.FogStart = Flags["Visuals/FullDark/FogStart"]
        end

        -- Atmosphere
        local atmosphere = Services.Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere and Flags["Visuals/FullDark/SetAtmosphere"] then
            atmosphere.Density = Flags["Visuals/FullDark/AtmosphereDensity"]
            atmosphere.Haze    = Flags["Visuals/FullDark/SkyHaze"]
            atmosphere.Glare   = Flags["Visuals/FullDark/SkyGlare"]
        end
    end
end

function GetCharacter(player)
    if not player then return nil end

    local cache = CharCache[player]
    if cache then
        local char = cache.Char
        local root = cache.Root

        if char and char.Parent and char == player.Character and root and root.Parent then

            if cache.Humanoid then
                if cache.Humanoid.Health > 0 then
                    return char, root
                end
                return nil

            elseif cache.HealthInst then
                 if cache.HealthInst.Value > 0 then
                     return char, root
                 end
                 return nil
            else

                return char, root
            end
        else

             cache.Char = nil
             cache.Root = nil
             cache.Humanoid = nil
             cache.HealthInst = nil
             cache.Head = nil
        end
    end

    local character = player.Character
    if not character or not character.Parent then return nil end

    local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
    if not rootPart then return nil end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local healthInst = nil

    if not humanoid then
        local stats = player:FindFirstChild("Stats")
        if stats and stats:IsA("Folder") then
            local health = stats:FindFirstChild("Health")
            if health and health:IsA("ValueBase") then
                healthInst = health
            end
        end
    end

    if not cache then
        cache = {}
        CharCache[player] = cache
    end
    cache.Char = character
    cache.HumanoidRootPart = rootPart
    cache.Root = rootPart
    cache.Humanoid = humanoid
    cache.HealthInst = healthInst

    cache.Head = character:FindFirstChild("Head")

    if humanoid and humanoid.Health <= 0 then return nil end
    if healthInst and healthInst.Value <= 0 then return nil end

    return character, rootPart
end

function GetHealth(player)
    if not player then return 0, 100 end

    local cache = CharCache[player]
    if cache then
        if cache.Humanoid then
            return cache.Humanoid.Health, cache.Humanoid.MaxHealth
        elseif cache.HealthInst then
            return cache.HealthInst.Value, 100
        end
    end

    local char = player.Character
    if char then
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            return humanoid.Health, humanoid.MaxHealth
        end

        local stats = player:FindFirstChild("Stats")
        if stats and stats:IsA("Folder") then
            local health = stats:FindFirstChild("Health")
            if health and health:IsA("ValueBase") then
                return health.Value, 100
            end
        end
    end

    return 0, 100
end

function GetHealthColor(health, maxHealth)

    local snappedHealth = math.floor(health / 5) * 5
    local percent = math.clamp(snappedHealth / maxHealth, 0, 1)

    if percent >= 0.75 then

        local t = (1 - percent) / 0.25
        return Color3.fromRGB(math.floor(127 * t), 255, 0)
    elseif percent >= 0.50 then

        local t = (0.75 - percent) / 0.25
        return Color3.fromRGB(127 + math.floor(128 * t), 255, 0)
    elseif percent >= 0.25 then

        local t = (0.50 - percent) / 0.25
        return Color3.fromRGB(255, 255 - math.floor(128 * t), 0)
    else

        local t = (0.25 - percent) / 0.25
        return Color3.fromRGB(255, 127 - math.floor(127 * t), 0)
    end
end

function InEnemyTeam(Enabled, Player)
    if not Enabled then return true end

    local lpTeam, pTeam = LocalPlayer.Team, Player.Team
    if lpTeam and pTeam then
        if lpTeam == pTeam then
            return false
        end
    end

    local pCache = CharCache[Player]
    if not pCache then
        GetCharacter(Player)
        pCache = CharCache[Player]
    end

    if pCache then
        if pCache.Squad == nil then
            pCache.Squad = Player:FindFirstChild("Squad") or false
        end

        local playerSquad = pCache.Squad
        if playerSquad then
            local lpCache = CharCache[LocalPlayer]
            if not lpCache then
                GetCharacter(LocalPlayer)
                lpCache = CharCache[LocalPlayer]
            end

            if lpCache then
                if lpCache.Squad == nil then
                    lpCache.Squad = LocalPlayer:FindFirstChild("Squad") or false
                end

                local localSquad = lpCache.Squad
                if localSquad and localSquad.Value ~= "" and localSquad.Value == playerSquad.Value then
                    return false
                end
            end
        end
    end

    return true
end

lastCharCachePrune = 0
CHAR_CACHE_PRUNE_INTERVAL = 5.0

function PruneCharCache()
    local now = os.clock()
    if (now - lastCharCachePrune) < CHAR_CACHE_PRUNE_INTERVAL then return end
    lastCharCachePrune = now

    local players = GetPlayersCache()
    local playerMap = {}
    for i = 1, #players do playerMap[players[i]] = true end

    for player, cache in pairs(CharCache) do

        if not playerMap[player] or not player.Parent then
            if AimState.LastAimTarget == player then
                AimState.LastAimTarget = nil
            end
            RemoveESP(player)
            cache.Char = nil
            cache.HumanoidRootPart = nil
            cache.Head = nil
            cache.Root = nil
            cache.Humanoid = nil
            cache.HealthInst = nil
            cache.Squad = nil
            CharCache[player] = nil

        elseif cache.Char and not cache.Char.Parent then
            if AimState.LastAimTarget == player then
                AimState.LastAimTarget = nil
            end
            RemovePlayerOutlines(player)
            cache.Char = nil
            cache.Root = nil
            cache.Humanoid = nil
            cache.HealthInst = nil
            cache.Head = nil
        elseif cache.Root and not cache.Root.Parent then
            if AimState.LastAimTarget == player then
                AimState.LastAimTarget = nil
            end
            RemovePlayerOutlines(player)
            cache.Root = nil
            cache.Humanoid = nil
            cache.HealthInst = nil
            cache.Head = nil
        end
    end
end

ClearCandidateReferences = nil

function ValidateESPObjects()

    if PlayerOutlineObjects then
        for player, _ in pairs(PlayerOutlineObjects) do
            if not player or not player.Parent then
                pcall(RemovePlayerOutlines, player)
            end
        end
    end

    if not ESPObjects then return end
    for player, espData in pairs(ESPObjects) do

        if not player or not player.Parent then

            if NearestPlayerRef == player then NearestPlayerRef = nil end
            if AimState.LastAimTarget == player then AimState.LastAimTarget = nil end
            if ClosestResult[1] == player then table.clear(ClosestResult) end

            if AdvancedPlayerPanelState.SelectedPlayer == player then
                AdvancedPlayerPanelState.SelectedPlayer = nil
                SwitchToPlayerPageView("List")
            end
            if AdvancedPlayerPanelState.Spectating == player then
                AdvancedPlayerPanelState.Spectating = nil
            end

            pcall(RemovePlayerOutlines, player)

            pcall(function()
                if espData.Nametag then espData.Nametag:Destroy() end
                if espData.Connections then
                    for _, conn in pairs(espData.Connections) do
                        if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
                            conn:Disconnect()
                        end
                    end
                    table.clear(espData.Connections)
                end
                espData.Nametag = nil
                espData.EquippedLabel = nil
                espData.Connections = nil
            end)
            ESPObjects[player] = nil
        end
    end
end

CachedFilterType = (function()

    local ok, val = pcall(function()
        local ft = Enum.RaycastFilterType.Exclude

        if typeof(ft) == "EnumItem" then
            return ft
        end
    end)
    if ok and val then
        print("[Sp3arParvus] Successfully cached RaycastFilterType.Exclude")
        return val
    end

    ok, val = pcall(function()
        local ft = Enum.RaycastFilterType.Blacklist
        if typeof(ft) == "EnumItem" then
            return ft
        end
    end)
    if ok and val then
        print("[Sp3arParvus] Successfully cached RaycastFilterType.Blacklist")
        return val
    end

    warn("[Sp3arParvus] WARNING: Could not cache any RaycastFilterType enum - raycasts may not filter properly")
    return nil
end)()

SharedRaycastParams = RaycastParams.new()
SharedRaycastParams.IgnoreWater = true
if CachedFilterType then
    SharedRaycastParams.FilterType = CachedFilterType
end

function Raycast(Origin, Direction, Filter)
    SharedRaycastParams.FilterDescendantsInstances = Filter
    return Workspace:Raycast(Origin, Direction, SharedRaycastParams)
end

function WithinReach(Enabled, Distance, Limit)
    if not Enabled then return true end
    return Distance < Limit
end

OcclusionFilter = {nil, nil}

function ObjectOccluded(Enabled, Origin, Position, Object)
    if not Enabled then return false end

    if typeof(Position) ~= "Vector3" then return false end

    OcclusionFilter[1] = LocalPlayer.Character
    OcclusionFilter[2] = Object
    local hit = Raycast(Origin, Position - Origin, OcclusionFilter)

    if hit and hit.Instance and not hit.Instance:IsDescendantOf(Object) then
        return true
    end

    return false
end

ClosestResult = {nil, nil, nil, 0, 0, nil}

function CandidateSortFn(a, b)
    return a.mag < b.mag
end

CandidateList = {}
CandidateCount = 0
MAX_CANDIDATES = 15

function ClearCandidateReferences()
    if not CandidateList then return end

    if #CandidateList > MAX_CANDIDATES * 3 then
        for i = MAX_CANDIDATES * 3 + 1, #CandidateList do
            CandidateList[i] = nil
        end
    end

    for i = 1, #CandidateList do
        local entry = CandidateList[i]
        if entry then
            entry.ply = nil
            entry.char = nil
            entry.part = nil
            entry.pos = nil
            entry.realPos = nil
        end
    end

end

local _hoistedCheckParts = {}
local _lastTargetGroupsHash = nil

local function RebuildCheckParts()
    table.clear(_hoistedCheckParts)
    local anySelected = false
    for category, enabled in pairs(Flags["Aim/TargetGroups"]) do
        if enabled then
            anySelected = true
            for _, partName in ipairs(TARGET_GROUPS[category]) do
                table.insert(_hoistedCheckParts, partName)
            end
        end
    end
    if not anySelected then
        table.clear(_hoistedCheckParts)
        for _, partName in ipairs(ALL_BODY_PARTS) do
            table.insert(_hoistedCheckParts, partName)
        end
    end
end

function GetClosest(Enabled, TeamCheck, VisibilityCheck, DistanceCheck, DistanceLimit, FieldOfView, Priority, BodyParts, StickyTarget)
    if not Enabled then
        return nil
    end

    local CameraPosition = Camera.CFrame.Position
    local mouseBehavior = UserInputService.MouseBehavior

    local crosshairX, crosshairY, crosshairValid = GetCrosshairViewportPosition(mouseBehavior)
    if not crosshairValid then
        return nil
    end

    CandidateCount = 0

    local players = GetPlayersCache()
    local lookVector = Camera.CFrame.LookVector
    local maxCandsLimit = MAX_CANDIDATES * 3

    local currentHash = (Flags["Aim/TargetGroups"].Head and 1 or 0) +
                        (Flags["Aim/TargetGroups"].Torso and 2 or 0) +
                        (Flags["Aim/TargetGroups"].LeftArm and 4 or 0) +
                        (Flags["Aim/TargetGroups"].RightArm and 8 or 0) +
                        (Flags["Aim/TargetGroups"].LeftLeg and 16 or 0) +
                        (Flags["Aim/TargetGroups"].RightLeg and 32 or 0)
    if currentHash ~= _lastTargetGroupsHash then
        RebuildCheckParts()
        _lastTargetGroupsHash = currentHash
    end
    local checkParts = _hoistedCheckParts
    local isLocalDNR = DNR(LocalPlayer)

    for _, Player in ipairs(players) do
        if Player == LocalPlayer then
            continue
        end
        if not isLocalDNR and DNR(Player) then
            continue
        end

        local pId = Player.UserId
        local pTeam = Player.Team
        local teamName = pTeam and pTeam.Name

        local isIndivWhitelisted = AdvancedPlayerPanelState.Whitelist[pId]
        local isIndivBlacklisted = AdvancedPlayerPanelState.Blacklist[pId]
        local isTeamWhitelisted = teamName and AdvancedPlayerPanelState.TeamWhitelist[teamName]
        local isTeamBlacklisted = teamName and AdvancedPlayerPanelState.TeamBlacklist[teamName]

        local isWhitelisted = isIndivWhitelisted or (isTeamWhitelisted and not isIndivBlacklisted)
        local isBlacklisted = isIndivBlacklisted or (isTeamBlacklisted and not isIndivWhitelisted)

        if isWhitelisted then
            continue
        end

        local Character, RootPart = GetCharacter(Player)
        if not Character or not RootPart then
            continue
        end
        if not isBlacklisted and not InEnemyTeam(TeamCheck, Player) then
            continue
        end

        local rootPos = RootPart.Position
        local relPos = rootPos - CameraPosition

        if not isBlacklisted and lookVector:Dot(relPos) < 0 then
            continue
        end

        local rootDist = relPos.Magnitude
        if not isBlacklisted and DistanceCheck and rootDist > (DistanceLimit + 50) then
            continue
        end

        for _, PartName in ipairs(checkParts) do
            local cache = CharCache[Player]
            local BodyPart = (cache and cache[PartName]) or Character:FindFirstChild(PartName)
            if not BodyPart then
                continue
            end

            local ActualPosition = BodyPart.Position
            local Distance = (ActualPosition - CameraPosition).Magnitude

            if not isBlacklisted and DistanceCheck and Distance >= DistanceLimit then
                continue
            end

            local ScreenPosition, OnScreen = GetViewportPoint(ActualPosition)
            if OnScreen then
                local screenX, screenY = ScreenPosition.X, ScreenPosition.Y
                local dx, dy = screenX - crosshairX, screenY - crosshairY
                local Magnitude = sqrt(dx * dx + dy * dy)

                local bypassBlacklistPriority = false
                if isBlacklisted and Flags["Aim/BypassBlacklistPriorityIfOccludedOrFar"] then
                    local isOccluded = ObjectOccluded(VisibilityCheck, CameraPosition, ActualPosition, Character)
                    local isFar = Distance > Flags["Aim/BlacklistBypassDistance"]
                    if isOccluded or isFar then
                        bypassBlacklistPriority = true
                    end
                end

                local priorityRank = GetPriorityRank(Player, teamName)
                if priorityRank then
                    Magnitude = Magnitude - (30000 - priorityRank * 100)
                elseif isBlacklisted and not bypassBlacklistPriority then
                    Magnitude = Magnitude - 10000
                end

                if isBlacklisted or priorityRank or Magnitude < FieldOfView then
                    local TargetPosition = ActualPosition

                    if CandidateCount < maxCandsLimit then
                        CandidateCount = CandidateCount + 1
                        local entry = CandidateList[CandidateCount]
                        if not entry then
                            entry = {}
                            CandidateList[CandidateCount] = entry
                        end
                        entry.mag = Magnitude
                        entry.ply = Player
                        entry.char = Character
                        entry.part = BodyPart
                        entry.sx = screenX
                        entry.sy = screenY
                        entry.pos = TargetPosition
                        entry.realPos = ActualPosition
                    end
                end
            end
        end
    end

    if CandidateCount == 0 then
        return nil
    end

    local currentSize = #CandidateList
    if CandidateCount > 1 then
        BoundedInsertionSort(CandidateList, CandidateCount, CandidateSortFn)
    end

    local stickyId = StickyTarget and StickyTarget.UserId
    local stickyTeam = StickyTarget and StickyTarget.Team and StickyTarget.Team.Name
    local isStickyBlacklisted = stickyId and (AdvancedPlayerPanelState.Blacklist[stickyId] or (stickyTeam and AdvancedPlayerPanelState.TeamBlacklist[stickyTeam] and not AdvancedPlayerPanelState.Whitelist[stickyId]))

    if StickyTarget and not isStickyBlacklisted then
        for i = 1, CandidateCount do
            local entry = CandidateList[i]
            if entry.ply == StickyTarget then
                local pId = entry.ply.UserId
                local pTeam = entry.ply.Team
                local teamName = pTeam and pTeam.Name
                local isSpecTargetBlacklisted = AdvancedPlayerPanelState.Blacklist[pId] or (teamName and AdvancedPlayerPanelState.TeamBlacklist[teamName] and not AdvancedPlayerPanelState.Whitelist[pId])

                local performStickyOcclusion = true
                if isSpecTargetBlacklisted and Flags["Aim/TargetBlacklistedThroughTerrain"] then
                    performStickyOcclusion = false
                end

                if not performStickyOcclusion or not ObjectOccluded(VisibilityCheck, CameraPosition, entry.realPos, entry.char) then
                    ClosestResult[1] = entry.ply
                    ClosestResult[2] = entry.char
                    ClosestResult[3] = entry.part
                    ClosestResult[4] = entry.sx
                    ClosestResult[5] = entry.sy
                    ClosestResult[6] = entry.pos
                    return ClosestResult
                end
                break
            end
        end
    end

    local limit = min(CandidateCount, MAX_CANDIDATES)

    for i = 1, limit do
        local entry = CandidateList[i]
        if not entry then
            continue
        end

        local pId = entry.ply.UserId
        local pTeam = entry.ply.Team
        local teamName = pTeam and pTeam.Name
        local isEntryBlacklisted = AdvancedPlayerPanelState.Blacklist[pId] or (teamName and AdvancedPlayerPanelState.TeamBlacklist[teamName] and not AdvancedPlayerPanelState.Whitelist[pId])

        local performOcclusionCheck = true
        if isEntryBlacklisted and Flags["Aim/TargetBlacklistedThroughTerrain"] then
            performOcclusionCheck = false
        end

        if performOcclusionCheck and ObjectOccluded(VisibilityCheck, CameraPosition, entry.realPos, entry.char) then
            continue
        end

        ClosestResult[1] = entry.ply
        ClosestResult[2] = entry.char
        ClosestResult[3] = entry.part
        ClosestResult[4] = entry.sx
        ClosestResult[5] = entry.sy
        ClosestResult[6] = entry.pos

        return ClosestResult
    end

    return nil
end

function AimAt(Hitbox)
    if not Hitbox then
        ClearAimLockState(false)
        return
    end
    if not mousemoverel then
        return
    end

    local targetPart = Hitbox[3]
    if not targetPart or not targetPart.Parent then
        ClearAimLockState(false)
        return
    end

    local currentMode = Services.UserInputService.MouseBehavior
    if currentMode ~= AimState.LastMouseMode then
        AimState.LastMouseMode = currentMode
        AimState.LastOriginX = nil
        AimState.LastOriginY = nil
    end

    local currentTarget = Hitbox[1]
    if currentTarget ~= AimState.LastAimTarget then
        AimState.LastAimTarget = currentTarget
        AimState.LastOriginX = nil
        AimState.LastOriginY = nil
    end

    local targetPos = targetPart.Position
    local cameraCFrame = Camera.CFrame
    local cameraPos = cameraCFrame.Position
    local dist = (targetPos - cameraPos).Magnitude

    if dist < 1 then
        return
    end

    local ScreenPosition, OnScreen = GetViewportPoint(targetPos)
    if not OnScreen or ScreenPosition.Z <= 0 then
        return
    end

    local viewportSize = Camera.ViewportSize
    local originX, originY, originValid = GetCrosshairViewportPosition(currentMode)
    if not originValid then
        return
    end

    local lastOriginX = AimState.LastOriginX
    local lastOriginY = AimState.LastOriginY
    AimState.LastOriginX = originX
    AimState.LastOriginY = originY

    local targetX, targetY = ScreenPosition.X, ScreenPosition.Y
    local dx, dy = targetX - originX, targetY - originY

    local mag = sqrt(dx * dx + dy * dy)
    if mag > Flags["Aim/FOV/Radius"] then
        return
    end

    local attractionMultiplier = Flags["Aim/AttractionStrength"] / 100

    if Flags["Aim/Dampening"] then
        local lockThreshold = Flags["Aim/Dampening/Threshold"]
        if mag < lockThreshold then
            local dampening = math.max(Flags["Aim/Dampening/Strength"] / 100, mag / lockThreshold)
            attractionMultiplier = attractionMultiplier * dampening
        end
    end

    local BASE_PULL = 0.2
    local deltaX = dx * BASE_PULL * attractionMultiplier
    local deltaY = dy * BASE_PULL * attractionMultiplier

    if deltaX ~= deltaX or deltaY ~= deltaY then
        return
    end

    local maxClampX = viewportSize.X * 0.5
    local maxClampY = viewportSize.Y * 0.5

    deltaX = math.clamp(deltaX, -maxClampX, maxClampX)
    deltaY = math.clamp(deltaY, -maxClampY, maxClampY)

    mousemoverel(floor(deltaX + 0.5), floor(deltaY + 0.5))
end

ESPObjects = {}
PlayerOutlineObjects = {}

local _cachedESPOpacity      = nil
local _cachedESPTransparency = nil

COLORS = {
    CLOSEST = Color3.fromRGB(255, 105, 180),
    NORMAL = Color3.fromRGB(255, 255, 255),
    OUTLINE = Color3.fromRGB(255, 105, 180)
}

MAX_OUTLINE_HIGHLIGHTS = 15

COLOR_CLOSE = Color3.fromRGB(255, 50, 50)
COLOR_MID = Color3.fromRGB(255, 200, 50)
COLOR_FAR = Color3.fromRGB(50, 255, 50)

ClosestPlayerTrackerLabel = nil
TrackerMinimized = false
TrackerOriginalSize = UDim2.fromOffset(220, 70)
NearestPlayerRef = nil
CurrentTargetDistance = 0
TrackerStrokeRef = nil

function GetDistanceColor(distance, isClosest)
    if isClosest then
        return COLORS.CLOSEST
    end

    if distance <= 750 then
        return COLOR_CLOSE
    elseif distance <= 1875 then
        return COLOR_MID
    else
        return COLOR_FAR
    end
end

function GetTeamColor(player)
    if not player then return COLORS.NORMAL end

    if player.Team then
        return player.TeamColor.Color
    end

    return COLORS.NORMAL
end

TrackerHeaderLabel, TrackerNameLabel, TrackerDistanceLabel, TrackerHealthLabel, TrackerEquippedLabel = nil, nil, nil, nil, nil

function CreateClosestPlayerTracker()

    ClosestPlayerTrackerLabel = Instance.new("CanvasGroup")
    ClosestPlayerTrackerLabel.Name = "ClosestPlayerTracker"
    ClosestPlayerTrackerLabel.Size = UDim2.fromOffset(220, 70)
    local OriginalSize = ClosestPlayerTrackerLabel.Size
    ClosestPlayerTrackerLabel.Position = UDim2.new(0.5, 0, 0, 0)
    ClosestPlayerTrackerLabel.AnchorPoint = Vector2.new(0.5, 0)

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(180, 30)
    sizeConstraint.MaxSize = Vector2.new(450, 250)
    sizeConstraint.Parent = ClosestPlayerTrackerLabel

    ClosestPlayerTrackerLabel.BackgroundTransparency = 0.5
    ClosestPlayerTrackerLabel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    ClosestPlayerTrackerLabel.BorderSizePixel = 0
    EnsureScreenGui()
    ClosestPlayerTrackerLabel.Parent = ScreenGui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = ClosestPlayerTrackerLabel

    local stroke = Instance.new("UIStroke")
    stroke.Color = COLORS.CLOSEST
    stroke.Thickness = 2
    stroke.Transparency = 0.5
    stroke.Parent = ClosestPlayerTrackerLabel
    TrackerStrokeRef = stroke

    local textContainer = Instance.new("Frame")
    textContainer.Name = "TextContainer"
    textContainer.Size = UDim2.new(1, -30, 1, 0)
    textContainer.Position = UDim2.fromOffset(0, 0)
    textContainer.BackgroundTransparency = 1
    textContainer.Parent = ClosestPlayerTrackerLabel

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 2)
    layout.Parent = textContainer

    TrackerHeaderLabel = Instance.new("TextLabel")
    TrackerHeaderLabel.Name = "HeaderLabel"
    TrackerHeaderLabel.Size = UDim2.new(1, 0, 0, 18)
    TrackerHeaderLabel.BackgroundTransparency = 1
    TrackerHeaderLabel.TextColor3 = COLORS.CLOSEST
    TrackerHeaderLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TrackerHeaderLabel.TextSize = 14
    TrackerHeaderLabel.Text = "Closest Player"
    TrackerHeaderLabel.LayoutOrder = 1
    TrackerHeaderLabel.Parent = textContainer

    TrackerNameLabel = Instance.new("TextLabel")
    TrackerNameLabel.Name = "NameLabel"
    TrackerNameLabel.Size = UDim2.new(1, 0, 0, 18)
    TrackerNameLabel.BackgroundTransparency = 1
    TrackerNameLabel.TextColor3 = COLORS.NORMAL
    TrackerNameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TrackerNameLabel.TextSize = 14
    TrackerNameLabel.Text = "Searching..."
    TrackerNameLabel.LayoutOrder = 2
    TrackerNameLabel.Parent = textContainer

    TrackerDistanceLabel = Instance.new("TextLabel")
    TrackerDistanceLabel.Name = "DistanceLabel"
    TrackerDistanceLabel.Size = UDim2.new(1, 0, 0, 18)
    TrackerDistanceLabel.BackgroundTransparency = 1
    TrackerDistanceLabel.TextColor3 = COLORS.CLOSEST
    TrackerDistanceLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TrackerDistanceLabel.TextSize = 14
    TrackerDistanceLabel.Text = ""
    TrackerDistanceLabel.LayoutOrder = 3
    TrackerDistanceLabel.Parent = textContainer

    TrackerHealthLabel = Instance.new("TextLabel")
    TrackerHealthLabel.Name = "HealthLabel"
    TrackerHealthLabel.Size = UDim2.new(1, 0, 0, 18)
    TrackerHealthLabel.BackgroundTransparency = 1
    TrackerHealthLabel.TextColor3 = COLORS.NORMAL
    TrackerHealthLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TrackerHealthLabel.TextSize = 14
    TrackerHealthLabel.Text = ""
    TrackerHealthLabel.LayoutOrder = 4
    TrackerHealthLabel.Parent = textContainer

    TrackerEquippedLabel = Instance.new("TextLabel")
    TrackerEquippedLabel.Name = "EquippedLabel"
    TrackerEquippedLabel.Size = UDim2.new(1, 0, 0, 18)
    TrackerEquippedLabel.BackgroundTransparency = 1
    TrackerEquippedLabel.TextColor3 = COLORS.NORMAL
    TrackerEquippedLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    TrackerEquippedLabel.TextSize = 14
    TrackerEquippedLabel.Text = ""
    TrackerEquippedLabel.LayoutOrder = 5
    TrackerEquippedLabel.Parent = textContainer

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeBtn"
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 30, 40)
    minimizeBtn.BackgroundTransparency = 0.3
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Size = UDim2.fromOffset(20, 20)
    minimizeBtn.Position = UDim2.new(1, -25, 0, 5)
    minimizeBtn.Text = "−"
    minimizeBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    minimizeBtn.TextSize = 14
    minimizeBtn.TextColor3 = COLORS.CLOSEST
    minimizeBtn.Parent = ClosestPlayerTrackerLabel

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 4)
    btnCorner.Parent = minimizeBtn

    TrackConnection(minimizeBtn.MouseButton1Click:Connect(function()
        TrackerMinimized = not TrackerMinimized
        if TrackerMinimized then
            sizeConstraint.Parent = nil
            TweenService:Create(ClosestPlayerTrackerLabel, TWEENS.SMOOTH, {Size = UDim2.fromOffset(220, 30)}):Play()
            TrackerNameLabel.Visible = false
            TrackerDistanceLabel.Visible = false
            if TrackerHealthLabel then TrackerHealthLabel.Visible = false end
            if TrackerEquippedLabel then TrackerEquippedLabel.Visible = false end
            minimizeBtn.Text = "+"
        else
            sizeConstraint.Parent = ClosestPlayerTrackerLabel
            minimizeBtn.Text = "−"
            UpdateClosestPlayerTracker()
        end
    end))

    if UI.MakeDraggable then
        UI.MakeDraggable(ClosestPlayerTrackerLabel)
    end
    pcall(UpdateScreenUIOpacity)
end

function UpdateNearestPlayer()
    local myChar = LocalPlayer.Character
    if not myChar then
        NearestPlayerRef = nil
        return
    end

    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then
        NearestPlayerRef = nil
        return
    end

    local myRootPos = myRoot.Position
    local best, bestDist = nil, nil
    local isLocalDNR = DNR(LocalPlayer)

    for _, player in ipairs(GetPlayersCache()) do
        if player ~= LocalPlayer and player.Parent then
            if not isLocalDNR and DNR(player) then
                continue
            end
            local character, rootPart = GetCharacter(player)
            if character and rootPart then
                local dist = (rootPart.Position - myRootPos).Magnitude
                if not bestDist or dist < bestDist then
                    bestDist = dist
                    best = player
                end
            end
        end
    end

    NearestPlayerRef = best
end

function UpdateClosestPlayerTracker()
    if not Flags["LocalUI/ClosestPlayerTracker"] or not ClosestPlayerTrackerLabel then
        if ClosestPlayerTrackerLabel then
            ClosestPlayerTrackerLabel.Visible = false
        end
        return
    end

    ClosestPlayerTrackerLabel.Visible = true

    if not TrackerMinimized then
        local showDisplay = Flags["LocalUI/ClosestPlayer/ShowDisplayName"]
        local showUser = Flags["LocalUI/ClosestPlayer/ShowUsername"]
        local showDistance = Flags["LocalUI/ClosestPlayer/ShowDistance"]
        local showHealth = Flags["LocalUI/ClosestPlayer/ShowHealth"]
        local showEquipped = Flags["LocalUI/ClosestPlayer/ShowEquipped"]

        local hasPlayer = false
        local distance = 0
        local distColor = COLORS.CLOSEST

        if NearestPlayerRef and NearestPlayerRef.Parent then
            local myChar = LocalPlayer.Character
            local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
            local targetChar = NearestPlayerRef.Character
            local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

            if myRoot and targetRoot then
                hasPlayer = true
                distance = (targetRoot.Position - myRoot.Position).Magnitude
                distColor = GetDistanceColor(distance, false)

                if TrackerStrokeRef then
                    TrackerStrokeRef.Color = distColor
                end

                local displayName = NearestPlayerRef.DisplayName or NearestPlayerRef.Name
                local username = NearestPlayerRef.Name
                local nameText = ""
                if showDisplay and showUser then
                    nameText = displayName .. " (@" .. username .. ")"
                elseif showDisplay then
                    nameText = displayName
                elseif showUser then
                    nameText = "@" .. username
                end

                if TrackerNameLabel then
                    TrackerNameLabel.Text = nameText
                    TrackerNameLabel.TextColor3 = GetTeamColor(NearestPlayerRef)
                end

                local distRounded = floor(distance + 0.5)
                if TrackerDistanceLabel then
                    TrackerDistanceLabel.Text = string.format("%d studs away", distRounded)
                    TrackerDistanceLabel.TextColor3 = distColor
                end
                CurrentTargetDistance = distRounded

                if TrackerHealthLabel then
                    local health, maxHealth = GetHealth(NearestPlayerRef)
                    TrackerHealthLabel.Text = string.format("HP: %d/%d", floor(health), floor(maxHealth))
                    TrackerHealthLabel.TextColor3 = GetHealthColor(health, maxHealth)
                end

                if TrackerEquippedLabel then
                    local equippedTool = targetChar and targetChar:FindFirstChildOfClass("Tool")
                    local toolName = equippedTool and equippedTool.Name or "Unarmed"
                    TrackerEquippedLabel.Text = "[" .. toolName .. "]"
                    TrackerEquippedLabel.TextColor3 = COLORS.NORMAL
                end
            else
                if TrackerNameLabel then
                    TrackerNameLabel.Text = "---"
                    TrackerNameLabel.TextColor3 = COLORS.NORMAL
                end
            end
        else
            if TrackerNameLabel then
                TrackerNameLabel.Text = "No players nearby"
                TrackerNameLabel.TextColor3 = COLORS.NORMAL
            end
            NearestPlayerRef = nil
        end

        local visibleCount = 1
        local maxTextWidth = 100

        if TrackerHeaderLabel and TrackerHeaderLabel.Text ~= "" then
            local headerSize = TextService:GetTextSize(TrackerHeaderLabel.Text, 14, Enum.Font.Montserrat, Vector2.new(1000, 18))
            maxTextWidth = math.max(maxTextWidth, headerSize.X)
        end

        local showNameLabel = hasPlayer and (showDisplay or showUser)
        if not hasPlayer then
            showNameLabel = true
        end

        if TrackerNameLabel then
            TrackerNameLabel.Visible = showNameLabel
            if showNameLabel and TrackerNameLabel.Text ~= "" then
                local nameSize = TextService:GetTextSize(TrackerNameLabel.Text, 14, Enum.Font.Montserrat, Vector2.new(1000, 18))
                maxTextWidth = math.max(maxTextWidth, nameSize.X)
            end
        end
        if TrackerDistanceLabel then
            local showDistanceLabel = hasPlayer and showDistance
            TrackerDistanceLabel.Visible = showDistanceLabel
            if showDistanceLabel and TrackerDistanceLabel.Text ~= "" then
                local distanceSize = TextService:GetTextSize(TrackerDistanceLabel.Text, 14, Enum.Font.Montserrat, Vector2.new(1000, 18))
                maxTextWidth = math.max(maxTextWidth, distanceSize.X)
            end
        end
        if TrackerHealthLabel then
            local showHealthLabel = hasPlayer and showHealth
            TrackerHealthLabel.Visible = showHealthLabel
            if showHealthLabel and TrackerHealthLabel.Text ~= "" then
                local healthSize = TextService:GetTextSize(TrackerHealthLabel.Text, 14, Enum.Font.Montserrat, Vector2.new(1000, 18))
                maxTextWidth = math.max(maxTextWidth, healthSize.X)
            end
        end
        if TrackerEquippedLabel then
            local showEquippedLabel = hasPlayer and showEquipped
            TrackerEquippedLabel.Visible = showEquippedLabel
            if showEquippedLabel and TrackerEquippedLabel.Text ~= "" then
                local equippedSize = TextService:GetTextSize(TrackerEquippedLabel.Text, 14, Enum.Font.Montserrat, Vector2.new(1000, 18))
                maxTextWidth = math.max(maxTextWidth, equippedSize.X)
            end
        end

        if showNameLabel then visibleCount = visibleCount + 1 end
        if hasPlayer and showDistance then visibleCount = visibleCount + 1 end
        if hasPlayer and showHealth then visibleCount = visibleCount + 1 end
        if hasPlayer and showEquipped then visibleCount = visibleCount + 1 end

        local targetHeight = 12 + (visibleCount * 18) + (math.max(0, visibleCount - 1) * 2)
        local targetWidth = math.clamp(maxTextWidth + 50, 180, 450)

        TweenService:Create(ClosestPlayerTrackerLabel, TWEENS.SMOOTH, {Size = UDim2.fromOffset(targetWidth, targetHeight)}):Play()
    end
end

function CreateItemPanel()
    if ItemPanelUI.MainFrame then return end

    local MainFrame = Instance.new("CanvasGroup")
    MainFrame.Name = "ItemPanel"
    MainFrame.Size = UDim2.fromOffset(500, 400)
    MainFrame.Position = UDim2.fromScale(0.5, 0.5)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = UI_THEME.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.Visible = false
    MainFrame.ClipsDescendants = true
    EnsureScreenGui()
    MainFrame.Parent = ScreenGui

    ApplyUIScale(MainFrame, Flags["Visuals/UIScale"] or 1)

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = MainFrame

    UI.MakeDraggable(MainFrame)

    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 35)
    header.BackgroundColor3 = UI_THEME.Sidebar
    header.BorderSizePixel = 0
    header.Parent = MainFrame

    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 8)
    headerCorner.Parent = header

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = UI_THEME.Sidebar
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -70, 1, 0)
    title.Position = UDim2.fromOffset(12, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎒 Item Panel"
    title.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.TextSize = 16
    title.TextColor3 = UI_THEME.Accent
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Size = UDim2.fromOffset(26, 26)
    closeBtn.Position = UDim2.new(1, -31, 0.5, -13)
    closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    closeBtn.BackgroundTransparency = 0.5
    closeBtn.Text = "X"
    closeBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = header

    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 4)
    closeBtnCorner.Parent = closeBtn

    TrackConnection(closeBtn.MouseButton1Click:Connect(function()
        ItemPanelState.Visible = false
        MainFrame.Visible = false
        Flags["Misc/ItemPanel"] = false
        local updater = UIState.Updaters["Misc/ItemPanel"]
        if updater then updater(false) end
    end))

    local ExplorerFrame = Instance.new("Frame")
    ExplorerFrame.Name = "ExplorerFrame"
    ExplorerFrame.Size = UDim2.new(0.5, -5, 1, -45)
    ExplorerFrame.Position = UDim2.fromOffset(5, 40)
    ExplorerFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ExplorerFrame.BorderSizePixel = 0
    ExplorerFrame.Parent = MainFrame
    local efCorner = Instance.new("UICorner"); efCorner.CornerRadius = UDim.new(0, 6); efCorner.Parent = ExplorerFrame

    local explorerContent = Instance.new("ScrollingFrame")
    explorerContent.Name = "ExplorerContent"
    explorerContent.Size = UDim2.new(1, -10, 1, -10)
    explorerContent.Position = UDim2.fromOffset(5, 5)
    explorerContent.BackgroundTransparency = 1
    explorerContent.BorderSizePixel = 0
    explorerContent.ScrollBarThickness = 4
    explorerContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    explorerContent.Parent = ExplorerFrame

    local explorerLayout = Instance.new("UIListLayout")
    explorerLayout.Padding = UDim.new(0, 2)
    explorerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    explorerLayout.Parent = explorerContent

    TrackConnection(explorerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        explorerContent.CanvasSize = UDim2.new(0, 0, 0, explorerLayout.AbsoluteContentSize.Y)
    end))

    local PropertyFrame = Instance.new("Frame")
    PropertyFrame.Name = "PropertyFrame"
    PropertyFrame.Size = UDim2.new(0.5, -5, 1, -45)
    PropertyFrame.Position = UDim2.new(0.5, 0, 0, 40)
    PropertyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    PropertyFrame.BorderSizePixel = 0
    PropertyFrame.Parent = MainFrame
    local pfCorner = Instance.new("UICorner"); pfCorner.CornerRadius = UDim.new(0, 6); pfCorner.Parent = PropertyFrame

    local pfHeader = Instance.new("Frame")
    pfHeader.Size = UDim2.new(1, 0, 0, 30)
    pfHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    pfHeader.Parent = PropertyFrame
    local pfhCorner = Instance.new("UICorner"); pfhCorner.CornerRadius = UDim.new(0, 6); pfhCorner.Parent = pfHeader

    local pfTitle = Instance.new("TextLabel")
    pfTitle.Size = UDim2.new(0.4, 0, 1, 0)
    pfTitle.Position = UDim2.fromOffset(10, 0)
    pfTitle.BackgroundTransparency = 1
    pfTitle.Text = "Properties"
    pfTitle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    pfTitle.TextSize = 12
    pfTitle.TextColor3 = UI_THEME.Accent
    pfTitle.TextXAlignment = Enum.TextXAlignment.Left
    pfTitle.Parent = pfHeader

    local pfSearch = Instance.new("TextBox")
    pfSearch.Size = UDim2.new(0.5, -5, 0.7, 0)
    pfSearch.Position = UDim2.new(1, -5, 0.5, 0)
    pfSearch.AnchorPoint = Vector2.new(1, 0.5)
    pfSearch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    pfSearch.Text = ""
    pfSearch.PlaceholderText = "Search..."
    pfSearch.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    pfSearch.TextSize = 11
    pfSearch.TextColor3 = UI_THEME.Text
    pfSearch.Parent = pfHeader
    local pfsCorner = Instance.new("UICorner"); pfsCorner.CornerRadius = UDim.new(0, 4); pfsCorner.Parent = pfSearch

    TrackConnection(pfSearch:GetPropertyChangedSignal("Text"):Connect(function()
        ItemPanelState.PropertySearchText = pfSearch.Text:lower()
        if ItemPanelState.selectedItem then
            local inst = ResolveItemPath(ItemPanelState.selectedItem)
            if inst then UpdateItemPropertyPane(inst) end
        end
    end))

    local propertyContent = Instance.new("ScrollingFrame")
    propertyContent.Name = "PropertyContent"
    propertyContent.Size = UDim2.new(1, -10, 1, -40)
    propertyContent.Position = UDim2.fromOffset(5, 35)
    propertyContent.BackgroundTransparency = 1
    propertyContent.BorderSizePixel = 0
    propertyContent.ScrollBarThickness = 4
    propertyContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    propertyContent.Parent = PropertyFrame

    local propertyLayout = Instance.new("UIListLayout")
    propertyLayout.Padding = UDim.new(0, 2)
    propertyLayout.SortOrder = Enum.SortOrder.LayoutOrder
    propertyLayout.Parent = propertyContent

    TrackConnection(propertyLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        propertyContent.CanvasSize = UDim2.new(0, 0, 0, propertyLayout.AbsoluteContentSize.Y)
    end))

    ItemPanelUI.MainFrame = MainFrame
    ItemPanelUI.ExplorerContent = explorerContent
    ItemPanelUI.PropertyContent = propertyContent
    ItemPanelUI.PropertyFrame = PropertyFrame
    ItemPanelUI.PropertySearch = pfSearch
    pcall(UpdateScreenUIOpacity)
end

local function ClearFrame(container)
    if not container then return end
    for _, child in ipairs(container:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
end

function UpdateActionButtonsState(player)
    if not player or not AdvancedPlayerPanelUI.Initialized then return end
    local wBtn = AdvancedPlayerPanelUI.WhitelistBtn
    local bBtn = AdvancedPlayerPanelUI.BlacklistBtn
    local pBtn = AdvancedPlayerPanelUI.PrioritizeBtn
    local specBtn = AdvancedPlayerPanelUI.SpectateBtn

    local isW = AdvancedPlayerPanelState.Whitelist[player.UserId]
    local isB = AdvancedPlayerPanelState.Blacklist[player.UserId]
    local isP = IsPlayerPrioritized(player)
    local isSpec = (AdvancedPlayerPanelState.Spectating == player)

    if wBtn then
        wBtn.Text = isW and "Unwhitelist" or "Whitelist"
        wBtn.TextColor3 = isW and UI_THEME.Accent or UI_THEME.Text
    end
    if bBtn then
        bBtn.Text = isB and "Unblacklist" or "Blacklist"
        bBtn.TextColor3 = isB and UI_THEME.Accent or UI_THEME.Text
    end
    if pBtn then
        pBtn.Text = isP and "Deprioritize" or "Prioritize"
        pBtn.TextColor3 = isP and UI_THEME.Accent or UI_THEME.Text
    end
    if specBtn then
        specBtn.Text = isSpec and "Stop Spec" or "Spectate"
        specBtn.BackgroundColor3 = isSpec and UI_THEME.Fail or UI_THEME.Element
    end
end

function UpdateSettingsPanelList()
    local container = AdvancedPlayerPanelUI.PriorityListContainer
    if not container then return end
    ClearFrame(container)

    local priorityList = AdvancedPlayerPanelState.PriorityList
    if #priorityList == 0 then
        local emptyLabel = Instance.new("TextLabel")
        emptyLabel.Size = UDim2.new(1, 0, 0, 30)
        emptyLabel.BackgroundTransparency = 1
        emptyLabel.Text = "Priority list is empty."
        emptyLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
        emptyLabel.TextSize = 12
        emptyLabel.TextColor3 = UI_THEME.TextDark
        emptyLabel.Parent = container
        return
    end

    for index, item in ipairs(priorityList) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 32)
        row.BackgroundColor3 = UI_THEME.Element
        row.BorderSizePixel = 0
        row.Parent = container
        local rCorner = Instance.new("UICorner"); rCorner.CornerRadius = UDim.new(0, 6); rCorner.Parent = row

        local typeIcon = item.type == "Player" and "👤" or "👥"
        local itemText = string.format("%d. %s  %s", index, typeIcon, item.value)

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -110, 1, 0)
        label.Position = UDim2.fromOffset(10, 0)
        label.BackgroundTransparency = 1
        label.Text = itemText
        label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        label.TextSize = 12
        label.TextColor3 = UI_THEME.Text
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local function createRowBtn(text, posX, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.fromOffset(24, 24)
            btn.Position = UDim2.new(1, posX, 0.5, -12)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            btn.Text = text
            btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            btn.TextSize = 11
            btn.TextColor3 = UI_THEME.Text
            btn.Parent = row
            local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 4); corner.Parent = btn
            TrackConnection(btn.MouseButton1Click:Connect(callback))
            return btn
        end

        if index > 1 then
            createRowBtn("▲", -85, function()
                local temp = priorityList[index]
                priorityList[index] = priorityList[index - 1]
                priorityList[index - 1] = temp
                UpdateSettingsPanelList()
            end)
        end

        if index < #priorityList then
            createRowBtn("▼", -55, function()
                local temp = priorityList[index]
                priorityList[index] = priorityList[index + 1]
                priorityList[index + 1] = temp
                UpdateSettingsPanelList()
            end)
        end

        createRowBtn("❌", -26, function()
            table.remove(priorityList, index)
            UpdateSettingsPanelList()
        end)
    end
end

function UpdateSettingsPanel()
    UpdateSettingsPanelList()
end

function SwitchToPlayerPageView(viewName)
    AdvancedPlayerPanelState.CurrentView = viewName
    if not AdvancedPlayerPanelUI.Initialized then return end

    local listFrame = AdvancedPlayerPanelUI.ListFrame
    local detailsFrame = AdvancedPlayerPanelUI.DetailsFrame
    local teamFrame = AdvancedPlayerPanelUI.TeamFrame
    local settingsFrame = AdvancedPlayerPanelUI.SettingsFrame
    local headerFrame = AdvancedPlayerPanelUI.HeaderFrame
    local actionHeader = AdvancedPlayerPanelUI.ActionsHeaderFrame
    local listBtn = AdvancedPlayerPanelUI.ListBtn
    local teamsBtn = AdvancedPlayerPanelUI.TeamsBtn
    local settingsBtn = AdvancedPlayerPanelUI.SettingsBtn

    if settingsBtn then
        settingsBtn.BackgroundColor3 = (viewName == "Settings") and UI_THEME.Accent or UI_THEME.Element
    end

    if viewName == "List" then
        if teamFrame then teamFrame.Visible = false end
        if detailsFrame then detailsFrame.Visible = false end
        if settingsFrame then settingsFrame.Visible = false end
        if listFrame then listFrame.Visible = true end
        if actionHeader then actionHeader.Visible = false end
        if listBtn then listBtn.Visible = true end
        if teamsBtn then teamsBtn.Visible = true end
        if headerFrame then headerFrame.Position = UDim2.fromOffset(0, 0) end
        if listFrame then
            listFrame.Position = UDim2.fromOffset(0, 35)
            listFrame.Size = UDim2.new(1, 0, 1, -35)
        end
    elseif viewName == "Teams" then
        if listFrame then listFrame.Visible = false end
        if detailsFrame then detailsFrame.Visible = false end
        if settingsFrame then settingsFrame.Visible = false end
        if teamFrame then
            teamFrame.Visible = true
            UpdateTeamPanelList()
        end
        if actionHeader then actionHeader.Visible = false end
        if listBtn then listBtn.Visible = true end
        if teamsBtn then teamsBtn.Visible = true end
        if headerFrame then headerFrame.Position = UDim2.fromOffset(0, 0) end
        if teamFrame then
            teamFrame.Position = UDim2.fromOffset(0, 35)
            teamFrame.Size = UDim2.new(1, 0, 1, -35)
        end
    elseif viewName == "Details" then
        if listFrame then listFrame.Visible = false end
        if teamFrame then teamFrame.Visible = false end
        if settingsFrame then settingsFrame.Visible = false end
        if detailsFrame then detailsFrame.Visible = true end
        if actionHeader then actionHeader.Visible = true end
        if listBtn then listBtn.Visible = false end
        if teamsBtn then teamsBtn.Visible = false end
        if headerFrame then headerFrame.Position = UDim2.fromOffset(0, 30) end
        if detailsFrame then
            detailsFrame.Position = UDim2.fromOffset(0, 65)
            detailsFrame.Size = UDim2.new(1, 0, 1, -65)
        end
        local selectedPlayer = AdvancedPlayerPanelState.SelectedPlayer
        if selectedPlayer then
            UpdateActionButtonsState(selectedPlayer)
        end
    elseif viewName == "Settings" then
        if listFrame then listFrame.Visible = false end
        if teamFrame then teamFrame.Visible = false end
        if detailsFrame then detailsFrame.Visible = false end
        if settingsFrame then
            settingsFrame.Visible = true
            UpdateSettingsPanel()
        end
        if actionHeader then actionHeader.Visible = false end
        if listBtn then listBtn.Visible = true end
        if teamsBtn then teamsBtn.Visible = true end
        if headerFrame then headerFrame.Position = UDim2.fromOffset(0, 0) end
        if settingsFrame then
            settingsFrame.Position = UDim2.fromOffset(0, 35)
            settingsFrame.Size = UDim2.new(1, 0, 1, -35)
        end
    end
end

function InitializePlayerPage(page)
    if AdvancedPlayerPanelUI.Initialized then return end
    AdvancedPlayerPanelUI.Initialized = true
    AdvancedPlayerPanelState.RowCache = {}
    AdvancedPlayerPanelState.PropertyRowCache = {}
    AdvancedPlayerPanelState.PlayerRowCache = {}

    local Wrapper = Instance.new("Frame")
    Wrapper.Name = "PlayerPageWrapper"
    Wrapper.Size = UDim2.new(1, 0, 0, 450)
    Wrapper.BackgroundTransparency = 1
    Wrapper.Parent = page

    local wrapperPadding = Instance.new("UIPadding")
    wrapperPadding.PaddingTop = UDim.new(0, 35)
    wrapperPadding.Parent = Wrapper

    local actionHeaderFrame = Instance.new("Frame")
    actionHeaderFrame.Name = "ActionsHeaderFrame"
    actionHeaderFrame.Size = UDim2.new(1, 0, 0, 30)
    actionHeaderFrame.Position = UDim2.fromOffset(0, 0)
    actionHeaderFrame.BackgroundTransparency = 1
    actionHeaderFrame.Visible = false
    actionHeaderFrame.Parent = Wrapper
    AdvancedPlayerPanelUI.ActionsHeaderFrame = actionHeaderFrame

    local actionLayout = Instance.new("UIListLayout")
    actionLayout.FillDirection = Enum.FillDirection.Horizontal
    actionLayout.Padding = UDim.new(0, 5)
    actionLayout.SortOrder = Enum.SortOrder.LayoutOrder
    actionLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    actionLayout.Parent = actionHeaderFrame

    local actionPadding = Instance.new("UIPadding")
    actionPadding.PaddingLeft = UDim.new(0, 10)
    actionPadding.Parent = actionHeaderFrame

    local function createMinBtn(text, parent)
        local btn = Instance.new("TextButton")
        btn.BackgroundColor3 = UI_THEME.Element
        btn.Text = text
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 11
        btn.TextColor3 = UI_THEME.Text
        btn.Parent = parent
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 4); corner.Parent = btn
        return btn
    end

    local wBtn = createMinBtn("Whitelist", actionHeaderFrame)
    wBtn.Size = UDim2.new(0.19, -4, 0, 24)
    AdvancedPlayerPanelUI.WhitelistBtn = wBtn

    local bBtn = createMinBtn("Blacklist", actionHeaderFrame)
    bBtn.Size = UDim2.new(0.19, -4, 0, 24)
    AdvancedPlayerPanelUI.BlacklistBtn = bBtn

    local pBtn = createMinBtn("Prioritize", actionHeaderFrame)
    pBtn.Size = UDim2.new(0.19, -4, 0, 24)
    AdvancedPlayerPanelUI.PrioritizeBtn = pBtn

    local tpBtn = createMinBtn("Teleport to", actionHeaderFrame)
    tpBtn.Size = UDim2.new(0.21, -4, 0, 24)
    AdvancedPlayerPanelUI.TeleportBtn = tpBtn

    local specBtn = createMinBtn("Spectate", actionHeaderFrame)
    specBtn.Size = UDim2.new(0.21, -4, 0, 24)
    AdvancedPlayerPanelUI.SpectateBtn = specBtn

    TrackConnection(wBtn.MouseButton1Click:Connect(function()
        local player = AdvancedPlayerPanelState.SelectedPlayer
        if player then
            ToggleWhitelist(player)
            UpdateActionButtonsState(player)
        end
    end))

    TrackConnection(bBtn.MouseButton1Click:Connect(function()
        local player = AdvancedPlayerPanelState.SelectedPlayer
        if player then
            ToggleBlacklist(player)
            UpdateActionButtonsState(player)
        end
    end))

    TrackConnection(pBtn.MouseButton1Click:Connect(function()
        local player = AdvancedPlayerPanelState.SelectedPlayer
        if player then
            TogglePlayerPriority(player)
            UpdateActionButtonsState(player)
        end
    end))

    TrackConnection(tpBtn.MouseButton1Click:Connect(function()
        local player = AdvancedPlayerPanelState.SelectedPlayer
        if player then
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Teleport-to-Player is disabled while Safe Mode is ON. Set SAFE_MODE = false at the top to enable it.")
                return
            end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart)
            local targetChar, targetRoot = GetCharacter(player)
            if myRoot and targetRoot then
                myRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, 3)
                UI.Notify("Player Explorer", "Teleported to " .. player.Name .. ".", 3)
            else
                UI.Notify("Player Explorer", "Failed to teleport: character root part not found.", 3)
            end
        end
    end))

    TrackConnection(specBtn.MouseButton1Click:Connect(function()
        local player = AdvancedPlayerPanelState.SelectedPlayer
        if player then
            local targetChar = player.Character
            local targetHum = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
            local targetRoot = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar.PrimaryPart)

            if AdvancedPlayerPanelState.Spectating == player then
                AdvancedPlayerPanelState.Spectating = nil
                local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if myHum then
                    Camera.CameraSubject = myHum
                end
                LocalPlayer.ReplicationFocus = nil
                pcall(function() GuiService:SetGameplayPausedNotificationEnabled(true) end)
                UI.Notify("Player Explorer", "Stopped spectating " .. player.Name .. ".", 3)
            else
                if targetHum then
                    AdvancedPlayerPanelState.Spectating = player
                    Camera.CameraSubject = targetHum
                    if targetRoot then
                        LocalPlayer.ReplicationFocus = targetRoot
                    end
                    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(false) end)
                    UI.Notify("Player Explorer", "Now spectating " .. player.Name .. ".", 3)
                else
                    UI.Notify("Player Explorer", "Failed to spectate: target humanoid not found.", 3)
                end
            end
            UpdateActionButtonsState(player)
        end
    end))

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 30)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = Wrapper
    AdvancedPlayerPanelUI.HeaderFrame = headerFrame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0, 140, 1, 0)
    title.BackgroundTransparency = 1
    title.Text = "Player Explorer"
    title.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.TextSize = 14
    title.TextColor3 = UI_THEME.Accent
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = headerFrame

    local listBtn = Instance.new("TextButton")
    listBtn.Size = UDim2.fromOffset(80, 24)
    listBtn.Position = UDim2.new(0, 150, 0.5, -12)
    listBtn.BackgroundColor3 = UI_THEME.Element
    listBtn.Text = "Players"
    listBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    listBtn.TextSize = 12
    listBtn.TextColor3 = UI_THEME.Text
    listBtn.Parent = headerFrame
    AdvancedPlayerPanelUI.ListBtn = listBtn
    local lbCorner = Instance.new("UICorner"); lbCorner.CornerRadius = UDim.new(0, 4); lbCorner.Parent = listBtn

    local teamsBtn = Instance.new("TextButton")
    teamsBtn.Size = UDim2.fromOffset(80, 24)
    teamsBtn.Position = UDim2.new(0, 240, 0.5, -12)
    teamsBtn.BackgroundColor3 = UI_THEME.Element
    teamsBtn.Text = "Teams"
    teamsBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    teamsBtn.TextSize = 12
    teamsBtn.TextColor3 = UI_THEME.Text
    teamsBtn.Parent = headerFrame
    AdvancedPlayerPanelUI.TeamsBtn = teamsBtn
    local tbCorner = Instance.new("UICorner"); tbCorner.CornerRadius = UDim.new(0, 4); tbCorner.Parent = teamsBtn

    local settingsBtn = Instance.new("TextButton")
    settingsBtn.Size = UDim2.fromOffset(28, 24)
    settingsBtn.Position = UDim2.new(0, 330, 0.5, -12)
    settingsBtn.BackgroundColor3 = UI_THEME.Element
    settingsBtn.Text = "⚙️"
    settingsBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    settingsBtn.TextSize = 14
    settingsBtn.TextColor3 = UI_THEME.Text
    settingsBtn.Parent = headerFrame
    AdvancedPlayerPanelUI.SettingsBtn = settingsBtn
    local sbCorner = Instance.new("UICorner"); sbCorner.CornerRadius = UDim.new(0, 4); sbCorner.Parent = settingsBtn

    TrackConnection(settingsBtn.MouseButton1Click:Connect(function()
        SwitchToPlayerPageView("Settings")
    end))

    local ListFrame = Instance.new("Frame")
    ListFrame.Name = "ListFrame"
    ListFrame.Size = UDim2.new(1, 0, 1, -35)
    ListFrame.Position = UDim2.fromOffset(0, 35)
    ListFrame.BackgroundTransparency = 1
    ListFrame.Visible = true
    ListFrame.Parent = Wrapper

    TrackConnection(listBtn.MouseButton1Click:Connect(function()
        SwitchToPlayerPageView("List")
    end))

    TrackConnection(teamsBtn.MouseButton1Click:Connect(function()
        SwitchToPlayerPageView("Teams")
    end))

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -20, 0, 30)
    searchBox.Position = UDim2.fromOffset(10, 10)
    searchBox.BackgroundColor3 = UI_THEME.Element
    searchBox.Text = ""
    searchBox.PlaceholderText = "Search players..."
    searchBox.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    searchBox.TextSize = 13
    searchBox.TextColor3 = UI_THEME.Text
    searchBox.PlaceholderColor3 = UI_THEME.TextDark
    searchBox.Parent = ListFrame
    local sbCorner = Instance.new("UICorner"); sbCorner.CornerRadius = UDim.new(0, 6); sbCorner.Parent = searchBox

    TrackConnection(searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if AdvancedPlayerPanelState.CurrentView == "List" and type(UpdateAdvancedPlayerList) == "function" then
            UpdateAdvancedPlayerList()
        end
    end))

    local tabFrame = Instance.new("Frame")
    tabFrame.Name = "TabFrame"
    tabFrame.Size = UDim2.new(1, -20, 0, 30)
    tabFrame.Position = UDim2.fromOffset(10, 45)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Parent = ListFrame

    local tabLayout = Instance.new("UIListLayout")
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Parent = tabFrame

    local function CreateTab(name, label)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "_Tab"
        btn.Size = UDim2.new(0.33, -3, 1, 0)
        btn.BackgroundColor3 = (AdvancedPlayerPanelState.ListTab == name) and UI_THEME.Accent or UI_THEME.Element
        btn.Text = label
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 12
        btn.TextColor3 = UI_THEME.Text
        btn.Parent = tabFrame
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = btn

        TrackConnection(btn.MouseButton1Click:Connect(function()
            AdvancedPlayerPanelState.ListTab = name
            for tabName, tabBtn in pairs(AdvancedPlayerPanelUI.TabButtons) do
                tabBtn.BackgroundColor3 = (tabName == name) and UI_THEME.Accent or UI_THEME.Element
            end
            UpdateAdvancedPlayerList()
        end))
        AdvancedPlayerPanelUI.TabButtons[name] = btn
    end

    CreateTab("All", "All")
    CreateTab("Whitelisted", "Whitelisted (☮️)")
    CreateTab("Blacklisted", "Blacklisted (☠️)")

    local listContent = Instance.new("ScrollingFrame")
    listContent.Name = "ListContent"
    listContent.Size = UDim2.new(1, -10, 1, -85)
    listContent.Position = UDim2.fromOffset(5, 80)
    listContent.BackgroundTransparency = 1
    listContent.BorderSizePixel = 0
    listContent.ScrollBarThickness = 4
    listContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    listContent.Parent = ListFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 4)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = listContent

    TrackConnection(listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        listContent.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
    end))

    local DetailsFrame = Instance.new("Frame")
    DetailsFrame.Name = "DetailsFrame"
    DetailsFrame.Size = UDim2.new(1, 0, 1, -35)
    DetailsFrame.Position = UDim2.fromOffset(0, 35)
    DetailsFrame.BackgroundTransparency = 1
    DetailsFrame.Visible = false
    DetailsFrame.Parent = Wrapper

    local backBtn = Instance.new("TextButton")
    backBtn.Name = "BackBtn"
    backBtn.Size = UDim2.fromOffset(70, 26)
    backBtn.Position = UDim2.fromOffset(10, 10)
    backBtn.BackgroundColor3 = UI_THEME.Element
    backBtn.Text = "← Back"
    backBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    backBtn.TextSize = 12
    backBtn.TextColor3 = UI_THEME.Text
    backBtn.Parent = DetailsFrame
    local bbCorner = Instance.new("UICorner"); bbCorner.CornerRadius = UDim.new(0, 4); bbCorner.Parent = backBtn

    TrackConnection(backBtn.MouseButton1Click:Connect(function()
        SwitchToPlayerPageView("List")
    end))

    local detailsTabFrame = Instance.new("Frame")
    detailsTabFrame.Name = "DetailsTabFrame"
    detailsTabFrame.Size = UDim2.new(1, -90, 0, 26)
    detailsTabFrame.Position = UDim2.fromOffset(85, 10)
    detailsTabFrame.BackgroundTransparency = 1
    detailsTabFrame.Parent = DetailsFrame

    local detailsTabLayout = Instance.new("UIListLayout")
    detailsTabLayout.FillDirection = Enum.FillDirection.Horizontal
    detailsTabLayout.Padding = UDim.new(0, 5)
    detailsTabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    detailsTabLayout.Parent = detailsTabFrame

    local function CreateDetailsTab(name, label)
        local btn = Instance.new("TextButton")
        btn.Name = name .. "_DetailsTab"
        btn.Size = UDim2.new(0.33, -3, 1, 0)
        btn.BackgroundColor3 = (AdvancedPlayerPanelState.DetailsTab == name) and UI_THEME.Accent or UI_THEME.Element
        btn.Text = label
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 12
        btn.TextColor3 = UI_THEME.Text
        btn.Parent = detailsTabFrame
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = btn

        TrackConnection(btn.MouseButton1Click:Connect(function()
            AdvancedPlayerPanelState.DetailsTab = name
            for tabName, tabBtn in pairs(AdvancedPlayerPanelUI.DetailsTabButtons) do
                tabBtn.BackgroundColor3 = (tabName == name) and UI_THEME.Accent or UI_THEME.Element
            end
            if AdvancedPlayerPanelUI.ExplorerContent then
                AdvancedPlayerPanelUI.ExplorerContent.Visible = (name == "Workspace")
                AdvancedPlayerPanelUI.DetailsContent.Visible = (name ~= "Workspace")
            end
            AdvancedPlayerPanelState.RowCache = {}
            if AdvancedPlayerPanelState.SelectedPlayer then
                ShowAdvancedPlayerDetails(AdvancedPlayerPanelState.SelectedPlayer)
            end
        end))
        AdvancedPlayerPanelUI.DetailsTabButtons[name] = btn
    end

    CreateDetailsTab("General", "General")
    CreateDetailsTab("Player", "Player")
    CreateDetailsTab("Workspace", "Workspace")

    local detailsContent = Instance.new("ScrollingFrame")
    detailsContent.Name = "DetailsContent"
    detailsContent.Size = UDim2.new(1, -10, 1, -186)
    detailsContent.Position = UDim2.fromOffset(5, 46)
    detailsContent.BackgroundTransparency = 1
    detailsContent.BorderSizePixel = 0
    detailsContent.ScrollBarThickness = 4
    detailsContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    detailsContent.Parent = DetailsFrame

    local detailsLayout = Instance.new("UIListLayout")
    detailsLayout.Padding = UDim.new(0, 0)
    detailsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    detailsLayout.Parent = detailsContent

    TrackConnection(detailsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        detailsContent.CanvasSize = UDim2.new(0, 0, 0, detailsLayout.AbsoluteContentSize.Y)
    end))

    local detailsPadding = Instance.new("UIPadding")
    detailsPadding.PaddingLeft = UDim.new(0, 10)
    detailsPadding.PaddingRight = UDim.new(0, 10)
    detailsPadding.Parent = detailsContent

    local explorerContent = Instance.new("ScrollingFrame")
    explorerContent.Name = "ExplorerContent"
    explorerContent.Size = UDim2.new(1, -10, 1, -186)
    explorerContent.Position = UDim2.fromOffset(5, 46)
    explorerContent.BackgroundTransparency = 1
    explorerContent.BorderSizePixel = 0
    explorerContent.ScrollBarThickness = 4
    explorerContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    explorerContent.Visible = false
    explorerContent.Parent = DetailsFrame

    local expLayout = Instance.new("UIListLayout")
    expLayout.Padding = UDim.new(0, 0)
    expLayout.SortOrder = Enum.SortOrder.LayoutOrder
    expLayout.Parent = explorerContent
    TrackConnection(expLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        explorerContent.CanvasSize = UDim2.new(0, 0, 0, expLayout.AbsoluteContentSize.Y)
    end))

    local propertyFrame = Instance.new("Frame")
    propertyFrame.Name = "PropertyFrame"
    propertyFrame.Size = UDim2.new(1, -10, 0, 140)
    propertyFrame.Position = UDim2.new(0, 5, 1, -145)
    propertyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    propertyFrame.Visible = false
    propertyFrame.Parent = DetailsFrame
    local pfCorner = Instance.new("UICorner"); pfCorner.CornerRadius = UDim.new(0, 6); pfCorner.Parent = propertyFrame

    local pfHeader = Instance.new("Frame")
    pfHeader.Size = UDim2.new(1, 0, 0, 24)
    pfHeader.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    pfHeader.Parent = propertyFrame
    local pfhCorner = Instance.new("UICorner"); pfhCorner.CornerRadius = UDim.new(0, 6); pfhCorner.Parent = pfHeader

    local pfTitle = Instance.new("TextLabel")
    pfTitle.Size = UDim2.new(0.4, 0, 1, 0)
    pfTitle.Position = UDim2.fromOffset(10, 0)
    pfTitle.BackgroundTransparency = 1
    pfTitle.Text = "Properties"
    pfTitle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    pfTitle.TextSize = 12
    pfTitle.TextColor3 = UI_THEME.Accent
    pfTitle.TextXAlignment = Enum.TextXAlignment.Left
    pfTitle.Parent = pfHeader

    local pfSearch = Instance.new("TextBox")
    pfSearch.Size = UDim2.new(0.5, 0, 0.8, 0)
    pfSearch.Position = UDim2.new(1, -5, 0.5, 0)
    pfSearch.AnchorPoint = Vector2.new(1, 0.5)
    pfSearch.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    pfSearch.Text = ""
    pfSearch.PlaceholderText = "Search properties..."
    pfSearch.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    pfSearch.TextSize = 11
    pfSearch.TextColor3 = UI_THEME.Text
    pfSearch.Parent = pfHeader
    local pfsCorner = Instance.new("UICorner"); pfsCorner.CornerRadius = UDim.new(0, 4); pfsCorner.Parent = pfSearch

    TrackConnection(pfSearch:GetPropertyChangedSignal("Text"):Connect(function()
        AdvancedPlayerPanelState.PropertySearchText = pfSearch.Text:lower()
        if AdvancedPlayerPanelState.ExplorerSelected then
            local inst = GetInstanceFromPath(AdvancedPlayerPanelState.ExplorerSelected)
            if inst then UpdatePropertyPane(inst) end
        end
    end))

    local propertyContent = Instance.new("ScrollingFrame")
    propertyContent.Size = UDim2.new(1, -10, 1, -30)
    propertyContent.Position = UDim2.fromOffset(5, 28)
    propertyContent.BackgroundTransparency = 1
    propertyContent.ScrollBarThickness = 4
    propertyContent.Parent = propertyFrame

    local pLayout = Instance.new("UIListLayout")
    pLayout.Padding = UDim.new(0, 2)
    pLayout.Parent = propertyContent
    TrackConnection(pLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        propertyContent.CanvasSize = UDim2.new(0, 0, 0, pLayout.AbsoluteContentSize.Y)
    end))

    AdvancedPlayerPanelUI.PropertyFrame = propertyFrame
    AdvancedPlayerPanelUI.PropertyContent = propertyContent
    AdvancedPlayerPanelUI.PropertySearch = pfSearch
    AdvancedPlayerPanelUI.ExplorerContent = explorerContent

    local TeamFrame = Instance.new("Frame")
    TeamFrame.Name = "TeamFrame"
    TeamFrame.Size = UDim2.new(1, 0, 1, -35)
    TeamFrame.Position = UDim2.fromOffset(0, 35)
    TeamFrame.BackgroundTransparency = 1
    TeamFrame.Visible = false
    TeamFrame.Parent = Wrapper

    local teamContent = Instance.new("ScrollingFrame")
    teamContent.Name = "TeamContent"
    teamContent.Size = UDim2.new(1, -10, 1, -46)
    teamContent.Position = UDim2.fromOffset(5, 46)
    teamContent.BackgroundTransparency = 1
    teamContent.BorderSizePixel = 0
    teamContent.ScrollBarThickness = 4
    teamContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    teamContent.Parent = TeamFrame

    local teamLayout = Instance.new("UIListLayout")
    teamLayout.Padding = UDim.new(0, 5)
    teamLayout.SortOrder = Enum.SortOrder.LayoutOrder
    teamLayout.Parent = teamContent

    TrackConnection(teamLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        teamContent.CanvasSize = UDim2.new(0, 0, 0, teamLayout.AbsoluteContentSize.Y)
    end))

    AdvancedPlayerPanelUI.ListFrame = ListFrame
    AdvancedPlayerPanelUI.DetailsFrame = DetailsFrame
    AdvancedPlayerPanelUI.TeamFrame = TeamFrame
    AdvancedPlayerPanelUI.ListContent = listContent
    AdvancedPlayerPanelUI.DetailsContent = detailsContent
    AdvancedPlayerPanelUI.TeamContent = teamContent
    AdvancedPlayerPanelUI.SearchBox = searchBox

    local SettingsFrame = Instance.new("Frame")
    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Size = UDim2.new(1, 0, 1, -35)
    SettingsFrame.Position = UDim2.fromOffset(0, 35)
    SettingsFrame.BackgroundTransparency = 1
    SettingsFrame.Visible = false
    SettingsFrame.Parent = Wrapper
    AdvancedPlayerPanelUI.SettingsFrame = SettingsFrame

    local settingsContent = Instance.new("ScrollingFrame")
    settingsContent.Name = "SettingsContent"
    settingsContent.Size = UDim2.new(1, -10, 1, -10)
    settingsContent.Position = UDim2.fromOffset(5, 5)
    settingsContent.BackgroundTransparency = 1
    settingsContent.BorderSizePixel = 0
    settingsContent.ScrollBarThickness = 4
    settingsContent.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
    settingsContent.Parent = SettingsFrame

    local settingsLayout = Instance.new("UIListLayout")
    settingsLayout.Padding = UDim.new(0, 8)
    settingsLayout.SortOrder = Enum.SortOrder.LayoutOrder
    settingsLayout.Parent = settingsContent

    TrackConnection(settingsLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        settingsContent.CanvasSize = UDim2.new(0, 0, 0, settingsLayout.AbsoluteContentSize.Y + 20)
    end))

    UI.CreateSection(settingsContent, "Targeting Rules for blacklisted (☠️) players")
    UI.CreateToggle(settingsContent, "Target Blacklisted Through Terrain", "Aim/TargetBlacklistedThroughTerrain", Flags["Aim/TargetBlacklistedThroughTerrain"])
    UI.CreateToggle(settingsContent, "Bypass Blacklist Priority If Occluded/Far", "Aim/BypassBlacklistPriorityIfOccludedOrFar", Flags["Aim/BypassBlacklistPriorityIfOccludedOrFar"])
    UI.CreateNumericInput(settingsContent, "Blacklist Bypass Distance", "Aim/BlacklistBypassDistance", Flags["Aim/BlacklistBypassDistance"], 0, 10000, 10, "studs")

    UI.CreateSection(settingsContent, "Target Prioritization (⭐) List")

    local addPanel = Instance.new("Frame")
    addPanel.Size = UDim2.new(1, 0, 0, 30)
    addPanel.BackgroundTransparency = 1
    addPanel.Parent = settingsContent

    local addInput = Instance.new("TextBox")
    addInput.Size = UDim2.new(0.5, -5, 1, 0)
    addInput.Position = UDim2.fromOffset(0, 0)
    addInput.BackgroundColor3 = UI_THEME.Element
    addInput.Text = ""
    addInput.PlaceholderText = "Player or Team name..."
    addInput.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    addInput.TextSize = 12
    addInput.TextColor3 = UI_THEME.Text
    addInput.PlaceholderColor3 = UI_THEME.TextDark
    addInput.Parent = addPanel
    local aiCorner = Instance.new("UICorner"); aiCorner.CornerRadius = UDim.new(0, 6); aiCorner.Parent = addInput

    local function createAddBtn(text, posX, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.24, -4, 1, 0)
        btn.Position = UDim2.new(posX, 2, 0, 0)
        btn.BackgroundColor3 = UI_THEME.Element
        btn.Text = text
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 11
        btn.TextColor3 = UI_THEME.Accent
        btn.Parent = addPanel
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = btn

        TrackConnection(btn.MouseButton1Click:Connect(callback))
        return btn
    end

    createAddBtn("+ Player", 0.5, function()
        local name = addInput.Text
        if name and #name > 0 then
            table.insert(AdvancedPlayerPanelState.PriorityList, {
                type = "Player",
                value = name
            })
            addInput.Text = ""
            UpdateSettingsPanelList()
        end
    end)

    createAddBtn("+ Team", 0.74, function()
        local name = addInput.Text
        if name and #name > 0 then
            table.insert(AdvancedPlayerPanelState.PriorityList, {
                type = "Team",
                value = name
            })
            addInput.Text = ""
            UpdateSettingsPanelList()
        end
    end)

    local listContainer = Instance.new("Frame")
    listContainer.Size = UDim2.new(1, 0, 0, 0)
    listContainer.BackgroundTransparency = 1
    listContainer.Parent = settingsContent
    AdvancedPlayerPanelUI.PriorityListContainer = listContainer

    local containerLayout = Instance.new("UIListLayout")
    containerLayout.Padding = UDim.new(0, 4)
    containerLayout.SortOrder = Enum.SortOrder.LayoutOrder
    containerLayout.Parent = listContainer

    TrackConnection(containerLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        listContainer.Size = UDim2.new(1, 0, 0, containerLayout.AbsoluteContentSize.Y)
    end))

    TrackThread(task.spawn(function()
        while task.wait(0.5) do
            if UIState.CurrentTab == "PlayerPage" and UIState.Visible then
                if AdvancedPlayerPanelState.CurrentView == "List" then
                    UpdateAdvancedPlayerList()
                elseif AdvancedPlayerPanelState.CurrentView == "Teams" then
                    UpdateTeamPanelList()
                elseif AdvancedPlayerPanelState.CurrentView == "Details" and AdvancedPlayerPanelState.SelectedPlayer then
                    if AdvancedPlayerPanelState.DetailsTab == "Workspace" then
                        local targetPlayer = AdvancedPlayerPanelState.SelectedPlayer
                        local targetChar = targetPlayer and targetPlayer.Character
                        local targetRoot = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar.PrimaryPart or targetChar:FindFirstChild("PrimaryPart"))
                        if targetRoot then
                            local char = targetChar
                            AdvancedPlayerPanelState.CurrentPaths = {}
                            ExplorerCounter = 0
                            VisualizeInstance(char, AdvancedPlayerPanelUI.ExplorerContent, 0)

                            for path, row in pairs(AdvancedPlayerPanelState.RowCache) do
                                if not AdvancedPlayerPanelState.CurrentPaths[path] then
                                    row:Destroy()
                                    AdvancedPlayerPanelState.RowCache[path] = nil
                                end
                            end

                            if AdvancedPlayerPanelState.ExplorerSelected then
                                local inst = GetInstanceFromPath(AdvancedPlayerPanelState.ExplorerSelected)
                                if inst then UpdatePropertyPane(inst) end
                            end
                        else
                            ClearFrame(AdvancedPlayerPanelUI.ExplorerContent)
                        end
                    end
                end
            end
        end
    end))

    TrackConnection(UIState.Tabs[#UIState.Tabs].Button:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
        if UIState.CurrentTab ~= "PlayerPage" and AdvancedPlayerPanelState.selectionHighlight then
            AdvancedPlayerPanelState.selectionHighlight:Destroy()
            AdvancedPlayerPanelState.selectionHighlight = nil
        end
    end))

    TrackConnection(page:GetPropertyChangedSignal("Visible"):Connect(function()
        if not page.Visible and AdvancedPlayerPanelState.selectionHighlight then
            AdvancedPlayerPanelState.selectionHighlight:Destroy()
            AdvancedPlayerPanelState.selectionHighlight = nil
        end
    end))
    SwitchToPlayerPageView("List")
end

function UpdateTeamPanelList()
    if not UIState.Visible or UIState.CurrentTab ~= "PlayerPage" then return end
    if AdvancedPlayerPanelState.CurrentView ~= "Teams" then return end

    local content = AdvancedPlayerPanelUI.TeamContent
    if not content then return end

    ClearFrame(content)

    local Teams = game:GetService("Teams")
    local teamList = Teams:GetTeams()

    for _, team in ipairs(teamList) do
        local teamName = team.Name
        local teamColor = team.TeamColor.Color
        local playersOnTeam = team:GetPlayers()
        local playerCount = #playersOnTeam

        local isWhitelisted = AdvancedPlayerPanelState.TeamWhitelist[teamName]
        local isBlacklisted = AdvancedPlayerPanelState.TeamBlacklist[teamName]
        local isExpanded = AdvancedPlayerPanelState.TeamExpanded[teamName]

        local row = Instance.new("Frame")
        row.Name = teamName .. "_Row"
        row.Size = UDim2.new(1, 0, 0, 40)
        row.BackgroundColor3 = isWhitelisted and UI_THEME.Success or (isBlacklisted and UI_THEME.Fail or UI_THEME.Element)
        row.Parent = content
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = row

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -160, 1, 0)
        nameLabel.Position = UDim2.fromOffset(10, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = string.format("%s [%d Players]", teamName, playerCount)
        nameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        nameLabel.TextSize = 14
        nameLabel.TextColor3 = teamColor
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = row

        local expandBtn = Instance.new("TextButton")
        expandBtn.Size = UDim2.fromOffset(25, 25)
        expandBtn.Position = UDim2.new(1, -35, 0.5, -12)
        expandBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        expandBtn.Text = isExpanded and "↓" or "→"
        expandBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        expandBtn.TextSize = 25
        expandBtn.TextColor3 = Color3.new(1, 1, 1)
        expandBtn.Parent = row
        local eCorner = Instance.new("UICorner"); eCorner.CornerRadius = UDim.new(0, 4); eCorner.Parent = expandBtn

        TrackConnection(expandBtn.MouseButton1Click:Connect(function()
            AdvancedPlayerPanelState.TeamExpanded[teamName] = not AdvancedPlayerPanelState.TeamExpanded[teamName]
            UpdateTeamPanelList()
        end))

        local wBtn = Instance.new("TextButton")
        wBtn.Size = UDim2.fromOffset(25, 25)
        wBtn.Position = UDim2.new(1, -65, 0.5, -12)
        wBtn.BackgroundColor3 = isWhitelisted and UI_THEME.Success or Color3.fromRGB(40, 40, 40)
        wBtn.Text = "☮️"
        wBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        wBtn.TextSize = 12
        wBtn.TextColor3 = Color3.new(1, 1, 1)
        wBtn.Parent = row
        local wCorner = Instance.new("UICorner"); wCorner.CornerRadius = UDim.new(0, 4); wCorner.Parent = wBtn

        TrackConnection(wBtn.MouseButton1Click:Connect(function()
            ToggleTeamWhitelist(teamName)
            UpdateTeamPanelList()
        end))

        local bBtn = Instance.new("TextButton")
        bBtn.Size = UDim2.fromOffset(25, 25)
        bBtn.Position = UDim2.new(1, -95, 0.5, -12)
        bBtn.BackgroundColor3 = isBlacklisted and UI_THEME.Fail or Color3.fromRGB(40, 40, 40)
        bBtn.Text = "☠️"
        bBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        bBtn.TextSize = 12
        bBtn.TextColor3 = Color3.new(1, 1, 1)
        bBtn.Parent = row
        local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 4); bCorner.Parent = bBtn

        TrackConnection(bBtn.MouseButton1Click:Connect(function()
            ToggleTeamBlacklist(teamName)
            UpdateTeamPanelList()
        end))

        local isTeamPrioritized = IsTeamPrioritized(teamName)
        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.fromOffset(25, 25)
        pBtn.Position = UDim2.new(1, -125, 0.5, -12)
        pBtn.BackgroundColor3 = isTeamPrioritized and UI_THEME.Accent or Color3.fromRGB(40, 40, 40)
        pBtn.Text = "⭐"
        pBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        pBtn.TextSize = 12
        pBtn.TextColor3 = Color3.new(1, 1, 1)
        pBtn.Parent = row
        local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 4); pCorner.Parent = pBtn

        TrackConnection(pBtn.MouseButton1Click:Connect(function()
            ToggleTeamPriority(teamName)
            UpdateTeamPanelList()
        end))

        if isExpanded then
            local isLocalDNR = DNR(LocalPlayer)
            for _, player in ipairs(playersOnTeam) do
                if not isLocalDNR and DNR(player) then
                    continue
                end
                local pId = player.UserId
                local pWhitelisted = AdvancedPlayerPanelState.Whitelist[pId]
                local pBlacklisted = AdvancedPlayerPanelState.Blacklist[pId]

                local pRow = Instance.new("Frame")
                pRow.Size = UDim2.new(1, -20, 0, 30)
                pRow.Position = UDim2.fromOffset(20, 0)
                pRow.BackgroundColor3 = pWhitelisted and UI_THEME.Success or (pBlacklisted and UI_THEME.Fail or Color3.fromRGB(35, 35, 35))
                pRow.Parent = content
                local pCorner = Instance.new("UICorner"); pCorner.CornerRadius = UDim.new(0, 4); pCorner.Parent = pRow

                local pLabel = Instance.new("TextLabel")
                pLabel.Size = UDim2.new(1, -95, 1, 0)
                pLabel.Position = UDim2.fromOffset(10, 0)
                pLabel.BackgroundTransparency = 1
                pLabel.Text = player.DisplayName or player.Name
                pLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                pLabel.TextSize = 12
                pLabel.TextColor3 = Color3.new(1, 1, 1)
                pLabel.TextXAlignment = Enum.TextXAlignment.Left
                pLabel.Parent = pRow

                local pwBtn = Instance.new("TextButton")
                pwBtn.Size = UDim2.fromOffset(20, 20)
                pwBtn.Position = UDim2.new(1, -25, 0.5, -10)
                pwBtn.BackgroundColor3 = pWhitelisted and UI_THEME.Success or Color3.fromRGB(45, 45, 45)
                pwBtn.Text = "☮️"
                pwBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                pwBtn.TextSize = 10
                pwBtn.TextColor3 = Color3.new(1, 1, 1)
                pwBtn.Parent = pRow
                local pwCorner = Instance.new("UICorner"); pwCorner.CornerRadius = UDim.new(0, 4); pwCorner.Parent = pwBtn

                TrackConnection(pwBtn.MouseButton1Click:Connect(function()
                    ToggleWhitelist(player)
                    UpdateTeamPanelList()
                end))

                local pbBtn = Instance.new("TextButton")
                pbBtn.Size = UDim2.fromOffset(20, 20)
                pbBtn.Position = UDim2.new(1, -50, 0.5, -10)
                pbBtn.BackgroundColor3 = pBlacklisted and UI_THEME.Fail or Color3.fromRGB(45, 45, 45)
                pbBtn.Text = "☠️"
                pbBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                pbBtn.TextSize = 10
                pbBtn.TextColor3 = Color3.new(1, 1, 1)
                pbBtn.Parent = pRow
                local pbCorner = Instance.new("UICorner"); pbCorner.CornerRadius = UDim.new(0, 4); pbCorner.Parent = pbBtn

                TrackConnection(pbBtn.MouseButton1Click:Connect(function()
                    ToggleBlacklist(player)
                    UpdateTeamPanelList()
                end))

                local ppBtn = Instance.new("TextButton")
                ppBtn.Size = UDim2.fromOffset(20, 20)
                ppBtn.Position = UDim2.new(1, -75, 0.5, -10)
                ppBtn.BackgroundColor3 = IsPlayerPrioritized(player) and UI_THEME.Accent or Color3.fromRGB(45, 45, 45)
                ppBtn.Text = "⭐"
                ppBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                ppBtn.TextSize = 10
                ppBtn.TextColor3 = Color3.new(1, 1, 1)
                ppBtn.Parent = pRow
                local ppCorner = Instance.new("UICorner"); ppCorner.CornerRadius = UDim.new(0, 4); ppCorner.Parent = ppBtn

                TrackConnection(ppBtn.MouseButton1Click:Connect(function()
                    TogglePlayerPriority(player)
                    UpdateTeamPanelList()
                end))
            end
        end
    end
end

function UpdateAdvancedPlayerList()
    if not AdvancedPlayerPanelUI.Initialized or not AdvancedPlayerPanelUI.SearchBox then return end
    if not UIState.Visible or UIState.CurrentTab ~= "PlayerPage" then return end
    if AdvancedPlayerPanelState.CurrentView ~= "List" then return end

    local players = Players:GetPlayers()
    local searchText = AdvancedPlayerPanelUI.SearchBox.Text:lower()

    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("PrimaryPart") or myChar:FindFirstChild("HumanoidRootPart"))
    local myPos = myRoot and myRoot.Position or Camera.CFrame.Position

    local isLocalDNR = DNR(LocalPlayer)

    local currentPlayersSet = {}
    for _, player in ipairs(players) do
        if not isLocalDNR and DNR(player) then
            continue
        end
        currentPlayersSet[player.UserId] = true
    end

    for _, player in ipairs(players) do
        if not isLocalDNR and DNR(player) then
            continue
        end
        local userId = player.UserId

        local nameMatch = string.find(string.lower(player.Name), searchText, 1, true)
        local displayNameMatch = string.find(string.lower(player.DisplayName or ""), searchText, 1, true)
        local isFiltered = false

        if searchText ~= "" and not nameMatch and not displayNameMatch then
            isFiltered = true
        end

        local pTeam = player.Team
        local teamName = pTeam and pTeam.Name

        local isIndivWhitelisted = AdvancedPlayerPanelState.Whitelist[userId]
        local isIndivBlacklisted = AdvancedPlayerPanelState.Blacklist[userId]
        local isTeamWhitelisted = teamName and AdvancedPlayerPanelState.TeamWhitelist[teamName]
        local isTeamBlacklisted = teamName and AdvancedPlayerPanelState.TeamBlacklist[teamName]

        local isWhitelisted = isIndivWhitelisted or (isTeamWhitelisted and not isIndivBlacklisted)
        local isBlacklisted = isIndivBlacklisted or (isTeamBlacklisted and not isIndivWhitelisted)

        local currentTab = AdvancedPlayerPanelState.ListTab
        if (currentTab == "Whitelisted" and not isWhitelisted) or (currentTab == "Blacklisted" and not isBlacklisted) then
            isFiltered = true
        end

        local entry = AdvancedPlayerPanelState.PlayerRowCache[userId]

        if isFiltered then
            if entry then
                entry.Frame.Visible = false
            end
            continue
        end

        local dist = 999999
        local distStr = "Loading..."
        local targetChar = player.Character
        local targetRoot = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar.PrimaryPart or targetChar:FindFirstChild("PrimaryPart"))
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart or myChar:FindFirstChild("PrimaryPart"))

        if targetRoot then
            if myRoot then
                dist = (myRoot.Position - targetRoot.Position).Magnitude
                distStr = math.floor(dist) .. "m"
            else
                distStr = "N/A"
            end
        else
            distStr = "N/A"
        end

        if not entry then
            entry = {}
            entry.PlayerObj = player

            local frame = Instance.new("Frame")
            frame.Name = player.Name .. "_Entry"
            frame.Size = UDim2.new(1, 0, 0, 75)
            frame.BackgroundColor3 = UI_THEME.Element
            frame.BorderSizePixel = 0
            frame.Parent = AdvancedPlayerPanelUI.ListContent
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 6)
            corner.Parent = frame

            local avatar = Instance.new("ImageLabel")
            avatar.Name = "Avatar"
            avatar.Size = UDim2.fromOffset(40, 40)
            avatar.Position = UDim2.fromOffset(5, 17)
            avatar.BackgroundColor3 = UI_THEME.Background
            avatar.BorderSizePixel = 0
            avatar.Parent = frame
            local aCorner = Instance.new("UICorner")
            aCorner.CornerRadius = UDim.new(1, 0)
            aCorner.Parent = avatar

            task.spawn(function()
                if player and player.Parent then
                    local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
                    if isReady and avatar and avatar.Parent then
                        avatar.Image = content
                    end
                end
            end)

            local nickname = player.DisplayName or player.Name
            local username = player.Name

            local function createCopyableLabel(parent, text, position, font, size, color)
                local container = Instance.new("Frame")
                container.Size = UDim2.new(1, -175, 0, 20)
                container.Position = position
                container.BackgroundTransparency = 1
                container.ZIndex = 3
                container.Parent = parent

                local layout = Instance.new("UIListLayout")
                layout.FillDirection = Enum.FillDirection.Horizontal
                layout.Padding = UDim.new(0, 5)
                layout.VerticalAlignment = Enum.VerticalAlignment.Center
                layout.SortOrder = Enum.SortOrder.LayoutOrder
                layout.Parent = container

                local lbl = Instance.new("TextLabel")
                lbl.AutomaticSize = Enum.AutomaticSize.X
                lbl.Size = UDim2.fromScale(0, 1)
                lbl.BackgroundTransparency = 1
                lbl.Text = text
                lbl.FontFace = font
                lbl.TextSize = size
                lbl.TextColor3 = color
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = container

                local copyBtn = Instance.new("TextButton")
                copyBtn.Text = "📋"
                copyBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                copyBtn.TextSize = 12
                copyBtn.TextColor3 = UI_THEME.Text
                copyBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                copyBtn.BackgroundTransparency = 0.3
                copyBtn.Size = UDim2.fromOffset(20, 20)
                copyBtn.ZIndex = 3
                copyBtn.Parent = container

                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 4)
                btnCorner.Parent = copyBtn

                TrackConnection(copyBtn.MouseButton1Click:Connect(function()
                    local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
                    if copy then
                        copy(lbl.Text)
                        UI.Notify("Player Explorer", "Copied to clipboard: " .. lbl.Text, 3)
                    end
                end))

                return lbl, copyBtn
            end

            local nicknameLbl, nicknameCopy = createCopyableLabel(frame, nickname, UDim2.fromOffset(55, 5), Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal), 14, UI_THEME.Text)
            local usernameLbl, usernameCopy = createCopyableLabel(frame, "@" .. username, UDim2.fromOffset(55, 25), Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal), 12, UI_THEME.TextDark)
            local userIdLbl, userIdCopy = createCopyableLabel(frame, tostring(player.UserId), UDim2.fromOffset(55, 45), Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal), 12, UI_THEME.TextDark)

            local distLbl = Instance.new("TextLabel")
            distLbl.Name = "Distance"
            distLbl.Size = UDim2.new(0, 60, 1, 0)
            distLbl.Position = UDim2.new(1, -65, 0, 0)
            distLbl.BackgroundTransparency = 1
            distLbl.Text = distStr
            distLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            distLbl.TextSize = 12
            distLbl.TextColor3 = UI_THEME.Accent
            distLbl.TextXAlignment = Enum.TextXAlignment.Right
            distLbl.Parent = frame

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundTransparency = 1
            btn.Text = ""
            btn.ZIndex = 1
            btn.Parent = frame

            TrackConnection(btn.MouseButton1Click:Connect(function()
                AdvancedPlayerPanelState.SelectedPlayer = player
                SwitchToPlayerPageView("Details")
                ShowAdvancedPlayerDetails(player)
            end))

            local wBtn = Instance.new("TextButton")
            wBtn.Name = "WBtn"
            wBtn.Size = UDim2.fromOffset(25, 25)
            wBtn.Position = UDim2.new(1, -100, 0.5, -12)
            wBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            wBtn.Text = "☮️"
            wBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            wBtn.TextSize = 12
            wBtn.TextColor3 = Color3.new(1, 1, 1)
            wBtn.ZIndex = 2
            wBtn.Parent = frame
            local wCorner = Instance.new("UICorner")
            wCorner.CornerRadius = UDim.new(0, 4)
            wCorner.Parent = wBtn

            TrackConnection(wBtn.MouseButton1Click:Connect(function()
                ToggleWhitelist(player)
                UpdateAdvancedPlayerList()
            end))

            local bBtn = Instance.new("TextButton")
            bBtn.Name = "BBtn"
            bBtn.Size = UDim2.fromOffset(25, 25)
            bBtn.Position = UDim2.new(1, -130, 0.5, -12)
            bBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            bBtn.Text = "☠️"
            bBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            bBtn.TextSize = 12
            bBtn.TextColor3 = Color3.new(1, 1, 1)
            bBtn.ZIndex = 2
            bBtn.Parent = frame
            local bCorner = Instance.new("UICorner")
            bCorner.CornerRadius = UDim.new(0, 4)
            bCorner.Parent = bBtn

            TrackConnection(bBtn.MouseButton1Click:Connect(function()
                ToggleBlacklist(player)
                UpdateAdvancedPlayerList()
            end))

            local pBtn = Instance.new("TextButton")
            pBtn.Name = "PBtn"
            pBtn.Size = UDim2.fromOffset(25, 25)
            pBtn.Position = UDim2.new(1, -160, 0.5, -12)
            pBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            pBtn.Text = "⭐"
            pBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            pBtn.TextSize = 12
            pBtn.TextColor3 = Color3.new(1, 1, 1)
            pBtn.ZIndex = 2
            pBtn.Parent = frame
            local pCorner = Instance.new("UICorner")
            pCorner.CornerRadius = UDim.new(0, 4)
            pCorner.Parent = pBtn

            TrackConnection(pBtn.MouseButton1Click:Connect(function()
                TogglePlayerPriority(player)
                UpdateAdvancedPlayerList()
            end))

            entry.Frame = frame
            entry.NicknameLabel = nicknameLbl
            entry.UsernameLabel = usernameLbl
            entry.UserIdLabel = userIdLbl
            entry.DistanceLabel = distLbl
            entry.WBtn = wBtn
            entry.BBtn = bBtn
            entry.PBtn = pBtn

            AdvancedPlayerPanelState.PlayerRowCache[userId] = entry
        else

            entry.Frame.Visible = true

            local nickname = player.DisplayName or player.Name
            local username = player.Name

            entry.NicknameLabel.Text = nickname
            entry.UsernameLabel.Text = "@" .. username
            entry.UserIdLabel.Text = tostring(userId)
            entry.DistanceLabel.Text = distStr
        end

        entry.Frame.LayoutOrder = math.floor(dist)
        if isWhitelisted then
            entry.Frame.BackgroundColor3 = UI_THEME.Success
        elseif isBlacklisted then
            entry.Frame.BackgroundColor3 = UI_THEME.Fail
        else
            entry.Frame.BackgroundColor3 = UI_THEME.Element
        end

        if entry.WBtn then
            entry.WBtn.BackgroundColor3 = isIndivWhitelisted and UI_THEME.Success or Color3.fromRGB(40, 40, 40)
        end
        if entry.BBtn then
            entry.BBtn.BackgroundColor3 = isIndivBlacklisted and UI_THEME.Fail or Color3.fromRGB(40, 40, 40)
        end
        if entry.PBtn then
            entry.PBtn.BackgroundColor3 = IsPlayerPrioritized(player) and UI_THEME.Accent or Color3.fromRGB(40, 40, 40)
        end
    end

    for userId, entry in pairs(AdvancedPlayerPanelState.PlayerRowCache) do
        if not currentPlayersSet[userId] then
            if entry.Frame then
                entry.Frame:Destroy()
            end
            AdvancedPlayerPanelState.PlayerRowCache[userId] = nil
        end
    end
end

local ExplorerCounter = 0
local function UpdateItemPropertyPane(instance)
    local content = ItemPanelUI.PropertyContent
    if not content then return end

    for _, child in ipairs(content:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end

    local searchText = ItemPanelState.PropertySearchText
    local path = GetItemUniquePath(instance)
    local lockedProps = ItemPanelState.lockedProperties[path] or {}

    local categories = {"Data", "Appearance", "Behavior", "Stats", "Transform"}

    for _, catName in ipairs(categories) do
        local catProps = PROPERTY_CATEGORIES[catName]
        local catHasAny = false

        for _, prop in ipairs(catProps) do
            if searchText == "" or prop:lower():find(searchText) then
                local success, val = pcall(function() return instance[prop] end)
                if success and val ~= nil then
                    catHasAny = true
                    break
                end
            end
        end

        if catHasAny then
            local catHeader = Instance.new("Frame")
            catHeader.Size = UDim2.new(1, 0, 0, 20)
            catHeader.BackgroundTransparency = 1
            catHeader.Parent = content

            local catLabel = Instance.new("TextLabel")
            catLabel.Size = UDim2.new(1, -10, 1, 0)
            catLabel.Position = UDim2.fromOffset(5, 0)
            catLabel.BackgroundTransparency = 1
            catLabel.Text = "v " .. catName
            catLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            catLabel.TextSize = 11
            catLabel.TextColor3 = UI_THEME.TextDark
            catLabel.TextXAlignment = Enum.TextXAlignment.Left
            catLabel.Parent = catHeader

            for _, prop in ipairs(catProps) do
                if searchText == "" or prop:lower():find(searchText) then
                    local success, val = pcall(function() return instance[prop] end)
                    if success and val ~= nil then
                        local isLocked = lockedProps[prop] ~= nil

                        local row = Instance.new("Frame")
                        row.Size = UDim2.new(1, 0, 0, 30)
                        row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                        row.BackgroundTransparency = 0.5
                        row.BorderSizePixel = 0
                        row.Parent = content

                        local lockBtn = Instance.new("TextButton")
                        lockBtn.Size = UDim2.new(0, 20, 0, 20)
                        lockBtn.Position = UDim2.new(0, 5, 0.5, -10)
                        lockBtn.BackgroundTransparency = 1
                        lockBtn.Text = isLocked and "🔒" or "🔓"
                        lockBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                        lockBtn.TextSize = 12
                        lockBtn.TextColor3 = isLocked and UI_THEME.Accent or UI_THEME.TextDark
                        lockBtn.Parent = row

                        TrackConnection(lockBtn.MouseButton1Click:Connect(function()
                            if not ItemPanelState.lockedProperties[path] then
                                ItemPanelState.lockedProperties[path] = {}
                            end
                            if ItemPanelState.lockedProperties[path][prop] ~= nil then
                                ItemPanelState.lockedProperties[path][prop] = nil
                                if not next(ItemPanelState.lockedProperties[path]) then
                                    ItemPanelState.lockedProperties[path] = nil
                                end
                                lockBtn.Text = "🔓"
                                lockBtn.TextColor3 = UI_THEME.TextDark
                            else
                                ItemPanelState.lockedProperties[path][prop] = instance[prop]
                                lockBtn.Text = "🔒"
                                lockBtn.TextColor3 = UI_THEME.Accent
                            end
                        end))

                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Size = UDim2.new(0.4, -30, 1, 0)
                        nameLabel.Position = UDim2.fromOffset(30, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = prop
                        nameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                        nameLabel.TextSize = 10
                        nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                        nameLabel.Parent = row

                        local valInput = Instance.new("TextBox")
                        valInput.Size = UDim2.new(0.6, -10, 0.8, 0)
                        valInput.Position = UDim2.new(0.4, 5, 0.1, 0)
                        valInput.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
                        valInput.Text = tostring(val)
                        valInput.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                        valInput.TextSize = 10
                        valInput.TextColor3 = Color3.new(1, 1, 1)
                        valInput.ClearTextOnFocus = false
                        valInput.Parent = row
                        local viCorner = Instance.new("UICorner"); viCorner.CornerRadius = UDim.new(0, 4); viCorner.Parent = valInput

                        TrackConnection(valInput.FocusLost:Connect(function()
                            local newVal = valInput.Text
                            local currentVal = instance[prop]
                            local typeName = typeof(currentVal)

                            local finalVal = nil
                            if typeName == "number" then
                                finalVal = tonumber(newVal)
                            elseif typeName == "boolean" then
                                finalVal = (newVal:lower() == "true")
                            elseif typeName == "string" then
                                finalVal = newVal
                            elseif typeName == "Vector3" then
                                local parts = string.split(newVal, ",")
                                if #parts == 3 then
                                    finalVal = Vector3.new(tonumber(parts[1]), tonumber(parts[2]), tonumber(parts[3]))
                                end
                            elseif typeName == "Color3" then
                                local parts = string.split(newVal, ",")
                                if #parts == 3 then
                                    finalVal = Color3.new(tonumber(parts[1])/255, tonumber(parts[2])/255, tonumber(parts[3])/255)
                                end
                            end

                            if finalVal ~= nil then
                                pcall(SafeSetProp, instance, prop, finalVal)
                                if ItemPanelState.lockedProperties[path] and ItemPanelState.lockedProperties[path][prop] ~= nil then
                                    ItemPanelState.lockedProperties[path][prop] = finalVal
                                end
                            end
                            valInput.Text = tostring(instance[prop])
                        end))
                    end
                end
            end
        end
    end
end

local function UpdatePropertyPane(instance)
    local content = AdvancedPlayerPanelUI.PropertyContent
    if not content then return end

    local currentPropRows = {}
    local searchText = AdvancedPlayerPanelState.PropertySearchText
    local categories = {"Data", "Appearance", "Behavior", "Stats", "Transform"}
    local orderCounter = 0

    for _, catName in ipairs(categories) do
        local catProps = PROPERTY_CATEGORIES[catName]
        local catHasAny = false

        for _, prop in ipairs(catProps) do
            if searchText == "" or prop:lower():find(searchText) then
                local success, val = pcall(function() return instance[prop] end)
                if success and val ~= nil then
                    catHasAny = true
                    break
                end
            end
        end

        if catHasAny then
            orderCounter = orderCounter + 1
            local catHeaderId = "Cat_" .. catName
            currentPropRows[catHeaderId] = true
            local catHeader = AdvancedPlayerPanelState.PropertyRowCache[catHeaderId]

            if not catHeader then
                catHeader = Instance.new("Frame")
                catHeader.Size = UDim2.new(1, 0, 0, 20)
                catHeader.BackgroundTransparency = 1
                catHeader.Parent = content
                AdvancedPlayerPanelState.PropertyRowCache[catHeaderId] = catHeader

                local catLabel = Instance.new("TextLabel")
                catLabel.Name = "CatLabel"
                catLabel.Size = UDim2.new(1, -10, 1, 0)
                catLabel.Position = UDim2.fromOffset(5, 0)
                catLabel.BackgroundTransparency = 1
                catLabel.Text = "v " .. catName
                catLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                catLabel.TextSize = 11
                catLabel.TextColor3 = UI_THEME.TextDark
                catLabel.TextXAlignment = Enum.TextXAlignment.Left
                catLabel.Parent = catHeader
            end
            catHeader.LayoutOrder = orderCounter

            for _, prop in ipairs(catProps) do
                if searchText == "" or prop:lower():find(searchText) then
                    local success, val = pcall(function() return instance[prop] end)
                    if success and val ~= nil then
                        orderCounter = orderCounter + 1
                        local propId = "Prop_" .. prop
                        currentPropRows[propId] = true

                        local row = AdvancedPlayerPanelState.PropertyRowCache[propId]
                        local valueLabel

                        if not row then
                            row = Instance.new("Frame")
                            row.Size = UDim2.new(1, 0, 0, 20)
                            row.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                            row.BackgroundTransparency = 0.5
                            row.BorderSizePixel = 0
                            row.Parent = content
                            AdvancedPlayerPanelState.PropertyRowCache[propId] = row

                            local nameLabel = Instance.new("TextLabel")
                            nameLabel.Size = UDim2.new(0.4, -10, 1, 0)
                            nameLabel.Position = UDim2.fromOffset(10, 0)
                            nameLabel.BackgroundTransparency = 1
                            nameLabel.Text = prop
                            nameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                            nameLabel.TextSize = 11
                            nameLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
                            nameLabel.Parent = row

                            valueLabel = Instance.new("TextLabel")
                            valueLabel.Name = "ValueLabel"
                            valueLabel.Size = UDim2.new(0.6, -10, 1, 0)
                            valueLabel.Position = UDim2.new(0.4, 5, 0, 0)
                            valueLabel.BackgroundTransparency = 1
                            valueLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                            valueLabel.TextSize = 11
                            valueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                            valueLabel.TextXAlignment = Enum.TextXAlignment.Left
                            valueLabel.Parent = row
                        else
                            valueLabel = row:FindFirstChild("ValueLabel")
                        end

                        row.LayoutOrder = orderCounter
                        valueLabel.Text = tostring(val)
                    end
                end
            end
        end
    end

    for id, row in pairs(AdvancedPlayerPanelState.PropertyRowCache) do
        if not currentPropRows[id] then
            row:Destroy()
            AdvancedPlayerPanelState.PropertyRowCache[id] = nil
        end
    end
end

local function VisualizeItemInstance(instance, content, depth)
    if depth > 10 then return end

    local success, children = pcall(function() return instance:GetChildren() end)
    if not success then return end
    table.sort(children, function(a, b) return a.Name < b.Name end)

    for _, child in ipairs(children) do
        pcall(function()
            local path = GetItemUniquePath(child)
            local isExpanded = ItemPanelState.explorerExpanded[path]
            local isSelected = ItemPanelState.explorerSelected == path
            local hasChildren = #child:GetChildren() > 0

            ItemPanelUI.ExplorerCounter = ItemPanelUI.ExplorerCounter + 1
            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 24)
            row.BackgroundColor3 = isSelected and UI_THEME.Accent or UI_THEME.Element
            row.BackgroundTransparency = isSelected and 0.5 or 1
            row.BorderSizePixel = 0
            row.LayoutOrder = ItemPanelUI.ExplorerCounter
            row.Parent = content

            local indent = depth * 12

            if hasChildren then
                local toggleBtn = Instance.new("TextButton")
                toggleBtn.Size = UDim2.new(0, 20, 1, 0)
                toggleBtn.Position = UDim2.fromOffset(indent, 0)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.Text = isExpanded and "▼" or "▶"
                toggleBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                toggleBtn.TextSize = 10
                toggleBtn.TextColor3 = UI_THEME.Accent
                toggleBtn.Parent = row

                TrackConnection(toggleBtn.MouseButton1Click:Connect(function()
                    ItemPanelState.explorerExpanded[path] = not ItemPanelState.explorerExpanded[path]
                    UpdateItemPanelUI()
                end))
            end

            local selectBtn = Instance.new("TextButton")
            selectBtn.Size = UDim2.new(1, -(indent + 25), 1, 0)
            selectBtn.Position = UDim2.fromOffset(indent + 20, 0)
            selectBtn.BackgroundTransparency = 1
            selectBtn.Text = child.Name .. " (" .. child.ClassName .. ")"
            selectBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            selectBtn.TextSize = 11
            selectBtn.TextColor3 = isSelected and Color3.new(1, 1, 1) or UI_THEME.Text
            selectBtn.TextXAlignment = Enum.TextXAlignment.Left
            selectBtn.Parent = row

            TrackConnection(selectBtn.MouseButton1Click:Connect(function()
                ItemPanelState.explorerSelected = (ItemPanelState.explorerSelected == path) and nil or path
                ItemPanelState.selectedItem = ItemPanelState.explorerSelected
                UpdateItemPanelUI()
                if ItemPanelState.explorerSelected then
                    UpdateItemPropertyPane(child)
                end
            end))

            if isExpanded then
                VisualizeItemInstance(child, content, depth + 1)
            end
        end)
    end
end

function UpdateItemPanelUI()
    if not ItemPanelUI.ExplorerContent then return end
    ItemPanelUI.ExplorerCounter = 0

    for _, child in ipairs(ItemPanelUI.ExplorerContent:GetChildren()) do
        if not child:IsA("UIListLayout") then child:Destroy() end
    end

    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character

    local function createSection(name)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 25)
        lbl.BackgroundTransparency = 1
        lbl.Text = "  " .. name:upper()
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        lbl.TextSize = 12
        lbl.TextColor3 = UI_THEME.Accent
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = ItemPanelUI.ExplorerCounter
        lbl.Parent = ItemPanelUI.ExplorerContent
        ItemPanelUI.ExplorerCounter = ItemPanelUI.ExplorerCounter + 1
    end

    if backpack then
        createSection("Backpack")
        for _, item in ipairs(backpack:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Accessory") then
                VisualizeItemInstance(item, ItemPanelUI.ExplorerContent, 0)
            end
        end
    end

    if character then
        createSection("Character")
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Tool") or item:IsA("Accessory") then
                VisualizeItemInstance(item, ItemPanelUI.ExplorerContent, 0)
            end
        end
    end
end

local function VisualizeInstance(instance, content, depth)
    if depth > 8 then return end

    local success, children = pcall(function() return instance:GetChildren() end)
    if not success then return end
    table.sort(children, function(a, b) return a.Name < b.Name end)

    local ignoreList = {PlayerGui = true, PlayerScripts = true, StarterGear = true}

    for _, child in ipairs(children) do
        pcall(function()
            if ignoreList[child.Name] then return end
            local path = GetUniquePath(child)
            if AdvancedPlayerPanelState.CurrentPaths then
                AdvancedPlayerPanelState.CurrentPaths[path] = true
            end

            local isExpanded = AdvancedPlayerPanelState.ExplorerExpanded[path]
            local isSelected = AdvancedPlayerPanelState.ExplorerSelected == path
            local hasChildren = #child:GetChildren() > 0

            ExplorerCounter = ExplorerCounter + 1

            local row = AdvancedPlayerPanelState.RowCache[path]
            local selectBtn, toggleBtn
            local indent = depth * 16

            if not row then
                row = Instance.new("Frame")
                row.Size = UDim2.new(1, 0, 0, 24)
                row.BorderSizePixel = 0
                row.Parent = content
                AdvancedPlayerPanelState.RowCache[path] = row

                toggleBtn = Instance.new("TextButton")
                toggleBtn.Name = "ToggleBtn"
                toggleBtn.Size = UDim2.new(0, 24, 1, 0)
                toggleBtn.BackgroundTransparency = 1
                toggleBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
                toggleBtn.TextSize = 25
                toggleBtn.TextColor3 = UI_THEME.Accent
                toggleBtn.Parent = row

                TrackConnection(toggleBtn.MouseButton1Click:Connect(function()
                    AdvancedPlayerPanelState.ExplorerExpanded[path] = not AdvancedPlayerPanelState.ExplorerExpanded[path]
                    local targetPlayer = AdvancedPlayerPanelState.SelectedPlayer
                    if targetPlayer then
                        if AdvancedPlayerPanelState.DetailsTab == "Player" then
                            ShowAdvancedPlayerDetails(targetPlayer)
                        elseif AdvancedPlayerPanelState.DetailsTab == "Workspace" then
                            if targetPlayer.Character then
                                AdvancedPlayerPanelState.CurrentPaths = {}
                                ExplorerCounter = 0
                                VisualizeInstance(targetPlayer.Character, AdvancedPlayerPanelUI.ExplorerContent, 0)
                                for p, r in pairs(AdvancedPlayerPanelState.RowCache) do
                                    if not AdvancedPlayerPanelState.CurrentPaths[p] then
                                        r:Destroy()
                                        AdvancedPlayerPanelState.RowCache[p] = nil
                                    end
                                end
                            end
                        end
                    end
                end))

                selectBtn = Instance.new("TextButton")
                selectBtn.Name = "SelectBtn"
                selectBtn.BackgroundTransparency = 1
                selectBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                selectBtn.TextSize = 12
                selectBtn.TextXAlignment = Enum.TextXAlignment.Left
                selectBtn.Parent = row

                TrackConnection(selectBtn.MouseButton1Click:Connect(function()
                    AdvancedPlayerPanelState.ExplorerSelected = (AdvancedPlayerPanelState.ExplorerSelected == path) and nil or path

                    if AdvancedPlayerPanelState.selectionHighlight then
                        AdvancedPlayerPanelState.selectionHighlight:Destroy()
                        AdvancedPlayerPanelState.selectionHighlight = nil
                    end

                    if AdvancedPlayerPanelState.ExplorerSelected then
                        local inst = GetInstanceFromPath(path)
                        if inst then
                            if inst:IsA("BasePart") or inst:IsA("Model") then
                                local hl = Instance.new("Highlight")
                                hl.OutlineColor = Color3.new(1, 1, 1)
                                hl.FillTransparency = 1
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Adornee = inst
                                hl.Parent = game.CoreGui
                                AdvancedPlayerPanelState.selectionHighlight = hl
                            end
                            UpdatePropertyPane(inst)
                        end
                    else
                        ClearFrame(AdvancedPlayerPanelUI.PropertyContent)
                    end

                    local targetPlayer = AdvancedPlayerPanelState.SelectedPlayer
                    if targetPlayer then
                        if AdvancedPlayerPanelState.DetailsTab == "Player" then
                            ShowAdvancedPlayerDetails(targetPlayer)
                        elseif AdvancedPlayerPanelState.DetailsTab == "Workspace" then
                            if targetPlayer.Character then
                                AdvancedPlayerPanelState.CurrentPaths = {}
                                ExplorerCounter = 0
                                VisualizeInstance(targetPlayer.Character, AdvancedPlayerPanelUI.ExplorerContent, 0)
                                for p, r in pairs(AdvancedPlayerPanelState.RowCache) do
                                    if not AdvancedPlayerPanelState.CurrentPaths[p] then
                                        r:Destroy()
                                        AdvancedPlayerPanelState.RowCache[p] = nil
                                    end
                                end
                            end
                        end
                    end
                end))
            else
                row.Parent = content
                toggleBtn = row:FindFirstChild("ToggleBtn")
                selectBtn = row:FindFirstChild("SelectBtn")
            end

            row.LayoutOrder = ExplorerCounter
            row.BackgroundColor3 = isSelected and UI_THEME.Accent or UI_THEME.Element
            row.BackgroundTransparency = isSelected and 0.5 or 1

            if hasChildren then
                toggleBtn.Visible = true
                toggleBtn.Position = UDim2.fromOffset(indent, 0)
                toggleBtn.Text = isExpanded and "↓" or "→"
            else
                toggleBtn.Visible = false
            end

            selectBtn.Position = UDim2.fromOffset(indent + 24, 0)
            selectBtn.Size = UDim2.new(1, -(indent + 25), 1, 0)
            selectBtn.Text = child.Name .. " (" .. child.ClassName .. ")"
            selectBtn.TextColor3 = isSelected and Color3.new(1, 1, 1) or UI_THEME.Text

            if isExpanded then
                VisualizeInstance(child, content, depth + 1)
            end
        end)
    end
end

function ShowAdvancedPlayerDetails(player)
    UpdateActionButtonsState(player)
    ExplorerCounter = 0
    local content = AdvancedPlayerPanelUI.DetailsContent
    local oldPos = content.CanvasPosition

    if AdvancedPlayerPanelState.DetailsTab == "Player" then
        AdvancedPlayerPanelState.RowCache = {}
    end

    ClearFrame(content)
    table.clear(AdvancedPlayerPanelUI.DetailLabels)

    local function createSection(name)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 25)
        lbl.BackgroundTransparency = 1
        lbl.Text = name:upper()
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        lbl.TextSize = 12
        lbl.TextColor3 = UI_THEME.Accent
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = content
    end

    local function createLabel(name, initialValue)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 20)
        frame.BackgroundTransparency = 1
        frame.Parent = content

        local n = Instance.new("TextLabel")
        n.Size = UDim2.new(0.4, 0, 1, 0)
        n.BackgroundTransparency = 1
        n.Text = name .. ":"
        n.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        n.TextSize = 13
        n.TextColor3 = UI_THEME.TextDark
        n.TextXAlignment = Enum.TextXAlignment.Left
        n.Parent = frame

        local v = Instance.new("TextLabel")
        v.Size = UDim2.new(0.6, 0, 1, 0)
        v.Position = UDim2.new(0.4, 0, 0, 0)
        v.BackgroundTransparency = 1
        v.Text = initialValue
        v.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        v.TextSize = 13
        v.TextColor3 = UI_THEME.Text
        v.TextXAlignment = Enum.TextXAlignment.Right
        v.Parent = frame

        AdvancedPlayerPanelUI.DetailLabels[name] = v
        return v
    end

    local function createButton(name, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = UI_THEME.Element
        btn.Text = name
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 13
        btn.TextColor3 = UI_THEME.Text
        btn.Parent = content
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = btn

        TrackConnection(btn.MouseButton1Click:Connect(callback))
        return btn
    end

    if AdvancedPlayerPanelState.DetailsTab == "General" then
        content.Size = UDim2.new(1, -10, 1, -46)
        if AdvancedPlayerPanelUI.PropertyFrame then AdvancedPlayerPanelUI.PropertyFrame.Visible = false end
        createSection("User Information")
    createLabel("Display Name", player.DisplayName)
    createLabel("Username", "@" .. player.Name)
    createLabel("User ID", tostring(player.UserId))

    local creationDate = "Unknown"
    pcall(function()
        local t = os.time() - (player.AccountAge * 86400)
        creationDate = os.date("%x", t)
    end)
    createLabel("Account Created", creationDate)
    createLabel("Mutual Friends", "N/A")
    createLabel("Is Friend", LocalPlayer:IsFriendsWith(player.UserId) and "Yes" or "No")

    createSection("In-Game Information")
    createLabel("Distance", "---")
    createLabel("Coordinates", "---")
    createLabel("Current Health", "---")
    createLabel("Held Item", "---")

    createSection("Proximity")
    createLabel("Nearest Player 1", "---")
    createLabel("Nearest Player 2", "---")
    createLabel("Nearest Player 3", "---")

    elseif AdvancedPlayerPanelState.DetailsTab == "Player" then
        content.Size = UDim2.new(1, -10, 1, -195)
        if AdvancedPlayerPanelUI.PropertyFrame then
            AdvancedPlayerPanelUI.PropertyFrame.Visible = true
            local sel = AdvancedPlayerPanelState.ExplorerSelected
            local inst = sel and GetInstanceFromPath(sel)
            if inst then UpdatePropertyPane(inst) else
                ClearFrame(AdvancedPlayerPanelUI.PropertyContent)
            end
        end
        VisualizeInstance(player, content, 0)
    elseif AdvancedPlayerPanelState.DetailsTab == "Workspace" then
        content.Size = UDim2.new(1, -10, 1, -195)
        if AdvancedPlayerPanelUI.PropertyFrame then
            AdvancedPlayerPanelUI.PropertyFrame.Visible = true
            local sel = AdvancedPlayerPanelState.ExplorerSelected
            local inst = sel and GetInstanceFromPath(sel)
            if inst then UpdatePropertyPane(inst) else
                ClearFrame(AdvancedPlayerPanelUI.PropertyContent)
            end
        end
        if player.Character then
            VisualizeInstance(player.Character, AdvancedPlayerPanelUI.ExplorerContent, 0)
        else
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, 0, 0, 30)
            lbl.BackgroundTransparency = 1
            lbl.Text = "Character not found in Workspace"
            lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            lbl.TextSize = 13
            lbl.TextColor3 = UI_THEME.TextDark
            lbl.Parent = AdvancedPlayerPanelUI.ExplorerContent
        end
    end

    task.defer(function()
        if content and content.Parent then
            content.CanvasPosition = oldPos
        end
    end)
end

function UpdateAdvancedPlayerDetails()
    local player = AdvancedPlayerPanelState.SelectedPlayer
    if not player or not player.Parent then return end
    if AdvancedPlayerPanelState.CurrentView ~= "Details" then return end

    UpdateActionButtonsState(player)

    if AdvancedPlayerPanelState.DetailsTab ~= "General" then return end

    local labels = AdvancedPlayerPanelUI.DetailLabels

    local myChar = LocalPlayer.Character
    local targetChar = player.Character

    local distStr = "Loading..."
    local coordsStr = "---"

    local targetRoot = targetChar and (targetChar:FindFirstChild("HumanoidRootPart") or targetChar.PrimaryPart or targetChar:FindFirstChild("PrimaryPart"))
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart or myChar:FindFirstChild("PrimaryPart"))

    if targetRoot then
        if myRoot then
            local dist = (targetRoot.Position - myRoot.Position).Magnitude
            distStr = math.floor(dist) .. "m"
        else
            distStr = "N/A"
        end
        local p = targetRoot.Position
        coordsStr = string.format("%d, %d, %d", math.floor(p.X), math.floor(p.Y), math.floor(p.Z))
    else
        distStr = "N/A"
    end

    if labels["Distance"] then labels["Distance"].Text = distStr end
    if labels["Coordinates"] then labels["Coordinates"].Text = coordsStr end

    local h, mh = GetHealth(player)
    if labels["Current Health"] then labels["Current Health"].Text = string.format("%d/%d", math.floor(h), math.floor(mh)) end

    local heldItem = "None"
    if targetChar then
        local tool = targetChar:FindFirstChildOfClass("Tool")
        if tool then heldItem = tool.Name end
    end
    if labels["Held Item"] then labels["Held Item"].Text = heldItem end

    if targetRoot then
        local targetPos = targetRoot.Position
        local others = {}
        local isLocalDNR = DNR(LocalPlayer)
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player then
                if not isLocalDNR and DNR(p) then
                    continue
                end
                local pChar = p.Character
                local pRoot = pChar and (pChar:FindFirstChild("HumanoidRootPart") or pChar.PrimaryPart or pChar:FindFirstChild("PrimaryPart"))
                if pRoot then
                    table.insert(others, {p = p, d = (pRoot.Position - targetPos).Magnitude})
                end
            end
        end
        table.sort(others, function(a, b) return a.d < b.d end)

        for i = 1, 3 do
            local key = "Nearest Player " .. i
            if labels[key] then
                local data = others[i]
                if data then
                    labels[key].Text = string.format("%s (%dm)", data.p.DisplayName or data.p.Name, math.floor(data.d))
                else
                    labels[key].Text = "---"
                end
            end
        end
    else
        for i = 1, 3 do
            local key = "Nearest Player " .. i
            if labels[key] then
                labels[key].Text = "---"
            end
        end
    end
end

PoolFolder = Instance.new("Folder")
PoolFolder.Name = "Sp3arParvus_Pool"
if gethui then
    PoolFolder.Parent = gethui()
elseif syn and syn.protect_gui then
    syn.protect_gui(PoolFolder)
    PoolFolder.Parent = game.CoreGui
else
    PoolFolder.Parent = game.CoreGui
end

local function CreateESP(player)
    if ESPObjects[player] then return end
    if player == LocalPlayer then return end

    local espData = {

        lastNickname = "",
        lastUsername = "",
        lastDistance = -1,
        lastTeamColor = nil,
        lastDistanceColor = nil,
        lastEquipped = "",
        lastStatus = "",
        lastOcclusionCheck = 0,
        lastOcclusionResult = false,
        Connections = {}
    }

    local billboard = Instance.new("BillboardGui")
    billboard.Enabled = false
    billboard.Name = "Nametag"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 140)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    EnsureScreenGui()
    billboard.Parent = ScreenGui

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    container.Parent = billboard

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 0)
    layout.Parent = container

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Text = ""
    statusLabel.Name = "StatusLabel"
    statusLabel.Size = UDim2.new(1, 0, 0, 22)
    statusLabel.BackgroundTransparency = 1
    statusLabel.TextColor3 = Color3.new(1, 1, 1)
    statusLabel.TextStrokeTransparency = 0
    statusLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    statusLabel.TextSize = 16
    statusLabel.LayoutOrder = 0
    statusLabel.Visible = false
    statusLabel.Parent = container

    local nicknameLabel = Instance.new("TextLabel")
    nicknameLabel.Text = ""
    nicknameLabel.Name = "NicknameLabel"
    nicknameLabel.Size = UDim2.new(1, 0, 0, 18)
    nicknameLabel.BackgroundTransparency = 1
    nicknameLabel.TextColor3 = COLORS.NORMAL
    nicknameLabel.TextStrokeTransparency = 0
    nicknameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    nicknameLabel.TextSize = 14
    nicknameLabel.LayoutOrder = 1
    nicknameLabel.Parent = container

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Text = ""
    usernameLabel.Name = "UsernameLabel"
    usernameLabel.Size = UDim2.new(1, 0, 0, 18)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.TextColor3 = COLORS.NORMAL
    usernameLabel.TextStrokeTransparency = 0
    usernameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    usernameLabel.TextSize = 14
    usernameLabel.LayoutOrder = 2
    usernameLabel.Parent = container

    local distanceLabel = Instance.new("TextLabel")
    distanceLabel.Text = ""
    distanceLabel.Name = "DistanceLabel"
    distanceLabel.Size = UDim2.new(1, 0, 0, 18)
    distanceLabel.BackgroundTransparency = 1
    distanceLabel.TextColor3 = COLORS.NORMAL
    distanceLabel.TextStrokeTransparency = 0
    distanceLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    distanceLabel.TextSize = 14
    distanceLabel.LayoutOrder = 3
    distanceLabel.Parent = container

    local healthNumLabel = Instance.new("TextLabel")
    healthNumLabel.Name = "HealthNumericalLabel"
    healthNumLabel.Size = UDim2.new(1, 0, 0, 18)
    healthNumLabel.BackgroundTransparency = 1
    healthNumLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    healthNumLabel.TextStrokeTransparency = 0
    healthNumLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    healthNumLabel.TextSize = 14
    healthNumLabel.LayoutOrder = 4
    healthNumLabel.Text = "100/100"
    healthNumLabel.Parent = container

    local healthBarBG = Instance.new("Frame")
    healthBarBG.Name = "HealthBarContainer"
    healthBarBG.Size = UDim2.new(0.8, 0, 0, 6)
    healthBarBG.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    healthBarBG.BorderSizePixel = 0
    healthBarBG.LayoutOrder = 5
    healthBarBG.Parent = container
    local hbCorner = Instance.new("UICorner"); hbCorner.CornerRadius = UDim.new(1,0); hbCorner.Parent = healthBarBG

    local healthBarFill = Instance.new("Frame")
    healthBarFill.Name = "HealthBarFill"
    healthBarFill.Size = UDim2.fromScale(1, 1)
    healthBarFill.BackgroundColor3 = Color3.fromRGB(50, 220, 100)
    healthBarFill.BorderSizePixel = 0
    healthBarFill.Parent = healthBarBG
    local hbfCorner = Instance.new("UICorner"); hbfCorner.CornerRadius = UDim.new(1,0); hbfCorner.Parent = healthBarFill

    local equippedLabel = Instance.new("TextLabel")
    equippedLabel.Text = ""
    equippedLabel.Name = "EquippedLabel"
    equippedLabel.Size = UDim2.new(1, 0, 0, 18)
    equippedLabel.BackgroundTransparency = 1
    equippedLabel.TextColor3 = GetTeamColor(player)
    equippedLabel.TextStrokeTransparency = 0
    equippedLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    equippedLabel.TextSize = 14
    equippedLabel.LayoutOrder = 6
    equippedLabel.Parent = container

    espData.Nametag = billboard
    espData.StatusLabel = statusLabel
    espData.NicknameLabel = nicknameLabel
    espData.UsernameLabel = usernameLabel
    espData.DistanceLabel = distanceLabel
    espData.HealthNumericalLabel = healthNumLabel
    espData.HealthBarContainer = healthBarBG
    espData.HealthBarFill = healthBarFill
    espData.EquippedLabel = equippedLabel

    ESPObjects[player] = espData
end

ObjectPool = {
    Highlights = {},
    Billboards = {}
}
MAX_POOL_SIZE = 50
ActiveHighlightCount = 0

function GetPooledObject(poolName, className)
    local pool = ObjectPool[poolName]
    while #pool > 0 do
        local obj = table.remove(pool)

        if obj and obj.Parent == PoolFolder then
            obj.Parent = nil
            return obj
        end
    end
    return Instance.new(className)
end

function _resetPooledObject(obj)
    obj.Adornee = nil
    pcall(function() obj.Enabled = false end)
    obj.Parent = PoolFolder
end

function ReturnPooledObject(obj)
    if not obj then return end

    local success = pcall(_resetPooledObject, obj)

    if not success then return end

    if obj:IsA("Highlight") then
        if #ObjectPool.Highlights < MAX_POOL_SIZE then
            table.insert(ObjectPool.Highlights, obj)
        else
            obj:Destroy()
        end
    elseif obj:IsA("BillboardGui") then
        if #ObjectPool.Billboards < MAX_POOL_SIZE then
            table.insert(ObjectPool.Billboards, obj)
        else
            obj:Destroy()
        end
    else
        obj:Destroy()
    end
end

function UpdateDot(player, character, storage, dotType, partName)
    if not Flags["Aim/ShowAssistDots"] then
        if storage[dotType] then
            ReturnPooledObject(storage[dotType])
            storage[dotType] = nil
        end
        return
    end
    local part = character:FindFirstChild(partName)
    if not part then
        if storage[dotType] then
            ReturnPooledObject(storage[dotType])
            storage[dotType] = nil
        end
        return
    end

    local dot = storage[dotType]
    if not dot then

        dot = GetPooledObject("Billboards", "BillboardGui")
        dot.Name = dotType
        dot.AlwaysOnTop = true
        dot.Size = UDim2.fromOffset(6, 6)
        dot.StudsOffset = Vector3.new(0, 0, 0)
        dot.Adornee = part
        dot.Enabled = true
        dot.Parent = character

        local dotFrame = dot:FindFirstChild("Dot")
        if not dotFrame then
            dotFrame = Instance.new("Frame")
            dotFrame.Name = "Dot"
            dotFrame.Size = UDim2.new(1, 0, 1, 0)
            dotFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            dotFrame.BorderSizePixel = 0
            dotFrame.Parent = dot

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = dotFrame
        end

        storage[dotType] = dot
    else

        if not dot.Parent and dot ~= storage[dotType] then
            storage[dotType] = nil
            return UpdateDot(player, character, storage, dotType, partName)
        end

        if dot.Adornee ~= part then
            dot.Adornee = part
        end
        if dot.Parent ~= character then
            dot.Parent = character
        end
        if not dot.Enabled then
            dot.Enabled = true
        end

        local dotFrame = dot:FindFirstChild("Dot")
        if not dotFrame then
            dotFrame = Instance.new("Frame")
            dotFrame.Name = "Dot"
            dotFrame.Size = UDim2.new(1, 0, 1, 0)
            dotFrame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            dotFrame.BorderSizePixel = 0
            dotFrame.Parent = dot

            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(1, 0)
            corner.Parent = dotFrame
        end
    end

    local dotFrame = dot:FindFirstChild("Dot")
    if dotFrame then
            local dotColor = Color3.fromRGB(0, 255, 0)

            if CachedTarget and (os.clock() - CachedTargetTime) < 0.1 and CachedTarget[1] == player then
                local lockedPart = CachedTarget[3]
                if lockedPart == part then
                    dotColor = Color3.fromRGB(255, 0, 0)
                end
            end

            if dotFrame.BackgroundColor3 ~= dotColor then
                dotFrame.BackgroundColor3 = dotColor
            end
    end
end

SharedDotParts = {}
function UpdatePlayerOutlines(player, character)
    if not character then return end

    if not PlayerOutlineObjects[player] then
        PlayerOutlineObjects[player] = {}
    end

    local storage = PlayerOutlineObjects[player]

    local dotParts = SharedDotParts
    table.clear(dotParts)

    if Flags["Aim/ShowAssistDots"] then
        local anySelected = false
        for category, enabled in pairs(Flags["Aim/TargetGroups"]) do
            if enabled then
                anySelected = true
                for _, partName in ipairs(TARGET_GROUPS[category]) do
                    table.insert(dotParts, partName)
                end
            end
        end

        if not anySelected then

            if CachedTarget and (os.clock() - CachedTargetTime) < 0.1 and CachedTarget[1] == player then
                table.insert(dotParts, CachedTarget[3].Name)
            end
        end
    end

    for k, v in pairs(storage) do
        if k ~= "Highlight" then
            local stillNeeded = false
            for _, name in ipairs(dotParts) do
                if k == name .. "Dot" then stillNeeded = true break end
            end
            if not stillNeeded then
                ReturnPooledObject(v)
                storage[k] = nil
            end
        end
    end

    if not storage.Highlight then

        if ActiveHighlightCount >= MAX_OUTLINE_HIGHLIGHTS then

            local furthest = nil
            local maxDist = -1
            local myPos = Camera.CFrame.Position

            for p, obj in pairs(PlayerOutlineObjects) do
                if obj.Highlight then
                    local _, root = GetCharacter(p)
                    if root then
                        local d = (root.Position - myPos).Magnitude
                        if d > maxDist then
                            maxDist = d
                            furthest = p
                        end
                    else

                        furthest = p
                        break
                    end
                end
            end

            if furthest and PlayerOutlineObjects[furthest] then
                storage.Highlight = PlayerOutlineObjects[furthest].Highlight
                PlayerOutlineObjects[furthest].Highlight = nil
                storage.Highlight.Adornee = character
                storage.Highlight.Parent = character

            end
        end

        if not storage.Highlight then
            local highlight = GetPooledObject("Highlights", "Highlight")
            highlight.Name = "PlayerOutlineHighlight"
            highlight.Adornee = character
            highlight.FillColor = COLORS.OUTLINE
            highlight.FillTransparency = 1
            highlight.OutlineColor = COLORS.OUTLINE
            highlight.OutlineTransparency = 0
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Enabled = true
            highlight.Parent = character

            storage.Highlight = highlight
            ActiveHighlightCount = ActiveHighlightCount + 1
        end
    else
        local highlight = storage.Highlight

        if not highlight.Parent and highlight ~= storage.Highlight then
             storage.Highlight = nil
             return UpdatePlayerOutlines(player, character)
        end

        if highlight.Adornee ~= character then
            highlight.Adornee = character
        end
        if highlight.Parent ~= character then
            highlight.Parent = character
        end
        if highlight.OutlineColor ~= COLORS.OUTLINE then
            highlight.OutlineColor = COLORS.OUTLINE
        end
        if not highlight.Enabled then
            highlight.Enabled = true
        end
    end

    for _, partName in ipairs(dotParts) do
        UpdateDot(player, character, storage, partName .. "Dot", partName)
    end
end

function RemovePlayerOutlines(player)
    local storage = PlayerOutlineObjects[player]
    if not storage then return end

    if storage.Highlight then
        ReturnPooledObject(storage.Highlight)
        storage.Highlight = nil
        ActiveHighlightCount = math.max(0, ActiveHighlightCount - 1)
    end

    for k, v in pairs(storage) do
        if k ~= "Highlight" then
            if v:IsA("BillboardGui") then
                ReturnPooledObject(v)
            else
                if v and v.Parent then v:Destroy() end
            end
            storage[k] = nil
        end
    end

    PlayerOutlineObjects[player] = nil
end

function UpdateESP(now, player, isClosest)
    local espData = ESPObjects[player]

    local pId = player.UserId
    local pTeam = player.Team
    local teamName = pTeam and pTeam.Name

    local isIndivWhitelisted = AdvancedPlayerPanelState.Whitelist[pId]
    local isIndivBlacklisted = AdvancedPlayerPanelState.Blacklist[pId]
    local isTeamWhitelisted = teamName and AdvancedPlayerPanelState.TeamWhitelist[teamName]
    local isTeamBlacklisted = teamName and AdvancedPlayerPanelState.TeamBlacklist[teamName]
    local isPrioritized = IsPlayerPrioritized(player) or IsTeamPrioritized(teamName)

    local isWhitelisted = isIndivWhitelisted or (isTeamWhitelisted and not isIndivBlacklisted)

    local statusEmoji = ""
    if isIndivBlacklisted then
        statusEmoji = "❌"
    elseif isPrioritized then
        statusEmoji = "⭐"
    elseif isIndivWhitelisted then
        statusEmoji = "✅"
    elseif isTeamBlacklisted then
        statusEmoji = "❌"
    elseif isTeamWhitelisted then
        statusEmoji = "✅"
    end

    local isTeammate = Flags["ESP/TeamCheck"] and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team
    if not Flags["ESP/Enabled"] or Flags["Settings/GhostMode"] or (isWhitelisted and statusEmoji == "") or isTeammate then
        if espData then
            if espData.Nametag then espData.Nametag.Enabled = false end
        end
        RemovePlayerOutlines(player)
        return
    end

    if espData then

        local nametag = espData.Nametag
        local targetGui = EnsureScreenGui()

        local nametagParent = nametag and PcallGetParent(nametag)
        local isValid = (nametagParent ~= nil)

        if isValid and (not espData.NicknameLabel or not PcallGetParent(espData.NicknameLabel)) then
            isValid = false
        end

        if not isValid then
             RemoveESP(player)
             SetupPlayerESP(player)
             espData = ESPObjects[player]
        else

            if nametag.Parent ~= targetGui then
                nametag.Parent = targetGui
            end
        end
    end

    if not espData then
        CreateESP(player)
        espData = ESPObjects[player]
    end
    if not espData then return end

    local character, rootPart = GetCharacter(player)
    if not character or not rootPart then
        RemovePlayerOutlines(player)

        if espData.Nametag then espData.Nametag.Enabled = false end
        return
    end

    local distance = (rootPart.Position - Camera.CFrame.Position).Magnitude

    if espData.Nametag then
        local nametag = espData.Nametag

        local flagOpacity = Flags["ESP/NametagOpacity"] or 75
        if flagOpacity ~= _cachedESPOpacity then
            _cachedESPOpacity      = flagOpacity
            _cachedESPTransparency = 1 - (flagOpacity / 100)
        end
        local transparency = _cachedESPTransparency

        if espData.StatusLabel and espData.StatusLabel.TextTransparency ~= transparency then
            espData.StatusLabel.TextTransparency = transparency
            espData.StatusLabel.TextStrokeTransparency = transparency
        end
        if espData.NicknameLabel and espData.NicknameLabel.TextTransparency ~= transparency then
            espData.NicknameLabel.TextTransparency = transparency
            espData.NicknameLabel.TextStrokeTransparency = transparency
        end
        if espData.UsernameLabel and espData.UsernameLabel.TextTransparency ~= transparency then
            espData.UsernameLabel.TextTransparency = transparency
            espData.UsernameLabel.TextStrokeTransparency = transparency
        end
        if espData.DistanceLabel and espData.DistanceLabel.TextTransparency ~= transparency then
            espData.DistanceLabel.TextTransparency = transparency
            espData.DistanceLabel.TextStrokeTransparency = transparency
        end
        if espData.HealthNumericalLabel and espData.HealthNumericalLabel.TextTransparency ~= transparency then
            espData.HealthNumericalLabel.TextTransparency = transparency
            espData.HealthNumericalLabel.TextStrokeTransparency = transparency
        end
        if espData.EquippedLabel and espData.EquippedLabel.TextTransparency ~= transparency then
            espData.EquippedLabel.TextTransparency = transparency
            espData.EquippedLabel.TextStrokeTransparency = transparency
        end
        if espData.HealthBarContainer and espData.HealthBarContainer.BackgroundTransparency ~= transparency then
            espData.HealthBarContainer.BackgroundTransparency = transparency
        end
        if espData.HealthBarFill and espData.HealthBarFill.BackgroundTransparency ~= transparency then
            espData.HealthBarFill.BackgroundTransparency = transparency
        end

        if nametag.Adornee ~= rootPart then
            nametag.Adornee = rootPart
        end
        if not nametag.Enabled then
            nametag.Enabled = true
        end

        local teamColor = GetTeamColor(player)

        local nickname = player.DisplayName or player.Name
        local username = "@" .. player.Name
        local distRounded = floor(distance)

        if espData.StatusLabel then
            local showStatus = Flags["ESP/ShowStatus"] and (statusEmoji ~= "")
            if espData.lastStatus ~= statusEmoji or espData.StatusLabel.Visible ~= showStatus then
                espData.StatusLabel.Text = statusEmoji
                espData.StatusLabel.Visible = showStatus
                espData.lastStatus = statusEmoji
            end
        end

        if espData.lastNickname ~= nickname then
            espData.NicknameLabel.Text = nickname
            espData.lastNickname = nickname
        end
        if espData.NicknameLabel.Visible ~= Flags["ESP/ShowNickname"] then
            espData.NicknameLabel.Visible = Flags["ESP/ShowNickname"]
        end

        if espData.lastUsername ~= username then
            espData.UsernameLabel.Text = username
            espData.lastUsername = username
        end
        if espData.UsernameLabel.Visible ~= Flags["ESP/ShowUsername"] then
            espData.UsernameLabel.Visible = Flags["ESP/ShowUsername"]
        end

        if espData.lastTeamColor ~= teamColor then
            espData.NicknameLabel.TextColor3 = teamColor
            espData.EquippedLabel.TextColor3 = teamColor

            espData.lastTeamColor = teamColor
        end

        if math.abs(espData.lastDistance - distRounded) > 5 then
            espData.DistanceLabel.Text = string.format("%d studs", distRounded)
            espData.lastDistance = distRounded
        end
        if espData.DistanceLabel.Visible ~= Flags["ESP/ShowDistance"] then
            espData.DistanceLabel.Visible = Flags["ESP/ShowDistance"]
        end

        local distanceColor = GetDistanceColor(distance, isClosest)
        if espData.lastDistanceColor ~= distanceColor then
            espData.DistanceLabel.TextColor3 = distanceColor
            espData.UsernameLabel.TextColor3 = distanceColor
            espData.lastDistanceColor = distanceColor
        end

        if espData.EquippedLabel then
            local equippedTool = character:FindFirstChildOfClass("Tool")
            local toolName = equippedTool and equippedTool.Name or "Unarmed"
            local equippedString = "[" .. toolName .. "]"

            if espData.lastEquipped ~= equippedString then
                espData.EquippedLabel.Text = equippedString
                espData.lastEquipped = equippedString
            end
            if espData.EquippedLabel.Visible ~= Flags["ESP/ShowEquipped"] then
                espData.EquippedLabel.Visible = Flags["ESP/ShowEquipped"]
            end
        end

        local OCCLUSION_CHECK_INTERVAL = 0.5
        local isOccluded = espData.lastOcclusionResult or false
        if (now - (espData.lastOcclusionCheck or 0)) > OCCLUSION_CHECK_INTERVAL then
            espData.lastOcclusionCheck = now
            isOccluded = ObjectOccluded(true, Camera.CFrame.Position, rootPart.Position, character)
            espData.lastOcclusionResult = isOccluded
        end
        local healthVisible = not isOccluded

        local settingEnabled = Flags["ESP/HealthIndicator"]

        if espData.HealthBarContainer and espData.HealthBarContainer.Visible ~= (healthVisible and settingEnabled) then
            espData.HealthBarContainer.Visible = healthVisible and settingEnabled
        end

        if espData.HealthNumericalLabel and espData.HealthNumericalLabel.Visible ~= settingEnabled then
            espData.HealthNumericalLabel.Visible = settingEnabled
        end

        local health, maxHealth = GetHealth(player)
        if espData.lastHealth ~= health or espData.lastMaxHealth ~= maxHealth then
            espData.HealthNumericalLabel.Text = string.format("%d/%d", math.floor(health), math.floor(maxHealth))
            espData.HealthNumericalLabel.TextColor3 = GetHealthColor(health, maxHealth)

            local healthPercent = math.clamp(health / maxHealth, 0, 1)
            espData.HealthBarFill.Size = UDim2.fromScale(healthPercent, 1)

            espData.lastHealth = health
            espData.lastMaxHealth = maxHealth
        end
    elseif espData.Nametag then
        if espData.Nametag.Enabled then espData.Nametag.Enabled = false end
    end

    if Flags["ESP/PlayerOutlines"] then
        UpdatePlayerOutlines(player, character)
    else
        RemovePlayerOutlines(player)
    end
end

function RemoveESP(player)

    RemovePlayerOutlines(player)

    local espData = ESPObjects[player]
    if not espData then return end

    if espData.Nametag then
        PcallDestroy(espData.Nametag)
    end

    if espData.Connections then
        for _, conn in pairs(espData.Connections) do
            PcallDisconnect(conn)
        end
        table.clear(espData.Connections)
    end

    espData.Nametag = nil
    espData.EquippedLabel = nil
    espData.Connections = nil

    ESPObjects[player] = nil
end

local InformationDisplayHUD = nil
local InformationDisplayLabel = nil

-- Server region detection: infer from round-trip ping latency against Roblox's
-- known data-center locations. Cached after first stable read to avoid flicker.
local INFO_DISPLAY_CACHED_REGION = nil
local INFO_DISPLAY_REGION_SAMPLES = 0
local INFO_DISPLAY_REGION_PING_SUM = 0
local INFO_DISPLAY_REGION_RESOLVE_AFTER = 8  -- samples before locking the region label

function GetServerRegion()
    -- Once resolved, return the cached value
    if INFO_DISPLAY_CACHED_REGION then return INFO_DISPLAY_CACHED_REGION end

    local ok, ping = pcall(LocalPlayer.GetNetworkPing, LocalPlayer)
    if not ok then return "N/A" end

    local ms = ping * 1000
    INFO_DISPLAY_REGION_PING_SUM = INFO_DISPLAY_REGION_PING_SUM + ms
    INFO_DISPLAY_REGION_SAMPLES  = INFO_DISPLAY_REGION_SAMPLES  + 1

    if INFO_DISPLAY_REGION_SAMPLES < INFO_DISPLAY_REGION_RESOLVE_AFTER then
        -- Not enough samples yet — show provisional label with a tilde
        local region
        if ms < 45   then region = "US-E"
        elseif ms < 90  then region = "US-W"
        elseif ms < 120 then region = "EU-W"
        elseif ms < 180 then region = "AP-SE"
        else                 region = "AP-E"
        end
        return "~" .. region
    end

    -- Lock in using the average ping over the sampling window
    local avgMs = INFO_DISPLAY_REGION_PING_SUM / INFO_DISPLAY_REGION_SAMPLES
    if avgMs < 45   then INFO_DISPLAY_CACHED_REGION = "US-E"
    elseif avgMs < 90  then INFO_DISPLAY_CACHED_REGION = "US-W"
    elseif avgMs < 120 then INFO_DISPLAY_CACHED_REGION = "EU-W"
    elseif avgMs < 180 then INFO_DISPLAY_CACHED_REGION = "AP-SE"
    else                    INFO_DISPLAY_CACHED_REGION = "AP-E"
    end
    return INFO_DISPLAY_CACHED_REGION
end

FormatInfoDuration = nil
GetServerUptime = nil
do
    local HttpService = game:GetService("HttpService")
    local ReplicatedStorage = game:FindService("ReplicatedStorage")

    local UPTIME_ATTR_EXACT = {
        serverstarttime = true, starttime = true, serverstart = true,
        creationtime = true, servercreated = true, boottime = true,
        serverboottime = true, gamestarttime = true, worldstarttime = true,
        serveruptime = true, serverage = true, worldage = true,
        instanceage = true, gameage = true, uptime = true,
    }
    local INFO_CONTAINER_NAMES = {
        serverinfo = true, worldinfo = true, gameinfo = true,
        serverdata = true, serverstats = true, info = true,
    }
    local UPTIME_INFO_SUBKEYS = {
        age = true, start = true, created = true, started = true,
    }
    local UPTIME_GUI_NAMES = {
        serveruptime = true, serverage = true, worldage = true,
        instanceage = true, gameage = true, uptime = true,
        uptimetext = true, uptimelabel = true,
        serveragevalue = true, serveruptimevalue = true,
    }

    local state = {
        ExactStartServerUnix = nil,
        RovalraFirstSeenUnix = nil,
        RovalraAttempts = 0,
        RovalraInFlight = false,
        LastRovalraAttemptClock = -100,
        SyncedUptimeBaseSec = nil,
        SyncedUptimeBaseClock = nil,
        LastSyncedRawKey = nil,
        CachedUptimeAttrHost = nil,
        CachedUptimeAttrName = nil,
        CachedUptimeValueObj = nil,
        CachedUptimeLabel = nil,
        CachedUptimeLabelMode = "prefixed",
        LastSourceScanClock = -100,
        SourceScanCount = 0,
    }

    FormatInfoDuration = function(totalSec)
        totalSec = max(0, floor(tonumber(totalSec) or 0))
        local h = floor(totalSec / 3600)
        local m = floor((totalSec % 3600) / 60)
        local s = totalSec % 60
        return string.format("%02d:%02d:%02d", h, m, s)
    end

    local function IsLiveInstance(inst)
        if not inst then return false end
        if inst == Workspace or inst == ReplicatedStorage or inst == Lighting then return true end
        local ok, res = pcall(inst.IsDescendantOf, inst, game)
        return ok and res == true
    end

    local function GetApproxServerUnix()
        local ok, t = pcall(Workspace.GetServerTimeNow, Workspace)
        if ok and type(t) == "number" and t > 0 then
            return t
        end
        return os.time()
    end

    local function SafeHttpGet(url)
        local ok, body = pcall(game.HttpGet, game, url)
        if ok and type(body) == "string" and #body > 0 then
            return body
        end
        local req = (syn and syn.request) or (http and http.request) or http_request or request
        if type(req) == "function" then
            local ok2, resp = pcall(req, { Url = url, Method = "GET" })
            if ok2 and type(resp) == "table" and type(resp.Body) == "string" and #resp.Body > 0 then
                if resp.StatusCode == nil or (resp.StatusCode >= 200 and resp.StatusCode < 300) then
                    return resp.Body
                end
            end
        end
        return nil
    end

    local function CleanGuiString(raw)
        if type(raw) ~= "string" or #raw == 0 then return "" end
        local s = raw
        if s:find("<", 1, true) then
            s = s:gsub("<[^>]->", "")
        end
        if s:find("\194\160", 1, true) then
            s = s:gsub("\194\160", " ")
        end
        return s
    end

    local function GetCleanGuiText(inst)
        local okCt, ct = pcall(function() return inst.ContentText end)
        if okCt and type(ct) == "string" and #ct > 0 then
            if ct:find("\194\160", 1, true) then
                return ct:gsub("\194\160", " ")
            end
            return ct
        end
        local okT, t = pcall(function() return inst.Text end)
        if okT and type(t) == "string" then
            return CleanGuiString(t)
        end
        return ""
    end

    local function ParseUnitDuration(fragment)
        if fragment:find("stud", 1, true) or fragment:match("%d%s*[ap]%.?m%.?") then
            return nil
        end
        local padded = (" " .. fragment .. " "):gsub("%d+%s*milli%a*", " "):gsub("%d+%s*ms[^%a]", " ")
        local d = tonumber(padded:match("(%d+)%s*d"))
        local h = tonumber(padded:match("(%d+)%s*h"))
        local m = tonumber(padded:match("(%d+)%s*min")) or tonumber(padded:match("(%d+)%s*m[^%a]"))
        local s = tonumber(padded:match("(%d+)%s*sec")) or tonumber(padded:match("(%d+)%s*s[^%a]"))
        if d or h or m or s then
            return (d or 0) * 86400 + (h or 0) * 3600 + (m or 0) * 60 + (s or 0)
        end
        return nil
    end

    local function ParseDurationFromTail(tail)
        local stripped = tail:match("^[%s:%-|%(%[{=]*(.-)$") or tail
        local h, m, s = stripped:match("^(%d+):(%d%d):(%d%d)")
        if h then
            return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
        end
        local m2, s2 = stripped:match("^(%d+):(%d%d)")
        if m2 and not stripped:match("^%d+:%d%d%s*[ap]%.?m%.?") then
            return tonumber(m2) * 60 + tonumber(s2)
        end
        local unitSec = ParseUnitDuration(stripped:sub(1, 40))
        if unitSec then return unitSec end
        return nil
    end

    local function ParseUptimeTextSeconds(rawText, mode)
        if type(rawText) ~= "string" then return nil end
        local clean = CleanGuiString(rawText)
        if #clean == 0 or #clean > 240 then return nil end
        local lower = clean:lower()

        if lower:find("script/session/server", 1, true) then return nil end

        if mode == "prefixed" or mode == "strict_server" then
            local prefixEnd = nil
            local _, e1 = lower:find("server%s*uptime")
            if not e1 then _, e1 = lower:find("server%s*age") end
            if not e1 then _, e1 = lower:find("world%s*age") end
            if not e1 then _, e1 = lower:find("instance%s*age") end
            if not e1 then _, e1 = lower:find("game%s*age") end

            if e1 then
                prefixEnd = e1
            elseif mode == "prefixed" then
                local s3, e3 = lower:find("uptime")
                if s3 then
                    local before = s3 > 1 and lower:sub(max(1, s3 - 14), s3 - 1) or ""
                    if not before:match("[%a]$")
                        and not before:find("script", 1, true)
                        and not before:find("client", 1, true)
                        and not before:find("session", 1, true)
                        and not before:find("local", 1, true)
                    then
                        prefixEnd = e3
                    end
                end
            end

            if not prefixEnd then return nil end
            return ParseDurationFromTail(lower:sub(prefixEnd + 1))
        else
            if lower:match("%d%s*[ap]%.?m%.?") then return nil end
            local h, m, s = lower:match("^%s*(%d+):(%d%d):(%d%d)%s*$")
            if h then
                return tonumber(h) * 3600 + tonumber(m) * 60 + tonumber(s)
            end
            local m2, s2 = lower:match("^%s*(%d+):(%d%d)%s*$")
            if m2 then
                return tonumber(m2) * 60 + tonumber(s2)
            end
            local prefixed = ParseUptimeTextSeconds(clean, "prefixed")
            if prefixed then return prefixed end
            return ParseUnitDuration(lower)
        end
    end

    local function ResolveRawUptimeValue(val)
        if type(val) == "number" then
            if val > 1500000000 then
                local sNow = GetApproxServerUnix()
                local diffServer = sNow - val
                if diffServer >= -10 and diffServer < 86400 * 30 then
                    state.ExactStartServerUnix = val
                    return max(0, diffServer), true
                end
                local diffTick = tick() - val
                if diffTick >= -10 and diffTick < 86400 * 30 then
                    return max(0, diffTick), true
                end
            elseif val >= 0 and val < 86400 * 30 then
                return val, false
            end
        elseif type(val) == "string" then
            local asNum = tonumber(val)
            if asNum then
                return ResolveRawUptimeValue(asNum)
            end
            local parsed = ParseUptimeTextSeconds(val, "raw")
            if parsed then
                return parsed, false
            end
        end
        return nil, false
    end

    local function SyncObservedUptime(rawKey, observedSec)
        local nowClock = os.clock()
        if state.LastSyncedRawKey ~= rawKey or not state.SyncedUptimeBaseSec then
            state.LastSyncedRawKey = rawKey
            state.SyncedUptimeBaseSec = observedSec
            state.SyncedUptimeBaseClock = nowClock
            return observedSec
        end
        return state.SyncedUptimeBaseSec + max(0, nowClock - state.SyncedUptimeBaseClock)
    end

    local function IsOwnGui(gui)
        if not gui then return true end
        if ScreenGui and (gui == ScreenGui or gui:IsDescendantOf(ScreenGui)) then return true end
        if NotifyGui and (gui == NotifyGui or gui:IsDescendantOf(NotifyGui)) then return true end
        if FreecamUI and (gui == FreecamUI or gui:IsDescendantOf(FreecamUI)) then return true end
        if InformationDisplayHUD and (gui == InformationDisplayHUD or gui:IsDescendantOf(InformationDisplayHUD)) then return true end
        return gui.Name == "Sp3arParvusUI" or gui.Name == "FreecamKeybindsUI"
    end

    local function PruneStaleUptimeRefs()
        if state.CachedUptimeAttrHost then
            local ok, v = pcall(state.CachedUptimeAttrHost.GetAttribute, state.CachedUptimeAttrHost, state.CachedUptimeAttrName)
            if not IsLiveInstance(state.CachedUptimeAttrHost) or not ok or v == nil then
                state.CachedUptimeAttrHost = nil
                state.CachedUptimeAttrName = nil
                state.ExactStartServerUnix = nil
            end
        end
        if state.CachedUptimeValueObj and not IsLiveInstance(state.CachedUptimeValueObj) then
            state.CachedUptimeValueObj = nil
        end
        if state.CachedUptimeLabel and not IsLiveInstance(state.CachedUptimeLabel) then
            state.CachedUptimeLabel = nil
        end
    end

    local function ScanContainerForUptime(container, depth, inInfoFolder)
        if not container or depth > 3 then return end
        if state.CachedUptimeAttrHost or state.CachedUptimeValueObj then return end

        local okAttr, attrs = pcall(container.GetAttributes, container)
        if okAttr and type(attrs) == "table" then
            for attrName, attrVal in pairs(attrs) do
                local key = tostring(attrName):lower():gsub("[%s_%-]", "")
                if UPTIME_ATTR_EXACT[key] or (inInfoFolder and UPTIME_INFO_SUBKEYS[key]) then
                    if ResolveRawUptimeValue(attrVal) then
                        state.CachedUptimeAttrHost = container
                        state.CachedUptimeAttrName = attrName
                        return
                    end
                end
            end
        end

        if depth >= 3 then return end
        local okCh, children = pcall(container.GetChildren, container)
        if not okCh or type(children) ~= "table" then return end

        for i = 1, min(#children, 200) do
            local child = children[i]
            local key = child.Name:lower():gsub("[%s_%-]", "")
            if child:IsA("ValueBase") then
                if UPTIME_ATTR_EXACT[key] or (inInfoFolder and UPTIME_INFO_SUBKEYS[key]) then
                    local okV, v = pcall(function() return child.Value end)
                    if okV and ResolveRawUptimeValue(v) then
                        state.CachedUptimeValueObj = child
                        return
                    end
                end
            elseif child:IsA("Folder") or child:IsA("Configuration") then
                local childIsInfo = inInfoFolder or INFO_CONTAINER_NAMES[key] == true
                ScanContainerForUptime(child, depth + 1, childIsInfo)
                if state.CachedUptimeAttrHost or state.CachedUptimeValueObj then
                    return
                end
            end
        end
    end

    local function IsServerUptimeGuiName(rawName)
        if type(rawName) ~= "string" or #rawName == 0 then return false end
        local lower = rawName:lower()
        if lower:find("script", 1, true) or lower:find("client", 1, true)
            or lower:find("session", 1, true) or lower:find("local", 1, true)
        then
            return false
        end
        local key = lower:gsub("[%s_%-]", "")
        return UPTIME_GUI_NAMES[key] == true
    end

    local function ScanGuiRootForUptime(guiRoot, labelMode, skipCoreInternals)
        if not guiRoot or state.CachedUptimeLabel then return end
        local okGuis, guis = pcall(guiRoot.GetChildren, guiRoot)
        if not okGuis or type(guis) ~= "table" then return end

        for i = 1, #guis do
            local gui = guis[i]
            local gName = gui.Name
            if (not skipCoreInternals or (gName ~= "RobloxGui" and gName ~= "DevConsoleMaster"))
                and gui:IsA("LayerCollector")
                and not IsOwnGui(gui)
            then
                local okDesc, desc = pcall(gui.GetDescendants, gui)
                if okDesc and type(desc) == "table" then
                    local limit = min(#desc, 8000)
                    for j = 1, limit do
                        local inst = desc[j]
                        local cls = inst.ClassName
                        if cls == "TextLabel" or cls == "TextButton" then
                            local txt = GetCleanGuiText(inst)
                            if #txt > 0 and #txt <= 240 then
                                if ParseUptimeTextSeconds(txt, labelMode) then
                                    state.CachedUptimeLabel = inst
                                    state.CachedUptimeLabelMode = labelMode
                                    return
                                end
                                if labelMode == "prefixed" then
                                    local p = inst.Parent
                                    if (IsServerUptimeGuiName(inst.Name) or (p and IsServerUptimeGuiName(p.Name)))
                                        and ParseUptimeTextSeconds(txt, "raw")
                                    then
                                        state.CachedUptimeLabel = inst
                                        state.CachedUptimeLabelMode = "raw"
                                        return
                                    end
                                    local low = txt:lower()
                                    if low:match("^%s*server%s*uptime%s*[:%-|]?%s*$")
                                        or low:match("^%s*server%s*age%s*[:%-|]?%s*$")
                                        or low:match("^%s*world%s*age%s*[:%-|]?%s*$")
                                        or low:match("^%s*uptime%s*[:%-|]?%s*$")
                                    then
                                        if p then
                                            local okSib, sibs = pcall(p.GetChildren, p)
                                            if okSib and type(sibs) == "table" then
                                                for k = 1, #sibs do
                                                    local sib = sibs[k]
                                                    if sib ~= inst and (sib.ClassName == "TextLabel" or sib.ClassName == "TextButton") then
                                                        local sibTxt = GetCleanGuiText(sib)
                                                        if #sibTxt > 0 and ParseUptimeTextSeconds(sibTxt, "raw") then
                                                            state.CachedUptimeLabel = sib
                                                            state.CachedUptimeLabelMode = "raw"
                                                            return
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    local function TryFetchRovalraServerAge()
        if state.RovalraFirstSeenUnix or state.RovalraInFlight or state.RovalraAttempts >= 4 then return end
        local now = os.clock()
        if (now - state.LastRovalraAttemptClock) < 20 then return end

        local placeId = game.PlaceId
        local jobId = game.JobId
        if not placeId or placeId <= 0 or type(jobId) ~= "string" or #jobId == 0 then return end

        state.RovalraInFlight = true
        state.RovalraAttempts = state.RovalraAttempts + 1
        state.LastRovalraAttemptClock = now

        TrackThread(task.spawn(function()
            local url = string.format(
                "https://apis.rovalra.com/v1/servers/details?place_id=%s&server_ids=%s",
                tostring(placeId),
                tostring(jobId)
            )
            local body = SafeHttpGet(url)
            if body then
                local okDec, decoded = pcall(HttpService.JSONDecode, HttpService, body)
                if okDec and type(decoded) == "table" and type(decoded.servers) == "table" then
                    local srv = decoded.servers[1]
                    if type(srv) == "table" and type(srv.first_seen) == "string" then
                        local y, mo, d, h, mi, s = srv.first_seen:match("^(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)")
                        if y then
                            local okDt, dt = pcall(
                                DateTime.fromUniversalTime,
                                tonumber(y), tonumber(mo), tonumber(d),
                                tonumber(h), tonumber(mi), tonumber(s)
                            )
                            if okDt and dt and dt.UnixTimestamp and dt.UnixTimestamp > 1500000000 then
                                state.RovalraFirstSeenUnix = dt.UnixTimestamp
                            end
                        end
                    end
                end
            end
            state.RovalraInFlight = false
        end))
    end

    local function ScanInGameUptimeSources()
        PruneStaleUptimeRefs()
        local now = os.clock()
        local interval = state.SourceScanCount < 6 and 3 or 8
        if (now - state.LastSourceScanClock) < interval then return end
        state.LastSourceScanClock = now
        state.SourceScanCount = state.SourceScanCount + 1

        local hasUptimeSource = (state.CachedUptimeAttrHost ~= nil)
            or (state.CachedUptimeValueObj ~= nil)
            or (state.CachedUptimeLabel ~= nil)
            or (state.ExactStartServerUnix ~= nil)
        if hasUptimeSource then return end

        ScanContainerForUptime(Workspace, 0, false)
        if not ReplicatedStorage then
            ReplicatedStorage = game:FindService("ReplicatedStorage")
        end
        if ReplicatedStorage then
            ScanContainerForUptime(ReplicatedStorage, 0, false)
        end
        if Lighting then
            ScanContainerForUptime(Lighting, 0, false)
        end

        if not state.CachedUptimeLabel then
            local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
            if playerGui then
                ScanGuiRootForUptime(playerGui, "prefixed", false)
            end
        end
        if not state.CachedUptimeLabel then
            local okCore, coreGui = pcall(game.GetService, game, "CoreGui")
            if okCore and coreGui then
                ScanGuiRootForUptime(coreGui, "strict_server", true)
            end
        end
    end

    TryFetchRovalraServerAge()

    GetServerUptime = function()
        ScanInGameUptimeSources()

        if state.CachedUptimeAttrHost then
            local okA, raw = pcall(state.CachedUptimeAttrHost.GetAttribute, state.CachedUptimeAttrHost, state.CachedUptimeAttrName)
            local sec, isTs = ResolveRawUptimeValue(okA and raw or nil)
            if sec then
                if isTs then return FormatInfoDuration(max(Workspace.DistributedGameTime, sec)) end
                return FormatInfoDuration(SyncObservedUptime("attr:" .. tostring(raw), sec))
            end
            state.CachedUptimeAttrHost = nil
            state.CachedUptimeAttrName = nil
        end

        if state.CachedUptimeValueObj then
            local okV, raw = pcall(function() return state.CachedUptimeValueObj.Value end)
            local sec, isTs = ResolveRawUptimeValue(okV and raw or nil)
            if sec then
                if isTs then return FormatInfoDuration(max(Workspace.DistributedGameTime, sec)) end
                return FormatInfoDuration(SyncObservedUptime("val:" .. tostring(raw), sec))
            end
            state.CachedUptimeValueObj = nil
        end

        if state.CachedUptimeLabel then
            local rawTxt = GetCleanGuiText(state.CachedUptimeLabel)
            local sec = ParseUptimeTextSeconds(rawTxt, state.CachedUptimeLabelMode)
            if sec then
                return FormatInfoDuration(SyncObservedUptime("lbl:" .. rawTxt, sec))
            end
            state.CachedUptimeLabel = nil
        end

        if state.ExactStartServerUnix then
            local sec = max(Workspace.DistributedGameTime, GetApproxServerUnix() - state.ExactStartServerUnix)
            return FormatInfoDuration(sec)
        end

        TryFetchRovalraServerAge()
        if state.RovalraFirstSeenUnix then
            local sec = max(Workspace.DistributedGameTime, GetApproxServerUnix() - state.RovalraFirstSeenUnix)
            return FormatInfoDuration(sec)
        end

        local okStudio, isStudio = pcall(RunService.IsStudio, RunService)
        if okStudio and isStudio then
            return FormatInfoDuration(max(0, Workspace.DistributedGameTime))
        end

        return "?"
    end
end

function CreateInformationDisplayHUD(parent)
    InformationDisplayHUD = Instance.new("Frame")
    InformationDisplayHUD.Name = "InformationDisplayHUD"
    InformationDisplayHUD.Position = UDim2.new(1, -6, 0, 3)
    InformationDisplayHUD.AnchorPoint = Vector2.new(1, 0)
    InformationDisplayHUD.BackgroundTransparency = 1
    InformationDisplayHUD.AutomaticSize = Enum.AutomaticSize.XY
    InformationDisplayHUD.Parent = parent

    InformationDisplayLabel = Instance.new("TextLabel")
    InformationDisplayLabel.Name = "InformationDisplayLabel"
    InformationDisplayLabel.Text = ""
    InformationDisplayLabel.BackgroundTransparency = 1
    InformationDisplayLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    InformationDisplayLabel.TextSize = 15
    InformationDisplayLabel.TextColor3 = Color3.new(1, 1, 1)
    InformationDisplayLabel.TextXAlignment = Enum.TextXAlignment.Right
    InformationDisplayLabel.AutomaticSize = Enum.AutomaticSize.XY
    InformationDisplayLabel.Parent = InformationDisplayHUD

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 1
    stroke.Color = Color3.new(0, 0, 0)
    stroke.Parent = InformationDisplayLabel
end

function UpdateInformationDisplay()
    if not InformationDisplayHUD then return end

    local visible = Flags["Visuals/InformationDisplay"] and not Flags["Settings/GhostMode"]
    if InformationDisplayHUD.Visible ~= visible then
        InformationDisplayHUD.Visible = visible
    end

    if not visible then return end

    local clockTime = Lighting.ClockTime
    local hours = math.floor(clockTime)
    local minutes = math.floor((clockTime - hours) * 60)
    local period = hours >= 12 and "PM" or "AM"
    local hours12 = hours % 12
    if hours12 == 0 then hours12 = 12 end
    local timeStr = string.format("%d:%02d %s", hours12, minutes, period)

    local lpcStr = "N/A"
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
    if root then
        local pos = root.Position
        lpcStr = string.format("%d,%d,%d", floor(pos.X), floor(pos.Y), floor(pos.Z))
    end

    local mouseLoc = UserInputService:GetMouseLocation()
    local lmcStr = string.format("%d,%d", floor(mouseLoc.X), floor(mouseLoc.Y))

    -- Region: latency-inferred data-center label
    local regionStr = GetServerRegion()

    local scriptUptimeStr = type(initStartTime) == "number"
        and FormatInfoDuration(max(0, floor(tick() - initStartTime)))
        or "?"
    local okDgt, dgt = pcall(function() return Workspace.DistributedGameTime end)
    local sessionUptimeStr = (okDgt and type(dgt) == "number")
        and FormatInfoDuration(max(0, floor(dgt)))
        or "?"
    local serverUptimeStr = GetServerUptime()

    local newText = string.format(
        "WorldTime[%s] Humanoid[%s] Mouse[%s] Region[%s] Script/Session/Server uptime: {%s/%s/%s}",
        timeStr, lpcStr, lmcStr, regionStr, scriptUptimeStr, sessionUptimeStr, serverUptimeStr
    )
    if InformationDisplayLabel.Text ~= newText then
        InformationDisplayLabel.Text = newText
    end
end

PerformanceLabel = nil
PerfMinimized = false
PerfOriginalSize = UDim2.fromOffset(180, 145)

PerformanceRows = {}

function CreatePerformanceDisplay(parent)
    PerformanceLabel = Instance.new("CanvasGroup")
    PerformanceLabel.Name = "PerformanceDisplay"
    PerformanceLabel.Size = UDim2.fromScale(0.1, 0.14)
    local OriginalSize = PerformanceLabel.Size
    PerformanceLabel.Position = UDim2.new(1, -240, 0, 100)
    PerformanceLabel.AnchorPoint = Vector2.new(1, 0)

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(160, 140)
    sizeConstraint.MaxSize = Vector2.new(220, 180)
    sizeConstraint.Parent = PerformanceLabel

    PerformanceLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    PerformanceLabel.BackgroundTransparency = 0
    PerformanceLabel.BorderSizePixel = 0
    PerformanceLabel.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = PerformanceLabel

    local stroke = Instance.new("UIStroke")
    stroke.Color = UI_THEME.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = PerformanceLabel

    local headerTitle = Instance.new("TextLabel")
    headerTitle.Name = "HeaderTitle"
    headerTitle.Size = UDim2.new(1, -30, 0, 24)
    headerTitle.Position = UDim2.fromOffset(8, 2)
    headerTitle.BackgroundTransparency = 1
    headerTitle.Text = "Performance"
    headerTitle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    headerTitle.TextSize = 12
    headerTitle.TextColor3 = UI_THEME.Accent
    headerTitle.TextXAlignment = Enum.TextXAlignment.Left
    headerTitle.Parent = PerformanceLabel

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(1, -16, 1, -36)
    container.Position = UDim2.fromOffset(8, 28)
    container.BackgroundTransparency = 1
    container.Parent = PerformanceLabel

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 2)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    local function CreateRow(name, initialValue)
        local row = Instance.new("Frame")
        row.Name = name .. "Row"
        row.Size = UDim2.new(1, 0, 0, 14)
        row.BackgroundTransparency = 1
        row.Parent = container

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.4, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = name .. ":"
        label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        label.TextSize = 11
        label.TextColor3 = Color3.fromRGB(200, 200, 200)
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local value = Instance.new("TextLabel")
        value.Size = UDim2.new(0.6, 0, 1, 0)
        value.Position = UDim2.new(0.4, 0, 0, 0)
        value.BackgroundTransparency = 1
        value.Text = initialValue
        value.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        value.TextSize = 11
        value.TextColor3 = Color3.fromRGB(255, 255, 255)
        value.TextXAlignment = Enum.TextXAlignment.Right
        value.Parent = row

        PerformanceRows[name] = value
    end

    CreateRow("FPS", "0")
    CreateRow("Ping", "0 ms")
    CreateRow("Memory", "0 MB")
    CreateRow("Players", "0")
    CreateRow("Aim", "OFF")
    CreateRow("Br0k3n Objects", "0")
    CreateRow("H1ghL1ghted Objects", "0")

    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "Minimize"
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    minimizeBtn.BackgroundTransparency = 0.5
    minimizeBtn.Size = UDim2.fromOffset(18, 18)
    minimizeBtn.Position = UDim2.new(1, -22, 0, 4)
    minimizeBtn.Text = "−"
    minimizeBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    minimizeBtn.TextSize = 14
    minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.ZIndex = 10
    minimizeBtn.Parent = PerformanceLabel

    local mCorner = Instance.new("UICorner")
    mCorner.CornerRadius = UDim.new(0, 4)
    mCorner.Parent = minimizeBtn

    TrackConnection(minimizeBtn.MouseButton1Click:Connect(function()
        PerfMinimized = not PerfMinimized
        if PerfMinimized then
            sizeConstraint.Parent = nil
            TweenService:Create(PerformanceLabel, TWEENS.SMOOTH, {Size = UDim2.fromOffset(180, 28)}):Play()
            container.Visible = false
            headerTitle.Text = "Performance Stats"
            minimizeBtn.Text = "+"
        else
            sizeConstraint.Parent = PerformanceLabel
            TweenService:Create(PerformanceLabel, TWEENS.SMOOTH, {Size = OriginalSize}):Play()
            container.Visible = true
            headerTitle.Text = "Performance"
            minimizeBtn.Text = "−"
        end
    end))

    if UI.MakeDraggable then
        UI.MakeDraggable(PerformanceLabel)
    end
    pcall(UpdateScreenUIOpacity)
end

local LocalHealthHUD = nil
local LocalHealthValueLabel = nil

function CreateLocalHealthHUD(parent)
    LocalHealthHUD = Instance.new("CanvasGroup")
    LocalHealthHUD.Name = "LocalHealthHUD"
    LocalHealthHUD.Size = UDim2.fromScale(0.08, 0.05)
    LocalHealthHUD.Position = UDim2.new(1, -260, 0, 70)
    LocalHealthHUD.AnchorPoint = Vector2.new(1, 0)

    local sizeConstraint = Instance.new("UISizeConstraint")
    sizeConstraint.MinSize = Vector2.new(110, 30)
    sizeConstraint.MaxSize = Vector2.new(160, 30)
    sizeConstraint.Parent = LocalHealthHUD

    LocalHealthHUD.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    LocalHealthHUD.BackgroundTransparency = 0.2
    LocalHealthHUD.BorderSizePixel = 0
    LocalHealthHUD.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = LocalHealthHUD

    local stroke = Instance.new("UIStroke")
    stroke.Color = UI_THEME.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.5
    stroke.Parent = LocalHealthHUD

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "100/100"
    label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Parent = LocalHealthHUD
    LocalHealthValueLabel = label

    if UI.MakeDraggable then
        UI.MakeDraggable(LocalHealthHUD)
    end
    pcall(UpdateScreenUIOpacity)
end

local lastLocalH, lastLocalMH = -1, -1
function UpdateLocalHealthHUD()
    if not LocalHealthValueLabel or not LocalHealthHUD then return end

    if not Flags["LocalUI/LocalHealthIndicator"] then
        if LocalHealthHUD.Visible then LocalHealthHUD.Visible = false end
        return
    else
        if not LocalHealthHUD.Visible and not Flags["Settings/GhostMode"] then LocalHealthHUD.Visible = true end
    end

    local h, mh = GetHealth(LocalPlayer)
    if h ~= lastLocalH or mh ~= lastLocalMH then
        LocalHealthValueLabel.Text = string.format("%d/%d", math.floor(h), math.floor(mh))
        lastLocalH, lastLocalMH = h, mh
    end
end

function UpdatePerformanceDisplay()
    if not Flags["LocalUI/PerformancePanel"] or not PerformanceLabel or PerfMinimized then
        if PerformanceLabel and not Flags["LocalUI/PerformancePanel"] and PerformanceLabel.Visible then
            PerformanceLabel.Visible = false
        end
        return
    end

    if not PerformanceLabel.Visible then return end

    local fps = floor(GetFPS())
    local ping = floor(GetPing())
    local playerCount = #GetPlayersCache()
    local memoryUsed = floor(Stats:GetTotalMemoryUsageMb())
    local activeTargets = max(0, playerCount - 1)

    local fpsColor = Color3.fromRGB(50, 255, 50)
    if fps < 30 then
        fpsColor = Color3.fromRGB(255, 50, 50)
    elseif fps < 60 then
        fpsColor = Color3.fromRGB(255, 200, 50)
    end

    local pingColor = Color3.fromRGB(50, 255, 50)
    if ping > 200 then
        pingColor = Color3.fromRGB(255, 50, 50)
    elseif ping > 100 then
        pingColor = Color3.fromRGB(255, 200, 50)
    end

    if PerformanceRows.FPS then
        local val = tostring(fps)
        if PerformanceRows.FPS.Text ~= val then PerformanceRows.FPS.Text = val end
        if PerformanceRows.FPS.TextColor3 ~= fpsColor then PerformanceRows.FPS.TextColor3 = fpsColor end
    end
    if PerformanceRows.Ping then
        local val = ping .. " ms"
        if PerformanceRows.Ping.Text ~= val then PerformanceRows.Ping.Text = val end
        if PerformanceRows.Ping.TextColor3 ~= pingColor then PerformanceRows.Ping.TextColor3 = pingColor end
    end
    if PerformanceRows.Memory then
        local val = memoryUsed .. " MB"
        if PerformanceRows.Memory.Text ~= val then PerformanceRows.Memory.Text = val end
    end
    if PerformanceRows.Players then
        local val = tostring(playerCount)
        if PerformanceRows.Players.Text ~= val then PerformanceRows.Players.Text = val end
    end
    if PerformanceRows.Aim then
        local AimActive = Flags["Aim/AimLock"] and (Flags["Aim/AlwaysEnabled"] or AimState.Aim)
        local val = AimActive and "LOCKED 🔒" or "IDLE ─"
        local col = AimActive and UI_THEME.Accent or Color3.fromRGB(150, 150, 150)
        if PerformanceRows.Aim.Text ~= val then PerformanceRows.Aim.Text = val end
        if PerformanceRows.Aim.TextColor3 ~= col then PerformanceRows.Aim.TextColor3 = col end
    end
    if PerformanceRows["Br0k3n Objects"] then
        local brokenCount = 0
        for _ in pairs(Br3ak3rState.brokenSet) do brokenCount = brokenCount + 1 end
        local val = tostring(brokenCount)
        if PerformanceRows["Br0k3n Objects"].Text ~= val then PerformanceRows["Br0k3n Objects"].Text = val end
    end
    if PerformanceRows["H1ghL1ghted Objects"] then
        local highlightedCount = 0
        for _ in pairs(H1ghl1ght3rState.highlightedSet) do highlightedCount = highlightedCount + 1 end
        local val = tostring(highlightedCount)
        if PerformanceRows["H1ghL1ghted Objects"].Text ~= val then PerformanceRows["H1ghL1ghted Objects"].Text = val end
    end
end

function UpdateScreenUIOpacity()
    local opacity = (Flags["LocalUI/ScreenUIOpacity"] or 75) / 100
    local transparency = 1 - opacity

    if UIState and UIState.MainFrame then
        UIState.MainFrame.GroupTransparency = transparency
    end
    if ClosestPlayerTrackerLabel then
        ClosestPlayerTrackerLabel.GroupTransparency = transparency
    end
    if PerformanceLabel then
        PerformanceLabel.GroupTransparency = transparency
    end
    if LocalHealthHUD then
        LocalHealthHUD.GroupTransparency = transparency
    end
    if ItemPanelUI and ItemPanelUI.MainFrame then
        ItemPanelUI.MainFrame.GroupTransparency = transparency
    end
end

function UpdateAllNametagOpacities()
    local opacity = (Flags["ESP/NametagOpacity"] or 75) / 100
    local transparency = 1 - opacity
    if not ESPObjects then return end
    for player, espData in pairs(ESPObjects) do
        if espData.Nametag then
            if espData.StatusLabel then
                espData.StatusLabel.TextTransparency = transparency
                espData.StatusLabel.TextStrokeTransparency = transparency
            end
            if espData.NicknameLabel then
                espData.NicknameLabel.TextTransparency = transparency
                espData.NicknameLabel.TextStrokeTransparency = transparency
            end
            if espData.UsernameLabel then
                espData.UsernameLabel.TextTransparency = transparency
                espData.UsernameLabel.TextStrokeTransparency = transparency
            end
            if espData.DistanceLabel then
                espData.DistanceLabel.TextTransparency = transparency
                espData.DistanceLabel.TextStrokeTransparency = transparency
            end
            if espData.HealthNumericalLabel then
                espData.HealthNumericalLabel.TextTransparency = transparency
                espData.HealthNumericalLabel.TextStrokeTransparency = transparency
            end
            if espData.EquippedLabel then
                espData.EquippedLabel.TextTransparency = transparency
                espData.EquippedLabel.TextStrokeTransparency = transparency
            end
            if espData.HealthBarContainer then
                espData.HealthBarContainer.BackgroundTransparency = transparency
            end
            if espData.HealthBarFill then
                espData.HealthBarFill.BackgroundTransparency = transparency
            end
        end
    end
end

local FreecamProxy = {}
local function ___InitializeFreecam()

local pi    = math.pi
local abs   = math.abs
local clamp = math.clamp
local exp   = math.exp
local rad   = math.rad
local sign  = math.sign
local sqrt  = math.sqrt
local tan   = math.tan

local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
LocalPlayer = Players.LocalPlayer
end

local Camera = workspace.CurrentCamera
TrackConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
local newCamera = workspace.CurrentCamera
if newCamera then
Camera = newCamera
if ConnectViewportSize then ConnectViewportSize() end
end
end))

local TOGGLE_INPUT_PRIORITY = Enum.ContextActionPriority.Low.Value
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
local FREECAM_MACRO_KB = {Enum.KeyCode.LeftControl, Enum.KeyCode.P}

local NAV_GAIN = Vector3.new(1, 1, 1)*64
local PAN_GAIN = Vector2.new(0.75, 1)*8
local FOV_GAIN = 300

local PITCH_LIMIT = rad(90)

local VEL_STIFFNESS = 1.5
local PAN_STIFFNESS = 1.0
local FOV_STIFFNESS = 4.0

local Spring = {} do
Spring.__index = Spring

function Spring.new(freq, pos)
local self = setmetatable({}, Spring)
self.f = freq
self.p = pos
self.v = pos*0
return self
end

function Spring:Update(dt, goal)
local f = self.f*2*pi
local p0 = self.p
local v0 = self.v

local offset = goal - p0
local decay = exp(-f*dt)

local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
local v1 = (f*dt*(offset*f - v0) + v0)*decay

self.p = p1
self.v = v1

return p1
end

function Spring:Reset(pos)
self.p = pos
self.v = pos*0
end
end

local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local cameraFov = 0

local velSpring = Spring.new(VEL_STIFFNESS, Vector3.new())
local panSpring = Spring.new(PAN_STIFFNESS, Vector2.new())
local fovSpring = Spring.new(FOV_STIFFNESS, 0)
local freecamMouseLocked = true

local Input = {} do
local thumbstickCurve do
local K_CURVATURE = 2.0
local K_DEADZONE = 0.15

function fCurve(x)
return (exp(K_CURVATURE*x) - 1)/(exp(K_CURVATURE) - 1)
end

function fDeadzone(x)
return fCurve((x - K_DEADZONE)/(1 - K_DEADZONE))
end

function thumbstickCurve(x)
return sign(x)*clamp(fDeadzone(abs(x)), 0, 1)
end
end

local gamepad = {
ButtonX = 0,
ButtonY = 0,
DPadDown = 0,
DPadUp = 0,
ButtonL2 = 0,
ButtonR2 = 0,
Thumbstick1 = Vector2.new(),
Thumbstick2 = Vector2.new(),
}

local keyboard = {
W = 0,
A = 0,
S = 0,
D = 0,
E = 0,
Q = 0,
U = 0,
H = 0,
J = 0,
K = 0,
I = 0,
Y = 0,
Up = 0,
Down = 0,
LeftShift = 0,
RightShift = 0,
Space = 0,
}
Input.keyboard = keyboard

local mouse = {
Delta = Vector2.new(),
MouseWheel = 0,
}

local NAV_GAMEPAD_SPEED  = Vector3.new(1, 1, 1)
local NAV_KEYBOARD_SPEED = Vector3.new(3.8, 3.8, 3.8)
local PAN_MOUSE_SPEED    = Vector2.new(1.7, 1.7)*(pi/64)
local PAN_GAMEPAD_SPEED  = Vector2.new(1.7, 1.7)*(pi/8)
local FOV_WHEEL_SPEED    = 1.0
local FOV_GAMEPAD_SPEED  = 3
local NAV_ADJ_SPEED      = 2
local NAV_SHIFT_MUL      = 0.30

local navSpeed = 1

function Input.Vel(dt)
navSpeed = clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.1, 4)

local kGamepad = Vector3.new(
thumbstickCurve(gamepad.Thumbstick1.x),
thumbstickCurve(gamepad.ButtonR2) - thumbstickCurve(gamepad.ButtonL2),
thumbstickCurve(-gamepad.Thumbstick1.y)
)*NAV_GAMEPAD_SPEED

local kKeyboard = Vector3.new(
keyboard.D - keyboard.A,
keyboard.E - keyboard.Q,
keyboard.S - keyboard.W
)*NAV_KEYBOARD_SPEED

local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

return (kGamepad + kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
end

function Input.Pan(dt)
local kGamepad = Vector2.new(
thumbstickCurve(gamepad.Thumbstick2.y),
thumbstickCurve(-gamepad.Thumbstick2.x)
)*PAN_GAMEPAD_SPEED
local kMouse = mouse.Delta*PAN_MOUSE_SPEED
mouse.Delta = Vector2.new()
return kGamepad + kMouse
end

function Input.Fov(dt)
local kGamepad = (gamepad.ButtonX - gamepad.ButtonY)*FOV_GAMEPAD_SPEED
local kMouse = mouse.MouseWheel*FOV_WHEEL_SPEED
mouse.MouseWheel = 0
return kGamepad + kMouse
end

do
function Keypress(action, state, input)
local isBegin = state == Enum.UserInputState.Begin
keyboard[input.KeyCode.Name] = isBegin and 1 or 0

if isBegin then
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        if input.KeyCode == Enum.KeyCode.I then
            hum.PlatformStand = not hum.PlatformStand
            if hum.PlatformStand then
                hum:ChangeState(Enum.HumanoidStateType.Physics)
            else
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        elseif input.KeyCode == Enum.KeyCode.Y then
            hum.Health = 0
        end
    end
end
return Enum.ContextActionResult.Sink
end

function GpButton(action, state, input)
gamepad[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
return Enum.ContextActionResult.Sink
end

function MousePan(action, state, input)
local delta = input.Delta
mouse.Delta = Vector2.new(-delta.y, -delta.x)
return Enum.ContextActionResult.Sink
end

function Thumb(action, state, input)
gamepad[input.KeyCode.Name] = input.Position
return Enum.ContextActionResult.Sink
end

function Trigger(action, state, input)
gamepad[input.KeyCode.Name] = input.Position.z
return Enum.ContextActionResult.Sink
end

function MouseWheel(action, state, input)
mouse[input.UserInputType.Name] = -input.Position.z
return Enum.ContextActionResult.Sink
end

function TeleportAction(action, state, input)
if state == Enum.UserInputState.Begin then
local character = LocalPlayer.Character
if character then
local hrp = character:FindFirstChild("HumanoidRootPart")
if hrp then
character:PivotTo(Camera.CFrame)
if type(FreecamProxy.StopFreecam) == "function" then
FreecamProxy.StopFreecam()
elseif type(_G.StopFreecamFunc) == "function" then
_G.StopFreecamFunc()
end
end
end
end
return Enum.ContextActionResult.Sink
end

function MouseLockToggle(action, state, input)
if state == Enum.UserInputState.Begin then
freecamMouseLocked = not freecamMouseLocked
end
return Enum.ContextActionResult.Sink
end

function Zero(t)
for k, v in pairs(t) do
t[k] = v*0
end
end

function Input.StartCapture()
ContextActionService:BindActionAtPriority("FreecamKeyboard", Keypress, false, INPUT_PRIORITY,
Enum.KeyCode.W, Enum.KeyCode.U,
Enum.KeyCode.A, Enum.KeyCode.H,
Enum.KeyCode.S, Enum.KeyCode.J,
Enum.KeyCode.D, Enum.KeyCode.K,
Enum.KeyCode.E, Enum.KeyCode.I,
Enum.KeyCode.Q, Enum.KeyCode.Y,
Enum.KeyCode.Up, Enum.KeyCode.Down,
Enum.KeyCode.Space
)
ContextActionService:BindActionAtPriority("FreecamMousePan",          MousePan,   false, INPUT_PRIORITY, Enum.UserInputType.MouseMovement)
ContextActionService:BindActionAtPriority("FreecamMouseWheel",        MouseWheel, false, INPUT_PRIORITY, Enum.UserInputType.MouseWheel)
ContextActionService:BindActionAtPriority("FreecamGamepadButton",     GpButton,   false, INPUT_PRIORITY, Enum.KeyCode.ButtonX, Enum.KeyCode.ButtonY)
ContextActionService:BindActionAtPriority("FreecamGamepadTrigger",    Trigger,    false, INPUT_PRIORITY, Enum.KeyCode.ButtonR2, Enum.KeyCode.ButtonL2)
ContextActionService:BindActionAtPriority("FreecamGamepadThumbstick", Thumb,      false, INPUT_PRIORITY, Enum.KeyCode.Thumbstick1, Enum.KeyCode.Thumbstick2)
ContextActionService:BindActionAtPriority("FreecamTeleport",          TeleportAction, false, INPUT_PRIORITY, Enum.KeyCode.T)
ContextActionService:BindActionAtPriority("FreecamMouseLockToggle",   MouseLockToggle, false, INPUT_PRIORITY, Enum.KeyCode.LeftAlt)
ContextActionService:BindActionAtPriority("FreecamDisableRMB",        function() return Enum.ContextActionResult.Sink end, false, INPUT_PRIORITY, Enum.UserInputType.MouseButton2)
end

function Input.StopCapture()
navSpeed = 1
Zero(gamepad)
Zero(keyboard)
Zero(mouse)
ContextActionService:UnbindAction("FreecamKeyboard")
ContextActionService:UnbindAction("FreecamMousePan")
ContextActionService:UnbindAction("FreecamMouseWheel")
ContextActionService:UnbindAction("FreecamGamepadButton")
ContextActionService:UnbindAction("FreecamGamepadTrigger")
ContextActionService:UnbindAction("FreecamGamepadThumbstick")
ContextActionService:UnbindAction("FreecamTeleport")
ContextActionService:UnbindAction("FreecamMouseLockToggle")
ContextActionService:UnbindAction("FreecamDisableRMB")
end
end
end

local function GetFocusDistance(cameraFrame)
local znear = 0.1
local viewport = Camera.ViewportSize
local projy = 2*tan(cameraFov/2)
local projx = viewport.x/viewport.y*projy
local fx = cameraFrame.rightVector
local fy = cameraFrame.upVector
local fz = cameraFrame.lookVector

local minVect = Vector3.new()
local minDist = 512

for x = 0, 1, 0.5 do
for y = 0, 1, 0.5 do
local cx = (x - 0.5)*projx
local cy = (y - 0.5)*projy
local offset = fx*cx - fy*cy + fz
local origin = cameraFrame.p + offset*znear
local part, hit = workspace:FindPartOnRay(Ray.new(origin, offset.unit*minDist))
local dist = (hit - origin).magnitude
if minDist > dist then
minDist = dist
minVect = offset.unit
end
end
end

return fz:Dot(minVect)*minDist
end

local function StepFreecam(dt)
if freecamMouseLocked then
UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
else
UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

local vel = Input.Vel(dt)
local pan = Input.Pan(dt)
local fov = Input.Fov(dt)

local zoomFactor = sqrt(tan(rad(70/2))/tan(rad(cameraFov/2)))

cameraFov = clamp(cameraFov + fov*FOV_GAIN*(dt/zoomFactor), 1, 120)
cameraRot = cameraRot + pan*PAN_GAIN*(dt/zoomFactor)
cameraRot = Vector2.new(clamp(cameraRot.x, -PITCH_LIMIT, PITCH_LIMIT), cameraRot.y%(2*pi))

local moveX = vel.X * NAV_GAIN.X * dt
local moveY = vel.Y * NAV_GAIN.Y * dt
local moveZ = vel.Z * NAV_GAIN.Z * dt

local rotCFrame = CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)
local cameraCFrameXZ = CFrame.new(cameraPos) * rotCFrame * CFrame.new(moveX, 0, moveZ)

cameraPos = cameraCFrameXZ.p + Vector3.new(0, moveY, 0)
local cameraCFrame = CFrame.new(cameraPos) * rotCFrame

Camera.CFrame = cameraCFrame
Camera.Focus = cameraCFrame*CFrame.new(0, 0, -1)
Camera.FieldOfView = cameraFov

local char = LocalPlayer.Character
if char then
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        local moveZ = Input.keyboard.J - Input.keyboard.U
        local moveX = Input.keyboard.K - Input.keyboard.H
        local moveVector = Vector3.new(moveX, 0, moveZ)

        local look = cameraCFrame.LookVector
        look = Vector3.new(look.X, 0, look.Z).Unit
        local right = cameraCFrame.RightVector
        right = Vector3.new(right.X, 0, right.Z).Unit

        local walkDir = Vector3.new()
        if moveVector.Magnitude > 0 then
            walkDir = (look * -moveZ + right * moveX).Unit
        end
        hum:Move(walkDir, false)

        if Input.keyboard.Space == 1 then
            hum.Jump = true
        end
    end
end
end

local PlayerState = {} do
local cameraSubject
local cameraType
local cameraFocus
local cameraCFrame
local cameraFieldOfView
local screenGuis = {}

function PlayerState.Push()
local playergui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
if playergui then
for _, gui in pairs(playergui:GetChildren()) do
if gui:IsA("ScreenGui") and gui.Enabled then
screenGuis[#screenGuis + 1] = gui
gui.Enabled = false
end
end
end

cameraFieldOfView = Camera.FieldOfView
Camera.FieldOfView = 70

cameraType = Camera.CameraType
Camera.CameraType = Enum.CameraType.Custom

cameraSubject = Camera.CameraSubject
Camera.CameraSubject = nil

cameraCFrame = Camera.CFrame
cameraFocus = Camera.Focus

mouseBehavior = UserInputService.MouseBehavior
UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

function PlayerState.Pop()
for _, gui in pairs(screenGuis) do
if gui.Parent then
gui.Enabled = true
end
end

Camera.FieldOfView = cameraFieldOfView
cameraFieldOfView = nil

Camera.CameraType = cameraType
cameraType = nil

Camera.CameraSubject = cameraSubject
cameraSubject = nil

Camera.CFrame = cameraCFrame
cameraCFrame = nil

Camera.Focus = cameraFocus
cameraFocus = nil

UserInputService.MouseBehavior = mouseBehavior
mouseBehavior = nil
end
end

local FreecamUI = nil
local function CreateFreecamUI()
    if FreecamUI then FreecamUI:Destroy() end
    FreecamUI = Instance.new("ScreenGui")
    FreecamUI.Name = "FreecamKeybindsUI"
    FreecamUI.IgnoreGuiInset = true
    pcall(function() FreecamUI.ScreenInsets = Enum.ScreenInsets.None end)
    FreecamUI.DisplayOrder = 999

    local targetParent = game:GetService("CoreGui")
    if not pcall(function() FreecamUI.Parent = targetParent end) then
        targetParent = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        FreecamUI.Parent = targetParent
    end

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 220, 0, 260)
    frame.Position = UDim2.new(0, 10, 0.5, -130)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = FreecamUI

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(100, 100, 100)
    stroke.Thickness = 1
    stroke.Parent = frame

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = frame

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 30)
    title.Text = "  Freecam Keybinds"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.BackgroundTransparency = 1
    title.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.LayoutOrder = 1
    title.Parent = frame

    local binds = {
        "W/A/S/D - Move Cam",
        "E/Q - Move Cam Up/Down",
        "U/H/J/K - Move Player",
        "Space - Jump Player",
        "I - Ragdoll Player",
        "Y - Respawn Player",
        "↑/↓ - Adjust Speed Up/Down",
        "Shift - Slow Speed",
        "Scroll - Adjust FOV",
        "L-Alt - Toggle Mouse Lock",
        "Ctrl+P - Toggle Freecam",
        "T - Teleport Here & Exit"
    }

    for i, bind in ipairs(binds) do
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 18)
        lbl.Text = "    " .. bind
        lbl.TextColor3 = Color3.fromRGB(200, 200, 200)
        lbl.BackgroundTransparency = 1
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.LayoutOrder = i + 1
        lbl.Parent = frame
    end
end

local function StartFreecam()
local cameraCFrame = Camera.CFrame
cameraRot = Vector2.new(cameraCFrame:toEulerAnglesYXZ())
cameraPos = cameraCFrame.p
cameraFov = Camera.FieldOfView

velSpring:Reset(Vector3.new())
panSpring:Reset(Vector2.new())
fovSpring:Reset(0)
freecamMouseLocked = true

PlayerState.Push()
RunService:BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
Input.StartCapture()

if not FreecamUI then
CreateFreecamUI()
end
end

local function StopFreecam()
Input.StopCapture()
RunService:UnbindFromRenderStep("Freecam")
PlayerState.Pop()

if FreecamUI then
FreecamUI:Destroy()
FreecamUI = nil
end
end

do
local enabled = false

local ToggleFreecam, CheckMacro, HandleActivationInput

ToggleFreecam = function()
if enabled then
StopFreecam()
else
StartFreecam()
end
enabled = not enabled
_G.FreecamActive = enabled
UI.Notify("Freecam", "Freecam is now " .. (enabled and "ON" or "OFF"))
end

_G.ToggleFreecamFunc = ToggleFreecam
FreecamProxy.ToggleFreecam = ToggleFreecam

_G.StopFreecamFunc = function()
    if enabled then
        StopFreecam()
        enabled = false
        _G.FreecamActive = false
    end
end
FreecamProxy.StopFreecam = _G.StopFreecamFunc

CheckMacro = function(macro)
for i = 1, #macro - 1 do
if not UserInputService:IsKeyDown(macro[i]) then
return
end
end
if Flags["Settings/Freecam Toggle"] then ToggleFreecam() end
end

HandleActivationInput = function(action, state, input)
if state == Enum.UserInputState.Begin then
if input.KeyCode == FREECAM_MACRO_KB[#FREECAM_MACRO_KB] then
CheckMacro(FREECAM_MACRO_KB)
end
end
return Enum.ContextActionResult.Pass
end

ContextActionService:BindActionAtPriority("FreecamToggle", HandleActivationInput, false, TOGGLE_INPUT_PRIORITY, FREECAM_MACRO_KB[#FREECAM_MACRO_KB])
end
end
___InitializeFreecam()

function Cleanup()

    if delfile and isfile and isfile("Sp3arParvus_Icon.png") then
        pcall(delfile, "Sp3arParvus_Icon.png")
    end

    if type(FreecamProxy.StopFreecam) == "function" then
        pcall(FreecamProxy.StopFreecam)
    elseif type(_G.StopFreecamFunc) == "function" then
        pcall(_G.StopFreecamFunc)
    end
    pcall(function()
        game:GetService("ContextActionService"):UnbindAction("FreecamToggle")
    end)

    Sp3arParvus.Active = false

    for _, conn in pairs(Sp3arParvus.Connections) do
        pcall(function()
            if conn then conn:Disconnect() end
        end)
    end
    table.clear(Sp3arParvus.Connections)

    for _, conn in ipairs(WaypointConnections) do
        pcall(function()
            if conn then conn:Disconnect() end
        end)
    end
    table.clear(WaypointConnections)

    for _, thread in pairs(Sp3arParvus.Threads) do
        pcall(function()
            if thread then task.cancel(thread) end
        end)
    end
    table.clear(Sp3arParvus.Threads)

    if ScreenGui then
        pcall(function() ScreenGui:Destroy() end)
        ScreenGui = nil
    end
    if NotifyGui then
        pcall(function() NotifyGui:Destroy() end)
        NotifyGui = nil
    end
    FovCircleFrame = nil
    table.clear(UIState.Tabs)
    table.clear(UIState.DraggableFrames)
    table.clear(UIState.Updaters)
    UIState.MainFrame = nil
    UIState.ContentArea = nil
    UIState.TabContainer = nil
    UIState.ActiveDraggedFrame = nil
    UIState.DragStart = nil
    UIState.StartPos = nil

    for player, espData in pairs(ESPObjects) do
        pcall(function()
            if espData.Nametag then espData.Nametag:Destroy() end

            if espData.Connections then
                for _, conn in pairs(espData.Connections) do
                    if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
                        conn:Disconnect()
                    end
                end
                table.clear(espData.Connections)
            end
        end)
    end
    table.clear(ESPObjects)

    for player, outlines in pairs(PlayerOutlineObjects) do
        for partName, obj in pairs(outlines) do
            pcall(function() obj:Destroy() end)
        end
    end
    table.clear(PlayerOutlineObjects)

    for _, pool in pairs(ObjectPool) do
        for _, obj in ipairs(pool) do
            PcallDestroy(obj)
        end
        table.clear(pool)
    end
    if PoolFolder then
        pcall(function() PoolFolder:Destroy() end)
        PoolFolder = nil
    end

    for id, wpData in pairs(ActiveWaypoints) do
        pcall(function()
            if wpData.Billboard then wpData.Billboard:Destroy() end
            if wpData.Part then wpData.Part:Destroy() end
        end)
    end
    table.clear(ActiveWaypoints)

    for path, data in pairs(Br3ak3rState.brokenSet) do
        pcall(function()
            local part = data.instance
            if not part or not part.Parent then
                part = RobustResolvePart(path, data)
            end
            if part and part.Parent and type(data) == "table" then
                part.CanCollide = data.cc
                pcall(function() part.CanTouch = data.ct end)
                pcall(function() part.CanQuery = data.cq end)
                part.LocalTransparencyModifier = data.ltm
                part.Transparency = data.t
            end
        end)
    end
    table.clear(Br3ak3rState.brokenSet)
    table.clear(Br3ak3rState.undoStack)
    table.clear(Br3ak3rState.brokenIgnoreCache)
    Br3ak3rState.brokenCacheDirty = true
    Br3ak3rState.CTRL_HELD = false
    Br3ak3rState.LEFT_CTRL_HELD = false

    for part, data in pairs(H1ghl1ght3rState.highlightedSet) do
        pcall(function()
            if part.Parent and type(data) == "table" then
                part.LocalTransparencyModifier = data.ltm
                part.Transparency = data.t
            end
            if type(data) == "table" then
                if data.hl then data.hl:Destroy() end
                if data.bg then data.bg:Destroy() end
            end
        end)
    end
    table.clear(H1ghl1ght3rState.highlightedSet)
    table.clear(H1ghl1ght3rState.undoStack)
    H1ghl1ght3rState.SHIFT_HELD = false

    ClearWorldHumConnections()
    if WorldHumState.selectionHighlight then
        pcall(function() WorldHumState.selectionHighlight:Destroy() end)
    end
    table.clear(WorldHumState.lockedProperties)
    table.clear(WorldHumState.presetsApplied)
    WorldHumState.selectedHum = nil
    WorldHumState.selectionHighlight = nil

    if Br3ak3rState.hoverHL then
        pcall(function() Br3ak3rState.hoverHL:Destroy() end)
        Br3ak3rState.hoverHL = nil
    end

    if FullbrightState.lastState then
        Flags["Visuals/Fullbright"] = false
        Flags["Visuals/FullDark"] = false
        pcall(UpdateLighting)
    end

    if ZoomState.OriginalMax then
        LocalPlayer.CameraMaxZoomDistance = ZoomState.OriginalMax
    end
    if ZoomState.OriginalMin then
        LocalPlayer.CameraMinZoomDistance = ZoomState.OriginalMin
    end

    if HumanoidState.captured then
        local character = LocalPlayer.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            for prop, value in pairs(HumanoidState.originalSettings) do
                pcall(function()
                    humanoid[prop] = value
                end)
            end
        end
        table.clear(HumanoidState.originalSettings)
        HumanoidState.captured = false
        HumanoidState.presetsApplied = false
    end

    AimState.Aim = false
    AimState.LastAimTarget = nil
    CachedTarget = nil
    NearestPlayerRef = nil
    PerformanceLabel = nil
    if InformationDisplayHUD then
        pcall(function() InformationDisplayHUD:Destroy() end)
    end
    InformationDisplayHUD = nil
    InformationDisplayLabel = nil
    ClosestPlayerTrackerLabel = nil
    LocalHealthHUD = nil
    LocalHealthValueLabel = nil

    if AdvancedPlayerPanelUI.MainFrame then
        pcall(function() AdvancedPlayerPanelUI.MainFrame:Destroy() end)
    end
    AdvancedPlayerPanelState.Visible = false
    AdvancedPlayerPanelState.CurrentView = "List"
    AdvancedPlayerPanelState.DetailsTab = "General"
    AdvancedPlayerPanelState.SelectedPlayer = nil
    AdvancedPlayerPanelState.Spectating = nil
    table.clear(AdvancedPlayerPanelState.Whitelist)
    table.clear(AdvancedPlayerPanelState.Blacklist)
    table.clear(AdvancedPlayerPanelState.TeamWhitelist)
    table.clear(AdvancedPlayerPanelState.TeamBlacklist)
    table.clear(AdvancedPlayerPanelState.TeamExpanded)
    table.clear(AdvancedPlayerPanelState.PlayerRowCache)
    AdvancedPlayerPanelUI.MainFrame = nil
    AdvancedPlayerPanelUI.ListFrame = nil
    AdvancedPlayerPanelUI.DetailsFrame = nil
    AdvancedPlayerPanelUI.TeamFrame = nil
    AdvancedPlayerPanelUI.HeaderFrame = nil
    AdvancedPlayerPanelUI.ActionsHeaderFrame = nil
    AdvancedPlayerPanelUI.WhitelistBtn = nil
    AdvancedPlayerPanelUI.BlacklistBtn = nil
    AdvancedPlayerPanelUI.TeleportBtn = nil
    AdvancedPlayerPanelUI.SpectateBtn = nil
    AdvancedPlayerPanelUI.ListBtn = nil
    AdvancedPlayerPanelUI.TeamsBtn = nil
    AdvancedPlayerPanelUI.ListContent = nil
    AdvancedPlayerPanelUI.DetailsContent = nil
    AdvancedPlayerPanelUI.TeamContent = nil
    AdvancedPlayerPanelUI.SearchBox = nil
    table.clear(AdvancedPlayerPanelUI.Entries)
    table.clear(AdvancedPlayerPanelUI.DetailLabels)
    table.clear(AdvancedPlayerPanelUI.TabButtons)
    table.clear(AdvancedPlayerPanelUI.DetailsTabButtons)
    AdvancedPlayerPanelUI.PropertyFrame = nil
    AdvancedPlayerPanelUI.PropertyContent = nil
    AdvancedPlayerPanelUI.PropertySearch = nil

    if ItemPanelUI.MainFrame then
        pcall(function() ItemPanelUI.MainFrame:Destroy() end)
    end
    ItemPanelState.Visible = false
    table.clear(ItemPanelState.lockedProperties)
    ItemPanelState.selectedItem = nil
    table.clear(ItemPanelState.explorerExpanded)
    ItemPanelState.explorerSelected = nil
    ItemPanelUI.MainFrame = nil
    ItemPanelUI.ExplorerContent = nil
    ItemPanelUI.PropertyContent = nil
    ItemPanelUI.PropertyFrame = nil
    ItemPanelUI.PropertySearch = nil

    LocalPlayer.ReplicationFocus = nil
    pcall(function() GuiService:SetGameplayPausedNotificationEnabled(true) end)

    table.clear(PathCache)
    table.clear(ViewportCache)
    table.clear(ViewportPool)
    for p, c in pairs(CharCache) do
        c.Char = nil; c.HumanoidRootPart = nil; c.Root = nil; c.Humanoid = nil; c.HealthInst = nil; c.Squad = nil; c.Head = nil
    end
    table.clear(CharCache)

    for _, entry in ipairs(CandidateList) do
        entry.mag = nil; entry.ply = nil; entry.char = nil; entry.part = nil; entry.sx = nil; entry.sy = nil; entry.pos = nil; entry.realPos = nil
    end
    table.clear(CandidateList)

    table.clear(cachedPlayersList)
    table.clear(Br3ak3rState.brokenIgnoreCache)
    table.clear(Br3ak3rState.scratchIgnore)

    _G.StopFreecamFunc = nil
    local globalEnv = getgenv and getgenv() or _G
    rawset(globalEnv, "Sp3arParvus", nil)

    warn("[Sp3arParvus] Script Unloaded! You can now reload the script.")
end

function Reload()
    UI.Notify("Sp3arParvus", "Reloading script...")
    task.wait(0.1)
    Cleanup()
    task.wait(0.2)
    if isfile and isfile("Sp3arParvus.lua") then
        loadstring(readfile("Sp3arParvus.lua"))()
    elseif isfile and isfile("Sp3arParvus/Sp3arParvus.lua") then
        loadstring(readfile("Sp3arParvus/Sp3arParvus.lua"))()
    else
        loadstring(game:HttpGet("https://raw.githubusercontent.com/JakeHukari/Sp3arParvus/refs/heads/main/Sp3arParvus.lua", true))()
    end
end

function ForceReload()
    UI.Notify("Sp3arParvus", "Fetching and reloading latest script version...")
    task.wait(0.1)
    Cleanup()
    task.wait(0.2)
    loadstring(game:HttpGet("https://raw.githubusercontent.com/JakeHukari/Sp3arParvus/refs/heads/main/Sp3arParvus.lua", true))()
end

local KeyboardRows = {
    {
        {Text = "` ~", Key = "Backquote", Width = 1, KeyCode = Enum.KeyCode.Backquote, Name = "Aimlock Assist Toggle", Action = "Ctrl + ~", Desc = "Toggles camera-lock tracking assistant.", StatusKey = "Aim/AimLock"},
        {Text = "1", Width = 1},
        {Text = "2", Width = 1},
        {Text = "3", Width = 1},
        {Text = "4", Width = 1},
        {Text = "5", Width = 1},
        {Text = "6", Width = 1},
        {Text = "7", Width = 1},
        {Text = "8", Width = 1},
        {Text = "9", Width = 1},
        {Text = "0", Width = 1},
        {Text = "-", Width = 1},
        {Text = "+", Width = 1},
        {Text = "<-", Width = 2},
        {Text = "del", Width = 1}
    },
    {
        {Text = "tab", Width = 1.5},
        {Text = "Q", Key = "Q", Width = 1, KeyCode = Enum.KeyCode.Q, Name = "QTeleport", Action = "Ctrl + Q", Desc = "Teleports player to the mouse position (character face preserved).", StatusKey = "Misc/QTeleport"},
        {Text = "W", Width = 1},
        {Text = "E", Key = "E", Width = 1, KeyCode = Enum.KeyCode.E, Name = "Execute ESP", Action = "Ctrl + E", Desc = "Fetches and runs the external Any-Item-ESP script from GitHub."},
        {Text = "R", Key = "R", Width = 1, KeyCode = Enum.KeyCode.R, Name = "Rejoin / Reload", Action = "Ctrl+R / Ctrl+Shift+R", Desc = "Rejoins server, or unloads and reloads script from GitHub (with Shift)."},
        {Text = "T", Width = 1},
        {Text = "Y", Key = "Y", Width = 1, KeyCode = Enum.KeyCode.Y, Name = "Waypoint Teleport", Action = "Ctrl + Y", Desc = "Teleports player to the most recently created active waypoint."},
        {Text = "U", Key = "U", Width = 1, KeyCode = Enum.KeyCode.U, Name = "Unload Script", Action = "Ctrl + U", Desc = "Unloads the script, removes all UI elements, and cleans up connections."},
        {Text = "I", Width = 1},
        {Text = "O", Width = 1},
        {Text = "P", Key = "P", Width = 1, KeyCode = Enum.KeyCode.P, Name = "Toggle Freecam", Action = "Ctrl + P", Desc = "Toggles cinematic free-camera mode.", StatusKey = "FreecamActive"},
        {Text = "[", Width = 1},
        {Text = "]", Width = 1},
        {Text = "\\", Width = 1.5},
        {Text = "pg up", Width = 1}
    },
    {
        {Text = "caps", Key = "CapsLock", Width = 1.75, KeyCode = Enum.KeyCode.CapsLock, Name = "Open / Close Menu", Action = "CapsLock", Desc = "Opens or closes the main Sp3arParvus menu GUI."},
        {Text = "A", Width = 1},
        {Text = "S", Width = 1},
        {Text = "D", Width = 1},
        {Text = "F", Key = "F", Width = 1, KeyCode = Enum.KeyCode.F, Name = "Toggle Fullbright", Action = "Ctrl + F", Desc = "Toggles full bright lighting, removing shadows.", StatusKey = "Visuals/Fullbright"},
        {Text = "G", Key = "G", Width = 1, KeyCode = Enum.KeyCode.G, Name = "Toggle Ghost Mode", Action = "Ctrl + G", Desc = "Toggles Ghost Mode (character transparency & noclip).", StatusKey = "Settings/GhostMode"},
        {Text = "H", Key = "H", Width = 1, KeyCode = Enum.KeyCode.H, Name = "Toggle Headshot Only", Action = "Ctrl + H", Desc = "Toggles between headshot-only and all-body tracking.", StatusKey = "Aim/HeadshotOnlyState"},
        {Text = "J", Key = "J", Width = 1, KeyCode = Enum.KeyCode.J, Name = "Toggle Item Panel", Action = "Ctrl + J", Desc = "Toggles visibility of the item panel HUD.", StatusKey = "Misc/ItemPanel"},
        {Text = "K", Key = "K", Width = 1, KeyCode = Enum.KeyCode.K, Name = "PlayerPage Shortcut", Action = "Ctrl + K", Desc = "Opens menu and navigates directly to the PlayerPage tab."},
        {Text = "L", Width = 1},
        {Text = ";", Width = 1},
        {Text = "\"", Width = 1},
        {Text = "enter", Width = 2.25},
        {Text = "pg dn", Width = 1}
    },
    {
        {Text = "shift", Key = "Shift", Width = 2.25, KeyCode = Enum.KeyCode.LeftShift, Name = "Shift Modifier", Action = "Shift (Held)", Desc = "Modifies other shortcut actions (e.g. Reload script, clear waypoints)."},
        {Text = "Z", Key = "Z", Width = 1, KeyCode = Enum.KeyCode.Z, Name = "Undo Last Break / Highlight", Action = "Ctrl+Z / Ctrl+Shift+Z", Desc = "Undo last broken collision (Ctrl+Z) or last highlight (Ctrl+Shift+Z)."},
        {Text = "X", Key = "X", Width = 1, KeyCode = Enum.KeyCode.X, Name = "Clear Breaks / Highlights", Action = "Ctrl+X / Ctrl+Shift+X", Desc = "Unbreak all collisions (Ctrl+X) or clear all highlights (Ctrl+Shift+X)."},
        {Text = "C", Width = 1},
        {Text = "V", Width = 1},
        {Text = "B", Key = "B", Width = 1, KeyCode = Enum.KeyCode.B, Name = "Clickbreak State", Action = "Ctrl + B", Desc = "Toggles click-to-break collision debugger (Br3ak3r).", StatusKey = "Br3ak3r/Enabled"},
        {Text = "N", Key = "N", Width = 1, KeyCode = Enum.KeyCode.N, Name = "Toggle FullDark", Action = "Ctrl + N", Desc = "Toggles full dark lighting mode.", StatusKey = "Visuals/FullDark"},
        {Text = "M", Width = 1},
        {Text = ",", Width = 1},
        {Text = ".", Key = "Period", Width = 1, KeyCode = Enum.KeyCode.Period, Name = "Toggle Information Display", Action = "Ctrl + .", Desc = "Toggles the Information Display overlay.", StatusKey = "Visuals/InformationDisplay"},
        {Text = "/", Width = 1},
        {Text = "shift", Width = 1.75},
        {Text = "↑", Key = "Up", Width = 1, KeyCode = Enum.KeyCode.Up, Name = "Position Force Up / Forward", Action = "Ctrl+Up / Ctrl+Shift+Up", Desc = "Forces character position up or forward by the configured distance."},
        {Text = "ins", Width = 1}
    },
    {
        {Text = "ctrl", Key = "Ctrl", Width = 1.25, KeyCode = Enum.KeyCode.LeftControl, Name = "Control Modifier", Action = "Ctrl (Held)", Desc = "Modifier key held to execute script keyboard shortcuts."},
        {Text = "❖", Width = 1.25},
        {Text = "alt", Width = 1.25},
        {Text = "space", Width = 5.5},
        {Text = "alt", Width = 1.25},
        {Text = "fn", Width = 1.25},
        {Text = "ctrl", Width = 1.25},
        {Text = "←", Key = "Left", Width = 1, KeyCode = Enum.KeyCode.Left, Name = "Position Force Left", Action = "Ctrl + Left", Desc = "Forces character position left by the configured distance."},
        {Text = "↓", Key = "Down", Width = 1, KeyCode = Enum.KeyCode.Down, Name = "Position Force Down / Backward", Action = "Ctrl+Down / Ctrl+Shift+Down", Desc = "Forces character position down or backward by the configured distance."},
        {Text = "→", Key = "Right", Width = 1, KeyCode = Enum.KeyCode.Right, Name = "Position Force Right", Action = "Ctrl + Right", Desc = "Forces character position right by the configured distance."}
    }
}

local MouseButtons = {
    MouseButton1 = {
        Key = "MouseButton1",
        Name = "Break / Highlight Part",
        Action = "Ctrl + Click / Ctrl + Shift + Click",
        Desc = "Ctrl+Click breaks target part collision. Ctrl+Shift+Click highlights part.",
        StatusKey = "MouseButton1"
    },
    MouseButton2 = {
        Key = "MouseButton2",
        Name = "Aimlock Assist Hold",
        Action = "Right Click (Held)",
        Desc = "Hold Right Click to track closest target inside FOV radius."
    },
    MouseButton3 = {
        Key = "MouseButton3",
        Name = "Waypoint Controls",
        Action = "Ctrl+MidClick / Ctrl+Shift+MidClick",
        Desc = "Ctrl+MiddleClick creates/deletes waypoint. Ctrl+Shift+MiddleClick clears all waypoints.",
        StatusKey = "MouseButton3"
    },
    MouseWheelUp = {
        Key = "MouseWheelUp",
        Name = "Scroll Undo (Unbreak Last)",
        Action = "Ctrl + Shift + Scroll Up",
        Desc = "While Ctrl+Shift is held, scroll the wheel UP to undo the most recent Br3ak3r break (same as Ctrl+Z). Works even when left-click is unavailable."
    },
    MouseWheelDown = {
        Key = "MouseWheelDown",
        Name = "Scroll Break (Clickbreak)",
        Action = "Ctrl + Shift + Scroll Down",
        Desc = "While Ctrl+Shift is held, scroll the wheel DOWN to break the part collision under your cursor (same as Ctrl+Click Br3ak3r). Works even when left-click is unavailable."
    }
}

function InitializeShortcutsPage(page)

    UI.CreateSection(page, "Shortcuts Legend")

    local legendLabel = Instance.new("TextLabel")
    legendLabel.Size = UDim2.new(1, -10, 0, 90)
    legendLabel.BackgroundTransparency = 1
    legendLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    legendLabel.TextSize = 11
    legendLabel.TextColor3 = UI_THEME.Text
    legendLabel.TextXAlignment = Enum.TextXAlignment.Left
    legendLabel.TextYAlignment = Enum.TextYAlignment.Top
    legendLabel.TextWrapped = true
    legendLabel.Text = "• Teal Keys/Buttons: Have active game shortcuts assigned.\n" ..
                      "• Gray Keys/Buttons: Standard keyboard layout (no shortcut).\n" ..
                      "• Toggles (Active/Inactive): Features like Fullbright (Ctrl+F) or Information Display (Ctrl+.) show active/inactive state inside the tooltip popup in real-time.\n" ..
                      "• Modifiers (Ctrl/Shift): Hold these keys in game to execute actions.\n" ..
                      "• Hover over any highlighted key/button to view its detailed shortcut function."
    legendLabel.Parent = page

    local DemoWrapper = Instance.new("Frame")
    DemoWrapper.Name = "DemoWrapper"
    DemoWrapper.Size = UDim2.new(1, 0, 0, 115)
    DemoWrapper.BackgroundTransparency = 1
    DemoWrapper.Parent = page

    local function updateDemoSize()
        local width = DemoWrapper.AbsoluteSize.X
        if width > 0 then
            DemoWrapper.Size = UDim2.new(1, 0, 0, width / 3.636)
        end
    end
    TrackConnection(DemoWrapper:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateDemoSize))
    task.spawn(function()
        task.wait(0.1)
        updateDemoSize()
    end)

    local KeyboardFrame = Instance.new("Frame")
    KeyboardFrame.Name = "KeyboardFrame"
    KeyboardFrame.Size = UDim2.new(16/20, 0, 5/5.5, 0)
    KeyboardFrame.Position = UDim2.new(0, 0, 0.25/5.5, 0)
    KeyboardFrame.BackgroundTransparency = 1
    KeyboardFrame.Parent = DemoWrapper

    local MouseFrame = Instance.new("Frame")
    MouseFrame.Name = "MouseFrame"
    MouseFrame.Size = UDim2.new(3.5/20, 0, 1, 0)
    MouseFrame.Position = UDim2.new(16.5/20, 0, 0, 0)
    MouseFrame.BackgroundTransparency = 1
    MouseFrame.Parent = DemoWrapper

    local MouseOutline = Instance.new("Frame")
    MouseOutline.Name = "MouseOutline"
    MouseOutline.Size = UDim2.new(1, 0, 1, 0)
    MouseOutline.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    MouseOutline.Parent = MouseFrame
    local mCorner = Instance.new("UICorner"); mCorner.CornerRadius = UDim.new(0.12, 0); mCorner.Parent = MouseOutline
    local mStroke = Instance.new("UIStroke"); mStroke.Color = Color3.fromRGB(0, 180, 80); mStroke.Thickness = 1; mStroke.Parent = MouseOutline

    local tooltipFrame = Instance.new("Frame")
    tooltipFrame.Name = "ShortcutsTooltip"
    tooltipFrame.Size = UDim2.new(0, 280, 0, 0)
    tooltipFrame.AutomaticSize = Enum.AutomaticSize.Y
    tooltipFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    tooltipFrame.Visible = false
    tooltipFrame.ZIndex = 1000
    tooltipFrame.BorderSizePixel = 0
    tooltipFrame.Parent = ScreenGui

    local tCorner = Instance.new("UICorner"); tCorner.CornerRadius = UDim.new(0, 6); tCorner.Parent = tooltipFrame
    local tStroke = Instance.new("UIStroke"); tStroke.Color = UI_THEME.Accent; tStroke.Thickness = 1.5; tStroke.Parent = tooltipFrame
    local tPadding = Instance.new("UIPadding")
    tPadding.PaddingTop = UDim.new(0, 8)
    tPadding.PaddingBottom = UDim.new(0, 8)
    tPadding.PaddingLeft = UDim.new(0, 10)
    tPadding.PaddingRight = UDim.new(0, 10)
    tPadding.Parent = tooltipFrame

    local tLayout = Instance.new("UIListLayout")
    tLayout.Padding = UDim.new(0, 4)
    tLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tLayout.Parent = tooltipFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, 0, 0, 0)
    titleLabel.AutomaticSize = Enum.AutomaticSize.Y
    titleLabel.BackgroundTransparency = 1
    titleLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = UI_THEME.Accent
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextWrapped = true
    titleLabel.Parent = tooltipFrame

    local comboLabel = Instance.new("TextLabel")
    comboLabel.Size = UDim2.new(1, 0, 0, 0)
    comboLabel.AutomaticSize = Enum.AutomaticSize.Y
    comboLabel.BackgroundTransparency = 1
    comboLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    comboLabel.TextSize = 14
    comboLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
    comboLabel.TextXAlignment = Enum.TextXAlignment.Left
    comboLabel.TextWrapped = true
    comboLabel.Parent = tooltipFrame

    local descLabel = Instance.new("TextLabel")
    descLabel.Size = UDim2.new(1, 0, 0, 0)
    descLabel.AutomaticSize = Enum.AutomaticSize.Y
    descLabel.BackgroundTransparency = 1
    descLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    descLabel.TextSize = 11
    descLabel.TextColor3 = UI_THEME.Text
    descLabel.TextXAlignment = Enum.TextXAlignment.Left
    descLabel.TextWrapped = true
    descLabel.Parent = tooltipFrame

    local statusFrame = Instance.new("Frame")
    statusFrame.Size = UDim2.new(1, 0, 0, 16)
    statusFrame.BackgroundTransparency = 1
    statusFrame.Parent = tooltipFrame

    local sLayout = Instance.new("UIListLayout")
    sLayout.FillDirection = Enum.FillDirection.Horizontal
    sLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    sLayout.Padding = UDim.new(0, 6)
    sLayout.Parent = statusFrame

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.fromOffset(8, 8)
    statusDot.Parent = statusFrame
    local sdCorner = Instance.new("UICorner"); sdCorner.CornerRadius = UDim.new(1, 0); sdCorner.Parent = statusDot

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(0.8, 0, 1, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    statusLabel.TextSize = 11
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = statusFrame

    local tooltipActiveConnection = nil

    local function showTooltip(targetButton, keyData)
        titleLabel.Text = (keyData.Key == "MouseButton1" or keyData.Key == "MouseButton2" or keyData.Key == "MouseButton3") and ("🖱  " .. keyData.Name) or ("⌨  " .. keyData.Name)
        comboLabel.Text = "Combo: " .. keyData.Action
        descLabel.Text = keyData.Desc

        if tooltipActiveConnection then
            tooltipActiveConnection:Disconnect()
            tooltipActiveConnection = nil
        end

        local function updateStatus()
            local status = nil
            if keyData.StatusKey then
                if keyData.StatusKey == "FreecamActive" then
                    status = _G.FreecamActive
                elseif keyData.StatusKey == "Misc/ItemPanel" then
                    status = ItemPanelState.Visible
                elseif keyData.StatusKey == "MouseButton1" or keyData.StatusKey == "MouseButton3" then
                    status = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
                else
                    status = Flags[keyData.StatusKey]
                end
            end

            if status ~= nil then
                statusDot.BackgroundColor3 = status and UI_THEME.Success or UI_THEME.Fail
                statusLabel.Text = status and "Active" or "Inactive"
                statusLabel.TextColor3 = status and UI_THEME.Success or UI_THEME.Fail
                statusFrame.Visible = true
            else
                statusFrame.Visible = false
            end

            local btnPos = targetButton.AbsolutePosition
            local btnSize = targetButton.AbsoluteSize
            local tooltipSize = tooltipFrame.AbsoluteSize
            local screenSize = ScreenGui.AbsoluteSize

            local x = btnPos.X + (btnSize.X / 2) - (tooltipSize.X / 2)
            local y = btnPos.Y - tooltipSize.Y - 8

            if x < 10 then x = 10
            elseif x + tooltipSize.X > screenSize.X - 10 then x = screenSize.X - tooltipSize.X - 10 end

            if y < 10 then y = btnPos.Y + btnSize.Y + 8 end

            tooltipFrame.Position = UDim2.fromOffset(x, y)
        end

        updateStatus()
        tooltipFrame.Visible = true
        tooltipActiveConnection = RunService.Heartbeat:Connect(updateStatus)
    end

    local function hideTooltip()
        tooltipFrame.Visible = false
        if tooltipActiveConnection then
            tooltipActiveConnection:Disconnect()
            tooltipActiveConnection = nil
        end
    end

    for rowIndex = 1, 5 do
        local rowFrame = Instance.new("Frame")
        rowFrame.Name = "Row" .. rowIndex
        rowFrame.Size = UDim2.new(1, 0, 0.2, 0)
        rowFrame.Position = UDim2.new(0, 0, (rowIndex - 1) * 0.2, 0)
        rowFrame.BackgroundTransparency = 1
        rowFrame.Parent = KeyboardFrame

        local currentX = 0
        for _, keyData in ipairs(KeyboardRows[rowIndex]) do
            local btn = Instance.new("TextButton")
            btn.Name = keyData.Text
            btn.Text = keyData.Text
            btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            btn.TextSize = 10
            btn.TextColor3 = keyData.Key and Color3.fromRGB(224, 251, 252) or Color3.fromRGB(130, 130, 130)
            btn.BackgroundColor3 = keyData.Key and Color3.fromRGB(0, 95, 115) or Color3.fromRGB(15, 15, 15)
            btn.Size = UDim2.new(keyData.Width / 16, -2, 1, -2)
            btn.Position = UDim2.new(currentX, 1, 0, 1)
            btn.Parent = rowFrame

            local kCorner = Instance.new("UICorner"); kCorner.CornerRadius = UDim.new(0, 4); kCorner.Parent = btn
            local kStroke = Instance.new("UIStroke"); kStroke.Color = Color3.fromRGB(0, 180, 80); kStroke.Thickness = 1; kStroke.Parent = btn

            if keyData.Key then
                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 140, 160)}):Play()
                    showTooltip(btn, keyData)
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 95, 115)}):Play()
                    hideTooltip()
                end)
            else
                btn.MouseEnter:Connect(function()
                    TweenService:Create(btn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
                end)
                btn.MouseLeave:Connect(function()
                    TweenService:Create(btn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
                end)
            end

            currentX = currentX + keyData.Width / 16
        end
    end

    local leftBtn = Instance.new("TextButton")
    leftBtn.Name = "LeftClick"
    leftBtn.Text = "L"
    leftBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    leftBtn.TextSize = 11
    leftBtn.TextColor3 = Color3.fromRGB(224, 251, 252)
    leftBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 115)
    leftBtn.Size = UDim2.new(0.425, -2, 0.45, -2)
    leftBtn.Position = UDim2.new(0.05, 1, 0.05, 1)
    leftBtn.Parent = MouseOutline
    local lCorner = Instance.new("UICorner"); lCorner.CornerRadius = UDim.new(0.2, 0); lCorner.Parent = leftBtn
    local lStroke = Instance.new("UIStroke"); lStroke.Color = Color3.fromRGB(0, 180, 80); lStroke.Thickness = 1; lStroke.Parent = leftBtn

    leftBtn.MouseEnter:Connect(function()
        TweenService:Create(leftBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 140, 160)}):Play()
        showTooltip(leftBtn, MouseButtons.MouseButton1)
    end)
    leftBtn.MouseLeave:Connect(function()
        TweenService:Create(leftBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 95, 115)}):Play()
        hideTooltip()
    end)

    local rightBtn = Instance.new("TextButton")
    rightBtn.Name = "RightClick"
    rightBtn.Text = "R"
    rightBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    rightBtn.TextSize = 11
    rightBtn.TextColor3 = Color3.fromRGB(224, 251, 252)
    rightBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 115)
    rightBtn.Size = UDim2.new(0.425, -2, 0.45, -2)
    rightBtn.Position = UDim2.new(0.525, 1, 0.05, 1)
    rightBtn.Parent = MouseOutline
    local rCorner = Instance.new("UICorner"); rCorner.CornerRadius = UDim.new(0.2, 0); rCorner.Parent = rightBtn
    local rStroke = Instance.new("UIStroke"); rStroke.Color = Color3.fromRGB(0, 180, 80); rStroke.Thickness = 1; rStroke.Parent = rightBtn

    rightBtn.MouseEnter:Connect(function()
        TweenService:Create(rightBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 140, 160)}):Play()
        showTooltip(rightBtn, MouseButtons.MouseButton2)
    end)
    rightBtn.MouseLeave:Connect(function()
        TweenService:Create(rightBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 95, 115)}):Play()
        hideTooltip()
    end)

    local wheelBtn = Instance.new("TextButton")
    wheelBtn.Name = "MiddleClick"
    wheelBtn.Text = ""
    wheelBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 115)
    wheelBtn.Size = UDim2.new(0.08, 0, 0.18, 0)
    wheelBtn.Position = UDim2.new(0.46, 0, 0.12, 0)
    wheelBtn.ZIndex = 5
    wheelBtn.Parent = MouseOutline
    local wCorner = Instance.new("UICorner"); wCorner.CornerRadius = UDim.new(1, 0); wCorner.Parent = wheelBtn
    local wStroke = Instance.new("UIStroke"); wStroke.Color = Color3.fromRGB(0, 180, 80); wStroke.Thickness = 1; wStroke.Parent = wheelBtn

    wheelBtn.MouseEnter:Connect(function()
        TweenService:Create(wheelBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 140, 160)}):Play()
        showTooltip(wheelBtn, MouseButtons.MouseButton3)
    end)
    wheelBtn.MouseLeave:Connect(function()
        TweenService:Create(wheelBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 95, 115)}):Play()
        hideTooltip()
    end)

    -- Scroll Up arrow (Ctrl+ScrollUp = Break)
    local scrollUpBtn = Instance.new("TextButton")
    scrollUpBtn.Name = "ScrollUp"
    scrollUpBtn.Text = "▲"
    scrollUpBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    scrollUpBtn.TextSize = 9
    scrollUpBtn.TextColor3 = Color3.fromRGB(224, 251, 252)
    scrollUpBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 115)
    scrollUpBtn.Size = UDim2.new(0.08, 0, 0.10, 0)
    scrollUpBtn.Position = UDim2.new(0.46, 0, 0.01, 0)
    scrollUpBtn.ZIndex = 5
    scrollUpBtn.Parent = MouseOutline
    local suCorner = Instance.new("UICorner"); suCorner.CornerRadius = UDim.new(0.3, 0); suCorner.Parent = scrollUpBtn
    local suStroke = Instance.new("UIStroke"); suStroke.Color = Color3.fromRGB(0, 180, 80); suStroke.Thickness = 1; suStroke.Parent = scrollUpBtn

    scrollUpBtn.MouseEnter:Connect(function()
        TweenService:Create(scrollUpBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 140, 160)}):Play()
        showTooltip(scrollUpBtn, MouseButtons.MouseWheelUp)
    end)
    scrollUpBtn.MouseLeave:Connect(function()
        TweenService:Create(scrollUpBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 95, 115)}):Play()
        hideTooltip()
    end)

    -- Scroll Down arrow (Ctrl+ScrollDown = Undo)
    local scrollDownBtn = Instance.new("TextButton")
    scrollDownBtn.Name = "ScrollDown"
    scrollDownBtn.Text = "▼"
    scrollDownBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    scrollDownBtn.TextSize = 9
    scrollDownBtn.TextColor3 = Color3.fromRGB(224, 251, 252)
    scrollDownBtn.BackgroundColor3 = Color3.fromRGB(0, 95, 115)
    scrollDownBtn.Size = UDim2.new(0.08, 0, 0.10, 0)
    scrollDownBtn.Position = UDim2.new(0.46, 0, 0.31, 0)
    scrollDownBtn.ZIndex = 5
    scrollDownBtn.Parent = MouseOutline
    local sdCorner = Instance.new("UICorner"); sdCorner.CornerRadius = UDim.new(0.3, 0); sdCorner.Parent = scrollDownBtn
    local sdStroke = Instance.new("UIStroke"); sdStroke.Color = Color3.fromRGB(0, 180, 80); sdStroke.Thickness = 1; sdStroke.Parent = scrollDownBtn

    scrollDownBtn.MouseEnter:Connect(function()
        TweenService:Create(scrollDownBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 140, 160)}):Play()
        showTooltip(scrollDownBtn, MouseButtons.MouseWheelDown)
    end)
    scrollDownBtn.MouseLeave:Connect(function()
        TweenService:Create(scrollDownBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(0, 95, 115)}):Play()
        hideTooltip()
    end)

    local bodyFrame = Instance.new("Frame")
    bodyFrame.Name = "MouseBody"
    bodyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bodyFrame.Size = UDim2.new(0.9, -2, 0.425, -2)
    bodyFrame.Position = UDim2.new(0.05, 1, 0.525, 1)
    bodyFrame.Parent = MouseOutline
    local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0.2, 0); bCorner.Parent = bodyFrame

    local bodyLabel = Instance.new("TextLabel")
    bodyLabel.Size = UDim2.new(1, 0, 1, 0)
    bodyLabel.BackgroundTransparency = 1
    bodyLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    bodyLabel.TextSize = 11
    bodyLabel.TextColor3 = UI_THEME.TextDark
    bodyLabel.Text = "SP"
    bodyLabel.Parent = bodyFrame
end


local Window = UI.CreateWindow("Sp3arParvus")

CreateInformationDisplayHUD(ScreenGui)
CreatePerformanceDisplay(ScreenGui)
CreateLocalHealthHUD(ScreenGui)
CreateClosestPlayerTracker()

local AimTab = UI.CreateTab("Tracking")
local VisualsTab = UI.CreateTab("Visuals")
local HumanoidTab = UI.CreateTab("Humanoid")
WorldHumState.Page = UI.CreateTab("WorldHumanoids")
local PlayerPage = UI.CreateTab("PlayerPage")
InitializePlayerPage(PlayerPage)
local MiscTab = UI.CreateTab("Dev Tools")
local ShortcutsTab = UI.CreateTab("Shortcuts")
InitializeShortcutsPage(ShortcutsTab)

-- Save Modifier: Active-state scanner ───────────────────────────
local function UpdateSaveModifierActive()
    for _, v in pairs(SaveModifierState.Categories) do
        if not v then SaveModifierState.Active = true; return end
    end
    for _, tbl in ipairs({
        SaveModifierState.WhitelistEntries,     SaveModifierState.BlacklistEntries,
        SaveModifierState.TeamWhitelistEntries, SaveModifierState.TeamBlacklistEntries,
        SaveModifierState.PriorityEntries,      SaveModifierState.PresetEntries,
        SaveModifierState.FlagEntries,
    }) do
        for _, v in pairs(tbl) do
            if v == false then SaveModifierState.Active = true; return end
        end
    end
    SaveModifierState.Active = false
end

-- Save Modifier: Build filter table for ConfigManager ────────────
local function BuildSaveFilter()
    UpdateSaveModifierActive()
    if not SaveModifierState.Active then return nil end
    local filter = {}
    local cats   = SaveModifierState.Categories
    local function makeEx(tbl)
        local ex, any = {}, false
        for k, v in pairs(tbl) do if v == false then ex[k] = false; any = true end end
        return any and ex or nil
    end
    if not cats.flags           then filter.flags           = false else local ex = makeEx(SaveModifierState.FlagEntries);          if ex then filter.flagEntries          = ex end end
    if not cats.whitelist       then filter.whitelist       = false else local ex = makeEx(SaveModifierState.WhitelistEntries);      if ex then filter.whitelistEntries      = ex end end
    if not cats.blacklist       then filter.blacklist       = false else local ex = makeEx(SaveModifierState.BlacklistEntries);      if ex then filter.blacklistEntries      = ex end end
    if not cats.teamWhitelist   then filter.teamWhitelist   = false else local ex = makeEx(SaveModifierState.TeamWhitelistEntries);  if ex then filter.teamWhitelistEntries  = ex end end
    if not cats.teamBlacklist   then filter.teamBlacklist   = false else local ex = makeEx(SaveModifierState.TeamBlacklistEntries);  if ex then filter.teamBlacklistEntries  = ex end end
    if not cats.priorityList    then filter.priorityList    = false else local ex = makeEx(SaveModifierState.PriorityEntries);       if ex then filter.priorityEntries       = ex end end
    if not cats.worldHumPresets then filter.worldHumPresets = false else local ex = makeEx(SaveModifierState.PresetEntries);         if ex then filter.presetEntries         = ex end end
    return filter
end

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  Config Tab — Profile Save/Load System UI                        ║
-- ╚══════════════════════════════════════════════════════════════════╝
local function BuildConfigTab(page)
    local THEME = UI_THEME
    local openModifier  -- forward-declared; assigned after overlay is fully built

    -- Helper: thin separator ─────────────────────────────────────────
    local function makeSeparator(parent)
        local sep = Instance.new("Frame")
        sep.Size = UDim2.new(1, 0, 0, 1)
        sep.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        sep.BorderSizePixel  = 0
        sep.Parent = parent
    end

    -- Helper: make a styled info label ──────────────────────────────
    local function makeInfoLabel(parent, text, height)
        height = height or 36
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, height)
        lbl.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
        lbl.BorderSizePixel = 0
        lbl.Text = text
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        lbl.TextSize = 11
        lbl.TextColor3 = THEME.TextDark
        lbl.TextWrapped = true
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = parent
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = lbl
        local p = Instance.new("UIPadding")
        p.PaddingLeft = UDim.new(0, 10)
        p.PaddingRight = UDim.new(0, 10)
        p.PaddingTop = UDim.new(0, 4)
        p.PaddingBottom = UDim.new(0, 4)
        p.Parent = lbl
        return lbl
    end

    -- Helper: make a small icon+text button ─────────────────────────
    local function makeSmallBtn(parent, text, bgColor, textColor, width)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, width or 60, 0, 26)
        btn.BackgroundColor3 = bgColor or THEME.Element
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 11
        btn.TextColor3 = textColor or THEME.Text
        btn.AutoButtonColor = false
        btn.Parent = parent
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 5); c.Parent = btn
        TrackConnection(btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TWEENS.FAST, {BackgroundColor3 = (bgColor or THEME.Element):Lerp(Color3.fromRGB(255,255,255), 0.08)}):Play()
        end))
        TrackConnection(btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TWEENS.FAST, {BackgroundColor3 = bgColor or THEME.Element}):Play()
        end))
        return btn
    end

    -- Helper: TextBox row (for inline naming) ────────────────────────
    local function makeNameInput(parent, placeholderText)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        frame.BorderSizePixel = 0
        frame.Parent = parent
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = frame
        local stroke = Instance.new("UIStroke")
        stroke.Color = THEME.Accent
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0.7
        stroke.Parent = frame
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(1, -20, 1, -4)
        tb.Position = UDim2.new(0, 10, 0, 2)
        tb.BackgroundTransparency = 1
        tb.PlaceholderText = placeholderText or "Profile name..."
        tb.PlaceholderColor3 = THEME.TextDark
        tb.Text = ""
        tb.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        tb.TextSize = 13
        tb.TextColor3 = THEME.Text
        tb.TextXAlignment = Enum.TextXAlignment.Left
        tb.ClearTextOnFocus = false
        tb.Parent = frame
        -- Glow on focus
        TrackConnection(tb.Focused:Connect(function()
            TweenService:Create(stroke, TWEENS.MEDIUM, {Transparency = 0}):Play()
        end))
        TrackConnection(tb.FocusLost:Connect(function()
            TweenService:Create(stroke, TWEENS.MEDIUM, {Transparency = 0.7}):Play()
        end))
        return frame, tb
    end

    -- State ───────────────────────────────────────────────────────────
    local apiAvailable  = ConfigManager.HasFileAPIs()

    -- Content frame (always visible) ───────────────────────────────────
    local expandable = Instance.new("Frame")
    expandable.Size = UDim2.new(1, 0, 0, 0)
    expandable.BackgroundTransparency = 1
    expandable.ClipsDescendants = false
    expandable.Visible = true
    expandable.Parent = page
    local exLayout = Instance.new("UIListLayout")
    exLayout.Padding = UDim.new(0, 5)
    exLayout.SortOrder = Enum.SortOrder.LayoutOrder
    exLayout.Parent = expandable
    TrackConnection(exLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        expandable.Size = UDim2.new(1, 0, 0, exLayout.AbsoluteContentSize.Y)
    end))

    -- ─────────────────────────────────────────────────────────────────
    --  Content of the expandable section
    -- ─────────────────────────────────────────────────────────────────

    -- API unavailable banner (shown only if executor lacks file APIs)
    local apiBanner
    if not apiAvailable then
        apiBanner = Instance.new("Frame")
        apiBanner.Size = UDim2.new(1, 0, 0, 48)
        apiBanner.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
        apiBanner.BorderSizePixel = 0
        apiBanner.Parent = expandable
        local abC = Instance.new("UICorner"); abC.CornerRadius = UDim.new(0, 6); abC.Parent = apiBanner
        local abStroke = Instance.new("UIStroke")
        abStroke.Color = Color3.fromRGB(200, 60, 60)
        abStroke.Thickness = 1
        abStroke.Parent = apiBanner
        local abLabel = Instance.new("TextLabel")
        abLabel.Size = UDim2.fromScale(1, 1)
        abLabel.BackgroundTransparency = 1
        abLabel.Text = "File I/O API is unavailable on this executor.\nConfig saving & loading is disabled."
        abLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        abLabel.TextSize = 11
        abLabel.TextColor3 = Color3.fromRGB(230, 100, 100)
        abLabel.TextWrapped = true
        abLabel.Parent = apiBanner
    end

    -- SECTION: QUICK ACTIONS ────────────────────────────────────────
    local function makeSection(parent, label)
        local s = Instance.new("Frame")
        s.Size = UDim2.new(1, 0, 0, 26)
        s.BackgroundTransparency = 1
        s.Parent = parent
        local sl = Instance.new("TextLabel")
        sl.Size = UDim2.new(1, 0, 1, 0)
        sl.Position = UDim2.new(0, 2, 0, 4)
        sl.BackgroundTransparency = 1
        sl.Text = string.upper(label)
        sl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        sl.TextSize = 11
        sl.TextColor3 = THEME.Accent
        sl.TextXAlignment = Enum.TextXAlignment.Left
        sl.Parent = s
    end

    -- Save Modifier button (opens full-page overlay) ───────────────
    local modOpenBtn = Instance.new("TextButton")
    modOpenBtn.Size = UDim2.new(1, 0, 0, 34)
    modOpenBtn.BackgroundColor3 = Color3.fromRGB(28, 22, 34)
    modOpenBtn.BorderSizePixel = 0
    modOpenBtn.Text = "SAVE MODIFIER  —  Customize what gets saved"
    modOpenBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    modOpenBtn.TextSize = 12
    modOpenBtn.TextColor3 = THEME.Accent
    modOpenBtn.AutoButtonColor = false
    modOpenBtn.Parent = expandable
    local _modBtnC  = Instance.new("UICorner"); _modBtnC.CornerRadius  = UDim.new(0, 6); _modBtnC.Parent  = modOpenBtn
    local _modBtnSt = Instance.new("UIStroke");  _modBtnSt.Color = THEME.Accent; _modBtnSt.Thickness = 1
    _modBtnSt.Transparency = 0.4; _modBtnSt.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; _modBtnSt.Parent = modOpenBtn
    TrackConnection(modOpenBtn.MouseEnter:Connect(function()
        TweenService:Create(modOpenBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(38, 28, 46)}):Play()
        TweenService:Create(_modBtnSt, TWEENS.FAST, {Transparency = 0}):Play()
    end))
    TrackConnection(modOpenBtn.MouseLeave:Connect(function()
        TweenService:Create(modOpenBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(28, 22, 34)}):Play()
        TweenService:Create(_modBtnSt, TWEENS.FAST, {Transparency = 0.4}):Play()
    end))
    TrackConnection(modOpenBtn.MouseButton1Click:Connect(function()
        if openModifier then openModifier() end
    end))
    -- Active badge (amber, shown when SaveModifierState.Active == true)
    local activeModLabel = Instance.new("TextLabel")
    activeModLabel.Size = UDim2.new(1, 0, 0, 20)
    activeModLabel.BackgroundTransparency = 1
    activeModLabel.Text = "Save Modifier active  —  filtered data will be omitted from saves"
    activeModLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    activeModLabel.TextSize = 10
    activeModLabel.TextColor3 = Color3.fromRGB(230, 160, 40)
    activeModLabel.TextXAlignment = Enum.TextXAlignment.Right
    activeModLabel.Visible = false
    activeModLabel.Parent = expandable

    makeSection(expandable, "Quick Actions")

    makeInfoLabel(expandable,
        "Save your current settings as a profile, load existing profiles, or reset everything to the built-in defaults.",
        46)

    -- Name input row for quick save
    local _, saveNameBox = makeNameInput(expandable, "Enter profile name here...")

    -- Save Universal button
    local saveUniversalBtn = Instance.new("TextButton")
    saveUniversalBtn.Size = UDim2.new(1, 0, 0, 36)
    saveUniversalBtn.BackgroundColor3 = THEME.Accent
    saveUniversalBtn.BackgroundTransparency = 0.2
    saveUniversalBtn.BorderSizePixel = 0
    saveUniversalBtn.Text = "Save as Universal Pre-set Profile"
    saveUniversalBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    saveUniversalBtn.TextSize = 13
    saveUniversalBtn.TextColor3 = THEME.Background
    saveUniversalBtn.Parent = expandable
    local sucC = Instance.new("UICorner"); sucC.CornerRadius = UDim.new(0, 6); sucC.Parent = saveUniversalBtn
    local sucStroke = Instance.new("UIStroke"); sucStroke.Color = THEME.Accent; sucStroke.Thickness = 1; sucStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; sucStroke.Parent = saveUniversalBtn

    TrackConnection(saveUniversalBtn.MouseButton1Click:Connect(function()
        TweenService:Create(saveUniversalBtn, TWEENS.INSTANT, {Size = UDim2.new(1, -4, 0, 32)}):Play()
        task.wait(0.05)
        TweenService:Create(saveUniversalBtn, TWEENS.INSTANT, {Size = UDim2.new(1, 0, 0, 36)}):Play()

        if not apiAvailable then
            UI.Notify("Config Unavailable", "writefile API is inaccessible. Saving configs is unavailable on this executor.", 7)
            return
        end
        local name = saveNameBox.Text:match("^%s*(.-)%s*$")
        if name == "" then
            UI.Notify("Invalid Name", "Please enter a profile name before saving.", 4)
            return
        end
        local ok, err = ConfigManager.SaveUniversal(name, BuildSaveFilter())
        if ok then
            UI.Notify("Profile Saved", "Universal profile \"" .. name .. "\" saved successfully.", 5)
            saveNameBox.Text = ""
            task.wait(0.1)
            -- Refresh the profile lists
            if _G._SP3AR_ConfigRefresh then pcall(_G._SP3AR_ConfigRefresh) end
        else
            if err == "writefile API unavailable" then
                UI.Notify("Config Unavailable", "writefile API is inaccessible. Saving configs is unavailable on this executor.", 7)
            else
                UI.Notify("Save Failed", "Could not write profile \"" .. name .. "\". Check executor permissions.", 6)
            end
        end
    end))

    -- Save Per-Game button
    local savePerGameBtn = Instance.new("TextButton")
    savePerGameBtn.Size = UDim2.new(1, 0, 0, 36)
    savePerGameBtn.BackgroundColor3 = Color3.fromRGB(40, 90, 160)
    savePerGameBtn.BackgroundTransparency = 0.1
    savePerGameBtn.BorderSizePixel = 0
    savePerGameBtn.Text = "Save as Per-Game Config  (PlaceId: " .. tostring(game.PlaceId) .. ")"
    savePerGameBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    savePerGameBtn.TextSize = 12
    savePerGameBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    savePerGameBtn.Parent = expandable
    local spgC = Instance.new("UICorner"); spgC.CornerRadius = UDim.new(0, 6); spgC.Parent = savePerGameBtn
    local spgStroke = Instance.new("UIStroke"); spgStroke.Color = Color3.fromRGB(80, 140, 220); spgStroke.Thickness = 1; spgStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; spgStroke.Parent = savePerGameBtn

    TrackConnection(savePerGameBtn.MouseButton1Click:Connect(function()
        TweenService:Create(savePerGameBtn, TWEENS.INSTANT, {Size = UDim2.new(1, -4, 0, 32)}):Play()
        task.wait(0.05)
        TweenService:Create(savePerGameBtn, TWEENS.INSTANT, {Size = UDim2.new(1, 0, 0, 36)}):Play()

        if not apiAvailable then
            UI.Notify("Config Unavailable", "writefile API is inaccessible. Saving configs is unavailable on this executor.", 7)
            return
        end
        local name = saveNameBox.Text:match("^%s*(.-)%s*$")
        if name == "" then
            UI.Notify("Invalid Name", "Please enter a profile name before saving.", 4)
            return
        end
        local ok, err = ConfigManager.SavePerGame(name, BuildSaveFilter())
        if ok then
            UI.Notify("Profile Saved", "Per-Game profile \"" .. name .. "\" saved for PlaceId " .. tostring(game.PlaceId) .. ".", 5)
            saveNameBox.Text = ""
            task.wait(0.1)
            if _G._SP3AR_ConfigRefresh then pcall(_G._SP3AR_ConfigRefresh) end
        else
            if err == "writefile API unavailable" then
                UI.Notify("Config Unavailable", "writefile API is inaccessible. Saving configs is unavailable on this executor.", 7)
            else
                UI.Notify("Save Failed", "Could not write profile \"" .. name .. "\". Check executor permissions.", 6)
            end
        end
    end))

    -- Reset to Defaults button (with confirmation)
    local resetConfirming = false
    local resetTimer = nil
    local resetBtn = Instance.new("TextButton")
    resetBtn.Size = UDim2.new(1, 0, 0, 36)
    resetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    resetBtn.BackgroundTransparency = 0
    resetBtn.BorderSizePixel = 0
    resetBtn.Text = "Reset to Default Config"
    resetBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    resetBtn.TextSize = 13
    resetBtn.TextColor3 = THEME.TextDark
    resetBtn.Parent = expandable
    local rbC = Instance.new("UICorner"); rbC.CornerRadius = UDim.new(0, 6); rbC.Parent = resetBtn
    local rbStroke = Instance.new("UIStroke"); rbStroke.Color = Color3.fromRGB(80, 80, 80); rbStroke.Thickness = 1; rbStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; rbStroke.Parent = resetBtn

    TrackConnection(resetBtn.MouseButton1Click:Connect(function()
        if not resetConfirming then
            resetConfirming = true
            resetBtn.Text = "Confirm Reset? (click again)"
            resetBtn.TextColor3 = Color3.fromRGB(240, 100, 80)
            TweenService:Create(rbStroke, TWEENS.MEDIUM, {Color = Color3.fromRGB(200, 60, 60)}):Play()
            TweenService:Create(resetBtn, TWEENS.MEDIUM, {BackgroundColor3 = Color3.fromRGB(65, 25, 25)}):Play()
            -- Auto-cancel after 4 seconds
            resetTimer = task.delay(4, function()
                resetConfirming = false
                resetBtn.Text = "Reset to Default Config"
                resetBtn.TextColor3 = THEME.TextDark
                TweenService:Create(rbStroke, TWEENS.MEDIUM, {Color = Color3.fromRGB(80, 80, 80)}):Play()
                TweenService:Create(resetBtn, TWEENS.MEDIUM, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            end)
        else
            -- Confirmed
            if resetTimer then task.cancel(resetTimer) end
            resetConfirming = false
            resetBtn.Text = "Reset to Default Config"
            resetBtn.TextColor3 = THEME.TextDark
            TweenService:Create(rbStroke, TWEENS.MEDIUM, {Color = Color3.fromRGB(80, 80, 80)}):Play()
            TweenService:Create(resetBtn, TWEENS.MEDIUM, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}):Play()
            ConfigManager.ResetToDefaults()
            UI.Notify("Defaults Restored", "All settings have been reset to their hardcoded defaults.", 5)
        end
    end))

    -- SECTION: PROFILE LISTS ────────────────────────────────────────
    makeSection(expandable, "Universal Profiles")
    makeInfoLabel(expandable, "Universal profiles load regardless of which game you're in.", 30)

    -- Universal list container
    local universalListFrame = Instance.new("Frame")
    universalListFrame.Size = UDim2.new(1, 0, 0, 0)
    universalListFrame.BackgroundTransparency = 1
    universalListFrame.Parent = expandable
    local ulLayout = Instance.new("UIListLayout")
    ulLayout.Padding = UDim.new(0, 4)
    ulLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ulLayout.Parent = universalListFrame
    TrackConnection(ulLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        universalListFrame.Size = UDim2.new(1, 0, 0, ulLayout.AbsoluteContentSize.Y)
        expandable.Size = UDim2.new(1, 0, 0, exLayout.AbsoluteContentSize.Y)
    end))

    makeSection(expandable, "Per-Game Profiles")
    makeInfoLabel(expandable, "Per-Game profiles only auto-load when a matching game (PlaceId) is detected.", 34)

    -- Per-Game list container
    local pergameListFrame = Instance.new("Frame")
    pergameListFrame.Size = UDim2.new(1, 0, 0, 0)
    pergameListFrame.BackgroundTransparency = 1
    pergameListFrame.Parent = expandable
    local pgLayout = Instance.new("UIListLayout")
    pgLayout.Padding = UDim.new(0, 4)
    pgLayout.SortOrder = Enum.SortOrder.LayoutOrder
    pgLayout.Parent = pergameListFrame
    TrackConnection(pgLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        pergameListFrame.Size = UDim2.new(1, 0, 0, pgLayout.AbsoluteContentSize.Y)
        expandable.Size = UDim2.new(1, 0, 0, exLayout.AbsoluteContentSize.Y)
    end))

    -- Refresh button at bottom
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 0, 30)
    refreshBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "Refresh Profile Lists"
    refreshBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    refreshBtn.TextSize = 12
    refreshBtn.TextColor3 = THEME.TextDark
    refreshBtn.Parent = expandable
    local rBtnC = Instance.new("UICorner"); rBtnC.CornerRadius = UDim.new(0, 6); rBtnC.Parent = refreshBtn

    -- ─────────────────────────────────────────────────────────────────
    --  Build a single profile row
    -- ─────────────────────────────────────────────────────────────────
    local function buildProfileRow(container, profileData, profileType, refreshFn)
        local isCurrentGame = profileData.isPerGame and tostring(profileData.placeId) == tostring(game.PlaceId)

        local rowFrame = Instance.new("Frame")
        rowFrame.Size = UDim2.new(1, 0, 0, 68)
        rowFrame.BackgroundColor3 = Color3.fromRGB(36, 36, 36)
        rowFrame.BorderSizePixel = 0
        rowFrame.Parent = container
        local rowC = Instance.new("UICorner"); rowC.CornerRadius = UDim.new(0, 6); rowC.Parent = rowFrame
        local rowStroke = Instance.new("UIStroke")
        rowStroke.Color = profileData.autoLoad and THEME.Accent or Color3.fromRGB(50, 50, 50)
        rowStroke.Thickness = 1
        rowStroke.Transparency = profileData.autoLoad and 0.3 or 0.8
        rowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        rowStroke.Parent = rowFrame

        -- Name + meta row
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -12, 0, 22)
        nameLabel.Position = UDim2.new(0, 10, 0, 6)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = profileData.name
            .. (isCurrentGame and "  [Current Game]" or "")
            .. (profileData.isPerGame and not isCurrentGame and ("  [PlaceId: " .. tostring(profileData.placeId) .. "]") or "")
        nameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        nameLabel.TextSize = 12
        nameLabel.TextColor3 = isCurrentGame and Color3.fromRGB(120, 200, 255) or THEME.Text
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
        nameLabel.Parent = rowFrame

        -- Auto-load status label
        local autoLabel = Instance.new("TextLabel")
        autoLabel.Size = UDim2.new(1, -12, 0, 14)
        autoLabel.Position = UDim2.new(0, 10, 0, 28)
        autoLabel.BackgroundTransparency = 1
        autoLabel.Text = profileData.autoLoad and "● Auto-Load: ON" or "○ Auto-Load: OFF"
        autoLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        autoLabel.TextSize = 10
        autoLabel.TextColor3 = profileData.autoLoad and THEME.Success or THEME.TextDark
        autoLabel.TextXAlignment = Enum.TextXAlignment.Left
        autoLabel.Parent = rowFrame

        -- Buttons row
        local btnRow = Instance.new("Frame")
        btnRow.Size = UDim2.new(1, -10, 0, 24)
        btnRow.Position = UDim2.new(0, 5, 0, 42)
        btnRow.BackgroundTransparency = 1
        btnRow.Parent = rowFrame
        local btnLayout = Instance.new("UIListLayout")
        btnLayout.FillDirection = Enum.FillDirection.Horizontal
        btnLayout.Padding = UDim.new(0, 4)
        btnLayout.SortOrder = Enum.SortOrder.LayoutOrder
        btnLayout.Parent = btnRow

        -- Load button
        local loadBtn = makeSmallBtn(btnRow, "Load", Color3.fromRGB(30, 80, 40), THEME.Success, 58)
        TrackConnection(loadBtn.MouseButton1Click:Connect(function()
            local ok, nameOrErr = ConfigManager.LoadProfile(profileData.fileName)
            if ok then
                UI.Notify("Profile Loaded", "Profile \"" .. (nameOrErr or profileData.name) .. "\" has been applied.", 5)
            else
                UI.Notify("Load Failed", "Profile \"" .. profileData.name .. "\" could not be parsed. File may be corrupted.", 6)
            end
        end))

        -- Auto-load toggle button
        local autoState = profileData.autoLoad
        local autoBtn = makeSmallBtn(btnRow,
            autoState and "Auto: ON" or "Auto: OFF",
            autoState and Color3.fromRGB(30, 60, 30) or Color3.fromRGB(45, 45, 45),
            autoState and THEME.Success or THEME.TextDark,
            76)
        TrackConnection(autoBtn.MouseButton1Click:Connect(function()
            autoState = not autoState
            local ok, err = ConfigManager.SetAutoLoad(profileData.fileName, autoState)
            if ok then
                autoBtn.Text = autoState and "Auto: ON" or "Auto: OFF"
                autoBtn.BackgroundColor3 = autoState and Color3.fromRGB(30, 60, 30) or Color3.fromRGB(45, 45, 45)
                autoBtn.TextColor3 = autoState and THEME.Success or THEME.TextDark
                autoLabel.Text = autoState and "● Auto-Load: ON" or "○ Auto-Load: OFF"
                autoLabel.TextColor3 = autoState and THEME.Success or THEME.TextDark
                rowStroke.Color = autoState and THEME.Accent or Color3.fromRGB(50, 50, 50)
                rowStroke.Transparency = autoState and 0.3 or 0.8
                if autoState then
                    UI.Notify("Auto-Load Enabled", "Profile \"" .. profileData.name .. "\" will now auto-load on startup.", 5)
                else
                    UI.Notify("Auto-Load Disabled", "Profile \"" .. profileData.name .. "\" will no longer auto-load.", 5)
                end
            else
                UI.Notify("Auto-Load Error", "Could not update auto-load state for \"" .. profileData.name .. "\".", 5)
            end
        end))

        -- Rename button (with inline TextBox)
        local renaming = false
        local renameBtn = makeSmallBtn(btnRow, "Rename", Color3.fromRGB(45, 45, 60), THEME.Text, 62)
        local renameBox = nil
        local renameConfirmBtn = nil

        TrackConnection(renameBtn.MouseButton1Click:Connect(function()
            if renaming then return end
            renaming = true

            rowFrame.Size = UDim2.new(1, 0, 0, 100)
            renameBtn.Text = "Renaming..."
            renameBtn.TextColor3 = THEME.Accent

            -- Inline rename textbox
            local rbFrame, rbBox = makeNameInput(rowFrame, "New name...")
            rbFrame.Position = UDim2.new(0, 5, 0, 70)
            rbFrame.Size = UDim2.new(0.6, -8, 0, 26)
            renameBox = rbBox

            local confirmRenameBtn = makeSmallBtn(rowFrame, "OK", Color3.fromRGB(30, 80, 40), THEME.Success, 46)
            confirmRenameBtn.Position = UDim2.new(0.6, 2, 0, 70)
            confirmRenameBtn.AnchorPoint = Vector2.new(0, 0)

            local cancelRenameBtn = makeSmallBtn(rowFrame, "Cancel", Color3.fromRGB(70, 30, 30), THEME.Fail, 52)
            cancelRenameBtn.Position = UDim2.new(0.6, 52, 0, 70)
            cancelRenameBtn.AnchorPoint = Vector2.new(0, 0)

            TrackConnection(confirmRenameBtn.MouseButton1Click:Connect(function()
                local newName = rbBox.Text:match("^%s*(.-)%s*$")
                if newName == "" then
                    UI.Notify("Invalid Name", "Please enter a new name before confirming.", 4)
                    return
                end
                local ok, oldNameOrErr = ConfigManager.RenameProfile(profileData.fileName, newName, profileType)
                if ok then
                    UI.Notify("Renamed", "Profile \"" .. (oldNameOrErr or profileData.name) .. "\" renamed to \"" .. newName .. "\".", 5)
                    -- Update the row display in-place immediately
                    profileData.name = newName
                    nameLabel.Text = newName
                        .. (isCurrentGame and "  [Current Game]" or "")
                        .. (profileData.isPerGame and not isCurrentGame and ("  [PlaceId: " .. tostring(profileData.placeId) .. "]") or "")
                    -- Collapse the rename UI
                    renaming = false
                    rowFrame.Size = UDim2.new(1, 0, 0, 68)
                    renameBtn.Text = "Rename"
                    renameBtn.TextColor3 = THEME.Text
                    rbFrame:Destroy()
                    confirmRenameBtn:Destroy()
                    cancelRenameBtn:Destroy()
                    -- Deferred full refresh so the filesystem listing catches up
                    task.defer(function()
                        task.wait(0.3)
                        if refreshFn then pcall(refreshFn) end
                    end)
                else
                    UI.Notify("Rename Failed", "Could not rename profile. Check executor permissions.", 6)
                    renaming = false
                    rowFrame.Size = UDim2.new(1, 0, 0, 68)
                    renameBtn.Text = "Rename"
                    renameBtn.TextColor3 = THEME.Text
                    rbFrame:Destroy()
                    confirmRenameBtn:Destroy()
                    cancelRenameBtn:Destroy()
                end
            end))

            TrackConnection(cancelRenameBtn.MouseButton1Click:Connect(function()
                renaming = false
                rowFrame.Size = UDim2.new(1, 0, 0, 68)
                renameBtn.Text = "Rename"
                renameBtn.TextColor3 = THEME.Text
                rbFrame:Destroy()
                confirmRenameBtn:Destroy()
                cancelRenameBtn:Destroy()
            end))
        end))

        -- Overwrite button
        local overwriteConfirming = false
        local overwriteTimer = nil
        local overwriteBtn = makeSmallBtn(btnRow, "Overwrite", Color3.fromRGB(50, 50, 20), Color3.fromRGB(220, 200, 80), 72)
        TrackConnection(overwriteBtn.MouseButton1Click:Connect(function()
            if not overwriteConfirming then
                overwriteConfirming = true
                overwriteBtn.Text = "Confirm?"
                overwriteBtn.BackgroundColor3 = Color3.fromRGB(90, 80, 10)
                overwriteTimer = task.delay(3, function()
                    overwriteConfirming = false
                    overwriteBtn.Text = "Overwrite"
                    overwriteBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 20)
                end)
            else
                if overwriteTimer then task.cancel(overwriteTimer) end
                overwriteConfirming = false
                overwriteBtn.Text = "Overwrite"
                overwriteBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 20)
                local ok, nameOrErr = ConfigManager.OverwriteProfile(profileData.fileName, BuildSaveFilter())
                if ok then
                    UI.Notify("Profile Updated", "Profile \"" .. (nameOrErr or profileData.name) .. "\" has been overwritten with current settings.", 5)
                else
                    UI.Notify("Overwrite Failed", "Could not overwrite profile \"" .. profileData.name .. "\". Check executor permissions.", 6)
                end
            end
        end))

        -- Delete button (with confirm)
        local deleteConfirming = false
        local deleteTimer = nil
        local deleteBtn = makeSmallBtn(btnRow, "Delete", Color3.fromRGB(70, 30, 30), THEME.Fail, 56)

        TrackConnection(deleteBtn.MouseButton1Click:Connect(function()
            if not deleteConfirming then
                deleteConfirming = true
                deleteBtn.Text = "Confirm?"
                deleteBtn.BackgroundColor3 = Color3.fromRGB(140, 40, 40)
                deleteTimer = task.delay(3, function()
                    deleteConfirming = false
                    deleteBtn.Text = "Delete"
                    deleteBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
                end)
            else
                if deleteTimer then task.cancel(deleteTimer) end
                deleteConfirming = false
                local ok, err = ConfigManager.DeleteProfile(profileData.fileName)
                if ok then
                    UI.Notify("Profile Deleted", "Profile \"" .. profileData.name .. "\" has been deleted.", 5)
                    task.wait(0.2)
                    if refreshFn then refreshFn() end
                else
                    UI.Notify("Delete Failed", "Could not delete profile \"" .. profileData.name .. "\".", 6)
                    deleteBtn.Text = "Delete"
                    deleteBtn.BackgroundColor3 = Color3.fromRGB(70, 30, 30)
                end
            end
        end))
    end

    -- ─────────────────────────────────────────────────────────────────
    --  Refresh function — rebuilds both profile lists
    -- ─────────────────────────────────────────────────────────────────
    local function refreshLists()
        -- Clear existing rows
        for _, child in ipairs(universalListFrame:GetChildren()) do
            if not child:IsA("UIListLayout") then child:Destroy() end
        end
        for _, child in ipairs(pergameListFrame:GetChildren()) do
            if not child:IsA("UIListLayout") then child:Destroy() end
        end

        if not apiAvailable then return end

        local uProfiles = ConfigManager.ListProfiles("Universal")
        local pgProfiles = ConfigManager.ListProfiles("PerGame")

        if #uProfiles == 0 then
            local emptyLbl = Instance.new("TextLabel")
            emptyLbl.Size = UDim2.new(1, 0, 0, 28)
            emptyLbl.BackgroundTransparency = 1
            emptyLbl.Text = "No universal profiles saved yet."
            emptyLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            emptyLbl.TextSize = 11
            emptyLbl.TextColor3 = THEME.TextDark
            emptyLbl.Parent = universalListFrame
        else
            for _, prof in ipairs(uProfiles) do
                buildProfileRow(universalListFrame, prof, "Universal", refreshLists)
            end
        end

        if #pgProfiles == 0 then
            local emptyLbl = Instance.new("TextLabel")
            emptyLbl.Size = UDim2.new(1, 0, 0, 28)
            emptyLbl.BackgroundTransparency = 1
            emptyLbl.Text = "No per-game profiles saved yet."
            emptyLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
            emptyLbl.TextSize = 11
            emptyLbl.TextColor3 = THEME.TextDark
            emptyLbl.Parent = pergameListFrame
        else
            for _, prof in ipairs(pgProfiles) do
                buildProfileRow(pergameListFrame, prof, "PerGame", refreshLists)
            end
        end

        -- Recompute heights
        task.wait()
        expandable.Size = UDim2.new(1, 0, 0, exLayout.AbsoluteContentSize.Y)
    end

    -- Register global refresh hook so save buttons can trigger it
    _G._SP3AR_ConfigRefresh = refreshLists

    -- Wire up the refresh button
    TrackConnection(refreshBtn.MouseButton1Click:Connect(function()
        refreshLists()
    end))

    -- Initial population ─────────────────────────────────────────────
    -- Fire API warning notification immediately if file I/O is unavailable
    if not apiAvailable then
        task.delay(1, function()
            UI.Notify("Config Unavailable", "File I/O API inaccessible on this executor. Config saving/loading is disabled.", 8)
        end)
    end
    -- Populate profile lists now that all containers exist
    task.defer(refreshLists)

    -- ─────────────────────────────────────────────────────────────────
    --  Save Modifier Overlay  (full-page takeover, parented to `page`)
    -- ─────────────────────────────────────────────────────────────────
    local modOverlay = Instance.new("Frame")
    modOverlay.Name = "SaveModifierOverlay"
    modOverlay.Size = UDim2.new(1, 0, 0, 0)
    modOverlay.BackgroundColor3 = THEME.Background
    modOverlay.BorderSizePixel = 0
    modOverlay.Visible = false
    modOverlay.ZIndex = 5
    modOverlay.Parent = page
    local _molayout = Instance.new("UIListLayout")
    _molayout.Padding = UDim.new(0, 0)
    _molayout.SortOrder = Enum.SortOrder.LayoutOrder
    _molayout.Parent = modOverlay
    TrackConnection(_molayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        modOverlay.Size = UDim2.new(1, 0, 0, _molayout.AbsoluteContentSize.Y + 12)
    end))

    -- Header ──────────────────────────────────────────────────────
    local modHdr = Instance.new("Frame")
    modHdr.Size = UDim2.new(1, 0, 0, 46)
    modHdr.BackgroundColor3 = Color3.fromRGB(24, 18, 30)
    modHdr.BorderSizePixel = 0
    modHdr.LayoutOrder = 1
    modHdr.Parent = modOverlay
    local modHdrStroke = Instance.new("UIStroke")
    modHdrStroke.Color = THEME.Accent; modHdrStroke.Thickness = 1
    modHdrStroke.Transparency = 0.35; modHdrStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    modHdrStroke.Parent = modHdr
    local modHdrTitle = Instance.new("TextLabel")
    modHdrTitle.Size = UDim2.new(1, -114, 0, 24)
    modHdrTitle.Position = UDim2.new(0, 12, 0, 7)
    modHdrTitle.BackgroundTransparency = 1
    modHdrTitle.Text = "SAVE MODIFIER"
    modHdrTitle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
    modHdrTitle.TextSize = 14
    modHdrTitle.TextColor3 = THEME.Accent
    modHdrTitle.TextXAlignment = Enum.TextXAlignment.Left
    modHdrTitle.Parent = modHdr
    local modHdrSub = Instance.new("TextLabel")
    modHdrSub.Size = UDim2.new(1, -114, 0, 12)
    modHdrSub.Position = UDim2.new(0, 12, 0, 31)
    modHdrSub.BackgroundTransparency = 1
    modHdrSub.Text = "Choose what data is included when saving or overwriting profiles"
    modHdrSub.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    modHdrSub.TextSize = 9
    modHdrSub.TextColor3 = THEME.TextDark
    modHdrSub.TextXAlignment = Enum.TextXAlignment.Left
    modHdrSub.Parent = modHdr
    local modCloseBtn = Instance.new("TextButton")
    modCloseBtn.Size = UDim2.new(0, 96, 0, 28)
    modCloseBtn.Position = UDim2.new(1, -104, 0.5, -14)
    modCloseBtn.BackgroundColor3 = Color3.fromRGB(55, 28, 33)
    modCloseBtn.BorderSizePixel = 0
    modCloseBtn.Text = "Close"
    modCloseBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    modCloseBtn.TextSize = 12
    modCloseBtn.TextColor3 = Color3.fromRGB(240, 100, 110)
    modCloseBtn.AutoButtonColor = false
    modCloseBtn.Parent = modHdr
    local modCloseBtnC = Instance.new("UICorner"); modCloseBtnC.CornerRadius = UDim.new(0, 5); modCloseBtnC.Parent = modCloseBtn
    TrackConnection(modCloseBtn.MouseEnter:Connect(function()
        TweenService:Create(modCloseBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(90, 38, 44)}):Play()
    end))
    TrackConnection(modCloseBtn.MouseLeave:Connect(function()
        TweenService:Create(modCloseBtn, TWEENS.FAST, {BackgroundColor3 = Color3.fromRGB(55, 28, 33)}):Play()
    end))

    -- Amber status bar (visible when modifier is filtering) ────────
    local modStatusBar = Instance.new("Frame")
    modStatusBar.Size = UDim2.new(1, 0, 0, 28)
    modStatusBar.BackgroundColor3 = Color3.fromRGB(44, 33, 7)
    modStatusBar.BorderSizePixel = 0
    modStatusBar.LayoutOrder = 2
    modStatusBar.Visible = false
    modStatusBar.Parent = modOverlay
    local modStatusStroke = Instance.new("UIStroke")
    modStatusStroke.Color = Color3.fromRGB(210, 150, 40)
    modStatusStroke.Thickness = 1; modStatusStroke.Transparency = 0.4
    modStatusStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; modStatusStroke.Parent = modStatusBar
    local modStatusLbl = Instance.new("TextLabel")
    modStatusLbl.Size = UDim2.new(1, -16, 1, 0)
    modStatusLbl.Position = UDim2.new(0, 8, 0, 0)
    modStatusLbl.BackgroundTransparency = 1
    modStatusLbl.Text = "Modifier is active  —  filtered data will be omitted when saving."
    modStatusLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    modStatusLbl.TextSize = 10
    modStatusLbl.TextColor3 = Color3.fromRGB(230, 175, 60)
    modStatusLbl.TextXAlignment = Enum.TextXAlignment.Left
    modStatusLbl.Parent = modStatusBar

    -- Action bar ───────────────────────────────────────────────────
    local modActionBar = Instance.new("Frame")
    modActionBar.Size = UDim2.new(1, 0, 0, 38)
    modActionBar.BackgroundTransparency = 1
    modActionBar.LayoutOrder = 3
    modActionBar.Parent = modOverlay
    local modActionPad = Instance.new("UIPadding")
    modActionPad.PaddingLeft = UDim.new(0, 6); modActionPad.PaddingRight  = UDim.new(0, 6)
    modActionPad.PaddingTop  = UDim.new(0, 5); modActionPad.PaddingBottom = UDim.new(0, 5)
    modActionPad.Parent = modActionBar
    local modActionLayout2 = Instance.new("UIListLayout")
    modActionLayout2.FillDirection = Enum.FillDirection.Horizontal
    modActionLayout2.Padding = UDim.new(0, 6)
    modActionLayout2.SortOrder = Enum.SortOrder.LayoutOrder
    modActionLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
    modActionLayout2.Parent = modActionBar
    local function _makeModActionBtn(parent, text, bg, tc, w)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, w, 0, 26)
        b.BackgroundColor3 = bg; b.BorderSizePixel = 0
        b.Text = text
        b.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        b.TextSize = 11; b.TextColor3 = tc
        b.AutoButtonColor = false; b.Parent = parent
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 5); c.Parent = b
        TrackConnection(b.MouseEnter:Connect(function()
            TweenService:Create(b, TWEENS.FAST, {BackgroundColor3 = bg:Lerp(Color3.fromRGB(255,255,255), 0.10)}):Play()
        end))
        TrackConnection(b.MouseLeave:Connect(function()
            TweenService:Create(b, TWEENS.FAST, {BackgroundColor3 = bg}):Play()
        end))
        return b
    end
    local modSelectAllBtn   = _makeModActionBtn(modActionBar, "Select All",   Color3.fromRGB(28, 68, 34),  THEME.Success,               90)
    local modDeselectAllBtn = _makeModActionBtn(modActionBar, "Deselect All", Color3.fromRGB(60, 38, 14),  Color3.fromRGB(220, 155, 70), 100)
    local modResetBtn       = _makeModActionBtn(modActionBar, "Reset",        Color3.fromRGB(38, 38, 48),  THEME.TextDark,               64)

    -- Info label ───────────────────────────────────────────────────
    local modInfoLbl = makeInfoLabel(modOverlay,
        "Toggle categories and individual entries. Selections persist when you close. Use Save / Overwrite buttons to save with the active filter.", 40)
    modInfoLbl.LayoutOrder = 4

    -- Categories container ─────────────────────────────────────────
    local modCatContainer = Instance.new("Frame")
    modCatContainer.Size = UDim2.new(1, 0, 0, 0)
    modCatContainer.BackgroundTransparency = 1
    modCatContainer.LayoutOrder = 5
    modCatContainer.Parent = modOverlay
    local modCatLayout = Instance.new("UIListLayout")
    modCatLayout.Padding = UDim.new(0, 4)
    modCatLayout.SortOrder = Enum.SortOrder.LayoutOrder
    modCatLayout.Parent = modCatContainer
    local modCatPad = Instance.new("UIPadding")
    modCatPad.PaddingTop = UDim.new(0, 4); modCatPad.PaddingBottom = UDim.new(0, 4)
    modCatPad.Parent = modCatContainer
    TrackConnection(modCatLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        modCatContainer.Size = UDim2.new(1, 0, 0, modCatLayout.AbsoluteContentSize.Y + 8)
    end))

    -- Persist expand state across open/close cycles
    local _modCatExpanded = {}

    -- Helper: build one collapsible category section ───────────────
    local function buildModSection(catKey, catLabel, stateTable, getEntries)
        local secFrame = Instance.new("Frame")
        secFrame.Size = UDim2.new(1, 0, 0, 0)
        secFrame.BackgroundTransparency = 1
        secFrame.Parent = modCatContainer
        local secLayout = Instance.new("UIListLayout")
        secLayout.Padding = UDim.new(0, 0)
        secLayout.SortOrder = Enum.SortOrder.LayoutOrder
        secLayout.Parent = secFrame
        TrackConnection(secLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            secFrame.Size = UDim2.new(1, 0, 0, secLayout.AbsoluteContentSize.Y)
        end))

        -- Section header row
        local hdr = Instance.new("Frame")
        hdr.Size = UDim2.new(1, 0, 0, 36)
        hdr.BackgroundColor3 = Color3.fromRGB(30, 28, 36)
        hdr.BorderSizePixel = 0; hdr.LayoutOrder = 1
        hdr.Parent = secFrame
        local hdrC = Instance.new("UICorner"); hdrC.CornerRadius = UDim.new(0, 6); hdrC.Parent = hdr
        local hdrStroke = Instance.new("UIStroke")
        hdrStroke.Color = SaveModifierState.Categories[catKey] and THEME.Accent or Color3.fromRGB(55, 55, 60)
        hdrStroke.Thickness = 1; hdrStroke.Transparency = 0.6
        hdrStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; hdrStroke.Parent = hdr

        -- Master toggle circle
        local masterTog = Instance.new("TextButton")
        masterTog.Size = UDim2.new(0, 18, 0, 18)
        masterTog.Position = UDim2.new(0, 8, 0.5, -9)
        masterTog.BackgroundColor3 = SaveModifierState.Categories[catKey] and THEME.Accent or Color3.fromRGB(48, 48, 55)
        masterTog.BorderSizePixel = 0; masterTog.Text = ""; masterTog.AutoButtonColor = false
        masterTog.Parent = hdr
        local masterTogC = Instance.new("UICorner"); masterTogC.CornerRadius = UDim.new(0, 3); masterTogC.Parent = masterTog
        local masterCheck = Instance.new("TextLabel")
        masterCheck.Size = UDim2.fromScale(1, 1); masterCheck.BackgroundTransparency = 1
        masterCheck.Text = SaveModifierState.Categories[catKey] and "✓" or ""
        masterCheck.FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
        masterCheck.TextSize = 10; masterCheck.TextColor3 = THEME.Background
        masterCheck.Parent = masterTog

        -- Title
        local titleLbl = Instance.new("TextLabel")
        titleLbl.Size = UDim2.new(0.5, -34, 1, 0); titleLbl.Position = UDim2.new(0, 32, 0, 0)
        titleLbl.BackgroundTransparency = 1; titleLbl.Text = catLabel
        titleLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        titleLbl.TextSize = 12
        titleLbl.TextColor3 = SaveModifierState.Categories[catKey] and THEME.Text or THEME.TextDark
        titleLbl.TextXAlignment = Enum.TextXAlignment.Left
        titleLbl.TextTruncate = Enum.TextTruncate.AtEnd; titleLbl.Parent = hdr

        -- Entry count
        local countLbl = Instance.new("TextLabel")
        countLbl.Size = UDim2.new(0.3, 0, 1, 0); countLbl.Position = UDim2.new(0.5, 0, 0, 0)
        countLbl.BackgroundTransparency = 1; countLbl.Text = "—"
        countLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        countLbl.TextSize = 10; countLbl.TextColor3 = THEME.TextDark
        countLbl.TextXAlignment = Enum.TextXAlignment.Center; countLbl.Parent = hdr

        -- Expand arrow
        local arrowBtn = Instance.new("TextButton")
        arrowBtn.Size = UDim2.new(0, 30, 0, 30); arrowBtn.Position = UDim2.new(1, -34, 0.5, -15)
        arrowBtn.BackgroundTransparency = 1; arrowBtn.BorderSizePixel = 0
        arrowBtn.Text = _modCatExpanded[catKey] and "▼" or "▶"
        arrowBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        arrowBtn.TextSize = 10; arrowBtn.TextColor3 = THEME.TextDark; arrowBtn.AutoButtonColor = false
        arrowBtn.Parent = hdr

        -- Entries frame
        local entriesFrame = Instance.new("Frame")
        entriesFrame.Size = UDim2.new(1, 0, 0, 0)
        entriesFrame.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        entriesFrame.BorderSizePixel = 0; entriesFrame.LayoutOrder = 2
        entriesFrame.Visible = _modCatExpanded[catKey] == true; entriesFrame.Parent = secFrame
        local entriesLayout = Instance.new("UIListLayout")
        entriesLayout.Padding = UDim.new(0, 0); entriesLayout.SortOrder = Enum.SortOrder.LayoutOrder
        entriesLayout.Parent = entriesFrame
        local entriesPad = Instance.new("UIPadding")
        entriesPad.PaddingLeft = UDim.new(0, 28); entriesPad.PaddingRight = UDim.new(0, 8)
        entriesPad.PaddingTop = UDim.new(0, 2); entriesPad.PaddingBottom = UDim.new(0, 4)
        entriesPad.Parent = entriesFrame
        local entriesC = Instance.new("UICorner"); entriesC.CornerRadius = UDim.new(0, 4); entriesC.Parent = entriesFrame
        TrackConnection(entriesLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            entriesFrame.Size = UDim2.new(1, 0, 0, entriesLayout.AbsoluteContentSize.Y + 6)
        end))

        local function setExpanded(v)
            _modCatExpanded[catKey] = v
            arrowBtn.Text = v and "▼" or "▶"
            entriesFrame.Visible = v
        end
        TrackConnection(arrowBtn.MouseButton1Click:Connect(function() setExpanded(not _modCatExpanded[catKey]) end))

        local function updateHdrVisuals(enabled)
            TweenService:Create(masterTog, TWEENS.FAST, {BackgroundColor3 = enabled and THEME.Accent or Color3.fromRGB(48, 48, 55)}):Play()
            masterCheck.Text = enabled and "✓" or ""
            titleLbl.TextColor3 = enabled and THEME.Text or THEME.TextDark
            hdrStroke.Color = enabled and THEME.Accent or Color3.fromRGB(55, 55, 60)
        end

        local rebuildEntries  -- forward-declared

        TrackConnection(masterTog.MouseButton1Click:Connect(function()
            local newState = not SaveModifierState.Categories[catKey]
            SaveModifierState.Categories[catKey] = newState
            if newState then for k in pairs(stateTable) do stateTable[k] = nil end end
            updateHdrVisuals(newState)
            UpdateSaveModifierActive()
            modStatusBar.Visible = SaveModifierState.Active
            if rebuildEntries then pcall(rebuildEntries) end
        end))

        rebuildEntries = function()
            for _, child in ipairs(entriesFrame:GetChildren()) do
                if not child:IsA("UIListLayout") and not child:IsA("UIPadding") and not child:IsA("UICorner") then
                    child:Destroy()
                end
            end
            local entries  = getEntries()
            local total    = #entries
            local selCnt   = 0
            local catOn    = SaveModifierState.Categories[catKey]

            if total == 0 then
                local emptyLbl = Instance.new("TextLabel")
                emptyLbl.Size = UDim2.new(1, 0, 0, 26)
                emptyLbl.BackgroundTransparency = 1
                emptyLbl.Text = "No entries saved in this category."
                emptyLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                emptyLbl.TextSize = 10; emptyLbl.TextColor3 = THEME.TextDark
                emptyLbl.TextXAlignment = Enum.TextXAlignment.Left
                emptyLbl.Parent = entriesFrame
                countLbl.Text = "0 / 0"
                updateHdrVisuals(catOn)
                return
            end

            for _, entry in ipairs(entries) do
                local eKey = tostring(entry.key)
                local isSel = catOn and (stateTable[eKey] ~= false)
                if isSel then selCnt += 1 end

                local rowFrame = Instance.new("TextButton")
                rowFrame.Size = UDim2.new(1, 0, 0, 28); rowFrame.BackgroundTransparency = 1
                rowFrame.BorderSizePixel = 0; rowFrame.Text = ""; rowFrame.AutoButtonColor = false; rowFrame.Parent = entriesFrame
                rowFrame.Selectable = false; rowFrame.Active = true

                local eTog = Instance.new("Frame")
                eTog.Size = UDim2.new(0, 14, 0, 14); eTog.Position = UDim2.new(0, 0, 0.5, -7)
                eTog.BackgroundColor3 = isSel and THEME.Accent or Color3.fromRGB(48, 48, 55)
                eTog.BorderSizePixel = 0; eTog.Parent = rowFrame
                local eTogC = Instance.new("UICorner"); eTogC.CornerRadius = UDim.new(0, 0); eTogC.Parent = eTog
                local eCheck = Instance.new("TextLabel")
                eCheck.Size = UDim2.fromScale(1, 1); eCheck.BackgroundTransparency = 1
                eCheck.Text = isSel and "✓" or ""; eCheck.TextSize = 8
                eCheck.FontFace = Font.fromName("Montserrat", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
                eCheck.TextColor3 = THEME.Background; eCheck.Parent = eTog

                local eLbl = Instance.new("TextLabel")
                eLbl.Size = UDim2.new(1, -20, 1, 0); eLbl.Position = UDim2.new(0, 20, 0, 0)
                eLbl.BackgroundTransparency = 1; eLbl.Text = entry.label
                eLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
                eLbl.TextSize = 11; eLbl.TextColor3 = isSel and THEME.Text or THEME.TextDark
                eLbl.TextXAlignment = Enum.TextXAlignment.Left
                eLbl.TextTruncate = Enum.TextTruncate.AtEnd; eLbl.Parent = rowFrame

                -- Capture mutable refs for closure
                local capKey, capTog, capChk, capLbl = eKey, eTog, eCheck, eLbl
                TrackConnection(rowFrame.MouseButton1Click:Connect(function()
                    if not SaveModifierState.Categories[catKey] then return end
                    local cur = stateTable[capKey] ~= false
                    if cur then
                        stateTable[capKey] = false
                    else
                        stateTable[capKey] = nil
                    end
                    local newSel = stateTable[capKey] ~= false
                    TweenService:Create(capTog, TWEENS.FAST, {BackgroundColor3 = newSel and THEME.Accent or Color3.fromRGB(48, 48, 55)}):Play()
                    capChk.Text = newSel and "✓" or ""
                    capLbl.TextColor3 = newSel and THEME.Text or THEME.TextDark
                    -- Recount
                    local cnt = 0
                    for _, e in ipairs(entries) do
                        if stateTable[tostring(e.key)] ~= false then cnt += 1 end
                    end
                    countLbl.Text = tostring(cnt) .. " / " .. tostring(total)
                    UpdateSaveModifierActive()
                    modStatusBar.Visible = SaveModifierState.Active
                end))
            end
            countLbl.Text = tostring(selCnt) .. " / " .. tostring(total)
            updateHdrVisuals(catOn)
        end

        return rebuildEntries
    end

    -- Instantiate all 7 category sections ──────────────────────────
    local _PS = game:GetService("Players")
    local function _pname(uid)
        local ok, pl = pcall(function() return _PS:GetPlayerByUserId(tonumber(uid) or 0) end)
        return (ok and pl) and pl.Name or ("User #" .. tostring(uid))
    end

    local _modRebuilders = {}

    table.insert(_modRebuilders, buildModSection("whitelist",  "Player Whitelist",
        SaveModifierState.WhitelistEntries, function()
            local out = {}
            for uid, v in pairs(AdvancedPlayerPanelState.Whitelist) do
                if v then table.insert(out, {key = tostring(uid), label = _pname(uid)}) end
            end; return out
        end))

    table.insert(_modRebuilders, buildModSection("blacklist",  "Player Blacklist",
        SaveModifierState.BlacklistEntries, function()
            local out = {}
            for uid, v in pairs(AdvancedPlayerPanelState.Blacklist) do
                if v then table.insert(out, {key = tostring(uid), label = _pname(uid)}) end
            end; return out
        end))

    table.insert(_modRebuilders, buildModSection("teamWhitelist", "Team Whitelist",
        SaveModifierState.TeamWhitelistEntries, function()
            local out = {}
            for tName, v in pairs(AdvancedPlayerPanelState.TeamWhitelist) do
                if v then table.insert(out, {key = tName, label = "Team: " .. tName}) end
            end; return out
        end))

    table.insert(_modRebuilders, buildModSection("teamBlacklist", "Team Blacklist",
        SaveModifierState.TeamBlacklistEntries, function()
            local out = {}
            for tName, v in pairs(AdvancedPlayerPanelState.TeamBlacklist) do
                if v then table.insert(out, {key = tName, label = "Team: " .. tName}) end
            end; return out
        end))

    table.insert(_modRebuilders, buildModSection("priorityList", "Priority List",
        SaveModifierState.PriorityEntries, function()
            local out = {}
            for i, item in ipairs(AdvancedPlayerPanelState.PriorityList) do
                table.insert(out, {key = tostring(i), label = "#" .. i .. "  " .. item.type .. ": " .. tostring(item.value)})
            end; return out
        end))

    table.insert(_modRebuilders, buildModSection("worldHumPresets", "Humanoid Presets",
        SaveModifierState.PresetEntries, function()
            local out = {}
            for _, preset in ipairs(WorldHumState.Presets) do
                local pid = tostring(preset.Id or "")
                local lbl = (preset.TargetName or "Unnamed") .. "  [" .. (preset.TargetMode or "?") .. "]"
                table.insert(out, {key = pid, label = lbl})
            end; return out
        end))

    table.insert(_modRebuilders, buildModSection("flags", "Flags / Settings",
        SaveModifierState.FlagEntries, function()
            local seen, out = {}, {}
            for k in pairs(USER_MODIFIED_FLAGS) do
                if not k:match("/Locked$") and not seen[k] then
                    seen[k] = true
                    local val = Flags[k]
                    table.insert(out, {key = k, label = k .. "  =  " .. (type(val) == "table" and "{…}" or tostring(val))})
                end
            end
            for k in pairs(PROFILE_LOADED_FLAGS) do
                if not k:match("/Locked$") and not seen[k] then
                    seen[k] = true
                    local val = Flags[k]
                    table.insert(out, {key = k, label = k .. "  =  " .. (type(val) == "table" and "{…}" or tostring(val))})
                end
            end
            table.sort(out, function(a, b) return a.key < b.key end)
            return out
        end))

    -- Refresh all sections (called on each open)
    local function _rebuildModifierContent()
        for _, fn in ipairs(_modRebuilders) do pcall(fn) end
        UpdateSaveModifierActive()
        modStatusBar.Visible = SaveModifierState.Active
    end

    -- Badge updater (called on close, updates Config page button/label) ──
    local function _updateConfigBadges()
        UpdateSaveModifierActive()
        local active = SaveModifierState.Active
        activeModLabel.Visible = active
        modOpenBtn.Text = active
            and "SAVE MODIFIER  —  Modifier Active"
            or  "SAVE MODIFIER  —  Customize what gets saved"
        modOpenBtn.TextColor3 = active and Color3.fromRGB(230, 160, 40) or THEME.Accent
        _modBtnSt.Color = active and Color3.fromRGB(230, 160, 40) or THEME.Accent
    end
    _G._SP3AR_ModBadgeUpdate = _updateConfigBadges

    -- Close handler ────────────────────────────────────────────────
    local function _closeModifier()
        modOverlay.Visible = false
        expandable.Visible = true
        _updateConfigBadges()
    end
    TrackConnection(modCloseBtn.MouseButton1Click:Connect(_closeModifier))

    -- Bulk action handlers ─────────────────────────────────────────
    local _allEntryTables = {
        SaveModifierState.WhitelistEntries,     SaveModifierState.BlacklistEntries,
        SaveModifierState.TeamWhitelistEntries, SaveModifierState.TeamBlacklistEntries,
        SaveModifierState.PriorityEntries,      SaveModifierState.PresetEntries,
        SaveModifierState.FlagEntries,
    }
    TrackConnection(modSelectAllBtn.MouseButton1Click:Connect(function()
        for k in pairs(SaveModifierState.Categories) do SaveModifierState.Categories[k] = true end
        for _, t in ipairs(_allEntryTables) do for k in pairs(t) do t[k] = nil end end
        _rebuildModifierContent()
    end))
    TrackConnection(modDeselectAllBtn.MouseButton1Click:Connect(function()
        for k in pairs(SaveModifierState.Categories) do SaveModifierState.Categories[k] = false end
        for _, t in ipairs(_allEntryTables) do for k in pairs(t) do t[k] = nil end end
        _rebuildModifierContent()
    end))
    TrackConnection(modResetBtn.MouseButton1Click:Connect(function()
        for k in pairs(SaveModifierState.Categories) do SaveModifierState.Categories[k] = true end
        for _, t in ipairs(_allEntryTables) do for k in pairs(t) do t[k] = nil end end
        _rebuildModifierContent()
    end))

    -- Assign openModifier (forward-declared at top of BuildConfigTab) ──
    openModifier = function()
        expandable.Visible = false
        modOverlay.Visible = true
        pcall(function() page.CanvasPosition = Vector2.zero end)
        _rebuildModifierContent()
    end
end

local ConfigTab = UI.CreateTab("Config")
BuildConfigTab(ConfigTab)

local function ShowPresetEditor(page, preset, isNew)
    WorldHumState.SubPage = "Editor"
    for _, child in ipairs(page:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end

    local draft = {
        TargetName = preset and preset.TargetName or "",
        TargetMode = preset and preset.TargetMode or "Closest Only",
        TargetCount = preset and preset.TargetCount or 1,
        UpdateRate = preset and preset.UpdateRate or 2.0,
        Properties = {}
    }
    
    if preset and preset.Properties then
        for k, v in pairs(preset.Properties) do draft.Properties[k] = v end
    else
        draft.Properties = {}
    end

    local draftUpdaters = {}

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 24)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = page

    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(0, 80, 0, 24)
    backBtn.BackgroundColor3 = UI_THEME.Element
    backBtn.Text = "← Back"
    backBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    backBtn.TextSize = 12
    backBtn.TextColor3 = UI_THEME.Text
    backBtn.Parent = headerFrame
    local bC = Instance.new("UICorner"); bC.CornerRadius = UDim.new(0, 4); bC.Parent = backBtn
    TrackWorldHumConnection(backBtn.MouseButton1Click:Connect(function()
        ShowPresetManager(page)
    end))

    local function CreatePresetToggle(pg, text, prop)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 36)
        Frame.BackgroundColor3 = UI_THEME.Element
        Frame.BorderSizePixel = 0
        Frame.Parent = pg
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.7, -30, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        Label.TextSize = 13
        Label.TextColor3 = UI_THEME.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 44, 0, 22)
        Switch.AnchorPoint = Vector2.new(1, 0.5)
        Switch.Position = UDim2.new(1, -12, 0.5, 0)
        Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        Switch.Parent = Frame
        local swCorner = Instance.new("UICorner"); swCorner.CornerRadius = UDim.new(1, 0); swCorner.Parent = Switch

        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 18, 0, 18)
        Knob.AnchorPoint = Vector2.new(0, 0.5)
        Knob.Position = UDim2.new(0, 2, 0.5, 0)
        Knob.BackgroundColor3 = Color3.new(1, 1, 1)
        Knob.Parent = Switch
        local kbCorner = Instance.new("UICorner"); kbCorner.CornerRadius = UDim.new(1, 0); kbCorner.Parent = Knob

        local Button = Instance.new("TextButton")
        Button.Size = UDim2.new(1, 0, 1, 0)
        Button.BackgroundTransparency = 1
        Button.Text = ""
        Button.Parent = Switch

        local function updateVisuals(state)
            if state == nil then
                TweenService:Create(Switch, TWEENS.MEDIUM, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
                TweenService:Create(Knob, TWEENS.SMOOTH, {Position = UDim2.new(0.5, -9, 0.5, 0)}):Play()
            else
                TweenService:Create(Switch, TWEENS.MEDIUM, {BackgroundColor3 = state and UI_THEME.Accent or Color3.fromRGB(50, 50, 50)}):Play()
                TweenService:Create(Knob, TWEENS.SMOOTH, {Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
            end
        end
        draftUpdaters[prop] = updateVisuals

        TrackWorldHumConnection(Button.MouseButton1Click:Connect(function()
            if draft.Properties[prop] == nil then
                draft.Properties[prop] = true
            elseif draft.Properties[prop] == true then
                draft.Properties[prop] = false
            else
                draft.Properties[prop] = nil
            end
            updateVisuals(draft.Properties[prop])
        end))
        updateVisuals(draft.Properties[prop])
    end

    local function CreatePresetNumeric(pg, text, prop, min, max, step)
        local Frame = Instance.new("Frame")
        Frame.Size = UDim2.new(1, 0, 0, 48)
        Frame.BackgroundColor3 = UI_THEME.Element
        Frame.BorderSizePixel = 0
        Frame.Parent = pg
        local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = Frame

        local Label = Instance.new("TextLabel")
        Label.Size = UDim2.new(0.6, -42, 1, 0)
        Label.Position = UDim2.new(0, 12, 0, 0)
        Label.BackgroundTransparency = 1
        Label.Text = text
        Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        Label.TextSize = 13
        Label.TextColor3 = UI_THEME.Text
        Label.TextXAlignment = Enum.TextXAlignment.Left
        Label.Parent = Frame

        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(0.4, -12, 0, 30)
        InputFrame.Position = UDim2.new(1, -12, 0.5, 0)
        InputFrame.AnchorPoint = Vector2.new(1, 0.5)
        InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        InputFrame.Parent = Frame
        local ifCorner = Instance.new("UICorner"); ifCorner.CornerRadius = UDim.new(0, 4); ifCorner.Parent = InputFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1, -50, 1, 0)
        Input.Position = UDim2.new(0, 25, 0, 0)
        Input.BackgroundTransparency = 1
        Input.Text = draft.Properties[prop] ~= nil and tostring(math.floor(draft.Properties[prop] * 100) / 100) or ""
        Input.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Input.TextSize = 13
        Input.TextColor3 = UI_THEME.Accent
        Input.ClearTextOnFocus = false
        Input.Parent = InputFrame

        draftUpdaters[prop] = function(v)
            Input.Text = v ~= nil and tostring(math.floor(v * 100) / 100) or ""
        end

        local function updateValueStepped(val)
            if type(val) == "string" and val:match("^%s*$") then
                draft.Properties[prop] = nil
                Input.Text = ""
                return
            end
            val = math.clamp(tonumber(val) or (draft.Properties[prop] or min), min, max)
            if step and step > 0 then val = math.floor(val / step + 0.5) * step end
            draft.Properties[prop] = val
            Input.Text = tostring(math.floor(val * 100) / 100)
        end
        local function updateValueFree(val)
            if type(val) == "string" and val:match("^%s*$") then
                draft.Properties[prop] = nil
                Input.Text = ""
                return
            end
            val = math.clamp(tonumber(val) or (draft.Properties[prop] or min), min, max)
            draft.Properties[prop] = val
            Input.Text = tostring(math.floor(val * 100) / 100)
        end
        TrackWorldHumConnection(Input.FocusLost:Connect(function() updateValueFree(Input.Text) end))

        local mBtn = Instance.new("TextButton")
        mBtn.Size = UDim2.new(0, 25, 1, 0)
        mBtn.BackgroundTransparency = 1
        mBtn.Text = "-"
        mBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        mBtn.TextSize = 16
        mBtn.TextColor3 = UI_THEME.TextDark
        mBtn.Parent = InputFrame
        TrackWorldHumConnection(mBtn.MouseButton1Click:Connect(function() updateValueStepped((draft.Properties[prop] or min) - (step or 1)) end))

        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(0, 25, 1, 0)
        pBtn.Position = UDim2.new(1, -25, 0, 0)
        pBtn.BackgroundTransparency = 1
        pBtn.Text = "+"
        pBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        pBtn.TextSize = 16
        pBtn.TextColor3 = UI_THEME.TextDark
        pBtn.Parent = InputFrame
        TrackWorldHumConnection(pBtn.MouseButton1Click:Connect(function() updateValueStepped((draft.Properties[prop] or min) + (step or 1)) end))
    end

    local function makeInputRow(pg, labelText, defaultVal, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundColor3 = UI_THEME.Element
        frame.BorderSizePixel = 0
        frame.Parent = pg
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = frame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        lbl.TextSize = 13
        lbl.TextColor3 = UI_THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local boxFrame = Instance.new("Frame")
        boxFrame.Size = UDim2.new(0.6, -16, 0, 26)
        boxFrame.Position = UDim2.new(1, -8, 0.5, 0)
        boxFrame.AnchorPoint = Vector2.new(1, 0.5)
        boxFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        boxFrame.Parent = frame
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 4); bc.Parent = boxFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -16, 1, 0)
        box.Position = UDim2.new(0, 8, 0, 0)
        box.BackgroundTransparency = 1
        box.Text = defaultVal or ""
        box.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        box.TextSize = 13
        box.TextColor3 = Color3.fromRGB(255, 255, 255)
        box.TextXAlignment = Enum.TextXAlignment.Left
        box.ClearTextOnFocus = false
        box.Parent = boxFrame
        TrackWorldHumConnection(box.FocusLost:Connect(function() callback(box.Text) end))
        return box
    end

    local function makeDropdownRow(pg, labelText, options, defaultVal, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundColor3 = UI_THEME.Element
        frame.BorderSizePixel = 0
        frame.Parent = pg
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = frame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        lbl.TextSize = 13
        lbl.TextColor3 = UI_THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local btnFrame = Instance.new("Frame")
        btnFrame.Size = UDim2.new(0.6, -16, 0, 26)
        btnFrame.Position = UDim2.new(1, -8, 0.5, 0)
        btnFrame.AnchorPoint = Vector2.new(1, 0.5)
        btnFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        btnFrame.Parent = frame
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 4); bc.Parent = btnFrame

        local currentIndex = 1
        for i, v in ipairs(options) do
            if v == defaultVal then currentIndex = i break end
        end

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = options[currentIndex]
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 13
        btn.TextColor3 = UI_THEME.Accent
        btn.Parent = btnFrame

        TrackWorldHumConnection(btn.MouseButton1Click:Connect(function()
            currentIndex = (currentIndex % #options) + 1
            btn.Text = options[currentIndex]
            callback(options[currentIndex])
        end))
        return btn
    end

    local function makeNumericRow(pg, labelText, defaultVal, min, max, step, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, 36)
        frame.BackgroundColor3 = UI_THEME.Element
        frame.BorderSizePixel = 0
        frame.Parent = pg
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = frame

        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.4, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = labelText
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        lbl.TextSize = 13
        lbl.TextColor3 = UI_THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame

        local InputFrame = Instance.new("Frame")
        InputFrame.Size = UDim2.new(0.6, -16, 0, 26)
        InputFrame.Position = UDim2.new(1, -8, 0.5, 0)
        InputFrame.AnchorPoint = Vector2.new(1, 0.5)
        InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        InputFrame.Parent = frame
        local ifCorner = Instance.new("UICorner"); ifCorner.CornerRadius = UDim.new(0, 4); ifCorner.Parent = InputFrame

        local Input = Instance.new("TextBox")
        Input.Size = UDim2.new(1, -50, 1, 0)
        Input.Position = UDim2.new(0, 25, 0, 0)
        Input.BackgroundTransparency = 1
        Input.Text = tostring(math.floor(defaultVal * 100) / 100)
        Input.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        Input.TextSize = 13
        Input.TextColor3 = UI_THEME.Accent
        Input.ClearTextOnFocus = false
        Input.Parent = InputFrame

        local currentVal = defaultVal

        local function updateValueStepped(val)
            val = math.clamp(tonumber(val) or currentVal, min, max)
            if step and step > 0 then val = math.floor(val / step + 0.5) * step end
            currentVal = val
            Input.Text = tostring(math.floor(val * 100) / 100)
            callback(val)
        end
        local function updateValueFree(val)
            val = math.clamp(tonumber(val) or currentVal, min, max)
            currentVal = val
            Input.Text = tostring(math.floor(val * 100) / 100)
            callback(val)
        end

        TrackWorldHumConnection(Input.FocusLost:Connect(function() updateValueFree(Input.Text) end))

        local mBtn = Instance.new("TextButton")
        mBtn.Size = UDim2.new(0, 25, 1, 0)
        mBtn.BackgroundTransparency = 1
        mBtn.Text = "-"
        mBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        mBtn.TextSize = 16
        mBtn.TextColor3 = UI_THEME.TextDark
        mBtn.Parent = InputFrame
        TrackWorldHumConnection(mBtn.MouseButton1Click:Connect(function() updateValueStepped(currentVal - step) end))

        local pBtn = Instance.new("TextButton")
        pBtn.Size = UDim2.new(0, 25, 1, 0)
        pBtn.Position = UDim2.new(1, -25, 0, 0)
        pBtn.BackgroundTransparency = 1
        pBtn.Text = "+"
        pBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        pBtn.TextSize = 16
        pBtn.TextColor3 = UI_THEME.TextDark
        pBtn.Parent = InputFrame
        TrackWorldHumConnection(pBtn.MouseButton1Click:Connect(function() updateValueStepped(currentVal + step) end))

        return InputFrame
    end

    UI.CreateSection(page, "Preset Core Settings")
    
    local infoLbl = Instance.new("TextLabel")
    infoLbl.Size = UDim2.new(1, -10, 0, 50)
    infoLbl.Position = UDim2.new(0, 5, 0, 0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "Core Settings define how this pre-set finds targets.\n• Target Mode: How it selects humanoids (e.g. Closest Only).\n• Target Count: Max number of humanoids to affect.\n• Update Rate: How often (seconds) properties are applied."
    infoLbl.TextWrapped = true
    infoLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
    infoLbl.TextSize = 11
    infoLbl.TextColor3 = Color3.fromRGB(170, 170, 170)
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.TextYAlignment = Enum.TextYAlignment.Top
    infoLbl.Parent = page

    local nameBox = makeInputRow(page, "Target Name", draft.TargetName, function(t) draft.TargetName = t end)
    local modeBox = makeDropdownRow(page, "Target Mode", {"Closest Only", "Closest X Amount", "All Rendered"}, draft.TargetMode, function(t) draft.TargetMode = t end)
    local countBox = makeNumericRow(page, "Target Count (X)", draft.TargetCount, 1, 500, 1, function(v) draft.TargetCount = v end)
    local rateBox = makeNumericRow(page, "Update Rate (Sec)", draft.UpdateRate, 0.1, 60.0, 0.1, function(v) draft.UpdateRate = v end)

    local dropdownContainer = Instance.new("Frame")
    dropdownContainer.Size = UDim2.new(1, 0, 0, 0)
    dropdownContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropdownContainer.ClipsDescendants = true
    dropdownContainer.Parent = page
    local dcLayout = Instance.new("UIListLayout")
    dcLayout.SortOrder = Enum.SortOrder.LayoutOrder
    dcLayout.Parent = dropdownContainer
    
    local dToggle = Instance.new("TextButton")
    dToggle.Size = UDim2.new(1, 0, 0, 30)
    dToggle.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dToggle.Text = "▼ Select Nearby Humanoid Template"
    dToggle.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    dToggle.TextSize = 12
    dToggle.TextColor3 = UI_THEME.Accent
    dToggle.Parent = page
    local dCorner = Instance.new("UICorner"); dCorner.CornerRadius = UDim.new(0, 4); dCorner.Parent = dToggle
    
    local dropOpen = false
    TrackWorldHumConnection(dToggle.MouseButton1Click:Connect(function()
        dropOpen = not dropOpen
        dToggle.Text = dropOpen and "▲ Hide Nearby Humanoids" or "▼ Select Nearby Humanoid Template"
        TweenService:Create(dropdownContainer, TWEENS.FAST, {Size = UDim2.new(1, 0, 0, dropOpen and dcLayout.AbsoluteContentSize.Y or 0)}):Play()
    end))

    local humanoids = GetNearbyHumanoids()
    local uniqueNames = {}
    for _, hum in ipairs(humanoids) do
        local n = hum.Name
        if hum.Parent and hum.Parent:IsA("Model") then n = hum.Parent.Name end
        if not uniqueNames[n] then
            uniqueNames[n] = hum
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 26)
            btn.BackgroundTransparency = 1
            btn.Text = "  " .. n
            btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
            btn.TextSize = 12
            btn.TextColor3 = UI_THEME.Text
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.Parent = dropdownContainer
            TrackWorldHumConnection(btn.MouseButton1Click:Connect(function()
                draft.TargetName = n
                nameBox.Text = n
                dropOpen = false
                dToggle.Text = "▼ Select Nearby Humanoid Template"
                TweenService:Create(dropdownContainer, TWEENS.FAST, {Size = UDim2.new(1, 0, 0, 0)}):Play()
            end))
        end
    end
    
    TrackWorldHumConnection(dcLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        if dropOpen then dropdownContainer.Size = UDim2.new(1, 0, 0, dcLayout.AbsoluteContentSize.Y) end
    end))

    UI.CreateSection(page, "Preset Behavior")
    CreatePresetToggle(page, "Archivable", "Archivable")
    CreatePresetToggle(page, "Break Joints On Death", "BreakJointsOnDeath")
    CreatePresetToggle(page, "Evaluate State Machine", "EvaluateStateMachine")
    CreatePresetToggle(page, "Requires Neck", "RequiresNeck")

    UI.CreateSection(page, "Preset Control")
    CreatePresetToggle(page, "Auto Rotate", "AutoRotate")
    CreatePresetToggle(page, "Platform Stand", "PlatformStand")
    CreatePresetToggle(page, "Sit", "Sit")

    UI.CreateSection(page, "Preset Jump Settings")
    CreatePresetToggle(page, "Auto Jump Enabled", "AutoJumpEnabled")
    CreatePresetNumeric(page, "Jump Height", "JumpHeight", 0, 500, 1)
    CreatePresetNumeric(page, "Jump Power", "JumpPower", 0, 500, 1)
    CreatePresetToggle(page, "Use Jump Power", "UseJumpPower")

    UI.CreateSection(page, "Preset Game Properties")
    CreatePresetToggle(page, "Automatic Scaling Enabled", "AutomaticScalingEnabled")
    CreatePresetNumeric(page, "Health", "Health", 0, 100000, 1)
    CreatePresetNumeric(page, "Max Health", "MaxHealth", 0, 100000, 1)
    CreatePresetNumeric(page, "Hip Height", "HipHeight", 0, 100, 1)
    CreatePresetNumeric(page, "Max Slope Angle", "MaxSlopeAngle", 0, 90, 1)
    CreatePresetNumeric(page, "Walk Speed", "WalkSpeed", 0, 500, 1)

    UI.CreateButton(page, "Save Configuration", function()
        if draft.TargetName == "" then UI.Notify("Error", "Target Name cannot be empty.", 3) return end
        
        if isNew then
            table.insert(WorldHumState.Presets, {
                Id = game:GetService("HttpService"):GenerateGUID(false),
                TargetName = draft.TargetName,
                TargetMode = draft.TargetMode,
                TargetCount = draft.TargetCount,
                UpdateRate = draft.UpdateRate,
                Enabled = true,
                HighlightEnabled = false,
                Properties = draft.Properties
            })
            UI.Notify("Preset Created", "Added preset for " .. draft.TargetName, 3)
        else
            preset.TargetName = draft.TargetName
            preset.TargetMode = draft.TargetMode
            preset.TargetCount = draft.TargetCount
            preset.UpdateRate = draft.UpdateRate
            preset.Properties = draft.Properties
            preset.lastUpdate = 0
            UI.Notify("Preset Updated", "Saved changes for " .. draft.TargetName, 3)
        end
        ShowPresetManager(page)
    end)
end

function ShowPresetManager(page)
    if not page then return end
    WorldHumState.SubPage = "Manager"

    for _, child in ipairs(page:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    ClearWorldHumConnections()
    
    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 24)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = page

    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(0, 80, 0, 24)
    backBtn.BackgroundColor3 = UI_THEME.Element
    backBtn.Text = "← Back"
    backBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    backBtn.TextSize = 12
    backBtn.TextColor3 = UI_THEME.Text
    backBtn.Parent = headerFrame
    local bC = Instance.new("UICorner"); bC.CornerRadius = UDim.new(0, 4); bC.Parent = backBtn
    TrackWorldHumConnection(backBtn.MouseButton1Click:Connect(function()
        ShowWorldHumList(page)
    end))

    UI.CreateButton(page, "+ Create New Pre-set", function()
        ShowPresetEditor(page, nil, true)
    end)

    UI.CreateSection(page, "Active Pre-sets")

    local function createToggleBlock(parent, text, state, callback)
        local block = Instance.new("Frame")
        block.Size = UDim2.new(0.5, -5, 0, 30)
        block.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        block.Parent = parent
        local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = block
        
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.7, 0, 1, 0)
        lbl.Position = UDim2.new(0, 8, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        lbl.TextSize = 12
        lbl.TextColor3 = UI_THEME.Text
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = block

        local Switch = Instance.new("Frame")
        Switch.Size = UDim2.new(0, 34, 0, 18)
        Switch.AnchorPoint = Vector2.new(1, 0.5)
        Switch.Position = UDim2.new(1, -8, 0.5, 0)
        Switch.BackgroundColor3 = state and UI_THEME.Accent or Color3.fromRGB(60, 60, 60)
        Switch.Parent = block
        local swC = Instance.new("UICorner"); swC.CornerRadius = UDim.new(1, 0); swC.Parent = Switch
        
        local Knob = Instance.new("Frame")
        Knob.Size = UDim2.new(0, 14, 0, 14)
        Knob.AnchorPoint = Vector2.new(0, 0.5)
        Knob.Position = state and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
        Knob.BackgroundColor3 = Color3.new(1, 1, 1)
        Knob.Parent = Switch
        local knC = Instance.new("UICorner"); knC.CornerRadius = UDim.new(1, 0); knC.Parent = Knob

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 1, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = Switch
        
        local currentState = state
        TrackWorldHumConnection(btn.MouseButton1Click:Connect(function()
            currentState = not currentState
            TweenService:Create(Switch, TWEENS.FAST, {BackgroundColor3 = currentState and UI_THEME.Accent or Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(Knob, TWEENS.FAST, {Position = currentState and UDim2.new(1, -16, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
            callback(currentState)
        end))
        return block
    end

    if not WorldHumState.Presets or #WorldHumState.Presets == 0 then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.BackgroundTransparency = 1
        lbl.Text = "No active pre-sets."
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        lbl.TextSize = 13
        lbl.TextColor3 = UI_THEME.TextDark
        lbl.Parent = page
    else
        for i, preset in ipairs(WorldHumState.Presets) do
            local card = Instance.new("Frame")
            card.Size = UDim2.new(1, 0, 0, 95)
            card.BackgroundColor3 = UI_THEME.Element
            card.BorderSizePixel = 0
            card.Parent = page
            local cC = Instance.new("UICorner"); cC.CornerRadius = UDim.new(0, 6); cC.Parent = card

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(1, -60, 0, 22)
            nameLbl.Position = UDim2.new(0, 10, 0, 5)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = preset.TargetName .. " (" .. preset.TargetMode .. ")"
            nameLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            nameLbl.TextSize = 14
            nameLbl.TextColor3 = UI_THEME.Text
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = card

            local countLbl = Instance.new("TextLabel")
            countLbl.Size = UDim2.new(1, -20, 0, 18)
            countLbl.Position = UDim2.new(0, 10, 0, 25)
            countLbl.BackgroundTransparency = 1
            countLbl.Text = "Affected: " .. (preset.affectedCount or 0) .. "  |  Update: " .. (preset.UpdateRate or 2.0) .. "s"
            countLbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
            countLbl.TextSize = 11
            countLbl.TextColor3 = UI_THEME.TextDark
            countLbl.TextXAlignment = Enum.TextXAlignment.Left
            countLbl.Parent = card
            -- Register for live refresh from ApplyWorldHumanoidSettings
            if preset.Id then
                WorldHumState.presetCountLabels[preset.Id] = countLbl
            end

            local toggleContainer = Instance.new("Frame")
            toggleContainer.Size = UDim2.new(1, -20, 0, 30)
            toggleContainer.Position = UDim2.new(0, 10, 0, 50)
            toggleContainer.BackgroundTransparency = 1
            toggleContainer.Parent = card
            local tcLayout = Instance.new("UIListLayout")
            tcLayout.FillDirection = Enum.FillDirection.Horizontal
            tcLayout.Padding = UDim.new(0, 10)
            tcLayout.Parent = toggleContainer

            createToggleBlock(toggleContainer, "Enabled", preset.Enabled ~= false, function(s)
                preset.Enabled = s
                preset.lastUpdate = 0
            end)
            
            createToggleBlock(toggleContainer, "Highlight All", preset.HighlightEnabled == true, function(s)
                preset.HighlightEnabled = s
            end)

            local editBtn = Instance.new("TextButton")
            editBtn.Size = UDim2.new(0, 50, 0, 22)
            editBtn.AnchorPoint = Vector2.new(1, 0)
            editBtn.Position = UDim2.new(1, -65, 0, 5)
            editBtn.BackgroundColor3 = Color3.fromRGB(55, 105, 155)
            editBtn.Text = "Edit"
            editBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            editBtn.TextSize = 11
            editBtn.TextColor3 = Color3.new(1, 1, 1)
            editBtn.Parent = card
            local eC = Instance.new("UICorner"); eC.CornerRadius = UDim.new(0, 4); eC.Parent = editBtn
            TrackWorldHumConnection(editBtn.MouseButton1Click:Connect(function()
                ShowPresetEditor(page, preset, false)
            end))

            local deleteBtn = Instance.new("TextButton")
            deleteBtn.Size = UDim2.new(0, 50, 0, 22)
            deleteBtn.AnchorPoint = Vector2.new(1, 0)
            deleteBtn.Position = UDim2.new(1, -10, 0, 5)
            deleteBtn.BackgroundColor3 = UI_THEME.Fail
            deleteBtn.Text = "Delete"
            deleteBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
            deleteBtn.TextSize = 11
            deleteBtn.TextColor3 = Color3.new(1, 1, 1)
            deleteBtn.Parent = card
            local dC = Instance.new("UICorner"); dC.CornerRadius = UDim.new(0, 4); dC.Parent = deleteBtn
            TrackWorldHumConnection(deleteBtn.MouseButton1Click:Connect(function()
                table.remove(WorldHumState.Presets, i)
                ShowPresetManager(page)
            end))
        end
    end
end

function UpdateWorldHumListInPlace()
    local page = WorldHumState.Page
    if not page then return end

    local humanoids = GetNearbyHumanoids()
    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart)
    local myPos = myRoot and myRoot.Position or Camera.CFrame.Position

    local existingHums = {}
    for _, entry in ipairs(WorldHumState.listEntries) do
        existingHums[entry.hum] = entry
    end

    local humDataList = {}
    for _, hum in ipairs(humanoids) do
        local model = hum.Parent
        local root = hum.RootPart or (model and model.PrimaryPart)
        local dist = root and (root.Position - myPos).Magnitude or 999999
        table.insert(humDataList, {hum = hum, dist = dist})
    end

    table.sort(humDataList, function(a, b)
        return a.dist < b.dist
    end)

    local matchedHums = {}
    local anyChanges = false

    for _, data in ipairs(humDataList) do
        local hum = data.hum
        matchedHums[hum] = true
        if existingHums[hum] then
            existingHums[hum].label.Text = math.floor(data.dist) .. " studs away"
            existingHums[hum].card.LayoutOrder = math.floor(data.dist)
        else
            anyChanges = true
        end
    end

    for _, entry in ipairs(WorldHumState.listEntries) do
        if not matchedHums[entry.hum] then
            anyChanges = true
            break
        end
    end

    if anyChanges then
        ShowWorldHumList(page)
    end
end

function ShowWorldHumList(page)
    if not page then return end
    WorldHumState.SubPage = "List"

    for _, child in ipairs(page:GetChildren()) do
        if not child:IsA("UIListLayout") and not child:IsA("UIPadding") then
            child:Destroy()
        end
    end
    ClearWorldHumConnections()
    WorldHumState.selectedHum = nil
    table.clear(WorldHumState.listEntries)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local layout = page:FindFirstChildOfClass("UIListLayout")
    if not layout then
        layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Parent = page
    end

    local manageBtn = Instance.new("TextButton")
    manageBtn.Size = UDim2.new(1, 0, 0, 36)
    manageBtn.BackgroundColor3 = Color3.fromRGB(50, 90, 150)
    manageBtn.Text = "⚙ Manage Pre-sets"
    manageBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    manageBtn.TextSize = 14
    manageBtn.TextColor3 = Color3.new(1, 1, 1)
    manageBtn.Parent = page
    local mC = Instance.new("UICorner"); mC.CornerRadius = UDim.new(0, 6); mC.Parent = manageBtn
    TrackWorldHumConnection(manageBtn.MouseButton1Click:Connect(function()
        ShowPresetManager(page)
    end))

    UI.CreateSection(page, "Nearby Humanoids")

    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 0, 30)
    refreshBtn.BackgroundColor3 = UI_THEME.Element
    refreshBtn.Text = "Refresh Scan"
    refreshBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    refreshBtn.TextSize = 13
    refreshBtn.TextColor3 = UI_THEME.Accent
    refreshBtn.Parent = page
    local rC = Instance.new("UICorner"); rC.CornerRadius = UDim.new(0, 6); rC.Parent = refreshBtn
    TrackWorldHumConnection(refreshBtn.MouseButton1Click:Connect(function()
        ShowWorldHumList(page)
    end))

    local humanoids = GetNearbyHumanoids()
    if #humanoids == 0 then
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, 30)
        lbl.BackgroundTransparency = 1
        lbl.Text = "No non-local humanoids found."
        lbl.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        lbl.TextSize = 13
        lbl.TextColor3 = UI_THEME.TextDark
        lbl.Parent = page
        return
    end

    local myChar = LocalPlayer.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart)
    local myPos = myRoot and myRoot.Position or Camera.CFrame.Position

    local humDataList = {}
    for _, hum in ipairs(humanoids) do
        local model = hum.Parent
        local root = hum.RootPart or (model and model.PrimaryPart)
        local dist = root and (root.Position - myPos).Magnitude or 999999
        table.insert(humDataList, {hum = hum, dist = dist})
    end

    table.sort(humDataList, function(a, b)
        return a.dist < b.dist
    end)

    for _, data in ipairs(humDataList) do
        local hum = data.hum
        local model = hum.Parent
        if not model then continue end

        local card = Instance.new("Frame")
        card.Size = UDim2.new(1, 0, 0, 45)
        card.BackgroundColor3 = UI_THEME.Element
        card.BorderSizePixel = 0
        card.LayoutOrder = math.floor(data.dist)
        card.Parent = page
        local cC = Instance.new("UICorner"); cC.CornerRadius = UDim.new(0, 6); cC.Parent = card

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Size = UDim2.new(1, -140, 0, 22)
        nameLabel.Position = UDim2.new(0, 12, 0, 4)
        nameLabel.BackgroundTransparency = 1
        nameLabel.Text = model.Name
        nameLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
        nameLabel.TextSize = 14
        nameLabel.TextColor3 = UI_THEME.Text
        nameLabel.TextXAlignment = Enum.TextXAlignment.Left
        nameLabel.Parent = card

        local distanceLabel = Instance.new("TextLabel")
        distanceLabel.Size = UDim2.new(1, -140, 0, 16)
        distanceLabel.Position = UDim2.new(0, 12, 0, 22)
        distanceLabel.BackgroundTransparency = 1
        distanceLabel.Text = math.floor(data.dist) .. " studs away"
        distanceLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        distanceLabel.TextSize = 12
        distanceLabel.TextColor3 = UI_THEME.TextDark
        distanceLabel.TextXAlignment = Enum.TextXAlignment.Left
        distanceLabel.Parent = card

        table.insert(WorldHumState.listEntries, {hum = hum, card = card, label = distanceLabel})

        local selectionBtn = Instance.new("TextButton")
        selectionBtn.Size = UDim2.new(1, 0, 1, 0)
        selectionBtn.BackgroundTransparency = 1
        selectionBtn.Text = ""
        selectionBtn.ZIndex = 1
        selectionBtn.Parent = card

        local editBtn = Instance.new("TextButton")
        editBtn.Name = "Edit"
        editBtn.Size = UDim2.new(0, 60, 0, 26)
        editBtn.Position = UDim2.new(1, -10, 0.5, 0)
        editBtn.AnchorPoint = Vector2.new(1, 0.5)
        editBtn.BackgroundColor3 = UI_THEME.Accent
        editBtn.Text = "Edit"
        editBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        editBtn.TextSize = 12
        editBtn.TextColor3 = UI_THEME.Background
        editBtn.Visible = false
        editBtn.ZIndex = 2
        editBtn.Parent = card
        local eC = Instance.new("UICorner"); eC.CornerRadius = UDim.new(0, 4); eC.Parent = editBtn

        local tpBtn = Instance.new("TextButton")
        tpBtn.Name = "TP"
        tpBtn.Size = UDim2.new(0, 50, 0, 26)
        tpBtn.Position = UDim2.new(1, -75, 0.5, 0)
        tpBtn.AnchorPoint = Vector2.new(1, 0.5)
        tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        tpBtn.Text = "TP"
        tpBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        tpBtn.TextSize = 12
        tpBtn.TextColor3 = Color3.new(1, 1, 1)
        tpBtn.Visible = false
        tpBtn.ZIndex = 2
        tpBtn.Parent = card
        local tpC = Instance.new("UICorner"); tpC.CornerRadius = UDim.new(0, 4); tpC.Parent = tpBtn

        TrackWorldHumConnection(selectionBtn.MouseButton1Click:Connect(function()

            if WorldHumState.selectionHighlight then
                pcall(function() WorldHumState.selectionHighlight:Destroy() end)
                WorldHumState.selectionHighlight = nil
            end

            for _, child in ipairs(page:GetChildren()) do
                local eb = child:FindFirstChild("Edit")
                local tb = child:FindFirstChild("TP")
                if eb then eb.Visible = false end
                if tb then tb.Visible = false end
            end

            WorldHumState.selectedHum = hum
            editBtn.Visible = true
            tpBtn.Visible = true

            local hl = Instance.new("Highlight")
            hl.Enabled = not Flags["Settings/GhostMode"]
            hl.Name = "WorldHumSelectionHighlight"
            hl.Adornee = model
            hl.FillTransparency = 1
            hl.OutlineColor = Color3.new(255, 255, 255)
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Parent = model
            WorldHumState.selectionHighlight = hl
        end))

        TrackWorldHumConnection(editBtn.MouseButton1Click:Connect(function()
            if WorldHumState.selectionHighlight then
                WorldHumState.selectionHighlight:Destroy()
                WorldHumState.selectionHighlight = nil
            end
            ShowWorldHumEditor(page, hum)
        end))

        TrackWorldHumConnection(tpBtn.MouseButton1Click:Connect(function()
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Teleporting is disabled while Safe Mode is ON.")
                return
            end
            local myChar = LocalPlayer.Character
            local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart)
            local targetPart = hum.RootPart or (model and model.PrimaryPart) or (model and model:FindFirstChildOfClass("BasePart"))
            if myRoot and targetPart then
                myRoot.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
                UI.Notify("Teleport", "Teleported to " .. model.Name)
            else
                UI.Notify("Teleport Error", "Target humanoid location could not be determined.")
            end
        end))
    end
end

for _, t in pairs(UIState.Tabs) do
    if t.Label.Text == "WorldHumanoids" then
        TrackConnection(t.Button.MouseButton1Click:Connect(function()
            ShowWorldHumList(WorldHumState.Page)
        end))
        break
    end
end

function CreateWorldHumToggle(page, text, targetHum, prop)
    local path = GetUniquePath(targetHum)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 36)
    Frame.BackgroundColor3 = UI_THEME.Element
    Frame.BorderSizePixel = 0
    Frame.Parent = page
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, -30, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Label.TextSize = 13
    Label.TextColor3 = UI_THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local initialLocked = (WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil)
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0, 24, 0, 24)
    LockBtn.AnchorPoint = Vector2.new(1, 0.5)
    LockBtn.Position = UDim2.new(1, -64, 0.5, 0)
    LockBtn.BackgroundTransparency = 1
    LockBtn.Text = initialLocked and "🔒" or "🔓"
    LockBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LockBtn.TextSize = 14
    LockBtn.TextColor3 = initialLocked and UI_THEME.Accent or UI_THEME.TextDark
    LockBtn.Parent = Frame

    local Switch = Instance.new("Frame")
    Switch.Size = UDim2.new(0, 44, 0, 22)
    Switch.AnchorPoint = Vector2.new(1, 0.5)
    Switch.Position = UDim2.new(1, -12, 0.5, 0)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Switch.Parent = Frame
    local swCorner = Instance.new("UICorner"); swCorner.CornerRadius = UDim.new(1, 0); swCorner.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 18, 0, 18)
    Knob.AnchorPoint = Vector2.new(0, 0.5)
    Knob.Position = UDim2.new(0, 2, 0.5, 0)
    Knob.BackgroundColor3 = Color3.new(1, 1, 1)
    Knob.Parent = Switch
    local kbCorner = Instance.new("UICorner"); kbCorner.CornerRadius = UDim.new(1, 0); kbCorner.Parent = Knob

    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = Switch

    local function updateVisuals(state)
        TweenService:Create(Switch, TWEENS.MEDIUM, {BackgroundColor3 = state and UI_THEME.Accent or Color3.fromRGB(50, 50, 50)}):Play()
        TweenService:Create(Knob, TWEENS.SMOOTH, {Position = state and UDim2.new(1, -20, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}):Play()
    end

    WorldHumState.updaters[prop] = updateVisuals

    TrackWorldHumConnection(LockBtn.MouseButton1Click:Connect(function()
        local isLocked = not (WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil)
        if isLocked then
            if not WorldHumState.lockedProperties[path] then WorldHumState.lockedProperties[path] = {} end
            WorldHumState.lockedProperties[path][prop] = targetHum[prop]
        else
            WorldHumState.lockedProperties[path][prop] = nil
        end
        LockBtn.Text = isLocked and "🔒" or "🔓"
        LockBtn.TextColor3 = isLocked and UI_THEME.Accent or UI_THEME.TextDark
    end))

    TrackWorldHumConnection(Button.MouseButton1Click:Connect(function()
        local newState = not targetHum[prop]
        pcall(SafeSetProp, targetHum, prop, newState)
        if WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil then
            WorldHumState.lockedProperties[path][prop] = newState
        end
        updateVisuals(newState)
    end))

    updateVisuals(targetHum[prop])
end

function CreateWorldHumNumeric(page, text, targetHum, prop, min, max, step)
    local path = GetUniquePath(targetHum)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, 0, 0, 48)
    Frame.BackgroundColor3 = UI_THEME.Element
    Frame.BorderSizePixel = 0
    Frame.Parent = page
    local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 6); corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, -42, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold, Enum.FontStyle.Normal)
    Label.TextSize = 13
    Label.TextColor3 = UI_THEME.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local initialLocked = (WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil)
    local LockBtn = Instance.new("TextButton")
    LockBtn.Size = UDim2.new(0, 24, 0, 24)
    LockBtn.AnchorPoint = Vector2.new(1, 0.5)
    LockBtn.Position = UDim2.new(0.6, -12, 0.5, 0)
    LockBtn.BackgroundTransparency = 1
    LockBtn.Text = initialLocked and "🔒" or "🔓"
    LockBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    LockBtn.TextSize = 14
    LockBtn.TextColor3 = initialLocked and UI_THEME.Accent or UI_THEME.TextDark
    LockBtn.Parent = Frame

    local InputFrame = Instance.new("Frame")
    InputFrame.Size = UDim2.new(0.4, -12, 0, 30)
    InputFrame.Position = UDim2.new(1, -12, 0.5, 0)
    InputFrame.AnchorPoint = Vector2.new(1, 0.5)
    InputFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    InputFrame.Parent = Frame
    local ifCorner = Instance.new("UICorner"); ifCorner.CornerRadius = UDim.new(0, 4); ifCorner.Parent = InputFrame

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -50, 1, 0)
    Input.Position = UDim2.new(0, 25, 0, 0)
    Input.BackgroundTransparency = 1
    Input.Text = tostring(math.floor(targetHum[prop] * 100) / 100)
    Input.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    Input.TextSize = 13
    Input.TextColor3 = UI_THEME.Accent
    Input.ClearTextOnFocus = false
    Input.Parent = InputFrame

    local function updateValueStepped(val)
        val = math.clamp(tonumber(val) or targetHum[prop], min, max)
        if step and step > 0 then val = math.floor(val / step + 0.5) * step end
        pcall(SafeSetProp, targetHum, prop, val)
        if WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil then
            WorldHumState.lockedProperties[path][prop] = val
        end
        Input.Text = tostring(math.floor(val * 100) / 100)
    end
    local function updateValueFree(val)
        val = math.clamp(tonumber(val) or targetHum[prop], min, max)
        pcall(SafeSetProp, targetHum, prop, val)
        if WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil then
            WorldHumState.lockedProperties[path][prop] = val
        end
        Input.Text = tostring(math.floor(val * 100) / 100)
    end

    WorldHumState.updaters[prop] = function(val)
        if not Input:IsFocused() then
            Input.Text = tostring(math.floor(val * 100) / 100)
        end
    end

    TrackWorldHumConnection(LockBtn.MouseButton1Click:Connect(function()
        local isLocked = not (WorldHumState.lockedProperties[path] and WorldHumState.lockedProperties[path][prop] ~= nil)
        if isLocked then
            if not WorldHumState.lockedProperties[path] then WorldHumState.lockedProperties[path] = {} end
            WorldHumState.lockedProperties[path][prop] = targetHum[prop]
        else
            WorldHumState.lockedProperties[path][prop] = nil
        end
        LockBtn.Text = isLocked and "🔒" or "🔓"
        LockBtn.TextColor3 = isLocked and UI_THEME.Accent or UI_THEME.TextDark
    end))

    TrackWorldHumConnection(Input.FocusLost:Connect(function() updateValueFree(Input.Text) end))

    local mBtn = Instance.new("TextButton")
    mBtn.Size = UDim2.new(0, 25, 1, 0)
    mBtn.BackgroundTransparency = 1
    mBtn.Text = "-"
    mBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    mBtn.TextSize = 16
    mBtn.TextColor3 = UI_THEME.TextDark
    mBtn.Parent = InputFrame
    TrackWorldHumConnection(mBtn.MouseButton1Click:Connect(function() updateValueStepped(targetHum[prop] - (step or 1)) end))

    local pBtn = Instance.new("TextButton")
    pBtn.Size = UDim2.new(0, 25, 1, 0)
    pBtn.Position = UDim2.new(1, -25, 0, 0)
    pBtn.BackgroundTransparency = 1
    pBtn.Text = "+"
    pBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    pBtn.TextSize = 16
    pBtn.TextColor3 = UI_THEME.TextDark
    pBtn.Parent = InputFrame
    TrackWorldHumConnection(pBtn.MouseButton1Click:Connect(function() updateValueStepped(targetHum[prop] + (step or 1)) end))
end

function ShowWorldHumEditor(page, hum)
    page:ClearAllChildren()
    ClearWorldHumConnections()
    WorldHumState.selectedHum = hum

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 5)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = page

    local headerFrame = Instance.new("Frame")
    headerFrame.Size = UDim2.new(1, 0, 0, 24)
    headerFrame.BackgroundTransparency = 1
    headerFrame.Parent = page

    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(0, 80, 0, 24)
    backBtn.BackgroundColor3 = UI_THEME.Element
    backBtn.Text = "← Back"
    backBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    backBtn.TextSize = 12
    backBtn.TextColor3 = UI_THEME.Text
    backBtn.Parent = headerFrame
    local bC = Instance.new("UICorner"); bC.CornerRadius = UDim.new(0, 4); bC.Parent = backBtn
    TrackWorldHumConnection(backBtn.MouseButton1Click:Connect(function()
        ShowWorldHumList(page)
    end))

    local tpBtn = Instance.new("TextButton")
    tpBtn.Size = UDim2.new(0, 80, 0, 24)
    tpBtn.Position = UDim2.new(0, 85, 0, 0)
    tpBtn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    tpBtn.Text = "Teleport"
    tpBtn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    tpBtn.TextSize = 12
    tpBtn.TextColor3 = Color3.new(1, 1, 1)
    tpBtn.Parent = headerFrame
    local tpC = Instance.new("UICorner"); tpC.CornerRadius = UDim.new(0, 4); tpC.Parent = tpBtn
    TrackWorldHumConnection(tpBtn.MouseButton1Click:Connect(function()
        if SAFE_MODE then
            UI.Notify("Safe Mode", "Teleporting is disabled while Safe Mode is ON.")
            return
        end
        local myChar = LocalPlayer.Character
        local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar.PrimaryPart)
        local targetPart = hum.RootPart or (hum.Parent and hum.Parent.PrimaryPart) or (hum.Parent and hum.Parent:FindFirstChildOfClass("BasePart"))
        if myRoot and targetPart then
            myRoot.CFrame = targetPart.CFrame * CFrame.new(0, 3, 0)
            UI.Notify("Teleport", "Teleported to " .. hum.Parent.Name)
        else
            UI.Notify("Teleport Error", "Target humanoid location could not be determined.")
        end
    end))

    UI.CreateSection(page, "Editor: " .. hum.Parent.Name)

    UI.CreateSection(page, "Behavior")
    CreateWorldHumToggle(page, "Archivable", hum, "Archivable")
    CreateWorldHumToggle(page, "Break Joints On Death", hum, "BreakJointsOnDeath")
    CreateWorldHumToggle(page, "Evaluate State Machine", hum, "EvaluateStateMachine")
    CreateWorldHumToggle(page, "Requires Neck", hum, "RequiresNeck")

    UI.CreateSection(page, "Control")
    CreateWorldHumToggle(page, "Auto Rotate", hum, "AutoRotate")
    CreateWorldHumToggle(page, "Platform Stand", hum, "PlatformStand")
    CreateWorldHumToggle(page, "Sit", hum, "Sit")

    UI.CreateSection(page, "Jump Settings")
    CreateWorldHumToggle(page, "Auto Jump Enabled", hum, "AutoJumpEnabled")
    CreateWorldHumNumeric(page, "Jump Height", hum, "JumpHeight", 0, 500, 1)
    CreateWorldHumNumeric(page, "Jump Power", hum, "JumpPower", 0, 500, 1)
    CreateWorldHumToggle(page, "Use Jump Power", hum, "UseJumpPower")

    UI.CreateSection(page, "Game")
    CreateWorldHumToggle(page, "Automatic Scaling Enabled", hum, "AutomaticScalingEnabled")
    CreateWorldHumNumeric(page, "Health", hum, "Health", 0, 100000, 1)
    CreateWorldHumNumeric(page, "Max Health", hum, "MaxHealth", 0, 100000, 1)
    CreateWorldHumNumeric(page, "Hip Height", hum, "HipHeight", 0, 100, 1)
    CreateWorldHumNumeric(page, "Max Slope Angle", hum, "MaxSlopeAngle", 0, 90, 1)
    CreateWorldHumNumeric(page, "Walk Speed", hum, "WalkSpeed", 0, 500, 1)
end

local WaypointsPage = UI.CreateTab("Waypoints")

for _, t in pairs(UIState.Tabs) do
    if t.Label.Text == "Waypoints" then
        WaypointsTabButton = t.Button
        WaypointsTabButton.Visible = false
        break
    end
end

UI.CreateSection(WaypointsPage, "Active Waypoints")
WaypointsUIList = Instance.new("Frame")
WaypointsUIList.Size = UDim2.new(1, 0, 0, 0)
WaypointsUIList.BackgroundTransparency = 1
WaypointsUIList.Parent = WaypointsPage
local wListLayout = Instance.new("UIListLayout")
wListLayout.Padding = UDim.new(0, 5)
wListLayout.SortOrder = Enum.SortOrder.LayoutOrder
wListLayout.Parent = WaypointsUIList

TrackConnection(wListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    WaypointsUIList.Size = UDim2.new(1, 0, 0, wListLayout.AbsoluteContentSize.Y)
end))

if SAFE_MODE then

    local safeBanner = Instance.new("TextLabel")
    safeBanner.Size = UDim2.new(1, 0, 0, 36)
    safeBanner.BackgroundColor3 = Color3.fromRGB(20, 60, 30)
    safeBanner.BorderSizePixel = 0
    safeBanner.Text = "⚠  Camera Tracking & Input Simulation\nare disabled in Safe Mode"
    safeBanner.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    safeBanner.TextSize = 11
    safeBanner.TextColor3 = Color3.fromRGB(60, 200, 100)
    safeBanner.TextWrapped = true
    safeBanner.Parent = AimTab
    local bnCorner = Instance.new("UICorner")
    bnCorner.CornerRadius = UDim.new(0, 6)
    bnCorner.Parent = safeBanner
end
UI.CreateSection(AimTab, "Camera Tracking Assistant")
UI.CreateToggle(AimTab, "Enable Camera Tracking (Ctrl + ~)", "Aim/AimLock", Flags["Aim/AimLock"])
UI.CreateToggle(AimTab, "Always Active (No Keybind — If OFF: hold RMB to track)", "Aim/AlwaysEnabled", Flags["Aim/AlwaysEnabled"])
UI.CreateToggle(AimTab, "Ignore Teammates", "Aim/TeamCheck", Flags["Aim/TeamCheck"])
UI.CreateToggle(AimTab, "Auto Whitelist Friends/Connections", "Aim/AutoWhitelistFriends", Flags["Aim/AutoWhitelistFriends"], function(state)
    if state then
        task.spawn(function()
            if not LocalPlayer then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.UserId > 0 and LocalPlayer.UserId > 0 then
                    pcall(function()
                        if LocalPlayer:IsFriendsWith(p.UserId) then
                            AdvancedPlayerPanelState.Whitelist[p.UserId] = true
                        end
                    end)
                end
            end
        end)
    end
end)
UI.CreateToggle(AimTab, "Visibility Check (Raycast)", "Aim/VisibilityCheck", Flags["Aim/VisibilityCheck"])
UI.CreateToggle(AimTab, "Show Tracking Indicator Dots", "Aim/ShowAssistDots", Flags["Aim/ShowAssistDots"])
UI.CreateNumericInput(AimTab, "Attraction Strength", "Aim/AttractionStrength", Flags["Aim/AttractionStrength"], 0, 500, 10, "%")
UI.CreateNumericInput(AimTab, "FOV Radius", "Aim/FOV/Radius", Flags["Aim/FOV/Radius"], 0, 500, 5, "px")
UI.CreateToggle(AimTab, "Show FOV Circle", "Aim/FOV/ShowCircle", Flags["Aim/FOV/ShowCircle"])
UI.CreateToggle(AimTab, "Enable Dampening", "Aim/Dampening", Flags["Aim/Dampening"])
UI.CreateNumericInput(AimTab, "Dampening Threshold", "Aim/Dampening/Threshold", Flags["Aim/Dampening/Threshold"], 0, 500, 5, "px")
UI.CreateNumericInput(AimTab, "Dampening Min Strength", "Aim/Dampening/Strength", Flags["Aim/Dampening/Strength"], 0, 100, 1, "%")

UI.CreateSection(AimTab, "Target Zone Selector")

do
    local TargetArea = Instance.new("Frame")
    TargetArea.Name = "TargetArea"
    TargetArea.Size = UDim2.new(1, 0, 0, 220)
    TargetArea.BackgroundTransparency = 1
    TargetArea.Parent = AimTab

    local PriorityLabel = Instance.new("TextLabel")
    PriorityLabel.Name = "PriorityLabel"
    PriorityLabel.Size = UDim2.new(1, 0, 0, 25)
    PriorityLabel.Position = UDim2.new(0, 0, 0, 0)
    PriorityLabel.BackgroundTransparency = 1
    PriorityLabel.Text = "Priority: Head"
    PriorityLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
    PriorityLabel.TextSize = 14
    PriorityLabel.TextColor3 = UI_THEME.Text
    PriorityLabel.Parent = TargetArea
    UIState.PriorityLabel = PriorityLabel

    local HumanoidRoot = Instance.new("Frame")
    HumanoidRoot.Name = "HumanoidRoot"
    HumanoidRoot.Size = UDim2.fromOffset(100, 180)
    HumanoidRoot.Position = UDim2.new(0.5, 0, 0.5, 15)
    HumanoidRoot.AnchorPoint = Vector2.new(0.5, 0.5)
    HumanoidRoot.BackgroundTransparency = 1
    HumanoidRoot.Parent = TargetArea

    local function CreatePart(name, size, pos, flagKey)
        local Part = Instance.new("TextButton")
        Part.Name = name
        Part.Size = size
        Part.Position = pos
        Part.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Part.BackgroundTransparency = Flags["Aim/TargetGroups"][flagKey] and 0 or 1
        Part.BorderSizePixel = 0
        Part.Text = ""
        Part.Parent = HumanoidRoot

        local PartStroke = Instance.new("UIStroke")
        PartStroke.Color = Color3.fromRGB(255, 255, 255)
        PartStroke.Thickness = 1
        PartStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        PartStroke.Parent = Part

        Part.MouseButton1Click:Connect(function()
            Flags["Aim/TargetGroups"][flagKey] = not Flags["Aim/TargetGroups"][flagKey]
            Part.BackgroundTransparency = Flags["Aim/TargetGroups"][flagKey] and 0 or 1
            USER_MODIFIED_FLAGS["Aim/TargetGroups"] = true
        end)

        if not UIState.Updaters["Aim/TargetGroups"] then
            UIState.Updaters["Aim/TargetGroups"] = {}
        end
        UIState.Updaters["Aim/TargetGroups"][flagKey] = function(state)
            Part.BackgroundTransparency = state and 0 or 1
        end

        return Part
    end

    local Head = CreatePart("Head", UDim2.fromOffset(30, 30), UDim2.new(0.5, 0, 0, 0), "Head")
    Head.AnchorPoint = Vector2.new(0.5, 0)
    local HeadCorner = Instance.new("UICorner", Head)
    HeadCorner.CornerRadius = UDim.new(1, 0)

    local Torso = CreatePart("Torso", UDim2.fromOffset(40, 60), UDim2.new(0.5, 0, 0, 35), "Torso")
    Torso.AnchorPoint = Vector2.new(0.5, 0)

    local LeftArm = CreatePart("LeftArm", UDim2.fromOffset(20, 60), UDim2.new(0.5, -25, 0, 35), "LeftArm")
    LeftArm.AnchorPoint = Vector2.new(1, 0)

    local RightArm = CreatePart("RightArm", UDim2.fromOffset(20, 60), UDim2.new(0.5, 25, 0, 35), "RightArm")
    RightArm.AnchorPoint = Vector2.new(0, 0)

    local LeftLeg = CreatePart("LeftLeg", UDim2.fromOffset(18, 70), UDim2.new(0.5, -2, 0, 100), "LeftLeg")
    LeftLeg.AnchorPoint = Vector2.new(1, 0)

    local RightLeg = CreatePart("RightLeg", UDim2.fromOffset(18, 70), UDim2.new(0.5, 2, 0, 100), "RightLeg")
    RightLeg.AnchorPoint = Vector2.new(0, 0)
end

UI.CreateSection(AimTab, "Input Simulation")
UI.CreateToggle(AimTab, "Enable Input Simulation", "ShootBot/Enabled", Flags["ShootBot/Enabled"])
UI.CreateToggle(AimTab, "Ignore Teammates", "ShootBot/TeamCheck", Flags["ShootBot/TeamCheck"])
UI.CreateNumericInput(AimTab, "Clicks Per Second", "ShootBot/CPS", Flags["ShootBot/CPS"], 5, 100, 5, "cps")

do
    local TargetArea = Instance.new("Frame")
    TargetArea.Name = "TargetArea"
    TargetArea.Size = UDim2.new(1, 0, 0, 200)
    TargetArea.BackgroundTransparency = 1
    TargetArea.Parent = AimTab

    local HumanoidRoot = Instance.new("Frame")
    HumanoidRoot.Name = "HumanoidRoot"
    HumanoidRoot.Size = UDim2.fromOffset(100, 180)
    HumanoidRoot.Position = UDim2.new(0.5, 0, 0.5, 0)
    HumanoidRoot.AnchorPoint = Vector2.new(0.5, 0.5)
    HumanoidRoot.BackgroundTransparency = 1
    HumanoidRoot.Parent = TargetArea

    local function CreatePart(name, size, pos, flagKey)
        local Part = Instance.new("TextButton")
        Part.Name = name
        Part.Size = size
        Part.Position = pos
        Part.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        Part.BackgroundTransparency = Flags["ShootBot/TargetParts"][flagKey] and 0 or 1
        Part.BorderSizePixel = 0
        Part.Text = ""
        Part.Parent = HumanoidRoot

        local PartStroke = Instance.new("UIStroke")
        PartStroke.Color = Color3.fromRGB(255, 255, 255)
        PartStroke.Thickness = 1
        PartStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        PartStroke.Parent = Part

        Part.MouseButton1Click:Connect(function()
            Flags["ShootBot/TargetParts"][flagKey] = not Flags["ShootBot/TargetParts"][flagKey]
            Part.BackgroundTransparency = Flags["ShootBot/TargetParts"][flagKey] and 0 or 1
        end)

        return Part
    end

    local Head = CreatePart("Head", UDim2.fromOffset(30, 30), UDim2.new(0.5, 0, 0, 0), "Head")
    Head.AnchorPoint = Vector2.new(0.5, 0)
    local HeadCorner = Instance.new("UICorner", Head)
    HeadCorner.CornerRadius = UDim.new(1, 0)

    local Torso = CreatePart("Torso", UDim2.fromOffset(40, 60), UDim2.new(0.5, 0, 0, 35), "Torso")
    Torso.AnchorPoint = Vector2.new(0.5, 0)

    local LeftArm = CreatePart("LeftArm", UDim2.fromOffset(20, 60), UDim2.new(0.5, -25, 0, 35), "LeftArm")
    LeftArm.AnchorPoint = Vector2.new(1, 0)

    local RightArm = CreatePart("RightArm", UDim2.fromOffset(20, 60), UDim2.new(0.5, 25, 0, 35), "RightArm")
    RightArm.AnchorPoint = Vector2.new(0, 0)

    local LeftLeg = CreatePart("LeftLeg", UDim2.fromOffset(18, 70), UDim2.new(0.5, -2, 0, 100), "LeftLeg")
    LeftLeg.AnchorPoint = Vector2.new(1, 0)

    local RightLeg = CreatePart("RightLeg", UDim2.fromOffset(18, 70), UDim2.new(0.5, 2, 0, 100), "RightLeg")
    RightLeg.AnchorPoint = Vector2.new(0, 0)
end

UI.CreateSection(VisualsTab, "Other-Player ESP Elements")
UI.CreateToggle(VisualsTab, "Enable ESP", "ESP/Enabled", Flags["ESP/Enabled"], function(state)
    if not state then

        for _, player in ipairs(Players:GetPlayers()) do
             RemovePlayerOutlines(player)
        end
    end
end)
UI.CreateNumericInput(VisualsTab, "Max ESP Distance", "ESP/MaxDistance", Flags["ESP/MaxDistance"], 100, 10000, 100, " studs")
UI.CreateToggle(VisualsTab, "Non-Teammates Only", "ESP/TeamCheck", Flags["ESP/TeamCheck"])
UI.CreateToggle(VisualsTab, "Draw Status Emoji", "ESP/ShowStatus", Flags["ESP/ShowStatus"])
UI.CreateToggle(VisualsTab, "Draw Nickname", "ESP/ShowNickname", Flags["ESP/ShowNickname"])
UI.CreateToggle(VisualsTab, "Draw Username", "ESP/ShowUsername", Flags["ESP/ShowUsername"])
UI.CreateToggle(VisualsTab, "Draw Distance", "ESP/ShowDistance", Flags["ESP/ShowDistance"])
UI.CreateToggle(VisualsTab, "Draw Health Indicator", "ESP/HealthIndicator", Flags["ESP/HealthIndicator"])
UI.CreateToggle(VisualsTab, "Draw Equipped Item", "ESP/ShowEquipped", Flags["ESP/ShowEquipped"])
UI.CreateNumericInput(VisualsTab, "Nametag Opacity", "ESP/NametagOpacity", Flags["ESP/NametagOpacity"], 0, 100, 5, "%", function(val)
    UpdateAllNametagOpacities()
end)

UI.CreateToggle(VisualsTab, "Player Outlines (Hitbox)", "ESP/PlayerOutlines", Flags["ESP/PlayerOutlines"], function(state)

    if not state then
        local players = GetPlayersCache()
        for i = 1, #players do
            pcall(RemovePlayerOutlines, players[i])
        end
        table.clear(PlayerOutlineObjects)
        ActiveHighlightCount = 0
    end
end)

UI.CreateSection(VisualsTab, "Local UI Elements")
UI.CreateToggle(VisualsTab, "Show Performance Panel", "LocalUI/PerformancePanel", Flags["LocalUI/PerformancePanel"], function(state)
    if PerformanceLabel then PerformanceLabel.Visible = state end
end)
UI.CreateToggle(VisualsTab, "Show Local Health Indicator", "LocalUI/LocalHealthIndicator", Flags["LocalUI/LocalHealthIndicator"], function(state)
    if LocalHealthHUD then LocalHealthHUD.Visible = state end
end)
UI.CreateToggle(VisualsTab, "Show Closest Player Tracker", "LocalUI/ClosestPlayerTracker", Flags["LocalUI/ClosestPlayerTracker"], function(state)
    if ClosestPlayerTrackerLabel then ClosestPlayerTrackerLabel.Visible = state end
end)
UI.CreateToggle(VisualsTab, "Gh0st Mode (Ctrl+G)", "Settings/GhostMode", Flags["Settings/GhostMode"], function(state)
    if NotifyGui then NotifyGui.Enabled = not state end
end)
UI.CreateToggle(VisualsTab, "Enable Information Display (Ctrl+.)", "Visuals/InformationDisplay", Flags["Visuals/InformationDisplay"])
UI.CreateToggle(VisualsTab, "Scroll-unlocker", "Misc/ScrollUnlocker", Flags["Misc/ScrollUnlocker"], function(state)
    if not state then
        if ZoomState.OriginalMax then
            LocalPlayer.CameraMaxZoomDistance = ZoomState.OriginalMax
        end
        if ZoomState.OriginalMin then
            LocalPlayer.CameraMinZoomDistance = ZoomState.OriginalMin
        end
        ZoomState.LastSetMax = nil
        ZoomState.LastSetMin = nil
        ZoomState.Multiplier = 1
        ZoomState.WasCtrlHeld = false
        ZoomState.UserScrolled = false
    end
end)
UI.CreateNumericInput(VisualsTab, "Screen UI Opacity", "LocalUI/ScreenUIOpacity", Flags["LocalUI/ScreenUIOpacity"], 0, 100, 5, "%", function(val)
    UpdateScreenUIOpacity()
end)
UI.CreateNumericInput(VisualsTab, "UI Scale", "Visuals/UIScale", Flags["Visuals/UIScale"], 0.1, 2.0, 0.10, "", function(val)
    ApplyUIScale(UIState.MainFrame, val)
    ApplyUIScale(ItemPanelUI.MainFrame, val)
end)

-- Fullbright & FullDark Toggles ──────────────────────────────────────────
UI.CreateSection(VisualsTab, "Fullbright / FullDark")
UI.CreateToggle(VisualsTab, "Fullbright (Ctrl+F)", "Visuals/Fullbright", Flags["Visuals/Fullbright"], function(state)
    if state then
        Flags["Visuals/FullDark"] = false
        local updater = UIState.Updaters["Visuals/FullDark"]
        if updater then updater(false) end
    end
end)
UI.CreateToggle(VisualsTab, "FullDark (Ctrl+N)", "Visuals/FullDark", Flags["Visuals/FullDark"], function(state)
    if state then
        Flags["Visuals/Fullbright"] = false
        local updater = UIState.Updaters["Visuals/Fullbright"]
        if updater then updater(false) end
    end
end)

-- Fullbright Modifier Settings ────────────────────────────────────────────
UI.CreateSection(VisualsTab, "Fullbright Settings")
UI.CreateNumericInput(VisualsTab, "FB: Time of Day (0-24)", "Visuals/Fullbright/ClockTime",
    Flags["Visuals/Fullbright/ClockTime"], 0, 23.99, 0.25, "h", nil)
UI.CreateNumericInput(VisualsTab, "FB: Brightness", "Visuals/Fullbright/Brightness",
    Flags["Visuals/Fullbright/Brightness"], 0, 10, 0.1, "", nil)
UI.CreateToggle(VisualsTab, "FB: Set Exposure", "Visuals/Fullbright/SetExposure",
    Flags["Visuals/Fullbright/SetExposure"], nil)
UI.CreateNumericInput(VisualsTab, "FB: Exposure Compensation", "Visuals/Fullbright/ExposureCompensation",
    Flags["Visuals/Fullbright/ExposureCompensation"], -5, 5, 0.1, "", nil)
UI.CreateToggle(VisualsTab, "FB: Remove Fog", "Visuals/Fullbright/RemoveFog",
    Flags["Visuals/Fullbright/RemoveFog"], nil)
UI.CreateNumericInput(VisualsTab, "FB: Fog Far Distance", "Visuals/Fullbright/FogEnd",
    Flags["Visuals/Fullbright/FogEnd"], 0, 1000000, 1000, "m", nil)
UI.CreateNumericInput(VisualsTab, "FB: Fog Near Distance", "Visuals/Fullbright/FogStart",
    Flags["Visuals/Fullbright/FogStart"], 0, 100000, 100, "m", nil)
UI.CreateToggle(VisualsTab, "FB: Remove Shadows", "Visuals/Fullbright/RemoveShadows",
    Flags["Visuals/Fullbright/RemoveShadows"], nil)
UI.CreateToggle(VisualsTab, "FB: White Ambient Light", "Visuals/Fullbright/WhiteAmbient",
    Flags["Visuals/Fullbright/WhiteAmbient"], nil)
UI.CreateToggle(VisualsTab, "FB: Remove Atmosphere", "Visuals/Fullbright/RemoveAtmosphere",
    Flags["Visuals/Fullbright/RemoveAtmosphere"], nil)
UI.CreateNumericInput(VisualsTab, "FB: Sky Haze", "Visuals/Fullbright/SkyHaze",
    Flags["Visuals/Fullbright/SkyHaze"], 0, 10, 0.1, "", nil)
UI.CreateNumericInput(VisualsTab, "FB: Sky Glare", "Visuals/Fullbright/SkyGlare",
    Flags["Visuals/Fullbright/SkyGlare"], 0, 10, 0.1, "", nil)

-- FullDark Modifier Settings ───────────────────────────────────────────────
UI.CreateSection(VisualsTab, "FullDark Settings")
UI.CreateNumericInput(VisualsTab, "FD: Time of Day (0-24)", "Visuals/FullDark/ClockTime",
    Flags["Visuals/FullDark/ClockTime"], 0, 23.99, 0.25, "h", nil)
UI.CreateNumericInput(VisualsTab, "FD: Brightness", "Visuals/FullDark/Brightness",
    Flags["Visuals/FullDark/Brightness"], 0, 10, 0.1, "", nil)
UI.CreateToggle(VisualsTab, "FD: Set Exposure", "Visuals/FullDark/SetExposure",
    Flags["Visuals/FullDark/SetExposure"], nil)
UI.CreateNumericInput(VisualsTab, "FD: Exposure Compensation", "Visuals/FullDark/ExposureCompensation",
    Flags["Visuals/FullDark/ExposureCompensation"], -5, 5, 0.1, "", nil)
UI.CreateToggle(VisualsTab, "FD: Black Ambient Light", "Visuals/FullDark/BlackAmbient",
    Flags["Visuals/FullDark/BlackAmbient"], nil)
UI.CreateToggle(VisualsTab, "FD: Enable Shadows", "Visuals/FullDark/SetShadows",
    Flags["Visuals/FullDark/SetShadows"], nil)
UI.CreateToggle(VisualsTab, "FD: Apply Fog", "Visuals/FullDark/SetFog",
    Flags["Visuals/FullDark/SetFog"], nil)
UI.CreateNumericInput(VisualsTab, "FD: Fog Far Distance", "Visuals/FullDark/FogEnd",
    Flags["Visuals/FullDark/FogEnd"], 0, 1000000, 100, "m", nil)
UI.CreateNumericInput(VisualsTab, "FD: Fog Near Distance", "Visuals/FullDark/FogStart",
    Flags["Visuals/FullDark/FogStart"], 0, 100000, 10, "m", nil)
UI.CreateToggle(VisualsTab, "FD: Apply Atmosphere", "Visuals/FullDark/SetAtmosphere",
    Flags["Visuals/FullDark/SetAtmosphere"], nil)
UI.CreateNumericInput(VisualsTab, "FD: Atmosphere Density", "Visuals/FullDark/AtmosphereDensity",
    Flags["Visuals/FullDark/AtmosphereDensity"], 0, 1, 0.05, "", nil)
UI.CreateNumericInput(VisualsTab, "FD: Sky Haze", "Visuals/FullDark/SkyHaze",
    Flags["Visuals/FullDark/SkyHaze"], 0, 10, 0.1, "", nil)
UI.CreateNumericInput(VisualsTab, "FD: Sky Glare", "Visuals/FullDark/SkyGlare",
    Flags["Visuals/FullDark/SkyGlare"], 0, 10, 0.1, "", nil)

-- Current World Lighting Live Editor ──────────────────────────────────────
do
    -- Local table to hold updater functions so the Refresh button can repopulate all fields
    local LiveLightingUpdaters = {}

    -- Helper: create a numeric input that reads/writes directly to Services.Lighting
    -- getter()  -> current numeric value
    -- setter(v) -> applies v to the world immediately
    local function MakeLiveLightingNumeric(labelText, key, getter, setter, minV, maxV, stepV, unit)
        local currentVal = math.clamp(tonumber(getter()) or 0, minV, maxV)
        UI.CreateNumericInput(VisualsTab, labelText, "LiveLight/" .. key, currentVal, minV, maxV, stepV, unit,
            function(val)
                pcall(setter, val)
            end
        )
        LiveLightingUpdaters[key] = function()
            local v = math.clamp(tonumber(getter()) or 0, minV, maxV)
            local upd = UIState.Updaters["LiveLight/" .. key]
            if upd then upd(v) end
        end
    end

    -- Helper: create a toggle that reads/writes a boolean property on Services.Lighting
    local function MakeLiveLightingToggle(labelText, key, getter, setter)
        local currentVal = getter()
        UI.CreateToggle(VisualsTab, labelText, "LiveLight/" .. key, currentVal,
            function(val)
                pcall(setter, val)
            end
        )
        LiveLightingUpdaters[key] = function()
            local v = getter()
            local upd = UIState.Updaters["LiveLight/" .. key]
            if upd then upd(v) end
        end
    end

    UI.CreateSection(VisualsTab, "Current World Lighting")

    -- Refresh button — re-reads all live lighting values from the world and updates every input
    UI.CreateButton(VisualsTab, "⟳  Refresh Values from World", function()
        for _, fn in pairs(LiveLightingUpdaters) do
            pcall(fn)
        end
    end)

    -- Time & Exposure ────────────────────────────────────────────────────
    MakeLiveLightingNumeric("Clock Time (0–24 h)", "ClockTime",
        function() return Services.Lighting.ClockTime end,
        function(v) Services.Lighting.ClockTime = v end,
        0, 23.99, 0.25, "h")

    MakeLiveLightingNumeric("Brightness", "Brightness",
        function() return Services.Lighting.Brightness end,
        function(v) Services.Lighting.Brightness = v end,
        0, 10, 0.1, "")

    MakeLiveLightingNumeric("Exposure Compensation", "ExposureCompensation",
        function() return Services.Lighting.ExposureCompensation end,
        function(v) Services.Lighting.ExposureCompensation = v end,
        -5, 5, 0.1, "")

    -- Ambient ────────────────────────────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Ambient (RGB 0–255)")
    MakeLiveLightingNumeric("Ambient  R", "Ambient_R",
        function() return math.floor(Services.Lighting.Ambient.R * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.Ambient
            Services.Lighting.Ambient = Color3.fromRGB(v, math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
        end, 0, 255, 1, "")
    MakeLiveLightingNumeric("Ambient  G", "Ambient_G",
        function() return math.floor(Services.Lighting.Ambient.G * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.Ambient
            Services.Lighting.Ambient = Color3.fromRGB(math.floor(c.R*255+0.5), v, math.floor(c.B*255+0.5))
        end, 0, 255, 1, "")
    MakeLiveLightingNumeric("Ambient  B", "Ambient_B",
        function() return math.floor(Services.Lighting.Ambient.B * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.Ambient
            Services.Lighting.Ambient = Color3.fromRGB(math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), v)
        end, 0, 255, 1, "")

    UI.CreateSection(VisualsTab, "World Outdoor Ambient (RGB 0–255)")
    MakeLiveLightingNumeric("Outdoor Ambient  R", "OutdoorAmbient_R",
        function() return math.floor(Services.Lighting.OutdoorAmbient.R * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.OutdoorAmbient
            Services.Lighting.OutdoorAmbient = Color3.fromRGB(v, math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
        end, 0, 255, 1, "")
    MakeLiveLightingNumeric("Outdoor Ambient  G", "OutdoorAmbient_G",
        function() return math.floor(Services.Lighting.OutdoorAmbient.G * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.OutdoorAmbient
            Services.Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(c.R*255+0.5), v, math.floor(c.B*255+0.5))
        end, 0, 255, 1, "")
    MakeLiveLightingNumeric("Outdoor Ambient  B", "OutdoorAmbient_B",
        function() return math.floor(Services.Lighting.OutdoorAmbient.B * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.OutdoorAmbient
            Services.Lighting.OutdoorAmbient = Color3.fromRGB(math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), v)
        end, 0, 255, 1, "")

    -- Shadows ────────────────────────────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Shadows & Fog")
    MakeLiveLightingToggle("Global Shadows", "GlobalShadows",
        function() return Services.Lighting.GlobalShadows end,
        function(v) Services.Lighting.GlobalShadows = v end)

    -- Fog ───────────────────────────────────────────────────────────────
    MakeLiveLightingNumeric("Fog Near (FogStart)", "FogStart",
        function() return Services.Lighting.FogStart end,
        function(v) Services.Lighting.FogStart = v end,
        0, 100000, 10, "m")

    MakeLiveLightingNumeric("Fog Far (FogEnd)", "FogEnd",
        function() return Services.Lighting.FogEnd end,
        function(v) Services.Lighting.FogEnd = v end,
        0, 1000000, 1000, "m")

    UI.CreateSection(VisualsTab, "World Fog Color (RGB 0–255)")
    MakeLiveLightingNumeric("Fog Color  R", "FogColor_R",
        function() return math.floor(Services.Lighting.FogColor.R * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.FogColor
            Services.Lighting.FogColor = Color3.fromRGB(v, math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
        end, 0, 255, 1, "")
    MakeLiveLightingNumeric("Fog Color  G", "FogColor_G",
        function() return math.floor(Services.Lighting.FogColor.G * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.FogColor
            Services.Lighting.FogColor = Color3.fromRGB(math.floor(c.R*255+0.5), v, math.floor(c.B*255+0.5))
        end, 0, 255, 1, "")
    MakeLiveLightingNumeric("Fog Color  B", "FogColor_B",
        function() return math.floor(Services.Lighting.FogColor.B * 255 + 0.5) end,
        function(v)
            local c = Services.Lighting.FogColor
            Services.Lighting.FogColor = Color3.fromRGB(math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), v)
        end, 0, 255, 1, "")

    -- Atmosphere (if present) ────────────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Atmosphere")
    MakeLiveLightingNumeric("Atmo Density", "Atmo_Density",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and a.Density or 0
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then a.Density = v end
        end, 0, 1, 0.01, "")

    MakeLiveLightingNumeric("Atmo Offset", "Atmo_Offset",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and a.Offset or 0
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then a.Offset = v end
        end, 0, 1, 0.01, "")

    MakeLiveLightingNumeric("Atmo Haze", "Atmo_Haze",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and a.Haze or 0
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then a.Haze = v end
        end, 0, 10, 0.1, "")

    MakeLiveLightingNumeric("Atmo Glare", "Atmo_Glare",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and a.Glare or 0
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then a.Glare = v end
        end, 0, 10, 0.1, "")

    MakeLiveLightingNumeric("Atmo Decay R", "Atmo_Decay_R",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and math.floor(a.Color.R * 255 + 0.5) or 128
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then
                local c = a.Color
                a.Color = Color3.fromRGB(v, math.floor(c.G*255+0.5), math.floor(c.B*255+0.5))
            end
        end, 0, 255, 1, "")

    MakeLiveLightingNumeric("Atmo Decay G", "Atmo_Decay_G",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and math.floor(a.Color.G * 255 + 0.5) or 128
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then
                local c = a.Color
                a.Color = Color3.fromRGB(math.floor(c.R*255+0.5), v, math.floor(c.B*255+0.5))
            end
        end, 0, 255, 1, "")

    MakeLiveLightingNumeric("Atmo Decay B", "Atmo_Decay_B",
        function()
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            return a and math.floor(a.Color.B * 255 + 0.5) or 128
        end,
        function(v)
            local a = Services.Lighting:FindFirstChildOfClass("Atmosphere")
            if a then
                local c = a.Color
                a.Color = Color3.fromRGB(math.floor(c.R*255+0.5), math.floor(c.G*255+0.5), v)
            end
        end, 0, 255, 1, "")

    -- Bloom (if present) ─────────────────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Bloom Effect")
    MakeLiveLightingNumeric("Bloom Intensity", "Bloom_Intensity",
        function()
            local b = Services.Lighting:FindFirstChildOfClass("BloomEffect")
            return b and b.Intensity or 0
        end,
        function(v)
            local b = Services.Lighting:FindFirstChildOfClass("BloomEffect")
            if b then b.Intensity = v end
        end, 0, 10, 0.1, "")

    MakeLiveLightingNumeric("Bloom Size", "Bloom_Size",
        function()
            local b = Services.Lighting:FindFirstChildOfClass("BloomEffect")
            return b and b.Size or 0
        end,
        function(v)
            local b = Services.Lighting:FindFirstChildOfClass("BloomEffect")
            if b then b.Size = v end
        end, 0, 56, 0.5, "")

    MakeLiveLightingNumeric("Bloom Threshold", "Bloom_Threshold",
        function()
            local b = Services.Lighting:FindFirstChildOfClass("BloomEffect")
            return b and b.Threshold or 0
        end,
        function(v)
            local b = Services.Lighting:FindFirstChildOfClass("BloomEffect")
            if b then b.Threshold = v end
        end, 0, 1, 0.01, "")

    -- ColorCorrection (if present) ───────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Color Correction")
    MakeLiveLightingNumeric("CC Brightness", "CC_Brightness",
        function()
            local cc = Services.Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            return cc and cc.Brightness or 0
        end,
        function(v)
            local cc = Services.Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            if cc then cc.Brightness = v end
        end, -1, 1, 0.01, "")

    MakeLiveLightingNumeric("CC Contrast", "CC_Contrast",
        function()
            local cc = Services.Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            return cc and cc.Contrast or 0
        end,
        function(v)
            local cc = Services.Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            if cc then cc.Contrast = v end
        end, -1, 1, 0.01, "")

    MakeLiveLightingNumeric("CC Saturation", "CC_Saturation",
        function()
            local cc = Services.Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            return cc and cc.Saturation or 0
        end,
        function(v)
            local cc = Services.Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
            if cc then cc.Saturation = v end
        end, -1, 1, 0.01, "")

    -- SunRays (if present) ───────────────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Sun Rays")
    MakeLiveLightingNumeric("SunRays Intensity", "SunRays_Intensity",
        function()
            local sr = Services.Lighting:FindFirstChildOfClass("SunRaysEffect")
            return sr and sr.Intensity or 0
        end,
        function(v)
            local sr = Services.Lighting:FindFirstChildOfClass("SunRaysEffect")
            if sr then sr.Intensity = v end
        end, 0, 1, 0.01, "")

    MakeLiveLightingNumeric("SunRays Spread", "SunRays_Spread",
        function()
            local sr = Services.Lighting:FindFirstChildOfClass("SunRaysEffect")
            return sr and sr.Spread or 0
        end,
        function(v)
            local sr = Services.Lighting:FindFirstChildOfClass("SunRaysEffect")
            if sr then sr.Spread = v end
        end, 0, 1, 0.01, "")

    -- DepthOfField (if present) ──────────────────────────────────────────
    UI.CreateSection(VisualsTab, "World Depth of Field")
    MakeLiveLightingNumeric("DOF Far Intensity", "DOF_FarIntensity",
        function()
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            return d and d.FarIntensity or 0
        end,
        function(v)
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            if d then d.FarIntensity = v end
        end, 0, 1, 0.01, "")

    MakeLiveLightingNumeric("DOF Near Intensity", "DOF_NearIntensity",
        function()
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            return d and d.NearIntensity or 0
        end,
        function(v)
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            if d then d.NearIntensity = v end
        end, 0, 1, 0.01, "")

    MakeLiveLightingNumeric("DOF Focus Distance", "DOF_FocusDistance",
        function()
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            return d and d.FocusDistance or 0
        end,
        function(v)
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            if d then d.FocusDistance = v end
        end, 0, 1000, 1, "m")

    MakeLiveLightingNumeric("DOF In Focus Radius", "DOF_InFocusRadius",
        function()
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            return d and d.InFocusRadius or 0
        end,
        function(v)
            local d = Services.Lighting:FindFirstChildOfClass("DepthOfFieldEffect")
            if d then d.InFocusRadius = v end
        end, 0, 1000, 1, "m")
end

UI.CreateSection(VisualsTab, "Closest Player Panel Settings")
UI.CreateToggle(VisualsTab, "Show Display Name", "LocalUI/ClosestPlayer/ShowDisplayName", Flags["LocalUI/ClosestPlayer/ShowDisplayName"], function(state)
    UpdateClosestPlayerTracker()
end)
UI.CreateToggle(VisualsTab, "Show Username", "LocalUI/ClosestPlayer/ShowUsername", Flags["LocalUI/ClosestPlayer/ShowUsername"], function(state)
    UpdateClosestPlayerTracker()
end)
UI.CreateToggle(VisualsTab, "Show Distance", "LocalUI/ClosestPlayer/ShowDistance", Flags["LocalUI/ClosestPlayer/ShowDistance"], function(state)
    UpdateClosestPlayerTracker()
end)
UI.CreateToggle(VisualsTab, "Show Health", "LocalUI/ClosestPlayer/ShowHealth", Flags["LocalUI/ClosestPlayer/ShowHealth"], function(state)
    UpdateClosestPlayerTracker()
end)
UI.CreateToggle(VisualsTab, "Show Equipped Item", "LocalUI/ClosestPlayer/ShowEquipped", Flags["LocalUI/ClosestPlayer/ShowEquipped"], function(state)
    UpdateClosestPlayerTracker()
end)

UI.CreateSection(VisualsTab, "Waypoints Settings(Ctrl+Middle Mouse Button)")
UI.CreateToggle(VisualsTab, "Enable Waypoints", "Waypoints/Enabled", Flags["Waypoints/Enabled"], function(state)
    RefreshWaypointUI()
end)

-- Assign the module-level _updateHum upvalue (forward-declared at the top of the file).
-- ConfigManager.LoadProfile references it by upvalue, so it must NOT be local here.
_updateHum = function(prop, val)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        pcall(SafeSetProp, hum, prop, val)
    end
end

UI.CreateSection(HumanoidTab, "Behavior")
UI.CreateToggle(HumanoidTab, "Archivable", "Humanoid/Archivable", Flags["Humanoid/Archivable"], function(v) _updateHum("Archivable", v) end, true)
UI.CreateToggle(HumanoidTab, "Break Joints On Death", "Humanoid/BreakJointsOnDeath", Flags["Humanoid/BreakJointsOnDeath"], function(v) _updateHum("BreakJointsOnDeath", v) end, true)
UI.CreateToggle(HumanoidTab, "Evaluate State Machine", "Humanoid/EvaluateStateMachine", Flags["Humanoid/EvaluateStateMachine"], function(v) _updateHum("EvaluateStateMachine", v) end, true)
UI.CreateToggle(HumanoidTab, "Requires Neck", "Humanoid/RequiresNeck", Flags["Humanoid/RequiresNeck"], function(v) _updateHum("RequiresNeck", v) end, true)

UI.CreateSection(HumanoidTab, "Control")
UI.CreateToggle(HumanoidTab, "Auto Rotate", "Humanoid/AutoRotate", Flags["Humanoid/AutoRotate"], function(v) _updateHum("AutoRotate", v) end, true)
UI.CreateToggle(HumanoidTab, "Platform Stand", "Humanoid/PlatformStand", Flags["Humanoid/PlatformStand"], function(v) _updateHum("PlatformStand", v) end, true)
UI.CreateToggle(HumanoidTab, "Sit", "Humanoid/Sit", Flags["Humanoid/Sit"], function(v) _updateHum("Sit", v) end, true)
UI.CreateToggle(HumanoidTab, "Jump", "Humanoid/Jump", Flags["Humanoid/Jump"], function(v)
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.Jump = v
    end
end, true)

UI.CreateSection(HumanoidTab, "Jump Settings")
UI.CreateToggle(HumanoidTab, "Auto Jump Enabled", "Humanoid/AutoJumpEnabled", Flags["Humanoid/AutoJumpEnabled"], function(v) _updateHum("AutoJumpEnabled", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Jump Height", "Humanoid/JumpHeight", Flags["Humanoid/JumpHeight"], 0, 500, 1, nil, function(v) _updateHum("JumpHeight", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Jump Power", "Humanoid/JumpPower", Flags["Humanoid/JumpPower"], 0, 500, 1, nil, function(v) _updateHum("JumpPower", v) end, true)
UI.CreateToggle(HumanoidTab, "Use Jump Power", "Humanoid/UseJumpPower", Flags["Humanoid/UseJumpPower"], function(v) _updateHum("UseJumpPower", v) end, true)

UI.CreateSection(HumanoidTab, "Game")
UI.CreateToggle(HumanoidTab, "Automatic Scaling Enabled", "Humanoid/AutomaticScalingEnabled", Flags["Humanoid/AutomaticScalingEnabled"], function(v) _updateHum("AutomaticScalingEnabled", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Health", "Humanoid/Health", Flags["Humanoid/Health"], 0, 2000, 1, nil, function(v) _updateHum("Health", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Max Health", "Humanoid/MaxHealth", Flags["Humanoid/MaxHealth"], 0, 2000, 1, nil, function(v) _updateHum("MaxHealth", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Hip Height", "Humanoid/HipHeight", Flags["Humanoid/HipHeight"], 0, 100, 1, nil, function(v) _updateHum("HipHeight", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Max Slope Angle", "Humanoid/MaxSlopeAngle", Flags["Humanoid/MaxSlopeAngle"], 0, 90, 1, nil, function(v) _updateHum("MaxSlopeAngle", v) end, true)
UI.CreateNumericInput(HumanoidTab, "Walk Speed", "Humanoid/WalkSpeed", Flags["Humanoid/WalkSpeed"], 0, 500, 1, nil, function(v) _updateHum("WalkSpeed", v) end, true)

UI.CreateSection(HumanoidTab, "Rotation")
UI.CreateRotationSlider(HumanoidTab, "Rotation X", "Humanoid/RotationX", 0)
UI.CreateRotationSlider(HumanoidTab, "Rotation Y", "Humanoid/RotationY", 0)
UI.CreateRotationSlider(HumanoidTab, "Rotation Z", "Humanoid/RotationZ", 0)


UI.CreateSection(MiscTab, "Br3ak3r Tool")
UI.CreateToggle(MiscTab, "Enable Br3ak3r", "Br3ak3r/Enabled", Flags["Br3ak3r/Enabled"], function(state)
    Br3ak3rState.CLICKBREAK_ENABLED = state
    if not state and Br3ak3rState.hoverHL then
        Br3ak3rState.hoverHL.Enabled = false
    end
end)
UI.CreateButton(MiscTab, "Undo Last Break (Ctrl+Z)", unbreakLast)
UI.CreateButton(MiscTab, "Clear All Breaks (Ctrl+X)", unbreakAll)

UI.CreateSection(MiscTab, "H1ghl1ght3r Tool")
UI.CreateToggle(MiscTab, "Enable H1ghl1ght3r", "H1ghl1ght3r/Enabled", H1ghl1ght3rState.ENABLED, function(state)
    H1ghl1ght3rState.ENABLED = state
    if not state and Br3ak3rState.hoverHL then
        Br3ak3rState.hoverHL.Enabled = false
    end
end)
UI.CreateButton(MiscTab, "Undo Last Highlight (Ctrl+Shift+Z)", unhighlightLast)

UI.CreateSection(MiscTab, "Utilities")
UI.CreateToggle(MiscTab, "Toggle Item Panel", "Misc/ItemPanel", Flags["Misc/ItemPanel"], function(state)
    ItemPanelState.Visible = state
    if state then
        if not ItemPanelUI.MainFrame then
            CreateItemPanel()
        end
        UpdateItemPanelUI()
        ItemPanelUI.MainFrame.Visible = true
    else
        if ItemPanelUI.MainFrame then
            ItemPanelUI.MainFrame.Visible = false
        end
    end
end)
UI.CreateToggle(MiscTab, "Q-Teleport — Press Ctrl+Q to tp to mouse position", "Misc/QTeleport", Flags["Misc/QTeleport"], function(state)
    Flags["Misc/QTeleport"] = state
end)
UI.CreateButton(MiscTab, "Rejoin Server", Rejoin)
UI.CreateButton(MiscTab, "Copy gameInstanceId Link", function()
    local url = "https://www.roblox.com/games/start?placeId=" .. tostring(game.PlaceId) .. "&gameInstanceId=" .. tostring(game.JobId)
    local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if copy then
        pcall(function() copy(url) end)
        UI.Notify("Game Join Link", "Game join link has been copied to clipboard", 5)
    else
        UI.Notify("Game Join Link", "Clipboard function not supported by your exploit", 5)
    end
end)
UI.CreateButton(MiscTab, "Unload Script", Cleanup)
UI.CreateButton(MiscTab, "Force Reload (Reload latest script version from GitHub)", ForceReload)

UI.CreateSection(MiscTab, "Configuration")

do
    local smRow = Instance.new("Frame")
    smRow.Size = UDim2.new(1, 0, 0, 28)
    smRow.BackgroundColor3 = SAFE_MODE and Color3.fromRGB(20, 60, 30) or Color3.fromRGB(50, 25, 25)
    smRow.BorderSizePixel = 0
    smRow.Parent = MiscTab
    local smCorner = Instance.new("UICorner")
    smCorner.CornerRadius = UDim.new(0, 6)
    smCorner.Parent = smRow
    local smStroke = Instance.new("UIStroke")
    smStroke.Color = SAFE_MODE and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(160, 50, 50)
    smStroke.Thickness = 1
    smStroke.Parent = smRow
    local smLabel = Instance.new("TextLabel")
    smLabel.Size = UDim2.fromScale(1, 1)
    smLabel.BackgroundTransparency = 1
    smLabel.Text = SAFE_MODE
        and "✓  Safe Mode: ON  — Tracking & Input Simulation disabled"
        or  "⚠  Safe Mode: OFF — All features active (set at script top)"
    smLabel.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
    smLabel.TextSize = 10
    smLabel.TextColor3 = SAFE_MODE and Color3.fromRGB(60, 210, 100) or Color3.fromRGB(220, 100, 100)
    smLabel.TextWrapped = true
    smLabel.Parent = smRow
end
UI.CreateButton(MiscTab, "Activate/Deactivate Freecam", function()
    if type(FreecamProxy.ToggleFreecam) == "function" then
        FreecamProxy.ToggleFreecam()
    elseif type(_G.ToggleFreecamFunc) == "function" then
        _G.ToggleFreecamFunc()
    end
end)
UI.CreateToggle(MiscTab, "Freecam Toggle (Ctrl+P)", "Settings/Freecam Toggle", Flags["Settings/Freecam Toggle"], function(state)
    if not state and type(FreecamProxy.StopFreecam) == "function" then
        FreecamProxy.StopFreecam()
    elseif not state and type(_G.StopFreecamFunc) == "function" then
        _G.StopFreecamFunc()
    end
end)

UI.CreateNumericInput(MiscTab, "Horizontal Position Force Distance", "Misc/HorizontalPositionForceValue", Flags["Misc/HorizontalPositionForceValue"], 0.1, 100, 0.05, "studs")
UI.CreateNumericInput(MiscTab, "Vertical Position Force Distance", "Misc/VerticalPositionForceValue", Flags["Misc/VerticalPositionForceValue"], 0.1, 100, 0.05, "studs")

UI.CreateButton(MiscTab, "Copy Sp3arParvus GitHub Link", function()
    local url = "https://www.pingbird.org/~/sp3arparvus"
    local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if copy then
        pcall(function() copy(url) end)
        UI.Notify("GitHub", "Sp3arParvus link has been added to clipboard", 5)
    end
end)

do
    -- Support button: splits into Buy Me a Coffee / Ko-fi on click
    local supportContainer = Instance.new("Frame")
    supportContainer.Size = UDim2.new(1, 0, 0, 36)
    supportContainer.BackgroundTransparency = 1
    supportContainer.BorderSizePixel = 0
    supportContainer.ClipsDescendants = true
    supportContainer.Parent = MiscTab

    local supportListLayout = Instance.new("UIListLayout")
    supportListLayout.FillDirection = Enum.FillDirection.Horizontal
    supportListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    supportListLayout.Padding = UDim.new(0, 6)
    supportListLayout.Parent = supportContainer

    local function makeSupportBtn(text, layoutOrder, color, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 1, 0)   -- width controlled by tween
        btn.AutomaticSize = Enum.AutomaticSize.None
        btn.BackgroundColor3 = color or UI_THEME.Accent
        btn.BackgroundTransparency = 0.2
        btn.BorderSizePixel = 0
        btn.Text = text
        btn.FontFace = Font.fromName("Montserrat", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
        btn.TextSize = 13
        btn.TextColor3 = UI_THEME.Background
        btn.ClipsDescendants = true
        btn.LayoutOrder = layoutOrder
        btn.Parent = supportContainer

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, 6)
        corner.Parent = btn

        local stroke = Instance.new("UIStroke")
        stroke.Color = color or UI_THEME.Accent
        stroke.Thickness = 1
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = btn

        TrackConnection(btn.MouseButton1Click:Connect(function()
            TweenService:Create(btn, TWEENS.INSTANT, {Size = UDim2.new(0, btn.AbsoluteSize.X - 4, 0, 32)}):Play()
            task.wait(0.05)
            TweenService:Create(btn, TWEENS.INSTANT, {Size = UDim2.new(0, btn.AbsoluteSize.X + 4, 0, 36)}):Play()
            if callback then callback() end
        end))

        return btn
    end

    local supportBtn = makeSupportBtn("❤  Support", 1, UI_THEME.Accent, nil)
    TweenService:Create(supportBtn, TWEENS.INSTANT, {Size = UDim2.new(1, 0, 1, 0)}):Play()

    local bmcBtn  = makeSupportBtn("☕  Buy Me a Coffee", 1, UI_THEME.Accent, nil)
    local kofiBtn = makeSupportBtn("🍵  Ko-fi", 2, UI_THEME.Accent, nil)

    -- Start sub-buttons hidden (zero width)
    bmcBtn.Visible  = false
    kofiBtn.Visible = false

    local expanded = false

    TrackConnection(supportBtn.MouseButton1Click:Connect(function()
        if expanded then return end
        expanded = true

        -- Press animation on the main button
        TweenService:Create(supportBtn, TWEENS.INSTANT, {Size = UDim2.new(1, -4, 0, 32)}):Play()
        task.wait(0.05)

        -- Hide main button, reveal sub-buttons
        supportBtn.Visible = false
        bmcBtn.Visible  = true
        kofiBtn.Visible = true

        local containerWidth = supportContainer.AbsoluteSize.X
        local half = math.floor((containerWidth - 6) / 2)  -- 6px gap

        bmcBtn.Size  = UDim2.new(0, 0, 1, 0)
        kofiBtn.Size = UDim2.new(0, 0, 1, 0)

        TweenService:Create(bmcBtn,  TWEENS.SMOOTH, {Size = UDim2.new(0, half, 1, 0)}):Play()
        TweenService:Create(kofiBtn, TWEENS.SMOOTH, {Size = UDim2.new(0, half, 1, 0)}):Play()
    end))

    -- Buy Me a Coffee callback
    TrackConnection(bmcBtn.MouseButton1Click:Connect(function()
        local url = "https://buymeacoffee.com/Hukari"
        local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
        if copy then
            pcall(function() copy(url) end)
            UI.Notify("Support", "Buy Me a Coffee link copied to clipboard!", 5)
        else
            UI.Notify("Support", "Clipboard not supported by your exploit", 5)
        end
    end))

    -- Ko-fi callback
    TrackConnection(kofiBtn.MouseButton1Click:Connect(function()
        local url = "https://ko-fi.com/hukari"
        local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
        if copy then
            pcall(function() copy(url) end)
            UI.Notify("Support", "Ko-fi link copied to clipboard!", 5)
        else
            UI.Notify("Support", "Clipboard not supported by your exploit", 5)
        end
    end))
end

UI.CreateButton(MiscTab, "Join Official Discord Server", function()
    local inviteCode = "KJuxMnBFqB"
    local url = "https://discord.gg/" .. inviteCode
    local copy = setclipboard or toclipboard or set_clipboard or (Clipboard and Clipboard.set)
    if copy then
        pcall(function() copy(url) end)
        UI.Notify("Discord", "Discord invite link has been copied to clipboard", 5)
    else
        UI.Notify("Discord", "Clipboard function not supported by your exploit", 5)
    end

    local req = syn and syn.request or http and http.request or http_request or request
    if req then
        pcall(function()
            req({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Origin"] = "https://discord.com"
                },
                Body = game:GetService("HttpService"):JSONEncode({
                    cmd = "INVITE_BROWSER",
                    args = {
                        code = inviteCode
                    },
                    nonce = game:GetService("HttpService"):GenerateGUID(false)
                })
            })
        end)
    end
end)

function SetupPlayerESP(player)
    if player == LocalPlayer then return end
    if not DNR(LocalPlayer) and DNR(player) then return end

    CreateESP(player)
    local espData = ESPObjects[player]

    if espData then

        if espData.Connections then
            for _, conn in pairs(espData.Connections) do
                if conn and typeof(conn) == "RBXScriptConnection" and conn.Connected then
                    conn:Disconnect()
                end
            end
            table.clear(espData.Connections)
        else
            espData.Connections = {}
        end

        local conn = player.CharacterAdded:Connect(function(character)

            CharCache[player] = nil

            if espData.waitingForChar then return end
            espData.waitingForChar = true

            local attempts = 0
            local root = nil
            repeat
                task.wait(0.2)
                if not player.Parent then break end
                root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
                attempts = attempts + 1
            until root or attempts > 10

            espData.waitingForChar = nil

            if player.Parent and Sp3arParvus.Active then

                local data = ESPObjects[player]
                if data then

                    data.lastNickname = ""
                    data.lastUsername = ""
                    data.lastDistance = -1
                    data.lastTeamColor = nil
                    data.lastDistanceColor = nil
                    data.lastStatus = ""

                    EnsureScreenGui()

                    UpdateESP(os.clock(), player, player == NearestPlayerRef)
                end
            end
        end)
        table.insert(espData.Connections, conn)

        if player.Character then
            if espData.waitingForChar then return end
            espData.waitingForChar = true

            task.spawn(function()
                local character = player.Character

                CharCache[player] = nil

                local attempts = 0
                local root = nil
                repeat
                    task.wait(0.2)
                    if not player.Parent then break end
                    root = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
                    attempts = attempts + 1
                until root or attempts > 10

                espData.waitingForChar = nil

                if player.Parent and Sp3arParvus.Active then

                    espData.lastNickname = ""
                    espData.lastUsername = ""
                    espData.lastDistance = -1
                    espData.lastTeamColor = nil
                    espData.lastDistanceColor = nil
                    espData.lastStatus = ""

                    EnsureScreenGui()
                    UpdateESP(os.clock(), player, player == NearestPlayerRef)
                end
            end)
        end
    end
end

local isLocalDNR = DNR(LocalPlayer)
for _, player in ipairs(Players:GetPlayers()) do
    if not isLocalDNR and DNR(player) then
        continue
    end
    SetupPlayerESP(player)
end

TrackConnection(Players.PlayerAdded:Connect(function(player)
    AddPlayerToCache(player)
    if not DNR(LocalPlayer) and DNR(player) then
        return
    end
    SetupPlayerESP(player)

    if Flags["Aim/AutoWhitelistFriends"] then
        task.spawn(function()
            if LocalPlayer and LocalPlayer.UserId > 0 and player.UserId > 0 then
                pcall(function()
                    if LocalPlayer:IsFriendsWith(player.UserId) then
                        AdvancedPlayerPanelState.Whitelist[player.UserId] = true
                    end
                end)
            end
        end)
    end

    if AdvancedPlayerPanelState.Whitelist[player.UserId] then
        UI.Notify("☮️ Whitelist", "Whitelisted player " .. (player.Name or "Unknown") .. " has joined the server")
    elseif AdvancedPlayerPanelState.Blacklist[player.UserId] then
        UI.Notify("☠️ Blacklist", "Blacklisted player " .. (player.Name or "Unknown") .. " has joined the server")
    elseif IsPlayerPrioritized(player) then
        UI.Notify("⭐ Prioritized", "Prioritized player " .. (player.Name or "Unknown") .. " has joined the server")
    end
end))
TrackConnection(Players.PlayerRemoving:Connect(function(player)
    RemovePlayerFromCache(player)
    CharCache[player] = nil
    RemoveESP(player)
    RemovePlayerOutlines(player)   -- L-1 fix: immediately release the pooled Highlight

    if AdvancedPlayerPanelState.SelectedPlayer == player then
        AdvancedPlayerPanelState.SelectedPlayer = nil
        SwitchToPlayerPageView("List")
    end
    if AdvancedPlayerPanelState.Spectating == player then
        AdvancedPlayerPanelState.Spectating = nil
    end

    if AdvancedPlayerPanelState.Whitelist[player.UserId] then
        UI.Notify("Whitelist", "Whitelisted player " .. (player.Name or "Unknown") .. " has left")
    elseif AdvancedPlayerPanelState.Blacklist[player.UserId] then
        UI.Notify("Blacklist", "Blacklisted player " .. (player.Name or "Unknown") .. " has left")
    elseif IsPlayerPrioritized(player) then
        UI.Notify("Prioritized", "Prioritized player " .. (player.Name or "Unknown") .. " has left")
    end
end))

TrackConnection(Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)

    if input.KeyCode == Enum.KeyCode.LeftControl then
        Br3ak3rState.LEFT_CTRL_HELD = true
        Br3ak3rState.CTRL_HELD = true
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        Br3ak3rState.RIGHT_CTRL_HELD = true
        Br3ak3rState.CTRL_HELD = true
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        H1ghl1ght3rState.SHIFT_HELD = true
    end

    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimState.Aim = Flags["Aim/AimLock"]
    end

    if not gameProcessed and (input.KeyCode == Enum.KeyCode.I or input.KeyCode == Enum.KeyCode.O) then
        ZoomState.UserScrolled = true
    end

    if not gameProcessed and Br3ak3rState.CTRL_HELD and input.UserInputType == Enum.UserInputType.MouseButton1 then
        if H1ghl1ght3rState.SHIFT_HELD and H1ghl1ght3rState.ENABLED then
            local origin, direction = GetMouseRay()
            if origin and direction then
                local hit = WorldRaycastBr3ak3r(origin, direction, true)
                if hit and hit.Instance and hit.Instance:IsA("BasePart") and not hit.Instance:IsA("Terrain") then
                    markHighlighted(hit.Instance)
                end
            end
        elseif Br3ak3rState.CLICKBREAK_ENABLED then
            local origin, direction = GetMouseRay()
            if origin and direction then
                local hit = WorldRaycastBr3ak3r(origin, direction, true)
                if hit and hit.Instance and hit.Instance:IsA("BasePart") and not hit.Instance:IsA("Terrain") then
                    markBroken(hit.Instance)
                end
            end
        end
    end

    if not gameProcessed and Br3ak3rState.CTRL_HELD and input.UserInputType == Enum.UserInputType.MouseButton3 then
        if Flags["Waypoints/Enabled"] then
            if H1ghl1ght3rState.SHIFT_HELD then
                local ids = {}
                for id in pairs(ActiveWaypoints) do
                    table.insert(ids, id)
                end
                for _, id in ipairs(ids) do
                    DestroyWaypoint(id)
                end
                if #ids > 0 then
                    UI.Notify("Waypoints", "All waypoints destroyed")
                end
            else

                local mouseLoc = UserInputService:GetMouseLocation()
                local origin, direction = GetMouseRay()
                local raycastHit = nil
                if origin and direction then
                    raycastHit = WorldRaycastBr3ak3r(origin, direction, true)
                end

                local deleted = false
                for id, wpData in pairs(ActiveWaypoints) do
                    local screenPos, onScreen = GetViewportPoint(wpData.Position)

                    local screenClose = false
                    if onScreen then
                        local dist = math.sqrt((mouseLoc.X - screenPos.X)^2 + (mouseLoc.Y - screenPos.Y)^2)
                        if dist < 60 then
                            screenClose = true
                        end
                    end

                    local worldClose = false
                    if raycastHit and raycastHit.Position then
                        local dist3D = (wpData.Position - raycastHit.Position).Magnitude
                        if dist3D < 15 then
                            worldClose = true
                        end
                    end

                    if screenClose or worldClose then
                        DestroyWaypoint(id)
                        deleted = true

                    end
                end

                if not deleted then
                    if raycastHit then
                        CreateWaypoint(raycastHit.Position)
                    else
                        local mouse = LocalPlayer:GetMouse()
                        if mouse and mouse.Hit then
                            CreateWaypoint(mouse.Hit.Position)
                        end
                    end
                end
            end
        end
    end

end))

TrackConnection(Services.UserInputService.InputEnded:Connect(function(input)

    if input.KeyCode == Enum.KeyCode.LeftControl then
        Br3ak3rState.LEFT_CTRL_HELD = false
        if not UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
            Br3ak3rState.CTRL_HELD = false
        end
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        Br3ak3rState.RIGHT_CTRL_HELD = false
        if not UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            Br3ak3rState.CTRL_HELD = false
        end
    elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
        if not UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) and not UserInputService:IsKeyDown(Enum.KeyCode.RightShift) then
            H1ghl1ght3rState.SHIFT_HELD = false
        end
    end

    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        AimState.Aim = false
    end
end))

TrackConnection(Services.UserInputService.InputChanged:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseWheel then
        local ctrlHeld = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
            or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        local shiftHeld = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)
            or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

        if ctrlHeld and shiftHeld and Br3ak3rState.CLICKBREAK_ENABLED then
            if input.Position.Z < 0 then
                -- Ctrl + Shift + Scroll Down  →  break part under cursor (same as Ctrl+Click)
                local origin, direction = GetMouseRay()
                if origin and direction then
                    local hit = WorldRaycastBr3ak3r(origin, direction, true)
                    if hit and hit.Instance and hit.Instance:IsA("BasePart") and not hit.Instance:IsA("Terrain") then
                        markBroken(hit.Instance)
                    end
                end
            elseif input.Position.Z > 0 then
                -- Ctrl + Shift + Scroll Up  →  undo last break (same as Ctrl+Z)
                unbreakLast()
            end
        else
            -- Ctrl+Shift scroll falls through as normal scroll (no zoom unlock expansion)
            ZoomState.UserScrolled = true
        end
    end
end))

TrackConnection(Services.UserInputService.TouchPinch:Connect(function(pinchScale, velocity, state, gameProcessed)
    if not gameProcessed then
        ZoomState.UserScrolled = true
    end
end))

local unhighlightLast = unhighlightLast
local unhighlightAll = unhighlightAll
local unbreakLast = unbreakLast
local unbreakAll = unbreakAll
local Rejoin = Rejoin
local Cleanup = Cleanup
local CreateAdvancedPlayerPanel = CreateAdvancedPlayerPanel
local CreateItemPanel = CreateItemPanel
local UpdateItemPanelUI = UpdateItemPanelUI
local loadstring = loadstring
local game = game
local ActiveWaypoints = ActiveWaypoints
local GetMouseRay = GetMouseRay
local WorldRaycastBr3ak3r = WorldRaycastBr3ak3r
local ForceReload = ForceReload

local activeMovementLoops = {}

local function startMovementLoop(keyCode)
    if activeMovementLoops[keyCode] then return end
    activeMovementLoops[keyCode] = true

    task.wait(0.4)

    local RunService = game:GetService("RunService")

    while activeMovementLoops[keyCode] do
        if SAFE_MODE then break end

        local ctrlHeld = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
        local keyHeld = Services.UserInputService:IsKeyDown(keyCode)

        if not (ctrlHeld and keyHeld) then break end

        local character = LocalPlayer and LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not rootPart then break end

        local hForceVal = Flags["Misc/HorizontalPositionForceValue"] or 3.0
        local vForceVal = Flags["Misc/VerticalPositionForceValue"] or 3.4
        local shiftHeld = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

        local dt = RunService.Heartbeat:Wait()
        local hSpeed = hForceVal * 4
        local vSpeed = vForceVal * 4

        if keyCode == Enum.KeyCode.Up then
            if shiftHeld then
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -hSpeed * dt)
            else
                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, vSpeed * dt, 0)
            end
        elseif keyCode == Enum.KeyCode.Down then
            if shiftHeld then
                rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, hSpeed * dt)
            else
                rootPart.CFrame = rootPart.CFrame + Vector3.new(0, -vSpeed * dt, 0)
            end
        elseif keyCode == Enum.KeyCode.Left then
            rootPart.CFrame = rootPart.CFrame * CFrame.new(-hSpeed * dt, 0, 0)
        elseif keyCode == Enum.KeyCode.Right then
            rootPart.CFrame = rootPart.CFrame * CFrame.new(hSpeed * dt, 0, 0)
        end
    end

    activeMovementLoops[keyCode] = nil
end

local function handleShortcuts(actionName, inputState, inputObject)
    if Services.UserInputService:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end

    if inputState == Enum.UserInputState.End then
        if inputObject.KeyCode == Enum.KeyCode.Up or inputObject.KeyCode == Enum.KeyCode.Down or inputObject.KeyCode == Enum.KeyCode.Left or inputObject.KeyCode == Enum.KeyCode.Right then
            activeMovementLoops[inputObject.KeyCode] = nil
        end
        return Enum.ContextActionResult.Pass
    end

    if inputState ~= Enum.UserInputState.Begin then return Enum.ContextActionResult.Pass end

    local ctrlHeld = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightControl)
    local shiftHeld = Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or Services.UserInputService:IsKeyDown(Enum.KeyCode.RightShift)

    if ctrlHeld then
        if inputObject.KeyCode == Enum.KeyCode.Z then
            if shiftHeld then
                unhighlightLast()
            else
                unbreakLast()
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.X then
            if shiftHeld then
                unhighlightAll()
            else
                unbreakAll()
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.B then
            Br3ak3rState.CLICKBREAK_ENABLED = not Br3ak3rState.CLICKBREAK_ENABLED
            Flags["Br3ak3r/Enabled"] = Br3ak3rState.CLICKBREAK_ENABLED

            local updater = UIState.Updaters["Br3ak3r/Enabled"]
            if updater then updater(Br3ak3rState.CLICKBREAK_ENABLED) end

            UI.Notify("Br3ak3r", string.format("Br3ak3r has been %s with 'Ctrl+B'", Br3ak3rState.CLICKBREAK_ENABLED and "activated" or "deactivated"))

            if not Br3ak3rState.CLICKBREAK_ENABLED and Br3ak3rState.hoverHL then
                Br3ak3rState.hoverHL.Enabled = false
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.E then
            UI.Notify("Any-Item-ESP", "Executing Any-Item-ESP...")
            loadstring(game:HttpGet("https://raw.githubusercontent.com/JakeHukari/Any-Item-ESP/refs/heads/main/any_item_esp.lua", true))()
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.R then
            if shiftHeld then
                ForceReload()
            else
                Rejoin()
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.U then
            UI.Notify("Sp3arParvus", "Unloaded with 'Ctrl+U'")
            Cleanup()
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.F then
            Flags["Visuals/Fullbright"] = not Flags["Visuals/Fullbright"]
            local state = Flags["Visuals/Fullbright"]
            if state then
                Flags["Visuals/FullDark"] = false
                local updater = UIState.Updaters["Visuals/FullDark"]
                if updater then updater(false) end
            end
            UI.Notify("Fullbright", string.format("Fullbright has been %s with 'Ctrl+F'", state and "activated" or "deactivated"))
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.N then
            Flags["Visuals/FullDark"] = not Flags["Visuals/FullDark"]
            local state = Flags["Visuals/FullDark"]
            if state then
                Flags["Visuals/Fullbright"] = false
                local updater = UIState.Updaters["Visuals/Fullbright"]
                if updater then updater(false) end
            end
            UI.Notify("FullDark", string.format("FullDark has been %s with 'Ctrl+N'", state and "activated" or "deactivated"))
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.G then
            Flags["Settings/GhostMode"] = not Flags["Settings/GhostMode"]
            local state = Flags["Settings/GhostMode"]
            if NotifyGui then NotifyGui.Enabled = not state end
            UI.Notify("Ghost Mode", string.format("Ghost Mode has been %s with 'Ctrl+G'", state and "activated" or "deactivated"))
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Period then
            Flags["Visuals/InformationDisplay"] = not Flags["Visuals/InformationDisplay"]
            local state = Flags["Visuals/InformationDisplay"]
            UI.Notify("Information Display", string.format("Information Display has been %s with 'Ctrl+.'", state and "activated" or "deactivated"))
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Backquote then
            Flags["Aim/AimLock"] = not Flags["Aim/AimLock"]
            local state = Flags["Aim/AimLock"]
            local updater = UIState.Updaters["Aim/AimLock"]
            if updater then updater(state) end
            UI.Notify("Camera Tracking", string.format("Camera Tracking Assistant has been %s with 'Ctrl+~'", state and "activated" or "deactivated"))
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.H then
            if Flags["Aim/HeadshotOnlyState"] == nil then
                Flags["Aim/HeadshotOnlyState"] = true
            end

            Flags["Aim/HeadshotOnlyState"] = not Flags["Aim/HeadshotOnlyState"]
            local isHeadshotOnly = Flags["Aim/HeadshotOnlyState"]

            for k in pairs(Flags["Aim/TargetGroups"]) do
                Flags["Aim/TargetGroups"][k] = false
            end
            Flags["Aim/TargetGroups"]["Head"] = true

            if isHeadshotOnly then
                Flags["Aim/BodyParts"] = {"Head"}
                Flags["Aim/Priority"] = "Head"
                UI.Notify("Camera Tracking", "Headshot Only Mode ACTIVATED with 'Ctrl+H'")
            else
                Flags["Aim/TargetGroups"]["Torso"] = true
                Flags["Aim/TargetGroups"]["LeftArm"] = true
                Flags["Aim/TargetGroups"]["RightArm"] = true
                Flags["Aim/TargetGroups"]["LeftLeg"] = true
                Flags["Aim/TargetGroups"]["RightLeg"] = true
                Flags["Aim/BodyParts"] = {"Head", "HumanoidRootPart", "LeftArm", "RightArm", "LeftLeg", "RightLeg"}
                Flags["Aim/Priority"] = "Head"
                UI.Notify("Camera Tracking", "All-Body Mode ACTIVATED with 'Ctrl+H'")
            end

            if UIState.Updaters["Aim/TargetGroups"] then
                for k, v in pairs(Flags["Aim/TargetGroups"]) do
                    if UIState.Updaters["Aim/TargetGroups"][k] then
                        UIState.Updaters["Aim/TargetGroups"][k](v)
                    end
                end
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Y then
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Teleporting is disabled while Safe Mode is ON.")
            else
                local highestId = -1
                for id, _ in pairs(ActiveWaypoints) do
                    if type(id) == "number" and id > highestId then
                        highestId = id
                    end
                end

                if highestId > -1 then
                    local wpData = ActiveWaypoints[highestId]
                    if wpData and LocalPlayer and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(wpData.Position + Vector3.new(0, 3, 0))
                        UI.Notify("Teleport", "Teleported to " .. wpData.Name)
                    end
                else
                    UI.Notify("Teleport", "No active waypoints.")
                end
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Q then
            if not SAFE_MODE and Flags["Misc/QTeleport"] then
                local character = LocalPlayer and LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local origin, direction = GetMouseRay()
                    local raycastHit = nil
                    if origin and direction then
                        raycastHit = WorldRaycastBr3ak3r(origin, direction, true)
                    end

                    local tpPos = nil
                    if raycastHit then
                        tpPos = raycastHit.Position
                    else
                        local mouse = LocalPlayer:GetMouse()
                        if mouse and mouse.Hit then
                            tpPos = mouse.Hit.Position
                        end
                    end

                    if tpPos then
                        rootPart.CFrame = CFrame.new(tpPos + Vector3.new(0, 3, 0)) * (rootPart.CFrame - rootPart.CFrame.Position)
                    end
                end
                return Enum.ContextActionResult.Sink
            end
        elseif inputObject.KeyCode == Enum.KeyCode.K then
            if not UIState.Visible then

                if UIState.Minimized and UIState.ToggleMinimize then
                    UIState.ToggleMinimize()
                end
                if UIState.ToggleVisible then
                    UIState.ToggleVisible(true)
                end
                for _, t in ipairs(UIState.Tabs) do
                    if t.Label.Text == "PlayerPage" and t.Select then
                        t.Select()
                    end
                end
            elseif UIState.Minimized then

                if UIState.ToggleMinimize then
                    UIState.ToggleMinimize()
                end
                for _, t in ipairs(UIState.Tabs) do
                    if t.Label.Text == "PlayerPage" and t.Select then
                        t.Select()
                    end
                end
            else

                if UIState.CurrentTab ~= "PlayerPage" then

                    for _, t in ipairs(UIState.Tabs) do
                        if t.Label.Text == "PlayerPage" and t.Select then
                            t.Select()
                        end
                    end
                else

                    if UIState.ToggleMinimize then
                        UIState.ToggleMinimize()
                    end
                end
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.J then
            ItemPanelState.Visible = not ItemPanelState.Visible
            Flags["Misc/ItemPanel"] = ItemPanelState.Visible
            local updater = UIState.Updaters["Misc/ItemPanel"]
            if updater then updater(ItemPanelState.Visible) end

            UI.Notify("Item Panel", "Item Panel is now " .. (ItemPanelState.Visible and "ON" or "OFF"))

            if ItemPanelState.Visible then
                if not ItemPanelUI.MainFrame then
                    CreateItemPanel()
                end
                UpdateItemPanelUI()
                ItemPanelUI.MainFrame.Visible = true
            else
                if ItemPanelUI.MainFrame then
                    ItemPanelUI.MainFrame.Visible = false
                end
            end
        elseif inputObject.KeyCode == Enum.KeyCode.Up then
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Position Force is disabled while Safe Mode is ON.")
            else
                local character = LocalPlayer and LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local hForceVal = Flags["Misc/HorizontalPositionForceValue"] or 3.0
                    local vForceVal = Flags["Misc/VerticalPositionForceValue"] or 3.4
                    if shiftHeld then
                        rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, -hForceVal)
                    else
                        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, vForceVal, 0)
                    end
                    task.spawn(startMovementLoop, Enum.KeyCode.Up)
                end
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Down then
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Position Force is disabled while Safe Mode is ON.")
            else
                local character = LocalPlayer and LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local hForceVal = Flags["Misc/HorizontalPositionForceValue"] or 3.0
                    local vForceVal = Flags["Misc/VerticalPositionForceValue"] or 3.4
                    if shiftHeld then
                        rootPart.CFrame = rootPart.CFrame * CFrame.new(0, 0, hForceVal)
                    else
                        rootPart.CFrame = rootPart.CFrame + Vector3.new(0, -vForceVal, 0)
                    end
                    task.spawn(startMovementLoop, Enum.KeyCode.Down)
                end
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Left then
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Position Force is disabled while Safe Mode is ON.")
            else
                local character = LocalPlayer and LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local hForceVal = Flags["Misc/HorizontalPositionForceValue"] or 3.0
                    rootPart.CFrame = rootPart.CFrame * CFrame.new(-hForceVal, 0, 0)
                    task.spawn(startMovementLoop, Enum.KeyCode.Left)
                end
            end
            return Enum.ContextActionResult.Sink
        elseif inputObject.KeyCode == Enum.KeyCode.Right then
            if SAFE_MODE then
                UI.Notify("Safe Mode", "Position Force is disabled while Safe Mode is ON.")
            else
                local character = LocalPlayer and LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    local hForceVal = Flags["Misc/HorizontalPositionForceValue"] or 3.0
                    rootPart.CFrame = rootPart.CFrame * CFrame.new(hForceVal, 0, 0)
                    task.spawn(startMovementLoop, Enum.KeyCode.Right)
                end
            end
            return Enum.ContextActionResult.Sink
        end
    end

    return Enum.ContextActionResult.Pass
end

game:GetService("ContextActionService"):BindActionAtPriority(
    "Sp3arParvusShortcuts",
    handleShortcuts,
    false,
    Enum.ContextActionPriority.High.Value + 100,
    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.B, Enum.KeyCode.E,
    Enum.KeyCode.R, Enum.KeyCode.U, Enum.KeyCode.F, Enum.KeyCode.N,
    Enum.KeyCode.G, Enum.KeyCode.Period, Enum.KeyCode.Backquote,
    Enum.KeyCode.H, Enum.KeyCode.K, Enum.KeyCode.Y,
    Enum.KeyCode.Q, Enum.KeyCode.J, Enum.KeyCode.Up, Enum.KeyCode.Down,
    Enum.KeyCode.Left, Enum.KeyCode.Right
)

local TARGET_CACHE_DURATION = 0.016

local function IsCursorOverMenu()
    local mouseLoc = Services.UserInputService:GetMouseLocation()
    local mx, my = mouseLoc.X, mouseLoc.Y

    local function isOverFrame(frame)
        if not frame or not frame.Visible or not frame.Parent then return false end
        local pos = frame.AbsolutePosition
        local size = frame.AbsoluteSize
        return mx >= pos.X and mx <= pos.X + size.X and my >= pos.Y and my <= pos.Y + size.Y
    end

    if isOverFrame(UIState.MainFrame) then return true end

    if isOverFrame(ItemPanelUI.MainFrame) then return true end
    return false
end

function GetCachedTarget()
    local now = os.clock()
    if CachedTarget and (now - CachedTargetTime) < TARGET_CACHE_DURATION then
        return CachedTarget
    end

    if IsCursorOverMenu() then
        CachedTarget = nil
        CachedTargetTime = now
        return nil
    end

    CachedTarget = GetClosest(
        Flags["Aim/AimLock"],
        Flags["Aim/TeamCheck"],
        Flags["Aim/VisibilityCheck"],
        false,
        0,
        Flags["Aim/FOV/Radius"],
        Flags["Aim/Priority"],
        Flags["Aim/BodyParts"],
        AimState.LastAimTarget
    )
    CachedTargetTime = now

    if UIState.PriorityLabel then
        local selectedCount = 0
        local lastCategory = "Head"
        for category, enabled in pairs(Flags["Aim/TargetGroups"]) do
            if enabled then
                selectedCount = selectedCount + 1
                lastCategory = category
            end
        end

        if selectedCount == 0 or selectedCount == 6 then
            UIState.PriorityLabel.Text = "Priority: Closest part"
        elseif selectedCount == 1 then
            UIState.PriorityLabel.Text = "Priority: " .. lastCategory
        else

            if CachedTarget then
                local targetedPart = CachedTarget[3]
                local categoryName = (targetedPart and PART_TO_CATEGORY[targetedPart.Name])
                    or "Closest part"
                UIState.PriorityLabel.Text = "Priority: " .. categoryName
            else
                UIState.PriorityLabel.Text = "Priority: Closest part"
            end
        end
    end

    return CachedTarget
end

local function UpdateFOVCircle()
    local showCircle = Sp3arParvus.Active and LocalCharReady and not SAFE_MODE and Flags["Aim/AimLock"] and Flags["Aim/FOV/ShowCircle"]

    if not showCircle then
        if FovCircleFrame then
            FovCircleFrame.Visible = false
        end
        return
    end

    local screenGui = EnsureScreenGui()
    if not screenGui then
        if FovCircleFrame then
            FovCircleFrame.Visible = false
        end
        return
    end

    if not FovCircleFrame or FovCircleFrame.Parent ~= screenGui then
        if FovCircleFrame then
            pcall(function() FovCircleFrame:Destroy() end)
        end

        FovCircleFrame = Instance.new("Frame")
        FovCircleFrame.Name = "FOVCircle"
        FovCircleFrame.BackgroundTransparency = 1
        FovCircleFrame.BorderSizePixel = 0
        FovCircleFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        FovCircleFrame.ZIndex = 10

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = FovCircleFrame

        local stroke = Instance.new("UIStroke")
        stroke.Thickness = 1
        stroke.Color = UI_THEME.Accent
        stroke.Transparency = 0.3
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Parent = FovCircleFrame

        FovCircleFrame.Parent = screenGui
    end

    local currentMode = UserInputService.MouseBehavior
    local crosshairX, crosshairY, crosshairValid = GetCrosshairViewportPosition(currentMode)

    if crosshairValid then
        local radius = Flags["Aim/FOV/Radius"] or 50
        local diameter = radius * 2

        FovCircleFrame.Size = UDim2.fromOffset(diameter, diameter)
        FovCircleFrame.Position = UDim2.fromOffset(crosshairX, crosshairY)
        FovCircleFrame.Visible = not Flags["Settings/GhostMode"]
    else
        FovCircleFrame.Visible = false
    end
end

function UpdateAim()
    pcall(UpdateFOVCircle)

    if SAFE_MODE then return end

    if not Sp3arParvus.Active or not LocalCharReady then
        ClearAimLockState(false)
        return
    end

    local AimActive = Flags["Aim/AimLock"] and (Flags["Aim/AlwaysEnabled"] or AimState.Aim)
    if not AimActive then
        ClearAimLockState(false)
        return
    end

    local target = GetCachedTarget()
    if target then
        AimAt(target)
    else
        ClearAimLockState(false)
    end
end

TrackConnection(RunService.RenderStepped:Connect(UpdateAim))

lastEspUpdate = 0
espUpdateRate = 0.2
lastTrackerUpdate = 0
trackerUpdateRate = 0.5
lastBr3ak3rCleanup = 0
br3ak3rCleanupRate = 2.0
lastHoverUpdate = 0
hoverUpdateRate = 0.033
lastWaypointUpdate = 0
waypointUpdateRate = 0.5
lastStateEnforcement = 0
stateEnforcementRate = 0.1
lastHumanoidSync = 0
humanoidSyncRate = 0.1
lastWorldHumListUpdate = 0
lastWorldHumPresetScan = 0
lastTeamsUpdate = 0
lastGhostMode = nil

function UnifiedHeartbeat(dt)
    if not Sp3arParvus.Active or not LocalCharReady then return end

    local now = os.clock()
    local ghostMode = Flags["Settings/GhostMode"]
    local ghostModeChanged = (ghostMode ~= lastGhostMode)
    lastGhostMode = ghostMode

    if ghostModeChanged and not ghostMode then

        if ClosestPlayerTrackerLabel and not ClosestPlayerTrackerLabel.Visible and Flags["LocalUI/ClosestPlayerTracker"] then
            ClosestPlayerTrackerLabel.Visible = true
        end
        if PerformanceLabel and not PerformanceLabel.Visible and Flags["LocalUI/PerformancePanel"] then
            PerformanceLabel.Visible = true
        end
        if LocalHealthHUD and not LocalHealthHUD.Visible and Flags["LocalUI/LocalHealthIndicator"] then
            LocalHealthHUD.Visible = true
        end
    end

    UpdateLighting()

    if (now - lastStateEnforcement) > 0.1 or ghostModeChanged then
        lastStateEnforcement = now
        UpdateLocalHealthHUD()
        UpdateInformationDisplay()
        ApplyHumanoidSettings()
        ApplyWorldHumanoidSettings()
        ApplyItemPanelSettings()

        local currentMax = LocalPlayer.CameraMaxZoomDistance
        local currentMin = LocalPlayer.CameraMinZoomDistance

        if not ZoomState.LastSetMax or math.abs(currentMax - ZoomState.LastSetMax) > 0.01 then
            ZoomState.OriginalMax = currentMax
        end
        if not ZoomState.LastSetMin or math.abs(currentMin - ZoomState.LastSetMin) > 0.01 then
            ZoomState.OriginalMin = currentMin
        end

        if Flags["Misc/ScrollUnlocker"] then
            if Br3ak3rState.CTRL_HELD and not H1ghl1ght3rState.SHIFT_HELD then
                -- Ctrl only (no Shift): expand zoom limits for scroll unlocker
                ZoomState.WasCtrlHeld = true

                if LocalPlayer.CameraMaxZoomDistance ~= 10000 then
                    LocalPlayer.CameraMaxZoomDistance = 10000
                    ZoomState.LastSetMax = 10000
                end
                if LocalPlayer.CameraMinZoomDistance ~= 0 then
                    LocalPlayer.CameraMinZoomDistance = 0
                    ZoomState.LastSetMin = 0
                end
            else
                local currentZoom = (Camera.CFrame.Position - Camera.Focus.Position).Magnitude

                if ZoomState.WasCtrlHeld then
                    ZoomState.WasCtrlHeld = false

                    local originalMax = ZoomState.OriginalMax or 128
                    if originalMax > 0 then
                        local newMultiplier = currentZoom / originalMax
                        ZoomState.Multiplier = newMultiplier > 1 and newMultiplier or 1
                    else
                        ZoomState.Multiplier = 1
                    end
                elseif ZoomState.UserScrolled then
                    ZoomState.UserScrolled = false

                    local originalMax = ZoomState.OriginalMax or 128
                    if originalMax > 0 then
                        local newMultiplier = currentZoom / originalMax
                        ZoomState.Multiplier = newMultiplier > 1 and newMultiplier or 1
                    else
                        ZoomState.Multiplier = 1
                    end
                end

                local multiplier = ZoomState.Multiplier or 1
                local targetMax = math.max((ZoomState.OriginalMax or 128) * multiplier, currentZoom)
                local targetMin = math.min(ZoomState.OriginalMin or 0.5, currentZoom)
                if targetMax < targetMin then
                    targetMax = targetMin
                end

                if not ZoomState.LastSetMax or math.abs(LocalPlayer.CameraMaxZoomDistance - targetMax) > 0.01 then
                    LocalPlayer.CameraMaxZoomDistance = targetMax
                    ZoomState.LastSetMax = targetMax
                end
                if not ZoomState.LastSetMin or math.abs(LocalPlayer.CameraMinZoomDistance - targetMin) > 0.01 then
                    LocalPlayer.CameraMinZoomDistance = targetMin
                    ZoomState.LastSetMin = targetMin
                end
            end
        else
            ZoomState.LastSetMax = nil
            ZoomState.LastSetMin = nil
            ZoomState.WasCtrlHeld = nil
            ZoomState.UserScrolled = nil
        end
    end

    if (now - lastHumanoidSync) > humanoidSyncRate then
        lastHumanoidSync = now
        UpdateHumanoidUI()
        UpdateWorldHumanoidEditorUI()

        if AdvancedPlayerPanelState.Visible then
            if AdvancedPlayerPanelState.CurrentView == "Teams" then
                if (now - lastTeamsUpdate) > 1.0 then
                    lastTeamsUpdate = now
                    UpdateTeamPanelList()
                end
            else
                UpdateAdvancedPlayerList()
            end
            UpdateAdvancedPlayerDetails()
        end

        local specPlayer = AdvancedPlayerPanelState.Spectating
        if specPlayer then
            if specPlayer.Parent then
                local _, specRoot = GetCharacter(specPlayer)
                if specRoot and LocalPlayer.ReplicationFocus ~= specRoot then
                    LocalPlayer.ReplicationFocus = specRoot
                end
            else

                AdvancedPlayerPanelState.Spectating = nil
                local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if myHum then Camera.CameraSubject = myHum end
                LocalPlayer.ReplicationFocus = nil
                pcall(function() GuiService:SetGameplayPausedNotificationEnabled(true) end)
            end
        end
    end

    if UIState.CurrentTab == "WorldHumanoids" and WorldHumState.SubPage == "List" and not WorldHumState.selectedHum then
        if (now - lastWorldHumListUpdate) > 4.0 then
            lastWorldHumListUpdate = now
            UpdateWorldHumListInPlace()
        end
    end

    if Flags["Waypoints/Enabled"] and (now - lastWaypointUpdate) > waypointUpdateRate then
        lastWaypointUpdate = now
        local camPos = Camera.CFrame.Position
        for id, wpData in pairs(ActiveWaypoints) do
            if wpData.Part and wpData.Label then
                local dist = (wpData.Position - camPos).Magnitude
                local distRounded = math.floor(dist)
                if math.abs((wpData.lastDist or 0) - distRounded) > 1 then
                    wpData.lastDist = distRounded
                    wpData.DistanceText = distRounded .. " studs"
                    wpData.Label.Text = string.format("%s\n%s", wpData.Name, wpData.DistanceText)
                end
            end
            local wpVisible = not ghostMode
            if wpData.Billboard and wpData.Billboard.Enabled ~= wpVisible then wpData.Billboard.Enabled = wpVisible end
            if wpData.PinBg and wpData.PinBg.Enabled ~= wpVisible then wpData.PinBg.Enabled = wpVisible end
        end
    elseif not Flags["Waypoints/Enabled"] then

        for id, wpData in pairs(ActiveWaypoints) do
            if wpData.Billboard and wpData.Billboard.Enabled then wpData.Billboard.Enabled = false end
            if wpData.PinBg and wpData.PinBg.Enabled then wpData.PinBg.Enabled = false end
        end
    else

        local wpVisible = not ghostMode
        for id, wpData in pairs(ActiveWaypoints) do
            if wpData.Billboard and wpData.Billboard.Enabled ~= wpVisible then wpData.Billboard.Enabled = wpVisible end
            if wpData.PinBg and wpData.PinBg.Enabled ~= wpVisible then wpData.PinBg.Enabled = wpVisible end
        end
    end

    if Flags["Visuals/Fullbright"] and Flags["Visuals/FullDark"] then

        Flags["Visuals/FullDark"] = false
        local updater = UIState.Updaters["Visuals/FullDark"]
        if updater then updater(false) end
    end

    local shouldUpdateEsp = (now - lastEspUpdate) > espUpdateRate
    local shouldUpdateTracker = (now - lastTrackerUpdate) > trackerUpdateRate

    local forceUpdateTarget = nil
    if CachedTarget and (now - CachedTargetTime) < 0.1 then
        forceUpdateTarget = CachedTarget[1]
    end

    if (shouldUpdateEsp or forceUpdateTarget) then
        if shouldUpdateEsp then
            lastEspUpdate = now
        end

        local players = GetPlayersCache()
        local myPos = Camera.CFrame.Position
        local espEnabled = Flags["ESP/Enabled"]
        local isLocalDNR = DNR(LocalPlayer)

        for _, player in ipairs(players) do
            if player ~= LocalPlayer then
                if not isLocalDNR and DNR(player) then
                    continue
                end

                if not espEnabled then

                    local espData = ESPObjects[player]
                    if espData then
                        if espData.Nametag and espData.Nametag.Enabled then espData.Nametag.Enabled = false end
                    end
                    RemovePlayerOutlines(player)
                    continue
                end

                local pChar, pRoot = GetCharacter(player)
                local skip = false

                if not shouldUpdateEsp and player ~= forceUpdateTarget then
                    skip = true
                end

                if not skip and pRoot and player ~= forceUpdateTarget then
                    local dist = (pRoot.Position - myPos).Magnitude
                    if dist > 1000 then

                        if (floor(now * 5) % 10) ~= 0 then skip = true end
                    elseif dist > 400 then

                        if (floor(now * 5) % 4) ~= 0 then skip = true end
                    end
                end

                if not skip then
                   UpdateESP(now, player, player == NearestPlayerRef)
                end
            end
        end
    end

    if shouldUpdateTracker then
        lastTrackerUpdate = now
        UpdateNearestPlayer()
        UpdateClosestPlayerTracker()
    end

    if (now - lastHoverUpdate) > hoverUpdateRate then
        lastHoverUpdate = now
        UpdateBr3ak3rHover()
    end

    if (now - lastBr3ak3rCleanup) > br3ak3rCleanupRate then
        lastBr3ak3rCleanup = now
        UpdatePlayerCache()
        pcall(pruneBrokenSet)
        pcall(pruneHighlightedSet)

        CleanupDeadConnections()
        CleanupDeadThreads()
        PruneCharCache()
        ClearCandidateReferences()
        ValidateESPObjects()
    end

    sweepUndo(dt)
    sweepHighlightedUndo(dt)

    if (now - Br3ak3rState.lastEnforcement) > stateEnforcementRate or ghostModeChanged then
        Br3ak3rState.lastEnforcement = now

        if ScreenGui and ScreenGui.Enabled ~= (not ghostMode) then
            ScreenGui.Enabled = not ghostMode
        end

        if ghostMode then
            for _, espData in pairs(ESPObjects) do
                if espData.Nametag and espData.Nametag.Enabled then espData.Nametag.Enabled = false end
            end

            for _, obj in ipairs(PoolFolder:GetChildren()) do
                PcallSetEnabled(obj, false)
            end

            if ClosestPlayerTrackerLabel and ClosestPlayerTrackerLabel.Visible then ClosestPlayerTrackerLabel.Visible = false end
            if PerformanceLabel and PerformanceLabel.Visible then PerformanceLabel.Visible = false end
            if LocalHealthHUD and LocalHealthHUD.Visible then LocalHealthHUD.Visible = false end
        end

        local enforcementMadeChange = false
        local camPos = Camera and Camera.CFrame.Position
        for path, data in pairs(Br3ak3rState.brokenSet) do
            local part = data.instance
            if not part or not part.Parent then

                local isClose = camPos and data.pos and (camPos - data.pos).Magnitude < 100
                if isClose or not data.nextResolve or now > data.nextResolve then
                    data.nextResolve = now + 2.0
                    part = RobustResolvePart(path, data)

                    if part then
                        data.instance = part
                        enforcementMadeChange = true
                    end
                end
            end

            if part and part.Parent then

                if part.CanCollide ~= false then
                    part.CanCollide = false
                    enforcementMadeChange = true
                end
                if PcallSafeSetProp(part, "CanTouch", false) then enforcementMadeChange = true end
                if PcallSafeSetProp(part, "CanQuery", false) then enforcementMadeChange = true end

                local targetT = (ghostMode and type(data) == "table") and data.t or 0.5
                local targetLTM = (ghostMode and type(data) == "table") and data.ltm or 0.5

                if PcallSafeSetProp(part, "Transparency", targetT) then enforcementMadeChange = true end
                if PcallSafeSetProp(part, "LocalTransparencyModifier", targetLTM) then enforcementMadeChange = true end
            end
        end
        if enforcementMadeChange then
            Br3ak3rState.brokenCacheDirty = true
        end

        for part, data in pairs(H1ghl1ght3rState.highlightedSet) do
            if part.Parent then
                local targetT = (ghostMode and type(data) == "table") and data.t or 0.5
                local targetLTM = (ghostMode and type(data) == "table") and data.ltm or 0.5
                if part.Transparency ~= targetT then part.Transparency = targetT end
                if part.LocalTransparencyModifier ~= targetLTM then part.LocalTransparencyModifier = targetLTM end

                local hVisible = not ghostMode
                if data.hl and data.hl.Enabled ~= hVisible then data.hl.Enabled = hVisible end
                if data.bg and data.bg.Enabled ~= hVisible then data.bg.Enabled = hVisible end
            end
        end

        for player, storage in pairs(PlayerOutlineObjects) do
            local outlineVisible = not ghostMode
            if storage.Highlight and storage.Highlight.Enabled ~= outlineVisible then
                storage.Highlight.Enabled = outlineVisible
            end
            if storage.HeadDot and storage.HeadDot.Enabled ~= outlineVisible then
                storage.HeadDot.Enabled = outlineVisible
            end
            if storage.RootDot and storage.RootDot.Enabled ~= outlineVisible then
                storage.RootDot.Enabled = outlineVisible
            end
        end
    end
end

local shootBotThread = task.spawn(function()
    while Sp3arParvus.Active do
        local enabled = Flags["ShootBot/Enabled"]
        local cps = Flags["ShootBot/CPS"]

        if enabled and not SAFE_MODE and type(isrbxactive) == "function" and isrbxactive() and type(mouse1press) == "function" and type(mouse1release) == "function" then
            local targetPart = Mouse.Target
            if targetPart then

                local character = targetPart.Parent
                while character and character ~= game do
                    if character:IsA("Model") and Players:GetPlayerFromCharacter(character) then
                        break
                    end
                    character = character.Parent
                end

                local player = character and character ~= game and Players:GetPlayerFromCharacter(character)

                if player and player ~= LocalPlayer and InEnemyTeam(Flags["ShootBot/TeamCheck"], player) and GetCharacter(player) then
                    local targetParts = Flags["ShootBot/TargetParts"]
                    local anySelected = false
                    for _, selected in pairs(targetParts) do
                        if selected then anySelected = true break end
                    end

                    local shouldFire = false
                    if not anySelected then

                        shouldFire = true
                    else

                        local bodyPart = nil
                        if targetPart.Parent == character then
                            bodyPart = targetPart
                        else

                            local accessory = targetPart:FindFirstAncestorOfClass("Accessory")
                            if accessory then
                                local handle = accessory:FindFirstChild("Handle") or targetPart
                                local weld = handle:FindFirstChild("AccessoryWeld") or handle:FindFirstChildOfClass("Weld")
                                if weld and weld.Part1 and weld.Part1:IsDescendantOf(character) then
                                    bodyPart = weld.Part1
                                end
                            else

                                local tool = targetPart:FindFirstAncestorOfClass("Tool")
                                if tool then
                                    bodyPart = character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
                                end
                            end
                        end

                        if bodyPart then
                            local name = bodyPart.Name
                            if targetParts.Head and name == "Head" then
                                shouldFire = true
                            elseif targetParts.Torso and (name == "UpperTorso" or name == "LowerTorso" or name == "Torso" or name == "HumanoidRootPart") then
                                shouldFire = true
                            elseif targetParts.LeftArm and (name == "LeftUpperArm" or name == "LeftLowerArm" or name == "LeftHand" or name == "Left Arm") then
                                shouldFire = true
                            elseif targetParts.RightArm and (name == "RightUpperArm" or name == "RightLowerArm" or name == "RightHand" or name == "Right Arm") then
                                shouldFire = true
                            elseif targetParts.LeftLeg and (name == "LeftUpperLeg" or name == "LeftLowerLeg" or name == "LeftFoot" or name == "Left Leg") then
                                shouldFire = true
                            elseif targetParts.RightLeg and (name == "RightUpperLeg" or name == "RightLowerLeg" or name == "RightFoot" or name == "Right Leg") then
                                shouldFire = true
                            end
                        end
                    end

                    if shouldFire then
                        mouse1press()
                        task.wait(1 / cps / 2)
                        mouse1release()
                        task.wait(1 / cps / 2)
                        continue
                    end
                end
            end
        end
        task.wait()
    end
end)
TrackThread(shootBotThread)

TrackConnection(RunService.Heartbeat:Connect(UnifiedHeartbeat))

createHoverHighlight()

local perfThread = task.spawn(function()
    while Sp3arParvus.Active do
        UpdatePerformanceDisplay()
        task.wait(0.5)
    end
end)
TrackThread(perfThread)

print(string.format("[Sp3arParvus v%s] Developer tool loaded successfully!", VERSION))
if SAFE_MODE then
    UI.Notify(
        string.format("Sp3arParvus v%s — Safe Mode", VERSION),
        "Safe Mode is ACTIVE. Camera Tracking, Input Simulation, and position-jump features are disabled. " ..
        "Set SAFE_MODE = false at the script top to re-enable them."
    )
    print(string.format("[Sp3arParvus v%s] ✓ SAFE MODE active — Camera Tracking and Input Simulation are OFF", VERSION))
else
    UI.Notify(
        string.format("Sp3arParvus v%s", VERSION),
        string.format("Sp3arParvus v%s loaded. Camera Tracking: %s | ESP: %s | Safe Mode: OFF",
            VERSION,
            Flags["Aim/AimLock"] and "ON" or "OFF",
            Flags["ESP/Enabled"] and "ON" or "OFF"
        )
    )
    print(string.format("[Sp3arParvus v%s] Camera Tracking: %s | ESP: %s | Input Sim: %s",
        VERSION,
        Flags["Aim/AimLock"] and "ON" or "OFF",
        Flags["ESP/Enabled"] and "ON" or "OFF",
        Flags["ShootBot/Enabled"] and "ON" or "OFF"
    ))
end
print(string.format("[Sp3arParvus v%s] Br3ak3r: %s", VERSION, Flags["Br3ak3r/Enabled"] and "ON" or "OFF"))
print(string.format("[Sp3arParvus v%s] Press RIGHT SHIFT to toggle UI visibility", VERSION))
print(string.format("[Sp3arParvus v%s] Br3ak3r Controls: Ctrl+Click=Break | Ctrl+Z=Undo | Ctrl+B=Toggle", VERSION))
print(string.format("[Sp3arParvus v%s] Distance Colors: Pink=Closest | Red≤750 | Yellow≤1875 | Green>1875", VERSION))

-- Deferred startup config notification (UI is now ready) ────────────
do
    local payloads = ConfigManager and ConfigManager._startupPayloads
    if payloads then
        for _, sf in ipairs(payloads) do
            pcall(ConfigManager.LoadProfile, sf)
        end
    end

    local notifies = ConfigManager and ConfigManager._startupNotifies
    if notifies then
        task.delay(0.5, function()
            -- Small delay so the main load notification displays first
            for i, sn in ipairs(notifies) do
                task.delay((i - 1) * 2, function()
                    if sn.kind == "no_api" then
                        UI.Notify(
                            "⚠ Config Unavailable",
                            "File I/O API inaccessible on this executor. Config saving/loading is disabled.",
                            8
                        )
                    elseif sn.kind == "pergame" then
                        UI.Notify(
                            "🌎 Per-Game Config Loaded",
                            string.format("Game %s detected — auto-loading profile \"%s\".", sn.placeId or "?", sn.profileName or "?"),
                            7
                        )
                    elseif sn.kind == "universal" then
                        UI.Notify(
                            "🌐 Universal Config Loaded",
                            string.format("Universal config with auto-load enabled detected — loading profile \"%s\".", sn.profileName or "?"),
                            7
                        )
                    elseif sn.kind == "defaults_with_profiles" then
                        UI.Notify(
                            "📄 Config: Defaults Loaded",
                            string.format("%d profile(s) found, none with auto-load enabled. Loading defaults.", sn.count or 0),
                            6
                        )
                    end
                end)
            end
        end)
    end
end

