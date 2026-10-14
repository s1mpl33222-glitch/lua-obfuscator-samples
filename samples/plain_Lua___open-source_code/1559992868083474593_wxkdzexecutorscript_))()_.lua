-- ================================================================
-- WXKDZ v19 — FIXED ESP (naka-OFF by default)
-- Password: WXKDZ2024
-- Fix: ESP only shows when toggled ON
-- ================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local lp = Players.LocalPlayer
local cam = workspace.CurrentCamera

local PASSWORD = "WXKDZ2024"
local UNLOCKED = false

-- ============ SOUND ============
local SOUNDS = {
    Hover = "rbxassetid://9120386436",
    Click = "rbxassetid://9120386436",
    Toggle = "rbxassetid://9125402236",
    Open = "rbxassetid://9125402236",
    Close = "rbxassetid://9125402236",
    Notify = "rbxassetid://9125402236",
    Tab = "rbxassetid://9120386436",
    Unlock = "rbxassetid://9125402236",
    Error = "rbxassetid://9120386436",
}

local function playSound(id, volume, pitch)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = volume or 0.5
        s.PlaybackSpeed = pitch or 1
        s.Parent = SoundService
        s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
end

local function playHover() playSound(SOUNDS.Hover, 0.15, 1.2) end
local function playClick() playSound(SOUNDS.Click, 0.3, 1) end
local function playToggle() playSound(SOUNDS.Toggle, 0.3, 1.1) end
local function playOpen() playSound(SOUNDS.Open, 0.35, 1) end
local function playClose() playSound(SOUNDS.Close, 0.35, 0.9) end
local function playNotify() playSound(SOUNDS.Notify, 0.25, 1.4) end
local function playTab() playSound(SOUNDS.Tab, 0.25, 1.3) end
local function playUnlock() playSound(SOUNDS.Unlock, 0.4, 1.2) end
local function playError() playSound(SOUNDS.Error, 0.35, 0.7) end

-- ============ CONFIG ============
local CONFIG = {
    Enabled = false, FollowSpeed = 0.25, LockFollowSpeed = 0.5,
    TargetPart = "Head", TeamCheck = true, OffsetY = -0.15, LockedPlayer = nil,
    FOV = 250,
    SilentAim = false, SilentAimFOV = 300, SilentAimSpeed = 0.5,
    ESP = false, ESPColor = Color3.fromRGB(255,255,255),
    Fullbright = false, NoFog = false,
    Speed = false, SpeedValue = 32, Jump = false, JumpValue = 80,
    Noclip = false, Fly = false, FlySpeed = 50, InfiniteJump = false,
    AntiAFK = false, AutoRejoin = false,
    RapidFire = false, RapidFireDelay = 0.05,
    Bighead = false, BigheadSize = 3, BigheadAllPlayers = false, BigheadBypass = true,
}

local CurrentTarget = nil
local LastCameraType = cam.CameraType
local LastCameraSubject = cam.CameraSubject
local OriginalSpeed = 16
local OriginalJump = 50
local rapidFireConn, flyConn, noclipConn, infJumpConn, antiAfkConn
local bigheadConn, bigheadBypassConn
local flyBV, flyBG
local originalAmbient, originalBrightness, originalOutdoor, originalFogEnd, originalFogStart
local originalMeshData = {}
local espCache = {}

local FONT_HERO = Enum.Font.GothamBlack
local FONT_SUB = Enum.Font.GothamBold
local FONT_LABEL = Enum.Font.GothamSemibold
local FONT_MONO = Enum.Font.Code

-- ============ GUI ============
local gui = Instance.new("ScreenGui")
gui.Name = "WXKDZ"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder = 999
gui.Parent = lp:WaitForChild("PlayerGui")

local function add3DInside(frame)
    local hl = Instance.new("Frame")
    hl.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    hl.BackgroundTransparency = 0.9
    hl.BorderSizePixel = 0
    hl.Position = UDim2.new(0, 3, 0, 3)
    hl.Size = UDim2.new(1, -6, 0, 2)
    hl.ZIndex = frame.ZIndex + 1
    hl.Active = false; hl.Interactable = false
    hl.Parent = frame
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(1, 0); hc.Parent = hl
end

local function addNeonStroke(frame, color, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Color3.fromRGB(255, 255, 255)
    stroke.Thickness = thickness or 1.5
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Parent = frame
    return stroke
end

local function addGradient(frame, c1, c2, rotation)
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new(c1 or Color3.fromRGB(255,255,255), c2 or Color3.fromRGB(60,60,60))
    grad.Rotation = rotation or 45
    grad.Parent = frame
    return grad
end

-- ============ NOTIFICATION ============
local notifContainer = Instance.new("Frame")
notifContainer.Size = UDim2.new(0, 300, 0, 300)
notifContainer.Position = UDim2.new(1, -320, 0, 20)
notifContainer.BackgroundTransparency = 1
notifContainer.ZIndex = 100
notifContainer.Active = false; notifContainer.Interactable = false
notifContainer.Parent = gui

local notifLayout = Instance.new("UIListLayout")
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
notifLayout.Padding = UDim.new(0, 8)
notifLayout.Parent = notifContainer

local function showNotification(title, text, color)
    color = color or Color3.fromRGB(60, 220, 60)
    playNotify()
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(1, 0, 0, 58)
    notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    notif.BackgroundTransparency = 0.05
    notif.BorderSizePixel = 0
    notif.ZIndex = 101
    notif.Position = UDim2.new(1, 80, 0, 0)
    notif.ClipsDescendants = true
    notif.Parent = notifContainer
    local nCorner = Instance.new("UICorner"); nCorner.CornerRadius = UDim.new(0, 12); nCorner.Parent = notif

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,0,0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(20,20,20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,0,0))
    })
    bgGrad.Parent = notif
    TweenService:Create(bgGrad, TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Rotation = 360}):Play()

    addNeonStroke(notif, color, 1.5)
    add3DInside(notif)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 0.7, 0); accentBar.Position = UDim2.new(0, 6, 0.15, 0)
    accentBar.BackgroundColor3 = color; accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 105; accentBar.Parent = notif
    local abCorner = Instance.new("UICorner"); abCorner.CornerRadius = UDim.new(1, 0); abCorner.Parent = accentBar

    local nTitle = Instance.new("TextLabel")
    nTitle.Size = UDim2.new(1, -24, 0, 20); nTitle.Position = UDim2.new(0, 20, 0, 8)
    nTitle.BackgroundTransparency = 1
    nTitle.Text = title
    nTitle.Font = FONT_HERO; nTitle.TextSize = 12
    nTitle.TextColor3 = color
    nTitle.TextXAlignment = Enum.TextXAlignment.Left
    nTitle.ZIndex = 104; nTitle.Parent = notif

    local nText = Instance.new("TextLabel")
    nText.Size = UDim2.new(1, -24, 0, 18); nText.Position = UDim2.new(0, 20, 0, 30)
    nText.BackgroundTransparency = 1
    nText.Text = text
    nText.Font = FONT_LABEL; nText.TextSize = 10
    nText.TextColor3 = Color3.fromRGB(200, 200, 200)
    nText.TextXAlignment = Enum.TextXAlignment.Left
    nText.ZIndex = 104; nText.Parent = notif

    TweenService:Create(notif, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(0,0,0,0)}):Play()

    task.delay(4, function()
        local t = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 80, 0, 0),
            BackgroundTransparency = 1
        })
        t:Play()
        t.Completed:Connect(function() notif:Destroy() end)
    end)
end

-- ============ KEY GATE ============
local keyGate = Instance.new("Frame")
keyGate.Size = UDim2.new(0, 400, 0, 240)
keyGate.Position = UDim2.new(0.5, -200, 0.5, -120)
keyGate.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
keyGate.BackgroundTransparency = 0.02
keyGate.BorderSizePixel = 0
keyGate.ZIndex = 500
keyGate.Parent = gui
local kgCorner = Instance.new("UICorner"); kgCorner.CornerRadius = UDim.new(0, 18); kgCorner.Parent = keyGate
local kgStroke = addNeonStroke(keyGate, Color3.fromRGB(255, 255, 255), 2)
addGradient(kgStroke, Color3.fromRGB(255,255,255), Color3.fromRGB(80,80,80), 45)
add3DInside(keyGate)

local kgTitle = Instance.new("TextLabel")
kgTitle.Size = UDim2.new(1, 0, 0, 55); kgTitle.Position = UDim2.new(0, 0, 0, 22)
kgTitle.BackgroundTransparency = 1
kgTitle.Text = "WXKDZ"
kgTitle.Font = FONT_HERO; kgTitle.TextSize = 38
kgTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
kgTitle.ZIndex = 502; kgTitle.Parent = keyGate

