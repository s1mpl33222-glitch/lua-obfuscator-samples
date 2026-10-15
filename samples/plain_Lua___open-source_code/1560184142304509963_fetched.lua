
-- =========================================================
-- ✅ DISCORD WEBHOOK + USER COUNTER (JSONBin.io)
-- =========================================================

local WEBHOOK_URL = ""  -- GANTI
local JSONBIN_ID  = "6ab4baf0ffd5d160532942b0"                              -- GANTI (dari jsonbin.io)
local JSONBIN_KEY = "$2a$10$fqM416FqxYlN9IxodShsTe89/7se5TluSWtfdJo1xJgIPdt5ruJhi"                              -- GANTI (X-Master-Key)

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

-- ===== Helper: ambil info executor =====
local function getExecutorName()
    local name = "Unknown"
    pcall(function() if identifyexecutor then name = identifyexecutor() end end)
    if name == "Unknown" then
        pcall(function() if getexecutorname then name = getexecutorname() end end)
    end
    return tostring(name)
end

local function getHWID()
    local id = "N/A"
    pcall(function()
        if gethwid then id = gethwid()
        elseif syn and syn.get_hwid then id = syn.get_hwid()
        elseif getrobloxhwid then id = getrobloxhwid() end
    end)
    return tostring(id)
end

local function getAvatarURL(userId)
    return string.format(
        "https://www.roblox.com/headshot-thumbnail/image?userId=%d&width=420&height=420&format=png",
        userId
    )
end

-- ===== Load stats dari JSONBin =====
local function loadStats()
    local stats = { totalUsers = 0, seenUsers = {} }
    pcall(function()
        local res = request({
            Url = "https://api.jsonbin.io/v3/b/" .. JSONBIN_ID .. "/latest",
            Method = "GET",
            Headers = {
                ["X-Master-Key"] = JSONBIN_KEY,
                ["X-Bin-Meta"] = "false",
            },
        })
        if res and res.Body then
            local data = HttpService:JSONDecode(res.Body)
            if type(data) == "table" then
                stats.totalUsers = data.totalUsers or 0
                stats.seenUsers = data.seenUsers or {}
            end
        end
    end)
    return stats
end

-- ===== Save stats ke JSONBin =====
local function saveStats(stats)
    pcall(function()
        request({
            Url = "https://api.jsonbin.io/v3/b/" .. JSONBIN_ID,
            Method = "PUT",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Master-Key"] = JSONBIN_KEY,
            },
            Body = HttpService:JSONEncode({
                totalUsers = stats.totalUsers,
                seenUsers = stats.seenUsers,
            }),
        })
    end)
end

-- ===== Kirim webhook =====
local function sendWebhook(isFirstTime, activeCount, totalCount, executor, hwid)
    local player = Players.LocalPlayer
    local avatar = getAvatarURL(player.UserId)
    local now = os.time()

    local title = isFirstTime
        and "🆕 New User Executed Lych X Putra Hub!"
        or  "🔁 Returning User Executed Lych X Putra Hub!"
    local color = isFirstTime and 0x00FF88 or 0x00A2FF

    local payload = {
        username = "Lych X Putra Hub Logger",
        embeds = {{
            title = title,
            description = "**Lych X Putra Hub [ V1 ]** — Steal An Egg\nScript berhasil dijalankan.",
            color = color,
            thumbnail = { url = avatar },
            fields = {
                { name = "👤 Namalu",   value = string.format("`%s` (%s)", player.Name, player.DisplayName), inline = true },
                { name = "🆔 ID",    value = "`" .. tostring(player.UserId) .. "`", inline = true },
                { name = "⚙️ Executor",   value = "`" .. executor .. "`", inline = true },
                { name = "🔑 Hwid",       value = "`" .. string.sub(hwid, 1, 40) .. "...`", inline = false },
                { name = "🌐 Place ID",   value = "`" .. tostring(game.PlaceId) .. "`", inline = true },
                { name = "🕐 Waktu",       value = "<t:" .. now .. ":F> (<t:" .. now .. ":R>)", inline = true },
                { name = "📊 User Aktif", value = "**" .. tostring(activeCount) .. "** orang", inline = true },
                { name = "🏆 Total User",  value = "**" .. tostring(totalCount) .. "** orang", inline = true },
                { name = "🎮 Server Player", value = tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers), inline = true },
            },
            footer = {
                text = "Lych X Putra Hub • " .. executor,
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        }},
    }

    pcall(function()
        request({
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {["Content-Type"] = "application/json"},
            Body = HttpService:JSONEncode(payload),
        })
    end)
end

-- ===== MAIN: jalankan saat script load =====
task.spawn(function()
    local player = Players.LocalPlayer
    local uid = tostring(player.UserId)
    local executor = getExecutorName()
    local hwid = getHWID()

    -- Load stats global
    local stats = loadStats()

    -- Cek user pertama kali atau bukan
    local isFirstTime = not stats.seenUsers[uid]

    if isFirstTime then
        stats.totalUsers = stats.totalUsers + 1
        stats.seenUsers[uid] = os.time()
        saveStats(stats)
    else
        stats.seenUsers[uid] = os.time()
        saveStats(stats)
    end

    -- Active users = jumlah player di server (proxy sederhana)
    -- Kalau mau lebih akurat: simpan activeUsers ke bin juga, tapi resiko race condition
    local activeCount = #Players:GetPlayers()

    -- Kirim webhook
    sendWebhook(isFirstTime, activeCount, stats.totalUsers, executor, hwid)

    -- Log ke console
    print(string.format("[Lych X PutraHub Logger] User: %s | First time: %s | Total: %d",
        player.Name, tostring(isFirstTime), stats.totalUsers))
end)

local ProxyLib = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/ProxyHubDev/ProxyLib/refs/heads/main/Documents/ProxyLibrary"
))()
local Lib = ProxyLib.new()

local Window = Lib:CreateWindow({
    Title = "Lych X Putra Hub [ V1 ]",
    Subtitle = "Steal An Egg",
    Size = Vector2.new(460, 320),
    MinSize = Vector2.new(420, 320),
    MaxSize = Vector2.new(900, 620),
    Theme = Color3.fromRGB(0, 200, 255),
    TypeUI = "Modern",
    Language = "English",
    Search = true,
    AutoSave = false, AutoLoad = false,
    DefaultFps = false, DefaultPing = false, DefaultProfile = true,
    BackgroundImage = { Id = "rbxassetid://136182100085563", Active = false },
    TitleConfig = {
        Gradient = true,
        Colors = { Color3.fromRGB(80, 180, 255), Color3.fromRGB(30, 90, 255) },
        Words = {
            { Text = "Lych X Putra", Colors = { Color3.fromRGB(80, 200, 255), Color3.fromRGB(0, 120, 255) } },
            { Text = "Hub", Colors = { Color3.fromRGB(120, 220, 255), Color3.fromRGB(30, 90, 255) } },
        },
    },
    ConfigPanel = {
        Enabled = true, Acrylic = true, Theme = true, Fps = false,
        Ping = false, Profile = true, HideNotify = true, Language = true,
        BackgroundImage = true,
    },
    FloatButton = {
        Shape = "Circle", Color = "Translucent", Size = 50,
        Icon = "rbxassetid://102468802738090"
    },
    Acrylic = { Enabled = false, Opacity = 0 },
})

-- =========================================================
-- ==============  Lych X PutraHUB ORIGINAL (UNCHANGED)  ==========
-- =========================================================
local e = game:GetService("Players")
local r = game:GetService("Workspace")
local y = game:GetService("RunService")
local u = game:GetService("TweenService")
local w = game:GetService("UserInputService")
local j = game:GetService("ReplicatedStorage")
local k = game:GetService("ProximityPromptService")
local a = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local o = e.LocalPlayer
local currentLang = "EN"
local executorCheckCaller = typeof(checkcaller) == "function" and checkcaller or function() return false end
local safeNewCClosure = typeof(newcclosure) == "function" and newcclosure or function(fn) return fn end
local V = game:GetService("ProximityPromptService")
pcall(function()
    V.PromptButtonHoldBegan:Connect(function(e)
        pcall(function()
            if typeof(fireproximityprompt) == "function" then fireproximityprompt(e) end
        end)
    end)
end)
local H = function() end
local t = function() end

local s = nil
pcall(function() s = require((j:WaitForChild("Client", 5)):WaitForChild("EggState", 5)) end)
if not s then pcall(function() s = require(j.Client.EggState) end) end
local p = nil
pcall(function() p = require(((j:WaitForChild("Shared", 5)):WaitForChild("Util", 5)):WaitForChild("AssetItems", 5)) end)
if not p then pcall(function() p = require(j.Shared.Util.AssetItems) end) end
local B = nil
pcall(function() B = require((j:WaitForChild("Shared", 5)):WaitForChild("Remotes", 5)) end)
if not B then pcall(function() B = require(j.Shared.Remotes) end) end

local function J(e, r)
    local y = (j:FindFirstChild("Packages") and j.Packages:FindFirstChild("Networking")) or j:FindFirstChild("Network") or j
    local u = y:FindFirstChild(e) or j:FindFirstChild(e)
    if u then return u end
    local w = y:FindFirstChild(e, true) or j:FindFirstChild(e, true)
    if w then return w end
    if r then
        local e = y:FindFirstChild(r) or j:FindFirstChild(r)
        if e then return e end
        local u = y:FindFirstChild(r, true) or j:FindFirstChild(r, true)
        if u then return u end
    end
    local k = string.match(e, "[^/]+$")
    if k then
        local e = y:FindFirstChild(k, true) or j:FindFirstChild(k, true)
        if e then return e end
    end
    return nil
end

local K = J("RF/EggWorld/AskPlaceEgg", "AskPlaceEgg")
local c = J("RF/EggWorld/AskLiveSnapshot", "AskLiveSnapshot")
local v = J("RF/Homestead/AskState", "RF/Plots/AskState") or J("AskState")
local i = J("RF/EggWorld/AskFieldEggCarry", "AskFieldEggCarry")
local R = J("RF/EggWorld/AskFieldEggSnapshot", "AskFieldEggSnapshot") or J("Eggs: RequestAreaEggSnapshot", "RequestAreaEggSnapshot")
local g = J("RF/EggWorld/AskHatch", "AskHatch") or J("Eggs: RequestHatchEgg")
local Q = J("RF/EggWorld/AskFinishHatch", "AskFinishHatch") or J("Eggs: RequestCompleteHatchEgg")
local P = J("RE/GuardPatrol/ForestStrike", "ForestStrike") or (B and (B.GuardPatrol and B.GuardPatrol.ForestStrike))
local N = J("SpeedTollOffer", "RE/GuardPatrol/SpeedTollOffer") or (B and (B.GuardPatrol and B.GuardPatrol.SpeedTollOffer))
local U = J("RF/Treadmill/AskDoff", "AskDoff")
local l = J("RF/Treadmill/AskDon", "AskDon") or J("RF/Treadmill/AskMount", "AskMount")
local D = J("RF/Treadmill/AskTierRaise", "Treadmills: RequestUpgrade", "AskTierRaise")
local C = J("RF/Trailwear/AskPurchase", "Trailwear: RequestPurchase", "AskPurchase")
local q = J("RF/Trailwear/AskChoose", "Trailwear: RequestEquip", "AskChoose")
local n = J("RF/Trailwear/AskDoff", "Trailwear: RequestUnequip", "AskDoff")

H(string.format("[RemoteCheck] Carry:%s Snap:%s Place:%s Hatch:%s Finish:%s Strike:%s Toll:%s Doff:%s",
    tostring(i~=nil), tostring(R~=nil), tostring(K~=nil), tostring(g~=nil),
    tostring(Q~=nil), tostring(P~=nil), tostring(N~=nil), tostring(U~=nil)))

local f = { ["Light Dark"]=1300, ["LightDark"]=1300, ["Titan Temple"]=1100, ["Cherry Blossom"]=1000, ["Cosmic"]=900, ["Prehistoric"]=800, ["Abyss Ocean"]=700, ["Volcano"]=600, ["Snow"]=500, ["Jungle"]=400, ["Desert"]=300, ["Lake"]=200, ["Forest"]=100 }
local M = {"Light Dark","Titan Temple","Cherry Blossom","Cosmic","Prehistoric","Abyss Ocean","Volcano","Snow","Jungle","Desert","Lake","Forest"}
local I = { ["Light Dark"]=420, ["LightDark"]=420, ["Titan Temple"]=380, ["Cherry Blossom"]=330, ["Cosmic"]=280, ["Prehistoric"]=240, ["Abyss Ocean"]=200, ["Volcano"]=180, ["Snow"]=160, ["Jungle"]=140, ["Desert"]=130, ["Lake"]=125, ["Forest"]=125 }
local L = -360
local E = 525
local b = 620
local A = 130
local S = CFrame.new(4773.7587890625, 70.392112731934, -315.73501586914)
local Z = "Lych X PutraHub_FlightSpeed.txt"
local z = "Lych X PutraHub_EggSelectConfig.json"
local d = { ["Light Dark"]=Color3.fromRGB(168,85,247), ["Titan Temple"]=Color3.fromRGB(245,158,11), ["Cherry Blossom"]=Color3.fromRGB(236,72,153), ["Cosmic"]=Color3.fromRGB(6,182,212), ["Prehistoric"]=Color3.fromRGB(16,185,129), ["Abyss Ocean"]=Color3.fromRGB(59,130,246), ["Volcano"]=Color3.fromRGB(239,68,68), ["Snow"]=Color3.fromRGB(147,197,253), ["Jungle"]=Color3.fromRGB(34,197,94), ["Desert"]=Color3.fromRGB(234,179,8), ["Lake"]=Color3.fromRGB(20,184,166), ["Forest"]=Color3.fromRGB(22,163,74) }
local X = {"Divine","Eternal","Secret","Cosmic","Mythic","Legendary","Epic","Rare","Uncommon","Common"}
local G = { ["Divine"]=Color3.fromRGB(244,63,94), ["Eternal"]=Color3.fromRGB(217,70,239), ["Secret"]=Color3.fromRGB(249,115,22), ["Cosmic"]=Color3.fromRGB(6,182,212), ["Mythic"]=Color3.fromRGB(139,92,246), ["Legendary"]=Color3.fromRGB(251,191,36), ["Epic"]=Color3.fromRGB(168,85,247), ["Rare"]=Color3.fromRGB(59,130,246), ["Uncommon"]=Color3.fromRGB(34,197,94), ["Common"]=Color3.fromRGB(148,163,184) }
local F = { ["Divine"]=6, ["Eternal"]=5, ["Secret"]=4, ["Cosmic"]=3, ["Mythic"]=2, ["Legendary"]=1, ["Epic"]=0.5, ["Rare"]=0.3, ["Uncommon"]=0.1, ["Common"]=0 }
local h
local function O()
    local e = 600
    pcall(function()
        local r = false
        if isfile then r = isfile(Z)
        elseif readfile then local e, y = pcall(readfile, Z); r = e and (y ~= nil) end
        if r and readfile then
            local r = readfile(Z)
            local u = tonumber(r)
            if u and (u >= 100 and u <= 1000) then e = math.floor(u) end
        end
    end)
    return e
end
local function Y(e)
    pcall(function()
        if writefile then
            local y = math.clamp(math.floor(tonumber(e) or 600), 100, 1000)
            writefile(Z, tostring(y))
        end
    end)
end
local function T()
    local e = nil
    pcall(function()
        local r = false
        if isfile then r = isfile(z)
        elseif readfile then local e, y = pcall(readfile, z); r = e and (y ~= nil) end
        if r and (readfile and a) then
            local r = readfile(z)
            if r and r ~= "" then
                local u = a:JSONDecode(r)
                if type(u) == "table" then e = u end
            end
        end
    end)
    local r = { ["Light Dark"]=true, ["Titan Temple"]=true, ["Cherry Blossom"]=true, ["Cosmic"]=false, ["Prehistoric"]=false, ["Abyss Ocean"]=false, ["Volcano"]=false, ["Snow"]=false, ["Jungle"]=false, ["Desert"]=false, ["Lake"]=false, ["Forest"]=false }
    local y = { ["Divine"]=true, ["Eternal"]=true, ["Secret"]=true, ["Cosmic"]=true, ["Mythic"]=true, ["Legendary"]=true, ["Epic"]=true, ["Rare"]=true, ["Uncommon"]=true, ["Common"]=true }
    if type(e) ~= "table" then
        e = { ["selectedZones"]=r, ["selectedRarities"]=y, ["alwaysCollectSecretPlus"]=false, ["minRarityTier"]=2, ["autoTreadmill"]=false, ["autoUpgradeTreadmill"]=false, ["autoBuyTrails"]=false, ["hideNotEnoughMoney"]=true, ["performanceMode"]=false, ["disable3D"]=false, ["antiAFK"]=false, ["language"]="EN" }
    else
        if type(e.selectedZones) ~= "table" then e.selectedZones = r end
        if type(e.selectedRarities) ~= "table" then e.selectedRarities = y
        else
            for r, w in ipairs(X) do
                if e.selectedRarities[w] == nil then e.selectedRarities[w] = (y[w] == true) end
            end
        end
        if e.alwaysCollectSecretPlus == nil then e.alwaysCollectSecretPlus = true end
        if e.minRarityTier == nil then e.minRarityTier = 2 end
        if e.autoTreadmill == nil then e.autoTreadmill = true end
        if e.autoUpgradeTreadmill == nil then e.autoUpgradeTreadmill = true end
        if e.autoBuyTrails == nil then e.autoBuyTrails = true end
        if e.hideNotEnoughMoney == nil then e.hideNotEnoughMoney = true end
        if e.performanceMode == nil then e.performanceMode = false end
        if e.disable3D == nil then e.disable3D = false end
        if e.antiAFK == nil then e.antiAFK = false end
        if e.language and ((e.language == "EN" or e.language == "TH")) then currentLang = e.language end
    end
    return e
end
local function x()
    pcall(function()
        if writefile and (a and h) then
            local r = { ["selectedZones"]=h.selectedZones or {}, ["selectedRarities"]=h.selectedRarities or {}, ["alwaysCollectSecretPlus"]=(h.alwaysCollectSecretPlus ~= false), ["minRarityTier"]=h.minRarityTier or 2, ["autoTreadmill"]=(h.autoTreadmill == true), ["autoUpgradeTreadmill"]=(h.autoUpgradeTreadmill == true), ["autoBuyTrails"]=(h.autoBuyTrails == true), ["hideNotEnoughMoney"]=(h.hideNotEnoughMoney == true), ["performanceMode"]=(h.performanceMode == true), ["disable3D"]=(h.disable3D == true), ["antiAFK"]=(h.antiAFK == false), ["language"]=currentLang or "EN" }
            local y = a:JSONEncode(r)
            writefile(z, y)
        end
    end)
end
local W = T()
h = { 
    ["godmode"]=true, ["autoGlide"]=true, ["autoHatch"]=false, ["autoPlaceEvery5"]=false, 
    ["batchStealCount"]=0, ["isBatchPlacing"]=false, ["isHatching"]=false, ["autoFarmLoop"]=false, 
    ["pureTweenFarm"]=false, ["glidingToTarget"]=false, ["securingEgg"]=false, ["glideSpeed"]=O(), 
    ["selectedZones"]=W.selectedZones, ["selectedRarities"]=W.selectedRarities, 
    ["alwaysCollectSecretPlus"]=W.alwaysCollectSecretPlus, ["minRarityTier"]=W.minRarityTier, 
    ["autoTreadmill"]=false, ["autoUpgradeTreadmill"]=false, ["autoBuyTrails"]=false, 
    ["hideNotEnoughMoney"]=false, ["performanceMode"]=false, ["disable3D"]=false, ["antiAFK"]=false, 
    ["onTreadmill"]=false, ["lastTreadmillMount"]=0, ["laneZ"]=-360, ["swapped"]=false, 
    ["teleporting"]=false, ["isReturning"]=false, ["delivering"]=false, ["holdingEggForGuard"]=false, 
    ["currentTargetModel"]=nil, ["targetPosition"]=nil, ["stateTime"]=os.clock(), ["statusText"]="Ready", 
    ["bestEggInfo"]="Scanning...", ["gui"]=nil, ["alive"]=true, ["plot"]=nil, ["pen"]=nil, 
    ["origin"]=nil, ["tread"]=nil, ["autoKillScramble"]=false, ["scrambleTarget"]=nil, 
    ["scrambleUID"]=nil, ["isAttackingScramble"]=false, ["scrambleFlyLock"]=false, 
    ["scrambleZoneIdx"]=1, ["scrambleHits"]={}, ["scrambleMaxHP"]={},
    ["scrambleHpFilter"] = { ["3"] = true, ["5"] = true, ["6"] = true, ["10"] = true },
    -- ✅ NEW FLAGS untuk fitur baru
    ["autoStealBigSize"] = false,
    ["stealAutoTreadmill"] = false,
}

-- =========================================================
-- ✅ SCHEDULED PAUSE (HANYA AUTO STEAL + KILL SCRAMBLE + BIG SIZE)
--    Stop saat menit berakhiran 4 & detik >= 13
--    Resume saat menit berganti ke 5
-- =========================================================
h.scheduledPause = false
h.pauseReason = nil
h._pausedFarmMode = "NONE"  -- "TWEEN" / "WARP" / "NONE"
h._pausedScramble = false
h._pausedBigSize = false
h._pausedToggles = {
    tween = false,
    warp = false,
    scramble = false,
    bigSize = false,
}

local function timeToString()
    local t = os.date("*t")
    return string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
end

-- ✅ Cek apakah sekarang waktunya pause (menit berakhiran 4 & detik >= 13)
local function shouldPauseNow()
    local t = os.date("*t")
    local isPauseMinute = (t.min % 10 == 4)  -- 04, 14, 24, 34, 44, 54
    return isPauseMinute and (t.sec >= 13)
end

-- ✅ Cek apakah sudah waktunya resume (menit berakhiran 5)
local function shouldResumeNow()
    local t = os.date("*t")
    return (t.min % 10 == 5)  -- 05, 15, 25, 35, 45, 55
end

-- ✅ Pause: Auto Steal + Scramble + Big Size
local function pauseStealAndScramble()
    if h.scheduledPause then return end
    h.scheduledPause = true
    h.pauseReason = "Pause @ " .. timeToString()

    print(string.format("[ScheduledPause] ⏸️ PAUSE @ %s — Stop Auto Steal + Scramble + Big Size", timeToString()))

    -- Simpan state toggle (untuk UI sync)
    h._pausedToggles.tween     = h.pureTweenFarm
    h._pausedToggles.warp      = h.autoFarmLoop
    h._pausedToggles.scramble  = h.autoKillScramble
    h._pausedToggles.bigSize   = h.autoStealBigSize
    h._pausedFarmMode          = Y4  -- "TWEEN" / "WARP" / "NONE"
    h._pausedScramble          = h.autoKillScramble
    h._pausedBigSize           = h.autoStealBigSize

    -- ✅ Stop farm mode (Tween & Warp) via T4
    Y4 = "NONE"
    h.pureTweenFarm = false
    h.autoFarmLoop = false

    -- ✅ Stop scramble
    h.autoKillScramble = false
    h.scrambleTarget = nil
    h.scrambleUID = nil
    h.scrambleFlyLock = false
    h.scrambleHits = {}
    h.scrambleMaxHP = {}

    -- ✅ Stop big size
    h.autoStealBigSize = false

    -- ✅ Cancel aktivitas steal yang sedang berjalan
    h.teleporting = false
    h.glidingToTarget = false
    h.securingEgg = false
    h.isReturning = false
    h.delivering = false
    h.holdingEggForGuard = false
    -- ⚠️ JANGAN cancel isBatchPlacing, onTreadmill, isHatching — biar fitur lain tetap jalan

    h.statusText = "⏸️ PAUSE (Steal + Scramble + BigSize) — Tunggu menit berganti..."
end

-- ✅ Resume: Auto Steal + Scramble + Big Size
local function resumeStealAndScramble()
    if not h.scheduledPause then return end

    print(string.format("[ScheduledPause] ▶️ RESUME @ %s — Restore Auto Steal + Scramble + Big Size", timeToString()))

    h.scheduledPause = false
    h.pauseReason = nil

    -- ✅ Restore scramble
    h.autoKillScramble = h._pausedScramble or false

    -- ✅ Restore big size
    h.autoStealBigSize = h._pausedBigSize or false

    -- ✅ Restore farm mode (TWEEN / WARP) via T4
    local prevMode = h._pausedFarmMode
    if prevMode == "TWEEN" or prevMode == "WARP" then
        pcall(function() if T4 then T4(prevMode) end end)
    end

    h._pausedFarmMode = "NONE"
    h._pausedScramble = false
    h._pausedBigSize = false
    h._pausedToggles = { tween = false, warp = false, scramble = false, bigSize = false }

    h.statusText = "▶️ RESUMED — Fitur kembali aktif"
