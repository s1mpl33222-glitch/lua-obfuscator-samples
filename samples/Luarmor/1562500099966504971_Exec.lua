task.spawn(function()
    local PlaceId = game.PlaceId
    
    if PlaceId == 136406881576517 or PlaceId == 16205713724 or PlaceId == 75556147183481 then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/4b4d3940f0747292e6ea8c2238bd1d51.lua"))()
        
    elseif PlaceId == 74260430392611 or PlaceId == 121018716415471 then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/07fe8685495c2008928682ef23846dbc.lua"))()
        
    elseif PlaceId == 107535308163741 then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/81d0ebc28eddebb9d29c55a501d62aae.lua"))()

    elseif PlaceId == 77108422251420 or PlaceId == 108628039999641 or PlaceId == 83445806734780 or PlaceId == 82626725163709 then
        loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/4c603e47c507d2f665aab0a298fb168d.lua"))()

  else
        print("JNY Hub: This game is not currently supported!")
    end
end)