-- Kero Hub | Universal Loader
local Releases = {
    [10762636904] = {Release = "Cameraman%20TD", Folder = "CameraTD_Macros", RequiresCache = true},
    [10393438342] = {Release = "Alliance%20TD", Folder = "AllianceTD_Macros", RequiresCache = true},
    [10340119210] = {Release = "Periastron%20TD", Folder = "PeriastronTD_Macros", RequiresCache = true},
    [10231502419] = {Release = "Snack%20Defense", Folder = "SnackTD_Macros", RequiresCache = true},
    [10529769390] = {Release = "Slop%20TD", Folder = "SlopTD_Macros", RequiresCache = false},
    [4938220315] = {Release = "Skibidi%20Defense", Folder = "SkibidiDefense_Macros", RequiresCache = false},
    [6628327758] = {Release = "Dummy%20Defense", Folder = "DummyDefense_Macros", RequiresCache = false},
    [3913007563] = {Release = "The%20Battle%20Brick", Folder = "BattleBrick_Macros", RequiresCache = false},
    [6272727021] = {Release = "Undertale%20Adventure%20X", Folder = "UndertableAX_Macros", RequiresCache = true},
    [10703226578] = {Release = "Doodle%20Tower%20Defense", Folder = "DoodleTD_Macros", RequiresCache = true},
    [9994099755] = {Release = "Grow%20A%20Unit%20TD", Folder = "GrowAUnitTD_Macros", RequiresCache = true},
}
local BaseURL = "https://raw.githubusercontent.com/KeroTwT/Kero-Hub/refs/heads/main/Sources/"

if not game:IsLoaded() then game.Loaded:Wait() end
local release = Releases[game.GameId]
if not release then error("Kero Hub: unsupported game.", 0) end

local env = getgenv()
local url = BaseURL .. release.Release
env.__KeroLoaderBusy = env.__KeroLoaderBusy or {}
if env.__KeroLoaderBusy[url] then return end
env.__KeroLoaderBusy[url] = true

local ok, reason = pcall(function()
    local source = game:HttpGet(url)
    local run, compileError = loadstring(source, "KeroHubRelease")
    if not run then error(compileError, 0) end

    local hasFiles = type(isfolder) == "function"
        and type(makefolder) == "function" and type(writefile) == "function"
    if release.RequiresCache and not hasFiles then
        error("Kero Hub: file APIs are required for Auto Execute.", 0)
    end
    if hasFiles then
        if not isfolder(release.Folder) then makefolder(release.Folder) end
        writefile(release.Folder .. "/Hub.lua", source)
    end
    run()
end)

env.__KeroLoaderBusy[url] = nil
if not ok then error(reason, 0) end
