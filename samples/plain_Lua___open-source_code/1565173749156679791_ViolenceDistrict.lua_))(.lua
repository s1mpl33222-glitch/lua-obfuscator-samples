local BASE = "https://raw.githubusercontent.com/lixxWW/ViolenceDistrict/refs/heads/main/"

local SCRIPTS = {
    [93978595733734] = BASE .. "violencedistrict.lua",   -- Violence District
    [97598239454123] = BASE .. "growagarden.lua",         -- Grow a Garden 2
    [77085202503540] = BASE .. "growagarden.lua",         -- Grow a Garden 2 
    [142823291]      = BASE .. "murdermystery2.lua",     -- Murder Mystery 2
    [66654135]       = BASE .. "murdermystery2.lua",     -- Murder Mystery 2
    [10265440494]    = BASE .. "1981.lua",               -- 1981 (Main / Lobby)
    [72137289529544] = BASE .. "1981.lua",               -- 1981 (In-Game Match)
    [6137321701]     = BASE .. "blair.lua",              -- Blair
    [893973440]      = BASE .. "ftf.lua",                -- Flee the Facility
    [13772394625]    = BASE .. "bladeball.lua",          -- Blade Ball
}

local placeId = game.PlaceId
local url     = SCRIPTS[placeId]

if not url then
    if workspace:FindFirstChild("FavoriteRoomHighlightMock") then
        url = BASE .. "blair.lua"
        print("[Hypnosis] Game Detected: Blair")
    elseif workspace:FindFirstChild("Packanack Lodge") or workspace:FindFirstChild("InGameHousing") then
        url = BASE .. "1981.lua"
        print("[Hypnosis] Game Detected: 1981")
    elseif workspace:FindFirstChild("Balls") and (workspace:FindFirstChild("Alive") or workspace:FindFirstChild("Dead")) then
        url = BASE .. "bladeball.lua"
        print("[Hypnosis] Game Detected: Blade Ball")
    else
        local player = game:GetService("Players").LocalPlayer
        local coinBags = player and player:FindFirstChild("PlayerGui")
            and player.PlayerGui:FindFirstChild("MainGUI")
            and player.PlayerGui.MainGUI:FindFirstChild("Game")
            and player.PlayerGui.MainGUI.Game:FindFirstChild("CoinBags")
        
        if coinBags then
            url = BASE .. "murdermystery2.lua"
            print("[Hypnosis] Game Detected: Murder Mystery 2")
        else
            warn("[Hypnosis] No script found for PlaceId: " .. tostring(placeId))
            return
        end
    end
else
    print("[Hypnosis] Game Detected: " .. tostring(placeId))
end

print("[Hypnosis] Downloading script from ViolenceDistrict...")

local nocacheUrl = url .. "?t=" .. tostring(math.floor(os.time() or tick()))
local ok, scriptContent = pcall(function()
    return game:HttpGet(nocacheUrl)
end)

if not ok or not scriptContent or #scriptContent == 0 then
    ok, scriptContent = pcall(function()
        return game:HttpGet(url)
    end)
end

if not ok or not scriptContent or #scriptContent == 0 then
    warn("[Hypnosis] Failed to download script from repository.")
    return
end

local fn, err = loadstring(scriptContent)
if not fn then
    warn("[Hypnosis] Compile error in target script: " .. tostring(err))
    return
end

print("[Hypnosis] Script loaded successfully. Executing...")
fn()
