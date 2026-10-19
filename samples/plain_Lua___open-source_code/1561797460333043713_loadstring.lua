--[[
    HEADLESS OG SNIPER — v48
    • Clean log cards: no overlap, fixed zones, single action row
    • Better detection + dedup logging
    • Reactive atmospheric background
    • Orange theme (inherits PURPLE on theme swap)
--]]

print("[HOS] v48 boot...")

do

local cloneref = cloneref or function(o) return o end
local function svc(n)
    local ok, s = pcall(function() return game:GetService(n) end)
    if not ok or not s then return nil end
    local ok2, r = pcall(cloneref, s)
    return (ok2 and r) or s
end

local Players           = svc("Players")
local ReplicatedStorage = svc("ReplicatedStorage")
local UIS               = svc("UserInputService")
local TS                = svc("TweenService")
local RunService        = svc("RunService")
local CoreGui           = svc("CoreGui")
local HttpService       = svc("HttpService")
local CollectionService = svc("CollectionService")

local LP = Players.LocalPlayer
local PG = LP:WaitForChild("PlayerGui")
local httpReq = (syn and syn.request) or (http and http.request) or http_request or request

local MUT_COLORS = {
    ["gold"]        = Color3.fromRGB(255, 200, 60),
    ["diamond"]     = Color3.fromRGB(120, 220, 255),
    ["bloodrot"]    = Color3.fromRGB(180, 25, 30),
    ["candy"]       = Color3.fromRGB(255, 140, 200),
    ["lava"]        = Color3.fromRGB(255, 90, 20),
    ["galaxy"]      = Color3.fromRGB(140, 80, 220),
    ["yinyang"]     = Color3.fromRGB(220, 220, 220),
    ["radioactive"] = Color3.fromRGB(140, 255, 60),
    ["cursed"]      = Color3.fromRGB(120, 40, 160),
    ["rainbow"]     = Color3.fromRGB(255, 120, 180),
    ["divine"]      = Color3.fromRGB(255, 240, 180),
    ["cyber"]       = Color3.fromRGB(60, 240, 220),
    ["phantom"]     = Color3.fromRGB(110, 110, 180),
    ["crystal"]     = Color3.fromRGB(180, 240, 255),
    ["eclipse"]     = Color3.fromRGB(80, 40, 120),
}

local KNOWN_MUTATIONS = {
    "Default","Gold","Diamond","Bloodrot","Candy","Lava","Galaxy",
    "Yin Yang","Radioactive","Cursed","Rainbow","Divine","Cyber",
    "Phantom","Crystal","Eclipse",
}
local KNOWN_MUT_LOOKUP = {}
for _, name in ipairs(KNOWN_MUTATIONS) do
    KNOWN_MUT_LOOKUP[name:lower():gsub("[^%w]", "")] = name
end

local function canonicalizeMutation(raw)
    if type(raw) ~= "string" then return nil end
    local low = raw:lower():gsub("^%s+",""):gsub("%s+$","")
    if low == "" or low == "none" or low == "normal" or low == "default" then return nil end
    local n = low:gsub("[^%w]", "")
    if n == "default" then return nil end
    if KNOWN_MUT_LOOKUP[n] then return KNOWN_MUT_LOOKUP[n] end
    for key, canon in pairs(KNOWN_MUT_LOOKUP) do
        if #key >= 4 and (n:find(key, 1, true) or key:find(n, 1, true)) then return canon end
    end
    return nil
end

local function getMutationColor(mutationName)
    if not mutationName or mutationName == "" then return nil end
    local low = mutationName:lower():gsub("^%s+",""):gsub("%s+$","")
    if low == "none" or low == "normal" or low == "" or low == "default" or low == "base" then return nil end
    local canon = canonicalizeMutation(mutationName)
    if canon then
        local key = canon:lower():gsub("[^%w]", "")
        if MUT_COLORS[key] then return MUT_COLORS[key] end
    end
    local n = low:gsub("[^%w]", "")
    if MUT_COLORS[n] then return MUT_COLORS[n] end
    return nil
end

local THEMES = {
    HALLOWEEN = {
        bg = Color3.fromRGB(20, 10, 4), bgDeep = Color3.fromRGB(12, 6, 2),
        header = Color3.fromRGB(26, 13, 5), panel = Color3.fromRGB(32, 16, 6),
        panel2 = Color3.fromRGB(44, 22, 8), card = Color3.fromRGB(28, 14, 6),
        input = Color3.fromRGB(16, 8, 3), line = Color3.fromRGB(120, 60, 12),
        lineSoft = Color3.fromRGB(80, 40, 10), acc = Color3.fromRGB(255, 140, 26),
        acc2 = Color3.fromRGB(200, 90, 10), accHi = Color3.fromRGB(255, 180, 80),
        txt = Color3.fromRGB(255, 235, 220), sub = Color3.fromRGB(200, 150, 100),
        dim = Color3.fromRGB(130, 90, 55), caughtBg = Color3.fromRGB(42, 20, 8),
        off = Color3.fromRGB(50, 26, 12), sendBg = Color3.fromRGB(70, 35, 6),
        sendTxt = Color3.fromRGB(255, 170, 70), targetBg = Color3.fromRGB(72, 16, 24),
        targetTxt = Color3.fromRGB(255, 90, 110), duelBg = Color3.fromRGB(48, 20, 70),
        duelTxt = Color3.fromRGB(200, 120, 255), copyBg = Color3.fromRGB(58, 26, 44),
        copyTxt = Color3.fromRGB(255, 130, 180), scanBg = Color3.fromRGB(60, 30, 6),
        scanTxt = Color3.fromRGB(255, 160, 60), blacklistBg = Color3.fromRGB(46, 18, 18),
        blacklistTxt = Color3.fromRGB(220, 90, 90), trackBg = Color3.fromRGB(46, 22, 52),
        trackTxt = Color3.fromRGB(190, 130, 240), mutationPill = Color3.fromRGB(56, 40, 16),
        mutationTxt = Color3.fromRGB(255, 200, 100), normalPill = Color3.fromRGB(48, 30, 16),
        normalTxt = Color3.fromRGB(160, 120, 80), income = Color3.fromRGB(120, 220, 140),
        headless = Color3.fromRGB(255, 140, 26), headlessBg = Color3.fromRGB(60, 25, 4),
        ok = Color3.fromRGB(120, 200, 140), err = Color3.fromRGB(220, 90, 100),
        warn = Color3.fromRGB(255, 200, 90),
        bgImage = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
        bgTint = Color3.fromRGB(255, 140, 60),
        overlayBorder = Color3.fromRGB(255, 140, 26),
        overlayBadge  = Color3.fromRGB(255, 140, 26),
        overlayBadgeText = Color3.fromRGB(26, 13, 5),
        overlayUser   = Color3.fromRGB(255, 180, 80),
        overlaySub    = Color3.fromRGB(200, 150, 100),
    },
    PURPLE = {
        bg = Color3.fromRGB(11, 6, 20), bgDeep = Color3.fromRGB(8, 4, 16),
        header = Color3.fromRGB(24, 14, 40), panel = Color3.fromRGB(24, 14, 40),
        panel2 = Color3.fromRGB(36, 22, 60), card = Color3.fromRGB(22, 12, 36),
        input = Color3.fromRGB(14, 8, 26), line = Color3.fromRGB(70, 44, 120),
        lineSoft = Color3.fromRGB(50, 32, 88), acc = Color3.fromRGB(168, 85, 247),
        acc2 = Color3.fromRGB(120, 55, 190), accHi = Color3.fromRGB(210, 150, 255),
        txt = Color3.fromRGB(240, 230, 255), sub = Color3.fromRGB(160, 140, 190),
        dim = Color3.fromRGB(110, 90, 140), caughtBg = Color3.fromRGB(30, 16, 52),
        off = Color3.fromRGB(45, 36, 68), sendBg = Color3.fromRGB(52, 22, 62),
        sendTxt = Color3.fromRGB(220, 130, 255), targetBg = Color3.fromRGB(60, 18, 46),
        targetTxt = Color3.fromRGB(255, 100, 160), duelBg = Color3.fromRGB(38, 18, 72),
        duelTxt = Color3.fromRGB(180, 130, 255), copyBg = Color3.fromRGB(48, 24, 62),
        copyTxt = Color3.fromRGB(230, 140, 240), scanBg = Color3.fromRGB(50, 28, 70),
        scanTxt = Color3.fromRGB(190, 150, 255), blacklistBg = Color3.fromRGB(40, 16, 32),
        blacklistTxt = Color3.fromRGB(230, 100, 150), trackBg = Color3.fromRGB(40, 22, 62),
        trackTxt = Color3.fromRGB(190, 130, 240), mutationPill = Color3.fromRGB(48, 32, 68),
        mutationTxt = Color3.fromRGB(220, 180, 255), normalPill = Color3.fromRGB(34, 24, 48),
        normalTxt = Color3.fromRGB(150, 130, 180), income = Color3.fromRGB(140, 220, 200),
        headless = Color3.fromRGB(210, 150, 255), headlessBg = Color3.fromRGB(48, 22, 70),
        ok = Color3.fromRGB(140, 200, 200), err = Color3.fromRGB(220, 90, 130),
        warn = Color3.fromRGB(200, 180, 255),
        bgImage = "rbxthumb://type=Asset&id=96519310989847&w=420&h=420",
        bgTint = Color3.fromRGB(150, 90, 240),
        overlayBorder = Color3.fromRGB(168, 85, 247),
        overlayBadge  = Color3.fromRGB(168, 85, 247),
        overlayBadgeText = Color3.fromRGB(20, 10, 30),
        overlayUser   = Color3.fromRGB(210, 150, 255),
        overlaySub    = Color3.fromRGB(160, 140, 190),
    },
}

local C = {}
for k, v in pairs(THEMES.HALLOWEEN) do C[k] = v end
local currentTheme = "HALLOWEEN"
local FM, FB, FBK = Enum.Font.GothamMedium, Enum.Font.GothamBold, Enum.Font.GothamBlack

local WEBHOOK_URL        = "https://discord.com/api/webhooks/1554241846430011402/1Zku-hmmcqoA99pMcPw-EFioKQRMhbYCZ0YAN7H8OJDcr7kA1WHYMVOf8okBGmb33fZ6"
local WEBHOOK_DETECT_URL = "https://discord.com/api/webhooks/1560033278331719720/qhvZdk_uUhPhwbMApgGaUNWxKXUTIFmWP3pryFr0bfyzDy-0c_vE1GhNnCd2zMFyoEGG"

local SLOTS = {
    { key = "SKIBIDI", display = "Skibidi Toilet",
      searchKeys = { "SkibidiToilet", "Skibidi Toilet", "Skibidi", "Skibiditoilet" },
      matchTokens = { "skibiditoilet" },
      logMatchNames = { "skibidi toilet", "skibiditoilet", "skibidi" } },
    { key = "PORK", display = "John Pork",
      searchKeys = { "JohnPork", "John Pork", "Johnpork" },
      matchTokens = { "johnpork" },
      logMatchNames = { "john pork", "johnpork", "j.pork", "jpork" } },
    { key = "SELEPH", display = "Strawberry Elephant",
      searchKeys = { "StrawberryElephant", "Strawberry Elephant" },
      matchTokens = { "strawberryelephant" },
      logMatchNames = { "strawberry elephant", "strawberryelephant" } },
    { key = "MEOWL", display = "Meowl",
      searchKeys = { "Meowl", "MeowI", "MeowL" },
      matchTokens = { "meowl" },
      logMatchNames = { "meowl" } },
    { key = "DRAGONCANNELLONI", display = "Dragon Cannelloni",
      searchKeys = { "DragonCannelloni", "Dragon Cannelloni" },
      matchTokens = { "dragoncannelloni" },
      logMatchNames = { "dragon cannelloni", "dragoncannelloni" } },
}

local function new(class, props, parent)
    local i = Instance.new(class)
    for k, v in pairs(props or {}) do i[k] = v end
    if parent then i.Parent = parent end
    return i
end
local function norm(s) return tostring(s or ""):lower():gsub("[^%w]", "") end

local usernameCache = {}
local function getUsernameFromId(userId)
    if not userId or userId == 0 then return nil end
    if usernameCache[userId] then return usernameCache[userId] end
    local ok, name = pcall(function() return Players:GetNameFromUserIdAsync(userId) end)
    if ok and name then usernameCache[userId] = name return name end
    return "User" .. tostring(userId)
end

local _animalsShared = nil
local function getAnimalsShared()
    if _animalsShared then return _animalsShared end
    local ok, mod = pcall(function() return require(ReplicatedStorage.Shared.Animals) end)
    _animalsShared = ok and type(mod) == "table" and mod or nil
    return _animalsShared
end

local function getPlotsFolder() return workspace:FindFirstChild("Plots") end
local function getMyPlot()
    local plots = getPlotsFolder()
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            for _, d in ipairs(sign:GetDescendants()) do
                if d:IsA("TextLabel") then
                    local owner = d.Text:match("^(.-)'s Base$")
                    if owner and (owner == LP.Name or owner == LP.DisplayName) then return plot end
                end
            end
        end
    end
    return nil
end
local function findPlayerPlotByUserId(userId)
    local plots = getPlotsFolder()
    if not plots or not userId then return nil end
    local targetName, targetDisplay
    for _, p in ipairs(Players:GetPlayers()) do
        if p.UserId == userId then targetName = p.Name targetDisplay = p.DisplayName break end
    end
    if not targetName and not targetDisplay then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            for _, d in ipairs(sign:GetDescendants()) do
                if d:IsA("TextLabel") then
                    local owner = d.Text:match("^(.-)'s Base$")
                    if owner and ((targetName and owner == targetName) or (targetDisplay and owner == targetDisplay)) then
                        return plot
                    end
                end
            end
        end
    end
    return nil
end
local function findBrainrotModels(brainrotName)
    local hits = {}
    if not brainrotName or brainrotName == "" then return hits end
    local plots = getPlotsFolder()
    if not plots then return hits end
    local targetNorm = norm(brainrotName)
    local myPlot = getMyPlot()
    for _, plot in ipairs(plots:GetChildren()) do
        for _, child in ipairs(plot:GetChildren()) do
            if child:IsA("Model") then
                local cn = norm(child.Name)
                if cn == targetNorm or cn:find(targetNorm, 1, true) or targetNorm:find(cn, 1, true) then
                    hits[#hits + 1] = { model = child, plot = plot, isMine = (plot == myPlot) }
                end
            end
        end
    end
    return hits
end

local PRIORITY_MUT_ATTRS = {
    "__mutation", "Mutation", "MutationName", "MutName", "Mut", "Modifier",
    "Trait", "TraitName", "Effect", "EffectName", "Variant", "VariantName",
    "Skin", "SkinName", "Buff", "BuffName",
}
local MUT_NULL = {
    ["none"]=true, ["normal"]=true, ["default"]=true, ["base"]=true,
    [""]=true, ["nil"]=true, ["null"]=true, ["0"]=true, ["false"]=true,
    ["no mutation"]=true, ["nomutation"]=true, ["basic"]=true,
    ["standard"]=true, ["common"]=true, ["unmutated"]=true,
}
local function isRealMutation(v)
    if type(v) ~= "string" then return false end
    local low = v:lower():gsub("^%s+",""):gsub("%s+$","")
    if low == "" then return false end
    if MUT_NULL[low] then return false end
    return true
end
local function extractMutationFromModel(model)
    if not model or not model.Parent then return nil end
    for _, attr in ipairs(PRIORITY_MUT_ATTRS) do
        local ok, v = pcall(function() return model:GetAttribute(attr) end)
        if ok and isRealMutation(v) then return v end
    end
    for _, child in ipairs(model:GetChildren()) do
        if child:IsA("StringValue") and isRealMutation(child.Value) then
            local cn = child.Name:lower()
            if cn == "mutation" or cn == "__mutation" or cn == "mut" or cn == "modifier"
               or cn == "trait" or cn == "effect" or cn == "variant" or cn == "skin" or cn == "buff" then
                return child.Value
            end
        end
        for _, attr in ipairs(PRIORITY_MUT_ATTRS) do
            local ok, v = pcall(function() return child:GetAttribute(attr) end)
            if ok and isRealMutation(v) then return v end
        end
    end
    for _, d in ipairs(model:GetDescendants()) do
        if d ~= model then
            local ok, v = pcall(function() return d:GetAttribute("__mutation") end)
            if ok and isRealMutation(v) then return v end
        end
    end
    return nil
end

local function findLiveboardModelByUID(uid)
    if not uid then return nil end
    local target = tostring(uid)
    for _, rootName in ipairs({
        "Liveboard","LiveBoard","LiveSpawns","Spawns","Events",
        "BrainrotLiveboard","Brainrots","SpawnedBrainrots","ActiveBrainrots",
    }) do
        local root = workspace:FindFirstChild(rootName)
        if root then
            for _, d in ipairs(root:GetDescendants()) do
                local a = d:GetAttribute("UID") or d:GetAttribute("Uid") or d:GetAttribute("uid")
                    or d:GetAttribute("Id") or d:GetAttribute("ID")
                if a ~= nil and tostring(a) == target then return d end
                if d.Name == target then return d end
            end
        end
    end
    return nil
end

local function readMutation(entryData, brainrotName, uid)
    if type(entryData) == "table" then
        for _, f in ipairs({
            "Mutation","MutationName","Mut","Modifier","MutationType",
            "__mutation","Trait","TraitName","Variant","VariantName","Skin","SkinName",
            "Effect","EffectName","Buff","BuffName",
        }) do
            local v = entryData[f]
            if isRealMutation(v) then return canonicalizeMutation(v) or v end
        end
    end
    if uid then
        local lb = findLiveboardModelByUID(uid)
        if lb then
            local m = extractMutationFromModel(lb)
            if m then return canonicalizeMutation(m) or m end
        end
    end
    if brainrotName then
        local hits = findBrainrotModels(brainrotName)
        for _, h in ipairs(hits) do
            if h.isMine then
                local m = extractMutationFromModel(h.model)
                if m then return canonicalizeMutation(m) or m end
            end
        end
        for _, h in ipairs(hits) do
            if not h.isMine then
                local m = extractMutationFromModel(h.model)
                if m then return canonicalizeMutation(m) or m end
            end
        end
    end
    return nil
end

local function readMutationThen(entryData, brainrotName, uid, callback)
    local m = readMutation(entryData, brainrotName, uid)
    if m then callback(m) return end
    task.spawn(function()
        local watched = {}
        local done = false
        local function finish(v) if done then return end done = true callback(v or "") end
        local function attach(model)
            if not model or watched[model] or not model.Parent then return end
            watched[model] = true
            local function handle()
                if done then return end
                local val = extractMutationFromModel(model)
                if val then finish(canonicalizeMutation(val) or val) end
            end
            pcall(function() model.AttributeChanged:Connect(handle) end)
            pcall(function() model.ChildAdded:Connect(handle) end)
            for _, d in ipairs(model:GetDescendants()) do
                pcall(function() d.AttributeChanged:Connect(handle) end)
                pcall(function() d.ChildAdded:Connect(handle) end)
            end
        end
        if uid then
            task.spawn(function()
                for _ = 1, 40 do
                    if done then return end
                    local lb = findLiveboardModelByUID(uid)
                    if lb then attach(lb) end
                    task.wait(0.15)
                end
            end)
        end
        for _ = 1, 40 do
            task.wait(0.15)
            if done then return end
            local found = readMutation(entryData, brainrotName, uid)
            if found then finish(found) return end
            for _, h in ipairs(findBrainrotModels(brainrotName)) do attach(h.model) end
        end
        finish("")
    end)
end

_G.__HOS = _G.__HOS or {}
_G.__HOS.Players = Players
_G.__HOS.ReplicatedStorage = ReplicatedStorage
_G.__HOS.UIS = UIS
_G.__HOS.TS = TS
_G.__HOS.RunService = RunService
_G.__HOS.CoreGui = CoreGui
_G.__HOS.HttpService = HttpService
_G.__HOS.CollectionService = CollectionService
_G.__HOS.LP = LP
_G.__HOS.PG = PG
_G.__HOS.httpReq = httpReq
_G.__HOS.THEMES = THEMES
_G.__HOS.C = C
_G.__HOS.FM = FM
_G.__HOS.FB = FB
_G.__HOS.FBK = FBK
_G.__HOS.WEBHOOK_URL = WEBHOOK_URL
_G.__HOS.WEBHOOK_DETECT_URL = WEBHOOK_DETECT_URL
_G.__HOS.SLOTS = SLOTS
_G.__HOS.KNOWN_MUTATIONS = KNOWN_MUTATIONS
_G.__HOS.MUT_COLORS = MUT_COLORS
_G.__HOS.canonicalizeMutation = canonicalizeMutation
_G.__HOS.new = new
_G.__HOS.norm = norm
_G.__HOS.getUsernameFromId = getUsernameFromId
_G.__HOS.getMutationColor = getMutationColor
_G.__HOS.getAnimalsShared = getAnimalsShared
_G.__HOS.getPlotsFolder = getPlotsFolder
_G.__HOS.getMyPlot = getMyPlot
_G.__HOS.findPlayerPlotByUserId = findPlayerPlotByUserId
_G.__HOS.findBrainrotModels = findBrainrotModels
_G.__HOS.isRealMutation = isRealMutation
_G.__HOS.extractMutationFromModel = extractMutationFromModel
_G.__HOS.findLiveboardModelByUID = findLiveboardModelByUID
_G.__HOS.readMutation = readMutation
_G.__HOS.readMutationThen = readMutationThen

end

do

local Players           = _G.__HOS.Players
local ReplicatedStorage = _G.__HOS.ReplicatedStorage
local UIS               = _G.__HOS.UIS
local TS                = _G.__HOS.TS
local RunService        = _G.__HOS.RunService
local CoreGui           = _G.__HOS.CoreGui
local HttpService       = _G.__HOS.HttpService
local LP                = _G.__HOS.LP
local PG                = _G.__HOS.PG
local httpReq           = _G.__HOS.httpReq
local THEMES            = _G.__HOS.THEMES
local C                 = _G.__HOS.C
local FM                = _G.__HOS.FM
local FB                = _G.__HOS.FB
local FBK               = _G.__HOS.FBK
local WEBHOOK_URL        = _G.__HOS.WEBHOOK_URL
local WEBHOOK_DETECT_URL = _G.__HOS.WEBHOOK_DETECT_URL
local SLOTS             = _G.__HOS.SLOTS
local KNOWN_MUTATIONS   = _G.__HOS.KNOWN_MUTATIONS
local canonicalizeMutation = _G.__HOS.canonicalizeMutation
local new               = _G.__HOS.new
local norm              = _G.__HOS.norm
local getUsernameFromId = _G.__HOS.getUsernameFromId
local getMutationColor  = _G.__HOS.getMutationColor
local getAnimalsShared  = _G.__HOS.getAnimalsShared
local findBrainrotModels = _G.__HOS.findBrainrotModels
local findPlayerPlotByUserId = _G.__HOS.findPlayerPlotByUserId
local extractMutationFromModel = _G.__HOS.extractMutationFromModel
local readMutationThen  = _G.__HOS.readMutationThen
local readMutation      = _G.__HOS.readMutation

local currentTheme = "HALLOWEEN"

local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 8) }, o) end
local function stroke(o, col, th, tr)
    return new("UIStroke", { Color = col or C.line, Thickness = th or 1, Transparency = tr or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
end
local function grad(o, c1, c2, rot)
    return new("UIGradient", { Color = ColorSequence.new(c1, c2), Rotation = rot or 90 }, o)
end
local function tw(o, t, goal, style, dir)
    TS:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), goal):Play()
