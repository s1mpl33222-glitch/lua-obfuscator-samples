-- ═══════════════════════════════════════════
--  ✦ ZENITH PREMIUM | Ride a Pet | v14 ✦
-- ═══════════════════════════════════════════
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local RS = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

-- ═══════════════════════════════════════════
--  LOADING SCREEN
-- ═══════════════════════════════════════════
local loadingGui = Instance.new("ScreenGui")
loadingGui.Name = "ZenithLoading"
loadingGui.ResetOnSpawn = false
loadingGui.IgnoreGuiInset = true
loadingGui.DisplayOrder = 999
loadingGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

local bg = Instance.new("Frame", loadingGui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.15
bg.BorderSizePixel = 0

local bgGrad = Instance.new("UIGradient", bg)
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(10, 0, 25)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20, 5, 45)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 0, 25)),
})
bgGrad.Rotation = 45

local card = Instance.new("Frame", bg)
card.Size = UDim2.new(0, 320, 0, 200)
card.Position = UDim2.new(0.5, -160, 0.5, -100)
card.BackgroundColor3 = Color3.fromRGB(15, 10, 30)
card.BackgroundTransparency = 0.15
card.BorderSizePixel = 0
Instance.new("UICorner", card).CornerRadius = UDim.new(0, 16)

local cardStroke = Instance.new("UIStroke", card)
cardStroke.Color = Color3.fromRGB(140, 80, 255)
cardStroke.Thickness = 2
cardStroke.Transparency = 0.2

task.spawn(function()
    while card.Parent do
        TweenService:Create(cardStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0.6}):Play()
        task.wait(1)
        TweenService:Create(cardStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Transparency = 0.2}):Play()
        task.wait(1)
    end
end)

local logo = Instance.new("TextLabel", card)
logo.Size = UDim2.new(1, 0, 0, 60)
logo.Position = UDim2.new(0, 0, 0, 25)
logo.BackgroundTransparency = 1
logo.Text = "✦ ZENITH PREMIUM ✦"
logo.TextColor3 = Color3.fromRGB(180, 120, 255)
logo.Font = Enum.Font.GothamBlack
logo.TextSize = 26
logo.TextStrokeTransparency = 0.5
logo.TextStrokeColor3 = Color3.fromRGB(60, 20, 120)

local sub = Instance.new("TextLabel", card)
sub.Size = UDim2.new(1, 0, 0, 20)
sub.Position = UDim2.new(0, 0, 0, 82)
sub.BackgroundTransparency = 1
sub.Text = "Loading your experience..."
sub.TextColor3 = Color3.fromRGB(180, 180, 220)
sub.Font = Enum.Font.Gotham
sub.TextSize = 12

local track = Instance.new("Frame", card)
track.Size = UDim2.new(1, -60, 0, 10)
track.Position = UDim2.new(0, 30, 0, 125)
track.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
track.BorderSizePixel = 0
Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

local fill = Instance.new("Frame", track)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(140, 80, 255)
fill.BorderSizePixel = 0
Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

local fillGrad = Instance.new("UIGradient", fill)
fillGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 40, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 200)),
})

local pct = Instance.new("TextLabel", card)
pct.Size = UDim2.new(1, 0, 0, 20)
pct.Position = UDim2.new(0, 0, 0, 145)
pct.BackgroundTransparency = 1
pct.Text = "0%"
pct.TextColor3 = Color3.fromRGB(220, 200, 255)
pct.Font = Enum.Font.GothamBold
pct.TextSize = 13

task.spawn(function()
    while fill.Parent do
        fillGrad.Offset = Vector2.new(-1, 0)
        TweenService:Create(fillGrad, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {Offset = Vector2.new(1, 0)}):Play()
        task.wait(1.4)
    end
end)

local messages = {
    "Initializing core...",
    "Connecting to server...",
    "Loading modules...",
    "Scanning eggs...",
    "Building ESP cache...",
    "Optimizing performance...",
    "Almost ready...",
    "Welcome to Zenith Premium!"
}

local statusLine = Instance.new("TextLabel", card)
statusLine.Size = UDim2.new(1, 0, 0, 16)
statusLine.Position = UDim2.new(0, 0, 0, 168)
statusLine.BackgroundTransparency = 1
statusLine.Text = messages[1]
statusLine.TextColor3 = Color3.fromRGB(140, 120, 180)
statusLine.Font = Enum.Font.Code
statusLine.TextSize = 11

