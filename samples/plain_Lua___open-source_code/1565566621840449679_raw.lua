local cloneref = cloneref or function(object) return object end
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local HttpService       = cloneref(game:GetService("HttpService"))
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
if getgenv and getgenv().StopAura then pcall(getgenv().StopAura) end

local CONFIG_FILE = "tigy_redeemer_config.json"
local savedConfig = {
    codeSniper = true,
    autoSubmit = true,
    submitAfter = 3,
    retypeInvalid = false,
    riddleSolver = false,
}
pcall(function()
    if type(isfile) == "function" and type(readfile) == "function"
    and isfile(CONFIG_FILE) then
        local decoded = HttpService:JSONDecode(readfile(CONFIG_FILE))
        if type(decoded) == "table" then
            if type(decoded.codeSniper) == "boolean" then savedConfig.codeSniper = decoded.codeSniper end
            if type(decoded.autoSubmit) == "boolean" then savedConfig.autoSubmit = decoded.autoSubmit end
            if type(decoded.submitAfter) == "number" then savedConfig.submitAfter = math.max(1, math.floor(decoded.submitAfter)) end
            if type(decoded.retypeInvalid) == "boolean" then savedConfig.retypeInvalid = decoded.retypeInvalid end
            if type(decoded.riddleSolver) == "boolean" then savedConfig.riddleSolver = decoded.riddleSolver end
        end
    end
end)
local function saveConfig()
    if type(writefile) ~= "function" then return end
    pcall(function()
        writefile(CONFIG_FILE, HttpService:JSONEncode({
            codeSniper = savedConfig.codeSniper,
            autoSubmit = savedConfig.autoSubmit,
            submitAfter = savedConfig.submitAfter,
            retypeInvalid = savedConfig.retypeInvalid,
            riddleSolver = savedConfig.riddleSolver,
        }))
    end)
end

-- STATE --
local _enabled              = savedConfig.codeSniper
local _seen                 = {}
local _focused              = nil
local _lastBox              = nil
local _autoAccept           = savedConfig.autoSubmit
local _submitAfter          = savedConfig.submitAfter
local _capturedParts        = {}
local _lastWatchedBox       = nil
local _boxTextConn          = nil
local _boxAncestryConn      = nil
local _boxVisibilityConns   = {}
local _retypeInvalid        = savedConfig.retypeInvalid
local _riddleSolver         = savedConfig.riddleSolver
local _lastNonBlankBoxText  = ""
local _pendingRejectedText  = nil
local _pendingRejectedBox   = nil
local _pendingRejectedUntil = 0
local _pendingRejectedToken = 0
local ACE_CASE_MODE         = "EXACT"
local ACE_WORD_COUNT        = 1
local KNOWN_CODE_BOX_PATH   = {"Codes", "Codes", "CodeRedeem", "TextBox"}

local setStatus, flashCode, appendToBox
local rememberPendingSubmission, clearPendingSubmission, handleRedemptionFeedback
local clearAceCapture
local _lastStatusMsg = nil

local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns = getconnections or (debug and debug.getconnections)
local setupv = (debug and debug.setupvalue) or setupvalue
local REDEEM_GUID = "7d14a912-1040-4867-b005-98838eb9acc4"
local RedeemRemote

local function aceCodeBox()
    local gui = playerGui:FindFirstChild("Codes")
    if not gui then return nil end
    local root = gui:FindFirstChild("Codes") or gui
    local redeem = root:FindFirstChild("CodeRedeem")
    local box = redeem and redeem:FindFirstChild("TextBox")
    if box and box:IsA("TextBox") then return box end
    for _, obj in ipairs(gui:GetDescendants()) do
        if obj:IsA("TextBox") then return obj end
    end
end

local function resolveAceRedeemRemote()
    if RedeemRemote and RedeemRemote.Parent then return RedeemRemote end
    local ok, api = pcall(require, Net)
    if ok and type(api) == "table" then
        local rok, rf = pcall(function() return api:RemoteFunction(REDEEM_GUID) end)
        if rok and typeof(rf) == "Instance" then RedeemRemote = rf end
    end
    return RedeemRemote
end

local function killAceDebounce(fn)
    if not (fn and setupv and getupvalues) then return end
    local ok, ups = pcall(getupvalues, fn)
    if ok and type(ups) == "table" then
        for i, v in pairs(ups) do if type(v) == "boolean" then pcall(setupv, fn, i, false) end end
    end
end

local function aceRedeemViaBox(code)
    if not getconns then return false, "no getconnections" end
    local box = aceCodeBox()
    if not box then return false, "no codebox" end
    local ok, conns = pcall(getconns, box.FocusLost)
    if not ok or type(conns) ~= "table" or #conns == 0 then return false, "no connection" end
    local fired = false
    for _, c in ipairs(conns) do
        local fn; pcall(function() fn = c.Function end)
        killAceDebounce(fn)
        box.Text = code; box.Active = true; box.Selectable = true
        local fok = pcall(function() if c.Enabled ~= false then c:Fire(true) end end)
        fired = fired or fok
    end
    return fired, fired and "sent" or "fire failed"
