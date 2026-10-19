local function s1() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XenaScriptX/Best/refs/heads/main/Script.lua"))()
end 
local function s2() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/XenaScriptX/AutoFarmLite/refs/heads/main/Script.lua", true))()
end

task.spawn(s1)
task.spawn(s2)
