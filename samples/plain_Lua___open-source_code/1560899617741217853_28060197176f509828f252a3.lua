-- ═══════════════════════════════════════════════════════════
-- LEXINOR V1.3 PROTECTED
-- This is Lua code protection by LEXINOR v3.5
-- Unauthorized modification or extraction is prohibited
-- ═══════════════════════════════════════════════════════════

local _ikggwxariz = "68747470733a2f2f6c6578696e6f72312e6e65746c6966792e617070"

local function decodeHex(s)
    local out = {}
    for i = 1, #s, 2 do
        local n = tonumber(s:sub(i, i + 1), 16)
        if n then out[#out + 1] = string.char(n) end
    end
    return table.concat(out)
end

local _uwvxvthdqp = "af7a1e37529560ad6b5f06b635db158db59705243b7c592ecec3223fc66e7e9c"
local _tiljinigvu = "9c67b4b33c1e7d4bfdf02b53afc06fc26406754e7f2781daa3ce6cc16d47335b"

local _hbSession = _uwvxvthdqp
local _hbMiss = 0
local _hbMax = 3
local _hbAlive = true

local function _jkbthndtjp()
    local endpoint = decodeHex(_ikggwxariz)
    local url = endpoint .. "/api/heartbeat?session=" .. _hbSession
    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(response) == "string" and response:find("ok") then
        _hbMiss = 0
    else
        _hbMiss = _hbMiss + 1
        if _hbMiss >= _hbMax then
            _hbAlive = false
            local player = game:GetService("Players").LocalPlayer
            if player then
                pcall(function()
                    player:Kick("LEXINOR v1.3: Session Expires, Recheck")
                end)
            end
        end
    end
end

pcall(function()
    spawn(function()
        while _hbAlive do
            wait(15)
            pcall(_jkbthndtjp)
        end
    end)
end)

local function _sjjwasyzsx()
    local endpoint = decodeHex(_ikggwxariz)
    local url = endpoint .. "/api/x/3cqWX7q1vD5Z5mxv5FiGajom?session=" .. _uwvxvthdqp .. "&token=" .. _tiljinigvu
    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then return end
    if type(response) ~= "string" then return end
    local fn = loadstring(response)
    if fn then return fn() end
end

return _sjjwasyzsx()
