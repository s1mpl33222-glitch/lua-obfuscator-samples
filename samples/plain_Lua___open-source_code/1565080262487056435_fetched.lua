-- [[ Rscripts Risk Notice ]]
-- This script is not verified by rscripts.net. Deal with caution.
--
-- Stay safe:
--   • Never log in on unofficial Roblox sites or lookalike domains.
--   • Real Roblox links use roblox.com (check the .com ending).
--   • Treat fake Roblox login / "claim reward" pages as phishing.
-- [[ End Rscripts Risk Notice ]]

--[[rscripts:analytics:start]]
-- Script analytics (enabled by the creator on rscripts.net).
-- Runs in its own thread and cannot affect the script below.
task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/v2/client.lua?s=6ade7d8391f0da85692ce6b0"))()
	end)
end)
--[[rscripts:analytics:end]]

-- LocalScript dans StarterPlayerScripts
-- =========================================================
-- AutoKill Zombies (dans HoodLocal) - HEAD + clic droit auto
-- Cibles : Workspace.HoodLocal.zombie1, zombie2, zombie3...
-- Le clic droit (visée) reste maintenu quand il y a une cible
-- =========================================================

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players   = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VIM       = game:GetService("VirtualInputManager")
local UIS       = game:GetService("UserInputService")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera

-- ===== CONFIG =====
local CONFIG = {
    ENABLED         = true,
    MAX_DISTANCE    = 1000,
    AIM_OFFSET      = Vector3.new(0, 0, 0),
    AIM_PART_NAME   = "Head",
    WEAPON_KEY      = Enum.KeyCode.Two,
    SPAM_KEY        = Enum.KeyCode.E,
    ACTIVATION_KEY  = Enum.KeyCode.F,
    WEAPON_CHECK    = 0.5,
    MONEY_GAINED    = 0,
    SHOT_DELAY      = 0.08,
    BURST_SIZE      = 3,
    BURST_PAUSE     = 0.25,
    AIM_STRICT      = 0.97,
    RIGHT_HOLD      = true,   -- <-- clic droit maintenu auto
}

local state = {
    firing       = false,
    toggleMode   = true,
    waitingFor   = nil,
    lastShot     = 0,
    shotsInBurst = 0,
    lastBurst    = 0,
    rightHeld    = false,  -- état actuel du clic droit
}

-- =========================================================
-- HOODLOCAL
-- =========================================================
local hoodLocal = Workspace:WaitForChild("HoodLocal", 10)
if not hoodLocal then
    warn("[AutoKillZ] HoodLocal introuvable dans Workspace")
    return
end

print("[AutoKillZ] HoodLocal trouvé :", hoodLocal:GetFullName())

local function getZombies()
    local list = {}
    for _, obj in ipairs(hoodLocal:GetChildren()) do
        if obj:IsA("Model") and string.match(string.lower(obj.Name), "^zombie") then
            table.insert(list, obj)
        end
    end
    return list
end

