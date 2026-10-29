--[[
    Smart Aim Assist v4.2
    ─────────────────────────────────────────
    • Stronger aim lock — doesn't drift
    • Lock button (mobile) — freeze all buttons
    • Exit confirmation dialog
    • Better loading screen spacing
    • Persistent tracking circles
    ─────────────────────────────────────────
]]

local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local CoreGui          = game:GetService("CoreGui")
local LocalPlayer      = Players.LocalPlayer
local Camera           = workspace.CurrentCamera

-- ══════════════════════════════════════════════
--  EXECUTOR COMPATIBILITY
-- ══════════════════════════════════════════════
local function safeGuiParent()
    if typeof(gethui) == "function" then
        local ok, result = pcall(gethui)
        if ok and result then return result end
    end
    if typeof(syn) == "table" and syn.protect_gui then
        local gui = Instance.new("ScreenGui")
        local ok = pcall(function() syn.protect_gui(gui) end)
        if ok then gui.Parent = CoreGui; return gui end
        gui:Destroy()
    end
    local ok = pcall(function()
        local t = Instance.new("Folder"); t.Parent = CoreGui; t:Destroy()
    end)
    if ok then return CoreGui end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local GUI_PARENT = safeGuiParent()

local function createScreenGui(name, props)
    local gui = Instance.new("ScreenGui")
    gui.Name = name; gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.IgnoreGuiInset = true end)
    pcall(function() if typeof(protect_gui) == "function" then protect_gui(gui) end end)
    if props then for k, v in pairs(props) do pcall(function() gui[k] = v end) end end
    gui.Parent = GUI_PARENT
    return gui
end

for _, v in pairs((GUI_PARENT:IsA("ScreenGui") and GUI_PARENT.Parent or GUI_PARENT):GetChildren()) do
    if v:IsA("ScreenGui") and (v.Name == "AimAssistV4" or v.Name == "LoadingScreen" or v.Name == "ExitDialog") then
        v:Destroy()
    end
end

local IS_MOBILE = UserInputService.TouchEnabled
    and not UserInputService.KeyboardEnabled
    and not UserInputService.GamepadEnabled

-- ══════════════════════════════════════════════
--  LOADING SCREEN (10 SECONDS, SPACED OUT)
-- ══════════════════════════════════════════════
local LoadGui = createScreenGui("LoadingScreen", { DisplayOrder = 999 })

local loadBG = Instance.new("Frame")
loadBG.Size                   = UDim2.new(1, 0, 1, 0)
loadBG.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
loadBG.BackgroundTransparency = 0
loadBG.BorderSizePixel        = 0
loadBG.ZIndex                 = 100
loadBG.Parent                 = LoadGui

local loadTitle = Instance.new("TextLabel")
loadTitle.AnchorPoint            = Vector2.new(0.5, 0)
loadTitle.Position               = UDim2.new(0.5, 0, 0.02, 0)
loadTitle.Size                   = UDim2.fromOffset(500, 36)
loadTitle.BackgroundTransparency = 1
loadTitle.Font                   = Enum.Font.GothamBold
loadTitle.TextSize               = IS_MOBILE and 22 or 26
loadTitle.TextColor3             = Color3.new(1, 1, 1)
loadTitle.Text                   = "aimbot universal (BETA)"
loadTitle.ZIndex                 = 101
loadTitle.Parent                 = loadBG

local loadSub = Instance.new("TextLabel")
loadSub.AnchorPoint            = Vector2.new(0.5, 0)
loadSub.Position               = UDim2.new(0.5, 0, 0.07, 0)
loadSub.Size                   = UDim2.fromOffset(420, 18)
loadSub.BackgroundTransparency = 1
loadSub.Font                   = Enum.Font.GothamMedium
loadSub.TextSize               = IS_MOBILE and 11 or 12
loadSub.TextColor3             = Color3.fromRGB(150, 255, 150)
loadSub.Text                   = "Loading..."
loadSub.ZIndex                 = 101
loadSub.Parent                 = loadBG

-- ── MOBILE INSTRUCTIONS ──
local mobileBox = Instance.new("Frame")
mobileBox.AnchorPoint            = Vector2.new(0.5, 0)
mobileBox.Position               = IS_MOBILE
    and UDim2.new(0.5, 0, 0.12, 0)
    or  UDim2.new(0.26, 0, 0.12, 0)
mobileBox.Size                   = IS_MOBILE
    and UDim2.new(0, 340, 0, 280)
    or  UDim2.new(0, 320, 0, 320)
mobileBox.BackgroundColor3       = Color3.fromRGB(12, 12, 18)
mobileBox.BackgroundTransparency = 0.1
mobileBox.BorderSizePixel        = 0
mobileBox.ZIndex                 = 101
mobileBox.Parent                 = loadBG

Instance.new("UICorner", mobileBox).CornerRadius = UDim.new(0, 12)
local ms = Instance.new("UIStroke"); ms.Color = Color3.fromRGB(60, 60, 70); ms.Thickness = 1; ms.Parent = mobileBox

local mp = Instance.new("UIPadding")
mp.PaddingTop = UDim.new(0, 14); mp.PaddingBottom = UDim.new(0, 14)
mp.PaddingLeft = UDim.new(0, 14); mp.PaddingRight = UDim.new(0, 14)
mp.Parent = mobileBox

local mobileText = Instance.new("TextLabel")
mobileText.Size                   = UDim2.new(1, 0, 1, 0)
mobileText.BackgroundTransparency = 1
mobileText.Font                   = Enum.Font.RobotoMono
mobileText.TextSize               = IS_MOBILE and 10 or 11
mobileText.TextColor3             = Color3.fromRGB(220, 220, 220)
mobileText.TextWrapped            = true
mobileText.TextXAlignment         = Enum.TextXAlignment.Left
mobileText.TextYAlignment         = Enum.TextYAlignment.Top
mobileText.ZIndex                 = 102
mobileText.Text                   = [[📱  MOBILE CONTROLS


•  Tap the AIM button to toggle ON / OFF

•  Hold & drag buttons to move them

•  Tap 🔒 button to LOCK buttons in place

•  Tap ⚙ button to open settings

•  Adjust aim speed with the slider

•  When aim is ON → auto-locks enemy

•  Tap ✕ (top-right) to exit script

•  Green circle = locked target

•  White circles = detected enemies]]
mobileText.Parent = mobileBox

-- ── PC INSTRUCTIONS ──
local pcBox = Instance.new("Frame")
pcBox.AnchorPoint            = Vector2.new(0.5, 0)
pcBox.Position               = IS_MOBILE
    and UDim2.new(0.5, 0, 0.12 + 0, 300)
    or  UDim2.new(0.74, 0, 0.12, 0)
pcBox.Size                   = IS_MOBILE
    and UDim2.new(0, 340, 0, 280)
    or  UDim2.new(0, 320, 0, 320)
pcBox.BackgroundColor3       = Color3.fromRGB(12, 12, 18)
pcBox.BackgroundTransparency = 0.1
pcBox.BorderSizePixel        = 0
pcBox.ZIndex                 = 101
pcBox.Parent                 = loadBG

Instance.new("UICorner", pcBox).CornerRadius = UDim.new(0, 12)
local ps = Instance.new("UIStroke"); ps.Color = Color3.fromRGB(60, 60, 70); ps.Thickness = 1; ps.Parent = pcBox

local pp = Instance.new("UIPadding")
pp.PaddingTop = UDim.new(0, 14); pp.PaddingBottom = UDim.new(0, 14)
pp.PaddingLeft = UDim.new(0, 14); pp.PaddingRight = UDim.new(0, 14)
pp.Parent = pcBox

