-- Wyvern Key System - Jnkie SDK Entegreli (Gamesense Tema)
local Players    = game:GetService("Players")
local TS         = game:GetService("TweenService")
local UIS        = game:GetService("UserInputService")
local CoreGui    = game:GetService("CoreGui")

local LP         = Players.LocalPlayer
local KEY_FILE   = "wyvern_key.txt"

-- Jnkie SDK Yükle
local Junkie = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
Junkie.service = "wyvern rivals"
Junkie.identifier = "1034398"
Junkie.provider = "wyvern key system"

-- Key dosya yönetimi
local function saveKey(k)
    pcall(function()
        if type(writefile) == "function" then
            writefile(KEY_FILE, tostring(k or ""))
        end
    end)
end
local function loadSavedKey()
    local ok, res = pcall(function()
        if type(isfile) == "function" and type(readfile) == "function" and isfile(KEY_FILE) then
            return readfile(KEY_FILE)
        end
    end)
    if ok and type(res) == "string" then
        return (res:gsub("^%s+", ""):gsub("%s+$", ""))
    end
    return nil
end
local function forgetKey()
    pcall(function()
        if type(delfile) == "function" and type(isfile) == "function" and isfile(KEY_FILE) then
            delfile(KEY_FILE)
        elseif type(writefile) == "function" then
            writefile(KEY_FILE, "")
        end
    end)
end

-- Tema renkleri (Gamesense)
local ACCENT     = Color3.fromRGB(153, 196, 39)
local ACCENT_LO  = Color3.fromRGB(120, 155, 30)
local ACCENT_HI  = Color3.fromRGB(200, 220, 100)
local BG_MAIN    = Color3.fromRGB(20, 20, 20)
local BG_HEAD    = Color3.fromRGB(31, 31, 31)
local BG_FIELD   = Color3.fromRGB(24, 24, 24)
local BG_BTN     = Color3.fromRGB(31, 31, 31)
local BG_BTN_HOT = Color3.fromRGB(45, 45, 45)
local STROKE_SFT = Color3.fromRGB(60, 60, 60)
local STROKE_DRK = Color3.fromRGB(45, 45, 45)
local TXT_MAIN   = Color3.fromRGB(220, 220, 220)
local TXT_MUTE   = Color3.fromRGB(140, 140, 140)
local TXT_FOOT   = Color3.fromRGB(90, 90, 90)
local TXT_PLACE  = Color3.fromRGB(80, 80, 80)
local TXT_ONLIME = Color3.fromRGB(15, 15, 15)
local ERR_RED    = Color3.fromRGB(220, 80, 80)
local WARN_ORANGE = Color3.fromRGB(255, 180, 60)
local FONT_REG   = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local FONT_BLD   = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Bold,    Enum.FontStyle.Normal)

-- Helpers
local function newInst(class, props, parent)
    local inst = Instance.new(class)
    if props then for k, v in pairs(props) do inst[k] = v end end
    if parent then inst.Parent = parent end
    return inst
end
local function corner(inst, r)
    newInst("UICorner", {CornerRadius = UDim.new(0, r or 3)}, inst)
end
local function stroke(inst, c, t, tr)
    return newInst("UIStroke", {
        Color = c or STROKE_SFT, Thickness = t or 1,
        Transparency = tr or 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    }, inst)
end

-- Cleanup
local host = (gethui and gethui()) or CoreGui
pcall(function()
    for _, sg in ipairs(host:GetChildren()) do
        if sg.Name == "WV_KeySystem" then sg:Destroy() end
    end
end)
pcall(function()
    for _, sg in ipairs(LP:WaitForChild("PlayerGui"):GetChildren()) do
        if sg.Name == "WV_KeySystem" then sg:Destroy() end
    end
end)

-- ScreenGui
local ScreenGui = newInst("ScreenGui", {
    Name = "WV_KeySystem",
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    DisplayOrder = 2147483647,
})
pcall(function() ScreenGui.Parent = host end)
if not ScreenGui.Parent then
    pcall(function() ScreenGui.Parent = LP:WaitForChild("PlayerGui") end)
