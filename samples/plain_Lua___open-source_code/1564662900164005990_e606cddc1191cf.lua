local _006c1c
local function _898d13(msg)
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
  _898d13("Set script_key before running the loader")
  return
end
uk = string.lower((tostring(uk):gsub("^%s+", ""):gsub("%s+$", "")))
local _7d5dff
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
  _7d5dff = function(url)
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
    body, err = _7d5dff(url)
    if type(body) == "string" and #body > 0 then break end
    nap(0.4 * attempt)
  end
  if type(body) ~= "string" or #body == 0 then
    _898d13("HWID Check Failed (network: " .. tostring(err) .. ")")
    return
  end
  local data = nil
  pcall(function() data = game:GetService("HttpService"):JSONDecode(body) end)
  if type(data) ~= "table" or not data.valid then
    local reason = (type(data) == "table" and data.reason) or "Invalid Key"
    _898d13(tostring(reason))
    return
  end
end
local _bda908
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
      if type(f) == "function" then _bda908 = f break end
    end
  end
end
_006c1c=(function()
return (function()
local _0={}
for _zw0=0,255 do _0[_zw0]=string.char(_zw0) end
local _e3d={}
do
  local _fy3="9_6CxV20zDN1yP-dFSst7AMRvhLYBIacZo4jqTQlm3HGgwEb8ikUrepOXWK5Jnuf"
  for _zw0=1,#_fy3 do _e3d[string.byte(_fy3,_zw0)]=_zw0-1 end
end
local function _868(s)
  local _mx8,_5mb,_zx1,_f8q={},0,0,0
  for _zw0=1,#s do
    local _ppx=_e3d[string.byte(s,_zw0)]
    if _ppx then
      _zx1=_zx1*64+_ppx
      _f8q=_f8q+6
      if _f8q>=8 then
        _f8q=_f8q-8
        local _fho=2^_f8q
        _5mb=_5mb+1
        _mx8[_5mb]=_0[math.floor(_zx1/_fho)%256]
        _zx1=_zx1%_fho
      end
    end
  end
  return table.concat(_mx8)
end
local _85fd={}
do
  local _ma2="\134\006\1467e\1866\152\132\023\028j?\180]#\017X\172\175\236\240\130\005\144%\029\243\133\193\242\203\004v\178\171t\232uo\238\128\219\174\214\182qO\207.\020\\\169\234=w@pY\221\195\231N\210\188i\156\027!\012}\224KV\225U\233\199Z,\003`\167\019J\143\218y\223z\011\184\247\018\176\198\007\163S\251;\216\021(\r\142\001P\1944T9\245\211QaB\024\197\248\227\145>\246<r\254\141m\025\249^8\137\147\241\026\181\237\205f5\157\168\208h\209E \153\230D\220\244\213\212b)R\148g\022L\200\228\202l/\000:\030\196\136\201|\229\151\009\149\159\204\191\164G$\177W\165*\189\2150x\158\166\185'\179\252\0082\129F1\150\226\206\170\031\192&_\160Mk3\154\217\187\235\140\253\255\155\002\183\138s-+\135A[\015\239I\131~\161\n\"\016\014H\162\173d\190\222\127cn{\250C\139"
  for _zw0=1,256 do _85fd[string.byte(_ma2,_zw0)]=_zw0-1 end
end
local function _43(S)
  local _3rk,_1u1=1680643064,237
  local _mx8,_5mb,_bto={},0,0
  local P=894249 A=-1332290949 L=11635629
  local K={239,147,59,36,217,146,113,89,168,206,92,90,91,216,97,172,53,244,146,148,65,135,169,87,174,243,201,4,5,89,56,81}
  for _zw0=1,#S do
    _3rk=(P*_3rk+A)%4294967296
    local _2nd=string.byte(S,_zw0)
    local _nms=(_3rk%256+K[((_zw0-1)%32)+1]+((_zw0*113+L)%256)+_1u1)%256
    _1u1=_2nd
    local _xnm=(_85fd[_2nd]-_nms)%256
    _bto=(_bto*33+_xnm)%4294967296
    _5mb=_5mb+1
    _mx8[_5mb]=_0[_xnm]
  end
  return table.concat(_mx8),_bto
end
local function _eq(_yx, _jz)
local _at = table.unpack or unpack
local function _lu(...) return { n = select('#', ...), ... } end
local _wv
_wv = function(_gs, _re, _sy)
local f46tpx, _ex, f4i550 = _gs.f46tpx, _gs.k, _gs.f4i550
local _ob = {}
local _xh = _gs.f55iri
for _vq = 1, _xh do _ob[_vq] = _re[_vq] end
local _ox, _zy = {}, 0
if _gs.f16q8w then
local _gh = _re.n or #_re
for _vq = _xh + 1, _gh do _zy = _zy + 1; _ox[_zy] = _re[_vq] end
end
local _ka = _gs.f7en5c + 8
local _vb = 1
while true do
local _gd = f46tpx[_vb]
local _sj = f46tpx[_vb + 1]
if _gd == 22 then
_ob[_sj] = _ob[f46tpx[_vb + 2]]
_vb = _vb + 4
elseif _gd == 36 then
_ob[_sj] = _ex[f46tpx[_vb + 2]]
_vb = _vb + 4
elseif _gd == 14 then
_ob[_sj] = _jz[_ex[f46tpx[_vb + 2]]]
_vb = _vb + 4
elseif _gd == 7 then
local _dl = f46tpx[_vb + 2]
local _cv = _ob[_dl]
if _dl >= 256 then _cv = _ex[_dl - 256] end
local _om = f46tpx[_vb + 3]
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
_ob[_sj] = _cv[_om]
_vb = _vb + 4
elseif _gd == 25 then
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
local _kp = _ob[_sj]
local n = (_dl == 0) and (_ka - _sj) or (_dl - 1)
if _om == 2 then
if n == 0 then _ob[_sj] = _kp()
elseif n == 1 then _ob[_sj] = _kp(_ob[_sj + 1])
elseif n == 2 then _ob[_sj] = _kp(_ob[_sj + 1], _ob[_sj + 2])
elseif n == 3 then _ob[_sj] = _kp(_ob[_sj + 1], _ob[_sj + 2], _ob[_sj + 3])
else
local _cv = {}
for _vq = 1, n do _cv[_vq] = _ob[_sj + _vq] end
_ob[_sj] = _kp(_at(_cv, 1, n))
end
elseif _om == 1 then
if n == 0 then _kp()
elseif n == 1 then _kp(_ob[_sj + 1])
elseif n == 2 then _kp(_ob[_sj + 1], _ob[_sj + 2])
elseif n == 3 then _kp(_ob[_sj + 1], _ob[_sj + 2], _ob[_sj + 3])
else
local _cv = {}
for _vq = 1, n do _cv[_vq] = _ob[_sj + _vq] end
_kp(_at(_cv, 1, n))
end
else
local _nh
if n == 0 then _nh = _lu(_kp())
elseif n == 1 then _nh = _lu(_kp(_ob[_sj + 1]))
elseif n == 2 then _nh = _lu(_kp(_ob[_sj + 1], _ob[_sj + 2]))
elseif n == 3 then _nh = _lu(_kp(_ob[_sj + 1], _ob[_sj + 2], _ob[_sj + 3]))
elseif n == 4 then _nh = _lu(_kp(_ob[_sj + 1], _ob[_sj + 2], _ob[_sj + 3], _ob[_sj + 4]))
else
local _cv = {}
for _vq = 1, n do _cv[_vq] = _ob[_sj + _vq] end
_nh = _lu(_kp(_at(_cv, 1, n)))
end
if _om == 0 then
local _jk = _nh.n
for _vq = 1, _jk do _ob[_sj + _vq - 1] = _nh[_vq] end
if _jk == 0 then _ob[_sj] = nil end
_ka = _sj + _jk - 1
else
local _yi = _om - 1
for _vq = 1, _yi do _ob[_sj + _vq - 1] = _nh[_vq] end
end
end
_vb = _vb + 4
elseif _gd == 39 then
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
_ob[_sj] = _dl + _om
_vb = _vb + 4
elseif _gd == 3 then
if _ob[_sj] then _vb = _vb + 4 else _vb = _vb + f46tpx[_vb + 2] * 4 end
elseif _gd == 4 then
_vb = _vb + _sj * 4
elseif _gd == 29 then
local _cv = _ob[_sj]
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
_cv[_dl] = _om
_vb = _vb + 4
elseif _gd == 16 then
_ob[_sj] = f46tpx[_vb + 2]
_vb = _vb + 4
elseif _gd == 13 then
if _ob[_sj] then _vb = _vb + f46tpx[_vb + 2] * 4 else _vb = _vb + 4 end
elseif _gd == 37 then
local _dl = f46tpx[_vb + 2]
if _dl == 0 then
local n = _ka - _sj + 1
if n <= 0 then return end
local _cv = {}
for _vq = 1, n do _cv[_vq] = _ob[_sj + _vq - 1] end
return _at(_cv, 1, n)
end
local n = _dl - 1
if n <= 0 then return end
local _cv = {}
for _vq = 1, n do _cv[_vq] = _ob[_sj + _vq - 1] end
return _at(_cv, 1, n)
elseif _gd == 23 then
local _dl = f46tpx[_vb + 2]
for _vq = _sj, _sj + _dl - 1 do _ob[_vq] = nil end
_vb = _vb + 4
elseif _gd == 35 or _gd == 9 or _gd == 6 or _gd == 19 or _gd == 2 or _gd == 33 then
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
if _gd == 35 then _ob[_sj] = (_dl == _om)
elseif _gd == 9 then _ob[_sj] = (_dl ~= _om)
elseif _gd == 6 then _ob[_sj] = (_dl < _om)
elseif _gd == 19 then _ob[_sj] = (_dl <= _om)
elseif _gd == 2 then _ob[_sj] = (_dl > _om)
else _ob[_sj] = (_dl >= _om) end
_vb = _vb + 4
elseif _gd == 34 or _gd == 17 or _gd == 26 or _gd == 42 or _gd == 10 then
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
if _gd == 34 then _ob[_sj] = _dl - _om
elseif _gd == 17 then _ob[_sj] = _dl * _om
elseif _gd == 26 then _ob[_sj] = _dl / _om
elseif _gd == 42 then _ob[_sj] = _dl % _om
else _ob[_sj] = _dl ^ _om end
_vb = _vb + 4
elseif _gd == 11 then
_ob[_sj] = (f46tpx[_vb + 2] ~= 0)
_vb = _vb + 4
elseif _gd == 20 then
_ob[_sj] = {}
_vb = _vb + 4
elseif _gd == 15 then
local _cv = _ob[_sj]
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
if _dl == 0 then _dl = _ka - _sj end
local _cg = _om - 1
for _vq = 1, _dl do _cv[_cg + _vq] = _ob[_sj + _vq] end
_vb = _vb + 4
elseif _gd == 24 then
local _dl = _ob[f46tpx[_vb + 2]]
local _om = f46tpx[_vb + 3]
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
_ob[_sj] = _dl[_om]
_ob[_sj + 1] = _dl
_vb = _vb + 4
elseif _gd == 5 then
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
local _rt = _ob[_dl]
for _vq = _dl + 1, _om do _rt = _rt .. _ob[_vq] end
_ob[_sj] = _rt
_vb = _vb + 4
elseif _gd == 38 then
local _mr = f4i550[f46tpx[_vb + 2]]
local f511ym = {}
local _qo = _mr.f511ym
for _vq = 1, #_qo do
local _bq = _qo[_vq]
if _bq.f2szgi then f511ym[_vq] = _ob[_bq.f52v3j] else f511ym[_vq] = _sy[_bq.f52v3j] end
end
_ob[_sj] = function(...) return _wv(_mr, _lu(...), f511ym) end
_vb = _vb + 4
elseif _gd == 30 then
local _dl = f46tpx[_vb + 2]
if _dl == 0 then
for _vq = 1, _zy do _ob[_sj + _vq - 1] = _ox[_vq] end
_ka = _sj + _zy - 1
else
local n = _dl - 1
for _vq = 1, n do _ob[_sj + _vq - 1] = _ox[_vq] end
end
_vb = _vb + 4
elseif _gd == 40 then
_ob[_sj] = _sy[f46tpx[_vb + 2]][1]
_vb = _vb + 4
elseif _gd == 12 then
_sy[_sj][1] = _ob[f46tpx[_vb + 2]]
_vb = _vb + 4
elseif _gd == 1 then
_ob[_sj] = {}
_vb = _vb + 4
elseif _gd == 31 then
_ob[_sj] = _ob[f46tpx[_vb + 2]][1]
_vb = _vb + 4
elseif _gd == 28 then
local _cv = _ob[_sj]
_cv[1] = _ob[f46tpx[_vb + 2]]
_vb = _vb + 4
elseif _gd == 32 then
local _cv = _ob[_sj]
local n = #_cv
local _vq = f46tpx[_vb + 2]
while _vq <= _ka do n = n + 1; _cv[n] = _ob[_vq]; _vq = _vq + 1 end
_vb = _vb + 4
elseif _gd == 18 then
_jz[_ex[_sj]] = _ob[f46tpx[_vb + 2]]
_vb = _vb + 4
elseif _gd == 41 then
local _dl = f46tpx[_vb + 2]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
_ob[_sj] = -_dl
_vb = _vb + 4
elseif _gd == 8 then
local _dl = f46tpx[_vb + 2]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
_ob[_sj] = not _dl
_vb = _vb + 4
elseif _gd == 27 then
local _dl = f46tpx[_vb + 2]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
_ob[_sj] = #_dl
_vb = _vb + 4
elseif _gd == 21 then
local _dl, _om = f46tpx[_vb + 2], f46tpx[_vb + 3]
if _dl >= 256 then _dl = _ex[_dl - 256] else _dl = _ob[_dl] end
if _om >= 256 then _om = _ex[_om - 256] else _om = _ob[_om] end
_ob[_sj] = math.floor(_dl / _om)
_vb = _vb + 4
else
error(('E'..tostring(_gd)), 0)
end
end
end
return _wv(_yx, { n = 0 }, {})
end
local function _pr(_rt, _ht, _ua)
_ht = _ht or 1
local function KMVX8(_sj,_om)
_sj=_sj%256 _om=_om%256
local r,_gs=0,1
for _=1,8 do
local _nw,w=_sj%2,_om%2
if _nw~=w then r=r+_gs end
_sj=(_sj-_nw)/2 _om=(_om-w)/2 _gs=_gs*2
end
return r
end
_ua = _ua or 24571
local function _xw()
local _dl = string.byte(_rt, _ht)
_ht = _ht + 1
_ua = (_ua * 3050 + 5631) % 65521
local _ex = _ua % 256
local v = _dl - _ex
if v < 0 then v = v + 256 end
return v
end
local function _iy()
local n, _fc = 0, 1
while true do
local _dl = _xw()
n = n + (_dl % 128) * _fc
if _dl < 128 then break end
_fc = _fc * 128
end
return n
end
local function _tz()
local n = _iy()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _eb()
local _gs = {}
_gs.f55iri = _iy()
_gs.f16q8w = (_xw() == 1)
_gs.f7en5c = _iy()
local _ij = _iy()
_gs.f511ym = {}
for _vq = 1, _ij do
local f2szgi = (_xw() == 1)
_gs.f511ym[_vq] = { f2szgi = f2szgi, f52v3j = _iy() }
end
local _bf = _iy()
_gs.k = {}
for _vq = 1, _bf do
local _wc = _xw()
if _wc == 0 then _gs.k[_vq] = nil
elseif _wc == 1 then _gs.k[_vq] = false
elseif _wc == 2 then _gs.k[_vq] = true
elseif _wc == 5 then
_gs.k[_vq] = _tz()
elseif _wc == 3 or _wc == 4 then
local _ul = _iy()
local _lq = {}
local m = 249
for j = 1, _ul do
_lq[j] = string.char(KMVX8(_xw(), m))
m = (m * 193 + 206) % 256
end
if _wc == 3 then _gs.k[_vq] = tonumber(table.concat(_lq)) else _gs.k[_vq] = table.concat(_lq) end
else
_gs.k[_vq] = nil
end
end
local _qd = _iy()
local _em, _tk = _iy(), _iy()
_gs.f46tpx = {}
if _qd > 0 then
local _pn = {}
for _vq = 1, _qd do
_pn[_vq * 4 - 3] = _iy()
_pn[_vq * 4 - 2] = _tz()
_pn[_vq * 4 - 1] = _tz()
_pn[_vq * 4] = _tz()
end
local _py = {}
for _vq = 0, _qd - 1 do _py[((_vq * _em) + _tk) % _qd] = _vq end
for _vq = 1, _qd do
local _wr = _py[_vq - 1] + 1
local q = _vq * 4
local _bq = _wr * 4
_gs.f46tpx[_bq - 3] = _pn[q - 3]
_gs.f46tpx[_bq - 2] = _pn[q - 2]
_gs.f46tpx[_bq - 1] = _pn[q - 1]
_gs.f46tpx[_bq] = _pn[q]
end
end
local _lf = _iy()
_gs.f4i550 = {}
for _vq = 1, _lf do _gs.f4i550[_vq] = _eb() end
return _gs
end
local _mr = _eb()
return _mr, _ht, _ua
end
local _f87e={
"SagjaXx_z75hriU5OnAKYZUAm0hilWpbLyDu6Zeu-wd8iYoDbtMtY6qeAT2dMgKmeuTmf4970lQHk_TtuAsNjC24yq7srpzVyiz0YmH0oHkCFA4g4-VGzB9xc5cAVu-E0AYWE5bLVehV4IXWGkfDoDb_syVnBIIsQhbCit92bkrAeWY2ANU55janO2HNZf-HD3IrVCjHqkrYPC5NXSD60RP69FH_qhAg-0d2oh8eAHYDRYUI0wh5XBVmv8ppQ_kCc6VXm4XqhUfYe-SAUs700zUhmkjJLhvNGHw7SmJuSHxbDBwLDaxLQBugty8Yy_ibP6FmXou52a4QRTnR1uRrRhURpSvxlZJ7A8rX1rdChS4Hu60ZmK5WGblmdHJTM7A42GKlIaXTTkt4PdJFvYwZfrIt3WfTOAvcJpc1cloRQadzR3JBBMGzT-5jb1xXxjOg1BacgJ4h_2fpMbU9YoR7sTr2ZfGASH-tZHJzmkuAvZ0BkE-013eUHl0zyWwH8Bc52Vb3h6XITQHlmAWcD94F1q2gPpUSY8AhuQ_SXQmwwgA55-q5yYwU0_ovzhmj9MUNzjEyP_D49-dRuCRb35DilST3-ty00GJPTsv9HRVfHX__2HxtsPfC99RjsnzuP9bJK8T6z01IUcIPPQ5b3Xooyfgkj_kMNvOtDXqE6q0_uVXZ8CrRYD_BaBsbWtLHEHvuzhb7bXrYJPxvcBejl3xMagSC2qkzLRB2Ewg-nfiFwFCEHJbIy8qLGFqkVoZLetPYZpHDQPt79F8XsEBt-AGNrBZ1fyTjXEtAo7ZbMhGTEHlknctwzrTa9NDn3vBP-iZZHivslqMJLNlxnRAOBjYfWMKZ4jiffFDwmNIGJRV1ZcClPc20CU7bI04fsYNDHA851xraU37IEODQRypAuEjZYupq7aGjXRurxow7OB35RB0_tmwOIsmSlTUN3wE_-3ockKRtivZ4Ejfjj2C2BXHzv2zC8600EgLVSKTAHVbbmavB4ehXMNPtAxZo4kCzmzwRUmvPkn73zd0R9hXVt6kxRAuCztqnaH-uSzFfaGXGxFoP-HYPS0ZI_egOX3H1EbmpPOxkw0tTz8AdKTX2FgvsPRwI6gy9ySwYiqsfXw3YH3--60NG-nQeWcBqbwobK6bQZSSsbBbTHe1eQrrEjq8BocHOJN989qsI3Bb0y757SYOYfzgxiBbH_LPhAzXlHL9wsK44Cm62YjFJ0a-5t7z9F8UxyyTknZ1cu5zmRdJULH0PQQrX7yEzI2c9ge3x9_Cf1sEZdWye19mqQIbY89ALDousD0rnKgN0taeRgZmlyfL3OrPQiiUAZZHfYR8IFy52c_SyWFFHHZkTG0Pgz0USnQMcpe2tTMamM_dxyujj20G516vbUU04tDthOO_NPWS2YZp5wvzThSKxFpLjaD4_HpLLHEGzwjf23UB6zVmDlCXxdC79kPn9z7xTQndHXtEtHU3r5nkSCS5xWM_BySUnU7T4lNlXIQGJFu7Gm2nbWFWQeU-Nd3hRxHC7n7uDyniKmga85ufyT6plGH9Z8IYycbqy4LVKpPRaiCEzIjm-sdTw94GnGatSCIChymHLgLeYSZZxSb5QGxmLw7xru0DSDJNCQrMhH5x7IQu_09YoGG8mVZ_qwwpbk3o7du34zViVS5ndVYgH3dSZ1RME8hUXb94uCR_xLpdI4Wb88zhvqZ8yRHORthgCGR52wHY_LBJS2hSJfSeNkf4m7deIsD4Guh1L9yoWLKwPuF8MEzAUUc-84M1SGTeIYtGLN1J_RRb4yBfD8MUW7vwYg-pd5Ldcw8qh6EF0SxK0-YiQP7IqX0GhjbtBYoSWOPercA3_MKzpIAz0WTrbyKq3Pnb5QY943mVXY0_B_V3bIjbos4wecnpBXEmocjrnagaWb1J2UjT5iD0OENAvB44b_LwZJ2Kf4Gtke5Borg7U_rr7lC8rbnOiP2lRlWlI4BdkCj8cZdxtDjoxIxjMoYllTFkgzSoeN6kbZjTMXtxaVwdD_qDlLuHrGz9g-UxKIrIH7Cfv-Yaso-NTp21ZZNV-u04X87Q7nrgKDX_vkf94CwhCehn7gkDJvc0dfSl8U5VqBj-wF3aYkZR5ngN2-8eqf0H8euHGp_wv_qSEU6HtM-aqgd1dEJoSRGzX-2pKIw0C0l0Me_wO_3skzdPaYRDVRuNNN7dnjZyEJBhlHxFwP54pRQokDsfTi5pE03rr8v861wNVFoT4k9g5kJlZAJfU46Nok8iAYQPN8N6zhgkKuvaEiCulsUycSUdZX7y61BbHNbCxR-edS55wYHeIgVIWJsRCtyNTILtulsG12pf7sc4O2LyLIUmoWXwWJ7Ky1DDSJLLg6L0NZMrx4zX6dJO8-q5h3uFnuZAhnYOprz0QxBb-5OBfwiecWo12g9vXS0I3hleewcI05JR1KXbSDxdoo5k7LrxekGyHA7zIkUCOSqxyZIUJJrs2_7exxTQo7ALtBQd3iq5m8V5PlcrAlrqHAfaBo1k_HnBwdulcZrstJYJ-ichLRsbhOrSFpgDDxH_UAA85Dth_hCooEFW_KoWRytKNExGNCdeAdK4BvQNeU0FRRPEOYj83o7Gwgb2NNmCxwi2tpIWXm8TaRsNscOJcYiyQ2vWIeRUvOq35M3r07xBTlqrf_w8u6OKNDwNrrnmGivdTc8_zdY_7L97DsM2aDCBhl7iAEZl07pUCsIRJcoB692CP-qPxt7eYlkav9jvKwEi76VvW-gRfsWma5XGgGYARpnVDCybP2z2bfl54I2Ixro6-al3mA7CkejRLe-v-xrWYOhzg3h0RtgREEslPB6dv4EbG4FwZt2sR0ORL4b-tpmDJ4CBliJrMJNX_0gcZmJMB2ICcuEdZfT-flFPOdv6AV0qxTUjQpaxdI_Lh7JPuxhH0PAPik__SQFj3Ii358kc3fGyuDyi0s1VnTb7GW_jnMr_i66BXTDA7BveHZOwvDBXEsT4XrHUS4UZGZtyiCgIpswGJDsDfVDsaeJ2qVH3l851-G40VdqSjsUscfbeNXMNWvrch534i4sO97pvbWUqzDMLd4n8pnm88NMF0Y5xwZ-gSeVzpQicd1OC7C4UiL-qyaFvFmAyB5Bs52WhZdaP8RUQWTa6cEHhhtuBKCCIJLqsj6q2-Js_sRdo7t5P0fWY2aUNBJHvTP5xLupc2wOMX3tpRsH_x7eznPtA7WEiAGZq4Dz9OOFJKPgOKCimerH8ptBHCn7Aj6xoZNHo6uECt0dH4jsEZswOCObXwsIdmU2UV0cl2n3Jd4YcFctVavsR4JhxeT2LjwUP8sDlchFaXCSzecBctu49UFTPDywxbKODSgNwnMJSjl5pj3CNnzfdwO0tPvJTbzrzr4FyKFjiw9v0VH5ymstpfPZhaWHJuOVqXsWVK1sEvjvM07JO6GsjbhL1cqwBpVfUp8LAFYeV5JARiJiPb352xs5gXZ_sLtRjLUu_dE1gFubng4Wz4yKXLX-3bX-JDV9KYsfa64tPMdHJ-VIZEJaR2YJuE_4lHr8vZ_WvXZGLycY1jJmEYGMdlTmoM4Qj9Neolw3csNpjFAPtcHomPE3BPOqG3HkxUATCVc2gs8RTv4KBqVT4a9H3Qgatly6h5qfFcDsBbuFBRFp8mLK7_BbTHFM1HUxnfm97PqRjcONcFT_Xti1phkhkGCRwijoZt_EqtuD_DQAgn55eamKQletWBrH9Xapx4nuSXFbkDiPrILP_N3kfwtJ_tKrOlvnzF30Vjg1owuBec-tZ1iIxtahnd3abuO2ZAH6kuOJNBm_XWHjMvLp9rEKPcJ1iNcdBaYuiKvbYgWIJtaxtQTX1LVRxWNkGmEAWMABP8dNgnTGf9PKK3oUfX_5_LiKK6t0jkfCcYiTtn_M_khwaXSL9xoA7N65jIIZ9hXiPCjHpeWH-S64uFTPtCMyiPppiCRLRrfXC4vSTahF8sIbLI-BAUrCcKbYEnT1wO2LPovoEqSO-UiMg7dyDrU_5ip954Aq4O5Bcj1CqKyYwlFIrgaadjY_xmZbrTEnUQV-yWEcUC1doQF5K2a4jqPJRraDYl2AIdmGoQkFjefk8_BdJRu0t2yYlEMbTD5Ev7PTlhxU1nhwhSODdEIyABHORc365EkYm4BzQ8M43w2jkyJzMHdDS7Wq7pRtsbtWMKIi4RshUw1_ZOaqa8I4MNkv8BAWvqaBA3qiGuHdXv5CVxpOEPB9bGGB1dOYsbtF7m-q258AW7zVmzzPKbMMbLxt_HtNAYFXG4LlH-wk4kFJHPrYpWEIIZNZYpjWEa3wn2UfDf17jL28ub-Okt_gkQYBPMksL3GuBa9fFBQbcDRSZpH_NODBuAbLqNXoMW45oiSC4ylm8JwshRtGS8RssCVZV6Kcsukbp-TX5MmFyv0hUAPOxgc7S6wRzWzZBDm_XLYW32JbsjvUwe0tHms67cT5L0nY9eTYSRhmyz7OVslEhajJTMvtpWaV3m0VgvfrJ-aW2OVNT6Q5hdR00P64zQUsyUtgFM-WsPEBsxYq-GCkpS64VZ1Runn8b968D6Ou4luvV_sHZqIGzI4-rMYXPry-17E72A7MBr92cTaC4wLE2bBZgI9-2CFE3XZ-ryLOj4q63ndy6FZ6t-Im9fTN5xB24IVLZuCPKPGDhEpGYr-sKX185XBfHX-xuWWG3W9aQSamonJj0JjOq0LZVq6xfTtQ2xDwNpwpT3XVKGYME54ltGR982CcB0BosVhLEYGHG68Lm_bPTZILuOilsm-fjYjRTsZHr1hK2tP9-vmGRWk5MWAF-AbP9JAiKKwz7bZ8k64cN58avIWPhaMCgOluejBTlV51T_074bfUpDA91frC_AZN3E6WQSEELDG1FQbMPkew__pdMJaHYD80YTutPcZxg2_LqkddETzGPXOyCbjl_w_IzGFIbVNiaJzS_K02O3d5RUsK4cVLQYcBtvrfZN6UNN78p7oG5ietR1clsG37ZoZN4iediNF7zUJo1zZ86UMhP9TS4P3S33XcbjcypMEevJqvSHpnHn-Ud7HwjUhU9HWM0_BIr_ihxy7yQ_d4Q0_-KaOXcP_RwQ41uJDH08233vtlmmlkQ8pZ0W577CMUibcFDv0Xl5yisBHVhSz69cWX8uO2pOx7UUVJbs_DtJg8jJNLPJr7FaLdL6Es01ALuJtpS3xxzqVsVvhN_2rRkoz7xaBVd_IzI6EKE2v54uhwhkHOf9Ij4Pw0K8FzCo7v1weayrCuR0ukyiN4z-C3VJE-F5zROw-o8wm_zIp02OTz7NdSY_MLZH4cpDDMwwQmSpGskXzpB8XZxGKrBWUpE8o1KRvzhX-V9qt0rFwyhBqzztTu--ObxktGWA_Ief4kSPMMX4gGa_nmTo0_dQBS_Mwsxjlele9ZtAkV3q36ogT9A78RoDP70nMtgcFXh_tKcxhhLdFjt3T5HXrmlhVPMvcE373L5Tl7NM2vCpTxu56CdYbm_R8gWwlD6ACpl8jSYd5PWfZUGDJhEwLdozpPjKQp1aj7UHAkYy2riuk8OK0-ba2BuE5ulamkjuvBPL0-8G-cnKb_cZ2OH9U1Wuz7z5p_dkbbEQ0xBAG27lwhR79xhOBI5ftWkkke3I8HDm1N8LmCf6rPzShPw-hF_MTdM_ZSf9jGwL9hSOO3XxFZ-Q8yNEqas-XHc4MfCvzXA9zM4PhlUSP7pkN8U2lBQzh7pGcx_5BSLejtIf8LVP0SWs6WnJujK8Gxo6uMCoxP6qMfGFXHnQZZdhr7fEKrmevYo3ghttQh2G52iU9EBWvOwzEVO9_XPs3Ohh5RgSF2jD7OclwQpnzv4vrx8tS9_CPlI1qN8IUsRYXzsJNKj9ZAM2J8OQUzfc6xSADQSK5Y83-4JYnkjEbpPMRP4v3kcITQVjAIr9RoYIVwMTLDLtn-JDJiYhfcIqey0isyQRbKx2Xy89VjzUBEqvIi1B0nG9bfb5BbAPpoIAHmwDBTN5AvS7LmD2chKEe_szUQj5Bzrp0f7UroagAuRKC4qZaIb8xERCEsCygglx8ZAU7azUcRdZJZZ2_13L2oKqehHGGeKUF7mO17vv9ZInrHDZL8UPEulMomacqOyywgmKm807xae9paoe_vYjCytF8fz5F-dq7Z-qlXX-8ssbBvo_LipAtLgAcAc7TqBnAd8svJgRlk_pk-mAQb20DHG6OFLE-rUcdu6s-fakSXeVVjkZUBJ-yveTVWPKjuYL5TzaS1enUsROFFBphy5iDvSeGxTrZRmOLM0a2lellqTjFDpBiQEpAba1m2VhNn-tB9ZhEjhyOMV3_9oW6FD4BomkoyJQUcVqWEzxFYpxJdGtPSXAbZnGP1T6FGTXhRwWVQ-NxSwc7qO8JBrddnSemh8sFyjz3gkzpBsgEd6IyIgtm4Sdgae9HZAE73SJW-H-B192K3VU9S84oQAHL8m_hg602DjgA8Tmo8bM--byaeZ2Bp3PtsjvQltW_uMUpyiLeuJdON4PrrbUGQ_Z0L1idOl8gF70B6Tyd-2Pmof6rm1qNJth6-75posUlq_bVtFi6EM0gKP8E8ek3B-bZwAb2viOIH-jsFBO3YxKoKO1F1rN-ubI9Xad1MT_g3NEx_BqXzNMUcCTXmptDBavhOA5rP9mIof6a5klMDO7445DLF5XCXN4fJjvCUd9yp-a85qdgvAX0q-oC9rmBU-cf3cxQUgsRypUyW82UN-_Q0vlnpd80X6gtgdq-rtyxWzAQ_-PhwhwjV2HCFAX8HIy6kLoCMo234Rnk3CC-UGFtTAD5aBzX2Iiu-p-nmCnUoPeisJc0ZGgpE8fxDccO9MmER1qUjLbjyZpv-9keV0k6-lR2hSEYEarDXO1DSLMA5mmZyeYfIWwJi-GQYnNUx-o_VYsJ9JVh9te__aq0geJMuMguTFf4xMOVQcg4eSTM6AcZROu5w5crvv7b8jJLD-zupPAdAkk6VudO_EX3o5yv2J0oxK8a4p0znmxMIMw8lIl2YtdeABEQX-fq0PMxUhYZz9mr2GDLAi3buAqqZ0e0PNhY2FbOm3Uw9BREDQf1FI3iDif7Vy7OqBNvYVvOgHKagu-4iqeF55UKSlz5eaaYcEavx3jEiupNebVDLItclf5z7dzkmzEF8EoJ0hAgvi4y3pI9sS5VY4bswQDipUQTjzDpy1YFLjO_eSpCsBz0hca3BsSXglHQWq0wLcm6gddMWb-lr7gAzqX_3z7Yy069Ssx13xtDwxcc3KBGnvyv4e7fgN-3fnEMP2OoUc-YvW_abpjAikdLoDidO6AQnM09C2mSwev34cg7vcy0uM8kQFutLqqCTtTDpKA8llyi37hJkfkGY4hLfAflhNPAuQEdswlsrpd7xwGjuMJemWGZoVaLyGH8bPSH5TBSRbA5BqGOgVAGdMu9fTztF8uN88S0ZagbKHu34iWUlF0bbdVYVWktHlTy6-mYn6LAqnMb5PZcufCGMf2N2OrlyZ9oMGv5a7_kiUScg7oM5PsuI77_US4jSWdPiHA9h0OWnQD2M_3RX4brMA7PMtEIIIG-2Z5OtxDOLWZUoywlAqPxTZQYb0jjxdZHN15EANAc6OoxzEkScw3Jj_dcYNmBrD6vI1lnB5J1V-_2xq2k6zldOXyoHpCM0dIBDmwhQ0pf9FsoVKu87cCq9V8a-ygulKEDLLg1OUR0NyVqtRheEGlwkV1PT7RKXa3_MhAYvLAF2mgSPge6YtMFU43a-gh5gIFsfF33ju11hIhxk6g28lB",
}
local _8de8={1}
local _693b={} for i=1,#_8de8 do _693b[i]=_f87e[_8de8[i]] end
local _2db6,_9f2=_43(_868(table.concat(_693b)))
if _9f2~=1983080487 then error(string.char(49,48,48,48),0) end
local _4d6d=(getfenv and getfenv(0)) or _G
if type(_4d6d)~="table" then _4d6d=_G end
local _d,_e1,_ddee=_pr(_2db6)
local _6e=_eq(_d,_4d6d)
return _6e
end)()
end)()
if type(_006c1c) ~= "table" or type(_006c1c[1]) ~= "function" or type(_006c1c[2]) ~= "function" then
  _898d13("Protection unavailable")
  return
