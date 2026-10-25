local __scoopHubEnvironment = _G
if type(getgenv) == 'function' then local __ok, __env = pcall(getgenv); if __ok and type(__env) == 'table' then __scoopHubEnvironment = __env end end
__scoopHubEnvironment.ScoopHubLaunchMode = "free"
--[[
    SCOOPHUB | UNIVERSAL KEYLOADER V2.1
    ScoopHub custom key loader

    Flow:
    1. Free uses keyless access while open, otherwise a validated Free key.
    2. The Premium route validates an explicitly supplied or saved Premium key.
    3. Invalid Premium access stays blocked and never falls back to Free.
    4. Every payload redemption is bound to the validated client/session/server.
    5. Free and Premium store validated keys in their separate folders.
]]

repeat task.wait() until game:IsLoaded()

local HubName = "ScoopHub"
local ProductName = "LOADER"
local ProductVersion = "V2.1"
-- Reuse the same ScoopHub mark shown in the main ScoopHub window.
local HubLogo = "rbxassetid://97406911955707"
local DiscordLogo = "rbxassetid://94434236999817"
local DiscordInvite = "discord.gg/9czKzA5mVt"
local KeyUrl = "https://scoophub.me/getkey/"
local WebsiteUrl = "https://scoophub.me/"
local ValidateUrl = "https://api.scoophub.me/api/key/validate"
local FreeAccessUrl = "https://api.scoophub.me/api/loader/free"
local LoaderBaseUrl = "https://loader.scoophub.me"

-- Official provider logos. Their ImageLabels have fully transparent backgrounds.
local LootLabsLogoAsset = "rbxassetid://102357888982176"
local LinkvertiseLogoAsset = "rbxassetid://77886518827598"
local SaveFolder = "ScoopHub"
local FreeFolder = SaveFolder .. "/Free"
local FreeKeyPath = FreeFolder .. "/key.txt"
local PremiumFolder = SaveFolder .. "/Premium"
local PremiumKeyPath = PremiumFolder .. "/key.txt"
local LegacyCredentialPath = PremiumFolder .. "/Session.json"
local LegacyRootKeyPath = SaveFolder .. "/Key.txt"
local LegacyKeyPath = SaveFolder .. "/ScoopHubKey.txt"

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local RuntimeEnvironment = _G
if type(getgenv) == "function" then
    local ok, environment = pcall(getgenv)
    if ok and type(environment) == "table" then
        RuntimeEnvironment = environment
    end
end

local LaunchMode = tostring(RuntimeEnvironment.ScoopHubLaunchMode or "auto"):lower()
if LaunchMode ~= "free" and LaunchMode ~= "premium" then
    LaunchMode = "auto"
end
local LoaderUrl = LaunchMode == "free" and (LoaderBaseUrl .. "/free")
    or LaunchMode == "premium" and (LoaderBaseUrl .. "/premium")
    or LoaderBaseUrl

-- Multiple queued copies can arrive together after a teleport. Keep a short
-- active-run lock, but always release it when this execution finishes. Older
-- loader builds stored a permanent boolean here; treat that value as stale so
-- updating the loader also repairs an already-blocked session.
local ExistingLoaderRun = RuntimeEnvironment.ScoopHubLoaderRunning
if type(ExistingLoaderRun) == "table" and ExistingLoaderRun.active == true then
    local startedAt = tonumber(ExistingLoaderRun.startedAt) or 0
    if os.clock() - startedAt < 30 then
        return
    end
end

local LoaderRunToken = {
    active = true,
    startedAt = os.clock(),
}
RuntimeEnvironment.ScoopHubLoaderRunning = LoaderRunToken

local function releaseLoaderLock()
    LoaderRunToken.active = false
    if RuntimeEnvironment.ScoopHubLoaderRunning == LoaderRunToken then
        RuntimeEnvironment.ScoopHubLoaderRunning = nil
    end
end

local function safeCall(callback, ...)
    local ok, result = pcall(callback, ...)
    if ok then
        return result
    end
    return nil
end

local function getRequestFunction()
    if type(request) == "function" then
        return request
    end
    if type(http_request) == "function" then
        return http_request
    end
    if type(syn) == "table" and type(syn.request) == "function" then
        return syn.request
    end
    if type(http) == "table" and type(http.request) == "function" then
        return http.request
    end
    return nil
end

local function getQueueFunction()
    if type(queue_on_teleport) == "function" then
        return queue_on_teleport
    end
    if type(queueonteleport) == "function" then
        return queueonteleport
    end
    if type(syn) == "table" and type(syn.queue_on_teleport) == "function" then
        return syn.queue_on_teleport
    end
    if type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" then
        return fluxus.queue_on_teleport
    end
    return nil
end

local function queueLoaderForTeleport()
    local queueFunction = getQueueFunction()
    if not queueFunction then
        return false
    end

    local queuedSource = string.format([[
repeat task.wait() until game:IsLoaded()
loadstring(game:HttpGet(%q, true))()
]], LoaderUrl)

    return pcall(queueFunction, queuedSource)
end

local function getHWID()
    local candidates = {
        gethwid,
        get_hwid,
        getexecutorhwid,
        getdeviceid,
    }

    if type(syn) == "table" and type(syn.gethwid) == "function" then
        table.insert(candidates, 1, syn.gethwid)
    end

    for _, callback in ipairs(candidates) do
        if type(callback) == "function" then
            local value = safeCall(callback)
            if value and tostring(value) ~= "" then
                return tostring(value)
            end
        end
    end

    -- Stable per Roblox client installation fallback.
    local clientId = safeCall(function()
        return RbxAnalyticsService:GetClientId()
    end)

    if clientId and tostring(clientId) ~= "" then
        return tostring(clientId)
    end

    return ""
end