card.Position = UDim2.new(0.5, -160, 0.5, -80)
card.BackgroundTransparency = 1
TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -160, 0.5, -100),
    BackgroundTransparency = 0.15
}):Play()
task.wait(0.4)

local duration = 2.6
local steps = 100
for i = 0, steps do
    local p = i / steps
    fill.Size = UDim2.new(p, 0, 1, 0)
    pct.Text = math.floor(p * 100) .. "%"
    local idx = math.clamp(math.floor(p * #messages) + 1, 1, #messages)
    statusLine.Text = messages[idx]
    task.wait(duration / steps)
end

task.wait(0.3)
local outTween = TweenService:Create(card, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
    Position = UDim2.new(0.5, -160, 0.5, -80),
    BackgroundTransparency = 1
})
outTween:Play()
TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
outTween.Completed:Wait()
loadingGui:Destroy()

-- ═══════════════════════════════════════════
--  MAIN SCRIPT
-- ═══════════════════════════════════════════
for _,v in ipairs(((gethui and gethui()) or game:GetService("CoreGui")):GetDescendants()) do
    if v.Name == "ZenithPremium" then v:Destroy() end
end

local parent = (gethui and gethui()) or game:GetService("CoreGui")
local gui = Instance.new("ScreenGui")
gui.Name = "ZenithPremium"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = parent

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 0)
main.Position = UDim2.new(0, 20, 0.1, 0)
main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(120, 60, 220)
stroke.Thickness = 1.5
stroke.Transparency = 0.3

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 42)
header.BackgroundColor3 = Color3.fromRGB(20, 10, 40)
header.BorderSizePixel = 0
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -10, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ ZENITH PREMIUM ✦"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

local pulseDot = Instance.new("Frame", header)
pulseDot.Size = UDim2.new(0, 8, 0, 8)
pulseDot.Position = UDim2.new(1, -20, 0.5, -4)
pulseDot.BackgroundColor3 = Color3.fromRGB(120, 255, 120)
pulseDot.BorderSizePixel = 0
Instance.new("UICorner", pulseDot).CornerRadius = UDim.new(1, 0)

task.spawn(function()
    while pulseDot.Parent do
        TweenService:Create(pulseDot, TweenInfo.new(0.8), {BackgroundTransparency = 0.6}):Play()
        task.wait(0.8)
        TweenService:Create(pulseDot, TweenInfo.new(0.8), {BackgroundTransparency = 0}):Play()
        task.wait(0.8)
    end
end)

local status = Instance.new("TextLabel", main)
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 0, 50)
status.BackgroundColor3 = Color3.fromRGB(18,18,26)
status.Text = "● Initializing..."
status.TextColor3 = Color3.fromRGB(170,170,190)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", status).CornerRadius = UDim.new(0, 6)
local sp = Instance.new("UIPadding", status); sp.PaddingLeft = UDim.new(0, 8)

local eggList = Instance.new("TextLabel", main)
eggList.Size = UDim2.new(1, -20, 0, 56)
eggList.Position = UDim2.new(0, 10, 0, 76)
eggList.BackgroundColor3 = Color3.fromRGB(15,15,22)
eggList.Text = "● Scanning..."
eggList.TextColor3 = Color3.fromRGB(140,220,255)
eggList.Font = Enum.Font.Code
eggList.TextSize = 10
eggList.TextXAlignment = Enum.TextXAlignment.Left
eggList.TextYAlignment = Enum.TextYAlignment.Top
eggList.TextWrapped = true
Instance.new("UICorner", eggList).CornerRadius = UDim.new(0, 6)
local ep2 = Instance.new("UIPadding", eggList); ep2.PaddingLeft = UDim.new(0, 6); ep2.PaddingTop = UDim.new(0, 4)

local function makeBtn(text, y, bg, sc)
    local b = Instance.new("TextButton", main)
    b.Size = UDim2.new(1, -20, 0, 42)
    b.Position = UDim2.new(0, 10, 0, y)
    b.BackgroundColor3 = bg
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 13
    b.AutoButtonColor = false
    b.Active = true
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local s = Instance.new("UIStroke", b)
    s.Color = sc; s.Thickness = 1.5; s.Transparency = 0.2
    b.MouseEnter:Connect(function() TweenService:Create(s, TweenInfo.new(0.2), {Thickness = 2.5, Transparency = 0}):Play() end)
    b.MouseLeave:Connect(function() TweenService:Create(s, TweenInfo.new(0.2), {Thickness = 1.5, Transparency = 0.2}):Play() end)
    return b, s
