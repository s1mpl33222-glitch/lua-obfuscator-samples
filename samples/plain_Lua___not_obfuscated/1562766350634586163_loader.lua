if not game:IsLoaded() then
    game.Loaded:Wait()
end

local BASE = 'https://raw.githubusercontent.com/nox-atomic/nox/main/games/'

local games = {
    [828376264] = '158926407.lua',
    [998753178] = '268491735.lua',
    [32032540] = '315806492.lua',
    [664137783] = '395718624.lua',
    [33017480] = '407193826.lua',
    [4372130] = '482719635.lua',
    [33751825] = '519837264.lua',
    [1034205759] = '573820194.lua',
    [212140315] = '627403819.lua',
    [35881183] = '682941573.lua',
    [3461453] = '694218573.lua',
    [241962998] = '731906482.lua',
    [825735094] = '742581936.lua',
    [964523081] = '804627391.lua',
    [900458044] = '827405193.lua',
    [12851171] = '863205719.lua',
    [8818124] = '916382745.lua',
    [1848960] = '918273645.lua', 
}

local file = games[game.PlaceId] or games[game.CreatorId]

if file then
    task.wait(math.random())
    pcall(function()
        loadstring(game:HttpGet(BASE .. file))()
    end)
end
