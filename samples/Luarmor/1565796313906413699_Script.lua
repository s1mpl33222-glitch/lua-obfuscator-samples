if not game:IsLoaded() then
    game.Loaded:Wait()
end

local SCRIPTS = {
    primeval = "https://api.luarmor.net/files/v4/loaders/b8c171b96c2ad3b3c869ae572cb2ca22.lua",
    sniper = "https://api.luarmor.net/files/v4/loaders/98096e4869522b965b4e94bde2cf4f42.lua",
    bugevolution = "https://api.luarmor.net/files/v4/loaders/386d315125cf7415d381cf735ec39ecc.lua",
}

local NAMES = {
    primeval = "Primeval Earth",
    sniper = "Sniper Arena",
    bugevolution = "Bug Evolution",
}

local PLACES = {
    [10696301650] = "primeval",
    [122446657157717] = "sniper",
    [90165746516953] = "sniper",
    [70650894743738] = "bugevolution",
}

local GAMES = {
    [9534705677] = "sniper",
    [10769957062] = "bugevolution",
}

-- fallback when a place isn't listed (sub-places, new servers): match the game's name
local KEYWORDS = {
    {"primeval", "primeval"},
    {"sniper arena", "sniper"},
    {"bug evolution", "bugevolution"},
}

local DISCORD = "discord.gg/AH8SRWBxQy"

local function notify(text, duration)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Strawberry Hub",
            Text = text,
            Duration = duration or 10,
        })
    end)
end

local function detect()
    local which = PLACES[game.PlaceId] or GAMES[game.GameId]
    if which then return which end
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    local name = ok and info and string.lower(tostring(info.Name)) or ""
    for _, k in ipairs(KEYWORDS) do
        if string.find(name, k[1], 1, true) then return k[2] end
    end
    return nil
end

-- game:HttpGet first, then the executor's request function if that fails
local function fetch(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 0 then return body end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok2, res = pcall(req, {Url = url, Method = "GET"})
        if ok2 and res and type(res.Body) == "string" and #res.Body > 0 then return res.Body end
    end
    return nil, tostring(body)
end

local which = detect()
local url = which and SCRIPTS[which]
if not url then
    notify("This game isn't supported yet. Join our Discord: " .. DISCORD)
    return
end

notify("Loading " .. NAMES[which] .. "...", 4)

local src, httpErr = fetch(url)
if not src then
    notify("Couldn't download the script. Check your internet / executor and try again.")
    warn("[Strawberry Hub] download failed: " .. tostring(httpErr))
    return
end

local fn, compileErr = loadstring(src)
if not fn then
    notify("Script failed to start (" .. string.sub(tostring(compileErr), 1, 80) .. "). Ask in " .. DISCORD)
    warn("[Strawberry Hub] loadstring failed: " .. tostring(compileErr))
    return
end

local ok, runErr = xpcall(fn, debug.traceback)
if not ok then
    notify("Script error: " .. string.sub(tostring(runErr), 1, 80) .. " - ask in " .. DISCORD)
    warn("[Strawberry Hub] script error: " .. tostring(runErr))
end
