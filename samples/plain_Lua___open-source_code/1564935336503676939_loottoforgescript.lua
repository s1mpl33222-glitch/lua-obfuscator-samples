--[[
  KeySystem Loader  (ฝั่ง Roblox executor)
  ไฟล์นี้ถูกเสิร์ฟอัตโนมัติจาก Worker ที่ /loader/<slug>
  วิธีใช้ในเกม:
      loadstring(game:HttpGet("https://YOUR-WORKER.workers.dev/loader/myscript"))()
  หรือข้ามหน้ากรอก key:
      getgenv().Key = "XXXX-XXXX-XXXX-XXXX"
      loadstring(game:HttpGet("https://YOUR-WORKER.workers.dev/loader/myscript"))()
]]

local BASE     = "https://lua-keysystem.webforyous.workers.dev"
local PRIMARY  = ""   -- VPS หลัก (ว่าง = ไม่ใช้ failover)
local SLUG     = "loottoforgescript"
local NAME     = "Loot To Forge Script"
local BRAND    = "PROROBLOX"
local ANNOUNCE = ""   -- ประกาศจากหน้าตั้งค่า
local GETKEY   = "https://discord.gg/c54zqyRUZ9"     -- ลิงก์รับ/ซื้อ key
local ACCENT   = Color3.fromRGB(76, 124, 255)
local ACCENT2  = Color3.fromRGB(160, 60, 255)
local SALT     = "6e3848bf553afbcd"       -- ใช้ประกอบกุญแจถอดรหัส
local DISCORD  = ""    -- ลิงก์ Discord ช่วยเหลือ (ว่าง = ไม่แสดงปุ่ม)

local HttpService = game:GetService("HttpService")
local Players     = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- ---------- บัญชี Roblox ของคนเล่น (ส่งไปบันทึก + ล็อก key กับบัญชีแรก) ----------
-- รันเร็วตอนเข้าเกม (autoexec) LocalPlayer อาจยังไม่มา รอสูงสุด 10 วิ
if not LocalPlayer then
    local t0 = os.clock()
    repeat task.wait(0.1); LocalPlayer = Players.LocalPlayer until LocalPlayer or os.clock() - t0 > 10
end
local PLAYER = { id = "", name = "", display = "" }
pcall(function()
    PLAYER.id = tostring(LocalPlayer.UserId)
    PLAYER.name = tostring(LocalPlayer.Name)
    PLAYER.display = tostring(LocalPlayer.DisplayName)
end)

-- ---------- HWID ----------
local function getHwid()
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and id and id ~= "" then return tostring(id) end
    if gethwid then
        local ok2, id2 = pcall(gethwid)
        if ok2 and id2 then return tostring(id2) end
    end
    return "UID-" .. tostring(LocalPlayer and LocalPlayer.UserId or 0)
end

local HWID = getHwid()

-- รหัสประจำการ exec หนึ่งครั้ง (server ใช้รวมเวลาเล่นของ session เดียวกัน)
local SID = tostring(math.random(0, 0x7fffffff)) .. tostring(math.random(0, 0x7fffffff))
pcall(function() SID = HttpService:GenerateGUID(false) end)

-- ---------- HTTP ----------
local httpRequest = (syn and syn.request)
    or (http and http.request)
    or http_request
    or (fluxus and fluxus.request)
    or request

local function enc(s)
    local ok, r = pcall(function() return HttpService:UrlEncode(s) end)
    if ok then return r end
    return (tostring(s):gsub("[^%w%-%.%_%~]", function(c)
        return string.format("%%%02X", string.byte(c))
    end))
end

-- ---------- failover: ลอง PRIMARY (VPS) ก่อน แล้วถอยมา BASE (Worker + D1) ----------
-- PRIMARY ว่าง = ใช้ BASE อย่างเดียวเหมือนเดิมทุกอย่าง (ตั้ง primary_url ในหน้าตั้งค่า Worker)
local PRIMARY_TIMEOUT = 2.5   -- วินาทีที่รอ PRIMARY ตอน redeem/check
local SCRIPT_TIMEOUT  = 20    -- วินาทีที่รอ PRIMARY ตอนโหลดสคริปต์
local START_WAIT      = 8     -- วินาทีที่รอดู error ตอนสคริปต์เริ่ม ; เกินนี้ถือว่ารันแล้ว (สคริปต์ที่ yield นานห้ามทำให้หน้าต่างค้าง)
local primaryDown = false     -- true = PRIMARY ล้ม (timeout/ต่อไม่ได้/5xx/ไม่ใช่ JSON) ใช้ BASE ตลอดรอบนี้
local tokenHost = BASE        -- host ที่ออก token ให้ (ใช้ /api/script และ heartbeat ที่ host เดียวกัน)

-- executor ไม่มี timeout ให้ request(): รันใน thread แยกแล้วรอด้วย os.clock
-- คืน done, ค่าที่ fn คืน (ถ้า timeout done=false และผลที่มาทีหลังถูกทิ้ง)
local function runWithTimeout(fn, sec)
    local done, result = false, nil
    task.spawn(function()
        local ok, r = pcall(fn)
        if ok then result = r end
        done = true
    end)
    local t0 = os.clock()
    while not done and os.clock() - t0 < sec do task.wait(0.05) end
    return done, result
end

-- ยิงหนึ่งครั้ง คืน data(table) หรือ nil, ข้อความ error, และ hard (true = host นี้ใช้ไม่ได้)
-- limit = nil คือไม่จำกัดเวลา (BASE เหมือนเดิม) ; status 5xx นับเป็น hard เฉพาะเมื่อมี limit (PRIMARY)
local function callApi(host, path, bodyTbl, query, limit)
    local function once()
        local raw, status
        if httpRequest then
            local ok, res = pcall(httpRequest, {
                Url = host .. path,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode(bodyTbl),
            })
            if ok and res then
                raw = res.Body or res.body
                status = tonumber(res.StatusCode or res.status_code)
            end
        end
        if not raw then
            -- executor ที่ไม่มี request(): ใช้ GET แทน
            local ok, res = pcall(function() return game:HttpGet(host .. path .. query) end)
            if ok then raw = res end
        end
        if limit and status and status >= 500 then return { err = "ต่อเซิร์ฟเวอร์ไม่ได้" } end
        if not raw then return { err = "ต่อเซิร์ฟเวอร์ไม่ได้" } end
        local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
        if not ok or type(data) ~= "table" then return { err = "อ่านคำตอบจากเซิร์ฟเวอร์ไม่ได้" } end
        return { data = data }
    end
    local r
    if limit then
        local done, res = runWithTimeout(once, limit)
        r = done and res or { err = "ต่อเซิร์ฟเวอร์ไม่ได้" }
    else
        r = once()
    end
    if r and r.data then return r.data end
    return nil, (r and r.err) or "ต่อเซิร์ฟเวอร์ไม่ได้", true
end

-- ข้อมูลสภาพแวดล้อม ส่งไปให้ server เก็บเป็นหลักฐานเสริม (ปลอมได้ ไม่ใช่การพิสูจน์) ไม่มีค่า = ไม่ส่ง
local ENVINFO = { place_id = tostring(game.PlaceId), job_id = tostring(game.JobId) }
pcall(function() ENVINFO.executor = tostring((identifyexecutor and identifyexecutor()) or "") end)
pcall(function() ENVINFO.client_ver = tostring(version and version() or "") end)
for k, v in pairs(ENVINFO) do
    if v == "" or v == "0" then ENVINFO[k] = nil end
end

-- เติม field เพิ่มเติม (list_versions / version / new_session + ENVINFO) ลงทั้ง body และ query (โหมด GET)
local function addExtra(body, query, extra)
    for k, v in pairs(ENVINFO) do
        body[k] = v
        query = query .. "&" .. k .. "=" .. enc(v)
    end
    for k, v in pairs(extra or {}) do
        body[k] = v
        query = query .. "&" .. k .. "=" .. enc(v == true and "1" or tostring(v))
    end
    return query
end

-- extra.list_versions = ขอแค่รายการ version (ยังไม่ออก token) ; extra.version = id ที่เลือก
-- server เก่าที่ไม่รู้จัก field นี้จะข้ามไปและออก token ตามปกติ
local function redeemOn(host, key, limit, extra)
    local body = {
        key = key, hwid = HWID, slug = SLUG, sid = SID,
        rbx_id = PLAYER.id, rbx_name = PLAYER.name, rbx_display = PLAYER.display,
    }
    local query = "?key=" .. enc(key) .. "&hwid=" .. enc(HWID) .. "&slug=" .. enc(SLUG)
        .. "&rbx_id=" .. enc(PLAYER.id) .. "&rbx_name=" .. enc(PLAYER.name) .. "&rbx_display=" .. enc(PLAYER.display)
        .. "&sid=" .. enc(SID)
    query = addExtra(body, query, extra)
    return callApi(host, "/api/redeem", body, query, limit)
end

