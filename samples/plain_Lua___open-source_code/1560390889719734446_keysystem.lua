--[[
  Skulx loader v2 — ENCRYPTED PAYLOAD
  !!! OBFUSCATE THIS FILE (MoonSec / PSU) BEFORE DEPLOYING !!!
  Unobfuscated, the embedded key makes the encryption pointless.
]]

local bit32=bit32
local function _u32(n) return string.char(math.floor(n/16777216)%256,math.floor(n/65536)%256,math.floor(n/256)%256,n%256) end
local function _sha256(msg)
  local K={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
  0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
  0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
  0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
  0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
  0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
  0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
  0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
  local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
  local ml=#msg
  msg=msg.."\128"
  msg=msg..string.rep("\0",(56-(#msg%64))%64)
  local bl=(ml*8)%4294967296
  local bh=math.floor((ml*8)/4294967296)
  msg=msg.._u32(bh).._u32(bl)
  local w={}
  for c=1,#msg,64 do
    for i=0,15 do
      local o=c+i*4
      w[i]=bit32.bor(bit32.lshift(msg:byte(o),24),bit32.lshift(msg:byte(o+1),16),bit32.lshift(msg:byte(o+2),8),msg:byte(o+3))
    end
    for i=16,63 do
      local s0=bit32.bxor(bit32.rrotate(w[i-15],7),bit32.rrotate(w[i-15],18),bit32.rshift(w[i-15],3))
      local s1=bit32.bxor(bit32.rrotate(w[i-2],17),bit32.rrotate(w[i-2],19),bit32.rshift(w[i-2],10))
      w[i]=(w[i-16]+s0+w[i-7]+s1)%4294967296
    end
    local a,b,cc,d,e,f,g,hh=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
    for i=0,63 do
      local S1=bit32.bxor(bit32.rrotate(e,6),bit32.rrotate(e,11),bit32.rrotate(e,25))
      local ch=bit32.bxor(bit32.band(e,f),bit32.band(bit32.bnot(e),g))
      local t1=(hh+S1+ch+K[i+1]+w[i])%4294967296
      local S0=bit32.bxor(bit32.rrotate(a,2),bit32.rrotate(a,13),bit32.rrotate(a,22))
      local maj=bit32.bxor(bit32.band(a,b),bit32.band(a,cc),bit32.band(b,cc))
      local t2=(S0+maj)%4294967296
      hh=g g=f f=e e=(d+t1)%4294967296 d=cc cc=b b=a a=(t1+t2)%4294967296
    end
    h[1]=(h[1]+a)%4294967296 h[2]=(h[2]+b)%4294967296 h[3]=(h[3]+cc)%4294967296 h[4]=(h[4]+d)%4294967296
    h[5]=(h[5]+e)%4294967296 h[6]=(h[6]+f)%4294967296 h[7]=(h[7]+g)%4294967296 h[8]=(h[8]+hh)%4294967296
  end
  return _u32(h[1]).._u32(h[2]).._u32(h[3]).._u32(h[4]).._u32(h[5]).._u32(h[6]).._u32(h[7]).._u32(h[8])
end

local _p={
  "https://skulxdeve", "lopment.vercel.app/api/",
  "getscript?name=keysystem&payload=1&token=",
  "eyJzbHVnIjoia2V5c3lzdGVtIiwiZXhwIjoxNzkyMDk2NjI1LCJub", "25jZSI6IjkwMmNhMDQ4YjVhOGQzNzVhYTNmYzQwMWZjZWNjODU0Ii", "wiayI6Ijg5ODhjYWQ2M2U4MzQ3N2RlMTEzYWRlNDg5ZThjZjZmIn0",
  "&sig=", "RAR2tSSD-6DbihF3yrut4", "j6bYYD_Ja3che-CcNGzt8w"
}
local _k="8988cad63e83477de113ade489e8cf6f"
local _u=table.concat(_p)
local _ok,_d=pcall(function() return game:HttpGet(_u) end)
if not _ok then error("Skulx: payload request failed") end
local _pos,_ctr,_out=1,0,{}
while _pos<=#_d do
  local _blk=_sha256(_k..":".."eyJzbHVnIjoia2V5c3lzdGVtIiwiZXhwIjoxNzkyMDk2NjI1LCJub25jZSI6IjkwMmNhMDQ4YjVhOGQzNzVhYTNmYzQwMWZjZWNjODU0IiwiayI6Ijg5ODhjYWQ2M2U4MzQ3N2RlMTEzYWRlNDg5ZThjZjZmIn0"..":".._ctr)
  for i=1,32 do
    if _pos>#_d then break end
    _out[#_out+1]=string.char(bit32.bxor(tonumber(_d:sub(_pos,_pos+1),16),_blk:byte(i)))
    _pos=_pos+2
  end
  _ctr=_ctr+1
end
local _src=table.concat(_out)
local _f,_err=loadstring(_src)
if not _f then error(_err) end
return _f()