local kgSub = Instance.new("TextLabel")
kgSub.Size = UDim2.new(1, 0, 0, 18); kgSub.Position = UDim2.new(0, 0, 0, 78)
kgSub.BackgroundTransparency = 1
kgSub.Text = "◆  ULTRA EDITION  ◆"
kgSub.Font = FONT_SUB; kgSub.TextSize = 10
kgSub.TextColor3 = Color3.fromRGB(150, 150, 150)
kgSub.ZIndex = 502; kgSub.Parent = keyGate

local kgInput = Instance.new("TextBox")
kgInput.Size = UDim2.new(0, 320, 0, 42); kgInput.Position = UDim2.new(0.5, -160, 0, 108)
kgInput.BackgroundColor3 = Color3.fromRGB(10, 10, 10); kgInput.BorderSizePixel = 0
kgInput.Text = ""; kgInput.PlaceholderText = "◆  ENTER KEY  ◆"
kgInput.Font = FONT_MONO; kgInput.TextSize = 16
kgInput.TextColor3 = Color3.fromRGB(255, 255, 255)
kgInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
kgInput.ClearTextOnFocus = false
kgInput.ZIndex = 502; kgInput.Parent = keyGate
local kgInputCorner = Instance.new("UICorner"); kgInputCorner.CornerRadius = UDim.new(0, 10); kgInputCorner.Parent = kgInput
local kgInputStroke = addNeonStroke(kgInput, Color3.fromRGB(120,120,120), 1.2)

kgInput.Focused:Connect(function()
    playTab()
    TweenService:Create(kgInputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 220, 60), Thickness = 2.5}):Play()
end)
kgInput.FocusLost:Connect(function()
    TweenService:Create(kgInputStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(120, 120, 120), Thickness = 1.2}):Play()
end)

local kgBtn = Instance.new("TextButton")
kgBtn.Size = UDim2.new(0, 320, 0, 42); kgBtn.Position = UDim2.new(0.5, -160, 0, 162)
kgBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0); kgBtn.BorderSizePixel = 0
kgBtn.Text = "◆  UNLOCK  ◆"
kgBtn.Font = FONT_HERO; kgBtn.TextSize = 14
kgBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
kgBtn.AutoButtonColor = false
kgBtn.ZIndex = 502; kgBtn.Parent = keyGate
local kgBtnCorner = Instance.new("UICorner"); kgBtnCorner.CornerRadius = UDim.new(0, 10); kgBtnCorner.Parent = kgBtn
local kgBtnStroke = addNeonStroke(kgBtn, Color3.fromRGB(255,255,255), 1.5)

kgBtn.MouseEnter:Connect(function()
    playHover()
    TweenService:Create(kgBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 330, 0, 44),
        Position = UDim2.new(0.5, -165, 0, 161)
    }):Play()
    TweenService:Create(kgBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 220, 60), Thickness = 2.5}):Play()
end)
kgBtn.MouseLeave:Connect(function()
    TweenService:Create(kgBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 320, 0, 42),
        Position = UDim2.new(0.5, -160, 0, 162)
    }):Play()
    TweenService:Create(kgBtnStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 255, 255), Thickness = 1.5}):Play()
end)

keyGate.Position = UDim2.new(0.5, -200, 0.5, -400)
TweenService:Create(keyGate, TweenInfo.new(0.7, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -200, 0.5, -120)
}):Play()

local function shakeKeyGate()
    local base = keyGate.Position
    task.spawn(function()
        for i = 1, 6 do
            keyGate.Position = base + UDim2.new(0, (i % 2 == 0 and 8 or -8), 0, 0)
            task.wait(0.03)
        end
        keyGate.Position = base
    end)
end

local function unlockScript()
    UNLOCKED = true
    playUnlock()
    local t = TweenService:Create(keyGate, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -200, 0.5, -400),
        BackgroundTransparency = 1
    })
    t:Play()
    t.Completed:Connect(function() keyGate:Destroy() end)
end

local function checkPassword()
    if kgInput.Text == PASSWORD then unlockScript()
    else
        playError()
        shakeKeyGate()
        kgInput.Text = ""
        kgInput.PlaceholderText = "✕  WRONG KEY  ✕"
        TweenService:Create(kgInput, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 0, 0)}):Play()
        task.delay(0.5, function()
            TweenService:Create(kgInput, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(10, 10, 10)}):Play()
        end)
    end
end

kgBtn.MouseButton1Click:Connect(checkPassword)
kgInput.FocusLost:Connect(function(enter) if enter then checkPassword() end end)

-- ============ OPEN BUTTON ============
local openBtn = Instance.new("TextButton")
openBtn.Size = UDim2.new(0, 54, 0, 54)
openBtn.Position = UDim2.new(0, 20, 0.5, -27)
openBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
openBtn.BackgroundTransparency = 0.03
openBtn.BorderSizePixel = 0
openBtn.Text = ""
openBtn.AutoButtonColor = false
openBtn.Visible = false
openBtn.ZIndex = 150
openBtn.Active = true
openBtn.Parent = gui
local obCorner = Instance.new("UICorner"); obCorner.CornerRadius = UDim.new(1, 0); obCorner.Parent = openBtn
local obStroke = addNeonStroke(openBtn, Color3.fromRGB(255,255,255), 2.5)
addGradient(obStroke, Color3.fromRGB(255,255,255), Color3.fromRGB(100,100,100), 45)

local obIcon = Instance.new("TextLabel")
obIcon.Size = UDim2.new(1, 0, 1, 0)
obIcon.BackgroundTransparency = 1
obIcon.Text = "W"
obIcon.Font = FONT_HERO; obIcon.TextSize = 24
obIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
obIcon.ZIndex = 152
obIcon.Active = false; obIcon.Interactable = false
obIcon.Parent = openBtn

task.spawn(function()
    while gui.Parent do
        TweenService:Create(obStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Thickness = 4, Color = Color3.fromRGB(220,220,220)}):Play()
        task.wait(1)
        TweenService:Create(obStroke, TweenInfo.new(1, Enum.EasingStyle.Sine), {Thickness = 2.5, Color = Color3.fromRGB(255,255,255)}):Play()
        task.wait(1)
    end
end)

openBtn.MouseEnter:Connect(function()
    playHover()
    TweenService:Create(openBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 17, 0.5, -30)
    }):Play()
end)
openBtn.MouseLeave:Connect(function()
    TweenService:Create(openBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
        Size = UDim2.new(0, 54, 0, 54),
        Position = UDim2.new(0, 20, 0.5, -27)
    }):Play()
end)

local draggingBtn = false
local dragStartB, startPosB, wasDraggedB = false, nil, nil, false
openBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingBtn = true; wasDraggedB = false
        dragStartB = input.Position
        startPosB = openBtn.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingBtn and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStartB
        if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then wasDraggedB = true end
        openBtn.Position = UDim2.new(
            startPosB.X.Scale, startPosB.X.Offset + delta.X,
            startPosB.Y.Scale, startPosB.Y.Offset + delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then draggingBtn = false end
end)

-- ============ MAIN PANEL ============
local panel = Instance.new("Frame")
panel.Size = UDim2.new(0, 520, 0, 420)
panel.Position = UDim2.new(0.5, -260, 0.5, -210)
panel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
panel.BackgroundTransparency = 0.02
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 200
panel.ClipsDescendants = true
panel.Active = true
panel.Parent = gui

local panelCorner = Instance.new("UICorner"); panelCorner.CornerRadius = UDim.new(0, 16); panelCorner.Parent = panel
local panelStroke = addNeonStroke(panel, Color3.fromRGB(255,255,255), 2)
addGradient(panelStroke, Color3.fromRGB(255,255,255), Color3.fromRGB(80,80,80), 45)
add3DInside(panel)

local panelGlow = Instance.new("ImageLabel")
panelGlow.Size = UDim2.new(1, 80, 1, 80); panelGlow.Position = UDim2.new(0, -40, 0, -40)
panelGlow.BackgroundTransparency = 1
panelGlow.Image = "rbxassetid://5028857084"
panelGlow.ImageColor3 = Color3.fromRGB(255, 255, 255)
panelGlow.ImageTransparency = 0.7
panelGlow.ZIndex = 0; panelGlow.Parent = panel

local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 46)
header.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
header.BorderSizePixel = 0
header.ZIndex = 201; header.Parent = panel
local hCorner = Instance.new("UICorner"); hCorner.CornerRadius = UDim.new(0, 16); hCorner.Parent = header
local hFix = Instance.new("Frame")
hFix.Size = UDim2.new(1, 0, 0, 23); hFix.Position = UDim2.new(0, 0, 1, -23)
hFix.BackgroundColor3 = Color3.fromRGB(8, 8, 8)
hFix.BorderSizePixel = 0
hFix.ZIndex = 201; hFix.Parent = header

