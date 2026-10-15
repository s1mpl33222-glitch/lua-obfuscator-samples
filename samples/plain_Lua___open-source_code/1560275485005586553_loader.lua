local FREE_GAMES = {
    "136431686349723",
    "102181577519757",
    "125591428878906",
    "95211388186571",
    "102629288441708",
    "129556108844772",
    "91086002169354",
    "142823291",
    "11379739543",
    "98752102030179",
    "18794863104",
    "4580204640",
    "124216119978534",
    "12355337193",
}

local PREMIUM_GAMES = {
    "107778070777162",
}

local FREE_URL = "https://api.jnkie.com/api/v1/luascripts/public/ab6550b8cf245b7c2fd25c0deb6f36d94ecfc76a95981895ef0ad986e769991b/download"
local PREMIUM_URL = "https://api.jnkie.com/api/v1/luascripts/public/0d238f4924f920cc2005ecc2708bdf3c0af4e7f2620549ee0ccc086258570786/download"

local PlaceId = tostring(game.PlaceId)

local function contains(list, value)
    for _, id in ipairs(list) do
        if id == value then
            return true
        end
    end
    return false
end

if contains(PREMIUM_GAMES, PlaceId) then
    loadstring(game:HttpGet(PREMIUM_URL))()
    return
end

if contains(FREE_GAMES, PlaceId) then
    loadstring(game:HttpGet(FREE_URL))()
    return
end

warn("Unsupported game: " .. PlaceId)
