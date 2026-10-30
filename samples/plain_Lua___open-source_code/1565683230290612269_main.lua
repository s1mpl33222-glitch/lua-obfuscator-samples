local Players     = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

local GAMES = {
    {
        Name      = "The Morgue Shift",
        Subtitle  = "Freemium Roblox Scripts",
        PlaceIds   = { 126025038789852,122093998639862, 98049867659682, 82572839415010 },
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/themorgueshift.lua",
    },
    {
        Name      = "+1 Superhero Evolution",
        Subtitle  = "Freemium Roblox Scripts",
        PlaceId   = 97824450589417,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/superheroevolution.lua",
    },
    {
        Name    = "Anime Dice",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 113290951185459,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/animedice.lua",
    },
    {
        Name    = "Ride A Pet",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 124216119978534,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/rideapet.lua",
    },
    {
        Name    = "Dueling Grounds",
        Subtitle  = "Freemium Roblox Scripts",
        PlaceIds  = { 94217045453265, 9051406594, 100484168444874 },
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/duelinggrounds.lua",
    },
    {
        Name    = "Break And Steal An Egg",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 114326934417838,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/basae.lua",
    },
    {
        Name    = "Fishing Master",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 99925503388128,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/fishingmaster.lua",
    },
    {
        Name    = "+1 Assasin Leveling",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 120731410233153,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/assasinleveling.lua",
    },
    {
        Name    = "Cold War [VIETNAM]",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 120731410233153,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/coldwar.lua",
    },
    {
        Name    = "Sniper Arena",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 122446657157717,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/sniperarena.lua",
    },
    {
        Name    = "Don't Steal My Egg",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 135675416428111,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/dontstealmyegg.lua",
    },
    {
        Name    = "Anime Zero",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceIds  = { 114574503491412, 109151342576374 },
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/animezero.lua",
    },
    {
        Name    = "Prehistoric Farm",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 139780970631001,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/prehistoricfarm.lua",
    },
    {
        Name    = "Fish Riders",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 119672433229947,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/fishriders.lua",
    },
    {
        Name    = "Climb For Animals Egg",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 85738654635245,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/climbforanimals.lua",
    },
    {
        Name    = "Forester",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 117020342702668,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/forester.lua",
    },
    {
        Name    = "DOORS",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 6839171747,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/doors.lua",
    },
    {
        Name    = "Flee The Facilityl",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceId   = 893973440,
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/ftf.lua",
    },
    {
        Name    = "Violence District",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceIds   = { 6739698191, 93978595733734, 9245727061 },
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/violencedistrict.lua",
    },
    {
        Name    = "Blade Ball",
        Subtitle   = "Freemium Roblox Scripts",
        PlaceIds   = { 13772394625, 1712764003, 76007646, 4777817887, 16044264830, 16281300371 },
        ScriptURL = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/scripts/bladeball.lua",
    },
}

local CONFIG = {
    LoaderURL   = "https://cdn.jsdelivr.net/gh/euloxa/Universal@refs/heads/main/loader.lua",
    VerifyKey   = "L2-HUB",
    NotifyTime  = 4,
    Verbose     = true,
    SecretSalt  = "L2HUB_v1_SECRET_CHANGE_ME",
    SessionTTL  = 600,
    VerifyWait  = 180,
}

local function Log(msg)
    if CONFIG.Verbose then
        print("[L2-HUB] " .. tostring(msg))
    end
end

local function Notify(title, content, duration)
    duration = duration or CONFIG.NotifyTime

    if L2Hub and L2Hub.Notifier then
        pcall(function()
            L2Hub.Notifier.new({
                Title    = title,
                Content  = content,
                Duration = duration,
                Icon     = "lucide:info",
            })
        end)
        return
    end

    if Starlight and Starlight.Notify then
        pcall(Starlight.Notify, { Title = title, Content = content, Duration = duration })
    end
end

local function HMAC(str, salt)
    local out = 0
    for i = 1, #str do
        out = (out * 31 + str:byte(i)) % 2^31
    end
    return tostring(out)
end

