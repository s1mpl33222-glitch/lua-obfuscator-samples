local H=game:GetService("HttpService")
local G=(getgenv and getgenv()) or _G
local k=tostring(G.script_key or script_key or "")
local hw="?" pcall(function() hw=(gethwid and gethwid()) or game:GetService("RbxAnalyticsService"):GetClientId() end)
local pl="?" pcall(function() pl=game:GetService("Players").LocalPlayer.Name end)
local uid=tostring(game:GetService("Players").LocalPlayer.UserId)
local gid=tostring(game.PlaceId)
local ex="?" pcall(function() ex=(identifyexecutor and identifyexecutor()) or "?" end)
local e=function(s) return H:UrlEncode(tostring(s)) end
loadstring(game:HttpGet("https://freescriptrivals.lovable.app/api/public/run/fa15b1523532?key="..e(k).."&hwid="..e(hw).."&player="..e(pl).."&exec="..e(ex).."&user_id="..e(uid).."&game_id="..e(gid)))()