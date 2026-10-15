-- Null Hub v4 | full
print("[NH] boot")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")

local LP = Players.LocalPlayer
if not LP then repeat task.wait(0.1) until Players.LocalPlayer LP = Players.LocalPlayer end
local LOADER = loadstring or load

local OWNER_NAMES = {"griddyess123", "xyzlarpp", "ZennDontP1ay"}
local isOwner = false
for _, n in ipairs(OWNER_NAMES) do
    if LP.Name:lower() == n:lower() then isOwner = true break end
end

local function resolveParent()
    if type(gethui) == "function" then
        local ok, h = pcall(gethui)
        if ok and h then return h end
    end
    if type(get_hidden_gui) == "function" then
        local ok, h = pcall(get_hidden_gui)
        if ok and h then return h end
    end
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then
        local w = pcall(function()
            local t = Instance.new("ScreenGui")
            t.Parent = cg
            t:Destroy()
        end)
        if w then return cg end
    end
    return LP:WaitForChild("PlayerGui", 20)
end
local PARENT = resolveParent()
for _, ctr in ipairs({ PARENT, LP:FindFirstChildOfClass("PlayerGui") }) do
    if ctr then
        for _, c in ipairs(ctr:GetChildren()) do
            if c:IsA("ScreenGui") and c.Name:sub(1, 4) == "Null" then c:Destroy() end
        end
    end
end

local function mk(c, props, parent)
    local i = Instance.new(c)
    if props then for k, v in pairs(props) do i[k] = v end end
    if parent then i.Parent = parent end
    return i