-- คืน data, host หรือ nil, ข้อความ error
-- PRIMARY ปฏิเสธ (ok ~= true) ก็ถอยมาถาม BASE อีกรอบ เพราะ D1 อาจรู้ข้อมูลล่าสุดกว่าตอน VPS ล่มกลางทาง
local function apiRedeem(key, extra)
    if PRIMARY ~= "" and not primaryDown then
        local data, _, hard = redeemOn(PRIMARY, key, PRIMARY_TIMEOUT, extra)
        if data and data.ok == true and (data.token or data.versions) then return data, PRIMARY end
        if hard then primaryDown = true end
    end
    local data, err = redeemOn(BASE, key, nil, extra)
    if not data then return nil, err end
    return data, BASE
end

-- เช็คสถานะ key เป็นระยะ (heartbeat) คืน nil ถ้าติดต่อเซิร์ฟเวอร์ไม่ได้ (ไม่ถือว่า key ใช้ไม่ได้)
local function apiCheck(key, extra)
    local body = { key = key, hwid = HWID, sid = SID, rbx_id = PLAYER.id, rbx_name = PLAYER.name, rbx_display = PLAYER.display }
    local query = "?key=" .. enc(key) .. "&hwid=" .. enc(HWID) .. "&rbx_id=" .. enc(PLAYER.id) .. "&sid=" .. enc(SID)
    query = addExtra(body, query, extra)
    if PRIMARY ~= "" and tokenHost == PRIMARY and not primaryDown then
        local data = callApi(PRIMARY, "/api/check", body, query, PRIMARY_TIMEOUT)
        if data then return data end
        primaryDown = true
    end
    return (callApi(BASE, "/api/check", body, query, nil))
end

-- ---------- ถอดรหัสซอร์ส ----------
local B64C = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local B64M = {}
for i = 1, 64 do B64M[string.sub(B64C, i, i)] = i - 1 end

local function b64decode(s)
    s = string.gsub(s, '%s', '')
    local pad = 0
    if string.sub(s, -2) == '==' then pad = 2
    elseif string.sub(s, -1) == '=' then pad = 1 end
    s = string.gsub(s, '=', '')
    local out, n = {}, 0
    local len = #s
    local i = 1
    while i <= len do
        local a = B64M[string.sub(s, i, i)] or 0
        local b = B64M[string.sub(s, i + 1, i + 1)] or 0
        local c = B64M[string.sub(s, i + 2, i + 2)] or 0
        local d = B64M[string.sub(s, i + 3, i + 3)] or 0
        local num = a * 262144 + b * 4096 + c * 64 + d
        n = n + 1
        out[n] = string.char(
            math.floor(num / 65536) % 256,
            math.floor(num / 256) % 256,
            num % 256
        )
        i = i + 4
    end
    local res = table.concat(out)
    if pad > 0 then res = string.sub(res, 1, #res - pad) end
    return res
end

local function slowXor(a, b)
    local r, bit = 0, 1
    while a > 0 or b > 0 do
        local ab, bb = a % 2, b % 2
        if ab ~= bb then r = r + bit end
        a = (a - ab) / 2
        b = (b - bb) / 2
        bit = bit * 2
    end
    return r
end
local XOR = (bit32 and bit32.bxor) or slowXor

local function rc4(key, data)
    local S = {}
    for i = 0, 255 do S[i] = i end
    local klen = #key
    local j = 0
    for i = 0, 255 do
        j = (j + S[i] + string.byte(key, i % klen + 1)) % 256
        S[i], S[j] = S[j], S[i]
    end
    local out, n = {}, 0
    local buf, bn = {}, 0
    local x, y = 0, 0
    for idx = 1, #data do
        x = (x + 1) % 256
        y = (y + S[x]) % 256
        S[x], S[y] = S[y], S[x]
        bn = bn + 1
        buf[bn] = string.char(XOR(string.byte(data, idx), S[(S[x] + S[y]) % 256]))
        if bn >= 4096 then
            n = n + 1
            out[n] = table.concat(buf)
            buf, bn = {}, 0
        end
    end
    if bn > 0 then n = n + 1; out[n] = table.concat(buf, '', 1, bn) end
    return table.concat(out)
end

-- ---------- unload อัตโนมัติเมื่อ key หมดอายุ/ถูกระงับ ----------
-- ลบ GUI ที่สคริปต์สร้างขึ้นหลังโหลด + เรียก callback ที่สคริปต์ลงทะเบียนไว้ที่ getgenv().KS_ON_UNLOAD
-- (สคริปต์ที่มี loop/hook ของตัวเองควรเช็ค getgenv().KS_ALIVE หรือลงทะเบียน callback เพื่อหยุดตัวเอง)
local genv = (getgenv and getgenv()) or _G

local function guiRoots()
    local roots = {}
    pcall(function() table.insert(roots, game:GetService("CoreGui")) end)
    pcall(function()
        local pg = LocalPlayer and LocalPlayer:FindFirstChild("PlayerGui")
        if pg then table.insert(roots, pg) end
    end)
    if gethui then
        pcall(function() table.insert(roots, gethui()) end)
    end
    return roots
end

local function snapshotGuis()
    local seen = {}
    for _, root in ipairs(guiRoots()) do
        pcall(function()
            for _, c in ipairs(root:GetChildren()) do seen[c] = true end
        end)
    end
    return seen
end

local function unloadAll(before, reason)
    genv.KS_ALIVE = false
    local cbs = genv.KS_ON_UNLOAD
    if type(cbs) == "table" then
        for _, fn in ipairs(cbs) do
            if type(fn) == "function" then pcall(fn, reason) end
        end
    end
    genv.KS_ON_UNLOAD = nil
    for _, root in ipairs(guiRoots()) do
        pcall(function()
            for _, c in ipairs(root:GetChildren()) do
                if not before[c] then pcall(function() c:Destroy() end) end
            end
        end)
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = BRAND, Text = reason .. " — สคริปต์ถูกปิดแล้ว", Duration = 10,
        })
    end)
end

-- ป๊อปอัพข้อความจากแอดมินหลังถูกเตะ: กดปิดเองได้ (ไม่บังจอถาวร) ปิดเองใน 60 วิ
local function showKickNotice(msg)
    pcall(function()
        local g = Instance.new("ScreenGui")
        g.Name = "KeySystemNotice"
        g.ResetOnSpawn = false
        g.IgnoreGuiInset = true
        pcall(function() g.Parent = game:GetService("CoreGui") end)
        if not g.Parent then g.Parent = LocalPlayer:WaitForChild("PlayerGui") end
        local f = Instance.new("Frame")
        f.Size = UDim2.new(0, 340, 0, 150)
        f.Position = UDim2.new(0.5, -170, 0.5, -75)
        f.BackgroundColor3 = Color3.fromRGB(20, 20, 32)
        f.BorderSizePixel = 0
        f.Parent = g
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
        local t = Instance.new("TextLabel")
        t.BackgroundTransparency = 1
        t.Size = UDim2.new(1, -28, 1, -64)
        t.Position = UDim2.new(0, 14, 0, 12)
        t.TextWrapped = true
        t.TextXAlignment = Enum.TextXAlignment.Left
        t.TextYAlignment = Enum.TextYAlignment.Top
        t.Font = Enum.Font.Gotham
        t.TextSize = 15
        t.TextColor3 = Color3.fromRGB(240, 242, 250)
        t.Text = (msg and msg ~= "") and msg or "แอดมินปิดสคริปต์ของคุณ"
        t.Parent = f
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 96, 0, 34)
        b.Position = UDim2.new(1, -110, 1, -46)
        b.BackgroundColor3 = Color3.fromRGB(80, 90, 255)
        b.TextColor3 = Color3.new(1, 1, 1)
        b.Font = Enum.Font.GothamBold
        b.TextSize = 14
        b.Text = "ปิด"
        b.Parent = f
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
        b.MouseButton1Click:Connect(function() g:Destroy() end)
        task.delay(60, function() pcall(function() g:Destroy() end) end)
    end)
end

