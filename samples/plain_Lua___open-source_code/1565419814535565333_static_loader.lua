getgenv().renzo_key = "KEY-F9894241-618B8B45-1F6A2E5A"

local Players    = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local RunService  = game:GetService("RunService")


-- Set to false if legit users on unusual executors get false "tampered" kicks.
local STRICT_HOOK_CHECK = true

local _real_loadstring = rawget(getfenv and getfenv(0) or _G, "loadstring") or loadstring

-- Native executor functions are C closures. A script-level hook (the usual dumper:
-- loadstring = function(src) writefile(...) ... end) is a Lua closure, so it gives itself away.
local function looksHooked(fn)
    if type(fn) ~= "function" then return true end
    local ok, src = pcall(function() return debug.info(fn, "s") end)
    if ok and type(src) == "string" and src ~= "[C]" then return true end
    if type(iscclosure) == "function" then
        local ok2, isC = pcall(iscclosure, fn)
        if ok2 and isC == false then return true end
    end
    return false
end

local function currentLoadstring()
    return rawget(getfenv and getfenv(0) or _G, "loadstring") or loadstring
end

-- Anything that can be used to dump a payload to disk or the clipboard.
local DUMP_FNS = { "loadstring", "writefile", "appendfile", "setclipboard", "toclipboard" }
local function findHookedDumper()
    local env = getfenv and getfenv(0) or _G
    for _, name in ipairs(DUMP_FNS) do
        local fn = rawget(env, name)
        if fn ~= nil and looksHooked(fn) then return name end
    end
    return nil
end

local function safeLoadstring(src)
    local current = currentLoadstring()
    if current ~= _real_loadstring or (STRICT_HOOK_CHECK and looksHooked(current)) then
        pcall(function() Players.LocalPlayer:Kick("[RP] env tampered") end)
        return nil, "tampered"
    end
    return _real_loadstring(src)
end



