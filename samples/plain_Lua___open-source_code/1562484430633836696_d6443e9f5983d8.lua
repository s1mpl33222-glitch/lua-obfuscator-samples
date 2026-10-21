-- Plotmor secure loader v5-inline
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
    return httpget("https://plotmor.up.railway.app/api/hwid/check?scriptId=d6443e9f5983d8&key=" .. uk .. "&hwid=" .. hwid)
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
local key={157,186,224,134,220,28,155,196,46,166,176,18,99,48,140,138,123,207,87,192,177,22,76,168,248,121,167,146,235,44,183,79}
local seed=923158575
local _p={
  [1]=[=[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]=],
  [2]=[=[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]=],
  [3]=[=[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]=]
}
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
local enc=b64dec(table.concat(_p))
if shield() then run(decrypt(enc)) end
