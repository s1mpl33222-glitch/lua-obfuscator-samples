local _c4eb8d=213
local _dd49e1=1
local _0b595c={{189,162,163,168,170,224,244,243,175,177,176,141,130,141,145,128,203,130,151,140,135,153,197,131,159,137},{250,183,167,177,246,174,180,183,184,176},{250,183,167,177,246,188,190,168,190,182,224,148,220},{243,190,160,177,189,231},{161,185,188,189,183},{165,183,174,180,182,187,191},{176,164,165,183,171},{166,181,165,177,169,174,146,184},{189,161,190,188},{150,185,185,172,188,180,175,241,137,167,175,133},{180,166,167,180,176,185,186,168,180,177,177,207,139,145,140,138},{135,180,175,153,183,187,183,165,169,183,188,147,178,135,145,146,140,133,130},{146,179,163,155,181,179,190,178,169,151,187},{142,164,184,183,180,185,180,174,185,131,255}}
local function _bc2b48(i)
local t=_0b595c[i+1];local k=_c4eb8d;local o={}
for j=1,#t do
o[j]=string.char(bit32.bxor(t[j],k))
k=bit32.band(k+_dd49e1,0xFF)
if k==0 then k=_dd49e1 end
end
return table.concat(o)
end
local VAULT_BASE=_bc2b48(0)
local SCRIPT_ID="nteVYkD0"
local HWID_SEND=true

local function err(msg)
warn(_bc2b48(13)..tostring(msg))
return nil
end

local b64c="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local b64t={}
for i=1,#b64c do b64t[b64c:sub(i,i)]=i-1 end

local function b64d(s)
s=s:gsub("[^"..b64c.."=]","")
local o={}
for i=1,#s,4 do
local a=b64t[s:sub(i,i)] or 0
local b=b64t[s:sub(i+1,i+1)] or 0
local c=b64t[s:sub(i+2,i+2)] or 0
local d=b64t[s:sub(i+3,i+3)] or 0
local n=bit32.bor(bit32.lshift(a,18),bit32.lshift(b,12),bit32.lshift(c,6),d)
o[#o+1]=string.char(bit32.rshift(bit32.band(n,0xFF0000),16))
if s:sub(i+2,i+2)~="=" then o[#o+1]=string.char(bit32.rshift(bit32.band(n,0x00FF00),8)) end
if s:sub(i+3,i+3)~="=" then o[#o+1]=string.char(bit32.band(n,0x0000FF)) end
end
return table.concat(o)
end

local function xd(data,key)
local o={};local kl=#key
for i=1,#data do
o[i]=string.char(bit32.bxor(string.byte(data,i),string.byte(key,(i-1)%kl+1)))
end
return table.concat(o)
end

local function jg(src,f)
local sv=src:match('"'..f..'"%s*:%s*"([^"]*)"')
if sv then return sv end
local nv=src:match('"'..f..'"%s*:%s*([%d%.]+)')
if nv then return tonumber(nv) end
return nil
end

local function gh()
if type(request)=="function" then return request end
if type(http_request)=="function" then return http_request end
if type(http)=="table" and type(http.request)=="function" then return http.request end
if type(syn)=="table" and type(syn.request)=="function" then return syn.request end
return nil
end

local function hpost(url,body)
local fn=gh()
if not fn then return nil end
local ok,r=pcall(fn,{Url=url,Method="POST",Headers={[_bc2b48(9)]=_bc2b48(10)},Body=body})
if not ok then return nil end
if type(r)=="table" then return r.Body or r.body end
return tostring(r)
end

local function hget(url)
local fn=gh()
if fn then
local ok,r=pcall(fn,{Url=url,Method="GET"})
if ok then
if type(r)=="table" then return r.Body or r.body end
return tostring(r)
end
end
local ok,r=pcall(function() return game:HttpGet(url) end)
if ok then return r end
return nil
end

local function hwid()
local ok,id=pcall(function()
return tostring(game:GetService(_bc2b48(11))[_bc2b48(12)](game:GetService(_bc2b48(11))))
end)
if ok and id and id~="" then return id end
return nil
end

local function main()
local hw=HWID_SEND and hwid() or nil
local tb='{"'.._bc2b48(7)..'":"'..SCRIPT_ID..'"'
if hw then tb=tb..',"'.._bc2b48(8)..'":"'..hw..'"' end
tb=tb.."}"
local tr=hpost(VAULT_BASE.._bc2b48(1),tb)
if not tr then return err("Token request failed") end
local tid=jg(tr,_bc2b48(4))
if not tid or #tid~=32 then
return err("Token invalid: "..(jg(tr,_bc2b48(6)) or tr:sub(1,80)))
end
local fu=VAULT_BASE.._bc2b48(2)..tid
if hw then fu=fu.._bc2b48(3)..hw end
local fr=hget(fu)
if not fr then return err("Fetch failed") end
local ep=jg(fr,_bc2b48(5))
if not ep or ep=="" then
return err("Fetch error: "..(jg(fr,_bc2b48(6)) or fr:sub(1,80)))
end
local dec=b64d(ep)
if not dec or #dec==0 then return err("b64 failed") end
local src=xd(dec,tid)
if not src or #src==0 then return err("xor failed") end
local ch,ce=loadstring(src)
if not ch then return err("loadstring: "..tostring(ce)) end
local ok,re=pcall(ch)
if not ok then return err("runtime: "..tostring(re)) end
end
main()