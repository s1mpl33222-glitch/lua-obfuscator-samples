-- Kingmor loader
local Players = game:GetService("Players")
local _kmLp = Players and Players.LocalPlayer
local function _60aa20(msg)
  pcall(function()
    local lp = _kmLp or (game:GetService("Players") and game:GetService("Players").LocalPlayer)
    if lp then pcall(function() lp:Kick("[Kingmor] " .. tostring(msg)) end) end
  end)
  warn("[Kingmor] " .. tostring(msg))
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

local uk = nil
do
  local names = {"script_key", "ScriptKey", "KINGMOR_KEY"}
  local envs = {}
  pcall(function() if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then envs[#envs+1] = g end end end)
  pcall(function() if type(getfenv) == "function" then local f = getfenv(0) if type(f) == "table" then envs[#envs+1] = f end end end)
  if type(_G) == "table" then envs[#envs+1] = _G end
  pcall(function() if type(shared) == "table" then envs[#envs+1] = shared end end)
  for i = 1, #envs do
    for j = 1, #names do
      local v = envs[i][names[j]]
      if type(v) == "string" and #v >= 4 then uk = v break end
    end
    if uk then break end
  end
end
if type(uk) ~= "string" or #uk < 4 then
  _60aa20("Set script_key before running the loader")
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))

local _a98d44
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
  _a98d44 = function(url)
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
  local url = "https://kingmor.up.railway.app/api/hwid/check?scriptId=cee864bc1138e8&key=" .. uk .. "&hwid=" .. hwid
  local body, err
  for attempt = 1, 3 do
    body, err = _a98d44(url)
    if type(body) == "string" and #body > 0 then break end
    nap(0.4 * attempt)
  end
  if type(body) ~= "string" or #body == 0 then
    _60aa20("HWID Check Failed (network: " .. tostring(err) .. ")")
    return
  end
  local data = nil
  pcall(function() data = game:GetService("HttpService"):JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    _60aa20(tostring(reason))
    return
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
        envs[i][bad[j]] = function() _60aa20("Dump source detected [" .. bad[j] .. "]") end
      end
    end
    local d = envs[i]._LAST_DUMP or envs[i]._KM_DUMP
    if type(d) == "string" and #d > 200 then
      _60aa20("Dump source detected [captured]")
      return
    end
  end
end
local _286287
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
      if type(f) == "function" then _286287 = f break end
    end
  end
end

local _63e20a={}
for i=0,255 do _63e20a[i]=string.char(i) end
local _979b31,_5152de={},{}
do
  local ta="13b3fec3a11b71c19864852a0ec63bb5e0682e740cb1cfbc6b8309ff5b67c487dc9a1ffdeddfbbfbcad5d44d62fc8863def21c4031145d72e327755c94f10278a860d2932ce608cb7c5379aa7fdd3ebef8a757814116956d4b0135ecf061fae251206e0d298d5fea33d3a4242dc8394fe144490734a6803ff632baccb6385603ad9ba00b15bfce767b8c37aed8e469d9e9059ea989f91d5217861e4623eb3c45066caff730c7007ed6c04e439047129db85a772f509c4a65da6a73e8d766a20f0a21f48eb26fef7db058dbac189fb7ab047aa5c58219f52848222554269942c28bb4923611c98af3d14c55bd3a3d102bcda35ee7708fd091e59659ee1ab98497"
  local tb="44487e4e52a6842c6c0eafe04f1722c9aa9ad511b0cfa2922a27d719e79e6ef8e91c507016431264eb7fa77c04b55ab277faea0d8e3e68cd61b43841a47855e16676089b6a8bfb463a9d0507a3dee398bf1531a1674c96f1c1394a748201fd3b81105f4990b7ece49f8d56475bda4d062629e5a9d28928adf6d98654f7dde8721b8cdc99831865ffc3bbf071b6c65dce0c3d4269f5cb236d202e930959d05eab451ea01f1a142bedfedf877d3c24737b34d3ee5c36fcf32fcc8aae882da5beb1d88f37f28558f46f3075403353c7c435a86325c51dcae2ba57f97a9cacef1300d462bc95020a6079c051b9214b3f0b91bd97c294320fc8e6dbd6d16bb3b88003"
  for i=1,256 do
    _979b31[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _5152de[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _782844={}
do
  local a="R4O1KxGw3QVLeuMZCYXmlJqTNgc5_kon" .. "2rAvFS89Djf-6BUPzp0HbIa7hysWidtE"
  for i=1,#a do _782844[string.byte(a,i)]=i-1 end
end
local function _ffe374(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_782844[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_63e20a[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _167863(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _9096f4(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _f937bb(S)
  local sa,pa=572710444,204
  local sb,pb=2011934954,77
  local MA,AA,LA=307313,-1194775659,15416399
  local MB,AB,LB=28901,1139364049,9832462
  local KA={186,39,46,170,184,61,163,242,19,69,157,12,218,93,229,1,65,19,115,127,213,51,177,178,141,239,210,232,204,255,105,250}
  local KB={176,189,200,254,215,203,24,36,137,235,124,196,253,227,137,61,146,240,108,58,46,43,83,27,222,112,225,117,162,25,131,49}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_5152de[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_979b31[mid]-ksa)%256
    n=n+1
    out[n]=_63e20a[p]
  end
  return table.concat(out)
end
local _3fa066
do
  local np = 8
  local base = "https://kingmor.up.railway.app/api/loader/cee864bc1138e8.lua?pack=1&part=" .. "@@PARTNUM@@" .. "&dtok=" .. "eyJzIjoiY2VlODY0YmMxMTM4ZTgiLCJzZCI6ImM2NzZiYmIzZWY3NiIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MjkzMjY2ODEwNX0.-FaH8sm12QrWAUQJvWo97CYlnx_x5WZIUnYJxmZsWak"
  local single = "https://kingmor.up.railway.app/api/loader/cee864bc1138e8.lua?single=1&dtok=eyJzIjoiY2VlODY0YmMxMTM4ZTgiLCJzZCI6ImM2NzZiYmIzZWY3NiIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MjkzMjY2ODEwNX0.-FaH8sm12QrWAUQJvWo97CYlnx_x5WZIUnYJxmZsWak"
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _167863(hx)
    local body = string.sub(res, 9)
    if (_9096f4(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function runMsg(res)
    if type(res) ~= "string" or #res < 10 then return end
    if string.find(res, "Kick", 1, true) == nil then return end
    if _286287 then pcall(function() local f = _286287(res) if type(f) == "function" then f() end end) end
  end
  local function fetchAll()
    if _286287 == nil then return nil, "no loader" end
    local res, err = _a98d44(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_9096f4(body) % 4294967296) ~= _167863("3f7f4fbc") then
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
      local res, err = _a98d44(string.gsub(base, "@@PARTNUM@@", tostring(i)))
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
    _3fa066 = got
  else
    -- 2) fallback: whole payload in a single request
    local all, why = fetchAll()
    if all == nil then
      _60aa20("Download failed part " .. missing)
      return
    end
    _3fa066 = all
  end
end

local ok, plain, why = (function()
  local sh = _3fa066
  if type(sh) ~= "table" then return false, nil, "no payload" end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _3fa066 = nil
  if #joined == 0 then return false, nil, "empty payload" end
  local expect = _167863("3f7f4fbc")
  if expect ~= nil and (_9096f4(joined) % 4294967296) ~= expect then
    return false, nil, "payload checksum mismatch"
  end
  local raw = _ffe374(joined)
  joined = nil
  local out = (_f937bb)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, "decrypt failed" end
  local ph = _167863("eb440b56")
  if ph ~= nil and (_9096f4(out) % 4294967296) ~= ph then
    return false, nil, "integrity mismatch"
  end
  return true, out, nil
end)()
if not ok then
  _60aa20("Payload error: " .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = "cee864bc1138e8", scriptId = "cee864bc1138e8", t = 0}
  pcall(function() if type(os) == "table" and type(os.clock) == "function" then sess.t = os.clock() end end)
  local function setg(name, value)
    pcall(function() if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then g[name] = value end end end)
    pcall(function() if type(_G) == "table" then _G[name] = value end end)
  end
  setg("_KM_AUTH", sess)
  setg("_KM_SID", sess.sid)
  setg("_KM_BASE", "https://kingmor.up.railway.app")
  setg("_KM_HWID", hwid)
end
if type(_286287) ~= "function" then
  _60aa20("Executor missing loadstring")
  return
end
local fn, cerr = _286287(plain)
plain = nil
if type(fn) ~= "function" then
  warn("[Kingmor] compile: " .. tostring(cerr))
  _60aa20("Script compile error")
  return
end
local rok, runErr = pcall(fn)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn("[Kingmor] runtime: " .. tostring(runErr)) end
