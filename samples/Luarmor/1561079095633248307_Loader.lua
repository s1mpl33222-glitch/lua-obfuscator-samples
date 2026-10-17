if _G.exec then return end
_G.exec = true

local id = game.PlaceId
local raw

function Add() pcall(function() (request or http_request or (syn and syn.request))({Url="https://api.counterapi.dev/v2/lkz/lkz-hub/up",Method="GET"}) end) end

if id == 126509999114328 then  
    raw = "https://raw.githubusercontent.com/LucasggkX/Games/refs/heads/main/99%20Nights.lua"
elseif id == 109983668079237 or id == 128762245270197 or id == 96342491571673 or id == 85621847059032 or id == 99606176102979 or id == 99392882090073 or id == 123923334828954 then  
    raw = "https://api.luarmor.net/files/v4/loaders/66705d62b53668c135171165c745016a.lua"
elseif id == 127742093697776 then
    raw = "https://raw.githubusercontent.com/LucasggkX/Games/refs/heads/main/Plant%20vs.lua"
elseif id == 537413528 then
    raw = "https://raw.githubusercontent.com/LucasggkX/Games/refs/heads/main/Build%20a%20Boat.lua"
elseif id == 3101667897 then
    raw = "https://raw.githubusercontent.com/LucasggkX/Games/refs/heads/main/Legends%20of%20speed.lua"
elseif id == 107778070777162 then
    raw = "https://api.luarmor.net/files/v4/loaders/65bf3459d87ba3ac46350e154b640929.lua"
else
    return 
end

Add()
loadstring(game:HttpGet(raw))()
