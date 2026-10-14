local Loaders = {
    [10035204815] = "https://api.luarmor.net/files/v4/loaders/13d3fce9b99b4b7b3eb60c3fcb649252.lua",
    [10563114921] = "https://api.luarmor.net/files/v4/loaders/596d9f15c52b399844cd8da2880aacd4.lua",
}

while game.GameId == 0 do
    task.wait()
end

loadstring(game:HttpGet(Loaders[game.GameId] or "https://nolag.wtf/legacy.lua"))()
