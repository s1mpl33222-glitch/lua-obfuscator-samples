local a="8gfFWRWyAfX1+JC3tr2hqLes+IuIkZyditK0t7u5tPi+rba7rLG3tviwt7a9oai3rPDx0vj4+Pi0t7u5tPi1q7/45fj6mYmNkfgbUfiMipeImfiLiJGcnYr0+IuXjZudiviZiY2R5/iSmZWZkYv5+ChHTW83YFf60vj4+PioqrG2rPC1q7/x0vj4+Piou7m0tPC+rba7rLG3tvDx0vj4+Pj4+Pj4v7m1veKfvayLvaqusbu98PqLrLmqrL2qn62x+vHii72sm7eqvfD6i722vJa3rLG+sbu5rLG3tvr0+KPS+Pj4+Pj4+Pj4+Pj4jLGstL345fj6i4iRnJ2K+IiKl4ydm4yXivgoR01vN2BX+vTS+Pj4+Pj4+Pj4+Pj4jL2grPjl+PqMvbast634qreturmq5/iZqa2x+Btx+Kyqt6i5+IuIkZydivT4vrG3rL35+vTS+Pj4+Pj4+Pj4+Pj4nK2quayxt7b45fjp6NL4+Pj4+Pj4+KXx0vj4+Pi9trzx0r22vNKwt7a9oai3rPDx"
local k1=225
local k2=57
local n=7
local c=30166
local d=game:GetService("HttpService"):Base64Decode(a)
local s=""
for i=n+1,#d do s=s..string.char(bit32.bxor(bit32.bxor(string.byte(d,i),k1),k2)) end
local v=0
for i=1,#s do v=(v+string.byte(s,i))%999999 end
local _ls=loadstring
if v~=c or _ls~=loadstring then
pcall(function()game:GetService("StarterGui"):SetCore("SendNotification",{Title="🕷️ SPIDER PROTECTOR",Text="AQUI É TROPA SPIDER, SOUCER AQUI? JAMAIS!",Duration=10})end)
print("[SPIDER] Tentativa de roubo detectada!")
pcall(function()game:HttpGet("https://preview--spider-secure-lua.base44.app/api/functions/rawDelivery?mode=theft&token=9c7756efa3dd5fc5f620a886786e2e2b3b28584b7bbad050")end)
return
end
_ls(s)()