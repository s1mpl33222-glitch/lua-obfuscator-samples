local licence = ... or {}
if type(licence) ~= 'table' then licence = {} end

-- the newest execution always wins: an earlier launch stops at its next checkpoint and main.lua
-- takes down whatever instance is already loaded, working or not
local running = shared.AetherV2Loading
if type(running) == 'table' then
	running.Superseded = true
	warn('[AetherV2] replacing an earlier launch that had not finished')
	-- give it a moment to stand down, a launch that hung or died never will
	local deadline = os.clock() + 5
	while not running.Done and os.clock() < deadline do
		task.wait(0.1)
	end
end
local launch = {At = os.clock()}
shared.AetherV2Loading = launch

local cloneref = cloneref or function(object)
	return object
end
local isfile = isfile or function(file)
	local success, result = pcall(readfile, file)
	return success and result ~= nil and result ~= ''
end
local delfile = delfile or function(file)
	writefile(file, '')
end

local HttpService = cloneref(game:GetService('HttpService'))

-- One release source for every request and the identity the release is keyed on. The commit is
-- read from GitLab's API with a single small request; contents.json is only fetched when that
-- identity is not the one already on disk. A launch on a current install therefore costs one
-- request and no writes, and an update is decided by the repository's commit, never by the
-- displayed version - version.txt is an indicator for Aether Home, not an update key.
local SOURCE = 'main'
local RAW_BASE = 'https://gitlab.com/plutoxqq/AetherV2/-/raw/'..SOURCE..'/'
local COMMIT_URL = 'https://gitlab.com/api/v4/projects/plutoxqq%2FAetherV2/repository/commits/'..SOURCE
local API_BASE = 'https://gitlab.com/api/v4/projects/plutoxqq%2FAetherV2/repository/files/'
local ROOT = 'aetherv2/'
local COMMIT_PATH = ROOT..'profiles/commit.txt'
local VERSION_PATH = ROOT..'profiles/version.txt'
-- rel -> release hash of every file this loader has verified on disk. An update only has to read and
-- hash the files whose release hash changed since then, instead of re-hashing the whole ~16MB
-- install in Lua on every update. Dropped whenever the install is suspected to be damaged, so the
-- next launch falls back to a full verification.
local INDEX_PATH = ROOT..'profiles/contents.index.json'
local DOWNLOAD_BATCH = 24

local function usable(success, body)
	if not success or type(body) ~= 'string' or body == '' then
		return nil
	end
	local head = body:sub(1, 300):lower()
	if body == '404: Not Found' or head:find('^%s*404') or head:find('^%s*429') or head:find('^%s*5%d%d:')
		or head:find('^%s*too many requests') or head:find('^%s*retry later') or head:find('^%s*{"message"')
		or head:find('^%s*{"error"') or head:find('<!doctype html') or head:find('^%s*<html') then
		return nil
	end
	return body
end

local function fetch(rel)
	return usable(pcall(function()
		return game:HttpGet(RAW_BASE..rel, true)
	end))
end

local function fetchApi(rel)
	local path = rel:gsub('([^%w%-%._~])', function(character)
		return string.format('%%%02X', string.byte(character))
	end)
	return usable(pcall(function()
		return game:HttpGet(API_BASE..path..'/raw?ref='..SOURCE, true)
	end))
end

local function decodeJson(text)
	if type(text) ~= 'string' then return nil end
	local success, decoded = pcall(function()
		return HttpService:JSONDecode(text)
	end)
	return success and decoded or nil
end

local function readLocal(path)
	local success, body = pcall(readfile, path)
	if not success or type(body) ~= 'string' then
		return nil
	end
	return body
end

local function parseVersion(body)
	return (tostring(body or ''):match('version%s*=%s*([^\r\n]+)') or ''):gsub('%s+$', '')
end

local function ensureParentFolder(path)
	local parent = path:match('^(.*)/[^/]+$')
	if not parent or parent == '' then
		return
	end
	local acc = ''
	for part in string.gmatch(parent, '[^/]+') do
		acc = acc == '' and part or (acc..'/'..part)
		if not isfolder(acc) then
			pcall(makefolder, acc)
		end
	end
end

