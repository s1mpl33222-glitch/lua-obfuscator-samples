-- cutrr loader

local function cutrr_crypto()
    local POW = { [0] = 1 }
    for i = 1, 32 do POW[i] = POW[i - 1] * 2 end

    local band, bor, bxor, bnot, rshift, lshift
    if bit32 then
        band, bor, bxor, rshift, lshift, bnot =
            bit32.band, bit32.bor, bit32.bxor, bit32.rshift, bit32.lshift, bit32.bnot
    else
        -- Integer floor-division (//) keeps every result an exact integer, which
        -- string.pack requires; plain / would yield floats.
        local function tobit(a, b, op)
            local r, p = 0, 1
            for _ = 1, 32 do
                local x, y = a % 2, b % 2
                if op(x, y) == 1 then r = r + p end
                a = (a - x) // 2
                b = (b - y) // 2
                p = p * 2
            end
            return r
        end
        band = function(a, b) return tobit(a, b, function(x, y) return (x == 1 and y == 1) and 1 or 0 end) end
        bor = function(a, b) return tobit(a, b, function(x, y) return (x == 1 or y == 1) and 1 or 0 end) end
        bxor = function(a, b) return tobit(a, b, function(x, y) return (x ~= y) and 1 or 0 end) end
        bnot = function(a) return 4294967295 - a end
        rshift = function(a, n) return a // POW[n] end
        lshift = function(a, n) return (a % POW[32 - n]) * POW[n] end
    end
    local function rrotate(x, n) return bor(rshift(x, n), lshift(x, 32 - n)) end

    local K = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2,
    }

    local function sha256(msg)
        local h0,h1,h2,h3 = 0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a
        local h4,h5,h6,h7 = 0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19
        local len = #msg
        msg = msg .. "\x80"
        while #msg % 64 ~= 56 do msg = msg .. "\0" end
        -- 64-bit big-endian bit length (message length fits well under 2^53).
        local bits = len * 8
        local function wordBytes(v)
            return string.char((v // 16777216) % 256, (v // 65536) % 256, (v // 256) % 256, v % 256)
        end
        msg = msg .. wordBytes(bits // 4294967296) .. wordBytes(bits % 4294967296)

        for chunk = 1, #msg, 64 do
            local w = {}
            for i = 1, 16 do
                local p = chunk + (i - 1) * 4
                local b1, b2, b3, b4 = msg:byte(p, p + 3)
                w[i] = b1 * 16777216 + b2 * 65536 + b3 * 256 + b4
            end
            for i = 17, 64 do
                local a = w[i - 15]
                local b = w[i - 2]
                local s0 = bxor(bxor(rrotate(a, 7), rrotate(a, 18)), rshift(a, 3))
                local s1 = bxor(bxor(rrotate(b, 17), rrotate(b, 19)), rshift(b, 10))
                w[i] = (w[i - 16] + s0 + w[i - 7] + s1) % 4294967296
            end
            local a,b,c,d,e,f,g,hh = h0,h1,h2,h3,h4,h5,h6,h7
            for i = 1, 64 do
                local S1 = bxor(bxor(rrotate(e, 6), rrotate(e, 11)), rrotate(e, 25))
                local ch = bxor(band(e, f), band(bnot(e), g))
                local t1 = (hh + S1 + ch + K[i] + w[i]) % 4294967296
                local S0 = bxor(bxor(rrotate(a, 2), rrotate(a, 13)), rrotate(a, 22))
                local maj = bxor(bxor(band(a, b), band(a, c)), band(b, c))
                local t2 = (S0 + maj) % 4294967296
                hh = g; g = f; f = e; e = (d + t1) % 4294967296
                d = c; c = b; b = a; a = (t1 + t2) % 4294967296
            end
            h0 = (h0 + a) % 4294967296; h1 = (h1 + b) % 4294967296
            h2 = (h2 + c) % 4294967296; h3 = (h3 + d) % 4294967296
            h4 = (h4 + e) % 4294967296; h5 = (h5 + f) % 4294967296
            h6 = (h6 + g) % 4294967296; h7 = (h7 + hh) % 4294967296
        end
        local function wordBytes(v)
            return string.char((v // 16777216) % 256, (v // 65536) % 256, (v // 256) % 256, v % 256)
        end
        return wordBytes(h0) .. wordBytes(h1) .. wordBytes(h2) .. wordBytes(h3)
            .. wordBytes(h4) .. wordBytes(h5) .. wordBytes(h6) .. wordBytes(h7)
    end

    local b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #b64 do lookup[b64:sub(i, i)] = i - 1 end
    local function b64decode(data)
        data = data:gsub("[^" .. b64 .. "]", "")
        local out, bits, nbits = {}, 0, 0
        for i = 1, #data do
            bits = bits * 64 + lookup[data:sub(i, i)]
            nbits = nbits + 6
            if nbits >= 8 then
                nbits = nbits - 8
                out[#out + 1] = string.char((bits // POW[nbits]) % 256)
                -- Keep only the unread bits so the number never outgrows a double's 53-bit precision.
                bits = bits % POW[nbits]
            end
        end
        return table.concat(out)
    end

    -- Rebuild the keystream and XOR it over the ciphertext.
    local function decrypt(key, nonce, payload)
        local cipher = b64decode(payload)
        local out, counter, ks, ksPos = {}, 0, "", 1
        for i = 1, #cipher do
            if ksPos > #ks then
                ks = sha256(key .. ":" .. nonce .. ":" .. counter)
                counter = counter + 1
                ksPos = 1
            end
            out[i] = string.char(bxor(cipher:byte(i), ks:byte(ksPos)))
            ksPos = ksPos + 1
        end
        return table.concat(out)
    end

    return { decrypt = decrypt }
end

local BASE = "https://cutrr.xyz"
local SCRIPT_ID = "1l9s9dkqai4fub6u"
local PROJECT_ID = "u9bmpi4vpbb8al8m"
local PROJECT_NAME = "001"
local GETKEY_URL = BASE .. "/getkey/" .. PROJECT_ID
local SUPPORT_URL = "https://discord.gg/P2ZNMFPGkN"
local SUPPORTED_PLACES = {}
local ANNOUNCEMENT = ""
local KEY_FILE = "cutrr_" .. PROJECT_ID .. ".key"

local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

local function notify(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = PROJECT_NAME, Text = text, Duration = 5 })
    end)
end

local request = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request


local hwid
pcall(function() if gethwid then hwid = gethwid() end end)
if not hwid then
    pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
end

local function check(key)
    local roblox
    pcall(function()
        local player = game:GetService("Players").LocalPlayer
        if player then
            roblox = { user_id = tostring(player.UserId), username = player.Name, display_name = player.DisplayName }
        end
    end)
    local ok, res = pcall(request, {
        Url = BASE .. "/v1/check",
        Method = "POST",
        Headers = { ["Content-Type"] = "application/json" },
        Body = HttpService:JSONEncode({ script = SCRIPT_ID, key = key, hwid = hwid, roblox = roblox, place_id = game.PlaceId }),
    })
    if not ok or type(res) ~= "table" or not res.Body then
        return { ok = false, code = "CONNECTION_FAILED", message = "Couldn't reach the key server. Try again. Your key has not been marked invalid." }
    end
    local decoded, data = pcall(function() return HttpService:JSONDecode(res.Body) end)
    if not decoded or type(data) ~= "table" then
        return { ok = false, code = "BAD_RESPONSE", message = "The key server returned an unreadable response. Try again or contact Support." }
    end
    local httpStatus = tonumber(res.StatusCode or res.Status)
    if (httpStatus and httpStatus >= 400) or type(data.ok) ~= "boolean" then
        return {
            ok = false,
            code = type(data.code) == "string" and data.code or "SERVER_ERROR",
            message = type(data.message) == "string" and data.message or (type(data.error) == "string" and data.error or "The key server could not complete the request. Try again or contact Support."),
            announcement = data.announcement,
        }
    end
    if data.ok == false and type(data.message) ~= "string" then
        local messages = {
            KEY_INVALID = "This key was not found in this project. Check the key and loader link.",
            KEY_EXPIRED = "This key has expired.",
            KEY_BANNED = "This key is banned.",
            HWID_MISMATCH = "This key is bound to another device. Reset its HWID on the website.",
            HWID_MISSING = "Your executor could not provide a device ID.",
        }
        data.message = messages[data.code] or "The key check could not be completed. Try again or contact Support."
    end
    return data
end

local function readSaved()
    if not (isfile and readfile) then return nil end
    local ok, value = pcall(function() return isfile(KEY_FILE) and readfile(KEY_FILE) or nil end)
    return ok and value or nil
end
local function saveKey(key) if writefile then pcall(writefile, KEY_FILE, key) end end
local function forgetKey()
    if delfile and isfile then pcall(function() if isfile(KEY_FILE) then delfile(KEY_FILE) end end) end
end

local crypto = cutrr_crypto()

local COLORS = {
    bg = Color3.fromRGB(17, 17, 19),
    field = Color3.fromRGB(10, 10, 11),
    line = Color3.fromRGB(46, 46, 50),
    text = Color3.fromRGB(237, 237, 238),
    muted = Color3.fromRGB(154, 154, 161),
    good = Color3.fromRGB(74, 222, 128),
    bad = Color3.fromRGB(248, 113, 113),
}

local function make(class, props, children)
    local inst = Instance.new(class)
    for k, v in pairs(props) do inst[k] = v end
    for _, child in ipairs(children or {}) do child.Parent = inst end
    return inst
end
local function corner(r) return make("UICorner", { CornerRadius = UDim.new(0, r) }) end
local function stroke(color) return make("UIStroke", { Color = color, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }) end

local gui = make("ScreenGui", { Name = "cutrr_" .. PROJECT_ID, ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling })
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end
local parented = pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
if not parented then gui.Parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

local frame = make("Frame", {
    Size = UDim2.fromOffset(340, 254 + (ANNOUNCEMENT ~= "" and 66 or 0)),
    Position = UDim2.fromScale(0.5, 0.5),
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = COLORS.bg,
    BorderSizePixel = 0,
    Parent = gui,
}, { corner(10), stroke(COLORS.line) })

local function label(props)
    props.BackgroundTransparency = 1
    props.Font = props.Font or Enum.Font.Gotham
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    props.Parent = frame
    return make("TextLabel", props)
end

label({ Text = PROJECT_NAME, Font = Enum.Font.GothamBold, TextSize = 17, TextColor3 = COLORS.text, Position = UDim2.fromOffset(18, 14), Size = UDim2.new(1, -60, 0, 22) })
local subtitle = label({ Text = "Enter your key to continue", TextSize = 13, TextColor3 = COLORS.muted, Position = UDim2.fromOffset(18, 38), Size = UDim2.new(1, -36, 0, 18) })

local close = make("TextButton", {
    Text = "×", Font = Enum.Font.GothamBold, TextSize = 20, TextColor3 = COLORS.muted,
    BackgroundTransparency = 1, Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -38, 0, 10), Parent = frame,
})

local box = make("TextBox", {
    PlaceholderText = "Paste your key here", Text = "", ClearTextOnFocus = false,
    Font = Enum.Font.Code, TextSize = 14, TextColor3 = COLORS.text, PlaceholderColor3 = COLORS.muted,
    BackgroundColor3 = COLORS.field, BorderSizePixel = 0,
    Position = UDim2.fromOffset(18, 70), Size = UDim2.new(1, -36, 0, 38), Parent = frame,
}, { corner(8), stroke(COLORS.line), make("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }) })

local function button(text, x, primary)
    return make("TextButton", {
        Text = text, Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = true,
        TextColor3 = primary and COLORS.field or COLORS.text,
        BackgroundColor3 = primary and COLORS.text or COLORS.bg, BorderSizePixel = 0,
        Position = UDim2.new(x, x == 0 and 18 or 5, 0, 120), Size = UDim2.new(0.5, -23, 0, 36), Parent = frame,
    }, { corner(8), stroke(primary and COLORS.text or COLORS.line) })
end
local getKeyBtn = button("Get Key", 0, false)
local activateBtn = button("Activate", 0.5, true)

local announcementLabel = label({ Text = ANNOUNCEMENT, TextSize = 12, TextColor3 = COLORS.text, TextWrapped = true, Visible = ANNOUNCEMENT ~= "", Position = UDim2.fromOffset(18, 250), Size = UDim2.new(1, -36, 0, 60), TextYAlignment = Enum.TextYAlignment.Top })
local function showAnnouncement(text)
    if type(text) ~= "string" or not gui.Parent then return end
    announcementLabel.Text = text
    announcementLabel.Visible = text ~= ""
    frame.Size = UDim2.fromOffset(340, 254 + (text ~= "" and 66 or 0))
end

local status = label({ Text = "", TextSize = 12, TextColor3 = COLORS.muted, TextWrapped = true, Position = UDim2.fromOffset(18, 164), Size = UDim2.new(1, -36, 0, 48), TextYAlignment = Enum.TextYAlignment.Top })
local function setStatus(text, color)
    if gui.Parent then status.Text = text; status.TextColor3 = color or COLORS.muted end
end

local supportBtn = make("TextButton", {
    Text = "Support - cutrr Discord", Font = Enum.Font.GothamMedium, TextSize = 12,
    TextColor3 = COLORS.muted, BackgroundTransparency = 1,
    Position = UDim2.fromOffset(18, 218), Size = UDim2.new(1, -36, 0, 24), Parent = frame,
})

-- Drag by the frame.
local dragging, dragStart, startPos
frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging, dragStart, startPos = true, input.Position, frame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)

close.MouseButton1Click:Connect(function() gui:Destroy() end)

local busy = false
local compatible = #SUPPORTED_PLACES == 0
for _, id in ipairs(SUPPORTED_PLACES) do
    if game.PlaceId == id then compatible = true; break end
end


getKeyBtn.MouseButton1Click:Connect(function()
    if busy or not compatible then return end
    local copy = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if copy and pcall(copy, GETKEY_URL) then
        setStatus("Link copied! Paste it in your browser to get a key.", COLORS.good)
        notify("Key link copied to clipboard")
    else
        box.Text = GETKEY_URL
        setStatus("Copy the link from the box and open it in your browser.", COLORS.muted)
    end
end)


supportBtn.MouseButton1Click:Connect(function()
    local copy = setclipboard or toclipboard or (Clipboard and Clipboard.set)
    if copy and pcall(copy, SUPPORT_URL) then
        notify("cutrr Discord invite copied to clipboard")
        if not busy then setStatus("Support invite copied. Paste it in your browser.", COLORS.good) end
    elseif not busy then
        box.Text = SUPPORT_URL
        setStatus("Copy the Discord invite from the box and open it in your browser.")
    else
        notify("Support: " .. SUPPORT_URL)
    end
end)

local function launch(data, key)
    setStatus("Download complete. Preparing script...", COLORS.muted)
    task.wait()
    if not gui.Parent then return end
    local source = data.source
    if data.enc then
        setStatus("Decrypting script...", COLORS.muted)
        task.wait()
        local ok, dec = pcall(crypto.decrypt, key, data.enc.n, data.enc.p)
        if not ok or type(dec) ~= "string" then
            return setStatus("Couldn't decrypt the script. Try again or contact Support.", COLORS.bad)
        end
        source = dec
    end
    if type(source) ~= "string" or source == "" then
        return setStatus("The server returned an empty script. Contact Support.", COLORS.bad)
    end
    local compiled, fn, err = pcall(loadstring, source)
    if not compiled or not fn then
        warn("[cutrr] Script failed to load: " .. tostring(err or fn))
        return setStatus("Script failed to load. Contact Support for help.", COLORS.bad)
    end
    if not gui.Parent then return end
    saveKey(key)
    setStatus("Starting script...", COLORS.good)
    task.wait()
    if not gui.Parent then return end
    local failed = false
    task.spawn(function()
        local ok, runErr = xpcall(fn, debug.traceback)
        if not ok then
            failed = true
            warn("[cutrr] Script error: " .. tostring(runErr))
            setStatus("Script error. Contact Support for help.", COLORS.bad)
            notify("Script error: " .. tostring(runErr):sub(1, 150))
        end
    end)
    task.delay(0.8, function()
        if not failed and gui.Parent then gui:Destroy() end
    end)
end

local function activate(key, fromSaved)
    if busy or not compatible then return end
    if key == "" or key == GETKEY_URL or key == SUPPORT_URL then
        return setStatus("Paste your key first.", COLORS.bad)
    end
    if not request then return setStatus("Your executor can't make HTTP requests. Contact Support.", COLORS.bad) end
    busy = true
    activateBtn.Text = "Loading..."
    setStatus("Checking key and downloading script...", COLORS.muted)
    task.wait()
    local data = check(key)
    if not gui.Parent then busy = false; return end
    showAnnouncement(data.announcement)
    if data.ok then
        launch(data, key)
    else
        if fromSaved and (data.code == "KEY_INVALID" or data.code == "KEY_EXPIRED" or data.code == "KEY_BANNED") then
            forgetKey()
            box.Text = ""
        end
        setStatus(data.message or "The key check could not be completed. Try again or contact Support.", COLORS.bad)
    end
    busy = false
    if gui.Parent then activateBtn.Text = "Activate" end
end

activateBtn.MouseButton1Click:Connect(function()
    activate((box.Text or ""):gsub("%s+", ""), false)
end)

if not compatible then
    subtitle.Text = "This game is not supported"
    activateBtn.Active = false
    activateBtn.AutoButtonColor = false
    activateBtn.Text = "Unsupported"
    getKeyBtn.Active = false
    getKeyBtn.AutoButtonColor = false
    setStatus("Join a supported game and run the loader again. Need help? Use Support below.", COLORS.bad)
    if request then
        task.spawn(function()
            local data = check(readSaved() or "")
            showAnnouncement(data.announcement)
        end)
    end
else
    local saved = readSaved()
    if type(saved) == "string" and saved ~= "" then
        box.Text = saved
        task.spawn(function() activate(saved, true) end)
    end
end

