-- Do not save this file
-- Always use the loadstring
-- ScripterHub session loader (init layer) | ScripterHub7750718500 | no script material in this file
-- 1. paid scripts only: set your license ONCE before running this:
--      getgenv().ScripterHubKey = "YOUR_LICENSE_KEY"
-- 2. run the loadstring. Free scripts need no key, no account, no email.
_bsdata0={["v"]=1,["id"]="ScripterHub7750718500",["base"]="https://scripterhub-stats.dubovikstanislav51.workers.dev",["cdn"]="https://scripterhub-stats.dubovikstanislav51.workers.dev/sh/v4_init_ScripterHub7750718500.lua",["slot"]="ScripterHub7750718500-ocmid"};
local D=_bsdata0
local ID=D["id"]
do local a=... if type(a)=="string" and a:match("^ScripterHub%d+$") then ID=a end end
local BASE=D["base"]
local CDN=D["cdn"]
local KEYED=false
local G=(getgenv and getgenv()) or _G
local function NT(t,d) pcall(function() game:GetService("StarterGui"):SetCore("SendNotification",{Title="ScripterHub",Text=t,Duration=d or 5}) end) end
local function DIE(t) NT(t,7) print("[ScripterHub] "..t) end
local function DENYMSG(r)
 if r=="hidden" then return "This script is private. Only the author can run it." end
 if r=="gone" then return "Script cannot be loaded, doesnt exist or expired." end
 if r=="storageauth" then return "The script is still stored, but the site cannot reach its storage. The owner needs to check the Storage Keeper is running and that SH_STORE_TOKEN matches it." end
 if r=="toobig" then return "This script is too large to load in one piece and was stored whole. The owner needs to re-upload it so it is split into parts." end
 if r=="invalid" then return "That license key is not valid." end
 if r=="expired" then return "That license has expired." end
 if r=="banned" then return "That license has been banned." end
 if r=="hwid" then return "That license is locked to different hardware." end
 if r=="project" then return "This license is for a different project than this script. Make a key for this project, or bind the key to All projects." end
 if r=="killswitch" then return "The owner has disabled this script." end
 return "Denied: "..r
