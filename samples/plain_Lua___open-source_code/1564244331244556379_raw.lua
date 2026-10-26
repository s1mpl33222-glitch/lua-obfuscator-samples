-- APEX HUB Loader v10 (Analytics Edition)
-- Protected by APEX Security System
local _key = "v97DkUzq6xrGfty9"
local _hex = "1a56562018210818581f5a2007191c033e4d43342c300e591410063316074316594b5633453213055e0d103215110b5a195743210521541259155d290101005c185e5e25093c14190448437657591d5c144c506b3f3009051915132e085b1057125c4f6a07201b531f515a6e"

local _byte = string.byte
local _char = string.char
local _tonumber = tonumber
local _bxor = bit32 and bit32.bxor or bit and bit.bxor
local _keyLen = #_key
local _idx = 1

local _code = _hex:gsub("..", function(cc)
    local b = _tonumber(cc, 16)
    local kb = _byte(_key, (_idx - 1) % _keyLen + 1)
    _idx = _idx + 1
    return _char(_bxor(b, kb))
end)

_hex = nil
_key = nil

assert(type(_code) == "string", "APEX Error: Decoded data corrupted")
assert(#_code > 0, "APEX Error: Decoded script content is empty")

local _f, _e = loadstring(_code)
if not _f then
    warn("=== APEX HUB CLIENT DEBUG ===")
    warn("Received Payload Size: " .. #_code .. " bytes")
    error("APEX Hub Compile Error: " .. tostring(_e))
end
_code = nil
_f()
_f = nil
collectgarbage("collect")