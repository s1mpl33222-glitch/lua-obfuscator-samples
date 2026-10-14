local GAMES = {
    [6739698191] = {
        name      = "Violence District",
        universal = "https://api.luarmor.net/files/v4/loaders/fd07938aec8247d8116ff6ee06678abf.lua",
    },
    [10035204815] = {
        name      = "Ride a Pet",
        universal = "https://api.luarmor.net/files/v4/loaders/030a9bb5e9ff9b485a081421426b93a6.lua",
    },
    [10684750879] = {
        name      = "Loot To Forge",
        universal = "https://api.luarmor.net/files/v4/loaders/91e6113f02845af9c37d75809c1d4465.lua",
    },
    [10765288803] = {
        name      = "Break and Steal an Egg",
        universal = "https://api.luarmor.net/files/v4/loaders/a6490392771a63ea40e5819c2b72f790.lua",
    },
    [10512942223] = {
        name      = "Anime Zero",
        universal = "https://api.luarmor.net/files/v4/loaders/ef243ac23eec49ee6d0f2317ef23c0d6.lua",
    },
    [9051406594] = {
        name      = "Dueling Grounds",
        -- Bukan script Luarmor: stub dari server kita (/api/dg) yang memeriksa key + perangkat, lalu mengirim script.
        -- checkUrl menggantikan SDK Luarmor untuk menolak key salah/expired di panel Redeem.
        universal = "https://artheirs.xyz/api/dg",
        checkUrl  = "https://artheirs.xyz/api/dg/check?k=",
    },
}

