local HttpService = game:GetService("HttpService")
local env = getgenv()
local api = "https://api.honeylua.com"

local games = {
    [66654135] = "murder-mystery-2",
    [142823291] = "murder-mystery-2",
    [920587237] = "adopt-me",
    [7326934954] = "99-nights-in-the-forest",
    [126509999114328] = "99-nights-in-the-forest",
    [79546208627805] = "99-nights-in-the-forest",
    [10200395747] = "gag2",
    [77085202503540] = "gag2",
}

local scriptId = games[game.GameId] or games[game.PlaceId]
if not scriptId then
    local url = string.format(
        "%s/bootstrap-info?universeId=%s&placeId=%s",
        api,
        HttpService:UrlEncode(tostring(game.GameId)),
        HttpService:UrlEncode(tostring(game.PlaceId))
    )

    scriptId = HttpService:JSONDecode(game:HttpGet(url)).scriptId
end

if not scriptId or scriptId == "" then return end

env.HoneyLuaScriptId = scriptId
env.HoneyLuaScriptVersion = "1.0.0"

loadstring(game:HttpGet(api .. "/bootstrap-source"))()
