--[[ ═══════════════════════════════════════════════════════
     GANKUNZ LOADER v4.0
     Warm amber / cream — non-generic design
     Domain: https://gankunz.web.id
     ═══════════════════════════════════════════════════════ ]]

local HttpService      = game:GetService("HttpService")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local BASE     = "https://gankunz.web.id"
local plr      = Players.LocalPlayer
local VERSION  = "v4.0"
local BRAND    = "GANKUNZ"
local KEY_FILE = "gankunz_key.txt"

-- ═══════════════════════════════════════════════════════
--   COLOR PALETTE (warm amber / cream / dark)
-- ═══════════════════════════════════════════════════════
local C = {
    bg        = Color3.fromRGB(10, 9, 7),
    bg1       = Color3.fromRGB(18, 16, 13),
    bg2       = Color3.fromRGB(26, 23, 19),
    bg3       = Color3.fromRGB(34, 30, 24),
    border    = Color3.fromRGB(42, 38, 32),
    border2   = Color3.fromRGB(58, 52, 42),
    text      = Color3.fromRGB(245, 240, 230),
    text2     = Color3.fromRGB(184, 176, 160),
    text3     = Color3.fromRGB(122, 114, 101),
    text4     = Color3.fromRGB(74, 68, 56),
    accent    = Color3.fromRGB(245, 158, 11),
    accentH   = Color3.fromRGB(251, 191, 36),
    accentDim = Color3.fromRGB(180, 115, 8),
    success   = Color3.fromRGB(74, 222, 128),
    danger    = Color3.fromRGB(248, 113, 113),
    warn      = Color3.fromRGB(251, 191, 36),
}

-- ═══════════════════════════════════════════════════════
--   LANGUAGE
-- ═══════════════════════════════════════════════════════
local LANG = "en"
pcall(function()
    local loc = plr.LocaleId or ""
    if loc:sub(1,2) == "id" then LANG = "id" end
end)

local T = {
    en = {
        access_key = "ACCESS KEY", enter_key = "Enter your key to continue",
        verify = "VERIFY KEY", get_key = "GET KEY",
        waiting = "waiting for input...",
        opening_br = "opening browser...",
        br_opened = "browser opened - link also copied",
        br_copied = "link copied - open manually in browser",
        key_short = "key too short (min 8 chars)",
        verifying = "verifying...",
        no_response = "server not responding",
        invalid_resp = "invalid response",
        invalid_key = "invalid key",
        success = "success - loading scripts...",
        script_lib = "Scripts", search_ph = "search script or map...",
        no_scripts = "no scripts available", load_fail = "failed to load scripts",
        exec = "RUN", ok = "OK", fail = "FAIL", error = "ERR",
        logout = "EXIT", key_expired = "Key expired, please enter a new key",
        server_busy = "Server busy, try again in a moment",
        welcome = "welcome", exp = "exp",
    },
    id = {
        access_key = "KUNCI AKSES", enter_key = "Masukkan key untuk lanjut",
        verify = "VERIFIKASI", get_key = "AMBIL KEY",
        waiting = "menunggu input...",
        opening_br = "membuka browser...",
        br_opened = "browser dibuka - link disalin juga",
        br_copied = "link disalin - buka manual di browser",
        key_short = "key terlalu pendek (min 8)",
        verifying = "memverifikasi...",
        no_response = "server tidak merespon",
        invalid_resp = "respon tidak valid",
        invalid_key = "key tidak valid",
        success = "berhasil - memuat script...",
        script_lib = "Script", search_ph = "cari script atau map...",
        no_scripts = "belum ada script", load_fail = "gagal memuat script",
        exec = "JALAN", ok = "OK", fail = "GAGAL", error = "ERR",
        logout = "KELUAR", key_expired = "Key expired, masukkan key baru",
        server_busy = "Server sibuk, coba sebentar",
        welcome = "halo", exp = "sisa",
    },
}
local function tr(k) return (T[LANG] and T[LANG][k]) or T.en[k] or k end

-- ═══════════════════════════════════════════════════════
--   HWID
-- ═══════════════════════════════════════════════════════
local HWID = "acc" .. tostring(plr.UserId)

-- ═══════════════════════════════════════════════════════
--   STORAGE
-- ═══════════════════════════════════════════════════════
local function hasFileAPI()
    return type(writefile) == "function"
       and type(readfile) == "function"
       and type(isfile) == "function"
end
local STORAGE_OK = hasFileAPI()

