-- main.lua
local games = {
    -- Format: [PlaceID] = { url = "ScriptLink", key_required = boolean }
    
    -- Game Tanpa Key (Langsung Load)
    [121864768012064] = { url = "https://api.jnkie.com/api/v1/luascripts/public/97afe9c02a8026a11c091fedb8e687bd4c866ee7ac2a7a292bb9513ad65b5c5a/download", key_required = true }, -- Fish It
    [1537690962]      = { url = "https://api.jnkie.com/api/v1/luascripts/public/356b91d2f130f0d93b4bf50e5d3c9f611a6b210ce97f97317a2c7213c1a25431/download", key_required = true }, -- Bee Swarm
    [130594398886540] = { url = "https://api.jnkie.com/api/v1/luascripts/public/b8332843c08dc314f9b1da44faa8320cfb3c81038d6ebb7c85b7f9badc912938/download", key_required = true }, -- Garden Horizons

    -- Game Pakai Key (Akan memanggil Key System)
    [76558904092080]  = { url = "https://api.jnkie.com/api/v1/luascripts/public/ea8ae5d36a20a896bb7f85ea42d1378ea6925566a1ddfb715928d016ad3fe70e/download", key_required = true },  -- The Forge 1
    [129009554587176] = { url = "https://api.jnkie.com/api/v1/luascripts/public/ea8ae5d36a20a896bb7f85ea42d1378ea6925566a1ddfb715928d016ad3fe70e/download", key_required = true }, -- The Forge 2
    [131884594917121] = { url = "https://api.jnkie.com/api/v1/luascripts/public/ea8ae5d36a20a896bb7f85ea42d1378ea6925566a1ddfb715928d016ad3fe70e/download", key_required = true }, -- The Forge 3
    [74414241680540] = { url = "https://api.jnkie.com/api/v1/luascripts/public/ea8ae5d36a20a896bb7f85ea42d1378ea6925566a1ddfb715928d016ad3fe70e/download", key_required = true }, -- The Forge 4
    [127794225497302] = { url = "https://api.jnkie.com/api/v1/luascripts/public/16c8fd26bd86602187a839bb4c4f521723686c5fc3aa5dc91ecf9f6e7608318e/download", key_required = true },  -- Abyss
    [131623223084840] = { url = "https://api.jnkie.com/api/v1/luascripts/public/a8c1deecb961e3727ddb8492cc60048c00e57052c01327c57a6cdec78ee7edfe/download", key_required = true }, -- Escape Tsunami For Brainrots
    [137629155365661] = { url = "https://api.jnkie.com/api/v1/luascripts/public/a8c1deecb961e3727ddb8492cc60048c00e57052c01327c57a6cdec78ee7edfe/download", key_required = true }, -- Escape Tsunami For brainrots
    [86362492050446] = { url = "https://api.jnkie.com/api/v1/luascripts/public/a8c1deecb961e3727ddb8492cc60048c00e57052c01327c57a6cdec78ee7edfe/download", key_required = true }, -- Escape Tsunami For Brainrots

}

local currentID = game.PlaceId
local gameData = games[currentID]

print("[Catraz Hub] Checking Game ID:", currentID) 

if gameData then
    if gameData.key_required then
        print("[Catraz Hub] Keyed Game Detected. Loading Key System...")
        
        -- Kita simpan URL script target ke global variable agar bisa dibaca oleh keysystem.lua
        getgenv().CatrazTargetScript = gameData.url
        
        -- Load file keysystem.lua kamu (Ganti URL ini dengan link raw keysystem.lua kamu)
        loadstring(game:HttpGet("https://raw.githubusercontent.com/nurvian/Catraz-HUB/refs/heads/main/Catraz/keysystemfree.lua"))()
    else
        print("[Catraz Hub] Free Game Detected. Injecting Script...")
        -- Langsung load scriptnya karena tidak butuh key
        loadstring(game:HttpGet(gameData.url))() 
    end
else
    game.Players.LocalPlayer:Kick("\n[Catraz Hub]\n\nYo! This game ain't on the list.\nCheck the Discord for whitelisted games, homie.")
end