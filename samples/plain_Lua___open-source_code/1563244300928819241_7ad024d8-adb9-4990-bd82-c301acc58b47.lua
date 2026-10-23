-- script delivered through sxrpt.vault — do not redistribute
local _k1ada810d={162,26,177,44,239,98,81,14,28,116,130,213,212,123,188,52,74,31,128,192,178,151,60,195,208,166,134,1,186,136,114,100}
local _c0eb58696="kyiDHt1QYzwuRrA="
local _f0455cff9=string.char
local bx=(bit32 and bit32.bxor) or function(a,b) local r,m=0,1 while a>0 or b>0 do local x,y=a%2,b%2 if x~=y then r=r+m end a=(a-x)/2 b=(b-y)/2 m=m*2 end return r end
local _t303aaaf2={}
local _o49ebb749={}
for _ic6119326=0,63 do _o49ebb749[("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"):sub(_ic6119326+1,_ic6119326+1)]=_ic6119326 end
local _ic6119326=1
local b=0 local n=0
for p=1,#_c0eb58696 do
  local ch=_c0eb58696:sub(p,p)
  if ch=='=' then break end
  local v=_o49ebb749[ch] if v then b=b*64+v; n=n+6
    if n>=8 then n=n-8; local by=math.floor(b/(2^n)); b=b-by*(2^n)
      _t303aaaf2[#_t303aaaf2+1]=_f0455cff9(bx(by,_k1ada810d[((#_t303aaaf2)%#_k1ada810d)+1]))
    end
  end
end
local ok,err=pcall(function() local fn,e=(loadstring or load)(table.concat(_t303aaaf2)); if not fn then error(e) end; fn() end)
if not ok then error(err) end