local _k
local function _d(t)
    local r = {}
    for i = 1, #t do
        r[i] = string.char(bit32.bxor(t[i], _k[(i - 1) % #_k + 1]))
    end
    return table.concat(r)
end


local function deriveKey(hwid, nonce)
    local combined = tostring(hwid) .. ":" .. tostring(nonce)
    local key = {0,0,0,0,0,0,0,0,0,0,0}
    for i = 1, #combined do
        local idx = (i - 1) % 11 + 1
        key[idx] = bit32.bxor(key[idx], string.byte(combined, i))
    end
    return key
end


local SCRIPT_KEY = (getgenv and (getgenv().renzo_key or getgenv().key)) or ""
local DEBUG      = (getgenv and getgenv().renzo_debug) or false
local BASE_URL   = "https://renzoauth.lol"
local API_URL    = BASE_URL .. "/api/load"

local gui, fillBar, label, hbConn
local shown, target, creepMax = 0, 0, 0

local function guiParent()
    local ok, h = pcall(function() return gethui and gethui() end)
    if ok and h then return h end
    local ok2, core = pcall(function() return game:GetService("CoreGui") end)
    if ok2 and core then return core end
    return Players.LocalPlayer:WaitForChild("PlayerGui")
end

local function createUI()
    if getgenv and getgenv()._rp_loaded then return end
    pcall(function()
        gui = Instance.new("ScreenGui")
        gui.Name = "RenzoLoading"
        gui.ResetOnSpawn = false
        gui.IgnoreGuiInset = true
        gui.DisplayOrder = 999999
        pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)

        local frame = Instance.new("Frame")
        frame.AnchorPoint = Vector2.new(0.5, 0.5)
        frame.Position    = UDim2.new(0.5, 0, 0.5, 0)
        frame.Size        = UDim2.new(0, 320, 0, 84)
        frame.BackgroundColor3 = Color3.fromRGB(11, 11, 13)
        frame.BorderSizePixel  = 0
        frame.Parent = gui
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
        local stroke = Instance.new("UIStroke", frame)
        stroke.Color     = Color3.fromRGB(124, 92, 255)
        stroke.Thickness = 1.5

        label = Instance.new("TextLabel")
        label.BackgroundTransparency = 1
        label.Position  = UDim2.new(0, 0, 0, 12)
        label.Size      = UDim2.new(1, 0, 0, 30)
        label.Font      = Enum.Font.GothamBold
        label.TextSize  = 20
        label.TextColor3 = Color3.fromRGB(236, 236, 241)
        label.Text      = "renzo loading (0%)"
        label.Parent    = frame

        local track = Instance.new("Frame")
        track.AnchorPoint = Vector2.new(0.5, 0)
        track.Position    = UDim2.new(0.5, 0, 0, 54)
        track.Size        = UDim2.new(1, -40, 0, 8)
        track.BackgroundColor3 = Color3.fromRGB(36, 36, 43)
        track.BorderSizePixel  = 0
        track.Parent = frame
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        fillBar = Instance.new("Frame")
        fillBar.Size = UDim2.new(0, 0, 1, 0)
        fillBar.BackgroundColor3 = Color3.fromRGB(124, 92, 255)
        fillBar.BorderSizePixel  = 0
        fillBar.Parent = track
        Instance.new("UICorner", fillBar).CornerRadius = UDim.new(1, 0)

        gui.Parent = guiParent()

        hbConn = RunService.Heartbeat:Connect(function(dt)
            if target < creepMax then
                target = math.min(creepMax, target + dt * 10)
            end
            shown = shown + (target - shown) * math.min(1, dt * 10)
            if fillBar then fillBar.Size = UDim2.new(math.clamp(shown / 100, 0, 1), 0, 1, 0) end
            if label   then label.Text   = string.format("renzo loading (%d%%)", math.floor(shown + 0.5)) end
        end)
    end)
end

local function setStage(base, creep)
    target   = math.max(target, base)
    creepMax = creep or base
end

local function closeUI()
    pcall(function() if hbConn then hbConn:Disconnect() end end)
    pcall(function() if gui    then gui:Destroy()        end end)
    gui, fillBar, label, hbConn = nil, nil, nil, nil
end

local T0 = os.clock()
local function lap(name)
    if DEBUG then
        print(string.format("[Renzos Priv][timing] %s: %.0f ms", name, (os.clock() - T0) * 1000))
    end
end

local function kickPlayer(message)
    closeUI()
    pcall(function() Players.LocalPlayer:Kick(message) end)
end

if SCRIPT_KEY == "" then
    warn("[Renzos Priv] Set your key first: getgenv().renzo_key = 'YOUR_KEY'")
    kickPlayer("[Renzos Priv] Missing key.")
    return
end


local function getHWID()
    if gethwid then return gethwid() end
    if syn and syn.get_hwid then return syn.get_hwid() end
    -- RbxAnalyticsService is acceptable (executor-provided, not player-controlled)
    local ok, clientId = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    if ok and clientId then return clientId end
    -- UserId+JobId fallback is spoofable — kick instead of accepting it
    kickPlayer("[Renzos Priv] Unsupported executor. Use a supported exploit.")
    return nil
end


local function httpPost(url, body, extraHeaders)
    local jsonBody = HttpService:JSONEncode(body)
    local headers  = { ["Content-Type"] = "application/json" }
    if extraHeaders then
        for k, v in pairs(extraHeaders) do headers[k] = v end
    end
    local req = request or http_request or (syn and syn.request)
    if req then
        return req({ Url = url, Method = "POST", Headers = headers, Body = jsonBody }).Body
    end
    return HttpService:PostAsync(url, jsonBody, Enum.HttpContentType.ApplicationJson)
end

local function httpGet(url)
    local req = request or http_request or (syn and syn.request)
    if req then
        return req({ Url = url, Method = "GET", Headers = {} }).Body
    end
    return HttpService:GetAsync(url)
end

local function reportTamper(hwid, what)
    pcall(function()
        httpPost(BASE_URL .. "/api/leak-detected", {
            key    = SCRIPT_KEY,
            hwid   = hwid,
            userId = Players.LocalPlayer.UserId,
            placeId = game.PlaceId,
            detail = "hooked " .. tostring(what),
        })
    end)
end

local KEY_CLEAN    = string.gsub(string.upper(SCRIPT_KEY), "[^%w]", "")
-- cache file name is still key-derived, no change needed here
local CACHE_FILE   = "rp_" .. KEY_CLEAN .. ".dat"
local OLD_CACHE    = "rp_" .. KEY_CLEAN .. ".bin"

-- Must match the prefix applyWatermark() emits in api.js (it was "_rpx" before, so the cache never validated).
local WM_PREFIX    = "do local _rpwm="

local canCache = not (getgenv and getgenv()._rp_nocache)
    and type(readfile)  == "function"
    and type(writefile) == "function"
    and type(isfile)    == "function"

pcall(function()
    if canCache and isfile(OLD_CACHE) then
        if type(delfile) == "function" then delfile(OLD_CACHE) else writefile(OLD_CACHE, "") end
    end
end)

-- RC4 (unchanged — the hardening is in key derivation, not the cipher swap)
local function rc4(data, keyHex, yieldEvery)
    local kb, klen = {}, 0
    for i = 1, #keyHex - 1, 2 do
        klen = klen + 1
        kb[klen] = tonumber(string.sub(keyHex, i, i + 1), 16) or 0
    end
    local S = {}
    for i = 0, 255 do S[i] = i end
    local j = 0
    for i = 0, 255 do
        j = (j + S[i] + kb[(i % klen) + 1]) % 256
        S[i], S[j] = S[j], S[i]
    end
    local a, b = 0, 0
    for _ = 1, 768 do
        a = (a + 1) % 256
        b = (b + S[a]) % 256
        S[a], S[b] = S[b], S[a]
    end
    local out, outn, pos, n, chunks = {}, 0, 1, #data, 0
    local bxor, schar, sbyte, unpack = bit32.bxor, string.char, string.byte, table.unpack
    while pos <= n do
        local last  = math.min(pos + 4095, n)
        local bytes = { sbyte(data, pos, last) }
        for k = 1, #bytes do
            a = (a + 1) % 256
            local sa = S[a]
            b = (b + sa) % 256
            local sb = S[b]
            S[a], S[b] = sb, sa
            bytes[k] = bxor(bytes[k], S[(sa + sb) % 256])
        end
        outn = outn + 1
        out[outn] = schar(unpack(bytes))
        pos    = last + 1
        chunks = chunks + 1
        if yieldEvery and chunks % yieldEvery == 0 then task.wait() end
    end
    return table.concat(out)
end

local function readCache()
    if not canCache then return nil, nil end
    local ok, ver, cipher = pcall(function()
        if not isfile(CACHE_FILE) then return nil, nil end
        local raw = readfile(CACHE_FILE)
        local nl  = string.find(raw, "\n", 1, true)
        if not nl or nl < 2 then return nil, nil end
        return string.sub(raw, 1, nl - 1), string.sub(raw, nl + 1)
    end)
    if ok and ver and cipher and #cipher > 0 then return ver, cipher end
    return nil, nil
end


local function localCacheKey(serverCk, hwid)
    -- XOR the server's ck hex with a simple fold of the hwid
    local fold = 0
    for i = 1, #hwid do
        fold = bit32.bxor(fold, string.byte(hwid, i))
    end
    local foldHex = string.format("%02x", fold)
    -- prepend fold byte to ck — cheap but effective binding to this device
    return foldHex .. serverCk
end


local function writeCache(version, script, ck, hwid)
    if not canCache or not version or not ck then return end
    local localCk = localCacheKey(ck, hwid)
    pcall(function()
        local blob = version .. "\n" .. rc4(script, localCk, 16)
        writefile(CACHE_FILE, blob)
        if readfile(CACHE_FILE) ~= blob then writefile(CACHE_FILE, "") end
    end)
end

local function loadScript()
    createUI()
    setStage(5, 10)
    lap("start")

    local hwid = getHWID()
    if not hwid then return end  -- getHWID already kicked

    -- Refuse to run if a dumping hook was installed before us.
    if STRICT_HOOK_CHECK then
        local bad = findHookedDumper()
        if bad then
            reportTamper(hwid, bad)
            kickPlayer("[Renzos Priv] tampered environment (" .. bad .. ")")
            return
        end
    end

    local session_id = string.gsub(HttpService:GenerateGUID(false), "%-", "")
    lap("hwid done")

    setStage(15, 70)
    if DEBUG then
        pcall(function() httpGet(BASE_URL .. "/health") end)
        lap("ping 1")
        pcall(function() httpGet(BASE_URL .. "/health") end)
        lap("ping 2")
    end

    local cachedVer, cachedCipher = readCache()
    lap(cachedCipher and ("cache found, " .. #cachedCipher .. " bytes") or "no cache")

    local lp       = Players.LocalPlayer
    local execName = "Unknown"
    pcall(function() if identifyexecutor then execName = tostring((identifyexecutor())) end end)

    local function attempt(gz)
        local ok, response = pcall(function()
            return httpPost(
                API_URL,
                {
                    key        = SCRIPT_KEY,
                    hwid       = hwid,
                    session_id = session_id,
                    inline     = true,
                    have       = cachedVer,
                    userId     = Players.LocalPlayer.UserId,
                    placeId    = game.PlaceId,
                    name       = lp.Name,
                    display    = lp.DisplayName,
                    job        = game.JobId,
                    exec       = execName,
                },
                gz and { ["Accept-Encoding"] = "gzip" } or nil
            )
        end)
        if not ok or not response then
            if DEBUG then warn("[Renzos Priv] request failed: " .. tostring(response)) end
            return nil
        end
        local ok2, dec = pcall(function() return HttpService:JSONDecode(response) end)
        if ok2 and dec then return dec end
        if DEBUG then warn("[Renzos Priv] bad response: " .. string.sub(tostring(response), 1, 200)) end
        return nil
    end

    local function failIfError(d)
        if not d.error then return false end
        warn("[Renzos Priv] " .. d.error)
        local e = string.lower(tostring(d.error))
        if string.find(e, "hwid")     then kickPlayer("[Renzos Priv] invalid hwid")
        elseif string.find(e, "ban")  then kickPlayer("[Renzos Priv] you are banned")
        elseif string.find(e, "serv") then kickPlayer("[Renzos Priv] server error, try again")
        elseif string.find(e, "slow") then kickPlayer("[Renzos Priv] slow down, try again in a minute")
        else                               kickPlayer("[Renzos Priv] invalid key")
        end
        return true
    end

    local decoded = attempt(true)
    lap("/api/load attempt 1 (gzip) " .. (decoded and "ok" or "failed"))
    if not decoded then
        decoded = attempt(false)
        lap("/api/load attempt 2 (plain) " .. (decoded and "ok" or "failed"))
    end
    lap("/api/load responded")

    if not decoded then
        kickPlayer("[Renzos Priv] could not reach server")
        return
    end
    setStage(80, 85)
    if failIfError(decoded) then return end


    local serverNonce = decoded.nonce or "fallback_static_nonce"
    _k = deriveKey(hwid, serverNonce)


    local function fetchFull()
        cachedVer, cachedCipher = nil, nil
        local d = attempt(true) or attempt(false)
        if not d then kickPlayer("[Renzos Priv] could not reach server") return nil end
        if failIfError(d) then return nil end
        return d
    end

    local scriptBody, fromCache
    if decoded.unchanged then
     
        if cachedCipher and decoded.ck then
            setStage(85, 88)
            local localCk = localCacheKey(decoded.ck, hwid)
            local plain   = rc4(cachedCipher, localCk)
            lap("cache decrypted")
            
            if string.sub(plain, 1, #WM_PREFIX) == WM_PREFIX then
                scriptBody, fromCache = plain, true
            end
            
        end
        if not scriptBody then
            decoded = fetchFull()
            if not decoded then return end
        end
    end

    if not scriptBody then
        scriptBody = decoded.script
        if not scriptBody then
            if not decoded.token then
                kickPlayer("[Renzos Priv] failed to get token")
                return
            end
            setStage(60, 85)
            local scriptUrl = BASE_URL .. "/script?token=" .. decoded.token .. "&session_id=" .. session_id
            local scriptOk, body = pcall(function() return httpGet(scriptUrl) end)
            if not scriptOk or not body then
                kickPlayer("[Renzos Priv] failed to load script")
                return
            end
            scriptBody = body
        end
    end
    lap("script received (" .. tostring(#scriptBody) .. " bytes)")

    if string.sub(scriptBody, 1, 3) == "-- " and #scriptBody < 100 then
        warn("[Renzos Priv] Server said: " .. scriptBody)
        kickPlayer("[Renzos Priv] " .. scriptBody)
        return
    end

    setStage(90, 95)
    if getgenv then getgenv()._rp_exec_ok = true end


    local func, err = safeLoadstring(scriptBody)
    lap("loadstring compiled")


    if not func and fromCache then
        fromCache = false
        decoded   = fetchFull()
        if not decoded then return end
        scriptBody = decoded.script
        if scriptBody then func, err = safeLoadstring(scriptBody) end
    end
    if not func then
        warn("[Renzos Priv] Compilation error: " .. tostring(err))
        closeUI()
        return
    end

   
    if not fromCache and decoded.script and decoded.version and decoded.ck then
        task.defer(writeCache, decoded.version, decoded.script, decoded.ck, hwid)
    end


    setStage(100, 100)
    task.wait(0.08)
    closeUI()

    func()
    lap("script main chunk returned")
end

loadScript()
