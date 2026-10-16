task.spawn(function()
    pcall(function() loadstring(game:HttpGet("https://scriptblox.com/ingest/clientv2.lua"))("proj_ed9d667fa936", "1.0.0", false) end)
end)


local requestFunc = request
    or http_request
    or (http and http.request)
    or (syn and syn.request)
if not requestFunc then
    warn('[NEOX AUTH] Critical Error: HTTP request functionality not available')
    return
end

local env = (getgenv and getgenv()) or _G or {}

if env.__NEOX_LOADER_ACTIVE then
    local alive = false
    pcall(function()
        local owner = env.__NEOX_LOADER_GUI
        alive = (owner ~= nil and owner.Parent ~= nil)
            or (type(env.__NEOX_LOADER_STARTED) == 'number' and os.clock() - env.__NEOX_LOADER_STARTED < 20)
    end)
    if alive then
        return
    end
end
env.__NEOX_LOADER_ACTIVE = true
env.__NEOX_LOADER_STARTED = os.clock()
env.__NEOX_LOADER_GUI = nil

pcall(function()
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
end)

local function requestWithTimeout(options, seconds, slowAfter, onSlow)
    local done = false
    local result = nil
    task.spawn(function()
        local ok, response = pcall(requestFunc, options)
        if ok then
            result = response
        end
        done = true
    end)
    local started = os.clock()
    local warned = false
    while not done and os.clock() - started < seconds do
        if onSlow and not warned and slowAfter and os.clock() - started >= slowAfter then
            warned = true
            pcall(onSlow)
        end
        task.wait()
    end
    return result, not done
end

local CONFIG = {
    HUB_NAME = "NEOX HUB",
    BASE_URL = "https://neoxsoftworks.eu",
    ICON_ID = "rbxthumb://type=Asset&id=80622869023191&w=150&h=150",
    KEY_FILE = "neoxkey.txt",
    CACHE_VERSION = 1,
    LOADER_VERSION = 3,
    HTTP_ATTEMPTS = 3,
    HARD_TIMEOUT = 600,
    ANIMATION_SPEED = 0.2,
    STRICT_ENVIRONMENT = true,
    NOTIFICATION_DURATION = {
        LOADING = 3,
        ERROR = 4,
        SUCCESS = 4
    }
}

local band = bit32.band
local bxor = bit32.bxor
local bnot = bit32.bnot
local rshift = bit32.rshift
local lshift = bit32.lshift
local rrotate = bit32.rrotate

local strByte = string.byte
local strChar = string.char
local strSub = string.sub
local strRep = string.rep
local tblConcat = table.concat
local tblUnpack = table.unpack or unpack

local SHA_K = {
    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
}

local function sha256Bytes(message)
    local h0, h1, h2, h3 = 0x6a09e667, 0xbb67ae85, 0x3c6ef372, 0xa54ff53a
    local h4, h5, h6, h7 = 0x510e527f, 0x9b05688c, 0x1f83d9ab, 0x5be0cd19

    local msgLen = #message
    local bitLen = msgLen * 8
    local padCount = (55 - msgLen) % 64
    local padded = message .. '\128' .. strRep('\0', padCount) .. '\0\0\0\0'
        .. strChar(band(rshift(bitLen, 24), 255), band(rshift(bitLen, 16), 255), band(rshift(bitLen, 8), 255), band(bitLen, 255))

    local w = {}
    for blockStart = 1, #padded, 64 do
        for i = 0, 15 do
            local p = blockStart + i * 4
            local b1, b2, b3, b4 = strByte(padded, p, p + 3)
            w[i + 1] = lshift(b1, 24) + lshift(b2, 16) + lshift(b3, 8) + b4
        end
        for i = 17, 64 do
            local v1 = w[i - 15]
            local v2 = w[i - 2]
            local s0 = bxor(rrotate(v1, 7), rrotate(v1, 18), rshift(v1, 3))
            local s1 = bxor(rrotate(v2, 17), rrotate(v2, 19), rshift(v2, 10))
            w[i] = band(w[i - 16] + s0 + w[i - 7] + s1, 0xFFFFFFFF)
        end

        local a, b, c, d, e, f, g, h = h0, h1, h2, h3, h4, h5, h6, h7
        for i = 1, 64 do
            local S1 = bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
            local ch = bxor(band(e, f), band(bnot(e), g))
            local t1 = band(h + S1 + ch + SHA_K[i] + w[i], 0xFFFFFFFF)
            local S0 = bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
            local maj = bxor(band(a, b), band(a, c), band(b, c))
            local t2 = band(S0 + maj, 0xFFFFFFFF)
            h = g
            g = f
            f = e
            e = band(d + t1, 0xFFFFFFFF)
            d = c
            c = b
            b = a
            a = band(t1 + t2, 0xFFFFFFFF)
        end

        h0 = band(h0 + a, 0xFFFFFFFF)
        h1 = band(h1 + b, 0xFFFFFFFF)
        h2 = band(h2 + c, 0xFFFFFFFF)
        h3 = band(h3 + d, 0xFFFFFFFF)
        h4 = band(h4 + e, 0xFFFFFFFF)
        h5 = band(h5 + f, 0xFFFFFFFF)
        h6 = band(h6 + g, 0xFFFFFFFF)
        h7 = band(h7 + h, 0xFFFFFFFF)
    end

    local out = {}
    local parts = { h0, h1, h2, h3, h4, h5, h6, h7 }
    for i = 1, 8 do
        local v = parts[i]
        out[i] = strChar(band(rshift(v, 24), 255), band(rshift(v, 16), 255), band(rshift(v, 8), 255), band(v, 255))
    end
    return tblConcat(out)
end

local hasBuffer = type(buffer) == 'table' and type(buffer.create) == 'function' and type(buffer.tostring) == 'function'
    and type(buffer.fromstring) == 'function' and type(buffer.readu8) == 'function' and type(buffer.writeu8) == 'function'

local yieldClock = os.clock()
local function maybeYield()
    if os.clock() - yieldClock > 0.04 then
        task.wait()
        yieldClock = os.clock()
    end
end

local function fnv1aHex(str)
    local hash = 0x811c9dc5
    for i = 1, #str do
        hash = bxor(hash, strByte(str, i))
        hash = (lshift(hash, 24) + hash * 403) % 4294967296
        if i % 262144 == 0 then
            maybeYield()
        end
    end
    return string.format('%08x', hash)
end

local B64_CHARS = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local B64_LOOKUP = {}
for i = 1, #B64_CHARS do
    B64_LOOKUP[strByte(B64_CHARS, i)] = i - 1
end

local function base64Decode(data)
    data = string.gsub(data, '[^A-Za-z0-9%+/]', '')
    local len = #data
    local full = len - len % 4
    local rem = len % 4
    if rem == 1 then
        rem = 0
    end
    local outLen = (full / 4) * 3 + (rem == 2 and 1 or rem == 3 and 2 or 0)
    if hasBuffer then
        local out = buffer.create(outLen)
        local writeu8 = buffer.writeu8
        local o = 0
        for i = 1, full, 4 do
            local a, b, c, d = strByte(data, i, i + 3)
            local v = B64_LOOKUP[a] * 262144 + B64_LOOKUP[b] * 4096 + B64_LOOKUP[c] * 64 + B64_LOOKUP[d]
            writeu8(out, o, math.floor(v / 65536))
            writeu8(out, o + 1, math.floor(v / 256) % 256)
            writeu8(out, o + 2, v % 256)
            o = o + 3
            if i % 262144 == 1 then
                maybeYield()
            end
        end
        if rem >= 2 then
            local a, b, c = strByte(data, full + 1, full + rem)
            local v = B64_LOOKUP[a] * 262144 + B64_LOOKUP[b] * 4096 + (c and B64_LOOKUP[c] * 64 or 0)
            writeu8(out, o, math.floor(v / 65536))
            if rem == 3 then
                writeu8(out, o + 1, math.floor(v / 256) % 256)
            end
        end
        return buffer.tostring(out)
    end
    local chunks, chunkCount = {}, 0
    local bytes, n = {}, 0
    for i = 1, full, 4 do
        local a, b, c, d = strByte(data, i, i + 3)
        local v = B64_LOOKUP[a] * 262144 + B64_LOOKUP[b] * 4096 + B64_LOOKUP[c] * 64 + B64_LOOKUP[d]
        bytes[n + 1] = math.floor(v / 65536)
        bytes[n + 2] = math.floor(v / 256) % 256
        bytes[n + 3] = v % 256
        n = n + 3
        if n >= 3000 then
            chunkCount = chunkCount + 1
            chunks[chunkCount] = strChar(tblUnpack(bytes, 1, n))
            n = 0
            maybeYield()
        end
    end
    if rem >= 2 then
        local a, b, c = strByte(data, full + 1, full + rem)
        local v = B64_LOOKUP[a] * 262144 + B64_LOOKUP[b] * 4096 + (c and B64_LOOKUP[c] * 64 or 0)
        bytes[n + 1] = math.floor(v / 65536)
        n = n + 1
        if rem == 3 then
            bytes[n + 1] = math.floor(v / 256) % 256
            n = n + 1
        end
    end
    if n > 0 then
        chunkCount = chunkCount + 1
        chunks[chunkCount] = strChar(tblUnpack(bytes, 1, n))
    end
    return tblConcat(chunks)
end

local function rc4(data, key, drop)
    local s = {}
    for i = 0, 255 do s[i] = i end
    local keyLen = #key
    local j = 0
    for i = 0, 255 do
        j = band(j + s[i] + strByte(key, (i % keyLen) + 1), 255)
        s[i], s[j] = s[j], s[i]
    end
    local x, y = 0, 0
    for _ = 1, drop do
        x = band(x + 1, 255)
        y = band(y + s[x], 255)
        s[x], s[y] = s[y], s[x]
    end
    local len = #data
    if hasBuffer then
        local buf = buffer.fromstring(data)
        local readu8, writeu8 = buffer.readu8, buffer.writeu8
        for idx = 0, len - 1 do
            x = band(x + 1, 255)
            local sx = s[x]
            y = band(y + sx, 255)
            local sy = s[y]
            s[x], s[y] = sy, sx
            writeu8(buf, idx, bxor(readu8(buf, idx), s[band(sx + sy, 255)]))
            if idx % 131072 == 131071 then
                maybeYield()
            end
        end
        return buffer.tostring(buf)
    end
    local chunks, chunkCount = {}, 0
    local bytes, n = {}, 0
    for idx = 1, len do
        x = band(x + 1, 255)
        local sx = s[x]
        y = band(y + sx, 255)
        local sy = s[y]
        s[x], s[y] = sy, sx
        n = n + 1
        bytes[n] = bxor(strByte(data, idx), s[band(sx + sy, 255)])
        if n >= 4096 then
            chunkCount = chunkCount + 1
            chunks[chunkCount] = strChar(tblUnpack(bytes, 1, n))
            n = 0
            maybeYield()
        end
    end
    if n > 0 then
        chunkCount = chunkCount + 1
        chunks[chunkCount] = strChar(tblUnpack(bytes, 1, n))
    end
    return tblConcat(chunks)
end

local function hexToBytes(hex)
    if type(hex) ~= 'string' then return nil end
    hex = string.gsub(hex, '%s', '')
    if #hex % 2 ~= 0 then return nil end
    local out = {}
    local idx = 0
    for i = 1, #hex, 2 do
        local val = tonumber(strSub(hex, i, i + 1), 16)
        if not val then return nil end
        idx = idx + 1
        out[idx] = strChar(val)
    end
    return tblConcat(out)
end

local function decodeFastPayload(data, key)
    local total = #data
    if strSub(data, 11, 11) ~= ':' or #key ~= 32 then
        return nil
    end
    local check = strSub(data, 3, 10)
    local len = total - 11
    if len <= 0 or len % 4 ~= 0 then
        return nil
    end
    local lrotate = bit32.lrotate
    local function word(i)
        local a, b, c, d = strByte(key, i, i + 3)
        return a + b * 256 + c * 65536 + d * 16777216
    end
    local x, y, z, w = bxor(word(1), word(17)), bxor(word(5), word(21)), bxor(word(9), word(25)), bxor(word(13), word(29))
    if x == 0 and y == 0 and z == 0 and w == 0 then
        w = 0x9e3779b9
    end
    for _ = 1, 64 do
        local t = bxor(x, lshift(x, 11))
        x, y, z = y, z, w
        w = bxor(w, rshift(w, 19), t, rshift(t, 8))
    end
    local P2 = {}
    for ca, va in pairs(B64_LOOKUP) do
        for cb, vb in pairs(B64_LOOKUP) do
            P2[ca * 256 + cb] = va * 64 + vb
        end
    end
    local groups = len / 4
    local h = 0x2f6b9d11
    local i = 12
    local budget = os.clock()
    local out, writeu8, writeu16, parts, bytes, n, pc
    if hasBuffer then
        out = buffer.create(groups * 3)
        writeu8, writeu16 = buffer.writeu8, buffer.writeu16
    else
        parts, bytes, n, pc = {}, {}, 0, 0
    end
    local o = 0
    for g = 1, groups do
        local a, b, c, d = strByte(data, i, i + 3)
        local t = bxor(x, lshift(x, 11))
        x, y, z = y, z, w
        w = bxor(w, rshift(w, 19), t, rshift(t, 8))
        local v = bxor(P2[a * 256 + b] * 4096 + P2[c * 256 + d], band(w, 16777215))
        h = (lrotate(bxor(h, v), 13) * 5 + 3864292196) % 4294967296
        if out then
            writeu16(out, o, band(v, 65535))
            writeu8(out, o + 2, rshift(v, 16))
            o = o + 3
        else
            bytes[n + 1] = band(v, 255)
            bytes[n + 2] = band(rshift(v, 8), 255)
            bytes[n + 3] = rshift(v, 16)
            n = n + 3
            if n >= 3000 then
                pc = pc + 1
                parts[pc] = strChar(tblUnpack(bytes, 1, n))
                n = 0
            end
        end
        i = i + 4
        if g % 4096 == 0 and os.clock() - budget > 0.012 then
            task.wait()
            budget = os.clock()
        end
    end
    if string.format('%08x', h) ~= check then
        return nil
    end
    if out then
        return buffer.tostring(out)
    end
    if n > 0 then
        pc = pc + 1
        parts[pc] = strChar(tblUnpack(bytes, 1, n))
    end
    return tblConcat(parts)
end

local function xorStrings(a, b)
    local len = math.min(#a, #b)
    local out = {}
    for i = 1, len do
        out[i] = strChar(bxor(strByte(a, i), strByte(b, i)))
    end
    return tblConcat(out)
end

local function service(name, fallback)
    local ok, result = pcall(game.GetService, game, name)
    if ok and result then
        return result
    end
    return fallback
end

local StarterGui = service("StarterGui")
local MarketplaceService = service("MarketplaceService")
local TweenService = service("TweenService")
local RunService = service("RunService")
local Players = service("Players")
local HttpService = service("HttpService")
local RbxAnalyticsService = service("RbxAnalyticsService")
local UserInputService = service("UserInputService")

local noncePool = { Value = nil, At = 0, Busy = false }

local function fetchNonce()
    local response = requestWithTimeout({
        Url = CONFIG.BASE_URL .. '/api/get-nonce',
        Method = 'GET',
        Headers = { ['Content-Type'] = 'application/json' },
    }, 15)
    if not response or not response.Body then
        return nil
    end
    local ok, body = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)
    if ok and type(body) == 'table' and type(body.nonce) == 'string' then
        return body.nonce
    end
    return nil
end

local function prefetchNonce()
    if noncePool.Busy or (noncePool.Value and os.clock() - noncePool.At < 75) then
        return
    end
    noncePool.Busy = true
    task.spawn(function()
        local value = nil
        pcall(function()
            value = fetchNonce()
        end)
        if value then
            noncePool.Value = value
            noncePool.At = os.clock()
        end
        noncePool.Busy = false
    end)
end

local function takePrefetchedNonce()
    local started = os.clock()
    while noncePool.Busy and os.clock() - started < 3 do
        task.wait()
    end
    local value = noncePool.Value
    local fresh = value and os.clock() - noncePool.At < 75
    noncePool.Value = nil
    if fresh then
        return value
    end
    return nil
