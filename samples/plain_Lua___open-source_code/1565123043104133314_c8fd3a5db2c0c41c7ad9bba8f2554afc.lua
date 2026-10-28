local hash = "c8fd3a5db2c0c41c7ad9bba8f2554afc"
local api = "https://luavify-protector.itskevin.workers.dev"
local success, token = pcall(function()
    return game:HttpGet(api .. "/api/get-token?hash=" .. hash)
end)
if not success or not token or token == "" then game.Players.LocalPlayer:Kick("Luavify: Auth failed.") return end

local success2, payload = pcall(function()
    return game:HttpGet(api .. "/api/get-payload?hash=" .. hash .. "&token=" .. token)
end)
if not success2 or not payload then game.Players.LocalPlayer:Kick("Luavify: Download failed.") return end

pcall(function() game:HttpGet(api .. "/log-execution?hash=" .. hash) end)
loadstring(payload)()