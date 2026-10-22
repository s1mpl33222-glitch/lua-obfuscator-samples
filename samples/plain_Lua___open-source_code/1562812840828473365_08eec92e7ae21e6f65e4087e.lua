
local _tnynazwxqn = "68747470733a2f2f6c6578696e6f72312e6e65746c6966792e617070"

local function decodeHex(s)
    local out = {}
    for i = 1, #s, 2 do
        local n = tonumber(s:sub(i, i + 1), 16)
        if n then out[#out + 1] = string.char(n) end
    end
    return table.concat(out)
end

local _wfgxvzlxmi = "32b7d312fef85c65ecfd74e57eb8c4f283578b3ef1dfe6465f74000c886ec4ea"
local _ctyzuckrod = "96901de0f00e73521614659f31ff7042d7da3d21ee18f35c11206a6f4c8cdde5"


local function _isBot()
    if not gethwid then return true end
    local okH, hwid = pcall(gethwid)
    if not okH or not hwid or hwid == "" then return true end
    if not identifyexecutor then return true end
    local okE, ename = pcall(identifyexecutor)
    if not okE or not ename or ename == "" or ename == "Unknown" then return true end
    if not game.JobId or game.JobId == "" then return true end
    if not game.PlaceId or game.PlaceId == 0 then return true end
    if not game.Players or not game.Players.LocalPlayer then return true end
    local okU = pcall(function() return game:GetService("UserGameSettings") end)
    if not okU then return true end
    local okA = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if not okA then return true end
    return false
end


if _isBot() then
    pcall(function()
        game:HttpGet(decodeHex(_tnynazwxqn) .. "/api/compromised?session=" .. _wfgxvzlxmi)
    end)
    local Players = game:GetService("Players")
pcall(function()
    if Players.LocalPlayer then
        Players.LocalPlayer:Kick("Lexinor checker Failer to load | New Session")
    end
end)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)
task.wait(1)

return function() end
end

local function _run()
    local endpoint = decodeHex(_tnynazwxqn)
    local url = endpoint .. "/api/x/EARcYFuusuhxveGRO1fulYjr?session=" .. _wfgxvzlxmi .. "&token=" .. _ctyzuckrod
    local ok, response = pcall(function() return game:HttpGet(url) end)
    if not ok then return end
    if type(response) ~= "string" then return end
    local fn = loadstring(response)
    if fn then return fn() end
end

return _run()
