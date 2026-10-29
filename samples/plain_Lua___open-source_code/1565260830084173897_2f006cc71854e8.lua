local _eee148
local function _43273f(msg)
  warn(string.char(91,75,105,110,103,109,111,114,93,32) .. tostring(msg))
  return false
end
local _d154e2=(function()
return (function()
local _1c38={}
for _q65=0,255 do _1c38[_q65]=string.char(_q65) end
local _1c={}
do
  local _vxj="Qh_tVZMjJnK9IucgXNHTkBiDwLdPmF34eWa5-6x7812zUq0OvColpSfArGYRbEsy"
  for _q65=1,#_vxj do _1c[string.byte(_vxj,_q65)]=_q65-1 end
end
local function _0e(s)
  local _lxx,_swk,_ylm,_7w={},0,0,0
  for _q65=1,#s do
    local _i9t=_1c[string.byte(s,_q65)]
    if _i9t then
      _ylm=_ylm*64+_i9t
      _7w=_7w+6
      if _7w>=8 then
        _7w=_7w-8
        local _uaw=2^_7w
        _swk=_swk+1
        _lxx[_swk]=_1c38[math.floor(_ylm/_uaw)%256]
        _ylm=_ylm%_uaw
      end
    end
  end
  return table.concat(_lxx)
end
local _d1={}
do
  local _k86="Oj\251\150\030\196\165\008\200\024Zx\174\219\136o\184wKg\128\210>\129\001?\007\193\016\187G\188\015\137\011\132\168\172\169\252\190\175\166\022\002$+\217\202\145\227\160\149\000i\151eS\171\026\018\198HPL\189\004z\241V\218t\253\031\225\181\215\233\133\131\204\2499\n\212\141\248\177\009\199\144\242A\205\019\146\230T\228\154\186\247&.\194N2\250\014\178\254\197\"r\027\213E\005=4qc\223Q\244Bd\234b\208\152\209\220\180|}\020\191\239)\127\192f\023\021]\012\025@\003\029WaIJ\231\142\161(\246Fs\130[:\148_!<\017\135\214\236\1646Uln\185\156^\179p\157\0060\216\163\203 \235uk3\221\237\183\138\238h\1535\r`\226\139R\\D\206\224-;#\245\2077',\255\211X\243v\162m%\147\173\2228{\134\176\201\159\195\143M\229\240Y\232*\182~\028\155/\170\158Cy\140\1671"
  for _q65=1,256 do _d1[string.byte(_k86,_q65)]=_q65-1 end
end
local function _c5(S)
  local _wey,_bv0=319727561,213
  local _lxx,_swk,_smd={},0,0
  local P=494241 A=728188339 L=12012437
  local K={35,0,24,144,137,147,75,5,129,158,219,89,225,197,132,116,77,20,42,34,199,230,8,112,176,102,128,161,179,14,216,179}
  for _q65=1,#S do
    _wey=(P*_wey+A)%4294967296
    local _kj4=string.byte(S,_q65)
    local _ybe=(_wey%256+K[((_q65-1)%32)+1]+((_q65*113+L)%256)+_bv0)%256
    _bv0=_kj4
    local _qk1=(_d1[_kj4]-_ybe)%256
    _smd=(_smd*33+_qk1)%4294967296
    _swk=_swk+1
    _lxx[_swk]=_1c38[_qk1]
  end
  return table.concat(_lxx),_smd
end
local function _tv(_nd, _ye)
local _py = table.unpack or unpack
local function _aa(...) return { n = select('#', ...), ... } end
local _lb
_lb = function(_vx, _gk, _he)
local f4e711, _tc, f625qe = _vx.f4e711, _vx.k, _vx.f625qe
local _dh = {}
local _mn = _vx.f8ypx6
for _kw = 1, _mn do _dh[_kw] = _gk[_kw] end
local _dd, _oe = {}, 0
if _vx.f1kz3g then
local _vm = _gk.n or #_gk
for _kw = _mn + 1, _vm do _oe = _oe + 1; _dd[_oe] = _gk[_kw] end
end
local _zf = _vx.fcq67 + 8
local _kh = 1
while true do
local _vi = f4e711[_kh]
local _hp = f4e711[_kh + 1]
if _vi == 10 then
_dh[_hp] = _dh[f4e711[_kh + 2]]
_kh = _kh + 4
elseif _vi == 23 then
_dh[_hp] = _tc[f4e711[_kh + 2]]
_kh = _kh + 4
elseif _vi == 39 then
_dh[_hp] = _ye[_tc[f4e711[_kh + 2]]]
_kh = _kh + 4
elseif _vi == 19 then
local _sq = f4e711[_kh + 2]
local _ra = _dh[_sq]
if _sq >= 256 then _ra = _tc[_sq - 256] end
local _ds = f4e711[_kh + 3]
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
_dh[_hp] = _ra[_ds]
_kh = _kh + 4
elseif _vi == 37 then
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
local _zu = _dh[_hp]
local n = (_sq == 0) and (_zf - _hp) or (_sq - 1)
if _ds == 2 then
if n == 0 then _dh[_hp] = _zu()
elseif n == 1 then _dh[_hp] = _zu(_dh[_hp + 1])
elseif n == 2 then _dh[_hp] = _zu(_dh[_hp + 1], _dh[_hp + 2])
elseif n == 3 then _dh[_hp] = _zu(_dh[_hp + 1], _dh[_hp + 2], _dh[_hp + 3])
else
local _ra = {}
for _kw = 1, n do _ra[_kw] = _dh[_hp + _kw] end
_dh[_hp] = _zu(_py(_ra, 1, n))
end
elseif _ds == 1 then
if n == 0 then _zu()
elseif n == 1 then _zu(_dh[_hp + 1])
elseif n == 2 then _zu(_dh[_hp + 1], _dh[_hp + 2])
elseif n == 3 then _zu(_dh[_hp + 1], _dh[_hp + 2], _dh[_hp + 3])
else
local _ra = {}
for _kw = 1, n do _ra[_kw] = _dh[_hp + _kw] end
_zu(_py(_ra, 1, n))
end
else
local _cn
if n == 0 then _cn = _aa(_zu())
elseif n == 1 then _cn = _aa(_zu(_dh[_hp + 1]))
elseif n == 2 then _cn = _aa(_zu(_dh[_hp + 1], _dh[_hp + 2]))
elseif n == 3 then _cn = _aa(_zu(_dh[_hp + 1], _dh[_hp + 2], _dh[_hp + 3]))
elseif n == 4 then _cn = _aa(_zu(_dh[_hp + 1], _dh[_hp + 2], _dh[_hp + 3], _dh[_hp + 4]))
else
local _ra = {}
for _kw = 1, n do _ra[_kw] = _dh[_hp + _kw] end
_cn = _aa(_zu(_py(_ra, 1, n)))
end
if _ds == 0 then
local _yp = _cn.n
for _kw = 1, _yp do _dh[_hp + _kw - 1] = _cn[_kw] end
if _yp == 0 then _dh[_hp] = nil end
_zf = _hp + _yp - 1
else
local _no = _ds - 1
for _kw = 1, _no do _dh[_hp + _kw - 1] = _cn[_kw] end
end
end
_kh = _kh + 4
elseif _vi == 20 then
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
_dh[_hp] = _sq + _ds
_kh = _kh + 4
elseif _vi == 31 then
if _dh[_hp] then _kh = _kh + 4 else _kh = _kh + f4e711[_kh + 2] * 4 end
elseif _vi == 35 then
_kh = _kh + _hp * 4
elseif _vi == 24 then
local _ra = _dh[_hp]
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
_ra[_sq] = _ds
_kh = _kh + 4
elseif _vi == 41 then
_dh[_hp] = f4e711[_kh + 2]
_kh = _kh + 4
elseif _vi == 40 then
if _dh[_hp] then _kh = _kh + f4e711[_kh + 2] * 4 else _kh = _kh + 4 end
elseif _vi == 21 then
local _sq = f4e711[_kh + 2]
if _sq == 0 then
local n = _zf - _hp + 1
if n <= 0 then return end
local _ra = {}
for _kw = 1, n do _ra[_kw] = _dh[_hp + _kw - 1] end
return _py(_ra, 1, n)
end
local n = _sq - 1
if n <= 0 then return end
local _ra = {}
for _kw = 1, n do _ra[_kw] = _dh[_hp + _kw - 1] end
return _py(_ra, 1, n)
elseif _vi == 36 then
local _sq = f4e711[_kh + 2]
for _kw = _hp, _hp + _sq - 1 do _dh[_kw] = nil end
_kh = _kh + 4
elseif _vi == 38 or _vi == 29 or _vi == 34 or _vi == 11 or _vi == 4 or _vi == 25 then
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
if _vi == 38 then _dh[_hp] = (_sq == _ds)
elseif _vi == 29 then _dh[_hp] = (_sq ~= _ds)
elseif _vi == 34 then _dh[_hp] = (_sq < _ds)
elseif _vi == 11 then _dh[_hp] = (_sq <= _ds)
elseif _vi == 4 then _dh[_hp] = (_sq > _ds)
else _dh[_hp] = (_sq >= _ds) end
_kh = _kh + 4
elseif _vi == 43 or _vi == 15 or _vi == 16 or _vi == 17 or _vi == 22 then
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
if _vi == 43 then _dh[_hp] = _sq - _ds
elseif _vi == 15 then _dh[_hp] = _sq * _ds
elseif _vi == 16 then _dh[_hp] = _sq / _ds
elseif _vi == 17 then _dh[_hp] = _sq % _ds
else _dh[_hp] = _sq ^ _ds end
_kh = _kh + 4
elseif _vi == 6 then
_dh[_hp] = (f4e711[_kh + 2] ~= 0)
_kh = _kh + 4
elseif _vi == 30 then
_dh[_hp] = {}
_kh = _kh + 4
elseif _vi == 3 then
local _ra = _dh[_hp]
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
if _sq == 0 then _sq = _zf - _hp end
local _rl = _ds - 1
for _kw = 1, _sq do _ra[_rl + _kw] = _dh[_hp + _kw] end
_kh = _kh + 4
elseif _vi == 9 then
local _sq = _dh[f4e711[_kh + 2]]
local _ds = f4e711[_kh + 3]
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
_dh[_hp] = _sq[_ds]
_dh[_hp + 1] = _sq
_kh = _kh + 4
elseif _vi == 14 then
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
local _gz = _dh[_sq]
for _kw = _sq + 1, _ds do _gz = _gz .. _dh[_kw] end
_dh[_hp] = _gz
_kh = _kh + 4
elseif _vi == 2 then
local _bx = f625qe[f4e711[_kh + 2]]
local f3j995 = {}
local _fu = _bx.f3j995
for _kw = 1, #_fu do
local _qv = _fu[_kw]
if _qv.f1md0s then f3j995[_kw] = _dh[_qv.f5cxv0] else f3j995[_kw] = _he[_qv.f5cxv0] end
end
_dh[_hp] = function(...) return _lb(_bx, _aa(...), f3j995) end
_kh = _kh + 4
elseif _vi == 32 then
local _sq = f4e711[_kh + 2]
if _sq == 0 then
for _kw = 1, _oe do _dh[_hp + _kw - 1] = _dd[_kw] end
_zf = _hp + _oe - 1
else
local n = _sq - 1
for _kw = 1, n do _dh[_hp + _kw - 1] = _dd[_kw] end
end
_kh = _kh + 4
elseif _vi == 7 then
_dh[_hp] = _he[f4e711[_kh + 2]][1]
_kh = _kh + 4
elseif _vi == 13 then
_he[_hp][1] = _dh[f4e711[_kh + 2]]
_kh = _kh + 4
elseif _vi == 18 then
_dh[_hp] = {}
_kh = _kh + 4
elseif _vi == 1 then
_dh[_hp] = _dh[f4e711[_kh + 2]][1]
_kh = _kh + 4
elseif _vi == 5 then
local _ra = _dh[_hp]
_ra[1] = _dh[f4e711[_kh + 2]]
_kh = _kh + 4
elseif _vi == 26 then
local _ra = _dh[_hp]
local n = f4e711[_kh + 3] - 1
local _kw = f4e711[_kh + 2]
while _kw <= _zf do n = n + 1; _ra[n] = _dh[_kw]; _kw = _kw + 1 end
_kh = _kh + 4
elseif _vi == 12 then
local _zu = _dh[_hp]
if type(_zu) ~= 'function' then
local _ra = getmetatable(_zu)
local _sq, _ds
if type(_ra) == 'table' then _sq = rawget(_ra, '__iter'); _ds = rawget(_ra, '__call') end
if _sq ~= nil then
_dh[_hp], _dh[_hp + 1], _dh[_hp + 2] = _sq(_zu)
elseif type(_zu) == 'table' and (_ra == nil or (type(_ra) == 'table' and _ds == nil)) then
_dh[_hp], _dh[_hp + 1], _dh[_hp + 2] = next, _zu, nil
end
end
_kh = _kh + 4
elseif _vi == 8 then
_ye[_tc[_hp]] = _dh[f4e711[_kh + 2]]
_kh = _kh + 4
elseif _vi == 27 then
local _sq = f4e711[_kh + 2]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
_dh[_hp] = -_sq
_kh = _kh + 4
elseif _vi == 42 then
local _sq = f4e711[_kh + 2]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
_dh[_hp] = not _sq
_kh = _kh + 4
elseif _vi == 28 then
local _sq = f4e711[_kh + 2]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
_dh[_hp] = #_sq
_kh = _kh + 4
elseif _vi == 33 then
local _sq, _ds = f4e711[_kh + 2], f4e711[_kh + 3]
if _sq >= 256 then _sq = _tc[_sq - 256] else _sq = _dh[_sq] end
if _ds >= 256 then _ds = _tc[_ds - 256] else _ds = _dh[_ds] end
_dh[_hp] = math.floor(_sq / _ds)
_kh = _kh + 4
else
error(('E'..tostring(_vi)), 0)
end
end
end
return _lb(_nd, { n = 0 }, {})
end
local function _ex(_gz, _wy, _jg)
_wy = _wy or 1
local function KMVX8(_hp,_ds)
_hp=_hp%256 _ds=_ds%256
local r,_vx=0,1
for _=1,8 do
local _cc,w=_hp%2,_ds%2
if _cc~=w then r=r+_vx end
_hp=(_hp-_cc)/2 _ds=(_ds-w)/2 _vx=_vx*2
end
return r
end
_jg = _jg or 8446
local function _mc()
local _sq = string.byte(_gz, _wy)
_wy = _wy + 1
_jg = (_jg * 2425 + 1280) % 65521
local _tc = _jg % 256
local v = _sq - _tc
if v < 0 then v = v + 256 end
return v
end
local function _xd()
local n, _uh = 0, 1
while true do
local _sq = _mc()
n = n + (_sq % 128) * _uh
if _sq < 128 then break end
_uh = _uh * 128
end
return n
end
local function _if()
local n = _xd()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _tg()
local _vx = {}
_vx.f8ypx6 = _xd()
_vx.f1kz3g = (_mc() == 1)
_vx.fcq67 = _xd()
local _xo = _xd()
_vx.f3j995 = {}
for _kw = 1, _xo do
local f1md0s = (_mc() == 1)
_vx.f3j995[_kw] = { f1md0s = f1md0s, f5cxv0 = _xd() }
end
local _qk = _xd()
_vx.k = {}
for _kw = 1, _qk do
local _li = _mc()
if _li == 0 then _vx.k[_kw] = nil
elseif _li == 1 then _vx.k[_kw] = false
elseif _li == 2 then _vx.k[_kw] = true
elseif _li == 5 then
_vx.k[_kw] = _if()
elseif _li == 3 or _li == 4 then
local _jr = _xd()
local _aw = {}
local m = 204
for j = 1, _jr do
_aw[j] = string.char(KMVX8(_mc(), m))
m = (m * 69 + 25) % 256
end
if _li == 3 then _vx.k[_kw] = tonumber(table.concat(_aw)) else _vx.k[_kw] = table.concat(_aw) end
else
_vx.k[_kw] = nil
end
end
local _fj = _xd()
local _tr, _iq = _xd(), _xd()
_vx.f4e711 = {}
if _fj > 0 then
local _et = {}
for _kw = 1, _fj do
_et[_kw * 4 - 3] = _xd()
_et[_kw * 4 - 2] = _if()
_et[_kw * 4 - 1] = _if()
_et[_kw * 4] = _if()
end
local _ee = {}
for _kw = 0, _fj - 1 do _ee[((_kw * _tr) + _iq) % _fj] = _kw end
for _kw = 1, _fj do
local _lx = _ee[_kw - 1] + 1
local q = _kw * 4
local _qv = _lx * 4
_vx.f4e711[_qv - 3] = _et[q - 3]
_vx.f4e711[_qv - 2] = _et[q - 2]
_vx.f4e711[_qv - 1] = _et[q - 1]
_vx.f4e711[_qv] = _et[q]
end
end
local _al = _xd()
_vx.f625qe = {}
for _kw = 1, _al do _vx.f625qe[_kw] = _tg() end
return _vx
end
local _bx = _tg()
return _bx, _wy, _jg
end
local _1={
("J6WuGLUfMlZe3dQFlkFBmo80tNtYgA29G7AGPQaP5j-gkAkPXpNcUQUHcx8VljOd1SWq4-hsY1wl21pM7B_PT7_9E395UsFhIgNGNQwWlcxoFV59MnNQ06YopFXLLJyGg97azc1GE1lgcUjA6qJU6j5i6u3OmskB1VbjLJIwVSQAno2sLKqsszitcTwvB_yDJOwZEBkRL_6Ut8uGAHFLgF6VpAmo0PXwTqXTZwT0Ciq3QDqccyhJdmPI512VFShxToFmfhIhzDHOqmGN9t_pYpQrxs5Uey93k8g-CzP3XWqNw98jigLo_Vk_o6d-jOPVjGHtg4QTqrp7qqlEHikZZo2vjfJj3_VkKyfrlZrsrarbsutGmWKy5YfG2LnwxLNA5C-kHtV02SGvGcxG5GCNncAHFc_TLlKDOs1cRJH6H9bmVnX5iR3E-BuQRMYYk7lGcRkQp6fVMfvUqAAtUUZR5bIcGQKuvVrH6GQNgPKopE58_K2ZIg85aAdlA4FyOH4-10nORe2PBAHufXuBDyTi_KEgi4KvmUwXHAQc6hc_6lTCJNzKJ9Qx8NaMJ-ajMDMZiaHyWxkImjFEF4An_3slK93ZcAMQmBX-X_CQ6WwwUH_4N2-ecQD-C5e57GPYmiH291j_FX259SdsF_mhQIbMsW0DMHQOkRe6dkzNHxOom9FcTlHFZf_WKLgmTHuJMjAvEnnTsKQhKR7_Lm2Sla7AFCG4tWPFs3u5_gKGopHUS-vdBbmfqWg7ssZfy8Vs3x17SjJRwYBWo5RnShunpfgded6HAxobmNB7nyOZ1fA9hFQlu1BFFW_Sv-6wP8315_IaXOk1Dxw1At-Jj54LogykQzoH-rnZr9TezHhCO3_DovWKAVzSFcYgWk8Fqd05urVt_8zqPjT04gPOEggzTeSu1UvMnnHIQfwDohSX0_ac5xC1g8Br99E2zMoiIZkviWSACVoN94vHg0ElZsx921Y9U0-y6v-5A1VnimU7SHsaHhbVjZGBoE934h7zLCNkso-mz9mdmi7uDqbnginb42gRlfcIFe2om-O750COdUKyyrzv6GzqrcV5mXkq7SVGPJhdCAIQ2xsUodu8_pH12LgzPml7zxWzXD7bqt-jzPkI5zaP90889yN1cmfiXzCaV-uFVNaoQpBY08UdVK8XfoUEklDRp1m3llXj23hbIi8w6R4DvPuqwb-uEBnypoECUj9yPU2FWD6ZEAlSGCS0ovi0isvLtvVPy379hefuAudIwYykhMuLZirr3yomRU6T1QeRscMfdEnNGkTotDFA8kScPgCDhqwgFDD5OxybuYnCwVsa9gCeUv-ZeNNQXRvZp_VLJBW9z-b7CjgLq94IvQBY8tKMsZTvmS156w7jv0AMrMxqgoIfugvRcs4_w13CIFPt1MgNg9LmWV27Olw1J79NVzaPHoN3tobLkCOCC3yLOy5cFRMMbggBUZqXzfUbSzmqEfwZoyNsf4cOi-7A5B-XaSIABCR6u8zzA4TjToR_agKKsEUX0tHVA3hivQ-M0115iekwWzjY3lz6tWc9jTwbRocZRasXHot73x9aD4Z_2ChiCu6WGBozlIMq2cQfG3x476NGtJMOGwvC80c6AbuIhkVwpj4sTe-61BwDfeuXiPlC1nF2bzljicj9qqKBqxLuLvUE3M2JV8q7SKr-wykdVXy6JDVE1IQrBwMmSc_hV5KRvJ59tv3pDhgCuUEgAqmi-GKUrX39cLTrqSQ6N3ruH2vagrNugNNNCeigYGP4o5NYWnYD4f8JUidk1e2klLTZpYx2MSdkgse3oNDwZHKKKf6wGd1fUHKjkE1msyZZmDuuVcmPNulMmsxweD9vfplSD4bjiCg-zQ4TqKsrEk1n0q7WOayYpAcP2l73vVMmAKGac58n72I371t9XiVhjaNW5gF-D7X7k5ybd_AveOiY348jjIS-F_LPWlf9XBtpwMdKzZk-C8pU5nRePlI1CZsN1Tq7VAKOKr4qLtG-NGxk32OI3StDuk".."MveNfIGRixP9Zo4_m1-2SYzUWWJCYKgmFenfls6panxv9FYkSp4fsWGjO8KGgWsaKwSSeVUDEPioiwD9P64SWVbi01k4GbV6GpbneWoQc7kodDI6kNhHDx9N7EB0hmn02STGYgaG9pOjohnM8CFioIa-6lyuPC7Qp68RT2uMn_jjlZKMG9BOuyVMrMzNiL1APDeQAadGJffDawNJmdQ3teTOwIdaU7nW4KTwcUBR_pg2Nr2ocaPb0QJsZKlrm1hSwuJssqa_NDnox2WQ4VBgbOSQx-ghKTTGFrWQ7maKXyJzc2DJ3ZZosQdKWnKgR9q35AiFJG2icmuWbP43lJAmpkjFNi0RDVMzpJBc8nxMQlEgDTw0f04r3V81-Rks3eyvzIxmb6EKXwRjbl43yL-jLopywXn8PcTywZ4vrsg3ZZ4M_5pZTkdnDcPUPX8M67eguD6lSvP3Ffkv-0kCYy-7EiPRbjHohFkvGLa07-RPnSpJ0WVUE9JzA63-vVeQZEw99NiJXyLtObIdPGQpDG18soR6acjBjrvY1j_-zw3m6Ea_tmcPAHayYBhRTu8yBD4AMFIMxLYm-PX0HhN6lncjhdpaaRWqPCQnNO0biCvztjlKB-aYkjeGKP0lQl63hRgcB9ZBk88K3eVcu75XgNrM8kQ2QK5lJZFkoG3zZrCigDCViw7xqWI9pjIxAt7GcRPSYMJ_q9B49u011IM_740aH2oV9hTNYxxxySyQBsrrOIS8aJGQaymUYJjWj7yHxT9-X_J5Wy5EnMDAJ5ihdWZW0Tg9jDO92vn2xHZerdBSNw3lg-szTB45Fifjnv3sSc6oRYB5_5UT1WZXV2P4-riRCy55G9XN40yFLaIXygUAv8XlfPHwnX3i8LnAlg_3WrKhlAnmsr9c9wmgn0epjJtl_1gfQJKu11Fx3iErIVAC4q_4UKdXnWYKn021AqGwe6lTZXwMRxS-mP544aE4Lpp6wOw-c6oPrvuZqsjqk7RKvOCaKIYU-RkMfkKH3itykIbNolb6-7Epciz4Dm0_LBZZHek5W4PfuJfnyBtYmkteCUBZgqdJ-i916627EyemcF6bPXuFhxFAzroQvzsZizOqXLNU8QBVXJ1rr1EbK8bSzwy1amgkIytAhkcfPsv3_RjnYVarJ7bahlVgLAKID6bbdaBZ-I2sU4gkAGrxZd5HrOHxNtd1yRy3mpuD-v0s8xQoLhklGRcE5PHZ1uJtea0eIqlD2VhgWSJlT8YqgJgnxXzG2imYyFqhh09DmxnXaDagWp234bGWAI_I5llNWSpWlr06f0Ea5vBxvdLCriwBeOdHcnGI7DLuYo8Zxs-JNsgxhjxaVAn6G4XWx5--cWkjZTz8sVUUXxomcJCmKQ-6--OGwInAH5Z7b0q2fG6YDfjWXbgx-gxOKd_6ctZqTIDermXL_Ru9ermvJGfBPFmkCIn6Th_t9zo9fcS8R426uyLT4oZmdJjUXoHstJMLM85XE5nJRrM7af9Yoz4FbGvdjBab8j_eXOy5sWK6D2zvDkqYUbvlnkkaXN3qPhXMobZKGQhlzrt5tXwHlShRH9IqQM5PX6IFP6u90zzW7kdtt8mYamRDRopqETKNr9v9zS0576FDif-7nqLyVm2Meo6ojI_kQHZ6lOrG42ruCAc50ZDYdky4twOalZhL7GYBFaHtvPRyF_jojWN844jdw8IbpGB0S26Pf-ZY-yNW3BE9SyNDMxbG9mRZsWHm3CQxuZdV0utKVvgJQ3fkgL1h9cb6tGzgqLJ08VJUH2poGRkGi87OMwm17K58eyfFOOjsjLe0I8FoSw_Iu7Yt1eKfoWXbwMHaxWcANszfDcvpc0h728o91xuBLHgxO-YE8-rDemBTgj3wKqCoB9DG3RhUssXYcgCi66xc-qeQLYoGrXQdPvFyAP5LPVMpmA4vJ7lSxE48TlWkGrrkLITsrpyUTSbBeci401jq8mXoHiHOl4NDDUGjNUcYFMq17-aqPEm_4fZkC4Uyv1kDo1zRnrVRIxPmImpIi4MGzu23b0SehRG1Q9a9GyiJW0CuEym4NBsgPtpgn-sXP5n_MYudHKe_V2aZuswxaCzKtAZMyqMnf9cCa_kQTIyUK9wugmEouxoHR9J6KqaoCBjvFqpwqYBxni0o7rOUb2NZqecb3cK4Mtz8RP-w0BramSVSxe2t9g_LlbEnvMW2tAyMqAeSyLe_ImzPRsvx2tUYVJGG-go1gpBT8FCi3Ll-zQD1rnY3COcTUq2I9yfoix9oF6bfGOan8GQVPAScY9rcdwtJYRLa34hFtazsYlgJn4ZnTm9cFRirVqZkMk_l4KbJoQKIWBnrHlSORxcL_suV_fCk9JesQbPpW7KPoCo7yfcFJxUp8q5KnfZ_0ikd83WxTNN4BUutIjdTsgMfs0pGBB8Vp3bwr5LKthnuV8nyqBgaFB5zZZwRYM9R0pLXoqnQLnrMhxDZMiam-OWtmTFwvPUlwZ-PgffDGqVJK7Liq6fNMQyVZ6i-pn0odUNJUP-qo7mUCD1Mi-wjo3Dl9x6KQGSJmwkNGRxjQ68-7nPHwBGVozhzMTk3FOM73CsnG2W9y8_VUvnijJX6eNFThhULr0gJta63XmkNOU-uQhHV52qDuj6jZvCua3KD_iL9wYRzb51gevT-yZhSB-cLKBNLD10BZZ4d3EanoDobLCLYHCVFaUAHjhjl0keB4zzLwFGKALcpswMODp1QWY-2UZQUAS750MRrnD9UwFq7eaC8Sfm8W0E0Bt7dkK2Z4VjxODRDnHcJpfdq1ySjJxrC5kqQaGUrWMAjXzpJoG-glT6NPzP251U5hcviQJdcGapfM0tr8fPCb33Jw2JoMkwl5iemoAqx-J-KU0jdI0X-kdCvK42olhgzrn7Oh6ykLjfOlJX1FAqy2KU656OPPWwVhPuEODemcVWNMSdWzBzh1lXT9xS5T2JxCuDrhaXRLtDqHfvQV1IKotXXZ5fHZKB6tLZobXUU9ahgakbyXQ5jwDGrdvCYsWNvp9UKjZZVTc3ybvKbaYsv4NxH_BQRmK1urNhgKYcLykwUBlTiL53QI2VIX70Rie1wkXnReINGzKOPhZXhfOu6ONmZvBqt5c605IoZbw92DS6h7uW_EdcKOLT6wwOdUPLLyvP3y1PKA8yyezb2IIyr4C7oVIsR0xgcx87s-d_jOQ0Y2NnPbZ58GFgy66ATcYhFF60kteDBZQY34S9-VuKUsGTjrhyFyy2nca7SNykGJngj-DlcmpxqN-y6svQ_1F5KQLHyFbAnVKoaagCeIUF_zdfrBtTbUQYn4_YQ9xRzupTvBlB3ZlVT7Qj5PDNxbJta61k8VcnsPkkK6sdBU-ow2uu9eBTqnhe26LPkF4kcmzEOvuRpLKW03d1rV3jmJCNf7qqsbNlNSXJRstrA4qSxfa9_3cLPU5yGcwUdboHNT12KWlcCDf32FXw7QCEjOZYsRXBxA__OTAt0bMxKDxJ-rs9MlSlgyfj5iIeU3DeJAlTSXALnbZ2x5kTQjzAErGVTky1tM6NiKgcT8QsDUsRI-gWAbkERUgi2jqqKx0yf47iJaWhM-aolR9D-zK1t9iojifjYxiG-wQQD5Bugs2YufiN-bYuDZtnoTQBlhAFyglKGu6kB5-PVPc6G6Qu0ZRUARy8RJ1vbbZLtcJ4GL5QhFdgF17PjkN1XvisaGyj6jfie7_l4dFwXztPoH2bYiIQWTb74bdwNdxQ5KNcivzNwKSu8PlM4A7m2GWM5boYwwJcX2IJy9m18ydqRbLcJ3g4bO86XHlDZ7k0Gxa9vCKa4UR7avfhbQshjvJdSJz_wAIBSqQWHoS0FbfkWmeU_5KjjVnAaeqq32p9-v-7es6SZabG-Y2kOOT6cBjCMhc_342K7vPbXjFE2qwt7y-Fxvt7_hb7Tk3ENeRXgcEhMFJIqLdK4TRR2iujc-qRuOEqWq1WvRmaRkxqWH0V3B1oozqNXMZosqKZa29XiyNXaChMmPSDDSd-sIZzesTe8cr9yITMs6QEOgeDoDwWZ56lAm3bHtpuE4xVEX8GJd0Rg1E5K0YyS4bGBqWn-0UKRVrL_NYM0MCz_kogwKRUNur7ZiMyF0EU_7-YyAUWuCZFaSZBd4qWY3b8x5juIIB3bTAXMBX-rWAkU5ZmUXvQBUM5eUfXGaPHS95djPfxH_OEm99djRWjdL8YWTbjU70Te5Prj-gQt4muZJkWs5_D_xUUDo1nb5roXtyq4KnvjEREWWerC8fRGXAVKltm7TNBL9TCc_fzebOLgKOVw0ApDaEsER8z6uq29GuxOElqekeV0TLaVOLYxcUcfDV9kovNbTvETRiuVEJ2EJO54_932FjE8mO9VhA1uxqQxfkAhMw5AjeeiUjBBQKL08aoXcDszWGr2yWqPC4F6qpbWWMqMccUSB6J2wTwndsAdIbhDJITdMhSiAP8G53-ziA7DBlIckja0TmKS-FlKRBDL_seEWTU4N-pNF-bsN1mcCE6JTMYoRyiPe-L4qhI0fiXxqxp0BAlRdrdXkj29vSPmbG_hgz3rKQaAtj9VpbMpypS7_8GOzOLter-K5H2t7HOB_1oyBfWzv6oSHVJ8sHqyQBAul3gTZ1pXz8fZJkU82Buqlaxla260SYGRJNsouIUmlysICfhz4HANU-GvS8K6-7U4HzLhFuMDekvPz2sIARuy5iXHISUYwB3lk9Fe05HNuzAdS3SsRHbtZE3zkF67Y2mrHnqUNNKSQtdBE1f1DhDSmhADbzQoVEl8oLS5OPExy2k1zkeQzrQU3hm15-X01F3bFvNReYaf3nhch2Y9wlnOM9NtBzvDw5DbUmkrzg44BaHbX9uLhCBWQAUhhVpZ2XI-0v7NoGcpnYGRu1MInf8N2YFVYqEVOglGXR83jXr_WRfwH0vDlnzV07i3p6fMKJz2MDJo5uZZ_A8V3OaHmQRBa4LV62nKXjnMqtZYxB2Y9sjK5zJ"),
("UDHAKJVabQXWYS6fQP3k".."mv9RjdsMQIsZFLX5HMdoa6MijV6mueLpRaCgBP8DWAtnLC98Yx1nO9x9iwWoIBRYXTaxeCfOrVVHsKlF6n6amijw85fnsn4qwymNOrzJF7bsDAQAtRhS4tdC8kLut_3bcUR96xXvvGfzS3iSxCGYpBxZkt3xV0j93RUyKvvvi7FQTeqi0eaLCKCPCEBPzVWGWwu3MUsO2EGBkAnfKlcyAl_bKtTS_XYPd2HqenUutqACrL38V1POPIVzKrcazNjPJktMN1TvYfTyVjsvtZyOl_gicl-TOGI12LJ1nyKj4HBv-rQIWc9PKewMo0RTW-NtsMtG-u8s8s96rvAs8rxiL2xE9ss0YiRpR8jQukc_H8kcC1uB4sTGy0oL34GjE1kpg__82UMN2DrhaqkxUsnSXKfk0l-Zix7pwMUWa4-dm4ypJBu_okBDWHRXBpV0g30xXhoUMXE-uSUAWWZbVMLJnHMY5DRsF0yQMTiWE8hPIo8haRCK3JbOlVKwB-wPexEhOOXdPtvKTUbhjL8tz3A4bZH6ugrzpJZAKjv1bTn5GeprByg1Id44jaZw-EUTnh4JvjnP_YnGUbaYi6GA46zPHuUMCFBFA6sGf12SbQ0zLqqLCSNV48Gp0_0KW7a_6H3LmXB8PVPpOba12cFYV8ZSwGwjau05mOSwkaa5JrKYAhtC86woyXq2di7yZ8c3BEY1BcYoLR5lRrgzDJd8Cod-33eG7I-YGyZOlsK33b-YzBtY3_t8u84CfB5eJXX5SeqK3wuLlqMuiJAuaqFJ8HpdQ8NFN0UVMJa0_KEIVCjsF0DuEZWlOh0zEiZeGcAt4pKba-kcTQUFVL7--UPbb4WN97Ud7ocU7podCbo5arAdUxopw8_Z4meqvFABsl1I3kAp4OrNXDdSwceVIF16mOnWIm4PKLYyMnyXG2S7oozdBgI7_qyitXT09B5aSbddzizZCZc5ZvUpRLtA5Ld5gT4sqaFoUUaTmvP6U1y3i7_hIQHcpDJ04Mso9SmpUQv3XhbelKdB6hRAbh4OKzRNPYJfLm7gtLJQFgrLEN4nspjQtNe7-0_7iTODKzpRtiNPYN33PUJqIlgNyL3x-pbj2GDiRtJ6RTibrCa37zhFcxvfq8E4xM2C-Ak1zN5eTmfVAvcP-M-XGdwnEtdmUidv8Yf9jEp1YM8zzK7sHTY5t8izV9oBKRdltwPWDroVrMkYI-q5yvEBe34rZedK6b6oJiaWS9shiMHbQHU0Nnju1fwmgmAf7QNGkUkkobIJ0oT9LspJDvuk13gnAzfJ-NaSh6Z9l71UtEZrNZd9-ygDO3eOHxJ4QUw8SmFsTDK6CvyM8-WfeswCtyfmUyjzqlqdvv1wCdsOyyRUXaf7N8dSZKBf_r5SDv-G_Qf8FUgJo4JPq4yrMvusNXeVtCA1ZSoUr1f05E7nff5IvGBCVG_Iq21bDXzykXvcjtBRaps17MJKskulp4lEo5f2aMdXLaxr5DDLMfsAAabk4w_hpJEnUyeC2Mk740cNGYYyPuQT2QoV0xhbKAcGSX5wbx4BV-sKOkICEiBreZWffgS93IwILFXGxnV5M0Zcw2tvYgPTFYsJAtVmhzFh2uzNNAWMPX8Hq7fBMY8iaCT75P8dL2WuErLvVvvSb3iWd1dFqGnXcs9uvF2P-6kzqqzoNLPCbCLb-RDLjn2rWzEns7d8GjtTPmyf5x3LetW9ObVrY3RPgkXD4WyLSI6g4qoTKldGjnmnJFae3izxz8uHldMzZdtJpTC6QCyo_gzbYpGYPwledLJSvMqR5YJXTxgY_HGo2itPcOwnZ9FGTUtPDHAAFm8WtN_hTFxadAFR_Fp2FXnfLhVMTphc27ghKd8qwAhrar_7fejGfRggymK0P06n7qwf9uJeOdoK40gPteOwrpfFHvt7zFZJl3Yh6X7Cn_MxeBfPm2pxpUg0kcY3LhoSdpVO1qavyRgIFi8lKU0QCyonyHJLG7T7pPkUbcXMykH2LCm1gf7KSMf_Xyxr_N6d189MlF8P3CcKD3oF9VlnSCp6nPejFWMIk2nfkEDwVqJmIoiAThl0RX0RAd1dK6uE9vrT37xD20a_JBLFsK2lCaqLWAMtShamwXy7Re5Jc6MuYQnSgdkqYhGf0XGHEhWxiE0ir32a9u2xFaj6snniJ2dt46x2-RJiy7VodXcGwlztQmKg7XTnAX3MNCL2tQ3Z84us47FSpCAlvbMRJT9rSV3HN3HNlTWBPW3Qqu0Lc9_rSBWEaKqBVUQswKC88PZiMo8xL-8_jhgqzUrjN6UCgD_85tm3eT7SdtH7g_l2EoeRQuDCjBroTWsy6uY-bxXyQPOQIrddB4z7bDMDpFqKXENhzQDUkPANHNfWaGnGE6lon7xbz3pju86Ug_cvlApegx-ARCNaVEInsaDDrdcXPpoV6g2LZybfTjcesGVW5CsL4fQJCsgpK6zGvQaWJxVf3AFKduMzXlOClopm8maxmBymKLAWr0itBGBj7chTTubsfRlsG21L47WzvltaqU_i34Dv1VqmTa0OITsCUsQHzGGZ7u12lfX3HHaicQoqpaXGyv5y0qopSc-k-K4LOkWIeKpuJEMf1TWTj8tPFwcjlrjRpMWOexx6aoYLLnAi5ICbJE6YQc9LMB-7mrpKTbA0ZjlXkLQ1rYiT4LCVyynx7aixonSOTFTnOFTL-dZK833scm5zy2Ij2tqO8m2fFv2MIEI_t3N8WdCCJ3DIxTk0mKD-iwZEj4l6_AUEdlMy3PrJqQ6n7N8Dn_-g18LLmm7ycAc5Mv_5iS7dX5Q3UdcA5hEI_uRxIs4CjfZ04SuOn6I_FJA759l8FBNe2WMxTtOwPU5PMUCi0aFvmX9j14eYaPp5qKFB5P7lmxKu4Q5QSapab5LYKoISn14AtpEkcQK3DkHO4UVBwmmnCRdodQKlT98Neo_GwK".."mvayDhSAII3-0qb59KN2rOMtYOKtnuptLRH1YJZFeuZFa2C06LKvACxSv_ixcxY0_4XDuY5E2M4jeFA9vqxoo7bUkXA7-BrKiprqRO00PM8LgaQ7GoXWRSEATRnbUMy6K5w-8oDaAPY5XQ2kWYPlVhfr7DWfnTJLz8WPIeafgjlfB5AneK2Gr7IQesRzGt_W38Qc9fzEie2e-Mdk4iTwiCfo84Ip7P0eNyEqkKmR-vWBgF9ItVfE8JqBxNIpG1WPZmYIai3UCYfPd7hkKZuaO_SiQeCqadLkdX-V2gK9GG0G1s6SObQtIXJn6bropWGyMnswwsT787OVDA062GrCkSkp8tumphvo5iVBBjK5JsDCRj1ZDMEOh5xcj0QG4bYJXuO6SxVTsfy-nWdVYXmZTolE_RPnbdR7bfQ7nXVWAzrQwOpEw1P_86cmXxfRKVU8XpFOWl0ugNVzKCvEIP2kehXnRS_P8pfdcU_BFvmj2HDvBh8JVcTKaQEqsdUcTlGGLd5MqBz5inNiQwpDI7jXnLNuxfe6pkI3Mc-WxvBl2FC5N45CyPzvMSbsIxOM4HFNYUsUfeqSy8H8O6KCraR2QkaPHgfmBhoEOyMQU3l2rEYBmImBFwGsIoGecWXJYXrZD3heobOejc1mwaf5ke-nVihY8ioOeARdatSSEDTUD9C08oeqkusjvAiOghLixAIf9b1xjKpGAPL9kbeOzaqdjRkPqySIHYFeLjzapI1KNhd9RXbhK6rIXmPPIDJPase5FnbWQ86HKuL9D2aXNPTgzARrc92fedeD_gABjMSQsiuH15brdWsHDOdKvvxarwG0ulqWHFjpgJIO3fUTaojAdV06Fkn_Yo9Mc1GCsIcJxph810AQqjs3R6HBgpwmA7b6lOYvmkgT3AKA57YoPsa9OWOYTzELq8kDRLKmfU14j8-thYlaHjDfBvPIq3Ie60BPBt2c0s3HQMPF-n1IqdBwwcbKrOyRSzxfvQzY9o6muEs8Ts2ZQ1Zbqb-HpheBBgJM7h2Lpi2ELMGUJ52xkCVRXt8wAGL3vuscunnDeTo_cv3GBbjPXKTDIj1knW09lAgTZcZ3v1M5afR-7VmGkzj2N9Gxkd3esRcau8uQDS26pjBkC6ieYT884PhCnjE2ct3odig-6WFuTCR7zA3_6fLiFudN30dckB1DaiDplGeymkiBnrH513QuOR-451csgcv0XqWUdTDjeF_HcIAR24fhMtQskFrc1hMosBwugvOgxYK70tp6NieMJRWl-gXmrWNaORDEGEK7yvd_SQ5HLiYCmzHpqo1wiXx_mBKfG1EhWCQn2MOevaQQHyv-V_WdlrLORxz0zmAiV9zezXqX8ghKypZkAvUGfk9vRp8__jlgQD_nEmwdxjCgJw6_0WNq2lS20NynqVa8uJLt51amgjCfJ4LbtobpM0r-Tu-pUEgfhEIgblroAeNKpP7U_-tBRQksEJUl3JQEhUEhYJveeM2JDmPEQaBmxTfHM-CX_q_qQayad9cmy3XL84ufJwR1iiWwNPIuNLzAsO4YY0RJNvimV0HnxDJTqaaGZtQOmDcJPZ3_0XSc_ZSS56HV_zvKTAdNtYUfLJM2GgwuOtPy5T4UN7C4cQYLQLGVcniOdd-NM2XV13t9W4dzMeJ4GVHWHpLY2EdX8fReseCeeaH3HTHPabFEdCmf-yGTdJ9_bWwuRUfgHx0M7UKkVchmW8TyKiOsIjOh3QQ6cngSXG1D1D1EEjpJyAFzsVjlQvs5XwRb13CuRoUWJpC8TuMnNhcPfgmrp3SzE1BFel16OPSRn2ufWAaLydzB722O5tnbBU30c_Qd6BqerrnomZG3Uu4WWklv669VkJD1x97mJ9dj7Ww0I4YS2OknoDnP5_l7ZzNoaE2_rm7ClUmlWEnEEVk_ym1C-fvcBk3nlYZ3M4gRnxQ-i9vRoyt27iWv4o9r7BrYmGPcGpWpvdy00X-oEU1HiQHgVQS8MNM67X5yq_5zNWlEncZIiZmNmZAlQw5wPzv-MU7gw5u54nd3BssHt8CprJNI6ZRkfD4DnGiEPAJgXHEmZHA0qzIsKAEUrhwd3f4z33mLj43mMdTNBZPZNqpfL5Edmrkf3LTFNsSxw5oJUw5RzPId7XrI79JLV60CkmmdSh_yquYL7X-IP2Vke2Axd8FW3LpD-p4sx9MDhrB-rMfGL5_DLukxo_YPNDwO3_XpE_MDJvOoj0YcP6iaFjWC9cb-2AIjuIwjaG2lv5m1bosRYl4jCWN604Nr4omk3qi0U-4e4BBDHrMYXeSYjciDp-gUMcIn3J_1YtlLRydv3D-o7DD5O7esJrqckOiiupJZ-jXVP6zgMwJN3ngm98dfHw8LjJV11DH-FzwlXBWwrsgt-fDvNFM3qEb1XnRXW5aeV5Mfsg5iZfMomuexTfEIV26vaHIuGa9mn7-_1OPmAy6Nmg2Vn_kZqku2rBaN3HMKFc1kAvwsxCAjcUuHxAikLY7yq7m_XVn9ClOOBcx2xoiENFU70CEv6Z1gGs4vKYBfh7BV8NLYrwgW-ZcgPr0dZaT5q2D5nift3w39YsUlySygryCy5gKt2gnQzT5o5WiN9u6LGmqE3XsAK8rDeewGWKd_HImNIUO3KGTm5sh95a9WgmcFeT2WK4DjiDceKAft-Kskr4UmaFYKCC2Rubi8i8cOGPjXkUFGNanBZJwv2GWYanLonlPLdsGxro8MdWry7v2-GBEF-sqzSWaY1lQMr8qH0Px_I_RTrBhcxVRVmImiY6IzUJIZPmkJTwacMBFSJqabgVGv67OtsfwuiXD9qTx73445TWIYCoAXODzZ1lOn34pAFYxh1OP4-dczDn5VfYmo-Fc-LJldP-dVVsxQ5lX5AdF02hddeH7Kdwi3nC3amhMeri7o8n4IrPrFC0DcbV_2sMPa0OWA6V21Q4pNkxZaXfOKFzlZQx0NBKCBBzE_4uaFxbCW6i5IUOirGq8yeAFJWsa5q0uvsS_UxWeTzMMLGpcs-uk1U_Aw2tXCJIEH9tCw4luj8NktKgNnxGta9IBWWOyrMMItPlbVH7gK98G5-qVc-vAijgoPNrN1MIU3h4-_AvQ4dDNqR2sS5b59L8x6hox_Q8S8eiIfQbaf7Whg5OC9j5D5CVlke7bswQUVUDlULYFXrNkgo1bQ2ccDx0qV35cRV4Tp7V1gLn6itATFhYbrInsrtDLr9E6NrYaNj9xedu3tOJ48PDRNET3v3ogyGjY7lc_Bo7TDGhNjINB-LAiGE2ESecGuIBU3Yt9KjNRLj_wrL2ZoPf-5aqyedEDIKgEvNa0TnJCahNl-SoQuqEgtKIBk2w0q2RVzBt0L3i2-UcE6wYMtAx_5BkBF83AjDNT8a5QyzqLqsi_VIJ6KEUlJVguv5kks1G7zG3Gm8pgQHlvyU-tvAm7UMK1T_QkC_L2CuICDUXkdcatV4-LiKtPpTBaI50Wyb7bhYkIyl5i4jyi1YqrO1vn6CGkNd6YHw1erXd8VR6gWOy3KBpgR1RL0sctCaCZ1bPcJzT5O-QpCJ7S6IGEWm0WNyb13J_IUmI2LfjdB6e04LceLf8DLNUKzf32lUt6c9kdNz1IAPbHM3PEaKUMhB-CcVlm3VbFNyKgaYAGGJ8ihOuYxo_aJWts9_gj8ju7TII21d81cQnqFwUmDQXx1AVkafz1vj4y6VsQf-HaAJdXXV05L0CwXsL4bLofUTJS7e_vED2iwaUAc9HkPpCHDlK7q3jr3ZJywWwuNBXGbTMAx0sxN6crotztbhfA9pgQlk2QcC_DhIxPK9bQFKqTXB4OiJLaClKDa1xW4k9pEDMFnVahNq0l7v64PAIce8rHiWcdHEZ5vst68i1EqA5O_SUhK_o5zvmJMUY7QNujEpWcl22aHusnAz58SeVMTI7bVGCu63PwZuQAbe_lT5017uiDunOKF6xMINHaniZXm4hX0PjSBN3SrTPS7i8JHx1Wyd88GIxFYEE76L5_idARmO2ys8TAZf76NgpoDfbY6r_ZffIZKTPq"),
"_nYO2bYs1nv1qdlU-QP125hy2dId67hc68SxAT87TtP_ndtL9qmA2gdpUVhtz_xeIv6FUwBgDQ4bqekGseovvgQWflkNwKhN6WCOdMtT5Mamx_uydN68NSZY4kZlnKHgan_bv4SKzXZmE8RY4vsZr56wGUHMdvK4-uXEZvkStlBOY94GN1epib-ZITq9i1j7TOuxbreN-fEi0WVi_ExRezuhvqVW0ao30nCAr57Ik16LSkCIoejDs_E7wABaiKqzBZKyoWINFkBVHFuX1lwDtdc-Qo_ISCjsJtCsql1GYpip2mciSwCc_PPjoLLJzqNLNB0chPMhNlTt6bOvEtWPj4xsLof60yrClnt7DbSVOfJETtPFbz2hQV4NQdLYJcof85_CXFoSAHIPrV_KmjWXpUEkevHlThZYdbg8Fahd1KTLCh-HLohUvzT_4yCshUad5JJZCFfta6OjEMqtNE4BWSAZ2v8poPq6oUVRnPujVhWjHarELN7RDJRE93GBsp3akd0N_X8iVKxn9HJe_ry4bzh42baQDaN6rB-ZCiN1JHm-d1DZhbAs6Ni9pdvLtqDpcRDJDHJOYFfQOVrro37_9xWuLuioaeG7fY-_lljkh1PHGObUqd2HQ0AsOa0E10XJoctz_bHftFHT7bO2ValF0tmvBprMfn8ndhlIW7lwUxv0tX3Zzjdt0Sxu-rbs0DPTYoUgvTBNta5TotZrLzuOroPOLfx25-vM43nMNuNxNlQCO9hmUPTaITX5xuNF0bv7xis0rehT8JK4TjgoMN3A9Tz_hhk7_GWr4IGzH58iyMd-53jXwtbFW1XjyER2QhVkK6s5lUdtwW_WDFsTgfIDCVC7eE0C7qIXCvqzfEhRtLdcBrPK4wd15ITaruM3-cOzyNsINemUHSihnjy6s-CGyFlsYd1Or7AKWI8MlJ5xD6iESkbbMwzqkMU8ONI70ggZZ5mDlWEGW4Awm4wBcdOXYPjqA61B4vNq4AMWbHF4ExOIqb2vpYH0YKxx9o0ItBkU4CUMyXyyCUJ8rxBGaZctNRPKdKdLsqZBwPXCyu2U8cV0q3t0wmaplkuReJu-E3RMwaPb-w7NwVL6kxLdg35epTlrYYUjzkuJR5SoWWJMELgLwMi2VLddjnpSW_4FvUcO7j3WVpbZVxV9XKVw8nqZic_QumhvdWc1TK7lD7ivIIVNS6q4KWdErB4Ggac53BWaFuVXYuBuN4yl5bdQgWVv-kU7fLmzYLg8wYH6m77Q9b3O5wHjYFyJESwaC3XJAR-Rz2Pen34rhOVvSzEqE_SrjZ_iyKbw4GyK-d6jU4adKx8tDsbu5jW3KckjzVOHWImJw_IeehioxwMfE_ANI_9ihbd03WQpaNHJP9IGo1vyrPP1ZqK4l9up28gJyoYpAWyD1J8OjwMi3DagThKfEzNDp9mbzAlfIZqvArTFWiCNFqSND19uz1ozZZ2yfJFPfJrNYRWDPCnyKtpJsStBaAGd86ADVBCFP4RoJ4tiedxN124h4ISjc4eBUhVxAUEN4aieiDqmLVBWH3a7jLEU8iz-Kra39gC3_NN0R1eXFaSVgpu1Psktw2S8mRnqCmFk3L5aW-XGPbAgiJT282eykRdujW6BRK6cHIYVMleBVELFfmd1W_bqT-m2C__SnEe2uhJFStVVwd1n16H5qQBn-nS-JbGwtRd7-uaVoot1VBBFg3tK4e9GxWhbWWQANoJyeA_RI4P1D2wnIvBIGou767nEMsvgRtDvIXOXNBlH73-zQdUo59_Ao6KAO3uPLCD-wcgLVA4TTPde-kMUZpAHIwl8MufAJ-efd4EDYpjQAfWtQFczzuJEOKZd3HiuDKZ6eHNRz86Acydi8lltbeN-l3INm-cJU9bdjJ4WcQ9l_xk3V3Kr2Ui-Ojkyo_1TiPInxLe3LTfbo3PhyuJAAEHzoRLivF9kwAFATWJOLp8sGUtc93czbH0Ndqxmiors88IT7ot3dkR07WLyNzI3h36oKkC3LP9OjxUhxPqU3orBkcLfc6QBzLOCcO0VnZxY3ltEYOLA-lYe09JCWUsfRvW1wOcSaNstGSNe2E-8L6KEYKixRA85MvmcX2SreduuVolRaqDoms3TEdphS1g9PynXt188MJFwEMCKPkE6R1z9IEyBJ1h1du9gcXNgw2noUlUMjcKPEjigbR0aoOfMtvssNrjUIV3QPaEdk58QoWhFv69ou-s3yMKtDnZvCPKgMcuNCo7UPOL0OCWUJ2qp7-nPo9E8Qialdd3DA7bIhODgHRCy30SpaTFCM5Kwd8-BVeKgqyEHXRwoHISTb1NqYTzhGDmz5gN_M-zwsUhrx049lanzEm7Trs3iKHuw7r8fL4MWweS0w6W63dgP-HE_uZnwlGoAiyDdWDL5vv6RPpbtdk1qzRZrdCbEjsL-ns1rqJa8kfoVb8K7ppDZR85jSuBgmNz5WSLHjWmQ8K4w6X9F9eu7cQu_AJtQSadB0D9Htno6eDvtX1kn69uTsOAlOhjg8Qvu1oCV2mWGPWB3WiK-_Gq32ZsNu65anUZSEMbJGgBpbg3zz_n3F0ixXUzHNty-ezV_Hn4YUWKMeV6RgrXfdeOCwI1Zuzr1VmMQcF_0uK-u7u8YpbQxYKBjYFoKE5P_xdtQtlDzoKYtv6f0Rs0anM30vtUcpeIhhDJ5KxRv6SeZ-loKAhrUFybCbNVAVL3YKufztskp1KViK3e1pphtbLgR1CmCulH3kG8K6Airh5HL2AvFWVKm9Pj_2n8QWHbUtmA2PF3bUhe-e-WWPKvEoh_7UQ1FsQieFB4mte2nRRkmDR8X3t2gOXbesVAKY5FL8REfK1mznNcrbTJ0Gy_UTddhSR5yiUjBDOlZ3t38M69wn9XbqX-903G1wwR37Hu8YBXLIPqquAP5fglPzUUMf8JWjxV_tkMiaB-vr2G0ZiQ-ABSy-EK_w1xS9IFQrHHLFZB5l2V9dmRxAHkipzVOThY-tAZQUOpe9fyMG_HPdcuJJfcc_F8gR3Tq04XoG0GnIMJ1P3l2Q6eoUvqQDdYBSa-ou1WnwAguz8d45Emn02fOIW13M-tQLDodyDnhWwCArH7CkJc-ToCUNUvq24BxwCnC4NudlVMN_gDs4J_qYsi6OhiZH976_q8ybdnTW8_h7riJSzXsLrsVAf8lJHAY6MmLBNRAp8XH9Xwwdc6DBNshlmtSr5Gs_zl9CbkI-82ne3RK1B03zhyV44Mi1VCj34cUFNf5a0ewyxOJY5WfSvYBLzkydG5NNJxBzLF-VgMKpGsOWmP4VBIIZpgLOdaCzn75iBbuIyiYvgJe4jyU7kbqi8XeW_8YzGg1TIVIN7owrZS-2-vZ2AKKw07J-jHHAHppWU-hvE3Ah4Rrr5cYvZKNTNQqOslr1J70SWMkKaK_NdUIo8EFGbeck-E_g2XDTbxn5lx2RwYMMotPleV_Iq0mfSpQbPsgMBv999M531V0Y_oae6ReGoO8OUVTxITh-ddKF1X7lpIBKOZvhoGsJm38bp3v_dkVFs611V48b_pcrzGc6C6yC8zAkP2j4A1mfw3ti4zYxLmD5EYT2N__-MGvc4UMR7bSRtavm5RXDFCP2bQR70T4Y9m4t2EEHCVVZ8w_vk1ea2W3Ez46v3-_DcXYhszZBN3yC7_Uiik8r9SnTIVUxXDtZ26czGE0Em7cs9SfD8Sg5tWvc05ioIjnCVlWtEFhKnzaNjMP-Om7GdGa_53rAIY2NPeXxEoPUSyJ0ZMR18o8pDD1uGNp8Vt5fzxlmX6WL92A1InHXXFe50Y1ohc5oJ5l1ckpeg2loX30K6tf2TgWcF_tZQtogdNBJ2oLIm3my74QPvx_0U9fWtZPbfyEZsoCGJQFmP2d_qpx0tqauzQj-AHXZvxNWPImMlysADowdPZ8fr0uhlNz11u1oiT1aXaNKcDfARCfsXBoX6-pZGcm-ICV19TskO3eQbYuAAqUeXNzx20UrGCL1g2prYpnr2HhYoTRq8AES2U5bRprqKLz7GCmIXCXxMxYlwHYGSiTua8ggVBY2ATSgkTgKOQeORB59iFNM-fe3hYNp1FfAI5tdtVQqC_SjJ4fRbS08UZBGtDuv1emoLGFLrzrAyOAirnAiJA5H2puQdlNJSn99knTCaRi6G_pdTy2fBv4CYe0TZmMZewctmRVu8l38P_ltjebjH3U31Hr5G4-7f4sIca33WTxc_AdnpE4k5-yuMfWFgX7yoP-iHJuc4G7MZGv8LXuCm1ieXvas7jWttmoDVZAaBmnCkB8JeedKlVPFJNt-ITA-PdmdQqSDVobyOyVqGFsaZVvu-EXnsNJHdaVAayMLP5o5CdI6QRgkacb9LabgbaPohBMdfK2suLrmhBcputTJBQX_M8_R72-eI_N3b42O7uGBdv-opnX13bzF2DCvCsq02oqsozKEvvYnWF0mv6ng8yHl7BOi2_R8dsy5lcZ0sbDh8C2Hz4iMHBoIPlzU7UViPOGTwLcoMRnh7b8H_-lv576QEyzKahC0MIPbYPox4rGotc-HCXgKMhBdKyT1rx3fWBILJqlUvBmDDtbnQyObqimwRi5WFyAYBnSVen4mZz7hpaf8WwaHAicz-3jQpqAFE6oY7PLHOChVA4GFpQAyBxks6Xjyyle_zKuDKhAkeZz_fS46y7nc2g1H3iU44uINMXaMHbXWzawC6gOlJoa8RUqDkJLJzSmRaP5ZxJMzXXq1YyIQ5TVnXOv8Spuj1YiyFdkCPNGgKYm04z0f-mfJSPnOCnad330kc6wRmOdZKhza4vqmwizf8k2Syb9pfNONSK0FFyzmgNH959yJ2_Xe7N64vz1-ivHL1ULK4lElhsJ1VMkXjWO19GlSUSdBHk6iTv8HhHedNMpRA9I2qrwCvixdbhVkgYpa_f4jUEqEFZi6zdIlmVhs29qfgHrYcAX_3aI5tmV0dJ6VkfTc9eDHfC-sog1n8wnr5LZVQyBfezA3Pnlz1Xoc1U7ZXRo6W5aqPMQLYLCtwXhvjxtfvHiuMFSLjxLtsLsk4uEijlREYs7ExJLTLO1dHrpE7ayA1JnKs75saEr4stMUB8VyUkd-cQqcIDVj5Lr1zWOtrKpdM705FRw8QkgxmRXB24tcwNi8PgwUAzL3uRgUptV1hbTAcZRr6dRRI3e4UInQdfim1GjvHXNsbjRBJe9lSz-dzWNRWysbBRQ5i2xMtpooWqu8Q5WposV1qRFn_qiAfPCf35iwYSq_fQJQ9TfsoVfO1xjSb9vwR2-v8uPtSFPxMx9rDHQ0diPs9wtzqcOVADj2AGm2mAI8FIuAeEwVLvmbp3omV6zzNRg8n86jztOC35Yt9ajpYtZ6KRvPbWeMG6dt_DWx4fY6o368VQ-ycHkFZ9hTfLpmVQVk83fusBurJvefGpq68gOfWnudAqhzYdeeiH5Xhvh7Glb0BLMi_7ycBwDrdrSTFk2n38zx_E5aS0Vif3YG_ln0trJi4BZ82DrbWyGbb9SsxqfRitPZGUy-5ZkL1imSr8iwOtry33gXVf7A4dG0Xlsd5WRGfHB6pwhUQ3z2_Magm2EGKoE8CfyOmB2iNyasQ5-YexElaHi7DCJm3ya4odQphM_MgXu8lOYdkpDvJeQQY1TWVCcftfydpIwk11m1G-EjBVUIeu40Qbp8Mq4UABTaVPWQAmEkT05AnwmPzWzkPoP8CeX9qWNE1fP-uwgKxRC15NkmRpHHIDkyH5jCsnDTkoVktm_T2qjVOqt1QNBkSN9NuRz4GlX9b1-oZFC4aKTpNOQBn4MW4Qup6wcInisF-5dx8mDqlZl2oGuyjZz_iLYC9A8TkTPA4e47RyKj5dWRoMtMKFe6vFJJakVqB4GsvcUVDFvY6NqiJGjuTtDtQGqrTdwAzD4YRXeM4Os--FEXa-q1OQyAVKUgJmbNpjb0DoScGG8Y-3s1U2aolLMmd0YkyfE2XEW6q1EeXfsfpwimcBbCAnYe-IigRlRhVTKUAONsKNT2B-QJPro5tFQYcOH27KotjzmNhQZeSj1o8ZZjjmNmUmsH4NZBdP4Xeeba5BgDhP7KNoZJt7gSj0UuLs5uyPFtfd8Du_zaV-3d8G0lXhKduC6EP_xwvEIHWjxe5yAQIkA1ogG6r18HBl7uEDPtOvUM1wvsl2IHY14nM5St7KxP4MyC1YmPx__mzCpXUiQL0216Uq5XW714HlUkJUnnFZyVSWyNn1wQgfaY4d5lMzL53_uvZj1f9w_h5ay_wnG8nGDLR5mkzACxevZmFvEDlEK_airgRjP5og_meVQcrdUnEd6RDpWrzrThDLSxzDhGyhZ7B2IB-G1vKtfuc1RHb2dy-4heepaPUnTABljKpbQSOWI6Ecf64wiKvugpZMnnmfTD9CVYYrQzCESMK3vbpBlWZSM1g7jHoknkcdnWhr_TMBXbowSxBndR_iqVcncR7vHIjCk1ZyOHUgOKhDEZlXzCiKfgD0ddxk6n0XkmddLlF-kna4hrLDpMwCggNk_HpBDtAPBvRgglGzO9LBOKyn_EeF4llaWvJRqu8oaUM0UOu4AMXL5LfsD0CSbV4x0ssSbM2YBZOS_NFpef0_nszmm5FtuSdf1OhJ0Oob1K1REWcCP8tSYgRtsV2TstUjLOuIE5isBl6KYln_IfyKqNLxKH1FIEaRCOI5J9FulhszIweOcqT4177vUi7tzPFLu4PUYzVvBK6aU_YVJvP4NBSaEVw_oeIcwkji8XJSiO5N6KVeOFtzb9ApeB7GHICreu5Urn2pSP5JxildJbbez1-xXyDWt8rTIH-s2Qew2n-8cjl7BR5ndT7H2lc6cEBqf4ubaXxy4k0Vwm15zHLI1KJusnE2asIF6LnOuIEV-pCQdCxtNikvUl0_bZttxucM0aRMUzcgdMVAJFlfHRoK_tNyymcR2bLMymQP8AUNoqzi3Ii9HnVCI53IE1awIPduWvj1MPm62lBmhz3qIeoj7DJLh-T4b0MESnDgAKAFTZyne",
}
local _0d={1,2,3}
local _a={} for i=1,#_0d do _a[i]=_1[_0d[i]] end
local _2,_7=_c5(_0e(table.concat(_a)))
if _7~=1080841460 then error(string.char(51,49,53,54),0) end
local _259
pcall(function() if type(getfenv)=="function" then _259=getfenv(1) end end)
if type(_259)~="table" then pcall(function() _259=_ENV end) end
if type(_259)~="table" then _259=_G end
local _f,_3ca,_62c7=_ex(_2)
local _cb6=_tv(_f,_259)
return _cb6
end)()
end)()
if type(_d154e2)~="table" then return end
local hwid,_d0f08a,_f02fbe,_167796,_43abcd,_15c809,_c197b9,nap =
  _d154e2[1],_d154e2[2],_d154e2[3],_d154e2[4],_d154e2[5],_d154e2[6],_d154e2[7],_d154e2[8]