local function getExecutorName()
    local candidates = {
        identifyexecutor,
        getexecutorname,
    }

    for _, callback in ipairs(candidates) do
        if type(callback) == "function" then
            local value = safeCall(callback)
            if value and tostring(value) ~= "" then
                return tostring(value)
            end
        end
    end

    return "Unknown"
end

local function buildValidationContext()
    local hwid = getHWID()
    local executor = getExecutorName()
    local nonce = HttpService:GenerateGUID(false):gsub("%-", "")

    return {
        hwid = hwid,
        executor = executor,
        clientNonce = nonce,
        robloxUsername = LocalPlayer and LocalPlayer.Name or "",
        robloxUserId = LocalPlayer and tostring(LocalPlayer.UserId) or "",
        placeId = tostring(game.PlaceId),
        gameId = tostring(game.GameId),
        jobId = tostring(game.JobId or ""),
    }
end

local function requestScoopHubAccess(url, key, credential)
    local requestFunction = getRequestFunction()
    if not requestFunction then
        return nil, "HTTP_REQUEST_UNAVAILABLE", nil
    end

    local context = buildValidationContext()

    local response = safeCall(requestFunction, {
        Url = url,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/json",
        },
        Body = HttpService:JSONEncode({
            key = tostring(key or ""),
            credential = tostring(credential or ""),
            hwid = context.hwid,
            clientNonce = context.clientNonce,
            loaderProtocol = 2,
            credentialMode = "raw_key",

            -- Execution metadata is included in this SAME validation request.
            robloxUsername = context.robloxUsername,
            robloxUserId = context.robloxUserId,
            executor = context.executor,
            placeId = context.placeId,
            gameId = context.gameId,
            jobId = context.jobId,
        }),
    })

    if type(response) ~= "table" then
        return nil, "REQUEST_FAILED", nil
    end

    local statusCode = tonumber(response.StatusCode or response.Status or response.status_code or 0) or 0
    local body = response.Body or response.body or ""

    local data = safeCall(function()
        return HttpService:JSONDecode(body)
    end)

    if type(data) ~= "table" then
        return nil, "INVALID_SERVER_RESPONSE", nil
    end

    if statusCode ~= 0 and statusCode >= 500 then
        return nil, "SERVER_ERROR", nil
    end

    return data, nil, context
end

local function validateWithScoopHub(key)
    return requestScoopHubAccess(ValidateUrl, key)
end

local function requestFreeAccess()
    return requestScoopHubAccess(FreeAccessUrl, "")
end

local function publishScoopHubSession(validationData, context, payloadData)
    local session = {
        access = validationData and validationData.guest == true and "free" or "premium",
        plan = tostring(validationData and validationData.plan or "free"),
        expiresAt = tonumber(validationData and validationData.expiresAt) or nil,
    }

    -- The protected payload and its child tools run in the same executor
    -- environment. This is runtime-only; it is never written to a file.
    if type(getgenv) == "function" then
        local environment = safeCall(getgenv)
        if type(environment) == "table" then
            environment.ScoopHubSession = session
        end
    end
    _G.ScoopHubSession = session

    local gameInfo = type(payloadData) == "table" and payloadData.game or nil
    local loaderGameId = tonumber(type(gameInfo) == "table" and gameInfo.id or 0)
    local runtimeToken = tostring(type(payloadData) == "table" and payloadData.runtimeToken or "")
    if loaderGameId and loaderGameId > 0 and runtimeToken ~= "" then
        if type(RuntimeEnvironment.ScoopHubPremiumSessions) ~= "table" then
            RuntimeEnvironment.ScoopHubPremiumSessions = {}
        end
        RuntimeEnvironment.ScoopHubPremiumSessions[loaderGameId] = {
            runtimeToken = runtimeToken,
            runtimeExpiresAt = tonumber(payloadData.runtimeExpiresAt) or nil,
        }
        _G.ScoopHubPremiumSessions = RuntimeEnvironment.ScoopHubPremiumSessions
    end
end

