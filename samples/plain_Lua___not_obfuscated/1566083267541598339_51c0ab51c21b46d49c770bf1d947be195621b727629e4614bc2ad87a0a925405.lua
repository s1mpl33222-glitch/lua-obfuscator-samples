-- HV_CLIENT_BEGIN
local hvHashRaw,hvVerify

local hvReleases={["hv-runtime-6"]=true,["hv-runtime-7"]=true,["hv-runtime-8"]=true,["hv-runtime-9"]=true,["hv-runtime-10"]=true,["hv-runtime-11"]=true,["hv-runtime-12"]=true,["hv-runtime-13"]=true,["hv-runtime-14"]=true}
local hvExpected={artifactId="75332d1ab6f8f51d334c26525969fd98a5c89ea99ecaa121ecca0ca6cc478b4f",payloadFormat="legacy-json",runnerHash="f1730afbe2a025906b58ef906566887e4df6d28546c370514f79e49cbb5c87ea",payloadHash="38d80ce74927b654b15998daf1a0b1e53771237082a79919d51d5df6897c3334",proofHash="4f53cda18c2baa0c0354bb5f9a3ecbe5ed12ab4d8e11ba873c2f11161202b945",runnerBytes=25773,payloadBytes=482687,proofBytes=2,proofCount=0,sessionId="1216b1c4-79da-47ab-8661-f0cda10186f5",keyId="e1b57f276e179e11c7924da3b7aa63ae198a91d662540297abc11c87d8664a5b"}
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
  return type(loadstring)=="function" and type(pcall)=="function" and type(type)=="function"
    and type(pairs)=="function" and type(ipairs)=="function" and type(tonumber)=="function"
    and type(bit32)=="table" and type(bit32.band)=="function" and type(bit32.bxor)=="function"
    and type(bit32.bnot)=="function" and type(bit32.rrotate)=="function" and type(bit32.rshift)=="function"
    and type(table)=="table" and type(table.concat)=="function" and type(table.unpack)=="function" and type(table.pack)=="function"
    and type(string)=="table" and type(string.byte)=="function" and type(string.char)=="function"
    and type(string.rep)=="function" and type(string.sub)=="function" and type(string.gsub)=="function" and type(string.format)=="function"
    and type(math)=="table" and type(math.floor)=="function" and type(os)=="table" and type(os.time)=="function"