end

local function aceRedeemViaRemote(code)
    local rf = resolveAceRedeemRemote()
    if not rf then return false, "no remote" end
    local ok, result = pcall(function() return rf:InvokeServer(code) end)
    if not ok then return false, tostring(result) end
    return true, result
end

local function aceRedeem(code)
    local ok, res = aceRedeemViaBox(code)
    if ok then return true, res end
    if getconns then return false, res end
    return aceRedeemViaRemote(code)
end

-- ============================================================
-- TIGY LIGHT-BLUE PALETTE
-- ============================================================
local C = {
    bg         = Color3.fromRGB(180, 214, 238),
    bgHeader   = Color3.fromRGB(180, 214, 238),
    tabBarBg   = Color3.fromRGB(214, 232, 246),
    tabActive  = Color3.fromRGB(59, 111, 189),
    tabIdleTxt = Color3.fromRGB(122, 145, 168),
    tabActiveTxt = Color3.fromRGB(255, 255, 255),
    text       = Color3.fromRGB(58, 78, 100),
    textDark   = Color3.fromRGB(30, 48, 70),
    dim        = Color3.fromRGB(140, 160, 180),
    toggleOff  = Color3.fromRGB(210, 222, 233),
    toggleOn   = Color3.fromRGB(59, 111, 189),
    knob       = Color3.fromRGB(255, 255, 255),
    pillBg     = Color3.fromRGB(184, 214, 240),
    pillText   = Color3.fromRGB(52, 94, 158),
    consoleBg  = Color3.fromRGB(236, 245, 253),
    consoleTxt = Color3.fromRGB(80, 100, 120),
    consoleHdr = Color3.fromRGB(214, 232, 246),
    divider    = Color3.fromRGB(168, 195, 218),
    closeBg    = Color3.fromRGB(214, 232, 246),
    closeTxt   = Color3.fromRGB(100, 125, 150),
    logoBlue   = Color3.fromRGB(59, 111, 189),
    shadow     = Color3.fromRGB(120, 155, 190),
    dotRed     = Color3.fromRGB(255, 160, 155),
    dotYellow  = Color3.fromRGB(250, 212, 130),
    dotGreen   = Color3.fromRGB(160, 220, 165),
    logTime    = Color3.fromRGB(150, 170, 190),
    logText    = Color3.fromRGB(90, 110, 130),
}

local function addCorner(parent, radius)
    local value = Instance.new("UICorner")
    value.CornerRadius = UDim.new(0, radius)
    value.Parent = parent
    return value
end
local function addStroke(parent, color, thickness, transparency)
    local value = Instance.new("UIStroke")
    value.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    value.Color = color
    value.Thickness = thickness or 1
    value.Transparency = transparency or 0
    value.Parent = parent
    return value
end
local function makeLabel(parent, name, text, size, position, textSize, color, font)
    local label = Instance.new("TextLabel")
    label.Name = name
    label.Size = size
    label.Position = position
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextSize = textSize
    label.TextColor3 = color
    label.Font = font or Enum.Font.GothamMedium
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.Parent = parent
    return label
end

