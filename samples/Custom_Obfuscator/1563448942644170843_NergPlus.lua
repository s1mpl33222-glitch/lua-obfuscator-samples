-- LIXMABALL
-- NergProMax
local j00OIoIi=(getfenv and getfenv(1)) or _ENV or _G
local ioL011iLI11j,I1LLoLO0jl=string.byte,string.char
local function lljOOiIljlj(jjoIjjLj1oji,IOooiO0)
local jLjliOjil1IIl0=""
local illi0joOOjo10i=#IOooiO0
for IiillOo1I=1,#jjoIjjLj1oji do jLjliOjil1IIl0=jLjliOjil1IIl0..I1LLoLO0jl((ioL011iLI11j(jjoIjjLj1oji,IiillOo1I)-ioL011iLI11j(IOooiO0,(IiillOo1I-1)%illi0joOOjo10i+1))%256) end
return jLjliOjil1IIl0
end
local L0ioLjl=j00OIoIi[lljOOiIljlj("\200W\007?\173\247","U\242\155\218J\131\221")]
local Lo1OijOLjjjOIo=j00OIoIi[lljOOiIljlj("\199\128\148\024\145\187","T\012\"\175#")][lljOOiIljlj("GL\235","\212\215\137\209\002M")]
local jOo1o00l=j00OIoIi[lljOOiIljlj("\246\173~n\"","\130L\028\002\189X")][lljOOiIljlj("3r$\001'\226","\208\003\182\158\198n\031")]
local iO111iI=j00OIoIi[lljOOiIljlj("4\239=\004","\199\142\201\156-\1728")][lljOOiIljlj("x\030F\182\008","\018\178\215G\150")]
local loii0olIjoo=j00OIoIi[lljOOiIljlj("\000\201\207\191\240\238\191\211","\140ZaJ\131")]
local IlIIoLOlL0=j00OIoIi[lljOOiIljlj("\021&\208\031&","\176\180^")]
local LL1ojloi1i=j00OIoIi[lljOOiIljlj("4\168\006\216","\192/\150s\158")]
local iilLI0llooj=j00OIoIi[lljOOiIljlj("0\204\204y\173Y*\219\185n\180J","\201gX\012H\229")]
local I11jjoILOlI=j00OIoIi[lljOOiIljlj("\227c\179l$\143","q\002<\005\191\027#")]
local IOI1ol=j00OIoIi[lljOOiIljlj("4d\250:","\198\255\130")]
local I011o1,L11jl11Il0,IL1OlI,LLOI0OL0jl00lL=lljOOiIljlj("\028\247\226\227b","\168\150\128w\253\\"),lljOOiIljlj("4\226+-\245\151=\219","\206m\189\202\129."),lljOOiIljlj("\197\129\220\031\001\161","f\"s\171\156/u"),lljOOiIljlj("[P,\254\194h","\252\241\201\157V")
local Il0i0I11LoLjj=j00OIoIi[lljOOiIljlj("%\164\172x(","\193?J\003")]
local I1jo0oL0o=78
if Il0i0I11LoLjj then local il0j0LiO0Ll=Il0i0I11LoLjj[lljOOiIljlj("\253w\023\221\2467\219\236p","\137\005\182z\145\213z")] if il0j0LiO0Ll then local function jO0OLiIl1ILoLi() local L1oijj010iL1,Ii0IL0i1=il0j0LiO0Ll():gsub(":%d+","") if Ii0IL0i1>=2 then return 8457 end return 78 end I1jo0oL0o=jO0OLiIl1ILoLi() end end
local ii001lIO1iIiL=L0ioLjl("#",0,0,0,0,0)*5+loii0olIjoo("8212")*7+(I1LLoLO0jl(83,82)=="SR" and 7918 or 99)+I1jo0oL0o+ioL011iLI11j("P")
local IijlLO11I0=j00OIoIi[lljOOiIljlj("{\027\031~\016","\007\186\189\018\171\203K")][lljOOiIljlj("\152\207ZG","(n\247\220")] or function(...) return {n=L0ioLjl("#",...),...} end
local lii1001i=j00OIoIi[lljOOiIljlj("\n*3\200\225","\150\201\209\\|")][lljOOiIljlj("\0317\243\011,\238","\170\201\131")] or j00OIoIi[lljOOiIljlj("\172M\218\008\154J","7\223j\167")]
local il10OLio="Wa0s6QfKt8eo3kHCOyzSIqpjmuxXV2RUln+LbvZ/JrTEdgA91wiYGMhB45N7FPcD"
local function jil1lll(jioIO1iIO0)
local I1IIIllio1l={}
for IIiO111ljOo=1,64 do I1IIIllio1l[ioL011iLI11j(il10OLio,IIiO111ljOo)]=IIiO111ljOo-1 end
local ljjOLljIjI0Io,L1oIOIIooiOj,i011jojLj,iOO1i0LjiLIl0I={},0,0,0
for IIiO111ljOo=1,#jioIO1iIO0 do
local liLL11lL0Loo1=I1IIIllio1l[ioL011iLI11j(jioIO1iIO0,IIiO111ljOo)]
if liLL11lL0Loo1 then
L1oIOIIooiOj=L1oIOIIooiOj*64+liLL11lL0Loo1
i011jojLj=i011jojLj+6
if i011jojLj>=8 then i011jojLj=i011jojLj-8 iOO1i0LjiLIl0I=iOO1i0LjiLIl0I+1 ljjOLljIjI0Io[iOO1i0LjiLIl0I]=I1LLoLO0jl(iO111iI(L1oIOIIooiOj/(2^i011jojLj))%256) L1oIOIIooiOj=L1oIOIIooiOj%(2^i011jojLj) end
end
end
return jOo1o00l(ljjOLljIjI0Io)
end
local joLL0OIil0jI1o="fZDz9lIMymwvGeAY8MQNJlZtQK6/FhLeOYnP43givpLA+6D7X09Fmt3XOk7bqNQ3aFX6qzjXbVZkQfn3sZQysiUr1clCQw3uH8OCr+ZdZjX1pyMAAKzgehfTJqsU+dWmgM2YWbtYCyqv8JTifIupznfZ+g3Sh5eHkJyfGuIGJ9EPujLhcZZGoXk9Q9W4wyMMUiHwy0HeilYq/Pa0W7gglDLkZ6+KXY1zZosQ4wIYtBGXadUlg5j36yDcDelCVJFkGCbI1YXYg1GVmNNr2/4j7f+WTICAz/bfJlB7t4S1ln/ym48vn9jhWyHA6/7pjSVxY7NPQ6x9azHASUxrY/AmJCvBt5DEH95YRWYtQkbKJAa+wvzJO0dG8dmFkklhqvC4PmgeRO3ga3MBdxh2aD5SMyi1ttnq9ib9cc0jpNNOhKAqNXPEFlRVDUw3KAYYLkqQUoXwkDuRKcVTbTY3LpIX2RXti3p/jyrw3FCAKDnMA5MNOxHGlUP+lzh7WUmkHnbPKK27R7KbPyg33w0YlmTGwZu1EAaXHPk0RGxSJDDqRBJ3NrW1Nm78K89O1kur8e2Z/l6B4wisKG8xwpCNe6pI1hxbxskfKSbHTGxK1tRpBX95JbxjvPugpPsD1mzCoJ89LNX2X5oe/6GeYosKFcO8DFSlKW8TOdu7hXDJRQcczZpH4v890PW+/wgRxlYJdwKbOzoBaBMt8QUEg3Jmi9PCefnqvyP1+XyC/ZjeURMM4uNQL9LKmw1Le0MdFnzDPfMKBqCSka3AhqfOxk1kMX5tsm32A++ynul4BS93DS+aXFWLBAgKCoU9oLwNH7ilzayAK1MtCYaoog6jn/c2sMobR30NQ84uX2SEQjjF9yB32WerQRbz/GFV01+D2pXgcIDzrv2IXlubZz1XYWF9XJVssoCdTzASs1R6GRCt9xpg3PpWQ0M6jysKR9MslM8XABb9tEIsgKgbVRND77RJl5bUCvTYrZQHnS8v9QmHZhDIEYdsxrVgf3LBp0VJlJYBghCpndC8mv23bgyW3pITf8mo9rlC/lTLBOzvebBD26RGeMo70K3PFm2DSGfSna+YT6rXES7XteOjDN7np+QRdSDZ8J+f/fi2p8JERk+8o4qgSGctRn12Be1aETYumAjuBtdNLt+MnMLBPZ1SUhGJl2AN0YUsBx6MV8QSANktLcYPSToHpyeQTCYkF3AlK+7214dUcGxkgF/WXoG9B0sR0E+rxBfiJlaGj0Ahgp3cspWlEjiUsrv6VqygLUUrWqbYho4jx3pOY4mvskR/0+U+hgM3D76KOU/6Tm4spKUMSJQ4MyqxL8R+2+KaVaqkL6VrmG8kNLTzbDiXnhaoX1=="
local LL0loiOoil=jil1lll(joLL0OIil0jI1o)
joLL0OIil0jI1o=nil
if #LL0loiOoil~=1018 then IlIIoLOlL0("VM integrity check failed",0) end
local function ill1iIi1i()
local jjoj0i1I=(1070058923)+ii001lIO1iIiL
local i0oiOILiLojIOO=21
local ILlol0=0
return function()
ILlol0=ILlol0+1
jjoj0i1I=(jjoj0i1I*24819+2622547879)%4294967296
local loil00iL1i1OI1=ioL011iLI11j(LL0loiOoil,ILlol0)
local lIi0000IOi1=(iO111iI(jjoj0i1I/65536)+i0oiOILiLojIOO+(ILlol0-1)*236)%256
local LjO0o0lj=(loil00iL1i1OI1-lIi0000IOi1)%256
i0oiOILiLojIOO=(i0oiOILiLojIOO*41+loil00iL1i1OI1+1)%251
return LjO0o0lj
end
end
local Li0lLo1il=ill1iIi1i()
local iOIl0jjiIIi,Iio1IOiO0LOio=1,0
for L1oijj010iL1=1,#LL0loiOoil do
local LjO0o0lj=Li0lLo1il()
iOIl0jjiIIi=(iOIl0jjiIIi*257+LjO0o0lj+1)%4294967291
Iio1IOiO0LOio=(Iio1IOiO0LOio*65599+LjO0o0lj+1)%4294967279
end
if iOIl0jjiIIi~=591194265 or Iio1IOiO0LOio~=2352822938 then IlIIoLOlL0("VM integrity check failed",0) end
Li0lLo1il=ill1iIi1i()
local ILlol0=1
local function lLioioOo1(L1oijj010iL1)
if L1oijj010iL1<0 or ILlol0+L1oijj010iL1-1>#LL0loiOoil then IlIIoLOlL0("VM payload is truncated",0) end
end
local function jiLjloOi()
lLioioOo1(1)
local L1oijj010iL1=Li0lLo1il()
ILlol0=ILlol0+1
return L1oijj010iL1
end
local function iIjllLLLO()
lLioioOo1(2)
local L1oijj010iL1=Li0lLo1il()
local LjO0o0lj=Li0lLo1il()
ILlol0=ILlol0+2
return L1oijj010iL1+LjO0o0lj*256
end
local function Il0Ol1i()
lLioioOo1(4)
local L1oijj010iL1=Li0lLo1il()
local LjO0o0lj=Li0lLo1il()
local loil00iL1i1OI1=Li0lLo1il()
local l1oLil01LLj=Li0lLo1il()
ILlol0=ILlol0+4
return L1oijj010iL1+LjO0o0lj*256+loil00iL1i1OI1*65536+l1oLil01LLj*16777216
end
local function llji1j0iIoOjI()
local L1oijj010iL1=Il0Ol1i()
lLioioOo1(L1oijj010iL1)
local LjO0o0lj={}
for loil00iL1i1OI1=1,L1oijj010iL1 do LjO0o0lj[loil00iL1i1OI1]=I1LLoLO0jl(Li0lLo1il()) end
ILlol0=ILlol0+L1oijj010iL1
return jOo1o00l(LjO0o0lj)
end
local function ILjj11Io0O()
local L1oijj010iL1=jiLjloOi()
local LjO0o0lj=llji1j0iIoOjI()
if L1oijj010iL1==0 then return loii0olIjoo(LjO0o0lj)
elseif L1oijj010iL1==1 then return LjO0o0lj
elseif L1oijj010iL1==2 then return 1/0
elseif L1oijj010iL1==3 then return -1/0
else return 0/0 end
end
local function i0ol1LlOoL0IIi(j0ijliij110l11)
if j0ijliij110l11>200 then IlIIoLOlL0("VM function nesting limit exceeded",0) end
local I0jlIl0l1O=jiLjloOi()
local L1oijj010iL1=jiLjloOi()
if L1oijj010iL1>1 then IlIIoLOlL0("VM invalid function flags",0) end
local l0jLLLl1LOOooI=Il0Ol1i()
local Io1lOj=l0jLLLl1LOOooI%65536
local LjO0o0lj=iIjllLLLO()
local jILIjloo={}
for loil00iL1i1OI1=1,LjO0o0lj do local LI0liiL0oLILo=iIjllLLLO() jILIjloo[loil00iL1i1OI1]={LI0liiL0oLILo,llji1j0iIoOjI()} end
local l1oLil01LLj=Il0Ol1i()
lLioioOo1(l1oLil01LLj*12)
local joL0IooOooL={}
for loil00iL1i1OI1=1,l1oLil01LLj do
joL0IooOooL[loil00iL1i1OI1]={iIjllLLLO(),Il0Ol1i(),Il0Ol1i(),iIjllLLLO()}
for LII0IL0ojjl=1,4 do Io1lOj=(Io1lOj*131+joL0IooOooL[loil00iL1i1OI1][LII0IL0ojjl]%65536+LII0IL0ojjl)%65536 end
end
local ILlol0=iIjllLLLO()
local Ll0Oij0ojoojI={}
for loil00iL1i1OI1=1,ILlol0 do Ll0Oij0ojoojI[loil00iL1i1OI1]=i0ol1LlOoL0IIi(j0ijliij110l11+1) end
local ilI11oLOLIi1o=iIjllLLLO()
local iljjjIOljIlLL={}
for loil00iL1i1OI1=1,ilI11oLOLIi1o do iljjjIOljIlLL[loil00iL1i1OI1]={jiLjloOi(),iIjllLLLO()} end
return {I0jlIl0l1O,L1oijj010iL1,joL0IooOooL,jILIjloo,Ll0Oij0ojoojI,iljjjIOljIlLL,{},l0jLLLl1LOOooI,(ii001lIO1iIiL+32033+Io1lOj)%65536}
end
local function jjooLll(llOIio0,l1IoO0ilijO,LI0liiL0oLILo,LoOILll1ijj)
if l1IoO0ilijO[LI0liiL0oLILo]~=nil then return l1IoO0ilijO[LI0liiL0oLILo] end
local jioIO1iIO0=llOIio0[LI0liiL0oLILo]
local I1IIIllio1l=jioIO1iIO0[1]
local IIiO111ljOo=jioIO1iIO0[2]
local ljjOLljIjI0Io=(LoOILll1ijj+I1IIIllio1l*251+1)%65536
local L1oIOIIooiOj={}
for i011jojLj=1,#IIiO111ljOo do
ljjOLljIjI0Io=(ljjOLljIjI0Io*40503+12345)%65536
L1oIOIIooiOj[i011jojLj]=I1LLoLO0jl((ioL011iLI11j(IIiO111ljOo,i011jojLj)-iO111iI(ljjOLljIjI0Io/256)%256-i011jojLj*(LoOILll1ijj%256))%256)
end
local iOO1i0LjiLIl0I=jOo1o00l(L1oIOIIooiOj)
if #iOO1i0LjiLIl0I<5 then IlIIoLOlL0("VM invalid constant",0) end
local liLL11lL0Loo1=ioL011iLI11j(iOO1i0LjiLIl0I,1)
local IiLlliL=ioL011iLI11j(iOO1i0LjiLIl0I,2)+ioL011iLI11j(iOO1i0LjiLIl0I,3)*256+ioL011iLI11j(iOO1i0LjiLIl0I,4)*65536+ioL011iLI11j(iOO1i0LjiLIl0I,5)*16777216
if IiLlliL~=#iOO1i0LjiLIl0I-5 or liLL11lL0Loo1>4 then IlIIoLOlL0("VM invalid constant",0) end
local lioLOL=Lo1OijOLjjjOIo(iOO1i0LjiLIl0I,6,5+IiLlliL)
local j1Ll1jll
if liLL11lL0Loo1==0 then j1Ll1jll=loii0olIjoo(lioLOL) elseif liLL11lL0Loo1==1 then j1Ll1jll=lioLOL elseif liLL11lL0Loo1==2 then j1Ll1jll=1/0 elseif liLL11lL0Loo1==3 then j1Ll1jll=-1/0 else j1Ll1jll=0/0 end
l1IoO0ilijO[LI0liiL0oLILo]=j1Ll1jll
return j1Ll1jll
end
local Ij011OLOjOO={}
local lOi00jIi1IL=iIjllLLLO()
for lIo0IoI0IOi0O=1,lOi00jIi1IL do local L1oijj010iL1=iIjllLLLO() local LjO0o0lj=iIjllLLLO() Ij011OLOjOO[L1oijj010iL1]=LjO0o0lj end
local IoOL1L0=i0ol1LlOoL0IIi(0)
if ILlol0~=#LL0loiOoil+1 then IlIIoLOlL0("VM trailing payload data",0) end
LL0loiOoil=nil
Li0lLo1il=nil
local iLliiIlj
local function I10Lj01iL0(IoOL1L0,iljjjIOljIlLL)
return function(...) return iLliiIlj(IoOL1L0,iljjjIOljIlLL,IijlLO11I0(...)) end
end
iLliiIlj=function(IoOL1L0,iljjjIOljIlLL,I10OlLOiI0O11L)
local LOi0IO1Ii1={}
local II0LIOOL10jjj=0
local I0jlIl0l1O=IoOL1L0[1]
local jIIiiL0iliL=I10OlLOiI0O11L.n
for L1oijj010iL1=1,I0jlIl0l1O do LOi0IO1Ii1[L1oijj010iL1-1]=I10OlLOiI0O11L[L1oijj010iL1] end
local lOOLljj,loijoOILIIjlIj={},0
if IoOL1L0[2]==1 then loijoOILIIjlIj=jIIiiL0iliL-I0jlIl0l1O; if loijoOILIIjlIj<0 then loijoOILIIjlIj=0 end; for L1oijj010iL1=1,loijoOILIIjlIj do lOOLljj[L1oijj010iL1]=I10OlLOiI0O11L[I0jlIl0l1O+L1oijj010iL1] end end
local joL0IooOooL,jILIjloo,Ll0Oij0ojoojI=IoOL1L0[3],IoOL1L0[4],IoOL1L0[5]
local liOjol0OOLLjjl=IoOL1L0[7]
local jLO10i=1
local ilI11oLOLIi1o=0
while true do
local Ilj01ojOjlij=joL0IooOooL[jLO10i]
if Ilj01ojOjlij==nil then IlIIoLOlL0("VM invalid instruction address",0) end
local jLIO0jj1O1o1i=(IoOL1L0[8]+jLO10i*65599)%4294967296
jLO10i=jLO10i+1
jLIO0jj1O1o1i=(jLIO0jj1O1o1i*1664525+1013904223)%4294967296
local Ll1LLlIj=(Ilj01ojOjlij[1]-jLIO0jj1O1o1i)%65536
jLIO0jj1O1o1i=(jLIO0jj1O1o1i*1664525+1013904223)%4294967296
local L1oijj010iL1=(Ilj01ojOjlij[4]-jLIO0jj1O1o1i)%65536
jLIO0jj1O1o1i=(jLIO0jj1O1o1i*1664525+1013904223)%4294967296
local LjO0o0lj=(Ilj01ojOjlij[2]-jLIO0jj1O1o1i)%4294967296
jLIO0jj1O1o1i=(jLIO0jj1O1o1i*1664525+1013904223)%4294967296
local loil00iL1i1OI1=(Ilj01ojOjlij[3]-jLIO0jj1O1o1i)%4294967296
local l1oLil01LLj=Ij011OLOjOO[Ll1LLlIj]
if (jLO10i%2)*(jLO10i%2)-(jLO10i%2)~=0 then II0LIOOL10jjj=II0LIOOL10jjj+7 end
if (jLO10i*jLO10i+jLO10i)%2~=0 then II0LIOOL10jjj=II0LIOOL10jjj+1 end
if l1oLil01LLj==10 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj]//LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==18 then
local IIiO111ljOo
if LjO0o0lj==0 then IIiO111ljOo=ilI11oLOLIi1o-L1oijj010iL1 else IIiO111ljOo=LjO0o0lj-1 end
local ljjOLljIjI0Io={}
for jioIO1iIO0=1,IIiO111ljOo do ljjOLljIjI0Io[jioIO1iIO0]=LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0-1] end
return lii1001i(ljjOLljIjI0Io,1,IIiO111ljOo)
elseif l1oLil01LLj==23 then
local I1IIIllio1l=LOi0IO1Ii1[L1oijj010iL1]
local iOO1i0LjiLIl0I=LOi0IO1Ii1[L1oijj010iL1+1]
local liLL11lL0Loo1=LOi0IO1Ii1[L1oijj010iL1+2]
local L1oIOIIooiOj=IijlLO11I0(I1IIIllio1l(iOO1i0LjiLIl0I,liLL11lL0Loo1))
local i011jojLj=L1oIOIIooiOj[1]
if i011jojLj~=nil then
LOi0IO1Ii1[L1oijj010iL1+2]=i011jojLj
for jioIO1iIO0=1,LjO0o0lj do LOi0IO1Ii1[L1oijj010iL1+3+jioIO1iIO0-1]=L1oIOIIooiOj[jioIO1iIO0] end
jLO10i=loil00iL1i1OI1+1
end
elseif l1oLil01LLj==15 then
local jioIO1iIO0,I1IIIllio1l=LOi0IO1Ii1[LjO0o0lj],LOi0IO1Ii1[loil00iL1i1OI1];LOi0IO1Ii1[L1oijj010iL1]=(jioIO1iIO0==I1IIIllio1l)
elseif l1oLil01LLj==37 then
LOi0IO1Ii1[L1oijj010iL1]={}
elseif l1oLil01LLj==19 then
for jioIO1iIO0=L1oijj010iL1,L1oijj010iL1+LjO0o0lj do LOi0IO1Ii1[jioIO1iIO0]=nil end
elseif l1oLil01LLj==35 then
LOi0IO1Ii1[L1oijj010iL1]=(LOi0IO1Ii1[LjO0o0lj]<LOi0IO1Ii1[loil00iL1i1OI1])
elseif l1oLil01LLj==36 then
if LjO0o0lj==0 then
for jioIO1iIO0=1,loijoOILIIjlIj do LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0-1]=lOOLljj[jioIO1iIO0] end
ilI11oLOLIi1o=L1oijj010iL1+loijoOILIIjlIj
else
for jioIO1iIO0=1,LjO0o0lj-1 do LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0-1]=lOOLljj[jioIO1iIO0] end
end
elseif l1oLil01LLj==4 then
LOi0IO1Ii1[L1oijj010iL1]=iljjjIOljIlLL[LjO0o0lj+1][1]
elseif l1oLil01LLj==24 then
local jioIO1iIO0=LOi0IO1Ii1[LjO0o0lj];LOi0IO1Ii1[L1oijj010iL1]=jioIO1iIO0
elseif l1oLil01LLj==7 then
LOi0IO1Ii1[L1oijj010iL1][LOi0IO1Ii1[LjO0o0lj]]=LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==21 then
LOi0IO1Ii1[L1oijj010iL1]=(LOi0IO1Ii1[LjO0o0lj]~=LOi0IO1Ii1[loil00iL1i1OI1])
elseif l1oLil01LLj==13 then
jLO10i=LjO0o0lj+1
elseif l1oLil01LLj==29 then
LOi0IO1Ii1[L1oijj010iL1]=-LOi0IO1Ii1[LjO0o0lj]
elseif l1oLil01LLj==39 then
local I1IIIllio1l=LOi0IO1Ii1[L1oijj010iL1]
local IIiO111ljOo
if LjO0o0lj==0 then IIiO111ljOo=ilI11oLOLIi1o-L1oijj010iL1-1 else IIiO111ljOo=LjO0o0lj-1 end
local ljjOLljIjI0Io={}
for jioIO1iIO0=1,IIiO111ljOo do ljjOLljIjI0Io[jioIO1iIO0]=LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0] end
local L1oIOIIooiOj=IijlLO11I0(I1IIIllio1l(lii1001i(ljjOLljIjI0Io,1,IIiO111ljOo)))
if loil00iL1i1OI1==0 then
local i011jojLj=L1oIOIIooiOj.n
for jioIO1iIO0=1,i011jojLj do LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0-1]=L1oIOIIooiOj[jioIO1iIO0] end
ilI11oLOLIi1o=L1oijj010iL1+i011jojLj
else
for jioIO1iIO0=1,loil00iL1i1OI1-1 do LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0-1]=L1oIOIIooiOj[jioIO1iIO0] end
end
elseif l1oLil01LLj==43 then
LOi0IO1Ii1[L1oijj010iL1]=#LOi0IO1Ii1[LjO0o0lj]
elseif l1oLil01LLj==11 then
LOi0IO1Ii1[L1oijj010iL1]=(LOi0IO1Ii1[LjO0o0lj]>LOi0IO1Ii1[loil00iL1i1OI1])
elseif l1oLil01LLj==22 then
LOi0IO1Ii1[L1oijj010iL1]=j00OIoIi[jjooLll(jILIjloo,liOjol0OOLLjjl,LjO0o0lj+1,IoOL1L0[9])]
elseif l1oLil01LLj==2 then
LOi0IO1Ii1[L1oijj010iL1]={LOi0IO1Ii1[LjO0o0lj]}
elseif l1oLil01LLj==14 then
II0LIOOL10jjj=(II0LIOOL10jjj+LjO0o0lj)%(loil00iL1i1OI1+1)
elseif l1oLil01LLj==40 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj]-LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==8 then
local jioIO1iIO0,I1IIIllio1l=LOi0IO1Ii1[LjO0o0lj],LOi0IO1Ii1[loil00iL1i1OI1];LOi0IO1Ii1[L1oijj010iL1]=(jioIO1iIO0>=I1IIIllio1l)
elseif l1oLil01LLj==25 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj][LOi0IO1Ii1[loil00iL1i1OI1]]
elseif l1oLil01LLj==5 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj]/LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==41 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj][1]
elseif l1oLil01LLj==38 then
local jioIO1iIO0,I1IIIllio1l=LOi0IO1Ii1[LjO0o0lj],LOi0IO1Ii1[loil00iL1i1OI1];LOi0IO1Ii1[L1oijj010iL1]=(jioIO1iIO0<=I1IIIllio1l)
elseif l1oLil01LLj==27 then
local jioIO1iIO0,I1IIIllio1l=LOi0IO1Ii1[LjO0o0lj],LOi0IO1Ii1[loil00iL1i1OI1];LOi0IO1Ii1[L1oijj010iL1]=jioIO1iIO0..I1IIIllio1l
elseif l1oLil01LLj==28 then
local IIiO111ljOo
if LjO0o0lj==0 then IIiO111ljOo=ilI11oLOLIi1o-L1oijj010iL1-1 else IIiO111ljOo=LjO0o0lj end
local I1IIIllio1l=LOi0IO1Ii1[L1oijj010iL1]
for jioIO1iIO0=1,IIiO111ljOo do I1IIIllio1l[loil00iL1i1OI1+jioIO1iIO0]=LOi0IO1Ii1[L1oijj010iL1+jioIO1iIO0] end
elseif l1oLil01LLj==1 then
local jioIO1iIO0,I1IIIllio1l=LOi0IO1Ii1[LjO0o0lj],LOi0IO1Ii1[loil00iL1i1OI1];LOi0IO1Ii1[L1oijj010iL1]=jioIO1iIO0+I1IIIllio1l
elseif l1oLil01LLj==31 then
LOi0IO1Ii1[L1oijj010iL1+1]=LOi0IO1Ii1[LjO0o0lj]; LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj][LOi0IO1Ii1[loil00iL1i1OI1]]
elseif l1oLil01LLj==26 then
iljjjIOljIlLL[LjO0o0lj+1][1]=LOi0IO1Ii1[L1oijj010iL1]
elseif l1oLil01LLj==6 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[L1oijj010iL1]+LOi0IO1Ii1[L1oijj010iL1+2]
local I1IIIllio1l=LOi0IO1Ii1[L1oijj010iL1+2]
local IIiO111ljOo
if I1IIIllio1l>0 then IIiO111ljOo=LOi0IO1Ii1[L1oijj010iL1]<=LOi0IO1Ii1[L1oijj010iL1+1] else IIiO111ljOo=LOi0IO1Ii1[L1oijj010iL1]>=LOi0IO1Ii1[L1oijj010iL1+1] end
if IIiO111ljOo then LOi0IO1Ii1[L1oijj010iL1+3]=LOi0IO1Ii1[L1oijj010iL1]; jLO10i=LjO0o0lj+1 end
elseif l1oLil01LLj==30 then
local jioIO1iIO0=jjooLll(jILIjloo,liOjol0OOLLjjl,LjO0o0lj+1,IoOL1L0[9]);LOi0IO1Ii1[L1oijj010iL1]=jioIO1iIO0
elseif l1oLil01LLj==20 then
for jioIO1iIO0=L1oijj010iL1,L1oijj010iL1+2 do
LOi0IO1Ii1[jioIO1iIO0]=loii0olIjoo(LOi0IO1Ii1[jioIO1iIO0])
if LOi0IO1Ii1[jioIO1iIO0]==nil then IlIIoLOlL0("Numeric for bounds and step must be numbers",0) end
end
local I1IIIllio1l=LOi0IO1Ii1[L1oijj010iL1+2]
local IIiO111ljOo
if I1IIIllio1l>0 then IIiO111ljOo=LOi0IO1Ii1[L1oijj010iL1]<=LOi0IO1Ii1[L1oijj010iL1+1] else IIiO111ljOo=LOi0IO1Ii1[L1oijj010iL1]>=LOi0IO1Ii1[L1oijj010iL1+1] end
if IIiO111ljOo then LOi0IO1Ii1[L1oijj010iL1+3]=LOi0IO1Ii1[L1oijj010iL1] else jLO10i=LjO0o0lj+1 end
elseif l1oLil01LLj==17 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj]*LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==44 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj]%LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==34 then
LOi0IO1Ii1[L1oijj010iL1]=LOi0IO1Ii1[LjO0o0lj]^LOi0IO1Ii1[loil00iL1i1OI1]
elseif l1oLil01LLj==12 then
local I1IIIllio1l=Ll0Oij0ojoojI[LjO0o0lj+1]
local ljjOLljIjI0Io={}
local L1oIOIIooiOj=I1IIIllio1l[6]
for jioIO1iIO0=1,#L1oIOIIooiOj do
local i011jojLj=L1oIOIIooiOj[jioIO1iIO0]
if i011jojLj[1]==1 then ljjOLljIjI0Io[jioIO1iIO0]=LOi0IO1Ii1[i011jojLj[2]] else ljjOLljIjI0Io[jioIO1iIO0]=iljjjIOljIlLL[i011jojLj[2]+1] end
end
LOi0IO1Ii1[L1oijj010iL1]=I10Lj01iL0(I1IIIllio1l,ljjOLljIjI0Io)
elseif l1oLil01LLj==42 then
if (not not LOi0IO1Ii1[L1oijj010iL1])==(LjO0o0lj~=0) then jLO10i=loil00iL1i1OI1+1 end
elseif l1oLil01LLj==16 then
LOi0IO1Ii1[L1oijj010iL1]=not LOi0IO1Ii1[LjO0o0lj]
elseif l1oLil01LLj==3 then
local jioIO1iIO0=LOi0IO1Ii1[L1oijj010iL1]
if LL1ojloi1i(jioIO1iIO0)~=L11jl11Il0 then
local I1IIIllio1l=iilLI0llooj(jioIO1iIO0)
if I1IIIllio1l~=nil and LL1ojloi1i(I1IIIllio1l)~=I011o1 then IlIIoLOlL0("Protected iterator metatables require an explicit iterator function",0) end
local IIiO111ljOo=I1IIIllio1l and I11jjoILOlI(I1IIIllio1l,IL1OlI)
if IIiO111ljOo~=nil then
LOi0IO1Ii1[L1oijj010iL1],LOi0IO1Ii1[L1oijj010iL1+1],LOi0IO1Ii1[L1oijj010iL1+2]=IIiO111ljOo(jioIO1iIO0)
elseif LL1ojloi1i(jioIO1iIO0)==I011o1 and (I1IIIllio1l==nil or I11jjoILOlI(I1IIIllio1l,LLOI0OL0jl00lL)==nil) then
LOi0IO1Ii1[L1oijj010iL1],LOi0IO1Ii1[L1oijj010iL1+1],LOi0IO1Ii1[L1oijj010iL1+2]=IOI1ol,jioIO1iIO0,nil
end
end
elseif l1oLil01LLj==33 then
LOi0IO1Ii1[LjO0o0lj][1]=LOi0IO1Ii1[L1oijj010iL1]
elseif l1oLil01LLj==32 then
LOi0IO1Ii1[L1oijj010iL1]=(LjO0o0lj~=0)
elseif l1oLil01LLj==9 then
j00OIoIi[jjooLll(jILIjloo,liOjol0OOLLjjl,LjO0o0lj+1,IoOL1L0[9])]=LOi0IO1Ii1[L1oijj010iL1]
else IlIIoLOlL0() end
end
return II0LIOOL10jjj
end
return iLliiIlj(IoOL1L0,{},IijlLO11I0(...))
