local env = type(getgenv) == "function" and getgenv() or _G
local compiler = loadstring or load
assert(type(compiler) == "function", "HoneyLua requires loadstring or load")

local scriptId = tostring(env.HoneyLuaScriptId or ""):lower():gsub("^%s+", ""):gsub("%s+$", "")
assert(scriptId:match("^[a-z0-9%-]+$"), "HoneyLua loader did not select a supported script")
local scriptVersion = tostring(env.HoneyLuaScriptVersion or "1.0.0"):gsub("^%s+", ""):gsub("%s+$", "")
assert(scriptVersion:match("^%d+%.%d+%.%d+[%w%.%-]*$"), "HoneyLua loader selected an invalid script version")

local apiBase = tostring(env.HoneyAuthApiBase or env.HoneyAuthBaseUrl or "https://api.honeylua.com"):gsub("/+$", "")
if apiBase ~= "https://api.honeylua.com"
    and not apiBase:match("^http://127%.0%.0%.1:%d+$")
    and not apiBase:match("^http://localhost:%d+$") then
    apiBase = "https://api.honeylua.com"
end

local payloadRuntimeActive = type(env.HoneyLuaUI) == "table" and env.HoneyLuaLoaded == true
if scriptId == "murder-mystery-2" then
    local mm2Runtime = env.HoneyMM2Runtime
    payloadRuntimeActive = env.HoneyMM2CoreLoaded == true
        and type(mm2Runtime) == "table"
        and mm2Runtime.Active ~= false
end

local state = env.HoneyBootstrapState
if type(state) ~= "table" or state.scriptId ~= scriptId then
    state = {
        scriptId = scriptId,
        fetching = false,
        loaded = false,
    }
    env.HoneyBootstrapState = state
elseif state.loaded == true and payloadRuntimeActive ~= true then
    -- The UI unloads the protected game runtime, but the bootstrap state lives in
    -- the executor environment. Do not let a completed older run suppress the
    -- next authenticated payload request.
    state.fetching = false
    state.loaded = false
    state.loadedModules = {}
end

local function compileAndRun(source, label)
    assert(type(source) == "string" and source ~= "", tostring(label) .. " returned empty source")
    local chunk, compileError = compiler(source)
    assert(type(chunk) == "function", compileError or ("Failed to compile " .. tostring(label)))
    return chunk()
end

local function authClientIsCurrent(authClient)
    return type(authClient) == "table"
        and tonumber(authClient.RuntimeProofRevision or 0) >= 9
        and tonumber(authClient.PublicSurfaceRevision or 0) >= 3
        and type(authClient.RequireScriptPolicy) == "function"
        and type(authClient.IsAuthenticated) == "function"
        and type(authClient.ConfigureBaseUrl) == "function"
        and type(authClient.StartHeartbeat) == "function"
        and type(authClient.StopHeartbeat) ~= "function"
        and type(authClient.StopLiveChecks) ~= "function"
        and type(authClient.StopRandomizedChecks) ~= "function"
        and type(authClient.StopLoaderFlowChecks) ~= "function"
end

local function authClientIsAuthenticated(authClient)
    if not authClientIsCurrent(authClient) then
        return false
    end
    local ok, authenticated = pcall(authClient.IsAuthenticated)
    return ok == true and authenticated == true
end

local function refreshScriptPolicy(authClient)
    local callOk, allowed, policy = pcall(authClient.RequireScriptPolicy, {
        scriptId = scriptId,
        scriptVersion = scriptVersion,
        channel = "stable",
        releaseCapability = tostring(env.HoneyMM2ReleaseCapability or env.HoneyLuaReleaseCapability or ""),
    })
    if callOk == true and allowed == true then
        return true, policy
    end
    return false, tostring(policy or allowed or "HoneyLua script policy denied access")
end

local function prepareAuthClientPolicy()
    local authClient = env.HoneyAuthClient
    if not authClientIsCurrent(authClient) then
        local source = game:HttpGet(apiBase .. "/auth-client?runtime=9")
        authClient = compileAndRun(source, "HoneyLua AuthClient")
        assert(authClientIsCurrent(authClient), "HoneyLua AuthClient release is stale or exposes unsafe lifecycle controls")
        env.HoneyAuthClient = authClient
    end

    assert(authClient.ConfigureBaseUrl(apiBase) == true, "HoneyLua AuthClient rejected the API origin")

    local policyOk, policyOrError = refreshScriptPolicy(authClient)
    assert(policyOk == true, policyOrError)
    return authClient
end

prepareAuthClientPolicy()

local function loadMainUi()
    local existingUi = env.HoneyLuaUI
    if type(existingUi) == "table" then
        local contextOk, activeScriptId = pcall(function()
            return type(existingUi.GetAccessScriptId) == "function" and existingUi.GetAccessScriptId() or ""
        end)
        if contextOk and activeScriptId == scriptId then
            return existingUi
        end
        if type(existingUi.Unload) == "function" then
            pcall(existingUi.Unload, {skipAnimation = true})
        end
        env.HoneyLuaUI = nil
    end

    local function runMainUiSource(source)
        env.HoneyLuaMainUiAccessContext = {
            source = "honey-bootstrap",
            scriptId = scriptId,
        }
        local okRun, result = pcall(compileAndRun, source, "HoneyLua MainUI")
        env.HoneyLuaMainUiAccessContext = nil
        return okRun, result
    end

    if type(readfile) == "function" then
        local okRead, source = pcall(readfile, "Appearance/MainUi.luau")
        if okRead and type(source) == "string" and source ~= "" then
            local okRun, result = runMainUiSource(source)
            if okRun and type(result) == "table" then
                return result
            end
        end
    end

    local source = game:HttpGet(apiBase .. "/ui-source")
    local okRun, result = runMainUiSource(source)
    assert(okRun and type(result) == "table", result or "Failed to load HoneyLua MainUI")
    return result