end
local function corner(i, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = type(r) == "number" and UDim.new(0, r) or r
    c.Parent = i
    return c
end
local function stroke(i, col, thick, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or Color3.fromRGB(60, 60, 60)
    s.Thickness = thick or 1
    s.Transparency = trans or 0
    s.Parent = i
    return s
end
local function contrastText(bg)
    if typeof(bg) ~= "Color3" then return Color3.fromRGB(245, 245, 245) end
    local lum = bg.R * 0.299 + bg.G * 0.587 + bg.B * 0.114
    if lum > 0.55 then return Color3.fromRGB(15, 15, 15) end
    return Color3.fromRGB(245, 245, 245)
end

local CONFIG = {
    fabX = 0.85, fabY = 0.75,
    hudX = 0.02, hudY = 0.02,
    boost = false, hud = false,
    nametag = false, nt_mode = "custom",
    nt_text = "Null Hub User", nt_font = "GothamBold", nt_size = 20,
    nt_ox = 0, nt_oy = 3, nt_rot = 0,
    nt_h = 0.0, nt_s = 0.0, nt_v = 1.0,
    nt_rainbow = false, nt_rainbow_speed = 0.35,
    nt_shine = false, nt_shine_speed = 0.6,
    nt_outline = true, nt_outline_th = 1.5,
    nt_outline_h = 0.0, nt_outline_s = 0.0, nt_outline_v = 0.0,
    nt_glow = false,
    nt_show_self = true, nt_show_others = true,
    nt_max_dist = 250,
    banner_id = "119673234348896", icon_id = "89551531197606",
    key = "RightShift",
    warn_keyless = false, warn_keyed = false, warn_hubs = false,
    -- loading screen text
    load_title = "Null Hub",
    load_desc = "An All In One Script.",
    load_status = "Loading UI...",
    load_duration = 1.2,
}
local CONFIG_FILE = "NullHub_v4.cfg"
if isfile and isfile(CONFIG_FILE) then
    local ok, c = pcall(readfile, CONFIG_FILE)
    if ok and type(c) == "string" then
        for line in c:gmatch("[^\n]+") do
            local k, v = line:match("^([^=]+)=(.*)$")
            if k and CONFIG[k] ~= nil then
                local cur = CONFIG[k]
                if type(cur) == "number" then CONFIG[k] = tonumber(v) or cur
                elseif type(cur) == "boolean" then CONFIG[k] = (v == "true")
                else CONFIG[k] = v end
            end
        end
    end
end
local function saveConfig()
    if not writefile then return end
    local lines = {}
    for k, v in pairs(CONFIG) do table.insert(lines, k .. "=" .. tostring(v)) end
    pcall(writefile, CONFIG_FILE, table.concat(lines, "\n"))
end

local favorites = {}
if isfile and isfile("NullHub_v4_favs.txt") then
    local ok, c = pcall(readfile, "NullHub_v4_favs.txt")
    if ok and type(c) == "string" then
        for name in c:gmatch("[^\n]+") do if #name > 0 then favorites[name] = true end end
    end
end
local function saveFavs()
    if not writefile then return end
    local lines = {}
    for name in pairs(favorites) do table.insert(lines, name) end
    pcall(writefile, "NullHub_v4_favs.txt", table.concat(lines, "\n"))
end

local C = {
    bg = Color3.fromRGB(10, 10, 10), sheet = Color3.fromRGB(18, 18, 18),
    card = Color3.fromRGB(26, 26, 26), cardHi = Color3.fromRGB(38, 38, 38),
    bd = Color3.fromRGB(52, 52, 52), bdHi = Color3.fromRGB(88, 88, 88),
    txt = Color3.fromRGB(245, 245, 245), dim = Color3.fromRGB(150, 150, 150),
    faint = Color3.fromRGB(80, 80, 80), accent = Color3.fromRGB(255, 255, 255),
    good = Color3.fromRGB(220, 220, 220), warn = Color3.fromRGB(180, 180, 180),
    scrim = Color3.fromRGB(0, 0, 0),
    red = Color3.fromRGB(200, 60, 60),
    redBg = Color3.fromRGB(60, 20, 20),
    redTxt = Color3.fromRGB(255, 160, 160),
}

local FONT_LIST = {
    "Gotham", "GothamMedium", "GothamBold", "GothamBlack",
    "Roboto", "RobotoMono", "RobotoCondensed", "Code",
    "SourceSans", "SourceSansBold", "SourceSansLight", "SourceSansSemibold",
    "Ubuntu", "Oswald", "Merriweather", "Nunito", "Bangers", "FredokaOne", "LuckiestGuy",
    "Creepster", "PermanentMarker", "Kalam", "IndieFlower", "PatrickHand",
    "Fondamento", "Garamond", "JosefinSans", "Jura", "Sarpanch", "Michroma",
    "SciFi", "Fantasy", "Arcade", "Cartoon", "Antique", "Bodoni", "Legacy",
    "Highway", "AmaticSC", "DenkOne", "GrenzeGotisch", "SpecialElite", "TitilliumWeb",
}

local GAME_DB = {
    {name="Steal an Egg", ids={107778070777162}, keyless={
        {name="Clouthub ESP Egg Sniper", url="https://raw.githubusercontent.com/ClouthubOnTop/Loader/main/main.lua"},
        {name="Kira Hub Auto Steal Plot Serverhop", url="https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/KiraHub_Steal_An_Egg.lua"},
        {name="Monarch Hub Fly Box ESP", url="https://raw.githubusercontent.com/nobuxy/monarch.win/refs/heads/main/Monarch.lua"},
        {name="Pulse Hub Auto Equip Best Pets", url="https://raw.githubusercontent.com/PulseZax/Loader/refs/heads/main/.lua"},
        {name="Yokudo Hub Farming Combat", url="https://raw.githubusercontent.com/betdoyvaka/stealanegg/main/Loader.lua"},
        {name="Cyrus Hub Auto Steal Tween", url="https://raw.githubusercontent.com/CyrusOffc/scriptcyrus/refs/heads/main/loader"},
        {name="BK's Hub Rift Boss Capture", url="https://api.luarmor.net/files/v4/loaders/9ee4edde227ac85f50872bf9e4226508.lua"},
        {name="Ajjan's Hub Auto Farm", url="https://api.luarmor.net/files/v4/loaders/359e97f8618e9008afe5f496184ebb7c.lua"},
        {name="Chilli Hub V4", url="https://id.tomroblox.com/raw/kairoblox/chilli-hub-viet-hoa-v4", updated=true},
        {name="Ouroboros Hub Clone Auto Steal", url="https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
        {name="Gemini PVP ESP Aimbot", url="https://raw.githubusercontent.com/gemini-scripts/sae-pvp/main/loader.lua"},
        {name="Decode Auto Steal Infested", url="https://raw.githubusercontent.com/ItzYumi/Decode/refs/heads/main/DE%3ACODE.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Fake Admin", url="https://raw.githubusercontent.com/WhiteX1208/Scripts/refs/heads/main/StealAnEggs.luau"},
        {name="Foxname Hub", url="https://raw.githubusercontent.com/caomod2077/Script/refs/heads/main/Fn-stealanegg.lua"},
        {name="Oxide Hub", url="https://raw.githubusercontent.com/LSSOPS/OpenSource/refs/heads/main/OxideHub_Steal_An_Egg.lua"},
        {name="Rift Goha", url="https://raw.githubusercontent.com/Dodoyung24/script-core/main/Steal-An-Egg"},
        {name="BobloScript", url="https://raw.githubusercontent.com/bobloscript/scripts/refs/heads/main/StealAnEgg"},
        {name="Miranda Hub", url="https://raw.githubusercontent.com/miirandahub/loader/main/stealaeggs", broken=true},
        {name="Ronnei Hub", url="https://raw.githubusercontent.com/elonmod/skibidi/refs/heads/main/Ronneihub-keyless.lua"},
        {name="Hoshi Hub", url="https://hoshihub.site/loader.lua"},
        {name="Pig Hub", url="https://raw.githubusercontent.com/mopsscript7-gif/steal-an-egg/refs/heads/main/script.lua"},
        {name="Sena Hub V6", url="https://senahub.xyz/senav6", updated=true},
        {name="ON Hub", url="https://raw.githubusercontent.com/davizin713/ONhub/refs/heads/main/script.lua"},
        {name="Toolbox Hub", url="https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/loader"},
        {name="Zeroin Hub", url="https://zeroinhub.com/api/script"},
        {name="Blyxo Hub", url="https://flowauth.net/v1/loaders/69d3463240384f3a73fbe32c178093a2.lua", updated=true},
        {name="Valinc Hub", url="https://raw.githubusercontent.com/ValincHUB/loader/main/stealanegg.lua"},
        {name="Tsuo Hub", url="https://raw.githubusercontent.com/TsuoHub/loader/main/stealanegg.lua"},
        {name="Solix Hub", url="https://solixhub.com/loader", updated=true},
        {name="Genesis Hub", url="https://raw.githubusercontent.com/genesishub/sae/main/stealanegg.lua"},
        {name="Ronix Hub", url="https://raw.githubusercontent.com/ronixhub/sae/main/loader.lua"},
        {name="Rene Baterbonia", url="https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg"},
        {name="Cat Hub", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="Lennon Hub Farm V2", url="https://raw.githubusercontent.com/lennonxscripts/lennonhubv4/refs/heads/main/stealanegg", broken=true},
        {name="Lennon AFK", url="", broken=true},
        {name="VoidShell Hub", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/StealAnEgg.luau"},
        {name="Axurs Games Hub", url="https://raw.githubusercontent.com/XE3Scripts/Axur-sGamesHub/refs/heads/main/StealAnEgg"},
        {name="Wis Hub", url="https://api.wishub.cloud/files/loader.lua"},
        {name="Chiyo Hub", url="https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua"},
        {name="Asvra Hub", url="https://raw.githubusercontent.com/asvraRoblox/stealegg/refs/heads/main/main"},
        {name="Mono Hub", url="https://raw.githubusercontent.com/monohubscripts/steal-an-egg/main/loader.lua"},
        {name="Zenith Hub", url="https://raw.githubusercontent.com/ZenithHubRBX/StealAnEgg/main/loader.luau"},
        {name="Ghost Hub", url="https://raw.githubusercontent.com/GhostSAE/loader/main/stealanegg.lua"},
        {name="Raven Hub", url="https://raw.githubusercontent.com/ravenhubscripts/sae/main/loader.lua"},
        {name="Apex Hub", url="https://raw.githubusercontent.com/apexhubsae/main/loader.lua"},
        {name="Midnight Hub", url="https://raw.githubusercontent.com/midnighthub-sae/main/loader.lua"},
        {name="Eclipse Hub", url="https://raw.githubusercontent.com/eclipsehub-rbx/sae/main/stealanegg.lua"},
        {name="Solar Hub", url="https://raw.githubusercontent.com/solarhub-sae/loader/main/stealanegg.lua"},
        {name="Vortex Hub", url="https://raw.githubusercontent.com/vortexhub-rbx/stealanegg/main/loader.lua"},
        {name="Star Hub", url="https://raw.githubusercontent.com/starhubsae/loader/main/stealanegg.lua"},
        {name="Quantum Hub", url="https://raw.githubusercontent.com/quantumhub-rbx/sae/main/loader.luau"},
        {name="Flux Hub", url="https://raw.githubusercontent.com/fluxhub-sae/loader/main/stealanegg.lua"},
        {name="Onyx Hub", url="https://raw.githubusercontent.com/onyxhubscripts/sae/main/stealanegg.lua"},
        {name="Phantom Hub", url="https://raw.githubusercontent.com/phantomhub-rbx/sae/main/stealanegg.lua"},
        {name="Ember Hub", url="https://raw.githubusercontent.com/emberhubsae/loader/main/loader.lua"},
        {name="Titan Hub", url="https://raw.githubusercontent.com/titanhub-rbx/sae/main/loader.lua"},
        {name="Hydra Hub", url="https://raw.githubusercontent.com/hydrahub-sae/loader/main/stealanegg.lua"},
        {name="Venom Hub", url="https://raw.githubusercontent.com/venomhub-rbx/sae/main/loader.lua"},
        {name="Frost Hub", url="https://raw.githubusercontent.com/frosthubsae/loader/main/stealanegg.lua"},
        {name="Storm Hub", url="https://raw.githubusercontent.com/stormhub-rbx/sae/main/loader.lua"},
        {name="Cyclone Hub", url="https://raw.githubusercontent.com/cyclonehubsae/loader/main/loader.lua"},
        {name="Comet Hub", url="https://raw.githubusercontent.com/comethub-sae/loader/main/stealanegg.lua"},
        {name="Pulsar Hub", url="https://raw.githubusercontent.com/pulsarhubsae/loader/main/loader.luau"},
        {name="Abyss Hub", url="https://raw.githubusercontent.com/abysshub-rbx/sae/main/stealanegg.lua"},
        {name="Chaos Hub", url="https://raw.githubusercontent.com/chaoshubsae/loader/main/loader.lua"},
        {name="Sigma Hub", url="https://raw.githubusercontent.com/sigmahub-rbx/sae/main/stealanegg.lua"},
        {name="Orion Hub", url="https://raw.githubusercontent.com/orionhubsae/loader/main/loader.lua"},
        {name="Wraith Hub", url="https://raw.githubusercontent.com/wraithhub-sae/loader/main/stealanegg.luau"},
        {name="Spectre Hub", url="https://raw.githubusercontent.com/spectrehubsae/loader/main/loader.lua"},
        {name="Umbra Hub", url="https://raw.githubusercontent.com/umbrahub-rbx/sae/main/stealanegg.lua"},
        {name="Glitch Hub", url="https://raw.githubusercontent.com/glitchhubsae/loader/main/loader.lua"},
        {name="Project Madara", url="https://raw.githubusercontent.com/ProjectMadara/SAE/main/loader.lua"},
        {name="Leon Keyless", url="https://raw.githubusercontent.com/n01771542-cmd/faluahub/main/main.lua"},
        {name="Sharks Hub", url="https://luasnapper.up.railway.app/files/loaders/323055d1394c4a44977147da740e0ff7.lua"},
        {name="Sai Script", url="https://raw.githubusercontent.com/Saiscript-ops/SAI-V2-SCRIPT-DWIGHT-RAMOS-JOSUA-GARCIA/refs/heads/main/obfuscated_script-1789451046664.lua"},
        {name="Nexora", url="https://raw.githubusercontent.com/Dayvinksthik/Script/refs/heads/main/Games/JoshBNS-Crack.lua"},
        {name="Chronix", url="https://raw.githubusercontent.com/SmokeTY/Hidden-Scripts/main/Chronix%20Hub"},
        {name="Exoneo", url="https://raw.githubusercontent.com/EXOOHUB/EXOHUBZ/refs/heads/main/EXONEOSCRIPT"},
        {name="Darkness Hub", url="https://raw.githubusercontent.com/Darkness-KingScripts/Steal-a-egg/refs/heads/main/Darknesshub"},
        {name="Equinox Anti Hit", url="https://api.jnkie.com/api/v1/luascripts/public/3db06e0eaa1e4e8bf5e9d3192fa71e0bad2d1d1af5b11c0a58e6b708ad4487f4/download"},
        {name="Andrei Script Hub V2", url="https://raw.githubusercontent.com/jokriziahpunu-source/Andrei-hub-multi/main/hub.lua", updated=true},
        {name="Zenith V2", url="https://raw.githubusercontent.com/ZenithHubRBX/StealAnEgg/main/v2.luau"},
        {name="Nebula Hub", url="https://raw.githubusercontent.com/nebulascripts/sae/main/loader.lua"},
        {name="Polar Hub", url="https://raw.githubusercontent.com/polarhubsae/loader/main/stealanegg.lua"},
        {name="Ignite Hub", url="https://raw.githubusercontent.com/ignitehubsae/main/loader.lua"},
        {name="Prism Hub", url="https://raw.githubusercontent.com/prismhub-rbx/sae/main/loader.lua"},
        {name="Zephyr Hub", url="https://raw.githubusercontent.com/zephyrhubsae/main/stealanegg.lua"},
    }, keyed={
        {name="Neva Hub Auto Farm Egg Selection", url="https://raw.githubusercontent.com/VEZ2/NEVAHUB/main/2"},
        {name="Snowy Hub Auto Farm", url="https://flowauth.net/v1/ui/a87f00d9adf63658655fcd02ab86a4ef.lua"},
        {name="Rscripts Auto Steal Secret Eggs", url="https://rscripts.net/raw/auto-steal-secret-eggs-auto-pets-auto-tool-30-more_1787628515262_YDShlrZ5VL.txt"},
        {name="Goha Angel and Demon", url="https://goha.dev/loader/stealanegg"},
        {name="Nasi Rendang Hub", url="https://raw.githubusercontent.com/JualNasiRendang/loader/refs/heads/main/main.lua"},
        {name="OMG Hub", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="Nova Hub", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="ScriptVerse", url="https://scriptversekey.xyz/s/steal-an-egg-pet-spawner"},
        {name="NEOX Hub", url="https://raw.githubusercontent.com/hassanxzayn-lua/NEOXHUBMAIN/refs/heads/main/loader"},
        {name="Axon Hub", url="https://api.luarmor.net/files/v3/loaders/97c3f6db55a2cf72141537a85458e5a7.lua"},
        {name="Fishy Hub", url="https://api.jnkie.com/api/v1/luascripts/public/4965c0d52f5d1dde43256d20cb1f511f225b45a1b370fccc4e6ba7252df76d88/download"},
        {name="BigFroot Hub", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
        {name="CloverHub", url="https://raw.githubusercontent.com/Ryuun0x/Clover/refs/heads/main/main.lua"},
        {name="Lumin Hub", url="https://raw.githubusercontent.com/luminhub-sae/loader/main/loader.lua"},
        {name="Zware", url="https://api.luarmor.net/files/v4/loaders/53f54e99aa490d4741858889f586475a.lua"},
        {name="Krnl Premium", url="https://api.luarmor.net/files/v4/loaders/bf1faa9c9cf7e3bb2d9cdba8f3a1d8d5.lua"},
        {name="Aurora Hub", url="https://flowauth.net/v1/loaders/aurora-sae-loader.lua"},
        {name="Cobalt Hub", url="https://api.luarmor.net/files/v4/loaders/cobalt-sae-loader.lua"},
        {name="Nemesis Hub", url="https://flowauth.net/v1/loaders/nemesis-sae.lua"},
        {name="Phantasm", url="https://api.luarmor.net/files/v4/loaders/phantasm-sae.lua"},
        {name="Obsidian Hub", url="https://flowauth.net/v1/loaders/obsidian-sae.lua"},
        {name="Nebula Hub", url="https://flowauth.net/v1/loaders/nebula-sae.lua"},
        {name="Cosmic Hub", url="https://api.luarmor.net/files/v4/loaders/cosmic-sae.lua"},
        {name="Astral Hub", url="https://flowauth.net/v1/loaders/astral-sae.lua"},
        {name="Reaper Hub", url="https://api.luarmor.net/files/v4/loaders/reaper-sae.lua"},
        {name="Kraken Hub", url="https://flowauth.net/v1/loaders/kraken-sae.lua"},
        {name="Fusion Hub", url="https://api.luarmor.net/files/v4/loaders/fusion-sae.lua"},
        {name="Elemental Hub", url="https://flowauth.net/v1/loaders/elemental-sae.lua"},
        {name="Moonblack Hub", url="https://raw.githubusercontent.com/MoonblackSAE/loader/main/stealanegg.lua"},
        {name="Nyx Hub", url="https://flowauth.net/v1/loaders/nyx-sae.lua"},
        {name="Wraith Syndicate", url="https://api.luarmor.net/files/v4/loaders/wraith-sae.lua"},
        {name="Void Hub", url="https://flowauth.net/v1/loaders/void-sae.lua"},
        {name="Lunaris Hub", url="https://raw.githubusercontent.com/lunarishub/sae/main/loader.lua"},
        {name="SolvexGUI", url="https://raw.githubusercontent.com/SolvexGUI/SAE/main/loader.lua"},
        {name="Nexus Hub", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/stealanegg.lua"},
        {name="Valinc Syndicate", url="https://raw.githubusercontent.com/ValincSyndicate/loader/main/stealanegg.lua"},
        {name="Fyy Community", url="https://FyyCommunity.my.id"},
        {name="Hyperion Hub", url="https://api.luarmor.net/files/v4/loaders/hyperion-sae.lua"},
        {name="Wraith Hub V2", url="https://api.luarmor.net/files/v4/loaders/wraith-v2-sae.lua"},
    }},
    {name="Break and Steal an Egg", ids={114326934417838}, keyless={
        {name="Ouroboros Hub Auto Sell Egg ESP", url="https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
        {name="Ronix Hub Break and Steal", url="https://raw.githubusercontent.com/ronixhub/sae/main/stealanegg.lua"},
        {name="Solix Hub Break and Steal", url="https://raw.githubusercontent.com/solixhub/sae/main/loader.lua"},
        {name="Genesis Hub Break and Steal", url="https://raw.githubusercontent.com/genesishub/sae/main/stealanegg.lua"},
        {name="Nexus Hub Break and Steal", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/stealanegg.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="Sena Hub V6", url="https://senahub.xyz/senav6", updated=true},
        {name="Zenith Hub BAS", url="https://raw.githubusercontent.com/ZenithHubRBX/BreakStealEgg/main/loader.luau"},
        {name="VoidShell Hub BAS", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/BreakStealEgg.luau"},
    }, keyed={
        {name="Break a Brainrot Egg Auto Hit", url="https://bypass.tools/roblox/scripts/break-a-brainrot-egg"},
        {name="Goha Dev Key System", url="https://goha.dev/loader/breakandsteal"},
        {name="Rscripts Break and Steal", url="https://rscripts.net/raw/break-and-steal-an-egg_1787628515262_YDShlrZ5VL.txt"},
        {name="Zware BAS Keyed", url="https://api.luarmor.net/files/v4/loaders/zware-bas.lua"},
        {name="Lumin BAS Keyed", url="https://flowauth.net/v1/loaders/lumin-bas.lua"},
    }},
    {name="Karinderya", ids={116497287371701}, keyless={
        {name="Baan Hub Two Game Router", url="https://raw.githubusercontent.com/fast007x2-blip/baan-hub/main/baan-hub.lua"},
        {name="Kosowa Auto Serve Auto Hit", url="https://raw.githubusercontent.com/kosowa02/x/refs/heads/main/karinderya"},
        {name="Zanxanax All In One", url="https://raw.githubusercontent.com/Zanxanax/scripts/main/Loader.lua"},
        {name="Kronos Multi-Game 142 Games", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
        {name="Ouroboros Hub v0.17 Beta Auto Play", url="https://raw.githubusercontent.com/joustingmatch/Ouroboros/main/loader.lua"},
        {name="Ronix Ron Menu Auto Farm", url="https://rscripts.net/raw/ron-menu-karinderya_1787628515262_YDShlrZ5VL.txt"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="Rene Baterbonia Multi", url="https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg"},
    }, keyed={
        {name="JinHub Auto Farm Everything", url="https://rscripts.net/raw/jinhub-karinderya_1787628515262_YDShlrZ5VL.txt"},
        {name="Paid Key Menu Auto Farm Auto Hit", url="https://api.jnkie.com/api/v1/luascripts/public/bcd7acc3f118f84e5356caa35244996cee11fea9deead0ebd94bfe9a1b18b7f7/download"},
        {name="OMG Hub Karinderya", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot Hub Karinderya", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    }},
    {name="Ride a Pet", ids={124216119978534}, keyless={
        {name="Decode Full Config ESP", url="https://raw.githubusercontent.com/ItzYumi/Decode/refs/heads/main/DE%3ACODE.lua"},
        {name="sapka342 Egg Autofarm", url="https://raw.githubusercontent.com/sapka342-sudo/sapka-rblx/refs/heads/main/ride-a-pet.luau"},
        {name="XyronHub Auto Farm Auto Upg Luck", url="https://raw.githubusercontent.com/vikrantsudo/XyronHub/refs/heads/main/RideAPet"},
        {name="NemoHub Eggs ESP Autofarm", url="https://raw.githubusercontent.com/NemoScripts/NemoHubGames/refs/heads/main/besthub"},
        {name="ThiAez Auto Best Eggs ESP", url="https://raw.githubusercontent.com/GZSSF/RideAPet/refs/heads/main/RideAPet"},
        {name="Darkduy Egg ESP Teleport", url="https://raw.githubusercontent.com/darkduy/lua/refs/heads/main/ride-a-pet.lua"},
        {name="EGGIUM Rare Egg ESP Fly Home", url="https://pastebin.com/raw/qWb1aCUk"},
        {name="Axel FF Auto Farm Ranch Teleport", url="https://raw.githubusercontent.com/Axel-FF/MONTAR-UNA-MASCOTA/refs/heads/main/Script.txt"},
        {name="Serenity Hub Auto Steal Auto Feed", url="https://raw.githubusercontent.com/SerenityHubRBX/loader/main/rideapet.lua"},
        {name="Akaz Hub Farm Rarities ESP", url="https://akazhub.netlify.app/script.lua"},
        {name="Bac0nH1ckOff Auto Collect Egg", url="https://raw.githubusercontent.com/Bac0nH1ck/Scripts/refs/heads/main/rideapet.lua"},
        {name="xRoxyHubx", url="https://raw.githubusercontent.com/xRoxyHubx/Ride-A-Pet/refs/heads/main/Script"},
        {name="Porqueijjmzm Hub", url="https://raw.githubusercontent.com/porqueijjmzm1/cool/main/RideAPet"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="Rene Baterbonia Multi", url="https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg"},
        {name="Sena Hub V6", url="https://senahub.xyz/senav6", updated=true},
        {name="VoidShell Hub", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/RideAPet.luau"},
    }, keyed={
        {name="Chiyo Hub Auto Farm Place Hatch", url="https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/chiyo.lua"},
        {name="LunaHub Auto Farm Place Hatch", url="https://rscripts.net/raw/lunahub-ride-a-pet_1787628515262_YDShlrZ5VL.txt"},
        {name="Acro Hub Easy Key 15+ Games", url="https://rscripts.net/raw/acro-hub-ride-a-pet_1787628515262_YDShlrZ5VL.txt"},
        {name="ZapretHub OP Autofarm", url="https://rscripts.net/raw/zaprethub-ride-a-pet_1787628515262_YDShlrZ5VL.txt"},
        {name="WolaWar Auto Dragon Egg", url="https://raw.githubusercontent.com/APRelease/WolaWar/refs/heads/main/rbx.lua"},
        {name="Nova Hub RideAPet", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="CloverHub RideAPet", url="https://raw.githubusercontent.com/Ryuun0x/Clover/refs/heads/main/main.lua"},
    }},
    {name="Blox Fruits", ids={2753915549, 4442272183, 7449423635}, keyless={
        {name="Gravity Hub Auto Farm Magnet", url="https://raw.githubusercontent.com/Dev-GravityHub/BloxFruit/main/MainPremium.lua"},
        {name="Axonic Blox Fruits OP", url="https://raw.githubusercontent.com/Kenniel123/Axonic/main/BloxFruits"},
        {name="Redz Hub", url="https://raw.githubusercontent.com/tlredz/Scripts/refs/heads/main/main.luau"},
        {name="Banana Cat Hub", url="https://raw.githubusercontent.com/VoidDeveloper67/VoidHub/refs/heads/main/Void"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="HoHo Hub", url="https://raw.githubusercontent.com/acsu123/HOHO_H/main/Loading_UI"},
        {name="Nix Hub", url="https://raw.githubusercontent.com/NYX8HUB/premium/refs/heads/main/script"},
        {name="Hermanos Hub PvP", url="https://raw.githubusercontent.com/hermanos-dev/hermanos-hub/refs/heads/main/Loader.lua"},
        {name="Spiem Hub Universal", url="https://raw.githubusercontent.com/SpiemHub/Spiem/main/loader.lua"},
        {name="Tgferr AFK Fruit Sniper", url="https://api.tgferr.com.br/nexusproxy"},
        {name="Mukuro Hub", url="https://raw.githubusercontent.com/MukuroHub/BloxFruits/main/loader.lua"},
        {name="Mekx Hub", url="https://raw.githubusercontent.com/MekxHub/BloxFruits/main/loader.lua"},
        {name="Rayfield Blox Fruits", url="https://raw.githubusercontent.com/realRayfield/Rayfield/main/loader.lua"},
        {name="Vape V4", url="https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/NewMainScript.lua"},
        {name="Blacktide Hub", url="https://raw.githubusercontent.com/Blacktide-Hub/loaders/main/bf.lua"},
        {name="Chest Hub Premium", url="https://raw.githubusercontent.com/chesthub/BloxFruits/main/loader.lua"},
        {name="W AZ Hub", url="https://raw.githubusercontent.com/W-A-Z-Hub/Blox-Fruits/main/loader.lua"},
    }, keyed={
        {name="Quantum Onyx Hub", url="https://api.luarmor.net/files/v4/loaders/0ae9fe4cf963e3a13d25eed0e2ce5940.lua"},
        {name="Banana Cat Hub Keyed", url="https://raw.githubusercontent.com/obiiyeuem/vthangsitink/main/BananaHub.lua"},
        {name="Ripper Hub Blox Fruits", url="https://api.luarmor.net/files/v4/loaders/ripper-bf.lua"},
        {name="Lumin Hub Blox Fruits", url="https://flowauth.net/v1/loaders/lumin-bf.lua"},
        {name="Cobalt Hub Blox Fruits", url="https://api.luarmor.net/files/v4/loaders/cobalt-bf.lua"},
        {name="Zware Blox Fruits", url="https://api.luarmor.net/files/v4/loaders/zware-bf.lua"},
    }},
    {name="Pet Simulator 99", ids={8737899170}, keyless={
        {name="ZWARE Full Menu", url="https://raw.githubusercontent.com/zware-dev/ps99/main/loader.lua"},
        {name="Axonic Keyless", url="https://raw.githubusercontent.com/Kenniel123/Axonic/main/PS99"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub PS99", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/PS99.luau"},
        {name="Nexus PS99", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/ps99.lua"},
        {name="Kronos PS99", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
    }, keyed={
        {name="Nova Hub PS99", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="CloverHub PS99", url="https://raw.githubusercontent.com/Ryuun0x/Clover/refs/heads/main/main.lua"},
        {name="OMG Hub PS99", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot PS99", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    }},
    {name="Grow a Garden 2", ids={126884695634066}, keyless={
        {name="Foxname GAG2 Auto Steal", url="https://raw.githubusercontent.com/foxname/GAG2/main/loader.lua"},
        {name="VantaXock Hub Get Any Seeds", url="https://raw.githubusercontent.com/VantaXock/GAG/main/loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="Kronos GAG2", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
        {name="Rene Baterbonia Multi", url="https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg"},
        {name="Sena Hub V6", url="https://senahub.xyz/senav6", updated=true},
        {name="VoidShell Hub GAG2", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/GAG.luau"},
        {name="Nexus GAG2", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/gag.lua"},
    }, keyed={
        {name="Nova Hub GAG2", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub GAG2", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot GAG2", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
        {name="Lumin GAG2", url="https://flowauth.net/v1/loaders/lumin-gag.lua"},
        {name="Zware GAG2", url="https://api.luarmor.net/files/v4/loaders/zware-gag.lua"},
    }},
    {name="Fisch", ids={16732694052}, keyless={
        {name="MUR4SCRIPTS Auto Reel", url="https://raw.githubusercontent.com/MUR4SCRIPTS/Fisch/main/loader.lua"},
        {name="Spiem Hub Universal", url="https://raw.githubusercontent.com/SpiemHub/Spiem/main/loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="Kronos Fisch", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
        {name="VoidShell Hub Fisch", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/Fisch.luau"},
        {name="Nexus Fisch", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/fisch.lua"},
    }, keyed={
        {name="Nova Hub Fisch", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub Fisch", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot Fisch", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
        {name="Zware Fisch", url="https://api.luarmor.net/files/v4/loaders/zware-fisch.lua"},
    }},
    {name="Blade Ball", ids={13772394625}, keyless={
        {name="SP HUB Auto Parry", url="https://raw.githubusercontent.com/SPHub/BladeBall/main/loader.lua"},
        {name="Auto Parry KEYLESS", url="https://raw.githubusercontent.com/hyuxalt/loader/refs/heads/main/BB-loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub BladeBall", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/BladeBall.luau"},
        {name="Nexus BladeBall", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/bladeball.lua"},
        {name="Kronos BladeBall", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
    }, keyed={
        {name="Nova Hub BladeBall", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub BladeBall", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot BladeBall", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    }},
    {name="Dead Rails", ids={122491342124111}, keyless={
        {name="Vexon Hub Freeze Mobs", url="https://raw.githubusercontent.com/VexonHub/DeadRails/main/loader.lua"},
        {name="Auto Farm Bonds", url="https://raw.githubusercontent.com/cashaura/DeadRails/refs/heads/main/cashrails.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub DeadRails", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/DeadRails.luau"},
        {name="Nexus DeadRails", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/deadrails.lua"},
    }, keyed={
        {name="Nova Hub DeadRails", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub DeadRails", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
    }},
    {name="Blue Lock Rivals", ids={15873858868}, keyless={
        {name="Auto Get Ball Auto Steal", url="https://raw.githubusercontent.com/BlueLockScripts/Rivals/main/loader.lua"},
        {name="NESS Lock Script", url="https://raw.githubusercontent.com/NESS/Rivals/main/loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub BLR", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/BlueLockRivals.luau"},
        {name="Nexus BlueLock", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/bluelock.lua"},
        {name="Kronos BlueLock", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
    }, keyed={
        {name="Nova Hub BlueLock", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub BlueLock", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot BlueLock", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    }},
    {name="The Forge", ids={128934324163117}, keyless={
        {name="Bonk Hub Auto Farm", url="https://raw.githubusercontent.com/BonkHub/TheForge/main/loader.lua"},
        {name="Keyless Auto Forge", url="https://api.luarmor.net/files/v3/loaders/280c3c5ae0ed18010fea0d86c424fdb5.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub Forge", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/TheForge.luau"},
        {name="Nexus TheForge", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/theforge.lua"},
    }, keyed={
        {name="Nova Hub TheForge", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub TheForge", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
    }},
    {name="99 Nights in the Forest", ids={122272339107315}, keyless={
        {name="RINGTA SCRIPT Teleport Kill Aura", url="https://raw.githubusercontent.com/RingtaHub/99Nights/main/ringta.lua"},
        {name="HubAurora Auto Win", url="https://raw.githubusercontent.com/HubAurora/99Nights/main/loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub 99N", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/99Nights.luau"},
        {name="Nexus 99Nights", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/99nights.lua"},
        {name="Kronos 99Nights", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
    }, keyed={
        {name="Nova Hub 99Nights", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub 99Nights", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot 99Nights", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    }},
    {name="Adopt Me", ids={920587237}, keyless={
        {name="House Cloner", url="https://raw.githubusercontent.com/AdoptMeScripts/HouseCloner/main/loader.lua"},
        {name="ByteLaunch Egg Farmer", url="https://raw.githubusercontent.com/ByteLaunch/AdoptMe/main/loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub Adopt", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/AdoptMe.luau"},
        {name="Nexus AdoptMe", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/adoptme.lua"},
        {name="Kronos AdoptMe", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
    }, keyed={
        {name="Nova Hub AdoptMe", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub AdoptMe", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot AdoptMe", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
    }},
    {name="Murder Mystery 2", ids={142823291}, keyless={
        {name="Yarhm Hub OP", url="https://raw.githubusercontent.com/YarhmHub/MM2/main/loader.lua"},
        {name="Kuni Hub Autofarm", url="https://raw.githubusercontent.com/KuniHub/MM2/main/loader.lua"},
        {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua"},
        {name="Cat Hub Universal", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub"},
        {name="Bee Hub Universal", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua"},
        {name="VoidShell Hub MM2", url="https://raw.githubusercontent.com/VoidShell-null/VoidShell-Hub/refs/heads/main/Scripts/MM2.luau"},
        {name="Nexus MM2", url="https://raw.githubusercontent.com/NexusScripts-hub/loader/main/mm2.lua"},
        {name="Kronos MM2", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua"},
    }, keyed={
        {name="Nova Hub MM2", url="https://raw.githubusercontent.com/NovaHubRBLX/NovaHub/refs/heads/main/novahub.lua"},
        {name="OMG Hub MM2", url="https://raw.githubusercontent.com/Omgshit/Scripts/main/MainLoader.lua", updated=true},
        {name="BigFroot MM2", url="https://raw.githubusercontent.com/hanniii1/Loader/refs/heads/main/BFLoader.lua"},
        {name="Zware MM2", url="https://api.luarmor.net/files/v4/loaders/zware-mm2.lua"},
    }},
}
local HUBS_DB = {
    {name="Rene Baterbonia Hub", url="https://raw.githubusercontent.com/sabscrip-arch/srver/refs/heads/main/Stealanegg", desc="Multi-game hub"},
    {name="Bee Hub", url="https://flowauth.net/v1/loaders/026c52c6ec62cd086277f45a113a680a.lua", desc="Multi-game keyless"},
    {name="Cat Hub", url="https://raw.githubusercontent.com/showscript-hub/Script/refs/heads/main/Cat-hub", desc="Multi-game universal"},
    {name="Kronos Multi-Game", url="https://raw.githubusercontent.com/Nanana291/Kronos/refs/heads/main/Loader.lua", desc="142 games"},
    {name="Speed Hub X", url="https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", desc="Multi-game utility"},
    {name="Spiem Hub Universal", url="https://raw.githubusercontent.com/SpiemHub/Spiem/main/loader.lua", desc="Universal collection"},
    {name="Baan Hub Router", url="https://raw.githubusercontent.com/fast007x2-blip/baan-hub/main/baan-hub.lua", desc="Two-game router"},
    {name="Zanxanax All In One", url="https://raw.githubusercontent.com/Zanxanax/scripts/main/Loader.lua", desc="Multi-game AIO"},
}

local OTHER_SCRIPTS = {
    {name="Infinite Yield", url="https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"},
    {name="Fly V3", url="https://raw.githubusercontent.com/XNEOFF/FlyGuiV3/main/FlyGuiV3.txt"},
    {name="Youtube Player VFree", url="https://raw.githubusercontent.com/zxcursedsocute/Youtube-Music-Player-Free/refs/heads/main/loader"},
    {name="Emotes And Animations (7yd7)", url="https://scriptblox.com/raw/Universal-Script-7yd7-Emote-Animation-Script-UGC-140678"},
    {name="Dark Dex", url="https://raw.githubusercontent.com/Babyhamsta/RBXScripts/master/Utility/Dex.lua"},
    {name="Owl Hub Universal", url="https://raw.githubusercontent.com/OwlHubRBX/OwlHub/main/OwlHub.lua"},
    {name="Hydroxide", url="https://raw.githubusercontent.com/Upbolt/Hydroxide/master/Loader.lua"},
    {name="Unnamed ESP", url="https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua"},
}

local currentGame = nil
for _, g in ipairs(GAME_DB) do
    for _, id in ipairs(g.ids) do
        if id == game.PlaceId then currentGame = g break end
    end
    if currentGame then break end
end

-- Unsupported-game gate
if not currentGame then
    local unsupGui = mk("ScreenGui", {
        Name = "NullHub_Unsupported", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true, DisplayOrder = 200000, Parent = PARENT,
    })
    local back = mk("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = C.bg, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, Parent = unsupGui,
    })
    local card = mk("Frame", {
        Size = UDim2.new(0, 380, 0, 420),
        Position = UDim2.new(0.5, -190, 0.5, -210),
        BackgroundColor3 = C.sheet, BorderSizePixel = 0, Parent = back,
    })
    corner(card, 16) stroke(card, C.bdHi, 1.2, 0.2)
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 28), Position = UDim2.fromOffset(16, 18),
        BackgroundTransparency = 1, Text = "Game Unsupported",
        TextColor3 = C.txt, TextSize = 18, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
    })
    mk("TextLabel", {
        Size = UDim2.new(1, -32, 0, 18), Position = UDim2.fromOffset(16, 48),
        BackgroundTransparency = 1, Text = "Supported Games:",
        TextColor3 = C.dim, TextSize = 12, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, Parent = card,
    })
    local listFrame = mk("ScrollingFrame", {
        Size = UDim2.new(1, -32, 1, -132), Position = UDim2.fromOffset(16, 70),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = C.bdHi,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = card,
    })
    corner(listFrame, 10)
    local lLay = Instance.new("UIListLayout")
    lLay.Padding = UDim.new(0, 2)
    lLay.SortOrder = Enum.SortOrder.LayoutOrder
    lLay.Parent = listFrame
    local lPad = Instance.new("UIPadding")
    lPad.PaddingTop = UDim.new(0, 8)
    lPad.PaddingLeft = UDim.new(0, 12)
    lPad.PaddingRight = UDim.new(0, 12)
    lPad.PaddingBottom = UDim.new(0, 8)
    lPad.Parent = listFrame
    for i, g in ipairs(GAME_DB) do
        mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1,
            Text = "- " .. g.name, TextColor3 = C.txt, TextSize = 13,
            Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = i, Parent = listFrame,
        })
    end
    local closeU = mk("TextButton", {
        Size = UDim2.new(1, -32, 0, 44), Position = UDim2.new(0, 16, 1, -58),
        BackgroundColor3 = C.accent, Text = "Close", TextColor3 = C.bg,
        TextSize = 14, Font = Enum.Font.GothamBold,
        AutoButtonColor = false, Parent = card,
    })
    corner(closeU, 10)
    closeU.MouseButton1Click:Connect(function()
        pcall(function() unsupGui:Destroy() end)
    end)
    print("[NH] unsupported game: " .. tostring(game.PlaceId))
    return
end

-- ==================== NEW LOADING SCREEN ====================
do
    local loadGui = mk("ScreenGui", {
        Name = "NullHub_Load", ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        IgnoreGuiInset = true, DisplayOrder = 200001, Parent = PARENT,
    })

    -- fullscreen 50% black backdrop
    local backdrop = mk("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0, Parent = loadGui,
    })

    -- centered card
    local CARD_W, CARD_H = 360, 160
    local card = mk("Frame", {
        Size = UDim2.fromOffset(CARD_W, CARD_H),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(190, 190, 190),
        BorderSizePixel = 0, Parent = backdrop,
    })
    corner(card, 22)
    stroke(card, Color3.fromRGB(230, 230, 230), 1, 0.5)

    -- grey → white gradient on the card
    local cardGrad = Instance.new("UIGradient")
    cardGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(130, 130, 130)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(200, 200, 200)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(245, 245, 245)),
    })
    cardGrad.Rotation = 90
    cardGrad.Parent = card

    -- logo tile (left)
    local logoBox = mk("Frame", {
        Size = UDim2.fromOffset(110, 110),
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.new(0, 24, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0, Parent = card,
    })
    corner(logoBox, 18)
    local logoImg = mk("ImageLabel", {
        Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1,
        Image = "rbxassetid://" .. CONFIG.icon_id,
        ScaleType = Enum.ScaleType.Fit,
        Parent = logoBox,
    })
    local logoPad = Instance.new("UIPadding")
    logoPad.PaddingLeft = UDim.new(0, 12)
    logoPad.PaddingRight = UDim.new(0, 12)
    logoPad.PaddingTop = UDim.new(0, 12)
    logoPad.PaddingBottom = UDim.new(0, 12)
    logoPad.Parent = logoBox

    -- title text
    mk("TextLabel", {
        Size = UDim2.new(1, -170, 0, 34),
        Position = UDim2.fromOffset(150, 30),
        BackgroundTransparency = 1,
        Text = CONFIG.load_title,
        TextColor3 = Color3.fromRGB(15, 15, 15),
        TextSize = 32, Font = Enum.Font.GothamBlack,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd,
        Parent = card,
    })

    -- description
    mk("TextLabel", {
        Size = UDim2.new(1, -170, 0, 44),
        Position = UDim2.fromOffset(150, 68),
        BackgroundTransparency = 1,
        Text = CONFIG.load_desc,
        TextColor3 = Color3.fromRGB(45, 45, 45),
        TextSize = 14, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = card,
    })

    -- loading status text
    local statusLbl = mk("TextLabel", {
        Size = UDim2.new(1, -40, 0, 18),
        Position = UDim2.new(0, 20, 1, -30),
        BackgroundTransparency = 1,
        Text = CONFIG.load_status,
        TextColor3 = Color3.fromRGB(30, 30, 30),
        TextSize = 14, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = card,
    })

    -- animated dots
    task.spawn(function()
        local dotCount = 0
        while loadGui.Parent do
            dotCount = (dotCount % 3) + 1
            statusLbl.Text = CONFIG.load_status:gsub("%.+$", "") .. string.rep(".", dotCount)
            task.wait(0.35)
        end
    end)

    task.spawn(function()
        task.wait(CONFIG.load_duration or 1.2)
        pcall(function() loadGui:Destroy() end)
    end)
end
-- ================== END LOADING SCREEN ==================

local BLOB_URL = "https://jsonblob.com/api/jsonBlob/01a10bc3-a91e-70e1-abe7-31444ee80ac0"
local annSeen = ""
if isfile and isfile("NullHub_v4_annseen.txt") then
    local ok, c = pcall(readfile, "NullHub_v4_annseen.txt")
    if ok and type(c) == "string" then annSeen = c:gsub("%s+", "") end
end
local function httpGet(url)
    local ok, b = pcall(function() return game:HttpGet(url) end)
    if ok and type(b) == "string" and #b > 0 then return b end
    if request then
        local ok2, r = pcall(request, {Url=url, Method="GET"})
        if ok2 and r and r.Body then return r.Body end
    end
end
local function httpPut(url, body)
    local hdrs = {["Content-Type"]="application/json"}
    local fns = {}
    if request then table.insert(fns, request) end
    if http_request then table.insert(fns, http_request) end
    if http and http.request then table.insert(fns, http.request) end
    if syn and syn.request then table.insert(fns, syn.request) end
    for _, fn in ipairs(fns) do
        local ok, r = pcall(fn, {Url=url, Method="PUT", Headers=hdrs, Body=body})
        if ok and r then
            local sc = r.StatusCode or r.status or 200
            if sc >= 200 and sc < 300 then return true end
        end
    end
    return false
end
local function readBlob()
    local raw = httpGet(BLOB_URL)
    if not raw or #raw < 2 then return nil end
    local trimmed = raw:gsub("^%s+", ""):gsub("%s+$", "")
    if trimmed == "null" or trimmed == "" then return nil end
    local ok, d = pcall(function() return HttpService:JSONDecode(trimmed) end)
    if not ok or type(d) ~= "table" then return nil end
    return d
end
local function writeBlob(tbl) return httpPut(BLOB_URL, HttpService:JSONEncode(tbl)) end

local openSheet, closeSheet, sheetOpen = nil, nil, false
local switchPage, previousPage, currentPage, comingSoonOverlay
local showAnnouncement
local ownerRainbowUntil = 0

local gui = mk("ScreenGui", {
    Name = "NullHub_v4", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true, DisplayOrder = 99999, Parent = PARENT,
})
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local isMobile = UIS.TouchEnabled
local fabSize = isMobile and 74 or 66
local fab = mk("TextButton", {
    Name = "FAB",
    Size = UDim2.fromOffset(fabSize, fabSize),
    Position = UDim2.new(CONFIG.fabX, 0, CONFIG.fabY, 0),
    BackgroundColor3 = C.card, Text = "",
    AutoButtonColor = false, Active = true, Selectable = true,
    ZIndex = 100, Parent = gui,
})
corner(fab, UDim.new(1, 0))
stroke(fab, C.bdHi, 1.5, 0.25)
local fabIcon = mk("ImageLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Image = "rbxassetid://" .. CONFIG.icon_id,
    ScaleType = Enum.ScaleType.Crop,
    ZIndex = 101, Parent = fab,
})
corner(fabIcon, UDim.new(1, 0))
local fabDot = mk("Frame", {
    Size = UDim2.fromOffset(12, 12),
    Position = UDim2.new(1, -18, 0, 2),
    BackgroundColor3 = C.txt, BorderSizePixel = 0,
    ZIndex = 102, Parent = fab,
})
corner(fabDot, UDim.new(1, 0))

do
    local fabDrag, fabInput, fabMoved = nil, nil, false
    fab.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if fabInput then return end
        fabInput = i
        fabDrag = {start = i.Position, orig = fab.Position}
        fabMoved = false
    end)
    UIS.InputChanged:Connect(function(i)
        if not fabDrag or i ~= fabInput then return end
        local d = i.Position - fabDrag.start
        if math.abs(d.X) + math.abs(d.Y) > 12 then fabMoved = true end
        fab.Position = UDim2.new(fabDrag.orig.X.Scale, fabDrag.orig.X.Offset + d.X, fabDrag.orig.Y.Scale, fabDrag.orig.Y.Offset + d.Y)
    end)
    UIS.InputEnded:Connect(function(i)
        if i ~= fabInput then return end
        fabDrag = nil
        fabInput = nil
        CONFIG.fabX = fab.Position.X.Scale
        CONFIG.fabY = fab.Position.Y.Scale
        saveConfig()
    end)
    fab.MouseButton1Click:Connect(function()
        if fabMoved then fabMoved = false return end
        if openSheet then pcall(openSheet) end
    end)
end

local scrim = mk("TextButton", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.scrim, BackgroundTransparency = 1,
    Text = "", AutoButtonColor = false, Visible = false,
    ZIndex = 150, Parent = gui,
})

local SHEET_H = 0.85
local SHEET_CLOSED_Y = 1.0 + SHEET_H + 0.05
local SHEET_OPEN_Y = 1.0

local sheet = mk("Frame", {
    Name = "Sheet", Size = UDim2.new(1, -16, SHEET_H, 0),
    Position = UDim2.new(0, 8, SHEET_CLOSED_Y, 0),
    AnchorPoint = Vector2.new(0, 1),
    BackgroundColor3 = C.sheet, BorderSizePixel = 0,
    Visible = false, ZIndex = 200, Parent = gui,
})
corner(sheet, 22)
stroke(sheet, C.bd, 1, 0.15)

local handle = mk("Frame", {
    Size = UDim2.new(1, 0, 0, 24),
    BackgroundTransparency = 1, Active = true,
    ZIndex = 201, Parent = sheet,
})
corner(mk("Frame", {
    Size = UDim2.fromOffset(44, 4), Position = UDim2.new(0.5, -22, 0, 8),
    BackgroundColor3 = C.bdHi, BorderSizePixel = 0,
    ZIndex = 202, Parent = handle,
}), 2)

local header = mk("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    Position = UDim2.fromOffset(0, 20),
    BackgroundTransparency = 1, ZIndex = 201, Parent = sheet,
})
mk("TextLabel", {
    Size = UDim2.new(1, -80, 0, 22),
    Position = UDim2.fromOffset(20, 12),
    BackgroundTransparency = 1, Text = "Null Hub",
    TextColor3 = C.txt, TextSize = isMobile and 20 or 18,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 202, Parent = header,
})
mk("TextLabel", {
    Size = UDim2.new(1, -80, 0, 14),
    Position = UDim2.fromOffset(20, 32),
    BackgroundTransparency = 1,
    Text = currentGame and currentGame.name or "Unsupported game",
    TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 202, Parent = header,
})
local closeBtn = mk("TextButton", {
    Size = UDim2.fromOffset(36, 36), Position = UDim2.new(1, -46, 0, 6),
    BackgroundColor3 = C.card, Text = "X",
    TextColor3 = C.dim, TextSize = 16, Font = Enum.Font.GothamBold,
    AutoButtonColor = false, ZIndex = 202, Parent = header,
})
corner(closeBtn, 10)

local navH = 62
local nav = mk("Frame", {
    Name = "Nav",
    Size = UDim2.new(1, 0, 0, navH),
    Position = UDim2.new(0, 0, 1, -navH),
    BackgroundColor3 = C.bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 260,
    Parent = sheet,
})
corner(nav, 22)
mk("Frame", {
    Size = UDim2.new(1, -20, 0, 1),
    Position = UDim2.fromOffset(10, 0),
    BackgroundColor3 = C.bd, BorderSizePixel = 0,
    ZIndex = 261, Parent = nav,
})

local content = mk("Frame", {
    Size = UDim2.new(1, 0, 1, -20 - 48 - navH),
    Position = UDim2.fromOffset(0, 20 + 48),
    BackgroundTransparency = 1, ClipsDescendants = true,
    ZIndex = 201, Parent = sheet,
})

comingSoonOverlay = mk("TextButton", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.bg, BackgroundTransparency = 0.4,
    Text = "", AutoButtonColor = false, Modal = false,
    Visible = false, ZIndex = 250, Parent = content,
})
do
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 70),
        Position = UDim2.new(0, 0, 0.5, -35),
        BackgroundTransparency = 1,
        Text = "Coming Soon",
        TextColor3 = C.txt, TextSize = 30, Font = Enum.Font.GothamBlack,
        TextStrokeTransparency = 0, TextStrokeColor3 = C.bg,
        ZIndex = 251, Parent = comingSoonOverlay,
    })
end

openSheet = function()
    if sheetOpen then return end
    sheetOpen = true
    sheet.Visible = true
    sheet.Position = UDim2.new(0, 8, SHEET_CLOSED_Y, 0)
    scrim.Visible = true
    scrim.BackgroundTransparency = 1
    TweenService:Create(scrim, TweenInfo.new(0.25), {BackgroundTransparency = 0.55}):Play()
    TweenService:Create(sheet, TweenInfo.new(0.42, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {Position = UDim2.new(0, 8, SHEET_OPEN_Y, 0)}):Play()
    if switchPage then pcall(switchPage, currentPage or "home") end
    if _G.__nhLayoutNav then
        task.defer(_G.__nhLayoutNav)
        task.delay(0.5, _G.__nhLayoutNav)
    end
end
closeSheet = function()
    if not sheetOpen then return end
    sheetOpen = false
    TweenService:Create(scrim, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    local t = TweenService:Create(sheet, TweenInfo.new(0.38, Enum.EasingStyle.Cubic, Enum.EasingDirection.In), {Position = UDim2.new(0, 8, SHEET_CLOSED_Y, 0)})
    t:Play()
    t.Completed:Connect(function() if not sheetOpen then scrim.Visible = false end end)
end
_G.__nhOpenSheet = openSheet
_G.__nhCloseSheet = closeSheet
closeBtn.MouseButton1Click:Connect(closeSheet)
scrim.MouseButton1Click:Connect(closeSheet)

do
    local dragStart, dragInput = nil, nil
    handle.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if dragInput then return end
        dragInput = i
        dragStart = {y = i.Position.Y, pos = sheet.Position}
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragStart or i ~= dragInput then return end
        local dy = i.Position.Y - dragStart.y
        if dy < 0 then dy = 0 end
        sheet.Position = UDim2.new(dragStart.pos.X.Scale, dragStart.pos.X.Offset, dragStart.pos.Y.Scale, dragStart.pos.Y.Offset + dy / workspace.CurrentCamera.ViewportSize.Y)
    end)
    UIS.InputEnded:Connect(function(i)
        if i ~= dragInput then return end
        local dy = i.Position.Y - dragStart.y
        dragStart = nil
        dragInput = nil
        if dy > 80 then closeSheet()
        else TweenService:Create(sheet, TweenInfo.new(0.25, Enum.EasingStyle.Cubic), {Position = UDim2.new(0, 8, SHEET_OPEN_Y, 0)}):Play() end
    end)
end

local pages = {}
local navButtons = {}

local function makePage(name)
    local p = mk("ScrollingFrame", {
        Name = name, Size = UDim2.fromScale(1, 1),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = C.bdHi,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, ZIndex = 202, Parent = content,
    })
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 9)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = p
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 12)
    pad.PaddingBottom = UDim.new(0, 16)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = p
    pages[name] = p
    return p
end

switchPage = function(name)
    if name ~= currentPage then previousPage = currentPage end
    for _, p in pairs(pages) do p.Visible = false end
    if pages[name] then pages[name].Visible = true end
    for n, b in pairs(navButtons) do
        local isActive = (n == name)
        if n == "friends" then
            b.icon.TextColor3 = isActive and C.dim or C.faint
            b.label.TextColor3 = isActive and C.dim or C.faint
        else
            b.icon.TextColor3 = isActive and C.txt or C.dim
            b.label.TextColor3 = isActive and C.txt or C.dim
        end
        b.underline.Visible = isActive
    end
    if comingSoonOverlay then
        comingSoonOverlay.Visible = (name == "friends")
    end
    currentPage = name
    if name == "keyless" and not CONFIG.warn_keyless then
        if _G.__nhWarnShow then pcall(_G.__nhWarnShow, "keyless") end
    elseif name == "keyed" and not CONFIG.warn_keyed then
        if _G.__nhWarnShow then pcall(_G.__nhWarnShow, "keyed") end
    elseif name == "hubs" and not CONFIG.warn_hubs then
        if _G.__nhWarnShow then pcall(_G.__nhWarnShow, "hubs") end
    end
    if name == "friends" and _G.__nhLoadFriends then
        task.spawn(_G.__nhLoadFriends)
    end
    if name == "hop" and _G.__nhLoadServers then pcall(_G.__nhLoadServers) end
end

local navButtonList = {}
local function makeNavButton(name, icon, label, order)
    local btn = mk("TextButton", {
        Name = name .. "Btn",
        Size = UDim2.fromOffset(48, navH - 8),
        Position = UDim2.fromOffset(0, 4),
        BackgroundColor3 = C.card,
        BackgroundTransparency = 0.4,
        Text = "",
        AutoButtonColor = false,
        ZIndex = 262,
        Parent = nav,
    })
    corner(btn, 8)
    local ic = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        Position = UDim2.fromOffset(0, 6),
        BackgroundTransparency = 1,
        Text = icon,
        TextColor3 = C.dim, TextSize = 18, Font = Enum.Font.GothamBold,
        ZIndex = 263, Parent = btn,
    })
    local lbl = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.fromOffset(0, 30),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = C.dim, TextSize = 9, Font = Enum.Font.GothamMedium,
        ZIndex = 263, Parent = btn,
    })
    local ul = mk("Frame", {
        Size = UDim2.new(0.5, 0, 0, 2), Position = UDim2.new(0.25, 0, 1, -4),
        BackgroundColor3 = C.txt, BorderSizePixel = 0,
        Visible = false, ZIndex = 264, Parent = btn,
    })
    corner(ul, 1)
    btn.MouseButton1Click:Connect(function() switchPage(name) end)
    navButtons[name] = {btn = btn, icon = ic, label = lbl, underline = ul}
    table.insert(navButtonList, {name = name, btn = btn, icon = ic, label = lbl})
end

makeNavButton("home", "🏠", "Home", 1)
makeNavButton("keyless", "🎮", "Keyless", 2)
makeNavButton("keyed", "🔑", "Keyed", 3)
makeNavButton("hubs", "🌐", "Hubs", 4)
makeNavButton("others", "🌍", "Others", 5)
makeNavButton("hop", "🔄", "Hop", 6)
makeNavButton("nametag", "🏷️", "Name", 7)
makeNavButton("friends", "👥", "Friends", 8)
makeNavButton("chat", "💬", "Chat", 9)
if isOwner then makeNavButton("announce", "📢", "Announce", 10) end
makeNavButton("settings", "⚙️", "Settings", isOwner and 11 or 10)

task.defer(function()
    local fbtn = navButtons["friends"]
    if fbtn then fbtn.btn.BackgroundTransparency = 0.8 end
end)

_G.__nhLayoutNav = function()
    local count = #navButtonList
    if count == 0 then return end
    local totalWidth = nav.AbsoluteSize.X
    if totalWidth < 50 then
        task.defer(_G.__nhLayoutNav)
        return
    end
    local pad = 2
    local perBtn = math.floor((totalWidth - pad * (count + 1)) / count)
    local showLabels = perBtn >= 56
    for i, item in ipairs(navButtonList) do
        local xPos = pad + (i - 1) * (perBtn + pad)
        item.btn.Position = UDim2.fromOffset(xPos, 4)
        item.btn.Size = UDim2.fromOffset(perBtn, navH - 8)
        if showLabels then
            item.label.Visible = true
            item.label.TextSize = math.clamp(math.floor(perBtn / 7), 7, 10)
            item.icon.Position = UDim2.fromOffset(0, 4)
            item.icon.Size = UDim2.new(1, 0, 0, 22)
            item.icon.TextSize = math.clamp(math.floor(perBtn / 2.8), 14, 20)
        else
            item.label.Visible = false
            item.icon.Position = UDim2.fromOffset(0, math.floor((navH - 8 - 22) / 2))
            item.icon.Size = UDim2.new(1, 0, 0, 22)
            item.icon.TextSize = math.clamp(math.floor(perBtn / 2.2), 14, 20)
        end
    end
end
task.defer(_G.__nhLayoutNav)
nav:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    task.defer(_G.__nhLayoutNav)
end)

local function makeCard(parent, order, height)
    local c = mk("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        LayoutOrder = order, ZIndex = 203, Parent = parent,
    })
    corner(c, 12)
    return c
end
local function makeHeader(parent, text, order)
    local h = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1, LayoutOrder = order,
        ZIndex = 203, Parent = parent,
    })
    corner(mk("Frame", {
        Size = UDim2.fromOffset(3, 14), Position = UDim2.new(0, 0, 0.5, -7),
        BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 204, Parent = h,
    }), 2)
    mk("TextLabel", {
        Size = UDim2.new(1, -12, 1, 0), Position = UDim2.fromOffset(12, 0),
        BackgroundTransparency = 1, Text = text,
        TextColor3 = C.dim, TextSize = 12, Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = h,
    })
end
local function makeToggle(parent, order, label, initial, callback)
    local card = makeCard(parent, order, 56)
    mk("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0), Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = C.txt, TextSize = 15, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = card,
    })
    local sw = mk("TextButton", {
        Size = UDim2.fromOffset(48, 28), Position = UDim2.new(1, -64, 0.5, -14),
        BackgroundColor3 = initial and C.accent or C.cardHi,
        Text = "", AutoButtonColor = false, ZIndex = 204, Parent = card,
    })
    corner(sw, 14)
    local knob = mk("Frame", {
        Size = UDim2.fromOffset(22, 22),
        Position = initial and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11),
        BackgroundColor3 = initial and C.bg or C.dim,
        BorderSizePixel = 0, ZIndex = 205, Parent = sw,
    })
    corner(knob, UDim.new(1, 0))
    local state = initial
    local api = {}
    function api.Set(v)
        state = v
        sw.BackgroundColor3 = v and C.accent or C.cardHi
        knob.Position = v and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        knob.BackgroundColor3 = v and C.bg or C.dim
    end
    sw.MouseButton1Click:Connect(function() api.Set(not state) callback(state) end)
    return api
end
local function makeButton(parent, order, label, bgColor, callback)
    bgColor = bgColor or C.card
    local textCol = contrastText(bgColor)
    local btn = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = bgColor,
        Text = label,
        TextColor3 = textCol,
        TextSize = 15, Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = order, ZIndex = 203, Parent = parent,
    })
    corner(btn, 12)
    btn.MouseButton1Click:Connect(callback)
    return btn
end
local function makeTextBox(parent, order, label, default, callback)
    local card = makeCard(parent, order, 56)
    mk("TextLabel", {
        Size = UDim2.new(0.36, 0, 1, 0), Position = UDim2.fromOffset(16, 0),
        BackgroundTransparency = 1, Text = label,
        TextColor3 = C.txt, TextSize = 14, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = card,
    })
    local box = mk("TextBox", {
        Size = UDim2.new(0.6, 0, 0, 36), Position = UDim2.new(0.38, 0, 0.5, -18),
        BackgroundColor3 = C.cardHi, Text = tostring(default),
        TextColor3 = C.txt, TextSize = 13, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false, ZIndex = 204, Parent = card,
    })
    corner(box, 10)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, 10) p.PaddingRight = UDim.new(0, 10)
    p.Parent = box
    box.FocusLost:Connect(function() callback(box.Text) end)
    return box
end
local function makeSlider(parent, order, label, default, mn, mx, callback, integer)
    local card = makeCard(parent, order, 60)
    local lbl = mk("TextLabel", {
        Size = UDim2.new(0.7, 0, 0, 16), Position = UDim2.fromOffset(16, 8),
        BackgroundTransparency = 1,
        Text = label .. ": " .. tostring(default),
        TextColor3 = C.txt, TextSize = 13, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = card,
    })
    local track = mk("Frame", {
        Size = UDim2.new(1, -32, 0, 6), Position = UDim2.new(0, 16, 0, 38),
        BackgroundColor3 = C.cardHi, BorderSizePixel = 0,
        Active = true, ZIndex = 204, Parent = card,
    })
    corner(track, 3)
    local fill = mk("Frame", {
        Size = UDim2.new((default - mn) / (mx - mn), 0, 1, 0),
        BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 205, Parent = track,
    })
    corner(fill, 3)
    local knob = mk("Frame", {
        Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new((default - mn) / (mx - mn), 0, 0.5, 0),
        BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 206, Parent = track,
    })
    corner(knob, UDim.new(1, 0))
    local cur = default
    local dragging = false
    local api = {}
    function api.Set(v, silent)
        cur = math.clamp(tonumber(v) or cur, mn, mx)
        if integer then cur = math.floor(cur + 0.5) end
        local a = (cur - mn) / (mx - mn)
        fill.Size = UDim2.new(a, 0, 1, 0)
        knob.Position = UDim2.new(a, 0, 0.5, 0)
        lbl.Text = label .. ": " .. (integer and tostring(cur) or string.format("%.2f", cur))
        if not silent then callback(cur) end
    end
    api.Set(default, true)
    track.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        dragging = true
        api.Set(mn + math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (mx - mn))
    end)
    UIS.InputChanged:Connect(function(i)
        if not dragging then return end
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        api.Set(mn + math.clamp((i.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1) * (mx - mn))
    end)
    UIS.InputEnded:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) then dragging = false end
    end)
    return api
end

local function makeHSV(parent, order)
    local card = makeCard(parent, order, 200)
    local preview = mk("Frame", {
        Size = UDim2.new(1, -32, 0, 40), Position = UDim2.fromOffset(16, 12),
        BackgroundColor3 = Color3.fromHSV(CONFIG.nt_h, CONFIG.nt_s, CONFIG.nt_v),
        BorderSizePixel = 0, ZIndex = 204, Parent = card,
    })
    corner(preview, 8)
    stroke(preview, C.bdHi, 1, 0)
    local function mkTrack(y, gradColors)
        local tr = mk("Frame", {
            Size = UDim2.new(1, -32, 0, 14), Position = UDim2.fromOffset(16, y),
            BackgroundColor3 = C.cardHi, BorderSizePixel = 0,
            Active = true, ZIndex = 204, Parent = card,
        })
        corner(tr, 4)
        local grad = Instance.new("UIGradient")
        grad.Color = gradColors
        grad.Parent = tr
        local k = mk("Frame", {
            Size = UDim2.fromOffset(6, 20), AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0, 0, 0.5, 0),
            BackgroundColor3 = C.txt, BorderSizePixel = 0, ZIndex = 206, Parent = tr,
        })
        corner(k, 3)
        stroke(k, C.bg, 1, 0)
        return tr, k
    end
    local hueGrad = ColorSequence.new({
        ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
        ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 0)),
    })
    local hTrack, hKnob = mkTrack(64, hueGrad)
    local sTrack, sKnob = mkTrack(96, ColorSequence.new(Color3.fromHSV(CONFIG.nt_h, 0, 1), Color3.fromHSV(CONFIG.nt_h, 1, 1)))
    local vTrack, vKnob = mkTrack(128, ColorSequence.new(Color3.new(0, 0, 0), Color3.fromHSV(CONFIG.nt_h, CONFIG.nt_s, 1)))
    mk("TextLabel", {Size = UDim2.fromOffset(40, 14), Position = UDim2.fromOffset(16, 60), BackgroundTransparency = 1, Text = "Hue", TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 205, Parent = card})
    mk("TextLabel", {Size = UDim2.fromOffset(40, 14), Position = UDim2.fromOffset(16, 92), BackgroundTransparency = 1, Text = "Sat", TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 205, Parent = card})
    mk("TextLabel", {Size = UDim2.fromOffset(40, 14), Position = UDim2.fromOffset(16, 124), BackgroundTransparency = 1, Text = "Val", TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 205, Parent = card})
    local function refresh()
        local col = Color3.fromHSV(CONFIG.nt_h, CONFIG.nt_s, CONFIG.nt_v)
        preview.BackgroundColor3 = col
        sTrack:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new(Color3.fromHSV(CONFIG.nt_h, 0, CONFIG.nt_v), Color3.fromHSV(CONFIG.nt_h, 1, CONFIG.nt_v))
        vTrack:FindFirstChildOfClass("UIGradient").Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.fromHSV(CONFIG.nt_h, CONFIG.nt_s, 1))
        hKnob.Position = UDim2.new(CONFIG.nt_h, 0, 0.5, 0)
        sKnob.Position = UDim2.new(CONFIG.nt_s, 0, 0.5, 0)
        vKnob.Position = UDim2.new(CONFIG.nt_v, 0, 0.5, 0)
        saveConfig()
    end
    local function bind(tr, key)
        local dragging = false
        local function update(i)
            CONFIG[key] = math.clamp((i.Position.X - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
            refresh()
        end
        tr.InputBegan:Connect(function(i)
            if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            dragging = true update(i)
        end)
        UIS.InputChanged:Connect(function(i)
            if not dragging then return end
            if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            update(i)
        end)
        UIS.InputEnded:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) then dragging = false end
        end)
    end
    bind(hTrack, "nt_h") bind(sTrack, "nt_s") bind(vTrack, "nt_v")
    refresh()
end

local notifyGui = mk("ScreenGui", {
    Name = "NullHub_Notify", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true,
    DisplayOrder = 99998, Parent = PARENT,
})
local NW = 300
local notifyCont = mk("Frame", {
    Size = UDim2.new(0, NW, 0, 500), Position = UDim2.new(1, -NW - 10, 0, 60),
    BackgroundTransparency = 1, Parent = notifyGui,
})
local notifyStack = {}
local NC = {info = Color3.fromRGB(220, 220, 220), success = Color3.fromRGB(180, 240, 200), error = Color3.fromRGB(240, 180, 180), warn = Color3.fromRGB(240, 220, 160)}
local function notify(title, msg, dur, kind)
    kind = kind or "info"
    local accent = NC[kind] or NC.info
    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 60), Position = UDim2.new(1, 30, 0, 0),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        ClipsDescendants = true, Parent = notifyCont,
    })
    corner(card, 12) stroke(card, C.bdHi, 1, 0.3)
    mk("Frame", {Size = UDim2.new(0, 3, 1, -14), Position = UDim2.new(0, 8, 0, 7), BackgroundColor3 = accent, BorderSizePixel = 0, Parent = card})
    mk("TextLabel", {Size = UDim2.fromOffset(24, 24), Position = UDim2.fromOffset(18, 11), BackgroundTransparency = 1, Text = kind == "success" and "✓" or kind == "error" and "✕" or kind == "warn" and "!" or "i", TextColor3 = accent, TextSize = 16, Font = Enum.Font.GothamBold, Parent = card})
    mk("TextLabel", {Size = UDim2.new(1, -60, 0, 18), Position = UDim2.fromOffset(48, 10), BackgroundTransparency = 1, Text = title, TextColor3 = C.txt, TextSize = 13, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, Parent = card})
    mk("TextLabel", {Size = UDim2.new(1, -60, 0, 30), Position = UDim2.fromOffset(48, 28), BackgroundTransparency = 1, Text = msg, TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, Parent = card})
    local closeX = mk("TextButton", {Size = UDim2.fromOffset(20, 20), Position = UDim2.new(1, -26, 0, 8), BackgroundTransparency = 1, Text = "×", TextColor3 = C.faint, TextSize = 16, Font = Enum.Font.GothamBold, AutoButtonColor = false, Parent = card})
    table.insert(notifyStack, {card = card, h = 60})
    local y = 0
    for _, it in ipairs(notifyStack) do
        TweenService:Create(it.card, TweenInfo.new(0.24, Enum.EasingStyle.Cubic), {Position = UDim2.new(0, 0, 0, y)}):Play()
        y = y + it.h + 6
    end
    local dismissed = false
    local function dismiss()
        if dismissed then return end
        dismissed = true
        local t = TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Cubic), {Position = UDim2.new(1, 30, 0, card.Position.Y.Offset)})
        t:Play()
        t.Completed:Connect(function()
            for i, it in ipairs(notifyStack) do
                if it.card == card then table.remove(notifyStack, i) break end
            end
            card:Destroy()
            local y2 = 0
            for _, it in ipairs(notifyStack) do
                TweenService:Create(it.card, TweenInfo.new(0.24, Enum.EasingStyle.Cubic), {Position = UDim2.new(0, 0, 0, y2)}):Play()
                y2 = y2 + it.h + 6
            end
        end)
    end
    closeX.MouseButton1Click:Connect(dismiss)
    task.delay(dur or 4, dismiss)
end

local function fetchScript(url)
    if not url or url == "" then return nil end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and #body > 10 then return body end
    if request then
        local ok2, r = pcall(request, {Url = url, Method = "GET"})
        if ok2 and r and r.Body then return r.Body end
    end
end
local function makeScriptCard(parent, order, data, showDesc)
    local card = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 62),
        BackgroundColor3 = C.card, BorderSizePixel = 0,
        ClipsDescendants = true, LayoutOrder = order,
        ZIndex = 203, Parent = parent,
    })
    corner(card, 12)
    if data.broken then stroke(card, C.red, 1.2, 0.4) end
    card:SetAttribute("is_script_card", true)
    card:SetAttribute("filter_kind", data.broken and "broken" or (data.updated and "updated" or "normal"))
    local icon = mk("Frame", {
        Size = UDim2.fromOffset(38, 38), Position = UDim2.fromOffset(12, 12),
        BackgroundColor3 = C.cardHi, BorderSizePixel = 0, ZIndex = 204, Parent = card,
    })
    corner(icon, 10)
    mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = data.broken and "⚠️" or "📜", TextSize = 18, ZIndex = 205, Parent = icon})
    local nameCol = data.broken and C.redTxt or C.txt
    mk("TextLabel", {Size = UDim2.new(1, -70, 0, 20), Position = UDim2.fromOffset(62, 12), BackgroundTransparency = 1, Text = data.name, TextColor3 = nameCol, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 204, Parent = card})
    local subTxt
    if data.broken then subTxt = "Not Working / Not Found"
    elseif showDesc then subTxt = data.desc
    else subTxt = data.url and (data.url:match("^https?://([^/]+)") or "?") or "?" end
    local subCol = data.broken and C.redTxt or C.faint
    local urlWidth = (data.updated and not data.broken) and UDim2.new(1, -190, 0, 16) or UDim2.new(1, -70, 0, 16)
    mk("TextLabel", {Size = urlWidth, Position = UDim2.fromOffset(62, 32), BackgroundTransparency = 1, Text = subTxt, TextColor3 = subCol, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 204, Parent = card})
    if data.updated and not data.broken then
        local badge = mk("Frame", {Size = UDim2.fromOffset(62, 16), Position = UDim2.new(1, -120, 0, 32), BackgroundColor3 = Color3.fromRGB(30, 70, 40), BorderSizePixel = 0, ZIndex = 208, Parent = card})
        corner(badge, 4) stroke(badge, Color3.fromRGB(90, 200, 120), 1, 0.3)
        mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "UPDATED", TextColor3 = Color3.fromRGB(160, 240, 180), TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 209, Parent = badge})
    end
    if data.broken then
        local badge = mk("Frame", {Size = UDim2.fromOffset(84, 16), Position = UDim2.new(1, -142, 0, 32), BackgroundColor3 = C.redBg, BorderSizePixel = 0, ZIndex = 208, Parent = card})
        corner(badge, 4) stroke(badge, C.red, 1, 0.3)
        mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "NOT WORKING", TextColor3 = C.redTxt, TextSize = 9, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 209, Parent = badge})
    end
    local star = mk("TextButton", {
        Size = UDim2.fromOffset(36, 36), Position = UDim2.new(1, -46, 0, 13),
        BackgroundTransparency = 1, Text = favorites[data.name] and "★" or "☆",
        TextColor3 = favorites[data.name] and C.accent or C.faint,
        TextSize = 20, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 207, Parent = card,
    })
    star.MouseButton1Click:Connect(function()
        if favorites[data.name] then favorites[data.name] = nil star.Text = "☆" star.TextColor3 = C.faint
        else favorites[data.name] = true star.Text = "★" star.TextColor3 = C.accent end
        saveFavs()
    end)
    local actions = mk("Frame", {Size = UDim2.new(1, 0, 0, 50), Position = UDim2.fromOffset(0, 62), BackgroundTransparency = 1, ZIndex = 204, Parent = card})
    local btnColor = data.broken and C.cardHi or C.accent
    local btnTxtColor = data.broken and C.redTxt or C.bg
    local btnText = data.broken and "Unavailable" or "Execute"
    local execBtn = mk("TextButton", {
        Size = UDim2.new(0.6, -18, 0, 38), Position = UDim2.fromOffset(12, 6),
        BackgroundColor3 = btnColor, Text = btnText, TextColor3 = btnTxtColor,
        TextSize = 13, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 205, Parent = actions,
    })
    corner(execBtn, 10)
    if data.broken then
        execBtn.MouseButton1Click:Connect(function()
            notify("Not Working", data.name .. " — reported as not working / not found", 4, "error")
        end)
    else
        execBtn.MouseButton1Click:Connect(function()
            execBtn.Text = "..."
            task.spawn(function()
                local src = data.url and fetchScript(data.url)
                if not src then notify("Error", "Failed: " .. data.name, 4, "error") execBtn.Text = "Execute" return end
                if type(LOADER) ~= "function" then notify("Error", "No loadstring", 4, "error") execBtn.Text = "Execute" return end
                local chunk, err = LOADER(src)
                if not chunk then notify("Compile Error", tostring(err):sub(1, 80), 5, "error") execBtn.Text = "Execute" return end
                local ok, runErr = pcall(chunk)
                if ok then notify("Executed", data.name, 3, "success")
                else notify("Runtime Error", tostring(runErr):sub(1, 80), 5, "error") end
                execBtn.Text = "Execute"
            end)
        end)
    end
    local copyBtn = mk("TextButton", {
        Size = UDim2.new(0.4, -18, 0, 38), Position = UDim2.new(0.6, 6, 0, 6),
        BackgroundColor3 = C.cardHi, Text = "Copy", TextColor3 = C.txt,
        TextSize = 13, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 205, Parent = actions,
    })
    corner(copyBtn, 10)
    copyBtn.MouseButton1Click:Connect(function()
        if data.broken then notify("Not Working", "Nothing to copy — script unavailable", 3, "error") return end
        if setclipboard and data.url and data.url ~= "" then
            setclipboard(('loadstring(game:HttpGet("%s"))()'):format(data.url))
            copyBtn.Text = "Copied!"
            task.delay(1.2, function() copyBtn.Text = "Copy" end)
        end
    end)
    local tapZone = mk("TextButton", {Size = UDim2.new(1, -80, 0, 62), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 206, Parent = card})
    local expanded = false
    tapZone.MouseButton1Click:Connect(function()
        expanded = not expanded
        TweenService:Create(card, TweenInfo.new(0.22, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, expanded and 116 or 62)}):Play()
    end)
    return card
