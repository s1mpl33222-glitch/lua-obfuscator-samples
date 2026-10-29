--[[ Protected by حماية — فك الحماية غير مسموح ]]
local _Ol101lOIl0="\31\132\184\200\215\191\168\119\196\176\210\70\63\248\61\28\56\25\75\78\178\204\151\210\91\50\203\5\155\122\6\223\19\120\127\5\168\188\179\194\132\226\242\49\102\235\33\62\235\11\91\14\141\81\227\76\204\2\137\102\87\77\237\159\6\71\65\204\32\213\187\169\128\139\99\148\29\210\8\98\12\61\167\110\31\186\102\136\234\89\25\14\181\137\166\17\164\44\219\221\152\166\174\199\200\172\136\191\69\236\173\52\154\23\31\219\181\74\196\189\183\131\40\194\95"
local _I0Il0IO0I0="\181\200\74\162\89\134\89\135\222\72\36\84\203\14\176\140\168\228\122\42\177\231\224\9\50\56\100\167\86\191\144\18\174\154\100\83\89"
local function _OIl0II1O00(_I1lI1OI101,_Ill00lO0I1)
local _OIOII0IlO0,_llOOI011ll=_Ill00lO0I1,{}
for _ll1OO1l1l0=1,#_I1lI1OI101 do
_OIOII0IlO0=(_OIOII0IlO0*16807)%2147483647
_llOOI011ll[_ll1OO1l1l0]=string.char((_I1lI1OI101:byte(_ll1OO1l1l0)-(_OIOII0IlO0%256)-(_ll1OO1l1l0-1))%256)
end
return table.concat(_llOOI011ll)
end
local _l01Ol1Il00=false
pcall(function()
local _OO1OIO0l10=(type(game)=="userdata" or type(game)=="table") and type(getfenv)=="function"
local _lI01011100=type(loadstring)=="function"
if _OO1OIO0l10 and _lI01011100 then
local _IO0IIII10l=debug and debug.getinfo and debug.getinfo(loadstring,"S")
_l01Ol1Il00=(not _IO0IIII10l) or _IO0IIII10l.what=="C"
end
end)
local _ll1OO1l1l0=_l01Ol1Il00 and 215800429 or 1706177156
local _OO1OIO0l10=_l01Ol1Il00 and _Ol101lOIl0 or _I0Il0IO0I0
local _lI01011100=(loadstring or load)(_OIl0II1O00(_OO1OIO0l10,_ll1OO1l1l0))
if _lI01011100 then _lI01011100() end