-- CLEANUP OLD
pcall(function()
    for _, name in ipairs({"TigyRedeemerUI", "ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
        local prev = game.CoreGui:FindFirstChild(name)
        if prev then prev:Destroy() end
    end
end)
for _, name in ipairs({"TigyRedeemerUI", "ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
    local prev = playerGui:FindFirstChild(name)
    if prev then prev:Destroy() end
end

-- ============================================================
-- WINDOW
-- ============================================================
local WINDOW_W = 290
local WINDOW_H = 360
local HEADER_H = 52
local TABBAR_Y = 60
local TABBAR_H = 34
local CONTENT_Y = TABBAR_Y + TABBAR_H + 8

local GUI = Instance.new("ScreenGui")
GUI.Name = "TigyRedeemerUI"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
if not pcall(function() GUI.Parent = game.CoreGui end) then GUI.Parent = playerGui end

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(WINDOW_W, WINDOW_H)
Window.Position = UDim2.new(1, -WINDOW_W - 8, 0, 8)
Window.BackgroundColor3 = C.bg
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI
addCorner(Window, 12)

-- subtle shadow / border
local WindowStroke = addStroke(Window, Color3.fromRGB(140, 175, 205), 1, 0.55)

local InterfaceScale = Instance.new("UIScale")
InterfaceScale.Name = "InterfaceScale"
InterfaceScale.Scale = 0.92
InterfaceScale.Parent = Window

local viewportConnection
local function updateInterfaceScale()
    local camera = workspace.CurrentCamera
    if not camera then InterfaceScale.Scale = 0.92; return end
    local viewport = camera.ViewportSize
    local fitScale = math.min((viewport.X - 16) / WINDOW_W, (viewport.Y - 16) / WINDOW_H)
    if UserInputService.TouchEnabled then
        InterfaceScale.Scale = math.max(0.5, math.min(0.8, fitScale))
    else
        InterfaceScale.Scale = math.min(0.92, fitScale)
    end
end
local function watchViewport()
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
    local camera = workspace.CurrentCamera
    if camera then
        viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateInterfaceScale)
    end
    updateInterfaceScale()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
watchViewport()

-- ============================================================
-- HEADER
-- ============================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, HEADER_H)
Header.BackgroundTransparency = 1
Header.Active = true
Header.ZIndex = 3
Header.Parent = Window

-- T logo circle
local Logo = Instance.new("Frame")
Logo.Name = "Logo"
Logo.Size = UDim2.fromOffset(28, 28)
Logo.Position = UDim2.fromOffset(16, 12)
Logo.BackgroundColor3 = C.logoBlue
Logo.BorderSizePixel = 0
Logo.ZIndex = 4
Logo.Parent = Header
addCorner(Logo, 14)

local LogoText = makeLabel(Logo, "LogoText", "T",
    UDim2.fromScale(1, 1), UDim2.fromScale(0, 0), 16, Color3.fromRGB(255, 255, 255), Enum.Font.GothamBlack)
LogoText.TextXAlignment = Enum.TextXAlignment.Center
LogoText.ZIndex = 5

-- Title
local Title = makeLabel(Header, "Title", "Tigy's Redeemer",
    UDim2.new(1, -90, 0, 30), UDim2.fromOffset(52, 11), 16, C.textDark, Enum.Font.GothamBold)
Title.ZIndex = 4

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.fromOffset(26, 26)
CloseBtn.Position = UDim2.new(1, -36, 0, 13)
CloseBtn.BackgroundColor3 = C.closeBg
CloseBtn.BorderSizePixel = 0
CloseBtn.AutoButtonColor = false
CloseBtn.Text = "×"
CloseBtn.TextSize = 18
CloseBtn.TextColor3 = C.closeTxt
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 5
CloseBtn.Parent = Header
addCorner(CloseBtn, 6)
addStroke(CloseBtn, C.shadow, 1, 0.7)

CloseBtn.MouseButton1Click:Connect(function()
    if GUI then GUI:Destroy() end
end)
if UserInputService.TouchEnabled then
    CloseBtn.Activated:Connect(function()
        if GUI then GUI:Destroy() end
    end)
end

-- ============================================================
-- TAB BAR (pill container)
-- ============================================================
local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -24, 0, TABBAR_H)
TabBar.Position = UDim2.fromOffset(12, TABBAR_Y)
TabBar.BackgroundColor3 = C.tabBarBg
TabBar.BorderSizePixel = 0
TabBar.ZIndex = 3
TabBar.Parent = Window
addCorner(TabBar, TABBAR_H / 2)
addStroke(TabBar, Color3.fromRGB(180, 205, 228), 1, 0.4)

local tabDefs = {
    { key = "REDEEMER", label = "REDEEMER" },
    { key = "RIDDLE",   label = "RIDDLE" },
    { key = "LOGS",     label = "LOGS" },
}
local tabButtons = {}
local activeTab = "REDEEMER"
local _setTabContent

local function setActiveTab(name)
    activeTab = name
    for _, t in ipairs(tabButtons) do
        if t.key == name then
            t.btn.BackgroundColor3 = C.tabActive
            t.label.TextColor3 = C.tabActiveTxt
            t.label.Font = Enum.Font.GothamBold
        else
            t.btn.BackgroundColor3 = C.tabBarBg
            t.label.TextColor3 = C.tabIdleTxt
            t.label.Font = Enum.Font.GothamBold
        end
    end
    if _setTabContent then _setTabContent(name) end
end

local TAB_COUNT = #tabDefs
for i, def in ipairs(tabDefs) do
    local btn = Instance.new("TextButton")
    btn.Name = "Tab_" .. def.key
    btn.Size = UDim2.new(1 / TAB_COUNT, -6, 1, -6)
    btn.Position = UDim2.new((i - 1) / TAB_COUNT, 3, 0, 3)
    btn.BackgroundColor3 = C.tabBarBg
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 4
    btn.Parent = TabBar
    addCorner(btn, (TABBAR_H - 6) / 2)

    local label = makeLabel(btn, "Label", def.label,
        UDim2.fromScale(1, 1), UDim2.fromScale(0, 0), 11, C.tabIdleTxt, Enum.Font.GothamBold)
    label.TextXAlignment = Enum.TextXAlignment.Center
    label.ZIndex = 5

    btn.MouseButton1Click:Connect(function() setActiveTab(def.key) end)
    if UserInputService.TouchEnabled then
        btn.Activated:Connect(function() setActiveTab(def.key) end)
    end

    tabButtons[#tabButtons + 1] = { key = def.key, btn = btn, label = label }
end

-- ============================================================
-- CONTENT PAGES
-- ============================================================
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, 0, 1, -CONTENT_Y)
Content.Position = UDim2.fromOffset(0, CONTENT_Y)
Content.BackgroundTransparency = 1
Content.ZIndex = 2
Content.Parent = Window

local function makePage(name)
    local p = Instance.new("Frame")
    p.Name = "Page_" .. name
    p.Size = UDim2.fromScale(1, 1)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.ZIndex = 3
    p.Parent = Content
    return p
end

local RedeemerPage = makePage("REDEEMER")
local RiddlePage   = makePage("RIDDLE")
local LogsPage     = makePage("LOGS")

_setTabContent = function(name)
    RedeemerPage.Visible = (name == "REDEEMER")
    RiddlePage.Visible   = (name == "RIDDLE")
    LogsPage.Visible     = (name == "LOGS")
end

-- ============================================================
-- TOGGLE + ROW BUILDERS
-- ============================================================
local function makeToggle(parent, state, onToggle)
    local track = Instance.new("Frame")
    track.Name = "Track"
    track.Size = UDim2.fromOffset(46, 24)
    track.Position = UDim2.new(1, -58, 0.5, -12)
    track.BackgroundColor3 = state and C.toggleOn or C.toggleOff
    track.BorderSizePixel = 0
    track.ZIndex = 5
    track.Parent = parent
    addCorner(track, 12)

    local knob = Instance.new("Frame")
    knob.Name = "Knob"
    knob.Size = UDim2.fromOffset(20, 20)
    knob.Position = state and UDim2.new(1, -22, 0.5, -10) or UDim2.fromOffset(2, 2)
    knob.BackgroundColor3 = C.knob
    knob.BorderSizePixel = 0
    knob.ZIndex = 6
    knob.Parent = track
    addCorner(knob, 10)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.fromScale(1, 1)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 7
    btn.Parent = track

    local current = state
    local function fire()
        current = not current
        track.BackgroundColor3 = current and C.toggleOn or C.toggleOff
        knob.Position = current and UDim2.new(1, -22, 0.5, -10) or UDim2.fromOffset(2, 2)
        if onToggle then onToggle(current) end
    end
    btn.MouseButton1Click:Connect(fire)
    if UserInputService.TouchEnabled then
        btn.Activated:Connect(fire)
    end
    return track, knob
end

local function makeDivider(parent, yOffset)
    local d = Instance.new("Frame")
    d.Size = UDim2.new(1, -32, 0, 1)
    d.Position = UDim2.fromOffset(16, yOffset)
    d.BackgroundColor3 = C.divider
    d.BorderSizePixel = 0
    d.BackgroundTransparency = 0.35
    d.ZIndex = 4
    d.Parent = parent
    return d
end

-- "Redeemer" row with counter pill
local function makeRedeemerRow(parent, yOffset)
    local row = Instance.new("Frame")
    row.Name = "RedeemerRow"
    row.Size = UDim2.new(1, 0, 0, 44)
    row.Position = UDim2.fromOffset(0, yOffset)
    row.BackgroundTransparency = 1
    row.ZIndex = 4
    row.Parent = parent

    local label = makeLabel(row, "Label", "Redeemer",
        UDim2.new(1, -160, 1, 0), UDim2.fromOffset(24, 0), 14, C.text, Enum.Font.GothamBold)
    label.ZIndex = 5

    -- counter pill "0/3"
    local pill = Instance.new("Frame")
    pill.Name = "CounterPill"
    pill.Size = UDim2.fromOffset(42, 22)
    pill.Position = UDim2.new(1, -112, 0.5, -11)
    pill.BackgroundColor3 = C.pillBg
    pill.BorderSizePixel = 0
    pill.ZIndex = 5
    pill.Parent = row
    addCorner(pill, 11)

    local pillTxt = makeLabel(pill, "PillText", "0/" .. tostring(_submitAfter),
        UDim2.fromScale(1, 1), UDim2.fromScale(0, 0), 11, C.pillText, Enum.Font.GothamBold)
    pillTxt.TextXAlignment = Enum.TextXAlignment.Center
    pillTxt.ZIndex = 6

    local toggleTrack = makeToggle(row, _autoAccept, function(state)
        _autoAccept = state
        savedConfig.autoSubmit = state
        saveConfig()
    end)

    -- update pill text on demand
    local function refreshPill()
        pillTxt.Text = tostring(#_capturedParts) .. "/" .. tostring(_submitAfter)
    end
    refreshPill()
    -- update on state changes via heartbeat (cheap)
    task.spawn(function()
        local last = ""
        while pill and pill.Parent do
            task.wait(0.15)
            local cur = tostring(#_capturedParts) .. "/" .. tostring(_submitAfter)
            if cur ~= last then
                last = cur
                pillTxt.Text = cur
            end
        end
    end)

    -- clicking the pill cycles submit-after 1..10 and back
    local pillBtn = Instance.new("TextButton")
    pillBtn.Size = UDim2.fromScale(1, 1)
    pillBtn.BackgroundTransparency = 1
    pillBtn.Text = ""
    pillBtn.ZIndex = 7
    pillBtn.Parent = pill
    local function cycleSubmit()
        _submitAfter = _submitAfter + 1
        if _submitAfter > 10 then _submitAfter = 1 end
        savedConfig.submitAfter = _submitAfter
        saveConfig()
        refreshPill()
        if clearAceCapture then clearAceCapture() end
    end
    pillBtn.MouseButton1Click:Connect(cycleSubmit)
    if UserInputService.TouchEnabled then
        pillBtn.Activated:Connect(cycleSubmit)
    end

    return row, pillTxt
end

local function makeSimpleRow(parent, yOffset, labelText, initialState, onToggle, labelWrap)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.Position = UDim2.fromOffset(0, yOffset)
    row.BackgroundTransparency = 1
    row.ZIndex = 4
    row.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -100, 1, 0)
    label.Position = UDim2.fromOffset(24, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextSize = 14
    label.TextColor3 = C.text
    label.Font = Enum.Font.GothamBold
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Center
    label.TextWrapped = true
    label.ZIndex = 5
    label.Parent = row

    makeToggle(row, initialState, onToggle)
    return row
end

-- ============================================================
-- REDEEMER PAGE
-- ============================================================
do
    makeRedeemerRow(RedeemerPage, 12)
    makeDivider(RedeemerPage, 62)
    makeSimpleRow(RedeemerPage, 74, "Auto Start Code On\nAnnc", _enabled, function(state)
        _enabled = state
        savedConfig.codeSniper = state
        saveConfig()
    end)
    makeDivider(RedeemerPage, 124)
end

-- ============================================================
-- RIDDLE PAGE
-- ============================================================
do
    makeSimpleRow(RiddlePage, 12, "Riddle Solver", _riddleSolver, function(state)
        _riddleSolver = state
        savedConfig.riddleSolver = state
        saveConfig()
    end)
    makeDivider(RiddlePage, 62)
end

-- ============================================================
-- LOGS PAGE (console panel with traffic-light dots)
-- ============================================================
local LogPanel = Instance.new("Frame")
LogPanel.Name = "LogPanel"
LogPanel.Size = UDim2.new(1, -24, 1, -20)
LogPanel.Position = UDim2.fromOffset(12, 10)
LogPanel.BackgroundColor3 = C.consoleBg
LogPanel.BorderSizePixel = 0
LogPanel.ClipsDescendants = true
LogPanel.ZIndex = 4
LogPanel.Parent = LogsPage
addCorner(LogPanel, 8)
addStroke(LogPanel, C.divider, 1, 0.35)

-- dots + "console" label header strip
local LogHeader = Instance.new("Frame")
LogHeader.Name = "Header"
LogHeader.Size = UDim2.new(1, 0, 0, 26)
LogHeader.BackgroundColor3 = C.consoleHdr
LogHeader.BorderSizePixel = 0
LogHeader.ZIndex = 5
LogHeader.Parent = LogPanel

local function makeDot(xOffset, col)
    local d = Instance.new("Frame")
    d.Size = UDim2.fromOffset(9, 9)
    d.Position = UDim2.fromOffset(xOffset, 9)
    d.BackgroundColor3 = col
    d.BorderSizePixel = 0
    d.ZIndex = 6
    d.Parent = LogHeader
    addCorner(d, 5)
    return d
end
makeDot(10, C.dotRed)
makeDot(24, C.dotYellow)
makeDot(38, C.dotGreen)

local HeaderLabel = makeLabel(LogHeader, "Label", "console",
    UDim2.new(1, -70, 1, 0), UDim2.new(0, 0, 0, 0), 11, C.dim, Enum.Font.GothamMedium)
HeaderLabel.TextXAlignment = Enum.TextXAlignment.Right
HeaderLabel.Position = UDim2.new(1, -50, 0, 0)
HeaderLabel.Size = UDim2.fromOffset(40, 26)
HeaderLabel.ZIndex = 6

-- scrolling console body
local LogScroll = Instance.new("ScrollingFrame")
LogScroll.Name = "LogScroll"
LogScroll.Size = UDim2.new(1, 0, 1, -26)
LogScroll.Position = UDim2.fromOffset(0, 26)
LogScroll.BackgroundTransparency = 1
LogScroll.BorderSizePixel = 0
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
LogScroll.ScrollBarThickness = 4
LogScroll.ScrollBarImageColor3 = C.dim
LogScroll.ScrollingDirection = Enum.ScrollingDirection.Y
LogScroll.ZIndex = 5
LogScroll.Parent = LogPanel

local LogOutput = Instance.new("TextLabel")
LogOutput.Name = "LogOutput"
LogOutput.Size = UDim2.new(1, -20, 0, 0)
LogOutput.Position = UDim2.fromOffset(10, 8)
LogOutput.AutomaticSize = Enum.AutomaticSize.Y
LogOutput.BackgroundTransparency = 1
LogOutput.RichText = true
LogOutput.Text = ""
LogOutput.TextSize = 13
LogOutput.Font = Enum.Font.Code
LogOutput.TextColor3 = C.consoleTxt
LogOutput.TextXAlignment = Enum.TextXAlignment.Left
LogOutput.TextYAlignment = Enum.TextYAlignment.Top
LogOutput.TextWrapped = true
LogOutput.ZIndex = 6
LogOutput.Parent = LogScroll

local BOTTOM_PAD = 16
local function updateLogCanvas()
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogOutput.AbsoluteSize.Y + BOTTOM_PAD + 8)
end
LogOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLogCanvas)
task.defer(updateLogCanvas)

local function scrollLogBottom()
    task.defer(function()
        task.wait()
        updateLogCanvas()
        local bottom = math.max(0, LogScroll.AbsoluteCanvasSize.Y - LogScroll.AbsoluteWindowSize.Y)
        LogScroll.CanvasPosition = Vector2.new(0, bottom)
    end)
end

local function timestamp()
    local t = os.date("*t")
    return string.format("[%02d:%02d:%02d]", t.hour or 0, t.min or 0, t.sec or 0)
end

local function esc(s)
    s = tostring(s or "")
    s = s:gsub("&", "&amp;")
    s = s:gsub("<", "&lt;")
    s = s:gsub(">", "&gt;")
    return s
end

local function logLine(msg, col)
    if not LogOutput then return end
    local timeStr = '<font color="rgb(150,170,190)">' .. timestamp() .. '</font>'
    local body = esc(msg)
    if col then
        local r = math.floor(col.R * 255 + 0.5)
        local g = math.floor(col.G * 255 + 0.5)
        local b = math.floor(col.B * 255 + 0.5)
        body = string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, body)
    end
    local line = timeStr .. " " .. body
    if LogOutput.Text == "" then
        LogOutput.Text = line
    else
        LogOutput.Text = LogOutput.Text .. "\n" .. line
    end
    scrollLogBottom()
