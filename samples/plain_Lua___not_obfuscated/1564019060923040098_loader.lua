local loaderStartedAt = os.clock()
-- Security hardening v4: bounded integrity checks and stop-on-interception policy.
-- Client-side code can still be captured by the executor; no anti-dump guarantee.
local MAX_PAYLOAD_BYTES = 16 * 1024 * 1024
local loaderEnvironment
pcall(function() if type(getfenv) == "function" then loaderEnvironment = getfenv(0) end end)
-- Automatic loader using script_key; no key-entry box or run button.
-- This performs normal authentication; it does not bypass key/device checks.
local suppliedKey = ...
local keyEnvironment = _G
pcall(function()
    if type(getgenv) == "function" then
        local candidate = getgenv()
        if type(candidate) == "table" then keyEnvironment = candidate end
    end
end)
-- Silent wall-time measurements only; no UI, files, network or scheduled work.
local timings = {Version = 1, StartedAt = loaderStartedAt, Ms = {}, MilestonesMs = {}, Status = "loading"}
local clock = os.clock
function timings.Record(name, startedAt)
    timings.Ms[name] = (clock() - startedAt) * 1000
end
function timings.Mark(name, at)
    timings.MilestonesMs[name] = ((at or clock()) - timings.StartedAt) * 1000
    if name == "mainStarted" and timings.Ms.loaderToMain then
        timings.Ms.mainBootstrap = math.max(0, timings.MilestonesMs.mainStarted - timings.Ms.loaderToMain)
    end
    local mainDone, uiDone = timings.MilestonesMs.mainReturned, timings.MilestonesMs.uiReady
    if mainDone and uiDone then
        timings.Ms.total = math.max(mainDone, uiDone)
        timings.Status = "ready"
    end
end
keyEnvironment.KimmyLoadTimings = timings

local function usableKey(value)
    if type(value) ~= "string" then return nil end
    local trimmed = value:match("^%s*(.-)%s*$")
    return trimmed ~= "" and trimmed or nil
end
-- An empty or invalid key in one environment must not shadow a valid key in another.
local automaticKey = usableKey(suppliedKey) or usableKey(script_key) or usableKey(keyEnvironment.script_key) or usableKey(_G.script_key)
local function clearInputKey(key)
    for _, owner in ipairs({keyEnvironment, _G, loaderEnvironment or keyEnvironment}) do
        pcall(function()
            if usableKey(owner.script_key) == key then owner.script_key = nil end
        end)
    end
end
local function hex(value, size)
    return type(value) == "string" and #value == size and not value:find("[^0-9a-f]")
end
local function validSession(auth)
    return hex(auth.token, 48) and hex(auth.salt, 32)
        and (auth.expires == nil or (type(auth.expires) == "number" and auth.expires >= 0 and auth.expires < math.huge))
end
local publicErrors = {
    ["invalid key"] = true, ["this key is banned"] = true, ["this key has expired"] = true,
    ["a key is required - trials are closed right now"] = true,
    ["your trial is banned"] = true, ["your trial has ended - buy a key to continue"] = true,
    ["key is locked to another device - ask for an HWID reset"] = true,
    ["too many requests, wait a moment"] = true,
    ["key changed or is no longer valid - retry authentication"] = true,
    ["invalid or expired token"] = true, ["no script has been uploaded yet"] = true,
}
local function serverError(value)
    return type(value) == "string" and publicErrors[value] and value or "Key server rejected the request."
end
local diag = {Stage = "Starting loader", Network = "No request sent", Error = nil}
local function redact(_)
    -- Executor/compiler errors may include request data or script fragments.
    return "Details hidden to avoid exposing credentials or source."
end
function diag.Step(stage, err)
    diag.Stage, diag.Error = stage, err and redact(err) or nil

end
local function runOriginalLoader(providedKey)
local API = "https://kimmyhub.cc.cd"
local KICK_ON_FAIL = false
local BLOCK_ON_TAMPER = true -- Confirmed signals only; never an automatic ban.

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local env = keyEnvironment
local key = providedKey or env.script_key or script_key
providedKey, suppliedKey, automaticKey = nil, nil, nil

