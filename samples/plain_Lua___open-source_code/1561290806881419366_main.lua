
local function __sdec__(b64, key)
    local alphabet='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    local decoded = {}
    local bits, value = 0, 0
    b64 = b64:gsub('[^%w%+%/]', '')
    for c in b64:gmatch('.') do
        local idx = alphabet:find(c, 1, true)
        if idx then
            value = (value * 64) + (idx - 1)
            bits = bits + 6
            if bits >= 8 then
                bits = bits - 8
                table.insert(decoded, math.floor(value / (2^bits)) % 256)
            end
        end
    end
    local out = {}
    for i, byte in ipairs(decoded) do
        out[i] = string.char((byte ~ key) % 256)
    end
    return table.concat(out)
end

local _aDQmpeKT=3676;local _SIqOrttJ=7111;if _aDQmpeKT>_SIqOrttJ then _aDQmpeKT=_SIqOrttJ end;






local _KdwWwAZE = __sdec__("or6+urnw5eWzpb+4566lp6ujpOSppac=",202)   
local _HnVdIkQM = (13+47)              

local _UOcIbRaK = game:GetService(__sdec__("XGBgZEdxZmJ9d3E=",20))
local _GXaagqnX = game:GetService(__sdec__("ADwxKTUiIw==",80))
local _fZRZPmLi = script_key or (getgenv and getgenv().script_key)






local _pyCcZEJM  = type
local _nAXYHsXN = pcall

local _HtSwkOSZ = (syn and syn.request) or (http and http.request)
    or http_request or request







local function _IcOHubfg(_RmvLfdNw)
    if _pyCcZEJM(_RmvLfdNw) ~= __sdec__("3c7V2M/S1NU=",187) then return true end
    local _zmwKsBvA, _QZHmZoPH = _nAXYHsXN(function() return debug.getinfo(_RmvLfdNw) end)
    if _zmwKsBvA and _QZHmZoPH then
        if _QZHmZoPH.source and _QZHmZoPH.source ~= __sdec__("i5ON",208) and _QZHmZoPH.what == __sdec__("7dTA",161) then
            return true  
        end
        if _QZHmZoPH.nups and _QZHmZoPH.nups > 0 and _QZHmZoPH.what == __sdec__("LA==",111) then
            
            return true
        end
    end
    return false
end


local function _nuzKSRvV()
    local _DabLzfDX = {}
    local _SjIrmDYU = {
        [__sdec__("0tTY0Jv9wcHF8tDB",181)]        = game.HttpGet,
        [__sdec__("HxkVHVYwDAwIKBcLDA==",120)]       = game.HttpPost,
        [__sdec__("GB4SGlE4GgssGg0JFhwa",127)]     = game.GetService,
        [__sdec__("u7i2s6Sjpb65sA==",215)]          = loadstring,
        [__sdec__("ES0tKQo8Ky8wOjx3EwoWFxw3OjY9PA==",89)] = _UOcIbRaK.JSONEncode,
        [__sdec__("d0tLT2xaTUlWXFoRdWxwcXtaXFBbWg==",63)] = _UOcIbRaK.JSONDecode,
        [__sdec__("BTk5PR4oPzskLihjCig5DD40Iy4=",77)]   = _UOcIbRaK.GetAsync,
        [__sdec__("eUVFQWJUQ0dYUlQfYV5CRXBCSF9S",49)]  = _UOcIbRaK.PostAsync,
        [__sdec__("FBUSBRdeFxUEGR4WHw==",112)]        = debug and debug.getinfo,
        [__sdec__("PTw7LD53LSs4Ojw7ODoy",89)]      = debug and debug.traceback,
    }
    for name, _RmvLfdNw in pairs(_SjIrmDYU) do
        if _IcOHubfg(_RmvLfdNw) then
            table.insert(_DabLzfDX, name)
        end
    end
    
    
    
    local _HqzoJGEF = { __sdec__("AwQEAA0eBQgfAgQF",107), __sdec__("Nj0vOzs0NystKj0=",88), __sdec__("Q1RBXVBSVFJdXkJEQ1Q=",49),
        __sdec__("qa6uqqyktaCspLWprqU=",193), __sdec__("X11MSllPVV1MWUxZWlRd",56), __sdec__("QVdGQFdTVl1cXks=",50) }
    local _NRjkltNh = getgenv and getgenv() or _G
    for _, name in ipairs(_HqzoJGEF) do
        if _pyCcZEJM(_NRjkltNh[name]) == __sdec__("q7ijrrmkoqM=",205) then
            table.insert(_DabLzfDX, __sdec__("UFdXU0hKUVUC",56) .. name)
        end
    end
    
    if _pyCcZEJM(_G) ~= __sdec__("HQgLBQw=",105) or _pyCcZEJM(getgenv) ~= __sdec__("JjUuIzQpLy4=",64) and getgenv ~= nil then
        table.insert(_DabLzfDX, __sdec__("TkVd",43))
    end
    if _pyCcZEJM(tostring) ~= __sdec__("gJOIhZKPiYg=",230) or _pyCcZEJM(tonumber) ~= __sdec__("S1hDTllEQkM=",45) then
        table.insert(_DabLzfDX, __sdec__("LiI/KA==",77))
    end
    return _DabLzfDX
