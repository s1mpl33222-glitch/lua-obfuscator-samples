
local _eeupewthbe = "68747470733a2f2f6c6578696e6f72312e6e65746c6966792e617070"


local function decodeHex(s)
    local out = {}
    for i = 1, #s, 2 do
        local n = tonumber(s:sub(i, i + 1), 16)
        if n then
            out[#out + 1] = string.char(n)
        end
    end
    return table.concat(out)
end


local _zkujmcdevo = "bab17a0801c101b6c7ba67696f375aaa0863f3f6fb237364a657b139cea2d1d8"

local _eodteeniii = "e4d4fb39e4fa80e2a72dfc2fdb81f9acd81958b427e36be24b393b62ad7875e0"

local _cs = _zkujmcdevo
local _cm = 0
local _cmax = 3
local _ca = true

local function _ewxlnnvqpb()

    local endpoint = decodeHex(_eeupewthbe)

    local url = endpoint .. "/api/checker?session=" .. _cs

    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and type(response) == "string" and response:find("ok") then
        _cm = 0
    else
        _cm = _cm + 1
        if _cm >= _cmax then
            _ca = false
            local player = game:GetService("Players").LocalPlayer
            if player then
                pcall(function()
                    player:Kick("Lexinor checker Failer to load | New Session")
                end)
            end
        end
    end

end

pcall(function()
    spawn(function()
        while _ca do
            wait(1)
            pcall(_ewxlnnvqpb)
        end
    end)
end)

local function _avwqlcexyq()

    local endpoint = decodeHex(_eeupewthbe)

    local url = endpoint .. "/api/x/l4TjDUYfIacHYgzQ4z5ZQr3K?session=" .. _zkujmcdevo .. "&token=" .. _eodteeniii

    local ok, response = pcall(function()
        return game:HttpGet(url)
    end)

    if not ok then
        return
    end

    if type(response) ~= "string" then
        return
    end

    local fn = loadstring(response)

    if fn then
        return fn()
    end

end

return _avwqlcexyq()
