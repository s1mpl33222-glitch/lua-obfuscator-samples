--[[
    PuckAFK Hub | Universal Access Loader v5.9.20 - Persistent Premium Auto Start + Dimension Continuity
    Canonical URL: https://puckafk.site/loader.lua

    Default flow:
      1. Choose Free or Premium.
      2. Free -> launch the public PuckAFK route for the current game.
      3. Premium -> validate a key server-side for every game.
         Launch the Premium release when available, or Free after validation.

    Premium keys are saved locally only after successful validation.
    v5.9.18: Opt-in AUTO VALIDATE SAVED KEY. When Premium was remembered and an
    already-saved key exists, execution revalidates through the normal server
    route before launching. Failures remain on the same manual key screen.
    Manual Premium selection and first-time keys still require user action.
    No premium-key bypass.

    v5.9 release polish:
      - Preserves the exact classic PuckAFK access-loader layout and proportions.
      - Removes external browser-opening attempts for Discord and Premium website actions.
      - Copies links to the Windows/system clipboard using executor clipboard APIs instead.
      - Shows a clear in-loader confirmation so users know exactly what happened.
      - Supports setclipboard/toclipboard plus common clipboard aliases and nested helpers.
      - Keeps real icons, Keep My Choice, animations, Premium validation, and key saving.
      - Correctly distinguishes key rejection from server-side source delivery failure.
]]

local ENV = _G
if type(getgenv) == "function" then
    local ok, shared = pcall(getgenv)
    if ok and type(shared) == "table" then ENV = shared end
end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Release-scoped cache key prevents older executor/browser caches serving stale game routes.
local FREE_LOADER = "https://puckafk.site/loader-free.lua?v=6.0.70-japp-subplaces"
local PREMIUM_API = "https://puckafk.site/api/premium"
local PREMIUM_API_FALLBACK = "https://puckhub-key-api.puckafk.workers.dev/v1/premium"
local KEY_VALIDATE_API = "https://puckhub-key-api.puckafk.workers.dev/v1/validate"
local DISCORD_INVITE = "https://discord.gg/NFfs8G2WAz"
local PREMIUM_PAGE = "https://puckafk.site/premium/"
local AFS_UNIVERSE_ID = 10321202755
local AFS_ROOT_PLACE_ID = 100429474155186
local AFS_PLACE_IDS = {
    [100429474155186] = true, -- main world
    [122385531796312] = true, -- Dimension 2 (verified uploaded place)
    [120613990796271] = true, -- Tower
    [122742651588736] = true, -- Dungeon
}
local PREMIUM_ONLY_PLACE_IDS = { [93978595733734] = true }
PREMIUM_ONLY_PLACE_IDS[17625359962] = true
for placeId in pairs(AFS_PLACE_IDS) do PREMIUM_ONLY_PLACE_IDS[placeId] = true end
local PREMIUM_ONLY_UNIVERSE_IDS = { [6739698191] = true }
PREMIUM_ONLY_UNIVERSE_IDS[6035872082] = true
PREMIUM_ONLY_UNIVERSE_IDS[AFS_UNIVERSE_ID] = true
local function premiumGameName()
    if game.GameId == AFS_UNIVERSE_ID or AFS_PLACE_IDS[game.PlaceId] then return "Anime Fighting Simulator" end
    if game.PlaceId == 17625359962 or game.GameId == 6035872082 then return "RIVALS" end
    return "Violence District"
end
-- The paid AFS source was originally registered for the universe's root place.
-- Roblox's GameId identifies the entire universe, including future subplaces.
-- Route those through the root entitlement and preserve currentPlaceId in the
-- server request for diagnostics. Never route a different universe this way.
local function premiumRoutingPlaceId()
    if game.GameId == AFS_UNIVERSE_ID then
        return AFS_ROOT_PLACE_ID
    end
    return game.PlaceId
end
local function gameRequiresPremium()
    return PREMIUM_ONLY_PLACE_IDS[game.PlaceId] == true or PREMIUM_ONLY_UNIVERSE_IDS[game.GameId] == true
end
local KEY_FILE = "PuckHub/premium.key"
local CHOICE_FILE = "PuckHub/access-choice.txt"
local KEY_FLAT_FILE = "PuckHub_premium.key"
local CHOICE_FLAT_FILE = "PuckHub_access-choice.txt"
local AUTO_VALIDATE_FILE = "PuckHub/premium-auto-validate.txt"
local AUTO_VALIDATE_FLAT_FILE = "PuckHub_premium-auto-validate.txt"

