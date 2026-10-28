-- STRAWB3RRY HUB CODE SNIPER🍓🎯
local Config = {
    SammyUserId = 2678001507, -- Verified group owner: SpyderSammy.
    RequireSenderId = true,
    AcceptBareParts = true, -- Unlabelled Sammy messages; false = explicit "code:" / "part 1:" only.
    AcceptSentenceParts = true, -- Collect whole announcements using the native textbox cleanup.
    MinPartLength = 1,
    MaxCodeLength = 50, -- Native textbox limit after removing spaces/punctuation; longer parts stay visible.
    AutoSubmitBlacklist = {"FIRE", "Sammy", "FireDragon101", "taco"}, -- Skip complete guesses; keep every collected part.
    WebhookEnabled = false,
    WebhookUrl = "",
    WebhookDetail = "reward_and_code", -- Lowercase reward and code; no emojis.
    DefaultParts = 3,
    MaxParts = 12,
    BlacklistedMessages = {"use code", "code is", "use code.."}, -- Control announcements, never code parts.
    RiddleAnswerDebounce = 0.12, -- Briefly combine nearby riddle clues.
    RiddleDuplicateWindow = 0.35,
    RiddleClueGap = 8,
    RiddleRetryInterval = 0.05,
    RiddleRateRetryDelay = 1, -- Minimum seconds before retrying a definite cooldown/activation failure.
    RiddleTransientRetryLimit = 2, -- Bounded retries; unclear replies and timeouts are never replayed.
    RiddleUtcOffsetHours = 0, -- UTC: at 00:00 in UTC+5 the riddle date still belongs to the previous day.
    CacheSweepInterval = 2,
    ResponseTimeout = 18,
    SessionTimeout = 180,
    DuplicateWindow = 0, -- Optional text-only deduplication in seconds; 0 permits identical parts without IDs.
    MessageIdTTL = 600,
    AttemptTTL = 600,
    RedeemedTTL = 3600,
    CacheLimit = 256,
    -- Optional function(cleanText) -> part, partIndex. Source checks still apply.
    ExtractPart = nil,
    -- Optional function(errorText) -> "invalid", "rate", "used", "terminal", "unknown".
    ClassifyError = nil,
}

-- Quiet preference storage; dependencies are optional executor/JSON adapters.
function createSettingsStore(config, deps)
    config, deps = config or {}, deps or {}
    local path = "STRAWB3RRYAutoCodeRedeemer.settings.json"
    local maxBytes = 16 * 1024
    local lastCanonical
    local function finite(value)
        return type(value) == "number" and value == value and value > -math.huge and value < math.huge
    end
    local maxParts = finite(config.MaxParts) and math.max(1, math.floor(config.MaxParts)) or 12
    local defaultParts = finite(config.DefaultParts) and math.clamp(math.floor(config.DefaultParts), 1, maxParts) or math.min(3, maxParts)
    local function options(value)
        return type(value) == "table" and value or {}
    end
    local function bounded(value, minimum, maximum, fallback, integral)
        if not finite(value) then return fallback end
        if integral then value = math.floor(value) end
        return math.clamp(value, minimum, maximum)
    end
    local function sanitize(value)
        value = options(value)
        local riddle, admin = options(value.riddleSettings), options(value.adminAbuse)
        local clean = {
            version = 1,
            enabled = value.enabled == true,
            guess = value.guess == true,
            partsMode = value.partsMode == true,
            partsModeBeforeGuess = value.partsModeBeforeGuess == true,
            autoMode = value.autoMode == true,
            amount = bounded(value.amount, 1, maxParts, defaultParts, true),
            riddleEnabled = value.riddleEnabled == true,
            riddleBeforeAuto = value.riddleBeforeAuto == true,
            riddleSettings = {
                learnFacts = riddle.learnFacts == true,
                fallback = riddle.fallback == true,
                fallbackDelay = bounded(riddle.fallbackDelay, 0, 1, 0.55, false),
            },
            fpsBoost = value.fpsBoost == true,
            adminAbuse = {
                autoBuy = admin.autoBuy == true,
                antiRagdoll = admin.antiRagdoll == true,
                lockPosition = admin.lockPosition == true,
            },
        }
        if type(value.manualBeforeAuto) == "table" then
            local manual = value.manualBeforeAuto
            clean.manualBeforeAuto = {
                enabled = manual.enabled == true,
                guess = manual.guess == true,
                partsMode = manual.partsMode == true,
                partsModeBeforeGuess = manual.partsModeBeforeGuess == true,
            }
        end
        return clean
    end
    -- All data values are booleans/numbers; keys come only from the allowlist.
    -- This remains stable even if the supplied JSON encoder varies key order.
    local function canonical(value)
        if type(value) ~= "table" then return tostring(value) end
        local keys, result = {}, {}
        for key in pairs(value) do table.insert(keys, key) end
        table.sort(keys)
        for _, key in ipairs(keys) do
            table.insert(result, '"' .. key .. '":' .. canonical(value[key]))
        end
        return "{" .. table.concat(result, ",") .. "}"
    end
    local store = {path = path}
    function store:sanitize(value)
        return sanitize(value)
    end
    function store:load()
        lastCanonical = nil
        if type(deps.read) ~= "function" or type(deps.decode) ~= "function" then
            return nil, "unavailable"
        end
        local ok, raw = pcall(deps.read, path)
        if not ok then return nil, "read_failed" end
        if raw == nil or raw == "" then return nil, "missing" end
        if type(raw) ~= "string" or #raw > maxBytes then return nil, "invalid_file" end
        local decoded, value = pcall(deps.decode, raw)
        if not decoded or type(value) ~= "table" then return nil, "decode_failed" end
        if value.version ~= 1 then return nil, "unsupported_version" end
        local clean = sanitize(value)
        lastCanonical = canonical(clean)
        return clean
    end
    function store:save(value)
        if type(deps.write) ~= "function" or type(deps.encode) ~= "function" then
            return false, "unavailable"
        end
        local clean = sanitize(value)
        local normalized = canonical(clean)
        if normalized == lastCanonical then return true, "unchanged" end
        local ok, raw = pcall(deps.encode, clean)
        if not ok or type(raw) ~= "string" or #raw == 0 or #raw > maxBytes then
            return false, "encode_failed"
        end
        local written, result = pcall(deps.write, path, raw)
        if not written or result == false then return false, "write_failed" end
        lastCanonical = normalized
        return true, "saved"
    end
    return store
end

-- Bounded local history of trusted announcements; explicit replay uses the shared router.
function createRetypeReplay(config, deps)
    local replay = {alive = true, busy = false, records = {}, serial = 0, generation = 0}
    local maxRecords = math.clamp(math.floor(tonumber(config.RetypeBufferLimit) or 32), 1, 128)
    local ttl = math.max(1, tonumber(config.RetypeBufferTTL) or 180)
    local maxLength = math.max(1, math.floor(tonumber(config.RetypeMessageLimit) or 1024))
    local seen = {}
    local function clean(value)
        return (value:gsub("<[^>]*>", ""):gsub("&lt;", "<"):gsub("&gt;", ">")
            :gsub("&quot;", '"'):gsub("&apos;", "'"):gsub("&amp;", "&")):match("^%s*(.-)%s*$")
    end
    local function marker(value)
        local plain = clean(value):lower():gsub("[%.!,:;%s]+$", ""):gsub("%s+", " ")
        if plain:find("%f[%a]use%s+code%f[%A]") or plain:find("%f[%a]code%s+is%f[%A]") then return "code" end
        plain = plain:gsub("^the%s+riddle", "riddle")
        if plain:find("%f[%w_]riddle%f[^%w_]") then return "riddle" end
    end
    local function prune(now)
        local fresh = {}
        for _, record in ipairs(replay.records) do if now - record.at <= ttl then fresh[#fresh + 1] = record end end
        while #fresh > maxRecords do table.remove(fresh, 1) end
        replay.records = fresh
        seen = {}
        for _, record in ipairs(fresh) do if record.key then seen[record.key] = record end end
    end
    function replay:capture(message, duration, sound, location, sender, id, remove)
        if not self.alive or remove or location ~= "Top" or type(message) ~= "string"
            or tonumber(sender) ~= config.SammyUserId or #message == 0 or #message > maxLength then return false end
        local now, plain = deps.now(), clean(message)
        prune(now)
        local identity = id ~= nil and tostring(id) ~= "" and tostring(id) or nil
        local key = identity and (tostring(config.SammyUserId) .. ":" .. identity .. ":" .. plain) or nil
        if key and seen[key] then return false end
        -- Identical no-ID text may be two legitimate code parts; retain both.
        self.serial += 1
        local record = {message = message, duration = type(duration) == "number" and duration or nil,
            sender = config.SammyUserId, id = identity, key = key, plain = plain,
            at = now, serial = self.serial, marker = marker(message)}
        self.records[#self.records + 1] = record
        if key then seen[key] = record end
        prune(now)
        return true
    end
    function replay:selection()
        prune(deps.now())
        -- Reconstruct one recent session rather than mixing old codes and later riddles.
        local first = 1
        for index, record in ipairs(self.records) do
            if record.marker then first = index
            elseif index > 1 and record.at - self.records[index - 1].at > (config.RiddleClueGap or 8) then first = index end
        end
        local selected = {}
        for index = first, #self.records do selected[#selected + 1] = self.records[index] end
        return selected
    end
    function replay:run()
        if not self.alive or self.busy then return false, "Retype Is Already Running" end
        local blocked, reason = deps.blocked()
        if blocked then return false, reason or "A Game Request Is Still Pending" end
        if not deps.modeEnabled() then return false, "Choose A Code Or Riddle Mode First" end
        local selected = self:selection()
        if #selected == 0 then return false, "No Recent Sammy Announcements" end
        self.busy = true self.generation += 1
        -- beginBatch must suppress candidate submissions while the complete session is rebuilt.
        -- resetCollections must keep successful codes and the code-keyed uncertainty ledger.
        local ok, problem = pcall(function()
            deps.beginBatch()
            deps.resetCollections()
            for _, record in ipairs(selected) do
                if not self.alive then break end
                local syntheticId = "STRAWB3RRY-retype:" .. self.generation .. ":" .. record.serial
                deps.dispatch(record.message, record.duration, nil, "Top", record.sender, syntheticId, false)
            end
        end)
        self.busy = false
        -- endBatch releases the gate and wakes once; it must run after a routing exception too.
        deps.endBatch(ok)
        if not ok then return false, "Retype Failed · Please Try Again" end
        return true, "Retyped " .. #selected .. " Recent Announcements"
    end
    function replay:stop() self.alive = false self.records = {} seen = {} end
    return replay
end

local function createEngine(config, deps, saved)
    saved = saved or {}
    local e = {
        alive = true, enabled = saved.enabled == true, guess = saved.guess == true,
        partsMode = saved.partsMode == true, amount = tonumber(saved.amount) or config.DefaultParts,
        parts = {}, partLength = 0, partsRevision = 0,
        seenIds = {}, seenText = {}, attempts = saved.attempts or {},
        redeemed = saved.redeemed or {}, epoch = 0,
        pending = nil, scheduled = false, halted = false, status = "Auto Redeem Off",
        autoMode = saved.autoMode == true, autoWaiting = false, autoRiddle = false,
        partsModeBeforeGuess = saved.partsModeBeforeGuess,
        manualBeforeAuto = type(saved.manualBeforeAuto) == "table" and {
            enabled = saved.manualBeforeAuto.enabled == true,
            guess = saved.manualBeforeAuto.guess == true,
            partsMode = saved.manualBeforeAuto.partsMode == true,
            partsModeBeforeGuess = saved.manualBeforeAuto.partsModeBeforeGuess,
        } or nil,
    }
    e.amount = math.clamp(math.floor(e.amount), 1, config.MaxParts)
    if e.guess then e.partsMode = false end
    local pump, sessionJob, responseJob
    local timers, cacheSizes = {}, setmetatable({}, {__mode = "k"})
    local nextMaintenance = 0
    local function controlText(value)
        return value:lower():gsub("[%.!,:;%s]+$", ""):gsub("%s+", " ")
    end
    local blacklist = {}
    for _, value in ipairs(config.BlacklistedMessages or {}) do blacklist[controlText(value)] = true end
    local function guessKey(value)
        return value:gsub("[^A-Za-z0-9]", ""):lower()
    end
    local guessBlacklist = {}
    for _, value in ipairs(config.AutoSubmitBlacklist or {}) do
        if type(value) == "string" then
            local key = guessKey(value)
            if key ~= "" then guessBlacklist[key] = true end
        end
    end
    local function emit(message)
        if message then e.status = message end
        deps.changed(e)
    end
    local function trim(s) return s:match("^%s*(.-)%s*$") end
    local function clean(s)
        if not s:find("[<&]") then return trim(s) end
        return trim((s:gsub("<[^>]*>", ""):gsub("&lt;", "<"):gsub("&gt;", ">")
            :gsub("&quot;", '"'):gsub("&apos;", "'"):gsub("&amp;", "&")))
    end
    local function prune(cache, ttl, now)
        local count = 0
        for key, timestamp in pairs(cache) do
            if type(timestamp) ~= "number" or now - timestamp > ttl then cache[key] = nil
            else count += 1 end
        end
        while count > config.CacheLimit do
            local oldest, when = nil, math.huge
            for key, timestamp in pairs(cache) do
                if timestamp < when then oldest, when = key, timestamp end
            end
            if not oldest then break end
            cache[oldest], count = nil, count - 1
        end
        cacheSizes[cache] = count
    end
    local function maintain(now)
        if now < nextMaintenance then return end
        nextMaintenance = now + config.CacheSweepInterval
        prune(e.seenIds, config.MessageIdTTL, now)
        prune(e.seenText, config.DuplicateWindow, now)
        prune(e.attempts, config.AttemptTTL, now)
        prune(e.redeemed, config.RedeemedTTL, now)
    end
    local function cached(cache, key, ttl, now)
        local timestamp = cache[key]
        return type(timestamp) == "number" and now - timestamp <= ttl
    end
    local function remember(cache, key, ttl, now)
        if cacheSizes[cache] == nil then prune(cache, ttl, now) end
        if cache[key] == nil then cacheSizes[cache] += 1 end
        cache[key] = now
        if cacheSizes[cache] > config.CacheLimit then prune(cache, ttl, now) end
    end
    local function cancel(job)
        if not job then return end
        timers[job] = nil
        if deps.cancel then deps.cancel(job) end
    end
    local function later(seconds, fn)
        local version, job = e.epoch, nil
        local function run()
            if job then timers[job] = nil end
            if e.alive and e.epoch == version then fn() end
        end
        job = seconds <= 0 and deps.defer(run) or deps.after(seconds, run)
        if job then timers[job] = true end
        return job
    end
    local function cancelTimers()
        for job in pairs(timers) do cancel(job) end
        sessionJob, responseJob = nil, nil
    end
    local function reset(message, clearTextbox)
        e.epoch += 1
        cancelTimers()
        e.parts, e.partLength, e.pending, e.scheduled, e.halted = {}, 0, nil, false, false
        e.partsRevision += 1
        e.lastPartAt, e.lastResponse = nil, nil
        if clearTextbox then deps.clearTextbox() end
        emit(message)
    end
    local function armAutoMode()
        e.autoMode, e.autoWaiting, e.enabled = true, true, false
        e.autoRiddle = false
        reset("Waiting For Sammy's Code...", true)
    end
    local function manualControl(restore)
        if restore and e.autoMode and e.manualBeforeAuto then
            local previous = e.manualBeforeAuto
            e.enabled, e.guess, e.partsMode = previous.enabled, previous.guess, previous.partsMode
            e.partsModeBeforeGuess = previous.partsModeBeforeGuess
            if e.guess then e.partsMode = false end
        end
        e.autoMode, e.autoWaiting = false, false
        e.autoRiddle = false
        e.manualBeforeAuto = nil
    end
    local function classify(message)
        if config.ClassifyError then return config.ClassifyError(message) end
        local s = clean(message):lower()
        if s:find("please wait", 1, true) or s:find("cooldown", 1, true)
            or s:find("too fast", 1, true) or s:find("try again later", 1, true) then return "rate" end
        if s:find("invalid code", 1, true) or s:find("code is invalid", 1, true) then return "invalid" end
        if s:find("already", 1, true) and s:find("redeem", 1, true) then return "used" end
        if s:find("expired", 1, true) or s:find("sold out", 1, true) then return "terminal" end
        return "unknown"
    end
    local function candidate()
        local count = e.guess and #e.parts or (e.partsMode and e.amount or 1)
        if count == 0 or #e.parts < count then return nil end
        return table.concat(e.parts, "", 1, count), count
    end
    local function lengthStatus(length)
        return "Code Too Long · " .. length .. " / " .. config.MaxCodeLength .. " Characters"
    end
    local function queue(seconds)
        if e.scheduled then return end
        e.scheduled = true
        later(seconds, function() e.scheduled = false pump() end)
    end
    local function discard(count)
        local remaining, length = {}, 0
        for i = count + 1, #e.parts do
            remaining[#remaining + 1] = e.parts[i]
            length += #e.parts[i]
        end
        e.parts, e.partLength = remaining, length
        e.partsRevision += 1
        if #remaining == 0 then
            cancel(sessionJob) sessionJob = nil
        end
    end
    local function completedStatus(message)
        emit(message)
        later(1.4, function()
            if not e.pending and #e.parts == 0 and e.status == message then
                emit(e.enabled and "Waiting For Announcement..." or "Auto Redeem Off")
            end
        end)
    end
    local function finish(request, kind, message)
        if not e.alive then return end
        local now = deps.now()
        -- A late result may be remembered, but must never consume a newer collection.
        if kind == "success" or kind == "used" then
            remember(e.redeemed, request.code, config.RedeemedTTL, now)
        end
        if e.pending ~= request or request.epoch ~= e.epoch then return end
        cancel(responseJob) responseJob = nil
        e.lastResponse = message
        if kind == "timeout" then
            -- Keep the request tracked: timeout cannot cancel an InvokeServer call.
            request.timedOut = true
            e.halted = true
            emit("Game Response Delayed · Request Still Pending")
            return
        end
        e.pending, e.halted = nil, false
        if kind == "rate" then
            -- The game's wait message is not a useful collection signal.
            -- Keep the parts, skip this exact attempt, and accept the next part.
            emit("Waiting For Next Part...")
            if #e.parts > request.count then pump() end
            return
        end
        if kind == "unknown" then
            -- An unclear reply may have reached the server. Keep this attempt
            -- visible until the player explicitly clears it.
            e.halted = true
            emit("Game reply unclear. Tap Clear")
            return
        end
        if e.autoMode and (kind == "success" or kind == "terminal") then
            armAutoMode()
            e.lastResponse = message
            return
        end
        if e.guess and kind == "used" then
            emit("Already Redeemed · Waiting For Next Part")
            if #e.parts > request.count then pump() end
            return
        end
        if kind == "success" or kind == "used" then
            discard(request.count)
            deps.clearTextbox()
            completedStatus(kind == "success" and "Code Redeemed" or "Already Redeemed")
            pump()
        elseif e.guess and kind ~= "terminal" then
            emit("Waiting For Next Part...")
            if #e.parts > request.count then pump() end
        elseif kind == "invalid" or kind == "terminal" then
            discard(request.count)
            deps.clearTextbox()
            completedStatus(kind == "invalid" and "Invalid Code"
                or (message:lower():find("sold out", 1, true) and "Code Sold Out" or "Code Expired"))
            pump()
        end
    end
    pump = function()
        if not e.alive or not e.enabled or e.pending or e.halted or e.autoRiddle then return end
        local code, count = candidate()
        if not code then return end
        -- A skipped guess stays collected so the next part can extend it.
        -- Check before history: an old redeemed prefix must not consume it.
        if e.guess and guessBlacklist[guessKey(code)] then
            emit("Guess Skipped · Waiting For Next Part")
            return
        end
        -- The native textbox strips formatting and truncates at 50 characters.
        -- Keep the complete collection visible, but never submit a clipped code.
        if #code > config.MaxCodeLength then emit(lengthStatus(#code)) return end
        local now = deps.now()
        maintain(now)
        if cached(e.redeemed, code, config.RedeemedTTL, now) then
            if e.guess then
                emit("Already Redeemed · Waiting For Next Part")
                return
            end
            if e.autoMode then armAutoMode() return end
            discard(count)
            completedStatus("Already Redeemed")
            if #e.parts > 0 then queue(0) end
            return
        end
        if type(deps.skipReplayCode) == "function" and deps.skipReplayCode(code) then
            emit(e.guess and "Guess Skipped · Waiting For Next Part" or "Already Checked")
            return
        end
        if cached(e.attempts, code, config.AttemptTTL, now) then
            if e.guess then emit("Waiting For Next Part...")
            else
                discard(count)
                deps.clearTextbox()
                completedStatus("Already Checked")
                if #e.parts > 0 then queue(0) end
            end
            return
        end
        local ready, reason = deps.ready()
        if not ready then emit(reason or "Waiting For The Code Box") return end
        local request = {code = code, count = count, epoch = e.epoch}
        e.pending = request
        e.lastSubmitted, e.submissions = code, (e.submissions or 0) + 1
        e.lastLatency = math.max(0, now - (e.lastPartAt or now))
        remember(e.attempts, code, config.AttemptTTL, now)
        emit("Redeeming Code...")
        responseJob = later(config.ResponseTimeout, function()
            if e.pending == request then finish(request, "timeout", "") end
        end)
        local ok = pcall(deps.submit, code, function(success, message)
            finish(request, success and "success" or classify(message or ""), message or "")
        end)
        if not ok then finish(request, "unknown", "Submit Adapter Failed") end
    end
    function e:receive(message, duration, sound, location, senderId, messageId, remove)
        if not self.alive or self.halted then return false end
        if not self.enabled and not (self.autoMode and self.autoWaiting) then return false end
        if location ~= "Top" or remove or type(message) ~= "string" then return false end
        local sender = tonumber(senderId)
        if config.RequireSenderId and sender ~= config.SammyUserId then return false end
        if senderId ~= nil and sender ~= config.SammyUserId then return false end
        local plain = clean(message)
        local now = deps.now()
        maintain(now)
        local idKey = messageId ~= nil and (tostring(senderId) .. ":" .. tostring(messageId) .. ":" .. plain) or nil
        if idKey and cached(self.seenIds, idKey, config.MessageIdTTL, now) then return false end
        local part, index
        local lower = plain:lower()
        local riddleMarker = lower:find("%f[%w_]riddle%f[^%w_]") ~= nil
        local a, b = lower:find("%f[%w_]use%s+code%f[^%w_]")
        if not a then a, b = lower:find("%f[%w_]code%s+is%f[^%w_]") end
        if riddleMarker then
            -- Setup chatter belongs to the solver; never sanitize it into a code part.
            if self.autoMode and not self:startRiddle() then return false end
            if idKey then remember(self.seenIds, idKey, config.MessageIdTTL, now) end
            return true
        end
        if self.autoMode and (self.autoWaiting or self.autoRiddle) then
            if not a or self.pending then return false end
            self.autoRiddle, self.autoWaiting = false, false
            self.enabled, self.guess, self.partsMode = true, true, false
            self.partsModeBeforeGuess = nil
            -- A new trusted code announcement starts a new attempt session.
            -- Retain both submitted-attempt and redeemed history: no implicit replay.
            reset("Waiting For Code Parts...", true)
        elseif self.autoRiddle then
            return false
        end
        if a then
            -- Only an explicit separator makes a marker's suffix a code payload.
            -- A trigger such as "Use Code Now" is control text, not a code part.
            part = plain:sub(b + 1):match("^%s*[:=]%s*(.+)$")
            if not part then
                if idKey then remember(self.seenIds, idKey, config.MessageIdTTL, now) end
                return true
            end
        end
        if not part and blacklist[controlText(plain)] then return false end
        if not part and config.ExtractPart then
            local ok, a, b = pcall(config.ExtractPart, plain)
            if not ok then emit("Part Filter Error · Check Configuration") return false end
            part, index = a, b
        elseif not part then
            -- Bare parts are the fast path; preserve their original case.
            if config.AcceptBareParts and plain:match("^[A-Za-z0-9]+$") then part = plain
            else
                local n, value = plain:match("^[Pp][Aa][Rr][Tt]%s*(%d+)%s*:%s*(.+)$")
                if n then part, index = value, tonumber(n) end
                part = part or plain:match("^[Cc][Oo][Dd][Ee]%s*:%s*(.+)$")
                if not part and config.AcceptBareParts and config.AcceptSentenceParts ~= false then part = plain end
            end
        end
        if type(part) ~= "string" then return false end
        -- Match CodesController's textbox cleanup without its destructive truncation.
        -- Case is significant; spaces, newlines and punctuation are formatting.
        if not part:match("^[A-Za-z0-9]+$") then part = part:gsub("[^A-Za-z0-9]", "") end
        if #part < config.MinPartLength then return false end
        if index ~= nil and (type(index) ~= "number" or index % 1 ~= 0 or index < 1) then return false end
        local textKey = tostring(senderId) .. ":" .. plain
        -- Text can legitimately repeat in different code parts. Only a matching
        -- message identity proves redelivery; text-only filtering is optional.
        if not idKey and config.DuplicateWindow > 0
            and cached(self.seenText, textKey, config.DuplicateWindow, now) then return false end
        local expectedIndex = self.partsMode and not self.guess and (#self.parts % self.amount) + 1 or #self.parts + 1
        if index and index ~= expectedIndex then emit("Part Order Changed · Press Clear") return false end
        if #self.parts >= config.MaxParts then
            self.halted = true emit("Too Many Parts · Press Clear") return false
        end
        if idKey then remember(self.seenIds, idKey, config.MessageIdTTL, now) end
        remember(self.seenText, textKey, config.DuplicateWindow, now)
        self.parts[#self.parts + 1] = part
        self.partLength += #part
        self.partsRevision += 1
        self.lastPartAt = now
        if not self.pending and self.partLength > config.MaxCodeLength
            and (self.guess or not self.partsMode or #self.parts <= self.amount) then
            emit(lengthStatus(self.partLength))
        else emit("Part " .. #self.parts .. " Detected") end
        cancel(sessionJob) sessionJob = nil
        if not self.guess and (not self.partsMode or #self.parts >= self.amount) then
            pump()
        else
            queue(0)
        end
        -- Start the idle timer after the immediate submit attempt. Allocating a
        -- delayed task should not hold up the game's Confirm button.
        if #self.parts > 0 then
            sessionJob = later(config.SessionTimeout, function()
                if self.pending then return end
                if #self.parts > 0 then
                    if self.autoMode then armAutoMode() else reset("Waiting For Announcement...", true) end
                end
            end)
        end
        return true
    end
    function e:clear(retryFailed)
        if retryFailed then
            self.attempts, self.seenIds, self.seenText = {}, {}, {}
            nextMaintenance = 0
        end
        if self.autoMode then armAutoMode()
        else reset(self.enabled and "Waiting For Announcement..." or "Auto Redeem Off", true) end
    end
    function e:setAutoMode(value)
        if value == true then
            if not self.autoMode then
                self.manualBeforeAuto = {enabled = self.enabled, guess = self.guess,
                    partsMode = self.partsMode, partsModeBeforeGuess = self.partsModeBeforeGuess}
            end
            armAutoMode()
        else
            manualControl(true)
            self:clear()
        end
    end
    function e:startRiddle()
        if not self.autoMode or self.pending or self.halted then return false end
        if self.autoRiddle then return true end
        self.autoWaiting, self.autoRiddle, self.enabled = false, true, true
        self.guess, self.partsMode, self.partsModeBeforeGuess = true, false, nil
        reset("Waiting For Riddle Questions...", true)
        return true
    end
    function e:finishRiddle(result)
        if not self.autoMode or not self.autoRiddle then return end
        if result == "success" or result == "unavailable" or result == "used" then armAutoMode() end
    end
    function e:setEnabled(value)
        manualControl(true)
        self.enabled = value == true
        self:clear()
    end
    function e:setGuess(value)
        if self.autoMode then manualControl(true) end
        local nextGuess = value == true
        if nextGuess and not self.guess then
            self.partsModeBeforeGuess = self.partsMode
            self.partsMode = false
        elseif not nextGuess and self.guess then
            self.partsMode = self.partsModeBeforeGuess == true
        end
        self.guess = nextGuess
        self:clear()
    end
    function e:setPartsMode(value)
        if self.autoMode then manualControl(true) end
        self.partsMode = value == true
        if self.partsMode then self.guess = false end
        self.partsModeBeforeGuess = nil
        self:clear()
    end
    function e:setAmount(value)
        self.amount = math.clamp(math.floor(value), 1, config.MaxParts)
        self:clear()
    end
    function e:wake() pump() end
    function e:stop()
        self.alive = false self.epoch += 1 self.enabled = false
        cancelTimers()
    end
    function e:snapshot()
        return {enabled = self.enabled, guess = self.guess, partsMode = self.partsMode, amount = self.amount,
            autoMode = self.autoMode, partsModeBeforeGuess = self.partsModeBeforeGuess,
            manualBeforeAuto = self.manualBeforeAuto,
            redeemed = self.redeemed, attempts = self.attempts}
    end
    if e.autoMode then
        -- Settings may persist; pending work and partial collections never do.
        if not e.manualBeforeAuto then
            e.manualBeforeAuto = {enabled = false, guess = false, partsMode = false}
        end
        armAutoMode()
    elseif e.enabled then
        e.status = "Waiting For Announcement..."
    end
    return e
end

local RiddleDatabase = {
    ["1 1 brainrot"] = "155",
    ["1 1 exist"] = "155",
    ["1 1s brainrot"] = "155",
    ["1 1s exist"] = "155",
    ["1 of 1"] = "1of1",
    ["1 of 1 brainrots"] = "155",
    ["1 of 1 brainrots exist"] = "155",
    ["1 of 1 exist"] = "155",
    ["1 of 1s brainrots"] = "155",
    ["1 of 1s exist"] = "155",
    ["1 speed keyboard escape"] = "1speedkeyboardescape",
    ["1 year event trait"] = "1year",
    ["1 year event trait date"] = "may2026",
    ["1 year event trait month"] = "may",
    ["1 year event trait release"] = "may2026",
    ["1 year event trait release date"] = "may2026",
    ["1 year event trait release month"] = "may",
    ["1 year event trait release year"] = "2026",
    ["1 year event trait year"] = "2026",
    ["1 year trait"] = "1year",
    ["1 year trait date"] = "may2026",
    ["1 year trait month"] = "may",
    ["1 year trait release"] = "may2026",
    ["1 year trait release date"] = "may2026",
    ["1 year trait release month"] = "may",
    ["1 year trait release year"] = "2026",
    ["1 year trait year"] = "2026",
    ["10 billion trait"] = "10b",
    ["10 billion trait date"] = "june2025",
    ["10 billion trait month"] = "june",
    ["10 billion trait release"] = "june2025",
    ["10 billion trait release date"] = "june2025",
    ["10 billion trait release month"] = "june",
    ["10 billion trait release year"] = "2025",
    ["10 billion trait year"] = "2025",
    ["10 billion visits trait"] = "10b",
    ["10 billion visits trait date"] = "june2025",
    ["10 billion visits trait month"] = "june",
    ["10 billion visits trait release"] = "june2025",
    ["10 billion visits trait release date"] = "june2025",
    ["10 billion visits trait release month"] = "june",
    ["10 billion visits trait release year"] = "2025",
    ["10 billion visits trait year"] = "2025",
    ["10b"] = "10b",
    ["10b trait"] = "10b",
    ["10b trait date"] = "june2025",
    ["10b trait month"] = "june",
    ["10b trait release"] = "june2025",
    ["10b trait release date"] = "june2025",
    ["10b trait release month"] = "june",
    ["10b trait release year"] = "2025",
    ["10b trait year"] = "2025",
    ["111"] = "111",
    ["155"] = "155",
    ["1of1"] = "1of1",
    ["1of1 brainrot"] = "155",
    ["1of1 brainrots"] = "155",
    ["1of1 brainrots exist"] = "155",
    ["1of1 exist"] = "155",
    ["1of1s brainrot"] = "155",
    ["1of1s brainrots"] = "155",
    ["1of1s exist"] = "155",
    ["1speedkeyboardescape"] = "1speedkeyboardescape",
    ["1st bee"] = "beeloco",
    ["1st bee brainrot"] = "beeloco",
    ["1st bee brainrot in game"] = "beeloco",
    ["1st bee brainrot in sab"] = "beeloco",
    ["1st bee brainrot in the"] = "beeloco",
    ["1st bee brainrot in the game"] = "beeloco",
    ["1st bee in game"] = "beeloco",
    ["1st bee in sab"] = "beeloco",
    ["1st bee in the game"] = "beeloco",
    ["1st bee lucky"] = "beeloco",
    ["1st bee lucky block"] = "beeloco",
    ["1st bee lucky block brainrot"] = "beeloco",
    ["1st bee shop"] = "beeloco",
    ["1st bee shop brainrot"] = "beeloco",
    ["1st bee update"] = "beeloco",
    ["1st bee update brainrot"] = "beeloco",
    ["1st best taco merchant"] = "sammynitruckini",
    ["1st brainrot"] = "noobinipizzanini",
    ["1st brainrot god"] = "tralalerotralala",
    ["1st brainrot that got removed"] = "tungtungtungsahur",
    ["1st brainrot that was reworked"] = "sammynispyderini",
    ["1st craft"] = "september2025",
    ["1st craft date"] = "september2025",
    ["1st craft day"] = "6",
    ["1st craft machine"] = "september2025",
    ["1st craft machine date"] = "september2025",
    ["1st craft machine day"] = "6",
    ["1st craft machine month"] = "september",
    ["1st craft machine release"] = "september2025",
    ["1st craft machine release date"] = "september2025",
    ["1st craft machine release day"] = "6",
    ["1st craft machine release month"] = "september",
    ["1st craft machine release year"] = "2025",
    ["1st craft machine year"] = "2025",
    ["1st craft month"] = "september",
    ["1st craft release"] = "september2025",
    ["1st craft release date"] = "september2025",
    ["1st craft release day"] = "6",
    ["1st craft release month"] = "september",
    ["1st craft release year"] = "2025",
    ["1st craft year"] = "2025",
    ["1st fuse"] = "lafusemachine",
    ["1st fuse date"] = "august2025",
    ["1st fuse day"] = "1",
    ["1st fuse machine"] = "lafusemachine",
    ["1st fuse machine date"] = "august2025",
    ["1st fuse machine day"] = "1",
    ["1st fuse machine month"] = "august",
    ["1st fuse machine release"] = "august2025",
    ["1st fuse machine release date"] = "august2025",
    ["1st fuse machine release day"] = "1",
    ["1st fuse machine release month"] = "august",
    ["1st fuse machine release year"] = "2025",
    ["1st fuse machine year"] = "2025",
    ["1st fuse month"] = "august",
    ["1st fuse release"] = "august2025",
    ["1st fuse release date"] = "august2025",
    ["1st fuse release day"] = "1",
    ["1st fuse release month"] = "august",
    ["1st fuse release year"] = "2025",
    ["1st fuse year"] = "2025",
    ["1st gear"] = "bat",
    ["1st god"] = "tralalerotralala",
    ["1st item"] = "bat",
    ["1st lucky block"] = "july2025",
    ["1st lucky block date"] = "july2025",
    ["1st lucky block day"] = "12",
    ["1st lucky block month"] = "july",
    ["1st lucky block release"] = "july2025",
    ["1st lucky block release date"] = "july2025",
    ["1st lucky block release day"] = "12",
    ["1st lucky block release month"] = "july",
    ["1st lucky block release year"] = "2025",
    ["1st lucky block year"] = "2025",
    ["1st machine"] = "rainbowmachine",
    ["1st machine added"] = "rainbowmachine",
    ["1st machine added date"] = "june2025",
    ["1st machine added day"] = "21",
    ["1st machine added month"] = "june",
    ["1st machine added release"] = "june2025",
    ["1st machine added release date"] = "june2025",
    ["1st machine added release day"] = "21",
    ["1st machine added release month"] = "june",
    ["1st machine added release year"] = "2025",
    ["1st machine added year"] = "2025",
    ["1st machine date"] = "june2025",
    ["1st machine day"] = "21",
    ["1st machine game"] = "rainbowmachine",
    ["1st machine month"] = "june",
    ["1st machine release"] = "june2025",
    ["1st machine release date"] = "june2025",
    ["1st machine release day"] = "21",
    ["1st machine release month"] = "june",
    ["1st machine release year"] = "2025",
    ["1st machine sab"] = "rainbowmachine",
    ["1st machine year"] = "2025",
    ["1st og"] = "strawberryelephant",
    ["1st og brainrot"] = "strawberryelephant",
    ["1st og brainrot in game"] = "strawberryelephant",
    ["1st og brainrot in the game"] = "strawberryelephant",
    ["1st og in game"] = "strawberryelephant",
    ["1st og in the game"] = "strawberryelephant",
    ["1st removed brainrot"] = "tungtungtungsahur",
    ["1st reworked brainrot"] = "sammynispyderini",
    ["1st secret"] = "lavaccasaturnosaturnita",
    ["1st secret brainrot"] = "lavaccasaturnosaturnita",
    ["1st secret in sab"] = "lavaccasaturnosaturnita",
    ["1st secret in sub"] = "lavaccasaturnosaturnita",
    ["1st secret in the game"] = "lavaccasaturnosaturnita",
    ["1st snake"] = "hydraserpent",
    ["1st snake added"] = "hydraserpent",
    ["1st snake brainrot"] = "hydraserpent",
    ["1st snake brainrot added"] = "hydraserpent",
    ["1st snake brainrot ever added"] = "hydraserpent",
    ["1st snake brainrot in game"] = "hydraserpent",
    ["1st snake brainrot in sab"] = "hydraserpent",
    ["1st snake brainrot in the game"] = "hydraserpent",
    ["1st snake brainrot that was added"] = "hydraserpent",
    ["1st snake brainrot that was ever added"] = "hydraserpent",
    ["1st snake ever added"] = "hydraserpent",
    ["1st snake in game"] = "hydraserpent",
    ["1st snake in sab"] = "hydraserpent",
    ["1st snake in the game"] = "hydraserpent",
    ["1st snake that was added"] = "hydraserpent",
    ["1st snake that was ever added"] = "hydraserpent",
    ["1st taco"] = "tipitopitaco",
    ["1st taco brainrot"] = "tipitopitaco",
    ["1st taco in the game"] = "tipitopitaco",
    ["1st taco merchant"] = "sammynitruckini",
    ["1year"] = "1year",
    ["2 brainrots deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots remove"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots removed"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["2 brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["2 deleted brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["2 removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["2013"] = "2013",
    ["2013 release year"] = "2013",
    ["2013 year"] = "2013",
    ["2026"] = "2026",
    ["2026 trait"] = "2026",
    ["2026 trait date"] = "december2025",
    ["2026 trait month"] = "december",
    ["2026 trait release"] = "december2025",
    ["2026 trait release date"] = "december2025",
    ["2026 trait release month"] = "december",
    ["2026 trait release year"] = "2025",
    ["2026 trait year"] = "2025",
    ["222"] = "222",
    ["26"] = "26",
    ["26 trait"] = "2026",
    ["26 trait date"] = "december2025",
    ["26 trait month"] = "december",
    ["26 trait release"] = "december2025",
    ["26 trait release date"] = "december2025",
    ["26 trait release month"] = "december",
    ["26 trait release year"] = "2025",
    ["26 trait year"] = "2025",
    ["2nd best"] = "strawberryelephant",
    ["2nd best brainrot"] = "strawberryelephant",
    ["2nd best brainrot in game"] = "strawberryelephant",
    ["2nd best brainrot in the game"] = "strawberryelephant",
    ["2nd best taco merchant"] = "nachorilla",
    ["2nd brainrot that got removed"] = "crocidilopenisini",
    ["2nd brainrot that was reworked"] = "unclitosamito",
    ["2nd fuse"] = "witchfuse",
    ["2nd fuse date"] = "october2025",
    ["2nd fuse day"] = "11",
    ["2nd fuse machine"] = "witchfuse",
    ["2nd fuse machine date"] = "october2025",
    ["2nd fuse machine day"] = "11",
    ["2nd fuse machine month"] = "october",
    ["2nd fuse machine release"] = "october2025",
    ["2nd fuse machine release date"] = "october2025",
    ["2nd fuse machine release day"] = "11",
    ["2nd fuse machine release month"] = "october",
    ["2nd fuse machine release year"] = "2025",
    ["2nd fuse machine year"] = "2025",
    ["2nd fuse month"] = "october",
    ["2nd fuse release"] = "october2025",
    ["2nd fuse release date"] = "october2025",
    ["2nd fuse release day"] = "11",
    ["2nd fuse release month"] = "october",
    ["2nd fuse release year"] = "2025",
    ["2nd fuse year"] = "2025",
    ["2nd name"] = "brakta",
    ["2nd name of sammy"] = "brakta",
    ["2nd name of sammys"] = "brakta",
    ["2nd og"] = "meowl",
    ["2nd og added"] = "meowl",
    ["2nd og added in sab"] = "meowl",
    ["2nd og added to sab"] = "meowl",
    ["2nd og brainrot"] = "meowl",
    ["2nd og in sab"] = "meowl",
    ["2nd og in the game"] = "meowl",
    ["2nd removed brainrot"] = "crocidilopenisini",
    ["2nd reworked brainrot"] = "unclitosamito",
    ["2nd taco merchant"] = "nachorilla",
    ["3 brainrots rework"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 brainrots reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["3 headed"] = "hydraserpent",
    ["3 headed brainrot"] = "hydraserpent",
    ["3 headed brainrot added in todays update"] = "hydraserpent",
    ["3 headed brainrot added today"] = "hydraserpent",
    ["3 headed snake"] = "hydraserpent",
    ["3 headed snake brainrot"] = "hydraserpent",
    ["3 reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["333"] = "333",
    ["3rd best taco merchant"] = "tacoturbotacorito",
    ["3rd brainrot that was reworked"] = "gattatinonyanino",
    ["3rd fuse"] = "santafuse",
    ["3rd fuse date"] = "december2025",
    ["3rd fuse day"] = "6",
    ["3rd fuse machine"] = "santafuse",
    ["3rd fuse machine date"] = "december2025",
    ["3rd fuse machine day"] = "6",
    ["3rd fuse machine month"] = "december",
    ["3rd fuse machine release"] = "december2025",
    ["3rd fuse machine release date"] = "december2025",
    ["3rd fuse machine release day"] = "6",
    ["3rd fuse machine release month"] = "december",
    ["3rd fuse machine release year"] = "2025",
    ["3rd fuse machine year"] = "2025",
    ["3rd fuse month"] = "december",
    ["3rd fuse release"] = "december2025",
    ["3rd fuse release date"] = "december2025",
    ["3rd fuse release day"] = "6",
    ["3rd fuse release month"] = "december",
    ["3rd fuse release year"] = "2025",
    ["3rd fuse year"] = "2025",
    ["3rd og"] = "skibiditoilet",
    ["3rd og brainrot"] = "skibiditoilet",
    ["3rd reworked brainrot"] = "gattatinonyanino",
    ["3rd taco merchant"] = "tacoturbotacorito",
    ["444"] = "444",
    ["4th 3 headed"] = "hydraserpent",
    ["4th 3 headed brainrot"] = "hydraserpent",
    ["4th 3 headed brainrot added"] = "hydraserpent",
    ["4th 3 headed brainrot in the game"] = "hydraserpent",
    ["4th best taco merchant"] = "burritobat",
    ["4th fuse"] = "divinefuse",
    ["4th fuse date"] = "march2026",
    ["4th fuse day"] = "7",
    ["4th fuse machine"] = "divinefuse",
    ["4th fuse machine date"] = "march2026",
    ["4th fuse machine day"] = "7",
    ["4th fuse machine month"] = "march",
    ["4th fuse machine release"] = "march2026",
    ["4th fuse machine release date"] = "march2026",
    ["4th fuse machine release day"] = "7",
    ["4th fuse machine release month"] = "march",
    ["4th fuse machine release year"] = "2026",
    ["4th fuse machine year"] = "2026",
    ["4th fuse month"] = "march",
    ["4th fuse release"] = "march2026",
    ["4th fuse release date"] = "march2026",
    ["4th fuse release day"] = "7",
    ["4th fuse release month"] = "march",
    ["4th fuse release year"] = "2026",
    ["4th fuse year"] = "2026",
    ["4th headed"] = "hydraserpent",
    ["4th of july trait"] = "firework",
    ["4th of july trait date"] = "july2025",
    ["4th of july trait day"] = "4",
    ["4th of july trait month"] = "july",
    ["4th of july trait release"] = "july2025",
    ["4th of july trait release date"] = "july2025",
    ["4th of july trait release day"] = "4",
    ["4th of july trait release month"] = "july",
    ["4th of july trait release year"] = "2025",
    ["4th of july trait year"] = "2025",
    ["4th og"] = "headlesshorseman",
    ["4th og brainrot"] = "headlesshorseman",
    ["4th taco merchant"] = "burritobat",
    ["4th three headed"] = "hydraserpent",
    ["4th three headed brainrot"] = "hydraserpent",
    ["4th three headed brainrot added"] = "hydraserpent",
    ["4th three headed brainrot in the game"] = "hydraserpent",
    ["555"] = "555",
    ["57 5"] = "candinifluffini",
    ["5th fuse"] = "summerfuse",
    ["5th fuse date"] = "may2026",
    ["5th fuse day"] = "23",
    ["5th fuse machine"] = "summerfuse",
    ["5th fuse machine date"] = "may2026",
    ["5th fuse machine day"] = "23",
    ["5th fuse machine month"] = "may",
    ["5th fuse machine release"] = "may2026",
    ["5th fuse machine release date"] = "may2026",
    ["5th fuse machine release day"] = "23",
    ["5th fuse machine release month"] = "may",
    ["5th fuse machine release year"] = "2026",
    ["5th fuse machine year"] = "2026",
    ["5th fuse month"] = "may",
    ["5th fuse release"] = "may2026",
    ["5th fuse release date"] = "may2026",
    ["5th fuse release day"] = "23",
    ["5th fuse release month"] = "may",
    ["5th fuse release year"] = "2026",
    ["5th fuse year"] = "2026",
    ["5th og"] = "johnpork",
    ["5th og brainrot"] = "johnpork",
    ["666"] = "666",
    ["67"] = "67",
    ["6th brainrot based off a mythical creature"] = "hydraserpent",
    ["6th brainrot based off mythical creature"] = "hydraserpent",
    ["6th brainrot based off of a mythical creature"] = "hydraserpent",
    ["6th brainrot based on a mythical creature"] = "hydraserpent",
    ["6th brainrot based on mythical creature"] = "hydraserpent",
    ["6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["6th brainrot to be based off of a mythical creature"] = "hydraserpent",
    ["6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["6th brainrot to be based on mythical creature"] = "hydraserpent",
    ["6th mythical"] = "hydraserpent",
    ["6th mythical brainrot"] = "hydraserpent",
    ["6th mythical creature"] = "hydraserpent",
    ["6th mythical creature brainrot"] = "hydraserpent",
    ["6th og"] = "spyderelephant",
    ["6th og brainrot"] = "spyderelephant",
    ["76"] = "76",
    ["777"] = "777",
    ["888"] = "888",
    ["95 income"] = "lafusemachine",
    ["95m"] = "lafusemachine",
    ["95m sec"] = "lafusemachine",
    ["999"] = "999",
    ["added in todays admin abuse"] = "lupaandlipa",
    ["added in todays update"] = "hydraserpent",
    ["added last saturday"] = "orchidox",
    ["added last week"] = "orchidox",
    ["added today"] = "hydraserpent",
    ["admin abuse"] = "jandel",
    ["admin abuse brainrot"] = "lupaandlipa",
    ["admin abuse trait"] = "sleepy",
    ["admin abuse war"] = "sleepy",
    ["admin abuse war trait"] = "sleepy",
    ["admin machine"] = "november2025",
    ["admin machine date"] = "november2025",
    ["admin machine day"] = "29",
    ["admin machine month"] = "november",
    ["admin machine release"] = "november2025",
    ["admin machine release date"] = "november2025",
    ["admin machine release day"] = "29",
    ["admin machine release month"] = "november",
    ["admin machine release year"] = "2025",
    ["admin machine year"] = "2025",
    ["age"] = "24",
    ["all brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["all brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["all brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["all brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["all removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["all reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["always put code"] = "67",
    ["always put codes"] = "67",
    ["am i competitive at"] = "valorant",
    ["america"] = "usa",
    ["anniversary"] = "anniversary",
    ["anniversary trait"] = "1year",
    ["anniversary trait date"] = "may2026",
    ["anniversary trait month"] = "may",
    ["anniversary trait release"] = "may2026",
    ["anniversary trait release date"] = "may2026",
    ["anniversary trait release month"] = "may",
    ["anniversary trait release year"] = "2026",
    ["anniversary trait year"] = "2026",
    ["antonio"] = "green",
    ["antonio color"] = "green",
    ["aquadragon"] = "dragonaquanini",
    ["aquanini"] = "DragonAquanini",
    ["arcadragon"] = "red",
    ["arcadragon color"] = "red",
    ["artist"] = "drake",
    ["asteroid trait"] = "cometstruck",
    ["asteroid trait date"] = "june2025",
    ["asteroid trait day"] = "28",
    ["asteroid trait month"] = "june",
    ["asteroid trait release"] = "june2025",
    ["asteroid trait release date"] = "june2025",
    ["asteroid trait release day"] = "28",
    ["asteroid trait release month"] = "june",
    ["asteroid trait release year"] = "2025",
    ["asteroid trait year"] = "2025",
    ["aura"] = "aura",
    ["avatar"] = "legoastronaut",
    ["backrooms"] = "backrooms",
    ["base in today update"] = "emperor",
    ["base in todays update"] = "emperor",
    ["base skin"] = "1of1",
    ["base skin admin"] = "1of1",
    ["base skin today"] = "1of1",
    ["baseball bat"] = "bat",
    ["baseballbat"] = "bat",
    ["bat"] = "bat",
    ["bee block"] = "august2026",
    ["bee block date"] = "august2026",
    ["bee block day"] = "22",
    ["bee block month"] = "august",
    ["bee block release"] = "august2026",
    ["bee block release date"] = "august2026",
    ["bee block release day"] = "22",
    ["bee block release month"] = "august",
    ["bee block release year"] = "2026",
    ["bee block year"] = "2026",
    ["bee gear"] = "flyingbee",
    ["bee loco"] = "beeloco",
    ["bee lucky"] = "august2026",
    ["bee lucky block"] = "august2026",
    ["bee lucky block best brainrot"] = "orchidox",
    ["bee lucky block brainrot"] = "orchidox",
    ["bee lucky block brainrot date"] = "august2026",
    ["bee lucky block brainrot day"] = "22",
    ["bee lucky block brainrot month"] = "august",
    ["bee lucky block brainrot release"] = "august2026",
    ["bee lucky block brainrot release date"] = "august2026",
    ["bee lucky block brainrot release day"] = "22",
    ["bee lucky block brainrot release month"] = "august",
    ["bee lucky block brainrot release year"] = "2026",
    ["bee lucky block brainrot year"] = "2026",
    ["bee lucky block date"] = "august2026",
    ["bee lucky block day"] = "22",
    ["bee lucky block in sab"] = "august2026",
    ["bee lucky block in sab date"] = "august2026",
    ["bee lucky block in sab day"] = "22",
    ["bee lucky block in sab month"] = "august",
    ["bee lucky block in sab release"] = "august2026",
    ["bee lucky block in sab release date"] = "august2026",
    ["bee lucky block in sab release day"] = "22",
    ["bee lucky block in sab release month"] = "august",
    ["bee lucky block in sab release year"] = "2026",
    ["bee lucky block in sab year"] = "2026",
    ["bee lucky block in the game"] = "august2026",
    ["bee lucky block in the game date"] = "august2026",
    ["bee lucky block in the game day"] = "22",
    ["bee lucky block in the game month"] = "august",
    ["bee lucky block in the game release"] = "august2026",
    ["bee lucky block in the game release date"] = "august2026",
    ["bee lucky block in the game release day"] = "22",
    ["bee lucky block in the game release month"] = "august",
    ["bee lucky block in the game release year"] = "2026",
    ["bee lucky block in the game year"] = "2026",
    ["bee lucky block month"] = "august",
    ["bee lucky block most op brainrot"] = "orchidox",
    ["bee lucky block op brainrot"] = "orchidox",
    ["bee lucky block release"] = "august2026",
    ["bee lucky block release date"] = "august2026",
    ["bee lucky block release day"] = "22",
    ["bee lucky block release month"] = "august",
    ["bee lucky block release year"] = "2026",
    ["bee lucky block year"] = "2026",
    ["bee lucky blocks"] = "august2026",
    ["bee lucky blocks date"] = "august2026",
    ["bee lucky blocks day"] = "22",
    ["bee lucky blocks month"] = "august",
    ["bee lucky blocks release"] = "august2026",
    ["bee lucky blocks release date"] = "august2026",
    ["bee lucky blocks release day"] = "22",
    ["bee lucky blocks release month"] = "august",
    ["bee lucky blocks release year"] = "2026",
    ["bee lucky blocks year"] = "2026",
    ["bee lucky date"] = "august2026",
    ["bee lucky day"] = "22",
    ["bee lucky month"] = "august",
    ["bee lucky release"] = "august2026",
    ["bee lucky release date"] = "august2026",
    ["bee lucky release day"] = "22",
    ["bee lucky release month"] = "august",
    ["bee lucky release year"] = "2026",
    ["bee lucky year"] = "2026",
    ["bee shop brainrot"] = "orchidox",
    ["bee shop brainrot date"] = "august2026",
    ["bee shop brainrot day"] = "22",
    ["bee shop brainrot month"] = "august",
    ["bee shop brainrot release"] = "august2026",
    ["bee shop brainrot release date"] = "august2026",
    ["bee shop brainrot release day"] = "22",
    ["bee shop brainrot release month"] = "august",
    ["bee shop brainrot release year"] = "2026",
    ["bee shop brainrot year"] = "2026",
    ["bee update brainrot"] = "orchidox",
    ["bee update brainrot date"] = "august2026",
    ["bee update brainrot day"] = "22",
    ["bee update brainrot month"] = "august",
    ["bee update brainrot release"] = "august2026",
    ["bee update brainrot release date"] = "august2026",
    ["bee update brainrot release day"] = "22",
    ["bee update brainrot release month"] = "august",
    ["bee update brainrot release year"] = "2026",
    ["bee update brainrot year"] = "2026",
    ["beeloco"] = "beeloco",
    ["began making games"] = "2013",
    ["began making games in roblox"] = "2013",
    ["began making games in roblox release year"] = "2013",
    ["began making games in roblox year"] = "2013",
    ["began making games on roblox"] = "2013",
    ["began making games on roblox in"] = "2013",
    ["began making games on roblox in 2013"] = "2013",
    ["began making games on roblox in 2013 release year"] = "2013",
    ["began making games on roblox in 2013 year"] = "2013",
    ["began making games on roblox in release year"] = "2013",
    ["began making games on roblox in year"] = "2013",
    ["began making games on roblox release year"] = "2013",
    ["began making games on roblox year"] = "2013",
    ["began making games release year"] = "2013",
    ["began making games year"] = "2013",
    ["best admin abuse brainrot"] = "lupaandlipa",
    ["best bee block"] = "orchidox",
    ["best bee brainrot"] = "orchidox",
    ["best bee brainrot date"] = "august2026",
    ["best bee brainrot day"] = "22",
    ["best bee brainrot month"] = "august",
    ["best bee brainrot release"] = "august2026",
    ["best bee brainrot release date"] = "august2026",
    ["best bee brainrot release day"] = "22",
    ["best bee brainrot release month"] = "august",
    ["best bee brainrot release year"] = "2026",
    ["best bee brainrot year"] = "2026",
    ["best bee lucky"] = "orchidox",
    ["best bee lucky block"] = "orchidox",
    ["best bee lucky block brainrot"] = "orchidox",
    ["best bee lucky block brainrot date"] = "august2026",
    ["best bee lucky block brainrot day"] = "22",
    ["best bee lucky block brainrot month"] = "august",
    ["best bee lucky block brainrot release"] = "august2026",
    ["best bee lucky block brainrot release date"] = "august2026",
    ["best bee lucky block brainrot release day"] = "22",
    ["best bee lucky block brainrot release month"] = "august",
    ["best bee lucky block brainrot release year"] = "2026",
    ["best bee lucky block brainrot year"] = "2026",
    ["best bee shop"] = "orchidox",
    ["best bee shop brainrot"] = "orchidox",
    ["best bee shop brainrot date"] = "august2026",
    ["best bee shop brainrot day"] = "22",
    ["best bee shop brainrot month"] = "august",
    ["best bee shop brainrot release"] = "august2026",
    ["best bee shop brainrot release date"] = "august2026",
    ["best bee shop brainrot release day"] = "22",
    ["best bee shop brainrot release month"] = "august",
    ["best bee shop brainrot release year"] = "2026",
    ["best bee shop brainrot year"] = "2026",
    ["best bee update"] = "orchidox",
    ["best brainrot"] = "lupaandlipa",
    ["best brainrot added"] = "hydraserpent",
    ["best brainrot added admin abuse"] = "hydraserpent",
    ["best brainrot added in today admin abuse"] = "lupaandlipa",
    ["best brainrot added in today update"] = "lupaandlipa",
    ["best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["best brainrot added in todays update"] = "lupaandlipa",
    ["best brainrot added last saturday"] = "orchidox",
    ["best brainrot added last saturday date"] = "august2026",
    ["best brainrot added last saturday day"] = "22",
    ["best brainrot added last saturday month"] = "august",
    ["best brainrot added last saturday release"] = "august2026",
    ["best brainrot added last saturday release date"] = "august2026",
    ["best brainrot added last saturday release day"] = "22",
    ["best brainrot added last saturday release month"] = "august",
    ["best brainrot added last saturday release year"] = "2026",
    ["best brainrot added last saturday year"] = "2026",
    ["best brainrot added last week"] = "orchidox",
    ["best brainrot added last week date"] = "august2026",
    ["best brainrot added last week day"] = "22",
    ["best brainrot added last week month"] = "august",
    ["best brainrot added last week release"] = "august2026",
    ["best brainrot added last week release date"] = "august2026",
    ["best brainrot added last week release day"] = "22",
    ["best brainrot added last week release month"] = "august",
    ["best brainrot added last week release year"] = "2026",
    ["best brainrot added last week year"] = "2026",
    ["best brainrot added today"] = "lupaandlipa",
    ["best brainrot admin abuse"] = "hydraserpent",
    ["best brainrot except"] = "strawberryelephant",
    ["best brainrot except spyder"] = "strawberryelephant",
    ["best brainrot except spyder elephant"] = "strawberryelephant",
    ["best brainrot except spyderelephant"] = "strawberryelephant",
    ["best brainrot from bee lucky"] = "orchidox",
    ["best brainrot from bee lucky block"] = "orchidox",
    ["best brainrot from bee lucky block date"] = "august2026",
    ["best brainrot from bee lucky block day"] = "22",
    ["best brainrot from bee lucky block month"] = "august",
    ["best brainrot from bee lucky block release"] = "august2026",
    ["best brainrot from bee lucky block release date"] = "august2026",
    ["best brainrot from bee lucky block release day"] = "22",
    ["best brainrot from bee lucky block release month"] = "august",
    ["best brainrot from bee lucky block release year"] = "2026",
    ["best brainrot from bee lucky block year"] = "2026",
    ["best brainrot from previous gamemode"] = "hydrabunny",
    ["best brainrot from previous ltm"] = "hydrabunny",
    ["best brainrot from the bee lucky block"] = "orchidox",
    ["best brainrot in"] = "lupaandlipa",
    ["best brainrot in admin abuse"] = "lupaandlipa",
    ["best brainrot in bee lucky"] = "orchidox",
    ["best brainrot in bee lucky block"] = "orchidox",
    ["best brainrot in bee lucky block date"] = "august2026",
    ["best brainrot in bee lucky block day"] = "22",
    ["best brainrot in bee lucky block month"] = "august",
    ["best brainrot in bee lucky block release"] = "august2026",
    ["best brainrot in bee lucky block release date"] = "august2026",
    ["best brainrot in bee lucky block release day"] = "22",
    ["best brainrot in bee lucky block release month"] = "august",
    ["best brainrot in bee lucky block release year"] = "2026",
    ["best brainrot in bee lucky block year"] = "2026",
    ["best brainrot in game"] = "lupaandlipa",
    ["best brainrot in game except spyder elephant"] = "strawberryelephant",
    ["best brainrot in game except spyderelephant"] = "strawberryelephant",
    ["best brainrot in previous gamemode"] = "hydrabunny",
    ["best brainrot in previous limited time mode"] = "hydrabunny",
    ["best brainrot in previous ltm"] = "hydrabunny",
    ["best brainrot in the"] = "lupaandlipa",
    ["best brainrot in the bee lucky block"] = "orchidox",
    ["best brainrot in the game"] = "lupaandlipa",
    ["best brainrot in the game except spyder elephant"] = "strawberryelephant",
    ["best brainrot in the game except spyderelephant"] = "strawberryelephant",
    ["best brainrot in the previous gamemode"] = "hydrabunny",
    ["best brainrot in today update"] = "lupaandlipa",
    ["best brainrot in todays admin abuse"] = "lupaandlipa",
    ["best brainrot in todays update"] = "lupaandlipa",
    ["best brainrot last saturday"] = "orchidox",
    ["best brainrot last week"] = "orchidox",
    ["best brainrot released last saturday"] = "orchidox",
    ["best brainrot released last saturday date"] = "august2026",
    ["best brainrot released last saturday day"] = "22",
    ["best brainrot released last saturday month"] = "august",
    ["best brainrot released last saturday release"] = "august2026",
    ["best brainrot released last saturday release date"] = "august2026",
    ["best brainrot released last saturday release day"] = "22",
    ["best brainrot released last saturday release month"] = "august",
    ["best brainrot released last saturday release year"] = "2026",
    ["best brainrot released last saturday year"] = "2026",
    ["best brainrot released last week"] = "orchidox",
    ["best brainrot released last week date"] = "august2026",
    ["best brainrot released last week day"] = "22",
    ["best brainrot released last week month"] = "august",
    ["best brainrot released last week release"] = "august2026",
    ["best brainrot released last week release date"] = "august2026",
    ["best brainrot released last week release day"] = "22",
    ["best brainrot released last week release month"] = "august",
    ["best brainrot released last week release year"] = "2026",
    ["best brainrot released last week year"] = "2026",
    ["best brainrot reskin"] = "sammynitruckini",
    ["best brainrot reskin me"] = "sammynitruckini",
    ["best brainrot reskin of me"] = "sammynitruckini",
    ["best brainrot reskin of sammy"] = "sammynitruckini",
    ["best brainrot reskin sammy"] = "sammynitruckini",
    ["best brainrot that was added in today update"] = "lupaandlipa",
    ["best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["best brainrot that was added in todays update"] = "lupaandlipa",
    ["best brainrot that was added last saturday"] = "orchidox",
    ["best brainrot that was added last saturday date"] = "august2026",
    ["best brainrot that was added last saturday day"] = "22",
    ["best brainrot that was added last saturday month"] = "august",
    ["best brainrot that was added last saturday release"] = "august2026",
    ["best brainrot that was added last saturday release date"] = "august2026",
    ["best brainrot that was added last saturday release day"] = "22",
    ["best brainrot that was added last saturday release month"] = "august",
    ["best brainrot that was added last saturday release year"] = "2026",
    ["best brainrot that was added last saturday year"] = "2026",
    ["best brainrot that was added last week"] = "orchidox",
    ["best brainrot that was added last week date"] = "august2026",
    ["best brainrot that was added last week day"] = "22",
    ["best brainrot that was added last week month"] = "august",
    ["best brainrot that was added last week release"] = "august2026",
    ["best brainrot that was added last week release date"] = "august2026",
    ["best brainrot that was added last week release day"] = "22",
    ["best brainrot that was added last week release month"] = "august",
    ["best brainrot that was added last week release year"] = "2026",
    ["best brainrot that was added last week year"] = "2026",
    ["best brainrot that was added today"] = "lupaandlipa",
    ["best brainrot that was released last saturday"] = "orchidox",
    ["best brainrot that was released last saturday date"] = "august2026",
    ["best brainrot that was released last saturday day"] = "22",
    ["best brainrot that was released last saturday month"] = "august",
    ["best brainrot that was released last saturday release"] = "august2026",
    ["best brainrot that was released last saturday release date"] = "august2026",
    ["best brainrot that was released last saturday release day"] = "22",
    ["best brainrot that was released last saturday release month"] = "august",
    ["best brainrot that was released last saturday release year"] = "2026",
    ["best brainrot that was released last saturday year"] = "2026",
    ["best brainrot that was released last week"] = "orchidox",
    ["best brainrot that was released last week date"] = "august2026",
    ["best brainrot that was released last week day"] = "22",
    ["best brainrot that was released last week month"] = "august",
    ["best brainrot that was released last week release"] = "august2026",
    ["best brainrot that was released last week release date"] = "august2026",
    ["best brainrot that was released last week release day"] = "22",
    ["best brainrot that was released last week release month"] = "august",
    ["best brainrot that was released last week release year"] = "2026",
    ["best brainrot that was released last week year"] = "2026",
    ["best brainrot that we added today"] = "draculino",
    ["best brainrot today"] = "lupaandlipa",
    ["best brainrot today update"] = "hydraserpent",
    ["best brainrot todays update"] = "hydraserpent",
    ["best brainrot we added today"] = "draculino",
    ["best brainrot without"] = "strawberryelephant",
    ["best brainrot without spyder"] = "strawberryelephant",
    ["best brainrot without spyder elephant"] = "strawberryelephant",
    ["best brainrot without spyderelephant"] = "strawberryelephant",
    ["best egg"] = "dragonegg",
    ["best egg from new ltm"] = "dragonegg",
    ["best egg from previous gamemode"] = "hydrabunnyegg",
    ["best egg from previous ltm"] = "hydrabunnyegg",
    ["best egg from the new ltm"] = "dragonegg",
    ["best egg from this ltm"] = "dragonegg",
    ["best egg in current ltm"] = "dragonegg",
    ["best egg in game"] = "dragonegg",
    ["best egg in limited time mode"] = "dragonegg",
    ["best egg in ltm"] = "dragonegg",
    ["best egg in new ltm"] = "dragonegg",
    ["best egg in previous gamemode"] = "hydrabunnyegg",
    ["best egg in previous ltm"] = "hydrabunnyegg",
    ["best egg in the current limited time mode"] = "dragonegg",
    ["best egg in the current ltm"] = "dragonegg",
    ["best egg in the game"] = "dragonegg",
    ["best egg in the ltm"] = "dragonegg",
    ["best egg in the new gamemode"] = "dragonegg",
    ["best egg in the new limited time mode"] = "dragonegg",
    ["best egg in the new ltm"] = "dragonegg",
    ["best egg in this gamemode"] = "dragonegg",
    ["best egg in this limited time mode"] = "dragonegg",
    ["best egg in this ltm"] = "dragonegg",
    ["best egg that you can get in ltm"] = "dragonegg",
    ["best egg that you can get in new ltm"] = "dragonegg",
    ["best egg that you can get in new ltm or ltm"] = "dragonegg",
    ["best egg that you can get in this ltm"] = "dragonegg",
    ["best egg that you can obtain in this ltm"] = "dragonegg",
    ["best egg that you could get in ltm"] = "dragonegg",
    ["best egg that you could get in new ltm"] = "dragonegg",
    ["best egg that you could get in new ltm or ltm"] = "dragonegg",
    ["best egg you can get in this ltm"] = "dragonegg",
    ["best egg you can obtain in this ltm"] = "dragonegg",
    ["best fuse brainrot"] = "griffin",
    ["best fuse machine brainrot"] = "griffin",
    ["best looking mutation for meowl"] = "cyber",
    ["best looking mutation for meowl date"] = "april2026",
    ["best looking mutation for meowl day"] = "18",
    ["best looking mutation for meowl month"] = "april",
    ["best looking mutation for meowl release"] = "april2026",
    ["best looking mutation for meowl release date"] = "april2026",
    ["best looking mutation for meowl release day"] = "18",
    ["best looking mutation for meowl release month"] = "april",
    ["best looking mutation for meowl release year"] = "2026",
    ["best looking mutation for meowl year"] = "2026",
    ["best looking mutation on meowl"] = "cyber",
    ["best looking mutation on meowl date"] = "april2026",
    ["best looking mutation on meowl day"] = "18",
    ["best looking mutation on meowl month"] = "april",
    ["best looking mutation on meowl release"] = "april2026",
    ["best looking mutation on meowl release date"] = "april2026",
    ["best looking mutation on meowl release day"] = "18",
    ["best looking mutation on meowl release month"] = "april",
    ["best looking mutation on meowl release year"] = "2026",
    ["best looking mutation on meowl year"] = "2026",
    ["best merchant taco"] = "sammynitruckini",
    ["best mutation"] = "crystal",
    ["best mutation currently"] = "crystal",
    ["best mutation for meowl visually"] = "cyber",
    ["best mutation for meowl visually date"] = "april2026",
    ["best mutation for meowl visually day"] = "18",
    ["best mutation for meowl visually month"] = "april",
    ["best mutation for meowl visually release"] = "april2026",
    ["best mutation for meowl visually release date"] = "april2026",
    ["best mutation for meowl visually release day"] = "18",
    ["best mutation for meowl visually release month"] = "april",
    ["best mutation for meowl visually release year"] = "2026",
    ["best mutation for meowl visually year"] = "2026",
    ["best mutation for my favorite brainrot visually"] = "cyber",
    ["best mutation right now"] = "crystal",
    ["best mutation rn"] = "crystal",
    ["best new brainrot"] = "draculino",
    ["best new brainrot in ltm"] = "draculino",
    ["best new brainrot in the ltm"] = "draculino",
    ["best reskin"] = "sammynitruckini",
    ["best reskin me"] = "sammynitruckini",
    ["best reskin of me"] = "sammynitruckini",
    ["best reskin of sammy"] = "sammynitruckini",
    ["best reskin sammy"] = "sammynitruckini",
    ["best taco"] = "latacocombinasion",
    ["best taco brainrot"] = "latacocombinasion",
    ["best taco merchant"] = "sammynitruckini",
    ["best visual mutation for favorite brainrot"] = "cyber",
    ["best visual mutation for favorite brainrot date"] = "april2026",
    ["best visual mutation for favorite brainrot day"] = "18",
    ["best visual mutation for favorite brainrot month"] = "april",
    ["best visual mutation for favorite brainrot release"] = "april2026",
    ["best visual mutation for favorite brainrot release date"] = "april2026",
    ["best visual mutation for favorite brainrot release day"] = "18",
    ["best visual mutation for favorite brainrot release month"] = "april",
    ["best visual mutation for favorite brainrot release year"] = "2026",
    ["best visual mutation for favorite brainrot year"] = "2026",
    ["best visual mutation for meowl"] = "cyber",
    ["best visual mutation for meowl date"] = "april2026",
    ["best visual mutation for meowl day"] = "18",
    ["best visual mutation for meowl month"] = "april",
    ["best visual mutation for meowl release"] = "april2026",
    ["best visual mutation for meowl release date"] = "april2026",
    ["best visual mutation for meowl release day"] = "18",
    ["best visual mutation for meowl release month"] = "april",
    ["best visual mutation for meowl release year"] = "2026",
    ["best visual mutation for meowl year"] = "2026",
    ["best visual mutation for my favorite brainrot"] = "cyber",
    ["best visual mutation for my favorite brainrot date"] = "april2026",
    ["best visual mutation for my favorite brainrot day"] = "18",
    ["best visual mutation for my favorite brainrot month"] = "april",
    ["best visual mutation for my favorite brainrot release"] = "april2026",
    ["best visual mutation for my favorite brainrot release date"] = "april2026",
    ["best visual mutation for my favorite brainrot release day"] = "18",
    ["best visual mutation for my favorite brainrot release month"] = "april",
    ["best visual mutation for my favorite brainrot release year"] = "2026",
    ["best visual mutation for my favorite brainrot year"] = "2026",
    ["best visual mutation on meowl"] = "cyber",
    ["best visual mutation on meowl date"] = "april2026",
    ["best visual mutation on meowl day"] = "18",
    ["best visual mutation on meowl month"] = "april",
    ["best visual mutation on meowl release"] = "april2026",
    ["best visual mutation on meowl release date"] = "april2026",
    ["best visual mutation on meowl release day"] = "18",
    ["best visual mutation on meowl release month"] = "april",
    ["best visual mutation on meowl release year"] = "2026",
    ["best visual mutation on meowl year"] = "2026",
    ["better 1speedkeyboardescape"] = "growagarden",
    ["better escape"] = "growagarden",
    ["better keyboard"] = "growagarden",
    ["better loki"] = "jandel",
    ["better lokii"] = "jandel",
    ["better luckymatg"] = "jandel",
    ["better secretloki"] = "jandel",
    ["better secretlokii"] = "jandel",
    ["better than 1 speed keyboard escape"] = "growagarden",
    ["better than 1speedkeyboardescape"] = "growagarden",
    ["better than loki"] = "jandel",
    ["better than lokii"] = "jandel",
    ["better than luckymatg"] = "jandel",
    ["better than secretloki"] = "jandel",
    ["better than secretlokii"] = "jandel",
    ["birth day"] = "24",
    ["birth month"] = "february",
    ["birth year"] = "2002",
    ["birthday"] = "february24",
    ["birthday month"] = "february",
    ["black"] = "black",
    ["bloodrot"] = "bloodrot",
    ["bloodrot date"] = "june2025",
    ["bloodrot day"] = "7",
    ["bloodrot month"] = "june",
    ["bloodrot mutation"] = "bloodrot",
    ["bloodrot mutation date"] = "june2025",
    ["bloodrot mutation day"] = "7",
    ["bloodrot mutation month"] = "june",
    ["bloodrot mutation release"] = "june2025",
    ["bloodrot mutation release date"] = "june2025",
    ["bloodrot mutation release day"] = "7",
    ["bloodrot mutation release month"] = "june",
    ["bloodrot mutation release year"] = "2025",
    ["bloodrot mutation year"] = "2025",
    ["bloodrot release"] = "june2025",
    ["bloodrot release date"] = "june2025",
    ["bloodrot release day"] = "7",
    ["bloodrot release month"] = "june",
    ["bloodrot release year"] = "2025",
    ["bloodrot year"] = "2025",
    ["blue"] = "blue",
    ["blue egg trait"] = "blueegg",
    ["blue egg trait date"] = "april2026",
    ["blue egg trait month"] = "april",
    ["blue egg trait release"] = "april2026",
    ["blue egg trait release date"] = "april2026",
    ["blue egg trait release month"] = "april",
    ["blue egg trait release year"] = "2026",
    ["blue egg trait year"] = "2026",
    ["blue suit of signore carapace"] = "blue",
    ["blueballoon"] = "blueballoon",
    ["blueegg"] = "blueegg",
    ["body skin color"] = "yellow",
    ["bombardini tortini"] = "bombardinitortinii",
    ["bombardini tortinii"] = "bombardinitortinii",
    ["bombardinitortinii"] = "bombardinitortinii",
    ["bombardiro"] = "bombardiro",
    ["bombardiro trait"] = "bombardiro",
    ["bombardiro trait date"] = "june2025",
    ["bombardiro trait month"] = "june",
    ["bombardiro trait release"] = "june2025",
    ["bombardiro trait release date"] = "june2025",
    ["bombardiro trait release month"] = "june",
    ["bombardiro trait release year"] = "2025",
    ["bombardiro trait year"] = "2025",
    ["born month"] = "february",
    ["born year"] = "2002",
    ["brainrot added in todays admin abuse"] = "lupaandlipa",
    ["brainrot added in todays update"] = "hydraserpent",
    ["brainrot added last saturday"] = "orchidox",
    ["brainrot added last saturday date"] = "august2026",
    ["brainrot added last saturday day"] = "22",
    ["brainrot added last saturday month"] = "august",
    ["brainrot added last saturday release"] = "august2026",
    ["brainrot added last saturday release date"] = "august2026",
    ["brainrot added last saturday release day"] = "22",
    ["brainrot added last saturday release month"] = "august",
    ["brainrot added last saturday release year"] = "2026",
    ["brainrot added last saturday year"] = "2026",
    ["brainrot added last week"] = "orchidox",
    ["brainrot added last week date"] = "august2026",
    ["brainrot added last week day"] = "22",
    ["brainrot added last week month"] = "august",
    ["brainrot added last week release"] = "august2026",
    ["brainrot added last week release date"] = "august2026",
    ["brainrot added last week release day"] = "22",
    ["brainrot added last week release month"] = "august",
    ["brainrot added last week release year"] = "2026",
    ["brainrot added last week year"] = "2026",
    ["brainrot added today"] = "hydraserpent",
    ["brainrot deleted"] = "tungtungtungsahur",
    ["brainrot for money ritual"] = "moneymoneypuggy",
    ["brainrot for new ritual"] = "moneymoneypuggy",
    ["brainrot from cave island"] = "draculino",
    ["brainrot from money"] = "lospuggies",
    ["brainrot from money ritual"] = "lospuggies",
    ["brainrot from new ritual"] = "lospuggies",
    ["brainrot from ritual"] = "lospuggies",
    ["brainrot from the cave island"] = "draculino",
    ["brainrot from the money ritual"] = "lospuggies",
    ["brainrot from the new ritual"] = "lospuggies",
    ["brainrot get money"] = "lospuggies",
    ["brainrot get ritual"] = "lospuggies",
    ["brainrot give money"] = "lospuggies",
    ["brainrot give ritual"] = "lospuggies",
    ["brainrot god lucky block"] = "july2025",
    ["brainrot god lucky block date"] = "july2025",
    ["brainrot god lucky block day"] = "12",
    ["brainrot god lucky block month"] = "july",
    ["brainrot god lucky block release"] = "july2025",
    ["brainrot god lucky block release date"] = "july2025",
    ["brainrot god lucky block release day"] = "12",
    ["brainrot god lucky block release month"] = "july",
    ["brainrot god lucky block release year"] = "2025",
    ["brainrot god lucky block year"] = "2025",
    ["brainrot in todays admin abuse"] = "lupaandlipa",
    ["brainrot in todays update"] = "hydraserpent",
    ["brainrot last saturday"] = "orchidox",
    ["brainrot last week"] = "orchidox",
    ["brainrot make ritual"] = "moneymoneypuggy",
    ["brainrot money ritual"] = "moneymoneypuggy",
    ["brainrot need ritual"] = "moneymoneypuggy",
    ["brainrot needed for money ritual"] = "moneymoneypuggy",
    ["brainrot needed for new ritual"] = "moneymoneypuggy",
    ["brainrot obtained from cave island"] = "draculino",
    ["brainrot obtained from the cave island"] = "draculino",
    ["brainrot released last saturday"] = "orchidox",
    ["brainrot released last saturday date"] = "august2026",
    ["brainrot released last saturday day"] = "22",
    ["brainrot released last saturday month"] = "august",
    ["brainrot released last saturday release"] = "august2026",
    ["brainrot released last saturday release date"] = "august2026",
    ["brainrot released last saturday release day"] = "22",
    ["brainrot released last saturday release month"] = "august",
    ["brainrot released last saturday release year"] = "2026",
    ["brainrot released last saturday year"] = "2026",
    ["brainrot released last week"] = "orchidox",
    ["brainrot released last week date"] = "august2026",
    ["brainrot released last week day"] = "22",
    ["brainrot released last week month"] = "august",
    ["brainrot released last week release"] = "august2026",
    ["brainrot released last week release date"] = "august2026",
    ["brainrot released last week release day"] = "22",
    ["brainrot released last week release month"] = "august",
    ["brainrot released last week release year"] = "2026",
    ["brainrot released last week year"] = "2026",
    ["brainrot remove"] = "tungtungtungsahur",
    ["brainrot removed"] = "tungtungtungsahur",
    ["brainrot reward ritual"] = "lospuggies",
    ["brainrot reworked"] = "sammynispyderini",
    ["brainrot that got deleted"] = "tungtungtungsahur",
    ["brainrot that got remove"] = "tungtungtungsahur",
    ["brainrot that got removed"] = "tungtungtungsahur",
    ["brainrot that got reworked"] = "sammynispyderini",
    ["brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["brainrot that was added in todays update"] = "hydraserpent",
    ["brainrot that was added last saturday"] = "orchidox",
    ["brainrot that was added last saturday date"] = "august2026",
    ["brainrot that was added last saturday day"] = "22",
    ["brainrot that was added last saturday month"] = "august",
    ["brainrot that was added last saturday release"] = "august2026",
    ["brainrot that was added last saturday release date"] = "august2026",
    ["brainrot that was added last saturday release day"] = "22",
    ["brainrot that was added last saturday release month"] = "august",
    ["brainrot that was added last saturday release year"] = "2026",
    ["brainrot that was added last saturday year"] = "2026",
    ["brainrot that was added last week"] = "orchidox",
    ["brainrot that was added last week date"] = "august2026",
    ["brainrot that was added last week day"] = "22",
    ["brainrot that was added last week month"] = "august",
    ["brainrot that was added last week release"] = "august2026",
    ["brainrot that was added last week release date"] = "august2026",
    ["brainrot that was added last week release day"] = "22",
    ["brainrot that was added last week release month"] = "august",
    ["brainrot that was added last week release year"] = "2026",
    ["brainrot that was added last week year"] = "2026",
    ["brainrot that was added today"] = "hydraserpent",
    ["brainrot that was deleted"] = "tungtungtungsahur",
    ["brainrot that was released last saturday"] = "orchidox",
    ["brainrot that was released last saturday date"] = "august2026",
    ["brainrot that was released last saturday day"] = "22",
    ["brainrot that was released last saturday month"] = "august",
    ["brainrot that was released last saturday release"] = "august2026",
    ["brainrot that was released last saturday release date"] = "august2026",
    ["brainrot that was released last saturday release day"] = "22",
    ["brainrot that was released last saturday release month"] = "august",
    ["brainrot that was released last saturday release year"] = "2026",
    ["brainrot that was released last saturday year"] = "2026",
    ["brainrot that was released last week"] = "orchidox",
    ["brainrot that was released last week date"] = "august2026",
    ["brainrot that was released last week day"] = "22",
    ["brainrot that was released last week month"] = "august",
    ["brainrot that was released last week release"] = "august2026",
    ["brainrot that was released last week release date"] = "august2026",
    ["brainrot that was released last week release day"] = "22",
    ["brainrot that was released last week release month"] = "august",
    ["brainrot that was released last week release year"] = "2026",
    ["brainrot that was released last week year"] = "2026",
    ["brainrot that was removed"] = "tungtungtungsahur",
    ["brainrot that was reworked"] = "sammynispyderini",
    ["brainrot that you can get from cave island"] = "draculino",
    ["brainrot that you can get from the cave island"] = "draculino",
    ["brainrot that you can obtain from cave island"] = "draculino",
    ["brainrot that you can obtain from the cave island"] = "draculino",
    ["brainrot that you get from money money puggy ritual"] = "lospuggies",
    ["brainrot that you get from money ritual"] = "lospuggies",
    ["brainrot that you get from new money money puggy ritual"] = "lospuggies",
    ["brainrot that you get from new ritual"] = "lospuggies",
    ["brainrot to make money ritual"] = "moneymoneypuggy",
    ["brainrot to make new ritual"] = "moneymoneypuggy",
    ["brainrot to use for money ritual"] = "moneymoneypuggy",
    ["brainrot to use for new ritual"] = "moneymoneypuggy",
    ["brainrot today admin abuse"] = "hydraserpent",
    ["brainrot today update"] = "hydraserpent",
    ["brainrot todays admin abuse"] = "hydraserpent",
    ["brainrot todays update"] = "hydraserpent",
    ["brainrot use ritual"] = "moneymoneypuggy",
    ["brainrot used for money ritual"] = "moneymoneypuggy",
    ["brainrot you can get from cave island"] = "draculino",
    ["brainrot you can get from the cave island"] = "draculino",
    ["brainrot you can obtain from cave island"] = "draculino",
    ["brainrot you can obtain from the cave island"] = "draculino",
    ["brainrot you get from money ritual"] = "lospuggies",
    ["brainrot you get from new ritual"] = "lospuggies",
    ["brainrot you need to use for money ritual"] = "moneymoneypuggy",
    ["brainrot you need to use for new ritual"] = "moneymoneypuggy",
    ["brainrots deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots remove"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots removed"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots rework"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brainrots reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brainrots that got deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brainrots that were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["brakta"] = "brakta",
    ["brother"] = "samuel",
    ["brother name"] = "samuel",
    ["brown"] = "brown",
    ["bruno mars"] = "brunomars",
    ["bruno mars concert trait"] = "concert",
    ["bruno mars concert trait date"] = "january2026",
    ["bruno mars concert trait day"] = "17",
    ["bruno mars concert trait month"] = "january",
    ["bruno mars concert trait release"] = "january2026",
    ["bruno mars concert trait release date"] = "january2026",
    ["bruno mars concert trait release day"] = "17",
    ["bruno mars concert trait release month"] = "january",
    ["bruno mars concert trait release year"] = "2026",
    ["bruno mars concert trait year"] = "2026",
    ["bruno mars trait"] = "concert",
    ["bruno mars trait date"] = "january2026",
    ["bruno mars trait day"] = "17",
    ["bruno mars trait month"] = "january",
    ["bruno mars trait release"] = "january2026",
    ["bruno mars trait release date"] = "january2026",
    ["bruno mars trait release day"] = "17",
    ["bruno mars trait release month"] = "january",
    ["bruno mars trait release year"] = "2026",
    ["bruno mars trait year"] = "2026",
    ["brunomars"] = "brunomars",
    ["bubblegum"] = "bubblegum",
    ["bubblegum machine"] = "bubblegummachine",
    ["bubblegum machine date"] = "july2025",
    ["bubblegum machine day"] = "18",
    ["bubblegum machine month"] = "july",
    ["bubblegum machine release"] = "july2025",
    ["bubblegum machine release date"] = "july2025",
    ["bubblegum machine release day"] = "18",
    ["bubblegum machine release month"] = "july",
    ["bubblegum machine release year"] = "2025",
    ["bubblegum machine year"] = "2025",
    ["bubblegum trait"] = "bubblegum",
    ["bubblegum trait date"] = "july2025",
    ["bubblegum trait day"] = "18",
    ["bubblegum trait month"] = "july",
    ["bubblegum trait release"] = "july2025",
    ["bubblegum trait release date"] = "july2025",
    ["bubblegum trait release day"] = "18",
    ["bubblegum trait release month"] = "july",
    ["bubblegum trait release year"] = "2025",
    ["bubblegum trait year"] = "2025",
    ["bull"] = "bull",
    ["bull trait"] = "bull",
    ["bull trait date"] = "july2026",
    ["bull trait day"] = "25",
    ["bull trait month"] = "july",
    ["bull trait release"] = "july2026",
    ["bull trait release date"] = "july2026",
    ["bull trait release day"] = "25",
    ["bull trait release month"] = "july",
    ["bull trait release year"] = "2026",
    ["bull trait year"] = "2026",
    ["bumbatron"] = "bumbatron",
    ["bunny"] = "hydrabunny",
    ["bunny ears"] = "bunnyears",
    ["bunny ears date"] = "april2026",
    ["bunny ears month"] = "april",
    ["bunny ears release"] = "april2026",
    ["bunny ears release date"] = "april2026",
    ["bunny ears release month"] = "april",
    ["bunny ears release year"] = "2026",
    ["bunny ears trait"] = "bunnyears",
    ["bunny ears trait date"] = "april2026",
    ["bunny ears trait month"] = "april",
    ["bunny ears trait release"] = "april2026",
    ["bunny ears trait release date"] = "april2026",
    ["bunny ears trait release month"] = "april",
    ["bunny ears trait release year"] = "2026",
    ["bunny ears trait year"] = "2026",
    ["bunny ears year"] = "2026",
    ["bunnyears"] = "bunnyears",
    ["burger"] = "burger",
    ["burrito bandito"] = "burritobandito",
    ["burrito bat"] = "burritobat",
    ["burritobandito"] = "burritobandito",
    ["burritobat"] = "burritobat",
    ["candini"] = "candinifluffini",
    ["candinifluffini"] = "candinifluffini",
    ["candy"] = "candy",
    ["candy mutation"] = "candy",
    ["candy mutation date"] = "july2025",
    ["candy mutation day"] = "5",
    ["candy mutation month"] = "july",
    ["candy mutation release"] = "july2025",
    ["candy mutation release date"] = "july2025",
    ["candy mutation release day"] = "5",
    ["candy mutation release month"] = "july",
    ["candy mutation release year"] = "2025",
    ["candy mutation year"] = "2025",
    ["cannelloni"] = "dragoncannelloni",
    ["capi taco"] = "capitaco",
    ["capitaco"] = "capitaco",
    ["capitano"] = "capitanomoby",
    ["capitano moby color"] = "blue",
    ["capitanomoby"] = "blue",
    ["car color"] = "red",
    ["carapace"] = "signorecarapace",
    ["cat name"] = "nova",
    ["cats name"] = "nova",
    ["caveisland"] = "caveisland",
    ["celestial"] = "celestialpegasus",
    ["celestial pegasus"] = "celestialpegasus",
    ["celestial pegasus color"] = "purple",
    ["celestialpegasus"] = "celestialpegasus",
    ["cerberus"] = "red",
    ["cheapest"] = "noobinipizzanini",
    ["cheapest brainrot"] = "noobinipizzanini",
    ["cheapest in game"] = "noobinipizzanini",
    ["cheapest taco merchant"] = "burritobat",
    ["chihuanini"] = "chihuaninitaconini",
    ["chihuanini taconini"] = "chihuaninitaconini",
    ["chihuaninitaconini"] = "chihuaninitaconini",
    ["chili"] = "chillinchili",
    ["chillin chili"] = "chillinchili",
    ["chillinchili"] = "chillinchili",
    ["chipso"] = "chipsoandqueso",
    ["chipso and queso"] = "chipsoandqueso",
    ["chipso and queso date"] = "october2025",
    ["chipso and queso day"] = "21",
    ["chipso and queso month"] = "october",
    ["chipso and queso release"] = "october2025",
    ["chipso and queso release date"] = "october2025",
    ["chipso and queso release day"] = "21",
    ["chipso and queso release month"] = "october",
    ["chipso and queso release year"] = "2025",
    ["chipso and queso year"] = "2025",
    ["chipso date"] = "october2025",
    ["chipso day"] = "21",
    ["chipso month"] = "october",
    ["chipso queso"] = "chipsoandqueso",
    ["chipso queso date"] = "october2025",
    ["chipso queso day"] = "21",
    ["chipso queso month"] = "october",
    ["chipso queso release"] = "october2025",
    ["chipso queso release date"] = "october2025",
    ["chipso queso release day"] = "21",
    ["chipso queso release month"] = "october",
    ["chipso queso release year"] = "2025",
    ["chipso queso year"] = "2025",
    ["chipso release"] = "october2025",
    ["chipso release date"] = "october2025",
    ["chipso release day"] = "21",
    ["chipso release month"] = "october",
    ["chipso release year"] = "2025",
    ["chipso year"] = "2025",
    ["chipsoandqueso"] = "chipsoandqueso",
    ["chocolate"] = "chocolate",
    ["chocolate trait"] = "chocolate",
    ["chocolate trait date"] = "february2026",
    ["chocolate trait month"] = "february",
    ["chocolate trait release"] = "february2026",
    ["chocolate trait release date"] = "february2026",
    ["chocolate trait release month"] = "february",
    ["chocolate trait release year"] = "2026",
    ["chocolate trait year"] = "2026",
    ["co founder"] = "dosmall",
    ["cofounder"] = "dosmall",
    ["color"] = "blue",
    ["color of antonio"] = "green",
    ["color of arcadragon"] = "red",
    ["color of capitano moby"] = "blue",
    ["color of celestial pegasus"] = "purple",
    ["color of digi narwhal"] = "blue",
    ["color of draculino"] = "black",
    ["color of dragon aquanini"] = "blue",
    ["color of dragon cannelloni"] = "yellow",
    ["color of dragon gingerini"] = "brown",
    ["color of elefanto frigo"] = "gray",
    ["color of garama and madundung"] = "gray",
    ["color of griffin"] = "white",
    ["color of headless horseman"] = "black",
    ["color of hydra bunny"] = "white",
    ["color of hydra dragon cannelloni"] = "yellow",
    ["color of hydra serpent"] = "green",
    ["color of john pork"] = "pink",
    ["color of kraken"] = "red",
    ["color of love love bear"] = "red",
    ["color of meowl"] = "white",
    ["color of my avatar"] = "red",
    ["color of my body skin"] = "yellow",
    ["color of my car"] = "red",
    ["color of my pants"] = "red",
    ["color of my roblox avatar"] = "red",
    ["color of my roblox skin"] = "yellow",
    ["color of my shirt"] = "red",
    ["color of my skin"] = "yellow",
    ["color of new best brainrot in ltm"] = "black",
    ["color of new brainrot"] = "black",
    ["color of new op brainrot"] = "black",
    ["color of orchidox"] = "purple",
    ["color of pancake and syrup"] = "orange",
    ["color of pig"] = "pink",
    ["color of sammy avatar"] = "red",
    ["color of sammy avatar or my color of my avatar"] = "red",
    ["color of sammy roblox avatar"] = "red",
    ["color of sammys avatar"] = "red",
    ["color of sammys roblox avatar"] = "red",
    ["color of signore carapace"] = "white",
    ["color of signore carapace suit"] = "blue",
    ["color of skibidi toilet"] = "white",
    ["color of spyder elephant"] = "gray",
    ["color of strawberry elephant"] = "red",
    ["color of the new best brainrot in ltm"] = "black",
    ["color of the new brainrot"] = "black",
    ["color of the new op brainrot"] = "black",
    ["color of toilet"] = "white",
    ["color suit of signore carapace"] = "blue",
    ["colour of spyder elephant"] = "gray",
    ["comet ritual"] = "comet",
    ["comet struck"] = "cometstruck",
    ["comet struck date"] = "june2025",
    ["comet struck day"] = "28",
    ["comet struck month"] = "june",
    ["comet struck release"] = "june2025",
    ["comet struck release date"] = "june2025",
    ["comet struck release day"] = "28",
    ["comet struck release month"] = "june",
    ["comet struck release year"] = "2025",
    ["comet struck trait"] = "cometstruck",
    ["comet struck trait date"] = "june2025",
    ["comet struck trait day"] = "28",
    ["comet struck trait month"] = "june",
    ["comet struck trait release"] = "june2025",
    ["comet struck trait release date"] = "june2025",
    ["comet struck trait release day"] = "28",
    ["comet struck trait release month"] = "june",
    ["comet struck trait release year"] = "2025",
    ["comet struck trait year"] = "2025",
    ["comet struck year"] = "2025",
    ["cometstruck"] = "cometstruck",
    ["coming fuse machine"] = "hauntedfuse",
    ["coming in Strawberry"] = "hauntedfuse",
    ["competitive game"] = "valorant",
    ["competitive player"] = "valorant",
    ["competitive player at"] = "valorant",
    ["competitive player at valorant"] = "valorant",
    ["competitive player valorant"] = "valorant",
    ["competitive valorant"] = "valorant",
    ["competitive valorant player"] = "valorant",
    ["concert"] = "concert",
    ["concert trait"] = "concert",
    ["concert trait date"] = "january2026",
    ["concert trait day"] = "17",
    ["concert trait month"] = "january",
    ["concert trait release"] = "january2026",
    ["concert trait release date"] = "january2026",
    ["concert trait release day"] = "17",
    ["concert trait release month"] = "january",
    ["concert trait release year"] = "2026",
    ["concert trait year"] = "2026",
    ["corn corn corn"] = "corncorncornsahur",
    ["corn corn corn sahur"] = "corncorncornsahur",
    ["corn sahur"] = "corncorncornsahur",
    ["corncorncornsahur"] = "corncorncornsahur",
    ["count of 1 of 1 brainrots"] = "155",
    ["count of 1 of 1s"] = "155",
    ["country"] = "usa",
    ["crab rave"] = "crabrave",
    ["crab rave date"] = "june2025",
    ["crab rave month"] = "june",
    ["crab rave release"] = "june2025",
    ["crab rave release date"] = "june2025",
    ["crab rave release month"] = "june",
    ["crab rave release year"] = "2025",
    ["crab rave trait"] = "crabrave",
    ["crab rave trait date"] = "june2025",
    ["crab rave trait month"] = "june",
    ["crab rave trait release"] = "june2025",
    ["crab rave trait release date"] = "june2025",
    ["crab rave trait release month"] = "june",
    ["crab rave trait release year"] = "2025",
    ["crab rave trait year"] = "2025",
    ["crab rave year"] = "2025",
    ["crabrave"] = "crabrave",
    ["craft"] = "september2025",
    ["craft date"] = "september2025",
    ["craft day"] = "6",
    ["craft machine"] = "september2025",
    ["craft machine date"] = "september2025",
    ["craft machine day"] = "6",
    ["craft machine month"] = "september",
    ["craft machine release"] = "september2025",
    ["craft machine release date"] = "september2025",
    ["craft machine release day"] = "6",
    ["craft machine release month"] = "september",
    ["craft machine release year"] = "2025",
    ["craft machine year"] = "2025",
    ["craft month"] = "september",
    ["craft release"] = "september2025",
    ["craft release date"] = "september2025",
    ["craft release day"] = "6",
    ["craft release month"] = "september",
    ["craft release year"] = "2025",
    ["craft year"] = "2025",
    ["crocidilo penisini"] = "crocidilopenisini",
    ["crocidilopenisini"] = "crocidilopenisini",
    ["crocodilo penisini"] = "crocidilopenisini",
    ["crocodilopenisini"] = "crocidilopenisini",
    ["crystal"] = "crystal",
    ["crystal mutation"] = "crystal",
    ["crystal mutation date"] = "july2026",
    ["crystal mutation day"] = "25",
    ["crystal mutation month"] = "july",
    ["crystal mutation release"] = "july2026",
    ["crystal mutation release date"] = "july2026",
    ["crystal mutation release day"] = "25",
    ["crystal mutation release month"] = "july",
    ["crystal mutation release year"] = "2026",
    ["crystal mutation year"] = "2026",
    ["crystal strawberry elephant exist"] = "1",
    ["crystal strawberry elephant exist count"] = "1",
    ["crystal strawberry elephants exist"] = "1",
    ["cucaracha"] = "lacucaracha",
    ["cupid fuse"] = "february2026",
    ["cupid fuse date"] = "february2026",
    ["cupid fuse day"] = "7",
    ["cupid fuse month"] = "february",
    ["cupid fuse release"] = "february2026",
    ["cupid fuse release date"] = "february2026",
    ["cupid fuse release day"] = "7",
    ["cupid fuse release month"] = "february",
    ["cupid fuse release year"] = "2026",
    ["cupid fuse year"] = "2026",
    ["cupid machine"] = "february2026",
    ["cupid machine date"] = "february2026",
    ["cupid machine day"] = "7",
    ["cupid machine month"] = "february",
    ["cupid machine release"] = "february2026",
    ["cupid machine release date"] = "february2026",
    ["cupid machine release day"] = "7",
    ["cupid machine release month"] = "february",
    ["cupid machine release year"] = "2026",
    ["cupid machine year"] = "2026",
    ["current fuse"] = "rainbowfuse",
    ["current fuse date"] = "june2025",
    ["current fuse day"] = "21",
    ["current fuse month"] = "june",
    ["current fuse release"] = "june2025",
    ["current fuse release date"] = "june2025",
    ["current fuse release day"] = "21",
    ["current fuse release month"] = "june",
    ["current fuse release year"] = "2025",
    ["current fuse year"] = "2025",
    ["current ritual"] = "money",
    ["current season"] = "autumn",
    ["cursed"] = "cursed",
    ["cursed date"] = "january2026",
    ["cursed day"] = "3",
    ["cursed month"] = "january",
    ["cursed mutation"] = "cursed",
    ["cursed mutation date"] = "january2026",
    ["cursed mutation day"] = "3",
    ["cursed mutation month"] = "january",
    ["cursed mutation release"] = "january2026",
    ["cursed mutation release date"] = "january2026",
    ["cursed mutation release day"] = "3",
    ["cursed mutation release month"] = "january",
    ["cursed mutation release year"] = "2026",
    ["cursed mutation year"] = "2026",
    ["cursed release"] = "january2026",
    ["cursed release date"] = "january2026",
    ["cursed release day"] = "3",
    ["cursed release month"] = "january",
    ["cursed release year"] = "2026",
    ["cursed year"] = "2026",
    ["cyber"] = "cyber",
    ["cyber admin"] = "april2026",
    ["cyber admin date"] = "april2026",
    ["cyber admin day"] = "25",
    ["cyber admin machine"] = "april2026",
    ["cyber admin machine date"] = "april2026",
    ["cyber admin machine day"] = "25",
    ["cyber admin machine month"] = "april",
    ["cyber admin machine release"] = "april2026",
    ["cyber admin machine release date"] = "april2026",
    ["cyber admin machine release day"] = "25",
    ["cyber admin machine release month"] = "april",
    ["cyber admin machine release year"] = "2026",
    ["cyber admin machine year"] = "2026",
    ["cyber admin month"] = "april",
    ["cyber admin release"] = "april2026",
    ["cyber admin release date"] = "april2026",
    ["cyber admin release day"] = "25",
    ["cyber admin release month"] = "april",
    ["cyber admin release year"] = "2026",
    ["cyber admin year"] = "2026",
    ["cyber craft"] = "cybercraft",
    ["cyber craft date"] = "april2026",
    ["cyber craft day"] = "18",
    ["cyber craft machine"] = "cybercraft",
    ["cyber craft machine date"] = "april2026",
    ["cyber craft machine day"] = "18",
    ["cyber craft machine month"] = "april",
    ["cyber craft machine release"] = "april2026",
    ["cyber craft machine release date"] = "april2026",
    ["cyber craft machine release day"] = "18",
    ["cyber craft machine release month"] = "april",
    ["cyber craft machine release year"] = "2026",
    ["cyber craft machine year"] = "2026",
    ["cyber craft month"] = "april",
    ["cyber craft release"] = "april2026",
    ["cyber craft release date"] = "april2026",
    ["cyber craft release day"] = "18",
    ["cyber craft release month"] = "april",
    ["cyber craft release year"] = "2026",
    ["cyber craft year"] = "2026",
    ["cyber date"] = "april2026",
    ["cyber day"] = "18",
    ["cyber month"] = "april",
    ["cyber mutation"] = "cyber",
    ["cyber mutation date"] = "april2026",
    ["cyber mutation day"] = "18",
    ["cyber mutation for meowl"] = "cyber",
    ["cyber mutation month"] = "april",
    ["cyber mutation release"] = "april2026",
    ["cyber mutation release date"] = "april2026",
    ["cyber mutation release day"] = "18",
    ["cyber mutation release month"] = "april",
    ["cyber mutation release year"] = "2026",
    ["cyber mutation year"] = "2026",
    ["cyber on meowl"] = "cyber",
    ["cyber release"] = "april2026",
    ["cyber release date"] = "april2026",
    ["cyber release day"] = "18",
    ["cyber release month"] = "april",
    ["cyber release year"] = "2026",
    ["cyber year"] = "2026",
    ["cybercraft"] = "cybercraft",
    ["cybercraft date"] = "april2026",
    ["cybercraft day"] = "18",
    ["cybercraft month"] = "april",
    ["cybercraft release"] = "april2026",
    ["cybercraft release date"] = "april2026",
    ["cybercraft release day"] = "18",
    ["cybercraft release month"] = "april",
    ["cybercraft release year"] = "2026",
    ["cybercraft year"] = "2026",
    ["date when strawberry elephant released"] = "august2025",
    ["day birthday"] = "24",
    ["day born"] = "24",
    ["day headless horseman"] = "1",
    ["day john pork"] = "1",
    ["day meowl"] = "1",
    ["day skibidi toilet"] = "1",
    ["day spyder elephant"] = "1",
    ["day strawberry elephant"] = "1",
    ["day when headless horseman released"] = "1",
    ["day when john pork released"] = "1",
    ["day when meowl released"] = "1",
    ["day when skibidi toilet released"] = "1",
    ["day when spyder elephant released"] = "1",
    ["day when strawberry elephant released"] = "1",
    ["deleted brainrot"] = "tungtungtungsahur",
    ["deleted brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["diamond strawberry elephant exist"] = "263",
    ["diamond strawberry elephant exist count"] = "263",
    ["diamond strawberry elephants exist"] = "263",
    ["digi narwhal color"] = "blue",
    ["diginarwhal"] = "blue",
    ["disco"] = "disco",
    ["divine"] = "divine",
    ["divine admin"] = "february2026",
    ["divine admin date"] = "february2026",
    ["divine admin day"] = "28",
    ["divine admin machine"] = "february2026",
    ["divine admin machine date"] = "february2026",
    ["divine admin machine day"] = "28",
    ["divine admin machine month"] = "february",
    ["divine admin machine release"] = "february2026",
    ["divine admin machine release date"] = "february2026",
    ["divine admin machine release day"] = "28",
    ["divine admin machine release month"] = "february",
    ["divine admin machine release year"] = "2026",
    ["divine admin machine year"] = "2026",
    ["divine admin month"] = "february",
    ["divine admin release"] = "february2026",
    ["divine admin release date"] = "february2026",
    ["divine admin release day"] = "28",
    ["divine admin release month"] = "february",
    ["divine admin release year"] = "2026",
    ["divine admin year"] = "2026",
    ["divine fuse"] = "divinefuse",
    ["divine fuse date"] = "march2026",
    ["divine fuse day"] = "7",
    ["divine fuse machine"] = "divinefuse",
    ["divine fuse machine date"] = "march2026",
    ["divine fuse machine day"] = "7",
    ["divine fuse machine month"] = "march",
    ["divine fuse machine release"] = "march2026",
    ["divine fuse machine release date"] = "march2026",
    ["divine fuse machine release day"] = "7",
    ["divine fuse machine release month"] = "march",
    ["divine fuse machine release year"] = "2026",
    ["divine fuse machine year"] = "2026",
    ["divine fuse month"] = "march",
    ["divine fuse release"] = "march2026",
    ["divine fuse release date"] = "march2026",
    ["divine fuse release day"] = "7",
    ["divine fuse release month"] = "march",
    ["divine fuse release year"] = "2026",
    ["divine fuse year"] = "2026",
    ["divine halo trait"] = "halo",
    ["divine halo trait date"] = "february2026",
    ["divine halo trait month"] = "february",
    ["divine halo trait release"] = "february2026",
    ["divine halo trait release date"] = "february2026",
    ["divine halo trait release month"] = "february",
    ["divine halo trait release year"] = "2026",
    ["divine halo trait year"] = "2026",
    ["divine mutation"] = "divine",
    ["divine mutation date"] = "february2026",
    ["divine mutation day"] = "21",
    ["divine mutation month"] = "february",
    ["divine mutation release"] = "february2026",
    ["divine mutation release date"] = "february2026",
    ["divine mutation release day"] = "21",
    ["divine mutation release month"] = "february",
    ["divine mutation release year"] = "2026",
    ["divine mutation year"] = "2026",
    ["divinefuse"] = "divinefuse",
    ["dog"] = "rocky",
    ["dog name"] = "rocky",
    ["dogs name"] = "rocky",
    ["draculino"] = "draculino",
    ["draculino color"] = "black",
    ["draculino island"] = "caveisland",
    ["dragon"] = "dragoncannelloni",
    ["dragon aquanini color"] = "blue",
    ["dragon cannelloni color"] = "yellow",
    ["dragon cannelloni egg"] = "dragonegg",
    ["dragon gingerini color"] = "brown",
    ["dragonaquanini"] = "blue",
    ["dragoncannelloni"] = "dragoncannelloni",
    ["dragonegg"] = "dragonegg",
    ["dragonfrutini"] = "torrtuginnidragonfrutini",
    ["dragongingerini"] = "brown",
    ["duels"] = "january2026",
    ["duels date"] = "january2026",
    ["duels day"] = "10",
    ["duels machine"] = "january2026",
    ["duels machine date"] = "january2026",
    ["duels machine day"] = "10",
    ["duels machine month"] = "january",
    ["duels machine release"] = "january2026",
    ["duels machine release date"] = "january2026",
    ["duels machine release day"] = "10",
    ["duels machine release month"] = "january",
    ["duels machine release year"] = "2026",
    ["duels machine year"] = "2026",
    ["duels month"] = "january",
    ["duels release"] = "january2026",
    ["duels release date"] = "january2026",
    ["duels release day"] = "10",
    ["duels release month"] = "january",
    ["duels release year"] = "2026",
    ["duels update"] = "january2026",
    ["duels update date"] = "january2026",
    ["duels update day"] = "10",
    ["duels update month"] = "january",
    ["duels update release"] = "january2026",
    ["duels update release date"] = "january2026",
    ["duels update release day"] = "10",
    ["duels update release month"] = "january",
    ["duels update release year"] = "2026",
    ["duels update year"] = "2026",
    ["duels year"] = "2026",
    ["easter"] = "easter",
    ["egg for dragon cannelloni"] = "dragonegg",
    ["egg incubator"] = "april2026",
    ["egg incubator date"] = "april2026",
    ["egg incubator day"] = "4",
    ["egg incubator month"] = "april",
    ["egg incubator release"] = "april2026",
    ["egg incubator release date"] = "april2026",
    ["egg incubator release day"] = "4",
    ["egg incubator release month"] = "april",
    ["egg incubator release year"] = "2026",
    ["egg incubator year"] = "2026",
    ["egg trait incubator"] = "april2026",
    ["egg trait incubator date"] = "april2026",
    ["egg trait incubator day"] = "4",
    ["egg trait incubator month"] = "april",
    ["egg trait incubator release"] = "april2026",
    ["egg trait incubator release date"] = "april2026",
    ["egg trait incubator release day"] = "4",
    ["egg trait incubator release month"] = "april",
    ["egg trait incubator release year"] = "2026",
    ["egg trait incubator year"] = "2026",
    ["eggcity"] = "eggcity",
    ["eid"] = "eid",
    ["elefanto"] = "elefantofrigo",
    ["elefanto frigo color"] = "gray",
    ["elefantofrigo"] = "gray",
    ["emperor"] = "emperor",
    ["enemy"] = "jandel",
    ["escapetsunami"] = "escapetsunami",
    ["esok sekolah"] = "esoksekolah",
    ["esoksekolah"] = "esoksekolah",
    ["event from money ritual"] = "moneymoneypuggy",
    ["event from new ritual"] = "moneymoneypuggy",
    ["event from the money ritual"] = "moneymoneypuggy",
    ["event money"] = "moneymoneypuggy",
    ["event puggy"] = "moneymoneypuggy",
    ["exist count of strawberry elephant"] = "2348",
    ["exist count of strawberry elephants"] = "2348",
    ["expensive"] = "spyderelephant",
    ["expensive brainrot"] = "spyderelephant",
    ["explosive"] = "explosive",
    ["extinct"] = "extinct",
    ["extinct event trait"] = "extinct",
    ["extinct event trait date"] = "september2025",
    ["extinct event trait day"] = "13",
    ["extinct event trait month"] = "september",
    ["extinct event trait release"] = "september2025",
    ["extinct event trait release date"] = "september2025",
    ["extinct event trait release day"] = "13",
    ["extinct event trait release month"] = "september",
    ["extinct event trait release year"] = "2025",
    ["extinct event trait year"] = "2025",
    ["extinct trait"] = "extinct",
    ["extinct trait date"] = "september2025",
    ["extinct trait day"] = "13",
    ["extinct trait month"] = "september",
    ["extinct trait release"] = "september2025",
    ["extinct trait release date"] = "september2025",
    ["extinct trait release day"] = "13",
    ["extinct trait release month"] = "september",
    ["extinct trait release year"] = "2025",
    ["extinct trait year"] = "2025",
    ["fat sammy"] = "fatsammy",
    ["fat sammy date"] = "august2025",
    ["fat sammy day"] = "12",
    ["fat sammy month"] = "august",
    ["fat sammy npc"] = "fatsammy",
    ["fat sammy npc date"] = "august2025",
    ["fat sammy npc day"] = "12",
    ["fat sammy npc month"] = "august",
    ["fat sammy npc release"] = "august2025",
    ["fat sammy npc release date"] = "august2025",
    ["fat sammy npc release day"] = "12",
    ["fat sammy npc release month"] = "august",
    ["fat sammy npc release year"] = "2025",
    ["fat sammy npc year"] = "2025",
    ["fat sammy release"] = "august2025",
    ["fat sammy release date"] = "august2025",
    ["fat sammy release day"] = "12",
    ["fat sammy release month"] = "august",
    ["fat sammy release year"] = "2025",
    ["fat sammy year"] = "2025",
    ["fatsammy"] = "fatsammy",
    ["fav brainrot"] = "meowl",
    ["fav color"] = "blue",
    ["fav food"] = "taco",
    ["fav game"] = "fortnite",
    ["fav mutation"] = "galaxy",
    ["fav mutation date"] = "august2025",
    ["fav mutation day"] = "23",
    ["fav mutation month"] = "august",
    ["fav mutation of sammy"] = "galaxy",
    ["fav mutation release"] = "august2025",
    ["fav mutation release date"] = "august2025",
    ["fav mutation release day"] = "23",
    ["fav mutation release month"] = "august",
    ["fav mutation release year"] = "2025",
    ["fav mutation year"] = "2025",
    ["fav number"] = "67",
    ["fav number of sammy"] = "67",
    ["fav phone"] = "iphone",
    ["favorite artist"] = "drake",
    ["favorite brainrot"] = "meowl",
    ["favorite color"] = "blue",
    ["favorite food"] = "taco",
    ["favorite fortnite"] = "robabankobby",
    ["favorite game"] = "fortnite",
    ["favorite mutation"] = "galaxy",
    ["favorite mutation date"] = "august2025",
    ["favorite mutation day"] = "23",
    ["favorite mutation month"] = "august",
    ["favorite mutation of sammy"] = "galaxy",
    ["favorite mutation release"] = "august2025",
    ["favorite mutation release date"] = "august2025",
    ["favorite mutation release day"] = "23",
    ["favorite mutation release month"] = "august",
    ["favorite mutation release year"] = "2025",
    ["favorite mutation year"] = "2025",
    ["favorite number"] = "67",
    ["favorite number of sammy"] = "67",
    ["favorite phone"] = "iphone",
    ["favorite singer"] = "drake",
    ["favourite artist"] = "drake",
    ["favourite brainrot"] = "meowl",
    ["favourite color"] = "blue",
    ["favourite food"] = "taco",
    ["favourite fortnite"] = "robabankobby",
    ["favourite game"] = "fortnite",
    ["favourite mutation"] = "galaxy",
    ["favourite mutation date"] = "august2025",
    ["favourite mutation day"] = "23",
    ["favourite mutation month"] = "august",
    ["favourite mutation of sammy"] = "galaxy",
    ["favourite mutation release"] = "august2025",
    ["favourite mutation release date"] = "august2025",
    ["favourite mutation release day"] = "23",
    ["favourite mutation release month"] = "august",
    ["favourite mutation release year"] = "2025",
    ["favourite mutation year"] = "2025",
    ["favourite number"] = "67",
    ["favourite number of sammy"] = "67",
    ["favourite phone"] = "iphone",
    ["favourite singer"] = "drake",
    ["fifth fuse"] = "summerfuse",
    ["fifth fuse date"] = "may2026",
    ["fifth fuse day"] = "23",
    ["fifth fuse machine"] = "summerfuse",
    ["fifth fuse machine date"] = "may2026",
    ["fifth fuse machine day"] = "23",
    ["fifth fuse machine month"] = "may",
    ["fifth fuse machine release"] = "may2026",
    ["fifth fuse machine release date"] = "may2026",
    ["fifth fuse machine release day"] = "23",
    ["fifth fuse machine release month"] = "may",
    ["fifth fuse machine release year"] = "2026",
    ["fifth fuse machine year"] = "2026",
    ["fifth fuse month"] = "may",
    ["fifth fuse release"] = "may2026",
    ["fifth fuse release date"] = "may2026",
    ["fifth fuse release day"] = "23",
    ["fifth fuse release month"] = "may",
    ["fifth fuse release year"] = "2026",
    ["fifth fuse year"] = "2026",
    ["fifth og"] = "johnpork",
    ["fifth og brainrot"] = "johnpork",
    ["fire"] = "fire",
    ["fire trait"] = "fire",
    ["fire trait date"] = "june2025",
    ["fire trait month"] = "june",
    ["fire trait release"] = "june2025",
    ["fire trait release date"] = "june2025",
    ["fire trait release month"] = "june",
    ["fire trait release year"] = "2025",
    ["fire trait year"] = "2025",
    ["firework"] = "firework",
    ["firework trait"] = "firework",
    ["firework trait date"] = "july2025",
    ["firework trait day"] = "4",
    ["firework trait month"] = "july",
    ["firework trait release"] = "july2025",
    ["firework trait release date"] = "july2025",
    ["firework trait release day"] = "4",
    ["firework trait release month"] = "july",
    ["firework trait release year"] = "2025",
    ["firework trait year"] = "2025",
    ["fireworks"] = "fireworks",
    ["first bee"] = "beeloco",
    ["first bee brainrot"] = "beeloco",
    ["first bee brainrot in game"] = "beeloco",
    ["first bee brainrot in sab"] = "beeloco",
    ["first bee brainrot in the"] = "beeloco",
    ["first bee brainrot in the game"] = "beeloco",
    ["first bee in game"] = "beeloco",
    ["first bee in sab"] = "beeloco",
    ["first bee in the game"] = "beeloco",
    ["first bee lucky"] = "beeloco",
    ["first bee lucky block"] = "beeloco",
    ["first bee lucky block brainrot"] = "beeloco",
    ["first bee shop"] = "beeloco",
    ["first bee shop brainrot"] = "beeloco",
    ["first bee update"] = "beeloco",
    ["first bee update brainrot"] = "beeloco",
    ["first brainrot"] = "noobinipizzanini",
    ["first brainrot god"] = "tralalerotralala",
    ["first brainrot that got removed"] = "tungtungtungsahur",
    ["first brainrot that was reworked"] = "sammynispyderini",
    ["first craft"] = "september2025",
    ["first craft date"] = "september2025",
    ["first craft day"] = "6",
    ["first craft machine"] = "september2025",
    ["first craft machine date"] = "september2025",
    ["first craft machine day"] = "6",
    ["first craft machine month"] = "september",
    ["first craft machine release"] = "september2025",
    ["first craft machine release date"] = "september2025",
    ["first craft machine release day"] = "6",
    ["first craft machine release month"] = "september",
    ["first craft machine release year"] = "2025",
    ["first craft machine year"] = "2025",
    ["first craft month"] = "september",
    ["first craft release"] = "september2025",
    ["first craft release date"] = "september2025",
    ["first craft release day"] = "6",
    ["first craft release month"] = "september",
    ["first craft release year"] = "2025",
    ["first craft year"] = "2025",
    ["first fuse"] = "lafusemachine",
    ["first fuse date"] = "august2025",
    ["first fuse day"] = "1",
    ["first fuse machine"] = "lafusemachine",
    ["first fuse machine date"] = "august2025",
    ["first fuse machine day"] = "1",
    ["first fuse machine month"] = "august",
    ["first fuse machine release"] = "august2025",
    ["first fuse machine release date"] = "august2025",
    ["first fuse machine release day"] = "1",
    ["first fuse machine release month"] = "august",
    ["first fuse machine release year"] = "2025",
    ["first fuse machine year"] = "2025",
    ["first fuse month"] = "august",
    ["first fuse release"] = "august2025",
    ["first fuse release date"] = "august2025",
    ["first fuse release day"] = "1",
    ["first fuse release month"] = "august",
    ["first fuse release year"] = "2025",
    ["first fuse year"] = "2025",
    ["first game"] = "crabgame",
    ["first game played"] = "crabgame",
    ["first gear"] = "bat",
    ["first god"] = "tralalerotralala",
    ["first item"] = "bat",
    ["first lucky block"] = "july2025",
    ["first lucky block date"] = "july2025",
    ["first lucky block day"] = "12",
    ["first lucky block month"] = "july",
    ["first lucky block release"] = "july2025",
    ["first lucky block release date"] = "july2025",
    ["first lucky block release day"] = "12",
    ["first lucky block release month"] = "july",
    ["first lucky block release year"] = "2025",
    ["first lucky block year"] = "2025",
    ["first machine"] = "rainbowmachine",
    ["first machine added"] = "rainbowmachine",
    ["first machine added date"] = "june2025",
    ["first machine added day"] = "21",
    ["first machine added month"] = "june",
    ["first machine added release"] = "june2025",
    ["first machine added release date"] = "june2025",
    ["first machine added release day"] = "21",
    ["first machine added release month"] = "june",
    ["first machine added release year"] = "2025",
    ["first machine added to sab"] = "rainbowmachine",
    ["first machine added to sab date"] = "june2025",
    ["first machine added to sab day"] = "21",
    ["first machine added to sab month"] = "june",
    ["first machine added to sab release"] = "june2025",
    ["first machine added to sab release date"] = "june2025",
    ["first machine added to sab release day"] = "21",
    ["first machine added to sab release month"] = "june",
    ["first machine added to sab release year"] = "2025",
    ["first machine added to sab year"] = "2025",
    ["first machine added to the game"] = "rainbowmachine",
    ["first machine added to the game date"] = "june2025",
    ["first machine added to the game day"] = "21",
    ["first machine added to the game month"] = "june",
    ["first machine added to the game release"] = "june2025",
    ["first machine added to the game release date"] = "june2025",
    ["first machine added to the game release day"] = "21",
    ["first machine added to the game release month"] = "june",
    ["first machine added to the game release year"] = "2025",
    ["first machine added to the game year"] = "2025",
    ["first machine added year"] = "2025",
    ["first machine date"] = "june2025",
    ["first machine day"] = "21",
    ["first machine game"] = "rainbowmachine",
    ["first machine in game"] = "rainbowmachine",
    ["first machine in game date"] = "june2025",
    ["first machine in game day"] = "21",
    ["first machine in game month"] = "june",
    ["first machine in game release"] = "june2025",
    ["first machine in game release date"] = "june2025",
    ["first machine in game release day"] = "21",
    ["first machine in game release month"] = "june",
    ["first machine in game release year"] = "2025",
    ["first machine in game year"] = "2025",
    ["first machine in sab"] = "rainbowmachine",
    ["first machine in sab date"] = "june2025",
    ["first machine in sab day"] = "21",
    ["first machine in sab month"] = "june",
    ["first machine in sab release"] = "june2025",
    ["first machine in sab release date"] = "june2025",
    ["first machine in sab release day"] = "21",
    ["first machine in sab release month"] = "june",
    ["first machine in sab release year"] = "2025",
    ["first machine in sab year"] = "2025",
    ["first machine in the game"] = "rainbowmachine",
    ["first machine in the game date"] = "june2025",
    ["first machine in the game day"] = "21",
    ["first machine in the game month"] = "june",
    ["first machine in the game release"] = "june2025",
    ["first machine in the game release date"] = "june2025",
    ["first machine in the game release day"] = "21",
    ["first machine in the game release month"] = "june",
    ["first machine in the game release year"] = "2025",
    ["first machine in the game year"] = "2025",
    ["first machine month"] = "june",
    ["first machine release"] = "june2025",
    ["first machine release date"] = "june2025",
    ["first machine release day"] = "21",
    ["first machine release month"] = "june",
    ["first machine release year"] = "2025",
    ["first machine sab"] = "rainbowmachine",
    ["first machine year"] = "2025",
    ["first name of first og"] = "strawberryelephant",
    ["first name og"] = "strawberryelephant",
    ["first og"] = "strawberryelephant",
    ["first og brainrot"] = "strawberryelephant",
    ["first og brainrot in game"] = "strawberryelephant",
    ["first og brainrot in the game"] = "strawberryelephant",
    ["first og brainrot name"] = "strawberryelephant",
    ["first og in game"] = "strawberryelephant",
    ["first og in the game"] = "strawberryelephant",
    ["first og name"] = "strawberryelephant",
    ["first removed brainrot"] = "tungtungtungsahur",
    ["first reworked brainrot"] = "sammynispyderini",
    ["first ritual"] = "comet",
    ["first secret"] = "lavaccasaturnosaturnita",
    ["first secret brainrot"] = "lavaccasaturnosaturnita",
    ["first secret in sab"] = "lavaccasaturnosaturnita",
    ["first secret in sub"] = "lavaccasaturnosaturnita",
    ["first secret in the game"] = "lavaccasaturnosaturnita",
    ["first secret in the game brainrot"] = "lavaccasaturnosaturnita",
    ["first secret sab"] = "lavaccasaturnosaturnita",
    ["first snake"] = "hydraserpent",
    ["first snake added"] = "hydraserpent",
    ["first snake brainrot"] = "hydraserpent",
    ["first snake brainrot added"] = "hydraserpent",
    ["first snake brainrot ever added"] = "hydraserpent",
    ["first snake brainrot in game"] = "hydraserpent",
    ["first snake brainrot in sab"] = "hydraserpent",
    ["first snake brainrot in the game"] = "hydraserpent",
    ["first snake brainrot that was added"] = "hydraserpent",
    ["first snake brainrot that was ever added"] = "hydraserpent",
    ["first snake ever added"] = "hydraserpent",
    ["first snake in game"] = "hydraserpent",
    ["first snake in sab"] = "hydraserpent",
    ["first snake in the game"] = "hydraserpent",
    ["first snake that was added"] = "hydraserpent",
    ["first snake that was ever added"] = "hydraserpent",
    ["first taco"] = "tipitopitaco",
    ["first taco brainrot"] = "tipitopitaco",
    ["first taco brainrot in the game"] = "tipitopitaco",
    ["first taco in the game"] = "tipitopitaco",
    ["first taco merchant"] = "sammynitruckini",
    ["first taco secret"] = "lacucaracha",
    ["first weapon"] = "bat",
    ["flying b"] = "flyingbee",
    ["flying b gear"] = "flyingbee",
    ["flying bee"] = "flyingbee",
    ["flying bee gear"] = "flyingbee",
    ["flyingbee"] = "flyingbee",
    ["flyingbee gear"] = "flyingbee",
    ["food"] = "food",
    ["fortnite"] = "fortnite",
    ["fortnite obby"] = "robabankobby",
    ["fourth 3 headed"] = "hydraserpent",
    ["fourth 3 headed brainrot"] = "hydraserpent",
    ["fourth 3 headed brainrot added"] = "hydraserpent",
    ["fourth 3 headed brainrot in game"] = "hydraserpent",
    ["fourth 3 headed brainrot in the game"] = "hydraserpent",
    ["fourth best taco merchant"] = "burritobat",
    ["fourth fuse"] = "divinefuse",
    ["fourth fuse date"] = "march2026",
    ["fourth fuse day"] = "7",
    ["fourth fuse machine"] = "divinefuse",
    ["fourth fuse machine date"] = "march2026",
    ["fourth fuse machine day"] = "7",
    ["fourth fuse machine month"] = "march",
    ["fourth fuse machine release"] = "march2026",
    ["fourth fuse machine release date"] = "march2026",
    ["fourth fuse machine release day"] = "7",
    ["fourth fuse machine release month"] = "march",
    ["fourth fuse machine release year"] = "2026",
    ["fourth fuse machine year"] = "2026",
    ["fourth fuse month"] = "march",
    ["fourth fuse release"] = "march2026",
    ["fourth fuse release date"] = "march2026",
    ["fourth fuse release day"] = "7",
    ["fourth fuse release month"] = "march",
    ["fourth fuse release year"] = "2026",
    ["fourth fuse year"] = "2026",
    ["fourth headed"] = "hydraserpent",
    ["fourth og"] = "headlesshorseman",
    ["fourth og brainrot"] = "headlesshorseman",
    ["fourth taco merchant"] = "burritobat",
    ["fourth three headed"] = "hydraserpent",
    ["fourth three headed brainrot"] = "hydraserpent",
    ["fourth three headed brainrot added"] = "hydraserpent",
    ["fourth three headed brainrot in game"] = "hydraserpent",
    ["fourth three headed brainrot in sab"] = "hydraserpent",
    ["fourth three headed brainrot in the game"] = "hydraserpent",
    ["friend food name"] = "steak",
    ["friend that is a youtuber that has food in his name"] = "steak",
    ["friend that is a youtuber that has food in name"] = "steak",
    ["friend that is a youtuber with food"] = "steak",
    ["friend that is a youtuber with food in his name"] = "steak",
    ["friend that is a youtuber with food in name"] = "steak",
    ["friend with food in his name"] = "steak",
    ["friend with food in name"] = "steak",
    ["friend youtuber"] = "steak",
    ["friend youtuber food"] = "steak",
    ["friend youtuber that has food in his name"] = "steak",
    ["friend youtuber with food in his name"] = "steak",
    ["frigo"] = "elefantofrigo",
    ["from what egg can you get dragon cannelloni"] = "dragonegg",
    ["from what egg can you obtain dragon cannelloni"] = "dragonegg",
    ["from what egg you can get dragon cannelloni"] = "dragonegg",
    ["from what egg you can obtain dragon cannelloni"] = "dragonegg",
    ["from what island can you obtain draculino"] = "caveisland",
    ["from what island you can obtain draculino"] = "caveisland",
    ["from which egg can you obtain dragon cannelloni"] = "dragonegg",
    ["full name"] = "sammy",
    ["fuse"] = "lafusemachine",
    ["fuse date"] = "august2025",
    ["fuse day"] = "1",
    ["fuse machine"] = "lafusemachine",
    ["fuse machine coming next"] = "hauntedfuse",
    ["fuse machine date"] = "august2025",
    ["fuse machine day"] = "1",
    ["fuse machine month"] = "august",
    ["fuse machine original"] = "lafusemachine",
    ["fuse machine original date"] = "august2025",
    ["fuse machine original day"] = "1",
    ["fuse machine original month"] = "august",
    ["fuse machine original release"] = "august2025",
    ["fuse machine original release date"] = "august2025",
    ["fuse machine original release day"] = "1",
    ["fuse machine original release month"] = "august",
    ["fuse machine original release year"] = "2025",
    ["fuse machine original year"] = "2025",
    ["fuse machine release"] = "august2025",
    ["fuse machine release date"] = "august2025",
    ["fuse machine release day"] = "1",
    ["fuse machine release month"] = "august",
    ["fuse machine release year"] = "2025",
    ["fuse machine return"] = "january2026",
    ["fuse machine return date"] = "january2026",
    ["fuse machine return day"] = "24",
    ["fuse machine return month"] = "january",
    ["fuse machine return release"] = "january2026",
    ["fuse machine return release date"] = "january2026",
    ["fuse machine return release day"] = "24",
    ["fuse machine return release month"] = "january",
    ["fuse machine return release year"] = "2026",
    ["fuse machine return year"] = "2026",
    ["fuse machine year"] = "2025",
    ["fuse month"] = "august",
    ["fuse release"] = "august2025",
    ["fuse release date"] = "august2025",
    ["fuse release day"] = "1",
    ["fuse release month"] = "august",
    ["fuse release year"] = "2025",
    ["fuse return"] = "january2026",
    ["fuse return date"] = "january2026",
    ["fuse return day"] = "24",
    ["fuse return month"] = "january",
    ["fuse return release"] = "january2026",
    ["fuse return release date"] = "january2026",
    ["fuse return release day"] = "24",
    ["fuse return release month"] = "january",
    ["fuse return release year"] = "2026",
    ["fuse return year"] = "2026",
    ["fuse year"] = "2025",
    ["futbol"] = "futbol",
    ["galactic"] = "galactic",
    ["galaxy"] = "galaxy",
    ["galaxy date"] = "august2025",
    ["galaxy day"] = "23",
    ["galaxy month"] = "august",
    ["galaxy mutation"] = "galaxy",
    ["galaxy mutation date"] = "august2025",
    ["galaxy mutation day"] = "23",
    ["galaxy mutation month"] = "august",
    ["galaxy mutation release"] = "august2025",
    ["galaxy mutation release date"] = "august2025",
    ["galaxy mutation release day"] = "23",
    ["galaxy mutation release month"] = "august",
    ["galaxy mutation release year"] = "2025",
    ["galaxy mutation year"] = "2025",
    ["galaxy release"] = "august2025",
    ["galaxy release date"] = "august2025",
    ["galaxy release day"] = "23",
    ["galaxy release month"] = "august",
    ["galaxy release year"] = "2025",
    ["galaxy year"] = "2025",
    ["game am i a competitive player at"] = "valorant",
    ["game am i competitive at"] = "valorant",
    ["game am i competitive in"] = "valorant",
    ["game am i competitive player at"] = "valorant",
    ["game better than 1 speed keyboard escape"] = "growagarden",
    ["game better than 1speedkeyboardescape"] = "growagarden",
    ["game competitive"] = "valorant",
    ["game created"] = "may2025",
    ["game created date"] = "may2025",
    ["game created day"] = "16",
    ["game created month"] = "may",
    ["game created release"] = "may2025",
    ["game created release date"] = "may2025",
    ["game created release day"] = "16",
    ["game created release month"] = "may",
    ["game created release year"] = "2025",
    ["game created year"] = "2025",
    ["game enjoy"] = "fortnite",
    ["game favorite"] = "fortnite",
    ["game favourite"] = "fortnite",
    ["game hate"] = "growagarden",
    ["game hate most"] = "growagarden",
    ["game hates"] = "growagarden",
    ["game hates most"] = "growagarden",
    ["game i am competitive at"] = "valorant",
    ["game i am competitive player at"] = "valorant",
    ["game i enjoy playing"] = "fortnite",
    ["game i hate"] = "growagarden",
    ["game i hate most"] = "growagarden",
    ["game i hate the most"] = "growagarden",
    ["game i like the most"] = "fortnite",
    ["game i like to play"] = "fortnite",
    ["game i love"] = "fortnite",
    ["game i love the most"] = "fortnite",
    ["game i love to play"] = "fortnite",
    ["game i play competitive"] = "valorant",
    ["game i play competitively"] = "valorant",
    ["game launched"] = "may2025",
    ["game launched date"] = "may2025",
    ["game launched day"] = "16",
    ["game launched month"] = "may",
    ["game launched release"] = "may2025",
    ["game launched release date"] = "may2025",
    ["game launched release day"] = "16",
    ["game launched release month"] = "may",
    ["game launched release year"] = "2025",
    ["game launched year"] = "2025",
    ["game like play"] = "fortnite",
    ["game likes play"] = "fortnite",
    ["game love"] = "fortnite",
    ["game love play"] = "fortnite",
    ["game loves"] = "fortnite",
    ["game loves play"] = "fortnite",
    ["game made"] = "may2025",
    ["game made date"] = "may2025",
    ["game made day"] = "16",
    ["game made month"] = "may",
    ["game made release"] = "may2025",
    ["game made release date"] = "may2025",
    ["game made release day"] = "16",
    ["game made release month"] = "may",
    ["game made release year"] = "2025",
    ["game made year"] = "2025",
    ["game release"] = "may2025",
    ["game release date"] = "may2025",
    ["game release day"] = "16",
    ["game release month"] = "may",
    ["game release release"] = "may2025",
    ["game release release date"] = "may2025",
    ["game release release day"] = "16",
    ["game release release month"] = "may",
    ["game release release year"] = "2025",
    ["game release year"] = "2025",
    ["game released"] = "may2025",
    ["game released date"] = "may2025",
    ["game released day"] = "16",
    ["game released month"] = "may",
    ["game released release"] = "may2025",
    ["game released release date"] = "may2025",
    ["game released release day"] = "16",
    ["game released release month"] = "may",
    ["game released release year"] = "2025",
    ["game released year"] = "2025",
    ["game sammy hates"] = "growagarden",
    ["game sammy hates most"] = "growagarden",
    ["game sammy hates the most"] = "growagarden",
    ["game sammy is competitive player at"] = "valorant",
    ["game sammy likes the most"] = "fortnite",
    ["game sammy likes to play"] = "fortnite",
    ["game sammy loves"] = "fortnite",
    ["game sammy loves the most"] = "fortnite",
    ["game sammy loves to play"] = "fortnite",
    ["game sammy plays competitively"] = "valorant",
    ["game that is better than 1 speed keyboard escape"] = "growagarden",
    ["game that is better than 1 speed keyboard escape is grow a garden"] = "growagarden",
    ["game that is better than 1 speed keyboard escape is growagarden"] = "growagarden",
    ["game that is better than 1speedkeyboardescape"] = "growagarden",
    ["game that is better than 1speedkeyboardescape is growagarden"] = "growagarden",
    ["game that is worse than grow a garden"] = "1speedkeyboardescape",
    ["game that is worse than grow a garden is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["game that is worse than grow a garden is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["game that is worse than growagarden"] = "1speedkeyboardescape",
    ["game that is worser than grow a garden"] = "1speedkeyboardescape",
    ["game that is worser than grow a garden is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["game that is worser than grow a garden is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["game that is worser than growagarden"] = "1speedkeyboardescape",
    ["game worse than grow a garden"] = "1speedkeyboardescape",
    ["game worse than growagarden"] = "1speedkeyboardescape",
    ["game worser than grow a garden"] = "1speedkeyboardescape",
    ["game worser than growagarden"] = "1speedkeyboardescape",
    ["garama"] = "garamaandmadundung",
    ["garama and madundung color"] = "gray",
    ["garamaandmadundung"] = "gray",
    ["garamaandmadungdung"] = "garamaandmadundung",
    ["gatito tacoto"] = "gattitotacoto",
    ["gattatino nyanino"] = "gattatinonyanino",
    ["gattatinonyanino"] = "gattatinonyanino",
    ["gattito tacoto"] = "gattitotacoto",
    ["gattitotacoto"] = "gattitotacoto",
    ["gingerbread"] = "dragongingerini",
    ["gingerbreaddragon"] = "dragongingerini",
    ["gingerini"] = "DragonGingerini",
    ["glitch"] = "glitch",
    ["glitch trait"] = "glitch",
    ["glitch trait date"] = "june2025",
    ["glitch trait month"] = "june",
    ["glitch trait release"] = "june2025",
    ["glitch trait release date"] = "june2025",
    ["glitch trait release month"] = "june",
    ["glitch trait release year"] = "2025",
    ["glitch trait year"] = "2025",
    ["glitched trait"] = "glitch",
    ["glitched trait date"] = "june2025",
    ["glitched trait month"] = "june",
    ["glitched trait release"] = "june2025",
    ["glitched trait release date"] = "june2025",
    ["glitched trait release month"] = "june",
    ["glitched trait release year"] = "2025",
    ["glitched trait year"] = "2025",
    ["gold strawberry elephant exist"] = "565",
    ["gold strawberry elephant exist count"] = "565",
    ["gold strawberry elephants exist"] = "565",
    ["granny"] = "granny",
    ["granny trait"] = "granny",
    ["granny trait date"] = "march2026",
    ["granny trait day"] = "21",
    ["granny trait month"] = "march",
    ["granny trait release"] = "march2026",
    ["granny trait release date"] = "march2026",
    ["granny trait release day"] = "21",
    ["granny trait release month"] = "march",
    ["granny trait release year"] = "2026",
    ["granny trait year"] = "2026",
    ["gray"] = "gray",
    ["green"] = "green",
    ["green egg trait"] = "greenegg",
    ["green egg trait date"] = "april2026",
    ["green egg trait month"] = "april",
    ["green egg trait release"] = "april2026",
    ["green egg trait release date"] = "april2026",
    ["green egg trait release month"] = "april",
    ["green egg trait release year"] = "2026",
    ["green egg trait year"] = "2026",
    ["greenballoon"] = "greenballoon",
    ["greenegg"] = "greenegg",
    ["griefshield"] = "griefshield",
    ["griffin"] = "griffin",
    ["griffin color"] = "white",
    ["group"] = "brazilianspyder",
    ["group hate"] = "secretverse",
    ["group hate most"] = "secretverse",
    ["group hates"] = "secretverse",
    ["group hates most"] = "secretverse",
    ["group i hate"] = "secretverse",
    ["group i hate most"] = "secretverse",
    ["group i hate the most"] = "secretverse",
    ["group sammy hates"] = "secretverse",
    ["group sammy hates most"] = "secretverse",
    ["group sammy hates the most"] = "secretverse",
    ["grow a garden"] = "growagarden",
    ["grow garden"] = "growagarden",
    ["growagarden"] = "growagarden",
    ["hair"] = "black",
    ["hair color"] = "black",
    ["hair colour"] = "black",
    ["Strawberry"] = "Strawberry",
    ["Strawberry fuse"] = "hauntedfuse",
    ["Strawberry fuse machine"] = "hauntedfuse",
    ["halo"] = "halo",
    ["halo trait"] = "halo",
    ["halo trait date"] = "february2026",
    ["halo trait month"] = "february",
    ["halo trait release"] = "february2026",
    ["halo trait release date"] = "february2026",
    ["halo trait release month"] = "february",
    ["halo trait release year"] = "2026",
    ["halo trait year"] = "2026",
    ["hardest brainrot"] = "spyderelephant",
    ["hardest brainrot in game"] = "spyderelephant",
    ["hardest brainrot in the game"] = "spyderelephant",
    ["hardest brainrot to find"] = "spyderelephant",
    ["hardest brainrot to get"] = "spyderelephant",
    ["hardest brainrot to get in game"] = "spyderelephant",
    ["hardest brainrot to get in the game"] = "spyderelephant",
    ["hardest brainrot to obtain"] = "spyderelephant",
    ["hardest to get"] = "spyderelephant",
    ["hated game"] = "growagarden",
    ["hated group"] = "secretverse",
    ["hated person"] = "secretlokii",
    ["hated studio"] = "secretverse",
    ["hauntedfuse"] = "hauntedfuse",
    ["he began making games on roblox in"] = "2013",
    ["he began making games on roblox in 2013"] = "2013",
    ["he began making games on roblox in 2013 release year"] = "2013",
    ["he began making games on roblox in 2013 year"] = "2013",
    ["he began making games on roblox in release year"] = "2013",
    ["he began making games on roblox in year"] = "2013",
    ["headless"] = "headlesshorseman",
    ["headless horseman added"] = "february2026",
    ["headless horseman color"] = "black",
    ["headless horseman date"] = "february2026",
    ["headless horseman day"] = "1",
    ["headless horseman month"] = "february",
    ["headless horseman release"] = "february2026",
    ["headless horseman release date"] = "february2026",
    ["headless horseman release day"] = "1",
    ["headless horseman release month"] = "february",
    ["headless horseman release year"] = "2026",
    ["headless horseman released"] = "february2026",
    ["headless horseman year"] = "2026",
    ["headlesshorseman"] = "headlesshorseman",
    ["headlesshorseman date"] = "february2026",
    ["headlesshorseman day"] = "1",
    ["headlesshorseman month"] = "february",
    ["headlesshorseman release"] = "february2026",
    ["headlesshorseman release date"] = "february2026",
    ["headlesshorseman release day"] = "1",
    ["headlesshorseman release month"] = "february",
    ["headlesshorseman release year"] = "2026",
    ["headlesshorseman year"] = "2026",
    ["hello"] = "hello",
    ["hey"] = "hey",
    ["hi"] = "hi",
    ["highest mutation"] = "crystal",
    ["his favorite game is fortnite"] = "fortnite",
    ["his favourite game is fortnite"] = "fortnite",
    ["his roblox avatar color"] = "red",
    ["horseman"] = "HeadlessHorseman",
    ["hotspotsitos"] = "losnooomyhotspotsitos",
    ["how many 1 1"] = "155",
    ["how many 1 of 1"] = "155",
    ["how many 1 of 1 brainrots"] = "155",
    ["how many 1 of 1 brainrots exist"] = "155",
    ["how many 1 of 1 exist"] = "155",
    ["how many 1 of 1s"] = "155",
    ["how many 1 of 1s brainrots"] = "155",
    ["how many 1 of 1s brainrots exist"] = "155",
    ["how many 1 of 1s exist"] = "155",
    ["how many 1of1"] = "155",
    ["how many 1of1 brainrots"] = "155",
    ["how many 1of1 brainrots exist"] = "155",
    ["how many 1of1 exist"] = "155",
    ["how many 1of1s"] = "155",
    ["how many 1of1s brainrots"] = "155",
    ["how many 1of1s brainrots exist"] = "155",
    ["how many 1of1s exist"] = "155",
    ["how many are there 1 of 1 brainrots"] = "155",
    ["how many are there 1 of 1s brainrots"] = "155",
    ["how many base strawberry elephant exist"] = "1277",
    ["how many base strawberry elephants exist"] = "1277",
    ["how many crystal strawberry elephant exist"] = "1",
    ["how many crystal strawberry elephants exist"] = "1",
    ["how many diamond strawberry elephant exist"] = "263",
    ["how many diamond strawberry elephants exist"] = "263",
    ["how many gold strawberry elephant exist"] = "565",
    ["how many gold strawberry elephants exist"] = "565",
    ["how many is there 1 of 1"] = "155",
    ["how many is there 1 of 1 brainrots"] = "155",
    ["how many is there 1 of 1s"] = "155",
    ["how many is there 1 of 1s brainrots"] = "155",
    ["how many is there one of one brainrots"] = "155",
    ["how many normal strawberry elephant exist"] = "1277",
    ["how many normal strawberry elephants exist"] = "1277",
    ["how many one of one"] = "155",
    ["how many one of one brainrots"] = "155",
    ["how many one of ones"] = "155",
    ["how many rainbow strawberry elephant exist"] = "87",
    ["how many rainbow strawberry elephants exist"] = "87",
    ["how many strawberry elephant exist"] = "2348",
    ["how many strawberry elephant exists"] = "2348",
    ["how many strawberry elephant in the game exist"] = "2348",
    ["how many strawberry elephant that exist"] = "2348",
    ["how many strawberry elephants exist"] = "2348",
    ["how many strawberry elephants exists"] = "2348",
    ["how many strawberry elephants in the game exist"] = "2348",
    ["how many strawberry elephants that exist"] = "2348",
    ["how many total 1 of 1"] = "155",
    ["how many total 1 of 1 brainrots exist"] = "155",
    ["how many total 1 of 1s"] = "155",
    ["how many total 1 of 1s exist"] = "155",
    ["how many total strawberry elephant exist"] = "2348",
    ["how many total strawberry elephants exist"] = "2348",
    ["how much 1 1"] = "155",
    ["how much 1 of 1"] = "155",
    ["how much 1 of 1 brainrots"] = "155",
    ["how much 1 of 1 exist"] = "155",
    ["how much 1 of 1s"] = "155",
    ["how much 1 of 1s brainrots"] = "155",
    ["how much 1 of 1s exist"] = "155",
    ["how much 1of1"] = "155",
    ["how much 1of1 brainrots"] = "155",
    ["how much 1of1 exist"] = "155",
    ["how much 1of1s"] = "155",
    ["how much 1of1s brainrots"] = "155",
    ["how much 1of1s exist"] = "155",
    ["how much are there 1 of 1 brainrots"] = "155",
    ["how much are there 1 of 1s brainrots"] = "155",
    ["how much is there 1 of 1"] = "155",
    ["how much is there 1 of 1 brainrots"] = "155",
    ["how much is there 1 of 1s"] = "155",
    ["how much is there 1 of 1s brainrots"] = "155",
    ["how much is there 1of1 brainrots"] = "155",
    ["how much is there 1of1s brainrots"] = "155",
    ["how much is there one of one brainrots"] = "155",
    ["how much one of one"] = "155",
    ["how much one of one brainrots"] = "155",
    ["how much one of ones"] = "155",
    ["how much weigh"] = "250",
    ["how old"] = "24",
    ["howdy"] = "howdy",
    ["hydra"] = "hydraserpent",
    ["hydra bunny color"] = "white",
    ["hydra dragon cannelloni color"] = "yellow",
    ["hydra serpent"] = "hydraserpent",
    ["hydra serpent color"] = "green",
    ["hydrabunny"] = "hydrabunny",
    ["hydrabunnyegg"] = "hydrabunnyegg",
    ["hydradragon"] = "hydradragoncannelloni",
    ["hydradragoncannelloni"] = "yellow",
    ["hydrarabbit"] = "hydrabunny",
    ["hydraserpent"] = "hydraserpent",
    ["i am a competitive player at"] = "valorant",
    ["i am a competitive player at valorant"] = "valorant",
    ["i am competitive at"] = "valorant",
    ["i am competitive player at"] = "valorant",
    ["i am competitive player at valorant"] = "valorant",
    ["i began making games"] = "2013",
    ["i began making games in roblox"] = "2013",
    ["i began making games in roblox release year"] = "2013",
    ["i began making games in roblox year"] = "2013",
    ["i began making games on roblox"] = "2013",
    ["i began making games on roblox in"] = "2013",
    ["i began making games on roblox in 2013"] = "2013",
    ["i began making games on roblox in 2013 release year"] = "2013",
    ["i began making games on roblox in 2013 year"] = "2013",
    ["i began making games on roblox in release year"] = "2013",
    ["i began making games on roblox in year"] = "2013",
    ["i began making games on roblox release year"] = "2013",
    ["i began making games on roblox year"] = "2013",
    ["i began making games release year"] = "2013",
    ["i began making games year"] = "2013",
    ["i love to play"] = "fortnite",
    ["i started making games"] = "2013",
    ["i started making games in roblox"] = "2013",
    ["i started making games in roblox release year"] = "2013",
    ["i started making games in roblox year"] = "2013",
    ["i started making games on roblox"] = "2013",
    ["i started making games on roblox in"] = "2013",
    ["i started making games on roblox in 2013"] = "2013",
    ["i started making games on roblox in 2013 release year"] = "2013",
    ["i started making games on roblox in 2013 year"] = "2013",
    ["i started making games on roblox in release year"] = "2013",
    ["i started making games on roblox in year"] = "2013",
    ["i started making games on roblox release year"] = "2013",
    ["i started making games on roblox year"] = "2013",
    ["i started making games release year"] = "2013",
    ["i started making games year"] = "2013",
    ["icedragon"] = "blue",
    ["incubator machine"] = "april2026",
    ["incubator machine date"] = "april2026",
    ["incubator machine day"] = "4",
    ["incubator machine month"] = "april",
    ["incubator machine release"] = "april2026",
    ["incubator machine release date"] = "april2026",
    ["incubator machine release day"] = "4",
    ["incubator machine release month"] = "april",
    ["incubator machine release year"] = "2026",
    ["incubator machine year"] = "2026",
    ["indonesia"] = "indonesia",
    ["indonesia trait"] = "indonesia",
    ["indonesia trait date"] = "june2025",
    ["indonesia trait month"] = "june",
    ["indonesia trait release"] = "june2025",
    ["indonesia trait release date"] = "june2025",
    ["indonesia trait release month"] = "june",
    ["indonesia trait release year"] = "2025",
    ["indonesia trait year"] = "2025",
    ["iphone"] = "iphone",
    ["jack o lantern trait"] = "jackolantern",
    ["jack o lantern trait date"] = "october2025",
    ["jack o lantern trait month"] = "october",
    ["jack o lantern trait release"] = "october2025",
    ["jack o lantern trait release date"] = "october2025",
    ["jack o lantern trait release month"] = "october",
    ["jack o lantern trait release year"] = "2025",
    ["jack o lantern trait year"] = "2025",
    ["jackolantern"] = "jackolantern",
    ["jackolantern trait"] = "jackolantern",
    ["jackolantern trait date"] = "october2025",
    ["jackolantern trait month"] = "october",
    ["jackolantern trait release"] = "october2025",
    ["jackolantern trait release date"] = "october2025",
    ["jackolantern trait release month"] = "october",
    ["jackolantern trait release year"] = "2025",
    ["jackolantern trait year"] = "2025",
    ["jandel"] = "jandel",
    ["job ritual"] = "job",
    ["job sahur ritual"] = "job",
    ["jobapplication"] = "jobapplication",
    ["john pork added"] = "may2026",
    ["john pork color"] = "pink",
    ["john pork date"] = "may2026",
    ["john pork day"] = "1",
    ["john pork month"] = "may",
    ["john pork release"] = "may2026",
    ["john pork release date"] = "may2026",
    ["john pork release day"] = "1",
    ["john pork release month"] = "may",
    ["john pork release year"] = "2026",
    ["john pork released"] = "may2026",
    ["john pork year"] = "2026",
    ["johnpork"] = "johnpork",
    ["johnpork date"] = "may2026",
    ["johnpork day"] = "1",
    ["johnpork month"] = "may",
    ["johnpork release"] = "may2026",
    ["johnpork release date"] = "may2026",
    ["johnpork release day"] = "1",
    ["johnpork release month"] = "may",
    ["johnpork release year"] = "2026",
    ["johnpork year"] = "2026",
    ["kraken"] = "red",
    ["kraken color"] = "red",
    ["la cucaracha"] = "lacucaracha",
    ["la secret combinasion"] = "lasecretcombinasion",
    ["la taco combinasion"] = "latacocombinasion",
    ["lacucaracha"] = "lacucaracha",
    ["lafusemachine"] = "lafusemachine",
    ["lasecretcombinasion"] = "lasecretcombinasion",
    ["last craft"] = "cybercraft",
    ["last craft date"] = "april2026",
    ["last craft day"] = "18",
    ["last craft in game"] = "cybercraft",
    ["last craft in sab"] = "cybercraft",
    ["last craft in the game"] = "cybercraft",
    ["last craft machine"] = "cybercraft",
    ["last craft machine date"] = "april2026",
    ["last craft machine day"] = "18",
    ["last craft machine in game"] = "cybercraft",
    ["last craft machine in sab"] = "cybercraft",
    ["last craft machine in the game"] = "cybercraft",
    ["last craft machine month"] = "april",
    ["last craft machine release"] = "april2026",
    ["last craft machine release date"] = "april2026",
    ["last craft machine release day"] = "18",
    ["last craft machine release month"] = "april",
    ["last craft machine release year"] = "2026",
    ["last craft machine year"] = "2026",
    ["last craft month"] = "april",
    ["last craft release"] = "april2026",
    ["last craft release date"] = "april2026",
    ["last craft release day"] = "18",
    ["last craft release month"] = "april",
    ["last craft release year"] = "2026",
    ["last craft year"] = "2026",
    ["last fuse"] = "rainbowfuse",
    ["last fuse date"] = "june2025",
    ["last fuse day"] = "21",
    ["last fuse machine"] = "rainbowfuse",
    ["last fuse machine date"] = "june2025",
    ["last fuse machine day"] = "21",
    ["last fuse machine month"] = "june",
    ["last fuse machine release"] = "june2025",
    ["last fuse machine release date"] = "june2025",
    ["last fuse machine release day"] = "21",
    ["last fuse machine release month"] = "june",
    ["last fuse machine release year"] = "2025",
    ["last fuse machine year"] = "2025",
    ["last fuse month"] = "june",
    ["last fuse release"] = "june2025",
    ["last fuse release date"] = "june2025",
    ["last fuse release day"] = "21",
    ["last fuse release month"] = "june",
    ["last fuse release year"] = "2025",
    ["last fuse year"] = "2025",
    ["last host admin abuse"] = "jandel",
    ["last mutation"] = "crystal",
    ["last name"] = "brakta",
    ["last person admin abuse"] = "jandel",
    ["last ritual"] = "money",
    ["last taco"] = "latacocombinasion",
    ["last taco brainrot"] = "latacocombinasion",
    ["last taco secret"] = "chipsoandqueso",
    ["lataco"] = "LaTacoCombinasion",
    ["latacocombinasion"] = "latacocombinasion",
    ["latest base"] = "emperor",
    ["latest base skin"] = "1of1",
    ["latest brainrot"] = "hydraserpent",
    ["latest brainrot last saturday"] = "orchidox",
    ["latest brainrot last week"] = "orchidox",
    ["latest craft"] = "cybercraft",
    ["latest craft date"] = "april2026",
    ["latest craft day"] = "18",
    ["latest craft machine"] = "cybercraft",
    ["latest craft machine date"] = "april2026",
    ["latest craft machine day"] = "18",
    ["latest craft machine month"] = "april",
    ["latest craft machine release"] = "april2026",
    ["latest craft machine release date"] = "april2026",
    ["latest craft machine release day"] = "18",
    ["latest craft machine release month"] = "april",
    ["latest craft machine release year"] = "2026",
    ["latest craft machine year"] = "2026",
    ["latest craft month"] = "april",
    ["latest craft release"] = "april2026",
    ["latest craft release date"] = "april2026",
    ["latest craft release day"] = "18",
    ["latest craft release month"] = "april",
    ["latest craft release year"] = "2026",
    ["latest craft year"] = "2026",
    ["latest fuse"] = "rainbowfuse",
    ["latest fuse date"] = "june2025",
    ["latest fuse day"] = "21",
    ["latest fuse machine"] = "rainbowfuse",
    ["latest fuse machine date"] = "june2025",
    ["latest fuse machine day"] = "21",
    ["latest fuse machine month"] = "june",
    ["latest fuse machine release"] = "june2025",
    ["latest fuse machine release date"] = "june2025",
    ["latest fuse machine release day"] = "21",
    ["latest fuse machine release month"] = "june",
    ["latest fuse machine release year"] = "2025",
    ["latest fuse machine year"] = "2025",
    ["latest fuse month"] = "june",
    ["latest fuse release"] = "june2025",
    ["latest fuse release date"] = "june2025",
    ["latest fuse release day"] = "21",
    ["latest fuse release month"] = "june",
    ["latest fuse release year"] = "2025",
    ["latest fuse year"] = "2025",
    ["latest mythical creature brainrot"] = "hydraserpent",
    ["latest ritual"] = "money",
    ["latest snake"] = "hydraserpent",
    ["latest snake brainrot"] = "hydraserpent",
    ["latest taco secret"] = "chipsoandqueso",
    ["lava"] = "lava",
    ["lava mutation"] = "lava",
    ["lava mutation date"] = "july2025",
    ["lava mutation day"] = "25",
    ["lava mutation month"] = "july",
    ["lava mutation release"] = "july2025",
    ["lava mutation release date"] = "july2025",
    ["lava mutation release day"] = "25",
    ["lava mutation release month"] = "july",
    ["lava mutation release year"] = "2025",
    ["lava mutation year"] = "2025",
    ["lavacca"] = "lavaccasaturnosaturnita",
    ["lavacca saturno saturnita"] = "lavaccasaturnosaturnita",
    ["lavaccasaturno"] = "LaVaccaSaturnoSaturnita",
    ["lavaccasaturnosaturnita"] = "lavaccasaturnosaturnita",
    ["lavaka"] = "lavaccasaturnosaturnita",
    ["lavaka saturno saturnita"] = "lavaccasaturnosaturnita",
    ["lavakasaturnosaturnita"] = "lavaccasaturnosaturnita",
    ["least exist brainrot"] = "polaroidini",
    ["least fav brainrot"] = "raccoonijandelini",
    ["least fav game"] = "growagarden",
    ["least fav group"] = "secretverse",
    ["least fav person"] = "secretlokii",
    ["least fav studio"] = "secretverse",
    ["least favorite brain"] = "raccoonijandelini",
    ["least favorite brainrot"] = "raccoonijandelini",
    ["least favorite game"] = "growagarden",
    ["least favorite group"] = "secretverse",
    ["least favorite person"] = "secretlokii",
    ["least favorite studio"] = "secretverse",
    ["least favourite brainrot"] = "raccoonijandelini",
    ["least favourite game"] = "growagarden",
    ["least favourite group"] = "secretverse",
    ["least favourite person"] = "secretlokii",
    ["least favourite studio"] = "secretverse",
    ["lightning"] = "lightning",
    ["live"] = "usa",
    ["los burritos"] = "losburritos",
    ["los chihuaninis"] = "loschihuaninis",
    ["los cucarachas"] = "loscucarachas",
    ["los noo my hotspotsitos"] = "losnooomyhotspotsitos",
    ["los nooo my hotspotsitos"] = "losnooomyhotspotsitos",
    ["los puggies"] = "lospuggies",
    ["los quesadillas"] = "losquesadillas",
    ["los taco block"] = "november2025",
    ["los taco block date"] = "november2025",
    ["los taco block day"] = "18",
    ["los taco block month"] = "november",
    ["los taco block release"] = "november2025",
    ["los taco block release date"] = "november2025",
    ["los taco block release day"] = "18",
    ["los taco block release month"] = "november",
    ["los taco block release year"] = "2025",
    ["los taco block year"] = "2025",
    ["los taco blocks"] = "november2025",
    ["los taco blocks date"] = "november2025",
    ["los taco blocks day"] = "18",
    ["los taco blocks month"] = "november",
    ["los taco blocks release"] = "november2025",
    ["los taco blocks release date"] = "november2025",
    ["los taco blocks release day"] = "18",
    ["los taco blocks release month"] = "november",
    ["los taco blocks release year"] = "2025",
    ["los taco blocks year"] = "2025",
    ["los tacoritas"] = "lostacoritas",
    ["los tipi tacos"] = "lostipitacos",
    ["los trader"] = "june2026",
    ["los trader date"] = "june2026",
    ["los trader day"] = "11",
    ["los trader month"] = "june",
    ["los trader release"] = "june2026",
    ["los trader release date"] = "june2026",
    ["los trader release day"] = "11",
    ["los trader release month"] = "june",
    ["los trader release year"] = "2026",
    ["los trader year"] = "2026",
    ["los traders"] = "june2026",
    ["los traders date"] = "june2026",
    ["los traders day"] = "11",
    ["los traders month"] = "june",
    ["los traders release"] = "june2026",
    ["los traders release date"] = "june2026",
    ["los traders release day"] = "11",
    ["los traders release month"] = "june",
    ["los traders release year"] = "2026",
    ["los traders year"] = "2026",
    ["losburritos"] = "losburritos",
    ["loschihuaninis"] = "loschihuaninis",
    ["loscucarachas"] = "loscucarachas",
    ["losdragons"] = "yellow",
    ["losnooomyhotspotsitos"] = "losnooomyhotspotsitos",
    ["lospuggies"] = "lospuggies",
    ["losquesadillas"] = "losquesadillas",
    ["lostacoritas"] = "lostacoritas",
    ["lostipitacos"] = "lostipitacos",
    ["love love bear color"] = "red",
    ["love play"] = "fortnite",
    ["lovebear"] = "lovelovebear",
    ["lovelove"] = "lovelovebear",
    ["lovelovebear"] = "red",
    ["loves play"] = "fortnite",
    ["lowest brainrot"] = "noobinipizzanini",
    ["lowest count brainrot"] = "polaroidini",
    ["lowest exist brainrot"] = "polaroidini",
    ["lowest exist count brainrot"] = "polaroidini",
    ["lowest taco merchant"] = "burritobat",
    ["lucky"] = "lucky",
    ["lucky block"] = "july2025",
    ["lucky block date"] = "july2025",
    ["lucky block day"] = "12",
    ["lucky block month"] = "july",
    ["lucky block release"] = "july2025",
    ["lucky block release date"] = "july2025",
    ["lucky block release day"] = "12",
    ["lucky block release month"] = "july",
    ["lucky block release year"] = "2025",
    ["lucky block year"] = "2025",
    ["lucky blocks"] = "july2025",
    ["lucky blocks date"] = "july2025",
    ["lucky blocks day"] = "12",
    ["lucky blocks month"] = "july",
    ["lucky blocks release"] = "july2025",
    ["lucky blocks release date"] = "july2025",
    ["lucky blocks release day"] = "12",
    ["lucky blocks release month"] = "july",
    ["lucky blocks release year"] = "2025",
    ["lucky blocks year"] = "2025",
    ["lucky matg"] = "secretlokii",
    ["lucky pot trait"] = "lucky",
    ["lucky pot trait date"] = "january2026",
    ["lucky pot trait month"] = "january",
    ["lucky pot trait release"] = "january2026",
    ["lucky pot trait release date"] = "january2026",
    ["lucky pot trait release month"] = "january",
    ["lucky pot trait release year"] = "2026",
    ["lucky pot trait year"] = "2026",
    ["lucky trait"] = "lucky",
    ["lucky trait date"] = "january2026",
    ["lucky trait month"] = "january",
    ["lucky trait release"] = "january2026",
    ["lucky trait release date"] = "january2026",
    ["lucky trait release month"] = "january",
    ["lucky trait release year"] = "2026",
    ["lucky trait year"] = "2026",
    ["luckymatg"] = "secretlokii",
    ["making games"] = "2013",
    ["making games in roblox"] = "2013",
    ["making games in roblox release year"] = "2013",
    ["making games in roblox year"] = "2013",
    ["making games on roblox"] = "2013",
    ["making games on roblox release year"] = "2013",
    ["making games on roblox year"] = "2013",
    ["making games release year"] = "2013",
    ["making games roblox"] = "2013",
    ["making games year"] = "2013",
    ["mariachi"] = "mariachicorazoni",
    ["mariachi corazoni"] = "mariachicorazoni",
    ["mariachicorazoni"] = "mariachicorazoni",
    ["material of spyder elephant"] = "silver",
    ["matteohat"] = "matteohat",
    ["meowl"] = "meowl",
    ["meowl added"] = "october2025",
    ["meowl color"] = "white",
    ["meowl date"] = "october2025",
    ["meowl day"] = "1",
    ["meowl month"] = "october",
    ["meowl release"] = "october2025",
    ["meowl release date"] = "october2025",
    ["meowl release day"] = "1",
    ["meowl release month"] = "october",
    ["meowl release year"] = "2025",
    ["meowl released"] = "october2025",
    ["meowl year"] = "2025",
    ["middle name"] = "brakta",
    ["moby"] = "capitanomoby",
    ["molten mutation"] = "lava",
    ["molten mutation date"] = "july2025",
    ["molten mutation day"] = "25",
    ["molten mutation month"] = "july",
    ["molten mutation release"] = "july2025",
    ["molten mutation release date"] = "july2025",
    ["molten mutation release day"] = "25",
    ["molten mutation release month"] = "july",
    ["molten mutation release year"] = "2025",
    ["molten mutation year"] = "2025",
    ["money"] = "money",
    ["money money puggy"] = "moneymoneypuggy",
    ["money money puggy ritual"] = "money",
    ["money ritual"] = "money",
    ["moneymoneypuggy"] = "moneymoneypuggy",
    ["moneyritual"] = "money",
    ["month birthday"] = "february",
    ["month born"] = "february",
    ["month headless horseman"] = "february",
    ["month john pork"] = "may",
    ["month meowl"] = "october",
    ["month skibidi toilet"] = "december",
    ["month spyder elephant"] = "may",
    ["month strawberry elephant"] = "august",
    ["month when headless horseman released"] = "february",
    ["month when john pork released"] = "may",
    ["month when meowl released"] = "october",
    ["month when skibidi toilet released"] = "december",
    ["month when spyder elephant released"] = "may",
    ["month when strawberry elephant released"] = "august",
    ["most best brainrot added today"] = "lupaandlipa",
    ["most best brainrot in todays admin abuse"] = "lupaandlipa",
    ["most best brainrot in todays update"] = "lupaandlipa",
    ["most best brainrot that was added today"] = "lupaandlipa",
    ["most expensive"] = "spyderelephant",
    ["most expensive item i have"] = "spyderchain",
    ["most expensive item that i have"] = "spyderchain",
    ["most expensive taco"] = "latacocombinasion",
    ["most expensive taco merchant"] = "sammynitruckini",
    ["most op"] = "hydraserpent",
    ["most op admin abuse brainrot"] = "lupaandlipa",
    ["most op base skin in todays admin abuse"] = "1of1",
    ["most op base skin in todays update"] = "1of1",
    ["most op base skin released today"] = "1of1",
    ["most op base skin that was added recently"] = "1of1",
    ["most op base skin that was released today"] = "1of1",
    ["most op bee lucky"] = "orchidox",
    ["most op bee lucky block"] = "orchidox",
    ["most op bee lucky block brainrot"] = "orchidox",
    ["most op bee lucky block brainrot date"] = "august2026",
    ["most op bee lucky block brainrot day"] = "22",
    ["most op bee lucky block brainrot month"] = "august",
    ["most op bee lucky block brainrot release"] = "august2026",
    ["most op bee lucky block brainrot release date"] = "august2026",
    ["most op bee lucky block brainrot release day"] = "22",
    ["most op bee lucky block brainrot release month"] = "august",
    ["most op bee lucky block brainrot release year"] = "2026",
    ["most op bee lucky block brainrot year"] = "2026",
    ["most op brainrot"] = "lupaandlipa",
    ["most op brainrot added"] = "orchidox",
    ["most op brainrot added date"] = "august2026",
    ["most op brainrot added day"] = "22",
    ["most op brainrot added in today update"] = "lupaandlipa",
    ["most op brainrot added in todays admin abuse"] = "lupaandlipa",
    ["most op brainrot added in todays update"] = "lupaandlipa",
    ["most op brainrot added last saturday"] = "orchidox",
    ["most op brainrot added last week"] = "orchidox",
    ["most op brainrot added month"] = "august",
    ["most op brainrot added recently"] = "orchidox",
    ["most op brainrot added recently date"] = "august2026",
    ["most op brainrot added recently day"] = "22",
    ["most op brainrot added recently month"] = "august",
    ["most op brainrot added recently release"] = "august2026",
    ["most op brainrot added recently release date"] = "august2026",
    ["most op brainrot added recently release day"] = "22",
    ["most op brainrot added recently release month"] = "august",
    ["most op brainrot added recently release year"] = "2026",
    ["most op brainrot added recently year"] = "2026",
    ["most op brainrot added release"] = "august2026",
    ["most op brainrot added release date"] = "august2026",
    ["most op brainrot added release day"] = "22",
    ["most op brainrot added release month"] = "august",
    ["most op brainrot added release year"] = "2026",
    ["most op brainrot added today"] = "lupaandlipa",
    ["most op brainrot added year"] = "2026",
    ["most op brainrot date"] = "august2026",
    ["most op brainrot day"] = "22",
    ["most op brainrot from bee lucky"] = "orchidox",
    ["most op brainrot from bee lucky block"] = "orchidox",
    ["most op brainrot from bee lucky block date"] = "august2026",
    ["most op brainrot from bee lucky block day"] = "22",
    ["most op brainrot from bee lucky block month"] = "august",
    ["most op brainrot from bee lucky block release"] = "august2026",
    ["most op brainrot from bee lucky block release date"] = "august2026",
    ["most op brainrot from bee lucky block release day"] = "22",
    ["most op brainrot from bee lucky block release month"] = "august",
    ["most op brainrot from bee lucky block release year"] = "2026",
    ["most op brainrot from bee lucky block year"] = "2026",
    ["most op brainrot from the bee lucky block"] = "orchidox",
    ["most op brainrot in admin abuse"] = "lupaandlipa",
    ["most op brainrot in bee lucky"] = "orchidox",
    ["most op brainrot in bee lucky block"] = "orchidox",
    ["most op brainrot in bee lucky block date"] = "august2026",
    ["most op brainrot in bee lucky block day"] = "22",
    ["most op brainrot in bee lucky block month"] = "august",
    ["most op brainrot in bee lucky block release"] = "august2026",
    ["most op brainrot in bee lucky block release date"] = "august2026",
    ["most op brainrot in bee lucky block release day"] = "22",
    ["most op brainrot in bee lucky block release month"] = "august",
    ["most op brainrot in bee lucky block release year"] = "2026",
    ["most op brainrot in bee lucky block year"] = "2026",
    ["most op brainrot in the bee lucky block"] = "orchidox",
    ["most op brainrot in todays admin abuse"] = "lupaandlipa",
    ["most op brainrot in todays update"] = "lupaandlipa",
    ["most op brainrot month"] = "august",
    ["most op brainrot recently"] = "lupaandlipa",
    ["most op brainrot recently date"] = "august2026",
    ["most op brainrot recently day"] = "22",
    ["most op brainrot recently month"] = "august",
    ["most op brainrot recently release"] = "august2026",
    ["most op brainrot recently release date"] = "august2026",
    ["most op brainrot recently release day"] = "22",
    ["most op brainrot recently release month"] = "august",
    ["most op brainrot recently release year"] = "2026",
    ["most op brainrot recently year"] = "2026",
    ["most op brainrot release"] = "august2026",
    ["most op brainrot release date"] = "august2026",
    ["most op brainrot release day"] = "22",
    ["most op brainrot release month"] = "august",
    ["most op brainrot release year"] = "2026",
    ["most op brainrot released"] = "orchidox",
    ["most op brainrot released date"] = "august2026",
    ["most op brainrot released day"] = "22",
    ["most op brainrot released last saturday"] = "orchidox",
    ["most op brainrot released last week"] = "orchidox",
    ["most op brainrot released month"] = "august",
    ["most op brainrot released recently"] = "orchidox",
    ["most op brainrot released recently date"] = "august2026",
    ["most op brainrot released recently day"] = "22",
    ["most op brainrot released recently month"] = "august",
    ["most op brainrot released recently release"] = "august2026",
    ["most op brainrot released recently release date"] = "august2026",
    ["most op brainrot released recently release day"] = "22",
    ["most op brainrot released recently release month"] = "august",
    ["most op brainrot released recently release year"] = "2026",
    ["most op brainrot released recently year"] = "2026",
    ["most op brainrot released release"] = "august2026",
    ["most op brainrot released release date"] = "august2026",
    ["most op brainrot released release day"] = "22",
    ["most op brainrot released release month"] = "august",
    ["most op brainrot released release year"] = "2026",
    ["most op brainrot released year"] = "2026",
    ["most op brainrot that was added"] = "orchidox",
    ["most op brainrot that was added date"] = "august2026",
    ["most op brainrot that was added day"] = "22",
    ["most op brainrot that was added in today update"] = "lupaandlipa",
    ["most op brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["most op brainrot that was added in todays update"] = "lupaandlipa",
    ["most op brainrot that was added month"] = "august",
    ["most op brainrot that was added recently"] = "orchidox",
    ["most op brainrot that was added recently date"] = "august2026",
    ["most op brainrot that was added recently day"] = "22",
    ["most op brainrot that was added recently month"] = "august",
    ["most op brainrot that was added recently release"] = "august2026",
    ["most op brainrot that was added recently release date"] = "august2026",
    ["most op brainrot that was added recently release day"] = "22",
    ["most op brainrot that was added recently release month"] = "august",
    ["most op brainrot that was added recently release year"] = "2026",
    ["most op brainrot that was added recently year"] = "2026",
    ["most op brainrot that was added release"] = "august2026",
    ["most op brainrot that was added release date"] = "august2026",
    ["most op brainrot that was added release day"] = "22",
    ["most op brainrot that was added release month"] = "august",
    ["most op brainrot that was added release year"] = "2026",
    ["most op brainrot that was added today"] = "lupaandlipa",
    ["most op brainrot that was added year"] = "2026",
    ["most op brainrot that was released"] = "orchidox",
    ["most op brainrot that was released date"] = "august2026",
    ["most op brainrot that was released day"] = "22",
    ["most op brainrot that was released month"] = "august",
    ["most op brainrot that was released recently"] = "orchidox",
    ["most op brainrot that was released recently date"] = "august2026",
    ["most op brainrot that was released recently day"] = "22",
    ["most op brainrot that was released recently month"] = "august",
    ["most op brainrot that was released recently release"] = "august2026",
    ["most op brainrot that was released recently release date"] = "august2026",
    ["most op brainrot that was released recently release day"] = "22",
    ["most op brainrot that was released recently release month"] = "august",
    ["most op brainrot that was released recently release year"] = "2026",
    ["most op brainrot that was released recently year"] = "2026",
    ["most op brainrot that was released release"] = "august2026",
    ["most op brainrot that was released release date"] = "august2026",
    ["most op brainrot that was released release day"] = "22",
    ["most op brainrot that was released release month"] = "august",
    ["most op brainrot that was released release year"] = "2026",
    ["most op brainrot that was released year"] = "2026",
    ["most op brainrot today"] = "lupaandlipa",
    ["most op brainrot year"] = "2026",
    ["mutation i like the most"] = "galaxy",
    ["mutation i love"] = "galaxy",
    ["mutation sammy likes the most"] = "galaxy",
    ["mutation sammy loves"] = "galaxy",
    ["mutation that looks best on meowl"] = "cyber",
    ["mutation that looks the best on meowl"] = "cyber",
    ["my 2nd name"] = "brakta",
    ["my 2nd name is"] = "brakta",
    ["my 2nd name is brakta"] = "brakta",
    ["my avatar car"] = "red",
    ["my avatar color"] = "red",
    ["my body skin color"] = "yellow",
    ["my car color"] = "red",
    ["my cat"] = "nova",
    ["my cat name"] = "nova",
    ["my cats name"] = "nova",
    ["my chain"] = "spyderchain",
    ["my chain name"] = "spyderchain",
    ["my color of my avatar"] = "red",
    ["my dog"] = "rocky",
    ["my dog name"] = "rocky",
    ["my dogs name"] = "rocky",
    ["my enemy"] = "jandel",
    ["my fav mutation"] = "galaxy",
    ["my fav mutation date"] = "august2025",
    ["my fav mutation day"] = "23",
    ["my fav mutation month"] = "august",
    ["my fav mutation release"] = "august2025",
    ["my fav mutation release date"] = "august2025",
    ["my fav mutation release day"] = "23",
    ["my fav mutation release month"] = "august",
    ["my fav mutation release year"] = "2025",
    ["my fav mutation year"] = "2025",
    ["my fav number"] = "67",
    ["my fav visual mutation for meowl"] = "cyber",
    ["my favorite game"] = "fortnite",
    ["my favorite game is fortnite"] = "fortnite",
    ["my favorite mutation"] = "galaxy",
    ["my favorite mutation date"] = "august2025",
    ["my favorite mutation day"] = "23",
    ["my favorite mutation month"] = "august",
    ["my favorite mutation release"] = "august2025",
    ["my favorite mutation release date"] = "august2025",
    ["my favorite mutation release day"] = "23",
    ["my favorite mutation release month"] = "august",
    ["my favorite mutation release year"] = "2025",
    ["my favorite mutation year"] = "2025",
    ["my favorite number"] = "67",
    ["my favorite visual mutation for meowl"] = "cyber",
    ["my favorite visual mutation for meowl date"] = "april2026",
    ["my favorite visual mutation for meowl day"] = "18",
    ["my favorite visual mutation for meowl month"] = "april",
    ["my favorite visual mutation for meowl release"] = "april2026",
    ["my favorite visual mutation for meowl release date"] = "april2026",
    ["my favorite visual mutation for meowl release day"] = "18",
    ["my favorite visual mutation for meowl release month"] = "april",
    ["my favorite visual mutation for meowl release year"] = "2026",
    ["my favorite visual mutation for meowl year"] = "2026",
    ["my favourite game"] = "fortnite",
    ["my favourite game is fortnite"] = "fortnite",
    ["my favourite mutation"] = "galaxy",
    ["my favourite mutation date"] = "august2025",
    ["my favourite mutation day"] = "23",
    ["my favourite mutation month"] = "august",
    ["my favourite mutation release"] = "august2025",
    ["my favourite mutation release date"] = "august2025",
    ["my favourite mutation release day"] = "23",
    ["my favourite mutation release month"] = "august",
    ["my favourite mutation release year"] = "2025",
    ["my favourite mutation year"] = "2025",
    ["my favourite number"] = "67",
    ["my favourite visual mutation for meowl"] = "cyber",
    ["my favourite visual mutation for meowl date"] = "april2026",
    ["my favourite visual mutation for meowl day"] = "18",
    ["my favourite visual mutation for meowl month"] = "april",
    ["my favourite visual mutation for meowl release"] = "april2026",
    ["my favourite visual mutation for meowl release date"] = "april2026",
    ["my favourite visual mutation for meowl release day"] = "18",
    ["my favourite visual mutation for meowl release month"] = "april",
    ["my favourite visual mutation for meowl release year"] = "2026",
    ["my favourite visual mutation for meowl year"] = "2026",
    ["my friend that is a youtuber that has food in his name"] = "steak",
    ["my friend that is a youtuber with food in his name"] = "steak",
    ["my full name"] = "sammy",
    ["my hair"] = "black",
    ["my hair color"] = "black",
    ["my hair colour"] = "black",
    ["my hated group"] = "secretverse",
    ["my hated studio"] = "secretverse",
    ["my hotspot"] = "nooomyhotspot",
    ["my last name"] = "brakta",
    ["my least fav game"] = "growagarden",
    ["my least fav group"] = "secretverse",
    ["my least fav person"] = "secretlokii",
    ["my least fav studio"] = "secretverse",
    ["my least favorite game"] = "growagarden",
    ["my least favorite game is 1 speed keyboard escape"] = "growagarden",
    ["my least favorite game is 1speedkeyboardescape"] = "growagarden",
    ["my least favorite group"] = "secretverse",
    ["my least favorite or my hated group or studio is secretverse studio"] = "secretverse",
    ["my least favorite person"] = "secretlokii",
    ["my least favorite person is secretlokii"] = "secretlokii",
    ["my least favorite studio"] = "secretverse",
    ["my least favourite game"] = "growagarden",
    ["my least favourite game is 1 speed keyboard escape"] = "growagarden",
    ["my least favourite game is 1speedkeyboardescape"] = "growagarden",
    ["my least favourite group"] = "secretverse",
    ["my least favourite or my hated group or studio is secretverse studio"] = "secretverse",
    ["my least favourite person"] = "secretlokii",
    ["my least favourite person is secretlokii"] = "secretlokii",
    ["my least favourite studio"] = "secretverse",
    ["my middle name"] = "brakta",
    ["my name"] = "sammy",
    ["my pants color"] = "red",
    ["my pet"] = "rocky",
    ["my pet name"] = "rocky",
    ["my pets name"] = "rocky",
    ["my phone"] = "iphone",
    ["my real name"] = "sammy",
    ["my roblox avatar color"] = "red",
    ["my roblox skin color"] = "yellow",
    ["my second name"] = "brakta",
    ["my second name is"] = "brakta",
    ["my second name is brakta"] = "brakta",
    ["my shirt color"] = "red",
    ["my skin color"] = "yellow",
    ["my spyder"] = "spyderchain",
    ["my surname"] = "brakta",
    ["my username"] = "sammy",
    ["my worst person"] = "secretlokii",
    ["my youtuber friend that has food in his name"] = "steak",
    ["my youtuber friend with food in his name"] = "steak",
    ["mythic lucky block"] = "july2025",
    ["mythic lucky block date"] = "july2025",
    ["mythic lucky block day"] = "12",
    ["mythic lucky block month"] = "july",
    ["mythic lucky block release"] = "july2025",
    ["mythic lucky block release date"] = "july2025",
    ["mythic lucky block release day"] = "12",
    ["mythic lucky block release month"] = "july",
    ["mythic lucky block release year"] = "2025",
    ["mythic lucky block year"] = "2025",
    ["mythical brainrot"] = "hydraserpent",
    ["mythical creature"] = "hydraserpent",
    ["mythical creature brainrot"] = "hydraserpent",
    ["mythical creature brainrot added in todays update"] = "hydraserpent",
    ["mythical creature brainrot added today"] = "hydraserpent",
    ["nacho gorilla"] = "nachorilla",
    ["nachorilla"] = "nachorilla",
    ["name base skin"] = "1of1",
    ["name new base"] = "emperor",
    ["name of first og"] = "strawberryelephant",
    ["name of flying bee gear"] = "flyingbee",
    ["name of me"] = "sammy",
    ["name of my cat"] = "nova",
    ["name of my chain"] = "spyderchain",
    ["name of my dog"] = "rocky",
    ["name of myself"] = "sammy",
    ["name of new base"] = "emperor",
    ["name of new base skin"] = "1of1",
    ["name of new flying bee gear"] = "flyingbee",
    ["name of previous ltm"] = "escapetsunami",
    ["name of sammy"] = "sammy",
    ["name of sammy cat"] = "nova",
    ["name of sammy dog"] = "rocky",
    ["name of sammys cat"] = "nova",
    ["name of sammys dog"] = "rocky",
    ["name of the first og"] = "strawberryelephant",
    ["name of the flying bee gear"] = "flyingbee",
    ["name of the new base"] = "emperor",
    ["name of the new base skin"] = "1of1",
    ["name of the new flying bee gear"] = "flyingbee",
    ["name of the previous ltm"] = "escapetsunami",
    ["narwhal"] = "diginarwhal",
    ["new 3 headed brainrot"] = "hydraserpent",
    ["new base"] = "emperor",
    ["new base in today update"] = "emperor",
    ["new base in todays update"] = "emperor",
    ["new base skin"] = "1of1",
    ["new base skin added today"] = "1of1",
    ["new base skin in today admin abuse"] = "1of1",
    ["new base skin in today update"] = "1of1",
    ["new base skin in todays admin abuse"] = "1of1",
    ["new base skin in todays update"] = "1of1",
    ["new base skin released today"] = "1of1",
    ["new base skin that was added today"] = "1of1",
    ["new base skin that was released in today admin abuse"] = "1of1",
    ["new base skin that was released in today update"] = "1of1",
    ["new base skin that was released in todays admin abuse"] = "1of1",
    ["new base skin that was released in todays update"] = "1of1",
    ["new base skin that was released today"] = "1of1",
    ["new base skin today"] = "1of1",
    ["new bee gear"] = "flyingbee",
    ["new best brainrot"] = "draculino",
    ["new best brainrot in ltm"] = "draculino",
    ["new best brainrot in ltm color"] = "black",
    ["new best brainrot in the ltm"] = "draculino",
    ["new best brainrot in the ltm color"] = "black",
    ["new brainrot"] = "hydraserpent",
    ["new brainrot color"] = "black",
    ["new flying b gear"] = "flyingbee",
    ["new flying bee"] = "flyingbee",
    ["new flying bee gear"] = "flyingbee",
    ["new gear"] = "griefshield",
    ["new gear in bee update"] = "flyingbee",
    ["new gear in today update"] = "flyingbee",
    ["new gear in todays update"] = "flyingbee",
    ["new mythical creature brainrot"] = "hydraserpent",
    ["new op brainrot"] = "draculino",
    ["new op brainrot added today"] = "draculino",
    ["new op brainrot color"] = "black",
    ["new op brainrot from cave island"] = "draculino",
    ["new op brainrot from the cave island"] = "draculino",
    ["new op brainrot obtained from cave island"] = "draculino",
    ["new op brainrot obtained from the cave island"] = "draculino",
    ["new op brainrot that was added today"] = "draculino",
    ["new op brainrot that we added today"] = "draculino",
    ["new rarest base skin"] = "1of1",
    ["new rebirth"] = "griefshield",
    ["new ritual"] = "money",
    ["new ritual added in today admin abuse"] = "money",
    ["new ritual added in today update"] = "money",
    ["new ritual added in todays admin abuse"] = "money",
    ["new ritual added in todays update"] = "money",
    ["new ritual added today"] = "money",
    ["new ritual added today in today admin abuse"] = "money",
    ["new ritual added today in today update"] = "money",
    ["new ritual added today in todays admin abuse"] = "money",
    ["new ritual added today in todays update"] = "money",
    ["new ritual in today admin abuse"] = "money",
    ["new ritual in today update"] = "money",
    ["new ritual in todays admin abuse"] = "money",
    ["new ritual in todays update"] = "money",
    ["new ritual today"] = "money",
    ["new snake"] = "hydraserpent",
    ["new snake brainrot"] = "hydraserpent",
    ["new snake brainrot his name"] = "hydraserpent",
    ["new snake brainrot name"] = "hydraserpent",
    ["new snake brainrots name"] = "hydraserpent",
    ["new three headed brainrot"] = "hydraserpent",
    ["new year 2026 trait"] = "2026",
    ["new year 2026 trait date"] = "december2025",
    ["new year 2026 trait month"] = "december",
    ["new year 2026 trait release"] = "december2025",
    ["new year 2026 trait release date"] = "december2025",
    ["new year 2026 trait release month"] = "december",
    ["new year 2026 trait release year"] = "2025",
    ["new year 2026 trait year"] = "2025",
    ["new year fuse"] = "december2025",
    ["new year fuse date"] = "december2025",
    ["new year fuse day"] = "31",
    ["new year fuse month"] = "december",
    ["new year fuse release"] = "december2025",
    ["new year fuse release date"] = "december2025",
    ["new year fuse release day"] = "31",
    ["new year fuse release month"] = "december",
    ["new year fuse release year"] = "2025",
    ["new year fuse year"] = "2025",
    ["new year machine"] = "december2025",
    ["new year machine date"] = "december2025",
    ["new year machine day"] = "31",
    ["new year machine month"] = "december",
    ["new year machine release"] = "december2025",
    ["new year machine release date"] = "december2025",
    ["new year machine release day"] = "31",
    ["new year machine release month"] = "december",
    ["new year machine release year"] = "2025",
    ["new year machine year"] = "2025",
    ["new years machine"] = "december2025",
    ["new years machine date"] = "december2025",
    ["new years machine day"] = "31",
    ["new years machine month"] = "december",
    ["new years machine release"] = "december2025",
    ["new years machine release date"] = "december2025",
    ["new years machine release day"] = "31",
    ["new years machine release month"] = "december",
    ["new years machine release year"] = "2025",
    ["new years machine year"] = "2025",
    ["newest base"] = "emperor",
    ["newest base skin"] = "1of1",
    ["newest base skin added today"] = "1of1",
    ["newest base skin in today admin abuse"] = "1of1",
    ["newest base skin in today update"] = "1of1",
    ["newest base skin in todays admin abuse"] = "1of1",
    ["newest base skin in todays update"] = "1of1",
    ["newest base skin released today"] = "1of1",
    ["newest brainrot"] = "hydraserpent",
    ["newest brainrot last saturday"] = "orchidox",
    ["newest brainrot last week"] = "orchidox",
    ["newest craft"] = "cybercraft",
    ["newest craft date"] = "april2026",
    ["newest craft day"] = "18",
    ["newest craft machine"] = "cybercraft",
    ["newest craft machine date"] = "april2026",
    ["newest craft machine day"] = "18",
    ["newest craft machine month"] = "april",
    ["newest craft machine release"] = "april2026",
    ["newest craft machine release date"] = "april2026",
    ["newest craft machine release day"] = "18",
    ["newest craft machine release month"] = "april",
    ["newest craft machine release year"] = "2026",
    ["newest craft machine year"] = "2026",
    ["newest craft month"] = "april",
    ["newest craft release"] = "april2026",
    ["newest craft release date"] = "april2026",
    ["newest craft release day"] = "18",
    ["newest craft release month"] = "april",
    ["newest craft release year"] = "2026",
    ["newest craft year"] = "2026",
    ["newest fuse"] = "rainbowfuse",
    ["newest fuse date"] = "june2025",
    ["newest fuse day"] = "21",
    ["newest fuse machine"] = "rainbowfuse",
    ["newest fuse machine date"] = "june2025",
    ["newest fuse machine day"] = "21",
    ["newest fuse machine month"] = "june",
    ["newest fuse machine release"] = "june2025",
    ["newest fuse machine release date"] = "june2025",
    ["newest fuse machine release day"] = "21",
    ["newest fuse machine release month"] = "june",
    ["newest fuse machine release year"] = "2025",
    ["newest fuse machine year"] = "2025",
    ["newest fuse month"] = "june",
    ["newest fuse release"] = "june2025",
    ["newest fuse release date"] = "june2025",
    ["newest fuse release day"] = "21",
    ["newest fuse release month"] = "june",
    ["newest fuse release year"] = "2025",
    ["newest fuse year"] = "2025",
    ["newest mutation"] = "crystal",
    ["newest mythical creature brainrot"] = "hydraserpent",
    ["newest ritual"] = "money",
    ["newest ritual added today"] = "money",
    ["newest ritual in today admin abuse"] = "money",
    ["newest ritual in today update"] = "money",
    ["newest ritual in todays admin abuse"] = "money",
    ["newest ritual in todays update"] = "money",
    ["newest snake"] = "hydraserpent",
    ["newest snake brainrot"] = "hydraserpent",
    ["newest three headed brainrot"] = "hydraserpent",
    ["next fuse machine"] = "hauntedfuse",
    ["next fuse machine coming"] = "hauntedfuse",
    ["next fuse machine that is coming"] = "hauntedfuse",
    ["next fuse machine that is gonna release"] = "hauntedfuse",
    ["next Strawberry fuse"] = "hauntedfuse",
    ["noo my hotspot"] = "nooomyhotspot",
    ["noobini"] = "NoobiniPizzanini",
    ["noobini pizzanini"] = "noobinipizzanini",
    ["noobinipizzanini"] = "noobinipizzanini",
    ["nooo my hotspot"] = "nooomyhotspot",
    ["nooomyhotspot"] = "nooomyhotspot",
    ["number always code"] = "67",
    ["number always codes"] = "67",
    ["number always put"] = "67",
    ["number i always put at code"] = "67",
    ["number i always put at codes"] = "67",
    ["number i always put in code"] = "67",
    ["number i always put in codes"] = "67",
    ["nyan"] = "nyan",
    ["nyan cat"] = "nyan",
    ["nyan cat date"] = "june2025",
    ["nyan cat day"] = "28",
    ["nyan cat month"] = "june",
    ["nyan cat release"] = "june2025",
    ["nyan cat release date"] = "june2025",
    ["nyan cat release day"] = "28",
    ["nyan cat release month"] = "june",
    ["nyan cat release year"] = "2025",
    ["nyan cat trait"] = "nyan",
    ["nyan cat trait date"] = "june2025",
    ["nyan cat trait day"] = "28",
    ["nyan cat trait month"] = "june",
    ["nyan cat trait release"] = "june2025",
    ["nyan cat trait release date"] = "june2025",
    ["nyan cat trait release day"] = "28",
    ["nyan cat trait release month"] = "june",
    ["nyan cat trait release year"] = "2025",
    ["nyan cat trait year"] = "2025",
    ["nyan cat year"] = "2025",
    ["nyan trait"] = "nyan",
    ["nyan trait date"] = "june2025",
    ["nyan trait day"] = "28",
    ["nyan trait month"] = "june",
    ["nyan trait release"] = "june2025",
    ["nyan trait release date"] = "june2025",
    ["nyan trait release day"] = "28",
    ["nyan trait release month"] = "june",
    ["nyan trait release year"] = "2025",
    ["nyan trait year"] = "2025",
    ["nyancat"] = "nyan",
    ["nyancat date"] = "june2025",
    ["nyancat day"] = "28",
    ["nyancat month"] = "june",
    ["nyancat release"] = "june2025",
    ["nyancat release date"] = "june2025",
    ["nyancat release day"] = "28",
    ["nyancat release month"] = "june",
    ["nyancat release year"] = "2025",
    ["nyancat year"] = "2025",
    ["obtainable admin abuse"] = "sleepy",
    ["og fuse machine"] = "january2026",
    ["og fuse machine date"] = "january2026",
    ["og fuse machine day"] = "24",
    ["og fuse machine month"] = "january",
    ["og fuse machine release"] = "january2026",
    ["og fuse machine release date"] = "january2026",
    ["og fuse machine release day"] = "24",
    ["og fuse machine release month"] = "january",
    ["og fuse machine release year"] = "2026",
    ["og fuse machine year"] = "2026",
    ["old limited time mode"] = "escapetsunami",
    ["old ltm"] = "escapetsunami",
    ["oldest fuse"] = "lafusemachine",
    ["oldest fuse date"] = "august2025",
    ["oldest fuse day"] = "1",
    ["oldest fuse month"] = "august",
    ["oldest fuse release"] = "august2025",
    ["oldest fuse release date"] = "august2025",
    ["oldest fuse release day"] = "1",
    ["oldest fuse release month"] = "august",
    ["oldest fuse release year"] = "2025",
    ["oldest fuse year"] = "2025",
    ["oldest machine"] = "rainbowmachine",
    ["oldest machine date"] = "june2025",
    ["oldest machine day"] = "21",
    ["oldest machine month"] = "june",
    ["oldest machine release"] = "june2025",
    ["oldest machine release date"] = "june2025",
    ["oldest machine release day"] = "21",
    ["oldest machine release month"] = "june",
    ["oldest machine release year"] = "2025",
    ["oldest machine year"] = "2025",
    ["op base skin"] = "1of1",
    ["op base skin added today"] = "1of1",
    ["op base skin in today admin abuse"] = "1of1",
    ["op base skin in today update"] = "1of1",
    ["op base skin in todays admin abuse"] = "1of1",
    ["op base skin in todays update"] = "1of1",
    ["op base skin released today"] = "1of1",
    ["op base skin that was released in today admin abuse"] = "1of1",
    ["op base skin that was released in today update"] = "1of1",
    ["op base skin that was released in todays admin abuse"] = "1of1",
    ["op base skin that was released in todays update"] = "1of1",
    ["op base skin that was released today"] = "1of1",
    ["op bee lucky"] = "orchidox",
    ["op bee lucky block"] = "orchidox",
    ["op bee lucky block brainrot"] = "orchidox",
    ["op brainrot"] = "lupaandlipa",
    ["op brainrot added"] = "lupaandlipa",
    ["op brainrot added date"] = "august2026",
    ["op brainrot added day"] = "22",
    ["op brainrot added in todays admin abuse"] = "lupaandlipa",
    ["op brainrot added in todays update"] = "lupaandlipa",
    ["op brainrot added last saturday"] = "orchidox",
    ["op brainrot added last week"] = "orchidox",
    ["op brainrot added month"] = "august",
    ["op brainrot added recently"] = "lupaandlipa",
    ["op brainrot added recently date"] = "august2026",
    ["op brainrot added recently day"] = "22",
    ["op brainrot added recently month"] = "august",
    ["op brainrot added recently release"] = "august2026",
    ["op brainrot added recently release date"] = "august2026",
    ["op brainrot added recently release day"] = "22",
    ["op brainrot added recently release month"] = "august",
    ["op brainrot added recently release year"] = "2026",
    ["op brainrot added recently year"] = "2026",
    ["op brainrot added release"] = "august2026",
    ["op brainrot added release date"] = "august2026",
    ["op brainrot added release day"] = "22",
    ["op brainrot added release month"] = "august",
    ["op brainrot added release year"] = "2026",
    ["op brainrot added today"] = "lupaandlipa",
    ["op brainrot added year"] = "2026",
    ["op brainrot date"] = "august2026",
    ["op brainrot day"] = "22",
    ["op brainrot from bee lucky block"] = "orchidox",
    ["op brainrot from the bee lucky block"] = "orchidox",
    ["op brainrot in bee lucky block"] = "orchidox",
    ["op brainrot in the bee lucky block"] = "orchidox",
    ["op brainrot in todays admin abuse"] = "lupaandlipa",
    ["op brainrot in todays update"] = "hydraserpent",
    ["op brainrot month"] = "august",
    ["op brainrot recently"] = "lupaandlipa",
    ["op brainrot recently added"] = "lupaandlipa",
    ["op brainrot recently date"] = "august2026",
    ["op brainrot recently day"] = "22",
    ["op brainrot recently month"] = "august",
    ["op brainrot recently release"] = "august2026",
    ["op brainrot recently release date"] = "august2026",
    ["op brainrot recently release day"] = "22",
    ["op brainrot recently release month"] = "august",
    ["op brainrot recently release year"] = "2026",
    ["op brainrot recently released"] = "lupaandlipa",
    ["op brainrot recently year"] = "2026",
    ["op brainrot release"] = "august2026",
    ["op brainrot release date"] = "august2026",
    ["op brainrot release day"] = "22",
    ["op brainrot release month"] = "august",
    ["op brainrot release year"] = "2026",
    ["op brainrot released last saturday"] = "orchidox",
    ["op brainrot released last week"] = "orchidox",
    ["op brainrot released recently"] = "lupaandlipa",
    ["op brainrot released recently date"] = "august2026",
    ["op brainrot released recently day"] = "22",
    ["op brainrot released recently month"] = "august",
    ["op brainrot released recently release"] = "august2026",
    ["op brainrot released recently release date"] = "august2026",
    ["op brainrot released recently release day"] = "22",
    ["op brainrot released recently release month"] = "august",
    ["op brainrot released recently release year"] = "2026",
    ["op brainrot released recently year"] = "2026",
    ["op brainrot that was added"] = "lupaandlipa",
    ["op brainrot that was added date"] = "august2026",
    ["op brainrot that was added day"] = "22",
    ["op brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["op brainrot that was added in todays update"] = "lupaandlipa",
    ["op brainrot that was added month"] = "august",
    ["op brainrot that was added recently"] = "lupaandlipa",
    ["op brainrot that was added recently date"] = "august2026",
    ["op brainrot that was added recently day"] = "22",
    ["op brainrot that was added recently month"] = "august",
    ["op brainrot that was added recently release"] = "august2026",
    ["op brainrot that was added recently release date"] = "august2026",
    ["op brainrot that was added recently release day"] = "22",
    ["op brainrot that was added recently release month"] = "august",
    ["op brainrot that was added recently release year"] = "2026",
    ["op brainrot that was added recently year"] = "2026",
    ["op brainrot that was added release"] = "august2026",
    ["op brainrot that was added release date"] = "august2026",
    ["op brainrot that was added release day"] = "22",
    ["op brainrot that was added release month"] = "august",
    ["op brainrot that was added release year"] = "2026",
    ["op brainrot that was added today"] = "lupaandlipa",
    ["op brainrot that was added year"] = "2026",
    ["op brainrot that was recently added"] = "lupaandlipa",
    ["op brainrot that was recently released"] = "lupaandlipa",
    ["op brainrot that was released recently"] = "lupaandlipa",
    ["op brainrot that was released recently date"] = "august2026",
    ["op brainrot that was released recently day"] = "22",
    ["op brainrot that was released recently month"] = "august",
    ["op brainrot that was released recently release"] = "august2026",
    ["op brainrot that was released recently release date"] = "august2026",
    ["op brainrot that was released recently release day"] = "22",
    ["op brainrot that was released recently release month"] = "august",
    ["op brainrot that was released recently release year"] = "2026",
    ["op brainrot that was released recently year"] = "2026",
    ["op brainrot that we added today"] = "draculino",
    ["op brainrot today"] = "lupaandlipa",
    ["op brainrot we added today"] = "draculino",
    ["op brainrot year"] = "2026",
    ["orange"] = "orange",
    ["orange egg trait"] = "orangeegg",
    ["orange egg trait date"] = "orangeegg",
    ["orange egg trait month"] = "april",
    ["orange egg trait release"] = "orangeegg",
    ["orange egg trait release date"] = "orangeegg",
    ["orange egg trait release month"] = "april",
    ["orange egg trait release year"] = "2026",
    ["orange egg trait year"] = "2026",
    ["orangeballoon"] = "orangeballoon",
    ["orangeegg"] = "orangeegg",
    ["orchideon"] = "orchidox",
    ["orchideon date"] = "august2026",
    ["orchideon day"] = "22",
    ["orchideon month"] = "august",
    ["orchideon release"] = "august2026",
    ["orchideon release date"] = "august2026",
    ["orchideon release day"] = "22",
    ["orchideon release month"] = "august",
    ["orchideon release year"] = "2026",
    ["orchideon year"] = "2026",
    ["orchidox"] = "orchidox",
    ["orchidox color"] = "purple",
    ["orchidox date"] = "august2026",
    ["orchidox day"] = "22",
    ["orchidox month"] = "august",
    ["orchidox release"] = "august2026",
    ["orchidox release date"] = "august2026",
    ["orchidox release day"] = "22",
    ["orchidox release month"] = "august",
    ["orchidox release year"] = "2026",
    ["orchidox year"] = "2026",
    ["original craft machine"] = "september2025",
    ["original craft machine date"] = "september2025",
    ["original craft machine day"] = "6",
    ["original craft machine month"] = "september",
    ["original craft machine release"] = "september2025",
    ["original craft machine release date"] = "september2025",
    ["original craft machine release day"] = "6",
    ["original craft machine release month"] = "september",
    ["original craft machine release year"] = "2025",
    ["original craft machine year"] = "2025",
    ["original fuse"] = "lafusemachine",
    ["original fuse date"] = "august2025",
    ["original fuse day"] = "1",
    ["original fuse machine"] = "lafusemachine",
    ["original fuse machine date"] = "august2025",
    ["original fuse machine day"] = "1",
    ["original fuse machine month"] = "august",
    ["original fuse machine release"] = "august2025",
    ["original fuse machine release date"] = "august2025",
    ["original fuse machine release day"] = "1",
    ["original fuse machine release month"] = "august",
    ["original fuse machine release year"] = "2025",
    ["original fuse machine year"] = "2025",
    ["original fuse month"] = "august",
    ["original fuse release"] = "august2025",
    ["original fuse release date"] = "august2025",
    ["original fuse release day"] = "1",
    ["original fuse release month"] = "august",
    ["original fuse release year"] = "2025",
    ["original fuse year"] = "2025",
    ["original lucky block"] = "july2025",
    ["original lucky block date"] = "july2025",
    ["original lucky block day"] = "12",
    ["original lucky block month"] = "july",
    ["original lucky block release"] = "july2025",
    ["original lucky block release date"] = "july2025",
    ["original lucky block release day"] = "12",
    ["original lucky block release month"] = "july",
    ["original lucky block release year"] = "2025",
    ["original lucky block year"] = "2025",
    ["original machine"] = "rainbowmachine",
    ["original machine date"] = "june2025",
    ["original machine day"] = "21",
    ["original machine month"] = "june",
    ["original machine release"] = "june2025",
    ["original machine release date"] = "june2025",
    ["original machine release day"] = "21",
    ["original machine release month"] = "june",
    ["original machine release year"] = "2025",
    ["original machine year"] = "2025",
    ["os"] = "windows11",
    ["overall fav mutation"] = "galaxy",
    ["overall fav mutation date"] = "august2025",
    ["overall fav mutation day"] = "23",
    ["overall fav mutation month"] = "august",
    ["overall fav mutation release"] = "august2025",
    ["overall fav mutation release date"] = "august2025",
    ["overall fav mutation release day"] = "23",
    ["overall fav mutation release month"] = "august",
    ["overall fav mutation release year"] = "2025",
    ["overall fav mutation year"] = "2025",
    ["overall favorite mutation"] = "galaxy",
    ["overall favorite mutation date"] = "august2025",
    ["overall favorite mutation day"] = "23",
    ["overall favorite mutation month"] = "august",
    ["overall favorite mutation release"] = "august2025",
    ["overall favorite mutation release date"] = "august2025",
    ["overall favorite mutation release day"] = "23",
    ["overall favorite mutation release month"] = "august",
    ["overall favorite mutation release year"] = "2025",
    ["overall favorite mutation year"] = "2025",
    ["overall favourite mutation"] = "galaxy",
    ["overall favourite mutation date"] = "august2025",
    ["overall favourite mutation day"] = "23",
    ["overall favourite mutation month"] = "august",
    ["overall favourite mutation release"] = "august2025",
    ["overall favourite mutation release date"] = "august2025",
    ["overall favourite mutation release day"] = "23",
    ["overall favourite mutation release month"] = "august",
    ["overall favourite mutation release year"] = "2025",
    ["overall favourite mutation year"] = "2025",
    ["owner name"] = "sammy",
    ["paint"] = "paint",
    ["pancake"] = "pancakeandsyrup",
    ["pancake and syrup color"] = "orange",
    ["pancakeandsyrup"] = "orange",
    ["pants color"] = "red",
    ["pegasus"] = "celestialpegasus",
    ["perrito burrito"] = "perritoburrito",
    ["perritoburrito"] = "perritoburrito",
    ["person better than loki"] = "jandel",
    ["person better than loki is jandel"] = "jandel",
    ["person better than lokii"] = "jandel",
    ["person better than lokii is jandel"] = "jandel",
    ["person better than luckymatg"] = "jandel",
    ["person better than luckymatg is jandel"] = "jandel",
    ["person better than secretloki"] = "jandel",
    ["person better than secretloki is jandel"] = "jandel",
    ["person better than secretlokii"] = "jandel",
    ["person better than secretlokii is jandel"] = "jandel",
    ["person hate"] = "secretlokii",
    ["person hate most"] = "secretlokii",
    ["person hates"] = "secretlokii",
    ["person hates most"] = "secretlokii",
    ["person i hate"] = "secretlokii",
    ["person i hate most"] = "secretlokii",
    ["person i hate the most"] = "secretlokii",
    ["person sammy hates"] = "secretlokii",
    ["person sammy hates most"] = "secretlokii",
    ["person sammy hates the most"] = "secretlokii",
    ["person that is better than loki"] = "jandel",
    ["person that is better than lokii"] = "jandel",
    ["person that is better than luckymatg"] = "jandel",
    ["person that is better than secretloki"] = "jandel",
    ["person that is better than secretlokii"] = "jandel",
    ["person that is worse than jandel"] = "secretlokii",
    ["person that is worser than jandel"] = "secretlokii",
    ["person worse than jandel"] = "secretlokii",
    ["person worse than jandel is secretlokii"] = "secretlokii",
    ["person worser than jandel"] = "secretlokii",
    ["person worser than jandel is secretlokii"] = "secretlokii",
    ["pet"] = "rocky",
    ["pet name"] = "rocky",
    ["pets name"] = "rocky",
    ["phantom"] = "phantom",
    ["phantom mutation"] = "phantom",
    ["phantom mutation date"] = "june2026",
    ["phantom mutation day"] = "13",
    ["phantom mutation month"] = "june",
    ["phantom mutation release"] = "june2026",
    ["phantom mutation release date"] = "june2026",
    ["phantom mutation release day"] = "13",
    ["phantom mutation release month"] = "june",
    ["phantom mutation release year"] = "2026",
    ["phantom mutation year"] = "2026",
    ["phone"] = "iphone",
    ["pig"] = "johnpork",
    ["pig color"] = "pink",
    ["pink"] = "pink",
    ["pink egg trait"] = "pinkegg",
    ["pink egg trait date"] = "april2026",
    ["pink egg trait month"] = "april",
    ["pink egg trait release"] = "april2026",
    ["pink egg trait release date"] = "april2026",
    ["pink egg trait release month"] = "april",
    ["pink egg trait release year"] = "2026",
    ["pink egg trait year"] = "2026",
    ["pinkballoon"] = "pinkballoon",
    ["pinkegg"] = "pinkegg",
    ["pizzanini"] = "NoobiniPizzanini",
    ["plays competitively"] = "valorant",
    ["polaroidini"] = "polaroidini",
    ["pork"] = "johnpork",
    ["pot hotspot"] = "pothotspot",
    ["pothotspot"] = "pothotspot",
    ["previous limited time mode"] = "escapetsunami",
    ["previous limited time mode name"] = "escapetsunami",
    ["previous ltm"] = "escapetsunami",
    ["previous ltm name"] = "escapetsunami",
    ["programmer"] = "hasted",
    ["purple"] = "purple",
    ["quesadilla crocodila"] = "quesadillacrocodila",
    ["quesadillacrocodila"] = "quesadillacrocodila",
    ["quesadillo vampiro"] = "quesadillovampiro",
    ["quesadillovampiro"] = "quesadillovampiro",
    ["queso"] = "chipsoandqueso",
    ["queso date"] = "october2025",
    ["queso day"] = "21",
    ["queso month"] = "october",
    ["queso release"] = "october2025",
    ["queso release date"] = "october2025",
    ["queso release day"] = "21",
    ["queso release month"] = "october",
    ["queso release year"] = "2025",
    ["queso year"] = "2025",
    ["raccooni"] = "RaccooniJandelini",
    ["raccooni jandelini"] = "raccoonijandelini",
    ["raccoonijandelini"] = "raccoonijandelini",
    ["radioactive"] = "radioactive",
    ["radioactive date"] = "november2025",
    ["radioactive day"] = "15",
    ["radioactive month"] = "november",
    ["radioactive mutation"] = "radioactive",
    ["radioactive mutation date"] = "november2025",
    ["radioactive mutation day"] = "15",
    ["radioactive mutation month"] = "november",
    ["radioactive mutation release"] = "november2025",
    ["radioactive mutation release date"] = "november2025",
    ["radioactive mutation release day"] = "15",
    ["radioactive mutation release month"] = "november",
    ["radioactive mutation release year"] = "2025",
    ["radioactive mutation year"] = "2025",
    ["radioactive release"] = "november2025",
    ["radioactive release date"] = "november2025",
    ["radioactive release day"] = "15",
    ["radioactive release month"] = "november",
    ["radioactive release year"] = "2025",
    ["radioactive year"] = "2025",
    ["rain"] = "rain",
    ["rain trait"] = "rain",
    ["rain trait date"] = "june2025",
    ["rain trait month"] = "june",
    ["rain trait release"] = "june2025",
    ["rain trait release date"] = "june2025",
    ["rain trait release month"] = "june",
    ["rain trait release year"] = "2025",
    ["rain trait year"] = "2025",
    ["rain weather trait"] = "rain",
    ["rain weather trait date"] = "june2025",
    ["rain weather trait month"] = "june",
    ["rain weather trait release"] = "june2025",
    ["rain weather trait release date"] = "june2025",
    ["rain weather trait release month"] = "june",
    ["rain weather trait release year"] = "2025",
    ["rain weather trait year"] = "2025",
    ["rainbow fuse"] = "rainbowfuse",
    ["rainbow fuse date"] = "june2025",
    ["rainbow fuse day"] = "21",
    ["rainbow fuse machine"] = "rainbowfuse",
    ["rainbow fuse machine date"] = "june2025",
    ["rainbow fuse machine day"] = "21",
    ["rainbow fuse machine month"] = "june",
    ["rainbow fuse machine release"] = "june2025",
    ["rainbow fuse machine release date"] = "june2025",
    ["rainbow fuse machine release day"] = "21",
    ["rainbow fuse machine release month"] = "june",
    ["rainbow fuse machine release year"] = "2025",
    ["rainbow fuse machine year"] = "2025",
    ["rainbow fuse month"] = "june",
    ["rainbow fuse release"] = "june2025",
    ["rainbow fuse release date"] = "june2025",
    ["rainbow fuse release day"] = "21",
    ["rainbow fuse release month"] = "june",
    ["rainbow fuse release year"] = "2025",
    ["rainbow fuse year"] = "2025",
    ["rainbow machine"] = "rainbowmachine",
    ["rainbow machine date"] = "june2025",
    ["rainbow machine day"] = "21",
    ["rainbow machine month"] = "june",
    ["rainbow machine release"] = "june2025",
    ["rainbow machine release date"] = "june2025",
    ["rainbow machine release day"] = "21",
    ["rainbow machine release month"] = "june",
    ["rainbow machine release year"] = "2025",
    ["rainbow machine year"] = "2025",
    ["rainbow strawberry elephant exist"] = "87",
    ["rainbow strawberry elephant exist count"] = "87",
    ["rainbow strawberry elephants exist"] = "87",
    ["rainbowballoon"] = "rainbowballoon",
    ["rainbowfuse"] = "rainbowfuse",
    ["rainbowfuse date"] = "june2025",
    ["rainbowfuse day"] = "21",
    ["rainbowfuse month"] = "june",
    ["rainbowfuse release"] = "june2025",
    ["rainbowfuse release date"] = "june2025",
    ["rainbowfuse release day"] = "21",
    ["rainbowfuse release month"] = "june",
    ["rainbowfuse release year"] = "2025",
    ["rainbowfuse year"] = "2025",
    ["rainbowmachine"] = "rainbowmachine",
    ["rainbowmachine date"] = "june2025",
    ["rainbowmachine day"] = "21",
    ["rainbowmachine month"] = "june",
    ["rainbowmachine release"] = "june2025",
    ["rainbowmachine release date"] = "june2025",
    ["rainbowmachine release day"] = "21",
    ["rainbowmachine release month"] = "june",
    ["rainbowmachine release year"] = "2025",
    ["rainbowmachine year"] = "2025",
    ["raining money"] = "rainingmoney",
    ["rainingmoney"] = "rainingmoney",
    ["rarest"] = "spyderelephant",
    ["rarest base"] = "1of1",
    ["rarest base in game"] = "1of1",
    ["rarest base in the game"] = "1of1",
    ["rarest base skin"] = "1of1",
    ["rarest base skin in game"] = "1of1",
    ["rarest base skin in the game"] = "1of1",
    ["rarest brainrot"] = "spyderelephant",
    ["rarest brainrot in game"] = "spyderelephant",
    ["rarest brainrot in the game"] = "spyderelephant",
    ["rarest fuse brainrot"] = "griffin",
    ["rarest fuse machine"] = "griffin",
    ["rarest fuse machine brainrot"] = "griffin",
    ["real name"] = "sammy",
    ["recent fuse"] = "rainbowfuse",
    ["recent fuse date"] = "june2025",
    ["recent fuse day"] = "21",
    ["recent fuse month"] = "june",
    ["recent fuse release"] = "june2025",
    ["recent fuse release date"] = "june2025",
    ["recent fuse release day"] = "21",
    ["recent fuse release month"] = "june",
    ["recent fuse release year"] = "2025",
    ["recent fuse year"] = "2025",
    ["recent ritual"] = "money",
    ["red"] = "red",
    ["redballoon"] = "redballoon",
    ["reindeer"] = "reindeer",
    ["reindeer trait"] = "reindeer",
    ["reindeer trait date"] = "december2025",
    ["reindeer trait month"] = "december",
    ["reindeer trait release"] = "december2025",
    ["reindeer trait release date"] = "december2025",
    ["reindeer trait release month"] = "december",
    ["reindeer trait release year"] = "2025",
    ["reindeer trait year"] = "2025",
    ["release event order 1"] = "bloodrot",
    ["release event order 10"] = "phantom",
    ["release event order 11"] = "crystal",
    ["release event order 2"] = "candy",
    ["release event order 3"] = "lava",
    ["release event order 4"] = "galaxy",
    ["release event order 5"] = "yinyang",
    ["release event order 6"] = "radioactive",
    ["release event order 7"] = "cursed",
    ["release event order 8"] = "divine",
    ["release event order 9"] = "cyber",
    ["released last saturday"] = "orchidox",
    ["released last week"] = "orchidox",
    ["removed brainrot"] = "tungtungtungsahur",
    ["removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["reskin me"] = "sammynitruckini",
    ["reskin of me"] = "sammynitruckini",
    ["reskin of sammy"] = "sammynitruckini",
    ["reskin sammy"] = "sammynitruckini",
    ["revived fuse machine"] = "january2026",
    ["revived fuse machine date"] = "january2026",
    ["revived fuse machine day"] = "24",
    ["revived fuse machine month"] = "january",
    ["revived fuse machine release"] = "january2026",
    ["revived fuse machine release date"] = "january2026",
    ["revived fuse machine release day"] = "24",
    ["revived fuse machine release month"] = "january",
    ["revived fuse machine release year"] = "2026",
    ["revived fuse machine year"] = "2026",
    ["reward from money ritual"] = "lospuggies",
    ["reward from new ritual"] = "lospuggies",
    ["reward money"] = "lospuggies",
    ["reward of money ritual"] = "lospuggies",
    ["reward of new ritual"] = "lospuggies",
    ["rework brainrot"] = "sammynispyderini",
    ["rework brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["reworked brainrot"] = "sammynispyderini",
    ["reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["rip tombstone"] = "riptombstone",
    ["rip tombstone date"] = "october2025",
    ["rip tombstone month"] = "october",
    ["rip tombstone release"] = "october2025",
    ["rip tombstone release date"] = "october2025",
    ["rip tombstone release month"] = "october",
    ["rip tombstone release year"] = "2025",
    ["rip tombstone trait"] = "riptombstone",
    ["rip tombstone trait date"] = "october2025",
    ["rip tombstone trait month"] = "october",
    ["rip tombstone trait release"] = "october2025",
    ["rip tombstone trait release date"] = "october2025",
    ["rip tombstone trait release month"] = "october",
    ["rip tombstone trait release year"] = "2025",
    ["rip tombstone trait year"] = "2025",
    ["rip tombstone year"] = "2025",
    ["riptombstone"] = "riptombstone",
    ["ritual added today"] = "money",
    ["ritual today"] = "money",
    ["rng machine"] = "august2026",
    ["rng machine date"] = "august2026",
    ["rng machine day"] = "8",
    ["rng machine month"] = "august",
    ["rng machine release"] = "august2026",
    ["rng machine release date"] = "august2026",
    ["rng machine release day"] = "8",
    ["rng machine release month"] = "august",
    ["rng machine release year"] = "2026",
    ["rng machine year"] = "2026",
    ["roblox skin color"] = "yellow",
    ["rose"] = "rose",
    ["sab created"] = "may2025",
    ["sab created date"] = "may2025",
    ["sab created day"] = "16",
    ["sab created month"] = "may",
    ["sab created release"] = "may2025",
    ["sab created release date"] = "may2025",
    ["sab created release day"] = "16",
    ["sab created release month"] = "may",
    ["sab created release year"] = "2025",
    ["sab created year"] = "2025",
    ["sab day"] = "16",
    ["sab game release"] = "may2025",
    ["sab game release date"] = "may2025",
    ["sab game release day"] = "16",
    ["sab game release month"] = "may",
    ["sab game release release"] = "may2025",
    ["sab game release release date"] = "may2025",
    ["sab game release release day"] = "16",
    ["sab game release release month"] = "may",
    ["sab game release release year"] = "2025",
    ["sab game release year"] = "2025",
    ["sab launched"] = "may2025",
    ["sab launched date"] = "may2025",
    ["sab launched day"] = "16",
    ["sab launched month"] = "may",
    ["sab launched release"] = "may2025",
    ["sab launched release date"] = "may2025",
    ["sab launched release day"] = "16",
    ["sab launched release month"] = "may",
    ["sab launched release year"] = "2025",
    ["sab launched year"] = "2025",
    ["sab made"] = "may2025",
    ["sab made date"] = "may2025",
    ["sab made day"] = "16",
    ["sab made month"] = "may",
    ["sab made release"] = "may2025",
    ["sab made release date"] = "may2025",
    ["sab made release day"] = "16",
    ["sab made release month"] = "may",
    ["sab made release year"] = "2025",
    ["sab made year"] = "2025",
    ["sab month"] = "may",
    ["sab release"] = "may2025",
    ["sab release date"] = "may2025",
    ["sab release day"] = "16",
    ["sab release month"] = "may",
    ["sab release release"] = "may2025",
    ["sab release release date"] = "may2025",
    ["sab release release day"] = "16",
    ["sab release release month"] = "may",
    ["sab release release year"] = "2025",
    ["sab release year"] = "2025",
    ["sab released"] = "may2025",
    ["sab released date"] = "may2025",
    ["sab released day"] = "16",
    ["sab released month"] = "may",
    ["sab released release"] = "may2025",
    ["sab released release date"] = "may2025",
    ["sab released release day"] = "16",
    ["sab released release month"] = "may",
    ["sab released release year"] = "2025",
    ["sab released year"] = "2025",
    ["sab year"] = "2025",
    ["sammy"] = "sammy",
    ["sammy 2nd name"] = "brakta",
    ["sammy avatar color"] = "red",
    ["sammy began making games on roblox in"] = "2013",
    ["sammy began making games on roblox in 2013"] = "2013",
    ["sammy began making games on roblox in 2013 release year"] = "2013",
    ["sammy began making games on roblox in 2013 year"] = "2013",
    ["sammy began making games on roblox in release year"] = "2013",
    ["sammy began making games on roblox in year"] = "2013",
    ["sammy brainrot"] = "meowl",
    ["sammy brakta"] = "brakta",
    ["sammy car color"] = "red",
    ["sammy cat"] = "nova",
    ["sammy cat name"] = "nova",
    ["sammy dog"] = "rocky",
    ["sammy dog name"] = "rocky",
    ["sammy enemy"] = "jandel",
    ["sammy fav mutation"] = "galaxy",
    ["sammy fav mutation date"] = "august2025",
    ["sammy fav mutation day"] = "23",
    ["sammy fav mutation month"] = "august",
    ["sammy fav mutation release"] = "august2025",
    ["sammy fav mutation release date"] = "august2025",
    ["sammy fav mutation release day"] = "23",
    ["sammy fav mutation release month"] = "august",
    ["sammy fav mutation release year"] = "2025",
    ["sammy fav mutation year"] = "2025",
    ["sammy fav number"] = "67",
    ["sammy favorite game"] = "fortnite",
    ["sammy favorite game is fortnite"] = "fortnite",
    ["sammy favorite mutation"] = "galaxy",
    ["sammy favorite mutation date"] = "august2025",
    ["sammy favorite mutation day"] = "23",
    ["sammy favorite mutation month"] = "august",
    ["sammy favorite mutation release"] = "august2025",
    ["sammy favorite mutation release date"] = "august2025",
    ["sammy favorite mutation release day"] = "23",
    ["sammy favorite mutation release month"] = "august",
    ["sammy favorite mutation release year"] = "2025",
    ["sammy favorite mutation year"] = "2025",
    ["sammy favorite number"] = "67",
    ["sammy favorite visual mutation for meowl"] = "cyber",
    ["sammy favorite visual mutation for meowl date"] = "april2026",
    ["sammy favorite visual mutation for meowl day"] = "18",
    ["sammy favorite visual mutation for meowl month"] = "april",
    ["sammy favorite visual mutation for meowl release"] = "april2026",
    ["sammy favorite visual mutation for meowl release date"] = "april2026",
    ["sammy favorite visual mutation for meowl release day"] = "18",
    ["sammy favorite visual mutation for meowl release month"] = "april",
    ["sammy favorite visual mutation for meowl release year"] = "2026",
    ["sammy favorite visual mutation for meowl year"] = "2026",
    ["sammy favourite game"] = "fortnite",
    ["sammy favourite game is fortnite"] = "fortnite",
    ["sammy favourite mutation"] = "galaxy",
    ["sammy favourite mutation date"] = "august2025",
    ["sammy favourite mutation day"] = "23",
    ["sammy favourite mutation month"] = "august",
    ["sammy favourite mutation release"] = "august2025",
    ["sammy favourite mutation release date"] = "august2025",
    ["sammy favourite mutation release day"] = "23",
    ["sammy favourite mutation release month"] = "august",
    ["sammy favourite mutation release year"] = "2025",
    ["sammy favourite mutation year"] = "2025",
    ["sammy favourite number"] = "67",
    ["sammy first game"] = "crabgame",
    ["sammy hair color"] = "black",
    ["sammy hair colour"] = "black",
    ["sammy hated group"] = "secretverse",
    ["sammy hated studio"] = "secretverse",
    ["sammy is a competitive player at"] = "valorant",
    ["sammy is a competitive player at valorant"] = "valorant",
    ["sammy is competitive player at"] = "valorant",
    ["sammy is competitive player at valorant"] = "valorant",
    ["sammy is competitive player at valorant his favorite game is fortnite"] = "valorant",
    ["sammy is competitive player at valorant his favourite game is fortnite"] = "valorant",
    ["sammy last name"] = "brakta",
    ["sammy least fav game"] = "growagarden",
    ["sammy least fav group"] = "secretverse",
    ["sammy least fav person"] = "secretlokii",
    ["sammy least fav studio"] = "secretverse",
    ["sammy least favorite game"] = "growagarden",
    ["sammy least favorite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammy least favorite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammy least favorite group"] = "secretverse",
    ["sammy least favorite person"] = "secretlokii",
    ["sammy least favorite studio"] = "secretverse",
    ["sammy least favourite game"] = "growagarden",
    ["sammy least favourite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammy least favourite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammy least favourite group"] = "secretverse",
    ["sammy least favourite person"] = "secretlokii",
    ["sammy least favourite studio"] = "secretverse",
    ["sammy loves to play"] = "fortnite",
    ["sammy middle name"] = "brakta",
    ["sammy name"] = "sammy",
    ["sammy number"] = "67",
    ["sammy pet"] = "rocky",
    ["sammy pet name"] = "rocky",
    ["sammy real"] = "sammy",
    ["sammy roblox avatar color"] = "red",
    ["sammy second name"] = "brakta",
    ["sammy surname"] = "brakta",
    ["sammy truckini"] = "sammynitruckini",
    ["sammy worst person"] = "secretlokii",
    ["sammyni spyderini"] = "sammynispyderini",
    ["sammyni spyderini and unclito samito and gattatino nyanino"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["sammyni spyderini unclito samito gattatino nyanino"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["sammyni truckini"] = "sammynitruckini",
    ["sammynispyderini"] = "sammynispyderini",
    ["sammynispyderiniunclitosamitogattatinonyanino"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["sammynitruckini"] = "sammynitruckini",
    ["sammys 2nd name"] = "brakta",
    ["sammys cat"] = "nova",
    ["sammys cat name"] = "nova",
    ["sammys dog"] = "rocky",
    ["sammys dog name"] = "rocky",
    ["sammys dogs name"] = "rocky",
    ["sammys fav number"] = "67",
    ["sammys favorite game"] = "fortnite",
    ["sammys favorite mutation"] = "galaxy",
    ["sammys favorite mutation date"] = "august2025",
    ["sammys favorite mutation day"] = "23",
    ["sammys favorite mutation month"] = "august",
    ["sammys favorite mutation release"] = "august2025",
    ["sammys favorite mutation release date"] = "august2025",
    ["sammys favorite mutation release day"] = "23",
    ["sammys favorite mutation release month"] = "august",
    ["sammys favorite mutation release year"] = "2025",
    ["sammys favorite mutation year"] = "2025",
    ["sammys favorite number"] = "67",
    ["sammys favorite visual mutation for meowl"] = "cyber",
    ["sammys favorite visual mutation for meowl date"] = "april2026",
    ["sammys favorite visual mutation for meowl day"] = "18",
    ["sammys favorite visual mutation for meowl month"] = "april",
    ["sammys favorite visual mutation for meowl release"] = "april2026",
    ["sammys favorite visual mutation for meowl release date"] = "april2026",
    ["sammys favorite visual mutation for meowl release day"] = "18",
    ["sammys favorite visual mutation for meowl release month"] = "april",
    ["sammys favorite visual mutation for meowl release year"] = "2026",
    ["sammys favorite visual mutation for meowl year"] = "2026",
    ["sammys favourite game"] = "fortnite",
    ["sammys favourite mutation"] = "galaxy",
    ["sammys favourite mutation date"] = "august2025",
    ["sammys favourite mutation day"] = "23",
    ["sammys favourite mutation month"] = "august",
    ["sammys favourite mutation release"] = "august2025",
    ["sammys favourite mutation release date"] = "august2025",
    ["sammys favourite mutation release day"] = "23",
    ["sammys favourite mutation release month"] = "august",
    ["sammys favourite mutation release year"] = "2025",
    ["sammys favourite mutation year"] = "2025",
    ["sammys favourite number"] = "67",
    ["sammys hair color"] = "black",
    ["sammys hair colour"] = "black",
    ["sammys hated group"] = "secretverse",
    ["sammys hated studio"] = "secretverse",
    ["sammys last name"] = "brakta",
    ["sammys least favorite game"] = "growagarden",
    ["sammys least favorite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammys least favorite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammys least favorite group"] = "secretverse",
    ["sammys least favorite person"] = "secretlokii",
    ["sammys least favorite studio"] = "secretverse",
    ["sammys least favourite game"] = "growagarden",
    ["sammys least favourite game is 1 speed keyboard escape"] = "1speedkeyboardescape",
    ["sammys least favourite game is 1speedkeyboardescape"] = "1speedkeyboardescape",
    ["sammys least favourite group"] = "secretverse",
    ["sammys least favourite person"] = "secretlokii",
    ["sammys least favourite studio"] = "secretverse",
    ["sammys middle name"] = "brakta",
    ["sammys pet"] = "rocky",
    ["sammys pet name"] = "rocky",
    ["sammys second name"] = "brakta",
    ["sammys surname"] = "brakta",
    ["sammys worst person"] = "secretlokii",
    ["sammytruckini"] = "sammynitruckini",
    ["santa fuse"] = "santafuse",
    ["santa fuse date"] = "december2025",
    ["santa fuse day"] = "6",
    ["santa fuse month"] = "december",
    ["santa fuse release"] = "december2025",
    ["santa fuse release date"] = "december2025",
    ["santa fuse release day"] = "6",
    ["santa fuse release month"] = "december",
    ["santa fuse release year"] = "2025",
    ["santa fuse year"] = "2025",
    ["santa hat trait"] = "santahat",
    ["santa hat trait date"] = "december2025",
    ["santa hat trait month"] = "december",
    ["santa hat trait release"] = "december2025",
    ["santa hat trait release date"] = "december2025",
    ["santa hat trait release month"] = "december",
    ["santa hat trait release year"] = "2025",
    ["santa hat trait year"] = "2025",
    ["santa machine"] = "santafuse",
    ["santa machine date"] = "december2025",
    ["santa machine day"] = "6",
    ["santa machine month"] = "december",
    ["santa machine release"] = "december2025",
    ["santa machine release date"] = "december2025",
    ["santa machine release day"] = "6",
    ["santa machine release month"] = "december",
    ["santa machine release year"] = "2025",
    ["santa machine year"] = "2025",
    ["santafuse"] = "santafuse",
    ["santahat"] = "santahat",
    ["santahat trait"] = "santahat",
    ["santahat trait date"] = "december2025",
    ["santahat trait month"] = "december",
    ["santahat trait release"] = "december2025",
    ["santahat trait release date"] = "december2025",
    ["santahat trait release month"] = "december",
    ["santahat trait release year"] = "2025",
    ["santahat trait year"] = "2025",
    ["santas fuse"] = "santafuse",
    ["santas fuse date"] = "december2025",
    ["santas fuse day"] = "6",
    ["santas fuse machine"] = "santafuse",
    ["santas fuse machine date"] = "december2025",
    ["santas fuse machine day"] = "6",
    ["santas fuse machine month"] = "december",
    ["santas fuse machine release"] = "december2025",
    ["santas fuse machine release date"] = "december2025",
    ["santas fuse machine release day"] = "6",
    ["santas fuse machine release month"] = "december",
    ["santas fuse machine release year"] = "2025",
    ["santas fuse machine year"] = "2025",
    ["santas fuse month"] = "december",
    ["santas fuse release"] = "december2025",
    ["santas fuse release date"] = "december2025",
    ["santas fuse release day"] = "6",
    ["santas fuse release month"] = "december",
    ["santas fuse release year"] = "2025",
    ["santas fuse year"] = "2025",
    ["season"] = "autumn",
    ["season currently"] = "autumn",
    ["season in"] = "autumn",
    ["season suffering"] = "autumn",
    ["season we are currently in"] = "autumn",
    ["season we are currently in is"] = "autumn",
    ["season we are in"] = "autumn",
    ["season we are suffering"] = "autumn",
    ["season we are suffering is"] = "autumn",
    ["second best"] = "strawberryelephant",
    ["second best brainrot"] = "strawberryelephant",
    ["second best brainrot in game"] = "strawberryelephant",
    ["second best brainrot in the game"] = "strawberryelephant",
    ["second best taco merchant"] = "nachorilla",
    ["second brainrot that got removed"] = "crocidilopenisini",
    ["second brainrot that was reworked"] = "unclitosamito",
    ["second fuse"] = "witchfuse",
    ["second fuse date"] = "october2025",
    ["second fuse day"] = "11",
    ["second fuse machine"] = "witchfuse",
    ["second fuse machine date"] = "october2025",
    ["second fuse machine day"] = "11",
    ["second fuse machine month"] = "october",
    ["second fuse machine release"] = "october2025",
    ["second fuse machine release date"] = "october2025",
    ["second fuse machine release day"] = "11",
    ["second fuse machine release month"] = "october",
    ["second fuse machine release year"] = "2025",
    ["second fuse machine year"] = "2025",
    ["second fuse month"] = "october",
    ["second fuse release"] = "october2025",
    ["second fuse release date"] = "october2025",
    ["second fuse release day"] = "11",
    ["second fuse release month"] = "october",
    ["second fuse release year"] = "2025",
    ["second fuse year"] = "2025",
    ["second name"] = "brakta",
    ["second name of sammy"] = "brakta",
    ["second name of sammy is"] = "brakta",
    ["second name of sammy is brakta"] = "brakta",
    ["second name of sammys"] = "brakta",
    ["second og"] = "meowl",
    ["second og added"] = "meowl",
    ["second og added in sab"] = "meowl",
    ["second og added in the game"] = "meowl",
    ["second og added to sab"] = "meowl",
    ["second og added to the game"] = "meowl",
    ["second og brainrot"] = "meowl",
    ["second og in sab"] = "meowl",
    ["second og in the game"] = "meowl",
    ["second removed brainrot"] = "crocidilopenisini",
    ["second reworked brainrot"] = "unclitosamito",
    ["second taco merchant"] = "nachorilla",
    ["secret brainrot"] = "lavaccasaturnosaturnita",
    ["secret loki"] = "secretlokii",
    ["secret lokii"] = "secretlokii",
    ["secret lucky block"] = "july2025",
    ["secret lucky block date"] = "july2025",
    ["secret lucky block day"] = "12",
    ["secret lucky block month"] = "july",
    ["secret lucky block release"] = "july2025",
    ["secret lucky block release date"] = "july2025",
    ["secret lucky block release day"] = "12",
    ["secret lucky block release month"] = "july",
    ["secret lucky block release year"] = "2025",
    ["secret lucky block year"] = "2025",
    ["secret sab"] = "lavaccasaturnosaturnita",
    ["secret steal"] = "strawberryelephant",
    ["secret sub"] = "lavaccasaturnosaturnita",
    ["secretloki"] = "secretlokii",
    ["secretlokii"] = "secretlokii",
    ["secretverse"] = "secretverse",
    ["secretverse studio"] = "secretverse",
    ["secretversestudio"] = "secretverse",
    ["serpent"] = "hydraserpent",
    ["setup"] = "windows11",
    ["shark"] = "shark",
    ["shark trait"] = "shark",
    ["shark trait date"] = "june2025",
    ["shark trait month"] = "june",
    ["shark trait release"] = "june2025",
    ["shark trait release date"] = "june2025",
    ["shark trait release month"] = "june",
    ["shark trait release year"] = "2025",
    ["shark trait year"] = "2025",
    ["sharkfin"] = "sharkfin",
    ["shirt color"] = "red",
    ["signore"] = "signorecarapace",
    ["signore carapace color"] = "white",
    ["signore carapace suit color"] = "blue",
    ["signorecarapace"] = "white",
    ["silver"] = "silver",
    ["singer"] = "drake",
    ["sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["sixth brainrot based off mythical creature"] = "hydraserpent",
    ["sixth brainrot based off of a mythical creature"] = "hydraserpent",
    ["sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["sixth brainrot based on mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based off of a mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["sixth brainrot to be based on mythical creature"] = "hydraserpent",
    ["sixth mythical"] = "hydraserpent",
    ["sixth mythical brainrot"] = "hydraserpent",
    ["sixth mythical creature"] = "hydraserpent",
    ["sixth mythical creature brainrot"] = "hydraserpent",
    ["sixth og"] = "spyderelephant",
    ["sixth og brainrot"] = "spyderelephant",
    ["skeleton"] = "skeleton",
    ["skeleton trait"] = "skeleton",
    ["skeleton trait date"] = "september2025",
    ["skeleton trait day"] = "13",
    ["skeleton trait month"] = "september",
    ["skeleton trait release"] = "september2025",
    ["skeleton trait release date"] = "september2025",
    ["skeleton trait release day"] = "13",
    ["skeleton trait release month"] = "september",
    ["skeleton trait release year"] = "2025",
    ["skeleton trait year"] = "2025",
    ["skibidi"] = "skibidi",
    ["skibidi toilet added"] = "december2025",
    ["skibidi toilet color"] = "white",
    ["skibidi toilet date"] = "december2025",
    ["skibidi toilet day"] = "1",
    ["skibidi toilet month"] = "december",
    ["skibidi toilet release"] = "december2025",
    ["skibidi toilet release date"] = "december2025",
    ["skibidi toilet release day"] = "1",
    ["skibidi toilet release month"] = "december",
    ["skibidi toilet release year"] = "2025",
    ["skibidi toilet released"] = "december2025",
    ["skibidi toilet year"] = "2025",
    ["skibidi trait"] = "skibidi",
    ["skibidi trait date"] = "june2025",
    ["skibidi trait month"] = "june",
    ["skibidi trait release"] = "june2025",
    ["skibidi trait release date"] = "june2025",
    ["skibidi trait release month"] = "june",
    ["skibidi trait release year"] = "2025",
    ["skibidi trait year"] = "2025",
    ["skibiditoilet"] = "skibiditoilet",
    ["skibiditoilet date"] = "december2025",
    ["skibiditoilet day"] = "1",
    ["skibiditoilet month"] = "december",
    ["skibiditoilet release"] = "december2025",
    ["skibiditoilet release date"] = "december2025",
    ["skibiditoilet release day"] = "1",
    ["skibiditoilet release month"] = "december",
    ["skibiditoilet release year"] = "2025",
    ["skibiditoilet year"] = "2025",
    ["skin color"] = "yellow",
    ["sleepy"] = "sleepy",
    ["sleepy trait"] = "sleepy",
    ["snake brainrot"] = "hydraserpent",
    ["snake brainrot his name"] = "hydraserpent",
    ["snake brainrot name"] = "hydraserpent",
    ["snake brainrots name"] = "hydraserpent",
    ["snow"] = "snow",
    ["snow trait"] = "snow",
    ["snow trait date"] = "june2025",
    ["snow trait month"] = "june",
    ["snow trait release"] = "june2025",
    ["snow trait release date"] = "june2025",
    ["snow trait release month"] = "june",
    ["snow trait release year"] = "2025",
    ["snow trait year"] = "2025",
    ["snow weather trait"] = "snow",
    ["snow weather trait date"] = "june2025",
    ["snow weather trait month"] = "june",
    ["snow weather trait release"] = "june2025",
    ["snow weather trait release date"] = "june2025",
    ["snow weather trait release month"] = "june",
    ["snow weather trait release year"] = "2025",
    ["snow weather trait year"] = "2025",
    ["snowy trait"] = "snow",
    ["snowy trait date"] = "june2025",
    ["snowy trait month"] = "june",
    ["snowy trait release"] = "june2025",
    ["snowy trait release date"] = "june2025",
    ["snowy trait release month"] = "june",
    ["snowy trait release year"] = "2025",
    ["snowy trait year"] = "2025",
    ["solar flare trait"] = "fire",
    ["solar flare trait date"] = "june2025",
    ["solar flare trait month"] = "june",
    ["solar flare trait release"] = "june2025",
    ["solar flare trait release date"] = "june2025",
    ["solar flare trait release month"] = "june",
    ["solar flare trait release year"] = "2025",
    ["solar flare trait year"] = "2025",
    ["song"] = "drake",
    ["spaghetti tualetti"] = "spaghettitualetti",
    ["spaghettitualetti"] = "spaghettitualetti",
    ["spain"] = "spain",
    ["spain event trait"] = "bull",
    ["spain event trait date"] = "july2026",
    ["spain event trait day"] = "25",
    ["spain event trait month"] = "july",
    ["spain event trait release"] = "july2026",
    ["spain event trait release date"] = "july2026",
    ["spain event trait release day"] = "25",
    ["spain event trait release month"] = "july",
    ["spain event trait release year"] = "2026",
    ["spain event trait year"] = "2026",
    ["spain trait"] = "bull",
    ["spain trait date"] = "july2026",
    ["spain trait day"] = "25",
    ["spain trait month"] = "july",
    ["spain trait release"] = "july2026",
    ["spain trait release date"] = "july2026",
    ["spain trait release day"] = "25",
    ["spain trait release month"] = "july",
    ["spain trait release year"] = "2026",
    ["spain trait year"] = "2026",
    ["spider"] = "spider",
    ["spiderelephant"] = "spyderelephant",
    ["spyder"] = "SpyderElephant",
    ["spyder chain"] = "spyderchain",
    ["spyder elephant added"] = "may2026",
    ["spyder elephant color"] = "gray",
    ["spyder elephant date"] = "may2026",
    ["spyder elephant day"] = "1",
    ["spyder elephant material"] = "silver",
    ["spyder elephant month"] = "may",
    ["spyder elephant release"] = "may2026",
    ["spyder elephant release date"] = "may2026",
    ["spyder elephant release day"] = "1",
    ["spyder elephant release month"] = "may",
    ["spyder elephant release year"] = "2026",
    ["spyder elephant released"] = "may2026",
    ["spyder elephant year"] = "2026",
    ["spyderchain"] = "spyderchain",
    ["spyderelephant"] = "spyderelephant",
    ["spyderelephant date"] = "may2026",
    ["spyderelephant day"] = "1",
    ["spyderelephant month"] = "may",
    ["spyderelephant release"] = "may2026",
    ["spyderelephant release date"] = "may2026",
    ["spyderelephant release day"] = "1",
    ["spyderelephant release month"] = "may",
    ["spyderelephant release year"] = "2026",
    ["spyderelephant year"] = "2026",
    ["starfall"] = "starfall",
    ["starfall trait"] = "starfall",
    ["starfall trait date"] = "june2025",
    ["starfall trait month"] = "june",
    ["starfall trait release"] = "june2025",
    ["starfall trait release date"] = "june2025",
    ["starfall trait release month"] = "june",
    ["starfall trait release year"] = "2025",
    ["starfall trait year"] = "2025",
    ["starfall weather trait"] = "starfall",
    ["starfall weather trait date"] = "june2025",
    ["starfall weather trait month"] = "june",
    ["starfall weather trait release"] = "june2025",
    ["starfall weather trait release date"] = "june2025",
    ["starfall weather trait release month"] = "june",
    ["starfall weather trait release year"] = "2025",
    ["starfall weather trait year"] = "2025",
    ["started making games"] = "2013",
    ["started making games in roblox"] = "2013",
    ["started making games in roblox release year"] = "2013",
    ["started making games in roblox year"] = "2013",
    ["started making games on roblox"] = "2013",
    ["started making games on roblox release year"] = "2013",
    ["started making games on roblox year"] = "2013",
    ["started making games release year"] = "2013",
    ["started making games year"] = "2013",
    ["steak"] = "steak",
    ["steal a brainrot created"] = "may2025",
    ["steal a brainrot created date"] = "may2025",
    ["steal a brainrot created day"] = "16",
    ["steal a brainrot created month"] = "may",
    ["steal a brainrot created release"] = "may2025",
    ["steal a brainrot created release date"] = "may2025",
    ["steal a brainrot created release day"] = "16",
    ["steal a brainrot created release month"] = "may",
    ["steal a brainrot created release year"] = "2025",
    ["steal a brainrot created year"] = "2025",
    ["steal a brainrot game"] = "may2025",
    ["steal a brainrot game date"] = "may2025",
    ["steal a brainrot game day"] = "16",
    ["steal a brainrot game month"] = "may",
    ["steal a brainrot game release"] = "may2025",
    ["steal a brainrot game release date"] = "may2025",
    ["steal a brainrot game release day"] = "16",
    ["steal a brainrot game release month"] = "may",
    ["steal a brainrot game release year"] = "2025",
    ["steal a brainrot game year"] = "2025",
    ["steal a brainrot launched"] = "may2025",
    ["steal a brainrot launched date"] = "may2025",
    ["steal a brainrot launched day"] = "16",
    ["steal a brainrot launched month"] = "may",
    ["steal a brainrot launched release"] = "may2025",
    ["steal a brainrot launched release date"] = "may2025",
    ["steal a brainrot launched release day"] = "16",
    ["steal a brainrot launched release month"] = "may",
    ["steal a brainrot launched release year"] = "2025",
    ["steal a brainrot launched year"] = "2025",
    ["steal a brainrot made"] = "may2025",
    ["steal a brainrot made date"] = "may2025",
    ["steal a brainrot made day"] = "16",
    ["steal a brainrot made month"] = "may",
    ["steal a brainrot made release"] = "may2025",
    ["steal a brainrot made release date"] = "may2025",
    ["steal a brainrot made release day"] = "16",
    ["steal a brainrot made release month"] = "may",
    ["steal a brainrot made release year"] = "2025",
    ["steal a brainrot made year"] = "2025",
    ["steal a brainrot release"] = "may2025",
    ["steal a brainrot release date"] = "may2025",
    ["steal a brainrot release day"] = "16",
    ["steal a brainrot release month"] = "may",
    ["steal a brainrot release release"] = "may2025",
    ["steal a brainrot release release date"] = "may2025",
    ["steal a brainrot release release day"] = "16",
    ["steal a brainrot release release month"] = "may",
    ["steal a brainrot release release year"] = "2025",
    ["steal a brainrot release year"] = "2025",
    ["steal a brainrot released"] = "may2025",
    ["steal a brainrot released date"] = "may2025",
    ["steal a brainrot released day"] = "16",
    ["steal a brainrot released month"] = "may",
    ["steal a brainrot released release"] = "may2025",
    ["steal a brainrot released release date"] = "may2025",
    ["steal a brainrot released release day"] = "16",
    ["steal a brainrot released release month"] = "may",
    ["steal a brainrot released release year"] = "2025",
    ["steal a brainrot released year"] = "2025",
    ["strawberry"] = "StrawberryElephant",
    ["strawberry elephant added"] = "august2025",
    ["strawberry elephant base exist"] = "1277",
    ["strawberry elephant color"] = "red",
    ["strawberry elephant crystal exist"] = "1",
    ["strawberry elephant date"] = "august2025",
    ["strawberry elephant day"] = "1",
    ["strawberry elephant diamond exist"] = "263",
    ["strawberry elephant exist"] = "2348",
    ["strawberry elephant exist count"] = "2348",
    ["strawberry elephant exists"] = "2348",
    ["strawberry elephant gold exist"] = "565",
    ["strawberry elephant gold mutation exist count"] = "565",
    ["strawberry elephant month"] = "august",
    ["strawberry elephant normal exist"] = "1277",
    ["strawberry elephant rainbow exist"] = "87",
    ["strawberry elephant release"] = "august2025",
    ["strawberry elephant release date"] = "august2025",
    ["strawberry elephant release day"] = "1",
    ["strawberry elephant release month"] = "august",
    ["strawberry elephant release year"] = "2025",
    ["strawberry elephant released"] = "august2025",
    ["strawberry elephant total exist"] = "2348",
    ["strawberry elephant total exist count"] = "2348",
    ["strawberry elephant year"] = "2025",
    ["strawberry elephants base exist"] = "1277",
    ["strawberry elephants crystal exist"] = "1",
    ["strawberry elephants diamond exist"] = "263",
    ["strawberry elephants exist"] = "2348",
    ["strawberry elephants exist count"] = "2348",
    ["strawberry elephants exists"] = "2348",
    ["strawberry elephants gold exist"] = "565",
    ["strawberry elephants normal exist"] = "1277",
    ["strawberry elephants rainbow exist"] = "87",
    ["strawberry elephants total exist"] = "2348",
    ["strawberry elephants total exist count"] = "2348",
    ["strawberryelephant"] = "strawberryelephant",
    ["strawberryelephant date"] = "august2025",
    ["strawberryelephant day"] = "1",
    ["strawberryelephant month"] = "august",
    ["strawberryelephant release"] = "august2025",
    ["strawberryelephant release date"] = "august2025",
    ["strawberryelephant release day"] = "1",
    ["strawberryelephant release month"] = "august",
    ["strawberryelephant release year"] = "2025",
    ["strawberryelephant year"] = "2025",
    ["strongest brainrot"] = "lupaandlipa",
    ["strongest brainrot added"] = "lupaandlipa",
    ["strongest brainrot added date"] = "august2026",
    ["strongest brainrot added day"] = "22",
    ["strongest brainrot added last saturday"] = "orchidox",
    ["strongest brainrot added last week"] = "orchidox",
    ["strongest brainrot added month"] = "august",
    ["strongest brainrot added recently"] = "lupaandlipa",
    ["strongest brainrot added recently date"] = "august2026",
    ["strongest brainrot added recently day"] = "22",
    ["strongest brainrot added recently month"] = "august",
    ["strongest brainrot added recently release"] = "august2026",
    ["strongest brainrot added recently release date"] = "august2026",
    ["strongest brainrot added recently release day"] = "22",
    ["strongest brainrot added recently release month"] = "august",
    ["strongest brainrot added recently release year"] = "2026",
    ["strongest brainrot added recently year"] = "2026",
    ["strongest brainrot added release"] = "august2026",
    ["strongest brainrot added release date"] = "august2026",
    ["strongest brainrot added release day"] = "22",
    ["strongest brainrot added release month"] = "august",
    ["strongest brainrot added release year"] = "2026",
    ["strongest brainrot added year"] = "2026",
    ["strongest brainrot recently"] = "lupaandlipa",
    ["strongest brainrot recently date"] = "august2026",
    ["strongest brainrot recently day"] = "22",
    ["strongest brainrot recently month"] = "august",
    ["strongest brainrot recently release"] = "august2026",
    ["strongest brainrot recently release date"] = "august2026",
    ["strongest brainrot recently release day"] = "22",
    ["strongest brainrot recently release month"] = "august",
    ["strongest brainrot recently release year"] = "2026",
    ["strongest brainrot recently year"] = "2026",
    ["strongest brainrot released last saturday"] = "orchidox",
    ["strongest brainrot released last week"] = "orchidox",
    ["strongest brainrot released recently"] = "lupaandlipa",
    ["strongest brainrot released recently date"] = "august2026",
    ["strongest brainrot released recently day"] = "22",
    ["strongest brainrot released recently month"] = "august",
    ["strongest brainrot released recently release"] = "august2026",
    ["strongest brainrot released recently release date"] = "august2026",
    ["strongest brainrot released recently release day"] = "22",
    ["strongest brainrot released recently release month"] = "august",
    ["strongest brainrot released recently release year"] = "2026",
    ["strongest brainrot released recently year"] = "2026",
    ["strongest brainrot that was added"] = "lupaandlipa",
    ["strongest brainrot that was added date"] = "august2026",
    ["strongest brainrot that was added day"] = "22",
    ["strongest brainrot that was added month"] = "august",
    ["strongest brainrot that was added recently"] = "lupaandlipa",
    ["strongest brainrot that was added recently date"] = "august2026",
    ["strongest brainrot that was added recently day"] = "22",
    ["strongest brainrot that was added recently month"] = "august",
    ["strongest brainrot that was added recently release"] = "august2026",
    ["strongest brainrot that was added recently release date"] = "august2026",
    ["strongest brainrot that was added recently release day"] = "22",
    ["strongest brainrot that was added recently release month"] = "august",
    ["strongest brainrot that was added recently release year"] = "2026",
    ["strongest brainrot that was added recently year"] = "2026",
    ["strongest brainrot that was added release"] = "august2026",
    ["strongest brainrot that was added release date"] = "august2026",
    ["strongest brainrot that was added release day"] = "22",
    ["strongest brainrot that was added release month"] = "august",
    ["strongest brainrot that was added release year"] = "2026",
    ["strongest brainrot that was added year"] = "2026",
    ["strongest brainrot that was released recently"] = "lupaandlipa",
    ["strongest brainrot that was released recently date"] = "august2026",
    ["strongest brainrot that was released recently day"] = "22",
    ["strongest brainrot that was released recently month"] = "august",
    ["strongest brainrot that was released recently release"] = "august2026",
    ["strongest brainrot that was released recently release date"] = "august2026",
    ["strongest brainrot that was released recently release day"] = "22",
    ["strongest brainrot that was released recently release month"] = "august",
    ["strongest brainrot that was released recently release year"] = "2026",
    ["strongest brainrot that was released recently year"] = "2026",
    ["strongest mutation"] = "crystal",
    ["studio hate"] = "secretverse",
    ["studio hate most"] = "secretverse",
    ["studio hates"] = "secretverse",
    ["studio hates most"] = "secretverse",
    ["studio i hate"] = "secretverse",
    ["studio i hate most"] = "secretverse",
    ["studio i hate the most"] = "secretverse",
    ["studio sammy hates"] = "secretverse",
    ["studio sammy hates most"] = "secretverse",
    ["studio sammy hates the most"] = "secretverse",
    ["suffering season"] = "autumn",
    ["summer"] = "summer",
    ["summer fuse"] = "summerfuse",
    ["summer fuse date"] = "may2026",
    ["summer fuse day"] = "23",
    ["summer fuse machine"] = "summerfuse",
    ["summer fuse machine date"] = "may2026",
    ["summer fuse machine day"] = "23",
    ["summer fuse machine month"] = "may",
    ["summer fuse machine release"] = "may2026",
    ["summer fuse machine release date"] = "may2026",
    ["summer fuse machine release day"] = "23",
    ["summer fuse machine release month"] = "may",
    ["summer fuse machine release year"] = "2026",
    ["summer fuse machine year"] = "2026",
    ["summer fuse month"] = "may",
    ["summer fuse release"] = "may2026",
    ["summer fuse release date"] = "may2026",
    ["summer fuse release day"] = "23",
    ["summer fuse release month"] = "may",
    ["summer fuse release year"] = "2026",
    ["summer fuse year"] = "2026",
    ["summerfuse"] = "summerfuse",
    ["summeroceandragon"] = "dragonaquanini",
    ["surname"] = "brakta",
    ["syrup"] = "pancakeandsyrup",
    ["taco"] = "taco",
    ["taco block"] = "september2025",
    ["taco block date"] = "september2025",
    ["taco block day"] = "16",
    ["taco block month"] = "september",
    ["taco block release"] = "september2025",
    ["taco block release date"] = "september2025",
    ["taco block release day"] = "16",
    ["taco block release month"] = "september",
    ["taco block release year"] = "2025",
    ["taco block year"] = "2025",
    ["taco blocks"] = "november2025",
    ["taco blocks date"] = "november2025",
    ["taco blocks day"] = "18",
    ["taco blocks month"] = "november",
    ["taco blocks release"] = "november2025",
    ["taco blocks release date"] = "november2025",
    ["taco blocks release day"] = "18",
    ["taco blocks release month"] = "november",
    ["taco blocks release year"] = "2025",
    ["taco blocks year"] = "2025",
    ["taco combinasion"] = "latacocombinasion",
    ["taco lucky block"] = "september2025",
    ["taco lucky block date"] = "september2025",
    ["taco lucky block day"] = "16",
    ["taco lucky block month"] = "september",
    ["taco lucky block release"] = "september2025",
    ["taco lucky block release date"] = "september2025",
    ["taco lucky block release day"] = "16",
    ["taco lucky block release month"] = "september",
    ["taco lucky block release year"] = "2025",
    ["taco lucky block year"] = "2025",
    ["taco merchant"] = "tacomerchant",
    ["taco merchant date"] = "august2026",
    ["taco merchant day"] = "18",
    ["taco merchant month"] = "august",
    ["taco merchant npc"] = "tacomerchant",
    ["taco merchant npc date"] = "august2026",
    ["taco merchant npc day"] = "18",
    ["taco merchant npc month"] = "august",
    ["taco merchant npc release"] = "august2026",
    ["taco merchant npc release date"] = "august2026",
    ["taco merchant npc release day"] = "18",
    ["taco merchant npc release month"] = "august",
    ["taco merchant npc release year"] = "2026",
    ["taco merchant npc year"] = "2026",
    ["taco merchant release"] = "august2026",
    ["taco merchant release date"] = "august2026",
    ["taco merchant release day"] = "18",
    ["taco merchant release month"] = "august",
    ["taco merchant release year"] = "2026",
    ["taco merchant year"] = "2026",
    ["taco secret"] = "lacucaracha",
    ["taco shop"] = "tacomerchant",
    ["taco shop date"] = "august2026",
    ["taco shop day"] = "18",
    ["taco shop month"] = "august",
    ["taco shop release"] = "august2026",
    ["taco shop release date"] = "august2026",
    ["taco shop release day"] = "18",
    ["taco shop release month"] = "august",
    ["taco shop release year"] = "2026",
    ["taco shop year"] = "2026",
    ["taco trait"] = "taco",
    ["taco trait date"] = "june2025",
    ["taco trait day"] = "28",
    ["taco trait month"] = "june",
    ["taco trait release"] = "june2025",
    ["taco trait release date"] = "june2025",
    ["taco trait release day"] = "28",
    ["taco trait release month"] = "june",
    ["taco trait release year"] = "2025",
    ["taco trait year"] = "2025",
    ["taco tuesday lucky block"] = "september2025",
    ["taco tuesday lucky block date"] = "september2025",
    ["taco tuesday lucky block day"] = "16",
    ["taco tuesday lucky block month"] = "september",
    ["taco tuesday lucky block release"] = "september2025",
    ["taco tuesday lucky block release date"] = "september2025",
    ["taco tuesday lucky block release day"] = "16",
    ["taco tuesday lucky block release month"] = "september",
    ["taco tuesday lucky block release year"] = "2025",
    ["taco tuesday lucky block year"] = "2025",
    ["taco tuesday trait"] = "taco",
    ["taco tuesday trait date"] = "june2025",
    ["taco tuesday trait day"] = "28",
    ["taco tuesday trait month"] = "june",
    ["taco tuesday trait release"] = "june2025",
    ["taco tuesday trait release date"] = "june2025",
    ["taco tuesday trait release day"] = "28",
    ["taco tuesday trait release month"] = "june",
    ["taco tuesday trait release year"] = "2025",
    ["taco tuesday trait year"] = "2025",
    ["taco turbo tacorito"] = "tacoturbotacorito",
    ["tacocombinasion"] = "LaTacoCombinasion",
    ["tacomerchant"] = "tacomerchant",
    ["taconini"] = "chihuaninitaconini",
    ["tacorillo crocodillo"] = "tacorillocrocodillo",
    ["tacorillocrocodillo"] = "tacorillocrocodillo",
    ["tacorita"] = "tacoritabicicleta",
    ["tacorita bicicleta"] = "tacoritabicicleta",
    ["tacoritabicicleta"] = "tacoritabicicleta",
    ["tacotuesday"] = "tacotuesday",
    ["tacoturbo tacorito"] = "tacoturbotacorito",
    ["tacoturbotacorito"] = "tacoturbotacorito",
    ["the 1st og"] = "strawberryelephant",
    ["the 1st og brainrot"] = "strawberryelephant",
    ["the 1st og brainrot in game"] = "strawberryelephant",
    ["the 1st og brainrot in the game"] = "strawberryelephant",
    ["the 1st og in game"] = "strawberryelephant",
    ["the 1st og in the game"] = "strawberryelephant",
    ["the 1st snake"] = "hydraserpent",
    ["the 1st snake added"] = "hydraserpent",
    ["the 1st snake brainrot"] = "hydraserpent",
    ["the 1st snake brainrot added"] = "hydraserpent",
    ["the 1st snake brainrot ever added"] = "hydraserpent",
    ["the 1st snake brainrot in game"] = "hydraserpent",
    ["the 1st snake brainrot in sab"] = "hydraserpent",
    ["the 1st snake brainrot in the game"] = "hydraserpent",
    ["the 1st snake brainrot that was added"] = "hydraserpent",
    ["the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["the 1st snake ever added"] = "hydraserpent",
    ["the 1st snake in game"] = "hydraserpent",
    ["the 1st snake in sab"] = "hydraserpent",
    ["the 1st snake in the game"] = "hydraserpent",
    ["the 1st snake that was added"] = "hydraserpent",
    ["the 1st snake that was ever added"] = "hydraserpent",
    ["the 2nd best brainrot"] = "strawberryelephant",
    ["the 2nd best brainrot in game"] = "strawberryelephant",
    ["the 2nd best brainrot in the game"] = "strawberryelephant",
    ["the 2nd og"] = "meowl",
    ["the 2nd og brainrot"] = "meowl",
    ["the 3 headed brainrot"] = "hydraserpent",
    ["the 3 headed snake brainrot"] = "hydraserpent",
    ["the 3rd og"] = "skibiditoilet",
    ["the 3rd og brainrot"] = "skibiditoilet",
    ["the 4th 3 headed"] = "hydraserpent",
    ["the 4th 3 headed brainrot"] = "hydraserpent",
    ["the 4th og"] = "headlesshorseman",
    ["the 4th og brainrot"] = "headlesshorseman",
    ["the 4th three headed"] = "hydraserpent",
    ["the 4th three headed brainrot"] = "hydraserpent",
    ["the 5th og"] = "johnpork",
    ["the 5th og brainrot"] = "johnpork",
    ["the 6th brainrot based off a mythical creature"] = "hydraserpent",
    ["the 6th brainrot based off of a mythical creature"] = "hydraserpent",
    ["the 6th brainrot based on a mythical creature"] = "hydraserpent",
    ["the 6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["the 6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["the 6th mythical brainrot"] = "hydraserpent",
    ["the 6th mythical creature"] = "hydraserpent",
    ["the 6th mythical creature brainrot"] = "hydraserpent",
    ["the 6th og"] = "spyderelephant",
    ["the 6th og brainrot"] = "spyderelephant",
    ["the best admin abuse brainrot"] = "lupaandlipa",
    ["the best brainrot"] = "lupaandlipa",
    ["the best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["the best brainrot added in todays update"] = "lupaandlipa",
    ["the best brainrot added last saturday"] = "orchidox",
    ["the best brainrot added last week"] = "orchidox",
    ["the best brainrot added today"] = "lupaandlipa",
    ["the best brainrot except spyder elephant"] = "strawberryelephant",
    ["the best brainrot except spyderelephant"] = "strawberryelephant",
    ["the best brainrot from bee lucky block"] = "orchidox",
    ["the best brainrot from the bee lucky block"] = "orchidox",
    ["the best brainrot in"] = "lupaandlipa",
    ["the best brainrot in bee lucky block"] = "orchidox",
    ["the best brainrot in game"] = "lupaandlipa",
    ["the best brainrot in the"] = "lupaandlipa",
    ["the best brainrot in the bee lucky block"] = "orchidox",
    ["the best brainrot in the game"] = "lupaandlipa",
    ["the best brainrot in todays admin abuse"] = "lupaandlipa",
    ["the best brainrot in todays update"] = "lupaandlipa",
    ["the best brainrot released last saturday"] = "orchidox",
    ["the best brainrot released last week"] = "orchidox",
    ["the best brainrot reskin of me"] = "sammynitruckini",
    ["the best brainrot reskin of sammy"] = "sammynitruckini",
    ["the best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["the best brainrot that was added in todays update"] = "lupaandlipa",
    ["the best brainrot that was added today"] = "lupaandlipa",
    ["the best brainrot today"] = "lupaandlipa",
    ["the best brainrot without spyder elephant"] = "strawberryelephant",
    ["the best brainrot without spyderelephant"] = "strawberryelephant",
    ["the best mutation"] = "crystal",
    ["the best mutation currently"] = "crystal",
    ["the best mutation right now"] = "crystal",
    ["the best reskin of me"] = "sammynitruckini",
    ["the best reskin of sammy"] = "sammynitruckini",
    ["the best visual mutation for meowl"] = "cyber",
    ["the best visual mutation for meowl date"] = "april2026",
    ["the best visual mutation for meowl day"] = "18",
    ["the best visual mutation for meowl month"] = "april",
    ["the best visual mutation for meowl release"] = "april2026",
    ["the best visual mutation for meowl release date"] = "april2026",
    ["the best visual mutation for meowl release day"] = "18",
    ["the best visual mutation for meowl release month"] = "april",
    ["the best visual mutation for meowl release year"] = "2026",
    ["the best visual mutation for meowl year"] = "2026",
    ["the best visual mutation on meowl"] = "cyber",
    ["the best visual mutation on meowl date"] = "april2026",
    ["the best visual mutation on meowl day"] = "18",
    ["the best visual mutation on meowl month"] = "april",
    ["the best visual mutation on meowl release"] = "april2026",
    ["the best visual mutation on meowl release date"] = "april2026",
    ["the best visual mutation on meowl release day"] = "18",
    ["the best visual mutation on meowl release month"] = "april",
    ["the best visual mutation on meowl release year"] = "2026",
    ["the best visual mutation on meowl year"] = "2026",
    ["the brainrot that you get from money money puggy ritual"] = "lospuggies",
    ["the brainrot that you get from money ritual"] = "lospuggies",
    ["the brainrot that you get from new money money puggy ritual"] = "lospuggies",
    ["the brainrot that you get from new ritual"] = "lospuggies",
    ["the brainrot you get from money ritual"] = "lospuggies",
    ["the brainrot you get from new ritual"] = "lospuggies",
    ["the current season"] = "autumn",
    ["the fifth og"] = "johnpork",
    ["the fifth og brainrot"] = "johnpork",
    ["the first og"] = "strawberryelephant",
    ["the first og brainrot"] = "strawberryelephant",
    ["the first og brainrot in game"] = "strawberryelephant",
    ["the first og brainrot in the game"] = "strawberryelephant",
    ["the first og in game"] = "strawberryelephant",
    ["the first og in the game"] = "strawberryelephant",
    ["the first snake"] = "hydraserpent",
    ["the first snake added"] = "hydraserpent",
    ["the first snake brainrot"] = "hydraserpent",
    ["the first snake brainrot added"] = "hydraserpent",
    ["the first snake brainrot ever added"] = "hydraserpent",
    ["the first snake brainrot in game"] = "hydraserpent",
    ["the first snake brainrot in sab"] = "hydraserpent",
    ["the first snake brainrot in the game"] = "hydraserpent",
    ["the first snake brainrot that was added"] = "hydraserpent",
    ["the first snake brainrot that was ever added"] = "hydraserpent",
    ["the first snake ever added"] = "hydraserpent",
    ["the first snake in game"] = "hydraserpent",
    ["the first snake in sab"] = "hydraserpent",
    ["the first snake in the game"] = "hydraserpent",
    ["the first snake that was added"] = "hydraserpent",
    ["the first snake that was ever added"] = "hydraserpent",
    ["the fourth 3 headed"] = "hydraserpent",
    ["the fourth 3 headed brainrot"] = "hydraserpent",
    ["the fourth og"] = "headlesshorseman",
    ["the fourth og brainrot"] = "headlesshorseman",
    ["the fourth three headed"] = "hydraserpent",
    ["the fourth three headed brainrot"] = "hydraserpent",
    ["the fourth three headed brainrot added"] = "hydraserpent",
    ["the hardest brainrot in game"] = "spyderelephant",
    ["the hardest brainrot in the game"] = "spyderelephant",
    ["the hardest brainrot to find"] = "spyderelephant",
    ["the hardest brainrot to get"] = "spyderelephant",
    ["the hardest brainrot to get in game"] = "spyderelephant",
    ["the hardest brainrot to get in the game"] = "spyderelephant",
    ["the hardest brainrot to obtain"] = "spyderelephant",
    ["the last craft machine"] = "cybercraft",
    ["the last craft machine in game"] = "cybercraft",
    ["the last craft machine in sab"] = "cybercraft",
    ["the last craft machine in the game"] = "cybercraft",
    ["the latest snake brainrot"] = "hydraserpent",
    ["the money ritual"] = "money",
    ["the most best brainrot added today"] = "lupaandlipa",
    ["the most best brainrot that was added today"] = "lupaandlipa",
    ["the most expensive item i have"] = "spyderchain",
    ["the most op brainrot"] = "lupaandlipa",
    ["the most op brainrot added"] = "orchidox",
    ["the most op brainrot added date"] = "august2026",
    ["the most op brainrot added day"] = "22",
    ["the most op brainrot added in todays admin abuse"] = "lupaandlipa",
    ["the most op brainrot added in todays update"] = "lupaandlipa",
    ["the most op brainrot added month"] = "august",
    ["the most op brainrot added recently"] = "orchidox",
    ["the most op brainrot added recently date"] = "august2026",
    ["the most op brainrot added recently day"] = "22",
    ["the most op brainrot added recently month"] = "august",
    ["the most op brainrot added recently release"] = "august2026",
    ["the most op brainrot added recently release date"] = "august2026",
    ["the most op brainrot added recently release day"] = "22",
    ["the most op brainrot added recently release month"] = "august",
    ["the most op brainrot added recently release year"] = "2026",
    ["the most op brainrot added recently year"] = "2026",
    ["the most op brainrot added release"] = "august2026",
    ["the most op brainrot added release date"] = "august2026",
    ["the most op brainrot added release day"] = "22",
    ["the most op brainrot added release month"] = "august",
    ["the most op brainrot added release year"] = "2026",
    ["the most op brainrot added today"] = "lupaandlipa",
    ["the most op brainrot added year"] = "2026",
    ["the most op brainrot date"] = "august2026",
    ["the most op brainrot day"] = "22",
    ["the most op brainrot from bee lucky block"] = "orchidox",
    ["the most op brainrot from the bee lucky block"] = "orchidox",
    ["the most op brainrot in bee lucky block"] = "orchidox",
    ["the most op brainrot in the bee lucky block"] = "orchidox",
    ["the most op brainrot in todays admin abuse"] = "lupaandlipa",
    ["the most op brainrot in todays update"] = "lupaandlipa",
    ["the most op brainrot month"] = "august",
    ["the most op brainrot recently"] = "orchidox",
    ["the most op brainrot recently date"] = "august2026",
    ["the most op brainrot recently day"] = "22",
    ["the most op brainrot recently month"] = "august",
    ["the most op brainrot recently release"] = "august2026",
    ["the most op brainrot recently release date"] = "august2026",
    ["the most op brainrot recently release day"] = "22",
    ["the most op brainrot recently release month"] = "august",
    ["the most op brainrot recently release year"] = "2026",
    ["the most op brainrot recently year"] = "2026",
    ["the most op brainrot release"] = "august2026",
    ["the most op brainrot release date"] = "august2026",
    ["the most op brainrot release day"] = "22",
    ["the most op brainrot release month"] = "august",
    ["the most op brainrot release year"] = "2026",
    ["the most op brainrot released"] = "orchidox",
    ["the most op brainrot released recently"] = "orchidox",
    ["the most op brainrot released recently date"] = "august2026",
    ["the most op brainrot released recently day"] = "22",
    ["the most op brainrot released recently month"] = "august",
    ["the most op brainrot released recently release"] = "august2026",
    ["the most op brainrot released recently release date"] = "august2026",
    ["the most op brainrot released recently release day"] = "22",
    ["the most op brainrot released recently release month"] = "august",
    ["the most op brainrot released recently release year"] = "2026",
    ["the most op brainrot released recently year"] = "2026",
    ["the most op brainrot that was added"] = "orchidox",
    ["the most op brainrot that was added date"] = "august2026",
    ["the most op brainrot that was added day"] = "22",
    ["the most op brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["the most op brainrot that was added in todays update"] = "lupaandlipa",
    ["the most op brainrot that was added month"] = "august",
    ["the most op brainrot that was added recently"] = "orchidox",
    ["the most op brainrot that was added recently date"] = "august2026",
    ["the most op brainrot that was added recently day"] = "22",
    ["the most op brainrot that was added recently month"] = "august",
    ["the most op brainrot that was added recently release"] = "august2026",
    ["the most op brainrot that was added recently release date"] = "august2026",
    ["the most op brainrot that was added recently release day"] = "22",
    ["the most op brainrot that was added recently release month"] = "august",
    ["the most op brainrot that was added recently release year"] = "2026",
    ["the most op brainrot that was added recently year"] = "2026",
    ["the most op brainrot that was added release"] = "august2026",
    ["the most op brainrot that was added release date"] = "august2026",
    ["the most op brainrot that was added release day"] = "22",
    ["the most op brainrot that was added release month"] = "august",
    ["the most op brainrot that was added release year"] = "2026",
    ["the most op brainrot that was added today"] = "lupaandlipa",
    ["the most op brainrot that was added year"] = "2026",
    ["the most op brainrot that was released"] = "orchidox",
    ["the most op brainrot that was released recently"] = "orchidox",
    ["the most op brainrot that was released recently date"] = "august2026",
    ["the most op brainrot that was released recently day"] = "22",
    ["the most op brainrot that was released recently month"] = "august",
    ["the most op brainrot that was released recently release"] = "august2026",
    ["the most op brainrot that was released recently release date"] = "august2026",
    ["the most op brainrot that was released recently release day"] = "22",
    ["the most op brainrot that was released recently release month"] = "august",
    ["the most op brainrot that was released recently release year"] = "2026",
    ["the most op brainrot that was released recently year"] = "2026",
    ["the most op brainrot year"] = "2026",
    ["the mythical creature brainrot"] = "hydraserpent",
    ["the name of the new base"] = "emperor",
    ["the name of the new base skin"] = "1of1",
    ["the new 3 headed brainrot"] = "hydraserpent",
    ["the new base"] = "emperor",
    ["the new base skin"] = "1of1",
    ["the new base skin added today"] = "1of1",
    ["the new base skin in today admin abuse"] = "1of1",
    ["the new base skin in today update"] = "1of1",
    ["the new base skin in todays admin abuse"] = "1of1",
    ["the new base skin in todays update"] = "1of1",
    ["the new base skin released today"] = "1of1",
    ["the new base skin that was released today"] = "1of1",
    ["the new mythical creature brainrot"] = "hydraserpent",
    ["the new rarest base skin"] = "1of1",
    ["the new ritual added today"] = "money",
    ["the new ritual in today admin abuse"] = "money",
    ["the new ritual in today update"] = "money",
    ["the new ritual in todays admin abuse"] = "money",
    ["the new ritual in todays update"] = "money",
    ["the new snake"] = "hydraserpent",
    ["the new snake brainrot"] = "hydraserpent",
    ["the new snake brainrot his name"] = "hydraserpent",
    ["the new snake brainrot name"] = "hydraserpent",
    ["the new snake brainrots name"] = "hydraserpent",
    ["the new three headed brainrot"] = "hydraserpent",
    ["the newest snake brainrot"] = "hydraserpent",
    ["the op base skin in todays admin abuse"] = "1of1",
    ["the op base skin in todays update"] = "1of1",
    ["the op base skin released today"] = "1of1",
    ["the op base skin that was released today"] = "1of1",
    ["the op brainrot"] = "lupaandlipa",
    ["the op brainrot added"] = "lupaandlipa",
    ["the op brainrot added date"] = "august2026",
    ["the op brainrot added day"] = "22",
    ["the op brainrot added month"] = "august",
    ["the op brainrot added recently"] = "lupaandlipa",
    ["the op brainrot added recently date"] = "august2026",
    ["the op brainrot added recently day"] = "22",
    ["the op brainrot added recently month"] = "august",
    ["the op brainrot added recently release"] = "august2026",
    ["the op brainrot added recently release date"] = "august2026",
    ["the op brainrot added recently release day"] = "22",
    ["the op brainrot added recently release month"] = "august",
    ["the op brainrot added recently release year"] = "2026",
    ["the op brainrot added recently year"] = "2026",
    ["the op brainrot added release"] = "august2026",
    ["the op brainrot added release date"] = "august2026",
    ["the op brainrot added release day"] = "22",
    ["the op brainrot added release month"] = "august",
    ["the op brainrot added release year"] = "2026",
    ["the op brainrot added today"] = "lupaandlipa",
    ["the op brainrot added year"] = "2026",
    ["the op brainrot date"] = "august2026",
    ["the op brainrot day"] = "22",
    ["the op brainrot month"] = "august",
    ["the op brainrot recently"] = "lupaandlipa",
    ["the op brainrot recently added"] = "lupaandlipa",
    ["the op brainrot recently released"] = "lupaandlipa",
    ["the op brainrot release"] = "august2026",
    ["the op brainrot release date"] = "august2026",
    ["the op brainrot release day"] = "22",
    ["the op brainrot release month"] = "august",
    ["the op brainrot release year"] = "2026",
    ["the op brainrot released recently"] = "lupaandlipa",
    ["the op brainrot that was added"] = "lupaandlipa",
    ["the op brainrot that was added date"] = "august2026",
    ["the op brainrot that was added day"] = "22",
    ["the op brainrot that was added month"] = "august",
    ["the op brainrot that was added recently"] = "lupaandlipa",
    ["the op brainrot that was added recently date"] = "august2026",
    ["the op brainrot that was added recently day"] = "22",
    ["the op brainrot that was added recently month"] = "august",
    ["the op brainrot that was added recently release"] = "august2026",
    ["the op brainrot that was added recently release date"] = "august2026",
    ["the op brainrot that was added recently release day"] = "22",
    ["the op brainrot that was added recently release month"] = "august",
    ["the op brainrot that was added recently release year"] = "2026",
    ["the op brainrot that was added recently year"] = "2026",
    ["the op brainrot that was added release"] = "august2026",
    ["the op brainrot that was added release date"] = "august2026",
    ["the op brainrot that was added release day"] = "22",
    ["the op brainrot that was added release month"] = "august",
    ["the op brainrot that was added release year"] = "2026",
    ["the op brainrot that was added today"] = "lupaandlipa",
    ["the op brainrot that was added year"] = "2026",
    ["the op brainrot that was recently added"] = "lupaandlipa",
    ["the op brainrot that was recently released"] = "lupaandlipa",
    ["the op brainrot that was released recently"] = "lupaandlipa",
    ["the op brainrot year"] = "2026",
    ["the rarest base skin"] = "1of1",
    ["the rarest base skin in the game"] = "1of1",
    ["the rarest brainrot"] = "spyderelephant",
    ["the rarest brainrot in game"] = "spyderelephant",
    ["the rarest brainrot in the game"] = "spyderelephant",
    ["the season we are currently in"] = "autumn",
    ["the season we are currently in is"] = "autumn",
    ["the season we are in"] = "autumn",
    ["the season we are suffering"] = "autumn",
    ["the season we are suffering is"] = "autumn",
    ["the second best brainrot"] = "strawberryelephant",
    ["the second best brainrot in game"] = "strawberryelephant",
    ["the second best brainrot in the game"] = "strawberryelephant",
    ["the second og"] = "meowl",
    ["the second og brainrot"] = "meowl",
    ["the sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["the sixth brainrot based off of a mythical creature"] = "hydraserpent",
    ["the sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["the sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["the sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["the sixth mythical brainrot"] = "hydraserpent",
    ["the sixth mythical creature"] = "hydraserpent",
    ["the sixth mythical creature brainrot"] = "hydraserpent",
    ["the sixth og"] = "spyderelephant",
    ["the sixth og brainrot"] = "spyderelephant",
    ["the snake brainrot"] = "hydraserpent",
    ["the snake brainrot his name"] = "hydraserpent",
    ["the snake brainrot name"] = "hydraserpent",
    ["the snake brainrots name"] = "hydraserpent",
    ["the third og"] = "skibiditoilet",
    ["the third og brainrot"] = "skibiditoilet",
    ["the three headed brainrot"] = "hydraserpent",
    ["the three headed snake brainrot"] = "hydraserpent",
    ["the worst person"] = "secretlokii",
    ["third best taco merchant"] = "tacoturbotacorito",
    ["third brainrot that was reworked"] = "gattatinonyanino",
    ["third fuse"] = "santafuse",
    ["third fuse date"] = "december2025",
    ["third fuse day"] = "6",
    ["third fuse machine"] = "santafuse",
    ["third fuse machine date"] = "december2025",
    ["third fuse machine day"] = "6",
    ["third fuse machine month"] = "december",
    ["third fuse machine release"] = "december2025",
    ["third fuse machine release date"] = "december2025",
    ["third fuse machine release day"] = "6",
    ["third fuse machine release month"] = "december",
    ["third fuse machine release year"] = "2025",
    ["third fuse machine year"] = "2025",
    ["third fuse month"] = "december",
    ["third fuse release"] = "december2025",
    ["third fuse release date"] = "december2025",
    ["third fuse release day"] = "6",
    ["third fuse release month"] = "december",
    ["third fuse release year"] = "2025",
    ["third fuse year"] = "2025",
    ["third og"] = "skibiditoilet",
    ["third og brainrot"] = "skibiditoilet",
    ["third reworked brainrot"] = "gattatinonyanino",
    ["third taco merchant"] = "tacoturbotacorito",
    ["three brainrots rework"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three brainrots reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["three headed"] = "hydraserpent",
    ["three headed brainrot"] = "hydraserpent",
    ["three headed brainrot added in todays update"] = "hydraserpent",
    ["three headed brainrot added today"] = "hydraserpent",
    ["three headed snake"] = "hydraserpent",
    ["three headed snake brainrot"] = "hydraserpent",
    ["three reworked brainrots"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["tie"] = "tie",
    ["tipi tacos"] = "lostipitacos",
    ["tipi topi"] = "tipitopitaco",
    ["tipi topi taco"] = "tipitopitaco",
    ["tipitopitaco"] = "tipitopitaco",
    ["today admin abuse"] = "hydraserpent",
    ["today admin abuse brainrot"] = "hydraserpent",
    ["today brainrot"] = "hydraserpent",
    ["today ritual"] = "money",
    ["today update"] = "hydraserpent",
    ["today update brainrot"] = "hydraserpent",
    ["todays admin abuse"] = "hydraserpent",
    ["todays admin abuse brainrot"] = "lupaandlipa",
    ["todays brainrot"] = "hydraserpent",
    ["todays ritual"] = "money",
    ["todays update"] = "hydraserpent",
    ["todays update brainrot"] = "hydraserpent",
    ["toilet"] = "skibiditoilet",
    ["toilet color"] = "white",
    ["tombstone trait"] = "riptombstone",
    ["tombstone trait date"] = "october2025",
    ["tombstone trait month"] = "october",
    ["tombstone trait release"] = "october2025",
    ["tombstone trait release date"] = "october2025",
    ["tombstone trait release month"] = "october",
    ["tombstone trait release year"] = "2025",
    ["tombstone trait year"] = "2025",
    ["top brainrot in game"] = "spyderelephant",
    ["top brainrot in the game"] = "spyderelephant",
    ["top mutation"] = "crystal",
    ["top taco merchant"] = "sammynitruckini",
    ["torrtuginni"] = "torrtuginnidragonfrutini",
    ["torrtuginni dragonfrutini"] = "torrtuginnidragonfrutini",
    ["torrtuginnidragonfrutini"] = "torrtuginnidragonfrutini",
    ["tortinii"] = "bombardinitortinii",
    ["total 1 of 1 brainrots"] = "155",
    ["total 1 of 1 brainrots exist"] = "155",
    ["total 1 of 1s"] = "155",
    ["total 1 of 1s exist"] = "155",
    ["total exist count of strawberry elephant"] = "2348",
    ["total exist count of strawberry elephants"] = "2348",
    ["trade machine"] = "february2026",
    ["trade machine date"] = "february2026",
    ["trade machine day"] = "21",
    ["trade machine month"] = "february",
    ["trade machine release"] = "february2026",
    ["trade machine release date"] = "february2026",
    ["trade machine release day"] = "21",
    ["trade machine release month"] = "february",
    ["trade machine release year"] = "2026",
    ["trade machine year"] = "2026",
    ["trade plaza"] = "june2026",
    ["trade plaza date"] = "june2026",
    ["trade plaza day"] = "13",
    ["trade plaza month"] = "june",
    ["trade plaza release"] = "june2026",
    ["trade plaza release date"] = "june2026",
    ["trade plaza release day"] = "13",
    ["trade plaza release month"] = "june",
    ["trade plaza release year"] = "2026",
    ["trade plaza year"] = "2026",
    ["trading machine"] = "june2026",
    ["trading machine date"] = "june2026",
    ["trading machine day"] = "11",
    ["trading machine month"] = "june",
    ["trading machine release"] = "june2026",
    ["trading machine release date"] = "june2026",
    ["trading machine release day"] = "11",
    ["trading machine release month"] = "june",
    ["trading machine release year"] = "2026",
    ["trading machine year"] = "2026",
    ["trait admin abuse"] = "sleepy",
    ["trait from admin abuse war"] = "sleepy",
    ["trait from money ritual"] = "rainingmoney",
    ["trait from new ritual"] = "rainingmoney",
    ["trait from the admin abuse war"] = "sleepy",
    ["trait from the money ritual"] = "rainingmoney",
    ["trait in admin abuse war"] = "sleepy",
    ["trait in money ritual"] = "rainingmoney",
    ["trait in the admin abuse war"] = "sleepy",
    ["trait incubator"] = "april2026",
    ["trait incubator date"] = "april2026",
    ["trait incubator day"] = "4",
    ["trait incubator month"] = "april",
    ["trait incubator release"] = "april2026",
    ["trait incubator release date"] = "april2026",
    ["trait incubator release day"] = "4",
    ["trait incubator release month"] = "april",
    ["trait incubator release year"] = "2026",
    ["trait incubator year"] = "2026",
    ["trait money"] = "rainingmoney",
    ["trait obtainable in admin abuse"] = "sleepy",
    ["trait obtainable in admin abuse war"] = "sleepy",
    ["trait obtainable in the admin abuse war"] = "sleepy",
    ["trait puggy"] = "rainingmoney",
    ["tralalero"] = "tralalero",
    ["tralalerotralala"] = "tralalerotralala",
    ["tung sahur"] = "tungtungtungsahur",
    ["tung sahur crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung sahur crocodilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung"] = "tungtung",
    ["tung tung attack"] = "tungtung",
    ["tung tung attack date"] = "june2025",
    ["tung tung attack month"] = "june",
    ["tung tung attack release"] = "june2025",
    ["tung tung attack release date"] = "june2025",
    ["tung tung attack release month"] = "june",
    ["tung tung attack release year"] = "2025",
    ["tung tung attack year"] = "2025",
    ["tung tung date"] = "june2025",
    ["tung tung month"] = "june",
    ["tung tung release"] = "june2025",
    ["tung tung release date"] = "june2025",
    ["tung tung release month"] = "june",
    ["tung tung release year"] = "2025",
    ["tung tung sahur"] = "tungtungtungsahur",
    ["tung tung sahur crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung sahur crocodilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung trait"] = "tungtung",
    ["tung tung trait date"] = "june2025",
    ["tung tung trait month"] = "june",
    ["tung tung trait release"] = "june2025",
    ["tung tung trait release date"] = "june2025",
    ["tung tung trait release month"] = "june",
    ["tung tung trait release year"] = "2025",
    ["tung tung trait year"] = "2025",
    ["tung tung tung sahur"] = "tungtungtungsahur",
    ["tung tung tung sahur and crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung tung sahur crocidilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung tung sahur crocodilo penisini"] = "tungtungtungsahurcrocidilopenisini",
    ["tung tung year"] = "2025",
    ["tung tung zombie"] = "tungtung",
    ["tung tung zombie date"] = "june2025",
    ["tung tung zombie month"] = "june",
    ["tung tung zombie release"] = "june2025",
    ["tung tung zombie release date"] = "june2025",
    ["tung tung zombie release month"] = "june",
    ["tung tung zombie release year"] = "2025",
    ["tung tung zombie year"] = "2025",
    ["tungtung"] = "tungtung",
    ["tungtungattack"] = "tungtungattack",
    ["tungtungtungsahur"] = "tungtungtungsahur",
    ["tungtungtungsahurcrocidilopenisini"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots remove"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots removed"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["two brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["two deleted brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["two removed brainrots"] = "tungtungtungsahurcrocidilopenisini",
    ["ufo"] = "ufo",
    ["unclito samito"] = "unclitosamito",
    ["unclitosamito"] = "unclitosamito",
    ["united states"] = "usa",
    ["upcoming fuse machine"] = "hauntedfuse",
    ["upcoming Strawberry fuse"] = "hauntedfuse",
    ["usa"] = "usa",
    ["valentine fuse"] = "february2026",
    ["valentine fuse date"] = "february2026",
    ["valentine fuse day"] = "14",
    ["valentine fuse month"] = "february",
    ["valentine fuse release"] = "february2026",
    ["valentine fuse release date"] = "february2026",
    ["valentine fuse release day"] = "14",
    ["valentine fuse release month"] = "february",
    ["valentine fuse release year"] = "2026",
    ["valentine fuse year"] = "2026",
    ["valentine machine"] = "february2026",
    ["valentine machine date"] = "february2026",
    ["valentine machine day"] = "14",
    ["valentine machine month"] = "february",
    ["valentine machine release"] = "february2026",
    ["valentine machine release date"] = "february2026",
    ["valentine machine release day"] = "14",
    ["valentine machine release month"] = "february",
    ["valentine machine release year"] = "2026",
    ["valentine machine year"] = "2026",
    ["valentine trait"] = "chocolate",
    ["valentine trait date"] = "february2026",
    ["valentine trait month"] = "february",
    ["valentine trait release"] = "february2026",
    ["valentine trait release date"] = "february2026",
    ["valentine trait release month"] = "february",
    ["valentine trait release year"] = "2026",
    ["valentine trait year"] = "2026",
    ["valentines machine"] = "february2026",
    ["valentines machine date"] = "february2026",
    ["valentines machine day"] = "14",
    ["valentines machine month"] = "february",
    ["valentines machine release"] = "february2026",
    ["valentines machine release date"] = "february2026",
    ["valentines machine release day"] = "14",
    ["valentines machine release month"] = "february",
    ["valentines machine release year"] = "2026",
    ["valentines machine year"] = "2026",
    ["valorant"] = "valorant",
    ["valorant player"] = "valorant",
    ["visits"] = "72billion",
    ["visual meowl"] = "cyber",
    ["visual mutation"] = "cyber",
    ["visually best mutation for meowl"] = "cyber",
    ["visually best mutation for meowl date"] = "april2026",
    ["visually best mutation for meowl day"] = "18",
    ["visually best mutation for meowl month"] = "april",
    ["visually best mutation for meowl release"] = "april2026",
    ["visually best mutation for meowl release date"] = "april2026",
    ["visually best mutation for meowl release day"] = "18",
    ["visually best mutation for meowl release month"] = "april",
    ["visually best mutation for meowl release year"] = "2026",
    ["visually best mutation for meowl year"] = "2026",
    ["visually best mutation on meowl"] = "cyber",
    ["visually best mutation on meowl date"] = "april2026",
    ["visually best mutation on meowl day"] = "18",
    ["visually best mutation on meowl month"] = "april",
    ["visually best mutation on meowl release"] = "april2026",
    ["visually best mutation on meowl release date"] = "april2026",
    ["visually best mutation on meowl release day"] = "18",
    ["visually best mutation on meowl release month"] = "april",
    ["visually best mutation on meowl release year"] = "2026",
    ["visually best mutation on meowl year"] = "2026",
    ["visually meowl"] = "cyber",
    ["weigh"] = "250",
    ["weight"] = "250",
    ["what 2 brainrots got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["what 2 brainrots got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what 2 brainrots were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what 3 brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what 3 brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are 2 brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are 2 brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are 3 brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are 3 brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are the 2 brainrots that got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are the 2 brainrots that were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what are the 3 brainrots that got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are the 3 brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are the three brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what are three brainrots that were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what brainrot can you get from cave island"] = "draculino",
    ["what brainrot can you get from the cave island"] = "draculino",
    ["what brainrot can you obtain from cave island"] = "draculino",
    ["what brainrot can you obtain from the cave island"] = "draculino",
    ["what brainrot do you get from money ritual"] = "lospuggies",
    ["what brainrot do you get from new ritual"] = "lospuggies",
    ["what brainrot do you get from the money ritual"] = "lospuggies",
    ["what brainrot do you get from the new ritual"] = "lospuggies",
    ["what brainrot do you need for money ritual"] = "moneymoneypuggy",
    ["what brainrot do you need for new ritual"] = "moneymoneypuggy",
    ["what brainrot do you need for the new ritual"] = "moneymoneypuggy",
    ["what brainrot do you need to use for money ritual"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in today admin abuse"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in today update"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in todays admin abuse"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual in todays update"] = "moneymoneypuggy",
    ["what brainrot do you need to use for new ritual that was added today"] = "moneymoneypuggy",
    ["what brainrot do you need to use for the new ritual"] = "moneymoneypuggy",
    ["what brainrot does money ritual give"] = "lospuggies",
    ["what brainrot does new ritual give"] = "lospuggies",
    ["what brainrot does the money ritual give"] = "lospuggies",
    ["what brainrot does the new ritual give"] = "lospuggies",
    ["what brainrot got added last saturday"] = "orchidox",
    ["what brainrot got added last week"] = "orchidox",
    ["what brainrot got added today"] = "hydraserpent",
    ["what brainrot got deleted"] = "tungtungtungsahur",
    ["what brainrot got released last saturday"] = "orchidox",
    ["what brainrot got released last week"] = "orchidox",
    ["what brainrot got remove"] = "tungtungtungsahur",
    ["what brainrot got removed"] = "tungtungtungsahur",
    ["what brainrot got reworked"] = "sammynispyderini",
    ["what brainrot makes money ritual"] = "moneymoneypuggy",
    ["what brainrot makes new ritual"] = "moneymoneypuggy",
    ["what brainrot makes the money ritual"] = "moneymoneypuggy",
    ["what brainrot to use for money ritual"] = "moneymoneypuggy",
    ["what brainrot to use for new ritual"] = "moneymoneypuggy",
    ["what brainrot to use for the new ritual"] = "moneymoneypuggy",
    ["what brainrot was added in todays admin abuse"] = "lupaandlipa",
    ["what brainrot was added in todays update"] = "hydraserpent",
    ["what brainrot was added last saturday"] = "orchidox",
    ["what brainrot was added last week"] = "orchidox",
    ["what brainrot was added today"] = "hydraserpent",
    ["what brainrot was deleted"] = "tungtungtungsahur",
    ["what brainrot was released last saturday"] = "orchidox",
    ["what brainrot was released last week"] = "orchidox",
    ["what brainrot was removed"] = "tungtungtungsahur",
    ["what brainrot was reworked"] = "sammynispyderini",
    ["what brainrot you get from money ritual"] = "lospuggies",
    ["what brainrot you get from new ritual"] = "lospuggies",
    ["what brainrot you need for new ritual"] = "moneymoneypuggy",
    ["what brainrot you need to use for money ritual"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in today admin abuse"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in today update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in todays admin abuse"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual in todays update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual that was added in today update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual that was added in todays update"] = "moneymoneypuggy",
    ["what brainrot you need to use for new ritual that was added today"] = "moneymoneypuggy",
    ["what brainrots got deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what brainrots were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["what brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["what color are my pants"] = "red",
    ["what color are my shirt"] = "red",
    ["what color is draculino"] = "black",
    ["what color is his roblox avatar"] = "red",
    ["what color is his roblox skin"] = "yellow",
    ["what color is my avatar"] = "red",
    ["what color is my body skin"] = "yellow",
    ["what color is my car"] = "red",
    ["what color is my hair"] = "black",
    ["what color is my roblox avatar"] = "red",
    ["what color is my roblox skin"] = "yellow",
    ["what color is my shirt"] = "red",
    ["what color is new best brainrot in ltm"] = "black",
    ["what color is new brainrot"] = "black",
    ["what color is sammy avatar"] = "red",
    ["what color is sammy roblox avatar"] = "red",
    ["what color is sammy roblox skin"] = "yellow",
    ["what color is the new best brainrot in ltm"] = "black",
    ["what color is the new brainrot"] = "black",
    ["what colour is my hair"] = "black",
    ["what day was bee lucky block released"] = "22",
    ["what day was headless horseman released"] = "1",
    ["what day was john pork released"] = "1",
    ["what day was meowl released"] = "1",
    ["what day was orchidox released"] = "22",
    ["what day was skibidi toilet released"] = "1",
    ["what day was spyder elephant released"] = "1",
    ["what day was strawberry elephant released"] = "1",
    ["what egg can you get dragon cannelloni from"] = "dragonegg",
    ["what egg can you obtain dragon cannelloni from"] = "dragonegg",
    ["what egg contains dragon cannelloni"] = "dragonegg",
    ["what egg do you get dragon cannelloni from"] = "dragonegg",
    ["what egg does dragon cannelloni come from"] = "dragonegg",
    ["what egg does dragon cannelloni hatch from"] = "dragonegg",
    ["what egg is dragon cannelloni from"] = "dragonegg",
    ["what egg you can obtain dragon cannelloni from"] = "dragonegg",
    ["what event does money ritual give"] = "moneymoneypuggy",
    ["what event does new ritual give"] = "moneymoneypuggy",
    ["what event does the money ritual give"] = "moneymoneypuggy",
    ["what event does the new ritual give"] = "moneymoneypuggy",
    ["what fuse machine is coming next"] = "hauntedfuse",
    ["what game am i a competitive player at"] = "valorant",
    ["what game am i competitive at"] = "valorant",
    ["what game am i competitive in"] = "valorant",
    ["what game am i competitive player at"] = "valorant",
    ["what game do i enjoy playing"] = "fortnite",
    ["what game do i hate"] = "growagarden",
    ["what game do i hate most"] = "growagarden",
    ["what game do i hate the most"] = "growagarden",
    ["what game do i like to play"] = "fortnite",
    ["what game do i love"] = "fortnite",
    ["what game do i love to play"] = "fortnite",
    ["what game do i play competitive"] = "valorant",
    ["what game do i play competitively"] = "valorant",
    ["what game does sammy enjoy playing"] = "fortnite",
    ["what game does sammy hate"] = "growagarden",
    ["what game does sammy hate most"] = "growagarden",
    ["what game does sammy hate the most"] = "growagarden",
    ["what game does sammy like to play"] = "fortnite",
    ["what game does sammy love"] = "fortnite",
    ["what game does sammy love to play"] = "fortnite",
    ["what game does sammy play competitive"] = "valorant",
    ["what game does sammy play competitively"] = "valorant",
    ["what game i am competitive at"] = "valorant",
    ["what game i am competitive player at"] = "valorant",
    ["what game i enjoy playing"] = "fortnite",
    ["what game i hate"] = "growagarden",
    ["what game i hate most"] = "growagarden",
    ["what game i hate the most"] = "growagarden",
    ["what game i like to play"] = "fortnite",
    ["what game i love"] = "fortnite",
    ["what game i love to play"] = "fortnite",
    ["what game i play competitive"] = "valorant",
    ["what game i play competitively"] = "valorant",
    ["what game is better than 1 speed keyboard escape"] = "growagarden",
    ["what game is better than 1speedkeyboardescape"] = "growagarden",
    ["what game is sammy a competitive player at"] = "valorant",
    ["what game is sammy competitive at"] = "valorant",
    ["what game is sammy competitive player at"] = "valorant",
    ["what game is worse than grow a garden"] = "1speedkeyboardescape",
    ["what game is worse than growagarden"] = "1speedkeyboardescape",
    ["what game is worser than grow a garden"] = "1speedkeyboardescape",
    ["what game is worser than growagarden"] = "1speedkeyboardescape",
    ["what game sammy hates"] = "growagarden",
    ["what game sammy hates most"] = "growagarden",
    ["what game sammy hates the most"] = "growagarden",
    ["what game sammy likes to play"] = "fortnite",
    ["what game sammy loves"] = "fortnite",
    ["what game sammy loves to play"] = "fortnite",
    ["what group do i hate"] = "secretverse",
    ["what group do i hate most"] = "secretverse",
    ["what group do i hate the most"] = "secretverse",
    ["what group does sammy hate"] = "secretverse",
    ["what group does sammy hate most"] = "secretverse",
    ["what group does sammy hate the most"] = "secretverse",
    ["what is 2nd name of sammy"] = "brakta",
    ["what is coming for Strawberry"] = "hauntedfuse",
    ["what is coming in Strawberry"] = "hauntedfuse",
    ["what is his roblox avatar color"] = "red",
    ["what is his roblox skin color"] = "yellow",
    ["what is my 2nd name"] = "brakta",
    ["what is my body skin color"] = "yellow",
    ["what is my cat called"] = "nova",
    ["what is my cat name"] = "nova",
    ["what is my cats name"] = "nova",
    ["what is my dog called"] = "rocky",
    ["what is my dog name"] = "rocky",
    ["what is my dogs name"] = "rocky",
    ["what is my favorite game"] = "fortnite",
    ["what is my favorite mutation"] = "galaxy",
    ["what is my favorite number"] = "67",
    ["what is my favorite visual mutation for meowl"] = "cyber",
    ["what is my favourite game"] = "fortnite",
    ["what is my favourite mutation"] = "galaxy",
    ["what is my favourite number"] = "67",
    ["what is my favourite visual mutation for meowl"] = "cyber",
    ["what is my hair color"] = "black",
    ["what is my hair colour"] = "black",
    ["what is my last name"] = "brakta",
    ["what is my least favorite game"] = "growagarden",
    ["what is my least favorite group"] = "secretverse",
    ["what is my least favorite studio"] = "secretverse",
    ["what is my least favourite game"] = "growagarden",
    ["what is my least favourite group"] = "secretverse",
    ["what is my least favourite studio"] = "secretverse",
    ["what is my middle name"] = "brakta",
    ["what is my pet name"] = "rocky",
    ["what is my roblox avatar color"] = "red",
    ["what is my roblox skin color"] = "yellow",
    ["what is my second name"] = "brakta",
    ["what is my surname"] = "brakta",
    ["what is next fuse machine"] = "hauntedfuse",
    ["what is sammy 2nd name"] = "brakta",
    ["what is sammy cat name"] = "nova",
    ["what is sammy dog name"] = "rocky",
    ["what is sammy favorite game"] = "fortnite",
    ["what is sammy favorite mutation"] = "galaxy",
    ["what is sammy favorite number"] = "67",
    ["what is sammy favourite game"] = "fortnite",
    ["what is sammy favourite mutation"] = "galaxy",
    ["what is sammy favourite number"] = "67",
    ["what is sammy least favorite game"] = "growagarden",
    ["what is sammy least favorite group"] = "secretverse",
    ["what is sammy least favorite studio"] = "secretverse",
    ["what is sammy least favourite game"] = "growagarden",
    ["what is sammy least favourite group"] = "secretverse",
    ["what is sammy least favourite studio"] = "secretverse",
    ["what is sammy pet name"] = "rocky",
    ["what is sammy roblox avatar color"] = "red",
    ["what is sammy roblox skin color"] = "yellow",
    ["what is sammy second name"] = "brakta",
    ["what is sammys 2nd name"] = "brakta",
    ["what is sammys cat called"] = "nova",
    ["what is sammys cat name"] = "nova",
    ["what is sammys cats name"] = "nova",
    ["what is sammys dog called"] = "rocky",
    ["what is sammys dog name"] = "rocky",
    ["what is sammys dogs name"] = "rocky",
    ["what is sammys favorite game"] = "fortnite",
    ["what is sammys favorite mutation"] = "galaxy",
    ["what is sammys favorite number"] = "67",
    ["what is sammys favourite game"] = "fortnite",
    ["what is sammys favourite mutation"] = "galaxy",
    ["what is sammys favourite number"] = "67",
    ["what is sammys least favorite game"] = "growagarden",
    ["what is sammys least favorite group"] = "secretverse",
    ["what is sammys least favorite studio"] = "secretverse",
    ["what is sammys least favourite game"] = "growagarden",
    ["what is sammys least favourite group"] = "secretverse",
    ["what is sammys least favourite studio"] = "secretverse",
    ["what is sammys pet name"] = "rocky",
    ["what is sammys second name"] = "brakta",
    ["what is second name of sammy"] = "brakta",
    ["what is the 1st bee"] = "beeloco",
    ["what is the 1st bee brainrot"] = "beeloco",
    ["what is the 1st bee brainrot in game"] = "beeloco",
    ["what is the 1st bee brainrot in sab"] = "beeloco",
    ["what is the 1st bee brainrot in the game"] = "beeloco",
    ["what is the 1st bee in game"] = "beeloco",
    ["what is the 1st bee in sab"] = "beeloco",
    ["what is the 1st bee in the game"] = "beeloco",
    ["what is the 1st og"] = "strawberryelephant",
    ["what is the 1st og brainrot"] = "strawberryelephant",
    ["what is the 1st snake"] = "hydraserpent",
    ["what is the 1st snake brainrot"] = "hydraserpent",
    ["what is the 1st snake brainrot added"] = "hydraserpent",
    ["what is the 1st snake brainrot ever added"] = "hydraserpent",
    ["what is the 1st snake brainrot that was added"] = "hydraserpent",
    ["what is the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["what is the 2nd best brainrot"] = "strawberryelephant",
    ["what is the 2nd best brainrot in game"] = "strawberryelephant",
    ["what is the 2nd best brainrot in the game"] = "strawberryelephant",
    ["what is the 2nd og brainrot"] = "meowl",
    ["what is the 3 headed brainrot"] = "hydraserpent",
    ["what is the 3rd og brainrot"] = "skibiditoilet",
    ["what is the 4th 3 headed"] = "hydraserpent",
    ["what is the 4th 3 headed brainrot"] = "hydraserpent",
    ["what is the 4th og brainrot"] = "headlesshorseman",
    ["what is the 4th three headed"] = "hydraserpent",
    ["what is the 4th three headed brainrot"] = "hydraserpent",
    ["what is the 5th og brainrot"] = "johnpork",
    ["what is the 6th brainrot based off a mythical creature"] = "hydraserpent",
    ["what is the 6th brainrot based on a mythical creature"] = "hydraserpent",
    ["what is the 6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["what is the 6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["what is the 6th mythical brainrot"] = "hydraserpent",
    ["what is the 6th mythical creature"] = "hydraserpent",
    ["what is the 6th mythical creature brainrot"] = "hydraserpent",
    ["what is the 6th og brainrot"] = "spyderelephant",
    ["what is the best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["what is the best brainrot added in todays update"] = "lupaandlipa",
    ["what is the best brainrot added last saturday"] = "orchidox",
    ["what is the best brainrot added last week"] = "orchidox",
    ["what is the best brainrot added today"] = "lupaandlipa",
    ["what is the best brainrot except spyder elephant"] = "strawberryelephant",
    ["what is the best brainrot except spyderelephant"] = "strawberryelephant",
    ["what is the best brainrot from bee lucky block"] = "orchidox",
    ["what is the best brainrot from the bee lucky block"] = "orchidox",
    ["what is the best brainrot in bee lucky block"] = "orchidox",
    ["what is the best brainrot in the bee lucky block"] = "orchidox",
    ["what is the best brainrot released last saturday"] = "orchidox",
    ["what is the best brainrot released last week"] = "orchidox",
    ["what is the best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["what is the best brainrot that was added in todays update"] = "lupaandlipa",
    ["what is the best brainrot that was added last saturday"] = "orchidox",
    ["what is the best brainrot that was added last week"] = "orchidox",
    ["what is the best brainrot that was added today"] = "lupaandlipa",
    ["what is the best brainrot that was released last week"] = "orchidox",
    ["what is the best brainrot without spyder elephant"] = "strawberryelephant",
    ["what is the best brainrot without spyderelephant"] = "strawberryelephant",
    ["what is the best mutation"] = "crystal",
    ["what is the best mutation currently"] = "crystal",
    ["what is the best mutation for meowl visually"] = "cyber",
    ["what is the best mutation for my favorite brainrot visually"] = "cyber",
    ["what is the best mutation right now"] = "crystal",
    ["what is the best mutation rn"] = "crystal",
    ["what is the best visual mutation for meowl"] = "cyber",
    ["what is the cat name"] = "nova",
    ["what is the color of my roblox avatar"] = "red",
    ["what is the color of new best brainrot in ltm"] = "black",
    ["what is the color of the new best brainrot in ltm"] = "black",
    ["what is the dog name"] = "rocky",
    ["what is the fifth og brainrot"] = "johnpork",
    ["what is the first bee"] = "beeloco",
    ["what is the first bee brainrot"] = "beeloco",
    ["what is the first bee brainrot in game"] = "beeloco",
    ["what is the first bee brainrot in sab"] = "beeloco",
    ["what is the first bee brainrot in the game"] = "beeloco",
    ["what is the first bee in game"] = "beeloco",
    ["what is the first bee in sab"] = "beeloco",
    ["what is the first bee in the game"] = "beeloco",
    ["what is the first og"] = "strawberryelephant",
    ["what is the first og brainrot"] = "strawberryelephant",
    ["what is the first snake"] = "hydraserpent",
    ["what is the first snake brainrot"] = "hydraserpent",
    ["what is the first snake brainrot added"] = "hydraserpent",
    ["what is the first snake brainrot ever added"] = "hydraserpent",
    ["what is the first snake brainrot that was added"] = "hydraserpent",
    ["what is the first snake brainrot that was ever added"] = "hydraserpent",
    ["what is the flying bee gear"] = "flyingbee",
    ["what is the fourth 3 headed"] = "hydraserpent",
    ["what is the fourth 3 headed brainrot"] = "hydraserpent",
    ["what is the fourth og brainrot"] = "headlesshorseman",
    ["what is the fourth three headed"] = "hydraserpent",
    ["what is the fourth three headed brainrot"] = "hydraserpent",
    ["what is the latest snake brainrot"] = "hydraserpent",
    ["what is the money ritual"] = "money",
    ["what is the most op brainrot"] = "orchidox",
    ["what is the most op brainrot added"] = "orchidox",
    ["what is the most op brainrot added recently"] = "orchidox",
    ["what is the most op brainrot added today"] = "lupaandlipa",
    ["what is the most op brainrot from bee lucky block"] = "orchidox",
    ["what is the most op brainrot from the bee lucky block"] = "orchidox",
    ["what is the most op brainrot in bee lucky block"] = "orchidox",
    ["what is the most op brainrot in the bee lucky block"] = "orchidox",
    ["what is the most op brainrot recently"] = "orchidox",
    ["what is the most op brainrot released"] = "orchidox",
    ["what is the most op brainrot released recently"] = "orchidox",
    ["what is the most op brainrot that was added"] = "orchidox",
    ["what is the most op brainrot that was added recently"] = "orchidox",
    ["what is the most op brainrot that was added today"] = "lupaandlipa",
    ["what is the most op brainrot that was released"] = "orchidox",
    ["what is the most op brainrot that was released recently"] = "orchidox",
    ["what is the mythical creature brainrot"] = "hydraserpent",
    ["what is the name of my dog"] = "rocky",
    ["what is the name of sammy dog"] = "rocky",
    ["what is the name of sammys dog"] = "rocky",
    ["what is the new bee gear"] = "flyingbee",
    ["what is the new flying bee gear"] = "flyingbee",
    ["what is the new ritual added today"] = "money",
    ["what is the new ritual in today admin abuse"] = "money",
    ["what is the new ritual in today update"] = "money",
    ["what is the new ritual in todays admin abuse"] = "money",
    ["what is the new ritual in todays update"] = "money",
    ["what is the new snake"] = "hydraserpent",
    ["what is the new snake brainrot"] = "hydraserpent",
    ["what is the new snake brainrot his name"] = "hydraserpent",
    ["what is the new snake brainrot name"] = "hydraserpent",
    ["what is the new snake brainrots name"] = "hydraserpent",
    ["what is the newest snake brainrot"] = "hydraserpent",
    ["what is the next fuse machine"] = "hauntedfuse",
    ["what is the op brainrot that was added recently"] = "lupaandlipa",
    ["what is the op brainrot that was recently added"] = "lupaandlipa",
    ["what is the op brainrot that was recently released"] = "lupaandlipa",
    ["what is the op brainrot that was released recently"] = "lupaandlipa",
    ["what is the second best brainrot"] = "strawberryelephant",
    ["what is the second best brainrot in game"] = "strawberryelephant",
    ["what is the second best brainrot in the game"] = "strawberryelephant",
    ["what is the second og brainrot"] = "meowl",
    ["what is the sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["what is the sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["what is the sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["what is the sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["what is the sixth mythical brainrot"] = "hydraserpent",
    ["what is the sixth mythical creature"] = "hydraserpent",
    ["what is the sixth mythical creature brainrot"] = "hydraserpent",
    ["what is the sixth og brainrot"] = "spyderelephant",
    ["what is the snake brainrot"] = "hydraserpent",
    ["what is the snake brainrot his name"] = "hydraserpent",
    ["what is the snake brainrot name"] = "hydraserpent",
    ["what is the snake brainrots name"] = "hydraserpent",
    ["what is the third og brainrot"] = "skibiditoilet",
    ["what is the three headed brainrot"] = "hydraserpent",
    ["what island is draculino from"] = "caveisland",
    ["what material is spyder elephant"] = "silver",
    ["what month was bee lucky block released"] = "august",
    ["what month was headless horseman released"] = "february",
    ["what month was john pork released"] = "may",
    ["what month was meowl released"] = "october",
    ["what month was orchidox released"] = "august",
    ["what month was skibidi toilet released"] = "december",
    ["what month was spyder elephant released"] = "may",
    ["what month was strawberry elephant released"] = "august",
    ["what mutation do i like the most"] = "galaxy",
    ["what mutation do i love"] = "galaxy",
    ["what mutation does sammy like the most"] = "galaxy",
    ["what mutation does sammy love"] = "galaxy",
    ["what mutation looks best on meowl"] = "cyber",
    ["what mutation looks the best on meowl"] = "cyber",
    ["what number always"] = "67",
    ["what number always at code"] = "67",
    ["what number always at codes"] = "67",
    ["what number always in code"] = "67",
    ["what number always in codes"] = "67",
    ["what number always put at code"] = "67",
    ["what number always put at codes"] = "67",
    ["what number do i always put"] = "67",
    ["what number do i always put at all codes"] = "67",
    ["what number do i always put at code"] = "67",
    ["what number do i always put at codes"] = "67",
    ["what number do i always put in all codes"] = "67",
    ["what number do i always put in code"] = "67",
    ["what number do i always put in codes"] = "67",
    ["what number i always put"] = "67",
    ["what number i always put at all codes"] = "67",
    ["what number i always put at code"] = "67",
    ["what number i always put at codes"] = "67",
    ["what number i always put in all codes"] = "67",
    ["what number i always put in code"] = "67",
    ["what number i always put in codes"] = "67",
    ["what number is always at code"] = "67",
    ["what number is always at codes"] = "67",
    ["what number is always in code"] = "67",
    ["what number is always in codes"] = "67",
    ["what number is in all code"] = "67",
    ["what number is in all codes"] = "67",
    ["what season are we currently in"] = "autumn",
    ["what season are we in"] = "autumn",
    ["what season are we suffering"] = "autumn",
    ["what season is it"] = "autumn",
    ["what season we are suffering"] = "autumn",
    ["what studio do i hate"] = "secretverse",
    ["what studio do i hate most"] = "secretverse",
    ["what studio do i hate the most"] = "secretverse",
    ["what studio does sammy hate"] = "secretverse",
    ["what studio does sammy hate most"] = "secretverse",
    ["what studio does sammy hate the most"] = "secretverse",
    ["what trait does money ritual give"] = "rainingmoney",
    ["what trait does new ritual give"] = "rainingmoney",
    ["what trait does the money ritual give"] = "rainingmoney",
    ["what trait does the new ritual give"] = "rainingmoney",
    ["what was the 1st bee"] = "beeloco",
    ["what was the 1st bee brainrot"] = "beeloco",
    ["what was the 1st bee brainrot in game"] = "beeloco",
    ["what was the 1st bee brainrot in sab"] = "beeloco",
    ["what was the 1st bee brainrot in the game"] = "beeloco",
    ["what was the 1st bee in game"] = "beeloco",
    ["what was the 1st bee in the game"] = "beeloco",
    ["what was the 1st og"] = "strawberryelephant",
    ["what was the 1st og brainrot"] = "strawberryelephant",
    ["what was the 1st snake brainrot"] = "hydraserpent",
    ["what was the 1st snake brainrot added"] = "hydraserpent",
    ["what was the 1st snake brainrot ever added"] = "hydraserpent",
    ["what was the 1st snake brainrot that was added"] = "hydraserpent",
    ["what was the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["what was the 2nd og added"] = "meowl",
    ["what was the 2nd og added to sab"] = "meowl",
    ["what was the first bee"] = "beeloco",
    ["what was the first bee brainrot"] = "beeloco",
    ["what was the first bee brainrot in game"] = "beeloco",
    ["what was the first bee brainrot in sab"] = "beeloco",
    ["what was the first bee brainrot in the game"] = "beeloco",
    ["what was the first bee in game"] = "beeloco",
    ["what was the first bee in the game"] = "beeloco",
    ["what was the first og"] = "strawberryelephant",
    ["what was the first og brainrot"] = "strawberryelephant",
    ["what was the first snake brainrot"] = "hydraserpent",
    ["what was the first snake brainrot added"] = "hydraserpent",
    ["what was the first snake brainrot ever added"] = "hydraserpent",
    ["what was the first snake brainrot that was added"] = "hydraserpent",
    ["what was the first snake brainrot that was ever added"] = "hydraserpent",
    ["what was the fourth three headed brainrot"] = "hydraserpent",
    ["what was the second og added"] = "meowl",
    ["what was the second og added to sab"] = "meowl",
    ["what was the trait in admin abuse"] = "sleepy",
    ["what was the trait in admin abuse war"] = "sleepy",
    ["what was the trait in the admin abuse war"] = "sleepy",
    ["what was the trait obtainable in admin abuse"] = "sleepy",
    ["what was the trait obtainable in admin abuse war"] = "sleepy",
    ["what was the trait obtainable in the admin abuse war"] = "sleepy",
    ["what year did i begin making games"] = "2013",
    ["what year did i begin making games in roblox"] = "2013",
    ["what year did i begin making games in roblox release year"] = "2013",
    ["what year did i begin making games in roblox year"] = "2013",
    ["what year did i begin making games on roblox"] = "2013",
    ["what year did i begin making games on roblox release year"] = "2013",
    ["what year did i begin making games on roblox year"] = "2013",
    ["what year did i begin making games release year"] = "2013",
    ["what year did i begin making games year"] = "2013",
    ["what year did i start making games"] = "2013",
    ["what year did i start making games in roblox"] = "2013",
    ["what year did i start making games in roblox release year"] = "2013",
    ["what year did i start making games in roblox year"] = "2013",
    ["what year did i start making games on roblox"] = "2013",
    ["what year did i start making games on roblox release year"] = "2013",
    ["what year did i start making games on roblox year"] = "2013",
    ["what year did i start making games release year"] = "2013",
    ["what year did i start making games year"] = "2013",
    ["what year did sammy begin making games"] = "2013",
    ["what year did sammy begin making games on roblox"] = "2013",
    ["what year did sammy begin making games on roblox release year"] = "2013",
    ["what year did sammy begin making games on roblox year"] = "2013",
    ["what year did sammy begin making games release year"] = "2013",
    ["what year did sammy begin making games year"] = "2013",
    ["what year did sammy start making games"] = "2013",
    ["what year did sammy start making games on roblox"] = "2013",
    ["what year did sammy start making games on roblox release year"] = "2013",
    ["what year did sammy start making games on roblox year"] = "2013",
    ["what year did sammy start making games release year"] = "2013",
    ["what year did sammy start making games year"] = "2013",
    ["what year i began making games"] = "2013",
    ["what year i began making games in roblox"] = "2013",
    ["what year i began making games in roblox release year"] = "2013",
    ["what year i began making games in roblox year"] = "2013",
    ["what year i began making games on roblox"] = "2013",
    ["what year i began making games on roblox release year"] = "2013",
    ["what year i began making games on roblox year"] = "2013",
    ["what year i began making games release year"] = "2013",
    ["what year i began making games year"] = "2013",
    ["what year i started making games"] = "2013",
    ["what year i started making games in roblox"] = "2013",
    ["what year i started making games in roblox release year"] = "2013",
    ["what year i started making games in roblox year"] = "2013",
    ["what year i started making games on roblox"] = "2013",
    ["what year i started making games on roblox release year"] = "2013",
    ["what year i started making games on roblox year"] = "2013",
    ["what year i started making games release year"] = "2013",
    ["what year i started making games year"] = "2013",
    ["what year was bee lucky block released"] = "2026",
    ["what year was headless horseman released"] = "2026",
    ["what year was john pork released"] = "2026",
    ["what year was meowl released"] = "2025",
    ["what year was orchidox released"] = "2026",
    ["what year was skibidi toilet released"] = "2025",
    ["what year was spyder elephant released"] = "2026",
    ["what year was strawberry elephant released"] = "2025",
    ["whats 2nd name of sammy"] = "brakta",
    ["whats my 2nd name"] = "brakta",
    ["whats my cat name"] = "nova",
    ["whats my cats name"] = "nova",
    ["whats my dog name"] = "rocky",
    ["whats my dogs name"] = "rocky",
    ["whats my favorite game"] = "fortnite",
    ["whats my favorite mutation"] = "galaxy",
    ["whats my favorite number"] = "67",
    ["whats my favourite game"] = "fortnite",
    ["whats my favourite mutation"] = "galaxy",
    ["whats my favourite number"] = "67",
    ["whats my hair color"] = "black",
    ["whats my hair colour"] = "black",
    ["whats my last name"] = "brakta",
    ["whats my least favorite game"] = "growagarden",
    ["whats my least favorite group"] = "secretverse",
    ["whats my least favorite person"] = "secretlokii",
    ["whats my least favorite studio"] = "secretverse",
    ["whats my least favourite game"] = "growagarden",
    ["whats my least favourite group"] = "secretverse",
    ["whats my least favourite person"] = "secretlokii",
    ["whats my least favourite studio"] = "secretverse",
    ["whats my middle name"] = "brakta",
    ["whats my pet name"] = "rocky",
    ["whats my second name"] = "brakta",
    ["whats my surname"] = "brakta",
    ["whats sammy 2nd name"] = "brakta",
    ["whats sammy cat name"] = "nova",
    ["whats sammy dog name"] = "rocky",
    ["whats sammy favorite game"] = "fortnite",
    ["whats sammy favorite mutation"] = "galaxy",
    ["whats sammy favourite game"] = "fortnite",
    ["whats sammy favourite mutation"] = "galaxy",
    ["whats sammy least favorite game"] = "growagarden",
    ["whats sammy least favourite game"] = "growagarden",
    ["whats sammy pet name"] = "rocky",
    ["whats sammy second name"] = "brakta",
    ["whats sammys 2nd name"] = "brakta",
    ["whats sammys cat name"] = "nova",
    ["whats sammys dog name"] = "rocky",
    ["whats sammys dogs name"] = "rocky",
    ["whats sammys favorite game"] = "fortnite",
    ["whats sammys favorite mutation"] = "galaxy",
    ["whats sammys favorite number"] = "67",
    ["whats sammys favourite game"] = "fortnite",
    ["whats sammys favourite mutation"] = "galaxy",
    ["whats sammys favourite number"] = "67",
    ["whats sammys least favorite game"] = "growagarden",
    ["whats sammys least favourite game"] = "growagarden",
    ["whats sammys pet name"] = "rocky",
    ["whats sammys second name"] = "brakta",
    ["whats second name of sammy"] = "brakta",
    ["whats the 1st snake"] = "hydraserpent",
    ["whats the 1st snake brainrot"] = "hydraserpent",
    ["whats the 1st snake brainrot added"] = "hydraserpent",
    ["whats the 1st snake brainrot ever added"] = "hydraserpent",
    ["whats the 1st snake brainrot that was added"] = "hydraserpent",
    ["whats the 1st snake brainrot that was ever added"] = "hydraserpent",
    ["whats the 2nd best brainrot"] = "strawberryelephant",
    ["whats the 2nd best brainrot in game"] = "strawberryelephant",
    ["whats the 2nd best brainrot in the game"] = "strawberryelephant",
    ["whats the 3 headed brainrot"] = "hydraserpent",
    ["whats the 4th 3 headed"] = "hydraserpent",
    ["whats the 4th 3 headed brainrot"] = "hydraserpent",
    ["whats the 4th three headed"] = "hydraserpent",
    ["whats the 4th three headed brainrot"] = "hydraserpent",
    ["whats the 6th brainrot based off a mythical creature"] = "hydraserpent",
    ["whats the 6th brainrot based on a mythical creature"] = "hydraserpent",
    ["whats the 6th brainrot to be based off a mythical creature"] = "hydraserpent",
    ["whats the 6th brainrot to be based on a mythical creature"] = "hydraserpent",
    ["whats the 6th mythical brainrot"] = "hydraserpent",
    ["whats the 6th mythical creature"] = "hydraserpent",
    ["whats the 6th mythical creature brainrot"] = "hydraserpent",
    ["whats the best brainrot added in todays admin abuse"] = "lupaandlipa",
    ["whats the best brainrot added in todays update"] = "lupaandlipa",
    ["whats the best brainrot added last saturday"] = "orchidox",
    ["whats the best brainrot added last week"] = "orchidox",
    ["whats the best brainrot added today"] = "lupaandlipa",
    ["whats the best brainrot except spyder elephant"] = "strawberryelephant",
    ["whats the best brainrot except spyderelephant"] = "strawberryelephant",
    ["whats the best brainrot from bee lucky block"] = "orchidox",
    ["whats the best brainrot from the bee lucky block"] = "orchidox",
    ["whats the best brainrot in bee lucky block"] = "orchidox",
    ["whats the best brainrot in the bee lucky block"] = "orchidox",
    ["whats the best brainrot released last saturday"] = "orchidox",
    ["whats the best brainrot released last week"] = "orchidox",
    ["whats the best brainrot that was added in todays admin abuse"] = "lupaandlipa",
    ["whats the best brainrot that was added in todays update"] = "lupaandlipa",
    ["whats the best brainrot that was added last saturday"] = "orchidox",
    ["whats the best brainrot that was added last week"] = "orchidox",
    ["whats the best brainrot that was added today"] = "lupaandlipa",
    ["whats the best brainrot that was released last week"] = "orchidox",
    ["whats the best brainrot without spyder elephant"] = "strawberryelephant",
    ["whats the best brainrot without spyderelephant"] = "strawberryelephant",
    ["whats the best mutation"] = "crystal",
    ["whats the best mutation currently"] = "crystal",
    ["whats the best mutation for meowl visually"] = "cyber",
    ["whats the best mutation right now"] = "crystal",
    ["whats the best mutation rn"] = "crystal",
    ["whats the best visual mutation for meowl"] = "cyber",
    ["whats the first snake"] = "hydraserpent",
    ["whats the first snake brainrot"] = "hydraserpent",
    ["whats the first snake brainrot added"] = "hydraserpent",
    ["whats the first snake brainrot ever added"] = "hydraserpent",
    ["whats the first snake brainrot that was added"] = "hydraserpent",
    ["whats the first snake brainrot that was ever added"] = "hydraserpent",
    ["whats the flying bee gear"] = "flyingbee",
    ["whats the fourth 3 headed"] = "hydraserpent",
    ["whats the fourth 3 headed brainrot"] = "hydraserpent",
    ["whats the fourth three headed"] = "hydraserpent",
    ["whats the fourth three headed brainrot"] = "hydraserpent",
    ["whats the latest snake brainrot"] = "hydraserpent",
    ["whats the most op brainrot"] = "orchidox",
    ["whats the most op brainrot added"] = "orchidox",
    ["whats the most op brainrot added recently"] = "orchidox",
    ["whats the most op brainrot added today"] = "lupaandlipa",
    ["whats the most op brainrot from bee lucky block"] = "orchidox",
    ["whats the most op brainrot from the bee lucky block"] = "orchidox",
    ["whats the most op brainrot in bee lucky block"] = "orchidox",
    ["whats the most op brainrot in the bee lucky block"] = "orchidox",
    ["whats the most op brainrot recently"] = "orchidox",
    ["whats the most op brainrot released"] = "orchidox",
    ["whats the most op brainrot released recently"] = "orchidox",
    ["whats the most op brainrot that was added"] = "orchidox",
    ["whats the most op brainrot that was added recently"] = "orchidox",
    ["whats the most op brainrot that was added today"] = "lupaandlipa",
    ["whats the most op brainrot that was released"] = "orchidox",
    ["whats the most op brainrot that was released recently"] = "orchidox",
    ["whats the mythical creature brainrot"] = "hydraserpent",
    ["whats the new bee gear"] = "flyingbee",
    ["whats the new flying bee gear"] = "flyingbee",
    ["whats the new snake"] = "hydraserpent",
    ["whats the new snake brainrot"] = "hydraserpent",
    ["whats the new snake brainrot his name"] = "hydraserpent",
    ["whats the new snake brainrot name"] = "hydraserpent",
    ["whats the new snake brainrots name"] = "hydraserpent",
    ["whats the newest snake brainrot"] = "hydraserpent",
    ["whats the op brainrot that was added recently"] = "lupaandlipa",
    ["whats the op brainrot that was recently added"] = "lupaandlipa",
    ["whats the op brainrot that was recently released"] = "lupaandlipa",
    ["whats the op brainrot that was released recently"] = "lupaandlipa",
    ["whats the second best brainrot"] = "strawberryelephant",
    ["whats the second best brainrot in game"] = "strawberryelephant",
    ["whats the second best brainrot in the game"] = "strawberryelephant",
    ["whats the sixth brainrot based off a mythical creature"] = "hydraserpent",
    ["whats the sixth brainrot based on a mythical creature"] = "hydraserpent",
    ["whats the sixth brainrot to be based off a mythical creature"] = "hydraserpent",
    ["whats the sixth brainrot to be based on a mythical creature"] = "hydraserpent",
    ["whats the sixth mythical brainrot"] = "hydraserpent",
    ["whats the sixth mythical creature"] = "hydraserpent",
    ["whats the sixth mythical creature brainrot"] = "hydraserpent",
    ["whats the snake brainrot"] = "hydraserpent",
    ["whats the snake brainrot his name"] = "hydraserpent",
    ["whats the snake brainrot name"] = "hydraserpent",
    ["whats the snake brainrots name"] = "hydraserpent",
    ["whats the three headed brainrot"] = "hydraserpent",
    ["when 1 year event trait released"] = "may2026",
    ["when 1 year trait released"] = "may2026",
    ["when 10 billion trait released"] = "june2025",
    ["when 10 billion visits trait released"] = "june2025",
    ["when 10b trait released"] = "june2025",
    ["when 1st craft machine released"] = "september2025",
    ["when 1st craft released"] = "september2025",
    ["when 1st fuse machine released"] = "august2025",
    ["when 1st fuse released"] = "august2025",
    ["when 1st lucky block released"] = "july2025",
    ["when 1st machine added released"] = "june2025",
    ["when 1st machine released"] = "june2025",
    ["when 2026 trait released"] = "december2025",
    ["when 26 trait released"] = "december2025",
    ["when 2nd fuse machine released"] = "october2025",
    ["when 2nd fuse released"] = "october2025",
    ["when 3rd fuse machine released"] = "december2025",
    ["when 3rd fuse released"] = "december2025",
    ["when 4th fuse machine released"] = "march2026",
    ["when 4th fuse released"] = "march2026",
    ["when 4th of july trait released"] = "july2025",
    ["when 5th fuse machine released"] = "may2026",
    ["when 5th fuse released"] = "may2026",
    ["when admin machine released"] = "november2025",
    ["when anniversary trait released"] = "may2026",
    ["when asteroid trait released"] = "june2025",
    ["when bee block released"] = "august2026",
    ["when bee lucky block brainrot released"] = "august2026",
    ["when bee lucky block in sab released"] = "august2026",
    ["when bee lucky block in the game released"] = "august2026",
    ["when bee lucky block released"] = "august2026",
    ["when bee lucky blocks released"] = "august2026",
    ["when bee lucky released"] = "august2026",
    ["when bee shop brainrot released"] = "august2026",
    ["when bee update brainrot released"] = "august2026",
    ["when best bee brainrot released"] = "august2026",
    ["when best bee lucky block brainrot released"] = "august2026",
    ["when best bee shop brainrot released"] = "august2026",
    ["when best brainrot added last saturday released"] = "august2026",
    ["when best brainrot added last week released"] = "august2026",
    ["when best brainrot from bee lucky block released"] = "august2026",
    ["when best brainrot in bee lucky block released"] = "august2026",
    ["when best brainrot released last saturday released"] = "august2026",
    ["when best brainrot released last week released"] = "august2026",
    ["when best brainrot that was added last saturday released"] = "august2026",
    ["when best brainrot that was added last week released"] = "august2026",
    ["when best brainrot that was released last saturday released"] = "august2026",
    ["when best brainrot that was released last week released"] = "august2026",
    ["when best looking mutation for meowl released"] = "april2026",
    ["when best looking mutation on meowl released"] = "april2026",
    ["when best mutation for meowl visually released"] = "april2026",
    ["when best visual mutation for favorite brainrot released"] = "april2026",
    ["when best visual mutation for meowl released"] = "april2026",
    ["when best visual mutation for my favorite brainrot released"] = "april2026",
    ["when best visual mutation on meowl released"] = "april2026",
    ["when bloodrot mutation released"] = "june2025",
    ["when bloodrot released"] = "june2025",
    ["when blue egg trait released"] = "april2026",
    ["when bombardiro trait released"] = "june2025",
    ["when brainrot added last saturday released"] = "august2026",
    ["when brainrot added last week released"] = "august2026",
    ["when brainrot god lucky block released"] = "july2025",
    ["when brainrot released last saturday released"] = "august2026",
    ["when brainrot released last week released"] = "august2026",
    ["when brainrot that was added last saturday released"] = "august2026",
    ["when brainrot that was added last week released"] = "august2026",
    ["when brainrot that was released last saturday released"] = "august2026",
    ["when brainrot that was released last week released"] = "august2026",
    ["when bruno mars concert trait released"] = "january2026",
    ["when bruno mars trait released"] = "january2026",
    ["when bubblegum machine released"] = "july2025",
    ["when bubblegum trait released"] = "july2025",
    ["when bull trait released"] = "july2026",
    ["when bunny ears released"] = "april2026",
    ["when bunny ears trait released"] = "april2026",
    ["when candy mutation released"] = "july2025",
    ["when chipso and queso released"] = "october2025",
    ["when chipso queso released"] = "october2025",
    ["when chipso released"] = "october2025",
    ["when chocolate trait released"] = "february2026",
    ["when comet struck released"] = "june2025",
    ["when comet struck trait released"] = "june2025",
    ["when concert trait released"] = "january2026",
    ["when crab rave released"] = "june2025",
    ["when crab rave trait released"] = "june2025",
    ["when craft machine released"] = "september2025",
    ["when craft released"] = "september2025",
    ["when crystal mutation released"] = "july2026",
    ["when cupid fuse released"] = "february2026",
    ["when cupid machine released"] = "february2026",
    ["when current fuse released"] = "june2025",
    ["when cursed mutation released"] = "january2026",
    ["when cursed released"] = "january2026",
    ["when cyber admin machine released"] = "april2026",
    ["when cyber admin released"] = "april2026",
    ["when cyber craft machine released"] = "april2026",
    ["when cyber craft released"] = "april2026",
    ["when cyber mutation released"] = "april2026",
    ["when cyber released"] = "april2026",
    ["when cybercraft released"] = "april2026",
    ["when did bee lucky block release"] = "august2026",
    ["when did he begin making games"] = "2013",
    ["when did he begin making games on roblox"] = "2013",
    ["when did he begin making games on roblox release year"] = "2013",
    ["when did he begin making games on roblox year"] = "2013",
    ["when did he begin making games release year"] = "2013",
    ["when did he begin making games year"] = "2013",
    ["when did he start making games"] = "2013",
    ["when did he start making games on roblox"] = "2013",
    ["when did he start making games on roblox release year"] = "2013",
    ["when did he start making games on roblox year"] = "2013",
    ["when did he start making games release year"] = "2013",
    ["when did he start making games year"] = "2013",
    ["when did headless horseman release"] = "february2026",
    ["when did i begin making games"] = "2013",
    ["when did i begin making games in roblox"] = "2013",
    ["when did i begin making games in roblox release year"] = "2013",
    ["when did i begin making games in roblox year"] = "2013",
    ["when did i begin making games on roblox"] = "2013",
    ["when did i begin making games on roblox release year"] = "2013",
    ["when did i begin making games on roblox year"] = "2013",
    ["when did i begin making games release year"] = "2013",
    ["when did i begin making games year"] = "2013",
    ["when did i start making games"] = "2013",
    ["when did i start making games in roblox"] = "2013",
    ["when did i start making games in roblox release year"] = "2013",
    ["when did i start making games in roblox year"] = "2013",
    ["when did i start making games on roblox"] = "2013",
    ["when did i start making games on roblox release year"] = "2013",
    ["when did i start making games on roblox year"] = "2013",
    ["when did i start making games release year"] = "2013",
    ["when did i start making games year"] = "2013",
    ["when did john pork release"] = "may2026",
    ["when did meowl release"] = "october2025",
    ["when did orchideon release"] = "august2026",
    ["when did orchidox release"] = "august2026",
    ["when did sammy begin making games"] = "2013",
    ["when did sammy begin making games in roblox"] = "2013",
    ["when did sammy begin making games on roblox"] = "2013",
    ["when did sammy begin making games on roblox release year"] = "2013",
    ["when did sammy begin making games on roblox year"] = "2013",
    ["when did sammy begin making games release year"] = "2013",
    ["when did sammy begin making games year"] = "2013",
    ["when did sammy start making games"] = "2013",
    ["when did sammy start making games in roblox"] = "2013",
    ["when did sammy start making games on roblox"] = "2013",
    ["when did sammy start making games on roblox release year"] = "2013",
    ["when did sammy start making games on roblox year"] = "2013",
    ["when did sammy start making games release year"] = "2013",
    ["when did sammy start making games year"] = "2013",
    ["when did skibidi toilet release"] = "december2025",
    ["when did spyder elephant release"] = "may2026",
    ["when did strawberry elephant release"] = "august2025",
    ["when did the bee lucky block release"] = "august2026",
    ["when did the strawberry elephant release"] = "august2025",
    ["when divine admin machine released"] = "february2026",
    ["when divine admin released"] = "february2026",
    ["when divine fuse machine released"] = "march2026",
    ["when divine fuse released"] = "march2026",
    ["when divine halo trait released"] = "february2026",
    ["when divine mutation released"] = "february2026",
    ["when duels machine released"] = "january2026",
    ["when duels released"] = "january2026",
    ["when duels update released"] = "january2026",
    ["when egg incubator released"] = "april2026",
    ["when egg trait incubator released"] = "april2026",
    ["when extinct event trait released"] = "september2025",
    ["when extinct trait released"] = "september2025",
    ["when fat sammy npc released"] = "august2025",
    ["when fat sammy released"] = "august2025",
    ["when fav mutation released"] = "august2025",
    ["when favorite mutation released"] = "august2025",
    ["when favourite mutation released"] = "august2025",
    ["when fifth fuse machine released"] = "may2026",
    ["when fifth fuse released"] = "may2026",
    ["when fire trait released"] = "june2025",
    ["when firework trait released"] = "july2025",
    ["when first craft machine released"] = "september2025",
    ["when first craft released"] = "september2025",
    ["when first fuse machine released"] = "august2025",
    ["when first fuse released"] = "august2025",
    ["when first lucky block released"] = "july2025",
    ["when first machine added released"] = "june2025",
    ["when first machine added to sab released"] = "june2025",
    ["when first machine added to the game released"] = "june2025",
    ["when first machine in game released"] = "june2025",
    ["when first machine in sab released"] = "june2025",
    ["when first machine in the game released"] = "june2025",
    ["when first machine released"] = "june2025",
    ["when fourth fuse machine released"] = "march2026",
    ["when fourth fuse released"] = "march2026",
    ["when fuse machine original released"] = "august2025",
    ["when fuse machine released"] = "august2025",
    ["when fuse machine return released"] = "january2026",
    ["when fuse released"] = "august2025",
    ["when fuse return released"] = "january2026",
    ["when galaxy mutation released"] = "august2025",
    ["when galaxy released"] = "august2025",
    ["when game created released"] = "may2025",
    ["when game launched released"] = "may2025",
    ["when game made released"] = "may2025",
    ["when game release released"] = "may2025",
    ["when game released released"] = "may2025",
    ["when glitch trait released"] = "june2025",
    ["when glitched trait released"] = "june2025",
    ["when granny trait released"] = "march2026",
    ["when green egg trait released"] = "april2026",
    ["when halo trait released"] = "february2026",
    ["when headless horseman"] = "february2026",
    ["when headlesshorseman released"] = "february2026",
    ["when i began making games"] = "2013",
    ["when i began making games in roblox"] = "2013",
    ["when i began making games in roblox release year"] = "2013",
    ["when i began making games in roblox year"] = "2013",
    ["when i began making games on roblox"] = "2013",
    ["when i began making games on roblox release year"] = "2013",
    ["when i began making games on roblox year"] = "2013",
    ["when i began making games release year"] = "2013",
    ["when i began making games year"] = "2013",
    ["when i started making games"] = "2013",
    ["when i started making games in roblox"] = "2013",
    ["when i started making games in roblox release year"] = "2013",
    ["when i started making games in roblox year"] = "2013",
    ["when i started making games on roblox"] = "2013",
    ["when i started making games on roblox release year"] = "2013",
    ["when i started making games on roblox year"] = "2013",
    ["when i started making games release year"] = "2013",
    ["when i started making games year"] = "2013",
    ["when incubator machine released"] = "april2026",
    ["when indonesia trait released"] = "june2025",
    ["when jack o lantern trait released"] = "october2025",
    ["when jackolantern trait released"] = "october2025",
    ["when john pork"] = "may2026",
    ["when johnpork released"] = "may2026",
    ["when last craft machine released"] = "april2026",
    ["when last craft released"] = "april2026",
    ["when last fuse machine released"] = "june2025",
    ["when last fuse released"] = "june2025",
    ["when latest craft machine released"] = "april2026",
    ["when latest craft released"] = "april2026",
    ["when latest fuse machine released"] = "june2025",
    ["when latest fuse released"] = "june2025",
    ["when lava mutation released"] = "july2025",
    ["when los taco block released"] = "november2025",
    ["when los taco blocks released"] = "november2025",
    ["when los trader released"] = "june2026",
    ["when los traders released"] = "june2026",
    ["when lucky block released"] = "july2025",
    ["when lucky blocks released"] = "july2025",
    ["when lucky pot trait released"] = "january2026",
    ["when lucky trait released"] = "january2026",
    ["when meowl"] = "october2025",
    ["when meowl released"] = "october2025",
    ["when molten mutation released"] = "july2025",
    ["when most op bee lucky block brainrot released"] = "august2026",
    ["when most op brainrot added recently released"] = "august2026",
    ["when most op brainrot added released"] = "august2026",
    ["when most op brainrot from bee lucky block released"] = "august2026",
    ["when most op brainrot in bee lucky block released"] = "august2026",
    ["when most op brainrot recently released"] = "august2026",
    ["when most op brainrot released"] = "august2026",
    ["when most op brainrot released recently released"] = "august2026",
    ["when most op brainrot released released"] = "august2026",
    ["when most op brainrot that was added recently released"] = "august2026",
    ["when most op brainrot that was added released"] = "august2026",
    ["when most op brainrot that was released recently released"] = "august2026",
    ["when most op brainrot that was released released"] = "august2026",
    ["when my fav mutation released"] = "august2025",
    ["when my favorite mutation released"] = "august2025",
    ["when my favorite visual mutation for meowl released"] = "april2026",
    ["when my favourite mutation released"] = "august2025",
    ["when my favourite visual mutation for meowl released"] = "april2026",
    ["when mythic lucky block released"] = "july2025",
    ["when new year 2026 trait released"] = "december2025",
    ["when new year fuse released"] = "december2025",
    ["when new year machine released"] = "december2025",
    ["when new years machine released"] = "december2025",
    ["when newest craft machine released"] = "april2026",
    ["when newest craft released"] = "april2026",
    ["when newest fuse machine released"] = "june2025",
    ["when newest fuse released"] = "june2025",
    ["when nyan cat released"] = "june2025",
    ["when nyan cat trait released"] = "june2025",
    ["when nyan trait released"] = "june2025",
    ["when nyancat released"] = "june2025",
    ["when og fuse machine released"] = "january2026",
    ["when oldest fuse released"] = "august2025",
    ["when oldest machine released"] = "june2025",
    ["when op brainrot added recently released"] = "august2026",
    ["when op brainrot added released"] = "august2026",
    ["when op brainrot recently released"] = "august2026",
    ["when op brainrot released"] = "august2026",
    ["when op brainrot released recently released"] = "august2026",
    ["when op brainrot that was added recently released"] = "august2026",
    ["when op brainrot that was added released"] = "august2026",
    ["when op brainrot that was released recently released"] = "august2026",
    ["when orange egg trait released"] = "orangeegg",
    ["when orchideon released"] = "august2026",
    ["when orchidox released"] = "august2026",
    ["when original craft machine released"] = "september2025",
    ["when original fuse machine released"] = "august2025",
    ["when original fuse released"] = "august2025",
    ["when original lucky block released"] = "july2025",
    ["when original machine released"] = "june2025",
    ["when overall fav mutation released"] = "august2025",
    ["when overall favorite mutation released"] = "august2025",
    ["when overall favourite mutation released"] = "august2025",
    ["when phantom mutation released"] = "june2026",
    ["when pink egg trait released"] = "april2026",
    ["when queso released"] = "october2025",
    ["when radioactive mutation released"] = "november2025",
    ["when radioactive released"] = "november2025",
    ["when rain trait released"] = "june2025",
    ["when rain weather trait released"] = "june2025",
    ["when rainbow fuse machine released"] = "june2025",
    ["when rainbow fuse released"] = "june2025",
    ["when rainbow machine released"] = "june2025",
    ["when rainbowfuse released"] = "june2025",
    ["when rainbowmachine released"] = "june2025",
    ["when recent fuse released"] = "june2025",
    ["when reindeer trait released"] = "december2025",
    ["when released"] = "may2025",
    ["when revived fuse machine released"] = "january2026",
    ["when rip tombstone released"] = "october2025",
    ["when rip tombstone trait released"] = "october2025",
    ["when rng machine released"] = "august2026",
    ["when sab created released"] = "may2025",
    ["when sab game release released"] = "may2025",
    ["when sab launched released"] = "may2025",
    ["when sab made"] = "may2025",
    ["when sab made released"] = "may2025",
    ["when sab release released"] = "may2025",
    ["when sab released"] = "may2025",
    ["when sab released released"] = "may2025",
    ["when sammy fav mutation released"] = "august2025",
    ["when sammy favorite mutation released"] = "august2025",
    ["when sammy favorite visual mutation for meowl released"] = "april2026",
    ["when sammy favourite mutation released"] = "august2025",
    ["when sammys favorite mutation released"] = "august2025",
    ["when sammys favorite visual mutation for meowl released"] = "april2026",
    ["when sammys favourite mutation released"] = "august2025",
    ["when santa fuse released"] = "december2025",
    ["when santa hat trait released"] = "december2025",
    ["when santa machine released"] = "december2025",
    ["when santahat trait released"] = "december2025",
    ["when santas fuse machine released"] = "december2025",
    ["when santas fuse released"] = "december2025",
    ["when second fuse machine released"] = "october2025",
    ["when second fuse released"] = "october2025",
    ["when secret lucky block released"] = "july2025",
    ["when shark trait released"] = "june2025",
    ["when skeleton trait released"] = "september2025",
    ["when skibidi toilet"] = "december2025",
    ["when skibidi trait released"] = "june2025",
    ["when skibiditoilet released"] = "december2025",
    ["when snow trait released"] = "june2025",
    ["when snow weather trait released"] = "june2025",
    ["when snowy trait released"] = "june2025",
    ["when solar flare trait released"] = "june2025",
    ["when spain event trait released"] = "july2026",
    ["when spain trait released"] = "july2026",
    ["when spyder elephant"] = "may2026",
    ["when spyderelephant released"] = "may2026",
    ["when starfall trait released"] = "june2025",
    ["when starfall weather trait released"] = "june2025",
    ["when steal a brainrot created released"] = "may2025",
    ["when steal a brainrot game released"] = "may2025",
    ["when steal a brainrot launched released"] = "may2025",
    ["when steal a brainrot made released"] = "may2025",
    ["when steal a brainrot release released"] = "may2025",
    ["when steal a brainrot released released"] = "may2025",
    ["when strawberry elephant"] = "august2025",
    ["when strawberryelephant released"] = "august2025",
    ["when strongest brainrot added recently released"] = "august2026",
    ["when strongest brainrot added released"] = "august2026",
    ["when strongest brainrot recently released"] = "august2026",
    ["when strongest brainrot released recently released"] = "august2026",
    ["when strongest brainrot that was added recently released"] = "august2026",
    ["when strongest brainrot that was added released"] = "august2026",
    ["when strongest brainrot that was released recently released"] = "august2026",
    ["when summer fuse machine released"] = "may2026",
    ["when summer fuse released"] = "may2026",
    ["when taco block released"] = "september2025",
    ["when taco blocks released"] = "november2025",
    ["when taco lucky block released"] = "september2025",
    ["when taco merchant npc released"] = "august2026",
    ["when taco merchant released"] = "august2026",
    ["when taco shop released"] = "august2026",
    ["when taco trait released"] = "june2025",
    ["when taco tuesday lucky block released"] = "september2025",
    ["when taco tuesday trait released"] = "june2025",
    ["when the best visual mutation for meowl released"] = "april2026",
    ["when the best visual mutation on meowl released"] = "april2026",
    ["when the most op brainrot added recently released"] = "august2026",
    ["when the most op brainrot added released"] = "august2026",
    ["when the most op brainrot recently released"] = "august2026",
    ["when the most op brainrot released"] = "august2026",
    ["when the most op brainrot released recently released"] = "august2026",
    ["when the most op brainrot that was added recently released"] = "august2026",
    ["when the most op brainrot that was added released"] = "august2026",
    ["when the most op brainrot that was released recently released"] = "august2026",
    ["when the op brainrot added recently released"] = "august2026",
    ["when the op brainrot added released"] = "august2026",
    ["when the op brainrot released"] = "august2026",
    ["when the op brainrot that was added recently released"] = "august2026",
    ["when the op brainrot that was added released"] = "august2026",
    ["when third fuse machine released"] = "december2025",
    ["when third fuse released"] = "december2025",
    ["when tombstone trait released"] = "october2025",
    ["when trade machine released"] = "february2026",
    ["when trade plaza released"] = "june2026",
    ["when trading machine released"] = "june2026",
    ["when trait incubator released"] = "april2026",
    ["when tung tung attack released"] = "june2025",
    ["when tung tung released"] = "june2025",
    ["when tung tung trait released"] = "june2025",
    ["when tung tung zombie released"] = "june2025",
    ["when valentine fuse released"] = "february2026",
    ["when valentine machine released"] = "february2026",
    ["when valentine trait released"] = "february2026",
    ["when valentines machine released"] = "february2026",
    ["when visually best mutation for meowl released"] = "april2026",
    ["when visually best mutation on meowl released"] = "april2026",
    ["when was 1 year event trait released"] = "may2026",
    ["when was 1 year trait released"] = "may2026",
    ["when was 10 billion trait released"] = "june2025",
    ["when was 10 billion visits trait released"] = "june2025",
    ["when was 10b trait released"] = "june2025",
    ["when was 1st craft machine released"] = "september2025",
    ["when was 1st craft released"] = "september2025",
    ["when was 1st fuse machine released"] = "august2025",
    ["when was 1st fuse released"] = "august2025",
    ["when was 1st lucky block released"] = "july2025",
    ["when was 1st machine added released"] = "june2025",
    ["when was 1st machine released"] = "june2025",
    ["when was 2026 trait released"] = "december2025",
    ["when was 26 trait released"] = "december2025",
    ["when was 2nd fuse machine released"] = "october2025",
    ["when was 2nd fuse released"] = "october2025",
    ["when was 3rd fuse machine released"] = "december2025",
    ["when was 3rd fuse released"] = "december2025",
    ["when was 4th fuse machine released"] = "march2026",
    ["when was 4th fuse released"] = "march2026",
    ["when was 4th of july trait released"] = "july2025",
    ["when was 5th fuse machine released"] = "may2026",
    ["when was 5th fuse released"] = "may2026",
    ["when was admin machine released"] = "november2025",
    ["when was anniversary trait released"] = "may2026",
    ["when was asteroid trait released"] = "june2025",
    ["when was bee block released"] = "august2026",
    ["when was bee lucky block brainrot released"] = "august2026",
    ["when was bee lucky block in sab released"] = "august2026",
    ["when was bee lucky block in the game released"] = "august2026",
    ["when was bee lucky block released"] = "august2026",
    ["when was bee lucky blocks released"] = "august2026",
    ["when was bee lucky released"] = "august2026",
    ["when was bee shop brainrot released"] = "august2026",
    ["when was bee update brainrot released"] = "august2026",
    ["when was best bee brainrot released"] = "august2026",
    ["when was best bee lucky block brainrot released"] = "august2026",
    ["when was best bee shop brainrot released"] = "august2026",
    ["when was best brainrot added last saturday released"] = "august2026",
    ["when was best brainrot added last week released"] = "august2026",
    ["when was best brainrot from bee lucky block released"] = "august2026",
    ["when was best brainrot in bee lucky block released"] = "august2026",
    ["when was best brainrot released last saturday released"] = "august2026",
    ["when was best brainrot released last week released"] = "august2026",
    ["when was best brainrot that was added last saturday released"] = "august2026",
    ["when was best brainrot that was added last week released"] = "august2026",
    ["when was best brainrot that was released last saturday released"] = "august2026",
    ["when was best brainrot that was released last week released"] = "august2026",
    ["when was best looking mutation for meowl released"] = "april2026",
    ["when was best looking mutation on meowl released"] = "april2026",
    ["when was best mutation for meowl visually released"] = "april2026",
    ["when was best visual mutation for favorite brainrot released"] = "april2026",
    ["when was best visual mutation for meowl released"] = "april2026",
    ["when was best visual mutation for my favorite brainrot released"] = "april2026",
    ["when was best visual mutation on meowl released"] = "april2026",
    ["when was bloodrot mutation released"] = "june2025",
    ["when was bloodrot released"] = "june2025",
    ["when was blue egg trait released"] = "april2026",
    ["when was bombardiro trait released"] = "june2025",
    ["when was brainrot added last saturday released"] = "august2026",
    ["when was brainrot added last week released"] = "august2026",
    ["when was brainrot god lucky block released"] = "july2025",
    ["when was brainrot released last saturday released"] = "august2026",
    ["when was brainrot released last week released"] = "august2026",
    ["when was brainrot that was added last saturday released"] = "august2026",
    ["when was brainrot that was added last week released"] = "august2026",
    ["when was brainrot that was released last saturday released"] = "august2026",
    ["when was brainrot that was released last week released"] = "august2026",
    ["when was bruno mars concert trait released"] = "january2026",
    ["when was bruno mars trait released"] = "january2026",
    ["when was bubblegum machine released"] = "july2025",
    ["when was bubblegum trait released"] = "july2025",
    ["when was bull trait released"] = "july2026",
    ["when was bunny ears released"] = "april2026",
    ["when was bunny ears trait released"] = "april2026",
    ["when was candy mutation released"] = "july2025",
    ["when was chipso and queso released"] = "october2025",
    ["when was chipso queso released"] = "october2025",
    ["when was chipso released"] = "october2025",
    ["when was chocolate trait released"] = "february2026",
    ["when was comet struck released"] = "june2025",
    ["when was comet struck trait released"] = "june2025",
    ["when was concert trait released"] = "january2026",
    ["when was crab rave released"] = "june2025",
    ["when was crab rave trait released"] = "june2025",
    ["when was craft machine released"] = "september2025",
    ["when was craft released"] = "september2025",
    ["when was crystal mutation released"] = "july2026",
    ["when was cupid fuse released"] = "february2026",
    ["when was cupid machine released"] = "february2026",
    ["when was current fuse released"] = "june2025",
    ["when was cursed mutation released"] = "january2026",
    ["when was cursed released"] = "january2026",
    ["when was cyber admin machine released"] = "april2026",
    ["when was cyber admin released"] = "april2026",
    ["when was cyber craft machine released"] = "april2026",
    ["when was cyber craft released"] = "april2026",
    ["when was cyber mutation released"] = "april2026",
    ["when was cyber released"] = "april2026",
    ["when was cybercraft released"] = "april2026",
    ["when was divine admin machine released"] = "february2026",
    ["when was divine admin released"] = "february2026",
    ["when was divine fuse machine released"] = "march2026",
    ["when was divine fuse released"] = "march2026",
    ["when was divine halo trait released"] = "february2026",
    ["when was divine mutation released"] = "february2026",
    ["when was duels machine released"] = "january2026",
    ["when was duels released"] = "january2026",
    ["when was duels update released"] = "january2026",
    ["when was egg incubator released"] = "april2026",
    ["when was egg trait incubator released"] = "april2026",
    ["when was extinct event trait released"] = "september2025",
    ["when was extinct trait released"] = "september2025",
    ["when was fat sammy npc released"] = "august2025",
    ["when was fat sammy released"] = "august2025",
    ["when was fav mutation released"] = "august2025",
    ["when was favorite mutation released"] = "august2025",
    ["when was favourite mutation released"] = "august2025",
    ["when was fifth fuse machine released"] = "may2026",
    ["when was fifth fuse released"] = "may2026",
    ["when was fire trait released"] = "june2025",
    ["when was firework trait released"] = "july2025",
    ["when was first craft machine released"] = "september2025",
    ["when was first craft released"] = "september2025",
    ["when was first fuse machine released"] = "august2025",
    ["when was first fuse released"] = "august2025",
    ["when was first lucky block released"] = "july2025",
    ["when was first machine added released"] = "june2025",
    ["when was first machine added to sab released"] = "june2025",
    ["when was first machine added to the game released"] = "june2025",
    ["when was first machine in game released"] = "june2025",
    ["when was first machine in sab released"] = "june2025",
    ["when was first machine in the game released"] = "june2025",
    ["when was first machine released"] = "june2025",
    ["when was fourth fuse machine released"] = "march2026",
    ["when was fourth fuse released"] = "march2026",
    ["when was fuse machine original released"] = "august2025",
    ["when was fuse machine released"] = "august2025",
    ["when was fuse machine return released"] = "january2026",
    ["when was fuse released"] = "august2025",
    ["when was fuse return released"] = "january2026",
    ["when was galaxy mutation released"] = "august2025",
    ["when was galaxy released"] = "august2025",
    ["when was game created released"] = "may2025",
    ["when was game launched released"] = "may2025",
    ["when was game made released"] = "may2025",
    ["when was game release released"] = "may2025",
    ["when was game released released"] = "may2025",
    ["when was glitch trait released"] = "june2025",
    ["when was glitched trait released"] = "june2025",
    ["when was granny trait released"] = "march2026",
    ["when was green egg trait released"] = "april2026",
    ["when was halo trait released"] = "february2026",
    ["when was headless horseman released"] = "february2026",
    ["when was headlesshorseman released"] = "february2026",
    ["when was incubator machine released"] = "april2026",
    ["when was indonesia trait released"] = "june2025",
    ["when was jack o lantern trait released"] = "october2025",
    ["when was jackolantern trait released"] = "october2025",
    ["when was john pork released"] = "may2026",
    ["when was johnpork released"] = "may2026",
    ["when was last craft machine released"] = "april2026",
    ["when was last craft released"] = "april2026",
    ["when was last fuse machine released"] = "june2025",
    ["when was last fuse released"] = "june2025",
    ["when was latest craft machine released"] = "april2026",
    ["when was latest craft released"] = "april2026",
    ["when was latest fuse machine released"] = "june2025",
    ["when was latest fuse released"] = "june2025",
    ["when was lava mutation released"] = "july2025",
    ["when was los taco block released"] = "november2025",
    ["when was los taco blocks released"] = "november2025",
    ["when was los trader released"] = "june2026",
    ["when was los traders released"] = "june2026",
    ["when was lucky block released"] = "july2025",
    ["when was lucky blocks released"] = "july2025",
    ["when was lucky pot trait released"] = "january2026",
    ["when was lucky trait released"] = "january2026",
    ["when was meowl released"] = "october2025",
    ["when was molten mutation released"] = "july2025",
    ["when was most op bee lucky block brainrot released"] = "august2026",
    ["when was most op brainrot added recently released"] = "august2026",
    ["when was most op brainrot added released"] = "august2026",
    ["when was most op brainrot from bee lucky block released"] = "august2026",
    ["when was most op brainrot in bee lucky block released"] = "august2026",
    ["when was most op brainrot recently released"] = "august2026",
    ["when was most op brainrot released"] = "august2026",
    ["when was most op brainrot released recently released"] = "august2026",
    ["when was most op brainrot released released"] = "august2026",
    ["when was most op brainrot that was added recently released"] = "august2026",
    ["when was most op brainrot that was added released"] = "august2026",
    ["when was most op brainrot that was released recently released"] = "august2026",
    ["when was most op brainrot that was released released"] = "august2026",
    ["when was my fav mutation released"] = "august2025",
    ["when was my favorite mutation released"] = "august2025",
    ["when was my favorite visual mutation for meowl released"] = "april2026",
    ["when was my favourite mutation released"] = "august2025",
    ["when was my favourite visual mutation for meowl released"] = "april2026",
    ["when was mythic lucky block released"] = "july2025",
    ["when was new year 2026 trait released"] = "december2025",
    ["when was new year fuse released"] = "december2025",
    ["when was new year machine released"] = "december2025",
    ["when was new years machine released"] = "december2025",
    ["when was newest craft machine released"] = "april2026",
    ["when was newest craft released"] = "april2026",
    ["when was newest fuse machine released"] = "june2025",
    ["when was newest fuse released"] = "june2025",
    ["when was nyan cat released"] = "june2025",
    ["when was nyan cat trait released"] = "june2025",
    ["when was nyan trait released"] = "june2025",
    ["when was nyancat released"] = "june2025",
    ["when was og fuse machine released"] = "january2026",
    ["when was oldest fuse released"] = "august2025",
    ["when was oldest machine released"] = "june2025",
    ["when was op brainrot added recently released"] = "august2026",
    ["when was op brainrot added released"] = "august2026",
    ["when was op brainrot recently released"] = "august2026",
    ["when was op brainrot released"] = "august2026",
    ["when was op brainrot released recently released"] = "august2026",
    ["when was op brainrot that was added recently released"] = "august2026",
    ["when was op brainrot that was added released"] = "august2026",
    ["when was op brainrot that was released recently released"] = "august2026",
    ["when was orange egg trait released"] = "orangeegg",
    ["when was orchideon released"] = "august2026",
    ["when was orchidox released"] = "august2026",
    ["when was original craft machine released"] = "september2025",
    ["when was original fuse machine released"] = "august2025",
    ["when was original fuse released"] = "august2025",
    ["when was original lucky block released"] = "july2025",
    ["when was original machine released"] = "june2025",
    ["when was overall fav mutation released"] = "august2025",
    ["when was overall favorite mutation released"] = "august2025",
    ["when was overall favourite mutation released"] = "august2025",
    ["when was phantom mutation released"] = "june2026",
    ["when was pink egg trait released"] = "april2026",
    ["when was queso released"] = "october2025",
    ["when was radioactive mutation released"] = "november2025",
    ["when was radioactive released"] = "november2025",
    ["when was rain trait released"] = "june2025",
    ["when was rain weather trait released"] = "june2025",
    ["when was rainbow fuse machine released"] = "june2025",
    ["when was rainbow fuse released"] = "june2025",
    ["when was rainbow machine released"] = "june2025",
    ["when was rainbowfuse released"] = "june2025",
    ["when was rainbowmachine released"] = "june2025",
    ["when was recent fuse released"] = "june2025",
    ["when was reindeer trait released"] = "december2025",
    ["when was revived fuse machine released"] = "january2026",
    ["when was rip tombstone released"] = "october2025",
    ["when was rip tombstone trait released"] = "october2025",
    ["when was rng machine released"] = "august2026",
    ["when was sab created released"] = "may2025",
    ["when was sab game release released"] = "may2025",
    ["when was sab launched released"] = "may2025",
    ["when was sab made released"] = "may2025",
    ["when was sab release released"] = "may2025",
    ["when was sab released released"] = "may2025",
    ["when was sammy fav mutation released"] = "august2025",
    ["when was sammy favorite mutation released"] = "august2025",
    ["when was sammy favorite visual mutation for meowl released"] = "april2026",
    ["when was sammy favourite mutation released"] = "august2025",
    ["when was sammys favorite mutation released"] = "august2025",
    ["when was sammys favorite visual mutation for meowl released"] = "april2026",
    ["when was sammys favourite mutation released"] = "august2025",
    ["when was santa fuse released"] = "december2025",
    ["when was santa hat trait released"] = "december2025",
    ["when was santa machine released"] = "december2025",
    ["when was santahat trait released"] = "december2025",
    ["when was santas fuse machine released"] = "december2025",
    ["when was santas fuse released"] = "december2025",
    ["when was second fuse machine released"] = "october2025",
    ["when was second fuse released"] = "october2025",
    ["when was secret lucky block released"] = "july2025",
    ["when was shark trait released"] = "june2025",
    ["when was skeleton trait released"] = "september2025",
    ["when was skibidi toilet released"] = "december2025",
    ["when was skibidi trait released"] = "june2025",
    ["when was skibiditoilet released"] = "december2025",
    ["when was snow trait released"] = "june2025",
    ["when was snow weather trait released"] = "june2025",
    ["when was snowy trait released"] = "june2025",
    ["when was solar flare trait released"] = "june2025",
    ["when was spain event trait released"] = "july2026",
    ["when was spain trait released"] = "july2026",
    ["when was spyder elephant released"] = "may2026",
    ["when was spyderelephant released"] = "may2026",
    ["when was starfall trait released"] = "june2025",
    ["when was starfall weather trait released"] = "june2025",
    ["when was steal a brainrot created released"] = "may2025",
    ["when was steal a brainrot game released"] = "may2025",
    ["when was steal a brainrot launched released"] = "may2025",
    ["when was steal a brainrot made released"] = "may2025",
    ["when was steal a brainrot release released"] = "may2025",
    ["when was steal a brainrot released released"] = "may2025",
    ["when was strawberry elephant released"] = "august2025",
    ["when was strawberryelephant released"] = "august2025",
    ["when was strongest brainrot added recently released"] = "august2026",
    ["when was strongest brainrot added released"] = "august2026",
    ["when was strongest brainrot recently released"] = "august2026",
    ["when was strongest brainrot released recently released"] = "august2026",
    ["when was strongest brainrot that was added recently released"] = "august2026",
    ["when was strongest brainrot that was added released"] = "august2026",
    ["when was strongest brainrot that was released recently released"] = "august2026",
    ["when was summer fuse machine released"] = "may2026",
    ["when was summer fuse released"] = "may2026",
    ["when was taco block released"] = "september2025",
    ["when was taco blocks released"] = "november2025",
    ["when was taco lucky block released"] = "september2025",
    ["when was taco merchant npc released"] = "august2026",
    ["when was taco merchant released"] = "august2026",
    ["when was taco shop released"] = "august2026",
    ["when was taco trait released"] = "june2025",
    ["when was taco tuesday lucky block released"] = "september2025",
    ["when was taco tuesday trait released"] = "june2025",
    ["when was the bee lucky block released"] = "august2026",
    ["when was the best visual mutation for meowl released"] = "april2026",
    ["when was the best visual mutation on meowl released"] = "april2026",
    ["when was the headless horseman released"] = "february2026",
    ["when was the john pork released"] = "may2026",
    ["when was the meowl released"] = "october2025",
    ["when was the most op brainrot added recently released"] = "august2026",
    ["when was the most op brainrot added released"] = "august2026",
    ["when was the most op brainrot recently released"] = "august2026",
    ["when was the most op brainrot released"] = "august2026",
    ["when was the most op brainrot released recently released"] = "august2026",
    ["when was the most op brainrot that was added recently released"] = "august2026",
    ["when was the most op brainrot that was added released"] = "august2026",
    ["when was the most op brainrot that was released recently released"] = "august2026",
    ["when was the op brainrot added recently released"] = "august2026",
    ["when was the op brainrot added released"] = "august2026",
    ["when was the op brainrot released"] = "august2026",
    ["when was the op brainrot that was added recently released"] = "august2026",
    ["when was the op brainrot that was added released"] = "august2026",
    ["when was the skibidi toilet released"] = "december2025",
    ["when was the spyder elephant released"] = "may2026",
    ["when was the strawberry elephant released"] = "august2025",
    ["when was third fuse machine released"] = "december2025",
    ["when was third fuse released"] = "december2025",
    ["when was tombstone trait released"] = "october2025",
    ["when was trade machine released"] = "february2026",
    ["when was trade plaza released"] = "june2026",
    ["when was trading machine released"] = "june2026",
    ["when was trait incubator released"] = "april2026",
    ["when was tung tung attack released"] = "june2025",
    ["when was tung tung released"] = "june2025",
    ["when was tung tung trait released"] = "june2025",
    ["when was tung tung zombie released"] = "june2025",
    ["when was valentine fuse released"] = "february2026",
    ["when was valentine machine released"] = "february2026",
    ["when was valentine trait released"] = "february2026",
    ["when was valentines machine released"] = "february2026",
    ["when was visually best mutation for meowl released"] = "april2026",
    ["when was visually best mutation on meowl released"] = "april2026",
    ["when was witch fuse machine released"] = "october2025",
    ["when was witch fuse released"] = "october2025",
    ["when was witch machine released"] = "october2025",
    ["when was witch released"] = "october2025",
    ["when was witching hour released"] = "october2025",
    ["when was witching hour trait released"] = "october2025",
    ["when was yin yang mutation released"] = "september2025",
    ["when was yin yang released"] = "september2025",
    ["when was yinyang mutation released"] = "september2025",
    ["when was yinyang released"] = "september2025",
    ["when was zombie trait released"] = "june2025",
    ["when witch fuse machine released"] = "october2025",
    ["when witch fuse released"] = "october2025",
    ["when witch machine released"] = "october2025",
    ["when witch released"] = "october2025",
    ["when witching hour released"] = "october2025",
    ["when witching hour trait released"] = "october2025",
    ["when yin yang mutation released"] = "september2025",
    ["when yin yang released"] = "september2025",
    ["when yinyang mutation released"] = "september2025",
    ["when yinyang released"] = "september2025",
    ["when zombie trait released"] = "june2025",
    ["where can you get draculino"] = "caveisland",
    ["where can you obtain draculino"] = "caveisland",
    ["where do you get draculino"] = "caveisland",
    ["where go"] = "gym",
    ["where i go"] = "gym",
    ["where is draculino from"] = "caveisland",
    ["where is draculino obtained from"] = "caveisland",
    ["where live"] = "usa",
    ["which 3 brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which 3 brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which brainrot got deleted"] = "tungtungtungsahur",
    ["which brainrot got remove"] = "tungtungtungsahur",
    ["which brainrot got removed"] = "tungtungtungsahur",
    ["which brainrot got reworked"] = "sammynispyderini",
    ["which brainrot was added in todays admin abuse"] = "lupaandlipa",
    ["which brainrot was added in todays update"] = "hydraserpent",
    ["which brainrot was added last saturday"] = "orchidox",
    ["which brainrot was added last week"] = "orchidox",
    ["which brainrot was added today"] = "hydraserpent",
    ["which brainrot was deleted"] = "tungtungtungsahur",
    ["which brainrot was released last saturday"] = "orchidox",
    ["which brainrot was released last week"] = "orchidox",
    ["which brainrot was removed"] = "tungtungtungsahur",
    ["which brainrot was reworked"] = "sammynispyderini",
    ["which brainrots got deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots got remove"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots got removed"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots got reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which brainrots were deleted"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots were removed"] = "tungtungtungsahurcrocidilopenisini",
    ["which brainrots were reworked"] = "sammynispyderiniunclitosamitogattatinonyanino",
    ["which egg can you get dragon cannelloni from"] = "dragonegg",
    ["which egg can you obtain dragon cannelloni from"] = "dragonegg",
    ["which egg is dragon cannelloni from"] = "dragonegg",
    ["which island is draculino from"] = "caveisland",
    ["which mutation looks best on meowl"] = "cyber",
    ["which mutation looks the best on meowl"] = "cyber",
    ["which snake brainrot is in the game"] = "hydraserpent",
    ["which snake brainrot was added"] = "hydraserpent",
    ["which snake brainrot was added in todays update"] = "hydraserpent",
    ["which snake brainrot was added today"] = "hydraserpent",
    ["white"] = "white",
    ["who do i hate"] = "secretlokii",
    ["who do i hate most"] = "secretlokii",
    ["who do i hate the most"] = "secretlokii",
    ["who does sammy hate"] = "secretlokii",
    ["who does sammy hate most"] = "secretlokii",
    ["who does sammy hate the most"] = "secretlokii",
    ["who hate"] = "secretlokii",
    ["who hate most"] = "secretlokii",
    ["who hates"] = "secretlokii",
    ["who hates most"] = "secretlokii",
    ["who host admin abuse"] = "jandel",
    ["who hosted admin abuse"] = "jandel",
    ["who is a competitive player at valorant"] = "sammy",
    ["who is a competitive valorant player"] = "sammy",
    ["who is better than loki"] = "jandel",
    ["who is better than lokii"] = "jandel",
    ["who is better than luckymatg"] = "jandel",
    ["who is better than secretloki"] = "jandel",
    ["who is better than secretlokii"] = "jandel",
    ["who is competitive player at valorant"] = "sammy",
    ["who is my friend that is a youtuber that has food in his name"] = "steak",
    ["who is my friend that is a youtuber that has food in name"] = "steak",
    ["who is my friend that is a youtuber with food"] = "steak",
    ["who is my friend that is a youtuber with food in his name"] = "steak",
    ["who is my friend that is a youtuber with food in name"] = "steak",
    ["who is my friend youtuber that has food in his name"] = "steak",
    ["who is my friend youtuber with food in his name"] = "steak",
    ["who is my least favorite person"] = "secretlokii",
    ["who is my least favourite person"] = "secretlokii",
    ["who is my youtuber friend that has food in his name"] = "steak",
    ["who is my youtuber friend that has food in name"] = "steak",
    ["who is my youtuber friend with food"] = "steak",
    ["who is my youtuber friend with food in his name"] = "steak",
    ["who is my youtuber friend with food in name"] = "steak",
    ["who is sammy least favorite person"] = "secretlokii",
    ["who is sammy least favourite person"] = "secretlokii",
    ["who is sammys least favorite person"] = "secretlokii",
    ["who is sammys least favourite person"] = "secretlokii",
    ["who is the person better than loki"] = "jandel",
    ["who is the person better than lokii"] = "jandel",
    ["who is the person better than luckymatg"] = "jandel",
    ["who is the person better than secretloki"] = "jandel",
    ["who is the person better than secretlokii"] = "jandel",
    ["who is the person worse than jandel"] = "secretlokii",
    ["who is the person worser than jandel"] = "secretlokii",
    ["who is the worst person"] = "secretlokii",
    ["who is the youtuber friend with food in his name"] = "steak",
    ["who is the youtuber that has food in his name"] = "steak",
    ["who is the youtuber with food in his name"] = "steak",
    ["who is worse than jandel"] = "secretlokii",
    ["who is worser than jandel"] = "secretlokii",
    ["who is worst person"] = "secretlokii",
    ["who plays competitive valorant"] = "sammy",
    ["who plays valorant competitively"] = "sammy",
    ["winterhour"] = "winterhour",
    ["witch"] = "witchfuse",
    ["witch date"] = "october2025",
    ["witch day"] = "11",
    ["witch fuse"] = "witchfuse",
    ["witch fuse date"] = "october2025",
    ["witch fuse day"] = "11",
    ["witch fuse machine"] = "witchfuse",
    ["witch fuse machine date"] = "october2025",
    ["witch fuse machine day"] = "11",
    ["witch fuse machine month"] = "october",
    ["witch fuse machine release"] = "october2025",
    ["witch fuse machine release date"] = "october2025",
    ["witch fuse machine release day"] = "11",
    ["witch fuse machine release month"] = "october",
    ["witch fuse machine release year"] = "2025",
    ["witch fuse machine year"] = "2025",
    ["witch fuse month"] = "october",
    ["witch fuse release"] = "october2025",
    ["witch fuse release date"] = "october2025",
    ["witch fuse release day"] = "11",
    ["witch fuse release month"] = "october",
    ["witch fuse release year"] = "2025",
    ["witch fuse year"] = "2025",
    ["witch machine"] = "witchfuse",
    ["witch machine date"] = "october2025",
    ["witch machine day"] = "11",
    ["witch machine month"] = "october",
    ["witch machine release"] = "october2025",
    ["witch machine release date"] = "october2025",
    ["witch machine release day"] = "11",
    ["witch machine release month"] = "october",
    ["witch machine release year"] = "2025",
    ["witch machine year"] = "2025",
    ["witch month"] = "october",
    ["witch release"] = "october2025",
    ["witch release date"] = "october2025",
    ["witch release day"] = "11",
    ["witch release month"] = "october",
    ["witch release year"] = "2025",
    ["witch year"] = "2025",
    ["witchfuse"] = "witchfuse",
    ["witching hour"] = "witchinghour",
    ["witching hour date"] = "october2025",
    ["witching hour month"] = "october",
    ["witching hour release"] = "october2025",
    ["witching hour release date"] = "october2025",
    ["witching hour release month"] = "october",
    ["witching hour release year"] = "2025",
    ["witching hour trait"] = "witchinghour",
    ["witching hour trait date"] = "october2025",
    ["witching hour trait month"] = "october",
    ["witching hour trait release"] = "october2025",
    ["witching hour trait release date"] = "october2025",
    ["witching hour trait release month"] = "october",
    ["witching hour trait release year"] = "2025",
    ["witching hour trait year"] = "2025",
    ["witching hour year"] = "2025",
    ["witchinghour"] = "witchinghour",
    ["worse garden"] = "1speedkeyboardescape",
    ["worse grow"] = "1speedkeyboardescape",
    ["worse jandel"] = "secretlokii",
    ["worse than grow a garden"] = "1speedkeyboardescape",
    ["worse than growagarden"] = "1speedkeyboardescape",
    ["worse than jandel"] = "secretlokii",
    ["worser garden"] = "1speedkeyboardescape",
    ["worser grow"] = "1speedkeyboardescape",
    ["worser jandel"] = "secretlokii",
    ["worser than grow a garden"] = "1speedkeyboardescape",
    ["worser than growagarden"] = "1speedkeyboardescape",
    ["worser than jandel"] = "secretlokii",
    ["worst"] = "banditoaxolito",
    ["worst brainrot"] = "banditoaxolito",
    ["worst enemy"] = "jandel",
    ["worst in game"] = "banditoaxolito",
    ["worst person"] = "secretlokii",
    ["worst person is secretlokii"] = "secretlokii",
    ["worst rng"] = "banditoaxolito",
    ["worst taco merchant"] = "burritobat",
    ["year began making games"] = "2013",
    ["year began making games release year"] = "2013",
    ["year began making games year"] = "2013",
    ["year born"] = "2002",
    ["year headless horseman"] = "2026",
    ["year i began making games"] = "2013",
    ["year i began making games in roblox"] = "2013",
    ["year i began making games in roblox release year"] = "2013",
    ["year i began making games in roblox year"] = "2013",
    ["year i began making games on roblox"] = "2013",
    ["year i began making games on roblox release year"] = "2013",
    ["year i began making games on roblox year"] = "2013",
    ["year i began making games release year"] = "2013",
    ["year i began making games year"] = "2013",
    ["year i started making games"] = "2013",
    ["year i started making games in roblox"] = "2013",
    ["year i started making games in roblox release year"] = "2013",
    ["year i started making games in roblox year"] = "2013",
    ["year i started making games on roblox"] = "2013",
    ["year i started making games on roblox release year"] = "2013",
    ["year i started making games on roblox year"] = "2013",
    ["year i started making games release year"] = "2013",
    ["year i started making games year"] = "2013",
    ["year john pork"] = "2026",
    ["year making games"] = "2013",
    ["year meowl"] = "2025",
    ["year sammy began making games"] = "2013",
    ["year sammy began making games on roblox"] = "2013",
    ["year sammy began making games on roblox release year"] = "2013",
    ["year sammy began making games on roblox year"] = "2013",
    ["year sammy began making games release year"] = "2013",
    ["year sammy began making games year"] = "2013",
    ["year sammy started making games"] = "2013",
    ["year sammy started making games on roblox"] = "2013",
    ["year sammy started making games on roblox release year"] = "2013",
    ["year sammy started making games on roblox year"] = "2013",
    ["year sammy started making games release year"] = "2013",
    ["year sammy started making games year"] = "2013",
    ["year skibidi toilet"] = "2025",
    ["year spyder elephant"] = "2026",
    ["year started making games"] = "2013",
    ["year started making games release year"] = "2013",
    ["year started making games year"] = "2013",
    ["year strawberry elephant"] = "2025",
    ["year when headless horseman released"] = "2026",
    ["year when john pork released"] = "2026",
    ["year when meowl released"] = "2025",
    ["year when skibidi toilet released"] = "2025",
    ["year when spyder elephant released"] = "2026",
    ["year when strawberry elephant released"] = "2025",
    ["yellow"] = "yellow",
    ["yin yang"] = "yinyang",
    ["yin yang date"] = "september2025",
    ["yin yang day"] = "27",
    ["yin yang month"] = "september",
    ["yin yang mutation"] = "yinyang",
    ["yin yang mutation date"] = "september2025",
    ["yin yang mutation day"] = "27",
    ["yin yang mutation month"] = "september",
    ["yin yang mutation release"] = "september2025",
    ["yin yang mutation release date"] = "september2025",
    ["yin yang mutation release day"] = "27",
    ["yin yang mutation release month"] = "september",
    ["yin yang mutation release year"] = "2025",
    ["yin yang mutation year"] = "2025",
    ["yin yang release"] = "september2025",
    ["yin yang release date"] = "september2025",
    ["yin yang release day"] = "27",
    ["yin yang release month"] = "september",
    ["yin yang release year"] = "2025",
    ["yin yang year"] = "2025",
    ["yinyang"] = "yinyang",
    ["yinyang date"] = "september2025",
    ["yinyang day"] = "27",
    ["yinyang month"] = "september",
    ["yinyang mutation"] = "yinyang",
    ["yinyang mutation date"] = "september2025",
    ["yinyang mutation day"] = "27",
    ["yinyang mutation month"] = "september",
    ["yinyang mutation release"] = "september2025",
    ["yinyang mutation release date"] = "september2025",
    ["yinyang mutation release day"] = "27",
    ["yinyang mutation release month"] = "september",
    ["yinyang mutation release year"] = "2025",
    ["yinyang mutation year"] = "2025",
    ["yinyang release"] = "september2025",
    ["yinyang release date"] = "september2025",
    ["yinyang release day"] = "27",
    ["yinyang release month"] = "september",
    ["yinyang release year"] = "2025",
    ["yinyang year"] = "2025",
    ["youtuber food"] = "steak",
    ["youtuber food in name"] = "steak",
    ["youtuber food name"] = "steak",
    ["youtuber friend food"] = "steak",
    ["youtuber friend that has food in his name"] = "steak",
    ["youtuber friend that has food in name"] = "steak",
    ["youtuber friend with food"] = "steak",
    ["youtuber friend with food in his name"] = "steak",
    ["youtuber friend with food in name"] = "steak",
    ["youtuber that has food in his name"] = "steak",
    ["youtuber with food"] = "steak",
    ["youtuber with food in his name"] = "steak",
    ["youtuber with food in name"] = "steak",
    ["zombie"] = "zombie",
    ["zombie trait"] = "tungtung",
    ["zombie trait date"] = "june2025",
    ["zombie trait month"] = "june",
    ["zombie trait release"] = "june2025",
    ["zombie trait release date"] = "june2025",
    ["zombie trait release month"] = "june",
    ["zombie trait release year"] = "2025",
    ["zombie trait year"] = "2025",
}
local RiddleDates = {
    ["1 year event trait"] = {date = "may2026", day = "", month = "may", year = "2026"},
    ["1 year trait"] = {date = "may2026", day = "", month = "may", year = "2026"},
    ["10 billion trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["10 billion visits trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["10b trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["1st craft"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["1st craft machine"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["1st fuse"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["1st fuse machine"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["1st lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["1st machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["1st machine added"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["2026 trait"] = {date = "december2025", day = "", month = "december", year = "2025"},
    ["26 trait"] = {date = "december2025", day = "", month = "december", year = "2025"},
    ["2nd fuse"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["2nd fuse machine"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["3rd fuse"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["3rd fuse machine"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["4th fuse"] = {date = "march2026", day = "7", month = "march", year = "2026"},
    ["4th fuse machine"] = {date = "march2026", day = "7", month = "march", year = "2026"},
    ["4th of july trait"] = {date = "july2025", day = "4", month = "july", year = "2025"},
    ["5th fuse"] = {date = "may2026", day = "23", month = "may", year = "2026"},
    ["5th fuse machine"] = {date = "may2026", day = "23", month = "may", year = "2026"},
    ["admin machine"] = {date = "november2025", day = "29", month = "november", year = "2025"},
    ["anniversary trait"] = {date = "may2026", day = "", month = "may", year = "2026"},
    ["asteroid trait"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["bee block"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee lucky"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee lucky block"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee lucky block brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee lucky block in sab"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee lucky block in the game"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee lucky blocks"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee shop brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bee update brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best bee brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best bee lucky block brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best bee shop brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot added last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot added last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot from bee lucky block"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot in bee lucky block"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot released last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot released last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot that was added last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot that was added last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot that was released last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best brainrot that was released last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["best looking mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["best looking mutation on meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["best mutation for meowl visually"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["best visual mutation for favorite brainrot"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["best visual mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["best visual mutation for my favorite brainrot"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["best visual mutation on meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["bloodrot"] = {date = "june2025", day = "7", month = "june", year = "2025"},
    ["bloodrot mutation"] = {date = "june2025", day = "7", month = "june", year = "2025"},
    ["blue egg trait"] = {date = "april2026", day = "", month = "april", year = "2026"},
    ["bombardiro trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["brainrot added last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot added last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot god lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["brainrot released last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot released last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot that was added last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot that was added last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot that was released last saturday"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["brainrot that was released last week"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["bruno mars concert trait"] = {date = "january2026", day = "17", month = "january", year = "2026"},
    ["bruno mars trait"] = {date = "january2026", day = "17", month = "january", year = "2026"},
    ["bubblegum machine"] = {date = "july2025", day = "18", month = "july", year = "2025"},
    ["bubblegum trait"] = {date = "july2025", day = "18", month = "july", year = "2025"},
    ["bull trait"] = {date = "july2026", day = "25", month = "july", year = "2026"},
    ["bunny ears"] = {date = "april2026", day = "", month = "april", year = "2026"},
    ["bunny ears trait"] = {date = "april2026", day = "", month = "april", year = "2026"},
    ["candy mutation"] = {date = "july2025", day = "5", month = "july", year = "2025"},
    ["chipso"] = {date = "october2025", day = "21", month = "october", year = "2025"},
    ["chipso and queso"] = {date = "october2025", day = "21", month = "october", year = "2025"},
    ["chipso queso"] = {date = "october2025", day = "21", month = "october", year = "2025"},
    ["chocolate trait"] = {date = "february2026", day = "", month = "february", year = "2026"},
    ["comet struck"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["comet struck trait"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["concert trait"] = {date = "january2026", day = "17", month = "january", year = "2026"},
    ["crab rave"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["crab rave trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["craft"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["craft machine"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["crystal mutation"] = {date = "july2026", day = "25", month = "july", year = "2026"},
    ["cupid fuse"] = {date = "february2026", day = "7", month = "february", year = "2026"},
    ["cupid machine"] = {date = "february2026", day = "7", month = "february", year = "2026"},
    ["current fuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["cursed"] = {date = "january2026", day = "3", month = "january", year = "2026"},
    ["cursed mutation"] = {date = "january2026", day = "3", month = "january", year = "2026"},
    ["cyber"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["cyber admin"] = {date = "april2026", day = "25", month = "april", year = "2026"},
    ["cyber admin machine"] = {date = "april2026", day = "25", month = "april", year = "2026"},
    ["cyber craft"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["cyber craft machine"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["cyber mutation"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["cybercraft"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["divine admin"] = {date = "february2026", day = "28", month = "february", year = "2026"},
    ["divine admin machine"] = {date = "february2026", day = "28", month = "february", year = "2026"},
    ["divine fuse"] = {date = "march2026", day = "7", month = "march", year = "2026"},
    ["divine fuse machine"] = {date = "march2026", day = "7", month = "march", year = "2026"},
    ["divine halo trait"] = {date = "february2026", day = "", month = "february", year = "2026"},
    ["divine mutation"] = {date = "february2026", day = "21", month = "february", year = "2026"},
    ["duels"] = {date = "january2026", day = "10", month = "january", year = "2026"},
    ["duels machine"] = {date = "january2026", day = "10", month = "january", year = "2026"},
    ["duels update"] = {date = "january2026", day = "10", month = "january", year = "2026"},
    ["egg incubator"] = {date = "april2026", day = "4", month = "april", year = "2026"},
    ["egg trait incubator"] = {date = "april2026", day = "4", month = "april", year = "2026"},
    ["extinct event trait"] = {date = "september2025", day = "13", month = "september", year = "2025"},
    ["extinct trait"] = {date = "september2025", day = "13", month = "september", year = "2025"},
    ["fat sammy"] = {date = "august2025", day = "12", month = "august", year = "2025"},
    ["fat sammy npc"] = {date = "august2025", day = "12", month = "august", year = "2025"},
    ["fav mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["favorite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["favourite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["fifth fuse"] = {date = "may2026", day = "23", month = "may", year = "2026"},
    ["fifth fuse machine"] = {date = "may2026", day = "23", month = "may", year = "2026"},
    ["fire trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["firework trait"] = {date = "july2025", day = "4", month = "july", year = "2025"},
    ["first craft"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["first craft machine"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["first fuse"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["first fuse machine"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["first lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["first machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["first machine added"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["first machine added to sab"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["first machine added to the game"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["first machine in game"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["first machine in sab"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["first machine in the game"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["fourth fuse"] = {date = "march2026", day = "7", month = "march", year = "2026"},
    ["fourth fuse machine"] = {date = "march2026", day = "7", month = "march", year = "2026"},
    ["fuse"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["fuse machine"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["fuse machine original"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["fuse machine return"] = {date = "january2026", day = "24", month = "january", year = "2026"},
    ["fuse return"] = {date = "january2026", day = "24", month = "january", year = "2026"},
    ["galaxy"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["galaxy mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["game created"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["game launched"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["game made"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["game release"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["game released"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["glitch trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["glitched trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["granny trait"] = {date = "march2026", day = "21", month = "march", year = "2026"},
    ["green egg trait"] = {date = "april2026", day = "", month = "april", year = "2026"},
    ["halo trait"] = {date = "february2026", day = "", month = "february", year = "2026"},
    ["headlesshorseman"] = {date = "february2026", day = "1", month = "february", year = "2026"},
    ["incubator machine"] = {date = "april2026", day = "4", month = "april", year = "2026"},
    ["indonesia trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["jack o lantern trait"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["jackolantern trait"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["johnpork"] = {date = "may2026", day = "1", month = "may", year = "2026"},
    ["last craft"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["last craft machine"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["last fuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["last fuse machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["latest craft"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["latest craft machine"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["latest fuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["latest fuse machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["lava mutation"] = {date = "july2025", day = "25", month = "july", year = "2025"},
    ["los taco block"] = {date = "november2025", day = "18", month = "november", year = "2025"},
    ["los taco blocks"] = {date = "november2025", day = "18", month = "november", year = "2025"},
    ["los trader"] = {date = "june2026", day = "11", month = "june", year = "2026"},
    ["los traders"] = {date = "june2026", day = "11", month = "june", year = "2026"},
    ["lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["lucky blocks"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["lucky pot trait"] = {date = "january2026", day = "", month = "january", year = "2026"},
    ["lucky trait"] = {date = "january2026", day = "", month = "january", year = "2026"},
    ["meowl"] = {date = "october2025", day = "1", month = "october", year = "2025"},
    ["molten mutation"] = {date = "july2025", day = "25", month = "july", year = "2025"},
    ["most op bee lucky block brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot from bee lucky block"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot in bee lucky block"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot released"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot that was added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot that was added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot that was released"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["most op brainrot that was released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["my fav mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["my favorite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["my favorite visual mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["my favourite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["my favourite visual mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["mythic lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["new year 2026 trait"] = {date = "december2025", day = "", month = "december", year = "2025"},
    ["new year fuse"] = {date = "december2025", day = "31", month = "december", year = "2025"},
    ["new year machine"] = {date = "december2025", day = "31", month = "december", year = "2025"},
    ["new years machine"] = {date = "december2025", day = "31", month = "december", year = "2025"},
    ["newest craft"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["newest craft machine"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["newest fuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["newest fuse machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["nyan cat"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["nyan cat trait"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["nyan trait"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["nyancat"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["og fuse machine"] = {date = "january2026", day = "24", month = "january", year = "2026"},
    ["oldest fuse"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["oldest machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["op brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot that was added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot that was added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["op brainrot that was released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["orange egg trait"] = {date = "orangeegg", day = "", month = "april", year = "2026"},
    ["orchideon"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["orchidox"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["original craft machine"] = {date = "september2025", day = "6", month = "september", year = "2025"},
    ["original fuse"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["original fuse machine"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["original lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["original machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["overall fav mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["overall favorite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["overall favourite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["phantom mutation"] = {date = "june2026", day = "13", month = "june", year = "2026"},
    ["pink egg trait"] = {date = "april2026", day = "", month = "april", year = "2026"},
    ["queso"] = {date = "october2025", day = "21", month = "october", year = "2025"},
    ["radioactive"] = {date = "november2025", day = "15", month = "november", year = "2025"},
    ["radioactive mutation"] = {date = "november2025", day = "15", month = "november", year = "2025"},
    ["rain trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["rain weather trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["rainbow fuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["rainbow fuse machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["rainbow machine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["rainbowfuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["rainbowmachine"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["recent fuse"] = {date = "june2025", day = "21", month = "june", year = "2025"},
    ["reindeer trait"] = {date = "december2025", day = "", month = "december", year = "2025"},
    ["revived fuse machine"] = {date = "january2026", day = "24", month = "january", year = "2026"},
    ["rip tombstone"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["rip tombstone trait"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["rng machine"] = {date = "august2026", day = "8", month = "august", year = "2026"},
    ["sab created"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["sab game release"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["sab launched"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["sab made"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["sab release"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["sab released"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["sammy fav mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["sammy favorite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["sammy favorite visual mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["sammy favourite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["sammys favorite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["sammys favorite visual mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["sammys favourite mutation"] = {date = "august2025", day = "23", month = "august", year = "2025"},
    ["santa fuse"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["santa hat trait"] = {date = "december2025", day = "", month = "december", year = "2025"},
    ["santa machine"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["santahat trait"] = {date = "december2025", day = "", month = "december", year = "2025"},
    ["santas fuse"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["santas fuse machine"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["second fuse"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["second fuse machine"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["secret lucky block"] = {date = "july2025", day = "12", month = "july", year = "2025"},
    ["shark trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["skeleton trait"] = {date = "september2025", day = "13", month = "september", year = "2025"},
    ["skibidi trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["skibiditoilet"] = {date = "december2025", day = "1", month = "december", year = "2025"},
    ["snow trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["snow weather trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["snowy trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["solar flare trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["spain event trait"] = {date = "july2026", day = "25", month = "july", year = "2026"},
    ["spain trait"] = {date = "july2026", day = "25", month = "july", year = "2026"},
    ["spyderelephant"] = {date = "may2026", day = "1", month = "may", year = "2026"},
    ["starfall trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["starfall weather trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["steal a brainrot created"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["steal a brainrot game"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["steal a brainrot launched"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["steal a brainrot made"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["steal a brainrot release"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["steal a brainrot released"] = {date = "may2025", day = "16", month = "may", year = "2025"},
    ["strawberryelephant"] = {date = "august2025", day = "1", month = "august", year = "2025"},
    ["strongest brainrot added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["strongest brainrot added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["strongest brainrot recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["strongest brainrot released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["strongest brainrot that was added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["strongest brainrot that was added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["strongest brainrot that was released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["summer fuse"] = {date = "may2026", day = "23", month = "may", year = "2026"},
    ["summer fuse machine"] = {date = "may2026", day = "23", month = "may", year = "2026"},
    ["taco block"] = {date = "september2025", day = "16", month = "september", year = "2025"},
    ["taco blocks"] = {date = "november2025", day = "18", month = "november", year = "2025"},
    ["taco lucky block"] = {date = "september2025", day = "16", month = "september", year = "2025"},
    ["taco merchant"] = {date = "august2026", day = "18", month = "august", year = "2026"},
    ["taco merchant npc"] = {date = "august2026", day = "18", month = "august", year = "2026"},
    ["taco shop"] = {date = "august2026", day = "18", month = "august", year = "2026"},
    ["taco trait"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["taco tuesday lucky block"] = {date = "september2025", day = "16", month = "september", year = "2025"},
    ["taco tuesday trait"] = {date = "june2025", day = "28", month = "june", year = "2025"},
    ["the best visual mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["the best visual mutation on meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["the most op brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot that was added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot that was added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the most op brainrot that was released recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the op brainrot"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the op brainrot added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the op brainrot added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the op brainrot that was added"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["the op brainrot that was added recently"] = {date = "august2026", day = "22", month = "august", year = "2026"},
    ["third fuse"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["third fuse machine"] = {date = "december2025", day = "6", month = "december", year = "2025"},
    ["tombstone trait"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["trade machine"] = {date = "february2026", day = "21", month = "february", year = "2026"},
    ["trade plaza"] = {date = "june2026", day = "13", month = "june", year = "2026"},
    ["trading machine"] = {date = "june2026", day = "11", month = "june", year = "2026"},
    ["trait incubator"] = {date = "april2026", day = "4", month = "april", year = "2026"},
    ["tung tung"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["tung tung attack"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["tung tung trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["tung tung zombie"] = {date = "june2025", day = "", month = "june", year = "2025"},
    ["valentine fuse"] = {date = "february2026", day = "14", month = "february", year = "2026"},
    ["valentine machine"] = {date = "february2026", day = "14", month = "february", year = "2026"},
    ["valentine trait"] = {date = "february2026", day = "", month = "february", year = "2026"},
    ["valentines machine"] = {date = "february2026", day = "14", month = "february", year = "2026"},
    ["visually best mutation for meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["visually best mutation on meowl"] = {date = "april2026", day = "18", month = "april", year = "2026"},
    ["witch"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["witch fuse"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["witch fuse machine"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["witch machine"] = {date = "october2025", day = "11", month = "october", year = "2025"},
    ["witching hour"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["witching hour trait"] = {date = "october2025", day = "", month = "october", year = "2025"},
    ["yin yang"] = {date = "september2025", day = "27", month = "september", year = "2025"},
    ["yin yang mutation"] = {date = "september2025", day = "27", month = "september", year = "2025"},
    ["yinyang"] = {date = "september2025", day = "27", month = "september", year = "2025"},
    ["yinyang mutation"] = {date = "september2025", day = "27", month = "september", year = "2025"},
    ["zombie trait"] = {date = "june2025", day = "", month = "june", year = "2025"},
}

-- Current answers and aliases.
RiddleDatabase["my age"] = "24"
RiddleDatabase["year i was born"] = RiddleDatabase["birth year"]
RiddleDatabase["year i was born in"] = RiddleDatabase["birth year"]
RiddleDatabase["my birth year"] = RiddleDatabase["birth year"]
RiddleDatabase["my year of birth"] = RiddleDatabase["birth year"]
RiddleDatabase["year of my birth"] = RiddleDatabase["birth year"]
RiddleDatabase["what year was i born"] = RiddleDatabase["birth year"]
RiddleDatabase["what year i was born"] = RiddleDatabase["birth year"]
RiddleDatabase["which year was i born"] = RiddleDatabase["birth year"]
RiddleDatabase["my name"] = "Sammy"
RiddleDatabase["my favorite color"] = RiddleDatabase["favorite color"] or "blue"
RiddleDatabase["my color of my avatar"] = "red"
RiddleDatabase["my avatar color"] = "red"

-- Corrected general answers and personal-question aliases.
local RiddleFactRevision = "2026-10-10-strawberry-headless-nova-dragonskeletonini-meowl-eclipse-reaper-noob-lavacca-money-taco-steak-birthdate-series2-griffin"
local RiddleFactKeys = {}
local RiddleRarityFactRevision = "2026-10-10-dragon-secret-rarities"
local RiddleRarityFactKeys = {}
local RiddleBirthDateFactRevision = "2026-10-10-birth-date-day-month-birth-date-full"
local RiddleBirthDateFactKeys = {}
local RiddleLuckyBlockFactRevision = "2026-10-10-skull-new-lucky-block-dragonskeletonini"
local RiddleLuckyBlockFactKeys = {}
local function registerRiddleFact(question, answer, keyset)
    for _, prefix in ipairs({"", "the ", "what ", "what is ", "what is the ", "whats ", "whats the ",
        "which ", "which is ", "which is the ", "tell me ", "tell me the ", "the answer to "}) do
        local alias = prefix .. question
        RiddleDatabase[alias] = answer
        RiddleFactKeys[alias] = true
        if keyset then keyset[alias] = true end
    end
end
registerRiddleFact("best minifigure thats new in series 2", "griffin")
registerRiddleFact("best minifigure that is new in series 2", "griffin")
registerRiddleFact("best minifigure in series 2 dlc", "griffin")
for _, name in ipairs({"dragonskeletonini", "dragon skeletonini", "dragoncannelloni", "dragon cannelloni"}) do
    for _, question in ipairs({name .. " rarity", name .. "s rarity", "rarity of " .. name,
        "rarity is " .. name, name .. " category", name .. "s category", "category of " .. name, "category is " .. name}) do
        registerRiddleFact(question, "secret", RiddleRarityFactKeys)
    end
end
for _, subject in ipairs({"best brainrot", "strongest brainrot", "most op brainrot", "op brainrot", "top brainrot"}) do
    for _, suffix in ipairs({"", " in game", " in the game", " in", " in the"}) do
        registerRiddleFact(subject .. suffix, "strawberryelephant")
    end
end
registerRiddleFact("most op", "strawberryelephant")
for _, suffix in ipairs({"", " in game", " in the game"}) do
    registerRiddleFact("rarest brainrot" .. suffix, "headlesshorseman")
end
for _, question in ipairs({"cat name", "cats name", "my cat", "my cat name", "my cats name",
    "name of my cat", "my cat called", "sammy cat", "sammy cat name", "sammy cats name",
    "sammys cat", "sammys cat name", "sammys cats name", "name of sammy cat", "name of sammys cat"}) do
    registerRiddleFact(question, "nova")
end
for _, question in ipairs({"my favorite brainrot", "my favourite brainrot", "sammy favorite brainrot",
    "sammy favourite brainrot", "sammys favorite brainrot", "sammys favourite brainrot",
    "favorite brainrot of sammy", "favourite brainrot of sammy"}) do
    registerRiddleFact(question, "meowl")
end
for _, question in ipairs({"new mutation that was added recently", "new mutation added recently",
    "mutation that was added recently", "mutation added recently", "recent mutation",
    "recently added mutation", "latest mutation added recently"}) do
    registerRiddleFact(question, "eclipse")
end
for _, subject in ipairs({"new base", "name of new base", "name of the new base"}) do
    for _, suffix in ipairs({" added today", " that was added today", " added in today update",
        " added in todays update", " that was added in todays update", " added in today admin abuse",
        " added in todays admin abuse", " that was added in todays admin abuse", " in today update",
        " in todays update", " in today admin abuse", " in todays admin abuse", " today"}) do
        registerRiddleFact(subject .. suffix, "reaperbase")
    end
end
for _, question in ipairs({"worst brainrot", "worst brainrot in sab", "worst brainrot in steal a brainrot",
    "worst brainrot in the game", "most hated brainrot", "most hated brainrot in sab",
    "most hated brainrot in steal a brainrot", "most hated brainrot in the game"}) do
    registerRiddleFact(question, question:find("hated") and "lavaccasaturnosaturnita" or "noobinipizzanini")
end
for _, question in ipairs({"brainrot that makes the most money", "brainrot that makes the most money s",
    "brainrot that makes the most money per second", "brainrot makes the most money",
    "brainrot makes the most money s", "brainrot makes the most money per second", "most money per second brainrot",
    "highest money per second brainrot", "highest income brainrot"}) do
    registerRiddleFact(question, "strawberryelephant")
end
for _, question in ipairs({"first trait", "my first trait", "first trait in sab", "first trait in steal a brainrot"}) do
    registerRiddleFact(question, "taco")
end
for _, question in ipairs({"favorite youtuber of sammy", "favourite youtuber of sammy",
    "my favorite youtuber", "my favourite youtuber", "sammys favorite youtuber",
    "sammys favourite youtuber", "least favorite youtuber of sammy",
    "least favourite youtuber of sammy", "sammy least favorite youtuber",
    "sammy least favourite youtuber", "sammys least favorite youtuber", "sammys least favourite youtuber", "favorite food of steak", "favourite food of steak"}) do
    registerRiddleFact(question, "steak")
end
for _, question in ipairs({"best youtubers brainrot in game", "best youtubers brainrot in the game",
    "best yts brainrot in game", "best yts brainrot in the game", "best youtubers brainrot"}) do
    registerRiddleFact(question, "steakinifattini")
end
-- Personal riddles use the day number for birth date, and month + day for birthday.
local birthdayRecord = {date = RiddleDatabase["birthday"], day = RiddleDatabase["birth day"],
    month = RiddleDatabase["birth month"], year = RiddleDatabase["birth year"]}
local birthRecord = {date = birthdayRecord.day, day = birthdayRecord.day,
    month = birthdayRecord.month, year = birthdayRecord.year}
for _, subject in ipairs({"birth", "my birth", "birth date", "my birth date", "birthdate", "my birthdate",
    "birthday", "my birthday", "date of birth", "my date of birth", "sammy birth", "sammys birth",
    "sammy birthday", "sammys birthday", "sammy birthdate", "sammys birthdate",
    "sammy birth date", "sammys birth date", "sammy date of birth", "sammys date of birth",
    "birth date of sammy", "birthdate of sammy", "date of birth of sammy"}) do
    local fullBirthday = subject:find("birthday", 1, true) ~= nil
    local record = fullBirthday and birthdayRecord or birthRecord
    local correctedKeys = not fullBirthday and RiddleBirthDateFactKeys or nil
    RiddleDates[subject] = record
    registerRiddleFact(subject, record.date, correctedKeys)
    for _, field in ipairs({"date", "day", "month", "year"}) do
        registerRiddleFact(subject .. " " .. field, record[field], field == "date" and correctedKeys or nil)
    end
end
-- Yarik's "my month birth date" wording requests the full month + day.
for _, subject in ipairs({"my month birth", "my month birth date", "my month birthdate",
    "sammy month birth", "sammys month birth", "sammy month birth date", "sammys month birth date"}) do
    RiddleDates[subject] = birthdayRecord
    registerRiddleFact(subject, birthdayRecord.date, RiddleBirthDateFactKeys)
end
registerRiddleFact("when was i born", birthdayRecord.date)
registerRiddleFact("when is my birthday", birthdayRecord.date)
registerRiddleFact("when is sammys birthday", birthdayRecord.date)

-- Keep PC uppercase for the code box.
for _, question in ipairs({
    "my device", "device i am on", "device im on", "device i use",
    "what device am i on", "what device do i use", "what device i am on",
    "what device im on", "what device i use", "which device am i on",
    "which device do i use", "which device i use", "device sammy is on",
    "device sammy uses", "sammys device", "sammy device",
    "what device is sammy on", "what device does sammy use",
    "which device is sammy on", "which device does sammy use",
}) do
    RiddleDatabase[question] = "PC"
end

-- Current brainrot answers.
local CurrentBrainrotFactRevision = "2026-10-08-phoenix-eclipse"
local CurrentBrainrotFactKeys = {}
local CurrentBrainrotQuestions = {
    "the best brainrot added today",
    "the best brainrot added in this update",
    "the best brainrot added in this admin abuse",
    "the op brainrot added today",
    "the op brainrot added in this update",
    "the op brainrot added in this admin abuse",
    "what brainrot was added today",
    "what brainrot was added in this update",
    "which brainrot was added today",
    "which brainrot was added in this update",
    "new op brainrot added today",
    "new op brainrot that we added today",
    "new op brainrot we added today",
    "new op brainrot that was added today",
    "new op brainrot added in this update",
    "most op brainrot added today",
    "most op brainrot added in this update",
    "best brainrot that was added today",
    "best brainrot added today",
    "best brainrot added in today update",
    "best brainrot added in today's update",
    "best brainrot added in todays update",
    "best brainrot added in this update",
    "best brainrot added in todays admin abuse",
    "best brainrot added in today's admin abuse",
    "best brainrot added in this admin abuse",
    "best brainrot that was added in this admin abuse",
    "best brainrot in this admin abuse",
    "best brainrot in todays admin abuse",
    "op brainrot added today",
    "op brainrot that we added today",
    "op brainrot we added today",
    "op brainrot that was added today",
    "most op brainrot that we added today",
    "op brainrot added in today update",
    "op brainrot added in todays update",
    "op brainrot added in this update",
    "op brainrot added in todays admin abuse",
    "op brainrot added in this admin abuse",
    "op brainrot in todays admin abuse",
    "op brainrot in this admin abuse",
    "op brainrot in this update",
    "brainrot added today",
    "brainrot added in this update",
    "new brainrot that was added today",
    "new brainrot added today",
    "new brainrot added in this update",
    "new brainrot that was added in this update",
    "name of the new brainrot that was added today",
    "name of new brainrot added today",
    "name of the new brainrot",
    "name of new brainrot",
    "new brainrots name",
    "new brainrot name",
    "name of the latest brainrot",
    "name of the newest brainrot",
    "best brainrot today",
    "best brainrot we added today",
    "best brainrot that we added today",
    "best brainrot added in today admin abuse",
    "best brainrot that was added in today update",
    "best brainrot that was added in todays update",
    "best brainrot that was added in today admin abuse",
    "best brainrot that was added in todays admin abuse",
    "best brainrot in today update",
    "best brainrot in todays update",
    "most best brainrot added today",
    "most best brainrot that was added today",
    "best brainrot in haunted fuse",
    "haunted fuse best brainrot",
    "best brainrot in the haunted fuse",
    "best brainrot from haunted fuse",
    "best brainrot from the haunted fuse",
    "best brainrot in haunted fuse machine",
    "best brainrot in the haunted fuse machine",
    "best brainrot from haunted fuse machine",
    "best brainrot from the haunted fuse machine",
    "best brainrot in hauntedfuse",
    "best brainrot from hauntedfuse",
    "best brainrot added in haunted fuse",
    "best brainrot added in the haunted fuse",
    "most op brainrot in haunted fuse",
    "op brainrot in haunted fuse",
    "best brainrot you can get in haunted fuse",
    "best brainrot you can get in the haunted fuse",
    "best brainrot you can get from haunted fuse",
    "best brainrot you can get from the haunted fuse",
    "best brainrot you can get in haunted fuse machine",
    "best brainrot you can get in the haunted fuse machine",
    "best brainrot in new fuse",
    "best brainrot in the new fuse",
    "best brainrot from new fuse",
    "best brainrot from the new fuse",
    "best brainrot in new fuse machine",
    "new fuse machine best brainrot",
    "best brainrot in the new fuse machine",
    "best brainrot you can get in new fuse",
    "best brainrot you can get in the new fuse",
    "best brainrot you can get from new fuse",
    "best brainrot you can get from the new fuse",
    "best brainrot you can get in new fuse machine",
    "best brainrot you can get in the new fuse machine",
    "best brainrot you can get in haunted fuse or new fuse",
    "best brainrot you can get in the haunted fuse or the new fuse",
}
for _, question in ipairs(CurrentBrainrotQuestions) do
    for _, prefix in ipairs({"", "what is ", "whats ", "the ", "what is the ", "whats the ", "which is ", "which is the ", "tell me "}) do
        local key = (prefix .. question):lower():gsub("[’']", ""):gsub("[^%w]+", " "):gsub("%s+", " "):match("^%s*(.-)%s*$")
        RiddleDatabase[key] = "phoenix"
        CurrentBrainrotFactKeys[key] = true
    end
end

-- Haunted Fuse rarity and strength have different answers.
for _, machine in ipairs({"haunted fuse", "haunted fuses", "haunted fuse machine", "haunted fuse machines", "hauntedfuse"}) do
    for _, clue in ipairs({
        "rarest brainrot in ", "rarest brainrot from ",
        "rarest brainrot you can get in ", "rarest brainrot you can get from ",
        "rarest brainrot that you can get in ", "rarest brainrot that you can get from ",
    }) do
        for _, article in ipairs({"", "the "}) do
            for _, prefix in ipairs({"", "the ", "what is ", "what is the ", "whats ", "whats the ", "which is ", "which is the ", "tell me "}) do
                local key = prefix .. clue .. article .. machine
                RiddleDatabase[key] = "plantsbros"
                CurrentBrainrotFactKeys[key] = true
            end
        end
    end
end

-- Current mutation answer.
local CurrentMutationQuestions = {
    "new mutation",
    "new mutation added today",
    "new mutation that was added today",
    "new mutation in this update",
    "new mutation added in this update",
    "new mutation name",
    "name of the new mutation",
    "current mutation",
    "mutation in the new update",
    "mutation added today",
    "mutation that was added today",
    "last mutation",
    "last mutation added",
    "last mutation that was added",
    "last mutation added today",
    "latest mutation",
    "latest mutation added",
    "latest mutation added today",
    "most recent mutation",
    "most recent mutation added",
    "newest mutation",
    "newest mutation added today",
    "what mutation was added today",
    "which mutation was added today",
}
for _, question in ipairs(CurrentMutationQuestions) do
    RiddleDatabase[question] = "eclipse"
    CurrentBrainrotFactKeys[question] = true
end

-- Mutation order.
local CurrentMutationOrder = {
    "bloodrot", "candy", "lava", "galaxy", "yinyang", "radioactive",
    "cursed", "divine", "cyber", "phantom", "crystal", "eclipse",
}
local MutationOrdinals = {
    "first", "second", "third", "fourth", "fifth", "sixth",
    "seventh", "eighth", "ninth", "tenth", "eleventh", "twelfth",
}
local MutationOrdinalNumbers = {"1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th"}
for number, mutation in ipairs(CurrentMutationOrder) do
    RiddleDatabase["release event order " .. number] = mutation
    for _, ordinal in ipairs({MutationOrdinals[number], MutationOrdinalNumbers[number]}) do
        for _, suffix in ipairs({" mutation", " mutation added", " mutation that was added", " mutation released"}) do
            RiddleDatabase[ordinal .. suffix] = mutation
        end
    end
    RiddleDatabase["mutation " .. number] = mutation
    RiddleDatabase["mutation number " .. number] = mutation
    RiddleDatabase["mutation release order " .. number] = mutation
end

-- Previous Strawberry fuse date aliases.
RiddleDatabase["previous Strawberry fuse machine release date"] = "october2025"
RiddleDatabase["previous Strawberry fuse machine release month"] = "october"
RiddleDatabase["previous Strawberry fuse machine release year"] = "2025"
RiddleDatabase["previous Strawberry fuse machine release day"] = "11"
RiddleDatabase["when previous Strawberry fuse machine released"] = "october2025"
local oldStrawberry = RiddleDates["witch fuse machine"]
if oldStrawberry then
    for _, alias in ipairs({"previous Strawberry fuse machine", "previous Strawberry machine", "old Strawberry fuse machine", "Strawberry fuse machine", "Strawberry fuse"}) do
        RiddleDates[alias] = oldStrawberry
    end
end

-- Today's update answer is distinct from the general best brainrot and from
-- fuse-machine questions. Apply these current aliases after older data updates.
for _, question in ipairs(CurrentBrainrotQuestions) do
    local q = question:lower():gsub("’", "'"):gsub("'", ""):gsub("[^%w]+", " ")
        :gsub("%s+", " "):match("^%s*(.-)%s*$")
    if q:find("today", 1, true) or q:find("this update", 1, true) or q:find("this admin abuse", 1, true) then
        registerRiddleFact(q, "dragonskeletonini")
    end
end
for _, description in ipairs({"best brainrot", "op brainrot", "most op brainrot", "strongest brainrot"}) do
    for _, suffix in ipairs({" today", " added today", " that was added today", " we added today", " that we added today"}) do
        registerRiddleFact(description .. suffix, "dragonskeletonini")
    end
    for _, timeframe in ipairs({"todays admin abuse", "today admin abuse", "this admin abuse",
        "todays update", "today update", "this update"}) do
        for _, connector in ipairs({" in ", " added in ", " that was added in ", " we added in ", " that we added in "}) do
            registerRiddleFact(description .. connector .. timeframe, "dragonskeletonini")
        end
    end
end
for _, question in ipairs({"best brainrot today update", "best brainrot todays update",
    "most best brainrot in todays admin abuse", "most best brainrot in todays update"}) do
    registerRiddleFact(question, "dragonskeletonini")
end
-- Skull / new Lucky Block rankings are separate from the general best brainrot.
for _, block in ipairs({"skull lucky block", "new lucky block",
    "skull lucky block or new lucky block", "new lucky block or skull lucky block",
    "skull lucky block or the new lucky block", "new lucky block or the skull lucky block"}) do
    for _, description in ipairs({"best brainrot", "op brainrot", "most op brainrot", "strongest brainrot"}) do
        for _, article in ipairs({"", "the "}) do
            local source = article .. block
            registerRiddleFact(source .. " " .. description, "dragonskeletonini", RiddleLuckyBlockFactKeys)
            registerRiddleFact(source .. "s " .. description, "dragonskeletonini", RiddleLuckyBlockFactKeys)
            for _, connector in ipairs({" in ", " from ", " out of ", " inside ", " you can get in ", " you can get from ",
                " you can get out of ", " that you can get in ", " that you can get from ", " that you can get out of "}) do
                registerRiddleFact(description .. connector .. source, "dragonskeletonini", RiddleLuckyBlockFactKeys)
            end
        end
    end
end

-- User-confirmed Dragon Skeletonini color; keep ranking answers independent.
local RiddleColorFactRevision = "2026-10-11-dragonskeletonini-gray"
local RiddleColorFactKeys = {}

local function registerRiddleColorSubject(subject)
    for _, spelling in ipairs({"color", "colour"}) do
        registerRiddleFact(spelling .. " of " .. subject, "gray", RiddleColorFactKeys)
        registerRiddleFact(subject .. " " .. spelling, "gray", RiddleColorFactKeys)
        registerRiddleFact(spelling .. " is " .. subject, "gray", RiddleColorFactKeys)
    end
end

for _, subject in ipairs({
    "new brainrot", "the new brainrot", "newbrainrot",
    "dragonskeletonini", "dragon skeletonini",
    "dragonskeletoninis", "dragon skeletoninis",
}) do
    registerRiddleColorSubject(subject)
end

for _, spelling in ipairs({"color", "colour"}) do
    registerRiddleFact(spelling .. "ofnewbrainrot", "gray", RiddleColorFactKeys)
end

for _, block in ipairs({"new lucky block", "skull lucky block"}) do
    for _, article in ipairs({"", "the "}) do
        for _, relation in ipairs({"in ", "from ", "that you can get in ", "that you can get from "}) do
            registerRiddleColorSubject("best brainrot " .. relation .. article .. block)
            registerRiddleColorSubject("the best brainrot " .. relation .. article .. block)
        end
    end
end

for _, description in ipairs({
    "best brainrot added today",
    "best brainrot that was added today",
    "best brainrot this update",
    "best brainrot in this update",
    "best brainrot added this update",
    "best brainrot added in this update",
    "best brainrot that was added this update",
    "best brainrot that was added in this update",
    "best brainrot todays admin abuse",
    "best brainrot in todays admin abuse",
    "best brainrot added in todays admin abuse",
    "best brainrot that was added in todays admin abuse",
}) do
    registerRiddleColorSubject(description)
    registerRiddleColorSubject("the " .. description)
end

-- These exact user phrasings refer to the supplied color clue. Do not register
-- the bare entity name, which could otherwise replace a different type of clue.
for _, alias in ipairs({
    "whats dragon skeletonini", "what is dragon skeletonini",
    "whats dragonskeletonini", "what is dragonskeletonini",
}) do
    RiddleDatabase[alias] = "gray"
    RiddleFactKeys[alias] = true
    RiddleColorFactKeys[alias] = true
end

-- Use an explicit reference timezone rather than an executor's local calendar.
local function createRiddleCalendar(config, deps)
    deps = deps or {}
    return function()
        local timestamp = deps.timestamp and deps.timestamp() or workspace:GetServerTimeNow()
        local offset = tonumber(config.RiddleUtcOffsetHours) or 0
        if offset ~= offset then offset = 0 end
        local adjusted = math.floor(timestamp + math.clamp(offset, -14, 14) * 3600)
        if deps.toDate then return deps.toDate(adjusted) end
        local current = DateTime.fromUnixTimestamp(adjusted):ToUniversalTime()
        return {day = current.Day, month = current.Month, year = current.Year}
    end
end

-- Riddle lookup and submission.
local function createRiddleSolver(config, deps, saved)
    saved = saved or {}
    local options = saved.riddleSettings or {}
    local s = {
        alive = true, enabled = false, armed = false, entries = {}, answers = {}, questions = {},
        learned = saved.learnedFacts or {}, seenIds = {}, seenText = {}, attempts = {},
        currentBrainrotFactRevision = CurrentBrainrotFactRevision, riddleFactRevision = RiddleFactRevision,
        riddleRarityFactRevision = RiddleRarityFactRevision,
        riddleBirthDateFactRevision = RiddleBirthDateFactRevision,
        riddleLuckyBlockFactRevision = RiddleLuckyBlockFactRevision,
        riddleColorFactRevision = RiddleColorFactRevision,
        redeemed = deps.redeemed or saved.riddleRedeemed or {}, session = 0,
        pending = nil, timer = nil, responseTimer = nil, waitingForReady = false, revision = 0,
        learnedCount = 0, unknownCount = 0, duplicateCount = 0, retryAt = nil, transientRetries = {},
        status = "AI Riddle Solver Off", lastMatched = "", lastResponse = "",
        settings = {learnFacts = options.learnFacts == true, fallback = options.fallback == true,
            fallbackDelay = math.clamp(tonumber(options.fallbackDelay) or 0.55, 0, 1)},
    }
    -- Clear superseded facts once for this update, preserving unrelated facts
    -- and anything learned after the current revision was saved.
    if saved.currentBrainrotFactRevision ~= s.currentBrainrotFactRevision then
        for question in pairs(CurrentBrainrotFactKeys or {}) do s.learned[question] = nil end
    end
    if saved.riddleFactRevision ~= s.riddleFactRevision then
        for question in pairs(RiddleFactKeys) do s.learned[question] = nil end
    end
    if saved.riddleRarityFactRevision ~= s.riddleRarityFactRevision then
        for question in pairs(RiddleRarityFactKeys) do s.learned[question] = nil end
    end
    if saved.riddleBirthDateFactRevision ~= s.riddleBirthDateFactRevision then
        for question in pairs(RiddleBirthDateFactKeys) do s.learned[question] = nil end
    end
    if saved.riddleColorFactRevision ~= s.riddleColorFactRevision then
        for question in pairs(RiddleColorFactKeys) do s.learned[question] = nil end
        s.learned["dragon skeletonini"], s.learned["dragonskeletonini"] = nil, nil
    end
    if saved.riddleLuckyBlockFactRevision ~= s.riddleLuckyBlockFactRevision then
        for question in pairs(RiddleLuckyBlockFactKeys) do s.learned[question] = nil end
    end
    for code, at in pairs(saved.riddleRedeemed or {}) do
        if not s.redeemed[code] then s.redeemed[code] = type(at) == "number" and at or deps.now() end
    end
    for _ in pairs(s.learned) do s.learnedCount += 1 end
    local submit, schedule
    local nextEntryId, nextAnnouncementId = 0, 0
    local function clean(value)
        return (tostring(value or ""):gsub("<[^>]*>", ""):gsub("&apos;", "'")
            :gsub("&quot;", '"'):gsub("&amp;", "&"):gsub("&lt;", "<"):gsub("&gt;", ">"))
    end
    local function normalize(value)
        return (clean(value):lower():gsub("’", "'"):gsub("'", "")
            :gsub("[^%w]+", " "):gsub("%s+", " "):match("^%s*(.-)%s*$"))
    end
    local function payload(value)
        local q = clean(value):gsub("’", "'"):lower()
        q = q:gsub("^%s*sammy%s+asks%s*:%s*", ""):gsub("^%s*sammy%s+says%s*:%s*", "")
        q = q:gsub("^%s*the%s+riddle%s+is%s*[:%-]?%s*", "")
            :gsub("^%s*the%s+riddle%s*:%s*", "")
            :gsub("^%s*the%s+riddle%s*%-%s*", "")
            :gsub("^%s*the%s+riddle%s+", "")
            :gsub("^%s*riddle%s+is%s*[:%-]?%s*", ""):gsub("^%s*riddle%s*:%s*", "")
            :gsub("^%s*riddle%s*%-%s*", ""):gsub("^%s*riddle%s+", "")
            :gsub("^%s*question%s+is%s*[:%-]?%s*", ""):gsub("^%s*question%s*:%s*", "")
        q = q:gsub("^%s*and%s+", "")
        return q
    end
    local function key(value)
        local q = normalize(payload(value))
        -- Exact originals remain available before these harmless wrappers.
        q = q:gsub("^what%s+is%s+", ""):gsub("^whats%s+", "")
            :gsub("^tell%s+me%s+", ""):gsub("^the%s+answer%s+to%s+", "")
        q = q:gsub("^the%s+", "")
        return q
    end
    local function encoded(value)
        return (tostring(value or ""):gsub("[^A-Za-z0-9]", ""))
    end
    local function emit(message)
        if message then s.status = message end
        deps.changed(s)
    end
    local function cancel(job)
        if job and deps.cancel then deps.cancel(job) end
    end
    local function refreshEntries()
        s.answers, s.questions = {}, {}
        for _, entry in ipairs(s.entries) do
            s.answers[#s.answers + 1] = entry.value or "?"
            s.questions[#s.questions + 1] = entry.question
        end
        s.revision += 1
    end
    local function reset(message)
        cancel(s.timer)
        -- Clearing clues cannot cancel the native game request. Keep its identity
        -- and deadline until its callback releases it, even while the solver is off.
        if not s.pending then cancel(s.responseTimer) s.responseTimer = nil end
        s.timer, s.waitingForReady, s.retryAt = nil, false, nil
        s.session += 1
        s.entries, s.attempts, s.transientRetries = {}, {}, {}
        s.completedQuestion, s.lastClueAt = nil, nil
        refreshEntries()
        emit(message or (s.enabled and "Waiting For A Riddle..." or "AI Riddle Solver Off"))
    end
    local function learnedValue(question)
        local record = s.learned[question]
        if type(record) == "string" then return record end
        if type(record) == "table" then return record.answer end
    end
    local fields = {month = true, year = true, day = true, date = true}
    local todayFields = {
        ["date of the month today"] = "date", ["day of the month today"] = "day",
        ["todays date"] = "date", ["todays day"] = "day", ["todays month"] = "month", ["todays year"] = "year",
        ["date today"] = "date", ["day today"] = "day", ["month today"] = "month", ["year today"] = "year",
        ["today date"] = "date", ["today day"] = "day", ["today month"] = "month", ["today year"] = "year",
        ["todays day of the month"] = "day", ["todays date of the month"] = "day",
        ["day of the month"] = "day", ["date of the month"] = "day",
        ["what day is it today"] = "day", ["what date is it today"] = "date",
        ["what month is it today"] = "month", ["what year is it today"] = "year",
        ["what day of the month is it today"] = "day",
    }
    local months = {"january", "february", "march", "april", "may", "june",
        "july", "august", "september", "october", "november", "december"}
    local function todayQuery(question, requested, current)
        local q = key(question)
        local field = todayFields[q]
        if not field then return nil end
        field = requested or field
        local calendar = {question = q, field = field}
        current = current or (deps.currentDate and deps.currentDate() or os.date("!*t"))
        local day, month, year = current.day, current.month, current.year
        local record = {date = tostring(day), day = tostring(day), month = months[month], year = tostring(year)}
        return record[field], q .. " " .. field, calendar
    end
    local function dateQuery(question, requested, current)
        local today, todayKey, calendar = todayQuery(question, requested, current)
        if calendar then return today, todayKey, calendar end
        local q = key(question)
        local field = requested
        local askedField, subject = q:match("^what%s+(%a+)%s+was%s+(.+)$")
        if fields[askedField] then field, q = askedField, subject end
        local first, tail = q:match("^(%a+)%s+(.+)$")
        if fields[first] then field, q = first, tail end
        local base, last = q:match("^(.-)%s+(%a+)$")
        if fields[last] then field, q = last, base end
        -- Explicit components override a field mentioned in the base question.
        field = requested or field
        today, todayKey, calendar = todayQuery(q, field, current)
        if calendar then return today, todayKey, calendar end
        local dateIntent = requested ~= nil or field ~= nil
            or q:find("released", 1, true) ~= nil or q:find("release", 1, true) ~= nil
            or q:match("^when%s+") ~= nil
        if not dateIntent then return nil end
        q = q:gsub("^date%s+when%s+", ""):gsub("^when%s+was%s+", "")
            :gsub("^when%s+", ""):gsub("^date%s+of%s+", ""):gsub("^the%s+", "")
            :gsub("^of%s+", "")
            :gsub("%s+was%s+released$", ""):gsub("%s+released$", "")
            :gsub("%s+release%s+date$", ""):gsub("%s+release$", "")
        local record = RiddleDates and RiddleDates[q]
        local value = record and record[field or "date"]
        if value and value ~= "" then return value, q .. " " .. (field or "date") end
        return nil
    end
    local function dynamicValue(question, original)
        if type(deps.dynamicAnswer) ~= "function" then return nil, nil, false end
        local ok, answer, matched, handled = pcall(deps.dynamicAnswer, question, original)
        if not ok then return nil, nil, false end
        -- A live resolver can recognize a question but temporarily lack a safe
        -- value. Preserve that state so stale learned/database answers do not
        -- silently replace it.
        if handled == true then
            if answer ~= nil then
                answer = tostring(answer)
                if answer == "" then answer = nil end
            end
            return answer, matched, true
        end
        if answer == nil then return nil, nil, false end
        answer = tostring(answer)
        if answer == "" then return nil, nil, false end
        return answer, matched, true
    end
    local function exact(question, current)
        local original, q = normalize(question), key(question)
        -- Resolve "today" at the time of the clue, before saved facts can go stale.
        local today, todayKey, calendar = todayQuery(q, nil, current)
        if calendar then return today, todayKey, "Current Date", calendar end
        local dated, datedKey, datedCalendar = dateQuery(q, nil, current)
        if datedCalendar then return dated, datedKey, "Current Date", datedCalendar end
        -- Live mutation, trait, and existence data must outrank saved answers.
        -- Pass the raw clue so punctuation/compound boundaries remain visible
        -- to the live adapter; it performs its own normalization.
        local live, liveKey, liveHandled = dynamicValue(question, question)
        if liveHandled then return live, liveKey or q, "Live" end
        local value = learnedValue(q) or learnedValue(original)
        if value then return value, q, "Learned" end
        if dated then return dated, datedKey, "Database" end
        value = RiddleDatabase[original] or RiddleDatabase[q]
        if value then return value, q, "Database" end
    end
    local function resolve(value)
        local raw = payload(value)
        -- All date components in this announcement use one calendar snapshot.
        -- The answer stays attached to its clue through midnight and cooldowns.
        local current = deps.currentDate and deps.currentDate() or os.date("!*t")
        local clauses = {}
        raw = raw:gsub("[\r\n;]+", ",")
        for clause in raw:gmatch("[^,+&]+") do
            clause = clause:match("^%s*(.-)%s*$"):gsub("^and%s+", "")
            if clause ~= "" then clauses[#clauses + 1] = clause end
        end
        local function qualifierFields(value)
            local result = {}
            for field in normalize(value):gmatch("%S+") do
                if field ~= "and" then
                    if not fields[field] then return nil end
                    result[#result + 1] = field
                end
            end
            return #result > 0 and result or nil
        end
        -- Also accept an unpunctuated date tail: "released month and year".
        if #clauses == 1 then
            local base, tail = raw:match("^(.-)%s+(%a+%s+and%s+.+)$")
            if base and qualifierFields(tail) then clauses = {base, tail} end
        end
        if #clauses > 1 then
            local requested, qualifiers = {}, true
            for i = 2, #clauses do
                local components = qualifierFields(clauses[i])
                if not components then qualifiers = false break end
                for _, field in ipairs(components) do requested[#requested + 1] = field end
            end
            if qualifiers then
                local entries = {}
                for _, field in ipairs(requested) do
                    local answer, found, datedCalendar = dateQuery(clauses[1], field, current)
                    entries[#entries + 1] = {question = key(clauses[1]) .. " " .. field,
                        value = answer and encoded(answer), source = datedCalendar and "Current Date" or "Database",
                        matched = found, calendar = datedCalendar}
                end
                return entries
            end
        end
        local whole, matched, source, calendar = exact(raw, current)
        if (whole or calendar) and source ~= "Live" then return {{question = key(raw), value = whole and encoded(whole), matched = matched,
            source = source, calendar = calendar}} end
        local entries = {}
        local function adjacent(clause)
            local words = {}
            for word in clause:gmatch("%S+") do words[#words + 1] = word end
            if #words < 2 or #words > 48 then return nil end
            local memo, lookups, budget = {}, {}, 128
            local function questionStart(index)
                local first = normalize(words[index])
                local starters = {my = true, what = true, whats = true, which = true, when = true,
                    who = true, how = true, where = true, why = true, sammy = true, sammys = true}
                if starters[first] then return true end
                local pair = first .. " " .. normalize(words[index + 1])
                return pair == "color of" or pair == "colour of" or pair == "name of"
                    or pair == "best brainrot" or pair == "op brainrot" or pair == "rarest brainrot"
                    or pair == "current mutation" or pair == "current trait" or pair == "date of" or pair == "day of"
            end
            local function lookup(first, last)
                local id = first .. ":" .. last
                if lookups[id] ~= nil then return lookups[id] or nil end
                if budget <= 0 then return nil end
                budget -= 1
                local text = table.concat(words, " ", first, last)
                local answer, found, from, datedCalendar = exact(text, current)
                local entry
                if answer or datedCalendar or from == "Live" then
                    entry = {question = key(text), value = answer and encoded(answer),
                        matched = found, source = from, calendar = datedCalendar}
                end
                lookups[id] = entry or false
                return entry
            end
            local function partition(first)
                if first > #words then return {count = 0} end
                if memo[first] ~= nil then return memo[first] or nil end
                -- Longest complete aliases win; every word must belong to a clue.
                for last = #words, first, -1 do
                    if not (first == 1 and last == #words) and (last == #words or questionStart(last + 1)) then
                        local entry = lookup(first, last)
                        if entry then
                            local tail = partition(last + 1)
                            if tail then
                                local result = {entry = entry, tail = tail, count = tail.count + 1}
                                memo[first] = result
                                return result
                            end
                        end
                    end
                end
                memo[first] = false
                return nil
            end
            local result = partition(1)
            if not result or result.count < 2 then return nil end
            return result
        end
        local function append(clause)
            local answer, found, from, datedCalendar = exact(clause, current)
            if (answer or datedCalendar) and from ~= "Live" then
                entries[#entries + 1] = {question = key(clause), value = answer and encoded(answer),
                    matched = found, source = from, calendar = datedCalendar}
                return
            end
            local partition = adjacent(clause)
            if partition then
                while partition.entry do
                    entries[#entries + 1] = partition.entry
                    partition = partition.tail
                end
                return
            end
            if answer or datedCalendar or from == "Live" then
                entries[#entries + 1] = {question = key(clause), value = answer and encoded(answer),
                    matched = found, source = from, calendar = datedCalendar}
                return
            end
            -- Preserve exact names containing "and" before splitting questions.
            local separators, position = {}, 1
            while true do
                local first, last = clause:find("%s+and%s+", position)
                if not first then break end
                separators[#separators + 1] = {first, last}
                position = last + 1
            end
            -- Prefer the longest known prefix so a name such as "chipso and
            -- queso" remains one answer when followed by another question.
            for i = #separators, 1, -1 do
                local split = separators[i]
                local left, right = clause:sub(1, split[1] - 1), clause:sub(split[2] + 1)
                local known, _, knownSource, knownCalendar = exact(left, current)
                if known or knownCalendar or knownSource == "Live" then append(left) append(right) return end
            end
            if #separators > 0 then
                local split = separators[1]
                append(clause:sub(1, split[1] - 1)) append(clause:sub(split[2] + 1)) return
            end
            entries[#entries + 1] = {question = key(clause)}
        end
        for _, clause in ipairs(clauses) do append(clause) end
        return entries
    end
    local function releaseSubmitted(request)
        local corrected = false
        for _, entry in ipairs(s.entries) do
            if request.entryIds[entry.id] then
                entry.submitted = false
                local answer = not entry.calendar and entry.source ~= "Live" and learnedValue(entry.question)
                if answer and entry.value ~= encoded(answer) then
                    entry.value, entry.source = encoded(answer), "Learned"
                    corrected = true
                end
            end
        end
        if corrected then refreshEntries() end
        return corrected
    end
    local function removeSubmitted(request)
        local rest = {}
        for _, entry in ipairs(s.entries) do
            if not request.entryIds[entry.id] then rest[#rest + 1] = entry end
        end
        s.entries = rest
        refreshEntries()
    end
    local function cooldownSeconds(message)
        local seconds = tonumber(message:lower():match("wait%s+(%d+%.?%d*)%s*seconds?"))
        return math.max(0.1, tonumber(config.RiddleRateRetryDelay) or 1, seconds or 0)
    end
    local function retryTransient(request, message)
        releaseSubmitted(request)
        local tries = s.transientRetries[request.attemptKey] or 0
        local limit = math.max(0, math.floor(tonumber(config.RiddleTransientRetryLimit) or 2))
        if tries >= limit then
            emit("Retry Limit Reached · Waiting For Next Clue Or Clear")
            return
        end
        s.transientRetries[request.attemptKey] = tries + 1
        s.attempts[request.attemptKey] = nil
        s.retryAt = deps.now() + cooldownSeconds(message)
        emit("Retrying Riddle Submission After A Delay")
        schedule()
    end
    local guessPool, guessSeen = {}, {}
    for _, answer in pairs(RiddleDatabase) do
        local code = encoded(answer)
        if #code >= config.MinPartLength and #code <= config.MaxCodeLength and not guessSeen[code] then
            guessSeen[code] = true
            guessPool[#guessPool + 1] = code
        end
    end
    table.sort(guessPool)
    local function guess(maxLength)
        local choices = {}
        for _, code in ipairs(guessPool) do
            if #code <= maxLength then choices[#choices + 1] = code end
        end
        if #choices == 0 then return nil end
        return choices[(deps.random or math.random)(1, #choices)]
    end
    local function unresolved()
        for _, entry in ipairs(s.entries) do if not entry.value or entry.value == "" then return true end end
        return false
    end
    schedule = function()
        cancel(s.timer) s.timer = nil
        s.waitingForReady = false
        if not s.alive or not s.enabled or not s.armed or s.pending or #s.entries == 0 then return end
        for _, entry in ipairs(s.entries) do
            if entry.source == "Live" and (not entry.value or entry.value == "") then
                emit("Live Riddle Data Unavailable · Submission Paused")
                return
            end
        end
        if unresolved() and not s.settings.fallback then
            emit("Unknown Riddle Part · Submission Paused")
            return
        end
        local wait = unresolved() and s.settings.fallbackDelay or (config.RiddleAnswerDebounce or 0.12)
        -- Queued clues may already have waited while the game finished another
        -- request. Only wait for the remaining quiet period after the last clue.
        local elapsed = s.lastClueAt and math.max(0, deps.now() - s.lastClueAt) or 0
        local delay = math.max(0, wait - elapsed, (s.retryAt or 0) - deps.now())
        local function run()
            s.timer = nil
            if not s.alive or s.pending or not s.enabled or not s.armed then return end
            if unresolved() then
                if not s.settings.fallback then return end
                local remaining, unknown = config.MaxCodeLength, 0
                for _, entry in ipairs(s.entries) do
                    if not entry.value or entry.value == "" then unknown += 1
                    else remaining -= #entry.value end
                end
                local guesses = {}
                for i, entry in ipairs(s.entries) do
                    if not entry.value or entry.value == "" then
                        local answer = guess(remaining - (unknown - 1) * config.MinPartLength)
                        if not answer then emit("No Fallback Answer Fits The Code Limit") return end
                        guesses[i] = answer
                        remaining -= #answer
                        unknown -= 1
                    end
                end
                for i, entry in ipairs(s.entries) do
                    if guesses[i] then entry.value, entry.source = guesses[i], "Guess" end
                end
                refreshEntries()
            end
            submit()
        end
        if delay == 0 and deps.defer then s.timer = deps.defer(run)
        else s.timer = deps.after(delay, run) end
    end
    submit = function()
        if not s.alive or not s.enabled or not s.armed or s.pending or #s.entries == 0 then return end
        if s.retryAt and deps.now() < s.retryAt then schedule() return end
        s.retryAt = nil
        if unresolved() then return end
        local values, identities, guessed = {}, {}, false
        local announcement = s.entries[1].announcement
        local question = s.entries[1].announcementQuestion
        for _, entry in ipairs(s.entries) do
            values[#values + 1] = entry.value guessed = guessed or entry.source == "Guess"
            identities[#identities + 1] = tostring(entry.id)
            if entry.announcement ~= announcement then question = nil end
        end
        local code = table.concat(values)
        if #code < config.MinPartLength or #code > config.MaxCodeLength then
            emit("Answer Exceeds The Game's Code Limit") return
        end
        if s.redeemed[code] then
            emit("Riddle Code Already Redeemed · Waiting For Next Clue")
            return
        end
        if deps.skipReplayCode and deps.skipReplayCode(code) then
            s.waitingForReady = false
            emit("Already Checked · Waiting For A New Clue")
            return
        end
        local attemptKey = code .. ":" .. table.concat(identities, ",")
        if s.attempts[attemptKey] then emit("Waiting For The Next Riddle Clue...") return end
        local ready, reason = deps.ready()
        if not ready then
            s.waitingForReady = true
            emit(reason or "Waiting For The Code Box")
            s.timer = deps.after(config.RiddleRetryInterval or 0.05, function()
                s.timer, s.waitingForReady = nil, false
                submit()
            end)
            return
        end
        s.waitingForReady = false
        local request = {code = code, count = #s.entries, revision = s.revision, guessed = guessed,
            session = s.session, question = question, attemptKey = attemptKey, entryIds = {}}
        for _, entry in ipairs(s.entries) do request.entryIds[entry.id] = true end
        s.pending, s.lastSubmitted = request, code
        s.attempts[attemptKey] = true
        for _, entry in ipairs(s.entries) do entry.submitted = true end
        emit(guessed and "Submitting Fallback Guess..." or "Submitting Riddle Answer...")
        s.responseTimer = deps.after(config.ResponseTimeout or 18, function()
            if s.pending ~= request then return end
            emit("Game Response Delayed · Request Still Pending")
            -- Keep the flight identity. A late callback can finish it; no retry.
        end)
        local ok = pcall(deps.submit, code, function(success, message)
            if s.pending ~= request then return end
            cancel(s.responseTimer) s.responseTimer = nil s.pending = nil
            s.lastResponse = clean(message)
            local lower, result = s.lastResponse:lower(), "unclear"
            if success then result = "success"
            elseif lower:find("please wait", 1, true) or lower:find("cooldown", 1, true)
                or lower:find("too fast", 1, true) or lower:find("try again later", 1, true) then result = "rate"
            elseif lower:find("sold out", 1, true) or lower:find("expired", 1, true) then result = "unavailable"
            elseif lower:find("already", 1, true) and (lower:find("redeem", 1, true) or lower:find("used", 1, true)) then result = "used"
            elseif lower:find("invalid", 1, true) or lower:find("incorrect", 1, true) then result = "invalid"
            elseif lower == "confirm button could not be activated" or lower == "textbox rejected the code" then result = "adapter" end
            if result == "success" or result == "used" then s.redeemed[request.code] = deps.now() end
            -- A cooldown belongs to the game even if the old riddle was cleared.
            if result == "rate" then s.retryAt = deps.now() + cooldownSeconds(s.lastResponse) end
            if request.session ~= s.session then
                -- A reset/new riddle may have replaced every old entry. Consume
                -- only the request's IDs, never a prefix of the replacement queue.
                removeSubmitted(request)
                emit(s.enabled and (#s.entries > 0 and "New Riddle Part Collected" or "Waiting For Riddle Questions...")
                    or "AI Riddle Solver Off")
                if #s.entries > 0 then schedule() end
                return
            end
            if result == "rate" or result == "adapter" then retryTransient(request, s.lastResponse) return end
            local corrected = releaseSubmitted(request)
            if result == "unclear" then
                emit(s.lastResponse ~= "" and "Riddle Not Confirmed · " .. s.lastResponse
                    or "Riddle Not Confirmed · Answer Kept")
                return
            end
            if #s.entries == request.count then s.completedQuestion = request.question end
            if result == "invalid" then
                -- Keep a rejected prefix for later clues, and allow a fact learned
                -- during its flight to correct it without replaying the old code.
                emit(#s.entries > request.count and "New Riddle Part Collected" or "Game Rejected Riddle Code · Waiting For Next Clue")
                if corrected or #s.entries > request.count then schedule() end
            else
                removeSubmitted(request)
                local status = result == "success" and "Riddle Code Redeemed"
                    or result == "unavailable" and "Riddle Code Sold Out Or Expired"
                    or "Riddle Code Already Redeemed"
                emit(status)
                if deps.finished then deps.finished(result, s.lastResponse) end
                if #s.entries > 0 then schedule() end
            end
        end)
        if not ok and s.pending == request then
            cancel(s.responseTimer) s.responseTimer = nil s.pending = nil
            retryTransient(request, "Submit Adapter Failed")
        end
    end
    local function trusted(message, location, sender, remove)
        return s.alive and not remove and location == "Top" and type(message) == "string"
            and tonumber(sender) == config.SammyUserId
    end
    local function identity(message, sender, id)
        return id ~= nil and tostring(id) ~= "" and (tostring(sender) .. ":" .. tostring(id) .. ":" .. normalize(message)) or nil
    end
    local function duplicate(message, sender, id)
        local now, idKey = deps.now(), identity(message, sender, id)
        if idKey then
            local at = s.seenIds[idKey]
            return at ~= nil and now - at <= (config.MessageIdTTL or 600)
        end
        local at = s.seenText[normalize(message)]
        return at ~= nil and now - at < (config.RiddleDuplicateWindow or 0.35)
    end
    local function remember(message, sender, id)
        local now, identity = deps.now(), id ~= nil and tostring(id) or ""
        local idKey = identity ~= "" and (tostring(sender) .. ":" .. identity .. ":" .. normalize(message)) or nil
        local textKey = normalize(message)
        if duplicate(message, sender, id) then s.duplicateCount += 1 return false end
        if idKey then s.seenIds[idKey] = now else s.seenText[textKey] = now end
        local count = 0
        for cacheKey, at in pairs(s.seenIds) do
            count += 1
            if now - at > (config.MessageIdTTL or 600) then s.seenIds[cacheKey] = nil end
        end
        if count > (config.CacheLimit or 256) then
            local oldestKey, oldest
            for cacheKey, at in pairs(s.seenIds) do
                if not oldest or at < oldest then oldestKey, oldest = cacheKey, at end
            end
            if oldestKey then s.seenIds[oldestKey] = nil end
        end
        for cacheKey, at in pairs(s.seenText) do if now - at > 2 then s.seenText[cacheKey] = nil end end
        return true
    end
    function s:observe(message, duration, sound, location, sender, id, remove)
        if not trusted(message, location, sender, remove) then return false end
        local q = normalize(message):gsub("^the%s+riddle", "riddle")
        local body = q:match("^riddle%s+is%s*(.*)$") or q:match("^riddle%s+(.+)$")
        local control = q == "riddle" or q == "riddle is" or q == "making a riddle"
            or q == "im going to make a riddle" or q == "i am going to make a riddle"
            or q == "im gonna make a riddle" or q == "i will make a riddle"
            or q == "okay im going to make a riddle" or q == "okay im gonna make a riddle"
        if body then
            local setup = body:match("^%s*(.-)%s*$")
            if setup == "hard" or setup == "easy" or setup == "very hard" or setup == "soon"
                or setup == "ready" or setup == "later" or setup == "tonight" or setup == "tomorrow"
                or setup == "next" or setup == "next up" or setup == "starting" or setup == "coming"
                or setup:match("^coming%s+soon") or setup:match("^starting%s+soon")
                or setup:match("^going%s+to") or setup:match("^gonna%s+be") or setup:match("^about%s+to") then
                control = true
            end
        end
        if not control and not body then
            if q:find("%f[%w_]riddle%f[^%w_]") then control = true else return false end
        end
        if duplicate(message, sender, id) then return true, true, false end
        if control and not remember(message, sender, id) then return true, true, false end
        -- A fresh explicit marker starts a new riddle, including inline clues.
        -- Old native requests remain tracked while the new queue waits.
        if self.enabled then reset("Waiting For Riddle Questions...") end
        if self.enabled then self.armed = true end
        return true, control, true
    end
    function s:receive(message, duration, sound, location, sender, id, remove)
        if not self.enabled or not trusted(message, location, sender, remove) then return false end
        local q = normalize(message):gsub("^the%s+riddle", "riddle")
        local explicit = q:match("^riddle%s+is%s+") ~= nil or q:match("^riddle%s+") ~= nil
        if not self.armed and not explicit then return false end
        local entries = resolve(message)
        if #entries == 0 or key(message) == "" then return false end
        local questionKey = key(message)
        local questionText = normalize(payload(message))
        local resolved = false
        for _, entry in ipairs(entries) do
            if entry.value or entry.calendar or entry.source == "Live" then resolved = true break end
        end
        local looksLikeQuestion = explicit or resolved
            or clean(message):find("?", 1, true) ~= nil
            or questionText:match("^my%s") or questionText:match("^what%s") or questionText:match("^when%s")
            or questionText:match("^whats%s") or questionText:match("^who%s") or questionText:match("^how%s")
            or questionText:match("^where%s") or questionText:match("^why%s")
            or questionText:match("^which%s") or questionText:match("^name%s+of%s")
            or questionText:match("^color%s+of%s") or questionText:find("released", 1, true)
        if not looksLikeQuestion then return false end
        if not remember(message, sender, id) then return true end
        if not self.pending and #self.entries > 0 and self.lastClueAt
            and deps.now() - self.lastClueAt > (config.RiddleClueGap or 8) then
            reset("Waiting For Riddle Questions...")
        end
        -- A completed standalone question can be announced again with a fresh
        -- identity. Rejected answers must not turn that repeat into redred/33.
        if not self.pending and self.completedQuestion == questionKey then
            reset("Waiting For Riddle Questions...")
        end
        if #self.entries + #entries > (config.MaxParts or 12) then
            cancel(self.timer) self.timer = nil
            self.waitingForReady = false
            emit("Too Many Riddle Parts · Press Clear")
            return true
        end
        self.completedQuestion = nil
        self.lastClueAt = deps.now()
        nextAnnouncementId += 1
        for _, entry in ipairs(entries) do
            nextEntryId += 1
            entry.id, entry.announcement, entry.announcementQuestion = nextEntryId, nextAnnouncementId, questionKey
            self.entries[#self.entries + 1] = entry
            if not entry.value or entry.value == "" then self.unknownCount += 1 end
            self.lastMatched = entry.matched or entry.question
        end
        refreshEntries()
        emit(self.pending and "Riddle Part Queued During Submission" or "Riddle Answer " .. #self.entries .. " Collected")
        schedule()
        return true
    end
    function s:learn(message, duration, sound, location, sender, id, remove)
        if not self.settings.learnFacts or not trusted(message, location, sender, remove) then return false end
        local plain, q = clean(message), normalize(message)
        if plain:find("?", 1, true) or q:match("^riddle") or q:match("^the%s+riddle") or q:match("^question") or q:match("^code%s")
            or q:match("^what%s") or q:match("^whats%s") or q:match("^when%s") or q:match("^which%s")
            or q:match("^who%s") or q:match("^how%s") or q:match("^where%s") or q:match("^why%s") then return false end
        local subject, answer = plain:match("^%s*(.-)%s+[Ii][Ss]%s+(.+)%s*$")
        if not subject or not answer then return false end
        local subjectKey = key(subject)
        local allowed = subjectKey:match("^my%s+.+%s+name$") or subjectKey:match("^my%s+.+%s+color$")
            or subjectKey:match("^name%s+of%s+my%s+.+$") or subjectKey:match("^color%s+of%s+my%s+.+$")
            or RiddleDatabase[subjectKey] ~= nil or learnedValue(subjectKey) ~= nil
        if not allowed then return false end
        answer = answer:match("^%s*(.-)%s*$"):gsub("[%.!]$", "")
        local answerLower = answer:lower()
        if #answer == 0 or #answer > 50 or answer:find("[,;:+&]") or answerLower:find(" or ", 1, true)
            or answerLower:match("%s+and%s+.-%s+is%s+") or answerLower:match("%s+is%s+") then return false end
        if encoded(answer) == "" then return false end
        if not answer:match("^[%w%s%-']+$") then return false end
        local aliases = {subjectKey}
        local person = subjectKey:match("^my%s+(.+)%s+name$")
        if person then
            person = person:gsub("s$", "")
        else person = subjectKey:match("^name%s+of%s+my%s+(.+)$") end
        if person then
            aliases[#aliases + 1] = "name of my " .. person
            aliases[#aliases + 1] = "my " .. person .. "s name"
            aliases[#aliases + 1] = "my " .. person .. " name"
        end
        local colored = subjectKey:match("^my%s+(.+)%s+color$") or subjectKey:match("^color%s+of%s+my%s+(.+)$")
        if colored then
            aliases[#aliases + 1] = "color of my " .. colored
            aliases[#aliases + 1] = "my " .. colored .. " color"
            aliases[#aliases + 1] = "my color of my " .. colored
        end
        local record = {answer = answer, source = plain, learnedAt = deps.now()}
        for _, alias in ipairs(aliases) do
            if not self.learned[alias] then self.learnedCount += 1 end
            self.learned[alias] = record
        end
        local corrected = false
        for _, entry in ipairs(self.entries) do
            if not entry.calendar and entry.source ~= "Live" and not entry.submitted and self.learned[entry.question] == record then
                entry.value, entry.source = encoded(answer), "Learned"
                corrected = true
            end
        end
        refreshEntries()
        emit("Learned Sammy Fact: " .. subjectKey)
        if deps.factsChanged then deps.factsChanged(self.learned) end
        if corrected then schedule() end
        return true
    end
    function s:setEnabled(value, arm)
        self.enabled = value == true self.armed = self.enabled and arm ~= false
        reset(self.enabled and (self.armed and "Waiting For A Riddle..." or "Waiting For Sammy's Riddle Announcement")
            or "AI Riddle Solver Off")
    end
    function s:setArmed(value)
        self.armed = self.enabled and value == true
        if not self.armed then
            cancel(self.timer) self.timer = nil self.waitingForReady = false
        elseif #self.entries > 0 then schedule() end
    end
    function s:wake()
        if not self.waitingForReady or not self.enabled or self.pending then return end
        cancel(self.timer)
        self.timer, self.waitingForReady = nil, false
        submit()
    end
    function s:setSettings(settings)
        if settings.learnFacts ~= nil then self.settings.learnFacts = settings.learnFacts == true end
        if settings.fallback ~= nil then
            self.settings.fallback = settings.fallback == true
            if not self.settings.fallback then
                local cleared = false
                for _, entry in ipairs(self.entries) do
                    if entry.source == "Guess" and not entry.submitted then
                        entry.value, entry.source = nil, nil
                        cleared = true
                    end
                end
                if cleared then refreshEntries() end
            end
        end
        if settings.fallbackDelay ~= nil then self.settings.fallbackDelay = math.clamp(tonumber(settings.fallbackDelay) or 0.55, 0, 1) end
        emit() schedule()
        return true
    end
    function s:clear() reset() end
    function s:prepareRetype()
        if self.pending then return false end
        local attempted = self.attempts
        reset("Retyping Recent Announcements...")
        self.attempts = attempted
        return true
    end
    function s:stop()
        self.alive, self.enabled, self.waitingForReady = false, false, false
        cancel(self.timer) cancel(self.responseTimer) self.pending = nil
    end
    function s:snapshot()
        return {learnedFacts = self.learned, riddleSettings = self.settings, riddleRedeemed = self.redeemed,
            currentBrainrotFactRevision = self.currentBrainrotFactRevision, riddleFactRevision = self.riddleFactRevision,
            riddleRarityFactRevision = self.riddleRarityFactRevision,
            riddleBirthDateFactRevision = self.riddleBirthDateFactRevision,
            riddleLuckyBlockFactRevision = self.riddleLuckyBlockFactRevision,
            riddleColorFactRevision = self.riddleColorFactRevision,
            riddleArmed = self.armed, riddleLastMatched = self.lastMatched, riddleEnabled = self.enabled}
    end
    return s
end

-- FPS boost.
local function createFPSController(onChanged)
    local Lighting = game:GetService("Lighting")
    local MaterialService = game:GetService("MaterialService")
    local f = {enabled = false, busy = false, changedProperties = 0, textures = 0, stoppedTracks = 0}
    local records, touched, connections, watchedAnimators = {}, {}, {}, {}
    local watchedProperties, stoppedTracks = {}, {}
    local worker, generation = nil, 0
    local function notify() if onChanged then onChanged(f) end end
    local function change(object, property, value)
        local ok, old = pcall(function() return object[property] end)
        if not ok or old == value then return false end
        local keys = touched[object]
        if not keys then keys = {} touched[object] = keys end
        local success = pcall(function() object[property] = value end)
        if not success then return false end
        local record = keys[property]
        if not record then
            record = {object = object, property = property, old = old, applied = value}
            keys[property] = record
            records[#records + 1] = record
            f.changedProperties += 1
        else
            -- Keep the latest game-assigned appearance when an asset finishes loading.
            -- Our own writes do not reach this branch because old already equals value.
            record.old, record.applied = old, value
        end
        return true
    end
    local function enforceProperty(object, property, value, isTexture)
        local properties = watchedProperties[object]
        if not properties then properties = {} watchedProperties[object] = properties end
        if not properties[property] then
            local version, writing = generation, false
            local ok, connection = pcall(function()
                return object:GetPropertyChangedSignal(property):Connect(function()
                    if not f.enabled or generation ~= version or writing then return end
                    writing = true
                    if change(object, property, value) and isTexture then f.textures += 1 end
                    writing = false
                end)
            end)
            if ok then
                properties[property] = connection
                connections[#connections + 1] = connection
            end
        end
        if change(object, property, value) and isTexture then f.textures += 1 end
    end
    local function disconnectAll()
        for _, connection in ipairs(connections) do connection:Disconnect() end
        connections = {}
    end
    local function stopTrack(track, animator)
        if not f.enabled then return end
        local ok, snapshot = pcall(function()
            if not track.IsPlaying then return nil end
            return {track = track, animator = animator, position = track.TimePosition,
                speed = track.Speed, weight = track.WeightTarget}
        end)
        if ok and snapshot and pcall(track.Stop, track, 0) then
            stoppedTracks[track] = snapshot
            f.stoppedTracks += 1
        end
    end
    local function apply(object)
        if not f.enabled then return end
        if object:IsA("BasePart") and not object:IsA("Terrain") then
            -- Changing visual materials must not change the original physical properties.
            if object.Material ~= Enum.Material.SmoothPlastic then
                change(object, "CustomPhysicalProperties", object.CurrentPhysicalProperties)
                change(object, "Material", Enum.Material.SmoothPlastic)
            end
            enforceProperty(object, "MaterialVariant", "")
            change(object, "Reflectance", 0)
            change(object, "CastShadow", false)
            if object:IsA("MeshPart") then enforceProperty(object, "TextureID", "", true) end
            if object:IsA("UnionOperation") then change(object, "UsePartColor", true) end
        elseif object:IsA("SurfaceAppearance") then
            -- PBR maps override MeshPart.TextureID and most maps cannot be changed at runtime.
            if change(object, "Parent", nil) then f.textures += 1 end
        elseif object:IsA("Decal") or object:IsA("Texture") then
            if change(object, "Parent", nil) then f.textures += 1 end
        elseif object:IsA("FileMesh") then
            enforceProperty(object, "TextureId", "", true)
        elseif object:IsA("Shirt") then
            enforceProperty(object, "ShirtTemplate", "", true)
        elseif object:IsA("Pants") then
            enforceProperty(object, "PantsTemplate", "", true)
        elseif object:IsA("ShirtGraphic") then
            enforceProperty(object, "Graphic", "", true)
        elseif object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")
            or object:IsA("Smoke") or object:IsA("Fire") or object:IsA("Sparkles")
            or object:IsA("Light") or object:IsA("PostEffect") or object:IsA("Highlight") then
            enforceProperty(object, "Enabled", false)
            if object:IsA("ParticleEmitter") then pcall(object.Clear, object) end
        elseif object:IsA("Explosion") then
            enforceProperty(object, "Visible", false)
        elseif object:IsA("Sky") or object:IsA("Atmosphere") or object:IsA("Clouds") then
            change(object, "Parent", nil)
        elseif object:IsA("Animator") and not watchedAnimators[object] then
            watchedAnimators[object] = true
            local version = generation
            -- Listen before taking the snapshot so playback started during setup is caught.
            connections[#connections + 1] = object.AnimationPlayed:Connect(function(track)
                if generation == version then stopTrack(track, object) end
            end)
            local ok, tracks = pcall(object.GetPlayingAnimationTracks, object)
            if ok then
                for _, track in ipairs(tracks) do stopTrack(track, object) end
            end
        end
    end
    local selector = "BasePart, SurfaceAppearance, Decal, Texture, FileMesh, Shirt, Pants, ShirtGraphic, "
        .. "ParticleEmitter, Trail, Beam, Smoke, Fire, Sparkles, Light, PostEffect, Highlight, "
        .. "Explosion, Sky, Atmosphere, Clouds, Animator"
    function f:setEnabled(value)
        value = value == true
        if value == self.enabled then return end
        generation += 1
        local version = generation
        self.enabled, self.busy = value, false
        if worker then pcall(task.cancel, worker) worker = nil end
        disconnectAll()
        if not value then
            -- Restore detached appearance objects only if their original parent still exists.
            for i = #records, 1, -1 do
                local record = records[i]
                pcall(function()
                    if record.property == "Parent" and record.old and record.old.Parent == nil then return end
                    if record.object[record.property] == record.applied then
                        record.object[record.property] = record.old
                    end
                end)
            end
            for _, snapshot in pairs(stoppedTracks) do
                pcall(function()
                    if not snapshot.animator:IsDescendantOf(workspace) or snapshot.track.IsPlaying then return end
                    snapshot.track:Play(0, snapshot.weight, snapshot.speed)
                    snapshot.track.TimePosition = snapshot.position
                end)
            end
            records, touched, watchedAnimators, watchedProperties, stoppedTracks = {}, {}, {}, {}, {}
            if self.renderSettings and self.previousQuality then
                pcall(function()
                    if self.renderSettings.QualityLevel == Enum.QualityLevel.Level01 then
                        self.renderSettings.QualityLevel = self.previousQuality
                    end
                end)
            end
            self.renderSettings, self.previousQuality = nil, nil
            if self.materialOverride ~= nil then
                pcall(function()
                    if MaterialService:GetBaseMaterialOverride(Enum.Material.SmoothPlastic) == "" then
                        MaterialService:SetBaseMaterialOverride(Enum.Material.SmoothPlastic, self.materialOverride)
                    end
                end)
                self.materialOverride = nil
            end
            notify()
            return
        end
        self.changedProperties, self.textures, self.stoppedTracks = 0, 0, 0
        self.busy = true
        change(Lighting, "GlobalShadows", false)
        change(Lighting, "EnvironmentDiffuseScale", 0)
        change(Lighting, "EnvironmentSpecularScale", 0)
        change(workspace.Terrain, "WaterWaveSize", 0)
        change(workspace.Terrain, "WaterWaveSpeed", 0)
        change(workspace.Terrain, "WaterReflectance", 0)
        change(workspace.Terrain, "Decoration", false)
        local qualityOk, rendering = pcall(function() return settings().Rendering end)
        if qualityOk then
            local setOk = pcall(function()
                self.previousQuality = rendering.QualityLevel
                rendering.QualityLevel = Enum.QualityLevel.Level01
            end)
            if setOk then self.renderSettings = rendering end
        end
        local overrideOk, materialOverride = pcall(MaterialService.GetBaseMaterialOverride, MaterialService, Enum.Material.SmoothPlastic)
        if overrideOk then
            self.materialOverride = materialOverride
            pcall(MaterialService.SetBaseMaterialOverride, MaterialService, Enum.Material.SmoothPlastic, "")
        end
        connections[#connections + 1] = workspace.DescendantAdded:Connect(apply)
        connections[#connections + 1] = Lighting.DescendantAdded:Connect(apply)
        notify()
        worker = task.defer(function()
            local objects = workspace:QueryDescendants(selector)
            local lightingObjects = Lighting:QueryDescendants(selector)
            for _, object in ipairs(lightingObjects) do objects[#objects + 1] = object end
            for i, object in ipairs(objects) do
                if not self.enabled or generation ~= version then return end
                apply(object)
                if i % 180 == 0 then task.wait() end
            end
            if self.enabled and generation == version then
                self.busy, worker = false, nil
                notify()
            end
        end)
    end
    function f:stop() self:setEnabled(false) end
    return f
end

-- Admin Abuse Helper.
local function createAdminHelper(player, runService, saved, changed, deps)
    saved = saved or {}
    deps = deps or {}
    local promptService = game:GetService("ProximityPromptService")
    local h = {
        alive = true, autoBuy = saved.autoBuy == true, antiRagdoll = saved.antiRagdoll == true,
        lockPosition = saved.lockPosition == true, worker = nil, heartbeat = nil,
        characterConnection = nil, humanoidConnection = nil, lockedCFrame = nil,
        status = "Admin Abuse Helper Off",
    }
    local connections, characterConnections, antiConnections = {}, {}, {}
    local visiblePrompts, visibleCount = {}, 0
    local character, humanoid, root, antiRecord, lockRecord
    local activePrompt, elapsed = nil, 0
    local updateHeartbeat, attemptPurchase
    local controls, camera = deps.controls, deps.camera
    local function serverAuthority()
        if type(deps.serverAuthority) ~= "function" then return false end
        local ok, value = pcall(deps.serverAuthority)
        return ok and value == true
    end
    local function ragdollActive()
        local ok, value = pcall(function() return player:GetAttribute("RagdollEndTime") end)
        local clockOk, now = pcall(function() return workspace:GetServerTimeNow() end)
        return ok and clockOk and type(value) == "number" and value > now
    end
    local skeletalJoints = {Root = true, RootJoint = true, Waist = true, Neck = true,
        LeftShoulder = true, RightShoulder = true, LeftElbow = true, RightElbow = true,
        LeftWrist = true, RightWrist = true, LeftHip = true, RightHip = true,
        LeftKnee = true, RightKnee = true, LeftAnkle = true, RightAnkle = true}
    local protectedStates = {
        Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Physics, Enum.HumanoidStateType.PlatformStanding,
    }
    local function emit(message)
        if message then h.status = message end
        if changed then pcall(changed, h) end
    end
    local function disconnect(list)
        for _, connection in ipairs(list) do pcall(connection.Disconnect, connection) end
        table.clear(list)
    end
    local function connect(list, signal, callback)
        local connection = signal:Connect(callback)
        list[#list + 1] = connection
        return connection
    end
    local function cancelPurchase()
        local worker = h.worker
        h.worker, activePrompt = nil, nil
        if worker then pcall(task.cancel, worker) end
    end
    local function isBadState(state)
        for _, protected in ipairs(protectedStates) do
            if protected == state then return true end
        end
        return false
    end
    local function restoreAntiRagdoll()
        disconnect(antiConnections)
        h.humanoidConnection = nil
        local record = antiRecord
        antiRecord = nil
        if not record then return end
        for object, values in pairs(record.rig or {}) do
            pcall(function()
                if object.Enabled == values.applied then
                    local restored = values.applied
                    if ragdollActive() then restored = values.original end
                    object.Enabled = restored
                end
            end)
        end
        if controls and record.controlsChanged and not h.lockPosition then
            pcall(function() if controls.controlsEnabled == true and record.controlsEnabled == false and ragdollActive() then controls:Disable() end end)
        end
        if camera and record.cameraChanged and ragdollActive() then
            pcall(function() if camera.CameraSubject == record.humanoid then camera.CameraSubject = record.cameraSubject end end)
        end
        for state, enabled in pairs(record.states) do
            pcall(function()
                -- Restore only our applied false value; preserve game changes made
                -- while the toggle was active.
                if record.humanoid:GetStateEnabled(state) == false then
                    record.humanoid:SetStateEnabled(state, enabled)
                end
            end)
        end
        if record.platformChanged then
            pcall(function()
                if record.humanoid.PlatformStand == false then
                    record.humanoid.PlatformStand = record.platformStand and ragdollActive()
                end
            end)
        end
    end
    local function applyAntiRagdoll()
        restoreAntiRagdoll()
        if not h.alive or not h.antiRagdoll or not humanoid then return end
        local current = humanoid
        local clock = deps.now or os.clock
        local record = {humanoid = current, states = {}, platformStand = current.PlatformStand,
            platformChanged = false, rig = {}, controlsEnabled = controls and controls.controlsEnabled,
            cameraSubject = camera and camera.CameraSubject}
        antiRecord = record
        if not serverAuthority() then
            for _, state in ipairs(protectedStates) do
                local ok, enabled = pcall(current.GetStateEnabled, current, state)
                if ok then
                    record.states[state] = enabled
                    pcall(current.SetStateEnabled, current, state, false)
                end
            end
        end
        local writing, lastRecovery = false, -math.huge
        local impactUntil, ragdollUntil = 0, 0
        local safeVelocity, safeTime, safeRoot = Vector3.zero, clock(), nil
        local upwardSpeed, upwardTime, airborne = 0, clock(), false
        local jumpGeneration, safeJumpGeneration, jumpQueued = 0, 0, false
        local recover
        local function hitRoot()
            if not character or player.Character ~= character or current ~= humanoid or current.Health <= 0
                or not character:IsDescendantOf(workspace) then return nil end
            local part = root and root.Parent == character and root or character:FindFirstChild("HumanoidRootPart")
            if not part or not part:IsA("BasePart") or not part:IsDescendantOf(character) then return nil end
            return part
        end
        local function locallyControlled(part)
            return not serverAuthority() and not part.Anchored and not part:GetAttribute("NetworkOwnerSet")
        end
        local function jumpSpeed()
            if current.UseJumpPower then return math.max(0, current.JumpPower) end
            return math.sqrt(2 * math.max(0, workspace.Gravity) * math.max(0, current.JumpHeight))
        end
        local function startJump(fromState)
            if h.lockPosition or current.Health <= 0 then return end
            local now = clock()
            if fromState and jumpQueued and now - upwardTime <= 0.25 then
                jumpQueued = false
                return -- The state transition belongs to the already recorded input.
            end
            if not fromState and (current.FloorMaterial == Enum.Material.Air
                or current:GetState() == Enum.HumanoidStateType.Jumping) then return end
            upwardSpeed, upwardTime, airborne = jumpSpeed(), clock(), true
            jumpGeneration += 1
            jumpQueued = not fromState
        end
        local function markImpact()
            if writing or not h.alive or not h.antiRagdoll or current ~= humanoid or current.Health <= 0 then return end
            local now = clock()
            if now >= impactUntil and now >= ragdollUntil then
                -- Use the last clean sample, not velocity already contaminated by a hit.
                local part = hitRoot()
                local clean = part and part == safeRoot and now - safeTime <= 0.25
                local pendingJump = jumpQueued and now - upwardTime <= 0.25
                if not pendingJump and (not clean or jumpGeneration <= safeJumpGeneration) then
                    upwardSpeed = clean and math.max(0, safeVelocity.Y - math.max(0, workspace.Gravity) * (now - safeTime)) or 0
                    upwardTime = now
                    airborne = current.FloorMaterial == Enum.Material.Air
                    if current.Jump then startJump()
                    elseif not clean and current:GetState() == Enum.HumanoidStateType.Jumping then startJump(true) end
                end
            end
            -- CombatController can delay its impulse for up to one second.
            impactUntil = math.max(impactUntil, now + 1.1)
        end
        local function refreshRagdollWindow()
            local ok, endTime = pcall(function() return player:GetAttribute("RagdollEndTime") end)
            local clockOk, serverNow = pcall(function() return workspace:GetServerTimeNow() end)
            if ok and clockOk and type(endTime) == "number" and endTime > serverNow then
                markImpact()
                ragdollUntil = clock() + endTime - serverNow
            else ragdollUntil = 0 end
        end
        local function correctMotion(sample)
            if not h.alive or not h.antiRagdoll then return end
            local part = hitRoot()
            if not part then return end
            local now = clock()
            if now >= impactUntil and now >= ragdollUntil then
                if sample ~= false then
                    safeVelocity, safeTime, safeRoot = part.AssemblyLinearVelocity, now, part
                    safeJumpGeneration = jumpGeneration
                end
                return
            end
            if not locallyControlled(part) then return end
            if recover then recover() end
            local velocity = part.AssemblyLinearVelocity
            local walkSpeed = math.max(0, current.WalkSpeed)
            local planarSpeed = math.sqrt(velocity.X * velocity.X + velocity.Z * velocity.Z)
            local cleanSpeed = safeRoot == part and math.sqrt(safeVelocity.X * safeVelocity.X + safeVelocity.Z * safeVelocity.Z) or 0
            local planarLimit = math.max(walkSpeed, math.min(cleanSpeed, walkSpeed * 1.5))
            -- Allow normal walking/sprinting. Large hit impulses follow the player's input.
            local x, y, z = velocity.X, velocity.Y, velocity.Z
            if planarSpeed > planarLimit + 1 then
                local direction = current.MoveDirection
                local magnitude = math.sqrt(direction.X * direction.X + direction.Z * direction.Z)
                local scale = magnitude > 1 and 1 / magnitude or 1
                if h.lockPosition then scale = 0 end
                x, z = direction.X * scale * walkSpeed, direction.Z * scale * walkSpeed
            end
            local grounded = current.FloorMaterial ~= Enum.Material.Air
            if not grounded then airborne = true end
            if grounded and airborne and velocity.Y <= 0 and current:GetState() ~= Enum.HumanoidStateType.Jumping
                and not (jumpQueued and now - upwardTime <= 0.25) then
                upwardSpeed, upwardTime, airborne = 0, now, false
            end
            local ceiling = math.max(0, upwardSpeed - math.max(0, workspace.Gravity) * (now - upwardTime))
            if y > ceiling then y = ceiling end
            -- Leave downward velocity alone: stopping a fall here would suspend the avatar.
            if x ~= velocity.X or y ~= velocity.Y or z ~= velocity.Z then
                part.AssemblyLinearVelocity = Vector3.new(x, y, z)
            end
            if part.AssemblyAngularVelocity.Magnitude > 0.01 then part.AssemblyAngularVelocity = Vector3.zero end
        end
        local function watchJoint(object)
            if record.rig[object] or serverAuthority() then return end
            local constraint = object:IsA("BallSocketConstraint")
            if not (constraint or object:IsA("AnimationConstraint") or object:IsA("Motor6D")) then return end
            local name = constraint and object.Name:gsub("BallSocket$", "") or object.Name
            if not skeletalJoints[name] then return end
            local values = {original = object.Enabled, applied = not constraint, writing = false}
            record.rig[object] = values
            local function keepJoint()
                if values.writing or not h.alive or not h.antiRagdoll or current ~= humanoid
                    or current.Health <= 0 or serverAuthority() then return end
                if object.Enabled == values.applied then return end
                markImpact()
                values.original = object.Enabled values.writing = true
                pcall(function() object.Enabled = values.applied end)
                values.writing = false
            end
            connect(antiConnections, object:GetPropertyChangedSignal("Enabled"), keepJoint)
            keepJoint()
        end
        recover = function(state)
            if writing or not h.alive or not h.antiRagdoll or current ~= humanoid or current.Health <= 0 then return end
            if clock() >= impactUntil and clock() >= ragdollUntil and not isBadState(state or current:GetState()) then return end
            writing = true
            pcall(function()
                if not serverAuthority() and current.PlatformStand then
                    record.platformStand, record.platformChanged = true, true
                    current.PlatformStand = false
                end
                if controls and not h.lockPosition and controls.controlsEnabled == false then
                    record.controlsEnabled, record.controlsChanged = false, true
                    controls:Enable()
                end
                if camera and camera.CameraSubject ~= current and camera.CameraSubject and character
                    and camera.CameraSubject:IsDescendantOf(character) then
                    record.cameraSubject, record.cameraChanged = camera.CameraSubject, true
                    camera.CameraSubject = current
                end
                if not serverAuthority() and isBadState(state or current:GetState()) and clock() - lastRecovery > 0.1 then
                    lastRecovery = clock()
                    -- GettingUp can add a stand-up kick while the rig is still being restored.
                    local nextState = current.FloorMaterial == Enum.Material.Air
                        and Enum.HumanoidStateType.Freefall or Enum.HumanoidStateType.Running
                    current:ChangeState(nextState)
                end
            end)
            writing = false
        end
        refreshRagdollWindow()
        pcall(function()
            for _, object in ipairs(character:QueryDescendants("AnimationConstraint, Motor6D, BallSocketConstraint")) do watchJoint(object) end
            connect(antiConnections, character.DescendantAdded, watchJoint)
        end)
        h.humanoidConnection = connect(antiConnections, current.StateChanged, function(previous, state)
            if writing then return end
            if state == Enum.HumanoidStateType.Jumping and previous ~= state then
                startJump(true)
            elseif isBadState(state) then
                markImpact()
                recover(state)
            end
        end)
        connect(antiConnections, current:GetPropertyChangedSignal("Jump"), function()
            if current.Jump then startJump() end
        end)
        connect(antiConnections, current:GetPropertyChangedSignal("PlatformStand"), function()
            if not writing and current.PlatformStand then markImpact() recover() end
        end)
        connect(antiConnections, current.Died, function()
            if antiRecord == record then restoreAntiRagdoll() end
        end)
        pcall(function()
            connect(antiConnections, player:GetAttributeChangedSignal("RagdollEndTime"), function()
                refreshRagdollWindow()
                task.defer(function() if antiRecord == record then recover() end end)
            end)
        end)
        if deps.impactSignal then
            connect(antiConnections, deps.impactSignal, function() markImpact() end)
        end
        if camera then connect(antiConnections, camera:GetPropertyChangedSignal("CameraSubject"), function() recover() end) end
        -- Remove impulses both before integration and after collision responses.
        if runService.PreSimulation then connect(antiConnections, runService.PreSimulation, function() correctMotion(false) end) end
        connect(antiConnections, runService.PostSimulation or runService.Heartbeat, correctMotion)
        recover()
    end

    local function releasePosition()
        local record = lockRecord
        lockRecord, h.lockedCFrame = nil, nil
        if not record then return end
        if controls and record.controlsEnabled == true then
            pcall(function() if controls.controlsEnabled == false and (h.antiRagdoll or not ragdollActive()) then controls:Enable() end end)
        end
    end
    local function capturePosition()
        releasePosition()
        if not h.alive or not h.lockPosition or not root then return end
        local ok, record = pcall(function()
            return {root = root, cframe = root.CFrame, humanoid = humanoid,
                controlsEnabled = controls and controls.controlsEnabled}
        end)
        if not ok then return end
        lockRecord, h.lockedCFrame = record, record.cframe
        pcall(function()
            if controls then controls:Disable() end
            if humanoid then
                humanoid.Jump = false humanoid:Move(Vector3.zero, false)
            end
        end)
    end
    local function currentRoot()
        if not root or not character or player.Character ~= character then return nil end
        if not root:IsDescendantOf(character) or not character:IsDescendantOf(workspace) then return nil end
        if not humanoid or humanoid.Health <= 0 then return nil end
        return root
    end
    local function brainrotPurchase(prompt)
        if not prompt:IsA("ProximityPrompt") or not prompt:IsDescendantOf(workspace)
            or not prompt:HasTag("AnimalPurchasePrompt") then return false end
        if tostring(prompt.ActionText):lower():match("^%s*(.-)%s*$") ~= "purchase" then return false end
        local model = prompt:FindFirstAncestorOfClass("Model")
        local uid = prompt:GetAttribute("UID")
        return model ~= nil and model:HasTag("Animal") and type(uid) == "string" and uid ~= ""
            and uid == model.Name and type(model:GetAttribute("Index")) == "string"
    end
    local function promptPosition(prompt)
        local parent = prompt.Parent
        if not parent then return nil end
        if parent:IsA("Attachment") then return parent.WorldPosition end
        if parent:IsA("BasePart") then return parent.Position end
        if parent:IsA("Model") then return parent:GetPivot().Position end
        return nil
    end
    local function nearbyVisible(prompt, record)
        if not h.alive or not h.autoBuy or visiblePrompts[prompt] ~= record
            or record.attempted then return nil end
        local current = currentRoot()
        if not current or not brainrotPurchase(prompt) or not prompt.Enabled
            or prompt:GetAttribute("Disabled") == true
            or prompt:GetAttribute("TargetPlayer") == player.UserId then return nil end
        local position = promptPosition(prompt)
        if not position or prompt.MaxActivationDistance <= 0 then return nil end
        local distance = (current.Position - position).Magnitude
        if distance > prompt.MaxActivationDistance then return nil end
        return distance
    end
    local function removePrompt(prompt)
        if visiblePrompts[prompt] then
            visiblePrompts[prompt] = nil
            visibleCount -= 1
        end
        if activePrompt == prompt then cancelPurchase() end
        updateHeartbeat()
    end
    local function cleanupTracked()
        local changedSet = false
        for prompt in pairs(visiblePrompts) do
            local ok, alive = pcall(function()
                return prompt:IsDescendantOf(workspace) and prompt.Enabled
            end)
            if not ok or not alive then
                visiblePrompts[prompt] = nil
                visibleCount -= 1
                changedSet = true
                if activePrompt == prompt then cancelPurchase() end
            end
        end
        return changedSet
    end
    attemptPurchase = function()
        if h.worker or not h.alive or not h.autoBuy or type(fireproximityprompt) ~= "function" then return end
        local nearest, record, best = nil, nil, math.huge
        for prompt, entry in pairs(visiblePrompts) do
            local ok, distance = pcall(nearbyVisible, prompt, entry)
            if ok and distance and distance < best then nearest, record, best = prompt, entry, distance end
        end
        if not nearest then return end
        local job
        job = task.defer(function()
            if h.worker ~= job then return end
            local ok, distance = pcall(nearbyVisible, nearest, record)
            if ok and distance then
                record.attempted = true
                emit("Purchasing Nearby Brainrot...")
                -- Activate once, after visibility and distance are revalidated.
                -- The executor prompt helper completes activation immediately.
                pcall(fireproximityprompt, nearest)
            end
            if h.worker == job then
                h.worker, activePrompt = nil, nil
                if h.alive and h.autoBuy then emit("Auto Buy Active") end
            end
        end)
        h.worker, activePrompt = job, nearest
    end
    updateHeartbeat = function()
        local needed = h.alive and (h.lockPosition or (h.autoBuy and visibleCount > 0))
        if not needed then
            if h.heartbeat then h.heartbeat:Disconnect() h.heartbeat = nil end
            return
        end
        if h.heartbeat then return end
        h.heartbeat = runService.Heartbeat:Connect(function(dt)
            if not h.alive then return end
            cleanupTracked()
            if h.lockPosition and lockRecord and currentRoot() == lockRecord.root then
                pcall(function()
                    if controls and controls.controlsEnabled then controls:Disable() end
                    if humanoid then humanoid.Jump = false humanoid:Move(Vector3.zero, false) end
                end)
            end
            if h.autoBuy and visibleCount > 0 then
                elapsed += dt
                if elapsed >= 0.1 then elapsed = 0 attemptPurchase() end
            end
            if visibleCount == 0 and not h.lockPosition then updateHeartbeat() end
        end)
    end
    local function refreshCharacterParts()
        if not h.alive or not character or player.Character ~= character then return end
        local nextHumanoid = character:FindFirstChildOfClass("Humanoid")
        local nextRoot = character:FindFirstChild("HumanoidRootPart")
        if nextRoot and not nextRoot:IsA("BasePart") then nextRoot = nil end
        local humanoidChanged = nextHumanoid ~= humanoid
        if humanoidChanged then
            restoreAntiRagdoll()
            humanoid = nextHumanoid
            applyAntiRagdoll()
            if humanoid then
                pcall(function() connect(characterConnections, humanoid.Died, function() releasePosition() end) end)
            end
        end
        if nextRoot ~= root then
            releasePosition()
            root = nextRoot
            capturePosition()
        elseif humanoidChanged and h.lockPosition then
            capturePosition()
        end
        updateHeartbeat()
    end
    local function bindCharacter(nextCharacter)
        cancelPurchase()
        disconnect(characterConnections)
        restoreAntiRagdoll()
        releasePosition()
        character, humanoid, root = nextCharacter, nil, nil
        if nextCharacter then
            connect(characterConnections, nextCharacter.ChildAdded, refreshCharacterParts)
            connect(characterConnections, nextCharacter.ChildRemoved, refreshCharacterParts)
            refreshCharacterParts()
        end
        updateHeartbeat()
    end
    function h:setAutoBuy(value)
        if not self.alive then return end
        self.autoBuy = value == true
        cancelPurchase()
        elapsed = 0
        updateHeartbeat()
        if self.autoBuy and type(fireproximityprompt) ~= "function" then
            emit("Auto Buy Needs Fireproximityprompt")
        else
            emit(self.autoBuy and "Auto Buy Active" or "Auto Buy Off")
            if self.autoBuy then attemptPurchase() end
        end
    end
    function h:setRuntime(nextControls, nextAuthority, nextImpactSignal)
        if nextControls then controls = nextControls end
        if type(nextAuthority) == "function" then deps.serverAuthority = nextAuthority end
        if nextImpactSignal then deps.impactSignal = nextImpactSignal end
        if self.antiRagdoll then applyAntiRagdoll() end
    end
    function h:setAntiRagdoll(value)
        if not self.alive then return end
        self.antiRagdoll = value == true
        applyAntiRagdoll()
        emit(self.antiRagdoll and "Anti-Ragdoll Active" or "Anti-Ragdoll Off")
    end
    function h:setLockPosition(value)
        if not self.alive then return end
        local nextValue = value == true
        if nextValue == self.lockPosition and (not nextValue or lockRecord) then return end
        self.lockPosition = nextValue
        if self.lockPosition then capturePosition() else releasePosition() end
        updateHeartbeat()
        emit(self.lockPosition and "Movement Input Locked" or "Position Lock Off")
    end
    function h:stop()
        if not self.alive then return end
        self.alive, self.autoBuy, self.antiRagdoll, self.lockPosition = false, false, false, false
        cancelPurchase()
        if self.heartbeat then self.heartbeat:Disconnect() self.heartbeat = nil end
        disconnect(connections)
        disconnect(characterConnections)
        restoreAntiRagdoll()
        releasePosition()
        table.clear(visiblePrompts)
        visibleCount = 0
        character, humanoid, root, self.characterConnection = nil, nil, nil, nil
    end
    function h:snapshot()
        return {autoBuy = self.autoBuy, antiRagdoll = self.antiRagdoll, lockPosition = self.lockPosition}
    end
    connect(connections, promptService.PromptShown, function(prompt)
        if not h.alive or visiblePrompts[prompt] or visibleCount >= 32 then return end
        local ok, purchase = pcall(brainrotPurchase, prompt)
        if not ok or not purchase then return end
        visiblePrompts[prompt] = {attempted = false}
        visibleCount += 1
        updateHeartbeat()
        if h.autoBuy then attemptPurchase() end
    end)
    connect(connections, promptService.PromptHidden, removePrompt)
    h.characterConnection = connect(connections, player.CharacterAdded, function(nextCharacter)
        if h.alive then bindCharacter(nextCharacter) end
    end)
    connect(connections, player.CharacterRemoving, function(oldCharacter)
        if oldCharacter == character then bindCharacter(nil) end
    end)
    bindCharacter(player.Character)
    if h.autoBuy then h:setAutoBuy(true)
    elseif h.lockPosition then emit("Movement Input Locked")
    elseif h.antiRagdoll then emit("Anti-Ragdoll Active") end
    return h
end


-- Send confirmed redemptions to the configured webhook once.
local function createWebhookRewardRecognizer(animals)
    local names = {}
    if type(animals) == "table" then
        for name in pairs(animals) do
            if type(name) == "string" and name ~= "" and #name <= 512 then
                names[#names + 1] = {name = name, text = name:lower():gsub("%s+", " ")}
            end
        end
    end
    table.sort(names, function(a, b) return #a.text == #b.text and a.text < b.text or #a.text > #b.text end)
    local function wordByte(value) return value ~= "" and value:match("[%w_\128-\255]") ~= nil end
    local function listGap(value)
        if value:find("[%.!?;:]") then return false end
        value = value:gsub("%f[%a]and%f[%A]", ""):gsub("[%s,'\"&]", "")
        return value == ""
    end
    return function(message)
        if type(message) ~= "string" then return nil end
        local text = message:gsub("&amp;", "&"):gsub("&apos;", "'"):gsub("&quot;", '"')
            :gsub("<[^>]*>", ""):lower():gsub("%s+", " ")
        if not text:match("%f[%a]spawned%f[%A]") and not text:match("%f[%a]received%f[%A]") then return nil end
        -- Negative/uncertain wording is deliberately left as the native message.
        for _, negative in ipairs({"not", "failed", "cannot", "invalid", "unable", "error"}) do
            if text:match("%f[%a]" .. negative .. "%f[%A]") then return nil end
        end
        if text:find("can't", 1, true) or text:find("couldn't", 1, true) or text:find("wasn't", 1, true) then return nil end
        local matches = {}
        -- Longest names claim their span first, so a shorter catalog name inside
        -- another animal cannot create a second, invented reward.
        for _, entry in ipairs(names) do
            local from = 1
            while true do
                local first, last = text:find(entry.text, from, true)
                if not first then break end
                from = last + 1
                if not wordByte(text:sub(first - 1, first - 1)) and not wordByte(text:sub(last + 1, last + 1)) then
                    local overlap = false
                    for _, existing in ipairs(matches) do
                        if first <= existing.last and last >= existing.first then overlap = true break end
                    end
                    if not overlap then matches[#matches + 1] = {first = first, last = last, name = entry.name} end
                end
            end
        end
        table.sort(matches, function(a, b) return a.first < b.first end)
        for _, entry in ipairs(matches) do
            local before = text:sub(1, entry.first - 1):gsub("['\"]", "")
            local after = text:sub(entry.last + 1):gsub("^['\"]", "")
            for _, verb in ipairs({"spawned", "received"}) do
                for _, article in ipairs({"", "a", "an", "the"}) do
                    local ending = article == "" and (verb .. "%s+$") or (verb .. "%s+" .. article .. "%s+$")
                    if before:match("%f[%a]" .. ending) then entry.reliable = true end
                end
            end
            for _, prefix in ipairs({"has%s+been", "have%s+been", "was", "were"}) do
                if after:match("^%s+" .. prefix .. "%s+spawned%f[%A]")
                    or after:match("^%s+" .. prefix .. "%s+successfully%s+spawned%f[%A]") then entry.reliable = true end
            end
            if after:match("^%s+spawned%f[%A]") then entry.reliable = true end
        end
        for index = 2, #matches do
            local previous, current = matches[index - 1], matches[index]
            if previous.reliable and listGap(text:sub(previous.last + 1, current.first - 1)) then current.reliable = true end
        end
        for index = #matches - 1, 1, -1 do
            local current, following = matches[index], matches[index + 1]
            if following.reliable and listGap(text:sub(current.last + 1, following.first - 1)) then current.reliable = true end
        end
        local result, seen = {}, {}
        for _, entry in ipairs(matches) do
            if entry.reliable and not seen[entry.name] then result[#result + 1], seen[entry.name] = entry.name, true end
        end
        return #result > 0 and table.concat(result, ", ") or nil
    end
end

local function createRedemptionWebhook(config, deps, saved)
    config, deps, saved = config or {}, deps or {}, saved or {}
    local w = {alive = true, status = "Webhook Off", postedCount = 0, failedCount = 0, pendingCount = 0}
    local history, jobs, active = {}, {}, {}
    local count, sequence = 0, 0
    local configuredLimit = tonumber(config.WebhookCacheLimit) or 256
    if configuredLimit ~= configuredLimit then configuredLimit = 256 end
    local limit = math.clamp(math.floor(configuredLimit), 1, 2048)
    local function emit(status)
        if status then w.status = status end
        if type(deps.changed) == "function" then pcall(deps.changed, w) end
    end
    local function now()
        if type(deps.now) == "function" then
            local ok, value = pcall(deps.now)
            if ok and type(value) == "number" and value == value and math.abs(value) < math.huge then return value end
        end
        return os.time()
    end
    local function codeValue(value)
        if type(value) ~= "string" then return nil end
        local code = value:match("^%s*(.-)%s*$")
        if #code == 0 or #code > 50 or not code:match("^[A-Za-z0-9]+$") then return nil end
        return code, code:lower()
    end
    local function endpoint()
        if config.WebhookEnabled ~= true then return nil, "disabled" end
        local value = config.WebhookUrl
        if type(value) ~= "string" or #value > 4096 then return nil, "invalid_url" end
        value = value:match("^%s*(.-)%s*$")
        if not value:match("^https://discord%.com/api/webhooks/%d+/[A-Za-z0-9_%.%-]+$") then
            return nil, "invalid_url"
        end
        return value
    end
    local function truncate(value, maxCharacters)
        local length = utf8.len(value)
        if not length then value = value:gsub("[\128-\255]", "") length = #value end
        if length <= maxCharacters then return value end
        local nextByte = utf8.offset(value, maxCharacters - 2)
        return value:sub(1, nextByte - 1) .. "..."
    end
    local function lowercasePlain(value)
        value = tostring(value or ""):gsub("&amp;", "&"):gsub("&apos;", "'")
            :gsub("&quot;", '"'):gsub("&lt;", "<"):gsub("&gt;", ">")
            :gsub("<[^>]*>", ""):gsub("[%z\1-\31\127]", " ")
            :gsub("[`*_~|\\]", ""):gsub("@", "(at)")
        local ok, result = pcall(function()
            local characters = {}
            for _, point in utf8.codes(value) do
                local emoji = (point >= 0x1F000 and point <= 0x1FAFF)
                    or (point >= 0x2600 and point <= 0x27BF)
                    or (point >= 0x2300 and point <= 0x23FF)
                    or (point >= 0x2190 and point <= 0x21FF)
                    or (point >= 0x2B00 and point <= 0x2BFF)
                    or point == 0xA9 or point == 0xAE or point == 0x203C or point == 0x2049
                    or point == 0x2122 or point == 0x2139 or point == 0x2934 or point == 0x2935
                    or point == 0x3030 or point == 0x303D or point == 0x3297 or point == 0x3299
                    or point == 0xFE0F or point == 0xFE0E or point == 0x200D or point == 0x20E3
                if not emoji then
                    if (point >= 0x41 and point <= 0x5A) or (point >= 0xC0 and point <= 0xD6)
                        or (point >= 0xD8 and point <= 0xDE) or (point >= 0x410 and point <= 0x42F)
                        or (point >= 0x391 and point <= 0x3A1) or (point >= 0x3A3 and point <= 0x3AB) then
                        point += 0x20
                    elseif point >= 0x400 and point <= 0x40F then point += 0x50
                    elseif point == 0x130 then point = 0x69
                    elseif point == 0x178 then point = 0xFF
                    elseif point == 0x1E9E then point = 0xDF
                    elseif ((point >= 0x100 and point <= 0x12F)
                        or (point >= 0x132 and point <= 0x137)
                        or (point >= 0x14A and point <= 0x177)) and point % 2 == 0 then point += 1
                    elseif ((point >= 0x139 and point <= 0x148)
                        or (point >= 0x179 and point <= 0x17E)) and point % 2 == 1 then point += 1 end
                    characters[#characters + 1] = utf8.char(point)
                end
            end
            return table.concat(characters)
        end)
        if not ok then result = value:gsub("[\128-\255]", ""):lower() end
        return result:lower():gsub("%s+", " "):match("^%s*(.-)%s*$")
    end
    local function rewardName(message)
        if type(deps.recognizeReward) == "function" then
            local ok, reward = pcall(deps.recognizeReward, message)
            if ok and type(reward) == "string" then
                reward = lowercasePlain(reward)
                if reward ~= "" then return truncate(reward, 256) end
            end
        end
        -- Only an explicit brainrot label is sufficient without a known-name
        -- catalog adapter. Generic "you received ..." can describe currency.
        local reward = message:match("%f[%a]brainrot%f[%A]%s*[:%-]%s*(.+)")
            or message:match("^you%s+received%s+a?%s*brainrot%s+(.+)$")
            or message:match("^spawned%s+brainrot%s*[:%-]?%s*(.+)$")
            or message:match("^brainrot%s+spawned%s*[:%-]?%s*(.+)$")
            or message:match("^successfully%s+redeemed%s+brainrot%s*[:%-]?%s*(.+)$")
            or message:match("^you%s+spawned%s+(.+)%s+brainrot[.!]?$" )
        if not reward then return nil end
        reward = reward:match("^([^!;]+)") or ""
        reward = reward:gsub("%s+has%s+been%s+spawned.*$", ""):gsub("[%.%s]+$", "")
        if reward == "" then return nil end
        return truncate(reward, 256)
    end
    local function payloadFor(code, message)
        local messageText = truncate(lowercasePlain(message), 4000)
        local reward = rewardName(messageText)
        local lines = {reward and ("brainrot: " .. reward) or "code redeemed"}
        if config.WebhookDetail ~= "reward_only" then lines[#lines + 1] = "code: " .. code:lower() end
        if not reward then lines[#lines + 1] = "game message: " .. (messageText ~= "" and messageText or "empty response") end
        return {content = truncate(table.concat(lines, "\n"), 2000), allowed_mentions = {parse = {}}}
    end
    local function oldestRemovable()
        local oldestKey, oldest
        for key, record in pairs(history) do
            if not active[record] and (not oldest or record.order < oldest.order
                or (record.order == oldest.order and key < oldestKey)) then
                oldestKey, oldest = key, record
            end
        end
        return oldestKey
    end
    local function makeRoom()
        while count >= limit do
            local oldest = oldestRemovable()
            if not oldest then return false end
            history[oldest], count = nil, count - 1
        end
        return true
    end
    local function import(records, state)
        if type(records) ~= "table" then return end
        for key, source in pairs(records) do
            local _, normalized = codeValue(key)
            if normalized and not history[normalized] then
                local actual = type(source) == "table" and source.code or key
                local code, actualKey = codeValue(actual)
                if actualKey ~= normalized then code = key end
                local order = type(source) == "table" and tonumber(source.order) or nil
                if not order or order ~= order or math.abs(order) == math.huge then order = sequence + 1 end
                sequence = math.max(sequence, order)
                local timestamp = type(source) == "table" and tonumber(source.at) or tonumber(source)
                if timestamp and (timestamp ~= timestamp or math.abs(timestamp) == math.huge) then timestamp = nil end
                history[normalized] = {code = code, at = timestamp or now(), order = order, state = state}
                count += 1
                if state == "posted" then w.postedCount += 1 end
            end
        end
    end
    import(saved.posted, "posted")
    import(saved.reserved, "reserved")
    while count > limit do
        local oldest = oldestRemovable()
        if not oldest then break end
        history[oldest], count = nil, count - 1
    end
    local function finish(record, successful, status)
        jobs[record], active[record] = nil, nil
        record.state = successful and "posted" or "failed"
        w.pendingCount = math.max(0, w.pendingCount - 1)
        if successful then w.postedCount += 1 else w.failedCount += 1 end
        if w.alive then emit(status) end
    end
    function w:successful(value, message)
        if not self.alive then return false, "stopped" end
        local url, reason = endpoint()
        if not url then
            emit(reason == "disabled" and "Webhook Off" or "Webhook URL Not Configured")
            return false, reason
        end
        local code, key = codeValue(value)
        if not code then return false, "invalid_code" end
        if history[key] then return false, "duplicate" end
        if type(deps.request) ~= "function" or type(deps.encode) ~= "function" or type(deps.defer) ~= "function" then
            emit("Webhook Transport Unavailable")
            return false, "unavailable"
        end
        if not makeRoom() then emit("Webhook Queue Full") return false, "queue_full" end
        sequence += 1
        local record = {code = code, at = now(), order = sequence, state = "reserved"}
        history[key], count, active[record] = record, count + 1, true
        self.pendingCount += 1
        local started = false
        local ok, job = pcall(deps.defer, function()
            started = true
            if not self.alive or record.state ~= "reserved" then return end
            -- Configuration may have been switched off while this job was queued.
            local currentUrl = endpoint()
            if currentUrl ~= url then finish(record, false, "Webhook Cancelled") return end
            local encoded, body = pcall(function() return deps.encode(payloadFor(code, message)) end)
            if not encoded or type(body) ~= "string" then
                finish(record, false, "Webhook Encoding Failed") return
            end
            record.state = "sending"
            local sent, response = pcall(deps.request, {
                Url = url .. "?wait=true", Method = "POST",
                Headers = {["Content-Type"] = "application/json"}, Body = body,
            })
            if not sent then finish(record, false, "Webhook Request Failed") return end
            local status = type(response) == "table" and tonumber(response.StatusCode or response.status_code or response.status) or nil
            if status and (status ~= status or status < 100 or status > 599 or status % 1 ~= 0) then status = nil end
            if status and status >= 200 and status < 300 then
                finish(record, true, "Webhook Posted")
            elseif status == 429 then
                finish(record, false, "Webhook Rate Limited")
            elseif status then
                finish(record, false, "Webhook HTTP " .. tostring(math.floor(status)))
            else finish(record, false, "Webhook Response Unclear") end
        end)
        if not ok or (job == nil and not started) then
            if active[record] then finish(record, false, "Webhook Scheduling Failed") end
            return false, "schedule_failed"
        end
        if active[record] then jobs[record] = job end
        if not started then emit("Webhook Queued") end
        return true
    end
    function w:stop()
        if not self.alive then return end
        self.alive = false
        for record, job in pairs(jobs) do
            if type(deps.cancel) == "function" then pcall(deps.cancel, job) end
            jobs[record], active[record] = nil, nil
        end
        self.pendingCount = 0
        self.status = "Webhook Stopped"
    end
    function w:snapshot()
        local snapshot = {posted = {}, reserved = {}}
        for key, record in pairs(history) do
            local target = record.state == "posted" and snapshot.posted or snapshot.reserved
            target[key] = {code = record.code, at = record.at, order = record.order}
        end
        return snapshot
    end
    local initialUrl, reason = endpoint()
    w.status = initialUrl and "Webhook Ready" or (reason == "disabled" and "Webhook Off" or "Webhook URL Not Configured")
    return w
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Input = game:GetService("UserInputService")
local Tween = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
if not player then warn("STRAWB3RRY Auto Code Redeemer: run in a client") return end
local playerGui = player:WaitForChild("PlayerGui", 20)
if not playerGui then warn("STRAWB3RRY Auto Code Redeemer: PlayerGui not ready") return end
local env = getgenv and getgenv() or _G
local KEY, GUI_NAME = "__STRAWB3RRY_auto_code_redeemer", "STRAWB3RRYAutoCodeRedeemer"
local previous = env[KEY] or env.__private_auto_code_redeemer
env.__STRAWB3RRY_settings_store = createSettingsStore(Config, {
    encode = function(value) return game:GetService("HttpService"):JSONEncode(value) end,
    decode = function(value) return game:GetService("HttpService"):JSONDecode(value) end,
    read = type(readfile) == "function" and readfile or nil,
    write = type(writefile) == "function" and writefile or nil,
})
local saved = env.__STRAWB3RRY_settings_store:load() or {}
if previous and previous.alive ~= false and not previous.closing and type(previous.snapshot) == "function" then
    local ok, snapshot = pcall(previous.snapshot)
    if ok and type(snapshot) == "table" then saved = snapshot end
end
local stopped = previous and type(previous.stop) == "function" and pcall(previous.stop)
if previous and not stopped and type(previous) == "table" then
    previous.alive = false
    for _, connection in ipairs(previous.connections or {}) do pcall(connection.Disconnect, connection) end
    for _, undo in ipairs(previous.restore or {}) do pcall(undo) end
    for thread in pairs(previous.jobs or {}) do pcall(task.cancel, thread) end
    for _, tween in pairs(previous.tweens or {}) do pcall(tween.Cancel, tween) end
end
for _, name in ipairs({GUI_NAME, "PrivateAutoCodeRedeemer"}) do
    local oldGui = playerGui:FindFirstChild(name)
    if oldGui then oldGui:Destroy() end
end
local state = {alive = true, connections = {}, jobs = {}, tweens = {}, restore = {},
    width = saved.width or 470, height = saved.height or 704, collapsed = saved.collapsed == true,
    x = saved.x, y = saved.y}
env[KEY] = state
state.submissionLedger = saved.submissionLedger or {}
state.retypeSafety, state.retypeBatch = false, false
state.riddleBeforeAuto = saved.riddleBeforeAuto == true
state.wasAutoMode = saved.autoMode == true
local engine, riddleSolver, refresh, fit, redemptionWebhook, ensureSetup, adminHelper, gui
state.stop = function()
    if not state.alive then return end
    if state.persistSettings then state.persistSettings(true) end
    if state.retypeReplay then state.retypeReplay:stop() end
    state.alive = false
    if redemptionWebhook then pcall(redemptionWebhook.stop, redemptionWebhook) end
    if state.fps then pcall(state.fps.stop, state.fps) end
    if riddleSolver then pcall(riddleSolver.stop, riddleSolver) end
    if adminHelper then pcall(adminHelper.stop, adminHelper) end
    if engine then pcall(engine.stop, engine) end
    for _, connection in ipairs(state.connections) do pcall(connection.Disconnect, connection) end
    for _, undo in ipairs(state.restore) do pcall(undo) end
    for thread in pairs(state.jobs) do pcall(task.cancel, thread) end
    for _, tween in pairs(state.tweens) do pcall(tween.Cancel, tween) end
    if gui and gui.Parent then gui:Destroy() end
    if env[KEY] == state then env[KEY] = nil end
end
local notification, notificationRemote, codesScript, codeBox, codeButton, codesFlags
local codesEnabled, buttonConnected, codeBoxReady = true, false, false
local flight, readyReason = nil, "connecting to game..."
local function connect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(state.connections, connection)
    return connection
end
local function after(seconds, callback)
    local thread
    thread = task.delay(seconds, function()
        state.jobs[thread] = nil
        if state.alive then callback() end
    end)
    state.jobs[thread] = true
    return thread
end
local function defer(callback)
    local thread
    thread = task.defer(function()
        state.jobs[thread] = nil
        if state.alive then callback() end
    end)
    state.jobs[thread] = true
    return thread
end
local function cancelJob(thread)
    if not thread then return end
    state.jobs[thread] = nil
    pcall(task.cancel, thread)
end
local function titleCase(value)
    return (value:gsub("%a[%w']*", function(word) return word:sub(1, 1):upper() .. word:sub(2) end))
end
local function animate(item, properties, duration)
    local old = state.tweens[item]
    if old then old:Cancel() end
    if state.fps and state.fps.enabled and not item:GetAttribute("STRAWB3RRY_window_animation") then
        state.tweens[item] = nil
        for key, value in pairs(properties) do item[key] = value end
        return
    end
    local tween = Tween:Create(item, TweenInfo.new(duration or 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), properties)
    state.tweens[item] = tween
    tween.Completed:Once(function() if state.tweens[item] == tween then state.tweens[item] = nil end end)
    tween:Play()
end
local function make(class, parent, properties)
    local object = Instance.new(class)
    for key, value in pairs(properties or {}) do object[key] = value end
    object.Parent = parent
    return object
end
-- One built-in Strawberry palette. All ornaments use native, passive UI shapes.
Strawberry = {
    background = Color3.fromRGB(24, 7, 13),
    surfaceTop = Color3.fromRGB(94, 18, 36),
    surfaceBottom = Color3.fromRGB(35, 8, 17),
    accent = Color3.fromRGB(232, 35, 67),
    highlight = Color3.fromRGB(255, 245, 247),
    muted = Color3.fromRGB(204, 145, 159),
    white = Color3.fromRGB(255, 255, 255),
    purple = Color3.fromRGB(255, 77, 111),
    green = Color3.fromRGB(139, 220, 154),
    red = Color3.fromRGB(255, 32, 70),
    card = Color3.fromRGB(70, 17, 31),
    field = Color3.fromRGB(36, 9, 18),
    off = Color3.fromRGB(91, 38, 51),
}

function Strawberry.shape(parent, name, x, y, w, h, color, radius, z, alpha, rotation)
    local shape = make("Frame", parent, {Name = name, Position = UDim2.fromOffset(x, y),
        Size = UDim2.fromOffset(w, h), BackgroundColor3 = color,
        BackgroundTransparency = alpha or 0, BorderSizePixel = 0,
        Active = false, Selectable = false, ZIndex = z or 1, Rotation = rotation or 0})
    if radius then make("UICorner", shape, {CornerRadius = UDim.new(0, radius)}) end
    return shape
end

function Strawberry.line(parent, name, x1, y1, x2, y2, color, z, alpha, thickness)
    local dx, dy = x2 - x1, y2 - y1
    local line = Strawberry.shape(parent, name, (x1 + x2) / 2, (y1 + y2) / 2,
        math.sqrt(dx * dx + dy * dy), thickness or 1, color, nil, z, alpha,
        math.deg(math.atan2(dy, dx)))
    line.AnchorPoint = Vector2.new(0.5, 0.5)
    return line
end

function Strawberry.icon(parent, kind, position, pixels, z, tint)
    z = z or 1
    local holder = make("Frame", parent, {Name = "Strawberry_" .. kind,
        Position = position, Size = UDim2.fromOffset(pixels, pixels),
        BackgroundTransparency = 1, Active = false, Selectable = false, ZIndex = z})
    local canvas = make("Frame", holder, {Name = "drawing", Size = UDim2.fromOffset(48, 48),
        BackgroundTransparency = 1, Active = false, Selectable = false, ZIndex = z})
    make("UIScale", canvas, {Scale = pixels / 48})
    local function part(name, x, y, w, h, color, radius, alpha, rotation)
        return Strawberry.shape(canvas, name, x, y, w, h, color, radius, z, alpha, rotation)
    end
    local function line(name, x1, y1, x2, y2, color, alpha, thickness)
        return Strawberry.line(canvas, name, x1, y1, x2, y2, color, z, alpha, thickness)
    end
    if kind == "spider" then
        local spider = tint or Strawberry.red
        for side = -1, 1, 2 do
            for leg = 0, 3 do
                local x, y = 24 + side * 8, 19 + leg * 4
                line("leg" .. side .. leg .. "a", x, y, 24 + side * 17, y - 6, spider, 0, 2)
                line("leg" .. side .. leg .. "b", 24 + side * 17, y - 6, 24 + side * 21, y + 2, spider, 0, 2)
            end
        end
        part("body", 16, 15, 17, 23, spider, 9)
        part("head", 18, 9, 13, 13, spider, 7)
        part("left_eye", 21, 14, 2, 3, Strawberry.highlight, 1)
        part("right_eye", 26, 14, 2, 3, Strawberry.highlight, 1)
    end
    return holder
end

function Strawberry.web(parent, right, width, height, z, alpha)
    local web = make("Frame", parent, {Name = right and "Strawberry_right_cobweb" or "Strawberry_left_cobweb",
        Position = right and UDim2.new(1, -width, 0, 0) or UDim2.fromOffset(0, 0),
        Size = UDim2.fromOffset(width, height), BackgroundTransparency = 1,
        Active = false, Selectable = false, ZIndex = z or 1})
    local rays = {{1, 0.1}, {0.96, 0.38}, {0.76, 0.72}, {0.4, 0.94}, {0.08, 1}}
    local function x(value) return right and width - value or value end
    for index, ray in ipairs(rays) do
        Strawberry.line(web, "ray" .. index, x(0), 0, x(width * ray[1]), height * ray[2],
            Strawberry.muted, z, alpha or 0.66)
    end
    for ring = 1, 4 do
        local factor = ring / 4
        for index = 1, #rays - 1 do
            local a, b = rays[index], rays[index + 1]
            Strawberry.line(web, "silk" .. ring .. "_" .. index,
                x(width * a[1] * factor), height * a[2] * factor,
                x(width * b[1] * factor), height * b[2] * factor,
                Strawberry.muted, z, alpha or 0.66)
        end
    end
    return web
end

function Strawberry.decorateWindow(surface, compact)
    -- Corner webs stay in the header; content and controls have no background ornaments.
    local layer = make("Frame", surface, {Name = "Strawberry_scenery", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, Active = false, Selectable = false, ClipsDescendants = true, ZIndex = 1})
    Strawberry.web(layer, false, 55, compact and 52 or 60, 1, 0.8)
    Strawberry.web(layer, true, compact and 66 or 74, compact and 52 or 60, 1, 0.76)
    return layer
end

function Strawberry.ornamentRow(parent, name, position, pixels, kinds, right, z)
    local gap, width = 6, #kinds * pixels + math.max(0, #kinds - 1) * 6
    local row = make("Frame", parent, {Name = name, Position = position,
        AnchorPoint = right and Vector2.new(1, 0) or Vector2.zero,
        Size = UDim2.fromOffset(width, pixels), BackgroundTransparency = 1,
        Active = false, Selectable = false, ZIndex = z or 1})
    for index, kind in ipairs(kinds) do
        Strawberry.icon(row, kind, UDim2.fromOffset((index - 1) * (pixels + gap), 0), pixels, z)
    end
    return row
end

function Strawberry.decorateCard(frame)
    make("UIGradient", frame, {Rotation = 100, Color = ColorSequence.new(
        Color3.fromRGB(255, 235, 220), Color3.fromRGB(183, 143, 208))})
    local seam = make("Frame", frame, {Name = "Strawberry_candle_seam", Position = UDim2.fromOffset(0, 14),
        Size = UDim2.new(0, 2, 1, -28), BackgroundColor3 = Strawberry.accent,
        BackgroundTransparency = 0.26, BorderSizePixel = 0, Active = false, Selectable = false})
    make("UICorner", seam, {CornerRadius = UDim.new(0, 2)})
end

function Strawberry.knobFace(knob)
    local z = knob.ZIndex + 1
    local face = make("Frame", knob, {Name = "Strawberry_lantern_face", Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, Active = false, Selectable = false, ZIndex = z})
    for index, x in ipairs({0.23, 0.59}) do
        make("Frame", face, {Name = "eye", Position = UDim2.fromScale(x, 0.26),
            Size = UDim2.fromScale(0.21, 0.17), Rotation = index == 1 and 28 or -28,
            BackgroundColor3 = Strawberry.background, BorderSizePixel = 0, ZIndex = z,
            Active = false, Selectable = false})
    end
    local mouth = make("Frame", face, {Name = "grin", Position = UDim2.fromScale(0.22, 0.53),
        Size = UDim2.fromScale(0.58, 0.3), BackgroundColor3 = Strawberry.background,
        BorderSizePixel = 0, ZIndex = z, Active = false, Selectable = false})
    make("UICorner", mouth, {CornerRadius = UDim.new(0.5, 0)})
    for index, x in ipairs({0.33, 0.61}) do
        make("Frame", face, {Name = "fang" .. index, Position = UDim2.fromScale(x, 0.51),
            Size = UDim2.fromScale(0.12, 0.17), BackgroundColor3 = Strawberry.white,
            BorderSizePixel = 0, ZIndex = z + 1, Active = false, Selectable = false})
    end
end
local accent, highlight, muted = Strawberry.accent, Strawberry.highlight, Strawberry.muted
local white, cardColor, fieldColor = Strawberry.white, Strawberry.card, Strawberry.field
local function mobileLayout()
    return Input.TouchEnabled and not Input.KeyboardEnabled
end
local function fitScale(width, height, area)
    local limit = mobileLayout() and 0.76 or 1
    return math.min(limit, math.max(0.1, (area.X - 24) / width), math.max(0.1, (area.Y - 24) / height))
end
local function round(object, radius) make("UICorner", object, {CornerRadius = UDim.new(0, radius)}) end
local function stroke(object, color, alpha)
    return make("UIStroke", object, {Color = color, Transparency = alpha or 0.7, Thickness = 1})
end
local function text(parent, name, value, position, size, fontSize, color, bold)
    return make("TextLabel", parent, {Name = name, Text = value, Position = position, Size = size,
        Font = bold and Enum.Font.GothamMedium or Enum.Font.Gotham, TextSize = fontSize,
        TextColor3 = color or white, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd})
end
local function button(parent, name, label, position, size)
    local b = make("TextButton", parent, {Name = name, Text = label, Position = position, Size = size,
        Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = highlight, BackgroundColor3 = accent,
        BackgroundTransparency = 0.88, AutoButtonColor = false, BorderSizePixel = 0})
    round(b, 11)
    local outline = stroke(b, accent, 0.58)
    make("UIGradient", b, {Rotation = 110, Color = ColorSequence.new(Strawberry.highlight, Strawberry.accent)})
    connect(b.MouseEnter, function() animate(outline, {Transparency = 0.2}) end)
    connect(b.MouseLeave, function() animate(outline, {Transparency = 0.58}) end)
    connect(b.MouseEnter, function() animate(b, {BackgroundTransparency = 0.72}) end)
    connect(b.MouseLeave, function() animate(b, {BackgroundTransparency = 0.88}) end)
    return b
end

gui = make("ScreenGui", playerGui, {Name = GUI_NAME, ResetOnSpawn = false, IgnoreGuiInset = false,
    DisplayOrder = 1, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
state.gui = gui
gui:SetAttribute("theme", "Strawberry")
local root = make("Frame", gui, {Name = "safe_area", Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, Active = false, Selectable = false})
-- Discord branding: centered below the Roblox top bar and kept clear of the panel title.
local discordInvite = make("TextLabel", root, {
    Name = "discord_invite",
    AnchorPoint = Vector2.new(0.5, 0),
    Position = UDim2.new(0.5, 0, 0, 76),
    Size = UDim2.fromOffset(280, 28),
    BackgroundColor3 = Strawberry.card,
    BackgroundTransparency = 0.12,
    BorderSizePixel = 0,
    Text = "discord.gg/strawberryhub",
    TextColor3 = Color3.fromRGB(255, 255, 255),
    TextSize = 13,
    Font = Enum.Font.GothamBold,
    TextScaled = false,
    TextWrapped = false,
    TextXAlignment = Enum.TextXAlignment.Center,
    ZIndex = 200,
    Active = false,
    Selectable = false,
})
round(discordInvite, 10)
local inviteStroke = stroke(discordInvite, Strawberry.red, 0.22)
make("UIGradient", discordInvite, {Rotation = 0, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(145, 12, 38)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(95, 8, 25)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 18, 45)),
})})
make("UITextSizeConstraint", discordInvite, {MinTextSize = 11, MaxTextSize = 13})
-- Strawberry seed flecks: small, passive shapes inside the invite banner.
for index, seedData in ipairs({
    {x = 13, y = 8, r = -25}, {x = 22, y = 17, r = 22},
    {x = 31, y = 7, r = 35}, {x = 249, y = 8, r = 25},
    {x = 258, y = 17, r = -22}, {x = 267, y = 7, r = -35},
}) do
    Strawberry.shape(discordInvite, "strawberry_seed_" .. index,
        seedData.x, seedData.y, 3, 6, Strawberry.white, 3, 201, 0.12, seedData.r)
end
-- Anime-lightning accents sit at the banner's edges and pulse gently; no input is intercepted.
local boltA = Strawberry.line(discordInvite, "lightning_left_a", 5, 4, 11, 11, Strawberry.highlight, 202, 0.12, 2)
local boltB = Strawberry.line(discordInvite, "lightning_left_b", 11, 11, 6, 17, Strawberry.red, 202, 0.12, 2)
local boltC = Strawberry.line(discordInvite, "lightning_right_a", 274, 4, 268, 11, Strawberry.highlight, 202, 0.12, 2)
local boltD = Strawberry.line(discordInvite, "lightning_right_b", 268, 11, 273, 17, Strawberry.red, 202, 0.12, 2)
local bannerPulse = Tween:Create(inviteStroke, TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
    Transparency = 0.62, Color = Strawberry.purple, Thickness = 2,
})
bannerPulse:Play()
table.insert(state.tweens, bannerPulse)
make("UIStroke", discordInvite, {Color = Strawberry.highlight, Transparency = 0.88, Thickness = 3})
local shadow = make("Frame", root, {Name = "shadow", BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = 0.65, BorderSizePixel = 0, ZIndex = 0})
round(shadow, 24)
local shadowScale = make("UIScale", shadow, {Scale = 1})
local panel = make("CanvasGroup", root, {Name = "panel", Size = UDim2.fromOffset(state.width, state.height),
    BackgroundColor3 = Strawberry.background, BackgroundTransparency = 1,
    BorderSizePixel = 0, GroupTransparency = 1})
round(panel, 24)
local panelStroke = stroke(panel, accent, 0.38)
local surface = make("Frame", panel, {Name = "surface", Size = UDim2.fromScale(1, 1), ZIndex = 0,
    BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0, BorderSizePixel = 0})
round(surface, 24)
make("UIGradient", surface, {Rotation = 115, Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Strawberry.surfaceTop),
    ColorSequenceKeypoint.new(1, Strawberry.surfaceBottom),
})})
Strawberry.decorateWindow(surface, false)
local scale = make("UIScale", panel, {Name = "ui_scale", Scale = 1})
local sheen = make("Frame", panel, {Name = "sheen", Size = UDim2.new(1, -50, 0, 1),
    Position = UDim2.fromOffset(25, 0), BackgroundColor3 = highlight, BackgroundTransparency = 0.4, BorderSizePixel = 0})
make("UIGradient", sheen, {Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0), NumberSequenceKeypoint.new(1, 1)})})
local header = make("Frame", panel, {Name = "header", Size = UDim2.new(1, -108, 0, 78), BackgroundTransparency = 1, Active = true})
local profile = make("CanvasGroup", panel, {Name = "profile", Position = UDim2.new(0, 24, 1, -65),
    Size = UDim2.new(1, -48, 0, 48), BackgroundTransparency = 1})
make("Frame", profile, {Position = UDim2.fromOffset(0, -8), Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = accent, BackgroundTransparency = 0.83, BorderSizePixel = 0})
local avatar = make("ImageLabel", profile, {Name = "avatar", Position = UDim2.fromOffset(0, 6),
    Size = UDim2.fromOffset(38, 38), BackgroundColor3 = Strawberry.off,
    BackgroundTransparency = 0.35, Image = "", BorderSizePixel = 0})
round(avatar, 14) stroke(avatar, accent, 0.6)
local title = text(header, "title", "STRAWB3RRY Auto Code Redeemer", UDim2.fromOffset(24, 26),
    UDim2.new(1, -24, 0, 26), 18, white, true)
title.TextScaled = true
make("UITextSizeConstraint", title, {MinTextSize = 14, MaxTextSize = 18})
local display = text(profile, "display_name", player.DisplayName, UDim2.fromOffset(52, 13),
    UDim2.new(1, -52, 0, 24), 14, white, true)
local chatButton = button(panel, "chat", "Chat", UDim2.new(1, -148, 0, 28), UDim2.fromOffset(46, 32))
chatButton.TextSize = 12
local expand = button(panel, "expand", "−", UDim2.new(1, -94, 0, 28), UDim2.fromOffset(32, 32))
local close = button(panel, "close", "×", UDim2.new(1, -54, 0, 28), UDim2.fromOffset(32, 32))
expand.TextSize, close.TextSize = 22, 23
local content = make("CanvasGroup", panel, {Name = "content", Position = UDim2.fromOffset(22, 82),
    Size = UDim2.new(1, -44, 1, -166), BackgroundTransparency = 1})
local function card(name, y, h)
    local frame = make("Frame", content, {Name = name, Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, h), BackgroundColor3 = cardColor,
        BackgroundTransparency = 0.12, BorderSizePixel = 0})
    round(frame, 16) stroke(frame, Strawberry.purple, 0.64)
    Strawberry.decorateCard(frame)
    return frame
end
local toggles = {}
local function toggle(parent, name, label, hint, y, getter, setter)
    local row = make("Frame", parent, {Name = name, Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, 56), BackgroundTransparency = 1})
    text(row, "label", label, UDim2.fromOffset(16, 16), UDim2.new(1, -100, 0, 24), 14, white, true)
    local switch = make("TextButton", row, {Name = "switch", Text = "", Position = UDim2.new(1, -65, 0, 15),
        Size = UDim2.fromOffset(48, 26), BackgroundColor3 = Strawberry.off,
        BackgroundTransparency = 0.15, AutoButtonColor = false, BorderSizePixel = 0})
    round(switch, 13)
    local outline = stroke(switch, accent, 0.76)
    connect(switch.MouseEnter, function() animate(outline, {Transparency = 0.3}) end)
    connect(switch.MouseLeave, function() animate(outline, {Transparency = 0.76}) end)
    local knob = make("Frame", switch, {Name = "knob", Position = UDim2.fromOffset(4, 4),
        Size = UDim2.fromOffset(18, 18), BackgroundColor3 = muted, BorderSizePixel = 0})
    round(knob, 9)
    Strawberry.knobFace(knob)
    local last
    local function update()
        local on = getter()
        if last == on then return end
        last = on
        switch:SetAttribute("on", on)
        animate(switch, {BackgroundColor3 = on and accent or Strawberry.off, BackgroundTransparency = 0.15})
        animate(knob, {Position = UDim2.fromOffset(on and 26 or 4, 4), BackgroundColor3 = on and white or muted})
    end
    connect(switch.Activated, function()
        setter(not getter())
        if state.persistSettings then state.persistSettings() end
    end)
    table.insert(toggles, update)
    return row
end
local switches = card("automation", 0, 224)
toggle(switches, "auto_redeem", "Auto Redeem", "listen for Sammy's code parts", 0,
    function() return engine and engine.enabled or false end,
    function(v) engine:setEnabled(v) if v then ensureSetup() end end)
make("Frame", switches, {Position = UDim2.fromOffset(16, 56), Size = UDim2.new(1, -32, 0, 1),
    BackgroundColor3 = accent, BackgroundTransparency = 0.9, BorderSizePixel = 0})
toggle(switches, "auto_part_guesser", "Auto Part Guesser", "", 56,
    function() return engine and engine.guess or false end, function(v) engine:setGuess(v) end)
make("Frame", switches, {Position = UDim2.fromOffset(16, 112), Size = UDim2.new(1, -32, 0, 1),
    BackgroundColor3 = accent, BackgroundTransparency = 0.9, BorderSizePixel = 0})
toggle(switches, "ai_riddle_solver", "AI Riddle Solver", "answers known Sammy riddles", 112,
    function() return riddleSolver and riddleSolver.enabled or false end,
    function(v)
        if engine.autoMode then engine:setAutoMode(false) end
        if state.syncAutoSolver then state.syncAutoSolver() end
        riddleSolver:setEnabled(v, true)
        state.riddleBeforeAuto = v
        if v then ensureSetup() end
    end)
make("Frame", switches, {Position = UDim2.fromOffset(16, 168), Size = UDim2.new(1, -32, 0, 1),
    BackgroundColor3 = accent, BackgroundTransparency = 0.9, BorderSizePixel = 0})
toggle(switches, "auto_mode", "Auto Mode", "", 168,
    function() return engine and engine.autoMode or false end,
    function(v)
        if v and not engine.autoMode then state.riddleBeforeAuto = riddleSolver.enabled end
        engine:setAutoMode(v)
        if state.syncAutoSolver then state.syncAutoSolver() end
        if v then ensureSetup() end
    end)
local partsCard = card("parts", 236, 106)
toggle(partsCard, "parts_mode", "Parts Mode", "wait for an exact number of parts", 0,
    function() return engine and engine.partsMode or false end, function(v) engine:setPartsMode(v) end)
local countHint = text(partsCard, "parts_label", "Parts", UDim2.fromOffset(16, 68),
    UDim2.new(1, -180, 0, 22), 11, muted)
local minus = button(partsCard, "minus", "−", UDim2.new(1, -134, 0, 63), UDim2.fromOffset(30, 30))
local amount = text(partsCard, "amount", "3", UDim2.new(1, -98, 0, 63), UDim2.fromOffset(40, 30), 15, highlight, true)
amount.TextXAlignment = Enum.TextXAlignment.Center
local plus = button(partsCard, "plus", "+", UDim2.new(1, -52, 0, 63), UDim2.fromOffset(30, 30))
connect(minus.Activated, function() engine:setAmount(engine.amount - 1) end)
connect(plus.Activated, function() engine:setAmount(engine.amount + 1) end)
local statusCard = card("status", 354, 98)
statusCard.Size = UDim2.new(1, 0, 0, 98)
local dot = make("Frame", statusCard, {Name = "dot", Position = UDim2.fromOffset(16, 20), Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = muted, BorderSizePixel = 0})
round(dot, 3)
local statusLabel = text(statusCard, "message", "Connecting To Game...", UDim2.fromOffset(30, 12),
    UDim2.new(1, -156, 0, 22), 12, white)
local progressCount = text(statusCard, "progress_count", "0 / 3 Parts", UDim2.new(1, -124, 0, 12),
    UDim2.fromOffset(108, 22), 11, highlight, true)
progressCount.TextXAlignment = Enum.TextXAlignment.Right
local codePreview = make("Frame", statusCard, {Name = "collected_preview", Position = UDim2.fromOffset(16, 42),
    Size = UDim2.new(1, -32, 0, 30), BackgroundColor3 = fieldColor,
    BackgroundTransparency = 0.22, BorderSizePixel = 0})
round(codePreview, 8) stroke(codePreview, accent, 0.83)
local preview = text(codePreview, "preview", "Waiting For Parts...", UDim2.fromOffset(12, 0),
    UDim2.new(1, -24, 1, 0), 14, highlight, true)
preview.Font = Enum.Font.Code
local progressTrack = make("Frame", statusCard, {Name = "progress_track", Position = UDim2.fromOffset(16, 82),
    Size = UDim2.new(1, -32, 0, 4), BackgroundColor3 = Strawberry.off,
    BackgroundTransparency = 0.68, BorderSizePixel = 0, ClipsDescendants = true})
round(progressTrack, 2)
local progressFill = make("Frame", progressTrack, {Name = "fill", Size = UDim2.fromScale(0, 1),
    BackgroundColor3 = Strawberry.accent, BackgroundTransparency = 0.18, BorderSizePixel = 0})
round(progressFill, 2)
progressFill.BackgroundColor3 = Color3.new(1, 1, 1)
make("UIGradient", progressFill, {Color = ColorSequence.new(Strawberry.purple, Strawberry.accent)})
local lastProgress, lastPartsRevision, lastProgressMode = -1, -1, nil
local clear = button(content, "clear", "Clear", UDim2.new(0, 6, 1, -74), UDim2.new(1 / 3, -12, 0, 30))
connect(clear.Activated, function()
    state.submissionLedger, state.retypeSafety = {}, false
    engine:clear(true) riddleSolver:clear()
    riddleSolver:setArmed(riddleSolver.enabled and not engine.autoMode)
end)
local senderButton = button(content, "sender", "Sender", UDim2.new(1 / 3, 6, 1, -74), UDim2.new(1 / 3, -12, 0, 30))
local fpsButton = button(content, "fps_boost", "FPS Boost", UDim2.new(2 / 3, 6, 1, -74), UDim2.new(1 / 3, -12, 0, 30))
fpsButton.TextSize = 12

-- Local announcement testing.
local senderShadow = make("Frame", root, {Name = "sender_shadow", Visible = false,
    BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.65,
    BorderSizePixel = 0, ZIndex = 99})
round(senderShadow, 22)
local senderShadowScale = make("UIScale", senderShadow, {Scale = 1})
local senderWindow = make("CanvasGroup", root, {Name = "announcement_sender", Visible = false,
    Size = UDim2.fromOffset(370, 300), BackgroundColor3 = Strawberry.background,
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 100})
round(senderWindow, 22) stroke(senderWindow, accent, 0.35)
local senderSurface = make("Frame", senderWindow, {Name = "surface", Size = UDim2.fromScale(1, 1), ZIndex = 0,
    BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0, BorderSizePixel = 0})
round(senderSurface, 22)
make("UIGradient", senderSurface, {Rotation = 115, Color = ColorSequence.new(
    Strawberry.surfaceTop, Strawberry.surfaceBottom)})
Strawberry.decorateWindow(senderSurface, true)
senderWindow:SetAttribute("theme", "Strawberry")
local senderScale = make("UIScale", senderWindow, {Scale = 1})
local senderHeader = make("Frame", senderWindow, {Name = "header", Size = UDim2.new(1, -108, 0, 66),
    BackgroundTransparency = 1, Active = true})
text(senderHeader, "title", "Announcement Sender", UDim2.fromOffset(22, 22), UDim2.new(1, -24, 0, 24), 16, white, true)
local senderExpand = button(senderWindow, "expand", "−", UDim2.new(1, -94, 0, 20), UDim2.fromOffset(32, 32))
senderExpand.TextSize = 22
local senderClose = button(senderWindow, "close", "×", UDim2.new(1, -54, 0, 20), UDim2.fromOffset(32, 32))
senderClose.TextSize = 23
local senderBody = make("CanvasGroup", senderWindow, {Name = "body", Position = UDim2.fromOffset(0, 66),
    Size = UDim2.new(1, 0, 1, -66), BackgroundTransparency = 1})
local announcementBox = make("TextBox", senderBody, {Name = "message", Position = UDim2.fromOffset(22, 10),
    Size = UDim2.new(1, -44, 0, 130), BackgroundColor3 = fieldColor,
    BackgroundTransparency = 0.24, Text = "", PlaceholderText = "Type An Announcement...",
    PlaceholderColor3 = muted, TextColor3 = white, TextSize = 15, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true, MultiLine = true, ClearTextOnFocus = false, BorderSizePixel = 0})
round(announcementBox, 14)
do
    local outline = stroke(announcementBox, Strawberry.purple, 0.5)
    connect(announcementBox.Focused, function() animate(outline, {Color = accent, Transparency = 0.18}) end)
    connect(announcementBox.FocusLost, function() animate(outline, {Color = Strawberry.purple, Transparency = 0.5}) end)
end
make("UIPadding", announcementBox, {PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
    PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12)})
local senderStatus = text(senderBody, "status", "Shown Only On Your Screen", UDim2.fromOffset(23, 149),
    UDim2.new(1, -46, 0, 20), 11, muted)
local send = button(senderBody, "send", "Send", UDim2.new(1, -110, 1, -52), UDim2.fromOffset(88, 32))
for _, item in ipairs({senderWindow, senderShadow, senderBody}) do item:SetAttribute("STRAWB3RRY_window_animation", true) end
local senderPosition = saved.senderPosition
local senderPointer, senderClosing = nil, false
local senderCollapsed, senderEpoch = saved.senderCollapsed == true, 0
local function fitSender(smooth, duration)
    if state.closing or senderClosing then return end
    local usable = root.AbsoluteSize
    if usable.X < 10 or usable.Y < 10 then return end
    local height = senderCollapsed and 66 or 300
    local factor = fitScale(370, height, usable)
    senderScale.Scale, senderShadowScale.Scale = factor, factor
    if not senderPosition then
        local proposedX = (state.x or 12) + state.width * scale.Scale + 18
        local x = proposedX + 370 * factor + 12 <= usable.X and proposedX or (usable.X - 370 * factor) / 2
        senderPosition = Vector2.new(x, state.y or (usable.Y - 300 * factor) / 2)
    end
    senderPosition = Vector2.new(
        math.clamp(senderPosition.X, 12, math.max(12, usable.X - 370 * factor - 12)),
        math.clamp(senderPosition.Y, 12, math.max(12, usable.Y - height * factor - 12)))
    local position = UDim2.fromOffset(senderPosition.X, senderPosition.Y)
    local size = UDim2.fromOffset(370, height)
    if smooth then animate(senderWindow, {Position = position, Size = size}, duration or 0.12)
    else senderWindow.Position, senderWindow.Size = position, size end
    senderShadow.Visible = senderWindow.Visible
    local shadowPosition = position + UDim2.fromOffset(0, 5)
    if smooth then animate(senderShadow, {Position = shadowPosition, Size = size}, duration or 0.12)
    else senderShadow.Position, senderShadow.Size = shadowPosition, size end
    senderExpand.Text = senderCollapsed and "+" or "−"
    senderWindow:SetAttribute("collapsed", senderCollapsed)
end
connect(senderButton.Activated, function()
    if state.closing then return end
    ensureSetup()
    senderEpoch += 1
    senderClosing = false
    senderWindow.Visible = true
    senderWindow.GroupTransparency = 1
    senderShadow.BackgroundTransparency = 1
    senderBody.Visible, senderBody.GroupTransparency = not senderCollapsed, 0
    fitSender(false)
    animate(senderWindow, {GroupTransparency = 0}, 0.22)
    animate(senderShadow, {BackgroundTransparency = 0.65}, 0.22)
end)
connect(senderClose.Activated, function()
    if senderClosing or state.closing then return end
    senderEpoch += 1
    local version = senderEpoch
    senderClosing = true
    announcementBox:ReleaseFocus()
    senderPointer = nil
    animate(senderWindow, {GroupTransparency = 1, Size = senderWindow.Size - UDim2.fromOffset(12, 12),
        Position = senderWindow.Position + UDim2.fromOffset(6 * senderScale.Scale, 6 * senderScale.Scale)}, 0.22)
    animate(senderShadow, {BackgroundTransparency = 1, Size = senderWindow.Size - UDim2.fromOffset(12, 12),
        Position = senderWindow.Position + UDim2.fromOffset(6 * senderScale.Scale, 6 * senderScale.Scale + 5)}, 0.22)
    after(0.24, function()
        if senderEpoch ~= version then return end
        senderWindow.Visible = false
        senderShadow.Visible = false
        senderClosing = false
        fitSender(false)
    end)
end)
connect(senderExpand.Activated, function()
    if senderClosing or state.closing then return end
    senderEpoch += 1
    local version = senderEpoch
    senderCollapsed = not senderCollapsed
    announcementBox:ReleaseFocus()
    if senderCollapsed then
        animate(senderBody, {GroupTransparency = 1}, 0.12)
        after(0.13, function() if senderEpoch == version then senderBody.Visible = false end end)
    else
        senderBody.Visible, senderBody.GroupTransparency = true, 1
        after(0.12, function()
            if senderEpoch == version then animate(senderBody, {GroupTransparency = 0}, 0.24) end
        end)
    end
    fitSender(true, 0.36)
end)
connect(senderHeader.InputBegan, function(input)
    if senderClosing or state.closing then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        senderPointer = {input = input, start = input.Position, position = senderPosition}
    end
end)
connect(Input.InputChanged, function(input)
    if not senderPointer then return end
    local mouse = senderPointer.input.UserInputType == Enum.UserInputType.MouseButton1
    if (mouse and input.UserInputType ~= Enum.UserInputType.MouseMovement) or (not mouse and input ~= senderPointer.input) then return end
    local delta = input.Position - senderPointer.start
    senderPosition = senderPointer.position + Vector2.new(delta.X, delta.Y)
    fitSender(true)
end)
connect(Input.InputEnded, function(input) if senderPointer and senderPointer.input == input then senderPointer = nil end end)
connect(Input.WindowFocusReleased, function() senderPointer = nil end)
connect(root:GetPropertyChangedSignal("AbsoluteSize"), function() if senderWindow.Visible then fitSender(false) end end)
local sendNumber = 0
connect(send.Activated, function()
    if senderClosing or state.closing then return end
    local message = announcementBox.Text:match("^%s*(.-)%s*$")
    if message == "" then senderStatus.Text = "Type A Message First" return end
    if not notificationRemote or not notificationRemote:IsDescendantOf(ReplicatedStorage) then
        senderStatus.Text = "Announcement Event Unavailable" return
    end
    if type(firesignal) ~= "function" then senderStatus.Text = "Firesignal Is Required" return end
    sendNumber += 1
    local id = "STRAWB3RRY-local-test:" .. tostring(os.clock()) .. ":" .. sendNumber
    local ok = pcall(firesignal, notificationRemote.OnClientEvent, message, 4, nil, "Top", Config.SammyUserId, id, false)
    senderStatus.Text = ok and "Sent Locally" or "Could Not Send The Local Test"
    if ok then announcementBox.Text = "" end
end)

local riddleSettingsState = saved.riddleSettings or {
    learnFacts = false, fallback = false, fallbackDelay = 0.55,
}
riddleSettingsState.learnFacts = riddleSettingsState.learnFacts == true
riddleSettingsState.fallback = riddleSettingsState.fallback == true
riddleSettingsState.fallbackDelay = math.clamp(tonumber(riddleSettingsState.fallbackDelay) or 0.55, 0, 1)
local toolRows = {}
local updateToolRows
local toolWindows = {}
local function makeToolWindow(name, title, size)
    local windowShadow = make("Frame", root, {Name = name .. "_shadow", Visible = false,
        BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = 0.65,
        BorderSizePixel = 0, ZIndex = 119})
    round(windowShadow, 24)
    local shadowScale = make("UIScale", windowShadow, {Scale = 1})
    local window = make("CanvasGroup", root, {Name = name, Visible = false,
        Size = UDim2.fromOffset(size.X, size.Y), BackgroundColor3 = Strawberry.background,
        BackgroundTransparency = 1, GroupTransparency = 1, BorderSizePixel = 0, ZIndex = 120})
    round(window, 24) stroke(window, accent, 0.38)
    local surface = make("Frame", window, {Name = "surface", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(1, 1, 1), BackgroundTransparency = 0,
        BorderSizePixel = 0, ZIndex = 0})
    round(surface, 24)
    make("UIGradient", surface, {Rotation = 115, Color = ColorSequence.new(
        Strawberry.surfaceTop, Strawberry.surfaceBottom)})
    Strawberry.decorateWindow(surface, true)
    window:SetAttribute("theme", "Strawberry")
    local header = make("Frame", window, {Name = "header", Size = UDim2.new(1, -108, 0, 62),
        BackgroundTransparency = 1, Active = true, ZIndex = 121})
    text(header, "title", title, UDim2.fromOffset(30, 19), UDim2.new(1, -40, 0, 24), 16, white, true)
    local collapseButton = button(window, "expand", "−", UDim2.new(1, -90, 0, 15), UDim2.fromOffset(32, 32))
    collapseButton.ZIndex = 122 collapseButton.TextSize = 22
    local closeButton = button(window, "close", "×", UDim2.new(1, -50, 0, 15), UDim2.fromOffset(32, 32))
    closeButton.ZIndex = 122 closeButton.TextSize = 22
    local body = make("CanvasGroup", window, {Name = "body", Position = UDim2.fromOffset(18, 62),
        Size = UDim2.new(1, -36, 1, -74), BackgroundTransparency = 1, ZIndex = 121})
    for _, item in ipairs({window, windowShadow, body}) do item:SetAttribute("STRAWB3RRY_window_animation", true) end
    local windowScale = make("UIScale", window, {Scale = 1})
    local position, pointer, closing, collapsed, epoch = nil, nil, false, false, 0
    local function hide()
        epoch += 1
        closing, pointer = false, nil
        window.Visible, windowShadow.Visible = false, false
    end
    toolWindows[#toolWindows + 1] = {window = window, shadow = windowShadow, hide = hide}
    local function place(smooth, duration)
        local area = root.AbsoluteSize
        if area.X < 10 or area.Y < 10 then return end
        local height = collapsed and 62 or size.Y
        local factor = fitScale(size.X, height, area)
        windowScale.Scale, shadowScale.Scale = factor, factor
        position = position or Vector2.new((area.X - size.X * factor) / 2, (area.Y - size.Y * factor) / 2)
        position = Vector2.new(math.clamp(position.X, 12, math.max(12, area.X - size.X * factor - 12)),
            math.clamp(position.Y, 12, math.max(12, area.Y - height * factor - 12)))
        local at, dimensions = UDim2.fromOffset(position.X, position.Y), UDim2.fromOffset(size.X, height)
        if smooth then
            animate(window, {Position = at, Size = dimensions}, duration or 0.12)
            animate(windowShadow, {Position = at + UDim2.fromOffset(0, 5), Size = dimensions}, duration or 0.12)
        else
            window.Position, window.Size = at, dimensions
            windowShadow.Position, windowShadow.Size = at + UDim2.fromOffset(0, 5), dimensions
        end
        collapseButton.Text = collapsed and "+" or "−"
        window:SetAttribute("collapsed", collapsed)
    end
    local function open()
        if state.closing then return end
        for _, other in ipairs(toolWindows) do
            if other.window ~= window then other.hide() end
        end
        epoch += 1 closing, pointer = false, nil
        local bodyTween = state.tweens[body]
        if bodyTween then bodyTween:Cancel() state.tweens[body] = nil end
        window.Visible, windowShadow.Visible = true, true
        body.Visible, body.GroupTransparency = not collapsed, 0
        place(false)
        local dimensions, at = window.Size, window.Position
        window.Size, window.Position = dimensions - UDim2.fromOffset(12, 12), at + UDim2.fromOffset(6 * windowScale.Scale, 6 * windowScale.Scale)
        window.GroupTransparency, windowShadow.BackgroundTransparency = 1, 1
        animate(window, {GroupTransparency = 0, Position = at, Size = dimensions}, 0.24)
        animate(windowShadow, {BackgroundTransparency = 0.65}, 0.24)
        updateToolRows()
    end
    local function close()
        if closing or not window.Visible then return end
        epoch += 1 local version = epoch closing, pointer = true, nil
        for _, box in ipairs(body:QueryDescendants("TextBox")) do box:ReleaseFocus() end
        animate(window, {GroupTransparency = 1, Size = window.Size - UDim2.fromOffset(12, 12),
            Position = window.Position + UDim2.fromOffset(6 * windowScale.Scale, 6 * windowScale.Scale)}, 0.22)
        animate(windowShadow, {BackgroundTransparency = 1}, 0.22)
        after(0.24, function()
            if version ~= epoch then return end
            window.Visible, windowShadow.Visible, closing = false, false, false
            place(false)
        end)
    end
    connect(closeButton.Activated, close)
    connect(collapseButton.Activated, function()
        if closing or state.closing then return end
        window.GroupTransparency, windowShadow.BackgroundTransparency = 0, 0.65
        epoch += 1 local version = epoch collapsed = not collapsed
        if collapsed then
            animate(body, {GroupTransparency = 1}, 0.12)
            after(0.13, function() if version == epoch then body.Visible = false end end)
        else
            body.Visible, body.GroupTransparency = true, 1
            after(0.12, function() if version == epoch then animate(body, {GroupTransparency = 0}, 0.24) end end)
        end
        place(true, 0.36)
    end)
    connect(header.InputBegan, function(input)
        if closing or state.closing then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            window.GroupTransparency, windowShadow.BackgroundTransparency = 0, 0.65
            pointer = {input = input, start = input.Position, position = position or Vector2.zero}
        end
    end)
    connect(Input.InputChanged, function(input)
        if not pointer then return end
        local mouse = pointer.input.UserInputType == Enum.UserInputType.MouseButton1
        if (mouse and input.UserInputType ~= Enum.UserInputType.MouseMovement) or (not mouse and input ~= pointer.input) then return end
        local delta = input.Position - pointer.start
        position = pointer.position + Vector2.new(delta.X, delta.Y) place(true)
    end)
    connect(Input.InputEnded, function(input) if pointer and pointer.input == input then pointer = nil end end)
    connect(Input.WindowFocusReleased, function() pointer = nil end)
    connect(root:GetPropertyChangedSignal("AbsoluteSize"), function() if window.Visible and not closing then place(false) end end)
    return window, body, open
end
local function toolToggle(parent, name, label, y, getter, setter)
    local row = make("Frame", parent, {Name = name, Position = UDim2.fromOffset(0, y),
        Size = UDim2.new(1, 0, 0, 42), BackgroundTransparency = 1, ZIndex = 122})
    text(row, "label", label, UDim2.fromOffset(24, 9), UDim2.new(1, -108, 0, 24), 13, white, true)
    local switch = make("TextButton", row, {Name = "switch", Text = "", Position = UDim2.new(1, -68, 0, 8),
        Size = UDim2.fromOffset(44, 24), BackgroundColor3 = Strawberry.off,
        BackgroundTransparency = 0.15, AutoButtonColor = false, BorderSizePixel = 0, ZIndex = 123})
    round(switch, 12)
    local knob = make("Frame", switch, {Name = "knob", Position = UDim2.fromOffset(4, 4),
        Size = UDim2.fromOffset(16, 16), BackgroundColor3 = muted, BorderSizePixel = 0, ZIndex = 124})
    round(knob, 8)
    Strawberry.knobFace(knob)
    switch:SetAttribute("STRAWB3RRY_window_animation", true)
    knob:SetAttribute("STRAWB3RRY_window_animation", true)
    local lastOn
    local function update()
        local on = getter() == true
        if on == lastOn then return end
        switch:SetAttribute("on", on)
        local trackColor = on and accent or Strawberry.off
        local knobProperties = {Position = UDim2.fromOffset(on and 24 or 4, 4),
            BackgroundColor3 = on and white or muted}
        if lastOn == nil then
            switch.BackgroundColor3 = trackColor
            knob.Position, knob.BackgroundColor3 = knobProperties.Position, knobProperties.BackgroundColor3
        else
            animate(switch, {BackgroundColor3 = trackColor}, 0.18)
            animate(knob, knobProperties, 0.18)
        end
        lastOn = on
    end
    update()
    connect(switch.Activated, function()
        setter(not (getter() == true)) update()
        if state.persistSettings then state.persistSettings() end
    end)
    toolRows[#toolRows + 1] = update
    return row
end
local function toolSection(parent, name, y, height)
    local section = make("Frame", parent, {Name = name, Position = UDim2.fromOffset(12, y),
        Size = UDim2.new(1, -24, 0, height), BackgroundColor3 = cardColor,
        BackgroundTransparency = 0.12, BorderSizePixel = 0, ZIndex = 0})
    round(section, 16) stroke(section, Strawberry.purple, 0.64)
    Strawberry.decorateCard(section)
    return section
end
local function toolDivider(parent, name, y, inset)
    inset = inset or 24
    return make("Frame", parent, {Name = name, Position = UDim2.fromOffset(inset, y),
        Size = UDim2.new(1, -inset * 2, 0, 1), BackgroundColor3 = accent,
        BackgroundTransparency = 0.78, BorderSizePixel = 0, ZIndex = 1})
end
updateToolRows = function()
    for _, update in ipairs(toolRows) do pcall(update) end
end
local riddleButton = button(content, "riddle_settings", "Riddle Settings", UDim2.new(0, 6, 1, -36), UDim2.new(1 / 3, -12, 0, 30))
local retypeButton = button(content, "retype", "Retype", UDim2.new(1 / 3, 6, 1, -36), UDim2.new(1 / 3, -12, 0, 30))
local adminButton = button(content, "admin_abuse_helper", "Admin Abuse Helper", UDim2.new(2 / 3, 6, 1, -36), UDim2.new(1 / 3, -12, 0, 30))
for _, footerButton in ipairs({clear, senderButton, fpsButton, riddleButton, retypeButton, adminButton}) do
    footerButton.TextSize = 13
    footerButton.TextScaled = true
    make("UITextSizeConstraint", footerButton, {MinTextSize = 10, MaxTextSize = 13})
    footerButton:SetAttribute("STRAWB3RRY_window_animation", true)
    make("UIPadding", footerButton, {PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 3), PaddingBottom = UDim.new(0, 3)})
end
local riddleWindow, riddleBody, openRiddleWindow = makeToolWindow("riddle_settings_window", "Riddle Settings", Vector2.new(390, 386))
local riddleStatus = text(riddleBody, "status", "AI Riddle Solver", UDim2.fromOffset(12, 0), UDim2.new(1, -24, 0, 24), 12, highlight, true)
toolDivider(riddleBody, "status_divider", 26, 12)
toolSection(riddleBody, "solver_options_panel", 32, 96)
toolDivider(riddleBody, "solver_options_divider", 80)
toolSection(riddleBody, "fallback_options_panel", 136, 62)
toolDivider(riddleBody, "footer_divider", 208, 12)
toolRows[#toolRows + 1] = function()
    if riddleSolver then
        riddleStatus.Text = (riddleSolver.enabled and "Solver On" or "Solver Off") .. " · " .. riddleSolver.learnedCount .. " Learned Answers"
    end
end
toolToggle(riddleBody, "learn_facts", "Learn Facts From Sammy", 36,
    function() return riddleSettingsState.learnFacts end,
    function(v) riddleSettingsState.learnFacts = v if riddleSolver then riddleSolver:setSettings(riddleSettingsState) end end)
toolToggle(riddleBody, "fallback", "Fallback (Database Guesses)", 82,
    function() return riddleSettingsState.fallback end,
    function(v) riddleSettingsState.fallback = v if riddleSolver then riddleSolver:setSettings(riddleSettingsState) end end)
text(riddleBody, "delay_label", "Guess Delay (0–1 Seconds)", UDim2.fromOffset(24, 155), UDim2.new(1, -150, 0, 22), 12, muted)
local fallbackDelayBox = make("TextBox", riddleBody, {Name = "fallback_delay", Text = string.format("%.2f", riddleSettingsState.fallbackDelay),
    Position = UDim2.new(1, -114, 0, 151), Size = UDim2.fromOffset(90, 32), BackgroundColor3 = fieldColor,
    BackgroundTransparency = 0.24, TextColor3 = highlight, TextSize = 13, Font = Enum.Font.Code,
    ClearTextOnFocus = false, BorderSizePixel = 0, ZIndex = 123})
round(fallbackDelayBox, 8)
do
    local outline = stroke(fallbackDelayBox, Strawberry.purple, 0.5)
    connect(fallbackDelayBox.Focused, function() animate(outline, {Color = accent, Transparency = 0.18}) end)
    connect(fallbackDelayBox.FocusLost, function() animate(outline, {Color = Strawberry.purple, Transparency = 0.5}) end)
end
connect(fallbackDelayBox.FocusLost, function()
    local value = math.clamp(tonumber(fallbackDelayBox.Text) or 0.55, 0, 1)
    riddleSettingsState.fallbackDelay = value fallbackDelayBox.Text = string.format("%.2f", value)
    if riddleSolver then riddleSolver:setSettings(riddleSettingsState) end
end)
local clearRiddle = button(riddleBody, "clear_answers", "Clear Pending Answers", UDim2.fromOffset(12, 220), UDim2.new(1, -24, 0, 32))
connect(clearRiddle.Activated, function() if riddleSolver then riddleSolver:clear() end end)
local riddleInfo = text(riddleBody, "info", "Unknown clues use random database answers when fallback is on.",
    UDim2.fromOffset(12, 264), UDim2.new(1, -24, 0, 40), 11, muted)
riddleInfo.TextWrapped = true
local adminWindow, adminBody, openAdminWindow = makeToolWindow("admin_abuse_helper_window", "Admin Abuse Helper", Vector2.new(390, 270))
local adminStatus = text(adminBody, "status", "Local Helper Off", UDim2.fromOffset(12, 0), UDim2.new(1, -24, 0, 24), 12, highlight, true)
toolDivider(adminBody, "status_divider", 26, 12)
toolSection(adminBody, "helper_options_panel", 30, 126)
toolDivider(adminBody, "auto_buy_divider", 72)
toolDivider(adminBody, "anti_ragdoll_divider", 114)
toolDivider(adminBody, "footer_divider", 160, 12)
local helperRuntimeLoaded = false
local function loadHelperRuntime()
    if helperRuntimeLoaded then return end
    local controls, authority, impactSignal
    local ok = pcall(function()
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local controller = controllers and controllers:FindFirstChild("CharacterController")
        if controller then controls = require(controller).Controls end
        local shared = ReplicatedStorage:FindFirstChild("Shared")
        local module = shared and shared:FindFirstChild("ServerAuthority")
        if module then authority = require(module).isEnabled end
    end)
    if not ok then return end
    helperRuntimeLoaded = true
    -- Observe the existing combat remote. Reading Start's upvalues avoids
    -- creating or guessing an obfuscated remote name through Net.
    pcall(function()
        local read = (type(getupvalues) == "function" and getupvalues) or (debug and debug.getupvalues)
        local controllers = ReplicatedStorage:FindFirstChild("Controllers")
        local module = controllers and controllers:FindFirstChild("CombatController")
        if not read or not module then return end
        local combat = require(module)
        if type(combat.Start) ~= "function" then return end
        local values = read(combat.Start)
        if type(values) ~= "table" then return end
        local remote
        for _, value in pairs(values) do
            if typeof(value) == "Instance" and value:IsA("RemoteEvent") then
                if remote then return end -- Never guess between unrelated events.
                remote = value
            end
        end
        if remote then impactSignal = remote.OnClientEvent end
    end)
    if adminHelper then adminHelper:setRuntime(controls, authority, impactSignal) end
end
adminHelper = createAdminHelper(player, RunService, saved.adminAbuse, function(h)
    if adminStatus then adminStatus.Text = h.status end
    if state.persistSettings then state.persistSettings() end
end,
    {camera = workspace.CurrentCamera})
toolToggle(adminBody, "auto_buy", "Auto Buy Brainrots", 30,
    function() return adminHelper and adminHelper.autoBuy end,
    function(v) if adminHelper then adminHelper:setAutoBuy(v) end end)
toolToggle(adminBody, "anti_ragdoll", "Anti-Ragdoll", 72,
    function() return adminHelper and adminHelper.antiRagdoll end,
    function(v) if adminHelper then if v then loadHelperRuntime() end adminHelper:setAntiRagdoll(v) end end)
toolToggle(adminBody, "lock_position", "Lock Position (Input)", 114,
    function() return adminHelper and adminHelper.lockPosition end,
    function(v) if adminHelper then if v then loadHelperRuntime() end adminHelper:setLockPosition(v) end end)
local adminInfo = text(adminBody, "info", "Locks Your Movement. Hits Can Still Push You.", UDim2.fromOffset(12, 166),
    UDim2.new(1, -24, 0, 24), 11, muted)
adminInfo.Size = UDim2.new(1, -68, 0, 24)
Strawberry.ornamentRow(adminBody, "Strawberry_footer_ornaments", UDim2.new(1, -12, 0, 166), 24, {"spider"}, true, 123)
connect(riddleButton.Activated, openRiddleWindow)
connect(adminButton.Activated, openAdminWindow)

-- Drag, resize and collapse.
local handles = {}
for _, corner in ipairs({"top_right", "bottom_right"}) do
    local h = make("TextButton", panel, {Name = "resize_" .. corner, Text = corner == "bottom_right" and "◢" or "",
        Position = corner == "top_right" and UDim2.new(1, -18, 0, 0) or UDim2.new(1, -18, 1, -18),
        Size = UDim2.fromOffset(18, 18), BackgroundTransparency = 1, TextColor3 = accent,
        TextTransparency = 0.3, TextSize = 12, AutoButtonColor = false, ZIndex = 20})
    handles[corner] = h
end
fit = function(smooth, duration)
    if not state.alive or state.closing then return end
    local usable = root.AbsoluteSize
    if usable.X < 10 or usable.Y < 10 then return end
    local mobile = mobileLayout()
    if not mobile then
        state.width = math.clamp(state.width, 430, math.max(430, math.min(760, usable.X - 24)))
        state.height = math.clamp(state.height, 704, math.max(704, math.min(760, usable.Y - 24)))
    end
    local w = state.collapsed and 430 or (mobile and math.min(state.width, 430) or state.width)
    local h = state.collapsed and 86 or (mobile and math.min(state.height, 704) or state.height)
    local factor = fitScale(w, h, usable)
    scale.Scale, shadowScale.Scale = factor, factor
    state.x = math.clamp(state.x or (usable.X - w * factor) / 2, 12, math.max(12, usable.X - w * factor - 12))
    state.y = math.clamp(state.y or (usable.Y - h * factor) / 2, 12, math.max(12, usable.Y - h * factor - 12))
    local props = {Position = UDim2.fromOffset(state.x, state.y), Size = UDim2.fromOffset(w, h)}
    if smooth then animate(panel, props, duration or 0.12)
    else for key, value in pairs(props) do panel[key] = value end end
    local shadowProps = {Position = props.Position + UDim2.fromOffset(0, 5), Size = props.Size}
    if smooth then animate(shadow, shadowProps, duration or 0.12)
    else for key, value in pairs(shadowProps) do shadow[key] = value end end
    for _, handle in pairs(handles) do handle.Visible = not state.collapsed and not mobile end
    expand.Text = state.collapsed and "+" or "−"
    gui:SetAttribute("collapsed", state.collapsed)
    gui:SetAttribute("mobile_layout", mobile)
end
local pointer
local function beginPointer(input, mode)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
    pointer = {input = input, mode = mode, start = input.Position, x = state.x, y = state.y,
        width = state.width, height = state.height, factor = scale.Scale}
    animate(panelStroke, {Transparency = 0.14})
end
connect(header.InputBegan, function(input) beginPointer(input, "move") end)
for mode, handle in pairs(handles) do connect(handle.InputBegan, function(input) beginPointer(input, mode) end) end
connect(Input.InputChanged, function(input)
    if not pointer then return end
    local mouse = pointer.input.UserInputType == Enum.UserInputType.MouseButton1
    if (mouse and input.UserInputType ~= Enum.UserInputType.MouseMovement) or (not mouse and input ~= pointer.input) then return end
    local delta = input.Position - pointer.start
    if pointer.mode == "move" then state.x, state.y = pointer.x + delta.X, pointer.y + delta.Y
    else
        state.width = pointer.width + delta.X / pointer.factor
        if pointer.mode == "top_right" then
            state.height = math.clamp(pointer.height - delta.Y / pointer.factor, 704, 760)
            state.y = pointer.y + (pointer.height - state.height) * pointer.factor
        else state.height = pointer.height + delta.Y / pointer.factor end
    end
    fit(true)
end)
local function endPointer() pointer = nil animate(panelStroke, {Transparency = 0.38}) end
connect(Input.InputEnded, function(input) if pointer and pointer.input == input then endPointer() end end)
connect(Input.WindowFocusReleased, endPointer)
connect(root:GetPropertyChangedSignal("AbsoluteSize"), function() fit(false) end)
local windowEpoch = 0
local function setCollapsed(value)
    windowEpoch += 1
    local version = windowEpoch
    state.collapsed = value
    if value then
        animate(content, {GroupTransparency = 1}, 0.12)
        animate(profile, {GroupTransparency = 1}, 0.12)
        after(0.13, function()
            if windowEpoch == version then content.Visible = false profile.Visible = false end
        end)
    else
        content.Visible, profile.Visible = true, true
        content.GroupTransparency, profile.GroupTransparency = 1, 1
        after(0.12, function()
            if windowEpoch == version then
                animate(content, {GroupTransparency = 0}, 0.24)
                animate(profile, {GroupTransparency = 0}, 0.24)
            end
        end)
    end
    fit(true, 0.36)
end
connect(expand.Activated, function() setCollapsed(not state.collapsed) end)
connect(chatButton.Activated, function()
    -- Enable Roblox's modern chat UI as well as the legacy CoreGui chat.
    -- This button cannot override chat disabled by the experience or account settings.
    local success = false
    local okTextChat = pcall(function()
        local textChatService = game:GetService("TextChatService")
        local windowConfig = textChatService:FindFirstChildOfClass("ChatWindowConfiguration")
        local inputConfig = textChatService:FindFirstChildOfClass("ChatInputBarConfiguration")
        if windowConfig then windowConfig.Enabled = true end
        if inputConfig then inputConfig.Enabled = true end
        success = (windowConfig ~= nil or inputConfig ~= nil)
    end)
    local okCoreGui = pcall(function()
        game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
        success = true
    end)
    if success and (okTextChat or okCoreGui) then
        chatButton.Text = "Chat ✓"
    else
        chatButton.Text = "Chat !"
        after(1.5, function()
            if chatButton and chatButton.Parent then chatButton.Text = "Chat" end
        end)
    end
end)
connect(player:GetPropertyChangedSignal("DisplayName"), function() display.Text = player.DisplayName end)
after(0, function()
    local ok, url = pcall(Players.GetUserThumbnailAsync, Players, player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    if state.alive and ok then avatar.Image = url end
end)

local function resolve(rootObject, names)
    local current = rootObject
    for _, name in ipairs(names) do
        current = current and current:FindFirstChild(name)
        if not current then return nil end
    end
    return current
end

local boxActiveConnection
local function refreshCodeObjects()
    local box = resolve(playerGui, {"Codes", "Codes", "CodeRedeem", "TextBox"})
    local confirm = resolve(playerGui, {"Codes", "Codes", "Confirm"})
    if not box or not box:IsA("TextBox") or not confirm or not confirm:IsA("GuiButton") then
        if boxActiveConnection then boxActiveConnection:Disconnect() boxActiveConnection = nil end
        codeBox, codeButton, buttonConnected, codeBoxReady = nil, nil, false, false
        return
    end
    if confirm ~= codeButton then buttonConnected = false end
    if box ~= codeBox then
        if boxActiveConnection then boxActiveConnection:Disconnect() end
        codeBox = box
        codeBoxReady = box.Active
        boxActiveConnection = connect(box:GetPropertyChangedSignal("Active"), function()
            if box ~= codeBox then return end
            codeBoxReady = false
            if not box.Active then return end
            defer(function()
                if box ~= codeBox or not box.Active then return end
                codeBoxReady = true
                if flight and flight.box == box then
                    local missed = flight
                    flight = nil
                    local ok, err = pcall(missed.callback, false, "Game Reply Not Captured")
                    if not ok then warn("STRAWB3RRY Auto Code Redeemer: " .. tostring(err)) end
                end
                if engine then engine:wake() end
                if riddleSolver then riddleSolver:wake() end
            end)
        end)
    end
    codeButton = confirm
end
local function adapterReady()
    if state.retypeBatch then return false, "Retyping Recent Announcements..." end
    if not notificationRemote or not notificationRemote:IsDescendantOf(ReplicatedStorage) then
        return false, readyReason or "Waiting For The Announcement Event"
    end
    if not notification or not state.responsesConnected then return false, "Response Listener Unavailable" end
    if type(firesignal) ~= "function" or type(getconnections) ~= "function" then return false, "Executor Needs Firesignal And Getconnections" end
    if not codesEnabled then return false, "Codes Are Disabled By The Game" end
    if flight or (engine and engine.pending) or (riddleSolver and riddleSolver.pending) then return false, "Waiting For The Game To Finish" end
    if not codeBox or not codeBox.Parent or not codeButton or not codeButton.Parent then refreshCodeObjects() end
    if not codeBox or not codeButton then return false, "Waiting For The Game's Code Box" end
    if not codeBox.Active or not codeBoxReady then return false, "Waiting For The Game To Finish" end
    if not buttonConnected then
        buttonConnected = #getconnections(codeButton.Activated) > 0
        if not buttonConnected then return false, "Waiting For The Confirm Button" end
    end
    return true
end
refresh = function()
    if not engine or not state.alive then return end
    if state.syncAutoSolver then state.syncAutoSolver() end
    if updateToolRows then updateToolRows() end
    for _, update in ipairs(toggles) do update() end
    amount.Text = tostring(engine.amount)
    amount.TextTransparency = engine.partsMode and 0 or 0.55
    countHint.Text = engine.partsMode and "Parts Required"
        or (engine.guess and "Guess Each Part" or "Single Code")
    local activeRiddle = riddleSolver and riddleSolver.enabled and (riddleSolver.armed or riddleSolver.pending ~= nil or #riddleSolver.answers > 0 or not engine.autoMode)
    statusLabel.Text = titleCase(activeRiddle and riddleSolver.status or engine.status)
    local collected = activeRiddle and #riddleSolver.answers or #engine.parts
    local target = engine.partsMode and engine.amount or 1
    local shown = math.min(collected, target)
    local fraction = math.clamp(shown / target, 0, 1)
    local unknownTotal = activeRiddle or engine.guess or engine.autoWaiting
    progressCount.Text = activeRiddle and (collected .. (collected == 1 and " Riddle Answer" or " Riddle Answers"))
        or (engine.autoWaiting and "Armed" or (engine.guess
        and (collected .. (collected == 1 and " Part" or " Parts"))
        or (engine.partsMode and (shown .. " / " .. target .. " Parts")
        or (shown .. " / 1 Code"))))
    if lastPartsRevision ~= (activeRiddle and riddleSolver.revision or engine.partsRevision) then
        lastPartsRevision = activeRiddle and riddleSolver.revision or engine.partsRevision
        preview.Text = collected > 0 and table.concat(activeRiddle and riddleSolver.answers or engine.parts, " + ")
            or (engine.autoWaiting and "Waiting For Sammy..." or "Waiting For Parts...")
        preview.TextColor3 = collected > 0 and highlight or muted
    end
    local mode = unknownTotal and (((activeRiddle and riddleSolver.pending) or (engine.pending and not engine.halted)) and "Checking" or "Waiting") or "Parts"
    local static = state.fps and state.fps.enabled
    local modeKey = mode .. (static and "Static" or "Animated")
    if lastProgressMode ~= modeKey then
        lastProgressMode, lastProgress = modeKey, -1
        local old = state.tweens[progressFill]
        if old then old:Cancel() state.tweens[progressFill] = nil end
        progressFill.Position = UDim2.fromScale(0, 0)
        progressFill.Visible = mode ~= "Waiting"
        if mode == "Checking" then
            progressFill.Size = UDim2.fromScale(0.22, 1)
            if not static then
                local sweep = Tween:Create(progressFill, TweenInfo.new(0.65, Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut, -1, true), {Position = UDim2.fromScale(0.78, 0)})
                state.tweens[progressFill] = sweep
                sweep:Play()
            end
        else progressFill.Size = UDim2.fromScale(0, 1) end
    end
    if mode == "Parts" and lastProgress ~= fraction then
        lastProgress = fraction
        if fraction == 0 then
            if state.tweens[progressFill] then state.tweens[progressFill]:Cancel() end
            progressFill.Size = UDim2.fromScale(0, 1)
        else animate(progressFill, {Size = UDim2.fromScale(fraction, 1)}, 0.14) end
    end
    progressTrack:SetAttribute("collected", collected)
    progressTrack:SetAttribute("target", unknownTotal and -1 or target)
    progressTrack:SetAttribute("fraction", unknownTotal and -1 or fraction)
    progressTrack:SetAttribute("activity", mode)
    dot.BackgroundColor3 = (engine.enabled or engine.autoMode or activeRiddle) and Strawberry.green or muted
    gui:SetAttribute("enabled", engine.enabled)
    gui:SetAttribute("auto_mode", engine.autoMode)
    gui:SetAttribute("auto_waiting", engine.autoWaiting)
    gui:SetAttribute("riddle_solver", activeRiddle == true)
    gui:SetAttribute("riddle_answers", riddleSolver and #riddleSolver.answers or 0)
    gui:SetAttribute("parts_collected", #engine.parts)
    gui:SetAttribute("status", engine.status)
    gui:SetAttribute("last_response", engine.lastResponse)
    gui:SetAttribute("last_submitted", engine.lastSubmitted)
    gui:SetAttribute("submissions", engine.submissions or 0)
    gui:SetAttribute("ready", notificationRemote ~= nil and state.responsesConnected == true)
    gui:SetAttribute("submission_method", "Button")
    gui:SetAttribute("collection_latency_ms", (engine.lastLatency or 0) * 1000)
end
local refreshQueued = false
local function requestRefresh()
    if state.persistSettings then state.persistSettings() end
    if refreshQueued or not state.alive then return end
    refreshQueued = true
    defer(function()
        refreshQueued = false
        if state.alive then refresh() end
    end)
end
local webhookHttp = game:GetService("HttpService")
local webhookRequest = type(request) == "function" and request
    or (type(http_request) == "function" and http_request)
    or (type(syn) == "table" and type(syn.request) == "function" and syn.request)
local webhookRecognizer
local function recognizeWebhookReward(message)
    if not webhookRecognizer then
        local animalsData
        pcall(function()
            local datas = ReplicatedStorage:FindFirstChild("Datas")
            local animals = datas and datas:FindFirstChild("Animals")
            if animals then animalsData = require(animals) end
        end)
        webhookRecognizer = createWebhookRewardRecognizer(animalsData)
    end
    return webhookRecognizer(message)
end
redemptionWebhook = createRedemptionWebhook(Config, {
    defer = defer, cancel = cancelJob, now = os.clock, request = webhookRequest,
    encode = function(payload) return webhookHttp:JSONEncode(payload) end,
    recognizeReward = recognizeWebhookReward,
    changed = function(w)
        gui:SetAttribute("webhook_status", w.status)
        gui:SetAttribute("webhook_enabled", Config.WebhookEnabled == true)
        gui:SetAttribute("webhook_posts", w.postedCount)
        gui:SetAttribute("webhook_failures", w.failedCount)
    end,
}, saved.webhook)
state.webhook = redemptionWebhook
gui:SetAttribute("webhook_status", redemptionWebhook.status)
gui:SetAttribute("webhook_enabled", Config.WebhookEnabled == true)
-- Read live game state for riddles. The game already exposes active event
-- mutations through Shared.Mutations and public per-brainrot counts through
-- ReplicatorClient.PublicExistCounts; no remotes are fired here.
local liveRiddleCache = {}
local function liveNormalize(value)
    return tostring(value or ""):lower():gsub("’", "'"):gsub("'", "")
        :gsub("[^%w]+", " "):gsub("%s+", " "):match("^%s*(.-)%s*$")
end
local function liveHasWord(question, word)
    return (" " .. question .. " "):find(" " .. word .. " ", 1, true) ~= nil
end
local function liveHasPhrase(question, phrase)
    return (" " .. question .. " "):find(" " .. phrase .. " ", 1, true) ~= nil
end
local function liveAsset(value)
    return tostring(value or ""):lower():gsub("%s+", "")
end
local function loadLiveRiddleData()
    local data = liveRiddleCache
    local datas = ReplicatedStorage:FindFirstChild("Datas")
    local shared = ReplicatedStorage:FindFirstChild("Shared")
    local packages = ReplicatedStorage:FindFirstChild("Packages")
    local function loadModule(parent, name, field)
        if data[field] then return end
        local object = parent and parent:FindFirstChild(name)
        if not object then return end
        local ok, value = pcall(require, object)
        if ok and value ~= nil then data[field] = value end
    end
    -- Load each source independently. A transient missing module must not
    -- permanently poison every other live source.
    loadModule(datas, "Animals", "animals")
    loadModule(datas, "Mutations", "mutations")
    loadModule(datas, "Traits", "traits")
    loadModule(shared, "Mutations", "sharedMutations")
    if not data.publicCounts then
        local object = packages and packages:FindFirstChild("ReplicatorClient")
        if object then
            local ok, replicator = pcall(require, object)
            if ok and type(replicator) == "table" and type(replicator.get) == "function" then
                local got, value = pcall(replicator.get, "PublicExistCounts")
                if not got or value == nil then got, value = pcall(replicator.get, replicator, "PublicExistCounts") end
                if got and value ~= nil then data.publicCounts = value end
            end
        end
    end
    return data
end
local function activeHudTrait(data)
    local activeEvents = playerGui and playerGui:FindFirstChild("ActiveEvents")
    local list = activeEvents and activeEvents:FindFirstChild("ActiveEvents")
    if not list or type(data.traits) ~= "table" then return nil end
    local found = {}
    local function addTrait(name)
        local normalized = liveNormalize(name):gsub(" ", "")
        if normalized ~= "" and not found[normalized] then found[normalized] = name end
    end
    for _, frame in ipairs(list:GetChildren()) do
        if frame:IsA("GuiObject") and frame.Visible then
            local image = frame:FindFirstChildWhichIsA("ImageLabel", true)
                or frame:FindFirstChildWhichIsA("ImageButton", true)
            local imageId = image and liveAsset(image.Image) or ""
            if imageId ~= "" then
                for key, record in pairs(data.traits) do
                    if type(record) == "table" and liveAsset(record.Icon) == imageId then
                        addTrait(key)
                    end
                end
            end
        end
    end
    local only, count
    for _, value in pairs(found) do only, count = value, (count or 0) + 1 end
    return count == 1 and only or nil
end
local function liveRiddleAnswer(question)
    local rawQuestion = tostring(question or "")
    local q = liveNormalize(rawQuestion)
    if q == "" then return nil, nil, false end
    -- Punctuation separates independent riddle clauses. The normal resolver
    -- will answer those clauses individually.
    if rawQuestion:find(",", 1, true) or rawQuestion:find("+", 1, true)
        or rawQuestion:find("&", 1, true) then
        return nil, nil, false
    end
    local data = loadLiveRiddleData()
    -- Count questions are parsed first, so "Rainbow mutation" cannot be
    -- mistaken for a request for the current mutation.
    local existsIntent = q:find("exist", 1, true) or q:find("count", 1, true)
        or liveHasPhrase(q, "how many") or liveHasPhrase(q, "number of")
    if existsIntent then
        if not data.animals or not data.publicCounts then return nil, "exist count", true end
    else
        local currentIntent = liveHasWord(q, "currently") or liveHasWord(q, "current")
            or liveHasWord(q, "running") or liveHasWord(q, "active") or liveHasWord(q, "now")
        local qualified = liveHasWord(q, "new") or liveHasWord(q, "latest") or liveHasWord(q, "recent")
            or liveHasWord(q, "added") or liveHasWord(q, "released") or liveHasWord(q, "update")
            or liveHasWord(q, "today") or liveHasWord(q, "best") or liveHasWord(q, "favorite")
            or liveHasWord(q, "favourite")
        if liveHasWord(q, "mutation") and currentIntent and not qualified and not q:find(" and ", 1, true) then
            local value
            if data.sharedMutations and type(data.sharedMutations.get) == "function" then
                local ok, result = pcall(data.sharedMutations.get, data.sharedMutations)
                if not ok or result == nil then ok, result = pcall(data.sharedMutations.get) end
                if ok and result ~= nil and tostring(result) ~= "" then value = tostring(result) end
            end
            if value and type(data.mutations) == "table" then
                local normalized = liveNormalize(value)
                for key, record in pairs(data.mutations) do
                    local aliases = {liveNormalize(key)}
                    if type(record) == "table" then aliases[#aliases + 1] = liveNormalize(record.DisplayText) end
                    for _, alias in ipairs(aliases) do
                        if alias ~= "" and alias == normalized then
                            return normalized:gsub(" ", ""), "current mutation", true
                        end
                    end
                end
            end
            return nil, "current mutation", true
        end
        if liveHasWord(q, "trait") and currentIntent and not qualified and not q:find(" and ", 1, true) then
            local value = activeHudTrait(data)
            if value then return liveNormalize(value):gsub(" ", ""), "current trait", true end
            return nil, "current trait", true
        end
        return nil, nil, false
    end
    local animalCandidates = {}
    for key, record in pairs(data.animals) do
        local aliases = {liveNormalize(key)}
        if type(record) == "table" then
            aliases[#aliases + 1] = liveNormalize(record.DisplayName)
            aliases[#aliases + 1] = liveNormalize(record.Name)
        end
        local extra = {}
        for _, alias in ipairs(aliases) do
            if alias ~= "" and alias:find(" ", 1, true) then extra[#extra + 1] = alias:gsub(" ", "") end
        end
        for _, alias in ipairs(extra) do aliases[#aliases + 1] = alias end
        local best, bestAlias = 0, nil
        for _, alias in ipairs(aliases) do
            if alias ~= "" and liveHasPhrase(q, alias) and #alias > best then best, bestAlias = #alias, alias end
        end
        if best > 0 then animalCandidates[#animalCandidates + 1] = {key = key, aliases = aliases, alias = bestAlias, score = best} end
    end
    if #animalCandidates == 0 then return nil, "exist count", true end
    table.sort(animalCandidates, function(a, b) return a.score > b.score end)
    local animalKey, animalAliases, animalAlias = animalCandidates[1].key, animalCandidates[1].aliases, animalCandidates[1].alias
    local animalName = liveNormalize(animalKey)
    if #animalCandidates > 1 then
        local nested = true
        for i = 2, #animalCandidates do
            if not animalCandidates[1].alias:find(animalCandidates[i].alias, 1, true) then nested = false break end
        end
        if not nested or animalCandidates[1].score == animalCandidates[2].score then
            if q:find(" and ", 1, true) then return nil, nil, false end
            return nil, "ambiguous exist count", true
        end
    end
    if q:find(" and ", 1, true) then
        local hasAnimalConjunction = false
        for _, alias in ipairs(animalAliases) do
            if alias:find(" and ", 1, true) and liveHasPhrase(q, alias) then hasAnimalConjunction = true break end
        end
        if not hasAnimalConjunction then return nil, nil, false end
    end
    local mutationCandidates = {}
    if type(data.mutations) == "table" then
        for key, record in pairs(data.mutations) do
            local aliases = {liveNormalize(key)}
            if type(record) == "table" then aliases[#aliases + 1] = liveNormalize(record.DisplayText) end
            local extra = {}
            for _, alias in ipairs(aliases) do
                if alias ~= "" and alias:find(" ", 1, true) then extra[#extra + 1] = alias:gsub(" ", "") end
                local spaced = tostring(alias):gsub("(%l)(%u)", "%1 %2")
                if spaced ~= alias then extra[#extra + 1] = liveNormalize(spaced) end
            end
            for _, alias in ipairs(extra) do aliases[#aliases + 1] = alias end
            for _, alias in ipairs(aliases) do
                local sameAsAnimal = false
                for _, animalAlias in ipairs(animalAliases) do
                    if alias ~= "" and animalAlias:find(alias, 1, true) and not liveHasWord(q, "mutation") then sameAsAnimal = true break end
                end
                if alias ~= "" and not sameAsAnimal and liveHasPhrase(q, alias) then
                    mutationCandidates[#mutationCandidates + 1] = {key = key, score = #alias}
                end
            end
        end
    end
    if liveHasWord(q, "default") or liveHasWord(q, "normal") then
        mutationCandidates[#mutationCandidates + 1] = {key = "None", score = 1000}
    end
    table.sort(mutationCandidates, function(a, b) return a.score > b.score end)
    if #mutationCandidates > 1 and mutationCandidates[1].score == mutationCandidates[2].score
        and mutationCandidates[1].key ~= mutationCandidates[2].key then
        return nil, tostring(animalKey) .. " ambiguous mutation exist count", true
    end
    local mutationKey = #mutationCandidates > 0 and mutationCandidates[1].key or nil
    local mutationTerm = q:match("(%w+)%s+mutation") or q:match("mutation%s+(%w+)")
    local genericMutationTerm = {current = true, total = true, count = true, exists = true, exist = true,
        many = true, how = true, the = true, of = true, ["in"] = true}
    if not mutationKey and mutationTerm and not genericMutationTerm[mutationTerm] then
        return nil, animalName .. " mutation exist count", true
    end
    -- Reject an unknown trailing word instead of answering a larger clue with
    -- the animal's total count. The normal resolver can split conjunctions.
    local remainder = q
    local first, last
    if animalAlias then first, last = q:find(animalAlias, 1, true) end
    if first then remainder = q:sub(1, first - 1) .. " " .. q:sub(last + 1) end
    local allowed = {how = true, many = true, what = true, is = true, are = true, there = true,
        the = true, a = true, an = true, number = true, of = true, exist = true, exists = true,
        existence = true, count = true, counts = true, total = true, with = true, ["in"] = true,
        ["for"] = true, per = true, mutation = true, mutations = true, default = true, normal = true}
    for _, candidate in ipairs(mutationCandidates) do
        local text = liveNormalize(candidate.key)
        for token in text:gmatch("%w+") do allowed[token] = true end
    end
    for token in remainder:gmatch("%w+") do
        if not allowed[token] then return nil, animalName .. " exist count", true end
    end
    local ok, record = pcall(data.publicCounts.TryIndex, data.publicCounts, {"data", animalKey})
    if not ok or type(record) ~= "table" then return nil, animalName .. " exist count", true end
    local value
    if mutationKey then
        local mutations = record.mutations
        value = type(mutations) == "table" and mutations[mutationKey] or nil
        -- A missing named mutation is unknown; never fall back to total_exists.
        if value == nil then return nil, animalName .. " " .. tostring(mutationKey) .. " exist count", true end
    else
        value = record.total_exists
        if value == nil then return nil, animalName .. " total exist count", true end
    end
    return tostring(value), animalName .. " " .. (mutationKey or "total") .. " exist count", true
end
local function submitCode(code, callback)
    local box, confirm = codeBox, codeButton
    local isRiddle = riddleSolver and riddleSolver.pending and riddleSolver.pending.code == code
    local record = {at = os.clock(), outcome = "pending",
        replay = state.retypeSafety and state.retypeReplay and state.retypeReplay.generation or nil}
    state.submissionLedger[code] = record
    local function completed(success, message)
        local lower = tostring(message or ""):lower()
        if success then record.outcome = "success"
        elseif lower == "textbox rejected the code" or lower == "confirm button could not be activated" then record.outcome = "local"
        elseif lower:find("invalid code", 1, true) or lower:find("code is invalid", 1, true)
            or (isRiddle and (lower:find("invalid", 1, true) or lower:find("incorrect", 1, true)))
            or (lower:find("already", 1, true) and (lower:find("redeem", 1, true) or (isRiddle and lower:find("used", 1, true))))
            or lower:find("expired", 1, true) or lower:find("sold out", 1, true)
            or lower:find("please wait", 1, true) or lower:find("cooldown", 1, true)
            or lower:find("too fast", 1, true) or lower:find("try again later", 1, true) then record.outcome = "definite"
        else record.outcome = "uncertain" end
        callback(success, message)
    end
    flight = {callback = completed, box = box, code = code}
    box.Text = code
    if box.Text ~= code then flight = nil completed(false, "Textbox Rejected The Code") return end
    local ok = pcall(firesignal, confirm.Activated)
    if not ok then flight = nil completed(false, "Confirm Button Could Not Be Activated") end
end
engine = createEngine(Config, {
    now = os.clock, after = after, defer = defer, cancel = cancelJob,
    changed = requestRefresh, ready = adapterReady,
    clearTextbox = function()
        if codeBox and codeBox.Parent and codeBox.Active and not flight then codeBox.Text = "" end
    end,
    submit = submitCode,
    skipReplayCode = function(code) return state.skipReplayCode and state.skipReplayCode(code) end,
}, saved)
state.engine = engine
riddleSolver = createRiddleSolver(Config, {
    now = os.clock, after = after, defer = defer, cancel = cancelJob, changed = requestRefresh,
    currentDate = createRiddleCalendar(Config), dynamicAnswer = liveRiddleAnswer,
    ready = adapterReady, submit = submitCode,
    skipReplayCode = function(code) return state.skipReplayCode and state.skipReplayCode(code) end,
    finished = function(result)
        if #riddleSolver.entries > 0 then return end
        engine:finishRiddle(result)
        if engine.autoWaiting then riddleSolver:setArmed(false) end
        requestRefresh()
    end,
    redeemed = engine.redeemed,
    clearTextbox = function() if codeBox and codeBox.Parent and codeBox.Active and not flight then codeBox.Text = "" end end,
}, saved)
state.riddleSolver = riddleSolver
state.fps = createFPSController(function(f)
    if not state.alive then return end
    fpsButton.Text = f.busy and "Boosting..." or (f.enabled and "FPS Boost On" or "FPS Boost")
    fpsButton:SetAttribute("on", f.enabled)
    gui:SetAttribute("fps_boost", f.enabled)
    gui:SetAttribute("fps_boost_busy", f.busy)
    gui:SetAttribute("fps_textures_removed", f.textures)
    gui:SetAttribute("fps_properties_changed", f.changedProperties)
    gui:SetAttribute("fps_tracks_stopped", f.stoppedTracks)
    refresh()
    if state.persistSettings then state.persistSettings() end
end)
connect(fpsButton.Activated, function() state.fps:setEnabled(not state.fps.enabled) end)
state.config = Config
state.snapshot = function()
    local snapshot = engine:snapshot()
    snapshot.fpsBoost = state.fps.enabled
    snapshot.webhook = redemptionWebhook and redemptionWebhook:snapshot() or {}
    snapshot.riddleEnabled = riddleSolver.enabled
    snapshot.riddleBeforeAuto = state.riddleBeforeAuto
    snapshot.submissionLedger = state.submissionLedger
    snapshot.riddleSettings = riddleSolver.settings
    snapshot.learnedFacts = riddleSolver.learned
    snapshot.currentBrainrotFactRevision = riddleSolver.currentBrainrotFactRevision
    snapshot.riddleFactRevision = riddleSolver.riddleFactRevision
    snapshot.riddleRarityFactRevision = riddleSolver.riddleRarityFactRevision
    snapshot.riddleBirthDateFactRevision = riddleSolver.riddleBirthDateFactRevision
    snapshot.riddleLuckyBlockFactRevision = riddleSolver.riddleLuckyBlockFactRevision
    snapshot.riddleColorFactRevision = riddleSolver.riddleColorFactRevision
    snapshot.riddleRedeemed = riddleSolver.redeemed
    snapshot.adminAbuse = adminHelper and adminHelper:snapshot() or {}
    snapshot.width, snapshot.height, snapshot.x, snapshot.y = state.width, state.height, state.x, state.y
    snapshot.collapsed = state.collapsed
    snapshot.senderPosition, snapshot.senderCollapsed = senderPosition, senderCollapsed
    snapshot.senderOpen = senderWindow.Visible and not senderClosing
    return snapshot
end
connect(close.Activated, function()
    if state.closing then return end
    if state.persistSettings then state.persistSettings(true) end
    state.closing = true
    engine:stop()
    riddleSolver:stop()
    if adminHelper then adminHelper:stop() end
    pointer, senderPointer = nil, nil
    announcementBox:ReleaseFocus()
    for _, connection in ipairs(state.connections) do connection:Disconnect() end
    local targetSize = panel.Size - UDim2.fromOffset(12, 12)
    local targetPosition = panel.Position + UDim2.fromOffset(6 * scale.Scale, 6 * scale.Scale)
    animate(panel, {GroupTransparency = 1, Size = targetSize, Position = targetPosition}, 0.22)
    animate(shadow, {BackgroundTransparency = 1, Size = targetSize,
        Position = targetPosition + UDim2.fromOffset(0, 5)}, 0.22)
    if senderWindow.Visible then animate(senderWindow, {GroupTransparency = 1}, 0.18) end
    if senderShadow.Visible then animate(senderShadow, {BackgroundTransparency = 1}, 0.18) end
    for _, tool in ipairs(toolWindows) do
        if tool.window.Visible then animate(tool.window, {GroupTransparency = 1}, 0.18) end
        if tool.shadow.Visible then animate(tool.shadow, {BackgroundTransparency = 1}, 0.18) end
    end
    after(0.24, state.stop)
end)
connect(gui.Destroying, function() if state.alive then state.stop() end end)
local objectRefreshQueued = false
connect(playerGui.DescendantAdded, function(child)
    if child.Name == "Codes" or child.Name == "TextBox" or child.Name == "Confirm" then
        if objectRefreshQueued then return end
        objectRefreshQueued = true
        defer(function()
            objectRefreshQueued = false
            if state.alive then refreshCodeObjects() engine:wake() end
        end)
    end
end)

state.settingsRestoring = true
state.syncAutoSolver = function()
    if not engine or not riddleSolver then return end
    if engine.autoMode then
        state.wasAutoMode = true
        local active = engine.autoRiddle == true
        if riddleSolver.enabled ~= active then riddleSolver:setEnabled(active, active)
        elseif riddleSolver.armed ~= active then riddleSolver:setArmed(active) end
    elseif state.wasAutoMode then
        state.wasAutoMode = false
        riddleSolver:setEnabled(state.riddleBeforeAuto, true)
    end
end
state.skipReplayCode = function(code)
    local record = state.submissionLedger[code]
    if not record then return false end
    if record.outcome == "pending" or record.outcome == "uncertain" then return true end
    local generation = state.retypeReplay and state.retypeReplay.generation
    return state.retypeSafety and record.outcome ~= "local" and record.replay ~= generation
end
state.persistSettings = function(immediate)
    if not state.alive or state.closing or state.settingsRestoring or not engine or not riddleSolver then return end
    local function writePreferences()
        state.settingsJob = nil
        if not state.alive or state.closing then return end
        local value = engine:snapshot()
        if engine.autoMode and engine.manualBeforeAuto then
            local manual = engine.manualBeforeAuto
            value.enabled, value.guess, value.partsMode = manual.enabled, manual.guess, manual.partsMode
            value.partsModeBeforeGuess = manual.partsModeBeforeGuess
        end
        if engine.autoMode then value.riddleEnabled = state.riddleBeforeAuto
        else value.riddleEnabled = riddleSolver.enabled end
        value.riddleBeforeAuto = state.riddleBeforeAuto
        value.riddleSettings = riddleSolver.settings
        value.fpsBoost = state.fps and state.fps.enabled or false
        value.adminAbuse = adminHelper and adminHelper:snapshot() or {}
        local ok, reason = env.__STRAWB3RRY_settings_store:save(value)
        if gui and gui.Parent then
            gui:SetAttribute("settings_saved", ok)
            gui:SetAttribute("settings_save_status", reason)
        end
    end
    if immediate then
        if state.settingsJob then cancelJob(state.settingsJob) state.settingsJob = nil end
        writePreferences()
    elseif not state.settingsJob then state.settingsJob = after(0.2, writePreferences) end
end
state.routeAnnouncement = function(replayed, ...)
    if not state.alive or not engine or not riddleSolver then return false end
    local message, _, _, location, sender, _, remove = ...
    if remove or location ~= "Top" or type(message) ~= "string" or tonumber(sender) ~= Config.SammyUserId then return false end
    if not replayed then state.retypeSafety = false end
    local plain = message:gsub("<[^>]*>", ""):gsub("&apos;", "'"):gsub("&amp;", "&")
    local lower = plain:lower()
    local riddleMarker = lower:find("%f[%w_]riddle%f[^%w_]") ~= nil
    local codeMarker = lower:find("%f[%w_]use%s+code%f[^%w_]")
        or lower:find("%f[%w_]code%s+is%f[^%w_]")
    if engine.autoMode and riddleMarker then
        if not engine:startRiddle() then return false end
        state.syncAutoSolver()
        local _, control = riddleSolver:observe(...)
        if not control then riddleSolver:receive(...) end
        return true
    end
    if engine.autoMode and codeMarker then
        local accepted = engine:receive(...)
        if accepted then state.syncAutoSolver() end
        return accepted
    end
    if engine.enabled and not engine.autoRiddle and not riddleSolver.armed
        and plain:match("^[A-Za-z0-9]+$") and not riddleMarker then return engine:receive(...) end
    local learned = riddleSolver:learn(...)
    local marked, control = riddleSolver:observe(...)
    if control or (learned and riddleSolver.enabled and riddleSolver.armed) then return true end
    local handled = riddleSolver:receive(...)
    if not marked and not handled then return engine:receive(...) end
    return handled or marked
end
state.retypeReplay = createRetypeReplay(Config, {
    now = os.clock,
    blocked = function()
        return flight ~= nil or engine.pending ~= nil or riddleSolver.pending ~= nil,
            "A Game Request Is Still Pending"
    end,
    modeEnabled = function() return engine.enabled or engine.autoMode or riddleSolver.enabled end,
    beginBatch = function() state.retypeBatch, state.retypeSafety = true, true end,
    resetCollections = function()
        engine:clear(false)
        riddleSolver:prepareRetype()
        riddleSolver:setArmed(riddleSolver.enabled and not engine.autoMode)
    end,
    dispatch = function(...) state.routeAnnouncement(true, ...) end,
    endBatch = function(ok)
        state.retypeBatch = false
        if ok then engine:wake() riddleSolver:wake() end
        requestRefresh()
    end,
})
connect(retypeButton.Activated, function()
    ensureSetup()
    local ok, reason = state.retypeReplay:run()
    if not ok then engine.status = reason requestRefresh() end
end)
if engine.autoMode then state.syncAutoSolver()
elseif saved.riddleEnabled == true then riddleSolver:setEnabled(true, true) end

local announcementConnection
local function bindNotificationRemote()
    if not notification or type(notification.Start) ~= "function" then return false end
    local ok, upvalues = pcall(debug.getupvalues, notification.Start)
    if not ok then return false end
    local found
    for _, value in pairs(upvalues) do
        if typeof(value) == "Instance" and value:IsA("RemoteEvent") and value:IsDescendantOf(ReplicatedStorage) then
            if found and found ~= value then readyReason = "announcement event is ambiguous" return false end
            found = value
        end
    end
    if not found then return false end
    if notificationRemote == found and announcementConnection and announcementConnection.Connected then return true end
    if announcementConnection then announcementConnection:Disconnect() end
    notificationRemote = found
    announcementConnection = connect(found.OnClientEvent, function(...)
        state.retypeReplay:capture(...)
        state.routeAnnouncement(false, ...)
    end)
    gui:SetAttribute("announcement_remote", found:GetFullName())
    connect(found.AncestryChanged, function()
        if state.alive and not found:IsDescendantOf(ReplicatedStorage) and notificationRemote == found then
            announcementConnection:Disconnect()
            notificationRemote = nil
            readyReason = "announcement event changed · reconnecting"
            defer(function() bindNotificationRemote() engine:wake() if riddleSolver then riddleSolver:clear() end end)
        end
    end)
    return true
end
local function installResponses()
    if state.responsesConnected then return end
    local expectedSource = codesScript:GetFullName()
    for _, name in ipairs({"Success", "Error"}) do
        local original = notification[name]
        if type(original) ~= "function" then error("notification response methods changed") end
        local wrapper
        wrapper = function(self, message, ...)
            local caller = debug.info(2, "s")
            local pending = flight
            -- Only the actual CodesController response belongs to this attempt.
            -- Normal notifications and other controllers are forwarded without collection.
            if state.alive and pending and caller == expectedSource and not pending.box.Active then
                local code, nativeMessage = pending.code, tostring(message or "")
                local reporter, isSuccess = redemptionWebhook, name == "Success"
                flight = nil
                local ok, err = pcall(pending.callback, isSuccess, nativeMessage)
                if not ok then warn("STRAWB3RRY Auto Code Redeemer: " .. tostring(err)) end
                if isSuccess and reporter then
                    local reported = pcall(reporter.successful, reporter, code, nativeMessage)
                    if not reported then warn("STRAWB3RRY Auto Code Redeemer: Webhook Reporting Failed") end
                end
            end
            return original(self, message, ...)
        end
        notification[name] = wrapper
        table.insert(state.restore, function() if notification[name] == wrapper then notification[name] = original end end)
    end
    state.responsesConnected = true
end
state.lifecycle = {
    state = state, engine = engine, rep = ReplicatedStorage, refresh = refresh,
    resolve = resolve, connect = connect, after = after, defer = defer,
    bind = bindNotificationRemote, installResponses = installResponses,
    refreshCodeObjects = refreshCodeObjects,
}
state.lifecycle.capable = function(c)
    return type(firesignal) == "function" and type(getconnections) == "function"
        and type(debug.getupvalues) == "function"
end
state.lifecycle.applyControllers = function(c)
    codesScript, notification = c.codesScript, c.notification
end
state.lifecycle.applyFlags = function(c)
    codesFlags = c.codesFlags
end
state.lifecycle.failCapability = function(c)
    readyReason = "Executor Needs Firesignal, Getconnections And Debug.getupvalues"
    c.engine.status = readyReason c.refresh()
end
state.lifecycle.failResponses = function(c, err)
    c.engine.status = "Response Listener Unavailable"
    gui:SetAttribute("error", tostring(err)) c.refresh()
end
state.lifecycle.finish = function(c)
    if notificationRemote then readyReason = nil end
    c.engine:wake() c.refresh()
end
state.lifecycle.controllers = function(c)
    local controllers = c.rep:WaitForChild("Controllers", 15)
    local noticeScript = controllers and controllers:WaitForChild("NotificationController", 15)
    c.codesScript = controllers and controllers:WaitForChild("CodesController", 15)
    if not c.state.alive then return false end
    if not noticeScript or not c.codesScript then
        c.engine.status = "Game Controllers Unavailable" c.refresh() return false
    end
    local ok, result = pcall(require, noticeScript)
    if not c.state.alive then return false end
    if not ok or type(result) ~= "table" then
        c.engine.status = "Notification Controller Unavailable" c.refresh() return false
    end
    c.notification = result c.applyControllers(c)
    return true
end
state.lifecycle.flags = function(c)
    local flagsScript = c.resolve(c.rep, {"Shared", "Flags", "CodesFlags"})
    if flagsScript then pcall(function() c.codesFlags = require(flagsScript) end) end
    c.applyFlags(c)
    if not c.codesFlags or not c.codesFlags.Enabled or not c.codesFlags.Enabled.Changed then return end
    local function updateCodesEnabled()
        local ok, value = pcall(function() return c.codesFlags.Enabled:Get() end)
        codesEnabled = ok and value == true c.engine:wake()
    end
    c.connect(c.codesFlags.Enabled.Changed, updateCodesEnabled)
    updateCodesEnabled()
end
state.lifecycle.announcement = function(c)
    if c.bind() then return end
    c.engine.status = "Waiting For The Announcement Event"
    for retry = 1, 5 do
        c.after(retry * 2, function()
            if c.bind() then
                c.engine.status = c.engine.enabled and "waiting for announcement..." or "auto redeem off"
                c.refresh() c.engine:wake()
            end
        end)
    end
end
state.lifecycle.network = function(c)
    local netContainer = c.resolve(c.rep, {"Packages", "Net"})
    if not netContainer then return end
    c.connect(netContainer.ChildAdded, function(child)
        if child:IsA("RemoteEvent") then c.defer(function() c.bind() c.engine:wake() end) end
    end)
end
state.lifecycle.run = function(c)
    if not c.capable(c) then c.failCapability(c) return end
    if not c.controllers(c) then return end
    c.flags(c)
    local connected, err = pcall(c.installResponses)
    if not connected then c.failResponses(c, err) return end
    c.refreshCodeObjects()
    c.announcement(c)
    c.network(c)
    c.finish(c)
end
local function setup()
    return state.lifecycle.run(state.lifecycle)
end
local setupStarted = false
ensureSetup = function()
    if setupStarted or not state.alive then return end
    setupStarted = true
    defer(function()
        local ok, err = pcall(setup)
        if not ok then
            gui:SetAttribute("error", tostring(err))
            engine.status = "Connection Setup Failed"
            refresh()
        end
        if not state.responsesConnected then setupStarted = false end
    end)
end
content.Visible, profile.Visible = not state.collapsed, not state.collapsed
senderBody.Visible = not senderCollapsed
fit(false)
refresh()
if saved.fpsBoost == true then state.fps:setEnabled(true) end
if saved.adminAbuse and (saved.adminAbuse.antiRagdoll or saved.adminAbuse.lockPosition) then loadHelperRuntime() end
if saved.adminAbuse and saved.adminAbuse.lockPosition then adminHelper:setLockPosition(true) end
state.settingsRestoring = false
state.persistSettings(true)
ensureSetup() -- Capture recent trusted announcements even while the switches are off.
animate(panel, {GroupTransparency = 0}, 0.28)