end

local ui = loadMainUi()
assert(type(ui) == "table" and type(ui.RunAfterKeySystemUnlocked) == "function", "HoneyLua MainUI authentication gate is unavailable")

local function reportFailure(message)
    state.fetching = false
    state.lastError = tostring(message or "Protected payload delivery failed.")
    warn("[HoneyLua][payload] " .. state.lastError)
    if type(ui.Notify) == "function" then
        pcall(ui.Notify, {
            Title = "HoneyLua could not start",
            Description = state.lastError,
            Duration = 8,
        })
    end
end

local function runAuthorizedPayload()
    if state.fetching == true or state.loaded == true then
        return
    end
    local authContext = env.HoneyLuaAuth
    local authClient = type(authContext) == "table" and authContext.AuthClient or env.HoneyAuthClient
    if type(authClient) ~= "table"
        or type(authClient.RunBasePayload) ~= "function"
        or type(authClient.GetModuleManifest) ~= "function"
        or type(authClient.RunModule) ~= "function"
        or type(authClient.StartHeartbeat) ~= "function"
    then
        reportFailure("Authenticated payload client is unavailable.")
        return
    end

    if authClientIsAuthenticated(authClient) ~= true then
        if type(authClient.GetKeySystemStatus) ~= "function"
            or type(authClient.AuthenticateFree) ~= "function" then
            reportFailure("Open-access authentication is unavailable.")
            return
        end

        local statusCallOk, statusOk, accessStatus = pcall(authClient.GetKeySystemStatus, {
            scriptId = scriptId,
            channel = "stable",
        })
        if statusCallOk ~= true or statusOk ~= true or type(accessStatus) ~= "table" then
            reportFailure(tostring(accessStatus or statusOk or "Access mode could not be verified."))
            return
        end

        local accessMode = tostring(accessStatus.mode or ""):lower()
        if accessStatus.enabled ~= false and accessMode ~= "none" then
            reportFailure("Authenticated payload client is unavailable.")
            return
        end

        local policyOk, policyError = refreshScriptPolicy(authClient)
        if policyOk ~= true then
            reportFailure(policyError)
            return
        end

        local authCallOk, authOk, authResult = pcall(authClient.AuthenticateFree, {
            scriptId = scriptId,
            channel = "stable",
        })
        if authCallOk ~= true or authOk ~= true then
            local retryPolicyOk = refreshScriptPolicy(authClient)
            if retryPolicyOk == true then
                authCallOk, authOk, authResult = pcall(authClient.AuthenticateFree, {
                    scriptId = scriptId,
                    channel = "stable",
                })
            end
        end
        if authCallOk ~= true or authOk ~= true
            or authClientIsAuthenticated(authClient) ~= true then
            reportFailure(tostring(authResult or authOk or "Open-access authentication failed."))
            return
        end
    end

    state.fetching = true
    local heartbeatCallOk, heartbeatOk, heartbeatError = pcall(authClient.StartHeartbeat, function(message)
        state.loaded = false
        reportFailure(message or "HoneyLua access was revoked.")
    end)
    if heartbeatCallOk ~= true or heartbeatOk ~= true then
        reportFailure(heartbeatError or heartbeatOk or "Heartbeat startup failed.")
        return
    end

    local pipelineOk, loadedOk, loadError = pcall(function()
        local manifestOk, modulesOrError = authClient.GetModuleManifest()
        if manifestOk ~= true then
            return false, modulesOrError or "Protected module manifest is unavailable."
        end
        local modules = type(modulesOrError) == "table" and modulesOrError or {}
        local function runPhase(phase)
            for _, module in ipairs(modules) do
                if type(module) == "table" and module.phase == phase then
                    state.loadedModules = type(state.loadedModules) == "table" and state.loadedModules or {}
                    if state.loadedModules[module.id] ~= true then
                        local callOk, moduleOk, moduleError = pcall(authClient.RunModule, module.id)
                        if callOk ~= true or moduleOk ~= true then
                            return false, callOk and moduleError or moduleOk
                        end
                        state.loadedModules[module.id] = true
                    end
                end
            end
            return true
        end

        local beforeOk, beforeError = runPhase("before-game-payload")
        if beforeOk ~= true then
            return false, beforeError or "A required startup module failed."
        end
        local callOk, payloadOk, payloadError = pcall(authClient.RunBasePayload)
        if callOk ~= true or payloadOk ~= true then
            return false, callOk and payloadError or payloadOk
        end
        local afterOk, afterError = runPhase("after-game-payload")
        if afterOk ~= true then
            return false, afterError or "A required post-start module failed."
        end
        return true
    end)
    if pipelineOk ~= true or loadedOk ~= true then
        reportFailure(pipelineOk and loadError or loadedOk)
        return
    end
    state.fetching = false
    state.loaded = true
    state.lastError = nil
end

ui.RunAfterKeySystemUnlocked(runAuthorizedPayload)
return ui