local initial = getZombies()
print("[AutoKillZ] Zombies détectés dans HoodLocal :", #initial)
for _, z in ipairs(initial) do
    print("  -", z.Name,
        "| Head:", tostring(z:FindFirstChild("Head") ~= nil),
        "| Humanoid:", tostring(z:FindFirstChildOfClass("Humanoid") ~= nil),
        "| HRP:", tostring(z:FindFirstChild("HumanoidRootPart") ~= nil))
end

-- ===== DÉTECTION ARGENT =====
local function getMoney()
    local leaderstats = player:FindFirstChild("leaderstats")
    if leaderstats then
        for _, stat in ipairs(leaderstats:GetChildren()) do
            if stat:IsA("IntValue") or stat:IsA("NumberValue") then
                local n = string.lower(stat.Name)
                if string.find(n, "cash") or string.find(n, "money")
                    or string.find(n, "coin") or string.find(n, "argent")
                    or string.find(n, "dollar") then
                    return stat.Value
                end
            end
        end
    end
    for _, attrName in ipairs({"Money","Cash","Coins","Argent","Dollars"}) do
        local ok, val = pcall(function() return player:GetAttribute(attrName) end)
        if ok and typeof(val) == "number" then return val end
    end
    return nil
end

local moneyStart = getMoney() or 0
local lastMoney  = moneyStart

-- =========================================================
-- RAYFIELD UI
-- =========================================================
local Window = Rayfield:CreateWindow({
    Name = "AutoKill Zombies (HEAD)",
    LoadingTitle = "AutoKill Zombies",
    LoadingSubtitle = "Headshot + clic droit auto",
    ShowText = "AZ",
    Theme = "Default",
    ToggleUIKeybind = "K",
    ConfigurationSaving = { Enabled = false, FolderName = nil, FileName = "AZCfg" },
    Discord = { Enabled = false, Invite = "x", RememberJoins = false },
    KeySystem = false,
    KeySettings = { Title = "x", Subtitle = "x", Note = "", FileName = "k", SaveKey = false, GrabKeyFromSite = false, Key = {"x"} },
})

local TabMain = Window:CreateTab("Main", 4483362458)
local TabKeys = Window:CreateTab("Touches", 4483362458)
local TabAim  = Window:CreateTab("Tir", 4483362458)
local TabDbg  = Window:CreateTab("Debug", 4483362458)

-- =========================================================
-- ONGLET MAIN
-- =========================================================
TabMain:CreateSection("Activation", false)

TabMain:CreateToggle({
    Name = "Script activé",
    CurrentValue = true,
    Flag = "AZ_Enabled",
    Callback = function(v)
        CONFIG.ENABLED = v
        if not v then
            state.firing = false
            -- relâche le clic droit si on désactive
            if state.rightHeld then
                VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                state.rightHeld = false
            end
        end
    end,
})

TabMain:CreateSection("Compteurs", false)

local zombieCountLabel = TabMain:CreateLabel("Zombies dans HoodLocal : 0", nil)
local moneyLabel       = TabMain:CreateLabel("Argent gagné : 0", nil)
local statusLabel      = TabMain:CreateLabel("Statut : prêt (F)", nil)

TabMain:CreateSection("Actions", false)

TabMain:CreateButton({
    Name = "Forcer équip arme",
    Interact = 'Interact',
    Callback = function()
        VIM:SendKeyEvent(true, CONFIG.WEAPON_KEY, false, game)
        task.wait(0.03)
        VIM:SendKeyEvent(false, CONFIG.WEAPON_KEY, false, game)
    end,
})

TabMain:CreateButton({
    Name = "Réinitialiser argent gagné",
    Interact = 'Interact',
    Callback = function()
        CONFIG.MONEY_GAINED = 0
        moneyStart = getMoney() or 0
        lastMoney = moneyStart
        pcall(function() moneyLabel:Set("Argent gagné : 0") end)
    end,
})

TabMain:CreateSection("Paramètres", false)

TabMain:CreateSlider({
    Name = "Distance max",
    Range = {10, 3000}, Increment = 10, Suffix = "studs",
    CurrentValue = 1000, Flag = "AZ_Dist",
    Callback = function(v) CONFIG.MAX_DISTANCE = v end,
})

TabMain:CreateSlider({
    Name = "Vérif arme",
    Range = {100, 2000}, Increment = 100, Suffix = "ms",
    CurrentValue = 500, Flag = "AZ_WCheck",
    Callback = function(v) CONFIG.WEAPON_CHECK = v / 1000 end,
})

TabMain:CreateToggle({
    Name = "Mode toggle (F = on/off)",
    CurrentValue = true,
    Flag = "AZ_Toggle",
    Callback = function(v) state.toggleMode = v end,
})

TabMain:CreateToggle({
    Name = "Clic droit maintenu auto",
    Info = "Garde la visée (clic droit) appuyée tant qu'il y a un zombie",
    CurrentValue = true,
    Flag = "AZ_RightHold",
    Callback = function(v)
        CONFIG.RIGHT_HOLD = v
        if not v and state.rightHeld then
            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
            state.rightHeld = false
        end
    end,
})

-- =========================================================
-- ONGLET TIR
-- =========================================================
TabAim:CreateSection("Rafales", false)

TabAim:CreateSlider({
    Name = "Délai entre balles", Range = {40, 300}, Increment = 10, Suffix = "ms",
    CurrentValue = 80, Flag = "AZ_ShotDelay",
    Callback = function(v) CONFIG.SHOT_DELAY = v / 1000 end,
})

TabAim:CreateSlider({
    Name = "Balles par rafale", Range = {1, 10}, Increment = 1, Suffix = "balles",
    CurrentValue = 3, Flag = "AZ_BurstSize",
    Callback = function(v) CONFIG.BURST_SIZE = v end,
})

TabAim:CreateSlider({
    Name = "Pause entre rafales", Range = {100, 1000}, Increment = 25, Suffix = "ms",
    CurrentValue = 250, Flag = "AZ_BurstPause",
    Callback = function(v) CONFIG.BURST_PAUSE = v / 1000 end,
})

TabAim:CreateSlider({
    Name = "Alignement requis (visée tête)", Range = {85, 100}, Increment = 1, Suffix = "%",
    CurrentValue = 97, Flag = "AZ_AimStrict",
    Callback = function(v) CONFIG.AIM_STRICT = v / 100 end,
})

TabAim:CreateSection("Partie visée", false)

TabAim:CreateDropdown({
    Name = "Partie du corps visée",
    Options = {"Head", "UpperTorso", "HumanoidRootPart"},
    CurrentOption = {"Head"},
    Flag = "AZ_AimPart",
    Callback = function(option)
        local opt = option
        if type(option) == "table" then opt = option[1] end
        CONFIG.AIM_PART_NAME = opt
        print("[AutoKillZ] Partie visée :", opt)
    end,
})

-- =========================================================
-- ONGLET TOUCHES
-- =========================================================
TabKeys:CreateSection("Configuration des touches", false)

local weaponKeyBtn = TabKeys:CreateButton({
    Name = "Touche ARME : [" .. CONFIG.WEAPON_KEY.Name .. "]",
    Interact = 'Interact',
    Callback = function()
        state.waitingFor = "weapon"
        weaponKeyBtn:Set("Touche ARME : [appuie...]")
    end,
})

local spamKeyBtn = TabKeys:CreateButton({
    Name = "Touche SPAM : [" .. CONFIG.SPAM_KEY.Name .. "]",
    Interact = 'Interact',
    Callback = function()
        state.waitingFor = "spam"
        spamKeyBtn:Set("Touche SPAM : [appuie...]")
    end,
})

local activationKeyBtn = TabKeys:CreateButton({
    Name = "Touche ACTIVATION : [" .. CONFIG.ACTIVATION_KEY.Name .. "]",
    Interact = 'Interact',
    Callback = function()
        state.waitingFor = "activation"
        activationKeyBtn:Set("Touche ACTIVATION : [appuie...]")
    end,
})

-- =========================================================
-- ONGLET DEBUG
-- =========================================================
TabDbg:CreateButton({
    Name = "Lister les zombies + Head (console)",
    Interact = 'Interact',
    Callback = function()
        print("=== CONTENU DE HOODLOCAL ===")
        local all = getZombies()
        print("Total zombies:", #all)
        for _, z in ipairs(all) do
            local head = z:FindFirstChild("Head")
            local hum  = z:FindFirstChildOfClass("Humanoid")
            print(string.format("  %s | Head=%s | Head.Pos=%s | Health=%s",
                z.Name,
                tostring(head ~= nil),
                head and tostring(head.Position) or "?",
                hum and tostring(hum.Health) or "?"
            ))
        end
    end,
})

-- =========================================================
-- INPUT
-- =========================================================
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end

    if state.waitingFor then
        if state.waitingFor == "weapon" then
            CONFIG.WEAPON_KEY = input.KeyCode
            weaponKeyBtn:Set("Touche ARME : [" .. input.KeyCode.Name .. "]")
        elseif state.waitingFor == "spam" then
            CONFIG.SPAM_KEY = input.KeyCode
            spamKeyBtn:Set("Touche SPAM : [" .. input.KeyCode.Name .. "]")
        elseif state.waitingFor == "activation" then
            CONFIG.ACTIVATION_KEY = input.KeyCode
            activationKeyBtn:Set("Touche ACTIVATION : [" .. input.KeyCode.Name .. "]")
        end
        state.waitingFor = nil
        return
    end

    if input.KeyCode == CONFIG.ACTIVATION_KEY and CONFIG.ENABLED then
        if state.toggleMode then
            state.firing = not state.firing
            state.shotsInBurst = 0
            print("[AutoKillZ] " .. (state.firing and "ACTIF" or "INACTIF"))
            if not state.firing and state.rightHeld then
                VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
                state.rightHeld = false
            end
        else
            state.firing = true
        end
    end
end)

UIS.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == CONFIG.ACTIVATION_KEY and not state.toggleMode then
        state.firing = false
        if state.rightHeld then
            VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)
            state.rightHeld = false
        end
    end