end
local function hvInitializeCrypto()
  if hvHashRaw then return true end
  local hash=(function()
local B=bit32
local band,bxor,bnot,rr,rs=B.band,B.bxor,B.bnot,B.rrotate,B.rshift
local floor,byte,char,rep,sub,concat=math.floor,string.byte,string.char,string.rep,string.sub,table.concat
 local k={1116352408,1899447441,3049323471,3921009573,961987163,1508970993,2453635748,2870763221,3624381080,310598401,607225278,1426881987,1925078388,2162078206,2614888103,3248222580,3835390401,4022224774,264347078,604807628,770255983,1249150122,1555081692,1996064986,2554220882,2821834349,2952996808,3210313671,3336571891,3584528711,113926993,338241895,666307205,773529912,1294757372,1396182291,1695183700,1986661051,2177026350,2456956037,2730485921,2820302411,3259730800,3345764771,3516065817,3600352804,4094571909,275423344,430227734,506948616,659060556,883997877,958139571,1322822218,1537002063,1747873779,1955562222,2024104815,2227730452,2361852424,2428436474,2756734187,3204031479,3329325298}
 local function be(v) return char(floor(v/16777216)%256,floor(v/65536)%256,floor(v/256)%256,v%256) end
return function(m)
 local h={1779033703,3144134277,1013904242,2773480762,1359893119,2600822924,528734635,1541459225}
 local bits=#m*8
 local full=#m-#m%64
 local tail=sub(m,full+1)..char(128)..rep(char(0),(55-#m)%64)..be(floor(bits/4294967296))..be(bits%4294967296)
 local w={}
 for offset=0,full+#tail-1,64 do
  local source,start=m,offset+1
  if offset>=full then source=tail;start=offset-full+1 end
  for i=0,15 do local a,b,c,d=byte(source,start+i*4,start+i*4+3);w[i+1]=((a*256+b)*256+c)*256+d end
  for i=17,64 do local x,y=w[i-15],w[i-2];w[i]=(w[i-16]+bxor(rr(x,7),rr(x,18),rs(x,3))+w[i-7]+bxor(rr(y,17),rr(y,19),rs(y,10)))%4294967296 end
  local a,b,c,d,e,f,g,v=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
  for i=1,64 do
   local t1=(v+bxor(rr(e,6),rr(e,11),rr(e,25))+bxor(band(e,f),band(bnot(e),g))+k[i]+w[i])%4294967296
   local t2=(bxor(rr(a,2),rr(a,13),rr(a,22))+bxor(band(a,b),band(a,c),band(b,c)))%4294967296
   v,g,f,e,d,c,b,a=g,f,e,(d+t1)%4294967296,c,b,a,(t1+t2)%4294967296
  end
  h[1]=(h[1]+a)%4294967296;h[2]=(h[2]+b)%4294967296
  h[3]=(h[3]+c)%4294967296;h[4]=(h[4]+d)%4294967296
  h[5]=(h[5]+e)%4294967296;h[6]=(h[6]+f)%4294967296
  h[7]=(h[7]+g)%4294967296;h[8]=(h[8]+v)%4294967296
 end
 local out={};for i=1,8 do out[i]=be(h[i]) end;return concat(out)
end
end)()
  -- Known-answer validation checks required semantics, not function identities.
  -- Transparent wrappers remain compatible; this is not an authorization rule.
  local known=(hash("abc"):gsub(".",function(c) return string.format("%02x",string.byte(c)) end))
  if known~="ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad" then return false end
  hvHashRaw=hash
  hvVerify=(function()
local sha=hvHashRaw
local floor,byte,char,rep,concat,kind=math.floor,string.byte,string.char,string.rep,table.concat,type
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
return function(message,signature)
if kind(message)~="string" or kind(signature)~="string" or #signature~=384 then return false end
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
local expected=char(0,1)..rep(char(255),330)..char(0)..digestInfo..sha(message)
return concat(out)==expected
end
end)()
  return true
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
local function hvValidateRuntimePacket(response,selectedExpected)
  local hvExpected=selectedExpected or hvExpected
  if not hvEnvironment() then return nil,"Incompatible runtime environment" end
  local responseBudget=6*(hvExpected.runnerBytes+hvExpected.payloadBytes+hvExpected.proofBytes)+4096
  if responseBudget>100663296 then responseBudget=100663296 end
  if type(response)~="string" or #response<2 or #response>responseBudget then return nil,"Runtime response exceeds budget" end
  if not hvInitializeCrypto() then return nil,"Incompatible runtime environment" end
  local http=game:GetService("HttpService")
  local decoded,packet=pcall(http.JSONDecode,http,response)
  if not decoded or not hvExact(packet,{version=true,release=true,artifactId=true,payloadFormat=true,sessionId=true,executionId=true,issuedAt=true,expiresAt=true,runner=true,payload=true,attestations=true},11) then return nil,"Invalid runtime packet schema" end
  if packet.version~=3 or packet.release~="hv-delivery-3" or packet.artifactId~=hvExpected.artifactId or packet.payloadFormat~=hvExpected.payloadFormat or packet.sessionId~=hvExpected.sessionId then return nil,"Runtime build or session mismatch" end
  if type(packet.executionId)~="string" or #packet.executionId~=36 or not packet.executionId:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then return nil,"Invalid execution identifier" end
  local now=os.time()
  if not hvInteger(packet.issuedAt) or not hvInteger(packet.expiresAt) or packet.issuedAt>now+30 or packet.issuedAt<now-90 or packet.expiresAt<=now or packet.expiresAt>now+90 or packet.expiresAt-packet.issuedAt~=60 then return nil,"Runtime packet expired" end
  if type(packet.runner)~="string" or #packet.runner~=hvExpected.runnerBytes or #packet.runner>4194304
    or type(packet.payload)~="string" or #packet.payload~=hvExpected.payloadBytes or #packet.payload>50331648
    or type(packet.attestations)~="string" or #packet.attestations~=hvExpected.proofBytes or #packet.attestations>131072 then return nil,"Invalid runtime field size" end
  if hvHash(packet.runner)~=hvExpected.runnerHash or hvHash(packet.payload)~=hvExpected.payloadHash or hvHash(packet.attestations)~=hvExpected.proofHash then return nil,"Runtime component integrity failed" end
  local proofsOk,proofs=pcall(http.JSONDecode,http,packet.attestations)
  if not proofsOk or type(proofs)~="table" or #proofs~=hvExpected.proofCount or #proofs>50 then return nil,"Invalid runtime attestation list" end
  local proofCount=0;for key in pairs(proofs) do if not hvInteger(key) or key<1 or key>#proofs then return nil,"Invalid runtime attestation list" end;proofCount+=1 end
  if proofCount~=#proofs then return nil,"Invalid runtime attestation list" end
  for _,proof in ipairs(proofs) do
    if not hvExact(proof,{version=true,protocol=true,release=true,keyId=true,message=true,signature=true},6) or proof.version~=1 or proof.protocol~=3 or not hvReleases[proof.release] or proof.keyId~=hvExpected.keyId
      or type(proof.message)~="string" or #proof.message>2048 or type(proof.signature)~="string" or #proof.signature~=768 or not proof.signature:match("^[a-f0-9]+$") or not hvVerify then return nil,"Invalid build attestation" end
    local signature=proof.signature:gsub("..",function(pair) return string.char(tonumber(pair,16)) end)
    if not hvVerify("HiddenVaults/RuntimeBuild/1"..string.char(0)..proof.message,signature) then return nil,"Runtime build signature failed" end
  end
  local dataOk,data=true,nil
  if packet.payloadFormat=="c2" then data={version=2,blob=packet.payload} else dataOk,data=pcall(http.JSONDecode,http,packet.payload) end
  if not dataOk or not hvData(data,0) then return nil,"Invalid protected program data" end
  if packet.expiresAt<=os.time() then return nil,"Runtime packet expired during verification" end
  local runner=packet.runner
  packet.runner=nil;packet.payload=nil;packet.attestations=nil
  return {runner=runner,data=data}
end
local function hvInitializeRuntime(validated)
  local ok,fn=pcall(loadstring,"local __hv_payload,__hv_verify_container=...\nreturn (function(...)\n"..validated.runner.."\nend)()","@HiddenVaults")
  validated.runner=nil
  if not ok or type(fn)~="function" then return nil,"Protected runtime compilation failed" end
  return fn
end
local function hvExecuteRuntime(response,selectedExpected)
  local validationOk,validated,reason=pcall(hvValidateRuntimePacket,response,selectedExpected)
  response=nil
  if not validationOk then return false,"Protected runtime validation failed" end
  if not validated then return false,reason end
  local fn,compileError=hvInitializeRuntime(validated)
  if not fn then return false,compileError end
  local data=validated.data;validated.data=nil;validated=nil
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

local HttpService = game:GetService("HttpService")
local HWID = game:GetService("RbxAnalyticsService"):GetClientId()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
-- You did not crack the loader. This is client UI scaffolding, not the protected script source.
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
local function createHiddenVaultsLoader()
  local loader = {}
  function loader:show() end
  function loader:setProgress() end
  function loader:complete() end
  function loader:fail() end
  function loader:dismiss() end
  return loader
end

local COPY_KEY_URL = "key url has not been setup"
local DISCORD_URL = "https://discord.gg/nVvc9PcZ7P"
local USE_NEW_KEY_SYSTEM = true
local FADE_IN_TIME = 0.45
local FADE_OUT_TIME = 0.38
local isSubmitting = false

local function tween(object, time, properties)
  local animation = TweenService:Create(
    object,
    TweenInfo.new(time, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
    properties
  )
  animation:Play()
  return animation
end

local function copyToClipboard(value)
  if setclipboard then
    setclipboard(value)
    return true
  end
  if toclipboard then
    toclipboard(value)
    return true
  end
  return false
end

local function isAccessServerMessage(message)
  return type(message) == "string" and (
    message:match("^%-%-%s*Load failed") or message:match("^%-%-%s*HiddenVaults")
  )
end

local function requestProtectedRuntime(key)
  local url = "https://hiddenvaults.org/api/key-access/51c0ab51c21b46d49c770bf1d947be195621b727629e4614bc2ad87a0a925405?delivery=3&binding=transport&key=" .. HttpService:UrlEncode(key)
    .. "&stage=1793454355.1216b1c4-79da-47ab-8661-f0cda10186f5.b43f942e2a25db2fe74a3bc4f018020c0f7f4490490b4a3467b44ac8e184fe0d"
    .. "&hwid=" .. HttpService:UrlEncode(HWID)
    .. "&username=" .. HttpService:UrlEncode(LocalPlayer.Name)
    .. "&executor=" .. HttpService:UrlEncode((function() local identify=identifyexecutor or getexecutorname; if type(identify)~="function" then return "Unknown" end; local ok,name=pcall(identify); if ok and type(name)=="string" then return name:sub(1,80) end; return "Unknown" end)())
      .. "&userId=" .. HttpService:UrlEncode(tostring(LocalPlayer.UserId))
    .. "&placeId=" .. HttpService:UrlEncode(tostring(game.PlaceId))
    .. "&gameId=" .. HttpService:UrlEncode(tostring(game.GameId))
    .. "&timestamp=" .. HttpService:UrlEncode(tostring(os.time()))
    .. "&nonce=" .. HttpService:UrlEncode(HttpService:GenerateGUID(false))
  return hvRuntimeRequest(url)
end

local function runHeadlessKeySystem()
  local environment = nil
  local environmentOk = pcall(function()
    environment = getgenv()
  end)
  local key = environmentOk and type(environment) == "table" and environment.HiddenVaultsKEY or nil
  if type(key) ~= "string" or key:gsub("^%s+", ""):gsub("%s+$", "") == "" then
    warn("[HiddenVaults]: [   ERROR   ] - Set getgenv().HiddenVaultsKEY before running this loader")
    return
  end
  key = key:gsub("^%s+", ""):gsub("%s+$", "")

  local loader = createHiddenVaultsLoader()
  loader:setProgress(22, "Loading...")
  local ok, response = pcall(function()
    return requestProtectedRuntime(key)
  end)
  if not ok then
    loader:fail("Could not reach server.")
    loader:dismiss(1.4)
    warn("[HiddenVaults]: [   ERROR   ] - Could not reach the key server")
    return
  end
  if isAccessServerMessage(response) then
    loader:fail("Access denied.")
    loader:dismiss(1.2)
    warn("[HiddenVaults]: [   ERROR   ] - Key, device, or Discord membership validation failed")
    return
  end

  loader:setProgress(78, "Executing...")
  local execOk, execErr = hvExecuteRuntime(response)
  response = nil
  if not execOk then
    warn("[HiddenVaults]: [   ERROR   ] - Runtime execution failed")
    if execErr then warn(tostring(execErr)) end
    return
  end
  loader:setProgress(100, "Finalizing...")
  loader:complete("Successfully loaded..")
  loader:dismiss(0.9)
end

if USE_NEW_KEY_SYSTEM then
  runHeadlessKeySystem()
  return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "HiddenVaultsKeyPrompt"
screenGui.IgnoreGuiInset = true
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

local blur = Instance.new("BlurEffect")
blur.Name = "HiddenVaultsBlur"
blur.Size = 0
blur.Parent = Lighting

local dim = Instance.new("Frame")
dim.Size = UDim2.fromScale(1, 1)
dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
dim.BackgroundTransparency = 1
dim.BorderSizePixel = 0
dim.Parent = screenGui

local main = Instance.new("Frame")
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.fromScale(0.5, 0.52)
main.Size = UDim2.fromOffset(760, 420)
main.BackgroundColor3 = Color3.fromRGB(3, 3, 5)
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Parent = screenGui

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(55, 55, 68)
mainStroke.Thickness = 1
mainStroke.Transparency = 1
mainStroke.Parent = main

local left = Instance.new("Frame")
left.Size = UDim2.fromScale(0.48, 1)
left.BackgroundColor3 = Color3.fromRGB(7, 7, 10)
left.BackgroundTransparency = 1
left.BorderSizePixel = 0
left.Parent = main

Instance.new("UICorner", left).CornerRadius = UDim.new(0, 14)

local leftGradient = Instance.new("UIGradient")
leftGradient.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(36, 36, 42)),
  ColorSequenceKeypoint.new(0.42, Color3.fromRGB(11, 11, 15)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
leftGradient.Rotation = 28
leftGradient.Parent = left

local shadowGradient = Instance.new("Frame")
shadowGradient.Size = UDim2.fromScale(1, 1)
shadowGradient.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
shadowGradient.BackgroundTransparency = 1
shadowGradient.BorderSizePixel = 0
shadowGradient.Parent = left

local radial = Instance.new("UIGradient")
radial.Color = ColorSequence.new({
  ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 70, 80)),
  ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
radial.Transparency = NumberSequence.new({
  NumberSequenceKeypoint.new(0, 0.78),
  NumberSequenceKeypoint.new(1, 1)
})
radial.Rotation = -35
radial.Parent = shadowGradient

local hvGlow = Instance.new("TextLabel")
hvGlow.AnchorPoint = Vector2.new(0.5, 0.5)
hvGlow.Position = UDim2.fromScale(0.5, 0.5)
hvGlow.Size = UDim2.fromOffset(330, 190)
hvGlow.BackgroundTransparency = 1
hvGlow.Text = "HV"
hvGlow.Font = Enum.Font.GothamBlack
hvGlow.TextSize = 140
hvGlow.TextColor3 = Color3.fromRGB(255, 255, 255)
hvGlow.TextTransparency = 1
hvGlow.Parent = left

local hvText = hvGlow:Clone()
hvText.TextSize = 122
hvText.TextTransparency = 1
hvText.Parent = left

local hvStroke = Instance.new("UIStroke")
hvStroke.Color = Color3.fromRGB(255, 255, 255)
hvStroke.Thickness = 2
hvStroke.Transparency = 1
hvStroke.Parent = hvText

local divider = Instance.new("Frame")
divider.Position = UDim2.fromScale(0.48, 0.2)
divider.Size = UDim2.new(0, 1, 0.6, 0)
divider.BackgroundColor3 = Color3.fromRGB(85, 85, 95)
divider.BackgroundTransparency = 1
divider.BorderSizePixel = 0
divider.Parent = main

local right = Instance.new("Frame")
right.Position = UDim2.fromScale(0.52, 0)
right.Size = UDim2.fromScale(0.45, 1)
right.BackgroundTransparency = 1
right.Parent = main

local topButtons = Instance.new("Frame")
topButtons.AnchorPoint = Vector2.new(1, 0)
topButtons.Position = UDim2.new(1, -32, 0, 18)
topButtons.Size = UDim2.fromOffset(230, 28)
topButtons.BackgroundTransparency = 1
topButtons.Parent = main

local list = Instance.new("UIListLayout")
list.FillDirection = Enum.FillDirection.Horizontal
list.HorizontalAlignment = Enum.HorizontalAlignment.Right
list.Padding = UDim.new(0, 8)
list.Parent = topButtons

local fadeObjects = {}

local function addFadeObject(object, property, visibleValue, hiddenValue)
  table.insert(fadeObjects, {
    Object = object,
    Property = property,
    Visible = visibleValue,
    Hidden = hiddenValue,
  })
end

local function createTopButton(text)
  local topButton = Instance.new("TextButton")
  topButton.Size = UDim2.fromOffset(108, 28)
  topButton.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
  topButton.BackgroundTransparency = 1
  topButton.TextColor3 = Color3.fromRGB(140, 140, 155)
  topButton.TextTransparency = 1
  topButton.Text = text
  topButton.Font = Enum.Font.GothamMedium
  topButton.TextSize = 11
  topButton.AutoButtonColor = false
  topButton.BorderSizePixel = 0
  topButton.Parent = topButtons

  Instance.new("UICorner", topButton).CornerRadius = UDim.new(0, 6)

  local stroke = Instance.new("UIStroke")
  stroke.Color = Color3.fromRGB(50, 50, 62)
  stroke.Transparency = 1
  stroke.Parent = topButton

  addFadeObject(topButton, "BackgroundTransparency", 0, 1)
  addFadeObject(topButton, "TextTransparency", 0, 1)
  addFadeObject(stroke, "Transparency", 0.35, 1)

  topButton.MouseEnter:Connect(function()
    tween(topButton, 0.18, {
      BackgroundColor3 = Color3.fromRGB(24, 24, 32),
      TextColor3 = Color3.fromRGB(230, 230, 240),
    })
  end)

  topButton.MouseLeave:Connect(function()
    tween(topButton, 0.18, {
      BackgroundColor3 = Color3.fromRGB(16, 16, 22),
      TextColor3 = Color3.fromRGB(140, 140, 155),
    })
  end)

  return topButton
end

local copyButton = createTopButton("↗ Copy Key URL")
local discordButton = createTopButton("Join Discord")

local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(0, 95)
title.Size = UDim2.fromOffset(320, 36)
title.BackgroundTransparency = 1
title.Text = "Aftermath 1"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextTransparency = 1
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextTruncate = Enum.TextTruncate.AtEnd
title.Parent = right

local underline = Instance.new("Frame")
underline.Position = UDim2.fromOffset(0, 132)
underline.Size = UDim2.fromOffset(88, 2)
underline.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
underline.BackgroundTransparency = 1
underline.BorderSizePixel = 0
underline.Parent = right

local subtitle = Instance.new("TextLabel")
subtitle.Position = UDim2.fromOffset(0, 150)
subtitle.Size = UDim2.fromOffset(338, 20)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Enter your access key"
subtitle.TextColor3 = Color3.fromRGB(95, 95, 110)
subtitle.TextTransparency = 1
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 12
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = right

local input = Instance.new("TextBox")
input.Position = UDim2.fromOffset(0, 190)
input.Size = UDim2.fromOffset(338, 44)
input.BackgroundColor3 = Color3.fromRGB(12, 12, 17)
input.BackgroundTransparency = 1
input.PlaceholderText = "paste key here..."
input.PlaceholderColor3 = Color3.fromRGB(65, 65, 78)
input.TextColor3 = Color3.fromRGB(235, 235, 245)
input.TextTransparency = 1
input.Text = ""
input.Font = Enum.Font.GothamMedium
input.TextSize = 13
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
input.BorderSizePixel = 0
input.Parent = right

Instance.new("UICorner", input).CornerRadius = UDim.new(0, 8)

local inputPadding = Instance.new("UIPadding")
inputPadding.PaddingLeft = UDim.new(0, 14)
inputPadding.PaddingRight = UDim.new(0, 14)
inputPadding.Parent = input

local inputStroke = Instance.new("UIStroke")
inputStroke.Color = Color3.fromRGB(38, 38, 50)
inputStroke.Thickness = 1
inputStroke.Transparency = 1
inputStroke.Parent = input

local continueButton = Instance.new("TextButton")
continueButton.Position = UDim2.fromOffset(0, 265)
continueButton.Size = UDim2.fromOffset(338, 46)
continueButton.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
continueButton.BackgroundTransparency = 1
continueButton.Text = "Continue"
continueButton.TextColor3 = Color3.fromRGB(255, 255, 255)
continueButton.TextTransparency = 1
continueButton.Font = Enum.Font.GothamBold
continueButton.TextSize = 13
continueButton.AutoButtonColor = false
continueButton.BorderSizePixel = 0
continueButton.Parent = right

Instance.new("UICorner", continueButton).CornerRadius = UDim.new(0, 8)

local continueStroke = Instance.new("UIStroke")
continueStroke.Color = Color3.fromRGB(45, 45, 58)
continueStroke.Thickness = 1
continueStroke.Transparency = 1
continueStroke.Parent = continueButton

local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(0, 322)
status.Size = UDim2.fromOffset(338, 34)
status.BackgroundTransparency = 1
status.Text = "You must join and remain in the configured Discord server to get and keep access to this script. Use the Join Discord button, then retrieve your personal key from the Discord panel."
status.TextColor3 = Color3.fromRGB(95, 95, 110)
status.TextTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextWrapped = true
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextYAlignment = Enum.TextYAlignment.Top
status.Parent = right

addFadeObject(main, "BackgroundTransparency", 0, 1)
addFadeObject(mainStroke, "Transparency", 0.35, 1)
addFadeObject(left, "BackgroundTransparency", 0, 1)
addFadeObject(hvGlow, "TextTransparency", 0.72, 1)
addFadeObject(hvText, "TextTransparency", 0, 1)
addFadeObject(hvStroke, "Transparency", 0.15, 1)
addFadeObject(divider, "BackgroundTransparency", 0.5, 1)
addFadeObject(title, "TextTransparency", 0, 1)
addFadeObject(underline, "BackgroundTransparency", 0, 1)
addFadeObject(subtitle, "TextTransparency", 0, 1)
addFadeObject(input, "BackgroundTransparency", 0, 1)
addFadeObject(input, "TextTransparency", 0, 1)
addFadeObject(inputStroke, "Transparency", 0, 1)
addFadeObject(continueButton, "BackgroundTransparency", 0, 1)
addFadeObject(continueButton, "TextTransparency", 0, 1)
addFadeObject(continueStroke, "Transparency", 0, 1)
addFadeObject(status, "TextTransparency", 0, 1)

local function fadeIn()
  main.Position = UDim2.fromScale(0.5, 0.54)
  tween(blur, FADE_IN_TIME, { Size = 14 })
  tween(dim, FADE_IN_TIME, { BackgroundTransparency = 0.35 })
  tween(main, FADE_IN_TIME, { Position = UDim2.fromScale(0.5, 0.5) })

  for _, item in ipairs(fadeObjects) do
    tween(item.Object, FADE_IN_TIME, {
      [item.Property] = item.Visible,
    })
  end
end

local function fadeOut(callback)
  tween(blur, FADE_OUT_TIME, { Size = 0 })
  tween(dim, FADE_OUT_TIME, { BackgroundTransparency = 1 })
  tween(main, FADE_OUT_TIME, { Position = UDim2.fromScale(0.5, 0.53) })

  for _, item in ipairs(fadeObjects) do
    tween(item.Object, FADE_OUT_TIME, {
      [item.Property] = item.Hidden,
    })
  end

  task.delay(FADE_OUT_TIME + 0.05, function()
    if blur then
      blur:Destroy()
    end
    if screenGui then
      screenGui:Destroy()
    end
    if callback then
      callback()
    end
  end)
end

continueButton.MouseEnter:Connect(function()
  tween(continueButton, 0.18, {
    BackgroundColor3 = Color3.fromRGB(25, 25, 34),
  })
end)

continueButton.MouseLeave:Connect(function()
  tween(continueButton, 0.18, {
    BackgroundColor3 = Color3.fromRGB(16, 16, 22),
  })
end)

copyButton.MouseButton1Click:Connect(function()
  if copyToClipboard(COPY_KEY_URL) then
    status.TextColor3 = Color3.fromRGB(140, 140, 155)
    status.Text = "Key URL copied to clipboard."
  else
    status.TextColor3 = Color3.fromRGB(180, 70, 70)
    status.Text = "Clipboard copy is not supported here."
  end
end)

discordButton.MouseButton1Click:Connect(function()
  if DISCORD_URL == "" then
    status.TextColor3 = Color3.fromRGB(180, 140, 70)
    status.Text = "No Discord invite has been configured for this script."
  elseif copyToClipboard(DISCORD_URL) then
    status.TextColor3 = Color3.fromRGB(140, 140, 155)
    status.Text = "Discord invite copied to clipboard."
  else
    status.TextColor3 = Color3.fromRGB(180, 70, 70)
    status.Text = "Clipboard copy is not supported here."
  end
end)

local function isServerMessage(message)
  return message:match("^%-%-%s*Load failed") or message:match("^%-%-%s*HiddenVaults")
end

local function submit()
  if isSubmitting then
    return
  end

  local key = input.Text:gsub("^%s+", ""):gsub("%s+$", "")
  if key == "" then
    input.PlaceholderText = "please enter a key..."
    inputStroke.Color = Color3.fromRGB(180, 70, 70)
    status.TextColor3 = Color3.fromRGB(180, 70, 70)
    status.Text = "Enter a valid key first."
    return
  end

  isSubmitting = true
  continueButton.Text = "Checking..."
  status.TextColor3 = Color3.fromRGB(140, 140, 155)
  status.Text = "Checking your key..."

  local loader = createHiddenVaultsLoader()
  loader:setProgress(22, "Loading...")

  local ok, response = pcall(function()
    local url = "https://hiddenvaults.org/api/key-access/51c0ab51c21b46d49c770bf1d947be195621b727629e4614bc2ad87a0a925405?delivery=3&binding=transport&key=" .. HttpService:UrlEncode(key)
      .. "&stage=1793454355.1216b1c4-79da-47ab-8661-f0cda10186f5.b43f942e2a25db2fe74a3bc4f018020c0f7f4490490b4a3467b44ac8e184fe0d"
      .. "&hwid=" .. HttpService:UrlEncode(HWID)
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
    isSubmitting = false
    loader:fail("Could not reach server.")
    loader:dismiss(1.4)
    continueButton.Text = "Continue"
    status.TextColor3 = Color3.fromRGB(180, 70, 70)
    status.Text = "Could not reach the key server."
    return
  end

  if isServerMessage(response) then
    isSubmitting = false
    loader:fail("Load failed.")
    loader:dismiss(1.2)
    continueButton.Text = "Continue"
    status.TextColor3 = Color3.fromRGB(180, 70, 70)
    status.Text = response:gsub("^%-%-%s*", "")
    return
  end

  fadeOut(function()
    loader:setProgress(78, "Executing...")
    local execOk, execErr = hvExecuteRuntime(response)
    response = nil
    if not execOk then
      isSubmitting = false
      continueButton.Text = "Continue"
      status.TextColor3 = Color3.fromRGB(180, 70, 70)
      status.Text = "Script failed to run."
      warn("[HiddenVaults]: [   ERROR   ] - Runtime execution failed")
      if execErr then
        warn(tostring(execErr))
      end
      return
    end

    loader:setProgress(100, "Finalizing...")
    loader:complete("Successfully loaded..")
    loader:dismiss(0.9)
  end)
end

continueButton.MouseButton1Click:Connect(submit)
input.FocusLost:Connect(function(enterPressed)
  if enterPressed then
    submit()
  end
end)

task.spawn(function()
  while screenGui.Parent do
    tween(hvGlow, 1.4, {
      TextTransparency = 0.62,
      TextSize = 150,
    })
    task.wait(1.4)
    tween(hvGlow, 1.4, {
      TextTransparency = 0.78,
      TextSize = 140,
    })
    task.wait(1.4)
  end
end)

fadeIn()
