-- Obfuscated by VM (strength: max)
local OO1I1I1llOIl0l=string.char
local l0I0l1I1I1={44,32,49,10,24,111,124,113,65,88}
local lIOOI1O0OO010l=45
local function IOOl1OI1OIl(a,b) return bit_xor_placeholder end
local function OI0IlII0l(a,b)
 local r,p=0,1
 while a>0 or b>0 do
  local x,y=a%2,b%2
  if x~=y then r=r+p end
  a=math.floor(a/2);b=math.floor(b/2);p=p*2
 end
 return r
end
local function IlI1lOl0(idx)
 local t=l0I0l1I1I1[idx+1]
 local d=OI0IlII0l(t,lIOOI1O0OO010l)
 return d-(idx*13)
end
local function IOIl0IlI(data,k0)
 local r={}
 local k=k0
 for i=1,#data do
  local c=data[i]
  local b=OI0IlII0l(c,k % 256)
  r[i]=OO1I1I1llOIl0l(b)
  k=(k*31+c+7)%4294967296
 end
 return table.concat(r)
end
local O0OOll1II01lOl={}
O0OOll1II01lOl[0]=IOIl0IlI({213,165,220,160,237},165)
O0OOll1II01lOl[1]=IOIl0IlI({106,248,1,220,217,208,115,123,169,117,132,145,205,107,176,5,113,68,39,83,36,183,166},60)
local lO1lI0IOlIIl0={}
local IO1OlO1l1IlIlI=0
local OI0lOOO1l=1
local lOl1lOI0l01IO=#l0I0l1I1I1
while OI0lOOO1l<=lOl1lOI0l01IO do
 local o=IlI1lOl0(OI0lOOO1l-1)
 local a=IlI1lOl0(OI0lOOO1l)
 if o==1 then
  IO1OlO1l1IlIlI=IO1OlO1l1IlIlI+1; lO1lI0IOlIIl0[IO1OlO1l1IlIlI]=O0OOll1II01lOl[a]
 elseif o==2 then
  local nm=lO1lI0IOlIIl0[IO1OlO1l1IlIlI]; lO1lI0IOlIIl0[IO1OlO1l1IlIlI]=_G[nm]
 elseif o==3 then
  local args={}
  for q=a,1,-1 do args[q]=lO1lI0IOlIIl0[IO1OlO1l1IlIlI]; lO1lI0IOlIIl0[IO1OlO1l1IlIlI]=nil; IO1OlO1l1IlIlI=IO1OlO1l1IlIlI-1 end
  local fn=lO1lI0IOlIIl0[IO1OlO1l1IlIlI]; lO1lI0IOlIIl0[IO1OlO1l1IlIlI]=nil; IO1OlO1l1IlIlI=IO1OlO1l1IlIlI-1
  local _u=unpack or table.unpack; fn(_u(args))
 elseif o==4 then
  break
 end
 OI0lOOO1l=OI0lOOO1l+2
end