end
local function E(s) s=tostring(s or "") return (s:gsub("[^%w%-._~]",function(c) return string.format("%%%02X",string.byte(c)) end)) end
local function QS(t) local o={} for k,v in pairs(t) do o[#o+1]=E(k).."="..E(v) end return table.concat(o,"&") end
local function GET(url)
 if request then
  local ok,r=pcall(function() return request({Url=url,Method="GET",Headers={["User-Agent"]="Roblox/570 Delta Executor",["X-SH-Transport"]="header"}}) end)
  if ok and type(r)=="table" and type(r.Body)=="string" and r.Body~="" then return r.Body end
 end
 if game and game.HttpGet then
  local ok,r=pcall(function() return game:HttpGet(url,true) end)
  if ok and type(r)=="string" and r~="" then return r end
 end
 return nil
end
local function CALL(path,q)
 local u=BASE..path..(q and ("?"..q) or "")
 if request then
  local ok,r=pcall(function() return request({Url=u,Method="POST",Headers={["Content-Type"]="application/json",["User-Agent"]="Roblox/570 Delta Executor",["X-SH-Transport"]="header"}}) end)
  if ok and type(r)=="table" and type(r.Body)=="string" and r.Body~="" then return r.Body end
 end
 return GET(u)
end
local K=G and G.ScripterHubKey
local HW=G and G.ScripterHubHwid
if not HW then
 local ok,v=pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
 if ok and type(v)=="string" and v~="" then HW=v end
end
local HW2=(identifyexecutor and (pcall(identifyexecutor) and identifyexecutor())) or ""
if HW==nil or HW=="" then HW=HW2 end
if KEYED and (type(K)~="string" or K=="") then
 DIE("License required: run getgenv().ScripterHubKey = \"YOUR_KEY\" then re-execute.")
 return
end
local resp=CALL("/sh/session",QS({id=ID,k=K or "",h=tostring(HW),h2=tostring(HW2),u=tostring(G.ScripterHubUser or "")}))
if type(resp)~="string" then DIE("Could not reach the license server.") return end
if resp:sub(1,6)=="SHERR " then DIE(DENYMSG(resp:sub(7):gsub("%s+$",""))) return end
local S,N=resp:match("^SHS (%S+) (%S+) %S+")
if not S or not N then DIE("Bad response from the license server.") return end
local body=GET(CDN.."?s="..S.."&n="..N)
local rsn=(type(body)=="string") and body:match("^SHERR (%S+)") or nil
if rsn=="nonce" then
  local r2=CALL("/sh/session",QS({id=ID,k=K or "",h=tostring(HW),u=tostring(G.ScripterHubUser or "")}))
  local S2,N2=nil,nil
  if type(r2)=="string" then S2,N2=r2:match("^SHS (%S+) (%S+) %S+") end
  if S2 and N2 then S,N=S2,N2; body=GET(CDN.."?s="..S.."&n="..N) end
end
if type(body)~="string" then DIE("Delivery failed.") return end
if body:sub(1,6)=="SHERR " then DIE(DENYMSG(body:sub(7):gsub("%s+$",""))) return end
local SK, B
local CH=false
if body:sub(1,4)=="SHL\n" then
  B=body:sub(5)                      -- keyless, no server-only layer
elseif body:sub(1,4)=="SHX\n" then
  local nl=body:find("\n",5)
  if not nl then DIE("Malformed delivery - no key line.") return end
  SK=body:sub(5,nl-1)                -- "t0 chk k1 k2 k3..."
  B=body:sub(nl+1)                   -- plain Lua, NOT ciphertext
elseif body:sub(1,4)=="SHK\n" then
  local nl=body:find("\n",5)
  if not nl then DIE("Malformed delivery - no key line.") return end
  SK=body:sub(5,nl-1)                -- "t0 chk k1 k2 k3..."
  B=body:sub(nl+1)                   -- the ciphertext
elseif body:sub(1,4)=="SHG " then
  CH=true local n,root,g=body:match("^SHG (%d+) (%S+) (%S+)")
  local nl=body:find("\n")
  if not nl then DIE("Malformed chain header.") return end
  local rel=body:sub(nl+1)
  local s2=rel:find("\n")
  if s2 then SK=rel:sub(1,s2-1) end
  if not n or not g then DIE("Bad chain header.") return end
  local P={}
  for i=0,tonumber(n)-1 do
   local u=root.."/"..i.."?g="..g.."&s="..S
   local ok,part=pcall(function() return game:HttpGet(u,true) end)
   if not ok or type(part)~="string" or #part==0 then DIE("Part "..i.." failed.") return end
   P[#P+1]=part
  end
  B=table.concat(P)
else
  DIE("Unrecognised delivery format.") return
end
local function BX(a,b) a=a%4294967296 b=b%4294967296 local r,p=0.0,1.0 for _=1,32 do local x=a%2 local y=b%2 if x~=y then r=r+p end a=(a-x)/2 b=(b-y)/2 p=p*2 end return r end
local function SD(k,i) local h=5381.0+i*7 for j=1,#k do local c=string.byte(k,j) h=(h*33+c)%4294967296 end return h end
local function NX(s) local x=s[1] x=BX(x,(x*8192)%4294967296) x=BX(x,math.floor(x/131072)) x=BX(x,(x*32)%4294967296) s[1]=s[2] s[2]=s[3] s[3]=s[4] s[4]=x return x end
local function DEC(k) local a,b,c,d=SD(k,0),SD(k,1),SD(k,2),SD(k,3)
 if a==0 then a=1 end if b==0 then b=2 end if c==0 then c=3 end if d==0 then d=4 end
 local function _b64dec(s)
  local T="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
  local M={} for i=1,64 do M[T:sub(i,i)]=i-1 end
  s=tostring(s or ""):gsub("[^A-Za-z0-9+/]","")
  local n=#s local o={} local i=1
  while i+3<=n do
   local c=0
   for j=0,3 do local v=M[s:sub(i+j,i+j)] if v then c=c*64+v end end
   o[#o+1]=string.char(math.floor(c/65536),math.floor(c/256)%256,c%256)
   i=i+4
  end
  local rem=n-i+1
  if rem==1 then return nil end
  if rem==2 then
   local c=0
   for j=0,1 do local v=M[s:sub(i+j,i+j)] if v then c=c*64+v end end
   o[#o+1]=string.char(math.floor(c/16)%256)
  elseif rem==3 then
   local c=0
   for j=0,2 do local v=M[s:sub(i+j,i+j)] if v then c=c*64+v end end
   o[#o+1]=string.char(math.floor(c/1024)%256,math.floor(c/4)%256)
  end
  return table.concat(o)
 end
 if type(B)~="string" then return nil end
 local BD=(B:match("^[A-Za-z0-9+/=]+$")) and _b64dec(B) or B
 if #BD==0 then return nil end
 local s={a,b,c,d} local o={} for i=1,#BD do local x=NX(s) o[i]=string.char(BX(string.byte(BD,i),x%256)) end
 local t=table.concat(o) if t:sub(1,4)~="SHOK" then return nil end return t:sub(5) end
local src=B
if KEYED and not CH then
 if type(SK)~="string" or SK=="" then DIE("Missing key material.") return end
 src=DEC(K)
 if not src then DIE("Wrong Special Key, or the delivery was tampered with.") return end
end
local LS=loadstring or load
if type(SK)=="string" and SK~="" then G["__SH_SPLITKEY"]=SK end
local fn,ferr=nil,nil
if LS then fn,ferr=LS(src) end
if not fn then
 local why=tostring(ferr or "loadstring returned no function and no error")
 local size=(type(src)=="string") and #src or -1
 DIE("Load failed: the delivered source is "..size.." bytes and did not compile. "..why)
 return
end
local ran,perr=pcall(fn,ID)
if not ran then DIE("The script itself failed: "..tostring(perr)) end
return true
