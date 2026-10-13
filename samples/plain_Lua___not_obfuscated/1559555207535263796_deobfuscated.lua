local _0x3e1a = (function(_0x9f2b)
    local _0x4c8d = {}
    for _0x2f1e = 1, #_0x9f2b do
        _0x4c8d[_0x2f1e] = string.char(string.byte(_0x9f2b, _0x2f1e) + 1)
    end
    return table.concat(_0x4c8d)
end)

local _0x8a1b = getfenv()[("\x77\x61\x72\x6b\x73\x70\x61\x63\x65"):gsub(".", function(c) return string.char(c:byte()) end)]
local _0x5f2c = _0x8a1b:FindFirstChild((("QNBJOUV").gsub(".", function(v) return string.char(v:byte() - 1) end))) or _G.workspace

local function _0x9c3d(_0x1e4f)
    for _, _0x7b2a in ipairs(_0x1e4f:GetChildren()) do
        local _0x6d8e = string.lower(_0x7b2a.Name)
        local _0x4a1f = (string.find(_0x6d8e, (("bmpuiu").gsub(".", function(v) return string.char(v:byte() - 1) end))) or string.find(_0x6d8e, (("qmbou").gsub(".", function(v) return string.char(v:byte() - 1) end))))
        local _0x3b2c = (_0x7b2a:IsA((("BbtfQbsu").gsub(".", function(v) return string.char(v:byte() - 1) end))) or _0x7b2a:IsA((("Npefm").gsub(".", function(v) return string.char(v:byte() - 1) end))))
        local _0x9f1e = not _0x7b2a:FindFirstChildOfClass((("Ijhimjhiu").gsub(".", function(v) return string.char(v:byte() - 1) end)))
        
        if _0x4a1f and _0x3b2c and _0x9f1e then
            local _0x2c4d = Instance.new((("Ijhimjhiu").gsub(".", function(v) return string.char(v:byte() - 1) end)))
            _0x2c4d.Name = (("DmpuiQmbouIjhiimjhiu").gsub(".", function(v) return string.char(v:byte() - 1) end))
            _0x2c4d.Adornee = _0x7b2a
            if string.find(_0x6d8e, (("bmpuiu").gsub(".", function(v) return string.char(v:byte() - 1) end))) then
                _0x2c4d.FillColor = Color3.fromRGB(255, 100, 255)
                _0x2c4d.OutlineColor = Color3.fromRGB(255, 255, 255)
            end
            _0x2c4d.FillTransparency = 0.5
            _0x2c4d.OutlineTransparency = 0
            _0x2c4d.Parent = _0x7b2a
        end
        _0x9c3d(_0x7b2a)
    end
end

_0x9c3d(_0x5f2c)