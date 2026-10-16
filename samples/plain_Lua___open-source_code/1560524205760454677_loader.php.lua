-- ===========================================
--   KEY SERVER LOADER (Get Key 24h)
--   loadstring(game:HttpGet("...loader.php"))()
-- ===========================================

local VERIFY_API = "https://robloxscriptbest.com/script/api/verify.php"
local GETKEY_API = "https://robloxscriptbest.com/script/api/getkey_api.php"
local SCRIPT_SLUG = "chilliv5beta"
local UI_THEME = "theme07"
local FOLDER = "KeyServer"
local KEYFILE = FOLDER .. "/key.txt"

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui     = game:GetService("CoreGui")

-- ============ FILE I/O (khai bao som de getHwid() co the dung hasFs) ============
local hasFs = (writefile and readfile and isfile and isfolder and makefolder) and true or false

local function ensureFolder()
    if hasFs and not isfolder(FOLDER) then
        pcall(function() makefolder(FOLDER) end)
    end
end

-- ============ HWID ============
-- Chien luoc lay HWID theo thu tu uu tien:
-- 1. API native cua executor (gethwid, syn.get_hwid, ...)
-- 2. RbxAnalyticsService ClientId (Roblox built-in, kha on dinh)
-- 3. Fingerprint tong hop tu UserId + PlaceId + JobId (duy nhat per session)
-- 4. Persist fingerprint vao file de on dinh qua cac lan chay

local HWID_FILE = FOLDER .. "/hwid.dat"

local function isValidId(v)
    if not v then return false end
    local s = tostring(v):gsub("%s+", "")
    return s ~= "" and s ~= "nil" and s ~= "0" and s ~= "false" and s ~= "null" and #s >= 4
end

