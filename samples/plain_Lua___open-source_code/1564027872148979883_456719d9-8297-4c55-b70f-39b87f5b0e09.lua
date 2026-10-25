-- LUX secure runtime bootstrap
local Players=game:GetService("Players")
local lp=Players.LocalPlayer
if not lp then return end
local function enc(s)
  return tostring(s or ""):gsub("[^%w%-_%.~]",function(c) return string.format("%%%02X",string.byte(c)) end)
end
local uid=tostring(lp.UserId or 0)
local pid=tostring(game.PlaceId or "")
local jid=tostring(game.JobId or "")
local cid=""
pcall(function() cid=tostring(game:GetService("RbxAnalyticsService"):GetClientId() or "") end)
local url="https://project--9348294b-d56e-4e0e-acd2-abd3eed5b12b.lovable.app/api/public/script-raw/456719d9-8297-4c55-b70f-39b87f5b0e09".."?tok=a1e3976a8966cdd7226397777ba10017291c1d02b37e41d3&uid="..enc(uid).."&pid="..enc(pid).."&jid="..enc(jid).."&cid="..enc(cid)
local ok,body=pcall(function() return game:HttpGet(url) end)
if not ok or not body or #body<20 then pcall(function() lp:Kick("\n[LUX] Secure fetch failed.") end) return end
local f,err=loadstring(body,"=LUX_SECURE_STAGE")
if not f then pcall(function() lp:Kick("\n[LUX] Secure load failed.") end) return end
return f()
