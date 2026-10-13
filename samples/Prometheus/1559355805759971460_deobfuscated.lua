-- This file was generated at discord.gg/syncrypt

local v2 = unpack or table.unpack
local ffi = require("ffi")
local t1 = {}
local t2 = {
	NOACCESS = 0,
	READONLY = 1,
	READWRITE = 3,
	EXECUTE = 4,
	EXECUTE_READ = 5,
	EXECUTE_READWRITE = 7
}
local v6 = ffi.typeof("void*")
local t3 = {}
local t4 = {}
ffi.cdef("int mprotect(void* addr, size_t len, int prot);\nint memcmp(const void* ptr1, const void* ptr2, size_t num);\n")
local function v9(p1, p2, p3, p4)
    local v19 = ffi.cast("uintptr_t", p1)
    local v20 = bit.band(v19, 4294963200)
    local v21 = ffi.cast(v6, v20)
    local v22 = bit.lshift(bit.rshift(v19 + p2 - v20 + 4095, 12), 12)
    local v23 = ffi.C.mprotect(v21, v22, p3)

    if v23 ~= 0 then
    end

    if v23 ~= 0 then
        if p4 then
            print("memory: mprotect failed, errno = ", ffi.errno())
        end

        return nil
    end

    return 0
end
local function v10(p5, p6)
    local v26 = v9(p5, p6, t2.EXECUTE_READWRITE, false)

    if v26 == nil then
    end

    if v26 == nil then
        local t5 = { v9(p5, p6, t2.READWRITE, true) }

        return v2(t5)
    end

    return v26
end
local function v11(p7, p8, p9)
    if p9 then
        return v10(p7, p8)
    end
end
local function v12(p10, p11)
    local num = tonumber(ffi.cast("uintptr_t", p10))

    if t3[num] then

        return
    end

    local v39 = ffi.new("uint8_t[?]", p11)

    ffi.copy(v39, p10, p11)
    t3[num] = {
		addr = p10,
		size = p11,
		value = v39
	}
end
function backup(p12, p13)
    if backups[p12] then
        return
    end

    local v42 = ffi.new("uint8_t[?]", p13)

    ffi.copy(v42, p12, p13)
    backups[p12] = {
		size = p13,
		value = v42
	}
end
function t1.restore(...)
    local t6 = { ... }
    local v44 = false

    for i = 1, select("#", v2(t6)) do
        local v46 = select(i, v2(t6))

        if v46 then
            local num = tonumber(ffi.cast("uintptr_t", v46))
            local v48 = t3[num]

            if v48 then
                ffi.copy(v48.addr, v48.value, v48.size)
                t3[num] = nil
                v44 = true
            end
        end
    end

    return v44
end
function t1.stop()

    for v51, v52 in pairs(t4) do

        t1.restore(v51)
    end
    t4 = {}
end
function t1.read(p14, p15, p16)
    if p15 > 0 then
        if p15 > 8 then
            p15 = 8
        end

        local v56 = ffi.cast(v6, p14)
        local v57 = ffi.new("int64_t[1]")

        if not p16 or v11(v56, p15, p16) ~= nil then
            ffi.copy(v57, v56, p15)

            if p15 <= 4 then
                return tonumber(v57[0])
            end

            return v57[0]
        end
    end
end
function t1.write(p17, p18, p19, p20)
    if p19 > 0 then
        if p19 > 8 then
            p19 = 8
        end

        local v69 = ffi.cast(v6, p17)

        v12(v69, p19)

        local v70 = ffi.new("int64_t[1]", p18)

        if not p20 or v11(v69, p19, p20) ~= nil then
            ffi.copy(v69, v70, p19)
        end
    end
end
function t1.unprotect(p21, p22)
    local t7 = { v10(ffi.cast(v6, p21), p22) }

    return v2(t7)
end
function t1.protect(p23, p24, p25)
    local t8 = { v9(ffi.cast(v6, p23), p24, p25, true) }

    return v2(t8)
end
function t1.copy(p26, p27, p28, p29)
    local v82 = ffi.cast(v6, p26)
    local v83 = type(p27)
    if v83 ~= "string" then
    end
    if v83 ~= "string" then
        p27 = ffi.cast(v6, p27)
    end
    v12(v82, p28)
    if not p29 or v11(v82, p28, p29) ~= nil then
        ffi.copy(v82, p27, p28)
    end
end
function t1.fill(p30, p31, p32, p33)
    local v89 = ffi.cast(v6, p30)

    v12(v89, p32)

    if not p33 or v11(v89, p32, p33) ~= nil then
        ffi.fill(v89, p32, p31)
    end
end
function t1.tostring(p34, p35, p36)
    local v93 = not p36
    local v94 = ffi.cast(v6, p34)
    local v95 = v11(v94, p35, p36)

    if not v93 then
        v93 = v95 ~= nil
    end

    if v93 then
        return (ffi.string(v94, p35))
    end
end
function t1.compare(p37, p38, p39)
    local v99 = ffi.cast(v6, p37)
    local v100 = ffi.cast(v6, p38)

    return ffi.C.memcmp(v99, v100, p39) == 0
end
function t1.strptr(p40)
    local t9 = { (tonumber(ffi.cast("uintptr_t", ffi.cast("const char*", p40)))) }

    return v2(t9)
