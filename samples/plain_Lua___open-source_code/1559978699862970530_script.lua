if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local function stop(text)
    local player = Players.LocalPlayer
    while not player do task.wait(0.1); player = Players.LocalPlayer end
    pcall(function() player:Kick("ArrestFlow" .. string.char(10, 10) .. text) end)
end
local executor = "This executor"
pcall(function()
    local name = identifyexecutor and identifyexecutor()
    if type(name) == "string" and name:match("%S") then executor = name:match("^%s*(%S+)") end
end)
local send = request or http_request or (syn and syn.request) or (http and http.request)
local upvalues = type(getupvalues) == "function" or (debug and type(debug.getupvalues) == "function")
local collected = false
pcall(function()
    local list = getgc()
    collected = type(list) == "table" and #list > 1000
end)
if type(send) ~= "function" or type(loadstring) ~= "function" or type(writefile) ~= "function"
    or type(readfile) ~= "function" or not upvalues or not collected then
    return stop(executor .. " is not supported by ArrestFlow."
        .. string.char(10, 10) .. "See the supported executors on our Discord:"
        .. string.char(10) .. "discord.gg/ggBsP7WPmN")
end
local ok, source = pcall(game.HttpGet, game, "https://arrestflow.dpdns.org/auth/script")
local chunk = ok and type(source) == "string" and loadstring(source)
if not chunk then return stop("Could not load ArrestFlow. Run the script again.") end
return chunk(...)