-- Bahasa panel: English / Indonesia. Pilihan disimpan di LANG_FILE; kalau belum ada, ikut bahasa Roblox (id = Indonesia, selain itu English).
local LANG_FILE = "artheirs_free_lang.txt"
local STR = {
    en = {
        warn_nogame = "[ARTHEIRS FREE] This game is not available in the FREE version.\nUniverseId: %s · PlaceId: %s\nUpgrade to PAID for access to every supported game.",
        warn_noplatform = "[ARTHEIRS FREE] %s does not support the %s platform yet.\nJoin our Discord for updates.",
        warn_cancel = "[ARTHEIRS FREE] Key activation cancelled. Run again and enter your key.",
        bad_format = "Wrong key format. A key is 32 letters/numbers.",
        bad_incorrect = "Key not found or expired. Get a new key on Discord.",
        bad_expired = "This key has expired. Get a new key on Discord.",
        bad_hwid = "This key is locked to another device. One key works on one device only, get a new key on Discord.",
        bad_banned = "This key is blocked. Contact staff on Discord.",
        chip_off = "Not Active", chip_on = "Active", chip_bad = "Inactive", chip_expired = "Expired",
        placeholder = "Paste your key here (32 characters)",
        note_wait = "Waiting for key.",
        note_invalid = "Invalid key. It must be 32 letters/numbers.",
        note_checking = "Checking key...",
        note_accepted = "Key accepted. Loading script...",
        notif_rejected = "Key rejected",
        notif_active = "Key active",
        notif_loading = "Loading %s script...",
        notif_saved_bad = "Saved key is no longer valid",
        saved_bad = "Your saved key is no longer valid.",
        btn_redeem = "Redeem Key", btn_paste = "Paste from Clipboard", btn_cancel = "Cancel",
        btn_paste_short = "Paste", btn_join = "Join Discord",
        dc_title = "Discord", dc_join = "Join our Discord", dc_tap = "Tap to copy", dc_copied = "Copied",
        dc_fail = "Copy unavailable", dc_notif_ok = "Link copied: %s",
        howto_title = "How to Get a Key",
        step1h = "1. Join Discord", step1 = "Tap the Discord card below to copy the link, then open it in Discord.",
        step2h = "2. Get Free Key", step2 = "In the Freemium panel channel, press Get Free Key, pick Linkvertise or Lootlabs, and finish the steps until your key appears.",
        step3h = "3. Redeem Key", step3 = "Copy that key, paste it into the key box, then press Redeem Key. Only once per key.",
        step4h = "4. Run", step4 = "After that, just run the loadstring as usual without a key. When your key runs out, get a new one and this panel shows up again.",
        foot_validity = "Keys last 26 hours and lock to one device.",
        foot_games = "Freemium games:  %s",
        s_about_title = "ABOUT THE FREE KEY",
        s_about = "Freemium keys are free through a short ad step, last 26 hours, and lock to one device. When it runs out, get a new key the same way.",
        s_steps_title = "HOW TO GET A KEY",
        s_step1 = "Join the Artheirs Discord (the Join Discord button below copies the link).",
        s_step2 = "In the Freemium panel channel, press Get Free Key, pick Linkvertise or Lootlabs, and finish the steps until your key appears.",
        s_step3 = "Copy that key, paste it in the box below, then press Redeem Key. Only once per key.",
        s_step4 = "After that, just run the loadstring as usual without a key. When your key runs out, get a new one and this panel shows up again.",
        s_games_title = "FREEMIUM GAMES",
        s_help = "Need help? Ask in the #id-chat channel on the Artheirs Discord.",
        join_copied = "Discord link copied: %s", join_open = "Open our Discord: %s",
    },
    id = {
        warn_nogame = "[ARTHEIRS FREE] Game belum tersedia di versi FREE.\nUniverseId: %s · PlaceId: %s\nUpgrade ke PAID untuk akses semua game supported.",
        warn_noplatform = "[ARTHEIRS FREE] %s belum support platform %s.\nJoin Discord untuk update info.",
        warn_cancel = "[ARTHEIRS FREE] Aktivasi key dibatalkan. Jalankan lagi dan masukkan key kamu.",
        bad_format = "Format key salah. Key terdiri dari 32 huruf/angka.",
        bad_incorrect = "Key tidak ditemukan atau sudah kedaluwarsa. Ambil key baru di Discord.",
        bad_expired = "Key sudah kedaluwarsa. Ambil key baru di Discord.",
        bad_hwid = "Key ini terkunci ke perangkat lain. Satu key hanya untuk satu perangkat, ambil key baru di Discord.",
        bad_banned = "Key diblokir. Hubungi staff di Discord.",
        chip_off = "Belum Aktif", chip_on = "Aktif", chip_bad = "Tidak Aktif", chip_expired = "Kedaluwarsa",
        placeholder = "Tempel key kamu di sini (32 karakter)",
        note_wait = "Menunggu key.",
        note_invalid = "Key tidak valid. Harus 32 karakter huruf/angka.",
        note_checking = "Memeriksa key...",
        note_accepted = "Key diterima. Memuat script...",
        notif_rejected = "Key ditolak",
        notif_active = "Key aktif",
        notif_loading = "Memuat script %s...",
        notif_saved_bad = "Key tersimpan tidak berlaku",
        saved_bad = "Key tersimpan tidak berlaku lagi.",
        btn_redeem = "Redeem Key", btn_paste = "Paste dari Clipboard", btn_cancel = "Batal",
        btn_paste_short = "Paste", btn_join = "Join Discord",
        dc_title = "Discord", dc_join = "Gabung Discord kami", dc_tap = "Tap salin", dc_copied = "Tersalin",
        dc_fail = "Gagal salin", dc_notif_ok = "Link disalin: %s",
        howto_title = "Cara Dapat Key",
        step1h = "1. Join Discord", step1 = "Tap kartu Discord di bawah untuk menyalin link, lalu buka di Discord.",
        step2h = "2. Get Free Key", step2 = "Di channel panel Freemium, tekan Get Free Key, pilih Linkvertise atau Lootlabs, dan selesaikan langkahnya sampai key muncul.",
        step3h = "3. Redeem Key", step3 = "Salin key tadi, tempel di kolom Key, lalu tekan Redeem Key. Cukup sekali per key.",
        step4h = "4. Jalankan", step4 = "Setelah itu cukup jalankan loadstring seperti biasa tanpa key. Kalau key habis, ambil key baru dan panel ini muncul lagi.",
        foot_validity = "Key berlaku 26 jam dan terkunci ke satu perangkat.",
        foot_games = "Game Freemium:  %s",
        s_about_title = "TENTANG KEY GRATIS",
        s_about = "Key Freemium didapat gratis lewat iklan, berlaku 26 jam, dan terkunci ke satu perangkat. Setelah habis, ambil key baru dengan cara yang sama.",
        s_steps_title = "CARA DAPAT KEY",
        s_step1 = "Join Discord Artheirs (tombol Join Discord di bawah menyalin link-nya).",
        s_step2 = "Di channel panel Freemium, tekan Get Free Key lalu pilih Linkvertise atau Lootlabs dan selesaikan langkahnya sampai key muncul.",
        s_step3 = "Salin key tadi, tempel di kolom bawah, lalu tekan Redeem Key. Cukup sekali per key.",
        s_step4 = "Setelah itu cukup jalankan loadstring seperti biasa tanpa key. Kalau key habis, ambil key baru dan panel ini muncul lagi.",
        s_games_title = "GAME FREEMIUM",
        s_help = "Butuh bantuan? Tanya di channel #id-chat di Discord Artheirs.",
        join_copied = "Link Discord disalin: %s", join_open = "Buka Discord kami: %s",
    },
}
local lang = "en"
do
    local saved
    if isfile and readfile then
        pcall(function() if isfile(LANG_FILE) then saved = readfile(LANG_FILE) end end)
    end
    saved = type(saved) == "string" and saved:match("%a+") or nil
    if saved == "en" or saved == "id" then
        lang = saved
    else
        local okLoc, locale = pcall(function() return game:GetService("Players").LocalPlayer.LocaleId end)
        if okLoc and type(locale) == "string" and locale:sub(1, 2) == "id" then lang = "id" end
    end