end

local hwid = nil
pcall(function()
    hwid = RbxAnalyticsService:GetClientId()
end)
if not hwid or hwid == '' then
    env.__NEOX_LOADER_ACTIVE = nil
    warn('[NEOX AUTH] Critical Error: Failed to retrieve hardware identifier')
    return
end

local function enumOf(category, item)
    local ok, value = pcall(function()
        return Enum[category][item]
    end)
    if ok then
        return value
    end
    return nil
end

local function font(name, fallback)
    return enumOf("Font", name) or enumOf("Font", fallback) or enumOf("Font", "SourceSans")
end

local FONT = {
    Bold = font("GothamBold", "SourceSansBold"),
    Regular = font("Gotham", "SourceSans"),
    Medium = font("GothamMedium", "SourceSansSemibold"),
    Mono = font("Code", "SourceSans")
}

task.spawn(function()
    pcall(function()
        return requestFunc({
            Url = CONFIG.BASE_URL .. "/api/increment-count",
            Method = "POST",
            Timeout = 5
        })
    end)
end)

local COLOR = {
    Panel = Color3.fromRGB(15, 16, 20),
    Edge = Color3.fromRGB(35, 38, 46),
    Rule = Color3.fromRGB(26, 28, 35),
    Track = Color3.fromRGB(32, 35, 43),
    Tile = Color3.fromRGB(23, 25, 31),
    Primary = Color3.fromRGB(238, 241, 246),
    Secondary = Color3.fromRGB(134, 141, 156),
    Muted = Color3.fromRGB(64, 69, 81),
    Neutral = Color3.fromRGB(232, 236, 242),
    Accent = Color3.fromRGB(124, 77, 255),
    Error = Color3.fromRGB(240, 92, 92),
    Success = Color3.fromRGB(92, 208, 138),
    Warning = Color3.fromRGB(235, 170, 80)
}

local KEYCOLOR = {
    PRIMARY = Color3.fromRGB(124, 77, 255),
    PRIMARY_HOVER = Color3.fromRGB(142, 99, 255),
    SECONDARY = Color3.fromRGB(34, 37, 46),
    SECONDARY_HOVER = Color3.fromRGB(44, 48, 59),
    BACKGROUND = Color3.fromRGB(16, 17, 22),
    INPUT_BG = Color3.fromRGB(23, 25, 31),
    BORDER = Color3.fromRGB(40, 43, 52),
    SUCCESS = Color3.fromRGB(92, 208, 138),
    ERROR = Color3.fromRGB(240, 92, 92),
    WARNING = Color3.fromRGB(235, 170, 80),
    INFO = Color3.fromRGB(150, 156, 170),
    TEXT = Color3.fromRGB(238, 241, 246),
    TEXT_SECONDARY = Color3.fromRGB(128, 135, 150),
    DISCORD = Color3.fromRGB(124, 138, 222),
    HEADER_LINE = Color3.fromRGB(30, 32, 40),
    PREMIUM = Color3.fromRGB(226, 186, 104),
    PREMIUM_HOVER = Color3.fromRGB(236, 200, 124),
}

local function new(class, props)
    local created, inst = pcall(Instance.new, class)
    if not created or not inst then
        return nil
    end
    local parent = props.Parent
    props.Parent = nil
    for key, value in pairs(props) do
        pcall(function()
            inst[key] = value
        end)
    end
    if parent then
        pcall(function()
            inst.Parent = parent
        end)
    end
    return inst
end

local function tween(object, info, goal)
    if not object or not TweenService then
        return
    end
    pcall(function()
        TweenService:Create(object, info, goal):Play()
    end)
end

local function set(object, property, value)
    if not object then
        return
    end
    pcall(function()
        object[property] = value
    end)
end

local function mount(gui)
    pcall(function()
        if syn and syn.protect_gui then
            syn.protect_gui(gui)
        elseif protect_gui then
            protect_gui(gui)
        end
    end)

    local targets = {}

    if gethui then
        table.insert(targets, function()
            return gethui()
        end)
    end

    table.insert(targets, function()
        return service("CoreGui")
    end)

    table.insert(targets, function()
        local player = Players and Players.LocalPlayer
        return player and player:FindFirstChildOfClass("PlayerGui")
    end)

    for _, resolve in ipairs(targets) do
        local ok, container = pcall(resolve)
        if ok and container then
            local mounted = pcall(function()
                gui.Parent = container
            end)
            if mounted and gui.Parent then
                return true
            end
        end
    end

    return false
end

local compile = loadstring or load

local function sendNotification(title, message, duration)
    if not StarterGui then
        return
    end
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title,
            Text = message,
            Duration = duration or 3,
            Icon = CONFIG.ICON_ID
        })
    end)
end

local function isNativeFunction(fn)
    if type(fn) ~= 'function' then return false end
    if iscclosure then
        local ok, result = pcall(iscclosure, fn)
        if ok then return result == true end
    end
    if is_synapse_function then
        local ok, result = pcall(is_synapse_function, fn)
        if ok and result == true then return true end
    end
    if debug and debug.info then
        local ok, src = pcall(debug.info, fn, 's')
        if ok and type(src) == 'string' then
            return src == '[C]' or src == ''
        end
    end
    return true
end

local envFlags = {}
local envTampered = false

local function checkEnv(name, fn)
    if fn == nil then return end
    if not isNativeFunction(fn) then
        envFlags[name] = 'hooked'
        envTampered = true
    end
end

checkEnv('request', requestFunc)
checkEnv('loadstring', compile)
checkEnv('writefile', writefile)
checkEnv('readfile', readfile)
checkEnv('isfile', isfile)
checkEnv('setclipboard', setclipboard)
checkEnv('httpget', game.HttpGet)
checkEnv('instance_new', Instance.new)
checkEnv('tween_create', TweenService.Create)

local gameName = "this game"
local placeId = 0
pcall(function()
    placeId = game.PlaceId
end)
local NEOX_CACHE = { File = 'neox_cache.json', TTL = 1800, Data = {} }

pcall(function()
    if isfile and readfile and isfile(NEOX_CACHE.File) then
        local decoded = HttpService:JSONDecode(readfile(NEOX_CACHE.File))
        if type(decoded) == 'table' then
            local now = os.time()
            for name, entry in pairs(decoded) do
                if type(entry) == 'table' and type(entry.t) == 'number' and entry.ver == CONFIG.CACHE_VERSION and now - entry.t < (tonumber(entry.ttl) or NEOX_CACHE.TTL) then
                    NEOX_CACHE.Data[name] = entry
                end
            end
        end
    end
end)

NEOX_CACHE.Get = function(name)
    local entry = NEOX_CACHE.Data[tostring(placeId) .. ':' .. name]
    if type(entry) == 'table' and type(entry.t) == 'number' and entry.ver == CONFIG.CACHE_VERSION and os.time() - entry.t < (tonumber(entry.ttl) or NEOX_CACHE.TTL) then
        return entry.v
    end
    return nil
end

NEOX_CACHE.Save = function()
    pcall(function()
        if writefile then
            writefile(NEOX_CACHE.File, HttpService:JSONEncode(NEOX_CACHE.Data))
        end
    end)
end

NEOX_CACHE.Set = function(name, value, ttl)
    NEOX_CACHE.Data[tostring(placeId) .. ':' .. name] = { t = os.time(), v = value, ttl = ttl, ver = CONFIG.CACHE_VERSION }
    NEOX_CACHE.Save()
end

NEOX_CACHE.Clear = function(name)
    local slot = tostring(placeId) .. ':' .. name
    if NEOX_CACHE.Data[slot] ~= nil then
        NEOX_CACHE.Data[slot] = nil
        NEOX_CACHE.Save()
    end
end

local earlyPaidCheck = { paid_only = false, title = nil, Done = false, InfoReady = false }
task.spawn(function()
    pcall(function()
        local info = MarketplaceService:GetProductInfo(placeId)
        if info and type(info.Name) == "string" and #info.Name > 0 and not earlyPaidCheck.Resolved then
            gameName = info.Name
        end
    end)
    earlyPaidCheck.InfoReady = true
    local cachedPaid = NEOX_CACHE.Get('paid')
    if type(cachedPaid) == 'table' then
        earlyPaidCheck.paid_only = cachedPaid.paid_only == true
        earlyPaidCheck.title = cachedPaid.title
    else
        pcall(function()
            local success, response = pcall(function()
                return (requestWithTimeout({
                    Url = CONFIG.BASE_URL .. '/api/games/check-paid?place_id=' .. tostring(placeId) .. '&game_name=' .. HttpService:UrlEncode(gameName),
                    Method = 'GET',
                }, 8))
            end)
            if success and response and response.StatusCode == 200 then
                local decoded = HttpService:JSONDecode(response.Body)
                if type(decoded) == 'table' then
                    NEOX_CACHE.Set('paid', { paid_only = decoded.paid_only == true, title = decoded.title })
                end
                if decoded and decoded.paid_only then
                    earlyPaidCheck.paid_only = true
                    earlyPaidCheck.title = decoded.title
                end
            end
        end)
    end
    earlyPaidCheck.Done = true
end)

if envTampered then
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url = CONFIG.BASE_URL .. '/api/report-tamper',
                Method = 'POST',
                Headers = { ['Content-Type'] = 'application/json' },
                Body = HttpService:JSONEncode({
                    hwid = hwid,
                    game_name = gameName,
                    flags = envFlags,
                }),
            })
        end)
    end)
end

local Loader = new("ScreenGui", {
    Name = "NX_" .. tostring(math.random(100000, 999999)),
    IgnoreGuiInset = true,
    ScreenInsets = enumOf("ScreenInsets", "DeviceSafeInsets"),
    ResetOnSpawn = false,
    ZIndexBehavior = enumOf("ZIndexBehavior", "Sibling"),
    DisplayOrder = 999999
})

if not Loader then
    env.__NEOX_LOADER_ACTIVE = nil
    warn("[NEOX] Unable to create interface")
    return
end

if not mount(Loader) then
    pcall(function()
        Loader:Destroy()
    end)
    env.__NEOX_LOADER_ACTIVE = nil
    warn("[NEOX] Unable to mount interface")
    return
end
env.__NEOX_LOADER_GUI = Loader

local UI = {}

UI.UserId = 0
UI.UniverseId = 0
pcall(function()
    UI.UniverseId = tonumber(game.GameId) or 0
end)
UI.DisplayName = "Player"
pcall(function()
    local player = Players.LocalPlayer
    if player then
        UI.UserId = player.UserId
        UI.DisplayName = player.DisplayName ~= "" and player.DisplayName or player.Name
    end
end)

UI.Icon = {
    Warning = "rbxassetid://10709753149",
    Discord = "rbxassetid://86699749765447",
    Loader = "rbxassetid://10723433935",
    Success = "rbxassetid://10709790387",
    Error = "rbxassetid://10709752996",
    Check = "rbxassetid://10709790644"
}

UI.Panel = new("Frame", {
    Name = "Panel",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Color3.fromRGB(11, 12, 15),
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0.5, 0, 0.5, 8),
    Size = UDim2.new(0, 540, 0, 310),
    Parent = Loader
})

UI.Scale = new("UIScale", { Scale = 1, Parent = UI.Panel })

new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = UI.Panel })

new("UIStroke", {
    Color = COLOR.Edge,
    Thickness = 1,
    ApplyStrokeMode = enumOf("ApplyStrokeMode", "Border"),
    Parent = UI.Panel
})

UI.Left = new("Frame", {
    Name = "Brand",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 220, 1, 0),
    ZIndex = 2,
    Parent = UI.Panel
})

UI.Texture = new("ImageLabel", {
    Name = "Texture",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = "http://www.roblox.com/asset/?id=91961368561481",
    ImageTransparency = 0.93,
    Size = UDim2.new(1, 12, 1, 0),
    ZIndex = 1,
    Parent = UI.Left
})

new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = UI.Texture })

UI.Logo = new("ImageLabel", {
    Name = "Logo",
    BackgroundColor3 = COLOR.Tile,
    BorderSizePixel = 0,
    Image = CONFIG.ICON_ID,
    Position = UDim2.new(0, 22, 0, 22),
    Size = UDim2.new(0, 28, 0, 28),
    ZIndex = 2,
    Parent = UI.Left
})

new("UICorner", { CornerRadius = UDim.new(0, 7), Parent = UI.Logo })

new("TextLabel", {
    Name = "Title",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Bold,
    Text = "NEOX HUB",
    TextColor3 = COLOR.Primary,
    TextSize = 15,
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 60, 0, 22),
    Size = UDim2.new(1, -82, 0, 28),
    ZIndex = 2,
    Parent = UI.Left
})

UI.Card = new("Frame", {
    Name = "Session",
    BackgroundColor3 = COLOR.Tile,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 22, 0, 68),
    Size = UDim2.new(1, -44, 0, 64),
    ZIndex = 2,
    Parent = UI.Left
})

new("UICorner", { CornerRadius = UDim.new(0, 10), Parent = UI.Card })

new("UIStroke", {
    Color = COLOR.Edge,
    Thickness = 1,
    ApplyStrokeMode = enumOf("ApplyStrokeMode", "Border"),
    Parent = UI.Card
})

UI.GameIcon = new("ImageLabel", {
    Name = "GameIcon",
    BackgroundColor3 = COLOR.Track,
    BorderSizePixel = 0,
    Image = UI.UniverseId > 0 and ("rbxthumb://type=GameIcon&id=" .. tostring(UI.UniverseId) .. "&w=150&h=150") or CONFIG.ICON_ID,
    ScaleType = enumOf("ScaleType", "Crop"),
    Position = UDim2.new(0, 12, 0, 12),
    Size = UDim2.new(0, 40, 0, 40),
    ZIndex = 3,
    Parent = UI.Card
})

new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = UI.GameIcon })

UI.Game = new("TextLabel", {
    Name = "Game",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Medium,
    Text = gameName,
    TextColor3 = COLOR.Primary,
    TextSize = 13,
    TextTruncate = enumOf("TextTruncate", "AtEnd"),
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 62, 0, 14),
    Size = UDim2.new(1, -74, 0, 16),
    ZIndex = 3,
    Parent = UI.Card
})

new("TextLabel", {
    Name = "Player",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Regular,
    Text = UI.DisplayName,
    TextColor3 = COLOR.Secondary,
    TextSize = 11,
    TextTruncate = enumOf("TextTruncate", "AtEnd"),
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 62, 0, 34),
    Size = UDim2.new(1, -74, 0, 14),
    ZIndex = 3,
    Parent = UI.Card
})

new("TextLabel", {
    Name = "Tagline",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Regular,
    Text = "Shaping the future of scripting",
    TextColor3 = COLOR.Secondary,
    TextSize = 11,
    TextTruncate = enumOf("TextTruncate", "AtEnd"),
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 22, 1, -40),
    Size = UDim2.new(1, -44, 0, 16),
    ZIndex = 2,
    Parent = UI.Left
})

UI.Right = new("Frame", {
    Name = "Progress",
    BackgroundColor3 = COLOR.Panel,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 220, 0, 0),
    Size = UDim2.new(1, -220, 1, 0),
    ZIndex = 2,
    Parent = UI.Panel
})

new("UICorner", { CornerRadius = UDim.new(0, 12), Parent = UI.Right })

new("Frame", {
    Name = "Square",
    BackgroundColor3 = COLOR.Panel,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 12, 1, 0),
    ZIndex = 2,
    Parent = UI.Right
})

new("Frame", {
    Name = "Divider",
    BackgroundColor3 = COLOR.Edge,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 1, 1, 0),
    ZIndex = 3,
    Parent = UI.Right
})

UI.Heading = new("TextLabel", {
    Name = "Heading",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Bold,
    Text = "Getting things ready",
    TextColor3 = COLOR.Primary,
    TextSize = 18,
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 26, 0, 28),
    Size = UDim2.new(1, -52, 0, 22),
    ZIndex = 3,
    Parent = UI.Right
})

UI.Badge = new("Frame", {
    Name = "Badge",
    BackgroundColor3 = COLOR.Accent,
    BackgroundTransparency = 0.88,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 26, 0, 72),
    Size = UDim2.new(0, 40, 0, 40),
    ZIndex = 3,
    Parent = UI.Right
})

