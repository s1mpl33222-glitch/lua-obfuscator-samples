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
  table.       concat(F)   end end;           local G;local H=game and game:GetService("HttpS".."ervice")or{}   
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
local p="tFfwCsDQiDxh".."rbqBic1CZRnp".."6srotGvkUCN5".."Xn+EJ2nt3rbq".."TSv8izjD1Nvk".."2RyTeZBskz1Q".."0Hr5PEDuUusV".."u/VHt7jJ9KTT".."X7xpxiD8flHa".."2WVyN3LPWY+Q".."lNNqH6grMp5T".."yOJ6WuUWITcg".."XmPDlM9Qs7fb".."VztTr6bC3YbK".."OqRFERrm/aM7".."D247UfIRt9cs".."GPv3/KWBTczB".."6o4srtzsJnnA".."bNj9FLKIVjNY".."nxBQl/4jfOYA".."r2bZ2H9ispmN".."tyAZs58GmPzu".."+SdHvQzbCeZl".."mO3g9BchDx3c".."60+YgXgpc7za".."AvJBS9cV4UB4".."S+pozT2glP+i".."lE7Hh+2pCMTF".."LFksM6CbtrHx".."DJcR1TPBfsQ5".."89SGOToksh3C".."8hZO4OcHwbBH".."XG8rjUict2pm".."CJzEe55ZofXo".."4LCBTJ47ikEb".."+Ifzqjmpozk2".."CdEQTqCzI3nX".."NskMX4hhgJXy".."nrkCW2RQLnOX".."HAM1Wdg9kd1C".."wejf4KuvYwGV".."3KHDZTsX9pwX".."7CQ5JGlA/5yQ".."qyoU7Edg13bB".."H7X4/m9xi801".."Zh8PAj++ynoK".."93o7qWqTi3Lr".."oWN4CSKr4ehY".."ivFioTHclDuo".."jYmczzj7XcdY".."/I4ypLNY1NLQ".."Nccnjs1AQVg3".."D6JEw4Q62Wyf".."Rj4tzwJ7T1NJ".."lR7CvhJ4vTga".."gIiKnJGnWdz3".."glJxV9m4RSIZ".."yBe0+SS7pRjD".."8euGra7S82bK".."SJ5RQV5AG9lS".."iW5hLfSL15kB".."aBNHlGP7UlAR".."cu2hr1fz+NEX".."OSxpFsRma/ep".."CrnNamAV7ykh".."w5dul5ggwi9Q".."FJgp2bEm1aGh".."lePS00pVpMhe".."iDyXCM9/kYlR".."cQL+NkzauAF+".."dtcm7B2luGDt".."xpzG6rrQsllj".."aMUQmg6nJ7vI".."dI+s1OepoJZl".."ByZm82ZZ6o4k".."A1Sphgg8niLc".."jjPsM6+gg8OC".."y+xCcLvDnedq".."eKfl1iU8tnOj".."X4vAjKPI7aJF".."T1VJTlI/6P6m".."lG+PLwPMG9/N".."jpT83hUjpond".."tGXurXEW++Th".."1qAnyrbBvIXK".."Ue5DfKAEBaGW".."ztx3JGxzVziG".."uX4UT+y6a2zl".."8jDQ5TYNl5rj".."96/TvT94JLLG".."l0qqYOot7d6F".."lPLiEJtn0RGb".."D4zYu5+VTa6f".."+W6iKAcqicaC".."jOuOUKdmaIw/".."GdXoj6nZVozt".."VC1KJP5dBw2N".."baBKoi2MlgI0".."aN8syEF24Gsn".."WDKghwGFPzvo".."Ojrk27jD378t".."MfUyzpAUuhgv".."PCq2ZAKEWrY7".."BScusF7hHjFF".."GuBcopNDoRM5".."iVbHI5fQwFeK".."mJLG1wMUAoIi".."UOpnW4AMzSj+".."1yZBv2eTatP9".."LMNnV5DaEGS+".."R/fDxIea/1/i".."oQ1KG2QH4xaW".."xTAt/9GXA/mB".."gVY/wrdCEfKb".."PMYM/8t1NNwx".."a2UQ0IlDIHyq".."WF3XgDBCBwCK".."NlnmyRKgBkRD".."7OIHfNBMkT1k".."uhzIlNiQx0Zp".."cu1pzmH3yjhH".."Qk+tRUF7hEcq".."q+BROsUNQtch".."4+D1sG4I7c+h".."ucobVqwebvQR".."GyzthoujXX+W".."XDTZUW3M92JX".."OG+XkCvYA53a".."htSJtFgF/GJC".."ivhi9jtUUvTq".."3C+2oAdXpj+Y".."wqA/rt21eIIm".."4Z7gDWM+Kn9P".."xCO7kFmbJeBp".."GRulXN735bwz".."daSKxlAyr0Tr".."wVezV0ik04BL".."H3gmdgPSraPJ".."VZwu1fE6XrhC".."bHBLvsDNXeiB".."QufTDn6ei2BL".."tD0dGxIJbzto".."lTkO3WfzGx42".."K2BRouh5CMKx".."lzWD8znH7yRZ".."S9TTIRp6PkEl".."OXjehoONZq1G".."6U+PBM+cAgL8".."i7JCMxk4WyDw".."UARaepXZOHGL".."MW+B7stIAFVt".."C2sahhYB3lKd".."KhdSSDFuuzD0".."UJkXyRR4rsMY".."NdyYmDXWQhiO".."sRZvR4LfObxV".."tTFZiw0KJomh".."JfigZz6wefZh".."AQKJp45wpIlV".."Hu2Ty0JB1DPK".."0QumBhD/XWVp".."k+7gxbln6SJa".."I1XPfgwlHtQI".."IS51pC3UUiin".."BFukFSLkNCPi".."OkVT98TzlPKn".."t9jlJftRvui4".."XgRVqoyOoXkM".."EbqYDmDm3qay".."Ybend2Dn5WpB".."jYFomTF+HCc4".."HrgZYUDnfi6j".."p7ZS3f207hpp".."5fVkVq61VMPX".."7Bqsur3NkZli".."imbwZ+DjNcrU".."FC57VmcxET9D".."Cmmm2q39BXh0".."bpJQWJnC4u2u".."y4WHh7NHxH5R".."SjPmCZKvq7DJ".."vKcrDqYsAm6r".."3SmppYevGD2d".."Y/bDXQyn1+JO".."IutXrmPhjlwD".."lZqPKWtqHtVD".."jQfiKxax+wcy".."wZOfSxo+QuKJ".."OKULeEuKpVKY".."TfXGBVE/ffCW".."ic0vd+FqnzRv".."xvo7xJa0OcQb".."SHsX0NMnvPtd".."PooBe8T8nabZ".."7LKZ9rqtJBYV".."6tEEA1VrTAkZ".."cFHm2SGtGGSi".."In/8fIkF+usY".."jtUOBXszrjUs".."ns9Ezj9LlwIo".."kNeav63KYSbU".."Zd5UgTgooZM2".."6GyyUoHPz6mT".."7KQJ6pWC9WG/".."FPHcKUKYtJj/".."y3Tv/GCkApcl".."JY7KBeLHOyem".."jAoRUtqL1Nx1".."JsY38/spTnTG".."gcD0grhlUKWN".."4VfQM2p7+vTA".."CSLFQnGZuvqE".."4e45rliEdr2g".."R6B2cjFSdfCx".."Ngn1/pKq7ir0".."UwXx7woSKJsb".."4v5b06Nmuswz".."vMQyNk/t2HiC".."1ZDtpU4H06Yb".."t1HkjI7wAz4t".."c1TvYsHblwlw".."7FssZ2FpjZ1t".."/hHxpdNsVJZx".."3OdY3ES5ZjM4".."oZHa6bfqgqJP".."w2HkKY2WEFuu".."p3RNvhj3ID1D".."CYIf0nCmDH+v".."Z2ZZ4tEKUGp1".."M46zbS2n2Q+b".."p6fcRoI4Jtpm".."ffs8EJVf+wZf".."oC6aaNkzUYnA".."Pj5xaBan6GyN".."6TY4NbDucApa".."VV8q0BYe/Ejf".."jcngM3jbA8/Y".."NbtUdx22ZyWI".."5S/9rkSjgh9d".."qImSWE9vf7bu".."AZAeeCHOyW45".."0yGaumoFM+P6".."s4/zsExzXpkV".."iFX+oLMHHSgl".."N2PO4XpREX/D".."QUypqmRirIR5".."2uAoM1tk6aJ8".."N+FiGZZhzb69".."6WFgSkRypsvL".."4rI9Da+53dxd".."8PsfOgJdYWDE".."c0mlOtwgEwHK".."gATuV1sypmXX".."mJW4FKPOahpa".."jbk6+ETgYs7v".."C2qWeAlnEgi8".."/TrVRLJxJvOM".."oOfvgoVRdlb5".."TMFIJnWTj4ee".."v6Ba465xYuuo".."ypGdKGWCJpib".."UBeB1HCPjeGs".."RNXFY6ts6Tw7".."1q+wDhS7pCYn".."xLGiK28eOfux".."CZM/humDXPSy".."/uWx5Ekl344E".."qdIxRLo3JxIF".."RU/7plY2o8iK".."+O1NKaI50QXW".."q3zFg7mtxUDl".."j0PFVYIgydYA".."ZEGtZJORIxuK".."2uZsMfnrQFSm".."rH5g9YxDsjU/".."9gJl2vYlpgeL".."R0TAhr9fuh7t".."J51gxkjg+0w0".."9IDhdJkkKPJw".."lqdbAT+o/vQ1".."BDfgVauz6YPG".."OXZZX2MSWFxr".."FrK9F2nqru1R".."U4aM6AREQMyq".."uLLRODxPhDnP".."CzzPblYIKIfF".."ZEB7T8pp7DRW".."2YQi6mm2Rv+s".."0t3xZ23qF2Wa".."AZ5I6x13v9AP".."Az0Ya8w7bH8b".."IApmgbVZO9fY".."SvCg248+4sDS".."DoqkyoCgL4RH".."NftXttP1gLAV".."YX4t7Y1ox454".."9eM3CBjuXTs9".."si1S+rCsanTW".."fORMnL1qvEFK".."q4GioAvHdaM9".."0nYl21Kxh8bI".."hTvybBuAD6HY".."7I+LOtEMGudH".."uBhUJWU1vGwi".."90mNHpxQr+bl".."LEuBdyJv9Ou4".."IK5ewwwh9bTo".."ZJZTZOrRrm2L".."exUgUP2WpWxC".."b8pMD5X4xvzF".."PrSqC1naqH5b".."3KsRo6qAf8+K".."Llll7Jru5bDT".."oEv4UuqRTiqI".."/5APyxs8dn2W".."QU+CuzQoDekk".."y/ealA"
local q={0x50,0xe1,0xe4,0x41,0x3e,0x77,0xf1,0x59}
local function hk(fn)
if type(fn)~="function" then return true end
if type(isfunctionhooked)=="function" then local ok,h=pcall(isfunctionhooked,fn) if ok and h then return true end end
if type(iscclosure)=="function" and type(islclosure)=="function" then local cOk,c=pcall(iscclosure,fn) local lOk,l=pcall(islclosure,fn) if cOk and lOk and l and not c then return true end end
if debug and type(debug.info)=="function" then local ok,src=pcall(debug.info,fn,"s") if ok and type(src)=="string" and src~="[C]" and src~="=[C]" then return true end end
return false
end
if hk(string.char) or hk(string.byte) or hk(table.concat) or hk(math.floor) or hk(pcall) then error("ho".."ok") end
local sc=string.char local sb=string.byte local tc=table.concat local mf=math.floor local ss=string.sub
local function ee(f,g) local h,i=0,1 while f>0 or g>0 do local j,k=f%2,g%2 if j~=k then h=h+i end f=mf(f/2) g=mf(g/2) i=i*2 end return h end
local SA=87 local MK=221
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
if type(isfunctionhooked)=="function" then local ok,h=pcall(isfunctionhooked,fn) if ok and h then error("du".."mp") end end
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
