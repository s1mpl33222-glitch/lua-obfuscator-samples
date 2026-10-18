local games = {
    {
        ids = {
            "109684591839194",
            "103521881639626",
            "86789627188240",
            "102580589030177",
            "134314141048307",
            "117134837736236",
            "74691681039273",
            "96802054849934",
            "85395484560711",
        },
        url = "https://raw.githubusercontent.com/user913945673657265478/Serenity/refs/heads/main/volleyballlegends.lua",
    },
    {
        ids = {
            "109258067111533",
            "76869119106266",
            "122084881497089",
            "95144714051153",
            "99265427850921",
            "134308493567752",
            "92307946911423",
        },
        url = "https://raw.githubusercontent.com/user913945673657265478/Serenity/refs/heads/main/touchline.lua",
    },
}

local placeId = tostring(game.PlaceId)

for _, entry in ipairs(games) do
    for _, id in ipairs(entry.ids) do
        if placeId == id then
            loadstring(game:HttpGet(entry.url))()
            return
        end
    end
end

warn("Unsupported PlaceId: " .. placeId)