end
function t1.tohex(p41, p42, p43)
    local v106 = not p43
    local v107 = ffi.cast("const uint8_t*", p41)
    local v108 = v11(v107, p42, p43)

    if not v106 then
        v106 = v108 ~= nil
    end

    if v106 then
        local t10 = {}

        for i = 0, p42 - 1 do

            t10[#t10 + 1] = bit.tohex(v107[i], 2)
        end

        local t11 = { table.concat(t10):upper() }

        return v2(t11)
    end
end
function t1.hex2bin(p44, p45, p46)
    if #p44 == 0 or #p44 % 2 ~= 0 then
        return false
    end

    if p45 then
        if not p46 or p46 == 0 then
            return false
        end

        local v116 = ffi.cast("uint8_t*", p45)
        local v117 = #p44
        local n1 = 0
        local v119 = false
        local n2 = -1

        repeat
            n2 += 2

            if not (v119 and v117 <= n2 or not v119 and n2 <= v117) then
                return true
            end

            local num = tonumber(p44:sub(n2, n2 + 1), 16)

            if not num then
                return false
            end

            v116[n1] = num
            n1 += 1

            if p46 <= n1 then
            end
        until p46 <= n1

        return true
    end

    local t12 = {}

    for i = 1, #p44, 2 do
        local num = tonumber(p44:sub(i, i + 1), 16)

        if not num then
            return nil
        end

        t12[#t12 + 1] = string.char(num)
    end

    local t13 = { table.concat(t12) }

    return v2(t13)
end
local function v13(p47, p48, p49)
    local v129 = ffi.cast(v6, p48)
    local v130 = ffi.sizeof(p47)

    if not p49 or v11(v129, v130, p49) ~= nil then
        return ffi.cast(p47 .. "*", v129)[0]
    end
end
local function v14(p50, p51, p52, p53)
    local v135 = ffi.cast(v6, p51)
    local v136 = ffi.sizeof(p50)

    if not t4[v135] then
        v12(v135, v136)
        t4[v135] = v136
    end

    if not p53 or v11(v135, v136, p53) ~= nil then
        ffi.cast(p50 .. "*", v135)[0] = p52
    end
end
t1.getvalue = v13
t1.setvalue = v14
function t1.getint8(p54, p55)
    return v13("int8_t", p54, p55)
end
function t1.getint16(p56, p57)
    return v13("int16_t", p56, p57)
end
function t1.getint32(p58, p59)
    return v13("int32_t", p58, p59)
end
function t1.getint64(p60, p61)
    return v13("int64_t", p60, p61)
end
function t1.getuint8(p62, p63)
    local t14 = { v13("uint8_t", p62, p63) }

    return v2(t14)
end
function t1.getuint16(p64, p65)
    return v13("uint16_t", p64, p65)
end
function t1.getuint32(p66, p67)
    local t15 = { v13("uint32_t", p66, p67) }

    return v2(t15)
end
function t1.getuint64(p68, p69)
    return v13("uint64_t", p68, p69)
end
function t1.getfloat(p70, p71)
    return v13("float", p70, p71)
end
function t1.getdouble(p72, p73)
    local t16 = { v13("double", p72, p73) }

    return v2(t16)
end
function t1.setint8(p74, p75, p76)
    return v14("int8_t", p74, p75, p76)
end
function t1.setint16(p77, p78, p79)
    local t17 = { v14("int16_t", p77, p78, p79) }

    return v2(t17)
end
function t1.setint32(p80, p81, p82)
    return v14("int32_t", p80, p81, p82)
end
function t1.setint64(p83, p84, p85)
    return v14("int64_t", p83, p84, p85)
end
function t1.setuint8(p86, p87, p88)
    return v14("uint8_t", p86, p87, p88)
end
function t1.setuint16(p89, p90, p91)
    return v14("uint16_t", p89, p90, p91)
end
function t1.setuint32(p92, p93, p94)
    return v14("uint32_t", p92, p93, p94)
end
function t1.setuint64(p95, p96, p97)
    return v14("uint64_t", p95, p96, p97)
end
function t1.setfloat(p98, p99, p100)
    return v14("float", p98, p99, p100)
end
function t1.setdouble(p101, p102, p103)
    return v14("double", p101, p102, p103)
end
t1.pageaccess = t2
addEventHandler("onScriptTerminate", function(p104)
    local this = script.this
    if p104 == this then
    end
    if p104 == this then

        for v62, v63 in pairs(t3) do

            ffi.copy(v63.addr, v63.value, v63.size)
        end
        t3 = {}
    end
end)
script_name("Fast Crosshair - Mira Instantânea")
script_author("P.E.I.X.E")
script_dependencies("Monetloader 3.6.0-Os")
script_description("Fast Crosshair - Remove a animação da mira e deixa ela instantânea, melhorando a rapidez na hora de mirar.")
script_url("https://discord.gg/X33UB9tTgZ")
function main()
    if MONET_VERSION == 3008000 then
        t1.copy(MONET_GTASA_BASE + 5359588, "\191\214\001q", 4, true)
    elseif MONET_VERSION == 3006000 then
        t1.copy(MONET_GTASA_BASE + 4420354, "O\240\001\002", 4, true)
    end

    while true do
        wait(0)
    end
end
function onExitScript()
    if MONET_VERSION == 3008000 then
        t1.restore(MONET_GTASA_BASE + 5359588)

        return
    end

    if MONET_VERSION == 3006000 then
        t1.restore(MONET_GTASA_BASE + 4420354)
    end
end
