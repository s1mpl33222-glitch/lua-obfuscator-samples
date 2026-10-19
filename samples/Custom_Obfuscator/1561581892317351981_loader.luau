local _fa67817c37140=(function()
 
 
local _f54b9ca05b8d6,_fc8fb573f1cfb,_f1db81b74fbe8,_fdc5e1b13d4ba=pcall,type,error,typeof
local _fb40d05477c9d,_fd9d7a6f599ab=game,workspace
local _fae4639d2b263,_fec375cfd32e6,_f8ff598e2e161
local _f817d4d7a7f64,_f48e4c8d0fa52=false,false
local _fa4ccae88d712='\116\097\109\112\101\114\032\097\115\032\098\101\101\110\032\100\101\116\101\099\116\101\100\032\116\104\097\110\107\115\032\102\111\114\032\115\116\111\112\112\105\110\103'
return function()
    if _f48e4c8d0fa52 then _f1db81b74fbe8(_fa4ccae88d712,0) end
    local ok,valid=_f54b9ca05b8d6(function()
        if game~=_fb40d05477c9d or workspace~=_fd9d7a6f599ab or typeof~=_fdc5e1b13d4ba then return false end
        if _fc8fb573f1cfb(_fdc5e1b13d4ba)~='\102\117\110\099\116\105\111\110' or _fdc5e1b13d4ba(game)~='\073\110\115\116\097\110\099\101' or _fdc5e1b13d4ba(workspace)~='\073\110\115\116\097\110\099\101' then return false end
        if not game:IsA('\068\097\116\097\077\111\100\101\108') or not workspace:IsA('\087\111\114\107\115\112\097\099\101') then return false end
        if game:GetService('\087\111\114\107\115\112\097\099\101')~=workspace or workspace.Parent~=game then return false end
        local runService=game:GetService('\082\117\110\083\101\114\118\105\099\101')
        local players=game:GetService('\080\108\097\121\101\114\115')
        if _fdc5e1b13d4ba(runService)~='\073\110\115\116\097\110\099\101' or not runService:IsA('\082\117\110\083\101\114\118\105\099\101') then return false end
        if _fdc5e1b13d4ba(players)~='\073\110\115\116\097\110\099\101' or not players:IsA('\080\108\097\121\101\114\115') then return false end
        if runService.Parent~=game or players.Parent~=game then return false end
        if runService:IsClient()~=true or runService:IsServer()~=false then return false end
        local player=players.LocalPlayer
        if _fdc5e1b13d4ba(player)~='\073\110\115\116\097\110\099\101' or not player:IsA('\080\108\097\121\101\114') or player.Parent~=players then return false end
        if _f817d4d7a7f64 and (runService~=_fae4639d2b263 or players~=_fec375cfd32e6 or player~=_f8ff598e2e161) then return false end
        local function validId(id)
            return _fc8fb573f1cfb(id)=='\110\117\109\098\101\114' and id==id and id>=0 and id<1/0 and id%1==0
        end
        if not validId(game.PlaceId) or not validId(game.GameId) then return false end
        _fae4639d2b263,_fec375cfd32e6,_f8ff598e2e161=runService,players,player
        _f817d4d7a7f64=true
        return true
    end)
    if not ok or valid~=true then _f48e4c8d0fa52=true;_f1db81b74fbe8(_fa4ccae88d712,0) end
end

end)()
_fa67817c37140()
local hash=(function()
 
local band,bxor,bnot,rshift,ror=bit32.band,bit32.bxor,bit32.bnot,bit32.rshift,bit32.rrotate
local byte,char,rep,format=string.byte,string.char,string.rep,string.format
local concat=table.concat
local K={
0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function word(v) return char(rshift(v,24),band(rshift(v,16),255),band(rshift(v,8),255),band(v,255)) end
return function(_fa4ccae88d712)
 local length=#_fa4ccae88d712
 local data=_fa4ccae88d712..char(128)..rep('\0',(55-length)%64)..word(math.floor(length/536870912))..word((length*8)%4294967296)
 local h={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
 local w={}
 for block=1,#data,64 do
  for i=1,16 do local a,b,c,d=byte(data,block+(i-1)*4,block+(i-1)*4+3);w[i]=((a*256+b)*256+c)*256+d end
  for i=17,64 do
   local x,y=w[i-15],w[i-2]
   w[i]=(w[i-16]+bxor(ror(x,7),ror(x,18),rshift(x,3))+w[i-7]+bxor(ror(y,17),ror(y,19),rshift(y,10)))%4294967296
  end
  local a,b,c,d,e,f,g,j=table.unpack(h)
  for i=1,64 do
   local t1=(j+bxor(ror(e,6),ror(e,11),ror(e,25))+bxor(band(e,f),band(bnot(e),g))+K[i]+w[i])%4294967296
   local t2=(bxor(ror(a,2),ror(a,13),ror(a,22))+bxor(band(a,b),band(a,c),band(b,c)))%4294967296
   j,g,f,e,d,c,b,a=g,f,e,(d+t1)%4294967296,c,b,a,(t1+t2)%4294967296
  end
  local v={a,b,c,d,e,f,g,j}
  for i=1,8 do h[i]=(h[i]+v[i])%4294967296 end
 end
 local out={};for i=1,8 do out[i]=format('\037\048\056\120',h[i]) end
 return concat(out)
end

end)()
local send=request or http_request or (type(syn)=='\116\097\098\108\101' and syn.request)
assert(type(send)=='\102\117\110\099\116\105\111\110','\077\105\115\115\105\110\103\032\114\101\113\117\101\115\116\032\065\080\073')
local ok,response=pcall(send,{Url="https://farlua.net/vm?script=9b46cc35-6d1f-42e6-922c-d316f46f3b62&release=0f1227a5-7ef1-4220-b179-47973d9c06cb",Method='\071\069\084'})
_fa67817c37140()
if not ok or type(response)~='\116\097\098\108\101' or response.StatusCode~=200 then error('\070\076\095\086\077\095\068\079\087\078\076\079\065\068\058\032\086\077\032\100\111\119\110\108\111\097\100\032\102\097\105\108\101\100\046',0) end
local body=response.Body
assert(type(body)=='\115\116\114\105\110\103' and #body>0 and #body<=262144,'\070\076\095\086\077\095\068\079\087\078\076\079\065\068\058\032\073\110\118\097\108\105\100\032\086\077\032\115\105\122\101\046')
assert(hash(body)=="b4c1d1aa3a02fe2e1a37457782048d442615b88fbef8322b241d2ef54133f74e",'\070\076\095\073\078\084\069\071\082\073\084\089\058\032\086\077\032\083\072\065\045\050\053\054\032\109\105\115\109\097\116\099\104')
_fa67817c37140()
local fn,err=loadstring(body,'\070\097\114\076\117\097\032\086\077')
assert(type(fn)=='\102\117\110\099\116\105\111\110',err or '\070\076\095\086\077\095\067\079\077\080\073\076\069\058\032\086\077\032\099\111\109\112\105\108\097\116\105\111\110\032\102\097\105\108\101\100\046')
_fa67817c37140()
return fn()
