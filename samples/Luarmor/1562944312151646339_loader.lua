--!nolint UnknownGlobal

if iscclosure and not iscclosure(loadstring) then return end

if getgenv().neuro_net then

    return

end

getgenv().neuro_net = true

local Loader = loadstring(game:HttpGet("https://raw.githubusercontent.com/jewhaxx/libraries/refs/heads/main/loader.luau"))()

Loader:SetTitle("neuro.net")

Loader:SetUpdateLogs({

    { Text = " Combat Warriors", Prefix = nil },

    { Text = "Fixed detections", Prefix = "!" },

    { Text = "", Prefix = nil },

    { Text = "Hood Customs", Prefix = nil },

    { Text = "Nil", Prefix = "+" },

})

local BaseUrl = "https://github.com/catthatdrinkssprite/catnip/raw/main"

local Folders = {

    "neuro_net",

    "neuro_net/images",

    "neuro_net/txts",

    "neuro_net/sounds",

}

local Assets = {

    { Name = "neuro_net/images/paw.png",           Url = BaseUrl .. "/catnip/images/paw.png" },

    { Name = "neuro_net/sounds/12.mp3",             Url = BaseUrl .. "/catnip/sounds/12.mp3" },

    { Name = "neuro_net/sounds/agpa2.mp3",          Url = BaseUrl .. "/catnip/sounds/agpa2.mp3" },

    { Name = "neuro_net/sounds/basshit.mp3",        Url = BaseUrl .. "/catnip/sounds/basshit.mp3" },

    { Name = "neuro_net/sounds/bell.mp3",           Url = BaseUrl .. "/catnip/sounds/bell.mp3" },

    { Name = "neuro_net/sounds/blizzard.mp3",       Url = BaseUrl .. "/catnip/sounds/blizzard.mp3" },

    { Name = "neuro_net/sounds/bubble.mp3",         Url = BaseUrl .. "/catnip/sounds/bubble.mp3" },

    { Name = "neuro_net/sounds/chockpro.mp3",       Url = BaseUrl .. "/catnip/sounds/chockpro.mp3" },

    { Name = "neuro_net/sounds/cod.mp3",            Url = BaseUrl .. "/catnip/sounds/cod.mp3" },

    { Name = "neuro_net/sounds/copperbell.mp3",     Url = BaseUrl .. "/catnip/sounds/copperbell.mp3" },

    { Name = "neuro_net/sounds/crowbar.mp3",        Url = BaseUrl .. "/catnip/sounds/crowbar.mp3" },

    { Name = "neuro_net/sounds/headshot.mp3",       Url = BaseUrl .. "/catnip/sounds/headshot.mp3" },

    { Name = "neuro_net/sounds/knob.mp3",           Url = BaseUrl .. "/catnip/sounds/knob.mp3" },

    { Name = "neuro_net/sounds/minecraft orb.mp3",  Url = BaseUrl .. "/catnip/sounds/minecraft%20orb.mp3" },

    { Name = "neuro_net/sounds/neverlose.mp3",      Url = BaseUrl .. "/catnip/sounds/neverlose.mp3" },

    { Name = "neuro_net/sounds/rust.mp3",           Url = BaseUrl .. "/catnip/sounds/rust.mp3" },

    { Name = "neuro_net/sounds/skeet.mp3",          Url = BaseUrl .. "/catnip/sounds/skeet.mp3" },

    { Name = "neuro_net/skyboxes.json",             Url = BaseUrl .. "/catnip/skyboxes.json" },

}

local GameScripts = {

    [3634139746] = "https://api.luarmor.net/files/v4/loaders/626fc7ead0096e200d611dfdabaaf108.lua",

    [73885730]   = "https://api.luarmor.net/files/v4/loaders/a17237386df1215087e13fb5d3529b94.lua",

    [4712126054] = "https://api.luarmor.net/files/v4/loaders/d1d7eb77497b786a06575fa6d04464d1.lua",

    [1390601379] = "https://api.luarmor.net/files/v4/loaders/70be6c611a13123fd4527f0416e751ad.lua",

    [4348829796] = "https://api.luarmor.net/files/v4/loaders/3df3f56e54e923ff7ecfd23fce32194d.lua",

    [6035872082] = "https://api.luarmor.net/files/v4/loaders/d8cefdea3e53b3a0752dc39265880d5c.lua",

}

local ScriptUrl = GameScripts[game.GameId]

for _, Folder in Folders do

    if not isfolder(Folder) then

        makefolder(Folder)

    end

end

local Steps = {

    {

        Type = "ConsoleLog",

        Text = "Starting loader",

        LogType = "Warning"

    },

    {

        Type = "WaitForGame",

        Weight = 2,

    },

    {

        Type = "DownloadAssets",

        Weight = 5,

        Assets = Assets,

    },

}

if ScriptUrl then

    table.insert(Steps, {

        Type = "ConsoleLog",

        Text = "Loading main script",

        LogType = "Success"

    })

    table.insert(Steps, {

        Type = "Loadstring",

        Link = ScriptUrl,

    })

else

    table.insert(Steps, {

        Type = "ConsoleLog",

        Text = "Unsupported game (GameId: " .. tostring(game.GameId) .. ")",

        LogType = "Error"

    })

end

Loader:Run(Steps)