end

local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ZenithESP"
local espEggFolder = Instance.new("Folder", espFolder); espEggFolder.Name = "Eggs"
local espEggOn = true

local btn, btnStroke            = makeBtn("⚡ STEAL 1B+", 140, Color3.fromRGB(45,20,90), Color3.fromRGB(140,70,255))
local hatchBtn, hatchStroke     = makeBtn("🥚 AUTO HATCH", 186, Color3.fromRGB(20,60,80), Color3.fromRGB(60,200,220))
local buyBtn, buyStroke         = makeBtn("💰 AUTO BUY HATCH LUCK", 232, Color3.fromRGB(80,60,10), Color3.fromRGB(255,200,60))
local espEggBtn, espEggStroke   = makeBtn("👁 EGG ESP: ON", 278, Color3.fromRGB(20,120,40), Color3.fromRGB(80,255,120))

-- ============ AUTO-DETECT PLOT ============
local ranchPos = nil

local function matchesMe(v)
    local un = lp.Name; local uid = tostring(lp.UserId)
    if v.Name:find(un, 1, true) then return true end
    if v.Name == uid then return true end
    for _, val in pairs(v:GetAttributes()) do
        local s = tostring(val)
        if s == un or s == uid then return true end
    end
    for _,d in ipairs(v:GetDescendants()) do
        if d:IsA("StringValue") and (d.Value == un or d.Value == uid) then return true end
        if d:IsA("IntValue") and tostring(d.Value) == uid then return true end
        if d:IsA("ObjectValue") and d.Value == lp then return true end
    end
    return false
end

local function autoLockRanch()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    for _,plot in ipairs(plots:GetChildren()) do
        if matchesMe(plot) then
            local bp = plot:FindFirstChild("Baseplate") or plot:FindFirstChildWhichIsA("BasePart", true)
            if bp then
                ranchPos = bp.CFrame + Vector3.new(0, bp.Size.Y/2 + 4, 0)
                return true
            end
        end
    end
    return false
end

task.spawn(function()
    if not lp.Character then lp.CharacterAdded:Wait() end
    for i = 1, 60 do
        if autoLockRanch() then status.Text = "● Plot found ✓"; break end
        task.wait(0.5)
    end
end)

-- ============ VALUE PARSER ============
local MIN_VALUE = 1_000_000_000

local function parseValue(t)
    if not t then return 0 end
    t = tostring(t):upper():gsub("%s",""):gsub(",","")
    local num, suf = t:match("([%d%.]+)([KMBT]?)")
    if not num then return 0 end
    local n = tonumber(num) or 0
    if suf == "K" then return n*1e3 end
    if suf == "M" then return n*1e6 end
    if suf == "B" then return n*1e9 end
    if suf == "T" then return n*1e12 end
    return n
end

-- ============ READ LUCK ============
local function readEggLuck(egg)
    if not egg or not egg.Parent then return "?" end
    local el = egg:FindFirstChild("EggLuck", true)
    if el then
        local l = el:FindFirstChild("Luck")
        if l and l:IsA("TextLabel") and l.Text ~= "" then return l.Text end
        for _,c in ipairs(el:GetDescendants()) do
            if c:IsA("TextLabel") and c.Text and c.Text ~= "" then return c.Text end
        end
    end
    local ok, v = pcall(function() return egg:GetAttribute("Luck") end)
    if ok and v then return tostring(v) end
    return "?"
end

-- ============ RARITY (cached) ============
local RS_RARITY = {}
local RS_SCANNED = false