local pcText = Instance.new("TextLabel")
pcText.Size                   = UDim2.new(1, 0, 1, 0)
pcText.BackgroundTransparency = 1
pcText.Font                   = Enum.Font.RobotoMono
pcText.TextSize               = IS_MOBILE and 10 or 11
pcText.TextColor3             = Color3.fromRGB(220, 220, 220)
pcText.TextWrapped            = true
pcText.TextXAlignment         = Enum.TextXAlignment.Left
pcText.TextYAlignment         = Enum.TextYAlignment.Top
pcText.ZIndex                 = 102
pcText.Text                   = [[🖥️  PC CONTROLS


•  Press F to toggle aim assist ON / OFF

•  Hold Right-Click to engage aim lock

•  Press G to open / close settings

•  Drag buttons & panel to reposition

•  Press Delete to exit script

•  Adjust aim speed in settings panel

•  Green circle = locked target

•  White circles = detected enemies

•  ESP highlights enemies through walls]]
pcText.Parent = pcBox

local platformTag = Instance.new("TextLabel")
platformTag.AnchorPoint            = Vector2.new(0.5, 0)
platformTag.Position               = IS_MOBILE
    and UDim2.new(0.5, 0, 0, 590)
    or  UDim2.new(0.5, 0, 0.12 + 0, 330)
platformTag.Size                   = UDim2.fromOffset(300, 20)
platformTag.BackgroundTransparency = 1
platformTag.Font                   = Enum.Font.GothamBold
platformTag.TextSize               = IS_MOBILE and 13 or 14
platformTag.TextColor3             = Color3.fromRGB(255, 200, 80)
platformTag.Text                   = "▶  You are on: " .. (IS_MOBILE and "MOBILE" or "PC")
platformTag.ZIndex                 = 102
platformTag.Parent                 = loadBG

-- Loading bar (very bottom)
local barBG = Instance.new("Frame")
barBG.AnchorPoint            = Vector2.new(0.5, 0)
barBG.Position               = UDim2.new(0.5, 0, 0.95, 0)
barBG.Size                   = UDim2.fromOffset(280, 5)
barBG.BackgroundColor3       = Color3.fromRGB(40, 40, 40)
barBG.BackgroundTransparency = 0
barBG.BorderSizePixel        = 0
barBG.ZIndex                 = 101
barBG.Parent                 = loadBG
Instance.new("UICorner", barBG).CornerRadius = UDim.new(1, 0)

local barFill = Instance.new("Frame")
barFill.Size                   = UDim2.new(0, 0, 1, 0)
barFill.BackgroundColor3       = Color3.fromRGB(100, 255, 100)
barFill.BackgroundTransparency = 0
barFill.BorderSizePixel        = 0
barFill.ZIndex                 = 102
barFill.Parent                 = barBG
Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)

local barPercent = Instance.new("TextLabel")
barPercent.AnchorPoint            = Vector2.new(0.5, 0)
barPercent.Position               = UDim2.new(0.5, 0, 0.95, 10)
barPercent.Size                   = UDim2.fromOffset(80, 14)
barPercent.BackgroundTransparency = 1
barPercent.Font                   = Enum.Font.GothamMedium
barPercent.TextSize               = 10
barPercent.TextColor3             = Color3.fromRGB(140, 140, 140)
barPercent.Text                   = "0%"
barPercent.ZIndex                 = 102
barPercent.Parent                 = loadBG

TweenService:Create(barFill,
    TweenInfo.new(9.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    { Size = UDim2.new(1, 0, 1, 0) }
):Play()

task.spawn(function()
    local steps = {
        { 0.8, "Checking executor...", "8%" },
        { 2.0, "Building UI...", "20%" },
        { 3.5, "Initializing ESP...", "35%" },
        { 5.0, "Setting up aim engine...", "50%" },
        { 6.5, "Configuring panel...", "65%" },
        { 8.0, "Final checks...", "80%" },
        { 9.0, "Almost ready...", "92%" },
        { 9.8, "Done!", "100%" },
    }
    local last = 0
    for _, s in ipairs(steps) do
        task.wait(s[1] - last); last = s[1]
        loadSub.Text = s[2]; barPercent.Text = s[3]
    end
end)

task.wait(10)

local fadeTI = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
TweenService:Create(loadBG, fadeTI, { BackgroundTransparency = 1 }):Play()
for _, child in loadBG:GetDescendants() do
    if child:IsA("TextLabel") then
        TweenService:Create(child, fadeTI, {
            TextTransparency = 1, TextStrokeTransparency = 1, BackgroundTransparency = 1
        }):Play()
    elseif child:IsA("Frame") then
        TweenService:Create(child, fadeTI, { BackgroundTransparency = 1 }):Play()
        local st = child:FindFirstChildOfClass("UIStroke")
        if st then TweenService:Create(st, fadeTI, { Transparency = 1 }):Play() end
    end
end
task.wait(1)
LoadGui:Destroy()

-- ══════════════════════════════════════════════
--  MAIN GUI
-- ══════════════════════════════════════════════
local MainGui = createScreenGui("AimAssistV4", { DisplayOrder = 10 })

-- ══════════════════════════════════════════════
--  SETTINGS
-- ══════════════════════════════════════════════
local CFG = {
    Enabled          = false,
    FOVRadius        = IS_MOBILE and 220 or 180,
    MaxDistance       = 500,
    TargetBone       = "Head",
    PriorityMode     = "Hybrid",
    TeamCheck        = true,
    WallCheck        = true,

    -- STRONGER DEFAULTS
    Smoothing        = IS_MOBILE and 0.4 or 0.45,
    SmartSmoothing   = true,
    MobileAutoAim    = true,
    StickyMultiplier = 2.5,   -- how far outside FOV the lock stays (multiplier)
    MinSmoothing     = 0.08,  -- minimum lerp so it never feels sluggish
    MaxSmoothing     = 0.95,  -- cap

    PredictMovement  = true,
    PredictionScale  = 0.06,

    ESPEnabled       = true,
    ESPTeamCheck     = true,

    ShowFOVCircle       = true,
    ShowNearbyCircles   = true,
    ShowLockedCircle    = true,
    FOVThickness        = 1.4,
    FOVTransparency     = 0.6,
    NearbyCircleSize    = IS_MOBILE and 34 or 28,
    LockedCircleSize    = IS_MOBILE and 38 or 32,
}

-- ══════════════════════════════════════════════
--  GLOBAL STATE
-- ══════════════════════════════════════════════
local scriptDestroyed  = false
local buttonsLocked    = false  -- lock button state
local holdingAim       = false
local lockedPlayer     = nil
local lastAimPos       = nil   -- for persistent tracking circle
local panelOpen        = false

-- ══════════════════════════════════════════════
--  EXIT CONFIRMATION DIALOG
-- ══════════════════════════════════════════════
local function showExitDialog()
    -- Don't show if already showing
    if MainGui:FindFirstChild("ExitDialog") then return end

    local overlay = Instance.new("Frame")
    overlay.Name                   = "ExitDialog"
    overlay.Size                   = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel        = 0
    overlay.ZIndex                 = 200
    overlay.Parent                 = MainGui

    local dialog = Instance.new("Frame")
    dialog.AnchorPoint            = Vector2.new(0.5, 0.5)
    dialog.Position               = UDim2.new(0.5, 0, 0.5, 0)
    dialog.Size                   = UDim2.fromOffset(IS_MOBILE and 300 or 340, IS_MOBILE and 180 or 170)
    dialog.BackgroundColor3       = Color3.fromRGB(22, 22, 28)
    dialog.BackgroundTransparency = 0.02
    dialog.BorderSizePixel        = 0
    dialog.ZIndex                 = 201
    dialog.Parent                 = overlay

    Instance.new("UICorner", dialog).CornerRadius = UDim.new(0, 16)

    local ds = Instance.new("UIStroke")
    ds.Color = Color3.fromRGB(80, 80, 90); ds.Thickness = 2; ds.Parent = dialog

    -- Warning icon
    local warn = Instance.new("TextLabel")
    warn.AnchorPoint            = Vector2.new(0.5, 0)
    warn.Position               = UDim2.new(0.5, 0, 0, 16)
    warn.Size                   = UDim2.fromOffset(40, 36)
    warn.BackgroundTransparency = 1
    warn.Font                   = Enum.Font.GothamBold
    warn.TextSize               = 32
    warn.TextColor3             = Color3.fromRGB(255, 200, 60)
    warn.Text                   = "⚠"
    warn.ZIndex                 = 202
    warn.Parent                 = dialog

    -- Question text
    local question = Instance.new("TextLabel")
    question.AnchorPoint            = Vector2.new(0.5, 0)
    question.Position               = UDim2.new(0.5, 0, 0, 56)
    question.Size                   = UDim2.fromOffset(260, 44)
    question.BackgroundTransparency = 1
    question.Font                   = Enum.Font.GothamMedium
    question.TextSize               = IS_MOBILE and 15 or 16
    question.TextColor3             = Color3.new(1, 1, 1)
    question.TextWrapped            = true
    question.Text                   = "Are you sure you want\nto exit the script?"
    question.ZIndex                 = 202
    question.Parent                 = dialog

    -- YES button (green)
    local yesBtn = Instance.new("TextButton")
    yesBtn.AnchorPoint            = Vector2.new(0, 1)
    yesBtn.Position               = UDim2.new(0, 20, 1, -18)
    yesBtn.Size                   = UDim2.fromOffset(IS_MOBILE and 120 or 135, IS_MOBILE and 42 or 38)
    yesBtn.BackgroundColor3       = Color3.fromRGB(40, 160, 40)
    yesBtn.BackgroundTransparency = 0.1
    yesBtn.BorderSizePixel        = 0
    yesBtn.Font                   = Enum.Font.GothamBold
    yesBtn.TextSize               = IS_MOBILE and 16 or 15
    yesBtn.TextColor3             = Color3.new(1, 1, 1)
    yesBtn.Text                   = "Yes, Exit"
    yesBtn.AutoButtonColor        = true
    yesBtn.ZIndex                 = 202
    yesBtn.Parent                 = dialog
    Instance.new("UICorner", yesBtn).CornerRadius = UDim.new(0, 10)

    -- NO button (red)
    local noBtn = Instance.new("TextButton")
    noBtn.AnchorPoint            = Vector2.new(1, 1)
    noBtn.Position               = UDim2.new(1, -20, 1, -18)
    noBtn.Size                   = UDim2.fromOffset(IS_MOBILE and 120 or 135, IS_MOBILE and 42 or 38)
    noBtn.BackgroundColor3       = Color3.fromRGB(200, 50, 50)
    noBtn.BackgroundTransparency = 0.1
    noBtn.BorderSizePixel        = 0
    noBtn.Font                   = Enum.Font.GothamBold
    noBtn.TextSize               = IS_MOBILE and 16 or 15
    noBtn.TextColor3             = Color3.new(1, 1, 1)
    noBtn.Text                   = "No, Stay"
    noBtn.AutoButtonColor        = true
    noBtn.ZIndex                 = 202
    noBtn.Parent                 = dialog
    Instance.new("UICorner", noBtn).CornerRadius = UDim.new(0, 10)

    -- Animate in
    dialog.Size = UDim2.fromOffset(0, 0)
    TweenService:Create(dialog, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(IS_MOBILE and 300 or 340, IS_MOBILE and 180 or 170)
    }):Play()

    noBtn.MouseButton1Click:Connect(function()
        TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(dialog, TweenInfo.new(0.2), {
            Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1
        }):Play()
        task.wait(0.25)
        overlay:Destroy()
    end)

    yesBtn.MouseButton1Click:Connect(function()
        overlay:Destroy()
        destroyScript()
    end)

    -- Tap outside = cancel
    overlay.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            -- Check if tap is outside dialog
            local pos = Vector2.new(input.Position.X, input.Position.Y)
            local dPos = dialog.AbsolutePosition
            local dSize = dialog.AbsoluteSize
            if pos.X < dPos.X or pos.X > dPos.X + dSize.X
                or pos.Y < dPos.Y or pos.Y > dPos.Y + dSize.Y then
                TweenService:Create(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
                TweenService:Create(dialog, TweenInfo.new(0.2), {
                    Size = UDim2.fromOffset(0, 0), BackgroundTransparency = 1
                }):Play()
                task.wait(0.25)
                overlay:Destroy()
            end
        end
    end)