end)

-- =========================================================
-- FONCTIONS
-- =========================================================
local function getAimPart(zombie)
    if not zombie then return nil end
    local part = zombie:FindFirstChild(CONFIG.AIM_PART_NAME)
    if part and part:IsA("BasePart") then return part end
    local fallbacks = {"Head", "UpperTorso", "Torso", "HumanoidRootPart"}
    for _, name in ipairs(fallbacks) do
        local p = zombie:FindFirstChild(name)
        if p and p:IsA("BasePart") then return p end
    end
    return zombie.PrimaryPart
end

local function isValidZombie(zombie)
    if not zombie or not zombie:IsA("Model") then return false end
    local hum = zombie:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return false end
    local aimPart = getAimPart(zombie)
    if not aimPart then return false end
    return true, aimPart, hum
end

local function hasLineOfSight(origin, targetPos)
    local myChar = player.Character
    if not myChar then return false end

    local rp = RaycastParams.new()
    rp.FilterDescendantsInstances = {myChar, hoodLocal}
    rp.FilterType = Enum.RaycastFilterType.Exclude

    local res = Workspace:Raycast(origin, targetPos - origin, rp)
    if not res then return true end
    local hm = res.Instance:FindFirstAncestorOfClass("Model")
    if hm and hm:FindFirstChildOfClass("Humanoid") then return true end
    return false