end
pcall(function() if syn and syn.protect_gui then syn.protect_gui(ScreenGui) end end)

-- Root
local Root = newInst("Frame", {
    Name = "Root",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(320, 190),
    BackgroundColor3 = BG_MAIN,
    BorderSizePixel = 0,
}, ScreenGui)
corner(Root, 4)
stroke(Root, STROKE_SFT, 1, 0)
stroke(Root, STROKE_DRK, 1, 0)

-- Accent line
newInst("Frame", {
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 0),
    Size = UDim2.new(1, 0, 0, 1),
}, Root)

-- Header
local Header = newInst("Frame", {
    BackgroundColor3 = BG_HEAD,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 1, 0, 1),
    Size = UDim2.new(1, -2, 0, 24),
    Active = true,
}, Root)

local Dot = newInst("Frame", {
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 8, 0.5, -3),
    Size = UDim2.fromOffset(6, 6),
}, Header)
corner(Dot, 1)

newInst("TextLabel", {
    BackgroundTransparency = 1,
    Text = "wyvern  ",
    TextColor3 = TXT_MAIN,
    TextSize = 13,
    FontFace = FONT_BLD,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Position = UDim2.new(0, 20, 0, 0),
    Size = UDim2.new(1, -60, 1, 0),
}, Header)

newInst("TextLabel", {
    BackgroundTransparency = 1,
    Text = "key system",
    TextColor3 = TXT_MUTE,
    TextSize = 13,
    FontFace = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Position = UDim2.new(0, 66, 0, 0),
    Size = UDim2.new(1, -110, 1, 0),
}, Header)

local CloseBtn = newInst("TextButton", {
    BackgroundTransparency = 1,
    Text = "X",
    TextColor3 = TXT_MUTE,
    TextSize = 14,
    FontFace = FONT_BLD,
    Position = UDim2.new(1, -22, 0, 0),
    Size = UDim2.fromOffset(20, 24),
    AutoButtonColor = false,
}, Header)
CloseBtn.MouseEnter:Connect(function() CloseBtn.TextColor3 = ERR_RED end)
CloseBtn.MouseLeave:Connect(function() CloseBtn.TextColor3 = TXT_MUTE end)

-- Description
newInst("TextLabel", {
    BackgroundTransparency = 1,
    Text = "paste your key below. click get key to open the link.",
    TextColor3 = TXT_MUTE,
    TextSize = 12,
    FontFace = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Position = UDim2.new(0, 12, 0, 32),
    Size = UDim2.new(1, -24, 0, 14),
}, Root)

-- Key Input
local KeyInput = newInst("TextBox", {
    BackgroundColor3 = BG_FIELD,
    BorderSizePixel = 0,
    PlaceholderText = "key",
    PlaceholderColor3 = TXT_PLACE,
    Text = "",
    TextColor3 = TXT_MAIN,
    TextSize = 13,
    FontFace = FONT_REG,
    ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Left,
    Position = UDim2.new(0, 12, 0, 54),
    Size = UDim2.new(1, -24, 0, 26),
}, Root)
corner(KeyInput, 3)
stroke(KeyInput, STROKE_SFT, 1, 0)
newInst("UIPadding", {PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)}, KeyInput)

-- Kaydedilmiş key'i yükle
do
    local sk = loadSavedKey()
    if sk and #sk > 0 then
        KeyInput.Text = sk
    end
end

-- Get Key Button
local GetKeyBtn = newInst("TextButton", {
    BackgroundColor3 = BG_BTN,
    BorderSizePixel = 0,
    Text = "get key",
    TextColor3 = TXT_MAIN,
    TextSize = 13,
    FontFace = FONT_BLD,
    AutoButtonColor = false,
    Position = UDim2.new(0, 12, 0, 90),
    Size = UDim2.new(0, 145, 0, 26),
}, Root)
corner(GetKeyBtn, 3)
stroke(GetKeyBtn, STROKE_SFT, 1, 0)

