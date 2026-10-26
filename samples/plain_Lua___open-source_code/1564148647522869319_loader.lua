local API = "https://moonhub-keys.moonhubscripts.workers.dev"
local DISCORD = "https://discord.gg/qn4WayavbB"
if type(EMBEDDED) == "table" and type(EMBEDDED.Api) == "string" and EMBEDDED.Api ~= "" then
    API = EMBEDDED.Api
end
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local env = (getgenv and getgenv()) or _G
local player = Players.LocalPlayer
while not player do
    task.wait(0.1)
    player = Players.LocalPlayer
end
local PREVIEW = API == ""
local KEY_FILE = "MoonHub/key.txt"
local function scopeOf(entry)
    local producer = type(entry) == "table" and entry.producer
    if type(producer) == "string" and producer ~= "moon" and #producer <= 24 and string.match(producer, "^[a-z0-9%-]+$") then
        return producer
    end
    return "moon"
end
local function keyFileOf(scope)
    return (scope and scope ~= "moon") and ("MoonHub/key_" .. scope .. ".txt") or KEY_FILE
end
local function gameParam(entry)
    return type(entry) == "table" and ("&game=" .. HttpService:UrlEncode(tostring(entry.script or entry.id))) or ""
end
local UNIVERSE_CACHE = "MoonHub/universes.json"
local COUNTDOWN = 5
local STATUS_CACHE = "MoonHub/status_cache.json"
local LOCAL_HUB = "MoonHub/Moon Hub.lua"
local DEMO_KEY = string.reverse("TSET-TSET-TSET-NOOM")
local CAN_FILES = type(writefile) == "function" and type(readfile) == "function" and type(isfile) == "function"
local AUTO_LAUNCH = env.MoonHubAutoLaunch == true
env.MoonHubAutoLaunch = nil
local TESTER = type(env.MoonHubTester) == "string" and env.MoonHubTester ~= "" and env.MoonHubTester or nil
env.MoonHubTester = nil
env.MoonHubKeyBeta = nil
local OWNER = false
local FROM_HUB = type(EMBEDDED) == "table" and type(env.MoonHub) == "table" and env.MoonHub.Running == true
if FROM_HUB and not TESTER and env.MoonHubChannel == "beta" and type(env.MoonHubKey) == "string" and env.MoonHubKey ~= "" then
    TESTER = env.MoonHubKey
end
local function hardwareId()
    local id
    if type(gethwid) == "function" then
        local ok, value = pcall(gethwid)
        id = ok and value or nil
    end
    if not id then
        local ok, value = pcall(function()
            return game:GetService("RbxAnalyticsService"):GetClientId()
        end)
        id = ok and value or nil
    end
    id = tostring(id or player.UserId)
    id = string.gsub(id, "[^%w_%-{}]", "")
    return string.sub(id, 1, 128)
end
local HWID = hardwareId()
local function get(path)
    local ok, body = pcall(function()
        return game:HttpGet(API .. path)
    end)
    return ok and body or nil
end
local function decode(body)
    local ok, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    return ok and type(data) == "table" and data or nil
end
local function readJSON(path)
    local ok, text = pcall(function()
        return CAN_FILES and isfile(path) and readfile(path) or nil
    end)
    return ok and type(text) == "string" and decode(text) or nil
end
local function writeJSON(path, data)
    pcall(function()
        if type(isfolder) == "function" and not isfolder("MoonHub") then
            makefolder("MoonHub")
        end
        writefile(path, HttpService:JSONEncode(data))
    end)
