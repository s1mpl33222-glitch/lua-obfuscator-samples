_G.KVN_SERVER = "http://kvnreal.online"
_G.KVN_SCRIPT_ID = "norecall"
_G.KVN_LOADER = "3ddefd1b5a542e750d73e6b1"
_G.KVN_GATE = "f81875404295b036572dcad6a8880e45"
_G.Key = _G.Key or ""
-- KVN Secure Loader v2
local SERVER_URL = _G.KVN_SERVER or "http://kvnreal.online"
local SCRIPT_ID  = _G.KVN_SCRIPT_ID or "norecall"
local LOADER_ID  = _G.KVN_LOADER or "3ddefd1b5a542e750d73e6b1"
local GATE_KEY   = _G.KVN_GATE or "f81875404295b036572dcad6a8880e45"
local KEY        = _G.Key or ""

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local lp = Players.LocalPlayer

local function notify(title, text, dur)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = title, Text = text, Duration = dur or 4 })
    end)
end

local function getHWID()
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and id then return tostring(id) end
    return tostring(game.PlaceId) .. "_" .. tostring(lp and lp.UserId or 0)
end

local function encode(tbl)
    local ok, s = pcall(function() return HttpService:JSONEncode(tbl) end)
    if ok and s then return s end
    return nil
end

local function decode(raw)
    if type(raw) == "table" then return raw end
    if type(raw) ~= "string" then return nil end
    local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
    if ok then return data end
    return nil
end

local function query(url, bodyTable)
    if not bodyTable then return url end
    local parts = {}
    for k, v in pairs(bodyTable) do
        table.insert(parts, tostring(k) .. "=" .. HttpService:UrlEncode(tostring(v)))
    end
    if url:find("?", 1, true) then
        return url .. "&" .. table.concat(parts, "&")
    end
    return url .. "?" .. table.concat(parts, "&")
end

local function httpRequest(method, url, bodyTable)
    local function useful(data)
        if type(data) ~= "table" then return false end
        if data.session or data.deliver or data.why or data.kicked or data.runPath or data.runToken or data.ok ~= nil then return true end
        return false
    end
    local getUrl = query(url, bodyTable)
    local okGet, rawGet = pcall(function()
        return game:HttpGet(getUrl)
    end)
    if okGet and rawGet then
        local data = decode(rawGet)
        if useful(data) then return data end
        if type(data) == "table" and data.success == false then return data end
    end
    local body = bodyTable and encode(bodyTable) or nil
    local req = {
        Url = url, url = url, Method = method, method = method,
        Headers = { ["Content-Type"] = "application/json" },
        headers = { ["Content-Type"] = "application/json" },
        Body = body, body = body
    }
    local fns = {}
    pcall(function() if syn and syn.request then table.insert(fns, syn.request) end end)
    pcall(function() if http and http.request then table.insert(fns, http.request) end end)
    pcall(function() if fluxus and fluxus.request then table.insert(fns, fluxus.request) end end)
    pcall(function() if request then table.insert(fns, request) end end)
    pcall(function() if http_request then table.insert(fns, http_request) end end)
    for _, fn in ipairs(fns) do
        local ok, res = pcall(fn, req)
        if ok and res then
            local raw = res.Body or res.body or res
            local data = decode(raw)
            if useful(data) then return data end
        end
    end
    return nil
end

local function setClip(text)
    pcall(function()
        if setclipboard then setclipboard(text) end
        if toclipboard then toclipboard(text) end
        if syn and syn.write_clipboard then syn.write_clipboard(text) end
    end)
end

local function startClipboardNoise()
    task.spawn(function()
        for i = 1, 24 do
            setClip((" "):rep((i % 5) + 1))
            task.wait(0.08)
        end
    end)
end

local function runIsolated(src)
    if type(src) ~= "string" or #src < 20 then return false, "empty" end
    local fn, err = loadstring(src)
    src = nil
    if not fn then return false, err end
    local ok, e = pcall(fn)
    fn = nil
    pcall(function() collectgarbage("collect") end)
    return ok, e
