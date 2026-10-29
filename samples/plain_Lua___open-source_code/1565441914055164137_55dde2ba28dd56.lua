local _14bbec
local function _dad32b(msg)
  warn(string.char(91,75,105,110,103,109,111,114,93,32) .. tostring(msg))
  return false
end
local _7377e6=(function()
return (function()
local _be55={}
for _fyl=0,255 do _be55[_fyl]=string.char(_fyl) end
local _9ff={}
do
  local _r59="eSVrC9W6Qhs7GDA8u4fmPEl-kpzK3YcdFOItwJgq1vBaRU_i2xTobHyMXn5L0jZN"
  for _fyl=1,#_r59 do _9ff[string.byte(_r59,_fyl)]=_fyl-1 end
end
local function _4e(s)
  local _feg,_zc4,_n68,_zyg={},0,0,0
  for _fyl=1,#s do
    local _hj0=_9ff[string.byte(s,_fyl)]
    if _hj0 then
      _n68=_n68*64+_hj0
      _zyg=_zyg+6
      if _zyg>=8 then
        _zyg=_zyg-8
        local _67t=2^_zyg
        _zc4=_zc4+1
        _feg[_zc4]=_be55[math.floor(_n68/_67t)%256]
        _n68=_n68%_67t
      end
    end
  end
  return table.concat(_feg)
end
local _0525={}
do
  local _o1w="\244\011\023,\214\161\159\217'\246N\164\188kU\002\156\199 \220\128\163wm\177\019\218$\221\169\190she%?D\208\129+\194\176\234qQ\143&\253\149]\184X5g8\166\167O\025\192\142\n\000\180i1\165\028\005<\205-\237\235\154\132#\162\016c\174\245\182\213\178\207\146\"L\131\185\240\020\021\187\222\252\216\211\230\147P\024\236\145\206)\212\152\138\140\2490\rB\231\1483v_\135\191\255\153\241\029F\144\183\136Y\009=t`\238\254\017\215\196\202Z\141{l\224~/^\195\225\248\027\008;(\181\201\175\014\243\160}:r\200\170d4\130\239\171\227\172\139\018\155u\223\134\228>\026fW\197o\012\004\251!\158\233RJb\006Gp\186\003\030\168H\150C\247z\0012T\189\133\\\204*\127S\179[7\2106n\193\173\198@.\151\226|\157MKxj\250\015VE\219\137\031ayA\209\0079\232I\022\242\229\203"
  for _fyl=1,256 do _0525[string.byte(_o1w,_fyl)]=_fyl-1 end
end
local function _142(S)
  local _gk1,_muu=2831722247,214
  local _feg,_zc4,_mhs={},0,0
  local P=291253 A=-32328845 L=12402173
  local K={117,138,105,24,71,185,240,247,23,67,242,220,40,55,212,234,207,237,187,218,14,126,218,13,118,147,11,161,230,191,213,160}
  for _fyl=1,#S do
    _gk1=(P*_gk1+A)%4294967296
    local _134=string.byte(S,_fyl)
    local _o60=(_gk1%256+K[((_fyl-1)%32)+1]+((_fyl*113+L)%256)+_muu)%256
    _muu=_134
    local _hxd=(_0525[_134]-_o60)%256
    _mhs=(_mhs*33+_hxd)%4294967296
    _zc4=_zc4+1
    _feg[_zc4]=_be55[_hxd]
  end
  return table.concat(_feg),_mhs
end
local function _vo(_pw, _ay)
local _rr = table.unpack or unpack
local function _ct(...) return { n = select('#', ...), ... } end
local _nu
_nu = function(_xq, _id, _jx)
local f123sv, _vv, fzzs1 = _xq.f123sv, _xq.k, _xq.fzzs1
local _fa = {}
local _og = _xq.f34cze
for _mp = 1, _og do _fa[_mp] = _id[_mp] end
local _fw, _qx = {}, 0
if _xq.f6ohmr then
local _xf = _id.n or #_id
for _mp = _og + 1, _xf do _qx = _qx + 1; _fw[_qx] = _id[_mp] end
end
local _bz = _xq.f11nhq + 8
local _ma = 1
while true do
local _xb = f123sv[_ma]
local _ji = f123sv[_ma + 1]
if _xb == 12 then
_fa[_ji] = _fa[f123sv[_ma + 2]]
_ma = _ma + 4
elseif _xb == 15 then
_fa[_ji] = _vv[f123sv[_ma + 2]]
_ma = _ma + 4
elseif _xb == 39 then
_fa[_ji] = _ay[_vv[f123sv[_ma + 2]]]
_ma = _ma + 4
elseif _xb == 24 then
local _uj = f123sv[_ma + 2]
local _tt = _fa[_uj]
if _uj >= 256 then _tt = _vv[_uj - 256] end
local _fl = f123sv[_ma + 3]
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
_fa[_ji] = _tt[_fl]
_ma = _ma + 4
elseif _xb == 16 then
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
local _bo = _fa[_ji]
local n = (_uj == 0) and (_bz - _ji) or (_uj - 1)
if _fl == 2 then
if n == 0 then _fa[_ji] = _bo()
elseif n == 1 then _fa[_ji] = _bo(_fa[_ji + 1])
elseif n == 2 then _fa[_ji] = _bo(_fa[_ji + 1], _fa[_ji + 2])
elseif n == 3 then _fa[_ji] = _bo(_fa[_ji + 1], _fa[_ji + 2], _fa[_ji + 3])
else
local _tt = {}
for _mp = 1, n do _tt[_mp] = _fa[_ji + _mp] end
_fa[_ji] = _bo(_rr(_tt, 1, n))
end
elseif _fl == 1 then
if n == 0 then _bo()
elseif n == 1 then _bo(_fa[_ji + 1])
elseif n == 2 then _bo(_fa[_ji + 1], _fa[_ji + 2])
elseif n == 3 then _bo(_fa[_ji + 1], _fa[_ji + 2], _fa[_ji + 3])
else
local _tt = {}
for _mp = 1, n do _tt[_mp] = _fa[_ji + _mp] end
_bo(_rr(_tt, 1, n))
end
else
local _eg
if n == 0 then _eg = _ct(_bo())
elseif n == 1 then _eg = _ct(_bo(_fa[_ji + 1]))
elseif n == 2 then _eg = _ct(_bo(_fa[_ji + 1], _fa[_ji + 2]))
elseif n == 3 then _eg = _ct(_bo(_fa[_ji + 1], _fa[_ji + 2], _fa[_ji + 3]))
elseif n == 4 then _eg = _ct(_bo(_fa[_ji + 1], _fa[_ji + 2], _fa[_ji + 3], _fa[_ji + 4]))
else
local _tt = {}
for _mp = 1, n do _tt[_mp] = _fa[_ji + _mp] end
_eg = _ct(_bo(_rr(_tt, 1, n)))
end
if _fl == 0 then
local _aj = _eg.n
for _mp = 1, _aj do _fa[_ji + _mp - 1] = _eg[_mp] end
if _aj == 0 then _fa[_ji] = nil end
_bz = _ji + _aj - 1
else
local _ph = _fl - 1
for _mp = 1, _ph do _fa[_ji + _mp - 1] = _eg[_mp] end
end
end
_ma = _ma + 4
elseif _xb == 28 then
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
_fa[_ji] = _uj + _fl
_ma = _ma + 4
elseif _xb == 14 then
if _fa[_ji] then _ma = _ma + 4 else _ma = _ma + f123sv[_ma + 2] * 4 end
elseif _xb == 5 then
_ma = _ma + _ji * 4
elseif _xb == 9 then
local _tt = _fa[_ji]
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
_tt[_uj] = _fl
_ma = _ma + 4
elseif _xb == 35 then
_fa[_ji] = f123sv[_ma + 2]
_ma = _ma + 4
elseif _xb == 7 then
if _fa[_ji] then _ma = _ma + f123sv[_ma + 2] * 4 else _ma = _ma + 4 end
elseif _xb == 4 then
local _uj = f123sv[_ma + 2]
if _uj == 0 then
local n = _bz - _ji + 1
if n <= 0 then return end
local _tt = {}
for _mp = 1, n do _tt[_mp] = _fa[_ji + _mp - 1] end
return _rr(_tt, 1, n)
end
local n = _uj - 1
if n <= 0 then return end
local _tt = {}
for _mp = 1, n do _tt[_mp] = _fa[_ji + _mp - 1] end
return _rr(_tt, 1, n)
elseif _xb == 43 then
local _uj = f123sv[_ma + 2]
for _mp = _ji, _ji + _uj - 1 do _fa[_mp] = nil end
_ma = _ma + 4
elseif _xb == 27 or _xb == 19 or _xb == 1 or _xb == 32 or _xb == 10 or _xb == 34 then
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
if _xb == 27 then _fa[_ji] = (_uj == _fl)
elseif _xb == 19 then _fa[_ji] = (_uj ~= _fl)
elseif _xb == 1 then _fa[_ji] = (_uj < _fl)
elseif _xb == 32 then _fa[_ji] = (_uj <= _fl)
elseif _xb == 10 then _fa[_ji] = (_uj > _fl)
else _fa[_ji] = (_uj >= _fl) end
_ma = _ma + 4
elseif _xb == 26 or _xb == 38 or _xb == 6 or _xb == 22 or _xb == 23 then
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
if _xb == 26 then _fa[_ji] = _uj - _fl
elseif _xb == 38 then _fa[_ji] = _uj * _fl
elseif _xb == 6 then _fa[_ji] = _uj / _fl
elseif _xb == 22 then _fa[_ji] = _uj % _fl
else _fa[_ji] = _uj ^ _fl end
_ma = _ma + 4
elseif _xb == 21 then
_fa[_ji] = (f123sv[_ma + 2] ~= 0)
_ma = _ma + 4
elseif _xb == 2 then
_fa[_ji] = {}
_ma = _ma + 4
elseif _xb == 25 then
local _tt = _fa[_ji]
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
if _uj == 0 then _uj = _bz - _ji end
local _te = _fl - 1
for _mp = 1, _uj do _tt[_te + _mp] = _fa[_ji + _mp] end
_ma = _ma + 4
elseif _xb == 18 then
local _uj = _fa[f123sv[_ma + 2]]
local _fl = f123sv[_ma + 3]
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
_fa[_ji] = _uj[_fl]
_fa[_ji + 1] = _uj
_ma = _ma + 4
elseif _xb == 17 then
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
local _is = _fa[_uj]
for _mp = _uj + 1, _fl do _is = _is .. _fa[_mp] end
_fa[_ji] = _is
_ma = _ma + 4
elseif _xb == 33 then
local _dq = fzzs1[f123sv[_ma + 2]]
local f81vtr = {}
local _hn = _dq.f81vtr
for _mp = 1, #_hn do
local _so = _hn[_mp]
if _so.fuqpw then f81vtr[_mp] = _fa[_so.f4bnf1] else f81vtr[_mp] = _jx[_so.f4bnf1] end
end
_fa[_ji] = function(...) return _nu(_dq, _ct(...), f81vtr) end
_ma = _ma + 4
elseif _xb == 13 then
local _uj = f123sv[_ma + 2]
if _uj == 0 then
for _mp = 1, _qx do _fa[_ji + _mp - 1] = _fw[_mp] end
_bz = _ji + _qx - 1
else
local n = _uj - 1
for _mp = 1, n do _fa[_ji + _mp - 1] = _fw[_mp] end
end
_ma = _ma + 4
elseif _xb == 42 then
_fa[_ji] = _jx[f123sv[_ma + 2]][1]
_ma = _ma + 4
elseif _xb == 30 then
_jx[_ji][1] = _fa[f123sv[_ma + 2]]
_ma = _ma + 4
elseif _xb == 36 then
_fa[_ji] = {}
_ma = _ma + 4
elseif _xb == 20 then
_fa[_ji] = _fa[f123sv[_ma + 2]][1]
_ma = _ma + 4
elseif _xb == 8 then
local _tt = _fa[_ji]
_tt[1] = _fa[f123sv[_ma + 2]]
_ma = _ma + 4
elseif _xb == 40 then
local _tt = _fa[_ji]
local n = f123sv[_ma + 3] - 1
local _mp = f123sv[_ma + 2]
while _mp <= _bz do n = n + 1; _tt[n] = _fa[_mp]; _mp = _mp + 1 end
_ma = _ma + 4
elseif _xb == 37 then
local _bo = _fa[_ji]
if type(_bo) ~= 'function' then
local _tt = getmetatable(_bo)
local _uj, _fl
if type(_tt) == 'table' then _uj = rawget(_tt, '__iter'); _fl = rawget(_tt, '__call') end
if _uj ~= nil then
_fa[_ji], _fa[_ji + 1], _fa[_ji + 2] = _uj(_bo)
elseif type(_bo) == 'table' and (_tt == nil or (type(_tt) == 'table' and _fl == nil)) then
_fa[_ji], _fa[_ji + 1], _fa[_ji + 2] = next, _bo, nil
end
end
_ma = _ma + 4
elseif _xb == 31 then
_ay[_vv[_ji]] = _fa[f123sv[_ma + 2]]
_ma = _ma + 4
elseif _xb == 3 then
local _uj = f123sv[_ma + 2]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
_fa[_ji] = -_uj
_ma = _ma + 4
elseif _xb == 29 then
local _uj = f123sv[_ma + 2]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
_fa[_ji] = not _uj
_ma = _ma + 4
elseif _xb == 41 then
local _uj = f123sv[_ma + 2]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
_fa[_ji] = #_uj
_ma = _ma + 4
elseif _xb == 11 then
local _uj, _fl = f123sv[_ma + 2], f123sv[_ma + 3]
if _uj >= 256 then _uj = _vv[_uj - 256] else _uj = _fa[_uj] end
if _fl >= 256 then _fl = _vv[_fl - 256] else _fl = _fa[_fl] end
_fa[_ji] = math.floor(_uj / _fl)
_ma = _ma + 4
else
error(('E'..tostring(_xb)), 0)
end
end
end
return _nu(_pw, { n = 0 }, {})
end
local function _gq(_is, _yr, _lz)
_yr = _yr or 1
local function KMVX8(_ji,_fl)
_ji=_ji%256 _fl=_fl%256
local r,_xq=0,1
for _=1,8 do
local _ev,w=_ji%2,_fl%2
if _ev~=w then r=r+_xq end
_ji=(_ji-_ev)/2 _fl=(_fl-w)/2 _xq=_xq*2
end
return r
end
_lz = _lz or 40439
local function _ov()
local _uj = string.byte(_is, _yr)
_yr = _yr + 1
_lz = (_lz * 2472 + 25082) % 65521
local _vv = _lz % 256
local v = _uj - _vv
if v < 0 then v = v + 256 end
return v
end
local function _zw()
local n, _wa = 0, 1
while true do
local _uj = _ov()
n = n + (_uj % 128) * _wa
if _uj < 128 then break end
_wa = _wa * 128
end
return n
end
local function _ky()
local n = _zw()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _vz()
local _xq = {}
_xq.f34cze = _zw()
_xq.f6ohmr = (_ov() == 1)
_xq.f11nhq = _zw()
local _zh = _zw()
_xq.f81vtr = {}
for _mp = 1, _zh do
local fuqpw = (_ov() == 1)
_xq.f81vtr[_mp] = { fuqpw = fuqpw, f4bnf1 = _zw() }
end
local _sd = _zw()
_xq.k = {}
for _mp = 1, _sd do
local _nb = _ov()
if _nb == 0 then _xq.k[_mp] = nil
elseif _nb == 1 then _xq.k[_mp] = false
elseif _nb == 2 then _xq.k[_mp] = true
elseif _nb == 5 then
_xq.k[_mp] = _ky()
elseif _nb == 3 or _nb == 4 then
local _lk = _zw()
local _cp = {}
local m = 72
for j = 1, _lk do
_cp[j] = string.char(KMVX8(_ov(), m))
m = (m * 95 + 183) % 256
end
if _nb == 3 then _xq.k[_mp] = tonumber(table.concat(_cp)) else _xq.k[_mp] = table.concat(_cp) end
else
_xq.k[_mp] = nil
end
end
local _hc = _zw()
local _vk, _kj = _zw(), _zw()
_xq.f123sv = {}
if _hc > 0 then
local _gm = {}
for _mp = 1, _hc do
_gm[_mp * 4 - 3] = _zw()
_gm[_mp * 4 - 2] = _ky()
_gm[_mp * 4 - 1] = _ky()
_gm[_mp * 4] = _ky()
end
local _gx = {}
for _mp = 0, _hc - 1 do _gx[((_mp * _vk) + _kj) % _hc] = _mp end
for _mp = 1, _hc do
local _nq = _gx[_mp - 1] + 1
local q = _mp * 4
local _so = _nq * 4
_xq.f123sv[_so - 3] = _gm[q - 3]
_xq.f123sv[_so - 2] = _gm[q - 2]
_xq.f123sv[_so - 1] = _gm[q - 1]
_xq.f123sv[_so] = _gm[q]
end
end
local _ce = _zw()
_xq.fzzs1 = {}
for _mp = 1, _ce do _xq.fzzs1[_mp] = _vz() end
return _xq
end
local _dq = _vz()
return _dq, _yr, _lz
end
local _74c={
("Y1CqnU4LEQPYFrs2RBRzTWykEBW40MlSkus-drAbglbHSAJ7vh1_T21bY2dp6_FOVxuwDRp-yVTLiUJ5yaljdc1SH3IcXXHytZgKxfB1WNNFPk_nR0dEcKNfgn8LOQ_tHcANy1-e0K08klxFNDNWXAXGJdzdWa27DKI8qAcZkoixB1E-03aTyv8Pa-8xObmRWzqGVAc5nOwXAnBjeC4-jL__OqBIrl1nSD-sAa3hYI1AsnnBQJszzciORnPJIWbVuHDVkLeK4iTlrNvSVpGKyHhCL6z1XmKj5Sbi9esJXohFD1YAPZuDGGQCFAS2uqDgZrqZJFy8pUu_lMmbw03AvINvTg4fz7hv00RWvMP6ikFdEtQx7VuvCO0aSTSg5CW30ELFY9y7L9OOSpKrE29Y3i7DnNBNjO6GjRlyMMB3KyyGv-hsT1ZhvnC9XEh2OfB44chyKPnzQY8iNoO77b_y6G5xoQm1lN9rLjVTN8ypeuahM42CrQbuRmhfmCsgQ2Rq0_dpgxawdCfLiL1CnuwELB2wZKpxdplOnShw5Dm05mJ-eNQ8I9TYovS9YpT2OWRQijeSUSDrw7QGqtZokI8X73pfJMZKOpC7LEKwQVQ_UXAZJb7iouWNvoEzYYBvnjw0bOxcW8svon-KuVbBXnb9iCoYfZg3PlkmflpNDy0d3o47AIptFgqUmot37wtHO5lktLF5Z2t_TX4hdY-0upqtKnLo6lDGX6PAdFqboNhScNeL3PSNnm5caU0Sg2TYfIpQw6bwg7fzfbm-QYQtEG40_nyTTCAtyTXTduPdApd7gOQEjAIVGpfkVCyVbxx9sguOWjr-SFiTExV9YsUA_YuFPsgXloe2ttQj01CA_bdLEeBuwUqS3CtAK-xRi6u_gxGBW0ootH9nPMf7guWDiz2UgmbavpLWfbHHw7ror7JWl_I0al578R3VHNQPyyh2TWnC59Ksunxym81WI-BuI-GOlqpkyHdSME_xfmJCYrsuY9QnzKTfunWYTf_Kjg6-c2eYO1UcLkU2WRT8VtisMDwVFPUHf9-7o9EyoTuJXVkXG9eBlw92NWxU-I1b1wni2EevhfnXNG_UngvBN-XhsXIWrV1tb0buzK9VEZuhP33cL0oWd1DFNPYB_2LroFzuA8byOXqwDl6Qo30RjjPyw80lWktBpcVgijoT4IRhxIGhWlJPg3GXfwzCT3Iz8fulw3v92uwdLDGM72TydBt9GrqQbFaQg1P5cfGa4ft2MBViRQIHCzYI7PNhe5hxKy0dGsYp8q6N9b80XU9frAI-UGOiJIo7ukhCrFXt1HzNdjNpON7sjMbU-iveR3aY-INnEYSy36yj1e2n_7dgLcBuxoazJ4L8W72QESMKppiciz37vaMcU7IRl1b9oXLIjQk9D4umZHLrTZqqlBnbOX1n7uTffFvzoRNMrZkEd9OLw-3qM_3NiFjxcCzNhEvFTc0S1olrn6xyA0v1DVRskoa0ntUwnEpy4ZAANwSJS7_ieNJwio_13vDZpS1rij93LxGSU4uw-RPKaxPTt0nOWLwNDY_jAVxIfHOoWtYjSQmqxct_0fDJQSTfUyNAC3uz1cJ1-FSnkwpf9i0RP54K4sQxgIo4-6BWo49NpWH4NjeSdMdHdrgXwL-Ch2S2p-qOcuQRaorOCXW9gyaDNS_edUK-jsenhpnA4yFpCfEjR6iVigpzeQ-IV18aMyMS0yHXZyJqdQSHVsrbKc3QryBMSczFLq3R8W6c-08ZziCfvSRUPxjy2c_lTqIX1lpfB5nx7YCKzaJpskAbY7VHWn7rjxhlpMUvOThLuJR4j4Jk3IN8aSNRPcnRgSep61_6gn6BqCvsDH8F3mhxDveovAqVqPTXahLHWtsUiqlOtXmAllxNqgjdked0eEcwd4yYo9w1HNsP_yakZDF2Gl4vPAc86LaRtg3N0-izxroPmnhCNhA_fHsaYKcBJeiIXN3JwpiPfUtHXVqNGQ8oKEsWKGB1VNCHQ-42J5d2wwPKPL9IHCffXn2boR3BY3LcoFICZMKx6yeDd_m0LYywq3wTQos1g7Q-SoN8tzNWa7XDH8I3x6sxyHtCMNmyLMOOaS_b7gWlHaHJR4Um99AnN2_l0RB0I7IBHQ6Ij8FnPnt-nSmu4TYmPI6ZzDLBVdtDZx6zy6Ti5pH5OEsOd0nFAvskPbihZeM_73UtCasALn19Cn2Rx4pb10eeIbO4gTgXHLD_sieUMEBDmI9x_gBiuSL1nE8W48zzCn1XhUF-o8-A8EKEKG6-PFDLDK9NuB2cSQkmN5J_7q_Ni4G9cqJX39cdrk2jVHhQRaLNb7bxFlG9okmRP-ECOwQ-Cz_ZaiYLscv8XsZ-PNtrD727KuuE8fudb6jGWYKeIGzni4qYXusnMtn9zVw_Dpfrvo6YlQzu6Y6gqypQzGdTAJoSI-lGiSCYpVd1YsbEbc67GqO5RUxd3kkhRL_zYdWgSeke1b1tNABRRlw3Ii0I_8mpFs_G2jFyrZXgvGnhd4dvMGB1awRB-vsc8Ck3vMiHnw0nPk6WTX54n4MxapdU7XFJLE6z74RNJ-00E3Sfpk1n42wRIwpuhYPxAPBjIPz-lLpqjfaKDdMVYJ80T07d1xEoc5OZCmuKvHf6eftkATaIUj2D-PwgMeEEhbV5pofqwEqo2HeS2aug5evoS9bzTORWxVIgK4F-LkTOuCraN2efXtAtIeMRmfNRdVkuuG72TenZb4UkpXeJ6EzSbcVE8n5-1ArL2dDZuXlSUfgpt7Q4uHftZ4z5bNqsGo20HlKx5MskcXgC2kZfepQ2_pq7EkctDFfsMFIToKAGWVxup1xYVq3-vpqUQ7ViwDayys-ZJ_5b-hf7h1_YLkSh0uhTITsOLU77HeFXpW-8mDvH3dAHyt_G5Uo8TMYVKZ-u1W14Iy6j24O1eLAYscNWRrHBRhjYwKkf0CWrBZ36cykuredtCo6LoY6i1qjaLW13SgDbsfgFz9_Kb2SyIUjUkCGY4zdhUvK7TLFQrrnA54PMPREW6ueVUL7IRMUVwXOPnwAIaedZnIj7Ofig_TnlO4qv755reb0SaHKfLtCKoHgWc9Y8IleYF8AkKnZqqa7XwtAl90y4S8HfIoX0uLQYhvI4S9gel8IGDBjKa5zyZrFwb1oQ1SEowUF6oLmWOLSaXFgYnZBmSW8-xORFwK5ubvG_xam29zNPtP7OXQncvt6dXN4wHvqfmzbmTgHdF_HTJTmmOVzuBVg8HvgjnrzUjvOwgCOX7vDvOfKgG-Wd542AvynpbFAbiXnj1zjsrnoO3PuWtwCG6pJbqel82OLBIlE2OuLsBMRTGcAHbZRJ50KddSs-htk".."MxkJsj2ueziyA7ewgvlzy2YBV1pAIDaLLFgin8MNQOyTdGMjSm1cCRDzZfo8lwG2rH47v6WA1Z1Lvvi9B5whaJKqz5I_uVNU8vGqUgdKAF0ly-tEkpWBTKwQrVMkzZGSD02JYLSJQhDCTQ49YLhoi0FX-K5weOoAWzbIsiIJlzP7lfHo1sM3aVym9vf3A7g7A9hQbNkGxhCJNjvmUDfEoAzSuCf7dXRMif_7KSo80qC6MTGguTERSTQFz9acrouy4m4lhaIJWoKBqTbj_uvyL0KomjJARhnsrZIK8-glRlQpT4qJC66zj8fuO91qA2QbMursavgLKLsIsvZe71zkn5Dhq8gypd38xqMwppZ0imrGYbPXxOZJeEg1U3PSyr-ubYUkmqr3KYN2f_PCdgJRlS4rWm7uU0_t3MXytq3pS1MLbwDBcjy3iTLFDSxjwm9WnQGTO63kiFNMUvyAc3IeYJGzopwsWPwzlgYWgSHjK4HTzkfm6Mgbkz8B3qXy0QURKqa__ja2hkfLG57gV7UvmMhsGNY2ibTvpcl0dCvVmQFMPTHlAW96lX7UsbZGzOHHXRvq7zYXCrTJFO8uGBqOYti9okXi3Rh8-g1CHyxjJ0z3KEJnmhlqeksEt25Vem7gEuQTsV6nN9xUkjcHVnU6bF3eElpHQhA5isbo0Fx5_jBNBGRl1hXrjCdI_l49yz-DWdy9modp8tyb3HcKDfUPcTe19UhS6mGwYEEu75YJyo1BdML3DqxKTxkCWwb2BQ5YSZEJKt5Fh3zK1QBJKC98m4zU8pQVqfqjY20ah0OsfZxKqhuqSgCN_oxxUSIiRtY20jDMmj1CL9wrpYierk_v10kzkzKdR3j5sHSfZtOeqNjOVRKU653fdz4HJHPrEOtGYwbeI9x2qDFBCxZiW-yUyhsM1A3E50Q9jE_aV-SR6MjYG3YPnDoq8FAlfoW171RGHla3WvQ5eTcBmJ6KumCi1udvj7L6VIpTaOJ3j9HXZN329RuB1y0zHZWWjuGHSX26topuKhyBrqbY28rvI1-xiSKOlefXsiltCiPNIfjEDalPOYJZ61XcjvbV-S1nPht8lJ8Aenjz2IzmwFQYLzMdsahKBXYakSI80kUHfRbF1bxrfWtJ2ZfyYeCZJ-MY-5PpSfiKjJJn6RKnuY6xEiF__G1VIJUzJUta917E8hhsE-Q1ZWvOpf1Z2PoX_omDb1cARR37pAOyoGFRK0vvBX9AboAevWTHrbaL9yxm-I4ZVNgK2p0lIx67fVcjfs-CBYlw_57KWgzfjQs1sO6LRH6tjVdOKEeo_n4s9y4jieTgJsEmzNzouxuUThKqMOPh9p6wdNDRrNTlmF-sVQSRVMTnP3HVi4ELV3UeNwlWo6O3A5LvSzef7F3LJmTzl0shsE7gCx5pv7WfgZmuV-oijmOp-8zo43qruIWja_vwc8zKXPGcIzk-g_QaMgI8rC_M5E_eN9oK473eYrtyqLslSIG6ZK9IrUp0x06gbqwK6GEvIGhdVwGI09JQXcdDTssS4ttxRItFqUeMxvkrp2QEIM5zajtNQowiv1Y0siftSub33ckPEgN99buCCPUnxa3Mz1zpOe4Um8eq_1CYaBbWB1bFg52IygfZ4nZ_GdN2xheVFLLQuJZF9DuQ2rhOEXSeLon_hCVUivMQ4PlBQq0MykcXbowXrxf1_vLPyIY3bcVyT8AyvxiFPv7sSihSxO1eJNIuG5K6vqi_rDd7_jNfuqjitMZfOhwd7j9iFVDfIufITdK825gbtcdC5vnYXNJhxlDdtAQv9-5W3LXmdbud_LYNLLVS3Ka90KsSyQfqmDmOTtgidhm-AGnn8mWSgzUcA1HISSzMWuQvc5KXmhOuSangRhIJcMrKpUU3O9RWjWkWk0to0voS3SHPBKqn-gFF15doqvlxWIqt72bxTebYWCb6tOy5UtEciTW4VWerbmxwU58G0EtrWj6xK7Wm_JzHkZ6Ai_rvM6e5qAIkY7CWpxdouZ9UvnWpIn2TxXrA0iqr1H_V9NCOcXqSE6lo9iM4tySARpfyoYSqDlV_rUVUsikFdRYUHcVcWQpRf8ZirU1NJeLSkhDrO3yqCYw-i2NzRo7wejLYWIOk5UEbZnJinD-um-AdZk0QQBABvTX7WM3kRAyRbl4uddaoutJaqXvdnmdkqpC9qAGBbdZYLzjkeNnbUzYPd6AGM1n9Xuap9o3u_ooPJQOH7jmNT0rL6mypmyGgVq6OyoztRs69NXS43vnv7K-Rvw4G88tbiuOkf_epzxU94fdNfNijd1QL2Av0MQeCESjJTRWrD0LXzPIdmg1OvUqd-CKewKJYsdEKDvVXgiiT0D60WLHIhGPYAVRIKLOMi6a64_pbEiTTSYr99y3MjTd-KWYJHmHQYWNXOsZLuw-enzTMxsn6APx61SW4w7o3OOjUeUa0mPrMiudXrdCf-j36exsAehc3wh9bVyXIhTHiqYVKTdr7RCnpXsH8F7B0Z6efOC28XYig2CmuHrGRbHEFttrR-s9GnoRZtdOXTEMSKb7rY8IckUc5OdoNwCIRWwA_SeVWnfsiVZPaFYFbWKlyG3W9GseWjvPzkUtRJNXitGgQvTPKtcEpTCNqrhSfzkZg63uLLzWrrIS8gkF3cWTiukjgsBFPfSQeMKEKfU_wluCc5OdbK75B1PtIYwgrolDKGbs5UUefH0DEYwVjcfhq2ACrmnstxiGZx17-0kWg0m1P1MQG6BRU4zSbHf39-IwUvbupDQYiKluSZUb1iLRto4_5hfMtce94d-iqY2Wibu2ELSdPgxtMLLzlSv46QPr0EriSvaCxfu1y_gNbKzsHard7RLsnB-DF_CGx8vieKvSB4XChp-OKnq0GWUFlI8Sm20553ZlDTy3GyS-LfWYDqDyLc2NWt5dgYFD0ky95SQsG3Rs_UbXKebJXUgOvwshSanX23BXHnyLh4JInCyNISP25e2S5NBYYTicnX1P-sGshkN5MYlqOl23K_yO2oiKGLQhLbQGjGcOODXNkEJTUOwH5DLzxk987oF2KCpOMKLnVvsHEkdEr9Vqik4NpKChvuy9MivvtrCwv89Yw7FZ8COk0_Ps_sxdI4pqEFzjcJpmiDIqnCb_BUS8w0_ELSNDkIDsGIcZXLxy3RCKCnofQDVXYS4B9IBJhp9CRhd1u2-K1YMO1q2ymvrNdVbSGFJ47492c51WwTvLF4b6POZfmkyG5S6tNEGWKaSn0N7xiSUgnTnLXZ1j-RGI7g9mXIwFfjbOyTZUt4KQIpiqX8QQdO5W4i0XLd2FnyW8ZHR4xSQFJzT6IGR4TzN3Ghhzx0lLETvYQRuk5qmUSOidi1AcDA9kE_WNkD4qRPohuUzOFFnQbPSWZEazaBmbuIMrFabs4EjHoTGaD_5Czkqeand4oKrFb_1J_g0krhxAn0k6Uqg4GkaaHKZjhXxPy_Xp0T8lhbQvkZ5d7Miw_FNCTOox8m0YZYYVJomzhVq-Eu-_pcYWIFOfKD0tLWBITLlgb9R4AIrnFgQhYcBYMAJqqOKqf8CiLtG46BjDEVar8nYvhHOtREazCycLn4c2YtFvVip_YjjqKjEcqdWUFnwC69ay1gpQ8xBcEdY0dkTJr6Juy2gpgnCF"),
"I2nONMKvNxwzczNtQnh3UmslPt_3qsKwdyO30LCp-60jU6Vb8XXrmfsGzUSnBbWBa-o50qi_Qy9nywPWnkfbrkigabS3iefEm3PldsY3kMKUMPeN4bsi77OpYj-Ns6shVmGKNX2ZEk6T8s7bgdlPsxmOq_5MDGekL8mESNzZi1xVuYudb6WbsJTaA6ncT6uJuHrsrDLBOUhob4f0ze6G_O56ca0KK1tN-6uRhDro7g-UBjQVTwjyh5QJGP0xb1RCEcXV1B_7EJ1ij6Bcfk2tlgfRVuOBlh6MZqtnkskb3Cpmdv1vu4DRIrfzaHbfTbcXJqT7yxv-ta-dSEGMFLG1D_Yunh3S4Fgwqaw5bqyjw8fWg1lqVRSwTbgXGhkPVO8CQqCoQ3T3YpZaBHE5UJbOgzcNxaaNtUwSC4NMP3zcI2f-ZeSEdisuw_qmwCTTTSTrm88XvpgiDlYXmujbTmrCu5nBHKjjG4GFgh6n25n7DC1hjsaf7z9scGyD5LLR2wi7G327CKF13-_J4_yjagPciwlB8HzreQ9TM9Cj6PPgQ0y9J2HqSs69kKdRoLfRr3OJgqydUG4mNNWMNSauuhHNDJ8qrjSHnFZ414GJdVGdxXfU-IZhI8MRZKViX07eAoGMYx5FinnCh1jVXyuLgBQJoJxYH_BRoDCHWGb0eNYYPuU8myc9M5bbk7qwiknZsxlQseURAy3imYQrnrC2psfzQBRJo5U6G5lkaJ9d0ytn3t-_r-iaCTx-7n8-uVxKIoNqkSbPC0UmnJVHXGUNg1rzwMK_mnawCZZn06rBH4U3iDDF9sCjnzzufTRhd3X5FRfnj1eCCN7t7UDARthNeGofZFu-1eJ2qXNO999ReiRjEvI25WZzy3RrZH62oo8S-sZ6uZczAYwir15jpyVmp_DtWipg2W5iScS3dHmaHgkPXrj8Ui4TH5ao7xfTRby_cMbEia3EhWQtwrIu9y3py2U_-N0BTx7Ra5Lylses17Z_CdX7poVD4VnV0NrsmqvobeZ6sZmVyY2E7SjXIGwJ1foKoz5PUjZSL0qOTQxDR1-JQBort6b5ExEKVc6nvOt8LtjsV5gMrCxioz0LlaeyhZYu24ELcZFFG7y_fWDXFqJF2eTkyNlpjhbSg7xX76w3OIdqY5xXyo8VkcLos2wJjcY8LB5XoGHQGeKz1ugIX0MwDdMAlcMqw0cLmtfkxk7tb0nh_kxVmB56B76llFbRFfd0dL2zJzg0emCsckOeWYXGOd70k61lzTpGDcKYxg93rbB_UU6W_MFoIn34WbALwDFQryTWu_MY0ovjfYx_wEzhYEnI1-2EkM7bZs4ylTfQa3k3omG3Wx63Uo31dttuIA7LViKuMijTxfO8AShXNkIC6lHfmC_gAdvBc-puVbog7DiHKhpUtYMwD_J9zBhZyBJj-3KOU0mxn8WdQpP_83ELCKd5CUfkz-SW2f8bT8mA-ixJmG9nk1n8ZhcXCPEmF527wNBVeXtRi21uiF1rSsUXSY4gLjEIGSULQgEXdWuZYPMm2eEisrl2qkhxREFwzfjp8CirYnspRilmtLjtn2yykADkdOIdquBP-_IE01ad_wrdBCxC3BS8cMkycmxY0Qn_bUQqtZ_AOY0AQat2hwojg-FlTGaa-_ub5CfQvcMVkq5_edffucj3QLmyaGwGEBbq-UIma0OhzhlzZq8U-dlNmUbf_KYeZHbkpiMnB2OWn9AXhbVxskt_UDJauooOd_Vuf_aD_ENS4R-QZt_tCcSjrCIorR5-EIA5TyLWiOA_T0m5DEY_Eeu-CmtbC3WtsQ4FVzel6iiBVTfy7f6GWU5s38k7QqIEB3JuTYeHbnCfZYL3FWxco8rRzDjmQLTxd-c6J9-DXvvL5WMB8W_tKaO3c9EQARgIOjFy430MgccUBOq7LOuWsX2qlW1V_c2DEqqIuwh-2lMLXLgxbN0H6uk1l5zUg6D0dSFwNCx5KUDud6tCaLt9npojFEaNrHC6V2xXd8aAEd5THygQWGll_fEH-Kx_IL6zRb8RlDQEoVc3E1T-fVROla0k_gCuQ8NbLLDAx0gGw4ODjjQkG-zTAvFDjT23tWgd3TZAo_ad228JSnkKILhF_heoBf7kosy8BtqPzFETSeQW8VJ8KhMqBmpwHEblM6MLgsqvcSACipYcDlUAqb0TrK7nD8doY1zjefbCX6GWtSwgLBSx08qvObfyK90iMt0Ryv3UDz2_EeQeX7p65vHLlMydsSlzXtbrq5nc0ogat12cQJwjzV3ulaHaQJ9Q1uEq1mQy8Mpmm4erc57rdRDtMqSzIOKoMBZjnyO0qR2HGpvBlKBK5as9dWO6LUCsiQ1m7k7tFwWOoVRImjg4tAknc3acX4BIoV-Ku6c98hr1oqiM6JBDJOv52l7n67eXQoUJVrUKUyjXbquVOw-ue5ADXdyppUrgw9xR5bzGL-qlek6qnM3aJSmd6RF39AMrKoV-4O9mO5GO5egLthtoxOMTmsSgSxtnJ2OlacFx2TkjMz4hwEqcfe4Oxwrrm3YS-HkehALMEStQqfvo8QZBnz54xBKW9djDfugSJtEmuxD5JIPw2g3l7-cVw-LWpUuDLA_SW1A6POAq4phuoBHIt0V33Z61J55hg6E336nIur1bcuto9hfB3hHin-Y7tRkJr2uHTc6ZWvsAl0U4R8rfw37IAJKWPWzZmbHFRqOyyztt2ZwQqQ8Ut1CqUNZmi1czWZedBLdDJ0xrg50ADyb1ocwDmhbPdunw_vwnnsBo-sLeJ8W0PKPEAI2HaU6nc7JuAL8PCZfWguVwiI0Ud6fyR49iMqRsEUNWskrghsAn6aKo1-w4TBM9ayG4SMHD8pfS6Z_9wFNaDaniLTVdt1a6lJ4onm2RAReDqMDEx7cJrLieaeyAS2lMLzmnwy5lFIZFoftllwn_DzD-Z2YlgfTSjlssEOY7S_yp2zL5I8_q6KCbnUko-bri7ZEFb0NQKs60vObGGlbdGUB_04GuHcldbSJqWxWDloRDL11bq9YqZmJQlrAhtGCrG-QNdZd6FUe1w6u4HmPRKbTV8u9MhTNoVj-eL8Y2APFaXv-iJDqBBkLgcTzi6YBBqvzSZZqGYz07OmOt7jT2I8MNeLDKQlrVy8YxFmchQtrlNFBRjC-O3UrPOCefAGDLvmzelYGdE9GF8F836CO29qVx78Pj-PyGmIY2PQxlq8xH5p9GnyLAj8Rj0XvYVDUYFzhqvz4Z2WJdEwQh6sOqjUwmkioLB0B0o7PmDI6BibP2VL32ml2mlgctp9nApIOnfuvdYRyZCSDKwEl3Zmi7u5oEL0azXUuB_aE0KF0HI-DMGaF5JrQ59XAuqtFU47Fymw8rcNaeekgQ9t6egBcZVvOh9OvOFSHjig9rXVIL9X9RAou31L1_IyqZWBdTjMrBrde_YyomquaS4rU1ixR5HcxYuXhUbG6v0NQlK-XxBtmE__jFytZTAKPvafjSa3s4xJrUJ44-qUKOFOT_yQarOXpJ44DeMtvDjZz881IXP-_dk5EDsg-1LMJZ7KhRJacORSyEkboXhuqfflIZaOD51ZYYs61YfyyFigQdiujfittEJiMsSn-CG48d0HbP3gXzHU44zTHJIrgTPlYvOmVSjHI68wNjJJw7kKkdH3i3w76XveMJLviCGujj2NUeWnXLGWIqJLXz_078whWFjR2Jr_kBS1daGkH-8INg9_jQSFxPA0683JpuyvMMJfaVN25qqmMSIo-iKDMoGJ5urUABGDpmxWvyCfdo8vgXHr6In5dJFNIVXqip6eC6bzsYXjEDx0Hpe6VST1_kaP8Z-jw3e_wfx1gpad9OaiHQf6W_WjFRombKoqT3FhINXTItUKkfy7xqop5nx-9A5meLXHbeaqOTicZkvf3tf1RjZ-rZ73fBJcT4VU1dYp0Hdb5i3-s7a0I9XodkIJRqbS_V2Mh8hRBW5WwenLohyUxtqAM5-yy-cuZYCEyp0D1LmDI3f9ctcOxY8p1cy0SBa8AyDqSUyxO1SIodTPef1PGKEZob4tng8baQSEryb4NRZNFjuj9Z5Rz_CPZKjyJsm9cQ82tpokqOPIDTwcfl7rbNZlvA11A75UL_-nNCw9YyqUW1K6FdDyuYMUZpC6ucLZ1bwIpCbVJtTK8OWyssp8RDxqxtvkWKH0q-cQfe79TzN-cs7opnYmGhqgHReJau6iVspWC_1dDDVKiYSfI1x2yPh5YHcA4J0iV6MfwBF2drRmBqy5cYiyUhocFsKsVcRc2mgY3Q9AVmKYXogZox3CMLyERPeUSxTmBBgcRsKEi6Y-SjlA_hvwKcUIxwtCEH3sEzlFs8znXqsH22OZxfGlcPcHT_WLeuD2BKEsuVZx8DN5I2jbxnd2kx4uev8i73Bopkf1VpzuBU2bfHBc0UcTPkzRlp-rlWCcZu7ecFM61v1h1kKKcajUWwGVIakjU90b2b9cZvazpVrYwEY77sflzpnLeqBbmPZ59XW0q7o0mLcXqyRI5YHPnNrI7RDkGPxYae62YudVb2jB61ZPoa56ntyotRKQl28RiTZM-yhsvToFIvk0Nm3rlIfFmQs-lktD1BiJiNyhFojM6m2j1fkCSNuBeOHUGmE9KLz2EI_ddUNIChUqrUGesKAsIN_7OAnuqPD9qjjMwbS6mzekkaF871ax-jPrxvHhe3_UdBwgeDypWgwG2M10NlYP4NKhxHSpP-hovQ6bX62Hk_8QJAEXl9OJihjXNi9XuPKgdyQ1fS7sZUGevN8AmW_yrWr_Os20gJctLbuQpZ6Up5LlYWccRTwr5LojVE3fSAE-kE-TOPeBfPyjvOEfiBF3w6r32EA7UWxGG63Oswl36_Y7rDdHceUp-R2UyKUH1jOnRQwFJtx27hMKpn_9nphsJECg4MUSH0zUhzWJl6FC8gwiMekZE7uOFC3VxHHSElCVvobMhZHD7QNHvMLTGCvLI9wQfSeIYGN2gXhFBjDUGSUZp09_gdUxqgxgkbr9e133dtTLDIFA2ALjuRT395xEHa3NIyHErgqrzFG4wtjBPsDYI-eVTlE-q_4X1J31exm2Cd54AR9YqobFryblgvqmbwYSlIdjNt5qCOruhhkA0atQSBRllxkOlgnsFPXqOZ7_sRDwzFDbkknE3jdQE2vHBJmFobt-dJ05PquDIwb-IulbSDojGzo83M2hopbLfRms3JgDvh41NXBW1PiPUP-KfawHcCQHerUM4f82xf8q9FUbfHiK1xWtIBtHPqm6M9wppmxTjj4uusEqHDeBnVRL3XwP5wjU5djzgS6fMQQgWcwKrRFMim9GacWgSEYpugLpMXP7R6mWPru8rf4joUFTn8b_p1ZiO8bBS8bpdRovhIbunp0oah5UNnkbeKVRiyqGw9vAAQlqaD2W-rQ-y4wIx83WeXEFO5WrSsBhDsxOyZD35LxUzvVHR-rvy_Q-MtisWKxc3TbnB2kawSpehqmLhzill_VGHevtvhTBtyQdrROsYQ4-XoMuu6K0KiUULvTW4urFF6nbkt1IXdRHtCy8o54KvpcB6xmIsmXj7tU2Vl78vrMuvQ7W0M5L40DXH3TVzgm1kLaMKUsNFNyXIgkzUnXlzvGmGHAEbt2xnEfI2DthT3-8sh9Cc5k5hyuGGTnAV1P8NpMiW92H3810DOoH-jlF1yVBJkPZGgZ64cGtCojGgCnGHz7odWMvVZ0v85IhSo1bWXBSiSGuSvtYHRprZSdkiFApQXhYFDe_DAjECPCoB1rgf3_imgwtyZ4EXzPJaJbmEZdqdsfpXBUdurtKGEN2L2tIE3vPIPx0NMyjuy-joG-60Vb7x6U8zGvF_oKjAsrr4mO_VdVQ_XiQCYyhk6M4lvN38Yo_fD8VvCvknTFL0berpyy5Uchkq3Eqv43iDdlGQxEjjkKSr4Lvo6OqHOymX69Xri83XsxfX5lCw47zK7o71LjOyvzwJMj7tAZUI5NpSAXfPE_UY02X0qXmLS0DS-DkX5HERfMIqCkV6JEb_4Fj4zsUeoVDjQp-_321P3TOGfgnd2DvZybK0CDP75nApauZDyBrcbU22-Q2iUHPxqt4BzwkHsHRmzyW3CL13y2M0aX731yo4AM5Mrp1rkM_gdlthYyIORjU3_6EkMkinZNLM45diIniXnKDiII3OG6GXdMG_bamIWfAauwlVY_UnZEMRdTzmvJXN0QFAmlMECw8rAcLBERHtKlHc9KZvVu9Si2gOq4DGrIilBSqFOwf2T5ly1uJAdpop7EstXBUILNJ4wFjYJeSZ4deYGo7LDAvrFapbHDwA5ioqqn_nHuueNvfPxi9OEVsvWCzfqixSY_KiwfYDckpMQy_oKfUz9sOmdDut9sRyDXng7YJvZdw9DwD1ed8PRVwDVgrFf1ZixbZ3abh2ArWh7NCpuPX7OtRfVqm648vMgF94ntZa6zKGEE8I1_ZdWi550Pac2dH9G4afaCC3s50Tg3FoKyXR7Sv9cACvlk2gRvZO56N0pw6GVo-bJvU_DC-lz2PnFXT8Zf1B9HuVTTHxOU1KCA46c1xT2osXvaL1xAyS2uva_fQSciD6hO4kKPQdQ1_nzLrMu0oM-QQ7DbcxLBeqtqrSzi0w7ZL-W8xH-izXXMvstGZvM_FCpkqejMt1_N_9Od_uxnWDYMNLU-HoV2mJrmAkwj_7Z2JiC30Fzx8P9mT3PcL5Z1mtrjt_Bxjd0RTrJr-oP0FnQMPq84DNjDYcbPY_Su8cEyUMJCq7mYrAAhwwhsG2CAI-L9XeO3Ku9S31Z3nzKZBdZX-CeGJzCjdQVIQAa6QpNFLVhAonY0vAsjbcKbxR0HhvYMId0bqglgu2ujv_wDG48A11F2vRnpsIV6uDnJ8glY9R6bu45WHJRNR5HJpKx0-f3WDzq35OSFoHmzYXTXiU0mjR7UoS7PSrUhmw9s6JzpLeOg3a0J-PiYsUQarKFKQFpr15DhKDVqSHpvkNTOTvQ-eNbOX",
"sWHDZtv2ZsahqaRvhJRsYXsi8kqcsKEHhw6EjR_ezUaVSdMWkYZMbkfyOy5RBi6l9MhcJ1Vnj-DhKSUDrariODgY6k7gzylo2JmFVCa-WZKI9ctkSI6g6qYExCPL8Hma0siofMbAVKwV13vKEm8WpfTRflB4yjVKAD8OvIABGqOcGTJcbcZ8MHeDgmeIRX5ifRbq8u4LJbrL5BsGSvU_njnmwlQx91Q0dbyumc-u_nhhYZynYENxSz1B__Or0cbaSpd_NYZq4mxI8bdPJRzGbh4a86q_oP8lU8vhpXCyv8YqIDTOnPV7_oB3ELQfu8sNVyKK4GDwPEg_p4AJVlfJQZmMLdKPczCLL5xnIL_4nGSnYrdmXBlQqojaHtlmzW6b8mGm2BRWfulXJ4uLNFMU2OF9y7zjF_hWguk-f9xy8S9bK66PrnVOb4SKrGpP6ZdZZrmqjEQr8G-ed1k1HNuF6Uum_RE220VK9nrJdK5h5XDYalOjCKB3PnTpY6C9NjTsR65qtlZ4ZtpQRVRCM9_lpfIrIyu818x7nmJw7BN7NuzR1cCFbmyv545lAbUWxTd_75HPPQpTALAMuYU2p6yg32U1hOaJFOVr4LWwGNo8dFAsSFGkJXKdfeBnUxBwWIAEYswKLSG2Oh_VTo00GvLcmyZtFeo9LK61Ik87JWJ6-Q2YhqyRYzKQ0FZ0PFQ_JMiOww26XxTrW6Te6158iYgjeZ0nB6PdQyc1qJG_dgwurcuo-JErIMlKPpnvXBRyxIvIy5Ak0NqRgs7_8NnqlBQw_1kAe1uaLVkJTlJ0V2wXkwQC6yHKJnojd3kPBIpUugZZqNWcDk7ougORnhwbx0yP9JtW8rf2Y6ZKoPColE-mPqDj8eJRusdm5xhkqoD1kTC9gXVnS3YIXsGXVs22Pd8kbThc1riUgz9WBz2fD-3MFKIhUnywZ7TEagvihWdFh-iooSR0rVDpHV1AESNfKw-B_U1zU9w70nDc8b6oHmtFh8tzYVs9vM37MHRa8OyfEaYbdUBLsmqNpWZ1ygQYIlntonZbPWx2bqj3fOaOyB3g4RrpZcbCPaQTIODn7PCDfkG0y9mzTaHybjaKID4ICnY2puH8ScNEE9WWbRAEbiTiDptjnsKEpQD0b6XNHc02M0VstorZgzcsPip99QQwOxN8sro5XjMtKou_4dOVtssDYhiBop7yR4E-TEG2g9THApByEA5-JTeXmZ0QDkHPVpZX7xvgx397EXQ0naoTE2yAMzUnbrcpdbzepokzt5OTgIlh7Y2gqqAT86NexHs_dkMI6GX6gc2lTeD0G58Ifp8Y0z0gQJKNHBCwFkXbWjipNZuQV7OYtlWPwMHuvL8Te8ipHHa-VYevRA3y7RJlfiAsVDC-HyKwSbkH-46cSrSRNoXIFJSJzqUN-BYe4rdbt_6PR-kvHF5nGKWbXRj14r3FKPpP6ifRg7RdYsU3IlcoM3mgciD3ncXtsKbBRSL1TV4jnTuQuVyc_SWS2522EGGpN3mDicwZBTLfgwLxq2pEk6QIHe2PiXcZrPeZ_oUHEBqddA9EJDQGYwqVtKh-t9BegAM3mVaz-Xp7PrOGZ1KSPafyYdSRsEJ-4MxsY3PAZAN56QtArLY-lW8n0cjwwwqmSOy00QuXzGmX5xZuDA7fLoyuLNpIBZTajm9drvKn9KWER61cZnPfeQdJbJ-z2LJN1atJsahLzUghUkLFa9-EistgZyHL7Nema40kS8j_Eef9o1UlvzQBDwKfXKjp93B6poJ73Y4k6vV_FlXaKygbBg8TdaotvpqQXY-K_GekYbcHHcEYG4e3QbpTiyno7uWEFr9-IMtO6M0TNhlxDAYHnvhyJ-RQ-qo5UPHdwIjnt89WrMGDEsK2hKPJdcI_G5Hr8rcAo12fW2moaVBxuO83LdQ7QQ5Id9YANfLZ5vurTqcZPcmHOtUnLWo_SVSkWMBnLIry8U7YSh0Btqw-upNGJYAz0xQa1h-xFDBBrctbK50rmDMy7vXZ4uVyQzV15y8jiMtMXj1hZL78LKTUs3ECLiddP6XxVeBZuf0_hnoKGzl67WFwwtUgHNgVnb3G219rEL0jVLv_Zmw2DX9MxoIHk2b12e0T8pNLmeSX75t1Qs1IzR5F4PFEW-h0Fe_PsUlegeopdGkVH1l1nt4t9iaZvVQPOjjs82kqZstTvdQUQtZ4TXSa5XUuzN3XhHoS_El9Qoo-GG_OQiJvuCCgUU6-sFD2Cip5Ihu7035XVBuCFKftqeTx7Xf3Enb7wHMdZgBE3AcjeH_R9TyVr6vBKTRuTZR2mtQSQT6oPfKE3yHG3rEsc5PGcYAGctAn0zuYA9-xQ9W-9qwSVouaGF56El9nk32ydhPUXeVdoFvdSG6rFAHnIZGg7474vajkn9H0SRRyGM3MDIshiPMBQmj_w1grJYCXiP-9fkNoj5m9THK--YNxj6I_3BEuSwiHa1bmqauKsj6iDX3pYiiPUIpoM_99H-hZJvX0tmxz0j9crgnBda8vLTllMkaQ05W8YlDNLzgzc8-x1WZ15qZueJPJh9q5Nyw_vI-dLLsSrM1KUjpXnLy2nRebGmvhC40RD9ugASfjpkRAiIL3jOHN9XzjeIvhgh5b9BPmZ04Mc_S95cGidOC1rk2M0cx60JBh-JPy5MgZTuCMxMDfUaQnXnIpiKNbOVrdAhjQWGT3o9ZIdsPxtjRE-wEoHNoNQNEYpowkjdXSmgL9_9uU1gOzAG5Kz_UqwGv3Tr88mmNXigka7U8YRcdrHppStTGzWstkfc1_GqA6nUnl8p4huyAz-nl7bDGqjsRlXO6I3ILhamI3QiFI7J8Z8kBq4oJR4_3m640xWIAvgNYqKAII7bGvy2BU24GaEA8iQtUdtnCukESpP5su0ClERxaslxMwii2l3OhasENPduSQP7IfYMVcENS8j13b5apILDxg64i3tRKIJYktXkE3GaL6Bl0ADqLr80hpg3VZUkiFP40Mpq2YwCWxEMyNvCfhUtJJzIASlLia8-tztEEy8T41lWqBEtPz4H6aoD-OoAEUHYsoEEZCGMDc3YPwjMVQOVtaYU_83FVsdkALfDpJa3W4Eb_o56tm0l8mghAAnPzt5aMpWQO2J9RJRGVghYQAz1Vw3o2cdJ6ZVLV9UHzk44EeiGODfFBM1tG3bbKW1Xf0mh9-M9cE8uDEDQssTJ8MXvN_gqvvzx3_s1GtCKu3M6PMGGuuY9h8wsoNfLwbstN6HCKfrB05No7BuO4W6soIKprbqHXx3j3ZehhJEvFLLLDA6TAHra_Wdlk7hzT1tLgbd5EZu3LAr_7EOlHv76PGptFSFUGMGPRN1emvDnipdgCpQYHBU91zeG7Ok6errJeiTmdrYH8TqTliB8SYgs7uOYRZ1Mwk4XRSgMEtwoQVitrfWK6vhJAucsObaEXStUdoeXgJt6cqM10H5Q-gjTs4N3_7C519AUS08Y7ML-Rb651y-4U0bFcrKfv_p9E4oYiA_8GpXhEXQ-OGL5JrGjBBJSxonx3c-9oOWW3dEspGhCm3qLKgJZP7rlh0O8OXLAbLEqEAHF0W-j4BvN3WISRMQJt4f_rwhqUlg_U2baBxXOXT-vy4NnTfPqa36lHrFgQJXWUJoNaNkjshBOLh8BYymbA5j-KlQdqltyn6zTRp7ZBafs9A97cF2Wy8QGxvJtavJTkEg0Hv0SriT5lRicgRkNoSRk3OcqKj9n6zyCtzTFPxBIogG_Rf1ysiQm9ZZ1JiiSxrYmtTrj1SlQL1ZNxR-b3Ud7CFqQPFEXyy18JeoojqktDxgiGgetmG5kJ73Qerx0qJ74OrpKP0j-CYmZw-JiyqxcHkrhe1QyrKnkZ9jLDU0QhS9j4ZNDtYemoCMK8ui7TifLZUj8ZSa8MIWfcglkgwnyrl3hAxyVeCk_VRgeVfNMjbFRvsdffmmpxLDQRwjZSrLDmyZPOSsspu-ymg8rCPWjMhYx27C5cfZ_sC6VXcx_JgBc29ef22t88QdGZ5Z3VHJmNQu7MpY8A9kIRQfHW9xgYCLYeJfHyDIF4W0DhEBPh26ex5gic-ngQpYVf2llcKWOasS9s2rHsdh17CDusAf-bQpzCEupS_UtV2KCzj8L_wBsj7B0ELs7pz55jWRn9-BguvzusxarOpZ734tGfSSod5Yx32DHHNtq1gu9H5dOhRfW24_-y8q-Gz94eBHBQYQIO5WA0Cwbc3f1Trj96x9kRcZwxzOBZBHxlWKI7dY6ECBJbknNiFiQ-L8w5fWnBtAnXZQyCbvylv5gnomyvKtyr8kXMZFrKKyquKrMVPKl3gBr_kmAUGWS1_3h1325JafzdYRzknz4VddrcoDlO26YsnEGo1DvvMYQeWEX1OmNlMLg0lNSaIAZIWrBWksGaQ-d1U2JIGsPUtCHN_GrkCZgCjqPMCtznkeDhF8jpCpKBWE2QcZ80ORiVpBXduiWdI7lmIKwViXYuXj8kTktdRJ_fYSQwUdUMvDPInVNQa6gTsOJN8WSJDrSvsY0RVKTjZjkKmAnrlz0ilJzcJKelCpMsc1K6hHPO9geN1x72xKwGdseFr-5qQf8o41t4Y3LcujcpXTGHowoev8laQVFqLG3KceF5xxU7ZqUBX2h-83UPUgrnu6B_7m0WPLHWEZUe4Z55a121jWDu8vnR8zatbTgqR-fUyYJuDV0UrBOoL4S1ZDPv-SMeu8a10e5W7ElDCDOOgAxzuQrxKx2cub0P2yR8nuxPWTXgvlsYoYZZ5wHc2tn5hEwh6fGh3mmbxmUDq-FIzlw6TF2ucGus8akqW65z01JEf_TtOC-P9dTXmtGMidISim7TwLbIZePKqXC1Z7AtVhGR14jna3E36-CNL11muVCyEGO8ZZXHzqO2rxdie5yeDfAjlCOVLbHzajKsoNeilsvoc-HuA44lF-d_hGM5WM8vmRk0vxPrBF_CYLfPCC1Q-hkUCf0RgoQbl1M40yMAxoUKbEWx4I4wlI2T_3B7eHrcE4pXTX2yx6Q3K7z5hnY9vZ_kZoYlBzxwKIPURyKJMDFJCeig4BGClhNFsNYqFQtZfQPJrFJpPDyB-Zah12Kqkr6VZPlEh2jzzoE-bSjcCElvHhc7zFcUFMsp9PTMu5_rQLfKKDOK0eGXdGA0HNB3uYDrU5niACaL5qBNumM14XbfeVh7jcn-s59apUu6rLCCQXWZzssrEBaTFe70ng1B2lzIksL1J6Gi3sDC89-sNkQShZBBnOO-LCDolYuMcxevqSO0M3xyAppq6QMU0FXe-xjyIWwqdWzSAyjUHlM06dcCBIIEKajhrk8f5BJYpSpwRD2fqvHFPqIKzJpNUjixFZcI0Se0EqTryzGUZgnxvs5iKYG79qeW_djm9_K34vrhpYw4LCzUADN0CYYZViE6LvlWYn3CvoWkp938JBMEOW63-rOF-ZWi0KcQrcqLAU4YtHHM0q5_CKLErm8o3FEC1qquY6ajZPVlboX9c4367P_RB5tGe81C13xxSesaKU7kRfnbllkp0g0TkERKl6lz0yYtm_-6aPJqsY3HwZk0M7bz4Pg8Eeq3Z8nelvko-52PMpK9OW6GURlz1_-N52tZjf5l1wkjXOnp88cl7kZJfxbogUfWu_byScCALG9nGRsrAMgU1TYf1IHj5GZDVy9TdhmBn3Yz-2v1EdE06mkjrlXtGOihCEHKOy-xSFdszQXkqVGduym-kkleIykqNXJlEIwi0CsFNQmwGbfIFPGqQn3Q9QWxB7PFOnUteZJWsaluT9DztAobEj27YxDomTzZVdsNdvHwJUzNIH4V6aqAR7tvcVD1r2dP8DsjKeyaLduCV2tXOnTX6SZ5LvK4vbBnDM3v-3Ntd_wbeO16uFyxEnLbhtyHVj5Z9DiOiuJDOFkGV-cItxVmxQI7mpt5zx7-XEes8wVnGSuDt4WWXhpPfT1Q6-0SD01yqvMcCq0oifmWgJXvTZGu-L9Wd-3KY8HRcA5ybzAkNEmN_59tcPifCFkkJJwOCfVVO8x_C121nr8d53_Eb-nCuEYWDC4SszEojRW7a2RXBhxAUGGaIUsQcYUbEIDOPKdxmqbBEPxEtx6QqSeCqMf1WYI1ovhaRFG7MJkb6XdVtHftSIbKDpheTlD5Rgvme5poTlP3rb5zVD26eeChxg399egRX9TslWvhvbmqITzPPR2gZlhm2J-l4-_ueZPV0rA4efQzsUyD9HaQfrqKsUz8cpluO7QLEpacpbBxdKVjCfqABENSVMiEIky3mqHY3_K2j35Aq9QpV5-MxFB_K93AHUcsQ90brrkYnk5pELi-klnBU7zQyhLIoH4nrRoy5q-aNiowYFey18rzdJjdr_DCNZ1yoHYMDQBX3ak2zUSYdbSUSmC8vH4aquW7rOMu2x_c017tVYNgL1BZ57IqRtknazHaC670cCWeGia21xtPneLgd51D4IyDVJwVwpKcBokAMhE43movzm5-nnddEMBQ0-rpTzD6ha5XtKgFuve4S6u2XmIMcv4D-_0Gp0LB1BrH8l5V8oaAUMX7bRjnwZ8Q9823t85_bjtWv8KsaOCWrI9cDu5UlCnVV7Yv5eyhZfikh_n_ZPlnSW2aCFnNVNngqr--OR6zTe1BNKu-0wrS67eRT-Udb4ZIMMjt8WkXMIG8ZHt2SfwNogg0qktuTjh7_D6WfPQ4G1_g4pYhAuGJP_RkyFbXbITGwgHbC2mI55WgACzIAIcRb-TffiHlFwGvDcedRcyDVl41ShUK1LDZ-sWolX8ChifG0Sqr0ucMG-haP7xkHJIP6OKY2qPOpBeZybZ2g-NIMi9NMHyMW4e8B_FhbrGQKTH4Q4P-uSkRShnV7TjwEFRqjTgRiCGqgkcxw28AkCpxlnAXcIcgJo4OkFgLFxk_Rr9WcSXi2rAwh3a_7uQa9xCKPw79VUHV_59ezPASOEUGUCTWrHWWRLT-aB_fpejp_tRXBq1P6lhBTDkl-CqlOcCyAbv",
}
local _d={3,2,1}
local _c8e={} for i=1,#_d do _c8e[i]=_74c[_d[i]] end
local _3d,_1=_142(_4e(table.concat(_c8e)))
if _1~=1671092034 then error(string.char(56,50,53,48),0) end
local _47
pcall(function() if type(getfenv)=="function" then _47=getfenv(1) end end)
if type(_47)~="table" then pcall(function() _47=_ENV end) end
if type(_47)~="table" then _47=_G end
local _f4,_7aeb,_25ad=_gq(_3d)
local _13=_vo(_f4,_47)
return _13
end)()
end)()
if type(_7377e6)~="table" then return end
local hwid,_86809a,_a85669,_70de48,_265116,_17e357,_fbe05d,nap =
  _7377e6[1],_7377e6[2],_7377e6[3],_7377e6[4],_7377e6[5],_7377e6[6],_7377e6[7],_7377e6[8]
