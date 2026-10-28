return(function(...)
local _ENV=getfenv(0)
local function _i(...)return ... end
local _t=type
local _p=pcall
local _c=string.char
local _b=string.byte
local _s=string.sub
local _f=math.floor
local _k=table.concat
local _r=rawget
local _w=rawset
local _m=setmetatable
local _g=getmetatable
local _n=newproxy
local _d=debug
local _tm=tick or os.clock
local _gs=game and game.GetService
local function _chk()
local e=_ENV
if e~=getfenv(1) and e~=_G then return true end
if _g and _g(e) then return true end
if _d and _d.getinfo then
local ok,info=_p(_d.getinfo,1,"S")
if ok and info and info.source and #info.source>3 and info.source:sub(1,1)=="@" then return true end
end
local t1=_tm()
for i=1,55000 do end
if _tm()-t1<0.00004 or _tm()-t1>2.9 then return true end
local need={"HttpService","RunService","Players","ReplicatedStorage","CoreGui","Lighting","TweenService","UserInputService"}
local hit=0
if _gs then
for i=1,#need do
local ok,s=_p(_gs,game,need[i])
if ok and s then hit=hit+1 end
end
end
if hit<6 then return true end
local ok,fn=_p(function()return function()end end)
if not ok or _t(fn)~="function" then return true end
return false
end
if _chk() then return end
local _data={83,70,76,87,5,2,0,0,0,5,0,0,0,112,114,105,110,116,2,0,0,0,104,105,2,0,0,0,4,0,0,0,65,0,0,0,1,1,1,0,29,0,2,1,31,0,1,0,2,0,0,0,4,0,0,0,0,0,0,0,4,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
local _pos=1
local function _u8()local v=_data[_pos] _pos=_pos+1 return v end
local function _u32()local a=_u8()local b=_u8()local c=_u8()local d=_u8()return a+b*256+c*65536+d*16777216 end
local function _str()local n=_u32()if n==0 then return""end local t={}for i=1,n do t[i]=_c(_u8())end return _k(t)end
if _u8()~=83 or _u8()~=70 or _u8()~=76 or _u8()~=87 then return end
if _u8()~=5 then return end
local ns=_u32()
local st={}
for i=1,ns do st[i]=_str()end
local ms,np,nu,iv=_u8(),_u8(),_u8(),_u8()
local nc=_u32()
local code={}
for i=1,nc do code[i]=_u32()end
local nk=_u32()
local k={}
for i=1,nk do
local tp=_u8()
if tp==4 then k[i]=st[_u32()+1] else k[i]=nil end
end
local stack,pc,env={},1,getfenv(1)
while pc<=#code do
if _chk() then return end
local raw=code[pc]
pc=pc+1
local op=raw%256
local a=_f(raw/256)%256
local b=_f(raw/65536)%256
local bx=_f(raw/65536)
if op==65 then
stack[a+1]=env[k[bx+1]]
elseif op==1 then
stack[a+1]=k[bx+1]
elseif op==29 then
local fn=stack[a+1]
local args={}
for i=1,b-1 do args[i]=stack[a+1+i]end
fn(unpack(args))
elseif op==31 then
return
end
end
end)(...)