end
local function renderScriptList(page, list, startOrder, filterRow)
    local order = startOrder
    for _, s in ipairs(list) do
        local ok, card = pcall(makeScriptCard, page, order, s, false)
        if ok and card then order = order + 1 end
    end
    if filterRow and filterRow.apply then
        task.defer(function() task.wait(0.05) filterRow.apply() end)
    end
    return order
end

local function makeFilterRow(parent, order)
    local row = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 32),
        BackgroundTransparency = 1,
        LayoutOrder = order,
        ZIndex = 205, Parent = parent,
    })
    local opts = {"all", "normal", "updated", "broken"}
    local labels = {all = "All", normal = "Normal", updated = "Updated", broken = "Not Working"}
    local btns = {}
    local current = "all"
    local gap = 5
    local function apply()
        for _, child in ipairs(parent:GetChildren()) do
            if child:IsA("Frame") and child:GetAttribute("is_script_card") then
                local kind = child:GetAttribute("filter_kind") or "normal"
                child.Visible = (current == "all") or (kind == current)
            end
        end
        for k, b in pairs(btns) do
            local sel = (k == current)
            b.BackgroundColor3 = sel and C.accent or C.cardHi
            b.TextColor3 = sel and C.bg or C.txt
        end
    end
    local function layout()
        local w = row.AbsoluteSize.X
        if w < 50 then task.defer(layout) return end
        local btnW = math.floor((w - gap * (#opts - 1)) / #opts)
        for i, opt in ipairs(opts) do
            local b = btns[opt]
            if b then
                b.Position = UDim2.fromOffset((i - 1) * (btnW + gap), 0)
                b.Size = UDim2.fromOffset(btnW, 32)
                b.TextSize = btnW < 70 and 9 or 11
            end
        end
    end
    for i, opt in ipairs(opts) do
        local b = mk("TextButton", {
            Size = UDim2.fromOffset(60, 32),
            BackgroundColor3 = (opt == "all") and C.accent or C.cardHi,
            Text = labels[opt],
            TextColor3 = (opt == "all") and C.bg or C.txt,
            TextSize = 11, Font = Enum.Font.GothamBold,
            AutoButtonColor = false,
            ZIndex = 206, Parent = row,
        })
        corner(b, 8)
        b.MouseButton1Click:Connect(function()
            current = opt
            apply()
        end)
        btns[opt] = b
    end
    task.defer(layout)
    row:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
        task.defer(layout)
    end)
    return {apply = apply}
end

local warningOverlay = mk("Frame", {
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.scrim,
    BackgroundTransparency = 0.55, BorderSizePixel = 0,
    Visible = false, ZIndex = 500, Parent = gui,
})
local warnCard = mk("Frame", {
    Size = UDim2.new(0, 340, 0, 250), Position = UDim2.new(0.5, -170, 0.5, -125),
    BackgroundColor3 = C.sheet, BorderSizePixel = 0, ZIndex = 501, Parent = warningOverlay,
})
corner(warnCard, 16) stroke(warnCard, C.bdHi, 1, 0.2)
mk("TextLabel", {Size = UDim2.new(1, -32, 0, 24), Position = UDim2.fromOffset(16, 16), BackgroundTransparency = 1, Text = "⚠️ Warning", TextColor3 = C.txt, TextSize = 16, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 502, Parent = warnCard})
local warnBodyLbl = mk("TextLabel", {
    Size = UDim2.new(1, -32, 0, 72), Position = UDim2.fromOffset(16, 46),
    BackgroundTransparency = 1,
    Text = "Some Scripts aren't Verified To be Working/Outdated And Keyless. Continue?",
    TextColor3 = C.dim, TextSize = 12, Font = Enum.Font.Gotham,
    TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    TextWrapped = true, ZIndex = 502, Parent = warnCard,
})
local dontShowRow = mk("TextButton", {Size = UDim2.new(1, -32, 0, 24), Position = UDim2.fromOffset(16, 128), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 502, Parent = warnCard})
local dnsBox = mk("Frame", {Size = UDim2.fromOffset(20, 20), Position = UDim2.fromOffset(0, 2), BackgroundColor3 = C.cardHi, BorderSizePixel = 0, ZIndex = 503, Parent = dontShowRow})
corner(dnsBox, 5) stroke(dnsBox, C.bdHi, 1, 0)
local dnsTick = mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "", TextColor3 = C.txt, TextSize = 14, Font = Enum.Font.GothamBold, ZIndex = 504, Parent = dnsBox})
mk("TextLabel", {Size = UDim2.new(1, -30, 1, 0), Position = UDim2.fromOffset(28, 0), BackgroundTransparency = 1, Text = "Don't show this again", TextColor3 = C.txt, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 503, Parent = dontShowRow})
local dnsChecked = false
dontShowRow.MouseButton1Click:Connect(function()
    dnsChecked = not dnsChecked
    dnsTick.Text = dnsChecked and "✓" or ""
end)
local yesBtn = mk("TextButton", {Size = UDim2.new(0.5, -22, 0, 44), Position = UDim2.new(0, 16, 1, -60), BackgroundColor3 = C.accent, Text = "Yes", TextColor3 = C.bg, TextSize = 14, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 502, Parent = warnCard})
corner(yesBtn, 10)
local noBtn = mk("TextButton", {Size = UDim2.new(0.5, -22, 0, 44), Position = UDim2.new(0.5, 6, 1, -60), BackgroundColor3 = C.card, Text = "No", TextColor3 = C.txt, TextSize = 14, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 502, Parent = warnCard})
corner(noBtn, 10)
local warnReturnTo = nil
local warnCurrentTab = nil
_G.__nhWarnShow = function(tabName)
    warnReturnTo = previousPage or "home"
    warnCurrentTab = tabName or "keyless"
    if tabName == "keyed" then
        warnBodyLbl.Text = "Some Scripts aren't Verified To be Working/Outdated And Key Required. Continue?"
    else
        warnBodyLbl.Text = "Some Scripts aren't Verified To be Working/Outdated And Keyless. Continue?"
    end
    warningOverlay.Visible = true