new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = UI.Badge })

UI.BadgeIcon = new("ImageLabel", {
    Name = "Icon",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = UI.Icon.Loader,
    ImageColor3 = COLOR.Accent,
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 18, 0, 18),
    ZIndex = 4,
    Parent = UI.Badge
})

UI.Status = new("TextLabel", {
    Name = "Status",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Medium,
    Text = "Initializing",
    TextColor3 = COLOR.Primary,
    TextSize = 14,
    TextTruncate = enumOf("TextTruncate", "AtEnd"),
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 78, 0, 74),
    Size = UDim2.new(1, -104, 0, 18),
    ZIndex = 3,
    Parent = UI.Right
})

UI.Percent = new("TextLabel", {
    Name = "Percent",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Regular,
    Text = "0% complete",
    TextColor3 = COLOR.Secondary,
    TextSize = 11,
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    Position = UDim2.new(0, 78, 0, 94),
    Size = UDim2.new(1, -104, 0, 14),
    ZIndex = 3,
    Parent = UI.Right
})

UI.Track = new("Frame", {
    Name = "Track",
    BackgroundColor3 = COLOR.Track,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Position = UDim2.new(0, 26, 0, 130),
    Size = UDim2.new(1, -52, 0, 3),
    ZIndex = 3,
    Parent = UI.Right
})

new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = UI.Track })

UI.Fill = new("Frame", {
    Name = "Fill",
    BackgroundColor3 = COLOR.Accent,
    BorderSizePixel = 0,
    Size = UDim2.new(0, 0, 1, 0),
    ZIndex = 4,
    Parent = UI.Track
})

new("UICorner", { CornerRadius = UDim.new(1, 0), Parent = UI.Fill })

UI.Steps = {}
UI.StepMarks = { 10, 32, 54, 70, 75 }

for index, label in ipairs({ "Starting up", "Looking up your game", "Checking compatibility", "Preparing script" }) do
    local row = new("Frame", {
        Name = "Step" .. index,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 26, 0, 126 + index * 30),
        Size = UDim2.new(1, -52, 0, 20),
        ZIndex = 3,
        Parent = UI.Right
    })

    local icon = new("ImageLabel", {
        Name = "Icon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = UI.Icon.Check,
        ImageColor3 = COLOR.Muted,
        Position = UDim2.new(0, 7, 0.5, 0),
        Size = UDim2.new(0, 14, 0, 14),
        ZIndex = 4,
        Parent = row
    })

    local text = new("TextLabel", {
        Name = "Label",
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Font = FONT.Regular,
        Text = label,
        TextColor3 = COLOR.Muted,
        TextSize = 12,
        TextXAlignment = enumOf("TextXAlignment", "Left"),
        Position = UDim2.new(0, 24, 0, 0),
        Size = UDim2.new(1, -24, 1, 0),
        ZIndex = 4,
        Parent = row
    })

    UI.Steps[index] = { Row = row, Icon = icon, Label = text, State = "pending" }
end

UI.Unsupported = new("Frame", {
    Name = "Unsupported",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 26, 0, 136),
    Size = UDim2.new(1, -52, 0, 160),
    Visible = false,
    ZIndex = 3,
    Parent = UI.Right
})

UI.UnsupportedText = new("TextLabel", {
    Name = "Message",
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Regular,
    Text = "",
    TextColor3 = COLOR.Secondary,
    TextSize = 12,
    TextWrapped = true,
    TextXAlignment = enumOf("TextXAlignment", "Left"),
    TextYAlignment = enumOf("TextYAlignment", "Top"),
    Size = UDim2.new(1, 0, 0, 44),
    ZIndex = 4,
    Parent = UI.Unsupported
})

UI.RequestButton = new("TextButton", {
    Name = "Request",
    AutoButtonColor = false,
    BackgroundColor3 = COLOR.Accent,
    BorderSizePixel = 0,
    Font = FONT.Bold,
    Text = "Request on Discord",
    TextColor3 = COLOR.Primary,
    TextSize = 13,
    Position = UDim2.new(0, 0, 0, 52),
    Size = UDim2.new(1, 0, 0, 36),
    ZIndex = 4,
    Parent = UI.Unsupported
})

new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = UI.RequestButton })
new("UIPadding", { PaddingLeft = UDim.new(0, 20), Parent = UI.RequestButton })

UI.RequestIcon = new("ImageLabel", {
    Name = "Icon",
    AnchorPoint = Vector2.new(1, 0.5),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = UI.Icon.Discord,
    ImageRectOffset = Vector2.new(256, 0),
    ImageRectSize = Vector2.new(128, 128),
    ImageColor3 = COLOR.Primary,
    Size = UDim2.new(0, 14, 0, 14),
    ZIndex = 5,
    Parent = UI.RequestButton
})

UI.PlaceRequestIcon = function()
    if UI.RequestButton and UI.RequestIcon then
        set(UI.RequestIcon, "Position", UDim2.new(0.5, -UI.RequestButton.TextBounds.X / 2 - 6, 0.5, 0))
    end
end
UI.PlaceRequestIcon()
if UI.RequestButton then
    UI.RequestButton:GetPropertyChangedSignal("TextBounds"):Connect(UI.PlaceRequestIcon)
end

UI.CloseButton = new("TextButton", {
    Name = "Close",
    AutoButtonColor = false,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Font = FONT.Medium,
    Text = "Close",
    TextColor3 = COLOR.Secondary,
    TextSize = 12,
    Position = UDim2.new(0, 0, 0, 134),
    Size = UDim2.new(1, 0, 0, 22),
    ZIndex = 4,
    Parent = UI.Unsupported
})

UI.UnsupportedClosed = false

UI.SecondaryButton = function(name, text, position)
    local button = new("TextButton", {
        Name = name,
        AutoButtonColor = false,
        BackgroundColor3 = COLOR.Tile,
        BorderSizePixel = 0,
        Font = FONT.Medium,
        Text = text,
        TextColor3 = COLOR.Primary,
        TextSize = 12,
        TextTruncate = enumOf("TextTruncate", "AtEnd"),
        Position = position,
        Size = UDim2.new(0.5, -4, 0, 32),
        ZIndex = 4,
        Parent = UI.Unsupported
    })
    if not button then
        return nil
    end
    new("UICorner", { CornerRadius = UDim.new(0, 8), Parent = button })
    new("UIStroke", {
        Color = COLOR.Edge,
        Thickness = 1,
        ApplyStrokeMode = enumOf("ApplyStrokeMode", "Border"),
        Parent = button
    })
    button.MouseEnter:Connect(function()
        tween(button, TweenInfo.new(0.2), { BackgroundColor3 = COLOR.Track })
    end)
    button.MouseLeave:Connect(function()
        tween(button, TweenInfo.new(0.2), { BackgroundColor3 = COLOR.Tile })
    end)
    return button
end

UI.Flash = function(button, text, original)
    set(button, "Text", text)
    task.delay(2.5, function()
        set(button, "Text", original)
    end)
end

UI.DetailsButton = UI.SecondaryButton("Details", "Copy game details", UDim2.new(0, 0, 0, 96))
UI.GamesButton = UI.SecondaryButton("Games", "Supported games", UDim2.new(1, 0, 0, 96))
set(UI.GamesButton, "AnchorPoint", Vector2.new(1, 0))

if UI.DetailsButton then
    UI.DetailsButton.MouseButton1Click:Connect(function()
        local details = "Game: " .. tostring(gameName)
            .. "\nPlace ID: " .. tostring(placeId)
            .. "\nLink: https://www.roblox.com/games/" .. tostring(placeId)
        if setclipboard then
            pcall(setclipboard, details)
            UI.Flash(UI.DetailsButton, "Details copied", "Copy game details")
        else
            set(UI.UnsupportedText, "Text", "Place ID: " .. tostring(placeId) .. ". Share it with the game name in our Discord.")
        end
    end)
end

if UI.GamesButton then
    UI.GamesButton.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(setclipboard, "https://neoxsoftworks.eu/games.html")
            UI.Flash(UI.GamesButton, "Link copied", "Supported games")
        else
            set(UI.UnsupportedText, "Text", "See every supported game at neoxsoftworks.eu/games.html")
        end
    end)
end

if UI.RequestButton then
    UI.RequestButton.MouseEnter:Connect(function()
        tween(UI.RequestButton, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(142, 99, 255) })
    end)
    UI.RequestButton.MouseLeave:Connect(function()
        tween(UI.RequestButton, TweenInfo.new(0.2), { BackgroundColor3 = COLOR.Accent })
    end)
    UI.RequestButton.MouseButton1Click:Connect(function()
        if setclipboard then
            pcall(setclipboard, "https://neoxsoftworks.eu/discord")
            UI.Flash(UI.RequestButton, "Invite copied", UI.RequestLabel or "Request on Discord")
        else
            UI.Flash(UI.RequestButton, "neoxsoftworks.eu/discord", UI.RequestLabel or "Request on Discord")
        end
    end)
end

if UI.CloseButton then
    UI.CloseButton.MouseEnter:Connect(function()
        tween(UI.CloseButton, TweenInfo.new(0.2), { TextColor3 = COLOR.Primary })
    end)
    UI.CloseButton.MouseLeave:Connect(function()
        tween(UI.CloseButton, TweenInfo.new(0.2), { TextColor3 = COLOR.Secondary })
    end)
    UI.CloseButton.MouseButton1Click:Connect(function()
        UI.UnsupportedClosed = true
    end)
end

UI.Failed = false
UI.Done = false

UI.AttachShadow = function(target, scaleObject, parent)
    local shadow = new("ImageLabel", {
        Name = "Shadow",
        AnchorPoint = target.AnchorPoint,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = "rbxassetid://8992230677",
        ImageColor3 = Color3.new(0, 0, 0),
        ImageTransparency = 0.55,
        ScaleType = enumOf("ScaleType", "Slice"),
        SliceCenter = Rect.new(99, 99, 99, 99),
        ZIndex = 0,
        Parent = parent
    })
    if not shadow then
        return nil
    end
    local function sync()
        local factor = scaleObject and scaleObject.Scale or 1
        local size = target.AbsoluteSize
        set(shadow, "Position", target.Position)
        set(shadow, "Size", UDim2.new(0, size.X + 100 * factor, 0, size.Y + 100 * factor))
        set(shadow, "SliceScale", factor)
    end
    sync()
    target:GetPropertyChangedSignal("Position"):Connect(sync)
    target:GetPropertyChangedSignal("AbsoluteSize"):Connect(sync)
    return shadow
end

UI.Collect = function(root)
    local list = {}
    local function add(object, property)
        local ok, value = pcall(function()
            return object[property]
        end)
        if ok and type(value) == "number" and value < 1 then
            table.insert(list, { Object = object, Property = property, Value = value })
        end
    end
    local objects = root:GetDescendants()
    table.insert(objects, root)
    for _, object in ipairs(objects) do
        if object:IsA("UIStroke") then
            add(object, "Transparency")
        elseif object:IsA("GuiObject") then
            add(object, "BackgroundTransparency")
            if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
                add(object, "TextTransparency")
            elseif object:IsA("ImageLabel") or object:IsA("ImageButton") then
                add(object, "ImageTransparency")
            end
        end
    end
    return list
end

UI.FadeIn = function(list, duration)
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    for _, entry in ipairs(list) do
        set(entry.Object, entry.Property, 1)
        local goal = {}
        goal[entry.Property] = entry.Value
        tween(entry.Object, info, goal)
    end
end

UI.FadeOut = function(root, duration)
    local info = TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    for _, entry in ipairs(UI.Collect(root)) do
        local goal = {}
        goal[entry.Property] = 1
        tween(entry.Object, info, goal)
    end
end

UI.SetGame = function(name)
    if type(name) == "string" and #name > 0 then
        set(UI.Game, "Text", name)
    end
end

task.spawn(function()
    local started = os.clock()
    while not earlyPaidCheck.InfoReady and os.clock() - started < 10 do
        task.wait(0.1)
    end
    UI.SetGame(gameName)
end)

UI.SetStep = function(step, state)
    if not step or step.State == state then
        return
    end
    step.State = state
    local info = TweenInfo.new(0.2)
    if state == "active" then
        set(step.Icon, "Image", UI.Icon.Loader)
        tween(step.Icon, info, { ImageColor3 = COLOR.Accent })
        tween(step.Label, info, { TextColor3 = COLOR.Primary })
    elseif state == "done" then
        set(step.Icon, "Image", UI.Icon.Check)
        set(step.Icon, "Rotation", 0)
        set(step.Icon, "Size", UDim2.new(0, 6, 0, 6))
        tween(step.Icon, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Size = UDim2.new(0, 14, 0, 14) })
        tween(step.Icon, info, { ImageColor3 = COLOR.Success })
        tween(step.Label, info, { TextColor3 = COLOR.Secondary })
    elseif state == "warning" then
        set(step.Icon, "Image", UI.Icon.Warning)
        set(step.Icon, "Rotation", 0)
        tween(step.Icon, info, { ImageColor3 = COLOR.Warning })
        tween(step.Label, info, { TextColor3 = COLOR.Warning })
    elseif state == "failed" then
        set(step.Icon, "Image", UI.Icon.Error)
        set(step.Icon, "Rotation", 0)
        tween(step.Icon, info, { ImageColor3 = COLOR.Error })
        tween(step.Label, info, { TextColor3 = COLOR.Error })
    end
end

UI.SyncSteps = function(value)
    if UI.Failed then
        return
    end
    for index, step in ipairs(UI.Steps) do
        if value >= UI.StepMarks[index + 1] then
            UI.SetStep(step, "done")
        elseif value >= UI.StepMarks[index] then
            UI.SetStep(step, "active")
        end
    end
    if value >= UI.StepMarks[#UI.StepMarks] and not UI.Done then
        UI.Done = true
        set(UI.BadgeIcon, "Image", UI.Icon.Success)
        set(UI.BadgeIcon, "Rotation", 0)
        tween(UI.BadgeIcon, TweenInfo.new(0.2), { ImageColor3 = COLOR.Success })
        tween(UI.Badge, TweenInfo.new(0.2), { BackgroundColor3 = COLOR.Success })
        tween(UI.Fill, TweenInfo.new(0.2), { BackgroundColor3 = COLOR.Success })
    end
end

UI.ShowUnsupported = function(name, pending)
    UI.Failed = true
    for _, step in ipairs(UI.Steps) do
        if step.State == "active" then
            UI.SetStep(step, "warning")
        end
    end
    local title = (name and name ~= "" and name ~= "this game") and name or "This game"
    set(UI.Heading, "Text", pending and "Coming back soon" or "Not supported yet")
    set(UI.BadgeIcon, "Image", UI.Icon.Warning)
    set(UI.BadgeIcon, "Rotation", 0)
    tween(UI.BadgeIcon, TweenInfo.new(0.25), { ImageColor3 = COLOR.Warning })
    tween(UI.Badge, TweenInfo.new(0.25), { BackgroundColor3 = COLOR.Warning })
    tween(UI.Fill, TweenInfo.new(0.25), { BackgroundColor3 = COLOR.Warning })
    set(UI.Status, "Text", title)
    set(UI.Percent, "Text", pending and "Script is moving to the NEOX server" or "No script for this game yet")
    task.wait(1)

    local leaving = { UI.Track }
    for _, step in ipairs(UI.Steps) do
        table.insert(leaving, step.Row)
    end
    for _, object in ipairs(leaving) do
        pcall(UI.FadeOut, object, 0.2)
    end
    task.wait(0.25)
    for _, object in ipairs(leaving) do
        set(object, "Visible", false)
    end

    if pending then
        UI.RequestLabel = "Updates on Discord"
        set(UI.RequestButton, "Text", UI.RequestLabel)
        set(UI.UnsupportedText, "Text", "NEOX HUB has a script for " .. title .. ", but it hasn't been moved to the NEOX HUB server yet. It will be back soon. Join our Discord to know when it's ready.")
    else
        set(UI.UnsupportedText, "Text", title .. " isn't supported by NEOX HUB yet. Request it on our Discord and paste the game details so the team can add it.")
    end
    set(UI.Unsupported, "Visible", true)
    pcall(function()
        UI.FadeIn(UI.Collect(UI.Unsupported), 0.3)
    end)
end

UI.WaitUnsupported = function(timeout)
    local started = os.clock()
    while not UI.UnsupportedClosed and os.clock() - started < timeout do
        task.wait(0.1)
    end
end

local REVEAL = {}

local function register(object, property, shown)
    if object then
        table.insert(REVEAL, { Object = object, Property = property, Shown = shown })
        set(object, property, 1)
    end
end

for _, object in ipairs(UI.Panel:GetDescendants()) do
    if object:IsA("UIStroke") then
        register(object, "Transparency", object.Transparency)
    elseif object:IsA("GuiObject") then
        if object.BackgroundTransparency < 1 then
            register(object, "BackgroundTransparency", object.BackgroundTransparency)
        end
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            register(object, "TextTransparency", object.TextTransparency)
        elseif object:IsA("ImageLabel") then
            register(object, "ImageTransparency", object.ImageTransparency)
        end
    end
end
register(UI.Panel, "BackgroundTransparency", 0)

UI.Shadow = UI.AttachShadow(UI.Panel, UI.Scale, Loader)
register(UI.Shadow, "ImageTransparency", 0.55)

local dismissed = false
local destroyed = false
local displayed = 0
local target = 0
local connections = {}

UI.FitScale = 1

local function fit()
    if not UI.Scale then
        return
    end
    local camera = workspace and workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    if viewport.X <= 0 or viewport.Y <= 0 then
        return
    end
    UI.FitScale = math.clamp(math.min(viewport.X / 600, viewport.Y / 370), 0.5, 1)
    UI.Scale.Scale = UI.FitScale
end

pcall(fit)

pcall(function()
    local camera = workspace.CurrentCamera
    if camera then
        table.insert(connections, camera:GetPropertyChangedSignal("ViewportSize"):Connect(fit))
    end
    table.insert(connections, workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
        pcall(fit)
    end))
end)