local topAccent = Instance.new("Frame")
topAccent.Size = UDim2.new(0.3, 0, 0, 3); topAccent.Position = UDim2.new(-0.3, 0, 0, 0)
topAccent.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topAccent.BorderSizePixel = 0
topAccent.ZIndex = 204; topAccent.Parent = header
local taGrad = Instance.new("UIGradient")
taGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255, 1)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255, 0))
})
taGrad.Parent = topAccent

local headerTitle = Instance.new("TextLabel")
headerTitle.Size = UDim2.new(1, -150, 1, 0); headerTitle.Position = UDim2.new(0, 20, 0, 0)
headerTitle.BackgroundTransparency = 1
headerTitle.Text = "WXKDZ"
headerTitle.Font = FONT_HERO; headerTitle.TextSize = 16
headerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
headerTitle.TextXAlignment = Enum.TextXAlignment.Left
headerTitle.ZIndex = 202; headerTitle.Parent = header

local headerSub = Instance.new("TextLabel")
headerSub.Size = UDim2.new(0, 200, 1, 0); headerSub.Position = UDim2.new(0, 100, 0, 16)
headerSub.BackgroundTransparency = 1
headerSub.Text = "◆ ULTRA"
headerSub.Font = FONT_SUB; headerSub.TextSize = 9
headerSub.TextColor3 = Color3.fromRGB(120, 120, 120)
headerSub.TextXAlignment = Enum.TextXAlignment.Left
headerSub.ZIndex = 203; headerSub.Parent = header

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30); closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
closeBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); closeBtn.BorderSizePixel = 0
closeBtn.Text = "✕"
closeBtn.Font = FONT_HERO; closeBtn.TextSize = 14
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.AutoButtonColor = false
closeBtn.ZIndex = 203; closeBtn.Parent = header
local cbCorner = Instance.new("UICorner"); cbCorner.CornerRadius = UDim.new(0, 8); cbCorner.Parent = closeBtn
local cbStroke = addNeonStroke(closeBtn, Color3.fromRGB(255,100,100), 1.2)

closeBtn.MouseEnter:Connect(function()
    playHover()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(60, 20, 20), TextColor3 = Color3.fromRGB(255, 180, 180)}):Play()
    TweenService:Create(cbStroke, TweenInfo.new(0.15), {Thickness = 2.5}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(20, 20, 20), TextColor3 = Color3.fromRGB(255, 100, 100)}):Play()
    TweenService:Create(cbStroke, TweenInfo.new(0.15), {Thickness = 1.2}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
    playClose()
    local t = TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, 600, 0.5, -210),
        BackgroundTransparency = 1
    })
    t:Play()
    t.Completed:Connect(function()
        panel.Visible = false
        panel.Position = UDim2.new(0.5, -260, 0.5, -210)
        panel.BackgroundTransparency = 0.02
        openBtn.Visible = true
        openBtn.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(openBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 54, 0, 54)}):Play()
    end)
end)

local dragHandle = Instance.new("TextButton")
dragHandle.Size = UDim2.new(1, -75, 1, 0)
dragHandle.BackgroundTransparency = 1
dragHandle.Text = ""
dragHandle.ZIndex = 205; dragHandle.Parent = header

local draggingPanel = false
local dragStart, startPos
dragHandle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        draggingPanel = true
        dragStart = input.Position
        startPos = panel.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if draggingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        panel.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then draggingPanel = false end
end)

local function openPanel()
    if not UNLOCKED then return end
    playOpen()
    openBtn.Visible = false
    panel.Visible = true
    panel.Position = UDim2.new(0.5, 600, 0.5, -210)
    panel.BackgroundTransparency = 1
    TweenService:Create(panel, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -260, 0.5, -210),
        BackgroundTransparency = 0.02
    }):Play()
end

openBtn.MouseButton1Click:Connect(function()
    if wasDraggedB then wasDraggedB = false; return end
    openPanel()
end)

task.spawn(function()
    while gui.Parent do
        TweenService:Create(panelStroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Thickness = 1.5}):Play()
        TweenService:Create(panelGlow, TweenInfo.new(0.9), {ImageTransparency = 0.85}):Play()
        task.wait(0.9)
        TweenService:Create(panelStroke, TweenInfo.new(0.9, Enum.EasingStyle.Sine), {Thickness = 3}):Play()
        TweenService:Create(panelGlow, TweenInfo.new(0.9), {ImageTransparency = 0.55}):Play()
        task.wait(0.9)
    end
end)

task.spawn(function()
    while gui.Parent do
        topAccent.Position = UDim2.new(-0.3, 0, 0, 0)
        local t = TweenService:Create(topAccent, TweenInfo.new(1.4, Enum.EasingStyle.Quad), {Position = UDim2.new(1, 0, 0, 0)})
        t:Play(); t.Completed:Wait(); task.wait(1.0)
    end
end)

-- Tabs
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -24, 0, 30); tabBar.Position = UDim2.new(0, 12, 0, 56)
tabBar.BackgroundColor3 = Color3.fromRGB(6, 6, 6)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 201; tabBar.Parent = panel
local tbCorner = Instance.new("UICorner"); tbCorner.CornerRadius = UDim.new(0, 8); tbCorner.Parent = tabBar
addNeonStroke(tabBar, Color3.fromRGB(60,60,60), 1)

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 2)
tabLayout.Parent = tabBar

local tabPad = Instance.new("UIPadding")
tabPad.PaddingTop = UDim.new(0, 3); tabPad.PaddingBottom = UDim.new(0, 3)
tabPad.PaddingLeft = UDim.new(0, 5); tabPad.PaddingRight = UDim.new(0, 5)
tabPad.Parent = tabBar

local tabs = {
    {name = "◆ SCRIPT", id = "script"},
    {name = "◆ CONSOLE", id = "console"},
    {name = "◆ CMD", id = "commands"},
    {name = "◆ COMBAT", id = "combat"},
    {name = "◆ VISUAL", id = "visual"},
    {name = "◆ FUN", id = "fun"},
    {name = "◆ MOVE", id = "move"},
    {name = "◆ ABOUT", id = "about"},
}

local tabButtons = {}
local frames = {}

for _, tab in ipairs(tabs) do
    local f = Instance.new("Frame")
    f.Size = UDim2.new(1, -24, 1, -180); f.Position = UDim2.new(0, 12, 0, 94)
    f.BackgroundTransparency = 1; f.Visible = (tab.id == "script"); f.ZIndex = 201
    f.Parent = panel
    frames[tab.id] = f
end

local function showTab(id)
    playTab()
    for tid, f in pairs(frames) do
        if tid == id then
            f.Visible = true
            f.Position = UDim2.new(0, 12, 0, 104)
            TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 12, 0, 94)
            }):Play()
        else
            f.Visible = false
        end
    end
    for name, btn in pairs(tabButtons) do
        if name == id then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255,255,255), TextColor3 = Color3.fromRGB(0,0,0)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(12,12,12), TextColor3 = Color3.fromRGB(160,160,160)}):Play()
        end
    end
end

for i, tab in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 58, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
    btn.BorderSizePixel = 0
    btn.Text = tab.name
    btn.Font = FONT_HERO; btn.TextSize = 7
    btn.TextColor3 = Color3.fromRGB(160, 160, 160)
    btn.AutoButtonColor = false
    btn.LayoutOrder = i
    btn.ZIndex = 202
    btn.Parent = tabBar
    local bCorner = Instance.new("UICorner"); bCorner.CornerRadius = UDim.new(0, 6); bCorner.Parent = btn
    addNeonStroke(btn, Color3.fromRGB(60,60,60), 1)
    btn.MouseEnter:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(255,255,255) then
            playHover()
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
        end
    end)
    btn.MouseLeave:Connect(function()
        if btn.BackgroundColor3 ~= Color3.fromRGB(255,255,255) then
            TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(12,12,12)}):Play()
        end
    end)
    btn.MouseButton1Click:Connect(function() showTab(tab.id) end)
    tabButtons[tab.id] = btn
end

-- Script editor
local editorFrame = Instance.new("Frame")
editorFrame.Size = UDim2.new(1, 0, 1, 0)
editorFrame.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
editorFrame.BorderSizePixel = 0
editorFrame.ZIndex = 202; editorFrame.ClipsDescendants = true
editorFrame.Parent = frames.script
local efCorner = Instance.new("UICorner"); efCorner.CornerRadius = UDim.new(0, 10); efCorner.Parent = editorFrame
addNeonStroke(editorFrame, Color3.fromRGB(40,40,40), 1)

