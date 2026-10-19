-- HV_CLIENT_BEGIN
local hvHashRaw=function(m)
local B=bit32
local band,bxor,bnot,rr,rs=B.band,B.bxor,B.bnot,B.rrotate,B.rshift
local floor,byte,char,sub,concat=math.floor,string.byte,string.char,string.sub,table.concat
local function sha(m)
 local k={1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298}
 local h={1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225}
 local function be(v) return char(floor(v/16777216)%256,floor(v/65536)%256,floor(v/256)%256,v%256) end
 local bits=#m*8
 m=m..char(128)..string.rep(char(0),(55-#m)%64)..be(floor(bits/4294967296))..be(bits%4294967296)
 local w={}
 for start=1,#m,64 do
  for i=0,15 do local a,b,c,d=byte(m,start+i*4,start+i*4+3);w[i+1]=((a*256+b)*256+c)*256+d end
  for i=17,64 do local x,y=w[i-15],w[i-2];w[i]=(w[i-16]+bxor(rr(x,7),rr(x,18),rs(x,3))+w[i-7]+bxor(rr(y,17),rr(y,19),rs(y,10)))%4294967296 end
  local a,b,c,d,e,f,g,v=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
  for i=1,64 do
   local t1=(v+bxor(rr(e,6),rr(e,11),rr(e,25))+bxor(band(e,f),band(bnot(e),g))+k[i]+w[i])%4294967296
   local t2=(bxor(rr(a,2),rr(a,13),rr(a,22))+bxor(band(a,b),band(a,c),band(b,c)))%4294967296
   v,g,f,e,d,c,b,a=g,f,e,(d+t1)%4294967296,c,b,a,(t1+t2)%4294967296
  end
  local x={a,b,c,d,e,f,g,v};for i=1,8 do h[i]=(h[i]+x[i])%4294967296 end
 end
 local out={};for i=1,8 do out[i]=be(h[i]) end;return concat(out)
end
return sha(m)
end
local hvVerify=function(message,signature)
local sha=function(m)
local B=bit32
local band,bxor,bnot,rr,rs=B.band,B.bxor,B.bnot,B.rrotate,B.rshift
local floor,byte,char,sub,concat=math.floor,string.byte,string.char,string.sub,table.concat
local function sha(m)
 local k={1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298}
 local h={1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225}
 local function be(v) return char(floor(v/16777216)%256,floor(v/65536)%256,floor(v/256)%256,v%256) end
 local bits=#m*8
 m=m..char(128)..string.rep(char(0),(55-#m)%64)..be(floor(bits/4294967296))..be(bits%4294967296)
 local w={}
 for start=1,#m,64 do
  for i=0,15 do local a,b,c,d=byte(m,start+i*4,start+i*4+3);w[i+1]=((a*256+b)*256+c)*256+d end
  for i=17,64 do local x,y=w[i-15],w[i-2];w[i]=(w[i-16]+bxor(rr(x,7),rr(x,18),rs(x,3))+w[i-7]+bxor(rr(y,17),rr(y,19),rs(y,10)))%4294967296 end
  local a,b,c,d,e,f,g,v=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
  for i=1,64 do
   local t1=(v+bxor(rr(e,6),rr(e,11),rr(e,25))+bxor(band(e,f),band(bnot(e),g))+k[i]+w[i])%4294967296
   local t2=(bxor(rr(a,2),rr(a,13),rr(a,22))+bxor(band(a,b),band(a,c),band(b,c)))%4294967296
   v,g,f,e,d,c,b,a=g,f,e,(d+t1)%4294967296,c,b,a,(t1+t2)%4294967296
  end
  local x={a,b,c,d,e,f,g,v};for i=1,8 do h[i]=(h[i]+x[i])%4294967296 end
 end
 local out={};for i=1,8 do out[i]=be(h[i]) end;return concat(out)
end
return sha(m)
end
local floor,byte,char,concat=math.floor,string.byte,string.char,table.concat
if type(message)~="string" or type(signature)~="string" or #signature~=384 then return false end
local n={26875.0,40007.0,62009.0,2170.0,64328.0,2254.0,7963.0,27609.0,22939.0,933.0,9057.0,20439.0,49002.0,9154.0,34955.0,60151.0,46054.0,21132.0,37789.0,15234.0,55559.0,47473.0,54014.0,28021.0,34273.0,40757.0,24954.0,46875.0,17622.0,58526.0,21678.0,25156.0,15842.0,22841.0,45675.0,46853.0,38119.0,24850.0,11401.0,30298.0,27900.0,37434.0,39318.0,23955.0,51877.0,15366.0,5528.0,34496.0,19521.0,60342.0,64660.0,40154.0,48864.0,57726.0,1770.0,62941.0,12442.0,18869.0,64035.0,56883.0,9333.0,8363.0,52097.0,55440.0,34601.0,44120.0,24968.0,31007.0,740.0,58681.0,52945.0,40918.0,12699.0,43266.0,27623.0,34027.0,1163.0,26010.0,63267.0,41652.0,52047.0,29218.0,9178.0,2366.0,44339.0,48584.0,15619.0,17724.0,36954.0,51077.0,20958.0,30478.0,52206.0,62725.0,8794.0,54324.0,37864.0,3088.0,3454.0,25673.0,8321.0,17375.0,18963.0,35847.0,50473.0,128.0,39674.0,4293.0,9118.0,17705.0,65005.0,52958.0,38196.0,59792.0,12897.0,33352.0,43067.0,23589.0,24575.0,23418.0,31221.0,40139.0,22450.0,11234.0,53847.0,41343.0,11387.0,41927.0,19915.0,40705.0,60738.0,58105.0,53023.0,31406.0,58867.0,37907.0,931.0,24471.0,2110.0,50709.0,65006.0,28920.0,47951.0,41247.0,20839.0,26753.0,41094.0,30101.0,21111.0,14844.0,24615.0,24188.0,45112.0,42739.0,9333.0,49827.0,45941.0,15446.0,63260.0,57880.0,64790.0,35880.0,24214.0,610.0,54068.0,44631.0,13605.0,55647.0,8492.0,38826.0,36206.0,11284.0,39718.0,51391.0,55944.0,61377.0,11160.0,38380.0,35223.0,65473.0,3276.0,40830.0,56375.0,39910.0,34043.0,9582.0,51045.0,7715.0,38431.0,40957.0,62938.0,40616.0}
local r2={14648.0,19654.0,32482.0,11336.0,42873.0,57568.0,29528.0,13928.0,39355.0,35173.0,63573.0,17469.0,5194.0,24883.0,2006.0,49270.0,21167.0,42146.0,29068.0,56078.0,30431.0,64236.0,11838.0,43726.0,38297.0,50402.0,8705.0,58589.0,47612.0,27669.0,43819.0,11661.0,6054.0,37739.0,41109.0,9483.0,23156.0,21924.0,52982.0,3382.0,15001.0,42026.0,51240.0,10300.0,48070.0,16289.0,33160.0,49470.0,52480.0,29966.0,37406.0,59361.0,1646.0,12196.0,55491.0,56809.0,26085.0,18435.0,44041.0,10174.0,24923.0,52993.0,59075.0,19774.0,20915.0,44388.0,319.0,57370.0,43187.0,26063.0,55817.0,26954.0,34852.0,55124.0,37430.0,56405.0,46275.0,50487.0,12158.0,34689.0,33345.0,26061.0,6262.0,18758.0,56927.0,13496.0,3144.0,39712.0,56813.0,44501.0,24910.0,8361.0,14885.0,59499.0,24352.0,38567.0,52896.0,779.0,26173.0,49823.0,54750.0,10029.0,49509.0,17021.0,12377.0,5623.0,39644.0,57977.0,65480.0,22270.0,61280.0,28747.0,4018.0,47970.0,57594.0,2946.0,2931.0,31430.0,50841.0,56704.0,67.0,60396.0,54185.0,14910.0,2439.0,59425.0,59171.0,55440.0,13222.0,43345.0,52559.0,7866.0,7587.0,20923.0,62369.0,27832.0,38074.0,59302.0,23939.0,18514.0,47264.0,58032.0,17881.0,19385.0,14429.0,5669.0,60272.0,30456.0,27925.0,29324.0,33218.0,36494.0,19922.0,41275.0,43500.0,62893.0,25451.0,14970.0,25800.0,62013.0,502.0,53783.0,33763.0,41913.0,1300.0,5982.0,31274.0,13312.0,40399.0,41788.0,354.0,17107.0,44970.0,19217.0,15758.0,4752.0,32320.0,45420.0,55606.0,37412.0,45871.0,65523.0,62842.0,16696.0,10369.0,45655.0,61522.0,20568.0,49597.0,12146.0,25071.0,23359.0}
local size,radix=192,65536.0
local function cmp(a,b)
 for i=size,1,-1 do if a[i]~=b[i] then return a[i]>b[i] and 1 or -1 end end;return 0
end
local function subtract(a,b)
 local borrow=0
 for i=1,size do local v=a[i]-b[i]-borrow;if v<0 then v=v+radix;borrow=1 else borrow=0 end;a[i]=v end
end
local function mont(a,b)
 local t={};for i=1,size*2+2 do t[i]=0 end
 for i=1,size do
  local carry=0
  for j=1,size do local p=i+j-1;local v=t[p]+a[i]*b[j]+carry;t[p]=v%radix;carry=floor(v/radix) end
  local p=i+size
  while carry>0 do local v=t[p]+carry;t[p]=v%radix;carry=floor(v/radix);p=p+1 end
 end
 for i=1,size do
  local q=(t[i]*40397)%radix
  local carry=0
  for j=1,size do local p=i+j-1;local v=t[p]+q*n[j]+carry;t[p]=v%radix;carry=floor(v/radix) end
  local p=i+size
  while carry>0 do local v=t[p]+carry;t[p]=v%radix;carry=floor(v/radix);p=p+1 end
 end
 local out={};for i=1,size do out[i]=t[size+i] end
 if t[size*2+1]>0 or cmp(out,n)>=0 then subtract(out,n) end
 return out
end
local s={};for i=1,size do local p=384-(i-1)*2;s[i]=byte(signature,p)+byte(signature,p-1)*256.0 end
if cmp(s,n)>=0 then return false end
local base=mont(s,r2)
local result=base
for i=1,16 do result=mont(result,result) end
result=mont(result,base)
local one={};for i=1,size do one[i]=i==1 and 1 or 0 end
result=mont(result,one)
local out={};for i=size,1,-1 do out[#out+1]=char(floor(result[i]/256),result[i]%256) end
local digestInfo=char(48,49,48,13,6,9,96,134,72,1,101,3,4,2,1,5,0,4,32)
local expected=char(0,1)..string.rep(char(255),330)..char(0)..digestInfo..sha(message)
return concat(out)==expected
end
local hvExpected={artifactId="0c62b85ee9f7f0644101fea153b2edb6efa726b492b5181720a2bda57a4f5880",payloadFormat="c2",runnerHash="b46e6cd5433345ac95b697c1dd260b79422af34a837d5c88f021e89131d38806",payloadHash="8118d75146b5037533a66a394fbf7dfd1a9a043899ef1a2c3b34a65a9ceaf9ed",proofHash="4f53cda18c2baa0c0354bb5f9a3ecbe5ed12ab4d8e11ba873c2f11161202b945",runnerBytes=35147,payloadBytes=538360,proofBytes=2,proofCount=0,sessionId="f39ecfab-379b-4ea6-afaa-e4fd4b28d40b",keyId="e1b57f276e179e11c7924da3b7aa63ae198a91d662540297abc11c87d8664a5b"}
local function hvHash(value)
  return (hvHashRaw(value):gsub(".",function(c) return string.format("%02x",string.byte(c)) end))
end
local function hvExact(value,allowed,count)
  if type(value)~="table" then return false end
  local n=0;for k in pairs(value) do if not allowed[k] then return false end;n+=1 end
  return n==count
end
local function hvInteger(value) return type(value)=="number" and value==math.floor(value) end
local function hvEnvironment()
  return type(loadstring)=="function" and type(pcall)=="function" and type(bit32)=="table"
    and type(bit32.bxor)=="function" and type(bit32.rrotate)=="function" and type(table.unpack)=="function"
    and type(table.pack)=="function" and type(os.time)=="function"
end
local function hvData(value,depth)
  if type(value)~="table" or depth>64 then return false end
  if value.version==2 then return hvExact(value,{version=true,blob=true},2) and type(value.blob)=="string" and #value.blob>0 and #value.blob<=50331648 end
  if value.version~=1 then return false end
  if value.items then
    if not hvExact(value,{version=true,items=true},2) or type(value.items)~="table" or #value.items<1 or #value.items>50 then return false end
    for _,item in ipairs(value.items) do if not hvData(item,depth+1) then return false end end;return true
  end
  return type(value.k)=="table" and type(value.c)=="table" and type(value.p)=="table" and #value.c<=4000000 and #value.k<=1000000 and #value.p<=65535
end
local function hvValidateRuntimePacket(response)
  if not hvEnvironment() then return nil,"Incompatible runtime environment" end
  if type(response)~="string" or #response<2 or #response>3445150 then return nil,"Runtime response exceeds budget" end
  local http=game:GetService("HttpService")
  local decoded,packet=pcall(http.JSONDecode,http,response)
  if not decoded or not hvExact(packet,{version=true,release=true,artifactId=true,payloadFormat=true,sessionId=true,executionId=true,issuedAt=true,expiresAt=true,runner=true,payload=true,attestations=true},11) then return nil,"Invalid runtime packet schema" end
  if packet.version~=3 or packet.release~="hv-delivery-3" or packet.artifactId~=hvExpected.artifactId or packet.payloadFormat~=hvExpected.payloadFormat or packet.sessionId~=hvExpected.sessionId then return nil,"Runtime build or session mismatch" end
  if type(packet.executionId)~="string" or #packet.executionId~=36 or not packet.executionId:match("^[a-f0-9%-]+$") then return nil,"Invalid execution identifier" end
  local now=os.time()
  if not hvInteger(packet.issuedAt) or not hvInteger(packet.expiresAt) or packet.issuedAt>now+30 or packet.issuedAt<now-90 or packet.expiresAt<=now or packet.expiresAt>now+90 or packet.expiresAt-packet.issuedAt~=60 then return nil,"Runtime packet expired" end
  if type(packet.runner)~="string" or #packet.runner~=hvExpected.runnerBytes or #packet.runner>4194304
    or type(packet.payload)~="string" or #packet.payload~=hvExpected.payloadBytes or #packet.payload>50331648
    or type(packet.attestations)~="string" or #packet.attestations~=hvExpected.proofBytes or #packet.attestations>131072 then return nil,"Invalid runtime field size" end
  if hvHash(packet.runner)~=hvExpected.runnerHash or hvHash(packet.payload)~=hvExpected.payloadHash or hvHash(packet.attestations)~=hvExpected.proofHash then return nil,"Runtime component integrity failed" end
  local proofsOk,proofs=pcall(http.JSONDecode,http,packet.attestations)
  if not proofsOk or type(proofs)~="table" or #proofs~=hvExpected.proofCount or #proofs>50 then return nil,"Invalid runtime attestation list" end
  for _,proof in ipairs(proofs) do
    if not hvExact(proof,{version=true,protocol=true,release=true,keyId=true,message=true,signature=true},6) or proof.version~=1 or proof.protocol~=3 or (proof.release~="hv-runtime-6" and proof.release~="hv-runtime-7" and proof.release~="hv-runtime-8" and proof.release~="hv-runtime-9" and proof.release~="hv-runtime-10" and proof.release~="hv-runtime-11") or proof.keyId~=hvExpected.keyId
      or type(proof.message)~="string" or #proof.message>2048 or type(proof.signature)~="string" or #proof.signature~=768 or not proof.signature:match("^[a-f0-9]+$") or not hvVerify then return nil,"Invalid build attestation" end
    local signature=proof.signature:gsub("..",function(pair) return string.char(tonumber(pair,16)) end)
    if not hvVerify("HiddenVaults/RuntimeBuild/1"..string.char(0)..proof.message,signature) then return nil,"Runtime build signature failed" end
  end
  local dataOk,data=true,nil
  if packet.payloadFormat=="c2" then data={version=2,blob=packet.payload} else dataOk,data=pcall(http.JSONDecode,http,packet.payload) end
  if not dataOk or not hvData(data,0) then return nil,"Invalid protected program data" end
  if packet.expiresAt<=os.time() then return nil,"Runtime packet expired during verification" end
  packet.payload=nil;packet.attestations=nil
  return {runner=packet.runner,data=data,packet=packet}
end
local function hvInitializeRuntime(validated)
  local ok,fn=pcall(loadstring,"local __hv_payload,__hv_verify_container=...\nreturn (function(...)\n"..validated.runner.."\nend)()","@HiddenVaults")
  validated.runner=nil;validated.packet.runner=nil
  if not ok or type(fn)~="function" then return nil,"Protected runtime compilation failed" end
  return fn
end
local function hvExecuteRuntime(response)
  local validationOk,validated,reason=pcall(hvValidateRuntimePacket,response)
  response=nil
  if not validationOk then return false,"Protected runtime validation failed" end
  if not validated then return false,reason end
  local fn,compileError=hvInitializeRuntime(validated)
  if not fn then return false,compileError end
  local data=validated.data;validated.data=nil;validated.packet=nil
  local ok,result=pcall(fn,data,hvVerify);data=nil;fn=nil
  return ok,result
end
local function hvRuntimeRequest(url)
  if type(url)~="string" or not url:match("^https://") then error("HiddenVaults requires HTTPS",0) end
  local requestFn=request or http_request or (syn and syn.request) or (http and http.request)
  if type(requestFn)~="function" then return game:HttpGet(url) end
  local base,query=url:match("^([^?]+)%?(.*)$")
  if not base or #query>8192 then error("Invalid runtime request",0) end
  local function decode(value) return (value:gsub("%+"," "):gsub("%%(%x%x)",function(hex) return string.char(tonumber(hex,16)) end)) end
  local body={};for name,value in query:gmatch("([^&=]+)=([^&]*)") do body[decode(name)]=decode(value) end
  local result=requestFn({Url=base,Method="POST",Headers={["Content-Type"]="application/json"},Body=game:GetService("HttpService"):JSONEncode(body)})
  if type(result)~="table" or type(result.Body)~="string" then error("Runtime transport failed",0) end
  local status=tonumber(result.StatusCode or result.Status)
  if status~=200 then return "-- Load failed." end
  return result.Body
end
-- HV_CLIENT_END

-- You did not crack the loader. This is GUI creation, not the protected script source.
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")
local CoreGui = game:GetService("CoreGui")
local _hvPlayers = game:GetService("Players")
local _hvMarketplaceService = game:GetService("MarketplaceService")
local _hvLocalPlayer = _hvPlayers.LocalPlayer

local function getHiddenVaultsIdentity()
  local playerName = (_hvLocalPlayer.DisplayName and _hvLocalPlayer.DisplayName ~= "" and _hvLocalPlayer.DisplayName) or _hvLocalPlayer.Name
  local gameName = "Unknown Experience"
  local avatarUrl = ""

  pcall(function()
    local info = _hvMarketplaceService:GetProductInfo(game.PlaceId)
    if info and info.Name then
      gameName = info.Name
    end
  end)

  pcall(function()
    avatarUrl = _hvPlayers:GetUserThumbnailAsync(
      _hvLocalPlayer.UserId,
      Enum.ThumbnailType.HeadShot,
      Enum.ThumbnailSize.Size100x100
    )
  end)

  return avatarUrl, playerName, gameName
end

local function attachHiddenVaultsIdentity(parent, position, size)
  local avatarUrl, playerName, gameName = getHiddenVaultsIdentity()

  local shell = Instance.new("Frame")
  shell.Size = size
  shell.Position = position
  shell.BackgroundColor3 = Color3.fromRGB(18, 20, 33)
  shell.BackgroundTransparency = 0.02
  shell.BorderSizePixel = 0
  shell.Parent = parent

  local shellCorner = Instance.new("UICorner")
  shellCorner.CornerRadius = UDim.new(0, 16)
  shellCorner.Parent = shell

  local shellStroke = Instance.new("UIStroke")
  shellStroke.Color = Color3.fromRGB(88, 93, 126)
  shellStroke.Transparency = 0.62
  shellStroke.Thickness = 1
  shellStroke.Parent = shell

  local avatar = Instance.new("ImageLabel")
  avatar.Size = UDim2.fromOffset(42, 42)
  avatar.Position = UDim2.fromOffset(12, 11)
  avatar.BackgroundColor3 = Color3.fromRGB(44, 47, 72)
  avatar.BorderSizePixel = 0
  avatar.Image = avatarUrl
  avatar.Parent = shell

  local avatarCorner = Instance.new("UICorner")
  avatarCorner.CornerRadius = UDim.new(1, 0)
  avatarCorner.Parent = avatar

  local avatarStroke = Instance.new("UIStroke")
  avatarStroke.Color = Color3.fromRGB(120, 123, 164)
  avatarStroke.Transparency = 0.42
  avatarStroke.Parent = avatar

  local nameLabel = Instance.new("TextLabel")
  nameLabel.BackgroundTransparency = 1
  nameLabel.Size = UDim2.new(1, -66, 0, 20)
  nameLabel.Position = UDim2.fromOffset(62, 11)
  nameLabel.Font = Enum.Font.GothamSemibold
  nameLabel.TextSize = 13
  nameLabel.TextColor3 = Color3.fromRGB(240, 242, 255)
  nameLabel.TextXAlignment = Enum.TextXAlignment.Left
  nameLabel.Text = playerName
  nameLabel.Parent = shell

  local gameLabel = Instance.new("TextLabel")
  gameLabel.BackgroundTransparency = 1
  gameLabel.Size = UDim2.new(1, -66, 0, 18)
  gameLabel.Position = UDim2.fromOffset(62, 31)
  gameLabel.Font = Enum.Font.Gotham
  gameLabel.TextSize = 11
  gameLabel.TextColor3 = Color3.fromRGB(151, 155, 182)
  gameLabel.TextXAlignment = Enum.TextXAlignment.Left
  gameLabel.TextTruncate = Enum.TextTruncate.AtEnd
  gameLabel.Text = gameName
  gameLabel.Parent = shell

  return shell
end

local HV_LOADER_SCRIPT_NAME = "v1"
local HV_CONSOLE_DONE_IMAGE = "rbxassetid://84271476582826"
local hvConsoleEnvironment = getgenv and getgenv() or shared or _G
hvConsoleEnvironment.__hiddenVaultsConsoleCounter = (hvConsoleEnvironment.__hiddenVaultsConsoleCounter or 3000) + 1

local function hvCreateConsoleStatus()
  local console = {
    progress = 0,
    label = "Loading client...",
    color = Color3.fromRGB(255, 255, 255),
    image = "",
    startedAt = os.clock(),
    messageIndex = nil,
    connection = nil,
    closed = false,
  }
  local marker = "__HV_CONSOLE_" .. tostring(hvConsoleEnvironment.__hiddenVaultsConsoleCounter)
    .. "_" .. tostring(os.clock())
  print(marker)

  task.spawn(function()
    local deadline = os.clock() + 6
    repeat
      local ok, history = pcall(function()
        return LogService:GetLogHistory()
      end)
      if ok and type(history) == "table" then
        for index, data in ipairs(history) do
          if tostring(data.message) == marker then
            console.messageIndex = index + 1
            return
          end
        end
      end
      task.wait(0.05)
    until console.closed or os.clock() >= deadline
  end)

  local function findConsoleRow()
    if not console.messageIndex then
      return nil
    end
    local ok, row = pcall(function()
      local master = CoreGui:FindFirstChild("DevConsoleMaster")
      local window = master and master:FindFirstChild("DevConsoleWindow")
      local ui = window and window:FindFirstChild("DevConsoleUI")
      local mainView = ui and ui:FindFirstChild("MainView")
      local clientLog = mainView and mainView:FindFirstChild("ClientLog")
      return clientLog and clientLog:FindFirstChild(tostring(console.messageIndex))
    end)
    return ok and row or nil
  end

  local function renderConsoleRow()
    local row = findConsoleRow()
    if not row then
      return
    end
    local messageLabel = row:FindFirstChild("msg", true)
    local imageLabel = row:FindFirstChild("image", true)
    local filled = math.floor((console.progress / 100) * 20)
    local bar = string.rep("#", filled) .. string.rep(" ", 20 - filled)
    local rendered = string.format(
      "[%s]: [%s] (%d%%) - %s",
      HV_LOADER_SCRIPT_NAME,
      bar,
      console.progress,
      console.label
    )
    if messageLabel and messageLabel:IsA("TextLabel") then
      messageLabel.Text = os.date("%H:%M:%S") .. " -- " .. rendered
      messageLabel.TextColor3 = console.color
      messageLabel.TextWrapped = true
    end
    if imageLabel and imageLabel:IsA("ImageLabel") then
      imageLabel.Image = console.image
      imageLabel.ImageColor3 = console.color
    end
  end

  console.connection = RunService.RenderStepped:Connect(function()
    pcall(renderConsoleRow)
  end)

  function console:update(value, label, color, image)
    self.progress = math.clamp(math.floor(tonumber(value) or self.progress), 0, 100)
    if type(label) == "string" and label ~= "" then
      self.label = label
    end
    if typeof(color) == "Color3" then
      self.color = color
    end
    if type(image) == "string" then
      self.image = image
    end
    pcall(renderConsoleRow)
  end

  function console:complete()
    local elapsed = os.clock() - self.startedAt
    self:update(
      100,
      string.format("[ SUCCESS ] Authenticated and loaded in %.3fs", elapsed),
      Color3.fromRGB(51, 255, 85),
      HV_CONSOLE_DONE_IMAGE
    )
  end

  function console:fail(message)
    self:update(
      self.progress,
      "[ ERROR ] " .. (message or "Load failed."),
      Color3.fromRGB(255, 92, 92),
      ""
    )
  end

  function console:cleanup(delayTime)
    task.delay(delayTime or 10, function()
      self.closed = true
      if self.connection then
        self.connection:Disconnect()
        self.connection = nil
      end
    end)
  end

  return console
end

local function hvTween(object, time, properties)
  local animation = TweenService:Create(
    object,
    TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    properties
  )
  animation:Play()
  return animation
end

local function createHiddenVaultsLoader()
  local console = hvCreateConsoleStatus()
  local gui = Instance.new("ScreenGui")
  gui.Name = "HiddenVaultsLoaderStatus"
  gui.ResetOnSpawn = false
  gui.IgnoreGuiInset = true
  gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
  gui.Parent = game:GetService("CoreGui")

  local frame = Instance.new("Frame")
  frame.Size = UDim2.fromOffset(430, 116)
  frame.Position = UDim2.new(1, 460, 1, -26)
  frame.AnchorPoint = Vector2.new(1, 1)
  frame.BackgroundColor3 = Color3.fromRGB(3, 3, 5)
  frame.BorderSizePixel = 0
  frame.ClipsDescendants = true
  frame.Parent = gui

  local frameCorner = Instance.new("UICorner")
  frameCorner.CornerRadius = UDim.new(0, 14)
  frameCorner.Parent = frame

  local frameGradient = Instance.new("UIGradient")
  frameGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 36, 42)),
    ColorSequenceKeypoint.new(0.45, Color3.fromRGB(11, 11, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
  })
  frameGradient.Rotation = 18
  frameGradient.Parent = frame

  local stroke = Instance.new("UIStroke")
  stroke.Thickness = 1
  stroke.Color = Color3.fromRGB(55, 55, 68)
  stroke.Transparency = 0.35
  stroke.Parent = frame

  local glow = Instance.new("TextLabel")
  glow.BackgroundTransparency = 1
  glow.Size = UDim2.fromOffset(128, 96)
  glow.Position = UDim2.fromOffset(10, 10)
  glow.Font = Enum.Font.GothamBlack
  glow.TextSize = 64
  glow.TextColor3 = Color3.fromRGB(255, 255, 255)
  glow.TextTransparency = 0.76
  glow.Text = "HV"
  glow.Parent = frame

  local hv = glow:Clone()
  hv.TextSize = 50
  hv.TextTransparency = 0
  hv.Parent = frame

  local hvStroke = Instance.new("UIStroke")
  hvStroke.Color = Color3.fromRGB(255, 255, 255)
  hvStroke.Thickness = 1.5
  hvStroke.Transparency = 0.22
  hvStroke.Parent = hv

  task.spawn(function()
    while gui.Parent do
      hvTween(glow, 1.25, { TextTransparency = 0.62, TextSize = 72 })
      task.wait(1.25)
      hvTween(glow, 1.25, { TextTransparency = 0.82, TextSize = 64 })
      task.wait(1.25)
    end
  end)

  local divider = Instance.new("Frame")
  divider.Size = UDim2.new(0, 1, 1, -42)
  divider.Position = UDim2.fromOffset(118, 21)
  divider.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
  divider.BackgroundTransparency = 0.5
  divider.BorderSizePixel = 0
  divider.Parent = frame

  local brand = Instance.new("TextLabel")
  brand.BackgroundTransparency = 1
  brand.Size = UDim2.new(1, -154, 0, 16)
  brand.Position = UDim2.fromOffset(138, 18)
  brand.Font = Enum.Font.GothamMedium
  brand.TextSize = 11
  brand.TextColor3 = Color3.fromRGB(140, 140, 155)
  brand.TextXAlignment = Enum.TextXAlignment.Left
  brand.Text = "HiddenVaults Runtime"
  brand.Parent = frame

  local status = Instance.new("TextLabel")
  status.BackgroundTransparency = 1
  status.Size = UDim2.new(1, -204, 0, 28)
  status.Position = UDim2.fromOffset(138, 36)
  status.Font = Enum.Font.GothamBlack
  status.TextSize = 22
  status.TextColor3 = Color3.fromRGB(255, 255, 255)
  status.TextXAlignment = Enum.TextXAlignment.Left
  status.Text = "Loading..."
  status.Parent = frame

  local percent = Instance.new("TextLabel")
  percent.BackgroundTransparency = 1
  percent.Size = UDim2.fromOffset(58, 20)
  percent.Position = UDim2.new(1, -18, 0, 42)
  percent.AnchorPoint = Vector2.new(1, 0)
  percent.Font = Enum.Font.GothamBold
  percent.TextSize = 12
  percent.TextColor3 = Color3.fromRGB(140, 140, 155)
  percent.TextXAlignment = Enum.TextXAlignment.Right
  percent.Text = "0%"
  percent.Parent = frame

  local subtitle = Instance.new("TextLabel")
  subtitle.BackgroundTransparency = 1
  subtitle.Size = UDim2.new(1, -154, 0, 16)
  subtitle.Position = UDim2.fromOffset(138, 64)
  subtitle.Font = Enum.Font.Gotham
  subtitle.TextSize = 12
  subtitle.TextColor3 = Color3.fromRGB(95, 95, 110)
  subtitle.TextXAlignment = Enum.TextXAlignment.Left
  subtitle.Text = "Preparing secure runtime delivery"
  subtitle.Parent = frame

  local track = Instance.new("Frame")
  track.Size = UDim2.new(1, -156, 0, 8)
  track.Position = UDim2.fromOffset(138, 90)
  track.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
  track.BorderSizePixel = 0
  track.Parent = frame

  local trackCorner = Instance.new("UICorner")
  trackCorner.CornerRadius = UDim.new(0, 999)
  trackCorner.Parent = track

  local fill = Instance.new("Frame")
  fill.Size = UDim2.fromScale(0, 1)
  fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
  fill.BorderSizePixel = 0
  fill.Parent = track

  local fillCorner = Instance.new("UICorner")
  fillCorner.CornerRadius = UDim.new(0, 999)
  fillCorner.Parent = fill

  local fillGradient = Instance.new("UIGradient")
  fillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 140, 155))
  })
  fillGradient.Parent = fill

  local loader = {}
  loader.gui = gui

  function loader:show()
    hvTween(frame, 0.42, {
      Position = UDim2.new(1, -26, 1, -26),
    })
  end

  function loader:setProgress(value, label)
    local normalized = math.clamp(value, 0, 100)
    percent.Text = string.format("%d%%", normalized)
    if label then
      status.Text = label
    end
    hvTween(fill, 0.26, {
      Size = UDim2.fromScale(normalized / 100, 1),
    })
    console:update(normalized, label)
  end

  function loader:complete(text)
    status.Text = text or "Successfully loaded.."
    status.TextColor3 = Color3.fromRGB(140, 255, 180)
    percent.Text = "100%"
    hvTween(fill, 0.22, {
      Size = UDim2.fromScale(1, 1),
    })
    console:complete()
  end

  function loader:fail(text)
    status.Text = text or "Load failed."
    status.TextColor3 = Color3.fromRGB(255, 120, 120)
    console:fail(text)
  end

  function loader:dismiss(delayTime)
    console:cleanup((delayTime or 1) + 10)
    task.delay(delayTime or 1, function()
      local tweenOut = TweenService:Create(frame, TweenInfo.new(0.32, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Position = UDim2.new(1, 460, 1, -26),
      })
      tweenOut:Play()
      tweenOut.Completed:Wait()
      gui:Destroy()
    end)
  end

  loader:show()
  return loader