local function loadMainScript(validationData, context, key, reportStage)
    local function stage(message)
        if type(reportStage) == "function" then
            reportStage(message)
            -- Let the status text render before a network request, compile, or
            -- script startup has a chance to yield for a long time.
            task.wait()
        end
    end

    if type(validationData) ~= "table" then
        return false, "ScoopHub did not provide a game payload."
    end

    local requestFunction = getRequestFunction()
    if not requestFunction then
        return false, "Your executor does not support HTTP requests."
    end

    -- V3 responses provide one entry per script assigned to this Place ID.
    -- V1/V2 responses use the existing single-payload fields unchanged.
    local payloads = validationData.payloads
    if type(payloads) ~= "table" or #payloads == 0 then
        payloads = { validationData }
    end

    for index, payloadData in ipairs(payloads) do
        if type(payloadData) ~= "table" then
            return false, "ScoopHub provided an invalid game payload."
        end

        local payloadUrl = tostring(payloadData.payloadUrl or validationData.payloadUrl or "")
        if payloadUrl == "" then
            return false, "ScoopHub did not provide a game payload."
        end

        local protocol = tonumber(payloadData.payloadProtocol or validationData.payloadProtocol or 1) or 1
        local requestOptions
        if protocol >= 2 then
            local ticket = tostring(payloadData.payloadTicket or validationData.payloadTicket or "")
            local token = tostring(payloadData.payloadToken or validationData.payloadToken or "")
            if ticket == "" or token == "" or type(context) ~= "table" then
                return false, "ScoopHub did not provide secure payload authorization."
            end
            requestOptions = {
                Url = payloadUrl,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    ["Accept"] = "text/plain",
                },
                Body = HttpService:JSONEncode({
                    ticket = ticket,
                    token = token,
                    hwid = tostring(context.hwid or ""),
                    clientNonce = tostring(context.clientNonce or ""),
                    executor = tostring(context.executor or ""),
                    robloxUsername = tostring(context.robloxUsername or ""),
                    robloxUserId = tostring(context.robloxUserId or ""),
                    placeId = tostring(context.placeId or ""),
                    gameId = tostring(context.gameId or ""),
                    jobId = tostring(context.jobId or ""),
                }),
            }
        else
            requestOptions = {
                Url = payloadUrl,
                Method = "GET",
                Headers = {
                    ["Accept"] = "text/plain",
                },
            }
        end

        local buildPrefix = #payloads > 1 and string.format("Build %d/%d • ", index, #payloads) or ""
        stage(buildPrefix .. "Downloading protected build…")
        local downloadStartedAt = os.clock()
        local response = safeCall(requestFunction, requestOptions)
        local downloadSeconds = os.clock() - downloadStartedAt
        if type(response) ~= "table" then
            return false, string.format("The protected build download did not return (%.1fs).", downloadSeconds)
        end

        local statusCode = tonumber(response.StatusCode or response.Status or response.status_code or 0) or 0
        local source = response.Body or response.body or ""
        if statusCode ~= 0 and (statusCode < 200 or statusCode >= 300) then
            if statusCode == 401 or statusCode == 403 then
                return false, "Secure payload authorization was rejected."
            end
            return false, "The ScoopHub payload ticket expired or could not be used."
        end
        if type(source) ~= "string" or source == "" then
            return false, "Could not download the ScoopHub game build."
        end

        stage(string.format("%sBuild received (%d KB) in %.1fs. Compiling…", buildPrefix, math.max(1, math.ceil(#source / 1024)), downloadSeconds))
        local compileStartedAt = os.clock()
        local compiled = safeCall(loadstring, source)
        local compileSeconds = os.clock() - compileStartedAt
        if type(compiled) ~= "function" then
            return false, "The ScoopHub game build could not be compiled."
        end

        publishScoopHubSession(validationData, context, payloadData)
        stage(string.format("%sBuild compiled in %.1fs. Starting…", buildPrefix, compileSeconds))
        local startStartedAt = os.clock()
        local ok, err = pcall(compiled)
        if not ok then
            return false, "The ScoopHub game build failed to start: " .. tostring(err)
        end
        stage(string.format("%sStarted in %.1fs.", buildPrefix, os.clock() - startStartedAt))
    end
    return true
end

local function copyText(value)
    if setclipboard then
        safeCall(setclipboard, value)
        return true
    end
    if toclipboard then
        safeCall(toclipboard, value)
        return true
    end
    return false
end

local function getClipboardText()
    if getclipboard then
        return safeCall(getclipboard)
    end
    return nil
end

local function ensureFolder(folder)
    if isfolder and safeCall(isfolder, folder) then
        return true
    end
    if type(makefolder) ~= "function" then
        return false
    end
    return pcall(makefolder, folder)
end

local function loadSavedPremiumKey()
    if type(readfile) ~= "function" or not isfile or not safeCall(isfile, PremiumKeyPath) then
        return nil
    end
    local savedKey = safeCall(readfile, PremiumKeyPath)
    if not savedKey or tostring(savedKey) == "" then
        return nil
    end
    return tostring(savedKey):gsub("^%s+", ""):gsub("%s+$", ""):upper()
end

local function loadSavedFreeKey()
    if type(readfile) ~= "function" or not isfile or not safeCall(isfile, FreeKeyPath) then
        return nil
    end
    local savedKey = safeCall(readfile, FreeKeyPath)
    if not savedKey or tostring(savedKey) == "" then
        return nil
    end
    return tostring(savedKey):gsub("^%s+", ""):gsub("%s+$", ""):upper()
end

local function removeFiles(paths)
    local deleteFunction = type(delfile) == "function" and delfile or deletefile
    if type(deleteFunction) ~= "function" then
        return
    end
    for _, path in ipairs(paths) do
        if not isfile or safeCall(isfile, path) then
            pcall(deleteFunction, path)
        end
    end
end

local function removeLegacyPremiumFiles()
    removeFiles({LegacyCredentialPath, LegacyRootKeyPath, LegacyKeyPath})
end

local function removeLegacyFreeFiles()
    removeFiles({LegacyRootKeyPath, LegacyKeyPath})
end

local function savePremiumKey(value)
    local key = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
    if not key:match("^SCOOP%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]$") then
        return false
    end
    if type(writefile) ~= "function" then
        return false
    end
    if not ensureFolder(SaveFolder) or not ensureFolder(PremiumFolder) then
        return false
    end
    local saved = pcall(writefile, PremiumKeyPath, key)
    if saved then
        removeLegacyPremiumFiles()
    end
    return saved
end

local function saveFreeKey(value)
    local key = tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", ""):upper()
    if not key:match("^SCOOP%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]%-[A-Z2-9][A-Z2-9][A-Z2-9][A-Z2-9]$") then
        return false
    end
    if type(writefile) ~= "function" then
        return false
    end
    if not ensureFolder(SaveFolder) or not ensureFolder(FreeFolder) then
        return false
    end
    local saved = pcall(writefile, FreeKeyPath, key)
    if saved then
        removeLegacyFreeFiles()
    end
    return saved
end

local function trimKey(value)
    return tostring(value or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function getProvidedKey()
    local candidates = {
        RuntimeEnvironment.ScoopHubKey,
        RuntimeEnvironment.key,
        _G.ScoopHubKey,
        _G.key,
    }

    for _, candidate in ipairs(candidates) do
        local value = trimKey(candidate)
        if value ~= "" then
            return value
        end
    end

    return nil
end

local function clearProvidedKey()
    RuntimeEnvironment.ScoopHubKey = nil
    RuntimeEnvironment.key = nil
    _G.ScoopHubKey = nil
    _G.key = nil
end

local function validationFailureMessage(data, requestError)
    if type(data) ~= "table" then
        local requestMessages = {
            HTTP_REQUEST_UNAVAILABLE = "Your executor does not support HTTP requests.",
            REQUEST_FAILED = "Could not contact ScoopHub. Check your connection and try again.",
            INVALID_SERVER_RESPONSE = "ScoopHub returned an invalid response. Please try again.",
            SERVER_ERROR = "ScoopHub's key server is temporarily unavailable.",
        }
        return requestMessages[requestError] or "Automatic key validation failed. Please try again."
    end

    local reason = tostring(data.reason or data.error or "unknown")
    local messages = {
        expired = "This key has expired. Generate or enter a new key.",
        revoked = "This key has been revoked.",
        hwid_mismatch = "This key is already linked to another device. Reset its HWID in the ScoopHub dashboard.",
        hwid_required = "Your executor did not provide a stable device ID for secure loading.",
        loader_update_required = "Your ScoopHub keyloader is outdated. Re-execute the public loader.",
        not_found = "That ScoopHub key does not exist.",
        invalid_key_format = "That key format is invalid.",
        unsupported_game = "ScoopHub does not have a build assigned to this game yet.",
        game_disabled = "This ScoopHub game build is currently disabled.",
        game_maintenance = "This ScoopHub game build is under maintenance.",
        build_unavailable = "This ScoopHub game build is not uploaded yet.",
        premium_required = "This game build requires a Premium ScoopHub key.",
        free_required = "This game build is available to Free ScoopHub keys only.",
        keyless_free_disabled = "Keyless Free access is currently closed. Enter a valid ScoopHub key.",
        credential_invalid = "This saved Premium session is invalid. Enter your Premium key again.",
        credential_revoked = "This saved Premium session was revoked. Enter your Premium key again.",
        credential_expired = "This saved Premium session expired. Enter your Premium key again.",
    }

    if reason == "revoked" and data.banReason and tostring(data.banReason) ~= "" then
        return "This key has been revoked: " .. tostring(data.banReason)
    end
    return messages[reason] or "Key validation failed. Please try again."
end


local function freeFallbackAllowed(data, requestError)
    if requestError then
        return false
    end
    local reason = type(data) == "table" and tostring(data.reason or data.error or "") or ""
    return reason ~= "device_banned" and reason ~= "account_banned"
end

local function freeFallbackText(data)
    local reason = type(data) == "table" and tostring(data.reason or data.error or "") or ""
    if reason == "free_required" then
        return "This game uses its Free build. Loading it now."
    end
    if reason == "expired" then
        return "Your Premium key expired. Loading the Free version instead."
    end
    if reason == "revoked" or reason == "credential_revoked" then
        return "Premium access was revoked. Loading the public Free version instead."
    end
    if reason == "hwid_mismatch" then
        return "Premium access is linked to another device. Loading the public Free version instead."
    end
    return "Premium key unavailable. Loading the Free version instead."
end

local function notifyUser(title, text)
    safeCall(function()
        StarterGui:SetCore("SendNotification", {
            Title = tostring(title or "ScoopHub"),
            Text = tostring(text or ""),
            Duration = 5,
        })
    end)
end

local existing = CoreGui:FindFirstChild("ScoopHubKeySystem")
if existing then
    existing:Destroy()
end

-- Quick Loader path. /free never reads Premium state. /premium accepts only an
-- explicitly supplied key or ScoopHub/Premium/key.txt. Invalid Premium access
-- stays blocked; only the legacy /auto route may fall back to public Free.
local automaticFailure
local automaticKey
local function launchFree(fallbackData)
    local freeData, freeRequestError, freeContext = requestFreeAccess()
    if freeData and freeData.valid == true then
        if fallbackData then
            notifyUser("ScoopHub Free", freeFallbackText(fallbackData))
        end
        queueLoaderForTeleport()
        local loaded, loadError = loadMainScript(freeData, freeContext, "")
        if loaded then
            return true
        end
        return false, loadError or "Free access was approved, but ScoopHub could not start."
    end
    return false, validationFailureMessage(freeData, freeRequestError)
end

if LaunchMode == "free" then
    local loaded, keylessError = launchFree(nil)
    if loaded then
        releaseLoaderLock()
        return
    end

    local providedKey = getProvidedKey()
    local savedFreeKey = not providedKey and loadSavedFreeKey() or nil
    local authorizationKind
    local authorizationValue
    local data, requestError, validationContext

    if providedKey and trimKey(providedKey) ~= "" then
        authorizationKind, authorizationValue = "key", trimKey(providedKey)
        data, requestError, validationContext = validateWithScoopHub(authorizationValue)
    elseif savedFreeKey and trimKey(savedFreeKey) ~= "" then
        authorizationKind, authorizationValue = "saved_key", trimKey(savedFreeKey)
        data, requestError, validationContext = validateWithScoopHub(authorizationValue)
    end
    automaticKey = authorizationValue

    if data and data.valid == true then
        local plan = tostring(data.plan or "free"):lower()
        if plan ~= "free" then
            data = {valid = false, reason = "free_required"}
        else
            saveFreeKey(authorizationValue)
            if authorizationKind == "key" then
                clearProvidedKey()
            end
            queueLoaderForTeleport()
            local keyLoaded, loadError = loadMainScript(data, validationContext, "")
            if keyLoaded then
                releaseLoaderLock()
                return
            end
            automaticFailure = loadError or "Free-key access was approved, but ScoopHub could not start."
        end
    end

    if not automaticFailure and data then
        automaticFailure = validationFailureMessage(data, requestError)
    elseif not automaticFailure and requestError then
        automaticFailure = validationFailureMessage(nil, requestError)
    elseif not automaticFailure then
        automaticFailure = keylessError or "Keyless Free is closed. Enter a valid Free key."
    end
else
    local providedKey = getProvidedKey()
    local savedPremiumKey = not providedKey and loadSavedPremiumKey() or nil
    local authorizationKind
    local authorizationValue
    local data, requestError, validationContext

    if providedKey and trimKey(providedKey) ~= "" then
        authorizationKind, authorizationValue = "key", trimKey(providedKey)
        data, requestError, validationContext = validateWithScoopHub(authorizationValue)
    elseif savedPremiumKey and trimKey(savedPremiumKey) ~= "" then
        authorizationKind, authorizationValue = "saved_key", trimKey(savedPremiumKey)
        data, requestError, validationContext = validateWithScoopHub(authorizationValue)
    end
    automaticKey = authorizationValue

    if data and data.valid == true then
        local plan = tostring(data.plan or "free"):lower()
        local premiumPlan = plan == "premium" or plan == "monthly" or plan == "lifetime"
        if LaunchMode == "premium" and not premiumPlan then
            data = {valid = false, reason = "premium_required"}
        else
            if premiumPlan then
                savePremiumKey(authorizationValue)
            end
            if authorizationKind == "key" then
                clearProvidedKey()
            end
            queueLoaderForTeleport()
            local loaded, loadError = loadMainScript(data, validationContext, "")
            if loaded then
                releaseLoaderLock()
                return
            end
            automaticFailure = loadError or "Premium access was approved, but ScoopHub could not start."
        end
    end

    if LaunchMode == "auto" and not automaticFailure and data and data.valid ~= true and freeFallbackAllowed(data, requestError) then
        local loaded, loadError = launchFree(data)
        if loaded then
            releaseLoaderLock()
            return
        end
        automaticFailure = loadError
    elseif not automaticFailure and not data and not authorizationKind and LaunchMode == "auto" then
        local loaded, loadError = launchFree(nil)
        if loaded then
            releaseLoaderLock()
            return
        end
        automaticFailure = loadError
    elseif not automaticFailure and data then
        automaticFailure = validationFailureMessage(data, requestError)
    elseif not automaticFailure and requestError then
        automaticFailure = validationFailureMessage(nil, requestError)
    elseif not automaticFailure then
        automaticFailure = "Enter a Premium key to activate this device."
    end
end

local gui = Instance.new("ScreenGui")
gui.Name = "ScoopHubKeySystem"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = CoreGui

local function new(className, properties, parent)
    local instance = Instance.new(className)
    for property, value in pairs(properties) do
        instance[property] = value
    end
    instance.Parent = parent
    return instance
end

local function imageAsset(assetId)
    if type(assetId) == "string" and assetId ~= "" then
        return assetId
    end
    return ""
end

local LootLabsLogoImage = imageAsset(LootLabsLogoAsset)
local LinkvertiseLogoImage = imageAsset(LinkvertiseLogoAsset)

local function corner(parent, radius)
    return new("UICorner", { CornerRadius = UDim.new(0, radius) }, parent)
end

local function stroke(parent, color, transparency, thickness)
    return new("UIStroke", {
        Color = color,
        Transparency = transparency,
        Thickness = thickness or 1,
    }, parent)
end

local function tween(instance, info, values)
    local animation = TweenService:Create(instance, info, values)
    animation:Play()
    return animation
end

local Overlay = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(3, 3, 6),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
}, gui)

local Stars = new("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.fromScale(1, 1),
}, Overlay)

local starData = {
    { 0.06, 0.12, 1 }, { 0.11, 0.80, 1 }, { 0.18, 0.24, 2 }, { 0.25, 0.68, 1 },
    { 0.33, 0.08, 1 }, { 0.41, 0.90, 2 }, { 0.52, 0.15, 1 }, { 0.59, 0.71, 1 },
    { 0.66, 0.89, 2 }, { 0.75, 0.11, 1 }, { 0.83, 0.61, 2 }, { 0.94, 0.30, 1 },
    { 0.13, 0.50, 1 }, { 0.32, 0.45, 1 }, { 0.70, 0.39, 1 }, { 0.90, 0.83, 1 },
}
for _, data in ipairs(starData) do
    new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(255, 222, 230),
        BackgroundTransparency = data[3] == 2 and 0.22 or 0.48,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(data[1], data[2]),
        Size = UDim2.fromOffset(data[3], data[3]),
    }, Stars)