end

-- ══════════════════════════════════════════════
--  DESTROY FUNCTION
-- ══════════════════════════════════════════════
function destroyScript()
    if scriptDestroyed then return end
    scriptDestroyed = true
    for _, plr in Players:GetPlayers() do
        if plr.Character then
            local h = plr.Character:FindFirstChild("AimAssistESP"); if h then h:Destroy() end
            local bb = plr.Character:FindFirstChild("AimAssistTag"); if bb then bb:Destroy() end
        end
    end
    pcall(function() RunService:UnbindFromRenderStep("SmartAimV4") end)
    MainGui:Destroy()
    print("[AimAssist] Script destroyed.")
end

-- ══════════════════════════════════════════════
--  DRAG SYSTEM (RESPECTS LOCK)
-- ══════════════════════════════════════════════
local function makeDraggable(frame, handle, onTap)
    handle = handle or frame
    local THRESHOLD = 10
    local dragging  = false
    local hasMoved  = false
    local dragStart = Vector2.zero
    local frameStart = UDim2.new()

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging   = true
            hasMoved   = false
            dragStart  = Vector2.new(input.Position.X, input.Position.Y)
            frameStart = frame.Position
        end
    end)

    local function onMove(input)
        if not dragging then return end
        if buttonsLocked then return end  -- LOCKED: don't move
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end

        local current = Vector2.new(input.Position.X, input.Position.Y)
        local delta   = current - dragStart
        if delta.Magnitude > THRESHOLD then
            hasMoved = true
            frame.Position = UDim2.new(
                frameStart.X.Scale, frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
            )
        end
    end

    handle.InputChanged:Connect(onMove)
    UserInputService.InputChanged:Connect(onMove)

    local function onEnd(input)
        if not dragging then return end
        if input.UserInputType ~= Enum.UserInputType.Touch
            and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        dragging = false
        if not hasMoved and onTap then onTap() end
        hasMoved = false
    end

    handle.InputEnded:Connect(onEnd)
    UserInputService.InputEnded:Connect(onEnd)
end

-- ══════════════════════════════════════════════
--  CIRCLE FACTORY
-- ══════════════════════════════════════════════
local function makeCircle(name, diameter, color, thickness, transp)
    local f = Instance.new("Frame")
    f.Name = name; f.AnchorPoint = Vector2.new(0.5, 0.5)
    f.Size = UDim2.fromOffset(diameter, diameter)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0
    f.Parent = MainGui
    Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    local s = Instance.new("UIStroke")
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Color = color; s.Thickness = thickness; s.Transparency = transp
    s.Parent = f
    return f, s
end

local fovCircle, fovStroke = makeCircle("FOVRing", CFG.FOVRadius * 2, Color3.new(1, 1, 1), CFG.FOVThickness, CFG.FOVTransparency)

local POOL_SIZE  = 20
local nearbyPool = {}
for i = 1, POOL_SIZE do
    local f, s = makeCircle("Near_" .. i, CFG.NearbyCircleSize, Color3.new(1, 1, 1), 1.8, 0)
    f.Visible = false
    local d = Instance.new("Frame")
    d.AnchorPoint = Vector2.new(0.5, 0.5); d.Position = UDim2.fromScale(0.5, 0.5)
    d.Size = UDim2.fromOffset(4, 4); d.BackgroundColor3 = Color3.new(1, 1, 1)
    d.BackgroundTransparency = 0.2; d.BorderSizePixel = 0; d.Parent = f
    Instance.new("UICorner", d).CornerRadius = UDim.new(1, 0)
    local n = Instance.new("TextLabel")
    n.AnchorPoint = Vector2.new(0.5, 1); n.Position = UDim2.new(0.5, 0, 0, -4)
    n.Size = UDim2.fromOffset(140, 14); n.BackgroundTransparency = 1
    n.Font = Enum.Font.GothamBold; n.TextSize = IS_MOBILE and 12 or 11
    n.TextColor3 = Color3.new(1, 1, 1); n.TextStrokeTransparency = 0.5; n.Text = ""
    n.Parent = f
    nearbyPool[i] = { Frame = f, Stroke = s, Dot = d, Tag = n }