end

-- match original signatures
function setStatus(msg, col)
    if not _enabled then return end
    if msg == _lastStatusMsg then return end
    _lastStatusMsg = msg
    logLine(tostring(msg), col or C.consoleTxt)
end

function flashCode(code, col)
    if not code or code == "" then return end
    logLine("[code] " .. tostring(code), col or C.textDark)
end

logLine("Tigy's Redeemer Loaded!", C.textDark)
logLine("This Console Will Contain Global Messages, Codes Redeemed, And More.", C.dim)

-- ============================================================
-- WINDOW DRAG
-- ============================================================
do
    local dragging = false
    local activeDragInput, dragStart, startPosition, dragMoved = nil, nil, nil, false
    local DRAG_THRESHOLD = UserInputService.TouchEnabled and 10 or 3

    local function isOverCloseBtn(pos)
        local p = CloseBtn.AbsolutePosition
        local s = CloseBtn.AbsoluteSize
        return pos.X >= p.X - 6 and pos.X <= p.X + s.X + 6
            and pos.Y >= p.Y - 6 and pos.Y <= p.Y + s.Y + 6
    end

    local function stopDragging(input)
        if input ~= activeDragInput then return end
        dragging = false; activeDragInput = nil; dragStart = nil; startPosition = nil
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
        and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging or isOverCloseBtn(input.Position) then return end
        dragging = true
        activeDragInput = input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPosition = Window.Position
        dragMoved = false
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End
            or input.UserInputState == Enum.UserInputState.Cancel then
                stopDragging(input)
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not activeDragInput then return end
        local isTouch = activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput
        local isMouse = activeDragInput.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        if not isTouch and not isMouse then return end
        local current = Vector2.new(input.Position.X, input.Position.Y)
        local delta = current - dragStart
        if not dragMoved then
            if delta.Magnitude < DRAG_THRESHOLD then return end
            dragMoved = true
        end
        Window.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end)