-- FNV-1a 32 folded in 16-bit halves so every step stays inside the range a double represents
-- exactly; .freebuff/gen_contents.py computes the same value over the same bytes. Newlines are
-- folded to LF first, because the release is hashed from the repository blobs and anything that
-- touches these files on the way to a client can hand back CRLF.
-- a full check hashes about 18MB, so it gives the frame back every 40ms or phones stop responding
local hashSlice = os.clock()
local function hashText(text)
	if text:find('\r', 1, true) then
		text = text:gsub('\r\n', '\n')
	end
	local hash = 2166136261
	for index = 1, #text do
		hash = bit32.bxor(hash, text:byte(index))
		local low = hash % 65536
		local high = (hash - low) / 65536
		hash = (low * 16777619 + (high * 16777619 % 65536) * 65536) % 4294967296
		if index % 16384 == 0 and os.clock() - hashSlice > 0.04 then
			task.wait()
			hashSlice = os.clock()
		end
	end
	if os.clock() - hashSlice > 0.04 then
		task.wait()
		hashSlice = os.clock()
	end
	return string.format('%08x', hash)
end

-- gitlab gives one address 500 raw requests a minute and the api another 500
local webLimited = false
local function fetchFile(rel, hash)
	local first, second = fetch, fetchApi
	if webLimited then
		first, second = fetchApi, fetch
	end
	local body = first(rel)
	if body and (not hash or hashText(body) == hash) then
		return body
	end
	body = second(rel)
	if body and (not hash or hashText(body) == hash) then
		webLimited = first == fetch
		return body
	end
	return nil
end

for _, folder in {'aetherv2', 'aetherv2/games', 'aetherv2/profiles', 'aetherv2/assets', 'aetherv2/libraries', 'aetherv2/guis'} do
	if not isfolder(folder) then
		pcall(makefolder, folder)
	end
end

-- A fresh install is one that has never recorded a commit; everything the release carries then
-- has to arrive. An existing install only pays for the files whose hash disagrees with the
-- release index, so profiles and any file the release did not touch are never rewritten.
local function syncContents(contents, forced)
	local files = contents.files
	if type(files) ~= 'table' then
		return 0, -1
	end

	local index = not forced and decodeJson(readLocal(INDEX_PATH)) or nil
	if type(index) ~= 'table' then index = {} end
	local verified = {}

	local jobs = {}
	for _, entry in ipairs(files) do
		local rel, size, hash = entry[1], entry[2], entry[3]
		if type(rel) == 'string' and type(hash) == 'string' then
			local path = ROOT..rel
			local matches
			if index[rel] == hash and isfile(path) then
				matches = true
			else
				local body = readLocal(path)
				matches = body ~= nil and hashText(body) == hash
			end
			if not matches or forced and rel == 'main.lua' then
				table.insert(jobs, {Rel = rel, Path = path, Hash = hash, Size = size})
			else
				verified[rel] = hash
			end
		end
	end

	-- what this launch runs goes first
	local function rank(rel)
		if rel == 'main.lua' then return 0 end
		if rel:find('^guis/') or rel:find('^libraries/') or rel:find('^profiles/') then return 1 end
		if rel:find('^games/universal/') then return 2 end
		if rel:find('^games/'..tostring(game.PlaceId)..'/') then return 3 end
		return rel:find('^games/') and 4 or 5
	end
	for order, job in ipairs(jobs) do
		job.Order = order
		job.Rank = rank(job.Rel)
	end
	table.sort(jobs, function(a, b)
		if a.Rank ~= b.Rank then return a.Rank < b.Rank end
		return a.Order < b.Order
	end)

	local written, failed = 0, 0
	local stale = {}
	local function download(list)
		local missed = {}
		local done, cursor = 0, 0
		while cursor < #list do
			cursor += 1
			local job = list[cursor]
			task.spawn(function()
				local body = fetchFile(job.Rel, job.Hash)
				if body then
					ensureParentFolder(job.Path)
					local ok = pcall(writefile, job.Path, body)
					if ok then
						written += 1
						verified[job.Rel] = job.Hash
						local folder = job.Rel:match('^games/([^/]+)/')
						if folder then
							stale[ROOT..'games/'..folder..'/pack.lua'] = true
						end
					else
						failed += 1
					end
				else
					table.insert(missed, job)
				end
				done += 1
			end)
			if cursor % DOWNLOAD_BATCH == 0 then
				repeat task.wait() until done >= cursor or (cursor - done) < DOWNLOAD_BATCH
			end
		end
		repeat task.wait() until done >= #list
		return missed
	end
	local missed = download(jobs)
	if #missed > 0 then
		task.wait(1)
		missed = download(missed)
	end
	for _, job in ipairs(missed) do
		failed += 1
		warn('[AetherV2] could not update '..job.Rel..' (hash mismatch or unavailable)')
	end

	-- A module changed but the release number may not have: the pack key would still match, so
	-- the stale pack is removed here rather than left to serve the module it replaced.
	for pack in stale do
		pcall(delfile, pack)
	end
	pcall(writefile, INDEX_PATH, HttpService:JSONEncode(verified))
	return written, failed
