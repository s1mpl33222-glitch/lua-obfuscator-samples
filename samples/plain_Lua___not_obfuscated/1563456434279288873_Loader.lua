local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local AllowedGameIds = {
    [135658482799046] = true,
    [86799537014206] = true,
    [98423078180065] = true
}

if not AllowedGameIds[game.PlaceId] then
    LocalPlayer:Kick("Divine Fruits Only\nJoin dsc: https://discord.gg/d2dBW8x6nd")
    return
end

loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/lekhang-123/no/refs/heads/main/wq"
))()
