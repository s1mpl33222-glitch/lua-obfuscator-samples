if not getgenv then
    function getgenv() return _G end
end
local UniverseId = game.GameId
local try, err = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/dunnook/SpectacleHub/refs/heads/main/"..tostring(UniverseId)))() end)
if try then
    print(err)
end