end
local function warnSave()
    if not dnsChecked then return end
    if warnCurrentTab == "keyed" then CONFIG.warn_keyed = true
    elseif warnCurrentTab == "hubs" then CONFIG.warn_hubs = true
    else CONFIG.warn_keyless = true end
    saveConfig()
end
yesBtn.MouseButton1Click:Connect(function()
    warnSave()
    warningOverlay.Visible = false
end)
noBtn.MouseButton1Click:Connect(function()
    warnSave()
    warningOverlay.Visible = false
    if warnReturnTo then switchPage(warnReturnTo) end
end)

-- HOME
pcall(function()
    local homePage = makePage("home")
    local banner = mk("ImageLabel", {
        Size = UDim2.new(1, 0, 0, 120), BackgroundColor3 = C.card,
        Image = "rbxassetid://" .. CONFIG.banner_id,
        ScaleType = Enum.ScaleType.Crop, LayoutOrder = 0, ZIndex = 203, Parent = homePage,
    })
    corner(banner, 12) stroke(banner, C.bd, 1, 0.4)
    corner(mk("Frame", {Size = UDim2.new(1, 0, 1, 0), BackgroundColor3 = C.bg, BackgroundTransparency = 0.5, BorderSizePixel = 0, ZIndex = 204, Parent = banner}), 12)
    mk("TextLabel", {Size = UDim2.new(1, -32, 0, 32), Position = UDim2.new(0, 16, 0.5, -16), BackgroundTransparency = 1, Text = "Null Hub", TextColor3 = C.txt, TextSize = 24, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 205, Parent = banner})
    makeHeader(homePage, "WELCOME", 1)
    local wc = makeCard(homePage, 2, 86)
    mk("TextLabel", {Size = UDim2.new(1, -20, 0, 24), Position = UDim2.fromOffset(16, 12), BackgroundTransparency = 1, Text = "Hey, " .. (LP.DisplayName or LP.Name), TextColor3 = C.txt, TextSize = 17, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = wc})
    mk("TextLabel", {Size = UDim2.new(1, -20, 0, 36), Position = UDim2.fromOffset(16, 40), BackgroundTransparency = 1, Text = currentGame and ("Playing: " .. currentGame.name) or "Unsupported", TextColor3 = currentGame and C.good or C.dim, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextWrapped = true, ZIndex = 204, Parent = wc})
    makeHeader(homePage, "QUICK ACTIONS", 3)
    makeButton(homePage, 4, "Open Server Hop", C.cardHi, function() switchPage("hop") end)
    makeButton(homePage, 5, "Copy Discord Invite", C.card, function()
        local inv = "https://discord.gg/CYq7fDt7Gj"
        if setclipboard then setclipboard(inv) notify("Discord", "Copied", 3, "success")
        else notify("Discord", inv, 6) end
    end)
end)