local function startGuard(key, data, before, version)
    genv.KS_ALIVE = true
    -- เฉพาะ guard ล่าสุดเท่านั้นที่ทำงาน: รันซ้ำ (เช่นสลับ version) แล้ว guard เก่าต้องเลิกเงียบ ๆ
    -- ไม่งั้นมันยิง /api/check ด้วย sid/version เก่าไปเรื่อย ๆ และ unload ด้วย snapshot เก่า
    -- (เพิ่มตอนรันสำเร็จจนเริ่ม guard เท่านั้น รอบที่ล้ม/ยกเลิกจึงไม่ฆ่า guard ของ session ที่ยังใช้งานอยู่)
    local myGen = (tonumber(genv.KS_GUARD_GEN) or 0) + 1
    genv.KS_GUARD_GEN = myGen
    local announced = false -- true เมื่อ server รับรู้ว่า session นี้เริ่มแล้ว (ส่ง new_session จนกว่าจะได้คำตอบ)
    local interval = math.max(tonumber(data.check_interval) or 300, 60)
    local remain = tonumber(data.key_remaining)
    local deadline = remain and (os.clock() + remain) or nil
    local nextCheck = os.clock() + interval
    local kickMsg
    -- unload เฉพาะเมื่อเซิร์ฟเวอร์ยืนยันว่า key หมดอายุจริงเท่านั้น
    -- (ระงับ/รีเซ็ตเครื่อง/เน็ตหลุด/เซิร์ฟเวอร์ล่ม = ไม่แตะผู้ใช้ที่ยังไม่หมดเวลา; แอดมินต่ออายุได้ทัน)
    local function serverSaysExpired(res)
        return res and res.expires_at and res.now and res.expires_at <= res.now
    end
    task.spawn(function()
        while genv.KS_ALIVE and genv.KS_GUARD_GEN == myGen do
            task.wait(5)
            if genv.KS_GUARD_GEN ~= myGen then return end -- มี guard ใหม่แทนแล้ว ห้ามยิง check/unload
            local t = os.clock()
            local reason
            local dueLocal = deadline and t >= deadline
            if dueLocal or t >= nextCheck then
                nextCheck = t + (dueLocal and 20 or (interval + math.random(0, 20)))
                local res = apiCheck(key, { version = version, new_session = (not announced) or nil })
                -- ติดต่อเซิร์ฟเวอร์ไม่ได้ = ข้ามรอบนี้ (ไม่ unload) ถึงเวลาหมดตามนาฬิกาในเครื่องก็รอเซิร์ฟเวอร์ตอบก่อน
                -- แต่ลองใหม่เร็วกว่าปกติ (60 วิ) เพื่อไม่ให้เวลาเล่นหายทั้งรอบ
                if not res then nextCheck = math.min(nextCheck, t + 60) end
                if res then
                    announced = true
                    if res.kick then
                        kickMsg = tostring(res.kick_message or "")
                        reason = "ถูกแอดมินปิดสคริปต์"
                    elseif serverSaysExpired(res) then
                        reason = "key หมดอายุ"
                    elseif res.expires_at and res.now then
                        deadline = os.clock() + math.max(res.expires_at - res.now, 0)
                    elseif res.expires_at == nil and res.started ~= false then
                        deadline = nil -- ตลอดชีพ
                    end
                end
            end
            if reason and genv.KS_GUARD_GEN == myGen then
                unloadAll(before, reason)
                if kickMsg then showKickNotice(kickMsg) end
                return
            end
        end
    end)
end

-- คืน ok, ข้อความ, beforeRun (true = ล้มก่อนรันสคริปต์ จึงลอง host อื่นได้โดยไม่รันซ้ำ)
local function fetchAndRun(host, token, step)
    step = step or function() end
    step("กำลังดาวน์โหลดสคริปต์...", 4)
    local url = host .. "/api/script?token=" .. enc(token) .. "&hwid=" .. enc(HWID)
    local ok, src
    if host == BASE then
        ok, src = pcall(function() return game:HttpGet(url) end)
    else
        local done, res = runWithTimeout(function() return game:HttpGet(url) end, SCRIPT_TIMEOUT)
        ok, src = done and res ~= nil, res
    end
    if not ok or not src or src == "" then
        return false, "โหลดสคริปต์ไม่สำเร็จ", true
    end
    -- ถ้าเซิร์ฟเวอร์เข้ารหัสมา ให้ถอดในหน่วยความจำก่อนรัน
    if string.sub(src, 1, 6) == "ENCv1:" then
        step("กำลังถอดรหัสสคริปต์...", 4)
        local okDec, plain = pcall(function()
            return rc4(token .. "|" .. HWID .. "|" .. SALT, b64decode(string.sub(src, 7)))
        end)
        if not okDec or not plain or plain == "" then
            return false, "ถอดรหัสสคริปต์ไม่สำเร็จ", true
        end
        src = plain
    end
    step("กำลังเริ่มสคริปต์...", 4)
    local fn, err = loadstring(src)
    if not fn then return false, "สคริปต์มีปัญหา: " .. tostring(err) end
    -- รันแยก thread: ตัวสคริปต์อาจ yield ไม่จบ (require โมดูลเกมที่รอข้อมูล, Loaded:Wait ฯลฯ)
    local finished, runErr = false, nil
    task.spawn(function()
        local ok2, err2 = pcall(fn)
        if not ok2 then runErr = tostring(err2) end
        finished = true
    end)
    local t0 = os.clock()
    while not finished and os.clock() - t0 < START_WAIT do task.wait(0.1) end
    if runErr then return false, "รันสคริปต์ผิดพลาด: " .. runErr end
    return true
end

local function notify(title, msgText)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title, Text = msgText, Duration = 6,
        })
    end)
end

-- ---------- ลองใช้ key ----------
-- เลือก version อัตโนมัติ (ตอนไม่มี UI): ต้องตรงกับ getgenv().Version เท่านั้น
-- ไม่ตรง = nil → เปิดหน้าเลือกให้ลูกค้า (Version อาจเป็นค่าค้างจากสคริปต์อื่นที่ใช้ชื่อเดียวกัน)
local function isRec(v)
    return v.recommended == true or v.recommended == 1
end

local function matchVersion(list, want)
    want = tostring(want or "")
    if want == "" then return nil end
    for _, v in ipairs(list) do
        if tostring(v.id) == want or tostring(v.name) == want then return v end
    end
    return nil
end

-- คืน ok, ข้อความ, รหัส error (ใช้ตัดสินว่าจะให้รอนานแค่ไหนก่อนกดใหม่)
-- pick(list) = ฟังก์ชันให้ผู้ใช้เลือก version คืน entry หรือ nil (ยกเลิก) ; ไม่ส่ง = เลือกอัตโนมัติ
-- ข้อความอายุ key: nil = ไม่จำกัด (ตลอดชีพ), ตัวเลข = วินาทีที่เหลือ
local function fmtRemain(remain)
    remain = tonumber(remain)
    if not remain then return "อายุ key: ไม่จำกัด (Unlimit)" end
    if remain >= 86400 then
        local d = math.floor(remain / 86400)
        local h = math.floor((remain % 86400) / 3600)
        return "อายุ key เหลือ " .. d .. " วัน" .. ((d < 3 and h > 0) and (" " .. h .. " ชม.") or "")
    elseif remain >= 3600 then
        return "อายุ key เหลือ " .. math.floor(remain / 3600) .. " ชม. " .. math.floor((remain % 3600) / 60) .. " นาที"
    end
    return "อายุ key เหลือ " .. math.max(math.floor(remain / 60), 0) .. " นาที"
end

-- ---------- จำ version (+ key) ไว้ใช้ตอน rejoin ----------
-- ลูกค้าติ๊กในหน้าเลือก version = เก็บไฟล์ใน workspace ของ executor (getgenv หายตอนเทเลพอร์ต)
-- key เข้ารหัสด้วย HWID ไว้ (กันอ่านตรง ๆ เท่านั้น ไม่ใช่ความลับ ; key ผูก HWID อยู่แล้ว)
-- executor ที่ไม่มี readfile/writefile = ไม่จำ ทำงานแบบเดิม
local MEM_FILE = "KeySystem/" .. (SLUG:gsub("[^%w%-_]", "_")) .. ".json"
local MEM_PASS = HWID .. "|" .. SLUG .. "|" .. SALT

local function toHex(s)
    return (s:gsub(".", function(c) return string.format("%02x", string.byte(c)) end))
end
local function fromHex(h)
    if #h % 2 == 1 or h:find("[^%x]") then return nil end
    return (h:gsub("%x%x", function(x) return string.char(tonumber(x, 16)) end))
end

-- คืน { version, key? } หรือ nil
local function readMemory()
    local ok, data = pcall(function()
        if not (isfile and readfile) or not isfile(MEM_FILE) then return nil end
        return HttpService:JSONDecode(readfile(MEM_FILE))
    end)
    if not ok or type(data) ~= "table" or type(data.v) ~= "string" or data.v == "" then return nil end
    local mem = { version = data.v }
    local raw = type(data.k) == "string" and fromHex(data.k)
    if raw then
        local okKey, key = pcall(rc4, MEM_PASS, raw)
        -- HWID เปลี่ยน = ถอดได้ขยะ: ไม่ใช้
        if okKey and type(key) == "string" and key:match("^[%w%-_]+$") then mem.key = key end
    end
    return mem
end

local function writeMemory(version, key)
    pcall(function()
        if not writefile then return end
        if makefolder and not (isfolder and isfolder("KeySystem")) then makefolder("KeySystem") end
        writefile(MEM_FILE, HttpService:JSONEncode({ v = version, k = toHex(rc4(MEM_PASS, key)), at = os.time() }))
    end)
end

local function forgetMemory()
    pcall(function()
        if delfile and isfile and isfile(MEM_FILE) then delfile(MEM_FILE) end
    end)
end