-- Load Button
local LoadBtn = newInst("TextButton", {
    BackgroundColor3 = ACCENT,
    BorderSizePixel = 0,
    Text = "load",
    TextColor3 = TXT_ONLIME,
    TextSize = 13,
    FontFace = FONT_BLD,
    AutoButtonColor = false,
    Position = UDim2.new(0, 163, 0, 90),
    Size = UDim2.new(0, 145, 0, 26),
}, Root)
corner(LoadBtn, 3)
stroke(LoadBtn, ACCENT, 1, 0.4)

-- Status
local Status = newInst("TextLabel", {
    BackgroundTransparency = 1,
    Text = "",
    TextColor3 = TXT_MUTE,
    TextSize = 12,
    FontFace = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Position = UDim2.new(0, 12, 0, 124),
    Size = UDim2.new(1, -24, 0, 14),
    TextTruncate = Enum.TextTruncate.AtEnd,
}, Root)

-- Footer
newInst("TextLabel", {
    BackgroundTransparency = 1,
    Text = "discord.gg/wyvernscripts",
    TextColor3 = TXT_FOOT,
    TextSize = 11,
    FontFace = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Center,
    Position = UDim2.new(0, 12, 1, -20),
    Size = UDim2.new(1, -24, 0, 14),
}, Root)

newInst("TextLabel", {
    BackgroundTransparency = 1,
    Text = "gamesense edition",
    TextColor3 = TXT_FOOT,
    TextSize = 11,
    FontFace = FONT_REG,
    TextXAlignment = Enum.TextXAlignment.Right,
    TextYAlignment = Enum.TextYAlignment.Center,
    Position = UDim2.new(0, 12, 1, -20),
    Size = UDim2.new(1, -24, 0, 14),
}, Root)

-- Drag
do
    local dragging, dragStart, startPos
    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = Root.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
                      or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
                                      startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- Hover tweens
local function hoverTween(btn, base, hot)
    btn.MouseEnter:Connect(function()
        TS:Create(btn, TweenInfo.new(0.12), {BackgroundColor3 = hot}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TS:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
end
hoverTween(GetKeyBtn, BG_BTN, BG_BTN_HOT)
hoverTween(LoadBtn,   ACCENT, ACCENT_HI)

-- Clipboard
local function setClip(text)
    for _, fn in ipairs({setclipboard, toclipboard, set_clipboard,
                         (syn and syn.write_clipboard),
                         (Clipboard and Clipboard.set)}) do
        if type(fn) == "function" then
            local ok = pcall(fn, text)
            if ok then return true end
        end
    end
    return false
end

local function setStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color or TXT_MUTE
end

-- Hata mesajlarını kullanıcı dostu göster
local ERROR_MESSAGES = {
    KEY_INVALID = "key not found.",
    KEY_EXPIRED = "key expired. get a new one.",
    HWID_BANNED = "hardware banned.",
    KEY_INVALIDATED = "key was disabled.",
    ALREADY_USED = "one-time key already used.",
    HWID_MISMATCH = "hwid limit reached.",
    SERVICE_NOT_FOUND = "service not found.",
    SERVICE_MISMATCH = "key is for a different service.",
    PREMIUM_REQUIRED = "premium key required.",
    RATE_LIMITED = "rate limited. wait 5 minutes.",
    ERROR = "network error. try again.",
}

local function friendlyError(err)
    if not err then return "unknown error." end
    local msg = ERROR_MESSAGES[err]
    if msg then return msg end
    if tostring(err):match("^http %d+") then
        return "server error: " .. tostring(err)
    end
    return tostring(err)
end

-- Close
CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() ScreenGui:Destroy() end)
end)

-- Get Key: Jnkie SDK üzerinden dinamik link al
local gettingKey = false
GetKeyBtn.MouseButton1Click:Connect(function()
    if gettingKey then return end
    gettingKey = true

    GetKeyBtn.BackgroundColor3 = STROKE_DRK
    TS:Create(GetKeyBtn, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {BackgroundColor3 = BG_BTN}):Play()
    GetKeyBtn.Text = "loading..."
    setStatus("getting key link...", TXT_MUTE)

    task.spawn(function()
        local link, err = Junkie.get_key_link()
        gettingKey = false
        GetKeyBtn.Text = "get key"

        if link then
            local ok = setClip(link)
            if ok then
                setStatus("link copied. paste in a browser.", ACCENT)
            else
                setStatus("link: " .. tostring(link), ACCENT)
            end
        else
            local errMsg = friendlyError(err)
            setStatus(errMsg, ERR_RED)
        end
    end)
end)

