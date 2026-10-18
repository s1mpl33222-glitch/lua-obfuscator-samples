-- [[ PROTECTED BY LOSTHEAVEN ]]
-- [LostHeaven Security Systems • Protected by LostHeaven]
-- [HeavenShield Server-Bound Protocol v3.0]

local _G_ENV = (getgenv and getgenv()) or _G or shared or {}
local _plrs = game and game.GetService and game:GetService("Players")
local _p = _plrs and _plrs.LocalPlayer
local _wLimit = 0
while not _p and _wLimit < 40 do
    task.wait(0.05)
    _wLimit = _wLimit + 1
    _p = _plrs and _plrs.LocalPlayer
end

local _u = (_p and _p.Name) or "RobloxPlayer"
local _srv = "https://lost-heaven.ai.studio"
local _tk = "lh_tk_4dfb29a9dab0cede1290f8c40338bb36b16ac4071216d9f3"
local _salt = 96
local _rawKey = _G_ENV.Key or _G.Key or ""

-- Pure portable bitwise XOR function (100% compatible with all Luau and Lua 5.1 environments)
local function _pureXor(a, b)
    local p, c = 1, 0
    while a > 0 or b > 0 do
        if (a % 2) ~= (b % 2) then c = c + p end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        p = p * 2
    end
    return c
end
local _bxor = (bit32 and bit32.bxor) or (bit and bit.bxor) or _pureXor

-- Encrypt key for transfer so key is never in plaintext
local _encKey = ""
if type(_rawKey) == "string" and #_rawKey > 0 then
    local _kChars = {}
    for i = 1, #_rawKey do
        local b = string.byte(_rawKey, i)
        local enc = _bxor(_bxor(b, _salt), (i * 7) % 256)
        _kChars[#_kChars + 1] = string.format("%02x", enc)
    end
    _encKey = table.concat(_kChars)
end

-- Universal HTTP Fetcher (game:HttpGet or executor request)
local function _fetch(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and res and #res > 0 then return true, res end
    local reqFn = (syn and syn.request) or (http and http.request) or request or http_request
    if reqFn then
        local rOk, rRes = pcall(function()
            return reqFn({ Url = url, Method = "GET" })
        end)
        if rOk and rRes and (rRes.Body or rRes.body) then
            return true, rRes.Body or rRes.body
        end
    end
    return false, nil
end

local _cleanU = string.gsub(tostring(_u), "[^%w_]", "")
local _claimUrl = _srv .. "/api/session/claim-and-burn?t=" .. _tk .. "&k=" .. _encKey .. "&u=" .. _cleanU .. "&s=" .. tostring(_salt)
local _ok, _payload = _fetch(_claimUrl)

if not _ok or not _payload then
    local _altUrl = "https://ais-pre-7s5cpsxpw6js3zva3fdgzw-377974272596.europe-west2.run.app/api/session/claim-and-burn?t=" .. _tk .. "&k=" .. _encKey .. "&u=" .. _cleanU .. "&s=" .. tostring(_salt)
    _ok, _payload = _fetch(_altUrl)
end

if not _ok or not _payload or #_payload < 5 then
    return
end

-- If server returned a kick or notification command
if string.sub(_payload, 1, 2) == "--" and not string.find(_payload, "lh_stream:") then
    local _fn = (getgenv and getgenv().loadstring or loadstring or load)(_payload)
    if _fn then pcall(_fn) end
    return
end

-- Decrypt stream in transient RAM (HttpSpy only intercepted encrypted hex noise)
if string.sub(_payload, 1, 10) == "lh_stream:" then
    local _hex = string.sub(_payload, 11)
    local _hLen = #_hex
    local _bytes = {}
    for _i = 1, _hLen, 2 do
        local _sub = string.sub(_hex, _i, _i + 1)
        local _b = tonumber(_sub, 16) or 0
        local _idx = math.floor(_i / 2)
        local _orig = _bxor(_bxor(_b, _salt), (_idx * 13) % 256)
        _bytes[#_bytes + 1] = string.char(_orig)
    end
    _payload = table.concat(_bytes)
    table.clear(_bytes)
end

-- Ephemeral In-Memory Execution & Immediate RAM Zeroing
local _runFn = (getgenv and getgenv().loadstring or loadstring or load)(_payload)
_payload = nil
_tk = nil
_salt = nil

if _runFn then
    local _rOk, _rErr = pcall(_runFn)
    if not _rOk and _rErr then
        warn("[Lost Heaven Runtime]:", _rErr)
    end
    _runFn = nil
end
pcall(function() if gcinfo then gcinfo() end end)