local function trim(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalizeKey(value)
    return trim(value):gsub("%s+", "")
end

local function normalizeChoice(value)
    value = string.lower(trim(value))
    if value == "free" or value == "premium" then return value end
    return ""
end

-- No isfile or makefolder requirement: some executors only expose readfile/writefile.
-- Verify writes by reading back the bytes; never claim a key was persisted if not.
local function executorFileFn(name)
    -- Most executors use ordinary global functions, but some expose them
    -- through _G or getgenv(). Check all three without trusting unsupported APIs.
    local direct = {
        readfile = readfile, writefile = writefile,
        makefolder = makefolder, isfolder = isfolder,
        delfile = delfile, isfile = isfile,
    }
    local fn = direct[name]
    if type(fn) == "function" then return fn end
    fn = type(ENV) == "table" and rawget(ENV, name) or nil
    if type(fn) == "function" then return fn end
    fn = type(_G) == "table" and rawget(_G, name) or nil
    if type(fn) == "function" then return fn end
    return nil
end
local function readSavedText(primary, flat)
    local read = executorFileFn("readfile")
    if not read then return nil end
    for _, path in ipairs({primary, flat}) do
        local ok, contents = pcall(read, path)
        if ok and type(contents) == "string" then return contents end
    end
    return nil
end

local function saveText(primary, flat, contents)
    local read, write = executorFileFn("readfile"), executorFileFn("writefile")
    if not read or not write then return false end
    local make = executorFileFn("makefolder")
    if make then pcall(make, "PuckHub") end
    for _, path in ipairs({primary, flat}) do
        if pcall(write, path, contents) then
            local ok, stored = pcall(read, path)
            if ok and stored == contents then return true end
        end
    end
    return false
end

local function clearText(primary, flat)
    local read,write,delete = executorFileFn("readfile"),executorFileFn("writefile"),executorFileFn("delfile")
    if not read then return false end
    local cleared = true
    for _, path in ipairs({primary, flat}) do
        local readOK, contents = pcall(read, path)
        if readOK and type(contents) == "string" and contents ~= "" then
            local done = false
            if delete and pcall(delete, path) then
                done = not pcall(read, path)
            end
            if not done and write
                and pcall(write, path, "") then
                local checkOK, check = pcall(read, path)
                done = checkOK and check == ""
            end
            if not done then cleared = false end
        end
    end
    return cleared
end

local function readSavedChoice()
    local session = normalizeChoice(rawget(ENV, "PuckHubRememberedAccess"))
    if session ~= "" then return session end
    return normalizeChoice(readSavedText(CHOICE_FILE, CHOICE_FLAT_FILE))
end

local function saveChoice(choice)
    choice = normalizeChoice(choice)
    if choice == "" then return false end
    ENV.PuckHubRememberedAccess = choice
    return saveText(CHOICE_FILE, CHOICE_FLAT_FILE, choice)
end

local function clearSavedChoice()
    ENV.PuckHubRememberedAccess = nil
    return clearText(CHOICE_FILE, CHOICE_FLAT_FILE)
end

-- Only an explicitly opted-in user may skip the manual Validate click.
-- This flag is NOT an authentication result: launchPremium always validates.
local function readAutoValidateSavedKey()
    local current = rawget(ENV, "PuckHubAutoValidateSavedKey")
    if type(current) == "boolean" then return current end
    local stored = trim(readSavedText(AUTO_VALIDATE_FILE, AUTO_VALIDATE_FLAT_FILE))
    if stored == "1" then return true end
    if stored == "0" then return false end -- explicit opt-out
    -- Migration: earlier v5.9.17 keys existed before the opt-in switch.
    -- For Premium-only games, a saved key is enough to AUTOMATICALLY REQUEST
    -- fresh server validation; it never grants Premium until accepted.
    return gameRequiresPremium() and normalizeKey(readSavedText(KEY_FILE, KEY_FLAT_FILE)) ~= ""
end
local function saveAutoValidateSavedKey(enabled)
    enabled = enabled == true
    ENV.PuckHubAutoValidateSavedKey = enabled
    return saveText(AUTO_VALIDATE_FILE, AUTO_VALIDATE_FLAT_FILE, enabled and "1" or "0")
end

local function compiler()
    return loadstring or load
end

local function requestFn()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if syn and type(syn.request) == "function" then return syn.request end
    if http and type(http.request) == "function" then return http.request end
    if fluxus and type(fluxus.request) == "function" then return fluxus.request end
    return nil
end

local function decode(text)
    local ok, value = pcall(function()
        return HttpService:JSONDecode(tostring(text or "{}"))
    end)
    return ok and value or nil
end

local function encode(value)
    return HttpService:UrlEncode(tostring(value or ""))
end

local function executorName()
    local probes = {
        function()
            if identifyexecutor then
                local name, version = identifyexecutor()
                if name then
                    return version and (tostring(name) .. " " .. tostring(version)) or tostring(name)
                end
            end
        end,
        function()
            if getexecutorname then return tostring(getexecutorname()) end
        end,
        function()
            if syn then return "Synapse-compatible" end
        end,
    }
    for _, probe in ipairs(probes) do
        local ok, value = pcall(probe)
        if ok and value and tostring(value) ~= "" then
            return tostring(value)
        end
    end
    return "Unknown"
end

local function deviceIdentifier()
    local probes = {
        function() if gethwid then return "hwid:" .. tostring(gethwid()) end end,
        function() if syn and syn.get_hwid then return "syn:" .. tostring(syn.get_hwid()) end end,
        function()
            return "rbxclient:" .. tostring(game:GetService("RbxAnalyticsService"):GetClientId())
        end,
    }
    for _, probe in ipairs(probes) do
        local ok, value = pcall(probe)
        if ok and value and tostring(value) ~= "" then return tostring(value) end
    end
    return nil
end

local function readSavedKey()
    local session = normalizeKey(ENV.PuckHubKey)
    if session ~= "" then return session end
    return normalizeKey(readSavedText(KEY_FILE, KEY_FLAT_FILE))
end

local function saveKey(key)
    key = normalizeKey(key)
    if key == "" then return false end
    ENV.PuckHubKey = key
    return saveText(KEY_FILE, KEY_FLAT_FILE, key)
end

local function clearSavedKey()
    ENV.PuckHubKey = nil
    return clearText(KEY_FILE, KEY_FLAT_FILE)
end

local function copyToClipboard(value)
    value = trim(value)
    if value == "" then return false, "empty-value" end

    -- Direct clipboard functions used by current Windows executors.
    local directNames = {
        "setclipboard", "toclipboard", "set_clipboard", "to_clipboard",
        "writeclipboard", "write_clipboard", "copyclipboard", "copy_clipboard",
        "setrbxclipboard", "set_rbx_clipboard",
    }

    local tried = {}
    local function tryFunction(fn, owner, label)
        if type(fn) ~= "function" or tried[fn] then return false end
        tried[fn] = true

        local ok = pcall(fn, value)
        if ok then return true, label end

        if owner then
            ok = pcall(fn, owner, value)
            if ok then return true, label .. "(method)" end
        end
        return false
    end

    for _, name in ipairs(directNames) do
        local fn = rawget(ENV, name) or rawget(_G, name)
        local ok, via = tryFunction(fn, nil, name)
        if ok then return true, via end
    end

    -- Some executors expose clipboard helpers under a small API table.
    local roots = {
        {rawget(ENV, "clipboard"), "clipboard"},
        {rawget(ENV, "Clipboard"), "Clipboard"},
        {rawget(ENV, "syn"), "syn"},
        {rawget(ENV, "executor"), "executor"},
        {rawget(ENV, "real"), "real"},
        {rawget(ENV, "Real"), "Real"},
        {rawget(ENV, "delta"), "delta"},
        {rawget(ENV, "Delta"), "Delta"},
        {rawget(ENV, "xeno"), "xeno"},
        {rawget(ENV, "Xeno"), "Xeno"},
        {rawget(ENV, "solara"), "solara"},
        {rawget(ENV, "Solara"), "Solara"},
        {rawget(ENV, "potassium"), "potassium"},
        {rawget(ENV, "Potassium"), "Potassium"},
    }

    local nestedNames = {
        "clipboard", "Clipboard", "system", "System", "platform", "Platform",
        "utils", "Utils", "utility", "Utility", "api", "API",
    }
    local seenRoots = {}
    local i = 1
    while i <= #roots and i <= 64 do
        local root, label = roots[i][1], roots[i][2]
        if type(root) == "table" and not seenRoots[root] then
            seenRoots[root] = true

            for _, name in ipairs({"set", "write", "copy", "setclipboard", "toclipboard", "set_clipboard", "writeclipboard"}) do
                local okRead, fn = pcall(function() return rawget(root, name) end)
                if okRead then
                    local ok, via = tryFunction(fn, root, label .. "." .. name)
                    if ok then return true, via end
                end
            end

            for _, nestedName in ipairs(nestedNames) do
                local okNested, nested = pcall(function() return rawget(root, nestedName) end)
                if okNested and type(nested) == "table" and not seenRoots[nested] then
                    table.insert(roots, {nested, label .. "." .. nestedName})
                end
            end
        end
        i = i + 1
    end

    return false, "clipboard-unavailable:" .. tostring(executorName())
end

local function fetchText(url)
    local ok, body = pcall(function()
        return game:HttpGet(url, url:find("loader-free.lua", 1, true) ~= nil)
    end)
    if ok and type(body) == "string" and #body > 0 then
        return true, body
    end

    local req = requestFn()
    if req then
        local requestOk, response = pcall(req, {Url = url, Method = "GET"})
        if requestOk and type(response) == "table" then
            local status = tonumber(response.StatusCode or response.Status or response.status) or 0
            local responseBody = response.Body or response.body
            if status >= 200 and status < 300 and type(responseBody) == "string" then
                return true, responseBody
            end
        end
    end

    return false, tostring(body or "HTTP request failed")
end

local function launchSource(source, label)
    local compile = compiler()
    if type(compile) ~= "function" then
        return false, "This executor does not provide loadstring/load."
    end
    local chunk, compileError = compile(source)
    if not chunk then
        return false, (label or "Script") .. " compile failed: " .. tostring(compileError)
    end

    local ok, runtimeError = pcall(chunk)
    if not ok then
        return false, (label or "Script") .. " failed: " .. tostring(runtimeError)
    end
    return true
end

local function launchFree(setStatus)
    if gameRequiresPremium() then
        if setStatus then setStatus(premiumGameName() .. " requires Premium access. Choose Premium and validate your key.", true) end
        return false
    end
    local freeLabels = {
        [70733580049633] = "Wash the Car",
        [140080362319349] = "Slice A Dummy!",
        [99686412871121] = "Lumber Empire",
        [99686412871121] = "Lumber Empire",
        [139246468685423] = "Lifting Simulator: REBORN",
        [115068315659966] = "Roll A Stickman",
        [129019396299239] = "Just a Passion Project",
        [104299809132349] = "Just a Passion Project",
        [135169917851408] = "Merge Hackers",
        [139717576471404] = "RoChess!",
        [109949693269081] = "Tycoon, but one dropper",
        [113220849219354] = "+1 Sword Blast Evolution",
        [70906625936847] = "Gym Star Simulator",
        [132239307080610] = "Deep Fishing",
        [75766778174856] = "Tower Incremental",
        [79389059854988] = "My Anime Mine",
        [96124247562170] = "+1 Soldier Evolution",
    }
    local launchLabel = freeLabels[game.PlaceId]
        or (game.GameId == 10779563082 and "Just a Passion Project")
        or "Free access"
    if setStatus then setStatus("Loading " .. launchLabel .. "…") end
    ENV.PuckHubCurrentAccessMode = "free"
    ENV.PuckHubAccessMode = "free"

    local ok, source = fetchText(FREE_LOADER)
    if not ok then
        ENV.PuckHubAccessMode = nil
        if setStatus then setStatus("Could not download the Free loader.", true) end
        return false
    end

    local launched, err = launchSource(source, "Free loader")
    ENV.PuckHubAccessMode = nil
    if not launched then
        if setStatus then setStatus(err, true) end
        return false
    end
    return true
end

local function buildResolveUrl(base)
    local player = Players.LocalPlayer
    return base .. "/resolve"
        .. "?placeId=" .. encode(premiumRoutingPlaceId())
        .. "&universeId=" .. encode(game.GameId)
        .. "&robloxUserId=" .. encode(player and player.UserId or "Unknown")
        .. "&robloxUsername=" .. encode(player and player.Name or "Unknown")
        .. "&executor=" .. encode(executorName())
        .. "&jobId=" .. encode(game.JobId or "")
end

local function resolvePremium()
    local urls = {
        buildResolveUrl(PREMIUM_API),
        buildResolveUrl(PREMIUM_API_FALLBACK),
    }

    local lastError = "Premium service is unavailable."
    for _, url in ipairs(urls) do
        local ok, body = fetchText(url)
        if ok then
            local data = decode(body)
            if data then return true, data end
            lastError = "Premium service returned an invalid response."
        else
            lastError = body
        end
    end
    return false, lastError
end

-- An explicit Free-only resolver response permits Free as a destination ONLY
-- AFTER the user's Premium key is positively validated. Resolver failures fail closed.
local function hasOnlyFreeRelease(info)
    return not gameRequiresPremium()
        and type(info) == "table"
        and info.ok == true
        and info.premium == false
end

local function postPremiumSource(base, payload)
    local req = requestFn()
    if type(req) ~= "function" then
        return false, nil, "Premium access requires an executor HTTP request function."
    end

    local ok, response = pcall(req, {
        Url = base .. "/source",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "text/plain, application/json",
        },
        Body = HttpService:JSONEncode(payload),
    })

    if not ok or type(response) ~= "table" then
        return false, nil, tostring(response or "Premium request failed")
    end

    local status = tonumber(response.StatusCode or response.Status or response.status) or 0
    local body = response.Body or response.body or ""
    if status == 200 and type(body) == "string" and #body > 0 then
        return true, body
    end

    local detail = decode(body)
    local message = detail and (detail.message or detail.error or detail.code)
    return false, status, tostring(message or ("HTTP " .. tostring(status))), detail and detail.code