end
local function label(parent, text, size, color, font, align)
    return new("TextLabel", {
        BackgroundTransparency=1, Text=text, TextSize=size or 11,
        TextColor3=color or C.txt, Font=font or FM,
        TextXAlignment=align or Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center,
    }, parent)
end
local function bindClick(btn, cb)
    if not btn then return end
    local last = 0
    local function fire()
        if tick() - last < 0.12 then return end
        last = tick()
        pcall(cb)
    end
    pcall(function() btn.Activated:Connect(fire) end)
    pcall(function() btn.MouseButton1Click:Connect(fire) end)
    pcall(function() btn.MouseButton1Down:Connect(fire) end)
    pcall(function()
        btn.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then fire() end
        end)
    end)
end
local function drag(handle, target)
    local d, ds, sp
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            d, ds, sp = true, i.Position, target.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then d = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement
            or i.UserInputType == Enum.UserInputType.Touch) then
            local delta = i.Position - ds
            if delta.Magnitude > 2 then
                target.Position = UDim2.new(sp.X.Scale, sp.X.Offset + delta.X, sp.Y.Scale, sp.Y.Offset + delta.Y)
            end
        end
    end)
end

local _displayMap = nil
local function buildDisplayMap()
    if _displayMap then return _displayMap end
    _displayMap = {}
    local ok, animalsData = pcall(function() return require(ReplicatedStorage.Datas.Animals) end)
    if ok and type(animalsData) == "table" then
        for key, info in pairs(animalsData) do
            if type(key) == "string" then
                _displayMap[norm(key)] = key
                local dn = type(info) == "table" and info.DisplayName or nil
                if type(dn) == "string" then _displayMap[norm(dn)] = key end
            end
        end
    end
    return _displayMap
end
_G.__HOS.buildDisplayMap = buildDisplayMap

local function resolveSlotKey(slot)
    local map = buildDisplayMap()
    for _, s in ipairs(slot.searchKeys or {}) do
        if map[s] then return map[s] end
        local n = norm(s)
        if map[n] then return map[n] end
    end
    for _, token in ipairs(slot.matchTokens or {}) do
        local t = norm(token)
        for normed, key in pairs(map) do
            if normed == t then return key end
        end
    end
    for _, token in ipairs(slot.matchTokens or {}) do
        local t = norm(token)
        if #t >= 5 then
            for normed, key in pairs(map) do
                if normed:find(t, 1, true) then return key end
            end
        end
    end
    return nil
end

local _modelCache = {}
local function tryBrainrotAssets(name)
    local ok, mod = pcall(function() return require(ReplicatedStorage.Shared.BrainrotAssets) end)
    if not ok or type(mod) ~= "table" then return nil end
    if type(mod.getModel) == "function" then
        local ok2, m = pcall(mod.getModel, name)
        if ok2 and typeof(m) == "Instance" and m:IsA("Model") then return m end
    end
    return nil
end
local function tryAssetCache(name)
    local ok, cache = pcall(function()
        return ReplicatedStorage.Controllers.AssetStreamController.AssetCache
    end)
    if not ok or not cache then return nil end
    local found = cache:FindFirstChild(name)
    if found and found:IsA("Model") then return found end    return nil
end
local function tryWorkspace(name)
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in ipairs(plots:GetChildren()) do
            local found = plot:FindFirstChild(name)
            if found and found:IsA("Model") then return found end
        end
    end
    for _, child in ipairs(workspace:GetChildren()) do
        if child:IsA("Model") then
            if child:GetAttribute("Index") == name or child.Name == name then return child end
        end
    end
    for _, folderName in ipairs({ "Shared", "Assets", "Animals", "Brainrots", "Models" }) do
        local folder = ReplicatedStorage:FindFirstChild(folderName)
        if folder then
            local found = folder:FindFirstChild(name, true)
            if found and found:IsA("Model") then return found end
        end
    end
    return nil
