local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local GameIds = {
    [73283852203739] = {
        Name = "EB Delta",
        URL = "https://raw.githubusercontent.com/toddynhooficial78-star/DripMenuEbDelta/refs/heads/main/SoS.txt"
    },

    [73767462197411] = {
        Name = "EB Mirage",
        URL = "https://raw.githubusercontent.com/toddynhooficial78-star/DripMenuEbDelta/refs/heads/main/Drip%20Devolution%20finality_obfuscated.lua.txt"
    }
}

local ScriptInfo = GameIds[game.GameId] or GameIds[game.PlaceId]

if not ScriptInfo then
    Player:Kick("DripMenu: jogo não autorizado.")
    return
end

local Success, Source = pcall(function()
    return game:HttpGet(ScriptInfo.URL)
end)

if not Success or type(Source) ~= "string" or Source == "" then
    warn("[DripMenu] Falha ao baixar o script:", Source)
    Player:Kick("DripMenu: falha ao carregar.")
    return
end

local CompileSuccess, Execute = pcall(function()
    return loadstring(Source)
end)

if not CompileSuccess or type(Execute) ~= "function" then
    warn("[DripMenu] Falha ao compilar:", Execute)
    Player:Kick("DripMenu: falha ao compilar.")
    return
end

print("[DripMenu] Carregando:", ScriptInfo.Name)

local RunSuccess, ErrorMessage = pcall(Execute)

if not RunSuccess then
    warn("[DripMenu] Erro de execução:", ErrorMessage)
end