local function saveKey(key, exp)
    local data = { key = key, exp = exp or "", saved_at = os.time() }
    local enc = HttpService:JSONEncode(data)
    if STORAGE_OK then pcall(function() writefile(KEY_FILE, enc) end) end
    pcall(function()
        local env = getgenv and getgenv() or _G
        env.__gankunz_key = data
    end)
    return true
end

local function loadKey()
    if STORAGE_OK and isfile(KEY_FILE) then
        local ok, content = pcall(readfile, KEY_FILE)
        if ok and content and content ~= "" then
            local data
            pcall(function() data = HttpService:JSONDecode(content) end)
            if data and data.key then return data end
        end
    end
    local ok, data = pcall(function()
        local env = getgenv and getgenv() or _G
        return env.__gankunz_key
    end)
    if ok and data and data.key then return data end
    return nil
end

local function deleteKey()
    if STORAGE_OK then
        pcall(function()
            if isfile(KEY_FILE) then
                if type(delfile) == "function" then
                    delfile(KEY_FILE)
                else
                    writefile(KEY_FILE, "")
                end
            end
        end)
    end
    pcall(function()
        local env = getgenv and getgenv() or _G
        env.__gankunz_key = nil
    end)
end

-- ═══════════════════════════════════════════════════════
--   UI HELPERS
-- ═══════════════════════════════════════════════════════
local function mk(inst, props, parent)
    local o = Instance.new(inst)
    for k, v in pairs(props or {}) do
        pcall(function() o[k] = v end)
    end
    if parent then o.Parent = parent end
    return o
end

local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
    return c
end

local function stroke(p, col, th, trans)
    local s = Instance.new("UIStroke")
    s.Color = col or C.border
    s.Thickness = th or 1
    s.Transparency = trans or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function newGui(name)
    local g = Instance.new("ScreenGui")
    g.Name = name or ("GK_" .. tostring(tick()))
    g.ResetOnSpawn = false
    g.IgnoreGuiInset = true
    pcall(function() g.ZIndexBehavior = Enum.ZIndexBehavior.Sibling end)
    pcall(function() g.Parent = game:GetService("CoreGui") end)
    if not g.Parent then
        pcall(function() g.Parent = plr:WaitForChild("PlayerGui") end)
    end
    return g
end

local function draggable(frame, handle)
    handle = handle or frame
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local function fadeIn(gui)
    for _, d in ipairs(gui:GetDescendants()) do
        if d:IsA("Frame") or d:IsA("TextLabel") or d:IsA("TextButton")
        or d:IsA("TextBox") or d:IsA("ScrollingFrame") then
            if d.BackgroundTransparency < 1 then
                local orig = d.BackgroundTransparency
                d.BackgroundTransparency = 1
                TweenService:Create(d, TweenInfo.new(0.3),
                    {BackgroundTransparency = orig}):Play()
            end
            if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
                local orig = d.TextTransparency
                d.TextTransparency = 1
                TweenService:Create(d, TweenInfo.new(0.3),
                    {TextTransparency = orig}):Play()
            end
        end
    end
end

local function hover(btn, base, hi)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = hi}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), {BackgroundColor3 = base}):Play()
    end)
end

local function openBrowser(url)
    local ok = false
    pcall(function()
        if syn and syn.request then syn.request({Url = url, Method = "GET"}); ok = true
        elseif request then request({Url = url, Method = "GET"}); ok = true
        elseif http and http.request then http.request({Url = url, Method = "GET"}); ok = true
        elseif fluxus and fluxus.request then fluxus.request({Url = url, Method = "GET"}); ok = true
        elseif krnl and krnl.request then krnl.request({Url = url, Method = "GET"}); ok = true
        end
    end)
    pcall(function() setclipboard(url) end)
    return ok
end

local function validateKey(key)
    local url = BASE .. "/api/validate.php?key=" .. key .. "&hwid=" .. HWID
    local ok, raw = pcall(function() return game:HttpGet(url) end)
    if not ok or not raw then return nil, "no_response" end
    local res
    pcall(function() res = HttpService:JSONDecode(raw) end)
    if not res then return nil, "invalid_resp" end
    if not res.valid then return false, res.reason or "invalid_key" end
    return true, res.exp
end