end

local _EvDChqNZ = _nuzKSRvV()
if #_EvDChqNZ > 0 then
    
    
    local _QDJzrVHw = false
    for _, f in ipairs(_EvDChqNZ) do
        if f:sub(1, (9+0)) ~= __sdec__("RkFBRV5cR0MU",46) and f ~= __sdec__("pK+3",193) and f ~= __sdec__("QExRRg==",35) then
            _QDJzrVHw = true
        end
    end
    if _QDJzrVHw then
        
        pcall(_HtSwkOSZ, {
            Url = _KdwWwAZE .. __sdec__("XgUQHAEUAw==",113),
            Method = __sdec__("SlVJTg==",26),
            Headers = { [__sdec__("pIiJk4KJk8qznpeC",231)] = __sdec__("sqOjv7qwsqe6vL38uaC8vQ==",211) },
            Body = _UOcIbRaK:JSONEncode({ _fZRZPmLi = _fZRZPmLi, _YFUDjpVy = _kSktgpTQ(), userid = __sdec__("",159), reason = table.concat(_EvDChqNZ, __sdec__("/w==",211)) }),
        })
        return warn(__sdec__("Mj4BAB0MBQAaHTRJPQgEGQwbSQ0MHQwKHQwNSUE=",105) .. table.concat(_EvDChqNZ, __sdec__("tro=",154))
            .. __sdec__("oailqPrt7v374ebvqPznqOTn6eym",136))
    else
        warn(__sdec__("Z2tUVUhZUFVPSGEcb0lPTFVfVVNJTxxZUkpVTlNSUVlSSAYc",60) .. table.concat(_EvDChqNZ, __sdec__("8v4=",222)))
    end
end

local function _kSktgpTQ()
    local _qcReqgwz, _FynAEbfF = _nAXYHsXN(function()
        return game:GetService(__sdec__("XGx2T2BvYnd6Z219XWt8eGdtaw==",14)):GetClientId()
    end)
    return _qcReqgwz and _FynAEbfF or __sdec__("wNve29rC2w==",181)
end

if _pyCcZEJM(_fZRZPmLi) ~= __sdec__("ub64o6St",202) or #_fZRZPmLi == 0 then
    local _mzjJXhmS = game:GetService(__sdec__("MAwBGQUSEw==",96)).LocalPlayer
    if _mzjJXhmS then _nAXYHsXN(function() _mzjJXhmS:Kick(__sdec__("DC1iKSc7YjIwLTQrJicmbA==",66)) end) end
    return warn(__sdec__("o6+QkYydlJGLjKXYtpfYk52B2IiKl46RnJ2c1g==",248))
