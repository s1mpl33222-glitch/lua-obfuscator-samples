local _bb0af8
local function _12cfdd(msg)
  warn(string.char(91,75,105,110,103,109,111,114,93,32) .. tostring(msg))
  return false
end
local _397dcf=(function()
return (function()
local _97={}
for _26g=0,255 do _97[_26g]=string.char(_26g) end
local _8059={}
do
  local _z15="Cu_tQVbIxGEUyRlNnvkWKJ731jrhfOHe2cA-9p6SaiMBTFmzXo8w5Yg04PZdsqDL"
  for _26g=1,#_z15 do _8059[string.byte(_z15,_26g)]=_26g-1 end
end
local function _e2(s)
  local _di0,_o7k,_m28,_a08={},0,0,0
  for _26g=1,#s do
    local _zal=_8059[string.byte(s,_26g)]
    if _zal then
      _m28=_m28*64+_zal
      _a08=_a08+6
      if _a08>=8 then
        _a08=_a08-8
        local _35w=2^_a08
        _o7k=_o7k+1
        _di0[_o7k]=_97[math.floor(_m28/_35w)%256]
        _m28=_m28%_35w
      end
    end
  end
  return table.concat(_di0)
end
local _6={}
do
  local _cyo="SM2\221u\238\214\200\174br\190c\193\140\226\188\131\252\144\205\215[\011Em\235\167Zg\003_)\225\241\149\184s\139\244\17580\008q\169\014Aj\218\209|\246\141yp\001\145\133\177\r\178\2236\005\185\208=\007+C]\229N\182\0283\015Y'-\026}\189\212\186\242/\220FX\196\016\146>\203Pi\153\136V\201\237\012\148\248\128\183kU`\192\207L\250\249%\134Ww\179\129\234\165(\253{\156\180\210K#Q\030\224\204\"\127x\228T\159\233e\240\132D\152\023;\029\151to\017\161\222\245\243\\\154\173\194R!\255$\168z\009\2519\1375\018\187\219hnf\130\143G\000J\n\199\172\158\232O\006\195\170\171\230I\160\216~ \181\002\031\004\157?\164\213\198\142\155\022\227\019\166*.a\202\206\138d\135\197&4v\191\2547:\163\211\0201\231\176\239\147l\027<\236\021H,B\024\217@\150\162^\025\247"
  for _26g=1,256 do _6[string.byte(_cyo,_26g)]=_26g-1 end
end
local function _b(S)
  local _f98,_i2t=1093446928,205
  local _di0,_o7k,_tdt={},0,0
  local P=415323 A=-759846671 L=10078953
  local K={44,26,66,37,143,160,123,126,124,167,20,182,203,5,56,62,103,93,217,115,29,203,20,32,67,0,182,202,238,173,22,19}
  for _26g=1,#S do
    _f98=(P*_f98+A)%4294967296
    local _6w1=string.byte(S,_26g)
    local _acm=(_f98%256+K[((_26g-1)%32)+1]+((_26g*113+L)%256)+_i2t)%256
    _i2t=_6w1
    local _xa0=(_6[_6w1]-_acm)%256
    _tdt=(_tdt*33+_xa0)%4294967296
    _o7k=_o7k+1
    _di0[_o7k]=_97[_xa0]
  end
  return table.concat(_di0),_tdt
end
local function _px(_jf, _ug)
local _la = table.unpack or unpack
local function _wb(...) return { n = select('#', ...), ... } end
local _hd
_hd = function(_rz, _cm, _dg)
local f7n099, _pe, f4907l = _rz.f7n099, _rz.k, _rz.f4907l
local _zi = {}
local _ip = _rz.f5yva7
for _gy = 1, _ip do _zi[_gy] = _cm[_gy] end
local _ze, _kg = {}, 0
if _rz.f17xl8 then
local _ro = _cm.n or #_cm
for _gy = _ip + 1, _ro do _kg = _kg + 1; _ze[_kg] = _cm[_gy] end
end
local _vh = _rz.f963uw + 8
local _gj = 1
while true do
local _rk = f7n099[_gj]
local _dr = f7n099[_gj + 1]
if _rk == 38 then
_zi[_dr] = _zi[f7n099[_gj + 2]]
_gj = _gj + 4
elseif _rk == 12 then
_zi[_dr] = _pe[f7n099[_gj + 2]]
_gj = _gj + 4
elseif _rk == 11 then
_zi[_dr] = _ug[_pe[f7n099[_gj + 2]]]
_gj = _gj + 4
elseif _rk == 8 then
local _os = f7n099[_gj + 2]
local _nc = _zi[_os]
if _os >= 256 then _nc = _pe[_os - 256] end
local _zt = f7n099[_gj + 3]
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
_zi[_dr] = _nc[_zt]
_gj = _gj + 4
elseif _rk == 39 then
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
local _vw = _zi[_dr]
local n = (_os == 0) and (_vh - _dr) or (_os - 1)
if _zt == 2 then
if n == 0 then _zi[_dr] = _vw()
elseif n == 1 then _zi[_dr] = _vw(_zi[_dr + 1])
elseif n == 2 then _zi[_dr] = _vw(_zi[_dr + 1], _zi[_dr + 2])
elseif n == 3 then _zi[_dr] = _vw(_zi[_dr + 1], _zi[_dr + 2], _zi[_dr + 3])
else
local _nc = {}
for _gy = 1, n do _nc[_gy] = _zi[_dr + _gy] end
_zi[_dr] = _vw(_la(_nc, 1, n))
end
elseif _zt == 1 then
if n == 0 then _vw()
elseif n == 1 then _vw(_zi[_dr + 1])
elseif n == 2 then _vw(_zi[_dr + 1], _zi[_dr + 2])
elseif n == 3 then _vw(_zi[_dr + 1], _zi[_dr + 2], _zi[_dr + 3])
else
local _nc = {}
for _gy = 1, n do _nc[_gy] = _zi[_dr + _gy] end
_vw(_la(_nc, 1, n))
end
else
local _yo
if n == 0 then _yo = _wb(_vw())
elseif n == 1 then _yo = _wb(_vw(_zi[_dr + 1]))
elseif n == 2 then _yo = _wb(_vw(_zi[_dr + 1], _zi[_dr + 2]))
elseif n == 3 then _yo = _wb(_vw(_zi[_dr + 1], _zi[_dr + 2], _zi[_dr + 3]))
elseif n == 4 then _yo = _wb(_vw(_zi[_dr + 1], _zi[_dr + 2], _zi[_dr + 3], _zi[_dr + 4]))
else
local _nc = {}
for _gy = 1, n do _nc[_gy] = _zi[_dr + _gy] end
_yo = _wb(_vw(_la(_nc, 1, n)))
end
if _zt == 0 then
local _ur = _yo.n
for _gy = 1, _ur do _zi[_dr + _gy - 1] = _yo[_gy] end
if _ur == 0 then _zi[_dr] = nil end
_vh = _dr + _ur - 1
else
local _jq = _zt - 1
for _gy = 1, _jq do _zi[_dr + _gy - 1] = _yo[_gy] end
end
end
_gj = _gj + 4
elseif _rk == 32 then
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
_zi[_dr] = _os + _zt
_gj = _gj + 4
elseif _rk == 43 then
if _zi[_dr] then _gj = _gj + 4 else _gj = _gj + f7n099[_gj + 2] * 4 end
elseif _rk == 33 then
_gj = _gj + _dr * 4
elseif _rk == 6 then
local _nc = _zi[_dr]
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
_nc[_os] = _zt
_gj = _gj + 4
elseif _rk == 41 then
_zi[_dr] = f7n099[_gj + 2]
_gj = _gj + 4
elseif _rk == 10 then
if _zi[_dr] then _gj = _gj + f7n099[_gj + 2] * 4 else _gj = _gj + 4 end
elseif _rk == 36 then
local _os = f7n099[_gj + 2]
if _os == 0 then
local n = _vh - _dr + 1
if n <= 0 then return end
local _nc = {}
for _gy = 1, n do _nc[_gy] = _zi[_dr + _gy - 1] end
return _la(_nc, 1, n)
end
local n = _os - 1
if n <= 0 then return end
local _nc = {}
for _gy = 1, n do _nc[_gy] = _zi[_dr + _gy - 1] end
return _la(_nc, 1, n)
elseif _rk == 29 then
local _os = f7n099[_gj + 2]
for _gy = _dr, _dr + _os - 1 do _zi[_gy] = nil end
_gj = _gj + 4
elseif _rk == 21 or _rk == 40 or _rk == 3 or _rk == 22 or _rk == 23 or _rk == 25 then
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
if _rk == 21 then _zi[_dr] = (_os == _zt)
elseif _rk == 40 then _zi[_dr] = (_os ~= _zt)
elseif _rk == 3 then _zi[_dr] = (_os < _zt)
elseif _rk == 22 then _zi[_dr] = (_os <= _zt)
elseif _rk == 23 then _zi[_dr] = (_os > _zt)
else _zi[_dr] = (_os >= _zt) end
_gj = _gj + 4
elseif _rk == 13 or _rk == 15 or _rk == 42 or _rk == 9 or _rk == 30 then
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
if _rk == 13 then _zi[_dr] = _os - _zt
elseif _rk == 15 then _zi[_dr] = _os * _zt
elseif _rk == 42 then _zi[_dr] = _os / _zt
elseif _rk == 9 then _zi[_dr] = _os % _zt
else _zi[_dr] = _os ^ _zt end
_gj = _gj + 4
elseif _rk == 20 then
_zi[_dr] = (f7n099[_gj + 2] ~= 0)
_gj = _gj + 4
elseif _rk == 31 then
_zi[_dr] = {}
_gj = _gj + 4
elseif _rk == 26 then
local _nc = _zi[_dr]
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
if _os == 0 then _os = _vh - _dr end
local _nn = _zt - 1
for _gy = 1, _os do _nc[_nn + _gy] = _zi[_dr + _gy] end
_gj = _gj + 4
elseif _rk == 19 then
local _os = _zi[f7n099[_gj + 2]]
local _zt = f7n099[_gj + 3]
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
_zi[_dr] = _os[_zt]
_zi[_dr + 1] = _os
_gj = _gj + 4
elseif _rk == 28 then
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
local _cb = _zi[_os]
for _gy = _os + 1, _zt do _cb = _cb .. _zi[_gy] end
_zi[_dr] = _cb
_gj = _gj + 4
elseif _rk == 7 then
local _xy = f4907l[f7n099[_gj + 2]]
local f2ewq7 = {}
local _bw = _xy.f2ewq7
for _gy = 1, #_bw do
local _mx = _bw[_gy]
if _mx.f6re89 then f2ewq7[_gy] = _zi[_mx.ff8z2] else f2ewq7[_gy] = _dg[_mx.ff8z2] end
end
_zi[_dr] = function(...) return _hd(_xy, _wb(...), f2ewq7) end
_gj = _gj + 4
elseif _rk == 14 then
local _os = f7n099[_gj + 2]
if _os == 0 then
for _gy = 1, _kg do _zi[_dr + _gy - 1] = _ze[_gy] end
_vh = _dr + _kg - 1
else
local n = _os - 1
for _gy = 1, n do _zi[_dr + _gy - 1] = _ze[_gy] end
end
_gj = _gj + 4
elseif _rk == 16 then
_zi[_dr] = _dg[f7n099[_gj + 2]][1]
_gj = _gj + 4
elseif _rk == 37 then
_dg[_dr][1] = _zi[f7n099[_gj + 2]]
_gj = _gj + 4
elseif _rk == 5 then
_zi[_dr] = {}
_gj = _gj + 4
elseif _rk == 27 then
_zi[_dr] = _zi[f7n099[_gj + 2]][1]
_gj = _gj + 4
elseif _rk == 34 then
local _nc = _zi[_dr]
_nc[1] = _zi[f7n099[_gj + 2]]
_gj = _gj + 4
elseif _rk == 18 then
local _nc = _zi[_dr]
local n = f7n099[_gj + 3] - 1
local _gy = f7n099[_gj + 2]
while _gy <= _vh do n = n + 1; _nc[n] = _zi[_gy]; _gy = _gy + 1 end
_gj = _gj + 4
elseif _rk == 35 then
local _vw = _zi[_dr]
if type(_vw) ~= 'function' then
local _nc = getmetatable(_vw)
local _os, _zt
if type(_nc) == 'table' then _os = rawget(_nc, '__iter'); _zt = rawget(_nc, '__call') end
if _os ~= nil then
_zi[_dr], _zi[_dr + 1], _zi[_dr + 2] = _os(_vw)
elseif type(_vw) == 'table' and (_nc == nil or (type(_nc) == 'table' and _zt == nil)) then
_zi[_dr], _zi[_dr + 1], _zi[_dr + 2] = next, _vw, nil
end
end
_gj = _gj + 4
elseif _rk == 2 then
_ug[_pe[_dr]] = _zi[f7n099[_gj + 2]]
_gj = _gj + 4
elseif _rk == 1 then
local _os = f7n099[_gj + 2]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
_zi[_dr] = -_os
_gj = _gj + 4
elseif _rk == 24 then
local _os = f7n099[_gj + 2]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
_zi[_dr] = not _os
_gj = _gj + 4
elseif _rk == 17 then
local _os = f7n099[_gj + 2]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
_zi[_dr] = #_os
_gj = _gj + 4
elseif _rk == 4 then
local _os, _zt = f7n099[_gj + 2], f7n099[_gj + 3]
if _os >= 256 then _os = _pe[_os - 256] else _os = _zi[_os] end
if _zt >= 256 then _zt = _pe[_zt - 256] else _zt = _zi[_zt] end
_zi[_dr] = math.floor(_os / _zt)
_gj = _gj + 4
else
error(('E'..tostring(_rk)), 0)
end
end
end
return _hd(_jf, { n = 0 }, {})
end
local function _az(_cb, _sa, _fi)
_sa = _sa or 1
local function KMVX8(_dr,_zt)
_dr=_dr%256 _zt=_zt%256
local r,_rz=0,1
for _=1,8 do
local _yd,w=_dr%2,_zt%2
if _yd~=w then r=r+_rz end
_dr=(_dr-_yd)/2 _zt=(_zt-w)/2 _rz=_rz*2
end
return r
end
_fi = _fi or 38391
local function _ie()
local _os = string.byte(_cb, _sa)
_sa = _sa + 1
_fi = (_fi * 490 + 25082) % 65521
local _pe = _fi % 256
local v = _os - _pe
if v < 0 then v = v + 256 end
return v
end
local function _tf()
local n, _qj = 0, 1
while true do
local _os = _ie()
n = n + (_os % 128) * _qj
if _os < 128 then break end
_qj = _qj * 128
end
return n
end
local function _eh()
local n = _tf()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _pi()
local _rz = {}
_rz.f5yva7 = _tf()
_rz.f17xl8 = (_ie() == 1)
_rz.f963uw = _tf()
local _tq = _tf()
_rz.f2ewq7 = {}
for _gy = 1, _tq do
local f6re89 = (_ie() == 1)
_rz.f2ewq7[_gy] = { f6re89 = f6re89, ff8z2 = _tf() }
end
local _mm = _tf()
_rz.k = {}
for _gy = 1, _mm do
local _hk = _ie()
if _hk == 0 then _rz.k[_gy] = nil
elseif _hk == 1 then _rz.k[_gy] = false
elseif _hk == 2 then _rz.k[_gy] = true
elseif _hk == 5 then
_rz.k[_gy] = _eh()
elseif _hk == 3 or _hk == 4 then
local _ft = _tf()
local _wx = {}
local m = 233
for j = 1, _ft do
_wx[j] = string.char(KMVX8(_ie(), m))
m = (m * 15 + 75) % 256
end
if _hk == 3 then _rz.k[_gy] = tonumber(table.concat(_wx)) else _rz.k[_gy] = table.concat(_wx) end
else
_rz.k[_gy] = nil
end
end
local _bl = _tf()
local _pt, _es = _tf(), _tf()
_rz.f7n099 = {}
if _bl > 0 then
local _av = {}
for _gy = 1, _bl do
_av[_gy * 4 - 3] = _tf()
_av[_gy * 4 - 2] = _eh()
_av[_gy * 4 - 1] = _eh()
_av[_gy * 4] = _eh()
end
local _ag = {}
for _gy = 0, _bl - 1 do _ag[((_gy * _pt) + _es) % _bl] = _gy end
for _gy = 1, _bl do
local _hz = _ag[_gy - 1] + 1
local q = _gy * 4
local _mx = _hz * 4
_rz.f7n099[_mx - 3] = _av[q - 3]
_rz.f7n099[_mx - 2] = _av[q - 2]
_rz.f7n099[_mx - 1] = _av[q - 1]
_rz.f7n099[_mx] = _av[q]
end
end
local _wm = _tf()
_rz.f4907l = {}
for _gy = 1, _wm do _rz.f4907l[_gy] = _pi() end
return _rz
end
local _xy = _pi()
return _xy, _sa, _fi
end
local _f70={
"h9mqENvmzL-iFDoXpW3DpdpKHwc9jcmrwAAOFEzPvn2Jv7pHZYvAZeBgxwqeTwLq-NjGj-zhsM6YUtA6-YMeN24utoIsWT9r9fhjMyVmV-1HkjFvlZnsE0WiJo75xkRLU4IJzPEy8teRG2h3UxoYofug-KqDdUTifn1Po5O5CpGMuG-rU9Q8fe8Y3KqaHS3sRQX55w6tZCEc8nvIPgGSXRQYvkcsGX8q1SpFaeHiAl6AyUd93KyMQcFQBP-JJhvB77bV7aJXB9zxEfuBPkcLq5M9lbJBMeOx4uV8SRfLrYXp2qbdrLJXJmb3AkeVO7_gfL75Pc7PNWjvmq_izaOAxcgepxjxl1InmN4p5kzDd-QkQvbIAjlAhVH-XCVuosq8XeVfAmDBZn7Gw6yB4YrHcAdl5ndxp3fXqo84B3OjE7Qtcu2B86KklkHg7m5QtjfQ4m-x4iMsR2dJLJT-iSH-YJ8G1SViNHsvhNK6ovPg-fN4mS9KUvdqM7YxWMjd4lb6_DhWhvvm5UqWUuEAUdW1mqeBwIuyE-LH1j3-XU4a2JFcOZLxu10TxEopxOmNU5ZwDCj1E3RmafXEEDP-zOQ4JwC8CyXSh0kG6Z2gyGd8i6E5OQNwB594DIGDFM1d-XdXQlLWnC48UYbXGgA4mqjjbWsuFUAHjoZes5326fIyBBwpJNVblIYJo5WBJcfeqfoT2g5OWjDKBmWb7lM2v4omlxEJ9rHaJQTquyGEASR7xEMRiu0w5N2GU1jamhzzJkEHh62m-BSghLpLnMt4rrp2yIY9qkLPM0M5hGfkbB4zZGUnnZuYJrutEnwXQQOP98sdrPaQn3PB0oSuVuIRVEoIbsL5yeGlPd4t4XC01yBLG3yDzp_FZMExjnmKOiyzutzWQ3X360GxURC6fIFzvmQ0S0CLlw56V7TGGyWufEZYA8IAom1EtpmwsAE_nf3LmXOgaDhzN3drIGVSKAWdlUc0ucAS46PqI8OI0gyqEmhN5MK20arB3dBpuMOsHVH7-TtA7uksX1hGDfx5kT_hboCM8S3KcE0WdCjbFmwr9F3FvOQlgzJste0GmZ122Idwzr2pF3aUevQaeE1DFckJBmS2KJ8mlmMyEyvBpXK1x2ZPZAZcVZfo-dsuybn-oE1ymRvqgYg1CTNy4J1PDn3Bwiuxm115l53RQRiy4zVWUGawhcPL0GP8-J7jBpS_8V6VbMZNRiC87k5Cc2VyQ2sJzI4YreipN3mJT1iUijFYyJ5dmvD6VvR3eagf7UjGqBF6rIUuwrUnnaKAIoNZtXeqkKaGkFj0I0gL2dLDigBTD_TQKz-GiinhSzdlMtQEHGNkVBT903emgfMB3WYHEpfNnzeaHNeKc7HPw6wF4ANmKmNnRBfjsFv6Rw0CnDbnHFfzL1nfhhUYzwH04Qc0InE-2dE1eBlG0JKFn8WTdFrqk0FZZ2wyTbQuCcGkogWgZ2DB1VZPs90uxyaRuT4UTO4k2xLfvnqkoSO2UsX3FLqv7Sl0qipAizRq-kTkklmlkG9hktOzKoNzD78CwlzwUFfNjHqLAdrLvdD5tm857xULYhdliupUkHHQVBAhhA3pUErz4CZl13BGdmQrYIJtYPx_CbubBIysSVVT4Rq5rV8-8_9R7REP1wOVMl9RHhG5Ak9w0esQaHdhTmITlSIly88IySFhhflSW9d1a79-6c5EE7UVIwTOZ_CnfbQaB8R2xgk9Q5WCAcfcZTZUxdi5RhFRgKHG4PwoyToq4WiMhc22S1YW5mGdDJTaxSxgofct-jXA2atADURB_FBlmeKRyDMk5O6DjR3v3d12TNQ8w6KzzwYJm-I91F4h889j0YIoZGNXb9xDGyyleyPeAdJu5mIuV7aRNe7FEY1ixjWyqBO0bAeNv5WHEox41qA-VIFjYsN0hE9MQMzn0JQdsH1v-YyvHTdAcAoNxmFYEX82XyAcX1oNHeJEXjIhTa6CS3BhhU4orVf5L7pcW4QZqTcAXO2u04ba80FXUaJZNil8c1celUgW22q8h0u8ArLvGvdCn2KnFmYq-7Qe1puBfCkZq6mJLB5SokivgziP0x06KDMlGwxQZh3bX1-PSJ9Md4e5WAUx0XAyIGV1RB3oialecvjrEyFyVJ3BKzICGMqXbaIBnI9xvZ56CkbY85K8PJxdKNyipnys3qYUDPQajBzrzeUCAYisbyerCIyXPZfrGJ3V7huMbKEcx9L-YoynhK1scgqiG8Dvfd5b6FYGegAXC8dcvzq9IFFTn1-QC0C40DosVDqUhH-ip-zX_sVL9-hVAsW5GW9BI-ykjd-Dfth7iDoCs2lFYERpfjvx-eHyWZ11KedYHa_CLFK6i6QMQn2hPTJCyserzd8gKH2vfv8abya_7DsIfH-110KltA9ubwD3ZCqrCrjqpSM_shOwlJzH_Y3nZ43yGL7kpUae_GkAlOSdDNXZvcFSDw--S_1ZUMaGQzvkrs2KWGC71JmkDDtdhZ67A6RNeSR6IwDaDiWml1eJBVLBxLWR9qsVKE0nS04FDhcI83xgkQAqvzvKaRx3KN8sYen29aLTeoFSg1YYiPxy55_J9-oqfAkAp2JEI9UIJoXBAVg5Y7UvLQzaFS-AVEbL3Cyb6e98eGaizuoV9hK5M3AmaGwdiJCqjJ7wGxzwSBZFVfhGViVF6_P_e1GXZzXzhZaqiEqoUyAL7Mt32VjuSFSag5bvTZou1tH4Nc4XoBNf0aoFPveO2NnsjRm7mNae6XYdTb3gnEP86SHr-d7QeYHnUriKOo3P5qIbwrW3h5OOvwxQY2LrJ6mTfvPx0tTlvMyuzRJiWSEyUU5LWO9-eNpIRukxGlf8mxwGreL8Pu__q35G8l2pmww-nBC9pBGCGobOgpguCfCdfgpS6RsgP6cfLzZVsLcl4Fr8cZS0oCYmv6UO3rnektSH-slD2Ske8R890ZF1mGqaT_8kHJP7c53awi_nAH4Z-kGmX1h1gf48NYO132NlFvEv1UVV9-VsJ7IA24CMJ6dIArLRNZQfokhQa72_q3LlDvhr5B70ZdzAlLo6RthAY8eCbur9Ub2jBbNkTQdUTw0CcOyuqZ0TrcvymESSnOn4NPubwvnnv7w8sjRN74wV8txtETWGbN1yMv_MqnQodp1-P8XSRbMbQ4epbkkXUclq0JXzJWemdd4_6JvywnVUuQPg4sq6L5hlvwQP04ugPHdwB6fudqNUMVUQSFJq2ki-4gkzrIZW985IX4a-wHM32IBHTjhMOqVcMkgS1vrarb8QBRRsA9SZWFptqT0mBF60tnqCU1KhWbjCqpSDShbnFBgCFkwQRHhI1PORvXns9Y3hH6_y3Ul2YpIn28dC8foQWX__3nRJknuOaX6DkGJvSkXvKbVsIOOa-Oky9ebxykArNmeiIGdUCpHJb-h1sanCeu6VJe2ykcXzz5nbQ04yOzYh0BkN3ivdA_Jcss7jiFunIYkXmiLgDRsgbvlgnNKKpoCLg9dPwO_wYheekjmDVw6dNp6f9WWbQkOGBhimJzozyy3ra68lqewz49AvHjXoXrGgnq05Gh2JfFNf5K2XDbB9l0DE0aGSiJRu09zMQ1GUkgB45v7PKC3fF3leBiQ7VsmCcIpzBZjvIOEclArb88WFRwDvewjxACsCBo1ChctXnE7Hb1DnBLA8zq-Ufm_jSvuLiCdKEmwEUPGvB_nQtpRcoeTh0I-GjhS7n60JZQ2Q3yHi1xlRkyBUp9u4JYkZSBVUqPTtsn_HQJsu9YPPX2HKyMrm7jTDfS-GapCEmBpOKypoNHEdVoe3Lugm8BKon4SiWj0Sm08TVq5lMOPZM4_ikvF-1umo-y_-X84NIqxqdBnrTF3QL2Fgg2Iw49gpfIT3k27jsTOKpQfzSYSs3nByPnH5yIMUdTGiVfrcJfAcDz_KJYe2tCLgVL2lBvk30t33wLpDV6FxhBz2_takHOKTjM-u9rX-mZCvcoKVJAMuD56jGO0SM6tXyPPqibG__dBVTBxog0jlGYyEsF_cMjJggoTeUZSzSIFD0cqCrY044zWiyJbniadsh-fZTC1M4GZZZBUpUlm-q1d8l-B0YnD-aB65KuK1vz_Et-KJcPFgVigWJikfI8KfeK0F7Ww1eOPwZ2x6DbFZ8s9B4Rf3BlmTBYoFRUnd_P4RDg5OHoGlK7lGCIY74gGM2nTJELUdXyfVRDC6RBvsKJ4Um1yRrIzAUSmKYckNj3cZj3EudiF8qV3dDeY1h5zVCXLeVDT1sWqEO7g1BzsaewgYVL_WQIO1zxmZeh8QxVNUx8t_KHnJ5Eh2SJZlUnPfwEJDI2o1Q4EGxuf8JaejqKZ6fRO2CEBJD7IwrgxPZlXgRbsBHVhhz-FWWvR4BbKRNVebSxnboK6jetOgWSFG8AnN72kewevvxVYZWFa9eTuOofRNjDexqfixNWdpkl6lVi2X9nTRw7OhTvcENh_5tAd4Pbd9TOyXhUCUjbU0KS_I7pkBPrecVML78-Pix7tha_t2HQsfSbODgKfzeCo_DbGi_G0nn9C9y-v6mG-nN91VwMjvno2EjfLzUcXZ964BXCikdtgGMqhmDmx_1UfPJ4fJLv0bG41CtTR2t3jPmegaWFzmYN8oyoSE8XzCIdxNlZma3JnnSdYD7OOBmGxVR799nhfz6BHtJHdBFXBDeheHlr8Vdxnt5nr4n8GFK6Pgzqvy6LJ3b4IowJFZB823eprpgHEckf24G-ZwoCsEulMJ9sJJsUrHt451WkZ4nzSp7VxqFUBnKGPJCoobLEGz4iWy9pSqmqMka8I5M20IewedXRo5-UZdMrSevVBdJU8JCDinYQ7wUQHP2mF7gaQ-Y187yNg2LNiq_b4bEN12Y12D89O4hRUS0iDUPud2IJzsHtcrBMaIUTNayHMBb0rxRRn7xxdZixsAKOSeh_o5vmKV8EcgCFd_6vor5GxNIeiytRvWNRy0nQa5FAcAmbV7mprVXLJm9hUrKG9GfRBMS2DmKb3SBoB0un3x66T4uqqI9wZP4eRGUX0SLnnvfx1hQlfEP7YjX8nCiNFe8S04kZ8WBzuWDZvmpDyYaRNBpxM5Jy3xSQ_BKYblKy-rkPdkPNT_UHzzoivTU-um3MuXQ6suujZLhgXwRUOeUnzpFaCFuq4mTY-7RmWxAXPfyH2o4YphRBpsMfZbo248lxCgcSDmSjQLpIbVeY_PbL0p51FZ3U6TQeczK9m4phSSs9dDnTRFX8a7RQrx5BL_AQdvximwwVjtsaJaGOft2l71J_5gDF2_OOxHLEQ_Ysei1dPkyqryyfy6zaZ-IeDUGPX8Yo_oIAhBtBH4La9nLDUkaGJy-gvVnRJQ33umYLxhtUXor5SF5i51JH0LpZaAq30ObI3Rb7UusNglcz6y1OeToWs3wl-Cs479kh2BnFgCsVeLuZBKknMprislyWZ4ESPcD6wLmY8jB3Xhm2Knl7J2wIKe3EiXbCzelykoI8wmFELA_oKicm0RpwjkrTGM380PEd7qLzbCkSIUx35RNLMkY2DbG2oV16LZPDOG2GAvz-j0tH9gVe2lTHkxU3FK6e3n_aUPOnvFSqHmWTWtN-20SDkAdwPmD9VAYp8HnwDzUh_izw6g286CW73506YLbiH9VJvPFITSURp4RwrO6mdr0V9vWaVrBF8p4GM_XSeaElk8bmIUlkMhqlafNetaKK4Djaw0JvKn2QLUOttXu0xI4IKUioqs5pll8VMJ0F0NF-rRF0wC4qHGCv3vhoJMvfgJUeIeVQ-nhHe55bM_cgbxerQpjpJ_V0COuYs7Qt3QkS5WZoBS7rGkkPmSc8n-RFmaNhMdJOgEEjLEGQiBLR6-FXIxVWufWpB0BXDKbvvlihk76QZDih6LwqfW_EbKQ2ESplt_xF9aTgH4DKFdgcbWlQkhfRsUekUgVsJddq-eJgJYeSFTYR2l_Bq2xlWsW1HU_lrTn65N69oLRUUI8ZVlabNHHu4RTCwPoy98BT4S1xenutBaLkZEWZkGxTLWj3D7oToBZrTLFD-pcVUkgTSmfDSj-sIIgqepF5RCe6wnLbH1a9KANnm6uLsLrR61MC2xHPVqQOrmR-0rmikvsLdJRzQRdMqaVZQQeH1kWqCVSIFfDblJh1WlBVhdxaWUfxpsmAdSg84yuYKm58zzktELGnmOEHVKKbUdzHVON2vauRIkR4RlnMFdA7FuHnxsE4R_BtlD8-XWQK5jAGOp1Ritpw8FJ05EWy-pfxlo3SGqgU_1X-Ll80F5rA_bWVBnjRj4l3lhH-VDJESQv00LWwFGPRnzgtEHyROsAPdb-flV15ACPXcxeFZ0ppyVnHm6d_7bmdA5sT9GKBkGVI13HElFkHtVCtuUwCDIs32g1THpBish3Rxu-xnIGqscw2wAaxXA_BpcadssWgx7RHoJyHdud4XXlj4kjWvd3p7aCNcjOPziTQxBh_rUj1frVJZ1ayrMdH2ADIubskKt9KohWHAmMBKD_g5VmTd30qbl78mVqwFkss0rMSU7n_9RGUpDglTZqU_VuViAYm9-rMkZVuzV-NTKeytBT0IP82jzW-jIEWayTBAWm3Yhas9NfJievikPyKyCpvum2L39KrERdZrNBm4i54Ixh4yGQadAHB-Z63eOBrgsOFsJmjcAPecZ5FTOEmkptHhKwab5UQCKMgTr1OX9BW4mQMUegnk5PDr44uCm92waWekKkZ8OIOK3fgYVWrJEl8JXtYh3i5aC2z2DTPeu5U93FF59pgx0RnDHnscD4YtfyX1RDvwcIvx7rJ8bLMh1E3M8Tmg4_cAogPWfxury6zTgVxAzVKQVcq_pXN25nOso3jDBm4pq-FLYVbb3-Di5hjOkH9vpBQdK30kLOtk_B49S3yepOnBMpD1yqDC6K3BZzbyG6ztc2qpyAyb-CQSZ_alfgnLXv3-8pNnyBP1d-YBevviASB1VP7ij-7satd3Sk_GaMuWfItS3ZugnyGDxbfNurZgL",
("f3FZWCxDqoLzMMWsXVsYyF66rXIF2GnLHYMDrCb8BPzcN-4d8MlJ7yCs5aGULf6HMGxDqBxLY8EV_RLwCddszv_EXz0jwIl028VBrv-muon-gCC08pmYkmZr1HXYez5Iz2Jfx-cOvEmjWKE8hLmWhxuqjW6FViIfU-Ggu9fiZ-Ya7iaeHsMyByzFXE5B6F7LOo3ZBByM_9PRv2aChBaXU-rMb5pbzoG-JSvrvPN8TErk0rVpJ7dXCnqLJBQHUqzeSSB4GXH5w3eK_rcVx93XhvRwB5_HT9V1HPdqj_XR-SVdPY0ZTd8ZwYh-u_seNWoPo6M-UnEfvWhC4Eed2FMaC8e1H7SW4_1i_ez0UOyZpsP7iqtqe-3EXNwg7K5aUSqZZBZoKrPTGpxV0QBe1bv-U7gbZQL8YTVovLgjJ26eVERf6Wu5W6Oz2uDRqzA69STiYFrvMyqIsWqdm8ET8dHS9z0OdlrDgfVaP14aGToN58LEbLIOz21vreY0SUvIS1D8LEpFP9Ixo7At2HYMfRyQ6AN6Jvx7aikME6gZcLUOsiSwQ9gj_iY6BtjRA11096KWFfTupmu160wMB9Lirg0fAuCrSs8SW6OXzj6zd3TNCYTFRTfgQGXcsl4srQ4fIWlDggukxbQOEUgw9924wjGHmOf15tag7-ere8JkBu0597FbgxwhA2UFxH53_iG8c9FbIS_gM8gsaB2gSzfuSwP-Qs4BDRc6jmSkXirbafHZDIsqMYpKCOGct0B2dln1MQMGAzB7SiZ0fQ73pSz6VnmAK9fNLv6VHrEDuWqQNO0rBUYGt7vDSFV93Ofps8w_85ZZLK6MO2RIzz0fmOy86PvI_o8-icSkNuzPiWNbg4AaHCDYT_UKB2Nyc3KcYTI4X6u8xr4lDOLJ5hIzy4MMHWhy72KvDP7fRt0gZtX4rcbuOQjXWCjv00OHVPh0ZeA65fFv1LsMMwzL97D35r6pT2JfrX-c2EpZFmVOvopbhcOVjEcMynNfcCq8w6RkwnQgy_GyzTfLf_lc-Ze1Ytpnram6Ymh_3LH1J0jskGXg0KysQWolf7d023OYWcLx7Mig4lHE39C3ArgeDkwE5F48tUkHCjiwByS89xOXdy8WjmF9pqRUxPdyLPSEa_1OR3eZqC25uscJTZMFHgUag9eTQs7MGqdB3slt6-vqPOmllfKOa0JCOA6mqOrkZJPhhuA7PI0KpeqsZffYHU1gIiOdhBvks0ZTQ8KCYm-eKNs9FRmUu-Spq8V_064g3Osabo8Yh5Ail02cW4hDzSzZgPqNvf6bBNXg2D3hGiASaQbswW35yKBTjYf6XrDkGdeXfzRd1tihjv1QWLkG7vXtyfw_AcieaoRMsvErsU3gkjW2q2OtN8euMv_0cOfC2dZw-DbjDFEgDRwmVyIEW0UL7uoEgGe7tYo4FEQR4W5EmVNh_ab11Tg6dWMDWM1paCKN0NjE_J2S29n188aXaf6M09IZmilLHv3v0pYOsGwoZsczPyB3ACfikgt8nNBg-pept44ijksIsapdFC9ZvZCte-SapSna6icXTgB15Gik40ooc4Hd_VdT6KoDENOSmAVwq-W06DFuGXTISd01wLlu407P2_fmGEYppNroJJDo7geJXaAAvdMgRzwaNyCrb71ac6U1MOgGEAY0FjmtkrAM7hdN4aPKF7gXu8xJCDrRxNsCwHDdRaZMAvp7Z7GcVTXp6haYuXtnC8KU562N5nIyVE4y7KsA0Zx4AtV2_hr9wNl9nNwMVaK-16NvvPey-cAdaX4B9i_w8W2Ylt0PjykL52PAs2zKJAzyRQbJFZNghVdLxfQnet5KcfDgLMX7PKozgpShcAOxZpEhgGkbLMLmblcpmbS48_CKe_SrBs2LV4da4e32mrIMm_klIlhMGcIkeUhJMECKfdYUnXFGqfoOuh-dFlFGUK2KnPwWVqQNKsTd34W-UIAAMsmDM7BbC4MVzPJr4beatjke3P0KOFWRZLlDdAVIY5jnKbAsX4PE4FtEv8IKhGo8lSfXtys5tqKLEy3FTP3KpF0L1v4qz1ErCncYOe4WEnAUOc5StZEQmtr6nH4X-iR_wHESNXD0EnwQBZcYmltZBdbRVVhei1szZS01kiQWUG8lb-9GEACGY0a3MfDWPyqlSmGwZhV2xiu0WMkAQiglOzOVnVw5HrjsmSW0EwEuG63NM4yY2L4dVZjxk3XFtkz8PTInitf5_vff2-zscNESgIQK20pMS8D9Qn4decjmGbeMM67UNmbp0qLbf3j4iuaw7YjKhSc39iHxxTh6gevoRgNtU1ws9mkCkhPzfmmgm7I5nLVLQJxKJQV2G_-5pLBWbuTGO_SNxqeNm9DeEh3Hi1W2X5GBuk4yOkSdBnxSsIE4KD_kGUzk3tWcsdWLL39N-x2RZyPZsbvpvCQcjVqzSf4w3tdctKRC4g_M6Lc5qoT6haXktL7q0XVAz7W1A4_-cJpOCkyKuBbCJmgMwVvBQ_f1MjIllZw_UTuadtJFpD2gVj-gmKPdYd-4zskKBd3LJDQMbLKbC03sRNcQsukjJ7fpKtZJowcnhjMSUKpqGQw6PAHUZubEAlPBJBAFpn9tiRn9MWt-GJIwtITOjApGYVr11_ThcjE8PWNA1DwTrKoNZxgR2jojYMI5mpDVZCkfpvvFGNcsS6nsDjcQ7ig8D-IVoMOF2FnE_-pfEwk2BQRlM7Zxa_x_KrxRufMV28BoEpMD0B9ixzja58jhHoErAzQ_6hGUyvUtU7hxsLVRcRsyuz5gVIfXjw3q9hS-LokqsUuYuBZm78BXHbPEbUY33fzadyj3mDqRmZaBXQGJ554Nn5f76rhcFRnCYeHMe-S5RTq23TEb6F_ddDicRkhDV4oBORlJ_4FEf76tXvYDdw-SxEjxoI_pMHya4w0aoWkwshrVEmgqz0QclfySAbBAK3foC4Vo0pO-LP69lt_LZCFFJcnWFvNXb7QENp7Nccr65tIUvxkoMQRdkcKrGr5KjKBlOY28pOkw9AGVol0i83agURXSmCHw6NEMHXzFEljYaIgB6Visc89oJ_R3-122ZfelfUn27v8sbU8FYkOMQPWNJpnk4KjKDppaMHet0uGCD0jwQP-sW2IDMGBYBg4UZfdYlzbVQ9sEfyJ13ooryxXm1Dzhs2lcP06aG1Xz1pT3WzDs3JSQ3WvGkl0NA3pgbnrIRmCMVJaDf8hbvc8qO_2isNd9hHqbOmd2xhn3-GtqaQVHm3K6UV46MO15LDNrCFbTC4Wa9Yo0ZcE-i3LBJsHnLAZ6IB6aUQZcl40JWGueqq5EFIhvv0aDxeoUEvpP4EoM56ifXl8J6r3LJiQ1xHYg_q8kVUYIi3Xhpk1Ylxl19feI8mBUUfgxYEwQ8h6VnRHXrS2FzMxDUMxH37m_MQeF_l3lLotIN6rVn9_R7ap9aVJhpW7QNKakvdS60pVDbWGt4IDnkJVralRUWK0dpR93HLzQK_58kQnugWPU8AHpXTMhyUmmTRyjqD-hCF9XxTWmGo1VykFroXGza9dF13Ko1t8b5DuWDzWFisp1ekjeJ2CVGh2MdfX2IIi15HLVOUmNROpDC3iexxkYQvyEMyxpfDgCOz_KTLnwoD-PsA2yWavtMdG-jizxH-egL4V5d07AE387wJbU7PeD7BH0ua_Mwd-f_KmNkvBYwrLJEEnxUBCbslgtxKNi_KlU7jdSHjVJ374VKor8fCbq8OyiPNHXSEN5rXlZt8K1M8Wd8HV5RysfQLhe39kaOc6aJtAZJ9R-WyOV4UJU5z5TQjrofbhCtAT3LQnfq97lFKHYOWzx_FCX-t-beLdkz35TDIB1oQW2TQSVPwMTHlTnguRmdJJEIwkjBoYAF8nS0TyWri2jZpk_yuKLvSuW4hOFoAU70u6et2X2zp7nlUMdulqKYUFPdYKGiQc85WZFB4kskh6ZZmzchTQRLFFVC3FHoHuK8uDaJ4ltdUh3Hmyxp-yvgbSjKUq6-pajskr3cKOpib86DcqpdWG3Flog7Fx1LrMcyRzmlobJQXLJDtoZ9wEKnoXPLw5nV8A-wh8fph1AWBEtOBw22ZuhqsoXki4tIumdiJRIhcoxSMVC_j73z1Oc0SopexHDAlRDGA1-WuaE5ZAIahgVB2Z6zqmplmxgyMUpZYBlGa44oJyJfZ1AYyUUfh_HKGtiWjEw_NM4jpXnmiFSzpEYHgK6L-MnS2V8isY3bGpU4TjVWVkEApWdBVmJs0W_xuh-nzju7yfN6Qq90BBdOHX7LEIvULVBDBYLmQaKG5WIPFX6rYEVzrnb-scjQvPVUbxVEAhW4LeJvvji4i07SIiej89krdqpMn2U74zC1sgc5pWBZk9HiJz-uCaPbh64dT-0uypS1kIa7Q3X5MW0mEMe4aNMIl4raoqBjr8r9BU9W22D3PxA54fqIT_xjSRg4VSYQGOHVfsURZnasLETW_uMRi5T5UvXhg5FFNdZtXFYUEpL1JhocdIhDRqTyvGFLr8fZIR-x9xBZjj3IiFxQB3lLvWNs00SKAID00ARoTgXQTOoRmi7DM2O0Zk".."MV6DAAmpvR0KyFhhD8cdBX2G3A3Q1tLsiIF1U4vLQIhrv3F1sBNNn4yhT1uw3lub10YWCUFimHOKwQOl0awASVW3Eg1_xTojP0oHF7SAhGilrLowgvlhvFIR2bus6obUvW7PQ5GjOT2-rGdEGEPYVTRDPIQZ4qCFgF1k77vx3H2LgyWvYixQBgl1Ugg_UnCjW_kF8XguftWkIwdyDZOUC7IbzlGoKvp2tGmHPGweSMRQAuQJMgdWom95MCxUcC--v8oVYSi2Hph1IS7Ztw2EGCA1tDVeCcscxo3oXQGePibBw_sBLUsmR4aIV21231b_NEmke7nZJs_xS_Ed5a1WDJLpMfzKaCwhjBKRFBLhcexKap39-CE1GCpNgo4MvTAnChQ3vGlFpa0m4MBtONCwmvKZKKO1L-XAEZSMENZAcXLsxI-xldONV-ywwyjUMAy01G5bcjbWtTsy86vq1lUWuWrAq3x-aDlz7i7KYxLDeEx9oG5b123a6SP61Vgu17BVljcK4WVKwsNlI4MIvaUKeugxOCySWbXunv8xM-UKdnTD7vv30xJ7ZRaip_8TnT6vWEO4eUA_VtCg0Se21j62hSvLLaYE2o0oKyfPMEU4GSCbyFCHurpWyWricg15gg0DBvUTIcPtzx6oZ7Vp_9eqrQzGHg1TRlMGWvT7GGrr8gJ5-ezlWn-cbpkYFGH7IxLJBX-VMZoipRnhx_28b36m5jhcxtwlbeLqHklnuLwtgHkmHHJAP3RSuGLT7cGo8Y6hbJ7IzBaKeCylS4hlcHrFx_9SBunEJZoA7ns1gCKKwTm7TEkvUTjADRY9nbCMTVQ3NI082qtZnGtcFPBRWz06XrqQztYO862WNNaeqEH_mq4NuKufOpbWzeeV9GDydX1_Uox0cuvpOavX0-HIVVRsdyBtcdBCic0L8pcD1BYax8WabDjd6MufH7hXOre6x8WQjZMFNYGB27JoKz7zEWl-we9Dl03p-W6DRjo12-TgMcMOZHZ5li7fT6p3LHSmgwuE3ynuy2QKtEqOr67X-UshX6tDKGeVmnS3AA915q3l7rzpXvezqzptsnOt_gaYnkWiAUy3pOnIIdstvTY4pb12EXHPvnOJWOaD0cu0HFeOST-cwGTb5vHm6ynAFdEzTXaUUmrkHfPswAQJ3Z7b3uB_i2BCVaIG_7igRrKdzP_PpRE3jYRLwAv3LgJW6OhLMSttZXTzR56I2ssfl5h2GKQpkZ92qb7p0wYHvADBC-wdQJ3ma1nQE_a1VgJYbqx790BAWKx5Ql25rSGDPA1NyIHoqc7yMzIQzAcanhXN3r_GJdUEKhbMzeRxFlQe3Dy9yalL_tQUVaqVokoHz0cE8tV3_zX1ZdUp_vm3AdkEIkgAMnrSLTHCHOBPc_zIFDleC9IxbjYkmjtlo3qaE-KzA2CjuxkaqIS358A4fZ82w4rRHZhaVMO_c05Xbq2-_EZ99lhW-zqlddz0ZFHFhlOmRvoluxSfTqB2vF47Z_1PrcbW3BzA2EqcgHy8ZtGTwj7JKgK-R8FYpTGUYA4F2oXPhQG1EjDEsZBlil3R7jPsNcz8M9f1yy7C_OtL3bJrUP7nAYYKxJfc6iJxS2_mBNDCyZ6ksvO6G1lGG4laVFE8zxbUUtMWHQa_TuTJZTJ9np_6EeOKCwBM5No-HE5s7f4XD9wgVhXtXWxNA-UwUMXTBLjY-dzpRFQmpVfT939f9r6jhNfSjDZhLW5NXfOeXJqAXABXbq9LUdvdji5z9Dna_FZdw_Nqxe5m1-dXLrQvfKHWG3UuY6ipbicTLBZS4YLUBxgizHcoxXMMNUHNS35vp5WWKtc_KjpjhyHX5VpihF8Zsft0hFzoYO16WtfLPTC1bSixszCF_ZnHRqE9yTC2TDqk0CokfX--m18VRyeTg2z6iLvxbr5SNOnzEBXARfNxmIEitF8UUSZnzlQLrUzwfy6LqMjWRMlsI6_gr-6JHE06Wz-dncttuuAyvWFh-cZ-LNgzajtOV1pefeQxMDqLIaKGYzDdjvEc8YhxUjhU6un-497rwJWwi071rViWvcTIYtyj2TXj-CfP4_G4-LxiGfUaq7kwR77EKZwytimJg76FHBYJA9Mgm7HEYXwV7NjxhTYl7X5vJp1DJDUECK68fid7guFEBX8wjU3HGA6Y-Q3EKyOjio9h9CiiJNLZpLYNsEResaMdkE2kGLYpF_I9xCtGi0d1pr97f7SsdQxH4jnMGCGS6vFzZm3gOgGHNQWkEl4L8b8BQOZGD3hRTCkqPdo7dpoiN6q14PysQUUK6iTQ19oqzk78FF4mnt9VSDEbk7N547a3LXFDETep0vLwhxih5WqwQR_LrzDMCmQrBjdOMOuP_5arakMiGsxBA2eNC7CxAjJTuFgFj7jPE2DgikLgd9qERhj32P1n"),
"I9p1aePMekJDjlAsSRX6EokpV-ED_ff5L8_nurGHMZ1l3G8TUEDbD41XY_gkwPLBx8tPfLMoS-SmcNRnmtLYhlkkmZhlVhlTnw4jOoNxrrv7YRggaMldBJ1I4xjD7IUSkFrZDOPJiGbID4INlZFzwj-k9z60Ot6qOhfbhzkD8wGLUfp1K10gTbJrAwAU9bIgpj6clL0bT235lef3llJ_hgzoFr-jGhuH7FpNYnm3VArtV6l0qGxDVc0GvJ798RCpZrWcMyA9tJ5-0Bm4-YmlSm4iQV5n2wuQmnbOce1Cj92YSYUEp4-qjkWxU8slGRNzovJMcA3sauO5v8OAIf8h4fvrSz6ed_7Rpg0DA5FwJMdCMb4kb0z6nVkSkNGY6TCrhqhik5XHrShkREla2I_kNNIG1k1aTNVOw-oKgz506kMPXBPUUwMNGlZxqSlXuuGG1jT9GcbH_5uSv350GjnLdSzT9AnPOMGujDcteq2EkMl7PFmHKU-lTTt2qmLJD51VcnVJbzpTWdZ4QWQ0UgmlqdkUPdMcg5xLENkiO_zi4UYnb_hNlWRo7_C8aN0GP2qMWf17CKcJ9_MPkNA4I2hG35IVcKe9TvHmCcIljxVAjMfMOFtG1vs4WF9hgHSAy_v4me1-gkVCtTuO8dOc6BqNLQTYlgxXhqtMyCcxoCCXUcoO07Vo_XRM2qYStyfYhn6yTDHYVGMO--e30DRhX9V9iW4esCklpw9N7uPWjeZQJj-j2-VgEO4Jk-eI4tqu1dvMZrQOrKTmiLw1MABXQu1J-oQwG0k9ucpZqB028bCOLqrPlXCuoLz-TDz4eV6Ow-cIf85gs_X3iYrOrAsSqi8AXZvFIfsH1cvA6W8_f5shzyZU9jaASduvV5phg6GC44rQKWluSI_qG-SRbo7D75RFCQdLXaXN0XIAFgXtJThCrpr6pdWGirCQz1LxJcbt94GF1xGeUteh5CBYghSTrzVwBWKceNR1A5GbOaK_XUblwmxlluzZEua4Kh1AoXK3l5-dCkn2ODpZMKIU2azGFPs3skSq5agtnapRsZAhAjA4OLasmyESQ1oDV9NjDhG2wtzTMNy6KwyVP95koP7q2Fra87U9s-C4Gjb_V0n6cCgKaRAsIeT8LBtLmqb272BCELSOviJP_cUXJT6kENQUMsRNzk4ehyXnA81tky8t0K90f3zlU-C3iKUzOe5kZ-86qclEXOxoWDNqpltngHcjT5Wf0voSHtTHFQa_SZ7UnirEeXI8FXjAcdsilGfQ-vsBMxqe8MBNL2sn6Dycy_FrbXsWDIoy9ne5lrKLRX-a1mKEUO0KmmYi6rDvRHSioM48J3HPTWnqenHcuXPg8YLTh_SI4x14t0UdHEKYYwk734bD1INSS6oDP9_JZwOWFF-EcTxqdn88iLF76ovQ4Nftkj96KZULEsxFFK7TcKGayCPBPuUfGDj68Prw4dgzHkeKH3izngzg-jEc66WdWh9h5HHT8iqLvtl9P9htst74NGZGXR0H0D9_YurqXGFnCuzad_KMdsWsr9GpGovIys5goTyYL4tyhfQVXRSLxEWnuwZyle1b54zJWLzjzr_9aWNAawBBpX-0ytTteZknzb53sDkqMmPw3SVNd-N3hdFHWXEq03aYdGeV24F17jk58_XDITuTiPfi_vwCk3ShSBAcKTx8pSsbiPgmCAAoQx9A3THnf_B7KnVT-U7d_wy9fAFNcAYRGBb3ZO_1gNrw9gefpEoqORLbkZsmxOFePQCaWpXQGXvtCmKVxPy5HsCvZd4lktIltdlP0fPGNRDgtJPn2koXymwSzqmgyMo9cylePWDsQ6a5RY0mwRTpD1h-GBh18CJt0gRAQMf2yttuK1eZ6UQWlwpzON2WOgjKzDE6DVAYwldgk3rCwEbopuIlQJJBCfeju-yaNrKMhpmxlBZqdhIKwUz-EPbklbPQoE6siGDJalwZkkFaB612Z-7RLzNfhFR6329zmZlkv1QOqMTzM-c1gLDVu-rh-hBUxv7kZ2SOaMhuvynpUCs1L46kcNvGJuMgGHM9xV86b7u1jfamfdkCCxQCxHT6M_0Z3siqjm_RXZn1wxi3wQpM-IsahOJl7gwTVX9oenJFHlmOKS-5QbVUEUEyYrEu3-e1IiROD9CDVRnLzarmffkEEvIX3OSC-oi0_lVFoAjoTSsMYv3Lb4fm95IgB5Ai9UsZ0lELG9FURmFRDs8z1ymKuxQy8xXRKSz_mW68y5wz8adB72PG1FzoLDudW8Zl98thjOAmULvp6x3IxhuDdwoEAObx2mQF8FTFIBQa7oOb9nHR3EKowFl_aM12Oqhdl20LwkvEfiDAd8Ptvj-z7om4Ksdmw4OISUv2NdNFygh7eNW2VcFN3i5X2LEOzQEudh8VVq9pdWWcXhIzPQRodfNfpTp3NgcEjt0oRbIc9g_PBlANqlR5LsLWgT3yVzXjwlpsQaB7Mec8Cfj1i-NEVleSqptOpR81p3bR_Hnc1SMkfPc44Ti2Zn7bNI7ML9qa8C4WSk2BgSI_j9oXR-Lm3itV5DuHL5bgX8TFX5qUsQo0ctTsS2lD49UzgMy1aNyXWIWTVV1mA723Xx-0wxn522D5Ir81e4zZId5C51i79PDj2nfoT-UtXXmdpTXsshJircDvNediu9QjHm1LpcxTBhn-9v90hPyBpZYJyxftb7T6erSZYHkUx6HQ3TVQSD-Mnj2pmHA8JBOoC9njrlqKp3ldce9utRMfD_88WK6EpUoQ-5Gzuz5bD-Vp-Qh7VzgFJbNIw5rPMRKCl-nPEfxMmmYcYPf7qt58F-y-R3YRw-IWS1wcbbK5FXQPKrubOAUcvXM3Hola9QeubQtZofeZwljljQU4Z_010o_NoZk1XOdNFrd4sMS-tGwGRd6HGYpclyXkRz-zZfZUJpHG3vWQkg0ZNR9mWSoZCJJxFMeA2W2TyzvzIqoXby9HIX9nLwctMKVxNPPi2GnLhhlEWnU1dRXdLRy38nIEhoEPeQMZaLDpqEHBBM8R0DmbzotWogMpN9RgSCvYByasUylfbQS61HoepVjofsEwm-IUCaeeys50tceclf5cFuD5lolKdevKjOHUopVAG70y469CT8w-XzrwY8UHXJHGrSn19-x0DjUBasBd2Hv65KjDlrSwAyWnHtYvHDlBsd33cVX4wIDCAe9fOp8cOwR39O7dV-1yXDdFrYsNbGMLdFne63pDEoavoA8Rk-g4vSIT136W6B9U60fYMWJLEkljmYSHKq9zCGRf4pxZXLlTpzE9jRZOkYcgLekP4K1LGriqM_BPPCiSmejBba_KZhzqzacOsf6Z3T7M6b7BkE_MTJshpjj6qTQB83Hop4_WBC_BobIb7o7odsUWQ3DvJdtG5O3A6bqrc8oEYt8o6hn5TG9B62QPpSJFFK0pVDVC14DOs7K40lyE8JpaE3A_BYiqoICMDujuObhbWVIkuX8N68cZWmBCaCDxCE1LLH6QmVRHOLp5auy0jYFnrTHsJJVZF1jHA_AaExT4XEBcWrbpxOVHlwvPS1WcibU2aHbM5F9H9gU_ZJeJYZ3E58DlmbUj5v-Fk7hRm3TqYYoN4poI_2iEGIzYMMLaRwro9Z4EkBu1Pf9X9Z9MDZqsiJSPdkwebPUi2qPLByPMWDZAMx3CrAPi97NwKLPwH5uWn4Djsn-cs0rOEHlGW0ST5Lng6gOYTQM3lhxZYXea16YXl0CPKxmwzKoL_KEl8muEPtmuRwvxjXoWHQ-VfMIRYos1FzFt_r2YOutGmuNLHc-2N6QmgMx_FWPJgkY5f83uODcTsz6x8Wd9o2IMnP8FjeIqkk3iPQvFg7G3R6ynassoB_57YecKQL6b-I7KLf6O_9XYh2Qy685CtemcDcCu1IoOnBrYGH8fThcqW_PrD9qUWNlyzCZW6ine7uE28F3goY86IzKHCxUUFY6mOLi9P00sr15pwnzY0T-1xCQ-Rgg7I_xMtmbnfAU67Z0Cgt5_osiIjU0xRnB5Mph88avYD5MujJMGFlnNBGvieEtY01OBMJINY3_jnzfgNeKethPEtbyUNeYO93l42Mv_6eD37rwrWOpl8HqiOROfjlodGCmDJaBFGwjBwSv7_ugaAqUbxGcmu54hs3pId_XdjXzN5UwaXjS9-wjq7J0niKa2vMNCHCcDjYTHT2U7_pztlWP7ty2Pr71qW5D7dEscX1QG2vTzRXUCYSDkRtqDC5RqJGPTC8_JqCOR-dGKBVEOTvvOie_rAGk487ErrTnRj4MTVp-zcv3OE2wOptNjLJkAQTyNUA1uxr5lpFLzA_wu8IIoCO0dz-lk0WS9GIfA-HVabSfu6XmkJ76uQCkdEQwZYFiR0DoSu3iZn4_4h8UoyoBM_ferS8cakEKdycWZ5gzO5MVY5D1i_mcQ01g0UujbivK5DsQwEEhI0WH2dG_hCUL0enxm-QtTyd8KVJADLjpp-S_525YhpX_t5F-Lpaig_InIDcMRyjTFE9ZzHTpc6EuFoUyVHo-KxTgpcgWr53Vybrj44d6bF2hwWJsbo20POMXhTXjffj4BJN2-5O4sXszlHABlFYkkuzG-wNOf-MTM8Svmir5hpWwHuuQ-ZqZa6wBIiVl-7w5-mvGvvI494CbgBDwyw2_YUCRn8mvmoUrR3IrFybzgoRF3IZTfkn-fCiyPmzX0mrap0RKHwJEHf_GT0XmE9IVukC-9SqRAkJ0OXwKlcGx1-vibCzA5q2ix38wQEbhwFxsNUuc7UhgqDsKF19wD9yeyfffZmLaLSsrlxHHTq4UinqlxH3haWkbCF7jf_02Lh5OdBmuWmCC4miMEQuRFDYptZf7fAacJvVls5pETpxVMatXINklXjdTSiG2RpuPMCjZlUjtguajK494Kd142vHBUmmECKoWMB9ZowR7dHnesHJkNia1TtahgCwIAZj9j-QbK6nwzFTnOfr76spC3EKPp-HQzIQhdeNRhK25ggUalDMuKVwN8HzFMO6FhRtZWctayCSPlzSd5MMf7NAdUOSlgzhs5_T6fnEj43QCHTjXIOHBHIi-w0mygwCuEVwAv5Qn0s2Dkl0g1Josjay2GpSwGavq9F-PuqlWLXYQkV5zqBhThw8jv4WA-gEhXngfJJwQB26H2esSjNgaRzI3n5i95_FncHCxesE-xpMKCQtCVYSMZkZN43lLAwGMkVG4LLXqD14fLcE3GvwMIuuaptkMQJNKx0fHvmDL7c33ka9wSLy4cZgTChiF_fGuPKpAPsOk_PX4qA0sUMqZnabRw_9SAfZMojcpJwCs4yNXaMXf945rInow0DaRwDrJdvarcs8mbEOQvUgQLwOWpxzwFlQm5DsaXPZLA_DSKSOS7NS3Kon42sZhgQlCyRNT9pcrKXKoNgaiOraPOx1GjxMTKbqi5SoXFGdHjbsdtqjuNN0HHuD_D_0RmzQlhMks_lu57j8lv5vOYIlNtD4Wnw0axuIkDTNgHmz1yHY6F0CAYM_OrOUkVLUzauNt54k8YXQ2f1I-Y4K2fNfnaRrSpZzqGRq1P5EnpWUArPUB5_r1a_240HtNxD5aRNECOy_GpimGor3QPsYXnW5mAD1bscYcCSio_TX-nB4HyLBr02A7t1zO6nH1x7-DzBWd6NWdPrU2_lfsyXEuDiUJnxsrUgP3x4Kg1nWV0QxfjcOMziYIVRFumkQ0iEuOu_qgDZf4HowVhexNvfxH0N09ZvjrL1Szmd8eJ2liNG1oYvX6MYreUjBIhL1HxDOyMqT_sMYcu_q7r49NawoJg0a0vgGsCQ_AE_7k1uH95IKiV-rmAf0abddxbm9JyEnuZ1DflhDO9aFtlbJGcgFl4vRDklW043pP5d76p0A7jaMlmjYjy7nNob1YE_X9bocd-2XWKNjqvyAA7HmLwzewlUBAk8d-6oZWUUC0y-F8Bongzt-wLFrDA0Nh4QryT10p7lNsEU8viVw1vDTyAlbqWQNB8hbJL-d-ntjQX0xoM1NQOcJw5JnLqE0RzadX1TSlRCw-G88J8NixEYJaOvTfs9rIF8oKHrBRPRnFJqqZwoy1yU_V5s7VwRHq0sf8qvG-C2JdC9BFFMx-cYHTHEsiXeeDhiQGCBpnetm1MqVjB_PsdoUrfK-b5AAo0LZAkvj8A0F4WUzaQ2RK6JQaGzID59B7XE2cegFNVAPJTQ2-TEWDikCqandAdBEBwZ-VHOdWPA8MFNNW1i4bnFmav5RTUeSUewS3e8Ch0aSugXpJ2rFg8sGD0bPQ75ACj09r7ztw1vnqlTYBYRjFoYxiBKwEzi0BErTVXrM6YK8oVV0wL691vxLd_RABLuxsCvIIerjxtYdZolYy1xWFwEGHL_uBc0LqizPNu6Fv0ACqF154TukdvmjjgDIlOo2o11lDFVaWjTXdRl1Wi7NNLM8qQx99wjvD_ZjUQraaRIWxtMX35l4hxV4o5PxY_9rgLXrFixG-kNTCorK4bX60hVaX4339VyHep5NJXPlBzV2ppZT7Mz0A-8i-Wikd5ToMNq3O8jDyxmkCkekRTzSI7oNETF2dNxJck_U7DLHIZUzKZaN3f5ypKTi8U6gJfAIWQOynZSFHZ6XgdWt8QYJtDatT7gTXoze08EYixNyC5EGIEN-Lgx4pVvSsNmw6HCOTZ0l0gL_tD7bSiPOedOnHIS1wRGBDwNiMU9d0FDqlpZLYppjkg31NGspC-7KCq80rJP7qeQHkJ7KLQMgdMSDwxMl1blo2ujhvfSahqyNw5qc6fAHNdhuXkWJC2EOjnafMM__em4ZHhSmM7KctwywnTPTuGth1qgzzxhmxDjIGkVypzEq2bj5BsPOeo1riQ6FPjL_-68HPfzaTF-M1QLdJwQlyhk73z_BbfAyDnQe-UUWq5ZzhqE8RJuroI0dr77ZOkAc7SPvP3ugvlU_uvtV4vz2f1nLRepAZEypueEj11IBkkLy2FkM3N8bkr8p_46jirqJJiwFSqTMRp",
}
local _1={3,1,2}
local _29={} for i=1,#_1 do _29[i]=_f70[_1[i]] end
local _6264,_90=_b(_e2(table.concat(_29)))
if _90~=2424486416 then error(string.char(52,55,49,56),0) end
local _ae
pcall(function() if type(getfenv)=="function" then _ae=getfenv(1) end end)
if type(_ae)~="table" then pcall(function() _ae=_ENV end) end
if type(_ae)~="table" then _ae=_G end
local _b50,_2a4,_161d=_az(_6264)
local _cdfa=_px(_b50,_ae)
return _cdfa
end)()
end)()
if type(_397dcf)~="table" then return end
local hwid,_0b4eaf,_3c2133,_1682e0,_1d1449,_ca7e17,_e23414,nap =
  _397dcf[1],_397dcf[2],_397dcf[3],_397dcf[4],_397dcf[5],_397dcf[6],_397dcf[7],_397dcf[8]
