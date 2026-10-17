local players = game:GetService("Players")
local player = players.LocalPlayer


if getgenv().DiscordId then 

else

    player:kick("script wasnt executed trough your custom loadstring or auth error.")
     task.wait(5)
    game:Shutdown()
end


