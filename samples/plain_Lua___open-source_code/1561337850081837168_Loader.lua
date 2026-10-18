if not game:IsLoaded()then
game.Loaded:Wait()
end

local a="https://raw.githubusercontent.com/zxcursedsocute/Bite-By-Night/refs/heads/main/lua"
local b="https://raw.githubusercontent.com/zxcursedsocute/World-of-Trollge-script/refs/heads/main/lua"
local c="https://raw.githubusercontent.com/zxcursedsocute/Forsaken-Script/refs/heads/main/lua"
local d="https://raw.githubusercontent.com/zxcursedsocute/Trollge-Incident-Fights-Reborn2-script/refs/heads/main/lua"
local e="https://raw.githubusercontent.com/zxcursedsocute/Trollge-Multiverse/refs/heads/main/lua"
local f="https://raw.githubusercontent.com/zxcursedsocute/CursedHub/refs/heads/main/Main"

local g={
[94641783649173]=b,
[75661637882183]=b,
[18687417158]=c,
[83645629621104]=c,
[12377995562]=d,
[12801608913]=d,
[13028864053]=d,
[13946738101]=e,
[70845479499574]=a
}

local h=g[game.PlaceId]or f

loadstring(game:HttpGet(h))()