_397dcf=nil
_bb0af8=(function()
return (function()
local _49={}
for _ucy=0,255 do _49[_ucy]=string.char(_ucy) end
local _15a={}
do
  local _hsi="G0U7z5MEgoHQYLjTbu64anW8Or-RyVN2XwC_mSd9icZ1sfDBvIkK3tpAFhPqelxJ"
  for _ucy=1,#_hsi do _15a[string.byte(_hsi,_ucy)]=_ucy-1 end
end
local function _e(s)
  local _6cg,_bct,_c2g,_qnk={},0,0,0
  for _ucy=1,#s do
    local _1g=_15a[string.byte(s,_ucy)]
    if _1g then
      _c2g=_c2g*64+_1g
      _qnk=_qnk+6
      if _qnk>=8 then
        _qnk=_qnk-8
        local _bu4=2^_qnk
        _bct=_bct+1
        _6cg[_bct]=_49[math.floor(_c2g/_bu4)%256]
        _c2g=_c2g%_bu4
      end
    end
  end
  return table.concat(_6cg)
end
local _30a1={}
do
  local _rh9="y#\1420S\194:\162\205\213n \168\221\153g\183U\127\223\133\\\222\246l\026\188a\156D\003\232R6\227{\015\237\009`\136\167\199v\177\158\146\0051\196\204\1495\144\249\243\176P\182e@\031,\248\254*\025\218\235\150\215\151Q>CO\216XW\132j&\002\130\014(Vk\027I\203\253\138B\160-\181\163\001\219;\229\017\134\143\024\131\000\231\178b\1934\012~\154F\226\159\1553\208<\173\228\148\016!T\251\172\239\250\135\197h\224\220]\0218\139\020\230\252\028\236\238\179K\192\242\180\007J$tH\171\2129\198\023M\211?\241A\209\245\186Z\170\200p'\201\n\207\004.\029m\175_^\141\019=L[\128+\137%\022\233\214z/2ux\234\202\187w\"\185f\189\008\165\184qi|\225\157\1667\210c\161\164\152EoN\129\r\030\191\195\190\140\255\244\217sr\011)\174\147\006\240\206}\169\018YdG\247\145"
  for _ucy=1,256 do _30a1[string.byte(_rh9,_ucy)]=_ucy-1 end
end
local function _5c6(S)
  local _oz9,_688=398555357,249
  local _6cg,_bct,_eeg={},0,0
  local P=336035 A=-1062287965 L=3385323
  local K={174,114,245,115,201,233,27,19,60,225,208,239,99,57,52,37,140,72,48,226,116,195,89,91,128,78,220,126,6,82,114,177}
  for _ucy=1,#S do
    _oz9=(P*_oz9+A)%4294967296
    local _k78=string.byte(S,_ucy)
    local _24h=(_oz9%256+K[((_ucy-1)%32)+1]+((_ucy*113+L)%256)+_688)%256
    _688=_k78
    local _dg4=(_30a1[_k78]-_24h)%256
    _eeg=(_eeg*33+_dg4)%4294967296
    _bct=_bct+1
    _6cg[_bct]=_49[_dg4]
  end
  return table.concat(_6cg),_eeg
end
local function _hv(_bd, _me)
local _dy = table.unpack or unpack
local function _oz(...) return { n = select('#', ...), ... } end
local _za
_za = function(_jx, _uj, _vd)
local f8179t, _hc, f25fgr = _jx.f8179t, _jx.k, _jx.f25fgr
local _rg = {}
local _an = _jx.f2u5bc
for _yv = 1, _an do _rg[_yv] = _uj[_yv] end
local _rc, _ce = {}, 0
if _jx.f474ur then
local _jm = _uj.n or #_uj
for _yv = _an + 1, _jm do _ce = _ce + 1; _rc[_ce] = _uj[_yv] end
end
local _nf = _jx.f7xmbc + 8
local _yg = 1
while true do
local _ji = f8179t[_yg]
local _vo = f8179t[_yg + 1]
if _ji == 35 then
_rg[_vo] = _rg[f8179t[_yg + 2]]
_yg = _yg + 4
elseif _ji == 17 then
_rg[_vo] = _hc[f8179t[_yg + 2]]
_yg = _yg + 4
elseif _ji == 41 then
_rg[_vo] = _me[_hc[f8179t[_yg + 2]]]
_yg = _yg + 4
elseif _ji == 2 then
local _gq = f8179t[_yg + 2]
local _fa = _rg[_gq]
if _gq >= 256 then _fa = _hc[_gq - 256] end
local _rr = f8179t[_yg + 3]
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
_rg[_vo] = _fa[_rr]
_yg = _yg + 4
elseif _ji == 18 then
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
local _nu = _rg[_vo]
local n = (_gq == 0) and (_nf - _vo) or (_gq - 1)
if _rr == 2 then
if n == 0 then _rg[_vo] = _nu()
elseif n == 1 then _rg[_vo] = _nu(_rg[_vo + 1])
elseif n == 2 then _rg[_vo] = _nu(_rg[_vo + 1], _rg[_vo + 2])
elseif n == 3 then _rg[_vo] = _nu(_rg[_vo + 1], _rg[_vo + 2], _rg[_vo + 3])
else
local _fa = {}
for _yv = 1, n do _fa[_yv] = _rg[_vo + _yv] end
_rg[_vo] = _nu(_dy(_fa, 1, n))
end
elseif _rr == 1 then
if n == 0 then _nu()
elseif n == 1 then _nu(_rg[_vo + 1])
elseif n == 2 then _nu(_rg[_vo + 1], _rg[_vo + 2])
elseif n == 3 then _nu(_rg[_vo + 1], _rg[_vo + 2], _rg[_vo + 3])
else
local _fa = {}
for _yv = 1, n do _fa[_yv] = _rg[_vo + _yv] end
_nu(_dy(_fa, 1, n))
end
else
local _qm
if n == 0 then _qm = _oz(_nu())
elseif n == 1 then _qm = _oz(_nu(_rg[_vo + 1]))
elseif n == 2 then _qm = _oz(_nu(_rg[_vo + 1], _rg[_vo + 2]))
elseif n == 3 then _qm = _oz(_nu(_rg[_vo + 1], _rg[_vo + 2], _rg[_vo + 3]))
elseif n == 4 then _qm = _oz(_nu(_rg[_vo + 1], _rg[_vo + 2], _rg[_vo + 3], _rg[_vo + 4]))
else
local _fa = {}
for _yv = 1, n do _fa[_yv] = _rg[_vo + _yv] end
_qm = _oz(_nu(_dy(_fa, 1, n)))
end
if _rr == 0 then
local _mp = _qm.n
for _yv = 1, _mp do _rg[_vo + _yv - 1] = _qm[_yv] end
if _mp == 0 then _rg[_vo] = nil end
_nf = _vo + _mp - 1
else
local _bo = _rr - 1
for _yv = 1, _bo do _rg[_vo + _yv - 1] = _qm[_yv] end
end
end
_yg = _yg + 4
elseif _ji == 29 then
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
_rg[_vo] = _gq + _rr
_yg = _yg + 4
elseif _ji == 16 then
if _rg[_vo] then _yg = _yg + 4 else _yg = _yg + f8179t[_yg + 2] * 4 end
elseif _ji == 1 then
_yg = _yg + _vo * 4
elseif _ji == 43 then
local _fa = _rg[_vo]
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
_fa[_gq] = _rr
_yg = _yg + 4
elseif _ji == 14 then
_rg[_vo] = f8179t[_yg + 2]
_yg = _yg + 4
elseif _ji == 12 then
if _rg[_vo] then _yg = _yg + f8179t[_yg + 2] * 4 else _yg = _yg + 4 end
elseif _ji == 32 then
local _gq = f8179t[_yg + 2]
if _gq == 0 then
local n = _nf - _vo + 1
if n <= 0 then return end
local _fa = {}
for _yv = 1, n do _fa[_yv] = _rg[_vo + _yv - 1] end
return _dy(_fa, 1, n)
end
local n = _gq - 1
if n <= 0 then return end
local _fa = {}
for _yv = 1, n do _fa[_yv] = _rg[_vo + _yv - 1] end
return _dy(_fa, 1, n)
elseif _ji == 40 then
local _gq = f8179t[_yg + 2]
for _yv = _vo, _vo + _gq - 1 do _rg[_yv] = nil end
_yg = _yg + 4
elseif _ji == 28 or _ji == 21 or _ji == 42 or _ji == 37 or _ji == 23 or _ji == 5 then
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
if _ji == 28 then _rg[_vo] = (_gq == _rr)
elseif _ji == 21 then _rg[_vo] = (_gq ~= _rr)
elseif _ji == 42 then _rg[_vo] = (_gq < _rr)
elseif _ji == 37 then _rg[_vo] = (_gq <= _rr)
elseif _ji == 23 then _rg[_vo] = (_gq > _rr)
else _rg[_vo] = (_gq >= _rr) end
_yg = _yg + 4
elseif _ji == 22 or _ji == 11 or _ji == 9 or _ji == 13 or _ji == 30 then
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
if _ji == 22 then _rg[_vo] = _gq - _rr
elseif _ji == 11 then _rg[_vo] = _gq * _rr
elseif _ji == 9 then _rg[_vo] = _gq / _rr
elseif _ji == 13 then _rg[_vo] = _gq % _rr
else _rg[_vo] = _gq ^ _rr end
_yg = _yg + 4
elseif _ji == 36 then
_rg[_vo] = (f8179t[_yg + 2] ~= 0)
_yg = _yg + 4
elseif _ji == 34 then
_rg[_vo] = {}
_yg = _yg + 4
elseif _ji == 8 then
local _fa = _rg[_vo]
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
if _gq == 0 then _gq = _nf - _vo end
local _fl = _rr - 1
for _yv = 1, _gq do _fa[_fl + _yv] = _rg[_vo + _yv] end
_yg = _yg + 4
elseif _ji == 25 then
local _gq = _rg[f8179t[_yg + 2]]
local _rr = f8179t[_yg + 3]
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
_rg[_vo] = _gq[_rr]
_rg[_vo + 1] = _gq
_yg = _yg + 4
elseif _ji == 10 then
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
local _uy = _rg[_gq]
for _yv = _gq + 1, _rr do _uy = _uy .. _rg[_yv] end
_rg[_vo] = _uy
_yg = _yg + 4
elseif _ji == 38 then
local _pw = f25fgr[f8179t[_yg + 2]]
local f1l0ea = {}
local _tt = _pw.f1l0ea
for _yv = 1, #_tt do
local _ev = _tt[_yv]
if _ev.f4zqxb then f1l0ea[_yv] = _rg[_ev.f57f6] else f1l0ea[_yv] = _vd[_ev.f57f6] end
end
_rg[_vo] = function(...) return _za(_pw, _oz(...), f1l0ea) end
_yg = _yg + 4
elseif _ji == 26 then
local _gq = f8179t[_yg + 2]
if _gq == 0 then
for _yv = 1, _ce do _rg[_vo + _yv - 1] = _rc[_yv] end
_nf = _vo + _ce - 1
else
local n = _gq - 1
for _yv = 1, n do _rg[_vo + _yv - 1] = _rc[_yv] end
end
_yg = _yg + 4
elseif _ji == 7 then
_rg[_vo] = _vd[f8179t[_yg + 2]][1]
_yg = _yg + 4
elseif _ji == 6 then
_vd[_vo][1] = _rg[f8179t[_yg + 2]]
_yg = _yg + 4
elseif _ji == 3 then
_rg[_vo] = {}
_yg = _yg + 4
elseif _ji == 4 then
_rg[_vo] = _rg[f8179t[_yg + 2]][1]
_yg = _yg + 4
elseif _ji == 33 then
local _fa = _rg[_vo]
_fa[1] = _rg[f8179t[_yg + 2]]
_yg = _yg + 4
elseif _ji == 19 then
local _fa = _rg[_vo]
local n = f8179t[_yg + 3] - 1
local _yv = f8179t[_yg + 2]
while _yv <= _nf do n = n + 1; _fa[n] = _rg[_yv]; _yv = _yv + 1 end
_yg = _yg + 4
elseif _ji == 31 then
local _nu = _rg[_vo]
if type(_nu) ~= 'function' then
local _fa = getmetatable(_nu)
local _gq, _rr
if type(_fa) == 'table' then _gq = rawget(_fa, '__iter'); _rr = rawget(_fa, '__call') end
if _gq ~= nil then
_rg[_vo], _rg[_vo + 1], _rg[_vo + 2] = _gq(_nu)
elseif type(_nu) == 'table' and (_fa == nil or (type(_fa) == 'table' and _rr == nil)) then
_rg[_vo], _rg[_vo + 1], _rg[_vo + 2] = next, _nu, nil
end
end
_yg = _yg + 4
elseif _ji == 24 then
_me[_hc[_vo]] = _rg[f8179t[_yg + 2]]
_yg = _yg + 4
elseif _ji == 15 then
local _gq = f8179t[_yg + 2]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
_rg[_vo] = -_gq
_yg = _yg + 4
elseif _ji == 27 then
local _gq = f8179t[_yg + 2]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
_rg[_vo] = not _gq
_yg = _yg + 4
elseif _ji == 39 then
local _gq = f8179t[_yg + 2]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
_rg[_vo] = #_gq
_yg = _yg + 4
elseif _ji == 20 then
local _gq, _rr = f8179t[_yg + 2], f8179t[_yg + 3]
if _gq >= 256 then _gq = _hc[_gq - 256] else _gq = _rg[_gq] end
if _rr >= 256 then _rr = _hc[_rr - 256] else _rr = _rg[_rr] end
_rg[_vo] = math.floor(_gq / _rr)
_yg = _yg + 4
else
error(('E'..tostring(_ji)), 0)
end
end
end
return _za(_bd, { n = 0 }, {})
end
local function _sw(_uy, _ky, _xf)
_ky = _ky or 1
local function KMVX8(_vo,_rr)
_vo=_vo%256 _rr=_rr%256
local r,_jx=0,1
for _=1,8 do
local _qb,w=_vo%2,_rr%2
if _qb~=w then r=r+_jx end
_vo=(_vo-_qb)/2 _rr=(_rr-w)/2 _jx=_jx*2
end
return r
end
_xf = _xf or 47605
local function _ac()
local _gq = string.byte(_uy, _ky)
_ky = _ky + 1
_xf = (_xf * 1411 + 7935) % 65521
local _hc = _xf % 256
local v = _gq - _hc
if v < 0 then v = v + 256 end
return v
end
local function _ld()
local n, _ih = 0, 1
while true do
local _gq = _ac()
n = n + (_gq % 128) * _ih
if _gq < 128 then break end
_ih = _ih * 128
end
return n
end
local function _we()
local n = _ld()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _hg()
local _jx = {}
_jx.f2u5bc = _ld()
_jx.f474ur = (_ac() == 1)
_jx.f7xmbc = _ld()
local _lo = _ld()
_jx.f1l0ea = {}
for _yv = 1, _lo do
local f4zqxb = (_ac() == 1)
_jx.f1l0ea[_yv] = { f4zqxb = f4zqxb, f57f6 = _ld() }
end
local _ek = _ld()
_jx.k = {}
for _yv = 1, _ek do
local _zh = _ac()
if _zh == 0 then _jx.k[_yv] = nil
elseif _zh == 1 then _jx.k[_yv] = false
elseif _zh == 2 then _jx.k[_yv] = true
elseif _zh == 5 then
_jx.k[_yv] = _we()
elseif _zh == 3 or _zh == 4 then
local _xq = _ld()
local _ov = {}
local m = 68
for j = 1, _xq do
_ov[j] = string.char(KMVX8(_ac(), m))
m = (m * 3 + 3) % 256
end
if _zh == 3 then _jx.k[_yv] = tonumber(table.concat(_ov)) else _jx.k[_yv] = table.concat(_ov) end
else
_jx.k[_yv] = nil
end
end
local _ti = _ld()
local _hr, _wp = _ld(), _ld()
_jx.f8179t = {}
if _ti > 0 then
local _ss = {}
for _yv = 1, _ti do
_ss[_yv * 4 - 3] = _ld()
_ss[_yv * 4 - 2] = _we()
_ss[_yv * 4 - 1] = _we()
_ss[_yv * 4] = _we()
end
local _sd = {}
for _yv = 0, _ti - 1 do _sd[((_yv * _hr) + _wp) % _ti] = _yv end
for _yv = 1, _ti do
local _zw = _sd[_yv - 1] + 1
local q = _yv * 4
local _ev = _zw * 4
_jx.f8179t[_ev - 3] = _ss[q - 3]
_jx.f8179t[_ev - 2] = _ss[q - 2]
_jx.f8179t[_ev - 1] = _ss[q - 1]
_jx.f8179t[_ev] = _ss[q]
end
end
local _ok = _ld()
_jx.f25fgr = {}
for _yv = 1, _ok do _jx.f25fgr[_yv] = _hg() end
return _jx
end
local _pw = _hg()
return _pw, _ky, _xf
end
local _088={
"NQvKPq-qDtxA6qrtIK3vksoCXRVAf_NsH6t5FZlOKEvdsQOO1FqNiOYTLu21Gz3NI2vLkAB7C6iYRzm8C2mXJZLMkkQX7OGI1LHIPorhzGCrlv2z62u4KAiKOY5_rTP26z9WPgFWeoRzpB8ETi1eoVUOW0OWKT3NiHNCzevyyGl7C3_XWLpfATbideahkrkmPutKhWJ1OQT_bDH4WT2IOSZj18SP5LhcnJIM8RMoiCySTIKBFOppC0OQ82POtk5r_VlN6EUikUlFexs2N9BEsWV3dFeQrQ3fv7LzhcVdmhkFS0s0D4xqX0Q9kp3fZSYIKO8YFQDK7odYMeh7wnwQiy9zADbhfvR8yqqvaFH04coNkWq8YY4NrJc7-mZuNB45mIGOqI3Tr6KO7yAeM35aR6tpFgvv5YFgIKqFRgasfZqhDaCNqMxgFcSb1-FmlhY01AAXekrSrJGFZQ7EBEFQJqSuW99rg9Fdu4TJOPkx6ncRtyapB4xiE0Tr0GmiTQQNLw1LuyIa5scpO4Vj8_ChjGXO72mB_sVvWJSAHDg8C874Mx-Q_3PyH_QQFLUb476PUNYtihBLvyzb1Guswuti2b8HUm-UlnmI26kQNnT0fyRAhzQv1JYBfFGq4hoBodigeNqgMXkPc_bJtc5iDqgr81tu3yc9IQaUoGRtZB1z400Ii85EsGMh9ptbhFOk0U3j8N6RM_efbFBQHE0umwui0wcib0lnwUmDhgwmwtPn_LuWiE-yUfI_HY2B85UH4fxzYWMHmlv6tXH9qZq-HRa6PPM0haavZM6srRKOX-FSMeW0iyF0ksyEArwfVWWkdNrFYzBhUYtSS2KtJowhNwn7pPqWmspjtRAZzmY8jqvEv_Xv2Nd42eiMyavRlNw5jwW7H0x2YP99arGJnxPHoY_b0mqVeEurKRhOX5sM1zeOTN4BExyTcKrjHtnwAM700EvzHwyg6b-5BFL0ws3jiBtzYI62D98rcZ_DPFqpVE9nui3lVoFP6VDL4Z4nM6PYBskVPTYLQeUaF8Tuib49pmTdpknKR9m2d-NxLVtScYn5KUwHs_6DcEvbmbY_JgbSk2RqQK5AhhE-8NsLB0e6Uq7pi9Ut49lz70xrfjgRKzVHuPjhmQe5T6abnZVKrHJ3TV7aEALJhxZaSfMubUbEAlLgTjh4QT-MIabMd9diWXs1Zf6DJBMX8FMsVKLDqMEYuMj9-dtI3akLMAjC79NSK-rNBa9E-7UV-styKIZATaIByNQ7mIeSi9JrrfzuKW3Ot9uqYeXbhOYYj32bzFzIU6nJCQ1-AR8HPbm1rGtyOHFFpwDQvinBUwsnC8W0O6prGzMckn7BouhlNApci_XGFv_yavapPxVQ3JMYS3-s_pJG__kzp6ih88A_0FYOa4l5CFnP4nGDNMkYnr0eFj_boYHoGynIsGBgJcUSzDdbIx59IZZg3n5xxSMxDMYic9xJgjc_NpQXlDaA-y8tSGWUv92bp0PFAYTshD0ysubmp2ecgQ5lLz3DbmjBLqnfBMVdue_MJWhnxPk6B9WCO3uemE0ybd5QzxJidXHZo71pg768K5J6ldU_Rb9TzFIp79jtExe2PsgOUre0VT_AMKtyMVjsZuALo1YjOjnIlgTqJZrl3l2dgg5NVHSmbuTiAto1_kY1FYpx9_nYfLPpg9cR573PK2R19v32raMfIozfEPz3FmCyNpPlFQ_qnVRjuQqJIn4RMx8d-2rI8xPjIg2ysI1vyST1uPsTlMuEgtA2KeVwM8mCFliyvaal0bBMCyQOe0WPGWqPN8JlUzOh5l_0Ao1A648uU7PMpLZSueHYUew6vHopq0Wy71XJKYD_lyftso7ycZQPHh6CcYuveefEFli7TQ2DnRTnjjFW6ML1FDqaKQasGa52iMFwb_L2hqPztkBIFk9wg_ZqmvuwJFoqsOtO9JSWNNitzLvVrQDUUYMS6rx9esDViVHs8Xy3oE7nzmvkizzMyLMbdafeeDxskakXfJ-5nW7Iua6eGgRyjWAv1E-4FAvoVqMNDyD1t5wcrz-rp15R8gRxq2nFskVZcRZl4w0YN7c1btG5W_IOHC8WnbSx8YAkTko5dlDQg5NfJaOkYhmL7_TqFyM-HuMXpnacdSxJb3QS1ufJ8bVVwGmAMMIqr972wvJhvI1Ya2z_yLYj_wXs7vzuzr7T98VknboHPPL926dw0ORjVMWPJrqmbhuHQ9_0VY3hscBSdtXg0zMaiIdOWCVEbr8yHe1I-bDTkgxXKhM5-stw7NKSM8Kn-rlTXLXR3YFZ8zgrd00U5OR_VgRTSVYrnTJ3qZEZ68JrJcGwzZReuqWeDrb-xeU5KSTv737_Y4LmKnrVcYsKo7KzOOEZpmMfNPNQK7JzY04KHsbW1SlIdWu39K2EsSmOZZ3uUgSN4RCTNjKAQyMdoISRD6qZ3okjWTkqXfq0wj4Nb_IUsWjfBnYdsxkVYQYxpodQGzc168IWhUiMAga3dH2i0c9LxXk1RSbqwYFCeTxlWnWGxdiplKHHM8_ppLvgxO1LDfwSC7GGYOEHOOyoo0FFcngsE277qoNbcYChMzOnZLFJrrXbhuixFVHtrh_fvZA68ueOo4V2rLCFnP_HP-ZdJUFgSOfVmOrRO-qiUoJ94HCN7w-5udsCDlhVTvalBw3S8tHrmB-9lnZkO0QKfZ6kF-ZQeSQZIihjhNR9r53di6l-iBT-WZQBTt_xQjHz2CV8KdIZt8HSZctIuwrZ4sMkizYe53sa0m7p8e3xAPkSXOtcNILR6p2hR6ot4FQCWDjd1veX2KiQTPB8uXg37oUp8uGQXmPCXgwsi3V7jrjIB35t0ozauK3On38ZMgtSH5rnf6whHFPXXVLiUpv5hLWLBJ_ACE_wIO7KNUstctLKfLbjwynaidk_hYi1E5DNiPkZ8rZdPPFrl0Ah3BcSOUlBbOTiGF9HGQR_ahFPCZUNpTxLnBaVq2yInSaEcl9WMQQgACVy-Y2ThdmqtAz9XSqiBsm0kSZhF7D6_EIppx6UCrUXcSLcCXT7m4rGUSIk6eEM3iOvtO-mFsO2S7Lc4eZb43w-Gm-bOD6Jp62Wa-cvaIvs_cogS4t9_l2moQTlg2dv1gHvFJCaXYUH-559pu5YkKsiphBAxrnKH-XIevOWQPNneMlwyFlQF2xjaT1baaRmMJIwIV6uOXQ6YkmIbZ75np4rO1j29T6ag6_vxbhRIL5hrCF6VHxM3dDM00SBiCaA8i59no3MO-uVTzd0XkckdefHN1lQxLlvXIVjIOLOJZmnrcO1-bnamVREG4_sqzWp0z9P0T77-RMWO_HnsbKoEhvtWno08J5q7jwASw77pG8sp1jNE68EOd0fth3Z8ixoRYd32YYQBxrTY5DsGi88PhneS9UxeG7iu8iuLnGTDtR-TVwo-bvf9xk_JdqPZEtX0ufN3z-jAdcMt_OL7HFhZHJPuRoVL62Bxz7FuVTjyFyqwIIrhJ-ihMhEA3rZgZHLNrTg-6Dqps9ZUvHZkauTmZhMukDnwf0xr1vSuO5LseN0qsykWoMNZK_xXn3g4Dr0n42eSERlrf3vug37NkwdVwyM-adBuyTd9utEMWzwsQknp8oLC7WLHy3pszhf8K-flAhkZu-apnTQy209rNW6vIHVL7Hs4B5454KII8Jvr7hwCS8HedlevtskOnoD_vUGZR7eYmSugLbv49sTRLLrADnj5FZDz5BVEvZC-ovXi7621LpebfG8uFIESycEMTwWcEUrFmpUevGk0faKyKXu0caEvqrQtHCCiZWsbf8NCO8QT3gylUUu9n7IZqfk0vekXBxnrN56OkaNplfTtHxz78Wob11Pp-vAqd2jFONJXD95DXZRBc5w8XheawSH-8jmq70ImTVDTuRlKNO5dDogXIQuZkn6enkohi8Gwu2ifgUZQfM-jRDuWlUQg67B65XYlFI38w8v2uyCqA5JHHo-_CY5s4cC2C0BYqoth0P74cXFJZAGOx7ucSQCCMye0zN26XLejDNulCbwsFLOLhIxcum1lYkuR8zfEYIe7Nr71DvnffgQWxsFIXi86r-qpY7OvpnYGnrybep-p5OT_h-QatAK2b9_qyQ6LyeM0ykrQ2TNZLHBMW_2x32jwyb4qZFHnBa7uaIuaXdRxDmiQH1-FzvnSHZDyPZ3Gccacc7WQj_0_nI_tMI8up42DVlQMFqVGswY1EuE9jrfT2prOaRZ2Nfmy34sV_mJEDYEp6NF4XpHzMCracFH0z5wZEQ-WP2YGKX64zO1ZHPBEjCraLSl6VeAYH1i5nGIbpxeZXEKn-QgJ1XHqRnTOjzpIzWKslGXtKVbK6A5sF8MWSARlQ3-lw0_ksNpl1QNcYRmsUoiTN7hfql5lgXhsGyTZYXOyZo_jD9AtG8NxZLzPfjtOuVzIkjrBWgckZfZbkrk58CM0QKknDVWXAqsetQ1ia1WQYBBdGCYxxrQy2FYuLmdgOefsE2kOT1uhHcHnb7vVwSr1O0kw77fYVF9_QOPPPN8m1oCSmpnYHKq_O79dgRGwwQ6i-2zJxU3QDsMFIy_8q2XbkIGEelv0LmJPPyrQzQAlC3akwHAldV6tn1P0YS5aIWzYlqW4a4OPzSrI5FI9IbBYTGhX37Tfk9ezbIAOeMdKKugSvUKhmZ5jBz3EdIDbF93YVwCCVo9OyJOyXiJ7ZBseHMs4P2Lpfh6QRDRjvDWeBLxrel5CkJnHPZzgu749KULIBc2DgU5m-8xMXrlzZSf-zG-C9Fpn6uapWiNJaU2MdfxCG48V-FzjaGu-soz4nhCUEDc7PsragusNseiPP2jJxd6auClmMS5HjCi5xeDf-WkwZuDvcazpmC9u_HYPOuFBv50q1uCuEHiyak-K1t0M_gqn0r-Xyu55kgQVL72j-KjxsUeZCaoBvhXAeAcYOkxLPqnw__Yi8shE-DsSekXZLA6Q9GNbCJsiB8Al1c3vFuX2x41drFCf8owiPG0YjKObtOKgf8hYdeisGtdm3gJ0ex2GSjXtRRQoiQM4M-Ig33bykuWEj0bWNB_Ut_eJAJW_54TD4Jdt0eMFfGqtzi2zI3ac6_G89G2qjUx7gBoJKkCJWIe3-f-puqKFTfPZH5cGr_kgtK6ceSFgMO_dLcGCDvtPD-LL-Jd55UnF-KM0uWLiojAXAnOqjniapiPPQS7_jecoQAP065o1RHp-PgmehSfKslot9UJKUgf_pGRXSZPl1FsZS4Vhe3Hv330VWRKva8JOMIVYul1HAtiSRsW2Yrl8Yas20yrI0pBiLfLUw-9yT2_k1R1JHm8ZoSIZga52MT63CGGnVZmczMYYaIHdY6rSRLGRmSX88rOknhjDZKZ3m35YC2LgSXaXicADST7Wrl9JzC3sUnbak96X0ovkD2z_y5Sje1gkPVZeoMCYueCB4nan0vdVJcKHVyLAUYBVDN10H4_RKS8Le1plUvVxFYd4Q8y9eWpu7Dv5ie1tIRYdyXNw-2UjwtQTX2hv_V8B0QV_igMMbeYJNhL67yBkHnOly8MjUbcYnli_3m3EWjUdV1uwqpAI5Uo_ixp7r8Z3L-03JoGhRSgGXKlPSh2Ng_apsAXhgDFzi4HqLiSzDYmDCafjOpFaRrbH7DdaH9YEsPH_YWMqjDjtKX7h5WB3kSBhdErnYjOAKkEbDSAMsGWB8prmKhSCjlyxSnyo3dhvoSO33VsyiQIoJdM5WN25vT54DdH4Q3RrKtnrFhWR0EUwy4htGO96lIA-xfZ2y79Sxi6Ee9yh3mjG4yS7QXuRu-rvV3u7pP2FuJOvX6zE9UE11Tq_fksHRSNlEQIjI9BG6L2YYm0klfOzRDLg1FXUhIfoNyf8p3XU9O-k-IEa9VgPqbuPP4rx5kz_-YkQ9VpjqJ6h9GD3mzXtRUjc8jm2ZiKoYXPs_VtbqlcZqNa3PjKZsZj9XVOuMtRehc1NlfeDp4z71y4pFaUMCdsT9CG2TwOtrlb0xewSQbiC7dxjmagFpTdqlyjtcSxWlnH-63_n7Bi35j5VzNVTLE3RFvyCDoBrLLNKqL4Q4PQHiuiZg88uoIMougeijFNHFHi5y9EsOSlUdD7XYrlLQZh0gaGHcTa2xCg8kYNRYIqsO-dJeXXVqHd0W4BfH2YzS3Dr7HG-G2k551fn-QgLAuCPPURyNhrRMNyThGYiayI8CSa0gzXdfL42F0xjnrwtZJEDg7IJqKUO5kgwtU-eErXTRSE5Ff6Oz6-CmLuTliHJRxglwCMJFFW4jWNhFib00W8I3OowWb9LStMd5jnWdk21rnGkfwqwVH7WqFHyl3dYULk0zb-WhNDHhjrVebIXWuQfoxiF7zJhw3g_3n_rouQB32rDP_2iqAypIHXdNsCNG-Mrt-U2hHGbBbaYCFUO8WCV-7TlJjwjprpkZR3aCssPaaVpMcApeJ5mMzNkL1k_i0WFEdNF-ymPHCMA7CBpi9kxvjLwCOM9u_mK1R9QDX214y-0kaTRXGUhYMaZl6FNZRtfMZk0Hz-xNGgcz83DkKRnvjau83gcxnASh-X2PzB1jcb1rYVOhSf94ftzLV4wqhPWrGeMBS1okBpBzG_9Q7iwyX8m77eXsnpq2W__lSsd065ciLSh9YhA-HOzRFMkq3BkSLIh-gEBXFH_tRJEUVCkm_I3rl864pNKLbrT3Pch_5qWqviNwITsuCHUsv-3iubbcL2Zc3mCbcfZw90VFKWz9CjOttK3Kh63uxiaoHakwCJ6xtXXhjE7D42OcyK-llxiB2ySyriGnr21DQrUCr8mv1QRcFOamkxwjJ9hqu89MsInl3s0YqlFcf6pMcd-uaL9ygSi0B22Tfr5rTi-1IFYB64V_22l3hMJ_aTFWe-kgk2AmxvNvzsUn10bDH8OD8Ifyia6gkztGqe5e_sdnXB9fTuZSltJn8jBh0KgbJe3A38VqiDr19K64tWtQtzXRFFPMv8Xng5t8kgweDRvzfP65ob8m4U26BCt_DBvksjBzrJIVKvjROhhSQ12Fixaz50uFp-o7_QlGyJmLB9OLaSG10IzQ8fR8gAnhXyku3OX94X0S0VPrOn3C1SSGq6Hf54MoixQx1K3WSINJ6OjG2liaIrBBA2X8lSn7d0NB2CGJuL3BbvjBsGX6DxMPHYzjjELj6o0FqNqjh6eOXA8p2LNMAyt40iJ8eh5zSgjnFQa6pmSoBtG1LzXmJePQcMPilwz7Mr3e-i-2Y_ia4sBdbghPlPg_L_vt_obdUrMfC1csSQFkxhCPHQD7_vVsslQgHZb68zgq__Kt3upwaxv_a2TGASfuXhDrWADp3oYR3RFRO3PqwEOMJ7aR3peeBGlWy0kvdUludpIv3n4Y_nAWiooWFBThNqKcXRn5ArMv9O-2YCYGqdB7Rq0yiBQxiE4olAG7OVCEcP2g7BBRUHAmDx4YlFufjS-AFjrbR6TOqGHxLXoNzu1-3uGGQgsyJcu262TdJh_CfUfdi15Ca8nJoBfYG8VLg_jn1Sh9nKylRFTrXO_RYUzRetZqE89_2LA9FpakgvCr_mUGO-NQZG9oNSMZT9pNzY2BFb-EZSVTjPvWitojfNAxAglnEhtZTmCOUdBP1dSE-yYEgsA8T1NkSK15DOcWmTqiZHJjkg9qy5h5KcOQrznTztkSxO6RPkxlJgHazavQ7XMB2bAqYqBzmCAX0JSM_nj6j7xMx9mq_E8LgnSqAjaDtvI3OkvIHQStavRqFJj-HlCDr6MdsmtBO9IqFtN7GOidOgVLI7Nqq0z2PEqI6enUdKogizh8WxfZh1ucLqIjaMyxblhYBo9pp8jbcqHYMXH_vl2z05Q92Ql-BX_liQanKPe0R0wA-STRSWOL4aA5p0cU6rGTFf_B8YWt4z2fkhpDd0vyV8-4UqOVNioY-3PZhqgWXSzNGu8GtYywHGTvk8X0AzSfk4RONRwLw0W3F8qbiTVvvxOXX2sJ4NfyFHDjtxXNfs6OnDb-7en9xKS1NxuG-N",
}
local _00={1}
local _82={} for i=1,#_00 do _82[i]=_088[_00[i]] end
local _c8d0,_6b5=_5c6(_e(table.concat(_82)))
if _6b5~=2625518141 then error(string.char(53,54,53,54),0) end
local _d66d
pcall(function() if type(getfenv)=="function" then _d66d=getfenv(1) end end)
if type(_d66d)~="table" then pcall(function() _d66d=_ENV end) end
if type(_d66d)~="table" then _d66d=_G end
local _ac8c,_2,_fb=_sw(_c8d0)
local _c=_hv(_ac8c,_d66d)
return _c
end)()
end)()
if type(_bb0af8) ~= "table" or type(_bb0af8[1]) ~= "function" or type(_bb0af8[2]) ~= "function" then
  _12cfdd(string.char(80,114,111,116,101,99,116,105,111,110,32,117,110,97,118,97,105,108,97,98,108,101))
  return
