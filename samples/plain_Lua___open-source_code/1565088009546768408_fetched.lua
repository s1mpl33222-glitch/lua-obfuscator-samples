-- Luavify Bootstrap
-- This is not the obfuscated code. This fetches the token and the payload.
local hash = "c8276206ff302dcd6261cf1c349ba0f4"
local api = "https://luavify-protector.itskevin.workers.dev"

local success, token = pcall(function()
    return game:HttpGet(api .. "/api/get-token?hash=" .. hash)
end)

if not success or not token or token == "" then
    game.Players.LocalPlayer:Kick("Luavify: Failed to authorize.")
    return
end

local success2, payload = pcall(function()
    return game:HttpGet(api .. "/api/get-payload?hash=" .. hash .. "&token=" .. token)
end)

if not success2 or not payload then
    game.Players.LocalPlayer:Kick("Luavify: Failed to download payload.")
    return
end

loadstring(payload)()