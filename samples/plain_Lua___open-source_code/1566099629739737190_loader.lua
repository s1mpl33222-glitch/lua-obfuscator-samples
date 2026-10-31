local url = "https://raw.githubusercontent.com/Larinleonard/Zenith-Premium/main/Zenith.lua"

for attempt = 1, 3 do
    local ok, source = pcall(game.HttpGet, game, url)
    if ok and type(source) == "string" and source ~= "" then
        local chunk, err = loadstring(source)
        if chunk then
            chunk()
            return
        end
        warn("[Zenith] Load error: " .. tostring(err))
    end
    task.wait(0.5)
end
