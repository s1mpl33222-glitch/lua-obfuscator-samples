local LOj0lillooLjjL=(getfenv and getfenv(1)) or _ENV or _G
local iOILj1iOlLjjL,ijI1LIl=string.byte,string.char
local function jIiOiOL1O1(lO0O1jiO01I,jjIoII0Ilol)
local ljjILj0IO=""
local ioIll0lIL=#jjIoII0Ilol
for iOiOOI=1,#lO0O1jiO01I do ljjILj0IO=ljjILj0IO..ijI1LIl((iOILj1iOlLjjL(lO0O1jiO01I,iOiOOI)-iOILj1iOlLjjL(jjIoII0Ilol,(iOiOOI-1)%ioIll0lIL+1))%256) end
return ljjILj0IO
end
local LoOi00=LOj0lillooLjjL[jIiOiOL1O1("\192\2184\220dy","Mu\200w\001\005")]
local lLi1o00=LOj0lillooLjjL[jIiOiOL1O1("KJ^ADS","\216\214\236")][jIiOiOL1O1(",<\129","\185\199\031")]
local IOO0j0oj0ioL=LOj0lillooLjjL[jIiOiOL1O1("Y\144\1515f","\229/5\201\001\211")][jIiOiOL1O1("\186;b\238,\249","W\204\244\139\203\133")]
local I0ioOl1=LOj0lillooLjjL[jIiOiOL1O1("\215o\024z","j\014\164\018")][jIiOiOL1O1("\133\155 \142\161","\031/\177")]
local ljL1LLI0o1o1oI=LOj0lillooLjjL[jIiOiOL1O1("\246\012>\017\023\1599\244","\130\157\208\156\170=\212")]
local i0liOo=LOj0lillooLjjL[jIiOiOL1O1("@7aJ7","\219\197\239")]
local ljOOj1i1LjILl0=LOj0lillooLjjL[jIiOiOL1O1("\170\226m\177","6i\253L>\193")]
local llOiL1ioiI1ll=LOj0lillooLjjL[jIiOiOL1O1("5\214\194\006MB\210\194\250J:\214","\206qN\153\232")]
local lLllOjO00lLj=LOj0lillooLjjL[jIiOiOL1O1("\130\196\203\220a\132","\016cTu\252")]
local ljLL0illOo1O1=LOj0lillooLjjL[jIiOiOL1O1("\245U\189\251","\135\240E")]
local jLIo0o1iL1iOoo,iIO10Ioj0,lI0LLjoI,IjIiioji1000=jIiOiOL1O1("xW\247vi","\004\246\149\n"),jIiOiOL1O1("\247\236z\244\235u\000\229","\145w\012"),jIiOiOL1O1("\027p\236x!\131","\188\017\131\004"),jIiOiOL1O1("\250\026\235\028\237\009","\155\187\136\187\129\157\174")
local llO0III10OOII=ljL1LLI0o1o1oI("164")*1+LoOi00("#",0,0,0)*15+iOILj1iOlLjjL(";")+(ijI1LIl(85,72)=="UH" and 8484 or 25)
local iLjjlioOO0=LOj0lillooLjjL[jIiOiOL1O1("Z\2473R\251","\230\150\209")][jIiOiOL1O1("\187e\r\141","K\004\170\" L")] or function(...) return {n=LoOi00("#",...),...} end
local jlij1ilLi=LOj0lillooLjjL[jIiOiOL1O1("\n=\228\127\n","\150\220\130\019\165\248)")][jIiOiOL1O1("\191\182L,\173\179","JH\220\203")] or LOj0lillooLjjL[jIiOiOL1O1("_\221\212@\216B","\234od\223u\215\189")]
local L0iOIoLO="E7Dk6q8295yr0FXYo4snbiKCPL3ZBOIjeVWgUQARphz+S1/HtaGmlJcdfwMuNxvT"
local function ljolol1L01o1Li(iLOiII10Iji0)
local jLOili1ILj={}
for iiljLiiOjl1iO=1,64 do jLOili1ILj[iOILj1iOlLjjL(L0iOIoLO,iiljLiiOjl1iO)]=iiljLiiOjl1iO-1 end
local i1ll0jlIiL,iIooLl,llIloOLOl,IL01LLllj00L0={},0,0,0
for iiljLiiOjl1iO=1,#iLOiII10Iji0 do
local Lo1jlo=jLOili1ILj[iOILj1iOlLjjL(iLOiII10Iji0,iiljLiiOjl1iO)]
if Lo1jlo then
iIooLl=iIooLl*64+Lo1jlo
llIloOLOl=llIloOLOl+6
if llIloOLOl>=8 then llIloOLOl=llIloOLOl-8 IL01LLllj00L0=IL01LLllj00L0+1 i1ll0jlIiL[IL01LLllj00L0]=ijI1LIl(I0ioOl1(iIooLl/(2^llIloOLOl))%256) iIooLl=iIooLl%(2^llIloOLOl) end
end
end
return IOO0j0oj0ioL(i1ll0jlIiL)
end
local I0ioiOIl="ENAd19rU7gWhQv76mIuHs9WjWWavbXktK9M30q0NJHkiayz9rUQd+G2YS74orRSqemnFq+nU/o4Tfx2KJ5caizrQvyfMpfBit5MMU9Gz7u4vNUdajDPAfuzybP25/tDI36OrQaPCEeHZcqg6ehDzx1Q/ZPQMO6esdLyrMksZFJF6SdfG0yJW+FXykjDb0dkT7yamJTVHNj6GJtSGR/wIpzrMZFpqeywhOKRxX89uLd/Mhbc8/BEV81MmNQb4dJOgavf/z33LhngomzYPRpr0wFZ/eGE0LY+tBHNuMCJYntB8ViebrPn3GsffTlyJlO1x52qdc2kcKr4/AYLgvu0j4pR1Z/ACfC47RBooebPFzf5XpgEdTF0gu+/OzphrRNjLyhrCXwuB+icbT1kn6A+NGg2s31qe4rXsSFWge/BZFSwxGZqBBEerEF+45e/rYv5ewNbhj/EIRHCERwyPNJe/8UXxD3W9FgG2bIKEf4KgPTDAtXhy+CZXsH38m/3jrPS7SDGuqtfyhpLunk/NCSqpJStysL9hw9t4llKM0gqLvpKGEe94op5x3J8GnHgKEhMFR7c6ensfAAaiMteQXyO4oZdvFI9u9kDkiMFllmLyAALgnsJmxPkL8Tls6HHH/hmQ9sMCmTI3oKYjU2U5TfefFN41Hht+PKpzvh1hHNhejCKcHJ6dy7H+LQZbSEjvAMbMEy6LmaNLK3IKtUMOzPI1gD+pexLSmbqivqVkhdzfifcQPE7x709y1C7/OvEtnhe4Bhd06l2XyiijaUspJWR29ylatPsHDMuRRcTN8uo+iSchwwZozIK4bDXVX5akLocAJqUnRpW/4DwnOwUud4kgfS5gjKzftBpJLuu44MpXnlIqrvVzAObHHocnTU11xSEZtpNEvhUIGzHZK516ok26N1hQMSE2oHGIPFm9o75jRotGYUxhytEo2ukv1nBfmrLtyPP3Ikwim3bzTeSHO3z8/KC1V0s9dX/UhXq7zMFOdCfNPsqiZfS2wPC+pAD+TEeOe2Rvka9NHsQqwohV85BcOq7/6tPMyuRWjg4BotITWY/Tz93me03TPkGsvE24/tRQyA5Eq6fRR1Zyb6lSP7PkLIWg76MOQjnK+ynOUdEx9pXSDXNdtzkGftixyrsUr/61uYuiGz8DSMpig/KpcaAFmgy9oglEdKvNkoegISI0MdpZDRgGGFhamRfPUaQvqzP8nE0ExmWKe9NZRJWwN/Mq02Usd1avRKvXL6M8e5C3WVRcHsd8SoyJlyT5dSCQuy304EY0W3BT3BEISPqsYNn5sY50OFRXAbo49IzghFfWeNT9Tl8oayckZQsBe/QUw1Xp6ZjM8KQd"
local function ij0o0i(ijiLilIilil0)
if #ijiLilIilil0~=1014 then i0liOo("VM integrity check failed",0) end
local L10i10oo=(448158177)+llO0III10OOII
local IiolilIIOioj01=210
local i0j1OLLLOLo0={}
local ioLO0I0oOLOIlL,LOiliOL100oi=1,0
for I0Oj0i1oI1I1oo=1,#ijiLilIilil0 do
L10i10oo=(L10i10oo*25353+2772581939)%4294967296
local L0lii0O=iOILj1iOlLjjL(ijiLilIilil0,I0Oj0i1oI1I1oo)
local jI10ijoi1o1li=(I0ioOl1(L10i10oo/65536)+IiolilIIOioj01+(I0Oj0i1oI1I1oo-1)*161)%256
local iO1iO1o10L=(L0lii0O-jI10ijoi1o1li)%256
i0j1OLLLOLo0[I0Oj0i1oI1I1oo]=ijI1LIl(iO1iO1o10L)
ioLO0I0oOLOIlL=(ioLO0I0oOLOIlL*257+iO1iO1o10L+1)%4294967291
LOiliOL100oi=(LOiliOL100oi*65599+iO1iO1o10L+1)%4294967279
IiolilIIOioj01=(IiolilIIOioj01*41+L0lii0O+1)%251
end
if ioLO0I0oOLOIlL~=1220856776 or LOiliOL100oi~=3096461019 then i0liOo("VM integrity check failed",0) end
return IOO0j0oj0ioL(i0j1OLLLOLo0)
end
local l0LLl01lLlOoI1=ij0o0i(ljolol1L01o1Li(I0ioiOIl))
local L0lii0O=1
local function j0Iiljjjl1LL(I0Oj0i1oI1I1oo)
if I0Oj0i1oI1I1oo<0 or L0lii0O+I0Oj0i1oI1I1oo-1>#l0LLl01lLlOoI1 then i0liOo("VM payload is truncated",0) end
end
local function jlOi00Ijii()
j0Iiljjjl1LL(1)
local I0Oj0i1oI1I1oo=iOILj1iOlLjjL(l0LLl01lLlOoI1,L0lii0O)
L0lii0O=L0lii0O+1
return I0Oj0i1oI1I1oo
end
local function j0Il11()
j0Iiljjjl1LL(2)
local I0Oj0i1oI1I1oo,iO1iO1o10L=iOILj1iOlLjjL(l0LLl01lLlOoI1,L0lii0O,L0lii0O+1)
L0lii0O=L0lii0O+2
return I0Oj0i1oI1I1oo+iO1iO1o10L*256
end
local function ll1OjilI0()
j0Iiljjjl1LL(4)
local I0Oj0i1oI1I1oo,iO1iO1o10L,ijiLilIilil0,i0j1OLLLOLo0=iOILj1iOlLjjL(l0LLl01lLlOoI1,L0lii0O,L0lii0O+3)
L0lii0O=L0lii0O+4
return I0Oj0i1oI1I1oo+iO1iO1o10L*256+ijiLilIilil0*65536+i0j1OLLLOLo0*16777216
end
local function Il1jOjo()
local I0Oj0i1oI1I1oo=ll1OjilI0()
j0Iiljjjl1LL(I0Oj0i1oI1I1oo)
local iO1iO1o10L=lLi1o00(l0LLl01lLlOoI1,L0lii0O,L0lii0O+I0Oj0i1oI1I1oo-1)
L0lii0O=L0lii0O+I0Oj0i1oI1I1oo
return iO1iO1o10L
end
local function ILilL1Ll1i1()
local I0Oj0i1oI1I1oo=jlOi00Ijii()
local iO1iO1o10L=Il1jOjo()
if I0Oj0i1oI1I1oo==0 then return ljL1LLI0o1o1oI(iO1iO1o10L)
elseif I0Oj0i1oI1I1oo==1 then return iO1iO1o10L
elseif I0Oj0i1oI1I1oo==2 then return 1/0
elseif I0Oj0i1oI1I1oo==3 then return -1/0
else return 0/0 end
end
local function jo1ilLI0I(i10jiLjLi0lj1)
if i10jiLjLi0lj1>200 then i0liOo("VM function nesting limit exceeded",0) end
local jiO1iL=jlOi00Ijii()
local I0Oj0i1oI1I1oo=jlOi00Ijii()
if I0Oj0i1oI1I1oo>1 then i0liOo("VM invalid function flags",0) end
local ILI1OiLoiI0L=ll1OjilI0()
local LLiL0iloo=ILI1OiLoiI0L%65536
local iO1iO1o10L=j0Il11()
local i0llI1O0={}
for ijiLilIilil0=1,iO1iO1o10L do local j0OlIIl10L=j0Il11() i0llI1O0[ijiLilIilil0]={j0OlIIl10L,Il1jOjo()} end
local i0j1OLLLOLo0=ll1OjilI0()
j0Iiljjjl1LL(i0j1OLLLOLo0*12)
local j0ilOiiI00L1={}
for ijiLilIilil0=1,i0j1OLLLOLo0 do
j0ilOiiI00L1[ijiLilIilil0]={ll1OjilI0(),j0Il11(),ll1OjilI0(),j0Il11()}
for j1O1lliIl0O=1,4 do LLiL0iloo=(LLiL0iloo*131+j0ilOiiI00L1[ijiLilIilil0][j1O1lliIl0O]%65536+j1O1lliIl0O)%65536 end
end
local L0lii0O=j0Il11()
local iOi1i1LOlIjo1={}
for ijiLilIilil0=1,L0lii0O do iOi1i1LOlIjo1[ijiLilIilil0]=jo1ilLI0I(i10jiLjLi0lj1+1) end
local i1LiO10I=j0Il11()
local lllLIoj={}
for ijiLilIilil0=1,i1LiO10I do lllLIoj[ijiLilIilil0]={jlOi00Ijii(),j0Il11()} end
return {jiO1iL,I0Oj0i1oI1I1oo,j0ilOiiI00L1,i0llI1O0,iOi1i1LOlIjo1,lllLIoj,{},ILI1OiLoiI0L,(llO0III10OOII+55923+LLiL0iloo)%65536}
end
local function lLOliI0j1(joIIIiLoLI0iLo,joLIo0Ii1IiL,j0OlIIl10L,ijLoLjlo01)
if joLIo0Ii1IiL[j0OlIIl10L]~=nil then return joLIo0Ii1IiL[j0OlIIl10L] end
local iLOiII10Iji0=joIIIiLoLI0iLo[j0OlIIl10L]
local jLOili1ILj=iLOiII10Iji0[1]
local iiljLiiOjl1iO=iLOiII10Iji0[2]
local i1ll0jlIiL=(ijLoLjlo01+jLOili1ILj*251+1)%65536
local iIooLl={}
for llIloOLOl=1,#iiljLiiOjl1iO do
i1ll0jlIiL=(i1ll0jlIiL*40503+12345)%65536
iIooLl[llIloOLOl]=ijI1LIl((iOILj1iOlLjjL(iiljLiiOjl1iO,llIloOLOl)-I0ioOl1(i1ll0jlIiL/256)%256-llIloOLOl*(ijLoLjlo01%256))%256)
end
local IL01LLllj00L0=IOO0j0oj0ioL(iIooLl)
if #IL01LLllj00L0<5 then i0liOo("VM invalid constant",0) end
local Lo1jlo=iOILj1iOlLjjL(IL01LLllj00L0,1)
local ioljOL0jiliOio=iOILj1iOlLjjL(IL01LLllj00L0,2)+iOILj1iOlLjjL(IL01LLllj00L0,3)*256+iOILj1iOlLjjL(IL01LLllj00L0,4)*65536+iOILj1iOlLjjL(IL01LLllj00L0,5)*16777216
if ioljOL0jiliOio~=#IL01LLllj00L0-5 or Lo1jlo>4 then i0liOo("VM invalid constant",0) end
local ILoLololO=lLi1o00(IL01LLllj00L0,6,5+ioljOL0jiliOio)
local LoojloLOill0LI
if Lo1jlo==0 then LoojloLOill0LI=ljL1LLI0o1o1oI(ILoLololO) elseif Lo1jlo==1 then LoojloLOill0LI=ILoLololO elseif Lo1jlo==2 then LoojloLOill0LI=1/0 elseif Lo1jlo==3 then LoojloLOill0LI=-1/0 else LoojloLOill0LI=0/0 end
joLIo0Ii1IiL[j0OlIIl10L]=LoojloLOill0LI
return LoojloLOill0LI
end
local L1LI1jl11IiO={}
local jL0ill=j0Il11()
for IlLI1liO0ll=1,jL0ill do local I0Oj0i1oI1I1oo=j0Il11() local iO1iO1o10L=j0Il11() L1LI1jl11IiO[I0Oj0i1oI1I1oo]=iO1iO1o10L end
local jiooojoii=jo1ilLI0I(0)
if L0lii0O~=#l0LLl01lLlOoI1+1 then i0liOo("VM trailing payload data",0) end
l0LLl01lLlOoI1=nil
I0ioiOIl=nil
local j1oo0Ll0loL0O
local function IOLOlIjloL(jiooojoii,lllLIoj)
return function(...) return j1oo0Ll0loL0O(jiooojoii,lllLIoj,iLjjlioOO0(...)) end
end
j1oo0Ll0loL0O=function(jiooojoii,lllLIoj,IoIoLLo)
local LL1LLl1llLj={}
local iO01oj=0
local jiO1iL=jiooojoii[1]
local iijiOiLjO11O=IoIoLLo.n
for I0Oj0i1oI1I1oo=1,jiO1iL do LL1LLl1llLj[I0Oj0i1oI1I1oo-1]=IoIoLLo[I0Oj0i1oI1I1oo] end
local j1lllj,joOji1LilIijl={},0
if jiooojoii[2]==1 then joOji1LilIijl=iijiOiLjO11O-jiO1iL; if joOji1LilIijl<0 then joOji1LilIijl=0 end; for I0Oj0i1oI1I1oo=1,joOji1LilIijl do j1lllj[I0Oj0i1oI1I1oo]=IoIoLLo[jiO1iL+I0Oj0i1oI1I1oo] end end
local j0ilOiiI00L1,i0llI1O0,iOi1i1LOlIjo1=jiooojoii[3],jiooojoii[4],jiooojoii[5]
local iojo1LjoLjool=jiooojoii[7]
local LoLjjLLOOLl=1
local i1LiO10I=0
while true do
local I0j0LLiolLOI0=j0ilOiiI00L1[LoLjjLLOOLl]
if I0j0LLiolLOI0==nil then i0liOo("VM invalid instruction address",0) end
local IIjil1II=(jiooojoii[8]+LoLjjLLOOLl*65599)%4294967296
LoLjjLLOOLl=LoLjjLLOOLl+1
IIjil1II=(IIjil1II*1664525+1013904223)%4294967296
local I00IOIolooojO=(I0j0LLiolLOI0[2]-IIjil1II)%65536
IIjil1II=(IIjil1II*1664525+1013904223)%4294967296
local I0Oj0i1oI1I1oo=(I0j0LLiolLOI0[4]-IIjil1II)%65536
IIjil1II=(IIjil1II*1664525+1013904223)%4294967296
local iO1iO1o10L=(I0j0LLiolLOI0[3]-IIjil1II)%4294967296
IIjil1II=(IIjil1II*1664525+1013904223)%4294967296
local ijiLilIilil0=(I0j0LLiolLOI0[1]-IIjil1II)%4294967296
local i0j1OLLLOLo0=L1LI1jl11IiO[I00IOIolooojO]
if (LoLjjLLOOLl*LoLjjLLOOLl*LoLjjLLOOLl-LoLjjLLOOLl)%6~=0 then iO01oj=iO01oj+8 end
if (i0j1OLLLOLo0*i0j1OLLLOLo0+i0j1OLLLOLo0)%2==1 then iO01oj=iO01oj-9 end
if (LoLjjLLOOLl*LoLjjLLOOLl+LoLjjLLOOLl)%2~=0 then iO01oj=iO01oj+6 end
if i0j1OLLLOLo0==23 then
LL1LLl1llLj[iO1iO1o10L][1]=LL1LLl1llLj[I0Oj0i1oI1I1oo]
elseif i0j1OLLLOLo0==43 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=-LL1LLl1llLj[iO1iO1o10L]
elseif i0j1OLLLOLo0==26 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L][LL1LLl1llLj[ijiLilIilil0]]
elseif i0j1OLLLOLo0==39 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L][1]
elseif i0j1OLLLOLo0==14 then
local iLOiII10Iji0=LL1LLl1llLj[I0Oj0i1oI1I1oo]
if ljOOj1i1LjILl0(iLOiII10Iji0)~=iIO10Ioj0 then
local jLOili1ILj=llOiL1ioiI1ll(iLOiII10Iji0)
if jLOili1ILj~=nil and ljOOj1i1LjILl0(jLOili1ILj)~=jLIo0o1iL1iOoo then i0liOo("Protected iterator metatables require an explicit iterator function",0) end
local iiljLiiOjl1iO=jLOili1ILj and lLllOjO00lLj(jLOili1ILj,lI0LLjoI)
if iiljLiiOjl1iO~=nil then
LL1LLl1llLj[I0Oj0i1oI1I1oo],LL1LLl1llLj[I0Oj0i1oI1I1oo+1],LL1LLl1llLj[I0Oj0i1oI1I1oo+2]=iiljLiiOjl1iO(iLOiII10Iji0)
elseif ljOOj1i1LjILl0(iLOiII10Iji0)==jLIo0o1iL1iOoo and (jLOili1ILj==nil or lLllOjO00lLj(jLOili1ILj,IjIiioji1000)==nil) then
LL1LLl1llLj[I0Oj0i1oI1I1oo],LL1LLl1llLj[I0Oj0i1oI1I1oo+1],LL1LLl1llLj[I0Oj0i1oI1I1oo+2]=ljLL0illOo1O1,iLOiII10Iji0,nil
end
end
elseif i0j1OLLLOLo0==41 then
lllLIoj[iO1iO1o10L+1][1]=LL1LLl1llLj[I0Oj0i1oI1I1oo]
elseif i0j1OLLLOLo0==2 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]%LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==32 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]..LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==20 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(LL1LLl1llLj[iO1iO1o10L]==LL1LLl1llLj[ijiLilIilil0])
elseif i0j1OLLLOLo0==40 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=lllLIoj[iO1iO1o10L+1][1]
elseif i0j1OLLLOLo0==6 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(LL1LLl1llLj[iO1iO1o10L]>=LL1LLl1llLj[ijiLilIilil0])
elseif i0j1OLLLOLo0==42 then
for iLOiII10Iji0=I0Oj0i1oI1I1oo,I0Oj0i1oI1I1oo+iO1iO1o10L do LL1LLl1llLj[iLOiII10Iji0]=nil end
elseif i0j1OLLLOLo0==31 then
LoLjjLLOOLl=iO1iO1o10L+1
elseif i0j1OLLLOLo0==10 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(LL1LLl1llLj[iO1iO1o10L]~=LL1LLl1llLj[ijiLilIilil0])
elseif i0j1OLLLOLo0==3 then
local jLOili1ILj=LL1LLl1llLj[I0Oj0i1oI1I1oo]
local iiljLiiOjl1iO
if iO1iO1o10L==0 then iiljLiiOjl1iO=i1LiO10I-I0Oj0i1oI1I1oo-1 else iiljLiiOjl1iO=iO1iO1o10L-1 end
local i1ll0jlIiL={}
for iLOiII10Iji0=1,iiljLiiOjl1iO do i1ll0jlIiL[iLOiII10Iji0]=LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0] end
local iIooLl=iLjjlioOO0(jLOili1ILj(jlij1ilLi(i1ll0jlIiL,1,iiljLiiOjl1iO)))
if ijiLilIilil0==0 then
local llIloOLOl=iIooLl.n
for iLOiII10Iji0=1,llIloOLOl do LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0-1]=iIooLl[iLOiII10Iji0] end
i1LiO10I=I0Oj0i1oI1I1oo+llIloOLOl
else
for iLOiII10Iji0=1,ijiLilIilil0-1 do LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0-1]=iIooLl[iLOiII10Iji0] end
end
elseif i0j1OLLLOLo0==11 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]/LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==33 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(LL1LLl1llLj[iO1iO1o10L]>LL1LLl1llLj[ijiLilIilil0])
elseif i0j1OLLLOLo0==29 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]
elseif i0j1OLLLOLo0==27 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=#LL1LLl1llLj[iO1iO1o10L]
elseif i0j1OLLLOLo0==5 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]^LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==9 then
local iiljLiiOjl1iO
if iO1iO1o10L==0 then iiljLiiOjl1iO=i1LiO10I-I0Oj0i1oI1I1oo-1 else iiljLiiOjl1iO=iO1iO1o10L end
local jLOili1ILj=LL1LLl1llLj[I0Oj0i1oI1I1oo]
for iLOiII10Iji0=1,iiljLiiOjl1iO do jLOili1ILj[ijiLilIilil0+iLOiII10Iji0]=LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0] end
elseif i0j1OLLLOLo0==8 then
local jLOili1ILj=LL1LLl1llLj[I0Oj0i1oI1I1oo]
local IL01LLllj00L0=LL1LLl1llLj[I0Oj0i1oI1I1oo+1]
local Lo1jlo=LL1LLl1llLj[I0Oj0i1oI1I1oo+2]
local iIooLl=iLjjlioOO0(jLOili1ILj(IL01LLllj00L0,Lo1jlo))
local llIloOLOl=iIooLl[1]
if llIloOLOl~=nil then
LL1LLl1llLj[I0Oj0i1oI1I1oo+2]=llIloOLOl
for iLOiII10Iji0=1,iO1iO1o10L do LL1LLl1llLj[I0Oj0i1oI1I1oo+3+iLOiII10Iji0-1]=iIooLl[iLOiII10Iji0] end
LoLjjLLOOLl=ijiLilIilil0+1
end
elseif i0j1OLLLOLo0==19 then
LL1LLl1llLj[I0Oj0i1oI1I1oo][LL1LLl1llLj[iO1iO1o10L]]=LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==36 then
local iiljLiiOjl1iO
if iO1iO1o10L==0 then iiljLiiOjl1iO=i1LiO10I-I0Oj0i1oI1I1oo else iiljLiiOjl1iO=iO1iO1o10L-1 end
local i1ll0jlIiL={}
for iLOiII10Iji0=1,iiljLiiOjl1iO do i1ll0jlIiL[iLOiII10Iji0]=LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0-1] end
return jlij1ilLi(i1ll0jlIiL,1,iiljLiiOjl1iO)
elseif i0j1OLLLOLo0==1 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(LL1LLl1llLj[iO1iO1o10L]<=LL1LLl1llLj[ijiLilIilil0])
elseif i0j1OLLLOLo0==37 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=not LL1LLl1llLj[iO1iO1o10L]
elseif i0j1OLLLOLo0==38 then
LOj0lillooLjjL[lLOliI0j1(i0llI1O0,iojo1LjoLjool,iO1iO1o10L+1,jiooojoii[9])]=LL1LLl1llLj[I0Oj0i1oI1I1oo]
elseif i0j1OLLLOLo0==21 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]={}
elseif i0j1OLLLOLo0==24 then
LL1LLl1llLj[I0Oj0i1oI1I1oo+1]=LL1LLl1llLj[iO1iO1o10L]; LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L][LL1LLl1llLj[ijiLilIilil0]]
elseif i0j1OLLLOLo0==13 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LOj0lillooLjjL[lLOliI0j1(i0llI1O0,iojo1LjoLjool,iO1iO1o10L+1,jiooojoii[9])]
elseif i0j1OLLLOLo0==4 then
local jLOili1ILj=iOi1i1LOlIjo1[iO1iO1o10L+1]
local i1ll0jlIiL={}
local iIooLl=jLOili1ILj[6]
for iLOiII10Iji0=1,#iIooLl do
local llIloOLOl=iIooLl[iLOiII10Iji0]
if llIloOLOl[1]==1 then i1ll0jlIiL[iLOiII10Iji0]=LL1LLl1llLj[llIloOLOl[2]] else i1ll0jlIiL[iLOiII10Iji0]=lllLIoj[llIloOLOl[2]+1] end
end
LL1LLl1llLj[I0Oj0i1oI1I1oo]=IOLOlIjloL(jLOili1ILj,i1ll0jlIiL)
elseif i0j1OLLLOLo0==15 then
if (not not LL1LLl1llLj[I0Oj0i1oI1I1oo])==(iO1iO1o10L~=0) then LoLjjLLOOLl=ijiLilIilil0+1 end
elseif i0j1OLLLOLo0==17 then
for iLOiII10Iji0=I0Oj0i1oI1I1oo,I0Oj0i1oI1I1oo+2 do
LL1LLl1llLj[iLOiII10Iji0]=ljL1LLI0o1o1oI(LL1LLl1llLj[iLOiII10Iji0])
if LL1LLl1llLj[iLOiII10Iji0]==nil then i0liOo("Numeric for bounds and step must be numbers",0) end
end
local jLOili1ILj=LL1LLl1llLj[I0Oj0i1oI1I1oo+2]
local iiljLiiOjl1iO
if jLOili1ILj>0 then iiljLiiOjl1iO=LL1LLl1llLj[I0Oj0i1oI1I1oo]<=LL1LLl1llLj[I0Oj0i1oI1I1oo+1] else iiljLiiOjl1iO=LL1LLl1llLj[I0Oj0i1oI1I1oo]>=LL1LLl1llLj[I0Oj0i1oI1I1oo+1] end
if iiljLiiOjl1iO then LL1LLl1llLj[I0Oj0i1oI1I1oo+3]=LL1LLl1llLj[I0Oj0i1oI1I1oo] else LoLjjLLOOLl=iO1iO1o10L+1 end
elseif i0j1OLLLOLo0==16 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(iO1iO1o10L~=0)
elseif i0j1OLLLOLo0==28 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]-LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==25 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]={LL1LLl1llLj[iO1iO1o10L]}
elseif i0j1OLLLOLo0==18 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=lLOliI0j1(i0llI1O0,iojo1LjoLjool,iO1iO1o10L+1,jiooojoii[9])
elseif i0j1OLLLOLo0==12 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]//LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==22 then
if iO1iO1o10L==0 then
for iLOiII10Iji0=1,joOji1LilIijl do LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0-1]=j1lllj[iLOiII10Iji0] end
i1LiO10I=I0Oj0i1oI1I1oo+joOji1LilIijl
else
for iLOiII10Iji0=1,iO1iO1o10L-1 do LL1LLl1llLj[I0Oj0i1oI1I1oo+iLOiII10Iji0-1]=j1lllj[iLOiII10Iji0] end
end
elseif i0j1OLLLOLo0==44 then
iO01oj=(iO01oj+iO1iO1o10L)%(ijiLilIilil0+1)
elseif i0j1OLLLOLo0==34 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]+LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==7 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[iO1iO1o10L]*LL1LLl1llLj[ijiLilIilil0]
elseif i0j1OLLLOLo0==30 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=(LL1LLl1llLj[iO1iO1o10L]<LL1LLl1llLj[ijiLilIilil0])
elseif i0j1OLLLOLo0==35 then
LL1LLl1llLj[I0Oj0i1oI1I1oo]=LL1LLl1llLj[I0Oj0i1oI1I1oo]+LL1LLl1llLj[I0Oj0i1oI1I1oo+2]
local jLOili1ILj=LL1LLl1llLj[I0Oj0i1oI1I1oo+2]
local iiljLiiOjl1iO
if jLOili1ILj>0 then iiljLiiOjl1iO=LL1LLl1llLj[I0Oj0i1oI1I1oo]<=LL1LLl1llLj[I0Oj0i1oI1I1oo+1] else iiljLiiOjl1iO=LL1LLl1llLj[I0Oj0i1oI1I1oo]>=LL1LLl1llLj[I0Oj0i1oI1I1oo+1] end
if iiljLiiOjl1iO then LL1LLl1llLj[I0Oj0i1oI1I1oo+3]=LL1LLl1llLj[I0Oj0i1oI1I1oo]; LoLjjLLOOLl=iO1iO1o10L+1 end
else i0liOo() end
end
return iO01oj
end
return j1oo0Ll0loL0O(jiooojoii,{},iLjjlioOO0(...))
