if not game:IsLoaded() then game.Loaded:Wait() end
local __stRunUrl="https://loader.somtank.space/loader/murder.lua"..'?run='..tostring(os.clock())
local __stRequestOk,__stSource=pcall(function() return game:HttpGet(__stRunUrl) end)
if not __stRequestOk or type(__stSource)~='string' or __stSource=='' then error("0x01cebd0109d7",0) end
local __stLoad=loadstring or load
if type(__stLoad)~='function' then error("0xec8a7ca7034d",0) end
local __stCompileOk,__stChunk=pcall(__stLoad,__stSource)
if not __stCompileOk or type(__stChunk)~='function' then error("0x8093ec88ba98",0) end
return __stChunk(...) 