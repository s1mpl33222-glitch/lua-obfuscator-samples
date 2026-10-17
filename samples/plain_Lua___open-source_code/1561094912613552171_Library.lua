-- Space Hub TDS: published as Library.lua; the large script is LibraryCore.lua.
-- Cached scripts start immediately; version checks update files for the next run.
local ROOT = "SpaceHub/Games/TDS/Temp"
local BASE = "https://f.spacehub.wtf/TDS/"
local VERSION_URL = BASE .. "Versions.json"
local VERSION_FILE = ROOT .. "/Versions.json"
local LIBRARY_URL = BASE .. "LibraryCore.lua"
local CACHED_FILES = {
    ["LibraryCore.lua"] = true,
    ["Sources/UI.lua"] = true,
    ["Sources/Icons.lua"] = true,
}
local environment = (type(getgenv) == "function" and getgenv()) or _G
local http = game:GetService("HttpService")
local supportsFiles = type(isfile) == "function" and type(readfile) == "function"
    and type(writefile) == "function" and type(makefolder) == "function"
local updating = {}
local freshlyDownloaded = {}
local startupManifest

-- Recorder is no longer cached. Remove only its old cache file, if present.
if type(isfile) == "function" and type(delfile) == "function" then
    local staleRecorder = ROOT .. "/Sources/Recorder.lua"
    local checked, exists = pcall(isfile, staleRecorder)
    if checked and exists then
        local removed, removeError = pcall(delfile, staleRecorder)
        if not removed then
            warn("[Space Hub] Could not remove old Recorder cache: " .. tostring(removeError))
        end
    end
end

local function readJson(path)
    if not supportsFiles or not isfile(path) then return {} end
    local ok, value = pcall(function() return http:JSONDecode(readfile(path)) end)
    return ok and type(value) == "table" and value or {}
end

local knownVersions = readJson(VERSION_FILE)

