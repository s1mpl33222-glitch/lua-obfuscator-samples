-- AegisLoader v2: public bootstrap
local function fail()local w=warn or print;if w then pcall(w,'[AegisLoader] Could not load securely. Please retry.')end end
local ok,s=pcall(function()return game:HttpGet("https://api.aegisloader.com/loader-runtime/dYSqCMVFDf?ep=1994&v=2")end)
if not ok or type(s)~='string' or #s==0 or #s>262144 then return fail()end
local ls=loadstring or load;if type(ls)~='function'then return fail()end
local good,f=pcall(ls,s);if not good or type(f)~='function'then return fail()end
return f(...)