end
local rememberKey
local function verify(key, entry)
    if PREVIEW then
        return key == DEMO_KEY, key == DEMO_KEY and "" or "Invalid key", math.huge, key == DEMO_KEY and "" or "invalid", "moon"
    end
    local data = decode(get("/verify?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(HWID) .. gameParam(entry)))
    if not data then
        return false, "Can't reach the key server, try again", nil, "network"
    end
    local reasons = {invalid = "Invalid key", revoked = "This key was revoked", hwid = "This key belongs to another device",
        expired = "Key expired: get a new one", rate = "Too many tries, wait a minute",
        scope = "This key is for other Moon Hub games: get a key for this game",
        disabled = tostring(data.message or "This game is paused in Moon Hub right now")}
    local left = tonumber(data.expires) == 0 and math.huge or (tonumber(data.expires) and (tonumber(data.expires) / 1000 - os.time()) or nil)
    local scope = scopeOf({producer = data.scope})
    OWNER = data.ok == true and data.owner == true
    if data.ok == true and rememberKey then
        rememberKey(key, left, scope)
    end
    if data.ok == true then
        env.MoonHubKeyBeta = data.beta == true or nil
        pcall(function()
            local mark = "MoonHub/key_beta" .. ((scope and scope ~= "moon") and ("_" .. scope) or "") .. ".txt"
            if data.beta == true then
                writefile(mark, key)
            elseif isfile(mark) and readfile(mark) == key and type(delfile) == "function" then
                delfile(mark)
            end
        end)
    end
    return data.ok == true, data.ok and "" or (reasons[data.reason] or "Key refused"), left, tostring(data.reason or ""), scope
end
local function readKey(scope)
    local ok, key = pcall(function()
        local path = keyFileOf(scope)
        return CAN_FILES and isfile(path) and readfile(path) or nil
    end)
    return ok and type(key) == "string" and string.match(key, "MOON%-[%w]+%-[%w]+%-[%w]+") or nil
end
local function saveKey(key, scope)
    pcall(function()
        if type(isfolder) == "function" and not isfolder("MoonHub") then
            makefolder("MoonHub")
        end
        writefile(keyFileOf(scope), key)
    end)
end
local function forgetKey(scope)
    pcall(function()
        local path = keyFileOf(scope)
        if CAN_FILES and type(delfile) == "function" and isfile(path) then
            delfile(path)
        end
    end)
end
local function hoursLeft(seconds)
    seconds = tonumber(seconds)
    if seconds == math.huge then
        return "no expiry"
    elseif not seconds or seconds <= 0 then
        return "active"
    elseif seconds >= 2 * 86400 then
        return string.format("%dd %dh", math.floor(seconds / 86400), math.floor(seconds % 86400 / 3600))
    end
    return string.format("%dh %02dm", math.floor(seconds / 3600), math.floor(seconds % 3600 / 60))
end
local MONTHS = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"}
local function shortDate(value)
    local _, month, day = string.match(tostring(value or ""), "^(%d+)%-(%d+)%-(%d+)")
    return month and ((MONTHS[tonumber(month)] or month) .. " " .. tonumber(day)) or tostring(value or "-")
end
local FALLBACK_STATUS = {
    state = "operational",
    message = "",
    games = {{id = "aotr", name = "Attack on Titan Revolution", short = "AOTR", creatorIds = {17347863}, placeIds = {13379208636, 14916516914},
        status = "working", notes = "Missions, raids, Waves, lobby and account automation"},
        {id = "universal", name = "Universal", short = "UNI", universal = true, private = true, script = "universal", status = "working",
            notes = "Fly, ESP, aim assist, teleports and open source tools for any game"}},
    news = {},
    changelog = {},
}
local function normalize(data)
    data.games = type(data.games) == "table" and data.games or {}
    data.news = type(data.news) == "table" and data.news or {}
    data.changelog = type(data.changelog) == "table" and data.changelog or {}
    return data
end
local function fetchStatus(key)
    local data
    if PREVIEW then
        data = readJSON("MoonHub/status.json")
    else
        data = decode(get("/status" .. ((type(key) == "string" and key ~= "") and ("?key=" .. HttpService:UrlEncode(key)) or "")))
    end
    if type(data) ~= "table" or type(data.games) ~= "table" then
        return normalize(readJSON(STATUS_CACHE) or FALLBACK_STATUS), false
    end
    writeJSON(STATUS_CACHE, data)
    return normalize(data), true
end
local function detectGame(status)
    local placeId, creatorId, universeId = game.PlaceId, game.CreatorId, 0
    pcall(function()
        universeId = game.GameId
    end)
    for _, id in ipairs(type(status) == "table" and type(status.blockedPlaces) == "table" and status.blockedPlaces or {}) do
        if tonumber(id) == placeId or tonumber(id) == universeId then
            return nil
        end
    end
    for _, entry in ipairs(type(status) == "table" and type(status.games) == "table" and status.games or {}) do
        if type(entry) == "table" and entry.status ~= "removed" and (entry.private ~= true or OWNER) then
            for _, pair in ipairs({{entry.placeIds, placeId}, {entry.creatorIds, creatorId}, {entry.universeIds, universeId}}) do
                for _, id in ipairs(type(pair[1]) == "table" and pair[1] or {}) do
                    if tonumber(id) == pair[2] then
                        return entry
                    end
                end
            end
        end
    end
    for _, entry in ipairs(type(status) == "table" and type(status.games) == "table" and status.games or {}) do
        if type(entry) == "table" and entry.universal == true and (entry.private ~= true or OWNER) then
            return entry
        end
    end
    return nil
end
local LAST_BUILD = nil
local function buildInfo(entry)
    local build = tonumber(game.PlaceVersion) or 0
    local tested = entry and type(entry.testedBuilds) == "table" and tonumber(entry.testedBuilds[tostring(game.PlaceId)])
    if tested then
        if build > tested then
            return build, "warn", "Game updated after the last script update"
        end
        return build, "good", "Tested on this game build"
    end
    if LAST_BUILD == nil then
        local builds = readJSON("MoonHub/builds.json") or {}
        LAST_BUILD = tonumber(builds[tostring(game.PlaceId)]) or false
        builds[tostring(game.PlaceId)] = build
        writeJSON("MoonHub/builds.json", builds)
    end
    local last = LAST_BUILD or nil
    if last and build > last then
        return build, "warn", "Game updated since your last session"
    elseif last then
        return build, "good", "No game update since your last session"
    end
    return build, "info", "First session on this game"
end
local function executorInfo()
    local name = "Unknown executor"
    if type(identifyexecutor) == "function" then
        local ok, executor, version = pcall(identifyexecutor)
        if ok and executor then
            name = tostring(executor) .. ((version and tostring(version) ~= "") and (" " .. tostring(version)) or "")
        end
    end
    local missing = {}
    local checks = {
        {"request", (type(syn) == "table" and syn.request) or http_request or request},
        {"queue_on_teleport", (type(syn) == "table" and syn.queue_on_teleport) or queue_on_teleport},
        {"run_on_actor", run_on_actor},
        {"gethui", gethui},
        {"writefile", writefile},
    }
    for _, check in ipairs(checks) do
        if type(check[2]) ~= "function" then
            table.insert(missing, check[1])
        end
    end
    return name, missing
end
local function webGet(url)
    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    return ok and body or nil
end
local function shortCount(value)
    value = tonumber(value)
    if not value then
        return "-"
    elseif value >= 1e6 then
        return string.format("%.2fM", value / 1e6)
    elseif value >= 1e4 then
        return string.format("%.1fK", value / 1e3)
    elseif value >= 1e3 then
        return string.format("%.2fK", value / 1e3)
    end
    return tostring(math.floor(value))
end
local function fetchPlaying(games, current)
    local cache = readJSON(UNIVERSE_CACHE) or {}
    local changed, ids, byEntry = false, {}, {}
    local here = 0
    pcall(function()
        here = tonumber(game.GameId) or 0
    end)
    for _, entry in ipairs(games) do
        if type(entry) == "table" then
            local id = type(entry.universeIds) == "table" and tonumber(entry.universeIds[1]) or nil
            local place = type(entry.placeIds) == "table" and tonumber(entry.placeIds[1]) or nil
            if not id and entry == current and here > 0 then
                id = here
            end
            if not id and place then
                id = tonumber(cache[tostring(place)])
                if not id then
                    local data = decode(webGet("https://apis.roblox.com/universes/v1/places/" .. place .. "/universe"))
                    id = data and tonumber(data.universeId)
                    if id then
                        cache[tostring(place)], changed = id, true
                    end
                end
            end
            if id then
                byEntry[entry] = id
                table.insert(ids, id)
            end
        end
    end
    if here > 0 and not table.find(ids, here) then
        table.insert(ids, here)
    end
    if changed then
        writeJSON(UNIVERSE_CACHE, cache)
    end
    if #ids == 0 then
        return {}, nil
    end
    local data = decode(webGet("https://games.roblox.com/v1/games?universeIds=" .. table.concat(ids, ",")))
    local byId = {}
    for _, row in ipairs(data and type(data.data) == "table" and data.data or {}) do
        if type(row) == "table" and tonumber(row.id) then
            byId[tonumber(row.id)] = tonumber(row.playing)
        end
    end
    local result = {}
    for entry, id in pairs(byEntry) do
        result[entry] = byId[id]
    end
    return result, byId[current and byEntry[current] or here] or byId[here]
end
local CACHE_DIR = "MoonHub/cache"
local KEY_META = "MoonHub/key_meta.json"
local function ensureCacheDir()
    pcall(function()
        if type(isfolder) == "function" and not isfolder(CACHE_DIR) then
            if not isfolder("MoonHub") then
                makefolder("MoonHub")
            end
            makefolder(CACHE_DIR)
        end
    end)
end
local function hubCachePath(gameId, channel)
    return CACHE_DIR .. "/hub_" .. tostring(gameId) .. "_" .. tostring(channel) .. ".lua"
end
local function readCachedHub(gameId, channel)
    local path = hubCachePath(gameId, channel)
    local meta = readJSON(path .. ".json")
    local ok, source = pcall(function()
        return CAN_FILES and isfile(path) and readfile(path) or nil
    end)
    if not ok or type(source) ~= "string" or type(meta) ~= "table" or tonumber(meta.len) ~= #source then
        return nil
    end
    local version = string.match(string.sub(source, 1, 400), 'local VERSION = "([^"]+)"')
    return version and version == meta.version and source or nil
end
local function writeCachedHub(gameId, channel, source)
    local version = string.match(string.sub(source, 1, 400), 'local VERSION = "([^"]+)"')
    if not CAN_FILES or not version then
        return
    end
    ensureCacheDir()
    pcall(function()
        local path = hubCachePath(gameId, channel)
        writefile(path, source)
        writeJSON(path .. ".json", {version = version, len = #source, at = os.time()})
    end)
end
local function keyMetaOf(scope)
    return (scope and scope ~= "moon") and ("MoonHub/key_meta_" .. scope .. ".json") or KEY_META
end
local function trustedKey(key, scope)
    local meta = readJSON(keyMetaOf(scope))
    local expires = type(meta) == "table" and tonumber(meta.expires)
    if type(meta) ~= "table" or meta.key ~= key or meta.hwid ~= HWID or not expires or os.time() - (tonumber(meta.checked) or 0) > 1800 then
        return false
    end
    OWNER = meta.owner == true
    env.MoonHubKeyBeta = nil
    pcall(function()
        local mark = "MoonHub/key_beta" .. ((scope and scope ~= "moon") and ("_" .. scope) or "") .. ".txt"
        env.MoonHubKeyBeta = (CAN_FILES and isfile(mark) and readfile(mark) == key) or nil
    end)
    if expires == 0 then
        return true, math.huge
    end
    local left = expires / 1000 - os.time()
    return left > 300, left
end
function rememberKey(key, left, scope)
    writeJSON(keyMetaOf(scope), {key = key, hwid = HWID, checked = os.time(), owner = OWNER or nil,
        expires = (tonumber(left) == math.huge or not tonumber(left)) and 0 or math.floor((os.time() + tonumber(left)) * 1000)})
end
local function launch(key, entry, left)
    local source
    if not PREVIEW and type(EMBEDDED) ~= "table" then
        local latest = readJSON(STATUS_CACHE)
        if type(latest) == "table" and type(latest.games) == "table" and not detectGame(latest) then
            return false, "Moon Hub isn't available for this game"
        end
    end
    local gameId = entry and tostring(entry.script or entry.id) or "aotr"
    env.MoonHubScope = scopeOf(entry)
    env.MoonHubKeyFile, env.MoonHubKeyMeta = keyFileOf(env.MoonHubScope), keyMetaOf(env.MoonHubScope)
    env.MoonHubKeyExpires = (tonumber(left) == math.huge or not tonumber(left)) and 0 or (os.time() + math.floor(tonumber(left)))
    if type(EMBEDDED) == "table" and not EMBEDDED.Reload then
        env.MoonHubKey, env.MoonHubHwid, env.MoonHubGame = key, HWID, gameId
        EMBEDDED.Done, EMBEDDED.Go = true, true
        return true
    end
    if PREVIEW then
        local ok, value = pcall(function()
            return CAN_FILES and isfile(LOCAL_HUB) and readfile(LOCAL_HUB) or nil
        end)
        source = ok and value or nil
        if type(source) ~= "string" then
            return false, "Preview: put Moon Hub.lua into workspace/MoonHub to start it from here"
        end
    else
        local channel = (TESTER or env.MoonHubKeyBeta) and "beta" or "stable"
        source = AUTO_LAUNCH and readCachedHub(gameId, channel) or nil
        if source then
            env.MoonHubFromCache = true
        else
            source = get("/script?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(HWID) .. "&game="
                .. HttpService:UrlEncode(gameId) .. "&channel=" .. ((TESTER or env.MoonHubKeyBeta) and "beta" or "stable")
                .. "&t=" .. tostring(os.time()) .. tostring(math.random(1000, 9999)))
            if type(source) == "string" and string.find(source, "local VERSION", 1, true) then
                writeCachedHub(gameId, channel, source)
            end
        end
    end
    if type(source) ~= "string" or not string.find(source, "local VERSION", 1, true) then
        return false, "Couldn't download Moon Hub, try again"
    end
    local deferred = AUTO_LAUNCH and not PREVIEW
    local chunk, err
    if not deferred then
        chunk, err = loadstring(source)
        if not chunk then
            return false, "Download broken: " .. tostring(err)
        end
    end
    env.MoonHubKey, env.MoonHubHwid, env.MoonHubChannel, env.MoonHubGame = key, HWID, (TESTER or env.MoonHubKeyBeta) and "beta" or "stable", gameId
    env.MoonHubPrivate = entry and entry.private == true or nil
    env.MoonHubFromLauncher = true
    env.MoonHubKeyCheckedAt = os.time()
    if not PREVIEW then
        local loaderCache = CACHE_DIR .. "/loader.lua"
        env.MoonHubLoaderCode = (TESTER and ("getgenv().MoonHubTester = " .. string.format("%q", TESTER) .. "\n") or "")
            .. "local p, s = " .. string.format("%q", loaderCache) .. ", nil\n"
            .. "pcall(function() if isfile(p) and isfile(p .. '.t') and os.time() - tonumber(readfile(p .. '.t')) < 21600 then s = readfile(p) end end)\n"
            .. "if not s then s = game:HttpGet(" .. string.format("%q", API .. "/loader") .. ") pcall(function() if not isfolder('MoonHub') then makefolder('MoonHub') end "
            .. "if not isfolder('MoonHub/cache') then makefolder('MoonHub/cache') end writefile(p, s) writefile(p .. '.t', tostring(os.time())) end) end\n"
            .. "loadstring(s)()"
    end
    if deferred then
        task.spawn(function()
            if not game:IsLoaded() then
                game.Loaded:Wait()
            end
            local deadline = os.clock() + 8
            while not player.Character and os.clock() < deadline do
                task.wait(0.2)
            end
            task.wait(0.5)
            local late, lateErr = loadstring(source)
            if late then
                late()
            else
                warn("[Moon Hub] cached copy broken: " .. tostring(lateErr))
                pcall(function()
                    local path = hubCachePath(gameId, (TESTER or env.MoonHubKeyBeta) and "beta" or "stable")
                    delfile(path)
                    delfile(path .. ".json")
                end)
            end
        end)
        return true
    end
    task.spawn(chunk)
    return true
end
local Theme = {
    Background = Color3.fromRGB(13, 14, 18),
    Surface = Color3.fromRGB(17, 18, 23),
    Card = Color3.fromRGB(21, 22, 28),
    Element = Color3.fromRGB(28, 29, 36),
    ElementHover = Color3.fromRGB(36, 37, 46),
    Stroke = Color3.fromRGB(44, 45, 56),
    StrokeSoft = Color3.fromRGB(31, 32, 40),
    Divider = Color3.fromRGB(37, 38, 48),
    Text = Color3.fromRGB(236, 237, 243),
    SubText = Color3.fromRGB(150, 153, 168),
    Muted = Color3.fromRGB(98, 101, 117),
    Off = Color3.fromRGB(46, 47, 59),
    Success = Color3.fromRGB(62, 207, 142),
    Danger = Color3.fromRGB(240, 96, 104),
    Warning = Color3.fromRGB(245, 180, 60),
    Accent = Color3.fromRGB(124, 108, 255),
}
local STATES = {
    working = {Theme.Success, "WORKING"}, operational = {Theme.Success, "OPERATIONAL"}, good = {Theme.Success, "OK"},
    updating = {Theme.Warning, "UPDATING"}, degraded = {Theme.Warning, "DEGRADED"}, warn = {Theme.Warning, "CHECK"},
    down = {Theme.Danger, "DOWN"}, patched = {Theme.Danger, "PATCHED"}, offline = {Theme.Muted, "OFFLINE"},
    soon = {Theme.Muted, "SOON"}, unsupported = {Theme.Muted, "NOT SUPPORTED"}, info = {Theme.SubText, "INFO"},
}
local function stateOf(name)
    return STATES[string.lower(tostring(name or ""))] or STATES.info
end
local function guiParent()
    if type(gethui) == "function" then
        local ok, container = pcall(gethui)
        if ok and typeof(container) == "Instance" then
            return container
        end
    end
    local ok, core = pcall(function()
        return game:GetService("CoreGui")
    end)
    return ok and core or player:WaitForChild("PlayerGui")
end
local function new(class, props, children)
    local instance = Instance.new(class)
    for key, value in pairs(props or {}) do
        if key ~= "Parent" then
            instance[key] = value
        end
    end
    for _, child in ipairs(children or {}) do
        child.Parent = instance
    end
    instance.Parent = props and props.Parent
    return instance
end
local function corner(radius)
    return new("UICorner", {CornerRadius = UDim.new(0, radius)})
end
local function stroke(color, thickness)
    return new("UIStroke", {Color = color or Theme.StrokeSoft, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
local function padding(top, right, bottom, left)
    return new("UIPadding", {PaddingTop = UDim.new(0, top), PaddingRight = UDim.new(0, right), PaddingBottom = UDim.new(0, bottom),
        PaddingLeft = UDim.new(0, left)})
end
local function list(gap, horizontal)
    return new("UIListLayout", {Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical})
end
local function tween(instance, duration, goal)
    local t = TweenService:Create(instance, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), goal)
    t:Play()
    return t
end
local function text(parent, props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.Gotham
    props.TextSize = props.TextSize or 13
    props.TextColor3 = props.TextColor3 or Theme.Text
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    props.Parent = parent
    return new("TextLabel", props)
end
local function caption(parent, value, props)
    props = props or {}
    props.Text = string.upper(value)
    props.Font = Enum.Font.GothamBold
    props.TextSize = 10
    props.TextColor3 = Theme.Muted
    return text(parent, props)
end
local LOGO_PNG = "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"
local logoAsset
local function base64decode(data)
    if type(crypt) == "table" and type(crypt.base64decode) == "function" then
        local ok, out = pcall(crypt.base64decode, data)
        if ok and type(out) == "string" and #out > 0 then
            return out
        end
    end
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, 64 do
        lookup[alphabet:byte(i)] = i - 1
    end
    local out, buffer, bits = {}, 0, 0
    for i = 1, #data do
        local v = lookup[data:byte(i)]
        if v then
            buffer, bits = buffer * 64 + v, bits + 6
            if bits >= 8 then
                bits = bits - 8
                out[#out + 1] = string.char(math.floor(buffer / 2 ^ bits) % 256)
                buffer = buffer % 2 ^ bits
            end
        end
    end
    return table.concat(out)
end
local function getLogoAsset()
    if logoAsset == nil then
        logoAsset = false
        local load = getcustomasset or getsynasset
        if CAN_FILES and type(load) == "function" then
            local ok, asset = pcall(function()
                if type(isfolder) == "function" and not isfolder("MoonHub") then
                    makefolder("MoonHub")
                end
                writefile("MoonHub/logo.png", base64decode(LOGO_PNG))
                return load("MoonHub/logo.png")
            end)
            if ok and type(asset) == "string" and asset ~= "" then
                logoAsset = asset
            end
        end
    end
    return logoAsset or nil
end
local function logo(parent, size, position)
    local badge = new("Frame", {Size = UDim2.fromOffset(size, size), Position = position, BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, Parent = parent}, {corner(math.floor(size * 0.28))})
    local asset = getLogoAsset()
    if asset then
        new("ImageLabel", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromScale(0.86, 0.86),
            BackgroundTransparency = 1, Image = asset, ScaleType = Enum.ScaleType.Fit, ZIndex = 2, Parent = badge})
        return badge
    end
    local moon = math.floor(size * 0.5)
    new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5), Size = UDim2.fromOffset(moon, moon),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, ZIndex = 2, Parent = badge}, {corner(moon)})
    new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, math.floor(moon * 0.34), 0.5, -math.floor(moon * 0.24)),
        Size = UDim2.fromOffset(math.floor(moon * 0.84), math.floor(moon * 0.84)), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0,
        ZIndex = 3, Parent = badge}, {corner(moon)})
    return badge