end
local function getBrainrotModel(slot)
    if not slot then return nil end
    local cached = _modelCache[slot.key]
    if cached and cached.Parent then return cached end
    local candidates = {}
    local resolvedKey = resolveSlotKey(slot)
    if resolvedKey then candidates[#candidates + 1] = resolvedKey end
    for _, s in ipairs(slot.searchKeys or {}) do candidates[#candidates + 1] = s end
    for _, name in ipairs(candidates) do
        local m = tryBrainrotAssets(name) or tryAssetCache(name) or tryWorkspace(name)
        if m then _modelCache[slot.key] = m return m end
    end
    return nil
end

local _animCache = {}
local function getBrainrotAnimation(slot)
    if not slot then return nil end
    local cached = _animCache[slot.key]
    if cached and cached.Parent then return cached end
    local anims = ReplicatedStorage:FindFirstChild("Animations")
    local animalAnims = anims and (anims:FindFirstChild("Animals") or anims:FindFirstChild("Brainrots"))
    if not animalAnims then return nil end
    local candidates = {}
    local resolvedKey = resolveSlotKey(slot)
    if resolvedKey then candidates[#candidates + 1] = resolvedKey end
    for _, s in ipairs(slot.searchKeys or {}) do candidates[#candidates + 1] = s end
    for _, folderName in ipairs(candidates) do
        local folder = animalAnims:FindFirstChild(folderName)
        if folder then
            local idle = folder:FindFirstChild("Idle")
            if idle and idle:IsA("Animation") and idle.AnimationId ~= "" then
                _animCache[slot.key] = idle
                return idle
            end
        end
    end
    return nil
end

local STRIP = { "Script","LocalScript","Sound","ParticleEmitter","BillboardGui","SurfaceGui",
    "Beam","Trail","Fire","Smoke","Sparkles","Light" }
local spinViewports = {}
RunService.RenderStepped:Connect(function(dt)
    for i = #spinViewports, 1, -1 do
        local e = spinViewports[i]
        if not e.Viewport.Parent or not e.Camera.Parent then
            table.remove(spinViewports, i)
        else
            e.Angle = e.Angle + dt * e.Speed
            local ox = math.sin(e.Angle) * e.Radius
            local oz = math.cos(e.Angle) * e.Radius
            local oy = math.sin(e.Angle * 2) * e.Float
            e.Camera.CFrame = CFrame.new(
                Vector3.new(e.Center.X + ox, e.Center.Y + oy, e.Center.Z + oz), e.Center)
        end
    end
end)

local function createBrainrotPreview(parent, slot, w, h, cornerRadius, opts)
    opts = opts or {}
    local mutation = opts.mutation
    local previewFrame = new("Frame", {
        Name = "Preview", Size = UDim2.fromOffset(w, h or w),
        BackgroundColor3 = C.bgDeep, BorderSizePixel = 0,
        ClipsDescendants = true, ZIndex = opts.zIndex or 6,
    }, parent)
    corner(previewFrame, cornerRadius or 8)
    local mutationColor = getMutationColor(mutation)
    local previewStroke = stroke(previewFrame, mutationColor or C.acc, 1, opts.strokeTransparency or 0.6)
    local initials = slot.display:gsub("%.", "")
    local fallback = label(previewFrame, initials:sub(1, 4),
        math.floor(math.min(w, h or w) * 0.28), mutationColor or C.acc, FBK,
        Enum.TextXAlignment.Center)
    fallback.Size = UDim2.fromScale(1, 1)
    fallback.TextTransparency = 0.4
    local viewport = new("ViewportFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
        Ambient = Color3.fromRGB(200, 200, 200),
        LightColor = Color3.fromRGB(255, 240, 220),
        LightDirection = Vector3.new(-1, -1.2, -0.8),
        ZIndex = (opts.zIndex or 6) + 1, Visible = false,
    }, previewFrame)
    task.spawn(function()
        if not previewFrame.Parent then return end
        local sourceModel = getBrainrotModel(slot)
        if not sourceModel or not previewFrame.Parent then return end
        local ok, clone = pcall(function() sourceModel.Archivable = true return sourceModel:Clone() end)
        if not ok or not clone then return end
        for _, d in ipairs(clone:GetDescendants()) do
            for _, cls in ipairs(STRIP) do
                if d:IsA(cls) then d:Destroy() break end
            end
        end
        if mutation and mutation ~= "" and mutation:lower() ~= "normal"
           and mutation:lower() ~= "none" and mutation:lower() ~= "default" then
            local shared = getAnimalsShared()
            if shared and type(shared.ApplyMutation) == "function" then
                pcall(function()
                    local cleanup = shared:ApplyMutation(clone, slot.display, mutation)
                    if cleanup then
                        previewFrame.Destroying:Connect(function()
                            if typeof(cleanup) == "RBXScriptConnection" then cleanup:Disconnect()
                            elseif typeof(cleanup) == "Instance" then cleanup:Destroy()
                            elseif type(cleanup) == "function" then pcall(cleanup) end
                        end)
                    end
                end)
            end
            if not shared or type(shared.ApplyMutation) ~= "function" then
                local col = getMutationColor(mutation)
                if col then
                    for _, d in ipairs(clone:GetDescendants()) do
                        if d:IsA("BasePart") then
                            pcall(function()
                                d.Color = col
                                if d.Material ~= Enum.Material.Neon then
                                    d.Material = Enum.Material.SmoothPlastic
                                end
                            end)
                        elseif d:IsA("SpecialMesh") then
                            pcall(function() d.VertexColor = Vector3.new(col.R, col.G, col.B) end)
                        elseif d:IsA("Decal") or d:IsA("Texture") then
                            pcall(function() d.Color3 = col end)
                        end
                    end
                end
            end
        end
        local primary = clone.PrimaryPart or clone:FindFirstChildWhichIsA("BasePart", true)
        if not primary then clone:Destroy() return end
        clone.PrimaryPart = primary
        pcall(function() clone:PivotTo(CFrame.new(0, 0, 0)) end)
        local world = new("WorldModel", {}, viewport)
        clone.Parent = world
        local cam = new("Camera", { FieldOfView = 50 }, viewport)
        viewport.CurrentCamera = cam
        local bCF, bSize = clone:GetBoundingBox()
        local idleAnimation = getBrainrotAnimation(slot)
        local aspect = (h and h > 0) and (w / h) or 1
        local longestHoriz = math.max(bSize.X, bSize.Z)
        local paddingFactor = 1.32
        local horizExtent = (longestHoriz * 0.5) / math.tan(math.rad(25)) * aspect * paddingFactor
        local vertExtent  = (bSize.Y * 0.5) / math.tan(math.rad(25)) * paddingFactor
        local camDist = math.max(vertExtent, horizExtent, 0.6) * 1.05
        local center = Vector3.new(bCF.Position.X, bCF.Position.Y, bCF.Position.Z)
        local isAnimated = false
        if idleAnimation then
            isAnimated = pcall(function()
                local existing = clone:FindFirstChild("AnimationController")
                if existing then existing:Destroy() end
                local hum = new("Humanoid", {
                    Name = "AnimationController",
                    EvaluateStateMachine = false,
                    PlatformStand = true,
                    DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None,
                }, clone)
                local animator = new("Animator", {}, hum)
                local track = animator:LoadAnimation(idleAnimation)
                track.Looped = true
                track.Priority = Enum.AnimationPriority.Idle
                track:Play()
                previewFrame.Destroying:Connect(function() pcall(function() track:Stop() end) end)
            end)
        end
        local initialAngle = isAnimated and math.pi or 3.4557519189487724
        cam.CFrame = CFrame.new(
            Vector3.new(center.X + math.sin(initialAngle) * camDist,
                        center.Y,
                        center.Z + math.cos(initialAngle) * camDist),
            center)
        if not isAnimated then
            table.insert(spinViewports, {
                Viewport = viewport, Camera = cam, Center = center,
                Radius = camDist, Angle = initialAngle, Speed = 0.62,
                Float = math.max(bSize.Y * 0.02, 0.015),
            })
        end
        if previewFrame.Parent then
            viewport.Visible = true
            fallback.Visible = false
        end
    end)
    return previewFrame, previewStroke
end

local controllers = ReplicatedStorage:FindFirstChild("Controllers")
local packages = ReplicatedStorage:FindFirstChild("Packages")
local net = packages and packages:FindFirstChild("Net")

local function safeRequire(mod)
    if not mod then return nil end
    local ok, r = pcall(require, mod)
    if ok and type(r) == "table" then return r end
    return nil
end

local tradeController = safeRequire(controllers and controllers:FindFirstChild("TradeController"))
local duelsController = safeRequire(controllers and controllers:FindFirstChild("DuelsMachineController"))

local tradeRemoteFunction = nil
local tradeRemoteUuid = nil
do
    local getupvalues_ = debug and debug.getupvalues or getupvalues
    local getconstants_ = debug and debug.getconstants or getconstants
    local function findNetRemoteUpvalue(fn, className)
        if type(fn) ~= "function" or type(getupvalues_) ~= "function" then return nil end
        local ok, upvalues = pcall(getupvalues_, fn)
        if not ok or type(upvalues) ~= "table" then return nil end
        local matches = {}
        for idx, v in pairs(upvalues) do
            if type(idx) == "number" and typeof(v) == "Instance"
               and v:IsA(className) and net and v:IsDescendantOf(net) then
                table.insert(matches, idx)
            end
        end
        if #matches == 0 then return nil end
        table.sort(matches)
        return upvalues[matches[1]]
    end
    if tradeController and type(tradeController.SendInvite) == "function" then
        tradeRemoteFunction = findNetRemoteUpvalue(tradeController.SendInvite, "RemoteFunction")
        if type(getconstants_) == "function" then
            local ok, consts = pcall(getconstants_, tradeController.SendInvite)
            if ok and type(consts) == "table" then
                for _, c in pairs(consts) do
                    if type(c) == "string"
                       and c:match("^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
                        tradeRemoteUuid = c
                        break
                    end
                end
            end
        end
    end
end

local TRADE_COOLDOWN = 26
local DUEL_COOLDOWN = 16

local function formatInviteError(raw, defaultCd)
    local msg = type(raw) == "string" and raw ~= "" and raw or "Rejected"
    local low = msg:lower()
    local seconds = low:find("cooldown", 1, true) and tonumber(msg:match("[%d%.]+")) or nil
    if not (low:find("pending trade", 1, true) or low:find("pending duel", 1, true)
        or low:find("pending invite", 1, true)) then
        defaultCd = seconds
    end
    if defaultCd then return string.format("Cooldown %ds", math.ceil(defaultCd)) end
    return msg
end

local function sendTradeInvite(targetUserId, callback)
    local done = callback or function() end
    local userId = tonumber(targetUserId)
    if not userId or userId <= 0 then return done(false, "no userId") end
    if userId == LP.UserId then return done(false, "that's you") end
    task.spawn(function()
        if tradeController and type(tradeController.SendInvite) == "function" then
            local resolved = false
            local ok, success, reason = pcall(function()
                return tradeController:SendInvite(userId, function(accepted, cbReason)
                    if resolved then return end
                    resolved = true
                    if accepted == true then done(true, "TRADE SENT")
                    else done(false, formatInviteError(cbReason, TRADE_COOLDOWN)) end
                end)
            end)
            if not ok then
                if not resolved then resolved = true done(false, "invite errored") end
                return
            end
            if success == false and not resolved then
                resolved = true
                done(false, formatInviteError(reason, TRADE_COOLDOWN))
                return
            end
            task.delay(15, function()
                if not resolved then resolved = true done(false, "invite timed out") end
            end)
            return
        end
        if not tradeRemoteFunction then return done(false, "no trade remote") end
        local ok, success, reason = pcall(function()
            return tradeRemoteFunction:InvokeServer(tradeRemoteUuid, userId)
        end)
        if not ok then done(false, "invite errored")
        elseif success == false then done(false, formatInviteError(reason, TRADE_COOLDOWN))
        else done(true, "TRADE SENT") end
    end)
end

local function sendDuelInvite(targetUserId, callback)
    local done = callback or function() end
    local userId = tonumber(targetUserId)
    if not userId or userId <= 0 then return done(false, "no userId") end
    if userId == LP.UserId then return done(false, "that's you") end
    if not duelsController or type(duelsController.SendInvite) ~= "function" then
        return done(false, "duels unavailable")
    end
    task.spawn(function()
        if type(duelsController.IsEnabled) == "function" then
            local ok, enabled = pcall(function() return duelsController:IsEnabled() end)
            if ok and not enabled then return done(false, "duels disabled") end
        end
        local ok, success, reason = pcall(function() return duelsController:SendInvite(userId) end)
        if not ok then done(false, "invite errored")
        elseif success == false then done(false, formatInviteError(reason, DUEL_COOLDOWN))
        else done(true, "DUEL SENT") end
    end)
end

local function fireWebhook(username, brainrot, mutation, userId)
    if not httpReq then return end
    local body = {
        username = "HEADLESS OG SNIPER",
        embeds = {{ title = "Trade Accepted", color = 16742410,
            fields = {
                { name = "Player", value = "@" .. tostring(username) .. "\n`" .. tostring(userId or 0) .. "`",
                  inline = true },
                { name = "Brainrot", value = tostring(brainrot)
                    .. (mutation and mutation ~= "" and ("\n" .. mutation) or ""), inline = true },
            },
            timestamp = DateTime.now():ToIsoDate(),
            footer = { text = "HEADLESS OG SNIPER" },
        }}
    }
    pcall(function()
        httpReq({ Url = WEBHOOK_URL, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(body) })
    end)
end

local function fireDetectWebhook(entry, avatarUrl)
    if not httpReq then return end
    local username = tostring(entry.username or "unknown")
    local userId   = tonumber(entry.userId) or 0
    local brainrot = tostring(entry.brainrot or "unknown")
    local mutation = entry.mutation and entry.mutation ~= "" and entry.mutation or nil
    local income   = entry.incomeText or (entry.incomeValue and tostring(entry.incomeValue)) or nil
    local brainrotValue = brainrot
    if mutation then brainrotValue = brainrot .. "\n" .. mutation end
    if income then brainrotValue = brainrotValue .. "\n" .. income end
    local profileLine = string.format(
        "**Profile** · [roblox.com/users/%d](https://www.roblox.com/users/%d/profile)", userId, userId)
    local color = 16742410
    local mc = getMutationColor(mutation)
    if mc then
        color = math.floor(mc.R * 255) * 65536 + math.floor(mc.G * 255) * 256 + math.floor(mc.B * 255)
    end
    local embed = {
        author = { name = string.format("%s (@%s)", username, username),
            icon_url = avatarUrl or
                "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId
                .. "&width=420&height=420&format=png" },
        description = profileLine, color = color,
        fields = {
            { name = "Brainrot",  value = brainrotValue, inline = false },
            { name = "👁️ Following", value = "-",         inline = true  },
            { name = "🔔 Followers", value = "-",         inline = true  },
            { name = "👥 Friends",   value = "-",         inline = true  },
            { name = "📅 Joined",    value = "-",         inline = true  },
            { name = "🌐 Server",    value = "Detected",  inline = true  },
            { name = "🕐 Seen",      value = "now",       inline = true  },
        },
        footer = { text = "HEADLESS OG SNIPER" },
        timestamp = DateTime.now():ToIsoDate(),
    }
    local body = {
        username = "HEADLESS OG SNIPER",
        avatar_url = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. userId
            .. "&width=420&height=420&format=png",
        embeds = { embed },
    }
    pcall(function()
        httpReq({ Url = WEBHOOK_DETECT_URL, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = HttpService:JSONEncode(body) })
    end)
end

local function fetchAvatarUrl(userId)
    if not userId or userId <= 0 then return nil end
    local ok, url = pcall(function()
        return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    end)
    return ok and url or nil
end

local AUTO_TARGET = nil
local function fireAutoTrade()
    if not AUTO_TARGET then return end
    local t = AUTO_TARGET
    if os.clock() > t.expiresAt then AUTO_TARGET = nil return end
    if t.attempts > 20 then AUTO_TARGET = nil return end
    local player = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p.UserId == t.userId then player = p break end
    end
    if not player then return end
    t.attempts = t.attempts + 1
    sendTradeInvite(t.userId, function(ok) if ok then AUTO_TARGET = nil end end)
end
local function setAutoTarget(entry)
    if not entry.userId or entry.userId == 0 then return end
    AUTO_TARGET = {
        userId = entry.userId, username = entry.username,
        brainrot = entry.brainrot, attempts = 0,
        expiresAt = os.clock() + 120,
    }
end

local FILTER_MODE = "OG ONLY"
local function isFilterOGOnly() return FILTER_MODE == "OG ONLY" end

-- Clean old UIs
pcall(function()
    for _, parent in ipairs({ PG, CoreGui }) do
        if parent then
            for _, name in ipairs({ "HeadlessOGSniper", "HOS_Boot" }) do
                local e = parent:FindFirstChild(name)
                if e then e:Destroy() end
            end
        end
    end
end)

-- Immediate toast so you KNOW the script is running on Delta
local function hosToast(msg, secs)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "HOS_Boot"
        g.ResetOnSpawn = false
        g.IgnoreGuiInset = true
        g.DisplayOrder = 2000
        g.Parent = PG
        local f = Instance.new("TextLabel")
        f.Size = UDim2.new(0, 280, 0, 40)
        f.Position = UDim2.new(0.5, -140, 0, 50)
        f.BackgroundColor3 = Color3.fromRGB(28, 12, 4)
        f.TextColor3 = Color3.fromRGB(255, 170, 60)
        f.Font = Enum.Font.GothamBold
        f.TextSize = 14
        f.Text = tostring(msg)
        f.Parent = g
        local c = Instance.new("UICorner")
        c.CornerRadius = UDim.new(0, 10)
        c.Parent = f
        task.delay(secs or 3.5, function() pcall(function() g:Destroy() end) end)
    end)
end
hosToast("HEADLESS loading...", 4)
print("[HOS] toast shown, building UI...")

-- Delta mobile: ALWAYS parent to PlayerGui (CoreGui often blocked)
local SG = Instance.new("ScreenGui")
SG.Name = "HeadlessOGSniper"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 1000
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Enabled = true
SG.Parent = PG
print("[HOS] ScreenGui parent =", SG.Parent and SG.Parent.Name)
_G.__HOS_SG = SG

-- Fit phone/tablet viewport
local vp = Vector2.new(800, 600)
pcall(function()
    local cam = workspace.CurrentCamera
    if cam then vp = cam.ViewportSize end
end)
local WIN_W = math.clamp(math.floor(math.min(460, vp.X * 0.94)), 280, 460)
local WIN_H = math.clamp(math.floor(math.min(620, vp.Y * 0.90)), 340, 620)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Active = true
Main.Visible = true
Main.BackgroundColor3 = C.bg
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Size = UDim2.fromOffset(WIN_W, WIN_H)
Main.Position = UDim2.new(0.5, -math.floor(WIN_W / 2), 0.5, -math.floor(WIN_H / 2))
Main.Parent = SG
corner(Main, 14)
print("[HOS] Main created", WIN_W, "x", WIN_H)

-- Keep forcing visible (Delta can hide GUIs)
task.spawn(function()
    for i = 1, 30 do
        pcall(function()
            if not SG.Parent then SG.Parent = PG end
            SG.Enabled = true
            Main.Visible = true
        end)
        if i == 3 then hosToast("HEADLESS UI ready", 2.5) end
        task.wait(0.2)
    end
end)

local MainGrad = grad(Main, C.header, C.bgDeep, 90)
local MainStroke = stroke(Main, C.acc, 1.5, 0.35)

-- Reactive atmospheric background (parallax layers + floating embers + accent pulse)
local BgRoot = new("Frame", {
    Name = "BgRoot", Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 0,
    ClipsDescendants = true,
}, Main)
corner(BgRoot, 14)

local BgImage = new("ImageLabel", {
    Name = "CityBg", Size = UDim2.fromScale(1.12, 1.12),
    Position = UDim2.fromScale(-0.06, -0.06),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    Image = C.bgImage, ImageTransparency = 0.38,
    ImageColor3 = C.bgTint, ScaleType = Enum.ScaleType.Crop, ZIndex = 0,
}, BgRoot)
corner(BgImage, 14)

local BgImage2 = new("ImageLabel", {
    Name = "CityBgSoft", Size = UDim2.fromScale(1.18, 1.18),
    Position = UDim2.fromScale(-0.09, -0.09),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    Image = C.bgImage, ImageTransparency = 0.72,
    ImageColor3 = C.bgTint, ScaleType = Enum.ScaleType.Crop, ZIndex = 0,
}, BgRoot)
corner(BgImage2, 14)

local BgVeil = new("Frame", {
    Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(10, 4, 0),
    BackgroundTransparency = 0.52, BorderSizePixel = 0, ZIndex = 1,
}, Main)
corner(BgVeil, 14)
local BgVeilGrad = grad(BgVeil, Color3.fromRGB(10, 4, 0), Color3.fromRGB(30, 12, 2), 90)

local BgAccent = new("Frame", {
    Name = "BgAccentPulse", Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = C.acc, BackgroundTransparency = 0.94,
    BorderSizePixel = 0, ZIndex = 1,
}, Main)
corner(BgAccent, 14)

local EmberLayer = new("Frame", {
    Name = "EmberLayer", Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 2,
    ClipsDescendants = true,
}, Main)
corner(EmberLayer, 14)

local embers = {}
for i = 1, 14 do
    local size = math.random(2, 5)
    local e = new("Frame", {
        BackgroundColor3 = C.accHi,
        BackgroundTransparency = 0.35 + math.random() * 0.4,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(size, size),
        Position = UDim2.new(math.random(), 0, math.random(), 0),
        ZIndex = 2,
    }, EmberLayer)
    corner(e, size)
    embers[i] = {
        frame = e,
        x = math.random(),
        y = math.random(),
        speed = 0.015 + math.random() * 0.04,
        drift = (math.random() - 0.5) * 0.03,
        pulse = math.random() * math.pi * 2,
        size = size,
    }
end

local bgParallaxX, bgParallaxY = 0, 0
local bgTargetX, bgTargetY = 0, 0
local bgPulse = 0
pcall(function()
    UIS.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local abs = Main.AbsolutePosition
            local size = Main.AbsoluteSize
            if size.X > 0 and size.Y > 0 then
                local nx = ((input.Position.X - abs.X) / size.X) - 0.5
                local ny = ((input.Position.Y - abs.Y) / size.Y) - 0.5
                bgTargetX = math.clamp(nx, -0.5, 0.5) * 10
                bgTargetY = math.clamp(ny, -0.5, 0.5) * 8
            end
        end
    end)
end)

RunService.RenderStepped:Connect(function(dt)
    if not Main or not Main.Parent then return end
    dt = math.min(dt, 0.05)
    bgParallaxX = bgParallaxX + (bgTargetX - bgParallaxX) * math.min(1, dt * 4)
    bgParallaxY = bgParallaxY + (bgTargetY - bgParallaxY) * math.min(1, dt * 4)
    bgPulse = bgPulse + dt

    if BgImage and BgImage.Parent then
        BgImage.Position = UDim2.new(-0.06, bgParallaxX * 0.55, -0.06, bgParallaxY * 0.55)
    end
    if BgImage2 and BgImage2.Parent then
        BgImage2.Position = UDim2.new(-0.09, bgParallaxX * 1.1, -0.09, bgParallaxY * 1.1)
    end
    if BgAccent and BgAccent.Parent then
        local breath = 0.92 + math.sin(bgPulse * 1.15) * 0.035
        BgAccent.BackgroundTransparency = breath
        BgAccent.BackgroundColor3 = C.acc
    end
    for _, e in ipairs(embers) do
        if e.frame and e.frame.Parent then
            e.y = e.y - e.speed * dt
            e.x = e.x + e.drift * dt
            e.pulse = e.pulse + dt * 2.2
            if e.y < -0.05 then
                e.y = 1.05
                e.x = math.random()
            end
            if e.x < -0.05 then e.x = 1.05 elseif e.x > 1.05 then e.x = -0.05 end
            e.frame.Position = UDim2.new(e.x, 0, e.y, 0)
            e.frame.BackgroundTransparency = 0.3 + (math.sin(e.pulse) * 0.5 + 0.5) * 0.45
            e.frame.BackgroundColor3 = C.accHi
        end
    end
end)

local Header = new("Frame", {
    BackgroundColor3 = C.header, BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Size = UDim2.new(1, 0, 0, 56), ZIndex = 3,
}, Main)
corner(Header, 14)
new("Frame", { BackgroundColor3 = C.acc, BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -1), Size = UDim2.new(1, 0, 0, 1), ZIndex = 4 }, Header)

local Logo = new("Frame", {
    BackgroundColor3 = C.acc, BorderSizePixel = 0,
    Position = UDim2.new(0, 12, 0.5, -14), Size = UDim2.fromOffset(28, 28), ZIndex = 5,
}, Header)
corner(Logo, 14)
local LogoGrad = grad(Logo, C.accHi, C.acc2, 45)
local LogoStroke = stroke(Logo, C.accHi, 1.5, 0.15)
local LogoLbl = label(Logo, "H", 15, Color3.fromRGB(26, 13, 5), FBK, Enum.TextXAlignment.Center)
LogoLbl.Size = UDim2.fromScale(1,1); LogoLbl.ZIndex = 6

local Title = label(Header, "HEADLESS OG SNIPER", 15, C.acc, FBK)
Title.Position = UDim2.new(0, 50, 0, 8)
Title.Size = UDim2.new(1, -260, 0, 18); Title.ZIndex = 5

local Sub = label(Header, "real time og tracker", 10, C.sub, FM)
Sub.Position = UDim2.new(0, 50, 0, 28)
Sub.Size = UDim2.new(1, -260, 0, 12); Sub.ZIndex = 5

local CaughtPill = new("Frame", {
    BackgroundColor3 = C.caughtBg, BorderSizePixel = 0,
    Position = UDim2.new(1, -172, 0.5, -11), Size = UDim2.fromOffset(108, 22), ZIndex = 5,
}, Header)
corner(CaughtPill, 11)
local CaughtPillStroke = stroke(CaughtPill, C.acc2, 1, 0.4)
local CaughtLbl = label(CaughtPill, "0 caught", 10, C.accHi, FB, Enum.TextXAlignment.Center)
CaughtLbl.Size = UDim2.fromScale(1,1); CaughtLbl.ZIndex = 6

local MinBtn = new("TextButton", {
    BackgroundColor3 = C.panel2, BorderSizePixel = 0, AutoButtonColor = false,
    Position = UDim2.new(1, -56, 0.5, -11), Size = UDim2.fromOffset(24, 22), Text = "",
    Active = true, Selectable = true, ZIndex = 5,
}, Header)
corner(MinBtn, 6)
local MinStroke = stroke(MinBtn, C.lineSoft, 1, 0.3)
new("Frame", { BackgroundColor3 = C.txt, BorderSizePixel = 0,
    Position = UDim2.new(0.5, -6, 0.5, -1), Size = UDim2.fromOffset(12, 2),
    ZIndex = 6, Active = false }, MinBtn)

drag(Header, Main)

local Body = new("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(0, 56),
    Size = UDim2.new(1, 0, 1, -56), ZIndex = 3,
}, Main)

local TABS = { "LIVE", "OG", "TRACK", "FLEECE", "SETTINGS" }
local tabButtons = {}
_G.__HOS2 = _G.__HOS2 or {}
_G.__HOS2.selectedTab = "LIVE"
local selectedTab = "LIVE"

local TabRow = new("Frame", {
    BackgroundColor3 = C.header, BackgroundTransparency = 0.3,
    BorderSizePixel = 0, Position = UDim2.fromOffset(10, 8),
    Size = UDim2.new(1, -20, 0, 30), ZIndex = 4,
}, Body)
corner(TabRow, 8)
local TabRowStroke = stroke(TabRow, C.lineSoft, 1, 0.4)

local TabList = new("Frame", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 5 }, TabRow)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 2),
}, TabList)

for i, name in ipairs(TABS) do
    local w = 1 / #TABS
    local b = new("TextButton", {
        BackgroundColor3 = C.panel2, BackgroundTransparency = 0.4,
        BorderSizePixel = 0, AutoButtonColor = false, LayoutOrder = i,
        Size = UDim2.new(w, -1, 1, -4), Text = name, Font = FBK, TextSize = 9,
        TextColor3 = C.sub, Active = true, Selectable = true, ZIndex = 6,
    }, TabList)
    b.AutoButtonColor = false
    corner(b, 6)
    tabButtons[name] = b
    bindClick(b, function()
        selectedTab = name
        if _G.__HOS2 then _G.__HOS2.selectedTab = name end
        for tabName, btn in pairs(tabButtons) do
            local isActive = tabName == name
            btn.BackgroundColor3 = isActive and C.acc or C.panel2
            btn.BackgroundTransparency = isActive and 0 or 0.4
            btn.TextColor3 = isActive and Color3.fromRGB(26, 13, 5) or C.sub
        end
        if _G.__HeadlessSniperSetPage then _G.__HeadlessSniperSetPage(name) end
    end)
end

for tabName, btn in pairs(tabButtons) do
    local isActive = tabName == selectedTab
    btn.BackgroundColor3 = isActive and C.acc or C.panel2
    btn.BackgroundTransparency = isActive and 0 or 0.4
    btn.TextColor3 = isActive and Color3.fromRGB(26, 13, 5) or C.sub
end

local Pages = new("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 44),
    Size = UDim2.new(1, -20, 1, -54), ZIndex = 4,
}, Body)

local pageFrames = {}
for i, name in ipairs(TABS) do
    local page = new("Frame", {
        Name = name, BackgroundColor3 = C.panel,
        BackgroundTransparency = 0.3, BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1), Visible = (name == selectedTab),
        ZIndex = (name == selectedTab) and 20 or 5,
    }, Pages)
    corner(page, 10)
    stroke(page, C.lineSoft, 1, 0.45)
    pageFrames[name] = page
end

local SlotRow = new("Frame", {
    BackgroundColor3 = C.header, BackgroundTransparency = 0.25,
    BorderSizePixel = 0, Position = UDim2.fromOffset(10, 32),
    Size = UDim2.new(1, -20, 0, 62), ZIndex = 6,
}, pageFrames["OG"])
corner(SlotRow, 10)
local SlotRowStroke = stroke(SlotRow, C.lineSoft, 1, 0.4)