end

local Main = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(9, 8, 12),
    BackgroundTransparency = 0.04,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(400, 340),
}, Overlay)
local MainScale = new("UIScale", {
    Scale = 1,
}, Main)
corner(Main, 14)
stroke(Main, Color3.fromRGB(179, 52, 63), 0.86, 1)

new("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(39, 11, 17)),
        ColorSequenceKeypoint.new(0.52, Color3.fromRGB(8, 5, 8)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 8, 11)),
    }),
    Rotation = 90,
}, Main)

-- Keep the night-sky texture inside the panel only; never dim the game itself.
Stars.Parent = Main

new("Frame", {
    BackgroundColor3 = Color3.fromRGB(226, 39, 65),
    BackgroundTransparency = 0.93,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, 0, 0, 3),
    ZIndex = 2,
}, Main)

new("ImageLabel", {
    BackgroundTransparency = 1,
    Image = "rbxassetid://3926305904",
    ImageColor3 = Color3.fromRGB(237, 46, 72),
    ImageRectOffset = Vector2.new(324, 364),
    ImageRectSize = Vector2.new(36, 36),
    Visible = false,
}, Main)


local Kicker = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "KEY SYSTEM",
    TextColor3 = Color3.fromRGB(247, 58, 84),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(64, 14),
    Size = UDim2.fromOffset(180, 16),
}, Main)