end
local function pill(parent, props)
    local frame = new("Frame", {
        Name = props.Name or "Pill",
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        LayoutOrder = props.LayoutOrder,
        AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.fromOffset(0, 22),
        BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0,
        Parent = parent,
    }, {corner(11), padding(0, 10, 0, 22)})
    local dot = new("Frame", {Size = UDim2.fromOffset(6, 6), Position = UDim2.new(0, -13, 0.5, -3), BorderSizePixel = 0, Parent = frame},
        {corner(3)})
    local label = text(frame, {Name = "PillText", Font = Enum.Font.GothamBold, TextSize = 10, AutomaticSize = Enum.AutomaticSize.X,
        Size = UDim2.new(0, 0, 1, 0)})
    local function set(stateName, custom)
        local state = stateOf(stateName)
        dot.BackgroundColor3 = state[1]
        label.TextColor3 = state[1]
        label.Text = custom or state[2]
        frame.BackgroundColor3 = state[1]
        frame.BackgroundTransparency = 0.88
    end
    set(props.State)
    return {Frame = frame, Set = set, Label = label}
end
local function button(parent, props)
    local primary = props.Primary
    local frame = new("TextButton", {
        Name = props.Name,
        Text = props.Text,
        Font = primary and Enum.Font.GothamBold or Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = primary and Color3.new(1, 1, 1) or Theme.Text,
        AutoButtonColor = false,
        BackgroundColor3 = primary and Theme.Accent or Theme.Element,
        AnchorPoint = props.AnchorPoint,
        Position = props.Position,
        Size = props.Size,
        LayoutOrder = props.LayoutOrder,
        Parent = parent,
    }, {corner(8)})
    if not primary then
        stroke(Theme.Stroke).Parent = frame
    end
    frame.MouseEnter:Connect(function()
        tween(frame, 0.12, primary and {BackgroundTransparency = 0.12} or {BackgroundColor3 = Theme.ElementHover})
    end)
    frame.MouseLeave:Connect(function()
        tween(frame, 0.12, primary and {BackgroundTransparency = 0} or {BackgroundColor3 = Theme.Element})
    end)
    return frame
end
local ICONS = {
    home = {{"L", 2.5, 8, 8, 2.5}, {"L", 8, 2.5, 13.5, 8}, {"O", 4, 7, 8, 7.5, 1.5}},
    games = {{"O", 2, 2, 5.5, 5.5, 1.5}, {"O", 8.5, 2, 5.5, 5.5, 1.5}, {"O", 2, 8.5, 5.5, 5.5, 1.5}, {"O", 8.5, 8.5, 5.5, 5.5, 1.5}},
    updates = {{"C", 3, 4, 2.4}, {"L", 6.5, 4, 14, 4}, {"C", 3, 8, 2.4}, {"L", 6.5, 8, 14, 8}, {"C", 3, 12, 2.4}, {"L", 6.5, 12, 11.5, 12}},
    key = {{"G", 5.5, 8, 7}, {"L", 9, 8, 14, 8}, {"L", 12, 8, 12, 11}, {"L", 14, 8, 14, 10.5}},
    farm = {{"L", 3.5, 12.5, 12.5, 3.5}, {"L", 3.5, 8.5, 7.5, 12.5}, {"L", 12.5, 3.5, 13.5, 2.5, 2}},
    missions = {{"G", 8, 8, 14}, {"G", 8, 8, 8}, {"C", 8, 8, 2.8}},
    raids = {{"L", 2.5, 12.5, 13.5, 12.5}, {"L", 2.5, 12.5, 3, 5}, {"L", 3, 5, 6, 8.5}, {"L", 6, 8.5, 8, 3.5}, {"L", 8, 3.5, 10, 8.5},
        {"L", 10, 8.5, 13, 5}, {"L", 13, 5, 13.5, 12.5}},
    waves = {{"L", 2, 6, 5, 4}, {"L", 5, 4, 8, 6}, {"L", 8, 6, 11, 4}, {"L", 11, 4, 14, 6}, {"L", 2, 11, 5, 9}, {"L", 5, 9, 8, 11},
        {"L", 8, 11, 11, 9}, {"L", 11, 9, 14, 11}},
    player = {{"G", 8, 5, 6}, {"O", 3, 9.5, 10, 6, 3}},
    esp = {{"O", 1.5, 4, 13, 8, 4}, {"C", 8, 8, 3.6}},
    teleport = {{"L", 3, 5, 13, 5}, {"L", 10, 2.5, 13, 5}, {"L", 10, 7.5, 13, 5}, {"L", 13, 11, 3, 11}, {"L", 6, 8.5, 3, 11}, {"L", 6, 13.5, 3, 11}},
    misc = {{"L", 2, 4, 14, 4}, {"C", 10, 4, 3.8}, {"L", 2, 8, 14, 8}, {"C", 5, 8, 3.8}, {"L", 2, 12, 14, 12}, {"C", 11, 12, 3.8}},
    lobby = {{"O", 2.5, 5.5, 11, 9, 1.5}, {"O", 5.5, 1.5, 5, 6, 2.5}},
    family = {{"G", 5.5, 5, 4.5}, {"O", 2, 9, 7, 6, 2.5}, {"G", 11, 5, 4.5}, {"O", 7.5, 9, 7, 6, 2.5}},
    stats = {{"R", 2.5, 9, 3, 5, 0.8}, {"R", 6.5, 5.5, 3, 8.5, 0.8}, {"R", 10.5, 2.5, 3, 11.5, 0.8}},
    performance = {{"L", 9.5, 1.5, 4.5, 9}, {"L", 4.5, 9, 8.5, 9}, {"L", 8.5, 9, 7, 14.5}, {"L", 7, 14.5, 12, 7}, {"L", 12, 7, 8, 7},
        {"L", 8, 7, 9.5, 1.5}},
    security = {{"L", 8, 2, 13, 4}, {"L", 13, 4, 12.5, 9}, {"L", 12.5, 9, 8, 14}, {"L", 8, 14, 3.5, 9}, {"L", 3.5, 9, 3, 4}, {"L", 3, 4, 8, 2}},
    settings = {{"G", 8, 8, 9}, {"C", 8, 8, 2.6}},
}
for index = 0, 7 do
    local angle = math.rad(index * 45)
    table.insert(ICONS.settings, {"L", 8 + math.cos(angle) * 5.3, 8 + math.sin(angle) * 5.3, 8 + math.cos(angle) * 7.2, 8 + math.sin(angle) * 7.2, 2.4})
end
local function drawIcon(parent, name, size, color, props)
    local holder = Instance.new("Frame")
    holder.Name = "Icon"
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.fromOffset(size, size)
    for key, value in pairs(props or {}) do
        holder[key] = value
    end
    local k = size / 16
    local fills, strokes = {}, {}
    local function part(x, y, w, h, radius, filled, thickness)
        local frame = Instance.new("Frame")
        frame.BorderSizePixel = 0
        frame.Position = UDim2.fromOffset(x * k, y * k)
        frame.Size = UDim2.fromOffset(math.max(1, w * k), math.max(1, h * k))
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0, math.max(0, radius * k))
        corner.Parent = frame
        if filled then
            frame.BackgroundColor3 = color
            table.insert(fills, frame)
        else
            frame.BackgroundTransparency = 1
            local stroke = Instance.new("UIStroke")
            stroke.Thickness = math.max(1, thickness * k)
            stroke.Color = color
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = frame
            table.insert(strokes, stroke)
        end
        frame.Parent = holder
        return frame
    end
    for _, cmd in ipairs(ICONS[name] or {}) do
        local kind = cmd[1]
        if kind == "L" then
            local x1, y1, x2, y2, width = cmd[2], cmd[3], cmd[4], cmd[5], cmd[6] or 1.6
            local dx, dy = x2 - x1, y2 - y1
            local frame = part(0, 0, math.sqrt(dx * dx + dy * dy) + width, width, width / 2, true)
            frame.AnchorPoint = Vector2.new(0.5, 0.5)
            frame.Position = UDim2.fromOffset((x1 + x2) / 2 * k, (y1 + y2) / 2 * k)
            frame.Rotation = math.deg(math.atan2(dy, dx))
        elseif kind == "O" then
            local t = cmd[7] or 1.6
            part(cmd[2] + t, cmd[3] + t, cmd[4] - 2 * t, cmd[5] - 2 * t, math.max(0, (cmd[6] or 2) - t), false, t)
        elseif kind == "G" then
            local d, t = cmd[4], cmd[5] or 1.6
            part(cmd[2] - d / 2 + t, cmd[3] - d / 2 + t, d - 2 * t, d - 2 * t, d, false, t)
        elseif kind == "C" then
            local d = cmd[4]
            part(cmd[2] - d / 2, cmd[3] - d / 2, d, d, d, true)
        elseif kind == "R" then
            part(cmd[2], cmd[3], cmd[4], cmd[5], cmd[6] or 1, true)
        end
    end
    holder.Parent = parent
    return {
        Frame = holder,
        SetColor = function(value)
            for _, frame in ipairs(fills) do
                frame.BackgroundColor3 = value
            end
            for _, stroke in ipairs(strokes) do
                stroke.Color = value
            end
        end,
    }