end
if not _HtSwkOSZ then
    return warn(__sdec__("09/g4fzt5OH7/NWowNzc2Kj67fn97fv8+6jm5/yo+/34+Of6/O3sqODt+u2m",136))
end

local _egNArrTH = game:GetService(__sdec__("CjY7Iz8oKQ==",90)).LocalPlayer
local _UKWjyVvJ = _egNArrTH and tostring(_egNArrTH.UserId) or __sdec__("",230)
local _GkjqsWOA = (getgenv and getgenv().__WL_SCRIPT_ID) or __sdec__("",49)

local _jbZRQPMm = (typeof and typeof(bit32) == __sdec__("EQQHCQA=",101) and bit32) or (typeof and typeof(bit) == __sdec__("Kj88Mjs=",94) and bit)
local function _fwkgtNWc(a, b)
    if _jbZRQPMm and _jbZRQPMm._fwkgtNWc then return _jbZRQPMm._fwkgtNWc(a, b) end
    local _GnljXvrk, _UDsWWwOC = 0, 1
    for i = 0, (2+5) do
        local _cJdDxufa = math.floor(a / ((1+1) ^ i)) % (2+0)
        local _JUKtgcNU = math.floor(b / ((2+0) ^ i)) % (2+0)
        if _cJdDxufa ~= _JUKtgcNU then _GnljXvrk = _GnljXvrk + _UDsWWwOC end
        _UDsWWwOC = _UDsWWwOC * (2+0)
    end
    return _GnljXvrk
end

