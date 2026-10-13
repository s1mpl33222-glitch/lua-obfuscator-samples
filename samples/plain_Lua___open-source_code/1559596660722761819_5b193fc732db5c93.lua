do local g=(type(getgenv)=="function" and getgenv())or _G;g.XA_LOADER_CFG={api="https://xenith-auth.online",mirrors={"https://xenith-api.online"},project="axon",script="5b193fc732db5c93",version=1,free=true} end
do
  local a, g = pcall(getgenv)
  g = (a and type(g) == "table" and g) or _G
  if type(g) == "table" and type(rawget(g, "script_key")) ~= "string" and type(getfenv) == "function" then
    for l = 2, 12 do
      local ok, e = pcall(getfenv, l)
      if ok and type(e) == "table" then
        local k = rawget(e, "script_key") or rawget(e, "key")
        if type(k) == "string" and #k > 0 then pcall(function() g.script_key = k end) break end
      end
    end
  end
end
--[[
  Xenith Auth :: loader

  Usage in the user's executor:

      script_key = "XENITH-XXXXX-XXXXX-XXXXX-XXXXX"
      loadstring(game:HttpGet("<api>/v1/loader/<project>"))()

  This body is obfuscated ONCE and shared by every script. The per-script
  values (api / project / script / version / free) are injected at serve time
  by a tiny plaintext header the server prepends, which sets XA_LOADER_CFG; we
  read it here and clear it so nothing lingers in the environment.
]]

local __cfg = (type(getgenv) == "function" and getgenv().XA_LOADER_CFG)
	or rawget(_G, "XA_LOADER_CFG")
	or {}
pcall(function() if type(getgenv) == "function" then getgenv().XA_LOADER_CFG = nil end end)
pcall(function() rawset(_G, "XA_LOADER_CFG", nil) end)

local LOADER_VERSION = tonumber(__cfg.version) or 1
local API = tostring(__cfg.api or "")
-- The same server under other names, for players whose network blocks the
-- first one (by DNS or in the TLS handshake). Attempts rotate through these,
-- starting from whichever name answered last.
local HOSTS = { API }
if type(__cfg.mirrors) == "table" then
	for _, m in ipairs(__cfg.mirrors) do
		if type(m) == "string" and #m > 0 then HOSTS[#HOSTS + 1] = m end
	end