_d154e2=nil
_eee148=(function()
return (function()
local _fa59={}
for _gj3=0,255 do _fa59[_gj3]=string.char(_gj3) end
local _0={}
do
  local _ne0="WrMBoEFp7yPKJwHDxL81Nd0Uh_ITnlsz6t35afbROqYg4XcmZSGQej-ui9V2kvCA"
  for _gj3=1,#_ne0 do _0[string.byte(_ne0,_gj3)]=_gj3-1 end
end
local function _b1a(s)
  local _ubl,_bim,_ug4,_bws={},0,0,0
  for _gj3=1,#s do
    local _388=_0[string.byte(s,_gj3)]
    if _388 then
      _ug4=_ug4*64+_388
      _bws=_bws+6
      if _bws>=8 then
        _bws=_bws-8
        local _8ed=2^_bws
        _bim=_bim+1
        _ubl[_bim]=_fa59[math.floor(_ug4/_8ed)%256]
        _ug4=_ug4%_8ed
      end
    end
  end
  return table.concat(_ubl)
end
local _9={}
do
  local _8og="?9\157^\021\202\\\209v@\233|w\235UTr\242\020\154i\243\244W\250\195\002\197\194\017\023\252\236\223\167\145NP\161\212\162'\141\166F\214\158\144\2173\127V\147\245\153\239\219:\183\251M\009Z\011J\181\007\232\211\027~p\179\015\240t\249H5\238\201)\019\139#c\175_$\192(\151\001e>\0088\191\246\241o\155\014\1634\134\137\222\165j\184\221\189\213lC\206\0000&\220f\171G\rgq\n\136\031\030s\226\187\016`\218\006\2151\018\133\005\248%\142\229b-\253A\200\022!2\225\1747,u=zK\169O]\132aQ\204X\178\203\185\190\146\188\234\196\128\186\199\193;\230\176\149nL\130Y\135\140+\170yR\138\205\182* \012\216\148\255.\172\"x\231\143E6\150\025\247\164\003\207DI}\173\152\168[\224<\254{\177\180\228m\208\198\026\210\028\131d\004\227\024\237k/\029hS\129B\159\156\160"
  for _gj3=1,256 do _9[string.byte(_8og,_gj3)]=_gj3-1 end
end
local function _27(S)
  local _r9x,_xd4=1343698445,212
  local _ubl,_bim,_2ac={},0,0
  local P=260691 A=-1789200111 L=4855594
  local K={202,38,208,165,26,93,207,161,211,81,84,202,160,36,85,251,99,3,218,27,217,130,245,202,133,128,0,228,109,78,155,13}
  for _gj3=1,#S do
    _r9x=(P*_r9x+A)%4294967296
    local _2d8=string.byte(S,_gj3)
    local _jel=(_r9x%256+K[((_gj3-1)%32)+1]+((_gj3*113+L)%256)+_xd4)%256
    _xd4=_2d8
    local _dft=(_9[_2d8]-_jel)%256
    _2ac=(_2ac*33+_dft)%4294967296
    _bim=_bim+1
    _ubl[_bim]=_fa59[_dft]
  end
  return table.concat(_ubl),_2ac
end
local function _zo(_tw, _ey)
local _vr = table.unpack or unpack
local function _gt(...) return { n = select('#', ...), ... } end
local _ru
_ru = function(_br, _md, _nx)
local f6o6ld, _zv, f6oifg = _br.f6o6ld, _br.k, _br.f6oifg
local _ja = {}
local _sg = _br.f2tjvo
for _qp = 1, _sg do _ja[_qp] = _md[_qp] end
local _jw, _ux = {}, 0
if _br.f4q9gx then
local _bg = _md.n or #_md
for _qp = _sg + 1, _bg do _ux = _ux + 1; _jw[_ux] = _md[_qp] end
end
local _fz = _br.f6owfh + 8
local _qa = 1
while true do
local _bc = f6o6ld[_qa]
local _ni = f6o6ld[_qa + 1]
if _bc == 22 then
_ja[_ni] = _ja[f6o6ld[_qa + 2]]
_qa = _qa + 4
elseif _bc == 26 then
_ja[_ni] = _zv[f6o6ld[_qa + 2]]
_qa = _qa + 4
elseif _bc == 40 then
_ja[_ni] = _ey[_zv[f6o6ld[_qa + 2]]]
_qa = _qa + 4
elseif _bc == 28 then
local _yj = f6o6ld[_qa + 2]
local _xt = _ja[_yj]
if _yj >= 256 then _xt = _zv[_yj - 256] end
local _jl = f6o6ld[_qa + 3]
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
_ja[_ni] = _xt[_jl]
_qa = _qa + 4
elseif _bc == 13 then
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
local _fo = _ja[_ni]
local n = (_yj == 0) and (_fz - _ni) or (_yj - 1)
if _jl == 2 then
if n == 0 then _ja[_ni] = _fo()
elseif n == 1 then _ja[_ni] = _fo(_ja[_ni + 1])
elseif n == 2 then _ja[_ni] = _fo(_ja[_ni + 1], _ja[_ni + 2])
elseif n == 3 then _ja[_ni] = _fo(_ja[_ni + 1], _ja[_ni + 2], _ja[_ni + 3])
else
local _xt = {}
for _qp = 1, n do _xt[_qp] = _ja[_ni + _qp] end
_ja[_ni] = _fo(_vr(_xt, 1, n))
end
elseif _jl == 1 then
if n == 0 then _fo()
elseif n == 1 then _fo(_ja[_ni + 1])
elseif n == 2 then _fo(_ja[_ni + 1], _ja[_ni + 2])
elseif n == 3 then _fo(_ja[_ni + 1], _ja[_ni + 2], _ja[_ni + 3])
else
local _xt = {}
for _qp = 1, n do _xt[_qp] = _ja[_ni + _qp] end
_fo(_vr(_xt, 1, n))
end
else
local _ig
if n == 0 then _ig = _gt(_fo())
elseif n == 1 then _ig = _gt(_fo(_ja[_ni + 1]))
elseif n == 2 then _ig = _gt(_fo(_ja[_ni + 1], _ja[_ni + 2]))
elseif n == 3 then _ig = _gt(_fo(_ja[_ni + 1], _ja[_ni + 2], _ja[_ni + 3]))
elseif n == 4 then _ig = _gt(_fo(_ja[_ni + 1], _ja[_ni + 2], _ja[_ni + 3], _ja[_ni + 4]))
else
local _xt = {}
for _qp = 1, n do _xt[_qp] = _ja[_ni + _qp] end
_ig = _gt(_fo(_vr(_xt, 1, n)))
end
if _jl == 0 then
local _ej = _ig.n
for _qp = 1, _ej do _ja[_ni + _qp - 1] = _ig[_qp] end
if _ej == 0 then _ja[_ni] = nil end
_fz = _ni + _ej - 1
else
local _th = _jl - 1
for _qp = 1, _th do _ja[_ni + _qp - 1] = _ig[_qp] end
end
end
_qa = _qa + 4
elseif _bc == 4 then
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
_ja[_ni] = _yj + _jl
_qa = _qa + 4
elseif _bc == 11 then
if _ja[_ni] then _qa = _qa + 4 else _qa = _qa + f6o6ld[_qa + 2] * 4 end
elseif _bc == 2 then
_qa = _qa + _ni * 4
elseif _bc == 16 then
local _xt = _ja[_ni]
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
_xt[_yj] = _jl
_qa = _qa + 4
elseif _bc == 42 then
_ja[_ni] = f6o6ld[_qa + 2]
_qa = _qa + 4
elseif _bc == 36 then
if _ja[_ni] then _qa = _qa + f6o6ld[_qa + 2] * 4 else _qa = _qa + 4 end
elseif _bc == 12 then
local _yj = f6o6ld[_qa + 2]
if _yj == 0 then
local n = _fz - _ni + 1
if n <= 0 then return end
local _xt = {}
for _qp = 1, n do _xt[_qp] = _ja[_ni + _qp - 1] end
return _vr(_xt, 1, n)
end
local n = _yj - 1
if n <= 0 then return end
local _xt = {}
for _qp = 1, n do _xt[_qp] = _ja[_ni + _qp - 1] end
return _vr(_xt, 1, n)
elseif _bc == 21 then
local _yj = f6o6ld[_qa + 2]
for _qp = _ni, _ni + _yj - 1 do _ja[_qp] = nil end
_qa = _qa + 4
elseif _bc == 23 or _bc == 5 or _bc == 25 or _bc == 20 or _bc == 43 or _bc == 8 then
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
if _bc == 23 then _ja[_ni] = (_yj == _jl)
elseif _bc == 5 then _ja[_ni] = (_yj ~= _jl)
elseif _bc == 25 then _ja[_ni] = (_yj < _jl)
elseif _bc == 20 then _ja[_ni] = (_yj <= _jl)
elseif _bc == 43 then _ja[_ni] = (_yj > _jl)
else _ja[_ni] = (_yj >= _jl) end
_qa = _qa + 4
elseif _bc == 30 or _bc == 9 or _bc == 1 or _bc == 37 or _bc == 14 then
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
if _bc == 30 then _ja[_ni] = _yj - _jl
elseif _bc == 9 then _ja[_ni] = _yj * _jl
elseif _bc == 1 then _ja[_ni] = _yj / _jl
elseif _bc == 37 then _ja[_ni] = _yj % _jl
else _ja[_ni] = _yj ^ _jl end
_qa = _qa + 4
elseif _bc == 19 then
_ja[_ni] = (f6o6ld[_qa + 2] ~= 0)
_qa = _qa + 4
elseif _bc == 38 then
_ja[_ni] = {}
_qa = _qa + 4
elseif _bc == 34 then
local _xt = _ja[_ni]
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
if _yj == 0 then _yj = _fz - _ni end
local _xe = _jl - 1
for _qp = 1, _yj do _xt[_xe + _qp] = _ja[_ni + _qp] end
_qa = _qa + 4
elseif _bc == 33 then
local _yj = _ja[f6o6ld[_qa + 2]]
local _jl = f6o6ld[_qa + 3]
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
_ja[_ni] = _yj[_jl]
_ja[_ni + 1] = _yj
_qa = _qa + 4
elseif _bc == 24 then
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
local _ms = _ja[_yj]
for _qp = _yj + 1, _jl do _ms = _ms .. _ja[_qp] end
_ja[_ni] = _ms
_qa = _qa + 4
elseif _bc == 29 then
local _hq = f6oifg[f6o6ld[_qa + 2]]
local f9nggr = {}
local _ln = _hq.f9nggr
for _qp = 1, #_ln do
local _wo = _ln[_qp]
if _wo.f5esfz then f9nggr[_qp] = _ja[_wo.f5trmq] else f9nggr[_qp] = _nx[_wo.f5trmq] end
end
_ja[_ni] = function(...) return _ru(_hq, _gt(...), f9nggr) end
_qa = _qa + 4
elseif _bc == 3 then
local _yj = f6o6ld[_qa + 2]
if _yj == 0 then
for _qp = 1, _ux do _ja[_ni + _qp - 1] = _jw[_qp] end
_fz = _ni + _ux - 1
else
local n = _yj - 1
for _qp = 1, n do _ja[_ni + _qp - 1] = _jw[_qp] end
end
_qa = _qa + 4
elseif _bc == 18 then
_ja[_ni] = _nx[f6o6ld[_qa + 2]][1]
_qa = _qa + 4
elseif _bc == 41 then
_nx[_ni][1] = _ja[f6o6ld[_qa + 2]]
_qa = _qa + 4
elseif _bc == 27 then
_ja[_ni] = {}
_qa = _qa + 4
elseif _bc == 6 then
_ja[_ni] = _ja[f6o6ld[_qa + 2]][1]
_qa = _qa + 4
elseif _bc == 31 then
local _xt = _ja[_ni]
_xt[1] = _ja[f6o6ld[_qa + 2]]
_qa = _qa + 4
elseif _bc == 17 then
local _xt = _ja[_ni]
local n = f6o6ld[_qa + 3] - 1
local _qp = f6o6ld[_qa + 2]
while _qp <= _fz do n = n + 1; _xt[n] = _ja[_qp]; _qp = _qp + 1 end
_qa = _qa + 4
elseif _bc == 32 then
local _fo = _ja[_ni]
if type(_fo) ~= 'function' then
local _xt = getmetatable(_fo)
local _yj, _jl
if type(_xt) == 'table' then _yj = rawget(_xt, '__iter'); _jl = rawget(_xt, '__call') end
if _yj ~= nil then
_ja[_ni], _ja[_ni + 1], _ja[_ni + 2] = _yj(_fo)
elseif type(_fo) == 'table' and (_xt == nil or (type(_xt) == 'table' and _jl == nil)) then
_ja[_ni], _ja[_ni + 1], _ja[_ni + 2] = next, _fo, nil
end
end
_qa = _qa + 4
elseif _bc == 10 then
_ey[_zv[_ni]] = _ja[f6o6ld[_qa + 2]]
_qa = _qa + 4
elseif _bc == 39 then
local _yj = f6o6ld[_qa + 2]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
_ja[_ni] = -_yj
_qa = _qa + 4
elseif _bc == 35 then
local _yj = f6o6ld[_qa + 2]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
_ja[_ni] = not _yj
_qa = _qa + 4
elseif _bc == 7 then
local _yj = f6o6ld[_qa + 2]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
_ja[_ni] = #_yj
_qa = _qa + 4
elseif _bc == 15 then
local _yj, _jl = f6o6ld[_qa + 2], f6o6ld[_qa + 3]
if _yj >= 256 then _yj = _zv[_yj - 256] else _yj = _ja[_yj] end
if _jl >= 256 then _jl = _zv[_jl - 256] else _jl = _ja[_jl] end
_ja[_ni] = math.floor(_yj / _jl)
_qa = _qa + 4
else
error(('E'..tostring(_bc)), 0)
end
end
end
return _ru(_tw, { n = 0 }, {})
end
local function _kq(_ms, _cs, _pz)
_cs = _cs or 1
local function KMVX8(_ni,_jl)
_ni=_ni%256 _jl=_jl%256
local r,_br=0,1
for _=1,8 do
local _iv,w=_ni%2,_jl%2
if _iv~=w then r=r+_br end
_ni=(_ni-_iv)/2 _jl=(_jl-w)/2 _br=_br*2
end
return r
end
_pz = _pz or 256
local function _sv()
local _yj = string.byte(_ms, _cs)
_cs = _cs + 1
_pz = (_pz * 3081 + 8446) % 65521
local _zv = _pz % 256
local v = _yj - _zv
if v < 0 then v = v + 256 end
return v
end
local function _dx()
local n, _ab = 0, 1
while true do
local _yj = _sv()
n = n + (_yj % 128) * _ab
if _yj < 128 then break end
_ab = _ab * 128
end
return n
end
local function _oy()
local n = _dx()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _zz()
local _br = {}
_br.f2tjvo = _dx()
_br.f4q9gx = (_sv() == 1)
_br.f6owfh = _dx()
local _di = _dx()
_br.f9nggr = {}
for _qp = 1, _di do
local f5esfz = (_sv() == 1)
_br.f9nggr[_qp] = { f5esfz = f5esfz, f5trmq = _dx() }
end
local _wd = _dx()
_br.k = {}
for _qp = 1, _wd do
local _rb = _sv()
if _rb == 0 then _br.k[_qp] = nil
elseif _rb == 1 then _br.k[_qp] = false
elseif _rb == 2 then _br.k[_qp] = true
elseif _rb == 5 then
_br.k[_qp] = _oy()
elseif _rb == 3 or _rb == 4 then
local _pk = _dx()
local _gp = {}
local m = 239
for j = 1, _pk do
_gp[j] = string.char(KMVX8(_sv(), m))
m = (m * 217 + 187) % 256
end
if _rb == 3 then _br.k[_qp] = tonumber(table.concat(_gp)) else _br.k[_qp] = table.concat(_gp) end
else
_br.k[_qp] = nil
end
end
local _lc = _dx()
local _zk, _oj = _dx(), _dx()
_br.f6o6ld = {}
if _lc > 0 then
local _km = {}
for _qp = 1, _lc do
_km[_qp * 4 - 3] = _dx()
_km[_qp * 4 - 2] = _oy()
_km[_qp * 4 - 1] = _oy()
_km[_qp * 4] = _oy()
end
local _kx = {}
for _qp = 0, _lc - 1 do _kx[((_qp * _zk) + _oj) % _lc] = _qp end
for _qp = 1, _lc do
local _rq = _kx[_qp - 1] + 1
local q = _qp * 4
local _wo = _rq * 4
_br.f6o6ld[_wo - 3] = _km[q - 3]
_br.f6o6ld[_wo - 2] = _km[q - 2]
_br.f6o6ld[_wo - 1] = _km[q - 1]
_br.f6o6ld[_wo] = _km[q]
end
end
local _ge = _dx()
_br.f6oifg = {}
for _qp = 1, _ge do _br.f6oifg[_qp] = _zz() end
return _br
end
local _hq = _zz()
return _hq, _cs, _pz
end
local _07={
"d4alclB6JbJbl3vkqobNYtZjHbWgXXAd-NGGR7th-jDErsw7Rrp_AshaNaEFZawFAEc45hcL_dR9w8f0Y2tIe0vOfbizNmJ4qq74rKu_wvStP-Oir6rQY5ANM7YU5TwUmQDJuZmZbSGyxX8ERu1Kg4wc7pjF0Jk2z6ZKPXsAdjeoMc1GuLbiR7MdvG22UqAAYpCTthL_EfuZdgBUK2yDFC4rr-YmvjpwRZh6KyIyajOhA52Sc8YNNQsRwR708jOUk000WFkIfg_HIfZzSw9WY-DFJTktKPGjra_Q6meqFCL70ublQwhs1Ok24uWV2qArpmfmqEkEFcnfNFXeOUf4GsK4QFquFvujZCmWUmkc4i7CTVvatDhYaKGHOe4aDC5M_DC7v1rnSAHMh_-zYLApvXHTgbU7iS6PRYbU8i3uYYcwl0lADlqqqH6NKkcx79R7BJBlwkvZDO3SE5rd7U3FyCcwSSYEcoto5zPDIumh7CcT-gsFsjmbnegKz23bzZtbX7qAfEAjdL7B5Yz31jB4vmDu4lwmsfUqfogNoQbuN31IH1j_NygwDDncllWH_SZQWL4U5cFfBcGPq79FPbXmdO0g1aRZARzzHl_FQvwTNfMMWSxMHhRryPB7QAWE7GpiEXjLva4HOfad5i7g7H9_rKX2J3Bz7XWC512qbLdf4izo97ra-9VscE-aYoNSUIcScvoyxItpLAMmwSMCKe2w40jdlYd_MVU7crqx7EuF1RsOVKvOcsU2kpAfTtBpC9M1h8UgE9zt9X9pA9uVIsFgKhrEDsgmiSOoyNUynPN8GQqGMXsjbNR3WfkQLtjrbJhrgOMfrnTONDXKJ0cYS7j7ULDUMYarKaM_VxTLDSKts0fl1W0obl1X0xgdcvfeNQEFScY-RWM9AxLV2lhe3ooPTDKD1B-vao3fgUjk0KQ7DbDFDKDpVDAg-Tsr_GLvFhhgMFjop_Vm0JqXlGPwDrli4eT89Ojo8YRDSkEpc08v4ug8Eq0C9SrmadPlEoQ1C1gqIv3AN9qOoryWx09zYx3LhThFEcEDFvUrMUg3jpv8MljqUvli-c9Bwd8_BgF_yyPp6rc1oNGkj0WZQ76La-s9-RLaQWQ5pDtbvGwb7zyZilVeU2Vh_vChKi059XuiHqa_VG3HVQbv00kEmyt2WzuulEWaxsy0cOLZxgJ-HOueNh8qb3GRh__TLcVw7KAcmvrEEQx43XaoGcp0z1xQmMjtY5yN7-CnQWpomqS7N7f5b6xIr39ti_N9mNvpa9kh0gnlhFFe4r3B4TDORuJBrJE6DO8cFt5137QlyQ6hWK2-qF_vcTF-uuN7pnL2PoL5MRZFZrJnTw3YyqTMvruzoMsSyC4XDk5qSG2kWktGbwk3a3yOkPaNPmPrYh9Wl9mg_Sv07nqkRq_E25ZF6WPUAIycEsVut1v54u21dsuv9rFEp7XjH24Yf2t107f5YsfXju9YdTmkvZdl0YPG5aYNtmmvphg82Pae-Ei1-iGU-Top9OZYNfbwsnMSYXGkEiMPKrr-vX9vr5gt4ibOPSiwu8gadddR-bFGk2Tyu36AalcM127Faxr0ZYJmyiwDGMFEraeMIizSBl6Bid0OFKVEo6Mc0nUoN-L9_Dcv5O9QyBR9yCJSWTNe70iphCh6-QkRxUZYagf8KGZfoQi7Y4_LeulY1BxUcRS9FtwfxMEwN4CPF56OxK8gm-DxYiz0evwnzmftas9TMYVxuOqI-Zo00XvniXf_brWQ1G8vxfbrgTm2ezznHsWqKinmlQPo4bDK3_zioQoNENg-knLAaLk5Y1v2x4XhwUkUYnlfYEzg1dfBOGKbItxplFh-gAD1ZTJaOmRnysN-qF86c67qTZm3MTiAxjcsPBPY6s4C8vW2p_KZW0tRw6BusJ8usdr-umrTUwjLgnM-vXygkZDR4ZjZBfp1YJmG8S9wsGGYokEC3MGN87qhwEt0SJkSkzxrY64iaRxfMO1ino3bcmAkRRP52MuHC1SX71kGURw-S7TsrnpJXemztHv-I4khphEP-2Wi9s3TORhzVRlBIfG0l0Fq2Hpv9KClHbaywAuNAr-oeVLl6sMm4gjbwLkwkKWIt07vycQCwGScyuo9T3N4ys6f6yc2iO4vxW9TUjSrT7NqMpNB_WjBNAImu3RcQZrSkSbp6bwbroxBSTxfv9bAe9QArLWnz7dVD_cTw4h_WwVbp7GxDQXFFTWxY2WvFmnOQjXoCjzBZpqYDRIvmUPkgkE8QofLti1e3V9JysplkNyHIJ-IZbUnNdNy-qg0SlmEjhizQq9F8Dq-T3Ape7EqrtS7bki1aQqeeYZ1qzV2ULcjRss2y8nJzjtwrc_My3cWv6N9QjWknm-iqCbDs15mkGUONwcTPsxvJT278nudZOSNzsauYapPNRH2iDy4D0QGitjC7b22-OOK77NWc1akl5sE46MAreTJX1rt5voUyjPVnoiZu_lfBiN4IIldw1Tz5KbCpX-AbthNywyu22vApg8sUp_7-ukSlIFbIYqwQh8aJ3MBl7MPJwhRCccliE6ZB5fHWVMzOI7UFwjulo5z4R4Jz0KXp1R6DL1bEIqkWUV34In3cILX19Q3d8WT2OtfwxKgr9ISi_rgpsC0_G1nu3ipk_fqu7ZknAYIsVy5CfAawcFWfIwvMh6OHfCZu7jgdlwMjWk-BjtGhDZKEdOFK5bV4q2Q4QIK5uys41eMRCeQ2YeqSaR4W_w-CLH6xaGBWQVCALygtPyH00zZbGrRwoBvptQLDKIbZYQL1A111XGOyeePN5xzDOdSK4hc1rN1Dck8S_bDR7eDpEAMbwKiWZyN0ijril7diDhCjJZVxMUsC1HDbHdQHHEaLLGvC36f0iSVNU6UU5VTvPccJVomEMxwy2-zHQ0bwMBCCFJihNnMfc3foL88uYiCg9X2gl1FJPc2msTeKoROREARIpORXuEZnosIuCZc5-G-b_zRiAbrlshkAiJP72evdake-8xMxIY8EsYF497hjmwpvKbFsavJ9MTw56sXqpUn0jIwTaL4z-j597P0Qfl3ZIGmFabu7QUZTMIGfb2mG5uqevOQywqUuQvOJOG4Xft86Ho-AlyQEqNMB3GyS3f7tnWilYysOUvMk-7qBJihN2w3Nad9s2-7GA0x2W8JE2tUJJnqpFDo1aMT-fZmPnOocderWQdP2YEMM7QrOswPUpVLFjeYI07uZeglXntyczFeVZVVMCoHu6FHDL_ynpa1F5T3NrqAF19Eg0Ux2zWlH7I66hei4qhO7kb8CNl3onSSb4sCW_PCi4ENZYIn2YXq6QGe_ZmTjkjBXhE3o0xpfrG5Ea0Xjznt-irFbc8Z1QYFlWYFMc2gg_UDCOTqfQE_RdYpuU7cs8RBMVeHk8MbKyK_14Qc5xKa9r1S2KvgSz__jkBSr_RJkWCg8F2MFyeznPFVhzCFN0Brr2jnfvyH0BrnOEi-AJOQ169SeVpnacvHInRWEw8N2aORGqa8-Ej950z_2bo2LVEvPKW0bjcix7xC9gdfVdWFMkt6hP63kcOFH6sBpLnviJ8GAY40Bsp_RATMXrfv0zG1bH-6BZJb4qRO2_MdvveSSM4Th0Hz4-CvqI--TKFLETnuVImCtfse2aDStgVOZ6OQYS4699SW-JvRGAEI5Qn6Q221HYTl_fbNkc5GHQRGWBjSf_ZJLv7Qrlo7T-wXMYhKgXAd9ZZcDJUXl-UFgCfnbxBn5wLsfgn_bzygRMR9N_e7UCvCLxsjnkDeMFxofdH3HBfu0sxolk3Ue6Mc4rPiaWF2BJRm0y0_ue6Nj9QJDPmNd9aWRTeM10C8Z_P32v3kkZLdj1rMnCy2-eroI-sO6HWVXAbFo-qaznuDpd-h4yga8ycL3n_Q3pAfKEqKm5QdNsykkBxhFVaklYtWe2pzCUJnT4y5f2xMGa3luCFo_PL3_vQxoiD5FDr6aadcKxJ6Du6c8rsElGc2d2wZs_0fS7M1ayO0CjIiR9KllHa4YqLb0PZbkeU8WDBXWgRJTc1kCnxGA0jpVWAB6ts-T9e9Op63NRfGft6ED2Fj5z_VcO3oCk8HXPT5IDwmoD7cP5Pyy8tGkk5CT4sseqNa-PcIX2wmguIOY-O5Xog7ya-De5Wga6MDfw2MZ8x13QoSENqDsyrDcMtlmjdx8a5EXXjST5iZ6gOYZVxVo9aCgu08-TR6PB8D9AZ9ZXQDfubuUoxalWweoUmKWwzEWbqcUER8duUMC6A1TNwTq4YIEt-sazpQlT46MBfUqOQngNLw03Wf4YlmHVg11vWemOcn_j91a4L9VIuCPT8o6GcSO3IXlRpUMtL1GVZ6BtsOK3I8khz4RA_aqOK5qfPYu9N6z5VZ27aCDizGyp9s9_iSjv1LjQg33wSB-FDWGEdToE_cuxk8P_rpx-OrAU3RQi1WQf8ymKcfWk8W7LSKham5u9GNda1t5snW3OKwoK9y9M5jiHLnrdXy3ur0B7fqsYWLZGCv_iirtV3eVY6EgIuLgXqjP5Bt5gyPiARf1ojb-IwaU-1lAFpd6-hiLRKHpd85kI2lWYpDqf0pWHtlyUkLHm7bWo2gTH0ZhSeMRwY1j7zwOr8lPK6dv4j3XJbi9kSDx6omjMMgYsdfDip1e1tBjf3z1T0xVKqcY0C-IDmSOO4NDhWWmbXvkprlsMomeDp5lFoi1-y1Ae7VHdPrMKJyhCSdiIIOU9rqEqfK-kkb7vt4rZxi32ii40zJ3E21Ff4xBj4s9-KhPCTkTfT1qbRG-aysCLisW4_aTr08h_RnIiptpn6s09sK12Qc_j_fdBdrLoZRJ4OMc9SwmQsRWvshsswvZRbiRRSYZA82mrREzRqD2vzzyUkyM9dCgDfUzIGLwqVu2Zx2KwhIUA3FY5sJSsOuilYERQREh5yHAVD5XMpqRMaUESzLV1Ps8kU5sRVkfANFnLm1lM99CWpnRwa1CF9kx690oPHRj56gVzqsL3LVhllhbVDifzSrtKy3iMClC_K2SKN08AqZYeJ8TWR0SJms_iVo_2l4pvC85bJh7J9-IVqoLSzHjz3i_6ngUa9EV7HUQeMpTY_t9ckP9EUtD4TZuorlpIXRVUzXbzMrz1tpjy_8kFO53C828KzveYazQ0w7yBa7ZMxD4nhf4jJ-PnWeO7-O6Qs2R6PEOXnbOpXEvPRLc2FCsf4zyNU65LWLFDcH9KRr5L8JX4Jp1kRNUD3Nr28wT4C77bV8fkDHtOhfwBUPJn-brKriP9DofNJujLXEF4TCxrn7XeftGJNai1TEXgDJf2DPdBLoLJd4riniJlBbjvQ7b-QWFy7P3wutnOni0Y4CeW4WveUN5Q1JSygFUDYv4By986bidP9-OTfXvdZkJzYpvnM-wJp-orERpQu9LvYOJwSRqsTrBT-iFRT3okrOFHFIns4JJzDHIexU8fudVbBdqZtEMBJ206kz_0ls06YiR_B8vclhC2d5z5zSK64LM5wQDGFf1lgpNxE_84X5rxDvx7uOCCxS_AHKJCTQ_1Krva8Xl0ZZ1BQJJC55JpkKJkvt7YHAMe3fvQuNRrteIyOWc5oFXajUK5LoOM0YGyzPSDwatfhna1VrKDQPb-grUAfUg4lBMOYYpP4ewqL8wDJw1-Z7jlF3-QJphNo1deDf73S-GiPK6c6x8thEoWE3r9yLkyqF15XlZHkk0-IUGdj955hlLIgB0P7ym6X01hyO6hOnMAb-FZjQg0A8vg4DTeKFI0UyzcZF_NQLAUWL2ofBO-l7uvWBr0V-uMKNSHx5Xw4VO_KsgX1I_DfVkJdvqqgScIkka1iqEs8BYygOsmSX3FGNppchQQh26Owo4nRLharNya27ABU1dMruHshHs6KUrREYX20TxZkPhGlJN54ZmwA645WU4eZzPFIO7Rk9MYhNMdJFyecPFu-Bh0hKrWR4h2cC5ZOnLl2iSIsogNk93jpLxub5SA1tTJKY3A9h7P910SDLeOJ-1Wlgl5KQQg3YwWZvaCv-1NLhkEEf-A6JMR-jA6xAMYP2NSlO1BwLzl-qSRrtpTlnMUWf6HN8VabxagIyNUlCD5dOkmCRD7xHGl0iH39agtND6sW0Oft-9ekxXxPyBVM83eAVFImgDQ8tFj-1r8LhxLcKdFJQ-Jvd6Ig47_bBhsvQgWBAAS_UwZBMOYE_h8OQMs0ZfofANJhZqdDlNZeGd9d7tIHKfPWF7xdtXBdKztFInUASyevTGe5SdP6IqA64M9X9y2q9JMtKq85poecCs3i14oVVo8oITkaH-T58avTJtAmcy2B57fm2bokWsdKqc6J4Wnp0_lCDWxMdzOWLg64fCepAnez0sz6QFS96-ctcYfDBPELupDZi3F2Ky0OcvLpkiIc0SiV4CXLKSB7LtKhTcG2D2OYjWy-go7Vt-tcudYa1pppAgj13aC0v4_MA0tqO4S0VpxJJcGYBI21TUXDsZ0T5DgX87DX2Z1YK6ADpA7B4v3eciV9Q_3kpiddM6aGfFDTrDKoDyFJe7MqaKvYlgbAsrDQr09sl0TfG6-MCYleM4fijjxfcnHtx-O0-fW4hY6EVKQloRTs7eb2VqibUo8ID6_TAYBK23dsr2HMTD4D0HL7RKPLqR7_--BbLFOQ4bl0PpL_80ZiB3ApoilEw34Hk_oV2FcYJlxnuMe_AWORpctZy9Z9-cFh5X2sr0YLz3eWnGStl-I612LX4GJC3cd2zImIvouyFj9s3x2vuy14X1_D1TxsnLnGlnqTxSuDtz118cUuKhEK5mZQaQFO6xpESdzKOG3PtK8KVxXpS-hAIsH3nraZLM-TyO1a2eI3jSO62wc_JouVVYr7Wy_x3wj98c3z5ypoSjBI_89FSoq6sEo7IOUg8FxF41TgMB14iy0AI5T8etEQqZgKAlFRDRhD-xgHIU3x145ildwznw_z55u7T6hCvs5YZobXXcH5tN2nSD1If_lQoemZsAQp0TKSIXQ1GrGgUB66g0YEZc9yrsKqlyjskj_BDPpLNEk3ha6ie-NQRqRQPe9A1bElUZD5NW3f9C7d0YrekGBdIXkDIEkrvGuQoBw6RKcZcrwt4yDFP27_Nzlftp7xq4Z3220RJake3awNSf_7UYyef1pghsaMolV6ynRCyNKO1Yt-rtXDr7yKw7uZB45E2Ygo4_0-gZXRfKsptApUZEf02HceNYtAbTvmpwEbKt9watOAyEmpkYc7BgL0GoVOJJOum6Tnb64Jz0WU7rjnQJbdW3LpzcKoMeHhYHw5RK2cSb163OzXIcZ6aKcP3SBLhpLKsZ0cpRvbOKbU79-noWOvBZRyXW5wQi5CXayKXpxB4OSAqCBYCHFAXifCpyCmyxZNpsrCEULB8SjXdb0KkeVRFidiFtsDZIBAHpNljDawzG8izIRdalcRoRbMJCqYvRkH0t2j5TWdvPvUXRAeRU24YSxVRzaR03ROffKxUE1ALNqFqFmVSTZvQalYOXkHExwaemuy1xr6WHR810XSHfmgbwBrXO71oosFernJDT4CPoNr17Zg28LeGhPBeIxh_ZQxFkMQgOaZrU4JO10wCceuxBV26I6VHs-Hgaw_pBSnt5NzV7vsIxbpRD9tCO77B_AEaeCMnSDDobz_R0LP0cbAzA_BsRfG0Nr4GBjH_4MfutbZZxId_-8NBqZnyu3WLU0XG09H0bNkCg-1-UqMjmObIyQIfMvCBotpC-0PAF-rT1azuDUB_wjm6AfC3Mkw3Kn6M4zmel3nbTE_Eq9uZWtEozoy2ZNydixKMeo-GRjm1XPbiAME2EuOrPb9Ln21Z2xU7vyEniGS_R23QPxSedRNreLt-sYnUlTfBlcLllbp-By9Ro0AgnDKOK4iELFqJH0qkeBvgMx7HfOl5FcJkqUDJpwZ46w8MCEFMt0jbbzBZBOCiutHyokQyYK0HxNbiuxG_cltJr0eEsGV858yzaId_EfiA6lgAnTJh_lxF-K7P7MPxHcKswGlnj_YZHWnn",
}
local _aa5b={1}
local _5d={} for i=1,#_aa5b do _5d[i]=_07[_aa5b[i]] end
local _38,_ff14=_27(_b1a(table.concat(_5d)))
if _ff14~=1531063230 then error(string.char(55,49,53,54),0) end
local _21
pcall(function() if type(getfenv)=="function" then _21=getfenv(1) end end)
if type(_21)~="table" then pcall(function() _21=_ENV end) end
if type(_21)~="table" then _21=_G end
local _6,_3b,_3fc=_kq(_38)
local _e=_zo(_6,_21)
return _e
end)()
end)()
if type(_eee148) ~= "table" or type(_eee148[1]) ~= "function" or type(_eee148[2]) ~= "function" then
  _43273f(string.char(80,114,111,116,101,99,116,105,111,110,32,117,110,97,118,97,105,108,97,98,108,101))
  return
