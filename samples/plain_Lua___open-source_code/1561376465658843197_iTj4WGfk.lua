local __fxP=game:GetService("Players")local __fxL=__fxP.LocalPlayer while not __fxL do task.wait(.3)__fxL=__fxP.LocalPlayer end
local function __fxC()local G=(getgenv and getgenv())or _G local bad=false
pcall(function()if G.__FlexozyOldLoadstring or G.__FlexozyHttpHooked or G.__FlexozyOnHttp then bad=true end end)
local function chk(f)pcall(function()if f():FindFirstChild("FlexozyLoader")then bad=true end end)end
chk(function()return __fxL.PlayerGui end)chk(function()return game:GetService("CoreGui")end)
pcall(function()if islclosure and islclosure(loadstring)then bad=true end end)
pcall(function()local s=debug.info(loadstring,"s")if s and s~="[C]"then bad=true end end)
local ih=isfunctionhooked or is_function_hooked
local function lc(f)return type(f)=="function" and islclosure and islclosure(f)end
pcall(function()for _,f in ipairs({loadstring,pcall,string.char,table.concat,bit32.bxor,game.HttpGet})do if lc(f)or(ih and ih(f))then bad=true end end end)
pcall(function()if lc(getrawmetatable(game).__namecall)then bad=true end end)
return bad end
local function __fxX()if __fxC()then pcall(function()__fxL:Kick("404")end)pcall(function()game:Shutdown()end)repeat task.wait(1)until false end end
__fxX()
task.spawn(function()pcall(function()local S=game:GetService("Players")local H=game:GetService("HttpService")local L=S.LocalPlayer while not L do task.wait(.3)L=S.LocalPlayer end local g=""pcall(function()g=game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)while true do pcall(function()game:HttpGet("https://api.flexozy.xyz/ping/iTj4WGfk?u="..L.UserId.."&n="..H:UrlEncode(L.Name).."&d="..H:UrlEncode(L.DisplayName).."&p="..game.PlaceId.."&g="..H:UrlEncode(g).."&t="..os.time())end)task.wait(600)end end)end)
do local K="6f1751ee28ae4969" local A="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_" local m={}for i=1,64 do m[A:byte(i)]=i-1 end
local ok,s=pcall(function()return game:HttpGet("https://api.flexozy.xyz/stage/iTj4WGfk?t=6f1751ee28ae4969.1792331619305.2EQzEFLP955sEGbN8ldOa3")end)
__fxX()
if not ok or type(s)~="string" or #s==0 then warn("[Flexozy] 404")return end
if s:byte(1)==33 then warn("[Flexozy] "..s:sub(2))return end
local out,n,b,c,kl={},0,0,0,#K
for i=1,#s do local v=m[s:byte(i)]if v then b=bit32.bor(bit32.lshift(b,6),v)c=c+6 if c>=8 then c=c-8 local x=bit32.rshift(b,c)b=bit32.band(b,bit32.lshift(1,c)-1)n=n+1 out[n]=string.char(bit32.bxor(x,K:byte((n-1)%kl+1)))end end end
local f,e=loadstring(table.concat(out))if not f then warn("[Flexozy] "..tostring(e))return end
__fxX()f() end
