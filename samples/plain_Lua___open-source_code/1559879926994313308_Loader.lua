local ENV = getgenv() or getfenv()
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local e = identifyexecutor()
local nig = {
    "Solara",
    "Xeno"
}

if table.find(nig, e) then
    return error("Not Supported Executor", 0)
end

if ENV.Loaded then
    return
end

ENV.Loaded = true

Players.PlayerRemoving:Connect(function(player)
    if player == LocalPlayer then
        ENV.Loaded = nil
        ENV.TeleportQueued = nil
    end
end)

if not ENV.TeleportQueued then
    local teleportFunc = queue_on_teleport or (syn and syn.queue_on_teleport)
    if teleportFunc then
        teleportFunc('loadstring(game:HttpGet("https://api.pagamescripts.xyz/Loader"))()')
        ENV.TeleportQueued = true
    end
end

local GameScripts = {
    [9409415054]  = "%2B1%20Jump%20Per%20Step",
    [9294646427]  = "Bobsled%20Ride%20Down%20a%20Mountainside",
    [4552793904]  = "Effortless%20Tower",
    [7290067958]  = "Double%20Jump%20Tower",
    [8362507239]  = "Jump%20Map%20Power%20Level%20Test",
    [7621512836]  = "Circular%20Tower",
    [3864279452]  = "cart%20ride%20around%20nothing",
    [8360491918]  = "Korea%20Army",
    [6147276975]  = "Drive%20the%20train%20to%20the%20end",
    [8883775493]  = "Build%20a%20Roller%20Coaster",
    [3310460039]  = "BARRY'S%20PRISON%20RUN!%20(OBBY)",
    [2027832238]  = "MMK",
    [8127951408]  = "Stage",
    [9584852943]  = "%2B1%20Speed%20Keyboard%20Escape",
    [10196985448] = "Korean%20Word%20Game",
    [12345678]    = "Gugudan%20Battle"
}

local GameId = game.GameId
local ScriptName = GameScripts[GameId]

if GameId == 6035872082 then
    loadstring(game:HttpGet("https://api.pagamescripts.xyz/files/v1/loaders/yjk8d29k8ikzpx7d34ii5kl0qtgvg5wc.lua"))()
    loadstring(game:HttpGet("https://api.pagamescripts.xyz/files/v1/loaders/ihbre7vsohysosb564y6k4ow2u8wf7mo.lua"))()
    return
end

loadstring(game:HttpGet("https://api.pagamescripts.xyz/files/v1/loaders/ihbre7vsohysosb564y6k4ow2u8wf7mo.lua"))()

if ScriptName then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pafapafa/GameScripts/main/" .. ScriptName))()
else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/pafapafa/GameScripts/main/PAFA"))()
end