end
local function tr(key, ...)
    local s = STR[lang][key] or STR.en[key] or key
    if select("#", ...) > 0 then return s:format(...) end
    return s
end
local function setLang(code)
    lang = code
    if writefile then pcall(writefile, LANG_FILE, code) end
end

local UIS       = game:GetService("UserInputService")
local IS_MOBILE = UIS.TouchEnabled and not UIS.MouseEnabled
local UNIVERSE  = game.GameId
local PLACE     = game.PlaceId

local gameDef = GAMES[UNIVERSE]
if not gameDef then
    warn(tr("warn_nogame", tostring(UNIVERSE), tostring(PLACE)))
    return
end

local loaderUrl
if gameDef.universal then
    loaderUrl = gameDef.universal
elseif IS_MOBILE then
    loaderUrl = gameDef.mobile
else
    loaderUrl = gameDef.pc
end

if not loaderUrl then
    warn(tr("warn_noplatform", gameDef.name, IS_MOBILE and "Mobile" or "PC"))
    return
end

-- Key: pakai script_key dari loader lengkap, atau key tersimpan di perangkat, atau minta lewat panel aktivasi (cukup sekali).
local KEY_FILE    = "artheirs_free_key.txt"
local DISCORD_URL = "https://discord.gg/artheirshub"
local SCRIPT_ID   = loaderUrl:match("loaders/(%w+)%.lua")
local env = (getgenv and getgenv()) or _G

local function cleanKey(raw)
    if type(raw) ~= "string" then return nil end
    -- toleran kalau user menempel seluruh baris loader, bukan hanya key-nya
    local k = raw:match("script_key%s*=%s*[\"']([%w]+)[\"']") or (raw:gsub("%s+", ""))
    if #k == 32 and not k:find("%W") then return k end
    return nil
end

local function readSaved()
    if not (isfile and readfile) then return nil end
    local ok, data = pcall(function()
        if isfile(KEY_FILE) then return readfile(KEY_FILE) end
    end)
    return ok and cleanKey(data) or nil
end

local function writeSaved(k)
    if writefile then pcall(writefile, KEY_FILE, k) end
end

local function deleteSaved()
    if delfile then pcall(function() if isfile(KEY_FILE) then delfile(KEY_FILE) end end) end
end

-- Cek status key lewat SDK publik Luarmor. Hanya kode pasti-salah yang ditolak;
-- gangguan jaringan/kode tak dikenal dibiarkan lolos supaya Luarmor yang memutuskan.
-- Nilai = kunci teks di STR (bukan teks jadi), supaya pesan ikut bahasa yang aktif saat ditampilkan.
local BAD_CODES = {
    KEY_INVALID = "bad_format",
    KEY_INCORRECT = "bad_incorrect",
    KEY_EXPIRED = "bad_expired",
    KEY_HWID_LOCKED = "bad_hwid",
    KEY_BANNED = "bad_banned",
    KEY_BLACKLISTED = "bad_banned",
}
local sdk
local function checkKey(key)
    if gameDef.checkUrl then
        local okc, body = pcall(function() return game:HttpGet(gameDef.checkUrl .. key) end)
        if not okc or type(body) ~= "string" then return "unknown" end
        if body == "valid" then return "valid" end
        local code = body:match("^bad:(%w+)")
        if code and BAD_CODES[code] then return "bad", BAD_CODES[code], code end
        return "unknown"
    end
    if not SCRIPT_ID then return "unknown" end
    local ok, st = pcall(function()
        sdk = sdk or loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
        sdk.script_id = SCRIPT_ID
        return sdk.check_key(key)
    end)
    if not ok or type(st) ~= "table" then return "unknown" end
    if st.code == "KEY_VALID" then return "valid" end
    if BAD_CODES[st.code] then return "bad", BAD_CODES[st.code], st.code end
    return "unknown"
end

local function copyText(text)
    local fn = setclipboard or toclipboard or (syn and syn.write_clipboard)
    if not fn then return false end
    return (pcall(fn, text))
end

