--[[
  ____               _              _     ____   _                _    
 |  _ \  _ __  ___  (_)  ___   ___ | |_  / ___| | |_  __ _  _ __ | | __
 | |_) || '__|/ _ \ | | / _ \ / __|| __| \___ \ | __|/ _` || '__|| |/ /
 |  __/ | |  | (_) || ||  __/| (__ | |_   ___) || |_| (_| || |   |   <
 |_|    |_|   \___/_/ | \___| \___| \__| |____/  \__|\__,_||_|   |_|\_\
                  |__/                                                                               ]]
-- Project Stark bootstrap.
-- Everything here stays in memory: the version map picks the current
-- content-addressed (edge-cached) loader + UI lib URLs, the UI libs are
-- prefetched in parallel with the loader download, and nothing is written
-- to disk. The loader owns all key/session/attest gating.
local bases = { "https://urbanstorm.uk", "https://api.hyxx.win" }

local function fetch(url)
	local ok, res = pcall(function()
		return game:HttpGet(url, true)
	end)
	if not ok or type(res) ~= "string" or #res == 0 then
		ok, res = pcall(function()
			return game:HttpGet(url)
		end)
	end
	if ok and type(res) == "string" and #res > 0 then
		return res
	end
	return nil
end

-- Tiny version map (never cached): artifact content hashes.
local versions
for _, base in ipairs(bases) do
	local res = fetch(base .. "/api/hub/versions")
	if res and res:sub(1, 1) == "{" then
		versions = res
		break
	end
end

local loaderHash, keyuiHash, uiHash
if versions then
	pcall(function()
		local data = game:GetService("HttpService"):JSONDecode(versions)
		local arts = data and data.artifacts
		if type(arts) == "table" then
			loaderHash = arts.loader and arts.loader.h
			keyuiHash = arts.keyui and arts.keyui.h
			uiHash = arts.ui and arts.ui.h
		end
	end)
end

-- Prefetch both UI libraries in parallel with the loader download. This is a
-- same-process memory handoff the loader/scripts consume; it is never saved.
_G.ProjectStarkPrefetch = {
	keyui = nil,
	ui = nil,
	keyuiHash = keyuiHash,
	uiHash = uiHash,
}

local function prefetch(name, hash, field)
	if type(hash) ~= "string" or #hash < 8 then
		return
	end
	task.spawn(function()
		for _, base in ipairs(bases) do
			local res = fetch(base .. "/api/hub/a/" .. name .. "/" .. hash .. ".js")
			if res and #res > 1000 then
				_G.ProjectStarkPrefetch[field] = res
				return
			end
		end
	end)
end

prefetch("keyui", keyuiHash, "keyui")
prefetch("ui", uiHash, "ui")

-- The loader itself: content-addressed (Cloudflare edge cached) when we know
-- the hash, plain endpoint as the fallback.
local source
if type(loaderHash) == "string" and #loaderHash >= 8 then
	for _, base in ipairs(bases) do
		local ok, res = pcall(function()
			return game:HttpGet(base .. "/api/hub/a/loader/" .. loaderHash .. ".js", true)
		end)
		if ok and type(res) == "string" and #res > 1000 then
			source = res
			break
		end
	end
end
if not source then
	for _, base in ipairs(bases) do
		source = fetch(base .. "/api/loader")
		if source then
			break
		end
	end
end

if not source then
	error("Project Stark: could not reach the loader. Check your connection and rejoin.")
end

return loadstring(source)()
