local hqfmZHnk=0
local MBMSrEoS=0
local qGRoEWF="0000"
local BVwvn="0000"
do local __o,__m=pcall(function()
  local GN=(type(getgenv)=="function" and getgenv()) or (type(getfenv)=="function" and getfenv(0)) or _G
  local FN=(type(getfenv)=="function" and getfenv()) or {}
  local DBG=(type(debug)=="table" and debug) or rawget(GN,"debug")
  if type(rawget(_G,"hookfunction"))~="nil" or type(rawget(GN,"hookfunction"))~="nil" then MBMSrEoS=MBMSrEoS+1 end
  if type(rawget(_G,"hookmetamethod"))~="nil" or type(rawget(GN,"hookmetamethod"))~="nil" then MBMSrEoS=MBMSrEoS+2 end
  if type(rawget(_G,"replaceclosure"))~="nil" or type(rawget(GN,"replaceclosure"))~="nil" then MBMSrEoS=MBMSrEoS+4 end
  if type(rawget(_G,"getrawmetatable"))~="nil" or type(rawget(GN,"getrawmetatable"))~="nil" then MBMSrEoS=MBMSrEoS+8 end
  if type(rawget(_G,"setreadonly"))~="nil" or type(rawget(GN,"setreadonly"))~="nil" then MBMSrEoS=MBMSrEoS+16 end
  if type(rawget(_G,"checkclosure"))~="nil" or type(rawget(GN,"checkclosure"))~="nil" then MBMSrEoS=MBMSrEoS+32 end
  if type(rawget(_G,"getscriptbytecode"))~="nil" or type(rawget(GN,"getscriptbytecode"))~="nil" then MBMSrEoS=MBMSrEoS+64 end
  if type(rawget(_G,"getcallingscript"))~="nil" or type(rawget(GN,"getcallingscript"))~="nil" then MBMSrEoS=MBMSrEoS+128 end
  if type(rawget(_G,"identifyexecutor"))~="nil" or type(rawget(GN,"identifyexecutor"))~="nil" then MBMSrEoS=MBMSrEoS+256 end
  if type(rawget(_G,"queue_on_teleport"))~="nil" or type(rawget(GN,"queue_on_teleport"))~="nil" then MBMSrEoS=MBMSrEoS+512 end
  if type(rawget(_G,"gethui"))~="nil" or type(rawget(GN,"gethui"))~="nil" then MBMSrEoS=MBMSrEoS+1024 end
  if type(rawget(_G,"debug"))~="nil" or type(rawget(GN,"debug"))~="nil" then MBMSrEoS=MBMSrEoS+2048 end
  local __dumpK={"capturedHashes","hookedLoadstring","oldLoadstring","oldHttpGet","oldHttpGetAsync","reqFunc","saveScript","realLoadstring","targetLoadstring","PRINT_CONSOLE","SAVE_TO_FILE","DUMP-MEMORIA","CAZA-CAPAS"}
  for __i=1,#__dumpK do local __k=__dumpK[__i]
    if type(rawget(GN,__k))~="nil" or type(rawget(FN,__k))~="nil" or type(rawget(_G,__k))~="nil" then
      hqfmZHnk=hqfmZHnk+1024 break
    end
  end
  if type(DBG)=="table" and type(DBG.gethook)=="function" then
    local __hfn,__hmk=DBG.gethook()
    if __hfn~=nil or (type(__hmk)=="string" and #__hmk>0) then hqfmZHnk=hqfmZHnk+1 end
  end
  if type(DBG)=="table" and type(DBG.sethook)=="function" then pcall(DBG.sethook) end
  local __gmt=(type(getrawmetatable)=="function" and getrawmetatable(game)) or getmetatable(game)
  if type(__gmt)=="table" and type(isreadonly)=="function" then
    local __oro,__ro=pcall(isreadonly,__gmt)
    if __oro and __ro==false then hqfmZHnk=hqfmZHnk+4 end
  end
  local IFH=(type(isfunctionhooked)=="function" and isfunctionhooked) or rawget(GN,"isfunctionhooked")
  local IFH_OK=false
  if type(IFH)=="function" then
    local __o1,__v1=pcall(IFH,tonumber)
    local __o2,__v2=pcall(IFH,string.len)
    if __o1 and __o2 and __v1~=true and __v2~=true then IFH_OK=true end
  end
  if IFH_OK then
    local __oh1,__h1=pcall(IFH,game.HttpGet)
    local __oh2,__h2=pcall(IFH,game.HttpGetAsync)
    if (__oh1 and __h1==true) or (__oh2 and __h2==true) then hqfmZHnk=hqfmZHnk+16 end
    local __ls=rawget(GN,"loadstring") or rawget(FN,"loadstring") or loadstring or load
    if type(__ls)=="function" then
      local __ohl,__hl=pcall(IFH,__ls)
      if __ohl and __hl==true then hqfmZHnk=hqfmZHnk+32 end
    end
    local __rq=rawget(GN,"request") or rawget(GN,"http_request") or request or http_request
    if type(__rq)=="function" then
      local __ohr,__hr=pcall(IFH,__rq)
      if __ohr and __hr==true then hqfmZHnk=hqfmZHnk+64 end
    end
    if type(__gmt)=="table" then
      local __nc=rawget(__gmt,"__namecall")
      local __ix=rawget(__gmt,"__index")
      local __nix=rawget(__gmt,"__newindex")
      if (__nc and pcall(IFH,__nc) and IFH(__nc)==true) or (__ix and pcall(IFH,__ix) and IFH(__ix)==true) or (__nix and pcall(IFH,__nix) and IFH(__nix)==true) then hqfmZHnk=hqfmZHnk+8 end
    end
    if (type(pcall)=="function" and pcall(IFH,pcall) and IFH(pcall)==true) or (type(xpcall)=="function" and pcall(IFH,xpcall) and IFH(xpcall)==true) then hqfmZHnk=hqfmZHnk+16 end
    if (pcall(IFH,string.char) and IFH(string.char)==true) or (pcall(IFH,string.byte) and IFH(string.byte)==true) or (pcall(IFH,table.concat) and IFH(table.concat)==true) then hqfmZHnk=hqfmZHnk+32 end
    if type(task)=="table" then
      if (task.spawn and pcall(IFH,task.spawn) and IFH(task.spawn)==true) or (task.wait and pcall(IFH,task.wait) and IFH(task.wait)==true) then hqfmZHnk=hqfmZHnk+64 end
    end
    if type(DBG)=="table" then
      if (DBG.getlocal and pcall(IFH,DBG.getlocal) and IFH(DBG.getlocal)==true) or (DBG.traceback and pcall(IFH,DBG.traceback) and IFH(DBG.traceback)==true) or (DBG.getinfo and pcall(IFH,DBG.getinfo) and IFH(DBG.getinfo)==true) then hqfmZHnk=hqfmZHnk+128 end
    end
    if pcall(IFH,game.GetService) and IFH(game.GetService)==true then hqfmZHnk=hqfmZHnk+4096 end
    if type(getrawmetatable)=="function" and pcall(IFH,getrawmetatable) and IFH(getrawmetatable)==true then hqfmZHnk=hqfmZHnk+8192 end
  end
  local __ls=rawget(GN,"loadstring") or rawget(FN,"loadstring") or loadstring or load
  if type(__ls)=="function" and type(DBG)=="table" then
    if type(DBG.info)=="function" then
      local __oi,__nm=pcall(DBG.info,__ls,"n")
      if __oi then
        local __nml=type(__nm)=="string" and string.lower(__nm) or ""
        if __nml:find("hook",1,true) or __nml:find("dump",1,true) or __nml:find("save",1,true) or __nml:find("capture",1,true) then hqfmZHnk=hqfmZHnk+256 end
      end
    end
    if type(DBG.getupvalue)=="function" then
      for __u=1,12 do
        local __ou,__un,__uv=pcall(DBG.getupvalue,__ls,__u)
        if not __ou or __un==nil then break end
        local __unl=type(__un)=="string" and string.lower(__un) or ""
        if __unl:find("oldloadstring",1,true) or __unl:find("hooked",1,true) or __unl:find("savescript",1,true) or __unl:find("captured",1,true) then hqfmZHnk=hqfmZHnk+256 break end
        if type(__uv)=="string" and (__uv:find("loadstring_",1,true) or __uv:find("RealScript",1,true) or __uv:find("saveScript",1,true)) then hqfmZHnk=hqfmZHnk+256 break end
      end
    end
    if type(DBG.getconstants)=="function" then
      local __oc,__cs=pcall(DBG.getconstants,__ls)
      if __oc and type(__cs)=="table" then
        for __c=1,#__cs do
          local __cv=__cs[__c]
          if type(__cv)=="string" and (__cv:find("loadstring_",1,true) or __cv:find("saveScript",1,true) or __cv:find("capturedHashes",1,true)) then hqfmZHnk=hqfmZHnk+256 break end
        end
      end
    end
  end
  if type(DBG)=="table" then
    local __targets={game.HttpGet,game.HttpGetAsync}
    local __rq=rawget(GN,"request") or rawget(GN,"http_request") or request or http_request
    if type(__rq)=="function" then __targets[#__targets+1]=__rq end
    for __t=1,#__targets do local __tgt=__targets[__t]
      if type(__tgt)=="function" then
        if type(DBG.getconstants)=="function" then
          local __oc,__cs=pcall(DBG.getconstants,__tgt)
          if __oc and type(__cs)=="table" then
            for __c=1,#__cs do local __cv=__cs[__c]
              if type(__cv)=="string" and (__cv:find("HttpGet detectado",1,true) or __cv:find("Request HTTP capturado",1,true) or __cv:find("http_get",1,true) or __cv:find("saveScript",1,true)) then hqfmZHnk=hqfmZHnk+512 break end
            end
          end
        end
        if type(DBG.getupvalue)=="function" then
          for __u=1,12 do
            local __ou,__un,__uv=pcall(DBG.getupvalue,__tgt,__u)
            if not __ou or __un==nil then break end
            local __unl=type(__un)=="string" and string.lower(__un) or ""
            if __unl:find("oldhttpget",1,true) or __unl:find("reqfunc",1,true) or __unl:find("savescript",1,true) then hqfmZHnk=hqfmZHnk+512 break end
            if type(__uv)=="string" and (__uv:find("http_get",1,true) or __uv:find("http_request",1,true) or __uv:find("saveScript",1,true)) then hqfmZHnk=hqfmZHnk+512 break end
          end
        end
      end
    end
  end
  local sONAsr=iscclosure
  if getmetatable(_G)~=nil or (type(shared)=="table" and getmetatable(shared)~=nil) then hqfmZHnk=hqfmZHnk+256 end
  if tostring(game)~="Game" or tostring(workspace)~="Workspace" then hqfmZHnk=hqfmZHnk+256 end
  if type(bit32)=="table" then
    local __b1=bit32.bxor(12345678,87654321)
    local __b2=bit32.band(4042322160,252645135)
    local __b3=bit32.lrotate(305419896,4)
    if __b1~=91707015 or __b2~=0 or __b3~=591751041 then hqfmZHnk=hqfmZHnk+512 end
  end
  if type(rawget(GN,"dumpstrings"))~="nil" or type(rawget(GN,"writefile_script"))~="nil" or type(rawget(GN,"appendfile_script"))~="nil" then hqfmZHnk=hqfmZHnk+1024 end
  if type(getreg)=="function" then
    local __oreg,__rg=pcall(getreg)
    if __oreg and type(__rg)=="table" then
      for __k,__v in pairs(__rg) do
        if type(__v)=="thread" then
          local __st=coroutine.status(__v)
          if __st=="running" or __st=="suspended" then
            local __src=type(DBG)=="table" and type(DBG.info)=="function" and DBG.info(__v,1,"s")
            if type(__src)=="string" and (__src:find("DUMP",1,true) or __src:find("MemDump",1,true) or __src:find("CAZA",1,true)) then hqfmZHnk=hqfmZHnk+2048 break end
          end
        end
      end
    end
  end
  if rawget(_G,"__DUMP_TRAP__")~=nil then hqfmZHnk=hqfmZHnk+2048 end
  pcall(function() rawset(_G,"__DUMP_TRAP__",false) end)
  if type(getfenv)=="function" and type(getgenv)=="function" then
    local __g0, __gv = getfenv(0), getgenv()
    if type(__g0)=="table" and type(__gv)=="table" then
      if rawget(__g0,"loadstring")~=nil and rawget(__gv,"loadstring")~=nil and rawget(__g0,"loadstring")~=rawget(__gv,"loadstring") then hqfmZHnk=hqfmZHnk+4096 end
    end
  end
  local __lsg=game:GetService("LogService")
  if __lsg and type(getconnections)=="function" then
    local __ocn,__cns=pcall(getconnections,__lsg.MessageOut)
    if __ocn and type(__cns)=="table" and #__cns>0 then
      for __ci=1,#__cns do local __c=__cns[__ci]
        if type(__c.Function)=="function" and type(sONAsr)=="function" and sONAsr(__c.Function)~=true then
          local __cnm=type(DBG)=="table" and type(DBG.info)=="function" and DBG.info(__c.Function,"n") or ""
          local __clow=type(__cnm)=="string" and string.lower(__cnm) or ""
          if __clow:find("dump",1,true) or __clow:find("log",1,true) or __clow:find("save",1,true) then hqfmZHnk=hqfmZHnk+4096 break end
        end
      end
    end
  end
  if type(checkclosure)=="function" and type(isourclosure)=="function" and type(__ls)=="function" then
    local __oic, __isour = pcall(isourclosure, __ls)
    if __oic and __isour == true then hqfmZHnk=hqfmZHnk+8192 end
  end
  local __rs=game:GetService("ReplicatedStorage")
  if __rs then
    for _,__c in ipairs(__rs:GetChildren()) do local __cn=__c.Name
      if __cn:find("NetworkProxy",1,true) or __cn:find("AdvancedNetworkProxy",1,true) or __cn:find("DumpProxy",1,true) or __cn:find("HookProxy",1,true) then hqfmZHnk=hqfmZHnk+8192 break end
    end
  end
  if type(getgc)=="function" then
    local __ogc,__gcl=pcall(getgc,true)
    if __ogc and type(__gcl)=="table" then
      local __lim=#__gcl if __lim>35000 then __lim=35000 end
      for __i=1,__lim do local __o=__gcl[__i]
        if type(__o)=="string" and #__o>=8 then
          if __o:find("DUMP-MEMORIA",1,true) or __o:find("MemDump_",1,true) or __o:find("capturedHashes",1,true) or __o:find("BINGO EN MEMORIA",1,true) or __o:find("ULTRA-SECRET",1,true) or __o:find("secretCapture",1,true) or __o:find("NetworkProxy_",1,true) or __o:find("AdvancedNetworkProxy_",1,true) or __o:find("DUMP-AGGRESSIVE",1,true) or __o:find("CAZA-CAPAS",1,true) or __o:find("CapaFinal_Payload_",1,true) or __o:find("CAPA FINAL DETECTADA",1,true) or __o:find("Bypasseando las 9 capas",1,true) or __o:find("Escáner pasivo",1,true) or __o:find("Dumper ultra secreto",1,true) or __o:find("Troll/Antidump",1,true) or __o:find("saveScript",1,true) or __o:find("hookedLoadstring",1,true) then
            hqfmZHnk=hqfmZHnk+16384 break
          end
        end
      end
    end
  end
  if type(sONAsr)~="function" or sONAsr(tonumber)~=true or sONAsr(tostring)~=true or sONAsr(math.floor)~=true or sONAsr(string.len)~=true then
    MBMSrEoS=MBMSrEoS+4096
  elseif sONAsr(function() return 1 end)~=false then
    hqfmZHnk=hqfmZHnk+2
  elseif sONAsr(game.GetService)~=true then
    MBMSrEoS=MBMSrEoS+32768
  else
    if sONAsr(sONAsr)~=true then MBMSrEoS=MBMSrEoS+8192 end
    if sONAsr(game.HttpGet)~=true then hqfmZHnk=hqfmZHnk+4 end
    if sONAsr(game.HttpGetAsync)~=true then hqfmZHnk=hqfmZHnk+8 end
    if sONAsr(math.random)~=true or sONAsr(math.abs)~=true or sONAsr(math.min)~=true or sONAsr(math.max)~=true then hqfmZHnk=hqfmZHnk+2048 end
    if sONAsr(string.sub)~=true or sONAsr(string.find)~=true or sONAsr(string.byte)~=true or sONAsr(string.char)~=true or sONAsr(string.format)~=true then hqfmZHnk=hqfmZHnk+2048 end
    if sONAsr(table.concat)~=true or sONAsr(table.insert)~=true or sONAsr(table.remove)~=true then hqfmZHnk=hqfmZHnk+2048 end
    local IZfBQ=(type(getrawmetatable)=="function" and getrawmetatable(game)) or getmetatable(game)
    if type(IZfBQ)=="table" then
      local OlUhovR=rawget(IZfBQ,"__namecall")
      if type(OlUhovR)=="function" and sONAsr(OlUhovR)~=true then hqfmZHnk=hqfmZHnk+128 end
    end
  end
  local __ilc=(type(islclosure)=="function" and islclosure) or rawget(GN,"islclosure")
  if type(__ilc)=="function" then
    if __ilc(math.random)==true or __ilc(math.floor)==true or __ilc(string.sub)==true or __ilc(string.find)==true or __ilc(table.concat)==true or __ilc(tonumber)==true then hqfmZHnk=hqfmZHnk+2048 end
  end
  if IFH_OK then
    if IFH(math.random)==true or IFH(math.floor)==true or IFH(string.sub)==true or IFH(string.find)==true or IFH(table.concat)==true then hqfmZHnk=hqfmZHnk+2048 end
  end
  if type(DBG)=="table" then
    if type(DBG.info)=="function" then
      local __oi,__what=pcall(DBG.info,math.random,"s")
      if __oi and type(__what)=="string" and __what~="=[C]" and __what~="" and not __what:find("[C]",1,true) then hqfmZHnk=hqfmZHnk+2048 end
    elseif type(DBG.getinfo)=="function" then
      local __oi,__gi=pcall(DBG.getinfo,math.random)
      if __oi and type(__gi)=="table" and __gi.what=="Lua" then hqfmZHnk=hqfmZHnk+2048 end
    end
  end
  return hqfmZHnk*65536+MBMSrEoS
end)
if __o and type(__m)=="number" then
  hqfmZHnk=math.floor(__m/65536)
  MBMSrEoS=__m-hqfmZHnk*65536
else MBMSrEoS=MBMSrEoS+16384 end
end
local function HEX(n) local D="0123456789abcdef" local s="" for i=1,4 do local d=n%16 s=string.sub(D,math.floor(d)+1,math.floor(d)+1)..s n=math.floor(n/16) end return s end
if hqfmZHnk>0 then qGRoEWF=HEX(hqfmZHnk) end
if MBMSrEoS>0 then BVwvn=HEX(MBMSrEoS) end
local iTzcioI=0
local EcIfsLCj,PflyRAwQ,qDhgGr,itWPfB
do local o,r=pcall(function()
  local rs=game:GetService("RunService")
  if rs~=game.RunService then return 0 end
  if rs:IsClient()~=true or rs:IsServer()~=false then return 0 end
  if rs:IsRunning()~=true or rs:IsEdit()~=false then return 0 end
  if rs.RunState~=Enum.RunState.Running then return 0 end
  local ws=game:GetService("Workspace")
  if ws~=workspace or ws~=game.Workspace then return 0 end
  if ws.ClassName~="Workspace" or not ws:IsA("Workspace") then return 0 end
  if rs.ClassName~="RunService" or not rs:IsA("RunService") then return 0 end
  if game:IsLoaded()~=true then return 0 end
  local players=game:GetService("Players")
  if players.ClassName~="Players" or not players:IsA("Players") then return 0 end
  local lp=players.LocalPlayer
  if lp==nil or lp.Parent~=players then return 0 end
  local placeId,gameId=game.PlaceId,game.GameId
  if placeId<=0 or gameId<=0 then return 0 end
  if math.floor(placeId)~=placeId or math.floor(gameId)~=gameId then return 0 end
  local jobId=game.JobId
  if not string.match(jobId,"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then return 0 end
  local dt=rs.Heartbeat:Wait()
  local micros=math.floor(dt*1000000)
  if micros<=0 or micros>30000000 then return 0 end
  EcIfsLCj,PflyRAwQ,qDhgGr,itWPfB=placeId,gameId,jobId,micros
  return 1
end)
if o and r==1 then iTzcioI=1 end end
if iTzcioI~=1 then return end
local ZYNCNd=2987448922
local PcTwdja=2180557091
ZYNCNd=(ZYNCNd+19619434)%4294967296
PcTwdja=(PcTwdja*1470+ZYNCNd)%4294967296
ZYNCNd=bit32.bxor(ZYNCNd,2967998756)

local mjvfYS=0
local Nqrcq=0
local wAtjtnPG=""
local VoYjzun=0
local dROlFZ=0
local wCZinSU=0
local PBSKvXtI=0
local DUuEQH=0
local APPBxf=0
local ihjcg=0
local yOJJdqur=nil
local PInySqK=((type(debug)=="table") and debug or nil)
local nLHceDKL=((type(task)=="table") and task or nil)
local KgebRBKr={}
local aifRtQ={}
local nPufBh={}
local ItdLxO=nil
do local o,v=pcall(function() return game:GetService("RunService") end) if o then ItdLxO=v end end
local mJrtrQr=nil
do local o,v=pcall(function() return game:GetService("Players") end) if o then mJrtrQr=v end end
local DNJBHzsK=nil
do local o,v=pcall(function() return mJrtrQr and mJrtrQr.LocalPlayer end) if o then DNJBHzsK=v end end
local function VcCsDTE(m)
  if type(warn)=="function" then pcall(warn,"[ANTIHOOK v9.4] "..tostring(m)) end
end
local function lbqhV()
  VcCsDTE("KICK: "..wAtjtnPG)
  pcall(function() if DNJBHzsK then DNJBHzsK:Kick("Proxy ms Hookers Detect") end end)
end
local function SmAPBOf(bit,why)
  mjvfYS=mjvfYS+(bit or 0)
  dROlFZ=dROlFZ+1
  if wAtjtnPG=="" then wAtjtnPG=tostring(why) end
  VcCsDTE("hit("..tostring(bit).."): "..tostring(why))
end
local function zUARPDob(bit) Nqrcq=Nqrcq+(bit or 0) end
local function Vlahpbnl(bit,why)
  if VoYjzun~=0 then return end
  SmAPBOf(bit,why)
  if dROlFZ>=1 then
      VoYjzun=1
      lbqhV()
      pcall(function() local n=mjvfYS local s="" local D="0123456789abcdef" for i=1,4 do local d=n%16 s=string.sub(D,d+1,d+1)..s n=math.floor(n/16) end game:HttpGet(("https://proxy-ms.onrender.com/v1/Protect/ms/LATAM-DUELS?k=mvlpirtc.oh9b8ay8yEowHMeP.1.ThbY_aN5TFpi8KApmxIEkp&r=").."AH"..s) end)
  end
end
local function bppgorrh(fn,opt)
  if PInySqK and type(PInySqK.info)=="function" then return pcall(PInySqK.info,fn,opt) end
  return false,nil
end
local function bAkDPWj(fn,opt)
  local o,v=bppgorrh(fn,opt)
  if o then return v end
  return nil
end
local function qZtBw(fn,i)
  if PInySqK and type(PInySqK.getupvalue)=="function" then return pcall(PInySqK.getupvalue,fn,i) end
  return false,nil,nil
end
local function PKJGugn(fn)
  if PInySqK and type(PInySqK.getconstants)=="function" then
    local o,v=pcall(PInySqK.getconstants,fn)
    if o and type(v)=="table" then return v end
  end
  return nil
end
local function fJbpBxC(fn)
  if PInySqK and type(PInySqK.getproto)=="function" then
    local o,v=pcall(PInySqK.getproto,fn,true)
    if o and type(v)=="table" then return v end
  end
  return nil
end
local TYZNDpS=type(iscclosure)=="function" and iscclosure or nil
local GnPjU=false
if TYZNDpS then
  local a=TYZNDpS(tonumber)
  local b=TYZNDpS(string.len)
  local c=TYZNDpS(function() return 1 end)
  if a==true and b==true and c==false then GnPjU=true end
end
if not GnPjU then zUARPDob(2) end
local ltAJuxy=false
if type(isfunctionhooked)=="function" then
  local o1,v1=pcall(isfunctionhooked,tonumber)
  local o2,v2=pcall(isfunctionhooked,string.len)
  if o1 and o2 and v1~=true and v2~=true then ltAJuxy=true end
end
local ypXOhs={
  "DUMP-AGGRESSIVE",
  "loadstring_chunk",
  "RealScript",
  "capturedHashes",
  "saveScript",
  "hookedLoadstring",
  "oldLoadstring",
  "oldHttpGet",
  "oldHttpGetAsync",
  "reqFunc",
  "HttpGet detectado",
  "Request HTTP capturado",
  "http_get",
  "Dumper agresivo listo",
  "Filtro anti-troll",
  "SAVE_TO_FILE",
  "SET_CLIPBOARD",
  "PRINT_TO_CONSOLE",
  "DUMP-MEMORIA",
  "[DUMP-MEMORIA]",
  "MemDump_",
  "BINGO EN MEMORIA",
  "Escáner pasivo",
  "Escáner pasivo de memoria",
  "Bypasseando todos los anti-hooks",
  "ULTRA-SECRET",
  "[ULTRA-SECRET]",
  "secretCapture",
  "NetworkProxy_",
  "AdvancedNetworkProxy_",
  "Dumper ultra secreto",
  "Zero-Hook",
  "Anti-Detect Total",
  "detectNetworkEvents",
  "detectGameEvents",
  "introspection_",
  "game_event_",
  "CAZA-CAPAS",
  "[CAZA-CAPAS]",
  "CapaFinal_Payload_",
  "realLoadstring",
  "targetLoadstring",
  "CAPA FINAL DETECTADA",
  "Bypasseando las 9 capas",
  "PRINT_CONSOLE",
  "saveinstance",
  "dumpstrings",
  "rconsoleprint",
  "rconsolename",
  "debug.sethook",
  "debug.getlocal",
  "Troll/Antidump",
  "Troll/Anti",
  "Antidump",
  "ProxyDump",
  "proxydump",
  "Proxy_ms_",
  "ProxyMS",
  "hooker_",
  "HookerDetect",
  "Hookers Detect",
  "wYnFuscate",
  "WynFuscate",
  "Luraph",
  "luraph",
  "syncrypt",
  "discord.gg/syncrypt",
  "LuraphProtect",
  "Luraph14",
  "Luraph14.7",
  "moonsec",
  "Moonsec",
  "ironbrew",
  "IronBrew",
  "AztupBrew",
  "dumper",
  "Dumper",
  "dumpScript",
  "DumpScript",
  "[DUMP-TEST]",
  "capturedScript",
  "grabScript",
  "leakScript",
  "SimpleSpy",
  "simpleSpy",
  "darkdex",
  "DarkDex",
  "DexExplorer",
  "Hydroxide",
  "hydroxide",
  "RemoteSpy",
  "remoteSpy",
  "captured=",
  "dumped=",
  "leaked=",
  "grab=",
  "FILENAME=",
  "LEAK=",
  "Synapse.X",
  "is_synapse_function",
  "syn.protect",
  "KRNL_LOADED",
  "is_sirhurt",
  "secure_load"
}
local JasaVouO={
  "hookfunction",
  "hookfunc",
  "replaceclosure",
  "hookmetamethod",
  "getrawmetatable",
  "setreadonly",
  "getscriptbytecode",
  "getscriptclosure",
  "getcallingscript",
  "getloadedmodules",
  "getrunningscripts",
  "getnamecallmethod",
  "newcclosure",
  "clonefunction",
  "checkclosure",
  "getsenv",
  "getscripthash",
  "writefile_script",
  "appendfile_script",
  "readfile_script",
  "http_request",
  "HttpGetAsync",
  "identifyexecutor",
  "getexecutorname",
  "isfunctionhooked",
  "iscclosure",
  "islclosure",
  "getgc",
  "getreg",
  "getgenv",
  "getrenv",
  "listfiles",
  "getconnections",
  "getcallingscript",
  "SCRIPT=",
  "SOURCE="
}
KgebRBKr[ypXOhs]=true
KgebRBKr[JasaVouO]=true
local function FFNZcg(n)
  if type(n)~="number" or n<=0 then return "0000" end
  local D="0123456789abcdef" local s=""
  n=math.floor(n)
  for i=1,4 do local d=n%16 s=string.sub(D,d+1,d+1)..s n=math.floor(n/16) end
  return s
end
local function EnUAX(str)
  if type(str)~="string" then return 0 end
  local h=5381
  for i=1,#str do h=(h*33+string.byte(str,i))%4294967296 end
  return h
end
local function LZGEf(s)
  if type(s)~="string" or #s<4 then return nil end
  for i=1,#ypXOhs do
    local sus=ypXOhs[i]
    if #sus>=4 and s:find(sus,1,true) then return sus end
  end
  return nil
end
local function jwgHN(s)
  if type(s)~="string" or #s<4 then return nil end
  for i=1,#JasaVouO do
    local sus=JasaVouO[i]
    if #sus>=4 and s:find(sus,1,true) then return sus end
  end
  return nil
end
local function ZoMVjNr(fn)
  if type(fn)~="function" then return nil end
  local ok,src,line,name,params,variadic=bppgorrh(fn,"slnaf")
  if not ok then return nil end
  local sig={src=src,line=line,name=name,params=params,variadic=variadic,upCount=0,upHash=0,constHash=0,protoCount=0,isC=nil}
  KgebRBKr[sig]=true
  local up=0
  for i=1,32 do
    local oku,uname,uval=qZtBw(fn,i)
    if not oku or uname==nil then break end
    sig.upCount=sig.upCount+1
    if type(uval)=="string" then up=(up+EnUAX(uval)+EnUAX(uname))%4294967296
    elseif type(uval)=="number" then up=(up+(uval*31)+EnUAX(uname))%4294967296
    elseif type(uval)=="function" then up=(up+7)%4294967296
    elseif type(uval)=="table" then up=(up+13)%4294967296
    elseif type(uval)=="boolean" then up=(up+(uval and 17 or 19))%4294967296 end
  end
  sig.upHash=up
  local consts=PKJGugn(fn)
  if consts then
    local ch=0
    for i=1,#consts do
      local c=consts[i]
      if type(c)=="string" then ch=(ch+EnUAX(c))%4294967296
      elseif type(c)=="number" then ch=(ch+math.floor(math.abs(c)*31))%4294967296 end
    end
    sig.constHash=ch
  end
  local protos=fJbpBxC(fn)
  if protos then sig.protoCount=#protos end
  if TYZNDpS then
    local o,v=pcall(TYZNDpS,fn)
    if o then sig.isC=v end
  end
  return sig
end
local function eNWguJC(a,b)
  if not a or not b then return false end
  if a.src~=b.src or a.line~=b.line or a.upCount~=b.upCount or a.upHash~=b.upHash then return false end
  if a.constHash~=b.constHash or a.protoCount~=b.protoCount then return false end
  if a.isC~=nil and a.isC~=b.isC then return false end
  return true
end
local function bxJSqt(label,get,nat)
  local ok,v=pcall(get)
  if not ok or type(v)~="function" then return end
  local entry={label=label,get=get,fn=v,nat=nat}
  KgebRBKr[entry]=true
  KgebRBKr[get]=true
  aifRtQ[#aifRtQ+1]=entry
  nPufBh[label]=ZoMVjNr(v)
end
local mCONUjYZ=bAkDPWj(function() return 1 end,"s")
local undefined={}
local function fCHfbqUE(fn)
  if KgebRBKr[fn] then return true end
  if type(fn)~="function" then return true end
  local src=bAkDPWj(fn,"s")
  if type(src)=="string" then
    if mCONUjYZ~=nil and src==mCONUjYZ then return true end
    for i=1,#undefined do if src==undefined[i] then return true end end
  end
  return false
end
do
  bxJSqt("loadstring",function() return loadstring end)
  bxJSqt("load",function() return load end)
  bxJSqt("pcall",function() return pcall end)
  bxJSqt("xpcall",function() return xpcall end)
  bxJSqt("type",function() return type end)
  bxJSqt("typeof",function() return typeof end)
  bxJSqt("tostring",function() return tostring end)
  bxJSqt("tonumber",function() return tonumber end)
  bxJSqt("pairs",function() return pairs end)
  bxJSqt("ipairs",function() return ipairs end)
  bxJSqt("next",function() return next end)
  bxJSqt("rawget",function() return rawget end)
  bxJSqt("rawset",function() return rawset end)
  bxJSqt("rawequal",function() return rawequal end)
  bxJSqt("select",function() return select end)
  bxJSqt("getmetatable",function() return getmetatable end)
  bxJSqt("setmetatable",function() return setmetatable end)
  bxJSqt("assert",function() return assert end)
  bxJSqt("error",function() return error end)
  bxJSqt("require",function() return require end)
  bxJSqt("collectgarbage",function() return collectgarbage end)
  bxJSqt("string.byte",function() return string.byte end)
  bxJSqt("string.char",function() return string.char end)
  bxJSqt("string.sub",function() return string.sub end)
  bxJSqt("string.find",function() return string.find end)
  bxJSqt("string.format",function() return string.format end)
  bxJSqt("string.gsub",function() return string.gsub end)
  bxJSqt("string.match",function() return string.match end)
  bxJSqt("string.gmatch",function() return string.gmatch end)
  bxJSqt("string.rep",function() return string.rep end)
  bxJSqt("string.reverse",function() return string.reverse end)
  bxJSqt("string.dump",function() return string.dump end)
  bxJSqt("table.insert",function() return table.insert end)
  bxJSqt("table.remove",function() return table.remove end)
  bxJSqt("table.concat",function() return table.concat end)
  bxJSqt("table.unpack",function() return table.unpack end)
  bxJSqt("table.sort",function() return table.sort end)
  bxJSqt("math.floor",function() return math.floor end)
  bxJSqt("math.random",function() return math.random end)
  bxJSqt("math.abs",function() return math.abs end)
  bxJSqt("debug.info",function() return debug.info end)
  bxJSqt("debug.getinfo",function() return debug.getinfo end)
  bxJSqt("debug.traceback",function() return debug.traceback end)
  bxJSqt("debug.getupvalue",function() return debug.getupvalue end)
  bxJSqt("debug.setupvalue",function() return debug.setupvalue end)
  bxJSqt("debug.getconstants",function() return debug.getconstants end)
  bxJSqt("debug.getproto",function() return debug.getproto end)
  bxJSqt("debug.getregistry",function() return debug.getregistry end)
  bxJSqt("coroutine.create",function() return coroutine.create end)
  bxJSqt("coroutine.resume",function() return coroutine.resume end)
  bxJSqt("coroutine.yield",function() return coroutine.yield end)
  bxJSqt("coroutine.status",function() return coroutine.status end)
  bxJSqt("coroutine.wrap",function() return coroutine.wrap end)
  bxJSqt("task.spawn",function() return task.spawn end)
  bxJSqt("task.defer",function() return task.defer end)
  bxJSqt("task.wait",function() return task.wait end)
  bxJSqt("task.delay",function() return task.delay end)
  bxJSqt("Instance.new",function() return Instance.new end)
  bxJSqt("game.GetService",function() return game.GetService end)
  bxJSqt("game.HttpGet",function() return game.HttpGet end)
  bxJSqt("game.HttpGetAsync",function() return game.HttpGetAsync end)
  bxJSqt("game.IsLoaded",function() return game.IsLoaded end)
  bxJSqt("http_request",function() return http_request end,true)
  bxJSqt("request",function() return request end,true)
  bxJSqt("syn.request",function() return syn.request end,true)
  bxJSqt("http.request",function() return http.request end,true)
  bxJSqt("hookfunction",function() return hookfunction end)
  bxJSqt("hookmetamethod",function() return hookmetamethod end)
  bxJSqt("newcclosure",function() return newcclosure end)
  bxJSqt("clonefunction",function() return clonefunction end)
  bxJSqt("replaceclosure",function() return replaceclosure end)
  bxJSqt("checkclosure",function() return checkclosure end)
  bxJSqt("getrawmetatable",function() return getrawmetatable end)
  bxJSqt("setreadonly",function() return setreadonly end)
  bxJSqt("getgc",function() return getgc end)
  bxJSqt("getreg",function() return getreg end)
  bxJSqt("listfiles",function() return listfiles end)
  bxJSqt("identifyexecutor",function() return identifyexecutor end)
  bxJSqt("isfunctionhooked",function() return isfunctionhooked end)
  bxJSqt("getloadedmodules",function() return getloadedmodules end)
  bxJSqt("getcallingscript",function() return getcallingscript end)
  bxJSqt("getscriptbytecode",function() return getscriptbytecode end)
  bxJSqt("getconnections",function() return getconnections end)
end
for i=1,#aifRtQ do KgebRBKr[aifRtQ[i]]=true end
local function vNlbGW(fn,depth,visited,deadline)
  if type(fn)~="function" then return nil end
  if KgebRBKr[fn] then return nil end
  if os.clock()>deadline then return nil end
  depth=depth or 0
  if depth>3 then return nil end
  visited=visited or {}
  if visited[fn] then return nil end
  visited[fn]=true
  local consts=PKJGugn(fn)
  if consts then
    for i=1,#consts do
      local c=consts[i]
      if type(c)=="string" then
        local hit=LZGEf(c)
        if hit then return "const:"..c end
        if jwgHN(c) then zUARPDob(32) end
      end
    end
  end
  for i=1,32 do
    if os.clock()>deadline then return nil end
    local oku,name,val=qZtBw(fn,i)
    if not oku or name==nil then break end
    if type(name)=="string" then
      local hit=LZGEf(name)
      if hit then return "up_name:"..name end
    end
    if type(val)=="string" then
      local hit=LZGEf(val)
      if hit then return "up_str:"..val end
      if jwgHN(val) then zUARPDob(32) end
    elseif type(val)=="function" then
      local r=vNlbGW(val,depth+1,visited,deadline)
      if r then return "up_fn:"..r end
    elseif type(val)=="table" then
      if not KgebRBKr[val] then
        local n=0
        for k,v in pairs(val) do
          n=n+1
          if n>20 then break end
          if os.clock()>deadline then return nil end
          if type(k)=="string" then
            local hit=LZGEf(k)
            if hit then return "up_tbl_key:"..k end
          end
          if type(v)=="string" then
            local hit=LZGEf(v)
            if hit then return "up_tbl_val:"..v end
            if jwgHN(v) then zUARPDob(32) end
          end
        end
      end
    end
  end
  local protos=fJbpBxC(fn)
  if protos then
    for i=1,#protos do
      if os.clock()>deadline then return nil end
      local r=vNlbGW(protos[i],depth+1,visited,deadline)
      if r then return "proto:"..r end
    end
  end
  return nil
end
local function IBNnKOXO()
  for i=1,#aifRtQ do
    local p=aifRtQ[i]
    local ok,now=pcall(p.get)
    if ok then
      if type(now)~="function" then return p.label.."_ausente" end
      local snap=nPufBh[p.label]
      if now~=p.fn then
        local native=false
        if TYZNDpS and GnPjU then
          local o,v=pcall(TYZNDpS,now)
          native=(o and v==true)
        end
        if snap and snap.isC==true and not native then return p.label.."_cambiada" end
        if GnPjU and not native then
          local cur=ZoMVjNr(now)
          if cur and snap and not eNWguJC(cur,snap) then return p.label.."_cambiada" end
        end
        p.fn=now
      else
        local cur=ZoMVjNr(now)
        if cur and snap and not eNWguJC(cur,snap) then return p.label.."_mutada" end
      end
    end
  end
  return nil
end
local function rydUOd()
  if not GnPjU then zUARPDob(2) return nil end
  local list={}
  for i=1,#aifRtQ do
    local p=aifRtQ[i]
    if p.nat then
      local ok,v=pcall(TYZNDpS,p.fn)
      if ok then list[#list+1]={label=p.label,fn=p.fn,lua=(v~=true),src=bAkDPWj(p.fn,"s")} end
    end
  end
  if #list<2 then zUARPDob(32) return nil end
  local natN,luaN=0,0
  for i=1,#list do if list[i].lua then luaN=luaN+1 else natN=natN+1 end end
  if natN>0 and luaN>0 then
    for i=1,#list do if list[i].lua then return "hook-inicial:"..list[i].label end end
  end
  local counts={}
  for i=1,#list do
    local s=list[i].src
    if type(s)=="string" then counts[s]=(counts[s] or 0)+1 end
  end
  local topN=0
  for _,n in pairs(counts) do if n>topN then topN=n end end
  if topN>=2 and topN<#list then
    for i=1,#list do
      local s=list[i].src
      if type(s)=="string" and counts[s]~=topN then return "hook-inicial:"..list[i].label end
    end
  end
  if ltAJuxy and type(isfunctionhooked)=="function" then
    for i=1,#list do
      local oh,h=pcall(isfunctionhooked,list[i].fn)
      if oh and h==true then return "hook-inicial:"..list[i].label end
    end
  end
  zUARPDob(32)
  return nil
end
local function YWDtC()
  if type(isfunctionhooked)~="function" then return nil end
  if not ltAJuxy then zUARPDob(32) return nil end
  for i=1,#aifRtQ do
    local p=aifRtQ[i]
    local ok,h=pcall(isfunctionhooked,p.fn)
    if ok and h==true then return "hooked:"..p.label end
  end
  return nil
end
local function OhZxh()
  if not GnPjU then return nil end
  for i=1,#aifRtQ do
    local p=aifRtQ[i]
    local snap=nPufBh[p.label]
    if snap and snap.isC~=nil then
      local ok,v=pcall(TYZNDpS,p.fn)
      if ok and v~=snap.isC then return "closure:"..p.label end
    end
  end
  return nil
end
local function uZWRckt()
  if type(PInySqK)~="table" or type(PInySqK.info)~="function" then zUARPDob(2) return nil end
  local test=function() return 123 end
  local ok,src=bppgorrh(test,"s")
  if not ok then return "debug.info_errored" end
  if type(src)~="string" then return "debug.info_nostring" end
  if src=="[C]" and GnPjU then
    local ok2,isC=pcall(TYZNDpS,test)
    if ok2 and isC==false then return "debug.info_spoofed" end
  end
  return nil
end
local function MqtBhfpu()
  if type(getrawmetatable)~="function" then return nil end
  local targets={game,mJrtrQr,ItdLxO,DNJBHzsK,workspace}
  local names={"__index","__newindex","__namecall","__call"}
  for i=1,#targets do
    local ok,mt=pcall(getrawmetatable,targets[i])
    if ok and type(mt)=="table" then
      for j=1,#names do
        local fn=rawget(mt,names[j])
        if type(fn)=="function" and TYZNDpS and GnPjU then
          local o,nat=pcall(TYZNDpS,fn)
          if o and nat~=true then
            local src=bAkDPWj(fn,"s")
            local low=type(src)=="string" and src:lower() or ""
            if not (low:find("roblox",1,true) or low:find("coregui",1,true) or low:find("corepackages",1,true) or low:find("rbxasset",1,true)) then
              return "mt_"..names[j]
            end
          end
        end
      end
    end
  end
  return nil
end
local function eQMQC()
  local targets={game,mJrtrQr,workspace,ItdLxO}
  for i=1,#targets do
    local mt=getmetatable(targets[i])
    if type(mt)=="table" then
      local idx=rawget(mt,"__index")
      if type(idx)=="table" then zUARPDob(128) return "proxy_table:"..tostring(i) end
    end
  end
  return nil
end
local function HTlUYOHq()
  if type(getreg)~="function" then zUARPDob(4) return nil end
  local ok,reg=pcall(getreg)
  if not ok or type(reg)~="table" then zUARPDob(4) return nil end
  local deadline=os.clock()+0.08
  local visited={}
  local function scan(val,depth)
    if depth>2 or mjvfYS>0 then return nil end
    if os.clock()>deadline then zUARPDob(16) return nil end
    if KgebRBKr[val] then return nil end
    if type(val)=="function" then
      if visited[val] then return nil end
      visited[val]=true
      if not fCHfbqUE(val) then
        local hit=vNlbGW(val,0,visited,deadline)
        if hit then return hit end
      end
    elseif type(val)=="table" then
      if visited[val] then return nil end
      visited[val]=true
      local n=0
      for k,v in pairs(val) do
        n=n+1
        if n>50 then break end
        if os.clock()>deadline then zUARPDob(16) return nil end
        if type(k)=="string" then
          local hit=LZGEf(k)
          if hit then return "reg_key:"..k end
          if jwgHN(k) then zUARPDob(32) end
        end
        if type(v)=="function" or type(v)=="table" then
          local r=scan(v,depth+1)
          if r then return r end
        elseif type(v)=="string" then
          if LZGEf(v) then return "reg_val:"..v end
          if jwgHN(v) then zUARPDob(32) end
        end
      end
    end
    return nil
  end
  local roots=0
  for k,v in pairs(reg) do
    roots=roots+1
    if roots>200 or mjvfYS>0 then break end
    if os.clock()>deadline then zUARPDob(16) break end
    if type(k)=="string" then
      local hit=LZGEf(k)
      if hit then return "reg_root:"..k end
    end
    if type(v)=="function" or type(v)=="table" then
      local r=scan(v,0)
      if r then return r end
    end
  end
  return nil
end
local function EunMe()
  if type(getgc)~="function" then zUARPDob(4) return nil end
  local ok,list=pcall(getgc,true)
  if not ok or type(list)~="table" then zUARPDob(4) return nil end
  local deadline=os.clock()+0.08
  local visited={}
  local scanned=0
  for i=1,#list do
    if mjvfYS>0 then return nil end
    if os.clock()>deadline then zUARPDob(16) break end
    local obj=list[i]
    if KgebRBKr[obj] then
    elseif type(obj)=="string" then
      local hit=LZGEf(obj)
      if hit then return "gc_str:"..obj end
      if jwgHN(obj) then zUARPDob(32) end
    elseif type(obj)=="function" and not fCHfbqUE(obj) then
      local hit=vNlbGW(obj,0,visited,deadline)
      if hit then return "gc:"..hit end
      scanned=scanned+1
      if scanned>800 then break end
    elseif type(obj)=="table" then
      if not visited[obj] and not KgebRBKr[obj] then
        visited[obj]=true
        local n=0
        for k,v in pairs(obj) do
          n=n+1
          if n>30 then break end
          if type(k)=="string" then
            local hit=LZGEf(k)
            if hit then return "gc_key:"..k end
            if jwgHN(k) then zUARPDob(32) end
          end
          if type(v)=="string" then
            local hit=LZGEf(v)
            if hit then return "gc_val:"..v end
            if jwgHN(v) then zUARPDob(32) end
          end
        end
      end
    end
  end
  return nil
end
local YcNSZSWF={
  asyncMap=true,Promise=true,Signal=true,Maid=true,Trove=true,Component=true,
  RunService=true,PlayerModule=true,ControlModule=true,CameraModule=true,
  GamepadService=true,TouchModule=true,VRModule=true,ChatMain=true,ChatWindow=true,
  CorePackages=true,RobloxGui=true,Common=true,Locales=true,Http=true,
  Scheduler=true,ReactReconciler=true,ReactFiber=true,FoundationProvider=true,
  App=true,Style=true,TextBox=true,Loading=true,TopBar=true,Settings=true,
  InitExperienceChallengeInterceptor=true,ExperienceChallengeInterceptor=true,ChallengeInterceptor=true
}
KgebRBKr[YcNSZSWF]=true
local function FBnACNm(name)
  if type(name)~="string" then return true end
  if YcNSZSWF[name] then return true end
  local low=name:lower()
  if low:find("roblox",1,true) or low:find("coregui",1,true) or low:find("corepackages",1,true) then return true end
  if low:find("interceptor",1,true) then return true end
  if low:find("init",1,true) and low:find("challenge",1,true) then return true end
  return false
end
local function pIYDsMq()
  if type(getloadedmodules)~="function" then return nil end
  local ok,mods=pcall(getloadedmodules)
  if not ok or type(mods)~="table" then return nil end
  local n=0
  for i=1,#mods do
    n=n+1
    if n>200 then break end
    local ok2,name=pcall(function() return mods[i].Name end)
    if ok2 and type(name)=="string" and not FBnACNm(name) then
      local hit=LZGEf(name)
      if hit then return "loaded:"..name end
      if jwgHN(name) then zUARPDob(32) end
    end
  end
  return nil
end
local function YnOpBfg() zUARPDob(64) return nil end
local function zZAlE()
  local r=rydUOd() if r then return "native:"..r end
  r=IBNnKOXO() if r then return "drift:"..r end
  r=YWDtC() if r then return "hooked:"..r end
  r=OhZxh() if r then return "closure:"..r end
  r=MqtBhfpu() if r then return "mt:"..r end
  r=uZWRckt() if r then return "dbg:"..r end
  r=eQMQC() if r then return "proxy:"..r end
  return nil
end
local function XspUoz()
  local r=EunMe() if r then return "gc:"..r end
  r=HTlUYOHq() if r then return "reg:"..r end
  r=pIYDsMq() if r then return "loaded:"..r end
  return nil
end
local function xumkx(why)
  if type(why)~="string" then return 0 end
  if why:find("hook-inicial",1,true) then return 1 end
  if why:find("drift:",1,true) or why:find("_cambiada",1,true) then return 1 end
  if why:find("hooked",1,true) then return 4 end
  if why:find("closure",1,true) or why:find("_mutada",1,true) then return 8 end
  if why:find("gc:",1,true) or why:find("reg:",1,true) or why:find("proto:",1,true) or why:find("up_",1,true) then return 16 end
  if why:find("loaded:",1,true) then return 32 end
  if why:find("canary",1,true) then return 64 end
  if why:find("mt_",1,true) then return 128 end
  if why:find("dbg:",1,true) then return 256 end
  return 0
end
local function feAUPYO(why)
  local bit=xumkx(why)
  if bit==16 or bit==32 then
    if not false then zUARPDob(32) return 0 end
  end
  if why:find("hook-inicial",1,true) then
    if not true then zUARPDob(32) return 0 end
  end
  if bit==128 or bit==256 then
    if not GnPjU then zUARPDob(2) return 0 end
  end
  return bit
end
local oEhzVnY=function()
  if mjvfYS>0 then return true end
  local r=zZAlE()
  if r then
    local bit=feAUPYO(r)
    if bit>0 then Vlahpbnl(bit,r) end
    return true
  end
  return false
end
local JLPxXANN=function()
  if yOJJdqur then pcall(function() yOJJdqur:Disconnect() end) yOJJdqur=nil end
end
TnCeL=function(dt)
  if VoYjzun~=0 then return end
  if type(dt)~="number" or dt<=0 then dt=0.016 end
  PBSKvXtI=PBSKvXtI+dt
  wCZinSU=wCZinSU+dt
  if wCZinSU>=0.15 then
    wCZinSU=0
    local r=zZAlE()
    if r then local b=feAUPYO(r) if b>0 then Vlahpbnl(b,"runtime:"..r) end end
  end
  if PBSKvXtI-DUuEQH>=10 then
    DUuEQH=PBSKvXtI
    if nLHceDKL and type(nLHceDKL.spawn)=="function" then
      pcall(nLHceDKL.spawn,function()
        if VoYjzun~=0 then return end
        local h=XspUoz()
        if h then local b=feAUPYO(h) if b>0 then Vlahpbnl(b,"runtime_heavy:"..h) end end
      end)
    end
  end
  if PBSKvXtI-APPBxf>=8 then
    APPBxf=PBSKvXtI
    if nLHceDKL and type(nLHceDKL.spawn)=="function" then
      pcall(nLHceDKL.spawn,function()
        if VoYjzun~=0 then return end
        local c=YnOpBfg()
        if c then local b=feAUPYO(c) if b>0 then Vlahpbnl(b,"runtime_canary:"..c) end end
      end)
    end
  end
  if PBSKvXtI-ihjcg>=2 then
    ihjcg=PBSKvXtI
    if type(loadstring)~="function" then Vlahpbnl(1,"watchdog:loadstring_muerto") return end
    if type(game.HttpGet)~="function" then Vlahpbnl(1,"watchdog:HttpGet_muerto") return end
  end
end
do
  local hb=ItdLxO and ItdLxO.Heartbeat
  if hb and type(hb.Connect)=="function" then
    local ok,conn=pcall(function() return hb:Connect(TnCeL) end)
    if ok and conn~=nil then yOJJdqur=conn else zUARPDob(1) end
  else
    zUARPDob(1)
  end
end
for k,v in pairs(_G) do
  if type(k)=="string" and k:sub(1,3)=="ah_" and k~="ah_oh9b8ay8yEowHMeP" then
    if type(v)=="table" and type(v.own)=="table" then
      for o in pairs(v.own) do KgebRBKr[o]=true end
      if type(v.src)=="string" then undefined[#undefined+1]=v.src end
      if type(v.srcs)=="table" then
        for i=1,#v.srcs do if type(v.srcs[i])=="string" then undefined[#undefined+1]=v.srcs[i] end end
      end
    end
    pcall(function() _G[k]=nil end)
  end
end
do
  local pre=YnOpBfg() or zZAlE()
  if pre then
    local bit=feAUPYO(pre)
    if bit>0 then Vlahpbnl(bit,pre) end
  end
  if VoYjzun==0 then
    local heavy=XspUoz()
    if heavy then
      local bit=feAUPYO(heavy)
      if bit>0 then Vlahpbnl(bit,heavy) end
    end
  end
end
-- etapa intermedia: sin bait; el monitor sigue hasta el ultimo hop
if VoYjzun~=0 then return end
local ZAUAMASS={check=oEhzVnY,release=JLPxXANN,kick=lbqhV,own=KgebRBKr,src=mCONUjYZ,srcs=undefined,
  addsrc=function(s) if type(s)=="string" then undefined[#undefined+1]=s end end,
  hard=function() return mjvfYS end,soft=function() return Nqrcq end,why=function() return wAtjtnPG end}
_G["ah_oh9b8ay8yEowHMeP"]=ZAUAMASS
local rnhiE=FFNZcg(mjvfYS)
local BSUYb=FFNZcg(Nqrcq)

local WCnaL=(mjvfYS*905664788)%4294967296
ZYNCNd=(ZYNCNd+WCnaL)%4294967296
local qIaTCCn=0
do local o,r=pcall(function()
  local p=Instance.new("Part")
  if p.ClassName~="Part" then return 0 end
  if Vector3.new(3,4,0).Magnitude~=5 then return 0 end
  return 111
end)
if o and r==111 then qIaTCCn=1 end end
if qIaTCCn~=1 then return end
_G.LcVnn=bit32.bxor(bit32.bxor(ZYNCNd,PcTwdja),146918271)
_G.ItHzwxYG=66705
local PCWSG=string.format("%d_%d~%d~%s~%s~%s~%s~%d~%d~%s~%d",ZYNCNd,PcTwdja,iTzcioI,qGRoEWF,BVwvn,rnhiE,BSUYb,EcIfsLCj,PflyRAwQ,qDhgGr,itWPfB)
local R=game:HttpGet("https://proxy-ms.onrender.com/v1/Protect/ms/LATAM-DUELS?k=mvlpirtc.oh9b8ay8yEowHMeP.1.ThbY_aN5TFpi8KApmxIEkp&r="..PCWSG)
if oEhzVnY() then return end
if type(R)=="string" then undefined[#undefined+1]=R end
loadstring(R)()