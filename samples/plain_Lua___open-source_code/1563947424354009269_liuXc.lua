--[[
    ════════════════════════════════════════════════════════════════════════
    SYNTH SUITE — Private Gym  (keyless, ofx)
    ════════════════════════════════════════════════════════════════════════
    Green math extracted from the target's decompiled client:

      green threshold = 100 - greenFactor * ShotContestConfig.BaseGreenWindow
      green check     = Timing >= threshold
                                 (Timing = MeterController.Release()/GetValue())

    The shared required-module table is wrapped in place so reads return
    100. Instant greens.
]]

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  1. SERVICES & CLIENT CONTEXT                                     ║
-- ╚══════════════════════════════════════════════════════════════════╝
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  2. TARGET SIGNATURES  (decompiled remote & config bindings)      ║
-- ╚══════════════════════════════════════════════════════════════════╝
local Events = ReplicatedStorage:WaitForChild("Events")
local StealEvent      = Events:WaitForChild("StealEvent")
local BlockEvent      = Events:WaitForChild("BlockEvent")
local BlockAttempt    = Events:WaitForChild("BlockAttemptEvent")
local ReboundAttempt  = Events:WaitForChild("ReboundAttemptEvent")
local ShotContestConfig = require(ReplicatedStorage.Shared.ShotContestConfig)
local Met = require(ReplicatedStorage.Client.Handlers.GamePlay.Player.MeterController)
assert(Met, "MeterController require failed")

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  3. FEATURE STATE TABLE                                           ║
-- ╚══════════════════════════════════════════════════════════════════╝
local S = {
    AutoGreen       = true,
    ShotGlide       = false,
    DribbleGlide    = false,
    DribbleGlidePow = 22, -- glide velocity magnitude while dribbling
    AutoGuard       = false,
    AutoContest     = false,
    AutoBlock       = false,
    AutoSteal       = false,
    AntiSteal       = false,
    AutoRebound     = false,
    BallMag         = false,
    UnlimStam       = false,
    WalkSpeed       = 16,
}
S.WalkSpeedDefault = 16

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  4. GREEN HOOK  (MeterController method wrapping)                 ║
-- ║  Shooting.lua reads MeterController.Release()/GetValue() for the  ║
-- ║  Timing sent to the server. Wrapping the shared module table so   ║
-- ║  those reads come back 100. Server math: Timing >= 100 - gf * w.  ║
-- ╚══════════════════════════════════════════════════════════════════╝
local hooksOn = true
if Met.Release then
    local oldRelease = Met.Release
    Met.Release = function(...)
        if hooksOn and S.AutoGreen then
            if Met.StopMoving then pcall(Met.StopMoving) end
            return 100
        end
        return oldRelease(...)
    end
end
if Met.GetValue then
    local oldGetValue = Met.GetValue
    Met.GetValue = function(...)
        if hooksOn and S.AutoGreen then
            return 100
        end
        return oldGetValue(...)
    end
end
if Met.GetGreenWindowFactor then
    local oldGWF = Met.GetGreenWindowFactor
    Met.GetGreenWindowFactor = function(...)
        if hooksOn and S.AutoGreen then
            return 1
        end
        return oldGWF(...)
    end
end

-- widen the client-side green band visual
if S.AutoGreen then
    ShotContestConfig.BaseGreenWindow = 55 -- stock 15