-- rejoin = โค้ดที่ฝากผ่าน queue_on_teleport ตั้ง getgenv().KS_REJOIN = true ก่อนเรียก loader ; inject เองไม่มี flag นี้
-- __LTF_REJOIN_RESUME = flag เดิมของ loottoforge (ห้ามล้าง สคริปต์ยังต้องอ่าน)
local isRejoin = genv.KS_REJOIN == true or rawget(_G, "__LTF_REJOIN_RESUME") == true
genv.KS_REJOIN = nil -- อ่านแล้วล้าง: inject ซ้ำใน VM เดิมต้องนับเป็น inject ใหม่
local memory = readMemory()

-- opts.fast = version ที่จำไว้ (rejoin): ขอ token ของ version นั้นเลย ไม่ขอรายการ ไม่ขึ้นหน้าเลือก
-- opts.fromMemory = key มาจากไฟล์ที่จำไว้ (key ใช้ไม่ได้แล้ว = ลืมไฟล์)
-- pick(list, info, memory) คืน entry ที่เลือก (nil = ยกเลิก), ติ๊กจำไว้ไหม
-- คืน ok, ข้อความ, รหัส error, ข้อความอายุ key, หมายเหตุ (เช่น เปลี่ยน version ให้)
local KEY_GONE = { invalid_key = true, key_expired = true, key_disabled = true }
local function tryKey(key, step, pick, opts)
    step = step or function() end
    opts = opts or {}
    if not key or key == "" then return false, "ยังไม่ได้กรอก key", "missing_key" end
    key = tostring(key):gsub("%s+", ""):upper()
    local function refused(d)
        if opts.fromMemory and KEY_GONE[d.error] then forgetMemory() end
        return false, d.message or d.error or "key ใช้ไม่ได้", d.error or "unknown"
    end
    local version, remember, note
    local data, host
    if opts.fast then
        step("rejoin · กำลังเปิด version " .. opts.fast .. "...", 3)
        data, host = apiRedeem(key, { version = opts.fast })
        if not data then return false, tostring(host), "network" end
        if data.ok and data.token then
            version = opts.fast
        elseif data.error ~= "version_not_allowed" then
            return refused(data)
        end
        -- version ที่จำไว้ถูกถอด: ขอรายการแล้วใช้ตัวแนะนำแทน (rejoin ห้ามค้างที่หน้าเลือก)
    end
    if not version then
        step("กำลังตรวจ key กับเซิร์ฟเวอร์...", 1)
        data, host = apiRedeem(key, { list_versions = true })
        if not data then return false, tostring(host), "network" end
        if not data.ok then return refused(data) end
        step("key ถูกต้อง", 2)
    end
    if not version and not data.token then
        -- server ใหม่: ตอบรายการ version มาก่อน ต้องเลือกแล้วขอ token อีกรอบ
        local list = data.versions
        if type(list) ~= "table" or #list == 0 then return false, "ไม่พบ version ที่ใช้ได้กับ key นี้", "no_version" end
        local chosen
        if #list == 1 then
            chosen = list[1]
        elseif opts.fast then
            chosen = list[1]
            for _, v in ipairs(list) do
                if isRec(v) then chosen = v break end
            end
            remember = true
            note = "version " .. opts.fast .. " ถูกปิดแล้ว ใช้ " .. tostring(chosen.name or chosen.id) .. " แทน"
        elseif pick then
            local info
            if data.lifetime == true then info = fmtRemain(nil)
            elseif tonumber(data.key_remaining) then info = fmtRemain(data.key_remaining) end
            chosen, remember = pick(list, info, memory)
            if not chosen then return false, "ยกเลิกการเลือก version", "cancelled" end
        else
            chosen = matchVersion(list, opts.want)
            if not chosen then return false, "Version ที่ตั้งไว้ไม่ตรงกับ version ที่ใช้ได้", "need_pick" end
        end
        version = tostring(chosen.id)
        step("กำลังขอสิทธิ์เปิด version " .. tostring(chosen.name or version) .. "...", 3)
        data, host = apiRedeem(key, { version = version })
        if not data then return false, tostring(host), "network" end
        if not data.ok then return refused(data) end
        if not data.token then return false, "เซิร์ฟเวอร์ไม่ออก token ให้", "load_failed" end
    end
    local before = snapshotGuis()
    local ok, runErr, beforeRun = fetchAndRun(host, data.token, step)
    if not ok and beforeRun and host ~= BASE then
        -- PRIMARY ออก token แล้วแต่ส่งสคริปต์ไม่ได้ (ล่มกลางทาง): ขอ token ใหม่จาก BASE แล้วโหลดจากที่นั่น
        primaryDown = true
        local data2 = redeemOn(BASE, key, nil, version and { version = version } or nil)
        if data2 and data2.ok and data2.token then
            data, host = data2, BASE
            ok, runErr = fetchAndRun(host, data.token, step)
        end
    end
    if not ok then return false, runErr, "load_failed" end
    tokenHost = host
    startGuard(key, data, before, version)
    -- เปลี่ยนไฟล์ที่จำหลังโหลดสำเร็จเท่านั้น: ติ๊ก = จำ, เปิดหน้าเลือกแต่ไม่ติ๊ก = ลืม, ไม่ได้เปิดหน้าเลือก = คงเดิม
    if version and remember == true then
        writeMemory(version, key)
    elseif remember == false then
        forgetMemory()
    elseif opts.fast and version == opts.fast then
        writeMemory(version, key) -- key ใหม่ (ต่ออายุ/ซื้อใหม่) แทนตัวเก่าในไฟล์
    end
    return true, nil, nil, fmtRemain(data.key_remaining), note
end

-- ---------- ถ้าตั้ง getgenv().Key ไว้แล้ว ก็รันเลย ----------
-- ตั้ง Key ไว้ = เปิดหน้าต่างแล้วตรวจ key ให้ ; ขึ้นหน้าเลือก version ทุกครั้งถ้า key มีหลาย version (Version ที่ตั้งไว้ไม่มีผล)
-- ไม่ตั้ง Key แต่เคยติ๊กจำไว้ = ใช้ key ในไฟล์ ; rejoin + มี version ที่จำ = ข้ามหน้าเลือก
local preset = (getgenv and getgenv().Key) or _G.Key
-- ไม่อ่าน getgenv().Version / _G.Version มาเลือก version ให้ (ค่าค้างจากสคริปต์อื่นทำให้ข้ามหน้าเลือก)
-- ล้างทิ้งไว้เหมือนเดิมเผื่อสคริปต์เก่าอ่านค่านี้ ; key ที่มี version เดียวยังเลือกให้อัตโนมัติใน tryKey
if getgenv then getgenv().Version = nil end
_G.Version = nil
local autoKey
if preset and preset ~= "" then
    autoKey = preset
elseif memory and memory.key then
    autoKey = memory.key
end
-- ใช้กับการตรวจ key อัตโนมัติครั้งแรกเท่านั้น (doCheck ล้างทิ้ง กดเองรอบต่อไปเป็นแบบปกติ)
local pendingOpts = {
    fast = isRejoin and memory and memory.version or nil,
    fromMemory = autoKey ~= nil and autoKey ~= preset,
}

-- ---------- หน้ากรอก key ----------
local TweenService = game:GetService("TweenService")

local COL = {
    bg      = Color3.fromRGB(14, 14, 22),
    panel   = Color3.fromRGB(20, 20, 32),
    field   = Color3.fromRGB(28, 28, 44),
    fieldOn = Color3.fromRGB(34, 34, 54),
    line    = Color3.fromRGB(46, 46, 70),
    text    = Color3.fromRGB(240, 242, 250),
    dim     = Color3.fromRGB(140, 145, 170),
    ok      = Color3.fromRGB(80, 220, 150),
    bad     = Color3.fromRGB(255, 82, 92),
}

local gui = Instance.new("ScreenGui")
gui.Name = "KeySystemUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then gui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
if syn and syn.protect_gui then pcall(syn.protect_gui, gui) end

local hasGetKey = GETKEY ~= ""
local hasDiscord = DISCORD ~= ""
local W = 400
local H
-- ตำแหน่งแนวตั้งของหน้ากรอก key (ไล่ต่อกันจากบนลงล่าง)
local Y_STATUS, Y_PILL, Y_BTN, Y_ROW = 117, 162, 172, 226
local Y_GET, Y_DC
do
    local y = Y_ROW + 44
    if hasGetKey then Y_GET = y; y = y + 44 end
    if hasDiscord then Y_DC = y; y = y + 44 end
    H = y + 10
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, W, 0, H)
frame.AnchorPoint = Vector2.new(0.5, 0.5)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = COL.panel
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = gui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

-- จอเล็ก: ย่อทั้งหน้าต่างให้พอดีจอ (ไม่ขยายเกินขนาดจริง) เผื่อสูงสุดตอนหน้าเลือก version
local uiScale = Instance.new("UIScale", frame)
local MAX_H = 470
local contentH = 0 -- ความสูงจริงของหน้าเลือก version (0 = ไม่ได้เปิดอยู่)
local function fitScreen()
    local cam = workspace.CurrentCamera
    local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
    uiScale.Scale = math.clamp(math.min((vp.X - 24) / W, (vp.Y - 24) / math.max(H, MAX_H, contentH)), 0.5, 1)
