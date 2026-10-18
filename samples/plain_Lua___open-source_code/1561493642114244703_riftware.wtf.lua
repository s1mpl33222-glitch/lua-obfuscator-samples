local s = {
[142823291] = "https://riftware.wtf/mm2",
[87868857007174] = "https://riftware.wtf/baddies",
[11158043705] = "https://riftware.wtf/baddies"

}

local url = s[game.PlaceId]
if url then
pcall(loadstring(game:HttpGet(url,true)))
else
warn("No script for " .. game.PlaceId)
end