end

-- Free-only releases still require a real server-side key check when the user
-- explicitly chooses Premium. Never infer validity from a saved key or from the
-- game catalog. The Key API returns {valid=true} only on a successful check.
local function validatePremiumKeyOnly(payload)
    local req = requestFn()
    if type(req) ~= "function" then
        return false, "This executor does not support secure Premium key requests."
    end
    local ok, response = pcall(req, {
        Url = KEY_VALIDATE_API,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/json",
        },
        Body = HttpService:JSONEncode(payload),
    })
    if not ok or type(response) ~= "table" then
        return false, "Could not reach the Premium key validator."
    end
    local status = tonumber(response.StatusCode or response.Status or response.status) or 0
    local detail = decode(response.Body or response.body or "")
    if status == 200 and type(detail) == "table" and detail.valid == true then
        return true
    end
    if type(detail) == "table" and (detail.message or detail.code) then
        return false, tostring(detail.message or detail.code)
    end
    return false, "Premium key validation failed (HTTP " .. tostring(status) .. ")."
end

-- The executor may have Roblox teleport queue APIs under different names.
-- Enqueue the *normal* loader once per source server so it runs on entering any
-- confirmed subplace of this universe. The new place revalidates the saved key
-- server-side; no key or entitlement is embedded in this source string.
local TELEPORT_RESTART_CODE = [=[
    if not game:IsLoaded() then game.Loaded:Wait() end
    if game.GameId ~= 10321202755 then return end
    local ok, source = pcall(function()
        return game:HttpGet("https://puckafk.site/loader.lua?v=6.0.58")
    end)
    if ok and type(source) == "string" and #source > 0 then
        local compile = loadstring or load
        if type(compile) == "function" then
            local chunk = compile(source)
            if chunk then pcall(chunk) end
        end
    end
]=]
local function queueAutoLaunchAfterTeleport()
    if game.GameId ~= AFS_UNIVERSE_ID then return false, "not-anime-fighting-simulator" end
    -- Some executors retain getgenv() between places. A global boolean would
    -- incorrectly suppress the queue in every destination after the first hop.
    local thisServer = tostring(game.JobId or "") .. ":" .. tostring(game.PlaceId)
    if ENV.PuckHubAFSTeleportQueuedForJob == thisServer then return true end
    local candidates = {
        { rawget(ENV,"queue_on_teleport"), nil },
        { rawget(ENV,"queueonteleport"), nil },
        { rawget(_G,"queue_on_teleport"), nil },
        { rawget(_G,"queueonteleport"), nil },
    }
    local synApi = rawget(ENV,"syn")
    if type(synApi) == "table" then
        candidates[#candidates+1] = {synApi.queue_on_teleport, synApi}
        candidates[#candidates+1] = {synApi.queueonteleport, synApi}
    end
    for _,entry in ipairs(candidates) do
        local fn,owner=entry[1],entry[2]
        if type(fn)=="function" then
            local ok=pcall(fn,TELEPORT_RESTART_CODE)
            if not ok and owner then ok=pcall(fn,owner,TELEPORT_RESTART_CODE) end
            if ok then
                ENV.PuckHubAFSTeleportQueuedForJob=thisServer
                ENV.PuckHubAFSTeleportQueueState="queued"
                return true
            end
        end
    end
    ENV.PuckHubAFSTeleportQueueState="executor-queue-unavailable"
    return false,"executor-queue-unavailable"
end

local premiumBusy = false
local function launchPremium(key, setStatus)
    if premiumBusy then return false end
    premiumBusy = true

    -- Resolve the script tier, but never bypass Premium key validation.
    setStatus("Checking available script for this game…")
    local resolveOk, info = resolvePremium()
    if not resolveOk then
        premiumBusy = false
        setStatus("Could not reach the Premium service. Try again in a moment.", true)
        return false
    end

    if not hasOnlyFreeRelease(info) and (type(info) ~= "table" or info.premium ~= true) then
        premiumBusy = false
        setStatus("Premium is not registered for this game. Contact staff.", true)
        return false
    end

    key = normalizeKey(key)
    if key == "" then
        premiumBusy = false
        setStatus("Enter your PuckHub Premium key first.", true)
        return false
    end
    if #key < 8 or #key > 256 then
        premiumBusy = false
        setStatus("That Premium key format does not look valid.", true)
        return false
    end

    local hwid = deviceIdentifier()
    if not hwid then
        premiumBusy = false
        setStatus("Could not determine a stable device identifier for Premium validation.", true)
        return false
    end

    local player = Players.LocalPlayer
    local payload = {
        key = key,
        hwid = hwid,
        slug = info.slug,
        executor = executorName(),
        script = info.name or info.slug,
        placeId = tostring(premiumRoutingPlaceId()),
        currentPlaceId = tostring(game.PlaceId),
        universeId = tostring(game.GameId),
        jobId = tostring(game.JobId or ""),
        robloxUserId = player and tostring(player.UserId) or "Unknown",
        robloxUsername = player and tostring(player.Name) or "Unknown",
    }

    -- A validated Premium selection can legitimately run a Free-only script.
    -- The Free button still takes the normal keyless path; only this Premium
    -- selection requires this additional POST /v1/validate round-trip.
    if hasOnlyFreeRelease(info) then
        setStatus("Validating your PuckHub key…")
        local validated, validationError = validatePremiumKeyOnly(payload)
        if not validated then
            premiumBusy = false
            setStatus("Key not accepted: " .. tostring(validationError or "invalid or expired key"), true)
            return false
        end
        ENV.PuckHubKey = key
        local persisted = saveKey(key)
        if readAutoValidateSavedKey() then saveAutoValidateSavedKey(true) end
        if not persisted then
            warn("[PuckAFK Hub] Premium validated; executor cannot persist the key. Session only.")
        end
        setStatus("Key accepted. No Premium release for this game — loading Free…")
        local loaded = launchFree(setStatus)
        premiumBusy = false
        return loaded
    end

    setStatus("Validating your PuckHub key…")
    local okSource, source, reason, errorCode = postPremiumSource(PREMIUM_API, payload)
    -- Retry alternate origin only for gateway/transport errors, never a rejected key.
    if not okSource and (source == 0 or source == 500 or source == 502 or source == 503 or source == 504) then
        local fallbackOk, fallbackSource, fallbackReason, fallbackCode = postPremiumSource(PREMIUM_API_FALLBACK, payload)
        if fallbackOk then
            okSource, source, reason, errorCode = fallbackOk, fallbackSource, fallbackReason, fallbackCode
        else
            source, reason, errorCode = fallbackSource, fallbackReason, fallbackCode
        end
    end

    if not okSource then
        premiumBusy = false
        local code = tostring(errorCode or "")
        local http = tonumber(source) or 0
        if code:find("GITHUB_", 1, true) == 1 or code:find("SOURCE_", 1, true) == 1 then
            setStatus("Key OK; Premium source unavailable (" .. code .. "). Contact staff.", true)
        elseif http == 401 or http == 403 then
            setStatus("Premium key rejected: " .. tostring(reason or "invalid or expired key"), true)
        elseif http == 404 and code == "ROUTE_MISMATCH" then
            setStatus("Premium is not registered for this game yet.", true)
        else
            setStatus("Premium delivery error (HTTP " .. tostring(http) .. "). Key may be valid; contact staff.", true)
        end
        return false
    end

    setStatus("Key accepted. Launching Premium…")
    ENV.PuckHubCurrentAccessMode = "premium"
    ENV.PuckHubAccessMode = "premium"
    ENV.PuckHubKey = key
    local keyPersisted = saveKey(key)
    if readAutoValidateSavedKey() then saveAutoValidateSavedKey(true) end
    if not keyPersisted then
        warn("[PuckAFK Hub] Premium validated; executor cannot persist the key. Session only.")
    end

    local launched, runtimeError = launchSource(source, tostring(info.name or "Premium script"))
    ENV.PuckHubAccessMode = nil
    premiumBusy = false
    if not launched then
        setStatus(runtimeError, true)
        return false
    end

    if game.GameId==AFS_UNIVERSE_ID then
        local queued=queueAutoLaunchAfterTeleport()
        if not queued then
            warn("[PuckAFK Hub] No teleport queue API; use executor Auto Execute with the normal versioned loader command for AFS subplaces.")
        end
    end
    setStatus("Premium loaded successfully.")
    return true
end

-- ============================================================================
-- Classic PuckAFK access gate
-- Uses the original loader visual language instead of PuckUI.
-- ============================================================================

local ACCESS_GUI_NAME = "PuckAFKAccessLoader"

local THEME = {
    Main = Color3.fromRGB(12, 12, 12),
    Section = Color3.fromRGB(18, 18, 18),
    Element = Color3.fromRGB(24, 24, 24),
    ElementHover = Color3.fromRGB(32, 32, 32),
    Border = Color3.fromRGB(45, 45, 45),
    BorderDark = Color3.fromRGB(5, 5, 5),
    Text = Color3.fromRGB(170, 170, 170),
    DimText = Color3.fromRGB(100, 100, 100),
    BrightText = Color3.fromRGB(230, 230, 230),
    Accent = Color3.fromRGB(0, 95, 255),
    Danger = Color3.fromRGB(180, 58, 64),
    Success = Color3.fromRGB(48, 145, 78),
    Discord = Color3.fromRGB(88, 101, 242),
    DiscordDark = Color3.fromRGB(32, 34, 52),
    DiscordHover = Color3.fromRGB(40, 43, 68),
}

-- Real Roblox image assets layered into the existing classic UI.
-- These do not alter the classic layout or replace it with another framework.
local ICON = {
    Discord = "rbxassetid://18977771125",
    Crown = "rbxassetid://7733765398",
    Gamepad = "rbxassetid://7733799795",
    ShieldCheck = "rbxassetid://7734056411",
    ExternalLink = "rbxassetid://7743866903",
    Globe = "rbxassetid://7733954760",
    Key = "rbxassetid://7733965118",
    Trash = "rbxassetid://7743873772",
    Back = "rbxassetid://7733717651",
    Check = "rbxassetid://7733715400",
    Close = "rbxassetid://7743878496",
}

local function accessCreate(className, properties)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    return object
end

local function accessTween(object, duration, properties, style, direction)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.12,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        ),
        properties
    )
    animation:Play()
    return animation
