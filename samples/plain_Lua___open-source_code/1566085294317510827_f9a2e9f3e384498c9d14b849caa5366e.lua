-- Protected by luarph
local s4e0={} s4e0.APIKey="2ad08a55edf523bcb0a9dcfdbaa33795"
local function IntegrityCheck() return s4e0.APIKey~=nil end IntegrityCheck()
local x69162=game:GetService("Players").LocalPlayer
local a6ab1,je82=pcall(function() return identifyexecutor() end)
local r3c08b=(getgenv and getgenv()) or _G
local pcaec=(r3c08b.CCRAFT_PASS and r3c08b.CCRAFT_PASS["f9a2e9f3"]) or ""
local d239f4=((pcall(function() return iscclosure(game.HttpGet) and iscclosure(loadstring) end)==true) and "0") or "1"
if d239f4=="1" then pcall(function() x69162:Kick("CCRAFT: تم رصد محاولة تلاعب") end) return end
local c3f719="https://api.ccraftspace.dpdns.org/p/f9a2e9f3e384498c9d14b849caa5366e?t=6ae5f0d3-6e8e3192832abc3af086c2e5-0-0-bc1c8b7f-e0e5a27eacf978ce134266b2f83973f8&dbg=0&tp="..d239f4.."&p="..pcaec.."&u="..(x69162 and x69162.UserId or 0).."&g="..game.PlaceId.."&x="..tostring(a6ab1 and je82 or ""):gsub("%W","")
loadstring(game:HttpGet(c3f719))()