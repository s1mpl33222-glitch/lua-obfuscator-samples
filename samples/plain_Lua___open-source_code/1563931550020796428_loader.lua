local PlaceId = game.PlaceId
local ServerURL = "https://jenicakes.vercel.app/api/script?placeid=" .. tostring(PlaceId)

local success, response = pcall(function()
    return game:HttpGet(ServerURL, true)
end)

if success and response then
    local func, err = loadstring(response)
    if func then
        func()
    else
        warn("[Jenicakes Loader] Syntax error: " .. tostring(err))
    end
else
    warn("[Jenicakes Loader] Connection error: " .. tostring(response))
end