-- anti-clipboard hook (run FIRST)
pcall(function()
    getgenv().setclipboard = function() end
    getgenv().toclipboard = function() end

    if Clipboard and Clipboard.set then
        Clipboard.set = function() end
    end
end)

-- THEN run main script
loadstring(game:HttpGet("https://star-scripts.com/api/run/d5G_adx7jVo1EMspYv3sx9tPzx29iY8p"))()
