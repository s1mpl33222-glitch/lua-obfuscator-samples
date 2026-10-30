-- Runtime loader.
-- This file contains no keys, tokens, or protected source.

local environment = (getgenv and getgenv()) or _G
if environment.__RUNTIME_LOADER then
    return
end
environment.__RUNTIME_LOADER = "loading"

local DEFAULT_MANIFEST_URL = "https://raw.githubusercontent.com/Exanety/load/main/manifest.json"
local manifestUrl = environment.BlipwareManifestUrl or DEFAULT_MANIFEST_URL

local function fail(message)
    environment.__RUNTIME_LOADER = nil
    error("Loader: " .. tostring(message), 0)
end

local function download(url)
    local ok, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if not ok or type(result) ~= "string" or result == "" then
        fail("failed to download " .. tostring(url))
    end
    return result
end

local httpService = game:GetService("HttpService")
local manifestText = download(manifestUrl)
local manifestOk, manifest = pcall(function()
    return httpService:JSONDecode(manifestText)
end)
if not manifestOk or type(manifest) ~= "table" then
    fail("manifest.json is invalid")
end

if manifest.status ~= "online" then
    fail(manifest.message or "the script is currently offline")
end

if type(manifest.payload) ~= "string" or manifest.payload == "" then
    fail("manifest.json has no payload path")
end

local repositoryBase = manifestUrl:match("^(.*)/[^/]+$")
if not repositoryBase then
    fail("manifest URL has no repository base")
end
environment.BlipwareRepositoryBase = repositoryBase

local payloadUrl = manifest.payload:match("^https?://")
    and manifest.payload
    or (repositoryBase .. "/" .. manifest.payload:gsub("^/+", ""))
local payload = download(payloadUrl)
local chunk, compileError = loadstring(payload, "@runtime.lua")
if not chunk then
    fail("payload failed to compile: " .. tostring(compileError))
end

local runOk, runError = xpcall(chunk, function(message)
    return debug and debug.traceback and debug.traceback(tostring(message), 2) or tostring(message)
end)
if not runOk then
    fail(runError)
end

environment.__RUNTIME_LOADER = "loaded"