local editorInput = Instance.new("TextBox")
editorInput.Size = UDim2.new(1, -20, 1, -20); editorInput.Position = UDim2.new(0, 10, 0, 10)
editorInput.BackgroundTransparency = 1
editorInput.Text = ""
editorInput.PlaceholderText = "-- ◆ Type your Lua script here..."
editorInput.Font = FONT_MONO; editorInput.TextSize = 11
editorInput.TextColor3 = Color3.fromRGB(230, 230, 230)
editorInput.PlaceholderColor3 = Color3.fromRGB(70, 70, 70)
editorInput.TextXAlignment = Enum.TextXAlignment.Left
editorInput.TextYAlignment = Enum.TextYAlignment.Top
editorInput.TextWrapped = true
editorInput.MultiLine = true
editorInput.ClearTextOnFocus = false
editorInput.ZIndex = 204; editorInput.Parent = editorFrame

-- Console
local consoleScroll = Instance.new("ScrollingFrame")
consoleScroll.Size = UDim2.new(1, 0, 1, 0)
consoleScroll.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
consoleScroll.BorderSizePixel = 0
consoleScroll.ScrollBarThickness = 4
consoleScroll.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
consoleScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
consoleScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
consoleScroll.ZIndex = 202; consoleScroll.Parent = frames.console
local csCorner = Instance.new("UICorner"); csCorner.CornerRadius = UDim.new(0, 10); csCorner.Parent = consoleScroll
addNeonStroke(consoleScroll, Color3.fromRGB(40,40,40), 1)

local consoleLayout = Instance.new("UIListLayout")
consoleLayout.SortOrder = Enum.SortOrder.LayoutOrder
consoleLayout.Padding = UDim.new(0, 4)
consoleLayout.Parent = consoleScroll

local consoleLogs = {}
local function logConsole(msg, color)
    color = color or Color3.fromRGB(120, 200, 120)
    local entry = Instance.new("TextLabel")
    entry.Size = UDim2.new(1, 0, 0, 14)
    entry.BackgroundTransparency = 1
    entry.Text = "◆ " .. msg
    entry.Font = FONT_MONO; entry.TextSize = 10
    entry.TextColor3 = color
    entry.TextXAlignment = Enum.TextXAlignment.Left
    entry.TextWrapped = true
    entry.AutomaticSize = Enum.AutomaticSize.Y
    entry.LayoutOrder = #consoleLogs + 1
    entry.ZIndex = 203; entry.Parent = consoleScroll
    entry.TextTransparency = 1
    TweenService:Create(entry, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    table.insert(consoleLogs, entry)
    task.wait()
    consoleScroll.CanvasPosition = Vector2.new(0, consoleScroll.AbsoluteCanvasSize.Y)
end

logConsole("WXKDZ v19 loaded", Color3.fromRGB(100, 180, 255))

-- Commands
local cmdScroll = Instance.new("ScrollingFrame")
cmdScroll.Size = UDim2.new(1, 0, 1, 0)
cmdScroll.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
cmdScroll.BorderSizePixel = 0
cmdScroll.ScrollBarThickness = 6
cmdScroll.ScrollBarImageColor3 = Color3.fromRGB(220, 220, 220)
cmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
cmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cmdScroll.ClipsDescendants = true
cmdScroll.ZIndex = 203; cmdScroll.Parent = frames.commands
local cmdsCorner = Instance.new("UICorner"); cmdsCorner.CornerRadius = UDim.new(0, 10); cmdsCorner.Parent = cmdScroll
addNeonStroke(cmdScroll, Color3.fromRGB(40,40,40), 1)

local cmdsLayout = Instance.new("UIListLayout")
cmdsLayout.SortOrder = Enum.SortOrder.LayoutOrder
cmdsLayout.Padding = UDim.new(0, 4)
cmdsLayout.Parent = cmdScroll

local cmdsPad = Instance.new("UIPadding")
cmdsPad.PaddingTop = UDim.new(0, 6); cmdsPad.PaddingBottom = UDim.new(0, 6)
cmdsPad.PaddingLeft = UDim.new(0, 6); cmdsPad.PaddingRight = UDim.new(0, 12)
cmdsPad.Parent = cmdScroll

local CommandsList = {
    {cmd = "$cc", desc = "Open custom chat"},
    {cmd = "$on", desc = "Aim assist ON"},
    {cmd = "$off", desc = "Aim assist OFF"},
    {cmd = "$silentaim", desc = "Toggle silent aim"},
    {cmd = "$esp", desc = "Toggle ESP"},
    {cmd = "$rapidfire", desc = "Toggle rapid fire"},
    {cmd = "$bighead", desc = "Bighead self (visual)"},
    {cmd = "$bigheadall", desc = "Bighead other (visual)"},
    {cmd = "$bigheadsize [n]", desc = "Set bighead size"},
    {cmd = "$fullbright", desc = "Toggle fullbright"},
    {cmd = "$nofog", desc = "Toggle no fog"},
    {cmd = "$speed [n]", desc = "Speed hack"},
    {cmd = "$jump [n]", desc = "Jump power"},
    {cmd = "$noclip", desc = "Toggle noclip"},
    {cmd = "$fly", desc = "Toggle fly"},
    {cmd = "$infjump", desc = "Toggle infinite jump"},
    {cmd = "$antiafk", desc = "Toggle anti-AFK"},
    {cmd = "$rejoin", desc = "Rejoin server"},
    {cmd = "$status", desc = "Show status"},
}

for i, data in ipairs(CommandsList) do
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundColor3 = Color3.fromRGB(16, 16, 16)
    row.BorderSizePixel = 0
    row.LayoutOrder = i
    row.ZIndex = 204; row.Parent = cmdScroll
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 8); rc.Parent = row
    addNeonStroke(row, Color3.fromRGB(40,40,40), 1)

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(0, 3, 0.7, 0); accent.Position = UDim2.new(0, 6, 0.15, 0)
    accent.BackgroundColor3 = Color3.fromRGB(60, 220, 60); accent.BorderSizePixel = 0
    accent.ZIndex = 205; accent.Parent = row
    local acCorner = Instance.new("UICorner"); acCorner.CornerRadius = UDim.new(1, 0); acCorner.Parent = accent

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -20, 0, 18); lbl.Position = UDim2.new(0, 14, 0, 3)
    lbl.BackgroundTransparency = 1
    lbl.Text = data.cmd
    lbl.Font = FONT_MONO; lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(80, 240, 80)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 205; lbl.Parent = row

    local descLbl = Instance.new("TextLabel")
    descLbl.Size = UDim2.new(1, -20, 0, 14); descLbl.Position = UDim2.new(0, 14, 0, 21)
    descLbl.BackgroundTransparency = 1
    descLbl.Text = data.desc
    descLbl.Font = FONT_LABEL; descLbl.TextSize = 9
    descLbl.TextColor3 = Color3.fromRGB(140, 140, 140)
    descLbl.TextXAlignment = Enum.TextXAlignment.Left
    descLbl.ZIndex = 205; descLbl.Parent = row

    local click = Instance.new("TextButton")
    click.Size = UDim2.new(1, 0, 1, 0)
    click.BackgroundTransparency = 1
    click.Text = ""
    click.ZIndex = 206; click.Parent = row
    click.MouseEnter:Connect(function()
        playHover()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    end)
    click.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}):Play()
    end)
    click.MouseButton1Click:Connect(function()
        playClick()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(50, 120, 50)}):Play()
        task.delay(0.2, function()
            TweenService:Create(row, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}):Play()
        end)
        showNotification("Command", "Copied: " .. data.cmd, Color3.fromRGB(100, 180, 255))
    end)
end

