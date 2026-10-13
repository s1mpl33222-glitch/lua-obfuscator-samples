-- This file was generated at discord.gg/syncrypt

local t1 = {}
local t2 = {}
t1.value5 = 25237642063336
t1.value2 = nil
t1.value3 = "\154\f\143\244\nk[\163\224\251\138\t\000x\165\252q\023yɄ\252\030\239G\161?\0163\144\242\244E\022\209\206"
t1.value7 = 4828406859976
t1.value6 = 8545818513291
t1.value4 = "\245?\028\188UR\183S\185\193\026\155\181F9an\017\149XR\215w\167\028\018\162\170\241"
t2.value1 = {
	ServiceId = 22984,
	PlatoSecret = "0999f5a2-c754-4564-a7f4-bfc278f7d7bb",
	Secret = "2009",
	MainScriptURL = "https://raw.githubusercontent.com/LPOLVO/LP10/refs/heads/main/Climb%20for%20animals%20eggs%20OB",
	ShowDiscord = true,
	DiscordURL = "https://discord.gg/Uqrkdrpwxr",
	ShowInstagram = true,
	InstagramURL = "https://www.instagram.com/4me.h4mz4_?igsh=MW9sa20yejExaGo5Nw==",
	ShowYoutube = true,
	YoutubeURL = "https://youtube.com/@lpolvoxd1?si=sz_Y8Rm0RTrb1r0-",
	KeyFileName = "LP10 Key",
	OldGuiName = "LP10",
	MainGuiName = "LP10 HUB",
	HubName = "LP10 HUB KeySystem",
	HubDescription = "Halloween Key  -  grab your key if you dare"
}
t2.value2 = 4294967296
t2.value3 = t2.value2 - 1
function t1.value3(p1, p2)
    if p2 < 0 then
        return lshift(p1, -p2)
    end

    return math.floor(p1 % 4294967296 / 2 ^ p2)
end
function t2.value4(p3, p4)
    local n1 = 0
    local n2 = 1

    while p3 ~= 0 or p4 ~= 0 do
        n1 += (p3 % 2 + p4 % 2) % 2 * n2
        p3 = math.floor(p3 / 2)
        p4 = math.floor(p4 / 2)
        n2 *= 2
    end

    return n1 % t2.value2
end
t2.value5 = nil
function t2.value5(p5, p6, p7, ...)
    if p6 then
        local v30 = p5 % t2.value2
        local v31 = t2.value4(v30, p6 % t2.value2)

        if p7 then
            v31 = t2.value5(v31, p7, ...)
        end

        return v31
    end

    if p5 then
        return p5 % t2.value2
    end

    return 0
end
t2.value6 = nil
function t2.value6(p8, p9, p10, ...)
    if p9 then
        local v36 = p8 % t2.value2
        local v37 = p9 % t2.value2
        local v38 = (v36 + v37 - t2.value4(v36, v37)) / 2

        if p10 then
            v38 = t2.value6(v38, p10, ...)
        end

        return v38
    end

    if p8 then
        return p8 % t2.value2
    end

    return t2.value3
end
function t2.value7(p11)
    return t2.value3 - p11
end
t2.value8 = t1.value3
local function v3(p12, p13)
    if p13 > 31 or p13 < -31 then
        return 0
    end

    return t2.value8(p12 % t2.value2, p13)
end
t2.value9 = nil
function t2.value9(p14, p15)
    if p15 < 0 then
        return v3(p14, -p15)
    end

    return p14 * 2 ^ p15 % 4294967296
end
function t2.value10(p16, p17)
    local v45 = p16 % t2.value2
    local v46 = p17 % 32
    local v47 = t2.value6(v45, 2 ^ v46 - 1)

    return ((if not (v46 > 31 or v46 < -31) then t2.value8(v45 % t2.value2, v46) else 0)) + t2.value9(v47, 32 - v46)
end
function t1.value5(p18)
    return string.gsub(p18, ".", function(p19)
        return string.format("%02x", string.byte(p19))
    end)