end

local lockCircle, lockStroke = makeCircle("LockRing", CFG.LockedCircleSize, Color3.fromRGB(130, 255, 130), 2.8, 0)
lockCircle.Visible = false
local lockDot = Instance.new("Frame")
lockDot.AnchorPoint = Vector2.new(0.5, 0.5); lockDot.Position = UDim2.fromScale(0.5, 0.5)
lockDot.Size = UDim2.fromOffset(6, 6); lockDot.BackgroundColor3 = Color3.fromRGB(130, 255, 130)
lockDot.BackgroundTransparency = 0; lockDot.BorderSizePixel = 0; lockDot.Parent = lockCircle
Instance.new("UICorner", lockDot).CornerRadius = UDim.new(1, 0)

-- Crosshair lines inside lock circle for stronger visual
local function makeCrossLine(rot)
    local l = Instance.new("Frame")
    l.AnchorPoint = Vector2.new(0.5, 0.5)
    l.Position = UDim2.fromScale(0.5, 0.5)
    l.Size = UDim2.new(0.6, 0, 0, 2)
    l.BackgroundColor3 = Color3.fromRGB(130, 255, 130)
    l.BackgroundTransparency = 0.3
    l.BorderSizePixel = 0
    l.Rotation = rot
    l.ZIndex = 2
    l.Parent = lockCircle
    return l
end
local crossH = makeCrossLine(0)
local crossV = makeCrossLine(90)

local info = Instance.new("TextLabel")
info.AnchorPoint = Vector2.new(0, 0)
info.Position = UDim2.fromOffset(12, IS_MOBILE and 54 or 12)
info.Size = UDim2.fromOffset(320, 22)
info.BackgroundTransparency = 1; info.Font = Enum.Font.RobotoMono
info.TextSize = IS_MOBILE and 14 or 13; info.TextColor3 = Color3.new(1, 1, 1)
info.TextStrokeTransparency = 0.55; info.TextXAlignment = Enum.TextXAlignment.Left
info.Text = ""; info.Parent = MainGui

-- ══════════════════════════════════════════════
--  BUTTONS
-- ══════════════════════════════════════════════
local BTN_SIZE = IS_MOBILE and 70 or 56
local BTN_X    = -60
local BTN_BASE_Y = 0.35

-- Toggle button
local toggleBtn = Instance.new("TextButton")
toggleBtn.Name = "ToggleBtn"; toggleBtn.AnchorPoint = Vector2.new(0.5, 0.5)
toggleBtn.Position = UDim2.new(1, BTN_X, BTN_BASE_Y, 0)
toggleBtn.Size = UDim2.fromOffset(BTN_SIZE, BTN_SIZE)
toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
toggleBtn.BackgroundTransparency = 0.3; toggleBtn.BorderSizePixel = 0
toggleBtn.Font = Enum.Font.GothamBold; toggleBtn.TextSize = IS_MOBILE and 13 or 11
toggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200); toggleBtn.Text = "AIM\nOFF"
toggleBtn.TextWrapped = true; toggleBtn.AutoButtonColor = false; toggleBtn.Active = false
toggleBtn.Parent = MainGui
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, IS_MOBILE and 18 or 14)

local btnStroke = Instance.new("UIStroke")
btnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
btnStroke.Color = Color3.fromRGB(100, 100, 100); btnStroke.Thickness = 2
btnStroke.Parent = toggleBtn

local statusDot = Instance.new("Frame")
statusDot.AnchorPoint = Vector2.new(0.5, 0); statusDot.Position = UDim2.new(0.5, 0, 0, 6)
statusDot.Size = UDim2.fromOffset(IS_MOBILE and 10 or 8, IS_MOBILE and 10 or 8)
statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
statusDot.BackgroundTransparency = 0; statusDot.BorderSizePixel = 0; statusDot.Parent = toggleBtn
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

-- Settings button
local settingsBtn = Instance.new("TextButton")
settingsBtn.Name = "SettingsBtn"; settingsBtn.AnchorPoint = Vector2.new(0.5, 0.5)
settingsBtn.Position = UDim2.new(1, BTN_X, BTN_BASE_Y, BTN_SIZE + 14)
settingsBtn.Size = UDim2.fromOffset(BTN_SIZE, BTN_SIZE)
settingsBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
settingsBtn.BackgroundTransparency = 0.3; settingsBtn.BorderSizePixel = 0
settingsBtn.Font = Enum.Font.GothamBold; settingsBtn.TextSize = IS_MOBILE and 22 or 18
settingsBtn.TextColor3 = Color3.fromRGB(200, 200, 200); settingsBtn.Text = "⚙"
settingsBtn.AutoButtonColor = false; settingsBtn.Active = false; settingsBtn.Parent = MainGui
Instance.new("UICorner", settingsBtn).CornerRadius = UDim.new(0, IS_MOBILE and 18 or 14)
local sBtnStroke = Instance.new("UIStroke")
sBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sBtnStroke.Color = Color3.fromRGB(100, 100, 100); sBtnStroke.Thickness = 2; sBtnStroke.Parent = settingsBtn

-- Lock button (freeze buttons in place)
local LOCK_SIZE = IS_MOBILE and 46 or 38

local lockBtn = Instance.new("TextButton")
lockBtn.Name = "LockBtn"; lockBtn.AnchorPoint = Vector2.new(0.5, 0.5)
lockBtn.Position = UDim2.new(1, BTN_X, BTN_BASE_Y, (BTN_SIZE + 14) * 2)
lockBtn.Size = UDim2.fromOffset(LOCK_SIZE, LOCK_SIZE)
lockBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
lockBtn.BackgroundTransparency = 0.3; lockBtn.BorderSizePixel = 0
lockBtn.Font = Enum.Font.GothamBold; lockBtn.TextSize = IS_MOBILE and 18 or 15
lockBtn.TextColor3 = Color3.fromRGB(180, 180, 180); lockBtn.Text = "🔓"
lockBtn.AutoButtonColor = false; lockBtn.Active = false; lockBtn.Parent = MainGui
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, IS_MOBILE and 14 or 10)

local lockBtnStroke = Instance.new("UIStroke")
lockBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
lockBtnStroke.Color = Color3.fromRGB(80, 80, 80); lockBtnStroke.Thickness = 1.5
lockBtnStroke.Parent = lockBtn

local lockLabel = Instance.new("TextLabel")
lockLabel.AnchorPoint = Vector2.new(0.5, 0)
lockLabel.Position = UDim2.new(0.5, 0, 1, 3)
lockLabel.Size = UDim2.fromOffset(60, 12)
lockLabel.BackgroundTransparency = 1; lockLabel.Font = Enum.Font.GothamMedium
lockLabel.TextSize = 9; lockLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
lockLabel.Text = "UNLOCK"; lockLabel.Parent = lockBtn

local function toggleLockButtons()
    buttonsLocked = not buttonsLocked
    if buttonsLocked then
        lockBtn.Text = "🔒"
        lockBtn.BackgroundColor3 = Color3.fromRGB(20, 45, 20)
        lockBtnStroke.Color = Color3.fromRGB(80, 200, 80)
        lockLabel.Text = "LOCKED"
        lockLabel.TextColor3 = Color3.fromRGB(80, 200, 80)
    else
        lockBtn.Text = "🔓"
        lockBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        lockBtnStroke.Color = Color3.fromRGB(80, 80, 80)
        lockLabel.Text = "UNLOCK"
        lockLabel.TextColor3 = Color3.fromRGB(140, 140, 140)
    end
