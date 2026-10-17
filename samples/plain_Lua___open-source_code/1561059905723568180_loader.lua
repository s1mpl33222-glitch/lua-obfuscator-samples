if game.GameId == 537413528 then
    pcall(function()
        loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))(
            "proj_dfd29687f3f5",
            "1.0.0",
            false
        )
    end)

    loadstring(game:HttpGet("https://luau.pro/api/babft/launcher"))()

elseif game.GameId == 109397169461300 or game.GameId == 7264587281 then
    loadstring(game:HttpGet("https://luau.pro/api/duels/launcher"))()
end