end
local function imageFallback(image, initials, textSize)
    local fallback = new("TextLabel", {Name = "Fallback", Text = initials, Font = Enum.Font.GothamBold, TextSize = textSize,
        TextColor3 = Color3.new(1, 1, 1), BackgroundColor3 = Theme.Accent, Size = UDim2.fromScale(1, 1), ZIndex = 1, Parent = image},
        {new("UICorner", {CornerRadius = UDim.new(0.5, 0)})})
    image.ZIndex = 2
    task.spawn(function()
        for _ = 1, 40 do
            local ok, loaded = pcall(function()
                return image.IsLoaded
            end)
            if ok and loaded and image.Image ~= "" then
                fallback.Visible = false
                return
            end
            task.wait(0.25)
        end
    end)
    return fallback
end
local function initialsOf(value)
    local out = ""
    for word in string.gmatch(tostring(value or ""), "%u%w*") do
        out = out .. string.sub(word, 1, 1)
    end
    out = string.sub(out, 1, 3)
    return out ~= "" and out or string.upper(string.sub(tostring(value or "?"), 1, 1))
end
local function remoteImage(image, kind, id)
    id = tonumber(id) or 0
    if id <= 0 then
        return
    end
    local api = kind == "game" and ("https://thumbnails.roblox.com/v1/games/icons?universeIds=" .. id .. "&size=150x150&format=Png&isCircular=false")
        or ("https://thumbnails.roblox.com/v1/users/avatar-headshot?userIds=" .. id .. "&size=150x150&format=Png&isCircular=false")
    image.Image = kind == "game" and ("rbxthumb://type=GameIcon&id=" .. id .. "&w=150&h=150")
        or ("rbxthumb://type=AvatarHeadShot&id=" .. id .. "&w=150&h=150")
    local custom = getcustomasset or getsynasset
    if type(custom) ~= "function" or type(writefile) ~= "function" then
        return
    end
    task.spawn(function()
        local path = "MoonHub/cache/" .. kind .. "_" .. id .. ".png"
        pcall(function()
            if type(isfolder) == "function" and not isfolder("MoonHub/cache") then
                if not isfolder("MoonHub") then
                    makefolder("MoonHub")
                end
                makefolder("MoonHub/cache")
            end
        end)
        local fresh = false
        pcall(function()
            local stamp = isfile(path .. ".time") and tonumber(readfile(path .. ".time"))
            fresh = isfile(path) and stamp and os.time() - stamp < 86400
        end)
        local function note(text)
            pcall(function()
                local old = isfile("MoonHub/cache/thumb_log.txt") and readfile("MoonHub/cache/thumb_log.txt") or ""
                writefile("MoonHub/cache/thumb_log.txt", string.sub(old, -4000) .. os.date("%H:%M:%S") .. "  " .. kind .. " " .. id .. "  " .. text .. "\n")
            end)
        end
        local function fetch(url)
            local ok, body = pcall(function()
                return game:HttpGet(url)
            end)
            if ok and type(body) == "string" and body ~= "" then
                return body, "HttpGet"
            end
            local send = (type(syn) == "table" and syn.request) or http_request or request
            if type(send) == "function" then
                local okRequest, response = pcall(send, {Url = url, Method = "GET"})
                if okRequest and type(response) == "table" and type(response.Body) == "string" and response.Body ~= "" then
                    return response.Body, "request"
                end
                return nil, "request failed: " .. tostring(okRequest and (type(response) == "table" and response.StatusCode) or response)
            end
            return nil, "HttpGet failed: " .. tostring(body)
        end
        if not fresh then
            local url
            for attempt = 1, 5 do
                local body, how = fetch(api)
                local okInfo, info = pcall(function()
                    return HttpService:JSONDecode(body)
                end)
                local row = okInfo and type(info) == "table" and type(info.data) == "table" and info.data[1] or nil
                if type(row) == "table" and type(row.imageUrl) == "string" and row.imageUrl ~= "" then
                    url = row.imageUrl
                    break
                end
                note("api attempt " .. attempt .. " (" .. tostring(how) .. "): " .. (type(row) == "table" and ("state " .. tostring(row.state))
                    or string.sub(tostring(body), 1, 120)))
                task.wait(1.5)
            end
            if not url then
                return
            end
            local bytes, how = fetch(url)
            local server = (type(EMBEDDED) == "table" and EMBEDDED.Api) or (API ~= "" and API) or nil
            if (type(bytes) ~= "string" or #bytes < 64) and type(server) == "string" and server ~= "" then
                note("direct download failed (" .. tostring(how) .. "), trying the Moon Hub server")
                bytes, how = fetch(server .. "/thumb?kind=" .. kind .. "&id=" .. id)
            end
            if type(bytes) ~= "string" or #bytes < 64 then
                note("image download failed (" .. tostring(how) .. ")")
                return
            end
            local okWrite, writeError = pcall(writefile, path, bytes)
            pcall(writefile, path .. ".time", tostring(os.time()))
            note("saved " .. #bytes .. " bytes via " .. tostring(how) .. (okWrite and "" or (" WRITE ERROR " .. tostring(writeError))))
        end
        local okAsset, asset = pcall(custom, path)
        if okAsset and type(asset) == "string" and asset ~= "" then
            image.Image = asset
        else
            note("getcustomasset failed: " .. tostring(asset))
        end
    end)
end
local function card(parent, props)
    props.BackgroundColor3 = Theme.Card
    props.BorderSizePixel = 0
    props.Parent = parent
    return new("Frame", props, {corner(12), stroke(Theme.StrokeSoft)})
end
local camera = workspace.CurrentCamera
local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
local WIDTH, HEIGHT = 800, 520
local scale = math.clamp(math.min((viewport.X - 24) / WIDTH, (viewport.Y - 24) / HEIGHT), 0.5, 1.1)
if type(EMBEDDED) ~= "table" then
    local previous = env.MoonHubLauncherScreen
    if typeof(previous) == "Instance" and previous.Parent then
        return
    end
end
local screen = new("ScreenGui", {Name = HttpService:GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 1000,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = guiParent()})
env.MoonHubLauncherScreen = screen
if type(EMBEDDED) == "table" and type(EMBEDDED.Track) == "function" then
    pcall(EMBEDDED.Track, screen)
end
local function toast(message, actionText)
    local box = new("Frame", {Name = "Toast", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, -80),
        Size = UDim2.fromOffset(actionText and 420 or 340, 56), BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, ClipsDescendants = true,
        Parent = screen}, {corner(12), stroke(Theme.Stroke), new("UIScale", {Scale = math.max(scale, 0.8)})})
    logo(box, 30, UDim2.fromOffset(13, 13))
    text(box, {Text = "Moon Hub", Font = Enum.Font.GothamBold, TextSize = 14, Position = UDim2.fromOffset(54, 10),
        Size = UDim2.new(1, actionText and -190 or -66, 0, 18)})
    local line = text(box, {Name = "ToastText", Text = message, TextSize = 11, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(54, 28),
        Size = UDim2.new(1, actionText and -190 or -66, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd})
    local fill = new("Frame", {Size = UDim2.new(0, 0, 0, 2), Position = UDim2.new(0, 0, 1, -2), BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, Parent = box})
    local action = actionText and button(box, {Name = "ToastAction", Text = actionText, AnchorPoint = Vector2.new(1, 0.5),
        Position = UDim2.new(1, -12, 0.5, 0), Size = UDim2.fromOffset(120, 32)}) or nil
    tween(box, 0.35, {Position = UDim2.new(0.5, 0, 0, 18)})
    local function close(delay)
        task.delay(delay or 0, function()
            tween(box, 0.3, {Position = UDim2.new(0.5, 0, 0, -80)})
            task.wait(0.35)
            box:Destroy()
        end)
    end
    return {Line = line, Fill = fill, Action = action, Close = close}
end
do
    local cachedStatus = readJSON(STATUS_CACHE) or FALLBACK_STATUS
    local guess = detectGame(cachedStatus)
    local scope = scopeOf(guess)
    local saved = not FROM_HUB and (TESTER or (AUTO_LAUNCH and readKey(scope)))
    if saved then
        local ok, _, left = trustedKey(saved, scope)
        if not ok then
            ok, _, left = verify(saved, guess)
        end
        local entry = ok and detectGame(cachedStatus)
        if entry and not TESTER and scopeOf(entry) ~= scope then
            entry = nil
        end
        if entry then
            local note = toast("Key valid  •  " .. (left == math.huge and "no expiry" or (hoursLeft(left) .. " left")) .. "  •  loading "
                .. tostring(entry.name))
            tween(note.Fill, 1.6, {Size = UDim2.new(1, 0, 0, 2)})
            local launched, err = launch(saved, entry, left)
            if not launched then
                note.Line.Text, note.Line.TextColor3 = tostring(err), Theme.Danger
            end
            note.Close(launched and 1.8 or 5)
            if launched then
                task.delay(2.4, function()
                    screen:Destroy()
                end)
                return
            end
        end
    end
end
local SIDEBAR = 200
local backdrop = new("Frame", {Name = "Backdrop", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(5, 6, 10),
    BackgroundTransparency = 1, BorderSizePixel = 0, Parent = screen})
local windowScale = new("UIScale", {Scale = scale * 0.96})
local holder = new("Frame", {Name = "LauncherHolder", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 14),
    Size = UDim2.fromOffset(WIDTH, HEIGHT), BackgroundTransparency = 1, Parent = screen}, {windowScale})
for index, layer in ipairs({{6, 0.7}, {14, 0.85}, {26, 0.93}}) do
    new("Frame", {Name = "Shadow" .. index, BackgroundColor3 = Color3.new(0, 0, 0), BackgroundTransparency = layer[2], BorderSizePixel = 0,
        Position = UDim2.new(0, -layer[1], 0, -layer[1] + 6), Size = UDim2.new(1, layer[1] * 2, 1, layer[1] * 2), Parent = holder},
        {corner(14 + layer[1])})
end
local window = new("Frame", {Name = "Launcher", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Theme.Background, BorderSizePixel = 0,
    ClipsDescendants = true, Parent = holder}, {corner(14), stroke(Theme.Stroke)})
new("TextButton", {Name = "MouseUnlock", Text = "", BackgroundTransparency = 1, Size = UDim2.fromOffset(1, 1), Modal = true, Parent = window})
do
    local RunService = game:GetService("RunService")
    local bindName = "MoonLauncherMouse" .. HttpService:GenerateGUID(false)
    local saved = {Behavior = UserInputService.MouseBehavior, Icon = UserInputService.MouseIconEnabled}
    local released = false
    local function release()
        if released then
            return
        end
        released = true
        pcall(function()
            RunService:UnbindFromRenderStep(bindName)
        end)
        local hub = env.MoonHub
        local hubRunning = type(hub) == "table" and hub.Running == true
        pcall(function()
            UserInputService.MouseBehavior = hubRunning and saved.Behavior or (saved.Behavior == Enum.MouseBehavior.LockCenter
                and Enum.MouseBehavior.Default or saved.Behavior)
            UserInputService.MouseIconEnabled = saved.Icon or not hubRunning
        end)
    end
    pcall(function()
        RunService:BindToRenderStep(bindName, 2001, function()
            if not screen.Parent or not holder.Parent then
                release()
                return
            end
            UserInputService.MouseBehavior = Enum.MouseBehavior.Default
            UserInputService.MouseIconEnabled = true
        end)
    end)
    local beat
    beat = RunService.Heartbeat:Connect(function()
        if released or not screen.Parent or not holder.Parent then
            beat:Disconnect()
            return
        end
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
        UserInputService.MouseIconEnabled = true
    end)
    screen.AncestryChanged:Connect(function()
        if not screen.Parent then
            release()
        end
    end)
end
local sidebar = new("Frame", {Name = "Sidebar", Size = UDim2.new(0, SIDEBAR, 1, 0), BackgroundColor3 = Theme.Surface, BorderSizePixel = 0,
    Parent = window})
new("Frame", {Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), BackgroundColor3 = Theme.StrokeSoft, BorderSizePixel = 0,
    Parent = sidebar})