end

-- Lock button is always tappable but never draggable itself
-- (uses its own simple tap handler)
lockBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Wait for release to confirm tap
    end
end)

lockBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleLockButtons()
    end
end)

-- Exit button (top right, small)
local exitBtn = Instance.new("TextButton")
exitBtn.Name = "ExitBtn"; exitBtn.AnchorPoint = Vector2.new(1, 0)
exitBtn.Position = UDim2.new(1, -10, 0, 10)
exitBtn.Size = UDim2.fromOffset(IS_MOBILE and 34 or 26, IS_MOBILE and 34 or 26)
exitBtn.BackgroundColor3 = Color3.fromRGB(160, 40, 40)
exitBtn.BackgroundTransparency = 0.3; exitBtn.BorderSizePixel = 0
exitBtn.Font = Enum.Font.GothamBold; exitBtn.TextSize = IS_MOBILE and 15 or 12
exitBtn.TextColor3 = Color3.new(1, 1, 1); exitBtn.Text = "✕"
exitBtn.AutoButtonColor = true; exitBtn.ZIndex = 90; exitBtn.Parent = MainGui
Instance.new("UICorner", exitBtn).CornerRadius = UDim.new(1, 0)

exitBtn.MouseButton1Click:Connect(function()
    showExitDialog()
end)

-- PC: Delete key → exit dialog
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe or scriptDestroyed then return end
    if inp.KeyCode == Enum.KeyCode.Delete then
        showExitDialog()
    end
end)

-- ══════════════════════════════════════════════
--  SETTINGS PANEL
-- ══════════════════════════════════════════════
local PANEL_W = IS_MOBILE and 300 or 290
local PANEL_H = IS_MOBILE and 480 or 440

local panel = Instance.new("ScrollingFrame")
panel.Name = "SettingsPanel"; panel.AnchorPoint = Vector2.new(0.5, 0.5)
panel.Position = UDim2.new(0.5, 0, 0.5, 0)
panel.Size = UDim2.fromOffset(PANEL_W, PANEL_H)
panel.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
panel.BackgroundTransparency = 0.05; panel.BorderSizePixel = 0
panel.Visible = false; panel.ZIndex = 50
panel.ScrollBarThickness = 4; panel.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
panel.CanvasSize = UDim2.new(0, 0, 0, 0)
panel.AutomaticCanvasSize = Enum.AutomaticSize.Y
panel.Parent = MainGui

Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 14)
local pStroke = Instance.new("UIStroke")
pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
pStroke.Color = Color3.fromRGB(60, 60, 60); pStroke.Thickness = 1.5; pStroke.Parent = panel

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 44)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
titleBar.BackgroundTransparency = 0; titleBar.BorderSizePixel = 0
titleBar.ZIndex = 51; titleBar.LayoutOrder = 0; titleBar.Parent = panel
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 14)

local titleText = Instance.new("TextLabel")
titleText.AnchorPoint = Vector2.new(0, 0.5)
titleText.Position = UDim2.new(0, 16, 0.5, 0)
titleText.Size = UDim2.new(0.6, 0, 1, 0)
titleText.BackgroundTransparency = 1; titleText.Font = Enum.Font.GothamBold
titleText.TextSize = IS_MOBILE and 16 or 15; titleText.TextColor3 = Color3.new(1, 1, 1)
titleText.TextXAlignment = Enum.TextXAlignment.Left; titleText.Text = "⚙  Settings"
titleText.ZIndex = 52; titleText.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.AnchorPoint = Vector2.new(1, 0.5)
closeBtn.Position = UDim2.new(1, -10, 0.5, 0)
closeBtn.Size = UDim2.fromOffset(30, 30)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.BackgroundTransparency = 0.4; closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.new(1, 1, 1); closeBtn.Text = "✕"
closeBtn.AutoButtonColor = true; closeBtn.ZIndex = 52; closeBtn.Parent = titleBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 0)
content.AutomaticSize = Enum.AutomaticSize.Y
content.BackgroundTransparency = 1; content.BorderSizePixel = 0
content.ZIndex = 51; content.LayoutOrder = 1; content.Parent = panel

local cPad = Instance.new("UIPadding")
cPad.PaddingLeft = UDim.new(0, 18); cPad.PaddingRight = UDim.new(0, 18)
cPad.PaddingTop = UDim.new(0, 10); cPad.PaddingBottom = UDim.new(0, 16)
cPad.Parent = content

Instance.new("UIListLayout", content).SortOrder = Enum.SortOrder.LayoutOrder
content:FindFirstChildOfClass("UIListLayout").Padding = UDim.new(0, 10)

Instance.new("UIListLayout", panel).SortOrder = Enum.SortOrder.LayoutOrder

-- ── Panel builders ──

local function makeLabel(text, size, color, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, size + 4); l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamMedium; l.TextSize = size
    l.TextColor3 = color or Color3.new(1, 1, 1); l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true; l.Text = text; l.LayoutOrder = order or 0
    l.ZIndex = 52; l.Parent = content
    return l
end

local function makeSlider(label, min, max, default, recMob, recPC, order, onChange)
    local SH = IS_MOBILE and 60 or 50
    local c = Instance.new("Frame")
    c.Size = UDim2.new(1, 0, 0, SH + 52); c.BackgroundTransparency = 1
    c.LayoutOrder = order; c.ZIndex = 52; c.Parent = content

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 0, 18); lbl.BackgroundTransparency = 1
    lbl.Font = Enum.Font.GothamMedium; lbl.TextSize = IS_MOBILE and 14 or 13
    lbl.TextColor3 = Color3.new(1, 1, 1); lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Text = label; lbl.ZIndex = 52; lbl.Parent = c

    local val = Instance.new("TextLabel")
    val.Size = UDim2.new(1, 0, 0, 18); val.BackgroundTransparency = 1
    val.Font = Enum.Font.GothamBold; val.TextSize = IS_MOBILE and 14 or 13
    val.TextColor3 = Color3.fromRGB(100, 255, 100); val.TextXAlignment = Enum.TextXAlignment.Right
    val.Text = tostring(default); val.ZIndex = 52; val.Parent = c

    local track = Instance.new("Frame")
    track.Position = UDim2.new(0, 0, 0, 24)
    track.Size = UDim2.new(1, 0, 0, IS_MOBILE and 18 or 12)
    track.BackgroundColor3 = Color3.fromRGB(40, 40, 48); track.BackgroundTransparency = 0
    track.BorderSizePixel = 0; track.ZIndex = 52; track.Parent = c
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(80, 200, 80); fill.BackgroundTransparency = 0
    fill.BorderSizePixel = 0; fill.ZIndex = 53; fill.Parent = track
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

    local HS = IS_MOBILE and 28 or 22
    local handle = Instance.new("Frame")
    handle.AnchorPoint = Vector2.new(0.5, 0.5)
    handle.Position = UDim2.new((default - min) / (max - min), 0, 0.5, 0)
    handle.Size = UDim2.fromOffset(HS, HS)
    handle.BackgroundColor3 = Color3.new(1, 1, 1); handle.BackgroundTransparency = 0
    handle.BorderSizePixel = 0; handle.ZIndex = 54; handle.Parent = track
    Instance.new("UICorner", handle).CornerRadius = UDim.new(1, 0)

    -- Recommended mobile
    local rm = Instance.new("TextLabel")
    rm.Size = UDim2.new(1, 0, 0, 14); rm.Position = UDim2.new(0, 0, 0, IS_MOBILE and 46 or 40)
    rm.BackgroundTransparency = 1; rm.Font = Enum.Font.GothamMedium
    rm.TextSize = 11; rm.TextColor3 = Color3.fromRGB(255, 200, 80)
    rm.TextXAlignment = Enum.TextXAlignment.Left
    rm.Text = "📱 Mobile: " .. recMob; rm.ZIndex = 52; rm.Parent = c

    -- Recommended PC
    local rp = Instance.new("TextLabel")
    rp.Size = UDim2.new(1, 0, 0, 14); rp.Position = UDim2.new(0, 0, 0, IS_MOBILE and 62 or 54)
    rp.BackgroundTransparency = 1; rp.Font = Enum.Font.GothamMedium
    rp.TextSize = 11; rp.TextColor3 = Color3.fromRGB(100, 180, 255)
    rp.TextXAlignment = Enum.TextXAlignment.Left
    rp.Text = "🖥️ PC: " .. recPC; rp.ZIndex = 52; rp.Parent = c

    local sliding = false
    local function upd(iPos)
        local tX = track.AbsolutePosition.X; local tW = track.AbsoluteSize.X
        if tW <= 0 then return end
        local r = math.clamp((iPos.X - tX) / tW, 0, 1)
        local v2 = math.floor((min + r * (max - min)) * 100 + 0.5) / 100
        fill.Size = UDim2.new(r, 0, 1, 0); handle.Position = UDim2.new(r, 0, 0.5, 0)
        val.Text = tostring(v2)
        if onChange then onChange(v2) end
    end

    track.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true; upd(i.Position)
        end
    end)
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = true
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if not sliding then return end
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement then
            upd(i.Position)
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
            sliding = false
        end
    end)
    return c
