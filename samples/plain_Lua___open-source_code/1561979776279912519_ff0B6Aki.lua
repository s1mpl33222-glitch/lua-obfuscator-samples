-- Main ChillHub Loader

local SCRIPT_HUB = {
    [18687417158] = "https://pastebin.com/raw/AJbNwbJU", -- Forsaken
    [10449761463] = "https://pastebin.com/raw/4aps8qeq",      -- TSB
}

local UNIVERSAL_URL = "https://pastebin.com/raw/isfyJXTY" -- Any other game

-- Select target link
local targetUrl = SCRIPT_HUB[game.PlaceId] or UNIVERSAL_URL

-- Load the game script
local success, err = pcall(function()
    loadstring(game:HttpGet(targetUrl))()
end)

if not success then
    warn("[ChillHub] Primary load failed: " .. tostring(err))
    pcall(function()
        loadstring(game:HttpGet(UNIVERSAL_URL))()
    end)
end