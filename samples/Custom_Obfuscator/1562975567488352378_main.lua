pcall(function()
    local url

    if game.PlaceId == 107778070777162 then
        url = "https://raw.githubusercontent.com/realkidhub/Games/refs/heads/main/RealKidEgg.lua"
    elseif game.GameId == 10200395747 then
        url = "https://raw.githubusercontent.com/realkidhub/Games/refs/heads/main/GaG2.lua"
    else
        url = "https://raw.githubusercontent.com/realkidhub/Games/refs/heads/main/BloxFruits.lua"
    end

    loadstring(game:HttpGet(url))()
end)