local keyGui = nil

local function cleanup()
    if destroyed then
        return
    end
    destroyed = true
    dismissed = true
    for _, connection in ipairs(connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    pcall(function()
        Loader:Destroy()
    end)
    if keyGui then
        local closing = keyGui
        pcall(function()
            UI.FadeOut(closing, 0.2)
        end)
        task.delay(0.25, function()
            pcall(function()
                closing:Destroy()
            end)
        end)
    end
    env.__NEOX_LOADER_ACTIVE = nil
    env.__NEOX_LOADER_GUI = nil
    env.__NEOX_LOADER_STARTED = nil
end

task.delay(CONFIG.HARD_TIMEOUT, cleanup)

local function reveal(shown)
    local info = TweenInfo.new(
        shown and 0.35 or 0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    for _, entry in ipairs(REVEAL) do
        local goal = {}
        goal[entry.Property] = shown and entry.Shown or 1
        tween(entry.Object, info, goal)
    end
end

local function setTone(color)
    UI.Failed = true
    for _, step in ipairs(UI.Steps) do
        if step.State == "active" then
            UI.SetStep(step, "failed")
        end
    end
    set(UI.Percent, "Text", "Stopped")
    set(UI.BadgeIcon, "Image", UI.Icon.Error)
    set(UI.BadgeIcon, "Rotation", 0)
    tween(UI.BadgeIcon, TweenInfo.new(0.25), { ImageColor3 = color })
    tween(UI.Badge, TweenInfo.new(0.25), { BackgroundColor3 = color })
    tween(UI.Fill, TweenInfo.new(0.25), { BackgroundColor3 = color })
end

local function setStatus(text)
    if dismissed or not UI.Status or UI.Status.Text == text then
        return
    end
    set(UI.Status, "Text", text)
    set(UI.Status, "TextTransparency", 1)
    tween(UI.Status, TweenInfo.new(0.2), { TextTransparency = 0 })
end

local function setProgress(value)
    target = math.clamp(value, 0, 100)
    UI.SyncSteps(target)
end

UI.Render = function(delta)
    local step = delta or 0.016
    displayed = displayed + (target - displayed) * math.min(step * 6, 1)
    if math.abs(target - displayed) < 0.1 then
        displayed = target
    end
    set(UI.Fill, "Size", UDim2.new(displayed / 100, 0, 1, 0))
    if not UI.Failed then
        set(UI.Percent, "Text", tostring(math.floor(displayed + 0.5)) .. "% complete")
    end

    local spin = step * 300
    if not UI.Failed and not UI.Done and UI.BadgeIcon then
        set(UI.BadgeIcon, "Rotation", (UI.BadgeIcon.Rotation + spin) % 360)
    end
    for _, item in ipairs(UI.Steps) do
        if item.State == "active" then
            set(item.Icon, "Rotation", (item.Icon.Rotation + spin) % 360)
        end
    end
end

local stepSignal = RunService and (RunService.RenderStepped or RunService.Heartbeat)
local counter

if stepSignal then
    local ok, connection = pcall(function()
        return stepSignal:Connect(function(delta)
            if destroyed or dismissed then
                return
            end
            UI.Render(delta)
        end)
    end)
    if ok and connection then
        counter = connection
        table.insert(connections, connection)
    end
end

if not counter then
    task.spawn(function()
        while not destroyed and not dismissed do
            UI.Render(0.03)
            task.wait(0.03)
        end
    end)
end

local function showLoader()
    set(UI.Scale, "Scale", UI.FitScale * 0.97)
    reveal(true)
    tween(
        UI.Scale,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Scale = UI.FitScale }
    )
    tween(
        UI.Panel,
        TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        { Position = UDim2.new(0.5, 0, 0.5, 0) }
    )
    task.wait(0.35)
end

local function hideLoader()
    if dismissed then
        return
    end
    dismissed = true
    reveal(false)
    task.wait(0.3)
    pcall(function()
        Loader:Destroy()
    end)
    if counter then
        pcall(function()
            counter:Disconnect()
        end)
    end
end

local function failLoader(message)
    setTone(COLOR.Error)
    setStatus(message)
    setProgress(100)
    task.wait(2)
    hideLoader()
    cleanup()
    sendNotification(CONFIG.HUB_NAME .. " - ERROR", message, CONFIG.NOTIFICATION_DURATION.ERROR)
end

pcall(showLoader)

setStatus("Initializing NEOX HUB")
setProgress(10)
task.wait(0.15)

setStatus("Looking up this game")
setProgress(32)

local resolvedScriptId, resolvedGameName, requestReached, gameSupported, resolvedKeyless = nil, nil, false, false, false
local gamePending = false
UI.Resolving = true
task.delay(5, function()
    if UI.Resolving then
        setStatus("Still working, the server is busy")
    end
end)
local cachedGame = NEOX_CACHE.Get('game')
if type(cachedGame) == 'table' and cachedGame.unsupported == true then
    requestReached = true
    gameSupported = false
    if cachedGame.pending == true then
        gamePending = true
        if type(cachedGame.game_name) == 'string' and #cachedGame.game_name > 0 then
            resolvedGameName = cachedGame.game_name
        end
    end
elseif type(cachedGame) == 'table' and type(cachedGame.script_id) == 'string' and #cachedGame.script_id > 0 then
    resolvedScriptId = cachedGame.script_id
    resolvedGameName = cachedGame.game_name
    resolvedKeyless = cachedGame.keyless == true
    requestReached = true
    gameSupported = true
end
for attempt = 1, 3 do
    if requestReached then
        break
    end
    pcall(function()
        local resp = requestWithTimeout({
            Url = CONFIG.BASE_URL .. '/api/games/resolve?place_id=' .. tostring(placeId),
            Method = 'GET',
        }, 15)
        if resp and resp.StatusCode == 200 then
            requestReached = true
            local decoded = HttpService:JSONDecode(resp.Body)
            if decoded and decoded.success and type(decoded.script_id) == 'string' and #decoded.script_id > 0 then
                resolvedScriptId = decoded.script_id
                resolvedGameName = decoded.game_name
                resolvedKeyless = decoded.keyless == true
                gameSupported = true
                NEOX_CACHE.Set('game', {
                    script_id = decoded.script_id,
                    game_name = decoded.game_name,
                    keyless = decoded.keyless == true,
                })
            elseif decoded and decoded.known == true then
                gamePending = true
                if type(decoded.game_name) == 'string' and #decoded.game_name > 0 then
                    resolvedGameName = decoded.game_name
                end
                NEOX_CACHE.Set('game', { unsupported = true, pending = true, game_name = resolvedGameName }, 120)
            else
                NEOX_CACHE.Set('game', { unsupported = true }, 300)
            end
        end
    end)
    if requestReached or attempt == 3 then
        break
    end
    setStatus("Server busy, retrying (" .. tostring(attempt + 1) .. "/3)")
    task.wait(attempt * 2)
end
UI.Resolving = false

if not requestReached then
    failLoader("Unable to reach the server")
    return
end

if not gameSupported then
    local infoWait = os.clock()
    while not earlyPaidCheck.InfoReady and os.clock() - infoWait < 2 do
        task.wait(0.1)
    end
    if gamePending and type(resolvedGameName) == "string" and #resolvedGameName > 0 then
        gameName = resolvedGameName
        earlyPaidCheck.Resolved = true
    end
    UI.SetGame(gameName)
    UI.ShowUnsupported(gameName, gamePending)
    UI.WaitUnsupported(45)
    hideLoader()
    cleanup()
    return
end

setStatus("Verifying compatibility")
setProgress(54)
task.wait(0.15)

if type(resolvedGameName) == "string" and #resolvedGameName > 0 then
    gameName = resolvedGameName
    earlyPaidCheck.Resolved = true
end

UI.SetGame(gameName)
if not resolvedKeyless then
    prefetchNonce()
end
setStatus("Preparing script")
setProgress(70)
task.wait(0.15)

setStatus("Waiting for authentication")
setProgress(75)
task.wait(0.2)
hideLoader()

keyGui = new("ScreenGui", {
    Name = "NXK_" .. tostring(math.random(100000, 999999)),
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = enumOf("ZIndexBehavior", "Sibling"),
    DisplayOrder = 999999
})

if not keyGui or not mount(keyGui) then
    cleanup()
    warn("[NEOX] Unable to mount authentication interface")
    return
end
env.__NEOX_LOADER_GUI = keyGui

local function createTween(instance, props)
    local tweenInfo = TweenInfo.new(
        CONFIG.ANIMATION_SPEED,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    return TweenService:Create(instance, tweenInfo, props)
end

local mainFrame = Instance.new('Frame')
mainFrame.Name = 'MainFrame'
mainFrame.Size = UDim2.new(0, 540, 0, 310)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 8)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(11, 12, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = false
mainFrame.ClipsDescendants = true
mainFrame.Parent = keyGui

local keyDrag = { Active = false }

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        keyDrag.Active = true
        keyDrag.Start = input.Position
        keyDrag.Origin = mainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                keyDrag.Active = false
            end
        end)
    end
end)

if UserInputService then
    table.insert(connections, UserInputService.InputChanged:Connect(function(input)
        if not keyDrag.Active then
            return
        end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - keyDrag.Start
            local offsetX = keyDrag.Origin.X.Offset + delta.X
            local offsetY = keyDrag.Origin.Y.Offset + delta.Y
            local screen = keyGui.AbsoluteSize
            local half = mainFrame.AbsoluteSize / 2
            local minX = half.X - keyDrag.Origin.X.Scale * screen.X
            local maxX = screen.X - half.X - keyDrag.Origin.X.Scale * screen.X
            local minY = half.Y - keyDrag.Origin.Y.Scale * screen.Y
            local maxY = screen.Y - half.Y - keyDrag.Origin.Y.Scale * screen.Y
            if maxX > minX then
                offsetX = math.clamp(offsetX, minX, maxX)
            end
            if maxY > minY then
                offsetY = math.clamp(offsetY, minY, maxY)
            end
            mainFrame.Position = UDim2.new(keyDrag.Origin.X.Scale, offsetX, keyDrag.Origin.Y.Scale, offsetY)
        end
    end))
end

local frameCorner = Instance.new('UICorner')
frameCorner.CornerRadius = UDim.new(0, 12)
frameCorner.Parent = mainFrame

local frameStroke = Instance.new('UIStroke')
frameStroke.Thickness = 1
frameStroke.Color = COLOR.Edge
frameStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
frameStroke.Parent = mainFrame

local keyScale = Instance.new('UIScale')
keyScale.Parent = mainFrame

local function computeKeyScale()
    local camera = workspace and workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    if viewport.X <= 0 or viewport.Y <= 0 then
        return 1
    end
    return math.clamp(math.min(viewport.X / 600, viewport.Y / 370), 0.5, 1)
end

local keyRestScale = computeKeyScale()
keyScale.Scale = keyRestScale * 0.97

UI.KeyShadow = UI.AttachShadow(mainFrame, keyScale, keyGui)

local ICON = {
    Key = 'rbxassetid://10723416652',
    Verify = 'rbxassetid://10734951367',
    Check = 'rbxassetid://10709790644',
    Crown = 'rbxassetid://10709818626',
    Close = 'rbxassetid://10747384394',
    Discord = 'rbxassetid://86699749765447',
    DiscordOffset = Vector2.new(256, 0),
    DiscordSize = Vector2.new(128, 128),
    Info = 'rbxassetid://10723415903',
    Success = 'rbxassetid://10709790387',
    Error = 'rbxassetid://10709752996',
    Warning = 'rbxassetid://10709753149',
    Clipboard = 'rbxassetid://10709798443',
    Loader = 'rbxassetid://10723433935',
    Copy = 'rbxassetid://10709812159',
    Refresh = 'rbxassetid://10734933222',
    Cart = 'rbxassetid://10734952479',
}

local function addButtonIcon(button, image, color, rectOffset, rectSize)
    local icon = Instance.new('ImageLabel')
    icon.Name = 'Icon'
    icon.Size = UDim2.new(0, 14, 0, 14)
    icon.AnchorPoint = Vector2.new(1, 0.5)
    icon.BackgroundTransparency = 1
    icon.Image = image
    icon.ImageColor3 = color
    if rectOffset and rectSize then
        icon.ImageRectOffset = rectOffset
        icon.ImageRectSize = rectSize
    end
    icon.ZIndex = button.ZIndex + 1
    icon.Parent = button

    local padding = Instance.new('UIPadding')
    padding.PaddingLeft = UDim.new(0, 20)
    padding.Parent = button

    local function place()
        icon.Position = UDim2.new(0.5, -button.TextBounds.X / 2 - 6, 0.5, 0)
    end
    place()
    button:GetPropertyChangedSignal('TextBounds'):Connect(place)
    return icon
end

local leftPane = Instance.new('Frame')
leftPane.Name = 'Brand'
leftPane.Size = UDim2.new(0, 220, 1, 0)
leftPane.BackgroundTransparency = 1
leftPane.BorderSizePixel = 0
leftPane.ZIndex = 2
leftPane.Parent = mainFrame

local keyTexture = Instance.new('ImageLabel')
keyTexture.Name = 'Texture'
keyTexture.Size = UDim2.new(1, 12, 1, 0)
keyTexture.BackgroundTransparency = 1
keyTexture.BorderSizePixel = 0
keyTexture.Image = 'http://www.roblox.com/asset/?id=91961368561481'
keyTexture.ImageTransparency = 0.93
keyTexture.ZIndex = 1
keyTexture.Parent = leftPane

local keyTextureCorner = Instance.new('UICorner')
keyTextureCorner.CornerRadius = UDim.new(0, 12)
keyTextureCorner.Parent = keyTexture

local keyLogo = Instance.new('ImageLabel')
keyLogo.Name = 'Logo'
keyLogo.Size = UDim2.new(0, 28, 0, 28)
keyLogo.Position = UDim2.new(0, 22, 0, 22)
keyLogo.BackgroundColor3 = COLOR.Tile
keyLogo.BorderSizePixel = 0
keyLogo.Image = CONFIG.ICON_ID
keyLogo.ZIndex = 2
keyLogo.Parent = leftPane

local keyLogoCorner = Instance.new('UICorner')
keyLogoCorner.CornerRadius = UDim.new(0, 7)
keyLogoCorner.Parent = keyLogo

