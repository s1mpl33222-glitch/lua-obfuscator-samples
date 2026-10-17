local environment = getgenv()
local currentJob = tostring(game.JobId or "")
local existingStart = environment.__CokeboysPublicLoaderStart
if type(existingStart) == "table"
    and existingStart.JobId == currentJob
    and os.clock() - (tonumber(existingStart.StartedAt) or 0) < 120 then
    warn("Cokeboys: the loader is already starting. Please wait.")
    return
end

local existingController = environment.__CokeboysLoaderController
local controllerIsCurrent = type(existingController) == "table"
    and existingController.disposed ~= true
    and existingController.ownsLaunch == true
    and os.clock() - (tonumber(existingController.updatedAt) or 0) < 120
if environment.CokeboysScriptLoaded == true
    or controllerIsCurrent then
    if controllerIsCurrent and type(existingController.focus) == "function" then
        pcall(existingController.focus, existingController)
    end
    warn("Cokeboys: the loader is already open.")
    return
end

local pendingStart = environment.__CokeboysLuaProtPendingStart
if type(pendingStart) == "table" and pendingStart.JobId == currentJob then
    warn("Cokeboys: LuaProt is already starting. Please wait.")
    return
end

local startOwnership = {
    JobId = currentJob,
    StartedAt = os.clock(),
}
environment.__CokeboysPublicLoaderStart = startOwnership
local function releaseStartOwnership()
    if environment.__CokeboysPublicLoaderStart == startOwnership then
        environment.__CokeboysPublicLoaderStart = nil
    end
end

local url = "https://cokeboys-luaprot-pilot.cokeboysclient.workers.dev/testers/experimental.lua"
local downloaded, source = pcall(function() return game:HttpGet(url, true) end)
if not downloaded or type(source) ~= "string" or #source == 0 or #source > 1048576 then
    releaseStartOwnership()
    warn("Cokeboys: unable to download the loader. Please try again shortly.")
    return
end
local compiled, entry = pcall(loadstring, source)
if not compiled or type(entry) ~= "function" then
    releaseStartOwnership()
    warn("Cokeboys: loader unavailable. Please try again shortly.")
    return
end
local entered, entryError = pcall(entry)
releaseStartOwnership()
if not entered then
    error(entryError, 0)
end