end
local _b54728={}
for i=0,255 do _b54728[i]=string.char(i) end
local _e6cbb2,_204049={},{}
do
  local ta="b4cb00230e872db9aa883a4e194169f91896b589ac8eba362b34c6efd8033851e60a704f6ee8449e8be5e2eb4532d0281ecf91f7f18c358acac562d53159f0146d335f54a07285426463af5ec3b19a906afe0bcddf84dc13d2787c5255aba4159277dd56debefbf8e12eb03022bfbd1b2f2c09262420c8e07ff68d864d46a6c782676f98101202d30f27ec5868219979753cd174b23d7d8106e9a5ae4897f5ea73ff409dbbe48083da040d9b50dbe3b69395ad7e4c17a271f3bc5c1a3bb8ce5b29b794576b372ac9c2cca901fa66fd47c4d7ed3eb33f530c6c1676e7fc5d9f057a9ca14beea7604349c0111c5a25a3f46508d61df2d4078f611f7bc1a8394ad9"
  local tb="012ae778b842865592eaca1fa5093841dc57de8b6e292425147e1ccfb2ad63ec2c7487f40bd01e8c93a2c0aa0c26c591b4f043afd4efbcb3df2361baff604a70e918cb0f8a404f515497ee64947b3ea3fec9319cd5d28220c3cc6ab0a18e6577891b88da955c9ef1fc84e4fa33eb6ff93bcd75906dc8086b4c4b7649dd22ab0d8579212f48fbbb05995816fdbe9d2b308032f25f4e6667448db75e0445135df750371de22e2d699a0717c7f815b10611567a3dd17359530a39e6348fe371e1e8acae3a7f19c43698353f83b6b568d89b52006c6281d9a8a6b97cc1e512bfc64602ed961a7d3ca40e28a0d303a95a47dbd64d72a727f3f6c25b10bde0f5ced79f"
  for i=1,256 do
    _e6cbb2[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _204049[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _83f788={}
do
  local a="GbVCJ60HcPXhTU3_fZNEpts7glowOLj2" .. "xazqQA4Wu19rIekDMiBRKnvmd5SFy-8Y"
  for i=1,#a do _83f788[string.byte(a,i)]=i-1 end
end
local function _3a81f0(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_83f788[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_b54728[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _24514c(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _c921fa(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _53a79e(S)
  local sa,pa=1388930449,86
  local sb,pb=1938353961,142
  local MA,AA,LA=598777,283433889,2085738
  local MB,AB,LB=573193,1830842603,1859385
  local KA={136,104,72,216,197,216,44,76,60,199,149,9,147,186,108,85,6,233,14,88,44,221,169,89,0,39,104,195,206,100,243,92}
  local KB={106,76,158,28,53,138,85,21,185,57,91,178,183,204,125,2,212,100,139,60,84,1,82,6,224,189,103,215,163,7,180,218}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_204049[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_e6cbb2[mid]-ksa)%256
    n=n+1
    out[n]=_b54728[p]
  end
  return table.concat(out)
end
local _37e2b0
do
  local np = _167796
  local base = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,50,102,48,48,54,99,99,55,49,56,53,52,101,56,46,108,117,97,63,112,97,99)..string.char(107,61,49,38,112,97,114,116,61)) .. "@@PARTNUM@@" .. string.char(38,100,116,111,107,61) .. _f02fbe
  local single = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,50,102,48,48,54,99,99,55,49,56,53,52,101,56,46,108,117,97,63,115,105,110)..string.char(103,108,101,61,49,38,100,116,111,107,61)) .. _f02fbe
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _24514c(hx)
    local body = string.sub(res, 9)
    if (_c921fa(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function fetchAll()
    if _c197b9 == nil then return nil, string.char(110,111,32,108,111,97,100,101,114) end
    local res, err = _d0f08a(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_c921fa(body) % 4294967296) ~= _24514c(_43abcd) then
      return nil, string.char(112,97,121,108,111,97,100,32,104,97,115,104)
    end
    return { body }
  end
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _d0f08a(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then _43273f(string.char(68,101,108,105,118,101,114,121,32,114,101,106,101,99,116,101,100)) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i)
      break
    end
    got[i] = body
  end
  if missing == nil then
    _37e2b0 = got
  else
    local all, why = fetchAll()
    if all == nil then
      _43273f(string.char(68,111,119,110,108,111,97,100,32,102,97,105,108,101,100,32,112,97,114,116,32) .. missing)
      return
    end
    _37e2b0 = all
  end
end
local ok, plain, why = (function()
  local sh = _37e2b0
  if type(sh) ~= "table" then return false, nil, string.char(110,111,32,112,97,121,108,111,97,100) end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _37e2b0 = nil
  if #joined == 0 then return false, nil, string.char(101,109,112,116,121,32,112,97,121,108,111,97,100) end
  local expect = _24514c(_43abcd)
  if expect ~= nil and (_c921fa(joined) % 4294967296) ~= expect then
    return false, nil, string.char(112,97,121,108,111,97,100,32,99,104,101,99,107,115,117,109,32,109,105,115,109,97,116,99,104)
  end
  local raw = _3a81f0(joined)
  joined = nil
  local out = (_53a79e)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, string.char(100,101,99,114,121,112,116,32,102,97,105,108,101,100) end
  local ph = _24514c(_15c809)
  if ph ~= nil and (_c921fa(out) % 4294967296) ~= ph then
    return false, nil, string.char(105,110,116,101,103,114,105,116,121,32,109,105,115,109,97,116,99,104)
  end
  return true, out, nil
end)()
if not ok then
  _43273f(string.char(80,97,121,108,111,97,100,32,101,114,114,111,114,58,32) .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = string.char(50,102,48,48,54,99,99,55,49,56,53,52,101,56), scriptId = string.char(50,102,48,48,54,99,99,55,49,56,53,52,101,56), t = 0}
  pcall(function() if type(os) == "table" and type(os.clock) == "function" then sess.t = os.clock() end end)
  local function setg(name, value)
    pcall(function() if type(getgenv) == "function" then local g = getgenv() if type(g) == "table" then g[name] = value end end end)
    pcall(function() if type(_G) == "table" then _G[name] = value end end)
  end
  setg(string.char(95,75,77,95,65,85,84,72), sess)
  setg(string.char(95,75,77,95,83,73,68), sess.sid)
  setg(string.char(95,75,77,95,66,65,83,69), string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112))
  setg(string.char(95,75,77,95,72,87,73,68), hwid)
end
local fn, cerr = _eee148[1](_c197b9, plain)
plain = nil
if type(fn) ~= "function" then
  warn(string.char(91,75,105,110,103,109,111,114,93,32,99,111,109,112,105,108,101,58,32) .. tostring(cerr))
  _43273f(string.char(83,99,114,105,112,116,32,99,111,109,112,105,108,101,32,101,114,114,111,114))
  return
end
local rok, runErr = _eee148[2](fn, false)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(string.char(91,75,105,110,103,109,111,114,93,32,114,117,110,116,105,109,101,58,32) .. tostring(runErr)) end