end
fitScreen()
do
    local cam = workspace.CurrentCamera
    if cam then cam:GetPropertyChangedSignal("ViewportSize"):Connect(fitScreen) end
end

-- ขอบเรืองแสงไล่สีตามโลโก้
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.6
stroke.Transparency = 0.15
local strokeGrad = Instance.new("UIGradient", stroke)
strokeGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(1, ACCENT2),
})
strokeGrad.Rotation = 45

-- พื้นหลังไล่เฉดบาง ๆ
local bgGrad = Instance.new("UIGradient", frame)
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(16, 16, 26)),
})
bgGrad.Rotation = 120

-- แถบไล่สีด้านบน
local bar = Instance.new("Frame")
bar.Size = UDim2.new(1, -32, 0, 3)
bar.Position = UDim2.new(0, 16, 0, 0)
bar.BorderSizePixel = 0
bar.BackgroundColor3 = ACCENT
bar.Parent = frame
Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
local barGrad = Instance.new("UIGradient", bar)
barGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT),
    ColorSequenceKeypoint.new(1, ACCENT2),
})

-- ชื่อแบรนด์ (ไล่สีตัวอักษร)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, hasDiscord and -140 or -60, 0, 26)
title.Position = UDim2.new(0, 18, 0, 16)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 19
title.TextXAlignment = Enum.TextXAlignment.Left
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Text = BRAND
title.Parent = frame
local titleGrad = Instance.new("UIGradient", title)
titleGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 200, 255)),
    ColorSequenceKeypoint.new(1, ACCENT2),
})

local subName = Instance.new("TextLabel")
subName.Size = UDim2.new(1, hasDiscord and -140 or -60, 0, 16)
subName.Position = UDim2.new(0, 18, 0, 41)
subName.BackgroundTransparency = 1
subName.Font = Enum.Font.Gotham
subName.TextSize = 12
subName.TextXAlignment = Enum.TextXAlignment.Left
subName.TextColor3 = COL.dim
subName.Text = (ANNOUNCE ~= "" and ANNOUNCE) or (NAME .. "  -  กรอก key เพื่อเริ่มใช้งาน")
subName.TextTruncate = Enum.TextTruncate.AtEnd
subName.Parent = frame

-- ปุ่มปิด (วาดกากบาทเอง ไม่พึ่งฟอนต์)
local btnClose = Instance.new("TextButton")
btnClose.Size = UDim2.new(0, 30, 0, 30)
btnClose.Position = UDim2.new(1, -42, 0, 14)
btnClose.BackgroundColor3 = COL.field
btnClose.BackgroundTransparency = 0.35
btnClose.BorderSizePixel = 0
btnClose.Text = ""
btnClose.AutoButtonColor = false
btnClose.Parent = frame
Instance.new("UICorner", btnClose).CornerRadius = UDim.new(0, 9)

local function makeSlash(rot)
    local l = Instance.new("Frame")
    l.Size = UDim2.new(0, 13, 0, 1.6)
    l.Position = UDim2.new(0.5, -6.5, 0.5, -0.8)
    l.BackgroundColor3 = COL.dim
    l.BorderSizePixel = 0
    l.Rotation = rot
    l.Parent = btnClose
    Instance.new("UICorner", l).CornerRadius = UDim.new(1, 0)
    return l
end
local slash1, slash2 = makeSlash(45), makeSlash(-45)

btnClose.MouseEnter:Connect(function()
    TweenService:Create(slash1, TweenInfo.new(0.15), { BackgroundColor3 = COL.bad }):Play()
    TweenService:Create(slash2, TweenInfo.new(0.15), { BackgroundColor3 = COL.bad }):Play()
    TweenService:Create(btnClose, TweenInfo.new(0.15), { BackgroundTransparency = 0.1 }):Play()
end)
btnClose.MouseLeave:Connect(function()
    TweenService:Create(slash1, TweenInfo.new(0.15), { BackgroundColor3 = COL.dim }):Play()
    TweenService:Create(slash2, TweenInfo.new(0.15), { BackgroundColor3 = COL.dim }):Play()
    TweenService:Create(btnClose, TweenInfo.new(0.15), { BackgroundTransparency = 0.35 }):Play()
end)
btnClose.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ช่องกรอก key
local boxHolder = Instance.new("Frame")
boxHolder.Size = UDim2.new(1, -36, 0, 44)
boxHolder.Position = UDim2.new(0, 18, 0, 68)
boxHolder.BackgroundColor3 = COL.field
boxHolder.BorderSizePixel = 0
boxHolder.Parent = frame
Instance.new("UICorner", boxHolder).CornerRadius = UDim.new(0, 11)
local boxStroke = Instance.new("UIStroke", boxHolder)
boxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
boxStroke.Color = COL.line
boxStroke.Thickness = 1

local box = Instance.new("TextBox")
box.Size = UDim2.new(1, -24, 1, 0)
box.Position = UDim2.new(0, 12, 0, 0)
box.BackgroundTransparency = 1
box.Font = Enum.Font.Code
box.TextSize = 16
box.TextColor3 = COL.text
box.PlaceholderColor3 = Color3.fromRGB(95, 100, 125)
box.PlaceholderText = "XXXX-XXXX-XXXX-XXXX"
box.Text = ""
box.ClearTextOnFocus = false
box.TextXAlignment = Enum.TextXAlignment.Left
box.Parent = boxHolder

box.Focused:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.18), { Color = ACCENT }):Play()
    TweenService:Create(boxHolder, TweenInfo.new(0.18), { BackgroundColor3 = COL.fieldOn }):Play()
end)
box.FocusLost:Connect(function()
    TweenService:Create(boxStroke, TweenInfo.new(0.18), { Color = COL.line }):Play()
    TweenService:Create(boxHolder, TweenInfo.new(0.18), { BackgroundColor3 = COL.field }):Play()
end)

-- แถบสถานะ
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -36, 0, 40)
status.Position = UDim2.new(0, 18, 0, Y_STATUS)
status.TextWrapped = true
status.TextYAlignment = Enum.TextYAlignment.Top
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 12
status.TextXAlignment = Enum.TextXAlignment.Left
status.TextColor3 = COL.dim
local IDLE_TEXT = (PLAYER.name ~= "" and ("บัญชี: " .. PLAYER.display .. " (@" .. PLAYER.name .. ")  ·  ") or "")
    .. "HWID: " .. string.sub(HWID, 1, 12) .. "..."
status.Text = IDLE_TEXT
status.TextTruncate = Enum.TextTruncate.AtEnd
status.Parent = frame

-- ---------- ปุ่ม ----------
local function hoverable(btn, base, hover)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = hover }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.15), { BackgroundColor3 = base }):Play()
    end)
end

local function smallButton(txt, x, y, w)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 0, 36)
    b.Position = UDim2.new(0, x, 0, y)
    b.BackgroundColor3 = COL.field
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamMedium
    b.TextSize = 13
    b.TextColor3 = Color3.fromRGB(215, 220, 240)
    b.Text = txt
    b.AutoButtonColor = false
    b.Parent = frame
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    local st = Instance.new("UIStroke", b)
    st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- เส้นรอบปุ่ม ไม่ใช่รอบตัวหนังสือ
    st.Color = COL.line
    st.Thickness = 1
    hoverable(b, COL.field, COL.fieldOn)
    return b
end

-- ปุ่มยืนยัน (ไล่สีตามโลโก้)
local btnCheck = Instance.new("TextButton")
btnCheck.Size = UDim2.new(1, -36, 0, 42)
btnCheck.Position = UDim2.new(0, 18, 0, Y_BTN)
btnCheck.BackgroundTransparency = 1 -- สีพื้น/gradient อยู่ที่ checkBg (gradient บนปุ่มจะคูณสีตัวหนังสือด้วย)
btnCheck.ZIndex = 2
btnCheck.BorderSizePixel = 0
btnCheck.Font = Enum.Font.GothamBold
btnCheck.TextSize = 15
btnCheck.TextColor3 = Color3.fromRGB(255, 255, 255)
btnCheck.Text = "ยืนยัน Key"
btnCheck.AutoButtonColor = false
btnCheck.Parent = frame
local checkBg = Instance.new("Frame")
checkBg.Size = btnCheck.Size
checkBg.Position = btnCheck.Position
checkBg.BackgroundColor3 = ACCENT
checkBg.BorderSizePixel = 0
checkBg.ZIndex = 1
checkBg.Parent = frame
Instance.new("UICorner", checkBg).CornerRadius = UDim.new(0, 11)
Instance.new("UICorner", btnCheck).CornerRadius = UDim.new(0, 11)
local checkGrad = Instance.new("UIGradient", checkBg)
checkGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, ACCENT),
    ColorSequenceKeypoint.new(1, ACCENT2),
})
btnCheck.MouseEnter:Connect(function()
    TweenService:Create(checkGrad, TweenInfo.new(0.2), { Offset = Vector2.new(0.15, 0) }):Play()
end)
btnCheck.MouseLeave:Connect(function()
    TweenService:Create(checkGrad, TweenInfo.new(0.2), { Offset = Vector2.new(0, 0) }):Play()
end)

