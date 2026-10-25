if getgenv().ScriptExecuted then return end
while true do
    getgenv().ScriptExecuted = nil
    local ok, result = pcall(function() loadstring(game:HttpGet("https://vss.pandauth.com/kv/841a4ebf618786d3"))() end)
    if ok then break end
end