local function cachePath(url)
    if type(url) ~= "string" or url:sub(1, #BASE) ~= BASE then return nil, nil end
    local relative = url:sub(#BASE + 1):match("^[^?]+")
    if not relative or not CACHED_FILES[relative] or relative:find("%.%.", 1, false)
        or relative:find("\\", 1, true) or relative:sub(1, 1) == "/" then
        return nil, nil
    end
    return ROOT .. "/" .. (relative == "LibraryCore.lua" and "Library.lua" or relative), relative
end

local function ensureFolder(path)
    local directory = path:match("^(.*)/[^/]+$")
    if not directory then return end
    local current = ""
    for part in directory:gmatch("[^/]+") do
        current = current == "" and part or (current .. "/" .. part)
        if type(isfolder) ~= "function" or not isfolder(current) then
            pcall(makefolder, current)
        end
    end
end

local function validSource(source)
    if type(source) ~= "string" or source == "" then return false, "Empty source" end
    local chunk, compileError = loadstring(source)
    return type(chunk) == "function", compileError, chunk
end

local function fetchRemote(url)
    local ok, source = pcall(function() return game:HttpGet(url, true) end)
    if ok then
        local valid, compileError, chunk = validSource(source)
        if valid then return source, chunk end
        error("Space Hub script could not compile: " .. tostring(url) .. " (" .. tostring(compileError) .. ")", 2)
    end
    error("Space Hub download failed: " .. tostring(url) .. " (" .. tostring(source) .. ")", 2)
end

local function fetchSource(url, withChunk)
    local path, relative = cachePath(url)
    if not path or not supportsFiles then
        local source, chunk = fetchRemote(url)
        if withChunk then return source, chunk end
        return source
    end
    local latestVersion = startupManifest and startupManifest.files and startupManifest.files[relative]
    if isfile(path) and type(latestVersion) == "string" and knownVersions[relative] ~= latestVersion then
        local source, chunk = fetchRemote(url .. "?v=" .. latestVersion)
        local saved, saveError = pcall(function() writefile(path, source) end)
        assert(saved, "Space Hub cache update failed: " .. tostring(relative) .. " (" .. tostring(saveError) .. ")")
        freshlyDownloaded[relative] = true
        if withChunk then return source, chunk end
        return source
    end
    if isfile(path) then
        local ok, source = pcall(readfile, path)
        if ok then
            local valid, _, chunk = validSource(source)
            if valid then
                if withChunk then return source, chunk end
                return source
            end
        end
    end
    local source, chunk = fetchRemote(url)
    local saved, saveError = pcall(function()
        ensureFolder(path)
        writefile(path, source)
    end)
    if saved then
        freshlyDownloaded[relative] = true
    else
        warn("[Space Hub] Could not cache " .. relative .. ": " .. tostring(saveError))
    end
    if withChunk then return source, chunk end
    return source
end

environment.SpaceHubFetchSource = fetchSource

local chunk
local corePath = cachePath(LIBRARY_URL)
if supportsFiles and corePath and isfile(corePath) then
    -- A stale Core can hang before the background updater gets a chance to run.
    -- Check only its small version manifest before executing the cached script.
    local responseOk, response = pcall(function() return game:HttpGet(VERSION_URL, true) end)
    if responseOk and type(response) == "string" then
        local decodedOk, decoded = pcall(function() return http:JSONDecode(response) end)
        if decodedOk and type(decoded) == "table" and type(decoded.files) == "table" then
            startupManifest = decoded
            local latestVersion = decoded.files["LibraryCore.lua"]
            if type(latestVersion) == "string" and knownVersions["LibraryCore.lua"] ~= latestVersion then
                local replacement, compiled = fetchRemote(LIBRARY_URL .. "?v=" .. latestVersion)
                local saved, saveError = pcall(function()
                    ensureFolder(corePath)
                    writefile(corePath, replacement)
                end)
                assert(saved, "Space Hub Core cache update failed: " .. tostring(saveError))
                freshlyDownloaded["LibraryCore.lua"] = true
                chunk = compiled
            end
        end
    end
end

if not chunk then
    local _, cachedChunk = fetchSource(LIBRARY_URL, true)
    chunk = cachedChunk
end

-- Finish updating any other cached modules and persist the new version list.
if supportsFiles then
    task.spawn(function()
        local manifest = startupManifest
        if not manifest then
            local ok, response = pcall(function() return game:HttpGet(VERSION_URL, true) end)
            if not ok or type(response) ~= "string" then return end
            local decodedOk, decoded = pcall(function() return http:JSONDecode(response) end)
            if not decodedOk then return end
            manifest = decoded
        end
        if type(manifest) ~= "table" or type(manifest.files) ~= "table" then return end
        local nextVersions = {}
        for relative, version in pairs(manifest.files) do
            if type(relative) == "string" and CACHED_FILES[relative] and type(version) == "string" then
                local path = cachePath(BASE .. relative)
                if path and freshlyDownloaded[relative] then
                    nextVersions[relative] = version
                elseif path and isfile(path) and knownVersions[relative] == version then
                    nextVersions[relative] = version
                elseif path and isfile(path) and knownVersions[relative] ~= version and not updating[relative] then
                    updating[relative] = true
                    local success, replacement = pcall(fetchRemote, BASE .. relative .. "?v=" .. version)
                    if success then
                        local saved = pcall(function()
                            ensureFolder(path)
                            writefile(path, replacement)
                        end)
                        if saved then nextVersions[relative] = version end
                    end
                    updating[relative] = nil
                end
            end
        end
        pcall(function()
            ensureFolder(VERSION_FILE)
            writefile(VERSION_FILE, http:JSONEncode(nextVersions))
        end)
    end)
end

local library = chunk()
if type(library) ~= "table" or type(library.Loadout) ~= "function" then
    library = environment.SpaceHubTDS or shared.TDSTable
end
assert(type(library) == "table" and type(library.Loadout) == "function", "Space Hub library did not provide TDS:Loadout")
return library