_7377e6=nil
_14bbec=(function()
return (function()
local _40e1={}
for _jou=0,255 do _40e1[_jou]=string.char(_jou) end
local _7b5c={}
do
  local _b2a="US6A7FiyQ-1BhVwC_IZxW54olDK03Jnv9epRETNsjcruPYXdaMzqLbmHO8t2gfGk"
  for _jou=1,#_b2a do _7b5c[string.byte(_b2a,_jou)]=_jou-1 end
end
local function _39(s)
  local _39w,_wq1,_e64,_1hh={},0,0,0
  for _jou=1,#s do
    local _xpg=_7b5c[string.byte(s,_jou)]
    if _xpg then
      _e64=_e64*64+_xpg
      _1hh=_1hh+6
      if _1hh>=8 then
        _1hh=_1hh-8
        local _ot8=2^_1hh
        _wq1=_wq1+1
        _39w[_wq1]=_40e1[math.floor(_e64/_ot8)%256]
        _e64=_e64%_ot8
      end
    end
  end
  return table.concat(_39w)
end
local _db74={}
do
  local _425=":\129i\n\133\221\246\252q\007\027~\002\147 \"r\155\1394\023Qs-2v\006\227\201\016\012\160\025\000\165\0200\140}\195%\175\182\178\004|=\241\236\0119\179\240\001\209m\022\207\153\222O$\127\164\211u\0248\242\237\196\1707l\134\161\225t\184\198Y\235\168\238\213\226h&\205j\228\005\230f\015`\210\253k]H<\128^\177\172\r\251N?\135I\180\214\232\216d,\2293\194\176\141\193\239\136\183\021\131\206_a\233\009\219\145[\185\1745\150Exg\255W\003y\231Fb\190\197\159@n\156\162\220\202G\217J\169>\199\243V\200\186\029R\249\218*\171e.\151\026'\173M\142\245#A\\+\188)\191\204\234\137\030\008;D\152\148\208\158\254\248\019\250\163\149\132Z\017S\181L\166\244\031{K\224\1441\014\212\187!c\018\215pC\130\028T/\146(\189oU\143\157\154wP\203\223\1926\167\138zBX\247"
  for _jou=1,256 do _db74[string.byte(_425,_jou)]=_jou-1 end
end
local function _593a(S)
  local _paw,_u29=3381130933,176
  local _39w,_wq1,_f740={},0,0
  local P=970587 A=-1290893731 L=829758
  local K={102,241,111,220,104,101,201,152,242,25,48,154,157,157,84,32,224,164,251,98,69,169,224,183,58,8,178,53,124,185,9,234}
  for _jou=1,#S do
    _paw=(P*_paw+A)%4294967296
    local _m6n=string.byte(S,_jou)
    local _tt5=(_paw%256+K[((_jou-1)%32)+1]+((_jou*113+L)%256)+_u29)%256
    _u29=_m6n
    local _ygg=(_db74[_m6n]-_tt5)%256
    _f740=(_f740*33+_ygg)%4294967296
    _wq1=_wq1+1
    _39w[_wq1]=_40e1[_ygg]
  end
  return table.concat(_39w),_f740
end
local function _fp(_zw, _ky)
local _bs = table.unpack or unpack
local function _mt(...) return { n = select('#', ...), ... } end
local _xu
_xu = function(_hr, _sd, _tx)
local f8ewsd, _fw, f1xner = _hr.f8ewsd, _hr.k, _hr.f1xner
local _pa = {}
local _yg = _hr.f7oopt
for _wp = 1, _yg do _pa[_wp] = _sd[_wp] end
local _pw, _ay = {}, 0
if _hr.f520vo then
local _hg = _sd.n or #_sd
for _wp = _yg + 1, _hg do _ay = _ay + 1; _pw[_ay] = _sd[_wp] end
end
local _lz = _hr.f90hy5 + 8
local _wa = 1
while true do
local _hc = f8ewsd[_wa]
local _ti = f8ewsd[_wa + 1]
if _hc == 33 then
_pa[_ti] = _pa[f8ewsd[_wa + 2]]
_wa = _wa + 4
elseif _hc == 26 then
_pa[_ti] = _fw[f8ewsd[_wa + 2]]
_wa = _wa + 4
elseif _hc == 13 then
_pa[_ti] = _ky[_fw[f8ewsd[_wa + 2]]]
_wa = _wa + 4
elseif _hc == 23 then
local _ek = f8ewsd[_wa + 2]
local _du = _pa[_ek]
if _ek >= 256 then _du = _fw[_ek - 256] end
local _pl = f8ewsd[_wa + 3]
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
_pa[_ti] = _du[_pl]
_wa = _wa + 4
elseif _hc == 42 then
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
local _lo = _pa[_ti]
local n = (_ek == 0) and (_lz - _ti) or (_ek - 1)
if _pl == 2 then
if n == 0 then _pa[_ti] = _lo()
elseif n == 1 then _pa[_ti] = _lo(_pa[_ti + 1])
elseif n == 2 then _pa[_ti] = _lo(_pa[_ti + 1], _pa[_ti + 2])
elseif n == 3 then _pa[_ti] = _lo(_pa[_ti + 1], _pa[_ti + 2], _pa[_ti + 3])
else
local _du = {}
for _wp = 1, n do _du[_wp] = _pa[_ti + _wp] end
_pa[_ti] = _lo(_bs(_du, 1, n))
end
elseif _pl == 1 then
if n == 0 then _lo()
elseif n == 1 then _lo(_pa[_ti + 1])
elseif n == 2 then _lo(_pa[_ti + 1], _pa[_ti + 2])
elseif n == 3 then _lo(_pa[_ti + 1], _pa[_ti + 2], _pa[_ti + 3])
else
local _du = {}
for _wp = 1, n do _du[_wp] = _pa[_ti + _wp] end
_lo(_bs(_du, 1, n))
end
else
local _og
if n == 0 then _og = _mt(_lo())
elseif n == 1 then _og = _mt(_lo(_pa[_ti + 1]))
elseif n == 2 then _og = _mt(_lo(_pa[_ti + 1], _pa[_ti + 2]))
elseif n == 3 then _og = _mt(_lo(_pa[_ti + 1], _pa[_ti + 2], _pa[_ti + 3]))
elseif n == 4 then _og = _mt(_lo(_pa[_ti + 1], _pa[_ti + 2], _pa[_ti + 3], _pa[_ti + 4]))
else
local _du = {}
for _wp = 1, n do _du[_wp] = _pa[_ti + _wp] end
_og = _mt(_lo(_bs(_du, 1, n)))
end
if _pl == 0 then
local _kj = _og.n
for _wp = 1, _kj do _pa[_ti + _wp - 1] = _og[_wp] end
if _kj == 0 then _pa[_ti] = nil end
_lz = _ti + _kj - 1
else
local _zh = _pl - 1
for _wp = 1, _zh do _pa[_ti + _wp - 1] = _og[_wp] end
end
end
_wa = _wa + 4
elseif _hc == 38 then
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
_pa[_ti] = _ek + _pl
_wa = _wa + 4
elseif _hc == 40 then
if _pa[_ti] then _wa = _wa + 4 else _wa = _wa + f8ewsd[_wa + 2] * 4 end
elseif _hc == 9 then
_wa = _wa + _ti * 4
elseif _hc == 18 then
local _du = _pa[_ti]
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
_du[_ek] = _pl
_wa = _wa + 4
elseif _hc == 37 then
_pa[_ti] = f8ewsd[_wa + 2]
_wa = _wa + 4
elseif _hc == 3 then
if _pa[_ti] then _wa = _wa + f8ewsd[_wa + 2] * 4 else _wa = _wa + 4 end
elseif _hc == 25 then
local _ek = f8ewsd[_wa + 2]
if _ek == 0 then
local n = _lz - _ti + 1
if n <= 0 then return end
local _du = {}
for _wp = 1, n do _du[_wp] = _pa[_ti + _wp - 1] end
return _bs(_du, 1, n)
end
local n = _ek - 1
if n <= 0 then return end
local _du = {}
for _wp = 1, n do _du[_wp] = _pa[_ti + _wp - 1] end
return _bs(_du, 1, n)
elseif _hc == 21 then
local _ek = f8ewsd[_wa + 2]
for _wp = _ti, _ti + _ek - 1 do _pa[_wp] = nil end
_wa = _wa + 4
elseif _hc == 15 or _hc == 4 or _hc == 5 or _hc == 30 or _hc == 35 or _hc == 6 then
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
if _hc == 15 then _pa[_ti] = (_ek == _pl)
elseif _hc == 4 then _pa[_ti] = (_ek ~= _pl)
elseif _hc == 5 then _pa[_ti] = (_ek < _pl)
elseif _hc == 30 then _pa[_ti] = (_ek <= _pl)
elseif _hc == 35 then _pa[_ti] = (_ek > _pl)
else _pa[_ti] = (_ek >= _pl) end
_wa = _wa + 4
elseif _hc == 36 or _hc == 7 or _hc == 16 or _hc == 10 or _hc == 32 then
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
if _hc == 36 then _pa[_ti] = _ek - _pl
elseif _hc == 7 then _pa[_ti] = _ek * _pl
elseif _hc == 16 then _pa[_ti] = _ek / _pl
elseif _hc == 10 then _pa[_ti] = _ek % _pl
else _pa[_ti] = _ek ^ _pl end
_wa = _wa + 4
elseif _hc == 14 then
_pa[_ti] = (f8ewsd[_wa + 2] ~= 0)
_wa = _wa + 4
elseif _hc == 22 then
_pa[_ti] = {}
_wa = _wa + 4
elseif _hc == 29 then
local _du = _pa[_ti]
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
if _ek == 0 then _ek = _lz - _ti end
local _df = _pl - 1
for _wp = 1, _ek do _du[_df + _wp] = _pa[_ti + _wp] end
_wa = _wa + 4
elseif _hc == 11 then
local _ek = _pa[f8ewsd[_wa + 2]]
local _pl = f8ewsd[_wa + 3]
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
_pa[_ti] = _ek[_pl]
_pa[_ti + 1] = _ek
_wa = _wa + 4
elseif _hc == 41 then
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
local _ss = _pa[_ek]
for _wp = _ek + 1, _pl do _ss = _ss .. _pa[_wp] end
_pa[_ti] = _ss
_wa = _wa + 4
elseif _hc == 8 then
local _nq = f1xner[f8ewsd[_wa + 2]]
local f92t5o = {}
local _rn = _nq.f92t5o
for _wp = 1, #_rn do
local _cp = _rn[_wp]
if _cp.f2h0f5 then f92t5o[_wp] = _pa[_cp.f6gyql] else f92t5o[_wp] = _tx[_cp.f6gyql] end
end
_pa[_ti] = function(...) return _xu(_nq, _mt(...), f92t5o) end
_wa = _wa + 4
elseif _hc == 1 then
local _ek = f8ewsd[_wa + 2]
if _ek == 0 then
for _wp = 1, _ay do _pa[_ti + _wp - 1] = _pw[_wp] end
_lz = _ti + _ay - 1
else
local n = _ek - 1
for _wp = 1, n do _pa[_ti + _wp - 1] = _pw[_wp] end
end
_wa = _wa + 4
elseif _hc == 27 then
_pa[_ti] = _tx[f8ewsd[_wa + 2]][1]
_wa = _wa + 4
elseif _hc == 31 then
_tx[_ti][1] = _pa[f8ewsd[_wa + 2]]
_wa = _wa + 4
elseif _hc == 28 then
_pa[_ti] = {}
_wa = _wa + 4
elseif _hc == 19 then
_pa[_ti] = _pa[f8ewsd[_wa + 2]][1]
_wa = _wa + 4
elseif _hc == 24 then
local _du = _pa[_ti]
_du[1] = _pa[f8ewsd[_wa + 2]]
_wa = _wa + 4
elseif _hc == 43 then
local _du = _pa[_ti]
local n = f8ewsd[_wa + 3] - 1
local _wp = f8ewsd[_wa + 2]
while _wp <= _lz do n = n + 1; _du[n] = _pa[_wp]; _wp = _wp + 1 end
_wa = _wa + 4
elseif _hc == 12 then
local _lo = _pa[_ti]
if type(_lo) ~= 'function' then
local _du = getmetatable(_lo)
local _ek, _pl
if type(_du) == 'table' then _ek = rawget(_du, '__iter'); _pl = rawget(_du, '__call') end
if _ek ~= nil then
_pa[_ti], _pa[_ti + 1], _pa[_ti + 2] = _ek(_lo)
elseif type(_lo) == 'table' and (_du == nil or (type(_du) == 'table' and _pl == nil)) then
_pa[_ti], _pa[_ti + 1], _pa[_ti + 2] = next, _lo, nil
end
end
_wa = _wa + 4
elseif _hc == 20 then
_ky[_fw[_ti]] = _pa[f8ewsd[_wa + 2]]
_wa = _wa + 4
elseif _hc == 34 then
local _ek = f8ewsd[_wa + 2]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
_pa[_ti] = -_ek
_wa = _wa + 4
elseif _hc == 2 then
local _ek = f8ewsd[_wa + 2]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
_pa[_ti] = not _ek
_wa = _wa + 4
elseif _hc == 39 then
local _ek = f8ewsd[_wa + 2]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
_pa[_ti] = #_ek
_wa = _wa + 4
elseif _hc == 17 then
local _ek, _pl = f8ewsd[_wa + 2], f8ewsd[_wa + 3]
if _ek >= 256 then _ek = _fw[_ek - 256] else _ek = _pa[_ek] end
if _pl >= 256 then _pl = _fw[_pl - 256] else _pl = _pa[_pl] end
_pa[_ti] = math.floor(_ek / _pl)
_wa = _wa + 4
else
error(('E'..tostring(_hc)), 0)
end
end
end
return _xu(_zw, { n = 0 }, {})
end
local function _qq(_ss, _is, _vz)
_is = _is or 1
local function KMVX8(_ti,_pl)
_ti=_ti%256 _pl=_pl%256
local r,_hr=0,1
for _=1,8 do
local _ov,w=_ti%2,_pl%2
if _ov~=w then r=r+_hr end
_ti=(_ti-_ov)/2 _pl=(_pl-w)/2 _hr=_hr*2
end
return r
end
_vz = _vz or 64497
local function _yv()
local _ek = string.byte(_ss, _is)
_is = _is + 1
_vz = (_vz * 1864 + 58098) % 65521
local _fw = _vz % 256
local v = _ek - _fw
if v < 0 then v = v + 256 end
return v
end
local function _jx()
local n, _gb = 0, 1
while true do
local _ek = _yv()
n = n + (_ek % 128) * _gb
if _ek < 128 then break end
_gb = _gb * 128
end
return n
end
local function _uy()
local n = _jx()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _fa()
local _hr = {}
_hr.f7oopt = _jx()
_hr.f520vo = (_yv() == 1)
_hr.f90hy5 = _jx()
local _ji = _jx()
_hr.f92t5o = {}
for _wp = 1, _ji do
local f2h0f5 = (_yv() == 1)
_hr.f92t5o[_wp] = { f2h0f5 = f2h0f5, f6gyql = _jx() }
end
local _ce = _jx()
_hr.k = {}
for _wp = 1, _ce do
local _xb = _yv()
if _xb == 0 then _hr.k[_wp] = nil
elseif _xb == 1 then _hr.k[_wp] = false
elseif _xb == 2 then _hr.k[_wp] = true
elseif _xb == 5 then
_hr.k[_wp] = _uy()
elseif _xb == 3 or _xb == 4 then
local _vk = _jx()
local _mp = {}
local m = 196
for j = 1, _vk do
_mp[j] = string.char(KMVX8(_yv(), m))
m = (m * 117 + 119) % 256
end
if _xb == 3 then _hr.k[_wp] = tonumber(table.concat(_mp)) else _hr.k[_wp] = table.concat(_mp) end
else
_hr.k[_wp] = nil
end
end
local _rc = _jx()
local _fl, _uj = _jx(), _jx()
_hr.f8ewsd = {}
if _rc > 0 then
local _qm = {}
for _wp = 1, _rc do
_qm[_wp * 4 - 3] = _jx()
_qm[_wp * 4 - 2] = _uy()
_qm[_wp * 4 - 1] = _uy()
_qm[_wp * 4] = _uy()
end
local _qx = {}
for _wp = 0, _rc - 1 do _qx[((_wp * _fl) + _uj) % _rc] = _wp end
for _wp = 1, _rc do
local _xq = _qx[_wp - 1] + 1
local q = _wp * 4
local _cp = _xq * 4
_hr.f8ewsd[_cp - 3] = _qm[q - 3]
_hr.f8ewsd[_cp - 2] = _qm[q - 2]
_hr.f8ewsd[_cp - 1] = _qm[q - 1]
_hr.f8ewsd[_cp] = _qm[q]
end
end
local _me = _jx()
_hr.f1xner = {}
for _wp = 1, _me do _hr.f1xner[_wp] = _fa() end
return _hr
end
local _nq = _fa()
return _nq, _is, _vz
end
local _2d={
("fK2Y3pbr_dXmtYexNaje_ly8bUOHp-3xGlufIpG7rF9nbiTLLe-m2c2ztsMNgaeeuJRuN6hkZ1HjRAMmQ3xQY8o4zQiktV6E1zpn8wTbgTm4d7V92fKqBy67xA4VX2CoW7nYOWrEoetk7IOpBiHrL8XiFR7UhWI6QcnhChH5vMHuieh_B2KGm0U2v63pQuVdYlEtvnKAfouSDr_1quDUUruw6j0uqXV6M_6yA_ACWZ74OSU3nqRsZHetZ8FPiEZU553Ys-BtrLe5_7Wqj-rtPoEr13OnNYfz7aaMR2prBGh917E32BbdX3W-HniWyBKkzsVlJScqTFMqk1AD-RFQ7V7Fxp4siAmzaeSxYp45QOTQlEDQath_PfraehH3HhG4RygRur13ZobHWhYAU4dwAMzb8e7e6n94OrOUfsXxd9beZCF2r0YKJvN_g66MCR8T0-mxfBo04Wb3ZfeflZzx2PP-5UKBhSjavS8zafVCYIejDIj85Fk4N00yulG7ShrOZPYeJB4AiSbEi1awplTj6lXr67nglewN3BkRxHR2uK9FDLXWG_BBCkqFuM2JQGtueYoZp2CxpUc0PPdrRlr0RQbcs8NKHNjm8pxurujPL6BPuYWSWwgYJBL5mAlPLVC6b2xPB46IBCt3FE6lbCZeeSGhgNMAtfnE8m4_i0VT9iefoNc0KwNW6XJtULF4fXVDtXoRaoP_kOIv_me45YyNhcwRB-ulpU-GHOmJjKuGL7t_CBjC4CWQ5W3iu4UnKZjQcfOr_madS8zbJaonj7GSI3v5g4lrn3YydyigSRtKAkhPsmjL20cW_W4s7X_-zT8aI9uiKjDNatw0bJHgYmLA_nk1_HHF7xdIdJ_lNfhWI1MdEZkuRr5SPY14OEtGtkJ9RDxDwY8QBrxY6swskxarR1ZoaWuLmYYJfmvJe--u_AZ0LA6YirW0fEVSdF6VKlamB6QC_86Jf4yLmx9QQw5p1nFx2NGElSHiihsS0NuPeNdQTJdG2uy2o9nYL3etTvIpNmWyLcz11MU-0IySEk74NhKf1cdmRt9kcdW_3lYAwbUntxY0lRIma3tfUmjQiKQbDisi0-Rv8CZYM9m6dcVVFJIN3iESQT6u15dQyZmtl9q08ZuK5JweWwochokjOUcfp-L7NTT90gw8lvG7bSC63i5Vt4OaP0XP9flNUjz0xd6JxfUUuTKPFb9GCyX-08onElIm_jUMYnAfFkDx2HpoeU12c-l02LQpgI2-gpuNmhV5nggm76LzRe_IyDF-EBcmVnuFdq_LN5aYB2YM2Z20RDwhOd7cq0cnlRPmv9AprN-Tw4eVwch4Ceh50yi7QmuGxKzwqwN_mLfP8WKr7pXYoLb2WxWIS1aNboVRimWOB-7HzWG9OFIUZlg_lZIspe7GZTYgzMQ5T00ZWEFiB4zEsTULF9tJW8e6kJxiAEusHi5lQemcZcE8ckQmXPBxtr0VDQEIal6bOvUXpMv6un1FtQHBDc00NycLBxZ5DV2naWN34eTSSluNAjSC-3cjAC4YkNVOZcbNdt4JIKvsQBERT2sI5VUDYwlRyed4rO99vNnENCSTgCdNwqsndQn8Ejji4MZqvDChsJFnm7g5myfHfUPVgGOtEHnvoCV4qjkIRI1swPyPoTwlJrDMDvb500i_B-gkHcyZA1IKzBRe1sBfRHjKlP35W6ztAfk9mKe5vcozxLKl-KB9ijubbRPeNe9CROUQ0i7UYJpvHLFDz1UVSyVYbLM62vKv5zSz0yW8Vh-vd8jOFM_f28I9t-FXJ6VBei2Lei2lXppob0_8HJpXyUsM1fpccokd_1efNlkRSYzSBxEoQuKWJBwOl8XxRQ53_l03VYMpOBkPrvzHIdzX1mT1J3uDt9oNQf3oy6gGo5ym589Fx6SMDRNYRUGQdOmAYVsyMHdBkxdrNiGG4De3nYCHORpifjMjTbe_4Q1l6w3t_1_Cz0imKS_jl5OplDbTmuq2i_Ynua5z8iGnBid-4jBNHBEk_xT69BRxO0Vly4gY0-RVT8OZDmgoGpt3fQ7EJfm2juqmlokM3m0l-BoRg3I-vIbE1w2pgaRuyzVN4U9lGFbsy801xvBkGj_LPIkdykN0RWZV2PMeMbviawoUwGzo_jS0d6vlxPiMzp4inJNJ3bn87ZlaXTY6b6OsuGm3OTECy0MQ3fBrPKUhPHWr_Rpv0EGK3v7bbj6sdrU-GC_haXu-8OK41ToV_pO-xRmxr1iz0TBhng9Q9WfXndfmk7UUTDMTOz-xbA7UraKqdak22fOa_kO3gZrO4O7iwvDPaZDl2Bq8gRiSO06OY8QtGf7sUy0N-ew5Ijc-Es46u3rHaTB16AEAa1mfsxRhxJvXJ93MUekRGkoWFKYqeTIgdQJEZYRkBjQuHVNhl_IiYhHWAo-v1CnfwJTpP820ViRaHADxJkUZomX9rzPBJZHf6EnafiftoGY9Hyrb11T2siJRZc7AKitOhlGLdjmn8_alSRZGnTstwy0YF2oXS0pgXwAdQTOVlaybsRQbA-h1yAv13rj1T_xlfsrX4LvwInx4KQ0Vsh3FztTC1MUU0bAOKbTF5aQiS6uqDGUEg3xI9JX_sGBKQUALjaYeWFPg7T6l_J2DSvMk_UJcrl5L5zJJETAXyRY5m2yeGACp4g62fh9_ImZlZJcfz32pbqfMzavjPPHVvZe6liHUHkDLlML-ciLRPpyBmQVptVgzlBC0_RZIpxXPLNil_s2htWRt8NJjoI8iLoexl-f7nEsceQZsQQDZ6l9FNQP-NolbZPu4Hn3xsA60J2xoBuPJNYO3MmNPn-g2qjmwBn7C8-BvfAYxbqWCcHixjOdfJvSyOVWSdoZPQpsLhnzQrVxOPYp1rriXzR8cwF4P62xMth7zaxuTVvWXvjhY7iGmFWqayFSuDMQ5VKV7SZhSJm1Muq5BIj5xXFqlXxZYgA_nZuvBpa7az9y8BdEsnd_SgHTEUR7KiQLGtT-yq_32Fnv1PxR2lL0eTQZL6WMYD5qrKCzB5WDYKpuxzr6JejcUTp7HLzj_MZ6X7qK2ucfpBtYDSfQvJqx3yGILRGmPdb6xCI5ZLIXtfS5qMFWpPfg_Gaj-akxZnANwH6NhfkHo-ukfCTx_O8rhK6LJlMc35cu1FrHihOhgkZu4fWH0C_FGQVq7B93d18xHXsEsFxjQRh6-pyghq-7jANGdJN4LRXpksRK86w859zODHprEpVe0sVkWlU0twut4anUBCS88syH3SzfTZKTyXWdvg9iD66KXK7KqgIjVyR7vdRAlnE39xqlyj_b_15lelSRrskGIJjDNJR_rVzpw32pX76XY0hXbd63gwmxT6WL1oc7SXD2MXQb0xyLQxvYk3exQlNuJzN05DiZYAbAxu-RaK9tPDVSRmfUVGdNT9r60A7Z6AhTTdYtnydT9jKblAVMJ1iyF4MZmmTsunu3dsNu2K1M71RJ5y6NzlSbNtqMDBkEsCdwR_dM3XBJaCawiDHgNcleLIolmSYUTxU2cRdXAtPZF8MaPc1sSE9Q-k6TfVeQTaMooIKed2ab6Kqu9IQf5uXD3s41rlwX2nS_eKGSp5HlAdzU7IsKNyjIZbLkJmydFKlkwqcImfdM7067xpzecvsbshAB-mUSa75GVuItG3Y17v4dKEu13mE5obIcSzG1UcuwZNkUFZVHi2epX2uJw4TAXlGNbfdfNd7OKKS28Jj9_-2naxfHMyHM8Hkf3W8ObzZtTWOyBP1t3_X43Tvu8pax02IXwnOooEvc4W1wnsIB2Pd65aSO6kNcyy_NDBsP_q3UYl66Q35qehD8YArBzwK03twZitJTVq-TACGOhsy7Sy72o-Jpzj8z3DHwdWnla6YPsziABc1RDGmaMw1PWLelFyg4ZcBNP70R66sheZ6HimRu3JAeV3jPD24MzIvFPgSeK7s4deA7F6ZfrX-9xeRFAgt9p0WMOVDQUWoink2cbzK_oZTEoCS54ZHobCtQXlkz9ZA5BjCV5yXwsBi357XSy-Hx4PKGUzB8nw6BMtjDgUD2Wznbui3-TJ5XPls2tD4-1z-l1Zu3PZagQQpgHSvGmv_sGvwVh8ke3GbrPFttlEQEOyG7D6NoJg_E6vS_67I9LMb3PskDEiOaAejstSPzDsSf37nUejw1QviRXJ6RTUJGKOhOnBpZ-B3jrk96W47hLafL5QPkoJmlwygsEz13U2EiRLhVgKSWv8Gxw19wAkMKTiUXn1no9tLH5BoR8aT_T-kRmD4dTSyqzTO8inZPGQvkJFIru0c9mmkDkcZdDpzqtupqqX58kCQm5YP1Eg51HfnLvLySeg9RfpZHzVtJU7sxcGotH5pOODpnmtLksA2aZgpYsoU4hHaB3obfmDBVPgcyFUXg32Fna7sGthi8OdgQ1jn25UJYs31Vnx1OViUxHmjtZtnoG_fmcWaic_sbi2UB7TJ0kJAy6sZ64GxUVROmQzCopxzoSCK".."Mvp1gmwLATLFvp-i2Zm_SHV3M_FTZqgp69BR73m53y7j3xCSqvIpJN9MBWmkP-vg2KQj4MxRjJZZBay72aWAT2yhqe2FrSpjDbVivd1xYLaWbSDZ2IlYm735lcOWJUILq8tspEv_9zLkEya9ITHue2uD9r4iDae-tBU76gGy4DH0KiEUOYdjmAIbFA2roEJb94yAVXYDi5zK_cL0H1m0lVm7c50j4Eg8Zxd8nd44zmFvJ_MrqnomYpUKXEVsSe3F5mBCyN0byVdmGHtVAqQsP0ceechaV99TGPe3rElFbEtpqEcdoI30Zh1M9aPzVtdExJ5XeWbnGAoiCfgLSWZNNG9Q-9gJV68mhC03zQGIQOri4rIRu--US77p74rqQv9oSW6ih3qXhKRiUZLGt0zWLzMtB1p4-HZRcBV8PP0tuQl4Oty4k0GkLZd8i_RTITOy17jXadWwirumaGSdIbtMr0pUUHjgXQWD2XiMjFAPqLVHDdTIZBYFylQ09cYT4DZBrak1WtS8hZBY6gyZvHrDs4WvSkAp0IlkY7wu2Y-5TpHgTrsW6UYaFWlTbHi4bvR2CSj4BHPljzQqCwe15hTDPDleEYNXau18pPHJSDNoV-1DXlongng9TTeCzpWjoqDDPgJdqVV7GEWzPxVxsnLwjfByhHCQOS1_lKkrYVUy7tXlsxwTilphblqMhnt2rb8ttQQxCD1YeBB3cuZz8EtyHeUHn_bp0zkzu2jVm73iJVQaAAKKMBywXtaEHaR2kOsQCgIOlawIRJqMI4k4CHd7Z78sS27V9rQlRqdp4dY9EnhmuATm5XBaxudk2Se4JOKJ1H05NxSz9OssuyOqoPB6PQ-ryzybE4U6HpgGTli91Z4hBQDOyFN4s6GtT7YHnpZ-TYPKskCsIHPV4ROPuUNb1zog4i2HBpryFzhCeJCejPbXv_KyJhWT7S2vQRmu8vo_Km95b1bYyyGlT0anC0wSJTJQ45oI20b7pPKkGRZAvGEd69GTKczgQB1mQand3XN8VL7YO-iJnUGLXmrp8ZCXgDD64j3rAN03r6yg1H2zGf0LmxbNgQYarwa6x8g_dePNjHopehRlUKJMDB9w4kRA2_5ayMpJJVMWnvqaPdEKxVwR2rBkgIMNJeB2YgjYK3d8pbap_tpNcy09nR1E_0BqdHvbyKVRYiHvogXwmbEw7Rf6IMfifKnPkgc-SjZbrotHiponsmkdQ0cjK5gxluC3g55d9kNgFvKzP2AkKsg8a3OH0apt2hBRtxwiqn3Z_I-qkJ3U8yFRjmgAiY0GaVDf4ScAIYYQxKoF86l8XOTw5TO5KYmjs3PS3va4A-cNBCw7ow46fC01Huf1rqgDUrlmE2fOEKIuLYueo_Lw6-mUNz81X_m9AExMDb9wWnX519HN_fhPq_201kXZHDPjVAE_hN37HCRtw4Ahck_9FYLRDXVF9NcUJGfGvLmsmemScIa8h7gxCyAh9HLRnfJzaoLfZFqA-UWVMF5-XAJWQ5ZENsb8JYF7YZrTb5lxgTwko0Ye8757eaTgaHndPxm4aR5C-tZ9oMU8UNWdNKKk2CP48M13vHdnHpmU8axzSZJUXisEyaSprNe8R1Ivj_0-uDEqNwiLGaPtq9efgmfVZPASOFb27GAMmc205Y2ak2aWDFtxMGVqvExxJSNTiKoEpkLvAQcy1cpREarCX7HKUW75kRj3CXhwUJqlcpV45_-4O7-wWv1wdaB5axcNxhPDrBa6NDN-XK-pOYdf4hkp7ItvN4MNo-2rh4Kt90kcDKyBur1Uo1zZaT59VsQbK-DS7I9QrBDvYFXZzpmT6DozEHc3bUl1aV3YuHymqjtxCUuRgkqgUeit52p5j8rJFBW4vBXSa9vWaAB67HaJhpkkAUefoSgaQb8CAWrsL-PvXPoHJeNOm9WEGUq3SAAZVY8EQBuH4m7dW6MkagbNexO-xVmDb_bQaTFcbq0dgopoUAcPBN4nMMBT64xhLqE50UYMIB8o4hrCCNW-nonHhv0--z9SpAL27XivtA68UXGhtJPlOFxmq1Un2iBXxq8YQlmKgpdrKgaAvMowjxunKhO9SRZruvHQ4GBs6nQ3-V1X_q22QqxFbR5-vfj5XgftK16NPC3puoxA63qM4wEHblIM5QxVYLYbpCtSbLstiGzEpZTGuqXjo1E7ybDeV_Is7W48xIvdYLjg89g9qEQt-zKiQiXKQSjF26zzHsFAViLnkRIKOUqFCDAGJTjZDoJhILILLHrrddTKc8fEAkEBEUB08WxcIuLgZyVI5pQPP6GurZybFRqSyfKF7RbP7esGneILPwc33Epqi-KdCvzQY19VAbOm096CPDjQ1uwZCTLHpgLVQDXMkNMr0toNH5WKp6k7gOE2W261tUMprAaRij5KVBi9TMvfp_nLGI9pMZLMKr_KeBCtDFnBV5vKIKk10VPUj4HEPkUTWgnzOETqNrtUyk9WnmgctlpNAHlmHKg_Zi8va6nPu6R5A0p02lmH1qll6wQY-t-1d1xSWEcDIPDPEv3wLzUDe3V2wM2AuqNXl5whXY5IxGy8QZA7V9WctevEgKKukX67LNFlmrbHaBcFkKZAlfa0ypzcjvQcxobE_RA0VlZjAV7Z9gQOg4nUD4BCDUewUWhdWXCGxvbfQKV4LpgxwnzKVQAuZCnRdTzdBA4NUGegzprq-n2CFBuLWSWdTH8CwkvyqWWgW5rUjMrt0mZhoeyMmmicOJGsr3Y69B6iouXsJB_hjj1yM90WADFTS-46X3sgOavAaSXJqlXdZ-m0GDUtbS_7_sTjtiBIjDo_oDkpmALwbUWk6zCGaUaPRzurVbxZv6RTkCPnx2_CiqYXy4Qvg9T8_J3-P-xSO7TZpm4IMnYqkbzD9PexjWIE6EqEEo2trTXg9gU2Xz_6WeR5n7JR-oeFzZ93tGnKDUjxhc5QhERT7EieMlZqJ3F5Sr_gnEU0pVxOSTWp5wcw21_S0SVZLG8t_Z_D6j_aT8TYXwM3V2GTY6wOF3wndsnN1nja16AIQINGp4sk6WAUdco_0gE4CatbmdPEIxYWNfZRKjxUQba1H_PYzM5kzqHEJXs9K6Wgg3OgKYDoT9ZuPzrKRKutXibTt5pg_1OR9wki8Mmipe2NFtSc0rScCrwrRxtRsoXvJ17cby5ht0e3928Yen3bgBrRP1gOY8fNCRycGbwtqxr80IT0bAEUTNOiqL0EKK85RkxAZy8y9f1uxfdt-LP7zQ-sExjsd7a6gRLqCD4ihgKhP1zF37RatASr7XRuogBonTVKs4cbNSdvixW_NQtmnLV3U97iIn84H1oywFySemx7Dq055QFdey-TXUujOXMJFKl2bbnuuqh-Z3n_vPv8moUtv5sq3d1BlICDYvTEjGb-D275-F-QsW6EpTKnXdtuhtCqWWFy7QgU1BphttZIVe1UIkJTZEUqvsYDZ_FsuFLRIqetJ41a5-rLVmmK5hfGyplMrbQBP0TVhlv2lj-7Yg2DRvsU"),
}
local _e0={1}
local _fccd={} for i=1,#_e0 do _fccd[i]=_2d[_e0[i]] end
local _9f,_23b=_593a(_39(table.concat(_fccd)))
if _23b~=972146137 then error(string.char(53,48,48,48),0) end
local _07
pcall(function() if type(getfenv)=="function" then _07=getfenv(1) end end)
if type(_07)~="table" then pcall(function() _07=_ENV end) end
if type(_07)~="table" then _07=_G end
local _281a,_2bec,_60=_qq(_9f)
local _b7=_fp(_281a,_07)
return _b7
end)()
end)()
if type(_14bbec) ~= "table" or type(_14bbec[1]) ~= "function" or type(_14bbec[2]) ~= "function" then
  _dad32b(string.char(80,114,111,116,101,99,116,105,111,110,32,117,110,97,118,97,105,108,97,98,108,101))
  return