local function buildRSCache()
    RS_RARITY = {}
    local folders = {"EggConfig","Eggs","GameData","EggData","Config","EggInfo"}
    for _,fn in ipairs(folders) do
        local f = RS:FindFirstChild(fn, true)
        if f then
            for _,eggT in ipairs(f:GetChildren()) do
                local rar = nil
                for _,a in ipairs({"Rarity","Tier","RarityName","TierName"}) do
                    local ok, v = pcall(function() return eggT:GetAttribute(a) end)
                    if ok and v then rar = tostring(v); break end
                end
                if not rar then
                    for _,c in ipairs(eggT:GetChildren()) do
                        local n = c.Name:lower()
                        if (c:IsA("StringValue") and (n:find("rar") or n:find("tier"))) then
                            rar = c.Value; break
                        end
                    end
                end
                if rar then RS_RARITY[eggT.Name] = rar end
            end
            break
        end
    end
    RS_SCANNED = true
end

local TIER_LIST = {"titanic","huge","secret","mythic","divine","godly","god","legendary","epic","rare","uncommon","common"}

local function titleCase(s)
    s = tostring(s)
    return s:sub(1,1):upper()..s:sub(2):lower()
end

local rarityCache = {}

local function readEggRarity(egg)
    if not egg or not egg.Parent then return "?" end
    local cached = rarityCache[egg]
    if cached then return cached end
    if not RS_SCANNED then buildRSCache() end

    local result = nil

    for _,a in ipairs({"Rarity","Tier","EggRarity","RarityName","RarityLevel","TierName"}) do
        local ok, v = pcall(function() return egg:GetAttribute(a) end)
        if ok and v then result = titleCase(tostring(v)); break end
    end

    if not result then
        for _,d in ipairs(egg:GetChildren()) do
            if d:IsA("StringValue") then
                local n = d.Name:lower()
                if n:find("rar") or n:find("tier") then result = titleCase(d.Value); break end
            end
        end
    end

    if not result then
        local r = RS_RARITY[egg.Name]
        if r then result = titleCase(r) end
    end

    if not result then
        local n = (egg.Name or ""):lower()
        for _,t in ipairs(TIER_LIST) do
            if n:find(t) then result = titleCase(t); break end
        end
    end

    if not result then
        local luck = parseValue(readEggLuck(egg))
        if luck >= 1e12 then result = "Titanic"
        elseif luck >= 1e9 then result = "Huge"
        elseif luck >= 1e6 then result = "Mythic"
        elseif luck >= 1e3 then result = "Legendary"
        elseif luck >= 100 then result = "Epic"
        elseif luck >= 10 then result = "Rare"
        elseif luck >= 1 then result = "Uncommon"
        else result = "Common" end
    end

    rarityCache[egg] = result
    return result
end

local function rarityColor(r)
    r = (tostring(r) or ""):lower()
    if r:find("titanic") then return Color3.fromRGB(255,60,60) end
    if r:find("huge") then return Color3.fromRGB(255,150,60) end
    if r:find("mythic") or r:find("secret") then return Color3.fromRGB(200,80,255) end
    if r:find("divine") or r:find("god") then return Color3.fromRGB(255,220,80) end
    if r:find("legend") then return Color3.fromRGB(255,180,60) end
    if r:find("epic") then return Color3.fromRGB(160,80,255) end
    if r:find("rare") then return Color3.fromRGB(80,150,255) end
    if r:find("uncommon") then return Color3.fromRGB(120,255,120) end
    return Color3.fromRGB(200,200,220)
end

local function fmt(n)
    if n >= 1e12 then return string.format("%.2fT", n/1e12) end
    if n >= 1e9  then return string.format("%.2fB", n/1e9) end
    if n >= 1e6  then return string.format("%.2fM", n/1e6) end
    if n >= 1e3  then return string.format("%.2fK", n/1e3) end
    return tostring(n)
end

local function getPos(o)
    if o:IsA("BasePart") then return o.Position end
    if o:IsA("Model") and o.PrimaryPart then return o.PrimaryPart.Position end
    local p = o:FindFirstChildWhichIsA("BasePart", true)
    return p and p.Position
end

-- ============ FAST EGG DETECTOR ============
local EGG_KEYWORDS = {"egg","eggs","eggbase","eggshell"}

local function nameHasEgg(n)
    n = (n or ""):lower()
    for _,k in ipairs(EGG_KEYWORDS) do
        if n:find(k) then return true end
    end
    return false
end

local function isPlayerOrNPC(obj)
    for _,pl in ipairs(Players:GetPlayers()) do
        if pl.Character == obj then return true end
    end
    if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then return true end
    return false
end

