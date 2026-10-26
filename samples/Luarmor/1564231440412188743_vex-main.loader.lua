local p = game:GetService("Players").LocalPlayer

local a = {
    [6403373529] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/vexslapples",
    [108843562394237] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/vexbomb",
    [71008479572236] = "https://api.luarmor.net/files/v4/loaders/ff8456b7f1d63fe042cb6597636e04c2.lua",
    [18687417158] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/main/vexsaken6.7",
    [92637789841354] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/collectalltheleaves",
    [78515283254292] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/Animal%20Hospital%20Vexsaken",
    [116497287371701] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/Karinderya%20Vexsaken",
    [99567941238278] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/Ink%20Game%20Nauru",
    [116495829188952] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/Dead%20Rails%20Nauru",
    [107535308163741] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/huss%20valley",
    [119958473240233] = "https://raw.githubusercontent.com/cvjhvc/vexsaken/refs/heads/main/dont%20splash%20nauru",
}

local b = {
    [2380077519] = a[6403373529],
    [9564673841] = a[108843562394237],
    [9684353339] = a[71008479572236],
    [6331902150] = a[18687417158],
    [10539411000] = a[92637789841354],
    [10148749921] = a[78515283254292],
    [10648820673] = a[116497287371701],
    [7008097940] = a[99567941238278],
    [7018190066] = a[116495829188952],
    [107535308163741] = a[107535308163741],
    [10771421858] = a[119958473240233],
}

local c = a[game.PlaceId] or b[game.GameId]

if not c then
    p:Kick("This game is not supported by Nauru Hub")
    return
end

local d, e = pcall(function()
    loadstring(game:HttpGet(c))()
end)

if not d then
    warn(e)
end