end

-- ✅ Watcher loop: cek waktu tiap 0.5 detik
task.spawn(function()
    while h.alive do
        pcall(function()
            if not h.scheduledPause then
                if shouldPauseNow() then
                    pauseStealAndScramble()
                end
            else
                if shouldResumeNow() then
                    resumeStealAndScramble()
                end
            end
        end)
        task.wait(0.5)
    end
end)

-- =========================================================
-- ✅ CAPTURE ORIGINAL HUMANOID VALUES (anti-flag WalkSpeed)
-- =========================================================
h._origWalkSpeed = nil
h._origJumpPower = nil
h._origJumpHeight = nil
h._origUseJumpPower = nil

local function captureOriginalHumanoid(char)
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if h._origWalkSpeed == nil then
        h._origWalkSpeed = hum.WalkSpeed
        h._origJumpPower = hum.JumpPower
        h._origJumpHeight = hum.JumpHeight
        h._origUseJumpPower = hum.UseJumpPower
    end
end

local function releaseRigidWelds(char)
    char = char or o.Character
    if not char then return end
    for _, dd in ipairs(char:GetDescendants()) do
        if dd:IsA("WeldConstraint") and dd.Name:sub(1, 15) == "RigidJointWeld_" then
            pcall(function() dd:Destroy() end)
        end
    end
end