local brand = new("Frame", {Name = "Brand", Size = UDim2.new(1, 0, 0, 64), BackgroundTransparency = 1, Parent = sidebar})
new("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.StrokeSoft, BorderSizePixel = 0,
    Parent = brand})
logo(brand, 32, UDim2.new(0, 16, 0.5, -16))
text(brand, {Text = "Moon Hub", Font = Enum.Font.GothamBold, TextSize = 15, Position = UDim2.fromOffset(58, 14), Size = UDim2.new(1, -66, 0, 18)})
text(brand, {Text = PREVIEW and "Launcher  •  beta" or "Launcher", Font = Enum.Font.GothamMedium, TextSize = 11, TextColor3 = Theme.Muted,
    Position = UDim2.fromOffset(58, 33), Size = UDim2.new(1, -66, 0, 14)})
local profile = new("Frame", {Name = "Profile", Position = UDim2.fromOffset(0, 64), Size = UDim2.new(1, 0, 0, 132), BackgroundTransparency = 1,
    Parent = sidebar})
new("Frame", {Size = UDim2.new(1, -32, 0, 1), Position = UDim2.new(0, 16, 1, -1), BackgroundColor3 = Theme.StrokeSoft, BorderSizePixel = 0,
    Parent = profile})
local avatarRing = new("Frame", {Name = "AvatarRing", AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.new(0.5, 0, 0, 18),
    Size = UDim2.fromOffset(62, 62), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Parent = profile}, {corner(31), stroke(Theme.Accent, 2)})
local avatarImage = new("ImageLabel", {Name = "Avatar", Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = avatarRing},
    {corner(31)})
remoteImage(avatarImage, "user", player.UserId)
local avatarFallback = imageFallback(avatarImage, string.upper(string.sub(player.DisplayName, 1, 1)), 24)
avatarFallback:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 31)
new("Frame", {Name = "Online", AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, 0, 1, 0), Size = UDim2.fromOffset(14, 14),
    BackgroundColor3 = Theme.Success, BorderSizePixel = 0, ZIndex = 2, Parent = avatarRing}, {corner(7), stroke(Theme.Surface, 3)})
text(profile, {Name = "ProfileName", Text = player.DisplayName, Font = Enum.Font.GothamBold, TextSize = 14,
    TextXAlignment = Enum.TextXAlignment.Center, Position = UDim2.fromOffset(12, 88), Size = UDim2.new(1, -24, 0, 18),
    TextTruncate = Enum.TextTruncate.AtEnd})
text(profile, {Name = "ProfileUser", Text = "@" .. player.Name, TextSize = 11, TextColor3 = Theme.Muted, TextXAlignment = Enum.TextXAlignment.Center,
    Position = UDim2.fromOffset(12, 107), Size = UDim2.new(1, -24, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd})
local nav = new("Frame", {Name = "Nav", Position = UDim2.fromOffset(0, 206), Size = UDim2.new(1, 0, 0, 160), BackgroundTransparency = 1,
    Parent = sidebar}, {list(2), padding(0, 12, 0, 12)})
local discordCard = new("TextButton", {Name = "Discord", Text = "", AutoButtonColor = false, BackgroundColor3 = Color3.fromRGB(88, 101, 242),
    BackgroundTransparency = 0.86, Position = UDim2.new(0, 12, 1, -146), Size = UDim2.new(1, -24, 0, 50), Parent = sidebar},
    {corner(10), stroke(Color3.fromRGB(88, 101, 242), 1)})
do
    local badge = new("Frame", {Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(30, 30), BackgroundColor3 = Color3.fromRGB(88, 101, 242),
        BorderSizePixel = 0, Parent = discordCard}, {corner(9)})
    local face = new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.55), Size = UDim2.fromOffset(18, 13),
        BackgroundColor3 = Color3.new(1, 1, 1), BorderSizePixel = 0, Parent = badge}, {corner(5)})
    for _, x in ipairs({0.32, 0.68}) do
        new("Frame", {AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(x, 0.5), Size = UDim2.fromOffset(4, 5),
            BackgroundColor3 = Color3.fromRGB(88, 101, 242), BorderSizePixel = 0, Parent = face}, {corner(2)})
    end
    text(discordCard, {Text = "Discord", Font = Enum.Font.GothamBold, TextSize = 13, Position = UDim2.fromOffset(50, 9), Size = UDim2.new(1, -56, 0, 16)})
    text(discordCard, {Name = "DiscordSub", Text = DISCORD ~= "" and "Join the community" or "Server coming soon", TextSize = 11,
        TextColor3 = Theme.SubText, Position = UDim2.fromOffset(50, 26), Size = UDim2.new(1, -56, 0, 14)})
end
local systemBox = new("Frame", {Name = "System", Position = UDim2.new(0, 0, 1, -86), Size = UDim2.new(1, 0, 0, 86), BackgroundTransparency = 1,
    Parent = sidebar})
new("Frame", {Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = Theme.StrokeSoft, BorderSizePixel = 0, Parent = systemBox})
caption(systemBox, "System", {Position = UDim2.fromOffset(16, 14), Size = UDim2.new(1, -32, 0, 12)})
local systemDot = new("Frame", {Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(16, 37), BackgroundColor3 = Theme.Muted,
    BorderSizePixel = 0, Parent = systemBox}, {corner(4)})
local systemText = text(systemBox, {Name = "SystemText", Text = "Checking status...", Font = Enum.Font.GothamMedium, TextSize = 12,
    Position = UDim2.fromOffset(32, 32), Size = UDim2.new(1, -44, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd})
local executorName, executorMissing = executorInfo()
text(systemBox, {Text = executorName, TextSize = 11, TextColor3 = Theme.Muted, Position = UDim2.fromOffset(16, 56),
    Size = UDim2.new(1, -32, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd})
local header = new("Frame", {Name = "Header", Position = UDim2.fromOffset(SIDEBAR, 0), Size = UDim2.new(1, -SIDEBAR, 0, 64),
    BackgroundTransparency = 1, Parent = window})
new("Frame", {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), BackgroundColor3 = Theme.StrokeSoft, BorderSizePixel = 0,
    Parent = header})
local pageTitle = text(header, {Name = "PageTitle", Font = Enum.Font.GothamBold, TextSize = 18, Position = UDim2.fromOffset(24, 13),
    Size = UDim2.new(1, -110, 0, 22)})
local pageDesc = text(header, {TextSize = 12, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(24, 36), Size = UDim2.new(1, -110, 0, 16),
    TextTruncate = Enum.TextTruncate.AtEnd})
local closeButton = new("TextButton", {Name = "Close", Text = "×", Font = Enum.Font.GothamMedium, TextSize = 18, TextColor3 = Theme.SubText,
    BackgroundColor3 = Theme.Element, BackgroundTransparency = 1, AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -18, 0.5, 0), Size = UDim2.fromOffset(30, 30), Parent = header}, {corner(8)})
local content = new("Frame", {Name = "Content", Position = UDim2.fromOffset(SIDEBAR, 64), Size = UDim2.new(1, -SIDEBAR, 1, -64),
    BackgroundTransparency = 1, Parent = window})
local pages, navButtons, current = {}, {}, nil
local countdown = {Token = 0, Active = false, Stopped = false, Tween = nil}
local stopCountdown
local PAGE_INFO = {
    Home = "Welcome back, " .. tostring(player.DisplayName),
    Games = "Every game Moon Hub supports",
    Updates = "What changed in each version",
    Key = "Your Moon Hub key, bound to this device",
}
local function selectPage(name)
    current = name
    pageTitle.Text = name
    pageDesc.Text = PAGE_INFO[name] or ""
    for pageName, page in pairs(pages) do
        page.Visible = pageName == name
    end
    for pageName, entry in pairs(navButtons) do
        local on = pageName == name
        entry.Button.BackgroundTransparency = on and 0 or 1
        entry.Label.TextColor3 = on and Theme.Text or Theme.SubText
        entry.Icon.SetColor(on and Theme.Accent or Theme.SubText)
        entry.Bar.Visible = on
    end
end
for index, name in ipairs({"Home", "Games", "Updates", "Key"}) do
    local navButton = new("TextButton", {Name = "Tab_" .. name, Text = "", BackgroundColor3 = Theme.Element, BackgroundTransparency = 1,
        AutoButtonColor = false, Size = UDim2.new(1, 0, 0, 34), LayoutOrder = index, Parent = nav}, {corner(8)})
    local bar = new("Frame", {Size = UDim2.fromOffset(3, 16), Position = UDim2.new(0, 0, 0.5, -8), BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0, Visible = false, Parent = navButton}, {corner(2)})
    local icon = drawIcon(navButton, string.lower(name), 16, Theme.SubText, {Position = UDim2.new(0, 14, 0.5, -8)})
    local label = text(navButton, {Text = name, Font = Enum.Font.GothamMedium, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(40, 0),
        Size = UDim2.new(1, -46, 1, 0)})
    navButtons[name] = {Button = navButton, Label = label, Bar = bar, Icon = icon}
    navButton.Activated:Connect(function()
        if name ~= "Home" and countdown.Active then
            stopCountdown(true)
        end
        selectPage(name)
    end)
    navButton.MouseEnter:Connect(function()
        if current ~= name then
            tween(navButton, 0.12, {BackgroundTransparency = 0.55})
        end
    end)
    navButton.MouseLeave:Connect(function()
        if current ~= name then
            tween(navButton, 0.12, {BackgroundTransparency = 1})
        end
    end)
    pages[name] = new(name == "Updates" and "ScrollingFrame" or "Frame", {Name = "Page_" .. name, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0, Visible = false, Parent = content}, {padding(18, 20, 18, 20)})