-- ============ TOGGLE BUILDER ============
local function makeToggleRow(parent, yPos, label, desc, configKey, onToggle)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50); row.Position = UDim2.new(0, 0, 0, yPos)
    row.BackgroundColor3 = Color3.fromRGB(16, 16, 16); row.BorderSizePixel = 0
    row.ZIndex = 202; row.Parent = parent
    local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 10); rc.Parent = row
    local rowStroke = addNeonStroke(row, Color3.fromRGB(50,50,50), 1)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 0, 18); lbl.Position = UDim2.new(0, 16, 0, 5)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.Font = FONT_HERO; lbl.TextSize = 11
    lbl.TextColor3 = Color3.fromRGB(230, 230, 230)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 203; lbl.Parent = row

    local dsc = Instance.new("TextLabel")
    dsc.Size = UDim2.new(0.65, 0, 0, 14); dsc.Position = UDim2.new(0, 16, 0, 24)
    dsc.BackgroundTransparency = 1
    dsc.Text = desc
    dsc.Font = FONT_LABEL; dsc.TextSize = 9
    dsc.TextColor3 = Color3.fromRGB(130, 130, 130)
    dsc.TextXAlignment = Enum.TextXAlignment.Left
    dsc.ZIndex = 203; dsc.Parent = row

    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 54, 0, 26); toggle.Position = UDim2.new(1, -68, 0.5, -13)
    toggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30); toggle.BorderSizePixel = 0
    toggle.Text = "OFF"
    toggle.Font = FONT_HERO; toggle.TextSize = 10
    toggle.TextColor3 = Color3.fromRGB(180, 180, 180)
    toggle.AutoButtonColor = false
    toggle.ZIndex = 203; toggle.Parent = row
    local tc = Instance.new("UICorner"); tc.CornerRadius = UDim.new(1, 0); tc.Parent = toggle
    local toggleStroke = addNeonStroke(toggle, Color3.fromRGB(60,60,60), 1)

    local function render()
        if CONFIG[configKey] == true then
            toggle.Text = "ON"
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(60, 220, 60),
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(110, 220, 110)}):Play()
        else
            toggle.Text = "OFF"
            TweenService:Create(toggle, TweenInfo.new(0.2), {
                BackgroundColor3 = Color3.fromRGB(30, 30, 30),
                TextColor3 = Color3.fromRGB(180, 180, 180)
            }):Play()
            TweenService:Create(toggleStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 60)}):Play()
        end
    end
    render()

    local clickArea = Instance.new("TextButton")
    clickArea.Size = UDim2.new(1, 0, 1, 0)
    clickArea.BackgroundTransparency = 1
    clickArea.Text = ""
    clickArea.ZIndex = 204; clickArea.Parent = row

    clickArea.MouseEnter:Connect(function()
        playHover()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(24, 24, 24)}):Play()
        TweenService:Create(rowStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(90, 90, 90)}):Play()
    end)
    clickArea.MouseLeave:Connect(function()
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}):Play()
        TweenService:Create(rowStroke, TweenInfo.new(0.15), {Color = Color3.fromRGB(50, 50, 50)}):Play()
    end)

    clickArea.MouseButton1Click:Connect(function()
        playToggle()
        CONFIG[configKey] = not CONFIG[configKey]
        render()
        TweenService:Create(row, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(60, 100, 60)}):Play()
        task.delay(0.15, function()
            TweenService:Create(row, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}):Play()
        end)
        if onToggle then
            local ok, err = pcall(onToggle)
            if not ok then warn("[WXKDZ] Toggle error: " .. tostring(err)) end
        end
    end)
    return row
end

-- ============ COMBAT TAB ============
local combatTitle = Instance.new("TextLabel")
combatTitle.Size = UDim2.new(1, 0, 0, 24)
combatTitle.BackgroundTransparency = 1
combatTitle.Text = "◆ COMBAT"
combatTitle.Font = FONT_HERO; combatTitle.TextSize = 13
combatTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
combatTitle.TextXAlignment = Enum.TextXAlignment.Left
combatTitle.ZIndex = 202; combatTitle.Parent = frames.combat

makeToggleRow(frames.combat, 30, "AIM ASSIST", "Camera follow nearest", "Enabled", function()
    if CONFIG.Enabled then
        LastCameraType = cam.CameraType
        LastCameraSubject = cam.CameraSubject
        cam.CameraType = Enum.CameraType.Scriptable
    else
        CurrentTarget = nil
        cam.CameraType = LastCameraType or Enum.CameraType.Custom
        if lp.Character then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end
end)

makeToggleRow(frames.combat, 88, "SILENT AIM", "Auto head-lock, switch on kill", "SilentAim", function()
    if CONFIG.SilentAim then
        CONFIG.Enabled = true
        LastCameraType = cam.CameraType
        LastCameraSubject = cam.CameraSubject
        cam.CameraType = Enum.CameraType.Scriptable
        CurrentTarget = nil
    else
        CurrentTarget = nil
        cam.CameraType = LastCameraType or Enum.CameraType.Custom
        if lp.Character then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
    end
end)

makeToggleRow(frames.combat, 146, "RAPID FIRE", "Auto-fire weapon", "RapidFire", function() end)

-- ============ VISUAL TAB ============
local visualTitle = Instance.new("TextLabel")
visualTitle.Size = UDim2.new(1, 0, 0, 24)
visualTitle.BackgroundTransparency = 1
visualTitle.Text = "◆ VISUAL"
visualTitle.Font = FONT_HERO; visualTitle.TextSize = 13
visualTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
visualTitle.TextXAlignment = Enum.TextXAlignment.Left
visualTitle.ZIndex = 202; visualTitle.Parent = frames.visual

makeToggleRow(frames.visual, 30, "ESP 3D", "Box + Name + Health + Dist", "ESP", function()
    refreshAllESP()
end)

makeToggleRow(frames.visual, 88, "FULLBRIGHT", "Brighten the map", "Fullbright", function()
    applyFullbright()
end)

makeToggleRow(frames.visual, 146, "NO FOG", "Remove fog", "NoFog", function()
    applyNoFog()
end)

-- ============ FUN TAB ============
local funTitle = Instance.new("TextLabel")
funTitle.Size = UDim2.new(1, 0, 0, 24)
funTitle.BackgroundTransparency = 1
funTitle.Text = "◆ FUN — BIGHEAD"
funTitle.Font = FONT_HERO; funTitle.TextSize = 13
funTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
funTitle.TextXAlignment = Enum.TextXAlignment.Left
funTitle.ZIndex = 202; funTitle.Parent = frames.fun

makeToggleRow(frames.fun, 30, "BIGHEAD (SELF)", "Enlarge YOUR head (visual)", "Bighead", function() updateBighead() end)
makeToggleRow(frames.fun, 88, "BIGHEAD (ALL)", "Enlarge OTHER players (visual)", "BigheadAllPlayers", function() updateBighead() end)
makeToggleRow(frames.fun, 146, "ANTI-BYPASS", "Re-apply mesh scale", "BigheadBypass", function() updateBighead() end)

-- Bighead slider
local bhSliderLabel = Instance.new("TextLabel")
bhSliderLabel.Size = UDim2.new(1, 0, 0, 18); bhSliderLabel.Position = UDim2.new(0, 0, 0, 200)
bhSliderLabel.BackgroundTransparency = 1
bhSliderLabel.Text = "◆ BIGHEAD SIZE: 3.0x"
bhSliderLabel.Font = FONT_HERO; bhSliderLabel.TextSize = 10
bhSliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
bhSliderLabel.TextXAlignment = Enum.TextXAlignment.Left
bhSliderLabel.ZIndex = 202; bhSliderLabel.Parent = frames.fun

local bhSliderBar = Instance.new("Frame")
bhSliderBar.Size = UDim2.new(1, -20, 0, 12); bhSliderBar.Position = UDim2.new(0, 10, 0, 222)
bhSliderBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30); bhSliderBar.BorderSizePixel = 0
bhSliderBar.ZIndex = 202; bhSliderBar.Parent = frames.fun
local bhSbCorner = Instance.new("UICorner"); bhSbCorner.CornerRadius = UDim.new(1, 0); bhSbCorner.Parent = bhSliderBar
addNeonStroke(bhSliderBar, Color3.fromRGB(60,60,60), 1)

local bhSliderFill = Instance.new("Frame")
local bhInitPct = (CONFIG.BigheadSize - 1.5) / (5 - 1.5)
bhSliderFill.Size = UDim2.new(bhInitPct, 0, 1, 0)
bhSliderFill.BackgroundColor3 = Color3.fromRGB(60, 220, 60); bhSliderFill.BorderSizePixel = 0
bhSliderFill.ZIndex = 203; bhSliderFill.Parent = bhSliderBar
local bhSfCorner = Instance.new("UICorner"); bhSfCorner.CornerRadius = UDim.new(1, 0); bhSfCorner.Parent = bhSliderFill

local bhSliderKnob = Instance.new("Frame")
bhSliderKnob.Size = UDim2.new(0, 16, 0, 16); bhSliderKnob.Position = UDim2.new(bhInitPct, -8, 0.5, -8)
bhSliderKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255); bhSliderKnob.BorderSizePixel = 0
bhSliderKnob.ZIndex = 204; bhSliderKnob.Parent = bhSliderBar
local bhSkCorner = Instance.new("UICorner"); bhSkCorner.CornerRadius = UDim.new(1, 0); bhSkCorner.Parent = bhSliderKnob
addNeonStroke(bhSliderKnob, Color3.fromRGB(255,255,255), 1.5)

