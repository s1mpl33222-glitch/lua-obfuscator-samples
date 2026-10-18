local cloneref = cloneref or function(object) return object end
local Players           = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RunService        = cloneref(game:GetService("RunService"))
local UserInputService  = cloneref(game:GetService("UserInputService"))
local HttpService       = cloneref(game:GetService("HttpService"))
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if getgenv and getgenv().StopAura then pcall(getgenv().StopAura) end

-- CONFIGURATION SYSTEM --
local CONFIG_FILE = "ace_code_sniper_auto_redeem_test_config.json"
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

-- STATE VARIABLES --
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

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns    = getconnections or (debug and debug.getconnections)
local setupv      = (debug and debug.setupvalue) or setupvalue

-- AI RIDDLE SOLVER --
local httpRequest   = (syn and syn.request) or (http and http.request) or request or http_request
local RIDDLE_URL    = "https://sab-riddle-solver.xyrcheatz.workers.dev"
local RIDDLE_TOKEN  = "0facce8d7ac3a4b6fc4b6ae068b3b219883009780cb2ca31"
local RIDDLE_MODEL  = "qwen"
local _solving      = 0
local _solvedCount  = 0
local _lastTypedSeq = 0
local _riddleSeq    = 0

local function normalizeCode(s)
    return (tostring(s or "")):match("^%s*(.-)%s*$") or ""
end

local function aiPost(path, body)
    if not httpRequest then return nil end
    local ok, res = pcall(httpRequest, {
        Url = RIDDLE_URL .. path,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. RIDDLE_TOKEN,
        },
        Body = HttpService:JSONEncode(body),
    })
    if not ok or type(res) ~= "table" then return nil end
    local raw = res.Body or res.body
    if type(raw) ~= "string" then return nil end
    local okd, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if okd and type(data) == "table" then return data end
    return nil
end

local function solveRiddle(message, seq)
    _solving = _solving + 1
    if setStatus then setStatus("AI solving riddle...", COLORS and COLORS.Text or Color3.fromRGB(200,200,200)) end
    task.spawn(function()
        local data = aiPost("/solve", { message = message, model = RIDDLE_MODEL, history = {} })
        _solving = math.max(0, _solving - 1)
        if not _enabled then return end
        local top = (data and data.riddle == true and type(data.answers) == "table" and data.answers[1])
                    and normalizeCode(data.answers[1]) or nil
        if top and #top > 0 and _riddleSolver and seq >= _lastTypedSeq then
            _lastTypedSeq = seq
            _solvedCount  = _solvedCount + 1
            if setStatus then setStatus("AI answer: " .. top, COLORS and COLORS.Green or Color3.fromRGB(0,255,0)) end
            if flashCode then flashCode(top) end
            typeAndSubmitCode(top)
        elseif not top or #top == 0 then
            if setStatus then setStatus("AI: no answer found", COLORS and COLORS.Red or Color3.fromRGB(255,0,0)) end
        end
    end)
end

local setStatus, flashCode, appendToBox
local rememberPendingSubmission, clearPendingSubmission, handleRedemptionFeedback
local clearAceCapture
local _lastStatusMsg = nil

-- UTILITY & REDEEM LOGIC --
local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "SkibidiRedeemerUI" or p.Name == "ACECodeSniperUI" or p.Name == "SourcesHubRedeemerGui" then return true end
        p = p.Parent
    end
    return false
end

local function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") and not current.Visible then return false end
        if current:IsA("ScreenGui") then return current.Enabled end
        current = current.Parent
    end
    return true
end

