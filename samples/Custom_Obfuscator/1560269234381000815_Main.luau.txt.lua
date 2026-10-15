local jj1jL000I1ol=(getfenv and getfenv(1)) or _ENV or _G
local ililj00IjI,i0OIj0Ojl001OL=string.byte,string.char
local function joILL1LOLI(iojO10,iI0lii0I0Li)
local Il0ooLIIlOLlI=""
local LOjLI1oili=#iI0lii0I0Li
for IIoL1iO0IIl1o=1,#iojO10 do Il0ooLIIlOLlI=Il0ooLIIlOLlI..i0OIj0Ojl001OL((ililj00IjI(iojO10,IIoL1iO0IIl1o)-ililj00IjI(iI0lii0I0Li,(IIoL1iO0IIl1o-1)%LOjLI1oili+1))%256) end
return Il0ooLIIlOLlI
end
local jll0lijL=jj1jL000I1ol[joILL1LOLI("\173\026\029\225\237\141",":\181\177|\138\0255")]
local l1oiojijLO=jj1jL000I1ol[joILL1LOLI("\160\204\177Z\194[","-X?\241T\244\007")][joILL1LOLI("9\"\227","\198\173\129S\193\024\001")]
local ilIOiiOLi00=jj1jL000I1ol[joILL1LOLI("\141\027\189\190\234","\025\186[R\133\140")][joILL1LOLI("\253\187W\253\173]","\154L\233")]
local I1L0L0=jj1jL000I1ol[joILL1LOLI("r\229em","\005\132\241")][joILL1LOLI("\162\133\009\190\174","<\025\154O")]
local IloLIo=jj1jL000I1ol[joILL1LOLI("m\228]\172f\215T\169","\249u\2397")]
local II1lLI1i1ij11L=jj1jL000I1ol[joILL1LOLI("\215Hg\225H","r\214\245")]
local iOoiIOjjoIIL=jj1jL000I1ol[joILL1LOLI("!\028\175`","\173\163?\251")]
local Ll1O0l=jj1jL000I1ol[joILL1LOLI("\207\228\015\009<\017\201\243\252\254C\002","h\127\155\156\215\157")]
local IloOILoI=jj1jL000I1ol[joILL1LOLI("\146\127\221\135\131\218"," \030f")]
local jil1lLIjo=jj1jL000I1ol[joILL1LOLI("v\151M\142","\0082\213\026\245\137\217")]
local l1OlILOij0lIiL,LOi1I1i0I1j1l,Lil00oljl,LLi0lILijl11OL=joILL1LOLI("\188M'\180Q","H\236\197"),joILL1LOLI("\184Vo\142\254\187Po","R\225\001+\138"),joILL1LOLI("1\250\187\026\025\153","\210\155R\166\180'"),joILL1LOLI("\2190dZ7\001","|\209\001\249\203\149")
local loO0OollI=jll0lijL("#",0,0,0,0)*21+(i0OIj0Ojl001OL(78,71)=="NG" and 8638 or 57)+IloLIo("5559")*6+ililj00IjI("+")
local ljLjOioii=jj1jL000I1ol[joILL1LOLI("\159\\\016}\144","+\251\174\017+\002v")][joILL1LOLI("XoE\135","\232\014\226\028")] or function(...) return {n=jll0lijL("#",...),...} end
local ji001o1iOLO10=jj1jL000I1ol[joILL1LOLI("\209=\144?\187","]\220.\211V\133:")][joILL1LOLI("\244 \1401\174z","\127\178\028\208K\015")] or jj1jL000I1ol[joILL1LOLI("i5\021-\219a","\244\199\165\204x\246\164")]
local L0joLII0LjiiL="rzQ2iUmE5FgPMxqBATko/vVdGCN+Lcp4S36OXIsuel1nhWjtRDaKyJwbZ8fYH790"
local function I01LioIiLiOo0(l0OiIl1011Li)
local IoiIOLljO0ojij={}
for IILLjiOIOi=1,64 do IoiIOLljO0ojij[ililj00IjI(L0joLII0LjiiL,IILLjiOIOi)]=IILLjiOIOi-1 end
local iOj1LoO10Ij,LLO011LI0,ljIOojlj,IIlOIillO={},0,0,0
for IILLjiOIOi=1,#l0OiIl1011Li do
local Loj1L0i=IoiIOLljO0ojij[ililj00IjI(l0OiIl1011Li,IILLjiOIOi)]
if Loj1L0i then
LLO011LI0=LLO011LI0*64+Loj1L0i
ljIOojlj=ljIOojlj+6
if ljIOojlj>=8 then ljIOojlj=ljIOojlj-8 IIlOIillO=IIlOIillO+1 iOj1LoO10Ij[IIlOIillO]=i0OIj0Ojl001OL(I1L0L0(LLO011LI0/(2^ljIOojlj))%256) LLO011LI0=LLO011LI0%(2^ljIOojlj) end
end
end
return ilIOiiOLi00(iOj1LoO10Ij)
end
local IjjLLOjiol0i="W5Cm1S79keCUvZiXxixfx9oLn7U89WYYcl0rYMcToecaflbzUGKVCs3iJsH6+cL1AWGwR+93SDvd58F17SwoiY1fazJL58TR7/1lCHrOW5eBFwBMlNEfUW/dYMtPHAupe3bwOPr87Gw2qqIjmxiT9holnAeS6ZqShl1UmERpNUciwojXlpnuZEw/CubA0H2CLuABr9fwqLgT5+SumjPj+TjtnAibUBHLHrfYlfLMGMK1eRNwm4yIQzEhoBBqB7rzIxq62SH9RJ57F19RfdcplYGo4BSfNijESexv+CU8rurrj4ORyw6owB4rHxRKmtv7cu7s6HhP73ywsRPJpRY3fMXpR3bqY7eZ32p72UAsvsvtYQnuOMxqKnxk5ob5woVWZuHl/ODqtzqJlsZ3AdgMNNT2J2vKuteuns6pVqnoe84VwVrvP4UZp/ApAi0HpKgSTx3gphaS6gueTffn1XKVgot2sy7Sb0VJ8i2Qr4gMR5e/x7ZjLhviMFMfngWUeiPq3Ian2/lxZqhjG2tCyDOvAl+VdVR0bDzdSSAmU+Og2OtZ1MIcXcqR6h/jrP5b4+z6rB4adBIeeDN2j9U4VVAwtSYgCmB71J51RQRjZudgLDYnxyS5W1IBW29DAZ50tbrHWgmJPWhQ8b3+41bebzN/4+AAbmm2HdOqLMmkYC7Y7MbALWTdFRA2IF6kYSfbfvUCFciatK5PuUHa75xFvMX354NbpTeJ+m99K6/hns/oMsIaoE2qeej4WfEYs6QTVMnN0FJmLQsscPQ1TZq1HrLHDxT000itPkS3J7r/iYKVFjB+wypTlmdMiw0J7kwJDQkAUdgeSbO/Tpc7lu6+DxguxKIxma44MEYPM7MO7u+kl9knEQ+pJB0hjcanOsbNiaS9Hk8D/3/zGX6Na5o2d6gPIPl/RJ+yjfA3rZO8+15g7zvCg000MTPoWyh3Ocg58PNhT1aBLcBZPGL4ZR9tnovKaRZtPkKvBk1/uCleDNBCb8RrQXYQ/MNvwXHetp9KkQsL3zmhdCJVA4w6qPsfNXAqIZOwUQUW3T0FX4nSPBLYl3Z/b6EeKV9zkEP6SCscgy8hH7nufZw4xTojNlCwvIsZG7cAiyW5GE4B5cXzBxXlBywKjbumDDehjTm6+A+mePYxd6sXTwnggUChaaUMtgM6u4OUaZUG2WRXbIT5dMTr5Oog5XR9uD0oOEmCkv0ZDfu9lfqI4grJyo4W24ozyfmxYhTeT5+kB9saENZrfyx7grfwZAowDquN/W6vigHoJrpvLXiKeydP/xfu8KobiVqADEktATSv/nsR9ER67joBZPzZKkgSc4V8lNxaSpgXA74NrO1qFKF1xLsnwWaNjmp7gv77rQr2EQhaNFHuX87YdHPoQ/fcSpvy20R6lTfvrLr="
local function jL0ji0LI(ioOjoliO0o)
if #ioOjoliO0o~=1055 then II1lLI1i1ij11L("VM integrity check failed",0) end
local i1ii0lO0LiL=(572070628)+loO0OollI
local jli0o1111I0=176
local Lil1j0={}
local lloiOLiiiLiLL,iOOiol0ill=1,0
for ijL11l1LO=1,#ioOjoliO0o do
i1ii0lO0LiL=(i1ii0lO0LiL*47029+426770445)%4294967296
local lij0iiolL0Oi=ililj00IjI(ioOjoliO0o,ijL11l1LO)
local iO0Iil=(I1L0L0(i1ii0lO0LiL/65536)+jli0o1111I0+(ijL11l1LO-1)*43)%256
local l0IIlili1loLl=(lij0iiolL0Oi-iO0Iil)%256
Lil1j0[ijL11l1LO]=i0OIj0Ojl001OL(l0IIlili1loLl)
lloiOLiiiLiLL=(lloiOLiiiLiLL*257+l0IIlili1loLl+1)%4294967291
iOOiol0ill=(iOOiol0ill*65599+l0IIlili1loLl+1)%4294967279
jli0o1111I0=(jli0o1111I0*31+lij0iiolL0Oi+1)%251
end
if lloiOLiiiLiLL~=4008557535 or iOOiol0ill~=3617269365 then II1lLI1i1ij11L("VM integrity check failed",0) end
return ilIOiiOLi00(Lil1j0)
end
local I1OIjjlLl11i=jL0ji0LI(I01LioIiLiOo0(IjjLLOjiol0i))
local lij0iiolL0Oi=1
local function ij1I1lIoLLOl(ijL11l1LO)
if ijL11l1LO<0 or lij0iiolL0Oi+ijL11l1LO-1>#I1OIjjlLl11i then II1lLI1i1ij11L("VM payload is truncated",0) end
end
local function iLol1j10o1()
ij1I1lIoLLOl(1)
local ijL11l1LO=ililj00IjI(I1OIjjlLl11i,lij0iiolL0Oi)
lij0iiolL0Oi=lij0iiolL0Oi+1
return ijL11l1LO
end
local function lloijLjL11i()
ij1I1lIoLLOl(2)
local ijL11l1LO,l0IIlili1loLl=ililj00IjI(I1OIjjlLl11i,lij0iiolL0Oi,lij0iiolL0Oi+1)
lij0iiolL0Oi=lij0iiolL0Oi+2
return ijL11l1LO+l0IIlili1loLl*256
end
local function ijO1jILLIl()
ij1I1lIoLLOl(4)
local ijL11l1LO,l0IIlili1loLl,ioOjoliO0o,Lil1j0=ililj00IjI(I1OIjjlLl11i,lij0iiolL0Oi,lij0iiolL0Oi+3)
lij0iiolL0Oi=lij0iiolL0Oi+4
return ijL11l1LO+l0IIlili1loLl*256+ioOjoliO0o*65536+Lil1j0*16777216
end
local function IjjOOl1O100()
local ijL11l1LO=ijO1jILLIl()
ij1I1lIoLLOl(ijL11l1LO)
local l0IIlili1loLl=l1oiojijLO(I1OIjjlLl11i,lij0iiolL0Oi,lij0iiolL0Oi+ijL11l1LO-1)
lij0iiolL0Oi=lij0iiolL0Oi+ijL11l1LO
return l0IIlili1loLl
end
local function IL1oOOjLL()
local ijL11l1LO=iLol1j10o1()
local l0IIlili1loLl=IjjOOl1O100()
if ijL11l1LO==0 then return IloLIo(l0IIlili1loLl)
elseif ijL11l1LO==1 then return l0IIlili1loLl
elseif ijL11l1LO==2 then return 1/0
elseif ijL11l1LO==3 then return -1/0
else return 0/0 end
end
local function ii0jIIloOO(Io0Ijoj)
if Io0Ijoj>200 then II1lLI1i1ij11L("VM function nesting limit exceeded",0) end
local L1i01O=iLol1j10o1()
local ijL11l1LO=iLol1j10o1()
if ijL11l1LO>1 then II1lLI1i1ij11L("VM invalid function flags",0) end
local iLLiolIli=ijO1jILLIl()
local i0oioo1jLi=iLLiolIli%65536
local l0IIlili1loLl=lloijLjL11i()
local joljioloL={}
for ioOjoliO0o=1,l0IIlili1loLl do local LiOoOLlI0jLi0i=lloijLjL11i() joljioloL[ioOjoliO0o]={LiOoOLlI0jLi0i,IjjOOl1O100()} end
local Lil1j0=ijO1jILLIl()
ij1I1lIoLLOl(Lil1j0*12)
local IiLOIliiO={}
for ioOjoliO0o=1,Lil1j0 do
IiLOIliiO[ioOjoliO0o]={ijO1jILLIl(),lloijLjL11i(),lloijLjL11i(),ijO1jILLIl()}
for LiljL1ljooOl=1,4 do i0oioo1jLi=(i0oioo1jLi*131+IiLOIliiO[ioOjoliO0o][LiljL1ljooOl]%65536+LiljL1ljooOl)%65536 end
end
local lij0iiolL0Oi=lloijLjL11i()
local LolLl11o1l={}
for ioOjoliO0o=1,lij0iiolL0Oi do LolLl11o1l[ioOjoliO0o]=ii0jIIloOO(Io0Ijoj+1) end
local jI100llIL1liO=lloijLjL11i()
local lOiIiliLi0lIoo={}
for ioOjoliO0o=1,jI100llIL1liO do lOiIiliLi0lIoo[ioOjoliO0o]={iLol1j10o1(),lloijLjL11i()} end
return {L1i01O,ijL11l1LO,IiLOIliiO,joljioloL,LolLl11o1l,lOiIiliLi0lIoo,{},iLLiolIli,(loO0OollI+47840+i0oioo1jLi)%65536}
end
local function IjIOl1lijoiL(LLj1IlO01IOL,LOOoIj1jj,LiOoOLlI0jLi0i,iO00IIj)
if LOOoIj1jj[LiOoOLlI0jLi0i]~=nil then return LOOoIj1jj[LiOoOLlI0jLi0i] end
local l0OiIl1011Li=LLj1IlO01IOL[LiOoOLlI0jLi0i]
local IoiIOLljO0ojij=l0OiIl1011Li[1]
local IILLjiOIOi=l0OiIl1011Li[2]
local iOj1LoO10Ij=(iO00IIj+IoiIOLljO0ojij*251+1)%65536
local LLO011LI0={}
for ljIOojlj=1,#IILLjiOIOi do
iOj1LoO10Ij=(iOj1LoO10Ij*40503+12345)%65536
LLO011LI0[ljIOojlj]=i0OIj0Ojl001OL((ililj00IjI(IILLjiOIOi,ljIOojlj)-I1L0L0(iOj1LoO10Ij/256)%256-ljIOojlj*(iO00IIj%256))%256)
end
local IIlOIillO=ilIOiiOLi00(LLO011LI0)
if #IIlOIillO<5 then II1lLI1i1ij11L("VM invalid constant",0) end
local Loj1L0i=ililj00IjI(IIlOIillO,1)
local joiI1ILo=ililj00IjI(IIlOIillO,2)+ililj00IjI(IIlOIillO,3)*256+ililj00IjI(IIlOIillO,4)*65536+ililj00IjI(IIlOIillO,5)*16777216
if joiI1ILo~=#IIlOIillO-5 or Loj1L0i>4 then II1lLI1i1ij11L("VM invalid constant",0) end
local jI1li01L=l1oiojijLO(IIlOIillO,6,5+joiI1ILo)
local j0LlooI0OlL
if Loj1L0i==0 then j0LlooI0OlL=IloLIo(jI1li01L) elseif Loj1L0i==1 then j0LlooI0OlL=jI1li01L elseif Loj1L0i==2 then j0LlooI0OlL=1/0 elseif Loj1L0i==3 then j0LlooI0OlL=-1/0 else j0LlooI0OlL=0/0 end
LOOoIj1jj[LiOoOLlI0jLi0i]=j0LlooI0OlL
return j0LlooI0OlL
end
local Ioi1IIOLioi={}
local jjL0iLoi=lloijLjL11i()
for ij00ilIIi0OO10=1,jjL0iLoi do local ijL11l1LO=lloijLjL11i() local l0IIlili1loLl=lloijLjL11i() Ioi1IIOLioi[ijL11l1LO]=l0IIlili1loLl end
local jLio0oLj=ii0jIIloOO(0)
if lij0iiolL0Oi~=#I1OIjjlLl11i+1 then II1lLI1i1ij11L("VM trailing payload data",0) end
I1OIjjlLl11i=nil
IjjLLOjiol0i=nil
local l1o1jil0OiL
local function jI1ii11I1(jLio0oLj,lOiIiliLi0lIoo)
return function(...) return l1o1jil0OiL(jLio0oLj,lOiIiliLi0lIoo,ljLjOioii(...)) end
end
l1o1jil0OiL=function(jLio0oLj,lOiIiliLi0lIoo,I1o1oIiO)
local Llooji1jll={}
local lj0iOoLjOO=0
local L1i01O=jLio0oLj[1]
local I1ii0o1L1illL=I1o1oIiO.n
for ijL11l1LO=1,L1i01O do Llooji1jll[ijL11l1LO-1]=I1o1oIiO[ijL11l1LO] end
local iljIloIOO,Io01LlIojlI={},0
if jLio0oLj[2]==1 then Io01LlIojlI=I1ii0o1L1illL-L1i01O; if Io01LlIojlI<0 then Io01LlIojlI=0 end; for ijL11l1LO=1,Io01LlIojlI do iljIloIOO[ijL11l1LO]=I1o1oIiO[L1i01O+ijL11l1LO] end end
local IiLOIliiO,joljioloL,LolLl11o1l=jLio0oLj[3],jLio0oLj[4],jLio0oLj[5]
local I01Oij10LO=jLio0oLj[7]
local l0l01lIII0=1
local jI100llIL1liO=0
while true do
local j1jLIoio1oILjj=IiLOIliiO[l0l01lIII0]
if j1jLIoio1oILjj==nil then II1lLI1i1ij11L("VM invalid instruction address",0) end
local L10lOIiIIL=(jLio0oLj[8]+l0l01lIII0*65599)%4294967296
l0l01lIII0=l0l01lIII0+1
L10lOIiIIL=(L10lOIiIIL*1664525+1013904223)%4294967296
local ilI11j0j=(j1jLIoio1oILjj[3]-L10lOIiIIL)%65536
L10lOIiIIL=(L10lOIiIIL*1664525+1013904223)%4294967296
local ijL11l1LO=(j1jLIoio1oILjj[2]-L10lOIiIIL)%65536
L10lOIiIIL=(L10lOIiIIL*1664525+1013904223)%4294967296
local l0IIlili1loLl=(j1jLIoio1oILjj[1]-L10lOIiIIL)%4294967296
L10lOIiIIL=(L10lOIiIIL*1664525+1013904223)%4294967296
local ioOjoliO0o=(j1jLIoio1oILjj[4]-L10lOIiIIL)%4294967296
local Lil1j0=Ioi1IIOLioi[ilI11j0j]
if (l0l01lIII0*(l0l01lIII0+1)*(l0l01lIII0+2))%3~=0 then lj0iOoLjOO=lj0iOoLjOO-2 end
if (l0l01lIII0*l0l01lIII0*l0l01lIII0-l0l01lIII0)%6~=0 then lj0iOoLjOO=lj0iOoLjOO+3 end
if Lil1j0==33 then
Llooji1jll[ijL11l1LO]=(Llooji1jll[l0IIlili1loLl]>=Llooji1jll[ioOjoliO0o])
elseif Lil1j0==37 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]/Llooji1jll[ioOjoliO0o]
elseif Lil1j0==35 then
Llooji1jll[ijL11l1LO]=not Llooji1jll[l0IIlili1loLl]
elseif Lil1j0==21 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]^Llooji1jll[ioOjoliO0o]
elseif Lil1j0==2 then
local l0OiIl1011Li=Llooji1jll[ijL11l1LO]
if iOoiIOjjoIIL(l0OiIl1011Li)~=LOi1I1i0I1j1l then
local IoiIOLljO0ojij=Ll1O0l(l0OiIl1011Li)
if IoiIOLljO0ojij~=nil and iOoiIOjjoIIL(IoiIOLljO0ojij)~=l1OlILOij0lIiL then II1lLI1i1ij11L("Protected iterator metatables require an explicit iterator function",0) end
local IILLjiOIOi=IoiIOLljO0ojij and IloOILoI(IoiIOLljO0ojij,Lil00oljl)
if IILLjiOIOi~=nil then
Llooji1jll[ijL11l1LO],Llooji1jll[ijL11l1LO+1],Llooji1jll[ijL11l1LO+2]=IILLjiOIOi(l0OiIl1011Li)
elseif iOoiIOjjoIIL(l0OiIl1011Li)==l1OlILOij0lIiL and (IoiIOLljO0ojij==nil or IloOILoI(IoiIOLljO0ojij,LLi0lILijl11OL)==nil) then
Llooji1jll[ijL11l1LO],Llooji1jll[ijL11l1LO+1],Llooji1jll[ijL11l1LO+2]=jil1lLIjo,l0OiIl1011Li,nil
end
end
elseif Lil1j0==12 then
local IILLjiOIOi
if l0IIlili1loLl==0 then IILLjiOIOi=jI100llIL1liO-ijL11l1LO else IILLjiOIOi=l0IIlili1loLl-1 end
local iOj1LoO10Ij={}
for l0OiIl1011Li=1,IILLjiOIOi do iOj1LoO10Ij[l0OiIl1011Li]=Llooji1jll[ijL11l1LO+l0OiIl1011Li-1] end
return ji001o1iOLO10(iOj1LoO10Ij,1,IILLjiOIOi)
elseif Lil1j0==22 then
Llooji1jll[ijL11l1LO]=(Llooji1jll[l0IIlili1loLl]<Llooji1jll[ioOjoliO0o])
elseif Lil1j0==24 then
Llooji1jll[ijL11l1LO]=(Llooji1jll[l0IIlili1loLl]==Llooji1jll[ioOjoliO0o])
elseif Lil1j0==19 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]
elseif Lil1j0==43 then
Llooji1jll[ijL11l1LO]={Llooji1jll[l0IIlili1loLl]}
elseif Lil1j0==18 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl][1]
elseif Lil1j0==3 then
Llooji1jll[ijL11l1LO]={}
elseif Lil1j0==27 then
for l0OiIl1011Li=ijL11l1LO,ijL11l1LO+2 do
Llooji1jll[l0OiIl1011Li]=IloLIo(Llooji1jll[l0OiIl1011Li])
if Llooji1jll[l0OiIl1011Li]==nil then II1lLI1i1ij11L("Numeric for bounds and step must be numbers",0) end
end
local IoiIOLljO0ojij=Llooji1jll[ijL11l1LO+2]
local IILLjiOIOi
if IoiIOLljO0ojij>0 then IILLjiOIOi=Llooji1jll[ijL11l1LO]<=Llooji1jll[ijL11l1LO+1] else IILLjiOIOi=Llooji1jll[ijL11l1LO]>=Llooji1jll[ijL11l1LO+1] end
if IILLjiOIOi then Llooji1jll[ijL11l1LO+3]=Llooji1jll[ijL11l1LO] else l0l01lIII0=l0IIlili1loLl+1 end
elseif Lil1j0==14 then
Llooji1jll[ijL11l1LO]=#Llooji1jll[l0IIlili1loLl]
elseif Lil1j0==15 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl][Llooji1jll[ioOjoliO0o]]
elseif Lil1j0==29 then
if (not not Llooji1jll[ijL11l1LO])==(l0IIlili1loLl~=0) then l0l01lIII0=ioOjoliO0o+1 end
elseif Lil1j0==32 then
Llooji1jll[ijL11l1LO]=(Llooji1jll[l0IIlili1loLl]~=Llooji1jll[ioOjoliO0o])
elseif Lil1j0==28 then
if l0IIlili1loLl==0 then
for l0OiIl1011Li=1,Io01LlIojlI do Llooji1jll[ijL11l1LO+l0OiIl1011Li-1]=iljIloIOO[l0OiIl1011Li] end
jI100llIL1liO=ijL11l1LO+Io01LlIojlI
else
for l0OiIl1011Li=1,l0IIlili1loLl-1 do Llooji1jll[ijL11l1LO+l0OiIl1011Li-1]=iljIloIOO[l0OiIl1011Li] end
end
elseif Lil1j0==38 then
local IoiIOLljO0ojij=Llooji1jll[ijL11l1LO]
local IIlOIillO=Llooji1jll[ijL11l1LO+1]
local Loj1L0i=Llooji1jll[ijL11l1LO+2]
local LLO011LI0=ljLjOioii(IoiIOLljO0ojij(IIlOIillO,Loj1L0i))
local ljIOojlj=LLO011LI0[1]
if ljIOojlj~=nil then
Llooji1jll[ijL11l1LO+2]=ljIOojlj
for l0OiIl1011Li=1,l0IIlili1loLl do Llooji1jll[ijL11l1LO+3+l0OiIl1011Li-1]=LLO011LI0[l0OiIl1011Li] end
l0l01lIII0=ioOjoliO0o+1
end
elseif Lil1j0==11 then
lOiIiliLi0lIoo[l0IIlili1loLl+1][1]=Llooji1jll[ijL11l1LO]
elseif Lil1j0==41 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]//Llooji1jll[ioOjoliO0o]
elseif Lil1j0==9 then
l0l01lIII0=l0IIlili1loLl+1
elseif Lil1j0==39 then
Llooji1jll[ijL11l1LO]=IjIOl1lijoiL(joljioloL,I01Oij10LO,l0IIlili1loLl+1,jLio0oLj[9])
elseif Lil1j0==36 then
Llooji1jll[ijL11l1LO][Llooji1jll[l0IIlili1loLl]]=Llooji1jll[ioOjoliO0o]
elseif Lil1j0==25 then
jj1jL000I1ol[IjIOl1lijoiL(joljioloL,I01Oij10LO,l0IIlili1loLl+1,jLio0oLj[9])]=Llooji1jll[ijL11l1LO]
elseif Lil1j0==44 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]-Llooji1jll[ioOjoliO0o]
elseif Lil1j0==8 then
Llooji1jll[ijL11l1LO]=(l0IIlili1loLl~=0)
elseif Lil1j0==5 then
local IoiIOLljO0ojij=LolLl11o1l[l0IIlili1loLl+1]
local iOj1LoO10Ij={}
local LLO011LI0=IoiIOLljO0ojij[6]
for l0OiIl1011Li=1,#LLO011LI0 do
local ljIOojlj=LLO011LI0[l0OiIl1011Li]
if ljIOojlj[1]==1 then iOj1LoO10Ij[l0OiIl1011Li]=Llooji1jll[ljIOojlj[2]] else iOj1LoO10Ij[l0OiIl1011Li]=lOiIiliLi0lIoo[ljIOojlj[2]+1] end
end
Llooji1jll[ijL11l1LO]=jI1ii11I1(IoiIOLljO0ojij,iOj1LoO10Ij)
elseif Lil1j0==13 then
Llooji1jll[ijL11l1LO]=(Llooji1jll[l0IIlili1loLl]<=Llooji1jll[ioOjoliO0o])
elseif Lil1j0==42 then
Llooji1jll[ijL11l1LO]=lOiIiliLi0lIoo[l0IIlili1loLl+1][1]
elseif Lil1j0==40 then
lj0iOoLjOO=(lj0iOoLjOO+l0IIlili1loLl)%(ioOjoliO0o+1)
elseif Lil1j0==4 then
local IILLjiOIOi
if l0IIlili1loLl==0 then IILLjiOIOi=jI100llIL1liO-ijL11l1LO-1 else IILLjiOIOi=l0IIlili1loLl end
local IoiIOLljO0ojij=Llooji1jll[ijL11l1LO]
for l0OiIl1011Li=1,IILLjiOIOi do IoiIOLljO0ojij[ioOjoliO0o+l0OiIl1011Li]=Llooji1jll[ijL11l1LO+l0OiIl1011Li] end
elseif Lil1j0==30 then
Llooji1jll[ijL11l1LO]=Llooji1jll[ijL11l1LO]+Llooji1jll[ijL11l1LO+2]
local IoiIOLljO0ojij=Llooji1jll[ijL11l1LO+2]
local IILLjiOIOi
if IoiIOLljO0ojij>0 then IILLjiOIOi=Llooji1jll[ijL11l1LO]<=Llooji1jll[ijL11l1LO+1] else IILLjiOIOi=Llooji1jll[ijL11l1LO]>=Llooji1jll[ijL11l1LO+1] end
if IILLjiOIOi then Llooji1jll[ijL11l1LO+3]=Llooji1jll[ijL11l1LO]; l0l01lIII0=l0IIlili1loLl+1 end
elseif Lil1j0==23 then
Llooji1jll[ijL11l1LO]=(Llooji1jll[l0IIlili1loLl]>Llooji1jll[ioOjoliO0o])
elseif Lil1j0==17 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]*Llooji1jll[ioOjoliO0o]
elseif Lil1j0==1 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]%Llooji1jll[ioOjoliO0o]
elseif Lil1j0==10 then
Llooji1jll[ijL11l1LO]=jj1jL000I1ol[IjIOl1lijoiL(joljioloL,I01Oij10LO,l0IIlili1loLl+1,jLio0oLj[9])]
elseif Lil1j0==31 then
Llooji1jll[ijL11l1LO+1]=Llooji1jll[l0IIlili1loLl]; Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl][Llooji1jll[ioOjoliO0o]]
elseif Lil1j0==20 then
Llooji1jll[l0IIlili1loLl][1]=Llooji1jll[ijL11l1LO]
elseif Lil1j0==16 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]+Llooji1jll[ioOjoliO0o]
elseif Lil1j0==26 then
for l0OiIl1011Li=ijL11l1LO,ijL11l1LO+l0IIlili1loLl do Llooji1jll[l0OiIl1011Li]=nil end
elseif Lil1j0==34 then
Llooji1jll[ijL11l1LO]=Llooji1jll[l0IIlili1loLl]..Llooji1jll[ioOjoliO0o]
elseif Lil1j0==6 then
Llooji1jll[ijL11l1LO]=-Llooji1jll[l0IIlili1loLl]
elseif Lil1j0==7 then
local IoiIOLljO0ojij=Llooji1jll[ijL11l1LO]
local IILLjiOIOi
if l0IIlili1loLl==0 then IILLjiOIOi=jI100llIL1liO-ijL11l1LO-1 else IILLjiOIOi=l0IIlili1loLl-1 end
local iOj1LoO10Ij={}
for l0OiIl1011Li=1,IILLjiOIOi do iOj1LoO10Ij[l0OiIl1011Li]=Llooji1jll[ijL11l1LO+l0OiIl1011Li] end
local LLO011LI0=ljLjOioii(IoiIOLljO0ojij(ji001o1iOLO10(iOj1LoO10Ij,1,IILLjiOIOi)))
if ioOjoliO0o==0 then
local ljIOojlj=LLO011LI0.n
for l0OiIl1011Li=1,ljIOojlj do Llooji1jll[ijL11l1LO+l0OiIl1011Li-1]=LLO011LI0[l0OiIl1011Li] end
jI100llIL1liO=ijL11l1LO+ljIOojlj
else
for l0OiIl1011Li=1,ioOjoliO0o-1 do Llooji1jll[ijL11l1LO+l0OiIl1011Li-1]=LLO011LI0[l0OiIl1011Li] end
end
else II1lLI1i1ij11L() end
end
return lj0iOoLjOO
end
return l1o1jil0OiL(jLio0oLj,{},ljLjOioii(...))