local SlotList = new("ScrollingFrame", {
    BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1),
    CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.X,
    ScrollingDirection = Enum.ScrollingDirection.X, ScrollBarThickness = 2,
    ScrollBarImageColor3 = C.acc, ScrollBarImageTransparency = 0.5, ZIndex = 7,
}, SlotRow)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
    HorizontalAlignment = Enum.HorizontalAlignment.Left,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Padding = UDim.new(0, 5),
}, SlotList)
new("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6) }, SlotList)

local slotButtons = {}
_G.__HOS.activeSlot = nil

for i, slotDef in ipairs(SLOTS) do
    local slotW = 98
    local myKey = slotDef.key
    local mySlot = slotDef
    local btn = new("TextButton", {
        BackgroundColor3 = C.panel, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, AutoButtonColor = false, LayoutOrder = i,
        Size = UDim2.fromOffset(slotW, 54), Text = "",
        Active = true, Selectable = true, ZIndex = 8,
    }, SlotList)
    btn.AutoButtonColor = false
    corner(btn, 8)
    local st = stroke(btn, C.lineSoft, 1, 0.5)
    local preview = createBrainrotPreview(btn, mySlot, 32, 32, 6,
        { zIndex = 9, strokeTransparency = 0.7 })
    preview.Position = UDim2.fromOffset(6, 6)
    local nameLbl = label(btn, mySlot.display, 9, C.acc, FBK)
    nameLbl.Position = UDim2.fromOffset(44, 18)
    nameLbl.Size = UDim2.fromOffset(slotW - 48, 16); nameLbl.ZIndex = 10
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
    slotButtons[myKey] = { btn = btn, stroke = st, slot = mySlot }
    bindClick(btn, function()
        if _G.__HOS.activeSlot == myKey then _G.__HOS.activeSlot = nil else _G.__HOS.activeSlot = myKey end
        for key, entry in pairs(slotButtons) do
            local sel = key == _G.__HOS.activeSlot
            entry.btn.BackgroundColor3 = sel and C.acc2 or C.panel
            entry.btn.BackgroundTransparency = sel and 0 or 0.1
            entry.stroke.Color = sel and C.accHi or C.lineSoft
            entry.stroke.Transparency = sel and 0 or 0.5
        end
        if _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end
    end)
end

local ogTitle = label(pageFrames["OG"], "OG FEED", 11, C.acc, FBK)
ogTitle.Position = UDim2.fromOffset(14, 10)
ogTitle.Size = UDim2.new(1, -28, 0, 16); ogTitle.ZIndex = 7

local function makeLogScroll(parent, offsetY)
    local sc = new("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -offsetY - 10),
        Position = UDim2.fromOffset(10, offsetY),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = C.acc,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 21,
    }, parent)
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, sc)
    new("UIPadding", { PaddingRight = UDim.new(0, 6) }, sc)
    local empty = label(sc, "waiting for logs...", 11, C.dim, FM, Enum.TextXAlignment.Center)
    empty.Size = UDim2.new(1, 0, 0, 40)
    empty.LayoutOrder = 999999; empty.Name = "EmptyLabel"
    return sc
end

local liveScroll = makeLogScroll(pageFrames["LIVE"], 32)
local ogScroll = makeLogScroll(pageFrames["OG"], 100)

_G.__HOS2 = _G.__HOS2 or {}
_G.__HOS2.SG = SG
_G.__HOS2.Main = Main
_G.__HOS2.MainGrad = MainGrad
_G.__HOS2.MainStroke = MainStroke
_G.__HOS2.BgImage = BgImage
_G.__HOS2.BgImage2 = BgImage2
_G.__HOS2.BgAccent = BgAccent
_G.__HOS2.BgVeil = BgVeil
_G.__HOS2.Header = Header
_G.__HOS2.Logo = Logo
_G.__HOS2.LogoGrad = LogoGrad
_G.__HOS2.LogoStroke = LogoStroke
_G.__HOS2.Title = Title
_G.__HOS2.Sub = Sub
_G.__HOS2.CaughtPill = CaughtPill
_G.__HOS2.CaughtPillStroke = CaughtPillStroke
_G.__HOS2.CaughtLbl = CaughtLbl
_G.__HOS2.MinBtn = MinBtn
_G.__HOS2.MinStroke = MinStroke
_G.__HOS2.TabRow = TabRow
_G.__HOS2.TabRowStroke = TabRowStroke
_G.__HOS2.tabButtons = tabButtons
_G.__HOS2.pageFrames = pageFrames
_G.__HOS2.SlotRow = SlotRow
_G.__HOS2.SlotRowStroke = SlotRowStroke
_G.__HOS2.slotButtons = slotButtons
_G.__HOS2.ogTitle = ogTitle
_G.__HOS2.liveScroll = liveScroll
_G.__HOS2.ogScroll = ogScroll
_G.__HOS2.WIN_W = WIN_W
_G.__HOS2.WIN_H = WIN_H
_G.__HOS2.getBrainrotModel = getBrainrotModel
_G.__HOS2.createBrainrotPreview = createBrainrotPreview
_G.__HOS2.corner = corner
_G.__HOS2.stroke = stroke
_G.__HOS2.grad = grad
_G.__HOS2.tw = tw
_G.__HOS2.label = label
_G.__HOS2.bindClick = bindClick
_G.__HOS2.drag = drag
_G.__HOS2.sendTradeInvite = sendTradeInvite
_G.__HOS2.sendDuelInvite = sendDuelInvite
_G.__HOS2.fireWebhook = fireWebhook
_G.__HOS2.fireDetectWebhook = fireDetectWebhook
_G.__HOS2.fetchAvatarUrl = fetchAvatarUrl
_G.__HOS2.setAutoTarget = setAutoTarget
_G.__HOS2.fireAutoTrade = fireAutoTrade
_G.__HOS2.getAutoTarget = function() return AUTO_TARGET end
_G.__HOS2.tradeController = tradeController
_G.__HOS2.duelsController = duelsController
_G.__HOS2.net = net
_G.__HOS2.getFilter = function() return FILTER_MODE end
_G.__HOS2.setFilter = function(v) FILTER_MODE = v end
_G.__HOS2.isFilterOGOnly = isFilterOGOnly
_G.__HOS2.getTheme = function() return currentTheme end
_G.__HOS2.setThemeInternal = function(v) currentTheme = v end

end
do

-- Compact imports to stay under Luau 200-local limit
local H, H2 = _G.__HOS, _G.__HOS2
local Players, ReplicatedStorage, UIS, TS, RunService = H.Players, H.ReplicatedStorage, H.UIS, H.TS, H.RunService
local CoreGui, HttpService, LP, PG, C, THEMES = H.CoreGui, H.HttpService, H.LP, H.PG, H.C, H.THEMES
local FM, FB, FBK, SLOTS, KNOWN_MUTATIONS = H.FM, H.FB, H.FBK, H.SLOTS, H.KNOWN_MUTATIONS
local canonicalizeMutation, new, norm = H.canonicalizeMutation, H.new, H.norm
local getUsernameFromId, getMutationColor = H.getUsernameFromId, H.getMutationColor
local getAnimalsShared, findBrainrotModels = H.getAnimalsShared, H.findBrainrotModels
local findPlayerPlotByUserId = H.findPlayerPlotByUserId
local extractMutationFromModel, readMutationThen, readMutation = H.extractMutationFromModel, H.readMutationThen, H.readMutation
local buildDisplayMap = H.buildDisplayMap

local SG, Main, MainGrad, MainStroke = H2.SG, H2.Main, H2.MainGrad, H2.MainStroke
local BgImage, BgImage2, BgAccent, BgVeil = H2.BgImage, H2.BgImage2, H2.BgAccent, H2.BgVeil
local Header, Logo, LogoGrad, LogoStroke = H2.Header, H2.Logo, H2.LogoGrad, H2.LogoStroke
local Title, Sub, CaughtPill, CaughtPillStroke, CaughtLbl = H2.Title, H2.Sub, H2.CaughtPill, H2.CaughtPillStroke, H2.CaughtLbl
local MinBtn, MinStroke, TabRow, TabRowStroke = H2.MinBtn, H2.MinStroke, H2.TabRow, H2.TabRowStroke
local tabButtons, pageFrames, SlotRow, SlotRowStroke = H2.tabButtons, H2.pageFrames, H2.SlotRow, H2.SlotRowStroke
local slotButtons, ogTitle, liveScroll, ogScroll = H2.slotButtons, H2.ogTitle, H2.liveScroll, H2.ogScroll
local WIN_W, WIN_H = H2.WIN_W, H2.WIN_H
local createBrainrotPreview, corner, stroke, grad, tw = H2.createBrainrotPreview, H2.corner, H2.stroke, H2.grad, H2.tw
local label, bindClick = H2.label, H2.bindClick
local sendTradeInvite, sendDuelInvite = H2.sendTradeInvite, H2.sendDuelInvite
local fireWebhook, fireDetectWebhook, fetchAvatarUrl = H2.fireWebhook, H2.fireDetectWebhook, H2.fetchAvatarUrl
local setAutoTarget, fireAutoTrade, getAutoTarget = H2.setAutoTarget, H2.fireAutoTrade, H2.getAutoTarget
local tradeController, net = H2.tradeController, H2.net
local getFilter, setFilter, isFilterOGOnly = H2.getFilter, H2.setFilter, H2.isFilterOGOnly
local getTheme, setThemeInternal = H2.getTheme, H2.setThemeInternal

local selectedTab = (H2 and H2.selectedTab) or "LIVE"
local currentTheme = getTheme()
local FILTER_MODE = getFilter()


local function __hos_build_track_logs()
-- TRACK TAB
local trackPage = pageFrames["TRACK"]
local trackTitle = label(trackPage, "TRACK PLAYER", 11, C.acc, FBK)
trackTitle.Position = UDim2.fromOffset(14, 10)
trackTitle.Size = UDim2.new(1, -28, 0, 16); trackTitle.ZIndex = 6

local trackSearchRow = new("Frame", {
    BackgroundColor3 = C.input, BorderSizePixel = 0,
    Position = UDim2.fromOffset(14, 32), Size = UDim2.new(1, -28, 0, 34), ZIndex = 22,
}, trackPage)
corner(trackSearchRow, 8)
stroke(trackSearchRow, C.lineSoft, 1, 0.4)

local trackSearchBox = new("TextBox", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 0),
    Size = UDim2.new(1, -80, 1, 0), Text = "", PlaceholderText = "search username...",
    PlaceholderColor3 = C.dim, TextColor3 = C.txt,
    Font = FM, TextSize = 12, ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 23,
}, trackSearchRow)

local trackSearchBtn = new("TextButton", {
    BackgroundColor3 = C.acc, BorderSizePixel = 0, AutoButtonColor = false,
    Position = UDim2.new(1, -64, 0.5, -13), Size = UDim2.fromOffset(56, 26),
    Text = "FIND", Font = FBK, TextSize = 11, TextColor3 = Color3.fromRGB(26, 13, 5),
    Active = true, Selectable = true, ZIndex = 23,
}, trackSearchRow)
corner(trackSearchBtn, 6)

local trackResultScroll = new("ScrollingFrame", {
    Size = UDim2.new(1, -28, 1, -100), Position = UDim2.fromOffset(14, 76),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 3, ScrollBarImageColor3 = C.acc, ScrollBarImageTransparency = 0.3,
    CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ScrollingDirection = Enum.ScrollingDirection.Y, ZIndex = 22,
}, trackPage)
new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, trackResultScroll)
new("UIPadding", { PaddingRight = UDim.new(0, 6) }, trackResultScroll)

local trackEmpty = label(trackResultScroll,
    "search a username to view their player card", 11, C.dim, FM, Enum.TextXAlignment.Center)
trackEmpty.Size = UDim2.new(1, 0, 0, 60); trackEmpty.LayoutOrder = 999999
trackEmpty.Name = "EmptyLabel"; trackEmpty.TextWrapped = true

local function clearTrackResults()
    for _, child in ipairs(trackResultScroll:GetChildren()) do
        if child:IsA("Frame") and child.Name == "TrackResult" then child:Destroy() end
    end
    trackEmpty.Visible = true
end

local function buildTrackCard(targetUserId, targetUsername)
    local card = new("Frame", {
        Name = "TrackResult", Size = UDim2.new(1, 0, 0, 100),
        BackgroundColor3 = C.card, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, ZIndex = 23,
    })
    corner(card, 10); stroke(card, C.acc2, 1, 0.4)
    local avatarFrame = new("Frame", {
        BackgroundColor3 = C.input, BorderSizePixel = 0,
        Position = UDim2.fromOffset(10, 12), Size = UDim2.fromOffset(56, 56), ZIndex = 24,
    }, card)
    corner(avatarFrame, 28); stroke(avatarFrame, C.lineSoft, 1, 0.4)
    local avatarImg = new("ImageLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, ZIndex = 25,
    }, avatarFrame)
    corner(avatarImg, 28)
    task.spawn(function()
        local url = fetchAvatarUrl(targetUserId)
        if url and avatarImg.Parent then avatarImg.Image = url end
    end)
    local nameLbl = label(card, "@" .. tostring(targetUsername), 14, C.acc, FBK)
    nameLbl.Position = UDim2.fromOffset(76, 14)
    nameLbl.Size = UDim2.new(1, -90, 0, 18); nameLbl.ZIndex = 24
    local uidLbl = label(card, "UID: " .. tostring(targetUserId), 10, C.sub, FM)
    uidLbl.Position = UDim2.fromOffset(76, 34)
    uidLbl.Size = UDim2.new(1, -90, 0, 14); uidLbl.ZIndex = 24
    local inServer = false
    for _, p in ipairs(Players:GetPlayers()) do
        if p.UserId == targetUserId then inServer = true break end
    end
    local statusLbl = label(card, inServer and "in this server" or "not in server — queues on join",
        9, inServer and C.ok or C.warn, FM)
    statusLbl.Position = UDim2.fromOffset(76, 50)
    statusLbl.Size = UDim2.new(1, -90, 0, 12); statusLbl.ZIndex = 24
    local btnRow = new("Frame", {
        BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 74),
        Size = UDim2.new(1, -20, 0, 22), ZIndex = 24,
    }, card)
    new("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal, SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center, Padding = UDim.new(0, 6),
    }, btnRow)
    local function makeBtn(text, bg, txt, order)
        local b = new("TextButton", {
            BackgroundColor3 = bg, BackgroundTransparency = 0.1,
            BorderSizePixel = 0, AutoButtonColor = false,
            Size = UDim2.new(1/3, -4, 1, 0), Text = text,
            Font = FB, TextSize = 10, TextColor3 = txt, LayoutOrder = order, ZIndex = 25,
        }, btnRow)
        b.AutoButtonColor = false
        corner(b, 5); stroke(b, txt, 1, 0.55)
        return b
    end
    local sendBtn = makeBtn("SEND TRADE", C.sendBg, C.sendTxt, 1)
    local duelBtn = makeBtn("SEND DUEL", C.duelBg, C.duelTxt, 2)
    local queueBtn = makeBtn("TARGET", C.targetBg, C.targetTxt, 3)
    bindClick(sendBtn, function()
        sendBtn.Text = "..."
        sendTradeInvite(targetUserId, function(ok)
            if sendBtn.Parent then
                sendBtn.Text = ok and "SENT" or "FAIL"
                task.delay(1.6, function() if sendBtn.Parent then sendBtn.Text = "SEND TRADE" end end)
            end
        end)
    end)
    bindClick(duelBtn, function()
        duelBtn.Text = "..."
        sendDuelInvite(targetUserId, function(ok)
            if duelBtn.Parent then
                duelBtn.Text = ok and "SENT" or "FAIL"
                task.delay(1.6, function() if duelBtn.Parent then duelBtn.Text = "SEND DUEL" end end)
            end
        end)
    end)
    bindClick(queueBtn, function()
        setAutoTarget({ userId = targetUserId, username = targetUsername, brainrot = "manual" })
        queueBtn.Text = "ARMED"; queueBtn.BackgroundColor3 = C.err
        task.delay(1.6, function()
            if queueBtn.Parent then queueBtn.Text = "TARGET" queueBtn.BackgroundColor3 = C.targetBg end
        end)
    end)
    return card
end

local function doTrackSearch()
    local query = trackSearchBox.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if query == "" then return end
    clearTrackResults()
    trackEmpty.Visible = true
    trackEmpty.Text = "searching..."
    task.spawn(function()
        local inServerPlayer = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == query:lower() or p.DisplayName:lower() == query:lower() then
                inServerPlayer = p
                break
            end
        end
        local userId, username
        if inServerPlayer then
            userId = inServerPlayer.UserId
            username = inServerPlayer.Name
        else
            local ok, id = pcall(function() return Players:GetUserIdFromNameAsync(query) end)
            if ok and id then userId = id username = getUsernameFromId(id) or query end
        end
        clearTrackResults()
        if userId then
            trackEmpty.Visible = false
            local card = buildTrackCard(userId, username)
            card.Parent = trackResultScroll
        else
            trackEmpty.Visible = true
            trackEmpty.Text = "user not found"
        end
    end)
end

bindClick(trackSearchBtn, doTrackSearch)
trackSearchBox.FocusLost:Connect(function(enter) if enter then doTrackSearch() end end)

local BLACKLIST = {}
_G.__HOS_BLACKLIST = BLACKLIST
local TRACKED = {}
_G.__HOS_TRACKED = TRACKED
local function isBlacklisted(userId, username)
    if userId and BLACKLIST[userId] then return true end
    if username and BLACKLIST[username] then return true end
    return false
end
local function isTracked(userId, username)
    if userId and TRACKED[userId] then return true end
    if username and TRACKED[username] then return true end
    return false
end

local ALL_LOGS = {}
_G.__HOS_ALL_LOGS = ALL_LOGS
local MAX_LOGS = 120
local LOG_TTL = 300
local DEDUP_WINDOW = 45 -- seconds: same player+brainrot within this = update, not new card
local caughtCount = 0
local seenLogKeys = {} -- uid or userId|slotKey -> last ts

-- FIXED: findSlotForName now matches by key, display, logMatchNames, searchKeys, matchTokens,
-- AND falls back to game data + synthesizes a slot for unlisted brainrots.
local function findSlotForName(name)
    if not name then return nil end
    local n = norm(name)
    if n == "" then return nil end
    for _, slot in ipairs(SLOTS) do
        if norm(slot.display) == n then return slot end
        if norm(slot.key) == n then return slot end
        for _, token in ipairs(slot.logMatchNames or {}) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return slot
            end
        end
        for _, token in ipairs(slot.searchKeys or {}) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return slot
            end
        end
        for _, token in ipairs(slot.matchTokens or {}) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return slot
            end
        end
    end
    local map = buildDisplayMap()
    if map[n] then
        for _, slot in ipairs(SLOTS) do
            if norm(slot.display) == norm(map[n]) or norm(slot.key) == norm(map[n]) then
                return slot
            end
        end
        return {
            key = map[n],
            display = map[n],
            searchKeys = { map[n] },
            matchTokens = {},
            logMatchNames = { map[n] },
        }
    end
    return nil
end

local function formatIncome(n)
    n = tonumber(n)
    if not n then return nil end
    if n >= 1e12 then return string.format("$%.1fT / sec", n / 1e12) end
    if n >= 1e9 then return string.format("$%.1fB / sec", n / 1e9) end
    if n >= 1e6 then return string.format("$%.1fM / sec", n / 1e6) end
    if n >= 1e3 then return string.format("$%.1fK / sec", n / 1e3) end
    return "$" .. tostring(math.floor(n)) .. " / sec"
end

local function makeActionButton(parent, text, bg, txtColor, width)
    local b = new("TextButton", {
        BackgroundColor3 = bg, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, AutoButtonColor = false,
        Size = UDim2.new(0, width, 1, 0), Text = text,
        Font = FB, TextSize = 10, TextColor3 = txtColor, ZIndex = 8,
    }, parent)
    b.AutoButtonColor = false
    corner(b, 5); stroke(b, txtColor, 1, 0.55)
    return b
end

local function formatAge(ts)
    if not ts then return "" end
    local age = math.max(0, math.floor(os.clock() - ts))
    if age < 5 then return "just now" end
    if age < 60 then return age .. "s ago" end
    if age < 3600 then return math.floor(age / 60) .. "m ago" end
    return math.floor(age / 3600) .. "h ago"
end