local function updateBigheadSliderUI()
    local pct = (CONFIG.BigheadSize - 1.5) / (5 - 1.5)
    pct = math.clamp(pct, 0, 1)
    TweenService:Create(bhSliderFill, TweenInfo.new(0.1), {Size = UDim2.new(pct, 0, 1, 0)}):Play()
    TweenService:Create(bhSliderKnob, TweenInfo.new(0.1), {Position = UDim2.new(pct, -8, 0.5, -8)}):Play()
    bhSliderLabel.Text = "◆ BIGHEAD SIZE: " .. string.format("%.1f", CONFIG.BigheadSize) .. "x"
end

local bhDragging = false
local function setFromX(absX)
    local rel = (absX - bhSliderBar.AbsolutePosition.X) / bhSliderBar.AbsoluteSize.X
    rel = math.clamp(rel, 0, 1)
    CONFIG.BigheadSize = 1.5 + rel * (5 - 1.5)
    updateBigheadSliderUI()
    updateBighead()
end

bhSliderBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        bhDragging = true
        setFromX(input.Position.X)
    end
end)
UIS.InputChanged:Connect(function(input)
    if bhDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        setFromX(input.Position.X)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then bhDragging = false end
end)

-- ============ MOVE TAB ============
local moveTitle = Instance.new("TextLabel")
moveTitle.Size = UDim2.new(1, 0, 0, 24)
moveTitle.BackgroundTransparency = 1
moveTitle.Text = "◆ MOVE"
moveTitle.Font = FONT_HERO; moveTitle.TextSize = 13
moveTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
moveTitle.TextXAlignment = Enum.TextXAlignment.Left
moveTitle.ZIndex = 202; moveTitle.Parent = frames.move

makeToggleRow(frames.move, 30, "SPEED HACK", "Adjustable walkspeed", "Speed", function()
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = CONFIG.Speed and CONFIG.SpeedValue or OriginalSpeed end
end)

makeToggleRow(frames.move, 88, "JUMP POWER", "Adjustable jump", "Jump", function()
    local char = lp.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = CONFIG.Jump and CONFIG.JumpValue or OriginalJump
    end
end)

makeToggleRow(frames.move, 146, "NOCLIP", "Walk through walls", "Noclip", function()
    if noclipConn then noclipConn:Disconnect(); noclipConn = nil end
    if CONFIG.Noclip then
        noclipConn = RunService.Stepped:Connect(function()
            local char = lp.Character
            if not char then return end
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
            end
        end)
    end
end)

makeToggleRow(frames.move, 204, "FLY", "WASD + Space/Ctrl", "Fly", function()
    if flyConn then flyConn:Disconnect(); flyConn = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
    if CONFIG.Fly then
        local char = lp.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
        flyBV.Velocity = Vector3.zero
        flyBV.Parent = hrp
        flyBG = Instance.new("BodyGyro")
        flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
        flyBG.P = 1000; flyBG.D = 50
        flyBG.CFrame = hrp.CFrame
        flyBG.Parent = hrp
        flyConn = RunService.RenderStepped:Connect(function()
            if not CONFIG.Fly then return end
            local c = lp.Character
            if not c then return end
            local root = c:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local camCf = cam.CFrame
            local mv = Vector3.zero
            if UIS:IsKeyDown(Enum.KeyCode.W) then mv += camCf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then mv -= camCf.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then mv -= camCf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then mv += camCf.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then mv += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then mv -= Vector3.new(0,1,0) end
            if mv.Magnitude > 0 then mv = mv.Unit end
            flyBV.Velocity = mv * CONFIG.FlySpeed
            flyBG.CFrame = camCf
        end)
    end
end)

makeToggleRow(frames.move, 262, "INFINITE JUMP", "Jump repeatedly", "InfiniteJump", function()
    if infJumpConn then infJumpConn:Disconnect(); infJumpConn = nil end
    if CONFIG.InfiniteJump then
        infJumpConn = UIS.JumpRequest:Connect(function()
            if not CONFIG.InfiniteJump then return end
            local char = lp.Character
            if not char then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end)
    end
end)

-- ============ ABOUT ============
local aboutInfo = Instance.new("TextLabel")
aboutInfo.Size = UDim2.new(1, 0, 1, 0)
aboutInfo.BackgroundTransparency = 1
aboutInfo.Text = "◆ WXKDZ ULTRA v19 ◆\n\nVersion: 19.0.0\nPassword: WXKDZ2024\n\nFIX:\n• ESP naka-OFF by default na\n• Hindi na lalabas kahit hindi i-toggle\n• Check sa loob ng createESP\n• Check sa PlayerAdded\n\nCommands: $cc"
aboutInfo.Font = FONT_LABEL; aboutInfo.TextSize = 10
aboutInfo.TextColor3 = Color3.fromRGB(180, 180, 180)
aboutInfo.TextXAlignment = Enum.TextXAlignment.Left
aboutInfo.TextYAlignment = Enum.TextYAlignment.Top
aboutInfo.TextWrapped = true
aboutInfo.ZIndex = 202; aboutInfo.Parent = frames.about

-- Bottom buttons
local buttonBar = Instance.new("Frame")
buttonBar.Size = UDim2.new(1, -24, 0, 36); buttonBar.Position = UDim2.new(0, 12, 1, -46)
buttonBar.BackgroundTransparency = 1
buttonBar.ZIndex = 202; buttonBar.Parent = panel

local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(0, 120, 1, 0); execBtn.BackgroundColor3 = Color3.fromRGB(16,16,16)
execBtn.Text = "◆ EXECUTE ◆"; execBtn.Font = FONT_HERO; execBtn.TextSize = 11
execBtn.TextColor3 = Color3.fromRGB(255,255,255); execBtn.AutoButtonColor = false
execBtn.ZIndex = 203; execBtn.Parent = buttonBar
local ebCorner = Instance.new("UICorner"); ebCorner.CornerRadius = UDim.new(0,8); ebCorner.Parent = execBtn
local ebStroke = addNeonStroke(execBtn, Color3.fromRGB(80,80,80), 1.2)

execBtn.MouseEnter:Connect(function()
    playHover()
    TweenService:Create(execBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    TweenService:Create(ebStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 220, 60), Thickness = 2}):Play()
end)
execBtn.MouseLeave:Connect(function()
    TweenService:Create(execBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}):Play()
    TweenService:Create(ebStroke, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 80), Thickness = 1.2}):Play()
end)
execBtn.MouseButton1Click:Connect(function()
    playClick()
    local code = editorInput.Text
    if code and #code > 0 then
        local ok, err = pcall(function() loadstring(code)() end)
        if ok then logConsole("Executed OK", Color3.fromRGB(60,220,60))
        else logConsole("Error: " .. tostring(err), Color3.fromRGB(255,80,80)) end
    end
end)

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(0, 90, 1, 0); clearBtn.Position = UDim2.new(0, 130, 0, 0)
clearBtn.BackgroundColor3 = Color3.fromRGB(16,16,16)
clearBtn.Text = "◆ CLEAR ◆"; clearBtn.Font = FONT_HERO; clearBtn.TextSize = 11
clearBtn.TextColor3 = Color3.fromRGB(255,255,255); clearBtn.AutoButtonColor = false
clearBtn.ZIndex = 203; clearBtn.Parent = buttonBar
local cbC2 = Instance.new("UICorner"); cbC2.CornerRadius = UDim.new(0,8); cbC2.Parent = clearBtn
local cbStroke2 = addNeonStroke(clearBtn, Color3.fromRGB(80,80,80), 1.2)

clearBtn.MouseEnter:Connect(function()
    playHover()
    TweenService:Create(clearBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
    TweenService:Create(cbStroke2, TweenInfo.new(0.2), {Color = Color3.fromRGB(255, 180, 60), Thickness = 2}):Play()
end)
clearBtn.MouseLeave:Connect(function()
    TweenService:Create(clearBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(16, 16, 16)}):Play()
    TweenService:Create(cbStroke2, TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 80, 80), Thickness = 1.2}):Play()
end)
clearBtn.MouseButton1Click:Connect(function()
    playClick()
    editorInput.Text = ""
    logConsole("Cleared", Color3.fromRGB(180,180,180))
end)