end
do
    local updates = pages.Updates
    updates.ScrollBarThickness = 3
    updates.ScrollBarImageColor3 = Theme.Stroke
    updates.CanvasSize = UDim2.new(0, 0, 0, 0)
    updates.AutomaticCanvasSize = Enum.AutomaticSize.Y
    updates.ScrollingDirection = Enum.ScrollingDirection.Y
    list(12).Parent = updates
end
local state = {Status = normalize(readJSON(STATUS_CACHE) or FALLBACK_STATUS), Online = nil, Entry = nil, Key = nil, KeyValid = false,
    KeyLeft = nil, KeyChecking = false, Launching = false}
state.Entry = detectGame(state.Status)
local home = pages.Home
local hero = card(home, {Name = "Hero", Size = UDim2.new(1, 0, 0, 150), ClipsDescendants = true})
local wash = new("Frame", {Name = "Wash", Size = UDim2.fromScale(1, 1), BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.82,
    BorderSizePixel = 0, Parent = hero}, {corner(12)})
new("UIGradient", {Transparency = NumberSequence.new(1, 0.55), Parent = wash})
local gameIcon = new("ImageLabel", {Name = "GameIcon", Position = UDim2.fromOffset(20, 20), Size = UDim2.fromOffset(64, 64),
    BackgroundColor3 = Theme.Element, Image = "", Parent = hero}, {corner(14), stroke(Theme.Stroke)})
local gameIconFallback = imageFallback(gameIcon, "?", 20)
gameIconFallback:FindFirstChildOfClass("UICorner").CornerRadius = UDim.new(0, 14)
caption(hero, "Current game", {Position = UDim2.fromOffset(100, 22), Size = UDim2.new(1, -260, 0, 12)})
local gameName = text(hero, {Name = "GameName", Font = Enum.Font.GothamBold, TextSize = 20, Position = UDim2.fromOffset(100, 37),
    Size = UDim2.new(1, -260, 0, 24), TextTruncate = Enum.TextTruncate.AtEnd})
local gameMeta = text(hero, {Name = "GameMeta", TextSize = 12, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(100, 64),
    Size = UDim2.new(1, -260, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd})
local buildDot = new("Frame", {Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(20, 106), BackgroundColor3 = Theme.Muted,
    BorderSizePixel = 0, Parent = hero}, {corner(3)})
local buildText = text(hero, {Name = "BuildText", TextSize = 12, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(32, 101),
    Size = UDim2.new(1, -290, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd})
local notesText = text(hero, {TextSize = 11, TextColor3 = Theme.Muted, Position = UDim2.fromOffset(20, 121), Size = UDim2.new(1, -290, 0, 16),
    TextTruncate = Enum.TextTruncate.AtEnd})
local gamePill = pill(hero, {Name = "GameStatus", State = "info", AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -20, 0, 20)})
local launchButton = button(hero, {Name = "Launch", Text = "Launch", Primary = true, AnchorPoint = Vector2.new(1, 1),
    Position = UDim2.new(1, -20, 1, -20), Size = UDim2.fromOffset(170, 42)})
local cancelButton = new("TextButton", {Name = "Cancel", Text = "Cancel", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.SubText,
    BackgroundTransparency = 1, AutoButtonColor = false, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -198, 1, -20),
    Size = UDim2.fromOffset(64, 42), Visible = false, Parent = hero})
local launchTrack = new("Frame", {Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 1, -3), BackgroundColor3 = Theme.Element,
    BorderSizePixel = 0, Visible = false, Parent = hero})
local launchFill = new("Frame", {Size = UDim2.new(0, 0, 1, 0), BackgroundColor3 = Theme.Accent, BorderSizePixel = 0, Parent = launchTrack})
pcall(function()
    remoteImage(gameIcon, "game", game.GameId)
end)
local tiles = new("Frame", {Name = "Tiles", Position = UDim2.fromOffset(0, 162), Size = UDim2.new(1, 0, 0, 74), BackgroundTransparency = 1,
    Parent = home}, {list(12, true)})
local tileRefs = {}
for index, name in ipairs({"Key", "Executor", "Players", "Status"}) do
    local tile = card(tiles, {Name = "Tile_" .. name, Size = UDim2.new(0.25, -9, 1, 0), LayoutOrder = index})
    caption(tile, name == "Players" and "Active players" or name, {Position = UDim2.fromOffset(14, 13), Size = UDim2.new(1, -28, 0, 12)})
    local value = text(tile, {Name = "Value", Font = Enum.Font.GothamBold, TextSize = 14, Position = UDim2.fromOffset(14, 29),
        Size = UDim2.new(1, -28, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd})
    local sub = text(tile, {Name = "Sub", TextSize = 11, TextColor3 = Theme.Muted, Position = UDim2.fromOffset(14, 48), Size = UDim2.new(1, -28, 0, 14),
        TextTruncate = Enum.TextTruncate.AtEnd})
    tileRefs[name] = {Value = value, Sub = sub}
end
local latest = card(home, {Name = "Latest", Position = UDim2.fromOffset(0, 248), Size = UDim2.new(1, 0, 1, -248), ClipsDescendants = true})
text(latest, {Text = "Latest updates", Font = Enum.Font.GothamBold, TextSize = 14, Position = UDim2.fromOffset(18, 14), Size = UDim2.new(1, -140, 0, 18)})
local viewAll = new("TextButton", {Name = "ViewAll", Text = "View all", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Accent,
    BackgroundTransparency = 1, AutoButtonColor = false, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -18, 0, 12),
    Size = UDim2.fromOffset(80, 22), TextXAlignment = Enum.TextXAlignment.Right, Parent = latest})
local latestList = new("Frame", {Position = UDim2.fromOffset(18, 42), Size = UDim2.new(1, -36, 1, -50), BackgroundTransparency = 1,
    Parent = latest}, {list(10)})
viewAll.Activated:Connect(function()
    selectPage("Updates")
end)
local gamesList = new("Frame", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Parent = pages.Games}, {list(10)})
local keyPage = pages.Key
local keyState = card(keyPage, {Name = "KeyState", Size = UDim2.new(1, 0, 0, 66)})
local keyStateDot = new("Frame", {Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(18, 20), BackgroundColor3 = Theme.Muted,
    BorderSizePixel = 0, Parent = keyState}, {corner(4)})
local keyStateTitle = text(keyState, {Name = "KeyStateTitle", Font = Enum.Font.GothamBold, TextSize = 14, Position = UDim2.fromOffset(34, 14),
    Size = UDim2.new(1, -200, 0, 18)})
local keyStateSub = text(keyState, {TextSize = 12, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(34, 34), Size = UDim2.new(1, -200, 0, 16),
    TextTruncate = Enum.TextTruncate.AtEnd})
local resetKey = button(keyState, {Name = "ResetKey", Text = "Renew key", AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -16, 0.5, 0), Size = UDim2.fromOffset(140, 34)})
local STEP_INFO = {{"Get a key", "Free or premium"}, {"Paste it", "Into the box below"}, {"Verify", "Checked instantly"}}
local steps = {}
local stepCard = card(keyPage, {Name = "Steps", Position = UDim2.fromOffset(0, 80), Size = UDim2.new(1, 0, 0, 56)})
for index, info in ipairs(STEP_INFO) do
    local cell = new("Frame", {Name = "Step" .. index, BackgroundTransparency = 1, Position = UDim2.new((index - 1) / 3, 0, 0, 0),
        Size = UDim2.new(1 / 3, 0, 1, 0), Parent = stepCard})
    local dot = new("Frame", {Size = UDim2.fromOffset(26, 26), Position = UDim2.new(0, 16, 0.5, -13), BackgroundColor3 = Theme.Element,
        BorderSizePixel = 0, Parent = cell}, {corner(13)})
    local ring = stroke(Theme.Stroke)
    ring.Parent = dot
    local number = text(dot, {Text = tostring(index), Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Center,
        Size = UDim2.fromScale(1, 1)})
    local title = text(cell, {Name = "StepTitle", Text = info[1], Font = Enum.Font.GothamBold, TextSize = 12, Position = UDim2.new(0, 52, 0.5, -15),
        Size = UDim2.new(1, -60, 0, 15)})
    local sub = text(cell, {Name = "StepSub", Text = info[2], TextSize = 10, TextColor3 = Theme.Muted, Position = UDim2.new(0, 52, 0.5, 2),
        Size = UDim2.new(1, -60, 0, 13), TextTruncate = Enum.TextTruncate.AtEnd})
    if index < #STEP_INFO then
        new("Frame", {Size = UDim2.new(0, 1, 0, 28), Position = UDim2.new(1, 0, 0.5, -14), BackgroundColor3 = Theme.Divider,
            BorderSizePixel = 0, Parent = cell})
    end
    steps[index] = {Dot = dot, Ring = ring, Number = number, Title = title, Sub = sub}
end
local currentStep, stepFailed = 0, false
local function setStep(active, failed)
    currentStep, stepFailed = active, failed == true
    for index, step in ipairs(steps) do
        local done, on = index < active, index == active
        local color = (on and stepFailed) and Theme.Danger or (done and Theme.Success or (on and Theme.Accent or Theme.Element))
        step.Dot.BackgroundColor3 = color
        step.Ring.Color = (done or on) and color or Theme.Stroke
        step.Number.TextColor3 = (done or on) and Color3.new(1, 1, 1) or Theme.Muted
        step.Title.TextColor3 = (done or on) and Theme.Text or Theme.SubText
        step.Title.Text, step.Sub.Text = STEP_INFO[index][1], STEP_INFO[index][2]
    end
    if active >= 4 then
        steps[3].Title.Text, steps[3].Sub.Text = "Verified", "Key active"
    elseif active == 3 and stepFailed then
        steps[3].Sub.Text = "Key not accepted"
    elseif active == 3 then
        steps[3].Sub.Text = "Checking..."
    end
end
caption(keyPage, "Your key", {Position = UDim2.fromOffset(0, 150), Size = UDim2.fromOffset(200, 12)})
local inputFrame = new("Frame", {Name = "KeyInput", Position = UDim2.fromOffset(0, 168), Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, Parent = keyPage}, {corner(8)})
local inputStroke = stroke(Theme.Stroke)
inputStroke.Parent = inputFrame
local box = new("TextBox", {Name = "KeyBox", Text = "", PlaceholderText = "MOON-XXXX-XXXX-XXXX", PlaceholderColor3 = Theme.Muted,
    Font = Enum.Font.GothamMedium, TextSize = 14, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(14, 0), Size = UDim2.new(1, -28, 1, 0), Parent = inputFrame})
local statusDot = new("Frame", {Size = UDim2.fromOffset(6, 6), Position = UDim2.fromOffset(2, 228), BackgroundColor3 = Theme.Muted,
    BorderSizePixel = 0, Parent = keyPage}, {corner(3)})
local status = text(keyPage, {Name = "Status", Text = PREVIEW and "Paste your key above: it is checked right away."
    or "Press Get Key, then paste your key above: it is checked right away.", TextSize = 12, TextColor3 = Theme.SubText, TextWrapped = true,
    TextYAlignment = Enum.TextYAlignment.Top, Position = UDim2.fromOffset(16, 223), Size = UDim2.new(1, -16, 0, 32)})