local Brand = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    RichText = true,
    Text = ProductName .. " " .. ProductVersion,
    TextColor3 = Color3.fromRGB(176, 152, 161),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(64, 28),
    Size = UDim2.fromOffset(305, 19),
}, Main)

local LogoBox = new("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.fromOffset(23, 11),
    Size = UDim2.fromOffset(31, 31),
}, Main)

new("ImageLabel", {
    BackgroundTransparency = 1,
    Image = HubLogo,
    ImageColor3 = Color3.fromRGB(255, 255, 255),
    ScaleType = Enum.ScaleType.Fit,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(31, 31),
}, LogoBox)

local CloseButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(37, 20, 26),
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "X",
    TextColor3 = Color3.fromRGB(245, 239, 243),
    TextSize = 14,
    Position = UDim2.fromOffset(360, 13),
    Size = UDim2.fromOffset(24, 24),
    ZIndex = 6,
}, Main)
corner(CloseButton, 6)

-- Keep dragging on the header so interacting with the input and buttons never
-- moves the window. The close button remains above this surface.
local HeaderDragZone = new("TextButton", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Text = "",
    AutoButtonColor = false,
    Active = true,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, 0, 0, 53),
    ZIndex = 5,
}, Main)

local Divider = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(116, 19, 37),
    BackgroundTransparency = 0.38,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(24, 52),
    Size = UDim2.fromOffset(356, 1),
}, Main)