end

local function getLatestCommit()
	local success, body = pcall(function()
		return game:HttpGet(COMMIT_URL, true)
	end)
	if not success then return nil end
	local decoded = decodeJson(body)
	return decoded and (decoded.id or decoded.sha) or nil
end

local function publishFeatures()
	local body = readLocal(ROOT..'profiles/features.json')
	if body and #body > 3 then
		shared.AetherV2Features = {Ref = SOURCE, Body = body, At = os.clock()}
	end
end

local function runUpdate()
	local commit = getLatestCommit()
	local installed = (readLocal(COMMIT_PATH) or ''):gsub('%s+', '')
	local mainMissing = not isfile(ROOT..'main.lua')

	if commit and installed == commit and not mainMissing then
		shared.AetherV2Commit = commit
		publishFeatures()
		return
	end

	local contents = decodeJson(fetch('contents.json'))
	if type(contents) ~= 'table' or type(contents.files) ~= 'table' or #contents.files == 0 then
		warn('[AetherV2] release contents are unavailable; starting from the cached install')
		publishFeatures()
		return
	end

	local identity = commit or tostring(contents.rev or '')
	if identity ~= '' and installed == identity and not mainMissing then
		shared.AetherV2Commit = identity
		publishFeatures()
		return
	end

	local previousVersion = parseVersion(readLocal(VERSION_PATH))
	local written, failed = syncContents(contents, mainMissing)
	local nextVersion = tostring(contents.version or ''):gsub('%s+$', '')

	-- The commit is only remembered once every file in it is accounted for, so the pair always
	-- means "this exact release is on disk and correct" and a partial download is retried.
	if failed == 0 and identity ~= '' then
		pcall(writefile, COMMIT_PATH, identity)
	elseif failed > 0 then
		warn('[AetherV2] '..tostring(failed)..' file(s) could not be updated; will retry next launch')
	end
	if nextVersion ~= '' then
		pcall(writefile, VERSION_PATH, 'version = '..nextVersion..'\n')
	end

	shared.AetherV2Commit = identity ~= '' and identity or nil
	if written > 0 then
		shared.updated = {From = previousVersion, To = nextVersion, Files = written}
	end
	publishFeatures()
end

-- Loader state from the release-based updater that this one replaced. Nothing reads them any
-- more, and a stale stamp only confuses a debugging session.
for _, obsolete in {ROOT..'profiles/manifest.txt', ROOT..'profiles/manifest.cache.json', ROOT..'profiles/loader.txt'} do
	if isfile(obsolete) then
		pcall(delfile, obsolete)
	end
end

if not shared.VapeDeveloper then
	xpcall(runUpdate, function(err)
		warn('[AetherV2] update check failed: '..tostring(err))
	end)
else
	publishFeatures()
end

shared.AetherV2PublicRef = SOURCE

-- If the cached main.lua cannot be loaded - it is missing, truncated, or does not compile - the
-- release identity is dropped and main.lua is pulled straight from the repository. The next
-- launch then re-checks every file against the release it came from.
--
-- Only loading is retried. A runtime error used to land in the same pcall and start the whole
-- startup a second time from a fresh download - GUI, packs and all - which is how one failing
-- launch could take twice as long. A runtime failure now marks the install for a full
-- verification on the next launch and reports the error instead of repeating the startup.
local mainSource = readLocal(ROOT..'main.lua')
local mainChunk = mainSource and mainSource:find('%S') and loadstring(mainSource, 'main') or nil
if not mainChunk then
	pcall(writefile, COMMIT_PATH, 'main')
	pcall(delfile, INDEX_PATH)
	local fresh = fetchFile('main.lua')
	mainChunk = fresh and loadstring(fresh, 'main') or nil
	if not mainChunk then
		if shared.AetherV2Loading == launch then shared.AetherV2Loading = nil end
		error('[AetherV2] main.lua could not be downloaded, try again in a minute', 0)
	end
end
if launch.Superseded then
	launch.Done = true
	return
end
local ran, runError = pcall(mainChunk, licence)
launch.Done = true
if shared.AetherV2Loading == launch then shared.AetherV2Loading = nil end
if not ran then
	pcall(writefile, COMMIT_PATH, 'main')
	pcall(delfile, INDEX_PATH)
	error(runError, 0)
end
