-- ============================================================
-- VRILZHUB LOADER — RIDE A PET
-- Repo: vrilz-bot-exploit/vrilzhub
-- ============================================================

local CONFIG = {
    GameId = 124216119978534, -- Ride a Pet
    FeaturesURL = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/features_rideapet.lua",
    UIURL = "https://raw.githubusercontent.com/vrilz-bot-exploit/vrilzhub/main/ui_rideapet.lua",
}

-- ============================================================
-- CEK GAME
-- ============================================================
if game.PlaceId ~= CONFIG.GameId then
    local WS = game:GetService("Workspace")
    if not WS:FindFirstChild("RenderedEggs") then
        warn("[VRILZHUB] Bukan game Ride a Pet, abort")
        return
    end
end

print("[VRILZHUB] Loading...")

-- ============================================================
-- LOADER
-- ============================================================
local function loadScript(url, name)
    local ok, source = pcall(function() return game:HttpGet(url) end)
    if not ok or not source then
        warn("[VRILZHUB] Gagal load " .. name)
        return nil
    end
    local fn, err = loadstring(source)
    if not fn then
        warn("[VRILZHUB] Gagal compile " .. name .. ": " .. tostring(err))
        return nil
    end
    local ok2, result = pcall(fn)
    if not ok2 then
        warn("[VRILZHUB] Gagal execute " .. name .. ": " .. tostring(result))
        return nil
    end
    print("[VRILZHUB] " .. name .. " loaded OK")
    return result
end

-- ============================================================
-- LOAD FEATURES
-- ============================================================
print("[VRILZHUB] Loading features...")
local Features = loadScript(CONFIG.FeaturesURL, "features")
if not Features then return end

-- ============================================================
-- LOAD UI
-- ============================================================
print("[VRILZHUB] Loading UI...")
local UI = loadScript(CONFIG.UIURL, "ui")
if not UI then return end

-- ============================================================
-- INIT
-- ============================================================
local Shared = {}

-- ⭐ FIX: Expose Features ke _G dulu — TAPI JANGAN panggil Init()
-- Features.Init() akan dipanggil DARI DALAM UI.lua
-- setelah key valid + loading screen selesai + main window muncul.
_G.VRILZ_Features = Features
_G.VRILZ_Shared = Shared

-- ⭐ Cuma UI yang di-init di sini
UI.Init(Shared)

print("[VRILZHUB] SUCCESS! Ride a Pet loaded.")