local function GenerateSession()
    local sessionKey = table.concat({
        tostring(game.PlaceId),
        tostring(game.JobId or ""),
        tostring(os.time()),
        tostring(math.random(1, 2^30)),
        tostring(LocalPlayer.UserId or 0),
    }, "|")

    local signature   = HttpService:GenerateGUID(false)
    local fingerprint = HMAC(sessionKey .. CONFIG.SecretSalt, CONFIG.SecretSalt)

    getgenv().L2HUB_SESSION = {
        Key         = sessionKey,
        Signature   = signature,
        Fingerprint = fingerprint,
        PlaceId     = game.PlaceId,
        JobId       = game.JobId,
        UserId      = LocalPlayer.UserId,
        Time        = os.time(),
        Version     = 1,
    }

    Log("Session generated.")
    return getgenv().L2HUB_SESSION
end

local function LoadLoader()
    Log("Fetching loader UI...")

    local ok, source = pcall(game.HttpGet, game, CONFIG.LoaderURL)
    if not ok or type(source) ~= "string" or #source < 100 then
        Notify("L2-HUB", "Failed to fetch loader UI.", 5)
        return false
    end

    local chunk, err = loadstring(source)
    if not chunk then
        Notify("L2-HUB", "Loader compile error: " .. tostring(err), 6)
        return false
    end

    local ok2, err2 = pcall(chunk)
    if not ok2 then
        Notify("L2-HUB", "Loader runtime error: " .. tostring(err2), 6)
        return false
    end

    Log("Loader UI loaded.")
    return true
end

local function WaitForGameSelection(timeout)
    timeout = timeout or CONFIG.VerifyWait

    local bindable = Instance.new("BindableEvent")
    getgenv().L2HUB_VERIFIED = bindable

    local selectedGame = nil
    local conn = bindable.Event:Connect(function(result)
        if type(result) == "table" and result.ScriptURL then
            selectedGame = result
        end
    end)

    local startTime = os.time()
    while not selectedGame do
        if os.time() - startTime > timeout then
            Log("Selection timeout.")
            break
        end
        task.wait(0.2)
    end

    conn:Disconnect()
    bindable:Destroy()
    getgenv().L2HUB_VERIFIED = nil

    return selectedGame
end

local function ExecuteScript(gameEntry)
    Log("Loading: " .. gameEntry.Name .. " (" .. gameEntry.ScriptURL .. ")")

    local ok, source = pcall(game.HttpGet, game, gameEntry.ScriptURL)
    if not ok or type(source) ~= "string" or #source < 50 then
        Notify("L2-HUB", "Failed to download: " .. gameEntry.Name, 5)
        return false
    end

    local chunk, err = loadstring(source)
    if not chunk then
        Notify("L2-HUB", "Compile error: " .. tostring(err), 6)
        return false
    end

    local ok2, err2 = pcall(chunk)
    if not ok2 then
        Notify("L2-HUB", "Runtime error: " .. tostring(err2), 6)
        return false
    end

    Notify("L2-HUB", gameEntry.Name .. " loaded.", 4)
    return true
end

local function NormalizeGames()
    for _, g in ipairs(GAMES) do
        if g.PlaceIds and type(g.PlaceIds) == "table" and #g.PlaceIds > 0 then
            if not g.PlaceId then g.PlaceId = g.PlaceIds[1] end
        elseif g.PlaceId then
            g.PlaceIds = { g.PlaceId }
        end

        if g.GameIds and type(g.GameIds) == "table" and #g.GameIds > 0 then
            if not g.GameId then g.GameId = g.GameIds[1] end
        elseif g.GameId then
            g.GameIds = { g.GameId }
        end
    end
end

local function Main()
    Log("Starting L2-HUB...")

    if #GAMES == 0 then
        Notify("L2-HUB", "No games configured in main.lua", 6)
        return
    end

    NormalizeGames()
    getgenv().L2HUB_GAMES = GAMES

    if not LoadLoader() then
        return
    end

    local selectedGame = WaitForGameSelection(CONFIG.VerifyWait)
    if not selectedGame then
        Log("No game selected.")
        return
    end

    GenerateSession()
    task.wait(0.15)

    ExecuteScript(selectedGame)
end

task.spawn(function()
    local ok, err = pcall(Main)
    if not ok then
        warn("[L2-HUB] Fatal: " .. tostring(err))
        Notify("L2-HUB", "Fatal error: " .. tostring(err), 6)
    end
end)