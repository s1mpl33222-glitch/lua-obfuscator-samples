local lILiIij=(getfenv and getfenv(1)) or _ENV or _G
local LLloOij0Lj0ll,jjliL11lO111=string.byte,string.char
local function Ij1LoljI0I(iijI00O0,ilOoOli)
local iiO11IO0iiIL0j=""
local jloIIiOii=#ilOoOli
for IILiiooLOLjlo1=1,#iijI00O0 do iiO11IO0iiIL0j=iiO11IO0iiIL0j..jjliL11lO111((LLloOij0Lj0ll(iijI00O0,IILiiooLOLjlo1)-LLloOij0Lj0ll(ilOoOli,(IILiiooLOLjlo1-1)%jloIIiOii+1))%256) end
return iiO11IO0iiIL0j
end
local i0LLjILlIL=lILiIij[Ij1LoljI0I("vf6\193 w","\003\001\202\\\189")]
local lIL0oL0L1jL=lILiIij[Ij1LoljI0I("\202\138\184\008\239\218","W\022F\159\129s")][Ij1LoljI0I("\003\157c","\144(\001")]
local j01oo1jjjI0O0=lILiIij[Ij1LoljI0I("\212\204y\230\197","`k\023z")][Ij1LoljI0I("\193\198\230\211\009\221","^Wxp\168i\164")]
local iiloo0jLilioOi=lILiIij[Ij1LoljI0I("\148\246\161\149","'\149--k\236:")][Ij1LoljI0I("W\147\179\197c","\241'DV")]
local jjoLOO01Li=lILiIij[Ij1LoljI0I("\188\141\184\165+\004\181\186","H\030J0\190\162P")]
local jjlILI0II=lILiIij[Ij1LoljI0I("*\155\019\139\147","\197)\161\028!")]
local jLoO0o0i1OI=lILiIij[Ij1LoljI0I("\133e&\136","\017\236\182#\177\187")]
local jioLli00LLi=lILiIij[Ij1LoljI0I("\028\131\230.\026\146\2115\022\128\222&","\181\030r\193")]
local iIl0lILOi=lILiIij[Ij1LoljI0I("M\r\218\251*\203","\219\172c\148\197W\022")]
local ij1IIIoijiIOIj=lILiIij[Ij1LoljI0I("\200\134{?","Z!\003\203")]
local L11l0Li1ii1lI,jLl0ioIo,jj0LoiOijo0io0,j1I1Oioll0L=Ij1LoljI0I("hD\150N\190","\244\2274\226Y\136"),Ij1LoljI0I("\196\211\146sI\199\205\146","^^$\016\213"),Ij1LoljI0I("\006\024\241\198\144\176","\167\185\136R+>"),Ij1LoljI0I("1\011lU0\178","\210\172\009\244\196F$")
local i0OII0ol0oi0ol=LLloOij0Lj0ll("[")+(jjliL11lO111(81,68)=="QD" and 4653 or 55)+i0LLjILlIL("#",0,0,0,0,0)*27+jjoLOO01Li("6486")*2
local li1i1l0j0OLllL=lILiIij[Ij1LoljI0I("/U\189\157 ","\187\244[1")][Ij1LoljI0I("\184\203\172\189","HjIR\140")] or function(...) return {n=i0LLjILlIL("#",...),...} end
local Ii1oLji1l0IO=lILiIij[Ij1LoljI0I("\197\233F\001\030","Q\136\228\149\185\199")][Ij1LoljI0I("-\197\183i\027\194","\184WG\008")] or lILiIij[Ij1LoljI0I("\155\186\170\247\219;","&L:\150x\208")]
local IIO0LlLloILl="tTJY4bsju5X9hVR1/WQlyCx0IGScwe3FLz+imBKMpUEDn2vAgPrkod768NHfaOqZ"
local function jo1IlllooLj(IOo0iIOLLLo)
local lIiL1lL={}
for lilOo1L0oIj=1,64 do lIiL1lL[LLloOij0Lj0ll(IIO0LlLloILl,lilOo1L0oIj)]=lilOo1L0oIj-1 end
local ji0Lii1,Lj11Ijili,i0ljoj1iLl,ijjll1I={},0,0,0
for lilOo1L0oIj=1,#IOo0iIOLLLo do
local Lo0jli=lIiL1lL[LLloOij0Lj0ll(IOo0iIOLLLo,lilOo1L0oIj)]
if Lo0jli then
Lj11Ijili=Lj11Ijili*64+Lo0jli
i0ljoj1iLl=i0ljoj1iLl+6
if i0ljoj1iLl>=8 then i0ljoj1iLl=i0ljoj1iLl-8 ijjll1I=ijjll1I+1 ji0Lii1[ijjll1I]=jjliL11lO111(iiloo0jLilioOi(Lj11Ijili/(2^i0ljoj1iLl))%256) Lj11Ijili=Lj11Ijili%(2^i0ljoj1iLl) end
end
end
return j01oo1jjjI0O0(ji0Lii1)
end
local ILil101j1Oo11="PR0NQukWM/63sfo09DwVzU/OvcddT0ZaJJ1A06gGeryjcKytyPRPEmlELHcD69W7YFs9Vs8AVQU7PHFKGPiDfueSAovI5+OFVE2luklXA92jwUFXqbfGsopxpEBmK6UghAZQpFO8XvXN/42hMCLE1SrCYKx6wK3gomq/8/jf0t15qjctkR+zib1yzBZFbVOA6LSdc5We0x4llWTkcdzfYHYqSVrLQZH+PKT5SMv+ewjndZshic5EClcYzZwZAvShKEvl4Wmn1QAslRrmNP2FCb93DXiAuWkmELKuLkQ+wLrtdDD0cKRA/NYynrW5tjvbZhveQ2r0E3wPs/ok2Kc0tc4Wg4o1JJEaZAT73rp8ztvTNq2ZLo+D9C4SmR+wnq2Q3WG/cepx9TaukeAYCOQwOyiu4xVnjd8hfOXt16cpYX5IgVGfM0DBa5qBS5mVR/FzWtaQByIMplthLpQsOygi0ckEuQ4CFl7hG7AE4cTwmJyJ+KkXZmjv3w+40p4D8djfeatgDjdFjNOoNSL3l9CDJC52b0OlmP/cKLwnE2KgjPpErQWEzLyeiovmZonuZzuUv6uMzpKvFLZ3W/Ecs3ZAp7SNg/K6KY1G/m/OaazH2yZWMbCfK9JweuLIKnceGDlW99sacDy0Z4ZCAD+LKdw+4wTrO/o6oCxsgR+AcJ2CMk8XKWql3wO7F5CP0sfsd4OHrMiHsAVRJtiy/O/7RAY0Z/HdGn3saqmlkaVJsHo/YLT6qIAhDIteiriMK7NEeHMbaRBQsF2SpWfgASKnVGrb1TX9ZbLSTZwULgdWi76xHpLW+Tdz7JXsmUk5/KMf+i4GaWAXsSDnFMeoTqux7VRlJS5lZGjunskIxGLWB0dNle6pTVf4TgmEiKvqlUQVl7Ir6mIaYGuDRt+zrwtJF7q9itTNSEfS9RdIrLwgtngyBuidt1HIIWhocnK8J/F3bxlDyDPiQYAZQ0VpJqjCNuAfshctmOPjF+mPIQAEPl2nLtTtuQC2TYVpD8vulRBIRceZSbAStUHc8j5ES8zvZD4ADUPTCS7ldJl56/ca9o4Jngdlw+V/l6vmVPSm4eM1R8AkOPg4Kjal7W/bR5arl2uALLiH2+wd8jumTXqRLqF6ukHUAOIVggyNDaVH5HY17m+da7BCCvcEOjqAjb478bb5XxXFFuFeTjKziXyQ0DHcXNlIB2B+YKPSWSlPZI4X4x+VlL4S+Dybsl3f3jpmjPPVMHVs9gScpX7dmqg1BshW/d7GqgA+pBVpb/kD9CDLgXEWWo2OTJHCUZmXCmqN/7iuzXB9pbmdx/EiLOthM9nZjgciYMnHVtrn0Ni2IaDLfJ8Fm2YIY8f3oNRIM2NJ4EuyGE4JkflgJ5hTP3+HXkvVK5iBrbi/lqs5+aTueZ7vIqzOxXAnxg4im8pyPv0MPMevH5jr7ag7OqqbK3DO"
local function L1ljl0oLil1(l0OIL001j)
if #l0OIL001j~=1083 then jjlILI0II("VM integrity check failed",0) end
local IIjioOlLL=(955318810)+i0OII0ol0oi0ol
local ILIOI01LiLLIio=121
local Io1Lol1l={}
local L01IiL0,LiOiIl101LoIL=1,0
for ilIoL1=1,#l0OIL001j do
IIjioOlLL=(IIjioOlLL*38601+1916614647)%4294967296
local iLIIIO0Ilj=LLloOij0Lj0ll(l0OIL001j,ilIoL1)
local Io0ijIil0=(iiloo0jLilioOi(IIjioOlLL/65536)+ILIOI01LiLLIio+(ilIoL1-1)*236)%256
local j1joLlj00=(iLIIIO0Ilj-Io0ijIil0)%256
Io1Lol1l[ilIoL1]=jjliL11lO111(j1joLlj00)
L01IiL0=(L01IiL0*257+j1joLlj00+1)%4294967291
LiOiIl101LoIL=(LiOiIl101LoIL*65599+j1joLlj00+1)%4294967279
ILIOI01LiLLIio=(ILIOI01LiLLIio*53+iLIIIO0Ilj+1)%251
end
if L01IiL0~=2516988818 or LiOiIl101LoIL~=996057693 then jjlILI0II("VM integrity check failed",0) end
return j01oo1jjjI0O0(Io1Lol1l)
end
local IIO0i1ol=L1ljl0oLil1(jo1IlllooLj(ILil101j1Oo11))
local iLIIIO0Ilj=1
local function j0lliL0ll0L0j(ilIoL1)
if ilIoL1<0 or iLIIIO0Ilj+ilIoL1-1>#IIO0i1ol then jjlILI0II("VM payload is truncated",0) end
end
local function LiloI1()
j0lliL0ll0L0j(1)
local ilIoL1=LLloOij0Lj0ll(IIO0i1ol,iLIIIO0Ilj)
iLIIIO0Ilj=iLIIIO0Ilj+1
return ilIoL1
end
local function iliI1lLiiiIl()
j0lliL0ll0L0j(2)
local ilIoL1,j1joLlj00=LLloOij0Lj0ll(IIO0i1ol,iLIIIO0Ilj,iLIIIO0Ilj+1)
iLIIIO0Ilj=iLIIIO0Ilj+2
return ilIoL1+j1joLlj00*256
end
local function Lj0LOo0I()
j0lliL0ll0L0j(4)
local ilIoL1,j1joLlj00,l0OIL001j,Io1Lol1l=LLloOij0Lj0ll(IIO0i1ol,iLIIIO0Ilj,iLIIIO0Ilj+3)
iLIIIO0Ilj=iLIIIO0Ilj+4
return ilIoL1+j1joLlj00*256+l0OIL001j*65536+Io1Lol1l*16777216
end
local function i11oll()
local ilIoL1=Lj0LOo0I()
j0lliL0ll0L0j(ilIoL1)
local j1joLlj00=lIL0oL0L1jL(IIO0i1ol,iLIIIO0Ilj,iLIIIO0Ilj+ilIoL1-1)
iLIIIO0Ilj=iLIIIO0Ilj+ilIoL1
return j1joLlj00
end
local function LojoIOliO0j1lj()
local ilIoL1=LiloI1()
local j1joLlj00=i11oll()
if ilIoL1==0 then return jjoLOO01Li(j1joLlj00)
elseif ilIoL1==1 then return j1joLlj00
elseif ilIoL1==2 then return 1/0
elseif ilIoL1==3 then return -1/0
else return 0/0 end
end
local function LL100il(lOioij)
if lOioij>200 then jjlILI0II("VM function nesting limit exceeded",0) end
local L0iOiLiLI=LiloI1()
local ilIoL1=LiloI1()
if ilIoL1>1 then jjlILI0II("VM invalid function flags",0) end
local li1IIijIO=Lj0LOo0I()
local jI0LLlljO=li1IIijIO%65536
local j1joLlj00=iliI1lLiiiIl()
local IoOL0OlLLLIL={}
for l0OIL001j=1,j1joLlj00 do local Ii0IIi=iliI1lLiiiIl() IoOL0OlLLLIL[l0OIL001j]={Ii0IIi,i11oll()} end
local Io1Lol1l=Lj0LOo0I()
j0lliL0ll0L0j(Io1Lol1l*12)
local iojOl0IO0oj01O={}
for l0OIL001j=1,Io1Lol1l do
iojOl0IO0oj01O[l0OIL001j]={Lj0LOo0I(),iliI1lLiiiIl(),iliI1lLiiiIl(),Lj0LOo0I()}
for l0ijl0I=1,4 do jI0LLlljO=(jI0LLlljO*131+iojOl0IO0oj01O[l0OIL001j][l0ijl0I]%65536+l0ijl0I)%65536 end
end
local iLIIIO0Ilj=iliI1lLiiiIl()
local Lloo11L0={}
for l0OIL001j=1,iLIIIO0Ilj do Lloo11L0[l0OIL001j]=LL100il(lOioij+1) end
local ILoOiiLOiL1=iliI1lLiiiIl()
local loo1jIoojljIl={}
for l0OIL001j=1,ILoOiiLOiL1 do loo1jIoojljIl[l0OIL001j]={LiloI1(),iliI1lLiiiIl()} end
return {L0iOiLiLI,ilIoL1,iojOl0IO0oj01O,IoOL0OlLLLIL,Lloo11L0,loo1jIoojljIl,{},li1IIijIO,(i0OII0ol0oi0ol+53800+jI0LLlljO)%65536}
end
local function lliilOoIoiILlo(jloIL0Ojoi,Li0OOl,Ii0IIi,j100OO1oj1l0)
if Li0OOl[Ii0IIi]~=nil then return Li0OOl[Ii0IIi] end
local IOo0iIOLLLo=jloIL0Ojoi[Ii0IIi]
local lIiL1lL=IOo0iIOLLLo[1]
local lilOo1L0oIj=IOo0iIOLLLo[2]
local ji0Lii1=(j100OO1oj1l0+lIiL1lL*251+1)%65536
local Lj11Ijili={}
for i0ljoj1iLl=1,#lilOo1L0oIj do
ji0Lii1=(ji0Lii1*40503+12345)%65536
Lj11Ijili[i0ljoj1iLl]=jjliL11lO111((LLloOij0Lj0ll(lilOo1L0oIj,i0ljoj1iLl)-iiloo0jLilioOi(ji0Lii1/256)%256-i0ljoj1iLl*(j100OO1oj1l0%256))%256)
end
local ijjll1I=j01oo1jjjI0O0(Lj11Ijili)
if #ijjll1I<5 then jjlILI0II("VM invalid constant",0) end
local Lo0jli=LLloOij0Lj0ll(ijjll1I,1)
local j00lliIilLOOL1=LLloOij0Lj0ll(ijjll1I,2)+LLloOij0Lj0ll(ijjll1I,3)*256+LLloOij0Lj0ll(ijjll1I,4)*65536+LLloOij0Lj0ll(ijjll1I,5)*16777216
if j00lliIilLOOL1~=#ijjll1I-5 or Lo0jli>4 then jjlILI0II("VM invalid constant",0) end
local iillLILjL0l=lIL0oL0L1jL(ijjll1I,6,5+j00lliIilLOOL1)
local Lll0LIi
if Lo0jli==0 then Lll0LIi=jjoLOO01Li(iillLILjL0l) elseif Lo0jli==1 then Lll0LIi=iillLILjL0l elseif Lo0jli==2 then Lll0LIi=1/0 elseif Lo0jli==3 then Lll0LIi=-1/0 else Lll0LIi=0/0 end
Li0OOl[Ii0IIi]=Lll0LIi
return Lll0LIi
end
local LollLOiLioi={}
local LlI0oL0=iliI1lLiiiIl()
for lLi10OOoO=1,LlI0oL0 do local ilIoL1=iliI1lLiiiIl() local j1joLlj00=iliI1lLiiiIl() LollLOiLioi[ilIoL1]=j1joLlj00 end
local jOOliI0ojLooLO=LL100il(0)
if iLIIIO0Ilj~=#IIO0i1ol+1 then jjlILI0II("VM trailing payload data",0) end
IIO0i1ol=nil
ILil101j1Oo11=nil
local LL1IiLiOILI0
local function iO0Ii1OiO10ILL(jOOliI0ojLooLO,loo1jIoojljIl)
return function(...) return LL1IiLiOILI0(jOOliI0ojLooLO,loo1jIoojljIl,li1i1l0j0OLllL(...)) end
end
LL1IiLiOILI0=function(jOOliI0ojLooLO,loo1jIoojljIl,lOll1O0o0IOI)
local IoIi0LOLIo0i={}
local jjliLolo00iI=0
local L0iOiLiLI=jOOliI0ojLooLO[1]
local ILi111li100jiI=lOll1O0o0IOI.n
for ilIoL1=1,L0iOiLiLI do IoIi0LOLIo0i[ilIoL1-1]=lOll1O0o0IOI[ilIoL1] end
local iIiiOljLL,jI00oOjolliOLj={},0
if jOOliI0ojLooLO[2]==1 then jI00oOjolliOLj=ILi111li100jiI-L0iOiLiLI; if jI00oOjolliOLj<0 then jI00oOjolliOLj=0 end; for ilIoL1=1,jI00oOjolliOLj do iIiiOljLL[ilIoL1]=lOll1O0o0IOI[L0iOiLiLI+ilIoL1] end end
local iojOl0IO0oj01O,IoOL0OlLLLIL,Lloo11L0=jOOliI0ojLooLO[3],jOOliI0ojLooLO[4],jOOliI0ojLooLO[5]
local LilLl0Oo0iL=jOOliI0ojLooLO[7]
local LIjIooIiOoo=1
local ILoOiiLOiL1=0
while true do
local iLOlj0lllI1ili=iojOl0IO0oj01O[LIjIooIiOoo]
if iLOlj0lllI1ili==nil then jjlILI0II("VM invalid instruction address",0) end
local iI1OjIjI0j=(jOOliI0ojLooLO[8]+LIjIooIiOoo*65599)%4294967296
LIjIooIiOoo=LIjIooIiOoo+1
iI1OjIjI0j=(iI1OjIjI0j*1664525+1013904223)%4294967296
local lOiolLO0IjIO=(iLOlj0lllI1ili[3]-iI1OjIjI0j)%65536
iI1OjIjI0j=(iI1OjIjI0j*1664525+1013904223)%4294967296
local ilIoL1=(iLOlj0lllI1ili[2]-iI1OjIjI0j)%65536
iI1OjIjI0j=(iI1OjIjI0j*1664525+1013904223)%4294967296
local j1joLlj00=(iLOlj0lllI1ili[4]-iI1OjIjI0j)%4294967296
iI1OjIjI0j=(iI1OjIjI0j*1664525+1013904223)%4294967296
local l0OIL001j=(iLOlj0lllI1ili[1]-iI1OjIjI0j)%4294967296
local Io1Lol1l=LollLOiLioi[lOiolLO0IjIO]
if (LIjIooIiOoo%2)*(LIjIooIiOoo%2)-(LIjIooIiOoo%2)~=0 then jjliLolo00iI=jjliLolo00iI+5 end
if (Io1Lol1l*Io1Lol1l)%4==2 then jjliLolo00iI=jjliLolo00iI+6 end
if (Io1Lol1l*Io1Lol1l+Io1Lol1l)%2==1 then jjliLolo00iI=jjliLolo00iI-5 end
if Io1Lol1l==26 then
local lIiL1lL=IoIi0LOLIo0i[ilIoL1]
local lilOo1L0oIj
if j1joLlj00==0 then lilOo1L0oIj=ILoOiiLOiL1-ilIoL1-1 else lilOo1L0oIj=j1joLlj00-1 end
local ji0Lii1={}
for IOo0iIOLLLo=1,lilOo1L0oIj do ji0Lii1[IOo0iIOLLLo]=IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo] end
local Lj11Ijili=li1i1l0j0OLllL(lIiL1lL(Ii1oLji1l0IO(ji0Lii1,1,lilOo1L0oIj)))
if l0OIL001j==0 then
local i0ljoj1iLl=Lj11Ijili.n
for IOo0iIOLLLo=1,i0ljoj1iLl do IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo-1]=Lj11Ijili[IOo0iIOLLLo] end
ILoOiiLOiL1=ilIoL1+i0ljoj1iLl
else
for IOo0iIOLLLo=1,l0OIL001j-1 do IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo-1]=Lj11Ijili[IOo0iIOLLLo] end
end
elseif Io1Lol1l==38 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[ilIoL1]+IoIi0LOLIo0i[ilIoL1+2]
local lIiL1lL=IoIi0LOLIo0i[ilIoL1+2]
local lilOo1L0oIj
if lIiL1lL>0 then lilOo1L0oIj=IoIi0LOLIo0i[ilIoL1]<=IoIi0LOLIo0i[ilIoL1+1] else lilOo1L0oIj=IoIi0LOLIo0i[ilIoL1]>=IoIi0LOLIo0i[ilIoL1+1] end
if lilOo1L0oIj then IoIi0LOLIo0i[ilIoL1+3]=IoIi0LOLIo0i[ilIoL1]; LIjIooIiOoo=j1joLlj00+1 end
elseif Io1Lol1l==5 then
if (not not IoIi0LOLIo0i[ilIoL1])==(j1joLlj00~=0) then LIjIooIiOoo=l0OIL001j+1 end
elseif Io1Lol1l==19 then
IoIi0LOLIo0i[ilIoL1][IoIi0LOLIo0i[j1joLlj00]]=IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==11 then
IoIi0LOLIo0i[ilIoL1]=(IoIi0LOLIo0i[j1joLlj00]~=IoIi0LOLIo0i[l0OIL001j])
elseif Io1Lol1l==20 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]*IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==21 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]+IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==37 then
local lIiL1lL=Lloo11L0[j1joLlj00+1]
local ji0Lii1={}
local Lj11Ijili=lIiL1lL[6]
for IOo0iIOLLLo=1,#Lj11Ijili do
local i0ljoj1iLl=Lj11Ijili[IOo0iIOLLLo]
if i0ljoj1iLl[1]==1 then ji0Lii1[IOo0iIOLLLo]=IoIi0LOLIo0i[i0ljoj1iLl[2]] else ji0Lii1[IOo0iIOLLLo]=loo1jIoojljIl[i0ljoj1iLl[2]+1] end
end
IoIi0LOLIo0i[ilIoL1]=iO0Ii1OiO10ILL(lIiL1lL,ji0Lii1)
elseif Io1Lol1l==23 then
loo1jIoojljIl[j1joLlj00+1][1]=IoIi0LOLIo0i[ilIoL1]
elseif Io1Lol1l==16 then
IoIi0LOLIo0i[ilIoL1]={IoIi0LOLIo0i[j1joLlj00]}
elseif Io1Lol1l==35 then
IoIi0LOLIo0i[j1joLlj00][1]=IoIi0LOLIo0i[ilIoL1]
elseif Io1Lol1l==9 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]-IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==25 then
IoIi0LOLIo0i[ilIoL1]=lILiIij[lliilOoIoiILlo(IoOL0OlLLLIL,LilLl0Oo0iL,j1joLlj00+1,jOOliI0ojLooLO[9])]
elseif Io1Lol1l==15 then
IoIi0LOLIo0i[ilIoL1]=#IoIi0LOLIo0i[j1joLlj00]
elseif Io1Lol1l==4 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00][IoIi0LOLIo0i[l0OIL001j]]
elseif Io1Lol1l==28 then
for IOo0iIOLLLo=ilIoL1,ilIoL1+2 do
IoIi0LOLIo0i[IOo0iIOLLLo]=jjoLOO01Li(IoIi0LOLIo0i[IOo0iIOLLLo])
if IoIi0LOLIo0i[IOo0iIOLLLo]==nil then jjlILI0II("Numeric for bounds and step must be numbers",0) end
end
local lIiL1lL=IoIi0LOLIo0i[ilIoL1+2]
local lilOo1L0oIj
if lIiL1lL>0 then lilOo1L0oIj=IoIi0LOLIo0i[ilIoL1]<=IoIi0LOLIo0i[ilIoL1+1] else lilOo1L0oIj=IoIi0LOLIo0i[ilIoL1]>=IoIi0LOLIo0i[ilIoL1+1] end
if lilOo1L0oIj then IoIi0LOLIo0i[ilIoL1+3]=IoIi0LOLIo0i[ilIoL1] else LIjIooIiOoo=j1joLlj00+1 end
elseif Io1Lol1l==44 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00][1]
elseif Io1Lol1l==8 then
local lIiL1lL=IoIi0LOLIo0i[ilIoL1]
local ijjll1I=IoIi0LOLIo0i[ilIoL1+1]
local Lo0jli=IoIi0LOLIo0i[ilIoL1+2]
local Lj11Ijili=li1i1l0j0OLllL(lIiL1lL(ijjll1I,Lo0jli))
local i0ljoj1iLl=Lj11Ijili[1]
if i0ljoj1iLl~=nil then
IoIi0LOLIo0i[ilIoL1+2]=i0ljoj1iLl
for IOo0iIOLLLo=1,j1joLlj00 do IoIi0LOLIo0i[ilIoL1+3+IOo0iIOLLLo-1]=Lj11Ijili[IOo0iIOLLLo] end
LIjIooIiOoo=l0OIL001j+1
end
elseif Io1Lol1l==14 then
local IOo0iIOLLLo=IoIi0LOLIo0i[ilIoL1]
if jLoO0o0i1OI(IOo0iIOLLLo)~=jLl0ioIo then
local lIiL1lL=jioLli00LLi(IOo0iIOLLLo)
if lIiL1lL~=nil and jLoO0o0i1OI(lIiL1lL)~=L11l0Li1ii1lI then jjlILI0II("Protected iterator metatables require an explicit iterator function",0) end
local lilOo1L0oIj=lIiL1lL and iIl0lILOi(lIiL1lL,jj0LoiOijo0io0)
if lilOo1L0oIj~=nil then
IoIi0LOLIo0i[ilIoL1],IoIi0LOLIo0i[ilIoL1+1],IoIi0LOLIo0i[ilIoL1+2]=lilOo1L0oIj(IOo0iIOLLLo)
elseif jLoO0o0i1OI(IOo0iIOLLLo)==L11l0Li1ii1lI and (lIiL1lL==nil or iIl0lILOi(lIiL1lL,j1I1Oioll0L)==nil) then
IoIi0LOLIo0i[ilIoL1],IoIi0LOLIo0i[ilIoL1+1],IoIi0LOLIo0i[ilIoL1+2]=ij1IIIoijiIOIj,IOo0iIOLLLo,nil
end
end
elseif Io1Lol1l==31 then
IoIi0LOLIo0i[ilIoL1]=not IoIi0LOLIo0i[j1joLlj00]
elseif Io1Lol1l==32 then
IoIi0LOLIo0i[ilIoL1]=(IoIi0LOLIo0i[j1joLlj00]>=IoIi0LOLIo0i[l0OIL001j])
elseif Io1Lol1l==6 then
IoIi0LOLIo0i[ilIoL1]=(IoIi0LOLIo0i[j1joLlj00]<IoIi0LOLIo0i[l0OIL001j])
elseif Io1Lol1l==43 then
local lilOo1L0oIj
if j1joLlj00==0 then lilOo1L0oIj=ILoOiiLOiL1-ilIoL1 else lilOo1L0oIj=j1joLlj00-1 end
local ji0Lii1={}
for IOo0iIOLLLo=1,lilOo1L0oIj do ji0Lii1[IOo0iIOLLLo]=IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo-1] end
return Ii1oLji1l0IO(ji0Lii1,1,lilOo1L0oIj)
elseif Io1Lol1l==42 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]..IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==10 then
LIjIooIiOoo=j1joLlj00+1
elseif Io1Lol1l==39 then
IoIi0LOLIo0i[ilIoL1]=(IoIi0LOLIo0i[j1joLlj00]<=IoIi0LOLIo0i[l0OIL001j])
elseif Io1Lol1l==36 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]
elseif Io1Lol1l==18 then
if j1joLlj00==0 then
for IOo0iIOLLLo=1,jI00oOjolliOLj do IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo-1]=iIiiOljLL[IOo0iIOLLLo] end
ILoOiiLOiL1=ilIoL1+jI00oOjolliOLj
else
for IOo0iIOLLLo=1,j1joLlj00-1 do IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo-1]=iIiiOljLL[IOo0iIOLLLo] end
end
elseif Io1Lol1l==1 then
for IOo0iIOLLLo=ilIoL1,ilIoL1+j1joLlj00 do IoIi0LOLIo0i[IOo0iIOLLLo]=nil end
elseif Io1Lol1l==30 then
IoIi0LOLIo0i[ilIoL1]=-IoIi0LOLIo0i[j1joLlj00]
elseif Io1Lol1l==13 then
IoIi0LOLIo0i[ilIoL1]=(IoIi0LOLIo0i[j1joLlj00]>IoIi0LOLIo0i[l0OIL001j])
elseif Io1Lol1l==29 then
IoIi0LOLIo0i[ilIoL1]=(j1joLlj00~=0)
elseif Io1Lol1l==40 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]/IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==34 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]^IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==24 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]//IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==2 then
IoIi0LOLIo0i[ilIoL1]=(IoIi0LOLIo0i[j1joLlj00]==IoIi0LOLIo0i[l0OIL001j])
elseif Io1Lol1l==12 then
IoIi0LOLIo0i[ilIoL1+1]=IoIi0LOLIo0i[j1joLlj00]; IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00][IoIi0LOLIo0i[l0OIL001j]]
elseif Io1Lol1l==7 then
IoIi0LOLIo0i[ilIoL1]=lliilOoIoiILlo(IoOL0OlLLLIL,LilLl0Oo0iL,j1joLlj00+1,jOOliI0ojLooLO[9])
elseif Io1Lol1l==27 then
lILiIij[lliilOoIoiILlo(IoOL0OlLLLIL,LilLl0Oo0iL,j1joLlj00+1,jOOliI0ojLooLO[9])]=IoIi0LOLIo0i[ilIoL1]
elseif Io1Lol1l==22 then
IoIi0LOLIo0i[ilIoL1]=loo1jIoojljIl[j1joLlj00+1][1]
elseif Io1Lol1l==17 then
jjliLolo00iI=(jjliLolo00iI+j1joLlj00)%(l0OIL001j+1)
elseif Io1Lol1l==41 then
IoIi0LOLIo0i[ilIoL1]={}
elseif Io1Lol1l==33 then
IoIi0LOLIo0i[ilIoL1]=IoIi0LOLIo0i[j1joLlj00]%IoIi0LOLIo0i[l0OIL001j]
elseif Io1Lol1l==3 then
local lilOo1L0oIj
if j1joLlj00==0 then lilOo1L0oIj=ILoOiiLOiL1-ilIoL1-1 else lilOo1L0oIj=j1joLlj00 end
local lIiL1lL=IoIi0LOLIo0i[ilIoL1]
for IOo0iIOLLLo=1,lilOo1L0oIj do lIiL1lL[l0OIL001j+IOo0iIOLLLo]=IoIi0LOLIo0i[ilIoL1+IOo0iIOLLLo] end
else jjlILI0II() end
end
return jjliLolo00iI
end
return LL1IiLiOILI0(jOOliI0ojLooLO,{},li1i1l0j0OLllL(...))
