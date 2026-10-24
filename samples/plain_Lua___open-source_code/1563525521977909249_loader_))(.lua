-- try to crack it

local API_BASE      = "https://silenceauth-production.up.railway.app"
local LOADER_VERSION = "1.0.0"
local REQUEST_TIMEOUT = 15

-- ── Environment shims ───────────────────────────────────────────────────────
-- Executors expose HTTP under different names. Resolve once, fail clearly.
local http_request = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

local HttpService = (typeof(game) ~= "nil") and game:GetService("HttpService") or nil

local function json_encode(t)
    if HttpService then return HttpService:JSONEncode(t) end
    error("orbit: no JSON encoder available")
end

local function json_decode(s)
    if HttpService then
        local ok, result = pcall(function() return HttpService:JSONDecode(s) end)
        if ok then return result end
    end
    return nil
end

-- ── Output ──────────────────────────────────────────────────────────────────
local function log(msg)
    print("[orbit] " .. tostring(msg))
end

local function fail(msg)
    -- One generic surface for the user. The server already knows the real reason
    -- and has logged it; echoing server internals here would help nobody but an
    -- attacker probing for which of their keys is which.
    log(msg)
    error("[orbit] " .. tostring(msg), 0)
end

-- Remove the player from the game with a message they cannot miss.
--
-- Used only where continuing is pointless and the user has something to do about
-- it. A kick is not a security control — the server has already refused to hand
-- over anything — it is how the reason reaches someone who is not watching the
-- console. If kicking is impossible (no LocalPlayer, studio, a non-game host),
-- fall back to the normal error path rather than failing silently.
local function kick(msg)
    log(msg)
    local ok = pcall(function()
        local players = game:GetService("Players")
        local me = players.LocalPlayer
        if me then
            me:Kick("\n" .. msg)
            return true
        end
        error("no local player")
    end)
    if not ok then
        error("[orbit] " .. tostring(msg), 0)
    end
    -- The kick is asynchronous; stop the chunk here so nothing else runs.
    error("[orbit] " .. tostring(msg), 0)
end

-- ── Transport ───────────────────────────────────────────────────────────────
local function post(path, body)
    if not http_request then
        fail("Your executor does not expose an HTTP request function.")
    end
    local ok, response = pcall(http_request, {
        Url = API_BASE .. path,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/json, text/plain",
            ["X-Loader-Version"] = LOADER_VERSION,
        },
        Body = json_encode(body),
        Timeout = REQUEST_TIMEOUT,
    })
    if not ok then
        fail("Could not reach the authentication server.")
    end
    local status = response.StatusCode or response.Status or 0
    return status, response.Body or ""
end

-- ── Input ───────────────────────────────────────────────────────────────────
-- The user sets these as globals above the loadstring call. getfenv exists in
-- Lua 5.1 and most Luau executors but not all, so resolve defensively rather
-- than indexing whatever it happens to return.
local function read_global(name)
    local ok, env = pcall(function()
        if type(getfenv) == "function" then return getfenv(0) end
        return nil
    end)
    if ok and type(env) == "table" and env[name] ~= nil then return env[name] end
    return _G[name]
end

local key = read_global("script_key")
local tier = read_global("script_tier") or "public"

if type(key) ~= "string" or #key < 16 then
    fail('No script key set. Put script_key = "osk_..." above the loadstring call.')
end
if tier ~= "public" and tier ~= "private" then
    tier = "public"
end

-- ── Hardware id ─────────────────────────────────────────────────────────────
-- Identifies the machine so a licence can be bound to it. Several sources
-- because executors differ; the first that yields a stable string wins.
--
-- This value is reported by the client and can therefore be forged by anyone
-- willing to patch this file. It raises the cost of casually passing a key to a
-- friend. It is not an identity proof, and nothing that matters — revocation,
-- expiry, the online switch — depends on it.
local function machine_id()
    local candidates = {
        function() return gethwid and gethwid() end,
        function() return syn and syn.request and game:GetService("RbxAnalyticsService"):GetClientId() end,
        function() return game:GetService("RbxAnalyticsService"):GetClientId() end,
        function() return getexecutorname and (getexecutorname() .. tostring(game:GetService("RbxAnalyticsService"):GetClientId())) end,
    }
    for _, get in ipairs(candidates) do
        local ok, value = pcall(get)
        if ok and type(value) == "string" and #value >= 8 then
            -- Keep it within the shape the API accepts: printable, bounded.
            value = value:gsub("[^%w%._:%-]", ""):sub(1, 128)
            if #value >= 8 then return value end
        end
    end
    return nil
end

local hwid = machine_id()

-- ── Step 1: authenticate, receive a short-lived grant ──────────────────────
-- There is no separate status check. It cost a full round trip from the client
-- to learn something /api/script/authenticate already answers with 503, and the
-- server checks the switch again at delivery anyway — so the check was pure
-- latency, not safety.
log("authenticating…")
local status, body = post("/api/script/authenticate", {
    script_key = key,
    tier = tier,
    loader_version = LOADER_VERSION,
    hwid = hwid,
})

if status == 503 then fail("Script is currently offline.") end
if status == 429 then fail("Too many attempts. Wait a minute and try again.") end
if status == 401 or status == 403 then
    -- The hardware lock is the one failure the user can fix themselves, so it
    -- is named. Everything else stays deliberately generic.
    local detail = json_decode(body)
    local code = detail and detail.error
    if code == "hwid_mismatch" then
        kick("Your HWID is connected to another device.\n\nReset it with /silencehub")
    elseif code == "hwid_required" then
        kick("Your executor did not report a hardware id.\n\nTry a different executor. /silencehub")
    end
    fail("Authentication failed.")
end
if status ~= 200 then fail("Authentication failed.") end

local auth = json_decode(body)
if not auth or not auth.grant then fail("Authentication failed.") end

local remote_version = auth.script and auth.script.version or "?"
log(("authenticated — %s v%s"):format(tier, tostring(remote_version)))

-- ── Step 2: redeem the grant for the source ─────────────────────────────────
-- The grant is single-use, IP-bound and expires in seconds, so there is nothing
-- worth caching here; fetch immediately.
local fetch_status, source = post("/api/script/fetch", { grant = auth.grant })

if fetch_status == 503 then fail("Script is currently offline.") end
if fetch_status == 429 then fail("Too many requests. Slow down.") end
if fetch_status ~= 200 then
    -- The server's own code for this step is one of grant_invalid, script_offline
    -- or rate_limited. None of them say anything about whether a key exists, so
    -- surfacing it costs nothing and saves the user guessing.
    local detail = json_decode(source)
    local code = detail and detail.error or ("http " .. tostring(fetch_status))
    fail("Access denied (" .. tostring(code) .. "). Press Get Script in Discord for a fresh key and try again.")
end
if type(source) ~= "string" or #source == 0 then fail("Access denied (empty response).") end

-- ── Step 3: compile and run ─────────────────────────────────────────────────
-- Lua 5.1 and most Luau executors expose loadstring; the 5.2+ name is load, and
-- some sandboxes ship only one of them. Take whichever exists rather than
-- assuming, so a missing loadstring is not mistaken for a broken script.
local compile = loadstring or load
if type(compile) ~= "function" then
    fail("Your executor exposes neither loadstring nor load, so no script can be run.")
end

local chunk, compile_err = compile(source, "=orbit:" .. tier)
if not chunk then
    fail("Script failed to compile: " .. tostring(compile_err))
end

log("loaded")
return chunk()
