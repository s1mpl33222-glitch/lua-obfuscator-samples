_G["CID"]="85fe3b8e8f3a3449ba720cd3" _G["CKB"]="51a6b74442b1c4764916f0f80938e17f0cf8b5a2dcfd0679699dfabb642a7b34" _G["CTK"]="ODVmZTNiOGU4ZjNhMzQ0OWJhNzIwY2QzfDE3OTI4OTQ2NDkwNjk.c211cba2b3cc5c80ac0ac8fbca4160bc2c449574549372fc675c91b2079b9d1e" _G["CKE"]="" _G["CAP"]="https://cipher.c1pher.workers.dev"
local __B=string.byte local __C=string.char local __T=table.concat local __X=bit32 and bit32.bxor
if not __X then return end
local __D=function(s)local t={}for i=1,#s do t[i]=__C(__X(__B(s,i),230))end return __T(t)end
local HS=game:GetService(__D("\xae\x92\x92\x96\xb5\x83\x94\x90\x8f\x85\x83"))
local ID=_G["CID"] local KB=_G["CKB"] local TK=_G["CTK"] local KE=_G["CKE"] or __D("") local API=_G["CAP"]
if not ID or not KB or not TK or not API then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6\x8a\x89\x87\x82\x83\x94\xc6\x83\x94\x94\x89\x94")) return end
local HW=__D("\x93\x88\x8d\x88\x89\x91\x88")
pcall(function() local p=game:GetService(__D("\xb6\x8a\x87\x9f\x83\x94\x95")).LocalPlayer if p then HW=tostring(p.UserId) end end)
if not HS or not HS.RequestAsync then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6\x92\x8e\x8f\x95\xc6\x83\x9e\x83\x85\x93\x92\x89\x94\xc6\x82\x89\x83\x95\xc6\x88\x89\x92\xc6\x95\x93\x96\x96\x89\x94\x92\xc6\xae\xb2\xb2\xb6\xc6\x94\x83\x97\x93\x83\x95\x92\x95")) return end
local ok,res=pcall(function() return HS:RequestAsync({Url=API..__D("\xc9\x87\x96\x8f\xc9\x96\xc9")..ID,Method=__D("\xb6\xa9\xb5\xb2"),Headers={["Content-Type"]=__D("\x87\x96\x96\x8a\x8f\x85\x87\x92\x8f\x89\x88\xc9\x8c\x95\x89\x88")},Body=HS:JSONEncode({t=TK,k=KB,key=KE,hwid=HW})}) end)
if not ok or not res or not res.Success then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6")..tostring((res and res.Body) or __D("\x85\x89\x88\x88\x83\x85\x92\x8f\x89\x88\xc6\x80\x87\x8f\x8a\x83\x82"))) return end
local data
pcall(function() data=HS:JSONDecode(res.Body) end)
if type(data)!=__D("\x92\x87\x84\x8a\x83") or not data.ok then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6")..tostring((type(data)==__D("\x92\x87\x84\x8a\x83") and data.error) or __D("\x8a\x89\x87\x82\xc6\x80\x87\x8f\x8a\x83\x82"))) return end
if type(data.c)!=__D("\x95\x92\x94\x8f\x88\x81") then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6\x82\x83\x85\x89\x82\x83\xc6\x80\x87\x8f\x8a\x83\x82")) return end
local B64=__D("\xa7\xa4\xa5\xa2\xa3\xa0\xa1\xae\xaf\xac\xad\xaa\xab\xa8\xa9\xb6\xb7\xb4\xb5\xb2\xb3\xb0\xb1\xbe\xbf\xbc\x87\x84\x85\x82\x83\x80\x81\x8e\x8f\x8c\x8d\x8a\x8b\x88\x89\x96\x97\x94\x95\x92\x93\x90\x91\x9e\x9f\x9c\xd6\xd7\xd4\xd5\xd2\xd3\xd0\xd1\xde\xdf\xcd\xc9")
local function b64d(sv)
  local map={} for i=1,#B64 do map[B64:sub(i,i)]=i-1 end
  local out={} local buf=0 local bits=0 local n=0
  for i=1,#sv do
    local ch=sv:sub(i,i)
    if ch~=__D("\xdb") then
      local v=map[ch]
      if not v then return nil end
      buf=buf*64+v bits=bits+6
      while bits>=8 do
        bits=bits-8 n=n+1
        out[n]=string.char(math.floor(buf/2^bits)%256)
        buf=buf%2^bits
      end
    end
  end
  return table.concat(out)
end
local ok2,raw=pcall(function() return HS:Base64Decode(data.c) end)
if not ok2 or type(raw)!=__D("\x95\x92\x94\x8f\x88\x81") or #raw==0 then raw=b64d(data.c) end
if type(raw)!=__D("\x95\x92\x94\x8f\x88\x81") or #raw==0 then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6\x82\x83\x85\x89\x82\x83\xc6\x80\x87\x8f\x8a\x83\x82")) return end
local kbn=#KB/2
if kbn<1 then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6\x8a\x89\x87\x82\x83\x94\xc6\x83\x94\x94\x89\x94")) return end
local parts=table.create(#raw)
for i=1,#raw do parts[i]=string.char(bit32.bxor(string.byte(raw,i),tonumber(KB:sub((i-1)%kbn*2+1,(i-1)%kbn*2+2),16))) end
local fn,lerr=loadstring(table.concat(parts))
if not fn then warn(__D("\xbd\xa5\x8f\x96\x8e\x83\x94\xaa\x93\x87\xbb\xc6\x8a\x89\x87\x82\xc6\x83\x94\x94\x89\x94\xdc\xc6")..tostring(lerr)) return end
task.spawn(function() while true do task.wait(60) pcall(function() HS:RequestAsync({Url=API..__D("\xc9\x87\x96\x8f\xc9\x84\x83\x87\x92\xc9")..ID,Method=__D("\xb6\xa9\xb5\xb2"),Headers={["Content-Type"]=__D("\x87\x96\x96\x8a\x8f\x85\x87\x92\x8f\x89\x88\xc9\x8c\x95\x89\x88")},Body=HS:JSONEncode({hwid=HW})}) end) end end)
fn()