if (getgenv().UC_LOADED) then
    return;
end;
getgenv().UC_LOADED = true;
if (game.GameId == 1008451066) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/ff0850aeaef1c7f649d5bd3acf995976.lua" ))()
end;
if (game.GameId == 6035872082) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/820752256ceb15cff17a05fd607aaf8b.lua"))()
end;
if (game.PlaceId == 155615604) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/4e79dc4ab9adddae25279dc271aa9e97.lua" ))()
end;
if (game.PlaceId == 114234929420007) then
    loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/27a3877e7273ed8c9cf12d2bd25c0e11.lua" ))()
end;
loadstring(game:HttpGet("https://api.luarmor.net/files/v4/loaders/5e0225ad1ab8668fb102acc2a4e64bc9.lua"))()
