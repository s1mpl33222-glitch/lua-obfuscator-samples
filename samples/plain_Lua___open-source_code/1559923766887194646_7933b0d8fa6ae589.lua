_G.SlugID = "7933b0d8fa6ae589"
-- ══════════════════════════════════════════════════════════════════════════════
-- [ Kryptic Vault Development Mode ]
-- Kryptic Development Loader — Bypass-Loader (Unobfuscated)
-- ══════════════════════════════════════════════════════════════════════════════
-- This loader is served ONLY when the script owner enables Development Mode.
-- It skips ALL security protections to allow clean debugging of UI libraries,
-- scripts, and PandaAuthV4 integrations.
--
-- OMITTED: Handshake, AES-256-CBC encryption, HMAC, Ed25519, Anti-Spy,
--          Telemetry, env_check, fn_check, Pre-sandbox, Heartbeat, WebSocket.
-- KEPT:    Basic function check, PandaAuthV4 SDK, script active poll.
-- ══════════════════════════════════════════════════════════════════════════════

local SLUG         = _G.SlugID
local SERVICE_ID   = ""
local GETKEY_URL   = ""
local VALIDATE_URL = "https://secure.pandauth.com/v2_validation"
local ACTIVE_URL   = "https://vss.pandauth.com/kv/7933b0d8fa6ae589/active"
local OWNER_TIER   = "BASIC"
local INIT_ENABLED = false
local DEV_MAIN_URL = "https://vss.pandauth.com/kv/7933b0d8fa6ae589/dev-main"
local DEV_INIT_URL = "https://vss.pandauth.com/kv/7933b0d8fa6ae589/dev-init"
local CONFIG_URL   = ""
local LOADER_VERSION = "1.4.0"

-- ── DEVELOPMENT MODE WARNING ──────────────────────────────────────────────
warn("══════════════════════════════════════════════════════════════")
warn("            [ Kryptic Vault Development Mode ]")
warn("══════════════════════════════════════════════════════════════")
warn("⚠️  WARNING: DEVELOPMENT MODE ACTIVE")
warn("⚠️  Security features are DISABLED in this mode:")
warn("⚠️  • No encryption / handshake")
warn("⚠️  • No anti-spy / anti-logger protection")
warn("⚠️  • No telemetry collection")
warn("⚠️  • No obfuscation — script is delivered in PLAINTEXT")
warn("⚠️  Do NOT use this mode in production!")
warn("══════════════════════════════════════════════════════════════")

if type(SLUG) ~= "string" or SLUG == "" then
    return warn("[Kryptic Dev] _G.SlugID is required (string)")
end

-- ── Check basic functions ─────────────────────────────────────────────────
local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")

local HTTP_FN = request or http_request or (http and http.request)
if not HTTP_FN then
    return error("[Kryptic Dev] No HTTP request function available")
end

local EXEC = "Unknown"
pcall(function()
    if type(identifyexecutor) == "function" then EXEC = identifyexecutor() or "Unknown"
    elseif type(getexecutorname) == "function" then EXEC = getexecutorname() or "Unknown" end
end)

local USER_ID, DISPLAY_NAME = "0", "Unknown"
pcall(function()
    local lp = Players.LocalPlayer
    if lp then USER_ID = tostring(lp.UserId); DISPLAY_NAME = lp.DisplayName or lp.Name end
end)

-- ── Authentication identity ───────────────────────────────────────────────────
-- Mirrors the production loader so `getgenv().Authentication_Method` behaves the
-- same while you are debugging in Development Mode. `getgenv().HIDE_GUI` is a
-- no-op here — the dev loader has no GUI to begin with.
local _GENV = _G
pcall(function() if type(getgenv) == "function" then _GENV = getgenv() or _G end end)
local function _opt(name)
    local v
    pcall(function() v = _GENV[name] end)
    if v == nil then pcall(function() v = _G[name] end) end
    return v
end

local HWID = "none"
pcall(function()
    if type(gethwid) == "function" then HWID = gethwid() or "none"
    elseif type(getfingerprintid) == "function" then HWID = getfingerprintid() or "none"
    elseif type(getdeviceid) == "function" then HWID = getdeviceid() or "none" end
end)

local AUTH_METHOD = "ClientID"
do
    local raw = _opt("Authentication_Method")
    if type(raw) == "string" then
        local n = raw:lower():gsub("[^%a]", "")
        if n == "useridonly" or n == "userid" then AUTH_METHOD = "UserID_Only"
        elseif n == "auto" then AUTH_METHOD = "Auto" end
    end
end

-- "rbx-<UserId>" — same shape as key-watcher-standalone.lua and the production loader.
local USER_IDENTITY = (USER_ID ~= "0" and USER_ID ~= "") and ("rbx-" .. USER_ID) or nil
local AUTH_ID
if AUTH_METHOD == "UserID_Only" then AUTH_ID = USER_IDENTITY or HWID
elseif AUTH_METHOD == "Auto" then AUTH_ID = (HWID ~= "none" and HWID ~= "") and HWID or (USER_IDENTITY or HWID)
else AUTH_ID = HWID end
if AUTH_ID == nil or tostring(AUTH_ID) == "" then AUTH_ID = "none" end

print("[Kryptic Dev] Executor: " .. EXEC .. " | User: " .. DISPLAY_NAME .. " (" .. USER_ID .. ")")
print("[Kryptic Dev] Slug: " .. SLUG)
print("[Kryptic Dev] Loader Version: " .. LOADER_VERSION)
print("[Kryptic Dev] Auth Method: " .. AUTH_METHOD .. " | Identity: " .. tostring(AUTH_ID))