local keyTitle = Instance.new('TextLabel')
keyTitle.Name = 'Title'
keyTitle.Size = UDim2.new(1, -82, 0, 28)
keyTitle.Position = UDim2.new(0, 60, 0, 22)
keyTitle.BackgroundTransparency = 1
keyTitle.Text = 'NEOX HUB'
keyTitle.TextColor3 = KEYCOLOR.TEXT
keyTitle.TextSize = 15
keyTitle.Font = FONT.Bold
keyTitle.TextXAlignment = Enum.TextXAlignment.Left
keyTitle.ZIndex = 2
keyTitle.Parent = leftPane

local gameCard = Instance.new('Frame')
gameCard.Name = 'Session'
gameCard.Size = UDim2.new(1, -44, 0, 64)
gameCard.Position = UDim2.new(0, 22, 0, 68)
gameCard.BackgroundColor3 = COLOR.Tile
gameCard.BorderSizePixel = 0
gameCard.ZIndex = 2
gameCard.Parent = leftPane

local gameCardCorner = Instance.new('UICorner')
gameCardCorner.CornerRadius = UDim.new(0, 10)
gameCardCorner.Parent = gameCard

local gameCardStroke = Instance.new('UIStroke')
gameCardStroke.Thickness = 1
gameCardStroke.Color = COLOR.Edge
gameCardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
gameCardStroke.Parent = gameCard

local gameIcon = Instance.new('ImageLabel')
gameIcon.Name = 'GameIcon'
gameIcon.Size = UDim2.new(0, 40, 0, 40)
gameIcon.Position = UDim2.new(0, 12, 0, 12)
gameIcon.BackgroundColor3 = COLOR.Track
gameIcon.BorderSizePixel = 0
gameIcon.Image = UI.UniverseId > 0 and ('rbxthumb://type=GameIcon&id=' .. tostring(UI.UniverseId) .. '&w=150&h=150') or CONFIG.ICON_ID
gameIcon.ScaleType = Enum.ScaleType.Crop
gameIcon.ZIndex = 3
gameIcon.Parent = gameCard

local gameIconCorner = Instance.new('UICorner')
gameIconCorner.CornerRadius = UDim.new(0, 8)
gameIconCorner.Parent = gameIcon

local gameTitle = Instance.new('TextLabel')
gameTitle.Name = 'Game'
gameTitle.Size = UDim2.new(1, -74, 0, 16)
gameTitle.Position = UDim2.new(0, 62, 0, 14)
gameTitle.BackgroundTransparency = 1
gameTitle.Text = gameName
gameTitle.TextColor3 = KEYCOLOR.TEXT
gameTitle.TextSize = 13
gameTitle.Font = FONT.Medium
gameTitle.TextTruncate = Enum.TextTruncate.AtEnd
gameTitle.TextXAlignment = Enum.TextXAlignment.Left
gameTitle.ZIndex = 3
gameTitle.Parent = gameCard

local gamePlayer = Instance.new('TextLabel')
gamePlayer.Name = 'Player'
gamePlayer.Size = UDim2.new(1, -74, 0, 14)
gamePlayer.Position = UDim2.new(0, 62, 0, 34)
gamePlayer.BackgroundTransparency = 1
gamePlayer.Text = UI.DisplayName
gamePlayer.TextColor3 = KEYCOLOR.TEXT_SECONDARY
gamePlayer.TextSize = 11
gamePlayer.Font = FONT.Regular
gamePlayer.TextTruncate = Enum.TextTruncate.AtEnd
gamePlayer.TextXAlignment = Enum.TextXAlignment.Left
gamePlayer.ZIndex = 3
gamePlayer.Parent = gameCard

local premiumRow = Instance.new('Frame')
premiumRow.Name = 'PremiumRow'
premiumRow.Size = UDim2.new(1, -44, 0, 136)
premiumRow.Position = UDim2.new(0, 22, 0, 154)
premiumRow.BackgroundTransparency = 1
premiumRow.BorderSizePixel = 0
premiumRow.ZIndex = 2
premiumRow.Parent = leftPane

local premiumTag = Instance.new('TextLabel')
premiumTag.Name = 'Tag'
premiumTag.Size = UDim2.new(1, 0, 0, 12)
premiumTag.BackgroundTransparency = 1
premiumTag.Text = 'PREMIUM'
premiumTag.TextColor3 = KEYCOLOR.PREMIUM
premiumTag.TextSize = 10
premiumTag.Font = FONT.Bold
premiumTag.TextXAlignment = Enum.TextXAlignment.Left
premiumTag.ZIndex = 3
premiumTag.Parent = premiumRow

local premiumLabel = Instance.new('TextLabel')
premiumLabel.Name = 'PremiumLabel'
premiumLabel.Size = UDim2.new(1, 0, 0, 34)
premiumLabel.Position = UDim2.new(0, 0, 0, 16)
premiumLabel.BackgroundTransparency = 1
premiumLabel.Text = 'Skip the key system for good'
premiumLabel.TextColor3 = KEYCOLOR.TEXT
premiumLabel.TextSize = 14
premiumLabel.Font = FONT.Medium
premiumLabel.TextWrapped = true
premiumLabel.TextXAlignment = Enum.TextXAlignment.Left
premiumLabel.TextYAlignment = Enum.TextYAlignment.Top
premiumLabel.ZIndex = 3
premiumLabel.Parent = premiumRow

local premiumPerks = {}
for index, perk in ipairs({ 'No keys, no ad links', '$12/month or $24 lifetime' }) do
    local row = Instance.new('Frame')
    row.Name = 'Perk' .. index
    row.Size = UDim2.new(1, 0, 0, 16)
    row.Position = UDim2.new(0, 0, 0, 40 + index * 16)
    row.BackgroundTransparency = 1
    row.ZIndex = 3
    row.Parent = premiumRow

    local bullet = Instance.new('ImageLabel')
    bullet.Size = UDim2.new(0, 12, 0, 12)
    bullet.Position = UDim2.new(0, 0, 0.5, 0)
    bullet.AnchorPoint = Vector2.new(0, 0.5)
    bullet.BackgroundTransparency = 1
    bullet.Image = ICON.Check
    bullet.ImageColor3 = KEYCOLOR.PREMIUM
    bullet.ZIndex = 3
    bullet.Parent = row

    local text = Instance.new('TextLabel')
    text.Size = UDim2.new(1, -18, 1, 0)
    text.Position = UDim2.new(0, 18, 0, 0)
    text.BackgroundTransparency = 1
    text.Text = perk
    text.TextColor3 = KEYCOLOR.TEXT_SECONDARY
    text.TextSize = 11
    text.Font = FONT.Regular
    text.TextTruncate = Enum.TextTruncate.AtEnd
    text.TextXAlignment = Enum.TextXAlignment.Left
    text.ZIndex = 3
    text.Parent = row

    premiumPerks[index] = row
end

local buyButton = Instance.new('TextButton')
buyButton.Name = 'BuyButton'
buyButton.Size = UDim2.new(1, 0, 0, 36)
buyButton.Position = UDim2.new(0, 0, 1, -36)
buyButton.BackgroundColor3 = KEYCOLOR.PREMIUM
buyButton.Text = 'Get Premium'
buyButton.TextSize = 13
buyButton.TextColor3 = Color3.fromRGB(28, 20, 6)
buyButton.Font = FONT.Bold
buyButton.AutoButtonColor = false
buyButton.ZIndex = 4
buyButton.Parent = premiumRow

local buyButtonCorner = Instance.new('UICorner')
buyButtonCorner.CornerRadius = UDim.new(0, 8)
buyButtonCorner.Parent = buyButton

local rightPane = Instance.new('Frame')
rightPane.Name = 'Form'
rightPane.Size = UDim2.new(1, -220, 1, 0)
rightPane.Position = UDim2.new(0, 220, 0, 0)
rightPane.BackgroundColor3 = COLOR.Panel
rightPane.BorderSizePixel = 0
rightPane.ZIndex = 2
rightPane.Parent = mainFrame

local rightPaneCorner = Instance.new('UICorner')
rightPaneCorner.CornerRadius = UDim.new(0, 12)
rightPaneCorner.Parent = rightPane

local rightPaneSquare = Instance.new('Frame')
rightPaneSquare.Name = 'Square'
rightPaneSquare.Size = UDim2.new(0, 12, 1, 0)
rightPaneSquare.BackgroundColor3 = COLOR.Panel
rightPaneSquare.BorderSizePixel = 0
rightPaneSquare.ZIndex = 2
rightPaneSquare.Parent = rightPane

local paneDivider = Instance.new('Frame')
paneDivider.Name = 'Divider'
paneDivider.Size = UDim2.new(0, 1, 1, 0)
paneDivider.BackgroundColor3 = COLOR.Edge
paneDivider.BorderSizePixel = 0
paneDivider.ZIndex = 3
paneDivider.Parent = rightPane

local discordButton = Instance.new('TextButton')
discordButton.Name = 'DiscordButton'
discordButton.Size = UDim2.new(0, 76, 0, 24)
discordButton.Position = UDim2.new(1, -48, 0, 20)
discordButton.AnchorPoint = Vector2.new(1, 0)
discordButton.BackgroundTransparency = 1
discordButton.Text = 'Discord'
discordButton.TextSize = 12
discordButton.TextColor3 = KEYCOLOR.TEXT_SECONDARY
discordButton.Font = FONT.Medium
discordButton.AutoButtonColor = false
discordButton.ZIndex = 3
discordButton.Parent = rightPane

local discordIcon = addButtonIcon(discordButton, ICON.Discord, KEYCOLOR.TEXT_SECONDARY, ICON.DiscordOffset, ICON.DiscordSize)

local closeButton = Instance.new('TextButton')
closeButton.Name = 'CloseButton'
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -18, 0, 20)
closeButton.AnchorPoint = Vector2.new(1, 0)
closeButton.BackgroundColor3 = KEYCOLOR.SECONDARY
closeButton.BackgroundTransparency = 1
closeButton.Text = ''
closeButton.TextSize = 12
closeButton.TextColor3 = KEYCOLOR.TEXT_SECONDARY
closeButton.Font = FONT.Medium
closeButton.AutoButtonColor = false
closeButton.ZIndex = 3
closeButton.Parent = rightPane

local closeCorner = Instance.new('UICorner')
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

local closeIcon = Instance.new('ImageLabel')
closeIcon.Name = 'Icon'
closeIcon.Size = UDim2.new(0, 14, 0, 14)
closeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
closeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
closeIcon.BackgroundTransparency = 1
closeIcon.Image = ICON.Close
closeIcon.ImageColor3 = KEYCOLOR.TEXT_SECONDARY
closeIcon.ZIndex = 4
closeIcon.Parent = closeButton

local formHeading = Instance.new('TextLabel')
formHeading.Name = 'Heading'
formHeading.Size = UDim2.new(1, -52, 0, 22)
formHeading.Position = UDim2.new(0, 26, 0, 62)
formHeading.BackgroundTransparency = 1
formHeading.Text = 'Key verification'
formHeading.TextColor3 = KEYCOLOR.TEXT
formHeading.TextSize = 18
formHeading.Font = FONT.Bold
formHeading.TextXAlignment = Enum.TextXAlignment.Left
formHeading.TextTruncate = Enum.TextTruncate.AtEnd
formHeading.ZIndex = 3
formHeading.Parent = rightPane

local tutorialText = Instance.new('TextLabel')
tutorialText.Name = 'TutorialText'
local DEFAULT_TUTORIAL_TEXT =
    "Click Get Key to generate a key. It takes about 10 seconds. Paste it below and press Verify."
local DEFAULT_TUTORIAL_COLOR = KEYCOLOR.TEXT_SECONDARY

tutorialText.Size = UDim2.new(1, -52, 0, 44)
tutorialText.Position = UDim2.new(0, 26, 0, 92)
tutorialText.BackgroundTransparency = 1
tutorialText.Text = DEFAULT_TUTORIAL_TEXT
tutorialText.TextColor3 = DEFAULT_TUTORIAL_COLOR
tutorialText.TextSize = 12
tutorialText.Font = FONT.Regular
tutorialText.TextWrapped = true
tutorialText.TextXAlignment = Enum.TextXAlignment.Left
tutorialText.TextYAlignment = Enum.TextYAlignment.Top
tutorialText.ZIndex = 3
tutorialText.Parent = rightPane

local keyInputFrame = Instance.new('Frame')
keyInputFrame.Name = 'KeyInputContainer'
keyInputFrame.Size = UDim2.new(1, -52, 0, 40)
keyInputFrame.Position = UDim2.new(0, 26, 0, 144)
keyInputFrame.BackgroundColor3 = KEYCOLOR.INPUT_BG
keyInputFrame.BorderSizePixel = 0
keyInputFrame.ZIndex = 3
keyInputFrame.Parent = rightPane

local inputStroke = Instance.new('UIStroke')
inputStroke.Thickness = 1
inputStroke.Color = KEYCOLOR.BORDER
inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
inputStroke.Parent = keyInputFrame

local inputCorner = Instance.new('UICorner')
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = keyInputFrame

local keyInput = Instance.new('TextBox')
keyInput.Name = 'KeyInput'
keyInput.Size = UDim2.new(1, -24, 1, 0)
keyInput.Position = UDim2.new(0, 12, 0, 0)
keyInput.BackgroundTransparency = 1
keyInput.PlaceholderText = 'Paste your key'
keyInput.PlaceholderColor3 = COLOR.Muted
keyInput.Text = ''
keyInput.TextSize = 13
keyInput.TextColor3 = KEYCOLOR.TEXT
keyInput.Font = FONT.Regular
keyInput.ClearTextOnFocus = false
keyInput.TextTruncate = Enum.TextTruncate.AtEnd
keyInput.TextXAlignment = Enum.TextXAlignment.Left
keyInput.ZIndex = 4
keyInput.Parent = keyInputFrame

keyInput.Focused:Connect(function()
    createTween(inputStroke, { Color = KEYCOLOR.PRIMARY }):Play()
end)

keyInput.FocusLost:Connect(function()
    createTween(inputStroke, { Color = KEYCOLOR.BORDER }):Play()
end)

local statusBadge = Instance.new('Frame')
statusBadge.Name = 'StatusBadge'
statusBadge.Size = UDim2.new(0, 44, 0, 44)
statusBadge.Position = UDim2.new(0.5, 0, 0, 112)
statusBadge.AnchorPoint = Vector2.new(0.5, 0)
statusBadge.BackgroundColor3 = KEYCOLOR.INFO
statusBadge.BackgroundTransparency = 0.88
statusBadge.BorderSizePixel = 0
statusBadge.Visible = false
statusBadge.ZIndex = 3
statusBadge.Parent = rightPane

local statusBadgeCorner = Instance.new('UICorner')
statusBadgeCorner.CornerRadius = UDim.new(1, 0)
statusBadgeCorner.Parent = statusBadge

UI.StatusPop = Instance.new('UIScale')
UI.StatusPop.Parent = statusBadge

local statusIcon = Instance.new('ImageLabel')
statusIcon.Name = 'Icon'
statusIcon.Size = UDim2.new(0, 20, 0, 20)
statusIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
statusIcon.AnchorPoint = Vector2.new(0.5, 0.5)
statusIcon.BackgroundTransparency = 1
statusIcon.Image = ICON.Info
statusIcon.ImageColor3 = KEYCOLOR.INFO
statusIcon.ZIndex = 4
statusIcon.Parent = statusBadge

local statusLabel = Instance.new('TextLabel')
statusLabel.Name = 'StatusLabel'
statusLabel.Size = UDim2.new(1, -52, 0, 36)
statusLabel.Position = UDim2.new(0.5, 0, 0, 178)
statusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ''
statusLabel.TextColor3 = KEYCOLOR.TEXT
statusLabel.TextSize = 14
statusLabel.Font = FONT.Medium
statusLabel.TextWrapped = true
statusLabel.ZIndex = 3
statusLabel.Parent = rightPane

local statusCode = Instance.new('TextLabel')
statusCode.Name = 'StatusCode'
statusCode.Size = UDim2.new(1, -52, 0, 14)
statusCode.Position = UDim2.new(0.5, 0, 0, 203)
statusCode.AnchorPoint = Vector2.new(0.5, 0.5)
statusCode.BackgroundTransparency = 1
statusCode.Text = ''
statusCode.TextColor3 = COLOR.Muted
statusCode.TextSize = 11
statusCode.Font = FONT.Medium
statusCode.ZIndex = 3
statusCode.Parent = rightPane