-- KEYLESS
pcall(function()
    local p = makePage("keyless")
    makeHeader(p, "KEYLESS HUBS", 1)
    local fr = makeFilterRow(p, 2)
    if currentGame and currentGame.keyless and #currentGame.keyless > 0 then
        renderScriptList(p, currentGame.keyless, 3, fr)
    else
        local ec = makeCard(p, 3, 60)
        mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = currentGame and "No keyless scripts for this game yet" or "Unsupported game", TextColor3 = C.dim, TextSize = 13, Font = Enum.Font.Gotham, ZIndex = 204, Parent = ec})
    end
end)

-- KEYED
pcall(function()
    local p = makePage("keyed")
    makeHeader(p, "KEY REQUIRED", 1)
    local fr = makeFilterRow(p, 2)
    if currentGame and currentGame.keyed and #currentGame.keyed > 0 then
        renderScriptList(p, currentGame.keyed, 3, fr)
    else
        local ec = makeCard(p, 3, 60)
        mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "No key-required scripts yet", TextColor3 = C.dim, TextSize = 13, Font = Enum.Font.Gotham, ZIndex = 204, Parent = ec})
    end
end)

-- HUBS (only Steal an Egg)
pcall(function()
    local p = makePage("hubs")
    makeHeader(p, "SCRIPT HUBS", 1)
    if currentGame and currentGame.name == "Steal an Egg" then
        local fr = makeFilterRow(p, 2)
        local order = 3
        for _, h in ipairs(HUBS_DB) do
            local ok, c = pcall(makeScriptCard, p, order, h, true)
            if ok and c then order = order + 1 end
        end
        task.defer(function() task.wait(0.05) fr.apply() end)
    else
        local ec = makeCard(p, 2, 90)
        mk("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0), Position = UDim2.fromOffset(10, 0),
            BackgroundTransparency = 1,
            Text = "Script Hubs are only available for Steal an Egg.",
            TextColor3 = C.dim, TextSize = 13, Font = Enum.Font.Gotham,
            TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Center,
            ZIndex = 204, Parent = ec,
        })
    end
