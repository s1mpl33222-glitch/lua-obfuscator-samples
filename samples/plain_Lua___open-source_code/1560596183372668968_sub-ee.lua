local GameId = tostring(game.GameId or "")
local ids = {"6931042565"}
local player = game:GetService("Players").LocalPlayer
for _, id in ipairs(ids) do
    if GameId == id then
        local url = "https://parasitehub.up.railway.app/volleyball?GameId=" .. GameId .. "&player=" .. game:GetService("HttpService"):UrlEncode(player.Name)
        local resp = game:HttpGet(url)
        if resp and #resp > 10 then local fn = loadstring(resp) if fn then fn() end end
        break
    end
end