end

local function makeToggleRow(label, default, order, onChange)
    local RH = IS_MOBILE and 36 or 30
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, RH); row.BackgroundTransparency = 1
    row.LayoutOrder = order; row.ZIndex = 52; row.Parent = content

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0.65, 0, 1, 0); l.BackgroundTransparency = 1
    l.Font = Enum.Font.GothamMedium; l.TextSize = IS_MOBILE and 14 or 13
    l.TextColor3 = Color3.new(1, 1, 1); l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = label; l.ZIndex = 52; l.Parent = row

    local TW, TH = IS_MOBILE and 52 or 44, IS_MOBILE and 28 or 24
    local bg = Instance.new("TextButton")
    bg.AnchorPoint = Vector2.new(1, 0.5); bg.Position = UDim2.new(1, 0, 0.5, 0)
    bg.Size = UDim2.fromOffset(TW, TH)
    bg.BackgroundColor3 = default and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(60, 60, 60)
    bg.BackgroundTransparency = 0; bg.BorderSizePixel = 0; bg.Text = ""
    bg.AutoButtonColor = false; bg.ZIndex = 53; bg.Parent = row
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local DS = TH - 6
    local dot2 = Instance.new("Frame")
    dot2.AnchorPoint = Vector2.new(0, 0.5)
    dot2.Position = default and UDim2.new(1, -DS - 3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
    dot2.Size = UDim2.fromOffset(DS, DS)
    dot2.BackgroundColor3 = Color3.new(1, 1, 1); dot2.BackgroundTransparency = 0
    dot2.BorderSizePixel = 0; dot2.ZIndex = 54; dot2.Parent = bg
    Instance.new("UICorner", dot2).CornerRadius = UDim.new(1, 0)

    local state = default
    bg.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(bg, TweenInfo.new(0.2), {
            BackgroundColor3 = state and Color3.fromRGB(60, 180, 60) or Color3.fromRGB(60, 60, 60)
        }):Play()
        TweenService:Create(dot2, TweenInfo.new(0.2), {
            Position = state and UDim2.new(1, -DS - 3, 0.5, 0) or UDim2.new(0, 3, 0.5, 0)
        }):Play()
        if onChange then onChange(state) end
    end)
    return row
end

-- ── BUILD PANEL ──

makeLabel("AIM SETTINGS", IS_MOBILE and 14 or 13, Color3.fromRGB(150, 150, 150), 1)

makeSlider("Aim Speed (Strength)", 0.05, 1.0, CFG.Smoothing,
    "0.35 – 0.50 (strong auto-aim)",
    "0.40 – 0.55 (strong with mouse)",
    2, function(v) CFG.Smoothing = v end
)

makeSlider("FOV Radius (px)", 50, 400, CFG.FOVRadius,
    "220 (larger for touch)",
    "180 (standard for mouse)",
    3, function(v) CFG.FOVRadius = math.floor(v)
        fovCircle.Size = UDim2.fromOffset(CFG.FOVRadius * 2, CFG.FOVRadius * 2)
    end
)

makeSlider("Max Distance (studs)", 50, 1000, CFG.MaxDistance,
    "500 studs", "500 studs",
    4, function(v) CFG.MaxDistance = math.floor(v) end
)

makeSlider("Prediction Strength", 0.01, 0.2, CFG.PredictionScale,
    "0.06 (default)", "0.06 (default)",
    5, function(v) CFG.PredictionScale = v end
)

makeLabel("", 4, Color3.fromRGB(40, 40, 40), 6)
makeLabel("FEATURES", IS_MOBILE and 14 or 13, Color3.fromRGB(150, 150, 150), 7)

makeToggleRow("ESP (Highlights)", CFG.ESPEnabled, 8, function(v)
    CFG.ESPEnabled = v
    if not v then
        for _, plr in Players:GetPlayers() do
            if plr.Character then
                local h = plr.Character:FindFirstChild("AimAssistESP"); if h then h:Destroy() end
                local bb = plr.Character:FindFirstChild("AimAssistTag"); if bb then bb:Destroy() end
            end
        end
    end
end)
makeToggleRow("Wall Check", CFG.WallCheck, 9, function(v) CFG.WallCheck = v end)
makeToggleRow("Team Check", CFG.TeamCheck, 10, function(v) CFG.TeamCheck = v; CFG.ESPTeamCheck = v end)
makeToggleRow("Predict Movement", CFG.PredictMovement, 11, function(v) CFG.PredictMovement = v end)
makeToggleRow("Show FOV Circle", CFG.ShowFOVCircle, 12, function(v) CFG.ShowFOVCircle = v end)
makeToggleRow("Show Nearby Circles", CFG.ShowNearbyCircles, 13, function(v) CFG.ShowNearbyCircles = v end)
makeToggleRow("Smart Smoothing", CFG.SmartSmoothing, 14, function(v) CFG.SmartSmoothing = v end)

-- ══════════════════════════════════════════════
--  PANEL + BUTTON CONNECTIONS
-- ══════════════════════════════════════════════
local function togglePanel()
    panelOpen = not panelOpen
    panel.Visible = panelOpen
end

closeBtn.MouseButton1Click:Connect(function()
    panelOpen = false; panel.Visible = false
end)

makeDraggable(panel, titleBar)
makeDraggable(settingsBtn, settingsBtn, togglePanel)

local function toggleAim()
    CFG.Enabled = not CFG.Enabled
    if CFG.Enabled then
        toggleBtn.Text = "AIM\nON"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 50, 20)
        btnStroke.Color = Color3.fromRGB(100, 255, 100)
        statusDot.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    else
        toggleBtn.Text = "AIM\nOFF"
        toggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btnStroke.Color = Color3.fromRGB(100, 100, 100)
        statusDot.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
        lockCircle.Visible = false; lastAimPos = nil
        for _, p in nearbyPool do p.Frame.Visible = false end
    end
end

makeDraggable(toggleBtn, toggleBtn, toggleAim)

-- PC keys
UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe or scriptDestroyed then return end
    if inp.KeyCode == Enum.KeyCode.F then toggleAim()
    elseif inp.KeyCode == Enum.KeyCode.G then togglePanel() end
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
    if gpe or scriptDestroyed then return end
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then holdingAim = true end
end)
UserInputService.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton2 then
        holdingAim = false; lockedPlayer = nil; lastAimPos = nil
    end
