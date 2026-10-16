local BASE = "https://raw.githubusercontent.com/lixxWW/ViolenceDistrict/refs/heads/main/"

local SCRIPTS = {
    [93978595733734] = BASE .. "violencedistrict.lua",   -- Violence District
    [97598239454123] = BASE .. "growagarden.lua",         -- Grow a Garden 2 (Old)
    [77085202503540] = BASE .. "growagarden.lua",         -- Grow a Garden 2 (New)
    [142823291]      = BASE .. "murdermystery2.lua",     -- Murder Mystery 2
    [66654135]       = BASE .. "murdermystery2.lua",     -- Murder Mystery 2 Trade Plaza
    [10265440494]    = BASE .. "1981.lua",               -- 1981 (Main / Lobby)
    [72137289529544] = BASE .. "1981.lua",               -- 1981 (In-Game Match)
    [6137321701] = BASE .. "blair.lua",
}

local placeId = game.PlaceId
local url     = SCRIPTS[placeId]

if not url then
    -- Fallback 1: Blair Detection via FavoriteRoomHighlightMock
    if workspace:FindFirstChild("FavoriteRoomHighlightMock") then
        url = BASE .. "blair.lua"
        print("[Loader] Game Detected: Blair")
    -- Fallback 2: 1981 / Friday the 13th Object Detection
    elseif workspace:FindFirstChild("Packanack Lodge") or workspace:FindFirstChild("InGameHousing") then
        url = BASE .. "1981.lua"
        print("[Loader] Game Detected: 1981")
    else
        -- Fallback 3: Murder Mystery 2 Detection
        local player = game:GetService("Players").LocalPlayer
        local coinBags = player and player:FindFirstChild("PlayerGui")
            and player.PlayerGui:FindFirstChild("MainGUI")
            and player.PlayerGui.MainGUI:FindFirstChild("Game")
            and player.PlayerGui.MainGUI.Game:FindFirstChild("CoinBags")
        
        if coinBags then
            url = BASE .. "murdermystery2.lua"
            print("[Loader] Game Detected: Murder Mystery 2")
        else
            warn("[Loader] No script found for PlaceId: " .. tostring(placeId))
            return
        end
    end
else
    print("[Loader] Game Detected: " .. tostring(placeId))
end

print("[Loader] Downloading script from ViolenceDistrict...")

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
    warn("[Loader] Failed to download script from repository.")
    return
end

local fn, err = loadstring(scriptContent)
if not fn then
    warn("[Loader] Compile error in target script: " .. tostring(err))
    return
end

print("[Loader] Script loaded successfully. Executing...")
fn()
