-- Este arquivo foi gerado Por Pato Obf v1 https://discord.gg/REHcV8Ca9v
return (function(...) local _OlI0OlI0={153,36,51,246,221,152,23,138};local _lI0OlI0O={116,67,198,109,232,39,90,241,156,75,46};local _lI0OlI0O={56,55,42,129,236,91,254,69,224};local _0OlI0OlI={250,17,60,107,206,213,48,207,226,217,100,115,54}; local _P={"\x66kF\x50ju\x48iF\x46Pc\x6dfY\x64kz\x73jc\x50pa\x6dto\x31E1\x49yc\x4cYK\x72iL\x46/H\x692E\x33gc\x6ebY\x550h\x57V0\x6bbG\x44K9\x69/T\x52uz\x418W\x41Q=\x3d","\x6fgx\x46rg\x47w0\x48IZ\x6aGB\x4bqF\x38cG\x35rF\x38bO\x4abO\x5agk\x51=="}
local _K={{164,179,118,93,24,151,10,225,204,187,222,165,192,31,242,169,244,195,70,237,104,167,218,113,28,203,174,53,16,47,194,57,68,211,22,125,184,183,170,1,108,219,126,197,96,63,146,201,148},{230,13,8,199,122,145,188,235,78,85,176,79,98,89,228,243,182,157,88,215,74,33,12,251,30,229,0,95,50,233,52,3,134,45,168,231,26,177,92,11,238,117,80},{2,121,132,19,86,189,248,247,234,65,172,27,190,5,160,127,210,9,212,35,38,77,72,7,186,209,252,43,142,149,240,143,162,153,36,51,246,221,152,23,138,97,76,59,94,37,64,159,114,41,116,67,198,109,232,39,90,241,156,75,46,181,144},{66,185,196,83,150,253,56,55,42,129,236,91,254,69,224,191,18,73,20,99,102,141,136,71,250,17,60,107,206,213,48,207,226,217,100,115,54,29,216},{202,161,140,123,158,101,128,223,178,105,180,131,6,173,40,103,154,49,220,139,110,245,208,239,130,249,4,147,214,61,120,119,106,193,44,155,62,133,32},{82,137,84,163,166,205,200,135,58,81,124,171,14,21,112,15,34,25,164,179,118,93,24,151,10,225,204,187,222,165,192,31,242,169,244,195,70,237,104,167,218,113,28,203,174,53,16,47,194,57,68,211,22,125,184,183,170,1,108,219,126,197,96},{146,201,148,227,230,13,8,199,122,145,188,235,78,85,176,79,98,89,228,243,182,157,88,215,74,33,12,251,30,229,0,95,50,233,52,3,134,45,168},{26,177,92,11,238,117,80,111,2,121,132,19,86,189,248,247,234,65,172,27,190,5,160,127,210,9,212,35,38,77,72}}
local _L=8
local _bit=bit32 or bit or (function() local ok,b=pcall(require,"bit") if ok then return b end end)()
local _bxor
if _bit and _bit.bxor then
  _bxor=_bit.bxor
else
  _bxor=function(a,b)
    local r,p=0,1
    for i=0,7 do
      local aa=a%2; local bb=b%2
      if aa~=bb then r=r+p end
      a=(a-aa)/2; b=(b-bb)/2; p=p*2
    end
    return r
  end
end
local _alpha="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local _map={}
for i=1,#_alpha do _map[string.sub(_alpha,i,i)]=i-1 end
local function _b64dec(s)
  local out={}
  local n=#s
  local i=1
  while i<=n do
    local c1=_map[string.sub(s,i,i)] or 0
    local c2=_map[string.sub(s,i+1,i+1)] or 0
    local ch3=string.sub(s,i+2,i+2)
    local ch4=string.sub(s,i+3,i+3)
    local c3=_map[ch3]
    local c4=_map[ch4]
    local b1=c1*4 + math.floor(c2/16)
    out[#out+1]=string.char(b1)
    if c3 then
      local b2=(c2%16)*16 + math.floor(c3/4)
      out[#out+1]=string.char(b2)
      if c4 then
        local b3=(c3%4)*64 + c4
        out[#out+1]=string.char(b3)
      end
    end
    i=i+4
  end
  return table.concat(out)
end
local _buf={}
for i=1,#_P do _buf[i]=_b64dec(_P[i]) end
local _data=table.concat(_buf)
local _bytes={}
for i=1,#_data do _bytes[i]=string.byte(_data,i) end
for l=_L,1,-1 do
  local k=_K[l]
  local kl=#k
  for i=1,#_bytes do
    _bytes[i]=_bxor(_bytes[i], k[((i-1)%kl)+1])
  end
end
local _chars={}
for i=1,#_bytes do _chars[i]=string.char(_bytes[i]) end
local _src=table.concat(_chars)
local _load=loadstring or load
local _fn,_err=_load(_src)
if not _fn then error(_err) end
return _fn(...) end)(...)
