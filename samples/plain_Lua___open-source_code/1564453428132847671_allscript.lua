
local placeScriptsPremium = {
    [131716211654599] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/UITES",
    [16732694052] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/UITES",
    [127794225497302] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/Abyss",
    [2753915549] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/BloxFruit.lua",
    [130594398886540] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/HorizonGardenPrem.lua",
    [130342654546662] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/sambungkata.lua",
    [77747658251236] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/SailorPiece",
    [93978595733734] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/vd.lua",
    [97598239454123] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/GAG2",
}

local placeScriptsFree = {
    [97598239454123] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/GAG2",
    [100875131717601] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/ThrowACoin.lua",
    [77747658251236] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/SailorPiece",
    [93978595733734] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/vd.lua",
    [130342654546662] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/sambungkata.lua",
    [130594398886540] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/HorizonGarden.lua",
    [2753915549] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/BloxFruit.lua",
    [86710642002144] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Talamau.lua",
    [129009554587176] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/TheForge/tes",
    [76558904092080] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/TheForge/tes",
    [131884594917121] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/TheForge/tes",
    [2693023319] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Antartika.lua",
    [131716211654599] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/UITES",
    [16732694052] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/UITES",
    [95777993643016] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Arunika.lua",
    [102234703920418] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Daun.lua",
    [89100225746834] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Tanditek.lua",
    [73384821369941] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Ulap.lua",
    [123224294054165] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Atin.lua",
    [8735521924] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/DISX/shieldtcentaura-enc.lua",
    [86076978383613] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/huntyZomby.lua",
    [103754275310547] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/huntyZomby.lua",
    [128473079243102] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/arunika2.lua",
    [14963184269] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/Sumbing.lua",
    [121864768012064] = "https://raw.githubusercontent.com/KAN-FISCH/tesss/refs/heads/main/gunung/fishit"
}

local key = _G.Key or getgenv().Key
local placeScripts = placeScriptsFree

if key and tostring(key) ~= "" then
    placeScripts = placeScriptsPremium
end

local currentPlaceId = game.PlaceId
if placeScripts[currentPlaceId] then
    local scriptUrl = placeScripts[currentPlaceId]
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    if not success then
        warn("Failed to execute script for place " .. currentPlaceId .. ": " .. result)
    end
end
