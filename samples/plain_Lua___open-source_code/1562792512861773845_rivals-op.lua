
-- ============================================
-- KeySystem Settings
-- ============================================

-- Die URL deines Workers (z.B. "https://my-keysystem.workers.dev")
local API_URL = "https://keysystem.vairoscripts.com"

-- Der Slug des Scripts aus deinem Dashboard (z.B. "mein-script.lua")
local SCRIPT_SLUG = "rivals-op.lua"

-- Die URL, wo User den Key bekommen (wird beim "Get Key" kopiert)
local WEBSITE_URL = "https://keysystem.vairoscripts.com"

-- Key Speichername
local KEY_SAVE_NAME = "MyKeySystem_SavedKey"

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer

local function getHWID()
    local success, result = pcall(function()
        -- KRNL/Synapse/etc. hwid functions
        if gethwid then return gethwid() end
        if syn and syn.request then return "synapse-hwid-unsupported" end
        return "unknown-hwid"
    end)
    if success then return result else return "error" end
end

local function getHeaders()
    return {
        ["User-Agent"] = "Roblox/Executor",
        ["X-Roblox-Username"] = player.Name,
        ["X-Roblox-Id"] = tostring(player.UserId),
        ["X-HWID"] = getHWID()
    }
end

-- ============================================
-- KEY EXPIRATION STORAGE
-- ============================================

local KEY_DURATIONS = {
    ["2H"]    = 2 * 60 * 60,
    ["6H"]    = 6 * 60 * 60,
    ["DAILY"] = 24 * 60 * 60
}

local function getKeyType(key)
    local keyType = key:match("^RBX%-(%w+)%-")
    if keyType then return keyType:upper() end
    return nil
end

local function getKeyDuration(keyType)
    if keyType and KEY_DURATIONS[keyType] then
        return KEY_DURATIONS[keyType]
    end
    return 2 * 60 * 60
end

local function saveKey(key)
    pcall(function()
        if writefile then
            local keyType = getKeyType(key) or "2H"
            local data = HttpService:JSONEncode({
                key = key,
                savedAt = os.time(),
                keyType = keyType,
                expiresAt = os.time() + getKeyDuration(keyType)
            })
            writefile(KEY_SAVE_NAME .. ".json", data)
        end
    end)
end

local function loadSavedKey()
    local success, result = pcall(function()
        if isfile and isfile(KEY_SAVE_NAME .. ".json") then
            local raw = readfile(KEY_SAVE_NAME .. ".json")
            return HttpService:JSONDecode(raw)
        end
    end)

    if success and result then
        if result.expiresAt and os.time() >= result.expiresAt then
            pcall(function()
                if delfile then delfile(KEY_SAVE_NAME .. ".json") end
            end)
            return nil, true -- expired
        end
        return result.key, false
    end
    return nil, false
end

local function deleteSavedKey()
    pcall(function()
        if delfile and isfile and isfile(KEY_SAVE_NAME .. ".json") then
            delfile(KEY_SAVE_NAME .. ".json")
        end
    end)
end

local function formatTimeRemaining(seconds)
    if seconds <= 0 then return "Expired" end
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    if h > 0 then return h .. "h " .. m .. "m" end
    return m .. "m"
end

-- ============================================
-- DESTROY OLD GUI & BLUR (if re-executed)
-- ============================================

pcall(function()
    if CoreGui:FindFirstChild("KeySystemGUI") then
        CoreGui:FindFirstChild("KeySystemGUI"):Destroy()
    end
end)

pcall(function()
    if Lighting:FindFirstChild("KeySystemBlur") then
        Lighting:FindFirstChild("KeySystemBlur"):Destroy()
    end
end)

-- ============================================
-- CREATE BLUR EFFECT (actual camera blur)
-- ============================================

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Name = "KeySystemBlur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

-- ============================================
-- CREATE GUI
-- ============================================

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KeySystemGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ============================================
-- FULL-SCREEN DARK OVERLAY
-- ============================================