local getButton = button(keyPage, {Name = "GetKey", Text = "Get Key", Position = UDim2.fromOffset(0, 262), Size = UDim2.new(0.4, -6, 0, 42)})
local startButton = button(keyPage, {Name = "Start", Text = "Continue", Primary = true, Position = UDim2.new(0.4, 6, 0, 262),
    Size = UDim2.new(0.6, -6, 0, 42)})
local info = new("Frame", {Name = "KeyInfo", Position = UDim2.fromOffset(0, 316), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundColor3 = Theme.Surface, BorderSizePixel = 0, Parent = keyPage}, {corner(10), stroke(Theme.StrokeSoft), padding(12, 14, 12, 14), list(4)})
text(info, {Text = "Good to know", Font = Enum.Font.GothamBold, TextSize = 12, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1})
text(info, {Text = "Your key is bound to this device, so sharing it won't work on another PC. "
    .. "With a valid key the hub starts by itself after a short countdown.", TextSize = 11, TextColor3 = Theme.SubText, TextWrapped = true,
    AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 14), LayoutOrder = 2})
text(keyPage, {Text = "Device " .. string.upper(string.sub(HWID, 1, 8)) .. "  •  one key per device", TextSize = 11, TextColor3 = Theme.Muted,
    AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(0, 0, 1, 0), Size = UDim2.new(0.6, 0, 0, 16)})
local notice = new("TextLabel", {Name = "Notice", Text = "", Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = Theme.Text,
    BackgroundColor3 = Theme.Element, AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, -16), Size = UDim2.fromOffset(300, 34),
    Visible = false, ZIndex = 20, Parent = content}, {corner(8), stroke(Theme.Stroke)})
local noticeToken = 0
local function showNotice(message)
    noticeToken = noticeToken + 1
    local token = noticeToken
    notice.Text, notice.Visible = message, true
    task.delay(2.5, function()
        if token == noticeToken then
            notice.Visible = false
        end
    end)
end
local function setStatus(message, kind)
    local colors = {good = Theme.Success, bad = Theme.Danger, busy = Theme.Accent}
    status.Text = message
    status.TextColor3 = kind == "bad" and Theme.Danger or (kind == "good" and Theme.Success or Theme.SubText)
    statusDot.BackgroundColor3 = colors[kind] or Theme.Muted
    inputStroke.Color = kind == "bad" and Theme.Danger or (kind == "good" and Theme.Success or Theme.Stroke)
end
local function renderKey()
    local tile = tileRefs.Key
    if state.KeyChecking then
        keyStateTitle.Text, keyStateSub.Text, keyStateDot.BackgroundColor3 = "Checking your key...", "Asking the key server", Theme.Accent
        tile.Value.Text, tile.Sub.Text, tile.Value.TextColor3 = "Checking", "Key server", Theme.Text
    elseif state.KeyValid then
        keyStateTitle.Text = "Key active"
        keyStateSub.Text = (state.KeyLeft == math.huge and "Never expires" or ("Expires in " .. hoursLeft(state.KeyLeft)))
            .. "  •  bound to this device" .. (state.Entry and type(state.Entry.by) == "string" and ("  •  games by " .. state.Entry.by) or "")
        keyStateDot.BackgroundColor3 = Theme.Success
        tile.Value.Text, tile.Sub.Text, tile.Value.TextColor3 = "Active", state.KeyLeft == math.huge and "Never expires"
            or (hoursLeft(state.KeyLeft) .. " left"), Theme.Success
    else
        keyStateTitle.Text = "No active key"
        keyStateSub.Text = state.Entry and type(state.Entry.by) == "string" and ("Get a key below for the games by " .. state.Entry.by)
            or "Get a key below to unlock Moon Hub"
        keyStateDot.BackgroundColor3 = Theme.Muted
        tile.Value.Text, tile.Sub.Text, tile.Value.TextColor3 = "Not set", "Get a free key", Theme.SubText
    end
    resetKey.Visible = state.KeyValid
end
local function renderLaunch()
    if state.Launching then
        return
    end
    if not state.Entry then
        launchButton.Text = "Not supported"
        launchButton.BackgroundColor3 = Theme.Element
        launchButton.TextColor3 = Theme.Muted
    else
        launchButton.Text = state.KeyValid and "Launch" or "Get a key to launch"
        launchButton.BackgroundColor3 = Theme.Accent
        launchButton.TextColor3 = Color3.new(1, 1, 1)
    end
end
local function changelogBlock(parent, entry, order, short)
    local block = new("Frame", {Name = "Update_" .. tostring(entry.version), Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1, LayoutOrder = order, Parent = parent}, {list(4)})
    local head = new("Frame", {Size = UDim2.new(1, 0, 0, 20), BackgroundTransparency = 1, LayoutOrder = 0, Parent = block})
    new("TextLabel", {Text = "v" .. tostring(entry.version or "?"), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Accent,
        BackgroundColor3 = Theme.Accent, BackgroundTransparency = 0.86, BorderSizePixel = 0, Size = UDim2.fromOffset(58, 20), Parent = head},
        {corner(6)})
    text(head, {Text = tostring(entry.title or ""), Font = Enum.Font.GothamBold, Position = UDim2.fromOffset(68, 0), Size = UDim2.new(1, -150, 1, 0),
        TextTruncate = Enum.TextTruncate.AtEnd})
    text(head, {Text = shortDate(entry.date), TextSize = 11, TextColor3 = Theme.Muted, TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 0, 0, 0), Size = UDim2.fromOffset(80, 20)})
    for index, item in ipairs(type(entry.items) == "table" and entry.items or {}) do
        if short and index > 2 then
            break
        end
        text(block, {Text = "•   " .. tostring(item), TextSize = 12, TextColor3 = Theme.SubText, TextWrapped = not short,
            AutomaticSize = not short and Enum.AutomaticSize.Y or nil, Size = UDim2.new(1, 0, 0, 15), LayoutOrder = index,
            TextTruncate = short and Enum.TextTruncate.AtEnd or nil})
    end
    return block
end
local function clear(parent)
    for _, child in ipairs(parent:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
end
local function renderStatus()
    local statusData = state.Status
    local entry = state.Entry
    local system = state.Online == false and "offline" or (statusData.state or "operational")
    local systemState = stateOf(system)
    local messages = {operational = "All systems operational", degraded = "Some features are degraded", down = "Down for maintenance"}
    systemDot.BackgroundColor3 = systemState[1]
    systemText.Text = state.Online == nil and "Checking status..." or (state.Online == false and "Status server unreachable"
        or ((statusData.message and statusData.message ~= "") and statusData.message or messages[system] or system))
    if entry then
        local placeName
        if entry.universal == true then
            if state.PlaceName == nil then
                local ok, info = pcall(function()
                    return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
                end)
                state.PlaceName = ok and type(info) == "table" and info.Name and tostring(info.Name) or false
            end
            placeName = state.PlaceName or nil
        end
        gameName.Text = placeName or tostring(entry.name or entry.id)
        gameIconFallback.Text = tostring(entry.short or initialsOf(entry.name))
        gameMeta.Text = "Moon Hub" .. (entry.universal == true and " Universal Script" or "") .. (type(entry.by) == "string" and ("  •  by " .. entry.by) or "")
            .. (entry.version and (" v" .. tostring(entry.version)) or "")
            .. (entry.updated and ("  •  updated " .. shortDate(entry.updated)) or "")
        gamePill.Set(entry.status or "working")
        notesText.Text = tostring(entry.notes or "")
    else
        local ok, info = pcall(function()
            return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        end)
        gameName.Text = ok and type(info) == "table" and tostring(info.Name) or ("Place " .. tostring(game.PlaceId))
        gameMeta.Text = "Moon Hub doesn't support this game yet"
        gamePill.Set("unsupported")
        notesText.Text = "See the Games page for supported games"
    end
    local build, kind, note = buildInfo(entry)
    buildDot.BackgroundColor3 = kind == "warn" and Theme.Warning or (kind == "good" and Theme.Success or Theme.Muted)
    buildText.Text = "Game build " .. tostring(build) .. "  •  " .. note
    tileRefs.Executor.Value.Text = executorName
    tileRefs.Executor.Sub.Text = #executorMissing == 0 and "Full support" or ("Missing " .. table.concat(executorMissing, ", "))
    tileRefs.Executor.Sub.TextColor3 = #executorMissing == 0 and Theme.Success or Theme.Warning
    local playing = state.Playing
    tileRefs.Players.Value.Text = playing and shortCount(playing) or (state.PlayingChecked and "-" or "...")
    tileRefs.Players.Sub.Text = playing and (entry and entry.universal == true and "playing this game" or "playing right now")
        or (state.PlayingChecked and "Roblox didn't answer" or "Asking Roblox")
    tileRefs.Status.Value.Text = string.sub(systemState[2], 1, 1) .. string.lower(string.sub(systemState[2], 2))
    tileRefs.Status.Value.TextColor3 = systemState[1]
    tileRefs.Status.Sub.Text = state.Online and ("Live  •  " .. os.date("%H:%M")) or (state.Online == false and "Showing cached data" or "Checking")
    clear(latestList)
    clear(pages.Updates)
    local news = statusData.news[1]
    if type(news) == "table" then
        local banner = new("Frame", {Name = "News", Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = Theme.Accent,
            BackgroundTransparency = 0.9, BorderSizePixel = 0, LayoutOrder = 0, Parent = pages.Updates}, {corner(10), padding(12, 14, 12, 14), list(3)})
        text(banner, {Text = tostring(news.title or "News"), Font = Enum.Font.GothamBold, Size = UDim2.new(1, 0, 0, 16), LayoutOrder = 1})
        text(banner, {Text = tostring(news.text or ""), TextSize = 12, TextColor3 = Theme.SubText, TextWrapped = true,
            AutomaticSize = Enum.AutomaticSize.Y, Size = UDim2.new(1, 0, 0, 15), LayoutOrder = 2})
    end
    if #statusData.changelog == 0 then
        text(latestList, {Text = state.Online == false and "Updates show here when the status server is reachable."
            or "No updates published yet.", TextSize = 12, TextColor3 = Theme.Muted, Size = UDim2.new(1, 0, 0, 16)})
    end
    for index, update in ipairs(statusData.changelog) do
        if type(update) == "table" then
            if index <= 2 then
                changelogBlock(latestList, update, index, true)
            end
            changelogBlock(pages.Updates, update, index, false)
        end
    end
    clear(gamesList)
    for index, gameEntry in ipairs(statusData.games) do
        if type(gameEntry) == "table" and (gameEntry.private ~= true or OWNER) then
            local here = gameEntry == entry
            local row = card(gamesList, {Name = "Game_" .. tostring(gameEntry.id), Size = UDim2.new(1, 0, 0, 74), LayoutOrder = index})
            if here then
                row:FindFirstChildOfClass("UIStroke").Color = Theme.Accent
            end
            local universal = gameEntry.universal == true
            text(row, {Text = universal and "Universal Script" or tostring(gameEntry.name or gameEntry.id), Font = Enum.Font.GothamBold, TextSize = 14, Position = UDim2.fromOffset(18, 14),
                Size = UDim2.new(1, -240, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd})
            local active = not universal and state.PlayingByEntry and state.PlayingByEntry[gameEntry] or nil
            text(row, {Name = "GameLine", Text = (type(gameEntry.by) == "string" and ("by " .. gameEntry.by .. "  •  ") or "")
                .. (gameEntry.version and ("v" .. tostring(gameEntry.version) .. "  •  ") or "") .. (gameEntry.updated
                and ("updated " .. shortDate(gameEntry.updated)) or "not released yet") .. (active and ("  •  " .. shortCount(active) .. " playing") or ""),
                TextSize = 12, TextColor3 = Theme.SubText,
                Position = UDim2.fromOffset(18, 34), Size = UDim2.new(1, -240, 0, 16)})
            text(row, {Text = tostring(gameEntry.notes or ""), TextSize = 11, TextColor3 = Theme.Muted, Position = UDim2.fromOffset(18, 51),
                Size = UDim2.new(1, -240, 0, 14), TextTruncate = Enum.TextTruncate.AtEnd})
            local tags = new("Frame", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -18, 0.5, 0), Size = UDim2.fromOffset(220, 22),
                BackgroundTransparency = 1, Parent = row}, {new("UIListLayout", {FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder})})
            if here then
                pill(tags, {Name = "Here", State = "info", LayoutOrder = 1}).Set("info", "YOU ARE HERE")
            end
            pill(tags, {State = gameEntry.status or "working", LayoutOrder = 2})
        end
    end
    local soon = new("Frame", {Name = "MoreGames", Size = UDim2.new(1, 0, 0, 52), BackgroundTransparency = 1, LayoutOrder = 999,
        Parent = gamesList}, {corner(12), stroke(Theme.StrokeSoft)})
    text(soon, {Text = "More games are on the way", Font = Enum.Font.GothamMedium, TextColor3 = Theme.SubText, Position = UDim2.fromOffset(18, 0),
        Size = UDim2.new(1, -36, 1, 0)})
    renderLaunch()
