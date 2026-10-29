if not (getgenv or identifyexecutor or getexecutorname) then return end
local g=(getgenv and getgenv()) or _G
local k=tostring(g.script_key or script_key or "")
local h="unknown"
pcall(function() h=game:GetService("RbxAnalyticsService"):GetClientId() end)
local H=game:GetService("HttpService")
local u="https://bleedland.lovable.app/api/public/run/ff4da0c4-c353-447c-b1e5-8aedd9f0fbb4?key="..H:UrlEncode(k).."&hwid="..H:UrlEncode(h)
local ok,r=pcall(function() return game:HttpGet(u) end)
if not ok then warn("[Loader] could not reach server") return end
local f,e=loadstring(r)
if f then f() else warn("[Loader] "..tostring(e)) end