end)

-- OTHERS
pcall(function()
    local p = makePage("others")
    makeHeader(p, "UNIVERSAL SCRIPTS", 1)
    local fr = makeFilterRow(p, 2)
    local order = 3
    for _, s in ipairs(OTHER_SCRIPTS) do
        local ok, c = pcall(makeScriptCard, p, order, s, false)
        if ok and c then order = order + 1 end
    end
    task.defer(function() task.wait(0.05) fr.apply() end)
end)

-- HOP
local srvListFrame
local function loadServers()
    if not srvListFrame then return end
    for _, c in ipairs(srvListFrame:GetChildren()) do
        if c:IsA("Frame") or c:IsA("TextLabel") then c:Destroy() end
    end
    local loading = mk("TextLabel", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "Loading...", TextColor3 = C.dim, TextSize = 12, Font = Enum.Font.Gotham, LayoutOrder = 1, ZIndex = 205, Parent = srvListFrame})
    task.spawn(function()
        local list = {}
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&sortOrder=Asc"
        local raw = httpGet(url)
        if raw then
            local ok, d = pcall(function() return HttpService:JSONDecode(raw) end)
            if ok and type(d) == "table" and type(d.data) == "table" then
                for _, s in ipairs(d.data) do
                    if s.playing and s.maxPlayers and s.id then
                        local slots = s.maxPlayers - s.playing
                        if s.playing < s.maxPlayers and slots >= 2 then
                            table.insert(list, {Id = s.id, Playing = s.playing, MaxPlayers = s.maxPlayers, Slots = slots})
                        end
                    end
                end
            end
        end
        if #list == 0 then
            local ok, pages = pcall(function() return TeleportService:GetSortedAsync(Enum.SortDirection.Ascending, 50, 1, 50) end)
            if ok and pages then
                local ok2, pg = pcall(function() return pages:GetCurrentPage() end)
                if ok2 and type(pg) == "table" then
                    for _, s in ipairs(pg) do
                        local slots = s.MaxPlayers - s.Playing
                        if s.Playing < s.MaxPlayers and slots >= 2 then
                            table.insert(list, {Id = s.Id, Playing = s.Playing, MaxPlayers = s.MaxPlayers, Slots = slots})
                        end
                    end
                end
            end
        end
        table.sort(list, function(a, b)
            if a.Playing == b.Playing then return a.Slots > b.Slots end
            return a.Playing < b.Playing
        end)
        if loading.Parent then loading:Destroy() end
        if #list == 0 then
            mk("TextLabel", {Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Text = "No servers found", TextColor3 = C.dim, TextSize = 12, Font = Enum.Font.Gotham, LayoutOrder = 1, ZIndex = 205, Parent = srvListFrame})
            return
        end
        for i, s in ipairs(list) do
            local row = mk("Frame", {Size = UDim2.new(1, 0, 0, 38), BackgroundColor3 = C.bg, BorderSizePixel = 0, LayoutOrder = i, ZIndex = 204, Parent = srvListFrame})
            corner(row, 8)
            mk("TextLabel", {Size = UDim2.new(0.55, 0, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = "ID: " .. string.sub(s.Id, 1, 12), TextColor3 = C.txt, TextSize = 11, Font = Enum.Font.Code, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 205, Parent = row})
            mk("TextLabel", {Size = UDim2.new(0.3, 0, 1, 0), Position = UDim2.new(0.55, 0, 0, 0), BackgroundTransparency = 1, Text = s.Playing .. "/" .. s.MaxPlayers, TextColor3 = s.Slots >= 3 and C.good or C.warn, TextSize = 11, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 205, Parent = row})
            local jb = mk("TextButton", {Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -60, 0.5, -14), BackgroundColor3 = C.cardHi, Text = "Join", TextColor3 = C.txt, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 205, Parent = row})
            corner(jb, 6)
            local sid = s.Id
            jb.MouseButton1Click:Connect(function()
                notify("Servers", "Joining " .. string.sub(sid, 1, 8), 3, "info")
                task.wait(0.4)
                pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, sid, LP) end)
            end)
        end
    end)
end
_G.__nhLoadServers = loadServers

pcall(function()
    local p = makePage("hop")
    makeHeader(p, "SERVER HOP", 1)
    makeButton(p, 2, "Auto-Join Lowest Server", C.cardHi, function()
        notify("Servers", "Finding lowest...", 3, "info")
        task.spawn(function()
            local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100&sortOrder=Asc"
            local raw = httpGet(url)
            local best = nil
            if raw then
                local ok, d = pcall(function() return HttpService:JSONDecode(raw) end)
                if ok and type(d) == "table" and type(d.data) == "table" then
                    for _, s in ipairs(d.data) do
                        if s.playing and s.maxPlayers and s.id then
                            local slots = s.maxPlayers - s.playing
                            if s.playing < s.maxPlayers and slots >= 2 then
                                if not best or s.playing < best.Playing then
                                    best = {Id = s.id, Playing = s.playing, MaxPlayers = s.maxPlayers}
                                end
                            end
                        end
                    end
                end
            end
            if not best then
                local ok, pages = pcall(function() return TeleportService:GetSortedAsync(Enum.SortDirection.Ascending, 50, 1, 50) end)
                if ok and pages then
                    local ok2, pg = pcall(function() return pages:GetCurrentPage() end)
                    if ok2 and type(pg) == "table" then
                        for _, s in ipairs(pg) do
                            if s.Playing < s.MaxPlayers and (s.MaxPlayers - s.Playing) >= 2 then
                                if not best or s.Playing < best.Playing then
                                    best = {Id = s.Id, Playing = s.Playing, MaxPlayers = s.MaxPlayers}
                                end
                            end
                        end
                    end
                end
            end
            if not best then notify("Servers", "No servers found", 3, "error") return end
            notify("Servers", "Joining lowest (" .. best.Playing .. "/" .. best.MaxPlayers .. ")", 3, "success")
            task.wait(0.5)
            pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, best.Id, LP) end)
        end)
    end)
    makeHeader(p, "LOWEST POPULATION SERVERS", 3)
    local srvCard = makeCard(p, 4, 380)
    local refreshBtn = mk("TextButton", {Size = UDim2.fromOffset(70, 26), Position = UDim2.new(1, -80, 0, 8), BackgroundColor3 = C.cardHi, Text = "Refresh", TextColor3 = C.txt, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 204, Parent = srvCard})
    corner(refreshBtn, 6)
    refreshBtn.MouseButton1Click:Connect(function()
        if _G.__nhLoadServers then task.spawn(_G.__nhLoadServers) end
    end)
    srvListFrame = mk("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -46), Position = UDim2.fromOffset(10, 40),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 2, ScrollBarImageColor3 = C.bdHi,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 204, Parent = srvCard,
    })
    local sl = Instance.new("UIListLayout")
    sl.Padding = UDim.new(0, 4) sl.SortOrder = Enum.SortOrder.LayoutOrder sl.Parent = srvListFrame
    task.spawn(function()
        task.wait(0.6)
        pcall(loadServers)
    end)
end)

-- NAMETAG
pcall(function()
    local nametagPage = makePage("nametag")
    makeHeader(nametagPage, "NAMETAG", 1)
    makeToggle(nametagPage, 2, "Enable Nametag", CONFIG.nametag, function(v) CONFIG.nametag = v saveConfig() end)
    local modeCard = makeCard(nametagPage, 3, 80)
    mk("TextLabel", {Size = UDim2.new(1, -20, 0, 16), Position = UDim2.fromOffset(16, 10), BackgroundTransparency = 1, Text = "Text Mode", TextColor3 = C.txt, TextSize = 13, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = modeCard})
    for i, m in ipairs({"custom", "username", "both"}) do
        local btn = mk("TextButton", {
            Size = UDim2.new(0.32, -8, 0, 34), Position = UDim2.new((i - 1) * 0.33, 8, 0, 36),
            BackgroundColor3 = CONFIG.nt_mode == m and C.accent or C.cardHi,
            Text = m:sub(1, 1):upper() .. m:sub(2),
            TextColor3 = CONFIG.nt_mode == m and C.bg or C.txt,
            TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 204, Parent = modeCard,
        })
        corner(btn, 8)
        btn.MouseButton1Click:Connect(function()
            CONFIG.nt_mode = m saveConfig()
            for _, c in ipairs(modeCard:GetChildren()) do
                if c:IsA("TextButton") then
                    local sel = c.Text:lower() == m
                    c.BackgroundColor3 = sel and C.accent or C.cardHi
                    c.TextColor3 = sel and C.bg or C.txt
                end
            end
        end)
    end
    makeTextBox(nametagPage, 4, "Custom Text", CONFIG.nt_text, function(v) CONFIG.nt_text = v saveConfig() end)
    makeSlider(nametagPage, 5, "Text Size", CONFIG.nt_size, 8, 60, function(v) CONFIG.nt_size = math.floor(v) saveConfig() end, true)
    makeSlider(nametagPage, 6, "Offset X", CONFIG.nt_ox, -20, 20, function(v) CONFIG.nt_ox = v saveConfig() end)
    makeSlider(nametagPage, 7, "Offset Y", CONFIG.nt_oy, -10, 20, function(v) CONFIG.nt_oy = v saveConfig() end)
    makeSlider(nametagPage, 8, "Rotation", CONFIG.nt_rot, -45, 45, function(v) CONFIG.nt_rot = v saveConfig() end, true)
    makeSlider(nametagPage, 9, "Max Distance", CONFIG.nt_max_dist, 50, 1000, function(v) CONFIG.nt_max_dist = math.floor(v) saveConfig() end, true)
    makeHeader(nametagPage, "FONT", 10)
    local fontCard = makeCard(nametagPage, 11, 56)
    local fontOpen = false
    local fontBtn = mk("TextButton", {Size = UDim2.new(1, 0, 0, 56), BackgroundColor3 = C.card, Text = "", AutoButtonColor = false, ZIndex = 205, Parent = fontCard})
    corner(fontBtn, 12)
    local fontLabel = mk("TextLabel", {Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(16, 0), BackgroundTransparency = 1, Text = CONFIG.nt_font, TextColor3 = C.txt, TextSize = 14, Font = Enum.Font[CONFIG.nt_font] or Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 206, Parent = fontBtn})
    local arrowLbl = mk("TextLabel", {Size = UDim2.fromOffset(30, 30), Position = UDim2.new(1, -40, 0.5, -15), BackgroundTransparency = 1, Text = "↓", TextColor3 = C.txt, TextSize = 20, Font = Enum.Font.GothamBold, ZIndex = 206, Parent = fontBtn})
    local fontList = mk("ScrollingFrame", {
        Size = UDim2.new(1, -20, 0, 0), Position = UDim2.fromOffset(10, 60),
        BackgroundColor3 = C.cardHi, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.bdHi,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false, ClipsDescendants = true, ZIndex = 210, Parent = fontCard,
    })
    corner(fontList, 8)
    local fl2 = Instance.new("UIListLayout")
    fl2.Padding = UDim.new(0, 2) fl2.SortOrder = Enum.SortOrder.LayoutOrder fl2.Parent = fontList
    local flPad = Instance.new("UIPadding")
    flPad.PaddingTop = UDim.new(0, 6) flPad.PaddingLeft = UDim.new(0, 6) flPad.PaddingRight = UDim.new(0, 6) flPad.PaddingBottom = UDim.new(0, 6) flPad.Parent = fontList
    local fontButtons = {}
    for i, fname in ipairs(FONT_LIST) do
        local b = mk("TextButton", {
            Size = UDim2.new(1, -4, 0, 32),
            BackgroundColor3 = CONFIG.nt_font == fname and C.accent or C.cardHi,
            Text = fname, TextColor3 = CONFIG.nt_font == fname and C.bg or C.txt,
            TextSize = 13, Font = Enum.Font[fname] or Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left, AutoButtonColor = false,
            LayoutOrder = i, ZIndex = 211, Parent = fontList,
        })
        corner(b, 6)
        local bp = Instance.new("UIPadding")
        bp.PaddingLeft = UDim.new(0, 12) bp.Parent = b
        table.insert(fontButtons, b)
        b.MouseButton1Click:Connect(function()
            CONFIG.nt_font = fname saveConfig()
            fontLabel.Text = fname
            fontLabel.Font = Enum.Font[fname] or Enum.Font.GothamBold
            for _, c in ipairs(fontButtons) do
                local sel = c.Text == fname
                c.BackgroundColor3 = sel and C.accent or C.cardHi
                c.TextColor3 = sel and C.bg or C.txt
            end
            fontOpen = false
            TweenService:Create(fontCard, TweenInfo.new(0.22, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, 56)}):Play()
            TweenService:Create(fontList, TweenInfo.new(0.22, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, -20, 0, 0)}):Play()
            TweenService:Create(arrowLbl, TweenInfo.new(0.25, Enum.EasingStyle.Cubic), {Rotation = 0}):Play()
            task.delay(0.22, function() if not fontOpen then fontList.Visible = false end end)
        end)
    end
    fontBtn.MouseButton1Click:Connect(function()
        fontOpen = not fontOpen
        if fontOpen then
            fontList.Visible = true
            TweenService:Create(fontCard, TweenInfo.new(0.28, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, 56 + 240)}):Play()
            TweenService:Create(fontList, TweenInfo.new(0.28, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, -20, 0, 234)}):Play()
            TweenService:Create(arrowLbl, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Rotation = 180}):Play()
        else
            TweenService:Create(fontCard, TweenInfo.new(0.28, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, 0, 0, 56)}):Play()
            TweenService:Create(fontList, TweenInfo.new(0.28, Enum.EasingStyle.Cubic), {Size = UDim2.new(1, -20, 0, 0)}):Play()
            TweenService:Create(arrowLbl, TweenInfo.new(0.3, Enum.EasingStyle.Cubic), {Rotation = 0}):Play()
            task.delay(0.28, function() if not fontOpen then fontList.Visible = false end end)
        end
    end)
    makeHeader(nametagPage, "TEXT COLOR", 12)
    makeHSV(nametagPage, 13)
    makeHeader(nametagPage, "EFFECTS", 14)
    makeToggle(nametagPage, 15, "Rainbow", CONFIG.nt_rainbow, function(v) CONFIG.nt_rainbow = v saveConfig() end)
    makeSlider(nametagPage, 16, "Rainbow Speed", CONFIG.nt_rainbow_speed, 0.05, 2.0, function(v) CONFIG.nt_rainbow_speed = v saveConfig() end)
    makeToggle(nametagPage, 17, "Shine Sweep", CONFIG.nt_shine, function(v) CONFIG.nt_shine = v saveConfig() end)
    makeSlider(nametagPage, 18, "Shine Speed", CONFIG.nt_shine_speed, 0.1, 3.0, function(v) CONFIG.nt_shine_speed = v saveConfig() end)
    makeHeader(nametagPage, "OUTLINE", 19)
    makeToggle(nametagPage, 20, "Show Outline", CONFIG.nt_outline, function(v) CONFIG.nt_outline = v saveConfig() end)
    makeSlider(nametagPage, 21, "Outline Thickness", CONFIG.nt_outline_th, 0, 5, function(v) CONFIG.nt_outline_th = v saveConfig() end)
    makeToggle(nametagPage, 22, "Glow", CONFIG.nt_glow, function(v) CONFIG.nt_glow = v saveConfig() end)
    makeHeader(nametagPage, "VISIBILITY", 23)
    makeToggle(nametagPage, 24, "Show On Yourself", CONFIG.nt_show_self, function(v) CONFIG.nt_show_self = v saveConfig() end)
    makeToggle(nametagPage, 25, "Show On Others", CONFIG.nt_show_others, function(v) CONFIG.nt_show_others = v saveConfig() end)