local function getHwid()
    -- [Buoc 1] Thu API native cua cac executor pho bien
    local id = nil

    -- gethwid (Wave, Delta, Fluxus, etc.)
    if not id then pcall(function()
        if type(gethwid) == "function" then
            local v = gethwid()
            if isValidId(v) then id = tostring(v) end
        end
    end) end

    -- Synapse X
    if not id then pcall(function()
        if syn and type(syn.get_hwid) == "function" then
            local v = syn.get_hwid()
            if isValidId(v) then id = tostring(v) end
        end
    end) end

    -- KRNL / Electron
    if not id then pcall(function()
        if type(get_hwid) == "function" then
            local v = get_hwid()
            if isValidId(v) then id = tostring(v) end
        end
    end) end

    -- Electron / misc executors
    if not id then pcall(function()
        if type(getdeviceid) == "function" then
            local v = getdeviceid()
            if isValidId(v) then id = tostring(v) end
        end
    end) end

    -- [Buoc 2] RbxAnalyticsService ClientId - Roblox built-in, on dinh tren session
    if not id then pcall(function()
        local v = game:GetService("RbxAnalyticsService"):GetClientId()
        if isValidId(v) then id = "RC-" .. tostring(v) end
    end) end

    -- [Buoc 3] Kiem tra file hwid da luu (fingerprint cu on dinh hon)
    if not id and hasFs and isfile(HWID_FILE) then
        pcall(function()
            local saved = readfile(HWID_FILE):gsub("%s+", "")
            if isValidId(saved) and #saved >= 8 then
                id = saved
            end
        end)
    end

    -- [Buoc 4] Tao fingerprint tong hop neu van chua co
    if not id then
        local parts = {}
        local uid = LocalPlayer.UserId
        if uid and uid ~= 0 then
            parts[#parts+1] = tostring(uid)
        end
        pcall(function()
            -- PlaceId giup phân biệt giữa các game khác nhau
            parts[#parts+1] = tostring(game.PlaceId)
        end)
        pcall(function()
            -- JobId la UUID duy nhat per server instance
            -- Chi lay 12 ky tu dau de tao fingerprint ngan gon
            local jid = tostring(game.JobId)
            if jid and jid ~= "" then
                parts[#parts+1] = jid:sub(1, 12):gsub("-", "")
            end
        end)
        pcall(function()
            -- GameId / UniverseId
            local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
            if info then
                parts[#parts+1] = tostring(info.AssetId or "")
            end
        end)
        if #parts >= 1 then
            id = "FP-" .. table.concat(parts, "-")
        end
    end

    -- [Buoc 5] Fallback cuoi cung: UserId (luon co, chi duy nhat theo tai khoan)
    if not id then
        local uid = LocalPlayer.UserId
        if uid and uid ~= 0 then
            id = "UID-" .. tostring(uid)
        else
            -- Absolute worst case: random + tick (khong on dinh nhung it nhat khong bi loi)
            id = "RND-" .. tostring(math.random(100000000, 999999999)) .. "-" .. string.format("%.0f", tick())
        end
    end

    -- Luu lai vao file de lan sau dung (neu chua co hoac khac)
    if hasFs then pcall(function()
        ensureFolder()
        local existing = ""
        if isfile(HWID_FILE) then
            existing = (readfile(HWID_FILE) or ""):gsub("%s+", "")
        end
        -- Chi luu neu chua co file, hoac file hien tai la RND- (khong on dinh)
        if existing == "" or existing:sub(1, 4) == "RND-" then
            writefile(HWID_FILE, id)
        else
            -- Dung gia tri cu neu no on dinh hon
            if existing:sub(1, 4) ~= "RND-" and isValidId(existing) and #existing >= 8 then
                id = existing
            end
        end
    end) end

    return id
end

-- ============ FILE I/O ============
-- (hasFs va ensureFolder da duoc khai bao phia tren, truoc getHwid)

local function loadKey()
    if not hasFs then return nil end
    if isfile(KEYFILE) then
        local ok, k = pcall(readfile, KEYFILE)
        if ok and k and k ~= "" then return k:gsub("^%s+",""):gsub("%s+$","") end
    end
end

local function saveKey(k)
    if not hasFs then return end
    ensureFolder()
    pcall(function() writefile(KEYFILE, k) end)
end

local function clearKey()
    if hasFs and isfile(KEYFILE) then pcall(function() delfile(KEYFILE) end) end
end

-- ============ HTTP ============
local function httpGet(url)
    warn("[LOADER] GET " .. url)
    local ok, raw = pcall(function() return game:HttpGet(url, true) end)
    if not ok then
        warn("[LOADER] GET error: " .. tostring(raw))
        return nil
    end
    if ok and raw then
        local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
        if ok2 then
            warn("[LOADER] GET success")
            return data
        else
            warn("[LOADER] GET JSON decode fail: " .. tostring(data))
        end
    end
    return nil
end

local function httpPost(url, payload)
    warn("[LOADER] POST " .. url .. " body=" .. HttpService:JSONEncode(payload))
    local body = HttpService:JSONEncode(payload)
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok, res = pcall(function()
            return req({
                Url = url, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" }, Body = body,
            })
        end)
        if not ok then
            warn("[LOADER] POST request error: " .. tostring(res))
        elseif res and res.Body then
            warn("[LOADER] POST response body len=" .. tostring(#res.Body))
            local ok2, data = pcall(HttpService.JSONDecode, HttpService, res.Body)
            if ok2 then
                warn("[LOADER] POST JSON success")
                return data
            else
                warn("[LOADER] POST JSON decode fail: " .. tostring(data))
            end
        else
            warn("[LOADER] POST no body, status=" .. tostring(res and res.StatusCode or "nil"))
        end
    else
        warn("[LOADER] POST no request fn, fallback to GET")
    end
    -- fallback GET
    local q = url .. "?key=" .. HttpService:UrlEncode(payload.key or "") ..
              "&hwid=" .. HttpService:UrlEncode(payload.hwid or "") ..
              "&action=" .. HttpService:UrlEncode(payload.action or "")
    return httpGet(q)
end

-- ============ CRYPTO (SHA256 + HMAC) ============
-- Pure-Lua SHA256 cho Roblox (Luau khong co crypto built-in)
local _band, _bor, _bxor, _bnot = bit32.band, bit32.bor, bit32.bxor, bit32.bnot
local _lshift, _rshift, _rrotate = bit32.lshift, bit32.rshift, bit32.rrotate

local SHA_K = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local function sha256(msg)
    local h = {0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
    local L = #msg
    msg = msg .. "\128"
    while #msg % 64 ~= 56 do msg = msg .. "\0" end
    local bitlen = L * 8
    msg = msg .. string.char(0,0,0,0,
        _band(_rshift(bitlen,24),0xff),
        _band(_rshift(bitlen,16),0xff),
        _band(_rshift(bitlen,8),0xff),
        _band(bitlen,0xff))
    for chunk = 1, #msg, 64 do
        local w = {}
        for i = 0, 15 do
            local off = chunk + i*4
            w[i+1] = _bor(
                _lshift(string.byte(msg, off), 24),
                _lshift(string.byte(msg, off+1), 16),
                _lshift(string.byte(msg, off+2), 8),
                string.byte(msg, off+3))
        end
        for i = 17, 64 do
            local s0 = _bxor(_rrotate(w[i-15],7), _rrotate(w[i-15],18), _rshift(w[i-15],3))
            local s1 = _bxor(_rrotate(w[i-2],17), _rrotate(w[i-2],19), _rshift(w[i-2],10))
            w[i] = _band(w[i-16] + s0 + w[i-7] + s1, 0xffffffff)
        end
        local a,b,c,d,e,f,g,hh = h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]
        for i = 1, 64 do
            local S1 = _bxor(_rrotate(e,6), _rrotate(e,11), _rrotate(e,25))
            local ch = _bxor(_band(e,f), _band(_bnot(e),g))
            local t1 = _band(hh + S1 + ch + SHA_K[i] + w[i], 0xffffffff)
            local S0 = _bxor(_rrotate(a,2), _rrotate(a,13), _rrotate(a,22))
            local mj = _bxor(_band(a,b), _band(a,c), _band(b,c))
            local t2 = _band(S0 + mj, 0xffffffff)
            hh = g; g = f; f = e
            e = _band(d + t1, 0xffffffff)
            d = c; c = b; b = a
            a = _band(t1 + t2, 0xffffffff)
        end
        h[1]=_band(h[1]+a,0xffffffff); h[2]=_band(h[2]+b,0xffffffff)
        h[3]=_band(h[3]+c,0xffffffff); h[4]=_band(h[4]+d,0xffffffff)
        h[5]=_band(h[5]+e,0xffffffff); h[6]=_band(h[6]+f,0xffffffff)
        h[7]=_band(h[7]+g,0xffffffff); h[8]=_band(h[8]+hh,0xffffffff)
    end
    -- Tra ve raw 32 bytes
    local out = {}
    for i = 1, 8 do
        out[#out+1] = string.char(
            _band(_rshift(h[i],24),0xff),
            _band(_rshift(h[i],16),0xff),
            _band(_rshift(h[i],8),0xff),
            _band(h[i],0xff))
    end
    return table.concat(out)
end

local function hmac_sha256_raw(key, msg)
    if #key > 64 then key = sha256(key) end
    if #key < 64 then key = key .. string.rep("\0", 64 - #key) end
    local opad, ipad = {}, {}
    for i = 1, 64 do
        local b = string.byte(key, i)
        opad[i] = string.char(_bxor(b, 0x5c))
        ipad[i] = string.char(_bxor(b, 0x36))
    end
    return sha256(table.concat(opad) .. sha256(table.concat(ipad) .. msg))
end

local function hmac_sha256_hex(key, msg)
    local raw = hmac_sha256_raw(key, msg)
    local hex = {}
    for i = 1, #raw do hex[i] = string.format("%02x", string.byte(raw, i)) end
    return table.concat(hex)
end

-- Base64 decode
local B64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local function b64dec(s)
    s = s:gsub("[^%a%d%+%/%=]", "")
    local out = {}
    for w in s:gmatch("....") do
        local n = 0
        for i = 1, 4 do
            local c = w:sub(i,i)
            if c == "=" then break end
            n = n * 64 + (B64:find(c) - 1)
        end
        local s4 = w:sub(4,4)
        local s3 = w:sub(3,3)
        if s3 ~= "=" then
            if s4 == "=" then
                out[#out+1] = string.char(_band(_rshift(n,10),0xff), _band(_rshift(n,2),0xff))
            else
                out[#out+1] = string.char(_band(_rshift(n,16),0xff), _band(_rshift(n,8),0xff), _band(n,0xff))
            end
        else
            out[#out+1] = string.char(_band(_rshift(n,4),0xff))
        end
    end
    return table.concat(out)
end

-- Decrypt payload tu server
local function decryptScript(enc_b64, nonce, ts, key, hwid, sig)
    local cipher = b64dec(enc_b64)
    local shared = key .. "|" .. hwid
    -- Verify HMAC sig truoc
    local expected_sig = hmac_sha256_hex(shared, cipher .. "|" .. nonce .. "|" .. ts)
    if expected_sig ~= sig then
        return nil, "Sai HMAC, payload da bi sua doi"
    end
    -- Sinh stream
    local stream_parts = {}
    local counter = 0
    local total = 0
    while total < #cipher do
        local block = hmac_sha256_raw(shared, nonce .. "|" .. ts .. "|" .. counter)
        stream_parts[#stream_parts+1] = block
        total = total + #block
        counter = counter + 1
    end
    local stream = table.concat(stream_parts):sub(1, #cipher)
    -- XOR
    local out = {}
    for i = 1, #cipher do
        out[i] = string.char(_bxor(string.byte(cipher, i), string.byte(stream, i)))
    end
    return table.concat(out)
end

-- Helper run script (decrypt + watchdog check key)
local function runScriptResponse(res, key, hwid)
    local source
    if res.enc and res.nonce and res.ts and res.sig then
        local plain, err = decryptScript(res.enc, res.nonce, res.ts, key, hwid, res.sig)
        if not plain then
            error("Decrypt fail: " .. tostring(err))
        end
        source = plain
    elseif res.script then
        source = res.script -- backward compat
    else
        error("Server không trả về script")
    end

    -- WATCHDOG: kiem tra key con valid moi 5 phut, kick neu het han
    -- Bo qua FREE mode (khong co key thuc)
    if key and key ~= "FREE" and key ~= "" then
        task.spawn(function()
            local fail_count = 0
            while true do
                task.wait(300) -- 5 phut
                local check = httpPost(VERIFY_API, { key = key, hwid = hwid, action = "verify", script = SCRIPT_SLUG })
                if check and check.ok then
                    fail_count = 0 -- reset
                else
                    fail_count = fail_count + 1
                    -- Code = expired/banned/invalid/hwid_mismatch -> kick ngay
                    if check and (check.code == "expired" or check.code == "banned" or check.code == "hwid_mismatch" or check.code == "invalid") then
                        clearKey()
                        notify("Key Server", "Key đã hết hạn hoặc không hợp lệ. Kick sau 5s.", 8)
                        task.wait(5)
                        pcall(function()
                            LocalPlayer:Kick("[Key Server] " .. tostring((check and check.message) or "Key hết hạn") .. "\n\nVui lòng chạy lại loader để lấy key mới.")
                        end)
                        break
                    end
                    -- Server loi network 3 lan lien tiep -> warn nhung khong kick
                    if fail_count >= 3 then
                        notify("Key Server", "Không kết nối được server. Sẽ thử lại...", 5)
                    end
                end
            end
        end)
    end

    local fn, err = loadstring(source)
    if not fn then
        warn("[LOADER] loadstring fail: " .. tostring(err))
        error(err)
    end
    -- Pcall script execution de crash khong xoa key
    local ok, scriptErr = pcall(fn)
    if not ok then
        warn("[LOADER] Script crashed: " .. tostring(scriptErr))
    end
    return ok, scriptErr
end

-- ============ NOTIFY ============
local function notify(title, text, dur)
    pcall(function()
        game.StarterGui:SetCore("SendNotification", {
            Title = title or "Key Server", Text = text or "", Duration = dur or 5,
        })
    end)
end

-- ============ COPY TO CLIPBOARD ============
local function setClipboard(s)
    local fn = setclipboard or (syn and syn.write_clipboard) or toclipboard or write_clipboard
    if fn then pcall(fn, s) end
end

-- ============ UI HELPER ============
local function mountGui()
    local gui = Instance.new("ScreenGui")
    gui.Name = "KeyServerUI_" .. tostring(math.random(1e6, 9e6))
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
    if gethui then
        pcall(function() gui.Parent = gethui() end)
    end
    if not gui.Parent then
        local ok = pcall(function() gui.Parent = CoreGui end)
        if not ok then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
    end
    return gui
end

local function makeCorner(parent, r) local c = Instance.new("UICorner", parent); c.CornerRadius = UDim.new(0, r or 12); return c end
-- ============ UI: GET KEY DIALOG ============
-- ============================================================
--  Theme engine for GetKey UI
--  Provides buildGetKeyUI(theme) -> showGetKeyUI function
--  Relies on injected globals: mountGui, makeCorner, setClipboard,
--  notify, httpPost, httpGet, HttpService, VERIFY_API, GETKEY_API, SCRIPT_SLUG
-- ============================================================

local function makeStroke(parent, color, thickness)
    local s = Instance.new("UIStroke", parent)
    s.Color = color
    s.Thickness = thickness or 1
    return s
end

local function makePad(parent, p)
    local pa = Instance.new("UIPadding", parent)
    pa.PaddingLeft = UDim.new(0, p)
    pa.PaddingRight = UDim.new(0, p)
    pa.PaddingTop = UDim.new(0, p)
    pa.PaddingBottom = UDim.new(0, p)
    return pa
end

local function col(c)
    if type(c) ~= "table" then
        return Color3.fromRGB(255, 255, 255)
    end
    return Color3.fromRGB(c.r or 255, c.g or 255, c.b or 255)
end

local function num(v, d)
    if type(v) == "number" then return v end
    return d
end

local function tbl(v, d)
    if type(v) == "table" then return v end
    return d
end

function buildGetKeyUI(theme)
    theme = theme or {}

    -- Default palette (fallback dark)
    local defaults = {
        bg = {r = 0, g = 0, b = 0},
        box = {r = 15, g = 20, b = 40},
        stroke = {r = 31, g = 38, b = 71},
        accent = {r = 99, g = 102, b = 241},
        success = {r = 34, g = 197, b = 94},
        text = {r = 231, g = 234, b = 246},
        muted = {r = 122, g = 133, b = 168},
        inputBg = {r = 7, g = 9, b = 26},
        statusBg = {r = 22, g = 28, b = 54},
        cancelBg = {r = 22, g = 28, b = 54},
        error = {r = 248, g = 113, b = 113},
    }

    local T = {}
    for k, v in pairs(defaults) do
        T[k] = col(tbl(theme[k], v))
    end

    T.bgTransparency = num(theme.bgTransparency, 0.5)
    T.boxTransparency = num(theme.boxTransparency, 0)
    T.strokeThickness = num(theme.strokeThickness, 1)

    local scale = num(theme.scale, 1)
    local fontScale = num(theme.fontScale, 1)

    local boxW = math.floor((theme.boxSize and (theme.boxSize.w or theme.boxSize[1]) or 360) * scale)
    local boxH = math.floor((theme.boxSize and (theme.boxSize.h or theme.boxSize[2]) or 320) * scale)

    local corner = num(theme.corner, 14)
    local tabCorner = num(theme.tabCorner, 8)
    local inputCorner = num(theme.inputCorner, 7)
    local btnCorner = num(theme.btnCorner, 7)
    local statusCorner = num(theme.statusCorner, 8)
    local cancelCorner = num(theme.cancelCorner, 6)

    local tabPosition = theme.tabPosition == "bottom" and "bottom" or "top"
    local showLogo = theme.showLogo ~= false
    local showHint = theme.showHint ~= false

    local title = tostring(theme.title or "Xác thực key")
    local subtitle = tostring(theme.subtitle or "Chọn cách nhận key")
    local freeTab = tostring(theme.freeTab or "⚡ Key Free")
    local manualTab = tostring(theme.manualTab or "🔑 Đã có key")

    -- Base sizes scaled by theme.scale
    local function sz(n) return math.floor(n * scale) end
    local function fs(n) return math.floor(n * fontScale) end

    return function(getkey_url, on_get_key, parent_hwid)
        local gui = mountGui()

        -- Background overlay
        local bg = Instance.new("Frame", gui)
        bg.Size = UDim2.fromScale(1, 1)
        bg.BackgroundColor3 = T.bg
        bg.BackgroundTransparency = T.bgTransparency
        bg.BorderSizePixel = 0

        -- Main box
        local box = Instance.new("Frame", bg)
        box.Size = UDim2.fromOffset(boxW, boxH)
        box.Position = UDim2.fromScale(0.5, 0.5)
        box.AnchorPoint = Vector2.new(0.5, 0.5)
        box.BackgroundColor3 = T.box
        box.BackgroundTransparency = T.boxTransparency
        box.BorderSizePixel = 0
        makeCorner(box, corner)
        if T.strokeThickness > 0 then
            makeStroke(box, T.stroke, T.strokeThickness)
        end

        local pad = sz(14)
        local spacing = sz(8)
        local logoSize = showLogo and sz(36) or 0
        local headerH = math.max(logoSize, sz(40))
        local tabH = sz(32)
        local cancelH = sz(28)
        local cancelY = boxH - pad - cancelH

        -- Header
        local titleX = pad
        local titleW = boxW - pad * 2

        if showLogo then
            local logo = Instance.new("Frame", box)
            logo.Size = UDim2.fromOffset(logoSize, logoSize)
            logo.Position = UDim2.fromOffset(pad, pad)
            logo.BackgroundColor3 = T.accent
            logo.BorderSizePixel = 0
            makeCorner(logo, math.floor(logoSize * 0.28))

            local logoTxt = Instance.new("TextLabel", logo)
            logoTxt.Size = UDim2.fromScale(1, 1)
            logoTxt.BackgroundTransparency = 1
            logoTxt.Font = Enum.Font.GothamBold
            logoTxt.TextSize = fs(math.max(14, math.floor(logoSize * 0.45)))
            logoTxt.TextColor3 = Color3.new(1, 1, 1)
            logoTxt.Text = "K"

            titleX = pad + logoSize + spacing
            titleW = boxW - titleX - pad
        end

        local ttl = Instance.new("TextLabel", box)
        ttl.Size = UDim2.new(0, titleW, 0, sz(18))
        ttl.Position = UDim2.fromOffset(titleX, pad)
        ttl.BackgroundTransparency = 1
        ttl.Font = Enum.Font.GothamBold
        ttl.TextSize = fs(14)
        ttl.TextColor3 = T.text
        ttl.TextXAlignment = Enum.TextXAlignment.Left
        ttl.Text = title

        local sub = Instance.new("TextLabel", box)
        sub.Size = UDim2.new(0, titleW, 0, sz(14))
        sub.Position = UDim2.fromOffset(titleX, pad + sz(18))
        sub.BackgroundTransparency = 1
        sub.Font = Enum.Font.Gotham
        sub.TextSize = fs(10)
        sub.TextColor3 = T.muted
        sub.TextXAlignment = Enum.TextXAlignment.Left
        sub.Text = subtitle

        -- Tab bar
        local tabBar = Instance.new("Frame", box)
        tabBar.Size = UDim2.new(0, boxW - pad * 2, 0, tabH)
        tabBar.Position = UDim2.fromOffset(pad, tabPosition == "top" and (pad + headerH + spacing) or (cancelY - tabH - spacing))
        tabBar.BackgroundColor3 = T.inputBg
        tabBar.BorderSizePixel = 0
        makeCorner(tabBar, tabCorner)

        local tabPad = sz(3)
        makePad(tabBar, tabPad)

        local tabLayout = Instance.new("UIListLayout", tabBar)
        tabLayout.FillDirection = Enum.FillDirection.Horizontal
        tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabLayout.Padding = UDim.new(0, sz(3))

        local function makeTabBtn(text, order)
            local b = Instance.new("TextButton", tabBar)
            b.Size = UDim2.new(0.5, -math.floor(sz(3) / 2), 1, 0)
            b.LayoutOrder = order
            b.BackgroundColor3 = T.inputBg
            b.BorderSizePixel = 0
            b.AutoButtonColor = false
            b.Font = Enum.Font.GothamBold
            b.TextSize = fs(11)
            b.TextColor3 = T.muted
            b.Text = text
            makeCorner(b, math.max(0, tabCorner - 2))
            return b
        end

        local tabFree = makeTabBtn(freeTab, 1)
        local tabManual = makeTabBtn(manualTab, 2)

        -- Content area
        local contentY, contentH
        if tabPosition == "top" then
            contentY = pad + headerH + spacing + tabH + spacing
            contentH = cancelY - contentY - spacing
        else
            contentY = pad + headerH + spacing
            contentH = cancelY - tabH - spacing * 2 - contentY
        end

        local content = Instance.new("Frame", box)
        content.Size = UDim2.new(0, boxW - pad * 2, 0, math.max(sz(80), contentH))
        content.Position = UDim2.fromOffset(pad, contentY)
        content.BackgroundTransparency = 1
        content.BorderSizePixel = 0

        -- Free panel
        local freePanel = Instance.new("Frame", content)
        freePanel.Size = UDim2.fromScale(1, 1)
        freePanel.BackgroundTransparency = 1

        local urlLabel = Instance.new("TextLabel", freePanel)
        urlLabel.Size = UDim2.new(1, 0, 0, sz(12))
        urlLabel.BackgroundTransparency = 1
        urlLabel.Font = Enum.Font.Gotham
        urlLabel.TextSize = fs(10)
        urlLabel.TextColor3 = T.muted
        urlLabel.TextXAlignment = Enum.TextXAlignment.Left
        urlLabel.Text = "Mở URL này trên trình duyệt"

        local urlBox = Instance.new("TextBox", freePanel)
        urlBox.Size = UDim2.new(1, 0, 0, sz(30))
        urlBox.Position = UDim2.fromOffset(0, sz(14))
        urlBox.BackgroundColor3 = T.inputBg
        urlBox.BorderSizePixel = 0
        urlBox.TextColor3 = T.accent
        urlBox.Font = Enum.Font.Code
        urlBox.TextSize = fs(10)
        urlBox.Text = getkey_url
        urlBox.ClearTextOnFocus = false
        urlBox.TextXAlignment = Enum.TextXAlignment.Left
        urlBox.TextTruncate = Enum.TextTruncate.AtEnd
        makeCorner(urlBox, inputCorner)
        makePad(urlBox, sz(10))
        if T.strokeThickness > 0 then
            makeStroke(urlBox, T.stroke, math.max(1, math.floor(T.strokeThickness * 0.8)))
        end

        local copyBtn = Instance.new("TextButton", freePanel)
        copyBtn.Size = UDim2.new(1, 0, 0, sz(32))
        copyBtn.Position = UDim2.fromOffset(0, sz(50))
        copyBtn.BackgroundColor3 = T.accent
        copyBtn.BorderSizePixel = 0
        copyBtn.Font = Enum.Font.GothamBold
        copyBtn.TextSize = fs(12)
        copyBtn.TextColor3 = Color3.new(1, 1, 1)
        copyBtn.Text = "SAO CHÉP URL"
        makeCorner(copyBtn, btnCorner)

        local statusBox = Instance.new("Frame", freePanel)
        statusBox.Size = UDim2.new(1, 0, 0, sz(48))
        statusBox.Position = UDim2.fromOffset(0, sz(92))
        statusBox.BackgroundColor3 = T.statusBg
        statusBox.BorderSizePixel = 0
        makeCorner(statusBox, statusCorner)

        local spinner = Instance.new("TextLabel", statusBox)
        spinner.Size = UDim2.fromOffset(sz(28), sz(28))
        spinner.Position = UDim2.fromOffset(sz(10), sz(10))
        spinner.BackgroundTransparency = 1
        spinner.Font = Enum.Font.GothamBold
        spinner.TextSize = fs(18)
        spinner.TextColor3 = T.accent
        spinner.Text = "⟳"

        local statusText = Instance.new("TextLabel", statusBox)
        statusText.Size = UDim2.new(1, -sz(52), 0, sz(16))
        statusText.Position = UDim2.fromOffset(sz(46), sz(8))
        statusText.BackgroundTransparency = 1
        statusText.Font = Enum.Font.GothamBold
        statusText.TextSize = fs(11)
        statusText.TextColor3 = T.text
        statusText.TextXAlignment = Enum.TextXAlignment.Left
        statusText.Text = "Đang chờ checkpoint..."

        local statusSub = Instance.new("TextLabel", statusBox)
        statusSub.Size = UDim2.new(1, -sz(52), 0, sz(14))
        statusSub.Position = UDim2.fromOffset(sz(46), sz(26))
        statusSub.BackgroundTransparency = 1
        statusSub.Font = Enum.Font.Gotham
        statusSub.TextSize = fs(10)
        statusSub.TextColor3 = T.muted
        statusSub.TextXAlignment = Enum.TextXAlignment.Left
        statusSub.Text = "Kiểm tra mỗi 5s"

        -- Manual panel
        local manualPanel = Instance.new("Frame", content)
        manualPanel.Size = UDim2.fromScale(1, 1)
        manualPanel.BackgroundTransparency = 1
        manualPanel.Visible = false

        local mLabel = Instance.new("TextLabel", manualPanel)
        mLabel.Size = UDim2.new(1, 0, 0, sz(12))
        mLabel.BackgroundTransparency = 1
        mLabel.Font = Enum.Font.Gotham
        mLabel.TextSize = fs(10)
        mLabel.TextColor3 = T.muted
        mLabel.TextXAlignment = Enum.TextXAlignment.Left
        mLabel.Text = "Dán key bản quyền của bạn"

        local keyInput = Instance.new("TextBox", manualPanel)
        keyInput.Size = UDim2.new(1, 0, 0, sz(36))
        keyInput.Position = UDim2.fromOffset(0, sz(14))
        keyInput.BackgroundColor3 = T.inputBg
        keyInput.BorderSizePixel = 0
        keyInput.TextColor3 = T.text
        keyInput.Font = Enum.Font.Code
        keyInput.TextSize = fs(13)
        keyInput.Text = ""
        keyInput.PlaceholderText = "HUB-XXXX-XXXX-XXXX"
        keyInput.PlaceholderColor3 = T.muted
        keyInput.ClearTextOnFocus = false
        keyInput.TextXAlignment = Enum.TextXAlignment.Center
        makeCorner(keyInput, inputCorner)
        makePad(keyInput, sz(10))
        if T.strokeThickness > 0 then
            makeStroke(keyInput, T.stroke, math.max(1, math.floor(T.strokeThickness * 0.8)))
        end

        local confirmBtn = Instance.new("TextButton", manualPanel)
        confirmBtn.Size = UDim2.new(1, 0, 0, sz(36))
        confirmBtn.Position = UDim2.fromOffset(0, sz(56))
        confirmBtn.BackgroundColor3 = T.success
        confirmBtn.BorderSizePixel = 0
        confirmBtn.Font = Enum.Font.GothamBold
        confirmBtn.TextSize = fs(12)
        confirmBtn.TextColor3 = Color3.new(1, 1, 1)
        confirmBtn.Text = "ĐĂNG NHẬP"
        makeCorner(confirmBtn, btnCorner)

        local mStatus = Instance.new("TextLabel", manualPanel)
        mStatus.Size = UDim2.new(1, 0, 0, sz(14))
        mStatus.Position = UDim2.fromOffset(0, sz(100))
        mStatus.BackgroundTransparency = 1
        mStatus.Font = Enum.Font.Gotham
        mStatus.TextSize = fs(10)
        mStatus.TextColor3 = T.error
        mStatus.TextXAlignment = Enum.TextXAlignment.Center
        mStatus.Text = ""

        local mHint
        if showHint then
            mHint = Instance.new("TextLabel", manualPanel)
            mHint.Size = UDim2.new(1, 0, 0, sz(28))
            mHint.Position = UDim2.fromOffset(0, sz(122))
            mHint.BackgroundTransparency = 1
            mHint.Font = Enum.Font.Gotham
            mHint.TextSize = fs(10)
            mHint.TextColor3 = T.muted
            mHint.TextWrapped = true
            mHint.TextXAlignment = Enum.TextXAlignment.Center
            mHint.Text = "Key VIP đã mua. Mỗi key gắn 1 máy, không share được."
        end

        -- Cancel button
        local cancelBtn = Instance.new("TextButton", box)
        cancelBtn.Size = UDim2.new(0, boxW - pad * 2, 0, cancelH)
        cancelBtn.Position = UDim2.fromOffset(pad, cancelY)
        cancelBtn.BackgroundColor3 = T.cancelBg
        cancelBtn.BorderSizePixel = 0
        cancelBtn.Font = Enum.Font.Gotham
        cancelBtn.TextSize = fs(11)
        cancelBtn.TextColor3 = T.muted
        cancelBtn.Text = "Hủy"
        makeCorner(cancelBtn, cancelCorner)

        -- Tab switch logic
        local function setActiveTab(tab)
            if tab == "free" then
                tabFree.BackgroundColor3 = T.accent
                tabFree.TextColor3 = Color3.new(1, 1, 1)
                tabManual.BackgroundColor3 = T.inputBg
                tabManual.TextColor3 = T.muted
                freePanel.Visible = true
                manualPanel.Visible = false
            else
                tabManual.BackgroundColor3 = T.accent
                tabManual.TextColor3 = Color3.new(1, 1, 1)
                tabFree.BackgroundColor3 = T.inputBg
                tabFree.TextColor3 = T.muted
                freePanel.Visible = false
                manualPanel.Visible = true
            end
        end
        setActiveTab("free")

        tabFree.MouseButton1Click:Connect(function() setActiveTab("free") end)
        tabManual.MouseButton1Click:Connect(function() setActiveTab("manual") end)

        -- Free logic
        local function resetCopyBtn()
            if copyBtn.Parent then
                copyBtn.Text = "SAO CHÉP URL"
                copyBtn.BackgroundColor3 = T.accent
            end
        end

        copyBtn.MouseButton1Click:Connect(function()
            setClipboard(getkey_url)
            copyBtn.Text = "✓ ĐÃ SAO CHÉP"
            copyBtn.BackgroundColor3 = T.success
            task.delay(1.5, resetCopyBtn)
        end)

        setClipboard(getkey_url)
        copyBtn.Text = "✓ ĐÃ SAO CHÉP TỰ ĐỘNG"
        copyBtn.BackgroundColor3 = T.success
        task.delay(2, resetCopyBtn)

        -- Spinner
        local spinning = true
        task.spawn(function()
            local angle = 0
            while spinning and spinner.Parent do
                angle = angle + 12
                spinner.Rotation = angle
                task.wait(0.04)
            end
        end)

        -- Manual logic
        local result_key = nil
        local cancelled = false

        local function doConfirm()
            local k = (keyInput.Text or ""):gsub("%s+", "")
            if #k < 4 then
                mStatus.TextColor3 = T.error
                mStatus.Text = "Vui lòng nhập key"
                return
            end
            -- Kiem tra hwid hop le truoc khi gui len server
            local hwid_ok = parent_hwid and parent_hwid ~= "" and parent_hwid ~= "nil" and parent_hwid ~= "0"
            if not hwid_ok then
                mStatus.TextColor3 = T.error
                mStatus.Text = "Lỗi: Không lấy được HWID - thử restart executor"
                return
            end
            confirmBtn.Text = "Đang xác thực..."
            confirmBtn.Active = false
            confirmBtn.BackgroundColor3 = T.muted
            mStatus.TextColor3 = T.accent
            mStatus.Text = "Đang kiểm tra với server..."

            local res = httpPost(VERIFY_API, {
                key = k, hwid = parent_hwid, action = "verify", script = SCRIPT_SLUG
            })
            if res and res.ok then
                mStatus.TextColor3 = T.success
                mStatus.Text = "✓ Key hợp lệ! Hạn: " .. tostring(res.time_left or "")
                confirmBtn.BackgroundColor3 = T.success
                confirmBtn.Text = "✓ THÀNH CÔNG"
                task.wait(0.8)
                spinning = false
                result_key = k
                gui:Destroy()
                on_get_key(k)
            else
                mStatus.TextColor3 = T.error
                mStatus.Text = "✗ " .. tostring((res and res.message) or "Key không hợp lệ")
                confirmBtn.Text = "ĐĂNG NHẬP"
                confirmBtn.Active = true
                confirmBtn.BackgroundColor3 = T.success
            end
        end

        confirmBtn.MouseButton1Click:Connect(doConfirm)

        cancelBtn.MouseButton1Click:Connect(function()
            cancelled = true
            spinning = false
            gui:Destroy()
        end)

        -- Polling
        local tries = 0
        while not cancelled and not result_key do
            task.wait(5)
            if cancelled or result_key then break end
            tries = tries + 1

            local res = httpGet(GETKEY_API .. "?hwid=" .. HttpService:UrlEncode(parent_hwid) .. "&script=" .. HttpService:UrlEncode(SCRIPT_SLUG))
            if res and res.has_key and res.key then
                keyInput.Text = res.key
                statusText.Text = "Đã nhận key, tự động đăng nhập..."
                statusSub.Text = "Vui lòng chờ"
                setActiveTab("manual")
                task.wait(0.5)
                doConfirm()
                return
            end

            if res and statusSub.Parent then
                local progress = res.cp_progress or 0
                local total = res.cp_total or 2
                statusSub.Text = "CP: " .. progress .. "/" .. total .. "  ·  Lần: " .. tries
            end
        end

        spinning = false
        if not result_key then
            error("Đã hủy lấy key")
        end
    end
end
-- Theme: ocean
local THEME = {
    boxSize = {w = 330, h = 300},
    scale = 0.85,
    fontScale = 1,

    bg = {r=0, g=0, b=0},
    box = {r=27, g=46, b=55},
    stroke = {r=67, g=97, b=112},
    accent = {r=62, g=176, b=234},
    success = {r=34, g=197, b=94},
    text = {r=231, g=234, b=246},
    muted = {r=122, g=131, b=159},
    inputBg = {r=17, g=28, b=34},
    statusBg = {r=40, g=61, b=72},
    cancelBg = {r=40, g=61, b=72},
    error = {r=248, g=113, b=113},

    bgTransparency = 0.5,
    boxTransparency = 0,
    strokeThickness = 1,

    corner = 12,
    tabCorner = 12,
    inputCorner = 12,
    btnCorner = 12,
    statusCorner = 12,
    cancelCorner = 12,

    tabPosition = "top",
    showLogo = false,
    showHint = true,

    title = "Xác thực key",
    subtitle = "Chọn cách nhận key",
    freeTab = "⚡ Key Free",
    manualTab = "🔑 Đã có key",
}
showGetKeyUI = buildGetKeyUI(THEME)
-- ============ MAIN FLOW ============
ensureFolder()
local hwid = getHwid()
-- getHwid() da xu ly fallback day du, chi can bao ve them truong hop edge case
if not hwid or hwid == "" or hwid == "nil" or hwid == "0" then
    local uid = LocalPlayer.UserId
    if uid and uid ~= 0 then
        hwid = "USR-" .. tostring(uid)
    else
        hwid = "RND-" .. tostring(math.random(100000, 999999)) .. "-" .. tostring(tick())
    end
end

-- Buoc 1: Kiem tra key da luu
local saved = loadKey()
if saved then
    local res = httpPost(VERIFY_API, { key = saved, hwid = hwid, action = "load", script = SCRIPT_SLUG })
    if res and res.ok then
        notify("Key Server", "Đã xác thực · " .. tostring(res.time_left or ""), 4)
        return runScriptResponse(res, saved, hwid)
    end
    clearKey()
end

-- Buoc 2: Kiem tra session (free mode hoac auto)
local sess = httpGet(GETKEY_API .. "?hwid=" .. HttpService:UrlEncode(hwid) .. "&script=" .. HttpService:UrlEncode(SCRIPT_SLUG))

-- ============ FREE MODE ============
-- Admin tat getkey -> user vao thang, khong can key
if sess and sess.mode == "free" then
    notify("Key Server", "Free mode - không cần key", 3)
    local res = httpPost(VERIFY_API, { hwid = hwid, action = "load_free", script = SCRIPT_SLUG })
    if res and res.ok then
        return runScriptResponse(res, "FREE", hwid)
    else
        error((res and res.message) or "Không thể load script (free mode)")
    end
end

-- ============ AUTO MODE - DA CO KEY ============
if sess and sess.has_key and sess.key then
    saveKey(sess.key)
    local res = httpPost(VERIFY_API, { key = sess.key, hwid = hwid, action = "load", script = SCRIPT_SLUG })
    if res and res.ok then
    notify("Key Server", "Đã xác thực · " .. tostring(res.time_left or ""), 4)
        return runScriptResponse(res, sess.key, hwid)
    end
end

-- Buoc 3: Hien UI lay key
local getkey_url = (sess and sess.getkey_url) or "https://robloxscriptbest.com/script/getkey.php?hwid=" .. HttpService:UrlEncode(hwid) .. "&script=" .. HttpService:UrlEncode(SCRIPT_SLUG)
notify("Key Server", "Vui lòng lấy key trên trang web", 6)

showGetKeyUI(getkey_url, function(key)
    saveKey(key)
    local res = httpPost(VERIFY_API, { key = key, hwid = hwid, action = "load", script = SCRIPT_SLUG })
    if res and res.ok then
        notify("Key Server", "Đã xác thực · " .. tostring(res.time_left or ""), 4)
        return runScriptResponse(res, key, hwid)
    else
        error((res and res.message) or "Không thể tải script")
    end
end, hwid)
