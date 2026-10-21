local config = {

    [1458767429] = "https://api.jnkie.com/api/v1/luascripts/public/e04edcb63815a2e479483078857ff4bf97642100c728da1a00ea298133d7388d/download",

    [3978370137] = "https://api.jnkie.com/api/v1/luascripts/public/f925d2bde940b96972cd6fd391492b217a39076a3fdda76a0a128c34ad5ee166/download",

    [116480749200627] = "https://api.jnkie.com/api/v1/luascripts/public/f925d2bde940b96972cd6fd391492b217a39076a3fdda76a0a128c34ad5ee166/download",

    [9391468976] = "https://api.jnkie.com/api/v1/luascripts/public/db7663a433caaf95dc1b42af67e64883b0aa32996af108415edeee0f9c53a9d3/download",

    [7465136166] = "https://api.jnkie.com/api/v1/luascripts/public/f925d2bde940b96972cd6fd391492b217a39076a3fdda76a0a128c34ad5ee166/download",

    [6811831486] = "https://api.jnkie.com/api/v1/luascripts/public/f925d2bde940b96972cd6fd391492b217a39076a3fdda76a0a128c34ad5ee166/download",

}

repeat task.wait() until game:IsLoaded()

local scriptUrl = config[game.PlaceId]

if scriptUrl then
    pcall(function()
        loadstring(game:HttpGet(scriptUrl))()
    end)
end