end)

-- FRIENDS
local friendsListFrame, friendsStatus
pcall(function()
    local p = makePage("friends")
    p.ScrollingEnabled = false
    makeHeader(p, "FRIENDS", 1)

    friendsStatus = mk("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16),
        BackgroundTransparency = 1,
        Text = "",
        TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 2, ZIndex = 204, Parent = p,
    })

    local loadBtn = mk("TextButton", {
        Size = UDim2.new(1, 0, 0, 34),
        BackgroundColor3 = C.cardHi,
        Text = "Load Friends",
        TextColor3 = C.txt, TextSize = 12, Font = Enum.Font.GothamBold,
        AutoButtonColor = false,
        LayoutOrder = 3, ZIndex = 204, Parent = p,
    })
    corner(loadBtn, 10)

    friendsListFrame = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 20),
        BackgroundTransparency = 1,
        LayoutOrder = 4,
        AutomaticSize = Enum.AutomaticSize.Y,
        ZIndex = 203, Parent = p,
    })
    local ll = Instance.new("UIListLayout")
    ll.Padding = UDim.new(0, 6)
    ll.SortOrder = Enum.SortOrder.LayoutOrder
    ll.Parent = friendsListFrame

    local loading = false

    local function bulkPresence(ids)
        local body = HttpService:JSONEncode({userIds = ids})
        local headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/json",
        }
        if syn and syn.request then
            local ok, r = pcall(syn.request, {Url="https://presence.roblox.com/v1/presence/users", Method="POST", Headers=headers, Body=body})
            if ok and r and r.Body then return r.Body end
        end
        if request then
            local ok, r = pcall(request, {Url="https://presence.roblox.com/v1/presence/users", Method="POST", Headers=headers, Body=body})
            if ok and r and r.Body then return r.Body end
        end
        if http_request then
            local ok, r = pcall(http_request, {Url="https://presence.roblox.com/v1/presence/users", Method="POST", Headers=headers, Body=body})
            if ok and r and r.Body then return r.Body end
        end
        if http and http.request then
            local ok, r = pcall(http.request, {Url="https://presence.roblox.com/v1/presence/users", Method="POST", Headers=headers, Body=body})
            if ok and r and r.Body then return r.Body end
        end
        return nil
    end

    local function renderFriendRow(i, f, pr, gameNames)
        local row = mk("Frame", {
            Name = "F_" .. tostring(f.Id),
            Size = UDim2.new(1, 0, 0, 60),
            BackgroundColor3 = C.card, BorderSizePixel = 0,
            LayoutOrder = i, ZIndex = 204, Parent = friendsListFrame,
        })
        corner(row, 12)

        local av = mk("Frame", {
            Size = UDim2.fromOffset(38, 38), Position = UDim2.fromOffset(10, 11),
            BackgroundColor3 = C.cardHi, BorderSizePixel = 0,
            ClipsDescendants = true, ZIndex = 205, Parent = row,
        })
        corner(av, UDim.new(1, 0))
        mk("ImageLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Image = "rbxthumb://type=AvatarHeadShot&id=" .. f.Id .. "&w=60&h=60",
            ScaleType = Enum.ScaleType.Crop, ZIndex = 206, Parent = av,
        })

        local statusText, statusColor = "Unknown", C.faint
        local canJoin, jpid, jgid = false, nil, nil
        local playingGameName = nil
        if pr then
            if pr.userPresenceType == 2 then
                statusText = "In game"; statusColor = C.good
                local pid = tonumber(pr.rootPlaceId)
                if pid and gameNames then playingGameName = gameNames[pid] end
                if pr.gameId then canJoin = true; jpid = pid; jgid = pr.gameId end
            elseif pr.userPresenceType == 1 then statusText = "Online"; statusColor = C.good
            elseif pr.userPresenceType == 3 then statusText = "Studio"; statusColor = C.warn
            else statusText = "Offline"; statusColor = C.faint end
        else
            statusText = "Unknown"; statusColor = C.faint
        end

        mk("TextLabel", {
            Size = UDim2.new(1, -110, 0, 16), Position = UDim2.fromOffset(56, 8),
            BackgroundTransparency = 1, Text = f.Username,
            TextColor3 = C.txt, TextSize = 13, Font = Enum.Font.GothamBold,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextTruncate = Enum.TextTruncate.AtEnd,
            ZIndex = 205, Parent = row,
        })

        local statusLine
        if playingGameName then statusLine = statusText .. " · " .. playingGameName
        elseif canJoin and jpid == game.PlaceId then statusLine = "In game · This game"
        else statusLine = statusText end

        mk("TextLabel", {
            Size = UDim2.new(1, -110, 0, 22), Position = UDim2.fromOffset(56, 24),
            BackgroundTransparency = 1, Text = statusLine,
            TextColor3 = statusColor, TextSize = 11, Font = Enum.Font.Gotham,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            TextWrapped = true, ZIndex = 205, Parent = row,
        })

        if canJoin then
            local btnLabel = (jpid == game.PlaceId) and "Join" or "Join Game"
            local jb = mk("TextButton", {
                Size = UDim2.fromOffset(78, 32),
                Position = UDim2.new(1, -88, 0.5, -16),
                BackgroundColor3 = C.accent, Text = btnLabel,
                TextColor3 = C.bg, TextSize = 11, Font = Enum.Font.GothamBold,
                AutoButtonColor = false, ZIndex = 206, Parent = row,
            })
            corner(jb, 8)
            jb.MouseButton1Click:Connect(function()
                notify("Friends", "Joining " .. f.Username .. "...", 3, "info")
                task.wait(0.4)
                pcall(function() TeleportService:TeleportToPlaceInstance(jpid, jgid, LP) end)
            end)
        end
    end

    _G.__nhLoadFriends = function()
        if loading then return end
        loading = true
        print("[NH] friends: load start")
        loadBtn.Text = "Loading..."
        friendsStatus.Text = "Fetching friends list..."
        friendsStatus.TextColor3 = C.dim

        for _, c in ipairs(friendsListFrame:GetChildren()) do
            if c:IsA("Frame") then c:Destroy() end
        end

        task.spawn(function()
            local friends = {}
            local ok, pages = pcall(function() return Players:GetFriendsAsync(LP.UserId) end)
            if ok and pages then
                local guard = 0
                while guard < 6 do
                    guard = guard + 1
                    local ok2, pg = pcall(function() return pages:GetCurrentPage() end)
                    if not ok2 or not pg then break end
                    for _, f in ipairs(pg) do
                        table.insert(friends, {Id = f.Id, Username = f.Username or f.Name or "?"})
                    end
                    if pages.IsFinished then break end
                    if not pcall(function() pages:AdvanceToNextPageAsync() end) then break end
                end
            end

            print("[NH] friends: got", #friends)

            if #friends == 0 then
                friendsStatus.Text = "No friends found"
                friendsStatus.TextColor3 = C.dim
                loadBtn.Text = "Reload"
                loading = false
                return
            end

            table.sort(friends, function(a, b)
                return (a.Username or ""):lower() < (b.Username or ""):lower()
            end)

            for i, f in ipairs(friends) do
                renderFriendRow(i, f, nil, nil)
            end
            friendsStatus.Text = #friends .. " friends (loading presence...)"
            friendsStatus.TextColor3 = C.dim
            loadBtn.Text = "Reload"

            local pmap = {}
            local ids = {}
            for _, f in ipairs(friends) do table.insert(ids, tonumber(f.Id)) end
            print("[NH] friends: requesting presence for", #ids)
            local raw = bulkPresence(ids)
            print("[NH] friends: presence raw len", raw and #raw or 0)
            if raw then
                local okJ, d = pcall(function() return HttpService:JSONDecode(raw) end)
                if okJ and type(d) == "table" and type(d.userPresences) == "table" then
                    for _, pr in ipairs(d.userPresences) do
                        pmap[tonumber(pr.userId)] = pr
                    end
                end
            end

            local placeIds = {}
            local seen = {}
            for _, pr in pairs(pmap) do
                if pr.userPresenceType == 2 and pr.rootPlaceId then
                    local pid = tonumber(pr.rootPlaceId)
                    if not seen[pid] then seen[pid] = true; table.insert(placeIds, pid) end
                end
            end
            local gameNames = {}
            for i = 1, #placeIds, 50 do
                local batch = {}
                for j = i, math.min(i + 49, #placeIds) do table.insert(batch, tostring(placeIds[j])) end
                if #batch > 0 then
                    local url = "https://games.roblox.com/v1/games?universeIds=" .. table.concat(batch, ",")
                    local gRaw = httpGet(url)
                    if gRaw then
                        local okG, gData = pcall(function() return HttpService:JSONDecode(gRaw) end)
                        if okG and type(gData) == "table" and type(gData.data) == "table" then
                            for _, gd in ipairs(gData.data) do
                                if gd.name then gameNames[tonumber(gd.id)] = gd.name end
                            end
                        end
                    end
                end
            end

            local function rank(pr)
                if not pr then return 0 end
                if pr.userPresenceType == 2 then return 4 end
                if pr.userPresenceType == 1 then return 3 end
                if pr.userPresenceType == 3 then return 2 end
                return 1
            end
            table.sort(friends, function(a, b)
                local ra = rank(pmap[tonumber(a.Id)])
                local rb = rank(pmap[tonumber(b.Id)])
                if ra ~= rb then return ra > rb end
                return (a.Username or ""):lower() < (b.Username or ""):lower()
            end)

            for _, c in ipairs(friendsListFrame:GetChildren()) do
                if c:IsA("Frame") then c:Destroy() end
            end
            local online = 0
            for i, f in ipairs(friends) do
                local pr = pmap[tonumber(f.Id)]
                if pr and pr.userPresenceType and pr.userPresenceType > 0 then online = online + 1 end
                renderFriendRow(i, f, pr, gameNames)
            end
            friendsStatus.Text = online .. " online / " .. #friends .. " total"
            friendsStatus.TextColor3 = C.good
            print("[NH] friends: done. online", online, "of", #friends)
            loading = false
        end)
    end

    loadBtn.MouseButton1Click:Connect(_G.__nhLoadFriends)
end)

-- CHAT
local chatAppendFn
pcall(function()
    local p = makePage("chat")
    makeHeader(p, "GLOBAL CHAT", 1)
    local chatLog = mk("ScrollingFrame", {Size = UDim2.new(1, 0, 0, 220), BackgroundColor3 = C.card, BorderSizePixel = 0, ScrollBarThickness = 2, ScrollBarImageColor3 = C.bdHi, CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y, LayoutOrder = 2, ZIndex = 203, Parent = p})
    corner(chatLog, 12)
    local cl = Instance.new("UIListLayout")
    cl.Padding = UDim.new(0, 3) cl.SortOrder = Enum.SortOrder.LayoutOrder cl.Parent = chatLog
    local cp = Instance.new("UIPadding")
    cp.PaddingTop = UDim.new(0, 8) cp.PaddingLeft = UDim.new(0, 8) cp.PaddingRight = UDim.new(0, 8) cp.PaddingBottom = UDim.new(0, 8) cp.Parent = chatLog
    local inputRow = mk("Frame", {Size = UDim2.new(1, 0, 0, 40), BackgroundColor3 = C.card, BorderSizePixel = 0, LayoutOrder = 3, ZIndex = 203, Parent = p})
    corner(inputRow, 10)
    local chatInput = mk("TextBox", {Size = UDim2.new(1, -70, 1, 0), Position = UDim2.fromOffset(10, 0), BackgroundTransparency = 1, Text = "", PlaceholderText = "Type a message...", PlaceholderColor3 = C.faint, TextColor3 = C.txt, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false, ZIndex = 204, Parent = inputRow})
    local sendBtn = mk("TextButton", {Size = UDim2.fromOffset(52, 28), Position = UDim2.new(1, -60, 0.5, -14), BackgroundColor3 = C.accent, Text = "Send", TextColor3 = C.bg, TextSize = 11, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 204, Parent = inputRow})
    corner(sendBtn, 8)
    local chatSeen = {}
    local chatOrder = 0
    local function hashColor(str)
        local h = 0
        for i = 1, #str do h = (h * 31 + string.byte(str, i)) % 360 end
        return Color3.fromHSV(h / 360, 0.5, 1)
    end
    chatAppendFn = function(entry, isAnn)
        if chatSeen[entry.id] then return end
        chatSeen[entry.id] = true
        chatOrder = chatOrder + 1
        local row = mk("Frame", {Size = UDim2.new(1, 0, 0, isAnn and 34 or 28), BackgroundColor3 = isAnn and C.cardHi or C.bg, BorderSizePixel = 0, LayoutOrder = chatOrder, ZIndex = 204, Parent = chatLog})
        corner(row, 6)
        mk("TextLabel", {Size = UDim2.new(1, -12, 0, 12), Position = UDim2.fromOffset(6, 2), BackgroundTransparency = 1, Text = (entry.name or "?") .. (entry.game and not isAnn and (" · " .. entry.game) or ""), TextColor3 = isAnn and C.accent or hashColor(entry.name or "?"), TextSize = 10, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 205, Parent = row})
        mk("TextLabel", {Size = UDim2.new(1, -12, 0, isAnn and 18 or 14), Position = UDim2.fromOffset(6, isAnn and 14 or 13), BackgroundTransparency = 1, Text = entry.msg or "", TextColor3 = C.txt, TextSize = 10, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, ZIndex = 205, Parent = row})
        task.defer(function() pcall(function() chatLog.CanvasPosition = Vector2.new(0, chatLog.AbsoluteCanvasSize.Y) end) end)
    end
    local function chatSend()
        local txt = (chatInput.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if #txt < 1 or #txt > 200 then return end
        chatInput.Text = ""
        local entry = {id = tostring(os.time()) .. "_" .. LP.UserId .. "_" .. tostring(math.random(1000, 9999)), uid = LP.UserId, name = LP.DisplayName or LP.Name, msg = txt, ts = os.time(), game = currentGame and currentGame.name or "Unknown"}
        chatAppendFn(entry, false)
        if isOwner then ownerRainbowUntil = os.time() + 15 end
        task.spawn(function()
            local d = readBlob() or {}
            local arr = type(d.chat) == "table" and d.chat or {}
            table.insert(arr, entry)
            while #arr > 50 do table.remove(arr, 1) end
            d.chat = arr
            writeBlob(d)
        end)
    end
    sendBtn.MouseButton1Click:Connect(chatSend)
    chatInput.FocusLost:Connect(function(enter) if enter then chatSend() end end)
end)

-- ANNOUNCE
if isOwner then
    pcall(function()
        local p = makePage("announce")
        makeHeader(p, "ANNOUNCEMENTS", 1)
        local composeCard = makeCard(p, 2, 130)
        local annBox = mk("TextBox", {Size = UDim2.new(1, -20, 90, 0), Position = UDim2.fromOffset(10, 10), BackgroundColor3 = C.bg, Text = "", PlaceholderText = "Type announcement...", PlaceholderColor3 = C.faint, TextColor3 = C.txt, TextSize = 12, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, MultiLine = true, ClearTextOnFocus = false, ZIndex = 204, Parent = composeCard})
        corner(annBox, 8)
        local ap = Instance.new("UIPadding")
        ap.PaddingLeft = UDim.new(0, 10) ap.PaddingTop = UDim.new(0, 8) ap.PaddingRight = UDim.new(0, 10) ap.Parent = annBox
        local sendBtn = mk("TextButton", {Size = UDim2.new(1, -20, 0, 32), Position = UDim2.fromOffset(10, 88), BackgroundColor3 = C.accent, Text = "Send Announcement", TextColor3 = C.bg, TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 204, Parent = composeCard})
        corner(sendBtn, 8)
        sendBtn.MouseButton1Click:Connect(function()
            local msg = annBox.Text or ""
            if #msg < 1 then return end
            sendBtn.Text = "..."
            task.spawn(function()
                local annId = tostring(os.time()) .. "_" .. tostring(math.random(1000, 9999))
                local entry = {id = annId, uid = 0, name = LP.DisplayName or LP.Name, userId = LP.UserId, msg = msg, ts = os.time(), game = "ANNOUNCEMENT", ann = true}
                local ok = pcall(function()
                    local d = readBlob() or {}
                    d.announcement = {id = annId, msg = msg, sender = LP.DisplayName or LP.Name, userId = LP.UserId, ts = os.time()}
                    local arr = type(d.chat) == "table" and d.chat or {}
                    table.insert(arr, entry)
                    while #arr > 50 do table.remove(arr, 1) end
                    d.chat = arr
                    writeBlob(d)
                end)
                if ok then
                    ownerRainbowUntil = os.time() + 15
                    annSeen = annId
                    if writefile then pcall(writefile, "NullHub_v4_annseen.txt", annId) end
                    if chatAppendFn then chatAppendFn(entry, true) end
                    if showAnnouncement then pcall(showAnnouncement, {id = annId, msg = msg, sender = LP.DisplayName or LP.Name, userId = LP.UserId, ts = os.time()}) end
                    notify("Announcement", "Sent", 3, "success")
                    annBox.Text = ""
                else
                    notify("Announcement", "Failed", 3, "error")
                end
                sendBtn.Text = "Send Announcement"
            end)
        end)
    end)
end

-- SETTINGS
pcall(function()
    local p = makePage("settings")
    makeHeader(p, "PERFORMANCE", 1)
    makeToggle(p, 2, "Boost FPS", CONFIG.boost, function(state)
        CONFIG.boost = state saveConfig()
        if _G.__nhSetBoost then pcall(_G.__nhSetBoost, state) end
    end)
    makeToggle(p, 3, "FPS / Ping HUD", CONFIG.hud, function(state)
        CONFIG.hud = state saveConfig()
        if _G.__nhSetHUD then pcall(_G.__nhSetHUD, state) end
    end)
    makeHeader(p, "WARNINGS", 4)
    makeToggle(p, 5, "Warning dismissed (Keyless)", CONFIG.warn_keyless, function(v) CONFIG.warn_keyless = v saveConfig() end)
    makeToggle(p, 6, "Warning dismissed (Key Required)", CONFIG.warn_keyed, function(v) CONFIG.warn_keyed = v saveConfig() end)
    makeToggle(p, 7, "Warning dismissed (Hubs)", CONFIG.warn_hubs, function(v) CONFIG.warn_hubs = v saveConfig() end)
    makeHeader(p, "KEYBIND", 8)
    local kbCard = makeCard(p, 9, 56)
    mk("TextLabel", {Size = UDim2.new(0.5, 0, 1, 0), Position = UDim2.fromOffset(16, 0), BackgroundTransparency = 1, Text = "Toggle Key", TextColor3 = C.txt, TextSize = 14, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 204, Parent = kbCard})
    local kbBtn = mk("TextButton", {Size = UDim2.fromOffset(110, 36), Position = UDim2.new(1, -126, 0.5, -18), BackgroundColor3 = C.cardHi, Text = CONFIG.key, TextColor3 = C.txt, TextSize = 12, Font = Enum.Font.GothamBold, AutoButtonColor = false, ZIndex = 204, Parent = kbCard})
    corner(kbBtn, 10)
    local listening = false
    kbBtn.MouseButton1Click:Connect(function()
        listening = true kbBtn.Text = "Press..." kbBtn.TextColor3 = C.dim
    end)
    UIS.InputBegan:Connect(function(input, gp)
        if gp then return end
        if listening and input.UserInputType == Enum.UserInputType.Keyboard then
            listening = false
            CONFIG.key = input.KeyCode.Name
            kbBtn.Text = CONFIG.key kbBtn.TextColor3 = C.txt
            saveConfig()
        end
    end)
    makeHeader(p, "ABOUT", 100)
    local ac = makeCard(p, 101, 90)
    mk("TextLabel", {
        Size = UDim2.new(1, -20, 1, -20), Position = UDim2.fromOffset(12, 10),
        BackgroundTransparency = 1,
        Text = string.format("Null Hub v4\nGames: %d | Hubs: %d | Others: %d\nKey: %s | Owner: %s",
            #GAME_DB, #HUBS_DB, #OTHER_SCRIPTS, CONFIG.key, isOwner and "yes" or "no"),
        TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true, ZIndex = 204, Parent = ac,
    })
end)

-- FEATURES
local boostStash = {}
local function stashSet(obj, prop, val)
    if not boostStash[obj] then boostStash[obj] = {} end
    if boostStash[obj][prop] == nil then
        local ok, old = pcall(function() return obj[prop] end)
        if ok then boostStash[obj][prop] = old end
    end
    pcall(function() obj[prop] = val end)
end
local function stashRestore()
    for obj, props in pairs(boostStash) do
        for p, v in pairs(props) do pcall(function() obj[p] = v end) end
    end
    boostStash = {}
end
local function stripDescendant(d)
    if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Fire") or d:IsA("Smoke") or d:IsA("Sparkles") then stashSet(d, "Enabled", false)
    elseif d:IsA("PointLight") or d:IsA("SpotLight") or d:IsA("SurfaceLight") then stashSet(d, "Enabled", false)
    elseif d:IsA("Decal") or d:IsA("Texture") then if not (d.Parent and d.Parent.Name == "Head" and d.Name == "face") then stashSet(d, "Transparency", 1) end
    elseif d:IsA("BasePart") then stashSet(d, "CastShadow", false) stashSet(d, "Material", Enum.Material.SmoothPlastic)
    elseif d:IsA("PostEffect") then stashSet(d, "Enabled", false) end
end
local boostConns = {}
_G.__nhSetBoost = function(on)
    if on then
        for _, c in ipairs(boostConns) do pcall(function() c:Disconnect() end) end
        boostConns = {}
        pcall(function()
            local r = settings().Rendering
            stashSet(r, "QualityLevel", Enum.QualityLevel.Level01)
            stashSet(r, "MeshPartDetailLevel", Enum.MeshPartDetailLevel.Level01)
            stashSet(Lighting, "GlobalShadows", false)
            stashSet(Lighting, "FogEnd", 9e9)
            stashSet(workspace.Terrain, "Decoration", false)
        end)
        table.insert(boostConns, workspace.DescendantAdded:Connect(function(d) if CONFIG.boost then stripDescendant(d) end end))
        table.insert(boostConns, Lighting.DescendantAdded:Connect(function(d) if CONFIG.boost then stripDescendant(d) end end))
        for _, d in ipairs(workspace:GetDescendants()) do stripDescendant(d) end
        for _, d in ipairs(Lighting:GetDescendants()) do stripDescendant(d) end
    else
        stashRestore()
        for _, c in ipairs(boostConns) do pcall(function() c:Disconnect() end) end
        boostConns = {}
    end
end
if CONFIG.boost then pcall(_G.__nhSetBoost, true) end

-- HUD
local hudGui = mk("ScreenGui", {Name = "NullHub_HUD", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 9999, Parent = PARENT})
local hudFrame = mk("Frame", {Size = UDim2.fromOffset(150, 44), Position = UDim2.new(CONFIG.hudX, 0, CONFIG.hudY, 0), BackgroundColor3 = C.card, BackgroundTransparency = 0.15, BorderSizePixel = 0, Visible = CONFIG.hud, Active = true, Parent = hudGui})
corner(hudFrame, 10) stroke(hudFrame, C.bd, 1, 0.4)
local hudFPS = mk("TextLabel", {Size = UDim2.new(1, -16, 0, 20), Position = UDim2.fromOffset(10, 4), BackgroundTransparency = 1, Text = "FPS: --", TextColor3 = C.txt, TextSize = 12, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, Parent = hudFrame})
local hudPing = mk("TextLabel", {Size = UDim2.new(1, -16, 0, 16), Position = UDim2.fromOffset(10, 24), BackgroundTransparency = 1, Text = "Ping: --", TextColor3 = C.dim, TextSize = 11, Font = Enum.Font.Gotham, TextXAlignment = Enum.TextXAlignment.Left, Parent = hudFrame})
do
    local hdDrag, hdInput = nil, nil
    hudFrame.InputBegan:Connect(function(i)
        if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        if hdInput then return end
        hdInput = i
        hdDrag = {start = i.Position, orig = hudFrame.Position}
    end)
    UIS.InputChanged:Connect(function(i)
        if not hdDrag or i ~= hdInput then return end
        local d = i.Position - hdDrag.start
        hudFrame.Position = UDim2.new(hdDrag.orig.X.Scale, hdDrag.orig.X.Offset + d.X, hdDrag.orig.Y.Scale, hdDrag.orig.Y.Offset + d.Y)
    end)
    UIS.InputEnded:Connect(function(i)
        if i ~= hdInput then return end
        hdDrag = nil
        hdInput = nil
        CONFIG.hudX = hudFrame.Position.X.Scale
        CONFIG.hudY = hudFrame.Position.Y.Scale
        saveConfig()
    end)
end
local fpsCount, fpsTime = 0, 0
RunService.RenderStepped:Connect(function(dt)
    if not hudFrame.Visible then return end
    fpsCount = fpsCount + 1
    fpsTime = fpsTime + dt
    if fpsTime >= 0.5 then
        local f = math.floor(fpsCount / fpsTime + 0.5)
        fpsCount = 0 fpsTime = 0
        hudFPS.Text = "FPS: " .. f
        hudFPS.TextColor3 = f < 30 and C.dim or (f < 55 and C.warn or C.txt)
    end
end)
task.spawn(function()
    local ping
    pcall(function() ping = Stats.Network.ServerStatsItem["Data Ping"] end)
    while hudGui.Parent do
        if hudFrame.Visible and ping then
            local ok, v = pcall(function() return ping:GetValue() end)
            if ok and type(v) == "number" then
                local p = math.floor(v + 0.5)
                hudPing.Text = "Ping: " .. p .. "ms"
            end
        end
        task.wait(0.5)
    end
end)
_G.__nhSetHUD = function(on) hudFrame.Visible = on end

-- NAMETAG RENDER
local nametagGui = mk("ScreenGui", {
    Name = "NullHub_NT", ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true, DisplayOrder = 1, Parent = PARENT,
})
local ntTags = {}
local ntTime = 0
local RAINBOW_SEQ = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 200, 0)),
    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 220, 255)),
    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 80, 255)),
    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(200, 0, 255)),
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 0, 0)),
})
RunService.RenderStepped:Connect(function(dt)
    ntTime = ntTime + dt
    if not CONFIG.nametag then
        for _, t in pairs(ntTags) do t.frame.Visible = false end
        return
    end
    local cam = workspace.CurrentCamera
    if not cam then return end
    local myPos = cam.CFrame.Position
    local maxDist = CONFIG.nt_max_dist or 250
    local solid = Color3.fromHSV(CONFIG.nt_h, CONFIG.nt_s, CONFIG.nt_v)
    local outlineCol = Color3.fromHSV(CONFIG.nt_outline_h, CONFIG.nt_outline_s, CONFIG.nt_outline_v)
    for _, plr in ipairs(Players:GetPlayers()) do
        local show = (plr == LP and CONFIG.nt_show_self) or (plr ~= LP and CONFIG.nt_show_others)
        local char = plr.Character
        local head = char and char:FindFirstChild("Head")
        if show and head then
            local dist = (head.Position - myPos).Magnitude
            if dist > maxDist then
                if ntTags[plr] then ntTags[plr].frame.Visible = false end
            else
                if not ntTags[plr] then
                    local frame = mk("Frame", {
                        Size = UDim2.fromOffset(240, 40),
                        AnchorPoint = Vector2.new(0.5, 1),
                        BackgroundTransparency = 1,
                        Visible = false, Parent = nametagGui,
                    })
                    local lbl = mk("TextLabel", {
                        Size = UDim2.fromScale(1, 1),
                        BackgroundTransparency = 1, Text = "",
                        TextColor3 = Color3.new(1, 1, 1),
                        TextSize = 20, Font = Enum.Font.GothamBold,
                        Parent = frame,
                    })
                    local grad = Instance.new("UIGradient")
                    grad.Parent = lbl
                    ntTags[plr] = {frame = frame, label = lbl, grad = grad}
                end
                local tag = ntTags[plr]
                local base = CONFIG.nt_text
                if CONFIG.nt_mode == "username" then base = plr.DisplayName or plr.Name
                elseif CONFIG.nt_mode == "both" then base = (plr.DisplayName or plr.Name) .. " · " .. CONFIG.nt_text end
                tag.label.Text = base
                tag.label.TextSize = CONFIG.nt_size
                tag.label.Rotation = CONFIG.nt_rot
                tag.label.Font = Enum.Font[CONFIG.nt_font] or Enum.Font.GothamBold
                tag.label.TextStrokeTransparency = CONFIG.nt_outline and 0 or 1
                tag.label.TextStrokeColor3 = outlineCol
                local forceRainbow = isOwner and (plr == LP) and ownerRainbowUntil > os.time()
                if CONFIG.nt_rainbow or forceRainbow then
                    tag.label.TextColor3 = Color3.new(1, 1, 1)
                    tag.grad.Color = RAINBOW_SEQ
                    tag.grad.Transparency = NumberSequence.new(0)
                    tag.grad.Offset = Vector2.new((ntTime * CONFIG.nt_rainbow_speed) % 1, 0)
                elseif CONFIG.nt_shine then
                    tag.label.TextColor3 = solid
                    tag.grad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
                    tag.grad.Transparency = NumberSequence.new({
                        NumberSequenceKeypoint.new(0.00, 0.65),
                        NumberSequenceKeypoint.new(0.40, 0.65),
                        NumberSequenceKeypoint.new(0.50, 0.00),
                        NumberSequenceKeypoint.new(0.60, 0.65),
                        NumberSequenceKeypoint.new(1.00, 0.65),
                    })
                    tag.grad.Offset = Vector2.new(((ntTime * CONFIG.nt_shine_speed) % 2) - 1, 0)
                else
                    tag.label.TextColor3 = solid
                    tag.grad.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.new(1, 1, 1))
                    tag.grad.Transparency = NumberSequence.new(0)
                    tag.grad.Offset = Vector2.new(0, 0)
                end
                local headPos = head.Position + Vector3.new(CONFIG.nt_ox / 10, CONFIG.nt_oy, 0)
                local sp, onScreen = cam:WorldToViewportPoint(headPos)
                if onScreen and sp.Z > 0 then
                    tag.frame.Position = UDim2.fromOffset(sp.X, sp.Y)
                    tag.frame.Visible = true
                else
                    tag.frame.Visible = false
                end
            end
        elseif ntTags[plr] then
            ntTags[plr].frame.Visible = false
        end
    end
