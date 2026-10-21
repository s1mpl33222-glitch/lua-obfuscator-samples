-- Plotmor secure loader v5-pack
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local hwid=""
pcall(function() hwid=tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
local uk = nil
-- resolve script_key from executor env
pcall(function()
  if type(getgenv) == "function" then
    local g = getgenv()
    if type(g) == "table" and type(g.script_key) == "string" then uk = g.script_key end
    if (not uk or #tostring(uk) < 4) and type(g) == "table" and type(g.ScriptKey) == "string" then uk = g.ScriptKey end
  end
end)
if type(uk) ~= "string" or #uk < 4 then
  pcall(function()
    if type(_G) == "table" then
      if type(_G.script_key) == "string" then uk = _G.script_key end
      if (not uk or #tostring(uk) < 4) and type(_G.ScriptKey) == "string" then uk = _G.ScriptKey end
    end
  end)
end
if type(uk) ~= "string" or #uk < 4 then
  pcall(function()
    if type(shared) == "table" and type(shared.script_key) == "string" then uk = shared.script_key end
  end)
end
if type(uk) ~= "string" or #uk < 4 then
  pcall(function()
    local ok, v = pcall(function() return script_key end)
    if ok and type(v) == "string" then uk = v end
  end)
end
if type(uk) ~= "string" or #uk < 4 then
  if lp then lp:Kick("[Plotmor] Set script_key before running the loader") end
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))
local function httpget(url)
  local list = {}
  local function add(f) if type(f)=="function" then list[#list+1]=f end end
  if type(request)=="function" then add(function(u) local r=request({Url=u,Method="GET",Headers={["User-Agent"]="Plotmor/5"}}) if type(r)=="table" then return r.Body or r.body or r.Data or r.data end end) end
  if type(http_request)=="function" then add(function(u) local r=http_request({Url=u,Method="GET"}) if type(r)=="table" then return r.Body or r.body end end) end
  if type(syn)=="table" and type(syn.request)=="function" then add(function(u) local r=syn.request({Url=u,Method="GET"}) if type(r)=="table" then return r.Body or r.body end end) end
  if type(http)=="table" and type(http.request)=="function" then add(function(u) local r=http.request({Url=u,Method="GET"}) if type(r)=="table" then return r.Body or r.body end end) end
  if type(fluxus)=="table" and type(fluxus.request)=="function" then add(function(u) local r=fluxus.request({Url=u,Method="GET"}) if type(r)=="table" then return r.Body or r.body end end) end
  add(function(u) if type(game.HttpGet)=="function" then return game:HttpGet(u) end end)
  add(function(u) return HttpService:GetAsync(u,true) end)
  local last="no http"
  for i=1,#list do
    local ok,res=pcall(list[i],url)
    if ok and type(res)=="string" and #res>0 then return res end
    last=tostring(res)
  end
  error(last)
end
do
  local ok,body = pcall(function()
    return httpget("https://plotmor.up.railway.app/api/hwid/check?scriptId=8c96014764511c&key=" .. uk .. "&hwid=" .. hwid)
  end)
  if not ok or type(body) ~= "string" or body == "" then
    if lp then lp:Kick("[Plotmor] HWID Check Failed") end
    return
  end
  local data = nil
  pcall(function() data = HttpService:JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    if lp then lp:Kick("[Plotmor] " .. tostring(reason)) end
    return
  end
end
local key={84,4,109,176,92,145,87,65,44,151,51,162,246,240,85,203,25,101,196,19,57,233,67,59,183,110,176,219,15,250,84,224}
local seed=2192300635
local parts=11
local partBase="https://plotmor.up.railway.app/api/loader/8c96014764511c.lua?pack=1&seed=2192300635&kh=54046db05c9157412c9733a2f6f055cb1965c41339e9433bb76eb0db0ffa54e0&psz=153600&part="
local function bx(a,c)
  a=a%256;c=c%256
  if bit32 and bit32.bxor then return bit32.bxor(a,c) end
  local r,p=0,1
  for _=1,8 do local x,y=a%2,c%2 if x~=y then r=r+p end a,c,p=(a-x)/2,(c-y)/2,p*2 end
  return r
end
local function b64dec(data)
  local A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local L={} for i=1,#A do L[A:sub(i,i)]=i-1 end
  data=tostring(data or ""):gsub("%s+",""):gsub("[^A-Za-z0-9%+/=]","")
  local out,val,bits={},0,0
  for i=1,#data do
    local ch=data:sub(i,i)
    if ch=="=" then break end
    local f=L[ch]
    if f then
      val=val*64+f; bits=bits+6
      if bits>=8 then bits=bits-8; local d=2^bits; out[#out+1]=string.char(math.floor(val/d)%256); val=val%d end
    end
  end
  return table.concat(out)
end
local function decrypt(enc)
  local outChunks,buf,bi={}, {},0
  local s=seed
  for i=1,#enc do
    s=(1664525*s+1013904223)%4294967296
    local k=key[((i-1)%32)+1]
    local drift=bx(s%256,((i-1)*131)%256)
    bi=bi+1; buf[bi]=string.char(bx(bx(string.byte(enc,i),k),drift))
    if bi>=8192 then outChunks[#outChunks+1]=table.concat(buf); buf={}; bi=0 end
  end
  if bi>0 then outChunks[#outChunks+1]=table.concat(buf) end
  return table.concat(outChunks)
end
local function run(src)
  -- Hardened execute: avoid lingering plain source in locals/globals after compile
  local loader=loadstring or load
  if type(loader)~="function" then if lp then lp:Kick("[Plotmor] No loadstring") end return end

  -- Soft anti-tamper (does not kick normal executors)
  pcall(function()
    local bad=0
    if type(getscriptbytecode)=="function" then bad=bad+1 end
    if type(dumpstring)=="function" then bad=bad+1 end
    if type(saveinstance)=="function" and type(getnilinstances)=="function" and type(getgc)=="function" then
      -- common dump stack present; still allow run (many legit tools ship these)
    end
  end)

  local chunk=src
  src=nil   -- drop plaintext ref ASAP

  local fn,err=(function(f,s)
    if type(f)~="function" then return nil,"no loadstring" end
    local es={}
    pcall(function() if type(getgenv)=="function" then es[#es+1]=getgenv() end end)
    if type(_G)=="table" and _G~=es[1] then es[#es+1]=_G end

    -- BLACKLIST during compile: silence dump vectors
    local n={"writefile","appendfile","setclipboard","toclipboard",
             "request","http_request","rconsoleprint","print","warn"}
    local z=function() end
    local sv={}
    for a=1,#es do
      sv[a]={}
      for b=1,#n do
        pcall(function()
          sv[a][b]={es[a][n[b]]}
          es[a][n[b]]=z          -- replace with no-op
        end)
      end
    end

    local ok,fn,er=pcall(f,s)   -- compile while dumps are muted

    -- restore originals
    for a=1,#es do
      for b=1,#n do
        pcall(function()
          local o=sv[a][b]
          if o then es[a][n[b]]=o[1] end
        end)
      end
    end
    if not ok then return nil,fn end
    return fn,er
  end)(loader,chunk)

  -- zero the source string so it can't be recovered from memory easily
  chunk=string.rep("\0",8)
  chunk=nil

  if not fn then
    warn("[Plotmor] compile:",err)
    if lp then lp:Kick("[Plotmor] Script compile error") end
    return
  end

  local ok,re=pcall(fn)
  fn=nil
  if not ok then warn("[Plotmor] runtime:",tostring(re)) end
  pcall(function() collectgarbage("collect") end)
end

-- Plotmor shield: anti-tamper, anti-getraw and anti-logger preflight
local function shield()
  local bad=false
  pcall(function()
    local core={tostring,type,pcall,string.char,string.byte,table.concat,math.floor}
    for i=1,#core do
      if type(core[i])~="function" then bad=true end
    end
  end)
  -- anti-getraw: metatable reflection must still behave
  pcall(function()
    if type(getrawmetatable)~="function" then return end
    local m=getrawmetatable(game)
    if type(m)~="table" then bad=true return end
    local idx=rawget(m,"__index")
    if type(idx)~="table" and type(idx)~="function" then bad=true end
  end)
  if bad then return false end
  -- sandbox / http-logger probe: freeze the executor if its error channel is instrumented
  local _,smsg=pcall(function(...) string.byte("a",function(...) return; end,9999,38) end)
  smsg=tostring(smsg or "")
  if smsg:find("httplog",1,true) or smsg:find("sandbox",1,true) then while true do end end
  return true
end
local function nap(sec) pcall(function() if task and task.wait then task.wait(sec) else wait(sec) end end) end
local pieces={}
for i=1,parts do
  local url=partBase..tostring(i) .. "&key=" .. uk
  local body,lastErr=nil,nil
  for attempt=1,8 do
    local ok,res=pcall(httpget,url)
    if ok and type(res)=="string" then
      if #res==0 then
        -- past end of payload (safe)
        body=""
        break
      elseif #res>8 then
        if res:sub(1,10)=="-- Plotmor" then lastErr="got bootstrap"
        elseif #res<500 and res:find("Kick",1,true) then local fn=(loadstring or load)(res) if fn then pcall(fn) end return
        else body=res break end
      else lastErr="short:"..tostring(#res) end
    else lastErr=tostring(res) end
    nap(0.35*attempt)
  end
  if body==nil then
    warn("[Plotmor] part fail",i,lastErr)
    if lp then lp:Kick("[Plotmor] Download failed part "..tostring(i)) end
    return
  end
  if body=="" then
    pieces[i]=""
  else
    local okd,dec=pcall(b64dec,body)
    if not okd or type(dec)~="string" or #dec==0 then
      if lp then lp:Kick("[Plotmor] Decode failed part "..tostring(i)) end
      return
    end
    pieces[i]=dec
  end
end
if shield() then run(decrypt(table.concat(pieces))) end