end)

-- ══════════════════════════════════════════════
--  ESP
-- ══════════════════════════════════════════════
local function createESP(ch, plr)
    if not ch or ch:FindFirstChild("AimAssistESP") then return end
    local hl = Instance.new("Highlight")
    hl.Name = "AimAssistESP"; hl.FillColor = Color3.new(1, 1, 1)
    hl.FillTransparency = 0.7; hl.OutlineColor = Color3.new(1, 1, 1)
    hl.OutlineTransparency = 0.1; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = ch; hl.Parent = ch

    local head = ch:FindFirstChild("Head") or ch:WaitForChild("Head", 3)
    if not head then return end
    local bb = Instance.new("BillboardGui")
    bb.Name = "AimAssistTag"; bb.Adornee = head; bb.Size = UDim2.fromOffset(200, 50)
    bb.StudsOffset = Vector3.new(0, 2.5, 0); bb.AlwaysOnTop = true
    bb.MaxDistance = CFG.MaxDistance; bb.Parent = ch

    local nt = Instance.new("TextLabel")
    nt.Size = UDim2.new(1, 0, 0.5, 0); nt.BackgroundTransparency = 1
    nt.Font = Enum.Font.GothamBold; nt.TextSize = IS_MOBILE and 14 or 13
    nt.TextColor3 = Color3.new(1, 1, 1); nt.TextStrokeTransparency = 0.4
    nt.Text = plr.DisplayName; nt.Parent = bb

    local dt = Instance.new("TextLabel")
    dt.Name = "DistTag"; dt.Size = UDim2.new(1, 0, 0.5, 0)
    dt.Position = UDim2.new(0, 0, 0.5, 0); dt.BackgroundTransparency = 1
    dt.Font = Enum.Font.GothamMedium; dt.TextSize = IS_MOBILE and 12 or 11
    dt.TextColor3 = Color3.fromRGB(200, 200, 200); dt.TextStrokeTransparency = 0.5
    dt.Text = "0m"; dt.Parent = bb

    local hbg = Instance.new("Frame")
    hbg.AnchorPoint = Vector2.new(0.5, 0); hbg.Position = UDim2.new(0.5, 0, 1, 2)
    hbg.Size = UDim2.fromOffset(100, 6); hbg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    hbg.BackgroundTransparency = 0.3; hbg.BorderSizePixel = 0; hbg.Parent = bb
    Instance.new("UICorner", hbg).CornerRadius = UDim.new(1, 0)

    local hf = Instance.new("Frame")
    hf.Name = "HealthFill"; hf.Size = UDim2.new(1, 0, 1, 0)
    hf.BackgroundColor3 = Color3.fromRGB(100, 255, 100); hf.BackgroundTransparency = 0
    hf.BorderSizePixel = 0; hf.Parent = hbg
    Instance.new("UICorner", hf).CornerRadius = UDim.new(1, 0)
end

local function removeESP(ch)
    if not ch then return end
    local h = ch:FindFirstChild("AimAssistESP"); if h then h:Destroy() end
    local b = ch:FindFirstChild("AimAssistTag"); if b then b:Destroy() end
end

local function updateESP()
    if scriptDestroyed then return end
    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer then continue end
        local ch = plr.Character; if not ch then continue end
        if not CFG.ESPEnabled then removeESP(ch); continue end
        if CFG.ESPTeamCheck and LocalPlayer.Team and plr.Team == LocalPlayer.Team then removeESP(ch); continue end
        local hum = ch:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then removeESP(ch); continue end
        createESP(ch, plr)

        local bb = ch:FindFirstChild("AimAssistTag")
        if bb then
            local dtag = bb:FindFirstChild("DistTag")
            if dtag and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                local root = ch:FindFirstChild("HumanoidRootPart")
                if root then
                    dtag.Text = math.floor((root.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) .. "m"
                end
            end
            for _, child in bb:GetChildren() do
                if child:IsA("Frame") then
                    local hf = child:FindFirstChild("HealthFill")
                    if hf then
                        local r = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                        hf.Size = UDim2.new(r, 0, 1, 0)
                        hf.BackgroundColor3 = r > 0.6 and Color3.fromRGB(100, 255, 100)
                            or r > 0.3 and Color3.fromRGB(255, 200, 50)
                            or Color3.fromRGB(255, 60, 60)
                    end
                end
            end
        end
        local hl = ch:FindFirstChild("AimAssistESP")
        if hl then
            if lockedPlayer == plr then
                hl.OutlineColor = Color3.fromRGB(100, 255, 100)
                hl.FillColor = Color3.fromRGB(100, 255, 100); hl.FillTransparency = 0.6
            else
                hl.OutlineColor = Color3.new(1, 1, 1)
                hl.FillColor = Color3.new(1, 1, 1); hl.FillTransparency = 0.75
            end
        end
    end
end

for _, plr in Players:GetPlayers() do
    if plr == LocalPlayer then continue end
    if plr.Character and CFG.ESPEnabled then createESP(plr.Character, plr) end
    plr.CharacterAdded:Connect(function(ch)
        task.wait(0.5)
        if CFG.ESPEnabled and not scriptDestroyed then createESP(ch, plr) end
    end)
end
Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(ch)
        task.wait(0.5)
        if CFG.ESPEnabled and not scriptDestroyed then createESP(ch, plr) end
    end)
end)
Players.PlayerRemoving:Connect(function(plr) if plr.Character then removeESP(plr.Character) end end)

-- ══════════════════════════════════════════════
--  AIM ENGINE (STRONGER)
-- ══════════════════════════════════════════════
local function screenCenter()
    local v = Camera.ViewportSize; return Vector2.new(v.X / 2, v.Y / 2)
end

local function w2s(pos)
    local sp, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(sp.X, sp.Y), on, sp.Z
end

local function alive(plr)
    local ch = plr.Character; if not ch then return false end
    local h = ch:FindFirstChildOfClass("Humanoid")
    return h and h.Health > 0 and ch:FindFirstChild("HumanoidRootPart") ~= nil
end

local function sameTeam(plr)
    if not CFG.TeamCheck then return false end
    return LocalPlayer.Team and plr.Team == LocalPlayer.Team
end

local function canSee(bone)
    if not CFG.WallCheck then return true end
    local ch = LocalPlayer.Character; if not ch then return false end
    local origin = Camera.CFrame.Position; local dir = bone.Position - origin
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = { ch, Camera }; rp.RespectCanCollide = true
    local hit = workspace:Raycast(origin, dir, rp)
    if not hit then return true end
    return hit.Instance:FindFirstAncestorOfClass("Model") == bone.Parent
end

local function getBone(char)
    return char:FindFirstChild(CFG.TargetBone) or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
end

local function predict(char, bone)
    if not CFG.PredictMovement then return bone.Position end
    local root = char:FindFirstChild("HumanoidRootPart"); if not root then return bone.Position end
    local vel = root.AssemblyLinearVelocity
    local dist = (bone.Position - Camera.CFrame.Position).Magnitude
    return bone.Position + vel * (dist * CFG.PredictionScale / 100)
end

local function gatherTargets()
    local centre = screenCenter(); local targets = {}
    for _, plr in Players:GetPlayers() do
        if plr == LocalPlayer then continue end
        if not alive(plr) then continue end
        if sameTeam(plr) then continue end
        local bone = getBone(plr.Character); if not bone then continue end
        local d3 = (bone.Position - Camera.CFrame.Position).Magnitude
        if d3 > CFG.MaxDistance then continue end
        local sp, on, depth = w2s(bone.Position)
        if not on or depth < 1 then continue end
        local d2 = (sp - centre).Magnitude
        if not canSee(bone) then continue end
        table.insert(targets, {
            Player = plr, Character = plr.Character, Bone = bone,
            Screen = sp, Dist = d3, ScreenDist = d2,
            Score = d2 * 0.6 + d3 * 0.4,
            InFOV = d2 <= CFG.FOVRadius,
        })
    end
    table.sort(targets, function(a, b) return a.Score < b.Score end)
    return targets
