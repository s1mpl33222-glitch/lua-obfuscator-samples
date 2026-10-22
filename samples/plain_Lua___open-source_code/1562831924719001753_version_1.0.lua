-- Smurfy's UI: loads the script for the game you're in.
-- (ids are text: obfuscators mangle numbers this big)
local BASE = "https://raw.githubusercontent.com/SmurfyYT/Smurfys_UI/refs/heads/main/"
local BY_PLACE = {
    ["124216119978534"] = "RideAPet.lua",
    ["85738654635245"] = "ClimbForAnimalEggs.lua",
    ["96510596525082"] = "BallVsBall.lua",
}
-- games found by name (other places of the same game, or ids not listed yet)
local BY_NAME = {
    { words = { "break", "steal", "egg" }, file = "BreakAndStealAnEgg.lua" },
    { words = { "climb", "egg" }, file = "ClimbForAnimalEggs.lua" },
    { words = { "ball", "vs", "ball" }, file = "BallVsBall.lua" },
    { words = { "ride", "pet" }, file = "RideAPet.lua" },
}
local DEFAULT = "RideAPet.lua" -- any other game: the menu with the Player, Teleport and Settings tabs

local function notify(text)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Smurfy's UI", Text = text, Duration = 6 })
    end)
end

local file = BY_PLACE[tostring(game.PlaceId)]
if not file then
    local ok, info = pcall(function()
        return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
    end)
    local name = ok and type(info) == "table" and string.lower(tostring(info.Name)) or ""
    for _, entry in ipairs(BY_NAME) do
        local all = name ~= ""
        for _, word in ipairs(entry.words) do
            if not string.find(name, word, 1, true) then all = false break end
        end
        if all then file = entry.file break end
    end
end
file = file or DEFAULT

local ok, source = pcall(function() return game:HttpGet(BASE .. file) end)
if not ok or type(source) ~= "string" or #source < 100 then
    return notify("Couldn't download the script. Try again in a moment.")
end
local run, err = loadstring(source)
if not run then
    return notify("The script didn't load: " .. tostring(err))
end
return run()
