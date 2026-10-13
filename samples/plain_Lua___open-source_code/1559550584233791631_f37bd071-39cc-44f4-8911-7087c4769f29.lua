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
local url="https://lux-sever-top.lovable.app/api/public/script-raw/f37bd071-39cc-44f4-8911-7087c4769f29".."?tok=b47d4e978334a0bffb1f6ffa0a2670b348978fa0eb7655f0&uid="..enc(uid).."&pid="..enc(pid).."&jid="..enc(jid).."&cid="..enc(cid)
local ok,body=pcall(function() return game:HttpGet(url) end)
if not ok or not body or #body<20 then pcall(function() lp:Kick("\n[LUX] Secure fetch failed.") end) return end
local f,err=loadstring(body,"=LUX_SECURE_STAGE")
if not f then pcall(function() lp:Kick("\n[LUX] Secure load failed.") end) return end
return f()