local loadingDots = Instance.new('TextLabel')
loadingDots.Name = 'LoadingState'
loadingDots.Size = UDim2.new(0, 0, 0, 0)
loadingDots.BackgroundTransparency = 1
loadingDots.Text = ''
loadingDots.TextTransparency = 1
loadingDots.Visible = false
loadingDots.Parent = rightPane

local helpLabel = Instance.new('TextLabel')
helpLabel.Name = 'HelpLabel'
helpLabel.Size = UDim2.new(1, -52, 0, 40)
helpLabel.Position = UDim2.new(0.5, 0, 0, 236)
helpLabel.AnchorPoint = Vector2.new(0.5, 0.5)
helpLabel.BackgroundTransparency = 1
helpLabel.Text = ''
helpLabel.TextColor3 = KEYCOLOR.TEXT_SECONDARY
helpLabel.TextSize = 12
helpLabel.Font = FONT.Regular
helpLabel.TextWrapped = true
helpLabel.ZIndex = 3
helpLabel.Visible = false
helpLabel.Parent = rightPane

statusLabel:GetPropertyChangedSignal('Text'):Connect(function()
    local shown = statusLabel.Text ~= ''
    statusBadge.Visible = shown
    if not shown then
        statusCode.Text = ''
    end
end)

local buttonFrame = Instance.new('Frame')
buttonFrame.Name = 'ButtonContainer'
buttonFrame.Size = UDim2.new(1, -52, 0, 84)
buttonFrame.Position = UDim2.new(0, 26, 0, 196)
buttonFrame.BackgroundTransparency = 1
buttonFrame.ZIndex = 3
buttonFrame.Parent = rightPane

local verifyButton = Instance.new('TextButton')
verifyButton.Name = 'VerifyButton'
verifyButton.Size = UDim2.new(1, 0, 0, 38)
verifyButton.Position = UDim2.new(0, 0, 0, 0)
verifyButton.BackgroundColor3 = KEYCOLOR.PRIMARY
verifyButton.Text = 'Verify'
verifyButton.TextSize = 13
verifyButton.TextColor3 = KEYCOLOR.TEXT
verifyButton.Font = FONT.Bold
verifyButton.AutoButtonColor = false
verifyButton.ZIndex = 4
verifyButton.Parent = buttonFrame

local verifyCorner = Instance.new('UICorner')
verifyCorner.CornerRadius = UDim.new(0, 8)
verifyCorner.Parent = verifyButton

local getKeyButton = Instance.new('TextButton')
getKeyButton.Name = 'GetKeyButton'
getKeyButton.Size = UDim2.new(1, 0, 0, 38)
getKeyButton.Position = UDim2.new(0, 0, 0, 46)
getKeyButton.BackgroundColor3 = KEYCOLOR.SECONDARY
getKeyButton.Text = 'Get Key'
getKeyButton.TextSize = 13
getKeyButton.TextColor3 = KEYCOLOR.TEXT
getKeyButton.Font = FONT.Medium
getKeyButton.AutoButtonColor = false
getKeyButton.ZIndex = 4
getKeyButton.Parent = buttonFrame

local getKeyCorner = Instance.new('UICorner')
getKeyCorner.CornerRadius = UDim.new(0, 8)
getKeyCorner.Parent = getKeyButton

local getKeyStroke = Instance.new('UIStroke')
getKeyStroke.Thickness = 1
getKeyStroke.Color = KEYCOLOR.BORDER
getKeyStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
getKeyStroke.Parent = getKeyButton

local MAIN_FRAME_DEFAULT_SIZE = mainFrame.Size
local MAIN_FRAME_REDEEM_SIZE = mainFrame.Size

local redeemPromptFrame = Instance.new('Frame')
redeemPromptFrame.Name = 'RedeemPromptFrame'
redeemPromptFrame.Size = UDim2.new(1, -52, 0, 190)
redeemPromptFrame.Position = UDim2.new(0, 26, 0, 96)
redeemPromptFrame.BackgroundTransparency = 1
redeemPromptFrame.Visible = false
redeemPromptFrame.ZIndex = 3
redeemPromptFrame.Parent = rightPane

local redeemMessageLabel = Instance.new('TextLabel')
redeemMessageLabel.Name = 'RedeemMessageLabel'
redeemMessageLabel.Size = UDim2.new(1, 0, 0, 46)
redeemMessageLabel.Position = UDim2.new(0, 0, 0, 0)
redeemMessageLabel.BackgroundTransparency = 1
redeemMessageLabel.Text = 'This is a Premium or Lifetime key, but it has not been redeemed yet. You must redeem it before you can use it.'
redeemMessageLabel.TextColor3 = KEYCOLOR.WARNING
redeemMessageLabel.TextSize = 12
redeemMessageLabel.Font = FONT.Medium
redeemMessageLabel.TextWrapped = true
redeemMessageLabel.TextXAlignment = Enum.TextXAlignment.Left
redeemMessageLabel.TextYAlignment = Enum.TextYAlignment.Top
redeemMessageLabel.ZIndex = 4
redeemMessageLabel.Parent = redeemPromptFrame

local redeemCopyBtn = Instance.new('TextButton')
redeemCopyBtn.Name = 'RedeemCopyBtn'
redeemCopyBtn.Size = UDim2.new(1, 0, 0, 38)
redeemCopyBtn.Position = UDim2.new(0, 0, 0, 56)
redeemCopyBtn.BackgroundColor3 = KEYCOLOR.PRIMARY
redeemCopyBtn.Text = 'Copy User Portal URL'
redeemCopyBtn.TextSize = 13
redeemCopyBtn.TextColor3 = KEYCOLOR.TEXT
redeemCopyBtn.Font = FONT.Bold
redeemCopyBtn.AutoButtonColor = false
redeemCopyBtn.ZIndex = 4
redeemCopyBtn.Parent = redeemPromptFrame

local redeemCopyBtnCorner = Instance.new('UICorner')
redeemCopyBtnCorner.CornerRadius = UDim.new(0, 8)
redeemCopyBtnCorner.Parent = redeemCopyBtn

local redeemCheckBtn = Instance.new('TextButton')
redeemCheckBtn.Name = 'RedeemCheckBtn'
redeemCheckBtn.Size = UDim2.new(1, 0, 0, 38)
redeemCheckBtn.Position = UDim2.new(0, 0, 0, 102)
redeemCheckBtn.BackgroundColor3 = KEYCOLOR.SECONDARY
redeemCheckBtn.Text = "I've Redeemed - Check Again"
redeemCheckBtn.TextSize = 13
redeemCheckBtn.TextColor3 = KEYCOLOR.TEXT
redeemCheckBtn.Font = FONT.Medium
redeemCheckBtn.AutoButtonColor = false
redeemCheckBtn.ZIndex = 4
redeemCheckBtn.Parent = redeemPromptFrame

local redeemCheckBtnCorner = Instance.new('UICorner')
redeemCheckBtnCorner.CornerRadius = UDim.new(0, 8)
redeemCheckBtnCorner.Parent = redeemCheckBtn

local redeemCheckBtnStroke = Instance.new('UIStroke')
redeemCheckBtnStroke.Thickness = 1
redeemCheckBtnStroke.Color = KEYCOLOR.BORDER
redeemCheckBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
redeemCheckBtnStroke.Parent = redeemCheckBtn

local redeemHintLabel = Instance.new('TextLabel')
redeemHintLabel.Name = 'RedeemHintLabel'
redeemHintLabel.Size = UDim2.new(1, 0, 0, 30)
redeemHintLabel.Position = UDim2.new(0, 0, 0, 150)
redeemHintLabel.BackgroundTransparency = 1
redeemHintLabel.Text = 'You can also redeem your key at our Discord server.'
redeemHintLabel.TextColor3 = KEYCOLOR.TEXT_SECONDARY
redeemHintLabel.TextSize = 11
redeemHintLabel.Font = FONT.Regular
redeemHintLabel.TextWrapped = true
redeemHintLabel.TextXAlignment = Enum.TextXAlignment.Left
redeemHintLabel.ZIndex = 4
redeemHintLabel.Parent = redeemPromptFrame

local paidScriptPromptFrame = Instance.new('Frame')
paidScriptPromptFrame.Name = 'PaidScriptPromptFrame'
paidScriptPromptFrame.Size = UDim2.new(1, -52, 0, 190)
paidScriptPromptFrame.Position = UDim2.new(0, 26, 0, 96)
paidScriptPromptFrame.BackgroundTransparency = 1
paidScriptPromptFrame.Visible = false
paidScriptPromptFrame.ZIndex = 3
paidScriptPromptFrame.Parent = rightPane

local paidScriptIconLabel = Instance.new('TextLabel')
paidScriptIconLabel.Name = 'PaidScriptIconLabel'
paidScriptIconLabel.Size = UDim2.new(1, 0, 0, 12)
paidScriptIconLabel.Position = UDim2.new(0, 0, 0, 0)
paidScriptIconLabel.BackgroundTransparency = 1
paidScriptIconLabel.Text = 'PAID ONLY SCRIPT'
paidScriptIconLabel.TextColor3 = KEYCOLOR.PREMIUM
paidScriptIconLabel.TextSize = 10
paidScriptIconLabel.Font = FONT.Bold
paidScriptIconLabel.TextXAlignment = Enum.TextXAlignment.Left
paidScriptIconLabel.ZIndex = 4
paidScriptIconLabel.Parent = paidScriptPromptFrame

local paidScriptMessageLabel = Instance.new('TextLabel')
paidScriptMessageLabel.Name = 'PaidScriptMessageLabel'
paidScriptMessageLabel.Size = UDim2.new(1, 0, 0, 34)
paidScriptMessageLabel.Position = UDim2.new(0, 0, 0, 16)
paidScriptMessageLabel.BackgroundTransparency = 1
paidScriptMessageLabel.Text = 'This is a paid script. You need to buy it to use it.'
paidScriptMessageLabel.TextColor3 = KEYCOLOR.TEXT
paidScriptMessageLabel.TextSize = 12
paidScriptMessageLabel.Font = FONT.Regular
paidScriptMessageLabel.TextWrapped = true
paidScriptMessageLabel.TextXAlignment = Enum.TextXAlignment.Left
paidScriptMessageLabel.TextYAlignment = Enum.TextYAlignment.Top
paidScriptMessageLabel.ZIndex = 4
paidScriptMessageLabel.Parent = paidScriptPromptFrame

local paidScriptWebsiteBtn = Instance.new('TextButton')
paidScriptWebsiteBtn.Name = 'PaidScriptWebsiteBtn'
paidScriptWebsiteBtn.Size = UDim2.new(1, 0, 0, 38)
paidScriptWebsiteBtn.Position = UDim2.new(0, 0, 0, 56)
paidScriptWebsiteBtn.BackgroundColor3 = KEYCOLOR.PREMIUM
paidScriptWebsiteBtn.Text = 'Buy On Site'
paidScriptWebsiteBtn.TextSize = 13
paidScriptWebsiteBtn.TextColor3 = Color3.fromRGB(28, 20, 6)
paidScriptWebsiteBtn.Font = FONT.Bold
paidScriptWebsiteBtn.AutoButtonColor = false
paidScriptWebsiteBtn.ZIndex = 4
paidScriptWebsiteBtn.Parent = paidScriptPromptFrame

local paidScriptWebsiteBtnCorner = Instance.new('UICorner')
paidScriptWebsiteBtnCorner.CornerRadius = UDim.new(0, 8)
paidScriptWebsiteBtnCorner.Parent = paidScriptWebsiteBtn

local paidScriptDiscordBtn = Instance.new('TextButton')
paidScriptDiscordBtn.Name = 'PaidScriptDiscordBtn'
paidScriptDiscordBtn.Size = UDim2.new(1, 0, 0, 38)
paidScriptDiscordBtn.Position = UDim2.new(0, 0, 0, 102)
paidScriptDiscordBtn.BackgroundColor3 = KEYCOLOR.SECONDARY
paidScriptDiscordBtn.Text = 'Need Help? Join Discord'
paidScriptDiscordBtn.TextSize = 13
paidScriptDiscordBtn.TextColor3 = KEYCOLOR.TEXT
paidScriptDiscordBtn.Font = FONT.Medium
paidScriptDiscordBtn.AutoButtonColor = false
paidScriptDiscordBtn.ZIndex = 4
paidScriptDiscordBtn.Parent = paidScriptPromptFrame

local paidScriptDiscordBtnCorner = Instance.new('UICorner')
paidScriptDiscordBtnCorner.CornerRadius = UDim.new(0, 8)
paidScriptDiscordBtnCorner.Parent = paidScriptDiscordBtn

local paidScriptDiscordBtnStroke = Instance.new('UIStroke')
paidScriptDiscordBtnStroke.Thickness = 1
paidScriptDiscordBtnStroke.Color = KEYCOLOR.BORDER
paidScriptDiscordBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
paidScriptDiscordBtnStroke.Parent = paidScriptDiscordBtn

local paidScriptEnterKeyBtn = Instance.new('TextButton')
paidScriptEnterKeyBtn.Name = 'PaidScriptEnterKeyBtn'
paidScriptEnterKeyBtn.Size = UDim2.new(1, 0, 0, 24)
paidScriptEnterKeyBtn.Position = UDim2.new(0, 0, 0, 148)
paidScriptEnterKeyBtn.BackgroundTransparency = 1
paidScriptEnterKeyBtn.Text = 'Already Bought? Enter Your Key'
paidScriptEnterKeyBtn.TextColor3 = KEYCOLOR.TEXT_SECONDARY
paidScriptEnterKeyBtn.TextSize = 12
paidScriptEnterKeyBtn.Font = FONT.Medium
paidScriptEnterKeyBtn.AutoButtonColor = false
paidScriptEnterKeyBtn.ZIndex = 4
paidScriptEnterKeyBtn.Parent = paidScriptPromptFrame

addButtonIcon(buyButton, ICON.Crown, Color3.fromRGB(28, 20, 6))
addButtonIcon(verifyButton, ICON.Verify, KEYCOLOR.TEXT)
addButtonIcon(getKeyButton, ICON.Key, KEYCOLOR.TEXT)
addButtonIcon(redeemCopyBtn, ICON.Copy, KEYCOLOR.TEXT)
addButtonIcon(redeemCheckBtn, ICON.Refresh, KEYCOLOR.TEXT)
addButtonIcon(paidScriptWebsiteBtn, ICON.Cart, Color3.fromRGB(28, 20, 6))
addButtonIcon(paidScriptDiscordBtn, ICON.Discord, KEYCOLOR.TEXT, ICON.DiscordOffset, ICON.DiscordSize)

local function setupButtonHover(button, normalColor, hoverColor)
    local press = Instance.new('UIScale')
    press.Parent = button
    button.MouseEnter:Connect(function()
        createTween(button, { BackgroundColor3 = hoverColor }):Play()
    end)
    button.MouseLeave:Connect(function()
        createTween(button, { BackgroundColor3 = normalColor }):Play()
        createTween(press, { Scale = 1 }):Play()
    end)
    button.MouseButton1Down:Connect(function()
        createTween(press, { Scale = 0.97 }):Play()
    end)
    button.MouseButton1Up:Connect(function()
        createTween(press, { Scale = 1 }):Play()
    end)
end

setupButtonHover(getKeyButton, KEYCOLOR.SECONDARY, KEYCOLOR.SECONDARY_HOVER)
setupButtonHover(verifyButton, KEYCOLOR.PRIMARY, KEYCOLOR.PRIMARY_HOVER)
setupButtonHover(buyButton, KEYCOLOR.PREMIUM, KEYCOLOR.PREMIUM_HOVER)
setupButtonHover(redeemCopyBtn, KEYCOLOR.PRIMARY, KEYCOLOR.PRIMARY_HOVER)
setupButtonHover(redeemCheckBtn, KEYCOLOR.SECONDARY, KEYCOLOR.SECONDARY_HOVER)
setupButtonHover(paidScriptDiscordBtn, KEYCOLOR.SECONDARY, KEYCOLOR.SECONDARY_HOVER)
setupButtonHover(paidScriptWebsiteBtn, KEYCOLOR.PREMIUM, KEYCOLOR.PREMIUM_HOVER)