end

-- طبقة ثانية: تكشف مراقبة loadstring / HttpGet بدون ما تمرّر السورس للهوك.
local function dumpWatching()
    local hit = false
    pcall(function()
        if typeof(isfunctionhooked) == "function" and isfunctionhooked(loadstring) then hit = true end
    end)
    pcall(function()
        if typeof(isfunctionhooked) == "function" and game.HttpGet and isfunctionhooked(game.HttpGet) then hit = true end
    end)
    return hit
end

local function abortDelivery(token)
    if type(token) ~= "string" or token == "" then return end
    pcall(function()
        httpRequest("POST", SERVER_URL .. "/api/secure/abort", { token = token, reason = "hook" })
    end)
    pcall(function()
        game:HttpGet(SERVER_URL .. "/api/secure/abort?token=" .. HttpService:UrlEncode(token))
    end)
end

local function hangSilent()
    while true do
        task.wait(86400)
    end
end

local function mixProof(token, key)
    local s = tostring(token) .. ":" .. tostring(key) .. ":KVN"
    local h = 0
    for i = 1, #s do
        h = (h + string.byte(s, i) * i) % 65536
    end
    return string.format("%04x", h) .. ":" .. tostring(#s)
end

local function passServerGate(token)
    if type(token) ~= "string" or token == "" then return false end
    if type(GATE_KEY) ~= "string" or GATE_KEY == "" or GATE_KEY == "f81875404295b036572dcad6a8880e45" then return false end
    local url = SERVER_URL .. "/api/secure/gate?token=" .. HttpService:UrlEncode(token) .. "&gateKey=" .. HttpService:UrlEncode(GATE_KEY)
    local raw
    pcall(function() raw = game:HttpGet(url) end)
    local data = decode(raw)
    if data and data.ok == true then return true end
    local res = httpRequest("POST", SERVER_URL .. "/api/secure/gate", {
        token = token,
        gateKey = GATE_KEY
    })
    return res and res.ok == true
end

local function corner(inst, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = inst
end

local function stroke(inst, color)
    local s = Instance.new("UIStroke")
    s.Color = color or Color3.fromRGB(67, 56, 202)
    s.Thickness = 1
    s.Transparency = 0.35
    s.Parent = inst
end

local function buildGui(challenge)
    local parent = CoreGui
    pcall(function() if gethui then parent = gethui() end end)
    local old = parent:FindFirstChild("KVNSecureGate")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "KVNSecureGate"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 416)
    frame.Position = UDim2.new(0.5, -190, 0.5, -208)
    frame.BackgroundColor3 = Color3.fromRGB(12, 16, 28)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    corner(frame, 20)
    stroke(frame, Color3.fromRGB(99, 102, 241))

    local accent = Instance.new("Frame")
    accent.Size = UDim2.new(1, 0, 0, 4)
    accent.BackgroundColor3 = Color3.fromRGB(99, 102, 241)
    accent.BorderSizePixel = 0
    accent.Parent = frame
    corner(accent, 20)

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, -24, 0, 30)
    title.Position = UDim2.new(0, 16, 0, 16)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 20
    title.TextColor3 = Color3.fromRGB(224, 231, 255)
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = "KVN  Secure"
    title.Parent = frame

    local sub = Instance.new("TextLabel")
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1, -24, 0, 18)
    sub.Position = UDim2.new(0, 16, 0, 44)
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 12
    sub.TextColor3 = Color3.fromRGB(148, 163, 184)
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.Text = "أدخل المفتاح ثم اكتب الكود كما يظهر"
    sub.Parent = frame

    local capCard = Instance.new("Frame")
    capCard.Size = UDim2.new(1, -32, 0, 72)
    capCard.Position = UDim2.new(0, 16, 0, 74)
    capCard.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
    capCard.BorderSizePixel = 0
    capCard.Parent = frame
    corner(capCard, 14)
    stroke(capCard, Color3.fromRGB(251, 191, 36))

    local capShow = Instance.new("TextLabel")
    capShow.BackgroundTransparency = 1
    capShow.Size = UDim2.new(1, -16, 1, 0)
    capShow.Position = UDim2.new(0, 8, 0, 0)
    capShow.Font = Enum.Font.GothamBlack
    capShow.TextSize = 34
    capShow.TextColor3 = Color3.fromRGB(253, 224, 71)
    capShow.Text = tostring(challenge or "-----")
    capShow.Parent = capCard

    local function field(y, placeholder, text, color)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(1, -32, 0, 42)
        box.Position = UDim2.new(0, 16, 0, y)
        box.BackgroundColor3 = Color3.fromRGB(22, 28, 45)
        box.TextColor3 = color or Color3.fromRGB(255, 255, 255)
        box.PlaceholderColor3 = Color3.fromRGB(100, 116, 139)
        box.PlaceholderText = placeholder
        box.Text = text or ""
        box.Font = Enum.Font.GothamMedium
        box.TextSize = 15
        box.ClearTextOnFocus = false
        box.TextXAlignment = Enum.TextXAlignment.Center
        box.Parent = frame
        corner(box, 11)
        stroke(box, Color3.fromRGB(51, 65, 85))
        return box
    end

    local keyBox = field(160, "المفتاح  KEY", KEY, Color3.fromRGB(253, 224, 71))
    local capBox = field(212, "اكتب الكود الظاهر بالأعلى", "", Color3.fromRGB(255, 255, 255))

    local status = Instance.new("TextLabel")
    status.BackgroundTransparency = 1
    status.Size = UDim2.new(1, -32, 0, 20)
    status.Position = UDim2.new(0, 16, 0, 260)
    status.Font = Enum.Font.Gotham
    status.TextSize = 12
    status.TextColor3 = Color3.fromRGB(148, 163, 184)
    status.Text = "60 ثانية لإكمال التحقق"
    status.Parent = frame

    local submit = Instance.new("TextButton")
    submit.Size = UDim2.new(1, -32, 0, 48)
    submit.Position = UDim2.new(0, 16, 0, 292)
    submit.BackgroundColor3 = Color3.fromRGB(79, 70, 229)
    submit.TextColor3 = Color3.fromRGB(255, 255, 255)
    submit.Font = Enum.Font.GothamBold
    submit.TextSize = 16
    submit.Text = "تحقق وتشغيل"
    submit.AutoButtonColor = false
    submit.Parent = frame
    corner(submit, 13)

    local tip = Instance.new("TextLabel")
    tip.BackgroundTransparency = 1
    tip.Size = UDim2.new(1, -32, 0, 48)
    tip.Position = UDim2.new(0, 16, 0, 350)
    tip.Font = Enum.Font.Gotham
    tip.TextSize = 11
    tip.TextWrapped = true
    tip.TextColor3 = Color3.fromRGB(100, 116, 139)
    tip.Text = "اكتب نفس الأحرف الخمسة. إذا الخطأ تبقى الواجهة مفتوحة."
    tip.Parent = frame

    return gui, capBox, keyBox, submit, status