-- ═══════════════════════════════════════════════════════
--   SCREEN 1 — KEY SYSTEM
-- ═══════════════════════════════════════════════════════
local function showKeySystem(autoMsg)
    local Gui = newGui("GankunzLoader")

    local Main = mk("Frame", {
        Size = UDim2.new(0, 420, 0, 320),
        Position = UDim2.new(0.5, -210, 0.5, -160),
        BackgroundColor3 = C.bg1,
        BorderSizePixel = 0,
    }, Gui)
    corner(Main, 12)
    stroke(Main, C.border, 1)

    -- Top accent line
    mk("Frame", {
        Size = UDim2.new(1, -32, 0, 1),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundColor3 = C.accent,
        BorderSizePixel = 0,
    }, Main)

    draggable(Main)

    -- Top bar
    local Top = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 56),
        BackgroundColor3 = C.bg1,
        BorderSizePixel = 0,
    }, Main)
    corner(Top, 12)

    -- Brand mark
    local Logo = mk("Frame", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 18, 0, 15),
        BackgroundColor3 = C.accent,
        BorderSizePixel = 0,
    }, Top)
    corner(Logo, 6)
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "G",
        TextColor3 = C.bg,
        Font = Enum.Font.GothamBlack,
        TextSize = 15,
    }, Logo)

    mk("TextLabel", {
        Size = UDim2.new(0, 100, 0, 20),
        Position = UDim2.new(0, 52, 0, 15),
        BackgroundTransparency = 1,
        Text = BRAND,
        TextColor3 = C.text,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Top)

    mk("TextLabel", {
        Size = UDim2.new(0, 60, 0, 14),
        Position = UDim2.new(0, 52, 0, 33),
        BackgroundTransparency = 1,
        Text = VERSION .. "  ·  HWID ACC",
        TextColor3 = C.text3,
        Font = Enum.Font.Code,
        TextSize = 9,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Top)

    -- Minimize
    local Min = mk("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -66, 0, 17),
        BackgroundColor3 = C.bg2,
        Text = "−",
        TextColor3 = C.text3,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, Top)
    corner(Min, 5)

    -- Close
    local Close = mk("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -40, 0, 17),
        BackgroundColor3 = C.bg2,
        Text = "×",
        TextColor3 = C.text3,
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, Top)
    corner(Close, 5)

    hover(Min, C.bg2, C.bg3)
    hover(Close, C.bg2, C.danger)

    Close.MouseButton1Click:Connect(function() Gui:Destroy() end)

    -- Body
    mk("TextLabel", {
        Size = UDim2.new(1, -40, 0, 14),
        Position = UDim2.new(0, 20, 0, 78),
        BackgroundTransparency = 1,
        Text = tr("access_key"),
        TextColor3 = C.text4,
        Font = Enum.Font.Code,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Main)

    mk("TextLabel", {
        Size = UDim2.new(1, -40, 0, 20),
        Position = UDim2.new(0, 20, 0, 92),
        BackgroundTransparency = 1,
        Text = tr("enter_key"),
        TextColor3 = C.text,
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Main)

    -- Input
    local InWrap = mk("Frame", {
        Size = UDim2.new(1, -40, 0, 44),
        Position = UDim2.new(0, 20, 0, 124),
        BackgroundColor3 = C.bg,
        BorderSizePixel = 0,
    }, Main)
    corner(InWrap, 7)
    local inStroke = stroke(InWrap, C.border, 1)

    mk("TextLabel", {
        Size = UDim2.new(0, 30, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "◆",
        TextColor3 = C.accent,
        Font = Enum.Font.Gotham,
        TextSize = 14,
    }, InWrap)

    local Input = mk("TextBox", {
        Size = UDim2.new(1, -45, 1, 0),
        Position = UDim2.new(0, 34, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        PlaceholderText = "paste key here",
        PlaceholderColor3 = C.text4,
        TextColor3 = C.accent,
        Font = Enum.Font.Code,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
    }, InWrap)

    -- Buttons
    local Submit = mk("TextButton", {
        Size = UDim2.new(0.5, -25, 0, 42),
        Position = UDim2.new(0, 20, 0, 180),
        BackgroundColor3 = C.accent,
        Text = tr("verify"),
        TextColor3 = C.bg,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, Main)
    corner(Submit, 7)

    local GetKey = mk("TextButton", {
        Size = UDim2.new(0.5, -25, 0, 42),
        Position = UDim2.new(0.5, 5, 0, 180),
        BackgroundColor3 = C.bg2,
        Text = tr("get_key"),
        TextColor3 = C.text,
        Font = Enum.Font.GothamBold,
        TextSize = 13,
        BorderSizePixel = 0,
        AutoButtonColor = false,
    }, Main)
    corner(GetKey, 7)
    stroke(GetKey, C.border2, 1)

    hover(Submit, C.accent, C.accentH)
    hover(GetKey, C.bg2, C.bg3)

    -- Status
    local StatusBar = mk("Frame", {
        Size = UDim2.new(1, -40, 0, 32),
        Position = UDim2.new(0, 20, 1, -46),
        BackgroundColor3 = C.bg,
        BorderSizePixel = 0,
    }, Main)
    corner(StatusBar, 6)

    local Dot = mk("Frame", {
        Size = UDim2.new(0, 6, 0, 6),
        Position = UDim2.new(0, 12, 0.5, -3),
        BackgroundColor3 = C.text4,
        BorderSizePixel = 0,
    }, StatusBar)
    corner(Dot, 3)

    local StatusTxt = mk("TextLabel", {
        Size = UDim2.new(1, -30, 1, 0),
        Position = UDim2.new(0, 26, 0, 0),
        BackgroundTransparency = 1,
        Text = autoMsg or tr("waiting"),
        TextColor3 = C.text3,
        Font = Enum.Font.Code,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, StatusBar)

    local pulse = 0
    RunService.RenderStepped:Connect(function(dt)
        pulse = pulse + dt * 3
        local a = (math.sin(pulse) + 1) / 2
        if Dot.BackgroundColor3 == C.text4 then
            Dot.BackgroundTransparency = 0.3 + a * 0.3
        end
    end)

    local function setStatus(txt, col, dotCol)
        StatusTxt.Text = txt
        StatusTxt.TextColor3 = col or C.text3
        Dot.BackgroundColor3 = dotCol or C.text4
        Dot.BackgroundTransparency = 0
    end

    Input.Focused:Connect(function()
        TweenService:Create(inStroke, TweenInfo.new(0.2), {Color = C.accent}):Play()
    end)
    Input.FocusLost:Connect(function()
        TweenService:Create(inStroke, TweenInfo.new(0.2), {Color = C.border}):Play()
    end)

    local minimized = false
    local origSize = Main.Size
    Min.MouseButton1Click:Connect(function()
        minimized = not minimized
        for _, d in ipairs(Main:GetChildren()) do
            if d ~= Top and d:IsA("GuiObject") then d.Visible = not minimized end
        end
        local target = minimized and UDim2.new(0, 420, 0, 56) or origSize
        TweenService:Create(Main, TweenInfo.new(0.25), {Size = target}):Play()
    end)

    GetKey.MouseButton1Click:Connect(function()
        local url = BASE .. "/getkey/"
        setStatus(tr("opening_br"), C.warn, C.warn)
        local ok = openBrowser(url)
        if ok then setStatus(tr("br_opened"), C.success, C.success)
        else setStatus(tr("br_copied"), C.warn, C.warn) end
    end)

    Submit.MouseButton1Click:Connect(function()
        local key = Input.Text
        if #key < 8 then
            setStatus(tr("key_short"), C.danger, C.danger)
            return
        end
        setStatus(tr("verifying"), C.warn, C.warn)
        Submit.BackgroundColor3 = C.bg2

        local valid, exp = validateKey(key)

        Submit.BackgroundColor3 = C.accent

        if valid == nil then
            setStatus(exp == "no_response" and tr("no_response") or tr("invalid_resp"),
                C.danger, C.danger)
            return
        end
        if valid == false then
            setStatus(exp or tr("invalid_key"), C.danger, C.danger)
            return
        end

        saveKey(key, exp)
        setStatus(tr("success"), C.success, C.success)
        task.wait(0.4)
        Gui:Destroy()
        _G.__gk_showlist(key)
    end)

    fadeIn(Main)
end

-- ═══════════════════════════════════════════════════════
--   SCREEN 2 — SCRIPT LIST
-- ═══════════════════════════════════════════════════════
local function showScriptList(key)
    local Gui = newGui("GankunzScripts")

    -- Heartbeat
    task.spawn(function()
        while Gui and Gui.Parent do
            pcall(function()
                game:HttpGet(BASE .. "/api/heartbeat.php?hwid=" .. HWID
                    .. "&name=" .. plr.Name .. "&key=" .. key)
            end)
            task.wait(30)
        end
    end)

    -- Announcement popup
    task.spawn(function()
        task.wait(0.5)
        local okA, rawA = pcall(function()
            return game:HttpGet(BASE .. "/api/announcement.php")
        end)
        if okA and rawA and rawA ~= "null" then
            local ann
            pcall(function() ann = HttpService:JSONDecode(rawA) end)
            if ann and ann.title then
                local Pop = mk("Frame", {
                    Size = UDim2.new(0, 360, 0, 160),
                    Position = UDim2.new(0.5, -180, 0, 20),
                    BackgroundColor3 = C.bg1, BorderSizePixel = 0, ZIndex = 100,
                }, Gui)
                corner(Pop, 12)
                stroke(Pop, C.accent, 2)

                mk("Frame", {
                    Size = UDim2.new(1, -32, 0, 1),
                    Position = UDim2.new(0, 16, 0, 0),
                    BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 102,
                }, Pop)

                mk("TextLabel", {
                    Size = UDim2.new(1, -30, 0, 22),
                    Position = UDim2.new(0, 16, 0, 14),
                    BackgroundTransparency = 1,
                    Text = "◆ " .. ann.title,
                    TextColor3 = C.accent,
                    Font = Enum.Font.GothamBold, TextSize = 14,
                    TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101,
                }, Pop)

                mk("TextLabel", {
                    Size = UDim2.new(1, -30, 0, 70),
                    Position = UDim2.new(0, 16, 0, 40),
                    BackgroundTransparency = 1,
                    Text = ann.message,
                    TextColor3 = C.text2,
                    Font = Enum.Font.Gotham, TextSize = 12,
                    TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left,
                    TextYAlignment = Enum.TextYAlignment.Top, ZIndex = 101,
                }, Pop)

                local OK = mk("TextButton", {
                    Size = UDim2.new(0, 90, 0, 30),
                    Position = UDim2.new(1, -106, 1, -42),
                    BackgroundColor3 = C.accent, Text = "OK",
                    TextColor3 = C.bg, Font = Enum.Font.GothamBold,
                    TextSize = 12, BorderSizePixel = 0, ZIndex = 101,
                }, Pop)
                corner(OK, 6)
                OK.MouseButton1Click:Connect(function() Pop:Destroy() end)
            end
        end
    end)

    -- Main window
    local W = mk("Frame", {
        Size = UDim2.new(0, 540, 0, 460),
        Position = UDim2.new(0.5, -270, 0.5, -230),
        BackgroundColor3 = C.bg1, BorderSizePixel = 0,
    }, Gui)
    corner(W, 12)
    stroke(W, C.border, 1)
    draggable(W)

    mk("Frame", {
        Size = UDim2.new(1, -32, 0, 1),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundColor3 = C.accent, BorderSizePixel = 0, ZIndex = 2,
    }, W)

    -- Header
    local Top = mk("Frame", {
        Size = UDim2.new(1, 0, 0, 60),
        BackgroundColor3 = C.bg1, BorderSizePixel = 0,
    }, W)
    corner(Top, 12)

    local LM = mk("Frame", {
        Size = UDim2.new(0, 26, 0, 26),
        Position = UDim2.new(0, 18, 0, 17),
        BackgroundColor3 = C.accent, BorderSizePixel = 0,
    }, Top)
    corner(LM, 6)
    mk("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "G", TextColor3 = C.bg,
        Font = Enum.Font.GothamBlack, TextSize = 15,
    }, LM)

    mk("TextLabel", {
        Size = UDim2.new(0, 200, 0, 20),
        Position = UDim2.new(0, 52, 0, 17),
        BackgroundTransparency = 1,
        Text = tr("script_lib"),
        TextColor3 = C.text, Font = Enum.Font.GothamBold,
        TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left,
    }, Top)

    -- Countdown timer label
    local CountLabel = mk("TextLabel", {
        Size = UDim2.new(0, 220, 0, 14),
        Position = UDim2.new(0, 52, 0, 36),
        BackgroundTransparency = 1,
        Text = tr("welcome") .. ", " .. plr.Name .. "  ·  loading...",
        TextColor3 = C.text3,
        Font = Enum.Font.Code, TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
    }, Top)

    -- Get expiration + countdown
    task.spawn(function()
        local expiry = nil
        local ok, raw = pcall(function()
            return game:HttpGet(BASE .. "/api/getkey.php?hwid=" .. HWID)
        end)
        if ok and raw then
            local res
            pcall(function() res = HttpService:JSONDecode(raw) end)
            if res and res.ok and res.exp then expiry = res.exp end
        end

        while Gui and Gui.Parent do
            local txt = tr("welcome") .. ", " .. plr.Name .. "  ·  "
            if expiry and expiry ~= "" and expiry ~= "null" then
                local expTime = nil
                pcall(function()
                    local y,m,d,H,M,S = expiry:match("(%d+)-(%d+)-(%d+) (%d+):(%d+):(%d+)")
                    if y then
                        expTime = os.time({year=tonumber(y), month=tonumber(m),
                            day=tonumber(d), hour=tonumber(H), min=tonumber(M), sec=tonumber(S)})
                    end
                end)
                if expTime then
                    local diff = expTime - os.time()
                    if diff <= 0 then
                        txt = txt .. "EXPIRED"
                    elseif diff > 86400 then
                        txt = txt .. string.format("%dd %dh %s", math.floor(diff/86400),
                            math.floor((diff % 86400) / 3600), tr("exp"))
                    elseif diff > 3600 then
                        txt = txt .. string.format("%dh %dm %s", math.floor(diff/3600),
                            math.floor((diff % 3600)/60), tr("exp"))
                    else
                        txt = txt .. string.format("%dm %ds %s", math.floor(diff/60),
                            diff % 60, tr("exp"))
                    end
                else
                    txt = txt .. expiry
                end
            else
                txt = txt .. "∞"
            end
            CountLabel.Text = txt
            task.wait(1)
        end
    end)

    -- Logout
    local Logout = mk("TextButton", {
        Size = UDim2.new(0, 60, 0, 22),
        Position = UDim2.new(1, -132, 0, 19),
        BackgroundColor3 = C.bg2, Text = tr("logout"),
        TextColor3 = C.danger, Font = Enum.Font.GothamBold,
        TextSize = 10, BorderSizePixel = 0, AutoButtonColor = false,
    }, Top)
    corner(Logout, 5)

    local Min2 = mk("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -66, 0, 19),
        BackgroundColor3 = C.bg2, Text = "−",
        TextColor3 = C.text3, Font = Enum.Font.GothamBold,
        TextSize = 14, BorderSizePixel = 0, AutoButtonColor = false,
    }, Top)
    corner(Min2, 5)

    local Close2 = mk("TextButton", {
        Size = UDim2.new(0, 22, 0, 22),
        Position = UDim2.new(1, -40, 0, 19),
        BackgroundColor3 = C.bg2, Text = "×",
        TextColor3 = C.text3, Font = Enum.Font.GothamBold,
        TextSize = 12, BorderSizePixel = 0, AutoButtonColor = false,
    }, Top)
    corner(Close2, 5)

    hover(Close2, C.bg2, C.danger)
    hover(Min2, C.bg2, C.bg3)
    hover(Logout, C.bg2, C.danger)
    Close2.MouseButton1Click:Connect(function() Gui:Destroy() end)
    Logout.MouseButton1Click:Connect(function()
        deleteKey()
        Logout.Text = "✓"
        task.wait(0.8)
        Gui:Destroy()
    end)

    -- Search
    local SW = mk("Frame", {
        Size = UDim2.new(1, -36, 0, 36),
        Position = UDim2.new(0, 18, 0, 72),
        BackgroundColor3 = C.bg, BorderSizePixel = 0,
    }, W)
    corner(SW, 7)
    stroke(SW, C.border, 1)

    mk("TextLabel", {
        Size = UDim2.new(0, 24, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = "◇", TextColor3 = C.accent,
        Font = Enum.Font.Gotham, TextSize = 14,
    }, SW)

    local Search = mk("TextBox", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 36, 0, 0),
        BackgroundTransparency = 1, Text = "",
        PlaceholderText = tr("search_ph"),
        PlaceholderColor3 = C.text4, TextColor3 = C.text,
        Font = Enum.Font.Code, TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left, ClearTextOnFocus = false,
    }, SW)

    -- Tabs
    local TabsRow = mk("ScrollingFrame", {
        Size = UDim2.new(1, -36, 0, 30),
        Position = UDim2.new(0, 18, 0, 116),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 0, CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = Enum.ScrollingDirection.X,
    }, W)
    mk("UIListLayout", {
        Padding = UDim.new(0, 6),
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, TabsRow)

    -- List
    local Scroll = mk("ScrollingFrame", {
        Size = UDim2.new(1, -36, 1, -216),
        Position = UDim2.new(0, 18, 0, 154),
        BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = C.border2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
    }, W)
    mk("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, Scroll)

    -- Load scripts
    local ok, raw = pcall(function()
        return game:HttpGet(BASE .. "/api/scripts.php?key=" .. key)
    end)

    if not ok or not raw then
        mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1, Text = "× " .. tr("load_fail"),
            TextColor3 = C.danger, Font = Enum.Font.Code, TextSize = 12,
        }, Scroll)
        return
    end

    local scripts = HttpService:JSONDecode(raw)

    if #scripts == 0 then
        local stillValid = validateKey(key)
        if stillValid == false then
            Gui:Destroy()
            deleteKey()
            task.wait(0.2)
            showKeySystem(tr("key_expired"))
            return
        end
        mk("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1, Text = tr("no_scripts"),
            TextColor3 = C.text3, Font = Enum.Font.Code, TextSize = 12,
        }, Scroll)
        return
    end

    -- Map tabs
    local maps = {}
    local mapSet = {}
    for _, s in ipairs(scripts) do
        local m = s.map or "Unknown"
        if not mapSet[m] then
            mapSet[m] = true
            table.insert(maps, m)
        end
    end

    local activeTab = "ALL"

    local function makeTab(name)
        local label = string.upper(name)
        local width = math.max(50, #label * 8 + 22)
        local tb = mk("TextButton", {
            Size = UDim2.new(0, width, 0, 28),
            BackgroundColor3 = (name == activeTab) and C.accent or C.bg2,
            Text = label,
            TextColor3 = (name == activeTab) and C.bg or C.text3,
            Font = Enum.Font.GothamBold, TextSize = 10,
            BorderSizePixel = 0, AutoButtonColor = false,
        }, TabsRow)
        corner(tb, 14)
        tb.MouseButton1Click:Connect(function()
            activeTab = name
            for _, o in ipairs(TabsRow:GetChildren()) do
                if o:IsA("TextButton") then
                    local a = o.Text == label
                    TweenService:Create(o, TweenInfo.new(0.2),
                        {BackgroundColor3 = a and C.accent or C.bg2}):Play()
                    TweenService:Create(o, TweenInfo.new(0.2),
                        {TextColor3 = a and C.bg or C.text3}):Play()
                end
            end
            for _, card in ipairs(Scroll:GetChildren()) do
                if card:IsA("Frame") then
                    local m = card:GetAttribute("map") or ""
                    card.Visible = (name == "ALL" or m == name)
                end
            end
        end)
        return tb
    end

    makeTab("ALL")
    for _, m in ipairs(maps) do makeTab(m) end

    -- Script cards
    for _, data in ipairs(scripts) do
        local Card = mk("Frame", {
            Size = UDim2.new(1, -6, 0, 60),
            BackgroundColor3 = C.bg2, BorderSizePixel = 0,
        }, Scroll)
        corner(Card, 8)
        stroke(Card, C.border, 1)
        Card:SetAttribute("map", data.map or "Unknown")

        -- Left accent strip
        local strip = mk("Frame", {
            Size = UDim2.new(0, 3, 0, 26),
            Position = UDim2.new(0, 0, 0.5, -13),
            BackgroundColor3 = C.accent, BorderSizePixel = 0,
        }, Card)
        corner(strip, 2)

        mk("TextLabel", {
            Size = UDim2.new(1, -140, 0, 20),
            Position = UDim2.new(0, 16, 0, 10),
            BackgroundTransparency = 1,
            Text = data.name or "Unnamed",
            TextColor3 = C.text, Font = Enum.Font.GothamBold,
            TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left,
        }, Card)

        mk("TextLabel", {
            Size = UDim2.new(1, -140, 0, 16),
            Position = UDim2.new(0, 16, 0, 30),
            BackgroundTransparency = 1,
            Text = "◆ " .. (data.map or "Unknown") ..
                "   " .. string.upper(data.tier or "FREE"),
            TextColor3 = C.text3, Font = Enum.Font.Code,
            TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left,
        }, Card)

        local Run = mk("TextButton", {
            Size = UDim2.new(0, 90, 0, 34),
            Position = UDim2.new(1, -102, 0.5, -17),
            BackgroundColor3 = C.accent, Text = tr("exec"),
            TextColor3 = C.bg, Font = Enum.Font.GothamBold,
            TextSize = 11, BorderSizePixel = 0, AutoButtonColor = false,
        }, Card)
        corner(Run, 6)
        hover(Run, C.accent, C.accentH)

        Run.MouseButton1Click:Connect(function()
            -- Log execute
            task.spawn(function()
                pcall(function()
                    game:HttpGet(BASE .. "/api/log_exec.php?hwid=" .. HWID
                        .. "&name=" .. HttpService:UrlEncode(data.name or "")
                        .. "&map=" .. HttpService:UrlEncode(data.map or "")
                        .. "&key=" .. key)
                end)
            end)

            Run.Text = "..."
            Run.BackgroundColor3 = C.bg3

            local ok2, src = pcall(function()
                return game:HttpGet(data.script_url)
            end)

            if not ok2 or not src then
                Run.Text = tr("error")
                Run.BackgroundColor3 = C.danger
                Run.TextColor3 = C.text
                task.wait(1.5)
                Run.Text = tr("exec")
                Run.BackgroundColor3 = C.accent
                Run.TextColor3 = C.bg
                return
            end

            local ok3, err = pcall(function() loadstring(src)() end)

            if ok3 then
                Run.Text = tr("ok")
                Run.BackgroundColor3 = C.success
                task.wait(0.8)
                Gui:Destroy()
            else
                Run.Text = tr("fail")
                Run.BackgroundColor3 = C.danger
                Run.TextColor3 = C.text
                warn("[Gankunz] " .. tostring(err))
                task.wait(1.5)
                Run.Text = tr("exec")
                Run.BackgroundColor3 = C.accent
                Run.TextColor3 = C.bg
            end
        end)
    end

    -- Search filter
    Search:GetPropertyChangedSignal("Text"):Connect(function()
        local q = string.lower(Search.Text)
        for _, card in ipairs(Scroll:GetChildren()) do
            if card:IsA("Frame") then
                local m = card:GetAttribute("map") or ""
                local txt = ""
                for _, c in ipairs(card:GetChildren()) do
                    if c:IsA("TextLabel") then
                        txt = txt .. string.lower(c.Text)
                    end
                end
                local mt = (activeTab == "ALL" or m == activeTab)
                local ms = (q == "" or string.find(txt, q, 1, true) ~= nil)
                card.Visible = mt and ms
            end
        end
    end)

    -- Minimize
    local min2 = false
    local orig2 = W.Size
    Min2.MouseButton1Click:Connect(function()
        min2 = not min2
        for _, d in ipairs(W:GetChildren()) do
            if d ~= Top and d:IsA("GuiObject") then d.Visible = not min2 end
        end
        local t = min2 and UDim2.new(0, 540, 0, 60) or orig2
        TweenService:Create(W, TweenInfo.new(0.25), {Size = t}):Play()
    end)

    fadeIn(W)
end

-- Register function globally for key system to call
_G.__gk_showlist = showScriptList

-- ═══════════════════════════════════════════════════════
--   AUTO-LOGIN
-- ═══════════════════════════════════════════════════════
task.spawn(function()
    print("[GANKUNZ] HWID: " .. HWID)

    -- 1) Cari key: file lokal -> memori executor -> server (berdasarkan HWID)
    local saved = loadKey()
    if saved and saved.key then
        print("[GANKUNZ] Local key found")
    else
        print("[GANKUNZ] Fetching from server...")
        local ok, raw = pcall(function()
            return game:HttpGet(BASE .. "/api/getkey.php?hwid=" .. HWID)
        end)
        if ok and raw then
            local res
            pcall(function() res = HttpService:JSONDecode(raw) end)
            if res and res.ok and res.key then
                print("[GANKUNZ] Server key found")
                saved = { key = res.key, exp = res.exp }
                saveKey(res.key, res.exp)
            end
        end
    end

    -- 2) Ada key -> validasi (retry kalau server lagi error, JANGAN hapus key)
    if saved and saved.key then
        local valid, exp
        for attempt = 1, 4 do
            valid, exp = validateKey(saved.key)
            if valid ~= nil then break end
            print("[GANKUNZ] Server error, retry " .. attempt .. "/4")
            task.wait(1.5)
        end

        if valid == true then
            print("[GANKUNZ] Valid -> script list")
            saveKey(saved.key, exp or saved.exp)
            showScriptList(saved.key)
            return
        elseif valid == false then
            -- Key benar-benar ditolak server (expired / tidak ada / HWID beda)
            print("[GANKUNZ] Invalid: " .. tostring(exp))
            deleteKey()
            task.wait(0.3)
            showKeySystem(tostring(exp or tr("key_expired")))
            return
        else
            -- Server tidak bisa dijangkau: key lokal TETAP disimpan
            print("[GANKUNZ] Server unreachable, key tetap disimpan")
            showKeySystem(tr("server_busy"))
            return
        end
    end

    print("[GANKUNZ] No key -> key system")
    showKeySystem(nil)
end)