end

local function accessLabel(parent, textValue, textSize, color, zIndex)
    return accessCreate("TextLabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Text = tostring(textValue or ""),
        TextColor3 = color or THEME.Text,
        TextSize = textSize or 12,
        Font = Enum.Font.Code,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        ZIndex = zIndex or 10,
        Parent = parent,
    })
end

local function accessIcon(parent, asset, position, size, tint, zIndex)
    local icon = accessCreate("ImageLabel", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = asset,
        ImageColor3 = tint or THEME.BrightText,
        ScaleType = Enum.ScaleType.Fit,
        Position = position,
        Size = size,
        ZIndex = zIndex or ((parent and parent.ZIndex or 20) + 3),
        Parent = parent,
    })
    return icon
end

local function accessGuiParent(screenGui)
    local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local playerGui = player:FindFirstChildOfClass("PlayerGui")
    if not playerGui then
        playerGui = player:WaitForChild("PlayerGui", 10)
    end

    if playerGui then
        local ok = pcall(function()
            screenGui.Parent = playerGui
        end)
        if ok and screenGui.Parent == playerGui then
            return playerGui
        end
    end

    if type(gethui) == "function" then
        local ok, target = pcall(gethui)
        if ok and target then
            local parented = pcall(function()
                screenGui.Parent = target
            end)
            if parented then return target end
        end
    end

    local ok = pcall(function()
        screenGui.Parent = CoreGui
    end)
    if ok then return CoreGui end
    return nil
end

