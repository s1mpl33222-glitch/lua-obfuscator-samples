setthreadidentity(8)
pcall(function() local a,b=pcall(identifyexecutor) local c={"potassium","wave","synapse","seliware","velocity","volt"} local d=false if a and type(b)=="string" then for _,e in ipairs(c) do if string.find(string.lower(b),string.lower(e),1,true) then d=true break end end end if not d then game:GetService("StarterGui"):SetCore("SendNotification",{Title="Nexus Hub",Text=(a and b or "Unknown Executor").." isn't officially supported by Nexus Hub, expect bugs!",Duration=8}) end end)
local _AT_fok,_AT_src=pcall(game.HttpGet,game,"https://nexushub.lol/api/internal/auth-timer?c=dev&t=1791909465896.85e7f17cc239a83095538d9513f6dc2c42923ed572c6b2efe22b34fbb28165f2",true)
if not _AT_fok then game:GetService("StarterGui"):SetCore("SendNotification",{Title="Nexus Hub",Text="Failed to start (AuthTimer): "..tostring(_AT_src),Duration=10}) else _G.AuthTimer=loadstring(_AT_src)() _G.AuthTimer.Start() end
local _02327792e08f6a85abb8328ed0257={"token","X-Api-Key","webhook"};local _352109d80685fa63767368e00f458={16407,5734,26701,29677};local _6b07c3f1edd6a2b1b4be4bfa03c69=16407*5734;
local _E=getgenv()
_E.__NxCh="dev";_E.__NxChS="1791911085896.453a3e86425380b512ecddfb903f840446bdf040e0c17adc36b7028494c8e651"
init={
  _c77ae531069c045d2b8b79b4fbb5df46="85/83/88/86/3/87/7/86/2/3/15/4/2/0/87/91/14/86/8/11/3/83/86/82/5/86/1/81/83/83/6/5/4/4/9/7/4/80/87/5/6/95/4/87/6/88/85/85",
  _f0f43ff4a7f55c9ed8c02a558c5c7318="2/83/14/115/13/87/3/7/27/6/10/33/6/72/1/33/116/35/29/10/119/85/15/76/7/80/13/118/12/39/114/119/7/14/0/85",
  _d488e8599688b390f3a26b829b69b318="121/57/106/31/0/91/1/117/27/116/9/92/115/72/3/38/115/85",
  _2d262e3c388873863e8a2ac1bc807caa="86/7/13/87/87/91/7/12/27/3/93/85/85/72/5/2/5/81/29/83/5/0/82/76/1/89/95/7/1/84/1/3/85/2/1/6",
  _c058047b5380ee5a389cff5c30259333="7a925c04679e6e1c6f026a7a",
  _8d72f3bf87236ddff84d61817f8d249d="7/92/81/87/7/15/83/81/7/85/1/5/1/6/0/3/2/2/94/0/87/9/3/83/6/9/85/87/83/13/93/0",
  _e259a5b661f4d4d8c16f84991352e77a="780a78dd130661143a87e941",
  _6a6138e5228390e4b9b9b09a78e0df97="7/79/11/6/90",
  _84d894415e2156a6e3d103cbb516abfb="0/84/14/81/7/5/7/1/80/84/0/1/84/3/1/85/15/82/4/5/80/3/81/0/83/89/15/1/86/81/84/86/87/7/12/82/14/3/80/90/83/83/82/6/82/3/3/87/84/3/90/2/83/81/83/13/84/6/95/6/85/83/7/91",
  _a57b673424ddff2d60d6489e5e4e76d0="86/82/92/11/1/83/82/12/87/81/11/92/14/1/2/84/5/84/86/2/0/4/5/2/14/80/90/4/87/91/83/86/15/82/13/87/82/80/80/0/6/87/82/7/83/81/82/88/1/85/13/4/6/87/83/3/83/2/92/1/80/6/9/86",
  _d959bde4e64b4c9b443ad046c1042ce6="86/86/93/84/13/2/84/80/0/0/90/6/3/85/87/87/85/82/2/86/7/89/83/7/82/87/11/3/13/85/82/1/0/15/93/4/4/84/7/81/80/95/2/11/83/86/0/88/3/88/11/81/4/0/4/87/83/82/8/87/84/82/0/91",
  _29a0b8f1c9fde414eab5f7087df90213=tick(),
  _87da0ba0845c24323d19415c6e7a8e39=(function() local s={} local ok,gc=pcall(getgc,true) if ok and gc then for _,v in ipairs(gc) do if type(v)=="function" then s[v]=true end end end return s end)(),
  _baeedc81831381b581fd5c22fe7c9d2a=(function() local ok,t=pcall(function() local t={} for i,v in (getallthreads and getallthreads()) or (getreg and getreg()) or (getgc and getgc(true)) or {} do if type(v)=="thread" and not table.find(t,v) then table.insert(t,v) end end return t end) return ok and t or {} end)(),
  _11679eda32eb6d54797fe9dd3ced0="X-Api-Key",
  _35393be7d3c142adcb0a4161e5271=56090,
  _c665fd8802a16931b977e411da692=27025,
  _22ecc3ed93471541b0373ab5c0df3=33907,
}
_E._nxi={i="_c77ae531069c045d2b8b79b4fbb5df46",u="_f0f43ff4a7f55c9ed8c02a558c5c7318",k="_d488e8599688b390f3a26b829b69b318",a="_2d262e3c388873863e8a2ac1bc807caa",x="_c058047b5380ee5a389cff5c30259333",t="_29a0b8f1c9fde414eab5f7087df90213",s="_87da0ba0845c24323d19415c6e7a8e39",th="_baeedc81831381b581fd5c22fe7c9d2a",lk="_8d72f3bf87236ddff84d61817f8d249d",lx="_e259a5b661f4d4d8c16f84991352e77a",sv="_6a6138e5228390e4b9b9b09a78e0df97",rk="_84d894415e2156a6e3d103cbb516abfb",ck="_a57b673424ddff2d60d6489e5e4e76d0",as="_d959bde4e64b4c9b443ad046c1042ce6",ch="dev",_a048706c4e9d6c395e015c33457f4=tick()*8.4486,_6acea2745dee76a01d0b3867b25f5=tick()*5.1879,_626cf7c494997dcd8c84b92b26786=tick()*4.3762}
local _110dd78fc392dfa3ac50287a65dea={"X-Request-ID","X-Request-ID","Cache-Control"};local _916aad2dcd44a45147e60929e1c7b={1910,26187,36283,57348};local _96280991dfc66368c53af5348e73c=1910*26187;
print("Dev v0.24o")
local _BL_fok,_BL_src=pcall(game.HttpGet,game,"https://nexushub.lol/api/internal/bridge-loader?c=dev&t=1791909465896.531742635b43a00566f438d89c38af31b595f32b49be301bbe553fb3a982b1ff")
if not _BL_fok then game:GetService("StarterGui"):SetCore("SendNotification",{Title="Nexus Hub",Text="Failed to load: "..tostring(_BL_src),Duration=10}) else loadstring(_BL_src)("Any attempt to crack Nexus will result in permanent blacklist") end