-- ── Simple HTTP helper ────────────────────────────────────────────────────
local function httpGet(url)
    local ok, res = pcall(HTTP_FN, { Url = url, Method = "GET" })
    if not ok then return nil, tostring(res) end
    if type(res) == "table" and res.Body then return res.Body end
    if type(res) == "string" then return res end
    return nil, "unexpected response type"
end

-- ── PandaAuthV4 SDK (simplified for dev mode) ─────────────────────────────
-- Full SDK with GetKey, Validate, Validate_Premium, InitScript support.
local PandaAuthV4 = {}
_G.PandaAuthV4 = PandaAuthV4

-- Dev mode validates against the V2 shim, whose Expired_At is a display string
-- ("MM/DD/YY_HH:MM", server local time) — not the ISO instant the production
-- loader gets. So GetExpiry() returns that string verbatim and the numeric
-- accessors return nil rather than inventing a timestamp from a lossy value.
local _devExpiresAt = nil

function PandaAuthV4.GetKey()
    if GETKEY_URL == "" then return "" end
    -- Carry the identity so a key generated in Development Mode binds to the same
    -- value the production loader will send for this Authentication_Method.
    local url = GETKEY_URL .. "?hwid=" .. tostring(AUTH_ID)
    if setclipboard then pcall(setclipboard, url) end
    return url
end

function PandaAuthV4.GetAuthMethod() return AUTH_METHOD end
function PandaAuthV4.GetIdentity() return AUTH_ID end

function PandaAuthV4.Validate(key)
    if SERVICE_ID == "" then
        print("[Kryptic Dev] No service linked — keyless mode (dev)")
        return true
    end
    if not key or key == "" then
        warn("[Kryptic Dev] PandaAuthV4.Validate() — no key provided")
        return false
    end
    local ok, res = pcall(HTTP_FN, {
        Url = VALIDATE_URL,
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ key = key, service = SERVICE_ID }),
    })
    if not ok then warn("[Kryptic Dev] Validate failed: " .. tostring(res)); return false end
    local body = type(res) == "table" and res.Body or res
    local data = pcall(function() return HttpService:JSONDecode(body) end) and HttpService:JSONDecode(body) or {}
    _devExpiresAt = data.Expired_At or data.expiresAt
    return data.valid == true or data.success == true
end

function PandaAuthV4.GetExpiry() return _devExpiresAt end
function PandaAuthV4.GetExpiryUnix() return nil end
function PandaAuthV4.GetTimeLeft() return nil end
function PandaAuthV4.IsExpired() return false end
function PandaAuthV4.GetExpiryFormatted()
    if _devExpiresAt == nil then return "Lifetime" end
    return tostring(_devExpiresAt)
end

function PandaAuthV4.Validate_Premium(key)
    -- In dev mode, Premium validation follows the same path
    return PandaAuthV4.Validate(key)
end

function PandaAuthV4.InitScript()
    if not INIT_ENABLED then
        warn("[Kryptic Dev] InitScript is disabled for this script")
        return
    end
    print("[Kryptic Dev] Fetching init script...")
    local body, err = httpGet(DEV_INIT_URL)
    if not body or body == "" then
        warn("[Kryptic Dev] Init script unavailable: " .. tostring(err or "empty response"))
        return
    end
    local fn, loadErr = loadstring(body)
    if not fn then
        warn("[Kryptic Dev] Init script load error: " .. tostring(loadErr))
        return
    end
    print("[Kryptic Dev] ✅ Init script loaded (" .. #body .. " bytes)")
    local ok2, runErr = pcall(fn)
    if not ok2 then warn("[Kryptic Dev] Init script runtime error: " .. tostring(runErr)) end
end

function PandaAuthV4.GetConfig(key)
    local cache = _G._puslDevConfigCache or {}
    if cache[key] ~= nil then return cache[key] end
    if CONFIG_URL == "" then return nil end
    local ok, resp = pcall(HTTP_FN, { Url = CONFIG_URL, Method = "GET" })
    if ok and resp then
        local body = type(resp) == "table" and (resp.Body or resp.body) or resp
        local d = pcall(function() return HttpService:JSONDecode(body) end) and HttpService:JSONDecode(body) or {}
        if d.success and d.data and d.data.configs then
            _G._puslDevConfigCache = d.data.configs
            return _G._puslDevConfigCache[key]
        end
    end
    return nil
end

-- ── Fetch & Execute Main Script ───────────────────────────────────────────
print("[Kryptic Dev] Fetching main script...")
local mainBody, mainErr = httpGet(DEV_MAIN_URL)

if not mainBody or mainBody == "" then
    local msg = "[Kryptic Dev] Main script unavailable: " .. tostring(mainErr or "empty response")
    warn(msg)
    pcall(function() local p = Players.LocalPlayer; if p then p:Kick(msg) end end)
    return
end

-- Check for server-side error responses
if mainBody:sub(1, 1) == "{" then
    local ok, parsed = pcall(function() return HttpService:JSONDecode(mainBody) end)
    if ok and parsed and parsed.error then
        local msg = "[Kryptic Dev] Server error: " .. tostring(parsed.error)
        warn(msg)
        pcall(function() local p = Players.LocalPlayer; if p then p:Kick(msg) end end)
        return
    end
end

local mainFn, loadErr = loadstring(mainBody)
if not mainFn then
    local msg = "[Kryptic Dev] Script load error: " .. tostring(loadErr)
    warn(msg)
    pcall(function() local p = Players.LocalPlayer; if p then p:Kick(msg) end end)
    return
end

print("[Kryptic Dev] ✅ Main script loaded (" .. #mainBody .. " bytes)")
print("[Kryptic Dev] Executing...")

local ok, runErr = pcall(mainFn)
if not ok then
    warn("[Kryptic Dev] Runtime error: " .. tostring(runErr))
end

print("[Kryptic Dev] ✅ Execution complete")
