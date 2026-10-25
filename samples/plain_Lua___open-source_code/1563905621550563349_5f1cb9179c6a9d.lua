-- JwwwVylCa0thBCBhBDhaaQ0
local Players = game:GetService("Players")
local _kmLp = Players and Players.LocalPlayer
local function _d77eb3(msg)
  pcall(function()
    local lp = _kmLp or (game:GetService("Players") and game:GetService("Players").LocalPlayer)
    if lp then pcall(function() lp:Kick(("[Kin".."gmor] ") .. tostring(msg)) end) end
  end)
  warn(("[Kin".."gmor] ") .. tostring(msg))
  return false
end
local hwid = ""
do
  local svc = game:GetService("RbxAnalyticsService")
  pcall(function() local v = svc:GetClientId() if v ~= nil then hwid = tostring(v) end end)
  if hwid == "" then pcall(function() local v = svc:GetSessionId() if v ~= nil then hwid = tostring(v) end end) end
  if hwid == "" then pcall(function() if type(gethwid) == "function" then hwid = tostring(gethwid()) end end) end
  if hwid == "" then pcall(function() if type(get_hwid) == "function" then hwid = tostring(get_hwid()) end end) end
  if hwid == "" then pcall(function() local u = game:GetService("UserInputService") if u then hwid = "u" .. tostring(u.TouchEnabled) end end) end
  if hwid == "" then hwid = "unknown" end
end
local function nap(t)
  pcall(function()
    if type(task) == "table" and type(task.wait) == "function" then task.wait(t)
    elseif type(wait) == "function" then wait(t) end
  end)