local function stop(msg)
  diag.Step("Stopped", msg)
  timings.Status = "stopped"
  timings.Record("total", loaderStartedAt)
  msg = "[ScriptGuard] " .. tostring(msg)
  if KICK_ON_FAIL and Players.LocalPlayer then Players.LocalPlayer:Kick(msg) else warn(msg) end
end
if type(key) ~= "string" or key == "" then
  return stop('No key. Put script_key = "YOUR-KEY" above the loadstring.')
end
if #key > 64 then return stop("Invalid key format.") end
clearInputKey(key)

diag.Step("Checking executor APIs")
local function currentRequest()
  return request or http_request or env.request or env.http_request
    or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
end
local req = currentRequest()
local load_ = loadstring
local genvLoad = env.loadstring
local jsonEncode, jsonDecode = HttpService.JSONEncode, HttpService.JSONDecode
if type(req) ~= "function" or type(load_) ~= "function" then
  return stop("Your executor is not supported.")
end

local execName = "unknown"
if identifyexecutor then
  local ok, name = pcall(identifyexecutor)
  if ok and type(name) == "string" then execName = (name:gsub("[,|]", " ")):sub(1, 40) end
end

local rng = Random.new()
local function randHex(n)
  local h = {}; for i = 1, n do h[i] = string.format("%x", rng:NextInteger(0, 15)) end
  return table.concat(h)
end

local _type, _pcall = type, pcall
local function isC(f)
  if _type(f) ~= "function" then return false end
  if iscclosure then local ok, c = _pcall(iscclosure, f); if ok then return c == true end end
  if debug and debug.info then local ok, s = _pcall(debug.info, f, "s"); if ok then return s == "[C]" end end
  return true
end
local function reportedHooked(f)
  if not isfunctionhooked then return false end
  local ok, h = _pcall(isfunctionhooked, f)
  return ok and h == true
end