local function destroyOldAccessGui()
    local parents = {CoreGui}
    local player = Players.LocalPlayer
    if player then
        local playerGui = player:FindFirstChildOfClass("PlayerGui")
        if playerGui then table.insert(parents, playerGui) end
    end
    if type(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then table.insert(parents, result) end
    end

    for _, parent in ipairs(parents) do
        pcall(function()
            local old = parent:FindFirstChild(ACCESS_GUI_NAME)
            if old then old:Destroy() end
        end)
    end
end

local function accessButton(parent, name, textValue, position, size, callback, options)
    options = options or {}
    local baseColor = options.BackgroundColor3 or THEME.Element
    local hoverColor = options.HoverColor3 or THEME.ElementHover
    local button = accessCreate("TextButton", {
        Name = name,
        Position = position,
        Size = size,
        BackgroundColor3 = baseColor,
        BorderColor3 = THEME.BorderDark,
        BorderSizePixel = 1,
        AutoButtonColor = false,
        Font = Enum.Font.Code,
        Text = tostring(textValue or "Button"),
        TextColor3 = options.TextColor3 or THEME.BrightText,
        TextSize = options.TextSize or 11,
        ZIndex = options.ZIndex or 20,
        Parent = parent,
    })

    local scale = accessCreate("UIScale", {Scale = 1, Parent = button})
    local inner = accessCreate("Frame", {
        Name = "InnerBorder",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1,
        BorderColor3 = options.BorderColor3 or THEME.Border,
        BorderSizePixel = 1,
        ZIndex = button.ZIndex + 1,
        Parent = button,
    })

    local alive = true
    button.AncestryChanged:Connect(function(_, parentNow)
        if not parentNow then alive = false end
    end)

    local function hover(on)
        if not alive then return end
        accessTween(button, 0.10, {BackgroundColor3 = on and hoverColor or baseColor})
        accessTween(inner, 0.10, {BorderColor3 = on and (options.ActiveBorderColor3 or THEME.Accent) or (options.BorderColor3 or THEME.Border)})
        accessTween(scale, 0.10, {Scale = on and 1.012 or 1})
    end

    button.MouseEnter:Connect(function() hover(true) end)
    button.MouseLeave:Connect(function() hover(false) end)
    button.MouseButton1Down:Connect(function()
        if alive then accessTween(scale, 0.055, {Scale = 0.975}) end
    end)
    button.MouseButton1Up:Connect(function()
        if alive then accessTween(scale, 0.085, {Scale = 1.012}) end
    end)
    button.Activated:Connect(function()
        if not alive then return end
        accessTween(scale, 0.06, {Scale = 0.972})
        task.delay(0.065, function()
            if alive then accessTween(scale, 0.11, {Scale = 1}) end
        end)
        if callback then callback() end
    end)
    return button, scale, inner
end

local function createDiscordMark(parent, position, size, zIndex)
    local holder = accessCreate("Frame", {
        Name = "DiscordMark",
        Position = position,
        Size = UDim2.fromOffset(size, size),
        BackgroundColor3 = THEME.Discord,
        BorderSizePixel = 0,
        ZIndex = zIndex or 30,
        Parent = parent,
    })
    accessCreate("UICorner", {CornerRadius = UDim.new(0, math.max(7, math.floor(size * 0.24))), Parent = holder})
    local scale = accessCreate("UIScale", {Scale = 1, Parent = holder})
    local logo = accessIcon(holder, ICON.Discord, UDim2.fromScale(0.16, 0.16), UDim2.fromScale(0.68, 0.68), Color3.fromRGB(255, 255, 255), holder.ZIndex + 2)
    logo.Name = "DiscordLogo"
    return holder, scale
end

local function createDiscordCard(parent, position, size, callback)
    local card = accessCreate("TextButton", {
        Name = "DiscordCard",
        Position = position,
        Size = size,
        BackgroundColor3 = THEME.DiscordDark,
        BorderColor3 = THEME.BorderDark,
        BorderSizePixel = 1,
        AutoButtonColor = false,
        Text = "",
        ZIndex = 20,
        Parent = parent,
    })
    local scale = accessCreate("UIScale", {Scale = 1, Parent = card})
    local inner = accessCreate("Frame", {
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(64, 68, 105),
        BorderSizePixel = 1,
        ZIndex = 21,
        Parent = card,
    })
    local brand = accessCreate("Frame", {
        Size = UDim2.fromOffset(3, size.Y.Offset - 4),
        Position = UDim2.fromOffset(2, 2),
        BackgroundColor3 = THEME.Discord,
        BorderSizePixel = 0,
        ZIndex = 22,
        Parent = card,
    })

    local logo, logoScale = createDiscordMark(card, UDim2.fromOffset(12, math.floor((size.Y.Offset - 36) / 2)), 36, 24)
    local title = accessLabel(card, "PUCKAFK DISCORD", 12, THEME.BrightText, 24)
    title.Position = UDim2.fromOffset(58, 8)
    title.Size = UDim2.new(1, -142, 0, 18)
    local sub = accessLabel(card, "Get your Premium key and account help", 9, Color3.fromRGB(150, 154, 185), 24)
    sub.Position = UDim2.fromOffset(58, 26)
    sub.Size = UDim2.new(1, -142, 0, 16)
    local open = accessLabel(card, "COPY", 10, Color3.fromRGB(206, 210, 255), 24)
    open.AnchorPoint = Vector2.new(1, 0.5)
    open.Position = UDim2.new(1, -34, 0.5, 0)
    open.Size = UDim2.fromOffset(48, 22)
    open.TextXAlignment = Enum.TextXAlignment.Right

    local alive = true
    card.AncestryChanged:Connect(function(_, p) if not p then alive = false end end)
    card.MouseEnter:Connect(function()
        if not alive then return end
        accessTween(card, 0.11, {BackgroundColor3 = THEME.DiscordHover})
        accessTween(inner, 0.11, {BorderColor3 = THEME.Discord})
        accessTween(scale, 0.11, {Scale = 1.01})
        accessTween(logoScale, 0.11, {Scale = 1.08})
        accessTween(open, 0.11, {TextColor3 = Color3.fromRGB(255, 255, 255)})
    end)
    card.MouseLeave:Connect(function()
        if not alive then return end
        accessTween(card, 0.11, {BackgroundColor3 = THEME.DiscordDark})
        accessTween(inner, 0.11, {BorderColor3 = Color3.fromRGB(64, 68, 105)})
        accessTween(scale, 0.11, {Scale = 1})
        accessTween(logoScale, 0.11, {Scale = 1})
        accessTween(open, 0.11, {TextColor3 = Color3.fromRGB(206, 210, 255)})
    end)
    card.MouseButton1Down:Connect(function()
        if alive then accessTween(scale, 0.05, {Scale = 0.985}) end
    end)
    card.MouseButton1Up:Connect(function()
        if alive then accessTween(scale, 0.08, {Scale = 1.01}) end
    end)
    card.Activated:Connect(function()
        if callback then callback() end
    end)

    task.spawn(function()
        for _ = 1, 2 do
            if not alive then return end
            accessTween(logoScale, 0.32, {Scale = 1.055}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(0.34)
            if not alive then return end
            accessTween(logoScale, 0.32, {Scale = 1}, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            task.wait(0.34)
        end
    end)

    return card, open
end

local function runAccessGate(openPremiumImmediately, rememberedChoice, recoveredKey, autoValidateOnOpen)
    -- An older or re-executed gate must never resurrect a duplicate window.
    ENV.PuckHubAccessGateGeneration = (tonumber(ENV.PuckHubAccessGateGeneration) or 0) + 1
    local thisGate = ENV.PuckHubAccessGateGeneration
    destroyOldAccessGui()

    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    local phoneLayout = UserInputService.TouchEnabled and math.min(viewport.X, viewport.Y) <= 720
    local windowWidth = phoneLayout and 350 or 480
    local chooserHeight = phoneLayout and 370 or 348
    local premiumHeight = phoneLayout and 470 or 448
    -- The initial premium-only screen must animate to the *premium* height.
    -- Otherwise the chooser-height tween runs after the direct Premium setup
    -- and clips the bottom actions until the user navigates Back and forward.
    local currentHeight = openPremiumImmediately and premiumHeight or chooserHeight
    local cancelled = false
    local busy = false
    ENV.PuckHubLoaderVersion = "5.9.20"

    local fitScale = math.min(
        (viewport.X - 16) / math.max(windowWidth, 1),
        (viewport.Y - 16) / math.max(premiumHeight, 1)
    )
    local uiScaleValue = math.max(0.70, math.min(1, fitScale))

    local gui = accessCreate("ScreenGui", {
        Name = ACCESS_GUI_NAME,
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        DisplayOrder = 10001,
    })
    accessGuiParent(gui)

    local shadow = accessCreate("Frame", {
        Name = "Shadow",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 4, 0.5, 16),
        Size = UDim2.fromOffset(windowWidth, currentHeight),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 1,
        Parent = gui,
    })

    local card = accessCreate("CanvasGroup", {
        Name = "LoaderCard",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 12),
        Size = UDim2.fromOffset(windowWidth, currentHeight),
        BackgroundColor3 = THEME.Main,
        BorderColor3 = THEME.BorderDark,
        BorderSizePixel = 1,
        GroupTransparency = 1,
        Active = true,
        ZIndex = 2,
        Parent = gui,
    })

    accessCreate("UIScale", {Scale = uiScaleValue, Parent = card})
    accessCreate("UIScale", {Scale = uiScaleValue, Parent = shadow})

    -- Same subtle procedural rose / damask motif used by the classic loader.
    local roseBackground = accessCreate("CanvasGroup", {
        Name = "RoseBackground",
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        GroupTransparency = 0.78,
        ZIndex = 3,
        Parent = card,
    })

    local roseColor = Color3.fromRGB(255, 255, 255)
    local function softPart(parent, position, anchor, size, rotation, transparency)
        local part = accessCreate("Frame", {
            AnchorPoint = anchor or Vector2.new(0.5, 0.5),
            Position = position,
            Size = size,
            Rotation = rotation or 0,
            BackgroundColor3 = roseColor,
            BackgroundTransparency = transparency or 0.84,
            BorderSizePixel = 0,
            ZIndex = 3,
            Parent = parent,
        })
        accessCreate("UICorner", {CornerRadius = UDim.new(1, 0), Parent = part})
        return part
    end

    local function createRose(x, y, scale, tilt)
        local motif = accessCreate("Frame", {
            Position = UDim2.fromOffset(x - 36, y - 36),
            Size = UDim2.fromOffset(72, 72),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Rotation = tilt or 0,
            ZIndex = 3,
            Parent = roseBackground,
        })
        local center = UDim2.fromScale(0.5, 0.43)
        for index = 0, 5 do
            softPart(motif, center, Vector2.new(0.5, 0.92), UDim2.fromOffset(math.max(6, math.floor(13 * scale)), math.max(12, math.floor(24 * scale))), index * 60, 0.78)
        end
        for index = 0, 4 do
            softPart(motif, center, Vector2.new(0.5, 0.90), UDim2.fromOffset(math.max(4, math.floor(9 * scale)), math.max(8, math.floor(16 * scale))), index * 72 + 36, 0.72)
        end
        softPart(motif, center, Vector2.new(0.5, 0.5), UDim2.fromOffset(4, 4), 0, 0.62)
        softPart(motif, UDim2.new(0.5, -5, 0.68, 0), Vector2.new(1, 0.5), UDim2.fromOffset(17, 4), -32, 0.80)
        softPart(motif, UDim2.new(0.5, 5, 0.71, 0), Vector2.new(0, 0.5), UDim2.fromOffset(17, 4), 32, 0.80)
        local stem = accessCreate("Frame", {
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.new(0.5, 0, 0.60, 0),
            Size = UDim2.fromOffset(1, 24),
            BackgroundColor3 = roseColor,
            BackgroundTransparency = 0.78,
            BorderSizePixel = 0,
            ZIndex = 2,
            Parent = motif,
        })
        accessCreate("UIGradient", {
            Rotation = 90,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.12),
                NumberSequenceKeypoint.new(1, 1),
            }),
            Parent = stem,
        })
    end

    createRose(74, 112, 0.68, -7)
    createRose(220, 176, 0.60, 7)
    createRose(385, 105, 0.64, -5)
    createRose(448, 265, 0.52, 8)

    accessCreate("Frame", {
        Name = "InnerBorder",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1,
        BorderColor3 = THEME.Border,
        BorderSizePixel = 1,
        ZIndex = 4,
        Parent = card,
    })

    local titleBar = accessCreate("Frame", {
        Name = "TitleBar",
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.new(1, -4, 0, 24),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 8,
        Parent = card,
    })

    local titleLabel = accessLabel(titleBar, "PuckAFK Hub", 13, THEME.BrightText, 11)
    titleLabel.Position = UDim2.fromOffset(6, 0)
    titleLabel.Size = UDim2.new(1, -92, 1, 0)

    local closeButton = accessCreate("TextButton", {
        Name = "Close",
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -2, 0, 2),
        Size = UDim2.fromOffset(18, 19),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Font = Enum.Font.Code,
        Text = "",
        TextSize = 12,
        TextColor3 = THEME.DimText,
        ZIndex = 15,
        Parent = titleBar,
    })
    local closeIcon = accessIcon(closeButton, ICON.Close, UDim2.fromOffset(2, 2), UDim2.fromOffset(15, 15), THEME.DimText, 17)
    closeButton.MouseEnter:Connect(function() accessTween(closeIcon, 0.08, {ImageColor3 = THEME.BrightText}) end)
    closeButton.MouseLeave:Connect(function() accessTween(closeIcon, 0.08, {ImageColor3 = THEME.DimText}) end)
    local function closeAnimated()
        if cancelled then return end
        cancelled = true
        accessTween(card, 0.14, {GroupTransparency = 1, Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset, card.Position.Y.Scale, card.Position.Y.Offset + 8)})
        accessTween(shadow, 0.14, {BackgroundTransparency = 1, Position = UDim2.new(shadow.Position.X.Scale, shadow.Position.X.Offset, shadow.Position.Y.Scale, shadow.Position.Y.Offset + 8)})
        task.delay(0.15, function()
            pcall(function() gui:Destroy() end)
        end)
    end
    closeButton.Activated:Connect(closeAnimated)

    local dragHandle = accessCreate("TextButton", {
        Name = "DragHandle",
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(1, -42, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        AutoButtonColor = false,
        Text = "",
        Active = true,
        ZIndex = 14,
        Parent = titleBar,
    })

    local dragging = false
    local dragStart
    local startPosition
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = card.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragStart or not startPosition then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            card.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
            shadow.Position = UDim2.new(card.Position.X.Scale, card.Position.X.Offset + 4, card.Position.Y.Scale, card.Position.Y.Offset + 4)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)

    local accentTop = accessCreate("Frame", {
        Name = "AccentTop",
        Position = UDim2.fromOffset(2, 26),
        Size = UDim2.new(1, -4, 0, 1),
        BackgroundColor3 = THEME.Accent,
        BackgroundTransparency = 0.75,
        BorderSizePixel = 0,
        ZIndex = 9,
        Parent = card,
    })

    local contentHost = accessCreate("Frame", {
        Name = "ContentHost",
        Position = UDim2.fromOffset(phoneLayout and 14 or 24, 48),
        Size = UDim2.new(1, phoneLayout and -28 or -48, 1, -64),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 6,
        Parent = card,
    })

    local function pulseStatus(label, color)
        if not label or not label.Parent then return end
        label.TextTransparency = 0.35
        accessTween(label, 0.16, {TextTransparency = 0, TextColor3 = color or label.TextColor3})
        accessTween(accentTop, 0.11, {BackgroundTransparency = 0})
        task.delay(0.12, function()
            if accentTop.Parent then accessTween(accentTop, 0.22, {BackgroundTransparency = 0.12}) end
        end)
    end

    local function switchPanel(fromPanel, toPanel, targetTitle, targetHeight, direction)
        if not fromPanel or not toPanel then return end
        direction = direction or 1
        toPanel.Visible = true
        toPanel.GroupTransparency = 1
        toPanel.Position = UDim2.new(0, 12 * direction, 0, 0)
        accessTween(fromPanel, 0.12, {GroupTransparency = 1, Position = UDim2.new(0, -10 * direction, 0, 0)})
        currentHeight = targetHeight
        titleLabel.Text = targetTitle
        accessTween(card, 0.18, {Size = UDim2.fromOffset(windowWidth, currentHeight)}, Enum.EasingStyle.Quart)
        accessTween(shadow, 0.18, {Size = UDim2.fromOffset(windowWidth, currentHeight)}, Enum.EasingStyle.Quart)
        task.delay(0.09, function()
            if cancelled or not toPanel.Parent then return end
            fromPanel.Visible = false
            fromPanel.Position = UDim2.fromScale(0, 0)
            accessTween(toPanel, 0.18, {GroupTransparency = 0, Position = UDim2.fromScale(0, 0)}, Enum.EasingStyle.Quart)
        end)
    end

    local chooser = accessCreate("CanvasGroup", {
        Name = "Chooser",
        Size = UDim2.fromScale(1, 1),
        GroupTransparency = 0,
        BackgroundColor3 = THEME.Section,
        BorderColor3 = THEME.Border,
        BorderSizePixel = 1,
        ZIndex = 7,
        Parent = contentHost,
    })
    accessCreate("Frame", {
        Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1, BorderColor3 = THEME.BorderDark, BorderSizePixel = 1,
        ZIndex = 8, Parent = chooser,
    })

    local premium = accessCreate("CanvasGroup", {
        Name = "Premium",
        Size = UDim2.fromScale(1, 1),
        GroupTransparency = 1,
        BackgroundColor3 = THEME.Section,
        BorderColor3 = THEME.Border,
        BorderSizePixel = 1,
        Visible = false,
        ZIndex = 7,
        Parent = contentHost,
    })
    accessCreate("Frame", {
        Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1, BorderColor3 = THEME.BorderDark, BorderSizePixel = 1,
        ZIndex = 8, Parent = premium,
    })

    local chooserTitle = accessLabel(chooser, "Choose PuckHub Access", 13, THEME.BrightText, 12)
    chooserTitle.Position = UDim2.fromOffset(14, 14)
    chooserTitle.Size = UDim2.new(1, -28, 0, 22)
    chooserTitle.TextXAlignment = Enum.TextXAlignment.Center

    local chooserDetail = accessLabel(chooser, "Use the normal free hub or unlock Premium with your key.", 10, THEME.DimText, 12)
    chooserDetail.Position = UDim2.fromOffset(14, 38)
    chooserDetail.Size = UDim2.new(1, -28, 0, 18)
    chooserDetail.TextXAlignment = Enum.TextXAlignment.Center
    chooserDetail.TextTruncate = Enum.TextTruncate.AtEnd

    local chooserStatus = accessLabel(chooser, "Ready", 9, THEME.DimText, 12)
    chooserStatus.AnchorPoint = Vector2.new(0.5, 1)
    chooserStatus.Position = UDim2.new(0.5, 0, 1, -10)
    chooserStatus.Size = UDim2.new(1, -28, 0, 16)
    chooserStatus.TextXAlignment = Enum.TextXAlignment.Center

    local freeY = 72
    local premiumY = 130
    if phoneLayout then
        freeY = 70
        premiumY = 132
    end

    rememberedChoice = normalizeChoice(rememberedChoice)
    local rememberChoice = rememberedChoice ~= ""
    local savedCountdownToken = 0

    local function cancelSavedCountdown()
        savedCountdownToken = savedCountdownToken + 1
    end

    local function setChooserStatus(textValue, isError, success)
        if not chooserStatus.Parent then return end
        chooserStatus.Text = tostring(textValue or "")
        local color = isError and THEME.Danger or (success and THEME.Success or THEME.DimText)
        chooserStatus.TextColor3 = color
        pulseStatus(chooserStatus, color)
    end

    local function chooseFree()
        if busy or cancelled then return end
        cancelSavedCountdown()
        if rememberChoice then saveChoice("free") else clearSavedChoice() end
        busy = true
        setChooserStatus("Loading Free access...")
        accentTop.BackgroundColor3 = THEME.Accent
        task.spawn(function()
            local ok = launchFree(function(textValue, isError)
                setChooserStatus(textValue, isError, not isError)
            end)
            busy = false
            if ok and not cancelled then
                setChooserStatus("Free access started.", false, true)
                cancelled = true -- intentional close: disable reset recovery
                accessTween(card, 0.14, {GroupTransparency = 1})
                accessTween(shadow, 0.14, {BackgroundTransparency = 1})
                task.wait(0.15)
                pcall(function() gui:Destroy() end)
            end
        end)
    end

    local freeButton = accessButton(chooser, "FreeAccess", "FREE ACCESS", UDim2.new(0, 14, 0, freeY), UDim2.new(1, -28, 0, 42), chooseFree)
    accessIcon(freeButton, ICON.Gamepad, UDim2.fromOffset(12, 12), UDim2.fromOffset(18, 18), THEME.DimText, 24)

    local freeInfo = accessLabel(chooser, "No key required  •  normal public PuckAFK scripts", 9, THEME.DimText, 12)
    freeInfo.Position = UDim2.fromOffset(14, freeY + 43)
    freeInfo.Size = UDim2.new(1, -28, 0, 14)
    freeInfo.TextXAlignment = Enum.TextXAlignment.Center

    local premiumButton
    local function choosePremium()
        if busy or cancelled then return end
        cancelSavedCountdown()
        if rememberChoice then saveChoice("premium") else clearSavedChoice() end
        -- Premium selection always displays key entry. Never auto-load Free here.
        switchPanel(chooser, premium, "PuckAFK Hub | Premium", premiumHeight, 1)
    end

    premiumButton = accessButton(chooser, "PremiumAccess", "PREMIUM ACCESS", UDim2.new(0, 14, 0, premiumY), UDim2.new(1, -28, 0, 42), choosePremium)
    accessIcon(premiumButton, ICON.Crown, UDim2.fromOffset(12, 12), UDim2.fromOffset(18, 18), Color3.fromRGB(205, 174, 82), 24)

    local premiumInfo = accessLabel(chooser, "Premium requires a key; Free-only games fall back after validation", 9, THEME.DimText, 12)
    premiumInfo.Position = UDim2.fromOffset(14, premiumY + 43)
    premiumInfo.Size = UDim2.new(1, -28, 0, 14)
    premiumInfo.TextXAlignment = Enum.TextXAlignment.Center

    if gameRequiresPremium() then
        chooserTitle.Text = premiumGameName() .. " | Premium"
        chooserDetail.Text = "Premium key required for " .. premiumGameName()
        freeButton.Visible = false
        freeInfo.Visible = false
        premiumButton.Position = UDim2.new(0, 14, 0, freeY)
        premiumInfo.Position = UDim2.fromOffset(14, freeY + 43)
    end

    local rememberY = premiumY + 66
    local rememberButton
    local function refreshRememberButton()
        if not rememberButton or not rememberButton.Parent then return end
        rememberButton.Text = rememberChoice and "[x]  KEEP MY CHOICE" or "[ ]  KEEP MY CHOICE"
        rememberButton.TextColor3 = rememberChoice and THEME.Success or THEME.BrightText
    end

    rememberButton = accessButton(chooser, "RememberChoice", "[ ]  KEEP MY CHOICE", UDim2.new(0, 14, 0, rememberY), UDim2.new(1, -28, 0, 32), function()
        rememberChoice = not rememberChoice
        cancelSavedCountdown()
        if not rememberChoice then
            local cleared = clearSavedChoice()
            rememberedChoice = ""
            setChooserStatus(cleared
                and "Keep choice is off — the loader will ask every time."
                or "Choice cleared for this session; executor cannot erase saved file.",
                not cleared, cleared)
        else
            local permanent = type(readfile) == "function"
                and type(writefile) == "function"
            setChooserStatus(permanent
                and "Keep choice is on — your selection will be saved when picked."
                or "Keep choice is on for this session only; no persistent file APIs.",
                not permanent, permanent)
        end
        refreshRememberButton()
    end, {TextSize = 10})
    refreshRememberButton()

    local rememberInfo = accessLabel(chooser, "Off by default  •  turn this on only if you want PuckHub to keep your tier", 9, THEME.DimText, 12)
    rememberInfo.Position = UDim2.fromOffset(14, rememberY + 34)
    rememberInfo.Size = UDim2.new(1, -28, 0, 14)
    rememberInfo.TextXAlignment = Enum.TextXAlignment.Center
    rememberInfo.TextTruncate = Enum.TextTruncate.AtEnd

    local setPremiumStatus

    local premiumTitle = accessLabel(premium, "Premium Access", 13, THEME.BrightText, 12)
    premiumTitle.Position = UDim2.fromOffset(14, 10)
    premiumTitle.Size = UDim2.new(1, -28, 0, 22)
    premiumTitle.TextXAlignment = Enum.TextXAlignment.Center

    local premiumDetail = accessLabel(premium, "Copy a link, paste it into your browser, then validate your key below.", 10, THEME.DimText, 12)
    premiumDetail.Position = UDim2.fromOffset(14, 31)
    premiumDetail.Size = UDim2.new(1, -28, 0, 18)
    premiumDetail.TextXAlignment = Enum.TextXAlignment.Center
    premiumDetail.TextTruncate = Enum.TextTruncate.AtEnd

    local discordCard, discordAction
    discordCard, discordAction = createDiscordCard(premium, UDim2.fromOffset(14, 58), UDim2.new(1, -28, 0, 56), function()
        if busy then return end
        setPremiumStatus("Copying Discord invite...")
        local copied = copyToClipboard(DISCORD_INVITE)
        if copied then
            if discordAction and discordAction.Parent then discordAction.Text = "COPIED" end
            setPremiumStatus("Discord invite copied — paste it into your browser.", false, true)
            task.delay(2.4, function()
                if discordAction and discordAction.Parent then discordAction.Text = "COPY" end
            end)
        else
            setPremiumStatus("Clipboard is unavailable on " .. executorName() .. ".", true)
        end
    end)

    local premiumPageButton
    premiumPageButton = accessButton(premium, "PremiumPage", "COPY PREMIUM WEBSITE", UDim2.new(0, 14, 0, 122), UDim2.new(1, -28, 0, 30), function()
        if busy then return end
        setPremiumStatus("Copying Premium website...")
        local copied = copyToClipboard(PREMIUM_PAGE)
        if copied then
            if premiumPageButton and premiumPageButton.Parent then premiumPageButton.Text = "COPIED — PASTE IN BROWSER" end
            setPremiumStatus("Premium website copied — paste it into your browser.", false, true)
            task.delay(2.4, function()
                if premiumPageButton and premiumPageButton.Parent then premiumPageButton.Text = "COPY PREMIUM WEBSITE" end
            end)
        else
            setPremiumStatus("Clipboard is unavailable on " .. executorName() .. ".", true)
        end
    end, {ActiveBorderColor3 = THEME.Accent})
    accessIcon(premiumPageButton, ICON.Globe, UDim2.fromOffset(10, 7), UDim2.fromOffset(16, 16), THEME.DimText, 24)

    local savedKey = type(recoveredKey) == "string" and recoveredKey or readSavedKey()
    local keyBox = accessCreate("TextBox", {
        Name = "PremiumKey",
        Position = UDim2.fromOffset(14, 160),
        Size = UDim2.new(1, -28, 0, 34),
        BackgroundColor3 = THEME.Element,
        BorderColor3 = THEME.BorderDark,
        BorderSizePixel = 1,
        ClearTextOnFocus = false,
        Font = Enum.Font.Code,
        Text = savedKey,
        PlaceholderText = "PH-XXXXX-XXXXX-XXXXX-XXXXX",
        PlaceholderColor3 = THEME.DimText,
        TextColor3 = THEME.BrightText,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 20,
        Parent = premium,
    })
    accessCreate("UIPadding", {
        PaddingLeft = UDim.new(0, 10),
        PaddingRight = UDim.new(0, 10),
        Parent = keyBox,
    })
    local keyInner = accessCreate("Frame", {
        Name = "KeyInnerBorder",
        Position = UDim2.fromOffset(1, 1), Size = UDim2.new(1, -2, 1, -2),
        BackgroundTransparency = 1, BorderColor3 = THEME.Border, BorderSizePixel = 1,
        ZIndex = 21, Parent = keyBox,
    })
    keyBox.Focused:Connect(function()
        accessTween(keyBox, 0.12, {BackgroundColor3 = THEME.ElementHover})
        accessTween(keyInner, 0.12, {BorderColor3 = THEME.Accent})
    end)
    keyBox.FocusLost:Connect(function()
        accessTween(keyBox, 0.12, {BackgroundColor3 = THEME.Element})
        accessTween(keyInner, 0.12, {BorderColor3 = THEME.Border})
    end)

    local premiumStatus = accessLabel(premium, savedKey ~= "" and "Saved key found — press Validate to check it." or "Enter a key to validate, or go Back to Free.", 9, THEME.DimText, 12)
    premiumStatus.Position = UDim2.fromOffset(14, 198)
    premiumStatus.Size = UDim2.new(1, -28, 0, 18)
    premiumStatus.TextXAlignment = Enum.TextXAlignment.Center
    premiumStatus.TextTruncate = Enum.TextTruncate.AtEnd

    setPremiumStatus = function(textValue, isError, success)
        if not premiumStatus.Parent then return end
        premiumStatus.Text = tostring(textValue or "")
        local color = isError and THEME.Danger or (success and THEME.Success or THEME.DimText)
        premiumStatus.TextColor3 = color
        accentTop.BackgroundColor3 = isError and THEME.Danger or (success and THEME.Success or THEME.Accent)
        pulseStatus(premiumStatus, color)
    end

    local function validateAndLaunchKey()
        if busy or cancelled then return end
        local key = normalizeKey(keyBox.Text)
        busy = true
        setPremiumStatus("Validating Premium key...")
        task.spawn(function()
            local called, launched = pcall(launchPremium, key, function(textValue, isError)
                if not cancelled and ENV.PuckHubAccessGateGeneration == thisGate then
                    setPremiumStatus(textValue, isError, false)
                end
            end)
            busy = false -- A rejected key, HTTP error or exception must never trap the GUI.
            if cancelled or ENV.PuckHubAccessGateGeneration ~= thisGate then return end
            if not called then
                premiumBusy = false -- Reset the internal lock as well; the next retry must work.
                -- Do not echo key or sensitive API contents to the GUI or console.
                setPremiumStatus("Could not validate key. Retry, or go Back to Free.", true)
                return
            end
            if launched then
                setPremiumStatus(ENV.PuckHubCurrentAccessMode == "free"
                    and "Free script launched successfully." or "Premium loaded successfully.", false, true)
                cancelled = true -- Close only after a successful launch.
                accessTween(card, 0.15, {GroupTransparency = 1})
                accessTween(shadow, 0.15, {BackgroundTransparency = 1})
                task.wait(0.16)
                pcall(function() gui:Destroy() end)
            end
            -- Failure: deliberately stay on this exact Premium screen. Retry
            -- with the existing key field, or use Back to Access -> Free.
        end)
    end
    local validateButton = accessButton(premium, "Validate", "VALIDATE KEY & LAUNCH", UDim2.new(0, 14, 0, 222), UDim2.new(1, -28, 0, 40), validateAndLaunchKey, {ActiveBorderColor3 = THEME.Success})
    accessIcon(validateButton, ICON.ShieldCheck, UDim2.fromOffset(12, 11), UDim2.fromOffset(18, 18), THEME.Success, 24)

    -- Define these up front so Forget Key resolves local closures (not globals).
    local savedKeyAutoEnabled
    local refreshAutoValidateButton
    local forgetButton = accessButton(premium, "ForgetKey", "FORGET SAVED KEY", UDim2.new(0, 14, 0, 272), UDim2.new(0.5, -18, 0, 30), function()
        if busy then return end
        local cleared = clearSavedKey()
        -- Forget Key also revokes consent for unattended saved-key validation.
        saveAutoValidateSavedKey(false)
        savedKeyAutoEnabled = false
        refreshAutoValidateButton()
        keyBox.Text = ""
        setPremiumStatus(cleared
            and "Saved Premium key removed."
            or "Key cleared from session; executor could not remove its saved file.",
            not cleared, cleared)
    end)
    accessIcon(forgetButton, ICON.Trash, UDim2.fromOffset(9, 7), UDim2.fromOffset(15, 15), THEME.DimText, 24)

    local backButton = accessButton(premium, "Back", "BACK TO ACCESS", UDim2.new(0.5, 4, 0, 272), UDim2.new(0.5, -18, 0, 30), function()
        if busy then return end
        accentTop.BackgroundColor3 = THEME.Accent
        switchPanel(premium, chooser, "PuckAFK Hub", chooserHeight, -1)
    end)
    accessIcon(backButton, ICON.Back, UDim2.fromOffset(9, 7), UDim2.fromOffset(15, 15), THEME.DimText, 24)

    local securityLabel = accessLabel(premium, "Key rejected? Try again or Back to Access for Free.", 9, THEME.DimText, 12)
    securityLabel.Position = UDim2.fromOffset(14, 312)
    securityLabel.Size = UDim2.new(1, -28, 0, 16)
    securityLabel.TextXAlignment = Enum.TextXAlignment.Center
    securityLabel.TextTruncate = Enum.TextTruncate.AtEnd
    if phoneLayout then
        securityLabel.Position = UDim2.fromOffset(14, 318)
    end

    savedKeyAutoEnabled = readAutoValidateSavedKey()
    local autoValidateButton
    refreshAutoValidateButton = function()
        if autoValidateButton and autoValidateButton.Parent then
            autoValidateButton.Text = savedKeyAutoEnabled
                and "[x]  AUTO VALIDATE SAVED KEY" or "[ ]  AUTO VALIDATE SAVED KEY"
            autoValidateButton.TextColor3 = savedKeyAutoEnabled and THEME.Success or THEME.BrightText
        end
    end
    autoValidateButton = accessButton(premium, "AutoValidateSavedKey", "[ ]  AUTO VALIDATE SAVED KEY",
        UDim2.fromOffset(14, 342), UDim2.new(1, -28, 0, 31), function()
            if busy or cancelled then return end
            savedKeyAutoEnabled = not savedKeyAutoEnabled
            local persisted = saveAutoValidateSavedKey(savedKeyAutoEnabled)
            if savedKeyAutoEnabled then
                -- Preserve Premium choice so future regular executor auto-runs
                -- know to enter the Premium validation flow automatically.
                saveChoice("premium")
            end
            refreshAutoValidateButton()
            setPremiumStatus(savedKeyAutoEnabled
                and (persisted and "Auto validation on — next execution uses saved key."
                    or "On this session only — filesystem cannot save the choice.")
                or (persisted and "Auto validation off. Next time, validate manually."
                    or "Off for this session; persistence unavailable."), not persisted)
        end, {TextSize = 10})
    refreshAutoValidateButton()

    -- On auto-execution, the SAME server validation path as the button runs.
    -- No loop or repeated retries: leave the panel available for manual retry.
    if autoValidateOnOpen == true and savedKeyAutoEnabled and savedKey ~= "" then
        task.defer(function()
            if not cancelled and ENV.PuckHubAccessGateGeneration == thisGate then
                validateAndLaunchKey()
            end
        end)
    end

    -- Select the correct initial panel before starting any entrance animation.
    -- Never change the card's Size mid-tween: direct Premium and manual navigation
    -- must finish with identical panel dimensions and working bottom buttons.
    if openPremiumImmediately then
        chooser.Visible = false
        chooser.GroupTransparency = 1
        premium.Visible = true
        premium.GroupTransparency = 0
        titleLabel.Text = "PuckAFK Hub | Premium"
    end

    card.Size = UDim2.fromOffset(windowWidth, currentHeight - 8)
    shadow.Size = UDim2.fromOffset(windowWidth, currentHeight - 8)
    accessTween(card, 0.26, {GroupTransparency = 0, Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(windowWidth, currentHeight)}, Enum.EasingStyle.Quart)
    accessTween(shadow, 0.26, {BackgroundTransparency = 0.5, Position = UDim2.new(0.5, 4, 0.5, 4), Size = UDim2.fromOffset(windowWidth, currentHeight)}, Enum.EasingStyle.Quart)
    accessTween(accentTop, 0.35, {BackgroundTransparency = 0.12}, Enum.EasingStyle.Sine)

    if rememberedChoice ~= "" and not openPremiumImmediately then
        local token = savedCountdownToken + 1
        savedCountdownToken = token
        local label = rememberedChoice == "free" and "Free" or "Premium"
        task.spawn(function()
            for seconds = 3, 1, -1 do
                if cancelled or busy or token ~= savedCountdownToken or not rememberChoice then return end
                setChooserStatus("Saved choice: " .. label .. "  •  continuing in " .. tostring(seconds) .. "s — click anything to change it.")
                task.wait(1)
            end
            if cancelled or busy or token ~= savedCountdownToken or not rememberChoice then return end
            if rememberedChoice == "free" then
                chooseFree()
            else
                choosePremium()
            end
        end)
    end

    -- Violence District occasionally clears/replaces PlayerGui while the
    -- access gate is open. ResetOnSpawn=false does not prevent explicit
    -- game:ClearAllChildren(). Recreate only a missing gate, never after the
    -- user closes it or launches a script successfully.
    task.spawn(function()
        while not cancelled and ENV.PuckHubAccessGateGeneration == thisGate do
            task.wait(0.8)
            if cancelled or ENV.PuckHubAccessGateGeneration ~= thisGate then break end
            local attached = false
            pcall(function()
                attached = gui.Parent ~= nil and gui:IsDescendantOf(game)
                if attached and not gui.Enabled then gui.Enabled = true end
            end)
            if not attached and not busy then
                task.wait(0.5) -- wait for the game's replacement PlayerGui
                if cancelled or ENV.PuckHubAccessGateGeneration ~= thisGate then break end
                local premiumWasOpen = openPremiumImmediately
                local lastKey = ""
                pcall(function()
                    premiumWasOpen = premium.Visible == true
                    lastKey = keyBox.Text
                end)
                return runAccessGate(premiumWasOpen, "", lastKey, false)
            end
        end
    end)
