local Players = game:GetService("Players")
local player = Players.LocalPlayer
local placeId = game.PlaceId

-- Game IDs were matched to Roblox experience pages.
-- URLs point to scripts present in noicyreal/bracehub on the main branch.
local base = "https://raw.githubusercontent.com/noicyreal/bracehub/main/"

local scripts = {
    -- BloxStrike
    [114234929420007] = base .. "bloxstrike.luau",
    -- Kontra
    [87204735676240] = base .. "kontra.luau",
    -- Counter Blox
    [301549746] = base .. "counter.luau",
    -- Operation One
    [72920620366355] = base .. "one.luau",
    -- Blade Ball
    [13772394625] = base .. "blade.luau",
    -- RoChess!
    [139717576471404] = base .. "rochess.luau",
    -- Guess the Song! 0.5s
    [131683977882464] = base .. "song.luau",
    -- Jailbird
    [14772802900] = base .. "jailbird.luau",
    -- Defusal (the FPS game)
    [79393329652220] = base .. "defusal.luau",
    -- TTK Testing (MARKED)
    [120189115846709] = base .. "ttk.luau",
    -- Riotfall
    [7796842481] = base .. "riotfall.luau",
    -- War Ground (MARKED) - existing ID preserved; game title not independently verified
    [76822114837453] = base .. "war.luau",
    -- Ground War (Stealth Developers) - separately verified experience
    [118367369949006] = base .. "war.luau",
    -- Chameleon
    [110808833601416] = base .. "cham.lua",
    -- Frontlines
    [5938036553] = base .. "frontlines.luau",
    -- Global Anarchy
    [132640332499066] = base .. "anarchy.luau",
    -- Super Hero Tycoon
    [574407221] = base .. "superherotycoon.lua",
    -- Stop the Timer
    [139988436996662] = base .. "stopthetimer.lua",
    -- Guess the Country
    [129870876180628] = base .. "guess.lua",
    -- Existing Brace game, preserved
    [17738127017] = base .. "brace.lua",
    -- Murderers VS Sheriffs Duels (MVS Duels Community)
    [135856908115931] = base .. "duels.luau",
    -- 8 Ball Duels
    [116921506811323] = base .. "8ball.luau",
    -- CHESS! (Cookie development)
    [6222531507] = base .. "chess.luau",
    -- REALISTIC HOME DEFENSE (IBA Community)
    [105527962898452] = base .. "home.luau",
}

local url = scripts[placeId]

if not url then
    player:Kick("Game not supported.")
    return
end

local source = game:HttpGet(url)
local func, loadError = loadstring(source)

if not func then
    warn("Could not load script:", loadError)
    return
end

local success, runError = xpcall(func, function(err)
    return debug.traceback(err)
end)

if not success then
    warn("Loaded script crashed:")
    warn(runError)
end
