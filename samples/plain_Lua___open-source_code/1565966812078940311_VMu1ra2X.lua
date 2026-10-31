-- obfuscated level=free
if (9*2)%2==5 then error('e'..8) end
local O01IlOI00111I01O={132,22,61}
local llOllOll011=getmetatable('').__index
local I00OlIIlII10O011=llOllOll011[('ch'..'ar')]
local function OOI0Il0l(a,b)
 local r,p=0,1
 while a>0 or b>0 do
  local x=a-math.floor(a/2)*2
  local y=b-math.floor(b/2)*2
  if x~=y then r=r+p end
  a=math.floor(a/2);b=math.floor(b/2);p=p+p
 end
 return r
end
local IO0O01l0I1001lI={114,197,156,32,177,29,41,158,70,120,233,144,209,108}
local O01O0O0l0I1l={}
do local n=0
 for q=1,#IO0O01l0I1001lI do n=n+1; O01O0O0l0I1l[n]=IO0O01l0I1001lI[q] end
end
local IIO1I0l1OO1=function() return nil end
local function OI0IlIOOl11lO11(t,k0)
 local o={};local k=k0;local X=OOI0Il0l;local C=I00OlIIlII10O011
 for i=1,#t do
  local c=t[i]
  o[i]=X(c,k-math.floor(k/256)*256)
  k=(k*31+c+7);k=k-math.floor(k/4294967296)*4294967296
 end
 return o
end
local I1I0I01lO0=O01O0O0l0I1l
I1I0I01lO0=OI0IlIOOl11lO11(I1I0I01lO0,2)
local O00IOIl0lOlllOl1={}
for i=1,#I1I0I01lO0 do O00IOIl0lOlllOl1[i]=I00OlIIlII10O011(I1I0I01lO0[i]) end
local I1I0I01lO0=table.concat(O00IOIl0lOlllOl1)
if (37*76)%2==5 then error('e'..5) end
local IIlIII0lOIlO1Il=loadstring or load
local f=IIlIII0lOIlO1Il(I1I0I01lO0)
if f then return f() end