end

local function getAllZombies()
    local myChar = player.Character
    if not myChar then return {} end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return {} end

    local list = {}
    for _, zombie in ipairs(getZombies()) do
        local valid, aimPart, hum = isValidZombie(zombie)
        if valid and aimPart then
            local dist = (myRoot.Position - aimPart.Position).Magnitude
            if dist <= CONFIG.MAX_DISTANCE then
                table.insert(list, {
                    aimPart = aimPart,
                    model = zombie,
                    hum = hum,
                    dist = dist,
                })
            end
        end
    end
    table.sort(list, function(a, b) return a.dist < b.dist end)
    return list
end

local function spamKey()
    VIM:SendKeyEvent(true, CONFIG.SPAM_KEY, false, game)
    task.wait(0.01)
    VIM:SendKeyEvent(false, CONFIG.SPAM_KEY, false, game)
end

local function hasToolEquipped()
    local myChar = player.Character
    if not myChar then return false end
    for _, c in ipairs(myChar:GetChildren()) do
        if c:IsA("Tool") then return true end
    end
    return false
end

local function forceEquipWeapon()
    if not CONFIG.ENABLED then return end
    if hasToolEquipped() then return end
    VIM:SendKeyEvent(true, CONFIG.WEAPON_KEY, false, game)
    task.wait(0.03)
    VIM:SendKeyEvent(false, CONFIG.WEAPON_KEY, false, game)
end

local function fireSingleShot()
    VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
    task.wait(0.02)
    VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

-- =========================================================
-- GESTION CLIC DROIT (visée maintenue)
-- =========================================================
local function holdRightClick()
    if CONFIG.RIGHT_HOLD and not state.rightHeld then
        VIM:SendMouseButtonEvent(0, 0, 1, true, game, 0)  -- down
        state.rightHeld = true
        print("[AutoKillZ] Clic droit MAINTENU (visée)")
    end
end

