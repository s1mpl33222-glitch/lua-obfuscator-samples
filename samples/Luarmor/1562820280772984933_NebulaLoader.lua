local key = script_key
local version = getgenv().NebulaVersion

if not key then
    warn("No Luarmor key found")
    return
end

if version == "Lite" then

    getgenv().script_key = key

    loadstring(game:HttpGet(
        "https://api.luarmor.net/files/v4/loaders/c8a1070ff0cf39d90eb9fc25d88397fc.lua"
    ))()

elseif version == "Full" then

    getgenv().script_key = key

    loadstring(game:HttpGet(
        "https://api.luarmor.net/files/v4/loaders/cf62c75f9d9512152bac397773b324ce.lua"
    ))()

elseif version == "Legacy" then

    getgenv().script_key = key

    loadstring(game:HttpGet(
        "https://api.luarmor.net/files/v4/loaders/f500de13b89126dc0c850851958b8690.lua"
    ))()

end