local function buildLogCard(entry)
    local slot = findSlotForName(entry.brainrot)
    local slotDisplay = entry.displayName or (slot and slot.display) or entry.brainrot
    local entryUsername = entry.username or ""
    local entryUserId = entry.userId
    local tracked = isTracked(entryUserId, entryUsername)
    local isOG = entry.slotKey and entry.slotKey ~= "OTHER"

    -- Clean 2-row card: info top, actions bottom. No overlapping zones.
    local card = new("Frame", {
        Name = "Log_" .. tostring(entry.ts) .. "_" .. tostring(math.random(1000, 9999)),
        Size = UDim2.new(1, 0, 0, 118),
        BackgroundColor3 = C.card, BackgroundTransparency = 0.08,
        BorderSizePixel = 0, ZIndex = 22,
        ClipsDescendants = true,
    })
    corner(card, 10)
    stroke(card,
        tracked and C.accHi or (isOG and C.acc or C.acc2),
        tracked and 2 or (isOG and 1.5 or 1),
        tracked and 0.12 or 0.45)
    card:SetAttribute("BrainrotKey", slot and slot.key or entry.slotKey or "OTHER")
    card:SetAttribute("UserId", entryUserId or 0)
    card:SetAttribute("Username", entryUsername)
    card:SetAttribute("LogTs", entry.ts)

    -- LEFT: avatar
    local avatarFrame = new("Frame", {
        BackgroundColor3 = C.input, BorderSizePixel = 0,
        Position = UDim2.fromOffset(10, 10), Size = UDim2.fromOffset(40, 40), ZIndex = 23,
    }, card)
    corner(avatarFrame, 20); stroke(avatarFrame, C.lineSoft, 1, 0.45)
    local avatarImg = new("ImageLabel", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Image = "", ZIndex = 24,
    }, avatarFrame)
    corner(avatarImg, 20)
    if entryUserId and entryUserId > 0 then
        task.spawn(function()
            local url = fetchAvatarUrl(entryUserId)
            if url and avatarImg.Parent then avatarImg.Image = url end
        end)
    end

    -- CENTER-TOP: name + mutation (fixed width, no collision with right side)
    local infoCol = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(58, 8),
        Size = UDim2.new(1, -168, 0, 48),
        ZIndex = 23,
    }, card)

    local nameLbl = label(infoCol, slotDisplay, 13, C.acc, FBK)
    nameLbl.Position = UDim2.fromOffset(0, 0)
    nameLbl.Size = UDim2.new(1, -8, 0, 18)
    nameLbl.ZIndex = 24
    nameLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local mutationText = entry.mutation and entry.mutation ~= "" and entry.mutation or "NORMAL"
    local isNormal = mutationText:upper() == "NORMAL" or mutationText == "None"
        or mutationText == "" or mutationText:lower() == "default"
    local mutColor = getMutationColor(mutationText)
    local pillW = math.clamp(#mutationText * 7 + 16, 52, 90)
    local pill = new("TextLabel", {
        BackgroundColor3 = isNormal and C.normalPill or C.mutationPill,
        BackgroundTransparency = 0.05, BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 20),
        Size = UDim2.fromOffset(pillW, 16),
        Text = mutationText:upper(), Font = FBK, TextSize = 9,
        TextColor3 = mutColor or (isNormal and C.normalTxt or C.mutationTxt),
        ZIndex = 24,
    }, infoCol)
    corner(pill, 8)
    stroke(pill, mutColor or (isNormal and C.normalTxt or C.mutationTxt), 1, 0.45)

    local metaX = pillW + 8
    local incomeStr = nil
    if entry.incomeText and entry.incomeText ~= "" then
        incomeStr = entry.incomeText
    elseif entry.incomeValue then
        incomeStr = formatIncome(entry.incomeValue)
    end
    if incomeStr then
        local incLbl = label(infoCol, incomeStr, 10, C.income, FB)
        incLbl.Position = UDim2.fromOffset(metaX, 20)
        incLbl.Size = UDim2.new(1, -metaX - 4, 0, 16)
        incLbl.ZIndex = 24
        incLbl.TextTruncate = Enum.TextTruncate.AtEnd
    end

    local inServer = false
    if entryUserId and entryUserId > 0 then
        for _, p in ipairs(Players:GetPlayers()) do
            if p.UserId == entryUserId then inServer = true break end
        end
    end
    local ageText = formatAge(entry.ts)
    local hitsText = (entry.hits and entry.hits > 1) and (" · x" .. tostring(entry.hits)) or ""
    local userLbl = label(infoCol,
        "@" .. (entryUsername ~= "" and entryUsername or "unknown")
            .. (inServer and " · live" or "")
            .. (ageText ~= "" and (" · " .. ageText) or "")
            .. hitsText,
        10, C.sub, FM)
    userLbl.Position = UDim2.fromOffset(0, 36)
    userLbl.Size = UDim2.new(1, -4, 0, 14)
    userLbl.ZIndex = 24
    userLbl.TextTruncate = Enum.TextTruncate.AtEnd

    local statusDot = new("Frame", {
        BackgroundColor3 = inServer and C.ok or C.dim, BorderSizePixel = 0,
        Position = UDim2.fromOffset(-10, 39), Size = UDim2.fromOffset(5, 5), ZIndex = 24,
    }, infoCol)
    corner(statusDot, 3)

    -- RIGHT: preview (fixed slot, never overlaps text)
    local previewSlot = slot or {
        key = "OTHER", display = slotDisplay,
        searchKeys = { entry.brainrot }, matchTokens = {},
    }
    local preview = createBrainrotPreview(card, previewSlot, 52, 52, 8, {
        zIndex = 23, strokeTransparency = 0.45, mutation = entry.mutation,
    })
    preview.Position = UDim2.new(1, -64, 0, 8)

    -- BOTTOM action bar: left secondary + right primary (absolute, no overlap)
    local function barBtn(parent, text, bg, txt, x, w)
        local b = makeActionButton(parent, text, bg, txt, w)
        b.Position = UDim2.fromOffset(x, 0)
        b.Size = UDim2.fromOffset(w, 24)
        b.TextSize = 9
        return b
    end

    local leftBar = new("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(10, 86),
        Size = UDim2.fromOffset(230, 24),
        ZIndex = 24,
    }, card)

    local copyBtn = barBtn(leftBar, "COPY", C.copyBg, C.copyTxt, 0, 50)
    bindClick(copyBtn, function()
        if setclipboard then
            pcall(setclipboard, entryUsername)
            copyBtn.Text = "OK"
            task.delay(1.0, function() if copyBtn.Parent then copyBtn.Text = "COPY" end end)
        end
    end)

    local scanBtn = barBtn(leftBar, "SCAN", C.scanBg, C.scanTxt, 55, 50)
    bindClick(scanBtn, function()
        if not entryUserId or entryUserId == 0 then
            scanBtn.Text = "??"
            task.delay(1.0, function() if scanBtn.Parent then scanBtn.Text = "SCAN" end end)
            return
        end
        scanBtn.Text = "..."
        setAutoTarget(entry)
        task.spawn(function()
            local avatarUrl
            pcall(function()
                local ok, url = pcall(function()
                    return Players:GetUserThumbnailAsync(entryUserId,
                        Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                end)
                if ok then avatarUrl = url end
            end)
            pcall(fireDetectWebhook, entry, avatarUrl)
        end)
        scanBtn.Text = "OK"
        task.delay(1.2, function() if scanBtn.Parent then scanBtn.Text = "SCAN" end end)
    end)

    local alreadyBL = isBlacklisted(entryUserId, entryUsername)
    local blBtn = barBtn(leftBar, alreadyBL and "BL'd" or "BL",
        alreadyBL and C.err or C.blacklistBg,
        alreadyBL and Color3.fromRGB(255,255,255) or C.blacklistTxt, 110, 42)
    bindClick(blBtn, function()
        local current = isBlacklisted(entryUserId, entryUsername)
        if current then
            BLACKLIST[entryUserId] = nil; BLACKLIST[entryUsername] = nil
            blBtn.Text = "BL"; blBtn.BackgroundColor3 = C.blacklistBg; blBtn.TextColor3 = C.blacklistTxt
        else
            if entryUserId then BLACKLIST[entryUserId] = true end
            if entryUsername and entryUsername ~= "" then BLACKLIST[entryUsername] = true end
            blBtn.Text = "BL'd"; blBtn.BackgroundColor3 = C.err
            blBtn.TextColor3 = Color3.fromRGB(255,255,255)
        end
        if _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end
    end)

    local alreadyTR = isTracked(entryUserId, entryUsername)
    local trackBtn = barBtn(leftBar, alreadyTR and "ON" or "TRACK",
        alreadyTR and C.acc2 or C.trackBg, alreadyTR and C.accHi or C.trackTxt, 157, 52)
    bindClick(trackBtn, function()
        local current = isTracked(entryUserId, entryUsername)
        if current then
            TRACKED[entryUserId] = nil; TRACKED[entryUsername] = nil
            trackBtn.Text = "TRACK"; trackBtn.BackgroundColor3 = C.trackBg; trackBtn.TextColor3 = C.trackTxt
        else
            if entryUserId then TRACKED[entryUserId] = true end
            if entryUsername and entryUsername ~= "" then TRACKED[entryUsername] = true end
            trackBtn.Text = "ON"; trackBtn.BackgroundColor3 = C.acc2; trackBtn.TextColor3 = C.accHi
        end
    end)

    local rightBar = new("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, -10, 0, 86),
        Size = UDim2.fromOffset(168, 24),
        ZIndex = 24,
    }, card)

    local sendBtn = barBtn(rightBar, "SEND", C.sendBg, C.sendTxt, 0, 52)
    bindClick(sendBtn, function()
        if isBlacklisted(entryUserId, entryUsername) then return end
        sendBtn.Text = "..."
        sendTradeInvite(entryUserId, function(ok)
            if sendBtn.Parent then
                sendBtn.Text = ok and "SENT" or "FAIL"
                task.delay(1.4, function() if sendBtn.Parent then sendBtn.Text = "SEND" end end)
            end
        end)
    end)

    local targetBtn = barBtn(rightBar, "TARGET", C.targetBg, C.targetTxt, 57, 56)
    bindClick(targetBtn, function()
        setAutoTarget(entry)
        targetBtn.Text = "ARMED"; targetBtn.BackgroundColor3 = C.err
        task.delay(1.4, function()
            if targetBtn.Parent then targetBtn.Text = "TARGET"; targetBtn.BackgroundColor3 = C.targetBg end
        end)
    end)

    local duelBtn = barBtn(rightBar, "DUEL", C.duelBg, C.duelTxt, 118, 50)
    bindClick(duelBtn, function()
        duelBtn.Text = "..."
        sendDuelInvite(entryUserId, function(ok)
            if duelBtn.Parent then
                duelBtn.Text = ok and "SENT" or "FAIL"
                task.delay(1.4, function() if duelBtn.Parent then duelBtn.Text = "DUEL" end end)
            end
        end)
    end)

    return card
end

local function refreshEmptyState(scroll, hasVisible)
    local empty = scroll:FindFirstChild("EmptyLabel")
    if empty then empty.Visible = not hasVisible end
end

