---@source Filе Deоbfuѕсаtеd Uѕіng LеаkD
---@see https://discord.gg/hkQAMzyGum

local function v1(v3, v4, v5, v6, v7, v8, v13, ...)
    local v9 = #v4
    local v10 = v3
    local v11 = 0
    local v12 = v9 - 1
    if 0 <= v12 then
        while true do
            v10[v4[(100183 * v11 + 33313) % v9 + 1]] = v10[v11 + 1]
            v11 = v11 + 1
            if v11 > v12 then
                break
            end
        end
    end
    v11 = v3[v5]
    v11 = table.pack(v11(v3, v6, v7, v8, v13, ...))
    return table.unpack(v11, 1, v11.n)
end
local function v2(...)
    return {[1] = {...}, [2] = select("#", ...)}
end
local function _w5(v3)
end
(function()
    local function v3(v4, v5, v6)
        if v5 > v6 then
            return
        end
        return v4[v5], v3(v4, v5 + 1, v6)
    end
    return function(v4)
        return v3(v4[1], 1, v4[2])
    end
end)()
local function _w7(v3, v4, v5, v6, v7)
    v3.G[v7] = bit32.band(bit32.band(4294967295, bit32.band(4294967295, bit32.bxor(v5, 23655) * v6)), bit32.band(4294967295, bit32.bxor(v5, 23655) * v6)) + -bit32.band(v6 * bit32.bxor(v5, 23655), 4294967295) + bit32.bnot(bit32.bor(bit32.bnot(bit32.band(bit32.bxor(v5, 23655) * v6, 4294967295)), bit32.bnot(v4)))
    return v3.G[v7]
end
local function _w8(v3, v4, v5, v6, v7)
    v3.G[v7] = -bit32.bxor(bit32.band(bit32.bxor(v4, 48378), 4294967295), bit32.band(bit32.bxor(v6, 48779), bit32.bxor(v4, 48378))) + (bit32.band(bit32.bxor(v4, 48378), v5) + bit32.bxor(v4, 48378) + bit32.bxor(bit32.bor(bit32.bxor(v4, 48378), bit32.bxor(v6, 48779)), bit32.bxor(v4, 48378)) + (bit32.bor(bit32.band(bit32.bxor(v4, 48378), 65535), bit32.band(65535, bit32.bxor(v4, 48378))) * bit32.band(bit32.band(65535, bit32.bxor(v4, 48378)), bit32.band(65535, bit32.bxor(v4, 48378))) + bit32.band(bit32.bnot(bit32.band(65535, bit32.bxor(v4, 48378))), bit32.band(65535, bit32.bxor(v4, 48378))) * bit32.band(bit32.bnot(bit32.band(bit32.bxor(v4, 48378), 65535)), bit32.band(65535, bit32.bxor(v4, 48378))) - bit32.band(bit32.bxor(v4, 48378), 65535) * bit32.band(65535, bit32.bxor(v4, 48378))))
    return v3.G[v7]
end
local function _w9(v3, v4, v5, v6, v7, ...)
    return v3:k()(v4, v5, v6, v7, ...)
end
local function _w10(v3, v4, v5, v6)
    v3.G[v6] = -3 * bit32.band(bit32.band(v4, v4), bit32.bnot(v5)) + (v4 + (bit32.bnot(bit32.bnot(v4)) + (bit32.band(bit32.band(65535, v5), bit32.bnot(bit32.band(65535, v5))) * bit32.band(bit32.band(65535, v5), bit32.bnot(bit32.band(v5, 65535))) + bit32.band(bit32.band(65535, v5), bit32.band(v5, 65535)) * bit32.bor(bit32.band(65535, v5), bit32.band(65535, v5)) - bit32.band(65535, v5) * bit32.band(65535, v5) + (-v5 + bit32.bnot(bit32.band(v4, v5))) + -bit32.bxor(bit32.bxor(4294967295, v5), v4)) + bit32.bnot(bit32.band(bit32.bnot(v5), bit32.bnot(v4)))))
    return v3.G[v6]
end
local function _w11(v3)
end
local function _w14(v3, v4, v5, v6, v7)
    v3.G[v7] = -bit32.bnot(bit32.bnot(v6)) + bit32.bnot(bit32.bor(bit32.bnot(bit32.band(bit32.bxor(v5, 26968), v4)), bit32.bnot(v6))) + (bit32.band(bit32.bnot(bit32.band(bit32.bxor(v5, 26968), 65535)), bit32.band(v4, 65535)) * bit32.band(bit32.bnot(bit32.band(v4, 65535)), bit32.band(bit32.bxor(v5, 26968), 65535)) + bit32.bor(bit32.band(65535, v4), bit32.band(bit32.bxor(v5, 26968), 65535)) * bit32.band(bit32.band(65535, bit32.bxor(v5, 26968)), bit32.band(v4, 65535)) - bit32.band(bit32.bxor(v5, 26968), 65535) * bit32.band(v4, 65535)) + v6
    return v3.G[v7]
end
v1({"J", "c", "H", "G", "a", "K", "I", "L", "d", "k", "l", "b"}, "L", ...)

-- https://discord.gg/hkQAMzyGum
