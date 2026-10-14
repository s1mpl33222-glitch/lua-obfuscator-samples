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
    return httpget("https://kingmor.up.railway.app/api/hwid/check?scriptId=d508c43546834c&key=" .. uk .. "&hwid=" .. hwid)
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
local key={30,140,116,35,91,131,226,203,55,182,138,32,186,32,193,43,178,80,22,110,32,84,47,151,233,147,113,226,223,28,32,91}
local seed=2608685085
local _p={
  [1]=[=[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]=],
  [2]=[=[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]=],
  [3]=[=[hjdfT6ZAbFcMCkx4eDiYU6M2siv7V05r16FfsE9ymXrS35m2uDN6/xTByZv3BZHcdVo7WkO13JM/yvXRMuGbn7u84QWQmNDeadKLvp7gsReNFM3SIj+GSHne4obn7TflQ8FZDeyV0mqAZNgL+SAA7dbrmd1er+nhRjgGCA9oHo6DIhpJsF0+FgAHXT4nfYIx5niYK4sPPUL3l1Cce3y2CPr86Z+YBXXTIM/g9+gr7vhXQDp5M6fW6Bbqw94e1ZWwyZTCdbm45tFF5oWX48udWqIy88cwM7hjRd7FrPvxBvpd6WA+pczXYrpi3B3VHVzIqu+MwGGx+vMKGywISmEBmI8tXAavED4aCQBdPid9gjHmeJgrshFOT9aCQ8B8XKFs0+73npE5KtlMldu/4TvY0ml2Witvn8vVT8DD3B/2g8uPqt4s4MCjh13YnqujuIpV6j3K+WYhtndoi8yl0tU0g3r8aR+YhfVToE/mad8gf8Le/Y7/So/zkmUSBghKbQvLhCtOBqYOI1NZUhNqPX2YTrQ2mG61E2Qbj9IGuFJXlHPP8s63uDsg9wnkxJLqLtjqfkVFbXX9jpsK3tXNA+LNhJr5hxf50qPTWdKTwO+4zBuqN9vqN1eIVRKi3rvT3AjdXtVCPeOw+3SIb9g8+wlU5oy42Ks7p9boFmpDXh5VFbDJFEJ1uThmUUVmBRdydoVXzHiYK/seCBvbi1aNAmKDApe5mIC1DmDTGNjT6K8sxN5oElgrO9eOmwPdxckGpIKAxqHIVP2Q4MZd29WsobHmG+Z4mKt7HogbQZ3SyMXvTd9C4VRGpZLxSIMfySX8LF7S6P/Q7mmFh5dfGwZNBGBny8pkGkOuBAkHEVIROSpxihupKIU24kdOT8eXSOIKJM0LyPbfh6tqI4cU2dnA6jbIsWN2HCIz3qQ=]=]
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