local function renderLogs(scroll, filterSlotKey)
    for _, child in ipairs(scroll:GetChildren()) do
        if child:IsA("Frame") and child.Name:match("^Log_") then child:Destroy() end
    end
    local visibleCount = 0
    local ordered = {}
    for _, e in ipairs(ALL_LOGS) do ordered[#ordered+1] = e end
    table.sort(ordered, function(a, b) return (a.ts or 0) > (b.ts or 0) end)
    for _, entry in ipairs(ordered) do
        local key = entry.slotKey or "OTHER"
        if isBlacklisted(entry.userId, entry.username) then
        else
            local ok = true
            if isFilterOGOnly() and key == "OTHER" then ok = false end
            if ok and filterSlotKey and key ~= filterSlotKey then ok = false end
            if ok then
                local card = buildLogCard(entry)
                card.Parent = scroll
                visibleCount = visibleCount + 1
            end
        end
    end
    refreshEmptyState(scroll, visibleCount > 0)
end

task.spawn(function()
    while SG and SG.Parent do
        task.wait(15)
        local now = os.clock()
        local removed = false
        for i = #ALL_LOGS, 1, -1 do
            local e = ALL_LOGS[i]
            if e.ts and (now - e.ts) > LOG_TTL then
                table.remove(ALL_LOGS, i)
                removed = true
            end
        end
        if removed and _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end
    end
end)

local trackedUIDs = {}

local function logKeyFor(entry)
    if entry.uid and tostring(entry.uid) ~= "" and tostring(entry.uid) ~= "0" then
        return "uid:" .. tostring(entry.uid)
    end
    local sk = entry.slotKey or (findSlotForName(entry.brainrot) and findSlotForName(entry.brainrot).key) or "OTHER"
    return "u:" .. tostring(entry.userId or 0) .. "|" .. sk .. "|" .. norm(entry.brainrot)
end

local function pushLog(entry)
    -- pushLog
    if type(entry) ~= "table" then return end
    entry.ts = entry.ts or os.clock()
    local s = findSlotForName(entry.brainrot)
    entry.slotKey = s and s.key or (entry.slotKey or "OTHER")
    if s and s.display then
        entry.displayName = s.display
    end
    entry.brainrot = entry.brainrot or (s and s.display) or "Unknown"
    entry.username = entry.username or "unknown"
    entry.userId = tonumber(entry.userId) or 0
    entry.mutation = entry.mutation or ""

    local key = logKeyFor(entry)
    local now = os.clock()
    local existingIdx = nil
    for i, e in ipairs(ALL_LOGS) do
        local ek = logKeyFor(e)
        if ek == key then
            existingIdx = i
            break
        end
        -- soft dedup: same player + same slot within window
        if e.userId and entry.userId and e.userId == entry.userId
            and e.slotKey == entry.slotKey and e.slotKey ~= "OTHER"
            and e.ts and (now - e.ts) < DEDUP_WINDOW then
            existingIdx = i
            break
        end
    end

    local isNew = existingIdx == nil
    if existingIdx then
        local old = ALL_LOGS[existingIdx]
        -- prefer richer data
        if (not old.mutation or old.mutation == "") and entry.mutation ~= "" then
            old.mutation = entry.mutation
        elseif entry.mutation ~= "" and entry.mutation ~= old.mutation then
            old.mutation = entry.mutation
        end
        if entry.incomeValue and not old.incomeValue then old.incomeValue = entry.incomeValue end
        if entry.incomeText and (not old.incomeText or old.incomeText == "") then
            old.incomeText = entry.incomeText
        end
        if entry.username and entry.username ~= "" and entry.username ~= "unknown" then
            old.username = entry.username
        end
        if entry.displayName then old.displayName = entry.displayName end
        old.ts = now
        old.hits = (old.hits or 1) + 1
        table.remove(ALL_LOGS, existingIdx)
        table.insert(ALL_LOGS, 1, old)
        entry = old
        isNew = false
    else
        entry.hits = 1
        table.insert(ALL_LOGS, 1, entry)
        if #ALL_LOGS > MAX_LOGS then table.remove(ALL_LOGS) end
        caughtCount = caughtCount + 1
        CaughtLbl.Text = caughtCount .. " caught"
    end

    seenLogKeys[key] = now
    if _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end

    if isNew then
        task.spawn(function()
            local avatarUrl
            pcall(function()
                if entry.userId and entry.userId > 0 then
                    local ok, url = pcall(function()
                        return Players:GetUserThumbnailAsync(entry.userId,
                            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
                    end)
                    if ok then avatarUrl = url end
                end
            end)
            pcall(fireDetectWebhook, entry, avatarUrl)
        end)
    end
end

_G.__HOS_PushLog = pushLog
_G.__HeadlessOGRefresh = function()
    renderLogs(ogScroll, _G.__HOS.activeSlot)
    renderLogs(liveScroll, nil)
end
_G.__HeadlessSniperSetPage = function(name)
    for tabName, page in pairs(pageFrames) do
        page.Visible = (tabName == name)
        page.ZIndex = (tabName == name) and 20 or 5
    end
    if name == "OG" or name == "LIVE" then _G.__HeadlessOGRefresh() end
end

local liveboardOK = false
local newEntryRE, claimEntryRE, getEntriesRF
do
    local function findNetChild(netF, patterns)
        if not netF then return nil end
        for _, child in ipairs(netF:GetChildren()) do
            local n = child.Name or ""
            for _, pat in ipairs(patterns) do
                if n == pat or n:lower():find(pat:lower(), 1, true) then
                    return child
                end
            end
        end
        -- deep search one level of folders
        for _, child in ipairs(netF:GetChildren()) do
            if child:IsA("Folder") then
                for _, sub in ipairs(child:GetChildren()) do
                    local n = sub.Name or ""
                    for _, pat in ipairs(patterns) do
                        if n == pat or n:lower():find(pat:lower(), 1, true) then
                            return sub
                        end
                    end
                end
            end
        end
        return nil
    end
    local ok, pkg = pcall(function() return ReplicatedStorage:WaitForChild("Packages", 12) end)
    local netF = ok and pkg and pkg:FindFirstChild("Net")
    if not netF then
        pcall(function()
            netF = ReplicatedStorage:FindFirstChild("Net")
                or (ReplicatedStorage:FindFirstChild("Shared") and ReplicatedStorage.Shared:FindFirstChild("Net"))
        end)
    end
    if netF then
        newEntryRE   = netF:FindFirstChild("RE/Liveboard/NewEntry")
            or findNetChild(netF, { "RE/Liveboard/NewEntry", "Liveboard/NewEntry", "NewEntry", "LiveboardNewEntry" })
        claimEntryRE = netF:FindFirstChild("RE/Liveboard/ClaimEntry")
            or findNetChild(netF, { "RE/Liveboard/ClaimEntry", "Liveboard/ClaimEntry", "ClaimEntry", "LiveboardClaimEntry" })
        getEntriesRF = netF:FindFirstChild("RF/Liveboard/GetEntries")
            or findNetChild(netF, { "RF/Liveboard/GetEntries", "Liveboard/GetEntries", "GetEntries", "LiveboardGetEntries" })
        liveboardOK  = newEntryRE ~= nil or claimEntryRE ~= nil or getEntriesRF ~= nil
        if liveboardOK then
            print("[HOS] liveboard hooks: new=", tostring(newEntryRE and newEntryRE.Name),
                " claim=", tostring(claimEntryRE and claimEntryRE.Name),
                " get=", tostring(getEntriesRF and getEntriesRF.Name))
        end
    end
    if not liveboardOK then
        print("[HOS] liveboard remotes not found — detection limited until remotes appear")
        task.spawn(function()
            for _ = 1, 30 do
                task.wait(2)
                local pkg2 = ReplicatedStorage:FindFirstChild("Packages")
                local net2 = pkg2 and pkg2:FindFirstChild("Net")
                if net2 then
                    newEntryRE = net2:FindFirstChild("RE/Liveboard/NewEntry") or newEntryRE
                    claimEntryRE = net2:FindFirstChild("RE/Liveboard/ClaimEntry") or claimEntryRE
                    getEntriesRF = net2:FindFirstChild("RF/Liveboard/GetEntries") or getEntriesRF
                    if newEntryRE or claimEntryRE or getEntriesRF then
                        liveboardOK = true
                        print("[HOS] liveboard remotes late-hooked")
                        break
                    end
                end
            end
        end)
    end
end

local TARGET_NAMES = {}
do
    for _, slot in ipairs(SLOTS) do
        for _, n in ipairs(slot.logMatchNames or {}) do
            TARGET_NAMES[n:lower()] = slot.key
            TARGET_NAMES[norm(n)] = slot.key
        end
        for _, n in ipairs(slot.searchKeys or {}) do
            TARGET_NAMES[n:lower()] = slot.key
            TARGET_NAMES[norm(n)] = slot.key
        end
        for _, n in ipairs(slot.matchTokens or {}) do
            TARGET_NAMES[n:lower()] = slot.key
            TARGET_NAMES[norm(n)] = slot.key
        end
        TARGET_NAMES[slot.display:lower()] = slot.key
        TARGET_NAMES[norm(slot.display)] = slot.key
        TARGET_NAMES[norm(slot.key)] = slot.key
    end
end

local function isTargetBrainrot(brainrotName)
    if not brainrotName then return nil end
    local low = tostring(brainrotName):lower()
    local n = norm(brainrotName)
    if TARGET_NAMES[low] then return TARGET_NAMES[low] end
    if TARGET_NAMES[n] then return TARGET_NAMES[n] end
    for token, slotKey in pairs(TARGET_NAMES) do
        if #token >= 4 and (n:find(token, 1, true) or low:find(token, 1, true)
            or token:find(n, 1, true)) then
            return slotKey
        end
    end
    local slot = findSlotForName(brainrotName)
    return slot and slot.key or nil
end

local function pickField(t, names)
    if type(t) ~= "table" then return nil end
    for _, f in ipairs(names) do
        local v = t[f]
        if v ~= nil and v ~= "" and v ~= 0 then return v end
    end
    -- case-insensitive fallback
    local lowerMap = {}
    for k, v in pairs(t) do
        if type(k) == "string" then lowerMap[k:lower()] = v end
    end
    for _, f in ipairs(names) do
        local v = lowerMap[f:lower()]
        if v ~= nil and v ~= "" and v ~= 0 then return v end
    end
    return nil
end

local function readIncome(entryData)
    if type(entryData) ~= "table" then return nil, nil end
    for _, field in ipairs({
        "Income", "IncomeText", "Value", "ValueText",
        "Generation", "GenerationText", "Gen", "PerSecond", "CPS",
        "CashPerSecond", "MoneyPerSecond", "Rate", "Earn", "Earnings",
    }) do
        local v = entryData[field]
        if type(v) == "number" and v > 0 then return v, nil end
        if type(v) == "string" and v ~= "" then return nil, v end
    end
    local nested = entryData.Stats or entryData.Data or entryData.Info
    if type(nested) == "table" then
        return readIncome(nested)
    end
    return nil, nil
end

local function normalizeEntryTable(entryData)
    if type(entryData) ~= "table" then return nil end
    -- sometimes the payload is { entry = {...} } or array-like
    if entryData.BrainrotName or entryData.Name or entryData.UID or entryData.Uid then
        return entryData
    end
    if type(entryData.Entry) == "table" then return entryData.Entry end
    if type(entryData.Data) == "table" and (entryData.Data.BrainrotName or entryData.Data.UID) then
        return entryData.Data
    end
    -- single-element array
    if entryData[1] and type(entryData[1]) == "table" and (entryData[1].BrainrotName or entryData[1].UID) then
        return entryData[1]
    end
    return entryData
end

local function processEntryData(entryData)
    entryData = normalizeEntryTable(entryData)
    if type(entryData) ~= "table" then return end

    local name = pickField(entryData, {
        "BrainrotName", "Name", "AnimalName", "PetName", "DisplayName",
        "Index", "Brainrot", "Animal", "ItemName", "Title",
    })
    local uid = pickField(entryData, {
        "UID", "Uid", "uid", "Id", "ID", "EntryId", "EntryID", "SpawnId",
    })
    local ownerId = pickField(entryData, {
        "OwnerUserId", "OwnerId", "UserId", "PlayerId", "Owner", "ClaimedBy",
    })
    ownerId = tonumber(ownerId)
    local ownerDisplay = pickField(entryData, {
        "OwnerDisplayName", "OwnerName", "Username", "PlayerName", "DisplayName", "OwnerDisplay",
    })
    if type(ownerDisplay) == "string" and ownerDisplay:match("^%d+$") then
        ownerDisplay = nil
    end

    if not name then return end
    name = tostring(name)

    local slotKey = isTargetBrainrot(name)
    local incomeValue, incomeText = readIncome(entryData)

    -- always track unclaimed OGs so claim events can resolve them
    if (not ownerId or ownerId <= 0) then
        if slotKey and uid then
            trackedUIDs[tostring(uid)] = {
                brainrot = name, slotKey = slotKey,
                incomeValue = incomeValue, incomeText = incomeText,
                ts = os.clock(),
            }
        end
        return
    end

    if ownerId == LP.UserId then return end -- skip own claims noise

    local resolvedUsername = getUsernameFromId(ownerId) or (type(ownerDisplay) == "string" and ownerDisplay)
        or ("User" .. tostring(ownerId))
    if isBlacklisted(ownerId, resolvedUsername) then
        if uid then trackedUIDs[tostring(uid)] = nil end
        return
    end
    if uid then trackedUIDs[tostring(uid)] = nil end

    -- push immediately so the feed is fast; mutation fills in when ready
    local pending = {
        brainrot = name, mutation = "",
        username = resolvedUsername, userId = ownerId, uid = uid and tostring(uid) or nil,
        incomeValue = incomeValue, incomeText = incomeText,
        slotKey = slotKey or "OTHER",
    }
    -- try instant mutation first
    local instantMut = readMutation(entryData, name, uid)
    if instantMut and instantMut ~= "" then
        pending.mutation = instantMut
        pushLog(pending)
        return
    end
    pushLog(pending)
    readMutationThen(entryData, name, uid, function(mut)
        if mut and mut ~= "" then
            pushLog({
                brainrot = name, mutation = mut,
                username = resolvedUsername, userId = ownerId, uid = uid and tostring(uid) or nil,
                incomeValue = incomeValue, incomeText = incomeText,
                slotKey = slotKey or "OTHER",
            })
        end
    end)
end

local function processEntriesList(entries)
    if type(entries) ~= "table" then return end
    -- array
    if entries[1] ~= nil then
        for _, entryData in ipairs(entries) do
            pcall(processEntryData, entryData)
        end
        return
    end
    -- dictionary
    for _, entryData in pairs(entries) do
        if type(entryData) == "table" then
            pcall(processEntryData, entryData)
        end
    end
end

local function hookLiveboard()
    if newEntryRE and not newEntryRE:GetAttribute("__HOSHooked") then
        newEntryRE:SetAttribute("__HOSHooked", true)
        newEntryRE.OnClientEvent:Connect(function(...)
            local args = { ... }
            -- handle (entry) or (uid, entry) or multiple
            if #args == 1 then
                pcall(processEntryData, args[1])
            elseif #args >= 2 and type(args[2]) == "table" then
                pcall(processEntryData, args[2])
            else
                for _, a in ipairs(args) do
                    if type(a) == "table" then pcall(processEntryData, a) end
                end
            end
        end)
    end
    if claimEntryRE and not claimEntryRE:GetAttribute("__HOSHooked") then
        claimEntryRE:SetAttribute("__HOSHooked", true)
        claimEntryRE.OnClientEvent:Connect(function(uid, ownerUserId, ownerDisplayName, extra)
            uid = uid or (type(ownerUserId) == "table" and nil)
            -- flexible arg shapes
            if type(uid) == "table" then
                pcall(processEntryData, uid)
                return
            end
            local tracked = uid and trackedUIDs[tostring(uid)]
            local ownerId = tonumber(ownerUserId)
            if type(ownerUserId) == "table" then
                pcall(processEntryData, ownerUserId)
                return
            end
            if not ownerId or ownerId <= 0 then return end
            if ownerId == LP.UserId then return end
            local brainrot = tracked and tracked.brainrot or nil
            local incomeValue = tracked and tracked.incomeValue
            local incomeText = tracked and tracked.incomeText
            -- extra payload sometimes carries the entry
            if type(extra) == "table" then
                pcall(processEntryData, extra)
                if not brainrot then
                    brainrot = pickField(extra, { "BrainrotName", "Name", "AnimalName", "Index" })
                end
            end
            if not brainrot then return end
            local resolvedUsername = getUsernameFromId(ownerId) or ownerDisplayName
                or ("User" .. tostring(ownerId))
            if isBlacklisted(ownerId, resolvedUsername) then
                if uid then trackedUIDs[tostring(uid)] = nil end
                return
            end
            local pending = {
                brainrot = brainrot, mutation = "",
                username = resolvedUsername, userId = ownerId,
                uid = uid and tostring(uid) or nil,
                incomeValue = incomeValue, incomeText = incomeText,
            }
            local instantMut = readMutation(type(extra) == "table" and extra or nil, brainrot, uid)
            if instantMut and instantMut ~= "" then
                pending.mutation = instantMut
                pushLog(pending)
            else
                pushLog(pending)
                readMutationThen(type(extra) == "table" and extra or nil, brainrot, uid, function(mut)
                    if mut and mut ~= "" then
                        pushLog({
                            brainrot = brainrot, mutation = mut,
                            username = resolvedUsername, userId = ownerId,
                            uid = uid and tostring(uid) or nil,
                            incomeValue = incomeValue, incomeText = incomeText,
                        })
                    end
                end)
            end
            if uid then trackedUIDs[tostring(uid)] = nil end
        end)
    end
end

hookLiveboard()

-- initial + periodic rescan so missed events still get picked up
task.spawn(function()
    local function pull()
        if not getEntriesRF then
            local pkg = ReplicatedStorage:FindFirstChild("Packages")
            local netF = pkg and pkg:FindFirstChild("Net")
            if netF then
                getEntriesRF = netF:FindFirstChild("RF/Liveboard/GetEntries") or getEntriesRF
                newEntryRE = netF:FindFirstChild("RE/Liveboard/NewEntry") or newEntryRE
                claimEntryRE = netF:FindFirstChild("RE/Liveboard/ClaimEntry") or claimEntryRE
                hookLiveboard()
            end
        end
        if getEntriesRF then
            local ok, entries = pcall(function() return getEntriesRF:InvokeServer() end)
            if ok then processEntriesList(entries) end
        end
    end
    pull()
    while SG and SG.Parent do
        task.wait(8)
        pull()
        -- prune stale unclaimed tracks
        local now = os.clock()
        for id, info in pairs(trackedUIDs) do
            if info.ts and (now - info.ts) > 120 then
                trackedUIDs[id] = nil
            end
        end
    end
end)


-- persist UI refs for theme/settings
pcall(function()
    local H2 = _G.__HOS2
    if not H2 then return end
    H2.trackTitle = trackTitle
    H2.trackSearchRow = trackSearchRow
    H2.trackSearchBox = trackSearchBox
    H2.trackSearchBtn = trackSearchBtn
    H2.liveboardOK = liveboardOK
end)

end
__hos_build_track_logs()

local function __hos_build_fleece()
local fleecePage = pageFrames["FLEECE"]
local FleeceTitle = label(fleecePage, "FLEECE", 11, C.acc, FBK)
FleeceTitle.Position = UDim2.fromOffset(14, 10)
FleeceTitle.Size = UDim2.new(1, -28, 0, 16); FleeceTitle.ZIndex = 21

-- Global fleece state (always reachable)
_G.__HeadlessFleece = true
_G.__Fleece = {
    invite = true,      -- auto-accept Trade Request Accept
    requireOG = true,   -- only accept invite if player base has OG
    readyOG = true,     -- READY if OG in open trade
    cancelNoOG = true,  -- CANCEL if no OG
    minRank = 5,
    invites = 0,
    accepted = 0,
    declined = 0,
    status = "starting...",
    lastClick = 0,
    lastOG = "",
}

local function F() return _G.__Fleece end

local StatusLbl = label(fleecePage, "status: starting...", 11, C.accHi, FB)
StatusLbl.Position = UDim2.fromOffset(14, 28)
StatusLbl.Size = UDim2.new(1, -28, 0, 16); StatusLbl.ZIndex = 22
StatusLbl.TextTruncate = Enum.TextTruncate.AtEnd

local StatsLbl = label(fleecePage, "invites 0 · ready 0 · cancel 0", 10, C.dim, FM)
StatsLbl.Position = UDim2.fromOffset(14, 46)
StatsLbl.Size = UDim2.new(1, -28, 0, 14); StatsLbl.ZIndex = 22

local function setFleeceStatus(msg)
    F().status = tostring(msg or "")
    if StatusLbl and StatusLbl.Parent then StatusLbl.Text = "status: " .. F().status end
    if StatsLbl and StatsLbl.Parent then
        StatsLbl.Text = string.format("invites %d · ready %d · cancel %d",
            F().invites, F().accepted, F().declined)
    end
end

-- Simple solid mobile buttons (no transparent overlays)
local function makeFleeceSwitch(y, key, title, desc)
    local row = new("Frame", {
        BackgroundColor3 = C.panel2, BackgroundTransparency = 0.05,
        BorderSizePixel = 0, Position = UDim2.fromOffset(14, y),
        Size = UDim2.new(1, -28, 0, 58), ZIndex = 22, Active = true,
    }, fleecePage)
    corner(row, 10); stroke(row, C.lineSoft, 1, 0.35)

    local t = label(row, title, 12, C.txt, FB)
    t.Position = UDim2.fromOffset(12, 8)
    t.Size = UDim2.new(1, -100, 0, 18); t.ZIndex = 23

    local d = label(row, desc, 9, C.sub, FM)
    d.Position = UDim2.fromOffset(12, 30)
    d.Size = UDim2.new(1, -100, 0, 16); d.ZIndex = 23

    local sw = new("TextButton", {
        Name = "Switch",
        BackgroundColor3 = F()[key] and C.acc or C.off,
        BorderSizePixel = 0, AutoButtonColor = true,
        Position = UDim2.new(1, -78, 0.5, -16),
        Size = UDim2.fromOffset(66, 32),
        Text = F()[key] and "ON" or "OFF",
        Font = FBK, TextSize = 14,
        TextColor3 = F()[key] and Color3.fromRGB(26, 13, 5) or C.txt,
        Active = true, Selectable = true, ZIndex = 30,
    }, row)
    corner(sw, 8)

    local function apply()
        local on = F()[key]
        sw.BackgroundColor3 = on and C.acc or C.off
        sw.Text = on and "ON" or "OFF"
        sw.TextColor3 = on and Color3.fromRGB(26, 13, 5) or C.txt
        t.TextColor3 = on and C.accHi or C.txt
        if key == "invite" then _G.__HeadlessFleece = on end
        setFleeceStatus(title .. " = " .. (on and "ON" or "OFF"))
        print("[HOS][Fleece]", key, on)
    end

    local last = 0
    local function toggle()
        if tick() - last < 0.2 then return end
        last = tick()
        F()[key] = not F()[key]
        apply()
    end

    sw.Activated:Connect(toggle)
    sw.MouseButton1Click:Connect(toggle)
    -- whole row tappable on mobile
    local rowBtn = new("TextButton", {
        BackgroundTransparency = 1, Size = UDim2.new(1, -84, 1, 0),
        Text = "", Active = true, ZIndex = 29,
    }, row)
    rowBtn.Activated:Connect(toggle)
    rowBtn.MouseButton1Click:Connect(toggle)

    apply()
    return row
end

makeFleeceSwitch(68, "invite", "AUTO-ACCEPT INVITES", "Accept on Trade Request popup")
makeFleeceSwitch(134, "requireOG", "ONLY IF PLAYER HAS OG", "Scan their base for OG before accept")
makeFleeceSwitch(200, "readyOG", "AUTO-READY IF OG", "Press READY when offer has OG")
makeFleeceSwitch(266, "cancelNoOG", "AUTO-CANCEL IF NO OG", "Press CANCEL when no OG")

-- Rank buttons
local RankCard = new("Frame", {
    BackgroundColor3 = C.panel2, BackgroundTransparency = 0.05,
    BorderSizePixel = 0, Position = UDim2.fromOffset(14, 332),
    Size = UDim2.new(1, -28, 0, 70), ZIndex = 22, Active = true,
}, fleecePage)
corner(RankCard, 10); stroke(RankCard, C.lineSoft, 1, 0.35)
label(RankCard, "MAX OG RANK (1=best, 5=any)", 10, C.sub, FBK).Position = UDim2.fromOffset(12, 6)
local rankRow = new("Frame", {
    BackgroundTransparency = 1, Position = UDim2.fromOffset(10, 32),
    Size = UDim2.new(1, -20, 0, 28), ZIndex = 23,
}, RankCard)
new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Center,
}, rankRow)

local rankBtns = {}
local function paintRanks()
    for r, b in pairs(rankBtns) do
        local sel = r == F().minRank
        b.BackgroundColor3 = sel and C.acc or C.input
        b.TextColor3 = sel and Color3.fromRGB(26, 13, 5) or C.txt
    end
end
for r = 1, 5 do
    local b = new("TextButton", {
        BackgroundColor3 = C.input, BorderSizePixel = 0, AutoButtonColor = true,
        Size = UDim2.fromOffset(50, 28), Text = tostring(r),
        Font = FBK, TextSize = 14, TextColor3 = C.txt,
        Active = true, Selectable = true, ZIndex = 30,
    }, rankRow)
    corner(b, 6)
    rankBtns[r] = b
    local rr = r
    local function setR()
        F().minRank = rr
        paintRanks()
        setFleeceStatus("max rank = " .. rr)
    end
    b.Activated:Connect(setR)
    b.MouseButton1Click:Connect(setR)
end
paintRanks()

-- Test button so user can verify input works
local TestBtn = new("TextButton", {
    BackgroundColor3 = C.acc, BorderSizePixel = 0, AutoButtonColor = true,
    Position = UDim2.fromOffset(14, 412),
    Size = UDim2.new(1, -28, 0, 36),
    Text = "TAP ME — test fleece input",
    Font = FBK, TextSize = 13,
    TextColor3 = Color3.fromRGB(26, 13, 5),
    Active = true, Selectable = true, ZIndex = 30,
}, fleecePage)
corner(TestBtn, 8)
TestBtn.Activated:Connect(function()
    setFleeceStatus("INPUT OK · " .. os.date("%H:%M:%S"))
    print("[HOS][Fleece] test button pressed")
end)
TestBtn.MouseButton1Click:Connect(function()
    setFleeceStatus("INPUT OK · " .. os.date("%H:%M:%S"))
end)

_G.__FleeceUI = { Title = FleeceTitle, StatusLbl = StatusLbl, StatsLbl = StatsLbl }

----------------------------------------------------------------------
-- Click helpers (mobile / Delta)
----------------------------------------------------------------------
local clickCD = {}
local function forceClick(btn)
    if not btn or not btn.Parent then return false end
    if tick() - (clickCD[btn] or 0) < 0.45 then return false end
    clickCD[btn] = tick()
    F().lastClick = tick()

    pcall(function()
        if btn:IsA("GuiButton") then
            btn.Active = true
            btn.Selectable = true
        end
    end)

    -- getconnections first (best on executors)
    local fired = false
    pcall(function()
        local gc = rawget(getfenv(), "getconnections") or getconnections
        if type(gc) ~= "function" then return end
        for _, name in ipairs({ "Activated", "MouseButton1Click", "MouseButton1Down" }) do
            local ok, signal = pcall(function() return btn[name] end)
            if ok and signal then
                local ok2, list = pcall(gc, signal)
                if ok2 and type(list) == "table" then
                    for _, c in ipairs(list) do
                        pcall(function()
                            if type(c.Function) == "function" then c.Function() fired = true end
                        end)
                        pcall(function()
                            if c.Fire then c:Fire() fired = true end
                        end)
                    end
                end
            end
        end
    end)

    pcall(function() btn.Activated:Fire() end)
    pcall(function() btn.MouseButton1Click:Fire() end)
    pcall(function() btn.MouseButton1Down:Fire() end)
    pcall(function() btn.MouseButton1Up:Fire() end)
    pcall(function() firesignal(btn.MouseButton1Click) end)
    pcall(function() firesignal(btn.Activated) end)

    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        local pos, size = btn.AbsolutePosition, btn.AbsoluteSize
        local x = pos.X + size.X * 0.5
        local y = pos.Y + size.Y * 0.5
        vim:SendMouseButtonEvent(x, y, 0, true, game, 1)
        task.wait(0.05)
        vim:SendMouseButtonEvent(x, y, 0, false, game, 1)
    end)

    return true
end

local function textOf(obj)
    local t = ""
    if obj:IsA("TextButton") or obj:IsA("TextLabel") then
        t = (obj.Text or "")
    end
    for _, d in ipairs(obj:GetDescendants()) do
        if d:IsA("TextLabel") or d:IsA("TextButton") then
            local dt = d.Text or ""
            if dt ~= "" then t = t .. " " .. dt end
        end
    end
    return (t .. " " .. (obj.Name or "")):lower()
end