local function isOnPlot(obj)
    local par = obj.Parent
    local depth = 0
    while par and par ~= workspace and depth < 5 do
        local n = par.Name:lower()
        if n == "plots" or n:find("plot") or n:find("ranch") then return true end
        par = par.Parent
        depth = depth + 1
    end
    return false
end

local function collectEggs()
    local out, seen = {}, {}
    local function add(o)
        if o and not seen[o] then seen[o]=true; table.insert(out, o) end
    end

    local re = workspace:FindFirstChild("RenderedEggs")
    if re then
        for _,v in ipairs(re:GetChildren()) do
            if not isOnPlot(v) then add(v) end
        end
    end

    local ef = workspace:FindFirstChild("Eggs")
    if ef then
        for _,v in ipairs(ef:GetChildren()) do
            if not isOnPlot(v) then add(v) end
        end
    end

    for _,cont in ipairs(workspace:GetChildren()) do
        if cont:IsA("Folder") or cont:IsA("Model") then
            local n = cont.Name:lower()
            if n:find("egg") or n:find("spawn") or n:find("map") then
                for _,v in ipairs(cont:GetChildren()) do
                    if not isOnPlot(v) and not isPlayerOrNPC(v) then add(v) end
                end
            end
        end
    end

    for _,v in ipairs(workspace:GetChildren()) do
        if not seen[v] and (v:IsA("BasePart") or v:IsA("Model")) then
            if nameHasEgg(v.Name) and not isOnPlot(v) and not isPlayerOrNPC(v) then
                add(v)
            end
        end
    end

    return out
end

-- ============ LOW-LAG ESP CACHE ============
local espCache = {}

local function buildESP(part, color)
    local hl = Instance.new("Highlight")
    hl.Adornee = part
    hl.FillColor = color
    hl.FillTransparency = 0.75
    hl.OutlineTransparency = 0.4
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = espEggFolder

    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0, 140, 0, 50)
    bb.StudsOffset = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 100000
    bb.Parent = espEggFolder

    local nameL = Instance.new("TextLabel", bb)
    nameL.Size = UDim2.new(1, 0, 0.34, 0)
    nameL.BackgroundTransparency = 1
    nameL.TextColor3 = Color3.new(1,1,1)
    nameL.TextStrokeTransparency = 0.4
    nameL.TextStrokeColor3 = Color3.new(0,0,0)
    nameL.Font = Enum.Font.GothamBold
    nameL.TextSize = 12

    local valL = Instance.new("TextLabel", bb)
    valL.Size = UDim2.new(1, 0, 0.33, 0)
    valL.Position = UDim2.new(0, 0, 0.33, 0)
    valL.BackgroundTransparency = 1
    valL.TextColor3 = Color3.fromRGB(140,255,140)
    valL.TextStrokeTransparency = 0.4
    valL.Font = Enum.Font.Code
    valL.TextSize = 11

    local rarL = Instance.new("TextLabel", bb)
    rarL.Size = UDim2.new(1, 0, 0.33, 0)
    rarL.Position = UDim2.new(0, 0, 0.66, 0)
    rarL.BackgroundTransparency = 1
    rarL.TextColor3 = color
    rarL.TextStrokeTransparency = 0.4
    rarL.Font = Enum.Font.GothamBold
    rarL.TextSize = 11

    return {hl=hl, bb=bb, nameL=nameL, valL=valL, rarL=rarL, lastText=nil, lastRar=nil, lastColor=nil}
end

local function clearAllESP()
    for part, data in pairs(espCache) do
        if data.hl then data.hl:Destroy() end
        if data.bb then data.bb:Destroy() end
    end
    espCache = {}
end