end
t2.value11 = {
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
	3329325298
}
t2.value12 = t1.value5
t2.value13 = nil
function t1.value4(p20, p21)
    local v56 = 64 - (p21 + 9) % 64
    local v57 = t2.value13(8 * p21, 8)
    local v58 = p20 .. "\128" .. string.rep("\000", v56) .. v57

    assert(#v58 % 64 == 0)

    return v58
end
function t2.value13(p22, p23)
    local s1 = ""

    for _ = 1, p23 do
        local v53 = p22 % 256

        s1 = string.char(v53) .. s1
        p22 = (p22 - v53) / 256
    end

    return s1
end
t2.value14 = t1.value4
function t2.value15(p24)
    p24[1] = 1779033703
    p24[2] = 3144134277
    p24[3] = 1013904242
    p24[4] = 2773480762
    p24[5] = 1359893119
    p24[6] = 2600822924
    p24[7] = 528734635
    p24[8] = 1541459225

    return p24
end
function t1.value6(p25, p26, p27)
    local t3 = {}

    for i = 1, 16 do
        local v69 = p26 + (i - 1) * 4
        local n3 = 0

        for j = v69, v69 + 3 do
            n3 = n3 * 256 + string.byte(p25, j)
        end

        t3[i] = n3
    end

    for i = 17, 64 do
        local v73 = t3[i - 15]
        local v74 = t2.value5(t2.value10(v73, 7), t2.value10(v73, 18), v3(v73, 3))
        local v75 = t3[i - 2]

        t3[i] = (t3[i - 16] + v74 + t3[i - 7] + t2.value5(t2.value10(v75, 17), t2.value10(v75, 19), v3(v75, 10))) % t2.value2
    end

    local v76 = p27[1]
    local v77 = p27[2]
    local v78 = p27[3]
    local v79 = p27[4]
    local v80 = p27[5]
    local v81 = p27[6]
    local v82 = p27[7]
    local v83 = p27[8]

    for i = 1, 64 do
        local v85 = (t2.value5(t2.value10(v76, 2), t2.value10(v76, 13), t2.value10(v76, 22)) + t2.value5(t2.value6(v76, v77), t2.value6(v76, v78), t2.value6(v77, v78))) % t2.value2
        local v86 = t2.value5(t2.value10(v80, 6), t2.value10(v80, 11), t2.value10(v80, 25))
        local v87 = t2.value5(t2.value6(v80, v81), t2.value6(t2.value7(v80), v82))
        local v88 = t2.value11[i]
        local v89 = t3[i]
        local v90 = (v83 + v86 + v87 + v88 + v89) % t2.value2
        local v91 = v80

        v83 = v82
        v80 = (v79 + v90) % t2.value2
        v79 = v78
        v78 = v77
        v82 = v81
        v77 = v76
        v76 = (v90 + v85) % t2.value2
        v81 = v91
    end

    p27[1] = (p27[1] + v76) % t2.value2
    p27[2] = (p27[2] + v77) % t2.value2
    p27[3] = (p27[3] + v78) % t2.value2
    p27[4] = (p27[4] + v79) % t2.value2
    p27[5] = (p27[5] + v80) % t2.value2
    p27[6] = (p27[6] + v81) % t2.value2
    p27[7] = (p27[7] + v82) % t2.value2
    p27[8] = (p27[8] + v83) % t2.value2
end
t2.value16 = t1.value6
t2.value17 = nil
function t1.value6(p28)
    local v93 = t2.value14(p28, #p28)
    local v94 = t2.value15({})

    for i = 1, #v93, 64 do
        t2.value16(v93, i, v94)
    end

    local value12 = t2.value12
    local v97 = v94[1]
    local v98 = t2.value13(v97, 4)
    local v99 = v94[2]
    local v100 = t2.value13(v99, 4)
    local v101 = v94[3]
    local v102 = t2.value13(v101, 4)
    local v103 = v94[4]
    local v104 = t2.value13(v103, 4)
    local v105 = v94[5]
    local v106 = t2.value13(v105, 4)
    local v107 = v94[6]
    local v108 = t2.value13(v107, 4)
    local v109 = v94[7]

    return value12(v98 .. v100 .. v102 .. v104 .. v106 .. v108 .. t2.value13(v109, 4) .. t2.value13(v94[8], 4))
end
t2.value18 = {
	["\\"] = "\\",
	["\""] = "\"",
	["\b"] = "b",
	["\f"] = "f",
	["\n"] = "n",
	["\r"] = "r",
	["\t"] = "t"
}
t2.value19 = {
	["/"] = "/"
}
for k, v in pairs(t2.value18) do
    t2.value19[v] = k
end
t1.value8 = 35106931261403
t1.value9 = 31312530536693
local function v6(p29)
    local v113 = t2.value18[p29]

    if not v113 then
        v113 = string.format("u%04x", p29:byte())
    end

    return "\\" .. v113
end
t2.value20 = {
	["nil"] = function(_)
    return "null"
end,
	table = function(p31, p32)
    local t4 = {}

    if not p32 then
        p32 = {}
    end

    if p32[p31] then
        error("circular reference")
    end

    p32[p31] = true

    if rawget(p31, 1) ~= nil or next(p31) == nil then
        local n4 = 0
        for v122 in pairs(p31) do

            if type(v122) ~= "number" then
                error("invalid table: mixed or invalid key types")
            end

            n4 += 1
        end
        if n4 ~= #p31 then
            error("invalid table: sparse array")
        end
        for _, v in ipairs(p31) do
            table.insert(t4, t2.value17(v, p32))
        end
        p32[p31] = nil

        return "[" .. table.concat(t4, ",") .. "]"
    end

    for k, v in pairs(p31) do
        local v127 = k

        if type(v127) ~= "string" then
            error("invalid table: mixed or invalid key types")
        end

        table.insert(t4, t2.value17(v127, p32) .. ":" .. t2.value17(v, p32))
    end

    p32[p31] = nil

    return "{" .. table.concat(t4, ",") .. "}"
end,
	string = function(p33)
    return "\"" .. p33:gsub("[%z\001-\031\\\"]", v6) .. "\""
end,
	number = function(p34)
    local v111 = p34 ~= p34

    if not v111 then
        v111 = p34 <= -1e999

        if not v111 then
            v111 = p34 >= 1e999
        end
    end

    if v111 then
        error("unexpected number value '" .. tostring(p34) .. "'")
    end

    return string.format("%.14g", p34)
end,
	boolean = tostring
}
function t2.value17(p35, p36)
    local v130 = type(p35)
    local v131 = t2.value20[v130]

    if v131 then
        return v131(p35, p36)
    end

    error("unexpected type '" .. v130 .. "'")
end
t2.value21 = nil
local function v7(...)
    local t5 = {}

    for i = 1, select("#", ...) do
        t5[select(i, ...)] = true
    end

    return t5
end
t2.value22 = v7(" ", "\t", "\r", "\n")
t2.value23 = v7(" ", "\t", "\r", "\n", "]", "}", ",")
t2.value24 = v7("\\", "/", "\"", "b", "f", "n", "r", "t", "u")
t2.value25 = v7("true", "false", "null")
t2.value26 = nil
t2.value27 = {
	["true"] = true,
	["false"] = false,
	null = nil
}
function t2.value28(p37, p38, p39, p40)
    for i = p38, #p37 do
        local v140 = i

        if p40 ~= p39[p37:sub(v140, v140)] then
            return v140
        end
    end

    return #p37 + 1
end
local function v8(p41, p42)
    local v143 = t2.value28(p41, p42, t2.value23)
    local v144 = p41:sub(p42, v143 - 1)

    if not t2.value25[v144] then
        t2.value26(p41, p42, "invalid literal '" .. v144 .. "'")
    end

    return t2.value27[v144], v143
end
function t2.value26(p43, p44, p45)
    local n5 = 1
    local n6 = 1

    for i = 1, p44 - 1 do
        n6 += 1

        if p43:sub(i, i) == "\n" then
            n5 += 1
            n6 = 1
        end
    end

    error(string.format("%s at line %d col %d", p45, n5, n6))
end
function t2.value29(p46)
    local floor = math.floor

    if p46 <= 127 then
        return string.char(p46)
    end

    if p46 <= 2047 then
        return string.char(floor(p46 / 64) + 192, p46 % 64 + 128)
    end

    if p46 <= 65535 then
        return string.char(floor(p46 / 4096) + 224, floor(p46 % 4096 / 64) + 128, p46 % 64 + 128)
    end

    if p46 <= 1114111 then
        return string.char(floor(p46 / 262144) + 240, floor(p46 % 262144 / 4096) + 128, floor(p46 % 4096 / 64) + 128, p46 % 64 + 128)
    end

    error(string.format("invalid unicode codepoint '%x'", p46))
end
local function v9(p47)
    local sub = p47.sub
    local num = tonumber(sub(p47, 1, 4), 16)
    local num2 = tonumber(p47:sub(7, 10), 16)

    if num2 then
        return t2.value29((num - 55296) * 1024 + num2 - 56320 + 65536)
    end

    return t2.value29(num)
end
local function v10(p48, p49)
    local v193 = t2.value28(p48, p49, t2.value23)
    local v194 = p48:sub(p49, v193 - 1)
    local num = tonumber(v194)

    if not num then
        t2.value26(p48, p49, "invalid number '" .. v194 .. "'")
    end

    return num, v193
end
t1.value9 = "\229"
t1.value10 = 1901981926261
t2.value30 = {
	["\""] = function(p50, p51)
    local s2 = ""
    local v171 = p51 + 1
    local v172 = v171

    while v171 <= #p50 do
        local v173 = p50:byte(v171)

        if v173 < 32 then
            t2.value26(p50, v171, "control character in string")
        elseif v173 == 92 then
            local v174 = s2 .. p50:sub(v172, v171 - 1)

            v171 += 1

            local v175 = p50:sub(v171, v171)

            if v175 == "u" then
                local v176 = p50:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", v171 + 1)

                if not v176 then
                    v176 = p50:match("^%x%x%x%x", v171 + 1)

                    if not v176 then
                        v176 = t2.value26(p50, v171 - 1, "invalid unicode escape in string")
                    end
                end

                s2 = v174 .. v9(v176)
                v171 += #v176
            else
                if not t2.value24[v175] then
                    t2.value26(p50, v171 - 1, "invalid escape char '" .. v175 .. "' in string")
                end

                s2 = v174 .. t2.value19[v175]
            end

            v172 = v171 + 1
        elseif v173 == 34 then
            return s2 .. p50:sub(v172, v171 - 1), v171 + 1
        end

        v171 += 1
    end

    t2.value26(p50, p51, "expected closing quote for string")
end,
	["0"] = v10,
	["1"] = v10,
	["2"] = v10,
	["3"] = v10,
	["4"] = v10,
	["5"] = v10,
	["6"] = v10,
	["7"] = v10,
	["8"] = v10,
	["9"] = v10,
	["-"] = v10,
	t = v8,
	f = v8,
	n = v8,
	["["] = function(p52, p53)
    local t6 = {}
    local n7 = 1
    local v149 = p53 + 1
    local v150
    while true do
        v150 = t2.value28(p52, v149, t2.value22, true)

        if p52:sub(v150, v150) == "]" then
            break
        end

        local v151, v152 = t2.value21(p52, v150)

        t6[n7] = v151
        n7 += 1

        local value22 = t2.value22
        local v154 = t2.value28(p52, v152, value22, true)
        local v155 = p52:sub(v154, v154)

        v149 = v154 + 1

        if v155 == "]" then
            return t6, v149
        end

        if v155 ~= "," then
            t2.value26(p52, v149, "expected ']' or ','")
        end
    end
    v149 = v150 + 1

    return t6, v149
end,
	["{"] = function(p54, p55)
    local t7 = {}
    local v180 = p55 + 1
    local v181
    while true do
        v181 = t2.value28(p54, v180, t2.value22, true)

        if p54:sub(v181, v181) == "}" then
            break
        end

        if p54:sub(v181, v181) ~= "\"" then
            t2.value26(p54, v181, "expected string for key")
        end

        local v182, v183 = t2.value21(p54, v181)
        local v184 = t2.value28(p54, v183, t2.value22, true)

        if p54:sub(v184, v184) ~= ":" then
            t2.value26(p54, v184, "expected ':' after key")
        end

        local v185 = t2.value28(p54, v184 + 1, t2.value22, true)
        local v186, v187 = t2.value21(p54, v185)

        t7[v182] = v186

        local value22 = t2.value22
        local v189 = t2.value28(p54, v187, value22, true)
        local v190 = p54:sub(v189, v189)

        v180 = v189 + 1

        if v190 == "}" then
            return t7, v180
        end

        if v190 ~= "," then
            t2.value26(p54, v180, "expected '}' or ','")
        end
    end
    v180 = v181 + 1

    return t7, v180
end
}
function t1.value8(p56)
    local _request = request

    if not _request then
        _request = http_request

        if not _request then
            _request = syn_request

            if not _request then
                _request = http

                if _request then
                    _request = http.request
                end
            end
        end
    end

    local v198 = _request

    if not v198 then
        return nil, "HTTP requests not supported"
    end

    local ok, result = pcall(function()
        return v198(p56)
    end)

    if ok and result then
        return result
    end

    return nil, "Connection Error"
end
t1.value10 = t1.value1
function t2.value21(p57, p58)
    local v203 = p57:sub(p58, p58)
    local v204 = t2.value30[v203]

    if v204 then
        return v204(p57, p58)
    end

    t2.value26(p57, p58, "unexpected character '" .. v203 .. "'")
end
function t2.value31(p59)
    return t2.value17(p59)
end
function t2.value32(p60)
    if type(p60) ~= "string" then
        error("expected argument of type string, got " .. type(p60))
    end

    local v206, v207 = t2.value21(p60, t2.value28(p60, 1, t2.value22, true))
    local v208 = t2.value28(p60, v207, t2.value22, true)

    if v208 <= #p60 then
        t2.value26(p60, v208, "trailing garbage")
    end

    return v206
end
t2.value33 = t1.value6
t2.value34 = true
t2.value35 = t1.value8
local _setclipboard = setclipboard
t1.value8 = _setclipboard
if not _setclipboard then
    local value1 = t1.value1
    local v13 = toclipboard or function()
    end

    t1.value1 = value1
    t1.value8 = v13
end
local value10 = t1.value10
t1.value11 = "\154*zd"
t1.value1 = value10
t2.value36 = t1.value8
t1.value8 = string.char
local _tostring = tostring
local time = os.time
local random = math.random
local floor = math.floor
t2.value37 = t1.value8
t2.value38 = _tostring
t2.value39 = time
t2.value40 = random
t2.value41 = floor
local v19 = gethwid or function()
    return game:GetService("RbxAnalyticsService"):GetClientId()
end
t1.value1 = t1.value1
t1.value12 = "game"
t2.value42 = v19
t1.value12 = game:GetService("TweenService")
t2.value43 = t1.value12
t1.value12 = game
local GetService = t1.value12.GetService
t1.value14 = 29239534056751
t1.value13 = GetService
t1.value13 = t1.value13(t1.value12, "RunService")
t2.value44 = t1.value13
t2.value45 = ""
t2.value46 = 0
t2.value47 = "https://api.platoboost.com";
(function()
    local v212 = t2.value35({
		Url = t2.value47 .. "/public/connectivity",
		Method = "GET"
	})
    local v213 = not v212

    if not v213 then
        v213 = v212.StatusCode ~= 200 and v212.StatusCode ~= 429
    end

    if v213 then
        t2.value47 = "https://api.platoboost.net"
    end
end)()
t2.value48 = nil
function t1.value14(p61)
    local v226 = t2.value48()
    local t8 = {
		identifier = t2.value33(t2.value42()),
		key = p61
	}

    if t2.value34 then
        t8.nonce = v226
    end

    local value35 = t2.value35
    local v229 = t2.value47 .. "/public/redeem/" .. t2.value38(t2.value1.ServiceId)
    local v230 = t2.value31(t8)
    local t9 = {
		["Content-Type"] = "application/json"
	}
    local v232, v233 = value35({
		Url = v229,
		Method = "POST",
		Body = v230,
		Headers = t9
	})

    if v232 and v232.StatusCode == 200 then
        local v234 = t2.value32(v232.Body)
        local success = v234.success

        if success then
            success = v234.data.valid
        end

        if success then
            if t2.value34 then
                if v234.data.hash == t2.value33("true" .. "-" .. v226 .. "-" .. t2.value1.PlatoSecret) then
                    if writefile then
                        writefile(t2.value1.KeyFileName, p61)
                    end

                    return true, "Success"
                end

                return false, "Integrity Check Failed"
            end

            if writefile then
                writefile(t2.value1.KeyFileName, p61)
            end

            return true, "Success"
        end

        return false, v234.message or "Invalid Key"
    end

    if not v233 then
        v233 = "Server Error"
    end

    return false, v233
end
function t2.value48()
    local s3 = ""

    for _ = 1, 16 do
        s3 ..= t2.value37(t2.value41(t2.value40() * 26) + 97)
    end

    return s3
end
function t2.value49()
    if t2.value46 + 600 < t2.value39() then
        local value35 = t2.value35
        local v215 = t2.value47 .. "/public/start"
        local value31 = t2.value31
        local ServiceId = t2.value1.ServiceId
        local value42 = t2.value42
        local v219 = t2.value33(value42())
        local v220 = value31({
			service = ServiceId,
			identifier = v219
		})
        local t10 = {
			["Content-Type"] = "application/json"
		}
        local v222, v223 = value35({
			Url = v215,
			Method = "POST",
			Body = v220,
			Headers = t10
		})

        if v222 and v222.StatusCode == 200 then
            local v224 = t2.value32(v222.Body)

            if v224.success then
                t2.value45 = v224.data.url
                t2.value39()

                return true, t2.value45
            end
        end

        if not v223 then
            v223 = "Server Unreachable"
        end

        return false, v223
    end

    return true, t2.value45
end
t2.value50 = t1.value14
function t2.value51()
    local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")

    if PlayerGui:FindFirstChild(t2.value1.OldGuiName) then
        PlayerGui[t2.value1.OldGuiName]:Destroy()
        task.wait(0.1)
    end

    _G[t2.value1.Secret] = true
    loadstring(game:HttpGet(t2.value1.MainScriptURL))()
end
if game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild(t2.value1.MainGuiName) then
    t2.value51()

    return
end;
(function()
    local LocalPlayer = game:GetService("Players").LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    pcall(function()
        if gethui then
            CoreGui = gethui()
        end
    end)
    if not CoreGui then
        CoreGui = LocalPlayer:WaitForChild("PlayerGui")
    end
    if CoreGui:FindFirstChild("OYB_KeySystem") then
        CoreGui.OYB_KeySystem:Destroy()
    end
    local ScreenGui = Instance.new("ScreenGui", CoreGui)
    ScreenGui.Name = "OYB_KeySystem"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Name = "AuroraBackdrop"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = Color3.fromRGB(9, 5, 13)
    Frame.BorderSizePixel = 0
    Frame.ZIndex = 1
    local UIGradient = Instance.new("UIGradient", Frame)
    UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(9, 5, 13)),
		ColorSequenceKeypoint.new(0.45, Color3.fromRGB(28, 10, 22)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 7, 20))
	})
    UIGradient.Rotation = 135
    local function v241(p62, p63, p64, p65, p66)
        local ImageLabel = Instance.new("ImageLabel", Frame)

        ImageLabel.Name = p62
        ImageLabel.Size = UDim2.fromOffset(p63, p63)
        ImageLabel.Position = p64
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://5028857084"
        ImageLabel.ImageColor3 = p65
        ImageLabel.ImageTransparency = p66
        ImageLabel.ZIndex = 2

        return ImageLabel
    end
    local v242 = v241("AuroraOne", 420, UDim2.new(0.08, -210, 0.08, -210), Color3.fromRGB(255, 117, 24), 0.68)
    local v243 = v241("AuroraTwo", 360, UDim2.new(0.92, -180, 0.86, -180), Color3.fromRGB(170, 60, 5), 0.73)
    local v244 = v241("AuroraThree", 260, UDim2.new(0.5, -130, 1.04, -130), Color3.fromRGB(120, 255, 70), 0.82)
    local Frame2 = Instance.new("Frame", Frame)
    Frame2.Name = "AuroraLine"
    Frame2.Size = UDim2.new(1.5, 0, 0, 1)
    Frame2.Position = UDim2.new(-0.25, 0, 0.35, 0)
    Frame2.Rotation = -17
    Frame2.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
    Frame2.BackgroundTransparency = 0.78
    Frame2.BorderSizePixel = 0
    Frame2.ZIndex = 3
    local clone = Frame2:Clone()
    clone.Name = "AuroraLineTwo"
    clone.Position = UDim2.new(-0.25, 0, 0.68, 0)
    clone.Rotation = 12
    clone.BackgroundColor3 = Color3.fromRGB(120, 255, 70)
    clone.BackgroundTransparency = 0.86
    clone.Parent = Frame
    task.spawn(function()
        while true do
            local v301 = ScreenGui

            if v301 then
                v301 = ScreenGui.Parent
            end

            if not v301 then
                break
            end

            local tweenInfo = TweenInfo.new(6.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)

            t2.value43:Create(v242, tweenInfo, {
				Position = UDim2.new(0.28, -210, 0.24, -210),
				ImageTransparency = 0.78
			}):Play()
            t2.value43:Create(v243, TweenInfo.new(7.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.72, -180, 0.7, -180),
				ImageTransparency = 0.82
			}):Play()
            t2.value43:Create(v244, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.4, -130, 0.84, -130),
				ImageTransparency = 0.88
			}):Play()
            t2.value43:Create(Frame2, tweenInfo, {
				Position = UDim2.new(0.08, 0, 0.62, 0),
				BackgroundTransparency = 0.9
			}):Play()
            t2.value43:Create(clone, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.12, 0, 0.28, 0),
				BackgroundTransparency = 0.93
			}):Play()
            task.wait(4.5)

            local v303 = not ScreenGui

            if not v303 then
                v303 = not ScreenGui.Parent
            end

            if v303 then
                return
            end

            t2.value43:Create(v242, tweenInfo, {
				Position = UDim2.new(0.08, -210, 0.08, -210),
				ImageTransparency = 0.68
			}):Play()
            t2.value43:Create(v243, TweenInfo.new(7.4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.92, -180, 0.86, -180),
				ImageTransparency = 0.73
			}):Play()
            t2.value43:Create(v244, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(0.5, -130, 1.04, -130),
				ImageTransparency = 0.82
			}):Play()
            t2.value43:Create(Frame2, tweenInfo, {
				Position = UDim2.new(-0.25, 0, 0.35, 0),
				BackgroundTransparency = 0.78
			}):Play()
            t2.value43:Create(clone, TweenInfo.new(5.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Position = UDim2.new(-0.25, 0, 0.68, 0),
				BackgroundTransparency = 0.86
			}):Play()
            task.wait(4.5)
        end
    end)
    local Frame3 = Instance.new("Frame", ScreenGui)
    Frame3.Name = "KeyCard"
    Frame3.Size = UDim2.new(0.88, 0, 0, 460)
    Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame3.Position = UDim2.fromScale(0.5, 0.5)
    Frame3.BackgroundColor3 = Color3.fromRGB(20, 10, 26)
    Frame3.BorderSizePixel = 0
    Frame3.Active = true
    Frame3.Draggable = true
    Frame3.ClipsDescendants = true
    Frame3.ZIndex = 10
    Instance.new("UICorner", Frame3).CornerRadius = UDim.new(0, 15)
    local UIScale = Instance.new("UIScale", Frame3)
    local function v249()
        local CurrentCamera = workspace.CurrentCamera
        local v305 = CurrentCamera and CurrentCamera.ViewportSize

        if not v305 then
            v305 = Vector2.new(800, 600)
        end

        UIScale.Scale = math.clamp(v305.Y / 520, 0.78, 0.93)
    end
    v249()
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(v249)
    end
    local UIStroke = Instance.new("UIStroke", Frame3)
    UIStroke.Thickness = 1.5
    UIStroke.Color = Color3.fromRGB(255, 117, 24)
    UIStroke.Transparency = 0.12
    local n8 = 0
    local connection
    connection = t2.value44.Heartbeat:Connect(function(dt)
        local v307 = not ScreenGui

        if not v307 then
            v307 = not ScreenGui.Parent
        end

        if v307 then
            if connection then
                connection:Disconnect()
            end

            return
        end

        n8 = (n8 + dt * 0.12) % 1
        UIStroke.Color = Color3.fromRGB(255, 117, 24):Lerp(Color3.fromRGB(150, 70, 230), (math.sin(n8 * 3.141592653589793 * 2) + 1) / 2)
    end)
    local UIGradient2 = Instance.new("UIGradient", Frame3)
    UIGradient2.Color = ColorSequence.new(Color3.fromRGB(42, 18, 40), Color3.fromRGB(12, 7, 16))
    UIGradient2.Rotation = 135
    local Frame4 = Instance.new("Frame", Frame3)
    Frame4.Size = UDim2.new(1, 0, 0, 3)
    Frame4.Position = UDim2.fromOffset(0, 78)
    Frame4.BackgroundColor3 = Color3.fromRGB(255, 160, 50)
    Frame4.BorderSizePixel = 0
    Frame4.ZIndex = 14
    local UIGradient3 = Instance.new("UIGradient", Frame4)
    UIGradient3.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 60, 5)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 190, 110)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(170, 60, 5))
	})
    UIGradient3.Offset = Vector2.new(-1, 0)
    task.spawn(function()
        while true do
            local v308 = ScreenGui

            if v308 then
                v308 = ScreenGui.Parent
            end

            if not v308 then
                break
            end

            t2.value43:Create(UIGradient3, TweenInfo.new(2.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
				Offset = Vector2.new(1, 0)
			}):Play()
            task.wait(2.8)

            local v309 = not ScreenGui

            if not v309 then
                v309 = not ScreenGui.Parent
            end

            if v309 then
                return
            end

            UIGradient3.Offset = Vector2.new(-1, 0)
        end
    end)
    local random2 = Random.new()
    local t11 = {
		"🦇",
		"👻",
		"🎃",
		"🕸\239\184\143",
		"🍬",
		"💀",
		"🕷\239\184\143"
	}
    local Frame5 = Instance.new("Frame", Frame3)
    Frame5.Name = "Fog"
    Frame5.Size = UDim2.new(1, 0, 0, 80)
    Frame5.Position = UDim2.new(0, 0, 1, -80)
    Frame5.BackgroundColor3 = Color3.fromRGB(122, 46, 180)
    Frame5.BorderSizePixel = 0
    Frame5.ZIndex = 11
    local UIGradient4 = Instance.new("UIGradient", Frame5)
    UIGradient4.Color = ColorSequence.new(Color3.fromRGB(122, 46, 180), Color3.fromRGB(122, 46, 180))
    UIGradient4.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0.75)
	})
    UIGradient4.Rotation = 90
    for _, v in ipairs({
		{
			pos = UDim2.fromOffset(-10, -10),
			rot = 0,
			tr = 0.25
		},
		{
			pos = UDim2.new(1, -44, 1, -44),
			rot = 180,
			tr = 0.35
		}
	}) do
        local TextLabel = Instance.new("TextLabel", Frame3)

        TextLabel.Size = UDim2.fromOffset(50, 50)
        TextLabel.Position = v.pos
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = "🕸\239\184\143"
        TextLabel.TextSize = 40
        TextLabel.TextTransparency = v.tr
        TextLabel.Rotation = v.rot
        TextLabel.ZIndex = 15
    end
    local Frame6 = Instance.new("Frame", Frame3)
    Frame6.Size = UDim2.fromScale(1, 1)
    Frame6.BackgroundColor3 = Color3.fromRGB(176, 96, 255)
    Frame6.BackgroundTransparency = 1
    Frame6.BorderSizePixel = 0
    Frame6.ZIndex = 30
    Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 15)
    local Frame7 = Instance.new("Frame", Frame)
    Frame7.Size = UDim2.fromScale(1, 1)
    Frame7.BackgroundColor3 = Color3.fromRGB(176, 96, 255)
    Frame7.BackgroundTransparency = 1
    Frame7.BorderSizePixel = 0
    Frame7.ZIndex = 5
    local function v265(p67, p68)
        t2.value43:Create(p67, TweenInfo.new(0.05), {
			BackgroundTransparency = p68
		}):Play()
        task.delay(0.08, function()
            t2.value43:Create(p67, TweenInfo.new(0.08), {
				BackgroundTransparency = 1
			}):Play()
            task.delay(0.12, function()
                t2.value43:Create(p67, TweenInfo.new(0.05), {
					BackgroundTransparency = p68 + 0.1
				}):Play()
                task.delay(0.07, function()
                    t2.value43:Create(p67, TweenInfo.new(0.35), {
						BackgroundTransparency = 1
					}):Play()
                end)
            end)
        end)
    end
    task.delay(0.6, function()
        v265(Frame6, 0.7)
        v265(Frame7, 0.85)
    end)
    task.spawn(function()
        while true do
            local v312 = ScreenGui

            if v312 then
                v312 = ScreenGui.Parent
            end

            if not v312 then
                break
            end

            task.wait(random2:NextNumber(8, 16))

            local v313 = ScreenGui

            if v313 then
                v313 = ScreenGui.Parent
            end

            if v313 then
                v265(Frame6, 0.7)
                v265(Frame7, 0.85)
            end
        end
    end)
    local function v266(p69, p70, p71, p72, p73, p74)
        local TextLabel = Instance.new("TextLabel", p69)

        TextLabel.Size = UDim2.fromOffset(p72, p72)
        TextLabel.Position = UDim2.new(p71, 0, 1, 0)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Text = t11[random2:NextInteger(1, #t11)]
        TextLabel.TextSize = p72
        TextLabel.TextTransparency = p74
        TextLabel.Rotation = random2:NextInteger(-25, 25)
        TextLabel.ZIndex = p70

        local value43 = t2.value43
        local tweenInfo = TweenInfo.new(p73, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
        local uDim2 = UDim2.new(math.clamp(p71 + random2:NextNumber(-0.12, 0.12), 0, 1), 0, -0.1, 0)
        local v324 = random2
        local Create = value43.Create
        local v326 = v324:NextInteger(-50, 50)

        Create(value43, TextLabel, tweenInfo, {
			Position = uDim2,
			TextTransparency = 1,
			Rotation = v326
		}):Play()
        task.delay(p73 + 0.1, function()
            pcall(function()
                TextLabel:Destroy()
            end)
        end)
    end
    task.spawn(function()
        while true do
            local v327 = ScreenGui

            if v327 then
                v327 = ScreenGui.Parent
            end

            if not v327 then
                break
            end

            task.wait(random2:NextNumber(0.9, 1.8))
            pcall(v266, Frame3, 11, random2:NextNumber(0.05, 0.9), random2:NextInteger(14, 22), random2:NextNumber(4, 6.5), 0.4)
        end
    end)
    task.spawn(function()
        while true do
            local v328 = ScreenGui

            if v328 then
                v328 = ScreenGui.Parent
            end

            if not v328 then
                break
            end

            task.wait(random2:NextNumber(0.5, 1.1))
            pcall(v266, Frame, 4, random2:NextNumber(0.03, 0.97), random2:NextInteger(20, 38), random2:NextNumber(6, 10), 0.55)
        end
    end)
    task.spawn(function()
        while true do
            local v329 = ScreenGui

            if v329 then
                v329 = ScreenGui.Parent
            end

            if not v329 then
                break
            end

            task.wait(random2:NextNumber(2.5, 5))
            pcall(function()
                local v353 = random2:NextNumber(0.08, 0.9)
                local TextLabel = Instance.new("TextLabel", Frame)

                TextLabel.Size = UDim2.fromOffset(32, 32)
                TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                TextLabel.Position = UDim2.new(-0.05, 0, v353, 0)
                TextLabel.BackgroundTransparency = 1
                TextLabel.Text = "🦇"
                TextLabel.TextSize = random2:NextInteger(20, 34)
                TextLabel.ZIndex = 4

                local v355 = random2:NextNumber(2.2, 3.6)
                local value43 = t2.value43
                local tweenInfo = TweenInfo.new(v355, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                local Create = value43.Create
                local uDim2 = UDim2.new(1.05, 0, math.clamp(v353 + random2:NextNumber(-0.15, 0.15), 0.05, 0.95), 0)
                local v360 = random2:NextInteger(-25, 25)

                Create(value43, TextLabel, tweenInfo, {
					Position = uDim2,
					Rotation = v360
				}):Play()
                task.delay(v355 + 0.1, function()
                    pcall(function()
                        TextLabel:Destroy()
                    end)
                end)
            end)
        end
    end)
    local TextButton = Instance.new("TextButton", Frame3)
    TextButton.Size = UDim2.new(0, 30, 0, 30)
    TextButton.Position = UDim2.new(1, -35, 0, 29)
    TextButton.BackgroundTransparency = 1
    TextButton.Text = "☠"
    TextButton.TextColor3 = Color3.fromRGB(232, 190, 150)
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 24
    TextButton.ZIndex = 10
    TextButton.MouseEnter:Connect(function()
        t2.value43:Create(TextButton, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(255, 83, 105),
			Rotation = 8
		}):Play()
    end)
    TextButton.MouseLeave:Connect(function()
        t2.value43:Create(TextButton, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(232, 190, 150),
			Rotation = 0
		}):Play()
    end)
    TextButton.MouseButton1Click:Connect(function()
        t2.value43:Create(Frame3, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Size = UDim2.new(0.88, 0, 0, 0),
			BackgroundTransparency = 1
		}):Play()
        task.delay(0.24, function()
            local v361 = ScreenGui

            if v361 then
                v361 = ScreenGui.Parent
            end

            if v361 then
                ScreenGui:Destroy()
            end
        end)
    end)
    local TextLabel = Instance.new("TextLabel", Frame3)
    TextLabel.Size = UDim2.new(1, -46, 0, 30)
    TextLabel.Position = UDim2.fromOffset(18, 29)
    TextLabel.Text = "🎃 " .. t2.value1.HubName
    TextLabel.BackgroundTransparency = 1
    TextLabel.TextColor3 = Color3.fromRGB(255, 117, 24)
    TextLabel.Font = Enum.Font.Creepster
    TextLabel.TextSize = 24
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 12
    local TextLabel2 = Instance.new("TextLabel", Frame3)
    TextLabel2.Size = UDim2.new(1, -36, 0, 24)
    TextLabel2.Position = UDim2.fromOffset(18, 59)
    TextLabel2.BackgroundTransparency = 1
    TextLabel2.Text = string.upper(t2.value1.HubDescription)
    TextLabel2.TextColor3 = Color3.fromRGB(232, 190, 150)
    TextLabel2.Font = Enum.Font.GothamSemibold
    TextLabel2.TextSize = 10
    TextLabel2.TextWrapped = true
    TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel2.ZIndex = 12
    local TextLabel3 = Instance.new("TextLabel", Frame3)
    TextLabel3.Size = UDim2.fromOffset(132, 20)
    TextLabel3.Position = UDim2.new(1, -154, 0, 61)
    TextLabel3.BackgroundColor3 = Color3.fromRGB(30, 40, 14)
    TextLabel3.Text = "💀  SECURE GATEWAY"
    TextLabel3.TextColor3 = Color3.fromRGB(120, 245, 70)
    TextLabel3.Font = Enum.Font.GothamBold
    TextLabel3.TextSize = 8
    TextLabel3.ZIndex = 13
    Instance.new("UICorner", TextLabel3).CornerRadius = UDim.new(0, 8)
    local function v271(p75)
        local UIStroke2 = Instance.new("UIStroke", p75)

        UIStroke2.Thickness = 1.2
        UIStroke2.Transparency = 0.05
        UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        task.spawn(function()
            while true do
                local v362 = UIStroke2

                if v362 then
                    v362 = UIStroke2.Parent
                end

                if not v362 then
                    break
                end

                local v363 = os.clock() * 0.12 % 1

                UIStroke2.Color = Color3.fromRGB(255, 117, 24):Lerp(Color3.fromRGB(120, 255, 70), (math.sin(v363 * math.pi * 2) + 1) / 2 * 0.7)
                task.wait(0.06)
            end
        end)

        return UIStroke2
    end
    local function v272(p76, p77, p78)
        p76.AutoButtonColor = false
        p76.ZIndex = 12

        local UIScale2 = Instance.new("UIScale", p76)

        UIScale2.Scale = 1
        p76.MouseEnter:Connect(function()
            t2.value43:Create(p76, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundColor3 = p78
			}):Play()
            t2.value43:Create(UIScale2, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Scale = 1.015
			}):Play()
        end)
        p76.MouseLeave:Connect(function()
            t2.value43:Create(p76, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				BackgroundColor3 = p77
			}):Play()
            t2.value43:Create(UIScale2, TweenInfo.new(0.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Scale = 1
			}):Play()
        end)
        p76.MouseButton1Down:Connect(function()
            t2.value43:Create(UIScale2, TweenInfo.new(0.08), {
				Scale = 0.97
			}):Play()
        end)
        p76.MouseButton1Up:Connect(function()
            t2.value43:Create(UIScale2, TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
				Scale = 1.015
			}):Play()
        end)
    end
    local n9 = 105
    if t2.value1.ShowDiscord then
        local TextButton2 = Instance.new("TextButton", Frame3)

        TextButton2.Size = UDim2.new(0.85, 0, 0, 35)
        TextButton2.Position = UDim2.new(0.075, 0, 0, n9)
        TextButton2.Text = "      👻 JOIN DISCORD"
        TextButton2.Font = Enum.Font.GothamBold
        TextButton2.TextSize = 11
        TextButton2.BackgroundColor3 = Color3.fromRGB(60, 26, 70)
        TextButton2.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", TextButton2).CornerRadius = UDim.new(0, 10)
        v271(TextButton2)
        v272(TextButton2, Color3.fromRGB(60, 26, 70), Color3.fromRGB(86, 36, 98))

        local ImageLabel = Instance.new("ImageLabel", TextButton2)

        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Position = UDim2.new(0.1, 0, 0.5, -10)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://18505728201"
        TextButton2.MouseButton1Click:Connect(function()
            t2.value36(t2.value1.DiscordURL)

            local StatusLabel = Frame3:FindFirstChild("StatusLabel")

            if StatusLabel then
                StatusLabel.Text = "Discord Link Copied!"
                StatusLabel.TextColor3 = Color3.fromRGB(88, 101, 242)
            end

            local match = string.match(t2.value1.DiscordURL, "discord%.gg/([%w-]+)")
            local _syn = syn

            if _syn then
                _syn = syn.request and match
            end

            if _syn then
                syn.request({
					Url = "http://localhost:1111/discord?invite=" .. match,
					Method = "GET"
				})
            end
        end)
        n9 += 45
    end
    if t2.value1.ShowInstagram then
        local TextButton3 = Instance.new("TextButton", Frame3)

        TextButton3.Size = UDim2.new(0.85, 0, 0, 35)
        TextButton3.Position = UDim2.new(0.075, 0, 0, n9)
        TextButton3.Text = "      🕸\239\184\143 FOLLOW INSTAGRAM"
        TextButton3.Font = Enum.Font.GothamBold
        TextButton3.TextSize = 11
        TextButton3.BackgroundColor3 = Color3.fromRGB(96, 42, 10)
        TextButton3.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 10)
        v271(TextButton3)
        v272(TextButton3, Color3.fromRGB(96, 42, 10), Color3.fromRGB(140, 60, 14))

        local ImageLabel = Instance.new("ImageLabel", TextButton3)

        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Position = UDim2.new(0.1, 0, 0.5, -10)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://18355586382"
        TextButton3.MouseButton1Click:Connect(function()
            t2.value36(t2.value1.InstagramURL)

            local StatusLabel = Frame3:FindFirstChild("StatusLabel")

            if StatusLabel then
                StatusLabel.Text = "Instagram Link Copied!"
                StatusLabel.TextColor3 = Color3.fromRGB(225, 48, 108)
            end
        end)
        n9 += 45
    end
    if t2.value1.ShowYoutube then
        local TextButton4 = Instance.new("TextButton", Frame3)

        TextButton4.Size = UDim2.new(0.85, 0, 0, 35)
        TextButton4.Position = UDim2.new(0.075, 0, 0, n9)
        TextButton4.Text = "      💀 SUBSCRIBE YOUTUBE"
        TextButton4.Font = Enum.Font.GothamBold
        TextButton4.TextSize = 11
        TextButton4.BackgroundColor3 = Color3.fromRGB(70, 16, 30)
        TextButton4.TextColor3 = Color3.new(1, 1, 1)
        Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 10)
        v271(TextButton4)
        v272(TextButton4, Color3.fromRGB(70, 16, 30), Color3.fromRGB(110, 26, 44))

        local ImageLabel = Instance.new("ImageLabel", TextButton4)

        ImageLabel.Size = UDim2.new(0, 20, 0, 20)
        ImageLabel.Position = UDim2.new(0.1, 0, 0.5, -10)
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.Image = "rbxassetid://82532989017804"
        TextButton4.MouseButton1Click:Connect(function()
            t2.value36(t2.value1.YoutubeURL)

            local StatusLabel = Frame3:FindFirstChild("StatusLabel")

            if StatusLabel then
                StatusLabel.Text = "YouTube Link Copied!"
                StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
            end
        end)
        n9 += 45
    end
    local TextBox = Instance.new("TextBox", Frame3)
    TextBox.Size = UDim2.new(0.85, 0, 0, 40)
    TextBox.Position = UDim2.new(0.075, 0, 0, n9 + 15)
    TextBox.PlaceholderText = "SPEAK THE KEY, MORTAL... 💀"
    TextBox.Text = ""
    TextBox.Font = Enum.Font.GothamSemibold
    TextBox.TextSize = 12
    TextBox.BackgroundColor3 = Color3.fromRGB(26, 13, 28)
    TextBox.TextColor3 = Color3.fromRGB(255, 238, 215)
    TextBox.PlaceholderColor3 = Color3.fromRGB(176, 128, 98)
    TextBox.ClearTextOnFocus = false
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ZIndex = 12
    Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 10)
    local UIPadding = Instance.new("UIPadding", TextBox)
    UIPadding.PaddingLeft = UDim.new(0, 14)
    UIPadding.PaddingRight = UDim.new(0, 14)
    local UIStroke3 = Instance.new("UIStroke", TextBox)
    UIStroke3.Color = Color3.fromRGB(96, 46, 28)
    UIStroke3.Thickness = 1
    TextBox.Focused:Connect(function()
        t2.value43:Create(UIStroke3, TweenInfo.new(0.18), {
			Color = Color3.fromRGB(255, 160, 50),
			Thickness = 1.5
		}):Play()
    end)
    TextBox.FocusLost:Connect(function()
        t2.value43:Create(UIStroke3, TweenInfo.new(0.18), {
			Color = Color3.fromRGB(96, 46, 28),
			Thickness = 1
		}):Play()
    end)
    local TextButton5 = Instance.new("TextButton", Frame3)
    TextButton5.Size = UDim2.new(0.4, 0, 0, 40)
    TextButton5.Position = UDim2.new(0.075, 0, 0, n9 + 65)
    TextButton5.Text = "🎃  VERIFY KEY"
    TextButton5.Font = Enum.Font.GothamBold
    TextButton5.TextSize = 10
    TextButton5.BackgroundColor3 = Color3.fromRGB(255, 117, 24)
    TextButton5.TextColor3 = Color3.new(1, 1, 1)
    TextButton5.ZIndex = 12
    Instance.new("UICorner", TextButton5).CornerRadius = UDim.new(0, 10)
    local UIGradient5 = Instance.new("UIGradient", TextButton5)
    UIGradient5.Color = ColorSequence.new(Color3.fromRGB(255, 160, 50), Color3.fromRGB(170, 60, 5))
    UIGradient5.Rotation = 0
    v272(TextButton5, Color3.fromRGB(255, 117, 24), Color3.fromRGB(255, 140, 40))
    local UIStroke4 = Instance.new("UIStroke", TextButton5)
    UIStroke4.Color = Color3.fromRGB(255, 170, 70)
    UIStroke4.Transparency = 0.45
    UIStroke4.Thickness = 1
    local TextButton6 = Instance.new("TextButton", Frame3)
    TextButton6.Size = UDim2.new(0.4, 0, 0, 40)
    TextButton6.Position = UDim2.new(0.525, 0, 0, n9 + 65)
    TextButton6.Text = "🗝\239\184\143  GET KEY"
    TextButton6.Font = Enum.Font.GothamBold
    TextButton6.TextSize = 10
    TextButton6.BackgroundColor3 = Color3.fromRGB(34, 16, 30)
    TextButton6.TextColor3 = Color3.new(1, 1, 1)
    TextButton6.ZIndex = 12
    Instance.new("UICorner", TextButton6).CornerRadius = UDim.new(0, 10)
    local UIStroke5 = Instance.new("UIStroke", TextButton6)
    UIStroke5.Color = Color3.fromRGB(150, 76, 30)
    UIStroke5.Thickness = 1
    v272(TextButton6, Color3.fromRGB(34, 16, 30), Color3.fromRGB(56, 26, 22))
    local TextLabel4 = Instance.new("TextLabel", Frame3)
    TextLabel4.Name = "StatusLabel"
    TextLabel4.Size = UDim2.new(1, -36, 0, 30)
    TextLabel4.Position = UDim2.fromOffset(18, n9 + 115)
    TextLabel4.BackgroundTransparency = 1
    TextLabel4.Text = "THE CRYPT AWAITS  /  ENTER YOUR KEY 👻"
    TextLabel4.TextColor3 = Color3.fromRGB(176, 96, 255)
    TextLabel4.Font = Enum.Font.GothamSemibold
    TextLabel4.TextSize = 10
    TextLabel4.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel4.ZIndex = 12
    local Frame8 = Instance.new("Frame", Frame3)
    Frame8.Size = UDim2.new(1, -36, 0, 1)
    Frame8.Position = UDim2.fromOffset(18, n9 + 146)
    Frame8.BackgroundColor3 = Color3.fromRGB(96, 46, 28)
    Frame8.BorderSizePixel = 0
    Frame8.ZIndex = 12
    local TextLabel5 = Instance.new("TextLabel", Frame3)
    TextLabel5.Size = UDim2.new(1, -36, 0, 18)
    TextLabel5.Position = UDim2.fromOffset(18, n9 + 154)
    TextLabel5.BackgroundTransparency = 1
    TextLabel5.Text = "🦇  LP10  /  HALLOWEEN EDITION  /  SECURE ACCESS  🦇"
    TextLabel5.TextColor3 = Color3.fromRGB(176, 128, 98)
    TextLabel5.Font = Enum.Font.GothamBold
    TextLabel5.TextSize = 8
    TextLabel5.TextXAlignment = Enum.TextXAlignment.Center
    TextLabel5.ZIndex = 12
    Frame3.Size = UDim2.new(0.88, 0, 0, n9 + 184)
    TextButton5.MouseButton1Click:Connect(function()
        local TextBoxText = TextBox.Text

        if TextBoxText == "" then
            TextLabel4.Text = "ERROR  /  ENTER A KEY FIRST"
            TextLabel4.TextColor3 = Color3.fromRGB(255, 156, 40)

            return
        end

        TextButton5.Active = false
        TextButton5.Text = "🕯\239\184\143  SUMMONING..."
        TextLabel4.Text = "SECURE CHECK  /  CONTACTING SERVER..."
        TextLabel4.TextColor3 = Color3.fromRGB(255, 190, 110)

        local ok, result, v344 = pcall(t2.value50, TextBoxText)

        if not ok then
            result = false
            v344 = "Verification error. Please try again."
        end

        if result then
            TextLabel4.Text = "ACCESS GRANTED  /  RAISING THE SPIRITS 🎃"
            TextLabel4.TextColor3 = Color3.fromRGB(120, 245, 70)
            task.wait(0.5)
            ScreenGui:Destroy()
            t2.value51()

            return
        end

        TextButton5.Active = true
        TextButton5.Text = "🎃  VERIFY KEY"
        TextLabel4.Text = "ACCESS DENIED  /  " .. tostring(v344)
        TextLabel4.TextColor3 = Color3.fromRGB(255, 83, 105)
    end)
    TextButton6.MouseButton1Click:Connect(function()
        TextLabel4.Text = "REQUESTING  /  GENERATING YOUR KEY LINK..."
        TextLabel4.TextColor3 = Color3.fromRGB(255, 190, 110)

        local ok, result, v347 = pcall(t2.value49)

        if not ok then
            result = false
            v347 = "Unable to reach the key service."
        end

        if result then
            t2.value36(v347)
            TextLabel4.Text = "LINK COPIED  /  OPEN IT TO GET YOUR KEY"
            TextLabel4.TextColor3 = Color3.fromRGB(120, 245, 70)

            return
        end

        TextLabel4.Text = "REQUEST FAILED  /  " .. tostring(v347)
        TextLabel4.TextColor3 = Color3.fromRGB(255, 83, 105)
    end)
    local _isfile = isfile
    if _isfile then
        _isfile = isfile(t2.value1.KeyFileName)
    end
    if _isfile then
        local v292 = readfile(t2.value1.KeyFileName)

        if v292 ~= "" then
            TextLabel4.Text = "SAVED KEY FOUND  /  VERIFYING..."
            TextLabel4.TextColor3 = Color3.fromRGB(255, 190, 110)
            task.spawn(function()
                local _pcall = pcall
                local v349 = v292
                local v350, v351, _ = _pcall(t2.value50, v349)

                if not v350 then
                    v351 = false
                end

                if v351 then
                    TextLabel4.Text = "AUTO-LOGIN SUCCESS  /  THE SPIRITS RISE 🎃"
                    TextLabel4.TextColor3 = Color3.fromRGB(120, 245, 70)
                    task.wait(0.5)
                    ScreenGui:Destroy()
                    t2.value51()

                    return
                end

                TextLabel4.Text = "SAVED KEY EXPIRED  /  ENTER A NEW KEY 🕯\239\184\143"
                TextLabel4.TextColor3 = Color3.fromRGB(255, 150, 0)
            end)
        end
    end
    local Frame3Size = Frame3.Size
    Frame3.Size = UDim2.new(Frame3Size.X.Scale, Frame3Size.X.Offset, 0, 0)
    Frame3.BackgroundTransparency = 1
    t2.value43:Create(Frame3, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = Frame3Size,
		BackgroundTransparency = 0
	}):Play()
end)()
