local base = "https://raw.githubusercontent.com/ImNotWhyLclc/Rendex/refs/heads/main/"

local hm = {
    [245662005] = "Games/Jailbreak.luau",
    [372226183] = "Games/FleeTheFacility.luau",
    [10509848467] = "Games/Demise.luau",
    [254394801] = "Games/KAT.luau",
    [7326934954] = "Games/Rendex99NITF.luau"
}

local yay = {
    [6839171747] = "Games/Doors.luau",
    [10549820578] = "Games/Doors.luau",
    [87716067947993] = "Games/Doors.luau",
    [110258689672367] = "Games/Doors.luau",
    [6516141723] = "Games/DoorsLobby.luau",
    [12308344607] = "Games/DoorsVCLobby.luau"
}

local file = yay[game.PlaceId] or hm[game.GameId]

if not file then
    warn("* Rendex * Unsupported Game:", game.GameId, "Place:", game.PlaceId)
    return
end

local success, err = pcall(function()
    local source = game:HttpGet(base .. file)
    local func = loadstring(source)

    if not func then
        error("Failed to compile " .. file)
    end

    func()
end)

if success then
    print("* Rendex * Loaded:", file)
else
    warn("* Rendex * Failed:", file)
    warn(err)
end
