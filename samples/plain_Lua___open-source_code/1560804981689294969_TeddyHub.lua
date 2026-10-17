pcall(function()
    local url = (game.PlaceId == 107778070777162) 
        and "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/StealAnEgg.lua" 
        or "https://raw.githubusercontent.com/teddyhubdev/diepvy/refs/heads/main/BloxFruits.lua"

    loadstring(game:HttpGet(url))()
end)
