--[[
  🛡️ KWARPEX SHIELD - PROTECTED SCRIPT
  SCRIPT: __
  ROBLOX & DELTA EXECUTOR COMPATIBLE
  ANTI-DUMP & ANTI-LEAK PROTECTION ACTIVE
--]]

local function _chk()
    if typeof == nil or game == nil or game.HttpGet == nil then
        error("[KWARPEX SHIELD]: هذا السكريبت محمي ولا يمكن تشغيله إلا داخل روبلوكس أو محاكي دلتا!")
        return false
    end
    return true
end

if not _chk() then return end

local _k = 210
local _p = {252,252,252,252,252,252,252,252}
local _b = {}

local _bxor = (bit32 and bit32.bxor) or function(a, b)
    local r, m = 0, 1
    while a > 0 or b > 0 do
        if (a % 2) ~= (b % 2) then r = r + m end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        m = m * 2
    end
    return r
end

for i = 1, #_p do
    table.insert(_b, string.char(_bxor(_p[i], _k)))
end

-- PURGE ENCRYPTED BUFFER & KEY IMMEDIATELY (Anti-Dump & Anti-Leak)
table.clear(_p)
_p = nil
_k = nil

local _src = table.concat(_b)
table.clear(_b)
_b = nil

local _fn, _err = (loadstring or load)(_src)
_src = nil -- WIPE DECRYPTED CODE STRING FROM MEMORY IMMEDIATELY

if not _fn then
    error("[KWARPEX ERROR]: " .. tostring(_err))
else
    -- Execute in a persistent Task thread so the script continues playing
    if task and task.spawn then
        task.spawn(_fn)
    else
        coroutine.wrap(_fn)()
    end
end
