if getgenv().nobulem_loader_started then return end
getgenv().nobulem_loader_started = true

local KEYSYSTEM_URL = ("https://raw.githubusercontent.com/Emplic/nobulem-v3/refs/heads/main/key-system.lua")

local LuarmorScriptIds = {
    WarTycoon = "450d986ceeb9678f3455712371a99053",
    Flick = "2d3b779daff5c319a93d5d8f38b1bdc0",
    WarRivals = "2e458885993bf92dd5f601886f49efd7",
    WarRivalsSellFries = "2e458885993bf92dd5f601886f49efd7",
    Wanted = "b59527dfe5520d0cd523a37e7ddf2b47",
    ProjectSlayers = "9955c61131117e72e978555014354b74",
    Hypershot = "df41b2339aac3a6c2e5b10079fd0a0f7",
    AnimeZero = "a04c0b7e46927ee3eefa916ccd650326",
    AnimeZeroHuntingSeason = "3ec02d97a9106e0ff825f5087fc02af7",
    HussValley = "116ebbf35ba12f82bbfb1b5b552d8773",
}
local LuarmorAdUrls = {
    Linkvertise = "https://ads.luarmor.net/get_key?for=Linkvertise-WNOSNrUbmMHZ",
    WorkInk = "https://ads.luarmor.net/get_key?for=Work_ink-ENZrHfPIitmN",
    Linkvertise24h = "https://ads.luarmor.net/get_key?for=Linkvertise_2-KLYIoYnluHnT",
}

for name, id in pairs(getgenv().NobulemLuarmorScriptIds or {}) do LuarmorScriptIds[name] = id end
for name, url in pairs(getgenv().NobulemLuarmorAdUrls or {}) do LuarmorAdUrls[name] = url end

local WarRivalsSellFriesScriptId = LuarmorScriptIds.WarRivalsSellFries or ""
local AnimeZeroHuntingSeasonScriptId = LuarmorScriptIds.AnimeZeroHuntingSeason or ""

local Games = {
    {
        PlaceIds        = { 114574503491412, 109151342576374, 96023089630459, 132303256922720 },
        UniverseId      = 10512942223,
        GameName        = "Anime Zero",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = AnimeZeroHuntingSeasonScriptId ~= "" and AnimeZeroHuntingSeasonScriptId or LuarmorScriptIds.AnimeZero or "",
        GetKeyUrl       = LuarmorAdUrls.AnimeZeroHuntingSeason or LuarmorAdUrls.AnimeZero or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = {
            120073741652089, 5286116071, 73645306091146, 89820338455770, 108808025081246,
            112565629873945, 124742531393193, 134584993281466,
        },
        UniverseId      = 1851087906,
        GameName        = "Hunting Season",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = AnimeZeroHuntingSeasonScriptId,
        GetKeyUrl       = LuarmorAdUrls.AnimeZeroHuntingSeason or LuarmorAdUrls.HuntingSeason or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = { 107535308163741 },
        UniverseId      = 10764627709,
        GameName        = "Huss Valley",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = LuarmorScriptIds.HussValley or "",
        GetKeyUrl       = LuarmorAdUrls.HussValley or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = { 4639625707, 6856061811, 17267897726, 18161998932, 116355587227251 },
        UniverseId      = 1526814825,
        GameName        = "War Tycoon",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = LuarmorScriptIds.WarTycoon or "",
        GetKeyUrl       = LuarmorAdUrls.WarTycoon or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = { 136801880565837 },
        UniverseId      = 8795154789,
        GameName        = "Flick",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = LuarmorScriptIds.Flick or "",
        GetKeyUrl       = LuarmorAdUrls.Flick or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = { 121918565917280, 84633364830760, 123983382517341 },
        UniverseId      = 10465807951,
        GameName        = "War Rivals",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = WarRivalsSellFriesScriptId ~= "" and WarRivalsSellFriesScriptId or LuarmorScriptIds.WarRivals or "",
        GetKeyUrl       = LuarmorAdUrls.WarRivalsSellFries or LuarmorAdUrls.WarRivals or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = { 139542527731344, 94891079210424 },
        UniverseId      = 10767380385,
        GameName        = "Sell Fries",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = WarRivalsSellFriesScriptId,
        GetKeyUrl       = LuarmorAdUrls.WarRivalsSellFries or LuarmorAdUrls.SellFries or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = { 14438406081 },
        UniverseId      = 4987856151,
        GameName        = "Wanted",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = LuarmorScriptIds.Wanted or "",
        GetKeyUrl       = LuarmorAdUrls.Wanted or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = {
            136406881576517, 13883059853, 11468075017, 5956785391, 9627847912, 75556147183481,
            16205713724, 17047024836, 109676363279588, 130395143593224,
        },
        UniverseId      = 5595353122,
        GameName        = "Project Slayers 2",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = LuarmorScriptIds.ProjectSlayers or "",
        GetKeyUrl       = LuarmorAdUrls.ProjectSlayers or LuarmorAdUrls.Default or "",
    },
    {
        PlaceIds        = {
            86696142930150, 100040622766961, 108428559529058, 17516596118, 92980558919575, 97804379417079,
            105357751512007, 110169684430399, 122181485177067, 128220027114734, 131008473296170, 134474332601640,
        },
        UniverseId      = 5995470825,
        GameName        = "Hypershot",
        SaveFile        = "nobulem_key.txt",
        LuarmorScriptId = LuarmorScriptIds.Hypershot or "",
        GetKeyUrl       = LuarmorAdUrls.Hypershot or LuarmorAdUrls.Default or "",
    },
}

local HttpService = game:GetService("HttpService")