end
local _10a77f={}
for i=0,255 do _10a77f[i]=string.char(i) end
local _ad493a,_1943cf={},{}
do
  local ta="3046f513682f556b757decaa51d7c422c7acf7ff584f2526c5871fc0608b179188fcb3a5efb0df340d014d826e78d953e76600208c45e365f83b2756a30203a916c88081e88dd80c23fe521589fa6fdc71c1e99d67c37c1c0aa86d09c95af9a1fb97a0ed3a215b6c3d0f40a6bd62ba8a7a2bce64964857471139295435ae5f3863507bf324d59fbe1237bfe41469778fe5de2dcb5db9591b9831f476bbaf08e2e60e199472f193ca702c611d5eee9592b6990b8479a2851e4a5c044efd05b1dbb53632f0cdcc10d3339e28d29cea412adde03f8e6a3cb24bd473901a9bbcebd0abd67fcff63ef2a7b74974d17ec62e4cb49a86da068343a4ad44c24218e1b807"
  local tb="20c6a6decb7cd1d7ae5873667637b975b133a11a1bedf46efbea77e3658a7a02ef0e173c9c9ad4fc784263f9b4cf59c39305510f7f50e8d6e5f39ea034c98cf009f13f944cac4108be3d2b22b6aaf810e6dfb0608b04af455eab29d51e830d9f008e0169f674b75d52f7d8e48d6fc40abd535b793b9b39972721dc2ec7d9c27be01d616c2648bb31f2c80b4e56a3383e07183a1fc5852319c1b37e36572aca401655c035bc2cfd807067a59824964dba95e1fa4728894b868746152dcdff30ee130391925f126aeb6da4cc11ced3da06714ae9847d62b54f1ca754fe72db0c8290e2f5881432eca8a2685a4964b2438125ad6b99b8e72fddbf8fa95c449dd0d2"
  for i=1,256 do
    _ad493a[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _1943cf[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _186981={}
do
  local a="eLcgwjtbSfuXolDdxha8k9CWQyJO34K6" .. "NUP0BE2sMp-m7vY_1nZ5zTVGRAriFqIH"
  for i=1,#a do _186981[string.byte(a,i)]=i-1 end
end
local function _2a5756(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_186981[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_10a77f[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _182dd6(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _cf122b(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _71dffb(S)
  local sa,pa=1254448573,104
  local sb,pb=288011434,153
  local MA,AA,LA=68731,-1526819371,7691076
  local MB,AB,LB=1042055,1371046255,13833858
  local KA={116,152,94,248,20,202,222,191,114,91,104,29,141,78,65,181,101,95,137,174,189,145,87,176,27,113,130,160,185,86,149,83}
  local KB={250,64,197,16,146,200,201,38,200,2,145,72,82,24,81,24,84,76,80,218,131,188,109,80,224,73,2,42,69,31,67,199}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_1943cf[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_ad493a[mid]-ksa)%256
    n=n+1
    out[n]=_10a77f[p]
  end
  return table.concat(out)
end
local _d2005c
do
  local np = _70de48
  local base = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,53,53,100,100,101,50,98,97,50,56,100,100,53,54,46,108,117,97,63,112,97,99)..string.char(107,61,49,38,112,97,114,116,61)) .. "@@PARTNUM@@" .. string.char(38,100,116,111,107,61) .. _a85669
  local single = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,53,53,100,100,101,50,98,97,50,56,100,100,53,54,46,108,117,97,63,115,105,110)..string.char(103,108,101,61,49,38,100,116,111,107,61)) .. _a85669
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _182dd6(hx)
    local body = string.sub(res, 9)
    if (_cf122b(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function fetchAll()
    if _fbe05d == nil then return nil, string.char(110,111,32,108,111,97,100,101,114) end
    local res, err = _86809a(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_cf122b(body) % 4294967296) ~= _182dd6(_265116) then
      return nil, string.char(112,97,121,108,111,97,100,32,104,97,115,104)
    end
    return { body }
  end
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _86809a(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then _dad32b(string.char(68,101,108,105,118,101,114,121,32,114,101,106,101,99,116,101,100)) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i)
      break
    end
    got[i] = body
  end
  if missing == nil then
    _d2005c = got
  else
    local all, why = fetchAll()
    if all == nil then
      _dad32b(string.char(68,111,119,110,108,111,97,100,32,102,97,105,108,101,100,32,112,97,114,116,32) .. missing)
      return
    end
    _d2005c = all
  end
end
local ok, plain, why = (function()
  local sh = _d2005c
  if type(sh) ~= "table" then return false, nil, string.char(110,111,32,112,97,121,108,111,97,100) end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _d2005c = nil
  if #joined == 0 then return false, nil, string.char(101,109,112,116,121,32,112,97,121,108,111,97,100) end
  local expect = _182dd6(_265116)
  if expect ~= nil and (_cf122b(joined) % 4294967296) ~= expect then
    return false, nil, string.char(112,97,121,108,111,97,100,32,99,104,101,99,107,115,117,109,32,109,105,115,109,97,116,99,104)
  end
  local raw = _2a5756(joined)
  joined = nil
  local out = (_71dffb)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, string.char(100,101,99,114,121,112,116,32,102,97,105,108,101,100) end
  local ph = _182dd6(_17e357)
  if ph ~= nil and (_cf122b(out) % 4294967296) ~= ph then
    return false, nil, string.char(105,110,116,101,103,114,105,116,121,32,109,105,115,109,97,116,99,104)
  end
  return true, out, nil
end)()
if not ok then
  _dad32b(string.char(80,97,121,108,111,97,100,32,101,114,114,111,114,58,32) .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = string.char(53,53,100,100,101,50,98,97,50,56,100,100,53,54), scriptId = string.char(53,53,100,100,101,50,98,97,50,56,100,100,53,54), t = 0}
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
local fn, cerr = _14bbec[1](_fbe05d, plain)
plain = nil
if type(fn) ~= "function" then
  warn(string.char(91,75,105,110,103,109,111,114,93,32,99,111,109,112,105,108,101,58,32) .. tostring(cerr))
  _dad32b(string.char(83,99,114,105,112,116,32,99,111,109,112,105,108,101,32,101,114,114,111,114))
  return
end
local rok, runErr = _14bbec[2](fn, false)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(string.char(91,75,105,110,103,109,111,114,93,32,114,117,110,116,105,109,101,58,32) .. tostring(runErr)) end