-- แถบความคืบหน้า 4 ขั้น: ตรวจ key -> เลือก version -> ขอสิทธิ์ -> โหลดสคริปต์
local STAGES = 4
local pillTrack = Instance.new("Frame")
pillTrack.Size = UDim2.new(1, -36, 0, 4)
pillTrack.Position = UDim2.new(0, 18, 0, Y_PILL)
pillTrack.BackgroundTransparency = 1
pillTrack.Parent = frame
local pills = {}
for i = 1, STAGES do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1 / STAGES, i == STAGES and 0 or -6, 1, 0)
    p.Position = UDim2.new((i - 1) / STAGES, 0, 0, 0)
    p.BackgroundColor3 = COL.line
    p.BorderSizePixel = 0
    p.Parent = pillTrack
    Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
    pills[i] = p
end
local pulse
-- stage = ขั้นที่กำลังทำ (ขั้นก่อนหน้าเต็มสี), state "run" | "bad" | "ok" (ok = เต็มทุกขั้น), nil = ล้างหมด
local function setStage(stage, state)
    if pulse then pulse:Cancel() pulse = nil end
    for i, p in ipairs(pills) do
        p.BackgroundTransparency = 0
        if state == "ok" then
            p.BackgroundColor3 = COL.ok
        elseif not stage then
            p.BackgroundColor3 = COL.line
        elseif i < stage then
            p.BackgroundColor3 = ACCENT
        elseif i == stage then
            p.BackgroundColor3 = (state == "bad") and COL.bad or ACCENT2
        else
            p.BackgroundColor3 = COL.line
        end
    end
    if stage and state == "run" then
        local p = pills[stage]
        p.BackgroundTransparency = 0.1
        pulse = TweenService:Create(p, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.75 })
        pulse:Play()
    end
end

-- วงหมุนในปุ่มระหว่างทำงาน (เส้นขอบวงกลม + ไล่ความโปร่งใส = ส่วนโค้ง แล้วหมุน gradient)
local spinner = Instance.new("Frame")
spinner.Size = UDim2.new(0, 18, 0, 18)
spinner.Position = UDim2.new(0, 14, 0.5, -9)
spinner.BackgroundTransparency = 1
spinner.Visible = false
spinner.Parent = btnCheck
Instance.new("UICorner", spinner).CornerRadius = UDim.new(1, 0)
local spinStroke = Instance.new("UIStroke", spinner)
spinStroke.Thickness = 2.4
spinStroke.Color = Color3.new(1, 1, 1)
local spinGrad = Instance.new("UIGradient", spinStroke)
spinGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.6, 0.15),
    NumberSequenceKeypoint.new(0.61, 1),
    NumberSequenceKeypoint.new(1, 1),
})
local spinConn
local function setSpinning(on)
    spinner.Visible = on
    if on and not spinConn then
        spinConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
            spinGrad.Rotation = (spinGrad.Rotation + dt * 420) % 360
        end)
    elseif not on and spinConn then
        spinConn:Disconnect()
        spinConn = nil
    end
end

-- แถวปุ่มรอง: วาง Key / คัดลอก HWID
-- หาฟังก์ชันอ่านคลิปบอร์ดของ executor ถ้าไม่มีจะไม่สร้างปุ่ม "วาง Key" เลย
local pasteFn
for _, fn in ipairs({
    getclipboard,
    getclipboardtext,
    (syn and syn.get_clipboard),
    (fluxus and fluxus.get_clipboard),
    (clipboard and clipboard.get),
}) do
    if type(fn) == "function" then pasteFn = fn break end
end

local btnPaste, btnCopy
if pasteFn then
    btnPaste = smallButton("วาง Key", 18, Y_ROW, 178)
    btnCopy  = smallButton("คัดลอก HWID", 204, Y_ROW, 178)
else
    btnCopy  = smallButton("คัดลอก HWID", 18, Y_ROW, W - 36)
end

local btnGet
if hasGetKey then
    btnGet = smallButton("คัดลอกลิงก์รับ Key", 18, Y_GET, W - 36)
end

-- Discord: ปุ่มล่าง (กดคัดลอกลิงก์) + ชิปมุมขวาบนข้างปุ่มปิด; ว่าง = ไม่สร้าง
local btnDiscord, chipDiscord, btnDiscordStroke
if hasDiscord then
    btnDiscord = smallButton("ขอความช่วยเหลือที่ Discord", 18, Y_DC, W - 36)
    btnDiscordStroke = btnDiscord:FindFirstChildOfClass("UIStroke")
    chipDiscord = Instance.new("TextButton")
    chipDiscord.Size = UDim2.new(0, 64, 0, 30)
    chipDiscord.Position = UDim2.new(1, -112, 0, 14)
    chipDiscord.BackgroundColor3 = COL.field
    chipDiscord.BackgroundTransparency = 0.35
    chipDiscord.BorderSizePixel = 0
    chipDiscord.Font = Enum.Font.GothamMedium
    chipDiscord.TextSize = 12
    chipDiscord.TextColor3 = COL.dim
    chipDiscord.Text = "Discord"
    chipDiscord.AutoButtonColor = false
    chipDiscord.Parent = frame
    Instance.new("UICorner", chipDiscord).CornerRadius = UDim.new(0, 9)
    hoverable(chipDiscord, COL.field, COL.fieldOn)
end

-- ---------- การทำงานของปุ่ม ----------
local function setStatus(msg, color)
    status.TextColor3 = color or COL.dim
    status.Text = msg
end

-- ปุ่มยืนยัน: เปิด/ปิดใช้งาน (ปิด = จางลง กดไม่ได้)
local function setCheckEnabled(on)
    btnCheck.Active = on
    TweenService:Create(checkBg, TweenInfo.new(0.15), { BackgroundTransparency = on and 0 or 0.55 }):Play()
end

-- ข้อความ error: { หัวข้อสั้นเมื่อ server ไม่ส่งข้อความมา, สิ่งที่ควรทำต่อ }
local ERR = {
    invalid_key      = { "ไม่พบ key นี้", "ตรวจว่าคัดลอกครบและไม่มีตัวอักษรเกิน แล้วแก้ key ก่อนกดใหม่" },
    missing_key      = { "ยังไม่ได้กรอก key", "วาง key ที่ได้จากหน้า \"คลังของฉัน\" ในเว็บร้าน" },
    key_expired      = { "key หมดอายุแล้ว", "ต่ออายุหรือซื้อ key ใหม่ที่เว็บร้าน" },
    key_disabled     = { "key ถูกระงับการใช้งาน", "ติดต่อแอดมินเพื่อสอบถาม" },
    key_scope        = { "key นี้ใช้กับสคริปต์นี้ไม่ได้", "ตรวจว่าซื้อ key ตรงกับสคริปต์ที่รัน" },
    hwid_limit       = { "key ถูกใช้กับเครื่องครบจำนวนแล้ว", "ขอรีเซ็ต HWID ที่เว็บร้านหรือติดต่อแอดมิน" },
    hwid_mismatch    = { "key นี้ผูกกับเครื่องอื่นแล้ว", "ขอรีเซ็ต HWID ที่เว็บร้านหรือติดต่อแอดมิน" },
    missing_hwid     = { "อ่าน HWID ไม่ได้", "executor นี้อาจไม่รองรับ ลองเปลี่ยน executor" },
    blocked          = { "ถูกบล็อกชั่วคราว (ใส่ key ผิดถี่เกินไป)", "รอสักพักแล้วลองใหม่ ถ้ายังไม่หายติดต่อแอดมิน" },
    maintenance      = { "ระบบกำลังปรับปรุง", "รอสักครู่แล้วลองใหม่" },
    script_disabled  = { "สคริปต์นี้ถูกปิดใช้งานชั่วคราว", "ติดตามประกาศจากแอดมิน" },
    script_not_found = { "ไม่พบสคริปต์นี้", "ติดต่อแอดมิน" },
    version_not_allowed = { "key นี้ใช้ version นี้ไม่ได้", "เลือก version อื่น" },
    no_version       = { "ไม่พบ version ที่ใช้ได้กับ key นี้", "ติดต่อแอดมิน" },
    network          = { "ต่อเซิร์ฟเวอร์ไม่ได้", "เช็คอินเทอร์เน็ต/ปิด VPN แล้วลองใหม่" },
    load_failed      = { "โหลดสคริปต์ไม่สำเร็จ", "ลองใหม่อีกครั้ง ถ้ายังไม่ได้ติดต่อแอดมิน" },
}
-- รวมข้อความจาก server (ถ้ามี) กับคำแนะนำขั้นต่อไป
local function explain(code, msg)
    local e = ERR[code]
    msg = (msg and msg ~= "") and tostring(msg) or (e and e[1]) or "เกิดข้อผิดพลาด"
    if code == "network" then msg = e[1] end
    return e and (msg .. "\n→ " .. e[2]) or msg
end

