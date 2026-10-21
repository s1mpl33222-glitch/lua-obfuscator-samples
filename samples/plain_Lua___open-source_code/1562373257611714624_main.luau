--!nocheck

local Suc, Err = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/sigma-ware/hub/refs/heads/main/" .. game.GameId .. "/loader.luau"))()
end)

if not Suc then
    warn("Erm no loader? :: ", Err)
end