end

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  5. RENDER LOOP  (stamina / contest / walkspeed / glides / ball)  ║
-- ╚══════════════════════════════════════════════════════════════════╝
RunService.RenderStepped:Connect(function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")

    -- unlimited stamina — game reads GameplayStamina off LocalPlayer attrs
    if S.UnlimStam and LocalPlayer:GetAttribute("GameplayStamina") then
        LocalPlayer:SetAttribute("GameplayStamina", 100)
    end
    -- anti-contest — zero the contest score the meter math reads
    if S.AutoContest and char and char:GetAttribute("ContestScore") then
        char:SetAttribute("ContestScore", 0)
    end

    if hum and S.WalkSpeed ~= hum.WalkSpeed then
        hum.WalkSpeed = S.WalkSpeed
    end

    -- shot / dribble glide
    if root and hum then
        local isShooting  = char and char:GetAttribute("IsShooting")
        local isDribbling = char and char:GetAttribute("IsDribbling")
        if S.DribbleGlide and isDribbling and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * S.DribbleGlidePow,
                root.AssemblyLinearVelocity.Y,
                hum.MoveDirection.Z * S.DribbleGlidePow)
        elseif S.ShotGlide and isShooting and hum.MoveDirection.Magnitude > 0 then
            root.AssemblyLinearVelocity = Vector3.new(
                hum.MoveDirection.X * S.WalkSpeed,
                root.AssemblyLinearVelocity.Y,
                hum.MoveDirection.Z * S.WalkSpeed)
        end
    end

    -- ball mag
    if S.BallMag and root then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower() == "ball"
               and (obj.Position - root.Position).Magnitude < 40 then
                obj.CFrame = root.CFrame * CFrame.new(0, 0, -1.5)
            end
        end
    end
end)

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  6. HEARTBEAT LOOP  (defense cluster — guard/steal/block/rebound) ║
-- ╚══════════════════════════════════════════════════════════════════╝
RunService.Heartbeat:Connect(function(dt)
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    -- nearest ball carrier
    local carrier, cdist = nil, math.huge
    for _, other in ipairs(Players:GetPlayers()) do
        if other ~= LocalPlayer and other.Character and other.Character:FindFirstChild("HumanoidRootPart") then
            local oroot = other.Character.HumanoidRootPart
            local d = (oroot.Position - root.Position).Magnitude
            local has = other.Character:GetAttribute("HasBall")
                or oroot:GetAttribute("HasBall")
                or (other:GetAttribute("HasBall") == true)
            if has and d < cdist then
                carrier, cdist = oroot, d
            end
        end
    end

    if S.AutoGuard and carrier and cdist < 25 then
        local cam = workspace.CurrentCamera
        local lookVec = cam and cam.CFrame.LookVector or root.CFrame.LookVector
        root.CFrame = CFrame.new(carrier.Position + lookVec * 2.5, carrier.Position)
    end

    if S.AutoSteal and carrier and cdist < 4.5 then
        pcall(function() StealEvent:FireServer(carrier.Parent, root.CFrame) end)
    end

    if S.AntiSteal then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower() == "ball" then
                local owner = obj:FindFirstAncestorOfClass("Model")
                if owner and owner ~= char and (obj.Position - root.Position).Magnitude < 6 then
                    pcall(function() StealEvent:FireServer(owner, root.CFrame) end)
                end
            end
        end
    end

    if S.AutoBlock and carrier and cdist < 6 and carrier.Position.Y > root.Position.Y + 0.5 then
        pcall(function() BlockAttempt:FireServer(carrier.Parent) end)
        pcall(function() BlockEvent:FireServer(carrier.Parent, char) end)
    end

    if S.AutoRebound then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (obj.Name:lower():find("rim") or obj.Name:lower():find("ball")) then
                local d = (obj.Position - root.Position).Magnitude
                if d < 55 then
                    root.CFrame = CFrame.new(obj.Position + Vector3.new(0, 2.5, 0))
                    if obj.Name:lower():find("rim") then
                        pcall(function()
                            ReboundAttempt:FireServer({ PredictedPosition = obj.Position })
                        end)
                    end
                    break
                end
            end
        end
    end
end)

-- ╔══════════════════════════════════════════════════════════════════╗
-- ║  7. GUI CONSTRUCTION  (dark theme / left sidebar / pill toggles)  ║
-- ╚══════════════════════════════════════════════════════════════════╝
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SynthSuiteGui"
-- rerun guard — destroy any stale copy so the loadstring keeps working on repeat runs
do
    local core = game:GetService("CoreGui")
    local old = core:FindFirstChild("SynthSuiteGui")
    while old do
        old:Destroy()
        old = core:FindFirstChild("SynthSuiteGui")
    end
