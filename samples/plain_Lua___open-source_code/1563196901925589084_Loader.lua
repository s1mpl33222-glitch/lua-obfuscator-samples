local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

local lp = game.Players.LocalPlayer
local PlaceId = game.PlaceId
local exec = identifyexecutor()

if exec == "Xeno" or exec == "Solara" then
    lp:Kick(exec .. " not supported")
end

local Games = {
    {
        Name = "Ultimate Battleground",
        PlaceIds = {
            11815767793,
            101993432229107,
        },
        Script = "https://lua-guard.xyz/api/raw/66d8d3f046a93ff0adb1bb3543a7c290"
    },

    {
        Name = "Hood Rivals",
        PlaceIds = {
            77463332823746,
            113272123504853,
        },
        Script = "https://lua-guard.xyz/api/raw/6760af93f23d19de3b385dc7a433195e"
    },

    {
        Name = "RIVALS",
        PlaceIds = {
            17625359962, -- Hub
            18126510175, -- Mobile
            117398147513099, -- Matchmaking / Duels / Ranked / LTM
            71874690745115, -- Team Deathmatch
            129604661913557, -- Free For All
            133215910299950, -- Gun Game
        },
        Script = "https://lua-guard.xyz/api/raw/189949d1c8a11f40d13f0afa9e3d88da"
    }
}

local function findGame()
    for _, gameData in ipairs(Games) do
        if table.find(gameData.PlaceIds, PlaceId) then
            return gameData
        end
    end

    return nil
end

local gameData = findGame()

if gameData then
    Library:Notify("loading...", 5)
    loadstring(game:HttpGet(gameData.Script))()
else
    Library:Notify("Game not supported", 2)
end