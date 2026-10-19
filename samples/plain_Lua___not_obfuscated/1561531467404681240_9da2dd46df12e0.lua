-- Kingmor secure loader v6-pack
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local hwid=""
pcall(function() hwid=tostring(game:GetService("RbxAnalyticsService"):GetClientId()) end)
local uk = ""
local function httpget(url)
  local list = {}
  local function add(f) if type(f)=="function" then list[#list+1]=f end end
  if type(request)=="function" then add(function(u) local r=request({Url=u,Method="GET",Headers={["User-Agent"]="Kingmor/5"}}) if type(r)=="table" then return r.Body or r.body or r.Data or r.data end end) end
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
pcall(function() httpget("https://k1ngmor.up.railway.app/api/hwid/check?scriptId=9da2dd46df12e0&hwid=" .. hwid) end)
local key={215,161,97,248,199,144,252,226,114,84,126,155,252,191,167,99,239,141,27,133,175,245,86,121,195,202,38,22,109,184,236,49}
local seed=2066192636
local parts=6
local partBase="https://k1ngmor.up.railway.app/api/loader/9da2dd46df12e0.lua?pack=1&dtok=eyJzaWQiOiI5ZGEyZGQ0NmRmMTJlMCIsImtoIjoiZDdhMTYxZjhjNzkwZmNlMjcyNTQ3ZTliZmNiZmE3NjNlZjhkMWI4NWFmZjU1Njc5YzNjYTI2MTY2ZGI4ZWMzMSIsInNlZWQiOjIwNjYxOTI2MzYsInBzeiI6MTUzNjAwLCJleHAiOjE3OTIzNjg2NjY2MzZ9.j4BMs0MryBn1hL680YSET5RxfxSgJdiZk0gy_qd8ghU&seed=2066192636&kh=d7a161f8c790fce272547e9bfcbfa763ef8d1b85aff55679c3ca26166db8ec31&psz=153600&part="
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
  if type(loader)~="function" then if lp then lp:Kick("[Kingmor] No loadstring") end return end
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
  src=nil
  local fn,err=loader(chunk)
  -- try to drop the big string reference before call
  chunk=string.rep("\0",8)
  chunk=nil
  if not fn then
    warn("[Kingmor] compile:",err)
    if lp then lp:Kick("[Kingmor] Script compile error") end
    return
  end
  local ok,re=pcall(fn)
  fn=nil
  if not ok then warn("[Kingmor] runtime:",tostring(re)) end
  pcall(function() collectgarbage("collect") end)
end
local function nap(sec) pcall(function() if task and task.wait then task.wait(sec) else wait(sec) end end) end
local pieces={}
for i=1,parts do
  local url=partBase..tostring(i)
  local body,lastErr=nil,nil
  for attempt=1,8 do
    local ok,res=pcall(httpget,url)
    if ok and type(res)=="string" then
      if #res==0 then
        -- past end of payload (safe)
        body=""
        break
      elseif #res>8 then
        if res:sub(1,10)=="-- Kingmor" then lastErr="got bootstrap"
        elseif #res<500 and res:find("Kick",1,true) then local fn=(loadstring or load)(res) if fn then pcall(fn) end return
        else body=res break end
      else lastErr="short:"..tostring(#res) end
    else lastErr=tostring(res) end
    nap(0.35*attempt)
  end
  if body==nil then
    warn("[Kingmor] part fail",i,lastErr)
    if lp then lp:Kick("[Kingmor] Download failed part "..tostring(i)) end
    return
  end
  if body=="" then
    pieces[i]=""
  else
    local okd,dec=pcall(b64dec,body)
    if not okd or type(dec)~="string" or #dec==0 then
      if lp then lp:Kick("[Kingmor] Decode failed part "..tostring(i)) end
      return
    end
    pieces[i]=dec
  end
end
local blob=table.concat(pieces)
for i=1,#pieces do pieces[i]=nil end
pieces=nil
local plain=decrypt(blob)
blob=nil
run(plain)
plain=nil
pcall(function() collectgarbage("collect") end)