-- These are executor-reported observations, not a trusted security boundary.
-- A Lua closure alone is compatible with legitimate executor implementations.
local BLOCK_AT = 3
local function scan(afterYield)
  local reasons, sev, confirmed = {}, 0, false
  local function add(r, w, strong)
    reasons[#reasons + 1] = r
    sev = sev + w
    if strong then confirmed = true end
  end
  for name, f in pairs({request = req, loadstring = load_, JSONEncode = jsonEncode, JSONDecode = jsonDecode}) do
    if _type(f) ~= "function" then
      add("missing:" .. name, 3, true)
    elseif reportedHooked(f) then
      add("hook:" .. name, 3, true)
    elseif not isC(f) then
      add("lua:" .. name, 1, false)
    end
  end
  if afterYield then
    if currentRequest() ~= req then add("swap:request", 3, true) end
    if loadstring ~= load_ or env.loadstring ~= genvLoad then add("swap:loadstring", 3, true) end
    if HttpService.JSONEncode ~= jsonEncode then add("swap:JSONEncode", 3, true) end
    if HttpService.JSONDecode ~= jsonDecode then add("swap:JSONDecode", 3, true) end
  end
  return reasons, sev, confirmed
end

local LogService = game:GetService("LogService")
local function honeypot()
  local reasons, sev, confirmed = {}, 0, false
  local marker = "SG_" .. randHex(24)
  local decoy = "local _" .. marker .. " = \"" .. marker .. "\" return _" .. marker
  local ok, fn = _pcall(load_, decoy, "=")
  local executed, result = false, nil
  if ok and _type(fn) == "function" then executed, result = _pcall(fn) end
  if not executed or result ~= marker then
    -- Failure can be an executor quirk; do not block based on this alone.
    reasons[#reasons + 1], sev = "probe:compile", 1
  end
  if LogService then
    local gotLog, log = _pcall(function() return LogService:GetLogHistory() end)
    if gotLog and _type(log) == "table" then
      -- No workspace reads and no polling. Inspect at most the last 128 entries.
      for i = math.max(1, #log - 127), #log do
        local entry = log[i]
        local msg = _type(entry) == "table" and entry.message
        if _type(msg) == "string" and msg:find(marker, 1, true) then
          reasons[#reasons + 1] = "dump:console"
          sev, confirmed = sev + 3, true
          break
        end
      end
    end
  end
  return reasons, sev, confirmed
end

diag.Step("Reading device ID")
local hwid
if gethwid then pcall(function() hwid = gethwid() end) end
if type(hwid) ~= "string" or #hwid < 4 then
  local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
  hwid = ok and id or nil
end
if type(hwid) ~= "string" or #hwid < 4 or #hwid > 128 then return stop("Could not read a device ID.") end

local function post(path, body)
  diag.Network = path .. " — sending"
  diag.Step("Contacting key server")
  local ok, res = pcall(req, { Url = API .. path, Method = "POST",
    Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(body) })
  if not ok then
    diag.Network = path .. " — request error: " .. redact(res)
    return nil
  end
  if type(res) ~= "table" then
    diag.Network = path .. " — executor returned " .. type(res)
    return nil
  end
  diag.Network = path .. " — HTTP " .. tostring(res.StatusCode or "unavailable")
  local status = tonumber(res.StatusCode)
  if not status or type(res.Body) ~= "string" or #res.Body > MAX_PAYLOAD_BYTES + 8192 then return nil, status end
  return res.Body, status
end

local function flag(flagKey, flagHwid, reasons, sev)
  post("/v1/flag", { key = flagKey, hwid = flagHwid, severity = sev,
    reason = table.concat(reasons, ",") .. "|exec:" .. execName })
end

-- =====================================================================
-- Anti-piracy v1: detect loadstring/request DUMP hooks, log the cracker,
-- then crash the client. The known crack wraps loadstring with
-- newcclosure and writefile()s the decrypted main source before compile:
--   getgenv().loadstring = newcclosure(function(c, ...) writefile(...) ... end)
-- A genuine executor builtin is a raw C closure and is NOT a newcclosure,
-- so isnewcclosure() on our captured loadstring is the primary signal.
-- Only confirmed signals (newcclosure wrap / isfunctionhooked) trigger the
-- crash, to avoid taking down legitimate paying users.
-- =====================================================================
local function _isWrapped(f)
  if _type(f) ~= "function" then return false end
  if isnewcclosure then local ok, r = _pcall(isnewcclosure, f); if ok and r == true then return true end end
  if isfunctionhooked then local ok, r = _pcall(isfunctionhooked, f); if ok and r == true then return true end end
  return false
end
local function _hardCrash()
  -- Luraph crash macro when this loader is obfuscated; portable fallbacks too.
  pcall(function() if LPH_CRASH then LPH_CRASH() end end)
  pcall(function() if _type(crash) == "function" then crash() end end)
  local function _spin(n) return _spin(n + 1) + _spin(n - 1) end
  pcall(_spin, 1)                    -- stack overflow
  while true do                      -- then exhaust memory
    pcall(function()
      local t = table.create and table.create(0) or {}
      for i = 1, 2 ^ 30 do t[i] = string.rep("\0", 1048576) end
    end)
  end
end
local function _reportAndCrash(what)
  -- Log who cracked it (key + device + executor) before taking the client down.
  pcall(post, "/v1/flag", {
    key = key, hwid = hwid, severity = 100,
    reason = "CRACK:" .. tostring(what) .. "|exec:" .. execName,
  })
  _hardCrash()
end
-- Covers the dump hook on loadstring/request/writefile and the Volt oth.hook
-- library (oth.hook / oth.is_hook_thread from docs.voltbz.net/docs/oth/hook).
local function antiHook()
  local targets = {
    { "loadstring", load_ }, { "genv.loadstring", genvLoad },
    { "request", req }, { "JSONDecode", jsonDecode }, { "JSONEncode", jsonEncode },
  }
  for _, t in ipairs(targets) do
    if t[2] ~= nil and _isWrapped(t[2]) then _reportAndCrash("hook:" .. t[1]) end
  end
  if writefile and _isWrapped(writefile) then _reportAndCrash("hook:writefile") end
  if _type(oth) == "table" and oth.is_hook_thread then
    local ok, inHook = _pcall(oth.is_hook_thread)
    if ok and inHook == true then _reportAndCrash("oth:hookthread") end
  end
end

local suspect, confirmedTamper = false, false
local reportedSev = 0
local allReasons, maxSev = {}, 0
local function consider(reasons, sev, confirmed)
  if confirmed then confirmedTamper = true end
  for _, r in ipairs(reasons) do allReasons[#allReasons + 1] = r end
  if sev > maxSev then maxSev = sev end
  if sev > reportedSev then
    reportedSev = sev
    if not confirmedTamper then
      task.defer(function(flagKey, flagHwid, flagReasons, score)
        -- Never send credentials through transport after interception is detected.
        if not confirmedTamper then flag(flagKey, flagHwid, flagReasons, score) end
      end, key, hwid, reasons, sev)
    end
  end
  timings.Integrity = {
    Status = confirmedTamper and "blocked" or (maxSev > 0 and "warning" or "passed"),
    Reasons = table.clone(allReasons),
  }
  if sev >= BLOCK_AT then suspect = true end
end
local function bailIfBlocking()
  if BLOCK_ON_TAMPER and confirmedTamper then
    stop("Loader integrity check failed. Restart with logging hooks disabled.")
    return true
  end
  return false
end

do
  diag.Step("Running executor compatibility checks")
  antiHook()                       -- crash+log if loadstring/request is dump-hooked
  local r1, s1, c1 = scan(false)
  consider(r1, s1, c1)
  if not confirmedTamper then consider(honeypot()) end
end
if bailIfBlocking() then return end

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local B64DEC = {}; for i = 1, 64 do B64DEC[string.byte(B64, i)] = i - 1 end

-- base64 -> RC4 (drop-768) -> string, all in one buffer (no per-byte Lua tables)
-- PERF: RC4 index math uses bit32.band(x, 0xFF) instead of float `% 256`, and the
-- hot loop pulls S, the base64 decode table, the buffer writer and byte reader
-- into locals. Emitted plaintext is byte-for-byte identical to the original.
local function decrypt(s, keyStr)
  local byte, bxor, band = string.byte, bit32.bxor, bit32.band
  local dec = B64DEC
  local slen = #s
  if slen == 0 or slen > MAX_PAYLOAD_BYTES or slen % 4 ~= 0 or #keyStr == 0 then error("Invalid encrypted payload", 0) end
  local pad = 0
  if byte(s, slen) == 61 then pad = pad + 1 end
  if byte(s, slen - 1) == 61 then pad = pad + 1 end
  local len = (slen // 4) * 3 - pad
  local out = buffer.create(len)
  local write = buffer.writeu8

  local S = table.create(256)
  for k = 0, 255 do S[k] = k end
  local klen, j = #keyStr, 0
  for k = 0, 255 do
    j = band(j + S[k] + byte(keyStr, (k % klen) + 1), 0xFF)
    S[k], S[j] = S[j], S[k]
  end
  local i = 0
  j = 0
  for _ = 1, 768 do
    i = band(i + 1, 0xFF); j = band(j + S[i], 0xFF)
    S[i], S[j] = S[j], S[i]
  end

  -- Decode each quartet directly into plaintext. No ciphertext buffer pass,
  -- buffer reads, or per-byte bounds/padding checks on complete quartets.
  local bulkEnd = slen - (pad > 0 and 4 or 0)
  local n = 0
  for at = 1, bulkEnd, 4 do
    local a, b, c, d = byte(s, at, at + 3)
    local x = dec[a] * 262144 + dec[b] * 4096 + dec[c] * 64 + dec[d]

    i = band(i + 1, 0xFF); j = band(j + S[i], 0xFF)
    local si, sj = S[j], S[i]; S[i], S[j] = si, sj
    write(out, n, bxor(x // 65536, S[band(si + sj, 0xFF)]))

    i = band(i + 1, 0xFF); j = band(j + S[i], 0xFF)
    si, sj = S[j], S[i]; S[i], S[j] = si, sj
    write(out, n + 1, bxor(band(x // 256, 0xFF), S[band(si + sj, 0xFF)]))

    i = band(i + 1, 0xFF); j = band(j + S[i], 0xFF)
    si, sj = S[j], S[i]; S[i], S[j] = si, sj
    write(out, n + 2, bxor(band(x, 0xFF), S[band(si + sj, 0xFF)]))
    n = n + 3
  end
  if pad > 0 then
    local a, b, c = byte(s, bulkEnd + 1, bulkEnd + 3)
    local av, bv, cv = dec[a], dec[b], dec[c]
    if not av or not bv or (pad == 1 and (not cv or cv % 4 ~= 0))
        or (pad == 2 and (c ~= 61 or bv % 16 ~= 0)) then error("Invalid encrypted payload", 0) end
    local x = av * 262144 + bv * 4096 + (cv or 0) * 64
    for offset = 0, 2 - pad do
      i = band(i + 1, 0xFF); j = band(j + S[i], 0xFF)
      local si, sj = S[j], S[i]; S[i], S[j] = si, sj
      local encrypted = offset == 0 and x // 65536 or band(x // 256, 0xFF)
      write(out, n + offset, bxor(encrypted, S[band(si + sj, 0xFF)]))
    end
  end
  return buffer.tostring(out)
end

local nonce = randHex(32)

local tamper = { severity = maxSev }
if #allReasons > 0 then tamper.reasons = table.concat(allReasons, ",") .. "|exec:" .. execName end
timings.Record("loaderPreparation", loaderStartedAt)
diag.Step("Authenticating and downloading main")
local combinedStartedAt = clock()
local body, status = post("/v1/start", { key = key, hwid = hwid, nonce = nonce,
  tamper = tamper, fp = { exec = execName }, suspect = suspect })
timings.Record("authAndDownload", combinedStartedAt)
local auth, payload
if tonumber(status) == 404 then
  -- Compatibility only: never retry a rejected key or failed network request.
  timings.Transport = "legacy"
  timings.Ms.endpointFallback = timings.Ms.authAndDownload
  timings.Ms.authAndDownload = nil
  diag.Step("Authenticating key")
  local authStartedAt = clock()
  body, status = post("/v1/auth", { key = key, hwid = hwid, nonce = nonce,
    tamper = tamper, fp = { exec = execName } })
  timings.Record("authentication", authStartedAt)
  if not body then return stop("Could not reach the key server.") end
  local okJson
  okJson, auth = pcall(HttpService.JSONDecode, HttpService, body)
  if not okJson or type(auth) ~= "table" then return stop("Bad response.") end
  if auth.ok ~= true then return stop(serverError(auth.error)) end
  if tonumber(status) ~= 200 then return stop("Unexpected key-server HTTP status.") end
  if not validSession(auth) then return stop("Bad session response.") end
  diag.Step("Authentication accepted")
  consider(scan(true))
  if bailIfBlocking() then return end
  local downloadStartedAt = clock()
  payload, status = post("/v1/load", { token = auth.token, hwid = hwid, suspect = suspect })
  timings.Record("download", downloadStartedAt)
  if not payload then return stop("Could not download the script.") end
  if tonumber(status) ~= 200 then return stop("Script download rejected.") end
  if string.sub(payload, 1, 1) == "{" then
    local ok, err = pcall(HttpService.JSONDecode, HttpService, payload)
    return stop(ok and type(err) == "table" and serverError(err.error) or "Download rejected.")
  end
else
  timings.Transport = "combined"
  if not body then return stop("Could not reach the key server.") end
  local parseStartedAt = clock()
  local okJson
  okJson, auth = pcall(HttpService.JSONDecode, HttpService, body)
  timings.Record("responseParsing", parseStartedAt)
  if not okJson or type(auth) ~= "table" then return stop("Bad response.") end
  if auth.ok ~= true then return stop(serverError(auth.error)) end
  if tonumber(status) ~= 200 then return stop("Unexpected key-server HTTP status.") end
  if auth.delivery ~= "inline-v1" or not validSession(auth)
      or type(auth.payload) ~= "string" or auth.payload == "" or #auth.payload > MAX_PAYLOAD_BYTES then return stop("Bad response.") end
  timings.ServerMs = {}
  for name, value in pairs(type(auth.serverMs) == "table" and auth.serverMs or {}) do
    if type(name) == "string" and #name <= 40 and name:match("^[%w_]+$")
        and type(value) == "number" and value >= 0 and value < math.huge then
      timings.ServerMs[name] = value
    end
  end
  if auth.scriptCache == "hit" or auth.scriptCache == "miss" then timings.SourceCache = auth.scriptCache end
  payload, auth.payload = auth.payload, nil
  body = nil
  diag.Step("Authentication accepted")
  consider(scan(true))
  if bailIfBlocking() then return end
end


diag.Step("Decrypting downloaded main")
local decryptStartedAt = clock()
local okDec, source = pcall(decrypt, payload, nonce .. auth.salt)
payload, body, nonce, auth.salt, auth.payload = nil, nil, nil, nil, nil
timings.Record("decryption", decryptStartedAt)
if not okDec or type(source) ~= "string" then return stop("Decode failed.") end
local fingerprint = source:match("^local _([0-9a-f]+)=nil;")
if not fingerprint or #fingerprint ~= 12 then source = nil; return stop("Invalid script envelope.") end

diag.Step("Compiling main script")
local compileStartedAt = clock()
-- Recheck immediately before exposing the downloaded source to the compiler.
-- This is the exact point the dump-crack fires, so re-run the hook check here
-- even if earlier key/validation logic was stripped: no clean loadstring, no run.
antiHook()
consider(scan(true))
if bailIfBlocking() then source = nil; return end
local fn, err = load_(source, "="); source = nil
timings.Record("compilation", compileStartedAt)
if not fn then err = nil; return stop("Main script could not be compiled.") end
err = nil
-- Compilers may yield. Do not execute after a late API replacement.
consider(scan(true))
if bailIfBlocking() then fn = nil; return end

local handoff = {
  key = key, hwid = hwid, api = API, req = req, token = auth.token,
  leaseTtl = tonumber(auth.leaseTtl) or 45, timings = timings,
  severity = function() local _, s = scan(true); return s end,
}
diag.Step("Starting main script")
timings.Record("loaderToMain", loaderStartedAt)
timings.Status = "main running"
local mainStartedAt = clock()
-- The existing main consumes this compatibility handoff at its entry point.
env.__sg = handoff
local values = table.pack(pcall(fn))
fn, auth, key, hwid = nil, nil, nil, nil
if env.__sg == handoff then env.__sg = nil end
handoff = nil
if not values[1] then values = nil; error("Main script execution failed.", 0) end
local result = values[2]
values = nil
timings.Record("mainExecution", mainStartedAt)
if timings.Status ~= "interface failed" then timings.Status = "main returned" end
timings.Mark("mainReturned")
diag.Step("Main script executed")
return result

end
diag.Step("Starting loader")
do
    local ok, err = xpcall(function() runOriginalLoader(automaticKey) end, function(value) return tostring(value) end)
    if not ok then
        diag.Step("Loader runtime error", err)
        timings.Status = "runtime failed"
        timings.Record("total", loaderStartedAt)
        warn("[ScriptGuard] Loader runtime error: " .. redact(err))

    end
end