-- ================================================================
-- ============ ESP 3D (FIXED — ONLY WHEN TOGGLED) ================
-- ================================================================
local function createESP(plr)
    -- FIX: huwag gumawa kung naka-OFF ang ESP
    if not CONFIG.ESP then return end
    if plr == lp then return end
    if espCache[plr] then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    local data = {}

    local hl = Instance.new("Highlight")
    hl.Name = "WXKDZ_ESP"
    hl.FillColor = CONFIG.ESPColor
    hl.OutlineColor = CONFIG.ESPColor
    hl.FillTransparency = 0.7
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = char
    hl.Parent = char
    data.hl = hl

    local bill = Instance.new("BillboardGui")
    bill.Name = "WXKDZ_Bill"
    bill.Size = UDim2.new(0, 200, 0, 60)
    bill.StudsOffset = Vector3.new(0, 3.5, 0)
    bill.AlwaysOnTop = true
    bill.LightInfluence = 0
    bill.Adornee = hrp
    bill.Parent = char
    data.bill = bill

    local nameLbl = Instance.new("TextLabel")
    nameLbl.Size = UDim2.new(1, 0, 0, 16)
    nameLbl.BackgroundTransparency = 1
    nameLbl.Text = plr.DisplayName .. " (@" .. plr.Name .. ")"
    nameLbl.Font = FONT_HERO; nameLbl.TextSize = 12
    nameLbl.TextColor3 = CONFIG.ESPColor
    nameLbl.TextStrokeTransparency = 0
    nameLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLbl.Parent = bill
    data.name = nameLbl

    local distLbl = Instance.new("TextLabel")
    distLbl.Size = UDim2.new(1, 0, 0, 14)
    distLbl.Position = UDim2.new(0, 0, 0, 16)
    distLbl.BackgroundTransparency = 1
    distLbl.Text = "0 studs"
    distLbl.Font = FONT_BOLD; distLbl.TextSize = 10
    distLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
    distLbl.TextStrokeTransparency = 0
    distLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    distLbl.Parent = bill
    data.dist = distLbl

    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0.8, 0, 0, 6)
    hpBg.Position = UDim2.new(0.1, 0, 0, 32)
    hpBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    hpBg.BorderSizePixel = 0
    hpBg.Parent = bill
    local hpBgCorner = Instance.new("UICorner"); hpBgCorner.CornerRadius = UDim.new(1, 0); hpBgCorner.Parent = hpBg

    local hpFill = Instance.new("Frame")
    hpFill.Size = UDim2.new(1, 0, 1, 0)
    hpFill.BackgroundColor3 = Color3.fromRGB(60, 220, 60)
    hpFill.BorderSizePixel = 0
    hpFill.Parent = hpBg
    local hpFillCorner = Instance.new("UICorner"); hpFillCorner.CornerRadius = UDim.new(1, 0); hpFillCorner.Parent = hpFill
    data.hpFill = hpFill

    local hpText = Instance.new("TextLabel")
    hpText.Size = UDim2.new(0.8, 0, 0, 12)
    hpText.Position = UDim2.new(0.1, 0, 0, 40)
    hpText.BackgroundTransparency = 1
    hpText.Text = "100 / 100"
    hpText.Font = FONT_BOLD; hpText.TextSize = 9
    hpText.TextColor3 = Color3.fromRGB(255, 255, 255)
    hpText.TextStrokeTransparency = 0
    hpText.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    hpText.Parent = bill
    data.hpText = hpText

    espCache[plr] = data
end

local function removeESP(plr)
    local data = espCache[plr]
    if not data then return end
    for _, obj in pairs(data) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espCache[plr] = nil
end

function refreshAllESP()
    -- Always clear first
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= lp then removeESP(plr) end
    end
    -- Only create if ESP is ON
    if CONFIG.ESP then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= lp then pcall(function() createESP(plr) end) end
        end
    end
end

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        task.wait(0.5)
        -- FIX: check muna kung naka-ON ang ESP
        if CONFIG.ESP then pcall(function() createESP(plr) end) end
    end)
end)
Players.PlayerRemoving:Connect(removeESP)

-- ESP update loop — check muna kung naka-ON
RunService.RenderStepped:Connect(function()
    if not UNLOCKED then return end
    if not CONFIG.ESP then
        -- Clear cache kung naka-OFF
        if next(espCache) then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp then removeESP(plr) end
            end
        end
        return
    end
    for plr, data in pairs(espCache) do
        local char = plr.Character
        if char and data.bill and data.hpFill then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hrp and hum then
                local dist = (hrp.Position - cam.CFrame.Position).Magnitude
                if data.dist then data.dist.Text = string.format("%d studs", math.floor(dist)) end
                local hp = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                data.hpFill.Size = UDim2.new(hp, 0, 1, 0)
                local col = Color3.fromRGB(60, 220, 60)
                if hp < 0.3 then col = Color3.fromRGB(255, 60, 60)
                elseif hp < 0.6 then col = Color3.fromRGB(255, 180, 60) end
                data.hpFill.BackgroundColor3 = col
                if data.hpText then data.hpText.Text = string.format("%d / %d", math.floor(hum.Health), math.floor(hum.MaxHealth)) end
                local show = dist < 1000
                if data.bill then data.bill.Enabled = show end
                if data.hl then data.hl.Enabled = show end
            end
        end
    end
end)

-- ============ BIGHEAD ============
local MAX_MULT = 5
local function getHeadMesh(head)
    local mesh = head:FindFirstChildOfClass("SpecialMesh")
    if not mesh then
        mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.Head
        mesh.Parent = head
    end
    return mesh
end

local function applyBighead(char, mult)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    mult = math.clamp(mult, 1, MAX_MULT)
    local mesh = getHeadMesh(head)
    if not originalMeshData[char] then
        originalMeshData[char] = {mesh = mesh, origScale = mesh.Scale}
    end
    pcall(function() mesh.Scale = Vector3.new(mult, mult, mult) end)
end

local function resetBighead(char)
    if not char then return end
    local data = originalMeshData[char]
    if not data then return end
    if data.mesh and data.mesh.Parent then
        pcall(function() data.mesh.Scale = data.origScale end)
    end
    originalMeshData[char] = nil
end

function updateBighead()
    if bigheadConn then bigheadConn:Disconnect(); bigheadConn = nil end
    if bigheadBypassConn then bigheadBypassConn:Disconnect(); bigheadBypassConn = nil end

    if not CONFIG.Bighead and not CONFIG.BigheadAllPlayers then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then resetBighead(plr.Character) end
        end
        return
    end

    bigheadConn = RunService.Heartbeat:Connect(function()
        if CONFIG.BigheadAllPlayers then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then applyBighead(plr.Character, CONFIG.BigheadSize) end
            end
            if not CONFIG.Bighead and lp.Character then resetBighead(lp.Character) end
        elseif CONFIG.Bighead then
            if lp.Character then applyBighead(lp.Character, CONFIG.BigheadSize) end
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= lp and plr.Character then resetBighead(plr.Character) end
            end
        end
    end)

    if CONFIG.BigheadBypass then
        bigheadBypassConn = RunService.Stepped:Connect(function()
            if CONFIG.BigheadAllPlayers then
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= lp and plr.Character then applyBighead(plr.Character, CONFIG.BigheadSize) end
                end
                if not CONFIG.Bighead and lp.Character then resetBighead(lp.Character) end
            elseif CONFIG.Bighead then
                if lp.Character then applyBighead(lp.Character, CONFIG.BigheadSize) end
                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= lp and plr.Character then resetBighead(plr.Character) end
                end
            end
        end)
    end
end

-- ============ RAPID FIRE / FULLBRIGHT / NOFOG / ANTIAFK ============
local function startRapidFire()
    if rapidFireConn then rapidFireConn:Disconnect(); rapidFireConn = nil end
    rapidFireConn = RunService.Heartbeat:Connect(function()
        if not CONFIG.RapidFire or not UNLOCKED then return end
        local char = lp.Character
        if not char then return end
        local tool = char:FindFirstChildOfClass("Tool")
        if not tool then return end
        pcall(function() tool:Activate() end)
    end)
end
startRapidFire()

local function applyFullbright()
    if CONFIG.Fullbright then
        originalAmbient = originalAmbient or Lighting.Ambient
        originalBrightness = originalBrightness or Lighting.Brightness
        originalOutdoor = originalOutdoor or Lighting.OutdoorAmbient
        Lighting.Ambient = Color3.fromRGB(255,255,255)
        Lighting.Brightness = 3
        Lighting.OutdoorAmbient = Color3.fromRGB(255,255,255)
        Lighting.GlobalShadows = false
    else
        if originalAmbient then Lighting.Ambient = originalAmbient end
        if originalBrightness then Lighting.Brightness = originalBrightness end
        if originalOutdoor then Lighting.OutdoorAmbient = originalOutdoor end
        Lighting.GlobalShadows = true
    end
end

