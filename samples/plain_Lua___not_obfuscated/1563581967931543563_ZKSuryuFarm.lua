if getgenv().ScriptExecuted then return end
while true do
    getgenv().ScriptExecuted = nil
    local ok, result = pcall(function() loadstring(game:HttpGet("https://vss.pandauth.com/kv/c96fbaae7252d36e"))() end)
    if ok then break end
end