end
local closing = false
local function close(delay)
    if closing then
        return
    end
    closing = true
    if type(EMBEDDED) == "table" and not EMBEDDED.Done then
        EMBEDDED.Done = true
    end
    task.delay(delay or 0, function()
        tween(holder, 0.25, {Position = UDim2.new(0.5, 0, 0.5, 14)})
        tween(windowScale, 0.25, {Scale = scale * 0.96})
        tween(backdrop, 0.25, {BackgroundTransparency = 1})
        task.wait(0.3)
        screen:Destroy()
    end)
end
local busy = false
function stopCountdown(byUser)
    countdown.Token = countdown.Token + 1
    countdown.Stopped = countdown.Stopped or byUser == true
    if countdown.Tween then
        countdown.Tween:Cancel()
        countdown.Tween = nil
    end
    if countdown.Active then
        countdown.Active = false
        cancelButton.Visible = false
        launchTrack.Visible = false
        launchFill.Size = UDim2.new(0, 0, 1, 0)
        renderLaunch()
    end
end
local function startHub(key)
    stopCountdown()
    state.Launching = true
    launchButton.Text = "Launching..."
    launchTrack.Visible = true
    tween(launchFill, 0.8, {Size = UDim2.new(1, 0, 1, 0)})
    local launched, err = launch(key, state.Entry, state.KeyLeft)
    if launched then
        close(0.9)
        return true
    end
    state.Launching = false
    launchTrack.Visible = false
    launchFill.Size = UDim2.new(0, 0, 1, 0)
    renderLaunch()
    return false, err
end
local function startCountdown()
    if FROM_HUB or countdown.Active or countdown.Stopped or state.Launching or closing or not state.KeyValid or not state.Entry or current ~= "Home" then
        return
    end
    countdown.Active = true
    countdown.Token = countdown.Token + 1
    local token = countdown.Token
    cancelButton.Visible = true
    launchTrack.Visible = true
    launchFill.Size = UDim2.new(0, 0, 1, 0)
    countdown.Tween = TweenService:Create(launchFill, TweenInfo.new(COUNTDOWN, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 1, 0)})
    countdown.Tween:Play()
    task.spawn(function()
        for left = COUNTDOWN, 1, -1 do
            if countdown.Token ~= token then
                return
            end
            launchButton.Text = "Launching in " .. left .. "..."
            task.wait(1)
        end
        if countdown.Token == token and not closing then
            countdown.Active = false
            cancelButton.Visible = false
            startHub(state.Key)
        end
    end)
end
local function submitKey()
    if busy or closing then
        return
    end
    local key = string.match(string.upper(box.Text), "MOON%-[%w]+%-[%w]+%-[%w]+")
    if not key then
        setStatus("That doesn't look like a Moon Hub key (MOON-XXXX-XXXX-XXXX).", "bad")
        return
    end
    busy = true
    setStep(3)
    setStatus("Checking your key...", "busy")
    local ok, why, left, _, keyScope = verify(key, state.Entry)
    if not ok then
        setStatus(why, "bad")
        setStep(3, true)
        busy = false
        return
    end
    saveKey(key, keyScope)
    state.Key, state.KeyValid, state.KeyLeft = key, true, left
    if OWNER then
        local fresh, online = fetchStatus(key)
        if online then
            state.Status = fresh
        end
    end
    state.Entry = detectGame(state.Status)
    setStep(4)
    renderKey()
    if not state.Entry then
        setStatus("Key OK  •  " .. hoursLeft(left) .. ". This game isn't supported yet.", "good")
        renderLaunch()
        busy = false
        return
    end
    setStatus("Key OK  •  " .. hoursLeft(left) .. ". Loading " .. tostring(state.Entry.name) .. "...", "good")
    local launched, err = startHub(key)
    if launched then
        selectPage("Home")
    else
        setStatus(err, "bad")
    end
    busy = false
end
cancelButton.Activated:Connect(function()
    stopCountdown(true)
end)
launchButton.Activated:Connect(function()
    if state.Launching or not state.Entry then
        return
    end
    if not state.KeyValid then
        selectPage("Key")
        return
    end
    local launched, err = startHub(state.Key)
    if not launched then
        buildText.Text = tostring(err)
        buildDot.BackgroundColor3 = Theme.Danger
    end
end)
local RENEW_CAP = 72 * 3600 - 60
local function copyKeyLink(renew)
    if PREVIEW then
        setStep(2)
        setStatus("Key links open soon. If you already have a key, paste it above.", "busy")
        return
    end
    if renew and state.KeyValid and tonumber(state.KeyLeft) and state.KeyLeft >= RENEW_CAP then
        setStatus(state.KeyLeft == math.huge and "Your key never expires: nothing to renew."
            or ("Your key has " .. hoursLeft(state.KeyLeft) .. " left. Ad rounds top a key up to 72 h, so there's nothing to add right now."),
            "good")
        return
    end
    local link = API .. "/getkey?hwid=" .. HttpService:UrlEncode(HWID) .. gameParam(state.Entry)
    setStep(2)
    if type(setclipboard) == "function" then
        setclipboard(link)
        setStatus(renew and "Link copied: finish the steps in your browser: +24 h on your key (up to 72 h)."
            or "Link copied: open it in your browser and paste the key here when you get it.", "good")
    else
        box.Text = link
        setStatus("Copy this link into your browser and paste the key here when you get it.", "busy")
    end
end
getButton.Activated:Connect(function()
    copyKeyLink(false)
end)
startButton.Activated:Connect(submitKey)
box.FocusLost:Connect(function(enterPressed)
    inputStroke.Color = Theme.Stroke
    if enterPressed then
        submitKey()
    end
end)
box.Focused:Connect(function()
    inputStroke.Color = Theme.Accent
    stopCountdown(true)
end)
local lastPasted = nil
box:GetPropertyChangedSignal("Text"):Connect(function()
    local pasted = string.match(string.upper(box.Text), "MOON%-[%w]+%-[%w]+%-[%w]+")
    if pasted and pasted ~= lastPasted and not busy and not state.KeyValid then
        lastPasted = pasted
        task.defer(submitKey)
    elseif not pasted and not busy and not state.KeyValid and currentStep >= 2 then
        setStep(2)
    end
end)
resetKey.Activated:Connect(function()
    stopCountdown(true)
    copyKeyLink(true)
end)
closeButton.Activated:Connect(function()
    close(0)
end)
closeButton.MouseEnter:Connect(function()
    tween(closeButton, 0.12, {BackgroundTransparency = 0, TextColor3 = Theme.Text})
end)
closeButton.MouseLeave:Connect(function()
    tween(closeButton, 0.12, {BackgroundTransparency = 1, TextColor3 = Theme.SubText})
end)
discordCard.Activated:Connect(function()
    if DISCORD == "" then
        showNotice("The Discord server isn't open yet. Coming soon!")
    elseif type(setclipboard) == "function" then
        setclipboard(DISCORD)
        showNotice("Invite link copied: paste it in your browser")
    else
        showNotice("discord.gg/" .. string.gsub(DISCORD, "^.*/", ""))
    end
end)
discordCard.MouseEnter:Connect(function()
    tween(discordCard, 0.12, {BackgroundTransparency = 0.75})
end)
discordCard.MouseLeave:Connect(function()
    tween(discordCard, 0.12, {BackgroundTransparency = 0.86})
end)
for _, handle in ipairs({brand, header}) do
    local dragging, startPosition, origin
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging, startPosition, origin = true, input.Position, holder.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPosition
            holder.Position = UDim2.new(origin.X.Scale, origin.X.Offset + delta.X, origin.Y.Scale, origin.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
end
setStep(1)
renderKey()
renderStatus()
selectPage(type(EMBEDDED) == "table" and EMBEDDED.Page or "Home")
tween(backdrop, 0.3, {BackgroundTransparency = 0.4})
tween(holder, 0.35, {Position = UDim2.fromScale(0.5, 0.5)})
tween(windowScale, 0.35, {Scale = scale})
local function checkSavedKey()
    local scope = scopeOf(state.Entry)
    local saved = TESTER or readKey(scope)
    if not saved then
        state.KeyChecking = false
        if not closing then
            renderKey()
            renderLaunch()
        end
        return
    end
    state.KeyChecking = true
    renderKey()
    local ok, why, left, reason = verify(saved, state.Entry)
    state.KeyChecking = false
    if ok then
        state.Key, state.KeyValid, state.KeyLeft = saved, true, left
        if OWNER then
            local fresh, online = fetchStatus(saved)
            if online then
                state.Status = fresh
            end
        end
        state.Entry = detectGame(state.Status)
        setStep(4)
        if not closing then
            renderStatus()
            startCountdown()
        end
    else
        if reason ~= "network" then
            forgetKey(scope)
        end
        lastPasted = string.upper(saved)
        box.Text = saved
        setStep(3, true)
        setStatus("Your saved key no longer works (" .. tostring(why) .. "): get a new one.", "bad")
        selectPage("Key")
    end
    if not closing then
        renderKey()
        renderLaunch()
        startCountdown()
    end
end
if TESTER or readKey(scopeOf(detectGame(state.Status))) then
    state.KeyChecking = true
    renderKey()
end
task.spawn(function()
    local statusData, online = fetchStatus(TESTER or readKey())
    state.Status, state.Online = statusData, online
    state.Entry = detectGame(statusData)
    if not closing then
        renderStatus()
        startCountdown()
    end
    task.spawn(checkSavedKey)
    local byEntry, current = fetchPlaying(statusData.games, state.Entry)
    state.PlayingByEntry, state.Playing, state.PlayingChecked = byEntry, current, true
    if not closing then
        renderStatus()
    end
end)
