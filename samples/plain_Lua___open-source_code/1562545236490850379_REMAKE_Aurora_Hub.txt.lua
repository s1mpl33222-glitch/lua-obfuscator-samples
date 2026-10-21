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
        if conn then conn:Disconnect() end
        if hrp.Parent then
            hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
            local last = waypoints[#waypoints]
            if (hrp.Position - last).Magnitude <= 6 then
                local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
                hrp.CFrame = CFrame.new(last) * CFrame.Angles(0, yaw, 0)
            end
        end
    end
    conn = RunService.Heartbeat:Connect(function()
        if not hrp.Parent or not iCollectPro_ALIVE() then finish() return end
        iCollectPro.equipCarpet()
        local target = waypoints[idx]
        local diff = target - hrp.Position
        local mag = diff.Magnitude
        local spd = speed
        local lastWp = idx == #waypoints
        if lastWp then spd = math.min(spd, math.max(40, mag * 12)) end
        if idx < #waypoints and mag < 26 then
            local turn = waypoints[idx + 1] - target
            if mag > 0.1 and turn.Magnitude > 0.1 and diff.Unit:Dot(turn.Unit) < 0.9 then spd = math.min(spd, 240) end
        end
        if mag < (lastWp and 1.5 or math.max(3, spd / 60 * 1.25)) then
            idx = idx + 1
            if idx > #waypoints then finish() return end
            lastDist, stallSince = math.huge, nil
            target = waypoints[idx]
            diff = target - hrp.Position
            mag = diff.Magnitude
        end
        if mag > lastDist - 0.05 then
            stallSince = stallSince or os.clock()
            if os.clock() - stallSince >= 0.4 then finish() return end
        else
            stallSince = nil
        end
        lastDist = mag
        if mag >= 0.1 then
            local dir = diff.Unit
            local sp = spd
            if dir.Y > 0 and dir.Y * sp > CLIMB then sp = CLIMB / dir.Y end
            hrp.AssemblyAngularVelocity = Vector3.zero
            body().AssemblyLinearVelocity = dir * sp
        end
    end)
    local timeout = os.clock() + total / math.min(125, speed) + 2
    local nextTrace, t0 = 0, os.clock()
    while not done and os.clock() < timeout and hrp.Parent do
        if os.clock() >= nextTrace and iCollectPro.log then
            nextTrace = os.clock() + 0.1
            local ch = hrp.Parent
            local tool = ch and ch:FindFirstChildOfClass("Tool")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            iCollectPro.log(string.format("  fly %.2fs  wp %d/%d  to end %.0f  vel %.0f  tool=%s  state=%s  anchored=%s",
                os.clock() - t0, idx, #waypoints, (waypoints[#waypoints] - hrp.Position).Magnitude,
                hrp.AssemblyLinearVelocity.Magnitude, tool and tool.Name or "-",
                hum and hum:GetState().Name or "?", tostring(hrp.Anchored)))
        end
        task.wait(0.03)
    end
    finish()
end

function iCollectPro.blocked(a, b, slackA, slackB)
    local d = b - a
    local len = d.Magnitude
    if len < 0.5 then return false end
    local u = d / len
    local a2 = a + u * math.min(slackA or 0, len * 0.4)
    local b2 = b - u * math.min(slackB or 0, len * 0.4)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.RespectCanCollide = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    local clone = Workspace:FindFirstChild(tostring(player.UserId) .. "_Clone")
    if clone then skip[#skip + 1] = clone end
    rp.FilterDescendantsInstances = skip
    local ok, hit = pcall(Workspace.Spherecast, Workspace, a2, 3, b2 - a2, rp)
    if not ok then hit = Workspace:Raycast(a2, b2 - a2, rp) end
    return hit ~= nil
end

function iCollectPro.gridPath(from, goal, y)
    local CELL, R, MARGIN, MAXN, W = 6, 3, 90, 6000, 100000
    local op = OverlapParams.new()
    op.FilterType = Enum.RaycastFilterType.Exclude
    op.RespectCanCollide = true
    local skip = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl.Character then skip[#skip + 1] = pl.Character end
    end
    local clone = Workspace:FindFirstChild(tostring(player.UserId) .. "_Clone")
    if clone then skip[#skip + 1] = clone end
    op.FilterDescendantsInstances = skip
    local x0 = math.min(from.X, goal.X) - MARGIN
    local z0 = math.min(from.Z, goal.Z) - MARGIN
    local nx = math.ceil((math.max(from.X, goal.X) + MARGIN - x0) / CELL)
    local nz = math.ceil((math.max(from.Z, goal.Z) + MARGIN - z0) / CELL)
    local function pos(k) return Vector3.new(x0 + (k // W) * CELL, y, z0 + (k % W) * CELL) end
    local function cellOf(p) return math.floor((p.X - x0) / CELL + 0.5), math.floor((p.Z - z0) / CELL + 0.5) end
    local open = {}
    local function isOpen(i, j)
        if i < 0 or j < 0 or i > nx or j > nz then return false end
        local k = i * W + j
        local v = open[k]
        if v == nil then
            v = #Workspace:GetPartBoundsInRadius(pos(k), R, op) == 0
            open[k] = v
        end
        return v
    end
    local si, sj = cellOf(from)
    local gi, gj = cellOf(goal)
    local sk, gk = si * W + sj, gi * W + gj
    open[sk], open[gk] = true, true
    local function h(i, j)
        local dx, dz = math.abs(i - gi), math.abs(j - gj)
        return math.max(dx, dz) + 0.414 * math.min(dx, dz)
    end
    local heap = {}
    local function push(f, k)
        heap[#heap + 1] = { f, k }
        local c = #heap
        while c > 1 do
            local p = c // 2
            if heap[p][1] <= heap[c][1] then break end
            heap[p], heap[c] = heap[c], heap[p]
            c = p
        end
    end
    local function pop()
        local top = heap[1]
        local last = table.remove(heap)
        if #heap > 0 then
            heap[1] = last
            local c = 1
            while true do
                local l, r, m = c * 2, c * 2 + 1, c
                if heap[l] and heap[l][1] < heap[m][1] then m = l end
                if heap[r] and heap[r][1] < heap[m][1] then m = r end
                if m == c then break end
                heap[m], heap[c] = heap[c], heap[m]
                c = m
            end
        end
        return top
    end
    local DIRS = { { 1, 0, 1 }, { -1, 0, 1 }, { 0, 1, 1 }, { 0, -1, 1 },
        { 1, 1, 1.414 }, { 1, -1, 1.414 }, { -1, 1, 1.414 }, { -1, -1, 1.414 } }
    local TURN = 0.5
    local g, came, closed, pdir = { [sk] = 0 }, {}, {}, {}
    push(h(si, sj), sk)
    local n, found = 0, false
    while #heap > 0 and n < MAXN do
        local k = pop()[2]
        if not closed[k] then
            closed[k] = true
            n = n + 1
            if k == gk then found = true break end
            local i, j = k // W, k % W
            local pd = pdir[k]
            for _, d in ipairs(DIRS) do
                local a, b = i + d[1], j + d[2]
                if isOpen(a, b) and (d[3] == 1 or (isOpen(a, j) and isOpen(i, b))) then
                    local nk, ng = a * W + b, g[k] + d[3] + ((pd and pd ~= d) and TURN or 0)
                    if not closed[nk] and (g[nk] == nil or ng < g[nk]) then
                        g[nk], came[nk], pdir[nk] = ng, k, d
                        push(ng + h(a, b), nk)
                    end
                end
            end
        end
    end
    if not found then return nil, n end
    local cells, k = {}, gk
    while k do cells[#cells + 1] = k k = came[k] end
    local pts = {}
    for idx = #cells, 1, -1 do pts[#pts + 1] = pos(cells[idx]) end
    pts[1], pts[#pts] = from, goal
    local out, cur = {}, 1
    while cur < #pts do
        local j = #pts
        while j > cur + 1 and iCollectPro.blocked(pts[cur], pts[j]) do j = j - 1 end
        out[#out + 1] = pts[j]
        cur = j
    end
    return out, n
end

function iCollectPro.routeTime(from, pts, speed)
    local t, prev = 0, from
    for _, p in ipairs(pts) do
        local d = p - prev
        t = t + math.max(d.Magnitude / speed, math.max(d.Y, 0) / 120)
        prev = p
    end
    return t
end

function iCollectPro.planRoute(from, approach, spot, cruiseY, speed)
    local B = iCollectPro.blocked
    local SLACK = 6
    speed = speed or 360
    if not B(from, approach, SLACK, 2) then return { approach, spot }, "straight" end
    local best, bestT, bestKind = nil, math.huge, nil
    local function consider(route, kind)
        local t = iCollectPro.routeTime(from, route, speed)
        if t < bestT then best, bestT, bestKind = route, t, kind end
    end
    local t0 = os.clock()
    for _, lift in ipairs({ 0, 12, 25, 45 }) do
        local y = approach.Y + lift
        local rise = Vector3.new(from.X, y, from.Z)
        local goal = Vector3.new(approach.X, y, approach.Z)
        local up = math.abs(from.Y - y) > 2
        if (not up or not B(from, rise, SLACK, 0)) and (lift == 0 or not B(goal, approach, 0, 2)) then
            local pts = iCollectPro.gridPath(rise, goal, y)
            if pts then
                local route = {}
                if up and B(from, pts[1], SLACK, 0) then route[1] = rise end
                for _, p in ipairs(pts) do route[#route + 1] = p end
                if lift > 0 then route[#route + 1] = approach end
                route[#route + 1] = spot
                consider(route, "path" .. (lift > 0 and (" +" .. lift) or ""))
            end
        end
    end
    local function pull(pts)
        local out, i = {}, 0
        local cur = from
        while i < #pts do
            local j = #pts
            while j > i + 1 and B(cur, pts[j], i == 0 and SLACK or 0, 0) do j = j - 1 end
            out[#out + 1] = pts[j]
            cur, i = pts[j], j
        end
        return out
    end
    for _, lift in ipairs({ 12, 25, 45 }) do
        local cy = math.max(from.Y, approach.Y) + lift
        local up, over = Vector3.new(from.X, cy, from.Z), Vector3.new(approach.X, cy, approach.Z)
        if not B(from, up, SLACK, 0) and not B(up, over) and not B(over, approach, 0, 2) then
            local pts = pull({ up, over, approach })
            pts[#pts + 1] = spot
            consider(pts, "crest +" .. lift)
            break
        end
    end
    local flat = Vector3.new(approach.X - from.X, 0, approach.Z - from.Z)
    if flat.Magnitude > 1 then
        local perp = Vector3.new(-flat.Unit.Z, 0, flat.Unit.X)
        local mid0 = (from + approach) * 0.5
        for _, off in ipairs({ 14, -14, 24, -24, 38, -38, 56, -56, 76, -76 }) do
            local mid = mid0 + perp * off
            if not B(from, mid, SLACK, 0) and not B(mid, approach, 0, 2) then
                consider({ mid, approach, spot }, "bend " .. off)
                break
            end
        end
    end
    if best then
        return best, string.format("%s (%.2fs, planned in %.0fms)", bestKind, bestT, (os.clock() - t0) * 1000)
    end
    local high = Vector3.new(approach.X, cruiseY, approach.Z)
    local lift = from:Lerp(high, 0.25)
    return { Vector3.new(lift.X, cruiseY, lift.Z), high, approach, spot }, "high cruise"
end

function iCollectPro.drawPath(from, pts)
    local old = Workspace:FindFirstChild("iCollectPro_SemiTP_Path")
    if old then old:Destroy() end
    if HubConfig.showPathEnabled == false then return end
    local folder = Instance.new("Folder")
    folder.Name = "iCollectPro_SemiTP_Path"
    local function part(cf, size, ball)
        local p = Instance.new("Part")
        p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
        p.Material = Enum.Material.Neon
        p.Color = T.ACCENT
        if ball then p.Shape = Enum.PartType.Ball end
        p.Size, p.CFrame = size, cf
        p.Parent = folder
    end
    local prev = from
    for _, wp in ipairs(pts) do
        local d = wp - prev
        if d.Magnitude > 0.05 then
            part(CFrame.lookAt((prev + wp) * 0.5, wp), Vector3.new(0.3, 0.3, d.Magnitude), false)
        end
        prev = wp
    end
    part(CFrame.new(pts[#pts]), Vector3.new(1.6, 1.6, 1.6), true)
    folder.Parent = Workspace
    task.delay(6, function() if folder.Parent then folder:Destroy() end end)
end

function iCollectPro.quantumClone()
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local cloner = iCollectPro.findTool("Quantum Cloner")
    if not hum or not hrp or not cloner then return false end
    local function stealing()
        local st = player:GetAttribute("Stealing")
        return st ~= nil and st ~= false
    end
    if iCollectPro.lastSwapAt and os.clock() - iCollectPro.lastSwapAt < 5 then
        iCollectPro.log("clone skipped - swapped under 5s ago")
        return false
    end
    if cloner.Parent ~= char then pcall(function() hum:EquipTool(cloner) end) end
    local t0 = os.clock()
    while cloner.Parent ~= char and os.clock() - t0 < 0.5 do RunService.Heartbeat:Wait() end
    pcall(function() hum:Move(Vector3.zero, false) end)
    hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    local lockCF = hrp.CFrame
    hrp.Anchored = true
    task.delay(2.5, function() if hrp.Parent then hrp.Anchored = false end end)
    t0 = os.clock()
    while os.clock() - t0 < 0.15 do
        RunService.Heartbeat:Wait()
        if hrp.Parent then hrp.CFrame = lockCF end
    end
    local cloneName = tostring(player.UserId) .. "_Clone"
    pcall(function() cloner:Activate() end)
    t0 = os.clock()
    local clone
    repeat
        RunService.Heartbeat:Wait()
        clone = Workspace:FindFirstChild(cloneName)
        if clone and (clone:GetPivot().Position - hrp.Position).Magnitude > 12 then clone = nil end
    until clone or os.clock() - t0 > 1
    hrp.Anchored = false
    iCollectPro.log(string.format("clone %s after %.2fs  (%.1f studs away)  equipped=%s",
        clone and "spawned" or "NOT seen", os.clock() - t0,
        clone and (clone:GetPivot().Position - hrp.Position).Magnitude or -1, tostring(cloner.Parent == char)))
    local frames = player.PlayerGui:FindFirstChild("ToolsFrames")
    local qc = frames and frames:FindFirstChild("QuantumCloner")
    local btn = qc and qc:FindFirstChild("TeleportToClone")
    if not btn or not firesignal or not clone then pcall(function() hum:UnequipTools() end) return false end
    local cloneAt = clone:GetPivot().Position
    local target = iCollectPro.cloneTarget
    if target then
        local function flat(v) return Vector2.new(v.X - target.X, v.Z - target.Z).Magnitude end
        if flat(cloneAt) > flat(hrp.Position) + 10 then
            iCollectPro.log(string.format("clone landed BEHIND us (%.1f vs %.1f from the brainrot) - no swap",
                flat(cloneAt), flat(hrp.Position)))
            pcall(function() hum:UnequipTools() end)
            return false
        end
    end
    if stealing() then pcall(function() hum:UnequipTools() end) return "stole" end
    local from = hrp.Position
    local gapV = Vector3.new(cloneAt.X - from.X, 0, cloneAt.Z - from.Z)
    local gap = gapV.Magnitude
    local dir = gap > 0.01 and gapV / gap or Vector3.zero
    local function swapDone()
        local me = (hrp.Position - from):Dot(dir)
        local cl = clone.Parent and Vector2.new(clone:GetPivot().Position.X - cloneAt.X,
            clone:GetPivot().Position.Z - cloneAt.Z).Magnitude or gap
        return me >= gap * 0.5 and cl >= gap * 0.5
    end
    local lastPress, presses = 0, 0
    t0 = os.clock()
    repeat
        if os.clock() - lastPress >= 0.1 then
            lastPress = os.clock()
            presses = presses + 1
            btn.Visible = true
            pcall(firesignal, btn.MouseButton1Up)
            iCollectPro.lastSwapAt = os.clock()
        end
        RunService.Heartbeat:Wait()
        if stealing() then break end
    until player.Character ~= char or not hrp.Parent or (gap >= 1.25 and swapDone()) or os.clock() - t0 > 1.5
    local ok = gap >= 1.25 and hrp.Parent and swapDone()
    iCollectPro.log(string.format("swap: %d presses in %.2fs  moved %.1f studs (gap %.1f)  confirmed=%s  newChar=%s",
        presses, os.clock() - t0, (hrp.Position - from).Magnitude, gap, tostring(ok), tostring(player.Character ~= char)))
    pcall(function() hum:UnequipTools() end)
    if stealing() and not ok then return "stole" end
    return ok and true or false
end

function iCollectPro.petPos(pod)
    for _, d in ipairs(pod.podium:GetDescendants()) do
        if d:IsA("Model") and d.Name ~= "Claim" and d.Name ~= "Base" and d.Name ~= "Decorations"
            and d:FindFirstChildWhichIsA("MeshPart", true) then
            local ok, cf = pcall(d.GetBoundingBox, d)
            if ok then return cf.Position end
        end
    end
    return pod.spawn.Position
end

function iCollectPro.oneWayPlatform(pos)
    local old = Workspace:FindFirstChild("iCollectPro_SemiTP_Platform")
    if old then old:Destroy() end
    local plat = Instance.new("Part")
    plat.Name = "iCollectPro_SemiTP_Platform"
    plat.Size = Vector3.new(10, 1, 10)
    plat.Position = pos
    plat.Anchored, plat.CanCollide, plat.Transparency = true, false, 1
    plat.Parent = Workspace
    local conn, lastY
    conn = RunService.Stepped:Connect(function()
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not plat.Parent or not hrp then conn:Disconnect() return end
        local y = hrp.Position.Y
        local up = hrp.AssemblyLinearVelocity.Y > 1 or (lastY and y - lastY > 0.01 and y - lastY < 5)
        plat.CanCollide = not up and y > plat.Position.Y + 0.1
        lastY = y
    end)
    task.delay(20, function() if plat.Parent then plat:Destroy() end end)
    return plat
end

function iCollectPro.upperSteal(pod, ctx)
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local cf = pod.rootCF
    local podLocal = cf:PointToObjectSpace(pod.spawn.Position)
    local s = podLocal.X >= 0 and 1 or -1
    local L = iCollectPro.log
    local function podDist()
        local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        return h and (h.Position - pod.spawn.Position).Magnitude or -1
    end
    L(string.format("UPPER podium %s  local(%.1f, %.1f, %.1f)  dist %.0f  hold=%s  prompt=%s",
        pod.podium.Name, podLocal.X, podLocal.Y, podLocal.Z, podDist(), tostring(ctx ~= nil), tostring(pod.prompt.Enabled)))
    if not pod.prompt.Enabled then
        L("podium prompt disabled - brainrot not grabbable yet, stopping")
        setStealStatus("BRAINROT NOT GRABBABLE YET - WAIT", false)
        return
    end
    stopFlyGear()

    iCollectPro.grappleBoost()
    L(string.format("grapple done  SpeedAllowance=%s  carpet=%s",
        tostring(char:GetAttribute("SpeedAllowance")), tostring(iCollectPro.carpetOn())))

    local flying = true
    if ctx then
        task.spawn(function()
            while flying do
                if tick() - (ctx.holdBeganAt or 0) >= 2.4 then
                    for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
                    ctx.holdBeganAt = tick()
                end
                task.wait(0.05)
            end
        end)
    end

    local spotY = podLocal.Y + 5.4
    local spotZ = math.clamp(podLocal.Z, -18, 18)
    local spot = cf * Vector3.new(24.6 * s, spotY, spotZ)
    local approach = cf * Vector3.new(34 * s, spotY, spotZ)
    local route, kind = iCollectPro.planRoute(hrp.Position, approach, spot, (cf * Vector3.new(0, 85, 0)).Y, 360)
    iCollectPro.drawPath(hrp.Position, route)
    L(string.format("route: %s, %d points", kind, #route))
    local flyT = os.clock()
    iCollectPro.flyRoute(hrp, route, 360)
    flying = false
    local offSpot = hrp.Parent and (hrp.Position - spot).Magnitude or math.huge
    L(string.format("flight done in %.2fs  off spot %.1f  pod dist %.1f", os.clock() - flyT, offSpot, podDist()))
    if offSpot > 6 then
        flying = false
        L("FLIGHT FAILED - never reached the clone spot, stopping")
        setStealStatus("FLIGHT BLOCKED - TRY AGAIN", false)
        return
    end
    if ctx then
        for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
        ctx.holdBeganAt = tick()
        L(string.format("hold restarted at the wall (pod dist %.1f)", podDist()))
    end

    local function stealing()
        local st = player:GetAttribute("Stealing")
        return st ~= nil and st ~= false
    end
    local function upperTrigger()
        local need = (tonumber(pod.prompt.HoldDuration) or 1.3) + 0.05
        while not stealing() do
            local age = tick() - (ctx.holdBeganAt or 0)
            if age > 2.5 then
                for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
                ctx.holdBeganAt = tick()
                L("hold older than 2.5s - restarted")
            elseif age >= need then
                break
            end
            RunService.Heartbeat:Wait()
        end
        if stealing() then return end
        if podDist() > 10 then L(string.format("grab held back - pod dist %.1f > 10", podDist())) return end
        L(string.format("grab fired  (hold age %.2fs, pod dist %.1f)", tick() - (ctx.holdBeganAt or 0), podDist()))
        for _, fn in ipairs(ctx.cb.trigger) do task.spawn(fn) end
    end
    iCollectPro.cloneTarget = pod.spawn.Position
    local grabbing = true
    local grabGate = math.huge
    task.spawn(function()
        while grabbing and not stealing() and iCollectPro_ALIVE() do
            if os.clock() >= grabGate and fireproximityprompt and pod.prompt.Parent then pcall(fireproximityprompt, pod.prompt, 0) end
            RunService.Heartbeat:Wait()
        end
    end)

    local face = cf:VectorToWorldSpace(Vector3.new(-s, 0, 0))
    local hold = Instance.new("Part")
    hold.Name = "iCollectPro_SemiTP_ClonePad"
    hold.Size = Vector3.new(12, 1, 12)
    hold.Position = spot - Vector3.new(0, 3.5, 0)
    hold.Anchored, hold.CanCollide, hold.Transparency = true, true, 1
    hold.Parent = Workspace
    for _ = 1, 2 do
        hrp.CFrame = CFrame.lookAt(spot, spot + face)
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        RunService.Heartbeat:Wait()
    end
    L(string.format("at the wall  pod dist %.1f  stealing=%s  cloner=%s", podDist(), tostring(stealing()),
        select(2, iCollectProUI.clonerState()) or "ready"))
    local swapped = not stealing() and iCollectPro.quantumClone()
    local swapT = os.clock()
    hold:Destroy()
    L(string.format("clone result=%s  pod dist %.1f  stealing=%s", tostring(swapped), podDist(), tostring(stealing())))
    if stealing() or swapped == "stole" then
        grabbing = false
        L("GRABBED from the wall (no swap)")
        task.spawn(iCollectProAutoPotion)
        return
    end
    if not swapped then
        grabbing = false
        L("CLONE FAILED - swap never moved us")
        setStealStatus("CLONE FAILED (Quantum Cloner on cooldown?)", false)
        return
    end

    char = player.Character
    hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then grabbing = false return end
    hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
    task.spawn(function()
        local cl = Workspace:FindFirstChild(tostring(player.UserId) .. "_Clone")
        if not cl then return end
        local function off(p)
            if p:IsA("BasePart") then p.CanTouch, p.CanCollide, p.CanQuery = false, false, false end
        end
        for _, p in ipairs(cl:GetDescendants()) do pcall(off, p) end
        local c = cl.DescendantAdded:Connect(function(p) pcall(off, p) end)
        L("clone neutralized (no touch / collide on our side)")
        task.delay(30, function() c:Disconnect() end)
    end)
    local qgChip = iCollectProUI.cfgChips and iCollectProUI.cfgChips.quickGrabEnabled
    local function qg(on)
        if qgChip then pcall(qgChip, on) else iCollectProFx.quickGrab = on end
    end
    local t0 = os.clock()
    while not iCollectPro.carpetOn() and os.clock() - t0 < 0.5 do iCollectPro.equipCarpet(); RunService.Heartbeat:Wait() end
    t0 = os.clock()
    while os.clock() - t0 < 0.08 do RunService.Heartbeat:Wait() end
    local to = pod.spawn.Position - Vector3.new(0, 8, 0)
    local old = Workspace:FindFirstChild("iCollectPro_SemiTP_Platform")
    if old then old:Destroy() end
    local plat = Instance.new("Part")
    plat.Name = "iCollectPro_SemiTP_Platform"
    plat.Size = Vector3.new(3, 1, 3)
    plat.Position = to - Vector3.new(0, 5, 0)
    plat.Anchored, plat.CanCollide, plat.Transparency = true, true, 1
    plat.Parent = Workspace
    task.spawn(function()
        task.wait(30)
        while plat.Parent and stealing() do task.wait(0.5) end
        if plat.Parent then plat:Destroy() end
    end)
    RunService.Heartbeat:Wait()
    local snapped = false
    for _ = 1, 2 do
        if not hrp.Parent then grabbing = false return end
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        hrp.CFrame = CFrame.new(to) * hrp.CFrame.Rotation
        hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
        t0 = os.clock()
        while os.clock() - t0 < 0.05 do RunService.Heartbeat:Wait() end
        if hrp.Parent and (hrp.Position - to).Magnitude <= 3 then snapped = true break end
    end
    local snapT = os.clock()
    L(string.format("snapped under the podium %.2fs after the swap  ok=%s  pod dist %.1f",
        snapT - swapT, tostring(snapped), podDist()))

    local settleUntil = math.max(snapT + 0.35, swapT + 0.5)
    while os.clock() < settleUntil and not stealing() do RunService.Heartbeat:Wait() end
    grabGate = os.clock()
    L(string.format("settled %.2fs after the swap - grabbing  pod dist %.1f  hold age %.2fs",
        os.clock() - swapT, podDist(), ctx and tick() - (ctx.holdBeganAt or 0) or -1))
    qg(true)
    iCollectPro.upperGrab = true
    if ctx then task.spawn(upperTrigger) end
    local pulses = 0
    task.spawn(function()
        local t = os.clock()
        while not stealing() and iCollectPro.upperGrab and iCollectPro_ALIVE() and os.clock() - t < 1.5 do
            task.wait(0.1)
            if stealing() or not iCollectPro.upperGrab then break end
            qg(false)
            task.wait(0.03)
            qg(true)
            pulses = pulses + 1
        end
        qg(not stealing())
    end)
    local function grabFor(sec)
        local t = os.clock()
        while not stealing() and os.clock() - t < sec do RunService.Heartbeat:Wait() end
        return stealing()
    end
    local got = grabFor(2.5)
    grabbing = false
    iCollectPro.upperGrab = false
    if got then
        qg(false)
        L(string.format("GRABBED under the podium %.2fs after the swap  (quick grab pulses %d, now OFF)",
            os.clock() - swapT, pulses))
        task.spawn(iCollectProAutoPotion)
        return
    end
    L(string.format("NO GRAB under the podium (pod dist %.1f, prompt=%s, hold age %.2fs)",
        podDist(), tostring(pod.prompt.Enabled), ctx and tick() - (ctx.holdBeganAt or 0) or -1))
    setStealStatus("NO GRAB - TRY AGAIN", false)
end

function iCollectPro.SSDoTeleport()
    local char = player.Character
    local hum = char and char:FindFirstChild("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return end

    setFFlags()

    local pod = findPodiumTarget(selectedSlot, hrp)
    if not pod then return end

    local function doTpSequence(HRP)
        local cf = pod.rootCF
        local podLocal = cf:PointToObjectSpace(pod.spawn.Position)
        local s = podLocal.X >= 0 and 1 or -1
        local row = rowFor(podLocal.Z)
        local upper = podLocal.Y > GROUND_MAX_Y
        local function at(v) return cf * Vector3.new(v.X * s, v.Y, v.Z) end

        local inside = at(row.inside)

        local here = cf:PointToObjectSpace(HRP.Position)
        local waypoints = {
            cf * Vector3.new(math.clamp(here.X, -CORRIDOR_REACH, CORRIDOR_REACH), CORRIDOR_Y, CORRIDOR_Z),
            cf * Vector3.new(0, CORRIDOR_Y, CORRIDOR_Z),
            inside,
        }

        local function doApproachPath(HRP_, speed)
            local startIndex = 1
            for i = #waypoints, 1, -1 do
                if canDirectTp(HRP_, waypoints[i]) then startIndex = i; break end
            end
            for i = startIndex, #waypoints do
                walkTo(HRP_, waypoints[i], speed or 180)
            end
        end

        local ctx = nil
        if pod.prompt and pod.prompt.Parent then
            pod.prompt.RequiresLineOfSight = false
            pod.prompt.MaxActivationDistance = math.huge
            if type(getconnections) == "function" then
                ctx = iCollectProHold.startStealHold(pod.prompt)
            else
                task.spawn(function()
                    if fireproximityprompt then fireproximityprompt(pod.prompt) end
                end)
            end
        end

        if ctx and not upper then iCollectProHold.waitForStealTime(ctx, 0.8) end
        if upper then
            iCollectPro.upperSteal(pod, ctx)
        else
            doApproachPath(HRP, 180)
            task.wait(0.25)

            iCollectProAutoPotion()

            if pod.prompt and pod.prompt.Parent then
                if ctx then iCollectProHold.waitForStealTime(ctx, 1.3) end
                if ctx and iCollectProFx.defBypass and iCollectProUI.waitOwnerLeave and not iCollectProUI.waitOwnerLeave(pod, ctx) then return end
                local green = clampToPodium(inside, at(row.green), pod.spawn.Position)
                HRP.CFrame = CFrame.new(green)
                HRP.AssemblyLinearVelocity = Vector3.zero
                iCollectPro.log("ground grab (original green snap)")
                if ctx then iCollectProHold.finishStealHold(ctx) end
            end
        end
    end

    task.spawn(function()
        _G.iCollectPro_SemiTP_Busy = true
        pcall(doTpSequence, hrp)
        iCollectPro.upperGrab = false
        _G.iCollectPro_SemiTP_Busy = false
        stopFlyGear()
    end)
end

local TeleportBtn = nil

function iCollectPro.execute(ignoreLock)
    if not iCollectPro_ALIVE() then return end
    if iCollectProUI.bypassWaiting then iCollectProUI.bypassWaiting = false return end
    if player:GetAttribute("Stealing") or iCollectPro.debounce then return end
    iCollectPro.logT0 = os.clock()
    iCollectPro.log("---- STEAL NOW  podium " .. tostring(selectedSlot))
    local ok, why = iCollectProUI.check(ignoreLock == true)
    if not ok then
        iCollectPro.log("refused: " .. tostring(why))
        iCollectProUI.flash(why)
        return
    end
    task.spawn(function()
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local conns = {}
        local grabPos
        local function state()
            local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
            if not h then return "no root" end
            return string.format("moved %.1f  vel %.0f  tool=%s  busy=%s", grabPos and (h.Position - grabPos).Magnitude or 0,
                h.AssemblyLinearVelocity.Magnitude, tool and tool.Name or "-", tostring(_G.iCollectPro_SemiTP_Busy))
        end
        conns[1] = player:GetAttributeChangedSignal("Stealing"):Connect(function()
            iCollectPro.log("Stealing -> " .. tostring(player:GetAttribute("Stealing")) .. "  " .. tostring(player:GetAttribute("StealingIndex") or ""))
            local h = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if player:GetAttribute("Stealing") and h and not grabPos then
                grabPos = h.Position
                local seen, tconns = {}, {}
                for _, p in ipairs(player.Character:GetChildren()) do
                    if p:IsA("BasePart") then
                        tconns[#tconns + 1] = p.Touched:Connect(function(o)
                            if o:IsDescendantOf(player.Character) or seen[o] then return end
                            seen[o] = true
                            iCollectPro.log(string.format("  touched %s  (%s, collide=%s)", o:GetFullName():sub(-70),
                                o.ClassName, tostring(o.CanCollide)))
                        end)
                    end
                end
                task.delay(2, function() for _, c in ipairs(tconns) do c:Disconnect() end end)
                task.spawn(function()
                    for _ = 1, 15 do
                        task.wait(0.1)
                        iCollectPro.log("  after grab: " .. state())
                    end
                end)
            end
        end)
        if hum then
            local lastHp = hum.Health
            conns[2] = hum:GetPropertyChangedSignal("Health"):Connect(function()
                if hum.Health < lastHp - 1 then iCollectPro.log(string.format("HP %.0f -> %.0f  %s", lastHp, hum.Health, state())) end
                lastHp = hum.Health
            end)
        end
        conns[3] = player.CharacterAdded:Connect(function() iCollectPro.log("RESPAWNED (died / reset)") end)
        local net = game:GetService("ReplicatedStorage"):FindFirstChild("Packages")
        net = net and net:FindFirstChild("Net")
        for _, n in ipairs({ "RE/NotificationService/Notify", "RE/StealService/StealingFailure",
            "RE/StealService/StealingSuccess", "RE/StealService/Grab", "RE/QuantumCloner/OnTeleport" }) do
            local re = net and net:FindFirstChild(n)
            if re then
                conns[#conns + 1] = re.OnClientEvent:Connect(function(...)
                    local a = {}
                    for i, v in ipairs({ ... }) do
                        a[i] = typeof(v) == "Instance" and v:GetFullName():sub(-40) or tostring(v):sub(1, 60)
                    end
                    iCollectPro.log("  server " .. n:match("[^/]+/[^/]+$") .. ": " .. table.concat(a, " | "))
                end)
            end
        end
        task.wait(10)
        for _, c in ipairs(conns) do c:Disconnect() end
        iCollectPro.log("---- log window closed  busy=" .. tostring(_G.iCollectPro_SemiTP_Busy))
    end)
    for _, key in ipairs({ "quickGrabEnabled", "publicGrabEnabled" }) do
        local set = iCollectProUI.cfgChips and iCollectProUI.cfgChips[key]
        if set then pcall(set, false) end
    end
    iCollectProFx.quickGrab, iCollectProFx.pubGrab = false, false
    local ragdollChip = iCollectProUI.cfgChips and iCollectProUI.cfgChips.antiRagdollEnabled
    if ragdollChip then pcall(ragdollChip, true) end
    iCollectPro.debounce = true
    iCollectPro.pressedAt = tick()
    STEAL_DURATION = 1.3

    task.spawn(function()
        local startT = tick()
        while tick() - startT < STEAL_DURATION do
            local p = math.clamp((tick() - startT) / STEAL_DURATION, 0, 1)
            updateProgressBar(p); task.wait()
        end
        updateProgressBar(1); task.wait(0.3); updateProgressBar(0)
    end)

    task.spawn(function()
        setFFlags()
        iCollectProUI.inputLock(true)
        holdFlyGearUntilCarrying()
        pcall(iCollectPro.SSDoTeleport)
        if not _G.iCollectPro_SemiTP_Busy then stopFlyGear() end
        local t0 = os.clock()
        while _G.iCollectPro_SemiTP_Busy and os.clock() - t0 < 20 do task.wait() end
        iCollectProUI.inputLock(false)
        task.wait(0.1)
        iCollectPro.debounce = false
    end)
end

iCollectProUI.friendPrompts = {}
do
    local set = iCollectProUI.friendPrompts
    local function consider(d)
        if d:IsA("ProximityPrompt") then
            local function check()
                if string.find(d.ObjectText, "llow Friends", 1, true) then set[d] = true end
            end
            check()
            d:GetPropertyChangedSignal("ObjectText"):Connect(check)
            d.AncestryChanged:Connect(function(_, parent) if not parent then set[d] = nil end end)
        end
    end
    for _, d in ipairs(Workspace:GetDescendants()) do consider(d) end
    local addConn
    addConn = Workspace.DescendantAdded:Connect(function(d)
        if not iCollectPro_ALIVE() then addConn:Disconnect() return end
        consider(d)
    end)
end

function iCollectProUI.promptPart(desc)
    local p = desc.Parent
    if not p then return nil end
    return p:IsA("BasePart") and p or p:FindFirstChildWhichIsA("BasePart", true)
end

local function friendsAllowed(plot)
    for desc in pairs(iCollectProUI.friendPrompts) do
        if desc.Parent and string.find(desc.ObjectText, "Disallow", 1, true) then
            local part = iCollectProUI.promptPart(desc)
            if part and part:IsDescendantOf(plot) then return true end
        end
    end
    return false
end
iCollectProUI.friendsAllowed = friendsAllowed

local hasAutoTPTriggered = false
task.spawn(function()
    while task.wait(0.1) do
        if not iCollectPro_ALIVE() then return end
        local hrp = AutoTPOnAllowEnabled and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local pod = hrp and findPodiumTarget(selectedSlot, hrp)
        if pod and friendsAllowed(pod.plot) then
            if not hasAutoTPTriggered and not iCollectPro.debounce and not player:GetAttribute("Stealing") then
                hasAutoTPTriggered = true
                iCollectPro.execute(true)
            end
        else
            hasAutoTPTriggered = false
        end
    end
end)

task.spawn(function()
    local wasLocked = setmetatable({}, { __mode = "k" })
    while iCollectPro_ALIVE() do
        task.wait(0.05)
        local hrp = iCollectProFx.unlockTP and player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local pod = hrp and findPodiumTarget(selectedSlot, hrp)
        if pod then
            local locked = iCollectProUI.lockInfo(pod.plot)
            if wasLocked[pod.plot] and not locked and iCollectProFx.unlockTP
                and not iCollectPro.debounce and not player:GetAttribute("Stealing") then
                iCollectPro.execute()
            end
            wasLocked[pod.plot] = locked
        end
    end
end)

do
    local _RunService = RunService
    local LP          = player

    _G.iCollectPro_SemiTP_ResetBusy = false
    _G.iCollectPro_SemiTP_AntiDieDisabled = nil

    _G.iCollectPro_SemiTP_InstaReset = function()
        local _now = os.clock()
        if _G.iCollectPro_SemiTP_ResetBusy
            and (_now - (tonumber(_G.iCollectPro_SemiTP_ResetAt) or 0))
                < (tonumber(_G.iCollectPro_SemiTP_ResetCooldown) or 2.5) then
            return
        end
        _G.iCollectPro_SemiTP_ResetBusy = true
        _G.iCollectPro_SemiTP_ResetAt   = _now

        task.spawn(function()
            local _prevAntiDie = _G.iCollectPro_SemiTP_AntiDieDisabled
            _G.iCollectPro_SemiTP_AntiDieDisabled = true
            _G.iCollectPro_SemiTP_StealHold  = false
            if _G.iCollectPro_SemiTP_SoftenAntiDie then pcall(_G.iCollectPro_SemiTP_SoftenAntiDie) end

            local _restored, _holding = false, true
            local function _restore()
                if _restored then return end
                _restored = true
                _holding  = false
                _G.iCollectPro_SemiTP_AntiDieDisabled  = nil
                _G.iCollectPro_SemiTP_ResetBusy = false
            end

            local _conn
            _conn = LP.CharacterAdded:Connect(function(newChar)
                if _conn then _conn:Disconnect(); _conn = nil end
                task.defer(function()
                    pcall(function() newChar:WaitForChild("Humanoid", 12) end)
                    _RunService.Heartbeat:Wait()
                    _restore()
                end)
            end)
            task.delay(8, function()
                if _conn then _conn:Disconnect(); _conn = nil end
                _restore()
            end)

            pcall(function()
                local char = LP.Character
                if not char then return end

                local _origChar = char

                local bp = LP:FindFirstChild("Backpack")
                if bp then
                    local hum = char:FindFirstChildOfClass("Humanoid")
                    if hum then pcall(function() hum:UnequipTools() end) end
                    for _, ch in ipairs(char:GetChildren()) do
                        if ch:IsA("Tool") then
                            pcall(function() ch.Parent = bp end)
                        end
                    end
                end

                local function _flingPart()
                    local c = LP.Character
                    if not c then return nil end
                    return c:FindFirstChild("UpperTorso")
                        or c:FindFirstChild("Torso")
                        or c:FindFirstChild("HumanoidRootPart")
                end

                local _t0 = os.clock()
                while os.clock() - _t0
                    < (tonumber(_G.iCollectPro_SemiTP_ResetFlingTime) or 5) do
                    if LP.Character ~= _origChar then break end
                    local _h = _origChar:FindFirstChildOfClass("Humanoid")
                    if not _h or _h.Health <= 0
                        or _h:GetState() == Enum.HumanoidStateType.Dead then
                        break
                    end
                    local part = _flingPart()
                    if not part then break end

                    pcall(function()
                        for _, o in ipairs(part:GetChildren()) do
                            if o:IsA("BodyPosition") or o:IsA("BodyVelocity")
                                or o:IsA("BodyGyro") or o:IsA("AlignPosition")
                                or o:IsA("LinearVelocity") then
                                o:Destroy()
                            end
                        end
                    end)

                    pcall(function()
                        part.Velocity = Vector3.new(0, 9999999, 0)
                    end)
                    _RunService.Heartbeat:Wait()
                end
            end)
        end)
    end
end

local iCollectProAntiRagdoll = {}
do
    local RS = ReplicatedStorage
    local LP = player

    local connections = {}
    local character, humanoid, rootPart, animator

    local function antiDieOff()
        return not AntiRagdollEnabled or _G.iCollectPro_SemiTP_AntiDieDisabled == true or _G.iCollectPro_SemiTP_ResetBusy == true
    end

    local function isFlyingCarpetActive()
        if not character then return false end
        if not character:FindFirstChildWhichIsA("Tool") then return false end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    return true
                end
            end
        end
        return false
    end

    local function isRagdolled()
        if not humanoid then return false end
        local state = humanoid:GetState()
        return state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.GettingUp
    end

    local controls
    local function enableControls()
        if not controls then
            local ps = LP:FindFirstChild("PlayerScripts")
            local PlayerModule = ps and ps:FindFirstChild("PlayerModule")
            if not PlayerModule then return end
            pcall(function() controls = require(PlayerModule):GetControls() end)
        end
        if controls then pcall(function() controls:Enable() end) end
    end

    local function cleanupRagdoll()
        if not character then return end
        local carpetEquipped = isFlyingCarpetActive()
        pcall(function()
            for _, obj in ipairs(character:GetChildren()) do
                if obj:IsA("BallSocketConstraint") or obj:IsA("NoCollisionConstraint") or obj:IsA("HingeConstraint")
                    or (obj:IsA("Attachment") and (obj.Name == "A" or obj.Name == "B")) then
                    obj:Destroy()
                elseif obj:IsA("BodyVelocity") or obj:IsA("BodyPosition") or obj:IsA("BodyGyro") then
                    if not carpetEquipped then obj:Destroy() end
                elseif obj:IsA("Motor6D") then
                    obj.Enabled = true
                elseif obj:IsA("BasePart") then
                    for _, child in ipairs(obj:GetChildren()) do
                        if child:IsA("Motor6D") then
                            child.Enabled = true
                        elseif child:IsA("BallSocketConstraint") or child:IsA("NoCollisionConstraint") or child:IsA("HingeConstraint") then
                            child:Destroy()
                        elseif child:IsA("Attachment") and (child.Name == "A" or child.Name == "B") then
                            child:Destroy()
                        end
                    end
                end
            end
        end)
        if animator then
            for _, track in pairs(animator:GetPlayingAnimationTracks()) do
                local animName = track.Animation and track.Animation.Name:lower() or ""
                if animName:find("rag") or animName:find("fall") or animName:find("hurt") or animName:find("down") then
                    track:Stop(0)
                end
            end
        end
    end

    local function harden(hum)
        pcall(function() hum.BreakJointsOnDeath = false end)
        pcall(function() hum.RequiresNeck = false end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false) end)
    end

    local function soften(hum)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true) end)
        pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true) end)
        pcall(function() hum.BreakJointsOnDeath = true end)
        pcall(function() hum.RequiresNeck = true end)
    end

    local function revive(hum)
        pcall(function() hum.Health = hum.MaxHealth end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end

    local function clear()
        for _, c in pairs(connections) do pcall(function() c:Disconnect() end) end
        connections = {}
    end

    local function bind(signal, fn)
        local c
        c = signal:Connect(function(...)
            if not iCollectPro_ALIVE() then c:Disconnect() return end
            return fn(...)
        end)
        table.insert(connections, c)
    end

    local function setup()
        clear()
        if not AntiRagdollEnabled or not humanoid or not rootPart then return end
        local hum = humanoid

        if not antiDieOff() then harden(hum) end

        bind(hum:GetPropertyChangedSignal("Health"), function()
            if antiDieOff() then return end
            if hum.Parent and hum.Health <= 0 then revive(hum) end
        end)

        bind(hum.Died, function()
            if antiDieOff() then return end
            if hum.Parent then revive(hum) end
        end)

        local lastHarden = 0
        bind(RunService.Heartbeat, function()
            if not hum.Parent or antiDieOff() then return end
            local now = os.clock()
            if now - lastHarden >= 1.0 then lastHarden = now; harden(hum) end
            if hum.Health <= 0 then revive(hum) end
        end)

        local HOLD_GRACE = 0.35
        local holdPos, holdUntil, lastSafe = nil, 0, nil

        local function myRoot()
            local ch = LP.Character
            return ch and ch:FindFirstChild("HumanoidRootPart")
        end

        local function ragLeft()
            local t = LP:GetAttribute("RagdollEndTime")
            if type(t) ~= "number" then return 0 end
            return t - workspace:GetServerTimeNow()
        end

        local function lockOff()
            return _G.iCollectPro_SemiTP_ResetBusy == true
                or _G.iCollectPro_SemiTP_Busy == true
                or isFlyingCarpetActive()
        end

        local function hitNow()
            if lockOff() then return end
            local rp = myRoot()
            if not rp then return end
            holdUntil = math.max(holdUntil, os.clock() + HOLD_GRACE)
            if not holdPos then holdPos = lastSafe or rp.Position end
            pcall(function()
                rp.AssemblyLinearVelocity = Vector3.zero
                rp.AssemblyAngularVelocity = Vector3.zero
            end)
        end

        local function holding()
            return holdPos ~= nil and (os.clock() < holdUntil or ragLeft() > 0)
        end

        local function pin(rp, dt)
            if dt then
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    holdPos = holdPos + Vector3.new(md.X, 0, md.Z) * hum.WalkSpeed * dt
                end
            end
            local _, yaw = rp.CFrame:ToEulerAnglesYXZ()
            rp.CFrame = CFrame.new(holdPos) * CFrame.Angles(0, yaw, 0)
            rp.AssemblyLinearVelocity = Vector3.zero
            rp.AssemblyAngularVelocity = Vector3.zero
        end

        bind(hum.StateChanged, function()
            if isRagdolled() then
                hitNow()
                if not isFlyingCarpetActive() then hum:ChangeState(Enum.HumanoidStateType.Running) end
                cleanupRagdoll()
                workspace.CurrentCamera.CameraSubject = hum
                enableControls()
            end
        end)

        bind(LP:GetAttributeChangedSignal("RagdollEndTime"), function()
            if ragLeft() > 0 then
                hitNow()
                enableControls()
            end
        end)

        local net = RS:FindFirstChild("Packages")
        net = net and net:FindFirstChild("Net")
        for _, nm in ipairs({ "RE/CombatService/ApplyImpulse", "RE/Ragdoll" }) do
            local re = net and net:FindFirstChild(nm)
            if re and re:IsA("RemoteEvent") then
                bind(re.OnClientEvent, function() hitNow() end)
            end
        end

        bind(character.DescendantAdded, function()
            if isRagdolled() then cleanupRagdoll() end
        end)

        bind(RunService.PreSimulation, function()
            if not holdPos or lockOff() or not holding() then return end
            local rp = myRoot()
            if rp then pcall(pin, rp) end
        end)

        bind(RunService.Heartbeat, function(dt)
            local rp = myRoot()
            if not rp then return end
            if ragLeft() > 0 then
                enableControls()
                if not holdPos then hitNow() end
            end
            if isRagdolled() then cleanupRagdoll() end
            if holdPos then
                if lockOff() then
                    holdPos = nil
                elseif holding() then
                    pcall(pin, rp, dt)
                else
                    holdPos = nil
                    pcall(function()
                        rp.AssemblyLinearVelocity = Vector3.zero
                        rp.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
            else
                lastSafe = rp.Position
            end
        end)

        local CAM_BIND = "iCollectProSemiTPCamLock"
        pcall(RunService.UnbindFromRenderStep, RunService, CAM_BIND)
        pcall(function()
            RunService:BindToRenderStep(CAM_BIND, Enum.RenderPriority.Camera.Value - 1, function()
                if _G.iCollectPro_SemiTP_ResetBusy == true then return end
                local cam = workspace.CurrentCamera
                local ch = LP.Character
                if not cam or not ch or not hum.Parent then return end
                local sub = cam.CameraSubject
                if sub ~= hum and typeof(sub) == "Instance" and sub:IsDescendantOf(ch) then
                    cam.CameraSubject = hum
                end
            end)
        end)
        table.insert(connections, {
            Disconnect = function() pcall(RunService.UnbindFromRenderStep, RunService, CAM_BIND) end,
        })

        enableControls()
        cleanupRagdoll()
    end

    local function attach(char)
        character = char
        humanoid = char:WaitForChild("Humanoid", 10)
        rootPart = char:WaitForChild("HumanoidRootPart", 10)
        animator = humanoid and humanoid:WaitForChild("Animator", 10)
    end

    _G.iCollectPro_SemiTP_SoftenAntiDie = function()
        if humanoid then soften(humanoid) end
    end

    function iCollectProAntiRagdoll.set(on)
        AntiRagdollEnabled = on and true or false
        if AntiRagdollEnabled then
            setup()
        else
            clear()
            if humanoid then soften(humanoid) end
        end
    end

    local arCharConn
    arCharConn = LP.CharacterAdded:Connect(function(char)
        if not iCollectPro_ALIVE() then arCharConn:Disconnect() return end
        clear()
        character, humanoid, rootPart, animator = nil, nil, nil, nil
        local h = char:WaitForChild("Humanoid", 10)
        local r = char:WaitForChild("HumanoidRootPart", 10)
        if not h or not r then return end
        task.wait(0.2)
        attach(char)
        setup()
    end)

    if LP.Character then
        task.spawn(function()
            attach(LP.Character)
            setup()
        end)
    end
end

local iCollectProAntiRocket = {}
do
    local LP = player
    local charConn
    local nextTick = 0

    local function off()
        return not AntiRocketEnabled or _G.iCollectPro_SemiTP_ResetBusy == true
    end

    local function strip(char)
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("VectorForce") then pcall(function() d:Destroy() end) end
        end
    end

    local function hookChar(char)
        if charConn then charConn:Disconnect() charConn = nil end
        if not char then return end
        strip(char)
        charConn = char.DescendantAdded:Connect(function(d)
            if off() or not d:IsA("VectorForce") then return end
            task.defer(function() pcall(function() d:Destroy() end) end)
        end)
    end

    local hbConn
    hbConn = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then
            hbConn:Disconnect()
            if charConn then charConn:Disconnect() end
            return
        end
        if off() then return end
        local now = os.clock()
        if now < nextTick then return end
        nextTick = now + 0.1

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) then return end

        strip(char)
        if hum.PlatformStand or hum:GetState() == Enum.HumanoidStateType.PlatformStanding then
            hum.PlatformStand = false
            local v = hrp.AssemblyLinearVelocity
            if v.Y > 5 then
                hrp.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z)
            end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
    end)

    ;(function()
        local function off()
            return not (AntiRocketEnabled or AntiRagdollEnabled) or _G.iCollectPro_SemiTP_ResetBusy == true
        end
        local guardUntil, anchor = 0, nil
        local function arm()
            if off() then return end
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            if os.clock() > guardUntil then anchor = hrp.Position end
            guardUntil = os.clock() + 8
        end
        iCollectPro.rocketArm = arm
        local lastFree = nil
        local function step()
            local ch = LP.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local hum = ch and ch:FindFirstChildOfClass("Humanoid")
            if not (hrp and hum) then return end
            local busy = _G.iCollectPro_SemiTP_Busy == true or _G.iCollectPro_SemiTP_ResetBusy == true
            local v = hrp.AssemblyLinearVelocity
            if os.clock() < guardUntil and anchor and not busy and not off() then
                hum.PlatformStand = false
                local flat = Vector3.new(v.X, 0, v.Z)
                if flat.Magnitude > hum.WalkSpeed + 4 then flat = flat.Unit * hum.WalkSpeed end
                hrp.AssemblyLinearVelocity = Vector3.new(flat.X, math.min(v.Y, 0), flat.Z)
                hrp.AssemblyAngularVelocity = Vector3.zero
                local p = hrp.Position
                anchor = Vector3.new(p.X, anchor.Y, p.Z)
                if p.Y - anchor.Y > 3 then
                    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
                    hrp.CFrame = CFrame.new(anchor) * CFrame.Angles(0, yaw, 0)
                end
                return
            end
            if not busy and not off() and (Vector3.new(v.X, 0, v.Z).Magnitude > 150 or v.Y > 120)
                and not ch:FindFirstChildOfClass("Tool") then
                hrp.AssemblyLinearVelocity = Vector3.zero
                hrp.AssemblyAngularVelocity = Vector3.zero
                if lastFree then hrp.CFrame = lastFree end
                return
            end
            if v.Magnitude < 60 and hum.FloorMaterial ~= Enum.Material.Air then lastFree = hrp.CFrame end
        end
        local c1, c2, c3
        c1 = RunService.PreSimulation:Connect(function()
            if not iCollectPro_ALIVE() then c1:Disconnect() c2:Disconnect() c3:Disconnect() return end
            step()
        end)
        c2 = RunService.Heartbeat:Connect(step)
        local FX = { ParticleEmitter = true, Fire = true, Smoke = true, Sparkles = true, Trail = true, Beam = true, Sound = true }
        local function hideFx(d)
            pcall(function()
                if d:IsA("Sound") then d.Volume = 0; d:Stop() else d.Enabled = false end
            end)
        end
        c3 = Workspace.DescendantAdded:Connect(function(d)
            local ch = LP.Character
            if d:IsA("Explosion") then
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if hrp and not off() and (d.Position - hrp.Position).Magnitude <= math.max(d.BlastRadius, 12) + 6 then
                    arm()
                    pcall(function() d.BlastPressure = 0; d.DestroyJointRadiusPercent = 0; d.Visible = false end)
                end
            elseif ch and d:IsDescendantOf(ch) then
                if d:IsA("VectorForce") then
                    arm()
                    if not off() and not _G.iCollectPro_SemiTP_Busy then task.defer(function() pcall(function() d:Destroy() end) end) end
                elseif FX[d.ClassName] and os.clock() < guardUntil and not off() then
                    hideFx(d)
                end
            end
        end)
    end)()

    local rcCharConn
    rcCharConn = LP.CharacterAdded:Connect(function(char)
        if not iCollectPro_ALIVE() then rcCharConn:Disconnect() return end
        char:WaitForChild("HumanoidRootPart", 10)
        hookChar(char)
    end)
    if LP.Character then task.spawn(hookChar, LP.Character) end

    local VICTIMS = { "jumpscare", "balloon", "inverse", "nightvision" }
    local cmds = ReplicatedStorage:FindFirstChild("Datas")
    cmds = cmds and cmds:FindFirstChild("AdminCommands")
    for _, name in ipairs(VICTIMS) do
        pcall(function()
            local m = require(cmds[name])
            if type(m.effects) == "table" and type(m.effects.Victim) == "function" then
                local orig = rawget(m.effects, "__semiOrigVictim") or m.effects.Victim
                m.effects.__semiOrigVictim = orig
                m.effects.Victim = function(...)
                    if AntiRocketEnabled then return end
                    return orig(...)
                end
            end
        end)
    end

    local charCtrl
    pcall(function() charCtrl = require(ReplicatedStorage.Controllers.CharacterController) end)
    local adminConn, adminNext = nil, 0
    adminConn = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then adminConn:Disconnect() return end
        if off() or os.clock() < adminNext then return end
        adminNext = os.clock() + 0.1
        if charCtrl and charCtrl.Controls and charCtrl.originalMoveFunction
            and charCtrl.Controls.moveFunction ~= charCtrl.originalMoveFunction then
            charCtrl.Controls.moveFunction = charCtrl.originalMoveFunction
        end
        if Workspace.Gravity < 150 then Workspace.Gravity = 196.2 end
        local char = LP.Character
        if char then
            for _, m in ipairs(char:GetChildren()) do
                if m:IsA("Model") then
                    for _, p in ipairs(m:GetDescendants()) do
                        if (p:IsA("BasePart") or p:IsA("Decal")) and p.LocalTransparencyModifier ~= 1 then
                            p.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end)

    function iCollectProAntiRocket.set(on)
        AntiRocketEnabled = on and true or false
        if AntiRocketEnabled and LP.Character then strip(LP.Character) end
    end
end

local iCollectProAntiFx = {}
do
    local LP = player
    local Lighting = game:GetService("Lighting")
    local net = ReplicatedStorage:FindFirstChild("Packages")
    net = net and net:FindFirstChild("Net")

    local charCtrl, camCtrl
    pcall(function() charCtrl = require(ReplicatedStorage.Controllers.CharacterController) end)
    pcall(function() camCtrl = require(ReplicatedStorage.Controllers.CameraController) end)
    local boomSound = ReplicatedStorage.Controllers:FindFirstChild("ItemController")
    boomSound = boomSound and boomSound:FindFirstChild("BoogieBombController")
    boomSound = boomSound and boomSound:FindFirstChild("BOOM")

    local function defaultFov()
        local ok, f = pcall(function() return camCtrl:GetDefaultFov() end)
        return ok and tonumber(f) or 70
    end

    local FX_SRC = { BeeLauncherController = "bee", BoogieBombController = "disco", PaintballGunController = "paint" }
    local fxConns, fxRemote = {}, nil

    local function scanRemote(r, into)
        local ok, cons = pcall(getconnections, r.OnClientEvent)
        if not ok or type(cons) ~= "table" then return end
        for _, c in ipairs(cons) do
            local fn = c.Function
            if type(fn) == "function" then
                local okS, src = pcall(debug.info, fn, "s")
                local kind = okS and FX_SRC[tostring(src):match("([^%.]+)$") or ""]
                if kind then
                    fxRemote = r
                    into[#into + 1] = { c = c, kind = kind }
                end
            end
        end
    end

    local function scanFx()
        if not net or type(getconnections) ~= "function" then return end
        local found = {}
        if fxRemote and fxRemote.Parent then
            scanRemote(fxRemote, found)
        else
            for _, r in ipairs(net:GetChildren()) do
                if r:IsA("RemoteEvent") then scanRemote(r, found) end
            end
        end
        fxConns = found
    end

    local function applyMute()
        for _, e in ipairs(fxConns) do
            local mute = iCollectProFx[e.kind]
            pcall(function() if mute then e.c:Disable() else e.c:Enable() end end)
        end
    end

    pcall(scanFx)
    applyMute()

    pcall(function()
        local presets = require(ReplicatedStorage.Shared.ShakePresets)
        local orig = rawget(presets, "__semiOrigBind") or presets.BindShakeToCamera
        presets.__semiOrigBind = orig
        presets.BindShakeToCamera = function(...)
            if iCollectProFx.disco then
                local ok, src = pcall(debug.info, 2, "s")
                if ok and tostring(src):find("BoogieBombController", 1, true) then
                    return function() end
                end
            end
            return orig(...)
        end
    end)

    local function undoBee()
        if charCtrl and charCtrl.Controls and charCtrl.originalMoveFunction then
            charCtrl.Controls.moveFunction = charCtrl.originalMoveFunction
        end
        for _, e in ipairs(Lighting:GetChildren()) do
            if e.Name == "BeeBlur" or (e:IsA("ColorCorrectionEffect") and e.Name == "ColorCorrection") then e:Destroy() end
        end
        local cam = Workspace.CurrentCamera
        if cam then cam.FieldOfView = 70 end
    end

    local discoUntil = 0
    local function discoOn() return iCollectProFx.disco and os.clock() < discoUntil end

    local function undoDisco()
        for _, e in ipairs(Lighting:GetChildren()) do
            if e.Name == "DiscoEffect" or (e:IsA("BlurEffect") and e.Name == "Blur") then e:Destroy() end
        end
        local cc = Lighting:FindFirstChild("ColorCCorrection")
        if cc then cc.Enabled = true end
        if boomSound and boomSound.IsPlaying then boomSound:Stop() end
    end

    local function onUseItem(kind)
        if kind == "Bee Attack" and iCollectProFx.bee then
            task.defer(undoBee)
            task.delay(0.1, undoBee)
        elseif kind == "Boogie" and iCollectProFx.disco then
            discoUntil = os.clock() + 10.5
            undoDisco()
            task.defer(undoDisco)
        end
    end

    local hooked = {}
    local function hookRemote(r)
        if not r or hooked[r] then return end
        hooked[r] = true
        local conn
        conn = r.OnClientEvent:Connect(function(kind)
            if not iCollectPro_ALIVE() then conn:Disconnect() return end
            onUseItem(kind)
        end)
    end
    hookRemote(fxRemote)
    hookRemote(net and net:FindFirstChild("RE/UseItem"))

    task.spawn(function()
        while iCollectPro_ALIVE() do
            task.wait(10)
            pcall(scanFx)
            applyMute()
            hookRemote(fxRemote)
        end
    end)

    do
        local lConn
        lConn = Lighting.ChildAdded:Connect(function(e)
            if not iCollectPro_ALIVE() then lConn:Disconnect() return end
            if discoOn() and (e.Name == "DiscoEffect" or (e:IsA("BlurEffect") and e.Name == "Blur")) then
                task.defer(undoDisco)
            end
        end)

        local BIND = "iCollectProSemiTPAntiDisco"
        pcall(RunService.UnbindFromRenderStep, RunService, BIND)
        RunService:BindToRenderStep(BIND, Enum.RenderPriority.Last.Value, function()
            if not iCollectPro_ALIVE() then pcall(RunService.UnbindFromRenderStep, RunService, BIND) return end
            if not discoOn() then return end
            local cam = Workspace.CurrentCamera
            if cam then cam.FieldOfView = defaultFov() end
            if boomSound and boomSound.IsPlaying then boomSound:Stop() end
        end)
    end

    local function unGummy()
        if not iCollectProFx.gummy then return end
        if LP:GetAttribute("BlockTools") then LP:SetAttribute("BlockTools", false) end
        local ch = LP.Character
        if ch and ch:GetAttribute("BackpackReady") == false then ch:SetAttribute("BackpackReady", true) end
        local g = Workspace:FindFirstChild("GummyBear")
        if g then pcall(function() g:Destroy() end) end
    end

    local gConn1, gConn2
    gConn1 = LP:GetAttributeChangedSignal("BlockTools"):Connect(function()
        if not iCollectPro_ALIVE() then gConn1:Disconnect() return end
        unGummy()
    end)
    gConn2 = Workspace.ChildAdded:Connect(function(c)
        if not iCollectPro_ALIVE() then gConn2:Disconnect() return end
        if c.Name == "GummyBear" and iCollectProFx.gummy then task.defer(unGummy) end
    end)

    function iCollectProAntiFx.setBee(on) iCollectProFx.bee = on and true or false; applyMute() end
    function iCollectProAntiFx.setDisco(on) iCollectProFx.disco = on and true or false; applyMute() end
    function iCollectProAntiFx.setGummy(on) iCollectProFx.gummy = on and true or false; unGummy() end
    function iCollectProAntiFx.setPaint(on) iCollectProFx.paint = on and true or false; applyMute() end
    function iCollectProAntiFx.useRemote() return fxRemote end
    iCollectPro.fx = iCollectProFx
    iCollectPro.cfg = HubConfig
    iCollectPro.antiDiscoTest = function() discoUntil = os.clock() + 10.5; undoDisco() end
    iCollectPro.antiFxState = function()
        local s = {}
        for _, e in ipairs(fxConns) do s[#s + 1] = e.kind .. "=" .. tostring(e.c.Enabled) end
        return (fxRemote and fxRemote.Name or "none"), s
    end
end

do
    local LP = player

    local webUsedAt = 0
    local function unWebOnce(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) then return end
        if LP:GetAttribute("Web") then LP:SetAttribute("Web", false) end
        if char:GetAttribute("Web") then char:SetAttribute("Web", false) end
        if LP:GetAttribute("BlockTools") then LP:SetAttribute("BlockTools", false) end
        local attach = hrp:FindFirstChild("WebTargetAttch")
        if attach then attach:Destroy() end
        local cut = 0
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                local ok, joints = pcall(part.GetJoints, part)
                for _, j in ipairs(ok and joints or {}) do
                    if not j:IsA("Motor6D") and not j:IsA("AnimationConstraint") then
                        local a, b
                        if j:IsA("Constraint") then
                            a = j.Attachment0 and j.Attachment0.Parent
                            b = j.Attachment1 and j.Attachment1.Parent
                        else
                            a, b = j.Part0, j.Part1
                        end
                        local out = (a and not a:IsDescendantOf(char)) or (b and not b:IsDescendantOf(char))
                            or not j:IsDescendantOf(char)
                        if out then cut = cut + 1 pcall(j.Destroy, j) end
                    end
                end
            elseif (part:IsA("RopeConstraint") or part:IsA("SpringConstraint")) then
                cut = cut + 1
                pcall(part.Destroy, part)
            end
        end
        local gb = Workspace:FindFirstChild("GummyBear")
        if gb and (gb.Position - hrp.Position).Magnitude < 12 then pcall(gb.Destroy, gb) end
        if hum.PlatformStand then hum.PlatformStand = false end
        local s = hum:GetState()
        if s == Enum.HumanoidStateType.Physics or s == Enum.HumanoidStateType.PlatformStanding
            or s == Enum.HumanoidStateType.FallingDown then
            pcall(hum.ChangeState, hum, Enum.HumanoidStateType.GettingUp)
        end
        return cut
    end

    local webbing = false
    local function unWeb(char)
        if not iCollectProFx.web or not char or webbing then return end
        if os.clock() - webUsedAt < 1.5 then return end
        webbing = true
        local t0, cuts = os.clock(), 0
        while iCollectPro_ALIVE() and os.clock() - t0 < 6 do
            local c = unWebOnce(char) or 0
            cuts = cuts + c
            local w = LP:GetAttribute("Web") or char:GetAttribute("Web")
            if not (w or c > 0) and os.clock() - t0 > 0.5 then break end
            RunService.Heartbeat:Wait()
        end
        webbing = false
        pcall(function() iCollectPro.log(string.format("ANTI WEBSLING: freed  (%d links cut, %.2fs)", cuts, os.clock() - t0)) end)
    end

    local function webHit(src)
        local v = src:GetAttribute("Web")
        if v ~= nil and v ~= false then task.spawn(unWeb, LP.Character) end
    end

    local webConns = {}
    local function hookWeb(char)
        for _, c in ipairs(webConns) do c:Disconnect() end
        webConns = { LP:GetAttributeChangedSignal("Web"):Connect(function() webHit(LP) end) }
        if char then
            table.insert(webConns, char:GetAttributeChangedSignal("Web"):Connect(function() webHit(char) end))
            local function ownTool(c)
                if c:IsA("Tool") and c.Name == "Web Slinger" then
                    table.insert(webConns, c.Activated:Connect(function() webUsedAt = os.clock() end))
                end
            end
            table.insert(webConns, char.ChildAdded:Connect(ownTool))
            local own = char:FindFirstChild("Web Slinger")
            if own then ownTool(own) end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                table.insert(webConns, hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
                    if hum.PlatformStand and (LP:GetAttribute("Web") or LP:GetAttribute("BlockTools")) then
                        task.spawn(unWeb, char)
                    end
                end))
            end
        end
    end
    hookWeb(LP.Character)
    local webCharConn
    webCharConn = LP.CharacterAdded:Connect(function(char)
        if not iCollectPro_ALIVE() then
            webCharConn:Disconnect()
            for _, c in ipairs(webConns) do c:Disconnect() end
            return
        end
        hookWeb(char)
    end)

    local SWAP_POTION = "Body Swap Potion"
    local threat, prevOthers, prevSelf, lastCounter = {}, {}, nil, 0

    local function myPotion()
        local ch, bp = LP.Character, LP:FindFirstChild("Backpack")
        return (ch and ch:FindFirstChild(SWAP_POTION)) or (bp and bp:FindFirstChild(SWAP_POTION))
    end

    local function swapBack(target, home)
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local potion = myPotion()
        local remote = iCollectProAntiFx.useRemote()
        if not (hum and potion and remote) or potion:GetAttribute("CooldownTime") then
            iCollectPro.log(string.format("SWAPPED by %s but can't swap back (potion=%s remote=%s cooldown=%s)",
                target.Name, tostring(potion ~= nil), tostring(remote ~= nil),
                tostring(potion and potion:GetAttribute("CooldownTime"))))
            return
        end
        local homePrompt = home and iCollectPro.enemyPromptAt and iCollectPro.enemyPromptAt(home)
        local homeCtx = homePrompt and iCollectProHold.startStealHold(homePrompt)
        iCollectPro.logT0 = os.clock()
        iCollectPro.log(string.format("---- SWAPPED by %s  home podium=%s  enabled=%s  hold banked=%s",
            target.Name, homePrompt and homePrompt:GetFullName():match("AnimalPodiums%.(%d+)") or "none",
            tostring(homePrompt and homePrompt.Enabled), tostring(homeCtx ~= nil and homeCtx ~= false)))
        local held = ch:FindFirstChildOfClass("Tool")
        pcall(function() hum:EquipTool(potion) end)
        local t0 = os.clock()
        while potion.Parent ~= ch and os.clock() - t0 < 0.5 do task.wait() end
        if potion.Parent == ch then
            local hrp = ch:FindFirstChild("HumanoidRootPart")
            local from = hrp and hrp.Position
            pcall(function() remote:FireServer(target) end)
            task.spawn(function()
                local t0 = os.clock()
                while hrp and hrp.Parent and from and (hrp.Position - from).Magnitude < 3 and os.clock() - t0 < 1.5 do
                    RunService.Heartbeat:Wait()
                end
                local moved = hrp and from and (hrp.Position - from).Magnitude or -1
                iCollectPro.log(string.format("swap-back landed=%s (moved %.1f)  off home %.1f  hold age %.2fs  prompt enabled=%s",
                    tostring(moved >= 3), moved, (hrp and home) and (hrp.Position - home).Magnitude or -1,
                    homeCtx and tick() - (homeCtx.holdBeganAt or 0) or -1, tostring(homePrompt and homePrompt.Enabled)))
                local lt = os.clock()
                local got = iCollectPro.grabUnderFeet and iCollectPro.grabUnderFeet(8, homePrompt, homeCtx or nil)
                iCollectPro.log(string.format("%s %.2fs after landing  (prompt enabled now=%s)", got and "GRABBED" or "NO GRAB",
                    os.clock() - lt, tostring(homePrompt and homePrompt.Enabled)))
            end)
        end
        task.wait(0.3)
        if held and held ~= potion and held.Parent then
            pcall(function() hum:EquipTool(held) end)
        else
            pcall(function() hum:UnequipTools() end)
        end
    end

    local swapConn, swapNext = nil, 0
    swapConn = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then swapConn:Disconnect() return end
        local hrp = iCollectProFx.swap and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then
            if prevSelf then prevSelf = nil; table.clear(prevOthers) end
            return
        end
        local now = tick()
        if now < swapNext then return end
        swapNext = now + 0.05
        local me = hrp.Position
        local others = {}
        for _, p in ipairs(Players:GetPlayers()) do
            local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if r then
                others[p] = r.Position
                local tool = p.Character:FindFirstChildOfClass("Tool")
                if tool and tool.Name == SWAP_POTION then threat[p] = now end
            end
        end
        if prevSelf and (me - prevSelf).Magnitude >= 3 and now - lastCounter >= 2 and not _G.iCollectPro_SemiTP_Busy then
            for p, was in pairs(prevOthers) do
                local nowPos = others[p]
                if nowPos and (me - was).Magnitude <= 6 and (nowPos - prevSelf).Magnitude <= 6
                    and threat[p] and now - threat[p] <= 6 then
                    lastCounter = now
                    threat[p] = nil
                    task.spawn(swapBack, p, prevSelf)
                    break
                end
            end
        end
        prevSelf, prevOthers = me, others
    end)

    local held = false
    local function hop()
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        hrp.Velocity = Vector3.new(hrp.Velocity.X, hum.JumpPower or 50, hrp.Velocity.Z)
    end
    local jumpConns = {}
    jumpConns[1] = UserInputService.JumpRequest:Connect(function()
        if iCollectProFx.infJump then hop() end
    end)
    jumpConns[2] = UserInputService.InputBegan:Connect(function(i, g)
        if not g and i.KeyCode == Enum.KeyCode.Space then held = true end
    end)
    jumpConns[3] = UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space then held = false end
    end)
    jumpConns[4] = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then
            for _, c in ipairs(jumpConns) do c:Disconnect() end
            return
        end
        if held and iCollectProFx.infJump then hop() end
    end)

    local function unJumpKill(ch)
        if type(getconnections) ~= "function" then return end
        local hum = ch and ch:WaitForChild("Humanoid", 10)
        if not hum then return end
        for _ = 1, 20 do
            local found = false
            for _, c in ipairs(getconnections(hum.StateChanged)) do
                local f = c.Function
                local src = type(f) == "function" and (debug.info(f, "s") or "") or ""
                if src:find("CharacterController", 1, true) then
                    found = true
                    pcall(function() c:Disable() end)
                end
            end
            if found then
                pcall(function() iCollectPro.log("jump-count kill switched off") end)
                return
            end
            task.wait(0.25)
        end
    end
    task.spawn(unJumpKill, LP.Character)
    table.insert(jumpConns, LP.CharacterAdded:Connect(function(ch) task.spawn(unJumpKill, ch) end))

    function iCollectProAntiFx.setWeb(on) iCollectProFx.web = on and true or false; if iCollectProFx.web then unWeb(LP.Character) end end
    function iCollectProAntiFx.setSwap(on) iCollectProFx.swap = on and true or false end
    function iCollectProAntiFx.setInfJump(on) iCollectProFx.infJump = on and true or false end
end

do
    local LP = player

    local function canFight()
        local ch = LP.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) or hum.Health <= 0 then return nil end
        if LP:GetAttribute("Stealing") or _G.iCollectPro_SemiTP_Busy then return nil end
        return ch, hum, hrp
    end

    local function swing(ch, hum)
        local bat = ch:FindFirstChild("Bat") or (LP:FindFirstChild("Backpack") and LP.Backpack:FindFirstChild("Bat"))
        if not bat then return false end
        if bat.Parent ~= ch then pcall(function() hum:EquipTool(bat) end) end
        if bat.Parent == ch and bat.Enabled ~= false then pcall(function() bat:Activate() end) end
        return true
    end

    local function enemySentry(p)
        if not p:IsA("BasePart") then return false end
        local id = p.Name:match("^Sentry_(%d+)$") or p.Name:match("^SentryCandy_(%d+)$")
        return id ~= nil and id ~= tostring(LP.UserId)
    end

    local function enemyDoge(m)
        if not m:IsA("Model") then return false end
        local who = m.Name:match("^PlayerName_(.+)_Doge$")
        if not who or who == LP.Name or who == LP.DisplayName then return false end
        local h = m:FindFirstChildOfClass("Humanoid")
        return h ~= nil and h.Health > 0
    end

    local busyDefence = false
    local function breakIt(obj, isDoge)
        if busyDefence then return end
        busyDefence = true
        task.spawn(function()
            local limit = os.clock() + (isDoge and 10 or 3)
            while iCollectPro_ALIVE() and obj.Parent and os.clock() < limit do
                if isDoge and not (iCollectProFx.doge and enemyDoge(obj)) then break end
                if not isDoge and not iCollectProFx.sentry then break end
                local ch, hum, hrp = canFight()
                if not ch then break end
                local part = isDoge and (obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")) or obj
                if not part or (part.Position - hrp.Position).Magnitude > 220 then break end
                local look = hrp.CFrame.LookVector
                local spot = hrp.Position + look * 4 + Vector3.new(0, isDoge and 0 or 1.2, 0)
                pcall(function()
                    for _, d in ipairs((isDoge and obj or part):GetDescendants()) do
                        if d:IsA("BasePart") then d.CanCollide = false end
                    end
                    part.CanCollide = false
                    part.AssemblyLinearVelocity = Vector3.zero
                    if isDoge then obj:PivotTo(CFrame.lookAt(spot, spot + look)) else part.CFrame = CFrame.lookAt(spot, spot + look) end
                end)
                if not swing(ch, hum) then break end
                task.wait(isDoge and 0.1 or 0.12)
            end
            busyDefence = false
        end)
    end

    local function scanDefences()
        for _, c in ipairs(Workspace:GetChildren()) do
            if iCollectProFx.sentry and enemySentry(c) then breakIt(c, false)
            elseif iCollectProFx.doge and enemyDoge(c) then breakIt(c, true) end
        end
    end
    local defConn
    defConn = Workspace.ChildAdded:Connect(function(c)
        if not iCollectPro_ALIVE() then defConn:Disconnect() return end
        task.delay(0.3, function()
            if iCollectProFx.sentry and enemySentry(c) then breakIt(c, false)
            elseif iCollectProFx.doge and enemyDoge(c) then breakIt(c, true) end
        end)
    end)
    task.spawn(function()
        while iCollectPro_ALIVE() do
            if iCollectProFx.sentry or iCollectProFx.doge then pcall(scanDefences) end
            task.wait(1)
        end
    end)

    local AIM_ITEMS = {}
    for _, n in ipairs({ "Blackhole Bomb", "BlowDryer", "Candy Launcher", "Candycane Bow", "Christmas Launcher",
        "Freeze Ray", "Gravity Gun", "Hunter Crossbow", "Jelly Gun", "Laser Cape", "Lava Blaster", "Paintball Gun",
        "Pumpkin Launcher", "Radioactive Airstrike", "Sabuk Bepak", "Sandal Jepit", "Slingshot", "Snowball",
        "Snowball Cannon", "Summer Soaker", "Super-GLS33", "Taser Gun", "Tripple Plungers", "Web Slinger",
        "Wormhole Tunneler", "Zombie Blaster" }) do AIM_ITEMS[n] = true end
    local mouse
    pcall(function() mouse = require(ReplicatedStorage.Packages.PlayerMouse) end)
    local aimAt, lastScan, lastShot = nil, 0, 0
    local function aimStep()
        if not (iCollectProFx.aim and mouse) then aimAt = nil return end
        local ch = LP.Character
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        local tool = ch and ch:FindFirstChildOfClass("Tool")
        if not (hrp and tool and AIM_ITEMS[tool.Name]) then aimAt = nil return end
        if not aimAt or not aimAt.Parent or os.clock() - lastScan >= 0.05 then
            lastScan = os.clock()
            local best, bestD = nil, math.huge
            for _, p in ipairs(Players:GetPlayers()) do
                local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                local h = r and p.Character:FindFirstChildOfClass("Humanoid")
                if r and h and h.Health > 0 then
                    local d = (r.Position - hrp.Position).Magnitude
                    if d < bestD then best, bestD = r, d end
                end
            end
            aimAt = best
        end
        if aimAt then
            pcall(function() mouse.Hit = CFrame.new(aimAt.Position); mouse.Target = aimAt end)
            if iCollectProFx.spam and os.clock() - lastShot >= 0.1 then
                lastShot = os.clock()
                pcall(function() tool:Activate() end)
            end
        end
    end
    local aimConn1, aimConn2
    aimConn1 = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then aimConn1:Disconnect() return end
        aimStep()
    end)
    aimConn2 = (RunService.PreRender or RunService.RenderStepped):Connect(function()
        if not iCollectPro_ALIVE() then aimConn2:Disconnect() return end
        if aimAt and aimAt.Parent and mouse then
            pcall(function() mouse.Hit = CFrame.new(aimAt.Position); mouse.Target = aimAt end)
        end
    end)

    pcall(function()
        for _, d in ipairs(Workspace:GetChildren()) do
            if d.Name == "iCollectPro_SemiTP_ServerGhost" then d:Destroy() end
        end
    end)
    local ghost = Instance.new("Model")
    ghost.Name = "iCollectPro_SemiTP_ServerGhost"
    local ghostHl = Instance.new("Highlight")
    ghostHl.FillColor = T.FILL2
    ghostHl.FillTransparency = 0.82
    ghostHl.OutlineColor = T.FILL2
    ghostHl.OutlineTransparency = 0
    ghostHl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    ghostHl.Adornee = ghost
    ghostHl.Parent = ghost
    local ghostSrc, ghostParts, ghostCFs, ghostChar, ghostDirty = {}, {}, {}, nil, true
    local anchorPart, charConns = nil, {}
    local KEEP = { SpecialMesh = true, Decal = true, SurfaceAppearance = true }
    local function buildGhost(char)
        for _, p in ipairs(ghostParts) do p:Destroy() end
        for _, c in ipairs(charConns) do c:Disconnect() end
        table.clear(ghostSrc); table.clear(ghostParts); table.clear(ghostCFs); table.clear(charConns)
        ghostChar, ghostDirty, anchorPart = char, false, nil
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, src in ipairs(char:GetDescendants()) do
            if src:IsA("BasePart") and src ~= hrp and src.Transparency < 1 and not src:FindFirstAncestorOfClass("Tool") then
                local arch = src.Archivable
                src.Archivable = true
                local ok, p = pcall(function() return src:Clone() end)
                src.Archivable = arch
                if ok and p then
                    for _, d in ipairs(p:GetChildren()) do
                        if not KEEP[d.ClassName] then d:Destroy() end
                    end
                    p.Anchored, p.CanCollide, p.CanQuery, p.CanTouch, p.CastShadow = true, false, false, false, false
                    p.Massless = true
                    p.Transparency = math.max(src.Transparency, 0.72)
                    p.Parent = ghost
                    ghostSrc[#ghostSrc + 1] = src
                    ghostParts[#ghostParts + 1] = p
                    ghostCFs[#ghostCFs + 1] = src.CFrame
                    if src.Name == "Head" then anchorPart = p end
                end
            end
        end
        anchorPart = anchorPart or ghostParts[1]
        local function mark(d)
            if d:IsA("BasePart") and not d:FindFirstAncestorOfClass("Tool") then ghostDirty = true end
        end
        charConns[1] = char.DescendantAdded:Connect(mark)
        charConns[2] = char.DescendantRemoving:Connect(mark)
    end

    local ghostTag = Instance.new("BillboardGui")
    ghostTag.Size = UDim2.fromOffset(150, 30)
    ghostTag.StudsOffset = Vector3.new(0, 2.6, 0)
    ghostTag.AlwaysOnTop = true
    ghostTag.LightInfluence = 0
    ghostTag.MaxDistance = 100000
    ghostTag.Parent = ghost
    local tagPill = Instance.new("Frame")
    tagPill.Size = UDim2.fromScale(1, 1)
    tagPill.BackgroundColor3 = T.BG
    tagPill.BorderSizePixel = 0
    tagPill.Parent = ghostTag
    corner(tagPill, 15)
    local tagStroke = stroke(tagPill, T.ACCENT, 2, 0.1)
    gradient(tagPill, T.SURF2, T.BG, 90)
    local ghostLbl = Instance.new("TextLabel")
    ghostLbl.Size = UDim2.new(1, -12, 1, 0)
    ghostLbl.Position = UDim2.fromOffset(6, 0)
    ghostLbl.BackgroundTransparency = 1
    ghostLbl.Font = Enum.Font.GothamBlack
    ghostLbl.TextSize = 13
    ghostLbl.TextColor3 = T.TEXT
    ghostLbl.TextStrokeTransparency = 0.6
    ghostLbl.Parent = tagPill
    local COL_OK, COL_WARN, COL_BAD = Color3.fromRGB(110, 235, 160), Color3.fromRGB(255, 205, 90), Color3.fromRGB(255, 110, 130)
    local trail, ping, lastPingRead, lastTagMs = {}, 0.05, 0, -1
    local recConn, drawConn
    recConn = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then recConn:Disconnect() return end
        local hrp = iCollectProFx.ghost and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if not hrp then if #trail > 0 then table.clear(trail) end return end
        local now = os.clock()
        local pose = {}
        if LP.Character == ghostChar then
            local rootCF = hrp.CFrame
            for i, src in ipairs(ghostSrc) do pose[i] = rootCF:ToObjectSpace(src.CFrame) end
        end
        trail[#trail + 1] = { t = now, cf = hrp.CFrame, pose = pose }
        while #trail > 2 and now - trail[1].t > 1.5 do table.remove(trail, 1) end
        if now - lastPingRead > 0.5 then
            lastPingRead = now
            pcall(function() ping = LP:GetNetworkPing() end)
        end
    end)
    drawConn = (RunService.PreRender or RunService.RenderStepped):Connect(function()
        if not iCollectPro_ALIVE() then
            drawConn:Disconnect()
            for _, c in ipairs(charConns) do c:Disconnect() end
            ghost:Destroy()
            return
        end
        if not iCollectProFx.ghost or #trail == 0 then
            if ghost.Parent then ghost.Parent = nil end
            return
        end
        local at = os.clock() - (ping + 1 / 60)
        local cf = trail[1].cf
        local sa, sb, alpha = trail[1], trail[1], 0
        for i = #trail, 2, -1 do
            local a, b = trail[i - 1], trail[i]
            if a.t <= at then
                local span = b.t - a.t
                alpha = span > 0 and math.clamp((at - a.t) / span, 0, 1) or 1
                cf = a.cf:Lerp(b.cf, alpha)
                sa, sb = a, b
                break
            end
        end
        local char = LP.Character
        if char ~= ghostChar or ghostDirty or #ghostParts == 0 then
            buildGhost(char)
            table.clear(trail)
            return
        end
        if #ghostParts == 0 then return end
        local pa, pb = sa.pose, sb.pose
        for i = 1, #ghostParts do
            local oa, ob = pa[i], pb[i]
            if oa and ob then
                ghostCFs[i] = cf * oa:Lerp(ob, alpha)
            elseif oa or ob then
                ghostCFs[i] = cf * (oa or ob)
            end
        end
        Workspace:BulkMoveTo(ghostParts, ghostCFs, Enum.BulkMoveMode.FireCFrameChanged)
        if anchorPart and ghostTag.Adornee ~= anchorPart then ghostTag.Adornee = anchorPart end

        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local off = hrp and (hrp.Position - cf.Position).Magnitude or 0
        local col = off < 2 and COL_OK or (off < 6 and COL_WARN or COL_BAD)
        local ms = math.floor(ping * 1000 + 0.5)
        local key = ms * 1000 + math.floor(off * 10)
        if key ~= lastTagMs then
            lastTagMs = key
            ghostLbl.Text = string.format("SERVER  %dms  ·  %.1f", ms, off)
        end
        tagStroke.Color = col
        ghostLbl.TextColor3 = col
        ghostHl.OutlineColor = col
        if ghost.Parent ~= Workspace then ghost.Parent = Workspace end
    end)

    local espFolder = Instance.new("ScreenGui")
    espFolder.Name = "iCollectPro_SemiTP_ESP"
    espFolder.ResetOnSpawn = false
    espFolder.Parent = safeGuiTarget
    local esp = {}
    local function clearEsp(p)
        local e = esp[p]
        if e then pcall(function() e.hl:Destroy(); e.tag:Destroy() end) esp[p] = nil end
    end
    task.spawn(function()
        while iCollectPro_ALIVE() do
            if not iCollectProFx.esp and next(esp) == nil then task.wait(0.5) continue end
            local me = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            for _, p in ipairs(Players:GetPlayers()) do
                local ch = p.Character
                local head = ch and ch:FindFirstChild("Head")
                local r = ch and ch:FindFirstChild("HumanoidRootPart")
                if iCollectProFx.esp and p ~= LP and head and r then
                    local e = esp[p]
                    if not e or e.char ~= ch then
                        clearEsp(p)
                        local hl = Instance.new("Highlight")
                        hl.FillColor = T.ACCENT2
                        hl.OutlineColor = T.FILL2
                        hl.FillTransparency = 0.75
                        hl.OutlineTransparency = 0
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Adornee = ch
                        hl.Parent = espFolder
                        local tag = Instance.new("BillboardGui")
                        tag.Size = UDim2.fromOffset(160, 16)
                        tag.StudsOffset = Vector3.new(0, -3.6, 0)
                        tag.AlwaysOnTop = true
                        tag.MaxDistance = 100000
                        tag.Adornee = r
                        tag.Parent = espFolder
                        local l = Instance.new("TextLabel")
                        l.Size = UDim2.fromScale(1, 1)
                        l.BackgroundTransparency = 1
                        l.Font = Enum.Font.GothamBold
                        l.TextSize = 11
                        l.TextColor3 = T.TEXT
                        l.TextStrokeTransparency = 0.4
                        l.Parent = tag
                        e = { hl = hl, tag = tag, lbl = l, char = ch }
                        esp[p] = e
                    end
                    local dist = me and math.floor((r.Position - me.Position).Magnitude) or 0
                    if e.dist ~= dist then
                        e.dist = dist
                        e.lbl.Text = p.Name .. "  " .. dist .. "m"
                    end
                else
                    clearEsp(p)
                end
            end
            for p in pairs(esp) do
                if not p.Parent then clearEsp(p) end
            end
            task.wait(0.2)
        end
        espFolder:Destroy()
    end)

    function iCollectProAntiFx.setSentry(on) iCollectProFx.sentry = on and true or false end
    function iCollectProAntiFx.setDoge(on) iCollectProFx.doge = on and true or false end
    function iCollectProAntiFx.setAim(on) iCollectProFx.aim = on and true or false end
    function iCollectProAntiFx.setSpam(on) iCollectProFx.spam = on and true or false end
    function iCollectProAntiFx.setGhost(on) iCollectProFx.ghost = on and true or false end
    function iCollectProAntiFx.setEsp(on) iCollectProFx.esp = on and true or false end
end

function iCollectPro.activate()
    task.spawn(function()
        setFFlags()
        _G.iCollectPro_SemiTP_InstaReset()
    end)
end

local AllowDisallowGui = Instance.new("ScreenGui")
AllowDisallowGui.Name = "iCollectPro_SemiTP_Allow"
AllowDisallowGui.ResetOnSpawn = false
AllowDisallowGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
AllowDisallowGui.Parent = safeGuiTarget

local MainAllowBtn = Instance.new("TextButton")
MainAllowBtn.Size = UDim2.new(0, 100, 0, 34)
MainAllowBtn.Position = UDim2.new(0.65, 36, 0, 15)
MainAllowBtn.BackgroundColor3 = T.SURF
MainAllowBtn.AutoButtonColor = false
MainAllowBtn.BorderSizePixel = 0
MainAllowBtn.Text = "WAITING"
MainAllowBtn.TextColor3 = T.TEXT
MainAllowBtn.Font = Enum.Font.GothamBlack
MainAllowBtn.TextSize = 12
MainAllowBtn.ZIndex = 20
MainAllowBtn.Parent = AllowDisallowGui
corner(MainAllowBtn, 11)
stroke(MainAllowBtn, T.STROKE, 1.2, 0.35)
addShadow(MainAllowBtn, 20)
addHover(MainAllowBtn, T.SURF, T.HOVER)
restorePos(MainAllowBtn, "allow")
makeDraggable(MainAllowBtn, MainAllowBtn, rememberPos(MainAllowBtn, "allow"))

local activeHubs = {}
local function createFloatingHub(parent, statusText)
    if activeHubs[parent] then return end
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.fromOffset(96, 20)
    billboard.Adornee = parent
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
    billboard.Parent = AllowDisallowGui

    local HubFrame = Instance.new("Frame")
    HubFrame.Name = "Frame"
    HubFrame.Size = UDim2.new(1, 0, 1, 0)
    HubFrame.BackgroundColor3 = T.BG
    HubFrame.BackgroundTransparency = 0.12
    HubFrame.BorderSizePixel = 0
    HubFrame.Parent = billboard
    corner(HubFrame, 10)
    gradient(HubFrame, T.SURF2, T.BG, 90)
    stroke(HubFrame, T.STROKE, 1.5, 0.1)

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "TextLabel"
    statusLabel.Size = UDim2.new(1, -8, 1, 0)
    statusLabel.Position = UDim2.fromOffset(4, 0)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = statusText
    statusLabel.TextColor3 = T.TEXT
    statusLabel.TextSize = 10
    statusLabel.Font = Enum.Font.GothamBlack
    statusLabel.Parent = HubFrame

    activeHubs[parent] = billboard
end

task.spawn(function()
    while task.wait(0.5) do
        if not iCollectPro_ALIVE() then return end
        local currentObjects = {}
        local myBase = findMyBase()
        local nearestPrompt = nil
        local minDist = math.huge

        for desc in pairs(iCollectProUI.friendPrompts) do
            if desc.Parent then
                local isDisallow = string.find(desc.ObjectText, "Disallow Friends", 1, true)
                local isAllow = not isDisallow and string.find(desc.ObjectText, "Allow Friends", 1, true)
                if isAllow or isDisallow then
                    local part = iCollectProUI.promptPart(desc)
                    if part then
                        currentObjects[part] = true
                        local status = isAllow and "FRIENDS OFF" or "FRIENDS ON"
                        if not activeHubs[part] then createFloatingHub(part, status) end
                        local frame = activeHubs[part].Frame
                        local label = frame.TextLabel
                        if label.Text ~= status then label.Text = status end
                        local col = isAllow and Color3.fromRGB(255, 110, 130) or Color3.fromRGB(110, 235, 160)
                        label.TextColor3 = col
                        local st = frame:FindFirstChildOfClass("UIStroke")
                        if st then st.Color = col end

                        if myBase and part:IsDescendantOf(myBase) then
                            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                            if hrp then
                                local dist = (hrp.Position - part.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    nearestPrompt = desc
                                end
                            end
                        end
                    end
                end
            end
        end

        MainAllowBtn.Text = nearestPrompt and (string.find(nearestPrompt.ObjectText, "Disallow") and "DISALLOW" or "ALLOW") or "NO BASE"

        for part, bbg in pairs(activeHubs) do
            if not currentObjects[part] then
                bbg:Destroy()
                activeHubs[part] = nil
            end
        end
    end
end)

MainAllowBtn.MouseButton1Click:Connect(function()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    local myBase = findMyBase()
    local target = nil
    local minDist = math.huge

    for desc in pairs(iCollectProUI.friendPrompts) do
        if desc.Parent then
            local part = iCollectProUI.promptPart(desc)
            if part and hrp and myBase and part:IsDescendantOf(myBase) then
                local dist = (hrp.Position - part.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    target = desc
                end
            end
        end
    end
    if target then fireproximityprompt(target) end
end)

local ProgressGui = Instance.new("ScreenGui")
ProgressGui.Name = "iCollectPro_SemiTP_Progress"
ProgressGui.ResetOnSpawn = false
ProgressGui.IgnoreGuiInset = true
ProgressGui.DisplayOrder = 998
ProgressGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ProgressGui.Parent = safeGuiTarget

local PBarMain = Instance.new("Frame")
PBarMain.AnchorPoint = Vector2.new(0.5, 1)
PBarMain.Size = UDim2.new(0, 230, 0, 46)
PBarMain.Position = UDim2.new(0.5, 0, 1, -160)
PBarMain.BackgroundColor3 = T.SURF
PBarMain.BackgroundTransparency = 0.02
PBarMain.BorderSizePixel = 0
PBarMain.ZIndex = 70
PBarMain.Parent = ProgressGui
corner(PBarMain, 12)
stroke(PBarMain, T.STROKE, 1, 0.35)
stroke(PBarMain, T.ACCENT, 3, 0.84)
addShadow(PBarMain, 20)
restorePos(PBarMain, "progress")
makeDraggable(PBarMain, PBarMain, rememberPos(PBarMain, "progress"))

local PBarTitle = Instance.new("TextLabel")
PBarTitle.Size = UDim2.new(1, -12, 0, 13)
PBarTitle.Position = UDim2.fromOffset(6, 3)
PBarTitle.BackgroundTransparency = 1
PBarTitle.Font = Enum.Font.GothamBold
PBarTitle.TextSize = 11
PBarTitle.TextColor3 = T.TEXT
PBarTitle.Text = "SEMI TP"
PBarTitle.ZIndex = 72
iCollectProUI.fit(PBarTitle, 11)
PBarTitle.Parent = PBarMain

local statusStamp = 0
setStealStatus = function(text, ok)
    local stamp = os.clock()
    statusStamp = stamp
    PBarTitle.Text = text
    PBarTitle.TextColor3 = (ok == true and Color3.fromRGB(110, 235, 160))
        or (ok == false and Color3.fromRGB(255, 110, 130))
        or T.TEXT
    if ok ~= nil then
        task.delay(4, function()
            if statusStamp == stamp and PBarTitle.Parent then
                PBarTitle.Text = "SEMI TP"
                PBarTitle.TextColor3 = T.TEXT
            end
        end)
    end
end

local PBarTrack = Instance.new("Frame")
PBarTrack.Size = UDim2.new(1, -10, 0, 18)
PBarTrack.Position = UDim2.fromOffset(5, 18)
PBarTrack.BackgroundColor3 = T.TRACK
PBarTrack.BorderSizePixel = 0
PBarTrack.ZIndex = 72
PBarTrack.Parent = PBarMain
corner(PBarTrack, 8)
stroke(PBarTrack, T.STROKE, 1, 0.55)

local PBarInner = Instance.new("Frame")
PBarInner.Size = UDim2.new(1, -2, 1, -2)
PBarInner.Position = UDim2.fromOffset(1, 1)
PBarInner.BackgroundColor3 = T.TRACK2
PBarInner.BackgroundTransparency = 0.15
PBarInner.BorderSizePixel = 0
PBarInner.ZIndex = 72
PBarInner.Parent = PBarTrack
corner(PBarInner, 7)

progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0)
progressFill.BackgroundColor3 = T.FILL1
progressFill.BorderSizePixel = 0
progressFill.ZIndex = 73
progressFill.Parent = PBarTrack
corner(progressFill, 8)
gradient(progressFill, T.FILL1, T.FILL2)
stroke(progressFill, Color3.fromRGB(205, 160, 255), 1, 0.45)

percentLabel = Instance.new("TextLabel")
percentLabel.Size = UDim2.new(1, 0, 1, 0)
percentLabel.BackgroundTransparency = 1
percentLabel.Font = Enum.Font.GothamBold
percentLabel.TextSize = 12
percentLabel.TextColor3 = T.TEXT
percentLabel.TextStrokeTransparency = 0.7
percentLabel.Text = "0%"
percentLabel.ZIndex = 74
percentLabel.Parent = PBarTrack

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "iCollectPro_SemiTP"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = safeGuiTarget

local panelWidth = IsMobile and 276 or 262

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, panelWidth, 0, 0)
MainFrame.AutomaticSize = Enum.AutomaticSize.Y
MainFrame.AnchorPoint = Vector2.new(1, 0)
MainFrame.Position = IsMobile and UDim2.new(0.88, 0, 0.05, 0) or UDim2.new(0.84, 0, 0.04, 0)
MainFrame.BackgroundColor3 = T.BG
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.ZIndex = 100
MainFrame.Parent = ScreenGui
corner(MainFrame, 18)
stroke(MainFrame, T.STROKE, 1.2, 0.4)
addShadow(MainFrame)

local MainPad = Instance.new("UIPadding")
MainPad.PaddingBottom = UDim.new(0, 10)
MainPad.Parent = MainFrame

local HeaderFrame = Instance.new("Frame")
HeaderFrame.Size = UDim2.new(1, 0, 0, 36)
HeaderFrame.BackgroundTransparency = 1
HeaderFrame.ZIndex = 101
HeaderFrame.Parent = MainFrame
restorePos(MainFrame, "main")
makeDraggable(HeaderFrame, MainFrame, rememberPos(MainFrame, "main"))

local TitleText = Instance.new("TextLabel")
TitleText.Size = UDim2.new(1, -28, 0, 22)
TitleText.Position = UDim2.new(0, 14, 0, 7)
TitleText.BackgroundTransparency = 1
TitleText.Text = "SEMI TP"
TitleText.Font = Enum.Font.GothamBlack
TitleText.TextSize = 18
TitleText.TextColor3 = T.TEXT
TitleText.ZIndex = 102
TitleText.Parent = HeaderFrame

local TitleRule = Instance.new("Frame")
TitleRule.AnchorPoint = Vector2.new(0.5, 0)
TitleRule.Position = UDim2.new(0.5, 0, 0, 32)
TitleRule.Size = UDim2.new(0, 124, 0, 1)
TitleRule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TitleRule.BackgroundTransparency = 0.15
TitleRule.BorderSizePixel = 0
TitleRule.ZIndex = 101
TitleRule.Parent = MainFrame

local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(1, -20, 0, 28)
TabContainer.Position = UDim2.fromOffset(10, 42)
TabContainer.BackgroundColor3 = T.SURF
TabContainer.BorderSizePixel = 0
TabContainer.ZIndex = 101
TabContainer.Parent = MainFrame
corner(TabContainer, 10)
stroke(TabContainer, T.STROKE, 1, 0.48)

local TabPad = Instance.new("UIPadding")
TabPad.PaddingLeft, TabPad.PaddingRight = UDim.new(0, 3), UDim.new(0, 3)
TabPad.PaddingTop, TabPad.PaddingBottom = UDim.new(0, 3), UDim.new(0, 3)
TabPad.Parent = TabContainer

local TabList = Instance.new("UIListLayout", TabContainer)
TabList.FillDirection = Enum.FillDirection.Horizontal
TabList.SortOrder = Enum.SortOrder.LayoutOrder
TabList.Padding = UDim.new(0, 4)

local function createTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / 6, -4, 1, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.LayoutOrder = order
    btn.ZIndex = 103
    btn.Parent = TabContainer

    local pill = Instance.new("Frame")
    pill.Name = "Pill"
    pill.Size = UDim2.new(1, 0, 1, 0)
    pill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    pill.BackgroundTransparency = 1
    pill.BorderSizePixel = 0
    pill.ZIndex = 103
    pill.Parent = btn
    corner(pill, 8)
    gradient(pill, T.FILL1, T.ACCENT2, 90)

    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = T.DIM
    label.Font = Enum.Font.GothamBold
    label.TextSize = 10
    iCollectProUI.fit(label, 10)
    label.ZIndex = 104
    label.Parent = btn
    return btn
end

local MainTabBtn = createTabButton("Main", 1)
local UtilsTabBtn = createTabButton("Steal", 2)
iCollectProUI.tabBtns = { Main = MainTabBtn, Steal = UtilsTabBtn, Protect = createTabButton("Anti", 3),
    Extras = createTabButton("Visual", 4), Move = createTabButton("Move", 5), Misc = createTabButton("Misc", 6) }

local ContentCard = Instance.new("Frame")
ContentCard.AutomaticSize = Enum.AutomaticSize.Y
ContentCard.Size = UDim2.new(1, -20, 0, 0)
ContentCard.Position = UDim2.fromOffset(10, 78)
ContentCard.BackgroundColor3 = T.SURF
ContentCard.BorderSizePixel = 0
ContentCard.ZIndex = 101
ContentCard.Parent = MainFrame
corner(ContentCard, 16)
stroke(ContentCard, T.STROKE, 1, 0.48)

local ContentLayout = Instance.new("Frame")
ContentLayout.AutomaticSize = Enum.AutomaticSize.Y
ContentLayout.Size = UDim2.new(1, -8, 0, 0)
ContentLayout.Position = UDim2.fromOffset(4, 4)
ContentLayout.BackgroundTransparency = 1
ContentLayout.ZIndex = 102
ContentLayout.Parent = ContentCard

local ContentPad = Instance.new("UIPadding")
ContentPad.PaddingBottom = UDim.new(0, 8)
ContentPad.Parent = ContentCard

local List = Instance.new("UIListLayout", ContentLayout)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Padding = UDim.new(0, 6)

local function createRowFrame(height, order)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, math.max(height, 30))
    card.BackgroundColor3 = T.SURF2
    card.BackgroundTransparency = 0.02
    card.BorderSizePixel = 0
    card.LayoutOrder = order or 1
    card.ZIndex = 103
    card.Parent = ContentLayout
    corner(card, 11)
    local rowStroke = stroke(card, T.STROKE, 1, 0.52)
    addHover(card, T.SURF2, T.HOVER, rowStroke)
    return card
end

local function rowLabel(parent, text, widthScale)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(widthScale or 0.55, 0, 1, 0)
    lbl.Position = UDim2.fromOffset(12, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = T.TEXT
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    iCollectProUI.fit(lbl, 12)
    lbl.ZIndex = 104
    lbl.Parent = parent
    return lbl
end

local function pillButton(parent, width, text)
    local btn = Instance.new("TextButton")
    btn.AutoButtonColor = false
    btn.Size = UDim2.fromOffset(width, 22)
    btn.Position = UDim2.new(1, -(width + 10), 0.5, -11)
    btn.BackgroundColor3 = T.OFF_BG
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = T.TEXT
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    iCollectProUI.fit(btn, 11)
    btn.ZIndex = 104
    btn.Parent = parent
    corner(btn, 7)
    local s = stroke(btn, T.STROKE, 1, 0.55)
    btn.MouseEnter:Connect(function() tween(s, 0.14, { Transparency = 0.12 }) end)
    btn.MouseLeave:Connect(function() tween(s, 0.14, { Transparency = 0.55 }) end)
    return btn, s
end

local function createModernToggle(parentCard, textLabel, initialState, onClick)
    rowLabel(parentCard, textLabel, 0.6)

    local btn = Instance.new("TextButton")
    btn.AutoButtonColor = false
    btn.Size = UDim2.fromOffset(62, 22)
    btn.Position = UDim2.new(1, -70, 0.5, -11)
    btn.BackgroundColor3 = T.OFF_BG
    btn.BorderSizePixel = 0
    btn.Text = ""
    btn.ZIndex = 104
    btn.Parent = parentCard
    corner(btn, 7)
    local btnStroke = stroke(btn, T.STROKE, 1, 0.55)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(1, 0, 1, 0)
    knob.BackgroundTransparency = 1
    knob.BorderSizePixel = 0
    knob.ZIndex = 104
    knob.Parent = btn
    corner(knob, 7)
    gradient(knob, T.GREEN1, T.GREEN2)

    local stateLabel = Instance.new("TextLabel")
    stateLabel.BackgroundTransparency = 1
    stateLabel.Size = UDim2.fromScale(1, 1)
    stateLabel.Font = Enum.Font.GothamBold
    stateLabel.TextSize = 11
    stateLabel.ZIndex = 105
    stateLabel.Parent = btn

    local state = initialState and true or false
    local function paint()
        if state then
            btn.BackgroundColor3 = T.GREEN1
            knob.BackgroundTransparency = 0
            stateLabel.Text = "ON"
            stateLabel.TextColor3 = T.ON_TEXT
            btnStroke.Color = T.GREEN_STROKE
            btnStroke.Transparency = 0.22
        else
            btn.BackgroundColor3 = T.OFF_BG
            knob.BackgroundTransparency = 1
            stateLabel.Text = "OFF"
            stateLabel.TextColor3 = T.OFF_TEXT
            btnStroke.Color = T.STROKE
            btnStroke.Transparency = 0.55
        end
    end
    paint()

    btn.MouseButton1Click:Connect(function()
        state = not state
        paint()
        onClick(state)
    end)
    return btn, paint
end

local function actionButton(parentCard, text, primary)
    local bg
    if primary then
        bg = Instance.new("Frame")
        bg.Size = UDim2.new(1, 0, 1, 0)
        bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        bg.BorderSizePixel = 0
        bg.ZIndex = 104
        bg.Parent = parentCard
        corner(bg, 11)
        gradient(bg, T.FILL1, T.ACCENT2, 90)
        stroke(bg, Color3.fromRGB(205, 160, 255), 1, 0.45)
    end
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.AutoButtonColor = false
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextStrokeTransparency = primary and 0.6 or 1
    btn.Font = primary and Enum.Font.GothamBlack or Enum.Font.GothamBold
    btn.TextSize = primary and 14 or 12
    btn.ZIndex = 105
    btn.Parent = parentCard
    return btn, bg
end

;(function()
    iCollectProUI.cfgChips, iCollectProUI.cfgRefresh = {}, {}
    local function box(row, right, spec)
        local holder = Instance.new("Frame")
        holder.Size = right == nil and UDim2.new(1, -16, 0, 22) or UDim2.new(0.5, -12, 0, 22)
        holder.Position = right and UDim2.new(0.5, 4, 0.5, -11) or UDim2.new(0, 8, 0.5, -11)
        holder.BackgroundColor3 = T.OFF_BG
        holder.BorderSizePixel = 0
        holder.ZIndex = 104
        holder.Parent = row
        corner(holder, 7)
        stroke(holder, T.STROKE, 1, 0.55)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, -44, 1, 0)
        l.Position = UDim2.fromOffset(6, 0)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.TextXAlignment = Enum.TextXAlignment.Left
        iCollectProUI.fit(l, 10)
        l.TextColor3 = T.OFF_TEXT
        l.Text = string.upper(spec[1])
        l.ZIndex = 105
        l.Parent = holder
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(0, 36, 1, -6)
        tb.Position = UDim2.new(1, -39, 0, 3)
        tb.BackgroundColor3 = T.TRACK
        tb.BorderSizePixel = 0
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.TextColor3 = T.TEXT
        tb.ClearTextOnFocus = false
        tb.ZIndex = 106
        tb.Parent = holder
        corner(tb, 5)
        local key, def, lo, hi = spec[2], spec[3], spec[4], spec[5]
        local function get() return math.clamp(tonumber(HubConfig[key]) or def, lo, hi) end
        tb.Text = tostring(get())
        iCollectProUI.cfgRefresh[#iCollectProUI.cfgRefresh + 1] = function() tb.Text = tostring(get()) end
        tb.FocusLost:Connect(function()
            local n = tonumber(tb.Text)
            if n then
                HubConfig[key] = math.clamp(math.floor(n * 10 + 0.5) / 10, lo, hi)
                saveHubConfig()
            end
            tb.Text = tostring(get())
        end)
    end

    function iCollectProUI.num(key, def, lo, hi)
        return math.clamp(tonumber(HubConfig[key]) or def, lo, hi)
    end

    function iCollectProUI.numPair(order, a, b)
        local r = createRowFrame(30, order)
        if b then
            box(r, false, a)
            box(r, true, b)
        else
            box(r, nil, a)
        end
        return r
    end

    function iCollectProUI.cycleRow(order, text, options, key, onSet)
        local r = createRowFrame(30, order)
        rowLabel(r, text, 0.4)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.fromOffset(120, 22)
        holder.Position = UDim2.new(1, -128, 0.5, -11)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 104
        holder.Parent = r
        local val = Instance.new("TextLabel")
        val.Size = UDim2.new(1, -52, 1, 0)
        val.Position = UDim2.fromOffset(26, 0)
        val.BackgroundColor3 = T.GREEN1
        val.BorderSizePixel = 0
        val.Font = Enum.Font.GothamBold
        val.TextSize = 11
        val.TextColor3 = T.ON_TEXT
        val.ZIndex = 105
        val.Parent = holder
        iCollectProUI.fit(val, 11, 6)
        corner(val, 7)
        stroke(val, T.GREEN_STROKE, 1, 0.22)
        local idx = table.find(options, HubConfig[key]) or 1
        local function show()
            val.Text = string.upper(options[idx])
            HubConfig[key] = options[idx]
            if onSet then onSet(options[idx]) end
        end
        show()
        iCollectProUI.cfgRefresh[#iCollectProUI.cfgRefresh + 1] = function()
            idx = table.find(options, HubConfig[key]) or idx
            show()
        end
        local function step(d)
            idx = (idx - 1 + d) % #options + 1
            show()
            saveHubConfig()
        end
        for i, spec in ipairs({ { "<", 0, 0, -1 }, { ">", 1, -22, 1 } }) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(22, 22)
            b.Position = UDim2.new(spec[2], spec[3], 0, 0)
            b.AutoButtonColor = false
            b.BackgroundColor3 = T.OFF_BG
            b.BorderSizePixel = 0
            b.Text = spec[1]
            b.TextColor3 = T.TEXT
            b.Font = Enum.Font.GothamBlack
            b.TextSize = 12
            b.ZIndex = 105
            b.Parent = holder
            corner(b, 7)
            stroke(b, T.STROKE, 1, 0.55)
            addHover(b, T.OFF_BG, T.HOVER)
            b.MouseButton1Click:Connect(function() step(spec[4]) end)
        end
        return r
    end

    function iCollectProUI.textRow(order, text, key, hint)
        local r = createRowFrame(30, order)
        rowLabel(r, text, 0.3)
        local tb = Instance.new("TextBox")
        tb.Size = UDim2.new(0.62, -8, 0, 22)
        tb.Position = UDim2.new(0.38, 0, 0.5, -11)
        tb.BackgroundColor3 = T.OFF_BG
        tb.BorderSizePixel = 0
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.TextColor3 = T.TEXT
        tb.PlaceholderText = hint or ""
        tb.PlaceholderColor3 = T.OFF_TEXT
        tb.TextTruncate = Enum.TextTruncate.AtEnd
        tb.ClearTextOnFocus = false
        tb.Text = tostring(HubConfig[key] or "")
        tb.ZIndex = 105
        tb.Parent = r
        corner(tb, 7)
        stroke(tb, T.STROKE, 1, 0.55)
        tb.FocusLost:Connect(function()
            HubConfig[key] = tb.Text
            saveHubConfig()
        end)
        iCollectProUI.cfgRefresh[#iCollectProUI.cfgRefresh + 1] = function() tb.Text = tostring(HubConfig[key] or "") end
        return r
    end

    function iCollectProUI.slider(order, text, key, def, lo, hi)
        local r = createRowFrame(30, order)
        local lbl = rowLabel(r, string.upper(text), 0.2)
        iCollectProUI.fit(lbl, 10)
        lbl.TextColor3 = T.OFF_TEXT
        local val = Instance.new("TextLabel")
        val.Size = UDim2.fromOffset(34, 22)
        val.Position = UDim2.new(1, -42, 0.5, -11)
        val.BackgroundColor3 = T.TRACK
        val.BorderSizePixel = 0
        val.Font = Enum.Font.GothamBold
        val.TextSize = 11
        val.TextColor3 = T.TEXT
        val.ZIndex = 105
        val.Parent = r
        corner(val, 6)
        local track = Instance.new("TextButton")
        track.AutoButtonColor = false
        track.Text = ""
        track:SetAttribute("__semiNoPop", true)
        track.Size = UDim2.new(0.8, -62, 0, 8)
        track.Position = UDim2.new(0.2, 8, 0.5, -4)
        track.BackgroundColor3 = T.TRACK
        track.BorderSizePixel = 0
        track.ZIndex = 105
        track.Parent = r
        corner(track, 4)
        stroke(track, T.STROKE, 1, 0.55)
        local fill = Instance.new("Frame")
        fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        fill.BorderSizePixel = 0
        fill.ZIndex = 106
        fill.Parent = track
        corner(fill, 4)
        gradient(fill, T.GREEN1, T.GREEN2)
        local knob = Instance.new("Frame")
        knob.AnchorPoint = Vector2.new(0.5, 0.5)
        knob.Size = UDim2.fromOffset(14, 14)
        knob.BackgroundColor3 = T.ON_TEXT
        knob.BorderSizePixel = 0
        knob.ZIndex = 107
        knob.Parent = track
        corner(knob, 7)
        stroke(knob, T.GREEN_STROKE, 1.5, 0)
        local function get() return math.clamp(tonumber(HubConfig[key]) or def, lo, hi) end
        local function show()
            local a = (get() - lo) / (hi - lo)
            fill.Size = UDim2.new(a, 0, 1, 0)
            knob.Position = UDim2.new(a, 0, 0.5, 0)
            val.Text = tostring(math.floor(get() + 0.5))
        end
        local function setFromX(x)
            local a = math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
            HubConfig[key] = math.floor(lo + a * (hi - lo) + 0.5)
            show()
        end
        local dragging = false
        track.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                setFromX(i.Position.X)
            end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                setFromX(i.Position.X)
            end
        end)
        UserInputService.InputEnded:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch) then
                dragging = false
                saveHubConfig()
            end
        end)
        show()
        iCollectProUI.cfgRefresh[#iCollectProUI.cfgRefresh + 1] = show
        return r
    end
end)()

;(function()
    local DIR = "iCollectPro_SemiTP_Configs"
    local PREFIX = "iCollectPro-"
    local SKIP = { positions = true, speedPos = true, selectedSlot = true, cfgActive = true }
    local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    local function b64enc(data)
        local out = {}
        for i = 1, #data, 3 do
            local a, b, c = data:byte(i, i + 2)
            local n = a * 65536 + (b or 0) * 256 + (c or 0)
            for j = 1, 4 do
                if j == 3 and not b or j == 4 and not c then
                    out[#out + 1] = "="
                else
                    local k = math.floor(n / 64 ^ (4 - j)) % 64
                    out[#out + 1] = B64:sub(k + 1, k + 1)
                end
            end
        end
        return table.concat(out)
    end

    local function b64dec(data)
        data = data:gsub("[^%w%+/]", "")
        local out, n, bits = {}, 0, 0
        for i = 1, #data do
            n = n * 64 + (B64:find(data:sub(i, i), 1, true) - 1)
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                out[#out + 1] = string.char(math.floor(n / 2 ^ bits) % 256)
                n = n % 2 ^ bits
            end
        end
        return table.concat(out)
    end

    local function snapshot()
        local t = {}
        for k, v in pairs(HubConfig) do
            if not SKIP[k] then t[k] = v end
        end
        return t
    end

    local function clean(name)
        name = tostring(name or ""):gsub("[^%w%s_%-]", ""):match("^%s*(.-)%s*$")
        return name:sub(1, 24)
    end

    local function path(name) return DIR .. "/" .. name .. ".json" end

    local function list()
        local names = {}
        pcall(function()
            if not isfolder(DIR) then makefolder(DIR) end
            for _, f in ipairs(listfiles(DIR)) do
                local n = tostring(f):match("([^/\\]+)%.json$")
                if n then names[#names + 1] = n end
            end
        end)
        table.sort(names, function(a, b) return a:lower() < b:lower() end)
        return names
    end

    local function apply(cfg)
        if type(cfg) ~= "table" then return false end
        for k, v in pairs(cfg) do
            if not SKIP[k] then HubConfig[k] = v end
        end
        for key, set in pairs(iCollectProUI.cfgChips) do
            if cfg[key] ~= nil then pcall(set, cfg[key]) end
        end
        for _, f in ipairs(iCollectProUI.cfgRefresh) do pcall(f) end
        saveHubConfig()
        return true
    end

    local function actionBtn(row, right, text, fn)
        local b = Instance.new("TextButton")
        b.AutoButtonColor = false
        b.Size = UDim2.new(0.5, -12, 0, 22)
        b.Position = right and UDim2.new(0.5, 4, 0.5, -11) or UDim2.new(0, 8, 0.5, -11)
        b.BackgroundColor3 = T.OFF_BG
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamBold
        b.TextSize = 10
        b.TextColor3 = T.TEXT
        b.Text = text
        b.ZIndex = 104
        b.Parent = row
        corner(b, 7)
        local s = stroke(b, T.STROKE, 1, 0.55)
        addHover(b, T.OFF_BG, T.HOVER)
        b.MouseButton1Click:Connect(function()
            b.BackgroundColor3 = T.GREEN1
            s.Color = T.GREEN_STROKE
            task.delay(0.25, function()
                b.BackgroundColor3 = T.OFF_BG
                s.Color = T.STROKE
            end)
            local ok, err = pcall(fn)
            if not ok then setStealStatus("CONFIG ERROR", false) warn("[SEMI TP] config:", err) end
        end)
        return b
    end

    local function textBox(parent, hint)
        local tb = Instance.new("TextBox")
        tb.BackgroundColor3 = T.OFF_BG
        tb.BorderSizePixel = 0
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 10
        tb.TextColor3 = T.TEXT
        tb.PlaceholderText = hint
        tb.PlaceholderColor3 = T.OFF_TEXT
        tb.TextTruncate = Enum.TextTruncate.AtEnd
        tb.ClearTextOnFocus = false
        tb.Text = ""
        tb.ZIndex = 105
        tb.Parent = parent
        corner(tb, 7)
        stroke(tb, T.STROKE, 1, 0.55)
        return tb
    end

    function iCollectProUI.configRows(order)
        local rows = {}
        local r1 = createRowFrame(30, order)
        rowLabel(r1, "Profile", 0.3)
        local holder = Instance.new("Frame")
        holder.Size = UDim2.new(0.66, -8, 0, 22)
        holder.Position = UDim2.new(0.34, 0, 0.5, -11)
        holder.BackgroundTransparency = 1
        holder.ZIndex = 104
        holder.Parent = r1
        local nameBox = textBox(holder, "profile name")
        nameBox.Size = UDim2.new(1, -52, 1, 0)
        nameBox.Position = UDim2.fromOffset(26, 0)
        nameBox.TextXAlignment = Enum.TextXAlignment.Center
        nameBox.Text = tostring(HubConfig.cfgActive or "")
        local selected = clean(nameBox.Text)
        local function step(d)
            local names = list()
            if #names == 0 then setStealStatus("NO SAVED PROFILES", false) return end
            local i = table.find(names, selected) or (d > 0 and 0 or 1)
            i = (i - 1 + d) % #names + 1
            selected = names[i]
            nameBox.Text = selected
        end
        for _, spec in ipairs({ { "<", 0, 0, -1 }, { ">", 1, -22, 1 } }) do
            local b = Instance.new("TextButton")
            b.Size = UDim2.fromOffset(22, 22)
            b.Position = UDim2.new(spec[2], spec[3], 0, 0)
            b.AutoButtonColor = false
            b.BackgroundColor3 = T.OFF_BG
            b.BorderSizePixel = 0
            b.Text = spec[1]
            b.TextColor3 = T.TEXT
            b.Font = Enum.Font.GothamBlack
            b.TextSize = 12
            b.ZIndex = 105
            b.Parent = holder
            corner(b, 7)
            stroke(b, T.STROKE, 1, 0.55)
            addHover(b, T.OFF_BG, T.HOVER)
            b.MouseButton1Click:Connect(function() step(spec[4]) end)
        end
        rows[1] = r1

        local function typed()
            local n = clean(nameBox.Text)
            if n == "" then setStealStatus("TYPE A PROFILE NAME", false) return nil end
            return n
        end
        local function exists(n) return table.find(list(), n) ~= nil end

        local r2 = createRowFrame(30, order + 1)
        actionBtn(r2, false, "SAVE", function()
            local n = typed()
            if not n then return end
            if not isfolder(DIR) then makefolder(DIR) end
            HubConfig.cfgActive = n
            writefile(path(n), HttpService:JSONEncode(snapshot()))
            saveHubConfig()
            selected = n
            setStealStatus("SAVED PROFILE: " .. n, true)
        end)
        actionBtn(r2, true, "LOAD", function()
            local n = typed()
            if not n then return end
            if not exists(n) then setStealStatus("NO PROFILE: " .. n, false) return end
            local cfg = HttpService:JSONDecode(readfile(path(n)))
            HubConfig.cfgActive = n
            selected = n
            apply(cfg)
            setStealStatus("LOADED PROFILE: " .. n, true)
        end)
        rows[2] = r2

        local r3 = createRowFrame(30, order + 2)
        actionBtn(r3, false, "RENAME", function()
            local n = typed()
            if not n then return end
            if not selected or selected == "" or not exists(selected) then setStealStatus("PICK A PROFILE WITH < >", false) return end
            if n == selected then return end
            writefile(path(n), readfile(path(selected)))
            delfile(path(selected))
            if HubConfig.cfgActive == selected then HubConfig.cfgActive = n saveHubConfig() end
            setStealStatus("RENAMED " .. selected .. " TO " .. n, true)
            selected = n
        end)
        actionBtn(r3, true, "DELETE", function()
            local n = typed()
            if not n then return end
            if not exists(n) then setStealStatus("NO PROFILE: " .. n, false) return end
            delfile(path(n))
            if HubConfig.cfgActive == n then HubConfig.cfgActive = nil saveHubConfig() end
            selected = nil
            nameBox.Text = ""
            setStealStatus("DELETED PROFILE: " .. n, true)
        end)
        rows[3] = r3

        local r5 = createRowFrame(30, order + 4)
        local codeBox = textBox(r5, "paste a share code here")
        codeBox.Size = UDim2.new(1, -16, 0, 22)
        codeBox.Position = UDim2.new(0, 8, 0.5, -11)
        local realCode = ""
        local MASK = PREFIX .. "********"
        local function showCode(code)
            realCode = code
            codeBox.Text = code ~= "" and MASK or ""
        end
        codeBox.Focused:Connect(function()
            if codeBox.Text == MASK then codeBox.Text = "" end
        end)
        codeBox.FocusLost:Connect(function()
            local raw = codeBox.Text:gsub("%s", "")
            if raw == "" then
                showCode(realCode)
            else
                showCode(raw)
            end
        end)

        local r4 = createRowFrame(30, order + 3)
        actionBtn(r4, false, "COPY CODE", function()
            local code = PREFIX .. b64enc(HttpService:JSONEncode({ name = clean(nameBox.Text), data = snapshot() }))
            if setclipboard then
                setclipboard(code)
                setStealStatus("SHARE CODE COPIED", true)
            else
                setStealStatus("CODE IN THE BOX (NO CLIPBOARD)", true)
            end
            showCode(code)
        end)
        actionBtn(r4, true, "IMPORT CODE", function()
            local raw = realCode
            local body
            for _, pre in ipairs({ PREFIX, "SEMITP-" }) do
                if raw:sub(1, #pre) == pre then body = raw:sub(#pre + 1) break end
            end
            if not body then setStealStatus("NOT AN iCollectPro CODE", false) return end
            local ok, pack = pcall(function() return HttpService:JSONDecode(b64dec(body)) end)
            if not ok or type(pack) ~= "table" or type(pack.data) ~= "table" then setStealStatus("BROKEN CODE", false) return end
            apply(pack.data)
            showCode("")
            local n = clean(pack.name)
            if n ~= "" then nameBox.Text = n end
            setStealStatus("IMPORTED" .. (n ~= "" and (": " .. n) or "") .. " (SAVE TO KEEP)", true)
        end)
        rows[4] = r4
        rows[5] = r5
        return rows
    end
end)()

local Row1 = createRowFrame(30, 1)
iCollectProUI.podiumLbl = rowLabel(Row1, "Podium (1-" .. MAX_PODIUM .. ")", 0.45)

local SelectorFrame = Instance.new("Frame")
SelectorFrame.Size = UDim2.fromOffset(100, 22)
SelectorFrame.Position = UDim2.new(1, -110, 0.5, -11)
SelectorFrame.BackgroundTransparency = 1
SelectorFrame.ZIndex = 104
SelectorFrame.Parent = Row1

local function arrowButton(text, xScale, xOffset, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.fromOffset(22, 22)
    b.Position = UDim2.new(xScale, xOffset, 0, 0)
    b.AutoButtonColor = false
    b.BackgroundColor3 = T.OFF_BG
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = T.TEXT
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.ZIndex = 105
    b.Parent = parent or SelectorFrame
    corner(b, 7)
    stroke(b, T.STROKE, 1, 0.55)
    addHover(b, T.OFF_BG, T.HOVER)
    return b
end

local LeftBtn = arrowButton("<", 0, 0)
local RightBtn = arrowButton(">", 1, -22)

local SlotDisplay = Instance.new("TextBox")
SlotDisplay.Size = UDim2.new(1, -52, 1, 0)
SlotDisplay.Position = UDim2.fromOffset(26, 0)
SlotDisplay.BackgroundColor3 = T.GREEN1
SlotDisplay.BorderSizePixel = 0
SlotDisplay.Text = tostring(selectedSlot)
SlotDisplay.TextColor3 = T.ON_TEXT
SlotDisplay.Font = Enum.Font.GothamBold
SlotDisplay.TextSize = 12
SlotDisplay.ClearTextOnFocus = true
SlotDisplay.ZIndex = 105
SlotDisplay.Parent = SelectorFrame
corner(SlotDisplay, 7)
stroke(SlotDisplay, T.GREEN_STROKE, 1, 0.22)

local function updateSlot(newSlot)
    selectedSlot = newSlot
    SlotDisplay.Text = tostring(selectedSlot)
    iCollectPro.setSlot(selectedSlot)
end

local slotStroke = SlotDisplay:FindFirstChildOfClass("UIStroke")
task.spawn(function()
    local was = nil
    while iCollectPro_ALIVE() and SlotDisplay.Parent do
        local max = iCollectPro.maxPodium()
        local text = "Podium (1-" .. max .. ")"
        if iCollectProUI.podiumLbl.Text ~= text then iCollectProUI.podiumLbl.Text = text end
        if selectedSlot > max then updateSlot(max) end
        if slotHasTarget ~= was then
            was = slotHasTarget
            SlotDisplay.BackgroundColor3 = was and T.GREEN1 or Color3.fromRGB(120, 30, 50)
            SlotDisplay.TextColor3 = was and T.ON_TEXT or Color3.fromRGB(255, 200, 210)
            if slotStroke then slotStroke.Color = was and T.GREEN_STROKE or Color3.fromRGB(220, 80, 110) end
        end
        task.wait(0.25)
    end
end)

SlotDisplay.FocusLost:Connect(function()
    local n = math.floor(tonumber(SlotDisplay.Text) or selectedSlot)
    updateSlot(math.clamp(n, 1, iCollectPro.maxPodium()))
end)

LeftBtn.MouseButton1Click:Connect(function()
    local nextSlot = selectedSlot - 1
    if nextSlot < 1 then nextSlot = iCollectPro.maxPodium() end
    updateSlot(nextSlot)
end)

RightBtn.MouseButton1Click:Connect(function()
    local nextSlot = selectedSlot + 1
    if nextSlot > iCollectPro.maxPodium() then nextSlot = 1 end
    updateSlot(nextSlot)
end)

Row1.LayoutOrder = 0

local RowBase = createRowFrame(30, -1)
rowLabel(RowBase, "Target", 0.3)

local BaseSelector = Instance.new("Frame")
BaseSelector.Size = UDim2.fromOffset(136, 22)
BaseSelector.Position = UDim2.new(1, -144, 0.5, -11)
BaseSelector.BackgroundTransparency = 1
BaseSelector.ZIndex = 104
BaseSelector.Parent = RowBase

local BaseLeft = arrowButton("<", 0, 0, BaseSelector)
local BaseRight = arrowButton(">", 1, -22, BaseSelector)

local BaseName = Instance.new("TextLabel")
BaseName.Size = UDim2.new(1, -52, 1, 0)
BaseName.Position = UDim2.fromOffset(26, 0)
BaseName.BackgroundColor3 = T.OFF_BG
BaseName.BorderSizePixel = 0
BaseName.Text = "Nearest"
BaseName.TextColor3 = T.TEXT
BaseName.Font = Enum.Font.GothamBold
BaseName.TextSize = 11
iCollectProUI.fit(BaseName, 11)
BaseName.ZIndex = 105
BaseName.Parent = BaseSelector
corner(BaseName, 7)
stroke(BaseName, T.STROKE, 1, 0.55)

local function plotOwnerName(plot)
    local sign = plot and plot:FindFirstChild("PlotSign")
    local sg = sign and sign:FindFirstChild("SurfaceGui")
    local lbl = sg and sg:FindFirstChild("Frame") and sg.Frame:FindFirstChild("TextLabel")
    return lbl and (lbl.Text:gsub("'s [Bb]ase$", "")) or "?"
end

local function enemyPlotList()
    local list = {}
    local plots = Workspace:FindFirstChild("Plots")
    for _, plot in ipairs(plots and plots:GetChildren() or {}) do
        if isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums") then
            list[#list + 1] = plot
        end
    end
    table.sort(list, function(a, b)
        return (tonumber(a:GetAttribute("Order")) or 0) < (tonumber(b:GetAttribute("Order")) or 0)
    end)
    return list
end

local function refreshBaseName()
    BaseName.Text = targetPlot and plotOwnerName(targetPlot) or "Nearest"
end

local function cycleBase(dir)
    local list = enemyPlotList()
    local idx = 0
    for i, p in ipairs(list) do
        if p == targetPlot then idx = i break end
    end
    idx = (idx + dir) % (#list + 1)
    targetPlot = list[idx]
    refreshBaseName()
end

BaseLeft.MouseButton1Click:Connect(function() cycleBase(-1) end)
BaseRight.MouseButton1Click:Connect(function() cycleBase(1) end)

task.spawn(function()
    while iCollectPro_ALIVE() and BaseName.Parent do
        if targetPlot and (not targetPlot.Parent or not isEnemyPlot(targetPlot)) then
            targetPlot = nil
        end
        refreshBaseName()
        task.wait(0.5)
    end
end)

local InfoRow = createRowFrame(26, 1)
InfoRow.BackgroundTransparency = 0.35
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, -16, 1, 0)
InfoLabel.Position = UDim2.fromOffset(8, 0)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Font = Enum.Font.GothamBold
InfoLabel.TextSize = 11
InfoLabel.TextColor3 = T.DIM
iCollectProUI.fit(InfoLabel, 11)
InfoLabel.Text = ""
InfoLabel.ZIndex = 104
InfoLabel.Parent = InfoRow

task.spawn(function()
    local last
    while iCollectPro_ALIVE() and InfoLabel.Parent do
        if podiumInfoText ~= last then
            last = podiumInfoText
            InfoLabel.Text = last
            InfoLabel.TextColor3 = (last == "empty" or last:find("no enemy")) and T.OFF_TEXT or T.TEXT
        end
        task.wait(0.25)
    end
end)

local Row6 = createRowFrame(36, 2)
local StealBg
TeleportBtn, StealBg = actionButton(Row6, "STEAL NOW", true)
iCollectProUI.fit(TeleportBtn, 14, 16)
TeleportBtn.MouseButton1Click:Connect(function() iCollectPro.execute() end)

do
    local flashUntil, flashText = 0, ""
    iCollectProUI.flash = function(msg)
        setStealStatus(msg, false)
        flashText = msg
        flashUntil = os.clock() + 1.2
    end
    task.spawn(function()
        while iCollectPro_ALIVE() and TeleportBtn.Parent do
            local st = iCollectProUI.state
            local flashing = os.clock() < flashUntil
            if flashing then
                TeleportBtn.Text = flashText
                StealBg.BackgroundColor3 = Color3.fromRGB(255, 120, 140)
            elseif st.locked and st.friends then
                TeleportBtn.Text = "STEAL NOW (FRIENDS ALLOWED)"
                StealBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            elseif st.locked then
                TeleportBtn.Text = "LOCKED  " .. st.lockText
                StealBg.BackgroundColor3 = Color3.fromRGB(110, 110, 120)
            else
                TeleportBtn.Text = "STEAL NOW"
                StealBg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            end
            TeleportBtn.TextColor3 = (st.locked and not st.friends and not flashing) and Color3.fromRGB(200, 200, 210) or Color3.fromRGB(255, 255, 255)
            task.wait(0.1)
        end
    end)
end

local Row5 = createRowFrame(30, 3)
local ActivateBtn = actionButton(Row5, "Instant Reset", false)
ActivateBtn.MouseButton1Click:Connect(function() iCollectPro.activate() end)

local isSpeedVisible = HubConfig.hexSpeedVisible or false
local HexSpeedFrameRef = nil
local SettingsRows = { Steal = {}, Protect = {}, Extras = {}, Move = {}, Misc = {} }
do
    local bucket = SettingsRows.Steal
    local function tab(name) bucket = SettingsRows[name] end
    local function header(text, order)
        local h = Instance.new("TextLabel")
        h.Size = UDim2.new(1, 0, 0, 14)
        h.BackgroundTransparency = 1
        h.Font = Enum.Font.GothamBlack
        h.TextSize = 10
        h.TextColor3 = T.DIM
        h.TextXAlignment = Enum.TextXAlignment.Left
        h.Text = "   " .. text
        h.LayoutOrder = order
        h.ZIndex = 104
        h.Parent = ContentLayout
        bucket[#bucket + 1] = h
    end

    local function pairRow(order)
        local r = createRowFrame(30, order)
        bucket[#bucket + 1] = r
        return r
    end

    local function chip(row, right, text, initial, onToggle)
        local btn = Instance.new("TextButton")
        btn.AutoButtonColor = false
        btn.Size = right == nil and UDim2.new(1, -16, 0, 22) or UDim2.new(0.5, -12, 0, 22)
        btn.Position = right and UDim2.new(0.5, 4, 0.5, -11) or UDim2.new(0, 8, 0.5, -11)
        btn.BackgroundColor3 = T.OFF_BG
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.ZIndex = 104
        btn.Parent = row
        corner(btn, 7)
        local s = stroke(btn, T.STROKE, 1, 0.55)
        local knob = Instance.new("Frame")
        knob.Size = UDim2.fromScale(1, 1)
        knob.BackgroundTransparency = 1
        knob.BorderSizePixel = 0
        knob.ZIndex = 104
        knob.Parent = btn
        corner(knob, 7)
        gradient(knob, T.GREEN1, T.GREEN2)
        local l = Instance.new("TextLabel")
        l.BackgroundTransparency = 1
        l.Size = UDim2.new(1, -10, 1, -8)
        l.Position = UDim2.fromOffset(5, 4)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 10
        l.Text = string.upper(text)
        l.ZIndex = 105
        l.Parent = btn
        iCollectProUI.fit(l, 10)
        local state = initial and true or false
        local cfgKey = iCollectProUI.lastKey
        iCollectProUI.lastKey = nil
        local function paint()
            knob.BackgroundTransparency = state and 0 or 1
            btn.BackgroundColor3 = state and T.GREEN1 or T.OFF_BG
            s.Color = state and T.GREEN_STROKE or T.STROKE
            s.Transparency = state and 0.22 or 0.55
            l.TextColor3 = state and T.ON_TEXT or T.OFF_TEXT
        end
        paint()
        btn.MouseButton1Click:Connect(function()
            state = not state
            paint()
            onToggle(state)
        end)
        if cfgKey then
            iCollectProUI.cfgChips[cfgKey] = function(v)
                v = v and true or false
                if v == state then return end
                state = v
                paint()
                onToggle(state)
            end
        end
    end

    local function single(order, text, initial, onToggle)
        local r = createRowFrame(30, order)
        bucket[#bucket + 1] = r
        createModernToggle(r, text, initial, onToggle)
        return r
    end

    local function saved(key, apply)
        iCollectProUI.lastKey = key
        return function(on)
            HubConfig[key] = on
            saveHubConfig()
            if apply then apply(on) end
        end
    end

    tab("Steal")
    header("STEAL", 10)
    local r = pairRow(11)
    chip(r, false, "Potion + Shield", PotionEnabled, saved("potionEnabled", function(on) PotionEnabled = on end))
    chip(r, true, "Show Path", HubConfig.showPathEnabled ~= false, saved("showPathEnabled"))
    bucket[#bucket + 1] = iCollectProUI.cycleRow(13, "Fly Tool",
        { "Auto", "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh" }, "flyTool")
    header("AUTO", 14)
    r = pairRow(15)
    chip(r, false, "TP on Allow", AutoTPOnAllowEnabled, saved("autoTPOnAllowEnabled", function(on) AutoTPOnAllowEnabled = on end))
    chip(r, true, "TP on Unlock", iCollectProFx.unlockTP, saved("autoTPOnUnlockEnabled", function(on) iCollectProFx.unlockTP = on end))
    r = pairRow(16)
    chip(r, false, "Auto Kick at 2s", iCollectProFx.rejoin2, saved("autoRejoinEnabled", function(on) iCollectProFx.rejoin2 = on end))
    chip(r, true, "Kick on Deliver", KickAfterStealEnabled, saved("kickAfterStealEnabled", function(on) KickAfterStealEnabled = on end))
    header("GRAB MODES", 17)
    r = pairRow(18)
    chip(r, false, "Quick Grab", iCollectProFx.quickGrab, saved("quickGrabEnabled", function(on) iCollectProFx.quickGrab = on end))
    chip(r, true, "Public Grab", iCollectProFx.pubGrab, saved("publicGrabEnabled", function(on) iCollectProFx.pubGrab = on end))
    r = pairRow(19)
    chip(r, nil, "Defender Bypass", iCollectProFx.defBypass, saved("defenderBypassEnabled", function(on) iCollectProFx.defBypass = on end))

    tab("Protect")
    header("PROTECTION", 10)
    r = pairRow(11)
    chip(r, false, "Anti Admin", AntiRocketEnabled, saved("antiRocketEnabled", iCollectProAntiRocket.set))
    chip(r, true, "Anti Bee", iCollectProFx.bee, saved("antiBeeEnabled", iCollectProAntiFx.setBee))
    r = pairRow(12)
    chip(r, false, "Anti Gummy", iCollectProFx.gummy, saved("antiGummyEnabled", iCollectProAntiFx.setGummy))
    chip(r, true, "Anti Disco", iCollectProFx.disco, saved("antiDiscoEnabled", iCollectProAntiFx.setDisco))
    r = pairRow(13)
    chip(r, false, "Anti Paintball", iCollectProFx.paint, saved("antiPaintEnabled", iCollectProAntiFx.setPaint))
    chip(r, true, "Anti Web", iCollectProFx.web, saved("antiWebEnabled", iCollectProAntiFx.setWeb))
    r = pairRow(14)
    chip(r, false, "Anti Body Swap", iCollectProFx.swap, saved("antiSwapEnabled", iCollectProAntiFx.setSwap))
    chip(r, true, "Anti Ragdoll", AntiRagdollEnabled, saved("antiRagdollEnabled", iCollectProAntiRagdoll.set))
    header("COMBAT", 15)
    r = pairRow(16)
    chip(r, false, "Destroy Sentry", iCollectProFx.sentry, saved("destroySentryEnabled", iCollectProAntiFx.setSentry))
    chip(r, true, "Destroy Doge", iCollectProFx.doge, saved("destroyDogeEnabled", iCollectProAntiFx.setDoge))
    r = pairRow(17)
    chip(r, false, "Aimbot", iCollectProFx.aim, saved("aimbotEnabled", iCollectProAntiFx.setAim))
    chip(r, true, "Auto Spam", iCollectProFx.spam, saved("autoSpamEnabled", iCollectProAntiFx.setSpam))

    tab("Extras")
    header("PLAYERS", 20)
    r = pairRow(21)
    chip(r, false, "Player ESP", iCollectProFx.esp, saved("playerEspEnabled", iCollectProAntiFx.setEsp))
    chip(r, true, "Tracers", iCollectProFx.tracers, saved("tracersEnabled", function(on) iCollectProFx.tracers = on end))
    r = pairRow(22)
    chip(r, false, "Server Ghost", iCollectProFx.ghost, saved("serverGhostEnabled", iCollectProAntiFx.setGhost))
    chip(r, true, "Steal Tags", iCollectProFx.tags, saved("stealTagsEnabled", function(on) iCollectProFx.tags = on end))
    header("BASES", 23)
    r = pairRow(24)
    chip(r, false, "Base Timers", iCollectProFx.timerEsp, saved("baseTimerEspEnabled", function(on) iCollectProFx.timerEsp = on end))
    chip(r, true, "Every Floor", iCollectProFx.timerFloors, saved("timerEveryFloorEnabled", function(on) iCollectProFx.timerFloors = on end))
    r = pairRow(25)
    chip(r, false, "Base ESP", iCollectProFx.baseEsp, saved("baseEspEnabled", function(on) iCollectProFx.baseEsp = on end))
    chip(r, true, "Base X-Ray", iCollectProFx.xray, saved("baseXrayEnabled", function(on) iCollectProFx.xray = on end))

    tab("Move")
    header("SPEED", 60)
    r = pairRow(61)
    chip(r, false, "Walk Speed", iCollectProFx.speedOn, saved("moveSpeedEnabled", function(on) iCollectProFx.speedOn = on end))
    chip(r, true, "Carpet Speed", iCollectProFx.carpet, saved("carpetSpeedEnabled", function(on) iCollectProFx.carpet = on end))
    bucket[#bucket + 1] = iCollectProUI.numPair(62, { "Walk", "walkSpeedValue", 28, 16, 80 }, { "Carpet", "carpetSpeedValue", 130, 16, 500 })
    bucket[#bucket + 1] = iCollectProUI.numPair(63, { "Giant Walk", "giantSpeedValue", 30, 16, 60 })
    header("JUMP & GRAVITY", 64)
    r = pairRow(65)
    chip(r, false, "Infinite Jump", iCollectProFx.infJump, saved("infJumpEnabled", iCollectProAntiFx.setInfJump))
    chip(r, true, "Gravity", iCollectProFx.grav, saved("gravityEnabled", function(on) iCollectProFx.grav = on end))
    bucket[#bucket + 1] = iCollectProUI.numPair(66, { "Gravity", "gravityValue", 196.2, 0, 300 })
    header("CAMERA", 67)
    r = pairRow(68)
    chip(r, nil, "Custom FOV", iCollectProFx.fov, saved("customFovEnabled", function(on) iCollectProFx.fov = on end))
    bucket[#bucket + 1] = iCollectProUI.slider(69, "FOV", "fovValue", 80, 30, 120)

    tab("Misc")
    header("HUD", 30)
    r = pairRow(31)
    chip(r, false, "Thief Bar", iCollectProFx.thiefBar, saved("thiefBarEnabled", function(on) iCollectProFx.thiefBar = on end))
    chip(r, true, "Speed Panel", isSpeedVisible, function(on)
        if HexSpeedFrameRef then
            HexSpeedFrameRef.Visible = on
            HubConfig.hexSpeedVisible = on
            saveHubConfig()
        end
    end)
    r = pairRow(32)
    chip(r, false, "Pill Bar", iCollectProFx.pillBar, saved("pillBarEnabled", function(on) iCollectProFx.pillBar = on end))
    chip(r, true, "Hide AP Icon", iCollectProFx.hideAP, saved("hideApIconEnabled", function(on) iCollectProFx.hideAP = on end))
    header("PERFORMANCE", 33)
    r = pairRow(34)
    chip(r, false, "FPS Boost", iCollectProFx.fps, saved("fpsOptimizerEnabled", function(on) iCollectProFx.fps = on end))
    chip(r, true, "Extreme FPS", iCollectProFx.xfps, saved("extremeFpsEnabled", function(on) iCollectProFx.xfps = on end))
    if not IsMobile then header("CONTROLS", 38) end

    header("CONFIGS", 42)
    if iCollectProUI.configRows then
        for _, row in ipairs(iCollectProUI.configRows(43)) do bucket[#bucket + 1] = row end
    end
end

local Row4 = createRowFrame(30, 40)
if IsMobile then Row4.Visible = false end
rowLabel(Row4, "Steal Keybind", 0.5)

local KeybindBtn = pillButton(Row4, 56, currentStealKey.Name)

local isBinding = false
KeybindBtn.MouseButton1Click:Connect(function() isBinding = true; KeybindBtn.Text = "..." end)

local ContextActionService = game:GetService("ContextActionService")
local STEAL_ACTION = "iCollectPro_SemiTP_StealKey"

local function bindStealKey()
    pcall(function() ContextActionService:UnbindAction(STEAL_ACTION) end)
    if not currentStealKey then return end
    ContextActionService:BindActionAtPriority(STEAL_ACTION, function(_, state)
        if not iCollectPro_ALIVE() then
            pcall(function() ContextActionService:UnbindAction(STEAL_ACTION) end)
            return Enum.ContextActionResult.Pass
        end
        if isBinding or UserInputService:GetFocusedTextBox() then
            return Enum.ContextActionResult.Pass
        end
        if state == Enum.UserInputState.Begin and not iCollectPro.debounce and not player:GetAttribute("Stealing") then
            task.spawn(iCollectPro.execute)
        end
        return Enum.ContextActionResult.Sink
    end, false, Enum.ContextActionPriority.High.Value + 1000, currentStealKey)
end
bindStealKey()

UserInputService.InputBegan:Connect(function(input)
    if isBinding and input.UserInputType == Enum.UserInputType.Keyboard then
        isBinding = false
        currentStealKey = input.KeyCode
        KeybindBtn.Text = input.KeyCode.Name
        HubConfig.stealKeybind = input.KeyCode.Name
        saveHubConfig()
        bindStealKey()
    end
end)

local mainRows = { RowBase, Row1, InfoRow, Row6, Row5 }
local settingsRows = SettingsRows
settingsRows.Main = mainRows
settingsRows.Misc[#settingsRows.Misc + 1] = Row4

local function paintTab(btn, active)
    tween(btn.Pill, 0.2, { BackgroundTransparency = active and 0 or 1 })
    btn.Label.TextColor3 = active and Color3.fromRGB(255, 255, 255) or T.DIM
    btn.Label.Font = active and Enum.Font.GothamBlack or Enum.Font.GothamBold
end

local function switchTab(tabName)
    for name, btn in pairs(iCollectProUI.tabBtns) do
        paintTab(btn, name == tabName)
        for _, r in ipairs(settingsRows[name]) do r.Visible = name == tabName end
    end
    if IsMobile then Row4.Visible = false end
end

for name, btn in pairs(iCollectProUI.tabBtns) do
    btn.MouseButton1Click:Connect(function() switchTab(name) end)
end
switchTab("Main")

local SpeedScreenGui = Instance.new("ScreenGui")
SpeedScreenGui.Name = "iCollectPro_SemiTP_Speed"
SpeedScreenGui.ResetOnSpawn = false
SpeedScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SpeedScreenGui.IgnoreGuiInset = true
SpeedScreenGui.DisplayOrder = 999
SpeedScreenGui.Parent = safeGuiTarget

local HexSpeed = Instance.new("Frame")
HexSpeed.Name = "SpeedPanel"
HexSpeed.Size = UDim2.new(0, 210, 0, 0)
HexSpeed.AutomaticSize = Enum.AutomaticSize.Y
HexSpeed.BackgroundColor3 = T.BG
HexSpeed.BorderSizePixel = 0
HexSpeed.Visible = isSpeedVisible
HexSpeed.ZIndex = 100
HexSpeed.Parent = SpeedScreenGui
HexSpeedFrameRef = HexSpeed
corner(HexSpeed, 18)
stroke(HexSpeed, T.STROKE, 1.2, 0.4)
addShadow(HexSpeed)

local SpeedPad = Instance.new("UIPadding")
SpeedPad.PaddingBottom = UDim.new(0, 10)
SpeedPad.Parent = HexSpeed

HexSpeed.AnchorPoint = Vector2.new(1, 0)
if HubConfig.speedPos and HubConfig.speedPos.ScaleX ~= 0.5 then
    HexSpeed.Position = UDim2.new(HubConfig.speedPos.ScaleX, HubConfig.speedPos.OffsetX, HubConfig.speedPos.ScaleY, HubConfig.speedPos.OffsetY)
else
    HexSpeed.Position = UDim2.new(0.98, 0, 0.04, 0)
end

local SpeedHeader = Instance.new("Frame")
SpeedHeader.Size = UDim2.new(1, 0, 0, 36)
SpeedHeader.BackgroundTransparency = 1
SpeedHeader.ZIndex = 101
SpeedHeader.Parent = HexSpeed

local SpeedTitle = Instance.new("TextLabel")
SpeedTitle.Size = UDim2.new(1, -28, 0, 22)
SpeedTitle.Position = UDim2.new(0, 14, 0, 7)
SpeedTitle.BackgroundTransparency = 1
SpeedTitle.Text = "STEAL SPEED"
SpeedTitle.Font = Enum.Font.GothamBlack
SpeedTitle.TextSize = 16
SpeedTitle.TextColor3 = T.TEXT
SpeedTitle.ZIndex = 102
SpeedTitle.Parent = SpeedHeader

local SpeedRule = Instance.new("Frame")
SpeedRule.AnchorPoint = Vector2.new(0.5, 0)
SpeedRule.Position = UDim2.new(0.5, 0, 0, 32)
SpeedRule.Size = UDim2.new(0, 110, 0, 1)
SpeedRule.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SpeedRule.BackgroundTransparency = 0.15
SpeedRule.BorderSizePixel = 0
SpeedRule.ZIndex = 101
SpeedRule.Parent = HexSpeed

local SpeedCard = Instance.new("Frame")
SpeedCard.AutomaticSize = Enum.AutomaticSize.Y
SpeedCard.Size = UDim2.new(1, -20, 0, 0)
SpeedCard.Position = UDim2.fromOffset(10, 40)
SpeedCard.BackgroundColor3 = T.SURF
SpeedCard.BorderSizePixel = 0
SpeedCard.ZIndex = 101
SpeedCard.Parent = HexSpeed
corner(SpeedCard, 16)
stroke(SpeedCard, T.STROKE, 1, 0.48)

local SpeedCardPad = Instance.new("UIPadding")
SpeedCardPad.PaddingTop, SpeedCardPad.PaddingBottom = UDim.new(0, 4), UDim.new(0, 4)
SpeedCardPad.PaddingLeft, SpeedCardPad.PaddingRight = UDim.new(0, 4), UDim.new(0, 4)
SpeedCardPad.Parent = SpeedCard

local SpeedList = Instance.new("UIListLayout", SpeedCard)
SpeedList.SortOrder = Enum.SortOrder.LayoutOrder
SpeedList.Padding = UDim.new(0, 6)

local function speedRow(order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 30)
    row.BackgroundColor3 = T.SURF2
    row.BackgroundTransparency = 0.02
    row.BorderSizePixel = 0
    row.LayoutOrder = order
    row.ZIndex = 103
    row.Parent = SpeedCard
    corner(row, 11)
    local rs = stroke(row, T.STROKE, 1, 0.52)
    addHover(row, T.SURF2, T.HOVER, rs)
    return row
end

local BoostRow = speedRow(1)
createModernToggle(BoostRow, "Auto on Steal", _G.iCollectPro_SemiTP_SpeedBoost, function(newState)
    _G.iCollectPro_SemiTP_SpeedBoost = newState
    HubConfig.stealBoostAutoOnSteal = newState
    saveHubConfig()
end)

local SpeedValueRow = speedRow(2)
rowLabel(SpeedValueRow, "Speed (max 23)", 0.6)

local InputBox = Instance.new("TextBox")
InputBox.Size = UDim2.fromOffset(56, 22)
InputBox.Position = UDim2.new(1, -66, 0.5, -11)
InputBox.BackgroundColor3 = T.OFF_BG
InputBox.BorderSizePixel = 0
InputBox.Text = tostring(stealSpeed())
InputBox.TextColor3 = T.TEXT
InputBox.Font = Enum.Font.GothamBold
InputBox.TextSize = 11
InputBox.ClearTextOnFocus = false
InputBox.ZIndex = 104
InputBox.Parent = SpeedValueRow
corner(InputBox, 7)
stroke(InputBox, T.STROKE, 1, 0.55)

InputBox.FocusLost:Connect(function()
    local num = tonumber(InputBox.Text)
    if num then
        num = math.clamp(math.floor(num + 0.5), STEAL_SPEED_MIN, STEAL_SPEED_MAX)
        currentSpeed = num
        HubConfig.speedValue = num
        saveHubConfig()
    end
    InputBox.Text = tostring(stealSpeed())
end)

makeDraggable(SpeedHeader, HexSpeed, function()
    HubConfig.speedPos = { ScaleX = HexSpeed.Position.X.Scale, OffsetX = HexSpeed.Position.X.Offset, ScaleY = HexSpeed.Position.Y.Scale, OffsetY = HexSpeed.Position.Y.Offset }
    saveHubConfig()
end)

do
    local function makePill(name, titleText)
        local bb = Instance.new("BillboardGui")
        bb.Name = name
        bb.Size = UDim2.fromOffset(120, 32)
        bb.StudsOffset = Vector3.new(0, 2.6, 0)
        bb.AlwaysOnTop = true
        bb.LightInfluence = 0
        bb.MaxDistance = 100000
        bb.Enabled = false
        bb.Parent = AllowDisallowGui

        local pill = Instance.new("Frame")
        pill.Size = UDim2.fromScale(1, 1)
        pill.BackgroundColor3 = T.BG
        pill.BorderSizePixel = 0
        pill.Parent = bb
        pill.BackgroundTransparency = 0.12
        corner(pill, 16)
        local pillStroke = stroke(pill, T.ACCENT, 1.5, 0.1)
        gradient(pill, T.SURF2, T.BG, 90)

        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, -14, 0, 15)
        title.Position = UDim2.fromOffset(7, 3)
        title.BackgroundTransparency = 1
        title.Font = Enum.Font.GothamBlack
        title.TextSize = 13
        title.TextScaled = false
        title.TextTruncate = Enum.TextTruncate.AtEnd
        title.TextColor3 = T.TEXT
        title.TextStrokeTransparency = 0.6
        title.Text = titleText
        title.Parent = pill

        local sub = Instance.new("TextLabel")
        sub.Size = UDim2.new(1, -14, 0, 11)
        sub.Position = UDim2.fromOffset(7, 18)
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.GothamBold
        sub.TextSize = 9
        sub.TextColor3 = T.DIM
        sub.TextTruncate = Enum.TextTruncate.AtEnd
        sub.Text = ""
        sub.Parent = pill
        return { bb = bb, title = title, sub = sub, stroke = pillStroke }
    end

    local target = makePill("iCollectPro_SemiTP_TargetPill", "TARGET")
    local bb, sub, pillStroke = target.bb, target.sub, target.stroke
    local intruders = {}
    local tracers, myAtt = {}, nil

    local COL_STEAL = Color3.fromRGB(255, 110, 130)
    local COL_IN = Color3.fromRGB(110, 235, 160)

    local function ownerOf(plot)
        local name = plotOwnerName(plot)
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == name or p.DisplayName == name then return p end
        end
        return nil
    end

    local boxes = setmetatable({}, { __mode = "k" })
    local function insidePlot(plot, pos)
        if not plot then return false end
        local box = boxes[plot]
        if not box then
            local ok, cf, size = pcall(plot.GetBoundingBox, plot)
            box = ok and { cf, size } or false
            boxes[plot] = box
        end
        if not box then return false end
        local l = box[1]:PointToObjectSpace(pos)
        return math.abs(l.X) <= box[2].X / 2 and math.abs(l.Z) <= box[2].Z / 2
    end

    task.spawn(function()
        while iCollectPro_ALIVE() and bb.Parent do
            local podium = getTargetPodiumForSlot(selectedSlot)
            local plot = targetPlot or (podium and podium.Parent and podium.Parent.Parent)
            local owner = plot and ownerOf(plot)
            local head = owner and owner.Character and owner.Character:FindFirstChild("Head")
            local root = owner and owner.Character and owner.Character:FindFirstChild("HumanoidRootPart")
            if head and root then
                bb.Adornee = head
                bb.Enabled = true
                local idx = owner:GetAttribute("StealingIndex")
                local col
                if owner:GetAttribute("Stealing") then
                    sub.Text = (idx ~= nil and idx ~= "") and ('STEALING "' .. string.upper(tostring(idx)) .. '"') or "STEALING"
                    col = COL_STEAL
                elseif insidePlot(findMyBase(), root.Position) then
                    sub.Text = "INSIDE YOUR BASE !!"
                    col = COL_STEAL
                elseif insidePlot(plot, root.Position) then
                    sub.Text = "INSIDE HIS BASE"
                    col = COL_IN
                else
                    sub.Text = "OUTSIDE BASE"
                    col = T.ACCENT
                end
                sub.TextColor3 = col
                pillStroke.Color = col
                pillStroke.Transparency = (col == COL_STEAL and (os.clock() % 0.6 < 0.3)) and 0.6 or 0.1
            else
                bb.Enabled = false
                bb.Adornee = nil
            end

            local myPlot = findMyBase()
            local seen = {}
            for _, p in ipairs(Players:GetPlayers()) do
                local ch = p.Character
                local h = ch and ch:FindFirstChild("Head")
                local r = ch and ch:FindFirstChild("HumanoidRootPart")
                if p ~= player and p ~= owner and h and r and insidePlot(myPlot, r.Position) then
                    seen[p] = true
                    local pl = intruders[p]
                    if not pl then
                        pl = makePill("iCollectPro_SemiTP_IntruderPill", p.Name)
                        intruders[p] = pl
                    end
                    pl.title.Text = p.Name
                    pl.bb.Adornee = h
                    pl.bb.Enabled = true
                    local pidx = p:GetAttribute("StealingIndex")
                    if p:GetAttribute("Stealing") then
                        pl.sub.Text = (pidx ~= nil and pidx ~= "") and ('STEALING "' .. string.upper(tostring(pidx)) .. '"') or "STEALING"
                    else
                        pl.sub.Text = "INSIDE YOUR BASE !!"
                    end
                    pl.sub.TextColor3 = COL_STEAL
                    pl.stroke.Color = COL_STEAL
                    pl.stroke.Transparency = (os.clock() % 0.6 < 0.3) and 0.6 or 0.1
                end
            end
            for p, pl in pairs(intruders) do
                if not seen[p] then
                    pl.bb:Destroy()
                    intruders[p] = nil
                end
            end

            local want = {}
            local myHrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if iCollectProFx.tracers and myHrp then
                if owner and root then want[owner] = { root, T.ACCENT } end
                for p in pairs(seen) do
                    local r = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if r then want[p] = { r, COL_STEAL } end
                end
                if not myAtt or myAtt.Parent ~= myHrp then
                    if myAtt then myAtt:Destroy() end
                    myAtt = Instance.new("Attachment")
                    myAtt.Name = "iCollectPro_SemiTP_Tracer"
                    myAtt.Parent = myHrp
                end
            end
            for p, tr in pairs(tracers) do
                local w = want[p]
                if not w or tr.att.Parent ~= w[1] or tr.beam.Attachment0 ~= myAtt then
                    tr.att:Destroy()
                    tracers[p] = nil
                end
            end
            for p, w in pairs(want) do
                local tr = tracers[p]
                if not tr then
                    local att = Instance.new("Attachment")
                    att.Name = "iCollectPro_SemiTP_Tracer"
                    att.Parent = w[1]
                    local beam = Instance.new("Beam")
                    beam.Attachment0, beam.Attachment1 = myAtt, att
                    beam.Width0, beam.Width1 = 0.12, 0.12
                    beam.FaceCamera = true
                    beam.LightEmission = 1
                    beam.Segments = 1
                    beam.Parent = att
                    tr = { att = att, beam = beam }
                    tracers[p] = tr
                end
                tr.beam.Color = ColorSequence.new(w[2])
            end
            if not iCollectProFx.tracers and myAtt then myAtt:Destroy(); myAtt = nil end
            task.wait(0.15)
        end
        bb:Destroy()
        for _, pl in pairs(intruders) do pl.bb:Destroy() end
        for _, tr in pairs(tracers) do tr.att:Destroy() end
        if myAtt then myAtt:Destroy() end
    end)
end

do
    local FADE = 0.9
    local FOLDERS = { "Base", "PlotSign", "FriendPanel", "Cash", "Laser", "Decorations", "Skin", "Unlock", "Purchases" }
    local faded, queue, conns = {}, {}, {}
    local on = false

    local function one(d)
        if d:IsA("BasePart") and not faded[d] then
            faded[d] = true
            d.LocalTransparencyModifier = FADE
        end
    end

    local function track(root)
        if not root then return end
        one(root)
        for _, d in ipairs(root:GetDescendants()) do one(d) end
        conns[#conns + 1] = root.DescendantAdded:Connect(function(d) queue[#queue + 1] = d end)
    end

    local function doPlot(plot)
        for _, name in ipairs(FOLDERS) do track(plot:FindFirstChild(name)) end
        conns[#conns + 1] = plot.ChildAdded:Connect(function(c)
            if table.find(FOLDERS, c.Name) then task.defer(track, c) end
        end)
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then return end
        local function pod(pd)
            track(pd:FindFirstChild("Claim"))
            local b = pd:FindFirstChild("Base")
            track(b and b:FindFirstChild("Decorations"))
        end
        for _, pd in ipairs(pods:GetChildren()) do pod(pd) end
        conns[#conns + 1] = pods.ChildAdded:Connect(function(pd) task.delay(0.1, pod, pd) end)
    end

    local function enable()
        local plots = Workspace:FindFirstChild("Plots")
        if not plots then return false end
        for _, p in ipairs(plots:GetChildren()) do pcall(doPlot, p) end
        conns[#conns + 1] = plots.ChildAdded:Connect(function(p) task.delay(0.2, function() if on then pcall(doPlot, p) end end) end)
        return true
    end

    local function disable()
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        table.clear(conns); table.clear(queue)
        for p in pairs(faded) do pcall(function() if p.Parent then p.LocalTransparencyModifier = 0 end end) end
        table.clear(faded)
    end

    task.spawn(function()
        while iCollectPro_ALIVE() do
            if iCollectProFx.xray and not on then
                on = enable()
            elseif not iCollectProFx.xray and on then
                on = false
                disable()
            end
            if on and #queue > 0 then
                local batch = queue
                queue = {}
                for _, d in ipairs(batch) do if d.Parent then pcall(one, d) end end
            end
            task.wait(0.2)
        end
        disable()
    end)
end

_G.iCollectPro_SemiTP = iCollectPro
iCollectPro_ENV.iCollectPro_SemiTP = iCollectPro
table.insert(iCollectPro_ENV.iCollectPro_SemiTP_Tables, iCollectPro)
_G.iCollectPro_SemiTP_Steal = function() pcall(iCollectPro.execute) end
_G.iCollectPro_SemiTP_SetPodium = function(slot) iCollectPro.setSlot(slot) end

iCollectPro.debounce = false

;(function()
    local function viewport()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize
        if not vp or vp.X < 2 or vp.Y < 2 then vp = Vector2.new(1920, 1080) end
        return vp
    end
    function iCollectProUI.uiFactor()
        local vp = viewport()
        if IsMobile then
            local short = math.min(vp.X, vp.Y)
            return math.clamp(short / (short < 500 and 430 or 650), 0.6, 1.15)
        end
        return math.clamp(math.min(vp.X / 1920, vp.Y / 1080), 0.7, 1.35)
    end

    local fitted = { { MainFrame, 1.2 }, { HexSpeed, 1.2 }, { PBarMain, 1 }, { MainAllowBtn, 1 } }
    local scalers = {}
    for i, e in ipairs(fitted) do
        local s = e[1]:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
        s.Parent = e[1]
        scalers[i] = s
    end

    local function keepOnScreen(frame)
        local sg = frame:FindFirstAncestorOfClass("ScreenGui")
        if not sg or not frame.Visible then return end
        local bounds, pos, size = sg.AbsoluteSize, frame.AbsolutePosition, frame.AbsoluteSize
        local dx, dy = 0, 0
        if pos.X < 0 then dx = -pos.X elseif pos.X + size.X > bounds.X then dx = bounds.X - (pos.X + size.X) end
        if pos.Y < 0 then dy = -pos.Y elseif pos.Y + size.Y > bounds.Y then dy = bounds.Y - (pos.Y + size.Y) end
        if math.abs(dx) > 0.5 or math.abs(dy) > 0.5 then
            frame.Position = frame.Position + UDim2.fromOffset(math.floor(dx), math.floor(dy))
        end
    end

    local busy = false
    local function update()
        if busy or not iCollectPro_ALIVE() then return end
        busy = true
        local f, vp = iCollectProUI.uiFactor(), viewport()
        for i, e in ipairs(fitted) do
            local s = f * e[2]
            if e[1] == MainFrame then
                local cur = scalers[i].Scale
                local baseH = cur > 0 and MainFrame.AbsoluteSize.Y / cur or 0
                if baseH > 0 then s = math.min(s, vp.Y * 0.8 / baseH) end
            end
            s = math.clamp(s, 0.5, 1.6)
            if math.abs(scalers[i].Scale - s) > 0.01 then scalers[i].Scale = s end
        end
        task.defer(function()
            for _, e in ipairs(fitted) do pcall(keepOnScreen, e[1]) end
            busy = false
        end)
    end
    iCollectProUI.fitUI = update

    update()
    local camConn
    local function watchCam()
        if camConn then camConn:Disconnect() end
        local cam = Workspace.CurrentCamera
        if cam then camConn = cam:GetPropertyChangedSignal("ViewportSize"):Connect(update) end
        update()
    end
    watchCam()
    Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchCam)
    MainFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() task.defer(update) end)

    local function fitBillboard(bb)
        if not bb:IsA("BillboardGui") then return end
        task.defer(function()
            if not bb.Parent then return end
            local w, h = bb:GetAttribute("__semiW"), bb:GetAttribute("__semiH")
            if not w then
                if bb.Size.X.Scale ~= 0 or bb.Size.Y.Scale ~= 0 then return end
                w, h = bb.Size.X.Offset, bb.Size.Y.Offset
                bb:SetAttribute("__semiW", w)
                bb:SetAttribute("__semiH", h)
            end
            local f = iCollectProUI.uiFactor()
            bb.Size = UDim2.fromOffset(w * f, h * f)
            local sc = bb:FindFirstChild("__semiScale") or Instance.new("UIScale")
            sc.Name = "__semiScale"
            sc.Scale = f
            sc.Parent = bb
        end)
    end
    for _, d in ipairs(AllowDisallowGui:GetDescendants()) do fitBillboard(d) end
    AllowDisallowGui.DescendantAdded:Connect(fitBillboard)
    local lastF = iCollectProUI.uiFactor()
    task.spawn(function()
        while iCollectPro_ALIVE() do
            task.wait(1)
            local f = iCollectProUI.uiFactor()
            if math.abs(f - lastF) > 0.01 then
                lastF = f
                for _, d in ipairs(AllowDisallowGui:GetDescendants()) do fitBillboard(d) end
            end
        end
    end)
end)()

;(function()
    local POP_ID = "rbxassetid://102289499477049"
    local HOVER_IDS = { "rbxassetid://95003901725897", "rbxassetid://72335876826381", "rbxassetid://82122230376488" }
    local sounds = {}
    local function play(id, vol)
        local s = sounds[id]
        if not s or not s.Parent then
            local ok, made = pcall(function()
                local n = Instance.new("Sound")
                n.Name = "__SemiTPUISound"
                n.SoundId = id
                n.Volume = vol
                n.Parent = ScreenGui
                return n
            end)
            s = ok and made or nil
            sounds[id] = s
        end
        if s then pcall(function() s.TimePosition = 0; s:Play() end) end
    end
    task.defer(function()
        for _, id in ipairs({ POP_ID, table.unpack(HOVER_IDS) }) do
            play(id, 0)
            if sounds[id] then pcall(function() sounds[id]:Stop() end) end
        end
    end)
    local hooked = setmetatable({}, { __mode = "k" })
    local function hook(b)
        if hooked[b] or not b:IsA("GuiButton") then return end
        hooked[b] = true
        local sc
        if not b:GetAttribute("__semiNoPop") and not (b.Text == "" and b:FindFirstChildWhichIsA("GuiObject") == nil) then
            sc = b:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")
            sc.Parent = b
        end
        local over = false
        local function to(s, t, style)
            if sc then
                TweenService:Create(sc, TweenInfo.new(t, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = s }):Play()
            end
        end
        b.Activated:Connect(function()
            play(POP_ID, 0.6)
            if sc then
                sc.Scale = 0.92
                to(over and 1.04 or 1, 0.22, Enum.EasingStyle.Back)
            end
        end)
        b.MouseEnter:Connect(function()
            over = true
            play(HOVER_IDS[math.random(1, #HOVER_IDS)], 0.12)
            to(1.04, 0.12)
        end)
        b.MouseLeave:Connect(function()
            over = false
            to(1, 0.12)
        end)
    end
    for _, gui in ipairs({ ScreenGui, SpeedScreenGui, AllowDisallowGui, ProgressGui }) do
        for _, d in ipairs(gui:GetDescendants()) do hook(d) end
        gui.DescendantAdded:Connect(hook)
    end
end)()

;(function()
local iCollectProAur = {
    RED = Color3.fromRGB(255, 110, 130),
    GREEN = Color3.fromRGB(110, 235, 160),
    YELLOW = Color3.fromRGB(255, 205, 90),
    INVIS = Color3.fromRGB(195, 135, 255),
}

function iCollectProAur.pill()
    local t = iCollectProAur.tag(120, 32)
    t.lbl.Size = UDim2.new(1, -14, 0, 15)
    t.lbl.Position = UDim2.fromOffset(7, 3)
    t.lbl.TextSize = 13
    t.lbl.TextStrokeTransparency = 0.6
    local sub = Instance.new("TextLabel")
    sub.Size = UDim2.new(1, -14, 0, 11)
    sub.Position = UDim2.fromOffset(7, 18)
    sub.BackgroundTransparency = 1
    sub.Font = Enum.Font.GothamBold
    sub.TextSize = 9
    sub.TextTruncate = Enum.TextTruncate.AtEnd
    sub.Parent = t.lbl.Parent
    t.sub = sub
    return t
end

function iCollectProAur.paint2(t, title, status, col)
    if t.lbl.Text ~= title then t.lbl.Text = title end
    if t.sub.Text ~= status then t.sub.Text = status end
    t.lbl.TextColor3 = T.TEXT
    t.sub.TextColor3 = col
    t.stroke.Color = col
    t.bb.Enabled = true
end

function iCollectProAur.tag(w, h)
    local bb = Instance.new("BillboardGui")
    bb.Size = UDim2.fromOffset(w, h)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 100000
    bb.Enabled = false
    bb.Parent = AllowDisallowGui
    local f = Instance.new("Frame")
    f.Size = UDim2.fromScale(1, 1)
    f.BackgroundColor3 = T.BG
    f.BackgroundTransparency = 0.12
    f.BorderSizePixel = 0
    f.Parent = bb
    corner(f, h // 2)
    gradient(f, T.SURF2, T.BG, 90)
    local s = stroke(f, T.ACCENT, 1.5, 0.1)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -10, 1, 0)
    l.Position = UDim2.fromOffset(5, 0)
    l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamBlack
    l.TextSize = 11
    l.TextColor3 = T.TEXT
    l.TextTruncate = Enum.TextTruncate.AtEnd
    l.Parent = f
    return { bb = bb, lbl = l, stroke = s }
end

function iCollectProAur.paint(t, text, col)
    if t.lbl.Text ~= text then t.lbl.Text = text end
    t.lbl.TextColor3 = col
    t.stroke.Color = col
    t.bb.Enabled = true
end

function iCollectProAur.timerState(plot)
    local pur = plot:FindFirstChild("Purchases")
    local pb = pur and pur:FindFirstChild("PlotBlock")
    local main = pb and pb:FindFirstChild("Main")
    local gui = main and main:FindFirstChild("BillboardGui")
    if not gui then return nil end
    local rt = gui:FindFirstChild("RemainingTime")
    if not rt or not rt.Visible then return "UNLOCKED", iCollectProAur.GREEN, main, nil end
    local n = tonumber(rt.Text:match("(%d+)"))
    local ts = n and (n >= 60 and string.format("%d:%02d", n // 60, n % 60) or (n .. "s")) or ""
    local delay = gui:FindFirstChild("Delay")
    if delay and delay.Visible then return "RELOCK IN " .. ts, iCollectProAur.YELLOW, main, n end
    return "LOCKED " .. ts, iCollectProAur.RED, main, n
end

function iCollectProAur.hitbox(plot)
    local h = plot and plot:FindFirstChild("StealHitbox", true)
    return h and h:IsA("BasePart") and h or nil
end

function iCollectProAur.inBox(part, pos)
    if not part then return false end
    local l = part.CFrame:PointToObjectSpace(pos)
    return math.abs(l.X) <= part.Size.X / 2 and math.abs(l.Z) <= part.Size.Z / 2
end

;(function()
    local boards, boxes = {}, {}
    local function clearBoards(plot)
        for _, t in ipairs(boards[plot] or {}) do t.bb:Destroy() end
        boards[plot] = nil
    end
    local function floorsOf(plot)
        local list = {}
        local un = plot:FindFirstChild("Unlock")
        for _, c in ipairs(un and un:GetChildren() or {}) do
            local ub = c:FindFirstChild("UnlockBase")
            if c:IsA("BasePart") and ub and ub:GetAttribute("Floor") then list[#list + 1] = c end
        end
        table.sort(list, function(a, b) return a.Position.Y < b.Position.Y end)
        return list
    end
    local function unlockPrompt(plot, anchor)
        local un = plot and plot:FindFirstChild("Unlock")
        if not un then return nil end
        if anchor and anchor.Parent == un then
            local pp = anchor:FindFirstChild("UnlockBase")
            return pp and pp:IsA("ProximityPrompt") and pp or nil
        end
        local best
        for _, c in ipairs(un:GetChildren()) do
            local pp = c:FindFirstChild("UnlockBase")
            if pp and pp:IsA("ProximityPrompt") and pp.Enabled and c:IsA("BasePart")
                and (not best or c.Position.Y < best.Parent.Position.Y) then
                best = pp
            end
        end
        return best
    end
    local function openUnlock(t)
        if not t.plot or t.plot == findMyBase() then return end
        local pp = unlockPrompt(t.plot, t.anchor)
        if not pp or not pp.Enabled then
            setStealStatus("THAT FLOOR ISN'T LOCKED", false)
            return
        end
        setStealStatus("OPENING UNLOCK...", nil)
        if firesignal then
            pcall(firesignal, pp.Triggered, player)
        elseif fireproximityprompt then
            pcall(fireproximityprompt, pp)
        end
    end
    local function clickable(t)
        t.bb.Active = true
        local b = Instance.new("TextButton")
        b.Size = UDim2.fromScale(1, 1)
        b.BackgroundTransparency = 1
        b.Text = ""
        b.ZIndex = 5
        b.Parent = t.lbl.Parent
        local last = 0
        b.MouseButton1Click:Connect(function()
            local now = os.clock()
            if now - last <= 0.4 then
                last = 0
                openUnlock(t)
            else
                last = now
            end
        end)
    end
    task.spawn(function()
        while iCollectPro_ALIVE() do
            local plots = Workspace:FindFirstChild("Plots")
            local mine = findMyBase()
            local seen = {}
            for _, plot in ipairs(plots and plots:GetChildren() or {}) do
                local owner = plotOwnerName(plot)
                local empty = owner == "?" or owner == "Empty Base"
                local text, col, main = iCollectProAur.timerState(plot)
                if iCollectProFx.timerEsp and text and not empty then
                    seen[plot] = true
                    local anchors = iCollectProFx.timerFloors and floorsOf(plot) or {}
                    if #anchors == 0 then anchors = { main } end
                    local list = boards[plot]
                    if not list or #list ~= #anchors then
                        clearBoards(plot)
                        list = {}
                        for _ = 1, #anchors do
                            local t = iCollectProAur.pill()
                            clickable(t)
                            list[#list + 1] = t
                        end
                        boards[plot] = list
                    end
                    local who = plot == mine and "YOUR BASE" or owner
                    for i, t in ipairs(list) do
                        t.plot, t.anchor = plot, anchors[i]
                        t.bb.Adornee = anchors[i]
                        t.bb.StudsOffsetWorldSpace = Vector3.new(0, 4, 0)
                        iCollectProAur.paint2(t, who, (#list > 1 and ("FLOOR " .. i .. "  ·  ") or "") .. text, col)
                    end
                end
                local hb = iCollectProFx.baseEsp and not empty and iCollectProAur.hitbox(plot)
                if hb then
                    local sb = boxes[plot]
                    if not sb or not sb.Parent then
                        sb = Instance.new("SelectionBox")
                        sb.LineThickness = 0.12
                        sb.SurfaceTransparency = 1
                        sb.Parent = AllowDisallowGui
                        boxes[plot] = sb
                    end
                    sb.Adornee = hb
                    sb.Color3 = plot == mine and iCollectProAur.GREEN or (col == iCollectProAur.RED and iCollectProAur.RED or T.ACCENT)
                elseif boxes[plot] then
                    boxes[plot]:Destroy()
                    boxes[plot] = nil
                end
            end
            for plot in pairs(boards) do
                if not seen[plot] then clearBoards(plot) end
            end
            for plot, sb in pairs(boxes) do
                if not plot.Parent then sb:Destroy() boxes[plot] = nil end
            end
            task.wait(0.25)
        end
        for plot in pairs(boards) do clearBoards(plot) end
        for _, sb in pairs(boxes) do sb:Destroy() end
    end)
end)()

;(function()
    local tags, lights = {}, {}
    local function invisible(ch)
        local lvl = ch:GetAttribute("InvisibilityLevel")
        if type(lvl) ~= "number" or lvl <= 0 then return false end
        for _, m in ipairs(ch:GetChildren()) do
            if m:IsA("Model") then
                local n = 0
                for _, d in ipairs(m:GetDescendants()) do
                    if d:IsA("BasePart") then n = n + 1 if n >= 2 then return false end end
                end
            end
        end
        return true
    end
    task.spawn(function()
        while iCollectPro_ALIVE() do
            local seen = {}
            if iCollectProFx.tags then
                for _, p in ipairs(Players:GetPlayers()) do
                    local ch = p ~= player and p.Character
                    local head = ch and ch:FindFirstChild("Head")
                    if head then
                        local st = p:GetAttribute("Stealing")
                        local stealing = st ~= nil and st ~= false
                        local inv = invisible(ch)
                        if stealing or inv then
                            seen[p] = true
                            local t = tags[p]
                            if not t then
                                t = iCollectProAur.tag(130, 18)
                                t.bb.StudsOffset = Vector3.new(0, 2.6, 0)
                                t.bb.SizeOffset = Vector2.new(0, 1.7)
                                tags[p] = t
                            end
                            t.bb.Adornee = head
                            local idx = p:GetAttribute("StealingIndex")
                            local s = stealing and ((idx ~= nil and idx ~= "") and ('STEALING "' .. string.upper(tostring(idx)) .. '"') or "STEALING") or nil
                            iCollectProAur.paint(t, inv and (s and ("INVISIBLE · " .. s) or "INVISIBLE") or s, inv and iCollectProAur.INVIS or iCollectProAur.RED)
                            if inv then
                                local hl = lights[p]
                                if not hl or not hl.Parent then
                                    hl = Instance.new("Highlight")
                                    hl.FillColor = iCollectProAur.INVIS
                                    hl.OutlineColor = iCollectProAur.INVIS
                                    hl.FillTransparency = 0.6
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Parent = AllowDisallowGui
                                    lights[p] = hl
                                end
                                hl.Adornee = ch
                            elseif lights[p] then
                                lights[p]:Destroy()
                                lights[p] = nil
                            end
                        end
                    end
                end
            end
            for p, t in pairs(tags) do
                if not seen[p] then t.bb:Destroy() tags[p] = nil end
            end
            for p, hl in pairs(lights) do
                if not seen[p] then hl:Destroy() lights[p] = nil end
            end
            task.wait(0.15)
        end
        for _, t in pairs(tags) do t.bb:Destroy() end
        for _, hl in pairs(lights) do hl:Destroy() end
    end)
end)()

;(function()
    local bar = Instance.new("Frame")
    bar.AnchorPoint = Vector2.new(0.5, 0)
    bar.Position = UDim2.new(0.5, 0, 0, 70)
    bar.Size = UDim2.fromOffset(320, 50)
    bar.BackgroundColor3 = T.SURF
    bar.BackgroundTransparency = 0.02
    bar.BorderSizePixel = 0
    bar.Visible = false
    bar.ZIndex = 80
    bar.Parent = ProgressGui
    corner(bar, 12)
    gradient(bar, T.SURF2, T.BG, 90)
    stroke(bar, T.STROKE, 1, 0.35)
    local barStroke = stroke(bar, T.ACCENT, 3, 0.6)
    addShadow(bar, 20)
    local barScale = Instance.new("UIScale")
    barScale.Parent = bar
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 0, 14)
    title.Position = UDim2.fromOffset(7, 4)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 11
    title.TextColor3 = T.TEXT
    title.TextXAlignment = Enum.TextXAlignment.Left
    iCollectProUI.fit(title, 11)
    title.ZIndex = 82
    title.Parent = bar
    local hitBtn = Instance.new("TextButton")
    hitBtn.AnchorPoint = Vector2.new(1, 0.5)
    hitBtn.Position = UDim2.new(1, -6, 0.5, 0)
    hitBtn.Size = UDim2.fromOffset(76, 40)
    hitBtn.AutoButtonColor = false
    hitBtn.BackgroundTransparency = 1
    hitBtn.BorderSizePixel = 0
    hitBtn.Text = ""
    hitBtn.ZIndex = 85
    hitBtn.Parent = bar
    local hitFace = Instance.new("Frame")
    hitFace.Size = UDim2.fromScale(1, 1)
    hitFace.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hitFace.BorderSizePixel = 0
    hitFace.ZIndex = 85
    hitFace.Parent = hitBtn
    corner(hitFace, 10)
    gradient(hitFace, Color3.fromRGB(255, 70, 90), Color3.fromRGB(185, 15, 45), 90)
    local hitStroke = stroke(hitFace, Color3.fromRGB(255, 255, 255), 2, 0)
    local hitLbl = Instance.new("TextLabel")
    hitLbl.Size = UDim2.new(1, -8, 1, 0)
    hitLbl.Position = UDim2.fromOffset(4, 0)
    hitLbl.BackgroundTransparency = 1
    hitLbl.Font = Enum.Font.GothamBlack
    hitLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    hitLbl.TextStrokeColor3 = Color3.fromRGB(60, 0, 15)
    hitLbl.TextStrokeTransparency = 0
    hitLbl.Text = "HIT"
    hitLbl.ZIndex = 86
    hitLbl.Parent = hitBtn
    iCollectProUI.fit(hitLbl, 22, 4)
    hitBtn:GetPropertyChangedSignal("Text"):Connect(function()
        if hitBtn.Text ~= "" then hitLbl.Text = hitBtn.Text hitBtn.Text = "" end
    end)
    hitBtn.MouseEnter:Connect(function() tween(hitStroke, 0.14, { Color = Color3.fromRGB(255, 230, 120) }) end)
    hitBtn.MouseLeave:Connect(function() tween(hitStroke, 0.14, { Color = Color3.fromRGB(255, 255, 255) }) end)
    local track = Instance.new("Frame")
    track.Size = UDim2.new(1, -94, 0, 20)
    track.Position = UDim2.fromOffset(6, 22)
    track.BackgroundColor3 = T.TRACK
    track.BorderSizePixel = 0
    track.ZIndex = 82
    track.Parent = bar
    corner(track, 8)
    stroke(track, T.STROKE, 1, 0.55)
    local fill = Instance.new("Frame")
    fill.Size = UDim2.fromScale(0, 1)
    fill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 83
    fill.Parent = track
    corner(fill, 8)
    gradient(fill, T.FILL1, T.FILL2)
    local pct = Instance.new("TextLabel")
    pct.Size = UDim2.fromScale(1, 1)
    pct.BackgroundTransparency = 1
    pct.Font = Enum.Font.GothamBold
    pct.TextSize = 11
    pct.TextColor3 = T.TEXT
    pct.TextStrokeTransparency = 0.7
    pct.Text = ""
    pct.ZIndex = 84
    pct.Parent = track

    local lastIn, thieves = {}, {}
    local shown, hunting = nil, false
    local pendingHome, pendingUntil = nil, 0

    local RANGED = {}
    for _, n in ipairs({ "Laser Cape", "Taser Gun", "Freeze Ray", "Web Slinger", "Paintball Gun", "Slingshot",
        "Snowball", "Jelly Gun", "Hunter Crossbow", "Candycane Bow", "Gravity Gun", "Tripple Plungers",
        "Zombie Blaster", "Lava Blaster", "Summer Soaker", "Candy Launcher", "Pumpkin Launcher" }) do RANGED[n] = true end
    local function pickWeapon()
        local ch, bp = player.Character, player:FindFirstChild("Backpack")
        local melee, ranged
        for _, cont in ipairs({ ch, bp }) do
            for _, t in ipairs(cont and cont:GetChildren() or {}) do
                if t:IsA("Tool") then
                    if t.Name == "Bat" or t.Name:find("Slap", 1, true) then melee = melee or t
                    elseif RANGED[t.Name] then ranged = ranged or t end
                end
            end
        end
        return melee or ranged, melee ~= nil
    end
    local mouse
    pcall(function() mouse = require(ReplicatedStorage.Packages.PlayerMouse) end)
    local steerRp = RaycastParams.new()
    steerRp.FilterType = Enum.RaycastFilterType.Exclude
    steerRp.RespectCanCollide = true
    local function steer(hrp, dest, speed, ignore)
        local d = dest - hrp.Position
        local dist = d.Magnitude
        if dist < 0.05 then return Vector3.zero end
        local dir = d.Unit
        steerRp.FilterDescendantsInstances = { player.Character, ignore }
        local look = math.min(dist, 14)
        local o = hrp.Position
        local ahead = Workspace:Raycast(o, dir * look, steerRp)
            or Workspace:Raycast(o + Vector3.new(0, -2.2, 0), dir * look, steerRp)
        if not ahead then return dir * speed end
        local flat = Vector3.new(dir.X, 0, dir.Z)
        flat = flat.Magnitude > 0.01 and flat.Unit or Vector3.zero
        if not Workspace:Raycast(o, Vector3.new(0, 7, 0), steerRp) then
            return (Vector3.new(0, 1, 0) * 0.85 + flat * 0.3).Unit * speed
        end
        local side = flat:Cross(Vector3.new(0, 1, 0))
        if side.Magnitude < 0.01 then side = Vector3.new(1, 0, 0) end
        for _, s in ipairs({ side, -side }) do
            if not Workspace:Raycast(o, s * 8, steerRp) then return (s * 0.8 + flat * 0.2).Unit * speed end
        end
        return -flat * speed * 0.5
    end
    local function inLockedBase(hrp)
        local plots = Workspace:FindFirstChild("Plots")
        local mine = findMyBase()
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            if plot ~= mine then
                local hb = iCollectProAur.hitbox(plot)
                if hb and iCollectProAur.inBox(hb, hrp.Position) and iCollectProUI.lockInfo(plot) then return true end
            end
        end
        return false
    end
    local function flyTo(hrp, getPos, stopDist, maxTime, onStep)
        local t0 = os.clock()
        while iCollectPro_ALIVE() and os.clock() - t0 < maxTime do
            local pos = getPos()
            if not pos or not hrp.Parent then return false end
            local d = pos - hrp.Position
            if onStep and onStep(d.Magnitude) then return true end
            if d.Magnitude <= stopDist then
                hrp.AssemblyLinearVelocity = Vector3.zero
                if not onStep then return true end
            else
                hrp.AssemblyLinearVelocity = steer(hrp, pos, math.clamp(d.Magnitude * 8, 30, 160))
            end
            RunService.Heartbeat:Wait()
        end
        return false
    end
    local function theirRoot(target)
        local st = target:GetAttribute("Stealing")
        if st == nil or st == false then return nil end
        return target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    end
    local function wear(hum, t)
        if t and t.Parent and t.Parent ~= player.Character then pcall(function() hum:EquipTool(t) end) end
    end
    local function adminHit(ch, hum, hrp)
        if not hum.Parent or hum.Health <= 0 or not hrp.Parent then return true end
        local t = player:GetAttribute("RagdollEndTime")
        if type(t) == "number" and t > Workspace:GetServerTimeNow() then return true end
        if player:GetAttribute("Ragdoll") == true or hrp.Anchored then return true end
        local held = ch:FindFirstChildOfClass("Tool")
        if held and held == findFlyGear() then return false end
        return hum.PlatformStand or ch:FindFirstChildWhichIsA("VectorForce", true) ~= nil
    end
    local function chase(target, ch, hum, hrp, tool, isMelee, gear)
        local range = isMelee and 4 or 30
        local t0, lastSwing = os.clock(), 0
        local bestD, bestAt = math.huge, os.clock()
        wear(hum, gear or tool)
        while iCollectPro_ALIVE() and os.clock() - t0 < 15 do
            local r = theirRoot(target)
            if not r then return "done" end
            if adminHit(ch, hum, hrp) then return "hit" end
            if inLockedBase(hrp) then return "locked" end
            local pos = r.Position + r.AssemblyLinearVelocity * 0.1
            local d = pos - hrp.Position
            local dist = d.Magnitude
            if dist < bestD - 3 or dist <= range + 4 then bestD, bestAt = dist, os.clock() end
            if os.clock() - bestAt > 2.5 then return "hit" end
            if dist > range + 8 then wear(hum, gear or tool) else wear(hum, tool) end
            if dist <= range then
                hrp.AssemblyLinearVelocity = Vector3.zero
            else
                hrp.AssemblyLinearVelocity = steer(hrp, pos, math.clamp(dist * 8, 30, 160), target.Character)
            end
            local flat = Vector3.new(r.Position.X, hrp.Position.Y, r.Position.Z)
            if (flat - hrp.Position).Magnitude > 0.1 then hrp.CFrame = CFrame.lookAt(hrp.Position, flat) end
            if mouse then pcall(function() mouse.Hit = CFrame.new(r.Position); mouse.Target = r end) end
            if dist <= range + 2 and os.clock() - lastSwing >= 0.12 then
                lastSwing = os.clock()
                pcall(function() tool:Activate() end)
            end
            RunService.Heartbeat:Wait()
        end
        return "timeout"
    end
    local function hunt(target)
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) or player:GetAttribute("Stealing") then return end
        if not pickWeapon() then setStealStatus("NO BAT / SLAP / WEAPON", false) return end
        hunting = true
        hitBtn.Text = "HUNTING"
        local home = hrp.CFrame
        _G.iCollectPro_SemiTP_Busy = true
        local resets = 0
        while iCollectPro_ALIVE() do
            ch = player.Character
            hum = ch and ch:FindFirstChildOfClass("Humanoid")
            hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            local tool, isMelee = pickWeapon()
            if not (hum and hrp and tool) then break end
            local result = chase(target, ch, hum, hrp, tool, isMelee, findFlyGear())
            if (result ~= "hit" and result ~= "locked") or resets >= 3 or not theirRoot(target) then break end
            resets = resets + 1
            hitBtn.Text = "RESETTING"
            setStealStatus((result == "locked" and "STUCK IN A LOCKED BASE" or "ADMIN PANELLED")
                .. " - RESETTING (" .. resets .. "/3)", false)
            local old = player.Character
            pcall(_G.iCollectPro_SemiTP_InstaReset)
            local t0 = os.clock()
            while player.Character == old and os.clock() - t0 < 8 do task.wait(0.1) end
            if player.Character == old then break end
            local nc = player.Character
            if not (nc and nc:WaitForChild("HumanoidRootPart", 6) and nc:WaitForChild("Humanoid", 6)) then break end
            task.wait(0.35)
            if not theirRoot(target) then break end
            setStealStatus("BACK ON " .. string.upper(target.Name), nil)
            hitBtn.Text = "HUNTING"
        end
        pcall(function() player.Character:FindFirstChildOfClass("Humanoid"):UnequipTools() end)
        _G.iCollectPro_SemiTP_Busy = false
        hunting = false
        pendingHome, pendingUntil = home, os.clock() + 3
        hitBtn.Text = "RETURN"
    end
    local function goHome()
        local home = pendingHome
        pendingHome = nil
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (home and hum and hrp) or player:GetAttribute("Stealing") then hitBtn.Text = "HIT" return end
        hunting = true
        hitBtn.Text = "RETURNING"
        _G.iCollectPro_SemiTP_Busy = true
        wear(hum, findFlyGear())
        pcall(flyTo, hrp, function() return home.Position end, 2.5, 8)
        pcall(function()
            hrp.CFrame = home
            hrp.AssemblyLinearVelocity = Vector3.zero
            hum:UnequipTools()
        end)
        _G.iCollectPro_SemiTP_Busy = false
        hunting = false
        hitBtn.Text = "HIT"
    end
    hitBtn.MouseButton1Click:Connect(function()
        if hunting then return end
        if pendingHome then task.spawn(goHome) return end
        if shown then task.spawn(hunt, shown) end
    end)

    task.spawn(function()
        while iCollectPro_ALIVE() do
            local show = false
            local mine = iCollectProFx.thiefBar and findMyBase()
            local myHb = mine and iCollectProAur.hitbox(mine)
            if myHb then
                local now = os.clock()
                local plots = Workspace:FindFirstChild("Plots")
                for _, p in ipairs(Players:GetPlayers()) do
                    local r = p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if r then
                        if iCollectProAur.inBox(myHb, r.Position) then lastIn[p] = now end
                        local st = p:GetAttribute("Stealing")
                        local stealing = st ~= nil and st ~= false
                        if stealing and (thieves[p] or now - (lastIn[p] or -99) < 5) then
                            thieves[p] = true
                        elseif not stealing then
                            thieves[p] = nil
                        end
                        if thieves[p] and not show then
                            show = true
                            shown = p
                            local theirHb
                            for _, pl in ipairs(plots and plots:GetChildren() or {}) do
                                local o = plotOwnerName(pl)
                                if o == p.Name or o == p.DisplayName then theirHb = iCollectProAur.hitbox(pl) break end
                            end
                            local total = theirHb and (theirHb.Position - myHb.Position).Magnitude or 150
                            local done = (r.Position - myHb.Position).Magnitude
                            local frac = math.clamp(done / math.max(total, 1), 0, 1)
                            fill.Size = UDim2.fromScale(frac, 1)
                            pct.Text = math.floor(frac * 100) .. "% TO THEIR BASE"
                            local idx = p:GetAttribute("StealingIndex")
                            title.Text = p.Name .. " STOLE " .. ((idx ~= nil and idx ~= "") and string.upper(tostring(idx)) or "YOUR BRAINROT")
                            barStroke.Transparency = (now % 0.6 < 0.3) and 0.85 or 0.3
                        end
                    end
                end
            end
            if not show and not hunting then shown = nil end
            if pendingHome and not hunting and os.clock() > pendingUntil then
                pendingHome = nil
                hitBtn.Text = "HIT"
            end
            if pendingHome and not show and not hunting then
                title.Text = "TAP RETURN TO FLY BACK"
                pct.Text = ""
            end
            bar.Visible = show or hunting or pendingHome ~= nil
            barScale.Scale = iCollectProUI.uiFactor()
            task.wait(0.1)
        end
        bar:Destroy()
    end)
end)()

;(function()
    local rejoined = false
    task.spawn(function()
        while iCollectPro_ALIVE() do
            if iCollectProFx.rejoin2 and not rejoined then
                local mine = findMyBase()
                local text, n
                if mine then
                    local t, _, _, secs = iCollectProAur.timerState(mine)
                    text, n = t, secs
                end
                if text and n and n > 0 and n <= 2 and not text:find("RELOCK") then
                    rejoined = true
                    pcall(function()
                        player:Kick("⏱  AUTO KICK AT 2s  ⏱\n\n"
                            .. "Your base unlocks in " .. n .. "s\n"
                            .. "You left before anyone could get in.\n"
                            .. "Discord.gg/FreeScripts")
                    end)
                end
            elseif not iCollectProFx.rejoin2 then
                rejoined = false
            end
            task.wait(0.1)
        end
    end)
end)()

;(function()
    local conn
    conn = RunService.Heartbeat:Connect(function(dt)
        if not iCollectPro_ALIVE() then conn:Disconnect() return end
        if not (iCollectProFx.speedOn or iCollectProFx.carpet or iCollectProFx.grav) then return end
        if _G.iCollectPro_SemiTP_Busy or _G.iCollectPro_SemiTP_ResetBusy then return end
        local ch = player.Character
        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
        local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
        if not (hum and hrp) or hum.Health <= 0 then return end
        local st = player:GetAttribute("Stealing")
        local stealing = st ~= nil and st ~= false
        local tool = ch:FindFirstChildOfClass("Tool")
        local fly = false
        if tool then
            local nm = tool.Name:lower()
            for _, k in ipairs(FLY_GEAR_KEYS) do if nm:find(k, 1, true) then fly = true break end end
        end
        local speed
        if not stealing then
            if iCollectProFx.carpet and fly then
                speed = iCollectProUI.num("carpetSpeedValue", 130, 16, 500)
            elseif iCollectProFx.speedOn and not fly then
                speed = player:GetAttribute("GiantPotion") ~= nil and iCollectProUI.num("giantSpeedValue", 30, 16, 60)
                    or iCollectProUI.num("walkSpeedValue", 28, 16, 80)
            end
        end
        local v = hrp.AssemblyLinearVelocity
        local vy = v.Y
        if iCollectProFx.grav and not fly and hum.FloorMaterial == Enum.Material.Air then
            vy = math.clamp(vy, -500, 500) - (iCollectProUI.num("gravityValue", 196.2, 0, 300) - 196.2) * dt
        end
        local md = hum.MoveDirection
        if speed and md.Magnitude > 0 then
            md = md.Unit
            hrp.AssemblyLinearVelocity = Vector3.new(md.X * speed, vy, md.Z * speed)
        elseif speed then
            hrp.AssemblyLinearVelocity = Vector3.new(0, vy, 0)
        elseif vy ~= v.Y then
            hrp.AssemblyLinearVelocity = Vector3.new(v.X, vy, v.Z)
        end
    end)
end)()

;(function()
    local Lighting = game:GetService("Lighting")
    local on, saved, parts, addConn = false, nil, {}, nil
    local FX = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true }
    local function hide(d)
        if FX[d.ClassName] and d.Enabled then
            parts[d] = true
            d.Enabled = false
        end
    end
    local function enable()
        saved = {
            shadows = Lighting.GlobalShadows,
            spec = Lighting.EnvironmentSpecularScale,
            diff = Lighting.EnvironmentDiffuseScale,
        }
        pcall(function() saved.quality = UserSettings():GetService("UserGameSettings").SavedQualityLevel end)
        Lighting.GlobalShadows = false
        Lighting.EnvironmentSpecularScale = 0
        Lighting.EnvironmentDiffuseScale = 0
        pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1 end)
        for _, d in ipairs(Workspace:GetDescendants()) do pcall(hide, d) end
        addConn = Workspace.DescendantAdded:Connect(function(d) pcall(hide, d) end)
    end
    local function disable()
        if addConn then addConn:Disconnect() addConn = nil end
        if saved then
            Lighting.GlobalShadows = saved.shadows
            Lighting.EnvironmentSpecularScale = saved.spec
            Lighting.EnvironmentDiffuseScale = saved.diff
            if saved.quality then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = saved.quality end) end
        end
        for d in pairs(parts) do pcall(function() if d.Parent then d.Enabled = true end end) end
        table.clear(parts)
    end
    task.spawn(function()
        while iCollectPro_ALIVE() do
            if iCollectProFx.fps and not on then on = true pcall(enable)
            elseif not iCollectProFx.fps and on then on = false pcall(disable) end
            if on then Lighting.GlobalShadows = false end
            task.wait(1)
        end
        if on then pcall(disable) end
    end)
end)()

;(function()
    local W, H = 520, 46
    local bar = Instance.new("Frame")
    bar.Name = "PillBar"
    bar.AnchorPoint = Vector2.new(0.5, 1)
    bar.Size = UDim2.fromOffset(W, H)
    bar.Position = UDim2.new(0.5, 0, 1, -100)
    bar.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
    bar.BorderSizePixel = 0
    bar.ZIndex = 60
    bar.Parent = ProgressGui
    local scale = Instance.new("UIScale")
    scale.Parent = bar
    local function rescale()
        local cam = Workspace.CurrentCamera
        local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local s = math.min(iCollectProUI.uiFactor(), vp.X * 0.94 / W)
        scale.Scale = math.clamp(s, 0.4, 1.25)
    end
    rescale()
    if Workspace.CurrentCamera then Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(rescale) end

    corner(bar, 13)
    stroke(bar, T.STROKE, 1, 0.18)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 22, 44)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(22, 17, 34)),
        ColorSequenceKeypoint.new(0.72, Color3.fromRGB(16, 12, 26)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(23, 18, 36)),
    })
    g.Parent = bar

    local function make(class, props)
        local o = Instance.new(class)
        for k, v in pairs(props) do o[k] = v end
        o.Parent = bar
        return o
    end
    make("Frame", { Name = "Sheen", Position = UDim2.new(0, 14, 0, 3), Size = UDim2.new(1, -28, 0, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BackgroundTransparency = 0.95, BorderSizePixel = 0, ZIndex = 63 })
    local dot = make("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0, 22, 0.5, 0), Size = UDim2.fromOffset(9, 9),
        BackgroundColor3 = T.STROKE, BorderSizePixel = 0, ZIndex = 62 })
    corner(dot, 5)
    stroke(dot, Color3.fromRGB(190, 140, 255), 1, 0.35)
    local function label(x, y, w, h, text, size, font, col, align)
        local l = make("TextLabel", { BackgroundTransparency = 1, Position = UDim2.new(0, x, 0, y), Size = UDim2.new(0, w, h == 0 and 1 or 0, h),
            Font = font, Text = text, TextSize = size, TextColor3 = col, TextXAlignment = align or Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center, ZIndex = 62 })
        l.AutoLocalize = false
        return l
    end
    local title = label(38, 0, 130, 0, "PURPLE HUB", 15, Enum.Font.GothamBold, Color3.fromRGB(245, 246, 248))
    title.TextStrokeTransparency = 0.92
    local invite = label(186, 0, 182, 0, "DISCORD.GG/FREESCRIPTS", 15, Enum.Font.GothamBlack, Color3.fromRGB(255, 255, 255), Enum.TextXAlignment.Center)
    invite.TextScaled = true
    local cap = Instance.new("UITextSizeConstraint")
    cap.MaxTextSize = 15
    cap.Parent = invite
    invite.TextStrokeColor3 = Color3.fromRGB(40, 14, 70)
    invite.TextStrokeTransparency = 0.4
    local shine = Instance.new("UIGradient")
    shine.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 45, 210)),
        ColorSequenceKeypoint.new(0.35, Color3.fromRGB(200, 130, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(200, 130, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(140, 45, 210)),
    })
    shine.Parent = invite
    for _, x in ipairs({ 180, 374, 450 }) do
        make("Frame", { Position = UDim2.new(0, x, 0.5, -11), Size = UDim2.fromOffset(1, 22),
            BackgroundColor3 = Color3.fromRGB(110, 60, 170), BackgroundTransparency = 0.15, BorderSizePixel = 0, ZIndex = 62 })
    end
    label(388, 8, 50, 10, "FPS", 9.5, Enum.Font.GothamBold, T.DIM)
    local fps = label(388, 20, 52, 17, "0", 15, Enum.Font.GothamBold, Color3.fromRGB(190, 140, 255))
    label(462, 8, 50, 10, "PING", 9.5, Enum.Font.GothamBold, T.DIM)
    local ping = label(462, 20, 52, 17, "0ms", 15, Enum.Font.GothamBold, Color3.fromRGB(190, 140, 255))

    local GOOD, OK, BAD = Color3.fromRGB(56, 214, 110), Color3.fromRGB(255, 165, 0), Color3.fromRGB(220, 60, 60)
    local frames, lastT, t0 = 0, os.clock(), os.clock()
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if not iCollectPro_ALIVE() then conn:Disconnect() bar:Destroy() return end
        bar.Visible = iCollectProFx.pillBar
        if not iCollectProFx.pillBar then return end
        frames = frames + 1
        local now = os.clock()
        shine.Offset = Vector2.new((now - t0) * 0.35 % 2 - 1, 0)
        if now - lastT >= 1 then
            fps.Text = tostring(frames)
            fps.TextColor3 = frames >= 60 and GOOD or (frames >= 30 and OK or BAD)
            frames, lastT = 0, now
            local okP, p = pcall(function() return math.floor(player:GetNetworkPing() * 1000) end)
            if okP then
                ping.Text = p .. "ms"
                ping.TextColor3 = p < 80 and GOOD or (p < 150 and OK or BAD)
            end
        end
    end)
end)()
end)()

;(function()
    function iCollectProUI.waitOwnerLeave(pod, ctx)
        local name = plotOwnerName(pod.plot)
        local owner
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name == name or p.DisplayName == name then owner = p end
        end
        if not owner then return true end
        setStealStatus("WAITING FOR " .. string.upper(owner.Name) .. " TO LEAVE", nil)
        local left = false
        local conn = Players.PlayerRemoving:Connect(function(p) if p == owner then left = true end end)
        iCollectProUI.bypassWaiting = true
        local t0 = os.clock()
        while iCollectPro_ALIVE() and not left and iCollectProUI.bypassWaiting and iCollectProFx.defBypass and os.clock() - t0 < 120 do
            local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
            if not hum or hum.Health <= 0 or not pod.prompt.Parent or not owner.Parent then
                left = not owner.Parent
                break
            end
            if tick() - (ctx.holdBeganAt or 0) >= 2.4 then
                for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
                ctx.holdBeganAt = tick()
                ctx.ragdollFireTime = ctx.holdBeganAt
            end
            task.wait()
        end
        conn:Disconnect()
        iCollectProUI.bypassWaiting = false
        if not left then setStealStatus("BYPASS CANCELLED", false) end
        return left
    end

    local function blocked()
        local t = player:GetAttribute("RagdollEndTime")
        return player:GetAttribute("BlockTools") == true or player:GetAttribute("Ragdoll") == true
            or (type(t) == "number" and t > Workspace:GetServerTimeNow())
    end
    local function nearestPrompt(hrp, maxD)
        local plots = Workspace:FindFirstChild("Plots")
        local best, bestD = nil, maxD
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            local pods = isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums")
            for _, pd in ipairs(pods and pods:GetChildren() or {}) do
                local spawn, prompt = podiumParts(pd)
                if spawn and prompt and prompt.Enabled then
                    local d = (spawn.Position - hrp.Position).Magnitude
                    if d <= bestD then best, bestD = prompt, d end
                end
            end
        end
        return best, bestD
    end
    local BANK, RANGE = 25, 9.5
    local bank = { prompt = nil, ctx = nil, inRange = false, lastFire = 0, fired = nil }
    task.spawn(function()
        while iCollectPro_ALIVE() do
            task.wait(0.03)
            local st = player:GetAttribute("Stealing")
            local stealing = st ~= nil and st ~= false
            if stealing and bank.fired then
                iCollectPro.log(string.format("PUBLIC GRAB: grabbed %.2fs after the grab fired  (hold %.2fs old, begun %s range)",
                    os.clock() - bank.fired.at, bank.fired.age, bank.fired.beganIn and "IN" or "OUT OF"))
                bank.fired = nil
            end
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not (iCollectProFx.pubGrab and not iCollectProFx.quickGrab and hrp) or stealing or blocked()
                or iCollectPro.debounce or _G.iCollectPro_SemiTP_Busy then
                bank.prompt, bank.ctx = nil, nil
                continue
            end
            local prompt, d = nearestPrompt(hrp, BANK)
            local inR = prompt ~= nil and d <= RANGE
            if prompt ~= bank.prompt then
                bank.prompt, bank.inRange, bank.beganIn = prompt, inR, inR
                bank.ctx = prompt and iCollectProHold.startStealHold(prompt) or nil
                if prompt and not bank.ctx and fireproximityprompt and inR then pcall(fireproximityprompt, prompt) end
            elseif prompt and bank.ctx then
                local ctx = bank.ctx
                local age = tick() - (ctx.holdBeganAt or 0)
                local need = (tonumber(prompt.HoldDuration) or 1.5) + 0.05
                if inR and age >= need and age <= 2.5 and os.clock() - bank.lastFire >= 0.15 then
                    bank.lastFire = os.clock()
                    bank.fired = { at = os.clock(), age = age, beganIn = bank.beganIn }
                    for _, fn in ipairs(ctx.cb.trigger) do task.spawn(fn) end
                end
                if (inR and not bank.inRange) or age >= 2.4 then
                    for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
                    ctx.holdBeganAt = tick()
                    bank.beganIn = inR
                end
                bank.inRange = inR
            end
        end
    end)

    ;(function()
        local REACH, ENTRY_WINDOW, GATE, REGRAB_WINDOW = 12, 1.0, 0.06, 12
        local ARM, RANGE = 40, 10
        iCollectPro.qgMaxAge = iCollectPro.qgMaxAge or 2.4
        local qgFired, qgBegan, fellBack = nil, "OUT OF", false
        local info = setmetatable({}, { __mode = "k" })
        local target, since, lastPress, holdPrompt = nil, 0, 0, nil
        local dropPrompt, dropAt, wasStealing = nil, 0, false
        local underSlot, underAt, cands, candAt = nil, 0, {}, 0
        local rp = RaycastParams.new()
        rp.FilterType = Enum.RaycastFilterType.Exclude

        local function infoOf(prompt)
            local i = info[prompt]
            if i then return i end
            local spawn = prompt.Parent and prompt.Parent.Parent
            local pod = spawn and spawn.Parent and spawn.Parent.Parent
            local plot = pod and pod.Parent and pod.Parent.Parent
            local root = plot and plot:FindFirstChild("MainRoot")
            if not (spawn and spawn:IsA("BasePart") and root) then return nil end
            i = { spawn = spawn, pod = pod, plot = plot, root = root, relZ = root.CFrame:PointToObjectSpace(spawn.Position).Z }
            info[prompt] = i
            return i
        end
        local function scan()
            table.clear(cands)
            local plots = Workspace:FindFirstChild("Plots")
            for _, plot in ipairs(plots and plots:GetChildren() or {}) do
                local pods = isEnemyPlot(plot) and plot:FindFirstChild("AnimalPodiums")
                for _, pd in ipairs(pods and pods:GetChildren() or {}) do
                    local _, prompt = podiumParts(pd)
                    if prompt then cands[#cands + 1] = prompt end
                end
            end
        end
        local function slotUnder(ch, hrp)
            rp.FilterDescendantsInstances = { ch }
            local hit = Workspace:Raycast(hrp.Position, Vector3.new(0, -7, 0), rp)
            local p = hit and hit.Instance
            while p and p ~= Workspace do
                if p.Parent and p.Parent.Name == "AnimalPodiums" then return p end
                p = p.Parent
            end
            return nil
        end
        local function press(p)
            lastPress = os.clock()
            pcall(fireproximityprompt, p, 0)
        end

        local spotRp = RaycastParams.new()
        spotRp.FilterType = Enum.RaycastFilterType.Exclude
        function iCollectPro.enemyPromptAt(pos)
            local skip = {}
            for _, pl in ipairs(Players:GetPlayers()) do
                if pl.Character then skip[#skip + 1] = pl.Character end
            end
            spotRp.FilterDescendantsInstances = skip
            local hit = Workspace:Raycast(pos, Vector3.new(0, -7, 0), spotRp)
            local p = hit and hit.Instance
            while p and p ~= Workspace do
                if p.Parent and p.Parent.Name == "AnimalPodiums" then break end
                p = p.Parent
            end
            local plot = p and p ~= Workspace and p.Parent and p.Parent.Parent
            local _, prompt = podiumParts(p ~= Workspace and p or nil)
            if prompt and isEnemyPlot(plot) then return prompt end
            return nil
        end

        function iCollectPro.grabUnderFeet(secs, prompt, ctx)
            if prompt then
                pcall(function()
                    prompt.RequiresLineOfSight = false
                    prompt.MaxActivationDistance = math.huge
                end)
            end
            local need = prompt and (tonumber(prompt.HoldDuration) or 1.3) + 0.05 or 1.35
            local t0, lastFire, lastSig, anchor = os.clock(), 0, 0, nil
            while iCollectPro_ALIVE() and os.clock() - t0 < (secs or 2) do
                local st = player:GetAttribute("Stealing")
                if st ~= nil and st ~= false then return true end
                local ch = player.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                if not hrp then return false end
                anchor = anchor or hrp.Position
                if (hrp.Position - anchor).Magnitude > 6 then return false end
                local p = prompt
                if not p then
                    local pod = slotUnder(ch, hrp)
                    local plot = pod and pod.Parent and pod.Parent.Parent
                    local _, pr = podiumParts(pod)
                    if pr and isEnemyPlot(plot) then p = pr end
                end
                if ctx then
                    local age = tick() - (ctx.holdBeganAt or 0)
                    if age >= 2.4 then
                        for _, fn in ipairs(ctx.cb.hold) do task.spawn(fn) end
                        ctx.holdBeganAt = tick()
                    elseif age >= need and os.clock() - lastFire >= 0.15 then
                        lastFire = os.clock()
                        for _, fn in ipairs(ctx.cb.trigger) do task.spawn(fn) end
                    end
                end
                if p and p.Parent and p.Enabled and fireproximityprompt then
                    press(p)
                elseif p and p.Parent and firesignal and os.clock() - lastSig >= 0.1 then
                    lastSig = os.clock()
                    pcall(firesignal, p.Triggered, player)
                end
                RunService.Heartbeat:Wait()
            end
            return false
        end

        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not iCollectPro_ALIVE() then conn:Disconnect() return end
            local st = player:GetAttribute("Stealing")
            local stealing = st ~= nil and st ~= false
            local now = os.clock()
            if stealing and not wasStealing then
                holdPrompt = target
                if qgFired then
                    local age = qgFired.age
                    iCollectPro.log(string.format("QUICK GRAB: grabbed %.2fs after the grab fired  (hold %.2fs old, begun %s range)",
                        now - qgFired.at, age, tostring(qgFired.began)))
                    if age > iCollectPro.qgMaxAge then iCollectPro.qgMaxAge = math.min(age, 6) end
                end
                qgFired = nil
            end
            if not stealing and wasStealing and holdPrompt then dropPrompt, dropAt = holdPrompt, now end
            wasStealing = stealing
            if not iCollectProFx.quickGrab then target, qgFired = nil, nil return end
            if stealing or ((_G.iCollectPro_SemiTP_Busy or iCollectPro.debounce) and not iCollectPro.upperGrab) then target = nil return end
            local ch = player.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            if dropPrompt and now - dropAt < REGRAB_WINDOW and dropPrompt.Parent and not dropPrompt.Enabled then
                local i = infoOf(dropPrompt)
                if i and (i.spawn.Position - hrp.Position).Magnitude <= REACH and firesignal then
                    pcall(firesignal, dropPrompt.Triggered, player)
                    return
                end
            elseif dropPrompt and (now - dropAt >= REGRAB_WINDOW or dropPrompt.Enabled) then
                dropPrompt = nil
            end

            if now - candAt > 1 then candAt = now scan() end
            if now - underAt > 0.05 then underAt = now underSlot = slotUnder(ch, hrp) end
            local best, bestD, arm, armD = nil, REACH, nil, ARM
            for _, p in ipairs(cands) do
                local i = p.Parent and p.Enabled and infoOf(p)
                if i then
                    local d = (i.spawn.Position - hrp.Position).Magnitude
                    if d <= armD then arm, armD = p, d end
                    if (underSlot == nil or i.pod == underSlot) and d <= bestD then best, bestD = p, d end
                end
            end
            if best ~= target then target, since, fellBack, qgFired = best, now, false, nil end
            local cb = arm and iCollectProStealCallbacks(arm)
            local tcb = target and iCollectProStealCallbacks(target)
            if not (cb and tcb) then
                if target and fireproximityprompt and now - lastPress >= ((now - since < ENTRY_WINDOW) and 0 or GATE) then press(target) end
                return
            end
            local age = tick() - iCollectProHold.lastHold
            local need = (tonumber(target and target.HoldDuration) or 1.5) + 0.05
            local upper = iCollectPro.upperGrab
            if not upper then
                local eta = 0
                if bestD > RANGE or not target then
                    local sp = infoOf(target or arm)
                    local dir = sp and (sp.spawn.Position - hrp.Position) or Vector3.zero
                    local v = hrp.AssemblyLinearVelocity
                    local toward = dir.Magnitude > 0 and v:Dot(dir.Unit) or 0
                    eta = (((target and bestD) or armD) - RANGE) / math.max(toward, 8)
                end
                if age + eta > iCollectPro.qgMaxAge then
                    for _, fn in ipairs(cb.hold) do task.spawn(fn) end
                    age, qgBegan = 0, (bestD <= RANGE and target) and "IN" or "OUT OF"
                end
            end
            if not target then return end
            if age >= need and age <= iCollectPro.qgMaxAge + 0.3 and now - lastPress >= 0.1 then
                lastPress = now
                if not qgFired then qgFired = { at = now, age = age, began = qgBegan } end
                for _, fn in ipairs(tcb.trigger) do task.spawn(fn) end
            end
            if not upper and not fellBack and bestD <= 8.5 and qgFired and now - qgFired.at >= 0.35 then
                fellBack = true
                for _, fn in ipairs(tcb.hold) do task.spawn(fn) end
                qgBegan, qgFired = "IN (fallback)", nil
                iCollectPro.log("QUICK GRAB: banked hold didn't take - hold begun again in range")
            end
        end)
    end)()

    local FOV_BIND = "iCollectProSemiTPFov"
    local fovWas = false
    pcall(RunService.UnbindFromRenderStep, RunService, FOV_BIND)
    RunService:BindToRenderStep(FOV_BIND, Enum.RenderPriority.Camera.Value + 1, function()
        if not iCollectPro_ALIVE() then pcall(RunService.UnbindFromRenderStep, RunService, FOV_BIND) return end
        local cam = Workspace.CurrentCamera
        if not cam then return end
        if iCollectProFx.fov then
            fovWas = true
            cam.FieldOfView = iCollectProUI.num("fovValue", 80, 30, 120)
        elseif fovWas then
            fovWas = false
            cam.FieldOfView = 70
        end
    end)

    ;(function()
        local Lighting = game:GetService("Lighting")
        local saved, conns, on = {}, {}, false
        local POST = { BloomEffect = true, BlurEffect = true, SunRaysEffect = true, DepthOfFieldEffect = true, ColorCorrectionEffect = true, Atmosphere = false }
        local function keep(d, prop, value)
            local s = saved[d]
            if not s then s = {} saved[d] = s end
            if s[prop] == nil then s[prop] = d[prop] end
            d[prop] = value
        end
        local function ours(d)
            local p = d
            for _ = 1, 3 do
                if not p then return false end
                if p.Name:sub(1, 11) == "iCollectPro" then return true end
                p = p.Parent
            end
            return false
        end
        local function strip(d)
            if ours(d) then return end
            if d:IsA("Decal") then keep(d, "Transparency", 1)
            elseif d:IsA("SurfaceAppearance") then
                local s = saved[d] or {}
                saved[d] = s
                if s.Parent == nil then s.Parent = d.Parent end
                d.Parent = nil
            elseif d:IsA("MeshPart") then
                if d.TextureID ~= "" then keep(d, "TextureID", "") end
                if d.Material ~= Enum.Material.SmoothPlastic then keep(d, "Material", Enum.Material.SmoothPlastic) end
            elseif d:IsA("SpecialMesh") then
                if d.TextureId ~= "" then keep(d, "TextureId", "") end
            elseif d:IsA("BasePart") then
                if d.Material ~= Enum.Material.SmoothPlastic then keep(d, "Material", Enum.Material.SmoothPlastic) end
            elseif d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Beam") or d:IsA("Smoke") or d:IsA("Fire") or d:IsA("Sparkles") then
                if d.Enabled then keep(d, "Enabled", false) end
            elseif POST[d.ClassName] and d.Parent == Lighting then
                keep(d, "Enabled", false)
            end
        end
        local function quiet(char)
            local hum = char and char:WaitForChild("Humanoid", 5)
            local anim = hum and hum:WaitForChild("Animator", 5)
            if not anim then return end
            for _, tr in ipairs(anim:GetPlayingAnimationTracks()) do pcall(function() tr:Stop(0) end) end
            conns[#conns + 1] = anim.AnimationPlayed:Connect(function(tr)
                if on then pcall(function() tr:Stop(0) end) end
            end)
        end
        local function enable()
            keep(Lighting, "GlobalShadows", false)
            keep(Lighting, "EnvironmentDiffuseScale", 0)
            keep(Lighting, "EnvironmentSpecularScale", 0)
            pcall(function()
                local gs = UserSettings():GetService("UserGameSettings")
                saved.__quality = saved.__quality or gs.SavedQualityLevel
                gs.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
            end)
            for _, d in ipairs(Lighting:GetChildren()) do pcall(strip, d) end
            local all = Workspace:GetDescendants()
            for i, d in ipairs(all) do
                pcall(strip, d)
                if i % 4000 == 0 then task.wait() end
            end
            conns[#conns + 1] = Workspace.DescendantAdded:Connect(function(d)
                if on then task.defer(function() pcall(strip, d) end) end
            end)
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= player then
                    task.spawn(quiet, p.Character)
                    conns[#conns + 1] = p.CharacterAdded:Connect(function(c) if on then quiet(c) end end)
                end
            end
            conns[#conns + 1] = Players.PlayerAdded:Connect(function(p)
                conns[#conns + 1] = p.CharacterAdded:Connect(function(c) if on then quiet(c) end end)
            end)
        end
        local function disable()
            for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
            table.clear(conns)
            local q = saved.__quality
            saved.__quality = nil
            if q then pcall(function() UserSettings():GetService("UserGameSettings").SavedQualityLevel = q end) end
            for d, props in pairs(saved) do
                for prop, v in pairs(props) do
                    pcall(function() d[prop] = v end)
                end
            end
            table.clear(saved)
        end
        task.spawn(function()
            while iCollectPro_ALIVE() do
                if iCollectProFx.xfps and not on then on = true pcall(enable)
                elseif not iCollectProFx.xfps and on then on = false pcall(disable) end
                task.wait(1)
            end
            if on then on = false pcall(disable) end
        end)
    end)()

    ;(function()
        local hidden = {}
        local function widgetOf(img)
            local g = img
            while g.Parent and g.Parent.Parent and g.Parent.Parent.Name ~= "Holders" do g = g.Parent end
            return (g.Parent and g.Parent.Parent and g.Parent.Parent.Name == "Holders") and g or nil
        end
        task.spawn(function()
            while iCollectPro_ALIVE() do
                local tb = player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("TopbarStandard")
                if iCollectProFx.hideAP and tb then
                    for _, d in ipairs(tb:GetDescendants()) do
                        if d.Name == "IconImage" and (d:IsA("ImageLabel") or d:IsA("ImageButton"))
                            and tostring(d.Image):find("95529031547606", 1, true) then
                            local w = widgetOf(d)
                            if w and w:IsA("GuiObject") then
                                if hidden[w] == nil then hidden[w] = w.Visible end
                                w.Visible = false
                            end
                        end
                    end
                elseif not iCollectProFx.hideAP and next(hidden) then
                    for w, v in pairs(hidden) do pcall(function() w.Visible = v end) end
                    table.clear(hidden)
                end
                task.wait(0.5)
            end
            for w, v in pairs(hidden) do pcall(function() w.Visible = v end) end
        end)
    end)()
end)()

;(function()
if not iCollectPro_ALIVE() then return end

local LP = player
local ENV = iCollectPro_ENV
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local PPS = game:GetService("ProximityPromptService")
local StatsService = game:GetService("Stats")
local MB1, TOUCH, MOVE = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement

for _, g in ipairs({ ScreenGui, ProgressGui, SpeedScreenGui, AllowDisallowGui }) do
    pcall(function() g.Enabled = false end)
end
pcall(function() if ENV.__iCPAuroraUnload then ENV.__iCPAuroraUnload() end end)

local AC = type(HubConfig.aurora) == "table" and HubConfig.aurora or {}
HubConfig.aurora = AC
AC.pos = type(AC.pos) == "table" and AC.pos or {}
AC.keys = type(AC.keys) == "table" and AC.keys or {}
if not AC.keysInit then
    AC.keysInit = true
    AC.keys.menu = "LeftControl"
    AC.keys.hide = "RightControl"
end

local U, F = {}, {}
local R = { sg = {}, tg = {}, fg = {}, bg1 = {}, bg2 = {}, tx1 = {}, tx2 = {}, bars = {},
    texts = setmetatable({}, { __mode = "k" }), wins = {}, rows = {}, conns = {}, cleanup = {} }

function U.get(k, d) local v = AC[k] if v == nil then return d end return v end
function U.set(k, v) AC[k] = v saveHubConfig() end
function U.on(sig, fn) local c = sig:Connect(fn) R.conns[#R.conns + 1] = c return c end

local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local function toT(c) return { math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5) } end
local function fromT(t, d) if type(t) == "table" and #t == 3 then return rgb(t[1], t[2], t[3]) end return d end

local C = {
    WIN = rgb(24, 25, 30), CARD = rgb(31, 33, 38), ELEM = rgb(40, 42, 49), SEP = rgb(46, 48, 54),
    TEXT = rgb(236, 237, 242), DIM = rgb(161, 164, 176), WHITE = rgb(255, 255, 255),
    A1 = rgb(110, 0, 178), A2 = rgb(114, 0, 255),
    GOOD = rgb(96, 214, 138), WARN = rgb(255, 205, 90), BAD = rgb(255, 110, 130),
    GOLD = rgb(255, 219, 115), OPEN = rgb(120, 255, 150),
}
C.A1 = fromT(AC.accent1, C.A1)
C.A2 = fromT(AC.accent2, C.A2)

local function new(class, props, parent)
    local o = Instance.new(class)
    if props then for k, v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end

function U.seq2() return ColorSequence.new(C.A1, C.A2) end
function U.seq3()
    return ColorSequence.new({ ColorSequenceKeypoint.new(0, C.A1), ColorSequenceKeypoint.new(0.5, C.A2), ColorSequenceKeypoint.new(1, C.A1) })
end
function U.round(o, r, scale) return new("UICorner", { CornerRadius = scale and UDim.new(r, 0) or UDim.new(0, r) }, o) end
function U.stroke(o, t)
    local s = new("UIStroke", { Color = C.WHITE, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o)
    R.sg[#R.sg + 1] = new("UIGradient", { Color = U.seq2() }, s)
    return s
end
function U.tgrad(o) local g = new("UIGradient", { Color = U.seq3() }, o) R.tg[#R.tg + 1] = g return g end
function U.pad(o, l, r, t, b)
    return new("UIPadding", { PaddingLeft = UDim.new(0, l or 0), PaddingRight = UDim.new(0, r or l or 0),
        PaddingTop = UDim.new(0, t or 0), PaddingBottom = UDim.new(0, b or t or 0) }, o)
end
function U.list(o, gap, dir)
    return new("UIListLayout", { Padding = UDim.new(0, gap or 0), SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = dir or Enum.FillDirection.Vertical }, o)
end

local FONTS = {
    { "Gotham", Enum.Font.Gotham }, { "Source Sans", Enum.Font.SourceSans }, { "Arial", Enum.Font.Arial },
    { "Roboto", Enum.Font.Roboto }, { "Roboto Mono", Enum.Font.RobotoMono }, { "Ubuntu", Enum.Font.Ubuntu },
    { "Nunito", Enum.Font.Nunito }, { "Merriweather", Enum.Font.Merriweather }, { "Oswald", Enum.Font.Oswald },
    { "Code", Enum.Font.Code }, { "Highway", Enum.Font.Highway }, { "Garamond", Enum.Font.Garamond },
    { "Fantasy", Enum.Font.Fantasy }, { "Antique", Enum.Font.Antique },
}
local WR, WM, WB = Enum.FontWeight.Regular, Enum.FontWeight.Medium, Enum.FontWeight.Bold
U.family = Font.fromEnum(Enum.Font.Gotham).Family
function U.setFont(name)
    local e = Enum.Font.Gotham
    for _, f in ipairs(FONTS) do if f[1] == name then e = f[2] end end
    U.family = Font.fromEnum(e).Family
    for o, w in pairs(R.texts) do pcall(function() o.FontFace = Font.new(U.family, w) end) end
end
U.setFont(U.get("font", "Gotham"))

function U.text(class, parent, text, size, weight, color, xa)
    local o = new(class, { BackgroundTransparency = 1, BorderSizePixel = 0, Text = text or "", TextSize = size or 13,
        TextColor3 = color or C.TEXT, TextXAlignment = xa or Enum.TextXAlignment.Left,
        FontFace = Font.new(U.family, weight or WR) }, parent)
    if class == "TextButton" then o.AutoButtonColor = false end
    R.texts[o] = weight or WR
    return o
end
function U.hit(parent, z)
    return new("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.fromScale(1, 1), AutoButtonColor = false, ZIndex = z or 2 }, parent)
end

local gui = new("ScreenGui", { Name = HttpService:GenerateGUID(false), ResetOnSpawn = false, IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 1000 })
if not pcall(function() gui.Parent = gethui() end) or not gui.Parent then gui.Parent = safeGuiTarget end
local root = new("Frame", { Name = "Root", BackgroundTransparency = 1, Size = UDim2.fromOffset(1745, 960) }, gui)
local uiScale = new("UIScale", {}, root)
function U.fit()
    local cam = Workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local s = math.max(vp.Y / 960, 0.45)
    if vp.X / s < 760 then s = vp.X / 760 end
    uiScale.Scale = s
    root.Size = UDim2.fromOffset(vp.X / s, vp.Y / s)
end
U.fit()
U.on(Workspace:GetPropertyChangedSignal("CurrentCamera"), function()
    U.fit()
    if Workspace.CurrentCamera then U.on(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), U.fit) end
end)
if Workspace.CurrentCamera then U.on(Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"), U.fit) end
function U.toRoot(v) return (v - root.AbsolutePosition) / uiScale.Scale end

U.locked = U.get("guiLock", false)
function U.savePos(key, f)
    local p = f.Position
    AC.pos[key] = { p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset }
    saveHubConfig()
end
function U.loadPos(key, f)
    local p = AC.pos[key]
    if type(p) == "table" and #p == 4 then f.Position = UDim2.new(p[1], p[2], p[3], p[4]) end
end
function U.drag(handle, target, key, onClick)
    handle.InputBegan:Connect(function(i)
        if i.UserInputType ~= MB1 and i.UserInputType ~= TOUCH then return end
        local start, pos, moved = i.Position, target.Position, false
        local mv = UserInputService.InputChanged:Connect(function(j)
            if j.UserInputType == MOVE or j == i then
                local d = (j.Position - start) / uiScale.Scale
                if math.abs(d.X) + math.abs(d.Y) > 4 then moved = true end
                if moved and not U.locked then
                    target.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
                end
            end
        end)
        local ec
        ec = i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                mv:Disconnect() ec:Disconnect()
                if moved and key and not U.locked then U.savePos(key, target) end
                if not moved and onClick then onClick() end
            end
        end)
    end)
end

function U.panel(parent, size, pos, anchor, bgT, radius, key, strokeT)
    local f = new("Frame", { Size = size, Position = pos, AnchorPoint = anchor or Vector2.zero, BackgroundColor3 = C.WIN,
        BackgroundTransparency = bgT or 0, BorderSizePixel = 0, Active = true }, parent or root)
    U.round(f, radius or 16)
    U.stroke(f, strokeT or 1.4)
    R.wins[#R.wins + 1] = { f = f, base = bgT or 0 }
    if key then U.loadPos(key, f) end
    return f
end
function U.applyTransparency()
    local p = math.clamp((tonumber(U.get("guiT", 0)) or 0) / 100, 0, 0.95)
    for _, w in ipairs(R.wins) do
        if w.f.Parent then w.f.BackgroundTransparency = w.base + (1 - w.base) * p end
    end
end

function U.header(f, title, h, ts, key)
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, h), BackgroundTransparency = 1 }, f)
    U.pad(hd, 10, 10)
    local t = U.text("TextLabel", hd, title, ts, WB, C.WHITE)
    t.Size = UDim2.new(1, -110, 1, 0)
    U.tgrad(t)
    local btns = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0),
        Size = UDim2.fromOffset(168, 30), BackgroundTransparency = 1 }, hd)
    local l = U.list(btns, 7, Enum.FillDirection.Horizontal)
    l.HorizontalAlignment = Enum.HorizontalAlignment.Right
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    U.drag(hd, f, key)
    return hd, btns, t
end
function U.hbtn(btns, text, order, fn)
    local b = U.text("TextButton", btns, text, 14, WB, C.DIM, Enum.TextXAlignment.Center)
    b.Size = UDim2.fromOffset(22, 22)
    b.LayoutOrder = order
    b.MouseButton1Click:Connect(fn)
    return b
end
function U.resizer(f, minW, minH, key, size)
    local b = new("TextButton", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -3, 1, -3), Size = UDim2.fromOffset(size or 16, size or 16),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 6 }, f)
    for _, s in ipairs({ { (size or 16) - 4, 2 }, { 2, (size or 16) - 4 } }) do
        U.round(new("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.fromScale(1, 1), Size = UDim2.fromOffset(s[1], s[2]),
            BackgroundColor3 = C.DIM, BorderSizePixel = 0 }, b), 1)
    end
    if type(AC.size) == "table" and type(AC.size[key]) == "table" then
        f.Size = UDim2.fromOffset(AC.size[key][1], AC.size[key][2])
    end
    b.InputBegan:Connect(function(i)
        if i.UserInputType ~= MB1 and i.UserInputType ~= TOUCH then return end
        local start, sz = i.Position, f.Size
        local mv = UserInputService.InputChanged:Connect(function(j)
            if (j.UserInputType == MOVE or j == i) and not U.locked then
                local d = (j.Position - start) / uiScale.Scale
                f.Size = UDim2.fromOffset(math.max(minW, sz.X.Offset + d.X), math.max(minH, sz.Y.Offset + d.Y))
            end
        end)
        local ec
        ec = i.Changed:Connect(function()
            if i.UserInputState == Enum.UserInputState.End then
                mv:Disconnect() ec:Disconnect()
                if key then
                    AC.size = type(AC.size) == "table" and AC.size or {}
                    AC.size[key] = { f.Size.X.Offset, f.Size.Y.Offset }
                    saveHubConfig()
                end
            end
        end)
    end)
    return b
end

function U.scroller(parent, pos, size, pad, gap)
    local s = new("ScrollingFrame", { Position = pos, Size = size, BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = C.A1, CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollingDirection = Enum.ScrollingDirection.Y }, parent)
    R.bars[#R.bars + 1] = s
    U.pad(s, pad or 10, pad or 10, pad or 10, pad or 10)
    U.list(s, gap or 8)
    return s
end

local ORDER = 0
local function nxt() ORDER = ORDER + 1 return ORDER end

function U.card(parent, title)
    local f = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.CARD,
        BorderSizePixel = 0, LayoutOrder = nxt() }, parent)
    U.round(f, 10) U.stroke(f, 1) U.list(f, 7) U.pad(f, 10, 10, 10, 10)
    if title then
        local l = U.text("TextLabel", f, title, 11, WB, C.WHITE)
        l.Size = UDim2.new(1, 0, 0, 16)
        l.LayoutOrder = 0
        U.tgrad(l)
    end
    return f
end
function U.row(parent, h, bg)
    local r = new("Frame", { Size = UDim2.new(1, 0, 0, h or 34), BackgroundColor3 = bg or C.CARD, BorderSizePixel = 0, LayoutOrder = nxt() }, parent)
    U.round(r, 10) U.stroke(r, 1) U.pad(r, 10, 10)
    return r
end
function U.switch(parent, on)
    local sw = new("Frame", { AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, 0, 0.5, 0), Size = UDim2.fromOffset(40, 20),
        BackgroundColor3 = C.ELEM, BorderSizePixel = 0 }, parent)
    U.round(sw, 10)
    local g = new("UIGradient", { Color = U.seq2() }, sw)
    R.fg[#R.fg + 1] = g
    local st = new("UIStroke", { Color = C.DIM, Thickness = 1, Transparency = 0.6 }, sw)
    local knob = new("Frame", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 2, 0.5, 0), Size = UDim2.fromOffset(16, 16),
        BackgroundColor3 = C.TEXT, BorderSizePixel = 0 }, sw)
    U.round(knob, 10)
    return function(v, instant)
        TweenService:Create(knob, TweenInfo.new(instant and 0 or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            { Position = v and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0) }):Play()
        sw.BackgroundColor3 = v and C.A1 or C.ELEM
        g.Enabled = v and true or false
        st.Transparency = v and 1 or 0.6
    end
end

local binds, listening = {}, nil
function U.shortKey(k)
    local m = { LeftControl = "LCtrl", RightControl = "RCtrl", LeftShift = "LShift", RightShift = "RShift",
        LeftAlt = "LAlt", RightAlt = "RAlt", Backquote = "`" }
    return m[k] or k
end
function U.chip(parent, name, fn)
    local b = U.text("TextButton", parent, "", 10, WB, C.DIM, Enum.TextXAlignment.Center)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, -46, 0.5, 0)
    b.Size = UDim2.fromOffset(30, 18)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    b.ZIndex = 3
    U.round(b, 0.5, true) U.stroke(b, 1)
    binds[name] = fn
    local function show()
        if listening and listening.name == name then return end
        local k = AC.keys[name]
        b.Text = k and U.shortKey(k) or ""
    end
    show()
    b.MouseButton1Click:Connect(function() listening = { name = name, show = show } b.Text = "..." end)
    b.MouseButton2Click:Connect(function() AC.keys[name] = nil saveHubConfig() show() end)
    R.rows[#R.rows + 1] = show
    return b
end
U.on(UserInputService.InputBegan, function(i, gp)
    if listening then
        if i.UserInputType == Enum.UserInputType.Keyboard then
            local l = listening
            listening = nil
            if i.KeyCode == Enum.KeyCode.Escape or i.KeyCode == Enum.KeyCode.Backspace then
                AC.keys[l.name] = nil
            else
                AC.keys[l.name] = i.KeyCode.Name
            end
            saveHubConfig()
            l.show()
        end
        return
    end
    if i.UserInputType ~= Enum.UserInputType.Keyboard or UserInputService:GetFocusedTextBox() then return end
    local kn = i.KeyCode.Name
    for name, k in pairs(AC.keys) do
        if k == kn and binds[name] and (not gp or name == "menu" or name == "hide") then task.spawn(binds[name]) end
    end
end)

function U.toggle(parent, text, opt)
    local r = U.row(parent)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Size = UDim2.new(1, opt.chip and -86 or (opt.dots and -78 or -48), 1, 0)
    l.TextTruncate = Enum.TextTruncate.AtEnd
    local state = opt.get() and true or false
    local paint = U.switch(r, state)
    paint(state, true)
    local hit = U.hit(r, 2)
    local function set(v, silent)
        state = v and true or false
        paint(state)
        if not silent then
            local ok, err = pcall(opt.set, state)
            if not ok then warn("[iCollectPro AURORA] " .. text .. ": " .. tostring(err)) end
        end
    end
    hit.MouseButton1Click:Connect(function() set(not state) end)
    if opt.dots then
        local d = U.text("TextLabel", r, "⋯", 15, WB, C.DIM, Enum.TextXAlignment.Center)
        d.AnchorPoint = Vector2.new(1, 0.5)
        d.Position = UDim2.new(1, -50, 0.5, 0)
        d.Size = UDim2.new(0, 14, 1, 0)
        local b = U.hit(r, 3)
        b.AnchorPoint = Vector2.new(1, 0.5)
        b.Position = UDim2.new(1, -45, 0.5, 0)
        b.Size = UDim2.new(0, 28, 1, 0)
        b.MouseButton1Click:Connect(function() opt.dots(r) end)
    end
    if opt.chip then U.chip(r, opt.chip, function() set(not state) end) end
    if opt.tip then U.tip(r, opt.tip) end
    R.rows[#R.rows + 1] = function() local v = opt.get() and true or false if v ~= state then set(v, true) end end
    return set, r
end

function U.slider(parent, text, lo, hi, step, get, setv)
    local r = U.row(parent, 44)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Position = UDim2.fromOffset(0, 6)
    l.Size = UDim2.new(1, -56, 0, 16)
    local box = U.text("TextBox", r, "", 12, WB, C.DIM, Enum.TextXAlignment.Right)
    box.Position = UDim2.new(1, -52, 0, 6)
    box.Size = UDim2.fromOffset(52, 16)
    box.ClearTextOnFocus = false
    local track = new("Frame", { Position = UDim2.new(0, 0, 1, -16), Size = UDim2.new(1, 0, 0, 6), BackgroundColor3 = C.ELEM, BorderSizePixel = 0 }, r)
    U.round(track, 3)
    local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.A2, BorderSizePixel = 0 }, track)
    U.round(fill, 3)
    R.bg2[#R.bg2 + 1] = fill
    local knob = new("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Size = UDim2.fromOffset(13, 13), BackgroundColor3 = C.TEXT, BorderSizePixel = 0 }, track)
    U.round(knob, 10)
    local grab = new("TextButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 0, 0.5, 0), Size = UDim2.new(1, 0, 0, 18),
        BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 2 }, track)
    local dec = step >= 1 and 0 or (step >= 0.1 and 1 or 2)
    local function fmt(v)
        if dec == 0 then return tostring(math.floor(v + 0.5)) end
        local s = string.format("%." .. dec .. "f", v)
        s = s:gsub("0+$", ""):gsub("%.$", "")
        return s
    end
    local function show(v)
        local p = math.clamp((v - lo) / (hi - lo), 0, 1)
        fill.Size = UDim2.fromScale(p, 1)
        knob.Position = UDim2.new(p, 0, 0.5, 0)
        box.Text = fmt(v)
    end
    local function apply(v)
        v = math.clamp(math.floor(v / step + 0.5) * step, lo, hi)
        show(v)
        local ok, err = pcall(setv, v)
        if not ok then warn("[iCollectPro AURORA] " .. text .. ": " .. tostring(err)) end
    end
    local sliding = nil
    local function at(x)
        apply(lo + (hi - lo) * math.clamp((x - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1))
    end
    grab.InputBegan:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then sliding = i at(i.Position.X) end
    end)
    U.on(UserInputService.InputChanged, function(i)
        if sliding and (i.UserInputType == MOVE or i == sliding) then at(i.Position.X) end
    end)
    U.on(UserInputService.InputEnded, function(i)
        if sliding and (i.UserInputType == MB1 or i == sliding) then sliding = nil end
    end)
    box.FocusLost:Connect(function()
        local n = tonumber(box.Text)
        if n then apply(n) else show(tonumber(get()) or lo) end
    end)
    show(tonumber(get()) or lo)
    R.rows[#R.rows + 1] = function() if not sliding and not box:IsFocused() then show(tonumber(get()) or lo) end end
    return r
end

function U.drop(parent, text, options, opt)
    local outer = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = C.CARD,
        BorderSizePixel = 0, LayoutOrder = nxt() }, parent)
    U.round(outer, 10) U.stroke(outer, 1) U.list(outer, 0)
    local head = new("Frame", { Size = UDim2.new(1, 0, 0, 34), BackgroundTransparency = 1, LayoutOrder = 0 }, outer)
    U.pad(head, 10, 10)
    local n = U.text("TextLabel", head, text, 13, WM)
    n.Size = UDim2.new(0.48, -8, 1, 0)
    local v = U.text("TextLabel", head, "", 12, WR, C.DIM, Enum.TextXAlignment.Right)
    v.AnchorPoint = Vector2.new(1, 0.5)
    v.Position = UDim2.new(1, -18, 0.5, 0)
    v.Size = UDim2.new(0.52, -18, 1, 0)
    v.TextTruncate = Enum.TextTruncate.AtEnd
    local a = U.text("TextLabel", head, "v", 11, WB, C.DIM, Enum.TextXAlignment.Center)
    a.AnchorPoint = Vector2.new(1, 0.5)
    a.Position = UDim2.new(1, 0, 0.5, 0)
    a.Size = UDim2.new(0, 14, 1, 0)
    local hit = U.hit(head, 2)
    local list = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
        Visible = false, LayoutOrder = 1 }, outer)
    U.pad(list, 10, 10, 0, 8)
    U.list(list, 2)
    local btns = {}
    local function opts() return type(options) == "function" and options() or options end
    local function isSel(o)
        local g = opt.get()
        if opt.multi then return type(g) == "table" and table.find(g, o) ~= nil end
        return g == o
    end
    local function refresh()
        if opt.multi then
            local s = {}
            for _, o in ipairs(opts()) do if isSel(o) then s[#s + 1] = o end end
            v.Text = #s > 0 and table.concat(s, ", ") or (opt.none or "None")
        else
            v.Text = tostring(opt.get() or "")
        end
        for o, b in pairs(btns) do b.TextColor3 = isSel(o) and C.TEXT or C.DIM end
    end
    local function build()
        for _, b in pairs(btns) do b:Destroy() end
        table.clear(btns)
        for i, o in ipairs(opts()) do
            local b = U.text("TextButton", list, o, 12, WR, C.DIM)
            b.Size = UDim2.new(1, 0, 0, 26)
            b.LayoutOrder = i
            b.MouseButton1Click:Connect(function()
                if opt.multi then
                    local g = table.clone(type(opt.get()) == "table" and opt.get() or {})
                    local idx = table.find(g, o)
                    if idx then table.remove(g, idx) else g[#g + 1] = o end
                    opt.set(g)
                else
                    opt.set(o)
                    list.Visible = false
                    a.Rotation = 0
                end
                refresh()
            end)
            btns[o] = b
        end
        refresh()
    end
    hit.MouseButton1Click:Connect(function()
        list.Visible = not list.Visible
        a.Rotation = list.Visible and 180 or 0
        if list.Visible then build() end
    end)
    build()
    R.rows[#R.rows + 1] = refresh
    return refresh
end

function U.button(parent, text, fn, bg)
    local r = U.row(parent, 34, bg or C.ELEM)
    local l = U.text("TextLabel", r, text, 13, WM, C.WHITE, Enum.TextXAlignment.Center)
    l.Size = UDim2.fromScale(1, 1)
    local h = U.hit(r, 2)
    h.MouseButton1Click:Connect(function()
        local ok, err = pcall(fn, l)
        if not ok then warn("[iCollectPro AURORA] " .. text .. ": " .. tostring(err)) end
    end)
    return l, r
end
function U.stepper(parent, textf, dec, inc)
    local l, r = U.button(parent, textf(), function() end)
    for _, s in ipairs({ { "-", 0, 6, dec }, { "+", 1, -6, inc } }) do
        local b = U.text("TextButton", r, s[1], 18, WB, C.TEXT, Enum.TextXAlignment.Center)
        b.BackgroundTransparency = 0
        b.BackgroundColor3 = C.CARD
        b.AnchorPoint = Vector2.new(s[2], 0.5)
        b.Position = UDim2.new(s[2], s[3], 0.5, 0)
        b.Size = UDim2.fromOffset(26, 20)
        b.ZIndex = 3
        U.round(b, 6)
        b.MouseButton1Click:Connect(function() pcall(s[4]) l.Text = textf() end)
    end
    R.rows[#R.rows + 1] = function() l.Text = textf() end
    return l
end
function U.keyRow(parent, text, name, fn)
    local r = U.row(parent)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Size = UDim2.new(1, -86, 1, 0)
    local b = U.text("TextButton", r, "", 12, WB, C.DIM, Enum.TextXAlignment.Center)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, 0, 0.5, 0)
    b.Size = UDim2.fromOffset(74, 22)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    U.round(b, 10) U.stroke(b, 1)
    binds[name] = fn
    local function show()
        if listening and listening.name == name then return end
        b.Text = AC.keys[name] or "None"
    end
    show()
    b.MouseButton1Click:Connect(function() listening = { name = name, show = show } b.Text = "..." end)
    R.rows[#R.rows + 1] = show
end
function U.input(parent, text, ph, init, onDone, readOnly)
    local r = U.row(parent)
    local l = U.text("TextLabel", r, text, 13, WM)
    l.Size = UDim2.new(1, -124, 1, 0)
    local b = U.text("TextBox", r, init or "", 12, WR, C.TEXT)
    b.AnchorPoint = Vector2.new(1, 0.5)
    b.Position = UDim2.new(1, 0, 0.5, 0)
    b.Size = UDim2.fromOffset(116, 20)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    b.PlaceholderText = ph or ""
    b.PlaceholderColor3 = C.DIM
    b.ClearTextOnFocus = false
    b.TextEditable = not readOnly
    b.TextTruncate = Enum.TextTruncate.AtEnd
    U.round(b, 6) U.pad(b, 6, 6)
    if onDone then b.FocusLost:Connect(function() onDone(b.Text) end) end
    return b
end

local TIP = U.panel(root, UDim2.fromOffset(224, 0), UDim2.new(), nil, 0, 10, nil, 1)
TIP.AutomaticSize = Enum.AutomaticSize.Y
TIP.Visible = false
TIP.ZIndex = 60
U.pad(TIP, 9, 9, 7, 8)
local TIPL = U.text("TextLabel", TIP, "", 12, WR, C.DIM)
TIPL.Size = UDim2.new(1, 0, 0, 0)
TIPL.AutomaticSize = Enum.AutomaticSize.Y
TIPL.TextWrapped = true
TIPL.ZIndex = 61
function U.tip(obj, text)
    obj.MouseEnter:Connect(function()
        TIPL.Text = text
        local p = U.toRoot(obj.AbsolutePosition)
        TIP.Position = UDim2.fromOffset(p.X + obj.AbsoluteSize.X / uiScale.Scale + 10, p.Y)
        TIP.Visible = true
    end)
    obj.MouseLeave:Connect(function() TIP.Visible = false end)
end

local TOASTS = new("Frame", { AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.fromOffset(250, 420),
    BackgroundTransparency = 1 }, root)
do
    local l = U.list(TOASTS, 6)
    l.VerticalAlignment = Enum.VerticalAlignment.Bottom
end
function U.notify(title, text, dur)
    local t = U.panel(TOASTS, UDim2.new(1, 0, 0, 0), UDim2.new(), nil, 0, 12, nil, 1)
    t.AutomaticSize = Enum.AutomaticSize.Y
    t.LayoutOrder = nxt()
    U.pad(t, 12, 12, 9, 10)
    U.list(t, 3)
    local a = U.text("TextLabel", t, title, 13, WB, C.WHITE)
    a.Size = UDim2.new(1, 0, 0, 16)
    U.tgrad(a)
    if text and text ~= "" then
        local b = U.text("TextLabel", t, text, 12, WR, C.DIM)
        b.Size = UDim2.new(1, 0, 0, 0)
        b.AutomaticSize = Enum.AutomaticSize.Y
        b.TextWrapped = true
        b.LayoutOrder = 1
    end
    task.delay(dur or 3, function() pcall(function() t:Destroy() end) end)
end

local MAIN = U.panel(root, UDim2.fromOffset(320, 420), UDim2.new(0.5, 420, 0.5, 0), Vector2.new(0.5, 0.5), 0, 16, "main")
MAIN.Visible = U.get("mainOpen", true)
local mainHd, mainBtns, mainTitle = U.header(MAIN, "iCollectPro", 34, 14, "main")
U.resizer(MAIN, 280, 260, "main")

local PALETTE = { rgb(110, 0, 178), rgb(114, 0, 255), rgb(0, 110, 255), rgb(0, 190, 255), rgb(0, 170, 110), rgb(60, 220, 140),
    rgb(210, 0, 70), rgb(255, 60, 110), rgb(230, 110, 0), rgb(255, 170, 40), rgb(200, 0, 160), rgb(255, 80, 210), rgb(220, 220, 230) }
function U.repaintAccent()
    for _, g in ipairs(R.sg) do g.Color = U.seq2() end
    for _, g in ipairs(R.fg) do g.Color = U.seq2() end
    for _, g in ipairs(R.tg) do g.Color = U.seq3() end
    for _, o in ipairs(R.bg1) do o.BackgroundColor3 = C.A1 end
    for _, o in ipairs(R.bg2) do o.BackgroundColor3 = C.A2 end
    for _, o in ipairs(R.tx1) do o.TextColor3 = C.A1 end
    for _, o in ipairs(R.tx2) do o.TextColor3 = C.A2 end
    for _, s in ipairs(R.bars) do s.ScrollBarImageColor3 = C.A1 end
    for _, f in ipairs(R.rows) do pcall(f) end
    AC.accent1, AC.accent2 = toT(C.A1), toT(C.A2)
    saveHubConfig()
end
for i, which in ipairs({ "A1", "A2" }) do
    local dot = new("TextButton", { Size = UDim2.fromOffset(13, 13), BackgroundColor3 = C[which], Text = "", AutoButtonColor = false,
        LayoutOrder = i, BorderSizePixel = 0 }, mainBtns)
    U.round(dot, 0.5, true)
    R[which == "A1" and "bg1" or "bg2"][#R[which == "A1" and "bg1" or "bg2"] + 1] = dot
    dot.MouseButton1Click:Connect(function()
        local idx = 0
        for k, c in ipairs(PALETTE) do if toT(c)[1] == toT(C[which])[1] and toT(c)[2] == toT(C[which])[2] and toT(c)[3] == toT(C[which])[3] then idx = k end end
        C[which] = PALETTE[idx % #PALETTE + 1]
        U.repaintAccent()
    end)
end
local lockBtn = U.hbtn(mainBtns, U.locked and "🔒" or "🔓", 3, function() end)
lockBtn.MouseButton1Click:Connect(function()
    U.locked = not U.locked
    lockBtn.Text = U.locked and "🔒" or "🔓"
    U.set("guiLock", U.locked)
end)
U.hbtn(mainBtns, "X", 4, function() MAIN.Visible = false U.set("mainOpen", false) end)

local mainBody = new("Frame", { Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34), BackgroundTransparency = 1 }, MAIN)
local tabBar = new("Frame", { Position = UDim2.fromOffset(10, 10), Size = UDim2.new(1, -20, 0, 28), BackgroundTransparency = 1 }, mainBody)
U.list(tabBar, 0, Enum.FillDirection.Horizontal)
local pageHolder = new("Frame", { Position = UDim2.fromOffset(0, 38), Size = UDim2.new(1, 0, 1, -38), BackgroundTransparency = 1, ClipsDescendants = true }, mainBody)
local TABS, PAGES, tabOrder = {}, {}, { "Stealing", "Player", "Visuals", "Admin", "Misc", "Configs" }
local TAB_W = { Stealing = 0.20408164, Player = 0.163265303, Visuals = 0.183673471, Admin = 0.142857149, Misc = 0.122448981, Configs = 0.183673471 }
function U.selectTab(name)
    for n, t in pairs(TABS) do
        local on = n == name
        t.btn.TextColor3 = on and C.TEXT or C.DIM
        t.line.Visible = on
        PAGES[n].Visible = on
    end
    U.set("tab", name)
end
for i, name in ipairs(tabOrder) do
    local b = U.text("TextButton", tabBar, name, 13, WM, C.DIM, Enum.TextXAlignment.Center)
    b.Size = UDim2.new(TAB_W[name], 0, 1, 0)
    b.LayoutOrder = i
    local line = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 1, 0), Size = UDim2.new(1, -8, 0, 2),
        BackgroundColor3 = C.A1, BorderSizePixel = 0, Visible = false }, b)
    U.round(line, 1)
    R.bg1[#R.bg1 + 1] = line
    TABS[name] = { btn = b, line = line }
    PAGES[name] = U.scroller(pageHolder, UDim2.new(), UDim2.fromScale(1, 1), 10, 8)
    PAGES[name].Visible = false
    b.MouseButton1Click:Connect(function() U.selectTab(name) end)
end

local POP = {}
function U.popup(title, key)
    local f = U.panel(root, UDim2.fromOffset(226, 50), UDim2.fromOffset(1182, 300), nil, 0, 16, "pop_" .. key, 1)
    f.Visible = false
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1 }, f)
    U.pad(hd, 10, 10)
    local t = U.text("TextLabel", hd, title, 12, WB, C.WHITE)
    t.Size = UDim2.new(1, -28, 1, 0)
    U.tgrad(t)
    local x = U.text("TextButton", hd, "X", 12, WB, C.DIM, Enum.TextXAlignment.Center)
    x.AnchorPoint = Vector2.new(1, 0.5)
    x.Position = UDim2.new(1, 0, 0.5, 0)
    x.Size = UDim2.fromOffset(28, 28)
    x.MouseButton1Click:Connect(function() f.Visible = false end)
    U.drag(hd, f, "pop_" .. key)
    local body = U.scroller(f, UDim2.fromOffset(0, 30), UDim2.new(1, 0, 1, -30), 10, 7)
    local lay = body:FindFirstChildOfClass("UIListLayout")
    local function resize()
        f.Size = UDim2.fromOffset(226, math.min(30 + lay.AbsoluteContentSize.Y / uiScale.Scale + 22, 480))
    end
    lay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(resize)
    task.defer(resize)
    local p = { f = f, body = body, key = "pop_" .. key }
    POP[key] = p
    return p
end
function U.openPop(p, row)
    if p.f.Visible then p.f.Visible = false return end
    if not AC.pos[p.key] and MAIN.Visible then
        local wl = U.toRoot(MAIN.AbsolutePosition).X
        local ry = row and U.toRoot(row.AbsolutePosition).Y or 100
        local maxY = root.AbsoluteSize.Y / uiScale.Scale - p.f.Size.Y.Offset - 8
        p.f.Position = UDim2.fromOffset(math.max(wl - 226 - 8, 4), math.clamp(ry - 8, 4, math.max(maxY, 4)))
    end
    p.f.Visible = true
end
local SUB = {}
function U.sub(title, key)
    local f = U.panel(root, UDim2.fromOffset(260, 320), UDim2.new(0.66, 0, 0.5, 0), Vector2.new(0.5, 0.5), 0, 16, "sub_" .. key)
    f.Visible = false
    local _, btns = U.header(f, title, 34, 14, "sub_" .. key)
    local body = new("Frame", { Position = UDim2.fromOffset(0, 34), Size = UDim2.new(1, 0, 1, -34), BackgroundTransparency = 1, ClipsDescendants = true }, f)
    local sc = U.scroller(body, UDim2.new(), UDim2.fromScale(1, 1), 10, 8)
    local mini, full = false, nil
    U.hbtn(btns, "-", 1, function()
        mini = not mini
        if mini then full = f.Size end
        body.Visible = not mini
        f.Size = mini and UDim2.fromOffset(f.Size.X.Offset, 34) or (full or UDim2.fromOffset(260, 320))
    end)
    U.hbtn(btns, "X", 2, function() f.Visible = false end)
    U.resizer(f, 220, 140, "sub_" .. key)
    local p = { f = f, body = sc, card = U.card(sc), key = key }
    SUB[key] = p
    return p
end
function U.openSub(p) p.f.Visible = not p.f.Visible end

local ANIMALS, RARITIES = {}, {}
pcall(function() ANIMALS = require(ReplicatedStorage.Datas.Animals) end)
pcall(function() RARITIES = require(ReplicatedStorage.Datas.Rarities) end)

function F.char()
    local c = LP.Character
    return c, c and c:FindFirstChildOfClass("Humanoid"), c and c:FindFirstChild("HumanoidRootPart")
end
function F.myPlot() local ok, p = pcall(findMyBase) return ok and p or nil end
function F.stealing() return LP:GetAttribute("Stealing") == true end
function F.money(n)
    n = tonumber(n) or 0
    local units = { { 1e12, "T" }, { 1e9, "B" }, { 1e6, "M" }, { 1e3, "K" } }
    for _, u in ipairs(units) do
        if n >= u[1] then
            local v = n / u[1]
            return "$" .. (v >= 100 and string.format("%d", v) or (string.format("%.1f", v):gsub("%.0$", ""))) .. u[2] .. "/s"
        end
    end
    return "$" .. math.floor(n) .. "/s"
end
function F.rarity(name) local d = ANIMALS[name] return d and d.Rarity or "Common" end
function F.rarityColor(r)
    local d = RARITIES[r]
    if d and typeof(d.Color) == "Color3" then return d.Color end
    return C.TEXT
end
function F.genOf(model)
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("TextLabel") and d.Text:match("^%$[%d%.]+[KMBT]?/s$") then return d.Text, nil end
    end
    local data = ANIMALS[model.Name]
    return F.money(data and data.Generation or 0), data and data.Generation or 0
end
function F.genValue(text)
    local n, u = tostring(text):match("%$([%d%.]+)([KMBT]?)/s")
    n = tonumber(n) or 0
    return n * (({ K = 1e3, M = 1e6, B = 1e9, T = 1e12 })[u] or 1)
end
function F.ownerName(plot) local ok, n = pcall(plotOwnerName, plot) return ok and n or "?" end
function F.enemyPlots() local ok, l = pcall(enemyPlotList) return ok and l or {} end

function F.brainrots()
    local out = {}
    for _, plot in ipairs(F.enemyPlots()) do
        local pods = plot:FindFirstChild("AnimalPodiums")
        local spots = {}
        for _, pod in ipairs(pods and pods:GetChildren() or {}) do
            local sp = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
            if sp then spots[#spots + 1] = { slot = tonumber(pod.Name), part = sp } end
        end
        for _, m in ipairs(plot:GetChildren()) do
            if m:IsA("Model") and ANIMALS[m.Name] then
                local pivot = m:GetPivot().Position
                local best, bd = nil, 14
                for _, s in ipairs(spots) do
                    local d = (s.part.Position - pivot).Magnitude
                    if d < bd then best, bd = s, d end
                end
                local gt, gv = F.genOf(m)
                out[#out + 1] = { model = m, plot = plot, slot = best and best.slot, spawn = best and best.part, name = m.Name,
                    gen = gv or F.genValue(gt), genText = gt, owner = F.ownerName(plot), rarity = F.rarity(m.Name) }
            end
        end
    end
    return out
end

local CHIPS = iCollectProUI.cfgChips or {}
local DEF_ON = { antiBeeEnabled = true, antiGummyEnabled = true, antiDiscoEnabled = true, antiPaintEnabled = true, antiWebEnabled = true,
    antiSwapEnabled = true, destroySentryEnabled = true, destroyDogeEnabled = true, antiRagdollEnabled = true, antiRocketEnabled = true,
    pillBarEnabled = true, potionEnabled = true, showPathEnabled = true }
function F.cfg(key)
    local v = HubConfig[key]
    if v == nil then return DEF_ON[key] == true end
    return v == true
end
function F.setCfg(key, v)
    if CHIPS[key] then CHIPS[key](v and true or false)
    else HubConfig[key] = v and true or false saveHubConfig() end
end
function F.num(key, def) return tonumber(HubConfig[key]) or def end
function F.setNum(key, v) HubConfig[key] = v saveHubConfig() end
local function chipOpt(key) return { get = function() return F.cfg(key) end, set = function(v) F.setCfg(key, v) end } end
local function acOpt(key, def, after)
    return { get = function() return U.get(key, def) end, set = function(v) U.set(key, v) if after then after(v) end end }
end

function F.instaReset() pcall(function() _G.iCollectPro_SemiTP_InstaReset() end) end

F.CMDS = { "ragdoll", "jumpscare", "morph", "jail", "tiny", "nightvision", "control", "balloon", "inverse", "rocket" }
function F.adminGui()
    local pg = LP:FindFirstChild("PlayerGui")
    local g = pg and pg:FindFirstChild("AdminPanel")
    return g, g and g:FindFirstChild("AdminPanel")
end
function F.cmdButton(cmd)
    local _, panel = F.adminGui()
    if not panel then return nil end
    for _, b in ipairs(panel:GetDescendants()) do
        if b:IsA("GuiButton") and b.Name ~= "Template" then
            local c = b:FindFirstChild("Command")
            if c and c:IsA("TextLabel") and c.Text:lower():gsub("^;", "") == cmd then return b end
        end
    end
end
function F.cmdCooldown(cmd)
    local b = F.cmdButton(cmd)
    local t = b and b:FindFirstChild("Timer")
    if t and t:IsA("TextLabel") and t.Visible then
        local n = tonumber(t.Text:match("(%d+)"))
        if n and n > 0 then return n end
    end
    return 0
end
local function press(b)
    if type(firesignal) == "function" then
        pcall(firesignal, b.Activated)
        pcall(firesignal, b.MouseButton1Click)
    end
end
function F.adminCmd(cmd, target)
    local g, panel = F.adminGui()
    if not panel or not target then return false end
    local b = F.cmdButton(cmd)
    if not b or F.cmdCooldown(cmd) > 0 then return false end
    local was = panel.Visible
    panel.Visible = true
    press(b)
    task.wait(0.15)
    local picked = false
    for _, x in ipairs(g:GetDescendants()) do
        if x:IsA("GuiButton") and x.Visible and x ~= b then
            local hit = x.Name == target.Name or x.Name == tostring(target.UserId)
            if not hit then
                for _, t in ipairs(x:GetDescendants()) do
                    if t:IsA("TextLabel") and (t.Text == target.Name or t.Text == target.DisplayName or t.Text == "@" .. target.Name) then hit = true break end
                end
            end
            if hit then press(x) picked = true break end
        end
    end
    panel.Visible = was
    return picked
end
function F.nearestPlayer(maxD)
    local _, _, hrp = F.char()
    if not hrp then return nil end
    local best, bd = nil, maxD or math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local d = (r.Position - hrp.Position).Magnitude
            if d < bd then best, bd = p, d end
        end
    end
    return best
end
function F.spamCmds(list, target)
    task.spawn(function()
        for _, c in ipairs(list or {}) do
            if not target or not target.Parent then return end
            F.adminCmd(c, target)
            task.wait(0.35)
        end
    end)
end

local moreSet = U.sub("More Settings", "more")
F.speedMasterDef = F.cfg("moveSpeedEnabled") or HubConfig.stealBoostAutoOnSteal ~= false
F.speedSync = function()
    if AC.giantSpeed == nil then AC.giantSpeed = F.num("giantSpeedValue", 30) end
    local master = U.get("speedMaster", F.speedMasterDef)
    local walk = U.get("speedWalk", F.cfg("moveSpeedEnabled"))
    iCollectProFx.speedOn = master and walk
    HubConfig.moveSpeedEnabled = master and walk
    _G.iCollectPro_SemiTP_SpeedBoost = master and U.get("speedSteal", true)
    HubConfig.stealBoostAutoOnSteal = _G.iCollectPro_SemiTP_SpeedBoost
    HubConfig.giantSpeedValue = U.get("speedGiant", true) and U.get("giantSpeed", 30)
        or F.num("walkSpeedValue", 30)
    iCollectProFx.grav = master and U.get("speedGravity", F.cfg("gravityEnabled"))
    HubConfig.gravityEnabled = iCollectProFx.grav
    saveHubConfig()
end
U.toggle(moreSet.card, "Walk", acOpt("speedWalk", F.cfg("moveSpeedEnabled"), F.speedSync))
U.slider(moreSet.card, "Walk Speed", 0, 80, 1, function() return F.num("walkSpeedValue", 30) end, function(v) F.setNum("walkSpeedValue", math.max(v, 16)) end)
U.toggle(moreSet.card, "Stealing", acOpt("speedSteal", true, F.speedSync))
U.slider(moreSet.card, "Steal Speed", 0, 60, 1, function() return F.num("speedValue", 22) end, function(v)
    currentSpeed = v
    F.setNum("speedValue", v)
end)
U.toggle(moreSet.card, "Giant", acOpt("speedGiant", true, F.speedSync))
U.slider(moreSet.card, "Giant Speed", 0, 60, 1, function() return U.get("giantSpeed", 30) end, function(v)
    U.set("giantSpeed", v)
    F.speedSync()
end)
U.toggle(moreSet.card, "Gravity", acOpt("speedGravity", F.cfg("gravityEnabled"), F.speedSync))
U.slider(moreSet.card, "Gravity", 0, 300, 0.1, function() return F.num("gravityValue", 196.2) end, function(v) F.setNum("gravityValue", v) end)

local speedWin = U.sub("Speed", "speed")
U.toggle(speedWin.card, "Enabled", { chip = "speed", get = function() return U.get("speedMaster", F.speedMasterDef) end,
    set = function(v) U.set("speedMaster", v) F.speedSync() end })
U.toggle(speedWin.card, "Auto Speed", acOpt("autoSpeed", false))
U.toggle(speedWin.card, "More Settings", { get = function() return moreSet.f.Visible end, set = function(v) moreSet.f.Visible = v end,
    dots = function() U.openSub(moreSet) end })

local carpetWin = U.sub("Carpet Speed", "carpet")
U.toggle(carpetWin.card, "Enabled", { chip = "carpet", get = function() return F.cfg("carpetSpeedEnabled") end,
    set = function(v) F.setCfg("carpetSpeedEnabled", v) iCollectProFx.carpet = v if F.actionsCarpet then F.actionsCarpet() end end })
U.toggle(carpetWin.card, "Auto Equip", acOpt("carpetEquip", false))
U.slider(carpetWin.card, "Carpet Speed", 0, 500, 1, function() return F.num("carpetSpeedValue", 130) end, function(v) F.setNum("carpetSpeedValue", math.max(v, 16)) end)

local semiWin = U.sub("Semi Instant", "semi")
U.button(semiWin.card, "Do Instant Steal", function()
    if U.get("semiAlignCam", false) and F.alignCam then F.alignCam() end
    task.spawn(iCollectPro.execute)
end)
U.stepper(semiWin.card, function() return "Target Slot: " .. tostring(selectedSlot) end, function()
    local n = selectedSlot - 1
    if n < 1 then n = iCollectPro.maxPodium() end
    updateSlot(n)
end, function()
    local n = selectedSlot + 1
    if n > iCollectPro.maxPodium() then n = 1 end
    updateSlot(n)
end)
U.button(semiWin.card, "Activate", function() iCollectPro.activate() end)
U.toggle(semiWin.card, "Auto Activate", acOpt("autoActivate", false))
U.toggle(semiWin.card, "More Settings", { get = function() return F.semiMore and F.semiMore.f.Visible or false end,
    set = function(v) if F.semiMore then F.semiMore.f.Visible = v end end,
    dots = function() if F.semiMore then U.openSub(F.semiMore) end end })

local manageWin = U.sub("Manage", "manage")
local shareWin = U.popup("Share & Import", "share")
local aimPop = U.popup("Aimbot", "aim")
U.toggle(aimPop.body, "Auto Spam", chipOpt("autoSpamEnabled"))

local safetyPop = U.popup("Safety Kick", "safety")
U.toggle(safetyPop.body, "Kick If No Cmds", acOpt("kickNoCmds", false))
U.toggle(safetyPop.body, "Leave After Balloon", acOpt("leaveBalloon", false))
U.toggle(safetyPop.body, "Kick 3rd Player", acOpt("kick3rd", false))

local defSetWin = U.sub("Settings", "defset")
local function cmdDrop(text, key, def)
    U.drop(defSetWin.card, text, F.CMDS, { multi = true, get = function() return U.get(key, def) end, set = function(v) U.set(key, v) end })
end
cmdDrop("Single Cmds 1", "defCmds1", { "balloon" })
cmdDrop("Single Cmds 2", "defCmds2", { "ragdoll", "rocket", "inverse", "tiny", "jumpscare" })
cmdDrop("Multi Cmds 1", "defMulti1", { "balloon" })
cmdDrop("Multi Cmds 2", "defMulti2", { "ragdoll", "rocket", "inverse", "tiny" })
cmdDrop("Intruder Cmds", "intruderCmds", { "balloon" })
local defWin = U.sub("Auto Defense", "defense")
U.toggle(defWin.card, "Enabled", acOpt("autoDefense", false))
U.toggle(defWin.card, "Safety Kick", { get = function() return U.get("safetyKick", true) end, set = function(v) U.set("safetyKick", v) end,
    dots = function(r) U.openPop(safetyPop, r) end })
U.toggle(defWin.card, "Settings", { get = function() return defSetWin.f.Visible end, set = function(v) defSetWin.f.Visible = v end,
    dots = function() U.openSub(defSetWin) end })
U.toggle(defWin.card, "Anti Intruder", acOpt("antiIntruder", false))

local spamPop = U.popup("Auto Spam After Steal", "spamsteal")
U.drop(spamPop.body, "Spam Cmds", { "balloon", "ragdoll", "rocket", "inverse", "tiny", "jail", "jumpscare", "morph" },
    { multi = true, get = function() return U.get("spamCmds", { "rocket", "inverse", "tiny" }) end, set = function(v) U.set("spamCmds", v) end })

F.semiMore = U.sub("More Settings", "semimore")
U.toggle(F.semiMore.card, "Align Camera", acOpt("semiAlignCam", false))
U.toggle(F.semiMore.card, "Auto Giant Potion + Grief Shield", { get = function() return F.cfg("potionEnabled") end, set = function(v)
    F.setCfg("potionEnabled", v)
    PotionEnabled = v
    if v then U.set("autoRagTech", false) end
end })
U.toggle(F.semiMore.card, "Auto Walk After Steal", acOpt("autoWalkSteal", false))
U.toggle(F.semiMore.card, "Auto Spam After Steal", { get = function() return U.get("spamAfter", U.get("adminSpam", false)) end,
    set = function(v) U.set("spamAfter", v) end, dots = function(r) U.openPop(spamPop, r) end })
local function tpRow(text)
    U.toggle(F.semiMore.card, text, { get = function() return false end, set = function(v)
        if v then
            U.notify(text, "Not wired in the remake (server-visible teleport)")
            task.defer(function() for _, f in ipairs(R.rows) do pcall(f) end end)
        end
    end })
end
tpRow("Auto TP On Allow")
tpRow("Auto TP On Unlock")

local BOX_MODES = { "Corner", "2D", "3D", "Triangle", "Circle", "Square", "Star" }
local brESPPop = U.popup("Brainrot ESP", "bresp")
U.drop(brESPPop.body, "Rarities", { "OG", "Secret", "Brainrot God", "Mythic", "Legendary", "Epic", "Rare", "Common" },
    { multi = true, get = function() return U.get("brRarities", { "OG", "Secret" }) end, set = function(v) U.set("brRarities", v) end })
U.toggle(brESPPop.body, "Boxes", acOpt("brBoxes", true))
U.drop(brESPPop.body, "Box Mode", BOX_MODES, { get = function() return U.get("brBoxMode", "Corner") end, set = function(v) U.set("brBoxMode", v) F.espReset() end })
U.toggle(brESPPop.body, "Chams", acOpt("brChams", true))
U.toggle(brESPPop.body, "Name", acOpt("brName", true))
U.toggle(brESPPop.body, "Generation", acOpt("brGen", true))
U.toggle(brESPPop.body, "Distance", acOpt("brDist", true))

local footPop = U.popup("Footstep ESP", "foot")
U.slider(footPop.body, "Lifetime (seconds)", 1, 8, 1, function() return U.get("footLife", 4) end, function(v) U.set("footLife", v) end)
local FOOT_COLORS = { rgb(114, 0, 255), rgb(255, 255, 255), rgb(255, 60, 90), rgb(60, 220, 140), rgb(255, 205, 90), rgb(0, 190, 255) }
U.button(footPop.body, "Footstep Color", function(l)
    local cur = toT(fromT(AC.footColor, FOOT_COLORS[1]))
    local idx = 1
    for k, c in ipairs(FOOT_COLORS) do local t = toT(c) if t[1] == cur[1] and t[2] == cur[2] and t[3] == cur[3] then idx = k end end
    AC.footColor = toT(FOOT_COLORS[idx % #FOOT_COLORS + 1])
    saveHubConfig()
    l.TextColor3 = fromT(AC.footColor, C.WHITE)
end)
local iconPop = U.popup("Icons", "icons")
U.toggle(iconPop.body, "Admin", acOpt("iconAdmin", true))
U.toggle(iconPop.body, "Giant Potion", acOpt("iconGiant", true))
U.toggle(iconPop.body, "Flash Teleport", acOpt("iconFlash", true))

local plESPPop = U.popup("Player ESP", "plesp")
U.toggle(plESPPop.body, "Boxes", acOpt("plBoxes", true))
U.drop(plESPPop.body, "Box Mode", BOX_MODES, { get = function() return U.get("plBoxMode", "Corner") end, set = function(v) U.set("plBoxMode", v) F.espReset() end })
U.toggle(plESPPop.body, "Chams", acOpt("plChams", true))
U.toggle(plESPPop.body, "Name", acOpt("plName", true))
U.toggle(plESPPop.body, "Use Display Name", acOpt("plDisplay", true))
U.toggle(plESPPop.body, "Distance", acOpt("plDist", true))
U.toggle(plESPPop.body, "Stealing Tag", acOpt("plStealTag", true))
U.toggle(plESPPop.body, "Invisible Tag", acOpt("plInvisTag", true))
U.toggle(plESPPop.body, "Footstep ESP", { get = function() return U.get("plFoot", false) end, set = function(v) U.set("plFoot", v) end,
    dots = function(r) U.openPop(footPop, r) end })
U.toggle(plESPPop.body, "Icons", { get = function() return U.get("plIcons", true) end, set = function(v) U.set("plIcons", v) end,
    dots = function(r) U.openPop(iconPop, r) end })

local timerPop = U.popup("Timer", "timer")
U.toggle(timerPop.body, "Repeat On Every Floor", acOpt("timerFloors", false))
U.toggle(timerPop.body, "Screen HUD", acOpt("timerHud", true, function() if F.baseHud then F.baseHud() end end))

local baseESPPop = U.popup("Base ESP", "baseesp")
U.toggle(baseESPPop.body, "Xray", acOpt("xray", false, function(v) if not v and F.xrayClear then F.xrayClear() end end))
U.slider(baseESPPop.body, "Xray Transparency", 0, 1, 0.05, function() return U.get("xrayT", 0.7) end, function(v) U.set("xrayT", v) end)
U.toggle(baseESPPop.body, "Allowed", acOpt("allowedTag", true))
U.toggle(baseESPPop.body, "Timer", { get = function() return U.get("baseTimer", true) end,
    set = function(v) U.set("baseTimer", v) if F.baseHud then F.baseHud() end end, dots = function(r) U.openPop(timerPop, r) end })
U.toggle(baseESPPop.body, "Delivery", acOpt("delivery", false))

local miscESPPop = U.popup("Misc ESP", "miscesp")
F.miscSync = function()
    local on = U.get("miscEsp", false)
    F.setCfg("tracersEnabled", on and U.get("tracers", false))
    F.setCfg("serverGhostEnabled", on and U.get("serverPos", false))
end
U.toggle(miscESPPop.body, "Bullet Tracers", acOpt("tracers", false, F.miscSync))
U.toggle(miscESPPop.body, "Server Position", acOpt("serverPos", false, F.miscSync))
U.toggle(miscESPPop.body, "Self Chams", { get = function() return U.get("selfChams", false) end, set = function(v) U.set("selfChams", v) end,
    tip = "Reversible; keeps clothing, textures and animations" })
U.toggle(miscESPPop.body, "Clone ESP", acOpt("cloneEsp", false))
U.toggle(miscESPPop.body, "Mine ESP", acOpt("mineEsp", false))

local pubPop = U.popup("Pub Method", "pub")
U.toggle(pubPop.body, "Slot ESP", acOpt("slotEsp", false))
U.toggle(pubPop.body, "Next Base ESP", acOpt("nextBase", false))

local fovPop = U.popup("Custom FOV/Stretch", "fov")
U.slider(fovPop.body, "FOV", 30, 120, 1, function() return F.num("fovValue", 80) end, function(v) F.setNum("fovValue", v) end)
U.slider(fovPop.body, "Stretch", 0.3, 1, 0.05, function() return U.get("stretch", 1) end, function(v) U.set("stretch", v) end)

local espLookWin = U.sub("ESP Look", "esplook")
U.drop(espLookWin.card, "Renderer", { "Auto", "Drawing", "GUI" },
    { get = function() return U.get("espRenderer", "Auto") end, set = function(v) U.set("espRenderer", v) F.espReset() end })
U.slider(espLookWin.card, "Text Size", 8, 32, 1, function() return U.get("espText", 16) end, function(v) U.set("espText", v) end)
U.slider(espLookWin.card, "Box Thickness", 1, 6, 1, function() return U.get("espThick", 2) end, function(v) U.set("espThick", v) F.espReset() end)
U.toggle(espLookWin.card, "Force Visible Colors", acOpt("forceVisible", true, function() F.espReset() end))

local function unavailable(title, key)
    local p = U.popup(title, key)
    U.input(p.body, "Error", "", "Unavailable", nil, true)
    return p
end
local rtbPop = unavailable("Region Trade Block", "rtb")
local tpbPop = unavailable("Trading Plaza Block", "tpb")
local rtb2Pop = unavailable("Region Trade Block V2", "rtb2")

do
    local pg = PAGES.Stealing
    local c = U.card(pg, "AUTO STEAL")
    U.toggle(c, "Auto Steal Best", acOpt("autoBest", false))
    U.toggle(c, "Auto Steal Nearest", acOpt("autoNearest", false))
    U.toggle(c, "Auto Steal Priority", acOpt("autoPriority", false, function(v) if F.priorityShow then F.priorityShow(v) end end))
    U.toggle(c, "Defender Bypass Grab", chipOpt("defenderBypassEnabled"))
    U.toggle(c, "Public Method Grab", chipOpt("publicGrabEnabled"))
    c = U.card(pg, "ASSIST")
    U.toggle(c, "Semi Instant", { get = function() return U.get("semiInstant", true) end, set = function(v)
        U.set("semiInstant", v)
        if v then pcall(bindStealKey) else pcall(function() game:GetService("ContextActionService"):UnbindAction("iCollectPro_SemiTP_StealKey") end) end
    end, dots = function() U.openSub(semiWin) end })
    U.toggle(c, "Auto Giant Potion + Grief Shield", { get = function() return F.cfg("potionEnabled") end, set = function(v)
        F.setCfg("potionEnabled", v)
        PotionEnabled = v
    end })
    U.toggle(c, "Auto Ragdoll Tech", acOpt("autoRagTech", false))
    U.toggle(c, "Auto Leave on Steal", { get = function() return F.cfg("kickAfterStealEnabled") end, set = function(v)
        F.setCfg("kickAfterStealEnabled", v)
        KickAfterStealEnabled = v
    end })
    U.toggle(c, "Auto Rejoin On 2 Seconds", chipOpt("autoRejoinEnabled"))
    U.toggle(c, "Auto Go To Base", acOpt("autoGoBase", false))
end

do
    local pg = PAGES.Player
    local c = U.card(pg, "MOVEMENT")
    U.toggle(c, "Speed", { get = function() return U.get("speedMaster", F.speedMasterDef) end,
        set = function(v) U.set("speedMaster", v) F.speedSync() end, dots = function() U.openSub(speedWin) end })
    U.toggle(c, "Carpet Speed", { get = function() return F.cfg("carpetSpeedEnabled") end,
        set = function(v) F.setCfg("carpetSpeedEnabled", v) iCollectProFx.carpet = v if F.actionsCarpet then F.actionsCarpet() end end,
        dots = function() U.openSub(carpetWin) end })
    U.toggle(c, "Infinite Jump", chipOpt("infJumpEnabled"))
    U.drop(c, "Auto Instant Reset", { "tiny", "balloon", "control", "inverse", "jail", "jumpscare", "morph", "nightvision", "ragdoll", "rocket" },
        { multi = true, none = "None", get = function() return U.get("autoResetCmds", {}) end, set = function(v) U.set("autoResetCmds", v) end })
    U.toggle(c, "Auto Reset On Ragdoll", acOpt("resetRagdoll", false))
    c = U.card(pg, "MISC")
    U.toggle(c, "Aimbot", { get = function() return F.cfg("aimbotEnabled") end, set = function(v) F.setCfg("aimbotEnabled", v) end,
        dots = function(r) U.openPop(aimPop, r) end })
    U.toggle(c, "Auto Destroy Sentry", { chip = "sentry", get = function() return F.cfg("destroySentryEnabled") end, set = function(v) F.setCfg("destroySentryEnabled", v) end })
    U.toggle(c, "Auto Destroy Doge", { chip = "doge", get = function() return F.cfg("destroyDogeEnabled") end, set = function(v) F.setCfg("destroyDogeEnabled", v) end })
    U.toggle(c, "Anti Bee", chipOpt("antiBeeEnabled"))
    U.toggle(c, "Anti Paintball", chipOpt("antiPaintEnabled"))
    U.toggle(c, "Anti Boogie Bomb", chipOpt("antiDiscoEnabled"))
    U.toggle(c, "Anti GummyBear", chipOpt("antiGummyEnabled"))
    U.toggle(c, "Anti WebSling", chipOpt("antiWebEnabled"))
    U.toggle(c, "Mute Walk Sound", acOpt("muteWalk", false))
    U.toggle(c, "Anti Ragdoll V2", { chip = "antiragdoll", get = function() return F.cfg("antiRagdollEnabled") end, set = function(v)
        F.setCfg("antiRagdollEnabled", v)
        AntiRagdollEnabled = v
    end })
    U.toggle(c, "Anti Admin Panel", { get = function() return F.cfg("antiRocketEnabled") end, set = function(v)
        F.setCfg("antiRocketEnabled", v)
        AntiRocketEnabled = v
    end })
    U.toggle(c, "Anti Body Swap", chipOpt("antiSwapEnabled"))
end

do
    local c = U.card(PAGES.Visuals, "ESP")
    U.toggle(c, "Brainrot ESP", { get = function() return U.get("brEsp", false) end, set = function(v) U.set("brEsp", v) end,
        dots = function(r) U.openPop(brESPPop, r) end })
    U.toggle(c, "Player ESP", { get = function() return U.get("plEsp", false) end, set = function(v) U.set("plEsp", v) end,
        dots = function(r) U.openPop(plESPPop, r) end })
    U.toggle(c, "Base ESP", { get = function() return U.get("baseEsp", false) end, set = function(v)
        U.set("baseEsp", v)
        if not v and F.xrayClear then F.xrayClear() end
        if F.baseHud then F.baseHud() end
    end, dots = function(r) U.openPop(baseESPPop, r) end })
    U.toggle(c, "Misc ESP", { get = function() return U.get("miscEsp", false) end, set = function(v) U.set("miscEsp", v) F.miscSync() end,
        dots = function(r) U.openPop(miscESPPop, r) end })
    U.toggle(c, "Pub Method", { get = function() return U.get("pubMethod", false) end, set = function(v) U.set("pubMethod", v) end,
        dots = function(r) U.openPop(pubPop, r) end })
    U.toggle(c, "Custom FOV/Stretch", { get = function() return F.cfg("customFovEnabled") end, set = function(v)
        F.setCfg("customFovEnabled", v)
        if not v and Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 70 end
    end, dots = function(r) U.openPop(fovPop, r) end })
end

do
    local c = U.card(PAGES.Admin, "ADMIN")
    U.toggle(c, "Auto Defense", { get = function() return defWin.f.Visible end, set = function(v) defWin.f.Visible = v end,
        dots = function() U.openSub(defWin) end })
    U.toggle(c, "Admin Panel", { get = function()
        local _, p = F.adminGui()
        return p and p.Visible or false
    end, set = function(v)
        local _, p = F.adminGui()
        if p then p.Visible = v else U.notify("Admin Panel", "You don't own the Admin Panel.") end
    end })
    U.toggle(c, "Admin Spammer", { get = function() return U.get("adminSpamOpen", false) end,
        set = function(v) U.set("adminSpamOpen", v) if F.asShow then F.asShow(v) end end })
    U.toggle(c, "Command Cooldowns", acOpt("cooldownHud", false, function(v) if F.cdShow then F.cdShow(v) end end))
    U.toggle(c, "Intruder Alarm", acOpt("intruder", false))
end

local ACT = U.panel(root, UDim2.fromOffset(150, 302), UDim2.new(0, 16, 0.5, -60), nil, 0, 12, "actions")
ACT.AutomaticSize = Enum.AutomaticSize.Y
ACT.Visible = U.get("actions", false)
U.pad(ACT, 6, 6, 6, 8)
U.list(ACT, 5)
do
    local t = U.text("TextLabel", ACT, "Actions", 12, WB, C.WHITE, Enum.TextXAlignment.Center)
    t.Size = UDim2.new(1, 0, 0, 19)
    U.tgrad(t)
    U.drag(t, ACT, "actions")
end
function F.actionButton(text, fn)
    local b = U.text("TextButton", ACT, text, 12, WB, C.TEXT, Enum.TextXAlignment.Center)
    b.Size = UDim2.new(1, -4, 0, 25)
    b.BackgroundTransparency = 0
    b.BackgroundColor3 = C.ELEM
    b.LayoutOrder = nxt()
    U.round(b, 8) U.stroke(b, 1)
    b.MouseButton1Click:Connect(function()
        local ok, err = pcall(fn, b)
        if not ok then warn("[iCollectPro AURORA] " .. text .. ": " .. tostring(err)) end
    end)
    return b
end
function F.selfRagdoll(t)
    local _, hum = F.char()
    if not hum then return end
    hum:ChangeState(Enum.HumanoidStateType.Physics)
    task.delay(t or 1.2, function() if hum.Parent then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end end)
end
function F.equipUse(name)
    local ch, hum = F.char()
    local bp = LP:FindFirstChild("Backpack")
    local tool = (ch and ch:FindFirstChild(name)) or (bp and bp:FindFirstChild(name))
    if not (tool and hum) then return false end
    if tool.Parent ~= ch then hum:EquipTool(tool) task.wait(0.1) end
    tool:Activate()
    return true
end
F.actionButton("Self Ragdoll", function() F.selfRagdoll(1.2) end)
F.actionButton("Instant Reset", function() F.instaReset() end)
function F.rejoin()
    if game.PrivateServerId == "" and #Players:GetPlayers() > 1 then
        local failed
        failed = TeleportService.TeleportInitFailed:Connect(function(p)
            if p ~= LP then return end
            failed:Disconnect()
            LP:Kick("Rejoining...")
            TeleportService:Teleport(game.PlaceId, LP)
        end)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LP)
    else
        LP:Kick("Rejoining...")
        TeleportService:Teleport(game.PlaceId, LP)
    end
end
F.actionButton("Rejoin", function() F.rejoin() end)
F.actionButton("Leave", function() LP:Kick("Left the game (iCollectPro)") end)
F.actionButton("Ragdoll Tech", function() F.selfRagdoll(0.25) end)
F.actionButton("Flash + Invis", function()
    local cloak = F.equipUse("Invisibility Cloak")
    task.wait(0.15)
    local flash = F.equipUse("Flash Teleport")
    if not (cloak or flash) then U.notify("Flash + Invis", "You need an Invisibility Cloak / Flash Teleport.") end
end)
do
    local cb = F.actionButton("Carpet Speed: OFF", function()
        F.setCfg("carpetSpeedEnabled", not F.cfg("carpetSpeedEnabled"))
        iCollectProFx.carpet = F.cfg("carpetSpeedEnabled")
        for _, f in ipairs(R.rows) do pcall(f) end
        F.actionsCarpet()
    end)
    F.actionsCarpet = function() cb.Text = "Carpet Speed: " .. (F.cfg("carpetSpeedEnabled") and "ON" or "OFF") end
    F.actionsCarpet()
end
F.actionButton("Spam 1", function()
    local t = F.nearestPlayer()
    if t then F.spamCmds(U.get("spam1Cmds", F.SPAM1_DEF), t) end
end)
F.actionButton("Spam 2", function()
    local t = F.nearestPlayer()
    if t then F.spamCmds(U.get("spam2Cmds", F.SPAM2_DEF), t) end
end)

do
    local pg = PAGES.Misc
    local c = U.card(pg)
    U.toggle(c, "Actions", { get = function() return ACT.Visible end, set = function(v) ACT.Visible = v U.set("actions", v) end,
        dots = function() ACT.Visible = not ACT.Visible U.set("actions", ACT.Visible) end })
    U.toggle(c, "ESP Look", { get = function() return espLookWin.f.Visible end, set = function(v) espLookWin.f.Visible = v end,
        dots = function() U.openSub(espLookWin) end })
    c = U.card(pg, "MISC")
    U.keyRow(c, "Menu Keybind", "menu", function() MAIN.Visible = not MAIN.Visible U.set("mainOpen", MAIN.Visible) end)
    U.keyRow(c, "Hide Keybind", "hide", function() gui.Enabled = not gui.Enabled end)
    local fontNames = {}
    for _, f in ipairs(FONTS) do fontNames[#fontNames + 1] = f[1] end
    U.drop(c, "UI Font", fontNames, { get = function() return U.get("font", "Gotham") end, set = function(v) U.set("font", v) U.setFont(v) end })
    U.slider(c, "GUI Transparency (%)", 0, 90, 1, function() return U.get("guiT", 0) end, function(v) U.set("guiT", v) U.applyTransparency() end)
    U.drop(c, "Fly Tool", { "Auto", "Flying Carpet", "Cupid's Wings", "Witch's Broom", "Waverider", "Santa's Sleigh" },
        { get = function() return HubConfig.flyTool or "Auto" end, set = function(v) HubConfig.flyTool = v saveHubConfig() end })
    U.toggle(c, "Quick Grab", chipOpt("quickGrabEnabled"))
    U.toggle(c, "Anti Logger", acOpt("antiLogger", false, function(v) if F.antiLogger then F.antiLogger(v) end end))
    U.toggle(c, "Hide AP Icon", chipOpt("hideApIconEnabled"))
    U.toggle(c, "FPS Optimizer", chipOpt("fpsOptimizerEnabled"))
    U.toggle(c, "Extreme FPS Optimizer", chipOpt("extremeFpsEnabled"))
    U.toggle(c, "Region Trade Block", { get = function() return false end, set = function(v)
        if v then U.notify("Region Trade Block", "Unavailable") task.defer(function() for _, f in ipairs(R.rows) do pcall(f) end end) end
    end, dots = function(r) U.openPop(rtbPop, r) end })
    U.toggle(c, "Trading Plaza Block", { get = function() return false end, set = function(v)
        if v then U.notify("Trading Plaza Block", "Unavailable") task.defer(function() for _, f in ipairs(R.rows) do pcall(f) end end) end
    end, dots = function(r) U.openPop(tpbPop, r) end })
    U.toggle(c, "Region Trade Block V2", { get = function() return false end, set = function(v)
        if v then U.notify("Region Trade Block V2", "Unavailable") task.defer(function() for _, f in ipairs(R.rows) do pcall(f) end end) end
    end, dots = function(r) U.openPop(rtb2Pop, r) end })
    U.button(c, "Reset Config", function() F.resetConfig() end)
    U.button(c, "Panic (Unload Hub)", function() F.panic() end)
end

local PROFILE_FILE = "AURORA_REMAKE_Profiles.json"
local PROF = { active = "Default", autoload = "Default", list = {}, gallery = {} }
pcall(function()
    if isfile and isfile(PROFILE_FILE) then
        local d = HttpService:JSONDecode(readfile(PROFILE_FILE))
        if type(d) == "table" then for k, v in pairs(d) do PROF[k] = v end end
    end
end)
if type(PROF.list) ~= "table" then PROF.list = {} end
if type(PROF.gallery) ~= "table" then PROF.gallery = {} end
local function saveProfiles() pcall(function() writefile(PROFILE_FILE, HttpService:JSONEncode(PROF)) end) end
function F.snapshot()
    local s = HttpService:JSONDecode(HttpService:JSONEncode(HubConfig))
    s.positions = nil
    if type(s.aurora) == "table" then s.aurora.pos = nil s.aurora.size = nil end
    return s
end
function F.applySnapshot(s)
    if type(s) ~= "table" then return false end
    local keepPos, keepAuroraPos, keepSize = HubConfig.positions, AC.pos, AC.size
    for k, v in pairs(s) do
        if k ~= "aurora" and k ~= "positions" then
            if CHIPS[k] and type(v) == "boolean" then pcall(CHIPS[k], v) else HubConfig[k] = v end
        end
    end
    if type(s.aurora) == "table" then
        for k, v in pairs(s.aurora) do if k ~= "pos" and k ~= "size" then AC[k] = v end end
    end
    HubConfig.positions, AC.pos, AC.size = keepPos, keepAuroraPos, keepSize
    currentSpeed = HubConfig.speedValue or currentSpeed
    pcall(function() for _, f in ipairs(iCollectProUI.cfgRefresh or {}) do pcall(f) end end)
    saveHubConfig()
    F.speedSync() F.miscSync()
    C.A1, C.A2 = fromT(AC.accent1, C.A1), fromT(AC.accent2, C.A2)
    U.setFont(U.get("font", "Gotham"))
    U.applyTransparency()
    U.repaintAccent()
    return true
end
function F.profileNames()
    local t = {}
    for n in pairs(PROF.list) do t[#t + 1] = n end
    if #t == 0 then t = { "Default" } end
    table.sort(t)
    return t
end
function F.encode(s)
    local json = HttpService:JSONEncode(s)
    local ok, b = pcall(function() return crypt.base64encode(json) end)
    if ok and type(b) == "string" then return "ICP1:" .. b end
    ok, b = pcall(function() return base64_encode(json) end)
    if ok and type(b) == "string" then return "ICP1:" .. b end
    return "ICP0:" .. json
end
function F.decode(code)
    code = tostring(code or ""):gsub("%s", "")
    local body
    if code:sub(1, 5) == "ICP1:" then
        local ok, j = pcall(function() return crypt.base64decode(code:sub(6)) end)
        if not ok then ok, j = pcall(function() return base64_decode(code:sub(6)) end) end
        body = ok and j or nil
    elseif code:sub(1, 5) == "ICP0:" then
        body = code:sub(6)
    end
    if not body then return nil end
    local ok, t = pcall(function() return HttpService:JSONDecode(body) end)
    return ok and t or nil
end
local exploreHolder
function F.renderExplore()
    if not exploreHolder then return end
    for _, ch in ipairs(exploreHolder:GetChildren()) do if ch:IsA("Frame") then ch:Destroy() end end
    local items = {}
    for _, g in ipairs(PROF.gallery) do items[#items + 1] = g end
    for _, n in ipairs(F.profileNames()) do
        if #items >= 5 then break end
        items[#items + 1] = { name = n, data = PROF.list[n], likes = 0, dislikes = 0, local_ = true }
    end
    for i = 1, math.min(#items, 5) do
        local it = items[i]
        local f = new("Frame", { Size = UDim2.new(1, 0, 0, 50), BackgroundColor3 = C.ELEM, BorderSizePixel = 0, LayoutOrder = i }, exploreHolder)
        U.round(f, 10) U.stroke(f, 1)
        local n = U.text("TextLabel", f, "#" .. i, 12, WB, C.DIM)
        n.Position = UDim2.fromOffset(11, 7) n.Size = UDim2.fromOffset(22, 16)
        local nm = U.text("TextLabel", f, tostring(it.name), 13, WB, C.TEXT)
        nm.Position = UDim2.fromOffset(33, 7) nm.Size = UDim2.new(1, -44, 0, 16) nm.TextTruncate = Enum.TextTruncate.AtEnd
        local function small(text, pos, w, fn)
            local b = U.text("TextButton", f, text, 12, WM, C.DIM, Enum.TextXAlignment.Center)
            b.BackgroundTransparency = 0 b.BackgroundColor3 = C.CARD
            b.AnchorPoint = Vector2.new(pos.X.Scale, 0)
            b.Position = pos b.Size = UDim2.fromOffset(w, 18)
            U.round(b, 10)
            b.MouseButton1Click:Connect(function() pcall(fn, b) end)
            return b
        end
        small("♥ " .. tostring(it.likes or 0), UDim2.new(0, 11, 1, -23), 52, function(b) it.likes = (it.likes or 0) + 1 b.Text = "♥ " .. it.likes saveProfiles() end)
        small("👎 " .. tostring(it.dislikes or 0), UDim2.new(0, 67, 1, -23), 52, function(b) it.dislikes = (it.dislikes or 0) + 1 b.Text = "👎 " .. it.dislikes saveProfiles() end)
        small("Import", UDim2.new(1, -11, 1, -23), 60, function()
            local d = it.data or (it.code and F.decode(it.code))
            if F.applySnapshot(d) then U.notify("Configs", "Imported " .. tostring(it.name)) else U.notify("Configs", "Nothing to import") end
        end)
    end
end
do
    local pg = PAGES.Configs
    local c = U.card(pg, "PROFILES")
    U.drop(c, "Active Config", F.profileNames, { get = function() return PROF.active end, set = function(v) PROF.active = v saveProfiles() end })
    U.button(c, "Load", function()
        local d = PROF.list[PROF.active]
        if d and F.applySnapshot(d) then U.notify("Configs", "Loaded " .. PROF.active) else U.notify("Configs", "'" .. PROF.active .. "' has nothing saved yet") end
    end)
    U.button(c, "Save Current", function()
        PROF.list[PROF.active] = F.snapshot()
        saveProfiles()
        F.renderExplore()
        U.notify("Configs", "Saved " .. PROF.active)
    end)
    U.toggle(c, "Manage", { get = function() return manageWin.f.Visible end, set = function(v) manageWin.f.Visible = v end,
        dots = function() U.openSub(manageWin) end })
    U.toggle(c, "Share & Import", { get = function() return shareWin.f.Visible end, set = function(v) shareWin.f.Visible = v end,
        dots = function(r) U.openPop(shareWin, r) end })
    c = U.card(pg, "EXPLORE")
    exploreHolder = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = nxt() }, c)
    U.list(exploreHolder, 7)
    F.renderExplore()
end
do
    local nameBox = U.input(manageWin.card, "Name", "config name", "")
    local function nm() local t = nameBox.Text:gsub("^%s+", ""):gsub("%s+$", "") return t end
    U.button(manageWin.card, "Create New", function()
        local n = nm()
        if n == "" then U.notify("Configs", "Type a name first") return end
        local base, k = n, 2
        while PROF.list[n] do n = base .. " (" .. k .. ")" k = k + 1 end
        PROF.list[n] = F.snapshot()
        PROF.active = n
        saveProfiles()
        for _, f in ipairs(R.rows) do pcall(f) end
        F.renderExplore()
        U.notify("Configs", "Created " .. n)
    end)
    U.button(manageWin.card, "Rename Active", function()
        local n = nm()
        if n == "" or PROF.list[n] then U.notify("Configs", "Pick a new, unused name") return end
        PROF.list[n] = PROF.list[PROF.active] or F.snapshot()
        PROF.list[PROF.active] = nil
        if PROF.autoload == PROF.active then PROF.autoload = n end
        PROF.active = n
        saveProfiles()
        for _, f in ipairs(R.rows) do pcall(f) end
        F.renderExplore()
    end)
    local auto
    auto = U.button(manageWin.card, "Autoload: " .. tostring(PROF.autoload), function(l)
        PROF.autoload = PROF.autoload == PROF.active and "None" or PROF.active
        saveProfiles()
        l.Text = "Autoload: " .. tostring(PROF.autoload)
    end)
    U.button(manageWin.card, "Delete Active", function()
        PROF.list[PROF.active] = nil
        if PROF.autoload == PROF.active then PROF.autoload = "None" auto.Text = "Autoload: None" end
        PROF.active = F.profileNames()[1]
        saveProfiles()
        for _, f in ipairs(R.rows) do pcall(f) end
        F.renderExplore()
    end)
end
do
    local codeBox
    U.button(shareWin.body, "Get Share Code", function()
        local code = F.encode(F.snapshot())
        if setclipboard then setclipboard(code) U.notify("Share & Import", "Share code copied to clipboard") end
        if codeBox then codeBox.Text = code end
    end)
    U.button(shareWin.body, "Post to Gallery", function()
        table.insert(PROF.gallery, 1, { name = PROF.active, data = F.snapshot(), likes = 0, dislikes = 0 })
        while #PROF.gallery > 5 do table.remove(PROF.gallery) end
        saveProfiles()
        F.renderExplore()
        U.notify("Share & Import", "Posted " .. PROF.active .. " to Explore")
    end)
    codeBox = U.input(shareWin.body, "Import Code", "paste code", "")
    U.button(shareWin.body, "Import From Code", function()
        local d = F.decode(codeBox.Text)
        if d and F.applySnapshot(d) then U.notify("Share & Import", "Config imported") else U.notify("Share & Import", "That code isn't valid") end
    end)
end

local PILL = new("Frame", { Position = UDim2.fromOffset(16, 64), Size = UDim2.fromOffset(378, 48), BackgroundTransparency = 1 }, root)
U.loadPos("pill", PILL)
local statsPanel
do
    local logo = new("Frame", { Size = UDim2.fromOffset(48, 48), BackgroundColor3 = C.CARD, BackgroundTransparency = 0.06, BorderSizePixel = 0 }, PILL)
    U.round(logo, 18) U.stroke(logo, 1.4)
    R.wins[#R.wins + 1] = { f = logo, base = 0.06 }
    local lt = U.text("TextLabel", logo, "iC", 18, WB, C.WHITE, Enum.TextXAlignment.Center)
    lt.Size = UDim2.fromScale(1, 1)
    U.tgrad(lt)
    local info = new("Frame", { Position = UDim2.fromOffset(53, 0), Size = UDim2.new(1, -53, 0, 48), BackgroundColor3 = C.CARD,
        BackgroundTransparency = 0.06, BorderSizePixel = 0 }, PILL)
    U.round(info, 20) U.stroke(info, 1.4)
    R.wins[#R.wins + 1] = { f = info, base = 0.06 }
    local t = U.text("TextLabel", info, "iCollectPro", 16, WB, C.WHITE)
    t.Position = UDim2.fromOffset(13, 7) t.Size = UDim2.fromOffset(92, 21)
    U.tgrad(t)
    local v = U.text("TextLabel", info, "v1.5.7", 10, WM, C.DIM)
    v.Position = UDim2.fromOffset(13, 28) v.Size = UDim2.fromOffset(78, 13)
    local stats = new("Frame", { Position = UDim2.fromOffset(108, 0), Size = UDim2.new(1, -112, 1, 0), BackgroundTransparency = 1 }, info)
    local function cell(x)
        local b = new("TextButton", { Position = UDim2.fromScale(x, 0), Size = UDim2.fromScale(0.5, 1), BackgroundTransparency = 1, Text = "", AutoButtonColor = false }, stats)
        new("Frame", { Position = UDim2.new(0, 0, 0.3, 0), Size = UDim2.new(0, 1, 0.4, 0), BackgroundColor3 = C.SEP, BackgroundTransparency = 0.5, BorderSizePixel = 0 }, b)
        local icon = new("Frame", { Position = UDim2.new(0, 8, 0.5, -8), Size = UDim2.fromOffset(17, 17), BackgroundTransparency = 1 }, b)
        local l = U.text("TextLabel", b, "--", 12, WB, C.GOOD)
        l.Position = UDim2.fromOffset(30, 0) l.Size = UDim2.new(1, -31, 1, 0)
        return b, icon, l
    end
    local fb, fIcon, fLbl = cell(0)
    local pb, pIcon, pLbl = cell(0.5)
    local mon = new("Frame", { Position = UDim2.fromOffset(1, 2), Size = UDim2.fromOffset(14, 9), BackgroundTransparency = 1 }, fIcon)
    U.round(mon, 1)
    local ms = new("UIStroke", { Color = C.A1, Thickness = 1.4 }, mon)
    for _, s in ipairs({ { 8, 14, 7 }, { 8, 13, 4 } }) do
        local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(s[1], s[2]), Size = UDim2.fromOffset(s[3], 1),
            BackgroundColor3 = C.A1, BorderSizePixel = 0 }, fIcon)
        R.bg1[#R.bg1 + 1] = f
    end
    for _, s in ipairs({ { 3, 12, 5 }, { 8, 10, 9 }, { 13, 8, 14 } }) do
        local f = new("Frame", { AnchorPoint = Vector2.new(0.5, 0), Position = UDim2.fromOffset(s[1], s[2]), Size = UDim2.fromOffset(s[3], 1),
            BackgroundColor3 = C.A2, BorderSizePixel = 0 }, pIcon)
        R.bg2[#R.bg2 + 1] = f
    end
    F.statsLabels = { fps = fLbl, ping = pLbl, monStroke = ms }

    statsPanel = new("Frame", { Position = UDim2.fromOffset(0, 54), Size = UDim2.new(1, 0, 0, 150), BackgroundColor3 = C.WIN,
        BackgroundTransparency = 0.06, BorderSizePixel = 0, Visible = U.get("statsOpen", false), ClipsDescendants = true }, PILL)
    U.round(statsPanel, 18) U.stroke(statsPanel, 1.4)
    R.wins[#R.wins + 1] = { f = statsPanel, base = 0.06 }
    local inner = new("Frame", { Position = UDim2.fromOffset(12, 12), Size = UDim2.new(1, -24, 1, -24), BackgroundTransparency = 1 }, statsPanel)
    local graph = new("Frame", { Position = UDim2.fromOffset(0, 58), Size = UDim2.new(1, -4, 1, -58), BackgroundTransparency = 1 }, inner)
    local N = 38
    local function column(x, title, accentKey)
        local col = new("Frame", { Position = UDim2.new(x, x > 0 and 3 or 0, 0, 0), Size = UDim2.new(0.5, -3, 0, 52), BackgroundTransparency = 1 }, inner)
        local h = U.text("TextLabel", col, title, 11, WB, C[accentKey])
        h.Size = UDim2.new(1, 0, 0, 15)
        R[accentKey == "A1" and "tx1" or "tx2"][#R[accentKey == "A1" and "tx1" or "tx2"] + 1] = h
        local lo = U.text("TextLabel", col, "--", 10, WM, C[accentKey])
        lo.Position = UDim2.fromOffset(16, 19) lo.Size = UDim2.new(0.5, -16, 0, 17)
        local hi = U.text("TextLabel", col, "--", 10, WM, C[accentKey])
        hi.Position = UDim2.new(0.5, 16, 0, 19) hi.Size = UDim2.new(0.5, -16, 0, 17)
        for _, l in ipairs({ lo, hi }) do R[accentKey == "A1" and "tx1" or "tx2"][#R[accentKey == "A1" and "tx1" or "tx2"] + 1] = l end
        for k, ax in ipairs({ 0, 0.5 }) do
            local ic = new("Frame", { Position = UDim2.new(ax, 0, 0, 22), Size = UDim2.fromOffset(12, 12), BackgroundTransparency = 1 }, col)
            local spec = k == 1 and { { 6, 6, 8 }, { 7, 7, 5 }, { 4, 7, 5 } } or { { 4, 4, 5 }, { 7, 4, 5 }, { 6, 6, 8 } }
            for _, s in ipairs(spec) do
                local f = new("Frame", { Position = UDim2.fromOffset(s[1] - math.floor(s[3] / 2), s[2]), Size = UDim2.fromOffset(s[3], 1),
                    BackgroundColor3 = C[accentKey], BorderSizePixel = 0 }, ic)
                R[accentKey == "A1" and "bg1" or "bg2"][#R[accentKey == "A1" and "bg1" or "bg2"] + 1] = f
            end
        end
        local st = U.text("TextLabel", col, "Waiting for samples", 9, WM, C.DIM)
        st.Position = UDim2.fromOffset(0, 38) st.Size = UDim2.new(1, 0, 0, 12)
        local bars = {}
        for i = 1, N do
            local b = new("Frame", { AnchorPoint = Vector2.new(0, 1), Position = UDim2.new(x + (i - 1) / N * 0.5, 0, 1, 0), Size = UDim2.new(0.5 / N, -1, 0, 0),
                BackgroundColor3 = C[accentKey], BorderSizePixel = 0 }, graph)
            U.round(b, 1)
            R[accentKey == "A1" and "bg1" or "bg2"][#R[accentKey == "A1" and "bg1" or "bg2"] + 1] = b
            bars[i] = b
        end
        return { lo = lo, hi = hi, st = st, bars = bars, samples = {} }
    end
    F.fpsCol = column(0, "FPS", "A1")
    F.pingCol = column(0.5, "Data ping", "A2")
    local toggleBtn = new("TextButton", { Size = UDim2.fromOffset(145, 48), BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 3 }, PILL)
    U.drag(toggleBtn, PILL, "pill", function()
        statsPanel.Visible = not statsPanel.Visible
        U.set("statsOpen", statsPanel.Visible)
    end)
    for _, b in ipairs({ fb, pb }) do
        b.MouseButton1Click:Connect(function()
            statsPanel.Visible = not statsPanel.Visible
            U.set("statsOpen", statsPanel.Visible)
        end)
    end
end

local MENU = new("ImageButton", { AnchorPoint = Vector2.new(0, 0.5), Position = UDim2.new(0, 16, 0.5, 0), Size = UDim2.fromOffset(44, 44),
    BackgroundColor3 = C.CARD, BorderSizePixel = 0, Image = "", AutoButtonColor = false }, root)
U.round(MENU, 0.5, true) U.stroke(MENU, 1.4)
U.loadPos("menuBtn", MENU)
do
    local l = U.text("TextLabel", MENU, "iC", 15, WB, C.WHITE, Enum.TextXAlignment.Center)
    l.Size = UDim2.fromScale(1, 1)
    U.tgrad(l)
    U.drag(MENU, MENU, "menuBtn", function() MAIN.Visible = not MAIN.Visible U.set("mainOpen", MAIN.Visible) end)
end

local BAR = new("Frame", { AnchorPoint = Vector2.new(0.5, 1), Position = UDim2.new(0.5, 0, 0.78, 10), Size = UDim2.fromOffset(240, 34),
    BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true }, root)
U.round(BAR, 10) U.stroke(BAR, 1.2)
R.wins[#R.wins + 1] = { f = BAR, base = 0 }
U.loadPos("bar", BAR)
do
    local title = U.text("TextLabel", BAR, "Auto Steal", 12, WB, C.TEXT)
    title.Position = UDim2.fromOffset(10, 0) title.Size = UDim2.new(1, -20, 0, 18)
    title.TextTruncate = Enum.TextTruncate.AtEnd
    local track = new("Frame", { Position = UDim2.new(0, 10, 1, -11), Size = UDim2.new(1, -20, 0, 5), BackgroundColor3 = C.ELEM, BorderSizePixel = 0 }, BAR)
    U.round(track, 3)
    local fill = new("Frame", { Size = UDim2.fromScale(0, 1), BackgroundColor3 = C.A1, BorderSizePixel = 0 }, track)
    U.round(fill, 3)
    R.fg[#R.fg + 1] = new("UIGradient", { Color = U.seq2() }, fill)
    R.bg1[#R.bg1 + 1] = fill
    local pct = U.text("TextLabel", track, "Waiting for target", 11, WB, C.TEXT, Enum.TextXAlignment.Right)
    pct.AnchorPoint = Vector2.new(1, 1) pct.Position = UDim2.new(1, 0, 0, -3) pct.Size = UDim2.fromOffset(118, 14)
    U.drag(BAR, BAR, "bar")
    U.resizer(BAR, 180, 34, "bar", 14)
    F.bar = { title = title, fill = fill, pct = pct }
end

local ALLOW = U.text("TextButton", root, "Allow / Disallow", 13, WB, C.TEXT, Enum.TextXAlignment.Center)
ALLOW.AnchorPoint = Vector2.new(0.5, 0.5)
ALLOW.Position = UDim2.new(0.5, 0, 0.9, 0)
ALLOW.Size = UDim2.fromOffset(150, 36)
ALLOW.BackgroundTransparency = 0
ALLOW.BackgroundColor3 = C.CARD
U.round(ALLOW, 10) U.stroke(ALLOW, 1.2)
U.loadPos("allow", ALLOW)
U.drag(ALLOW, ALLOW, "allow", function()
    local _, _, hrp = F.char()
    local my = F.myPlot()
    local target, md = nil, math.huge
    for desc in pairs(iCollectProUI.friendPrompts or {}) do
        if desc.Parent then
            local part = iCollectProUI.promptPart(desc)
            if part and hrp and my and part:IsDescendantOf(my) then
                local d = (hrp.Position - part.Position).Magnitude
                if d < md then target, md = desc, d end
            end
        end
    end
    if target and fireproximityprompt then fireproximityprompt(target) else U.notify("Allow / Disallow", "Your base's friend panel wasn't found") end
end)

local FLOORS = new("Frame", { Position = UDim2.fromOffset(865, 40), Size = UDim2.fromOffset(190, 42), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true }, root)
U.round(FLOORS, 10) U.stroke(FLOORS, 1.2)
R.wins[#R.wins + 1] = { f = FLOORS, base = 0 }
U.loadPos("floors", FLOORS)
do
    local l = U.list(FLOORS, 6, Enum.FillDirection.Horizontal)
    l.VerticalAlignment = Enum.VerticalAlignment.Center
    U.pad(FLOORS, 6, 6)
    local grip = U.text("TextLabel", FLOORS, ":", 14, WB, C.DIM, Enum.TextXAlignment.Center)
    grip.Size = UDim2.fromOffset(10, 42)
    grip.LayoutOrder = 0
    grip.Active = true
    U.drag(grip, FLOORS, "floors")
    for n = 1, 3 do
        local b = U.text("TextButton", FLOORS, tostring(n), 17, WB, C.TEXT, Enum.TextXAlignment.Center)
        b.Size = UDim2.fromOffset(48, 34)
        b.LayoutOrder = n
        b.BackgroundTransparency = 0
        b.BackgroundColor3 = C.ELEM
        U.round(b, 8)
        b.MouseButton1Click:Connect(function() F.goFloor(n) end)
    end
end
function F.floors(plot)
    local spawns = {}
    local pods = plot and plot:FindFirstChild("AnimalPodiums")
    for _, pod in ipairs(pods and pods:GetChildren() or {}) do
        local sp = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
        if sp then spawns[#spawns + 1] = sp end
    end
    table.sort(spawns, function(a, b) return a.Position.Y < b.Position.Y end)
    local floors = {}
    for _, sp in ipairs(spawns) do
        local last = floors[#floors]
        if not last or sp.Position.Y - last[1].Position.Y > 8 then floors[#floors + 1] = { sp } else last[#last + 1] = sp end
    end
    return floors
end
function F.goFloor(n)
    if F.stealing() then U.notify("Floors", "Not while carrying a brainrot") return end
    local plot = F.myPlot()
    local _, _, hrp = F.char()
    if not (plot and hrp) then return end
    local floors = F.floors(plot)
    local fl = floors[n]
    if not fl then U.notify("Floors", "Your base has no floor " .. n) return end
    local sum = Vector3.zero
    for _, sp in ipairs(fl) do sum = sum + sp.Position end
    local centre = sum / #fl
    if n == 1 and plot:FindFirstChild("Spawn") then
        hrp.CFrame = plot.Spawn.CFrame + Vector3.new(0, 4, 0)
    else
        hrp.CFrame = CFrame.new(centre + Vector3.new(0, 4, 0))
    end
end

local MYBASE = new("Frame", { Position = UDim2.fromOffset(14, 220), Size = UDim2.fromOffset(196, 56), BackgroundColor3 = C.CARD, BorderSizePixel = 0, Active = true }, root)
U.round(MYBASE, 12) U.stroke(MYBASE, 1.2)
R.wins[#R.wins + 1] = { f = MYBASE, base = 0 }
U.loadPos("mybase", MYBASE)
U.drag(MYBASE, MYBASE, "mybase")
do
    local a = U.text("TextLabel", MYBASE, "MY BASE", 11, WB, C.DIM)
    a.Position = UDim2.fromOffset(9, 5) a.Size = UDim2.new(1, -18, 0, 14)
    local b = U.text("TextLabel", MYBASE, "UNLOCKED", 20, WB, C.OPEN)
    b.Position = UDim2.fromOffset(9, 22) b.Size = UDim2.new(1, -18, 0, 26)
    F.baseLbl = b
end
F.baseHud = function() MYBASE.Visible = U.get("baseEsp", false) and U.get("baseTimer", true) and U.get("timerHud", true) end
F.baseHud()

local CD = U.panel(root, UDim2.fromOffset(150, 0), UDim2.new(0, 172, 0.5, -60), nil, 0, 12, "cooldowns", 1)
CD.AutomaticSize = Enum.AutomaticSize.Y
CD.Visible = U.get("cooldownHud", false)
U.pad(CD, 8, 8, 6, 8)
U.list(CD, 2)
do
    local t = U.text("TextLabel", CD, "Cooldowns", 12, WB, C.WHITE, Enum.TextXAlignment.Center)
    t.Size = UDim2.new(1, 0, 0, 18)
    U.tgrad(t)
    U.drag(t, CD, "cooldowns")
    F.cdRows = {}
    for i, cmd in ipairs(F.CMDS) do
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, LayoutOrder = i }, CD)
        local n = U.text("TextLabel", r, cmd, 11, WM, C.TEXT)
        n.Size = UDim2.fromScale(0.65, 1)
        local v = U.text("TextLabel", r, "ready", 11, WB, C.GOOD, Enum.TextXAlignment.Right)
        v.Position = UDim2.fromScale(0.65, 0) v.Size = UDim2.fromScale(0.35, 1)
        F.cdRows[cmd] = v
    end
end
F.cdShow = function(v) CD.Visible = v end

F.SPAM1_DEF = { "balloon", "tiny", "inverse", "rocket" }
F.SPAM2_DEF = { "ragdoll", "jail", "jumpscare", "morph" }
local AS = U.panel(root, UDim2.fromOffset(320, 360), UDim2.new(0.5, 180, 0.5, -180), nil, 0, 16, "adminspam")
AS.Visible = U.get("adminSpamOpen", false)
do
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1 }, AS)
    local t = U.text("TextLabel", hd, "Admin Spammer", 13, WB, C.WHITE)
    t.Position = UDim2.fromOffset(11, 0) t.Size = UDim2.new(1, -40, 1, 0)
    U.tgrad(t)
    local x = U.text("TextButton", hd, "X", 12, WB, C.DIM, Enum.TextXAlignment.Center)
    x.Position = UDim2.new(1, -34, 0, 6) x.Size = UDim2.fromOffset(24, 24)
    x.MouseButton1Click:Connect(function() AS.Visible = false U.set("adminSpamOpen", false) for _, f in ipairs(R.rows) do pcall(f) end end)
    U.drag(hd, AS, "adminspam")
    U.resizer(AS, 260, 200, "adminspam")
    local body = U.scroller(AS, UDim2.fromOffset(0, 36), UDim2.new(1, 0, 1, -36), 10, 6)

    local function which(cmd)
        if table.find(U.get("spam1Cmds", F.SPAM1_DEF), cmd) then return 1 end
        if table.find(U.get("spam2Cmds", F.SPAM2_DEF), cmd) then return 2 end
        return 0
    end
    local function assign(cmd, n)
        local s1 = table.clone(U.get("spam1Cmds", F.SPAM1_DEF))
        local s2 = table.clone(U.get("spam2Cmds", F.SPAM2_DEF))
        local i1, i2 = table.find(s1, cmd), table.find(s2, cmd)
        if i1 then table.remove(s1, i1) end
        if i2 then table.remove(s2, i2) end
        if n == 1 then s1[#s1 + 1] = cmd elseif n == 2 then s2[#s2 + 1] = cmd end
        U.set("spam1Cmds", s1) U.set("spam2Cmds", s2)
    end
    local cfgBtn = U.text("TextButton", body, "Configure Commands  v", 11, WB, C.DIM, Enum.TextXAlignment.Center)
    cfgBtn.Size = UDim2.new(1, 0, 0, 28) cfgBtn.BackgroundTransparency = 0 cfgBtn.BackgroundColor3 = C.ELEM cfgBtn.LayoutOrder = 1
    U.round(cfgBtn, 8) U.stroke(cfgBtn, 1)
    local cfgList = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Visible = false, LayoutOrder = 2 }, body)
    U.list(cfgList, 3)
    for i, cmd in ipairs(F.CMDS) do
        local r = new("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = i }, cfgList)
        local l = U.text("TextLabel", r, cmd, 12, WM, C.TEXT)
        l.Position = UDim2.fromOffset(8, 0) l.Size = UDim2.new(1, -64, 1, 0)
        local bs = {}
        local function paint()
            local w = which(cmd)
            for n, b in pairs(bs) do b.BackgroundColor3 = (w == n) and C.A1 or C.ELEM end
        end
        for n, xo in ipairs({ -30, -2 }) do
            local b = U.text("TextButton", r, tostring(n), 12, WB, C.TEXT, Enum.TextXAlignment.Center)
            b.AnchorPoint = Vector2.new(1, 0.5) b.Position = UDim2.new(1, xo, 0.5, 0) b.Size = UDim2.fromOffset(24, 20)
            b.BackgroundTransparency = 0
            U.round(b, 4)
            bs[n] = b
            b.MouseButton1Click:Connect(function() assign(cmd, which(cmd) == n and 0 or n) paint() end)
        end
        paint()
    end
    cfgBtn.MouseButton1Click:Connect(function()
        cfgList.Visible = not cfgList.Visible
        cfgBtn.Text = cfgList.Visible and "Configure Commands  ^" or "Configure Commands  v"
    end)
    new("Frame", { Size = UDim2.new(1, 0, 0, 1), BackgroundColor3 = C.ELEM, BorderSizePixel = 0, LayoutOrder = 3 }, body)
    local plist = new("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 4 }, body)
    U.list(plist, 4)

    local joinN, joinOf, rows, nextSpam = 0, {}, {}, 1
    for _, p in ipairs(Players:GetPlayers()) do joinN += 1 joinOf[p] = joinN end
    local function addRow(p)
        if p == LP or rows[p] then return end
        if not joinOf[p] then joinN += 1 joinOf[p] = joinN end
        local b = new("TextButton", { Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = C.CARD, BorderSizePixel = 0, AutoButtonColor = false,
            Text = "", LayoutOrder = joinOf[p] }, plist)
        U.round(b, 8) U.stroke(b, 1)
        local av = new("ImageLabel", { Size = UDim2.fromOffset(34, 34), Position = UDim2.new(0, 8, 0.5, -17), BackgroundTransparency = 1,
            ScaleType = Enum.ScaleType.Fit }, b)
        U.round(av, 17)
        task.spawn(function()
            local ok, img = pcall(Players.GetUserThumbnailAsync, Players, p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
            if ok and av.Parent then av.Image = img end
        end)
        local dot = new("Frame", { Size = UDim2.fromOffset(9, 9), Position = UDim2.new(0, 31, 0.5, 6), BackgroundColor3 = rgb(110, 110, 118),
            BorderSizePixel = 0, ZIndex = 3 }, b)
        U.round(dot, 5)
        local n = U.text("TextLabel", b, p.DisplayName, 14, WB, C.TEXT)
        n.Position = UDim2.fromOffset(46, 3) n.Size = UDim2.new(1, -54, 0, 15) n.TextTruncate = Enum.TextTruncate.AtEnd
        local u = U.text("TextLabel", b, "@" .. p.Name, 11, WR, C.DIM)
        u.Position = UDim2.fromOffset(46, 16) u.Size = UDim2.new(1, -54, 0, 11) u.TextTruncate = Enum.TextTruncate.AtEnd
        local badge = U.text("TextLabel", b, "", 10, WB, C.A2)
        badge.Position = UDim2.fromOffset(46, 27) badge.Size = UDim2.new(1, -54, 0, 11)
        local jo = U.text("TextLabel", b, "Joined #" .. joinOf[p], 11, WM, C.TEXT)
        jo.Name = "PlayerJoinOrder"
        jo.Position = UDim2.fromOffset(46, 39) jo.Size = UDim2.new(1, -54, 0, 13)
        b.MouseEnter:Connect(function() b.BackgroundColor3 = C.ELEM end)
        b.MouseLeave:Connect(function() b.BackgroundColor3 = C.CARD end)
        b.MouseButton1Click:Connect(function()
            if nextSpam == 1 then
                F.spamCmds(U.get("spam1Cmds", F.SPAM1_DEF), p) nextSpam = 2
            else
                F.spamCmds(U.get("spam2Cmds", F.SPAM2_DEF), p) nextSpam = 1
            end
        end)
        rows[p] = { row = b, dot = dot, badge = badge }
    end
    for _, p in ipairs(Players:GetPlayers()) do addRow(p) end
    U.on(Players.PlayerAdded, addRow)
    U.on(Players.PlayerRemoving, function(p)
        if rows[p] then rows[p].row:Destroy() rows[p] = nil end
        joinOf[p] = nil
    end)
    F.asRefresh = function()
        if not AS.Visible then return end
        local my = F.myPlot()
        local centre = my and my:GetPivot().Position
        for p, r in pairs(rows) do
            local root_ = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            local moving = root_ and Vector3.new(root_.AssemblyLinearVelocity.X, 0, root_.AssemblyLinearVelocity.Z).Magnitude > 1
            r.dot.BackgroundColor3 = moving and rgb(80, 225, 120) or rgb(110, 110, 118)
            local inBase = centre and root_ and (root_.Position - centre).Magnitude < 70
            r.badge.Text = p:GetAttribute("Stealing") and inBase and "STEALING FROM YOU" or (inBase and "IN YOUR BASE" or "")
        end
    end
end
F.asShow = function(v) AS.Visible = v end

local PRI = U.panel(root, UDim2.fromOffset(320, 360), UDim2.new(0.5, 534, 0.5, -141), nil, 0.72, 16, "priority")
PRI.Visible = U.get("autoPriority", false)
local priList
do
    local hd = new("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1 }, PRI)
    local t = U.text("TextLabel", hd, "Priority Steal", 13, WB, C.WHITE)
    t.Position = UDim2.fromOffset(9, 0) t.Size = UDim2.new(1, -38, 1, 0)
    U.tgrad(t)
    local x = U.text("TextButton", hd, "X", 14, WB, C.DIM, Enum.TextXAlignment.Center)
    x.Position = UDim2.new(1, -36, 0, 0) x.Size = UDim2.fromOffset(36, 36)
    x.MouseButton1Click:Connect(function() PRI.Visible = false end)
    U.drag(hd, PRI, "priority")
    priList = U.scroller(PRI, UDim2.fromOffset(0, 36), UDim2.new(1, 0, 1, -36), 8, 6)
    U.resizer(PRI, 260, 200, "priority")
end
F.priorityShow = function(v) PRI.Visible = v end
AC.priority = type(AC.priority) == "table" and AC.priority or {}
local priCards, priThumbs = {}, {}
function F.thumb(model)
    if priThumbs[model.Name] then return priThumbs[model.Name]:Clone() end
    local vf = new("ViewportFrame", { Size = UDim2.fromOffset(56, 56), BackgroundColor3 = C.ELEM, BorderSizePixel = 0, Ambient = rgb(200, 200, 200),
        LightColor = rgb(255, 255, 255) })
    U.round(vf, 8)
    pcall(function()
        local arch = model.Archivable
        model.Archivable = true
        local m = model:Clone()
        model.Archivable = arch
        for _, d in ipairs(m:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") or d:IsA("BillboardGui") or d:IsA("Sound") then d:Destroy() end
        end
        m:PivotTo(CFrame.new())
        m.Parent = vf
        local cam = new("Camera", {}, vf)
        local cf, size = m:GetBoundingBox()
        local r = math.max(size.X, size.Y, size.Z)
        cam.CFrame = CFrame.lookAt(cf.Position + Vector3.new(r * 0.9, r * 0.45, r * 0.9), cf.Position)
        vf.CurrentCamera = cam
    end)
    priThumbs[model.Name] = vf
    return vf:Clone()
end
function F.renderPriority()
    if not PRI.Visible then return end
    local seen, items = {}, {}
    for _, b in ipairs(F.brainrots()) do
        local key = b.model:GetDebugId()
        if not seen[key] then seen[key] = true items[#items + 1] = b end
    end
    local function rank(name) return table.find(AC.priority, name) end
    table.sort(items, function(a, b)
        local ra, rb = rank(a.name), rank(b.name)
        if ra and rb then return ra < rb end
        if ra or rb then return ra ~= nil end
        return a.gen > b.gen
    end)
    local want = {}
    for i, it in ipairs(items) do
        local key = it.model:GetDebugId()
        want[key] = true
        local c = priCards[key]
        if not c then
            local f = new("Frame", { Size = UDim2.new(1, 0, 0, 100), BackgroundColor3 = C.CARD, BorderSizePixel = 0 }, priList)
            U.round(f, 10) U.stroke(f, 1)
            local st = U.text("TextLabel", f, "Tap to select", 12, WB, C.DIM)
            st.Position = UDim2.fromOffset(6, 2) st.Size = UDim2.new(1, -12, 0, 22)
            local th = F.thumb(it.model)
            th.Position = UDim2.fromOffset(6, 30)
            th.Parent = f
            local nm = U.text("TextLabel", f, it.name, 12, WB, C.TEXT)
            nm.Position = UDim2.fromOffset(66, 27) nm.Size = UDim2.new(1, -70, 0, 30) nm.TextTruncate = Enum.TextTruncate.AtEnd
            local gn = U.text("TextLabel", f, it.genText, 10, WR, C.DIM)
            gn.Position = UDim2.fromOffset(66, 58) gn.Size = UDim2.new(1, -70, 0, 17)
            local ow = U.text("TextLabel", f, it.owner, 10, WR, C.DIM)
            ow.Position = UDim2.fromOffset(66, 77) ow.Size = UDim2.new(1, -70, 0, 17)
            local hit = U.hit(f, 2)
            hit.MouseButton1Click:Connect(function()
                local idx = table.find(AC.priority, it.name)
                if idx then table.remove(AC.priority, idx) else AC.priority[#AC.priority + 1] = it.name end
                saveHubConfig()
                F.renderPriority()
            end)
            local function mv(dir)
                local idx = table.find(AC.priority, it.name)
                local j = idx and idx + dir
                if idx and j >= 1 and j <= #AC.priority then
                    AC.priority[idx], AC.priority[j] = AC.priority[j], AC.priority[idx]
                    saveHubConfig()
                    F.renderPriority()
                end
            end
            local up = U.text("TextButton", f, "Up", 12, WB, C.TEXT, Enum.TextXAlignment.Center)
            up.Position = UDim2.new(1, -47, 0, 4) up.Size = UDim2.fromOffset(44, 44) up.BackgroundTransparency = 0 up.BackgroundColor3 = C.CARD up.ZIndex = 3
            U.round(up, 8) U.stroke(up, 1)
            up.MouseButton1Click:Connect(function() mv(-1) end)
            local dn = U.text("TextButton", f, "Down", 12, WB, C.TEXT, Enum.TextXAlignment.Center)
            dn.Position = UDim2.new(1, -47, 0, 52) dn.Size = UDim2.fromOffset(44, 44) dn.BackgroundTransparency = 0 dn.BackgroundColor3 = C.CARD dn.ZIndex = 3
            U.round(dn, 8) U.stroke(dn, 1)
            dn.MouseButton1Click:Connect(function() mv(1) end)
            c = { f = f, st = st, gn = gn, up = up, dn = dn }
            priCards[key] = c
        end
        local rk = table.find(AC.priority, it.name)
        c.f.LayoutOrder = i
        c.st.Text = rk and ("#" .. rk .. "  Selected") or "Tap to select"
        c.st.TextColor3 = rk and C.GOLD or C.DIM
        c.gn.Text = it.genText
        c.up.Visible = rk ~= nil
        c.dn.Visible = rk ~= nil
    end
    for key, c in pairs(priCards) do
        if not want[key] then c.f:Destroy() priCards[key] = nil end
    end
end

function F.menuTool()
    local bp = LP:FindFirstChild("Backpack")
    if not bp or bp:FindFirstChild("iCollectPro Menu") or (LP.Character and LP.Character:FindFirstChild("iCollectPro Menu")) then return end
    local t = new("Tool", { Name = "iCollectPro Menu", RequiresHandle = false, CanBeDropped = false })
    t.Equipped:Connect(function()
        MAIN.Visible = not MAIN.Visible
        U.set("mainOpen", MAIN.Visible)
        task.defer(function() local _, hum = F.char() if hum then hum:UnequipTools() end end)
    end)
    t.Parent = bp
    R.cleanup[#R.cleanup + 1] = function() t:Destroy() end
end
if IsMobile then
    F.menuTool()
    U.on(LP.CharacterAdded, function() task.wait(1) F.menuTool() end)
end

local ESPF = new("Folder", { Name = "ESP" }, gui)
local WORLD = new("Folder", { Name = "iCP_Aurora_World" }, Workspace)
R.cleanup[#R.cleanup + 1] = function() WORLD:Destroy() end
local espObjs = {}
function F.espKill(e)
    for _, x in pairs(e) do if typeof(x) == "Instance" then pcall(x.Destroy, x) end end
    for _, d in ipairs({ e.dText, e.dBox }) do if d then pcall(function() d:Remove() end) end end
end
function F.espReset()
    for k, o in pairs(espObjs) do
        F.espKill(o)
        espObjs[k] = nil
    end
end
R.cleanup[#R.cleanup + 1] = function() F.espReset() end
function F.espColor(c) return c end
function F.useDrawing()
    local r = U.get("espRenderer", "Auto")
    return r ~= "GUI" and type(Drawing) == "table" and type(Drawing.new) == "function"
end
function F.forceVisible() return U.get("forceVisible", true) end
function F.espEntry(key, model, adorn, mode, color)
    local e = espObjs[key]
    local drawing = F.useDrawing()
    if e and (e.model ~= model or e.mode ~= mode or e.drawing ~= drawing) then
        F.espKill(e)
        e = nil
    end
    if not e then
        e = { model = model, mode = mode, drawing = drawing, adorn = adorn }
        local fv = F.forceVisible()
        e.hl = new("Highlight", { DepthMode = fv and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded,
            Adornee = model, Enabled = false }, ESPF)
        local th = U.get("espThick", 2)
        if drawing then
            e.dText = Drawing.new("Text")
            e.dText.Center, e.dText.Outline, e.dText.Visible = true, true, false
            e.dBox = Drawing.new("Square")
            e.dBox.Filled, e.dBox.Thickness, e.dBox.Visible = false, th, false
        else
            e.tag = new("BillboardGui", { Size = UDim2.fromOffset(220, 70), StudsOffset = Vector3.new(0, 3.2, 0), AlwaysOnTop = fv,
                LightInfluence = 0, MaxDistance = 100000, Adornee = adorn }, ESPF)
            e.lbl = U.text("TextLabel", e.tag, "", 16, WB, color, Enum.TextXAlignment.Center)
            e.lbl.Size = UDim2.fromScale(1, 1)
            e.lbl.TextYAlignment = Enum.TextYAlignment.Bottom
            e.lbl.TextStrokeTransparency = 0.4
            if mode == "3D" then
                e.box = new("SelectionBox", { Adornee = model, LineThickness = 0.02 * th, SurfaceTransparency = 1 }, ESPF)
            else
                e.box = new("BillboardGui", { AlwaysOnTop = fv, LightInfluence = 0, MaxDistance = 100000, Adornee = adorn, Size = UDim2.fromScale(4, 5) }, ESPF)
                if mode == "2D" or mode == "Square" or mode == "Circle" then
                    local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1 }, e.box)
                    if mode == "Circle" then U.round(f, 0.5, true) end
                    if mode == "Square" then f.SizeConstraint = Enum.SizeConstraint.RelativeYY f.AnchorPoint = Vector2.new(0.5, 0) f.Position = UDim2.fromScale(0.5, 0) end
                    e.boxStroke = new("UIStroke", { Thickness = th, Color = color }, f)
                elseif mode == "Corner" then
                    e.corners = {}
                    for _, s in ipairs({ { 0, 0, 1, 0 }, { 0, 0, 0, 1 }, { 1, 0, -1, 0 }, { 1, 0, 0, 1 }, { 0, 1, 1, 0 }, { 0, 1, 0, -1 }, { 1, 1, -1, 0 }, { 1, 1, 0, -1 } }) do
                        local horiz = s[3] ~= 0
                        local f = new("Frame", { BorderSizePixel = 0, BackgroundColor3 = color,
                            AnchorPoint = Vector2.new(s[1], s[2]), Position = UDim2.fromScale(s[1], s[2]),
                            Size = horiz and UDim2.new(0.28, 0, 0, th) or UDim2.new(0, th, 0.28, 0) }, e.box)
                        e.corners[#e.corners + 1] = f
                    end
                else
                    local g = U.text("TextLabel", e.box, mode == "Star" and "☆" or "△", 12, WB, color, Enum.TextXAlignment.Center)
                    g.Size = UDim2.fromScale(1, 1) g.TextScaled = true
                    e.glyph = g
                end
            end
        end
        espObjs[key] = e
    end
    return e
end
function F.espPaint(e, color, chams, boxOn, text, sizeX, sizeY)
    e.hl.Enabled = chams
    e.hl.FillColor = color
    e.hl.OutlineColor = color
    e.hl.FillTransparency = 0.75
    e.hl.OutlineTransparency = 0
    e.color, e.text, e.boxOn, e.sizeX, e.sizeY = color, text, boxOn, sizeX or 4, sizeY or 5
    if e.drawing then return end
    e.lbl.Text = text
    e.lbl.TextColor3 = color
    e.lbl.TextSize = U.get("espText", 16)
    e.tag.Enabled = text ~= ""
    if e.box then
        if e.box:IsA("SelectionBox") then
            e.box.Visible = boxOn
            e.box.Color3 = color
        else
            e.box.Enabled = boxOn
            if sizeX then e.box.Size = UDim2.fromScale(sizeX, sizeY) end
        end
    end
    if e.boxStroke then e.boxStroke.Color = color end
    if e.corners then for _, f in ipairs(e.corners) do f.BackgroundColor3 = color end end
    if e.glyph then e.glyph.TextColor3 = color end
end
function F.drawTick()
    local cam = Workspace.CurrentCamera
    if not cam then return end
    for _, e in pairs(espObjs) do
        if e.drawing and e.dText then
            local a = e.adorn
            local ok = a and a.Parent
            local top, onTop, bot, onBot
            if ok then
                local up = Vector3.new(0, (e.sizeY or 5) / 2, 0)
                local t3, v1 = cam:WorldToViewportPoint(a.Position + up)
                local b3, v2 = cam:WorldToViewportPoint(a.Position - up)
                top, onTop, bot, onBot = t3, v1, b3, v2
            end
            if ok and onTop and onBot then
                local h = math.abs(bot.Y - top.Y)
                local w = h * math.clamp((e.sizeX or 4) / math.max(e.sizeY or 5, 0.1), 0.3, 2)
                e.dBox.Position = Vector2.new(top.X - w / 2, top.Y)
                e.dBox.Size = Vector2.new(w, h)
                e.dBox.Color = e.color or C.WHITE
                e.dBox.Thickness = U.get("espThick", 2)
                e.dBox.Visible = e.boxOn and true or false
                e.dText.Text = e.text or ""
                e.dText.Size = U.get("espText", 16)
                e.dText.Color = e.color or C.WHITE
                local lines = select(2, (e.text or ""):gsub("\n", "")) + 1
                e.dText.Position = Vector2.new(top.X, top.Y - lines * (U.get("espText", 16) + 1) - 2)
                e.dText.Visible = (e.text or "") ~= ""
            else
                e.dBox.Visible = false
                e.dText.Visible = false
            end
        end
    end
end
U.on(RunService.RenderStepped, function() pcall(F.drawTick) end)
function F.espSweep(alive)
    for k, e in pairs(espObjs) do
        if not alive[k] then
            F.espKill(e)
            espObjs[k] = nil
        end
    end
end

local footNext, lastSteps = 0, {}
function F.espTick()
    local alive = {}
    local _, _, me = F.char()
    local mePos = me and me.Position or Vector3.zero
    local chamBudget = 28
    if U.get("brEsp", false) then
        local rar = U.get("brRarities", { "OG", "Secret" })
        local list = F.brainrots()
        table.sort(list, function(a, b) return (a.model:GetPivot().Position - mePos).Magnitude < (b.model:GetPivot().Position - mePos).Magnitude end)
        for _, b in ipairs(list) do
            if table.find(rar, b.rarity) then
                local key = "br" .. b.model:GetDebugId()
                alive[key] = true
                local adorn = b.model.PrimaryPart or b.model:FindFirstChildWhichIsA("BasePart")
                if adorn then
                    local col = F.espColor(F.rarityColor(b.rarity))
                    local e = F.espEntry(key, b.model, adorn, U.get("brBoxMode", "Corner"), col)
                    local parts = {}
                    if U.get("brName", true) then parts[#parts + 1] = b.name end
                    if U.get("brGen", true) then parts[#parts + 1] = b.genText end
                    if U.get("brDist", true) then parts[#parts + 1] = math.floor((adorn.Position - mePos).Magnitude) .. "m" end
                    local _, size = b.model:GetBoundingBox()
                    local chams = U.get("brChams", true) and chamBudget > 0
                    if chams then chamBudget = chamBudget - 1 end
                    F.espPaint(e, col, chams, U.get("brBoxes", true), table.concat(parts, "\n"), math.max(size.X, size.Z), size.Y)
                end
            end
        end
    end
    if U.get("plEsp", false) then
        for _, p in ipairs(Players:GetPlayers()) do
            local ch = p ~= LP and p.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                local key = "pl" .. p.UserId
                alive[key] = true
                local col = F.espColor(rgb(255, 255, 255))
                if p:GetAttribute("Stealing") then col = F.espColor(C.BAD) end
                local e = F.espEntry(key, ch, hrp, U.get("plBoxMode", "Corner"), col)
                local top = {}
                if U.get("plIcons", true) then
                    if U.get("iconAdmin", true) and (p:GetAttribute("Role") and p:GetAttribute("Role") ~= "Member") then top[#top + 1] = "👑" end
                    if U.get("iconGiant", true) and p:GetAttribute("GiantPotion") ~= nil then top[#top + 1] = "🧪" end
                    if U.get("iconFlash", true) and ch:FindFirstChild("Flash Teleport") then top[#top + 1] = "⚡" end
                end
                local lines = {}
                if #top > 0 then lines[#lines + 1] = table.concat(top, " ") end
                if U.get("plName", true) then lines[#lines + 1] = U.get("plDisplay", true) and p.DisplayName or p.Name end
                if U.get("plDist", true) then lines[#lines + 1] = math.floor((hrp.Position - mePos).Magnitude) .. "m" end
                if U.get("plStealTag", true) and p:GetAttribute("Stealing") then lines[#lines + 1] = "STEALING" end
                if U.get("plInvisTag", true) then
                    local head = ch:FindFirstChild("Head")
                    if head and (head.Transparency >= 0.95 or head.LocalTransparencyModifier >= 0.95) then lines[#lines + 1] = "INVISIBLE" end
                end
                local chams = U.get("plChams", true) and chamBudget > 0
                if chams then chamBudget = chamBudget - 1 end
                F.espPaint(e, col, chams, U.get("plBoxes", true), table.concat(lines, "\n"), 4, 5.5)
            end
        end
        if U.get("plFoot", false) and os.clock() >= footNext then
            footNext = os.clock() + 0.3
            local col = fromT(AC.footColor, rgb(114, 0, 255))
            for _, p in ipairs(Players:GetPlayers()) do
                local ch = p ~= LP and p.Character
                local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
                local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.FloorMaterial ~= Enum.Material.Air then
                    local pos = hrp.Position - Vector3.new(0, hum.HipHeight + hrp.Size.Y / 2 - 0.05, 0)
                    if not lastSteps[p] or (lastSteps[p] - pos).Magnitude > 2 then
                        lastSteps[p] = pos
                        local s = new("Part", { Anchored = true, CanCollide = false, CanQuery = false, CanTouch = false, CastShadow = false,
                            Material = Enum.Material.Neon, Color = col, Size = Vector3.new(0.7, 0.08, 0.7), CFrame = CFrame.new(pos),
                            Shape = Enum.PartType.Cylinder }, WORLD)
                        s.CFrame = CFrame.new(pos) * CFrame.Angles(0, 0, math.rad(90))
                        s.Size = Vector3.new(0.08, 0.8, 0.8)
                        game:GetService("Debris"):AddItem(s, U.get("footLife", 4))
                    end
                end
            end
        end
    end
    if U.get("pubMethod", false) and U.get("slotEsp", false) then
        for _, plot in ipairs(F.enemyPlots()) do
            for _, pod in ipairs(plot.AnimalPodiums:GetChildren()) do
                local sp = pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
                if sp then
                    local key = "slot" .. sp:GetDebugId()
                    alive[key] = true
                    local e = espObjs[key]
                    if not e then
                        e = { tag = new("BillboardGui", { Size = UDim2.fromOffset(34, 22), StudsOffset = Vector3.new(0, 1.5, 0), AlwaysOnTop = true, Adornee = sp, MaxDistance = 260 }, ESPF) }
                        local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.WIN, BorderSizePixel = 0 }, e.tag)
                        U.round(f, 6) U.stroke(f, 1)
                        e.lbl = U.text("TextLabel", f, pod.Name, 12, WB, C.TEXT, Enum.TextXAlignment.Center)
                        e.lbl.Size = UDim2.fromScale(1, 1)
                        espObjs[key] = e
                    end
                end
            end
        end
    end
    if U.get("miscEsp", false) then
        for _, m in ipairs(Workspace:GetChildren()) do
            local isClone = U.get("cloneEsp", false) and m:IsA("Model") and m.Name:match("_Clone$") and not m.Name:find(tostring(LP.UserId), 1, true)
            local isMine = U.get("mineEsp", false) and (m.Name:find("Mine", 1, true) or m.Name:find("Subspace", 1, true))
                and not m.Name:find(tostring(LP.UserId), 1, true) and not m.Name:find(LP.Name, 1, true)
            if isClone or isMine then
                local adorn = m:IsA("BasePart") and m or m:FindFirstChildWhichIsA("BasePart", true)
                if adorn then
                    local key = "misc" .. m:GetDebugId()
                    alive[key] = true
                    local col = isMine and C.BAD or C.GOLD
                    local e = F.espEntry(key, m, adorn, "2D", col)
                    local chams = chamBudget > 0
                    if chams then chamBudget = chamBudget - 1 end
                    F.espPaint(e, col, chams, false, isMine and "MINE" or "CLONE")
                end
            end
        end
    end
    F.espSweep(alive)
end

local xrayed = {}
function F.xrayClear()
    for p in pairs(xrayed) do pcall(function() p.LocalTransparencyModifier = 0 end) end
    table.clear(xrayed)
end
function F.isAnimalPart(p)
    local m = p:FindFirstAncestorOfClass("Model")
    while m do
        if ANIMALS[m.Name] then return true end
        m = m.Parent and m.Parent:FindFirstAncestorOfClass("Model")
    end
    return false
end
function F.lockSecs(plot)
    local best = 0
    local pur = plot and plot:FindFirstChild("Purchases")
    for _, d in ipairs(pur and pur:GetDescendants() or {}) do
        if d:IsA("TextLabel") and d.Name == "RemainingTime" then
            local shown, p = d.Visible, d.Parent
            while shown and p and p ~= pur do
                if (p:IsA("GuiObject") and not p.Visible) or (p:IsA("LayerCollector") and not p.Enabled) then shown = false end
                p = p.Parent
            end
            local s = shown and tonumber(d.Text:match("(%d+)")) or 0
            if s > best then best = s end
        end
    end
    return best
end
local baseTags = {}
function F.baseTick()
    local baseOn = U.get("baseEsp", false)
    local tAlive = {}
    if baseOn and U.get("baseTimer", true) then
        local plots = Workspace:FindFirstChild("Plots")
        for _, plot in ipairs(plots and plots:GetChildren() or {}) do
            local owner = F.ownerName(plot)
            local pur = owner ~= "?" and owner ~= "Empty Base" and plot:FindFirstChild("Purchases")
            local blocks = {}
            for _, b in ipairs(pur and pur:GetChildren() or {}) do
                local main = b.Name == "PlotBlock" and b:FindFirstChild("Main")
                if main and main:IsA("BasePart") then blocks[#blocks + 1] = main end
            end
            table.sort(blocks, function(a, b) return a.Position.Y < b.Position.Y end)
            if not U.get("timerFloors", false) then blocks = { blocks[1] } end
            for _, main in ipairs(blocks) do
                local gui = main:FindFirstChild("BillboardGui")
                local rt = gui and gui:FindFirstChild("RemainingTime")
                local shown, p = rt and rt.Visible, rt and rt.Parent
                while shown and p and p ~= main do
                    if (p:IsA("GuiObject") and not p.Visible) or (p:IsA("LayerCollector") and not p.Enabled) then shown = false end
                    p = p.Parent
                end
                local secs = shown and (tonumber(rt.Text:match("(%d+)")) or 0) or 0
                tAlive[main] = true
                local bb = baseTags[main]
                if not bb then
                    bb = new("BillboardGui", { Size = UDim2.fromOffset(120, 26), StudsOffsetWorldSpace = Vector3.new(0, 3, 0), AlwaysOnTop = true,
                        LightInfluence = 0, MaxDistance = 1e9, Adornee = main }, ESPF)
                    local l = U.text("TextLabel", bb, "", 20, WB, C.OPEN, Enum.TextXAlignment.Center)
                    l.Name = "L"
                    l.Size = UDim2.fromScale(1, 1)
                    l.TextStrokeTransparency = 0.4
                    baseTags[main] = bb
                end
                local l = bb.L
                if secs > 0 then
                    l.Text = string.format("LOCKED  %d:%02d", secs // 60, secs % 60)
                    l.TextColor3 = C.A2
                else
                    l.Text = "UNLOCKED"
                    l.TextColor3 = C.OPEN
                end
            end
        end
    end
    if baseOn and U.get("allowedTag", true) then
        for desc in pairs(iCollectProUI.friendPrompts or {}) do
            local part = desc.Parent and iCollectProUI.promptPart(desc)
            local allowed = part and (tostring(desc.ObjectText):find("Disallow") ~= nil)
            if allowed then
                tAlive[part] = true
                if not baseTags[part] then
                    local bb = new("BillboardGui", { Size = UDim2.fromOffset(16, 16), StudsOffsetWorldSpace = Vector3.new(0, 9, 0), AlwaysOnTop = true,
                        LightInfluence = 0, MaxDistance = 1e9, Adornee = part }, ESPF)
                    local f = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = C.OPEN, BorderSizePixel = 0 }, bb)
                    U.round(f, 0.5, true)
                    local t = U.text("TextLabel", f, "✓", 12, WB, C.WIN, Enum.TextXAlignment.Center)
                    t.Size = UDim2.fromScale(1, 1)
                    baseTags[part] = bb
                end
            end
        end
    end
    for k, bb in pairs(baseTags) do if not tAlive[k] then bb:Destroy() baseTags[k] = nil end end
    if baseOn and U.get("xray", false) then
        local t = U.get("xrayT", 0.7)
        for _, plot in ipairs(F.enemyPlots()) do
            for _, d in ipairs(plot:GetDescendants()) do
                if d:IsA("BasePart") and d.Transparency < 1 and not xrayed[d] and not d:IsDescendantOf(plot.AnimalPodiums)
                    and d.Name ~= "Spawn" and not F.isAnimalPart(d) then
                    xrayed[d] = true
                end
            end
        end
        for p in pairs(xrayed) do
            if p.Parent then p.LocalTransparencyModifier = t else xrayed[p] = nil end
        end
    elseif next(xrayed) then
        F.xrayClear()
    end
    local my = F.myPlot()
    local dh = my and my:FindFirstChild("DeliveryHitbox")
    if baseOn and U.get("delivery", false) and dh then
        if not F.delBox or F.delBox.Adornee ~= dh then
            if F.delBox then F.delBox:Destroy() end
            F.delBox = new("SelectionBox", { Adornee = dh, LineThickness = 0.08, Color3 = C.OPEN, SurfaceTransparency = 0.85, SurfaceColor3 = C.OPEN }, ESPF)
        end
    elseif F.delBox then
        F.delBox:Destroy() F.delBox = nil
    end
    if U.get("pubMethod", false) and U.get("nextBase", false) then
        local best, bt = nil, math.huge
        for _, plot in ipairs(F.enemyPlots()) do
            local secs = F.lockSecs(plot)
            if secs < bt then best, bt = plot, secs end
        end
        if best then
            if not F.nextHl or F.nextHl.Adornee ~= best then
                if F.nextHl then F.nextHl:Destroy() end
                F.nextHl = new("Highlight", { Adornee = best, FillTransparency = 0.9, OutlineColor = C.GOLD, FillColor = C.GOLD,
                    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop }, ESPF)
            end
        end
    elseif F.nextHl then
        F.nextHl:Destroy() F.nextHl = nil
    end
    local ch = LP.Character
    if U.get("miscEsp", false) and U.get("selfChams", false) and ch then
        if not F.selfHl or F.selfHl.Adornee ~= ch then
            if F.selfHl then F.selfHl:Destroy() end
            F.selfHl = new("Highlight", { Adornee = ch, FillColor = C.A2, OutlineColor = C.A1, FillTransparency = 0.6,
                DepthMode = Enum.HighlightDepthMode.Occluded }, ESPF)
        end
    elseif F.selfHl then
        F.selfHl:Destroy() F.selfHl = nil
    end
    F.baseHud()
    if MYBASE.Visible and my then
        local secs = F.lockSecs(my)
        if secs > 0 then
            F.baseLbl.Text = "LOCKED  " .. secs .. "s"
            F.baseLbl.TextColor3 = C.BAD
        else
            F.baseLbl.Text = "UNLOCKED"
            F.baseLbl.TextColor3 = C.OPEN
        end
    end
end

pcall(function()
    darkBlueHighlight.FillTransparency = 1
    darkBlueHighlight.OutlineColor = rgb(255, 45, 45)
    darkBlueHighlight.OutlineTransparency = 0
    darkBlueHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
end)
local petMark = new("Highlight", { FillTransparency = 1, OutlineColor = rgb(255, 205, 45), OutlineTransparency = 0,
    DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Enabled = false }, ESPF)
function F.targetTick()
    local pod = darkBlueHighlight and darkBlueHighlight.Adornee
    local sp = pod and pod:FindFirstChild("Base") and pod.Base:FindFirstChild("Spawn")
    local plot = pod and pod.Parent and pod.Parent.Parent
    local best, bd = nil, 14
    if sp and plot then
        for _, m in ipairs(plot:GetChildren()) do
            if m:IsA("Model") and ANIMALS[m.Name] then
                local d = (m:GetPivot().Position - sp.Position).Magnitude
                if d < bd then best, bd = m, d end
            end
        end
    end
    petMark.Adornee = best
    petMark.Enabled = best ~= nil
end

function F.alignCam()
    local pod = darkBlueHighlight and darkBlueHighlight.Adornee
    local cam, _, _, hrp = Workspace.CurrentCamera, F.char()
    if not (pod and cam and hrp) then return end
    local focus = hrp.Position
    local dir = pod:GetPivot().Position - focus
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then return end
    local back = (cam.CFrame.Position - focus)
    local dist, height = Vector3.new(back.X, 0, back.Z).Magnitude, back.Y
    local pos = focus - dir.Unit * math.max(dist, 4) + Vector3.new(0, height, 0)
    cam.CFrame = CFrame.lookAt(pos, focus + dir.Unit * 8)
end

local STRETCH_BIND = "iCollectProAuroraStretch"
pcall(RunService.UnbindFromRenderStep, RunService, STRETCH_BIND)
RunService:BindToRenderStep(STRETCH_BIND, Enum.RenderPriority.Camera.Value + 1, function()
    local s = U.get("stretch", 1)
    if F.cfg("customFovEnabled") and s < 0.999 then
        local cam = Workspace.CurrentCamera
        if cam then cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, s, 0, 0, 0, 1) end
    end
end)
R.cleanup[#R.cleanup + 1] = function() pcall(RunService.UnbindFromRenderStep, RunService, STRETCH_BIND) end

function F.muteTick()
    local _, _, hrp = F.char()
    local s = hrp and hrp:FindFirstChild("Running")
    if s and s:IsA("Sound") then
        if U.get("muteWalk", false) then
            if s.Volume > 0 then s:SetAttribute("iCPVol", s.Volume) s.Volume = 0 end
        elseif s:GetAttribute("iCPVol") then
            s.Volume = s:GetAttribute("iCPVol")
            s:SetAttribute("iCPVol", nil)
        end
    end
end

pcall(function()
    local cmds = ReplicatedStorage:FindFirstChild("AdminCommands", true)
    for _, name in ipairs(F.CMDS) do
        local mod = cmds and cmds:FindFirstChild(name)
        if mod then
            local m = require(mod)
            if type(m.effects) == "table" and type(m.effects.Victim) == "function" then
                local prev = m.effects.Victim
                m.effects.Victim = function(...)
                    if iCollectPro_ALIVE() and table.find(U.get("autoResetCmds", {}), name) then
                        task.spawn(F.instaReset)
                    end
                    return prev(...)
                end
            end
        end
    end
end)

local lastRagReset = 0
function F.ragdollTick()
    if not U.get("resetRagdoll", false) or os.clock() - lastRagReset < 3 then return end
    local _, hum = F.char()
    local ended = tonumber(LP:GetAttribute("RagdollEndTime")) or 0
    local now = workspace:GetServerTimeNow()
    if (hum and hum:GetState() == Enum.HumanoidStateType.Physics) or ended > now then
        lastRagReset = os.clock()
        F.instaReset()
    end
end

local stealFrom, autoSpeedArmed = nil, false
U.on(LP:GetAttributeChangedSignal("Stealing"), function()
    if not iCollectPro_ALIVE() then return end
    if F.stealing() then
        if U.get("autoSpeed", false) and not U.get("speedMaster", F.speedMasterDef) then
            autoSpeedArmed = true
            U.set("speedMaster", true) F.speedSync()
            for _, f in ipairs(R.rows) do pcall(f) end
        end
    elseif autoSpeedArmed then
        autoSpeedArmed = false
        U.set("speedMaster", false) F.speedSync()
        for _, f in ipairs(R.rows) do pcall(f) end
    end
    if F.stealing() then
        stealFrom = targetPlot
        if U.get("autoActivate", false) then task.defer(function() iCollectPro.activate() end) end
        if U.get("autoRagTech", false) then task.delay(0.2, function() F.selfRagdoll(0.25) end) end
    end
end)
pcall(function()
    local net = ReplicatedStorage:FindFirstChild("Packages") and ReplicatedStorage.Packages:FindFirstChild("Net")
    local ok = net and net:FindFirstChild("RE/StealService/StealingSuccess")
    if ok then
        U.on(ok.OnClientEvent, function()
            if U.get("spamAfter", U.get("adminSpam", false)) then
                local owner = stealFrom and F.ownerName(stealFrom)
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LP and owner and (p.DisplayName == owner or p.Name == owner) then
                        F.spamCmds(U.get("spamCmds", { "rocket", "inverse", "tiny" }), p)
                    end
                end
            end
        end)
    end
end)

function F.goBaseTick()
    if not (U.get("autoGoBase", false) or U.get("autoWalkSteal", false)) or not F.stealing() or _G.iCollectPro_SemiTP_Busy then return end
    local my = F.myPlot()
    local dh = my and my:FindFirstChild("DeliveryHitbox")
    local _, hum = F.char()
    if dh and hum then hum:MoveTo(dh.Position) end
end

local lastAuto = 0
function F.autoStealTick()
    local best, nearest, pri = U.get("autoBest", false), U.get("autoNearest", false), U.get("autoPriority", false)
    if not (best or nearest or pri) then return end
    if F.stealing() or iCollectPro.debounce or _G.iCollectPro_SemiTP_Busy or os.clock() - lastAuto < 4 then return end
    local _, hum, hrp = F.char()
    if not (hum and hrp) or hum.Health <= 0 then return end
    local list, pick = F.brainrots(), nil
    if pri then
        for _, name in ipairs(AC.priority) do
            for _, b in ipairs(list) do if b.name == name and b.slot then pick = b break end end
            if pick then break end
        end
    end
    if not pick and best then
        for _, b in ipairs(list) do if b.slot and (not pick or b.gen > pick.gen) then pick = b end end
    end
    if not pick and nearest then
        local bd = math.huge
        for _, b in ipairs(list) do
            local d = b.spawn and (b.spawn.Position - hrp.Position).Magnitude or math.huge
            if b.slot and d < bd then pick, bd = b, d end
        end
    end
    if not pick then return end
    lastAuto = os.clock()
    targetPlot = pick.plot
    updateSlot(pick.slot)
    task.spawn(iCollectPro.execute)
end

local lastDefense, lastAlarm, lastIntruder, knownPlayers, defBusy = 0, {}, {}, #Players:GetPlayers(), false
local function allOnCooldown(list)
    if type(list) ~= "table" or #list == 0 then return false end
    for _, c in ipairs(list) do if F.cmdCooldown(c) <= 0 then return false end end
    return true
end
local function fireList(list, target)
    local any = false
    for _, c in ipairs(list or {}) do
        if not target.Parent then break end
        if F.adminCmd(c, target) then any = true end
        task.wait(0.35)
    end
    return any
end
local function safety(k) return U.get("safetyKick", true) and U.get(k, false) end
function F.defenseTick()
    local my = F.myPlot()
    if not my then return end
    local centre = my:GetPivot().Position
    local on = U.get("autoDefense", false)
    local thieves, inBase = {}, {}
    for _, p in ipairs(Players:GetPlayers()) do
        local r = p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if r then
            local d = (r.Position - centre).Magnitude
            if d < 70 then
                inBase[#inBase + 1] = p
                if U.get("intruder", false) and (not lastAlarm[p] or os.clock() - lastAlarm[p] > 15) then
                    lastAlarm[p] = os.clock()
                    U.notify("Intruder Alarm", p.DisplayName .. " is in your base")
                end
                if p:GetAttribute("Stealing") then thieves[#thieves + 1] = { p = p, d = d } end
            end
        end
    end
    if on and not defBusy and #thieves > 0 and os.clock() - lastDefense > 2 then
        lastDefense = os.clock()
        table.sort(thieves, function(a, b) return a.d < b.d end)
        defBusy = true
        task.spawn(function()
            local t1, t2 = thieves[1].p, thieves[2] and thieves[2].p
            if not t2 then
                local c1 = U.get("defCmds1", { "balloon" })
                if not allOnCooldown(c1) then
                    if fireList(c1, t1) and table.find(c1, "balloon") and safety("leaveBalloon") then
                        task.delay(0.3, function() LP:Kick("Left because balloon has been used (iCollectPro Safety Kick)") end)
                    end
                else
                    fireList(U.get("defCmds2", { "ragdoll", "rocket", "inverse", "tiny", "jumpscare" }), t1)
                    if safety("kickNoCmds") then
                        task.delay(0.3, function() LP:Kick("No balloon/ragdoll available (iCollectPro Safety Kick)") end)
                    end
                end
            else
                task.spawn(fireList, U.get("defMulti1", { "balloon" }), t1)
                fireList(U.get("defMulti2", { "ragdoll", "rocket", "inverse", "tiny" }), t2)
            end
            defBusy = false
        end)
    end
    if on and U.get("antiIntruder", false) and not defBusy then
        for _, p in ipairs(inBase) do
            if not lastIntruder[p] or os.clock() - lastIntruder[p] > 3 then
                lastIntruder[p] = os.clock()
                task.spawn(fireList, U.get("intruderCmds", { "balloon" }), p)
            end
        end
    end
    local n = #Players:GetPlayers()
    if on and safety("kick3rd") and n >= 3 and knownPlayers < 3 then
        LP:Kick("A 3rd player joined (iCollectPro Safety Kick)")
    end
    knownPlayers = n
end

function F.carpetTick()
    if not (U.get("carpetEquip", false) and F.cfg("carpetSpeedEnabled")) or F.stealing() or _G.iCollectPro_SemiTP_Busy then return end
    local ch, hum = F.char()
    if not (ch and hum) or ch:FindFirstChildOfClass("Tool") then return end
    local ok, t = pcall(findFlyGear)
    if ok and t and t.Parent ~= ch then pcall(function() hum:EquipTool(t) end) end
end

function F.antiLogger(on)
    local env = ENV
    if on and not F.realRequest then
        for _, n in ipairs({ "request", "http_request" }) do
            local orig = env[n]
            if type(orig) == "function" then
                F.realRequest = F.realRequest or {}
                F.realRequest[n] = orig
                env[n] = function(opts)
                    local url = type(opts) == "table" and tostring(opts.Url or opts.url or "") or ""
                    if url:find("discord", 1, true) and url:find("webhook", 1, true) or url:find("ipify", 1, true) or url:find("grabify", 1, true) then
                        return { StatusCode = 403, Success = false, Body = "" }
                    end
                    return orig(opts)
                end
            end
        end
    elseif not on and F.realRequest then
        for n, f in pairs(F.realRequest) do env[n] = f end
        F.realRequest = nil
    end
end
if U.get("antiLogger", false) then F.antiLogger(true) end
R.cleanup[#R.cleanup + 1] = function() F.antiLogger(false) end

local frames, frameTime = 0, 0
U.on(RunService.RenderStepped, function(dt) frames = frames + 1 frameTime = frameTime + dt end)
function F.dataPing()
    local ok, v = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    if ok and tonumber(v) then return v end
    local ok2, p = pcall(function() return LP:GetNetworkPing() * 2000 end)
    return ok2 and p or 0
end
function F.pushSample(col, v, fmt, goodHigh)
    local s = col.samples
    s[#s + 1] = v
    while #s > #col.bars do table.remove(s, 1) end
    local lo, hi, sum = math.huge, 0, 0
    for _, x in ipairs(s) do lo = math.min(lo, x) hi = math.max(hi, x) sum = sum + x end
    col.lo.Text = string.format(fmt, math.floor(lo + 0.5))
    col.hi.Text = string.format(fmt, math.floor(hi + 0.5))
    col.st.Text = string.format("Avg " .. fmt .. "  ·  %d samples", math.floor(sum / #s + 0.5), #s)
    for i, b in ipairs(col.bars) do
        local x = s[#s - #col.bars + i]
        b.Size = UDim2.new(b.Size.X.Scale, -1, x and math.clamp(x / math.max(hi, 1), 0.04, 1) or 0, 0)
    end
end
function F.statColor(v, good, ok, higherIsBetter)
    if higherIsBetter then return v >= good and C.GOOD or (v >= ok and C.WARN or C.BAD) end
    return v <= good and C.GOOD or (v <= ok and C.WARN or C.BAD)
end

local alive = true
local function unload()
    if not alive then return end
    alive = false
    for _, c in ipairs(R.conns) do pcall(function() c:Disconnect() end) end
    for _, f in ipairs(R.cleanup) do pcall(f) end
    F.espReset()
    F.xrayClear()
    pcall(function() gui:Destroy() end)
end
ENV.__iCPAuroraUnload = unload

function F.resetConfig()
    for k in pairs(AC) do if k ~= "pos" and k ~= "keys" and k ~= "keysInit" then AC[k] = nil end end
    AC.keys = { menu = "LeftControl", hide = "RightControl" }
    C.A1, C.A2 = rgb(110, 0, 178), rgb(114, 0, 255)
    U.setFont("Gotham")
    U.applyTransparency()
    F.speedSync() F.miscSync()
    U.repaintAccent()
    U.notify("Reset Config", "Hub settings are back to default")
end
function F.panic()
    for _, key in ipairs({ "moveSpeedEnabled", "carpetSpeedEnabled", "infJumpEnabled", "gravityEnabled", "aimbotEnabled", "autoSpamEnabled",
        "destroySentryEnabled", "destroyDogeEnabled", "customFovEnabled", "baseXrayEnabled", "playerEspEnabled", "tracersEnabled",
        "serverGhostEnabled", "quickGrabEnabled", "publicGrabEnabled", "defenderBypassEnabled" }) do
        pcall(function() if F.cfg(key) then F.setCfg(key, false) end end)
    end
    _G.iCollectPro_SemiTP_SpeedBoost = false
    Workspace.Gravity = 196.2
    if Workspace.CurrentCamera then Workspace.CurrentCamera.FieldOfView = 70 end
    ENV.iCollectPro_SemiTP_Gen = (tonumber(ENV.iCollectPro_SemiTP_Gen) or 0) + 1
    pcall(function() game:GetService("ContextActionService"):UnbindAction("iCollectPro_SemiTP_StealKey") end)
    for _, g in ipairs({ ScreenGui, ProgressGui, SpeedScreenGui, AllowDisallowGui }) do pcall(function() g:Destroy() end) end
    unload()
end

local barDoneAt, lastName = nil, "-"
U.on(RunService.Heartbeat, function()
    if not alive then return end
    local rot = (os.clock() * 45) % 360
    for _, g in ipairs(R.sg) do g.Rotation = rot end
    local fs = progressFill and progressFill.Size.X.Scale or 0
    F.bar.fill.Size = UDim2.fromScale(fs, 1)
    local idx = LP:GetAttribute("StealingIndex")
    if idx and idx ~= "" then lastName = tostring(idx) end
    local status = PBarTitle and PBarTitle.Text or ""
    if fs < 0.01 and not F.stealing() and (status == "" or status == "SEMI TP") then
        barDoneAt = nil
        F.bar.title.Text = "Auto Steal"
        F.bar.title.TextColor3 = C.TEXT
        F.bar.pct.Text = "Waiting for target"
        F.bar.pct.TextSize = 11
        return
    end
    F.bar.pct.TextSize = 13
    if status ~= "" and status ~= "SEMI TP" then
        F.bar.title.Text = status
        F.bar.title.TextColor3 = PBarTitle.TextColor3
    else
        F.bar.title.Text = "Stealing  " .. lastName
        F.bar.title.TextColor3 = C.TEXT
    end
    if fs >= 0.999 then
        barDoneAt = barDoneAt or os.clock()
    elseif fs < 0.01 then
        barDoneAt = nil
    end
    local pt = percentLabel and percentLabel.Text or (math.floor(fs * 100) .. "%")
    F.bar.pct.Text = barDoneAt and string.format("%s  +%.1fs", pt, os.clock() - barDoneAt) or pt
end)

task.spawn(function()
    local tick5, tick1 = 0, 0
    while alive do
        if not iCollectPro_ALIVE() or not gui.Parent then unload() break end
        local now = os.clock()
        if now - tick5 >= 0.2 then
            tick5 = now
            pcall(F.espTick)
            pcall(F.targetTick)
            pcall(F.muteTick)
            pcall(F.ragdollTick)
            pcall(F.carpetTick)
        end
        if now - tick1 >= 0.5 then
            local dt = now - tick1
            tick1 = now
            local fps = frameTime > 0 and frames / frameTime or 0
            frames, frameTime = 0, 0
            local ping = F.dataPing()
            F.statsLabels.fps.Text = math.floor(fps + 0.5) .. " fps"
            F.statsLabels.fps.TextColor3 = F.statColor(fps, 50, 30, true)
            F.statsLabels.ping.Text = math.floor(ping + 0.5) .. " ms"
            F.statsLabels.ping.TextColor3 = F.statColor(ping, 120, 250, false)
            F.pushSample(F.fpsCol, fps, "%d", true)
            F.pushSample(F.pingCol, ping, "%d", false)
            pcall(F.baseTick)
            pcall(F.goBaseTick)
            pcall(F.autoStealTick)
            pcall(F.defenseTick)
            pcall(F.asRefresh)
            pcall(F.renderPriority)
            for _, f in ipairs(R.rows) do pcall(f) end
            if CD.Visible then
                for cmd, l in pairs(F.cdRows) do
                    local s = F.cmdCooldown(cmd)
                    l.Text = s > 0 and (s .. "s") or "ready"
                    l.TextColor3 = s > 0 and C.WARN or C.GOOD
                end
            end
            local _ = dt
        end
        task.wait(0.05)
    end
end)

if not AC.firstRun then
    AC.firstRun = true
    pcall(F.setCfg, "pillBarEnabled", false)
    pcall(F.setCfg, "thiefBarEnabled", false)
end
U.applyTransparency()
F.speedSync()
F.miscSync()
if not U.get("semiInstant", true) then pcall(function() game:GetService("ContextActionService"):UnbindAction("iCollectPro_SemiTP_StealKey") end) end
U.selectTab(U.get("tab", "Stealing"))
for _, f in ipairs(R.rows) do pcall(f) end
if PROF.autoload and PROF.autoload ~= "None" and PROF.list[PROF.autoload] and not ENV.__iCPAuroraAutoloaded then
    ENV.__iCPAuroraAutoloaded = true
    task.defer(function() F.applySnapshot(PROF.list[PROF.autoload]) PROF.active = PROF.autoload end)
end
U.notify("iCollectPro", "Loaded. " .. (AC.keys.menu and (AC.keys.menu .. " toggles the menu.") or ""), 5)
print("[iCollectPro AURORA] loaded")
end)()