end
local hostIdx = 1
local function urlFor(url, attempt)
	for _, h in ipairs(HOSTS) do
		if type(url) == "string" and url:sub(1, #h) == h then
			local idx = ((hostIdx + attempt - 2) % #HOSTS) + 1
			return HOSTS[idx] .. url:sub(#h + 1), idx
		end
	end
	return url, nil
end
local PROJECT = tostring(__cfg.project or "")
local SCRIPT = tostring(__cfg.script or "")
local IS_FREE = __cfg.free and 1 or 0 -- 1 for a free-for-all script (no key required)

-- Portability shims for barebones / broken executors: fall back whenever a
-- Luau or Roblox global is missing, so a "trash" environment degrades to a
-- working (if plainer) path instead of hard-erroring on the first missing name.
local typeof = typeof or type
local clamp = (math and math.clamp) or function(x, lo, hi)
	if x < lo then return lo elseif x > hi then return hi else return x end
end

-- Anti-tamper: cloneref returns a reference to `game` that ignores the
-- metatable hooks (__namecall / __index) crackers use to intercept :GetService,
-- :HttpGet and :HttpGetAsync. Fetched once, up front, before the payload runs.
-- Falls back to the real game on executors without cloneref.
local realGame = game
pcall(function()
	if typeof(cloneref) == "function" then realGame = cloneref(game) end
end)

-- A service is fetched defensively: some executors block or break :GetService
-- for individual services. Only HttpService's JSON is truly needed (and it has
-- a pure-Lua fallback below); the rest are optional metadata.
local function getService(name)
	local ok, s = pcall(function() return realGame:GetService(name) end)
	if ok and s then return s end
	ok, s = pcall(function() return game:GetService(name) end)
	return ok and s or nil
end
local HttpService = getService("HttpService")
local UserInputService = getService("UserInputService")
local GuiService = getService("GuiService")
local Players = getService("Players")

------------------------------------------------------------------------- json

-- Executors almost always expose HttpService:JSONEncode/Decode, but a hardened
-- or broken environment can strip it. These wrappers use it when it works and
-- fall back to a compact pure-Lua implementation otherwise, so authentication
-- never dies just because JSON is sandboxed. Requests we send are flat objects;
-- responses are small objects plus one big base64 string — both handled here.
local function jsonEncodeFallback(v)
	local t = type(v)
	if t == "string" then
		return '"' .. v:gsub('[%z\1-\31\\"]', function(c)
			local named = { ['"'] = '\\"', ['\\'] = '\\\\', ['\n'] = '\\n', ['\r'] = '\\r', ['\t'] = '\\t', ['\b'] = '\\b', ['\f'] = '\\f' }
			return named[c] or string.format('\\u%04x', string.byte(c))
		end) .. '"'
	elseif t == "number" then
		if v ~= v or v == math.huge or v == -math.huge then return "null" end
		return tostring(v)
	elseif t == "boolean" then
		return tostring(v)
	elseif t == "table" then
		local parts = {}
		for k, val in pairs(v) do
			if type(k) == "string" then
				parts[#parts + 1] = jsonEncodeFallback(k) .. ":" .. jsonEncodeFallback(val)
			end
		end
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return "null"
end

local function jsonDecodeFallback(s)
	if type(s) ~= "string" then return nil end
	local i = 1
	local function skip()
		while i <= #s do
			local c = string.sub(s, i, i)
			if c == " " or c == "\t" or c == "\n" or c == "\r" then i = i + 1 else break end
		end
	end
	local parseValue
	local function parseString()
		i = i + 1
		local buf = {}
		while i <= #s do
			local c = string.sub(s, i, i)
			if c == '"' then i = i + 1 return table.concat(buf) end
			if c == "\\" then
				local e = string.sub(s, i + 1, i + 1)
				if e == "n" then buf[#buf + 1] = "\n"
				elseif e == "t" then buf[#buf + 1] = "\t"
				elseif e == "r" then buf[#buf + 1] = "\r"
				elseif e == "b" then buf[#buf + 1] = "\b"
				elseif e == "f" then buf[#buf + 1] = "\f"
				elseif e == "u" then
					local n = tonumber(string.sub(s, i + 2, i + 5), 16) or 0
					if n < 0x80 then buf[#buf + 1] = string.char(n)
					elseif n < 0x800 then buf[#buf + 1] = string.char(0xC0 + math.floor(n / 0x40), 0x80 + n % 0x40)
					else buf[#buf + 1] = string.char(0xE0 + math.floor(n / 0x1000), 0x80 + math.floor(n / 0x40) % 0x40, 0x80 + n % 0x40) end
					i = i + 4
				else buf[#buf + 1] = e end
				i = i + 2
			else
				buf[#buf + 1] = c
				i = i + 1
			end
		end
		error("unterminated string")
	end
	parseValue = function()
		skip()
		local c = string.sub(s, i, i)
		if c == '"' then
			return parseString()
		elseif c == "{" then
			i = i + 1
			local obj = {}
			skip()
			if string.sub(s, i, i) == "}" then i = i + 1 return obj end
			while true do
				skip()
				local k = parseString()
				skip()
				i = i + 1 -- ':'
				obj[k] = parseValue()
				skip()
				local d = string.sub(s, i, i)
				i = i + 1
				if d == "}" then return obj end
			end
		elseif c == "[" then
			i = i + 1
			local arr = {}
			skip()
			if string.sub(s, i, i) == "]" then i = i + 1 return arr end
			while true do
				arr[#arr + 1] = parseValue()
				skip()
				local d = string.sub(s, i, i)
				i = i + 1
				if d == "]" then return arr end
			end
		elseif c == "t" then i = i + 4 return true
		elseif c == "f" then i = i + 5 return false
		elseif c == "n" then i = i + 4 return nil
		else
			local j = i
			while i <= #s and string.match(string.sub(s, i, i), "[%-%+%.eE0-9]") do i = i + 1 end
			return tonumber(string.sub(s, j, i - 1))
		end
	end
	local ok, res = pcall(parseValue)
	if ok then return res end
	return nil
end

local function jsonEncode(t)
	if HttpService then
		local ok, out = pcall(function() return HttpService:JSONEncode(t) end)
		if ok and type(out) == "string" then return out end
	end
	return jsonEncodeFallback(t)
end

local function jsonDecode(str)
	if HttpService then
		local ok, out = pcall(function() return HttpService:JSONDecode(str) end)
		if ok and type(out) == "table" then return out end
	end
	return jsonDecodeFallback(str)
end

local genv = (typeof(getgenv) == "function" and getgenv()) or _G or {}
local yield = (task and task.wait) or wait
-- Wall-clock seconds (tick is wall-clock; os.clock is CPU time and stalls while
-- the thread yields, so it is only a last resort).
local wallclock = (typeof(tick) == "function" and tick) or os.clock
-- Forward-declared so fail() can tear the loading UI down on any error.
local loadingUI
local loaderStartedAt = wallclock()

---------------------------------------------------------------- notification

local function notify(title, text, duration)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = title,
			Text = text,
			Duration = duration or 8,
		})
	end)
end

local function fail(message)
	if loadingUI then pcall(function() loadingUI.destroy() end) end
	notify("Xenith Auth", message, 10)
	error("[Xenith Auth] " .. message, 0)
end

------------------------------------------------------------- loading bar

-- A Luarmor-style progress bar printed to the executor console:
--   Xenith [########------------] 42%   Preparing your script...
-- Reprints only when the percentage or the note changes, so it reads as a
-- short progress log rather than spamming a line every frame.
local function makeLoadingUI()
	local WIDTH = 22
	local note = ""
	local pct = 0
	local lastKey = nil
	local function draw()
		local filled = math.floor(pct * WIDTH + 0.5)
		if filled < 0 then filled = 0 elseif filled > WIDTH then filled = WIDTH end
		local bar = string.rep("#", filled) .. string.rep("-", WIDTH - filled)
		local line = ("Xenith [%s] %d%%"):format(bar, math.floor(pct * 100 + 0.5))
		if note ~= "" then line = line .. "   " .. note end
		local key = filled .. "|" .. note
		if key ~= lastKey then
			lastKey = key
			pcall(print, line)
		end
	end
	return {
		set = function(p)
			pct = clamp(p, 0, 1)
			draw()
		end,
		status = function(t)
			note = tostring(t)
			draw()
		end,
		destroy = function() pcall(print, "Xenith  ready") end,
	}
end

------------------------------------------------------------------ http shim

-- Executors expose their request function under several different names.
-- Anti-hook, cross-executor and false-positive-free: gather every source, then
-- prefer a clean NATIVE (cclosure) one. If a cracker hooks a single source with
-- a Lua function, another source is usually still native, so we route around
-- the hook instead of kicking a legitimate user whose request just happens to
-- be a Lua wrapper. Where the executor exposes a real unhook (restorefunction),
-- we try that too.
local requestSources = {}
local function addRequest(f)
	if typeof(f) == "function" then requestSources[#requestSources + 1] = f end
end
addRequest(syn and syn.request)
addRequest(http and http.request)
addRequest(http_request)
addRequest(httprequest)
addRequest(fluxus and fluxus.request)
addRequest(Krnl and Krnl.request)
addRequest(request)
pcall(function() addRequest(getgenv and getgenv().request) end)

local request, requestHooked = nil, false
if typeof(iscclosure) == "function" then
	for _, f in ipairs(requestSources) do
		local ok, native = pcall(iscclosure, f)
		if ok and native then request = f break end
	end
	-- Every source is a Lua closure: on executors whose request is natively a
	-- cclosure this means it was replaced (hooked). It is only a hint — some
	-- executors wrap request in Lua by default — so we flag it, never kick.
	if not request and #requestSources > 0 then requestHooked = true end
end
request = request or requestSources[1]

-- Best-effort unhook where the executor supports it. Guarded: a no-op (or a
-- harmless failure) everywhere else, and never replaces the working function.
if typeof(restorefunction) == "function" then pcall(restorefunction, request) end

-- Last-resort shim for minimal executors that expose no `request` function but
-- do have game:HttpGet / a POST variant. Signed auth needs POST, so we try a
-- few well-known POST names; if none exist the retry loop below just fails with
-- a clean "could not reach the server" message rather than a raw error.
if typeof(request) ~= "function" then
	local ct = "application/json"
	local postVariants = {
		function(u, b) return game:HttpPostAsync(u, b, ct) end,
		function(u, b) return game:HttpPost(u, b, ct) end,
		function(u, b) return game:HttpPost(u, b, false, ct) end,
	}
	request = function(opts)
		local url = opts.Url
		local method = string.upper(opts.Method or "GET")
		if method == "POST" then
			for _, fn in ipairs(postVariants) do
				local ok, res = pcall(fn, url, opts.Body)
				if ok and type(res) == "string" then return { Body = res, StatusCode = 200, Success = true } end
			end
			return nil
		end
		local ok, res = pcall(function() return game:HttpGet(url) end)
		if ok and type(res) == "string" then return { Body = res, StatusCode = 200, Success = true } end
		return nil
	end
end

-- Bad-wifi resilience: retry a request through transient failures (dropped
-- connection, timeout, a 5xx or an empty body) with a short backoff, instead
-- of failing the whole load on the first blip. A 4xx is deterministic and
-- returned as-is so the caller can handle it. Returns the response or nil.
local function httpRequest(opts, tries)
	tries = tries or 5
	local last
	for i = 1, tries do
		local o = {}
		for k, v in pairs(opts) do o[k] = v end
		local idx
		o.Url, idx = urlFor(opts.Url, i)
		local ok, res = pcall(request, o)
		if ok and type(res) == "table" and res.Body
			and (type(res.StatusCode) ~= "number" or (res.StatusCode < 500 and res.StatusCode ~= 0)) then
			if idx then hostIdx = idx end
			return res
		end
		last = res
		if i < tries then pcall(yield, math.min(0.5 * i, 3)) end
	end
	return nil, last
end

--------------------------------------------------------------------- base64

local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local function base64Decode(data, onProgress)
	-- The executor's native decoder is one fast C call — the common path, and
	-- the reason the loader no longer lags on large payloads.
	if crypt and typeof(crypt.base64decode) == "function" then
		local ok, out = pcall(crypt.base64decode, data)
		if ok and out then if onProgress then onProgress(1) end return out end
	end
	if base64 and typeof(base64.decode) == "function" then
		local ok, out = pcall(base64.decode, data)
		if ok and out then if onProgress then onProgress(1) end return out end
	end

	-- Pure-Lua fallback for executors without a native decoder: yields so it
	-- never freezes the client and keeps the bar moving.
	local lookup = {}
	for i = 1, #B64 do
		lookup[string.byte(B64, i)] = i - 1
	end

	local out = {}
	local acc, bits = 0, 0
	local n = #data
	for i = 1, n do
		local v = lookup[string.byte(data, i)]
		if v then
			acc = acc * 64 + v
			bits = bits + 6
			if bits >= 8 then
				bits = bits - 8
				out[#out + 1] = string.char(math.floor(acc / 2 ^ bits) % 256)
				acc = acc % 2 ^ bits
			end
		end
		if i % 16384 == 0 then
			if onProgress then onProgress(i / n) end
			yield()
		end
	end
	return table.concat(out)
end


----------------------------------------------------------------- fingerprint

local function getHwid()
	for _, fn in ipairs({ gethwid or false, get_hwid or false }) do
		if typeof(fn) == "function" then
			local ok, id = pcall(fn)
			if ok and type(id) == "string" and #id > 0 then return id end
		end
	end
	local ok, id = pcall(function()
		return game:GetService("RbxAnalyticsService"):GetClientId()
	end)
	if ok and type(id) == "string" and #id > 0 then return id end
	-- Last resort, mirrored in the key-check library so both sides bind the
	-- same value: the Roblox account. Weaker than a device id, but it works.
	local ok2, uid = pcall(function() return game:GetService("Players").LocalPlayer.UserId end)
	if ok2 and type(uid) == "number" and uid > 0 then return "uid:" .. tostring(uid) end
	fail("Could not determine your HWID on this executor.")
end

local function getExecutor()
	for _, fn in ipairs({ identifyexecutor or false, getexecutorname or false, get_executor_name or false }) do
		if typeof(fn) == "function" then
			local ok, name = pcall(fn)
			if ok and type(name) == "string" and #name > 0 then return name end
		end
	end
	return "Unknown"
end

local function getPlatform()
	local ok, plat = pcall(function()
		return tostring(UserInputService:GetPlatform()):gsub("Enum%.Platform%.", "")
	end)
	return ok and plat or "Unknown"
end

local function getViewport()
	local ok, x, y = pcall(function()
		local cam = workspace.CurrentCamera
		if cam and cam.ViewportSize then
			return math.floor(cam.ViewportSize.X), math.floor(cam.ViewportSize.Y)
		end
		return 0, 0
	end)
	if ok then return x or 0, y or 0 end
	return 0, 0
end

------------------------------------------------------------------- key input

local key = genv.script_key or _G.script_key or genv.key
if IS_FREE == 1 then
	-- Free-for-all: no key needed. Any key the user happens to have set is still
	-- passed through, but an empty one is fine.
	if type(key) ~= "string" then key = "" end
elseif type(key) ~= "string" or #key == 0 then
	fail('No key set. Put script_key = "YOUR-KEY" above the loadstring line.')
end

-- Instance registry: each running copy claims the next free slot in a shared
-- getgenv table, so several scripts can run at once, each tracked and validated
-- on its own. The slot holds the key, a per-run token, the session (filled after
-- auth) and a liveness flag; it is cleared when this run stops. The token lets
-- the loaded script confirm it was started by this loader.
local registry, slot, instanceToken
pcall(function()
	registry = genv.__xenith
	if type(registry) ~= "table" then
		registry = {}
		genv.__xenith = registry
	end
	instanceToken = tostring(math.random(1, 2147483647)) .. "-" .. tostring(math.random(1, 2147483647))
	for i = 1, 8192 do
		if registry[i] == nil then
			registry[i] = { key = key, session = false, token = instanceToken, alive = true }
			slot = i
			break
		end
	end
end)

local function freeSlot()
	if registry and slot then pcall(function() registry[slot] = nil end) end
end

-- The protected script stays in the workspace between runs, in a block order
-- only the server knows; the order arrives with a successful auth, so the file
-- alone is not a runnable script. Sending the hash of what is on disk lets the
-- server answer with ~1 KB instead of the whole body when nothing changed.
local canFile = typeof(readfile) == "function" and typeof(writefile) == "function" and typeof(isfile) == "function"
local BODY_FILE = "xenith/" .. SCRIPT .. ".body.txt"
local HASH_FILE = "xenith/" .. SCRIPT .. ".body.hash"
local cachedHash = nil
if canFile then
	pcall(function()
		if isfile(HASH_FILE) then
			local h = readfile(HASH_FILE)
			if type(h) == "string" and #h > 0 and #h <= 32 then cachedHash = h:gsub("%s+", "") end
		end
	end)
end

-- Show the loading card now, so the user sees Xenith while we authenticate.
loadingUI = makeLoadingUI()
loaderStartedAt = wallclock()
loadingUI.status("Authenticating...")
loadingUI.set(0.04)

------------------------------------------------------------------ authenticate

local vpx, vpy = getViewport()
local localPlayer = Players and Players.LocalPlayer

local payload = {
	project = PROJECT,
	script = SCRIPT,
	key = key,
	hwid = getHwid(),
	executor = getExecutor(),
	platform = getPlatform(),
	touch = (UserInputService and UserInputService.TouchEnabled) or false,
	keyboard = (UserInputService and UserInputService.KeyboardEnabled) or false,
	tenFoot = (function()
		local ok, v = pcall(function() return GuiService:IsTenFootInterface() end)
		return ok and v or false
	end)(),
	vpx = vpx,
	vpy = vpy,
	userId = localPlayer and localPlayer.UserId or nil,
	username = localPlayer and localPlayer.Name or nil,
	placeId = game.PlaceId,
	jobId = game.JobId,
	v = LOADER_VERSION,
	ts = math.floor(os.time()),
	body = "v2",
	have = cachedHash or "",
}

-- One handshake + auth pair. The server hands the script back only to a
-- request that presents a fresh handshake nonce, so pasting the loader URL or
-- replaying a captured /v1/auth body on its own gets nothing. The nonce lives
-- 30 seconds, so a retry after a slow or timed-out attempt must start from a
-- fresh handshake: resending the old nonce came back "not allowed", which was
-- most of the failures on slow connections.
-- The handshake is stateless, so it is raced across every server name: the
-- next name starts once the previous has failed or gone 3s without answering.
-- The name that answers is the one the auth (which is NOT raced: it records
-- the run) then goes to. A network that silently drops one name costs a few
-- seconds this way instead of a full timeout per attempt.
local function raceRequest(opts)
	local order = {}
	for k = 0, #HOSTS - 1 do order[#order + 1] = ((hostIdx - 1 + k) % #HOSTS) + 1 end
	local result, winner, started, finished = nil, nil, 0, 0
	local t0 = wallclock()
	local spawnFn = (task and task.spawn) or function(f) coroutine.wrap(f)() end
	local function launch()
		started = started + 1
		local idx = order[started]
		spawnFn(function()
			local o = {}
			for k, v in pairs(opts) do o[k] = v end
			o.Url = HOSTS[idx] .. opts.Url:sub(#API + 1)
			local ok, res = pcall(request, o)
			if ok and type(res) == "table" and res.Body
				and (type(res.StatusCode) ~= "number" or (res.StatusCode < 500 and res.StatusCode ~= 0))
				and result == nil then
				result, winner = res, idx
			end
			finished = finished + 1
		end)
	end
	launch()
	while result == nil do
		if finished >= started and started >= #order then break end
		if started < #order and (finished >= started or wallclock() - t0 >= 3 * started) then launch() end
		if wallclock() - t0 > 45 then break end
		pcall(yield, 0.1)
	end
	if winner then hostIdx = winner end
	return result
end

local function authOnce()
	local hsResp = raceRequest({
		Url = API .. "/v1/handshake",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = jsonEncode({ project = PROJECT, script = SCRIPT, hwid = payload.hwid }),
	})
	if not hsResp then return nil, "network" end
	local hs
	pcall(function() hs = jsonDecode(hsResp.Body) end)
	if type(hs) ~= "table" or type(hs.nonce) ~= "string" then return nil, "unreadable" end
	payload.nonce = hs.nonce
	payload.ts = math.floor(os.time())
	local resp = httpRequest({
		Url = API .. "/v1/auth",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = jsonEncode(payload),
	}, 1)
	if not resp then return nil, "network" end
	return resp
end

-- Up to `tries` pairs, each with its own nonce. A 4xx is a real answer and
-- ends the loop (httpRequest returns it); only no-response is retried, and a
-- retry moves to the next server name in case this one is what is failing.
local function authRequest(tries)
	local resp, why
	for i = 1, tries do
		resp, why = authOnce()
		if resp then return resp end
		hostIdx = (hostIdx % #HOSTS) + 1
		if i < tries then
			-- On screen, not just the console: a slow download used to look
			-- like nothing happening at all.
			notify("Xenith Auth", ("Slow connection, retrying (%d/%d)..."):format(i + 1, tries), 5)
			pcall(yield, math.min(0.5 * i, 3))
		end
	end
	return nil, why
end

notify("Xenith Auth", "Downloading your script...", 4)
local response, why = authRequest(3)
if not response then
	if why == "unreadable" then fail("The authentication server returned an unreadable response.") end
	fail("Could not reach the authentication server. Check your connection and try again.")
end

local decoded
local parsed = pcall(function()
	decoded = jsonDecode(response.Body)
end)

if not parsed or type(decoded) ~= "table" then
	fail("The authentication server returned an unreadable response.")
end

if not decoded.ok then
	fail(decoded.message or "Authentication failed.")
end

------------------------------------------------------------------- run script

---------------------------------------------------------------- revalidation

-- Human-readable reason for a key that stopped being valid.
local function reasonText(r)
	if r == "revoked" then return "Your key has been revoked."
	elseif r == "banned" then return "Your key has been banned."
	elseif r == "expired" then return "Your key has expired."
	elseif r == "killswitch" then return "This script has been disabled."
	elseif r == "script_disabled" then return "This script has been disabled by its owner."
	elseif r == "suspended" then return "This script is currently unavailable."
	else return "Your key is no longer valid." end
end

-- Asks the server whether this key is still good. Returns (valid, reason).
-- Safe by design: any network hiccup or unreadable reply returns valid=true, so
-- a transient blip never kicks a legitimate user — only a definite server "no"
-- (an explicit ok=false) counts as invalid.
local function validate()
	local ok, res = pcall(request, {
		Url = API .. "/v1/verify",
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = jsonEncode({ session = decoded.session, script = SCRIPT }),
	})
	if not ok or type(res) ~= "table" or not res.Body then return true end
	local parsed, body = pcall(function() return jsonDecode(res.Body) end)
	if not parsed or type(body) ~= "table" then return true end
	-- Third value is the script's relaunch epoch; the revalidation loop compares
	-- it to the one this run launched with and re-runs when the owner bumps it.
	return body.ok == true, body.reason, tonumber(body.relaunch)
end

-- The auth session is short-lived and normally kept alive by re-validation, but
-- a long enough network gap (bad wifi, a backgrounded game) can let it lapse.
-- A lapsed *session* is not a bad *key*, so instead of kicking we silently mint
-- a fresh session with the same key. Returns the new session token, or (nil,
-- reason) where reason is "network" for a transient failure or a real auth
-- reason (revoked/banned/expired/…) when the key itself is no longer good.
local function reauth()
	local resp = authRequest(3)
	if not resp then return nil, "network" end
	local d
	if not pcall(function() d = jsonDecode(resp.Body) end) or type(d) ~= "table" then
		return nil, "network"
	end
	if not d.ok then return nil, d.reason or "invalid" end
	return d.session
end

if registry and slot and registry[slot] then
	registry[slot].session = decoded.session
end

-- Several protected scripts can run in one game; each one's protection
-- looks up its own session by script key, so a later run must not wipe an
-- earlier one's. The table is carried forward from the previous record.
local prevAuth = genv.XenithAuth
local sessions = (type(prevAuth) == "table" and type(prevAuth.sessions) == "table") and prevAuth.sessions or {}
sessions[SCRIPT] = decoded.session

genv.XenithAuth = {
	session = decoded.session,
	sessions = sessions,
	expires = decoded.expires,
	project = PROJECT,
	script = SCRIPT,
	slot = slot,
	token = instanceToken,
	requestHooked = requestHooked,
	heartbeat = function()
		pcall(request, {
			Url = API .. "/v1/heartbeat",
			Method = "POST",
			Headers = { ["Content-Type"] = "application/json" },
			Body = jsonEncode({ session = decoded.session, script = SCRIPT }),
		})
	end,
	-- The owner's script may call this itself: returns true while the key is
	-- valid, false (plus a reason string) once the server revokes it.
	validate = validate,
}

------------------------------------------------------------------- relaunch

-- The relaunch epoch this run started on. When a later /v1/verify reports a
-- higher one, the owner pressed "Relaunch" after we launched, so we re-run.
local RELAUNCH0 = tonumber(decoded.relaunch) or 0

-- Jump this run to the newest published version: fetch a fresh loader (it
-- re-auths and pulls the current build), stop this run's own background threads,
-- then hand off to it. ponytail: this re-executes the script — a hub that guards
-- against double-loading may need the player to rejoin to actually see it.
local function doRelaunch(epoch)
	local src
	pcall(function() src = game:HttpGet(API .. "/v1/loader/" .. SCRIPT) end)
	if type(src) ~= "string" or #src < 64 then return false end -- couldn't fetch; try again next tick
	RELAUNCH0 = epoch
	pcall(notify, "Xenith Auth", "Updating to the latest version...", 6)
	freeSlot()
	-- Bumping the generation makes this run's presence + revalidation loops stop
	-- (current() turns false), so the new run does not stack on top of this one.
	genv.__xenithPresenceGen = (genv.__xenithPresenceGen or 0) + 1
	local go = (task and task.spawn) or spawn
	go(function() pcall(function() loadstring(src, "=XenithLoader")() end) end)
	return true
end

-------------------------------------------------------------------- presence

-- Holds one live connection so the dashboard can show who is running this
-- script right now. A WebSocket where the executor has one, a small HTTP ping
-- where it does not; either way the server drops anyone who goes quiet for
-- half a minute, so leaving the game takes the count down on its own.
do
	local go = (task and task.spawn) or spawn
	local pause = (task and task.wait) or wait
	local connect = (WebSocket and WebSocket.connect)
		or (syn and syn.websocket and syn.websocket.connect)
		or (Krnl and Krnl.WebSocket and Krnl.WebSocket.connect)

	-- Executing again replaces the previous connection instead of adding one:
	-- without this, a player who runs the script ten times holds ten sockets
	-- and the dashboard sees them more than once.
	if genv.__xenithPresence then
		pcall(function() genv.__xenithPresence:Close() end)
	end
	genv.__xenithPresenceGen = (genv.__xenithPresenceGen or 0) + 1
	local generation = genv.__xenithPresenceGen
	local function current() return genv.__xenithPresenceGen == generation end

	go(function()
		if typeof(connect) == "function" then
			local ok, sock = pcall(connect, (API:gsub("^http", "ws")) .. "/v1/presence")
			if ok and sock then
				genv.__xenithPresence = sock
				local hello = pcall(function()
					sock:Send(jsonEncode({ session = decoded.session, script = SCRIPT }))
				end)
				if hello then
					while current() do
						pause(10)
						if not pcall(function() sock:Send("1") end) then break end
					end
				end
				pcall(function() sock:Close() end)
				if genv.__xenithPresence == sock then genv.__xenithPresence = nil end
				if not current() then return end
			end
		end

		-- No WebSocket on this executor, or the socket dropped: keep the same
		-- presence alive over HTTP instead. Slower cadence, same effect.
		while current() do
			pcall(request, {
				Url = API .. "/v1/heartbeat",
				Method = "POST",
				Headers = { ["Content-Type"] = "application/json" },
				Body = jsonEncode({ session = decoded.session, script = SCRIPT }),
			})
			pause(15)
		end
	end)

	-- Re-validate the key every 30 seconds while the script runs. A key revoked,
	-- banned, expired, or a project killswitched mid-session ends the session
	-- promptly instead of lasting until the game closes.
	go(function()
		while current() do
			pause(30)
			if not current() then break end
			if registry and slot and registry[slot] then registry[slot].alive = true end
			local valid, reason, relaunch = validate()
			-- A lapsed session is not an invalid key: mint a fresh one and carry on.
			-- Only kick if re-auth is refused for a real reason (revoked/banned/…).
			if not valid and (reason == "session_expired" or reason == "no_session") then
				local newSession, rr = reauth()
				if newSession then
					decoded.session = newSession
					genv.XenithAuth.session = newSession
					sessions[SCRIPT] = newSession
					if registry and slot and registry[slot] then registry[slot].session = newSession end
					valid = true
				elseif rr == "network" then
					valid = true -- transient; try again next tick rather than kicking
				else
					reason = rr
				end
			end
			if not valid then
				local msg = reasonText(reason)
				freeSlot()
				notify("Xenith Auth", msg, 10)
				pcall(function()
					localPlayer = localPlayer or Players.LocalPlayer
					if localPlayer then localPlayer:Kick("[Xenith Auth] " .. msg) end
				end)
				return
			end
			-- Still valid: relaunch if the owner asked for one after we launched.
			if relaunch and relaunch > RELAUNCH0 and doRelaunch(relaunch) then return end
		end
		-- A replaced or ended run gives its slot back.
		freeSlot()
	end)
end

-- Pace the heavy decode behind a progress bar. Two obfuscated payloads landing
-- at once can hitch the client; spreading the work with yields and holding a
-- short minimum keeps it smooth and gives the user something to look at.
local MIN_SECONDS = 7

loadingUI.status("Preparing your script...")
loadingUI.set(0.08)

local chunk, compileError
if type(decoded.script) == "string" then
	-- Older server shape: the body came inline, base64.
	local source = base64Decode(decoded.script, function(p)
		loadingUI.set(0.10 + p * 0.70)
	end)
	chunk, compileError = loadstring(source, "=XenithProtected")
else
	local block = tonumber(decoded.block) or 8192
	local order = type(decoded.order) == "table" and decoded.order or nil
	if type(decoded.hash) ~= "string" or not order or #order == 0 then
		fail("The authentication server returned an unreadable response.")
	end
	-- Original block i sits at shuffled position order[i]; putting the body
	-- back together is one concat of native substrings.
	local function assemble(s)
		local parts = {}
		for i = 1, #order do
			local j = tonumber(order[i]) or 0
			parts[i] = string.sub(s, (j - 1) * block + 1, j * block)
		end
		return table.concat(parts)
	end
	local shuffled
	if canFile and cachedHash == decoded.hash then
		pcall(function() if isfile(BODY_FILE) then shuffled = readfile(BODY_FILE) end end)
		if type(shuffled) ~= "string" or #shuffled < block * (#order - 1) then shuffled = nil end
	end
	if shuffled then
		chunk, compileError = loadstring(assemble(shuffled), "=XenithProtected")
	end
	if not chunk then
		-- Nothing usable on disk (first run, republished script, or a damaged
		-- file): fetch this version once and keep it.
		loadingUI.status("Downloading your script...")
		local res = httpRequest({
			Url = API .. "/v1/body/" .. PROJECT .. "/" .. SCRIPT .. "/" .. decoded.hash .. "?t=" .. tostring(decoded.token),
			Method = "GET",
		}, 3)
		if not res or type(res.Body) ~= "string" or #res.Body == 0 then
			fail("Could not download the script. Check your connection and try again.")
		end
		shuffled = res.Body
		chunk, compileError = loadstring(assemble(shuffled), "=XenithProtected")
		if chunk and canFile then
			pcall(function()
				if typeof(makefolder) == "function" and typeof(isfolder) == "function" and not isfolder("xenith") then makefolder("xenith") end
				writefile(BODY_FILE, shuffled)
				writefile(HASH_FILE, decoded.hash)
			end)
		end
	end
	loadingUI.set(0.80)
end
if not chunk then
	fail("The protected script failed to compile: " .. tostring(compileError))
end

-- Hold the bar to the minimum duration, crawling toward full.
loadingUI.status("Almost there...")
while wallclock() - loaderStartedAt < MIN_SECONDS do
	local t = clamp((wallclock() - loaderStartedAt) / MIN_SECONDS, 0, 1)
	loadingUI.set(0.82 + 0.16 * t)
	yield()
end

loadingUI.set(1)
loadingUI.status("Done")
yield()
loadingUI.destroy()

return chunk()