-- Load: Jnkie SDK ile key doğrula
local loading = false
local function submitKey()
    if loading then return end
    local key = KeyInput.Text
    if key then key = (key:gsub("^%s+", ""):gsub("%s+$", "")) end
    if not key or #key < 4 then
        setStatus("enter your key first.", ERR_RED)
        return
    end

    loading = true
    LoadBtn.BackgroundColor3 = ACCENT_HI
    TS:Create(LoadBtn, TweenInfo.new(0.18, Enum.EasingStyle.Sine), {BackgroundColor3 = ACCENT}):Play()
    LoadBtn.Text = "validating..."
    LoadBtn.AutoButtonColor = false
    setStatus("validating key...", ACCENT)

    task.spawn(function()
        -- Jnkie SDK ile key kontrolü
        local validation = Junkie.check_key(key)

        if validation and validation.valid then
            -- KEY GEÇERLİ
            local g = (type(getgenv) == "function" and getgenv()) or _G
            g.SCRIPT_KEY = key
            g.ScriptKey  = key
            g.script_key = key
            g.jnkie_key  = key
            g.lp_key     = key
            g.Key, g.KEY, g.key = key, key, key
            _G.SCRIPT_KEY = key
            _G.ScriptKey  = key
            _G.script_key = key
            _G.jnkie_key  = key
            _G.lp_key     = key
            _G.Key, _G.KEY, _G.key = key, key, key
            pcall(function() rawset(_G, "SCRIPT_KEY", key) end)
            pcall(function() rawset(_G, "lp_key", key) end)
            if type(shared) == "table" then
                pcall(function()
                    shared.SCRIPT_KEY = key
                    shared.Key = key
                end)
            end
            pcall(function() setClip(key) end)
            saveKey(key)

            local statusMsg = "validated."
            if validation.message == "KEYLESS" then
                statusMsg = "keyless mode active."
            end
            setStatus(statusMsg, ACCENT)
            LoadBtn.Text = "loading..."

            -- Ana script'i yükle
            local ok, err = pcall(function()
                local LOADER_URL = "https://api.jnkie.com/api/v1/luascripts/public/50137e0baa47d4aa7008baf1ceba531c0bb394b141f2afa3681b9d4ce863a57c/download"
                local src = game:HttpGet(LOADER_URL)
                local fn, cerr = loadstring(src)
                if not fn then error(cerr or "loadstring failed", 0) end
                fn()
            end)
            if ok then
                setStatus("loaded.", ACCENT)
                LoadBtn.Text = "loaded"
                task.wait(0.6)
                pcall(function() ScreenGui:Destroy() end)
            else
                loading = false
                LoadBtn.Text = "load"
                LoadBtn.AutoButtonColor = true
                local msg = tostring(err):sub(1, 120)
                setStatus(msg, ERR_RED)
            end
        else
            -- KEY GEÇERSİZ
            loading = false
            LoadBtn.Text = "load"
            LoadBtn.AutoButtonColor = true
            local errMsg = friendlyError(validation and validation.error or "ERROR")
            setStatus(errMsg, ERR_RED)

            -- HWID ban durumunda kick
            if validation and validation.error == "HWID_BANNED" then
                task.wait(1.5)
                pcall(function() LP:Kick("Hardware banned.") end)
            end
        end
    end)
end

LoadBtn.MouseButton1Click:Connect(submitKey)
KeyInput.FocusLost:Connect(function(enter)
    saveKey(KeyInput.Text)
    if enter then submitKey() end
end)
KeyInput:GetPropertyChangedSignal("Text"):Connect(function()
    saveKey(KeyInput.Text)
end)
