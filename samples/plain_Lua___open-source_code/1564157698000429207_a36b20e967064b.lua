-- JwwwVylCa0thDiBiBDhbawQ
local Players = game:GetService("Players")
local _kmLp = Players and Players.LocalPlayer
local function _ecd85a(msg)
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
local uk = nil
do
  local names = {"script_key", "ScriptKey", ("KIN".."GMOR_KEY")}
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
  _ecd85a("Set script_key before running the loader")
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))
local _e7de9d
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
  _e7de9d = function(url)
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
  local url = ("https://kin".."gmor.up.railway.app/api/hwid/check?scriptId=a36b20e967064b&key=") .. uk .. "&hwid=" .. hwid
  local body, err
  for attempt = 1, 3 do
    body, err = _e7de9d(url)
    if type(body) == "string" and #body > 0 then break end
    nap(0.4 * attempt)
  end
  if type(body) ~= "string" or #body == 0 then
    _ecd85a("HWID Check Failed (network: " .. tostring(err) .. ")")
    return
  end
  local data = nil
  pcall(function() data = game:GetService("HttpService"):JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    _ecd85a(tostring(reason))
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
        envs[i][bad[j]] = function() _ecd85a("Dump source detected [" .. bad[j] .. "]") end
      end
    end
    local d = envs[i]._LAST_DUMP or envs[i]._KM_DUMP
    if type(d) == "string" and #d > 200 then
      _ecd85a("Dump source detected [captured]")
      return
    end
  end
end
local _ff6ecd
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
      if type(f) == "function" then _ff6ecd = f break end
    end
  end
end
local _c5e751={}
for i=0,255 do _c5e751[i]=string.char(i) end
local _e5067a,_dcd215={},{}
do
  local ta="34204cf6355cc32cdbebef4838a7ab9ea41674428d69d7c9a889fd78a10b9036c1f26da004d16893182303f3159cd850fab34459aabe6554c609fb6494735b49b8e437560a88014e7faf05d6b4bc8c2ad32db6ea8183468230286c1b84bf7c987df045edb121f79d67e5b05f9796111387adbde179f96b630e2ff5baf1acf46f06c45885fe3c9ba98662ca52b7a6663f515d8b021ecbee9f411a80cd574d1f92dabb9532310fdfec2761d5c0a25ab217009a1da54ffc0825c875998a1c3aae7e19c7d45e4be8e0e9d2c210143d4ab50d760ce7ddce2ecfe23be6336e72266a778f7bff55e33e29537060f840b9dc2247c512247a39d08e07deccd943a371912b"
  local tb="722411d5b8d4949c3296bcf3e28e23d8f1f86ddf89c1b34cded1591558c717b71d8d014e9b3c43cf21c009c31648138086e04928b96391abf5ea062c7a181937b2ef425350e3045f6f0a85e5b5fe2f7c5b1aadbaf4ff300f414f4d3fa66529bd2046f0cd8769552e5782aeeca87622a2ee66dc143ac933f239bb54a436e4d6786b62087381d0078bfc75e884fb9e64db252bb02dedeb98835274ac451bce310cd79f0299a3d23ea0c55e8861aa1f5de7a5c66e1005e9f7be4af6c4dd6c0eda707e8a47447993713d6a5195e18cb69d5c67a17b34000da7f9265acbb1cca9b4bf4b3b7f901caf8f1240681e92c2e6977d0bc856cafd35fa039ad36077382a27d9"
  for i=1,256 do
    _e5067a[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _dcd215[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _e72441={}
do
  local a="KbJ6ZO2tIN3n8BmFdEks1GHpruqjLyWw" .. "liTVfP5QD9c-v4CRUaAzSgMY0ox_Xh7e"
  for i=1,#a do _e72441[string.byte(a,i)]=i-1 end
end
local function _c0c427(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_e72441[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_c5e751[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _6c320c(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _142f6e(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _578830(S)
  local sa,pa=1229746406,66
  local sb,pb=2296697620,165
  local MA,AA,LA=670285,-1809369707,6137427
  local MB,AB,LB=368679,-520442623,10007946
  local KA={16,251,192,51,177,3,84,243,88,173,137,211,62,50,94,138,131,244,149,156,232,236,209,48,223,29,80,154,6,101,204,76}
  local KB={45,213,209,77,167,140,94,69,4,7,237,237,102,83,144,142,248,123,234,75,139,232,148,141,247,145,84,142,155,22,209,141}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_dcd215[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_e5067a[mid]-ksa)%256
    n=n+1
    out[n]=_c5e751[p]
  end
  return table.concat(out)
end
local _9894d0
do
  local np = 17
  local base = ("https://kin".."gmor.up.railway.app/api/loader/a36b20e967064b.lua?pack=1&part=") .. "@@PARTNUM@@" .. "&dtok=" .. "eyJzIjoiYTM2YjIwZTk2NzA2NGIiLCJzZCI6ImYwY2NmMTg3YTQxYiIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5Mjk5NTU1NzE0MH0.geYs-9dr7v8NXV4k7JqLSui8Q6dhmoIDi4uoIRrIIjM"
  local single = ("https://kin".."gmor.up.railway.app/api/loader/a36b20e967064b.lua?single=1&dtok=eyJzIjoiYTM2YjIwZTk2NzA2NGIiLCJzZCI6ImYwY2NmMTg3YTQxYiIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5Mjk5NTU1NzE0MH0.geYs-9dr7v8NXV4k7JqLSui8Q6dhmoIDi4uoIRrIIjM")
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _6c320c(hx)
    local body = string.sub(res, 9)
    if (_142f6e(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function runMsg(res)
    if type(res) ~= "string" or #res < 10 then return end
    if string.find(res, "Kick", 1, true) == nil then return end
    if _ff6ecd then pcall(function() local f = _ff6ecd(res) if type(f) == "function" then f() end end) end
  end
  local function fetchAll()
    if _ff6ecd == nil then return nil, "no loader" end
    local res, err = _e7de9d(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_142f6e(body) % 4294967296) ~= _6c320c("1dfd6418") then
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
      local res, err = _e7de9d(string.gsub(base, "@@PARTNUM@@", tostring(i)))
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
    _9894d0 = got
  else
    -- 2) fallback: whole payload in a single request
    local all, why = fetchAll()
    if all == nil then
      _ecd85a("Download failed part " .. missing)
      return
    end
    _9894d0 = all
  end
end
local ok, plain, why = (function()
  local sh = _9894d0
  if type(sh) ~= "table" then return false, nil, "no payload" end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _9894d0 = nil
  if #joined == 0 then return false, nil, "empty payload" end
  local expect = _6c320c("1dfd6418")
  if expect ~= nil and (_142f6e(joined) % 4294967296) ~= expect then
    return false, nil, "payload checksum mismatch"
  end
  local raw = _c0c427(joined)
  joined = nil
  local out = (_578830)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, "decrypt failed" end
  local ph = _6c320c("14f995e4")
  if ph ~= nil and (_142f6e(out) % 4294967296) ~= ph then
    return false, nil, "integrity mismatch"
  end
  return true, out, nil
end)()
if not ok then
  _ecd85a("Payload error: " .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = "a36b20e967064b", scriptId = "a36b20e967064b", t = 0}
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
if type(_ff6ecd) ~= "function" then
  _ecd85a("Executor missing loadstring")
  return
end
local fn, cerr = _ff6ecd(plain)
plain = nil
if type(fn) ~= "function" then
  warn(("[Kin".."gmor] compile: ") .. tostring(cerr))
  _ecd85a("Script compile error")
  return
end
local rok, runErr = pcall(fn)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(("[Kin".."gmor] runtime: ") .. tostring(runErr)) end
