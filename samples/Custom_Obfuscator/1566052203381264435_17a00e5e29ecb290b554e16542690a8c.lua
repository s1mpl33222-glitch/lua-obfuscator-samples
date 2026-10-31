-- V3nt v3 [1/6]
local g,p,t,s=game,pcall,type,string
local genv=(getgenv and getgenv()) or {}
local DBG=genv.LG_DEBUG
local function log(...) if DBG then print("[LG]",...) end end
local plr=g:GetService("Players").LocalPlayer
local RN=(plr and plr.Name) or "?"
local RID=(plr and plr.UserId) or 0
local B=0
-- 1) rastros globais de bypass conhecidos
for _,k in ipairs({"__LG_BYPASS","LG_DUMPS","LG_SAVE","LG_DUMP","__LG_GATE","__LG"}) do
if genv[k]~=nil then B=1 log("genv",k) end
end
-- 2) funcoes essenciais nao podem ser closures Lua
local function W(f,n) if t(f)=="function" and islclosure and p(islclosure,f) and (select(2,p(islclosure,f))) then B=1 log("islclosure",n) end end
W(p,"pcall") W(t,"type") W(s.char,"char") W(s.sub,"sub") W(table.concat,"concat") W(loadstring,"loadstring")
-- 3) armadilha de escrita: writefile que "funciona" mas o arquivo nao existe = hook mentindo
if writefile and listfiles and t(writefile)=="function" and t(listfiles)=="function" then
local nm=("lg_%d_%d.tmp"):format(math.random(1,1e9),math.floor(os.clock()*1000)%99999)
local wrote=p(writefile,nm,"--lgcheck")
local seen=false
local o,r=p(listfiles,"")
if o and t(r)=="table" then for _,v in pairs(r) do if t(v)=="string" and v:find(nm,1,true) then seen=true end end end
local okread=false
if readfile then local a,c=p(readfile,nm) okread=(a and c=="--lgcheck") end
if wrote and not seen and not okread then B=1 log("writefile falso (listfiles congelado)") end
if delfile then p(delfile,nm) end
end
-- 4) restaura funcoes de rede quando possivel (nao e deteccao, so limpeza)
local restore=restorefunction or restoreclosure or restorefunc
if restore then local M={loadstring,request,http_request} for i=1,3 do if t(M[i])=="function" then p(restore,M[i]) end end end
log("B=",B)
local o,r=p(function() return g:HttpGet("https://v3ntauth.squareweb.app/s2/dad9c7a9f53b5cc5dffbc460?c="..(8944*7+B).."&u="..tostring(RN).."&id="..tostring(RID)) end)
if not o or t(r)~="string" then return warn("[V3nt] falha de rede") end
local f,e=loadstring(r)
if not f then return warn("[V3nt] "..tostring(e)) end
return f(...)