if btnPaste then
    btnPaste.MouseButton1Click:Connect(function()
        local ok, txt = pcall(pasteFn)
        if ok and type(txt) == "string" and txt ~= "" then
            box.Text = (txt:gsub("%s+", ""))
            setStatus("วาง key จากคลิปบอร์ดแล้ว", COL.ok)
        else
            box:CaptureFocus()
        end
    end)
end

btnCopy.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(HWID)
        setStatus("คัดลอก HWID แล้ว", COL.ok)
    else
        setStatus("executor นี้คัดลอกไม่ได้", COL.bad)
    end
end)

if btnGet then
    btnGet.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(GETKEY)
            setStatus("คัดลอกลิงก์แล้ว เอาไปเปิดในเบราว์เซอร์", COL.ok)
        else
            setStatus(GETKEY, COL.dim)
        end
    end)
end

local function copyDiscord()
    if setclipboard then
        setclipboard(DISCORD)
        setStatus("คัดลอกลิงก์ Discord แล้ว เอาไปวางในเบราว์เซอร์", COL.ok)
    else
        setStatus("Discord: " .. DISCORD, COL.dim)
    end
end
if btnDiscord then btnDiscord.MouseButton1Click:Connect(copyDiscord) end
if chipDiscord then chipDiscord.MouseButton1Click:Connect(copyDiscord) end

-- กันกดรัว: ระหว่างทำงานกดซ้ำไม่ได้ / พลาดแล้วต้องรอ (2, 4, 8 ... สูงสุด 30 วิ)
-- key ที่เซิร์ฟเวอร์บอกว่า "ไม่มีอยู่จริง" จำไว้ ไม่ส่งซ้ำ (ส่งซ้ำ ๆ = โดนบล็อกเหมือนคนสุ่ม key)
local busy = false
local fails = 0
local readyAt = 0
local badKeys = {}
local LONG_WAIT = { blocked = 60, maintenance = 30 }

local function countdown()
    setCheckEnabled(false)
    while os.clock() < readyAt and gui.Parent do
        btnCheck.Text = "ลองใหม่ได้ใน " .. math.ceil(readyAt - os.clock()) .. " วิ"
        task.wait(0.25)
    end
    if gui.Parent then
        btnCheck.Text = "ยืนยัน Key"
        setCheckEnabled(true)
    end
end

-- ---------- หน้าเลือก version (แสดงหลัง key ผ่าน ก่อนขอ token) ----------
-- คืน entry ของ version ที่เลือก (nil ถ้ากดย้อนกลับ/ปิดหน้าต่าง) และติ๊ก "ใช้ตอน rejoin" ไว้ไหม
-- mem = ที่จำไว้ (readMemory): เลือก version นั้นไว้ก่อนและติ๊กไว้ให้
local keyWidgets = { boxHolder, checkBg, btnCheck, btnCopy, btnPaste, btnGet, btnDiscord, pillTrack }
local function showKeyWidgets(on)
    for _, w in pairs(keyWidgets) do w.Visible = on end
end

-- ปรับขนาดหน้าต่างเอง: ต้องยกเลิก tween เปิดตัวก่อน ไม่งั้นมันเขียนทับกลับเป็น H (server ตอบเร็วกว่า 0.28 วิ)
local openTween
local function setFrameHeight(h, content)
    if openTween then pcall(function() openTween:Cancel() end) end
    frame.BackgroundTransparency = 0
    frame.Size = UDim2.new(0, W, 0, h)
    contentH = content or 0
    fitScreen()
end

