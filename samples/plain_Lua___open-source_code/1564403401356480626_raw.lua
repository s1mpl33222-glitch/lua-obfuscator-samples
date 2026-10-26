do
local VXEZE_TRANSIENT = "[VXEZE_TRANSIENT]"
local vxezeRetryAfter = 3
local vxezeRetrySeed = 1
local vxezeRetryIdentity = tostring(game:GetService("HttpService"):GenerateGUID(false))
for i = 1, #vxezeRetryIdentity do
    vxezeRetrySeed = (vxezeRetrySeed * 131 + string.byte(vxezeRetryIdentity, i)) % 2147483647
end
local function vxezeRetryDelay(attempt, retryAfter)
    vxezeRetrySeed = (vxezeRetrySeed * 48271 + 1) % 2147483647
    local base = math.max(3, math.min(60, 2 ^ math.min(attempt, 6)))
    base = math.max(base, math.min(300, math.max(0, tonumber(retryAfter) or 0)))
    return base + base * 0.25 * (vxezeRetrySeed / 2147483647)
end
local function vxezePause(attempt, retryAfter)
    local seconds = vxezeRetryDelay(attempt, retryAfter)
    if task and type(task.wait) == "function" then task.wait(seconds) else wait(seconds) end
end
local function vxezeResponse(ok, response)
    if not ok then return 0, nil, nil end
    if type(response) == "string" then return 200, response, nil end
    if type(response) ~= "table" then return 0, nil, nil end
    local code = tonumber(response.StatusCode or response.Status or response.status_code or response.status)
        or (response.Success == false and 0 or 200)
    return code, response.Body or response.body or response.ResponseBody or response.response_body,
        response.Headers or response.headers
end
local function vxezeReadRetryAfter(headers, decoded)
    local seconds = type(decoded) == "table" and tonumber(decoded.retryAfterSeconds) or nil
    if type(headers) == "table" then
        for name, value in pairs(headers) do
            if tostring(name):lower() == "retry-after" then seconds = tonumber(value) or seconds end
        end
    end
    return math.min(300, math.max(0, seconds or 3))
end
local function vxezeTemporaryStatus(code, decoded)
    if code == 429 and type(decoded) == "table" and decoded.code == "ACTIVE_SESSIONS_FULL" then return false end
    return code == 0 or code == 408 or code == 425 or code == 429
        or (code >= 500 and code <= 599)
        or (code == 409 and type(decoded) == "table" and decoded.code == "VERIFY_IN_PROGRESS")
end
local vxezePendingRequests = {}
local function requestWithTimeout(options, timeoutSeconds, requestFunction)
    local channel = options.Url
    local authorization = options.Headers and options.Headers.Authorization or ""
    local pending = vxezePendingRequests[channel]
    if pending and (pending.body ~= options.Body or pending.authorization ~= authorization) then
        if not pending.done then return false, VXEZE_TRANSIENT .. " request still pending", true end
        vxezePendingRequests[channel] = nil
        pending = nil
    end
    if not pending then
        pending = { done = false, body = options.Body, authorization = authorization }
        vxezePendingRequests[channel] = pending
        local send = requestFunction or httpRequest
        task.spawn(function()
            pending.ok, pending.response = pcall(send, options)
            pending.done = true
        end)
    end
    local startedAt = os.clock()
    while not pending.done and os.clock() - startedAt < timeoutSeconds do task.wait(0.05) end
    if not pending.done then
        -- Retain the actual in-flight call. The next watchdog must not spawn
        -- another uncancellable executor request after a timeout.
        return false, VXEZE_TRANSIENT .. " request timed out", true
    end
    vxezePendingRequests[channel] = nil
    return pending.ok, pending.response, false
end
local function fetchSource(options)
    local send = (syn and syn.request) or http_request or request or (http and http.request)
    if type(send) == "function" then return send(options) end
    local ok, body = pcall(function() return game:HttpGet(options.Url) end)
    if ok then return { StatusCode = 200, Body = body } end
    return { StatusCode = tonumber(tostring(body):match("[Hh][Tt][Tt][Pp][^%d]*(%d%d%d)")) or 0, Body = tostring(body) }
end
local attempt = 0
while true do
    local ok, response = requestWithTimeout({ Url = "https://vxezestudio.online/api/scripts/script_JDI42TMhYSp60/stream/init", Method = "GET" }, 15, fetchSource)
    local code, body, headers = vxezeResponse(ok, response)
    local retryAfter = vxezeReadRetryAfter(headers)
    if code >= 200 and code < 300 and type(body) == "string" then
        local isStream = body:sub(1, 29) == "-- Vxeze stream transport v1\n"
        local compiler = loadstring or load
        local chunk, compileError = compiler(body)
        body, response = nil, nil
        if type(chunk) ~= "function" then error(compileError or "[Vxeze] Invalid loader source", 0) end
        if not isStream then chunk(); break end
        local transport = { PayloadStarted = false, Retryable = false }
        local executed, result = pcall(chunk, transport)
        if executed then break end
        if transport.PayloadStarted or not transport.Retryable then error(result, 0) end
        retryAfter = transport.RetryAfter or 3
    elseif not vxezeTemporaryStatus(code) then
        error("[Vxeze] Loader request rejected: HTTP " .. tostring(code), 0)
    end
    attempt = attempt + 1
    warn("[Vxeze] Server busy; loader will reconnect automatically.")
    vxezePause(attempt, retryAfter)
end
end