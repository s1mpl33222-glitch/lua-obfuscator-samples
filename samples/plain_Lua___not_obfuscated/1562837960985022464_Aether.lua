local configs = {
    [107778070777162] = {
        urls = {
            "https://flowauth.net/v1/loaders/a688aad4afa2161a7c80b2d2a9284e55.lua",
        },
    },

    [114326934417838] = {
        urls = {
            "https://flowauth.net/v1/loaders/fcd18281b399e3bbee72687c99c96aff.lua",
        },
    },
}

local config = configs[game.PlaceId]

if not config then
    game.Players.LocalPlayer:Kick("❌ Not Supported Game!\nPlaceId: " .. game.PlaceId)
    return
end

for _, url in ipairs(config.urls) do
    loadstring(game:HttpGet(url))()
end

repeat task.wait(0.5) until shared.TDSTable
return shared.TDSTable
