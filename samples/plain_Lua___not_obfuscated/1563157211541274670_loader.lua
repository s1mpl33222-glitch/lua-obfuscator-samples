repeat task.wait() until game:IsLoaded()

if getgenv().KuuraxLoading then return end
getgenv().KuuraxLoading = true

local games = {
    [6035872082]  = "rivals",
    [7633926880]  = "blox_strike",
    [9534705677]  = "sniper_arena",
    [10684750879] = "loot_to_forge",
    [7326934954]  = "ninety_nine_nights",
    [10648640958] = "hood_rivals",
    [2668101271]  = "ftap",
    [9051406594]  = "dueling_grounds",
    [10764627709] = "huss_valley",
    [9974314982]  = "spin_anime_cards",
    [10708913337] = "anime_dice",
    [5595353122]  = "ouwland",
    [6739698191]  = "violence_district",
    [10765298801] = "stone_skipping",
    [9294074907]  = "one_tap",
    [10526853622] = "deep_fishing",
    [6331902150]  = "forsaken",
    [10629695169] = "tap_simulator_reborn"
}

local current = games[game.GameId]
if not current then
    getgenv().KuuraxLoading = nil
    return
end

pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Kuurax Hub",
        Text = "Loading " .. current .. "...",
        Duration = 3
    })
end)

local ok, src = pcall(function()
    return game:HttpGet("https://scripts.majra.live/games/" .. current .. ".lua?_t=" .. os.time())
end)

getgenv().KuuraxLoading = nil

if ok and src and #src > 0 and src:sub(1, 1) ~= "<" then
    local chunk, err = loadstring(src, current)
    if chunk then
        task.spawn(chunk)
    else
        warn("[kuurax] syntax error:", err)
    end
else
    warn("[kuurax] failed to fetch game file")
end