end
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = game:GetService("CoreGui")

local master = Instance.new("Frame")
master.Name = "Master"
master.Size = UDim2.new(0, 560, 0, 400)
master.Position = UDim2.new(0, 80, 0, 120)
master.BackgroundColor3 = Color3.fromRGB(17, 18, 27)
master.BorderSizePixel = 0
master.ClipsDescendants = true
master.Parent = screenGui
local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0, 10); corner.Parent = master
local stroke = Instance.new("UIStroke"); stroke.Color = Color3.fromRGB(130, 80, 255); stroke.Thickness = 1.5; stroke.Parent = master
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new(Color3.fromRGB(24, 18, 40), Color3.fromRGB(14, 14, 22))
gradient.Parent = master

local topbar = Instance.new("Frame")
topbar.Size = UDim2.new(1, 0, 0, 42)
topbar.BackgroundColor3 = Color3.fromRGB(30, 22, 54)
topbar.BorderSizePixel = 0
topbar.Parent = master
local topbarCorner = Instance.new("UICorner"); topbarCorner.CornerRadius = UDim.new(0, 10); topbarCorner.Parent = topbar
local topTitle = Instance.new("TextLabel")
topTitle.Size = UDim2.new(0, 300, 1, 0)
topTitle.BackgroundTransparency = 1
topTitle.Position = UDim2.new(0, 14, 0, 0)
topTitle.Font = Enum.Font.GothamBold
topTitle.Text = "synth suite — private gym"
topTitle.TextColor3 = Color3.fromRGB(200, 170, 255)
topTitle.TextSize = 16
topTitle.TextXAlignment = Enum.TextXAlignment.Left
topTitle.Parent = topbar
local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 28, 0, 28)
minimize.Position = UDim2.new(1, -36, 0, 6)
minimize.BackgroundColor3 = Color3.fromRGB(35, 27, 62)
minimize.TextColor3 = Color3.fromRGB(220, 220, 235)
minimize.Font = Enum.Font.GothamBold
minimize.Text = "-"
minimize.TextSize = 18
minimize.Parent = topbar
local minCorner = Instance.new("UICorner"); minCorner.CornerRadius = UDim.new(0, 7); minCorner.Parent = minimize

local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 140, 1, -42)
sidebar.Position = UDim2.new(0, 0, 0, 42)
sidebar.BackgroundColor3 = Color3.fromRGB(15, 13, 24)
sidebar.BorderSizePixel = 0
sidebar.Parent = master
local pageLayout = Instance.new("UIListLayout")
pageLayout.FillDirection = Enum.FillDirection.Vertical
pageLayout.Padding = UDim.new(0, 6)
pageLayout.SortOrder = Enum.SortOrder.LayoutOrder
pageLayout.Parent = sidebar

local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -140, 1, -42)
contentFrame.Position = UDim2.new(0, 140, 0, 42)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = master
local contentLayout = Instance.new("UIListLayout")
contentLayout.FillDirection = Enum.FillDirection.Vertical
contentLayout.Padding = UDim.new(0, 7)
contentLayout.Parent = contentFrame
local contentPad = Instance.new("UIPadding")
contentPad.PaddingLeft = UDim.new(0, 10)
contentPad.PaddingTop = UDim.new(0, 10)
contentPad.Parent = contentFrame

local pages = {}
local function makePageButton(name, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -10, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(23, 20, 36)
    btn.Text = name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.fromRGB(190, 190, 215)
    btn.TextSize = 13
    btn.LayoutOrder = order
    btn.Parent = sidebar
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 7); c.Parent = btn
    local hl = Instance.new("UIStroke"); hl.Thickness = 0; hl.Color = Color3.fromRGB(130, 80, 255); hl.Parent = btn

    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 5
    page.Parent = contentFrame
    page.LayoutOrder = order
    page.Visible = false
    local pl = Instance.new("UIListLayout")
    pl.Padding = UDim.new(0, 7)
    pl.SortOrder = Enum.SortOrder.LayoutOrder
    pl.Parent = page
    local pad = Instance.new("UIPadding")
    pad.PaddingRight = UDim.new(0, 6)
    pad.PaddingTop = UDim.new(0, 4)
    pad.Parent = page
    pages[name] = { page = page, btn = btn, stroke = hl }

    btn.MouseButton1Click:Connect(function()
        for _, d in pairs(pages) do
            d.page.Visible = false
            d.stroke.Thickness = 0
        end
        page.Visible = true
        hl.Thickness = 2
    end)
    return page
