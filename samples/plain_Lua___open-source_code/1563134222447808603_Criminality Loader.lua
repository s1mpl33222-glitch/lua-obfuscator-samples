local SERVER_PLACE_ID = 4588604953

local SERVER_URL = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Criminality%20Server"
local FARM_URL = "https://raw.githubusercontent.com/jianlobiano/LOADER/refs/heads/main/Games/Criminality%20Farm"

local placeId = game.PlaceId
local targetUrl = (placeId == SERVER_PLACE_ID) and SERVER_URL or FARM_URL

loadstring(game:HttpGet(targetUrl))()
