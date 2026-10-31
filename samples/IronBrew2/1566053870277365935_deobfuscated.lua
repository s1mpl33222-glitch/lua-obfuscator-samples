local t1 = {
    ServiceId = 33510,
    PlatoSecret = "d3c64560-0c8f-4dce-925b-d7865cfce423",
    Secret = "dexahub123",
    MainScriptURL = "https://raw.githubusercontent.com/NihalIsDumb/dexahub-mm2-panel/refs/heads/main/obf_AlhmT78gl76057bWX5dRbyvHAP9rdUxY91BuUTN3FRydDpxk86WcyR6eZXnZ09e2.lua",
    ShowDiscord = false,
    DiscordURL = "https://discord.gg/kT55J724BK",
    ShowInstagram = false,
    InstagramURL = "https://www.instagram.com/oyb0i/",
    ShowYoutube = false,
    YoutubeURL = "https://www.youtube.com/channel/UCAlXXV1Hbvf7WbfXARuVtiQ",
    KeyFileName = "Mykey.txt",
    OldGuiName = "anything",
    MainGuiName = "anything",
    HubName = "Dexa Hub (MM2 Panel)",
    HubDescription = "Key System",
}
local n1 = 4294967296
local v3 = n1 - 1
local function v4(p1, p2)
    local n2 = 0
    local n3 = 1
    while p1 ~= 0 or p2 ~= 0 do
        n2 = n2 + (p1 % 2 + p2 % 2) % 2 * n3
        p1 = math.floor(p1 / 2)
        p2 = math.floor(p2 / 2)
        n3 = n3 * 2
    end
    return n2 % n1
end
local function v7(p3, p4, p5, ...)
    if not p4 then
        return not p3 and 0 or p3 % n1
    end
    local v8 = v4(p3 % n1, p4 % n1)
    if not p5 then
        return v8
    end
    v8 = v7(v8, p5, ...)
    return v8
end
local function v9(p6, p7, p8, ...)
    if not p7 then
        if p6 then
            return p6 % n1
        else
            return v3
        end
    end
    local v10 = p6 % n1
    local v11 = p7 % n1
    local v12 = (v10 + v11 - v4(v10, v11)) / 2
    if not p8 then
        return v12
    end
    v12 = v9(v12, p8, ...)
    return v12
end
local function v13(p9)
    return v3 - p9
end
local function v14(p10, p11)
    if p11 < 0 then
        return lshift(p10, -p11)
    else
        return math.floor(p10 % 4294967296 / 2 ^ p11)
    end
end
local function v15(p12, p13)
    return (p13 > 31 or p13 < -31) and 0 or v14(p12 % n1, p13)
end
local function v16(p14, p15)
    if p15 < 0 then
        return v15(p14, -p15)
    else
        return p14 * 2 ^ p15 % 4294967296
    end
end
local function v17(p16, p17)
    local v18 = p16 % n1
    local v19 = p17 % 32
    local v20 = v9(v18, 2 ^ v19 - 1)
    return v15(v18, v19) + v16(v20, 32 - v19)
end
local t2 = {
    1116352408,
    1899447441,
    3049323471,
    3921009573,
    961987163,
    1508970993,
    2453635748,
    2870763221,
    3624381080,
    310598401,
    607225278,
    1426881987,
    1925078388,
    2162078206,
    2614888103,
    3248222580,
    3835390401,
    4022224774,
    264347078,
    604807628,
    770255983,
    1249150122,
    1555081692,
    1996064986,
    2554220882,
    2821834349,
    2952996808,
    3210313671,
    3336571891,
    3584528711,
    113926993,
    338241895,
    666307205,
    773529912,
    1294757372,
    1396182291,
    1695183700,
    1986661051,
    2177026350,
    2456956037,
    2730485921,
    2820302411,
    3259730800,
    3345764771,
    3516065817,
    3600352804,
    4094571909,
    275423344,
    430227734,
    506948616,
    659060556,
    883997877,
    958139571,
    1322822218,
    1537002063,
    1747873779,
    1955562222,
    2024104815,
    2227730452,
    2361852424,
    2428436474,
    2756734187,
    3204031479,
    3329325298,
}
local function v22(p18)
    return string.gsub(p18, ".", function(p19)
        return string.format("%02x", string.byte(p19))
    end)
