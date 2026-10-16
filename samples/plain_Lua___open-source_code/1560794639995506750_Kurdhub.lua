local p = game.PlaceId
local url

if p == 109983668079237 or p == 96342491571673 or p == 128762245270197 or p == 99606176102979 or p == 1028202939 or p == 123923334828954 then
    url = "https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/kurdhub2"
else
    url = "https://raw.githubusercontent.com/Ninja10908/S4/refs/heads/main/kurdhub1"
end

local content = game:HttpGet(url)
local fn = loadstring(content)
if fn then
    fn()
end
