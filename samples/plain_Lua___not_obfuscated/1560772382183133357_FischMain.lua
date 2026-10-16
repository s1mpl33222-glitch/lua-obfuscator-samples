local Player = game.Players.LocalPlayer
local placeId = game.PlaceId

local Games = {
    [16732694052] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- fisch
    [131716211654599] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- fisch
    [76558904092080] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- forge
    [129009554587176] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- forge
    [131884594917121] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- forge
    [14890802310] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- bl
    [74747090658891] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- bl
    [77923379150463] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- bl
    [77747658251236] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [96767841099256] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [123955125827131] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [96767841099256] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [138368689293913] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [99684056491472] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [75159314259063] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [130167267952199] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- sp
    [16205713724] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- ps
    [136406881576517] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/KeyObsidian", -- ps

    [85896571713843] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/BGS",
    [122678592501168] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/Beaks",
    [126884695634066] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/GAG",
    [103754275310547] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/GAG",
    [86076978383613] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/GAG",
    [121864768012064] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/GAG",
    [127742093697776] = "https://raw.githubusercontent.com/Skibidiking123/Fisch1/refs/heads/main/GAG",
}

local scriptUrl = Games[placeId]

if scriptUrl then
    local suc, res = pcall(function()
        return game:HttpGet(scriptUrl, true)
    end)
    
    if suc then
        loadstring(res)()
    end
end