end
local _d376b7={}
for i=0,255 do _d376b7[i]=string.char(i) end
local _472fec,_87531a={},{}
do
  local ta="082df86f4e4f8f26e6801bb49a2f7ea9aae9a642ae7a6b3bb6906117698ce5cd74fc689894d191d80d5f50a12c8d15c1567b417d79b21e026ec7c31f2be07c49e4dfd044f6f3ed52e1fed43284bbf7e7512377ac0eb72eba207548eb819e6cf92970bfeef4c6d2a8eade09ffaf4d31135845cebd6dda5da32176012a6011dd0f823d97caa5e2101857f571cf1dfd731a0ab996bea44346e3a7c2995ccc5a8a9cc40459f066a0649b5e067fec30efad3cbc9325a2379f0bc56578dc92fa62d586cb8b3ff1abd66ab31c07476700d3d933225488f23e034c830c1427db350519b09d38b81263398e87fbb140854b36c8c9535b4a95b52434c0e889283ad7551672"
  local tb="b0caf3c2ef22957a6825ad641ffb493990fcdb4177eee4a06a87dd5d7d120a782337a717b82a15d37e6d274ad756cc24b216d667fe0b8552658fa56b0f131ee871037314ae20c5a8da11c35e803cdc664375f95b3e018a2f3807608e7c9cfd8c8d29ac50a3ab8357de538b6110e546c60597d04c92d1b44498d4a2741dc1cddf96e3ea9de0c006ff9a31af2dc90c082c70be4d3528b633f4824f30f2b56ebdbaa6f7a921043f9fed00b340794886ec516cbb544572d52ebf993d5ff0aa4e59931ae147b99e321b2bfac40ee7f5a4f17be276423af8e9f6e626cfce4bc734ebb7c8d289a191940d0258815a9b88b11c5c36637f84d90918193b556269d8cbbc6f"
  for i=1,256 do
    _472fec[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _87531a[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _503e02={}
do
  local a="2jYdR7zUuinpm5hOIvKPt194r8blCTXg" .. "N-wfGASQa3EWk_yB6qVJH0ZDxoLcseMF"
  for i=1,#a do _503e02[string.byte(a,i)]=i-1 end
end
local function _f6eb84(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_503e02[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_d376b7[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _23d87e(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _181a61(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _7b9e2d(S)
  local sa,pa=3816530351,49
  local sb,pb=1776882518,250
  local MA,AA,LA=838313,-349156991,7861524
  local MB,AB,LB=86751,-603398453,4867955
  local KA={115,173,127,169,158,132,21,156,249,93,182,123,193,163,92,165,12,164,184,76,79,91,21,197,67,161,188,86,123,245,166,21}
  local KB={54,41,232,63,18,185,191,112,209,252,65,134,130,137,169,242,124,234,254,24,109,82,92,177,211,239,236,48,118,204,255,141}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_87531a[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_472fec[mid]-ksa)%256
    n=n+1
    out[n]=_d376b7[p]
  end
  return table.concat(out)
end
local _0d154f
do
  local np = 7
  local base = ("https://kin".."gmor.up.railway.app/api/loader/e606cddc1191cf.lua?pack=1&part=") .. "@@PARTNUM@@" .. "&dtok=" .. "eyJzIjoiZTYwNmNkZGMxMTkxY2YiLCJzZCI6Ijg4NDc1NTRhZWQ1OSIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MzExNjAwNjMzNX0.JLYpDX0zKF76KsNWgnCwhmwjRcMiRbxnIZFbtHWY2jM"
  local single = ("https://kin".."gmor.up.railway.app/api/loader/e606cddc1191cf.lua?single=1&dtok=eyJzIjoiZTYwNmNkZGMxMTkxY2YiLCJzZCI6Ijg4NDc1NTRhZWQ1OSIsInAiOjE2Mzg0MCwibiI6MSwiZSI6MTc5MzExNjAwNjMzNX0.JLYpDX0zKF76KsNWgnCwhmwjRcMiRbxnIZFbtHWY2jM")
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _23d87e(hx)
    local body = string.sub(res, 9)
    if (_181a61(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function runMsg(res)
    if type(res) ~= "string" or #res < 10 then return end
    if string.find(res, "Kick", 1, true) == nil then return end
    if _bda908 then pcall(function() local f = _bda908(res) if type(f) == "function" then f() end end) end
  end
  local function fetchAll()
    if _bda908 == nil then return nil, "no loader" end
    local res, err = _7d5dff(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_181a61(body) % 4294967296) ~= _23d87e("edd22e8d") then
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
      local res, err = _7d5dff(string.gsub(base, "@@PARTNUM@@", tostring(i)))
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
    _0d154f = got
  else
    -- 2) fallback: whole payload in a single request
    local all, why = fetchAll()
    if all == nil then
      _898d13("Download failed part " .. missing)
      return
    end
    _0d154f = all
  end
end
local ok, plain, why = (function()
  local sh = _0d154f
  if type(sh) ~= "table" then return false, nil, "no payload" end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _0d154f = nil
  if #joined == 0 then return false, nil, "empty payload" end
  local expect = _23d87e("edd22e8d")
  if expect ~= nil and (_181a61(joined) % 4294967296) ~= expect then
    return false, nil, "payload checksum mismatch"
  end
  local raw = _f6eb84(joined)
  joined = nil
  local out = (_7b9e2d)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, "decrypt failed" end
  local ph = _23d87e("f0b33e9e")
  if ph ~= nil and (_181a61(out) % 4294967296) ~= ph then
    return false, nil, "integrity mismatch"
  end
  return true, out, nil
end)()
if not ok then
  _898d13("Payload error: " .. tostring(why))
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
local fn, cerr = _006c1c[1](_bda908, plain)
plain = nil
if type(fn) ~= "function" then
  warn(("[Kin".."gmor] compile: ") .. tostring(cerr))
  _898d13("Script compile error")
  return
end
local rok, runErr = _006c1c[2](fn, true)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(("[Kin".."gmor] runtime: ") .. tostring(runErr)) end