end

local function styleCard(item)
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 9); c.Parent = item
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(58, 44, 96); s.Thickness = 1; s.Parent = item
end

local function addToggle(pageObj, name, stateTable, key, callback)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 36)
    card.BackgroundColor3 = Color3.fromRGB(22, 20, 34)
    card.Text = ""
    card.LayoutOrder = #pageObj:GetChildren() + 1
    card.Parent = pageObj
    styleCard(card)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 1, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(205, 205, 225)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 12); pad.Parent = label

    local pill = Instance.new("Frame")
    pill.Size = UDim2.new(0, 40, 0, 20)
    pill.AnchorPoint = Vector2.new(1, 0.5)
    pill.Position = UDim2.new(1, -12, 0.5, 0)
    pill.BackgroundColor3 = stateTable[key] and Color3.fromRGB(130, 80, 255) or Color3.fromRGB(45, 42, 70)
    pill.Parent = card
    local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(1, 0); pc.Parent = pill
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 14, 0, 14)
    knob.AnchorPoint = Vector2.new(0, 0.5)
    knob.Position = UDim2.new(stateTable[key] and 1 or 0, stateTable[key] and -3 or 3, 0.5, 0)
    knob.BackgroundColor3 = Color3.fromRGB(235, 232, 255)
    knob.Parent = pill
    local kc = Instance.new("UICorner"); kc.CornerRadius = UDim.new(1, 0); kc.Parent = knob

    card.MouseButton1Click:Connect(function()
        stateTable[key] = not stateTable[key]
        pill.BackgroundColor3 = stateTable[key] and Color3.fromRGB(130, 80, 255) or Color3.fromRGB(45, 42, 70)
        knob.Position = UDim2.new(stateTable[key] and 1 or 0, stateTable[key] and -3 or 3, 0.5, 0)
        if callback then callback(stateTable[key]) end
    end)
end

local function addSlider(pageObj, name, min, max, stateTable, key, callback)
    local card = Instance.new("Frame")
    card.Size = UDim2.new(1, 0, 0, 44)
    card.BackgroundColor3 = Color3.fromRGB(22, 20, 34)
    card.LayoutOrder = #pageObj:GetChildren() + 1
    card.Parent = pageObj
    styleCard(card)

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -60, 0, 20)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.Text = name
    label.TextColor3 = Color3.fromRGB(205, 205, 225)
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = card
    local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0, 12); pad.Parent = label

    local value = Instance.new("TextLabel")
    value.Size = UDim2.new(0, 48, 0, 18)
    value.AnchorPoint = Vector2.new(1, 0.5)
    value.Position = UDim2.new(1, -12, 0, 11)
    value.BackgroundTransparency = 1
    value.Font = Enum.Font.GothamBold
    value.Text = tostring(stateTable[key])
    value.TextColor3 = Color3.fromRGB(175, 140, 255)
    value.TextSize = 12
    value.Parent = card

    local trackBg = Instance.new("Frame")
    trackBg.Size = UDim2.new(1, -26, 0, 5)
    trackBg.Position = UDim2.new(0, 12, 1, -13)
    trackBg.BackgroundColor3 = Color3.fromRGB(45, 42, 70)
    trackBg.BorderSizePixel = 0
    trackBg.Parent = card
    local trackCorner = Instance.new("UICorner"); trackCorner.CornerRadius = UDim.new(1, 0); trackCorner.Parent = trackBg

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((stateTable[key] - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
    fill.BorderSizePixel = 0
    fill.Parent = trackBg
    local fillCorner = Instance.new("UICorner"); fillCorner.CornerRadius = UDim.new(1, 0); fillCorner.Parent = fill

    local dragging = false
    local function setFromPos(input)
        local rel = (input.Position.X - trackBg.AbsolutePosition.X) / trackBg.AbsoluteSize.X
        rel = math.clamp(rel, 0, 1)
        local v = math.floor(min + (max - min) * rel + 0.5)
        stateTable[key] = v
        fill.Size = UDim2.new(rel, 0, 1, 0)
        value.Text = tostring(v)
        if callback then callback(v) end
    end
    trackBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; setFromPos(input)
        end
    end)
    trackBg.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            setFromPos(input)
        end
    end)
