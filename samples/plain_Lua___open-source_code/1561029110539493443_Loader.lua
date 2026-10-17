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

local _, chunk = fetchSource(LIBRARY_URL, true)

-- Do not delay startup for a version request. A newly downloaded version is used next time.
if supportsFiles then
    task.spawn(function()
        local ok, response = pcall(function() return game:HttpGet(VERSION_URL, true) end)
        if not ok or type(response) ~= "string" then return end
        local decodedOk, manifest = pcall(function() return http:JSONDecode(response) end)
        if not decodedOk or type(manifest) ~= "table" or type(manifest.files) ~= "table" then return end
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

return chunk()