local function restoreNormalHumanoid(char)
    char = char or o.Character
    if not char then return end
    pcall(releaseRigidWelds, char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    pcall(function()
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        hum.AutoRotate = true
        if hum.Health > 0 then
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    if h._origWalkSpeed ~= nil then
        pcall(function() hum.WalkSpeed = h._origWalkSpeed end)
    end
    if h._origUseJumpPower ~= nil then
        pcall(function() hum.UseJumpPower = h._origUseJumpPower end)
    end
    if h._origUseJumpPower and h._origJumpPower ~= nil then
        pcall(function() hum.JumpPower = h._origJumpPower end)
    elseif h._origJumpHeight ~= nil then
        pcall(function() hum.JumpHeight = h._origJumpHeight end)
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        pcall(function() hrp.Anchored = false end)
    end
end

captureOriginalHumanoid(o.Character)

local m, e4, r4, y4, u4, w4, j4, k4, a4, o4, V4, H4, t4, s4, p4, B4, J4, K4, c4, v4, i4, R4, g4, Q4, P4, N4, U4, l4, D4, C4, q4, n4, f4, M4, I4, L4, E4, b4, A4, S4, Z4, z4, d4
local X4 = {}
local G4 = 0
local F4 = nil
local h4
local O4 = 0
local Y4 = "NONE"
local T4
local x4 = nil
local W4 = nil

pcall(function()
    local e = game:GetService("Lighting")
    e:GetPropertyChangedSignal("ClockTime"):Connect(function() X4 = {}; G4 = 0 end)
end)
pcall(function()
    local function e(e)
        if e:IsA("RemoteEvent") then
            local y = string.lower(e.Name)
            if string.find(y, "reset") or string.find(y, "night") or string.find(y, "spawn") or string.find(y, "countdown") then
                pcall(function()
                    e.OnClientEvent:Connect(function() X4 = {}; G4 = 0 end)
                end)
            end
        end
    end
    for y, u in ipairs(j:GetDescendants()) do e(u) end
    j.DescendantAdded:Connect(e)
end)

m = function(e)
    if not e or not e:IsA("Tool") then return false end
    local r = string.lower(e.Name)
    if string.find(r, "sword") or string.find(r, "radar") or string.find(r, "basket") or string.find(r, "punch") then return false end
    if e:GetAttribute("EggUid") or e:GetAttribute("UID") or string.find(r, "egg") or e:GetAttribute("Category") or e:GetAttribute("ItemType") == "Egg" then return true end
    return false
end
e4 = function()
    local e = o.Character
    if e then
        for e, y in ipairs(e:GetChildren()) do
            if m(y) then
                local e = y:GetAttribute("UID") or y:GetAttribute("EggUid")
                return y, e or y.Name
            end
        end
    end
    return nil, nil
end
r4 = function()
    local e = o:FindFirstChild("Backpack")
    if e then
        for e, y in ipairs(e:GetChildren()) do
            if m(y) then
                local e = y:GetAttribute("UID") or y:GetAttribute("EggUid")
                return y, e or y.Name
            end
        end
    end
    return nil, nil
end
y4 = function()
    local e = 0
    local r = o:FindFirstChild("Backpack")
    if r then for r, y in ipairs(r:GetChildren()) do if m(y) then e = e + 1 end end end
    local y = o.Character
    if y then for r, y in ipairs(y:GetChildren()) do if m(y) then e = e + 1 end end end
    return e
end
u4 = function(e)
    if not e and not ((h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.stealAutoTreadmill or h.autoStealBigSize)) then return end
    local r = o.Character
    local y = r and r:FindFirstChildOfClass("Humanoid")
    local u = o:FindFirstChild("Backpack")
    if y then pcall(function() y:UnequipTools() end) end
    if r and u then
        for e, r in ipairs(r:GetChildren()) do
            if r:IsA("Tool") then pcall(function() r.Parent = u end) end
        end
    end
end
w4 = function(e)
    if ((h.pureTweenFarm or h.autoFarmLoop or h.stealAutoTreadmill or h.autoStealBigSize)) and not h.holdingEggForGuard then
        local e = e4()
        if e then pcall(u4) end
        return false
    end
    local r, y = e4()
    if r then
        if e then if y == e or not y then return true end
        else return true end
    end
    local u = o.Character
    local w = u and u:FindFirstChild("HumanoidRootPart")
    if w and w.Position.X <= (E + 15) then return false end
    if s and s.ReadFieldEggs then
        local r, y = pcall(s.ReadFieldEggs)
        if r and (y and y.Records) then
            for r, y in ipairs(y.Records) do
                if ((y.State == "Carried" or y.State == 2)) and ((y.CarrierUserId == o.UserId or y.Carrier == o.UserId)) then
                    if e then if y.Uid == e then return true end
                    else return true end
                end
            end
        end
    end
    return false
end
j4 = function(e)
    local r, y = e4()
    if r then if not e or y == e or not y then return true end end
    local u = o:FindFirstChild("Backpack")
    if u then
        for r, y in ipairs(u:GetChildren()) do
            if m(y) then
                local r = y:GetAttribute("UID") or y:GetAttribute("EggUid")
                if not e or r == e or y.Name == tostring(e) then return true end
            end
        end
    end
    if e and (s and s.ReadFieldEggs) then
        local r, y = pcall(s.ReadFieldEggs)
        if r and (y and y.Records) then
            for r, y in ipairs(y.Records) do
                if y.Uid == e then
                    if (y.State == "Carried" or y.State == 2) then
                        local e = y.CarrierUserId or y.Carrier
                        if e == o.UserId then return true end
                    end
                end
            end
        end
    end
    return false
end
local m4 = false
local function ek()
    if m4 then return end
    local e = R or j:FindFirstChild("RF/EggWorld/AskFieldEggSnapshot", true) or j:FindFirstChild("AskFieldEggSnapshot", true) or j:FindFirstChild("Eggs: RequestAreaEggSnapshot", true)
    if not e or not e:IsA("RemoteFunction") then return end
    m4 = true
    task.spawn(function()
        local r, y = pcall(function() return e:InvokeServer() end)
        if r and type(y) == "table" then
            local e = {}
            local r = y.Records or y
            if type(r) == "table" then
                for r, y in pairs(r) do
                    if type(y) == "table" then
                        if not y.Uid and type(r) == "string" then y.Uid = r end
                        table.insert(e, y)
                    end
                end
            end
            if #e > 0 then F4 = e; G4 = os.clock() end
        end
        m4 = false
    end)
end
task.spawn(function()
    while true do task.wait(1.5); pcall(ek) end
end)

h4 = function(e)
    local y = os.clock()
    if e or (y - G4 >= 1.5) or not F4 then ek() end
    local u = ((F4 and #F4 > 0)) and F4 or nil
    local w = nil
    if s and s.ReadFieldEggs then
        local e, r = pcall(s.ReadFieldEggs)
        if e and type(r) == "table" then
            local e = {}
            local y = r.Records or r
            if type(y) == "table" then
                for r, y in pairs(y) do
                    if type(y) == "table" then
                        if not y.Uid and type(r) == "string" then y.Uid = r end
                        table.insert(e, y)
                    end
                end
            end
            if #e > 0 then w = e end
        end
    end
    local j = {}
    local k = {}
    if u then
        for e, r in ipairs(u) do
            if r.Uid then k[r.Uid] = true; table.insert(j, r) end
        end
    end
    if w then
        for e, r in ipairs(w) do
            if r.Uid and not k[r.Uid] then k[r.Uid] = true; table.insert(j, r) end
        end
    end
    local a = r:FindFirstChild("AreaEggSlotsClient")
    if a then
        for e, r in ipairs(a:GetChildren()) do
            local y = r.Name
            if y and y ~= "" then
                local e = r:GetPivot()
                local u = e.Position
                if u.X >= 530 and not string.find(tostring(y), "FirstArea") then
                    if not k[y] then
                        k[y] = true
                        local u = r:GetAttribute("Category") or r:GetAttribute("AssetCategory") or r.Name
                        local w = r:GetAttribute("AreaId") or r:GetAttribute("Area")
                        local a = r:GetAttribute("Rarity") or r:GetAttribute("RarityTier")
                        local V = r:GetAttribute("RarityRank") or r:GetAttribute("Rank")
                        local H = r:GetAttribute("Income") or r:GetAttribute("EarningRate")
                        local t = r:GetAttribute("Scale") or r:GetAttribute("AssetScale") or 1
                        local s = r:GetAttribute("Mutations") or r:GetAttribute("Mutation")
                        table.insert(j, { ["Uid"]=y, ["AssetCategory"]=u, ["AreaId"]=w, ["Rarity"]=a, ["Rank"]=V, ["Income"]=H, ["BoundsCFrame"]=e, ["BottomCFrame"]=e, ["CFrame"]=e, ["State"]="Slot", ["AssetScale"]=t, ["Mutations"]=s, ["PhysicalModel"]=r })
                    else
                        for u, w in ipairs(j) do
                            if w.Uid == y then
                                w.PhysicalModel = r
                                if not w.BoundsCFrame then w.BoundsCFrame = e end
                                if not w.AreaId or w.AreaId == "" or w.AreaId == "Unknown" then w.AreaId = r:GetAttribute("AreaId") or r:GetAttribute("Area") end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
    return j
end

k4 = function(e)
    if not e then return false, "NoUid" end
    local y = h4(false)
    if y and #y > 0 then
        for r, y in ipairs(y) do
            if y.Uid == e then
                if (y.State == "Carried" or y.State == 2) then
                    local e = y.CarrierUserId or y.Carrier
                    if e and e == o.UserId then return true, "CarriedBySelf"
                    else return false, "CarriedByOther" end
                end
                if (y.State == "Slot" or y.State == "Dropped" or y.State == "GuardCarried" or y.State == 1) then return true, "Available" end
                local e = y.CarrierUserId or y.Carrier
                if e then
                    if e == o.UserId then return true, "CarriedBySelf"
                    else return false, "CarriedByOther" end
                end
                return true, "Available"
            end
        end
    end
    local u = r:FindFirstChild("AreaEggSlotsClient")
    if u then
        for r, y in ipairs(u:GetChildren()) do
            if y.Name == tostring(e) or y:GetAttribute("UID") == e or y:GetAttribute("Uid") == e then return true, "Available" end
        end
        return true, "Unchecked"
    end
end

a4 = function()
    local e, r = e4()
    if not r then local e, y = r4(); r = y end
    if not r then return false end
    if s and s.ReadFieldEggs then
        local e, u = pcall(s.ReadFieldEggs)
        if e and (u and u.Records) then
            for e, u in ipairs(u.Records) do
                if u.Uid == r then
                    local e = tostring(u.AreaId or "")
                    if e == "Lake" or string.find(string.lower(e), "lake") ~= nil then return true end
                end
            end
        end
    end
    if string.find(string.lower(tostring(r)), "lake") ~= nil then return true end
    return false
end

o4 = function()
    local e, r = e4()
    if not r then local e, y = r4(); r = y end
    if not r then return h.glideSpeed or 350 end
    if s and s.ReadFieldEggs then
        local e, u = pcall(s.ReadFieldEggs)
        if e and (u and u.Records) then
            for e, u in ipairs(u.Records) do
                if u.Uid == r and u.AreaId then return I[u.AreaId] or h.glideSpeed or 350 end
            end
        end
    end
    return h.glideSpeed or 350
end

V4 = function(e, y)
    y = y or 8
    local u = Instance.new("Part")
    u.Name = "SafetyFloorPad_AntiVoid"
    u.Size = Vector3.new(28, 1.5, 28)
    u.Position = e - Vector3.new(0, 3.2, 0)
    u.Anchored = true
    u.Transparency = 1
    u.CanCollide = true
    u.Parent = r
    task.delay(y, function() pcall(function() u:Destroy() end) end)
    return u
end

H4 = function(e)
    if P and e then
        pcall(function()
            local r = o.Character
            local y = r and r:FindFirstChild("HumanoidRootPart")
            local u = y and (y.CFrame * CFrame.new(0, 0, -3)) or CFrame.new()
            if P:IsA("RemoteFunction") then
                P:InvokeServer({ ["EggUid"]=e, ["GuardCFrame"]=u })
            else
                P:FireServer({ ["EggUid"]=e, ["GuardCFrame"]=u })
            end
        end)
    end
end

if typeof(hookmetamethod) == "function" and not _G._DesyncAntiRagdollHooked then
    _G._DesyncAntiRagdollHooked = true
    local oldIdx
    oldIdx = hookmetamethod(game, "__newindex", safeNewCClosure(function(r, y2, u2)
        if not executorCheckCaller() and typeof(r) == "Instance" then
            local farmActive = h and (
                h.pureTweenFarm or h.autoFarmLoop or h.teleporting or
                h.glidingToTarget or h.isReturning or h.securingEgg or
                h.delivering or h.holdingEggForGuard or h.onTreadmill or
                h.stealAutoTreadmill or h.autoStealBigSize
            )
            if farmActive then
                if r:IsA("Motor6D") and (y2 == "Enabled" and u2 == false) then return nil end
                if r:IsA("Humanoid") then
                    if y2 == "PlatformStand" and u2 == true then return nil end
                    if y2 == "Sit" and u2 == true then return nil end
                end
            end
        end
        return oldIdx(r, y2, u2)
    end))
end

S4 = function(e)
    e = e or o.Character
    if not e then return end
    local r = e:FindFirstChild("HumanoidRootPart")
    local y = e:FindFirstChild("Torso") or e:FindFirstChild("UpperTorso") or r
    if not y then return end

    local farmActive = h and (
        h.pureTweenFarm or h.autoFarmLoop or h.teleporting or
        h.glidingToTarget or h.isReturning or h.securingEgg or
        h.delivering or h.holdingEggForGuard or h.onTreadmill or
        h.autoKillScramble or h.stealAutoTreadmill or h.autoStealBigSize
    )

    if farmActive then
        for _, inst in ipairs(e:GetDescendants()) do
            if inst:IsA("BallSocketConstraint")
               or inst:IsA("HingeConstraint")
               or inst:IsA("NoCollisionConstraint") then
                pcall(function() inst:Destroy() end)
            end
        end
    end

    for _, m2 in ipairs(e:GetDescendants()) do
        if m2:IsA("Motor6D") and m2.Part0 and m2.Part1 then
            if farmActive then
                m2.Enabled = true
                local weldName = "RigidJointWeld_" .. m2.Name
                local existing = m2.Part1:FindFirstChild(weldName)
                if not existing then
                    local weld = Instance.new("WeldConstraint")
                    weld.Name = weldName
                    weld.Part0 = m2.Part0
                    weld.Part1 = m2.Part1
                    weld.Parent = m2.Part1
                end
            else
                m2.Enabled = true
                local weldName = "RigidJointWeld_" .. m2.Name
                local existing = m2.Part1:FindFirstChild(weldName)
                if existing then
                    pcall(function() existing:Destroy() end)
                end
            end
        end
    end

    if not farmActive then
        releaseRigidWelds(e)
    end
end

Z4 = function(e)
    if h and h.onTreadmill then return end
    e = e or o.Character
    if not e then return end

    local farmActive = h and (
        h.pureTweenFarm or h.autoFarmLoop or h.teleporting or
        h.glidingToTarget or h.isReturning or h.securingEgg or
        h.delivering or h.holdingEggForGuard
    )

    local r = e:FindFirstChildOfClass("Humanoid")
    if r then
        if farmActive then
            pcall(function()
                r:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                r:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                r:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                r:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, false)
                r:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
                if r.PlatformStand then r.PlatformStand = false end
                if r.Sit then r.Sit = false end
            end)
        else
            pcall(function()
                r:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                r:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                r:SetStateEnabled(Enum.HumanoidStateType.Physics, true)
                r:SetStateEnabled(Enum.HumanoidStateType.PlatformStanding, true)
                r:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
                r:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
                r:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                r:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            end)
        end
    end

    if farmActive then
        for _, r2 in ipairs(e:GetDescendants()) do
            if r2:IsA("LocalScript") and (string.find(string.lower(r2.Name), "ragdoll") or string.find(string.lower(r2.Name), "fall")) then
                r2.Disabled = true
            end
        end
    end

    S4(e)
end

z4 = function(e)
    if not e then return end
    Z4(e)
    for e, y in ipairs(e:GetDescendants()) do
        if y:IsA("Motor6D") then
            (y:GetPropertyChangedSignal("Enabled")):Connect(function()
                local farmActive = h and (h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or h.isReturning or h.securingEgg or h.delivering or h.holdingEggForGuard)
                if not y.Enabled and farmActive then y.Enabled = true end
            end)
        end
    end
    e.DescendantAdded:Connect(function(y)
        if y:IsA("BallSocketConstraint") or y:IsA("HingeConstraint") or y:IsA("NoCollisionConstraint") then
            task.defer(function()
                local farmActive = h and (h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or h.isReturning or h.securingEgg or h.delivering or h.holdingEggForGuard)
                if farmActive then
                    pcall(function() y:Destroy() end)
                    Z4(e)
                end
            end)
        elseif y:IsA("LocalScript") and (string.find(string.lower(y.Name), "ragdoll") or string.find(string.lower(y.Name), "fall")) then
            local farmActive = h and (h.pureTweenFarm or h.autoFarmLoop or h.teleporting or h.glidingToTarget or h.isReturning or h.securingEgg or h.delivering or h.holdingEggForGuard)
            if farmActive then y.Disabled = true end
        end
    end)
    e.ChildAdded:Connect(function(e2)
        if e2:IsA("Tool") and (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
            task.defer(function() u4() end)
        end
    end)
end

C4 = function()
    if h then h.onTreadmill = false end
    local e = o.Character
    local r = e and e:FindFirstChildOfClass("Humanoid")
    local y = e and e:FindFirstChild("HumanoidRootPart")
    if U then task.spawn(function() pcall(function() U:InvokeServer() end) end) end
    if r then
        pcall(function()
            for r, y in ipairs(r:GetPlayingAnimationTracks()) do
                local u = y.Animation
                local w = u and u.AnimationId or ""
                if string.find(w, "10921259953") or string.find(string.lower(y.Name), "treadmill") or string.find(string.lower(y.Name), "run") then
                    y:Stop(0)
                end
            end
            r.PlatformStand = false; r.Sit = false
            r:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            r:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            r:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local u = o:FindFirstChild("PlayerGui")
    if u then
        local e = u:FindFirstChild("SpeedGainAnimation")
        if e then pcall(function() e:Destroy() end) end
    end
    if y then y.AssemblyLinearVelocity = Vector3.zero; y.AssemblyAngularVelocity = Vector3.zero end
    Z4(e)
end

local rk = 0
local yk = false
E4 = function()
    local e = o:FindFirstChild("PlayerGui")
    if not e then return false end
    local r = false
    pcall(function()
        for e, u in ipairs(e:GetChildren()) do
            if u:IsA("ScreenGui") and u.Enabled then
                for e, u in ipairs(u:GetDescendants()) do
                    if ((u:IsA("TextButton") or u:IsA("ImageButton"))) and u.Visible then
                        local e = (u:IsA("TextButton") and u.Text) or u.Name
                        local w = string.lower(e or "")
                        if string.find(w, "get out") or string.find(w, "treadmill") or string.find(w, "doff") or string.find(w, "leave") or string.find(w, "exit") then
                            if typeof(firesignal) == "function" and u.Activated then pcall(firesignal, u.Activated)
                            elseif typeof(firesignal) == "function" and u.MouseButton1Click then pcall(firesignal, u.MouseButton1Click)
                            elseif typeof(getconnections) == "function" then
                                local e = getconnections(u.MouseButton1Click) or getconnections(u.Activated) or {}
                                for e, r in ipairs(e) do pcall(function() r:Fire() end); break end
                            end
                        end
                        r = true; break
                    end
                end
            end
            if r then break end
        end
    end)
    return r
end

L4 = function()
    local e = o.Character
    local r = e and e:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    local y = (typeof(I4) == "function") and I4() or nil
    if y then
        local e = y.Position + Vector3.new(0, 1.8, 0)
        local u = ((r.Position - e)).Magnitude
        if u > 6 then
            if h then h.onTreadmill = false end
            return false
        end
    else
        if r.Position.X > 535 then
            if h then h.onTreadmill = false end
            return false
        end
    end
    if h and h.onTreadmill then return true end
    local u = e and e:FindFirstChildOfClass("Humanoid")
    if u then
        for e, r in ipairs(u:GetPlayingAnimationTracks()) do
            local y = r.Animation
            local u = y and y.AnimationId or ""
            local w = string.lower(r.Name or "")
            if string.find(u, "10921259953") or string.find(w, "treadmill") or string.find(w, "run") then return true end
        end
    end
    local w = o:FindFirstChild("PlayerGui")
    if w and w:FindFirstChild("SpeedGainAnimation") then return true end
    return false
end

M4 = function()
    if yk then return end
    if os.clock() - rk < 0.8 then
        if h then h.onTreadmill = false end
        return
    end
    yk = true; rk = os.clock()
    if h then h.onTreadmill = false end
    E4()
    if U then pcall(function() U:InvokeServer() end) end
    local e = o.Character
    local r = e and e:FindFirstChildOfClass("Humanoid")
    local y = e and e:FindFirstChild("HumanoidRootPart")
    if r then
        pcall(function()
            for r, y in ipairs(r:GetPlayingAnimationTracks()) do
                local u = y.Animation
                local w = u and u.AnimationId or ""
                local j = string.lower(y.Name or "")
                if string.find(w, "10921259953") or string.find(j, "treadmill") or string.find(j, "run") then
                    y:Stop(0)
                end
            end
            r.PlatformStand = false; r.Sit = false
            r:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            r:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            r:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    local u = o:FindFirstChild("PlayerGui")
    if u then
        local e = u:FindFirstChild("SpeedGainAnimation")
        if e then pcall(function() e:Destroy() end) end
    end
    if y then y.AssemblyLinearVelocity = Vector3.zero; y.AssemblyAngularVelocity = Vector3.zero end
    Z4(e)
    task.wait(0.15)
    yk = false
end

q4 = M4

n4 = function()
    pcall(function()
        local e = r:FindFirstChild("Plots")
        if e then
            local r = h and h.plot
            if not r and t4 then r = select(1, t4()) end
            for e, u in ipairs(e:GetChildren()) do
                local w = (r ~= nil and u == r)
                local j = u:FindFirstChild("TreadmillBottom")
                if j and j:IsA("BasePart") then
                    if w and (h and h.autoTreadmill) then j.CanTouch = true; j.CanCollide = true
                    else j.CanTouch = false; j.CanCollide = false end
                end
                local k = u:FindFirstChild("TreadmillUpgrade")
                if k then
                    for e, r in ipairs(k:GetDescendants()) do
                        if r:IsA("BasePart") then
                            if w and (h and h.autoTreadmill) then r.CanTouch = true
                            else r.CanTouch = false; r.CanCollide = false end
                        end
                    end
                end
            end
        end
    end)
end
n4()
r.DescendantAdded:Connect(function(e)
    pcall(function()
        local r = (e.Name == "TreadmillBottom" and e:IsA("BasePart"))
        local y = (e.Name == "TreadmillUpgrade" and e:IsA("Model"))
        if r or y then
            local y = h and h.plot
            if not y and t4 then y = select(1, t4()) end
            local w = y and e:IsDescendantOf(y)
            if w and (h and h.autoTreadmill) then
                if r then e.CanTouch = true; e.CanCollide = true
                else for e, r in ipairs(e:GetDescendants()) do if r:IsA("BasePart") then r.CanTouch = true end end end
            else
                if r then e.CanTouch = false; e.CanCollide = false
                else for e, r in ipairs(e:GetDescendants()) do if r:IsA("BasePart") then r.CanTouch = false; r.CanCollide = false end end end
            end
        end
    end)
end)

D4 = function()
    h.onTreadmill = false; h.teleporting = false; h.glidingToTarget = false
    h.securingEgg = false; h.isReturning = false; h.delivering = false
    h.holdingEggForGuard = false; h.currentTargetModel = nil; h.targetPosition = nil
    h.stateTime = os.clock()
    local e = o.Character
    local r = e and e:FindFirstChild("HumanoidRootPart")
    if r then pcall(function() r.Anchored = false; r.AssemblyLinearVelocity = Vector3.zero; r.AssemblyAngularVelocity = Vector3.zero end) end
    pcall(function() if C4 then C4() end end)
    pcall(function() if Z4 and e then Z4(e) end end)
    pcall(function() if u4 and ((h.pureTweenFarm or h.autoFarmLoop)) then u4() end end)
end

d4 = function(e, y)
    if e then
        for e, r in ipairs(e:GetDescendants()) do
            if r:IsA("ProximityPrompt") then
                pcall(function()
                    r.RequiresLineOfSight = false; r.HoldDuration = 0
                    if typeof(fireproximityprompt) == "function" then
                        fireproximityprompt(r, 0); fireproximityprompt(r)
                    end
                end)
            end
        end
    end
    local u = r:FindFirstChild("AreaEggSlotsClient")
    if u and y then
        for e, r in ipairs(u:GetChildren()) do
            local u = r:FindFirstChildWhichIsA("BasePart") or r.PrimaryPart
            if u and ((u.Position - y)).Magnitude <= 18 then
                for e, r in ipairs(r:GetDescendants()) do
                    if r:IsA("ProximityPrompt") then
                        pcall(function()
                            r.RequiresLineOfSight = false; r.HoldDuration = 0
                            if typeof(fireproximityprompt) == "function" then
                                fireproximityprompt(r, 0); fireproximityprompt(r)
                            end
                        end)
                    end
                end
            end
        end
    end
end

b4 = function(e)
    h.godmode = e
    local r = o.Character
    if not r then return end
    local y = r:FindFirstChildOfClass("Humanoid")
    if y then
        y:SetStateEnabled(Enum.HumanoidStateType.Dead, not e)
        if e and y.Health < 100 then y.Health = 100 end
    end
    for r, y in ipairs(r:GetDescendants()) do
        if y:IsA("BasePart") then
            if e then y.CanTouch = false; y.CanCollide = false end
        end
    end
    if e then Z4(r) end
end

local function enableDesyncGodmode() b4(true) end
local function disableDesyncGodmode() 
    b4(false)
    pcall(restoreNormalHumanoid)
end

A4 = function()
    local e = o.Character
    local y = e and e:FindFirstChildOfClass("Humanoid")
    if not e or not y then return false end
    pcall(function()
        y.BreakJointsOnDeath = false
        local w = y:Clone(); w.Parent = e; y:Destroy()
        local j = w:FindFirstChildOfClass("Animator")
        if not j then j = Instance.new("Animator"); j.Parent = w end
        r.CurrentCamera.CameraSubject = w
        local k = e:FindFirstChild("Animate")
        if k and k:IsA("LocalScript") then
            k.Disabled = true
            task.defer(function() task.wait(0.05); k.Disabled = false end)
        end
        w:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
        w:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
        w:SetStateEnabled(Enum.HumanoidStateType.Running, true)
        w:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
        if h._origJumpPower ~= nil and h._origUseJumpPower then
            w.UseJumpPower = true
            w.JumpPower = h._origJumpPower
        elseif h._origJumpHeight ~= nil then
            w.UseJumpPower = false
            w.JumpHeight = h._origJumpHeight
        else
            w.JumpPower = math.max(50, w.JumpPower)
            w.JumpHeight = math.max(7.2, w.JumpHeight)
        end
        w:ChangeState(Enum.HumanoidStateType.Running)
    end)
    h.swapped = true
    if h.godmode then b4(true) end
    z4(e)
    return true
end

t4 = function()
    if h.plot and (h.plot.Parent and (h.pen and (h.origin and h.plotVerified))) then return h.plot, h.pen, h.origin end
    local e = r:FindFirstChild("Plots")
    if not e then return nil, nil, nil end
    local y = o.UserId
    local u = o.Name
    local w = o.DisplayName
    local j = nil
    local k = false
    if v then
        local r, w = pcall(function() return v:InvokeServer() end)
        if r and (type(w) == "table" and type(w.OwnersBySlot) == "table") then
            for r, w in pairs(w.OwnersBySlot) do
                if w == y or tostring(w) == tostring(y) or w == u then
                    j = e:FindFirstChild(tostring(r))
                    if j then k = true; break end
                end
            end
        end
    end
    if not j and c then
        local r, u = pcall(function() return c:InvokeServer() end)
        if r and type(u) == "table" then
            for r, u in pairs(u) do
                if type(u) == "table" and ((u.OwnerUserId == y or tostring(u.OwnerUserId) == tostring(y))) then
                    local y = u.Slot or r
                    j = e:FindFirstChild(tostring(y)) or e:FindFirstChild(tostring(r))
                    if j then k = true; break end
                end
            end
        end
    end
    if not j then
        for e, r in ipairs(e:GetChildren()) do
            local a = r:GetAttribute("Owner") or r:GetAttribute("OwnerUserId") or r:GetAttribute("UserId") or r:GetAttribute("OwnerId") or r:GetAttribute("Player")
            if a and ((a == y or tostring(a) == tostring(y) or a == u or tostring(a) == u or a == w)) then
                j = r; k = true; break
            end
            for e, a in ipairs({"Owner","OwnerUserId","OwnerId","UserId","Player","PlayerName"}) do
                local o = r:FindFirstChild(a)
                if o and ((o.Value == y or tostring(o.Value) == tostring(y) or o.Value == u or o.Value == w)) then
                    j = r; k = true; break
                end
            end
            if j then break end
        end
    end
    if not j then
        for e, r in ipairs(e:GetChildren()) do
            for e, y in ipairs(r:GetDescendants()) do
                if y:IsA("TextLabel") and y.Text ~= "" then
                    local e = string.lower(y.Text)
                    if string.find(e, string.lower(u), 1, true) or (w and string.find(e, string.lower(w), 1, true)) then
                        j = r; k = true; break
                    end
                end
            end
            if j then break end
        end
    end
    if not j then
        local r = o.Character
        local y = r and r:FindFirstChild("HumanoidRootPart")
        if y and y.Position.X <= (E + 30) then
            local r = nil; local u = 999999
            for e, w in ipairs(e:GetChildren()) do
                local j = w:FindFirstChild("CenterPoint") or w.PrimaryPart or w:FindFirstChildWhichIsA("BasePart")
                if j then
                    local e = ((y.Position - j.Position)).Magnitude
                    if e < u then u = e; r = w end
                end
            end
            if r and u < 160 then j = r end
        end
    end
    if not j then j = e:FindFirstChild("2") or e:FindFirstChild("1") or (e:GetChildren())[1] end
    if not j then return nil, nil, nil end
    h.plot = j; h.plotVerified = k; h.origin = j:FindFirstChild("CenterPoint")
    local a = j:FindFirstChild("ToUpdate")
    h.pen = (a and a:FindFirstChild("PetArea")) or j:FindFirstChild("PetArea")
    h.tread = j:FindFirstChild("TreadmillBottom")
    if not h.pen and a then
        for e, r in ipairs(a:GetChildren()) do
            if r:IsA("BasePart") and string.find(string.lower(r.Name), "pet") then h.pen = r; break end
        end
    end
    if not h.origin then h.origin = j:FindFirstChild("CenterPoint") or h.pen or j.PrimaryPart end
    if not h.pen then h.pen = h.origin end
    return h.plot, h.pen, h.origin
end

s4 = function()
    local e, r, y = t4()
    if r then return r.Position + Vector3.new(0, 3.5, 0) end
    if y then return y.Position + Vector3.new(0, 3.5, 0) end
    return Vector3.new(464.7, 71.7, -304)
end

p4 = function(e)
    local r, y, u = t4()
    if not y then return nil end
    local w = y.Size
    local j = math.max(4, w.X/2-5)
    local k = math.max(4, w.Z/2-5)
    for r = 1, 60, 1 do
        local u = math.random(-math.floor(j), math.floor(j))
        local o = math.random(-math.floor(k), math.floor(k))
        local V = y.CFrame * CFrame.new(u, w.Y/2+1, o)
        local H = true
        for e, r in ipairs(e) do
            if ((r - V.Position)).Magnitude < 5.5 then H = false; break end
        end
        if H then return V end
    end
    return y.CFrame * CFrame.new(math.random(-8,8), w.Y/2+1, math.random(-8,8))
end

B4 = function()
    local e, r, y = t4()
    if not y or not K then return 0 end
    local u = 0
    local w = {}
    if c then
        local e, r = pcall(function() return c:InvokeServer() end)
        if e and type(r) == "table" then
            local e = {}
            for r, y in pairs(r) do
                if type(y) == "table" and y.OwnerUserId == o.UserId then
                    for r, y in pairs(y.Records or {}) do e[r] = y end
                end
            end
            for e, r in pairs(e) do
                if r.Placement and r.Placement.LocalCFrame then
                    w[#w+1] = ((y.CFrame * r.Placement.LocalCFrame)).Position
                else
                    local r = p4(w)
                    if r then
                        local j = y.CFrame:ToObjectSpace(r)
                        local k, a = pcall(function() return K:InvokeServer({ ["Uid"]=e, ["LocalCFrame"]=j }) end)
                        if k and a then u = u+1; w[#w+1] = r.Position end
                    end
                end
            end
        end
    end
    local j = {}
    local k = o.Character
    if k then for e, r in ipairs(k:GetChildren()) do if m(r) then table.insert(j, r) end end end
    local a = o:FindFirstChild("Backpack")
    if a then for e, r in ipairs(a:GetChildren()) do if m(r) then table.insert(j, r) end end end
    for e, r in ipairs(j) do
        if not h.alive then break end
        local j = r:GetAttribute("UID") or r:GetAttribute("EggUid") or r.Name
        local k = p4(w)
        if k then
            local e = y.CFrame:ToObjectSpace(k)
            local r, a = pcall(function() return K:InvokeServer({ ["Uid"]=j, ["LocalCFrame"]=e }) end)
            if r and a ~= false then
                u = u+1; w[#w+1] = k.Position
                H(string.format("[PlaceEgg] Placed egg %s from inventory", tostring(j)))
            end
            task.wait(0.04)
        end
    end
    return u
end

J4 = function(e)
    if (not e and not h.autoHatch) or not g or not Q or not c then return 0 end
    if h.isHatching then return 0 end
    h.isHatching = true
    local y, u = pcall(function() return c:InvokeServer() end)
    if not y or type(u) ~= "table" then return 0 end
    local w = {}
    for e, r in pairs(u) do
        if type(r) == "table" and r.OwnerUserId == o.UserId then
            for e, r in pairs(r.Records or {}) do w[e] = r end
        end
    end
    local j = {}
    local k = r:GetServerTimeNow()
    for e, r in pairs(w) do
        if not h.alive then break end
        if r.Placement then
            local y = nil
            if s then
                local r = s.IsReadyToHatch or s.IsLocalEggReady
                if r then
                    local u, w = pcall(r, e)
                    if u and type(w) == "boolean" then y = w end
                end
            end
            if y == nil then
                local e = r.Placement.PlacedAt or r.Placement.Time or 0
                local u = 30
                if p and (p.Assets and p.Assets[r.AssetCategory]) then
                    local e = p.Assets[r.AssetCategory]
                    u = (e and (e.Egg and e.Egg.GrowthTime)) or 30
                end
                local w = u / math.max(0.01, r.GrowthSpeedMultiplier or 1)
                y = (k - e) >= w
            end
            if y then table.insert(j, { ["uid"]=e, ["category"]=r.AssetCategory or "Egg" }) end
        end
    end
    if #j == 0 then h.isHatching = false; return 0 end
    H(string.format("[AutoHatch] Found %d eggs ready to hatch!", #j))
    h.statusText = string.format("[Hatch] Hatching %d ready eggs...", #j)
    local a = 0
    for e, r in ipairs(j) do
        task.spawn(function()
            local e, y = pcall(function()
                if g:IsA("RemoteFunction") then return g:InvokeServer(r.uid)
                else g:FireServer(r.uid); return true end
            end)
            if e and y ~= false then
                task.wait(0.9)
                local e, y = pcall(function()
                    if Q:IsA("RemoteFunction") then return Q:InvokeServer(r.uid)
                    else Q:FireServer(r.uid); return true end
                end)
                if e and y ~= false then
                    a = a+1
                    h.hatched = ((h.hatched or 0)) + 1
                    H(string.format("[+] Hatched %s (UID: %s) -> Total: %d", r.category, tostring(r.uid), h.hatched))
                end
            end
        end)
        task.wait(0.04)
    end
    task.wait(0.95)
    h.isHatching = false
    H(string.format("[AutoHatch] Finished! Hatched %d eggs.", a))
    return a
end

i4 = function()
    local e = {}
    local y = r:FindFirstChild("__DEBRIS")
    if y then
        for r, y in ipairs(y:GetChildren()) do
            local u = y:FindFirstChild("Hitbox")
            if u and u:IsA("BasePart") then table.insert(e, u)
            elseif y:IsA("BasePart") and string.find(y.Name:lower(), "hitbox") then table.insert(e, y) end
        end
    end
    local u = r:FindFirstChild("BossArenaTeleport")
    if u then
        local r = u:FindFirstChild("Hitbox") or u:FindFirstChildWhichIsA("BasePart") or (u:IsA("BasePart") and u)
        if r and r:IsA("BasePart") then table.insert(e, r) end
    end
    return e
end

g4 = function(e, r, u)
    local w = o.Character
    local j = w and w:FindFirstChild("HumanoidRootPart")
    local k = w and w:FindFirstChildOfClass("Humanoid")
    if not j then return false end
    if k then k.AutoRotate = false end
    local a = s4()
    e = math.max(100, e or h.glideSpeed or 600)
    local V = h.laneZ or L
    h.isReturning = true; h.stateTime = os.clock()
    V4(a, 20)
    j.AssemblyLinearVelocity = Vector3.zero
    j.AssemblyAngularVelocity = Vector3.zero
    local H = o4()
    local t = math.max(e, H)
    local s = os.clock() + 25
    while h.alive and (h.isReturning and os.clock() < s) do
        if r and O4 ~= r then
            if k then k.AutoRotate = true end
            h.isReturning = false; return false
        end
        if not u and (not h.pureTweenFarm and not h.autoFarmLoop) then
            if k then k.AutoRotate = true end
            h.isReturning = false; return false
        end
        local e = j.Position
        local w = ((a - e)).Magnitude
        if (e.X <= (a.X+3) and math.abs(e.Z-a.Z) <= 8) or w <= 6 then break end
        local o = y.Heartbeat:Wait()
        e = j.Position
        local H = t
        if e.X <= b and e.X > E then
            local r = math.clamp(((e.X-E))/((b-E)), 0, 1)
            H = A + (((t-A))*r)
        elseif e.X <= E then H = A end
        local s = a.Z
        if e.X > 540 then s = V end
        local B = math.sign(a.X-e.X)
        local J = B * math.min(math.abs(a.X-e.X), H*o)
        local K = e.X + J
        local c = math.sign(a.Y-e.Y)
        local v = c * math.min(math.abs(a.Y-e.Y), (H*o)*0.5)
        local i = e.Y + v
        local R = s - e.Z
        local g = math.sign(R) * math.min(math.abs(R), H*o)
        local Q = e.Z + g
        local P = i4()
        local N = false
        if e.X > E then
            for e, r in ipairs(P) do
                local y = r.Position
                local u = ((Vector3.new(K,i,Q)-y)).Magnitude
                local w = math.abs(K-y.X)
                local j = math.abs(Q-y.Z)
                if u < 22 or (w < 18 and j < 14) then
                    N = true
                    local e = y.Y + 16
                    if i < e then i = math.min(i + ((H*o)*1.5), e) end
                    break
                end
            end
        end
        local U = Vector3.new(K,i,Q)
        local l = ((U-e)).Magnitude > 0.05 and ((U-e)).Unit or j.CFrame.LookVector
        j.CFrame = CFrame.lookAt(U, U+l)
        j.AssemblyLinearVelocity = Vector3.zero
        j.AssemblyAngularVelocity = Vector3.zero
        if N then
            h.statusText = string.format("Tweening Home (Z: %.0f) [DODGING TRAP!]", Q)
        else
            h.statusText = string.format("Tweening Home (%.0f studs | Z: %.0f | Spd: %.0f)", w, Q, H)
        end
    end
    j.CFrame = CFrame.new(a)
    j.AssemblyLinearVelocity = Vector3.zero
    j.AssemblyAngularVelocity = Vector3.zero
    if k then k.AutoRotate = true end
    u4()
    h.isReturning = false; h.delivering = false
    h.statusText = "Arrived at Base PetArea!"
    return true
end

v4 = function(e, r, y)
    local u = o.Character
    local w = u and u:FindFirstChild("HumanoidRootPart")
    local j = u and u:FindFirstChildOfClass("Humanoid")
    if not w or not j then return end
    local k = s4()
    local a = ((w.Position-k)).Magnitude
    if a > 8 then
        h.statusText = "[Place] Tweening back to base plot..."
        g4(e or h.glideSpeed or 600, r, true)
    end
    V4(k, 15)
    w.CFrame = CFrame.new(k)
    w.AssemblyLinearVelocity = Vector3.zero
    h.statusText = "[Place] Placing All Eggs to Stand..."
    local V = os.clock() + 3
    while y4() > 0 and (os.clock() < V and h.alive) do B4(); task.wait(0.06) end
    h.statusText = "[Place] Hatching ready eggs..."
    J4(true)
    u4()
    h.isReturning = false; h.delivering = false
    h.currentTargetModel = nil; h.targetPosition = nil
    local H = y4()
    h.statusText = string.format("Placed & Hatched (Left: %d)! Hands Free.", H)
end

local uk = 5
K4 = function(e)
    if h.isBatchPlacing then return end
    h.isBatchPlacing = true
    H(string.format("[AutoPlace] %d steals done! Batch placing (%s mode)...", uk, tostring(e)))
    local r = O4
    h.pureTweenFarm = (e == "TWEEN")
    h.autoFarmLoop = (e == "WARP")
    local y = o.Character
    local u = y and y:FindFirstChild("HumanoidRootPart")
    local w = y and y:FindFirstChildOfClass("Humanoid")
    local j = s4()
    local k = u and ((u.Position-j)).Magnitude or 999
    if k > 8 then
        h.statusText = "[AutoPlace] Tweening home to base plot..."
        g4(h.glideSpeed or 600, r, true)
    end
    if u then
        V4(j, 20)
        u.CFrame = CFrame.new(j)
        u.AssemblyLinearVelocity = Vector3.zero
        u.AssemblyAngularVelocity = Vector3.zero
        if w then w.AutoRotate = true end
    end
    task.spawn(function() pcall(B4); pcall(J4, true) end)
    u4()
    h.isReturning = false; h.delivering = false; h.glidingToTarget = false
    h.securingEgg = false; h.teleporting = false
    h.currentTargetModel = nil; h.targetPosition = nil
    for e = 5, 1, -1 do
        if not h.alive then break end
        h.statusText = string.format("[AutoPlace] At Base: Resuming in %ds...", e)
        task.wait(1)
    end
    h.isBatchPlacing = false
    if h.alive and O4 == r then
        H(string.format("[AutoPlace] Done! Continuing %s farm.", e))
        h.statusText = string.format("[AutoPlace] Resuming %s farm...", e)
        if e == "TWEEN" then h.pureTweenFarm = true; h.autoFarmLoop = false
        elseif e == "WARP" then h.autoFarmLoop = true; h.pureTweenFarm = false end
        Y4 = e
    end
end

c4 = function(e)
    if not h.autoPlaceEvery5 then return false end
    h.batchStealCount = ((h.batchStealCount or 0)) + 1
    H(string.format("[AutoPlace] Steal trip %d / %d completed.", h.batchStealCount, uk))
    if h.batchStealCount >= uk then
        h.batchStealCount = 0
        task.spawn(function() K4(e) end)
        return true
    end
    return false
end

local function wk(e, r, u, w)
    local j = o.Character
    local k = j and j:FindFirstChild("HumanoidRootPart")
    local a = j and j:FindFirstChildOfClass("Humanoid")
    if not k then return false end
    if a then a.AutoRotate = false end
    r = math.max(60, r or h.glideSpeed or 350)
    local V = e.Position
    V4(V, 14)
    pcall(function() o:RequestStreamAroundAsync(V) end)
    k.AssemblyLinearVelocity = Vector3.zero
    k.AssemblyAngularVelocity = Vector3.zero
    local H = h.laneZ or L
    h.glidingToTarget = true; h.stateTime = os.clock()
    local t = 0
    local s = os.clock() + 15
    while h.alive and (h.glidingToTarget and os.clock() < s) do
        if w and O4 ~= w then
            if a then a.AutoRotate = true end
            h.glidingToTarget = false; return false
        end
        if not h.pureTweenFarm and (not h.autoFarmLoop and not h.teleporting and not h.stealAutoTreadmill and not h.autoStealBigSize) then
            if a then a.AutoRotate = true end
            h.glidingToTarget = false; return false
        end
        local e = k.Position
        local j = ((V-e)).Magnitude
        local o = ((Vector2.new(e.X,e.Z)-Vector2.new(V.X,V.Z))).Magnitude
        local s = math.abs(e.Y-V.Y)
        if j <= 6 or (o <= 3.5 and s <= 6) then break end
        local B = y.Heartbeat:Wait()
        e = k.Position
        j = ((V-e)).Magnitude
        o = ((Vector2.new(e.X,e.Z)-Vector2.new(V.X,V.Z))).Magnitude
        local J = math.abs(e.X-V.X)
        if u and (os.clock()-t > 0.5) then
            t = os.clock()
            local e, r = k4(u)
            if not e and r == "CarriedByOther" then
                if a then a.AutoRotate = true end
                h.glidingToTarget = false; return false
            end
        end
        local K = V.Z
        if J > 40 then K = H end
        local c = math.sign(V.X-e.X)
        local v = c * math.min(math.abs(V.X-e.X), r*B)
        local i = e.X + v
        local R = (o <= 25) and 1.2 or 0.5
        local g = math.sign(V.Y-e.Y)
        local Q = g * math.min(math.abs(V.Y-e.Y), (r*B)*R)
        local P = e.Y + Q
        local N = K - e.Z
        local U = math.sign(N) * math.min(math.abs(N), r*B)
        local l = e.Z + U
        local D = false
        if o > 25 then
            local e = i4()
            for e, y in ipairs(e) do
                local u = y.Position
                local w = ((Vector3.new(i,P,l)-u)).Magnitude
                local j = math.abs(i-u.X)
                local k = math.abs(l-u.Z)
                if w < 22 or (j < 18 and k < 14) then
                    D = true
                    local e = u.Y + 16
                    if P < e then P = math.min(P + ((r*B)*1.5), e) end
                    break
                end
            end
        end
        local C = Vector3.new(i,P,l)
        local q = ((C-e)).Magnitude > 0.05 and ((C-e)).Unit or k.CFrame.LookVector
        k.CFrame = CFrame.lookAt(C, C+q)
        k.AssemblyLinearVelocity = Vector3.zero
        k.AssemblyAngularVelocity = Vector3.zero
        if D then
            h.statusText = string.format("Gliding Out (Z: %.0f) [DODGING TRAP!]", l)
        else
            h.statusText = string.format("Gliding -> Egg (%.0f studs | H: %.0f)", j, o)
        end
    end
    k.CFrame = e * CFrame.new(0, 0.4, 0)
    k.AssemblyLinearVelocity = Vector3.zero
    k.AssemblyAngularVelocity = Vector3.zero
    if a then a.AutoRotate = true end
    h.glidingToTarget = false
    return true
end

R4 = function(e, r, y, u)
    local w = o.Character
    local j = w and w:FindFirstChild("HumanoidRootPart")
    if j then
        local w = j.Position.X
        local a = e.Position.X
        if w <= 535 and a > 510 then
            local e = CFrame.new(500, 70, -364)
            local a = ((j.Position-e.Position)).Magnitude
            if a > 5 then
                h.statusText = "[AutoSteal] Exiting Base -> Waypoint..."
                H(string.format("[AutoSteal] Leaving base (X=%.1f): Gliding to waypoint first (dist=%.1f)", w, a))
                local j = wk(e, r, y, u)
                if not j then return false end
                task.wait(0.04)
            end
        end
    end
    return wk(e, r, y, u)
end

Q4 = function(e, r)
    local u = o.Character
    local w = u and u:FindFirstChild("HumanoidRootPart")
    local j = u and u:FindFirstChildOfClass("Humanoid")
    if not w then return false end
    if j then j.AutoRotate = false end
    local k = h.laneZ or L
    local a = Vector3.new(E-10, 70, k)
    e = math.max(100, e or h.glideSpeed or 350)
    h.isReturning = true; h.stateTime = os.clock()
    V4(Vector3.new(E, 70, k), 20)
    pcall(u4)
    w.AssemblyLinearVelocity = Vector3.zero
    w.AssemblyAngularVelocity = Vector3.zero
    local V = o4()
    local H = math.max(e, V)
    local s = os.clock() + 15
    while h.alive and (h.isReturning and os.clock() < s) do
        if r and O4 ~= r then
            t("[Return] Aborted by session switch!")
            if j then j.AutoRotate = true end
            h.isReturning = false; return false
        end
        if not h.pureTweenFarm and not h.autoFarmLoop and not h.stealAutoTreadmill and not h.autoStealBigSize then
            t("[Return] Aborted (all farms disabled)")
            if j then j.AutoRotate = true end
            h.isReturning = false; return false
        end
        local e = w.Position
        local o = ((a-e)).Magnitude
        if e.X <= (E+10) or o <= 6 then u4(); break end
        if u then
            for e, r in ipairs(u:GetChildren()) do
                if r:IsA("Tool") then pcall(u4); break end
            end
        end
        local V = y.Heartbeat:Wait()
        e = w.Position
        local s = H
        if e.X <= b and e.X > E then
            local r = math.clamp(((e.X-E))/((b-E)), 0, 1)
            s = A + (((H-A))*r)
        elseif e.X <= E then s = A end
        local B = math.sign(a.X-e.X)
        local J = B * math.min(math.abs(a.X-e.X), s*V)
        local K = e.X + J
        local c = math.sign(a.Y-e.Y)
        local v = c * math.min(math.abs(a.Y-e.Y), (s*V)*0.5)
        local i = e.Y + v
        local R = k - e.Z
        local g = math.sign(R) * math.min(math.abs(R), s*V)
        local Q = e.Z + g
        local P = i4()
        local N = false
        for e, r in ipairs(P) do
            local y = r.Position
            local u = ((Vector3.new(K,i,Q)-y)).Magnitude
            local w = math.abs(K-y.X)
            local j = math.abs(Q-y.Z)
            if u < 22 or (w < 18 and j < 14) then
                N = true
                local e = y.Y + 16
                if i < e then i = math.min(i + ((s*V)*1.5), e) end
                break
            end
        end
        local U = Vector3.new(K,i,Q)
        local l = ((U-e)).Magnitude > 0.05 and ((U-e)).Unit or w.CFrame.LookVector
        w.CFrame = CFrame.lookAt(U, U+l)
        w.AssemblyLinearVelocity = Vector3.zero
        w.AssemblyAngularVelocity = Vector3.zero
        if N then
            h.statusText = string.format("Tweening Safe Line (Z: %.0f) [DODGING!]", Q)
        else
            h.statusText = string.format("Tweening to Safe Line (%.0f studs | X: %.0f)", o, e.X)
        end
    end
    w.CFrame = CFrame.new(E, math.max(68, w.Position.Y), k)
    w.AssemblyLinearVelocity = Vector3.zero
    w.AssemblyAngularVelocity = Vector3.zero
    if j then j.AutoRotate = true end
    u4()
    h.isReturning = false; h.delivering = false
    if h then h.onTreadmill = false end
    h.statusText = "Arrived at Safe Line (X=525)! Hands Free."
    return true
end

local function jk(e)
    if not e then return nil end
    local r = e:FindFirstChild("TreadmillBottom")
    if r and r:IsA("BasePart") then return r end
    r = e:FindFirstChild("TreadmillBottom", true)
    if r and r:IsA("BasePart") then return r end
    local y = e:FindFirstChild("TreadmillUpgrade", true)
    if y then
        for e, r in ipairs({"TreadmillBottom","Belt","RunArea","Run","Platform","Pad","Floor","Base"}) do
            local w = y:FindFirstChild(r, true)
            if w and w:IsA("BasePart") then return w end
        end
        local e = nil; local r = 999999
        for y, w in ipairs(y:GetDescendants()) do
            if w:IsA("BasePart") and (w.Size.X >= 1.2 and w.Size.Z >= 1.2) then
                if w.Position.Y < r then r = w.Position.Y; e = w end
            end
        end
        if e then return e end
        if y.PrimaryPart then return y.PrimaryPart end
        local w = y:FindFirstChildWhichIsA("BasePart", true)
        if w then return w end
    end
    for e, r in ipairs(e:GetDescendants()) do
        if r:IsA("BasePart") and string.find(string.lower(r.Name), "treadmill") then return r end
    end
    return nil
end

I4 = function()
    local e = t4()
    if h.tread and h.tread.Parent then return h.tread end
    local y = nil
    if e then y = jk(e) end
    if not y then
        local w = r:FindFirstChild("Plots")
        if w then
            local r = string.lower(o.Name)
            local j = o.DisplayName and string.lower(o.DisplayName)
            for e, w in ipairs(w:GetChildren()) do
                local k = jk(w)
                if k then
                    local e = false
                    for y, w in ipairs(w:GetDescendants()) do
                        if w:IsA("TextLabel") and w.Text ~= "" then
                            local y = string.lower(w.Text)
                            if string.find(y, r, 1, true) or (j and string.find(y, j, 1, true)) then e = true; break end
                        end
                    end
                    if e then h.plot = w; h.plotVerified = true; y = k; break end
                end
            end
            if not y and e then y = jk(e) end
        end
    end
    h.tread = y
    return y
end

f4 = function(e)
    local r = o.Character
    local u = r and r:FindFirstChild("HumanoidRootPart")
    local w = r and r:FindFirstChildOfClass("Humanoid")
    if not u or not w then return false end
    if w.PlatformStand then w.PlatformStand = false end
    if w.Sit then w.Sit = false end
    w:ChangeState(Enum.HumanoidStateType.Running)
    local j = t4()
    local k = I4()
    if not k then
        t("[AutoTreadmill] Treadmill part not found!")
        return false
    end
    pcall(function()
        for r, y in ipairs(r:GetChildren()) do
            if y:IsA("BasePart") and y.Name ~= "HumanoidRootPart" then y.CanCollide = false end
        end
    end)
    pcall(function()
        k.CanTouch = true; k.CanCollide = true
        local e = j and j:FindFirstChild("TreadmillUpgrade", true)
        if e then
            for e, y in ipairs(e:GetDescendants()) do
                if y:IsA("BasePart") then y.CanTouch = true; y.CanCollide = true end
            end
        end
        if k.Parent and k.Parent:IsA("Model") then
            for e, y in ipairs(k.Parent:GetDescendants()) do
                if y:IsA("BasePart") then y.CanTouch = true; y.CanCollide = true end
            end
        end
    end)
    local a = k.Position + Vector3.new(0, 1.8, 0)
    if u.Position.X > 535 then
        h.statusText = "[AutoTreadmill] Returning to base..."
        Q4(h.glideSpeed, e)
        if e and O4 ~= e then return false end
        if u.Position.X > 535 then
            if u.Position.X <= 560 then u.CFrame = CFrame.new(E, 70, h.laneZ or L)
            else return false end
        end
    end
    if e and O4 ~= e then return false end
    local V = ((Vector2.new(u.Position.X,u.Position.Z)-Vector2.new(a.X,a.Z))).Magnitude
    if V > 4 then
        h.statusText = "[AutoTreadmill] Flyover to base plot..."
        local r = math.max(250, h.glideSpeed or 400)
        local j = os.clock()
        while h.alive and (((Vector2.new(u.Position.X,u.Position.Z)-Vector2.new(a.X,a.Z))).Magnitude > 4 and (os.clock()-j < 4)) do
            if e and O4 ~= e then return false end
            local j = y.Heartbeat:Wait()
            local k = u.Position
            local o = Vector3.new(a.X, 70, a.Z)
            local V = (o-k)
            local H = V.Unit * math.min(V.Magnitude, r*j)
            local t = k + H
            u.CFrame = CFrame.lookAt(t, t + ((V.Magnitude > 0.05 and V.Unit or u.CFrame.LookVector)))
            u.AssemblyLinearVelocity = Vector3.zero
            u.AssemblyAngularVelocity = Vector3.zero
            if w then
                if w.PlatformStand then w.PlatformStand = false end
                if w.Sit then w.Sit = false end
                w:ChangeState(Enum.HumanoidStateType.Running)
            end
        end
    end
    if e and O4 ~= e then return false end
    local H = os.clock()
    while h.alive and (math.abs(u.Position.Y-a.Y) > 2 and (os.clock()-H < 1.5)) do
        if e and O4 ~= e then return false end
        local r = y.Heartbeat:Wait()
        local w = u.Position
        local j = a
        local k = (j-w)
        local o = k.Unit * math.min(k.Magnitude, 150*r)
        local V = w + o
        u.CFrame = CFrame.new(V)
        u.AssemblyLinearVelocity = Vector3.zero
        u.AssemblyAngularVelocity = Vector3.zero
    end
    u.CFrame = CFrame.new(a)
    u.AssemblyLinearVelocity = Vector3.zero
    u.AssemblyAngularVelocity = Vector3.zero
    local s = ((u.Position-a)).Magnitude
    if s <= 6 then
        pcall(function()
            if typeof(firetouchinterest) == "function" then
                firetouchinterest(u, k, 0); task.wait(0.02); firetouchinterest(u, k, 1)
            end
        end)
        pcall(function()
            for r, y in ipairs(k:GetDescendants()) do
                if y:IsA("ProximityPrompt") and y.Enabled then
                    if typeof(fireproximityprompt) == "function" then fireproximityprompt(y) end
                end
            end
            if k.Parent then
                for r, y in ipairs(k.Parent:GetDescendants()) do
                    if y:IsA("ProximityPrompt") and y.Enabled then
                        if typeof(fireproximityprompt) == "function" then fireproximityprompt(y) end
                    end
                end
            end
        end)
        if l then pcall(function() l:InvokeServer() end) end
        h.onTreadmill = true
        h.lastTreadmillMount = os.clock()
        h.statusText = "[AutoTreadmill] Running (Waiting for eggs...)"
        return true
    else
        h.onTreadmill = false
        t(string.format("[AutoTreadmill] Not yet at pad (dist=%.1f). Retry!", s))
        return false
    end
end

local function kk()
    if not h or not h.hideNotEnoughMoney then return end
    local e = o:FindFirstChild("PlayerGui")
    if not e then return end
    pcall(function()
        for e, y in ipairs(e:GetDescendants()) do
            if y:IsA("TextLabel") and y.Visible then
                local e = (tostring(y.Text or "")):lower()
                if e:find("not enough money") or e:find("not enough cash") or (e:find("not enough") and ((e:find("money") or e:find("cash") or e:find("coin") or e:find("fund")))) then
                    y.Visible = false; y.TextTransparency = 1; y.TextStrokeTransparency = 1
                    local e = y.Parent
                    if e and (((e:IsA("Frame") or e:IsA("CanvasGroup"))) and #e:GetChildren() <= 3) then e.Visible = false end
                end
            end
        end
    end)
end
local function ak()
    local e = o:FindFirstChild("PlayerGui")
    if not e then return end
    local function r(e)
        if e:IsA("TextLabel") then
            local function y()
                if not h or not h.hideNotEnoughMoney then return end
                local y = (tostring(e.Text or "")):lower()
                if y:find("not enough money") or y:find("not enough cash") or (y:find("not enough") and ((y:find("money") or y:find("cash") or y:find("coin") or y:find("fund")))) then
                    e.Visible = false; e.TextTransparency = 1; e.TextStrokeTransparency = 1
                    local r = e.Parent
                    if r and (((r:IsA("Frame") or r:IsA("CanvasGroup"))) and #r:GetChildren() <= 3) then r.Visible = false end
                end
            end
            y()
            ;(e:GetPropertyChangedSignal("Text")):Connect(y)
            ;(e:GetPropertyChangedSignal("Visible")):Connect(function() if e.Visible then y() end end)
        end
    end
    pcall(function()
        for e, y in ipairs(e:GetDescendants()) do task.spawn(r, y) end
        e.DescendantAdded:Connect(r)
    end)
    task.spawn(function()
        while h and h.alive do
            if h.hideNotEnoughMoney then kk() end
            task.wait(0.25)
        end
    end)
end
task.spawn(ak)

local function ok(e)
    if not e then return 0 end
    local r = (((tostring(e)):gsub("[$,]","")):gsub("%s+","")):lower()
    local y = r:match("[%d%.]+")
    if not y then return 0 end
    local u = tonumber(y)
    if not u then return 0 end
    if r:find("sp") then return u*999999999999999983222784
    elseif r:find("sx") then return u*1000000000000000000000
    elseif r:find("qi") then return u*1000000000000000000
    elseif r:find("qa") or r:find("q") then return u*1000000000000000
    elseif r:find("t") then return u*1000000000000
    elseif r:find("b") then return u*1000000000
    elseif r:find("m") then return u*1000000
    elseif r:find("k") then return u*1000 end
    return u
end
local function Vk()
    local e = o:FindFirstChild("leaderstats")
    if e then
        for r, u in ipairs({"Money","Cash","Coins","Currency"}) do
            local w = e:FindFirstChild(u)
            if w then
                local e = tonumber(w.Value) or ok(w.Value)
                if e and e > 0 then return e end
            end
        end
    end
    local r = o:FindFirstChild("PlayerGui")
    if r then
        local e = r:FindFirstChild("HUD") or r:FindFirstChild("GameHUD") or r:FindFirstChild("MainHUD") or r:FindFirstChild("Main")
        if e then
            for e, r in ipairs(e:GetDescendants()) do
                if r:IsA("TextLabel") and r.Visible then
                    local e = r.Name:lower()
                    if e == "money" or e == "cash" or e == "coins" or e == "currency" or e == "value" then
                        local e = ok(r.Text)
                        if e and e > 0 then return e end
                    end
                end
            end
        end
    end
    return 0
end
local function Hk()
    local e = h.plot or (t4 and t4())
    if not e then return nil end
    local r = e:FindFirstChild("TreadmillUpgrade", true)
    if not r then return nil end
    local y = nil
    for e, r in ipairs(r:GetDescendants()) do
        if r:IsA("TextLabel") or r:IsA("TextButton") then
            local e = tostring(r.Text or "")
            local w = e:match("%$([%d%.,]+%s*[kKmMbBtTqQ]?[aA]?)")
            if w then
                local e = ok(w)
                if e and e > 0 then if not y or e > y then y = e end end
            end
        end
    end
    return y
end
local tk = 0
local sk = 10
local function pk()
    if not h.autoUpgradeTreadmill then return end
    if os.clock() - tk < sk then return end
    local e = h.plot or (t4 and t4())
    if not e then return end
    local r = e:FindFirstChild("TreadmillUpgrade", true)
    if not r then return end
    local y = Vk()
    local u = Hk()
    if u and (u > 0 and y < u) then return end
    tk = os.clock()
    if D then pcall(function() D:InvokeServer() end) end
    local w = o.Character
    local j = w and w:FindFirstChild("HumanoidRootPart")
    pcall(function()
        for r, y in ipairs(r:GetDescendants()) do
            if y:IsA("ProximityPrompt") and y.Enabled then
                if typeof(fireproximityprompt) == "function" then fireproximityprompt(y, 0); fireproximityprompt(y) end
            end
            if y:IsA("GuiButton") and y.Visible then
                local r = (y:IsA("TextButton") and y.Text) or y.Name
                local u = string.lower(r)
                if not string.find(u, "robux") and (not string.find(u, "r%$") and ((string.find(u, "%$") or string.find(u, "upgrade") or string.find(u, "cash") or (y.BackgroundColor3 and y.BackgroundColor3.G > y.BackgroundColor3.R)))) then
                    if typeof(firesignal) == "function" and y.Activated then firesignal(y.Activated)
                    elseif typeof(firesignal) == "function" and y.MouseButton1Click then firesignal(y.MouseButton1Click) end
                end
            end
            if y:IsA("BasePart") and (y.Name:find("Pad") and j) then
                if ((j.Position - y.Position)).Magnitude < 10 then
                    if typeof(firetouchinterest) == "function" then
                        firetouchinterest(j, y, 0); task.wait(0.02); firetouchinterest(j, y, 1)
                    end
                end
            end
        end
    end)
end

local Bk = {
    { ["id"]="GreyTrail", ["base"]="Grey", ["name"]="Grey Trail", ["price"]=100, ["mult"]=1.5 },
    { ["id"]="GreenTrail", ["base"]="Green", ["name"]="Green Trail", ["price"]=5000, ["mult"]=2 },
    { ["id"]="BlueTrail", ["base"]="Blue", ["name"]="Blue Trail", ["price"]=75000, ["mult"]=2.5 },
    { ["id"]="PurpleTrail", ["base"]="Purple", ["name"]="Purple Trail", ["price"]=1500000, ["mult"]=3 },
    { ["id"]="GoldenTrail", ["base"]="Golden", ["name"]="Golden Trail", ["price"]=1500000, ["mult"]=3.5 },
    { ["id"]="RedTrail", ["base"]="Red", ["name"]="Red Trail", ["price"]=750000000, ["mult"]=4 },
    { ["id"]="GalaxyTrail", ["base"]="Galaxy", ["name"]="Galaxy Trail", ["price"]=20000000000, ["mult"]=5 },
    { ["id"]="SecretTrail", ["base"]="Secret", ["name"]="Secret Trail", ["price"]=500000000000, ["mult"]=6 },
    { ["id"]="EternalTrail", ["base"]="Eternal", ["name"]="Eternal Trail", ["price"]=12500000000000, ["mult"]=10 },
    { ["id"]="DivineTrail", ["base"]="Divine", ["name"]="Divine Trail", ["price"]=300000000000000, ["mult"]=14 },
    { ["id"]="MoonbloomTrail", ["base"]="Moonbloom", ["name"]="Moonbloom Trail", ["price"]=5000000000000000, ["mult"]=20 }
}
local function Jk() return Bk end
local function Kk()
    local e = {}
    local r = o:FindFirstChild("PlayerGui")
    local y = r and ((r:FindFirstChild("TrailShop") or r:FindFirstChild("TrailShop", true)))
    local u = y and y:FindFirstChild("ScrollingFrame", true)
    if u then
        pcall(function()
            for y, u in ipairs(u:GetChildren()) do
                if u:IsA("GuiObject") and (not u:IsA("UIListLayout") and not u:IsA("UIPadding")) then
                    local y = u.Name
                    for u, w in ipairs(u:GetDescendants()) do
                        if w:IsA("GuiButton") or w:IsA("TextButton") then
                            local u = (w:IsA("TextButton") and w.Text:lower()) or w.Name:lower()
                            if u:find("unequip") or (u:find("equip") and not u:find("unequip")) then
                                e[y] = true; e[y:lower()] = true
                                local u = y:gsub("Trail", "")
                                e[u] = true; e[u:lower()] = true
                            end
                        end
                    end
                end
            end
        end)
    end
    return e
end
local function ck(e)
    if not e then return false end
    pcall(function()
        if typeof(firebutton1click) == "function" then firebutton1click(e)
        elseif typeof(firesignal) == "function" and e.Activated then firesignal(e.Activated)
        elseif typeof(firesignal) == "function" and e.MouseButton1Click then firesignal(e.MouseButton1Click) end
    end)
    return true
end
local function vk()
    local e = Jk()
    local r = Kk()
    local y = o:FindFirstChild("PlayerGui")
    local u = y and ((y:FindFirstChild("TrailShop") or y:FindFirstChild("TrailShop", true)))
    local w = u and u:FindFirstChild("ScrollingFrame", true)
    if w then
        for r = #e, 1, -1 do
            local y = e[r]
            local u = w:FindFirstChild(y.id) or w:FindFirstChild(y.base) or w:FindFirstChild(y.name)
            if not u then
                for e, r in ipairs(w:GetChildren()) do
                    if r:IsA("GuiObject") and ((r.Name:lower() == y.id:lower() or r.Name:lower() == y.base:lower() or r.Name:lower() == y.name:lower())) then
                        u = r; break
                    end
                end
            end
            if u then
                local e = false
                local r = nil
                for y, u in ipairs(u:GetDescendants()) do
                    if u:IsA("GuiButton") or u:IsA("TextButton") then
                        local y = (u:IsA("TextButton") and u.Text:lower()) or u.Name:lower()
                        if y:find("unequip") then e = true; break
                        elseif y:find("equip") and not y:find("unequip") then r = u end
                    end
                end
                if e then return true end
                if r then
                    ck(r)
                    if q then pcall(function() q:InvokeServer(y.id) end) end
                end
                task.wait(0.2)
                return true
            end
        end
    end
    if q then
        for y = #e, 1, -1 do
            local u = e[y]
            local w = r[u.id] or r[u.id:lower()] or r[u.base] or r[u.base:lower()] or r[u.name] or r[u.name:lower()]
            if w then
                pcall(function() q:InvokeServer(u.id) end)
                return true
            end
        end
    end
    return false
end
local ik = 0
local Rk = 8
local function gk()
    if not h.autoBuyTrails then return end
    vk()
    if os.clock() - ik < Rk then return end
    local e = Vk()
    if e <= 0 then return end
    local r = Jk()
    local y = Kk()
    local u = o:FindFirstChild("PlayerGui")
    local w = u and ((u:FindFirstChild("TrailShop") or u:FindFirstChild("TrailShop", true)))
    local j = w and w:FindFirstChild("ScrollingFrame", true)
    for u = #r, 1, -1 do
        local w = r[u]
        local a = y[w.id] or y[w.id:lower()] or y[w.base] or y[w.base:lower()] or y[w.name] or y[w.name:lower()]
        if not a and (w.price > 0 and e >= w.price) then
            ik = os.clock()
            local e = false
            if j then
                local r = j:FindFirstChild(w.id) or j:FindFirstChild(w.base) or j:FindFirstChild(w.name)
                if not r then
                    for e, y in ipairs(j:GetChildren()) do
                        if y:IsA("GuiObject") and ((y.Name:lower() == w.id:lower() or y.Name:lower() == w.base:lower() or y.Name:lower() == w.name:lower())) then
                            r = y; break
                        end
                    end
                end
                if r then
                    for r, y in ipairs(r:GetDescendants()) do
                        if y:IsA("GuiButton") or y:IsA("TextButton") then
                            local r = (y:IsA("TextButton") and y.Text:lower()) or y.Name:lower()
                            if not r:find("robux") and (not r:find("r%$") and (not r:find("unequip") and not r:find("equip"))) then
                                if r:find("%$") or r:find("buy") then ck(y); e = true; break end
                            end
                        end
                    end
                end
            end
            if C then pcall(function() C:InvokeServer(w.id) end); e = true end
            if e then task.wait(0.3); vk(); break end
        end
    end
end

P4 = function()
    local e = o.Character
    local y = e and e:FindFirstChild("HumanoidRootPart")
    if not y then return nil end
    local u = {}
    local w = r:FindFirstChild("AreaEggSlotsClient")
    local j = h4(false)
    if j and #j > 0 then
        for e, r in ipairs(j) do
            local w = (r.State == "Slot" or r.State == "Dropped" or r.State == 1)
            local j = (r.AreaId == "Lake") or (string.find(string.lower(tostring(r.AreaId)), "lake") ~= nil) or (string.find(string.lower(tostring(r.Uid)), "lake") ~= nil)
            local k = X4[r.Uid] and (os.clock() < X4[r.Uid])
            if w and (j and (r.BoundsCFrame and not k)) then
                local e = r.BoundsCFrame.Position
                local w = ((y.Position-e)).Magnitude
                table.insert(u, { ["Uid"]=r.Uid, ["Model"]=nil, ["Hitbox"]=nil, ["CFrame"]=r.BoundsCFrame, ["Position"]=e, ["Distance"]=w, ["Area"]="Lake" })
            end
        end
    end
    if #u == 0 and (j and #j > 0) then
        for e, r in ipairs(j) do
            local w = (r.State == "Slot" or r.State == "Dropped" or r.State == 1)
            local j = r.BoundsCFrame and r.BoundsCFrame.Position
            local k = j and ((j.X >= 545 and j.X < 850))
            local o = X4[r.Uid] and (os.clock() < X4[r.Uid])
            if w and (k and not o) then
                table.insert(u, { ["Uid"]=r.Uid, ["Model"]=nil, ["Hitbox"]=nil, ["CFrame"]=r.BoundsCFrame, ["Position"]=j, ["Distance"]=((y.Position-j)).Magnitude, ["Area"]=r.AreaId or "Field" })
            end
        end
    end
    if #u == 0 then return nil end
    table.sort(u, function(e, r) return e.Distance < r.Distance end)
    local k = u[1]
    if k and w then
        for e, r in ipairs(w:GetChildren()) do
            local y = r:FindFirstChildWhichIsA("BasePart") or r.PrimaryPart
            if y and ((y.Position-k.Position)).Magnitude <= 8 then k.Model = r; break end
        end
    end
    return k
end

local Qk = nil
local Pk = nil
local Nk = 350
local function Uk()
    local e = r:FindFirstChild("__OBJECTS") or r:FindFirstChild("Objects")
    local y = e and ((e:FindFirstChild("Areas") or e:FindFirstChild("Area")))
    local u = y and ((y:FindFirstChild("GuardAreas") or y:FindFirstChild("Guards")))
    if u then
        local e = u:FindFirstChild("Light Dark") or u:FindFirstChild("LightDark") or u:FindFirstChild("Light_Dark") or u:FindFirstChild("Light-Dark")
        if e then return e end
        for e, r in ipairs(u:GetChildren()) do
            local y = string.lower(r.Name)
            if string.find(y, "light") and string.find(y, "dark") then return r end
        end
    end
    if y then
        local e = y:FindFirstChild("Light Dark") or y:FindFirstChild("LightDark") or y:FindFirstChild("Light_Dark")
        if e then return e end
        for e, r in ipairs(y:GetChildren()) do
            local y = string.lower(r.Name)
            if string.find(y, "light") and string.find(y, "dark") then return r end
        end
    end
    for e, r in ipairs(r:GetChildren()) do
        local y = r.Name
        if y == "__OBJECTS" or y == "Objects" or y == "Areas" or y == "Map" then
            for e, r in ipairs(r:GetDescendants()) do
                local y = string.lower(r.Name)
                if (y == "light dark" or y == "lightdark" or (string.find(y, "light") and string.find(y, "dark"))) then
                    if r:IsA("BasePart") or r:IsA("Model") or r:IsA("Folder") then return r end
                end
            end
        end
    end
    return nil
end
local function lk(e)
    if not e then return false end
    if Qk then
        local r = ((Vector3.new(e.X, 0, e.Z) - Vector3.new(Qk.X, 0, Qk.Z))).Magnitude
        if r <= Nk then return true end
    end
    local r = Uk()
    if not r then
        if e.X >= 5200 then return true end
        return false
    end
    local y = false
    pcall(function()
        local u, w = nil, nil
        if r:IsA("BasePart") then u = r.CFrame; w = r.Size
        elseif r:IsA("Model") then u, w = r:GetBoundingBox()
        else
            local e, y = nil, nil
            for r, u in ipairs(r:GetChildren()) do
                if u:IsA("BasePart") then
                    local r = u.CFrame
                    local w = u.Size / 2
                    local k = r.Position - w
                    local a = r.Position + w
                    if not e then e = k; y = a
                    else
                        e = Vector3.new(math.min(e.X, k.X), math.min(e.Y, k.Y), math.min(e.Z, k.Z))
                        y = Vector3.new(math.max(y.X, a.X), math.max(y.Y, a.Y), math.max(y.Z, a.Z))
                    end
                end
            end
            if e and y then u = CFrame.new(((e+y))/2); w = y-e end
        end
        if u and w then
            Qk = u.Position; Pk = u; Nk = math.max(350, math.max(w.X, w.Z)/2+150)
            local r = ((Vector3.new(e.X, 0, e.Z) - Vector3.new(u.Position.X, 0, u.Position.Z))).Magnitude
            if r <= Nk then y = true; return end
            local k = u:PointToObjectSpace(e)
            local a = w / 2
            if math.abs(k.X) <= (a.X+200) and math.abs(k.Z) <= (a.Z+200) then y = true; return end
        end
        for r, u in ipairs(r:GetDescendants()) do
            if u:IsA("BasePart") then
                if ((e - u.Position)).Magnitude <= 250 then
                    y = true
                    if not Qk then Qk = u.Position end
                    return
                end
            end
        end
    end)
    return y
end

local function Dk(e, r, y)
    local u = r and r.X or 0
    local w = string.lower(tostring(e or ""))
    local j = string.lower(tostring(y or ""))
    if j ~= "" and j ~= "egg" then
        if string.find(j, "spideron") or string.find(j, "crustacia") or string.find(j, "bladehide") or string.find(j, "mantaris") or string.find(j, "rhinotaur") or string.find(j, "mutantshark") or string.find(j, "mutant shark") or string.find(j, "gorillaking") or string.find(j, "gorilla king") or string.find(j, "nightflame") then return "Titan Temple" end
        if string.find(j, "crane") or string.find(j, "salamander") or string.find(j, "redpanda") or string.find(j, "red panda") or string.find(j, "snowyowl") or string.find(j, "snowy owl") or string.find(j, "koiegg") or string.find(j, "koi egg") or string.find(j, "stagegg") or string.find(j, "stag egg") or string.find(j, "onitiger") or string.find(j, "oni tiger") or string.find(j, "kitsune") then return "Cherry Blossom" end
        if string.find(j, "centapede") or string.find(j, "cosmicgecko") or string.find(j, "cosmic gecko") or string.find(j, "cosmicgorilla") or string.find(j, "cosmic gorilla") or string.find(j, "saturno") or string.find(j, "saturnita") or string.find(j, "vacca") or string.find(j, "cosmic skeleton") or string.find(j, "skeletonboss") or string.find(j, "skeleton boss") or string.find(j, "cosmicdragon") or string.find(j, "cosmic dragon") or string.find(j, "lunardragon") or string.find(j, "lunar dragon") or string.find(j, "unicornegg") or string.find(j, "unicorn egg") then return "Cosmic" end
        if string.find(j, "dodo") or string.find(j, "pterodactyl") or string.find(j, "ankylosaurus") or string.find(j, "triceratops") or string.find(j, "bronto") or string.find(j, "trex") or string.find(j, "t-rex") or string.find(j, "tralaledon") or string.find(j, "mosasaurus") then return "Prehistoric" end
        if string.find(j, "parrotfish") or string.find(j, "swordfish") or string.find(j, "whaleshark") or string.find(j, "whale shark") or string.find(j, "belugawhale") or string.find(j, "beluga whale") or string.find(j, "kraken") or string.find(j, "elmaja") or string.find(j, "el maja") then return "Abyss Ocean" end
        if string.find(j, "lava gecko") or string.find(j, "lava frog") or string.find(j, "flaming bull") or string.find(j, "lava iguana") or string.find(j, "chillin chilli") or string.find(j, "cerberus") or string.find(j, "phoenix") or string.find(j, "lava dragon") then return "Volcano" end
        if string.find(j, "penguin") or string.find(j, "walrus") or string.find(j, "polar bear") or string.find(j, "polarbear") or string.find(j, "sabertooth") or string.find(j, "mammoth") or string.find(j, "yeti") or string.find(j, "ice dragon") or string.find(j, "icedragon") then return "Snow" end
        if string.find(j, "sand spider") or string.find(j, "sandspider") or string.find(j, "royal sphinx") or string.find(j, "sphinx") or string.find(j, "tob tobi") or string.find(j, "tobtobi") or string.find(j, "jerboa") or string.find(j, "fennec") or string.find(j, "camel") then return "Desert" end
        if string.find(j, "chimpanzee") or string.find(j, "toucan") or string.find(j, "crocodile") or string.find(j, "orangutini") or string.find(j, "ananassini") or string.find(j, "king snake") or string.find(j, "kingsnake") then return "Jungle" end
        if string.find(j, "duckling") or string.find(j, "catfish") or string.find(j, "turtle") or string.find(j, "trulimero") or string.find(j, "trulicina") or string.find(j, "swan") or string.find(j, "axolotl") or string.find(j, "leviathan") then return "Lake" end
        if string.find(j, "burrowing owl") or string.find(j, "burrowingowl") or string.find(j, "brr brr") or string.find(j, "patapim") or string.find(j, "chicken") or string.find(j, "dog") or string.find(j, "bird") or string.find(j, "raccoon") or string.find(j, "fox") then return "Forest" end
        if string.find(j, "shark") then return "Abyss Ocean" end
        if string.find(j, "snake") then return "Desert" end
        if string.find(j, "spider") then return "Jungle" end
        if string.find(j, "gorilla") then return "Jungle" end
        if string.find(j, "tiger") then return "Jungle" end
        if string.find(j, "frog") then return "Lake" end
        if string.find(j, "bear") then return "Forest" end
    end
    if (string.find(w, "light") and string.find(w, "dark")) or w == "lightdark" then return "Light Dark"
    elseif string.find(w, "titan") then return "Titan Temple"
    elseif string.find(w, "cherry") then return "Cherry Blossom"
    elseif string.find(w, "cosmic") then return "Cosmic"
    elseif string.find(w, "prehistoric") or string.find(w, "dino") then return "Prehistoric"
    elseif string.find(w, "abyss") or string.find(w, "ocean") then return "Abyss Ocean"
    elseif string.find(w, "volcano") or string.find(w, "lava") then return "Volcano"
    elseif string.find(w, "snow") or string.find(w, "ice") or string.find(w, "winter") then return "Snow"
    elseif string.find(w, "jungle") then return "Jungle"
    elseif string.find(w, "desert") or string.find(w, "sand") then return "Desert"
    elseif string.find(w, "lake") or string.find(w, "water") then return "Lake"
    elseif string.find(w, "forest") then return "Forest" end
    if u > 0 then
        if u >= 5200 then return "Light Dark"
        elseif u >= 4750 then return "Titan Temple"
        elseif u >= 4000 then return "Cherry Blossom"
        elseif u >= 3350 then return "Cosmic"
        elseif u >= 2780 then return "Prehistoric"
        elseif u >= 2250 then return "Abyss Ocean"
        elseif u >= 1850 then return "Volcano"
        elseif u >= 1450 then return "Snow"
        elseif u >= 1150 then return "Jungle"
        elseif u >= 920 then return "Desert"
        elseif u >= 720 then return "Lake"
        else return "Forest" end
    end
    return "Forest"
end

N4 = function()
    local e = h4(false)
    if not e or #e == 0 then e = h4(true) end
    if not e or #e == 0 then return nil end
    local y = o.Character
    local u = y and y:FindFirstChild("HumanoidRootPart")
    local w = u and u.Position or Vector3.new(525, 70, -360)
    local function j(e)
        e = tonumber(e) or 0
        if e >= 1000000000000 then return string.format("%.1fT", e/1000000000000) end
        if e >= 1000000000 then return string.format("%.1fB", e/1000000000) end
        if e >= 1000000 then return string.format("%.1fM", e/1000000) end
        if e >= 1000 then return string.format("%.1fK", e/1000) end
        return string.format("%.0f", e)
    end
    local function k(e, r, y, u)
        if e and e.PhysicalModel then
            local u = e.PhysicalModel
            local w = u:GetAttribute("Rarity") or u:GetAttribute("RarityTier") or u:GetAttribute("Tier")
            if w and (tostring(w) ~= "" and tostring(w) ~= "Unknown") then y = tostring(w) end
            if not r or r == "Egg" or r == "" then r = u:GetAttribute("Category") or u:GetAttribute("AssetCategory") or u.Name end
        end
        local w = string.lower(tostring(e.Rarity or ""))
        local j = string.lower(tostring(y or ""))
        for e, r in ipairs({w, j}) do
            if r ~= "" and (r ~= "unknown" and r ~= "nil") then
                if string.find(r, "divine") then return 6,"Divine" end
                if string.find(r, "eternal") then return 5,"Eternal" end
                if string.find(r, "secret") then return 4,"Secret" end
                if string.find(r, "cosmic") then return 3,"Cosmic" end
                if string.find(r, "mythic") then return 2,"Mythic" end
                if string.find(r, "legendary") then return 1,"Legendary" end
                if string.find(r, "epic") then return 0.5,"Epic" end
                if string.find(r, "rare") then return 0.3,"Rare" end
                if string.find(r, "uncommon") then return 0.1,"Uncommon" end
                if string.find(r, "common") then return 0,"Common" end
            end
        end
        if u and u >= 10 then return 6,"Divine"
        elseif u and u >= 9 then return 5,"Eternal"
        elseif u and u >= 8 then return 4,"Secret"
        elseif u and u >= 7 then return 3,"Cosmic"
        elseif u and u >= 6 then return 2,"Mythic"
        elseif u and u >= 5 then return 1,"Legendary"
        elseif u and u >= 4 then return 0.5,"Epic"
        elseif u and u >= 3 then return 0.3,"Rare"
        elseif u and u >= 2 then return 0.1,"Uncommon"
        elseif u and u >= 1 then return 0,"Common" end
        local k = string.lower(string.format("%s %s %s %s %s", tostring(r or ""), tostring(e.Uid or ""), tostring(e.Name or ""), tostring(e.DisplayName or ""), tostring(e.EggName or "")))
        if string.find(k, "nightflame") or string.find(k, "unicornegg") or string.find(k, "unicorn egg") or string.find(k, "shatteredcolossus") or string.find(k, "kitsune") or string.find(k, "elmaja") or string.find(k, "el maja") then return 6,"Divine" end
        if string.find(k, "gorillaking") or string.find(k, "gorilla king") or string.find(k, "lunardragon") or string.find(k, "lunar dragon") or string.find(k, "onitiger") or string.find(k, "oni tiger") or string.find(k, "mosasaurus") then return 5,"Eternal" end
        if string.find(k, "mutantshark") or string.find(k, "mutant shark") or string.find(k, "skeletonboss") or string.find(k, "skeleton boss") or string.find(k, "stagegg") or string.find(k, "stag egg") or string.find(k, "cosmicdragon") or string.find(k, "cosmic dragon") or string.find(k, "trex") or string.find(k, "t-rex") or string.find(k, "tralaledon") or string.find(k, "kraken") then return 4,"Secret" end
        if string.find(k, "saturnita") or string.find(k, "saturno") or string.find(k, "mantaris") or string.find(k, "rhinotaur") or string.find(k, "snowyowl") or string.find(k, "snowy owl") or string.find(k, "koiegg") or string.find(k, "koi egg") or string.find(k, "triceratops") or string.find(k, "bronto") or string.find(k, "whaleshark") or string.find(k, "whale shark") or string.find(k, "belugawhale") or string.find(k, "beluga whale") then return 3,"Cosmic" end
        if string.find(k, "bladehide") or string.find(k, "redpanda") or string.find(k, "red panda") or string.find(k, "cosmicgorilla") or string.find(k, "cosmic gorilla") or string.find(k, "ankylosaurus") or string.find(k, "orca") then return 2,"Mythic" end
        if string.find(k, "spideron") or string.find(k, "crustacia") or string.find(k, "salamander") or string.find(k, "cosmicgecko") or string.find(k, "cosmic gecko") or string.find(k, "pterodactyl") or string.find(k, "sharkegg") or string.find(k, "shark egg") then return 1,"Legendary" end
        if string.find(k, "crane") or string.find(k, "centapede") or string.find(k, "swordfish") then return 0.5,"Epic" end
        if string.find(k, "dodo") or string.find(k, "parrotfish") then return 0.3,"Rare" end
        local a = tonumber(e.EarningRate or e.Income or 0)
        if a and a >= 150000000 then return 4,"Secret" end
        local o = (y and (y ~= "Unknown" and y)) or "Common"
        local V = F[o] or 0
        return V, o
    end
    local function a2(r, y)
        local u2 = {}
        for e, r in ipairs(e) do
            local j = (r.State == "Slot" or r.State == "Dropped" or r.State == "GuardCarried" or r.State == 1)
            local a3 = (r.BoundsCFrame and r.BoundsCFrame.Position.X < 530) or string.find(tostring(r.Uid), "FirstArea")
            local o2 = X4[r.Uid] and (os.clock() < X4[r.Uid])
            if j and (not a3 and (((y or not o2)) and r.BoundsCFrame)) then
                local e2 = r.AssetCategory or "Egg"
                local y2 = 0
                local j2 = 0
                local a4 = 0
                local o3 = "Unknown"
                if p then
                    pcall(function()
                        if p.RarityRankForCategory then y2 = p.RarityRankForCategory(e2) or 0 end
                        if p.ProfileIncomePerSecond then j2 = p.ProfileIncomePerSecond(e2) or 0 end
                        if p.SalePrice then a4 = p.SalePrice(e2) or 0 end
                        if p.Assets and p.Assets[e2] then
                            local y3 = p.Assets[e2]
                            o3 = y3.Rarity or (y3.Egg and y3.Egg.Rarity) or "Unknown"
                            if not j2 or j2 == 0 then j2 = y3.EarningRate or (y3.Egg and y3.Egg.EarningRate) or 0 end
                        end
                    end)
                end
                local V3 = r.BoundsCFrame.Position.X
                local H3 = r.BoundsCFrame.Position
                local t3 = r.AreaId
                if ((not t3 or t3 == "" or t3 == "Unknown")) and r.PhysicalModel then
                    t3 = r.PhysicalModel:GetAttribute("AreaId") or r.PhysicalModel:GetAttribute("Area")
                end
                local B3 = string.format("%s %s %s %s", tostring(e2 or ""), tostring(r.Uid or ""), tostring(r.Name or ""), (r.PhysicalModel and r.PhysicalModel.Name) or "")
                local J2 = Dk(t3, H3, B3)
                local K2, c2 = k(r, e2, o3, y2)
                local v2 = (K2 >= 4 or c2 == "Secret" or c2 == "Eternal" or c2 == "Divine")
                -- ✅ Kalau filter kosong → anggap semua lolos
local zonesEmpty = true
if h.selectedZones then
    for _ in pairs(h.selectedZones) do zonesEmpty = false; break end
end
local rarEmpty = true
if h.selectedRarities then
    for _ in pairs(h.selectedRarities) do rarEmpty = false; break end
end

local i2 = zonesEmpty or (h.selectedZones and h.selectedZones[J2] == true)
local R2 = rarEmpty or (h.selectedRarities and h.selectedRarities[c2] == true)
                local g2 = false
                if v2 then g2 = true
                else if i2 and R2 then g2 = true end end
                if g2 then
                    local k3 = tonumber(r.AssetScale or r.Scale) or 1
                    local a5 = 1
                    if r.Mutations and type(r.Mutations) == "table" then
                        for e3, r3 in pairs(r.Mutations) do
                            local y3 = (type(r3) == "table" and tonumber(r3.Multiplier or r3.Value)) or tonumber(r3) or 1.5
                            a5 = a5 * y3
                        end
                    elseif r.Mutation then a5 = 1.5 end
                    local o4 = (j2 * k3) * a5
                    local V4v = f[J2] or 50
                    if o4 <= 0 then o4 = (((V4v^2)*k3)*a5)*10 end
                    local H4v = ((w - r.BoundsCFrame.Position)).Magnitude
                    table.insert(u2, { ["Uid"]=r.Uid, ["Category"]=tostring(e2), ["Area"]=tostring(J2), ["ZoneWeight"]=V4v, ["Rarity"]=tostring(c2), ["RarityTier"]=K2, ["Rank"]=y2, ["Income"]=j2, ["RealIncome"]=o4, ["Scale"]=k3, ["MutMultiplier"]=a5, ["CFrame"]=r.BoundsCFrame, ["Position"]=r.BoundsCFrame.Position, ["Distance"]=H4v, ["Model"]=r.PhysicalModel })
                end
            end
        end
        if #u2 == 0 then return nil end
        local function a3(e)
            local r = e.RarityTier or 0
            local y3 = e.ZoneWeight or 50
            if r >= 4 then return (400000 + (r*10000)) + y3
            else return (y3*11) + (r*1000) end
        end
        table.sort(u2, function(e, r)
            local y3 = a3(e)
            local u3 = a3(r)
            if y3 ~= u3 then return y3 > u3 end
            if e.ZoneWeight ~= r.ZoneWeight then return e.ZoneWeight > r.ZoneWeight end
            if math.abs(e.RealIncome - r.RealIncome) > 1 then return e.RealIncome > r.RealIncome end
            if math.abs(e.Scale - r.Scale) > 0.05 then return e.Scale > r.Scale end
            return e.Distance < r.Distance
        end)
        local o4 = u2[1]
        local V4v = {}
        for e2 = 1, math.min(3, #u2), 1 do
            local r2 = u2[e2]
            table.insert(V4v, string.format("#%d %s[%s|%s] Score:%d $%s/s (%.1fx) dist=%dm", e2, tostring(r2.Category), tostring(r2.Rarity), tostring(r2.Area), a3(r2), j(r2.RealIncome), tonumber(r2.Scale) or 1, math.floor(tonumber(r2.Distance) or 0)))
        end
        if #V4v > 0 then H("[AutoSteal v42.44] " .. table.concat(V4v, " | ")) end
        return o4
    end
    local V = a2(false, false)
    if not V then X4 = {}; V = a2(false, true) end
    if not V then e = h4(true); V = a2(false, true) end
    if V and r:FindFirstChild("AreaEggSlotsClient") then
        for e, r in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local y3 = r:FindFirstChildWhichIsA("BasePart") or r.PrimaryPart
            if y3 and ((y3.Position - V.Position)).Magnitude <= 12 then V.Model = r; break end
        end
    end
    return V
end

-- =========================================================
-- ✅ NEW: BIG SIZE EGG FINDER
-- Ambil egg dengan Scale paling besar di semua area
-- =========================================================
local function FindBiggestEgg()
    local allEggs = h4(false)
    if not allEggs or #allEggs == 0 then allEggs = h4(true) end
    if not allEggs or #allEggs == 0 then return nil end

    local char = o.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local myPos = hrp and hrp.Position or Vector3.new(525, 70, -360)

    local candidates = {}
    for _, egg in ipairs(allEggs) do
        -- Skip jika sudah diambil
        local onCooldown = X4[egg.Uid] and (os.clock() < X4[egg.Uid])
        local isValidState = (egg.State == "Slot" or egg.State == "Dropped" or egg.State == "GuardCarried" or egg.State == 1)
        local notBase = (egg.BoundsCFrame and egg.BoundsCFrame.Position.X >= 530) or string.find(tostring(egg.Uid), "FirstArea")
        local isNotBase = not string.find(tostring(egg.Uid), "FirstArea")
        local px = egg.BoundsCFrame and egg.BoundsCFrame.Position.X or 0
        local inField = px >= 530

        if isValidState and not onCooldown and egg.BoundsCFrame and inField and not string.find(tostring(egg.Uid), "FirstArea") then
            -- Ambil Scale
            local scale = tonumber(egg.AssetScale or egg.Scale) or 1
            if egg.PhysicalModel then
                local attr = egg.PhysicalModel:GetAttribute("Scale") or egg.PhysicalModel:GetAttribute("AssetScale")
                if attr then scale = tonumber(attr) or scale end
                -- Cek juga ukuran actual dari bounding box
                local ok2, size = pcall(function()
                    if egg.PhysicalModel:IsA("Model") then
                        local _, sz = egg.PhysicalModel:GetBoundingBox()
                        return sz
                    elseif egg.PhysicalModel:IsA("BasePart") then
                        return egg.PhysicalModel.Size
                    end
                end)
                if ok2 and size then
                    local vol = size.X * size.Y * size.Z
                    -- Kombinasikan scale attr dengan volume actual
                    scale = math.max(scale, vol / 100)
                end
            end
            table.insert(candidates, {
                egg = egg,
                scale = scale,
                distance = ((myPos - egg.BoundsCFrame.Position)).Magnitude,
            })
        end
    end

    if #candidates == 0 then return nil end

    -- Sort: Scale terbesar dulu, lalu jarak terdekat
    table.sort(candidates, function(a, b)
        if math.abs(a.scale - b.scale) > 0.05 then
            return a.scale > b.scale
        end
        return a.distance < b.distance
    end)

    local best = candidates[1]
    return {
        Uid = best.egg.Uid,
        Category = best.egg.AssetCategory or "Egg",
        CFrame = best.egg.BoundsCFrame,
        Position = best.egg.BoundsCFrame.Position,
        Scale = best.scale,
        Area = best.egg.AreaId or "Unknown",
        Distance = best.distance,
        Model = best.egg.PhysicalModel,
    }
end

-- =========================================================
-- ✅ NEW: STEAL + AUTO TREADMILL
-- Loop: jika ada egg target → ambil. Jika tidak ada → treadmill.
-- =========================================================
task.spawn(function()
    while h.alive do
        if h.stealAutoTreadmill then
            local ok2, err = pcall(function()
                local char = o.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                if h.securingEgg or h.teleporting or h.glidingToTarget or h.isReturning or h.isBatchPlacing then return end

                local target = N4()
                if target then
                    -- Ada egg → keluar treadmill dulu
                    if h.onTreadmill or L4() then
                        h.statusText = "[Steal+Treadmill] Target found! Getting off treadmill..."
                        M4()
                        task.wait(0.15)
                    end

                    local sessionId = O4
                    local uid = target.Uid
                    local ok3, reason = k4(uid)
                    if not ok3 and reason ~= "CarriedBySelf" then
                        X4[uid] = os.clock() + 5
                        return
                    end

                    if not h.swapped then A4() end
                    if not h.godmode then b4(true) end
                    Z4(char)
                    pcall(function() o:RequestStreamAroundAsync(target.Position) end)

                    local dest = target.CFrame * CFrame.new(0, 0.4, 0)
                    h.currentTargetModel = target.Model
                    h.targetPosition = target.Position
                    h.glidingToTarget = true
                    local ok4 = R4(dest, h.glideSpeed, uid, sessionId)
                    h.glidingToTarget = false
                    if O4 ~= sessionId or not h.stealAutoTreadmill then return end
                    if not ok4 then
                        X4[uid] = os.clock() + 5
                        return
                    end

                    if ((hrp.Position - target.Position)).Magnitude <= 22 then
                        local secured = U4(uid, dest, target.Model, sessionId)
                        if O4 ~= sessionId or not h.stealAutoTreadmill then return end
                        if secured then
                            pcall(u4)
                            h.statusText = "[Steal+Treadmill] Secured! Back to treadmill..."
                            H("[Steal+Treadmill] Egg secured! Auto-returning to treadmill.")
                            Q4(h.glideSpeed, sessionId)
                            pcall(u4)
                            h.isReturning = false; h.delivering = false
                            h.glidingToTarget = false; h.securingEgg = false
                            h.currentTargetModel = nil; h.targetPosition = nil
                            task.wait(0.2)
                            -- Mount treadmill
                            if h.stealAutoTreadmill then
                                f4(sessionId)
                            end
                        else
                            X4[uid] = os.clock() + 5
                        end
                    end
                else
                    -- Tidak ada egg → naik treadmill
                    if not h.onTreadmill and not L4() then
                        h.statusText = "[Steal+Treadmill] No target. Mounting treadmill..."
                        f4()
                    else
                        h.statusText = "[Steal+Treadmill] Running (Waiting for eggs...)"
                    end
                end
            end)
            if not ok2 then
                t("[Steal+Treadmill] Recovered:", tostring(err))
                pcall(D4)
            end
            task.wait(0.15)
        else
            task.wait(0.3)
        end
    end
end)

-- =========================================================
-- ✅ NEW: AUTO STEAL BIG SIZE — TWEEN
-- Ambil egg dengan size paling besar di semua area
-- =========================================================
task.spawn(function()
    local CkBig = os.clock()
    while h.alive do
        if h.autoStealBigSize then
            local ok2, err = pcall(function()
                local char = o.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if not hrp or not hum then return end
                if h.securingEgg or h.teleporting or h.glidingToTarget or h.isReturning or h.isBatchPlacing then return end
                if w4() then return end

                local target = FindBiggestEgg()
                if not target then
                    if os.clock() - CkBig > 5 then X4 = {}; CkBig = os.clock() end
                    if h.autoTreadmill and not h.onTreadmill and not L4() then
                        h.statusText = "[BigSize] No target. Mounting treadmill..."
                        f4()
                    else
                        h.statusText = "[BigSize] Scanning for big eggs..."
                    end
                    return
                end

                -- Keluar treadmill jika perlu
                if h.onTreadmill or L4() then
                    h.statusText = "[BigSize] Big egg found! Getting off treadmill..."
                    M4()
                    task.wait(0.15)
                end

                local sessionId = O4
                local uid = target.Uid
                local ok3, reason = k4(uid)
                if not ok3 and reason ~= "CarriedBySelf" then
                    H(string.format("[BigSize] Egg %s already taken (%s). Next...", tostring(uid), tostring(reason)))
                    X4[uid] = os.clock() + 5
                    task.wait(0.15)
                    return
                end

                if not h.swapped then A4() end
                if not h.godmode then b4(true) end
                Z4(char)
                pcall(function() o:RequestStreamAroundAsync(target.Position) end)

                h.currentTargetModel = target.Model
                h.targetPosition = target.Position
                h.glidingToTarget = true
                h.stateTime = os.clock()

                h.statusText = string.format("[BigSize] Flying to %s (%.1fx | %s | dist %d)...",
                    tostring(target.Category), tonumber(target.Scale) or 1,
                    tostring(target.Area), math.floor(target.Distance))
                H(string.format("[BigSize] Target: %s | Scale=%.2fx | Zone=%s | dist=%d",
                    tostring(target.Category), tonumber(target.Scale) or 1,
                    tostring(target.Area), math.floor(target.Distance)))

                local dest = target.CFrame * CFrame.new(0, 0.4, 0)
                local ok4 = R4(dest, h.glideSpeed, uid, sessionId)
                h.glidingToTarget = false
                if O4 ~= sessionId or not h.autoStealBigSize then return end

                if not ok4 then
                    t("[BigSize] Big egg was taken during flight.")
                    X4[uid] = os.clock() + 5
                    D4()
                    return
                end

                if h.autoStealBigSize and ((hrp.Position - target.Position)).Magnitude <= 22 then
                    local secured = U4(uid, dest, target.Model, sessionId)
                    if O4 ~= sessionId or not h.autoStealBigSize then return end
                    if secured then
                        pcall(u4)
                        if h.autoGlide then
                            h.statusText = "[BigSize] Secured! Returning to safe line..."
                            Q4(h.glideSpeed, sessionId)
                            pcall(u4)
                        end
                        h.isReturning = false; h.delivering = false
                        h.glidingToTarget = false; h.securingEgg = false
                        h.currentTargetModel = nil; h.targetPosition = nil
                        local count = y4()
                        h.statusText = string.format("[BigSize] Stashed (%d eggs). Next big egg...", count)
                    else
                        X4[uid] = os.clock() + 5
                        D4()
                    end
                end
            end)
            if not ok2 then
                t("[BigSize] Recovered:", tostring(err))
                pcall(D4)
            end
            task.wait(0.1)
        else
            task.wait(0.3)
        end
    end
end)

U4 = function(e, u, w, jj)
    local k2 = o.Character
    local a2 = k2 and k2:FindFirstChild("HumanoidRootPart")
    local V2 = k2 and k2:FindFirstChildOfClass("Humanoid")
    if not a2 or not V2 then return false end
    h.securingEgg = true; h.isReturning = false
    h.stateTime = os.clock()
    h.holdingEggForGuard = true
    local s2 = u.Position
    V4(s2, 14)
    h.currentTargetModel = w
    h.targetPosition = s2
    a2.AssemblyLinearVelocity = Vector3.zero
    a2.AssemblyAngularVelocity = Vector3.zero
    Z4(k2)
    pcall(function() o:RequestStreamAroundAsync(s2) end)
    if not w and r:FindFirstChild("AreaEggSlotsClient") then
        for e2, r2 in ipairs(r.AreaEggSlotsClient:GetChildren()) do
            local y3 = r2:FindFirstChildWhichIsA("BasePart") or r2.PrimaryPart
            if y3 and ((y3.Position - s2)).Magnitude <= 16 then w = r2; h.currentTargetModel = r2; break end
        end
    end
    if w then
        pcall(function()
            for r2, y3 in ipairs(w:GetDescendants()) do
                if y3:IsA("BasePart") and (y3.Transparency > 0.8 and (y3.Name ~= "Hitbox" and (y3.Name ~= "Root" and not y3.Name:find("Pad")))) then y3.Transparency = 0 end
            end
        end)
    end
    h.statusText = "[1/4] Lifting Egg to Trigger Guard..."
    H(string.format("[GuardStrike] Step 1: Lifting target egg (%s)...", tostring(e)))
    local p2 = os.clock() + 3.5
    local B2 = 0
    while not w4() and (os.clock() < p2 and (h.alive and h.securingEgg)) do
        if jj and O4 ~= jj then t("[GuardStrike] Cancelled by session switch in Step 1") break end
        if not h.pureTweenFarm and (not h.autoFarmLoop and (not h.teleporting and (not h.stealAutoTreadmill and not h.autoStealBigSize))) then break end
        if e and (os.clock() - B2 > 0.4) then
            B2 = os.clock()
            local r2, y3 = k4(e)
            if not r2 and y3 == "CarriedByOther" then t(string.format("[GuardStrike] Target egg %s was snatched!", tostring(e))) break end
        end
        k2:PivotTo(u * CFrame.new(0, 0.4, 0))
        d4(w, s2)
        if e and i then
            task.spawn(function()
                pcall(function()
                    if i:IsA("RemoteFunction") then i:InvokeServer({ ["Uid"]=e }); i:InvokeServer(e)
                    else i:FireServer({ ["Uid"]=e }); i:FireServer(e) end
                end)
            end)
        end
        y.Heartbeat:Wait()
    end
    if not w4() then
        t("[GuardStrike] Initial egg pickup timed out or egg was stolen")
        if e then X4[e] = os.clock() + 2 end
        h.currentTargetModel = nil; h.targetPosition = nil
        h.securingEgg = false; h.holdingEggForGuard = false
        return false
    end
    h.statusText = "[2/4] Waiting for Guard Strike..."
    H("[GuardStrike] Step 2: Egg lifted! Triggering guard strike...")
    local J2 = os.clock()
    local K2 = J2 + 4.5
    local c2 = false
    while w4() and (os.clock() < K2 and (h.alive and h.securingEgg)) do
        if jj and O4 ~= jj then t("[GuardStrike] Cancelled by session switch in Step 2") break end
        if not h.pureTweenFarm and (not h.autoFarmLoop and (not h.teleporting and (not h.stealAutoTreadmill and not h.autoStealBigSize))) then break end
        k2:PivotTo(u * CFrame.new(0, 0.4, 0))
        V4(s2, 14)
        if P and not c2 then
            task.spawn(function()
                pcall(function()
                    if P:IsA("RemoteFunction") then P:InvokeServer()
                    else P:FireServer() end
                end)
            end)
            c2 = true
        end
        y.Heartbeat:Wait()
    end
    h.statusText = "[3/4] Re-grabbing Egg..."
    H("[GuardStrike] Step 3: Guard struck! Re-grabbing egg...")
    local v2 = os.clock() + 3
    while not w4() and (os.clock() < v2 and (h.alive and h.securingEgg)) do
        if jj and O4 ~= jj then t("[GuardStrike] Cancelled by session switch in Step 3") break end
        if not h.pureTweenFarm and (not h.autoFarmLoop and (not h.teleporting and (not h.stealAutoTreadmill and not h.autoStealBigSize))) then break end
        k2:PivotTo(u * CFrame.new(0, 0.4, 0))
        d4(w, s2)
        if e and i then
            task.spawn(function()
                pcall(function()
                    if i:IsA("RemoteFunction") then i:InvokeServer({ ["Uid"]=e }); i:InvokeServer(e)
                    else i:FireServer({ ["Uid"]=e }); i:FireServer(e) end
                end)
            end)
        end
        y.Heartbeat:Wait()
    end
    local R2 = j4(e)
    if not R2 then task.wait(0.12); R2 = j4(e) end
    h.currentTargetModel = nil; h.targetPosition = nil
    h.securingEgg = false; h.holdingEggForGuard = false
    if jj and O4 ~= jj then return false end
    if R2 then
        pcall(u4)
        H("[GuardStrike] Egg secured! Stashed in backpack.")
        h.statusText = "Egg Secured! Tweening along Z=-360..."
    else
        t("[-] Failed to re-grab egg after guard strike")
        h.statusText = "[-] Failed to re-grab egg"
        if e then X4[e] = os.clock() + 2 end
    end
    return R2
end

l4 = function(e, u)
    if h.teleporting or h.glidingToTarget or h.delivering or h.securingEgg then return false end
    h.teleporting = true; h.isReturning = false
    h.stateTime = os.clock()
    local w = o.Character
    local j2 = w and w:FindFirstChild("HumanoidRootPart")
    local k2 = w and w:FindFirstChildOfClass("Humanoid")
    if not j2 or not k2 then D4(); return false end
    if k2 then k2:UnequipTools() end
    h.statusText = "[1/7] Pre-Flight Desync..."
    if not h.swapped then A4() end
    if not h.godmode then b4(true) end
    Z4(w)
    if not e then e = N4() end
    local a2 = e and e.CFrame or S
    local V2 = e and e.Uid
    local H2 = a2.Position
    if V2 then
        local e3, r2 = k4(V2)
        if not e3 and r2 ~= "CarriedBySelf" then
            t(string.format("[Snipe] Target egg %s already taken (%s)!", tostring(V2), tostring(r2)))
            h.statusText = "Target taken by another player!"
            X4[V2] = os.clock() + 5
            D4(); return false
        end
    end
    local s2 = select(2, e4())
    if not s2 then
        local e3 = P4()
        if not e3 then
            t("[-] Lake egg not found")
            h.statusText = "[-] No Lake egg found"
            D4(); return false
        end
        h.currentTargetModel = e3.Model
        h.targetPosition = e3.Position
        local r2 = ((j2.Position - e3.Position)).Magnitude
        local w2 = e3.CFrame * CFrame.new(0, 0.4, 0)
        pcall(function() o:RequestStreamAroundAsync(e3.Position) end)
        V4(e3.Position, 8)
        if r2 > 60 then
            h.statusText = string.format("[2/7] Gliding to Lake Egg (%.0f studs)...", r2)
            h.glidingToTarget = true
            local y3 = R4(w2, h.glideSpeed, e3.Uid, u)
            h.glidingToTarget = false
            if not y3 then
                t("[-] Lake starter egg was taken during flight")
                X4[e3.Uid] = os.clock() + 5
                D4(); return false
            end
        else
            h.statusText = "[2/7] Aligning with Lake Egg..."
            j2.CFrame = w2
            j2.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.04)
        end
        j2.Anchored = true
        task.wait(0.06)
        j2.Anchored = false
        h.holdingEggForGuard = true
        local k3 = os.clock() + 3
        while not w4() and (os.clock() < k3 and (h.alive and h.teleporting)) do
            if u and O4 ~= u then
                t("[Snipe] Cancelled by session switch during Lake egg pickup")
                D4(); return false
            end
            if not h.autoFarmLoop and not h.teleporting then D4(); return false end
            d4(e3.Model, e3.Position)
            if e3.Uid and i then
                task.spawn(function()
                    pcall(function()
                        if i:IsA("RemoteFunction") then i:InvokeServer({ ["Uid"]=e3.Uid })
                        else i:FireServer({ ["Uid"]=e3.Uid }) end
                    end)
                end)
            end
            y.Heartbeat:Wait()
        end
        s2 = select(2, e4())
        if not w4() then
            t("[-] Lake egg pickup failed")
            h.statusText = "[-] Lake pickup failed"
            D4(); return false
        end
    end
    h.statusText = "[3/7] Pre-streaming Target..."
    pcall(function() o:RequestStreamAroundAsync(H2) end)
    V4(H2, 12)
    h.statusText = "[4/7] Waiting for physical bounce..."
    j2.Anchored = false
    k2:ChangeState(Enum.HumanoidStateType.Running)
    local p2 = (k2.WalkSpeed > 0) and k2.WalkSpeed or 16
    k2.WalkSpeed = 0
    k2:Move(Vector3.zero, false)
    j2.AssemblyLinearVelocity = Vector3.zero
    j2.AssemblyAngularVelocity = Vector3.zero
    task.wait(0.04)
    local B2 = j2.Position
    local J2 = B2.Y
    local K2 = select(2, e4()) or s2
    local c2 = false
    local v2 = nil
    if N and N:IsA("RemoteEvent") then
        v2 = N.OnClientEvent:Connect(function()
            c2 = true
            if v2 then v2:Disconnect() end
        end)
    end
    h.holdingEggForGuard = true
    H4(K2)
    local R2 = os.clock()
    local g2 = false
    local Q2 = os.clock() + 2.5
    local P2 = false
    while os.clock() < Q2 and (h.alive and h.teleporting) do
        if u and O4 ~= u then
            t("[Snipe] Cancelled by session switch during strike bounce")
            if v2 then v2:Disconnect() end
            k2.WalkSpeed = p2
            D4(); return false
        end
        local e3 = os.clock() - R2
        local r2 = j2.AssemblyLinearVelocity
        local w2 = j2.Position
        local a3 = w2.Y - J2
        local o2 = ((w2 - B2)).Magnitude
        if e3 >= 0.08 then
            local e4v = c2 or (r2.Y >= 10) or (a3 >= 1.5 and r2.Magnitude >= 16) or (o2 >= 2) or (r2.Magnitude >= 20)
            if e4v then g2 = true; break end
        end
        if e3 >= 0.5 and not P2 then P2 = true; H4(K2) end
        y.Heartbeat:Wait()
    end
    if v2 then v2:Disconnect() end
    k2.WalkSpeed = p2
    h.holdingEggForGuard = false
    if not g2 then
        t("[-] No bounce detected, aborting")
        h.statusText = "[-] Aborted (No bounce detected)"
        D4(); pcall(u4); return false
    end
    task.wait(0.05)
    if V2 then
        local e3, r2 = k4(V2)
        if not e3 and r2 == "CarriedByOther" then
            t(string.format("[Snipe] Target egg %s was snatched while bouncing!", tostring(V2)))
            h.statusText = "Target taken! Aborting warp..."
            X4[V2] = os.clock() + 5
            D4(); return false
        end
    end
    h.currentTargetModel = e and e.Model
    h.targetPosition = H2
    h.statusText = "[5/7] Warping to Target Egg..."
    V4(H2, 8)
    w:PivotTo(a2 * CFrame.new(0, 0.4, 0))
    j2.Anchored = true
    for e3, r2 in ipairs(w:GetDescendants()) do
        if r2:IsA("BasePart") then
            r2.AssemblyLinearVelocity = Vector3.zero
            r2.AssemblyAngularVelocity = Vector3.zero
        end
    end
    h.statusText = "[6/7] Picking up Target Egg..."
    local U2 = o:FindFirstChild("Backpack")
    for e3, y3 in ipairs(w:GetChildren()) do
        if y3:IsA("Tool") then
            pcall(function()
                if U2 then y3.Parent = U2
                else y3.Parent = r end
            end)
        end
    end
    task.wait(0.06)
    j2.Anchored = false
    k2:ChangeState(Enum.HumanoidStateType.Running)
    local l2 = U4(V2, a2, e and e.Model, u)
    j2.Anchored = false
    k2:ChangeState(Enum.HumanoidStateType.Running)
    for e3, r2 in ipairs(w:GetDescendants()) do
        if r2:IsA("BasePart") then
            r2.AssemblyLinearVelocity = Vector3.zero
            r2.AssemblyAngularVelocity = Vector3.zero
        end
    end
    if not l2 then
        t("[-] Guard Strike criteria not met")
        h.statusText = "[-] Guard Strike criteria failed"
        D4(); return false
    else
        h.statusText = "[7/7] Target Secured! Stashing into Backpack..."
        h.teleporting = false
        pcall(u4)
        return true
    end
end

T4 = function(e)
    if Y4 == e then return end
    O4 = O4 + 1
    local r2 = O4
    Y4 = "SWITCHING"
    h.pureTweenFarm = false
    h.autoFarmLoop = false
    pcall(D4)
    pcall(u4)
    if e == "TWEEN" then
        if W4 then W4(false, true) end
        if x4 then x4(true, true) end
    elseif e == "WARP" then
        if x4 then x4(false, true) end
        if W4 then W4(true, true) end
    else
        if x4 then x4(false, true) end
        if W4 then W4(false, true) end
    end
    task.delay(0.06, function()
        if O4 == r2 then
            Y4 = e
            if e == "TWEEN" then
                h.pureTweenFarm = true; h.autoFarmLoop = false
                pcall(u4)
                H("[FarmController] Pure Auto Steal (Tween) ACTIVATED exclusively.")
            elseif e == "WARP" then
                h.autoFarmLoop = true; h.pureTweenFarm = false
                pcall(u4)
                H("[FarmController] Snipe Auto Loop (Warp) ACTIVATED exclusively.")
            else
                h.pureTweenFarm = false; h.autoFarmLoop = false
                if not h.isBatchPlacing then h.batchStealCount = 0 end
                pcall(restoreNormalHumanoid)
                H("[FarmController] All farms DEACTIVATED. Karakter kembali normal.")
            end
        end
    end)
end

-- =========== MAIN LOOPS ===========
local Ck = os.clock()
task.spawn(function()
    while h.alive do
        local r2, y2 = pcall(function()
            if h.pureTweenFarm and (not h.autoFarmLoop and (Y4 == "TWEEN" and (not h.isBatchPlacing and (not h.teleporting and (not h.glidingToTarget and (not h.securingEgg and (not h.delivering and not h.isReturning))))))) then
                local r3 = o.Character
                local y3 = r3 and r3:FindFirstChild("HumanoidRootPart")
                local u3 = r3 and r3:FindFirstChildOfClass("Humanoid")
                if y3 and u3 then
                    pcall(u4)
                    local u4v = w4()
                    if not u4v then
                        local u4v2 = O4
                        local w3 = N4()
                        if w3 and (h.pureTweenFarm and (Y4 == "TWEEN" and O4 == u4v2)) then
                            if h.onTreadmill or L4() then
                                h.statusText = "[AutoSteal] Target found! Getting off treadmill..."
                                M4()
                                task.wait(0.08)
                            end
                            local j2, k2 = k4(w3.Uid)
                            if not j2 and k2 ~= "CarriedBySelf" then
                                H(string.format("[AutoSteal] Egg %s already taken (%s). Next...", tostring(w3.Uid), tostring(k2)))
                                X4[w3.Uid] = os.clock() + 5
                                task.wait(0.12)
                                return
                            end
                            h.currentTargetModel = w3.Model
                            h.targetPosition = w3.Position
                            h.glidingToTarget = true
                            h.stateTime = os.clock()
                            local a2 = ((w3.Scale and w3.Scale > 1.05)) and string.format(" | %.1fx", w3.Scale) or ""
                            h.statusText = string.format("[AutoSteal] Flying to %s (%s%s)...", tostring(w3.Category or "Egg"), tostring(w3.Area or "Field"), a2)
                            H(string.format("[AutoSteal] Flying to %s | Zone: %s%s | Rank: %d", tostring(w3.Category or "Egg"), tostring(w3.Area or "Field"), a2, tonumber(w3.Rank) or 1))
                            if not h.swapped then A4() end
                            if not h.godmode then b4(true) end
                            Z4(r3)
                            pcall(function() o:RequestStreamAroundAsync(w3.Position) end)
                            local V2 = w3.CFrame * CFrame.new(0, 0.4, 0)
                            local s2 = R4(V2, h.glideSpeed, w3.Uid, u4v2)
                            h.glidingToTarget = false
                            if O4 ~= u4v2 or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                            if not s2 then
                                t("[AutoSteal] Egg was taken during flight.")
                                X4[w3.Uid] = os.clock() + 5
                                D4(); return
                            end
                            if h.pureTweenFarm and (Y4 == "TWEEN" and ((y3.Position - w3.Position)).Magnitude <= 22) then
                                local r4 = U4(w3.Uid, V2, w3.Model, u4v2)
                                if not r4 and w4() then r4 = true end
                                if O4 ~= u4v2 or not h.pureTweenFarm or Y4 ~= "TWEEN" then return end
                                if r4 then
                                    pcall(u4)
                                    if h.autoGlide then
                                        h.statusText = "[AutoSteal] Secured! Tweening to Safe Line X=525..."
                                        H("[AutoSteal] Egg secured! Returning to Safe Line X=525...")
                                        Q4(h.glideSpeed, u4v2)
                                        pcall(u4)
                                        local r5 = y4()
                                        h.statusText = string.format("Stashed in Bag (%d Eggs). Next steal...", r5)
                                        H(string.format("[AutoSteal] Stashed in bag (%d eggs).", r5))
                                    else
                                        h.statusText = "[AutoSteal] Secured! (Auto Return OFF)"
                                        H("[AutoSteal] Egg secured! Staying at target (Auto Return OFF).")
                                    end
                                    pcall(u4)
                                    h.isReturning = false; h.delivering = false
                                    h.glidingToTarget = false; h.securingEgg = false
                                    h.currentTargetModel = nil; h.targetPosition = nil
                                    if c4("TWEEN") then return end
                                else
                                    if O4 == u4v2 and (h.pureTweenFarm and Y4 == "TWEEN") then
                                        t("[AutoSteal] Guard Strike failed. Retrying...")
                                        X4[w3.Uid] = os.clock() + 5
                                        D4()
                                    end
                                end
                            else
                                h.currentTargetModel = nil; h.targetPosition = nil
                                h.glidingToTarget = false
                            end
                        else
                            if os.clock() - Ck > 5 then X4 = {}; Ck = os.clock() end
                            if h.autoTreadmill and (not h.isBatchPlacing and not h.isHatching) then
                                if not h.onTreadmill and not L4() then
                                    h.statusText = "[AutoTreadmill] No targets. Mounting..."
                                    f4(u4v)
                                else
                                    h.statusText = "[AutoTreadmill] Running (Waiting for eggs...)"
                                end
                            else
                                h.statusText = "[AutoSteal] Scanning for targets..."
                            end
                        end
                    end
                end
            end
        end)
        if not r2 then
            t("[AutoSteal Loop Recovered]:", tostring(y2))
            pcall(D4)
        end
        task.wait(0.08)
    end
end)

local qk = os.clock()
task.spawn(function()
    while h.alive do
        local r2, y2 = pcall(function()
            if h.autoFarmLoop and (not h.pureTweenFarm and (Y4 == "WARP" and (not h.isBatchPlacing and (not h.teleporting and (not h.glidingToTarget and (not h.securingEgg and (not h.delivering and not h.isReturning))))))) then
                local r3 = o.Character
                local y3 = r3 and r3:FindFirstChild("HumanoidRootPart")
                local u3 = r3 and r3:FindFirstChildOfClass("Humanoid")
                if y3 and u3 then
                    pcall(u4)
                    local r4 = w4()
                    if not r4 then
                        local r5 = O4
                        local y4v = N4()
                        if y4v and (h.autoFarmLoop and (Y4 == "WARP" and O4 == r5)) then
                            if h.onTreadmill or L4() then
                                h.statusText = "[SnipeLoop] Target found! Getting off treadmill..."
                                M4()
                                task.wait(0.08)
                            end
                            local u4v = ((y4v.Scale and y4v.Scale > 1.05)) and string.format(" | %.1fx", y4v.Scale) or ""
                            H(string.format("[SnipeLoop] Starting Warp Snipe: %s | Zone: %s%s (Rank %d)", tostring(y4v.Category or "Egg"), tostring(y4v.Area or "Field"), u4v, tonumber(y4v.Rank) or 1))
                            h.statusText = string.format("[SnipeLoop] Warping for %s%s...", tostring(y4v.Category or "Egg"), u4v)
                            local w3 = l4(y4v, r5)
                            if O4 ~= r5 or not h.autoFarmLoop or Y4 ~= "WARP" then return end
                            if w3 then
                                pcall(u4)
                                if h.autoGlide then
                                    h.statusText = "[SnipeLoop] Target secured! Tweening to Safe Line X=525..."
                                    Q4(h.glideSpeed, r5)
                                    pcall(u4)
                                    local y5 = y4()
                                    h.statusText = string.format("Stashed in Bag (%d Eggs). Next snipe...", y5)
                                    H(string.format("[SnipeLoop] Egg stashed in bag (%d eggs).", y5))
                                else
                                    h.statusText = "[SnipeLoop] Target secured! (Auto Return OFF)"
                                    H("[SnipeLoop] Snipe successful! Staying (Auto Return OFF).")
                                end
                                pcall(u4)
                                h.isReturning = false; h.delivering = false
                                if c4("WARP") then return end
                            else
                                if O4 == r5 and (h.autoFarmLoop and Y4 == "WARP") then
                                    t("[SnipeLoop] Snipe cycle failed. Resetting...")
                                    if y4v and y4v.Uid then X4[y4v.Uid] = os.clock() + 5 end
                                    pcall(D4)
                                end
                            end
                        else
                            if os.clock() - qk > 5 then X4 = {}; qk = os.clock() end
                            if h.autoTreadmill and (not h.isBatchPlacing and not h.isHatching) then
                                if not h.onTreadmill and not L4() then
                                    h.statusText = "[AutoTreadmill] No targets. Mounting..."
                                    f4(r4)
                                else
                                    h.statusText = "[AutoTreadmill] Running (Waiting for eggs...)"
                                end
                            else
                                h.statusText = "[SnipeLoop] Searching for targets..."
                            end
                        end
                    end
                end
            end
        end)
        if not r2 then
            t("[SnipeLoop Loop Recovered]:", tostring(y2))
            pcall(D4)
        end
        task.wait(0.08)
    end
end)

task.spawn(function()
    while h.alive do
        local r2, y2 = pcall(function()
            if h.autoTreadmill and (not h.pureTweenFarm and (not h.autoFarmLoop and (not h.isBatchPlacing and (not h.isHatching and (not h.teleporting and (not h.glidingToTarget and (not h.securingEgg and (not h.delivering and not h.isReturning)))))))) then
                local e2 = o.Character
                local y3 = e2 and e2:FindFirstChild("HumanoidRootPart")
                if y3 and not w4() then
                    if not h.onTreadmill and not L4() then
                        h.statusText = "[AutoTreadmill] Idle without farm. Mounting..."
                        f4()
                    end
                end
            end
        end)
        if not r2 then t("[Treadmill Idle Loop Recovered]:", tostring(y2)) end
        task.wait(0.5)
    end
end)

task.spawn(function()
    while h.alive do
        pcall(function()
            if h.autoUpgradeTreadmill then pk() end
        end)
        task.wait(5)
        pcall(function()
            if h.autoBuyTrails then gk() end
        end)
        task.wait(5)
    end
end)

task.spawn(function()
    while h.alive do
        if h.autoHatch and (not h.securingEgg and (not h.teleporting and not h.isHatching)) then
            pcall(function() J4(false) end)
        end
        task.wait(4)
    end
end)

-- =========================================================
-- ✅ AUTO KILL SCRAMBLE — FAST KILL + INSTANT SWITCH
-- Lebih cepat, langsung pindah drone saat HP = 0
-- =========================================================
local SCRAMBLE_ZONES = {
    { name = "Abyss Ocean",    x = 2250, z = -360 },
    { name = "Prehistoric",    x = 2780, z = -360 },
    { name = "Cosmic",         x = 3350, z = -360 },
    { name = "Cherry Blossom", x = 4000, z = -360 },
    { name = "Titan Temple",   x = 4750, z = -360 },
    { name = "Light Dark",     x = 5200, z = -360 },
}

local function parseScrambleHp(obj)
    local maxHp, curHp = nil, nil
    for _, desc in ipairs(obj:GetDescendants()) do
        if desc:IsA("TextLabel") then
            local text = tostring(desc.Text or "")
            local a, b = string.match(text, "(%d+)%s*/%s*(%d+)")
            if a and b then
                curHp = tonumber(a)
                maxHp = tonumber(b)
                break
            end
            local c = string.match(text, "(%d+)%s*[Hh][Pp]")
            if c then
                maxHp = tonumber(c)
                curHp = maxHp
                break
            end
        end
    end
    return maxHp, curHp
end

task.spawn(function()
    local sessionStart = os.clock()
    local sessionHits = 0
    local sessionMaxHits = 12       -- dinaikkan (dari 8) supaya lebih agresif
    local sessionCooldown = 18      -- diturunkan (dari 25) supaya lebih cepat re-engage
    local hitCooldown = 0.01        -- diturunkan (dari 0.6) supaya gebuk lebih cepat
    local hitRange = 8              -- dinaikkan (dari 7) supaya bisa hit dari lebih jauh
    local travelSpeed = 320         -- dinaikkan (dari 250) supaya fly lebih cepat
    local scanCooldown = 1.2        -- diturunkan (dari 0.4) supaya scan lebih cepat
    local lastScan = 0
    local lastScanLog = 0
    -- ✅ Track drone yang sudah di-kill supaya tidak diserang ulang sebelum visual hilang
    local killedDrones = {}  -- [uid] = os.clock() (waktu kapan di-kill)

    local function scrambleFly(targetPos, speed, timeout)
        local char = o.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp then return false end
        speed = h._origWalkSpeed
        timeout = timeout or 30
        h.scrambleFlyLock = true
        if hum then hum.AutoRotate = false end
        local deadline = os.clock() + timeout
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        pcall(function() o:RequestStreamAroundAsync(targetPos) end)
        while h.alive and h.autoKillScramble and os.clock() < deadline do
            local pos = hrp.Position
            local diff = targetPos - pos
            local dist = diff.Magnitude
            if dist <= 4 then break end
            local step = speed * y.Heartbeat:Wait()
            if step >= dist then
                hrp.CFrame = CFrame.new(targetPos)
                break
            end
            local dir = diff.Unit
            local newPos = pos + dir * step
            hrp.CFrame = CFrame.lookAt(newPos, newPos + dir)
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        hrp.CFrame = CFrame.new(targetPos)
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        if hum then hum.AutoRotate = true end
        h.scrambleFlyLock = false
        return true
    end

    local function scanScrambleVisuals()
        local visuals = r:FindFirstChild("ScrambleLocalVisuals")
        if not visuals then return {} end
        local char = o.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return {} end

        local filter = h.scrambleHpFilter or { ["3"] = true, ["5"] = true, ["10"] = true }
        local filterStr = {}
        for k, v in pairs(filter) do if v then table.insert(filterStr, k) end end
        local filterDisplay = table.concat(filterStr, ",")

        local found = {}
        local allScanned = {}
        for _, obj in ipairs(visuals:GetDescendants()) do
            if obj:IsA("Model") or obj:IsA("BasePart") then
                local name = tostring(obj.Name)
                if string.find(name, "DroneVisual") or string.find(name, "Scramble") or string.find(name, "Drone") then
                    local maxHp, curHp = parseScrambleHp(obj)
                    local pos = nil
                    if obj:IsA("Model") then
                        local ok2, pivot = pcall(function() return obj:GetPivot() end)
                        if ok2 and pivot then pos = pivot.Position end
                    else
                        pos = obj.Position
                    end

                    if pos and maxHp then
                        table.insert(allScanned, {
                            name = name,
                            hp = maxHp,
                            curHp = curHp,
                            pos = pos,
                            obj = obj,
                            dist = (hrp.Position - pos).Magnitude,
                            passed = filter[tostring(maxHp)] == true,
                        })
                    elseif pos then
                        table.insert(allScanned, {
                            name = name,
                            hp = "?",
                            curHp = nil,
                            pos = pos,
                            obj = obj,
                            dist = (hrp.Position - pos).Magnitude,
                            passed = false,
                        })
                    end
                end
            end
        end

        if os.clock() - lastScanLog > 3 then
            lastScanLog = os.clock()
            local logLines = {string.format("[Scramble Scan] Filter=%s | Found %d visuals", filterDisplay, #allScanned)}
            for i, v in ipairs(allScanned) do
                local killMark = killedDrones[v.name] and " [KILLED]" or ""
                table.insert(logLines, string.format("  #%d %s | HP=%s (%s) | dist=%.0f | %s%s",
                    i, v.name, tostring(v.hp), tostring(v.curHp), v.dist, v.passed and "PASS" or "SKIP", killMark))
            end
            if #allScanned > 0 then
                H(table.concat(logLines, "\n"))
            end
        end

        for _, v in ipairs(allScanned) do
            if v.passed and v.hp ~= "?" then
                -- ✅ Skip drone yang sudah di-kill dan masih dalam window (visual masih ada)
                local killedAt = killedDrones[v.name]
                local isKilled = killedAt and (os.clock() - killedAt < 3.0)
                if not isKilled then
                    table.insert(found, v)
                end
            end
        end
        return found
    end

    local function getBestTarget()
        local list = scanScrambleVisuals()
        if #list == 0 then return nil end
        table.sort(list, function(a, b)
            if a.hp ~= b.hp then return a.hp > b.hp end
            return a.dist < b.dist
        end)
        return list[1]
    end

    local function isTargetStillValid(target)
        if not target or not target.Parent then return false end
        local visuals = r:FindFirstChild("ScrambleLocalVisuals")
        if not visuals or not target:IsDescendantOf(visuals) then return false end
        -- ✅ Hanya cek curHp, JANGAN cek maxHp (karena maxHp bisa tetap terlihat)
        local _, curHp = parseScrambleHp(target)
        if curHp and curHp <= 0 then return false end
        return true
    end

    local function clearTargetState(reason)
        if h.scrambleUID and reason then
            H(string.format("[Scramble] Reset target %s (%s)", h.scrambleUID, reason))
        end
        h.scrambleTarget = nil
        h.scrambleUID = nil
    end

    -- ✅ Mark drone sebagai killed (instant switch, no need to wait visual hilang)
    local function markKilled(uid)
        if uid then
            killedDrones[uid] = os.clock()
            H(string.format("[Scramble] ✅ %s DOWN — INSTANT SWITCH!", uid))
        end
    end

    local weaponKeywords = {"bat", "club", "stick", "sword", "wrench", "hammer", "crowbar", "knife", "axe"}
    local function isWeapon(name)
        local n = string.lower(name or "")
        for _, kw in ipairs(weaponKeywords) do
            if string.find(n, kw) then return true end
        end
        return false
    end
    local function findWeapon()
        local char = o.Character
        if not char then return nil, false end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and isWeapon(item.Name) then return item, true end
        end
        local bp = o:FindFirstChild("Backpack")
        if bp then
            for _, item in ipairs(bp:GetChildren()) do
                if item:IsA("Tool") and isWeapon(item.Name) then return item, false end
            end
        end
        return nil, false
    end
    local function equipWeapon()
        local tool, equipped = findWeapon()
        if not tool then
            H("[Scramble] Tidak ada weapon (Bat) di Backpack!")
            return nil
        end
        local char = o.Character
        if not char then return nil end
        if equipped and tool.Parent == char then return tool end
        pcall(function() tool.Parent = char end)
        task.wait(0.15)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
            pcall(function() hum2:EquipTool(tool) end)
            task.wait(0.1)
        end
        return tool
    end
    local function realAttack()
        local char = o.Character
        if not char then return false end
        local tool = char:FindFirstChildWhichIsA("Tool")
        if not tool or not isWeapon(tool.Name) then
            tool = equipWeapon()
            if not tool then return false end
        end
        task.wait(0.03)
        pcall(function() tool:Activate() end)
        pcall(function()
            for _, child in ipairs(tool:GetChildren()) do
                if child:IsA("RemoteEvent") then child:FireServer() end
            end
        end)
        local handle = tool:FindFirstChild("Handle")
        local target = h.scrambleTarget
        if handle and target then
            pcall(function()
                local targetPart
                if target:IsA("Model") then targetPart = target:FindFirstChildWhichIsA("BasePart") or target.PrimaryPart
                else targetPart = target end
                if targetPart and typeof(firetouchinterest) == "function" then
                    firetouchinterest(handle, targetPart, 0)
                    task.wait(0.015)
                    firetouchinterest(handle, targetPart, 1)
                end
            end)
        end
        return true
    end

    -- ============ MAIN LOOP ============
    while h.alive do
        if h.autoKillScramble then
            if os.clock() - sessionStart > sessionCooldown then
                sessionHits = 0
                sessionStart = os.clock()
            end
            local char = o.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                -- ✅ Cek HP dulu — kalau target sekarang HP 0, INSTANT clear
                if h.scrambleTarget then
                    local _, curHpNow = parseScrambleHp(h.scrambleTarget)
                    if curHpNow ~= nil and curHpNow <= 0 then
                        markKilled(h.scrambleUID)
                        clearTargetState("HP=0")
                        -- JANGAN wait, langsung scan berikutnya
                    end
                end

                -- Cek validitas target
                local needScan = false
                if not h.scrambleTarget or not h.scrambleTarget.Parent or not isTargetStillValid(h.scrambleTarget) then
                    needScan = true
                end

                if needScan and os.clock() - lastScan > scanCooldown then
                    lastScan = os.clock()
                    local best = getBestTarget()
                    if best then
                        h.scrambleTarget = best.obj
                        h.scrambleUID = best.name
                        h.scrambleMaxHP[best.name] = best.hp
                        h.scrambleHits[best.name] = h.scrambleHits[best.name] or 0
                        H(string.format("[Scramble] 🎯 Locked: %s | MaxHP=%d | curHP=%s | dist=%.0f",
                            best.name, best.hp, tostring(best.curHp), best.dist))
                    else
                        if os.clock() - (h._lastZoneCheck or 0) > 1.5 then
                            h._lastZoneCheck = os.clock()
                            local z = SCRAMBLE_ZONES[h.scrambleZoneIdx or 1]
                            if z then
                                local zoneCF = Vector3.new(z.x, 70, z.z)
                                local dist = (hrp.Position - zoneCF).Magnitude
                                if dist < 100 then
                                    H(string.format("[Scramble] Zona %s kosong, pindah...", z.name))
                                    h.scrambleZoneIdx = (h.scrambleZoneIdx or 1) + 1
                                    if h.scrambleZoneIdx > #SCRAMBLE_ZONES then h.scrambleZoneIdx = 1 end
                                else
                                    h.statusText = string.format("[Scramble] Fly ke zona %s (%.0f)", z.name, dist)
                                    scrambleFly(zoneCF, travelSpeed, 15)
                                end
                            end
                        end
                    end
                end

                -- Eksekusi target
                if h.scrambleTarget and h.scrambleTarget.Parent and isTargetStillValid(h.scrambleTarget) then
                    local uid = h.scrambleUID
                    local maxHp, curHp = parseScrambleHp(h.scrambleTarget)
                    if maxHp then
                        h.scrambleMaxHP[uid] = maxHp
                    end
                    local maxHP = h.scrambleMaxHP[uid] or 3

                    -- ✅ INSTANT SWITCH: kalau curHp sudah 0, mark killed & skip
                    if curHp ~= nil and curHp <= 0 then
                        markKilled(uid)
                        clearTargetState("instant-hp0")
                    else
                        local ok2, targetPos = pcall(function()
                            if h.scrambleTarget:IsA("Model") then return h.scrambleTarget:GetPivot().Position
                            else return h.scrambleTarget.Position end
                        end)
                        if ok2 and targetPos then
                            local dist = (hrp.Position - targetPos).Magnitude
                            if dist > hitRange then
                                h.statusText = string.format("[Scramble] Fly ke target (%.0f | HP:%d/%s)", dist, maxHP, tostring(curHp or "?"))
                                scrambleFly(targetPos, travelSpeed, 10)
                            else
                                local isDead = false
                                if curHp ~= nil then
                                    isDead = (curHp <= 0)
                                    h.statusText = string.format("[Scramble] HP: %d/%d", curHp, maxHP)
                                else
                                    isDead = (h.scrambleHits[uid] or 0) >= maxHP
                                    h.statusText = string.format("[Scramble] Hits: %d/%d", h.scrambleHits[uid] or 0, maxHP)
                                end

                                if isDead then
                                    -- ✅ INSTANT SWITCH
                                    markKilled(uid)
                                    clearTargetState("hit-count")
                                    -- Reset lastScan supaya langsung cari target berikutnya
                                    lastScan = 0
                                elseif sessionHits >= sessionMaxHits then
                                    local waitTime = math.ceil(sessionCooldown - (os.clock() - sessionStart))
                                    h.statusText = string.format("[Scramble] Session limit — %ds", waitTime)
                                    task.wait(0.5)
                                else
                                    -- ✅ Hit lebih cepat (0.28s)
                                    if os.clock() - (h._lastHitTime or 0) >= hitCooldown then
                                        h._lastHitTime = os.clock()
                                        pcall(function()
                                            local lookAt = Vector3.new(targetPos.X, hrp.Position.Y, targetPos.Z)
                                            if (lookAt - hrp.Position).Magnitude > 0.5 then
                                                hum.AutoRotate = false
                                                hrp.CFrame = CFrame.lookAt(hrp.Position, lookAt)
                                                task.wait(0.015)
                                                hum.AutoRotate = true
                                            end
                                        end)
                                        h.scrambleHits[uid] = (h.scrambleHits[uid] or 0) + 1
                                        sessionHits = sessionHits + 1
                                        h.statusText = string.format("[Scramble] Gebuk %d/%d (s:%d/%d)", h.scrambleHits[uid], maxHP, sessionHits, sessionMaxHits)
                                        H(string.format("[Scramble] Gebuk %d/%d → %s", h.scrambleHits[uid], maxHP, uid))
                                        task.spawn(function()
                                            realAttack()
                                            task.wait(0.05)
                                            -- ✅ Cek HP lagi setelah attack — kalau udah 0, INSTANT SWITCH
                                            if h.scrambleTarget then
                                                local _, hpAfter = parseScrambleHp(h.scrambleTarget)
                                                if hpAfter ~= nil and hpAfter <= 0 then
                                                    markKilled(h.scrambleUID)
                                                    clearTargetState("after-hit-hp0")
                                                    lastScan = 0
                                                elseif not isTargetStillValid(h.scrambleTarget) then
                                                    markKilled(h.scrambleUID)
                                                    clearTargetState("after-hit-invalid")
                                                    lastScan = 0
                                                end
                                            end
                                        end)
                                        task.wait(0.05)  -- dikurangi dari 0.08
                                    end
                                end
                            end
                        end
                    end
                end
            end
        else
            h.scrambleTarget = nil
            h.scrambleUID = nil
            h.scrambleFlyLock = false
            h.scrambleZoneIdx = 1
            h.scrambleHits = {}
            h.scrambleMaxHP = {}
            sessionHits = 0
            sessionStart = os.clock()
            killedDrones = {}
        end
        task.wait(0.02)  -- diturunkan dari 0.05 supaya loop lebih responsif
    end
end)

-- =========================================================
-- ANTI AFK SAFE (NO DETECT) — Human-like
-- =========================================================
local function EkSafe()
    pcall(function()
        -- 1. Mouse wiggle (sangat halus, tidak memicu anti-cheat)
        if typeof(mousemoverel) == "function" then
            local dx = math.random(-3, 3)
            local dy = math.random(-2, 2)
            mousemoverel(dx, dy)
            task.wait(0.1)
            mousemoverel(-dx, -dy)
        end

        -- 2. VirtualInputManager untuk random key press (WASD) — terlihat seperti gerakan player
        local vim = game:GetService("VirtualInputManager")
        if vim then
            local keys = {Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Space}
            local key = keys[math.random(1, #keys)]
            local pressTime = math.random(8, 18) / 100  -- 0.08 - 0.18 detik
            vim:SendKeyEvent(true, key, false, game)
            task.wait(pressTime)
            vim:SendKeyEvent(false, key, false, game)
        end

        -- 3. Random camera rotate (halus)
        pcall(function()
            local cam = workspace.CurrentCamera
            if cam then
                local currentCF = cam.CFrame
                local rotY = math.rad(math.random(-4, 4))
                local rotX = math.rad(math.random(-2, 2))
                cam.CFrame = currentCF * CFrame.Angles(rotX, rotY, 0)
            end
        end)

        -- 4. Random jump occasionally (10% chance)
        if math.random(1, 10) == 1 then
            local char = o.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                pcall(function() hum.Jump = true end)
            end
        end
    end)
end

local antiAfkActive = false
local function bkSafe()
    if antiAfkActive then return end
    antiAfkActive = true
    task.spawn(function()
        while h and h.alive and h.antiAFK and antiAfkActive do
            -- Interval random 90-180 detik (lebih natural, tidak pola tetap)
            local waitTime = math.random(90, 180)
            local waited = 0
            while waited < waitTime and h.alive and h.antiAFK and antiAfkActive do
                task.wait(1)
                waited = waited + 1
            end
            if not h.antiAFK or not antiAfkActive then break end
            EkSafe()
        end
        antiAfkActive = false
    end)
end
local function AkSafe()
    antiAfkActive = false
end

-- Performance mode
local nk = nil
local function fk(e)
    pcall(function()
        if e:IsA("BasePart") then
            e.Material = Enum.Material.SmoothPlastic
            e.Reflectance = 0
            e.CastShadow = false
            if e:IsA("MeshPart") then
                e.TextureID = ""
                pcall(function() e.RenderFidelity = Enum.RenderFidelity.Performance end)
                pcall(function() e.CollisionFidelity = Enum.CollisionFidelity.Box end)
            end
        elseif e:IsA("SpecialMesh") then e.TextureId = ""
        elseif e:IsA("Decal") or e:IsA("Texture") or e:IsA("SurfaceAppearance") then e.Transparency = 1
        elseif e:IsA("ParticleEmitter") or e:IsA("Trail") or e:IsA("Smoke") or e:IsA("Fire") or e:IsA("Sparkles") then e.Enabled = false
        elseif e:IsA("Beam") then e.Enabled = false
        elseif e:IsA("Explosion") then e.Visible = false
        elseif e:IsA("Light") or e:IsA("PointLight") or e:IsA("SpotLight") or e:IsA("SurfaceLight") then e.Enabled = false
        elseif e:IsA("Highlight") and e.Name ~= "EggESP_Highlight" then e.Enabled = false end
    end)
end
local function Mk()
    h.performanceMode = true
    pcall(function()
        local e2 = r:FindFirstChild("Lych X PutraHub_EggESP")
        if e2 then e2:Destroy() end
        local y2 = game:GetService("Lighting")
        y2.GlobalShadows = false; y2.FogEnd = 9000000000; y2.Brightness = 1; y2.ClockTime = 14
        y2.OutdoorAmbient = Color3.fromRGB(128,128,128)
        for e3, r2 in ipairs(y2:GetChildren()) do
            if r2:IsA("PostEffect") or r2:IsA("BloomEffect") or r2:IsA("BlurEffect") or r2:IsA("ColorCorrectionEffect") or r2:IsA("SunRaysEffect") or r2:IsA("DepthOfFieldEffect") or r2:IsA("Atmosphere") then pcall(function() r2.Enabled = false end)
            elseif r2:IsA("Sky") then pcall(function() r2.Parent = nil end) end
        end
        local u2 = workspace:FindFirstChildOfClass("Terrain")
        if u2 then pcall(function() u2.Decoration = false; u2.WaterWaveSize = 0; u2.WaterWaveSpeed = 0; u2.WaterReflectance = 0; u2.WaterTransparency = 0 end) end
        for e3, r2 in ipairs(workspace:GetDescendants()) do fk(r2) end
        if not nk then
            nk = workspace.DescendantAdded:Connect(function(e3) if h.performanceMode then fk(e3) end end)
        end
        pcall(function()
            if settings and (settings()).Rendering then (settings()).Rendering.QualityLevel = 1 end
        end)
    end)
end
local function Ik()
    h.performanceMode = false
    if nk then pcall(function() nk:Disconnect() end); nk = nil end
    pcall(function()
        local e2 = game:GetService("Lighting")
        e2.GlobalShadows = true
        for e3, r2 in ipairs(e2:GetChildren()) do
            if r2:IsA("PostEffect") or r2:IsA("BloomEffect") or r2:IsA("BlurEffect") or r2:IsA("ColorCorrectionEffect") or r2:IsA("SunRaysEffect") or r2:IsA("DepthOfFieldEffect") or r2:IsA("Atmosphere") then pcall(function() r2.Enabled = true end) end
        end
        local r2 = workspace:FindFirstChildOfClass("Terrain")
        if r2 then pcall(function() r2.Decoration = true end) end
    end)
end

y.Heartbeat:Connect(function()
    local e2 = o.Character
    local r2 = e2 and e2:FindFirstChild("HumanoidRootPart")
    local y2 = e2 and e2:FindFirstChildOfClass("Humanoid")
    if not r2 or not y2 then return end

    local farmActive = h and (
        h.pureTweenFarm or h.autoFarmLoop or h.teleporting or
        h.glidingToTarget or h.isReturning or h.securingEgg or
        h.delivering or h.holdingEggForGuard or h.onTreadmill or
        h.autoKillScramble or h.stealAutoTreadmill or h.autoStealBigSize
    )

    if farmActive and not h.onTreadmill then
        if y2.PlatformStand then
            y2.PlatformStand = false
            y2:ChangeState(Enum.HumanoidStateType.Running)
        end
        if y2.Sit then
            y2.Sit = false
            y2:ChangeState(Enum.HumanoidStateType.Running)
        end
    end

    if not farmActive and not h.onTreadmill then
        pcall(function()
            if not y2:GetStateEnabled(Enum.HumanoidStateType.Jumping) then
                y2:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
            end
            if not y2:GetStateEnabled(Enum.HumanoidStateType.Freefall) then
                y2:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
            end
            if not y2:GetStateEnabled(Enum.HumanoidStateType.Running) then
                y2:SetStateEnabled(Enum.HumanoidStateType.Running, true)
            end
            if not y2:GetStateEnabled(Enum.HumanoidStateType.Climbing) then
                y2:SetStateEnabled(Enum.HumanoidStateType.Climbing, true)
            end
        end)
        if not y2.AutoRotate then
            y2.AutoRotate = true
        end
        if h._origWalkSpeed ~= nil and math.abs(y2.WalkSpeed - h._origWalkSpeed) > 0.5 then
            y2.WalkSpeed = h._origWalkSpeed
        end
        if h._origUseJumpPower and h._origJumpPower ~= nil 
           and math.abs(y2.JumpPower - h._origJumpPower) > 0.5 then
            y2.JumpPower = h._origJumpPower
        elseif h._origJumpHeight ~= nil and h._origUseJumpPower == false then
            if math.abs(y2.JumpHeight - h._origJumpHeight) > 0.5 then
                y2.JumpHeight = h._origJumpHeight
            end
        end
    end

    local u2 = r2.Position
    local w2 = w4()
    if u2.Y < 45 then
        r2.CFrame = CFrame.new(u2.X, 72, u2.Z)
        r2.AssemblyLinearVelocity = Vector3.zero
        return
    end
    if (h.pureTweenFarm or h.autoFarmLoop) and not h.holdingEggForGuard then
        local r3 = false
        for e3, y3 in ipairs(e2:GetChildren()) do
            if y3:IsA("Tool") then r3 = true; break end
        end
        if r3 then u4() end
    end
    if farmActive then return end
    if h.alive and h.autoGlide and w2 and (not a4()) and u2.X > E then
        task.spawn(function()
            Q4(h.glideSpeed)
            u4()
            h.isReturning = false
            h.delivering = false
        end)
    end
end)

-- =========== UI ===========
local Info = Window:CreateTab({
    Title = "Information",
    Subtitle = "Update/Dev Info",
    Icon = "rbxassetid://6031075938"
})

local Main = Window:CreateTab({
    Title = "Main",
    Subtitle = "Farm",
    Icon = "rbxassetid://6035067836"
})

local SelectTab = Window:CreateTab({
    Title = "Egg Select",
    Subtitle = "Filter",
    Icon = "rbxassetid://6031079158"
})

local EventTab = Window:CreateTab({
    Title = "Event",
    Subtitle = "Event Menu",
    Icon = "rbxassetid://6031071053"
})

local Extra = Window:CreateTab({
    Title = "Extra",
    Subtitle = "Tools",
    Icon = "rbxassetid://6031280882"
})

local ConfigTab = Window:CreateTab({
    Title = "Settings",
    Subtitle = "Config",
    Icon = "rbxassetid://6031280882"
})

Info:CreateDiscordInvite({
    Title = "Lych X Putra Server Official",
    Description = "Join the official Lych X Putra Server for updates, announcements, support, and community.",
    Icon = "rbxassetid://102468802738090",
    Banner = "rbxassetid://101774438494641",
    Link = "",
    Button = "Join Server",
})

Main:CreateSection({ Text = "Auto Steal Modes" })

Main:CreateButton({
    Title = "Load Anti Hit Guard",
    Description = "Lych X Putra Hub utama akan otomatis di-unload dulu biar tidak tabrakan",
    Callback = function()
        pcall(function()
            if h then
                h.alive = false
                h.pureTweenFarm = false
                h.autoFarmLoop = false
                h.autoTreadmill = false
                h.autoUpgradeTreadmill = false
                h.autoBuyTrails = false
                h.autoHatch = false
                h.autoKillScramble = false
                h.teleporting = false
                h.glidingToTarget = false
                h.securingEgg = false
                h.isReturning = false
                h.delivering = false
                h.holdingEggForGuard = false
                h.onTreadmill = false
                h.scrambleFlyLock = false
                h.stealAutoTreadmill = false
                h.autoStealBigSize = false
            end
        end)
        pcall(function() if Ik then Ik() end end)
        pcall(function() if AkSafe then AkSafe() end end)
        pcall(function() if D4 then D4() end end)
        pcall(function() if u4 then u4() end end)
        pcall(function() if C4 then C4() end end)
        pcall(function() if restoreNormalHumanoid then restoreNormalHumanoid() end end)
        pcall(function() y:Set3dRenderingEnabled(true) end)
        pcall(function()
            local ws = game:GetService("Workspace")
            for _, obj in ipairs(ws:GetChildren()) do
                if obj.Name == "SafetyFloorPad_AntiVoid" then
                    pcall(function() obj:Destroy() end)
                end
            end
        end)
        pcall(function() Window:Destroy() end)
        task.wait(0.35)
        loadstring(game:HttpGet("https://flowauth.net/v1/loaders/473e6a208c4fe05ff49555317ac8efca.lua"))()
    end,
})
Main:CreateSection({ Text = "Speed" })

Main:CreateSlider({
    Title = "Speed (studs/s)",
    Min = 100, Max = 1000, Default = h.glideSpeed or 600,
    Callback = function(v)
        h.glideSpeed = math.clamp(math.floor(v), 100, 1000)
        pcall(Y, h.glideSpeed)
    end,
})
local tweenToggle, warpToggle
local syncing = false

tweenToggle = Main:CreateToggle({
    Title = "Auto Steal (Tween)",
    Description = "Fly smoothly to steal eggs (Lych X PutraHUB engine)",
    Default = false,
    Callback = function(v)
        if syncing then return end
        
        -- ✅ Auto get-out treadmill sebelum toggle farm
        pcall(M4); pcall(C4); pcall(D4)
        
        if v then
            if warpToggle then syncing = true; pcall(function() warpToggle:Set(false) end); syncing = false end
            T4("TWEEN")
        else
            if Y4 == "TWEEN" then 
                T4("NONE")
                task.wait(0.1)
                pcall(restoreNormalHumanoid)
                
                -- ✅ FIX JUMP: reset semua flag farm
                h.swapped = false
                h.godmode = false
                h.onTreadmill = false
                h.pureTweenFarm = false
                h.autoFarmLoop = false
                
                local char = o.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                
                -- ✅ Re-enable semua humanoid state
                if hum then
                    pcall(function()
                        for _, state in ipairs({
                            Enum.HumanoidStateType.Ragdoll,
                            Enum.HumanoidStateType.FallingDown,
                            Enum.HumanoidStateType.Physics,
                            Enum.HumanoidStateType.PlatformStanding,
                            Enum.HumanoidStateType.Seated,
                            Enum.HumanoidStateType.Jumping,
                            Enum.HumanoidStateType.Freefall,
                            Enum.HumanoidStateType.Running,
                            Enum.HumanoidStateType.Climbing,
                            Enum.HumanoidStateType.Landed,
                            Enum.HumanoidStateType.GettingUp,
                        }) do
                            hum:SetStateEnabled(state, true)
                        end
                        hum.AutoRotate = true
                        hum.PlatformStand = false
                        hum.Sit = false
                        if hum.Health > 0 then
                            hum:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                end
                
                -- ✅ Restore CanCollide & CanTouch semua part
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            pcall(function() part.CanCollide = true end)
                            pcall(function() part.CanTouch = true end)
                        end
                    end
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function() 
                            hrp.Anchored = false 
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                end
                
                -- ✅ Restore WalkSpeed & JumpPower original
                if hum then
                    if h._origWalkSpeed then
                        pcall(function() hum.WalkSpeed = h._origWalkSpeed end)
                    end
                    if h._origUseJumpPower and h._origJumpPower then
                        pcall(function() 
                            hum.UseJumpPower = true
                            hum.JumpPower = h._origJumpPower 
                        end)
                    elseif h._origJumpHeight then
                        pcall(function() 
                            hum.UseJumpPower = false
                            hum.JumpHeight = h._origJumpHeight 
                        end)
                    end
                end
                
                H("[Toggle] Auto Steal (Tween) OFF — Karakter kembali normal.")
            end
        end
    end,
})

warpToggle = Main:CreateToggle({
    Title = "Auto Steal (Teleport)",
    Description = "Warp to steal eggs rapidly (Lych X PutraHUB engine)",
    Default = false,
    Callback = function(v)
        if syncing then return end
        
        -- ✅ Auto get-out treadmill sebelum toggle farm
        pcall(M4); pcall(C4); pcall(D4)
        
        if v then
            if tweenToggle then syncing = true; pcall(function() tweenToggle:Set(false) end); syncing = false end
            T4("WARP")
        else
            if Y4 == "WARP" then 
                T4("NONE")
                task.wait(0.1)
                pcall(restoreNormalHumanoid)
            end
        end
    end,
})

-- ✅ NEW TOGGLE: Auto Steal Egg Big Size (Tween)
Main:CreateToggle({
    Title = "Auto Steal Egg Big Size",
    Description = "Ambil egg dengan size paling besar di semua area (Tween version)",
    Default = false,
    Callback = function(v)
        -- ✅ Auto get-out treadmill sebelum toggle farm
        pcall(M4); pcall(C4); pcall(D4)
        
        h.autoStealBigSize = v
        if v then
            -- Auto-disable farm modes lain supaya tidak tabrakan
            if tweenToggle then syncing = true; pcall(function() tweenToggle:Set(false) end); syncing = false end
            if warpToggle then syncing = true; pcall(function() warpToggle:Set(false) end); syncing = false end
            if h.stealAutoTreadmill then
                h.stealAutoTreadmill = false
            end
            Y4 = "NONE"
            h.pureTweenFarm = false
            h.autoFarmLoop = false
            if not h.swapped then A4() end
            if not h.godmode then b4(true) end
            H("[BigSize] Auto Steal Egg Big Size ACTIVATED — Tween mode")
        else
            H("[BigSize] Auto Steal Egg Big Size DEACTIVATED")
            pcall(D4)
        end
    end,
})

Main:CreateButton({
    Title = "Get Out Treadmill",
    Callback = function() pcall(M4); pcall(C4); pcall(D4) end,
})

Main:CreateButton({
    Title = "Single Steal (Teleport)",
    Description = "Steal 1 egg and return to base",
    Callback = function()
        task.spawn(function()
            if Y4 ~= "NONE" then T4("NONE"); task.wait(0.2) end
            local egg = N4()
            if egg then
                local ok = l4(egg, nil)
                if ok then
                    pcall(u4)
                    if h.autoGlide then Q4(h.glideSpeed); u4() end
                end
            end
        end)
    end,
})

Main:CreateSection({ Text = "Place & Hatch" })

Main:CreateButton({
    Title = "Place Egg",
    Description = "Tween home, place eggs, request hatch",
    Callback = function()
        task.spawn(function()
            h.statusText = "[Manual] Depositing eggs..."
            g4(h.glideSpeed)
            v4()
            u4()
            h.isReturning = false
            h.delivering = false
        end)
    end,
})

Main:CreateToggle({
    Title = "Auto Place (Every 5)",
    Description = "Return home every 5 steals to deposit",
    Default = false,
    Callback = function(v)
        h.autoPlaceEvery5 = v
        if not v then h.batchStealCount = 0 end
    end,
})

Main:CreateToggle({
    Title = "Auto Hatch",
    Description = "Continuously hatch ready eggs",
    Default = h.autoHatch ~= false,
    Callback = function(v) h.autoHatch = v end,
})

Main:CreateToggle({
    Title = "Auto Return",
    Description = "Return to safe area after stealing",
    Default = h.autoGlide ~= false,
    Callback = function(v) h.autoGlide = v end,
})

Main:CreateToggle({
    Title = "Auto Treadmill",
    Description = "Run treadmill when no eggs available",
    Default = h.autoTreadmill ~= false,
    Callback = function(v)
        h.autoTreadmill = v
        pcall(n4)
        if not v and (h.onTreadmill or (L4 and L4())) then pcall(M4) end
    end,
})

Main:CreateToggle({
    Title = "Auto Upgrade Treadmill",
    Description = "Auto upgrade treadmill tier",
    Default = h.autoUpgradeTreadmill ~= false,
    Callback = function(v) h.autoUpgradeTreadmill = v end,
})

Main:CreateToggle({
    Title = "Auto Buy & Equip Trails",
    Description = "Auto purchase best speed trail",
    Default = h.autoBuyTrails ~= false,
    Callback = function(v) h.autoBuyTrails = v end,
})

Main:CreateToggle({
    Title = "Hide 'Not Enough Money'",
    Description = "Suppress red warning",
    Default = h.hideNotEnoughMoney ~= false,
    Callback = function(v) h.hideNotEnoughMoney = v end,
})

local function buildSelectedList(map, order)
    local out = {}
    if type(map) ~= "table" then return out end
    for _, name in ipairs(order) do
        if map[name] == true then out[#out + 1] = name end
    end
    return out
end

local function normalizeSelected(selected)
    local set = {}
    if type(selected) == "table" then
        for _, v in pairs(selected) do
            if type(v) == "string" then set[v] = true end
            if type(v) == "table" and type(v.Title) == "string" then set[v.Title] = true end
        end
        for i = 1, #selected do
            local v = selected[i]
            if type(v) == "string" then set[v] = true end
        end
    elseif type(selected) == "string" then
        set[selected] = true
    end
    return set
end

local function applyAreaFilter(selected)
    local set = normalizeSelected(selected)
    local countSelected = 0
    for k in pairs(set) do countSelected = countSelected + 1 end

    if set["All"] or countSelected == 0 then
        h.selectedZones = {}
        for _, areaName in ipairs(M) do h.selectedZones[areaName] = true end
        h.selectedZones["LightDark"] = true
        h.selectedZones["Angels & Demons"] = true
    else
        h.selectedZones = {}
        for _, areaName in ipairs(M) do
            if set[areaName] == true then h.selectedZones[areaName] = true end
        end
    end
    local hasAny = false
    for _ in pairs(h.selectedZones) do hasAny = true; break end
    if not hasAny then
        for _, areaName in ipairs(M) do h.selectedZones[areaName] = true end
    end
    pcall(x)
end

local function applyRarityFilter(selected)
    local set = normalizeSelected(selected)
    h.selectedRarities = {}

    -- ✅ Kalau user tidak pilih apapun → anggap SEMUA rarity aktif
    local countSelected = 0
    for k in pairs(set) do countSelected = countSelected + 1 end

    if set["All"] or countSelected == 0 then
        -- Aktifkan semua rarity kalau "All" atau tidak ada yang dipilih
        for _, rarName in ipairs(X) do h.selectedRarities[rarName] = true end
    else
        for _, rarName in ipairs(X) do
            if set[rarName] == true then h.selectedRarities[rarName] = true end
        end
        -- Safety: kalau hasilnya kosong, aktifkan semua
        local hasAny = false
        for _ in pairs(h.selectedRarities) do hasAny = true; break end
        if not hasAny then
            for _, rarName in ipairs(X) do h.selectedRarities[rarName] = true end
        end
    end
    pcall(x)
end

SelectTab:CreateSection({ Text = "Filter Zones & Rarities" })

SelectTab:CreateDropdown({
    Title = "Target Zones",
    Description = "Pilih 'All' untuk semua area. Atau pilih kombinasi.",
    Options = (function()
        local opts = {"All"}
        for _, v in ipairs(M) do table.insert(opts, v) end
        return opts
    end)(),
    Multiple = true,
    Callback = function(selected) applyAreaFilter(selected) end,
})

SelectTab:CreateDropdown({
    Title = "Target Rarities",
    Description = "Pilih 'All' untuk semua rarity. Atau pilih kombinasi.",
    Options = (function()
        local opts = {"All"}
        for _, v in ipairs(X) do table.insert(opts, v) end
        return opts
    end)(),
    Multiple = true,
    Callback = function(selected) applyRarityFilter(selected) end,
})

SelectTab:CreateToggle({
    Title = "Always Steal Secret+",
    Description = "Bypass area filter untuk Secret/Eternal/Divine",
    Default = h.alwaysCollectSecretPlus ~= false,
    Callback = function(v)
        h.alwaysCollectSecretPlus = v
        pcall(x)
    end,
})

EventTab:CreateSection({ Text = "Event Scramble" })

EventTab:CreateDropdown({
    Title = "Target Scramble HP",
    Description = "Pilih HP Scramble yang mau di-kill. (Urutan kill: HP terbesar dulu)",
    Options = {"3 / 3 HP", "5 / 5 HP", "10 / 10 HP", "All"},
    Multiple = true,
    Default = {"3 / 3 HP", "5 / 5 HP", "10 / 10 HP"},
    Callback = function(selected)
        local filter = {}
        for _, v in ipairs(selected) do
            if v == "3 / 3 HP" then filter["3"] = true end
            if v == "5 / 5 HP" then filter["5"] = true end
            if v == "10 / 10 HP" then filter["10"] = true end
            if v == "All" then 
                filter["3"] = true; filter["5"] = true; filter["10"] = true 
                break
            end
        end
        if next(filter) == nil then filter["3"] = true end
        h.scrambleHpFilter = filter
    end,
})

EventTab:CreateToggle({
    Title = "Auto Kill Scramble (Fast)",
    Description = "Fly + gebuk + INSTANT SWITCH saat HP=0 (tidak tunggu visual hilang)",
    Default = false,
    Callback = function(v)
        -- ✅ Auto get-out treadmill sebelum toggle scramble
        pcall(M4); pcall(C4); pcall(D4)
        
        h.autoKillScramble = v
        if not v then
            h.scrambleTarget = nil
            h.scrambleUID = nil
            h.isAttackingScramble = false
            h.scrambleFlyLock = false
            h.scrambleHits = {}
            h.scrambleMaxHP = {}
        else
            H("[Scramble] FAST KILL mode ACTIVATED — instant switch saat HP=0")
        end
    end,
})

Extra:CreateSection({ Text = "Safety" })

Extra:CreateToggle({
    Title = "Godmode",
    Description = "Invincible vs guards (desync)",
    Default = false,
    Callback = function(v)
        if v then pcall(enableDesyncGodmode)
        else pcall(disableDesyncGodmode) end
    end,
})

Extra:CreateButton({
    Title = "Get Out of Treadmill",
    Callback = function() pcall(M4); pcall(C4); pcall(D4) end,
})

Extra:CreateButton({
    Title = "Reset Character State",
    Callback = function() 
        pcall(D4); pcall(u4)
        pcall(restoreNormalHumanoid)
    end,
})

ConfigTab:CreateSection({ Text = "System" })

ConfigTab:CreateToggle({
    Title = "Anti AFK (Safe Mode)",
    Description = "Human-like: mouse wiggle + WASD + camera rotate, interval 90-180s (no detect)",
    Default = h.antiAFK ~= false,
    Callback = function(v)
        h.antiAFK = v
        pcall(x)
        if v then pcall(bkSafe) else pcall(AkSafe) end
    end,
})

ConfigTab:CreateToggle({
    Title = "Performance Mode (Ultra Potato)",
    Description = "Remove textures, shadows, particles for max FPS",
    Default = h.performanceMode == false,
    Callback = function(v)
        h.performanceMode = v
        pcall(x)
        if v then task.spawn(Mk) else pcall(Ik) end
    end,
})

ConfigTab:CreateToggle({
    Title = "Disable 3D Rendering",
    Description = "Freeze 3D viewport (GPU saver 95%)",
    Default = h.disable3D == false,
    Callback = function(v)
        h.disable3D = v
        pcall(x)
        pcall(function() y:Set3dRenderingEnabled(not v) end)
    end,
})

ConfigTab:CreateButton({
    Title = "Unload Script",
    Description = "Stop all loops and close UI",
    Callback = function()
        h.alive = false
        pcall(Ik)
        pcall(AkSafe)
        pcall(function() y:Set3dRenderingEnabled(true) end)
        pcall(D4)
        pcall(u4)
        pcall(restoreNormalHumanoid)
        pcall(function() Window:Destroy() end)
    end,
})

-- =========== STARTUP ===========
print("[Lych X PutraHUB] Loaded - Karakter normal saat idle")
task.spawn(function()
    task.wait(0.5)
    pcall(C4)
    pcall(u4)
end)

o.CharacterAdded:Connect(function(char)
    task.wait(0.4)
    h._origWalkSpeed = nil
    h._origJumpPower = nil
    h._origJumpHeight = nil
    h._origUseJumpPower = nil
    captureOriginalHumanoid(char)
    task.wait(0.2)
    if h.alive then
        pcall(D4)
        pcall(n4)
        pcall(C4)
        pcall(u4)
    end
end)

if h.disable3D then pcall(function() y:Set3dRenderingEnabled(false) end) end
if h.antiAFK then pcall(function() if bkSafe then task.spawn(bkSafe) end end) end

