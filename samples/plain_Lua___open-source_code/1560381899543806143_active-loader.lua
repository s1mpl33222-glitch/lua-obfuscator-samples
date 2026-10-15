repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players").LocalPlayer

_G.Loaded = true

if game.PlaceId ~= 107778070777162
    and game.PlaceId ~= 114326934417838
    and game.PlaceId ~= 114574503491412 then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Icon = "rbxassetid://108551171937093",
        Title = "NOX",
        Text = "Game Not Supported!",
        Duration = 5,
    })
    return
end

loadstring(game:HttpGet("https://flowauth.net/v1/loaders/5c2026123fe3f4d3c4b3ae92dfe88350.lua"))()
