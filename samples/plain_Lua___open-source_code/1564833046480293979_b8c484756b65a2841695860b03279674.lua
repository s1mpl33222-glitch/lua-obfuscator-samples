-- LuaGate v3 [1/4]
local g,p,t,s=game,pcall,type,string
local DBG=getgenv and getgenv().LG_DEBUG
local function log(...) if DBG then print("[LG]",...) end end
local function crash()
p(function() g:GetService("Players").LocalPlayer:Kick("[LuaGate] Ambiente adulterado.") end)
error("",0)
end
local function W(f,n)
if t(f)~="function" then log("sem funcao",n) return end
if debug and debug.info then local o,i=p(debug.info,f,"s") if o and i~="[C]" then log("nao e C",n,i) end end
if islclosure and islclosure(f) then log("islclosure",n) end
end
W(p,"pcall") W(t,"type") W(tostring,"tostring") W(tonumber,"tonumber") W(s.char,"char") W(s.sub,"sub") W(table.concat,"concat")
local ish=isfunctionhooked or ishooked or is_function_hooked
local M={loadstring,request,http_request,syn and syn.request,http and http.request}
if ish then for i=1,5 do if t(M[i])=="function" then local o,h=p(ish,M[i]) log("isfunctionhooked",i,o,h) end end end
if isnewcclosure then log("isnewcclosure(loadstring)",p(isnewcclosure,loadstring)) end
local B=0
if listfiles and t(listfiles)=="function" then
local function snap() local o,r=p(listfiles,"") local m={} if o and t(r)=="table" then for _,v in pairs(r) do m[v]=true end end return m,o end
local a,ok=snap()
if ok then
p(loadstring,"--LG"..tostring(os.clock()))
local b=snap()
for k in pairs(b) do if not a[k] then B=1 log("loadstring grava arquivo",k) if delfile then p(delfile,k) end end end
end
else log("listfiles indisponivel") end
log("B=",B)
if B>0 and not DBG then crash() end
local restore=restorefunction or restoreclosure or restorefunc
if restore then for i=1,5 do if t(M[i])=="function" then p(restore,M[i]) end end end
local o,r=p(function() return g:HttpGet("https://webproxy.squareweb.app/s2/6da3f11672103b9a0ea3f519?c="..(6866*7+B)) end)
if not o or t(r)~="string" then return warn("[LuaGate] falha de rede") end
local f,e=loadstring(r)
if not f then return warn("[LuaGate] "..tostring(e)) end
return f(...)