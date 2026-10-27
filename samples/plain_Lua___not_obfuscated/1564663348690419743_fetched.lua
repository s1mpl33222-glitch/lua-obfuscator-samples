local _ddb334
local function _4efb7b(msg)
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
  _4efb7b("Set script_key before running the loader")
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))
local _a3c221
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
  _a3c221 = function(url)
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
  local url = ("https://kin".."gmor.up.railway.app/api/hwid/check?scriptId=e606cddc1191cf&key=") .. uk .. "&hwid=" .. hwid
  local body, err
  for attempt = 1, 3 do
    body, err = _a3c221(url)
    if type(body) == "string" and #body > 0 then break end
    nap(0.4 * attempt)
  end
  if type(body) ~= "string" or #body == 0 then
    _4efb7b("HWID Check Failed (network: " .. tostring(err) .. ")")
    return
  end
  local data = nil
  pcall(function() data = game:GetService("HttpService"):JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    _4efb7b(tostring(reason))
    return
  end
end
local _bb2ad5
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
      if type(f) == "function" then _bb2ad5 = f break end
    end
  end
end
_ddb334=(function()
return (function()
local _da4={}
for _r4t=0,255 do _da4[_r4t]=string.char(_r4t) end
local _30a3={}
do
  local _jyr="yZF8ih_gakPO2HAJW6mzBneM3XI17GjDrqpEvuVRw-4UKcxoTlNSL0Y9Qtbf5sCd"
  for _r4t=1,#_jyr do _30a3[string.byte(_jyr,_r4t)]=_r4t-1 end
end
local function _d8dc(s)
  local _typ,_bp0,_jh0,_mgt={},0,0,0
  for _r4t=1,#s do
    local _s25=_30a3[string.byte(s,_r4t)]
    if _s25 then
      _jh0=_jh0*64+_s25
      _mgt=_mgt+6
      if _mgt>=8 then
        _mgt=_mgt-8
        local _w9w=2^_mgt
        _bp0=_bp0+1
        _typ[_bp0]=_da4[math.floor(_jh0/_w9w)%256]
        _jh0=_jh0%_w9w
      end
    end
  end
  return table.concat(_typ)
end
local _9e={}
do
  local _fgi="\163\175\174\255\210\223\238\162\231\218iK\222\178G-\245H\131W,$\011\233\211\184\137V\180\007\212\192~\251\151\r0\221>\195\173\226\215\006\160\134;b[\214\012`I6\161m\181\252\197\140\170s\227\213\016\031\217(\229}]\188\022R\219\236\015\224\171+\017d{\018t'r\240J\241^\154\141\026OQT\143\164\157\244\198\191\168\156\243\165f\025\199?\"Y\008\019j5\000\002w\228\132\155\230\202\\P84\136\146\029M\169\189\232\196\201\207!\020\176\225hg\186x9\237k|\177\247N\028\248)A.FSu\194\254\253\158\001v\153\142Z\206\204\133\208\144=7C\003\027\024\167\030\249y\172\021\023\005\130B\187\205\159e\200c\185D@X\193&U1*\135\004\234\139\216\129\246\179\145 #\250p\009E\242%_\138\239\152n/\190\209o3z\148al\203<\014\182\235\147\127\n\149\220:\150L2\183q\166\128"
  for _r4t=1,256 do _9e[string.byte(_fgi,_r4t)]=_r4t-1 end
end
local function _87(S)
  local _9hy,_va0=3638142164,230
  local _typ,_bp0,_joy={},0,0
  local P=880227 A=-1362493607 L=5611252
  local K={255,81,192,57,6,115,218,107,140,116,21,87,181,191,208,182,228,125,160,66,255,174,184,108,43,181,109,49,174,10,117,199}
  for _r4t=1,#S do
    _9hy=(P*_9hy+A)%4294967296
    local _k9e=string.byte(S,_r4t)
    local _ves=(_9hy%256+K[((_r4t-1)%32)+1]+((_r4t*113+L)%256)+_va0)%256
    _va0=_k9e
    local _8a4=(_9e[_k9e]-_ves)%256
    _joy=(_joy*33+_8a4)%4294967296
    _bp0=_bp0+1
    _typ[_bp0]=_da4[_8a4]
  end
  return table.concat(_typ),_joy
end
local function _fz(_zg, _ki)
local _bc = table.unpack or unpack
local function _md(...) return { n = select('#', ...), ... } end
local _xe
_xe = function(_hb, _sn, _th)
local f77kju, _fg, f2j3cz = _hb.f77kju, _hb.k, _hb.f2j3cz
local _pk = {}
local _yq = _hb.f4t3bv
for _wz = 1, _yq do _pk[_wz] = _sn[_wz] end
local _pg, _ai = {}, 0
if _hb.f12jpy then
local _hq = _sn.n or #_sn
for _wz = _yq + 1, _hq do _ai = _ai + 1; _pg[_ai] = _sn[_wz] end
end
local _lj = _hb.f8ie8j + 8
local _wk = 1
while true do
local _hm = f77kju[_wk]
local _ts = f77kju[_wk + 1]
if _hm == 38 then
_pk[_ts] = _pk[f77kju[_wk + 2]]
_wk = _wk + 4
elseif _hm == 9 then
_pk[_ts] = _fg[f77kju[_wk + 2]]
_wk = _wk + 4
elseif _hm == 40 then
_pk[_ts] = _ki[_fg[f77kju[_wk + 2]]]
_wk = _wk + 4
elseif _hm == 12 then
local _eu = f77kju[_wk + 2]
local _de = _pk[_eu]
if _eu >= 256 then _de = _fg[_eu - 256] end
local _pv = f77kju[_wk + 3]
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
_pk[_ts] = _de[_pv]
_wk = _wk + 4
elseif _hm == 37 then
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
local _ly = _pk[_ts]
local n = (_eu == 0) and (_lj - _ts) or (_eu - 1)
if _pv == 2 then
if n == 0 then _pk[_ts] = _ly()
elseif n == 1 then _pk[_ts] = _ly(_pk[_ts + 1])
elseif n == 2 then _pk[_ts] = _ly(_pk[_ts + 1], _pk[_ts + 2])
elseif n == 3 then _pk[_ts] = _ly(_pk[_ts + 1], _pk[_ts + 2], _pk[_ts + 3])
else
local _de = {}
for _wz = 1, n do _de[_wz] = _pk[_ts + _wz] end
_pk[_ts] = _ly(_bc(_de, 1, n))
end
elseif _pv == 1 then
if n == 0 then _ly()
elseif n == 1 then _ly(_pk[_ts + 1])
elseif n == 2 then _ly(_pk[_ts + 1], _pk[_ts + 2])
elseif n == 3 then _ly(_pk[_ts + 1], _pk[_ts + 2], _pk[_ts + 3])
else
local _de = {}
for _wz = 1, n do _de[_wz] = _pk[_ts + _wz] end
_ly(_bc(_de, 1, n))
end
else
local _oq
if n == 0 then _oq = _md(_ly())
elseif n == 1 then _oq = _md(_ly(_pk[_ts + 1]))
elseif n == 2 then _oq = _md(_ly(_pk[_ts + 1], _pk[_ts + 2]))
elseif n == 3 then _oq = _md(_ly(_pk[_ts + 1], _pk[_ts + 2], _pk[_ts + 3]))
elseif n == 4 then _oq = _md(_ly(_pk[_ts + 1], _pk[_ts + 2], _pk[_ts + 3], _pk[_ts + 4]))
else
local _de = {}
for _wz = 1, n do _de[_wz] = _pk[_ts + _wz] end
_oq = _md(_ly(_bc(_de, 1, n)))
end
if _pv == 0 then
local _kt = _oq.n
for _wz = 1, _kt do _pk[_ts + _wz - 1] = _oq[_wz] end
if _kt == 0 then _pk[_ts] = nil end
_lj = _ts + _kt - 1
else
local _zr = _pv - 1
for _wz = 1, _zr do _pk[_ts + _wz - 1] = _oq[_wz] end
end
end
_wk = _wk + 4
elseif _hm == 14 then
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
_pk[_ts] = _eu + _pv
_wk = _wk + 4
elseif _hm == 33 then
if _pk[_ts] then _wk = _wk + 4 else _wk = _wk + f77kju[_wk + 2] * 4 end
elseif _hm == 24 then
_wk = _wk + _ts * 4
elseif _hm == 34 then
local _de = _pk[_ts]
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
_de[_eu] = _pv
_wk = _wk + 4
elseif _hm == 17 then
_pk[_ts] = f77kju[_wk + 2]
_wk = _wk + 4
elseif _hm == 4 then
if _pk[_ts] then _wk = _wk + f77kju[_wk + 2] * 4 else _wk = _wk + 4 end
elseif _hm == 29 then
local _eu = f77kju[_wk + 2]
if _eu == 0 then
local n = _lj - _ts + 1
if n <= 0 then return end
local _de = {}
for _wz = 1, n do _de[_wz] = _pk[_ts + _wz - 1] end
return _bc(_de, 1, n)
end
local n = _eu - 1
if n <= 0 then return end
local _de = {}
for _wz = 1, n do _de[_wz] = _pk[_ts + _wz - 1] end
return _bc(_de, 1, n)
elseif _hm == 6 then
local _eu = f77kju[_wk + 2]
for _wz = _ts, _ts + _eu - 1 do _pk[_wz] = nil end
_wk = _wk + 4
elseif _hm == 11 or _hm == 30 or _hm == 18 or _hm == 20 or _hm == 19 or _hm == 7 then
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
if _hm == 11 then _pk[_ts] = (_eu == _pv)
elseif _hm == 30 then _pk[_ts] = (_eu ~= _pv)
elseif _hm == 18 then _pk[_ts] = (_eu < _pv)
elseif _hm == 20 then _pk[_ts] = (_eu <= _pv)
elseif _hm == 19 then _pk[_ts] = (_eu > _pv)
else _pk[_ts] = (_eu >= _pv) end
_wk = _wk + 4
elseif _hm == 32 or _hm == 41 or _hm == 13 or _hm == 5 or _hm == 26 then
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
if _hm == 32 then _pk[_ts] = _eu - _pv
elseif _hm == 41 then _pk[_ts] = _eu * _pv
elseif _hm == 13 then _pk[_ts] = _eu / _pv
elseif _hm == 5 then _pk[_ts] = _eu % _pv
else _pk[_ts] = _eu ^ _pv end
_wk = _wk + 4
elseif _hm == 42 then
_pk[_ts] = (f77kju[_wk + 2] ~= 0)
_wk = _wk + 4
elseif _hm == 23 then
_pk[_ts] = {}
_wk = _wk + 4
elseif _hm == 27 then
local _de = _pk[_ts]
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
if _eu == 0 then _eu = _lj - _ts end
local _dp = _pv - 1
for _wz = 1, _eu do _de[_dp + _wz] = _pk[_ts + _wz] end
_wk = _wk + 4
elseif _hm == 10 then
local _eu = _pk[f77kju[_wk + 2]]
local _pv = f77kju[_wk + 3]
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
_pk[_ts] = _eu[_pv]
_pk[_ts + 1] = _eu
_wk = _wk + 4
elseif _hm == 16 then
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
local _sc = _pk[_eu]
for _wz = _eu + 1, _pv do _sc = _sc .. _pk[_wz] end
_pk[_ts] = _sc
_wk = _wk + 4
elseif _hm == 35 then
local _na = f2j3cz[f77kju[_wk + 2]]
local f9wrea = {}
local _rx = _na.f9wrea
for _wz = 1, #_rx do
local _cz = _rx[_wz]
if _cz.f2xuh4 then f9wrea[_wz] = _pk[_cz.f4mqac] else f9wrea[_wz] = _th[_cz.f4mqac] end
end
_pk[_ts] = function(...) return _xe(_na, _md(...), f9wrea) end
_wk = _wk + 4
elseif _hm == 31 then
local _eu = f77kju[_wk + 2]
if _eu == 0 then
for _wz = 1, _ai do _pk[_ts + _wz - 1] = _pg[_wz] end
_lj = _ts + _ai - 1
else
local n = _eu - 1
for _wz = 1, n do _pk[_ts + _wz - 1] = _pg[_wz] end
end
_wk = _wk + 4
elseif _hm == 8 then
_pk[_ts] = _th[f77kju[_wk + 2]][1]
_wk = _wk + 4
elseif _hm == 22 then
_th[_ts][1] = _pk[f77kju[_wk + 2]]
_wk = _wk + 4
elseif _hm == 2 then
_pk[_ts] = {}
_wk = _wk + 4
elseif _hm == 3 then
_pk[_ts] = _pk[f77kju[_wk + 2]][1]
_wk = _wk + 4
elseif _hm == 39 then
local _de = _pk[_ts]
_de[1] = _pk[f77kju[_wk + 2]]
_wk = _wk + 4
elseif _hm == 25 then
local _de = _pk[_ts]
local n = #_de
local _wz = f77kju[_wk + 2]
while _wz <= _lj do n = n + 1; _de[n] = _pk[_wz]; _wz = _wz + 1 end
_wk = _wk + 4
elseif _hm == 28 then
_ki[_fg[_ts]] = _pk[f77kju[_wk + 2]]
_wk = _wk + 4
elseif _hm == 15 then
local _eu = f77kju[_wk + 2]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
_pk[_ts] = -_eu
_wk = _wk + 4
elseif _hm == 1 then
local _eu = f77kju[_wk + 2]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
_pk[_ts] = not _eu
_wk = _wk + 4
elseif _hm == 21 then
local _eu = f77kju[_wk + 2]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
_pk[_ts] = #_eu
_wk = _wk + 4
elseif _hm == 36 then
local _eu, _pv = f77kju[_wk + 2], f77kju[_wk + 3]
if _eu >= 256 then _eu = _fg[_eu - 256] else _eu = _pk[_eu] end
if _pv >= 256 then _pv = _fg[_pv - 256] else _pv = _pk[_pv] end
_pk[_ts] = math.floor(_eu / _pv)
_wk = _wk + 4
else
error(('E'..tostring(_hm)), 0)
end
end
end
return _xe(_zg, { n = 0 }, {})
end
local function _qa(_sc, _ic, _vj)
_ic = _ic or 1
local function KMVX8(_ts,_pv)
_ts=_ts%256 _pv=_pv%256
local r,_hb=0,1
for _=1,8 do
local _of,w=_ts%2,_pv%2
if _of~=w then r=r+_hb end
_ts=(_ts-_of)/2 _pv=(_pv-w)/2 _hb=_hb*2
end
return r
end
_vj = _vj or 33528
local function _yf()
local _eu = string.byte(_sc, _ic)
_ic = _ic + 1
_vj = (_vj * 3877 + 57075) % 65521
local _fg = _vj % 256
local v = _eu - _fg
if v < 0 then v = v + 256 end
return v
end
local function _jh()
local n, _gl = 0, 1
while true do
local _eu = _yf()
n = n + (_eu % 128) * _gl
if _eu < 128 then break end
_gl = _gl * 128
end
return n
end
local function _ui()
local n = _jh()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _fk()
local _hb = {}
_hb.f4t3bv = _jh()
_hb.f12jpy = (_yf() == 1)
_hb.f8ie8j = _jh()
local _js = _jh()
_hb.f9wrea = {}
for _wz = 1, _js do
local f2xuh4 = (_yf() == 1)
_hb.f9wrea[_wz] = { f2xuh4 = f2xuh4, f4mqac = _jh() }
end
local _co = _jh()
_hb.k = {}
for _wz = 1, _co do
local _xl = _yf()
if _xl == 0 then _hb.k[_wz] = nil
elseif _xl == 1 then _hb.k[_wz] = false
elseif _xl == 2 then _hb.k[_wz] = true
elseif _xl == 5 then
_hb.k[_wz] = _ui()
elseif _xl == 3 or _xl == 4 then
local _vu = _jh()
local _mz = {}
local m = 107
for j = 1, _vu do
_mz[j] = string.char(KMVX8(_yf(), m))
m = (m * 75 + 90) % 256
end
if _xl == 3 then _hb.k[_wz] = tonumber(table.concat(_mz)) else _hb.k[_wz] = table.concat(_mz) end
else
_hb.k[_wz] = nil
end
end
local _rm = _jh()
local _fv, _ut = _jh(), _jh()
_hb.f77kju = {}
if _rm > 0 then
local _qw = {}
for _wz = 1, _rm do
_qw[_wz * 4 - 3] = _jh()
_qw[_wz * 4 - 2] = _ui()
_qw[_wz * 4 - 1] = _ui()
_qw[_wz * 4] = _ui()
end
local _qh = {}
for _wz = 0, _rm - 1 do _qh[((_wz * _fv) + _ut) % _rm] = _wz end
for _wz = 1, _rm do
local _xa = _qh[_wz - 1] + 1
local q = _wz * 4
local _cz = _xa * 4
_hb.f77kju[_cz - 3] = _qw[q - 3]
_hb.f77kju[_cz - 2] = _qw[q - 2]
_hb.f77kju[_cz - 1] = _qw[q - 1]
_hb.f77kju[_cz] = _qw[q]
end
end
local _mo = _jh()
_hb.f2j3cz = {}
for _wz = 1, _mo do _hb.f2j3cz[_wz] = _fk() end
return _hb
end
local _na = _fk()
return _na, _ic, _vj
end
local _b5={
"ewkJnWQ30H88pLuOJJs5Sb-iQaQ4gOTF1vpF0oU5nmelTn1nwMrzJwchmzlIoF308Rnnxqmp1bq2fPfxkNlRBTsKMcaS2g8F-mHZ83LPUSu2_dGjx4Feb_WrkNLMlVU1w5GLxbam-YQ9L1ZwBQn6JOi5--eIGTK5VE2uA2wd-h0xQgOGwEl7XW4-_BYoD3IOcnLb3QcfWaht27XkR-oB78mfEHDyVo5NfT-VdKugsIyEWUpnyEhE9rWxXx0SsduDO-uezQq9Gb-RiNvKWxUVljOvSQq4XqIjVbzEkHBm4uQ4JOn-irlwJn6VbvK85kZQaljnNjnVuncxUJ6MsusRCygoKsRkHe8em8P3dtBHs9cRi2K7vFwH0f-weJmHfKWe7LyJSjtKZOlIVIWY8PA6_aVI1fw2x1PCQc2M_1dE5Fir2CaX-I8JEnsI9davcj0EaNgrf1boLqt1PSOzswr-PvbUDX7HR_eLS7b0I7tO1VQtBi1FfOWQENM8hJtgs_QbLU7UW3xAFQDwXbecqPeTFmsTxGV1XrvYrlKE5vxMDdSRsuA8rJkWA5DNPxDbE3d28U6F_dpeMbBJYtaSpqsv8ToWHQFbiL7NR4E0G9IWp5FrxRnIRapvkIa_8v-camq5nJ5rHUhXiVBw3Cd6Cy4ZjlzAp2y288j_P-CsRqzf-v0a0YI7YNoZlRbB2K7O4z5w4qgjVmDLghIYCKt-zTybdTVg450cTCh3WCNp59xnLTGLIk7VhZDCXhOl3g2HdZUkuk6JuX37ntIW6_f8TZ6K8S7DzfeYV5hXFF33TTIBgu5QIIEGp49JsAh9YEo2va7ycjCRvcEtKjhmzQd88oSQgKQPqO8FtgtLp4FpO3jNBk-sVQ_taqPvSNP3T_fiW0gLfjoo0ny9knsT43lsnmBxQSRt5wx1hRXhVsPyDHXyqJ43ARJ-EWA3A16LDZvLJtEObkMmg8nlEnaVeDho3Ab6R51ZTwt8iv6s_pPz_FmJH_YyNUtkO4KCwmiooAtH-TYFbdrQ0cXaYi60GN4hk1wPmFlRHfNyyPKA3gQk4UJ4CyAIVyc0fwNgVHuBSIA0NzTDnrBBNFvFxCVp_npRcx642rY6wX4EyJoZt7FPw4XHt6lf6W-MVE7ciroTP5FYbgLLJgrbbZDbbvttBpzJTGg8HoKyH9zSVZvZIi9jWl5RLrAr-CYOCHoEsMptbTjw96w8qSw-38DgtezmXtZXqsRCYDV_kS7MtpXgU5wJjwsDFv_aGhAkKg9VP-qNLPVVwZHseHugakZTfCiPn58PlE8swNV3yABhDkUnIeDb0PsNUWrgafo0ecE__SFWfZqk7UhWTFpPMrn_4oG0vuop77fbZdMS7H22amfTI3zCCBzIGnALOH10Ca2iKPgfFu831gmWruSkXBVhto5BYGC8Fk-qUJHhhfbadFXogeKmlb_f-_BvWkIR6rQRcOmgRxcRlATI-6hCopLyXaNhW7KrQ00lapzoG9VxA5XLa70PSOwO6s_rVmkb_EvBb-h0xyihqTWsunZPrBAhAae_IMIrBmAcSmqjD6T0p97FrFbpuzZ-K6ZHw-wRnPMWsmyVBCnFjXNepNmYw8bPWKW1szea7DLvCAIM6wTDkR7weimB_xLMu7_U2zRnWnEk2OPw9xsuiif5Yr8zKB0pm1Blhb-HSPsQLm-ia-lxQlhUdFoIrHkWr9-QMgBJmAk5XW7Yt-CDKeCpcoqHE2-dVi1kjQUddmlwSa46o4XCw4TWDS8114UqETXnMEeCFebPbmRXqp1p70r5TpbMqgHiHzRgXx-YsGPAGrwWflgV-Gab1tj_7seIJRhp3Pc06Znc30YTLRjJVQlWjaQOe8hsHJevzXxzrftxdoHsc3M0p2am76wrakd_-TMD3P3D4Tk9b7_xwI-HuNJARURy2MKl-VkTQ9ZdVptVrfjDsweuznH7HXrKpWGwxFqAQKwWa_oQ_M5Wul5sV_WNbbRuXak9j0XDRzWEMEVGYV5gCMVwhEE-xE2bZbBjCt4MvKks6KLw1soEspf0N18xIvQFwcxA1qyeeLtjc3AHzAyOZ-9eNx0DL0UMbMohQli2ywX2z8x3jEEk6CTH2mTdAg4T3e1yyrB8nfM2bdLZbEzNLFk7QyV9xB20Of0qc88QMcXmzVQJPa_pqZ_Z0DiV8OCjgwYzIwuo-z397qeWCiaAKAxavMa7q5qVYV4RvZm7pIVgAJ02mJbUsD_q4ghmc5qUqRk7vtjf2Pd-i9J20N2EftjhZNe8zM64wTadLCsHSxYYRfncQPTiUpu_itESf0ZQWOR8KmGhiE99SGDQo052NPYf6W0l0k3wsZEyhsRcg-3Hz2vgT5dN_tdSiRMj5C6PHFy-8TMPVC3xTZKnBhzfY-ELenGITV7QP1g1fQfOL3glaklR03ohuWzfNyNYVGYKIDeOPuO77kY_H_1vkynaq3jEUHsmKe_u_n-cXT7IwZ-6vdrADDPNhRvtIA-s7twppqz9MfQNUhSsUxFGVFdeWSbXOmk3VPM1ZjJh6DoHc-y7gphM_ibJtuj9YdiexFSGVrt18KGz6KZ2iQCLTsOvmXGA3eXSG0ElDWQdKJlPWuOkblPi5LWO-bW9UleuOAXACgywNdEJ59xIk9k9dy-8Q_inZRLAgffGLL2-KUuzVJI27xJqz5Oo3AiOm7uft8Dx_ChKTgh9G9Q7yZWQOXzN9BbdpqLIkKFoQESjCfWM4nq3TAQQYUYKH4_gScm57Hj4VTWcwGPVUuftwRGNtGgTvUz97CWUA5yy95hbkyzfzrrL_08j_S8Bd0eR4n1tcZBol8FLlBetCewcdyqL_Cpq2EeaSSObBEfXe01zWozD1Y9Ajt-l-tqx13EkKt1_wMnLH0lLnBwhtsjhaAWXqWLCVJzHhDvJFp0DlMFjlXhPe1tmU7N_FHzufCu1FJwAh7StIXW0bQIdvQnW8eEH8bEh4ZNFcokpGZjeuXxhPk3KNX8JX3e076Mh44eMqSrUDiuGWYycHmFbT2DfqQZmynovbZTn17p3q5zeAMm3w0ErWDLYokOJD6keH6g7JN1_gk6hAhz4tC19qTIfEsdw4sPBFiwQLgOAbfeuG05lqLyyzlnT-BPZ_5CeazxU3D5B4r3caCQonEM41Ikt7GDfHBfgWK7DB1jCOTG1HMsMd1GXKm-epWW8vQkeyE7Bci6uDbGxx-i6N5_oFp85X3QKEfjG_bZQ1ibm9S6PsJtYASai3tORzTFcjpqfjROn9PtXmiwLEEwyx3mQdzFAdol74sVqlIcrRZCru2VguS5MqTJZB1iPy6NxLmt1VFJmvEiu0_yC4jNYE2oBVVfnkAbzmLEPYH0g2TYehx23asRXRXgLv42ovSxfphvRDq84sqO5F-h-fE0nPM4xGojzJXVAGQrLMHaYFBhvRBnnu8jsz9V6t84-GqpMiPA6RUHOwzLunJ16NYro5ZcbOCG8K1SZVNCAKfQOVJsyajy5Sr4WhDyFcVIsQnx_WrK6xrDhuFpuQ43QPuUi_lc1lIMr2ypg6XehBPrL4yisg0zSKXgnSGAnS6RW5nfcN-N9kX63mynhnNw-v9kWWfslmowbG2G-qTDRlsh4WuDSnWyHTkIt2MUFX7rWzW-WFidDSaXFUZxJu5GuiDVBrNtpKw5j-90GIxKJ4w9NZlHEBfJfYWwz9Wm4mWJia4aKtJjXYtvsiy7ow5oeje_ejxXQp4591drosTTpMjDwTqN8vT-SSAV61qP0pkBYY0aY6ij0M0r-BctgGCT9bwojDIWu2P2ngwg_s0_KWO_0wOBKR2uvM8WmHs1CBFtJh_8X6BYi1_pIeEl8gpycHyY3uL2u5PCwpqR3t0dS2kuknck5TrPhdThElIsgY_MyK5IwfvZfjju1GKZLwCm4mk1FVwn98bl1s4_mQEVWtG_UENAnr1dxPvBkiQDQjfk1JyqZr2dXq3oRtsYKUSclneC_Du6Lv6dhDVvwDgqNGpPoSEPyYuhO33AV_-grfqfRncO9HYC_Smr5cDWpI6q5JqM5Q0WoZ86iiNrMEgBBVtnVglD3yF83ytdV3rrFgETi9AW2omNbH0fPr0H-biZv5_cig_BsbInF6VZLa-3d2MDMTK13YjdJ6ZevB5NGh6ZM36u7W9aHsKgzWWCS3LUZsxOUzkgbgIB_etxvup2WpwU82rJ-kGzbwbbSEpg5471X6mwB7DDsJX3pc6aL0709asXYKmuyBwYGPHoPtSCyIO4Uxb4uYes628PBKCSw-wfpj6diQpmhXVyAlqjsQi1asoq7Xudqqxtrscz_8fYlz8SmigmRfQaPEwU3kJsi_2B7GEK4fLaL-VREiH8p99bAgcDc3kJ3Je-_OkOJA5EdtjRQ5MDVZjbccY_aB4tlBsx9aA10hxLGR38IXeWoWSNnAfExga6yxVl1Vf6gRA9V2UDyfyMzxgIKfDYKdR93MyrC9vzDGJo_pPvWlCDqCPQcnJSEx0u3Rw3o5GXUZEtE_NoK2bs3pOaMMtNwpOBiXJkoOspLArref7BQG2vihVSO38t5zaSwM8E_XLedkU8xw_7aWMzCjbbAvNo5u_ISoEZSN_moyo5rx-EpiqWHbriLCH5sy7ahzQA-gflBuAUy00TIpSDb4sj6E7-i-SyF5qPnzBrfk7a7SQbfzh32kJKiiNf1MpGu2NkJaqb1L-6tAZkAQiCAogMNrEV-Tnp8ZtkqN2uWxsDlzLQqPCv4j3kAP8uMcwiYDbmhn6kojUqAoPCEW7qS7Ah5LJm-6OQQcaen6WeToKBPhDfe1Muj6bNzk2rcQQe047JP-T4-PJFH9sThqGLbhn6lE2AF7aeiYsk5OsS1Hw66Bv1carWbNSgYKTWIaNlpvz5aPM_d_drAlmAPUKpbvMecY3_ZG-UvqDTE5aI2QV2MBj2l2vuMkd1JDRjD_IazSiRYdrmVlPM5mmhV0LwczHuog9D0DvhJkQtWljaCKS3LdBAMcxk3D1gNv1FoTr2k58NWkQ6IwzxbYlkSLILRsBNj-8TZBCCpN0y6l7SclBy-JLsMxw8wRhETwSObKKvB3YrTAZvcxix--fMcNW9Sh0bSDE7uNBr1bQdtIA-wLl7cT7MWr-26TSqLLaLOt-STnR0v6K_Ks4j5XJ8AWux50k2ID52v8eQB_butubk88SV8dZzbqQX59bpOq_T-g5WaGgOSHBjNm5qciF8j51_lj-qSi5GOu5e8SsuRPz31K8rq6kRBvWd8rRIdFMx5NMJk4AT6ptCtsWHhHDMs5mQB57HuPQdp3CqbLkuRxomv4-1zuEJR1yiiJ7C3AMTAl8xZRAQInczBztqsUsL7GKdmUNoE99bCtJKjH7D_5B-y8X2ZTmGns15FG6RTGfDo3Ha636WvCH0VIuYVVGEDc-MBEmSVt6k7Xoydf1zD2rXp_KeKDK6oADzOx6g6ChyyUHua5vZGdYik7XVlBjRL3uNQsAsYVcMReKeqJoEF8CyoIlVmJr3XRDeEIpc4Ry_YoM9WcG2wjiR1fVj92AreXaQu5ghDSUWVaxiKzonBhbFtvYlar8Hr6Eg1lMxuuZSeBeb8g_VUSJCxLEksXYLrBiAEieeOfINvvCPRTYRS1IvFTQ-7GxdLj-3VCv-i_3-OZhZ0uRS1Q20MfetjzmdGmD4a8wj-w8chNPGqglLB1hJrixfaZeLMsgwEsUhen6QrMCCOjImAl6y1EJolwKDPTUz_OH4u87K-OgOF9eXChz7GlluAgBvLGQ0qUyCQ8brHEC_JDWBVdKKeDXZJJbWXKIUwxZEUk8H1c3aY0jzMXqb5eHpYn3UD4t4j9TnDZZoXZLmQnA_GJPPdoWdEPjg_K-bcPrp0txuoHg3DRL0--qKth2gzfpXiPDc7x09wIqSGRCj28aJl5YGlh08KyZJnU4Txs8p_b5_K1raeZUMK-mQCwOylTZAqip7b9urCH4ARRqG7P0qggumPBanoBcmSxoXk64a9D0yJDf2DFA8T9q0XxiDiEbMQzEAq2yihEZN8iUdjzgQe6m_u-co9N1-MzbQofbrkA1UMOwd0tJvrZwkfCV5ChLMk6MAFan91P5Egltp4rTtAICwULnT_vM6IHM1cPfpYciLHaiTbuZH62v4aFoX3qZ3xi4-YQxSzbALsqPBwIVnAr3QzwjlWBrisJ3Q0zpVqGuXxmP4d2Dp2wjPPRAkseMRpCgXSH_efGC6Fd-AIlZHUJNgrKxp1g_jco5DSE0Dkp_T-HGVRNUQno6kTQlg6hJOB0GIK8mWtahN7hE3ZbvWcP-G-t2nSHMo_gPdJ5w30ggYuV1RyDED_bcz5t_LH76_-WweMUosjy3hkrEEyOiRnCcVNTQMWiCt2AL_K8Rjws6obT8ElKLFbXg_jZKvuj_5Bj2tCYfNfxh3eyJUoAcG6tfg6Q6hj1ALMAWEchlZ0sc_g8yvznD6q5hE725pIGeBb7H6LHh6vJAo8ou43qwNKZheAf5if842xYEh541rZ09oG35q0Y27yuhQ0EKFkfHyQxhIjPaANX3zNKGGjZsFodfaAgWTp4Ha9LF0374f3h0zSUv8poQeov4J3S3ZehYPBNfomeJ2GgOeLj2u5Hycmnz_YNvzLMQtm8hP-oMvOna-yh94Ax772hWtz3_nlhoDWNnrBs11B4dTkyd7oVBZXGECUXFGfwBKuBDEYOdkJZHn74OxbO1DZUAZCMXjymwVbQQEsxtLl4Zzl-Tgx6BqeDvCXzDRypcE_DRJ-KnGRohpGOXr--eG2PSSPKitBFqP62b48Dot_vawg_FTyTWX1opce0Wt4k24eQueGw16hPN9iEvdgQL8MRCws0v975sRwb4ZKvafIKvjqF9uYUNh_mfAlJK0hgwUwi7L3h3DGyQM7qAAip9EJwwF1hxSbS1h0-eaKU2Z2o418swGReHj-ZGr2N3Uz7Y-DJ4ij_fWmxxLLEs-Q7oV5p8YmD_iWk19EonsO74AwA873Qzo27Z9ISITAOBBCH35W-avgQ6Ve0F2V80PuKcJE8u_2nE4FN85X0tQ3Ff-SPnLufnFJI8md_Ozw2OegwdWj9WYynh3GDbcoA8zdIc9dygEBfs4i-b-GhtlyjUWSwdQklHOurirnQlSJt3HMtufErwUc32fB_kldrpRqctEKOEtRcOv90tW2DwReQjSU8VK-Wp5CWmZGLrDr-YOyQb7SzNtXa34LqSaY35IhR1WMmYqOQFaCJCCL-CdJX3b06CvdBgUBaPwQbglvBVdSYFmHq23DYQjnd0hbre6qT_GZ32UwMKhHPsixHHL3yzGpimVpfTluqA7ezZ84681UgJG0Qr7ghi9OxPJnfX_ZZIjsQH9Xbm0r7fQ5R7mysh7t2_zISeDHTSrJUSU0UWso8U4fDAPewdIMI6WFSYJbGMvozGKeJnR0BbC4rU9FIG1jrZ5nKEgu1wxVIF6c-MZKlWLVPRGCB29IKwxIvTjRhPoD87aQznCEOGbjEHhBIUFfBgeRYE5mqtmlWcVsn-sjM2BYuC_9Sc1eVzZICcpCwiDxwnntiGS6k-hzgtrtP7AjIb1tguXDRFswOHkES7QtNsJ15Fw6T1Pq21_f_1uUmLwua_C-74LsT-lTmNDS5aXf8SNZY9H2HGDJzC4PnR9YaCvJ8Mh-1WCOJzGf2k-o4cU6e-hKxxgzasBvB-SEbCSvGK_DbnekNHpyWqe5mDG_kROlkbdmD0G1n7-osyUpX6NlqAPr9m6g7aYJWZOkHte45UFwQv-ZjW",
}
local _f={1}
local _73c={} for i=1,#_f do _73c[i]=_b5[_f[i]] end
local _4bf,_2d4e=_87(_d8dc(table.concat(_73c)))
if _2d4e~=2630710825 then error(string.char(49,56,55,53),0) end
local _db=(getfenv and getfenv(0)) or _G
if type(_db)~="table" then _db=_G end
local _3dc,_6d7c,_67f=_qa(_4bf)
local _caa9=_fz(_3dc,_db)
return _caa9
end)()
end)()
if type(_ddb334) ~= "table" or type(_ddb334[1]) ~= "function" or type(_ddb334[2]) ~= "function" then
  _4efb7b("Protection unavailable")
  return
end
local _a22b55={}
for i=0,255 do _a22b55[i]=string.char(i) end
local _3ef2b7,_4f2aee={},{}
do
  local ta="e286cb6d1e3863ecb129adea9801fc25725723c9652b11284341024cbf5fe81248ba00e1c5308f9dfb68ffd9b8183391a6a12ebbf65661f220c7abb0758d4fd13639e0a47827a3e4b29e3474acf8c373bd05d0da51f05269b45c64591b3adc4a15be1ff78162426f06c1600fa57e1c95dd7949c4b60b6b84a9c613fa4771320cfd3b22d3769af55410a785d4e3263fccafc28744d6e99f3eb51670fecaa2358b7f80b94d09147a9c0e946a55dbbce5ae6c3c8c1d4beb31e621d74e8207ef9297eeaa406e7d90edd22fd545c8040d2aa81a46b3f15e5324832df3678896f9a07766cd035af47bb7ce089b99e7197c37172c5d8e580a3d50d88993dfde8ac0cf5b"
  local tb="d69880b646a523106e7e2afe0b5af4bce9d755eb373c48ac85790af344256b9dc5bfe238789714af74cf2b43be064e4fb5de70b9dc9cbdfc695dea8a8ff51cb481605bb0fb66ed5354206f90d07c5076ee084d6a57ad1b4ba4a6fde8d2611f1858dfdb2cc407d9714a940db85ff8173aa8a762270cc7d88ce66524f68b3d9f0e3fe40fba9664fa93f0a1a2c09e6c345ec6d4f7e121cb429b2d99326828455cc3d17d77ccaeec040919b3472f1a8739521dc859ca26737b318456bb2e92e3406372a0ab91951529dd83c182168eb286aac20336a9da013e4130d37a054ce5ff6d113b35f933d5228951ce00b712b1f2e70213efe0889acd7f49a367f1c91e8d75"
  for i=1,256 do
    _3ef2b7[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _4f2aee[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _b52713={}
do
  local a="hz94kEAnJqlYug1s_f5vyHRwrj8pMoTD" .. "2aQ6GVbLUcXCxFe30OdtP7KIWimB-SZN"
  for i=1,#a do _b52713[string.byte(a,i)]=i-1 end
end
local function _96c96d(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_b52713[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_a22b55[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _fcda6b(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _bb3243(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _cc96e0(S)
  local sa,pa=2001283368,158
  local sb,pb=1050152828,212
  local MA,AA,LA=25655,188301401,14238545
  local MB,AB,LB=773873,798394455,540036
  local KA={92,69,217,35,220,45,166,147,249,194,104,173,71,31,235,221,224,164,192,46,37,47,151,49,200,24,13,155,202,8,40,114}
  local KB={42,248,221,109,171,51,189,171,70,110,255,16,12,187,104,64,79,200,186,200,118,79,132,255,98,93,78,235,40,78,96,11}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_4f2aee[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_3ef2b7[mid]-ksa)%256
    n=n+1
    out[n]=_a22b55[p]
  end
  return table.concat(out)
end
local _6fac9d
do
  local np = 7
  local base = ("https://kin".."gmor.up.railway.app/api/loader/e606cddc1191cf.lua?pack=1&part=") .. "@@PARTNUM@@" .. "&dtok=" .. "eyJzIjoiZTYwNmNkZGMxMTkxY2YiLCJzZCI6IjYxYzI0OGNmNTAzYiIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MzExNjAxOTA0NH0.2CAUBHVWEg4kjjRyw25GT_K1YzMdCGTadLCNonkd4jA"
  local single = ("https://kin".."gmor.up.railway.app/api/loader/e606cddc1191cf.lua?single=1&dtok=eyJzIjoiZTYwNmNkZGMxMTkxY2YiLCJzZCI6IjYxYzI0OGNmNTAzYiIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MzExNjAxOTA0NH0.2CAUBHVWEg4kjjRyw25GT_K1YzMdCGTadLCNonkd4jA")
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _fcda6b(hx)
    local body = string.sub(res, 9)
    if (_bb3243(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function runMsg(res)
    if type(res) ~= "string" or #res < 10 then return end
    if string.find(res, "Kick", 1, true) == nil then return end
    if _bb2ad5 then pcall(function() local f = _bb2ad5(res) if type(f) == "function" then f() end end) end
  end
  local function fetchAll()
    if _bb2ad5 == nil then return nil, "no loader" end
    local res, err = _a3c221(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_bb3243(body) % 4294967296) ~= _fcda6b("1325442a") then
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
      local res, err = _a3c221(string.gsub(base, "@@PARTNUM@@", tostring(i)))
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
    _6fac9d = got
  else
    -- 2) fallback: whole payload in a single request
    local all, why = fetchAll()
    if all == nil then
      _4efb7b("Download failed part " .. missing)
      return
    end
    _6fac9d = all
  end
end
local ok, plain, why = (function()
  local sh = _6fac9d
  if type(sh) ~= "table" then return false, nil, "no payload" end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _6fac9d = nil
  if #joined == 0 then return false, nil, "empty payload" end
  local expect = _fcda6b("1325442a")
  if expect ~= nil and (_bb3243(joined) % 4294967296) ~= expect then
    return false, nil, "payload checksum mismatch"
  end
  local raw = _96c96d(joined)
  joined = nil
  local out = (_cc96e0)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, "decrypt failed" end
  local ph = _fcda6b("f0b33e9e")
  if ph ~= nil and (_bb3243(out) % 4294967296) ~= ph then
    return false, nil, "integrity mismatch"
  end
  return true, out, nil
end)()
if not ok then
  _4efb7b("Payload error: " .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = "e606cddc1191cf", scriptId = "e606cddc1191cf", t = 0}
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
local fn, cerr = _ddb334[1](_bb2ad5, plain)
plain = nil
if type(fn) ~= "function" then
  warn(("[Kin".."gmor] compile: ") .. tostring(cerr))
  _4efb7b("Script compile error")
  return
end
local rok, runErr = _ddb334[2](fn, true)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(("[Kin".."gmor] runtime: ") .. tostring(runErr)) end
