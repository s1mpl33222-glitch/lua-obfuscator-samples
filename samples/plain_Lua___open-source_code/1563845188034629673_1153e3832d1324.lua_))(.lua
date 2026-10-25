-- Kingmor loader
local Players = game:GetService("Players")
local _kmLp = Players and Players.LocalPlayer
local function _1986bb(msg)
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
  _1986bb("Set script_key before running the loader")
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))

local _bf705d
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
  _bf705d = function(url)
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
  local url = "https://kingmor.up.railway.app/api/hwid/check?scriptId=1153e3832d1324&key=" .. uk .. "&hwid=" .. hwid
  local body, err
  for attempt = 1, 3 do
    body, err = _bf705d(url)
    if type(body) == "string" and #body > 0 then break end
    nap(0.4 * attempt)
  end
  if type(body) ~= "string" or #body == 0 then
    _1986bb("HWID Check Failed (network: " .. tostring(err) .. ")")
    return
  end
  local data = nil
  pcall(function() data = game:GetService("HttpService"):JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    _1986bb(tostring(reason))
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
        envs[i][bad[j]] = function() _1986bb("Dump source detected [" .. bad[j] .. "]") end
      end
    end
    local d = envs[i]._LAST_DUMP or envs[i]._KM_DUMP
    if type(d) == "string" and #d > 200 then
      _1986bb("Dump source detected [captured]")
      return
    end
  end
end
local _8863ca
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
      if type(f) == "function" then _8863ca = f break end
    end
  end
end

local _27ab1c={}
for i=0,255 do _27ab1c[i]=string.char(i) end
local _893ad4,_ce16d4={},{}
do
  local ta="35a8fdc9534e5f554d20aec6932a830719efa7a61c7b6470b6b3124997e3d689dff6774bbd678a06e543fa739dadb0fe7172d45c4a615836085796f213ddd7d991825ad2e17cce05c1c3f74744a2ff0edabc3f78f86d23f4341f31662fb4e788330ac8cc2e9c222bcb0bd8387a1d323e18b7a4d380101ed07d608d0fb221466c6e3a0cca796b866a5bf35d8f84c7a0f503ba3bd52cf950c29915de65e68e769ee2405e269802257404bfb845f1c4bb092db18b6300d187ab14a1a9db52acf0af37ebb5eee875c5aa414f394c90a5c011e09f28eab9427f7e92cf9554851b5916688c6f9469e9cd62309b48eda39a272951e4be56ec01170d3d1adc8124fb3cfc"
  local tb="715045d887feb43f847632e53c2cf573429330b0512563c809c4d22d91fd0038838097c2340bb399d0123616b827fc1ddf70fa4ef3e4966bf895543aec788ea8ca7b86d35a8ac715117a02a78d17b59ccfab1879677d48a24a537220d97f397c296c2a650a2f2b68b2199f6fc6dd64339ef024cd130356a1ebbf886a41eff461011fd6cb05aef6850c4057e8be62b6c5c3d1d5af266e74ccc9f2ba8f77944349dc905ef9f1ee5c664ca65fd70d2ee7aa35521ead31ce08f7a51089ac8221b74d594b5d8beae1376947da6d06dea99dfbb11c22c10effe2817ebca48ced0fd41a55145804b93de6bddb9a0723e9e3a3bb46c0284498603b751b4fe05b9ba03e92"
  for i=1,256 do
    _893ad4[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _ce16d4[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _8201d7={}
do
  local a="F7tMiQSTsV86p0ja5ANEeuLo4JmZYC31" .. "xf92nOKI_WwXvbzrc-BDgldPGqHRyhUk"
  for i=1,#a do _8201d7[string.byte(a,i)]=i-1 end
end
local function _282058(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_8201d7[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_27ab1c[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _3ba534(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _b33c5c(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _48a998(S)
  local sa,pa=2570911560,221
  local sb,pb=1173858763,59
  local MA,AA,LA=746955,140192837,13899667
  local MB,AB,LB=542517,-1453553941,10808218
  local KA={54,9,67,136,0,139,195,198,124,84,161,64,6,254,128,135,75,213,245,138,168,233,191,58,136,50,92,59,111,55,130,110}
  local KB={60,182,217,203,180,194,69,185,72,95,161,22,135,249,119,145,57,23,246,144,104,27,133,160,177,188,254,46,86,236,235,150}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_ce16d4[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_893ad4[mid]-ksa)%256
    n=n+1
    out[n]=_27ab1c[p]
  end
  return table.concat(out)
end
local _756801={
 [1]="MUt8pm7LWbPNLdFohnC168k8m" .. "_O7LGAVOilGj4LCbXroH3ilWj" .. "UYxnhtUhce0_NIdYQkEj2aec"
}

local ok, plain, why = (function()
  local sh = _756801
  if type(sh) ~= "table" then return false, nil, "no payload" end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _756801 = nil
  if #joined == 0 then return false, nil, "empty payload" end
  local expect = _3ba534("d7610f03")
  if expect ~= nil and (_b33c5c(joined) % 4294967296) ~= expect then
    return false, nil, "payload checksum mismatch"
  end
  local raw = _282058(joined)
  joined = nil
  local out = (_48a998)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, "decrypt failed" end
  local ph = _3ba534("d4abcfa8")
  if ph ~= nil and (_b33c5c(out) % 4294967296) ~= ph then
    return false, nil, "integrity mismatch"
  end
  return true, out, nil
end)()
if not ok then
  _1986bb("Payload error: " .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = "1153e3832d1324", scriptId = "1153e3832d1324", t = 0}
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
if type(_8863ca) ~= "function" then
  _1986bb("Executor missing loadstring")
  return
end
local fn, cerr = _8863ca(plain)
plain = nil
if type(fn) ~= "function" then
  warn("[Kingmor] compile: " .. tostring(cerr))
  _1986bb("Script compile error")
  return
end
local rok, runErr = pcall(fn)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn("[Kingmor] runtime: " .. tostring(runErr)) end