paidScriptEnterKeyBtn.MouseEnter:Connect(function()
    createTween(paidScriptEnterKeyBtn, { TextColor3 = KEYCOLOR.TEXT }):Play()
end)
paidScriptEnterKeyBtn.MouseLeave:Connect(function()
    createTween(paidScriptEnterKeyBtn, { TextColor3 = KEYCOLOR.TEXT_SECONDARY }):Play()
end)

closeButton.MouseEnter:Connect(function()
    createTween(closeButton, { BackgroundTransparency = 0 }):Play()
    createTween(closeIcon, { ImageColor3 = KEYCOLOR.TEXT }):Play()
end)
closeButton.MouseLeave:Connect(function()
    createTween(closeButton, { BackgroundTransparency = 1 }):Play()
    createTween(closeIcon, { ImageColor3 = KEYCOLOR.TEXT_SECONDARY }):Play()
end)

discordButton.MouseEnter:Connect(function()
    createTween(discordButton, { TextColor3 = KEYCOLOR.TEXT }):Play()
    createTween(discordIcon, { ImageColor3 = KEYCOLOR.TEXT }):Play()
end)
discordButton.MouseLeave:Connect(function()
    createTween(discordButton, { TextColor3 = KEYCOLOR.TEXT_SECONDARY }):Play()
    createTween(discordIcon, { ImageColor3 = KEYCOLOR.TEXT_SECONDARY }):Play()
end)

UI.FadeIn(UI.Collect(keyGui), 0.3)
TweenService:Create(keyScale, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Scale = keyRestScale }):Play()
TweenService:Create(mainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = UDim2.new(0.5, 0, 0.5, 0) }):Play()

local currentStatusThread = nil

local function setInputVisible(visible)
    keyInput.Visible = visible
    tutorialText.Visible = visible
    buttonFrame.Visible = visible
    keyInputFrame.Visible = visible
end

local pendingRedeemKey = nil

local function setHeading(text)
    if formHeading.Text == text then
        return
    end
    formHeading.Text = text
    formHeading.TextTransparency = 1
    createTween(formHeading, { TextTransparency = 0 }):Play()
end

local function showRedeemPrompt(key)
    pendingRedeemKey = key
    setHeading('Redeem your key')
    setInputVisible(false)
    statusLabel.Text = ''
    loadingDots.Visible = false
    helpLabel.Visible = false
    redeemCheckBtn.Text = "I've Redeemed - Check Again"
    createTween(mainFrame, { Size = MAIN_FRAME_REDEEM_SIZE }):Play()
    redeemPromptFrame.Visible = true
end

local function hideRedeemPrompt()
    pendingRedeemKey = nil
    setHeading('Key verification')
    redeemPromptFrame.Visible = false
    createTween(mainFrame, { Size = MAIN_FRAME_DEFAULT_SIZE }):Play()
end

local function showPaidScriptPrompt(scriptName)
    setHeading('Paid script')
    setInputVisible(false)
    statusLabel.Text = ''
    loadingDots.Visible = false
    helpLabel.Visible = false
    local displayName = (scriptName and scriptName ~= '') and scriptName or 'This script'
    paidScriptMessageLabel.Text = displayName .. ' is a paid script. You need to buy it to use it.'
    premiumRow.Visible = false
    createTween(mainFrame, { Size = MAIN_FRAME_REDEEM_SIZE }):Play()
    paidScriptPromptFrame.Visible = true
end

local function hidePaidScriptPrompt()
    setHeading('Key verification')
    paidScriptPromptFrame.Visible = false
    premiumRow.Visible = true
    createTween(mainFrame, { Size = MAIN_FRAME_DEFAULT_SIZE }):Play()
end

local verifyGuard = { Failures = 0, Until = 0, Rejected = {}, Last = nil }

local statusSpin = 0

local function showStatus(text, color, duration, showLoading, helpText)
    if currentStatusThread then
        pcall(task.cancel, currentStatusThread)
        currentStatusThread = nil
    end

    verifyGuard.Last = { text, color, duration, showLoading, helpText }

    local tone = color or KEYCOLOR.INFO
    local image = ICON.Info
    if showLoading then
        image = ICON.Loader
        if tone == KEYCOLOR.INFO then
            tone = KEYCOLOR.PRIMARY
        end
    elseif tone == KEYCOLOR.ERROR then
        image = ICON.Error
    elseif tone == KEYCOLOR.WARNING then
        image = ICON.Warning
    elseif tone == KEYCOLOR.SUCCESS then
        image = ICON.Success
    elseif tone == KEYCOLOR.PRIMARY or tone == KEYCOLOR.DISCORD or tone == KEYCOLOR.PREMIUM then
        image = ICON.Clipboard
    end

    local message, code = string.match(tostring(text), '^(.-)%s*%((NX%-%d+)%)%s*$')
    if not message or message == '' then
        message = tostring(text)
        code = nil
    end

    statusIcon.Image = image
    statusIcon.ImageColor3 = tone
    statusIcon.Rotation = 0
    statusBadge.BackgroundColor3 = tone
    statusLabel.Text = message
    statusLabel.TextColor3 = KEYCOLOR.TEXT
    statusCode.Text = code and ('Error code ' .. code) or ''
    statusLabel.TextTransparency = 1
    createTween(statusLabel, { TextTransparency = 0 }):Play()
    UI.StatusPop.Scale = 0.85
    TweenService:Create(UI.StatusPop, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()
    loadingDots.Visible = showLoading or false

    if helpText then
        helpLabel.Text = string.gsub(helpText, '^Help:%s*', '')
        helpLabel.Visible = true
    else
        helpLabel.Visible = false
    end

    statusSpin = statusSpin + 1
    if showLoading then
        local token = statusSpin
        task.spawn(function()
            while loadingDots.Visible and statusSpin == token do
                statusIcon.Rotation = (statusIcon.Rotation + 8) % 360
                task.wait(0.03)
            end
            if statusSpin == token then
                statusIcon.Rotation = 0
            end
        end)
    end

    if duration then
        currentStatusThread = task.spawn(function()
            task.wait(duration)
            statusLabel.Text = ''
            loadingDots.Visible = false
            helpLabel.Visible = false
        end)
    end
end

local function saveKey(key)
    return (pcall(function()
        if writefile then
            writefile(CONFIG.KEY_FILE, key)
        end
    end))
end

local function loadSavedKey()
    local scriptKey = nil
    pcall(function()
        scriptKey = env.script_key
        if type(scriptKey) ~= 'string' then
            scriptKey = script_key
        end
    end)
    if type(scriptKey) == 'string' then
        scriptKey = string.gsub(string.gsub(scriptKey, '^%s+', ''), '%s+$', '')
        if string.sub(scriptKey, 1, 5) == 'neox_' and #scriptKey >= 10 and #scriptKey <= 40 then
            return scriptKey
        end
    end
    local success, key = pcall(function()
        if readfile and isfile and isfile(CONFIG.KEY_FILE) then
            return readfile(CONFIG.KEY_FILE)
        end
        return nil
    end)
    return success and key or nil
end

local function getNonce()
    local pooled = takePrefetchedNonce()
    if pooled then
        return pooled, nil
    end
    local response = nil
    for attempt = 1, 2 do
        response = requestWithTimeout({
            Url = CONFIG.BASE_URL .. '/api/get-nonce',
            Method = 'GET',
            Headers = { ['Content-Type'] = 'application/json' },
        }, 15)
        if response and response.Body then
            break
        end
        if attempt == 1 then
            task.wait(1.5)
        end
    end

    if not response or not response.Body then
        return nil, 'Connection error. Please try again. (NX-0007)'
    end

    local decodeSuccess, body = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not decodeSuccess or not body or not body.nonce then
        return nil, 'Connection error. Please try again. (NX-0008)'
    end

    return body.nonce, nil
end

local isProcessing = false

local scriptId = resolvedScriptId or ''

local function validateKey(key)
    if key == '' or key:match('^%s*$') then
        showStatus('Key field is empty', KEYCOLOR.WARNING, 2)
        return nil, 'empty'
    end

    local rejected = verifyGuard.Rejected[key]
    if rejected then
        task.wait(0.2)
        showStatus(rejected[1], rejected[2], rejected[3], rejected[4], rejected[5])
        return nil
    end

    showStatus('Connecting...', KEYCOLOR.INFO, nil, true)

    local nonce, nonceError = getNonce()
    if not nonce then
        showStatus('Connection error. Please try again. (NX-0001)', KEYCOLOR.ERROR, 3, false,
            "Help: Check your internet connection, disable VPN if using one, and try again.")
        return nil, 'network'
    end

    showStatus('Verifying key...', KEYCOLOR.INFO, nil, true)

    local success, response, timedOut = false, nil, false
    for attempt = 1, 2 do
        if attempt == 2 then
            showStatus('Connection unstable, retrying...', KEYCOLOR.INFO, nil, true)
            task.wait(2)
            nonce = getNonce()
            if not nonce then
                break
            end
        end
        response, timedOut = requestWithTimeout({
            Url = CONFIG.BASE_URL .. '/api/validate-key',
            Method = 'POST',
            Headers = { ['Content-Type'] = 'application/json' },
            Body = HttpService:JSONEncode({
                key = key,
                hwid = hwid,
                nonce = nonce,
                game_name = gameName,
                script_id = scriptId,
                place_id = placeId,
                roblox_username = Players.LocalPlayer and Players.LocalPlayer.Name or nil,
                loader_version = CONFIG.LOADER_VERSION,
            }),
        }, 60, 8, function()
            showStatus('Still verifying, your connection seems slow...', KEYCOLOR.INFO, nil, true)
        end)
        success = response ~= nil
        local code = response and tonumber(response.StatusCode)
        if success and not (code and code >= 500) then
            break
        end
    end

    if timedOut and not response then
        showStatus('Your connection is too slow. (NX-0010)', KEYCOLOR.ERROR, 4, false,
            "Help: The server took too long to answer. Check your internet and try again.")
        return nil, 'network'
    end

    if not success then
        showStatus('Connection error. Please try again. (NX-0002)', KEYCOLOR.ERROR, 3, false,
            "Help: Please check your internet connection and try again.")
        return nil, 'network'
    end

    if not response then
        showStatus('Connection error. Please try again. (NX-0003)', KEYCOLOR.ERROR, 3, false,
            "Help: Server might be down or your internet is slow. Try again later.")
        return nil, 'network'
    end

    local statusCode = tonumber(response.StatusCode) or 0
    if statusCode == 429 then
        showStatus('Too many attempts. Please wait a moment.', KEYCOLOR.WARNING, 3, false,
            "Help: Wait a few seconds before trying again.")
        return nil, 'network'
    elseif statusCode >= 500 then
        showStatus('Server is busy. Please try again. (NX-0009)', KEYCOLOR.ERROR, 3, false,
            "Help: Our server is under heavy load right now. Try again in a minute.")
        return nil, 'network'
    end


    if not response.Body then
        showStatus('Connection error. Please try again. (NX-0004)', KEYCOLOR.ERROR, 3, false,
            "Help: Please check your internet connection and try again.")
        return nil, 'network'
    end

    local decodeSuccess, body = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not decodeSuccess or type(body) ~= 'table' then
        showStatus('Connection error. Please try again. (NX-0005)', KEYCOLOR.ERROR, 3, false,
            "Help: Please check your internet connection and try again.")
        return nil, 'network'
    end

    if not body.valid then
        if body.reason then
            local reason = string.lower(tostring(body.reason))
            verifyGuard.LastReason = reason
            if string.find(reason, 'premium expired') then
                showStatus('Your Premium has expired', KEYCOLOR.WARNING, 5, false,
                    "Help: Renew within 2 days of it ending at neoxsoftworks.eu/getneox, or this key and all its data are deleted.")
            elseif string.find(reason, 'not redeemed') then
                showRedeemPrompt(key)
                return nil, 'not_redeemed'
            elseif string.find(reason, 'separate purchase') or string.find(reason, 'not valid for this script') then
                NEOX_CACHE.Set('paid', { paid_only = true, title = gameName })
                showPaidScriptPrompt(gameName)
                return nil, 'paid_only'
            elseif string.find(reason, 'nonce') then
                showStatus('Verification failed. Please try again. (NX-0006)', KEYCOLOR.ERROR, 3, false,
                    "Help: Please disable any VPN and try again.")
            elseif string.find(reason, 'hwid blacklist') then
                showStatus('Your HWID Is Blocked (contact us)', KEYCOLOR.ERROR, 3, false,
                    "Help: Contact support in Discord for assistance.")
            elseif string.find(reason, 'hwid') or string.find(reason, 'hardware') then
                showStatus('Key bound to another HWID', KEYCOLOR.ERROR, 3, false,
                    "Help: This key is already used on another device. Get a new key, or ask for an HWID reset in our Discord.")
            else
                if string.find(reason, 'script') or string.find(reason, 'game') then
                    NEOX_CACHE.Clear('game')
                end
                showStatus('Key validation failed: ' .. tostring(body.reason), KEYCOLOR.ERROR, 3, false,
                    "Help: Check if key is correct and not expired. Get a new key if needed.")
            end
        else
            showStatus('Key is invalid or expired', KEYCOLOR.ERROR, 3, false,
                "Help: Key might be expired or incorrect. Get a new key from our website.")
        end
        if body.valid == false and not (body.reason and string.find(string.lower(tostring(body.reason)), 'nonce')) then
            verifyGuard.Rejected[key] = verifyGuard.Last
        end
        return nil
    end

    if type(body.unlock) ~= 'string' or #body.unlock ~= 64 then
        showStatus('Session could not be verified. (NX-1000)', KEYCOLOR.ERROR, 4, false,
            "Help: Please close other scripts, rejoin the game and try again.")
        return nil
    end

    return { unlock = body.unlock, nonce = nonce, key = key, payload = body.payload, run_token = body.run_token, expiry = body.expiry, is_lifetime = body.is_lifetime, key_type = body.key_type, usage_count = body.usage_count, discord_username = body.discord_username }
end

local function formatScriptError(raw)
    local text = tostring(raw)
    if #text > 200 then
        text = strSub(text, 1, 200) .. '...'
    end
    return text
end

local function decryptAndRun(auth)
    local scriptKey

    if type(auth.session_key_hex) == 'string' then
        scriptKey = hexToBytes(auth.session_key_hex)
        if not scriptKey or #scriptKey ~= 32 then
            return false, 'Session error. Please try again. (NX-1003)'
        end
    else
        local unlockBytes = hexToBytes(auth.unlock)
        if not unlockBytes or #unlockBytes ~= 32 then
            return false, 'Session error. Please try again. (NX-1001)'
        end

        local mask = sha256Bytes(auth.nonce .. '|' .. hwid .. '|' .. auth.key)
        scriptKey = xorStrings(unlockBytes, mask)
        if #scriptKey ~= 32 then
            return false, 'Session error. Please try again. (NX-1002)'
        end
    end

    showStatus('Loading NEOX HUB...', KEYCOLOR.INFO, nil, true)

    if type(auth.payload) ~= 'string' or #auth.payload == 0 then
        return false, 'This game has not been migrated to the server yet. (NX-2003)'
    end

    local source
    if strSub(auth.payload, 1, 2) == '3:' then
        local decodedOk, decoded = pcall(decodeFastPayload, auth.payload, scriptKey)
        if not decodedOk or type(decoded) ~= 'string' or #decoded < 16 then
            return false, 'Failed to load. Please rejoin and try again. (NX-3003)'
        end
        source = decoded
    else
        local raw = base64Decode(auth.payload)
        if not raw or #raw < 24 then
            return false, 'Failed to load. Please rejoin and try again. (NX-2004)'
        end

        local plain = rc4(raw, scriptKey, 768)

        if strSub(plain, 1, 7) ~= 'NEOXP1|' or strSub(plain, 16, 16) ~= '|' then
            return false, 'Failed to load. Please rejoin and try again. (NX-3001)'
        end

        local checksum = strSub(plain, 8, 15)
        source = strSub(plain, 17)

        if #source < 16 then
            return false, 'Failed to load. Please rejoin and try again. (NX-3002)'
        end

        local actual = fnv1aHex(source)
        if actual ~= checksum then
            return false, 'Failed to load. Please rejoin and try again. (NX-3003)'
        end

        raw = nil
        plain = nil
    end
    showStatus('Loading NEOX HUB...', KEYCOLOR.SUCCESS, nil, true)
    local compiledOk, chunk, compileErr = pcall(compile, source, '=NEOX')
    source = nil
    auth.payload = nil
    if not compiledOk then
        return false, 'Script error: ' .. formatScriptError(chunk) .. ' (NX-4001)'
    end
    if type(chunk) ~= 'function' then
        return false, 'Script error: ' .. formatScriptError(compileErr or 'failed to compile') .. ' (NX-4002)'
    end

    pcall(function()
        if auth.key then
            env.NEOX_ACTIVE_KEY = auth.key
            env.NEOX_ACTIVE_HWID = hwid
            env.NEOX_KEY_EXPIRY = auth.expiry
            env.NEOX_KEY_IS_LIFETIME = auth.is_lifetime
            env.NEOX_KEY_TYPE = auth.key_type
            env.NEOX_KEY_USAGE_COUNT = auth.usage_count
            env.NEOX_KEY_DISCORD = auth.discord_username
        end
    end)

    if type(auth.run_token) == 'string' and #auth.run_token > 0 then
        env.__NEOX_RUN = auth.run_token
    end
    auth.run_token = nil
    local ranOk, ret = pcall(chunk)
    env.__NEOX_RUN = nil
    if not ranOk then
        return false, 'Script error: ' .. formatScriptError(ret) .. ' (NX-4003)'
    end

    local depth = 0
    while type(ret) == 'function' and depth < 5 do
        depth = depth + 1
        local innerOk, innerRet = pcall(ret)
        if not innerOk then
            return false, 'Script error: ' .. formatScriptError(innerRet) .. ' (NX-4004)'
        end
        ret = innerRet
    end

    local heartbeatId = (tonumber(env.__NEOX_HEARTBEAT_ID) or 0) + 1
    env.__NEOX_HEARTBEAT_ID = heartbeatId

    task.spawn(function()
        local function sendHeartbeat()
            local code = 0
            pcall(function()
                local response = requestWithTimeout({
                    Url = CONFIG.BASE_URL .. '/api/heartbeat',
                    Method = 'POST',
                    Headers = { ['Content-Type'] = 'application/json' },
                    Body = HttpService:JSONEncode({
                        key = auth.key,
                        hwid = hwid,
                        game_name = gameName,
                    }),
                }, 15)
                code = response and tonumber(response.StatusCode) or 0
            end)
            return code
        end
        local interval = 45
        local code = sendHeartbeat()
        while env.__NEOX_HEARTBEAT_ID == heartbeatId do
            if code == 401 or code == 403 or code == 410 then
                break
            end
            if code == 0 or code == 429 or code >= 500 then
                interval = math.min(interval * 2, 180)
            else
                interval = 45
            end
            task.wait(interval)
            if env.__NEOX_HEARTBEAT_ID ~= heartbeatId then
                break
            end
            code = sendHeartbeat()
        end
    end)

    return true, nil
end

local function runGameScript(auth)
    local ok, result, err = pcall(decryptAndRun, auth)
    if not ok then
        NEOX_CACHE.Clear('game')
        return false, 'Failed to load. Please rejoin and try again. (NX-5001)'
    end
    if not result then
        NEOX_CACHE.Clear('game')
    end
    return result, err
end

local function startVerifyCooldown()
    verifyGuard.Failures = verifyGuard.Failures + 1
    local delays = { 0, 3, 6, 10 }
    local seconds = delays[math.min(verifyGuard.Failures, #delays)]
    if seconds <= 0 then
        return
    end
    verifyGuard.Until = os.clock() + seconds
    verifyButton.TextTransparency = 0.4
    task.spawn(function()
        while os.clock() < verifyGuard.Until do
            verifyButton.Text = 'Try again in ' .. tostring(math.ceil(verifyGuard.Until - os.clock())) .. 's'
            task.wait(0.25)
        end
        verifyButton.Text = 'Verify'
        verifyButton.TextTransparency = 0
    end)
end

local function flashInputError()
    inputStroke.Color = KEYCOLOR.ERROR
    task.delay(2, function()
        if not keyInput:IsFocused() then
            createTween(inputStroke, { Color = KEYCOLOR.BORDER }):Play()
        end
    end)
end

local function handleVerification()
    if isProcessing then return end
    if os.clock() < verifyGuard.Until then return end

    tutorialText.Text = DEFAULT_TUTORIAL_TEXT
    tutorialText.TextColor3 = DEFAULT_TUTORIAL_COLOR

    local key = string.gsub(string.gsub(keyInput.Text, '^%s+', ''), '%s+$', '')
    keyInput.Text = key
    isProcessing = true
    setInputVisible(false)

    local auth, special = validateKey(key)
    if auth then
        local saved = writefile and saveKey(key)
        showStatus(auth.is_lifetime and 'Lifetime key verified' or 'Key verified', KEYCOLOR.SUCCESS, nil, false,
            saved and 'Your key is saved for next time.' or nil)
        task.wait(0.25)

        local ok, err = runGameScript(auth)
        if ok then
            cleanup()
            return
        end

        showStatus(err or 'Failed to load. Please try again. (NX-5000)', KEYCOLOR.ERROR, 5, false,
            "Help: Please rejoin the game and try again. Contact support if this continues.")
        sendNotification(CONFIG.HUB_NAME .. " - ERROR", err or 'Failed to load script', CONFIG.NOTIFICATION_DURATION.ERROR)
        task.wait(5)
        isProcessing = false
        setInputVisible(true)
    elseif special == 'not_redeemed' then
        isProcessing = false
    elseif special == 'paid_only' then
        isProcessing = false
    else
        if special ~= 'empty' then
            prefetchNonce()
        end
        task.wait(3)
        isProcessing = false
        setInputVisible(true)
        if special ~= 'empty' then
            flashInputError()
            startVerifyCooldown()
        end
    end
end

closeButton.MouseButton1Click:Connect(function()
    cleanup()
    sendNotification(CONFIG.HUB_NAME, 'Closed. Run the script again whenever you are ready.', CONFIG.NOTIFICATION_DURATION.SUCCESS)
end)

getKeyButton.MouseButton1Click:Connect(function()
    if isProcessing then return end
    setInputVisible(false)
    local clipboardOk = setclipboard ~= nil
    if setclipboard then
        setclipboard('https://neoxsoftworks.eu/key.html')
        showStatus('Key link copied to clipboard', KEYCOLOR.PRIMARY, 3, false, 'Open it in your browser, finish the steps, then paste your key here.')
    else
        showStatus('Clipboard not supported on this executor', KEYCOLOR.WARNING, 5, false, 'Open neoxsoftworks.eu/key.html in your browser.')
    end
    task.wait(clipboardOk and 3 or 5)
    setInputVisible(true)
end)

discordButton.MouseButton1Click:Connect(function()
    if isProcessing then return end
    setInputVisible(false)
    local clipboardOk = setclipboard ~= nil
    if setclipboard then
        setclipboard('https://neoxsoftworks.eu/discord')
        showStatus('Discord invite copied to clipboard', KEYCOLOR.DISCORD, 3, false, 'Paste it in your browser to join the server.')
    else
        showStatus('Clipboard not supported on this executor', KEYCOLOR.WARNING, 5, false, 'Open neoxsoftworks.eu/discord in your browser.')
    end
    task.wait(clipboardOk and 3 or 5)
    setInputVisible(true)
end)

buyButton.MouseButton1Click:Connect(function()
    if isProcessing then return end
    setInputVisible(false)
    local clipboardOk = setclipboard ~= nil
    if setclipboard then
        setclipboard('https://neoxsoftworks.eu/getneox.html')
        showStatus('Premium link copied to clipboard', KEYCOLOR.PREMIUM, 3, false, 'Open it in your browser to see the Premium plans.')
    else
        showStatus('Clipboard not supported on this executor', KEYCOLOR.WARNING, 5, false, 'Open neoxsoftworks.eu/getneox.html in your browser.')
    end
    task.wait(clipboardOk and 3 or 5)
    setInputVisible(true)
end)

verifyButton.MouseButton1Click:Connect(function()
    handleVerification()
end)

redeemCopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard('https://neoxsoftworks.eu/userportal')
        local original = redeemCopyBtn.Text
        redeemCopyBtn.Text = 'Copied!'
        task.wait(1.5)
        if redeemPromptFrame.Visible then
            redeemCopyBtn.Text = original
        end
    end
end)

redeemCheckBtn.MouseButton1Click:Connect(function()
    if not pendingRedeemKey or isProcessing then return end
    isProcessing = true
    redeemCheckBtn.Text = 'Checking...'

    local keyToCheck = pendingRedeemKey
    local auth, special = validateKey(keyToCheck)

    if auth then
        hideRedeemPrompt()
        if writefile and saveKey(keyToCheck) then end
        local ok, err = runGameScript(auth)
        if ok then
            cleanup()
            return
        end
        isProcessing = false
        setInputVisible(true)
        showStatus(err or 'Failed to load. Please try again. (NX-5000)', KEYCOLOR.ERROR, 5, false,
            "Help: Please rejoin the game and try again. Contact support if this continues.")
    elseif special == 'not_redeemed' then
        isProcessing = false
    else
        isProcessing = false
        hideRedeemPrompt()
        setInputVisible(true)
    end
end)

paidScriptDiscordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard('https://neoxsoftworks.eu/discord')
        local original = paidScriptDiscordBtn.Text
        paidScriptDiscordBtn.Text = 'Copied!'
        task.wait(1.5)
        if paidScriptPromptFrame.Visible then
            paidScriptDiscordBtn.Text = original
        end
    end
end)

paidScriptWebsiteBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard('https://shop.neoxsoftworks.eu')
        local original = paidScriptWebsiteBtn.Text
        paidScriptWebsiteBtn.Text = 'Copied!'
        task.wait(1.5)
        if paidScriptPromptFrame.Visible then
            paidScriptWebsiteBtn.Text = original
        end
    end
end)