-- Panel cadangan (Roblox UI polos), dipakai kalau MacLib gagal dimuat.
local function showSimplePanel(notice)
    local Players = game:GetService("Players")
    local gui = Instance.new("ScreenGui")
    gui.Name = "ArtheirsKey"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999

    local parent
    pcall(function() if gethui then parent = gethui() end end)
    if not parent then pcall(function() parent = game:GetService("CoreGui") end) end
    local ok = parent and pcall(function() gui.Parent = parent end)
    if not ok or not gui.Parent then
        gui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    local function make(class, props, par)
        local o = Instance.new(class)
        for p, v in pairs(props) do o[p] = v end
        o.Parent = par
        return o
    end
    local function round(o, r) make("UICorner", { CornerRadius = UDim.new(0, r) }, o) end

    local BG, PANEL = Color3.fromRGB(20, 8, 30), Color3.fromRGB(38, 20, 56)
    local ACCENT, ACCENT2 = Color3.fromRGB(152, 101, 230), Color3.fromRGB(187, 144, 242)
    local TXT, DIM = Color3.fromRGB(255, 255, 255), Color3.fromRGB(190, 170, 215)
    local GREEN, RED = Color3.fromRGB(92, 214, 140), Color3.fromRGB(255, 120, 130)

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
    local W, H = math.min(440, vp.X - 24), math.min(430, vp.Y - 24)

    local frame = make("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, W, 0, H), BackgroundColor3 = BG, BorderSizePixel = 0,
    }, gui)
    round(frame, 12)
    make("UIStroke", { Color = ACCENT, Thickness = 1.5 }, frame)

    -- Header (bisa digeser)
    local header = make("Frame", {
        Size = UDim2.new(1, 0, 0, 48), BackgroundTransparency = 1, Active = true,
    }, frame)
    make("TextLabel", {
        Position = UDim2.new(0, 14, 0, 6), Size = UDim2.new(1, -130, 0, 20), BackgroundTransparency = 1,
        Text = "ARTHEIRS  |  Freemium", Font = Enum.Font.GothamBold, TextSize = 15,
        TextColor3 = TXT, TextXAlignment = Enum.TextXAlignment.Left,
    }, header)
    make("TextLabel", {
        Position = UDim2.new(0, 14, 0, 26), Size = UDim2.new(1, -130, 0, 16), BackgroundTransparency = 1,
        Text = "Game: " .. gameDef.name, Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = DIM, TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd,
    }, header)
    local chip = make("Frame", {
        AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 13), Size = UDim2.new(0, 92, 0, 22),
        BackgroundColor3 = PANEL, BorderSizePixel = 0,
    }, header)
    round(chip, 11)
    local chipLabel = make("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = tr("chip_off"),
        Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = DIM,
    }, chip)
    local function setChip(text, color) chipLabel.Text = text chipLabel.TextColor3 = color end
    make("Frame", {
        Position = UDim2.new(0, 12, 0, 48), Size = UDim2.new(1, -24, 0, 1),
        BackgroundColor3 = PANEL, BorderSizePixel = 0,
    }, frame)

    -- Isi (bisa di-scroll di layar kecil)
    local content = make("ScrollingFrame", {
        Position = UDim2.new(0, 12, 0, 56), Size = UDim2.new(1, -24, 1, -196), BackgroundTransparency = 1,
        BorderSizePixel = 0, ScrollBarThickness = 3, ScrollBarImageColor3 = ACCENT,
        CanvasSize = UDim2.new(0, 0, 0, 0), AutomaticCanvasSize = Enum.AutomaticSize.Y,
    }, frame)
    make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, content)

    local order = 0
    local function nextOrder() order = order + 1 return order end
    local function sectionTitle(text)
        make("TextLabel", {
            Size = UDim2.new(1, -6, 0, 14), BackgroundTransparency = 1, Text = text, LayoutOrder = nextOrder(),
            Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = ACCENT2, TextXAlignment = Enum.TextXAlignment.Left,
        }, content)
    end
    local function card()
        local c = make("Frame", {
            Size = UDim2.new(1, -6, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundColor3 = PANEL,
            BorderSizePixel = 0, LayoutOrder = nextOrder(),
        }, content)
        round(c, 8)
        make("UIPadding", {
            PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10),
        }, c)
        make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, c)
        return c
    end
    local function bodyText(par, text, color, size)
        return make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            Text = text, Font = Enum.Font.Gotham, TextSize = size or 12, TextColor3 = color or DIM,
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
            LayoutOrder = nextOrder(),
        }, par)
    end

    sectionTitle(tr("s_about_title"))
    local about = card()
    bodyText(about, tr("s_about"), TXT)

    sectionTitle(tr("s_steps_title"))
    local steps = card()
    local stepTexts = { tr("s_step1"), tr("s_step2"), tr("s_step3"), tr("s_step4") }
    for i, t in ipairs(stepTexts) do
        local row = make("Frame", {
            Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
            LayoutOrder = i,
        }, steps)
        local badge = make("TextLabel", {
            Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(0, 20, 0, 20), BackgroundColor3 = ACCENT,
            BorderSizePixel = 0, Text = tostring(i), Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = TXT,
        }, row)
        round(badge, 10)
        make("TextLabel", {
            Position = UDim2.new(0, 28, 0, 0), Size = UDim2.new(1, -28, 0, 20), AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1, Text = t, Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = TXT,
            TextWrapped = true, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
        }, row)
    end

    local names = {}
    for _, g in pairs(GAMES) do names[#names + 1] = g.name end
    table.sort(names)
    sectionTitle(tr("s_games_title"))
    local gamesCard = card()
    bodyText(gamesCard, table.concat(names, "  •  "), TXT)
    bodyText(gamesCard, tr("s_help"), DIM, 11)

    -- Bagian bawah: aktivasi key
    local bottom = make("Frame", {
        Position = UDim2.new(0, 12, 1, -134), Size = UDim2.new(1, -24, 0, 128), BackgroundTransparency = 1,
    }, frame)
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16), BackgroundTransparency = 1, Text = tr("btn_redeem"),
        Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = TXT, TextXAlignment = Enum.TextXAlignment.Left,
    }, bottom)
    local box = make("TextBox", {
        Position = UDim2.new(0, 0, 0, 18), Size = UDim2.new(1, 0, 0, 34), BackgroundColor3 = PANEL,
        BorderSizePixel = 0, Text = "", PlaceholderText = tr("placeholder"),
        PlaceholderColor3 = DIM, TextColor3 = TXT, Font = Enum.Font.Code, TextSize = 14,
        ClearTextOnFocus = false, TextTruncate = Enum.TextTruncate.AtEnd,
    }, bottom)
    round(box, 8)
    local btnRow = make("Frame", {
        Position = UDim2.new(0, 0, 0, 58), Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1,
    }, bottom)
    local status = make("TextLabel", {
        Position = UDim2.new(0, 0, 0, 98), Size = UDim2.new(1, 0, 0, 30), BackgroundTransparency = 1, Text = "",
        Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = DIM, TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top,
    }, bottom)
    local function setStatus(text, color) status.Text = text status.TextColor3 = color or DIM end

    local canPaste = type(getclipboard) == "function"
    local layout = canPaste
        and { { "paste", 0.18 }, { "join", 0.27 }, { "ok", 0.37 }, { "cancel", 0.18 } }
        or  { { "join", 0.30 }, { "ok", 0.46 }, { "cancel", 0.24 } }
    local btns, x = {}, 0
    for _, e in ipairs(layout) do
        local primary = e[1] == "ok"
        local b = make("TextButton", {
            Position = UDim2.new(x, 0, 0, 0), Size = UDim2.new(e[2], -6, 1, 0),
            BackgroundColor3 = primary and ACCENT or PANEL, BorderSizePixel = 0,
            Text = ({ paste = tr("btn_paste_short"), join = tr("btn_join"), ok = tr("btn_redeem"), cancel = tr("btn_cancel") })[e[1]],
            Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = (e[1] == "cancel") and DIM or TXT,
            AutoButtonColor = true,
        }, btnRow)
        round(b, 8)
        btns[e[1]] = b
        x = x + e[2]
    end

    if notice then
        setChip(tr(notice.chip or "chip_expired"), RED)
        setStatus(notice.text(), RED)
    else
        setStatus(tr("note_wait"), DIM)
    end

    -- Geser jendela lewat header
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging, dragStart, startPos = true, i.Position, frame.Position
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    local dragConn = UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)

    local result, done, busy = nil, false, false
    local function submit()
        if busy then return end
        local k = cleanKey(box.Text)
        if not k then
            setStatus(tr("note_invalid"), RED)
            return
        end
        busy = true
        setStatus(tr("note_checking"), DIM)
        task.spawn(function()
            local state, msgKey = checkKey(k)
            if state == "bad" then
                setChip(tr("chip_bad"), RED)
                setStatus(tr(msgKey), RED)
                busy = false
                return
            end
            setChip(tr("chip_on"), GREEN)
            setStatus(tr("note_accepted"), GREEN)
            task.wait(0.8)
            result, done = k, true
        end)
    end

    if btns.paste then
        btns.paste.MouseButton1Click:Connect(function()
            local ok2, clip = pcall(getclipboard)
            if ok2 and type(clip) == "string" then box.Text = clip end
        end)
    end
    btns.join.MouseButton1Click:Connect(function()
        if copyText(DISCORD_URL) then
            setStatus(tr("join_copied", (DISCORD_URL:gsub("https://", ""))), GREEN)
        else
            setStatus(tr("join_open", (DISCORD_URL:gsub("https://", ""))), DIM)
        end
    end)
    btns.ok.MouseButton1Click:Connect(submit)
    box.FocusLost:Connect(function(enter) if enter then submit() end end)
    btns.cancel.MouseButton1Click:Connect(function() done = true end)

    repeat task.wait() until done
    dragConn:Disconnect()
    gui:Destroy()
    return result
