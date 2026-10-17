local PUBLIC_BUILD = true

local function installPistonwareBuffer(developerMode)
	local nativePrint, nativeWarn, nativeError = print, warn, error
	local capacity = 512
	local entries = {}
	local head, count, dropped = 1, 0, 0
	local dumping, dumpScheduled, pendingDump = false, false, false
	local filesystemReady = false
	local buffer = {}

	pcall(function()
		filesystemReady = type(isfolder) == 'function' and isfolder('pistonware') and true or false
	end)

	local function timestamp(pathSafe)
		local value
		pcall(function()
			value = os.date(pathSafe and '!%Y%m%dT%H%M%SZ' or '!%Y-%m-%dT%H:%M:%SZ')
		end)
		return value or tostring(os.time())
	end

	local session = tostring(os.time())..'-'..tostring(math.floor(os.clock() * 1000))
	pcall(function()
		local guid = game:GetService('HttpService'):GenerateGUID(false)
		if type(guid) == 'string' and guid ~= '' then session = guid end
	end)
	local sessionFile = session:gsub('[^%w%-]', ''):sub(1, 16)
	local dumpPath = 'pistonware/errors/'..timestamp(true)..'-'..sessionFile..'.txt'

	local function safeText(value, limit)
		local text = tostring(value or '')
		text = text:gsub('[\r\n]+', ' ')
		text = text:gsub('([Ss]cript[_%s]*[Kk]ey%s*[:=]%s*)[^%s,;]+', '%1<redacted>')
		text = text:gsub('([?&][Kk]ey=)[^&%s]+', '%1<redacted>')
		limit = limit or 1200
		if #text > limit then text = text:sub(1, limit - 3)..'...' end
		return text
	end

	local function copyDetails(details)
		local result = {}
		if type(details) == 'table' then
			for key, value in pairs(details) do
				if type(value) ~= 'table' and type(value) ~= 'function' then
					result[safeText(key, 80)] = safeText(value, 3000)
				end
			end
		end
		return result
	end

	local function formatEntry(entry)
		local parts = {}
		for key, value in pairs(entry.details) do
			table.insert(parts, tostring(key)..'='..tostring(value))
		end
		table.sort(parts)
		local line = ('[%s] [pistonware] [%s] [%s] %s'):format(
			entry.timestamp,
			entry.level:upper(),
			entry.event,
			entry.message
		)
		if #parts > 0 then line = line..' '..table.concat(parts, ' ') end
		return line
	end

	local function orderedEntries()
		local result = {}
		for offset = 0, count - 1 do
			result[#result + 1] = entries[((head + offset - 1) % capacity) + 1]
		end
		return result
	end

	--[[ Automatic dumps are spaced at least this many seconds apart. Each one rewrites the whole
	file from every entry, so an error repeating every frame used to cost a full dump per frame.
	One that comes in sooner is put off until the gap has passed rather than dropped, so the file
	still ends up holding every error. Explicit dump() and raise() calls are never held back. ]]
	local autoDumpInterval = 5
	local lastAutoDump

	local function requestDump()
		pendingDump = true
		if not filesystemReady or dumping or dumpScheduled then return end
		dumpScheduled = true
		local function flush()
			dumpScheduled = false
			lastAutoDump = os.clock()
			buffer.dump('automatic error')
		end
		local holdFor = lastAutoDump and lastAutoDump + autoDumpInterval - os.clock() or 0
		if holdFor > 0 and task and type(task.delay) == 'function' then
			task.delay(holdFor, flush)
		elseif task and type(task.defer) == 'function' then
			task.defer(flush)
		else
			flush()
		end
	end

	local function record(level, event, message, details)
		local entry = {
			timestamp = timestamp(false),
			level = safeText(level, 20):lower(),
			event = safeText(event, 160),
			message = safeText(message, 1600),
			details = copyDetails(details)
		}
		if count < capacity then
			entries[((head + count - 1) % capacity) + 1] = entry
			count += 1
		else
			entries[head] = entry
			head = (head % capacity) + 1
			dropped += 1
		end

		--[[ Formatted once, here, and kept on the entry: a dump writes this same text back out
		instead of formatting all 512 entries again every time. ]]
		local line = formatEntry(entry)
		entry.line = line
		if developerMode then
			if entry.level == 'warn' or entry.level == 'error' or entry.level == 'fatal' then
				pcall(nativeWarn, line)
			else
				pcall(nativePrint, line)
			end
		end
		if entry.level == 'error' or entry.level == 'fatal' then requestDump() end
		return line
	end

	function buffer.log(event, message, details)
		return record('info', event, message, details)
	end

	function buffer.print(event, message, details)
		return record('info', event, message, details)
	end

	function buffer.warn(event, message, details)
		return record('warn', event, message, details)
	end

	function buffer.error(event, message, details)
		return record('error', event, message, details)
	end

	function buffer.raise(event, message, details, level)
		record('error', event, message, details)
		buffer.dump('raised error')
		return nativeError(message, (tonumber(level) or 1) + 1)
	end

	function buffer.guard(stage, fatal, callback, ...)
		local args = table.pack(...)
		local result = table.pack(xpcall(function()
			return callback(table.unpack(args, 1, args.n))
		end, function(err)
			local trace
			pcall(function()
				trace = debug and type(debug.traceback) == 'function' and debug.traceback(tostring(err), 2)
			end)
			return trace or tostring(err)
		end))
		if not result[1] then
			record(fatal and 'fatal' or 'error', stage, result[2], {traceback = result[2]})
		end
		return table.unpack(result, 1, result.n)
	end

	function buffer.snapshot()
		local snapshot = {}
		for index, entry in ipairs(orderedEntries()) do
			snapshot[index] = {
				timestamp = entry.timestamp,
				level = entry.level,
				event = entry.event,
				message = entry.message,
				details = copyDetails(entry.details)
			}
		end
		return snapshot, dropped
	end

	function buffer.dump(reason)
		if dumping then return false, 'a buffer dump is already running', count end
		if not filesystemReady then
			pendingDump = true
			return false, 'the pistonware filesystem is not ready', count
		end
		if type(writefile) ~= 'function' then return false, 'writefile is unavailable', count end
		pendingDump = false
		dumping = true
		local ok, result = pcall(function()
			if type(isfolder) == 'function' and type(makefolder) == 'function' then
				if not isfolder('pistonware/errors') then makefolder('pistonware/errors') end
			end
			local release = type(shared.PistonwareRelease) == 'table' and shared.PistonwareRelease or {}
			local lines = {
				'Pistonware error buffer',
				'session='..session,
				'dumped='..timestamp(false),
				'reason='..safeText(reason or 'manual', 240),
				'channel='..safeText(release.channel or 'unknown', 80),
				'version='..safeText(release.version or 'unknown', 160),
				'placeId='..safeText(game and game.PlaceId or 0, 40),
				'entries='..tostring(count),
				'dropped='..tostring(dropped),
				''
			}
			for _, entry in ipairs(orderedEntries()) do
				lines[#lines + 1] = entry.line
			end
			writefile(dumpPath, table.concat(lines, '\n')..'\n')
			return dumpPath
		end)
		dumping = false
		if ok then
			if pendingDump then requestDump() end
			return true, result, count
		end
		pendingDump = true
		return false, tostring(result), count
	end

	local function markFilesystemReady()
		filesystemReady = true
		if pendingDump then requestDump() end
	end

	pcall(function()
		local env = type(getgenv) == 'function' and getgenv() or nil
		if type(env) ~= 'table' then return end
		local namespace = env.pistonware
		if type(namespace) ~= 'table' then
			namespace = {}
			env.pistonware = namespace
		end
		namespace.buffer = buffer
	end)

	return buffer, markFilesystemReady
end

local pistonwareBuffer, markPistonwareBufferFilesystemReady = installPistonwareBuffer(false)

local VERSION_SCHEMA = 1
local CHANNELS = {
	main = {branch = 'main', label = 'stable'},
	beta = {branch = 'beta', label = 'beta'},
	nightly = {branch = 'nightly', label = 'nightly'}
}

local function configuredValue(name)
	local value
	pcall(function()
		local env = type(getgenv) == 'function' and getgenv() or nil
		if type(env) == 'table' then
			value = env[name]
		end
	end)
	if value == nil then
		pcall(function()
			value = shared[name]
		end)
	end
	return value
end

local requestedChannel = configuredValue('PistonwareChannel')
if type(requestedChannel) ~= 'string' then
	requestedChannel = 'main'
end
requestedChannel = requestedChannel:lower():gsub('^%s*(.-)%s*$', '%1')
local channelSpec = CHANNELS[requestedChannel]
local invalidChannel = channelSpec == nil
channelSpec = channelSpec or CHANNELS.main

local release = {
	schema = VERSION_SCHEMA,
	channel = channelSpec.branch == requestedChannel and requestedChannel or 'main',
	branch = channelSpec.branch,
	label = channelSpec.label,
	sourceRef = channelSpec.branch,
	requestedChannel = requestedChannel,
	cacheReady = false,
	resolved = false
}

local function safeText(value, limit)
	local text = tostring(value or '')
	text = text:gsub('[\r\n]+', ' ')
	text = text:gsub('([Ss]cript[_%s]*[Kk]ey%s*[:=]%s*)[^%s,;]+', '%1<redacted>')
	text = text:gsub('([?&][Kk]ey=)[^&%s]+', '%1<redacted>')
	limit = limit or 900
	if #text > limit then
		text = text:sub(1, limit - 3)..'...'
	end
	return text
end

local function jsonEncode(value)
	local ok, encoded = pcall(function()
		return game:GetService('HttpService'):JSONEncode(value)
	end)
	if ok and type(encoded) == 'string' then
		return encoded
	end
	local text = safeText(value, 1800)
	text = text:gsub('\\', '\\\\'):gsub('"', '\\"')
	return '"'..text..'"'
end

--[[ Paths already size-checked this boot. appendfile never trims, so each log is capped once
per boot, the same way the fallback below caps it on every write. ]]
local trimmedLogs = {}
local function appendText(path, text)
	if type(appendfile) == 'function' then
		if not trimmedLogs[path] and type(readfile) == 'function' and type(writefile) == 'function' then
			trimmedLogs[path] = true
			pcall(function()
				local body = readfile(path)
				if type(body) == 'string' and #body > 262144 then
					writefile(path, body:sub(-131072))
				end
			end)
		end
		local ok = pcall(appendfile, path, text)
		if ok then return true end
	end
	if type(writefile) ~= 'function' then return false end
	local previous = ''
	if type(readfile) == 'function' then
		pcall(function()
			local body = readfile(path)
			if type(body) == 'string' then previous = body end
		end)
	end
	if #previous > 262144 then
		previous = previous:sub(-131072)
	end
	return pcall(writefile, path, previous..text)
end

--[[ Log and telemetry lines are held per file during the boot and written with one append per
file at each boot phase, instead of one disk write per line. A warning, an error or a telemetry
report writes out everything held straight away, so whatever led up to a failure is on disk even
if the loader dies right after it. Once the boot has ended -- main.lua keeps reporting through the
telemetry handed to it -- every line goes straight to disk again. ]]
local heldLogText, heldLogOrder = {}, {}
local holdingLogs = true

local function writeLogText(path, text)
	if not holdingLogs then
		appendText(path, text)
		return
	end
	local held = heldLogText[path]
	if not held then
		held = {}
		heldLogText[path] = held
		table.insert(heldLogOrder, path)
	end
	table.insert(held, text)
end

local function flushLogs()
	if #heldLogOrder == 0 then return end
	local order, held = heldLogOrder, heldLogText
	heldLogText, heldLogOrder = {}, {}
	for _, path in order do
		appendText(path, table.concat(held[path]))
	end
end

local function stopHoldingLogs()
	holdingLogs = false
	flushLogs()
end

local function placeId()
	local value
	pcall(function() value = tonumber(game.PlaceId) end)
	return value or 0
end

local function sessionId()
	local guid
	pcall(function()
		guid = game:GetService('HttpService'):GenerateGUID(false)
	end)
	return type(guid) == 'string' and guid or (tostring(os.time())..'-'..tostring(math.floor(os.clock() * 1000)))
end

local function timestamp()
	local value
	pcall(function() value = os.date('!%Y-%m-%dT%H:%M:%SZ') end)
	return value or tostring(os.time())
end

local loaderSession = sessionId()
local logFiles = {'pistonware_loader.log'}
local logFileSet = {['pistonware_loader.log'] = true}
local telemetryFiles = {'pistonware_loader_telemetry.jsonl'}
local telemetryFileSet = {['pistonware_loader_telemetry.jsonl'] = true}

local function addFile(files, seen, path)
	if type(path) ~= 'string' or path == '' or seen[path] then return end
	seen[path] = true
	table.insert(files, path)
end

--[[ Whether the boot log is echoed into the executor output, read HERE -- at the top, before
the public build clears the flag further down -- so that setting

    shared.PistonwareDeveloper = true

in front of the loadstring turns the log on for the whole run. Captured once rather than read
per line precisely because of that clear: read live, only the loader.start line above the
lockout would ever appear.

This switch grants nothing else. The lockout still nils the flag, and isDeveloper is still
computed after it, so developer mode itself stays shut in a public build -- this decides
visibility of the loader's own log lines and nothing more. The lines are safe to show (safeText
redacts anything key-shaped), they are just noise: a wall of INFO during a boot that went fine
reads to an end user like something is broken. ]]
local logToConsole = shared.PistonwareDeveloper and true or false

local Logger = {}
Logger.__index = Logger

function Logger:addFile(path)
	addFile(logFiles, logFileSet, path)
end

function Logger:bindConsole(console)
	self.console = console
	if self.lastLine then
		pcall(function() console:SetLine(self.lastLine) end)
	end
end

function Logger:emit(level, event, message, details)
	local parts = {}
	if type(details) == 'table' then
		for key, value in pairs(details) do
			if type(value) ~= 'table' and type(value) ~= 'function' then
				table.insert(parts, tostring(key)..'='..safeText(value, 240))
			end
		end
		table.sort(parts)
	end
	local line = ('[%s] [pistonware] [%s] [%s] %s'):format(timestamp(), level:upper(), event, safeText(message, 1200))
	if #parts > 0 then line = line..' '..table.concat(parts, ' ') end
	self.lastLine = line
	for _, path in ipairs(logFiles) do
		writeLogText(path, line..'\n')
	end
	if level ~= 'info' then flushLogs() end
	if self.console then
		pcall(function() self.console:SetLine(line) end)
	end
	if level == 'error' then
		pistonwareBuffer.error(event, message, details)
	elseif level == 'warn' then
		pistonwareBuffer.warn(event, message, details)
	else
		pistonwareBuffer.log(event, message, details)
	end
	return line
end

function Logger:info(event, message, details)
	return self:emit('info', event, message, details)
end

function Logger:warn(event, message, details)
	return self:emit('warn', event, message, details)
end

function Logger:error(event, message, details)
	return self:emit('error', event, message, details)
end

local logger = setmetatable({}, Logger)

local Telemetry = {}
Telemetry.__index = Telemetry

local function telemetryValue(value)
	if type(value) == 'string' then return safeText(value, 3000) end
	if type(value) == 'number' or type(value) == 'boolean' then return value end
	return safeText(value, 3000)
end

function Telemetry:addFile(path)
	addFile(telemetryFiles, telemetryFileSet, path)
end

function Telemetry:report(event, message, details)
	local payload = {
		schema = VERSION_SCHEMA,
		event = event,
		message = safeText(message, 1600),
		session = loaderSession,
		channel = release.channel,
		branch = release.branch,
		version = release.version,
		placeId = placeId(),
		at = os.clock()
	}
	if type(details) == 'table' then
		for key, value in pairs(details) do
			if type(value) ~= 'table' and type(value) ~= 'function' then
				payload[key] = telemetryValue(value)
			end
		end
	end
	local encoded = jsonEncode(payload)
	for _, path in ipairs(telemetryFiles) do
		writeLogText(path, encoded..'\n')
	end
	flushLogs()

	local endpoint = self.endpoint
	local requestFn = self.requestFn
	if endpoint and requestFn then
		pcall(requestFn, {
			Url = endpoint,
			Method = 'POST',
			Headers = {['Content-Type'] = 'application/json'},
			Body = encoded
		})
	end
	return payload
end

local telemetry = setmetatable({}, Telemetry)
local configuredTelemetryEndpoint = configuredValue('PistonwareTelemetryEndpoint') or configuredValue('PistonwareTelemetryUrl')
if type(configuredTelemetryEndpoint) == 'string' and configuredTelemetryEndpoint:match('^https://') then
	telemetry.endpoint = configuredTelemetryEndpoint
end
pcall(function()
	local candidates = {
		request,
		http_request,
		syn and syn.request,
		http and http.request
	}
	for _, candidate in ipairs(candidates) do
		if type(candidate) == 'function' then
			telemetry.requestFn = candidate
			break
		end
	end
end)

local function reportError(stage, err, trace, fatal)
	local message = safeText(err, 1600)
	logger:error('loader.error', message, {stage = stage, channel = release.channel})
	telemetry:report('loader_error', message, {
		stage = stage,
		fatal = fatal == true,
		traceback = trace and safeText(trace, 3000) or nil
	})
	return message
end

local loaderStopped = false
local function stopExecution(console, stage, err, trace, display)
	if loaderStopped then return false end
	loaderStopped = true
	local message = reportError(stage, err, trace, true)
	stopHoldingLogs()
	shared.PistonwareLoaderBoot = nil
	shared.vapereload = nil
	if console then
		pcall(function() console:Fail(display or ('Loader stopped: '..message)) end)
		pcall(function() console:Halt() end)
	end
	return false
end

local function errorTrace(err)
	local traceback
	pcall(function()
		if debug and type(debug.traceback) == 'function' then
			traceback = debug.traceback(tostring(err), 2)
		end
	end)
	return traceback or tostring(err)
end

logger:info('loader.start', 'loader started', {
	channel = release.channel,
	branch = release.branch,
	session = loaderSession
})
if invalidChannel then
	logger:warn('version.channel', 'unknown channel; using main', {requested = requestedChannel})
end

if PUBLIC_BUILD then
	shared.PistonwareDeveloper = nil
	pcall(function()
		if getmetatable(shared) ~= nil then return end
		--[[ __newindex alone is the lock. __index only runs for a key the table does not hold, so it
		could only ever answer nil -- while costing a function call on every read of an unset shared
		flag for the rest of the session. ]]
		setmetatable(shared, {
			__newindex = function(self, key, value)
				if key == 'PistonwareDeveloper' then return end
				rawset(self, key, value)
			end
		})
	end)
end

local isDeveloper = (not PUBLIC_BUILD) and shared.PistonwareDeveloper and true or false

--[[ Developer-only boot timing. The console shows ONE line -- 'Injecting into ROBLOX...' -- from
the moment the key validates until main.lua starts, and the status chip reads INJECTING right
through main.lua on top of that. So every wait in between (Roblox loading, the GitHub tree,
the GUI build, the payload) looks identical from outside: 'stuck on injecting'. These marks
put a number on each one instead, in the executor output, for the build that is allowed to
care. Off entirely in the public build -- isDeveloper is false there by construction. ]]
local phaseClock = os.clock()
local function phase(name)
	local now = os.clock()
	local elapsed = now - phaseClock
	logger:info('boot.phase', name..' completed', {seconds = ('%.2f'):format(elapsed)})
	if isDeveloper then pistonwareBuffer.print('boot.phase', name..' completed', {seconds = ('%.2f'):format(elapsed)}) end
	phaseClock = now
	flushLogs()
end

--[[ A boot parked on the key prompt is the one exception to the duplicate guard. That prompt
has no timeout on purpose -- the user is off finishing ad checkpoints -- so the flag below can
legitimately stand for minutes, and every manual re-execution in that window was swallowed here
with no window and no output. From outside that is indistinguishable from the loader refusing
to open, which is the worst possible thing to happen to someone whose key just lapsed.

A second run is allowed to take that one over instead: createConsole tears the old window down,
the old AskKey sees `closed` and returns nil, and the boot behind it unwinds without touching
the new one's flags (releaseBoot only clears what it still owns). ]]
if shared.PistonwareLoaderBoot and not shared.PistonwareKeyPrompt and os.clock() - shared.PistonwareLoaderBoot < 180 then
	logger:warn('loader.duplicate', 'loader is already running; ignoring duplicate execution')
	return
end
shared.PistonwareLoaderBoot = os.clock()
--[[ Identifies THIS boot in the session-wide shared table, so a run that has been taken over can
tell that the flags it is about to clear now belong to somebody else. ]]
local bootStamp = shared.PistonwareLoaderBoot

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end
local cloneref = cloneref or function(ref)
	return ref
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local setclipboard = setclipboard or toclipboard or (Clipboard and Clipboard.set)

local Watermark = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.'

-- The bedwarslua script's id in the Pistonware project (not the project id: check_key wants a script).
local SCRIPT_ID   = 'bcf715c699489c7457e00e5323c2399b'
--[[ The ad links a key can come from, one per provider. Both end at LuaArmor either way -- it
is what issues the key; the provider only decides whose checkpoints you sit through getting
there -- so adding another is a URL here and an entry in the links list at the gate, nothing
else. ]]
local LOOTLABS_URL = 'https://ads.luarmor.net/get_key?for=Pistonware_LootLabs-xnpnovpEljPO'
local WORKINK_URL = 'https://ads.luarmor.net/get_key?for=Pistonware_Workink-cjPVCqOPPBCJ'
local KEY_FILE    = 'pistonwarekey.json'
local RELEASE_FILE = 'pistonware_release.json'
local HELP_URL    = 'https://discord.gg/pistonware'
--[[ ======================================================================== ]]

local function sourceRef(ref)
	return ref or release.sourceRef or release.branch
end

local function projectRawUrl(path, ref)
	path = tostring(path or ''):gsub('^/', '')
	return 'https://raw.githubusercontent.com/themagicpiston/pistonware/'..sourceRef(ref)..'/'..path
end

local function protectedRawUrl(ref)
	return 'https://gitlab.com/pistonware/pistonware/-/raw/'..(ref or release.branch)..'/bedwars.lua'
end

local function rewriteProjectUrl(url)
	local value = tostring(url or '')
	local ref = sourceRef()
	value = value:gsub('https://raw%.githubusercontent%.com/themagicpiston/pistonware/refs/heads/main/', function() return projectRawUrl('', ref) end)
	value = value:gsub('https://raw%.githubusercontent%.com/themagicpiston/pistonware/main/', function() return projectRawUrl('', ref) end)
	value = value:gsub('https://raw%.githubusercontent%.com/themagicpiston/pistonware/main/', function() return projectRawUrl('', ref) end)
	value = value:gsub('https://gitlab%.com/pistonware/pistonware/%-/raw/main/', function() return protectedRawUrl(release.branch):gsub('/bedwars%.lua$', '/') end)
	value = value:gsub('(/git/trees/)main', '%1'..release.branch)
	value = value:gsub('([?&]sha=)main', '%1'..ref)
	value = value:gsub('([?&]ref=)main', '%1'..ref)
	return value
end

shared.PistonwareRawUrl = projectRawUrl
shared.PistonwareProtectedRawUrl = protectedRawUrl
shared.PistonwareRewriteUrl = rewriteProjectUrl
shared.PistonwareRelease = release
shared.PistonwareTelemetry = telemetry
shared.PistonwareChannel = release.channel
if not isDeveloper then
	shared.PistonwareDevHttpGet = function(url, nocache)
		return game:HttpGet(rewriteProjectUrl(url), nocache)
	end
	shared.PistonwareDevProtectedHttpGet = function(url, nocache)
		return game:HttpGet(rewriteProjectUrl(url), nocache)
	end
end

local Strings = {
	enter_key       = 'Enter your key below to continue.',
	saved_expired   = 'Your key expired - renew it with Get Key, then paste it below. It is still saved.',
	saved_hwid      = 'Your key is linked to another device - reset your HWID, then submit it below. The key itself is still good and is still saved.',
	saved_incorrect = 'Saved key no longer exists - get a new one.',
	saved_banned    = 'Saved key is blacklisted.',
	placeholder     = 'Paste your key here',
	work_ink        = 'Work.ink',
	loot_labs       = 'LootLabs',
	paste           = 'Paste',
	submit          = 'Submit',
	footer          = 'No key? Pick a link -> finish the checkpoints -> paste the key above.',
	empty_key       = 'Enter your key first.',
	bad_format      = "That doesn't look like a valid key.",
	checking        = 'Checking key...',
	valid_loading   = 'Key valid%s - loading...',
	hwid_locked     = 'That key is linked to another device - reset your HWID via the bot, then submit it again.',
	expired         = 'That key has expired - renew it, then submit it again.',
	time_left       = '%s left',
	lifetime        = 'lifetime',
	banned          = 'Key is blacklisted.',
	incorrect       = 'Key is incorrect or has been deleted.',
	invalid_format  = 'Invalid key format.',
	check_failed    = 'Check failed: %s (%s)',
	link_copied     = '%s link copied! Finish the checkpoints, then paste your key here.',
	link_missing    = '%s is not set up yet - use LootLabs for now.',
	tip_work_ink    = 'Copies the Work.ink link. Open it in a browser to earn a key.',
	tip_loot_labs   = 'Copies the LootLabs link. Open it in a browser to earn a key.',
	tip_paste       = 'Puts whatever is on your clipboard into the box.',
	tip_submit      = 'Checks the key in the box and starts loading.',
	tip_help        = 'Copies the Discord invite in case you get stuck.',
	pasted          = 'Pasted from clipboard.',
	clipboard_empty = 'Clipboard is empty.',
	need_help       = 'Need Help?',
	help_copied     = 'Help link copied to your clipboard!',
	copy_failed     = 'Failed to copy script.',
	no_library      = "Can't reach LuaArmor (%s). Press Submit to try again.",
	check_error     = 'Key check failed: %s',
	cancelled       = 'Key entry cancelled.',
	headless        = 'No valid key saved - run the loader manually to enter one.'
}

local function t(key, ...)
	local s = Strings[key] or key
	if select('#', ...) > 0 then
		return string.format(s, ...)
	end
	return s
end

--[[ Coarse on purpose: '3 days' is what someone needs to know, and '3 days 4 hours 12 minutes'
is noise in a one-line status. Rounds down, so it never promises time that is not there. ]]
local function formatDuration(seconds)
	if seconds <= 0 then return nil end
	local days = math.floor(seconds / 86400)
	if days >= 1 then return days..(days == 1 and ' day' or ' days') end
	local hours = math.floor(seconds / 3600)
	if hours >= 1 then return hours..(hours == 1 and ' hour' or ' hours') end
	local minutes = math.max(1, math.floor(seconds / 60))
	return minutes..(minutes == 1 and ' minute' or ' minutes')
end

--[[ The parenthesised detail after 'Key valid', built from the fields LuaArmor only returns on
KEY_VALID: the seller note, and auth_expire (a unix timestamp, with -1 or 0 meaning a
lifetime key). Showing what is left matters because the complaint this addresses is people
believing a key had died when it had days on it -- if the remaining time is on screen every
run, that confusion has nowhere to start. ]]
local function keyDetail(status)
	local data = type(status) == 'table' and type(status.data) == 'table' and status.data or nil
	if not data then return '' end

	local parts = {}
	if data.note ~= nil and tostring(data.note) ~= '' then
		table.insert(parts, tostring(data.note))
	end

	local expire = tonumber(data.auth_expire)
	if expire == -1 or expire == 0 then
		table.insert(parts, t('lifetime'))
	elseif expire then
		local left = formatDuration(expire - os.time())
		if left then table.insert(parts, t('time_left', left)) end
	end

	if #parts == 0 then return '' end
	return ' ('..table.concat(parts, ', ')..')'
end

--[[ Hands the GUI the key's expiry so its footer can count it down: -1 for a lifetime key,
otherwise the unix time it runs out. Left unset when LuaArmor did not say. ]]
local function rememberExpiry(status)
	local data = type(status) == 'table' and type(status.data) == 'table' and status.data or nil
	local expire = data and tonumber(data.auth_expire)
	if expire == -1 or expire == 0 then
		shared.PistonwareKeyExpire = -1
	elseif expire then
		shared.PistonwareKeyExpire = expire
	end
end

local function trim(s)
	return (tostring(s):gsub('^%s*(.-)%s*$', '%1'))
end

--[[ Empty counts as missing. The executor's real isfile reports a zero-byte file as present, so a
write interrupted by a cancel, a crash or a teleport leaves a truncated file that this
function would otherwise never fetch again. For a .lua file that means a chunk that silently
does nothing; for an asset it means getcustomasset producing an invalid content id, which
throws 'ContentId formatting failed' and kills the GUI. Both states used to survive every
retry, because everything that could have repaired them asked isfile and was told the file
was fine -- so the only remedy was reinstalling the script.

Returns the body it read, and for a .lua file the chunk it compiled to prove it intact. Given the
name the file will run under, it compiles under that name, so the caller can run this chunk
instead of compiling the same source a second time with identical error traces. ]]
local function hasContent(path, chunkName)
	if not isfile(path) then return false end
	local ok, body = pcall(readfile, path)
	if not ok or type(body) ~= 'string' or body == '' then return false end
	if path:match('%.lua$') then
		local compileOk, chunk = pcall(loadstring, body, chunkName or path)
		if not (compileOk and type(chunk) == 'function') then return false end
		return body, chunk
	end
	return body
end

--[[ Paths the update pass rewrote at the release commit during this boot. The release marker
only moves once the whole boot has succeeded, so until then release.cacheReady stays false and
downloadFile used to fetch every one of these again straight after they were written. Only a
refresh whose write landed is listed, so a failed write still downloads as before. ]]
local refreshedThisBoot = {}

local function downloadFile(path, func, chunkName)
	local body, chunk
	if release.cacheReady or refreshedThisBoot[path] then
		body, chunk = hasContent(path, chunkName)
	end
	if not body then
		local relPath = select(1, path:gsub('pistonware/', ''))
		local isBedwars = relPath == 'games/bedwars.lua'
		local isLua = path:find('%.lua$') ~= nil
		local content
		for attempt = 1, 4 do
			local suc, res = pcall(function()
				if isBedwars then
					return game:HttpGet(protectedRawUrl(), true)
				end
				return game:HttpGet(projectRawUrl(relPath), true)
			end)
			if suc and res and res ~= '' and res ~= '404: Not Found' then
				if not isLua then
					content = res
				elseif chunkName then
					--[[ Checked exactly as it will be cached and run -- watermark line and chunk name
					included -- so the compile check is also the chunk the caller runs. ]]
					chunk = loadstring(Watermark..'\n'..res, chunkName)
					if chunk then content = res end
				elseif loadstring(res) ~= nil then
					content = res
				end
				if content then break end
			end
			if attempt < 4 then
				task.wait(attempt)
			end
		end
		if not content then
			local message = 'failed to download '..path..' after 4 attempts'
			reportError('source.download', message, nil, false)
			error(message, 2)
		end
		if isLua then
			content = Watermark..'\n'..content
		end
		local wrote, writeError = pcall(writefile, path, content)
		if not wrote then
			reportError('source.cache.write', writeError, nil, false)
			error(writeError, 2)
		end
		body = content
	end
	if func then return func(path) end
	--[[ The text already in hand, not a second readfile of what was just read or written. The
	chunk goes back only to a caller that named one, so every existing one-argument caller
	still gets exactly one value. ]]
	if chunkName then return body, chunk end
	return body
end

if not isDeveloper then
	shared.PistonwareDevLoadSource = function(path, chunkName)
		return downloadFile(path, nil, chunkName)
	end
end

--[[ Every concurrent batch in this file joins through here.

The old code used `done.Event:Wait()` with no timeout, which parks the boot FOREVER if
a worker dies before firing -- and workers could die, because the progress callback they
called on their way out was not wrapped. That is the 'stuck on Injecting into ROBLOX' report:
not a slow download, a batch that lost a worker and a join that waits for it regardless.

Fixed at both ends, because either alone still leaves a hole: the callbacks are pcall'd at
their call sites now, AND this gives up on the clock no matter what killed the worker. A
batch that loses one costs the files that worker had left, not the session. ]]
local function joinBatch(isDone, seconds)
	local deadline = os.clock() + (seconds or 90)
	while not isDone() and os.clock() < deadline do
		task.wait(0.05)
	end
	return isDone()
end

--[[
	Resolve the branch through the small GitHub branch endpoint first. The recursive tree is an
	optional cache/update index, not the release-verification gate: GitHub can serve valid branch
	metadata while a recursive tree request is rate-limited or temporarily unavailable.

	The loader used to treat that tree failure as proof that the branch had no release. That made
	"branch main has no verified release" a false negative and prevented an otherwise valid boot.
	Once the branch endpoint returns a 40-character commit, every later raw-file request is pinned
	to that commit. A matching local marker remains the offline fallback when both metadata calls
	are unavailable.
]]
--[[ GitHub requests for the release lookup, made so a failure says WHY and never throws.

Both 'Loader stopped' reports came out of this lookup:

  "Can't parse JSON"  game:HttpGet sends no User-Agent on some executors, and api.github.com
                      answers a request without one with a plain-text 403 ("Request
                      forbidden by administrative rules...") -- JSONDecode on that throws.
  "branch metadata did not contain a verified commit"
                      the REST API allows 60 unauthenticated requests an hour per IP. Past
                      that it answers with a JSON error object and no commit. A shared IP, a
                      VPN or a handful of reinjects in an hour is enough.

So the executor's request function goes first, with a User-Agent, and the status code is read
rather than guessed from the body. HttpGet stays as the fallback for executors without one. ]]
local GITHUB_HEADERS = {['User-Agent'] = 'pistonware-loader', Accept = 'application/vnd.github+json'}

local function describeGithubFailure(status, body)
	local detail
	pcall(function()
		local decoded = cloneref(game:GetService('HttpService')):JSONDecode(body)
		if type(decoded) == 'table' and type(decoded.message) == 'string' then
			detail = decoded.message
		end
	end)
	if detail then
		-- The rate-limit message names the caller's IP, which has no business in a log or report.
		detail = (detail:gsub('%d+%.%d+%.%d+%.%d+', '<ip>'))
		detail = (detail:gsub('%x*:%x*:[%x:]+', '<ip>'))
	end
	return (status and ('GitHub answered '..status) or 'GitHub refused the request')
		..(detail and (': '..safeText(detail, 200)) or '')
end

local function githubGet(url)
	local requestFn = telemetry.requestFn
	if requestFn then
		local ok, res = pcall(requestFn, {Url = url, Method = 'GET', Headers = GITHUB_HEADERS})
		if ok and type(res) == 'table' and type(res.Body) == 'string' then
			local status = tonumber(res.StatusCode) or 200
			if status >= 200 and status < 300 then
				if res.Body ~= '' then return res.Body end
				return nil, 'GitHub sent an empty response'
			end
			return nil, describeGithubFailure(status, res.Body)
		end
	end
	local ok, body = pcall(function()
		return game:HttpGet(url, true)
	end)
	if ok and type(body) == 'string' and body ~= '' then return body end
	return nil, ok and 'GitHub sent an empty response' or safeText(body, 200)
end

local function githubJson(url)
	local body, err = githubGet(url)
	if not body then return nil, err end
	local ok, decoded = pcall(function()
		return cloneref(game:GetService('HttpService')):JSONDecode(body)
	end)
	if not (ok and type(decoded) == 'table') then
		return nil, 'GitHub sent a response that is not JSON'
	end
	-- An error object that came through HttpGet, which hides the status code.
	if type(decoded.message) == 'string' and decoded.sha == nil and decoded.commit == nil then
		return nil, describeGithubFailure(nil, body)
	end
	return decoded
end

local repoTree, repoTreeTried, repoTreeDone
local repoTreeError
local function fetchRepoTree()
	if repoTreeTried then
		--[[ Joined, not returned. repoTreeTried is set on ENTRY, so a second caller arriving
		while the first request is still in flight used to be handed nil and read that as
		'no tree' -- silently skipping whatever it wanted the tree for. Harmless while the
		only concurrent caller was the update task, but the prefetch below makes a
		concurrent second caller the normal case. ]]
		if not repoTreeDone then
			joinBatch(function() return repoTreeDone end, 30)
		end
		return repoTree
	end
	repoTreeTried = true
	local ok, err = pcall(function()
		local body, treeErr = githubJson('https://api.github.com/repos/themagicpiston/pistonware/git/trees/'..(release.sourceRef or release.branch)..'?recursive=1')
		if type(body) == 'table' and type(body.tree) == 'table' and type(body.sha) == 'string' then
			repoTree = body
			--[[ Handed to main.lua so its asset prefetch reads this instead of spending its own
			contents/ calls. It only needs the paths, and they are all in here already. ]]
			shared.PistonwareRepoTree = body
		else
			error(treeErr or 'the repository tree was missing its file list', 0)
		end
	end)
	if not ok then
		repoTreeError = safeText(err)
		logger:warn('version.tree', 'could not resolve the selected branch tree', {error = repoTreeError, branch = release.branch})
		telemetry:report('loader_error', repoTreeError, {stage = 'version.tree', fatal = false})
	end
	repoTreeDone = true
	return repoTree
end

local function readReleaseMarker()
	if not isfile(RELEASE_FILE) then return nil end
	local ok, body = pcall(readfile, RELEASE_FILE)
	if not ok or type(body) ~= 'string' or body == '' then return nil end
	local decodedOk, decoded = pcall(function()
		return cloneref(game:GetService('HttpService')):JSONDecode(body)
	end)
	return decodedOk and type(decoded) == 'table' and decoded or nil
end

local function validCommit(value)
	return type(value) == 'string' and #value == 40 and value:match('^%x+$') ~= nil
end

--[[ The branch head without the REST API, so without its hourly limit. Git's own smart-HTTP
ref advertisement -- what `git clone` reads first -- lists every branch as a pkt-line,
'<4 hex length><40 hex sha> refs/heads/<name>'. The first line also carries HEAD and the
capability list after a NUL, which the ref match below never reaches for a branch. ]]
local function commitFromGitRefs()
	local body, err = githubGet('https://github.com/themagicpiston/pistonware.git/info/refs?service=git-upload-pack')
	if not body then return nil, err end
	local wanted = 'refs/heads/'..release.branch
	for line in body:gmatch('[^\n]+') do
		local hex, ref = line:match('^(%x+) (%S+)')
		if ref then
			local nul = ref:find('\0', 1, true)
			if nul then ref = ref:sub(1, nul - 1) end
		end
		if ref == wanted and #hex >= 40 then
			local sha = hex:sub(-40)
			if validCommit(sha) then return sha end
		end
	end
	return nil, 'the git refs did not list branch '..release.branch
end

-- Second non-API source: the branch's commit feed, newest commit first.
local function commitFromFeed()
	local body, err = githubGet('https://github.com/themagicpiston/pistonware/commits/'..release.branch..'.atom')
	if not body then return nil, err end
	local sha = body:match('Grit::Commit/(%x+)')
	if validCommit(sha) then return sha end
	return nil, 'the commit feed did not list a commit'
end

local branchCommit, branchCommitTried, branchCommitDone
local branchCommitError
local function fetchBranchCommit()
	if branchCommitTried then
		if not branchCommitDone then
			joinBatch(function() return branchCommitDone end, 30)
		end
		return branchCommit
	end
	branchCommitTried = true
	-- Why each source failed, in order, so a report names every one of them.
	local reasons = {}
	local ok, err = pcall(function()
		local body, apiErr = githubJson('https://api.github.com/repos/themagicpiston/pistonware/branches/'..release.branch)
		local commit = type(body) == 'table' and type(body.commit) == 'table' and body.commit.sha
		if validCommit(commit) then
			branchCommit = commit
			return
		end
		table.insert(reasons, 'API: '..(apiErr or 'no commit in the branch metadata'))
		for _, source in {{'git refs', commitFromGitRefs}, {'commit feed', commitFromFeed}} do
			local sha, sourceErr = source[2]()
			if validCommit(sha) then
				branchCommit = sha
				return
			end
			table.insert(reasons, source[1]..': '..tostring(sourceErr))
		end
	end)
	if not ok then
		table.insert(reasons, safeText(err, 200))
	end
	if branchCommit then
		if #reasons > 0 then
			logger:info('version.branch', 'resolved the branch without the GitHub API', {reasons = table.concat(reasons, '; '), branch = release.branch})
		end
	else
		branchCommitError = 'could not find the latest commit of branch '..release.branch..' ('..table.concat(reasons, '; ')..')'
		logger:warn('version.branch', 'could not resolve the selected branch', {error = branchCommitError, branch = release.branch})
		telemetry:report('loader_error', branchCommitError, {stage = 'version.branch', fatal = false})
	end
	branchCommitDone = true
	return branchCommit
end

local function markerMatches(marker)
	return type(marker) == 'table'
		and marker.schema == VERSION_SCHEMA
		and marker.channel == release.channel
		and marker.branch == release.branch
		and validCommit(marker.commit)
end

local function resolveRelease()
	local marker = readReleaseMarker()
	local commit = fetchBranchCommit()
	if validCommit(commit) then
		release.commit = commit
		release.sourceRef = commit
		release.version = release.channel..'@'..commit:sub(1, 12)
		release.resolved = true
		release.cacheReady = markerMatches(marker) and marker.commit == commit
			or false
		shared.PistonwareRelease = release
		logger:info('version.resolved', 'release selected', {
			channel = release.channel,
			branch = release.branch,
			version = release.version,
			cache = release.cacheReady and 'ready' or 'refresh'
		})
		return true
	end
	-- Keep the recursive tree as a compatibility fallback for hosts or API proxies that do not
	-- expose /branches/:name but do still expose git/trees/:name.
	local tree = fetchRepoTree()
	if tree and validCommit(tree.sha) then
		release.commit = tree.sha
		release.sourceRef = tree.sha
		release.version = release.channel..'@'..tree.sha:sub(1, 12)
		release.resolved = true
		release.cacheReady = markerMatches(marker) and marker.commit == tree.sha or false
		shared.PistonwareRelease = release
		logger:info('version.resolved', 'release selected from the repository tree', {
			channel = release.channel,
			branch = release.branch,
			version = release.version,
			cache = release.cacheReady and 'ready' or 'refresh'
		})
		return true
	end
	if markerMatches(marker) then
		release.commit = marker.commit
		release.sourceRef = marker.commit
		release.version = release.channel..'@'..marker.commit:sub(1, 12)
		release.resolved = true
		release.cacheReady = true
		shared.PistonwareRelease = release
		logger:warn('version.cached', 'using the last verified release because the branch tree was unavailable', {
			channel = release.channel,
			version = release.version
		})
		return true
	end
	--[[ Nothing could name a commit and there is no earlier release on disk -- a first run
	behind a network that blocks github.com as well as the API. Load the branch as it stands
	instead of refusing to load at all. The commit pin buys consistency (every file from one
	snapshot), not authenticity: a sha read from GitHub is no more trustworthy than the
	branch it came from, and both come over HTTPS from the same place. Nothing is cached as
	ready (every file is fetched fresh) and no marker is written, so the next run that can
	resolve a commit pins it as normal. ]]
	release.commit = nil
	release.sourceRef = release.branch
	release.version = release.channel..'@'..release.branch
	release.resolved = true
	release.cacheReady = false
	shared.PistonwareRelease = release
	local reason = branchCommitError or repoTreeError or ('branch '..release.branch..' has no verified release')
	logger:warn('version.unpinned', 'loading the branch head because no commit could be resolved', {
		channel = release.channel,
		branch = release.branch,
		reason = reason
	})
	telemetry:report('loader_error', reason, {stage = 'version.unpinned', fatal = false})
	return true
end

local function persistReleaseMarker()
	if not release.resolved or type(release.commit) ~= 'string' then return false end
	local marker = {
		schema = VERSION_SCHEMA,
		channel = release.channel,
		branch = release.branch,
		commit = release.commit,
		version = release.version,
		savedAt = os.time()
	}
	local ok, err = pcall(function()
		writefile(RELEASE_FILE, jsonEncode(marker))
	end)
	if not ok then
		logger:warn('version.marker', 'could not persist the verified release marker', {error = err})
		telemetry:report('loader_error', err, {stage = 'version.marker', fatal = false})
		return false
	end
	release.cacheReady = true
	shared.PistonwareRelease = release
	return true
end

--[[ Shaped like the old contents/ response ({type = 'file', path = ...}) so the downloader below
did not have to change. Pinned by construction: a tree IS a snapshot, so there is no window
where the listing and the file contents disagree. ]]
local function fetchProfilesListing()
	local tree = fetchRepoTree()
	if not tree then return nil end
	local files = {}
	for _, v in tree.tree do
		if v.type == 'blob' and v.path:sub(1, 9) == 'profiles/' then
			table.insert(files, {type = 'file', path = v.path})
		end
	end
	if #files == 0 then return nil end
	return files
end

local function mergeGuiState(path, incoming)
	if not path:find('%.gui%.txt$') then return incoming end
	local ok, merged = pcall(function()
		local httpService = cloneref(game:GetService('HttpService'))
		local new = httpService:JSONDecode(incoming)
		if type(new) ~= 'table' then return incoming end
		if isfile(path) then
			local old = httpService:JSONDecode(readfile(path))
			if type(old) == 'table' then
				-- Top level: the shape the OLD gui wrote, kept for a repo copy still in it.
				if old.Profiles ~= nil then new.Profiles = old.Profiles end
				if old.Profile ~= nil then new.Profile = old.Profile end

				--[[
					And the shape guis/newgui.lua writes, which is what is on disk now.

					The point of this merge is that a config sync replaces the theme and window
					layout without costing the user the profiles they made themselves. The new
					GUI keeps that list at Categories.Profiles.List (see its vape:Save), not at
					the top level -- so preserving only the two fields above let the repo's copy
					overwrite it, and a sync silently emptied the Profiles tab of everything
					except the shipped configs. The GUI's own sync button carries both across
					for the same reason.
				]]
				local oldprofiles = type(old.Categories) == 'table' and old.Categories.Profiles or nil
				if type(oldprofiles) == 'table' then
					new.Categories = type(new.Categories) == 'table' and new.Categories or {}
					local newprofiles = type(new.Categories.Profiles) == 'table' and new.Categories.Profiles or {}
					new.Categories.Profiles = newprofiles
					if oldprofiles.List ~= nil then newprofiles.List = oldprofiles.List end
					if oldprofiles.ListEnabled ~= nil then newprofiles.ListEnabled = oldprofiles.ListEnabled end
				end
			end
		end
		return httpService:JSONEncode(new)
	end)
	return (ok and type(merged) == 'string') and merged or incoming
end

local function downloadProfilesListing(body, commit, onProgress)
	local files = {}
	for _, v in body do
		if v.type == 'file' then
			table.insert(files, v)
		end
	end
	local completed, failed, total = 0, 0, #files
	for _, v in files do
		local relPath = ({v.path:gsub(' ', '%%20')})[1]
		task.spawn(function()
			local succeeded = false
			if commit then
				pcall(function()
					for attempt = 1, 4 do
						local suc, res = pcall(function()
							return game:HttpGet(projectRawUrl(relPath, commit or release.sourceRef), true)
						end)
						if suc and res and res ~= '' and res ~= '404: Not Found' then
							writefile('pistonware/'..relPath, mergeGuiState('pistonware/'..relPath, res))
							succeeded = true
							break
						end
						if attempt < 4 then
							task.wait(attempt)
						end
					end
				end)
			else
				succeeded = pcall(downloadFile, 'pistonware/'..relPath)
			end
			if not succeeded then failed += 1 end
			--[[ Counted first and reported second, both guarded: this worker's only remaining job
			is to be counted, and a throwing progress callback used to stop that happening. ]]
			completed += 1
			if onProgress then
				pcall(onProgress, completed, total)
			end
		end)
	end
	joinBatch(function() return completed >= total end)
	return completed == total and failed == 0
end

--[[ Derived from the tree already in hand, so the sync check costs no request of its own. The
fingerprint changes only when a profile changes and stays identical otherwise; the blob shas
give exactly; djb2 over them keeps the stored value one short line instead of growing with
the profile count. The 'p1-' prefix marks the scheme, so the migration in Step 2b can tell
one of these from the 40-char git sha the old code wrote. ]]
local function profilesFingerprint()
	local tree = fetchRepoTree()
	if not tree then return nil end
	local parts = {}
	for _, v in tree.tree do
		if v.type == 'blob' and v.path:sub(1, 9) == 'profiles/' then
			table.insert(parts, v.path..':'..tostring(v.sha))
		end
	end
	if #parts == 0 then return nil end
	table.sort(parts)
	local joined = table.concat(parts, '\n')
	local h = 5381
	for i = 1, #joined do
		h = (h * 33 + string.byte(joined, i)) % 4294967296
	end
	return ('p1-%08x'):format(h)
end

local function updateCachedFiles(onProgress)
	local httpService = cloneref(game:GetService('HttpService'))

	--[[ The tree carries its own sha, so this is the whole API budget -- and it is memoised, so
	the profiles listing and fingerprint below ride the same response. ]]
	local tree = fetchRepoTree()
	if not tree then return end
	local headSha = tree.sha

	local manifest = {}
	pcall(function()
		if isfile('pistonware/filecheck.json') then
			local decoded = httpService:JSONDecode(readfile('pistonware/filecheck.json'))
			if type(decoded) == 'table' then
				manifest = decoded
			end
		end
	end)

	local remote = {}
	for _, v in tree.tree do
		if v.type == 'blob' and v.path:sub(-4) == '.lua' then
			remote[v.path] = v.sha
		end
	end

	local function managed(localPath)
		if not isfile(localPath) then return false end
		if PUBLIC_BUILD then return true end
		return readfile(localPath):sub(1, #Watermark) == Watermark
	end

	--[[ Only files already cached get refreshed here -- everything else keeps downloading on
	demand, and is picked up by this pass on the session after it first appears. ]]
	local toUpdate = {}
	for path, sha in remote do
		local localPath = 'pistonware/'..path
		if manifest[path] ~= sha and managed(localPath) then
			table.insert(toUpdate, path)
		end
	end

	local changed = false

	if not tree.truncated then
		for path in manifest do
			if not remote[path] then
				pcall(function()
					local localPath = 'pistonware/'..path
					if managed(localPath) then
						delfile(localPath)
					end
				end)
				manifest[path] = nil
				changed = true
			end
		end
	end

	local completed, failed, total = 0, 0, #toUpdate
	local joined = true
	if total > 0 then
		for _, path in toUpdate do
			task.spawn(function()
				local done = false
				for attempt = 1, 4 do
					local suc, res = pcall(function()
							return game:HttpGet(projectRawUrl(select(1, path:gsub(' ', '%%20')), headSha), true)
					end)
					--[[ compile check: never overwrite a working cached file with an error page ]]
					if suc and res and res ~= '' and res ~= '404: Not Found' and loadstring(res) ~= nil then
						if pcall(writefile, 'pistonware/'..path, Watermark..'\n'..res) then
							refreshedThisBoot['pistonware/'..path] = true
						end
						manifest[path] = remote[path]
						done = true
						changed = true
						break
					end
					if attempt < 4 then
						task.wait(attempt)
					end
				end
				if not done then failed += 1 end
				--[[ Counted first, reported second, the report guarded. See joinBatch: a throwing
				progress callback here used to strand the join for the rest of the session. ]]
				completed += 1
				if onProgress then
					pcall(onProgress, completed, total)
				end
			end)
		end
		joined = joinBatch(function() return completed >= total end)
	end

	if changed then
		pcall(writefile, 'pistonware/filecheck.json', httpService:JSONEncode(manifest))
	end
	--[[ True only once the cache has been checked against a tree and every refresh landed. The
	no-tree exit above returns nil, and a failed or unjoined download returns false; the release
	marker is not advanced on either, so the next reload runs this pass again. ]]
	return joined and failed == 0
end

--[[
	Loader console
	--------------
	A fake terminal window that stands in for the executor console while pistonware boots.
	The piston face is drawn one row at a time as the boot progresses, so the art is only
	ever complete at the same moment the status flips to '> DONE'.
]]

local PistonFace = {
	'******=============******++++++=============******',
	'******=============******++++++=============******',
	'******=============******++++++=============******',
	'++++++=============++++++===================++++++',
	'++++++=============++++++===================++++++',
	'++++++=============++++++===================++++++',
	'::::::@@@@@@       ------::::::@@@@@@       ::::::',
	'::::::@@@@@@       ------::::::@@@@@@       ::::::',
	'::::::@@@@@@       ------::::::@@@@@@       ::::::',
	'::::::@@@@@@       ++++++------@@@@@@       ::::::',
	'::::::@@@@@@       ++++++------@@@@@@       ::::::',
	'::::::@@@@@@       ++++++------@@@@@@       ::::::',
	'::::::######:::::::++++++======******:::::::::::::',
	'::::::++++++=======++++++++++++=============::::::',
	'::::::++++++=======++++++++++++=============::::::',
	'::::::++++++=======++++++++++++=============::::::',
	'------++++++                         =======------',
	'------++++++                         =======------',
	'------++++++                         =======------',
	'::::::=============      ++++++++++++=======::::::',
	'::::::=============      ++++++++++++=======::::::',
	'::::::=============      ++++++++++++=======::::::',
	'::::::------:::::::------::::::------:::::::::::::',
	'::::::------:::::::------::::::------:::::::::::::',
	'::::::------:::::::------::::::------:::::::::::::'
}

--[[ Every offset below is authored against the base window and scaled as a whole by the
UIScale, so the layout can't drift apart on other resolutions. ]]
local WindowWidth = 1000
local TitleBarHeight = 44
local ContentPadding = 26
--[[ Rows are packed slightly tighter than the glyph size so the 25-row face stays a sane
height. Text is never clipped by its own frame in Roblox, so the 2px per row overlaps
harmlessly. ]]
local AsciiTextSize = 20
local AsciiLineHeight = 18

--[[ The rows under the art are positioned off the art itself, so a taller or shorter face
pushes them (and the bottom of the window) down instead of colliding with them. ]]
local AsciiTop = TitleBarHeight + 16
local StatusY = AsciiTop + #PistonFace * AsciiLineHeight + 16
local LineY = StatusY + 32
local AnswersY = LineY + 30
local WindowHeight = AnswersY + 34 + 30 + 22 + 16

local Palette = {
	Window = Color3.fromRGB(10, 10, 10),
	TitleBar = Color3.fromRGB(38, 38, 38),
	Border = Color3.fromRGB(52, 52, 52),
	Title = Color3.fromRGB(232, 232, 232),
	Glyph = Color3.fromRGB(190, 190, 190),
	Accent = Color3.fromRGB(240, 122, 31),
	Line = Color3.fromRGB(237, 237, 237),
	Footer = Color3.fromRGB(110, 110, 110),
	ButtonIdle = Color3.fromRGB(200, 200, 200),
	ButtonBorder = Color3.fromRGB(60, 60, 60),
	Error = Color3.fromRGB(225, 80, 70),
	Ok = Color3.fromRGB(120, 225, 150)
}

--[[ Ascii shading: the art is one colour in a real terminal, but the piston only reads as a
face if the solid blocks sit brighter than the dithered background, so each glyph class
gets its own tone. ]]
local AsciiShades = {
	['@'] = '#F2F2F2',
	['#'] = '#E4E4E4',
	['%'] = '#D2D2D2',
	['*'] = '#A6A6A6',
	['+'] = '#8C8C8C',
	['='] = '#6B6B6B',
	['-'] = '#5C5C5C',
	[':'] = '#4A4A4A',
	['.'] = '#4A4A4A'
}

--[[ Cancelling the loader has to leave nothing behind that THIS boot created, so on a fresh
install the whole folder is wiped. On an install that already existed before this run the
wipe is skipped entirely -- the folder holds the user's custom profiles, and cancelling a
reinject must never cost them those; only an explicit reinstall (reinstall.lua) deletes an
existing install. delfolder already recurses on the executors that have it; the manual walk
is for the ones that only ship delfile. ]]
--[[ Frees the session-wide flags this boot is holding, so the next manual run is not turned
away by the duplicate guard.

Ownership-checked, because a boot sitting on the key prompt can be taken over by a later
execution (see the guard above). The loser unwinds through here moments after the winner has
stamped its own boot, and clearing the winner's flags would leave the new run looking like a
reload -- headless, with no way to ask for a key. Exactly the state this whole path exists to
get people out of.

shared.vapereload goes with them. It is normally consumed at the very bottom of this file,
AFTER main.lua has had its look at it, but a boot that ends early never gets there and the flag
was left standing for the rest of the session. Everything from then on read as a reload: the
console went headless, and a headless console cannot ask for a key. That is what made a lapsed
key unrecoverable in-game -- Reinject failed at the gate telling you to run the loader manually,
and running it manually hit this same stale flag and said it again.

This is the WHOLE of what a failed key gate does. It never calls deleteInstall: the folder holds
the profiles the user built themselves, and wiping those because LuaArmor answered 'expired'
would charge them everything they configured for something a renewed key fixes in ten seconds.
The key outlives the install anyway -- pistonwarekey.json sits outside the folder for exactly
that reason -- so the deletion would be pure loss. ]]
local function releaseBoot()
	if shared.PistonwareLoaderBoot ~= bootStamp then return end
	shared.PistonwareLoaderBoot = nil
	shared.PistonwareKeyPrompt = nil
	shared.vapereload = nil
end

local freshInstall = false
local function deleteInstall()
	--[[ every cancel/abort path comes through here, so a cancelled boot immediately frees the
	duplicate-execution guard for the next manual run ]]
	releaseBoot()
	--[[ Before the wipe, so held lines land where they would have been written all along. ]]
	stopHoldingLogs()
	if not freshInstall then return end
	pcall(function()
		if delfolder then
			delfolder('pistonware')
			return
		end
		local function purge(folder)
			for _, path in listfiles(folder) do
				if isfolder(path) then
					purge(path)
				elseif delfile then
					delfile(path)
				end
			end
		end
		purge('pistonware')
	end)
end

local function asciiRichText(line)
	local out = {}
	local runColor, runStart = nil, 1
	local function flush(stop)
		if stop < runStart then return end
		local chunk = line:sub(runStart, stop)
		table.insert(out, runColor and ('<font color="'..runColor..'">'..chunk..'</font>') or chunk)
	end
	for i = 1, #line do
		local color = AsciiShades[line:sub(i, i)]
		if i > 1 and color ~= runColor then
			flush(i - 1)
			runStart = i
		end
		runColor = color
	end
	flush(#line)
	return table.concat(out)
end

local function createConsole()
	local tweenService = cloneref(game:GetService('TweenService'))
	local inputService = cloneref(game:GetService('UserInputService'))
	local playersService = cloneref(game:GetService('Players'))

		--[[ Whatever a previous run left standing goes first. Several Fail() paths through this
		file return without destroying the console so the message can be read, and each leaves behind
		a GUI tree, three service-level connections and the reveal thread below. Re-executing
		is the natural response to all of them, so without this the leak grows once per attempt
		rather than being replaced. ]]
	pcall(function()
		if type(shared.PistonwareLoaderTeardown) == 'function' then
			shared.PistonwareLoaderTeardown()
		end
	end)

	--[[ Connections on services and the camera, which outlive screen:Destroy() -- unlike the
	button and titlebar ones, which are parented into the GUI and go with it. ]]
	local connections = {}
	local function track(connection)
		table.insert(connections, connection)
		return connection
	end

	local screen = Instance.new('ScreenGui')
	screen.Name = 'PistonwareLoader'
	screen.DisplayOrder = 999999999
	screen.IgnoreGuiInset = true
	screen.ResetOnSpawn = false
	local parented = pcall(function()
		screen.Parent = (gethui and gethui()) or cloneref(game:GetService('CoreGui'))
	end)
	if not parented then
		pcall(function()
			screen.Parent = playersService.LocalPlayer:FindFirstChildOfClass('PlayerGui')
		end)
	end

	local window = Instance.new('Frame')
	window.AnchorPoint = Vector2.new(0.5, 0.5)
	window.Position = UDim2.fromScale(0.5, 0.5)
	window.Size = UDim2.fromOffset(WindowWidth, WindowHeight)
	window.BackgroundColor3 = Palette.Window
	window.BorderSizePixel = 0
	--[[ so minimising can roll the console up behind its own titlebar ]]
	window.ClipsDescendants = true
	window.Parent = screen
	local windowCorner = Instance.new('UICorner')
	windowCorner.CornerRadius = UDim.new(0, 10)
	windowCorner.Parent = window
	local windowStroke = Instance.new('UIStroke')
	windowStroke.Color = Palette.Border
	windowStroke.Thickness = 1
	windowStroke.Parent = window

	--[[ One UIScale drives the whole window, so the console keeps its proportions from a phone up
	to a 4K monitor: full size at 1080p, shrunk to fit anything smaller. ]]
	local uiscale = Instance.new('UIScale')
	uiscale.Parent = window
	local camera = workspace.CurrentCamera

	--[[ Window state, the way a desktop WM handles it: minimise rolls the window up into its own
	titlebar (there is no taskbar to minimise *to* here, so shading is the recoverable
	equivalent) and maximise fills the viewport, both toggling back on a second click. ]]
	local minimized, maximized = false, false
	local restorePosition = window.Position

	local function applyWindowState(animate)
		local viewport = camera and camera.ViewportSize or Vector2.new(WindowWidth, WindowHeight)
		--[[ Sizes are pre-UIScale, so divide by the scale to land on the viewport once scaled. ]]
		local width = maximized and (viewport.X / uiscale.Scale) or WindowWidth
		local height = maximized and (viewport.Y / uiscale.Scale) or WindowHeight
		local size = UDim2.fromOffset(width, minimized and TitleBarHeight or height)
		local position = maximized and UDim2.fromScale(0.5, 0.5) or restorePosition
		if animate then
			tweenService:Create(window, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {Size = size, Position = position}):Play()
		else
			window.Size, window.Position = size, position
		end
	end

	local function applyScale()
		local viewport = camera and camera.ViewportSize or Vector2.new(WindowWidth, WindowHeight)
		if viewport.X <= 0 or viewport.Y <= 0 then return end
		local fit = math.min(viewport.X * 0.94 / WindowWidth, viewport.Y * 0.92 / WindowHeight)
		local scale = math.min(fit, viewport.Y / 1080)
		--[[ The 1080p cap leaves a landscape phone at a third of its height with 6px text, so
		touch-only devices take the fit instead. Capped at 0.7 (only tablets get that far) and
		never below the desktop size. ]]
		if inputService.TouchEnabled and not inputService.KeyboardEnabled then
			scale = math.max(scale, math.min(fit, 0.7))
		end
		uiscale.Scale = math.clamp(scale, 0.25, 1.4)
		--[[ a maximised window has to keep tracking the viewport it is filling ]]
		applyWindowState(false)
	end
	applyScale()
	if camera then
		track(camera:GetPropertyChangedSignal('ViewportSize'):Connect(applyScale))
	end

	local titlebar = Instance.new('Frame')
	titlebar.Size = UDim2.new(1, 0, 0, TitleBarHeight)
	titlebar.BackgroundColor3 = Palette.TitleBar
	titlebar.BorderSizePixel = 0
	titlebar.Parent = window
	local titlebarCorner = Instance.new('UICorner')
	titlebarCorner.CornerRadius = UDim.new(0, 10)
	titlebarCorner.Parent = titlebar
	--[[ Squares off the bottom two corners the UICorner above rounded. ]]
	local titlebarFill = Instance.new('Frame')
	titlebarFill.Position = UDim2.new(0, 0, 1, -10)
	titlebarFill.Size = UDim2.new(1, 0, 0, 10)
	titlebarFill.BackgroundColor3 = Palette.TitleBar
	titlebarFill.BorderSizePixel = 0
	titlebarFill.Parent = titlebar

	local icon = Instance.new('TextLabel')
	icon.Position = UDim2.fromOffset(10, 10)
	icon.Size = UDim2.fromOffset(24, 24)
	icon.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	icon.BorderSizePixel = 0
	icon.Text = '>_'
	icon.TextColor3 = Palette.Accent
	icon.TextSize = 13
	icon.Font = Enum.Font.Code
	icon.Parent = titlebar
	local iconCorner = Instance.new('UICorner')
	iconCorner.CornerRadius = UDim.new(0, 5)
	iconCorner.Parent = icon

	local title = Instance.new('TextLabel')
	title.BackgroundTransparency = 1
	title.Size = UDim2.new(1, -220, 1, 0)
	title.Position = UDim2.fromOffset(110, 0)
	title.Text = './pistonware-loader'
	title.TextColor3 = Palette.Title
	title.TextSize = 18
	title.Font = Enum.Font.Code
	title.Parent = titlebar

	--[[ `finished` is raised by Finish(): from then on the boot is complete and the window is only
	counting itself out. ]]
	local closed, aborted, finished = false, false, false
	local console
	local function destroy()
		if closed then return end
		--[[ Set first: the reveal thread and every wait loop below key off it, so they stop
		even if destroying the GUI throws. ]]
		closed = true
		for _, connection in connections do
			pcall(function() connection:Disconnect() end)
		end
		table.clear(connections)
		pcall(function() screen:Destroy() end)
		--[[ Only clear the handle if it is still ours; a newer console may already own it. ]]
		if shared.PistonwareLoaderTeardown == destroy then
			shared.PistonwareLoaderTeardown = nil
		end
		--[[ The logger outlives the window (a download that fails after the boot still reports
		through it), so it lets go of this one instead of holding the destroyed tree for the rest
		of the session. ]]
		if logger.console == console then
			logger.console = nil
		end
	end

	--[[ Closing the window by hand is a cancel, not a dismissal: the boot stops at the next
	checkpoint, and on a first install everything the run wrote is deleted so a half-finished
	install can't be left behind (and no config gets silently picked for you). On an existing
	install deleteInstall refuses to wipe, so cancelling a reinject just stops the boot.

	Except once Finish() has run. The injection has succeeded and pistonware is running out of
	that folder, so [x] or ctrl+c during the countdown only closes the window early -- wiping a
	fresh install there deleted the profiles and cache from under the live GUI. ]]
	local function cancel()
		if finished then
			destroy()
			return
		end
		if aborted then return end
		aborted = true
		destroy()
		deleteInstall()
	end

	--[[ Chrome glyphs are drawn from thin rotated bars rather than typed: Roblox's Code font has
	no chevron glyphs, and a literal 'v'/'^' reads as text sitting next to the title instead
	of as window controls. ]]
	local function drawGlyph(parent, kind)
		local bars = {}
		local function bar(length, x, y, rotation)
			local piece = Instance.new('Frame')
			piece.AnchorPoint = Vector2.new(0.5, 0.5)
			piece.Position = UDim2.fromOffset(x, y)
			piece.Size = UDim2.fromOffset(length, 2)
			piece.BackgroundColor3 = Palette.Glyph
			piece.BorderSizePixel = 0
			piece.Rotation = rotation
			piece.Parent = parent
			local corner = Instance.new('UICorner')
			corner.CornerRadius = UDim.new(0, 1)
			corner.Parent = piece
			table.insert(bars, piece)
		end
		--[[ Arms meet at the centre of the 34x34 button: a chevron is two 10px bars at +-45
		degrees, the close is the same two bars crossed. ]]
		if kind == 'minimize' then
			bar(10, 13.5, 17, 45)
			bar(10, 20.5, 17, -45)
		elseif kind == 'maximize' then
			bar(10, 13.5, 17, -45)
			bar(10, 20.5, 17, 45)
		else
			bar(15, 17, 17, 45)
			bar(15, 17, 17, -45)
		end
		return bars
	end

	--[[ Assigned once the footer exists; the window buttons below are built before it. ]]
	local applyChromeVisibility = function() end

	for index, kind in {'minimize', 'maximize', 'close'} do
		local button = Instance.new('TextButton')
		button.AnchorPoint = Vector2.new(1, 0.5)
		button.Position = UDim2.new(1, -14 - (3 - index) * 38, 0.5, 0)
		button.Size = UDim2.fromOffset(34, 34)
		button.BackgroundColor3 = Color3.new(1, 1, 1)
		button.BackgroundTransparency = 1
		button.AutoButtonColor = false
		button.Modal = true
		button.Text = ''
		button.Parent = titlebar
		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 6)
		corner.Parent = button

		local bars = drawGlyph(button, kind)
		button.MouseEnter:Connect(function()
			button.BackgroundTransparency = 0.9
			for _, piece in bars do
				piece.BackgroundColor3 = kind == 'close' and Palette.Error or Color3.new(1, 1, 1)
			end
		end)
		button.MouseLeave:Connect(function()
			button.BackgroundTransparency = 1
			for _, piece in bars do
				piece.BackgroundColor3 = Palette.Glyph
			end
		end)

		button.MouseButton1Click:Connect(function()
			if kind == 'close' then
				cancel()
			elseif kind == 'minimize' then
				minimized = not minimized
				applyWindowState(true)
				applyChromeVisibility()
			else
				--[[ maximising an already rolled-up window unrolls it, as a WM would ]]
				maximized = not maximized
				minimized = false
				applyWindowState(true)
				applyChromeVisibility()
			end
		end)
	end

	--[[ Drag by the titlebar. Offsets live in screen space (the UIScale only rescales children),
	so the delta can be applied straight to the window position. ]]
	local dragging, dragStart, dragOrigin
	titlebar.InputBegan:Connect(function(input)
		--[[ a maximised window is pinned to the viewport; unmaximise it to move it ]]
		if maximized then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, dragStart, dragOrigin = true, input.Position, window.Position
			--[[ Dropped when this press ends. The mouse hands every click the same InputObject, so
			a handler left connected here outlived the window, one more for every drag. Tracked as
			well, so a window destroyed mid-drag drops it too. ]]
			local release
			release = track(input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					release:Disconnect()
				end
			end))
		end
	end)
	track(inputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			window.Position = UDim2.new(dragOrigin.X.Scale, dragOrigin.X.Offset + delta.X, dragOrigin.Y.Scale, dragOrigin.Y.Offset + delta.Y)
			--[[ so unmaximising and unminimising both come back to where it was left ]]
			restorePosition = window.Position
		end
	end))

	local ascii = Instance.new('Frame')
	ascii.BackgroundTransparency = 1
	ascii.Position = UDim2.fromOffset(ContentPadding, AsciiTop)
	ascii.Size = UDim2.fromOffset(WindowWidth - ContentPadding * 2, #PistonFace * AsciiLineHeight)
	ascii.Parent = window

	local rows = {}
	for index, line in PistonFace do
		local label = Instance.new('TextLabel')
		label.BackgroundTransparency = 1
		label.Position = UDim2.fromOffset(0, (index - 1) * AsciiLineHeight)
		label.Size = UDim2.new(1, 0, 0, AsciiLineHeight)
		label.RichText = true
		label.Text = asciiRichText(line)
		label.TextColor3 = Color3.new(1, 1, 1)
		label.TextSize = AsciiTextSize
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextTransparency = 1
		label.Font = Enum.Font.Code
		label.Visible = false
		label.Parent = ascii
		rows[index] = label
	end

	local status = Instance.new('TextLabel')
	status.BackgroundTransparency = 1
	status.Position = UDim2.fromOffset(ContentPadding, StatusY)
	status.Size = UDim2.new(1, -ContentPadding * 2, 0, 28)
	status.RichText = true
	status.TextColor3 = Palette.Line
	status.TextSize = 22
	status.TextXAlignment = Enum.TextXAlignment.Left
	status.Font = Enum.Font.Code
	status.Parent = window

	local line = Instance.new('TextLabel')
	line.BackgroundTransparency = 1
	line.Position = UDim2.fromOffset(ContentPadding, LineY)
	line.Size = UDim2.new(1, -ContentPadding * 2, 0, 24)
	line.Text = ''
	line.TextColor3 = Palette.Line
	line.TextSize = 17
	line.TextXAlignment = Enum.TextXAlignment.Left
	line.Font = Enum.Font.Code
	line.Parent = window

	--[[ Answer buttons sit on the row directly under the question and are reused for every
	prompt, so answering one question simply rewrites the line above them. ]]
	local answers = Instance.new('Frame')
	answers.BackgroundTransparency = 1
	answers.Position = UDim2.fromOffset(ContentPadding, AnswersY)
	answers.Size = UDim2.new(1, -ContentPadding * 2, 0, 34)
	answers.Visible = false
	answers.Parent = window
	local answersLayout = Instance.new('UIListLayout')
	answersLayout.SortOrder = Enum.SortOrder.LayoutOrder
	answersLayout.FillDirection = Enum.FillDirection.Horizontal
	answersLayout.Padding = UDim.new(0, 12)
	answersLayout.Parent = answers

	--[[ Explains what the hovered answer actually does. It rides in the same list layout as the
	buttons (LayoutOrder puts it last, after however many there are) so it lands on their row
	with the same gap between, and a hidden child takes no space -- the row closes up around
	it while nothing is hovered. Ask() only clears TextButtons, so this survives each question. ]]
	local tooltip = Instance.new('TextLabel')
	tooltip.Name = 'Tooltip'
	tooltip.LayoutOrder = 999
	tooltip.AutomaticSize = Enum.AutomaticSize.X
	tooltip.Size = UDim2.fromOffset(0, 34)
	tooltip.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
	tooltip.BorderSizePixel = 0
	tooltip.Visible = false
	tooltip.Text = ''
	tooltip.TextColor3 = Palette.Line
	tooltip.TextSize = 15
	tooltip.Font = Enum.Font.Code
	tooltip.Parent = answers
	local tooltipPadding = Instance.new('UIPadding')
	tooltipPadding.PaddingLeft = UDim.new(0, 12)
	tooltipPadding.PaddingRight = UDim.new(0, 12)
	tooltipPadding.Parent = tooltip
	local tooltipCorner = Instance.new('UICorner')
	tooltipCorner.CornerRadius = UDim.new(0, 4)
	tooltipCorner.Parent = tooltip
	local tooltipStroke = Instance.new('UIStroke')
	tooltipStroke.Color = Palette.ButtonBorder
	tooltipStroke.Thickness = 1
	tooltipStroke.Parent = tooltip

	local footer = Instance.new('TextLabel')
	footer.AnchorPoint = Vector2.new(0, 1)
	footer.BackgroundTransparency = 1
	footer.Position = UDim2.new(0, ContentPadding, 1, -16)
	footer.Size = UDim2.new(1, -ContentPadding * 2, 0, 22)
	--[[ Touch-only devices have no ctrl key, so point them at the titlebar button instead. ]]
	footer.Text = (inputService.TouchEnabled and not inputService.KeyboardEnabled) and 'Tap [x] to exit' or 'Press [CTRL+C] to exit'
	footer.TextColor3 = Palette.Footer
	footer.TextSize = 17
	footer.TextXAlignment = Enum.TextXAlignment.Left
	footer.Font = Enum.Font.Code
	footer.Parent = window

	--[[ An opt-out for the question currently being asked, in the bottom-right corner opposite
	the footer. Greyed out on purpose: it is the answer nobody should click by accident.
	Ask() shows it only when the caller passes one, and hides it again afterwards. ]]
	local optOutButton = Instance.new('TextButton')
	optOutButton.AnchorPoint = Vector2.new(1, 1)
	optOutButton.BackgroundTransparency = 1
	optOutButton.Position = UDim2.new(1, -ContentPadding, 1, -16)
	optOutButton.Size = UDim2.fromOffset(0, 22)
	optOutButton.AutomaticSize = Enum.AutomaticSize.X
	optOutButton.AutoButtonColor = false
	optOutButton.Modal = true
	optOutButton.Visible = false
	optOutButton.Text = ''
	optOutButton.TextColor3 = Palette.Footer
	optOutButton.TextSize = 17
	optOutButton.TextXAlignment = Enum.TextXAlignment.Right
	optOutButton.Font = Enum.Font.Code
	optOutButton.Parent = window
	optOutButton.MouseEnter:Connect(function()
		optOutButton.TextColor3 = Palette.Line
	end)
	optOutButton.MouseLeave:Connect(function()
		optOutButton.TextColor3 = Palette.Footer
	end)

	--[[ The footer and the opt-out are anchored to the bottom edge, so a rolled-up window would
	leave them floating over the titlebar. Hidden while minimised. ]]
	local optOutActive = false
	applyChromeVisibility = function()
		footer.Visible = not minimized
		optOutButton.Visible = optOutActive and not minimized
	end

	track(inputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		if input.KeyCode == Enum.KeyCode.C and inputService:IsKeyDown(Enum.KeyCode.LeftControl) then
			cancel()
		end
	end))

	local revealed, revealTarget = 0, 0
	--[[ Set by Halt() on the paths that leave the window up for reading but have no more rows
	to draw. Without it this thread outlives the boot at ~14Hz for the rest of the session. ]]
	local halted = false
	task.spawn(function()
		while not closed and not halted do
			if revealed < revealTarget then
				revealed += 1
				local row = rows[revealed]
				row.Visible = true
				tweenService:Create(row, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
			end
			task.wait(0.07)
		end
	end)

	--[[ One flat terminal button, shared by the answer row Ask() builds and the key entry row
	AskKey() builds. Callers stack their own MouseEnter/MouseLeave handlers on top of the
	accent hover wired here; Roblox runs every connection, so nothing needs passing in. ]]
	local function answerButton(text, width, order)
		local button = Instance.new('TextButton')
		--[[ keeps the buttons in the order given, ahead of the tooltip that trails them ]]
		button.LayoutOrder = order
		button.Size = UDim2.fromOffset(width, 34)
		button.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		button.BorderSizePixel = 0
		button.AutoButtonColor = false
		--[[ Frees the touch cursor so the button is tappable on phones (where input would
		otherwise be locked to the game). ]]
		button.Modal = true
		button.Text = text
		button.TextColor3 = Palette.ButtonIdle
		button.TextSize = 17
		button.Font = Enum.Font.Code
		button.Parent = answers
		local corner = Instance.new('UICorner')
		corner.CornerRadius = UDim.new(0, 4)
		corner.Parent = button
		local stroke = Instance.new('UIStroke')
		stroke.Color = Palette.ButtonBorder
		stroke.Thickness = 1
		stroke.Parent = button
		button.MouseEnter:Connect(function()
			stroke.Color = Palette.Accent
			button.TextColor3 = Palette.Accent
		end)
		button.MouseLeave:Connect(function()
			stroke.Color = Palette.ButtonBorder
			button.TextColor3 = Palette.ButtonIdle
		end)
		return button
	end

	--[[ The controls that Ask() and AskKey() put on the answer row are cleared between prompts. The tooltip
	label shares the frame and has to survive, hence the class test rather than a blanket
	ClearAllChildren. ]]
	local function clearAnswers()
		for _, child in answers:GetChildren() do
			if child:IsA('TextButton') or child:IsA('TextBox') then
				child:Destroy()
			end
		end
	end

	console = {}

	--[[ `chevron` is the glyph in front of the status word. It points forward ('>') for every
	step of the boot itself, and backward ('<') for the key gate, which is the one phase that
	is holding the boot up rather than advancing it. Escaped, since the label is RichText. ]]
	function console:SetStatus(text, color, chevron)
		status.Text = '<font color="#9E9E9E">'..(chevron == '<' and '&lt;' or '&gt;')..'</font> <font color="'..(color or '#F07A1F')..'">'..text..'</font>'
	end

	function console:SetLine(text, color)
		line.Text = text
		line.TextColor3 = color or Palette.Line
	end

	--[[ alpha is how far through the boot we are; the face is drawn to match, one row at a time.
	Clamped upwards only: a late progress report from a background step must never pull rows
	back off the face (nothing here ever un-boots). ]]
	function console:SetProgress(alpha)
		local count = math.clamp(math.floor(alpha * #PistonFace + 0.5), 0, #PistonFace)
		revealTarget = math.max(revealTarget, count)
	end

	function console:IsAborted()
		return aborted
	end

	--[[ Asks a question on the output line, waits for one of the buttons underneath it, then
	clears the line again so the next question can take its place. `fallback` is returned if
	the loader is closed or the timeout elapses -- a missed click must never hang injection. ]]
	function console:Ask(question, buttons, timeoutSeconds, fallback, optOut)
		if closed then return fallback end
		self:SetLine(question)
		clearAnswers()

		tooltip.Visible = false

		local choice
		--[[ `optOut` is one more answer, {text, key, tooltip}, drawn in the corner instead of on the
		row. Its connections are dropped when the question ends so the next Ask starts clean. ]]
		local optOutConnections = {}
		if optOut then
			optOutButton.Text = optOut.text
			optOutButton.TextColor3 = Palette.Footer
			table.insert(optOutConnections, optOutButton.MouseButton1Click:Connect(function()
				choice = optOut.key
			end))
			if optOut.tooltip then
				table.insert(optOutConnections, optOutButton.MouseEnter:Connect(function()
					tooltip.Text = optOut.tooltip
					tooltip.Visible = true
				end))
				table.insert(optOutConnections, optOutButton.MouseLeave:Connect(function()
					tooltip.Visible = false
				end))
			end
			optOutActive = true
			applyChromeVisibility()
		end
		for index, def in buttons do
			local button = answerButton(def.text, 132, index)
			if def.tooltip then
				button.MouseEnter:Connect(function()
					tooltip.Text = def.tooltip
					tooltip.Visible = true
				end)
				button.MouseLeave:Connect(function()
					tooltip.Visible = false
				end)
			end
			button.MouseButton1Click:Connect(function()
				choice = def.key
			end)
		end
		answers.Visible = true

		local timeout = os.clock() + (timeoutSeconds or 60)
		repeat task.wait() until choice ~= nil or closed or os.clock() > timeout
		answers.Visible = false
		optOutActive = false
		applyChromeVisibility()
		for _, connection in optOutConnections do
			connection:Disconnect()
		end
		clearAnswers()
		tooltip.Visible = false
		self:SetLine('')
		if choice == nil then
			return fallback
		end
		return choice
	end

	--[[ Key entry, drawn into the console's own question row rather than as a second window: the
	status line above it already reads '< KEY SYSTEM', so the gate looks like one more
	terminal prompt instead of a modal floating over the loader.

	Every handler is passed `say(message, kind)` and does its own reporting, which keeps all
	LuaArmor knowledge out of the console. onSubmit returns whether the key was accepted;
	anything false leaves the prompt up for another attempt. Returns the accepted key, or nil
	if the window was closed (i.e. the boot was cancelled).

	Deliberately has NO timeout, unlike Ask(): every boot question has a sane fallback answer,
	and a missing key does not. Waiting forever is correct -- the user is off finishing
	checkpoints in a browser, and the console is what they come back to. ]]
	function console:AskKey(opts)
		if closed then return nil end
		clearAnswers()
		tooltip.Visible = false

		local function say(message, kind)
			self:SetLine(message or '', kind == 'err' and Palette.Error or (kind == 'ok' and Palette.Ok or Palette.Line))
		end
		say(opts.message, opts.messageKind)

		--[[ The footer normally explains how to quit; while the gate is up it explains the gate,
		which is the only thing the user needs from it. Restored on the way out. ]]
		local previousFooter = footer.Text
		if opts.footer then
			footer.Text = opts.footer
		end

		local box = Instance.new('TextBox')
		box.LayoutOrder = 1
		box.Size = UDim2.fromOffset(320, 34)
		box.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
		box.BorderSizePixel = 0
		box.ClearTextOnFocus = false
		box.Text = ''
		box.PlaceholderText = opts.placeholder or ''
		box.PlaceholderColor3 = Palette.Footer
		box.TextColor3 = Palette.Line
		box.TextSize = 16
		box.TextXAlignment = Enum.TextXAlignment.Left
		box.Font = Enum.Font.Code
		box.Parent = answers
		local boxCorner = Instance.new('UICorner')
		boxCorner.CornerRadius = UDim.new(0, 4)
		boxCorner.Parent = box
		local boxStroke = Instance.new('UIStroke')
		boxStroke.Color = Palette.ButtonBorder
		boxStroke.Thickness = 1
		boxStroke.Parent = box
		local boxPadding = Instance.new('UIPadding')
		boxPadding.PaddingLeft = UDim.new(0, 10)
		boxPadding.PaddingRight = UDim.new(0, 10)
		boxPadding.Parent = box
		box.Focused:Connect(function()
			boxStroke.Color = Palette.Accent
		end)
		box.FocusLost:Connect(function()
			boxStroke.Color = Palette.ButtonBorder
		end)

		local accepted
		--[[ Guards the window between clicking Submit and the check coming back: check_key is a
		network round trip, and without this a second click would fire a second one. ]]
		local busy = false
		local function submit()
			if busy or closed or accepted then return end
			busy = true
			local key = trim(box.Text)
			if opts.onSubmit(key, say) then
				accepted = key
			end
			busy = false
		end

		--[[ Hover help goes on the footer, not the inline tooltip Ask() uses. That tooltip rides
		in the same list layout as the buttons, and this row already carries the box and five
		of them -- one hover would push the end of the row past the window edge, which clips.
		The footer has the full width to itself and is saved and restored around the prompt
		anyway. ]]
		local function hint(button, text)
			if not text then return end
			button.MouseEnter:Connect(function()
				footer.Text = text
			end)
			button.MouseLeave:Connect(function()
				footer.Text = opts.footer or previousFooter
			end)
		end

		--[[ One button per key provider, in the order the caller lists them, so adding a
		provider is an entry in that list rather than an edit in here. The widths across the
		whole row are chosen to fit: 948px usable, 910px used with every button showing. ]]
		local order = 1
		for _, link in opts.links or {} do
			order += 1
			local button = answerButton(link.text, 105, order)
			hint(button, link.tooltip)
			button.MouseButton1Click:Connect(function()
				link.onClick(say)
			end)
		end

		--[[ Only offered when the executor can actually read the clipboard; otherwise the row
		closes up around it and the user pastes with ctrl+v into the box like normal. ]]
		if opts.onPaste then
			order += 1
			local paste = answerButton(opts.pasteText, 95, order)
			hint(paste, opts.pasteTip)
			paste.MouseButton1Click:Connect(function()
				local text = opts.onPaste(say)
				if text then
					box.Text = text
				end
			end)
		end

		order += 1
		local submitButton = answerButton(opts.submitText, 115, order)
		hint(submitButton, opts.submitTip)
		submitButton.MouseButton1Click:Connect(submit)

		order += 1
		local help = answerButton(opts.helpText, 110, order)
		hint(help, opts.helpTip)
		help.MouseButton1Click:Connect(function()
			opts.onHelp(say)
		end)

		box.FocusLost:Connect(function(enterPressed)
			if enterPressed then
				submit()
			end
		end)

		answers.Visible = true
		repeat task.wait() until accepted or closed

		answers.Visible = false
		clearAnswers()
		footer.Text = previousFooter
		self:SetLine('')
		return accepted
	end

	--[[ Draws whatever rows are still missing, and only once the face is whole flips the header
	to '> DONE' and counts the window out. ]]
	function console:Finish(message, seconds)
		--[[ Raised before anything yields: closing the window from here on is a dismissal (see cancel). ]]
		finished = true
		if closed then return end
		self:SetProgress(1)
		local drawn = os.clock() + 2
		repeat task.wait() until revealed >= #PistonFace or closed or os.clock() > drawn
		--[[ the last row is still fading in when the counter hits the end ]]
		task.wait(0.2)
		if closed then return end
		self:SetStatus('DONE')
		seconds = seconds or 5
		local deadline = os.clock() + seconds
		task.spawn(function()
			while not closed do
				local left = math.max(0, math.ceil(deadline - os.clock()))
				self:SetLine(message..' Loader will close in '..left..'s.')
				if left <= 0 then break end
				task.wait(0.2)
			end
			destroy()
		end)
	end

	--[[ Stops the reveal thread without taking the window down, for the paths that end the boot
	but still want the message on screen. Everything already drawn stays drawn. ]]
	function console:Halt()
		halted = true
	end

	function console:Fail(err)
		if closed then return end
		self:SetStatus('FAILED', '#E15046')
		--[[ Executor errors carry absolute file paths that run off the right edge on a single
		line. Nothing is going to be asked at this point, so the output line is allowed to
		wrap down through the space the answer row was holding. ]]
		line.TextWrapped = true
		line.TextYAlignment = Enum.TextYAlignment.Top
		line.Size = UDim2.new(1, -ContentPadding * 2, 0, AnswersY + 34 - LineY)
		self:SetLine(err, Palette.Error)
		--[[ Nothing further is drawn after a failure, so the thread has no work left. ]]
		self:Halt()
	end

	--[[ Published so the next execution can tear this console down before building its own. ]]
	shared.PistonwareLoaderTeardown = destroy

	return console
end

--[[ Same surface as the console, wired to nothing. Reloads are not user-initiated -- the queued
teleport script, the GUI's reinject buttons -- so they run the same boot with no window over
the game, and every call site below stays identical instead of guarding each one. ]]
local function createHeadlessConsole()
	local console = {}
	function console:SetStatus() end
	function console:SetLine() end
	function console:SetProgress() end
	function console:Finish() end
	--[[ The one call that still reaches the player: a failed reload has usually already torn the
	old GUI down, so a Roblox notification is the only sign anything went wrong. ]]
	function console:Fail(err)
		pcall(function()
			local text = tostring(err or 'Loader stopped')
			local copied = text:find('(copied to clipboard)', 1, true) ~= nil
			text = text:gsub('%s*%(copied to clipboard%)%s*$', '')
			if #text > 180 then text = text:sub(1, 177)..'...' end
			if copied then text = text..' (copied to clipboard)' end
			game:GetService('StarterGui'):SetCore('SendNotification', {Title = 'Pistonware', Text = text, Duration = 15})
		end)
	end
	function console:Halt() end
	function console:IsAborted() return false end
	--[[ unattended, so a question can only answer with whatever the timeout would have picked ]]
	function console:Ask(question, buttons, timeoutSeconds, fallback)
		return fallback
	end
	--[[ Nobody is watching a headless boot, so there is no one to type a key. A reload that gets
	this far has no saved key that validated, and the caller turns this nil into a clean
	'run the loader manually' failure rather than hanging on an invisible prompt. ]]
	function console:AskKey()
		return nil
	end
	return console
end

--[[ shared.vapereload marks a run that something else started rather than a manual execution.
Read once here: it is cleared after main.lua has had its look at it (see the bottom of this
file), because nothing else clears it and a stale true would hide the console from every
later manual execution in the session. ]]
local isReload = shared.vapereload and true or false

local console
local consoleOk, consoleResult = xpcall(function()
	return isReload and createHeadlessConsole() or createConsole()
end, errorTrace)
if consoleOk then
	console = consoleResult
else
	console = createHeadlessConsole()
	stopExecution(console, 'console.create', consoleResult, consoleResult)
	return
end
do
	local unsupported = {'xeno', 'solara'}
	local executorName = ''
	pcall(function()
		executorName = identifyexecutor and identifyexecutor() or ''
	end)
	local lowered = tostring(executorName):lower()
	for _, name in unsupported do
		if lowered:find(name, 1, true) then
			local message = 'Unsupported executor ('..tostring(executorName)..'), please look in the #supported-executors channel for more info.'
			console:SetStatus('ERROR', '#E15046')
			console:SetLine(message, Palette.Error)
			stopExecution(console, 'executor.unsupported', message, nil, message)
			return
		end
	end
end
logger:bindConsole(console)
logger:info('console.ready', isReload and 'headless console ready' or 'console ready', {reload = isReload})
--[[ The key gate is the first thing that runs -- every run, reinjects included -- so the console
opens directly onto it rather than flashing '> INJECTING' for a frame first. ]]
console:SetStatus('AUTHENTICATING', nil, '<')
console:SetLine('Checking your key...')
console:SetProgress(0.08)

--[[
	Step 0: the key gate.

	Nothing past this block runs until a LuaArmor key validates -- no folders are created, no
	files are downloaded, no config prompts appear, main.lua is never reached, and so neither
	are guis/*.lua, games/<PlaceId>.lua or games/bedwars.lua. Vape cannot load unkeyed because
	the code that loads it is on the far side of this block.
]]
do
	local httpService = cloneref(game:GetService('HttpService'))

	--[[ Reads are separate from writes: setclipboard is already resolved at the top of the file,
	but reading needs its own lookup and is missing on more executors than writing is. ]]
	local canPaste = (getclipboard ~= nil) or (syn ~= nil and syn.read_clipboard ~= nil)
	local function clipboardGet()
		local fn = getclipboard or (syn and syn.read_clipboard)
		if not fn then return nil end
		local ok, res = pcall(fn)
		if ok and type(res) == 'string' then return res end
		return nil
	end
	local function clipboardSet(text)
		if not setclipboard then return false end
		return (pcall(setclipboard, text))
	end

	--[[ Both key buttons come through here, so a provider nobody has filled in yet says so
	instead of copying an empty string, and the wording is the same whichever button was
	pressed. ]]
	local function copyLink(name, url, say)
		if url == '' then
			say(t('link_missing', name), 'err')
			return
		end
		if clipboardSet(url) then
			say(t('link_copied', name))
		else
			say(t('copy_failed'), 'err')
		end
	end

	--[[ pistonwarekey.json lives at the workspace root rather than under pistonware/, so that
	reinstall.lua (and cancelling a first install, which wipes the whole folder) can't cost
	the user a key they already paid checkpoints for. ]]
	local hasFiles = (isfile and readfile and writefile) and true or false
	local function readSavedKey()
		if not hasFiles then return nil end
		local ok, key = pcall(function()
			if isfile(KEY_FILE) then
				local decoded = httpService:JSONDecode(readfile(KEY_FILE))
				if type(decoded) == 'table' then return decoded.key end
			end
			return nil
		end)
		return ok and key or nil
	end
	local function saveKey(key)
		if not hasFiles then return end
		pcall(function()
			writefile(KEY_FILE, httpService:JSONEncode({key = key, saved = os.time()}))
		end)
	end
	local function deleteSavedKey()
		pcall(function()
			if isfile(KEY_FILE) then
				delfile(KEY_FILE)
			end
		end)
	end

	--[[ One line, capped, and run through safeText so an executor error carrying a key in a URL
	cannot end up in the log. ]]
	local function shortError(err, limit)
		return safeText(err, limit or 160)
	end

	--[[ Executor errors arrive as '<chunk>:<line>: <message>', and on some executors that chunk
	is an absolute path long enough to fill the console line on its own -- leaving the part
	worth reading to be truncated away. Stripped for display only; the log copy keeps the
	position, which is what anyone actually debugging it wants. ]]
	local function errorMessage(err)
		return shortError(select(1, tostring(err or ''):gsub('^.-:%d+: ', '')), 90)
	end

	--[[ LuaArmor's public SDK, fetched on first use and reused once it lands.

	Retried the way downloadFile retries the repo, and for the same reason: this is the least
	reliable request the loader makes. Executors routinely fail the first HttpGet of a session
	while the game is still loading, and the CDN in front of library.lua answers with an
	interstitial often enough to matter. One attempt turned every one of those into a flat
	'Failed to load the LuaArmor library.'

	The failure is deliberately NOT latched any more. It used to be: one flag said 'tried', and
	after a single bad request every later call in the session returned nil without touching the
	network again. The key prompt has no timeout, so someone could sit there submitting a
	perfectly good key forever and never once have it checked -- the only way out was restarting
	Roblox. A failed round now arms a short cooldown instead, which stops the candidate sweep
	below from re-fetching for every key it tries, while any human retry (nobody clicks Submit
	twice in five seconds) gets a genuinely fresh attempt.

	apiFailure is the short label the console shows, apiDetail the full text for the log. They
	are separate because these fail in four quite different ways and the difference is the whole
	diagnosis: the request throwing is network, DNS or a blocked host; a body that will not
	compile is a block page rather than the library; a chunk that throws is LuaArmor's own code
	hitting something missing in the executor; and a chunk that returns the wrong shape means
	the SDK changed under us. ]]
	local api, apiCooldown, apiFailure, apiDetail
	local function getApi()
		if api then return api end
		--[[ Long enough that the three candidates below share one round of attempts instead of
		spending nine requests on a network that is plainly down; short enough that it has
		always expired by the time somebody presses Submit again. ]]
		if apiCooldown and os.clock() < apiCooldown then return nil end

		for attempt = 1, 3 do
			local ok, body = pcall(function()
				return game:HttpGet('https://sdkapi-public.luarmor.net/library.lua', true)
			end)
			if not ok then
				apiFailure, apiDetail = 'network', shortError(body)
			elseif type(body) ~= 'string' or body == '' then
				apiFailure, apiDetail = 'no response', 'the request came back empty'
			else
				local chunk, compileError = loadstring(body, 'luarmor')
				if not chunk then
					--[[ A block page, a captcha or an ISP error page -- all of them arrive as a
					perfectly successful request full of HTML. ]]
					apiFailure, apiDetail = 'blocked', shortError(compileError)
				else
					local ranOk, lib = pcall(chunk)
					if not ranOk then
						apiFailure, apiDetail = 'library error', shortError(lib)
					elseif type(lib) ~= 'table' or type(lib.check_key) ~= 'function' then
						apiFailure, apiDetail = 'bad library', 'the SDK loaded without a check_key'
					else
						lib.script_id = SCRIPT_ID
						api = lib
						apiFailure, apiDetail = nil, nil
						return api
					end
				end
			end
			if attempt < 3 then task.wait(attempt) end
		end

		apiCooldown = os.clock() + 5
		logger:warn('key.library', 'could not load the LuaArmor SDK', {reason = apiFailure, detail = apiDetail})
		return nil
	end
	local function checkKey(key)
		local lib = getApi()
		if not lib then
			--[[ library = true marks a non-verdict: nothing was checked, so the key is neither
			good nor bad and nothing downstream may treat it as rejected. ]]
			return {code = 'UNKNOWN_ERROR', library = true, message = t('no_library', apiFailure or 'unknown')}
		end
		local ok, status = pcall(function()
			return lib.check_key(key)
		end)
		--[[ A table with no code is not a verdict either; taking one used to leave every branch
		below unmatched, which read as 'checked, and nothing was wrong'. ]]
		if ok and type(status) == 'table' and status.code then return status end
		--[[ check_key throwing is worth repeating verbatim: it is nearly always the executor
		missing something the SDK wants (identifyexecutor, a hwid source) rather than anything
		to do with the key, and the message names it. ]]
		if not ok then logger:warn('key.check', 'check_key failed', {detail = shortError(status)}) end
		--[[ Cut shorter than the logged copy: the console line is one row and the log already has
		the whole thing. ]]
		return {code = 'UNKNOWN_ERROR', library = true, message = t('check_error', ok and 'no response' or errorMessage(status))}
	end

	--[[ Publishes the validated key where the protected payload will look for it. The LuaArmor
	build reads the global script_key when it runs, which is much later and in a different
	chunk (main.lua -> games/6872274481.lua -> the GitLab redirect), so the key has to go into
	the shared global environment rather than a local here.

	Written BOTH ways deliberately, not either/or. On most executors a plain global assignment
	and getgenv() land in the same table, but not on all of them -- and when they diverge the
	failure is LuaArmor reporting 'No key found' for a key that was very much set, which is
	indistinguishable from a wrong key and near-impossible to diagnose from the message. Two
	assignments cost nothing and remove the whole failure class.

	shared.PistonwareKey is the copy main.lua re-embeds into its queued teleport script:
	globals do not survive a teleport, and the new server re-runs the appropriate loader. ]]
	local function authenticate(key)
		script_key = key
		pcall(function() getgenv().script_key = key end)
		pcall(function() _G.script_key = key end)
		shared.PistonwareKey = key
		shared.PistonwareAuthenticated = true
	end

	--[[ Authentication is re-derived from a real key on EVERY run, never inherited. shared lives
	for the whole executor session, so trusting a flag found in it would make
	`shared.PistonwareAuthenticated = true` in front of the loadstring a one-line gate skip --
	the exact copy-pasteable bypass that ends up shared around. Clearing it first means the
	only way past this block is a key LuaArmor actually accepts.

	The cost is one check_key per loader run, including reinjects. That is fine: reinjects are
	deliberate user actions (the reinject button, a theme switch, a profile switch), not
	anything on a hot path, and check_key is the call LuaArmor expects on every script start. ]]
	shared.PistonwareAuthenticated = nil

	do
		local reason
		--[[ Kept apart from `reason` on purpose. `reason` means LuaArmor returned a verdict on
		the key; a notice means it never got that far -- the library would not load, or
		check_key threw -- so nothing was decided at all. Both travel to the prompt, because
		the alternative is a bare 'Enter your key below' that says nothing about the check
		that just failed, but only one of the two is the key's fault. ]]
		local notice

		local savedKey = readSavedKey()
		if savedKey then
			savedKey = trim(savedKey)
			if savedKey == '' then savedKey = nil end
		end

		--[[ Three places a key can already be, tried in this order:

		  1. a script_key global set in front of the loadstring. This is the snippet
		     LuaArmor's own bot hands people, so it has to work -- and it is the most
		     explicit statement of intent there is: pasting a key means use THAT key.
		  2. shared.PistonwareKey, the copy a reinject carries so the user is not asked
		     again for a key that was validated seconds ago.
		  3. pistonwarekey.json.

		Every one is tried until one validates, rather than committing to the first that
		exists. That matters for the new source: a mistyped key pasted in front of the
		loadstring should fall back to the good key on disk, not force the prompt and make
		the user think their saved key had gone.

		None of these are trusted. They are candidates, and LuaArmor decides. ]]
		local candidates, seen = {}, {}
		local function offer(value)
			if type(value) ~= 'string' then return end
			value = trim(value)
			if value == '' or seen[value] then return end
			seen[value] = true
			table.insert(candidates, value)
		end

		--[[ Executors disagree about where a chunk's globals live, so a key the user set before
		the loadstring can land in any of these three tables -- the same divergence that
		made authenticate() write all three. ]]
		for _, src in {
			function() return script_key end,
			function() return getgenv().script_key end,
			function() return _G.script_key end
		} do
			local ok, value = pcall(src)
			if ok then offer(value) end
		end
		offer(shared.PistonwareKey)
		offer(savedKey)

		for _, candidate in candidates do
			local status = checkKey(candidate)
			local code = status.code
			--[[ Only the key that came off disk is deleted on rejection: a bogus preset or
			session key must not be able to destroy the good one the user has saved. ]]
			local fromDisk = candidate == savedKey
			if code == 'KEY_VALID' then
				rememberExpiry(status)
				authenticate(candidate)
				--[[ Persist whatever just worked. This is what makes LuaArmor's snippet behave
				the way people expect: paste it once, the key lands in pistonwarekey.json,
				and every run after that needs no key in front of the loadstring at all. ]]
				if candidate ~= savedKey then saveKey(candidate) end
				break
			--[[ Only a key that CANNOT come back is deleted. Two of these four states used to
			delete it and should never have:

			  KEY_HWID_LOCKED is not a bad key. LuaArmor's own wording is "key is valid, hwid
			  does not match and needs to be reset". The user resets their HWID via the bot,
			  comes back, and it works -- except that we had already thrown the key away, so
			  instead they came back to an empty prompt and had to go find the key again.
			  That is the bug this fixes: a key with time left on it, in the ordinary waiting
			  state, being treated as though it had died.

			  KEY_EXPIRED is renewable. The ad link renews the same key rather than issuing a
			  different one, so deleting it costs the user a re-paste for no gain.

			KEY_INCORRECT (does not exist in the database) and KEY_BANNED (blacklisted) are
			the genuinely terminal ones. Nothing the user does brings those back, so a stale
			file only means a wasted request on every future run. ]]
			elseif code == 'KEY_EXPIRED' then
				reason = fromDisk and t('saved_expired') or t('expired')
			elseif code == 'KEY_HWID_LOCKED' then
				reason = fromDisk and t('saved_hwid') or t('hwid_locked')
			elseif code == 'KEY_INCORRECT' then
				if fromDisk then deleteSavedKey() end
				reason = fromDisk and t('saved_incorrect') or t('incorrect')
			elseif code == 'KEY_BANNED' then
				if fromDisk then deleteSavedKey() end
				reason = fromDisk and t('saved_banned') or t('banned')
			elseif status.library then
				notice = status.message
			end
			--[[ UNKNOWN_ERROR / SECURITY_ERROR / TIME_ERROR / INVALID_EXECUTOR and friends also
			keep the file, for the same reason: the key is probably fine and LuaArmor (or the
			network, or the executor) is not, so a bad minute must not cost the user the key
			they already earned. They just get prompted this once. ]]
		end

		if not shared.PistonwareAuthenticated then
			--[[ Nothing is torn down here, on purpose.

			A key is a load-time question. Someone already injected and playing keeps
			everything they have -- the vape stays hooked, the profile they equipped stays
			equipped, the install and its configs stay on disk -- and the expiry stops the
			NEXT load instead. The alternatives are both worse: polling LuaArmor on a timer
			to catch the moment it lapses, or pulling the game out from under someone
			mid-match, which lands at the worst possible time precisely because nobody is
			expecting their key to run out right then.

			So a rejected key costs the boot and nothing else. ]]

			--[[
				From here the key UI is not optional, and the loop is what makes that true.

				Headless is the right default for a run something else began: the reinject
				button, a profile reset, a config sync. None of those should throw a terminal
				over the game when the key they are carrying still works.

				It is exactly wrong once the key is the thing that failed. A headless AskKey
				answers nil immediately, so the boot ended on a console warning nobody reads
				mid-match -- and the line it printed, 'run the loader manually to enter one',
				could not even be acted on, because the run had left shared.vapereload set and
				every execution afterwards went down this same headless path. An expired key
				meant restarting Roblox.

				Two other ways the window used to be skipped, both closed here as well: a
				console that had already been closed by hand returned straight out of the gate
				(the boot was cancelled, but so was the only chance to fix the key), and a
				single pcall(createConsole) that happened to throw -- CoreGui and gethui are
				the one thing in this file that can fail on a hostile executor -- fell through
				to the same dead end. So an aborted console is rebuilt rather than obeyed, and
				a failed build is retried before giving up.

				Every route that reaches here is a deliberate action: a manual execution, or an
				in-game click (a teleport re-runs main.lua directly and never touches this
				file). Somebody is at the keyboard. Give them something to type into.
			]]
			local canPrompt = false
			for attempt = 1, 3 do
				--[[ The window this run already built is fine unless it is headless (a reload)
				or the user has closed it; either way it cannot take a key. ]]
				if attempt == 1 and not isReload and not console:IsAborted() then
					canPrompt = true
					break
				end
				local built, upgraded = pcall(createConsole)
				if built and upgraded then
					console = upgraded
					logger:bindConsole(console)
					canPrompt = true
					break
				end
				logger:warn('key.console', 'could not build the key prompt console', {attempt = attempt})
				task.wait(0.5)
			end

			console:SetStatus('KEY SYSTEM', nil, '<')
			console:SetProgress(0.1)

			--[[ Raised for the duplicate-execution guard at the top of the file: AskKey does not
			return until the user types something or the window closes, and while it is up a
			second execution is allowed through to build a prompt of its own instead of being
			turned away in silence. Stamped rather than a bare true so only the boot that
			raised it can lower it again. ]]
			shared.PistonwareKeyPrompt = bootStamp
			--[[ The prompt has no timeout, so what the boot has logged so far is written now rather
			than held for as long as somebody takes to fetch a key. ]]
			flushLogs()

			local key = console:AskKey({
				message = reason or notice or t('enter_key'),
				messageKind = (reason or notice) and 'err' or nil,
				placeholder = t('placeholder'),
				footer = t('footer'),
				pasteText = t('paste'),
				pasteTip = t('tip_paste'),
				submitText = t('submit'),
				submitTip = t('tip_submit'),
				helpText = t('need_help'),
				helpTip = t('tip_help'),
				--[[ The order here is the order on screen, and each entry carries its own URL
				and its own line of hover help -- the console draws whatever it is handed and
				knows nothing about LuaArmor. ]]
				links = {
					{text = t('work_ink'), tooltip = t('tip_work_ink'), onClick = function(say)
						copyLink('Work.ink', WORKINK_URL, say)
					end},
					{text = t('loot_labs'), tooltip = t('tip_loot_labs'), onClick = function(say)
						copyLink('LootLabs', LOOTLABS_URL, say)
					end}
				},
				--[[ Left nil when the executor cannot read the clipboard, which drops the button
				from the row entirely; ctrl+v into the box still works. ]]
				onPaste = canPaste and function(say)
					local clip = clipboardGet()
					if clip and trim(clip) ~= '' then
						say(t('pasted'))
						return trim(clip)
					end
					say(t('clipboard_empty'), 'err')
					return nil
				end or nil,
				onHelp = function(say)
					if clipboardSet(HELP_URL) then
						say(t('help_copied'))
					else
						say(t('copy_failed'), 'err')
					end
				end,
				onSubmit = function(key, say)
					if key == '' then
						say(t('empty_key'), 'err')
						return false
					end
					--[[ Cheap local reject before spending a request on something that cannot be
					a key (usually a half-pasted clipboard). ]]
					if #key < 8 then
						say(t('bad_format'), 'err')
						return false
					end
					say(t('checking'))
					local status = checkKey(key)
					local code = status.code
					if code == 'KEY_VALID' then
						saveKey(key)
						rememberExpiry(status)
						say(t('valid_loading', keyDetail(status)), 'ok')
						authenticate(key)
						return true
					elseif code == 'KEY_HWID_LOCKED' then
						say(t('hwid_locked'), 'err')
					elseif code == 'KEY_EXPIRED' then
						say(t('expired'), 'err')
					elseif code == 'KEY_BANNED' then
						say(t('banned'), 'err')
					elseif code == 'KEY_INCORRECT' then
						say(t('incorrect'), 'err')
					elseif code == 'KEY_INVALID' then
						say(t('invalid_format'), 'err')
					elseif status.library then
						--[[ Nothing was checked, so this is not a verdict on what they typed --
						the message says so and asks them to press Submit again. ]]
						say(status.message, 'err')
					else
						say(t('check_failed', tostring(status.message), tostring(code)), 'err')
					end
					return false
				end
			})

			if shared.PistonwareKeyPrompt == bootStamp then
				shared.PistonwareKeyPrompt = nil
			end

			--[[ IsAborted() as well as the nil test: closing the window while a check is still in
			flight lets that check land afterwards and set `accepted`, and a cancelled boot
			must not carry on just because the key turned out to be good. The key is still
			saved and the session still counts as authenticated, so the next run skips the
			gate -- cancelling costs the boot, not the key. ]]
			if not key or console:IsAborted() then
				--[[ The window closed, or -- only if a console could not be built at all, three
				tries deep -- there was nowhere to ask. Nothing has been downloaded or
				injected, so the boot simply stops. ]]
				local message = (not canPrompt) and t('headless') or t('cancelled')
				if not console:IsAborted() then
					console:Fail(message)
				end
				--[[ Keep the failure in the buffer as well as the console line so a headless reload
				still leaves a reportable result. ]]
				logger:warn('loader.cancelled', message)
				--[[ Flags only. No uninject, no delete: leaving the gate without a key ends
				this boot, not the session that is already running and not the install. ]]
				releaseBoot()
				return
			end
		end
	end

	--[[ Authenticated: hand the console back to the boot it was holding up. ]]
	phase('key gate')
	console:SetStatus('INJECTING')
	console:SetLine('Injecting into ROBLOX...')
	console:SetProgress(0.12)
end

--[[ Decided before the folders are created, while 'did this run create the install' is still
observable. The key gate above yields, but it runs before any folder exists and its own
cancel path returns without reaching here, so freshInstall still cannot be read stale. ]]
local foldersOk, foldersError = xpcall(function()
	freshInstall = not isfolder('pistonware')
	for _, folder in {'pistonware', 'pistonware/games', 'pistonware/profiles', 'pistonware/assets', 'pistonware/libraries', 'pistonware/guis'} do
		if not isfolder(folder) then
			makefolder(folder)
		end
	end
end, errorTrace)
	if not foldersOk then
	stopExecution(console, 'filesystem.setup', foldersError, foldersError)
	return
	end
	markPistonwareBufferFilesystemReady()
	logger:addFile('pistonware/loader.log')
telemetry:addFile('pistonware/loader_telemetry.jsonl')

local releaseOk, releaseError = resolveRelease()
if not releaseOk then
	stopExecution(console, 'version.resolve', releaseError, errorTrace(releaseError))
	return
end
console:SetLine(('Loading %s (%s)...'):format(release.channel, release.version))

--[[ Step 1: hold here until ROBLOX itself is ready. Everything after this touches game state
(or hands off to main.lua, which does), so the shared.Vape* flags the injecting loadstring
sets have to be in place and the place has to be loaded before we move on.
Step 1b runs CONCURRENTLY with Step 1, not after it.

These two phases have nothing to do with each other: waiting on Roblox is pure dead time
(seconds of it when someone injects at the loading screen) and the update check is pure
network. Run in sequence, the boot paid for both. Started here, the update check happens
inside the wait it used to follow, and on a warm cache it is finished before Roblox is.

Nothing in updateCachedFiles touches game state, which is what made the old ordering
necessary in the first place -- it reads a GitHub tree and writes files into pistonware/.
Both folders and authentication are already behind us, so the security ordering is intact:
this still cannot start until a key has validated.

A reload skips the check only while the release marker still matches the resolved commit. The
first teleport or reinject after a push runs it once, so the cache it leaves behind -- and the
marker written at the end -- describe the same commit. ]]
local updateDone = isDeveloper or (isReload and release.cacheReady)
local cacheReconciled = false
if not updateDone then
	task.spawn(function()
		local updateOk, updateError = xpcall(function()
			return updateCachedFiles(function(completed, total)
				console:SetLine('Updating files ('..completed..'/'..total..')...')
				console:SetProgress(0.4 + 0.06 * (completed / math.max(total, 1)))
			end)
		end, errorTrace)
		if not updateOk then
			stopExecution(console, 'cache.update', updateError, updateError)
		elseif updateError == true then
			cacheReconciled = true
		end
		updateDone = true
	end)
else
	--[[ Skipping the update check is not the same as needing no tree. The profile-sync check in
	Step 2b calls profilesFingerprint() -> fetchRepoTree() either way, and with the update
	task never started that call is COLD -- a synchronous, unbounded api.github.com request
	made on the boot thread, while the console still reads 'Injecting into ROBLOX...' and
	nothing on screen changes for the duration. That is a stall the public build does not
	have, because there the update task has already warmed the memo by the time Step 2b runs.

	Warmed here instead, inside the game:IsLoaded wait below, so Step 2b reads a finished
	memo. Nothing joins this: fetchRepoTree parks a late caller on its own bounded join now,
	and every consumer already treats a missing tree as 'skip the check'.

	Not started on a reload -- Step 2b is skipped outright there (`not isReload`), so the
	request would be pure cost. ]]
	if not isReload then
		task.spawn(fetchRepoTree)
	end
end

--[[ Wait for the game and LocalPlayer below. ]]
do
	local playersService = cloneref(game:GetService('Players'))
	local deadline = os.clock() + 120
	repeat task.wait() until game:IsLoaded() or console:IsAborted() or os.clock() > deadline
	console:SetProgress(0.24)
	repeat task.wait() until playersService.LocalPlayer or console:IsAborted() or os.clock() > deadline
	--[[ A previous injection still holding shared.vape means the old GUI is mid-teardown;
	main.lua uninjects it, so just let the flag settle before reading the rest of them. ]]
	if shared.vape then
		task.wait(0.25)
	end
	console:SetProgress(0.4)
end
phase('waiting for ROBLOX')
if console:IsAborted() or loaderStopped then deleteInstall() return end

--[[ Join the update check before anything reads a cached .lua file. Bounded for the same reason
every other join in this file is: a stalled update must cost the update, not the boot. ]]
if not updateDone then
	console:SetLine('Checking for updates...')
	joinBatch(function() return updateDone end, 60)
	console:SetLine('')
	if console:IsAborted() or loaderStopped then deleteInstall() return end
end
phase('update check')
console:SetProgress(0.46)

--[[ Detect the very first run (empty/near-empty profiles folder) BEFORE downloading, so we
know afterwards whether to show the prompts below. ]]
local firstRunProfiles = false
pcall(function()
	firstRunProfiles = #listfiles('pistonware/profiles') < 3
end)

--[[ profilecheck.txt persists a prior 'No' on the first-run download prompt, and optout.txt
persists a prior 'No' (or 'Do not ask me again') on the sync prompt. Either file is enough:
both live on disk next to the other saved decisions, so a rejection still holds after a reload
or a rejoin. Whitespace is ignored on the way back in -- a trailing newline from writefile used
to fail the exact 'false' compare and ask again every reinject. ]]
local syncOptedOut = false
pcall(function()
	syncOptedOut = isfile('pistonware/optout.txt')
end)
local declinedDownload = false
pcall(function()
	if isfile('pistonware/profiles/profilecheck.txt') then
		declinedDownload = trim(readfile('pistonware/profiles/profilecheck.txt')) == 'false'
	end
end)
declinedDownload = declinedDownload or syncOptedOut

--[[ Step 2: offer the shipped configs. ]]
local wantsDownload = true
if firstRunProfiles and not declinedDownload then
	console:SetProgress(0.47)
	local ok, res = pcall(function()
		return console:Ask('Would you like to download the latest config?', {
			{text = 'Yes', key = true, tooltip = 'Downloads the Blatant and Legit configs from GitHub'},
			{text = 'No', key = 'no', tooltip = 'Starts on default settings and stops asking on future runs'}
		}, 60, true)
	end)
	--[[ checked before the answer is acted on, so cancelling mid-question never counts as a 'No' ]]
	if console:IsAborted() then deleteInstall() return end
	wantsDownload = ok and res == true
	--[[ Explicit No only. A timeout falls back to Yes and must not be recorded as a rejection.
	Both files, so losing one of them cannot bring the prompt back. ]]
	if ok and res == 'no' then
		declinedDownload = true
		pcall(writefile, 'pistonware/profiles/profilecheck.txt', 'false')
		pcall(writefile, 'pistonware/optout.txt', 'true')
		syncOptedOut = true
	end
end
console:SetProgress(0.53)

local downloadedConfigs = false
if firstRunProfiles and not declinedDownload and wantsDownload then
	console:SetLine('Downloading configs...')
		local synced = false
		pcall(function()
			local body = fetchProfilesListing()
			if body then
				synced = downloadProfilesListing(body, nil, function(completed, total)
					console:SetLine('Downloading configs ('..completed..'/'..total..')...')
					console:SetProgress(0.53 + 0.2 * (completed / math.max(total, 1)))
			end)
		end
	end)
		if synced then
			pcall(function()
				downloadedConfigs = #listfiles('pistonware/profiles') >= 3
			end)
		end
	--[[ Record which commit this download reflects, so later sessions can tell whether profiles/
	has changed on GitHub since (see the sync prompt below). ]]
	if downloadedConfigs then
		pcall(function()
			local commit = profilesFingerprint()
			if commit then
				writefile('pistonware/profiles/profilecommit.txt', commit)
			end
		end)
	end
end
--[[ Repeat the cleanup here: downloads already in flight when cancel fired can land after its wipe. ]]
if console:IsAborted() then deleteInstall() return end

--[[ Step 2b: existing installs (3+ profiles). If profiles/ has changed on GitHub since the last
download/sync, offer to overwrite the shipped configs with the latest ones. Only the files
that exist in the GitHub profiles folder get redownloaded -- profiles the user made
themselves are left alone. Skipped on reinjects/teleports so it only ever asks once per
session, on the first manual execution. ]]
--[[ optout.txt was read above. Its presence is the whole signal -- delete the file (and
profilecheck.txt, if that one says 'false') to be asked again. Checked before the fingerprint
fetch so an opted-out boot does not spend a request on a question it will never ask. ]]
if not firstRunProfiles and not declinedDownload and not isReload and not syncOptedOut then
	local latestCommit, cachedCommit
	pcall(function()
		latestCommit = profilesFingerprint()
		cachedCommit = isfile('pistonware/profiles/profilecommit.txt') and readfile('pistonware/profiles/profilecommit.txt'):gsub('%s', '') or nil
	end)

	--[[ Existing installs hold a 40-char git sha from the old scheme, which can never equal a
	'p1-' fingerprint. Adopt the new value silently rather than reading that mismatch as
	"profiles changed": upgrading the loader is not a reason to ask every user in the world
	to re-sync, and the prompt is the kind that gets clicked through once and distrusted
	thereafter. ]]
	if latestCommit and cachedCommit and #cachedCommit == 40 and cachedCommit:match('^%x+$') then
		pcall(writefile, 'pistonware/profiles/profilecommit.txt', latestCommit)
		cachedCommit = latestCommit
	end

	if latestCommit and latestCommit ~= cachedCommit then
		console:SetProgress(0.6)
		local ok, wantsSync = pcall(function()
			return console:Ask('Would you like to sync to the latest config?', {
				{text = 'Yes', key = true, tooltip = 'Replaces the shipped configs with the newer ones on GitHub'},
				{text = 'No', key = 'no', tooltip = 'Keeps the configs you have and does not ask again'}
			}, 60, false, {text = 'Do not ask me again', key = 'optout', tooltip = 'Keeps the configs you have and never asks again'})
		end)
		if console:IsAborted() then deleteInstall() return end
		--[[ 'no' is distinct from the timeout fallback (false), so tabbing away still asks next
		session. An answered No is saved the same way as 'Do not ask me again'. ]]
		if ok and (wantsSync == 'optout' or wantsSync == 'no') then
			pcall(writefile, 'pistonware/optout.txt', 'true')
			syncOptedOut = true
			declinedDownload = true
		end
		if ok and wantsSync == true then
			console:SetLine('Syncing configs...')

			--[[ Read BEFORE anything is overwritten. <GameId>.gui.txt holds `Profile` -- the
			config currently equipped -- and the sync rewrites that file from the repo's
			copy, whose Profile is whatever happened to be equipped when it was committed
			('blatant', in the version shipping today). mergeGuiState carries the local
			value across, but on any decode failure it falls back to writing the incoming
			file verbatim, and that fallback is exactly how someone on 'legit' or on a
			config they made themselves comes back up on 'blatant'. Re-applying the name
			below makes the equipped config survive the sync whether the merge held or not. ]]
			local lastProfile
			pcall(function()
				--[[ The live object first. vape.Profile updates the moment a profile is switched, so it
				cannot be stale under any ordering, and this is read before the Uninject below
				flushes in-memory state to disk. On a fresh execution there is no object and the
				file is the only source, which is the common case here.

				(The rewritten GUI dropped SetProfile, which the old one used to stamp the switch
				straight into gui.txt. Nothing ever called it -- only this comment named it -- so
				the behaviour here is unchanged.) ]]
				local live = shared.vape and shared.vape.Profile
				if type(live) == 'string' and live ~= '' then
					lastProfile = live
					return
				end

				local guipath = 'pistonware/profiles/'..game.GameId..'.gui.txt'
				if not isfile(guipath) then return end
				local guidata = cloneref(game:GetService('HttpService')):JSONDecode(readfile(guipath))
				if type(guidata) == 'table' and type(guidata.Profile) == 'string' and guidata.Profile ~= '' then
					lastProfile = guidata.Profile
				end
			end)

			pcall(function()
				--[[ If a previous instance is still injected, uninject it BEFORE overwriting:
				Uninject() saves the old in-memory config to disk as its first step, and
				main.lua would otherwise trigger it right after us -- clobbering the freshly
				synced profiles with the old settings. Same for its autosave loop. ]]
				if shared.vape then
					pcall(function() shared.vape:Uninject() end)
					shared.vape = nil
				end
				--[[ Listing and file contents both pinned to latestCommit so a sync run right
				after a push can't grab a stale CDN copy of the branch head.
				The tree this listing came from is itself a pinned snapshot, so its sha is what
				the file contents are fetched at -- no separate ref needed, and no window in
				which the listing and the bodies can disagree. ]]
				local body = fetchProfilesListing()
				local treeSha = repoTree and repoTree.sha
			if body and treeSha then
				local synced = downloadProfilesListing(body, treeSha, function(completed, total)
					console:SetLine('Syncing configs ('..completed..'/'..total..')...')
					console:SetProgress(0.6 + 0.13 * (completed / math.max(total, 1)))
				end)
				if synced then
					writefile('pistonware/profiles/profilecommit.txt', latestCommit)
				else
					--[[ Through the logger rather than a bare warn, so it obeys the same
					developer gate as every other line and still reaches the log file. ]]
					logger:warn('profiles.sync', 'profile sync did not complete; retrying on the next run')
				end
			end
			end)
			if console:IsAborted() then deleteInstall() return end

			--[[ Hand the equipped config back to the load that is about to happen. This covers
			a config the user made themselves and 'legit' alike -- and 'blatant' and
			'default' too, since the shipped gui.txt names one of them and a user sitting
			on either would otherwise be indistinguishable from one who got reset onto it.
			finishLoading in main.lua treats this as a one-shot and clears it, so it steers
			only the load that follows this sync and does not leak into later reinjects.
			Left nil when gui.txt was unreadable, which keeps the old behaviour of letting
			whatever ends up in gui.txt decide rather than inventing a profile here. ]]
			if lastProfile then
				shared.VapeCustomProfile = lastProfile
			end
		end
		--[[ Timeout leaves the stored commit stale, so the prompt can return next session.
		An answered No is already on disk and will not. ]]
	end
end
phase('config download/sync')
console:SetProgress(0.73)

--[[ Step 3: after the shipped configs finish downloading, ask which one should load by default
and hand it to the GUI via shared.VapeCustomProfile. main.lua's finishLoading passes this
straight into vape:Load as the profile to load, replacing the 'default' profile. The keys
match the profile file name prefixes (e.g. blatant<PlaceId>.txt) so Load can find the file. ]]
if downloadedConfigs then
	--[[ No fallback: only an explicit button click may force a config. This used to
	default to 'blatant' -- on a timeout (user tabbed away for 120s) or on the
	headless console (which answers every Ask with the fallback instantly) that
	silently stamped 'blatant' into shared.VapeCustomProfile, overriding the
	profile saved in gui.txt without the user ever choosing it. With nil the
	type(choice) guard below skips the override and the saved profile decides. ]]
	local ok, choice = pcall(function()
		return console:Ask('Which config would you like to load by default?', {
			{text = 'Blatant', key = 'blatant', tooltip = 'Makes Blatant your default config: everything on, obvious'},
			{text = 'Legit', key = 'legit', tooltip = 'Makes Legit your default config: toned down to look normal'}
		}, 120, nil)
	end)
	if console:IsAborted() then deleteInstall() return end
	if ok and type(choice) == 'string' then
		shared.VapeCustomProfile = choice
	end
end

phase('config prompt')
console:SetProgress(0.8)
console:SetLine('Loading pistonware...')
--[[ Reveals the last couple of rows while main.lua downloads and builds the GUI, so the face
is still one row short of finished when injection actually completes. ]]
local injecting = true
task.spawn(function()
	local alpha = 0.8
	while injecting and alpha < 0.93 do
		task.wait(0.6)
		--[[ injection can finish while this thread is asleep; reporting the stale alpha here
		would land after Finish() has already asked for the full face. ]]
		if not injecting then break end
		alpha += 0.02
		console:SetProgress(alpha)
	end
end)

--[[ Protected so a failure surfaces on the console line instead of leaving the window stuck on
'Loading pistonware...'; the buffer retains the diagnostic without public executor output. ]]
local ok, result = xpcall(function()
	--[[ downloadFile already compiled main.lua under this name to validate it; that chunk runs
	as it is rather than the same source being compiled again. ]]
	local source, chunk = downloadFile('pistonware/main.lua', nil, 'main')
	local compileError
	if not chunk then
		chunk, compileError = loadstring(source, 'main')
	end
	if not chunk then
		error(compileError or 'main.lua did not compile', 0)
	end
	return chunk()
end, errorTrace)
injecting = false
phase('main.lua')
stopHoldingLogs()
--[[ Consumed only now: main.lua reads the flag itself while loading (it suppresses the 'Finished
Loading' notification on a reload). Left set it would leak into the rest of the session,
since main.lua never clears it and the next teleport/reinject sets it again anyway. ]]
shared.vapereload = nil
--[[ Boot is over (successfully or not) -- reinjects and later manual runs may proceed. ]]
shared.PistonwareLoaderBoot = nil

--[[ Cancelled while the GUI was already building: tear that back down too, then wipe whatever
the run wrote after cancel's first pass. ]]
if console:IsAborted() then
	if shared.vape then
		pcall(function() shared.vape:Uninject() end)
	end
	shared.VapeCustomProfile = nil
	deleteInstall()
	return
end

if ok then
	--[[ Only a cache that already matched, or one this boot reconciled, earns the marker. Written
	after a skipped update it would vouch for files still at the previous commit. ]]
	if release.cacheReady or cacheReconciled or isDeveloper then
		persistReleaseMarker()
	end
	logger:info('loader.complete', 'injection succeeded', {
		channel = release.channel,
		version = release.version
	})
	console:Finish('Injected successfully.', 5)
	return result
end
--[[ Copied as well as printed: the message is long, full of executor paths, and the person
hitting it is usually being asked to report it. Done here rather than inside console:Fail so
a headless reload (which has no window to read) still leaves it on the clipboard. ]]
local failure = 'Injection failed: '..safeText(result, 3000)
local copied = pcall(function() setclipboard(failure) end)
stopExecution(console, 'main.load', result, result, failure..(copied and '\n\n(copied to clipboard)' or ''))
