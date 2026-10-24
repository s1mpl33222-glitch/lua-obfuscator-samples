local success, result = pcall(function() 
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/sanjeevthakur154a-jpg/nehhinnjfiueioerok/refs/heads/main/KEYGATE.lua?t=" .. tick()))() 
end) 

if success then
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Key NOTICE!",
            Text = "The script may take up to 30 seconds to load.",
            Duration = 7
        })
    end)
else 
    warn("Failed to load script: " .. tostring(result)) 
end
