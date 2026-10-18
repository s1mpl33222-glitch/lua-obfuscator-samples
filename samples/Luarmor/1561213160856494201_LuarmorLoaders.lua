-- > [PlaceID] = Loader (in case you are curious 😉)

local Pokemon_Bronze_Forever = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/fd89e4002a0b531f6dd589be25c49ad8.lua"))
local Pokemon_Roria_Conquest = loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/93e5e925aca904d0fe0a91a076ae3527.lua"))

return {

--// Place Ids (1st checking)
["90966513484611"] = Pokemon_Bronze_Forever,
["75534240725899"] = Pokemon_Roria_Conquest,

--// Place Names (2nd checking)
["Pokemon Roria Conquest"] = Pokemon_Roria_Conquest,
["Pokemon Bronze Forever"] = Pokemon_Bronze_Forever,
}
