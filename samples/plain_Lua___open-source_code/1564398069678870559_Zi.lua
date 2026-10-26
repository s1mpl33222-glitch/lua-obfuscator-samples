task.spawn(function()
    pcall(function()
        local code = [[
            task.spawn(function()
                pcall(function()
                    loadstring(game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/no/refs/heads/main/Zi2.lua"))()
                end)
            end)
        ]]

        loadstring(game:HttpGet("https://raw.githubusercontent.com/xspeedHub0/no/refs/heads/main/Zi2.lua"))()

        local q = queue_on_teleport or queueonteleport
        if q then
            q(code)
        end
    end)
end)