local function applyNoFog()
    if CONFIG.NoFog then
        originalFogEnd = originalFogEnd or Lighting.FogEnd
        originalFogStart = originalFogStart or Lighting.FogStart
        Lighting.FogEnd = 100000
        Lighting.FogStart = 100000
    else
        if originalFogEnd then Lighting.FogEnd = originalFogEnd end
        if originalFogStart then Lighting.FogStart = originalFogStart end
    end
end

local function updateAntiAFK()
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
    if CONFIG.AntiAFK then
        antiAfkConn = lp.Idled:Connect(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end

local function rejoinServer()
    pcall(function()
        local TS = game:GetService("TeleportService")
        if game.JobId and #game.JobId > 0 then
            TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        else
            TS:Teleport(game.PlaceId, lp)
        end
    end)
end

-- ============ CUSTOM CHAT ============
local chatPanel = Instance.new("Frame")
chatPanel.Size = UDim2.new(0, 480, 0, 42)
chatPanel.Position = UDim2.new(0.5, -240, 1, -115)
chatPanel.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
chatPanel.BackgroundTransparency = 0.72
chatPanel.BorderSizePixel = 0
chatPanel.Visible = false
chatPanel.ZIndex = 250
chatPanel.Active = true
chatPanel.Parent = gui
local cpCorner = Instance.new("UICorner"); cpCorner.CornerRadius = UDim.new(0, 12); cpCorner.Parent = chatPanel
addNeonStroke(chatPanel, Color3.fromRGB(255,255,255), 1.5)

local chatInput = Instance.new("TextBox")
chatInput.Size = UDim2.new(1, -20, 1, -10); chatInput.Position = UDim2.new(0, 10, 0, 5)
chatInput.BackgroundTransparency = 1
chatInput.Text = ""
chatInput.PlaceholderText = "◆ Type command... (e.g. $esp)"
chatInput.Font = FONT_MONO; chatInput.TextSize = 12
chatInput.TextColor3 = Color3.fromRGB(255, 255, 255)
chatInput.PlaceholderColor3 = Color3.fromRGB(180, 180, 180)
chatInput.TextXAlignment = Enum.TextXAlignment.Left
chatInput.ClearTextOnFocus = false
chatInput.ZIndex = 253; chatInput.Parent = chatPanel

local function openChat()
    playOpen()
    chatPanel.Visible = true
    TweenService:Create(chatPanel, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -240, 1, -115),
        BackgroundTransparency = 0.72
    }):Play()
    task.wait(0.15)
    chatInput:CaptureFocus()
end

local function closeChat()
    TweenService:Create(chatPanel, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(0.5, -240, 1, -75),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.35)
    chatPanel.Visible = false
end

-- ============ COMMAND EXECUTOR ============
local function executeCommand(message)
    local lower = string.lower(message)
    if lower == "$on" then
        CONFIG.Enabled = true
        LastCameraType = cam.CameraType
        cam.CameraType = Enum.CameraType.Scriptable
        showNotification("Aim", "Aim Assist: ON", Color3.fromRGB(60,220,60))
    elseif lower == "$off" then
        CONFIG.Enabled = false
        CONFIG.SilentAim = false
        CurrentTarget = nil
        cam.CameraType = LastCameraType or Enum.CameraType.Custom
        if lp.Character then
            local hum = lp.Character:FindFirstChildOfClass("Humanoid")
            if hum then cam.CameraSubject = hum end
        end
        showNotification("Aim", "OFF", Color3.fromRGB(255,80,80))
    elseif lower == "$silentaim" then
        CONFIG.SilentAim = not CONFIG.SilentAim
        showNotification("Combat", "Silent Aim: " .. (CONFIG.SilentAim and "ON" or "OFF"), CONFIG.SilentAim and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$esp" then
        CONFIG.ESP = not CONFIG.ESP
        refreshAllESP()
        showNotification("Visual", "ESP: " .. (CONFIG.ESP and "ON" or "OFF"), CONFIG.ESP and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$rapidfire" then
        CONFIG.RapidFire = not CONFIG.RapidFire
        showNotification("Combat", "RF: " .. (CONFIG.RapidFire and "ON" or "OFF"), CONFIG.RapidFire and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$bighead" then
        CONFIG.Bighead = not CONFIG.Bighead
        updateBighead()
        showNotification("Fun", "Bighead SELF: " .. (CONFIG.Bighead and "ON" or "OFF"), CONFIG.Bighead and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$bigheadall" then
        CONFIG.BigheadAllPlayers = not CONFIG.BigheadAllPlayers
        updateBighead()
        showNotification("Fun", "Bighead OTHER: " .. (CONFIG.BigheadAllPlayers and "ON" or "OFF"), CONFIG.BigheadAllPlayers and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$fullbright" then
        CONFIG.Fullbright = not CONFIG.Fullbright; applyFullbright()
        showNotification("Visual", "Fullbright: " .. (CONFIG.Fullbright and "ON" or "OFF"), CONFIG.Fullbright and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$nofog" then
        CONFIG.NoFog = not CONFIG.NoFog; applyNoFog()
        showNotification("Visual", "NoFog: " .. (CONFIG.NoFog and "ON" or "OFF"), CONFIG.NoFog and Color3.fromRGB(60,220,60) or Color3.fromRGB(255,80,80))
    elseif lower == "$cc" then
        openChat()
    elseif lower == "$status" then
        showNotification("Status", "Aim: " .. (CONFIG.Enabled and "ON" or "OFF") .. " | ESP: " .. (CONFIG.ESP and "ON" or "OFF"), Color3.fromRGB(100,180,255))
    else
        showNotification("TBOT", "Unknown: " .. message, Color3.fromRGB(255,80,80))
    end
end

chatInput.FocusLost:Connect(function(enter)
    if enter then
        local msg = chatInput.Text
        chatInput.Text = ""
        if msg and #msg > 0 then executeCommand(msg) end
        task.delay(0.4, closeChat)
    end
end)

lp.Chatted:Connect(function(message)
    if not UNLOCKED then return end
    if string.lower(message) == "$cc" then openChat() else executeCommand(message) end
end)

-- ============ AIM LOGIC ============
local function screenDist(pos)
    local sp, onScreen = cam:WorldToViewportPoint(pos)
    if not onScreen then return math.huge end
    local center = Vector2.new(cam.ViewportSize.X/2, cam.ViewportSize.Y/2)
    return (Vector2.new(sp.X, sp.Y) - center).Magnitude
end

local function findBestTarget(fov)
    local best, bestDist = nil, fov
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == lp then continue end
        local char = plr.Character
        if not char then continue end
        local head = char:FindFirstChild("Head")
        if not head then continue end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then continue end
        local d = screenDist(head.Position)
        if d < bestDist then best = {plr = plr, part = head, char = char}; bestDist = d end
    end
    return best
end

RunService.RenderStepped:Connect(function()
    if not UNLOCKED then return end
    if not CONFIG.Enabled and not CONFIG.SilentAim then return end

    local fov = CONFIG.SilentAim and CONFIG.SilentAimFOV or CONFIG.FOV
    local speed = CONFIG.SilentAim and CONFIG.SilentAimSpeed or CONFIG.FollowSpeed

    if CurrentTarget then
        local char = CurrentTarget.char
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not char.Parent or not hum or hum.Health <= 0 then
            CurrentTarget = nil
            cam.CameraType = LastCameraType or Enum.CameraType.Custom
            if lp.Character then
                local myHum = lp.Character:FindFirstChildOfClass("Humanoid")
                if myHum then cam.CameraSubject = myHum end
            end
        end
    end

    if not CurrentTarget then
        CurrentTarget = findBestTarget(fov)
        if CurrentTarget then
            if cam.CameraType ~= Enum.CameraType.Scriptable then
                cam.CameraType = Enum.CameraType.Scriptable
            end
        end
    end

    if CurrentTarget and CurrentTarget.part and CurrentTarget.part.Parent then
        local camPos = cam.CFrame.Position
        local aimPos = CurrentTarget.part.Position + Vector3.new(0, CONFIG.OffsetY * 2, 0)
        local desired = CFrame.new(camPos, aimPos)
        cam.CFrame = cam.CFrame:Lerp(desired, speed)
    end
end)

lp.CharacterAdded:Connect(function()
    task.wait(0.5)
    if CONFIG.Enabled or CONFIG.SilentAim then
        LastCameraType = cam.CameraType
        cam.CameraType = Enum.CameraType.Scriptable
    end
    -- FIX: wag i-refresh kung naka-OFF
    if CONFIG.ESP then refreshAllESP() end
end)

showTab("script")
task.delay(2, function()
    showNotification("WXKDZ v19", "Type $cc for commands", Color3.fromRGB(100,180,255))
    openBtn.Visible = true
    openBtn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(openBtn, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 54, 0, 54)}):Play()
end)