end

-- ============================================================
-- BOX WATCHERS / PENDING SUBMISSION
-- ============================================================
local function resetPasteCounter() _capturedParts = {} end
clearAceCapture = function() _capturedParts = {} end

local function clearBoxWatchers()
    if _boxTextConn then pcall(function() _boxTextConn:Disconnect() end) end
    if _boxAncestryConn then pcall(function() _boxAncestryConn:Disconnect() end) end
    for _, connection in ipairs(_boxVisibilityConns) do pcall(function() connection:Disconnect() end) end
    _boxTextConn = nil
    _boxAncestryConn = nil
    _boxVisibilityConns = {}
    _lastWatchedBox = nil
end

local function isBoxStillOpen(box)
    if not box or not box.Parent then return false end
    local current = box
    while current do
        if current:IsA("GuiObject") and current.Visible == false then return false end
        if current:IsA("ScreenGui") and current.Enabled == false then return false end
        current = current.Parent
    end
    return true
end

local function resolveCodeBox()
    local node = playerGui
    for _, name in ipairs(KNOWN_CODE_BOX_PATH) do
        if not node then break end
        node = node:FindFirstChild(name)
    end
    if node and node:IsA("TextBox") and isBoxStillOpen(node) then return node end
    if isBoxStillOpen(_focused) then return _focused end
    if isBoxStillOpen(_lastBox) then return _lastBox end
    return nil
