local jOlLjji=(getfenv and getfenv(1)) or _ENV or _G
local iijjj1IjIo1,lOOijllOjLl=string.byte,string.char
local function liiiIl0Loi0(jOiOiiLll0o,lL0jlIljjIjIj)
local l0jOo0jLl=""
local I1liijLOoo0II=#lL0jlIljjIjIj
for lOol0i1I=1,#jOiOiiLll0o do l0jOo0jLl=l0jOo0jLl..lOOijllOjLl((iijjj1IjIo1(jOiOiiLll0o,lOol0i1I)-iijjj1IjIo1(lL0jlIljjIjIj,(lOol0i1I-1)%I1liijLOoo0II+1))%256) end
return l0jOo0jLl
end
local IOijloojILl=jOlLjji[liiiIl0Loi0("c\137\193\136\132d","\240$U#!")]
local L0IjLl0o=jOlLjji[liiiIl0Loi0("\161\188u\023\004\014",".H\003\174\150\167")][liiiIl0Loi0("\139\004c","\024\143\001K")]
local IollOj1L1ijLO=jOlLjji[liiiIl0Loi0("\161,/\n\146","-\203\205\158")][liiiIl0Loi0("\204\230\223`b0","iwq\253\001\188")]
local LoLI0OlOiL=jOlLjji[liiiIl0Loi0("a\029\173\008","\244\1889\160s\228\004")][liiiIl0Loi0("\198,y\2072","`\192\n")]
local jjLiiOlOOO=jOlLjji[liiiIl0Loi0("\157\152jA\144\248\142\155","))\252\204#\150")]
local i01oIiijo=jOlLjji[liiiIl0Loi0("KT<TX","\230\226\202\229")]
local LL1j1OLl=jOlLjji[liiiIl0Loi0("*I-\141","\182\208\189(\029\138")]
local ilio00iO=jOlLjji[liiiIl0Loi0("\181\198\136<\224\194\194\1360\221\186\198","Na\020\207{")]
local ioji0OI1Olj=jOlLjji[liiiIl0Loi0("\007\138\163j\131\214","\149),\003\030bl")]
local loO1ll0I0oO0O=jOlLjji[liiiIl0Loi0("\234@\006\240","|\219\142")]
local iioi0Oj0oio,l101jIilOOjo0L,Li1O0i0jL,liOlojo=liiiIl0Loi0("\228\137\009\247\213","p(\167\139"),liiiIl0Loi0("\238\001\"h\168Zt\246","\136\140\180\0054\241\005"),liiiIl0Loi0("Z\174;>`\193","\251O\210\202"),liiiIl0Loi0("\023\2276k\028\210","\184\132\211\n\176f\202")
local IO1l1i=(lOOijllOjLl(66,75)=="BK" and 4390 or 53)+iijjj1IjIo1("&")+IOijloojILl("#",0,0)*26+jjLiiOlOOO("1237")*6
local jIlli1oi1IllL=jOlLjji[liiiIl0Loi0("\159\215qx\250","+v\015\012\149\008")][liiiIl0Loi0("&\020\135\168","\182\179$=*")] or function(...) return {n=IOijloojILl("#",...),...} end
local LLlIioO=jOlLjji[liiiIl0Loi0("\0228\144\223v","\162\215.s\017\211\140")][liiiIl0Loi0("d5\250\171\252Z","\239\199\138J\153")] or jOlLjji[liiiIl0Loi0("\203\149:`\177\193","V'\202\255N")]
local lI0O101ll10="ZleyMsYVTxrBzH9wNg5PjAKi6Lf/1oE2Xn+aGvDtcuO38h7pI4Rm0qWCUJQkFdSb"
local function lIO0Ljj0LIo(iI11LlOOoIl)
local llIi11L1olI={}
for ILjOiI01L=1,64 do llIi11L1olI[iijjj1IjIo1(lI0O101ll10,ILjOiI01L)]=ILjOiI01L-1 end
local IlOj1ILoll1IoO,I0iO11OLLoLo,IoOOoiIoL01,ioil0j0ll={},0,0,0
for ILjOiI01L=1,#iI11LlOOoIl do
local iOoii0o=llIi11L1olI[iijjj1IjIo1(iI11LlOOoIl,ILjOiI01L)]
if iOoii0o then
I0iO11OLLoLo=I0iO11OLLoLo*64+iOoii0o
IoOOoiIoL01=IoOOoiIoL01+6
if IoOOoiIoL01>=8 then IoOOoiIoL01=IoOOoiIoL01-8 ioil0j0ll=ioil0j0ll+1 IlOj1ILoll1IoO[ioil0j0ll]=lOOijllOjLl(LoLI0OlOiL(I0iO11OLLoLo/(2^IoOOoiIoL01))%256) I0iO11OLLoLo=I0iO11OLLoLo%(2^IoOOoiIoL01) end
end
end
return IollOj1L1ijLO(IlOj1ILoll1IoO)
end
local IjoLloi0jl="+n9KH+X/T4Vq+y4gqnjicMGU09H4pWQcR7XbaSvAiLbcqYMgDu9WpKWDNESCpqKlQUY5gsHyMCnHG4kzSGTUOP93c+la3x0KudLnQYeQDhcNbevhvvqpj9BC7jnta3Jb3qEliiW4XPrG+18X+iG79o3+VuTR3Pz5hsaxTlH/uB75duVXi8Iiv8vdJkrODkUsNx8DTXaWcltlpY3wxl0yjdKvxgaanCD2wKU05xW4xWd6Lk+J0fOw6Qx+jbt/MMRuARlpFCxhDJNzoPnPuGCenwOJGXQvhBxeYn6NkAv4TfIWQzvxnB0ueRfewLpby1/6/61mnKEa3c19YCm8o2IyePJ5xk7Sx30FTEmoMe53n9/Bb4PffopD/QL9JFeOq9RcIhejAvGecSJP3B2M/rcCmf3Uah2SeR3fOQ9zoUIPgWvfZSEDKayNjd2DoxS9xoq3pJE+JczUOam6vYTCw0ypV0aL/+NS7ziAJ7rhf157PSnJ1c+ryrqkxucLJKz5jDlnDyZgoqzmbuENIvQ9ArxhDjco5UNcm07P+pvs7ixb07oZFGSBUkNZhIWgXVdIm19VmNWwdjAoxDk+QqhzEnHMRfj4IibLmNx+r96J5VdNURzzpubw3cxN3faRIy6FKDWYzPJ9qV4g8h20u+MSs9L+VoX2g//Wx4vzcb21p43/u+By67vTegFavY4KvuRryo9Pi31pMqQy727TNAlN6QCuM4dv3koRoZmFqJFpCU3/PMYhrtOv1yMu6eJsRzEHj/9Thz/esDPd84A6pTu0xzo9ejJnAFTMRLREBnHpzi51jpKdhjiHYTFXZXQT8/mgI9moS0EpSQh1MjRjaJPL7h9ltzXCgW2/n5QOKXjaPcEqDGSFBl7zDAk2/+lUrHc+0MPJPi+OAbsH2PJ+AuCF/8NN8ddbLoOIs9yBjgOfzsxEviWUsHfF3iQX1qrmseuGygESKc+l81QHdplAlVn7f4lRUmqgN2aKQPWHOxA48Lr9Rilv6m997lF5+XBkdLKsLqLSTbnds2ceQPYq5aXm2ZMnZVPz+WH+z13ae9eYuWFOHj9MTmfK5Z3LCrXcmw289XiaLfRQoysYQqD5yPpPzgvYvgA/WRkJYo5Cvjc2Rr8nTPWJ+1J0Z4qLfkAoP1nzk9/t4eD/FEMJ9viedFlm9Hr++9bJ/K+UaHt//hWqLwhyLnf9zD4PmCDgvUfW/NWITKZuAKpz0YaU3HfH7TmgMAx11zomHaZkxD26g31A19h7LrrsTIqt/C38dvUEHcBoMpvdBIhnP7TDmYcoHB0i"
local IIj01jOLjlj1lj=lIO0Ljj0LIo(IjoLloi0jl)
IjoLloi0jl=nil
if #IIj01jOLjlj1lj~=972 then i01oIiijo("VM integrity check failed",0) end
local function I00LoooLl0jIL()
local j01i1l0OijjjI1=(181756562)+IO1l1i
local il0lOoj1ooOo01=111
local I1O1jiILjO=0
return function()
I1O1jiILjO=I1O1jiILjO+1
j01i1l0OijjjI1=(j01i1l0OijjjI1*63107+351001115)%4294967296
local ij1l0ILIl=iijjj1IjIo1(IIj01jOLjlj1lj,I1O1jiILjO)
local I11LOj1L1o=(LoLI0OlOiL(j01i1l0OijjjI1/65536)+il0lOoj1ooOo01+(I1O1jiILjO-1)*38)%256
local jl1ll11o=(ij1l0ILIl-I11LOj1L1o)%256
il0lOoj1ooOo01=(il0lOoj1ooOo01*31+ij1l0ILIl+1)%251
return jl1ll11o
end
end
local l1L1OjLjo1o0=I00LoooLl0jIL()
local lOjjIolLIi1,jljIoLlOj1iO1=1,0
for LjiILI0OOL=1,#IIj01jOLjlj1lj do
local jl1ll11o=l1L1OjLjo1o0()
lOjjIolLIi1=(lOjjIolLIi1*257+jl1ll11o+1)%4294967291
jljIoLlOj1iO1=(jljIoLlOj1iO1*65599+jl1ll11o+1)%4294967279
end
if lOjjIolLIi1~=2578036519 or jljIoLlOj1iO1~=1741071706 then i01oIiijo("VM integrity check failed",0) end
l1L1OjLjo1o0=I00LoooLl0jIL()
local I1O1jiILjO=1
local function L0ljoloiIoli1(LjiILI0OOL)
if LjiILI0OOL<0 or I1O1jiILjO+LjiILI0OOL-1>#IIj01jOLjlj1lj then i01oIiijo("VM payload is truncated",0) end
end
local function i11oO0iooIIjoL()
L0ljoloiIoli1(1)
local LjiILI0OOL=l1L1OjLjo1o0()
I1O1jiILjO=I1O1jiILjO+1
return LjiILI0OOL
end
local function iliooI()
L0ljoloiIoli1(2)
local LjiILI0OOL=l1L1OjLjo1o0()
local jl1ll11o=l1L1OjLjo1o0()
I1O1jiILjO=I1O1jiILjO+2
return LjiILI0OOL+jl1ll11o*256
end
local function jIOoOlL1o1()
L0ljoloiIoli1(4)
local LjiILI0OOL=l1L1OjLjo1o0()
local jl1ll11o=l1L1OjLjo1o0()
local ij1l0ILIl=l1L1OjLjo1o0()
local iLojLiO0I0j1=l1L1OjLjo1o0()
I1O1jiILjO=I1O1jiILjO+4
return LjiILI0OOL+jl1ll11o*256+ij1l0ILIl*65536+iLojLiO0I0j1*16777216
end
local function l0j0lLI1()
local LjiILI0OOL=jIOoOlL1o1()
L0ljoloiIoli1(LjiILI0OOL)
local jl1ll11o={}
for ij1l0ILIl=1,LjiILI0OOL do jl1ll11o[ij1l0ILIl]=lOOijllOjLl(l1L1OjLjo1o0()) end
I1O1jiILjO=I1O1jiILjO+LjiILI0OOL
return IollOj1L1ijLO(jl1ll11o)
end
local function LjllI1LjlO0ll()
local LjiILI0OOL=i11oO0iooIIjoL()
local jl1ll11o=l0j0lLI1()
if LjiILI0OOL==0 then return jjLiiOlOOO(jl1ll11o)
elseif LjiILI0OOL==1 then return jl1ll11o
elseif LjiILI0OOL==2 then return 1/0
elseif LjiILI0OOL==3 then return -1/0
else return 0/0 end
end
local function j1IOLI(i01oOL1)
if i01oOL1>200 then i01oIiijo("VM function nesting limit exceeded",0) end
local iLjOjOLlLjoi=i11oO0iooIIjoL()
local LjiILI0OOL=i11oO0iooIIjoL()
if LjiILI0OOL>1 then i01oIiijo("VM invalid function flags",0) end
local Llj100o1iLOIiL=jIOoOlL1o1()
local L0ILjo=Llj100o1iLOIiL%65536
local jl1ll11o=iliooI()
local jLO1Oo1LIij1Ij={}
for ij1l0ILIl=1,jl1ll11o do local LIoliIi1=iliooI() jLO1Oo1LIij1Ij[ij1l0ILIl]={LIoliIi1,l0j0lLI1()} end
local iLojLiO0I0j1=jIOoOlL1o1()
L0ljoloiIoli1(iLojLiO0I0j1*12)
local i0j0OLoII={}
for ij1l0ILIl=1,iLojLiO0I0j1 do
i0j0OLoII[ij1l0ILIl]={iliooI(),jIOoOlL1o1(),jIOoOlL1o1(),iliooI()}
for jll01I=1,4 do L0ILjo=(L0ILjo*131+i0j0OLoII[ij1l0ILIl][jll01I]%65536+jll01I)%65536 end
end
local I1O1jiILjO=iliooI()
local joL01i1il={}
for ij1l0ILIl=1,I1O1jiILjO do joL01i1il[ij1l0ILIl]=j1IOLI(i01oOL1+1) end
local i00j0OIoI=iliooI()
local liiIlOIL={}
for ij1l0ILIl=1,i00j0OIoI do liiIlOIL[ij1l0ILIl]={i11oO0iooIIjoL(),iliooI()} end
return {iLjOjOLlLjoi,LjiILI0OOL,i0j0OLoII,jLO1Oo1LIij1Ij,joL01i1il,liiIlOIL,{},Llj100o1iLOIiL,(IO1l1i+39134+L0ILjo)%65536}
end
local function LloiO1(l1LLioiii,iO0jOoL,LIoliIi1,j11I0oLilo)
if iO0jOoL[LIoliIi1]~=nil then return iO0jOoL[LIoliIi1] end
local iI11LlOOoIl=l1LLioiii[LIoliIi1]
local llIi11L1olI=iI11LlOOoIl[1]
local ILjOiI01L=iI11LlOOoIl[2]
local IlOj1ILoll1IoO=(j11I0oLilo+llIi11L1olI*251+1)%65536
local I0iO11OLLoLo={}
for IoOOoiIoL01=1,#ILjOiI01L do
IlOj1ILoll1IoO=(IlOj1ILoll1IoO*40503+12345)%65536
I0iO11OLLoLo[IoOOoiIoL01]=lOOijllOjLl((iijjj1IjIo1(ILjOiI01L,IoOOoiIoL01)-LoLI0OlOiL(IlOj1ILoll1IoO/256)%256-IoOOoiIoL01*(j11I0oLilo%256))%256)
end
local ioil0j0ll=IollOj1L1ijLO(I0iO11OLLoLo)
if #ioil0j0ll<5 then i01oIiijo("VM invalid constant",0) end
local iOoii0o=iijjj1IjIo1(ioil0j0ll,1)
local jIlOioiIlO=iijjj1IjIo1(ioil0j0ll,2)+iijjj1IjIo1(ioil0j0ll,3)*256+iijjj1IjIo1(ioil0j0ll,4)*65536+iijjj1IjIo1(ioil0j0ll,5)*16777216
if jIlOioiIlO~=#ioil0j0ll-5 or iOoii0o>4 then i01oIiijo("VM invalid constant",0) end
local iO1lLlo=L0IjLl0o(ioil0j0ll,6,5+jIlOioiIlO)
local jjOo01O0IIo
if iOoii0o==0 then jjOo01O0IIo=jjLiiOlOOO(iO1lLlo) elseif iOoii0o==1 then jjOo01O0IIo=iO1lLlo elseif iOoii0o==2 then jjOo01O0IIo=1/0 elseif iOoii0o==3 then jjOo01O0IIo=-1/0 else jjOo01O0IIo=0/0 end
iO0jOoL[LIoliIi1]=jjOo01O0IIo
return jjOo01O0IIo
end
local i0jliOoiL0jOlo={}
local jILi00Oo1O=iliooI()
for iLjOjIil1=1,jILi00Oo1O do local LjiILI0OOL=iliooI() local jl1ll11o=iliooI() i0jliOoiL0jOlo[LjiILI0OOL]=jl1ll11o end
local jO0iOjLiIo101I=j1IOLI(0)
if I1O1jiILjO~=#IIj01jOLjlj1lj+1 then i01oIiijo("VM trailing payload data",0) end
IIj01jOLjlj1lj=nil
l1L1OjLjo1o0=nil
local ijlI0io00
local function j0i00ILoljoO(jO0iOjLiIo101I,liiIlOIL)
return function(...) return ijlI0io00(jO0iOjLiIo101I,liiIlOIL,jIlli1oi1IllL(...)) end
end
ijlI0io00=function(jO0iOjLiIo101I,liiIlOIL,L00jO1loOlj)
local joOjIiLjL0={}
local jo1o1oIII11=0
local iLjOjOLlLjoi=jO0iOjLiIo101I[1]
local L0IjOi=L00jO1loOlj.n
for LjiILI0OOL=1,iLjOjOLlLjoi do joOjIiLjL0[LjiILI0OOL-1]=L00jO1loOlj[LjiILI0OOL] end
local lOlL101,l0jLjjliO={},0
if jO0iOjLiIo101I[2]==1 then l0jLjjliO=L0IjOi-iLjOjOLlLjoi; if l0jLjjliO<0 then l0jLjjliO=0 end; for LjiILI0OOL=1,l0jLjjliO do lOlL101[LjiILI0OOL]=L00jO1loOlj[iLjOjOLlLjoi+LjiILI0OOL] end end
local i0j0OLoII,jLO1Oo1LIij1Ij,joL01i1il=jO0iOjLiIo101I[3],jO0iOjLiIo101I[4],jO0iOjLiIo101I[5]
local i0IOjOL0=jO0iOjLiIo101I[7]
local lO0jil01i1=1
local i00j0OIoI=0
while true do
local IiiIIjIjo0L=i0j0OLoII[lO0jil01i1]
if IiiIIjIjo0L==nil then i01oIiijo("VM invalid instruction address",0) end
local IojLjII0L=(jO0iOjLiIo101I[8]+lO0jil01i1*65599)%4294967296
lO0jil01i1=lO0jil01i1+1
IojLjII0L=(IojLjII0L*1664525+1013904223)%4294967296
local I0o1LlLjjOlIL0=(IiiIIjIjo0L[4]-IojLjII0L)%65536
IojLjII0L=(IojLjII0L*1664525+1013904223)%4294967296
local LjiILI0OOL=(IiiIIjIjo0L[1]-IojLjII0L)%65536
IojLjII0L=(IojLjII0L*1664525+1013904223)%4294967296
local jl1ll11o=(IiiIIjIjo0L[2]-IojLjII0L)%4294967296
IojLjII0L=(IojLjII0L*1664525+1013904223)%4294967296
local ij1l0ILIl=(IiiIIjIjo0L[3]-IojLjII0L)%4294967296
local iLojLiO0I0j1=i0jliOoiL0jOlo[I0o1LlLjjOlIL0]
if (lO0jil01i1*lO0jil01i1*lO0jil01i1-lO0jil01i1)%6~=0 then jo1o1oIII11=jo1o1oIII11+3 end
if (iLojLiO0I0j1*iLojLiO0I0j1)%4==2 then jo1o1oIII11=jo1o1oIII11+2 end
if (lO0jil01i1*lO0jil01i1+lO0jil01i1)%2~=0 then jo1o1oIII11=jo1o1oIII11+5 end
if iLojLiO0I0j1==21 then
joOjIiLjL0[LjiILI0OOL]=-joOjIiLjL0[jl1ll11o]
elseif iLojLiO0I0j1==37 then
joOjIiLjL0[LjiILI0OOL][joOjIiLjL0[jl1ll11o]]=joOjIiLjL0[ij1l0ILIl]
elseif iLojLiO0I0j1==13 then
joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[jl1ll11o]//joOjIiLjL0[ij1l0ILIl]
elseif iLojLiO0I0j1==30 then
joOjIiLjL0[LjiILI0OOL]=jOlLjji[LloiO1(jLO1Oo1LIij1Ij,i0IOjOL0,jl1ll11o+1,jO0iOjLiIo101I[9])]
elseif iLojLiO0I0j1==31 then
liiIlOIL[jl1ll11o+1][1]=joOjIiLjL0[LjiILI0OOL]
elseif iLojLiO0I0j1==42 then
local iI11LlOOoIl=joOjIiLjL0[LjiILI0OOL]
if LL1j1OLl(iI11LlOOoIl)~=l101jIilOOjo0L then
local llIi11L1olI=ilio00iO(iI11LlOOoIl)
if llIi11L1olI~=nil and LL1j1OLl(llIi11L1olI)~=iioi0Oj0oio then i01oIiijo("Protected iterator metatables require an explicit iterator function",0) end
local ILjOiI01L=llIi11L1olI and ioji0OI1Olj(llIi11L1olI,Li1O0i0jL)
if ILjOiI01L~=nil then
joOjIiLjL0[LjiILI0OOL],joOjIiLjL0[LjiILI0OOL+1],joOjIiLjL0[LjiILI0OOL+2]=ILjOiI01L(iI11LlOOoIl)
elseif LL1j1OLl(iI11LlOOoIl)==iioi0Oj0oio and (llIi11L1olI==nil or ioji0OI1Olj(llIi11L1olI,liOlojo)==nil) then
joOjIiLjL0[LjiILI0OOL],joOjIiLjL0[LjiILI0OOL+1],joOjIiLjL0[LjiILI0OOL+2]=loO1ll0I0oO0O,iI11LlOOoIl,nil
end
end
elseif iLojLiO0I0j1==22 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=(iI11LlOOoIl==llIi11L1olI)
elseif iLojLiO0I0j1==23 then
joOjIiLjL0[LjiILI0OOL]=liiIlOIL[jl1ll11o+1][1]
elseif iLojLiO0I0j1==32 then
local llIi11L1olI=joOjIiLjL0[LjiILI0OOL]
local ILjOiI01L
if jl1ll11o==0 then ILjOiI01L=i00j0OIoI-LjiILI0OOL-1 else ILjOiI01L=jl1ll11o-1 end
local IlOj1ILoll1IoO={}
for iI11LlOOoIl=1,ILjOiI01L do IlOj1ILoll1IoO[iI11LlOOoIl]=joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl] end
local I0iO11OLLoLo=jIlli1oi1IllL(llIi11L1olI(LLlIioO(IlOj1ILoll1IoO,1,ILjOiI01L)))
if ij1l0ILIl==0 then
local IoOOoiIoL01=I0iO11OLLoLo.n
for iI11LlOOoIl=1,IoOOoiIoL01 do joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl-1]=I0iO11OLLoLo[iI11LlOOoIl] end
i00j0OIoI=LjiILI0OOL+IoOOoiIoL01
else
for iI11LlOOoIl=1,ij1l0ILIl-1 do joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl-1]=I0iO11OLLoLo[iI11LlOOoIl] end
end
elseif iLojLiO0I0j1==40 then
for iI11LlOOoIl=LjiILI0OOL,LjiILI0OOL+2 do
joOjIiLjL0[iI11LlOOoIl]=jjLiiOlOOO(joOjIiLjL0[iI11LlOOoIl])
if joOjIiLjL0[iI11LlOOoIl]==nil then i01oIiijo("Numeric for bounds and step must be numbers",0) end
end
local llIi11L1olI=joOjIiLjL0[LjiILI0OOL+2]
local ILjOiI01L
if llIi11L1olI>0 then ILjOiI01L=joOjIiLjL0[LjiILI0OOL]<=joOjIiLjL0[LjiILI0OOL+1] else ILjOiI01L=joOjIiLjL0[LjiILI0OOL]>=joOjIiLjL0[LjiILI0OOL+1] end
if ILjOiI01L then joOjIiLjL0[LjiILI0OOL+3]=joOjIiLjL0[LjiILI0OOL] else lO0jil01i1=jl1ll11o+1 end
elseif iLojLiO0I0j1==7 then
joOjIiLjL0[LjiILI0OOL]=LloiO1(jLO1Oo1LIij1Ij,i0IOjOL0,jl1ll11o+1,jO0iOjLiIo101I[9])
elseif iLojLiO0I0j1==3 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=iI11LlOOoIl*llIi11L1olI
elseif iLojLiO0I0j1==35 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=iI11LlOOoIl-llIi11L1olI
elseif iLojLiO0I0j1==1 then
if (not not joOjIiLjL0[LjiILI0OOL])==(jl1ll11o~=0) then lO0jil01i1=ij1l0ILIl+1 end
elseif iLojLiO0I0j1==38 then
joOjIiLjL0[LjiILI0OOL]=not joOjIiLjL0[jl1ll11o]
elseif iLojLiO0I0j1==5 then
joOjIiLjL0[LjiILI0OOL]={}
elseif iLojLiO0I0j1==4 then
joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[jl1ll11o]/joOjIiLjL0[ij1l0ILIl]
elseif iLojLiO0I0j1==25 then
joOjIiLjL0[LjiILI0OOL]=#joOjIiLjL0[jl1ll11o]
elseif iLojLiO0I0j1==24 then
local ILjOiI01L
if jl1ll11o==0 then ILjOiI01L=i00j0OIoI-LjiILI0OOL else ILjOiI01L=jl1ll11o-1 end
local IlOj1ILoll1IoO={}
for iI11LlOOoIl=1,ILjOiI01L do IlOj1ILoll1IoO[iI11LlOOoIl]=joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl-1] end
return LLlIioO(IlOj1ILoll1IoO,1,ILjOiI01L)
elseif iLojLiO0I0j1==6 then
joOjIiLjL0[LjiILI0OOL]=(joOjIiLjL0[jl1ll11o]>=joOjIiLjL0[ij1l0ILIl])
elseif iLojLiO0I0j1==17 then
joOjIiLjL0[LjiILI0OOL]=(jl1ll11o~=0)
elseif iLojLiO0I0j1==33 then
joOjIiLjL0[LjiILI0OOL]=(joOjIiLjL0[jl1ll11o]>joOjIiLjL0[ij1l0ILIl])
elseif iLojLiO0I0j1==43 then
jo1o1oIII11=(jo1o1oIII11+jl1ll11o)%(ij1l0ILIl+1)
elseif iLojLiO0I0j1==44 then
joOjIiLjL0[LjiILI0OOL]={joOjIiLjL0[jl1ll11o]}
elseif iLojLiO0I0j1==27 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=iI11LlOOoIl[llIi11L1olI]
elseif iLojLiO0I0j1==29 then
joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[jl1ll11o]..joOjIiLjL0[ij1l0ILIl]
elseif iLojLiO0I0j1==26 then
for iI11LlOOoIl=LjiILI0OOL,LjiILI0OOL+jl1ll11o do joOjIiLjL0[iI11LlOOoIl]=nil end
elseif iLojLiO0I0j1==36 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=(iI11LlOOoIl<llIi11L1olI)
elseif iLojLiO0I0j1==19 then
local iI11LlOOoIl=LloiO1(jLO1Oo1LIij1Ij,i0IOjOL0,jl1ll11o+1,jO0iOjLiIo101I[9]);local llIi11L1olI=joOjIiLjL0[LjiILI0OOL];jOlLjji[iI11LlOOoIl]=llIi11L1olI
elseif iLojLiO0I0j1==39 then
local ILjOiI01L
if jl1ll11o==0 then ILjOiI01L=i00j0OIoI-LjiILI0OOL-1 else ILjOiI01L=jl1ll11o end
local llIi11L1olI=joOjIiLjL0[LjiILI0OOL]
for iI11LlOOoIl=1,ILjOiI01L do llIi11L1olI[ij1l0ILIl+iI11LlOOoIl]=joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl] end
elseif iLojLiO0I0j1==2 then
joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[jl1ll11o]^joOjIiLjL0[ij1l0ILIl]
elseif iLojLiO0I0j1==11 then
joOjIiLjL0[jl1ll11o][1]=joOjIiLjL0[LjiILI0OOL]
elseif iLojLiO0I0j1==41 then
joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[LjiILI0OOL]+joOjIiLjL0[LjiILI0OOL+2]
local llIi11L1olI=joOjIiLjL0[LjiILI0OOL+2]
local ILjOiI01L
if llIi11L1olI>0 then ILjOiI01L=joOjIiLjL0[LjiILI0OOL]<=joOjIiLjL0[LjiILI0OOL+1] else ILjOiI01L=joOjIiLjL0[LjiILI0OOL]>=joOjIiLjL0[LjiILI0OOL+1] end
if ILjOiI01L then joOjIiLjL0[LjiILI0OOL+3]=joOjIiLjL0[LjiILI0OOL]; lO0jil01i1=jl1ll11o+1 end
elseif iLojLiO0I0j1==20 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=iI11LlOOoIl+llIi11L1olI
elseif iLojLiO0I0j1==16 then
if jl1ll11o==0 then
for iI11LlOOoIl=1,l0jLjjliO do joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl-1]=lOlL101[iI11LlOOoIl] end
i00j0OIoI=LjiILI0OOL+l0jLjjliO
else
for iI11LlOOoIl=1,jl1ll11o-1 do joOjIiLjL0[LjiILI0OOL+iI11LlOOoIl-1]=lOlL101[iI11LlOOoIl] end
end
elseif iLojLiO0I0j1==9 then
joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[jl1ll11o][1]
elseif iLojLiO0I0j1==34 then
local iI11LlOOoIl=joOjIiLjL0[jl1ll11o];joOjIiLjL0[LjiILI0OOL]=iI11LlOOoIl
elseif iLojLiO0I0j1==18 then
joOjIiLjL0[LjiILI0OOL]=(joOjIiLjL0[jl1ll11o]~=joOjIiLjL0[ij1l0ILIl])
elseif iLojLiO0I0j1==28 then
joOjIiLjL0[LjiILI0OOL+1]=joOjIiLjL0[jl1ll11o]; joOjIiLjL0[LjiILI0OOL]=joOjIiLjL0[jl1ll11o][joOjIiLjL0[ij1l0ILIl]]
elseif iLojLiO0I0j1==15 then
local iI11LlOOoIl,llIi11L1olI=joOjIiLjL0[jl1ll11o],joOjIiLjL0[ij1l0ILIl];joOjIiLjL0[LjiILI0OOL]=iI11LlOOoIl%llIi11L1olI
elseif iLojLiO0I0j1==10 then
local llIi11L1olI=joOjIiLjL0[LjiILI0OOL]
local ioil0j0ll=joOjIiLjL0[LjiILI0OOL+1]
local iOoii0o=joOjIiLjL0[LjiILI0OOL+2]
local I0iO11OLLoLo=jIlli1oi1IllL(llIi11L1olI(ioil0j0ll,iOoii0o))
local IoOOoiIoL01=I0iO11OLLoLo[1]
if IoOOoiIoL01~=nil then
joOjIiLjL0[LjiILI0OOL+2]=IoOOoiIoL01
for iI11LlOOoIl=1,jl1ll11o do joOjIiLjL0[LjiILI0OOL+3+iI11LlOOoIl-1]=I0iO11OLLoLo[iI11LlOOoIl] end
lO0jil01i1=ij1l0ILIl+1
end
elseif iLojLiO0I0j1==12 then
joOjIiLjL0[LjiILI0OOL]=(joOjIiLjL0[jl1ll11o]<=joOjIiLjL0[ij1l0ILIl])
elseif iLojLiO0I0j1==8 then
local llIi11L1olI=joL01i1il[jl1ll11o+1]
local IlOj1ILoll1IoO={}
local I0iO11OLLoLo=llIi11L1olI[6]
for iI11LlOOoIl=1,#I0iO11OLLoLo do
local IoOOoiIoL01=I0iO11OLLoLo[iI11LlOOoIl]
if IoOOoiIoL01[1]==1 then IlOj1ILoll1IoO[iI11LlOOoIl]=joOjIiLjL0[IoOOoiIoL01[2]] else IlOj1ILoll1IoO[iI11LlOOoIl]=liiIlOIL[IoOOoiIoL01[2]+1] end
end
joOjIiLjL0[LjiILI0OOL]=j0i00ILoljoO(llIi11L1olI,IlOj1ILoll1IoO)
elseif iLojLiO0I0j1==14 then
lO0jil01i1=jl1ll11o+1
else i01oIiijo() end
end
return jo1o1oIII11
end
return ijlI0io00(jO0iOjLiIo101I,{},jIlli1oi1IllL(...))
