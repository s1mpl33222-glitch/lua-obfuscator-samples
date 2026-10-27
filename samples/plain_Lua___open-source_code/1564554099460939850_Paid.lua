if not lp_key then return end

local links = {
    [11729688377] = "https://luaprot.net/api/v3/loaders/get/99789352167974487639",
    [11879754496] = "https://luaprot.net/api/v3/loaders/get/99789352167974487639",
    [85016391652478] = "https://luaprot.net/api/v3/loaders/get/99789352167974487639",
}

local url = links[game.PlaceId]
if not url then return end

local ok, content = pcall(game.HttpGet, game, url)
if not ok or not content or content == "" then return end

assert(loadstring(content))()
