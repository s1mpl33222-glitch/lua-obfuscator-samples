-- Kingmor secure loader v5-inline
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
    return httpget("https://kingmor.up.railway.app/api/hwid/check?scriptId=1153e3832d1324&key=" .. uk .. "&hwid=" .. hwid)
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
local key={56,117,233,197,135,204,17,24,148,184,160,151,9,20,30,159,13,120,146,248,15,29,203,98,35,222,59,77,133,166,141,233}
local seed=3341121085
local _p={
  [1]=[=[MPPs49P4FSr4lKXsMEPBsLQDy1gJWsb9U1wY1jSX8iAVR8qEZsvuG2IVa3g4mJ0zrIiW2dvr7g==]=]
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
local enc=b64dec(table.concat(_p))
for i=1,#_p do _p[i]=nil end
_p=nil
local plain=decrypt(enc)
enc=nil
run(plain)
plain=nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
pcall(function() collectgarbage("collect") end)