end

local function addButton(pageObj, name, callback)
    local card = Instance.new("TextButton")
    card.Size = UDim2.new(1, 0, 0, 32)
    card.BackgroundColor3 = Color3.fromRGB(28, 24, 46)
    card.Text = name
    card.Font = Enum.Font.Gotham
    card.TextColor3 = Color3.fromRGB(215, 200, 255)
    card.TextSize = 13
    card.Parent = pageObj
    card.LayoutOrder = #pageObj:GetChildren() + 1
    styleCard(card)
    card.MouseButton1Click:Connect(function()
        callback()
    end)
end

-- 7a. page registration
local pageShooting = makePageButton("shooting", 1)
local pageDefense  = makePageButton("defense", 2)
local pageMove     = makePageButton("movement", 3)
local pageMisc     = makePageButton("misc", 4)
pages.shooting.page.Visible = true
pages.shooting.stroke.Thickness = 2

addToggle(pageShooting, "auto green (hooks meter math)", S, "AutoGreen")
addToggle(pageShooting, "shot glide", S, "ShotGlide")
addToggle(pageShooting, "dribble glide", S, "DribbleGlide")

addToggle(pageDefense, "auto guard", S, "AutoGuard")
addToggle(pageDefense, "auto contest", S, "AutoContest")
addToggle(pageDefense, "auto block", S, "AutoBlock")
addToggle(pageDefense, "auto steal", S, "AutoSteal")
addToggle(pageDefense, "anti steal", S, "AntiSteal")
addToggle(pageDefense, "auto rebound", S, "AutoRebound")

-- 7b. window drag (topbar / whole-hub move)
local dragging = false
local dragStart, startPosition = nil, nil
master.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = master.Position
    end
end)
master.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        master.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        screenGui.Enabled = not screenGui.Enabled
    end
end)
minimize.MouseButton1Click:Connect(function()
    screenGui.Enabled = false
end)

-- 7c. page population — movement (walkspeed, glide power, stamina)
addSlider(pageMove, "walk speed", 12, 60, S, "WalkSpeed", function(v)
    S.WalkSpeed = v
end)
addSlider(pageMove, "dribble glide power", 16, 60, S, "DribbleGlidePow", function(v)
    S.DribbleGlidePow = v
end)
addToggle(pageMove, "unlimited stamina", S, "UnlimStam")

-- 7d. page population — misc (ball mag, teleports, panic kill switch)
addToggle(pageMisc, "ball mag", S, "BallMag")
addButton(pageMisc, "teleport to nearest rim", function()
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        local nearest, nd = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("rim") then
                local d = (obj.Position - root.Position).Magnitude
                if d < nd then nearest, nd = obj, d end
            end
        end
        if nearest then
            root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 3, 0))
        end
    end
end)
addButton(pageMisc, "panic kill switch", function()
    S.AutoGreen = false
    hooksOn = false
    for _, k in ipairs({"ShotGlide","DribbleGlide","AutoGuard","AutoContest","AutoBlock","AutoSteal","AntiSteal","AutoRebound","BallMag","UnlimStam"}) do
        S[k] = false
    end
    S.WalkSpeed = S.WalkSpeedDefault
    S.DribbleGlidePow = 22
end)

print("[synth-clone] loaded. RightShift toggles. Dribble glide slider live on movement page. absolute sy.")