end
local function v23(p20, p21)
    local n4 = 1
    local s1 = ""
    for _ = 1, p21, n4 do
        local v27 = p20 % 256
        s1 = string.char(v27) .. s1
        p20 = (p20 - v27) / 256
        local _ = p21
        local _ = n4
    end
    return s1
end
local function v30(p22, p23)
    local v31 = p23 + 3
    local n5 = 1
    local n6 = 0
    for i = p23, v31, n5 do
        n6 = n6 * 256 + string.byte(p22, i)
        local _ = v31
        local _ = n5
    end
    return n6
end
local function v37(p24, p25)
    local v38 = 64 - (p25 + 9) % 64
    local v39 = v23(8 * p25, 8)
    local v40 = p24 .. "\128" .. string.rep("\000", v38) .. v39
    assert(#v40 % 64 == 0)
    return v40
end
local function v41(p26)
    p26[1] = 1779033703
    p26[2] = 3144134277
    p26[3] = 1013904242
    p26[4] = 2773480762
    p26[5] = 1359893119
    p26[6] = 2600822924
    p26[7] = 528734635
    p26[8] = 1541459225
    return p26
end
local function v42(p27, p28, p29)
    local n7 = 16
    local n8 = 1
    local t3 = {}
    for i = 1, n7, n8 do
        t3[i] = v30(p27, p28 + (i - 1) * 4)
        local _ = n7
        local _ = n8
    end
    local n9 = 64
    local n10 = 1
    for i = 17, n9, n10 do
        local v52 = t3[i - 15]
        local v53 = v7(v17(v52, 7), v17(v52, 18), v15(v52, 3))
        local v54 = t3[i - 2]
        t3[i] = (t3[i - 16] + v53 + t3[i - 7] + v7(v17(v54, 17), v17(v54, 19), v15(v54, 10))) % n1
        local _ = n9
        local _ = n10
    end
    local v57 = p29[1]
    local v58 = p29[2]
    local v59 = p29[3]
    local v60 = p29[4]
    local v61 = p29[5]
    local v62 = p29[6]
    local v63 = p29[7]
    local v64 = p29[8]
    local n11 = 64
    local n12 = 1
    for i = 1, n11, n12 do
        local v68 = (v7(v17(v57, 2), v17(v57, 13), v17(v57, 22)) + v7(v9(v57, v58), v9(v57, v59), v9(v58, v59))) % n1
        local v69 = v7(v17(v61, 6), v17(v61, 11), v17(v61, 25))
        local v70 = v7(v9(v61, v62), v9(v13(v61), v63))
        local v71 = (v64 + v69 + v70 + t2[i] + t3[i]) % n1
        local v72 = (v60 + v71) % n1
        local v73 = (v71 + v68) % n1
        v64 = v63
        v63 = v62
        v62 = v61
        v61 = v72
        v60 = v59
        v59 = v58
        v58 = v57
        v57 = v73
        local _ = n11
        local _ = n12
    end
    p29[1] = (p29[1] + v57) % n1
    p29[2] = (p29[2] + v58) % n1
    p29[3] = (p29[3] + v59) % n1
    p29[4] = (p29[4] + v60) % n1
    p29[5] = (p29[5] + v61) % n1
    p29[6] = (p29[6] + v62) % n1
    p29[7] = (p29[7] + v63) % n1
    p29[8] = (p29[8] + v64) % n1
end
local function v76(p30)
    local v77 = v37(p30, #p30)
    local v78 = v41({})
    local v79 = #v77
    local n13 = 64
    for i = 1, v79, n13 do
        v42(v77, i, v78)
        local _ = v79
        local _ = n13
    end
    return v22(v23(v78[1], 4) .. v23(v78[2], 4) .. v23(v78[3], 4) .. v23(v78[4], 4) .. v23(v78[5], 4) .. v23(v78[6], 4) .. v23(v78[7], 4) .. v23(v78[8], 4))
end
local t4 = {
    ["\\"] = "\\",
    ["\""] = "\"",
    ["\008"] = "b",
    ["\012"] = "f",
    ["\n"] = "n",
    ["\r"] = "r",
    ["\t"] = "t",
}
local t5 = {
    ["/"] = "/",
}
local v86 = nil
for k, v in pairs(t4) do
    t5[v] = k
end
local function v89(p31)
    return "\\" .. (t4[p31] or string.format("u%04x", p31.byte(p31)))
end
local t6 = {
    ["nil"] = function(_)
        return "null"
    end,
    table = function(p32, p33)
        local t7 = {}
        local v92 = p33 or {}
        local n14
        if not v92[p32] then
            v92[p32] = true
            if rawget(p32, 1) == nil and next(p32) ~= nil then
                for k, v in pairs(p32) do
                    if type(k) ~= "string" then
                        error("invalid table: mixed or invalid key types")
                    end
                    table.insert(t7, v86(k, v92) .. ":" .. v86(v, v92))
                end
                v92[p32] = nil
                return "{" .. table.concat(t7, ",") .. "}"
            else
                n14 = 0
                for k in pairs(p32) do
                    if type(k) ~= "number" then
                        error("invalid table: mixed or invalid key types")
                    end
                    n14 = n14 + 1
                end
                if n14 == #p32 then
                    for _, v in ipairs(p32) do
                        table.insert(t7, v86(v, v92))
                    end
                    v92[p32] = nil
                    return "[" .. table.concat(t7, ",") .. "]"
                end
                error("invalid table: sparse array")
                for _, v in ipairs(p32) do
                    table.insert(t7, v86(v, v92))
                end
                v92[p32] = nil
                return "[" .. table.concat(t7, ",") .. "]"
            end
        end
        error("circular reference")
        v92[p32] = true
        if rawget(p32, 1) == nil and next(p32) ~= nil then
            for k, v in pairs(p32) do
                if type(k) ~= "string" then
                    error("invalid table: mixed or invalid key types")
                end
                table.insert(t7, v86(k, v92) .. ":" .. v86(v, v92))
            end
            v92[p32] = nil
            return "{" .. table.concat(t7, ",") .. "}"
        else
            n14 = 0
            for k in pairs(p32) do
                if type(k) ~= "number" then
                    error("invalid table: mixed or invalid key types")
                end
                n14 = n14 + 1
            end
            if n14 == #p32 then
                for _, v in ipairs(p32) do
                    table.insert(t7, v86(v, v92))
                end
                v92[p32] = nil
                return "[" .. table.concat(t7, ",") .. "]"
            end
            error("invalid table: sparse array")
            for _, v in ipairs(p32) do
                table.insert(t7, v86(v, v92))
            end
            v92[p32] = nil
            return "[" .. table.concat(t7, ",") .. "]"
        end
    end,
    string = function(p34)
        return "\"" .. p34.gsub(p34, "[%z\001-\031\\\"]", v89) .. "\""
    end,
    number = function(p35)
        if p35 == p35 and (-math.huge < p35 and math.huge > p35) then
            return string.format("%.14g", p35)
        end
        error("unexpected number value '" .. tostring(p35) .. "'")
        return string.format("%.14g", p35)
    end,
    boolean = tostring,
}
local function v108(p36, p37)
    local kind = type(p36)
    local v110 = t6[kind]
    if v110 then
        return v110(p36, p37)
    else
        error("unexpected type '" .. kind .. "'")
    end
end
local function v111(p38)
    return v108(p38)
end
local v112 = nil
local function v113(...)
    local value = select("#", ...)
    local n15 = 1
    local t8 = {}
    for i = 1, value, n15 do
        t8[select(i, ...)] = true
        local _ = value
        local _ = n15
    end
    return t8
end
local v120 = v113(" ", "\t", "\r", "\n")
local v121 = v113(" ", "\t", "\r", "\n", "]", "}", ",")
local v122 = v113("\\", "/", "\"", "b", "f", "n", "r", "t", "u")
local v123 = v113("true", "false", "null")
local t9 = {
    ["true"] = true,
    ["false"] = false,
    null = nil,
}
local function v125(p39, p40, p41, p42)
    local v126 = #p39
    local n16 = 1
    for i = p40, v126, n16 do
        if p41[p39.sub(p39, i, i)] ~= p42 then
            return i
        end
        local _ = v126
        local _ = n16
    end
    return #p39 + 1
end
local function v131(p43, p44, p45)
    local v132 = p44 - 1
    local n17 = 1
    local n18 = 1
    local n19 = 1
    for i = 1, v132, n17 do
        n18 = n18 + 1
        if p43.sub(p43, i, i) == "\n" then
            n19 = n19 + 1
            n18 = 1
        end
        local _ = v132
        local _ = n17
    end
    error(string.format("%s at line %d col %d", p45, n19, n18))
end
local function v139(p46)
    local floor = math.floor
    if p46 <= 127 then
        return string.char(p46)
    elseif p46 <= 2047 then
        return string.char(floor(p46 / 64) + 192, p46 % 64 + 128)
    elseif p46 <= 65535 then
        return string.char(floor(p46 / 4096) + 224, floor(p46 % 4096 / 64) + 128, p46 % 64 + 128)
    elseif p46 <= 1114111 then
        return string.char(floor(p46 / 262144) + 240, floor(p46 % 262144 / 4096) + 128, floor(p46 % 4096 / 64) + 128, p46 % 64 + 128)
    else
        error(string.format("invalid unicode codepoint '%x'", p46))
        return
    end
end
local function v141(p47)
    local v142 = tonumber(p47.sub(p47, 1, 4), 16)
    local v143 = tonumber(p47.sub(p47, 7, 10), 16)
    if v143 then
        return v139((v142 - 55296) * 1024 + v143 - 56320 + 65536)
    else
        return v139(v142)
    end
end
local function v144(p48, p49)
    local v145 = v125(p48, p49, v121)
    local v146 = p48.sub(p48, p49, v145 - 1)
    local v147 = tonumber(v146)
    if v147 then
        return v147, v145
    end
    v131(p48, p49, "invalid number '" .. v146 .. "'")
    return v147, v145
end
local function v148(p50, p51)
    local v149 = v125(p50, p51, v121)
    local v150 = p50.sub(p50, p51, v149 - 1)
    if v123[v150] then
        return t9[v150], v149
    end
    v131(p50, p51, "invalid literal '" .. v150 .. "'")
    return t9[v150], v149
end
local t10 = {
    ["\""] = function(p52, p53)
        local v152 = p53 + 1
        local v153 = v152
        local s2 = ""
        while v152 <= #p52 do
            local v155 = p52.byte(p52, v152)
            if v155 < 32 then
                v131(p52, v152, "control character in string")
            elseif v155 == 92 then
                local v156 = s2 .. p52.sub(p52, v153, v152 - 1)
                v152 = v152 + 1
                local v157 = p52.sub(p52, v152, v152)
                if v157 == "u" then
                    local v158 = p52.match(p52, "^[dD][89aAbB]%x%x\\u%x%x%x%x", v152 + 1) or (p52.match(p52, "^%x%x%x%x", v152 + 1) or v131(p52, v152 - 1, "invalid unicode escape in string"))
                    s2 = v156 .. v141(v158)
                    v152 = v152 + #v158
                else
                    if not v122[v157] then
                        v131(p52, v152 - 1, "invalid escape char '" .. v157 .. "' in string")
                    end
                    s2 = v156 .. t5[v157]
                end
                v153 = v152 + 1
            elseif v155 == 34 then
                return s2 .. p52.sub(p52, v153, v152 - 1), v152 + 1
            end
            v152 = v152 + 1
        end
        v131(p52, p53, "expected closing quote for string")
    end,
    ["0"] = v144,
    ["1"] = v144,
    ["2"] = v144,
    ["3"] = v144,
    ["4"] = v144,
    ["5"] = v144,
    ["6"] = v144,
    ["7"] = v144,
    ["8"] = v144,
    ["9"] = v144,
    ["-"] = v144,
    t = v148,
    f = v148,
    n = v148,
    ["["] = function(p54, p55)
        local v159 = p55 + 1
        local t11 = {}
        local n20 = 1
        while true do
            local v162 = v125(p54, v159, v120, true)
            if p54.sub(p54, v162, v162) == "]" then
                break
            end
            local v163, v164 = v112(p54, v162)
            t11[n20] = v163
            n20 = n20 + 1
            local v165 = v125(p54, v164, v120, true)
            local v166 = p54.sub(p54, v165, v165)
            v159 = v165 + 1
            if v166 == "]" then
                return t11, v159
            end
            if v166 ~= "," then
                v131(p54, v159, "expected ']' or ','")
            end
        end
        v159 = v197 + 1
        return t11, v159
    end,
    ["{"] = function(p56, p57)
        local v167 = p57 + 1
        local t12 = {}
        while true do
            local v169 = v125(p56, v167, v120, true)
            if p56.sub(p56, v169, v169) == "}" then
                break
            end
            if p56.sub(p56, v169, v169) ~= "\"" then
                v131(p56, v169, "expected string for key")
            end
            local v170, v171 = v112(p56, v169)
            local v172 = v125(p56, v171, v120, true)
            if p56.sub(p56, v172, v172) ~= ":" then
                v131(p56, v172, "expected ':' after key")
            end
            local v173, v174 = v112(p56, (v125(p56, v172 + 1, v120, true)))
            t12[v170] = v173
            local v175 = v125(p56, v174, v120, true)
            local v176 = p56.sub(p56, v175, v175)
            v167 = v175 + 1
            if v176 == "}" then
                return t12, v167
            end
            if v176 ~= "," then
                v131(p56, v167, "expected '}' or ','")
            end
        end
        v167 = v206 + 1
        return t12, v167
    end,
}
v112 = function(p58, p59)
    local v177 = p58.sub(p58, p59, p59)
    local v178 = t10[v177]
    if v178 then
        return v178(p58, p59)
    else
        v131(p58, p59, "unexpected character '" .. v177 .. "'")
    end
end
local function v179(p60)
    if type(p60) ~= "string" then
        error("expected argument of type string, got " .. type(p60))
    end
    local v180, v181 = v112(p60, v125(p60, 1, v120, true))
    local v182 = v125(p60, v181, v120, true)
    if not (v182 <= #p60) then
        return v180
    end
    v131(p60, v182, "trailing garbage")
    return v180
end
local v183 = true
local function v184(p61)
    local http_ = not (request or http_request) and (not syn_request and http)
    if http_ then
        http_ = http.request
    end
    if not http_ then
        return nil, "HTTP requests not supported"
    end
    local ok, result = pcall(function()
        return http_(p61)
    end)
    if ok and type(result) == "table" then
        return result
    else
        return nil, "Connection Error: " .. tostring(result or "Unknown")
    end
end
local setclipboard_ = setclipboard or (toclipboard or (function()
end))
local char = string.char
local tostring_ = tostring
local time = os.time
local random = math.random
local floor = math.floor
local gethwid_ = gethwid or (function()
    local game_ = game
    local v196 = game_.GetService(game_, "RbxAnalyticsService")
    return v196.GetClientId(v196)
end)
local s3 = ""
local n21 = 0
local s4 = "https://api.platoboost.com"
local function v200()
    local v201 = v184({
        Url = s4 .. "/public/connectivity",
        Method = "GET",
    })
    if v201 and (v201.StatusCode == 200 or v201.StatusCode == 429) then
        return true
    else
        s4 = "https://api.platoboost.net"
        local v203 = v184({
            Url = s4 .. "/public/connectivity",
            Method = "GET",
        })
        if v203 then
            return true
        else
            return false
        end
    end
end
local function v205()
    local n22 = 16
    local n23 = 1
    local s5 = ""
    for _ = 1, n22, n23 do
        s5 = s5 .. char(floor(random() * 26) + 97)
        local _ = n22
        local _ = n23
    end
    return s5
end
local function v212()
    if v200() then
        if n21 + 600 < time() then
            local v213, v214 = v184({
                Url = s4 .. "/public/start",
                Method = "POST",
                Body = v111({
                    service = t1.ServiceId,
                    identifier = v76(gethwid_()),
                }),
                Headers = {
                    ["Content-Type"] = "application/json",
                },
            })
            if v213 and v213.StatusCode == 200 then
                local v215 = v179(v213.Body)
                if v215.success then
                    s3 = v215.data.url
                    n21 = time()
                    return true, s3
                else
                    return false, v214 or "Server Unreachable"
                end
            else
                return false, v214 or "Server Unreachable"
            end
        else
            return true, s3
        end
    else
        return false, "Delta/Network Error! Use VPN or change Executor."
    end
end
local function v216(p62)
    local v217 = v205()
    local t13 = {
        identifier = v76(gethwid_()),
        key = p62,
    }
    if v183 then
        t13.nonce = v217
    end
    local v219, v220 = v184({
        Url = s4 .. "/public/redeem/" .. tostring_(t1.ServiceId),
        Method = "POST",
        Body = v111(t13),
        Headers = {
            ["Content-Type"] = "application/json",
        },
    })
    if not (v219 and v219.StatusCode == 200) then
        return false, v220 or "Server Error"
    end
    local v221 = v179(v219.Body)
    if not (v221.success and v221.data.valid) then
        return false, v221.message or "Invalid Key"
    end
    if v183 then
        if v221.data.hash ~= v76("true" .. "-" .. v217 .. "-" .. t1.PlatoSecret) then
            return false, "Integrity Check Failed"
        end
        if not writefile then
            return true, "Success"
        end
        writefile(t1.KeyFileName, p62)
        return true, "Success"
    else
        if not writefile then
            return true, "Success"
        end
        writefile(t1.KeyFileName, p62)
        return true, "Success"
    end
end
local function v222()
    local game_ = game
    local LocalPlayer = game_.GetService(game_, "Players").LocalPlayer
    local v225 = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
    if not v225.FindFirstChild(v225, t1.OldGuiName) then
        _G[t1.Secret] = true
        v264 = loadstring
        v265 = game
        v264(v265.HttpGet(v265, t1.MainScriptURL))()
        return
    end
    local v226 = v225[t1.OldGuiName]
    v226.Destroy(v226)
    task.wait(0.1)
    _G[t1.Secret] = true
    local loadstring_ = loadstring
    local game_2 = game
    loadstring_(game_2.HttpGet(game_2, t1.MainScriptURL))()
end
local function v229()
    local game_ = game
    local LocalPlayer = game_.GetService(game_, "Players").LocalPlayer
    local game_2 = game
    local v233 = game_2.GetService(game_2, "CoreGui")
    local v234
    if pcall(function()
        return v233
    end) and v233 then
        v234 = v233
    else
        v234 = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
    end
    if v234.FindFirstChild(v234, "OYB_KeySystem") then
        local OYB_KeySystem = v234.OYB_KeySystem
        OYB_KeySystem.Destroy(OYB_KeySystem)
    end
    local ScreenGui = Instance.new("ScreenGui", v234)
    ScreenGui.Name = "OYB_KeySystem"
    ScreenGui.ResetOnSpawn = false
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 340, 0, 420)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -210)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.Active = true
    Frame.Draggable = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 15)
    local UIStroke = Instance.new("UIStroke", Frame)
    UIStroke.Thickness = 2
    UIStroke.Color = Color3.fromRGB(40, 40, 40)
    local TextButton = Instance.new("TextButton", Frame)
    TextButton.Size = UDim2.new(0, 30, 0, 30)
    TextButton.Position = UDim2.new(1, -35, 0, 10)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = "X"
    TextButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 18
    TextButton.ZIndex = 10
    local MouseButton1Click = TextButton.MouseButton1Click
    MouseButton1Click.Connect(MouseButton1Click, function()
        local v241 = ScreenGui
        v241.Destroy(v241)
    end)
    local TextLabel = Instance.new("TextLabel", Frame)
    TextLabel.Size = UDim2.new(1, 0, 0, 50)
    TextLabel.Text = t1.HubName
    TextLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    TextLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 16
    Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 15)
    local TextLabel2 = Instance.new("TextLabel", Frame)
    TextLabel2.Size = UDim2.new(0.9, 0, 0, 50)
    TextLabel2.Position = UDim2.new(0.05, 0, 0, 50)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = t1.HubDescription
    TextLabel2.TextColor3 = Color3.fromRGB(0, 170, 255)
    TextLabel2.Font = Enum.Font.GothamBold
    TextLabel2.TextSize = 14
    TextLabel2.TextWrapped = true
    local function v244(p63)
        local UIStroke2 = Instance.new("UIStroke", p63)
        UIStroke2.Thickness = 2
        UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        task.spawn(function()
            while task.wait() do
                local v246 = tick() % 5 / 5
                UIStroke2.Color = Color3.fromHSV(v246, 1, 1)
            end
        end)
    end
    local n24 = 105
    if t1.ShowDiscord then
        local TextButton2 = Instance.new("TextButton", Frame)
        TextButton2.Size = UDim2.new(0.85, 0, 0, 35)
        TextButton2.Position = UDim2.new(0.075, 0, 0, n24)
        TextButton2.Text = "      JOIN DISCORD"
        TextButton2.Font = "GothamBold"
        TextButton2.TextSize = 14
        TextButton2.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        TextButton2.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", TextButton2)
        v244(TextButton2)
        local ImageLabel = Instance.new("ImageLabel", TextButton2)
        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Position = UDim2.new(0.1, 0, 0.5, -10)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://18505728201"
        local MouseButton1Click2 = TextButton2.MouseButton1Click
        MouseButton1Click2.Connect(MouseButton1Click2, function()
            setclipboard_(t1.DiscordURL)
            local v251 = Frame
            local v252 = v251.FindFirstChild(v251, "StatusLabel")
            if v252 then
                v252.Text = "Discord Link Copied!"
                v252.TextColor3 = Color3.fromRGB(88, 101, 242)
            end
            local v253 = string.match(t1.DiscordURL, "discord%.gg/([%w-]+)")
            if not (syn and (syn.request and v253)) then
                return
            end
            syn.request({
                Url = "http://localhost:1111/discord?invite=" .. v253,
                Method = "GET",
            })
        end)
        n24 = n24 + 45
    end
    if t1.ShowInstagram then
        local TextButton2 = Instance.new("TextButton", Frame)
        TextButton2.Size = UDim2.new(0.85, 0, 0, 35)
        TextButton2.Position = UDim2.new(0.075, 0, 0, n24)
        TextButton2.Text = "      FOLLOW INSTAGRAM"
        TextButton2.Font = "GothamBold"
        TextButton2.TextSize = 14
        TextButton2.BackgroundColor3 = Color3.fromRGB(225, 48, 108)
        TextButton2.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", TextButton2)
        v244(TextButton2)
        local ImageLabel = Instance.new("ImageLabel", TextButton2)
        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Position = UDim2.new(0.1, 0, 0.5, -10)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://18355586382"
        local MouseButton1Click2 = TextButton2.MouseButton1Click
        MouseButton1Click2.Connect(MouseButton1Click2, function()
            setclipboard_(t1.InstagramURL)
            local v257 = Frame
            local v258 = v257.FindFirstChild(v257, "StatusLabel")
            if not v258 then
                return
            end
            v258.Text = "Instagram Link Copied!"
            v258.TextColor3 = Color3.fromRGB(225, 48, 108)
        end)
        n24 = n24 + 45
    end
    if t1.ShowYoutube then
        local TextButton2 = Instance.new("TextButton", Frame)
        TextButton2.Size = UDim2.new(0.85, 0, 0, 35)
        TextButton2.Position = UDim2.new(0.075, 0, 0, n24)
        TextButton2.Text = "      SUBSCRIBE YOUTUBE"
        TextButton2.Font = "GothamBold"
        TextButton2.TextSize = 14
        TextButton2.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        TextButton2.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", TextButton2)
        v244(TextButton2)
        local ImageLabel = Instance.new("ImageLabel", TextButton2)
        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Position = UDim2.new(0.1, 0, 0.5, -10)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://82532989017804"
        local MouseButton1Click2 = TextButton2.MouseButton1Click
        MouseButton1Click2.Connect(MouseButton1Click2, function()
            setclipboard_(t1.YoutubeURL)
            local v262 = Frame
            local v263 = v262.FindFirstChild(v262, "StatusLabel")
            if not v263 then
                return
            end
            v263.Text = "YouTube Link Copied!"
            v263.TextColor3 = Color3.fromRGB(255, 0, 0)
        end)
        n24 = n24 + 45
    end
    local TextBox = Instance.new("TextBox", Frame)
    TextBox.Size = UDim2.new(0.85, 0, 0, 40)
    TextBox.Position = UDim2.new(0.075, 0, 0, n24 + 15)
    TextBox.PlaceholderText = "Enter Key..."
    TextBox.Text = ""
    TextBox.Font = Enum.Font.GothamSemibold
    TextBox.TextSize = 14
    TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TextBox.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", TextBox)
    local TextButton2 = Instance.new("TextButton", Frame)
    TextButton2.Size = UDim2.new(0.4, 0, 0, 40)
    TextButton2.Position = UDim2.new(0.075, 0, 0, n24 + 65)
    TextButton2.Text = "VERIFY"
    TextButton2.Font = "GothamBold"
    TextButton2.TextSize = 14
    TextButton2.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    TextButton2.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", TextButton2)
    local TextButton3 = Instance.new("TextButton", Frame)
    TextButton3.Size = UDim2.new(0.4, 0, 0, 40)
    TextButton3.Position = UDim2.new(0.525, 0, 0, n24 + 65)
    TextButton3.Text = "GET KEY"
    TextButton3.Font = "GothamBold"
    TextButton3.TextSize = 14
    TextButton3.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    TextButton3.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", TextButton3)
    local TextLabel3 = Instance.new("TextLabel", Frame)
    TextLabel3.Name = "StatusLabel"
    TextLabel3.Size = UDim2.new(1, 0, 0, 30)
    TextLabel3.Position = UDim2.new(0, 0, 0, n24 + 115)
    TextLabel3.BackgroundTransparency = 1
    TextLabel3.Text = "Waiting for input..."
    TextLabel3.TextColor3 = Color3.fromRGB(150, 150, 150)
    TextLabel3.Font = Enum.Font.Gotham
    TextLabel3.TextSize = 12
    Frame.Size = UDim2.new(0, 340, 0, n24 + 160)
    local MouseButton1Click2 = TextButton2.MouseButton1Click
    MouseButton1Click2.Connect(MouseButton1Click2, function()
        local Text = TextBox.Text
        if Text == "" then
            TextLabel3.Text = "Enter a key!"
        else
            TextLabel3.Text = "Verifying..."
            local v270, v271 = v216(Text)
            if v270 then
                TextLabel3.Text = "Success! Loading..."
                TextLabel3.TextColor3 = Color3.fromRGB(0, 255, 100)
                task.wait(0.5)
                local v272 = ScreenGui
                v272.Destroy(v272)
                v222()
            else
                TextLabel3.Text = v271
                TextLabel3.TextColor3 = Color3.fromRGB(255, 50, 50)
            end
        end
    end)
    local MouseButton1Click3 = TextButton3.MouseButton1Click
    MouseButton1Click3.Connect(MouseButton1Click3, function()
        TextLabel3.Text = "Getting Link..."
        local v274, v275 = v212()
        if v274 then
            setclipboard_(v275)
            TextLabel3.Text = "Link Copied!"
            TextLabel3.TextColor3 = Color3.fromRGB(0, 170, 255)
        else
            TextLabel3.Text = tostring(v275)
            TextLabel3.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    if not (isfile and isfile(t1.KeyFileName)) then
        return
    end
    local v276 = readfile(t1.KeyFileName)
    if v276 == "" then
        return
    end
    TextLabel3.Text = "Found saved key, verifying..."
    task.spawn(function()
        local v277 = v216(v276)
        if v277 then
            TextLabel3.Text = "Auto-login success!"
            TextLabel3.TextColor3 = Color3.fromRGB(0, 255, 100)
            task.wait(0.5)
            local v279 = ScreenGui
            v279.Destroy(v279)
            v222()
        else
            TextLabel3.Text = "Saved key expired or invalid."
            TextLabel3.TextColor3 = Color3.fromRGB(255, 150, 0)
        end
    end)
end
local game_ = game
local LocalPlayer = game_.GetService(game_, "Players").LocalPlayer
local v282 = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
if v282.FindFirstChild(v282, t1.MainGuiName) then
    v222()
else
    v229()
end
