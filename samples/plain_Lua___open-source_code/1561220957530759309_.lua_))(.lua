local Scripts = {
    [6765805766] = {
        Name = "Block Spin",
        Load = function()
           loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/397b62fded2dc221325ed31cc6906a35baab4cda5b17d57b9dc8fd22f5026a40/download"))()
        end
    },
}

local godzila = Scripts[game.GameId]

if not godzila then
    game.Players.LocalPlayer:Kick("Game not supported")
    return
end

print("Loaded for " .. godzila.Name)

pcall(function()
    godzila.Load()
end)