end

local function watchBoxForBlankReset(box)
    if not box or _lastWatchedBox == box then return end
    clearBoxWatchers()
    _lastWatchedBox = box
    if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
    _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
        if box.Text == "" then
            resetPasteCounter()
        else
            _lastNonBlankBoxText = box.Text
        end
    end)
    _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
        if not parent then resetPasteCounter(); clearBoxWatchers() end
    end)
    local current = box
    while current do
        if current:IsA("GuiObject") then
            table.insert(_boxVisibilityConns, current:GetPropertyChangedSignal("Visible"):Connect(function()
                if not isBoxStillOpen(box) then resetPasteCounter(); clearBoxWatchers() end
            end))
        elseif current:IsA("ScreenGui") then
            table.insert(_boxVisibilityConns, current:GetPropertyChangedSignal("Enabled"):Connect(function()
                if not isBoxStillOpen(box) then resetPasteCounter(); clearBoxWatchers() end
            end))
        end
        current = current.Parent
    end
end

UserInputService.TextBoxFocused:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    if box ~= aceCodeBox() then return end
    _focused = box
    _lastBox = box
    watchBoxForBlankReset(box)
    if _enabled then setStatus("Ready", C.textDark) end
end)

UserInputService.TextBoxFocusReleased:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    local codeBox = aceCodeBox()
    if box ~= codeBox and box ~= _lastBox then return end
    if _retypeInvalid and rememberPendingSubmission and (box == codeBox or box == _lastBox) then
        local submittedText = box.Text ~= "" and box.Text or _lastNonBlankBoxText
        rememberPendingSubmission(box, submittedText, false)
    end
    if _focused == box then _focused = nil end
