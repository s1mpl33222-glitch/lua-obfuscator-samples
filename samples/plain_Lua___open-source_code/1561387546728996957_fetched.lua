local Place = game.PlaceId
local Game = game.GameId
local GameName = game:GetService("MarketplaceService"):GetProductInfo(Place).Name

local scripts = {
    [2474168535] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/WB.lua",
    [79267089300389] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/My%20Wood%20Farm.lua",
    [96645548064314] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/CAT.lua",
    [7305309231] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/TB.lua",
    [74569490529875] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Dig%20And%20Merge",
    [112413741511713] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/MCT.lua",
    [77393318863643] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/AA.lua",
    [82806856224736] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/GrabOre.lua",
    [131791366604550] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/LPFB.lua",
    [135911818477576] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Shoot%20For%20Eggs.lua",
    [107646426076756] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Build%20A%20Ring%20Farm.lua",
    [130422569332103] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/BCB.lua",
    [107535308163741] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Huss%20Valley.lua",
    [122245938604556] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/%2B1%20Tongue%20Escape",
    [112233638491976] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Unbox%20ASMR",
    [130641102725850] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Mog%20Or%20Die.lua",
    [134381727982611] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Evomon.lua",
    [88735661337823] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Spuddys",
    [92416421522960] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/Slime%20RNG.lua",
    [130594398886540] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/GH.lua",
    [124473577469410] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/BALB.lua",
    [103510455221561] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/CFC.lua",
    [116495829188952] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/DR2.lua",
    [114640202062357] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/SOFB",
    [70876832253163] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/DR2.lua",
    [129315204746120] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/EQFB.lua",
    [122678592501168] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/BE.lua",
    [121864768012064] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/FT.lua",
    [12604352060] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/AO.lua",
    [14894612329] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/AO.lua",
    [15449776494] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/AO.lua",
    [2772610559] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/FAF.lua",
    [87039211657390] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/AC.lua",
    [4924922222] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/main/FUNC/Games/BRKO.lua",
    [75366259315586] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/BUB.lua",
    [119574637420814] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/be%20a%20begger.lua",
    [89488832720361] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/GA.lua",
    [6735572261] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/PG.lua",
    [95702387256198] = "https://raw.githubusercontent.com/x7dJJ9vnFH23/Maintained-Fun/refs/heads/main/FUNC/Games/SAT.lua"
}

local scriptURL = scripts[Place] or scripts[Game]

if scriptURL then
    loadstring(game:HttpGet(scriptURL, true))()
else
    warn("Purge doesnt support this game!")
end
