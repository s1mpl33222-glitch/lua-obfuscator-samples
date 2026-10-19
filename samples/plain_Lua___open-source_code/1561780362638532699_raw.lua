-- sodium loader
local _e6d2c5a1a0='sodiumh'..'ub_main'
local _d7a0b8b6d5='05aaf088f80e966d.1792427855.7ae9c5ca4102692933c433a4b17cba4b96bfc927f7dc03ccc20087f4c76880c3'
local _c9d5b6d4b2=function()
 if type(gethwid)=='function' then
  local _a9d9c9c5b8,_b2a3c3e8c1=pcall(gethwid)
  if _a9d9c9c5b8 and type(_b2a3c3e8c1)=='string' and #_b2a3c3e8c1>0 then return _b2a3c3e8c1 end
  if _a9d9c9c5b8 and _b2a3c3e8c1~=nil then local _ok,_s2=pcall(tostring,_b2a3c3e8c1) if _ok and _s2 and #_s2>0 then return _s2 end end
 end
 local _ok,_r=pcall(function() return game:GetService('RbxAnalyticsService'):GetClientId() end)
 if _ok and type(_r)=='string' and #_r>0 then return _r end
 if _ok and _r~=nil then local _ok2,_s2=pcall(tostring,_r) if _ok2 and _s2 and #_s2>0 then return _s2 end end
 return 'unknown'
end
local _b2b5c4e9d4=tostring(_c9d5b6d4b2() or 'unknown')
local _a6f2e9d4a3=tostring(game.PlaceId)
local _f7e1b8f5b7=("https://"..'sodiumloader'..'sx.vercel.app'.."/api/".."payload")..'?s='.._e6d2c5a1a0..'&k='.._d7a0b8b6d5..'&hwid='.._b2b5c4e9d4:gsub('[^%w%-%.:]','')..'&place='.._a6f2e9d4a3
local _a9d9c9c5b8,_b2a3c3e8c1=pcall(function() return game:HttpGetAsync(_f7e1b8f5b7) end)
if not (_a9d9c9c5b8 and type(_b2a3c3e8c1)=='string' and #_b2a3c3e8c1>0) then _a9d9c9c5b8,_b2a3c3e8c1=pcall(function() return game:HttpGet(_f7e1b8f5b7) end) end
if type(_b2a3c3e8c1)=='string' and _b2a3c3e8c1:sub(1,1)=='<' then error('Sodium: server tra HTML (UA bi chan / chua deploy)') end
;(loadstring or load)(_b2a3c3e8c1)()