end

-- Panel utama: MacLibArtheirs (library UI yang sama dengan hub script). Mengembalikan (key) atau (nil, true) bila perlu cadangan.
local MACLIB_URL = "https://artheirs.xyz/api/ui"

local function colorText(text, hex)
    return string.format('<font color="%s">%s</font>', hex, text)
end

local function showMacPanel(notice)
    local okLib, Lib = pcall(function() return loadstring(game:HttpGet(MACLIB_URL))() end)
    if not okLib or type(Lib) ~= "table" or type(Lib.Window) ~= "function" then return nil, true end

    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local scale = math.clamp(math.min(vp.X * 0.92 / 660, vp.Y * 0.88 / 504, 1), 0.4, 1)

    local okWin, Window = pcall(function()
        return Lib:Window({
            Title = "Artheirs",
            Subtitle = "Freemium  |  " .. gameDef.name,
            Size = UDim2.fromOffset(660, 504),
            DragStyle = 1,
            Compact = true,
            ShowUserInfo = false,
            Keybind = Enum.KeyCode.RightShift,
            AcrylicBlur = false,
        })
    end)
    if not okWin or type(Window) ~= "table" then return nil, true end
    pcall(function() Window:SetScale(scale) end)

    local RED, GREEN, DIM = "#FF7882", "#5CD68C", "#BEAAD7"
    local result, done, busy = nil, false, false
    Window.onUnloaded(function() done = true end)

    local built = pcall(function()
        -- Tanpa sidebar, nama tab tampil sebagai judul di bar atas.
        local tab = Window:TabGroup():Tab({ Name = "Artheirs  |  Freemium" })
        local left = tab:Section({ Side = "Left" })
        local right = tab:Section({ Side = "Right" })

        -- Semua teks yang bergantung bahasa didaftarkan di sini; setLangAndRefresh() menulis ulang semuanya.
        local refreshers = {}
        local function onRefresh(fn) refreshers[#refreshers + 1] = fn end

        -- Pilihan bahasa (English | Indonesia): dua tombol kecil di bar atas, di kanan judul tab.
        local PURPLE = Color3.fromRGB(152, 101, 230)
        local langButtons = {}
        local function paintLang()
            for code, b in pairs(langButtons) do
                local on = code == lang
                b.BackgroundColor3 = on and PURPLE or Color3.fromRGB(255, 255, 255)
                b.BackgroundTransparency = on and 0.15 or 0.94
                b.TextColor3 = on and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 156, 176)
            end
        end
        local function buildLangPicker()
            local bar, titleLbl
            pcall(function()
                titleLbl = right.Instance:FindFirstAncestor("Content"):FindFirstChild("CurrentTab", true)
                bar = titleLbl.Parent
            end)
            local row = Instance.new("Frame")
            row.Name = "LanguagePicker"
            row.BackgroundTransparency = 1
            row.BorderSizePixel = 0
            if bar then
                row.AnchorPoint = Vector2.new(0, 0.5)
                row.Position = UDim2.new(0, titleLbl.Position.X.Offset + titleLbl.TextBounds.X + 16, 0.5, 0)
                row.Size = UDim2.fromOffset(150, 26)
                row.Parent = bar
            else
                -- Bar atas tidak ditemukan: taruh di paling atas kolom kanan.
                row.LayoutOrder = -1
                row.Size = UDim2.new(1, 0, 0, 30)
                row.Parent = right.Instance
            end
            for i, opt in ipairs({ { "en", "English" }, { "id", "Indonesia" } }) do
                local b = Instance.new("TextButton")
                b.Name = opt[1]
                b.AutoButtonColor = false
                b.Text = opt[2]
                b.Font = Enum.Font.GothamBold
                b.TextSize = 12
                b.BorderSizePixel = 0
                b.Position = UDim2.new((i - 1) * 0.5, i == 2 and 2 or 0, 0, 0)
                b.Size = UDim2.new(0.5, -2, 1, 0)
                b.Parent = row
                local c = Instance.new("UICorner")
                c.CornerRadius = UDim.new(0, 8)
                c.Parent = b
                b.Activated:Connect(function()
                    if opt[1] == lang then return end
                    setLang(opt[1])
                    paintLang()
                    for _, f in ipairs(refreshers) do pcall(f) end
                end)
                langButtons[opt[1]] = b
            end
            paintLang()
        end

        left:Header({ Name = "Redeem Key" })
        left:SubLabel({ Text = "Game: " .. gameDef.name })
        local statusLabel = left:Label({ Text = "" })
        -- Kotak key besar: tanpa label nama ("Key" ikut terpotong jadi "K..." di kolom sempit), lebar penuh, tinggi 38px.
        local input = left:Input({
            Name = "",
            Placeholder = tr("placeholder"),
            AcceptedCharacters = "All",
        })
        pcall(function()
            local frame = left.Instance:FindFirstChild("Input")
            local nameLbl, box = frame.InputName, frame.InputBox
            nameLbl.Visible = false
            local constraint = box:FindFirstChildOfClass("UISizeConstraint")
            if constraint then constraint.Parent = nil end
            box.AutomaticSize = Enum.AutomaticSize.None
            box.AnchorPoint = Vector2.new(0, 0.5)
            box.Position = UDim2.fromScale(0, 0.5)
            box.Size = UDim2.new(1, 0, 0, 38)
            box.TextSize = 14
            box.TextXAlignment = Enum.TextXAlignment.Left
            box.TextTransparency = 0
            box.ClearTextOnFocus = false
            box.PlaceholderColor3 = Color3.fromRGB(140, 146, 168)
            box.BackgroundTransparency = 0.9
            local corner = box:FindFirstChildOfClass("UICorner")
            if corner then corner.CornerRadius = UDim.new(0, 8) end
            local pad = box:FindFirstChildOfClass("UIPadding")
            if pad then
                pad.PaddingLeft = UDim.new(0, 8)
                pad.PaddingRight = UDim.new(0, 8)
            end
            local stroke = box:FindFirstChildOfClass("UIStroke")
            if stroke then
                stroke.Color = PURPLE
                stroke.Thickness = 1.5
                stroke.Transparency = 0.55
                box.Focused:Connect(function() stroke.Transparency = 0 end)
                box.FocusLost:Connect(function() stroke.Transparency = 0.55 end)
            end
        end)
        local note = left:SubLabel({ Text = "" })

        local chipKey, chipHex = "chip_off", RED
        local noteSrc, noteHex = "note_wait", DIM
        local function renderChip()
            statusLabel:UpdateName("Status:  " .. colorText(tr(chipKey), chipHex))
        end
        local function renderNote()
            local text = type(noteSrc) == "function" and noteSrc() or tr(noteSrc)
            note:UpdateName(colorText(text, noteHex))
        end
        -- setChip/setNote menerima kunci STR (atau fungsi yang mengembalikan teks) agar ikut berganti bahasa.
        local function setChip(keyName, hex) chipKey, chipHex = keyName, hex renderChip() end
        local function setNote(src, hex) noteSrc, noteHex = src, hex or DIM renderNote() end
        renderChip()
        renderNote()
        onRefresh(renderChip)
        onRefresh(renderNote)
        onRefresh(function() input:UpdatePlaceholder(tr("placeholder")) end)

        local function submit()
            if busy then return end
            local k = cleanKey(input:GetInput())
            if not k then
                setNote("note_invalid", RED)
                return
            end
            busy = true
            setNote("note_checking", DIM)
            task.spawn(function()
                local state, msgKey = checkKey(k)
                if state == "bad" then
                    setChip("chip_bad", RED)
                    setNote(function() return tr(msgKey) end, RED)
                    Window:Notify({ Title = tr("notif_rejected"), Description = tr(msgKey), Lifetime = 6 })
                    busy = false
                    return
                end
                setChip("chip_on", GREEN)
                setNote("note_accepted", GREEN)
                Window:Notify({ Title = tr("notif_active"), Description = tr("notif_loading", gameDef.name), Lifetime = 4 })
                task.wait(0.9)
                result = k
                pcall(function() Window:Unload() end)
                done = true
            end)
        end

        local redeemBtn = left:Button({ Name = tr("btn_redeem"), Callback = submit })
        onRefresh(function() redeemBtn:UpdateName(tr("btn_redeem")) end)
        if type(getclipboard) == "function" then
            local pasteBtn = left:Button({ Name = tr("btn_paste"), Callback = function()
                local ok2, clip = pcall(getclipboard)
                if ok2 and type(clip) == "string" then input:UpdateText(clip) end
            end })
            onRefresh(function() pasteBtn:UpdateName(tr("btn_paste")) end)
        end
        local cancelBtn = left:Button({ Name = tr("btn_cancel"), Callback = function()
            result = nil
            pcall(function() Window:Unload() end)
            done = true
        end })
        onRefresh(function() cancelBtn:UpdateName(tr("btn_cancel")) end)

        -- Kartu Discord (paling bawah): sekali tap = salin link (pola sama dengan dashboard script lain)
        do
            local SHOW = DISCORD_URL:gsub("https://", "")
            local BLURPLE = Color3.fromRGB(88, 101, 242)
            local btn = Instance.new("TextButton")
            btn.Name = "DiscordCard"
            btn.AutoButtonColor = false
            btn.Text = ""
            btn.BackgroundColor3 = Color3.fromRGB(23, 25, 35)
            btn.BorderSizePixel = 0
            btn.Size = UDim2.new(1, 0, 0, 52)
            btn.Parent = left.Instance
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 12)
            corner.Parent = btn
            local stroke = Instance.new("UIStroke")
            stroke.Color = BLURPLE
            stroke.Transparency = 0.85
            stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            stroke.Parent = btn
            local badge = Instance.new("ImageLabel")
            badge.BackgroundColor3 = BLURPLE
            badge.BorderSizePixel = 0
            badge.Image = "rbxthumb://type=Asset&id=10367063084&w=150&h=150"
            badge.ScaleType = Enum.ScaleType.Fit
            badge.Position = UDim2.fromOffset(12, 10)
            badge.Size = UDim2.fromOffset(32, 32)
            badge.Parent = btn
            local bc = Instance.new("UICorner")
            bc.CornerRadius = UDim.new(0, 9)
            bc.Parent = badge
            local function label(text, size, font, color, x, y, w)
                local l = Instance.new("TextLabel")
                l.BackgroundTransparency = 1
                l.Text = text
                l.TextSize = size
                l.Font = font
                l.TextColor3 = color
                l.TextXAlignment = Enum.TextXAlignment.Left
                l.Position = UDim2.fromOffset(x, y)
                l.Size = UDim2.new(0, w, 0, size + 4)
                l.Parent = btn
                return l
            end
            local joinLbl = label(tr("dc_join"), 11, Enum.Font.GothamMedium, Color3.fromRGB(137, 144, 164), 56, 10, 150)
            label(SHOW, 15, Enum.Font.GothamBold, Color3.fromRGB(238, 241, 250), 56, 25, 170)
            local hint = label(tr("dc_tap"), 11, Enum.Font.GothamMedium, BLURPLE, 0, 19, 90)
            hint.AnchorPoint = Vector2.new(1, 0)
            hint.Position = UDim2.new(1, -14, 0, 19)
            hint.TextXAlignment = Enum.TextXAlignment.Right
            onRefresh(function()
                joinLbl.Text = tr("dc_join")
                hint.Text = tr("dc_tap")
                hint.TextColor3 = BLURPLE
            end)
            btn.Activated:Connect(function()
                if copyText(DISCORD_URL) then
                    hint.Text = tr("dc_copied")
                    hint.TextColor3 = Color3.fromRGB(92, 214, 140)
                    Window:Notify({ Title = tr("dc_title"), Description = tr("dc_notif_ok", SHOW), Lifetime = 3 })
                else
                    hint.Text = tr("dc_fail")
                    hint.TextColor3 = Color3.fromRGB(255, 120, 130)
                    Window:Notify({ Title = tr("dc_title"), Description = SHOW, Lifetime = 6 })
                end
                task.delay(1.6, function()
                    if hint.Parent then
                        hint.Text = tr("dc_tap")
                        hint.TextColor3 = BLURPLE
                    end
                end)
            end)
        end

        local howto = right:Header({ Name = tr("howto_title") })
        onRefresh(function() howto:UpdateName(tr("howto_title")) end)
        for i = 1, 4 do
            local p = right:Paragraph({ Header = tr("step" .. i .. "h"), Body = tr("step" .. i) })
            onRefresh(function()
                p:UpdateHeader(tr("step" .. i .. "h"))
                p:UpdateBody(tr("step" .. i))
            end)
        end
        right:Divider()

        local names = {}
        for _, g in pairs(GAMES) do names[#names + 1] = g.name end
        table.sort(names)
        local gamesList = table.concat(names, "  •  ")
        local footA = right:SubLabel({ Text = tr("foot_validity") })
        local footB = right:SubLabel({ Text = tr("foot_games", gamesList) })
        onRefresh(function()
            footA:UpdateName(tr("foot_validity"))
            footB:UpdateName(tr("foot_games", gamesList))
        end)

        if notice then
            setChip(notice.chip, RED)
            setNote(notice.text, RED)
            Window:Notify({ Title = tr("notif_saved_bad"), Description = notice.text(), Lifetime = 7 })
        end
        tab:Select()
        -- Dibuat setelah Select agar judul tab sudah terisi (lebar teksnya dipakai untuk menaruh pilihan bahasa).
        task.defer(function()
            task.wait()
            pcall(buildLangPicker)
        end)
    end)
    if not built then
        pcall(function() Window:Unload() end)
        return nil, true
    end

    repeat task.wait() until done
    return result