end)

clearPendingSubmission = function()
    _pendingRejectedToken += 1
    _pendingRejectedText = nil
    _pendingRejectedBox = nil
    _pendingRejectedUntil = 0
end

rememberPendingSubmission = function(box, text, replaceExisting)
    if not _retypeInvalid or not text or text == "" then return end
    if not replaceExisting and _pendingRejectedText and os.clock() <= _pendingRejectedUntil then return end
    _pendingRejectedToken += 1
    local token = _pendingRejectedToken
    _pendingRejectedText = text
    _pendingRejectedBox = box
    _pendingRejectedUntil = os.clock() + 8
    task.delay(8, function()
        if token == _pendingRejectedToken then clearPendingSubmission() end
    end)
end

local function restoreRejectedText(box, previousText)
    if not _retypeInvalid or not previousText or previousText == "" then return false end
    RunService.Heartbeat:Wait()
    local repasteBox = resolveCodeBox() or box
    if not repasteBox or not isBoxStillOpen(repasteBox) then return false end
    local restored = pcall(function() repasteBox.Text = previousText end)
    if restored then
        _lastBox = repasteBox
        watchBoxForBlankReset(repasteBox)
    end
    return restored
end

handleRedemptionFeedback = function(text, feedbackObject)
    if not _retypeInvalid or not _pendingRejectedText then return end
    if os.clock() > _pendingRejectedUntil then clearPendingSubmission(); return end
    if feedbackObject and feedbackObject:IsDescendantOf(GUI) then return end
    local lower = tostring(text or ""):lower()
    local rejected = lower:find("invalid code", 1, true)
        or lower:find("code is invalid", 1, true)
        or lower:find("expired", 1, true)
        or lower:find("already redeemed", 1, true)
        or lower:find("already used", 1, true)
        or lower:find("doesn't exist", 1, true)
        or lower:find("does not exist", 1, true)
        or lower:find("not found", 1, true)
        or lower:find("rejected", 1, true)
    if not rejected then return end
    local previousText = _pendingRejectedText
    local previousBox = _pendingRejectedBox
    local restored = restoreRejectedText(previousBox, previousText)
    clearPendingSubmission()
    if restored then
        setStatus("Invalid - repasted: " .. previousText, C.textDark)
        flashCode(previousText, Color3.fromRGB(210, 100, 100))
    end
end

