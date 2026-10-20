-- anti-clipboard hook (run FIRST)
pcall(function()
    getgenv().setclipboard = function() end
    getgenv().toclipboard = function() end

    if Clipboard and Clipboard.set then
        Clipboard.set = function() end
    end
end)

-- THEN run main script
loadstring(game:HttpGet("https://raw.githubusercontent.com/OP-Script-Hub/OPSriptHub/refs/heads/main/_visual"))()