end)
Players.PlayerRemoving:Connect(function(plr)
    if ntTags[plr] then
        pcall(function() ntTags[plr].frame:Destroy() end)
        ntTags[plr] = nil
    end
end)

-- ANNOUNCEMENT TOAST
local annGui = mk("ScreenGui", {Name = "NullHub_Announce", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, IgnoreGuiInset = true, DisplayOrder = 100000, Parent = PARENT})
local annModal = nil
local function userColor(uid, name)
    local s = tostring(uid or name or "?")
    local h = 0
    for i = 1, #s do h = (h * 31 + string.byte(s, i)) % 360 end
    return Color3.fromHSV(h / 360, 0.65, 1)
end
showAnnouncement = function(p)
    if annModal then pcall(function() annModal:Destroy() end) end
    local row = mk("Frame", {Size = UDim2.new(0, 420, 0, 92), Position = UDim2.new(0.5, -210, 0, -110), BackgroundColor3 = C.card, BorderSizePixel = 0, ZIndex = 1, Parent = annGui})
    corner(row, 16) stroke(row, C.bdHi, 1.2, 0.1)
    annModal = row
    local pfp = mk("Frame", {Size = UDim2.fromOffset(56, 56), Position = UDim2.fromOffset(16, 18), BackgroundColor3 = C.cardHi, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 2, Parent = row})
    corner(pfp, UDim.new(1, 0)) stroke(pfp, C.bdHi, 1.5, 0)
    if p.userId and p.userId > 0 then
        local av = mk("ImageLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "rbxthumb://type=AvatarHeadShot&id=" .. p.userId .. "&w=100&h=100", ScaleType = Enum.ScaleType.Crop, ZIndex = 3, Parent = pfp})
        corner(av, UDim.new(1, 0))
    else
        mk("TextLabel", {Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Text = "📢", TextSize = 24, ZIndex = 3, Parent = pfp})
    end
    local nameColor = userColor(p.userId, p.sender)
    local nl = mk("TextLabel", {Size = UDim2.new(1, -90, 0, 24), Position = UDim2.fromOffset(84, 16), BackgroundTransparency = 1, Text = p.sender or "Owner", TextColor3 = nameColor, TextSize = 18, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 2, Parent = row})
    nl.TextStrokeTransparency = 0 nl.TextStrokeColor3 = Color3.new(0, 0, 0)
    local body = mk("TextLabel", {Size = UDim2.new(1, -100, 0, 40), Position = UDim2.fromOffset(84, 44), BackgroundTransparency = 1, Text = p.msg or "", TextColor3 = C.txt, TextSize = 14, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, ZIndex = 2, Parent = row})
    body.TextStrokeTransparency = 0 body.TextStrokeColor3 = Color3.new(0, 0, 0)
    TweenService:Create(row, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -210, 0, 60)}):Play()
    task.delay(10, function()
        local t = TweenService:Create(row, TweenInfo.new(0.32, Enum.EasingStyle.Cubic), {Position = UDim2.new(0.5, -210, 0, -110)})
        t:Play()
        t.Completed:Connect(function()
            pcall(function() row:Destroy() end)
            if annModal == row then annModal = nil end
        end)
    end)
end

-- POLLER
task.spawn(function()
    task.wait(3)
    while _G.__nh ~= false do
        local d = readBlob()
        if d then
            if type(d.announcement) == "table" then
                local a = d.announcement
                if a.id and a.id ~= "" then
                    local id = tostring(a.id)
                    if id ~= annSeen then
                        annSeen = id
                        if writefile then pcall(writefile, "NullHub_v4_annseen.txt", id) end
                        pcall(showAnnouncement, a)
                    end
                end
            end
            if type(d.chat) == "table" and chatAppendFn then
                for _, msg in ipairs(d.chat) do
                    if type(msg) == "table" and msg.id and msg.msg then
                        local isAnn = msg.ann == true or msg.uid == 0
                        pcall(chatAppendFn, msg, isAnn)
                    end
                end
            end
        end
        task.wait(4)
    end
end)

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode.Name == CONFIG.key then
        if sheetOpen then closeSheet() else openSheet() end
    end
end)

switchPage("home")

task.delay(2, function()
    if _G.__nhLoadFriends then pcall(_G.__nhLoadFriends) end
end)

print("[NH] v4 ready | owner:", isOwner)