local function pickVersion(versions, info, mem)
    showKeyWidgets(false)
    status.Visible = false
    setSpinning(false)
    setStage(2, "run")

    local holder = Instance.new("Frame")
    holder.BackgroundTransparency = 1
    holder.Size = UDim2.new(1, 0, 1, -68)
    holder.Position = UDim2.new(0, 0, 0, 68)
    holder.Parent = frame

    local chosen, done = nil, false
    local function label(txt, y, h, size, color)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(1, -36, 0, h)
        l.Position = UDim2.new(0, 18, 0, y)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.Gotham
        l.TextSize = size
        l.TextColor3 = color
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.Text = txt
        l.Parent = holder
        return l
    end

    local y = 0
    label("key ถูกต้อง — เลือก version ที่ต้องการใช้", y, 18, 13, COL.ok)
    y = y + 22
    if info then
        label(info, y, 16, 12, COL.dim)
        y = y + 20
    end
    y = y + 4

    local ROW, MAXROWS = 40, 4
    local sel = versions[1]
    for _, v in ipairs(versions) do
        if isRec(v) then sel = v break end
    end
    sel = (mem and matchVersion(versions, mem.version)) or sel
    local rows, confirm = {}, nil
    local function refresh()
        for v, r in pairs(rows) do
            local on = (v == sel)
            r.b.BackgroundColor3 = on and COL.fieldOn or COL.field
            r.st.Color = on and ACCENT or COL.line
            r.st.Thickness = on and 2 or 1
        end
        if confirm then confirm.Text = "ยืนยัน  ·  " .. tostring(sel.name or sel.id) end
    end

    -- แถว: ชื่อ version อยู่คอลัมน์ซ้ายกว้างคงที่ ส่วนหมายเหตุใช้ที่เหลือทั้งหมด (ขึ้นได้ถึง 3 บรรทัด แถวสูงเฉพาะแถวที่ยาว)
    local NAMEW, PAD = 80, 3 -- PAD = กันเส้นขอบแถวที่เลือกโดน ScrollingFrame ตัด
    local TextService = game:GetService("TextService")
    local function layout(scroll)
        local rowW = (W - 36) - (scroll and 6 or 0)
        local noteW = rowW - 12 - NAMEW - 12
        local hs, tags, total = {}, {}, 0
        for i, v in ipairs(versions) do
            local tag = (isRec(v) and "แนะนำ") or (v.note and tostring(v.note)) or ""
            local lines = 1
            if tag ~= "" then
                local ok, sz = pcall(function()
                    return TextService:GetTextSize(tag, 11, Enum.Font.Gotham, Vector2.new(noteW, 1000))
                end)
                if ok and sz then lines = math.clamp(math.ceil(sz.Y / 13), 1, 3) end
            end
            tags[i] = tag
            hs[i] = math.max(ROW - 6, lines * 13 + 14)
            total = total + hs[i] + (i < #versions and 6 or 0)
        end
        return hs, tags, total, noteW
    end
    local hs, tags, total, noteW = layout(false)
    -- <= MAXROWS แถว: สูงตามแถวจริง (เพดานสูงกว่าเดิม 40px กันแถวหมายเหตุ 2 บรรทัดทำให้เกิด scroll เปล่า ๆ) ; มากกว่านั้นเลื่อน
    local cap = (#versions <= MAXROWS) and (MAXROWS * ROW + 40) or (MAXROWS * ROW)
    local scroll = total > cap
    if scroll then hs, tags, total, noteW = layout(true) end
    local viewH = math.min(total, cap)

    local list = Instance.new("ScrollingFrame")
    -- list กว้าง/สูงกว่าแถว PAD รอบด้าน ให้เส้นขอบ 2px ไม่ถูกตัด ; ขอบแถวยังตรงกับปุ่มยืนยัน
    list.Size = UDim2.new(1, -36 + PAD * 2, 0, viewH + PAD * 2)
    list.Position = UDim2.new(0, 18 - PAD, 0, y - PAD)
    list.BackgroundTransparency = 1
    list.BorderSizePixel = 0
    list.ScrollBarThickness = scroll and 3 or 0
    list.ScrollingEnabled = scroll
    list.CanvasSize = UDim2.new(0, 0, 0, total + PAD * 2)
    list.Parent = holder
    local ry = PAD
    for i, v in ipairs(versions) do
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, -(PAD * 2) - (scroll and 6 or 0), 0, hs[i])
        b.Position = UDim2.new(0, PAD, 0, ry)
        ry = ry + hs[i] + 6
        b.BackgroundColor3 = COL.field
        b.BorderSizePixel = 0
        b.Text = ""
        b.AutoButtonColor = false
        b.Parent = list
        Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", b)
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border -- เส้นรอบแถว ไม่ใช่รอบตัวหนังสือ
        st.Color = COL.line
        st.Thickness = 1
        rows[v] = { b = b, st = st }
        local nm = Instance.new("TextLabel")
        nm.Size = UDim2.new(0, NAMEW, 1, 0)
        nm.Position = UDim2.new(0, 12, 0, 0)
        nm.BackgroundTransparency = 1
        nm.Font = Enum.Font.GothamMedium
        nm.TextSize = 13
        nm.TextColor3 = Color3.fromRGB(215, 220, 240)
        nm.TextXAlignment = Enum.TextXAlignment.Left
        nm.TextTruncate = Enum.TextTruncate.AtEnd
        nm.Text = tostring(v.name or v.id)
        nm.Parent = b
        if tags[i] ~= "" then
            local t = Instance.new("TextLabel")
            t.Size = UDim2.new(0, noteW, 1, 0)
            t.Position = UDim2.new(0, 12 + NAMEW, 0, 0)
            t.BackgroundTransparency = 1
            t.Font = Enum.Font.Gotham
            t.TextSize = 11
            t.TextColor3 = isRec(v) and ACCENT or COL.dim
            t.TextXAlignment = Enum.TextXAlignment.Left
            t.TextWrapped = true
            t.Text = tags[i]
            t.Parent = b
        end
        b.MouseButton1Click:Connect(function() sel = v refresh() end)
    end
    y = y + viewH + 8

    -- ติ๊ก = rejoin ครั้งต่อไปโหลด version นี้ด้วย key นี้เลยไม่ถาม ; inject เองครั้งหน้าเลือกใหม่ได้
    local remember = mem ~= nil
    local tick = Instance.new("TextButton")
    tick.Size = UDim2.new(1, -36, 0, 34)
    tick.Position = UDim2.new(0, 18, 0, y)
    tick.BackgroundTransparency = 1
    tick.AutoButtonColor = false
    tick.Text = ""
    tick.Parent = holder
    local tickBox = Instance.new("Frame")
    tickBox.Size = UDim2.new(0, 18, 0, 18)
    tickBox.Position = UDim2.new(0, 0, 0, 2)
    tickBox.BorderSizePixel = 0
    tickBox.Parent = tick
    Instance.new("UICorner", tickBox).CornerRadius = UDim.new(0, 5)
    local tickStroke = Instance.new("UIStroke", tickBox)
    tickStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    local tickDot = Instance.new("Frame")
    tickDot.Size = UDim2.new(0, 8, 0, 8)
    tickDot.Position = UDim2.new(0.5, -4, 0.5, -4)
    tickDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    tickDot.BorderSizePixel = 0
    tickDot.Parent = tickBox
    Instance.new("UICorner", tickDot).CornerRadius = UDim.new(0, 2)
    local tickText = Instance.new("TextLabel")
    tickText.Size = UDim2.new(1, -28, 0, 16)
    tickText.Position = UDim2.new(0, 28, 0, 3)
    tickText.BackgroundTransparency = 1
    tickText.Font = Enum.Font.GothamMedium
    tickText.TextSize = 12
    tickText.TextColor3 = COL.text
    tickText.TextXAlignment = Enum.TextXAlignment.Left
    tickText.Text = "ใช้ version นี้ตอน rejoin (จำ key ไว้ให้ด้วย)"
    tickText.Parent = tick
    local tickHint = Instance.new("TextLabel")
    tickHint.Size = UDim2.new(1, -28, 0, 14)
    tickHint.Position = UDim2.new(0, 28, 0, 19)
    tickHint.BackgroundTransparency = 1
    tickHint.Font = Enum.Font.Gotham
    tickHint.TextSize = 11
    tickHint.TextColor3 = COL.dim
    tickHint.TextXAlignment = Enum.TextXAlignment.Left
    tickHint.Text = "inject เองครั้งหน้า เลือก version ใหม่ได้"
    tickHint.Parent = tick
    local function paintTick()
        tickBox.BackgroundColor3 = remember and ACCENT or COL.field
        tickStroke.Color = remember and ACCENT or COL.line
        tickDot.Visible = remember
    end
    tick.MouseButton1Click:Connect(function()
        remember = not remember
        paintTick()
    end)
    paintTick()
    y = y + 42

    -- สีพื้น + gradient อยู่ที่ confirmBg (พี่น้อง ZIndex ต่ำกว่า) ไม่ใส่ที่ปุ่ม ไม่งั้นสีตัวหนังสือถูกคูณด้วย gradient
    local confirmBg = Instance.new("Frame")
    confirmBg.Size = UDim2.new(1, -36, 0, 42)
    confirmBg.Position = UDim2.new(0, 18, 0, y)
    confirmBg.BackgroundColor3 = ACCENT
    confirmBg.BorderSizePixel = 0
    confirmBg.ZIndex = 1
    confirmBg.Parent = holder
    Instance.new("UICorner", confirmBg).CornerRadius = UDim.new(0, 11)
    confirm = Instance.new("TextButton")
    confirm.Size = UDim2.new(1, -36, 0, 42)
    confirm.Position = UDim2.new(0, 18, 0, y)
    confirm.BackgroundTransparency = 1
    confirm.ZIndex = 2
    confirm.BorderSizePixel = 0
    confirm.Font = Enum.Font.GothamBold
    confirm.TextSize = 15
    confirm.TextColor3 = Color3.fromRGB(255, 255, 255)
    confirm.AutoButtonColor = false
    confirm.Parent = holder
    local g = Instance.new("UIGradient", confirmBg)
    g.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, ACCENT), ColorSequenceKeypoint.new(1, ACCENT2) })
    confirm.MouseButton1Click:Connect(function() chosen, done = sel, true end)
    refresh()
    y = y + 50

    local back = smallButton("ย้อนกลับ", 18, 68 + y, W - 36)
    back.Parent = holder
    back.Position = UDim2.new(0, 18, 0, y)
    back.MouseButton1Click:Connect(function() done = true end)
    y = y + 36

    setFrameHeight(68 + y + 18, 68 + y + 18)
    while not done and gui.Parent do task.wait(0.1) end

    holder:Destroy()
    setFrameHeight(H, 0)
    -- เลือกแล้ว: คงช่องกรอก key ซ่อนไว้ โชว์แค่สถานะระหว่างขอ token (doCheck คืนช่องกรอกเองถ้าล้มเหลว)
    status.Visible = true
    if chosen then
        setSpinning(true)
        pillTrack.Visible = true
        setStage(3, "run")
    else
        showKeyWidgets(true)
    end
    return chosen, chosen ~= nil and remember
end

local function doCheck()
    if busy then return end
    if os.clock() < readyAt then return end -- ปุ่มแสดงเวลานับถอยหลังอยู่แล้ว ไม่ทับข้อความ error
    local key = tostring(box.Text or ""):gsub("%s+", ""):upper()
    if key == "" then
        setStatus(explain("missing_key"), COL.bad)
        box:CaptureFocus()
        return
    end
    if badKeys[key] then
        setStatus(badKeys[key] .. "\n(key นี้ตรวจแล้ว ไม่ส่งซ้ำ — แก้ key ก่อน)", COL.bad)
        return
    end
    busy = true
    setCheckEnabled(false)
    setSpinning(true)
    setStage(1, "run")
    local stage = 1
    if btnDiscord then TweenService:Create(btnDiscordStroke, TweenInfo.new(0.2), { Color = COL.line }):Play() end
    btnCheck.Text = "      กำลังตรวจสอบ..."
    task.spawn(function()
        local opts = pendingOpts or {}
        pendingOpts = nil
        local ok, err, code, remainText, note = tryKey(key, function(msg, st)
            if st and st ~= stage then
                stage = st
                setStage(stage, "run")
            end
            setStatus(string.format("[%d/%d] %s", stage, STAGES, msg))
        end, pickVersion, opts)
        setSpinning(false)
        if not ok then showKeyWidgets(true) end
        if code == "cancelled" then
            -- ย้อนกลับจากหน้าเลือก version: ไม่ใช่ความผิดพลาด ไม่ต้องรอ backoff
            busy = false
            setStage(nil)
            setCheckEnabled(true)
            btnCheck.Text = "ยืนยัน Key"
            setStatus(IDLE_TEXT)
            return
        end
        if ok then
            setStage(STAGES, "ok")
            setStatus("สำเร็จ! เปิดสคริปต์แล้ว · " .. remainText, COL.ok)
            btnCheck.Text = "สำเร็จ"
            notify(BRAND, "โหลด " .. NAME .. " สำเร็จ · " .. remainText)
            if note then notify(BRAND, note) end
            task.wait(0.5)
            local out = TweenService:Create(frame, TweenInfo.new(0.25), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, W - 30, 0, H - 20),
            })
            out:Play()
            out.Completed:Wait()
            gui:Destroy()
            return
        end
        local text = explain(code, err)
        if code == "invalid_key" then badKeys[key] = tostring(err) end
        fails = fails + 1
        local waitSec = LONG_WAIT[code] or math.min(2 ^ fails, 30)
        readyAt = os.clock() + waitSec
        setStage(stage, "bad")
        setStatus(text, COL.bad)
        if btnDiscord then TweenService:Create(btnDiscordStroke, TweenInfo.new(0.2), { Color = COL.bad }):Play() end
        busy = false
        countdown()
    end)
end

btnCheck.MouseButton1Click:Connect(doCheck)
box.FocusLost:Connect(function(enterPressed)
    if enterPressed then doCheck() end
end)

-- เปิดตัวแบบนุ่ม ๆ
frame.Size = UDim2.new(0, W - 24, 0, H - 16)
frame.BackgroundTransparency = 0.4
openTween = TweenService:Create(frame, TweenInfo.new(0.28, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, W, 0, H),
    BackgroundTransparency = 0,
})
openTween:Play()

if autoKey then
    box.Text = tostring(autoKey)
    task.defer(doCheck)
end