local Welcome = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    RichText = true,
    Text = "Unlock <font color=\"#f33a57\">ScoopHub</font> access.",
    TextColor3 = Color3.fromRGB(244, 240, 243),
    TextSize = 21,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(24, 62),
    Size = UDim2.fromOffset(350, 28),
}, Main)

local Description = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Enter your key to launch ScoopHub.",
    TextColor3 = Color3.fromRGB(169, 151, 160),
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(24, 90),
    Size = UDim2.fromOffset(350, 16),
}, Main)

local PasteButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(61, 30, 40),
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "PASTE",
    TextColor3 = Color3.fromRGB(255, 242, 245),
    TextSize = 12,
    Position = UDim2.fromOffset(24, 113),
    Size = UDim2.fromOffset(63, 37),
}, Main)
corner(PasteButton, 8)
stroke(PasteButton, Color3.fromRGB(112, 43, 57), 0.78, 1)

local KeyBox = new("TextBox", {
    BackgroundColor3 = Color3.fromRGB(42, 30, 37),
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    PlaceholderColor3 = Color3.fromRGB(184, 170, 176),
    PlaceholderText = "Paste or enter your key here...",
    Text = "",
    TextColor3 = Color3.fromRGB(247, 242, 245),
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(97, 113),
    Size = UDim2.fromOffset(279, 37),
}, Main)
corner(KeyBox, 8)
local KeyStroke = stroke(KeyBox, Color3.fromRGB(42, 30, 37), 1, 1)
new("UIPadding", {
    PaddingLeft = UDim.new(0, 13),
    PaddingRight = UDim.new(0, 13),
}, KeyBox)

local SubmitButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(151, 27, 48),
    BackgroundTransparency = 0.04,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "SUBMIT KEY  >",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Position = UDim2.fromOffset(24, 160),
    Size = UDim2.fromOffset(352, 37),
}, Main)
corner(SubmitButton, 8)
stroke(SubmitButton, Color3.fromRGB(239, 59, 82), 0.76, 1)

local StatusPill = new("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(24, 207),
    Size = UDim2.fromOffset(352, 18),
}, Main)
corner(StatusPill, 9)

local StatusDot = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(100, 221, 168),
    BorderSizePixel = 0,
    Visible = false,
    Size = UDim2.fromOffset(4, 4),
}, StatusPill)
corner(StatusDot, 4)

local Status = new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "Enter your ScoopHub key, or get one from the website below.",
    TextColor3 = Color3.fromRGB(177, 162, 168),
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.fromOffset(352, 18),
}, StatusPill)

local DiscordPill = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0),
    BackgroundColor3 = Color3.fromRGB(52, 31, 37),
    BackgroundTransparency = 0.08,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0, 230),
    Size = UDim2.fromOffset(190, 24),
}, Main)
corner(DiscordPill, 12)
stroke(DiscordPill, Color3.fromRGB(231, 47, 59), 0.62, 1)

new("ImageLabel", {
    Image = DiscordLogo,
    ImageColor3 = Color3.fromRGB(255, 255, 255),
    ScaleType = Enum.ScaleType.Fit,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 9, 0.5, -7),
    Size = UDim2.fromOffset(14, 14),
}, DiscordPill)

new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = DiscordInvite,
    TextColor3 = Color3.fromRGB(235, 235, 240),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(30, 0),
    Size = UDim2.new(1, -38, 1, 0),
}, DiscordPill)

local DiscordButton = new("TextButton", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "",
    Size = UDim2.fromScale(1, 1),
}, DiscordPill)

local LootLabsButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(72, 43, 92),
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "",
    TextColor3 = Color3.fromRGB(235, 229, 236),
    TextSize = 11,
    Position = UDim2.fromOffset(24, 264),
    Size = UDim2.fromOffset(171, 28),
}, Main)
corner(LootLabsButton, 7)
stroke(LootLabsButton, Color3.fromRGB(178, 122, 219), 0.42, 1)

local LootLabsIcon = new("TextLabel", {
    BackgroundColor3 = Color3.fromRGB(137, 78, 184),
    BackgroundTransparency = 0.02,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBlack,
    Text = "KEY",
    TextColor3 = Color3.fromRGB(255, 235, 133),
    TextSize = 7,
    Position = UDim2.fromOffset(7, 5),
    Size = UDim2.fromOffset(18, 18),
    Visible = LootLabsLogoImage == "",
}, LootLabsButton)
corner(LootLabsIcon, 5)
local LootLabsImage = new("ImageLabel", {
    BackgroundTransparency = 1,
    Image = LootLabsLogoImage,
    ScaleType = Enum.ScaleType.Fit,
    Visible = LootLabsLogoImage ~= "",
    Position = UDim2.fromOffset(5, 3),
    Size = UDim2.fromOffset(22, 22),
    ZIndex = 2,
}, LootLabsButton)
new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Get Key",
    TextColor3 = Color3.fromRGB(250, 242, 255),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(32, 0),
    Size = UDim2.fromOffset(101, 28),
}, LootLabsButton)
new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "›",
    TextColor3 = Color3.fromRGB(218, 183, 245),
    TextSize = 19,
    Position = UDim2.fromOffset(143, 2),
    Size = UDim2.fromOffset(17, 23),
}, LootLabsButton)