paidScriptEnterKeyBtn.MouseButton1Click:Connect(function()
    hidePaidScriptPrompt()
    setInputVisible(true)
end)

local pasteWatch = { Last = '' }

keyInput:GetPropertyChangedSignal('Text'):Connect(function()
    local text = keyInput.Text
    local previous = pasteWatch.Last
    pasteWatch.Last = text
    if previous ~= '' or #text < 16 or isProcessing or not keyInput:IsFocused() then
        return
    end
    task.delay(0.5, function()
        if keyInput.Text == text and keyInput.Visible and not isProcessing and os.clock() >= verifyGuard.Until then
            keyInput:ReleaseFocus()
            handleVerification()
        end
    end)
end)

keyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and not isProcessing then
        handleVerification()
    end
end)

if UserInputService then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
            if keyGui and keyGui.Parent and not isProcessing then
                handleVerification()
            end
        end
    end)
end

if envTampered and CONFIG.STRICT_ENVIRONMENT then
    setInputVisible(false)
    isProcessing = true
    showStatus('Nice try.', KEYCOLOR.ERROR, nil, false,
        "Help: This script is protected and dumping it does not work. This attempt has been logged.")
    return
end

if envTampered then
    showStatus('Environment warning (NX-0101)', KEYCOLOR.WARNING, 5, false,
        "Help: Please close other scripts if verification fails.")
end

if resolvedKeyless then
    setHeading('No key needed')
    premiumRow.Visible = false
    setInputVisible(false)
    isProcessing = true
    task.spawn(function()
        showStatus('Loading NEOX HUB...', KEYCOLOR.INFO, nil, true)
        local fetchOk, payload, sessionKeyHex, runToken = false, nil, nil, nil
        for attempt = 1, 2 do
            if attempt == 2 then
                showStatus('Connection unstable, retrying...', KEYCOLOR.INFO, nil, true)
                task.wait(2)
            end
            pcall(function()
                local resp = requestWithTimeout({
                    Url = CONFIG.BASE_URL .. '/api/keyless-payload',
                    Method = 'POST',
                    Headers = { ['Content-Type'] = 'application/json' },
                    Body = HttpService:JSONEncode({
                        script_id = resolvedScriptId,
                        hwid = hwid,
                        roblox_username = Players.LocalPlayer and Players.LocalPlayer.Name or nil,
                        loader_version = CONFIG.LOADER_VERSION,
                    }),
                }, 60, 8, function()
                    showStatus('Still loading, your connection seems slow...', KEYCOLOR.INFO, nil, true)
                end)
                if resp and resp.StatusCode == 200 then
                    local decoded = HttpService:JSONDecode(resp.Body)
                    if decoded and decoded.success then
                        fetchOk = true
                        payload = decoded.payload
                        sessionKeyHex = decoded.session_key
                        runToken = decoded.run_token
                    end
                end
            end)
            if fetchOk then
                break
            end
        end

        if not fetchOk then
            NEOX_CACHE.Clear('game')
            showStatus('Failed to load. Please rejoin and try again. (NX-6001)', KEYCOLOR.ERROR, 5, false,
                "Help: Please rejoin the game and try again. Contact support if this continues.")
            return
        end

        local ok, err = runGameScript({ payload = payload, session_key_hex = sessionKeyHex, run_token = runToken })
        if ok then
            cleanup()
            return
        end
        showStatus(err or 'Failed to load. Please try again. (NX-6002)', KEYCOLOR.ERROR, 5, false,
            "Help: Please rejoin the game and try again. Contact support if this continues.")
    end)
    return
end

local savedKey = loadSavedKey()
if type(savedKey) == 'string' then
    savedKey = string.gsub(string.gsub(savedKey, '^%s+', ''), '%s+$', '')
end
if savedKey and savedKey ~= '' then
    setHeading('Welcome back')
    setInputVisible(false)
    isProcessing = true

    task.spawn(function()
        local auth, special = validateKey(savedKey)
        if auth then
            showStatus('Saved key verified', KEYCOLOR.SUCCESS, nil, false, 'Good to see you again, ' .. UI.DisplayName .. '.')
            task.wait(0.25)
            local ok, err = runGameScript(auth)
            if ok then
                cleanup()
                return
            end
            showStatus(err or 'Failed to load. Please try again. (NX-5000)', KEYCOLOR.ERROR, 5, false,
                "Help: Please rejoin the game and try again. Contact support if this continues.")
            task.wait(5)
            isProcessing = false
            setHeading('Key verification')
            setInputVisible(true)
        elseif special == 'not_redeemed' then
            isProcessing = false
        elseif special == 'paid_only' then
            isProcessing = false
        elseif special == 'network' then
            prefetchNonce()
            task.wait(3)
            setHeading('Key verification')
            tutorialText.Text = "Couldn't reach the server. Your saved key is filled in, press Verify to try again."
            tutorialText.TextColor3 = KEYCOLOR.WARNING
            keyInput.Text = savedKey
            isProcessing = false
            setInputVisible(true)
        else
            showStatus('Saved key expired. Enter new key.', KEYCOLOR.WARNING, 2, false,
                "Help: Your saved key is no longer valid. Get a new key from our website.")
            if verifyGuard.Rejected[savedKey] then
                pcall(function()
                    if writefile then
                        writefile(CONFIG.KEY_FILE, '')
                    end
                end)
            end
            setHeading('Key verification')
            prefetchNonce()
            if verifyGuard.LastReason and string.find(verifyGuard.LastReason, 'premium expired') then
                tutorialText.Text = 'Your Premium has expired. Renew within 2 days of it ending at neoxsoftworks.eu/getneox, or this key and all its data are deleted.'
            else
                tutorialText.Text = 'Saved key expired. Please enter a new key. Press Enter or click Verify to authenticate.'
            end
            tutorialText.TextColor3 = KEYCOLOR.WARNING
            keyInput.Text = ''
            task.wait(2)
            isProcessing = false
            setInputVisible(true)
        end
    end)
else
    prefetchNonce()
    task.spawn(function()
        local started = os.clock()
        while not earlyPaidCheck.Done and os.clock() - started < 8 do
            task.wait(0.1)
        end
        if earlyPaidCheck.paid_only and not isProcessing and keyInput.Visible then
            showPaidScriptPrompt(earlyPaidCheck.title or gameName)
        end
    end)
end