local function releaseRightClick()
    if state.rightHeld then
        VIM:SendMouseButtonEvent(0, 0, 1, false, game, 0)  -- up
        state.rightHeld = false
        print("[AutoKillZ] Clic droit RELÂCHÉ")
    end
end

-- =========================================================
-- BOUCLES
-- =========================================================
task.spawn(function()
    while true do
        task.wait(CONFIG.WEAPON_CHECK)
        forceEquipWeapon()
    end
end)

task.spawn(function()
    while true do
        task.wait(1)
        local current = getMoney()
        if current then
            if lastMoney == nil then
                lastMoney = current
                moneyStart = current
            end
            if current > lastMoney then
                CONFIG.MONEY_GAINED = CONFIG.MONEY_GAINED + (current - lastMoney)
                pcall(function() moneyLabel:Set("Argent gagné : " .. CONFIG.MONEY_GAINED) end)
            end
            lastMoney = current
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.03)

        local list = getAllZombies()
        pcall(function() zombieCountLabel:Set("Zombies dans HoodLocal : " .. #list) end)

        -- Si script désactivé / pas en mode firing → relâche le clic droit
        if not CONFIG.ENABLED or not state.firing then
            releaseRightClick()
            pcall(function()
                if not CONFIG.ENABLED then
                    statusLabel:Set("Statut : désactivé")
                else
                    statusLabel:Set("Statut : prêt (F)")
                end
            end)
            state.shotsInBurst = 0
            continue
        end

        local myChar = player.Character
        if not myChar or not myChar:FindFirstChildOfClass("Humanoid") then
            releaseRightClick()
            continue
        end
        if myChar.Humanoid.Health <= 0 then
            releaseRightClick()
            continue
        end

        -- Aucun zombie → relâche le clic droit
        if #list == 0 then
            releaseRightClick()
            pcall(function() statusLabel:Set("Statut : aucun zombie dans HoodLocal") end)
            continue
        end

        -- Cherche la cible la plus proche avec ligne de vue sur la tête
        local bestTarget, bestDist = nil, math.huge
        for _, entry in ipairs(list) do
            local aimPos = entry.aimPart.Position + CONFIG.AIM_OFFSET
            if hasLineOfSight(camera.CFrame.Position, aimPos) and entry.dist < bestDist then
                bestDist = entry.dist
                bestTarget = entry
            end
        end

        if not bestTarget then
            releaseRightClick()
            pcall(function() statusLabel:Set("Statut : pas de ligne de vue sur la tête") end)
            continue
        end

        if bestTarget.hum.Health <= 0 then
            state.shotsInBurst = 0
            continue
        end

        -- =====================================================
        -- ICI : un zombie est ciblé → on MAINTIENT le clic droit
        -- =====================================================
        holdRightClick()

        if tick() - state.lastBurst < CONFIG.BURST_PAUSE then continue end
        if tick() - state.lastShot  < CONFIG.SHOT_DELAY  then continue end

        local aimPos = bestTarget.aimPart.Position + CONFIG.AIM_OFFSET
        camera.CFrame = CFrame.new(camera.CFrame.Position, aimPos)

        local camLook = camera.CFrame.LookVector
        local toTarget = (aimPos - camera.CFrame.Position).Unit
        local dot = camLook:Dot(toTarget)

        pcall(function()
            statusLabel:Set(string.format("HEAD - %.0f studs | align %.2f | visée ON", bestDist, dot))
        end)

        if dot >= CONFIG.AIM_STRICT and bestTarget.hum.Health > 0 then
            fireSingleShot()
            spamKey()
            state.lastShot = tick()
            state.shotsInBurst = state.shotsInBurst + 1
            if state.shotsInBurst >= CONFIG.BURST_SIZE then
                state.shotsInBurst = 0
                state.lastBurst = tick()
            end
        end
    end
end)

-- =========================================================
player.OnTeleport:Connect(function()
    state.firing = false
    releaseRightClick()
end)

player.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    state.firing = false
    state.shotsInBurst = 0
    releaseRightClick()
end)

print("[AutoKillZ] Script lancé - HEAD + clic droit maintenu auto")