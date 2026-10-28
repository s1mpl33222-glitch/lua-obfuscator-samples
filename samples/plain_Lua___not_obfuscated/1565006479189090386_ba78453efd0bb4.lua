-- Do not save this file
-- Always use the loadstring
local _bsdata0={"https://plotmor.pages.dev"};
local _pm_gui=nil
local _pm_kick=function(m) pcall(function() if _pm_gui then pcall(function() _pm_gui:Destroy() end) _pm_gui=nil end end) pcall(function() game:GetService("Players").LocalPlayer:Kick("[Plotmor] "..tostring(m)) end) end
local _pm_key=""
do
  local ok,kv=pcall(function() return (getgenv and getgenv().Key) or nil end)
  if ok and type(kv)=="string" and #kv>0 then _pm_key=kv end
end
if _pm_key=="" and type(_G)=="table" and type(_G.Key)=="string" then _pm_key=_G.Key end
if _pm_key=="" and type(_bsdata0[2])=="string" then _pm_key=_bsdata0[2] end
local _pm_hw1,_pm_hw2="",""
pcall(function() if type(gethwid)=="function" then _pm_hw1=tostring(gethwid()) end end)
if type(_pm_hw1)~="string" then _pm_hw1="" end
pcall(function() _pm_hw2=tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
if type(_pm_hw2)~="string" then _pm_hw2="" end
local _pm_sr
if type(http_request)=="function" then _pm_sr=http_request elseif type(request)=="function" then _pm_sr=request elseif type(syn)=="table" and type(syn.request)=="function" then _pm_sr=syn.request end
if not _pm_sr then
  _pm_kick("Error PM-09")
  return error("Plotmor",0)
end
local _pm_gkill=function() if _pm_gui then pcall(function() _pm_gui:Destroy() end) _pm_gui=nil end end
pcall(function()
  if type(Instance)=="nil" or type(game)=="nil" then return end
  local sg=Instance.new("ScreenGui")
  sg.Name="PlotmorLoading"
  sg.ResetOnSpawn=false
  sg.DisplayOrder=999999
  local tl=Instance.new("TextLabel")
  tl.Size=UDim2.new(0,240,0,46)
  tl.Position=UDim2.new(0.5,-120,0.84,-23)
  tl.BackgroundColor3=Color3.fromRGB(18,18,18)
  tl.BackgroundTransparency=0.2
  tl.TextColor3=Color3.fromRGB(235,235,235)
  tl.Font=Enum.Font.Gotham
  tl.TextSize=15
  tl.Text="loading your script..."
  tl.Parent=sg
  local par=nil
  pcall(function() par=(gethui and gethui()) or nil end)
  if not par then pcall(function() par=game:GetService("CoreGui") end) end
  if not par then pcall(function() local pl=game:GetService("Players").LocalPlayer if pl then par=pl:FindFirstChildOfClass("PlayerGui") end end) end
  if par then sg.Parent=par end
  _pm_gui=sg
end)
-- anti-dump probe: a dump tool captures compile input, so a canary comment
-- marks it. Runs once, before any auth traffic; punishes only on use.
do
  local _pm_pls=loadstring or load
  local _pm_cap=false
  pcall(function()
    local _pm_g=_G
    pcall(function() if type(getgenv)=="function" then local g=getgenv() if type(g)=="table" then _pm_g=g end end end)
    local _pm_mk="PM_P_"..tostring(math.random(100000,999999))
    local _pm_dk={"_LAST_DUMP","_PM_DUMP","_KM_DUMP","_pm_dump","_pm_dumped","dumped"}
    for _pm_j=1,#_pm_dk do pcall(function() rawset(_pm_g,_pm_dk[_pm_j],nil) end) end
    pcall(function() _pm_pls("--".._pm_mk..string.rep("x",200)) end)
    for _pm_j=1,#_pm_dk do
      local _pm_d
      pcall(function() _pm_d=rawget(_pm_g,_pm_dk[_pm_j]) end)
      if type(_pm_d)=="string" and string.find(_pm_d,_pm_mk,1,true) then _pm_cap=true end
      pcall(function() rawset(_pm_g,_pm_dk[_pm_j],nil) end)
    end
    pcall(function()
      local _pm_sweep=function()
        if type(getgc)~="function" then return end
        local _ok,_gc=pcall(getgc,true)
        if not _ok or type(_gc)~="table" then return end
        for _i=1,#_gc do
          if _i>20000 or _pm_cap then break end
          local _v=_gc[_i]
          if type(_v)=="table" then
            local _n=0
            for _k2,_w in pairs(_v) do
              _n=_n+1
              if _n>30 or _pm_cap then break end
              if type(_w)=="string" and string.find(_w,"PM_P_%d%d%d%d%d%dxxx") then _pm_cap=true end
            end
          end
        end
        if _pm_cap then
          pcall(function() _pm_sr({Url=_bsdata0[1].."/api/tamper?sid=ba78453efd0bb4&hwid="..(_pm_hw1~="" and _pm_hw1 or _pm_hw2).."&reason=dump_probe_loader",Method="GET"}) end)
          pcall(function() local _pm_lp=game:GetService("Players").LocalPlayer if _pm_lp then _pm_lp:Kick("[Plotmor] Error PM-12") end end)
        end
      end
      if task and task.spawn then task.spawn(_pm_sweep) else local _co=coroutine.create(_pm_sweep) coroutine.resume(_co) end
    end)
  end)
  if _pm_cap then
    pcall(function()
      _pm_sr({Url=_bsdata0[1].."/api/tamper?sid=ba78453efd0bb4&hwid="..(_pm_hw1~="" and _pm_hw1 or _pm_hw2).."&reason=dump_probe_loader",Method="GET"})
    end)
    pcall(function() local _pm_lp=game:GetService("Players").LocalPlayer if _pm_lp then _pm_lp:Kick("[Plotmor] Error PM-12") end end)
    return error("failed to load script",0)
  end
end
local _pm_hsvc=game:GetService("HttpService")
local _pm_tok,_pm_k,_pm_ec
do
  local _pm_reg=""
  if _bsdata0[3] then
    -- Keyless flow: register this device first (the redeem step). The server
    -- refuses sessions for devices it has not seen register.
    local _pm_who=""
    pcall(function() _pm_who=tostring(game:GetService("Players").LocalPlayer.Name) end)
    _pm_who=_pm_who:gsub("[^%w_]","")
    for _pm_i=1,2 do
      local _pm_okr,_pm_rj=pcall(function()
        local _pm_rr=_pm_sr({Url=_bsdata0[1].."/api/hwid/check?scriptId=".._bsdata0[3].."&hwid="..(_pm_hw1~="" and _pm_hw1 or _pm_hw2).."&user=".._pm_who,Method="GET"})
        local _pm_b=type(_pm_rr)=="table" and (_pm_rr.Body or _pm_rr.body) or _pm_rr
        return _pm_hsvc:JSONDecode(tostring(_pm_b))
      end)
      if _pm_okr and type(_pm_rj)=="table" and _pm_rj.valid and type(_pm_rj.token)=="string" and #_pm_rj.token>0 then
        _pm_reg=_pm_rj.token
        break
      end
      if _pm_okr and type(_pm_rj)=="table" and type(_pm_rj.ec)=="string" then _pm_ec=_pm_rj.ec end
      pcall(function() task.wait(0.4) end)
    end
    if _pm_reg=="" then
      _pm_kick(_pm_ec or "Error PM-07")
      return error("Plotmor",0)
    end
  end
  local _pm_body
  if _bsdata0[3] then
    _pm_body={key=_pm_key,hwid=_pm_hw1,hwid2=_pm_hw2,scriptId=_bsdata0[3],ver="pm15.3.46",reg=_pm_reg}
  else
    _pm_body={key=_pm_key,hwid=_pm_hw1,hwid2=_pm_hw2,ver="pm15.3.46"}
  end
  for _pm_i=1,2 do
    local _pm_ok,_pm_tj=pcall(function()
      local _pm_rr=_pm_sr({Url=_bsdata0[1].."/api/session",Method="POST",Headers={["Content-Type"]="application/json"},Body=_pm_hsvc:JSONEncode(_pm_body)})
      local _pm_b=type(_pm_rr)=="table" and (_pm_rr.Body or _pm_rr.body) or _pm_rr
      return _pm_hsvc:JSONDecode(tostring(_pm_b))
    end)
    if _pm_ok and type(_pm_tj)=="table" and _pm_tj.ok and _pm_tj.token then
      _pm_tok=tostring(_pm_tj.token)
      break
    end
    if _pm_ok and type(_pm_tj)=="table" and type(_pm_tj.ec)=="string" then _pm_ec=_pm_tj.ec end
    pcall(function() task.wait(0.4) end)
  end
end
if not _pm_tok then
  _pm_kick(_pm_ec or "Error PM-01")
  return error("Plotmor",0)
end
do
  local B=bit32
  local function rol(x,n) return B.bor(B.lshift(x,n),B.rshift(x,32-n)) end
  local _pm_A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local _pm_bt={}
  for i=1,64 do _pm_bt[_pm_A:byte(i)]=i-1 end
  local function b64d(s)
    local b,k2={},0
    for i=1,#s,4 do
      local c1=_pm_bt[s:byte(i)] or 0
      local c2=_pm_bt[s:byte(i+1)] or 0
      local c3=_pm_bt[s:byte(i+2)] or 0
      local c4=_pm_bt[s:byte(i+3)] or 0
      local v=c1*262144+c2*4096+c3*64+c4
      k2=k2+1 b[k2]=string.char(math.floor(v/65536)%256)
      if s:byte(i+2) then k2=k2+1 b[k2]=string.char(math.floor(v/256)%256) end
      if s:byte(i+3) then k2=k2+1 b[k2]=string.char(v%256) end
    end
    return table.concat(b)
  end
  local function le32(s,i) return s:byte(i)+s:byte(i+1)*256+s:byte(i+2)*65536+s:byte(i+3)*16777216 end
  local function w2b(w) return string.char(w%256,math.floor(w/256)%256,math.floor(w/65536)%256,math.floor(w/16777216)%256) end
  local C0,C1,C2,C3=0x61707865,0x3320646e,0x79622d32,0x6b206574
  local function qr(a,b,c,d)
    a=(a+b)%4294967296; d=rol(B.bxor(d,a),16); c=(c+d)%4294967296; b=rol(B.bxor(b,c),12)
    a=(a+b)%4294967296; d=rol(B.bxor(d,a),8); c=(c+d)%4294967296; b=rol(B.bxor(b,c),7)
    return a,b,c,d
  end
  local function blk(kw,ctr,nw)
    local x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15 =
      C0,C1,C2,C3,kw[1],kw[2],kw[3],kw[4],kw[5],kw[6],kw[7],kw[8],ctr,nw[1],nw[2],nw[3]
    local st={x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15}
    for _=1,10 do
      x0,x4,x8,x12=qr(x0,x4,x8,x12); x1,x5,x9,x13=qr(x1,x5,x9,x13)
      x2,x6,x10,x14=qr(x2,x6,x10,x14); x3,x7,x11,x15=qr(x3,x7,x11,x15)
      x0,x5,x10,x15=qr(x0,x5,x10,x15); x1,x6,x11,x12=qr(x1,x6,x11,x12)
      x2,x7,x8,x13=qr(x2,x7,x8,x13); x3,x4,x9,x14=qr(x3,x4,x9,x14)
    end
    local t={x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15}
    local o={}
    for i=1,16 do o[i]=w2b((t[i]+st[i])%4294967296) end
    return table.concat(o)
  end
  local function poly(key32,msg)
    local B=bit32
    local CLEAR={[28]=true,[29]=true,[30]=true,[31]=true,[32]=true,[33]=true,[60]=true,
      [61]=true,[62]=true,[63]=true,[64]=true,[65]=true,[92]=true,[93]=true,[94]=true,
      [95]=true,[96]=true,[97]=true,[124]=true,[125]=true,[126]=true,[127]=true}
    local rv={}
    for k=1,10 do
      local base=(k-1)*13
      local v=0
      for b=0,12 do
        local p=base+b
        if p<128 and not CLEAR[p] then
          local byte=key32:byte(math.floor(p/8)+1)
          if B.band(B.rshift(byte,p%8),1)==1 then v=v+2^b end
        end
      end
      rv[k]=v
    end
    local h={0,0,0,0,0,0,0,0,0,0}
    local n=#msg
    local i=1
    while i<=n do
      local L=(n-i+1)>=16 and 16 or (n-i+1)
      if L==16 then
        local function g4(o) if o<16 then return msg:byte(i+o) or 0 else return 0 end end
        for k=1,10 do
          local base=(k-1)*13
          local bi=math.floor(base/8)+1
          local w=g4(bi-1)+g4(bi)*256+g4(bi+1)*65536+g4(bi+2)*16777216
          h[k]=h[k]+B.band(B.rshift(w,base%8),0x1fff)
        end
        h[10]=h[10]+2048
      else
        for k=1,10 do
          local base=(k-1)*13
          local v=0
          for b=0,12 do
            local p=base+b
            if p<8*L then
              local byte=msg:byte(i+math.floor(p/8))
              if B.band(B.rshift(byte,p%8),1)==1 then v=v+2^b end
            elseif p==8*L then
              v=v+2^b
            end
          end
          h[k]=h[k]+v
        end
      end
      local d={0,0,0,0,0,0,0,0,0,0}
      for a=1,10 do
        local ha=h[a]
        if ha~=0 then
          for j=1,10 do
            local k=a+j-1
            if k<=10 then d[k]=d[k]+ha*rv[j] else d[k-10]=d[k-10]+ha*rv[j]*5 end
          end
        end
      end
      local c=0
      for k=1,10 do
        local v=d[k]+c
        c=math.floor(v/8192)
        h[k]=v-c*8192
      end
      h[1]=h[1]+c*5
      c=math.floor(h[1]/8192)
      h[1]=h[1]-c*8192
      h[2]=h[2]+c
      i=i+16
    end
    local c=0
    for k=1,10 do
      local v=h[k]+c
      c=math.floor(v/8192)
      h[k]=v-c*8192
    end
    while c~=0 do
      h[1]=h[1]+c*5
      local c2=math.floor(h[1]/8192)
      h[1]=h[1]-c2*8192
      c=c2
      for k=2,10 do
        local v=h[k]+c
        c=math.floor(v/8192)
        h[k]=v-c*8192
      end
    end
    local g={}
    g[1]=h[1]+5
    local cg=math.floor(g[1]/8192)
    g[1]=g[1]-cg*8192
    for k=2,10 do
      g[k]=h[k]+cg
      cg=math.floor(g[k]/8192)
      g[k]=g[k]-cg*8192
    end
    local u
    if cg~=0 then u=g else u=h end
    local out={}
    for j=0,15 do
      local pos=j*8
      local l1=math.floor(pos/13)+1
      local o1=pos%13
      local v1=u[l1] or 0
      local v2=u[l1+1] or 0
      out[j+1]=math.floor((v1+v2*8192)/2^o1)%256
    end
    local carry=0
    for j=1,16 do
      local sv=out[j]+key32:byte(16+j)+carry
      out[j]=sv%256
      carry=math.floor(sv/256)
    end
    local o={}
    for j=1,16 do o[j]=string.char(out[j]) end
    return table.concat(o)
  end
  _pm_open=function(blob,khex,aad)
    local raw=b64d(tostring(blob))
    if #raw<45 then error("short payload") end
    local nonce=raw:sub(1,12)
    local tag=raw:sub(#raw-15)
    local ct=raw:sub(13,#raw-16)
    local kc={}
    for i=1,32 do kc[i]=string.char(tonumber(tostring(khex):sub(i*2-1,i*2),16) or 0) end
    local key=table.concat(kc)
    local kw,nw={},{}
    for i=1,8 do kw[i]=le32(key,i*4-3) end
    for i=1,3 do nw[i]=le32(nonce,i*4-3) end
    local function pad16(x)
      local r=#x%16
      if r==0 then return x end
      return x..string.rep("\0",16-r)
    end
    local function lenb(n)
      local a=n%4294967296
      return string.char(a%256,math.floor(a/256)%256,math.floor(a/65536)%256,math.floor(a/16777216)%256).."\0\0\0\0"
    end
    local aads=tostring(aad)
    local data=pad16(aads)..pad16(ct)..lenb(#aads)..lenb(#ct)
    local mac=poly(blk(kw,0,nw):sub(1,32),data)
    local diff=0
    for i=1,16 do diff=diff+B.bxor(mac:byte(i),tag:byte(i)) end
    if diff~=0 then error("tag mismatch") end
    local out={}
    local ctr=1
    for i=1,#ct,64 do
      local ks=blk(kw,ctr,nw)
      ctr=ctr+1
      local chunk=ct:sub(i,i+63)
      for j=1,#chunk do
        out[#out+1]=string.char(B.bxor(chunk:byte(j),ks:byte(j)))
      end
    end
    return table.concat(out)
  end
  _pm_kdf=function(tok,hw)
    local mat="pmkdf|"..tostring(tok).."|"..tostring(hw)
    local nb="pm-nonce|"..tostring(hw)
    local key={}
    for i=0,31 do key[i+1]=mat:byte((i%(#mat))+1) end
    local nby={}
    for i=0,11 do nby[i+1]=nb:byte((i%(#nb))+1) end
    local kw={}
    for i=0,7 do kw[i+1]=key[i*4+1]+key[i*4+2]*256+key[i*4+3]*65536+key[i*4+4]*16777216 end
    local nw={}
    for i=0,2 do nw[i+1]=nby[i*4+1]+nby[i*4+2]*256+nby[i*4+3]*65536+nby[i*4+4]*16777216 end
    local b=blk(kw,0,nw)
    local h={}
    for i=1,32 do h[i]=string.format("%02x",b:byte(i)) end
    return table.concat(h)
  end
end

local _pm_hwu=(_pm_hw1~="" and _pm_hw1 or _pm_hw2)
local _pm_k=_pm_kdf(_pm_tok,_pm_hwu)
local _pm_aad=_pm_hwu.."|".._pm_tok
local _pm_blob
for _pm_i=1,3 do
  local _pm_ok,_pm_body=pcall(function()
    local _pm_rr=_pm_sr({Url=_bsdata0[1].."/api/payload",Method="GET",Headers={["Authorization"]="Bearer ".._pm_tok}})
    return type(_pm_rr)=="table" and (_pm_rr.Body or _pm_rr.body or _pm_rr.ResponseBody) or _pm_rr
  end)
  if _pm_ok and type(_pm_body)=="string" and #_pm_body>80 and _pm_body:sub(1,1)=="{" then
    local _pm_ok2,_pm_j=pcall(function() return _pm_hsvc:JSONDecode(_pm_body) end)
    if _pm_ok2 and type(_pm_j)=="table" and _pm_j.ok and type(_pm_j.ct)=="string" then
      _pm_blob=_pm_j.ct
      break
    end
    if _pm_ok2 and type(_pm_j)=="table" and _pm_j.ok==false and type(_pm_j.ec)=="string" then
      _pm_kick(_pm_j.ec)
      return error("Plotmor",0)
    end
  end
  pcall(function() task.wait(0.4) end)
end
if not _pm_blob then
  _pm_kick("Error PM-01")
  return error("Plotmor",0)
end
local _pm_ok3,_pm_src=pcall(_pm_open,_pm_blob,_pm_k,_pm_aad)
if not (_pm_ok3 and type(_pm_src)=="string" and #_pm_src>100) then
  pcall(function()
    _pm_sr({Url=_bsdata0[1].."/api/tamper?sid=ba78453efd0bb4&hwid="..(_pm_hw1~="" and _pm_hw1 or _pm_hw2).."&reason=payload_tamper",Method="GET"})
  end)
  _pm_kick("Error PM-08")
  return error("Plotmor",0)
end
local _pm_lf=loadstring or load
if type(_pm_lf)~="function" then
  _pm_kick("Error PM-09")
  return error("Plotmor",0)
end
__PMPLOADED=true rawset(_G,"__PMPLOADED",true) local _pm_ok4,_pm_fn=pcall(_pm_lf,_pm_src)
if _pm_ok4 and type(_pm_fn)=="function" then
  pcall(function() _pm_gkill() end)
  return _pm_fn()
end
_pm_kick("Error PM-08")