local OverlayFrame = Instance.new("Frame")
OverlayFrame.Name = "Overlay"
OverlayFrame.Size = UDim2.new(1, 0, 1, 0)
OverlayFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
OverlayFrame.BackgroundTransparency = 1
OverlayFrame.BorderSizePixel = 0
OverlayFrame.ZIndex = 1
OverlayFrame.Parent = ScreenGui

-- Overlay blocks all input behind it
local OverlayBtn = Instance.new("TextButton")
OverlayBtn.Size = UDim2.new(1, 0, 1, 0)
OverlayBtn.BackgroundTransparency = 1
OverlayBtn.Text = ""
OverlayBtn.ZIndex = 1
OverlayBtn.Parent = OverlayFrame

-- Subtle vignette gradient
local OverlayGradient = Instance.new("UIGradient")
OverlayGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(10, 10, 15)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
})
OverlayGradient.Parent = OverlayFrame

-- "Key Required" watermark
local WatermarkLabel = Instance.new("TextLabel")
WatermarkLabel.Size = UDim2.new(1, 0, 0, 30)
WatermarkLabel.Position = UDim2.new(0, 0, 0, 20)
WatermarkLabel.BackgroundTransparency = 1
WatermarkLabel.Text = "🔒 KEY REQUIRED"
WatermarkLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
WatermarkLabel.TextTransparency = 1
WatermarkLabel.TextSize = 14
WatermarkLabel.Font = Enum.Font.GothamBold
WatermarkLabel.ZIndex = 2
WatermarkLabel.Parent = OverlayFrame

-- Main container
local MainFrame = Instance.new("Frame")
MainFrame.Name = "Main"
MainFrame.Size = UDim2.new(0, 380, 0, 280)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
MainFrame.BorderSizePixel = 0
MainFrame.ZIndex = 10
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(45, 45, 45)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Shadow
local Shadow = Instance.new("ImageLabel")
Shadow.Name = "Shadow"
Shadow.Size = UDim2.new(1, 50, 1, 50)
Shadow.Position = UDim2.new(0, -25, 0, -25)
Shadow.BackgroundTransparency = 1
Shadow.Image = "rbxassetid://5554236805"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.4
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(23, 23, 277, 277)
Shadow.ZIndex = 9
Shadow.Parent = MainFrame

-- Title bar
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
TitleBar.BorderSizePixel = 0
TitleBar.ZIndex = 11
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 14)
TitleCorner.Parent = TitleBar

local TitleCover = Instance.new("Frame")
TitleCover.Size = UDim2.new(1, 0, 0, 16)
TitleCover.Position = UDim2.new(0, 0, 1, -16)
TitleCover.BackgroundColor3 = Color3.fromRGB(14, 14, 14)
TitleCover.BorderSizePixel = 0
TitleCover.ZIndex = 11
TitleCover.Parent = TitleBar

local Divider = Instance.new("Frame")
Divider.Size = UDim2.new(1, 0, 0, 1)
Divider.Position = UDim2.new(0, 0, 0, 50)
Divider.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Divider.BorderSizePixel = 0
Divider.ZIndex = 11
Divider.Parent = MainFrame

-- Shield icon
local ShieldIcon = Instance.new("TextLabel")
ShieldIcon.Name = "Shield"
ShieldIcon.Size = UDim2.new(0, 30, 0, 30)
ShieldIcon.Position = UDim2.new(0, 14, 0, 10)
ShieldIcon.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ShieldIcon.BorderSizePixel = 0
ShieldIcon.Text = "🔒"
ShieldIcon.TextSize = 16
ShieldIcon.Font = Enum.Font.GothamBold
ShieldIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
ShieldIcon.ZIndex = 12
ShieldIcon.Parent = TitleBar

local ShieldCorner = Instance.new("UICorner")
ShieldCorner.CornerRadius = UDim.new(0, 8)
ShieldCorner.Parent = ShieldIcon

