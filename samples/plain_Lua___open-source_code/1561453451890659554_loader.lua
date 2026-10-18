--// ZHM Universal Loader - Fixed
--// Uses string IDs for reliable matching across executors

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Scripts = {
    ["135762233659303"] = "https://raw.githubusercontent.com/ejerzhome25/ZHM2/main/tinapay.lua",
    ["76761322556241"]  = "https://raw.githubusercontent.com/ejerzhome25/ZHM2/main/ukayukay.lua",
    ["76943966208523"]  = "https://raw.githubusercontent.com/ejerzhome25/ZHM2/main/clonestealegg.lua",
    ["114326934417838"] = "https://raw.githubusercontent.com/ejerzhome25/ZHM2/main/break%20egg",
    ["109475655864288"] = "https://raw.githubusercontent.com/ejerzhome25/ZHM2/main/SUKI",
    ["90920025162454"] = "https://raw.githubusercontent.com/ejerzhome25/ZHM2/main/RollAFisherman_VNDT_Nebula.lua",
}

local GameId = tostring(game.GameId)
local PlaceId = tostring(game.PlaceId)

print("[ZHM Loader] GameId:", GameId)
print("[ZHM Loader] PlaceId:", PlaceId)

local ScriptURL = Scripts[PlaceId] or Scripts[GameId]

if not ScriptURL then
    warn("[ZHM Loader] Game not supported.")
    warn("[ZHM Loader] GameId:", GameId)
    warn("[ZHM Loader] PlaceId:", PlaceId)
    return
end

print("[ZHM Loader] Match found:", ScriptURL)

local success, sourceOrError = pcall(function()
    return game:HttpGet(ScriptURL, true)
end)

if not success then
    warn("[ZHM Loader] Failed to download script:")
    warn(sourceOrError)
    return
end

local chunk, compileError = loadstring(sourceOrError)

if not chunk then
    warn("[ZHM Loader] Failed to compile script:")
    warn(compileError)
    return
end

local runSuccess, runError = pcall(chunk)

if runSuccess then
    print("[ZHM Loader] Script loaded successfully.")
else
    warn("[ZHM Loader] Script runtime error:")
    warn(runError)
end