local function _EzrUSebm(h)
    local _dpDSeYVz = {}
    for i = 1, #h, (1+1) do
        _dpDSeYVz[#_dpDSeYVz + 1] = string.char(tonumber(h:sub(i, i + 1), (2+14)) or 0)
    end
    return table.concat(_dpDSeYVz)
end

local function _WkxRskmq(data, _fZRZPmLi)
    local _dpDSeYVz = {}
    for i = 1, #data do
        _dpDSeYVz[i] = string.char(_fwkgtNWc(data:byte(i), _fZRZPmLi:byte((i - 1) % #_fZRZPmLi + 1)))
    end
    return table.concat(_dpDSeYVz)
end

local _qcReqgwz, _oSdSxbnv = pcall(_HtSwkOSZ, {
    Url = _KdwWwAZE .. __sdec__("nN/c0tc=",179),
    Method = __sdec__("PiE9Og==",110),
    Headers = { [__sdec__("m7e2rL22rPWMoai9",216)] = __sdec__("mYiIlJGbmYyRl5bXkouXlg==",248) },
    Body = _UOcIbRaK:JSONEncode({ _fZRZPmLi = _fZRZPmLi, _YFUDjpVy = _kSktgpTQ(), userid = _UKWjyVvJ, script_id = _GkjqsWOA }),
})

if not _qcReqgwz or not _oSdSxbnv then
    return warn(__sdec__("YW1SU05fVlNJTmcaeVVPVl4aVFVOGkhfW1lSGklfSExfSBQ=",58))
end

if _oSdSxbnv.StatusCode ~= (82+118) then
    local _ZiKKAkim = {}
    pcall(function() _ZiKKAkim = _UOcIbRaK:JSONDecode(_oSdSxbnv.Body) end)
    return warn(__sdec__("lZmmp7qroqe9upPuiqugp6uq9O4=",206) .. tostring(_ZiKKAkim.error or _oSdSxbnv.StatusCode))
end



local _ILKuHHiZ = {}
pcall(function() _ILKuHHiZ = _UOcIbRaK:JSONDecode(_oSdSxbnv.Body) end)
if _pyCcZEJM(_ILKuHHiZ._ILKuHHiZ) ~= __sdec__("QkVDWF9W",49) or _pyCcZEJM(_ILKuHHiZ._fZRZPmLi) ~= __sdec__("mJ+ZgoWM",235) then
    return warn(__sdec__("NzsEBRgJAAUfGDFMLg0ITB4JHxwDAh8JTAoeAwFMHwkeGgkeQg==",108))
end
local _wApKOtSb = _WkxRskmq(_EzrUSebm(_ILKuHHiZ._ILKuHHiZ), _ILKuHHiZ._fZRZPmLi)
local _RmvLfdNw, _huMMvyAj = loadstring(_wApKOtSb)
if not _RmvLfdNw then
    return warn(__sdec__("39Ps7fDh6O338Nmk1+f27fTwpOH29uv2vqQ=",132) .. tostring(_huMMvyAj))
end







_G.__WL_REVOKED = false

local function _SHvJVOkW()
    local _YFUDjpVy = _kSktgpTQ()
    local _aJvNScPp = (typeof and typeof(task) == __sdec__("oLW2uLE=",212) and task.spawn) or spawn
    _aJvNScPp(function()
        while true do
            if task and task.wait then task.wait(_HnVdIkQM) else wait(_HnVdIkQM) end
            local _KrnFLGUm, _gxaaxtuQ = _nAXYHsXN(_HtSwkOSZ, {
                Url = _KdwWwAZE .. __sdec__("fjk0MCMlMzQwJQ==",81),
                Method = __sdec__("a3Robw==",59),
                Headers = { [__sdec__("wu7v9eTv9azV+PHk",129)] = __sdec__("Kzo6JiMpKz4jJSRlIDklJA==",74) },
                Body = _UOcIbRaK:JSONEncode({ _fZRZPmLi = _fZRZPmLi, _YFUDjpVy = _YFUDjpVy, userid = _UKWjyVvJ }),
            })
            
            
            local _xrNwjngf = _nuzKSRvV()
            local _gxNWhBSN = false
            for _, f in ipairs(_xrNwjngf) do
                if f:sub(1, (4+5)) ~= __sdec__("+f7++uHj+Pyr",145) and f ~= __sdec__("19zE",178) and f ~= __sdec__("VFhFUg==",55) then
                    _gxNWhBSN = true
                end
            end
            if _gxNWhBSN then
                _G.__WL_REVOKED = true
                pcall(_HtSwkOSZ, {
                    Url = _KdwWwAZE .. __sdec__("XQYTHwIXAA==",114),
                    Method = __sdec__("BRoGAQ==",85),
                    Headers = { [__sdec__("4s7P1cTP1Yz12NHE",161)] = __sdec__("UUBAXFlTUURZX14fWkNfXg==",48) },
                    Body = _UOcIbRaK:JSONEncode({ _fZRZPmLi = _fZRZPmLi, _YFUDjpVy = _YFUDjpVy, userid = _UKWjyVvJ, reason = table.concat(_xrNwjngf, __sdec__("Hw==",51)) }),
                })
                warn(__sdec__("dHhHRltKQ0ZcW3IPe05CX0pdD0tKW0pMW0pLD19AXFsCQ0BOSw8H",47) .. table.concat(_xrNwjngf, __sdec__("npI=",178)) .. __sdec__("GRAdEENEX0BAWV5XHg==",48))
                local _egNArrTH = _GXaagqnX.LocalPlayer
                if _egNArrTH then _nAXYHsXN(function() _egNArrTH:Kick(__sdec__("rZiUiZyL2Z2cjZyajZyd1w==",249)) end) end
                break
            end
            if not _KrnFLGUm or not _gxaaxtuQ or _gxaaxtuQ.StatusCode ~= (137+63) then
                _G.__WL_REVOKED = true
                warn(__sdec__("bWFeX0JTWl9FQmsWZVNFRV9ZWBZEU0BZXVNSFllEFkVTREBTRBZDWERTV1VeV1RaUxYbFkVCWUZGX1hRGA==",54))
                local _egNArrTH = _GXaagqnX.LocalPlayer
                if _egNArrTH then
                    
                    
                    _nAXYHsXN(function() _egNArrTH:Kick(__sdec__("FCI0NC4oKWciKSMiI2k=",71)) end)
                end
                break
            end
        end
    end)
end

_SHvJVOkW()
_RmvLfdNw()