-- Title text
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(0, 200, 0, 50)
TitleLabel.Position = UDim2.new(0, 52, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Key System"
TitleLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
TitleLabel.TextSize = 16
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.ZIndex = 12
TitleLabel.Parent = TitleBar

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "Close"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(120, 120, 120)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.ZIndex = 12
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(180, 50, 50),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)

CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        TextColor3 = Color3.fromRGB(120, 120, 120)
    }):Play()
end)

CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), { Size = 0 }):Play()
    TweenService:Create(OverlayFrame, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(MainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 380, 0, 0),
        Position = UDim2.new(0.5, -190, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()
    task.wait(0.35)
    pcall(function() BlurEffect:Destroy() end)
    ScreenGui:Destroy()
end)

-- Content area
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "Content"
ContentFrame.Size = UDim2.new(1, -40, 0, 190)
ContentFrame.Position = UDim2.new(0, 20, 0, 65)
ContentFrame.BackgroundTransparency = 1
ContentFrame.ZIndex = 11
ContentFrame.Parent = MainFrame

-- Status label
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "Status"
StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Position = UDim2.new(0, 0, 0, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Enter your key below to continue"
StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
StatusLabel.TextSize = 13
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.ZIndex = 12
StatusLabel.Parent = ContentFrame

-- Key input box
local InputFrame = Instance.new("Frame")
InputFrame.Name = "InputFrame"
InputFrame.Size = UDim2.new(1, 0, 0, 44)
InputFrame.Position = UDim2.new(0, 0, 0, 30)
InputFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
InputFrame.BorderSizePixel = 0
InputFrame.ZIndex = 12
InputFrame.Parent = ContentFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = InputFrame

local InputStroke = Instance.new("UIStroke")
InputStroke.Name = "Stroke"
InputStroke.Color = Color3.fromRGB(40, 40, 40)
InputStroke.Thickness = 1.5
InputStroke.Parent = InputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Name = "KeyInput"
KeyInput.Size = UDim2.new(1, -20, 1, 0)
KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "RBX-XXXX-XXXXXXXX-XXXXXXXX"
KeyInput.PlaceholderColor3 = Color3.fromRGB(60, 60, 60)
KeyInput.TextColor3 = Color3.fromRGB(220, 220, 230)
KeyInput.TextSize = 13
KeyInput.Font = Enum.Font.Code
KeyInput.ClearTextOnFocus = false
KeyInput.ZIndex = 13
KeyInput.Parent = InputFrame

-- Focus animation
KeyInput.Focused:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(80, 80, 220)
    }):Play()
end)

KeyInput.FocusLost:Connect(function()
    TweenService:Create(InputStroke, TweenInfo.new(0.2), {
        Color = Color3.fromRGB(40, 40, 40)
    }):Play()
end)

-- Check Key button
local CheckBtn = Instance.new("TextButton")
CheckBtn.Name = "CheckBtn"
CheckBtn.Size = UDim2.new(1, 0, 0, 40)
CheckBtn.Position = UDim2.new(0, 0, 0, 84)
CheckBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
CheckBtn.BorderSizePixel = 0
CheckBtn.Text = "Check Key"
CheckBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CheckBtn.TextSize = 14
CheckBtn.Font = Enum.Font.GothamBold
CheckBtn.AutoButtonColor = false
CheckBtn.ZIndex = 12
CheckBtn.Parent = ContentFrame

local CheckCorner = Instance.new("UICorner")
CheckCorner.CornerRadius = UDim.new(0, 10)
CheckCorner.Parent = CheckBtn

local CheckGradient = Instance.new("UIGradient")
CheckGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(59, 130, 246)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(99, 102, 241))
})
CheckGradient.Rotation = 135
CheckGradient.Parent = CheckBtn

CheckBtn.MouseEnter:Connect(function()
    TweenService:Create(CheckBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(79, 150, 255)
    }):Play()