local function findAllTextBoxes(pg)
    local boxes = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    boxes[#boxes+1] = d
                end
            end
        end
    end
    return boxes
end

local function findCodeButtons(pg)
    local btns = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and not isOurGui(gui) then
            for _, d in ipairs(gui:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n  = d.Name:lower()
                    local pn = (d.Parent and d.Parent.Name or ""):lower()
                    if (n:find("code") or n:find("redeem") or pn:find("code") or pn:find("redeem"))
                        and isVisibleChain(d) then
                        btns[#btns+1] = d
                    end
                end
            end
        end
    end
    return btns
end

local function clickButton(btn)
    if not btn then return false end
    local methods = {}
    
    methods[#methods+1] = function() btn.MouseButton1Click:Fire() end
    methods[#methods+1] = function() btn.Activated:Fire() end
    
    if typeof(firesignal) == "function" then
        methods[#methods+1] = function() firesignal(btn.MouseButton1Click) end
        methods[#methods+1] = function() firesignal(btn.Activated) end
    end
    
    if typeof(getconns) == "function" then
        methods[#methods+1] = function()
            local ok, cs = pcall(getconns, btn.MouseButton1Click)
            if ok and type(cs) == "table" then
                for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
            end
            local ok2, cs2 = pcall(getconns, btn.Activated)
            if ok2 and type(cs2) == "table" then
                for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end
            end
        end
    end
    
    if typeof(fireclick) == "function" then
        methods[#methods+1] = function() fireclick(btn) end
    end
    
    local anyOk = false
    for _, fn in ipairs(methods) do
        local ok = pcall(fn)
        anyOk = anyOk or ok
    end
    return anyOk
end

local function fireBoxFocusLost(box)
    if not box then return false end
    local anyFired = false
    
    if typeof(firesignal) == "function" then
        local ok = pcall(firesignal, box.FocusLost, true)
        anyFired = anyFired or ok
    end
    
    if typeof(getconns) == "function" then
        local ok, cs = pcall(getconns, box.FocusLost)
        if ok and type(cs) == "table" then
            for _, c in ipairs(cs) do
                local fn
                pcall(function() fn = c.Function end)
                if fn and typeof(getupvalues) == "function" and typeof(setupv) == "function" then
                    local uOk, ups = pcall(getupvalues, fn)
                    if uOk and type(ups) == "table" then
                        for i, v in pairs(ups) do
                            if type(v) == "boolean" and v == true then
                                pcall(setupv, fn, i, false)
                            end
                        end
                    end
                end
                local fOk = pcall(function()
                    if c.Enabled ~= false then c:Fire(true) end
                end)
                anyFired = anyFired or fOk
            end
        end
    end
    
    return anyFired
end

local function typeAndSubmitCode(code)
    local pg = playerGui or player:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "no PlayerGui" end

    -- Strategy 1: Known UI path
    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        if codesGui:IsA("ScreenGui") then codesGui.Enabled = true end
        local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
        if codesFrame then
            if codesFrame:IsA("GuiObject") then codesFrame.Visible = true end
            local cur = codesFrame
            while cur and cur ~= codesGui do
                if cur:IsA("GuiObject") then cur.Visible = true end
                cur = cur.Parent
            end

            local box = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    box = d
                    break
                end
            end

            local submitBtn = nil
            for _, d in ipairs(codesFrame:GetDescendants()) do
                if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                    local n = d.Name:lower()
                    local txt = ""
                    pcall(function() txt = d.Text:lower() end)
                    if n:find("submit") or txt:find("submit") or n:find("redeem") or txt:find("redeem") or n:find("claim") or txt:find("confirm") or n:find("enter") then
                        submitBtn = d
                        break
                    end
                end
            end
            if not submitBtn then
                for _, d in ipairs(codesFrame:GetDescendants()) do
                    if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) then
                        local n = d.Name:lower()
                        if not n:find("close") and not n:find("x") and not n:find("toggle") then
                            submitBtn = d
                            break
                        end
                    end
                end
            end

            if box then
                pcall(function() box.Text = code end)
                task.wait(0.05)
                if submitBtn then clickButton(submitBtn) end
                fireBoxFocusLost(box)
                return true, "submitted via PlayerGui.Codes"
            end
        end
    end

    -- Strategy 2: Dynamic Search
    local btns = findCodeButtons(pg)
    for _, btn in ipairs(btns) do
        clickButton(btn)
        task.wait(0.05)
    end

    task.wait(0.2)

    local box = nil
    local deadline = tick() + 2
    while tick() < deadline do
        local allBoxes = findAllTextBoxes(pg)
        for _, d in ipairs(allBoxes) do
            if isVisibleChain(d) then
                local n  = d.Name:lower()
                local pn = (d.Parent and d.Parent.Name or ""):lower()
                if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or pn:find("textbox") or n:find("enter") then
                    box = d
                    break
                end
            end
        end
        if not box then
            for _, d in ipairs(allBoxes) do
                if isVisibleChain(d) then box = d; break end
            end
        end
        if box then break end
        task.wait(0.1)
    end

    if not box then return false, "no codebox visible" end

    pcall(function() box.Text = code end)
    task.wait(0.05)

    local redeemBtn = nil
    local searchNames = {"submit","redeem","claim","confirm","enter","send","apply","ok","use","go","check"}
    local p = box.Parent
    for _ = 1, 8 do
        if not p then break end
        for _, d in ipairs(p:GetDescendants()) do
            if (d:IsA("TextButton") or d:IsA("ImageButton")) and not isOurGui(d) and d ~= box then
                local n = d.Name:lower()
                local txt = ""
                pcall(function() txt = d.Text:lower() end)
                for _, sn in ipairs(searchNames) do
                    if n:find(sn) or txt:find(sn) then
                        if isVisibleChain(d) then
                            redeemBtn = d
                            break
                        end
                    end
                end
                if redeemBtn then break end
            end
        end
        if redeemBtn then break end
        p = p.Parent
    end

    if redeemBtn then clickButton(redeemBtn) end
    fireBoxFocusLost(box)

    return true, "submitted via dynamic search"
end

local function aceCodeBox()
    local pg = playerGui
    local allBoxes = findAllTextBoxes(pg)
    for _, box in ipairs(allBoxes) do
        if isVisibleChain(box) then return box end
    end
    return nil
end

-- STYLING & HELPER UTILITIES --
local COLORS = {
    Window = Color3.fromRGB(9, 9, 11),
    Row = Color3.fromRGB(18, 18, 21),
    Control = Color3.fromRGB(30, 30, 34),
    Log = Color3.fromRGB(7, 7, 9),
    Border = Color3.fromRGB(70, 70, 78),
    White = Color3.fromRGB(245, 245, 245),
    Text = Color3.fromRGB(190, 190, 196),
    Dim = Color3.fromRGB(120, 120, 130),
    Accent = Color3.fromRGB(245, 245, 245),
    Green = Color3.fromRGB(70, 210, 100),
    Red = Color3.fromRGB(255, 70, 70),
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

-- CLEANUP OLD GUIS --
pcall(function()
    for _, name in ipairs({"SkibidiRedeemerUI", "ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
        local previous = game.CoreGui:FindFirstChild(name)
        if previous then previous:Destroy() end
    end
end)
for _, name in ipairs({"SkibidiRedeemerUI", "ACECodeSniperUI", "AutoTypeCodesUI", "ACEPaste"}) do
    local previous = playerGui:FindFirstChild(name)
    if previous then previous:Destroy() end
end

-- MAIN GUI CREATION --
local GUI = Instance.new("ScreenGui")
GUI.Name = "SkibidiRedeemerUI"
GUI.ResetOnSpawn = false
GUI.IgnoreGuiInset = true
GUI.DisplayOrder = 999
if not pcall(function() GUI.Parent = game.CoreGui end) then GUI.Parent = playerGui end

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(310, 370)
Window.AnchorPoint = Vector2.new(1, 0)
Window.Position = UDim2.new(1, -8, 0, 8)
Window.BackgroundColor3 = COLORS.Window
Window.BorderSizePixel = 0
Window.ClipsDescendants = true
Window.Parent = GUI
addCorner(Window, 14)
addStroke(Window, COLORS.White, 1, 0.58)

local InterfaceScale = Instance.new("UIScale")
InterfaceScale.Name = "InterfaceScale"
InterfaceScale.Scale = 0.92
InterfaceScale.Parent = Window

local viewportConnection
local function updateInterfaceScale()
    local camera = workspace.CurrentCamera
    if not camera then InterfaceScale.Scale = 0.92; return end
    local viewport = camera.ViewportSize
    local fitScale = math.min((viewport.X - 16) / 310, (viewport.Y - 16) / 370)
    if UserInputService.TouchEnabled then
        local mobileTarget = 0.72
        InterfaceScale.Scale = math.max(0.45, math.min(mobileTarget, fitScale))
    else
        InterfaceScale.Scale = 0.92
    end
end

local function watchViewport()
    if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
    local camera = workspace.CurrentCamera
    if camera then viewportConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateInterfaceScale) end
    updateInterfaceScale()
end
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchViewport)
watchViewport()

local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 64)
Header.BackgroundTransparency = 1
Header.Active = true
Header.ZIndex = 3
Header.Parent = Window

local Console, ConsoleOutput, updateConsoleCanvas
local featureStates = {}
local CONSOLE_COLORS = {
    Dim = "rgb(124,127,135)",
    Amber = "rgb(214,158,92)",
    Green = "rgb(105,190,132)",
    Red = "rgb(218,105,105)",
    Cyan = "rgb(101,174,183)",
}

local function scrollConsoleToBottom()
    task.defer(function()
        task.wait()
        if not Console then return end
        if updateConsoleCanvas then updateConsoleCanvas() end
        local bottom = math.max(0, Console.AbsoluteCanvasSize.Y - Console.AbsoluteWindowSize.Y)
        Console.CanvasPosition = Vector2.new(0, bottom)
    end)
end

local function appendConsoleStatus(name, activated)
    if not ConsoleOutput then return end
    local state = activated and "ON" or "OFF"
    local stateColor = activated and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red
    local line = '<font color="' .. CONSOLE_COLORS.Dim .. '">[setting]</font> '
        .. '<font color="' .. CONSOLE_COLORS.Amber .. '">' .. name .. "</font> "
        .. '<font color="' .. CONSOLE_COLORS.Dim .. '">-&gt;</font> '
        .. '<font color="' .. stateColor .. '">' .. state .. "</font>"
    if ConsoleOutput.Text == "" then ConsoleOutput.Text = line
    else ConsoleOutput.Text = ConsoleOutput.Text .. "\n\n" .. line end
    scrollConsoleToBottom()
end

local BrandMark = Instance.new("Frame")
BrandMark.Name = "BrandMark"
BrandMark.Size = UDim2.fromOffset(34, 34)
BrandMark.Position = UDim2.fromOffset(17, 15)
BrandMark.BackgroundColor3 = COLORS.Window
BrandMark.BorderSizePixel = 0
BrandMark.Parent = Header
addCorner(BrandMark, 10)
addStroke(BrandMark, COLORS.White, 1, 0.7)

local BrandLetter = makeLabel(BrandMark, "Letter", "S", UDim2.fromScale(1, 1), UDim2.fromOffset(0, 0), 16, COLORS.White, Enum.Font.GothamBold)
BrandLetter.TextXAlignment = Enum.TextXAlignment.Center
BrandLetter.TextYAlignment = Enum.TextYAlignment.Center

makeLabel(Header, "Title", "SKIBIDI REDEEMER", UDim2.fromOffset(200, 18), UDim2.fromOffset(60, 13), 14, COLORS.White, Enum.Font.GothamBold)
local Subtitle = makeLabel(Header, "Subtitle", "CODE PANEL", UDim2.fromOffset(200, 14), UDim2.fromOffset(60, 32), 10, COLORS.Dim, Enum.Font.GothamMedium)

-- TOP RIGHT TOGGLE BUTTON (UPDATED FOR MOBILE & PC) --
local AutoWriteButton = Instance.new("TextButton")
AutoWriteButton.Name = "AutoWrite"
AutoWriteButton.Size = UDim2.fromOffset(46, 24)
AutoWriteButton.Position = UDim2.new(1, -63, 0, 20)
AutoWriteButton.BackgroundColor3 = COLORS.Control
AutoWriteButton.BorderSizePixel = 0
AutoWriteButton.AutoButtonColor = false
AutoWriteButton.Active = true
AutoWriteButton.Text = "OFF"
AutoWriteButton.TextSize = 9
AutoWriteButton.TextColor3 = COLORS.Dim
AutoWriteButton.Font = Enum.Font.GothamBold
AutoWriteButton.ZIndex = 5
AutoWriteButton.Parent = Header
addCorner(AutoWriteButton, 7)

local AutoWriteStroke = addStroke(AutoWriteButton, COLORS.White, 1, 0.78)

local autoWriteEnabled = _enabled
_enabled = autoWriteEnabled
AutoWriteButton.Text = autoWriteEnabled and "ON" or "OFF"
AutoWriteButton.BackgroundColor3 = autoWriteEnabled and COLORS.Accent or COLORS.Control
AutoWriteButton.TextColor3 = autoWriteEnabled and COLORS.Window or COLORS.Dim
AutoWriteStroke.Transparency = autoWriteEnabled and 0.62 or 0.78

local lastToggleTime = 0
local function toggleAutoWrite()
    if tick() - lastToggleTime < 0.15 then return end
    lastToggleTime = tick()

    autoWriteEnabled = not autoWriteEnabled
    _enabled = autoWriteEnabled
    if not autoWriteEnabled and clearAceCapture then clearAceCapture() end
    savedConfig.codeSniper = autoWriteEnabled
    saveConfig()
    _lastStatusMsg = nil
    AutoWriteButton.Text = autoWriteEnabled and "ON" or "OFF"
    AutoWriteButton.BackgroundColor3 = autoWriteEnabled and COLORS.Accent or COLORS.Control
    AutoWriteButton.TextColor3 = autoWriteEnabled and COLORS.Window or COLORS.Dim
    AutoWriteStroke.Transparency = autoWriteEnabled and 0.62 or 0.78
    
    if ConsoleOutput then
        if autoWriteEnabled then
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; system initialized</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; code sniper:</font> <font color="' .. CONSOLE_COLORS.Green .. '">ON</font>'
            for _, featureName in ipairs({"Auto submit", "Riddle solver", "Retype invalid"}) do
                if featureStates[featureName] then appendConsoleStatus(featureName, true) end
            end
        else
            ConsoleOutput.Text = '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; system initialized</font>\n<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; code sniper:</font> <font color="' .. CONSOLE_COLORS.Red .. '">OFF</font>'
        end
        scrollConsoleToBottom()
    end
end

-- MULTI-EVENT BINDING FOR MOBILE TOUCH STABILITY --
AutoWriteButton.Activated:Connect(toggleAutoWrite)
AutoWriteButton.MouseButton1Click:Connect(toggleAutoWrite)
AutoWriteButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleAutoWrite()
    end
end)

local HeaderAccent = Instance.new("Frame")
HeaderAccent.Name = "TitleDivider"
HeaderAccent.Size = UDim2.new(1, -34, 0, 1)
HeaderAccent.Position = UDim2.fromOffset(17, 54)
HeaderAccent.BackgroundColor3 = COLORS.White
HeaderAccent.BackgroundTransparency = 0.72
HeaderAccent.BorderSizePixel = 0
HeaderAccent.Parent = Header

local Settings = Instance.new("Frame")
Settings.Name = "Settings"
Settings.Size = UDim2.new(1, 0, 0, 154)
Settings.Position = UDim2.fromOffset(0, 65)
Settings.BackgroundTransparency = 1
Settings.ZIndex = 3
Settings.Parent = Window

local function makeCard(name, position, size)
    local card = Instance.new("Frame")
    card.Name = name
    card.Position = position
    card.Size = size
    card.BackgroundColor3 = COLORS.Row
    card.BackgroundTransparency = 0.68
    card.BorderSizePixel = 0
    card.Parent = Settings
    addCorner(card, 9)
    addStroke(card, COLORS.White, 1, 0.76)
    return card
end

local function makeStateButton(parent, enabled, consoleName, onToggle)
    parent.Active = true
    featureStates[consoleName] = enabled
    local button = Instance.new("TextButton")
    button.Name = "State"
    button.Size = UDim2.fromOffset(42, 20)
    button.Position = UDim2.new(1, -50, 0.5, -10)
    button.BackgroundColor3 = enabled and COLORS.Accent or COLORS.Control
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Active = true
    button.Text = enabled and "ON" or "OFF"
    button.TextSize = 8
    button.TextColor3 = enabled and COLORS.Window or COLORS.Dim
    button.Font = Enum.Font.GothamBold
    button.ZIndex = 5
    button.Parent = parent
    addCorner(button, 6)
    local outline = addStroke(button, COLORS.White, 1, enabled and 0.62 or 0.88)
    local state = enabled
    local lastSubToggle = 0
    
    local function toggleState()
        if tick() - lastSubToggle < 0.15 then return end
        lastSubToggle = tick()
        state = not state
        featureStates[consoleName] = state
        button.Text = state and "ON" or "OFF"
        button.BackgroundColor3 = state and COLORS.Accent or COLORS.Control
        button.TextColor3 = state and COLORS.Window or COLORS.Dim
        outline.Transparency = state and 0.62 or 0.88
        if autoWriteEnabled then appendConsoleStatus(consoleName, state) end
        if onToggle then onToggle(state) end
    end
    
    button.Activated:Connect(toggleState)
    button.MouseButton1Click:Connect(toggleState)
    button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleState()
        end
    end)
    return button
end

local AutoCard = makeCard("AutoSubmit", UDim2.fromOffset(17, 0), UDim2.fromOffset(135, 50))
makeLabel(AutoCard, "Title", "Auto submit", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AutoCard, _autoAccept, "Auto submit", function(state)
    _autoAccept = state
    savedConfig.autoSubmit = state
    saveConfig()
end)

local AICard = makeCard("AIRiddles", UDim2.fromOffset(158, 0), UDim2.fromOffset(135, 50))
makeLabel(AICard, "Title", "Riddle solver", UDim2.new(1, -58, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
makeStateButton(AICard, _riddleSolver, "Riddle solver", function(state)
    _riddleSolver = state
    savedConfig.riddleSolver = state
    saveConfig()
end)

local DelayCard = makeCard("SubmitAfter", UDim2.fromOffset(17, 57), UDim2.fromOffset(276, 43))
makeLabel(DelayCard, "Title", "Submit after messages", UDim2.fromOffset(150, 43), UDim2.fromOffset(12, 0), 10, COLORS.White, Enum.Font.GothamMedium)
local CounterShell = Instance.new("Frame")
CounterShell.Name = "Counter"
CounterShell.Size = UDim2.fromOffset(96, 31)
CounterShell.Position = UDim2.new(1, -105, 0.5, -15)
CounterShell.BackgroundColor3 = COLORS.Window
CounterShell.BackgroundTransparency = 0.05
CounterShell.BorderSizePixel = 0
CounterShell.Parent = DelayCard
addCorner(CounterShell, 7)
addStroke(CounterShell, COLORS.White, 1, 0.86)

local Minus = Instance.new("TextButton")
Minus.Name = "Minus"
Minus.Size = UDim2.fromOffset(25, 25)
Minus.Position = UDim2.fromOffset(3, 3)
Minus.BackgroundColor3 = COLORS.Control
Minus.BorderSizePixel = 0
Minus.AutoButtonColor = false
Minus.Active = true
Minus.Text = "-"
Minus.TextSize = 16
Minus.TextColor3 = COLORS.Text
Minus.Font = Enum.Font.GothamBold
Minus.Parent = CounterShell
addCorner(Minus, 5)

local Count = makeLabel(CounterShell, "Count", tostring(_submitAfter), UDim2.fromOffset(28, 25), UDim2.fromOffset(34, 3), 17, COLORS.White, Enum.Font.GothamBold)
Count.TextXAlignment = Enum.TextXAlignment.Center

local Plus = Instance.new("TextButton")
Plus.Name = "Plus"
Plus.Size = UDim2.fromOffset(25, 25)
Plus.Position = UDim2.fromOffset(68, 3)
Plus.BackgroundColor3 = COLORS.Control
Plus.BorderSizePixel = 0
Plus.AutoButtonColor = false
Plus.Active = true
Plus.Text = "+"
Plus.TextSize = 16
Plus.TextColor3 = COLORS.Text
Plus.Font = Enum.Font.GothamBold
Plus.Parent = CounterShell
addCorner(Plus, 5)

local function decr()
    _submitAfter = math.max(1, _submitAfter - 1)
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearAceCapture()
    saveConfig()
end
local function incr()
    _submitAfter += 1
    Count.Text = tostring(_submitAfter)
    savedConfig.submitAfter = _submitAfter
    clearAceCapture()
    saveConfig()
end

Minus.Activated:Connect(decr)
Minus.MouseButton1Click:Connect(decr)
Plus.Activated:Connect(incr)
Plus.MouseButton1Click:Connect(incr)

local RetypeCard = makeCard("RetypeInvalid", UDim2.fromOffset(17, 103), UDim2.fromOffset(276, 38))
makeLabel(RetypeCard, "Title", "Retype invalid", UDim2.new(1, -65, 1, 0), UDim2.fromOffset(12, 0), 11, COLORS.White, Enum.Font.GothamMedium)
local RetypeState = makeStateButton(RetypeCard, _retypeInvalid, "Retype invalid", function(state)
    _retypeInvalid = state
    savedConfig.retypeInvalid = state
    saveConfig()
end)
RetypeState.Position = UDim2.new(1, -50, 0.5, -10)

Console = Instance.new("ScrollingFrame")
Console.Name = "Console"
Console.Size = UDim2.new(1, -34, 0, 118)
Console.Position = UDim2.fromOffset(17, 216)
Console.BackgroundColor3 = COLORS.Log
Console.BorderSizePixel = 0
Console.ClipsDescendants = true
Console.Active = true
Console.ScrollingEnabled = true
Console.ScrollingDirection = Enum.ScrollingDirection.Y
Console.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
Console.VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar
Console.CanvasSize = UDim2.new(0, 0, 0, 0)
Console.AutomaticCanvasSize = Enum.AutomaticSize.None
Console.ScrollBarThickness = 4
Console.ScrollBarImageColor3 = COLORS.Dim
Console.ZIndex = 3
Console.Parent = Window
addCorner(Console, 9)
addStroke(Console, COLORS.White, 1, 0.88)

ConsoleOutput = Instance.new("TextLabel")
ConsoleOutput.Name = "ConsoleOutput"
ConsoleOutput.Size = UDim2.new(1, -18, 0, 115)
ConsoleOutput.AutomaticSize = Enum.AutomaticSize.Y
ConsoleOutput.Position = UDim2.fromOffset(9, 6)
ConsoleOutput.BackgroundTransparency = 1
ConsoleOutput.RichText = true
local function buildBootLog()
    local lines = {
        '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; system initialized</font>',
        '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; code sniper:</font> <font color="' .. (autoWriteEnabled and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red) .. '">' .. (autoWriteEnabled and "ON" or "OFF") .. '</font>',
        '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; auto submit:</font> <font color="' .. (_autoAccept and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red) .. '">' .. (_autoAccept and "ON" or "OFF") .. '</font>',
        '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; riddle solver:</font> <font color="' .. (_riddleSolver and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red) .. '">' .. (_riddleSolver and "ON" or "OFF") .. '</font>',
        '<font color="' .. CONSOLE_COLORS.Dim .. '">&gt; retype invalid:</font> <font color="' .. (_retypeInvalid and CONSOLE_COLORS.Green or CONSOLE_COLORS.Red) .. '">' .. (_retypeInvalid and "ON" or "OFF") .. '</font>',
    }
    return table.concat(lines, "\n")
end
ConsoleOutput.Text = buildBootLog()
ConsoleOutput.TextSize = 14
ConsoleOutput.Font = Enum.Font.Code
ConsoleOutput.TextColor3 = COLORS.Dim
ConsoleOutput.TextXAlignment = Enum.TextXAlignment.Left
ConsoleOutput.TextYAlignment = Enum.TextYAlignment.Top
ConsoleOutput.TextWrapped = true
ConsoleOutput.ZIndex = 4
ConsoleOutput.Parent = Console

local CONSOLE_BOTTOM_PADDING = 30
updateConsoleCanvas = function()
    if not Console or not ConsoleOutput then return end
    local contentHeight = ConsoleOutput.Position.Y.Offset + ConsoleOutput.AbsoluteSize.Y + CONSOLE_BOTTOM_PADDING
    Console.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
end
ConsoleOutput:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateConsoleCanvas)
task.defer(updateConsoleCanvas)

local FooterBar = Instance.new("Frame")
FooterBar.Name = "FooterBar"
FooterBar.Size = UDim2.new(1, 0, 0, 28)
FooterBar.Position = UDim2.fromOffset(0, 342)
FooterBar.BackgroundColor3 = COLORS.Log
FooterBar.BorderSizePixel = 0
FooterBar.ZIndex = 3
FooterBar.Parent = Window

local FooterLabel = makeLabel(FooterBar, "FooterText", "SKIBIDI REDEEMER", UDim2.new(1, 0, 1, 0), UDim2.fromOffset(0, 0), 10, COLORS.Dim, Enum.Font.GothamBold)
FooterLabel.TextXAlignment = Enum.TextXAlignment.Center
FooterLabel.ZIndex = 3

-- WINDOW DRAGGING SYSTEM WITH TOUCH INTEGRATION --
do
    local dragging = false
    local activeDragInput
    local dragStart
    local startPosition
    local dragMoved = false
    local DRAG_THRESHOLD = UserInputService.TouchEnabled and 10 or 3

    local function isOverHeaderControl(position)
        local btnPos = AutoWriteButton.AbsolutePosition
        local btnSize = AutoWriteButton.AbsoluteSize
        return position.X >= (btnPos.X - 10)
            and position.X <= (btnPos.X + btnSize.X + 10)
            and position.Y >= (btnPos.Y - 10)
            and position.Y <= (btnPos.Y + btnSize.Y + 10)
    end

    local function stopDragging(input)
        if input ~= activeDragInput then return end
        dragging = false
        activeDragInput = nil
        dragStart = nil
        startPosition = nil
    end

    Header.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging or isOverHeaderControl(input.Position) then return end

        dragging = true
        activeDragInput = input
        dragStart = Vector2.new(input.Position.X, input.Position.Y)
        startPosition = Window.Position
        dragMoved = false

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End or input.UserInputState == Enum.UserInputState.Cancel then
                stopDragging(input)
            end
        end)
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not activeDragInput then return end
        local isTrackedTouch = activeDragInput.UserInputType == Enum.UserInputType.Touch and input == activeDragInput
        local isTrackedMouse = activeDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseMovement
        if not isTrackedTouch and not isTrackedMouse then return end

        local current = Vector2.new(input.Position.X, input.Position.Y)
        local delta = current - dragStart
        if not dragMoved then
            if delta.Magnitude < DRAG_THRESHOLD then return end
            dragMoved = true
        end

        Window.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end)
end

local function col3ToRich(col)
    if col == COLORS.Green then return CONSOLE_COLORS.Green end
    if col == COLORS.Red then return CONSOLE_COLORS.Red end
    if col == COLORS.Text then return CONSOLE_COLORS.Amber end
    if col == COLORS.White then return CONSOLE_COLORS.Cyan end
    if col == COLORS.Dim then return CONSOLE_COLORS.Dim end
    return string.format("rgb(%d,%d,%d)", math.floor(col.R * 255 + 0.5), math.floor(col.G * 255 + 0.5), math.floor(col.B * 255 + 0.5))
end

function setStatus(msg, col)
    if not ConsoleOutput or not _enabled then return end
    if msg == _lastStatusMsg then return end
    _lastStatusMsg = msg
    col = col or COLORS.Dim
    local line = '<font color="' .. col3ToRich(col) .. '">' .. tostring(msg) .. "</font>"
    if ConsoleOutput.Text == "" then ConsoleOutput.Text = line
    else ConsoleOutput.Text = ConsoleOutput.Text .. "\n\n" .. line end
    scrollConsoleToBottom()
end

function flashCode(code, col)
    if not code or code == "" or code == "—" then return end
    setStatus("[code] -> " .. tostring(code), col or COLORS.White)
end

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

local function watchBoxForBlankReset(box)
    if not box or _lastWatchedBox == box then return end
    clearBoxWatchers()
    _lastWatchedBox = box
    if box.Text ~= "" then _lastNonBlankBoxText = box.Text end
    _boxTextConn = box:GetPropertyChangedSignal("Text"):Connect(function()
        if box.Text == "" then resetPasteCounter()
        else _lastNonBlankBoxText = box.Text end
    end)
    _boxAncestryConn = box.AncestryChanged:Connect(function(_, parent)
        if not parent then resetPasteCounter(); clearBoxWatchers() end
    end)
end

UserInputService.TextBoxFocused:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    if box ~= aceCodeBox() then return end
    _focused = box
    _lastBox = box
    watchBoxForBlankReset(box)
    if _enabled then setStatus("Ready", COLORS.Green) end
end)

UserInputService.TextBoxFocusReleased:Connect(function(box)
    if box:IsDescendantOf(GUI) then return end
    local codeBox = aceCodeBox()
    if box ~= codeBox and box ~= _lastBox then return end
    if _retypeInvalid and rememberPendingSubmission and (box == codeBox or box == _lastBox) then
        local submittedText = box.Text ~= "" and box.Text or _lastNonBlankBoxText
        rememberPendingSubmission(box, submittedText, false)
    end
    if _focused == box then
        _focused = nil
        if _enabled then
            setStatus((_lastBox and _lastBox.Parent) and "Ready" or "Click code box first", (_lastBox and _lastBox.Parent) and COLORS.Green or COLORS.Dim)
        end
    end
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
    local repasteBox = aceCodeBox() or box
    if not repasteBox or not isVisibleChain(repasteBox) then return false end
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
        setStatus("Invalid - repasted: " .. previousText, COLORS.Text)
        flashCode(previousText, COLORS.Red)
    end
end

function appendToBox(text)
    if not text or text == "" then return end
    if _lastWatchedBox and not isVisibleChain(_lastWatchedBox) then
        resetPasteCounter()
        clearBoxWatchers()
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
        setStatus("Captured; opening & searching UI...", COLORS.Text)
    end

    setStatus("Pasted " .. tostring(capturedCount) .. "/" .. tostring(_submitAfter), COLORS.Green)
    flashCode(combinedCode, COLORS.Green)

    if capturedCount >= _submitAfter then
        _capturedParts = {}
        if _autoAccept then
            rememberPendingSubmission(box, combinedCode, true)
            
            local ok, statusMsg = typeAndSubmitCode(combinedCode)
            
            if ok then
                setStatus("Redeemed: " .. combinedCode, COLORS.Green)
            else
                local restored = restoreRejectedText(box, combinedCode)
                clearPendingSubmission()
                if restored then
                    setStatus("Invalid - repasted: " .. combinedCode, COLORS.Text)
                    flashCode(combinedCode, COLORS.Red)
                else
                    setStatus("Failed: " .. tostring(statusMsg), COLORS.Red)
                end
            end
        end
    end
end

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

-- ANNOUNCEMENT NOTIFICATION LISTENER --
local function resolveNotifyRemote()
    if _G.PhiNotifyRemote then return _G.PhiNotifyRemote end
    local Net = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net")
    local getinfo = debug and (debug.getinfo or debug.info)
    if getgc and getinfo and getconnections then
        for _, d in ipairs(Net:GetDescendants()) do
            if d:IsA("RemoteEvent") then
                local ok, cs = pcall(getconnections, d.OnClientEvent)
                if ok then
                    for _, c in ipairs(cs) do
                        local f, fn = pcall(function() return c.Function end)
                        if f and type(fn) == "function" then
                            local i, info = pcall(getinfo, fn)
                            if i and tostring(info.short_src or info.source or ""):find("NotificationController", 1, true) then
                                return d
                            end
                        end
                    end
                end
            end
        end
    end
    return nil
end

local function aceStripRich(text)
    if type(text) ~= "string" then return tostring(text) end
    return (text:gsub("<[^>]->", ""))
end

local function aceTokenize(text)
    local words = {}
    for word in text:gmatch("[%w_]+") do
        words[#words + 1] = word
    end
    return words
end

local aceCollectBuffer = {}
local function onAceAnnouncement(...)
    local text = aceStripRich(tostring((...) or ""))
    text = text:match("^%s*(.-)%s*$") or ""
    if text == "" then return end

    -- If riddle solver is on and message has spaces, try AI solving
    if _riddleSolver and text:find("%s") then
        _riddleSeq = _riddleSeq + 1
        solveRiddle(text, _riddleSeq)
        return
    end

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
    
    local captured = table.concat(parts)
    if captured == "" or _seen[captured] then return end
    _seen[captured] = true
    task.delay(1.25, function() _seen[captured] = nil end)
    appendToBox(captured)
end

local aceNotifyRemote = resolveNotifyRemote()
local aceListenConnection
if aceNotifyRemote then
    if getgenv then
        local previous = getgenv().ACECodeSniperNotifyConnection
        if previous then pcall(function() previous:Disconnect() end) end
    end
    aceListenConnection = aceNotifyRemote.OnClientEvent:Connect(function(...)
        if not _enabled then return end
        pcall(onAceAnnouncement, ...)
    end)
    if getgenv then getgenv().ACECodeSniperNotifyConnection = aceListenConnection end
end

if getgenv then
    getgenv().StopAura = function()
        if aceListenConnection then
            pcall(function() aceListenConnection:Disconnect() end)
            aceListenConnection = nil
        end
        if getgenv().ACECodeSniperNotifyConnection then
            pcall(function() getgenv().ACECodeSniperNotifyConnection:Disconnect() end)
            getgenv().ACECodeSniperNotifyConnection = nil
        end
        if GUI then GUI:Destroy() end
    end
end