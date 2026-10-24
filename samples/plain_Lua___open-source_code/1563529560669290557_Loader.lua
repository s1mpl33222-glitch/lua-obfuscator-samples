local l,p=getfenv and getfenv() or function()end,print
local function g(u)local s,e=pcall(function()return game:HttpGet(u)end)return s and e or nil end
local c=g("https://raw.githubusercontent.com/fsh4/MyHub/main/!LOADER.LUA")
if c then local f,e=loadstring(c)if f then pcall(f)else p("Load error: "..tostring(e))end else p("Failed to load")end