local function FetchSubplaceIds(rootPlaceId)
    local okU, uniBody = pcall(function()
        return game:HttpGet(("https://apis.roblox.com/universes/v1/places/%d/universe"):format(rootPlaceId))
    end)
    if not okU then return {} end
    local okD, uniData = pcall(function() return HttpService:JSONDecode(uniBody) end)
    if not okD or type(uniData) ~= "table" or not uniData.universeId then return {} end

    local ids = {}
    local cursor = nil
    repeat
        local url = ("https://develop.roblox.com/v1/universes/%d/places?sortOrder=Asc&limit=100"):format(uniData.universeId)
        if cursor then url = url .. "&cursor=" .. cursor end
        local okP, body = pcall(function() return game:HttpGet(url) end)
        if not okP then break end
        local okJ, decoded = pcall(function() return HttpService:JSONDecode(body) end)
        if not okJ or type(decoded) ~= "table" then break end
        for _, place in ipairs(decoded.data or {}) do
            table.insert(ids, place.id)
        end
        cursor = decoded.nextPageCursor
    until not cursor or cursor == ""
    return ids
end

local SubplaceCache = {}

local function ResolveGame(placeId)
    for _, entry in ipairs(Games) do
        if placeId == game.PlaceId and entry.UniverseId and entry.UniverseId == game.GameId then
            return entry
        end
        for _, id in ipairs(entry.PlaceIds) do
            if id == placeId then return entry end
        end
    end
    for _, entry in ipairs(Games) do
        local roots = entry.SubplaceRoots or { entry.PlaceIds[1] }
        for _, rootId in ipairs(roots) do
            if rootId then
                if not SubplaceCache[rootId] then
                    SubplaceCache[rootId] = FetchSubplaceIds(rootId)
                end
                for _, id in ipairs(SubplaceCache[rootId]) do
                    if id == placeId then return entry end
                end
            end
        end
    end
    return nil
end

local ObsidianLibrary
local function LoadObsidian()
    if ObsidianLibrary then return ObsidianLibrary end
    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    local okL, Library = pcall(function() return loadstring(game:HttpGet("https://raw.githubusercontent.com/Emplic/nobulem-v3/refs/heads/main/library.lua"))() end)
    if not okL or not Library then return nil end
    Library.CornerRadius = 10
    local okT, ThemeManager = pcall(function() return loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))() end)
    if okT and ThemeManager then
        pcall(function()
            ThemeManager:SetLibrary(Library)
            ThemeManager:ApplyTheme("Tokyo Night")
        end)
    end
    pcall(function() Library:SetNotifySide("Right") end)
    ObsidianLibrary = Library
    return Library
end

local function Notify(title, text, duration)
    local Library = LoadObsidian()
    if Library and Library.Notify then
        local ok = pcall(function()
            Library:Notify({ Title = title, Description = text, Time = duration or 6 })
        end)
        if ok then return end
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = text, Duration = duration or 6,
        })
    end)
    warn(("[nobulem.wtf] %s: %s"):format(title, text))
end

local cfg = ResolveGame(game.PlaceId)
if not cfg then
    Notify(
        "Unsupported Game",
        ("nobulem.wtf does not currently support this game (PlaceId: %d)."):format(game.PlaceId),
        10
    )
    getgenv().nobulem_loader_started = nil
    return
end

local ResolvedName = (cfg.PlaceNames and cfg.PlaceNames[game.PlaceId]) or cfg.GameName

local scriptId = LuarmorScriptIds[game.PlaceId] or cfg.LuarmorScriptId
if type(scriptId) ~= "string" or #scriptId ~= 32 or not scriptId:match("^[0-9a-fA-F]+$") then
    Notify("Luarmor setup needed", "Set the Luarmor script ID for " .. ResolvedName .. " in loader.lua.", 10)
    getgenv().nobulem_loader_started = nil
    return
end

if cfg.Discontinued then
    Notify(
        ResolvedName,
        ("%s is currently discontinued for nobulem at this time. Please try again later."):format(ResolvedName),
        10
    )
    getgenv().nobulem_loader_started = nil
    return
end

getgenv().NobulemLoaderConfig = {
    PlaceId         = game.PlaceId,
    GameName        = ResolvedName,
    SaveFile        = cfg.SaveFile,
    LuarmorScriptId = scriptId,
    GetKeyUrl       = cfg.GetKeyUrl,
    LinkvertiseUrl  = LuarmorAdUrls.Linkvertise,
    Linkvertise12hUrl = LuarmorAdUrls.Linkvertise12h or LuarmorAdUrls.Linkvertise,
    Linkvertise24hUrl = LuarmorAdUrls.Linkvertise24h,
    WorkInkUrl      = LuarmorAdUrls.WorkInk,
    LootLabsUrl     = LuarmorAdUrls.LootLabs,
}

local function InviteDiscord()
    local HttpService = game:GetService("HttpService")
    local UserInputService = game:GetService("UserInputService")
    
    local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled
    
    if isMobile then
        pcall(function() setclipboard("https://discord.gg/mugcSRnpuG") end)
        Notify("nobulem.wtf", "Discord invite copied to clipboard!", 5)
    else
        pcall(function()
            request({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json", Origin = "https://discord.com" },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    nonce = HttpService:GenerateGUID(false),
                    args = { code = "mugcSRnpuG" }
                })
            })
        end)
    end
end

task.spawn(InviteDiscord)

local ok, err = pcall(function()
    local source = game:HttpGet(KEYSYSTEM_URL)
    local chunk, compileErr = loadstring(source)
    if not chunk then error("compile: " .. tostring(compileErr)) end
    chunk(getgenv().NobulemLoaderConfig)
end)

if not ok then
    Notify("Loader Error", tostring(err), 10)
    getgenv().nobulem_loader_started = nil
    getgenv().NobulemLoaderConfig = nil
end