local function isOnScreen(obj)
    if not obj or not obj:IsA("GuiObject") then return false end
    local p = obj
    for _ = 1, 15 do
        if not p then break end
        if p:IsA("GuiObject") and p.Visible == false then return false end
        if p:IsA("ScreenGui") and p.Enabled == false then return false end
        p = p.Parent
    end
    local ok, s = pcall(function() return obj.AbsoluteSize end)
    return ok and s and s.X > 4 and s.Y > 4
end

local function findAcceptButtons()
    local found = {}
    local roots = { PG }
    if CoreGui then roots[#roots + 1] = CoreGui end
    for _, root in ipairs(roots) do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextButton") or d:IsA("ImageButton") then
                if isOnScreen(d) then
                    local hay = textOf(d)
                    local exact = (d:IsA("TextButton") and (d.Text or ""):lower():gsub("^%s+",""):gsub("%s+$","") or "")
                    if exact == "accept" or (hay:find("accept", 1, true) and not hay:find("decline", 1, true)) then
                        found[#found + 1] = d
                    end
                end
            end
        end
    end
    table.sort(found, function(a, b)
        local ea = (a:IsA("TextButton") and (a.Text or ""):lower() == "accept") and 0 or 1
        local eb = (b:IsA("TextButton") and (b.Text or ""):lower() == "accept") and 0 or 1
        return ea < eb
    end)
    return found
end

local function findReadyCancel()
    local ready, cancel = {}, {}
    local roots = { PG }
    if CoreGui then roots[#roots + 1] = CoreGui end
    for _, root in ipairs(roots) do
        for _, d in ipairs(root:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and isOnScreen(d) then
                local exact = (d:IsA("TextButton") and (d.Text or ""):lower():gsub("^%s+",""):gsub("%s+$","") or "")
                local hay = textOf(d)
                if exact == "ready" or (hay:find("ready", 1, true) and not hay:find("already", 1, true) and not hay:find("cancel", 1, true)) then
                    ready[#ready + 1] = d
                elseif exact == "cancel" or exact == "decline" or hay:find("cancel", 1, true) or hay:find("no thanks", 1, true) then
                    cancel[#cancel + 1] = d
                end
            end
        end
    end
    return ready, cancel
end

-- Instant reaction when Accept appears (ChildAdded)
-- Search a player's plot/base for OG brainrots
local function isOGName(name)
    if not name or name == "" then return nil end
    local n = norm(name)
    if n == "" then return nil end
    for _, slot in ipairs(SLOTS) do
        if norm(slot.display) == n or norm(slot.key) == n then
            return slot
        end
        for _, token in ipairs(slot.logMatchNames or {}) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return slot
            end
        end
        for _, token in ipairs(slot.searchKeys or {}) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return slot
            end
        end
        for _, token in ipairs(slot.matchTokens or {}) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return slot
            end
        end
    end
    return nil
end

local function resolvePlayerId(username)
    if not username or username == "" then return nil, nil end
    local low = username:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == low or p.DisplayName:lower() == low then
            return p.UserId, p.Name
        end
    end
    local ok, id = pcall(function() return Players:GetUserIdFromNameAsync(username) end)
    if ok and id then return id, username end
    return nil, username
end

local function searchPlayerForOG(userId, username)
    local found = {}
    local plot = nil
    pcall(function()
        local fplot = findPlayerPlotByUserId or (_G.__HOS and _G.__HOS.findPlayerPlotByUserId)
        if userId and fplot then
            plot = fplot(userId)
        end
    end)
    if not plot then
        -- try match plot sign by username / display
        pcall(function()
            local plots = workspace:FindFirstChild("Plots")
            if not plots then return end
            local targets = {}
            if username then
                targets[#targets + 1] = username:lower()
            end
            for _, p in ipairs(Players:GetPlayers()) do
                if userId and p.UserId == userId then
                    targets[#targets + 1] = p.Name:lower()
                    targets[#targets + 1] = (p.DisplayName or ""):lower()
                end
            end
            for _, pl in ipairs(plots:GetChildren()) do
                local sign = pl:FindFirstChild("PlotSign")
                if sign then
                    for _, d in ipairs(sign:GetDescendants()) do
                        if d:IsA("TextLabel") then
                            local owner = (d.Text or ""):match("^(.-)'s Base$")
                            if owner then
                                local ol = owner:lower()
                                for _, t in ipairs(targets) do
                                    if t ~= "" and ol == t then plot = pl break end
                                end
                            end
                        end
                    end
                end
                if plot then break end
            end
        end)
    end

    local function consider(modelName)
        local slot = isOGName(modelName)
        if slot then
            found[#found + 1] = { slot = slot, name = modelName }
        end
    end

    if plot then
        for _, child in ipairs(plot:GetChildren()) do
            if child:IsA("Model") then consider(child.Name) end
        end
        for _, d in ipairs(plot:GetDescendants()) do
            if d:IsA("Model") then consider(d.Name) end
            pcall(function()
                local idx = d:GetAttribute("Index") or d:GetAttribute("BrainrotName") or d:GetAttribute("Name")
                if type(idx) == "string" then consider(idx) end
            end)
        end
    end

    -- also search known OG names via findBrainrotModels only on THEIR plot
    if findBrainrotModels and plot then
        for _, slot in ipairs(SLOTS) do
            local hits = {}
            pcall(function() hits = findBrainrotModels(slot.display) or {} end)
            for _, h in ipairs(hits) do
                if h.plot == plot then
                    found[#found + 1] = { slot = slot, name = slot.display }
                end
            end
        end
    end

    -- rank best
    local best = nil
    local rankMap = {
        SELEPH = 1, MEOWL = 2, PORK = 3, DRAGONCANNELLONI = 4, SKIBIDI = 5,
    }
    for _, e in ipairs(found) do
        local r = rankMap[e.slot.key] or 99
        if not best or r < best.rank then
            best = { key = e.slot.key, display = e.slot.display, rank = r, name = e.name }
        end
    end
    return best, plot ~= nil
end

local function extractTradeRequestUsername()
    local roots = { PG }
    if CoreGui then roots[#roots + 1] = CoreGui end
    for _, root in ipairs(roots) do
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("TextLabel") or d:IsA("TextButton") then
                local t = d.Text or ""
                -- "@user wants to trade with you"
                local u = t:match("@([%w_]+)%s+wants to trade")
                    or t:match("@([%w_]+)")
                    or t:match("([%w_]+)%s+wants to trade")
                if u and u:lower() ~= (LP.Name or ""):lower()
                    and u:lower() ~= (LP.DisplayName or ""):lower()
                    and u:lower() ~= "trade" and u:lower() ~= "accept" then
                    return u
                end
            end
        end
    end
    return nil
end

local function tryAcceptNow(reason)
    if not F().invite then return end
    local buttons = findAcceptButtons()
    if #buttons == 0 then return end

    local username = extractTradeRequestUsername()
    local userId = nil
    if username then
        userId = select(1, resolvePlayerId(username))
    end

    if F().requireOG then
        if not username and not userId then
            setFleeceStatus("waiting · need name to scan OG")
            return
        end
        local best, hadPlot = searchPlayerForOG(userId, username)
        if best then
            F().lastOG = best.display
            setFleeceStatus(string.format("OG found · %s · accepting", best.display))
        else
            setFleeceStatus(string.format("no OG on %s · skip", username or "?"))
            -- optionally auto-decline
            if F().cancelNoOG then
                for _, root in ipairs({ PG, CoreGui }) do
                    if root then
                    for _, d in ipairs(root:GetDescendants()) do
                        if (d:IsA("TextButton") or d:IsA("ImageButton")) and isOnScreen(d) then
                            local exact = (d:IsA("TextButton") and (d.Text or ""):lower():gsub("^%s+",""):gsub("%s+$","") or "")
                            if exact == "decline" then
                                forceClick(d)
                                F().declined = F().declined + 1
                                setFleeceStatus("DECLINED · no OG · " .. (username or "?"))
                                return
                            end
                        end
                    end
                    end
                end
            end
            return
        end
    end

    local btn = buttons[1]
    if forceClick(btn) then
        F().invites = F().invites + 1
        local extra = F().lastOG ~= "" and (" · " .. F().lastOG) or ""
        setFleeceStatus("ACCEPTED invite" .. extra .. " · " .. (reason or "scan"))
        print("[HOS][Fleece] Accept clicked:", btn:GetFullName(), username, F().lastOG)
    end
end

local function hookGuiForAccept(root)
    if not root or root:GetAttribute("__HOSFleeceHook") then return end
    root:SetAttribute("__HOSFleeceHook", true)
    pcall(function()
        root.DescendantAdded:Connect(function(inst)
            if not F().invite then return end
            task.defer(function()
                task.wait(0.05)
                if inst and inst.Parent and (inst:IsA("TextButton") or inst:IsA("ImageButton")) then
                    local exact = (inst:IsA("TextButton") and (inst.Text or ""):lower():gsub("^%s+",""):gsub("%s+$","") or "")
                    if exact == "accept" then
                        tryAcceptNow("descendant")
                        return
                    end
                end
                -- any new UI might be the trade request frame
                tryAcceptNow("descendant-scan")
            end)
        end)
    end)
end
hookGuiForAccept(PG)
if CoreGui then hookGuiForAccept(CoreGui) end

-- Try TradeController accept APIs if present
local function tryControllerAccept()
    if not tradeController then return false end
    for _, name in ipairs({
        "AcceptInvite", "AcceptTradeInvite", "Accept", "RespondInvite",
        "RespondToInvite", "AcceptRequest", "HandleInvite", "ClaimInvite",
    }) do
        local fn = tradeController[name]
        if type(fn) == "function" then
            local ok = pcall(function() fn(tradeController) end)
            if ok then
                setFleeceStatus("controller " .. name)
                return true
            end
            ok = pcall(function() fn(tradeController, true) end)
            if ok then
                setFleeceStatus("controller " .. name)
                return true
            end
        end
    end
    return false
end

-- Worker
task.spawn(function()
    setFleeceStatus("worker live · invites ON")
    print("[HOS][Fleece] worker live")
    local n = 0
    while true do
        n = n + 1
        pcall(function()
            if F().invite then
                tryAcceptNow("loop")
                if n % 8 == 0 then tryControllerAccept() end
            end
            if F().readyOG or F().cancelNoOG then
                if _G.__HOS_FleeceTryTrade then
                    _G.__HOS_FleeceTryTrade()
                end
            end
        end)
        -- heartbeat status every ~3s so user sees worker is alive
        if n % 25 == 0 then
            setFleeceStatus(string.format("live · inv %s · ready %s · cancel %s",
                F().invite and "ON" or "OFF",
                F().readyOG and "ON" or "OFF",
                F().cancelNoOG and "ON" or "OFF"))
        end
        task.wait(0.1)
    end
end)

-- compatibility aliases used by Stop / exports
local fleeceActive = true
local fleeceAcceptOG = true
local fleeceDeclineNoOG = true
local fleeceMinRank = 5
local fleeceInviteCount = 0
local fleeceAcceptCount = 0
local fleeceDeclineCount = 0
local fleeceActedOnToken = {}
local function fleeceSetStatus(msg) setFleeceStatus(msg) end
local function clickButtonSafely(btn) return forceClick(btn) end
local function getOpenTradeGui()
    for _, name in ipairs({ "TradeLiveTrade", "Trade", "TradeGui", "Trading", "TradeWindow", "LiveTrade" }) do
        local g = PG:FindFirstChild(name)
        if g and g:IsA("ScreenGui") and g.Enabled ~= false then return g end
    end
    return PG
end
local function findTradeReadyCancel(root)
    return findReadyCancel()
end
local function scanTradeInviteAccepts()
    tryAcceptNow("scan")
end


-- expose helpers for overlay scope
_G.__FleeceForceClick = forceClick
_G.__FleeceFindReadyCancel = findReadyCancel
_G.__FleeceSetStatus = setFleeceStatus
_G.__FleeceSearchOG = searchPlayerForOG

end
__hos_build_fleece()

local function __hos_build_settings()
local settingsPage = pageFrames["SETTINGS"]
local settingsTitle = label(settingsPage, "SETTINGS", 11, C.acc, FBK)
settingsTitle.Position = UDim2.fromOffset(14, 10)
settingsTitle.Size = UDim2.new(1, -28, 0, 16); settingsTitle.ZIndex = 21

local function buildDropdown(parent, order, labelText, initialValue, options, onChange)
    local row = new("Frame", {
        BackgroundColor3 = C.card, BackgroundTransparency = 0.1,
        BorderSizePixel = 0, Position = UDim2.fromOffset(14, 34 + (order - 1) * 78),
        Size = UDim2.new(1, -28, 0, 68), ZIndex = 21,
    }, parent)
    corner(row, 10); stroke(row, C.lineSoft, 1, 0.4)
    local titleLbl = label(row, labelText, 10, C.sub, FBK)
    titleLbl.Position = UDim2.fromOffset(12, 6)
    titleLbl.Size = UDim2.new(1, -24, 0, 14); titleLbl.ZIndex = 22
    local currentValue = initialValue
    local btn = new("TextButton", {
        BackgroundColor3 = C.input, BorderSizePixel = 0, AutoButtonColor = false,
        Position = UDim2.fromOffset(12, 26), Size = UDim2.new(1, -24, 0, 32),
        Text = "", Active = true, Selectable = true, ZIndex = 22,
    }, row)
    btn.AutoButtonColor = false
    corner(btn, 8); stroke(btn, C.lineSoft, 1, 0.4)
    local btnLbl = label(btn, currentValue, 12, C.txt, FB, Enum.TextXAlignment.Left)
    btnLbl.Position = UDim2.fromOffset(10, 0)
    btnLbl.Size = UDim2.new(1, -40, 1, 0); btnLbl.ZIndex = 23
    local arrow = label(btn, "▼", 10, C.sub, FB, Enum.TextXAlignment.Right)
    arrow.Position = UDim2.new(1, -24, 0, 0)
    arrow.Size = UDim2.fromOffset(16, 32); arrow.ZIndex = 23
    local popupHolder = new("Frame", {
        BackgroundTransparency = 1, Visible = false,
        Position = UDim2.fromOffset(0, 0), Size = UDim2.new(1, -28, 0, 0), ZIndex = 60,
    }, parent)
    local popup = new("Frame", {
        BackgroundColor3 = C.panel2, BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 34 + (order - 1) * 78 + 58),
        Size = UDim2.new(1, -28, 0, #options * 34 + 8), ZIndex = 61,
    }, popupHolder)
    corner(popup, 8); stroke(popup, C.acc, 1.5, 0.2)
    new("UIListLayout", { Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder }, popup)
    new("UIPadding", { PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4) }, popup)
    local optionButtons = {}
    local function setValue(v, silent)
        currentValue = v
        btnLbl.Text = v
        for optValue, ob in pairs(optionButtons) do
            local sel = optValue == v
            ob.BackgroundColor3 = sel and C.acc or C.panel
            ob.TextColor3 = sel and Color3.fromRGB(26, 13, 5) or C.txt
        end
        if not silent then onChange(v) end
    end
    for i, opt in ipairs(options) do
        local ob = new("TextButton", {
            BackgroundColor3 = C.panel, BorderSizePixel = 0, AutoButtonColor = false,
            Size = UDim2.new(1, 0, 0, 30), Text = opt, Font = FB, TextSize = 11,
            TextColor3 = C.txt, LayoutOrder = i, Active = true, Selectable = true, ZIndex = 62,
        }, popup)
        ob.AutoButtonColor = false
        corner(ob, 6)
        optionButtons[opt] = ob
        bindClick(ob, function() setValue(opt) popupHolder.Visible = false end)
    end
    setValue(initialValue, true)
    bindClick(btn, function() popupHolder.Visible = not popupHolder.Visible end)
    return setValue
end

buildDropdown(settingsPage, 1, "LIVE FEED FILTER", FILTER_MODE,
    { "OG ONLY", "ALL BRAINROTS" },
    function(v)
        FILTER_MODE = v
        setFilter(v)
        if _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end
    end)
buildDropdown(settingsPage, 2, "GUI THEME", currentTheme,
    { "HALLOWEEN", "PURPLE" },
    function(v)
        currentTheme = v
        setThemeInternal(v)
        if _G.__HeadlessApplyTheme then _G.__HeadlessApplyTheme(v) end
    end)

local function applyThemeToAll(name)
    local palette = THEMES[name] or THEMES.HALLOWEEN
    for k, v in pairs(palette) do C[k] = v end
    currentTheme = name
    setThemeInternal(name)
    Main.BackgroundColor3 = C.bg
    MainGrad.Color = ColorSequence.new(C.header, C.bgDeep)
    MainStroke.Color = C.acc
    if BgImage then
        BgImage.Image = C.bgImage
        BgImage.ImageColor3 = C.bgTint
    end
    if BgImage2 then
        BgImage2.Image = C.bgImage
        BgImage2.ImageColor3 = C.bgTint
    end
    if BgAccent then BgAccent.BackgroundColor3 = C.acc end
    Header.BackgroundColor3 = C.header
    Logo.BackgroundColor3 = C.acc
    LogoGrad.Color = ColorSequence.new(C.accHi, C.acc2)
    LogoStroke.Color = C.accHi
    Title.TextColor3 = C.acc
    Sub.TextColor3 = C.sub
    CaughtPill.BackgroundColor3 = C.caughtBg
    CaughtPillStroke.Color = C.acc2
    CaughtLbl.TextColor3 = C.accHi
    MinBtn.BackgroundColor3 = C.panel2
    MinStroke.Color = C.lineSoft
    TabRow.BackgroundColor3 = C.header
    TabRowStroke.Color = C.lineSoft
    local activeTab = (_G.__HOS2 and _G.__HOS2.selectedTab) or selectedTab
    for tabName, btn in pairs(tabButtons) do
        local isActive = tabName == activeTab
        btn.BackgroundColor3 = isActive and C.acc or C.panel2
        btn.BackgroundTransparency = isActive and 0 or 0.4
        btn.TextColor3 = isActive and Color3.fromRGB(26, 13, 5) or C.sub
    end
    for _, page in pairs(pageFrames) do page.BackgroundColor3 = C.panel end
    SlotRow.BackgroundColor3 = C.header
    SlotRowStroke.Color = C.lineSoft
    for _, entry in pairs(slotButtons) do
        local sel = entry.slot.key == _G.__HOS.activeSlot
        entry.btn.BackgroundColor3 = sel and C.acc2 or C.panel
        entry.stroke.Color = sel and C.accHi or C.lineSoft
    end
    ogTitle.TextColor3 = C.acc
    pcall(function()
        local t = _G.__HOS2
        if not t then return end
        if t.trackTitle then t.trackTitle.TextColor3 = C.acc end
        if t.trackSearchRow then t.trackSearchRow.BackgroundColor3 = C.input end
        if t.trackSearchBox then t.trackSearchBox.TextColor3 = C.txt end
        if t.trackSearchBtn then
            t.trackSearchBtn.BackgroundColor3 = C.acc
            t.trackSearchBtn.TextColor3 = Color3.fromRGB(26, 13, 5)
        end
    end)
    pcall(function()
        if FleeceTitle then FleeceTitle.TextColor3 = C.acc end
    end)
    if _G.__FleeceUI then
        for _, card in ipairs(_G.__FleeceUI.Cards or {}) do
            pcall(function() card.BackgroundColor3 = C.panel2 end)
        end
        if _G.__FleeceUI.Title then _G.__FleeceUI.Title.TextColor3 = C.acc end
        if _G.__FleeceUI.StatusLbl then _G.__FleeceUI.StatusLbl.TextColor3 = C.accHi end
    end
    pcall(function()
        if settingsTitle then settingsTitle.TextColor3 = C.acc end
    end)
    if _G.__HeadlessTradeOverlay and _G.__HeadlessTradeOverlay.RefreshTheme then
        _G.__HeadlessTradeOverlay.RefreshTheme()
    end
    if _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end
end
_G.__HeadlessApplyTheme = applyThemeToAll

local minimized = false
bindClick(MinBtn, function()
    minimized = not minimized
    tw(Main, 0.26, { Size = UDim2.fromOffset(WIN_W, minimized and 56 or WIN_H) }, Enum.EasingStyle.Quint)
end)


pcall(function()
    if _G.__HOS2 then _G.__HOS2.settingsTitle = settingsTitle end
end)
end
__hos_build_settings()

local function __hos_build_overlay()
local OG_RANKING = {
    { key = "SELEPH", display = "Strawberry Elephant", rank = 1,
      match = { "strawberry elephant", "strawberryelephant" } },
    { key = "MEOWL", display = "Meowl", rank = 2, match = { "meowl" } },
    { key = "PORK", display = "John Pork", rank = 3, match = { "john pork", "johnpork" } },
    { key = "DRAGONCANNELLONI", display = "Dragon Cannelloni", rank = 4,
      match = { "dragon cannelloni", "dragoncannelloni" } },
    { key = "SKIBIDI", display = "Skibidi Toilet", rank = 5,
      match = { "skibidi toilet", "skibiditoilet", "skibidi" } },
}
local MUT_RANK = {
    ["eclipse"] = 1, ["crystal"] = 2, ["phantom"] = 3, ["divine"] = 4,
    ["rainbow"] = 5, ["galaxy"] = 6, ["cyber"] = 7, ["cursed"] = 8,
    ["radioactive"] = 9, ["yinyang"] = 10, ["lava"] = 11, ["candy"] = 12,
    ["bloodrot"] = 13, ["diamond"] = 14, ["gold"] = 15, ["default"] = 99,
}
local function mutRank(m)
    if not m then return 99 end
    local n = m:lower():gsub("[^%w]", "")
    return MUT_RANK[n] or 50
end
local OG_SLOT_BY_KEY = {}
for _, s in ipairs(SLOTS) do OG_SLOT_BY_KEY[s.key] = s end
local function matchOGRank(brainrotName)
    if not brainrotName then return nil end
    local n = norm(brainrotName)
    if n == "" then return nil end
    for _, entry in ipairs(OG_RANKING) do
        for _, token in ipairs(entry.match) do
            local tn = norm(token)
            if tn ~= "" and (n == tn or n:find(tn, 1, true) or tn:find(n, 1, true)) then
                return entry
            end
        end
    end
    return nil
end

local TradeOverlay = new("Frame", {
    Name = "TradeOverlay", Size = UDim2.fromOffset(384, 76),
    Position = UDim2.new(0, 16, 0, 16),
    BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 0.15,
    BorderSizePixel = 0, Visible = false, ZIndex = 9999990, Active = true,
}, SG)
corner(TradeOverlay, 10)
local TradeOverlayStroke = stroke(TradeOverlay, C.overlayBorder or C.acc, 2, 0)
local iconFrame = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(12, 8, 16), BorderSizePixel = 0,
    Position = UDim2.fromOffset(8, 8), Size = UDim2.fromOffset(60, 60),
    ZIndex = 9999991, ClipsDescendants = true,
}, TradeOverlay)
corner(iconFrame, 10)
local iconStroke = stroke(iconFrame, C.overlayBorder or C.acc, 2, 0.25)
local iconLabel = label(iconFrame, "?", 22, C.overlayBorder or C.acc, FBK, Enum.TextXAlignment.Center)
iconLabel.Size = UDim2.fromScale(1, 1); iconLabel.ZIndex = 9999993
local avatarFrame = new("Frame", {
    BackgroundColor3 = Color3.fromRGB(20, 14, 26), BorderSizePixel = 0,
    Position = UDim2.fromOffset(76, 8), Size = UDim2.fromOffset(60, 60), ZIndex = 9999991,
}, TradeOverlay)
corner(avatarFrame, 30)
stroke(avatarFrame, C.overlayBorder or C.acc, 2, 0.25)
local avatarImg = new("ImageLabel", {
    BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 9999992,
}, avatarFrame)
corner(avatarImg, 30)
local userLbl = label(TradeOverlay, "@username", 14, C.overlayUser or C.accHi, FBK)
userLbl.Position = UDim2.fromOffset(146, 10)
userLbl.Size = UDim2.new(1, -160, 0, 18); userLbl.ZIndex = 9999992
local brainrotLbl = label(TradeOverlay, "—", 12, C.overlaySub or C.sub, FB)
brainrotLbl.Position = UDim2.fromOffset(146, 30)
brainrotLbl.Size = UDim2.new(1, -160, 0, 16); brainrotLbl.ZIndex = 9999992
local mutLbl = label(TradeOverlay, "", 10, C.overlaySub or C.sub, FM)
mutLbl.Position = UDim2.fromOffset(146, 48)
mutLbl.Size = UDim2.new(1, -160, 0, 12); mutLbl.ZIndex = 9999992
local tracedBadge = new("Frame", {
    BackgroundColor3 = C.overlayBadge or C.acc, BorderSizePixel = 0,
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -8, 0, 10),
    Size = UDim2.fromOffset(130, 22), ZIndex = 9999991,
}, TradeOverlay)
corner(tracedBadge, 6)
local tracedLbl = label(tracedBadge, "HEADLESS OG SNIPER", 9,
    C.overlayBadgeText or Color3.fromRGB(0,0,0), FBK, Enum.TextXAlignment.Center)
tracedLbl.Size = UDim2.fromScale(1, 1); tracedLbl.ZIndex = 9999992
local rankLbl = label(TradeOverlay, "", 9, C.overlaySub or C.sub, FB, Enum.TextXAlignment.Right)
rankLbl.AnchorPoint = Vector2.new(1, 0)
rankLbl.Position = UDim2.new(1, -8, 0, 34)
rankLbl.Size = UDim2.fromOffset(160, 12); rankLbl.ZIndex = 9999992

do
    local dragging = false
    local dragStart, startPos
    TradeOverlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = TradeOverlay.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            TradeOverlay.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function readOtherUsernameFromTradeGui()
    local tl = PG:FindFirstChild("TradeLiveTrade")
    if not tl or not tl:IsA("ScreenGui") or tl.Enabled == false then return nil end
    local inner = tl:FindFirstChild("TradeLiveTrade")
    if not inner or not inner:IsA("Frame") or inner.Visible == false then return nil end
    local other = inner:FindFirstChild("Other")
    if not other then return nil end
    local unameLbl = other:FindFirstChild("Username")
    if not unameLbl or not unameLbl:IsA("TextLabel") then return nil end
    local txt = unameLbl.Text or ""
    return txt:match("@([%w_]+)'s Offer") or txt:match("^([%w_]+)'s Offer")
end

local function findOtherPanel()
    local tl = PG:FindFirstChild("TradeLiveTrade")
    if not tl or not tl:IsA("ScreenGui") then return nil end
    local inner = tl:FindFirstChild("TradeLiveTrade")
    if not inner then return nil end
    for _, c in ipairs(inner:GetChildren()) do
        if c:IsA("Frame") and c.Name == "Other" then return c end
    end
    return nil
end

local function readCardMutation(card)
    if not card then return nil end
    local vp = card:FindFirstChild("ViewportFrame", true)
    if vp and vp:IsA("ViewportFrame") then
        local wm = vp:FindFirstChild("WorldModel", true)
            or vp:FindFirstChildWhichIsA("WorldModel", true)
        if wm then
            for _, d in ipairs(wm:GetDescendants()) do
                if d:IsA("Model") then
                    local ok, v = pcall(function() return d:GetAttribute("__mutation") end)
                    if ok and _G.__HOS.isRealMutation(v) then return v end
                end
                local ok, v = pcall(function() return d:GetAttribute("__mutation") end)
                if ok and _G.__HOS.isRealMutation(v) then return v end
            end
        end
    end
    for _, d in ipairs(card:GetDescendants()) do
        local ok, v = pcall(function() return d:GetAttribute("__mutation") end)
        if ok and _G.__HOS.isRealMutation(v) then return v end
    end
    return nil
end

local function readCardBrainrotName(card)
    if not card then return nil end
    for _, d in ipairs(card:GetDescendants()) do
        if d:IsA("TextLabel") and d.Name == "Title" then
            if d.Text and d.Text ~= "" then return d.Text end
        end
    end
    local vp = card:FindFirstChild("ViewportFrame", true)
    if vp then
        local wm = vp:FindFirstChild("WorldModel", true)
        if wm then
            for _, d in ipairs(wm:GetChildren()) do
                if d:IsA("Model") then return d.Name end
            end
        end
    end
    for _, d in ipairs(card:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text ~= "" then return d.Text end
    end
    return nil
end

local function scanTradeOfferForOG()
    local panel = findOtherPanel()
    if not panel then return nil end
    local sf = panel:FindFirstChild("ScrollingFrame", true)
    if not sf then return nil end
    local best = nil
    for _, card in ipairs(sf:GetChildren()) do
        if card:IsA("ImageButton") or card:IsA("Frame") or card:IsA("TextButton") then
            local brainrotName = readCardBrainrotName(card)
            if brainrotName then
                local rank = matchOGRank(brainrotName)
                if rank then
                    local mutRaw = readCardMutation(card)
                    local mut = mutRaw and canonicalizeMutation(mutRaw) or nil
                    local entry = { key = rank.key, display = rank.display,
                        rank = rank.rank, mutation = mut }
                    if not best then
                        best = entry
                    elseif entry.rank < best.rank then
                        best = entry
                    elseif entry.rank == best.rank then
                        if mutRank(entry.mutation) < mutRank(best.mutation) then
                            best = entry
                        end
                    end
                end
            end
        end
    end
    return best
end

local function updateIconForBest(best)
    for _, c in ipairs(iconFrame:GetChildren()) do
        if c:IsA("Frame") and c.Name == "Preview" then c:Destroy() end
    end
    if not best then
        iconLabel.Text = "—"; iconLabel.Visible = true
        iconLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        iconStroke.Color = C.overlayBorder or C.acc
        iconFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 16)
        return
    end
    local mut = best.mutation and canonicalizeMutation(best.mutation) or nil
    local mutColor = getMutationColor(mut)
    local slot = OG_SLOT_BY_KEY[best.key]
    if slot then
        local prev = createBrainrotPreview(iconFrame, slot, 60, 60, 8, {
            zIndex = 9999992, strokeTransparency = 1, mutation = mut,
        })
        prev.Position = UDim2.fromOffset(0, 0)
        iconLabel.Visible = false
    else
        local initials = best.display:gsub("%.", "")
        iconLabel.Text = initials:sub(1, 3); iconLabel.Visible = true
    end
    if mutColor then
        iconStroke.Color = mutColor
        iconFrame.BackgroundColor3 = Color3.fromRGB(
            math.floor(mutColor.R * 40), math.floor(mutColor.G * 40), math.floor(mutColor.B * 40))
        iconLabel.TextColor3 = mutColor
    else
        iconStroke.Color = C.overlayBorder or C.acc
        iconFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 16)
        iconLabel.TextColor3 = C.overlayBorder or C.acc
    end
end

local function refreshOverlayTheme()
    TradeOverlayStroke.Color = C.overlayBorder or C.acc
    tracedBadge.BackgroundColor3 = C.overlayBadge or C.acc
    tracedLbl.TextColor3 = C.overlayBadgeText or Color3.fromRGB(0,0,0)
    userLbl.TextColor3 = C.overlayUser or C.accHi
    brainrotLbl.TextColor3 = C.overlaySub or C.sub
    mutLbl.TextColor3 = C.overlaySub or C.sub
    rankLbl.TextColor3 = C.overlaySub or C.sub
    iconLabel.TextColor3 = C.overlayBorder or C.acc
    local existing = iconFrame:FindFirstChild("Preview")
    if not existing then iconStroke.Color = C.overlayBorder or C.acc end
    for _, c in ipairs(avatarFrame:GetChildren()) do
        if c:IsA("UIStroke") then c.Color = C.overlayBorder or C.acc end
    end
end

local CurrentTradeUser = nil
local CurrentTradeUserId = nil
local CurrentTradeToken = 0
local TradeIsOpen = false

local function resolveUserIdFromName(uname)
    if not uname then return nil end
    local low = uname:lower()
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name:lower() == low or p.DisplayName:lower() == low then
            return p.UserId, p.Name
        end
    end
    return nil
end

local function renderTradeOverlay(username)
    if not username or username == "" then return end
    if username:lower() == LP.Name:lower() or username:lower() == LP.DisplayName:lower() then return end
    CurrentTradeUser = username
    CurrentTradeToken = CurrentTradeToken + 1
    local myToken = CurrentTradeToken
    TradeIsOpen = true
    local resolvedId = resolveUserIdFromName(username)
    CurrentTradeUserId = resolvedId
    userLbl.Text = "@" .. tostring(username)
    task.spawn(function()
        if resolvedId then
            local url = fetchAvatarUrl(resolvedId)
            if url and avatarImg.Parent and myToken == CurrentTradeToken then
                avatarImg.Image = url
            end
        end
    end)
    task.spawn(function()
        for _ = 1, 24 do
            if myToken ~= CurrentTradeToken then return end
            local best = scanTradeOfferForOG()
            if myToken ~= CurrentTradeToken then return end
            if best then
                brainrotLbl.Text = best.display
                brainrotLbl.TextColor3 = Color3.fromRGB(255, 180, 220)
                if best.mutation then
                    mutLbl.Text = best.mutation
                    local mc = getMutationColor(best.mutation)
                    mutLbl.TextColor3 = mc or C.overlaySub or C.sub
                else
                    mutLbl.Text = "base"
                    mutLbl.TextColor3 = C.overlaySub or C.sub
                end
                rankLbl.Text = "BEST OG · RANK " .. tostring(best.rank)
                updateIconForBest(best)
                return
            end
            task.wait(0.25)
        end
        if myToken == CurrentTradeToken then
            brainrotLbl.Text = "no OG detected"
            brainrotLbl.TextColor3 = Color3.fromRGB(160, 160, 160)
            mutLbl.Text = ""; rankLbl.Text = ""
            updateIconForBest(nil)
        end
    end)
    TradeOverlay.Visible = true
end

local function hideTradeOverlay()
    TradeOverlay.Visible = false
    TradeIsOpen = false
    CurrentTradeUser = nil
    CurrentTradeUserId = nil
    CurrentTradeToken = CurrentTradeToken + 1
    avatarImg.Image = ""
    brainrotLbl.Text = "—"; mutLbl.Text = ""; rankLbl.Text = ""
    iconLabel.Text = "?"; iconLabel.Visible = true
    iconStroke.Color = C.overlayBorder or C.acc
    iconFrame.BackgroundColor3 = Color3.fromRGB(12, 8, 16)
    for _, c in ipairs(iconFrame:GetChildren()) do
        if c:IsA("Frame") and c.Name == "Preview" then c:Destroy() end
    end
end

_G.__HeadlessTradeOverlay = {
    Show = renderTradeOverlay, Hide = hideTradeOverlay,
    Ranking = OG_RANKING, MutationRanking = MUT_RANK,
    RefreshTheme = refreshOverlayTheme, Frame = TradeOverlay,
}
_G.__HOS_FleeceTryTrade = function()
    local fx = _G.__Fleece
    if not fx then return end
    if not (fx.readyOG or fx.cancelNoOG) then return end
    if not TradeIsOpen then return end
    local token = CurrentTradeToken or 0
    if token == 0 then return end
    fx._acted = fx._acted or {}
    if fx._acted[token] then return end
    local best = nil
    pcall(function() best = scanTradeOfferForOG() end)
    local findRC = _G.__FleeceFindReadyCancel
    local fClick = _G.__FleeceForceClick
    local setSt = _G.__FleeceSetStatus
    if type(findRC) ~= "function" or type(fClick) ~= "function" then return end
    local ready, cancel = findRC()
    if best and fx.readyOG then
        local rank = tonumber(best.rank) or 99
        if rank <= (fx.minRank or 5) and #ready > 0 then
            if fClick(ready[1]) then
                fx._acted[token] = true
                fx.accepted = (fx.accepted or 0) + 1
                if setSt then setSt("READY · " .. tostring(best.display)) end
            end
            return
        end
    end
    if fx.cancelNoOG then
        local should = (not best) or ((tonumber(best.rank) or 99) > (fx.minRank or 5))
        if should and #cancel > 0 then
            if fClick(cancel[1]) then
                fx._acted[token] = true
                fx.declined = (fx.declined or 0) + 1
                if setSt then setSt(best and "CANCEL · rank filtered" or "CANCEL · no OG") end
            end
        end
    end
end


task.spawn(function()
    while SG and SG.Parent do
        task.wait(0.25)
        local username = nil
        pcall(function() username = readOtherUsernameFromTradeGui() end)
        if username then
            if not TradeIsOpen or CurrentTradeUser ~= username then
                renderTradeOverlay(username)
            end
        else
            if TradeIsOpen then hideTradeOverlay() end
        end
    end
end)

refreshOverlayTheme()

end
__hos_build_overlay()

_G.__HeadlessOGSniper = {
    ScreenGui = SG, Main = Main, Pages = pageFrames, Tabs = tabButtons, Slots = slotButtons,
    CaughtLabel = CaughtLbl, PushLog = _G.__HOS_PushLog or pushLog,
    Blacklist = _G.__HOS_BLACKLIST or BLACKLIST, Tracked = _G.__HOS_TRACKED or TRACKED, LiveboardOK = (_G.__HOS2 and _G.__HOS2.liveboardOK) or liveboardOK,
    GetMutationColor = getMutationColor,
    CanonicalizeMutation = canonicalizeMutation,
    KnownMutations = KNOWN_MUTATIONS,
    SendTrade = sendTradeInvite,
    SendDuel = sendDuelInvite,
    SetAutoTarget = setAutoTarget,
    GetAutoTarget = getAutoTarget,
    FireWebhook = fireWebhook,
    FireDetectWebhook = fireDetectWebhook,
    SetCaught = function(n) caughtCount = n or 0 CaughtLbl.Text = caughtCount .. " caught" end,
    IsFleeceOn = function() return _G.__Fleece and _G.__Fleece.invite end,
    GetFilter = getFilter,
    SetFilter = setFilter,
    GetTheme = getTheme,
    SetTheme = function(v) _G.__HeadlessApplyTheme(v) end,
    GetTarget = function()
        local k = _G.__HOS.activeSlot
        return k, k and slotButtons[k] and slotButtons[k].slot or nil
    end,
    ClearLogs = function() local L = _G.__HOS_ALL_LOGS; if L then for i=#L,1,-1 do L[i]=nil end end; if _G.__HeadlessOGRefresh then _G.__HeadlessOGRefresh() end end,
    TradeOverlay = _G.__HeadlessTradeOverlay,
    Stop = function()
        _G.__HeadlessFleece = false
        if _G.__Fleece then
            _G.__Fleece.invite = false
            _G.__Fleece.readyOG = false
            _G.__Fleece.cancelNoOG = false
        end
        fleeceActive = false
        _G.__HOS = nil; _G.__HOS2 = nil
        if SG then pcall(function() SG:Destroy() end) end
    end,
}

pcall(function() applyThemeToAll(currentTheme) end)
for _, entry in pairs(slotButtons) do
    local sel = entry.slot.key == _G.__HOS.activeSlot
    entry.btn.BackgroundColor3 = sel and C.acc2 or C.panel
    entry.stroke.Color = sel and C.accHi or C.lineSoft
end

print("[HEADLESS OG SNIPER] v48 loaded (register-safe) — register fix — " .. #KNOWN_MUTATIONS
    .. " mutations — delta UI + fleece READY/CANCEL")
pcall(function()
    if SG and not SG.Parent then SG.Parent = PG end
    if SG then SG.Enabled = true end
    if Main then Main.Visible = true end
end)
print("[HOS] chunk3 complete — UI should be visible")

end -- end chunk 3