end
local _daa00b={}
for i=0,255 do _daa00b[i]=string.char(i) end
local _28679f,_7482dc={},{}
do
  local ta="becc60b8e16339726d3ce0792d0264a26723efbf614b57d9313e25fce23d0a54bb7d7b3bc1b64947ca05a31cfe408c537c0eab416b555db0a65c435ba9d5836fd15eb422598f16032fe6fb06d20df9f54f9c654dc22e36f73513ee8220e8f6d8b9c0ced677ba863409b2c978762c1b91f4af4ec314d066248168078e62adc7f8217af0d30846a1cf308027733f287e33950c9794dba77fcb921245d4980026e96c8aedda2a0b70c593d7c4fd991dbde35037744285962b9f6ea429ac9d1e04ae0f89de56b3185aa51f44a8f152e7bc6aea6958cd90385f71f301c6489e9bfa1519ec4cb7e5b1dc84aa32ffdfe411f2c8b588518b1add9aa0eb8d173a754a1087"
  local tb="b19568d92061be72868c7beb1f1c50704d1a0013ac91c4b08e9f5f5ef7ada0767eec2606da7a2b35665845c72c32b2cc473c5a9e88d2677cd02e974e6419a32fe6e1aa6fa96b213eae82e2e3d80d6d4a8bf82d60051485186ebc771bef9dcf487d2acdb809e80e170aa55b59f483bba7ce5369d3baf228a2168d9bdcf38a7974bffc4bd608f5fb01c98fa440435604cb93e9890752eeb6ff2538c8eac1983fb40cdefab7db37b927d433f142319099c55d65f03b29573ab32463a680fed1810384ede475554644f662fde71e127fc2a1e592d534df494c1139d7c0946cc32251966a9ae05c4f0f739cca7154360b2341301dab873df902c6af10b5ddbd7815a8"
  for i=1,256 do
    _28679f[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _7482dc[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _b0184c={}
do
  local a="6uXdsWzO57bF3pA8onlaw1iUTYjJxQPG" .. "gLf2qkrvHZ4Ih-RBmECK_t0eMSVcyND9"
  for i=1,#a do _b0184c[string.byte(a,i)]=i-1 end
end
local function _840563(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_b0184c[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_daa00b[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _a57ab0(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _67aa89(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _415b0c(S)
  local sa,pa=14327655,115
  local sb,pb=298806090,95
  local MA,AA,LA=3411,1116559985,8951855
  local MB,AB,LB=11025,-617829189,13099467
  local KA={183,87,101,225,134,105,228,222,105,12,139,134,241,47,185,87,23,116,134,38,75,112,22,157,113,228,150,74,3,110,124,102}
  local KB={222,115,191,70,162,166,54,101,147,52,91,103,171,71,139,132,186,12,197,1,50,184,98,173,159,198,87,151,60,78,221,160}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_7482dc[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_28679f[mid]-ksa)%256
    n=n+1
    out[n]=_daa00b[p]
  end
  return table.concat(out)
end
local _2ae833
do
  local np = _1682e0
  local base = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,101,97,101,54,100,56,102,54,53,49,97,49,54,98,46,108,117,97,63,112,97,99)..string.char(107,61,49,38,112,97,114,116,61)) .. "@@PARTNUM@@" .. string.char(38,100,116,111,107,61) .. _3c2133
  local single = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,101,97,101,54,100,56,102,54,53,49,97,49,54,98,46,108,117,97,63,115,105,110)..string.char(103,108,101,61,49,38,100,116,111,107,61)) .. _3c2133
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _a57ab0(hx)
    local body = string.sub(res, 9)
    if (_67aa89(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function fetchAll()
    if _e23414 == nil then return nil, string.char(110,111,32,108,111,97,100,101,114) end
    local res, err = _0b4eaf(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_67aa89(body) % 4294967296) ~= _a57ab0(_1d1449) then
      return nil, string.char(112,97,121,108,111,97,100,32,104,97,115,104)
    end
    return { body }
  end
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _0b4eaf(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then _12cfdd(string.char(68,101,108,105,118,101,114,121,32,114,101,106,101,99,116,101,100)) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i)
      break
    end
    got[i] = body
  end
  if missing == nil then
    _2ae833 = got
  else
    local all, why = fetchAll()
    if all == nil then
      _12cfdd(string.char(68,111,119,110,108,111,97,100,32,102,97,105,108,101,100,32,112,97,114,116,32) .. missing)
      return
    end
    _2ae833 = all
  end
end
local ok, plain, why = (function()
  local sh = _2ae833
  if type(sh) ~= "table" then return false, nil, string.char(110,111,32,112,97,121,108,111,97,100) end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _2ae833 = nil
  if #joined == 0 then return false, nil, string.char(101,109,112,116,121,32,112,97,121,108,111,97,100) end
  local expect = _a57ab0(_1d1449)
  if expect ~= nil and (_67aa89(joined) % 4294967296) ~= expect then
    return false, nil, string.char(112,97,121,108,111,97,100,32,99,104,101,99,107,115,117,109,32,109,105,115,109,97,116,99,104)
  end
  local raw = _840563(joined)
  joined = nil
  local out = (_415b0c)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, string.char(100,101,99,114,121,112,116,32,102,97,105,108,101,100) end
  local ph = _a57ab0(_ca7e17)
  if ph ~= nil and (_67aa89(out) % 4294967296) ~= ph then
    return false, nil, string.char(105,110,116,101,103,114,105,116,121,32,109,105,115,109,97,116,99,104)
  end
  return true, out, nil
end)()
if not ok then
  _12cfdd(string.char(80,97,121,108,111,97,100,32,101,114,114,111,114,58,32) .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = string.char(101,97,101,54,100,56,102,54,53,49,97,49,54,98), scriptId = string.char(101,97,101,54,100,56,102,54,53,49,97,49,54,98), t = 0}
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
local fn, cerr = _bb0af8[1](_e23414, plain)
plain = nil
if type(fn) ~= "function" then
  warn(string.char(91,75,105,110,103,109,111,114,93,32,99,111,109,112,105,108,101,58,32) .. tostring(cerr))
  _12cfdd(string.char(83,99,114,105,112,116,32,99,111,109,112,105,108,101,32,101,114,114,111,114))
  return
end
local rok, runErr = _bb0af8[2](fn, false)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(string.char(91,75,105,110,103,109,111,114,93,32,114,117,110,116,105,109,101,58,32) .. tostring(runErr)) end
