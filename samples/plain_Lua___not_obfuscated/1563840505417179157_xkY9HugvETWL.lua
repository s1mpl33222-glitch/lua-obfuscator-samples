-- V0IDLUA loader (ffa)
local KEY=""
local PEPPER="v0idlua-kb1"
local B64="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64dec(s)
  s=string.gsub(s,"[^"..B64.."]","")
  local out,bits,nb={},0,0
  for k=1,#s do
    bits=bits*64+(string.find(B64,string.sub(s,k,k),1,true)-1)
    nb=nb+6
    if nb>=8 then nb=nb-8 out[#out+1]=string.char(math.floor(bits/2^nb)%256) bits=bits%(2^nb) end
  end
  return table.concat(out)
end
local function unwrap(body, HWID)
  local p=string.find(body,":",1,true) if not p then return nil end
  local nonce=string.sub(body,1,p-1)
  local ct=b64dec(string.sub(body,p+1))
  local key=KEY..":"..HWID..":"..nonce..":"..PEPPER
  local S={} for i=0,255 do S[i]=i end
  local j,kl=0,#key
  for i=0,255 do j=(j+S[i]+string.byte(key,(i%kl)+1))%256 S[i],S[j]=S[j],S[i] end
  local a,b=0,0
  for _=1,256 do a=(a+1)%256 b=(b+S[a])%256 S[a],S[b]=S[b],S[a] end
  local out={}
  for k=1,#ct do
    a=(a+1)%256 b=(b+S[a])%256 S[a],S[b]=S[b],S[a]
    out[k]=string.char((string.byte(ct,k)-S[(S[a]+S[b])%256])%256)
  end
  return table.concat(out)
end
local function hwid()
  local ok,v=pcall(function()
    if gethwid then return gethwid() end
    return game:GetService("RbxAnalyticsService"):GetClientId()
  end)
  return (ok and v) and tostring(v) or "nohwid"
end
local HWID=hwid()
local EXE=(identifyexecutor and tostring((identifyexecutor()))) or "unknown"
local USER,UID="",""
pcall(function() local p=game:GetService("Players").LocalPlayer if p then USER=p.Name or "" UID=tostring(p.UserId or "") end end)
local PID="" pcall(function() PID=tostring(game.PlaceId or "") end)
local HS=game:GetService("HttpService")
local payload=HS:JSONEncode({k=KEY,h=HWID,e=EXE,u=USER,r=UID,g=PID})
local req=(syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
local body
for _,u in ipairs({"https://get.v0idlua.com/v/xkY9HugvETWL"}) do
  if req then
    local ok,res=pcall(req,{Url=u,Method="POST",Headers={["Content-Type"]="application/json"},Body=payload})
    if ok and res and res.Body and #res.Body>0 then body=res.Body break end
  else
    local ok,res=pcall(function() return game:HttpGet(u.."?k="..HS:UrlEncode(KEY).."&h="..HS:UrlEncode(HWID).."&e="..HS:UrlEncode(EXE).."&r="..HS:UrlEncode(UID).."&g="..HS:UrlEncode(PID)) end)
    if ok and res and #res>0 then body=res break end
  end
end
if not body then return end
local plain=unwrap(body, HWID)
if not plain or #plain<1 then return end
local chunk=(loadstring or load)(plain)
if chunk then return chunk() end