-- ============ ESP LOOP ============
task.spawn(function()
    while gui.Parent do
        if espEggOn then
            local liveParts = {}
            local eggs = collectEggs()

            for _,egg in ipairs(eggs) do
                local part = egg:IsA("BasePart") and egg or egg:FindFirstChildWhichIsA("BasePart", true)
                if part and part.Parent then
                    liveParts[part] = true
                    local luckText = readEggLuck(egg)
                    local rarityText = readEggRarity(egg)
                    local color = rarityColor(rarityText)
                    local luckStr = "🍀 "..luckText
                    local rarStr = "⭐ "..rarityText

                    local c = espCache[part]
                    if not c then
                        c = buildESP(part, color)
                        c.nameL.Text = "🥚 "..egg.Name
                        c.valL.Text = luckStr
                        c.rarL.Text = rarStr
                        c.rarL.TextColor3 = color
                        c.lastText = luckStr
                        c.lastRar = rarityText
                        c.lastColor = color
                        espCache[part] = c
                    else
                        if c.lastText ~= luckStr then
                            c.valL.Text = luckStr
                            c.lastText = luckStr
                        end
                        if c.lastRar ~= rarityText then
                            c.rarL.Text = rarStr
                            c.rarL.TextColor3 = color
                            c.lastRar = rarityText
                        end
                        if c.lastColor ~= color then
                            c.hl.FillColor = color
                            c.lastColor = color
                        end
                    end
                end
            end

            for part, data in pairs(espCache) do
                if not liveParts[part] or not part.Parent then
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    espCache[part] = nil
                end
            end

            for e,_ in pairs(rarityCache) do
                if not e.Parent then rarityCache[e] = nil end
            end
        else
            if next(espCache) then clearAllESP() end
        end

        task.wait(2)
    end
end)

-- ============ SUPER SMOOTH STEAL ============
local function superPickup(egg, prompt)
    local char = lp.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local pos = getPos(egg)
    if not pos then return false end

    local toEgg = TweenService:Create(hrp,
        TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
        {CFrame = CFrame.new(pos + Vector3.new(0, 1.5, 0))})
    toEgg:Play()
    toEgg.Completed:Wait()

    if not egg.Parent or not prompt.Parent then return false end

    local prompts = {prompt}
    for _,d in ipairs(egg:GetDescendants()) do
        if d:IsA("ProximityPrompt") and d ~= prompt then table.insert(prompts, d) end
    end
    for pass = 1, 8 do
        for _,p in ipairs(prompts) do
            if p and p.Parent then
                p.HoldDuration = 0
                p.MaxActivationDistance = math.huge
                p.Enabled = true
                pcall(fireproximityprompt, p)
            end
        end
        task.wait(0.012)
    end

    if egg:IsA("BasePart") then
        pcall(firetouchinterest, hrp, egg, 0)
        pcall(firetouchinterest, hrp, egg, 1)
    elseif egg:IsA("Model") then
        for _,part in ipairs(egg:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(firetouchinterest, hrp, part, 0)
                pcall(firetouchinterest, hrp, part, 1)
            end
        end
    end

    if ranchPos then
        local back = TweenService:Create(hrp,
            TweenInfo.new(0.05, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {CFrame = ranchPos})
        back:Play()
        back.Completed:Wait()
    end
    return true
end

-- ============ AUTO HATCH ============
local hatchActive = false
local function fireHatchPrompts()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    for _,p in ipairs(plots:GetChildren()) do
        for _,d in ipairs(p:GetDescendants()) do
            if d:IsA("ProximityPrompt") then
                local a = (d.ActionText or ""):lower()
                local o = (d.ObjectText or ""):lower()
                local pn = (d.Parent and d.Parent.Name or ""):lower()
                if a:find("hatch") or a:find("open") or o:find("hatch")
                or o:find("egg") or pn:find("hatch") or pn:find("egg") then
                    d.HoldDuration = 0
                    d.MaxActivationDistance = math.huge
                    pcall(fireproximityprompt, d)
                end
            end
        end
    end
end
local function hatchLoop()
    while hatchActive and gui.Parent do
        fireHatchPrompts()
        task.wait(0.4)
    end
end

-- ============ AUTO BUY HATCH LUCK ============
local buyActive = false
local function buyOnce()
    local G = RS.Remotes and RS.Remotes:FindFirstChild("Game")
    if not G then return end
    local P = G:FindFirstChild("Plot")
    if not P then return end
    local up = P:FindFirstChild("Upgrades")
    if up then pcall(function() up:FireServer() end) end
end
local function buyLoop()
    while buyActive and gui.Parent do
        buyOnce()
        status.Text = "● 💰 Buying Hatch Luck..."
        task.wait(0.15)
    end
end

-- ============ LIVE EGG LIST ============
local function getCurrentEggs()
    local list = {}
    for _,v in ipairs(collectEggs()) do
        local p = v:FindFirstChildWhichIsA("ProximityPrompt", true)
        if p and p.Enabled and p.Parent then
            local luckText = readEggLuck(v)
            local rarityText = readEggRarity(v)
            table.insert(list, {
                egg=v, prompt=p, name=v.Name,
                luckText=luckText,
                rarity=rarityText,
                num=parseValue(luckText)
            })
        end
    end
    table.sort(list, function(a,b) return a.num > b.num end)
    return list
end

task.spawn(function()
    while gui.Parent do
        local list = getCurrentEggs()
        if #list == 0 then eggList.Text = "○ no eggs spawning"
        else
            local txt = ""
            for i = 1, math.min(3, #list) do
                local e = list[i]
                local mark = e.num >= MIN_VALUE and "★" or "·"
                txt = txt .. mark .. " " .. e.name .. " — 🍀 " .. e.luckText .. " — ⭐ " .. e.rarity .. "\n"
            end
            eggList.Text = txt
        end
        task.wait(2)
    end
end)

-- ============ STEAL CYCLE ============
local active, busy = false, false
local function runCycle()
    if not active or busy or not ranchPos then return end
    busy = true
    local list = getCurrentEggs()
    local best = nil
    for _,e in ipairs(list) do if e.num >= MIN_VALUE then best = e break end end
    if best then
        task.wait(0.01)
        local l2 = getCurrentEggs()
        for _,e in ipairs(l2) do
            if e.num >= MIN_VALUE and e.num > best.num then best = e break end
        end
        local ok = superPickup(best.egg, best.prompt)
        status.Text = ok and ("● 🏆 "..best.name.." | 🍀 "..best.luckText.." | ⭐ "..best.rarity) or "● retry"
        task.wait(0.01)
    else
        status.Text = "● Waiting for 1B+ egg..."
        task.wait(0.15)
    end
    busy = false
end

-- ============ BUTTON HANDLERS ============
local loopConn = nil
btn.MouseButton1Click:Connect(function()
    if not ranchPos then status.Text = "● Plot not ready..." return end
    active = not active
    if active then
        btn.Text = "⚡ STEAL 1B+: ON"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,120,40)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80,255,120)}):Play()
        loopConn = RunService.Heartbeat:Connect(function() if active then runCycle() end end)
    else
        btn.Text = "⚡ STEAL 1B+"
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,20,90)}):Play()
        TweenService:Create(btnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(140,70,255)}):Play()
        if loopConn then loopConn:Disconnect() loopConn = nil end
        busy = false
        status.Text = "● Steal off"
    end
