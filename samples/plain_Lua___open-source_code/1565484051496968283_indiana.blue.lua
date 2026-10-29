local gameId = game.GameId

local deadline = {
    [4283416256] = true,
    [109603888803276] = true,
    [119426593006199] = true,
    [12144402492] = true,
}

local town = {
    [1718755273] = true,
    [2500999591] = true,
}

if deadline[gameId] then
    loadstring(game:HttpGet("https://luaprot.net/api/v3/loaders/get/11940581408208042664"))()
elseif town[gameId] then
    loadstring(game:HttpGet("https://luaprot.net/api/v3/loaders/get/14682458563288934707"))()
else
    game.Players.LocalPlayer:Kick("unsupported game")
end