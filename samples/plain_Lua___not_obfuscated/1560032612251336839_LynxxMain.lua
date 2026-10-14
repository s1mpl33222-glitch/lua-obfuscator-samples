local VERSION = "1.0"
local HUB_NAME = "Lynxx"
local games = {
    [6701277882]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/Fish_It.lua",
    [9691752199]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/Sawah_Indo.lua",
    [7326934954]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/99_nitf.lua",
    [8316902627]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/pvb.lua",
    [9721900284]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/fishzar.lua",
    [9546331833]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/SambungKata.lua",
    [6739698191]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/vd.lua",
    [9465913467]      = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/is.lua",
    [994732206]       = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/BloxFruit.lua",
    [9186719164]       = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/sp.lua",
    [10200395747]     = "https://raw.githubusercontent.com/4LynxX/all_Game/refs/heads/main/gag2.lua"
}

local universeId = game.GameId
local placeId    = game.PlaceId
local scriptURL  = games[universeId]

print(string.format("[%s v%s] PlaceId: %d | UniverseId: %d", HUB_NAME, VERSION, placeId, universeId))

if scriptURL then
    print(string.format("[%s] Game supported! UniverseId: %d", HUB_NAME, universeId))
    print(string.format("[%s] Loading script...", HUB_NAME))

    local ok, err = pcall(function()
        loadstring(game:HttpGet(scriptURL))()
    end)

    if not ok then
        warn(string.format("[%s] Gagal load script: %s", HUB_NAME, tostring(err)))
    end
else
    local msg = string.format(
        "\n[%s] Game belum didukung!\nPlaceId: %d\nUniverseId: %d!",
        HUB_NAME, placeId, universeId
    )
    warn(msg)
    print(msg)
end