end)

hatchBtn.MouseButton1Click:Connect(function()
    hatchActive = not hatchActive
    hatchBtn.Text = hatchActive and "🥚 AUTO HATCH: ON" or "🥚 AUTO HATCH"
    TweenService:Create(hatchBtn, TweenInfo.new(0.2), {BackgroundColor3 = hatchActive and Color3.fromRGB(20,120,40) or Color3.fromRGB(20,60,80)}):Play()
    TweenService:Create(hatchStroke, TweenInfo.new(0.2), {Color = hatchActive and Color3.fromRGB(80,255,120) or Color3.fromRGB(60,200,220)}):Play()
    if hatchActive then task.spawn(hatchLoop) end
end)

buyBtn.MouseButton1Click:Connect(function()
    buyActive = not buyActive
    buyBtn.Text = buyActive and "💰 BUY: ON (FAST)" or "💰 AUTO BUY HATCH LUCK"
    TweenService:Create(buyBtn, TweenInfo.new(0.2), {BackgroundColor3 = buyActive and Color3.fromRGB(20,120,40) or Color3.fromRGB(80,60,10)}):Play()
    TweenService:Create(buyStroke, TweenInfo.new(0.2), {Color = buyActive and Color3.fromRGB(80,255,120) or Color3.fromRGB(255,200,60)}):Play()
    if buyActive then task.spawn(buyLoop) end
end)

espEggBtn.MouseButton1Click:Connect(function()
    espEggOn = not espEggOn
    espEggBtn.Text = espEggOn and "👁 EGG ESP: ON" or "👁 EGG ESP: OFF"
    TweenService:Create(espEggBtn, TweenInfo.new(0.2), {BackgroundColor3 = espEggOn and Color3.fromRGB(20,120,40) or Color3.fromRGB(60,30,30)}):Play()
    if not espEggOn then clearAllESP() end
end)

TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 260, 0, 330)
}):Play()

print("[Zenith Premium] Loaded ✦ v14 — cinematic load")