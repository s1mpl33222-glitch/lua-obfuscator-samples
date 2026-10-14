-- Kingmor secure loader v5-inline
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
  if lp then lp:Kick("[Kingmor] Set script_key before running the loader") end
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))
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
do
  local ok,body = pcall(function()
    return httpget("https://kingmor.up.railway.app/api/hwid/check?scriptId=c4223c5ca70b0d&key=" .. uk .. "&hwid=" .. hwid)
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
local key={197,223,92,163,66,200,215,40,79,81,19,180,16,155,230,207,93,70,189,52,73,52,48,93,60,209,187,211,102,181,98,41}
local seed=4277027726
local _p={
  [1]=[=[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]=],
  [2]=[=[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]=],
  [3]=[=[/s9Bxs7Kv0vOqXFNNUTmowLZm92APvxrqnI6yiMKokUawFqqC6QSC2+IhyGRiz2PR/GoZv6P/Gvqsnr2c1BDRfjQvFnyFswjOxQndqDK2rW+jnV8P4YYQaryuj91UBtTq9T437OUnbvrAO+oIJ+ftjjK+6GdQ1ZrarJ6dvNQWVP8lXvUvMuZe/fSN2oxUcHyJMOm/KUKmCyiN2jtfFzHFWjQeptW3xF+OZe8PMneU7983/Bh8cOZO/eva6omUENU7dueH7wf0XxrFzNzyZ6Tv77IX205h3wu5LazN3x6]=]
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
  local loader=loadstring or load
  if type(loader)~="function" then if lp then lp:Kick("[Kingmor] No loadstring") end return end
  local fn,err=loader(src)
  if not fn then warn("[Kingmor] compile:",err) if lp then lp:Kick("[Kingmor] Script compile error") end return end
  local ok,re=pcall(fn)
  if not ok then warn("[Kingmor] runtime:",re) end
end
local enc=b64dec(table.concat(_p))
run(decrypt(enc))
