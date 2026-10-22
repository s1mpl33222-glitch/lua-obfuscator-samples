local settings = {
    reporterId = nil,
    version = "1.0.0",
    heartbeatInterval = 300,
    autoSend = true,
    includeUserId = true,
    resumeTeleport = true,
    printEvents = false,
    platform = nil
}

local endpoint = "https://scriptblox.com/ingest/v1"
local limits = {
    queueSize = 100,
    sendGap = 5,
    attempts = 3,
    bodyBytes = 8000,
    requestTimeout = 10,
    drainTimeout = 15,
    restartCooldown = 30,
    resumeLifetime = 120
}

assert(type(bit32) == "table", "analytics: bit32 is unavailable")

local band, bxor, bnot = bit32.band, bit32.bxor, bit32.bnot
local rshift, rrotate = bit32.rshift, bit32.rrotate
local modulus = 4294967296
local constants = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function sha256(value)
    local length = #value * 8
    local bytes = {string.byte(value, 1, #value)}
    bytes[#bytes + 1] = 128
    while #bytes % 64 ~= 56 do
        bytes[#bytes + 1] = 0
    end
    local high, low = math.floor(length / modulus), length % modulus
    for shift = 24, 0, -8 do bytes[#bytes + 1] = band(rshift(high, shift), 255) end
    for shift = 24, 0, -8 do bytes[#bytes + 1] = band(rshift(low, shift), 255) end
    local hash = {0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a, 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19}
    for offset = 1, #bytes, 64 do
        local words = {}
        for i = 0, 15 do
            local p = offset + i * 4
            words[i] = bytes[p] * 16777216 + bytes[p + 1] * 65536 + bytes[p + 2] * 256 + bytes[p + 3]
        end
        for i = 16, 63 do
            local x, y = words[i - 15], words[i - 2]
            local s0 = bxor(rrotate(x, 7), rrotate(x, 18), rshift(x, 3))
            local s1 = bxor(rrotate(y, 17), rrotate(y, 19), rshift(y, 10))
            words[i] = (words[i - 16] + s0 + words[i - 7] + s1) % modulus
        end
        local a, b, c, d, e, f, g, h = table.unpack(hash)
        for i = 0, 63 do
            local s1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
            local choose = bxor(band(e, f), band(bnot(e), g))
            local t1 = (h + s1 + choose + constants[i + 1] + words[i]) % modulus
            local s0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
            local majority = bxor(band(a, b), band(a, c), band(b, c))
            local t2 = (s0 + majority) % modulus
            h, g, f, e, d, c, b, a = g, f, e, (d + t1) % modulus, c, b, a, (t1 + t2) % modulus
        end
        local result = {a, b, c, d, e, f, g, h}
        for i = 1, 8 do hash[i] = (hash[i] + result[i]) % modulus end
    end
    for i = 1, 8 do hash[i] = string.format("%08x", hash[i]) end
    return table.concat(hash)
end

local function finite(value)
    return type(value) == "number" and value == value and math.abs(value) < math.huge
end

local function integer(value, minimum, maximum)
    return finite(value) and value % 1 == 0 and value >= minimum and value <= maximum
end

local function text(value, maximum)
    return type(value) == "string" and #value > 0 and #value <= maximum and not value:find("[%z\1-\31\127]")
end

local function copy(value)
    local result = {}
    for key, item in pairs(value) do
        result[key] = item
    end
    return result
end

local function resolveReporter()
    if type(settings.reporterId) == "string" then return settings.reporterId end
    local ok, env = pcall(getgenv)
    if ok and type(env) == "table" and type(env.ScriptBloxReporter) == "string" then
        return env.ScriptBloxReporter
    end
    local bare = rawget(_G, "ScriptBloxReporter")
    if type(bare) == "string" then return bare end
    return nil
end

local project = resolveReporter()
assert(type(project) == "string" and #project == 17 and project:match("^proj_[0-9a-f]+$"), "analytics: invalid reporter ID")
assert(text(settings.version, 16), "analytics: invalid script version")
assert(integer(settings.heartbeatInterval, 10, 3600), "analytics: heartbeat interval must be 10-3600 seconds")
local platforms = {Computer = true, Mobile = true, Console = true, Tablet = true}
assert(settings.platform == nil or platforms[settings.platform], "analytics: invalid platform")
for _, name in ipairs({"autoSend", "includeUserId", "resumeTeleport", "printEvents"}) do
    assert(type(settings[name]) == "boolean", "analytics: invalid " .. name)
end
assert(typeof(game) == "Instance" and game:IsA("DataModel"), "analytics: Roblox client required")
assert(game:IsLoaded(), "analytics: game has not finished loading")

local function findRequest()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if type(syn) == "table" and type(syn.request) == "function" then return syn.request end
    if type(http) == "table" and type(http.request) == "function" then return http.request end
    if type(fluxus) == "table" and type(fluxus.request) == "function" then return fluxus.request end
end

local sendRequest = findRequest()
if settings.autoSend then
    assert(sendRequest, "analytics: an HTTP request function is required")
    assert(type(task) == "table" and type(task.spawn) == "function" and type(task.wait) == "function", "analytics: task scheduler is unavailable")
end

local players = game:GetService("Players")
local run = game:GetService("RunService")
local http = game:GetService("HttpService")
local teleport = game:GetService("TeleportService")
assert(run:IsClient(), "analytics: client context required")
local player = players.LocalPlayer
assert(player and player:IsA("Player") and player.Parent == players, "analytics: local player is unavailable")
assert(integer(player.UserId, 1, 9007199254740991), "analytics: invalid player identifier")
assert(integer(game.PlaceId, 1, 9007199254740991) and integer(game.GameId, 1, 9007199254740991), "analytics: published experience required")
assert(text(game.JobId, 128), "analytics: server identity is unavailable")

local clock = os.clock
local started = clock()
local startedAt = os.time()
assert(finite(started) and integer(startedAt, 1, 9007199254740991), "analytics: clock is unavailable")

local registry = rawget(_G, "AnalyticsSessions")
if registry == nil then
    registry = {}
    rawset(_G, "AnalyticsSessions", registry)
end
assert(type(registry) == "table", "analytics: session registry is occupied")
local previous = registry[project]
if type(previous) == "table" and previous.job == game.JobId then
    if previous.active or (finite(previous.started) and started - previous.started < limits.restartCooldown) then
        return previous.client
    end
end

local counters = {
    recorded = 0,
    dropped = 0,
    suppressed = 0,
    httpCompleted = 0,
    uncertain = 0,
    rejected = 0,
    retries = 0,
    clockFaults = 0
}
local lastClock = started
local function monotonicNow()
    local value = clock()
    if not finite(value) or value < lastClock then
        counters.clockFaults = counters.clockFaults + 1
        return lastClock
    end
    lastClock = value
    return value
end

local userHash = sha256(string.format("%.0f", player.UserId))
local resumeKey = "analytics:v2:" .. project
local sessionId = http:GenerateGUID(false):gsub("%-", ""):lower()
assert(#sessionId == 32 and sessionId:match("^[0-9a-f]+$"), "analytics: invalid generated session ID")
local elapsedBeforeStart, resumed, resumeRejected, heartbeatAge = 0, false, false, 0
local checkpointRead, saved = pcall(teleport.GetTeleportSetting, teleport, resumeKey)

if checkpointRead and saved and settings.resumeTeleport then
    local valid = type(saved) == "table"
        and saved.schema == 3
        and saved.reporter_id == project
        and saved.version == settings.version
        and saved.user_hash == userHash
        and saved.universe_id == game.GameId
        and text(saved.origin_job, 128)
        and saved.origin_job ~= game.JobId
        and type(saved.session_id) == "string"
        and #saved.session_id == 32
        and saved.session_id:match("^[0-9a-f]+$")
        and integer(saved.uptime, 0, 86400)
        and integer(saved.heartbeat_age, 0, settings.heartbeatInterval)
        and integer(saved.saved_at, 1, startedAt)
        and startedAt - saved.saved_at <= limits.resumeLifetime
    if valid then
        sessionId = saved.session_id
        elapsedBeforeStart = math.min(86400, saved.uptime + startedAt - saved.saved_at)
        heartbeatAge = math.min(settings.heartbeatInterval, saved.heartbeat_age + startedAt - saved.saved_at)
        resumed = true
    else
        resumeRejected = true
    end
end
local function saveCheckpoint(value)
    return pcall(teleport.SetTeleportSetting, teleport, resumeKey, value)
end

saveCheckpoint(false)

local baseEvent = {
    reporter_id = project,
    session_id = sessionId,
    place_id = game.PlaceId,
    universe_id = game.GameId,
    version = settings.version,
    platform = settings.platform
}
if settings.includeUserId then baseEvent.user_id = userHash end
if text(player.LocaleId, 35) and player.LocaleId:match("^[A-Za-z0-9%-]+$") then
    baseEvent.locale = player.LocaleId
end
if type(identifyexecutor) == "function" then
    local identified, name, version = pcall(identifyexecutor)
    if identified then
        if text(name, 64) then baseEvent.executor = name end
        if text(version, 32) then baseEvent.executor_version = version end
    end
end

local queue, connections = {}, {}
local closed, paused, sending = false, false, false
local halted, lastResult, lastStatus, stopDeadline = false, nil, nil, nil
local resumeSaved = false
local lastHeartbeat, lastTeleport = started - heartbeatAge, -math.huge
local nextSendAt = started
local client = {}
local entry = {client = client, active = true, job = game.JobId, started = started}

local function uptime(now)
    return math.min(86400, math.floor(elapsedBeforeStart + math.max(0, (now or monotonicNow()) - started)))
end

local function emit(kind, category)
    if halted then return false end
    local now = monotonicNow()
    local event = copy(baseEvent)
    event.type = kind
    event.sent_at = math.floor(startedAt + math.max(0, now - started))
    event.uptime = uptime(now)
    if category then event.disconnect_type = category end
    if #queue >= limits.queueSize then
        local discard
        for i, pending in ipairs(queue) do
            if pending.payload.type == "heartbeat" then
                discard = i
                break
            end
        end
        counters.dropped = counters.dropped + 1
        if not discard and kind == "heartbeat" then
            return false
        end
        table.remove(queue, discard or 2)
    end
    queue[#queue + 1] = {payload = event, attempts = 0}
    counters.recorded = counters.recorded + 1
    if settings.printEvents then
        pcall(function() print(http:JSONEncode(event)) end)
    end
    return true
end

function client:events()
    local result = {}
    for i, item in ipairs(queue) do
        result[i] = copy(item.payload)
    end
    return result
end

function client:stats()
    local result = copy(counters)
    result.queued = #queue
    result.closed = closed
    result.paused = paused
    result.resumed = resumed
    result.resumeRejected = resumeRejected
    result.checkpointRead = checkpointRead
    result.resumeSaved = resumeSaved
    result.uptime = uptime()
    result.retryAfter = math.max(0, math.ceil(nextSendAt - monotonicNow()))
    result.mode = settings.autoSend and "http" or "local"
    result.sending = sending
    result.deliveryStopped = halted
    result.reason = lastResult
    result.lastStatus = lastStatus
    result.acceptance = "check_dashboard"
    return result
end

local function removePending(item)
    for i, pending in ipairs(queue) do
        if pending == item then
            table.remove(queue, i)
            break
        end
    end
end

local function post(event)
    local encoded, body = pcall(http.JSONEncode, http, event)
    if not encoded or type(body) ~= "string" or #body == 0 or #body > limits.bodyBytes then
        return "drop", "invalid_body"
    end
    local received, response = pcall(sendRequest, {
        Url = endpoint,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Content-Length"] = tostring(#body),
            ["X-Reporter-Id"] = project
        },
        Body = body,
        Timeout = limits.requestTimeout,
        Redirects = false
    })
    if not received or type(response) ~= "table" then return "uncertain", "request_failed" end
    local status = tonumber(response.StatusCode or response.status_code or response.Status)
    if not integer(status, 100, 599) then return "uncertain", "missing_status" end
    lastStatus = status
    if status >= 200 and status < 300 then return "complete", "http_completed" end
    if status == 401 or status == 403 or status == 404 or status == 410 then
        return "halt", "endpoint_rejected"
    end
    if status == 429 then
        local delay = 0
        if type(response.Headers) == "table" then
            for name, value in pairs(response.Headers) do
                if type(name) == "string" and name:lower() == "retry-after" then
                    local seconds = tonumber(value)
                    if finite(seconds) and seconds >= 0 then delay = math.min(3600, seconds) end
                end
            end
        end
        return "retry", "rate_limited", delay
    end
    if status == 408 or status >= 500 then return "uncertain", "ambiguous_response" end
    return "drop", "payload_rejected"
end

function client:flush()
    if halted then return false, lastResult end
    if type(sendRequest) ~= "function" then return false, "transport_required" end
    if sending then return false, "busy" end
    if #queue == 0 then return true, 0 end
    local now = monotonicNow()
    if now < nextSendAt then return false, "rate_limited" end
    sending = true
    nextSendAt = now + limits.sendGap
    local item = queue[1]
    item.attempts = item.attempts + 1
    local verdict, reason, delay = post(item.payload)
    lastResult = reason
    nextSendAt = monotonicNow() + limits.sendGap
    if verdict == "complete" then
        counters.httpCompleted = counters.httpCompleted + 1
        removePending(item)
    elseif verdict == "retry" and item.attempts < limits.attempts then
        counters.retries = counters.retries + 1
        nextSendAt = monotonicNow() + math.max(delay or 0, math.min(300, limits.sendGap * 2 ^ item.attempts))
    elseif verdict == "halt" then
        counters.rejected = counters.rejected + 1
        counters.dropped = counters.dropped + #queue
        halted = true
        queue = {}
        self:stop("other")
    else
        if verdict == "uncertain" then
            counters.uncertain = counters.uncertain + 1
        else
            counters.rejected = counters.rejected + 1
        end
        counters.dropped = counters.dropped + 1
        removePending(item)
    end
    sending = false
    return verdict == "complete", reason
end

local function disconnectListeners()
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    connections = {}
end

local categories = {kick = true, ban = true, teleport = true, shutdown = true, crash = true, leave = true, error = true, other = true}

function client:stop(category)
    if closed then return false, "already_stopped" end
    closed = true
    stopDeadline = monotonicNow() + limits.drainTimeout
    entry.active = false
    disconnectListeners()
    if not paused then
        saveCheckpoint(false)
        emit("disconnect", categories[category] and category or "other")
    end
    return true
end

local function heartbeat()
    if closed or paused then return end
    local now = monotonicNow()
    if now - lastHeartbeat < settings.heartbeatInterval then return end
    lastHeartbeat = now
    emit("heartbeat")
end

local function onTeleport(state)
    if closed then return end
    if state == Enum.TeleportState.InProgress then
        if paused then
            counters.suppressed = counters.suppressed + 1
            return
        end
        paused = true
        local now = monotonicNow()
        if now - lastTeleport >= 10 then
            lastTeleport = now
            emit("disconnect", "teleport")
        else
            counters.suppressed = counters.suppressed + 1
        end
        resumeSaved = saveCheckpoint({
            schema = 3,
            reporter_id = project,
            session_id = sessionId,
            version = settings.version,
            user_hash = userHash,
            universe_id = game.GameId,
            origin_job = game.JobId,
            uptime = uptime(),
            heartbeat_age = math.min(settings.heartbeatInterval, math.floor(math.max(0, monotonicNow() - lastHeartbeat))),
            saved_at = math.floor(startedAt + math.max(0, monotonicNow() - started))
        })
    elseif state == Enum.TeleportState.Failed and paused then
        paused = false
        resumeSaved = false
        saveCheckpoint(false)
        heartbeat()
    end
end

local connected = pcall(function()
    connections[#connections + 1] = run.Heartbeat:Connect(heartbeat)
    connections[#connections + 1] = player.OnTeleport:Connect(onTeleport)
    connections[#connections + 1] = players.PlayerRemoving:Connect(function(leaving)
        if leaving == player then client:stop("leave") end
    end)
end)
if not connected then
    disconnectListeners()
    error("analytics: event wiring failed")
end

registry[project] = entry
_G.AnalyticsClient = client
if not resumed then
    emit("execution")
else
    heartbeat()
end
if table.freeze then table.freeze(client) end
if settings.autoSend then
    task.spawn(function()
        while not halted do
            if closed and #queue == 0 then break end
            if closed and stopDeadline and monotonicNow() >= stopDeadline then
                counters.dropped = counters.dropped + #queue
                queue = {}
                lastResult = "drain_deadline"
                break
            end
            if #queue > 0 and monotonicNow() >= nextSendAt then client:flush() end
            task.wait(1)
        end
    end)
end
return client