end)

CheckBtn.MouseLeave:Connect(function()
    TweenService:Create(CheckBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(59, 130, 246)
    }):Play()
end)

-- Get Key button
local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Name = "GetKeyBtn"
GetKeyBtn.Size = UDim2.new(1, 0, 0, 36)
GetKeyBtn.Position = UDim2.new(0, 0, 0, 134)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
GetKeyBtn.BorderSizePixel = 0
GetKeyBtn.Text = "🔑  Get Key from Website"
GetKeyBtn.TextColor3 = Color3.fromRGB(140, 140, 140)
GetKeyBtn.TextSize = 12
GetKeyBtn.Font = Enum.Font.GothamSemibold
GetKeyBtn.AutoButtonColor = false
GetKeyBtn.ZIndex = 12
GetKeyBtn.Parent = ContentFrame

local GetKeyCorner = Instance.new("UICorner")
GetKeyCorner.CornerRadius = UDim.new(0, 10)
GetKeyCorner.Parent = GetKeyBtn

local GetKeyStroke = Instance.new("UIStroke")
GetKeyStroke.Color = Color3.fromRGB(40, 40, 40)
GetKeyStroke.Thickness = 1
GetKeyStroke.Parent = GetKeyBtn

GetKeyBtn.MouseEnter:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        TextColor3 = Color3.fromRGB(200, 200, 200)
    }):Play()
end)

GetKeyBtn.MouseLeave:Connect(function()
    TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        TextColor3 = Color3.fromRGB(140, 140, 140)
    }):Play()
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard(WEBSITE_URL)
    end)
    StatusLabel.Text = "🔗 Link copied! Open it in your browser."
    StatusLabel.TextColor3 = Color3.fromRGB(96, 165, 250)
    task.wait(2)
    StatusLabel.Text = "Enter your key below to continue"
    StatusLabel.TextColor3 = Color3.fromRGB(130, 130, 130)
end)

-- Result label
local ResultLabel = Instance.new("TextLabel")
ResultLabel.Name = "Result"
ResultLabel.Size = UDim2.new(1, 0, 0, 25)
ResultLabel.Position = UDim2.new(0, 0, 0, 178)
ResultLabel.BackgroundTransparency = 1
ResultLabel.Text = ""
ResultLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
ResultLabel.TextSize = 12
ResultLabel.Font = Enum.Font.GothamSemibold
ResultLabel.ZIndex = 12
ResultLabel.Parent = ContentFrame

-- ============================================
-- OPEN ANIMATION
-- ============================================

MainFrame.Size = UDim2.new(0, 380, 0, 0)
MainFrame.Position = UDim2.new(0.5, -190, 0.5, 0)
MainFrame.BackgroundTransparency = 1

-- Dark overlay fade in
TweenService:Create(OverlayFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
    BackgroundTransparency = 0.35
}):Play()

TweenService:Create(WatermarkLabel, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
    TextTransparency = 0.5
}):Play()

-- Camera blur
TweenService:Create(BlurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
    Size = 18
}):Play()

-- Window scale in
task.wait(0.1)
TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 380, 0, 280),
    Position = UDim2.new(0.5, -190, 0.5, -140),
    BackgroundTransparency = 0
}):Play()

-- ============================================
-- DRAGGING
-- ============================================

local dragging, dragInput, dragStart, startPos

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- ============================================
-- SCRIPT EXECUTION
-- ============================================

local function executeScript(code)
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 380, 0, 0),
        Position = UDim2.new(0.5, -190, 0.5, 0),
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(OverlayFrame, TweenInfo.new(0.4), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(WatermarkLabel, TweenInfo.new(0.3), { TextTransparency = 1 }):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quad), { Size = 0 }):Play()

    task.wait(0.45)
    pcall(function() BlurEffect:Destroy() end)
    ScreenGui:Destroy()

    -- Load the fetched script
    local success, err = pcall(function()
        loadstring(code)()
    end)

    if not success then
        warn("[KeySystem] Script error: " .. tostring(err))
    end