end
local HttpService = game:GetService("HttpService")
local Analytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local loader = createHiddenVaultsLoader()
loader:setProgress(12, "Loading...")

local function isServerMessage(message)
  return message:match("^%-%-%s*Load failed") or message:match("^%-%-%s*HiddenVaults")
end

loader:setProgress(48, "Authenticating...")
local ok, response = pcall(function()
  local url = "https://hiddenvaults.org/api/loader/HbtKhUJge-Ws?direct=1&runtime=1&delivery=3&binding=transport"
    .. "&stage=1792381274.f39ecfab-379b-4ea6-afaa-e4fd4b28d40b.480a0cac6911ed1b5ea189d92f99fa6692c05783b86c5fd64e35fba30fe7902b"
    .. "&hwid=" .. HttpService:UrlEncode(Analytics:GetClientId())
    .. "&username=" .. HttpService:UrlEncode(LocalPlayer.Name)
    .. "&executor=" .. HttpService:UrlEncode((function() local identify=identifyexecutor or getexecutorname; if type(identify)~="function" then return "Unknown" end; local ok,name=pcall(identify); if ok and type(name)=="string" then return name:sub(1,80) end; return "Unknown" end)())
      .. "&userId=" .. HttpService:UrlEncode(tostring(LocalPlayer.UserId))
    .. "&placeId=" .. HttpService:UrlEncode(tostring(game.PlaceId))
    .. "&gameId=" .. HttpService:UrlEncode(tostring(game.GameId))
    .. "&timestamp=" .. HttpService:UrlEncode(tostring(os.time()))
    .. "&nonce=" .. HttpService:UrlEncode(HttpService:GenerateGUID(false))
  return hvRuntimeRequest(url)
end)

if not ok then
  loader:fail("Could not reach server.")
  loader:dismiss(1.4)
  warn("[HiddenVaults]: [   ERROR   ] - Could not reach the HiddenVaults runtime server")
  return
end

if isServerMessage(response) then
  loader:fail("Load failed.")
  loader:dismiss(1.4)
  warn(response:gsub("^%-%-%s*", ""))
  return
end

loader:setProgress(86, "Executing...")
local execOk, execErr = hvExecuteRuntime(response)
response = nil
if not execOk then
  warn("[HiddenVaults]: [   ERROR   ] - Runtime execution failed")
  if execErr then
    warn(tostring(execErr))
  end
  return
end
loader:setProgress(100, "Finalizing...")
loader:complete("Successfully loaded..")
loader:dismiss(0.9)
