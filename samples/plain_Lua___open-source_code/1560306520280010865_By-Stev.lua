-- ==================================================
-- YOKUDO HUB | STEAL AN EGG | Loader
-- ✅ Load CharacterSystem មុន Features
-- ✅ VIPTP ជំនួស EggCheckPremium
-- ==================================================

local BASE_URL = "https://raw.githubusercontent.com/betdoyvaka/stealanegg/main/"

-- Copiar Discord al portapapeles al ejecutar
if setclipboard then
    setclipboard("https://discord.gg/AQUyu899hx")
elseif toclipboard then
    toclipboard("https://discord.gg/AQUyu899hx")
end

_G.YOKUDO_EnablePrint = false

local oldPrint = print
print = function(...)
    if _G.YOKUDO_EnablePrint then
        oldPrint(...)
    end
end

print("🔵 Loading YOKUDO HUB...")

-- ==================================================
-- CACHE SYSTEM
-- ==================================================
_G.YOKUDO_Cache = _G.YOKUDO_Cache or {}

local function GetScript(path)
    local fullPath = BASE_URL .. path
    if _G.YOKUDO_Cache[fullPath] then
        return _G.YOKUDO_Cache[fullPath]
    end
    local script = game:HttpGet(fullPath)
    _G.YOKUDO_Cache[fullPath] = script
    return script
end

-- ==================================================
-- WAIT UNTIL GAME IS LOADED
-- ==================================================
repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer

local Player = game.Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")

print("✅ Game loaded, Player: " .. Player.Name)

-- ==================================================
-- LOAD CORE FILES
-- ==================================================
loadstring(GetScript("Config.lua"))()
loadstring(GetScript("UI.lua"))()
loadstring(GetScript("Components.lua"))()

-- ==================================================
-- LOAD TABS MANAGER
-- ==================================================
loadstring(GetScript("Tabs/Init.lua"))()

-- ==================================================
-- LOAD FEATURES
-- ==================================================
loadstring(GetScript("Features/AntiAFK.lua"))()
loadstring(GetScript("Features/WalkSpeed.lua"))()
loadstring(GetScript("Features/AntiTrap.lua"))()
loadstring(GetScript("Features/GodMode.lua"))()
loadstring(GetScript("Features/TeleportSystem.lua"))()
loadstring(GetScript("Features/AutoFarm.lua"))()
loadstring(GetScript("Features/AutoAttack.lua"))()
loadstring(GetScript("Features/AFKSystem.lua"))()

-- ✅ VIPTP (AFK Farm Only) — ជំនួស EggCheckPremium
loadstring(GetScript("Features/VIPTP.lua"))()
loadstring(GetScript("Features/AttackDrone.lua"))()
loadstring(GetScript("Features/ManagerDrone.lua"))()
loadstring(GetScript("Features/ManualFastClick.lua"))()

-- ✅ FarmingManager (ប្រើ VIPTP + EggCheck Logic ខាងក្នុង)
loadstring(GetScript("Features/FarmingManager.lua"))()

-- ✅ ConfigSystem
loadstring(GetScript("Features/ConfigSystem.lua"))()

-- ==================================================
-- LOAD TABS
-- ==================================================
loadstring(GetScript("Tabs/Info.lua"))()
loadstring(GetScript("Tabs/Farming.lua"))()
loadstring(GetScript("Tabs/Combat.lua"))()
loadstring(GetScript("Tabs/AutoFarming.lua"))()
loadstring(GetScript("Tabs/Event.lua"))()
loadstring(GetScript("Tabs/HopServer.lua"))()
loadstring(GetScript("Tabs/Setting.lua"))()

-- ==================================================
-- SELECT DEFAULT TAB
-- ==================================================
if _G.YOKUDO_TabsManager then
    _G.YOKUDO_TabsManager:SelectTabByName("Info")
end
-- ==================================================
-- LOAD ANTI CHEAT
-- ==================================================
loadstring(GetScript("Features/BypassAntiCheat.lua"))()

-- ==================================================
-- ✅ WAIT 2 SECONDS THEN APPLY CONFIG
-- ==================================================
print("⏳ Waiting 2s before applying config...")
task.wait(2)

if _G.YOKUDO_ConfigSystem then
    print("🔧 Applying Config...")
    _G.YOKUDO_ConfigSystem.Load()
end
task.wait(0.3)
Loading.Destroy()
print("✅ Loading Screen Closed!")
print("🚀 YOKUDO HUB | Ready!")
