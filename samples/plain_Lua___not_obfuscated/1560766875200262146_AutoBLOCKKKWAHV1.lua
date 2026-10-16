-- did u know 1+1 is 3

local d = identifyexecutor()

task.spawn(function()
    local e = identifyexecutor()
    local n = string.lower(e)

    if n:find("xeno") or n:find("solara") then
        game.Players.LocalPlayer:Kick("This is not a problem - We don't Support Your Executor")
    end
end)

if game.PlaceId == 70845479499574 then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/hiimchae/bbn-why-are-you-here/refs/heads/main/83783922.lua"))()
elseif game.PlaceId == 70876832253163 then
    loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/fc3935820e793c3646c6d4ead8a3aba190372f025042644850699544d639fcc9/download"))()
elseif game.PlaceId == 116495829188952 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Lobby",
        Text = "Ur in lobby Pls join a game",
        Duration = 5
    })
else
    loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/e7da5ccc613ad180e4baeac2124054374e459aae8b766f54fd42be1e20332f5f/download"))()
end

print("tufff")
