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
local url="https://lux-sever-top.lovable.app/api/public/script-raw/3125eb0d-9656-4668-9ab1-50f053473fae".."?tok=c52fe95957c4f65a13a9122fdbec60fe85ad4b34697b44e6&uid="..enc(uid).."&pid="..enc(pid).."&jid="..enc(jid).."&cid="..enc(cid)
local ok,body=pcall(function() return game:HttpGet(url) end)
if not ok or not body or #body<20 then pcall(function() lp:Kick("\n[LUX] Secure fetch failed.") end) return end
local f,err=loadstring(body,"=LUX_SECURE_STAGE")
if not f then pcall(function() lp:Kick("\n[LUX] Secure load failed.") end) return end
return f()