end

local function boot()
    startClipboardNoise()
    local sessionRes = httpRequest("POST", SERVER_URL .. "/api/secure/session", {
        scriptId = SCRIPT_ID,
        key = KEY,
        loaderId = LOADER_ID,
        hwid = getHWID(),
        placeId = game.PlaceId,
        jobId = game.JobId,
        userId = lp and lp.UserId or 0,
        username = lp and lp.Name or "UNKNOWN"
    })

    if not sessionRes or not sessionRes.session then
        notify("KVN", "تعذر بدء الجلسة — تأكد من المفتاح والدومين", 6)
        return
    end

    local gui, capBox, keyBox, submit, status = buildGui(sessionRes.challenge)
    local busy = false
    local left = 60
    task.spawn(function()
        while gui and gui.Parent and left > 0 do
            status.Text = "متبقي " .. tostring(left) .. " ثانية"
            task.wait(1)
            left = left - 1
        end
        if gui and gui.Parent and left <= 0 then
            status.Text = "انتهى الوقت — أعد تشغيل السكربت"
            status.TextColor3 = Color3.fromRGB(248, 113, 113)
        end
    end)

    submit.MouseButton1Click:Connect(function()
        if busy then return end
        busy = true
        submit.Text = "جاري التحقق..."
        local ans = tostring(capBox.Text or ""):gsub("[^%w]", ""):upper()
        local useKey = ((keyBox.Text ~= "" and keyBox.Text) or KEY):gsub("^%s+",""):gsub("%s+$","")
        local ver = httpRequest("POST", SERVER_URL .. "/api/secure/verify", {
            session = sessionRes.session,
            answer = ans,
            key = useKey,
            hwid = getHWID(),
            placeId = game.PlaceId,
            username = lp and lp.Name or "UNKNOWN"
        })

        if not ver then
            status.Text = "فشل الاتصال بالسيرفر"
            status.TextColor3 = Color3.fromRGB(248, 113, 113)
            submit.Text = "إعادة المحاولة"
            busy = false
            return
        end
        if ver.kicked then
            pcall(function() lp:Kick(ver.reason or "Kicked") end)
            return
        end
        if ver.deliver ~= true or ver.dummy == true then
            local why = tostring(ver.why or "")
            local msg = "فشل التحقق"
            if why:find("captcha") then msg = "الكابتشا غلط"
            elseif why:find("key") or why:find("expired") then msg = "المفتاح غلط أو منتهي"
            elseif why:find("account") then msg = "المفتاح مربوط بحساب ثاني"
            elseif why:find("place") then msg = "مو نفس الماب"
            elseif why:find("hwid") or why:find("identity") then msg = "الجهاز/الحساب مو مطابق"
            elseif why:find("session") then msg = "انتهت الجلسة — أعد التشغيل"
            elseif why:find("source") then msg = "السورس مو موجود على السيرفر"
            end
            status.Text = msg
            status.TextColor3 = Color3.fromRGB(248, 113, 113)
            submit.Text = "حاول مرة ثانية"
            capBox.Text = ""
            busy = false
            return
        end

        local runPath = ver.runPath
        local runToken = ver.runToken
        ver = nil
        if type(runPath) ~= "string" or runPath == "" then
            status.Text = "ما وصل أمر التشغيل"
            status.TextColor3 = Color3.fromRGB(248, 113, 113)
            busy = false
            return
        end

        status.Text = "جاري التشغيل..."
        submit.Text = "جاري التشغيل"
        pcall(function() gui:Destroy() end)

        startClipboardNoise()
        notify("KVN", "جاري التشغيل", 3)

        local execUrl = SERVER_URL .. runPath
        local stub = [[
            local u = "]] .. execUrl .. [["
            local src
            pcall(function() src = game:HttpGet(u) end)
            if type(src) == "string" and #src > 40 and not src:find("KVNSecureGate") then
                local fn = loadstring(src)
                src = nil
                if fn then pcall(fn) end
            end
        ]]
        local queued = false
        pcall(function()
            if queue_on_teleport then queue_on_teleport(stub) queued = true end
        end)
        pcall(function()
            if syn and syn.queue_on_teleport then syn.queue_on_teleport(stub) queued = true end
        end)
        pcall(function()
            if fluxus and fluxus.queue_on_teleport then fluxus.queue_on_teleport(stub) queued = true end
        end)
        if not queued then
            local src
            pcall(function() src = game:HttpGet(execUrl) end)
            if type(src) == "string" and #src > 40 and not src:find("KVNSecureGate") then
                local fn = loadstring(src)
                src = nil
                if fn then pcall(fn) end
            end
            return
        end
        task.wait(0.35)
        pcall(function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
        end)
    end)
end

boot()