end

if not game:IsLoaded() then game.Loaded:Wait() end

-- Explicit requests now use PuckHubRequestedAccessMode. PuckHubAccessMode is runtime
-- state only and is cleared so a previous Free launch can never trap later executions.
local requestedMode = normalizeChoice(rawget(ENV, "PuckHubRequestedAccessMode"))
local legacyMode = normalizeChoice(rawget(ENV, "PuckHubAccessMode"))
ENV.PuckHubRequestedAccessMode = nil
ENV.PuckHubAccessMode = nil

-- Backward compatibility for older Premium purchase snippets: accept the old Premium
-- mode only when a Premium key is present. Deliberately ignore legacy Free mode.
if requestedMode == "" and legacyMode == "premium" and readSavedKey() ~= "" then
    requestedMode = "premium"
end

if requestedMode == "free" then
    if gameRequiresPremium() then return runAccessGate(true, readSavedChoice(), nil, false) end
    return launchFree()
elseif requestedMode == "premium" then
    -- Opt-in skips only the manual click, never validation or source authorization.
    return runAccessGate(true, readSavedChoice(), nil, readAutoValidateSavedKey())
end

local previousChoice = readSavedChoice()
local shouldAutoValidate = readAutoValidateSavedKey()
    and readSavedKey() ~= ""
    and (previousChoice == "premium" or gameRequiresPremium())
if shouldAutoValidate then
    return runAccessGate(true, previousChoice, nil, true)
end
return runAccessGate(gameRequiresPremium(), previousChoice, nil, false)