end

-- STRONGER AIM: multi-step lerp per frame for tighter tracking
local function aimCamera(worldPos)
    local camPos  = Camera.CFrame.Position
    local curLook = Camera.CFrame.LookVector
    local goalDir = (worldPos - camPos).Unit

    local dotVal = math.clamp(curLook:Dot(goalDir), -1, 1)
    local angle  = math.acos(dotVal)

    local smooth = CFG.Smoothing

    if CFG.SmartSmoothing then
        -- When far off target, go FAST. When close, stay strong but not jittery
        if angle > math.rad(10) then
            smooth = math.clamp(CFG.Smoothing * 2.5, CFG.MinSmoothing, CFG.MaxSmoothing)
        elseif angle > math.rad(3) then
            smooth = math.clamp(CFG.Smoothing * 1.8, CFG.MinSmoothing, CFG.MaxSmoothing)
        else
            smooth = math.clamp(CFG.Smoothing * 1.2, CFG.MinSmoothing, CFG.MaxSmoothing)
        end
    end

    -- Double-lerp for stronger snap (two passes in one frame)
    local goalCF = CFrame.lookAt(camPos, camPos + goalDir)
    local pass1  = Camera.CFrame:Lerp(goalCF, smooth)
    local newCF  = pass1:Lerp(goalCF, smooth * 0.5)

    Camera.CFrame = CFrame.new(camPos) * (newCF - newCF.Position)

    -- Store the aim position for persistent circle tracking
    lastAimPos = worldPos
end

local function shouldAimNow()
    if not CFG.Enabled then return false end
    if IS_MOBILE then return CFG.MobileAutoAim end
    return holdingAim
end

-- ══════════════════════════════════════════════
--  MAIN RENDER LOOP
-- ══════════════════════════════════════════════
local espTimer = 0

RunService:BindToRenderStep("SmartAimV4", Enum.RenderPriority.Camera.Value + 1, function(dt)
    if scriptDestroyed then return end
    Camera = workspace.CurrentCamera

    espTimer = espTimer + dt
    if espTimer >= 0.2 then espTimer = 0; updateESP() end

    if not CFG.Enabled then
        fovCircle.Visible = false; lockCircle.Visible = false
        info.Text = ""; info.Visible = false
        for _, p in nearbyPool do p.Frame.Visible = false end
        return
    end

    local sc = screenCenter()
    fovCircle.Size = UDim2.fromOffset(CFG.FOVRadius * 2, CFG.FOVRadius * 2)
    fovCircle.Position = UDim2.fromOffset(sc.X, sc.Y)
    fovCircle.Visible = CFG.ShowFOVCircle

    local targets = gatherTargets()

    for i = 1, POOL_SIZE do
        local p = nearbyPool[i]; local tgt = targets[i]
        if tgt and CFG.ShowNearbyCircles then
            local dyn = math.clamp(CFG.NearbyCircleSize * (200 / math.max(tgt.Dist, 1)),
                IS_MOBILE and 16 or 12, IS_MOBILE and 60 or 52)
            p.Frame.Size = UDim2.fromOffset(dyn, dyn)
            p.Frame.Position = UDim2.fromOffset(tgt.Screen.X, tgt.Screen.Y)
            p.Frame.Visible = true
            local pulse = 0.3 + 0.7 * math.abs(math.sin(tick() * 3 + i))
            p.Stroke.Transparency = 1 - pulse
            p.Stroke.Color = Color3.new(1, 1, 1)
            p.Dot.BackgroundColor3 = Color3.new(1, 1, 1)
            p.Tag.Text = tgt.Player.DisplayName .. "  " .. math.floor(tgt.Dist) .. "m"
        else
            p.Frame.Visible = false
        end
    end

    local best = nil
    for _, t in targets do if t.InFOV then best = t; break end end

    local aiming = shouldAimNow()

    if aiming and best then
        -- STRONG sticky lock: keep locked player with very wide grace zone
        if lockedPlayer and alive(lockedPlayer) then
            local bone = getBone(lockedPlayer.Character)
            if bone and canSee(bone) then
                local lsp, lon, ldp = w2s(bone.Position)
                local ld2 = lon and (lsp - sc).Magnitude or math.huge
                -- Very wide grace zone (2.5x FOV) so lock doesn't break easily
                if ld2 <= CFG.FOVRadius * CFG.StickyMultiplier and ldp > 0 then
                    best = {
                        Player = lockedPlayer, Character = lockedPlayer.Character,
                        Bone = bone, Screen = lsp,
                        Dist = (bone.Position - Camera.CFrame.Position).Magnitude,
                        InFOV = true,
                    }
                else
                    lockedPlayer = nil
                end
            else
                lockedPlayer = nil
            end
        end

        lockedPlayer = best.Player
        local aimPos = predict(best.Character, best.Bone)
        aimCamera(aimPos)

        -- Lock circle tracks the SCREEN POSITION of the aim point directly
        local lsp2, lon2 = w2s(aimPos)
        if lon2 and CFG.ShowLockedCircle then
            local dynLock = math.clamp(CFG.LockedCircleSize * (220 / math.max(best.Dist, 1)),
                IS_MOBILE and 20 or 16, IS_MOBILE and 68 or 60)
            lockCircle.Size = UDim2.fromOffset(dynLock, dynLock)
            -- Place circle directly at screen-projected aim position
            lockCircle.Position = UDim2.fromOffset(lsp2.X, lsp2.Y)
            lockCircle.Visible = true
            local glow = 0.4 + 0.6 * math.abs(math.sin(tick() * 5))
            lockStroke.Transparency = 1 - glow
            local gc = 130 + math.floor(60 * glow)
            lockStroke.Color = Color3.fromRGB(gc, 255, gc)
            crossH.BackgroundColor3 = Color3.fromRGB(gc, 255, gc)
            crossV.BackgroundColor3 = Color3.fromRGB(gc, 255, gc)
            crossH.BackgroundTransparency = 0.4 - 0.3 * glow
            crossV.BackgroundTransparency = 0.4 - 0.3 * glow
        else
            lockCircle.Visible = false
        end

        info.Text = string.format("🔒 %s  |  %.0f studs  |  LOCKED", best.Player.DisplayName, best.Dist)
        info.TextColor3 = Color3.fromRGB(170, 255, 170)
        info.Visible = true

    elseif best then
        lockCircle.Visible = false; lockedPlayer = nil; lastAimPos = nil
        info.Text = string.format("👁 %s  |  %.0f studs  |  DETECTED", best.Player.DisplayName, best.Dist)
        info.TextColor3 = Color3.new(1, 1, 1); info.Visible = true
    else
        lockCircle.Visible = false; lockedPlayer = nil; lastAimPos = nil
        info.Text = "—  No targets  —"
        info.TextColor3 = Color3.fromRGB(160, 160, 160); info.Visible = true
    end

    if aiming and best then
        local bp = 0.5 + 0.5 * math.abs(math.sin(tick() * 4))
        btnStroke.Color = Color3.fromRGB(math.floor(100 + 155 * bp), 255, math.floor(100 + 155 * bp))
    end
end)

-- ══════════════════════════════════════════════
--  CLEANUP
-- ══════════════════════════════════════════════
LocalPlayer.CharacterRemoving:Connect(function()
    lockedPlayer = nil; lastAimPos = nil; lockCircle.Visible = false
    for _, p in nearbyPool do p.Frame.Visible = false end
end)

print("─────────────────────────────────────")
print("  ⚡ Aim Assist v4.2 loaded")
print("  Platform: " .. (IS_MOBILE and "MOBILE" or "PC"))
print("─────────────────────────────────────")