function appendToBox(text)
    if not text or text == "" then return end
    if _lastWatchedBox and not isBoxStillOpen(_lastWatchedBox) then
        resetPasteCounter(); clearBoxWatchers()
    end
    local box = aceCodeBox()
    _capturedParts[#_capturedParts + 1] = text
    local combinedCode = table.concat(_capturedParts)
    local capturedCount = #_capturedParts
    if box then
        _lastBox = box
        watchBoxForBlankReset(box)
        local boxWasFocused = UserInputService:GetFocusedTextBox() == box
        box.Text = combinedCode
        if boxWasFocused then
            pcall(function()
                local caretEnd = #combinedCode + 1
                box.CursorPosition = caretEnd
                box.SelectionStart = caretEnd
            end)
        end
    else
        setStatus("Captured; code box is closed", C.text)
    end
    setStatus("Pasted " .. tostring(capturedCount) .. "/" .. tostring(_submitAfter), C.textDark)
    flashCode(combinedCode, C.textDark)
    if capturedCount >= _submitAfter then
        _capturedParts = {}
        if _autoAccept then
            rememberPendingSubmission(box, combinedCode, true)
            local ok, res = aceRedeem(combinedCode)
            local success = ok and (type(res) ~= "table" or res.success or res.Success)
            if success then
                setStatus("Redeemed: " .. combinedCode, Color3.fromRGB(70, 150, 90))
                logLine("Code redeemed: " .. combinedCode, Color3.fromRGB(70, 150, 90))
            else
                local restored = restoreRejectedText(box, combinedCode)
                clearPendingSubmission()
                if restored then
                    setStatus("Invalid - repasted: " .. combinedCode, C.textDark)
                    flashCode(combinedCode, Color3.fromRGB(210, 100, 100))
                else
                    setStatus("Invalid / cooldown", Color3.fromRGB(210, 100, 100))
                end
            end
        end
    end
end

-- watch feedback objects
local function watchRedemptionFeedbackObject(obj)
    if not (obj:IsA("TextLabel") or obj:IsA("TextButton")) then return end
    handleRedemptionFeedback(obj.Text or "", obj)
    obj:GetPropertyChangedSignal("Text"):Connect(function()
        handleRedemptionFeedback(obj.Text or "", obj)
    end)
end
for _, obj in ipairs(playerGui:GetDescendants()) do watchRedemptionFeedbackObject(obj) end
playerGui.DescendantAdded:Connect(function(obj)
    task.wait(0.04)
    watchRedemptionFeedbackObject(obj)
end)

-- ============================================================
-- NOTIFICATION LISTENER
-- ============================================================
local function aceRemotesFromFunction(fn)
    if not getupvalues then return {} end
    local ok, values = pcall(getupvalues, fn)
    local remotes = {}
    if ok and type(values) == "table" then
        for _, value in pairs(values) do
            if typeof(value) == "Instance"
            and (value:IsA("RemoteEvent") or value:IsA("RemoteFunction") or value:IsA("UnreliableRemoteEvent"))
            and value.Parent == Net then
                table.insert(remotes, value)
            end
        end
    end
    return remotes
end

local function resolveAceNotifyRemote()
    local ok, controller = pcall(function()
        return require(ReplicatedStorage.Controllers:FindFirstChild("NotificationController", true))
    end)
    if ok and type(controller) == "table" and type(controller.Start) == "function" then
        return aceRemotesFromFunction(controller.Start)[1]
    end
end

local ACE_POSITIONS = {
    Top = true, Bottom = true, Center = true, Middle = true, Left = true,
    Right = true, TopRight = true, TopLeft = true, BottomRight = true, BottomLeft = true,
}
local function isAceAnnouncement(...)
    local args = table.pack(...)
    if args.n == 0 or typeof(args[1]) ~= "string" then return false end
    for index = 2, args.n do
        local value = args[index]
        if typeof(value) == "string"
        and (value:find("Sounds%.") or value:find("rbxassetid") or ACE_POSITIONS[value]) then
            return true
        end
    end
    return false
end

local function aceStripRich(text)
    if type(text) ~= "string" then return tostring(text) end
    return (text:gsub("<[^>]->", ""))
end
local function aceApplyCase(code)
    if ACE_CASE_MODE == "UPPER" then return code:upper()
    elseif ACE_CASE_MODE == "lower" then return code:lower() end
    return code
end
local function aceTokenize(text)
    local words = {}
    for word in text:gmatch("[%w_]+") do words[#words + 1] = word end
    return words
end

local aceCollectBuffer = {}
local function onAceAnnouncement(...)
    local text = aceStripRich(tostring((...) or ""))
    text = text:match("^%s*(.-)%s*$") or ""
    if text == "" then return end
    if text:find("%s") then return end
    for _, word in ipairs(aceTokenize(text)) do
        aceCollectBuffer[#aceCollectBuffer + 1] = word
    end
    local parts = {}
    for index = 1, math.min(#aceCollectBuffer, ACE_WORD_COUNT) do
        parts[index] = aceCollectBuffer[index]
    end
    if #aceCollectBuffer < ACE_WORD_COUNT then return end
    aceCollectBuffer = {}
    local captured = aceApplyCase(table.concat(parts))
    if captured == "" or _seen[captured] then return end
    _seen[captured] = true
    task.delay(1.25, function() _seen[captured] = nil end)
    appendToBox(captured)
end

local aceNotifyRemote = resolveAceNotifyRemote()
local aceListenConnection
if aceNotifyRemote then
    if getgenv then
        local previous = getgenv().TigyRedeemerNotifyConnection
        if previous then pcall(function() previous:Disconnect() end) end
    end
    aceListenConnection = aceNotifyRemote.OnClientEvent:Connect(function(...)
        if not _enabled or not isAceAnnouncement(...) then return end
        pcall(onAceAnnouncement, ...)
    end)
    if getgenv then getgenv().TigyRedeemerNotifyConnection = aceListenConnection end
end

if getgenv then
    getgenv().StopAura = function()
        if aceListenConnection then
            pcall(function() aceListenConnection:Disconnect() end)
            aceListenConnection = nil
        end
        if getgenv().TigyRedeemerNotifyConnection then
            pcall(function() getgenv().TigyRedeemerNotifyConnection:Disconnect() end)
            getgenv().TigyRedeemerNotifyConnection = nil
        end
        if GUI then GUI:Destroy() end
    end
end

setActiveTab("REDEEMER")