local LinkvertiseButton = new("TextButton", {
    BackgroundColor3 = Color3.fromRGB(101, 51, 30),
    BackgroundTransparency = 0.06,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBold,
    Text = "",
    TextColor3 = Color3.fromRGB(235, 229, 236),
    TextSize = 11,
    Position = UDim2.fromOffset(205, 264),
    Size = UDim2.fromOffset(171, 28),
}, Main)
corner(LinkvertiseButton, 7)
stroke(LinkvertiseButton, Color3.fromRGB(225, 114, 55), 0.42, 1)

local LinkvertiseIcon = new("TextLabel", {
    BackgroundColor3 = Color3.fromRGB(200, 82, 33),
    BackgroundTransparency = 0.02,
    BorderSizePixel = 0,
    Font = Enum.Font.GothamBlack,
    Text = "WEB",
    TextColor3 = Color3.fromRGB(255, 236, 202),
    TextSize = 8,
    Position = UDim2.fromOffset(7, 5),
    Size = UDim2.fromOffset(18, 18),
    Visible = LinkvertiseLogoImage == "",
}, LinkvertiseButton)
corner(LinkvertiseIcon, 5)
local LinkvertiseImage = new("ImageLabel", {
    BackgroundTransparency = 1,
    Image = LinkvertiseLogoImage,
    ScaleType = Enum.ScaleType.Fit,
    Visible = LinkvertiseLogoImage ~= "",
    Position = UDim2.fromOffset(5, 3),
    Size = UDim2.fromOffset(22, 22),
    ZIndex = 2,
}, LinkvertiseButton)
new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "Website",
    TextColor3 = Color3.fromRGB(255, 244, 237),
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.fromOffset(32, 0),
    Size = UDim2.fromOffset(101, 28),
}, LinkvertiseButton)
new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.GothamBold,
    Text = "›",
    TextColor3 = Color3.fromRGB(255, 189, 142),
    TextSize = 19,
    Position = UDim2.fromOffset(143, 2),
    Size = UDim2.fromOffset(17, 23),
}, LinkvertiseButton)

new("Frame", {
    BackgroundColor3 = Color3.fromRGB(122, 36, 48),
    BackgroundTransparency = 0.62,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(24, 303),
    Size = UDim2.fromOffset(352, 1),
}, Main)

new("TextLabel", {
    BackgroundTransparency = 1,
    Font = Enum.Font.Gotham,
    Text = "ScoopHub  •  Secure access powered by ScoopHub",
    TextColor3 = Color3.fromRGB(151, 127, 136),
    TextSize = 9,
    TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(24, 307),
    Size = UDim2.fromOffset(352, 12),
}, Main)

local isChecking = false
local function setStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color or Color3.fromRGB(165, 148, 157)
    StatusDot.BackgroundColor3 = color or Color3.fromRGB(100, 221, 168)
end

local function addButtonFeedback(button, normalColor, hoverColor)
    button.MouseEnter:Connect(function()
        if not isChecking then
            tween(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = hoverColor,
            })
        end
    end)
    button.MouseLeave:Connect(function()
        if not isChecking then
            tween(button, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = normalColor,
            })
        end
    end)
end

addButtonFeedback(PasteButton, Color3.fromRGB(61, 30, 40), Color3.fromRGB(82, 38, 52))
addButtonFeedback(SubmitButton, Color3.fromRGB(151, 27, 48), Color3.fromRGB(182, 34, 57))
addButtonFeedback(LootLabsButton, Color3.fromRGB(72, 43, 92), Color3.fromRGB(96, 58, 121))
addButtonFeedback(LinkvertiseButton, Color3.fromRGB(101, 51, 30), Color3.fromRGB(136, 67, 38))

KeyBox.Focused:Connect(function()
    tween(KeyBox, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(50, 35, 43),
    })
end)
KeyBox.FocusLost:Connect(function()
    tween(KeyBox, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundColor3 = Color3.fromRGB(42, 30, 37),
    })
end)