end
local uk = ""
local _7e8ad7
do
  local list = {}
  local function add(f) if type(f) == "function" then list[#list+1] = f end end
  add(function(u)
    if type(game) == "table" and type(game.HttpGet) == "function" then return game:HttpGet(u, true) end
  end)
  add(function(u)
    if type(game) == "table" and type(game.HttpGetAsync) == "function" then return game:HttpGetAsync(u) end
  end)
  add(function(u)
    local ok, h = pcall(function() return game:GetService("HttpService") end)
    if ok and h and type(h.GetAsync) == "function" then return h:GetAsync(u, true) end
  end)
  if type(request) == "function" then
    add(function(u)
      local r = request({Url = u, Method = "GET", Headers = {["User-Agent"] = "Roblox/WinInet"}})
      if type(r) == "table" then return r.Body or r.body end
      if type(r) == "string" then return r end
    end)
  end
  if type(http_request) == "function" then
    add(function(u)
      local r = http_request({Url = u, Method = "GET"})
      if type(r) == "table" then return r.Body or r.body end
      if type(r) == "string" then return r end
    end)
  end
  if type(syn) == "table" and type(syn.request) == "function" then
    add(function(u)
      local r = syn.request({Url = u, Method = "GET"})
      if type(r) == "table" then return r.Body or r.body end
    end)
  end
  if type(http) == "table" and type(http.request) == "function" then
    add(function(u)
      local r = http.request({Url = u, Method = "GET"})
      if type(r) == "table" then return r.Body or r.body end
    end)
  end
  if type(httpget) == "function" then add(function(u) return httpget(u) end) end
  _7e8ad7 = function(url)
    local last = "no http transport"
    for i = 1, #list do
      local ok, res = pcall(list[i], url)
      if ok and type(res) == "string" and #res > 0 then return res end
      if ok then last = "empty response" else last = tostring(res) end
    end
    return nil, last
  end
end
do
  local bad = { "dumpstring", "getscriptbytecode", "saveinstance", "save_instance", "decompile", "dumpall" }
  local envs = {}
  pcall(function() if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then envs[#envs+1] = g end end end)
  if type(_G) == "table" then envs[#envs+1] = _G end
  for i = 1, #envs do
    for j = 1, #bad do
      if type(envs[i][bad[j]]) == "function" then
        envs[i][bad[j]] = function() _d77eb3("Dump source detected [" .. bad[j] .. "]") end
      end
    end
    local d = envs[i]._LAST_DUMP or envs[i]._KM_DUMP
    if type(d) == "string" and #d > 200 then
      _d77eb3("Dump source detected [captured]")
      return
    end
  end
end
local _99bbaa
do
  local envs = {}
  pcall(function() if type(getgenv) == "function" then envs[#envs+1] = getgenv() end end)
  pcall(function() if type(getfenv) == "function" then envs[#envs+1] = getfenv(0) end end)
  if type(_G) == "table" then envs[#envs+1] = _G end
  local n1, n2 = "load" .. "string", "lo" .. "ad"
  for i = 1, #envs do
    local e = envs[i]
    if type(e) == "table" then
      local f = e[n1] or e[n2]
      if type(f) == "function" then _99bbaa = f break end
    end
  end
end
local _697fa1={}
for i=0,255 do _697fa1[i]=string.char(i) end
local _909818,_00e6cf={},{}
do
  local ta="058e4fa21c261572c7c3ce06bd58c47fc2da5fac6af4e9831864bb7c8f11a85b611e7e666f90390cd18afef0b2bcb1600dca71b0799fe129425e948d02179149c9137603f83b2d04d99338c0a32bc1b8320e5c35982e01242aa6e8cfd3958b9ebeb40f6e8c5a65e4316ccc3ae350f9eb80c582a41909a167d85230cb419cbab3d423ad7a003e27f1d24cdb75a91f7b55b6f233cd3f201d10ae0af33d86d52289dcfb5de5ab6343409add076b28fd9b484d705414f5e24a81eaedf7e73769e6a0df08a7465725aa964588771684c81ab50b74447d85e0b94bf66d475999fc5187d712782c21621b2fbf73a5b7d692ee4edefaffaf68efec9d533c36d03456c697"
  local tb="e89e1f89a7fccfa35f9a75a53facf036f17cb44641fb31f7799319d42b1b684fc25d6355d7a10a5ec57ee1160735d06440c9bb062fda227a8ea982ab51b5b9659667d6a8aece08cd6e3ee67071e0fe8324668a695c8717f278eae7f538f97b23d8c6bcd39c0bb147c7a084050de49f3b8f2745b7dc26d2cb02157f3d8dcc97aa2aafe3ca2c85b2b6956d98dfbf3334818076c36b994a10c8bea6866ae592d99120049d32de590e774def13583714ed48526c1d033ab3128b25561828ba1ac40c9b8829e253612e502d1c21f8fd57b8724ead9449c0624bddf41ebd0f0030d5db09fa44ec01b0a4f66f3c39ee9043e954744cf38c5ac11142605beb73a2d1ff7d"
  for i=1,256 do
    _909818[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _00e6cf[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _cf4727={}
do
  local a="VzwxBKabYpMfnd4c1HqIG60oQ7Zlh5S9" .. "yUrTsA2-itOj3NJmkFLRv8_EugWDXCPe"
  for i=1,#a do _cf4727[string.byte(a,i)]=i-1 end
end
local function _5bf1a6(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_cf4727[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_697fa1[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _472249(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _10ee2c(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _ba5132(S)
  local sa,pa=1309540094,122
  local sb,pb=1373137855,1
  local MA,AA,LA=836671,473567075,10149233
  local MB,AB,LB=617897,840272483,13010426
  local KA={151,106,209,169,51,238,180,20,233,57,246,206,52,107,149,86,241,30,80,220,9,19,11,137,92,171,17,2,155,144,67,140}
  local KB={159,201,181,99,183,109,116,120,226,244,120,141,94,4,62,109,241,219,18,48,235,1,225,77,45,253,7,241,177,34,39,73}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_00e6cf[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_909818[mid]-ksa)%256
    n=n+1
    out[n]=_697fa1[p]
  end
  return table.concat(out)
end
local _af5164
do
  local np = 10
  local base = ("https://kin".."gmor.up.railway.app/api/loader/5f1cb9179c6a9d.lua?pack=1&part=") .. "@@PARTNUM@@" .. "&dtok=" .. "eyJzIjoiNWYxY2I5MTc5YzZhOWQiLCJzZCI6ImIzMjJlNGQyZWRmZSIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MjkzNTQ1NzA2OX0.u_Lr3NWypX5fe5DV-NN9XSWxdXKSGnxg2GvEU5LC1Nc"
  local single = ("https://kin".."gmor.up.railway.app/api/loader/5f1cb9179c6a9d.lua?single=1&dtok=eyJzIjoiNWYxY2I5MTc5YzZhOWQiLCJzZCI6ImIzMjJlNGQyZWRmZSIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MjkzNTQ1NzA2OX0.u_Lr3NWypX5fe5DV-NN9XSWxdXKSGnxg2GvEU5LC1Nc")
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _472249(hx)
    local body = string.sub(res, 9)
    if (_10ee2c(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function runMsg(res)
    if type(res) ~= "string" or #res < 10 then return end
    if string.find(res, "Kick", 1, true) == nil then return end
    if _99bbaa then pcall(function() local f = _99bbaa(res) if type(f) == "function" then f() end end) end
  end
  local function fetchAll()
    if _99bbaa == nil then return nil, "no loader" end
    local res, err = _7e8ad7(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_10ee2c(body) % 4294967296) ~= _472249("1ca272e0") then
      return nil, "payload hash"
    end
    return { body }
  end
  -- 1) documented path: verified parts
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _7e8ad7(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then runMsg(res) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i) .. " (" .. tostring(lastErr) .. ")"
      break
    end
    got[i] = body
  end
  if missing == nil then
    _af5164 = got
  else
    -- 2) fallback: whole payload in a single request
    local all, why = fetchAll()
    if all == nil then
      _d77eb3("Download failed part " .. missing)
      return
    end
    _af5164 = all
  end
end
local ok, plain, why = (function()
  local sh = _af5164
  if type(sh) ~= "table" then return false, nil, "no payload" end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _af5164 = nil
  if #joined == 0 then return false, nil, "empty payload" end
  local expect = _472249("1ca272e0")
  if expect ~= nil and (_10ee2c(joined) % 4294967296) ~= expect then
    return false, nil, "payload checksum mismatch"
  end
  local raw = _5bf1a6(joined)
  joined = nil
  local out = (_ba5132)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, "decrypt failed" end
  local ph = _472249("6126d0e7")
  if ph ~= nil and (_10ee2c(out) % 4294967296) ~= ph then
    return false, nil, "integrity mismatch"
  end
  return true, out, nil
end)()
if not ok then
  _d77eb3("Payload error: " .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = "5f1cb9179c6a9d", scriptId = "5f1cb9179c6a9d", t = 0}
  pcall(function() if type(os) == "table" and type(os.clock) == "function" then sess.t = os.clock() end end)
  local function setg(name, value)
    pcall(function() if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then g[name] = value end end end)
    pcall(function() if type(_G) == "table" then _G[name] = value end end)
  end
  setg("_KM_AUTH", sess)
  setg("_KM_SID", sess.sid)
  setg("_KM_BASE", ("https://kin".."gmor.up.railway.app"))
  setg("_KM_HWID", hwid)
end
if type(_99bbaa) ~= "function" then
  _d77eb3("Executor missing loadstring")
  return
end
local fn, cerr = _99bbaa(plain)
plain = nil
if type(fn) ~= "function" then
  warn(("[Kin".."gmor] compile: ") .. tostring(cerr))
  _d77eb3("Script compile error")
  return
end
local rok, runErr = pcall(fn)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(("[Kin".."gmor] runtime: ") .. tostring(runErr)) end
