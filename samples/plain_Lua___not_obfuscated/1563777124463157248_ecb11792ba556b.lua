-- Kingmor secure loader v6-pack
local HttpService=game:GetService("HttpService")
local Players=game:GetService("Players")
local lp=Players.LocalPlayer
local hwid=""
pcall(function()
  local ok,id=pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
  if ok and id~=nil then hwid=tostring(id) end
end)
if hwid=="" then pcall(function()
  local ok,id=pcall(function() return game:GetService("RbxAnalyticsService"):GetSessionId() end)
  if ok and id~=nil then hwid=tostring(id) end
end) end
if hwid=="" then pcall(function()
  if type(gethwid)=="function" then hwid=tostring(gethwid()) end
end) end
if hwid=="" then pcall(function()
  if type(get_hwid)=="function" then hwid=tostring(get_hwid()) end
end) end
if hwid=="" then pcall(function()
  if type(game.GetService)=="function" then
    local u=game:GetService("UserInputService")
    if u and u.TouchEnabled~=nil then hwid="t"..tostring(u.TouchEnabled) end
  end
end) end
if hwid=="" then hwid="unknown-"..tostring(math.random(100000,999999)) end
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
  if lp then lp:Kick("[Kingmor] Set script_key before running the loader") end
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))
local function httpget(url)
  local list = {}
  local function add(f) if type(f)=="function" then list[#list+1]=f end end
  -- Order: native game APIs first (Arceus X / mobile often only have these), then executor request APIs
  add(function(u)
    if type(game)=="table" and type(game.HttpGet)=="function" then
      return game:HttpGet(u, true)
    end
  end)
  add(function(u)
    if type(game)=="table" and type(game.HttpGetAsync)=="function" then
      return game:HttpGetAsync(u)
    end
  end)
  add(function(u)
    if type(HttpService)=="table" and type(HttpService.GetAsync)=="function" then
      return HttpService:GetAsync(u, true)
    end
  end)
  if type(request)=="function" then
    add(function(u)
      local r=request({Url=u,Method="GET",Headers={["User-Agent"]="Kingmor/6"}})
      if type(r)=="table" then return r.Body or r.body or r.Data or r.data end
      if type(r)=="string" then return r end
    end)
  end
  if type(http_request)=="function" then
    add(function(u)
      local r=http_request({Url=u,Method="GET"})
      if type(r)=="table" then return r.Body or r.body end
      if type(r)=="string" then return r end
    end)
  end
  if type(syn)=="table" and type(syn.request)=="function" then
    add(function(u)
      local r=syn.request({Url=u,Method="GET"})
      if type(r)=="table" then return r.Body or r.body end
    end)
  end
  if type(http)=="table" and type(http.request)=="function" then
    add(function(u)
      local r=http.request({Url=u,Method="GET"})
      if type(r)=="table" then return r.Body or r.body end
    end)
  end
  if type(fluxus)=="table" and type(fluxus.request)=="function" then
    add(function(u)
      local r=fluxus.request({Url=u,Method="GET"})
      if type(r)=="table" then return r.Body or r.body end
    end)
  end
  -- Arceus / some Android builds expose httpget / httprequest globals
  if type(httpget)=="function" then add(function(u) return httpget(u) end) end
  if type(httprequest)=="function" then
    add(function(u)
      local r=httprequest({Url=u,Method="GET"})
      if type(r)=="table" then return r.Body or r.body end
      if type(r)=="string" then return r end
    end)
  end
  local last="no http"
  for i=1,#list do
    local ok,res=pcall(list[i],url)
    if ok and type(res)=="string" and #res>0 then return res end
    if not ok then last=tostring(res) else last="empty" end
  end
  error(last)
end
do
  local ok,body = pcall(function()
    return httpget("https://kingmor.up.railway.app/api/hwid/check?scriptId=ecb11792ba556b&key=" .. uk .. "&hwid=" .. hwid)
  end)
  if not ok or type(body) ~= "string" or body == "" then
    if lp then lp:Kick("[Kingmor] HWID Check Failed") end
    return
  end
  local data = nil
  pcall(function() data = HttpService:JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    if lp then lp:Kick("[Kingmor] " .. tostring(reason)) end
    return
  end
end
local key={239,227,114,204,141,101,64,169,204,164,26,189,7,147,128,206,159,105,168,59,113,154,222,24,127,137,6,53,146,2,222,122}
local seed=148489978
local parts=21
local partBase="https://kingmor.up.railway.app/api/loader/ecb11792ba556b.lua?pack=1&dtok=eyJzaWQiOiJlY2IxMTc5MmJhNTU2YiIsImtoIjoiZWZlMzcyY2M4ZDY1NDBhOWNjYTQxYWJkMDc5MzgwY2U5ZjY5YTgzYjcxOWFkZTE4N2Y4OTA2MzU5MjAyZGU3YSIsInNlZWQiOjE0ODQ4OTk3OCwicHN6IjoxNTM2MDAsImV4cCI6MTc5MjkwNDA3NDU1MX0.4Rg7ze7a10WlhRpQo0-VLL9yQbJIApwT_0terBHwW6M&seed=148489978&kh=efe372cc8d6540a9cca41abd079380ce9f69a83b719ade187f8906359202de7a&psz=153600&part="
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
  if type(src)~="string" or #src<1 then
    if lp then pcall(function() lp:Kick("[Kingmor] Empty payload") end) end
    return
  end

  local loader=loadstring or load
  if type(loader)~="function" then
    pcall(function()
      if type(getgenv)=="function" then
        local g=getgenv()
        if type(g)=="table" then loader=g.loadstring or g.load end
      end
    end)
  end
  if type(loader)~="function" then
    pcall(function() if type(getrenv)=="function" then local r=getrenv() if type(r)=="table" then loader=r.loadstring or r.load end end end)
  end
  if type(loader)~="function" then
    if lp then pcall(function() lp:Kick("[Kingmor] Executor missing loadstring") end) end
    return
  end

  -- Light dump probe (kick only if marker captured)
  pcall(function()
    local marker="KM_P_"..tostring(math.random(1e5,1e6-1))
    local g=nil
    pcall(function() if type(getgenv)=="function" then g=getgenv() end end)
    if type(g)=="table" then
      g._LAST_DUMP=nil g._KM_DUMP=nil
      pcall(loader,"--"..marker..string.rep("x",200))
      local d=g._LAST_DUMP or g._KM_DUMP
      if type(d)=="string" and string.find(d,marker,1,true) then
        if lp then pcall(function() lp:Kick("[Kingmor] Dump tool detected") end) end
        return
      end
      g._LAST_DUMP=nil g._KM_DUMP=nil
    end
  end)

  -- Block dump writes (does not affect loadstring)
  pcall(function()
    local function block(n,d)
      if type(d)~="string" then return false end
      local ln=string.lower(tostring(n or ""))
      if string.find(ln,"dump",1,true) or string.find(ln,"printed",1,true) then return true end
      if #d>=1000 then return true end
      return false
    end
    local targets={}
    pcall(function() if type(getgenv)=="function" then targets[#targets+1]=getgenv() end end)
    if type(_G)=="table" then targets[#targets+1]=_G end
    for _,env in ipairs(targets) do
      if type(env)=="table" then
        pcall(function()
          local ow=env.writefile
          env.writefile=function(n,d) if block(n,d) then return end if type(ow)=="function" then return ow(n,d) end end
        end)
        pcall(function()
          env.setclipboard=function(d) if type(d)=="string" and #d>=500 then return end end
        end)
      end
    end
  end)

  -- Compile: plain loadstring FIRST (most reliable)
  local fn,err
  local ok,f1,e1=pcall(loader,src)
  if ok and type(f1)=="function" then
    fn=f1
  else
    local f2,e2=loader(src)
    if type(f2)=="function" then fn=f2 else err=e2 or e1 or f1 end
  end
  src=nil

  if type(fn)~="function" then
    warn("[Kingmor] compile:",tostring(err))
    if lp then pcall(function() lp:Kick("[Kingmor] Script compile error") end) end
    return
  end

  -- Official Kingmor session for auth gate inside payload
  pcall(function()
    local sess={ok=true,sid="ecb11792ba556b",scriptId="ecb11792ba556b",t=(type(os)=="table" and os.clock and os.clock()) or 0}
    if type(getgenv)=="function" then
      local g=getgenv()
      if type(g)=="table" then g._KM_AUTH=sess end
    end
    if type(_G)=="table" then _G._KM_AUTH=sess end
  end)

  -- Run the script — this is the critical path
  local ok2,re=pcall(fn)
  fn=nil
  if not ok2 then
    warn("[Kingmor] runtime:",tostring(re))
  end
  pcall(function()
    if type(getgenv)=="function" then
      local g=getgenv()
      if type(g)=="table" then g._LAST_DUMP=nil g._KM_DUMP=nil end
    end
  end)
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
pcall(function() if collectgarbage then collectgarbage("collect") end end)
plain=nil
pcall(function() collectgarbage("collect") end)