local function checkKey(value)
    if isChecking then
        return
    end

    value = trimKey(value)
    if value == "" then
        setStatus("Enter a key first.", Color3.fromRGB(244, 91, 110))
        return
    end

    isChecking = true
    SubmitButton.Text = "CHECKING KEY..."
    SubmitButton.BackgroundColor3 = Color3.fromRGB(85, 21, 33)
    setStatus("Contacting ScoopHub…", Color3.fromRGB(245, 199, 80))

    task.spawn(function()
        local data, requestError, validationContext = validateWithScoopHub(value)

        if not data then
            isChecking = false
            SubmitButton.Text = "SUBMIT KEY  >"
            SubmitButton.BackgroundColor3 = Color3.fromRGB(151, 27, 48)
            setStatus(validationFailureMessage(nil, requestError), Color3.fromRGB(244, 91, 110))
            return
        end

        if data.valid == true then
            local plan = tostring(data.plan or "free"):lower()
            local freePlan = plan == "free"
            local premiumPlan = plan == "premium" or plan == "monthly" or plan == "lifetime"
            if LaunchMode == "free" and not freePlan then
                data = {valid = false, reason = "free_required"}
            elseif LaunchMode == "premium" and not premiumPlan then
                data = {valid = false, reason = "premium_required"}
            else
                if LaunchMode == "free" and freePlan then
                    saveFreeKey(value)
                elseif premiumPlan then
                    savePremiumKey(value)
                end
                clearProvidedKey()
                queueLoaderForTeleport()

                local remainingText = ""
                if tonumber(data.expiresIn) then
                    local seconds = math.max(0, tonumber(data.expiresIn))
                    local days = math.floor(seconds / 86400)
                    local hours = math.floor((seconds % 86400) / 3600)

                    if days > 0 then
                        remainingText = string.format(" (%dd %dh remaining)", days, hours)
                    elseif hours > 0 then
                        remainingText = string.format(" (%dh remaining)", hours)
                    end
                end

                local gameName = type(data.game) == "table" and tostring(data.game.name or "") or ""
                local loadingName = gameName ~= "" and gameName or "ScoopHub"

                setStatus(
                    "Key accepted" .. remainingText .. ". Loading " .. loadingName .. "…",
                    Color3.fromRGB(92, 226, 171)
                )

                task.wait(0.35)

                local loaded, loadError = loadMainScript(data, validationContext, "", function(message)
                    setStatus(message, Color3.fromRGB(245, 199, 80))
                end)
                if loaded then
                    releaseLoaderLock()
                    gui:Destroy()
                    return
                end

                isChecking = false
                SubmitButton.Text = "SUBMIT KEY  >"
                SubmitButton.BackgroundColor3 = Color3.fromRGB(151, 27, 48)
                setStatus(loadError or "Key is valid, but the script could not be loaded.", Color3.fromRGB(244, 91, 110))
                return
            end
        end

        if LaunchMode == "auto" and freeFallbackAllowed(data, requestError) then
            setStatus("Checking Free access…", Color3.fromRGB(245, 199, 80))
            local freeData, freeRequestError, freeContext = requestFreeAccess()
            if freeData and freeData.valid == true then
                setStatus("Loading the Free version…", Color3.fromRGB(92, 226, 171))
                notifyUser("ScoopHub Free", freeFallbackText(data))
                queueLoaderForTeleport()
                local loaded, loadError = loadMainScript(freeData, freeContext, "", function(message)
                    setStatus(message, Color3.fromRGB(245, 199, 80))
                end)
                if loaded then
                    releaseLoaderLock()
                    gui:Destroy()
                    return
                end
                setStatus(loadError or "Free access was approved, but the script could not be loaded.", Color3.fromRGB(244, 91, 110))
            else
                setStatus(validationFailureMessage(freeData, freeRequestError), Color3.fromRGB(244, 91, 110))
            end
        else
            setStatus(validationFailureMessage(data, requestError), Color3.fromRGB(244, 91, 110))
        end

        isChecking = false
        SubmitButton.Text = "SUBMIT KEY  >"
        SubmitButton.BackgroundColor3 = Color3.fromRGB(151, 27, 48)
    end)
end

PasteButton.Activated:Connect(function()
    local clipboard = getClipboardText()
    if clipboard and clipboard ~= "" then
        KeyBox.Text = clipboard
        setStatus("Key pasted. Press Submit Key to continue.", Color3.fromRGB(165, 211, 255))
    else
        setStatus("Clipboard access is unavailable in this executor.", Color3.fromRGB(244, 91, 110))
    end
end)

SubmitButton.Activated:Connect(function()
    checkKey(KeyBox.Text)
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        checkKey(KeyBox.Text)
    end
end)

DiscordButton.Activated:Connect(function()
    copyText(DiscordInvite)
    setStatus("Discord invite copied to clipboard.", Color3.fromRGB(165, 211, 255))
end)

LootLabsButton.Activated:Connect(function()
    copyText(KeyUrl)
    setStatus("Get Key link copied to clipboard.", Color3.fromRGB(165, 211, 255))
end)

LinkvertiseButton.Activated:Connect(function()
    copyText(WebsiteUrl)
    setStatus("ScoopHub website copied to clipboard.", Color3.fromRGB(165, 211, 255))
end)

CloseButton.Activated:Connect(function()
    releaseLoaderLock()
    gui:Destroy()
end)

if automaticKey and automaticKey ~= "" then
    KeyBox.Text = automaticKey
end
if automaticFailure then
    setStatus(automaticFailure, Color3.fromRGB(244, 91, 110))
end

local dragging = false
local dragInput
local dragStart
local startPosition

local function beginDrag(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    dragging = true
    dragInput = input
    dragStart = input.Position
    startPosition = Main.Position

    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then
            dragging = false
            dragInput = nil
        end
    end)
end

HeaderDragZone.InputBegan:Connect(beginDrag)

UserInputService.InputChanged:Connect(function(input)
    if not dragging then
        return
    end

    local validMouse = input.UserInputType == Enum.UserInputType.MouseMovement
    local validTouch = input.UserInputType == Enum.UserInputType.Touch
    if not validMouse and not validTouch then
        return
    end

    local delta = input.Position - dragStart
    Main.Position = UDim2.new(
        startPosition.X.Scale,
        startPosition.X.Offset + delta.X,
        startPosition.Y.Scale,
        startPosition.Y.Offset + delta.Y
    )
end)

-- Some mobile executors also report mouse and keyboard support, so TouchEnabled
-- is the reliable signal. Recalculate when the camera or viewport changes.
local IS_MOBILE_DEVICE = UserInputService.TouchEnabled
local MOBILE_GUI_SCALE = 0.70
local MAIN_WIDTH = 400
local MAIN_HEIGHT = 340
local viewportConnection

local function updateScale()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end

    local viewport = camera.ViewportSize
    local baseScale = math.min(
        (viewport.X - 24) / MAIN_WIDTH,
        (viewport.Y - 24) / MAIN_HEIGHT
    )

    if IS_MOBILE_DEVICE then
        MainScale.Scale = math.clamp(baseScale * MOBILE_GUI_SCALE, 0.35, MOBILE_GUI_SCALE)
    else
        MainScale.Scale = math.clamp(baseScale, 0.62, 1)
    end
end

local function bindViewport()
    if viewportConnection then
        viewportConnection:Disconnect()
        viewportConnection = nil
    end

    local camera = workspace.CurrentCamera
    if camera then
        viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
    end
    updateScale()
end

workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewport)
bindViewport()