end

local function showPanel(notice)
    local k, fallback = showMacPanel(notice)
    if fallback then return showSimplePanel(notice) end
    return k
end

local key
local provided = cleanKey(env.script_key) or cleanKey(script_key)
if provided then
    -- Alur lama (loader lengkap dari Get Script): tetap jalan; key hanya disimpan kalau tidak jelas-jelas salah.
    key = provided
    if readSaved() ~= key and (checkKey(key)) ~= "bad" then writeSaved(key) end
else
    local saved = readSaved()
    if saved then
        local state, msgKey, code = checkKey(saved)
        if state == "bad" and code ~= "KEY_HWID_LOCKED" then
            -- Key tersimpan memang salah/expired/diblokir: hapus dan minta redeem ulang.
            deleteSaved()
            saved = nil
            key = showPanel({ chip = "chip_expired", text = function() return tr("saved_bad") .. " " .. tr(msgKey) end })
        else
            -- Key masih berlaku (atau cek HWID dari SDK saja yang menolak): jangan hapus key & jangan tampilkan panel Redeem.
            -- Keputusan HWID tetap di loader Luarmor di bawah; kalau memang terkunci, user cukup Reset HWID di Discord.
            if state == "bad" then
                warn("[ARTHEIRS FREE] " .. tr(msgKey))
                pcall(function()
                    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "ARTHEIRS", Text = tr(msgKey), Duration = 8 })
                end)
            end
            key = saved
        end
    else
        key = showPanel()
    end
    if not key then
        warn(tr("warn_cancel"))
        return
    end
    if readSaved() ~= key then writeSaved(key) end
end
env.script_key = key
script_key = key

loadstring(game:HttpGet(loaderUrl))()
