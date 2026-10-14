-- local script_mode = "PVP" -- PVP, FARM
local scripts = {
    [6765805766] = { -- Block Spin
        PVP  = "https://api.luarmor.net/files/v4/loaders/c07baff8edfc24b30c9f2a74218199d1.lua",
        FARM = "https://api.luarmor.net/files/v4/loaders/0c4940bf7e2a0b5130d3a83446c00f14.lua",
    },
    [994732206] = { -- Blox Fruits
        PVP = "https://api.luarmor.net/files/v4/loaders/0c7ea360c9bca139fc70fff09aad7d8b.lua",
    }
}

local cfg = scripts[game.GameId]
if not cfg then
    game:GetService("Players").LocalPlayer:Kick("Game not supported")
    return
end

loadstring(game:HttpGet(cfg[(script_mode or "PVP"):upper()] or cfg.PVP))()
