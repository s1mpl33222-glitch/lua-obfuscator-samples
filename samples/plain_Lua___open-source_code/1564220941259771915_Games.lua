if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = "https://raw.githubusercontent.com/AriseScript/AZ/refs/heads/main/"

local games = {
    [861404864] = "script.lua",
    [6042520] = "99.lua",
    [33017480] = "AD.lua",
    [825735094] = "SAE.lua",
    [169690820] = "CA.lua",
    [35881183] = "TSR.lua",
   [281831224] = "HV.lua",
   [279288859] = "SFAN.lua"
}

local file = games[game.CreatorId]

if file then
    local success, err = pcall(function()
        local source = game:HttpGet(BASE .. file)
        local execute = loadstring(source)

        assert(execute, "Failed to compile Script.lua")
        execute()
    end)

    if not success then
        warn("Loader error: " .. tostring(err))
    end
else
    warn("No script configured for Creator ID: " .. tostring(game.CreatorId))
end
