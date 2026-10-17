if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = 'https://raw.githubusercontent.com/NOX-SCRIPT/NOX/main/GAMES/'

local games = {
    [825735094] = 'sae.lua',
    [4372130] = 'bloxfruits.lua',
    [8818124] = 'vd.lua',
    [212140315] = 'ftap.lua',
    [1034205759] = 'bvsb.lua',
    [241962998] = 'sa.lua',
    [33017480] = 'animedice.lua',
    [964523081] = 'sfe.lua',
    [3461453] = 'rivals.lua',
    [900458044] = 'sfth.lua',
    [33751825] = 'bloxstrike.lua',
    [12851171] = 'sl2.lua',
}

local file = games[game.PlaceId] or games[game.CreatorId]

if file then
    task.wait(math.random())
    pcall(function()
        loadstring(game:HttpGet(BASE .. file))()
    end)
end