end

-- ============================================
-- KEY CHECK LOGIC (Server Validation)
-- ============================================

local checking = false

local function doKeyCheck()
    if checking then return end
    checking = true

    local inputKey = KeyInput.Text:match("^%s*(.-)%s*$")

    if not inputKey or #inputKey == 0 then
        ResultLabel.Text = "⚠️  Please enter a key!"
        ResultLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        checking = false
        return
    end

    CheckBtn.Text = "⏳  Checking Server..."
    CheckBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ResultLabel.Text = ""

    local fetchSuccess, scriptCode = pcall(function()
        local req = request or http_request or (syn and syn.request)
        if not req then return "No HTTP request function found in executor." end
        
        local res = req({
            Url = API_URL .. "/raw/" .. inputKey .. "/" .. SCRIPT_SLUG,
            Method = "GET",
            Headers = getHeaders()
        })
        
        if res.StatusCode == 200 then
            return res.Body
        else
            return "ERROR:" .. tostring(res.Body)
        end
    end)

    if fetchSuccess and scriptCode and not string.match(scriptCode, "^ERROR:") and not string.match(scriptCode, "^%-%- Access denied") and not string.match(scriptCode, "^%-%- Invalid") then
        ResultLabel.Text = "✅  Correct Key! Loading Script..."
        ResultLabel.TextColor3 = Color3.fromRGB(74, 222, 128)
        CheckBtn.Text = "✅  Verified"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(34, 197, 94)
        saveKey(inputKey)
        task.wait(1)
        executeScript(scriptCode)
    else
        local errMsg = "Invalid or expired key!"
        if fetchSuccess and string.match(scriptCode, "^ERROR:") then
            errMsg = string.gsub(scriptCode, "^ERROR:", "")
        elseif fetchSuccess and string.match(scriptCode, "^%-%- ") then
            errMsg = string.gsub(scriptCode, "^%-%- ", "")
        end

        ResultLabel.Text = "❌  " .. errMsg
        ResultLabel.TextColor3 = Color3.fromRGB(248, 113, 113)
        CheckBtn.Text = "Check Key"
        CheckBtn.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
        deleteSavedKey()

        local originalPos = InputFrame.Position
        for i = 1, 3 do
            InputFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset + 6, originalPos.Y.Scale, originalPos.Y.Offset)
            task.wait(0.04)
            InputFrame.Position = UDim2.new(originalPos.X.Scale, originalPos.X.Offset - 6, originalPos.Y.Scale, originalPos.Y.Offset)
            task.wait(0.04)
        end
        InputFrame.Position = originalPos

        TweenService:Create(InputStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(220, 50, 50) }):Play()
        task.wait(1)
        TweenService:Create(InputStroke, TweenInfo.new(0.2), { Color = Color3.fromRGB(40, 40, 40) }):Play()
    end

    checking = false
end

CheckBtn.MouseButton1Click:Connect(doKeyCheck)

-- ============================================
-- AUTO-CHECK SAVED KEY (with expiration)
-- ============================================

task.spawn(function()
    local savedKey, wasExpired = loadSavedKey()

    if wasExpired then
        StatusLabel.Text = "⏰ Your key has expired! Get a new one."
        StatusLabel.TextColor3 = Color3.fromRGB(251, 191, 36)
        KeyInput.Text = ""
        return
    end

    if savedKey and #savedKey > 0 then
        KeyInput.Text = savedKey
        StatusLabel.Text = "🔄 Saved key found, checking..."
        StatusLabel.TextColor3 = Color3.fromRGB(96, 165, 250)
        task.wait(0.8)

        -- Directly call doKeyCheck instead of firing the signal (Fire() is not valid on RBXScriptSignal)
        task.spawn(doKeyCheck)
    end
end)

print("[KeySystem] v2.1 loaded — local key validation active")

