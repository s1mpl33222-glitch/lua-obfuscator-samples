local v8 = (6 - 4) ^ (485 - (109 + 344))
local v9 = v8 - (1665 - (1269 + 395))
local function v10(v360, v361)
    local v362 = 492 - (76 + 416)
    local v363
    local v364
    while true do
        local v1111 = 0
        while true do
            if v1111 == (443 - (319 + 124)) then
                if v362 == (0 - 0) then
                    v363, v364 = 0, 1008 - (564 + 443)
                    while (v360 ~= 0) or (v361 ~= (0 - 0)) do
                        local v1501, v1502 = v360 % (460 - (337 + 121)), v361 % (5 - 3)
                        local v1503 = (v1501 + v1502) % 2
                        v363 = v363 + (v1503 * v364)
                        v360 = math.floor(v360 / (6 - 4))
                        v361 = math.floor(v361 / 2)
                        v364 = v364 * 2
                    end
                    v362 = 1912 - (1261 + 650)
                end
                if v362 == 1 then
                    return v363 % v8
                end
                break
            end
        end
    end
end
local function v11(v365, v366, v367, ...)
    local v368 = 0
    local v369
    while true do
        if v368 == 0 then
            v369 = nil
            if v366 then
                local v1373 = 0 + 0
                while true do
                    if v1373 == 1 then
                        v369 = v10(v365, v366)
                        if v367 then
                            v369 = v11(v369, v367, ...)
                        end
                        v1373 = 2 - 0
                    end
                    if v1373 == 2 then
                        return v369
                    end
                    if v1373 == (1817 - (772 + 1045)) then
                        v365 = v365 % v8
                        v366 = v366 % v8
                        v1373 = 1 + 0
                    end
                end
            elseif v365 then
                return v365 % v8
            else
                return 144 - (102 + 42)
            end
            break
        end
    end
end
local function v12(v370, v371, v372, ...)
    local v373
    if v371 then
        local v1208 = 1844 - (1524 + 320)
        while true do
            local v1230 = 0
            while true do
                if (1271 - (1049 + 221)) == v1230 then
                    if v1208 == (158 - (18 + 138)) then
                        return v373
                    end
                    break
                end
                if v1230 == (0 - 0) then
                    if v1208 == 0 then
                        v370 = v370 % v8
                        v371 = v371 % v8
                        v1208 = 1103 - (67 + 1035)
                    end
                    if 1 == v1208 then
                        v373 = ((v370 + v371) - v10(v370, v371)) / 2
                        if v372 then
                            v373 = v12(v373, v372, ...)
                        end
                        v1208 = 350 - (136 + 212)
                    end
                    v1230 = 1
                end
            end
        end
    elseif v370 then
        return v370 % v8
    else
        return v9
    end
end
local function v13(v374)
    return v9 - v374
end
local function v14(v375, v376)
    local v377 = 0
    local v378
    while true do
        if v377 == (0 - 0) then
            v378 = 0
            while true do
                if v378 == 0 then
                    local v1423 = 0 + 0
                    while true do
                        if 0 == v1423 then
                            if v376 >= (0 + 0) then
                            else
                                return lshift(v375, -v376)
                            end
                            return math.floor((v375 % ((1606 - (240 + 1364)) ^ 32)) / (2 ^ v376))
                        end
                    end
                end
            end
            break
        end
    end
end
local function v15(v379, v380)
    local v381 = 1082 - (1050 + 32)
    local v382
    while true do
        if v381 == (0 - 0) then
            v382 = 0
            while true do
                if v382 == 0 then
                    local v1424 = 0
                    local v1425
                    while true do
                        if 0 == v1424 then
                            v1425 = 0 + 0
                            while true do
                                if v1425 == (1055 - (331 + 724)) then
                                    if (v380 > (3 + 28)) or (v380 < -(675 - (269 + 375))) then
                                        return 0
                                    end
                                    return v14(v379 % v8, v380)
                                end
                            end
                            break
                        end
                    end
                end
            end
            break
        end
    end
end
local function v16(v383, v384)
    local v385 = 725 - (267 + 458)
    while true do
        if (0 + 0) == v385 then
            if v384 >= 0 then
            else
                return v15(v383, -v384)
            end
            return (v383 * ((3 - 1) ^ v384)) % (2 ^ (850 - (667 + 151)))
        end
    end
end
local function v17(v386, v387)
    local v388 = 1497 - (1410 + 87)
    local v389
    while true do
        if (1897 - (1504 + 393)) == v388 then
            v386 = v386 % v8
            v387 = v387 % 32
            v388 = 1
        end
        if 1 == v388 then
            local v1231 = 0 - 0
            local v1232
            while true do
                if v1231 == (0 - 0) then
                    v1232 = 0
                    while true do
                        if v1232 == 0 then
                            v389 = v12(v386, ((798 - (461 + 335)) ^ v387) - (1 + 0))
                            return v15(v386, v387) + v16(v389, (1793 - (1730 + 31)) - v387)
                        end
                    end
                    break
                end
            end
        end
    end
end
local v18 = {
    2888274940 - 1771922532,
    2899786576 - 1000339135,
    3049324539 - (138 + 930),
    3921009573,
    824454379 + 137532784,
    1508972759 - (459 + 1307),
    2453635748,
    2870763221 - 0,
    3624381080 - 0,
    310598401,
    996828253 - 389602975,
    1426882578 - (562 + 29),
    1925079807 - (374 + 1045),
    2162079779 - (1449 + 124),
    3292649639 - 677761536,
    4278635391 - 1030412811,
    5854685661 - 2019295260,
    4022226268 - (1307 + 187),
    618947977 - 354600899,
    1854476820 - 1249669192,
    770255983,
    1192776205 + 56373917,
    1373735522 + 181346170,
    3547554250 - 1551489264,
    2554221471 - (498 + 91),
    2821834349,
    2952996808,
    3210313671,
    3336571891,
    3499070720 - -85457991,
    113926993,
    338241895,
    666307205,
    2699401212 - 1925871300,
    1294757372,
    2884331000 - 1488148709,
    1695183700,
    1986661051,
    2177026350 - 0,
    2456956037,
    2730486628 - (303 + 404),
    2820303837 - (85 + 1341),
    3259730800,
    3323554149 - -22210622,
    3516065817 - 0,
    3600353306 - (444 + 58),
    4261033738 - 166461829,
    275423344,
    1280238933 - 850011199,
    76930669 + 430017947,
    53538972 + 605521584,
    883998371 - (415 + 79),
    958139571,
    1322822218,
    658424925 + 878577138,
    1747873779,
    1955562222,
    2959589801 - 935484986,
    2227732316 - (1710 + 154),
    2361852424,
    2428436474,
    2756734187,
    3491824423 - 287792944,
    3329326033 - (11 + 724),
}
local function v19(v390)
    return string.gsub(v390, ".", function(v1112)
        return string.format("%02x", string.byte(v1112))
    end)
end
local function v20(v391, v392)
    local v393 = 0
    local v394
    while true do
        if (1 + 0) == v393 then
            return v394
        end
        if v393 == (0 + 0) then
            v394 = ""
            for v1310 = 2 - 1, v392 do
                local v1311 = 0
                local v1312
                while true do
                    if v1311 == (1250 - (363 + 887)) then
                        local v1504 = 0 - 0
                        while true do
                            if (4 - 3) == v1504 then
                                v1311 = 1 + 0
                                break
                            end
                            if v1504 == 0 then
                                v1312 = v391 % (598 - 342)
                                v394 = string.char(v1312) .. v394
                                v1504 = 1 + 0
                            end
                        end
                    end
                    if v1311 == (1665 - (674 + 990)) then
                        v391 = (v391 - v1312) / (74 + 182)
                        break
                    end
                end
            end
            v393 = 1
        end
    end
end
local function v21(v395, v396)
    local v397 = 0 + 0
    local v398
    while true do
        local v1113 = 0 - 0
        while true do
            if v1113 == (1055 - (507 + 548)) then
                if v397 == (837 - (289 + 548)) then
                    local v1426 = 1818 - (821 + 997)
                    while true do
                        if v1426 == (255 - (195 + 60)) then
                            v398 = 0 + 0
                            for v1556 = v396, v396 + (1504 - (251 + 1250)) do
                                v398 = (v398 * 256) + string.byte(v395, v1556)
                            end
                            v1426 = 2 - 1
                        end
                        if v1426 == (1 + 0) then
                            v397 = 1
                            break
                        end
                    end
                end
                if v397 == (1033 - (809 + 223)) then
                    return v398
                end
                break
            end
        end
    end
end
local function v22(v399, v400)
    local v401 = 0 - 0
    local v402
    while true do
        if 1 == v401 then
            v399 = v399 .. "\128" .. string.rep("\0", v402) .. v400
            return v399
        end
        if v401 == (0 - 0) then
            v402 = (211 - 147) - ((v400 + 7 + 2) % 64)
            v400 = v20((5 + 3) * v400, 625 - (14 + 603))
            v401 = 130 - (118 + 11)
        end
    end
end
local function v23(v403)
    local v404 = 0
    while true do
        local v1114 = 0 + 0
        while true do
            if v1114 == (0 + 0) then
                if v404 == (11 - 7) then
                    return v403
                end
                if v404 == (950 - (551 + 398)) then
                    v403[3] = 640758660 + 373145582
                    v403[4] = 2773482187 - (512 + 913)
                    v404 = 6 - 4
                end
                v1114 = 1 + 0
            end
            if v1114 == (1 + 0) then
                if v404 == 2 then
                    v403[19 - 14] = 375453191 + 984439928
                    v403[95 - (40 + 49)] = 2470003137 - -130819787
                    v404 = 402 - (266 + 133)
                end
                if (1443 - (1292 + 151)) == v404 then
                    v403[1 - 0] = 1779033703
                    v403[1423 - (494 + 927)] = 3144135809 - (347 + 1185)
                    v404 = 1593 - (373 + 1219)
                end
                v1114 = 2
            end
            if v1114 == (3 - 1) then
                if v404 == (3 + 0) then
                    v403[11 - 4] = 1269929368 - 741194733
                    v403[30 - 22] = 1541460531 - (913 + 393)
                    v404 = 4
                end
                break
            end
        end
    end
end
local function v24(v405, v406, v407)
    local v408 = {}
    for v1115 = 1, 45 - 29 do
        v408[v1115] = v21(v405, v406 + ((v1115 - 1) * 4))
    end
    for v1117 = 23 - 6, 474 - (269 + 141) do
        local v1118 = 0
        local v1119
        local v1120
        while true do
            if v1118 == (2 - 1) then
                v1119 = v408[v1117 - 2]
                v408[v1117] = (
                    v408[v1117 - (1997 - (362 + 1619))]
                    + v1120
                    + v408[v1117 - 7]
                    + v11(v17(v1119, 1642 - (950 + 675)), v17(v1119, 8 + 11), v15(v1119, 1189 - (216 + 963)))
                ) % v8
                break
            end
            if v1118 == (1287 - (485 + 802)) then
                v1119 = v408[v1117 - (574 - (432 + 127))]
                v1120 = v11(v17(v1119, 1080 - (1065 + 8)), v17(v1119, 10 + 8), v15(v1119, 1604 - (635 + 966)))
                v1118 = 1 + 0
            end
        end
    end
    local v409, v410, v411, v412, v413, v414, v415, v416 =
        v407[1], v407[2], v407[45 - (5 + 37)], v407[4], v407[12 - 7], v407[3 + 3], v407[10 - 3], v407[4 + 4]
    for v1121 = 1, 64 do
        local v1122 = 0
        local v1123
        local v1124
        local v1125
        local v1126
        local v1127
        local v1128
        while true do
            if v1122 == (1 - 0) then
                v1127 = v11(v12(v413, v414), v12(v13(v413), v415))
                v1128 = (v416 + v1126 + v1127 + v18[v1121] + v408[v1121]) % v8
                v416 = v415
                v415 = v414
                v1122 = 7 - 5
            end
            if v1122 == 3 then
                v410 = v409
                v409 = (v1128 + v1125) % v8
                break
            end
            if v1122 == 2 then
                v414 = v413
                v413 = (v412 + v1128) % v8
                v412 = v411
                v411 = v410
                v1122 = 3
            end
            if v1122 == 0 then
                v1123 = v11(v17(v409, 3 - 1), v17(v409, 13), v17(v409, 52 - 30))
                v1124 = v11(v12(v409, v410), v12(v409, v411), v12(v410, v411))
                v1125 = (v1123 + v1124) % v8
                v1126 = v11(v17(v413, 6), v17(v413, 8 + 3), v17(v413, 25))
                v1122 = 530 - (318 + 211)
            end
        end
    end
    v407[4 - 3] = (v407[1588 - (963 + 624)] + v409) % v8
    v407[2] = (v407[1 + 1] + v410) % v8
    v407[849 - (518 + 328)] = (v407[3] + v411) % v8
    v407[8 - 4] = (v407[6 - 2] + v412) % v8
    v407[322 - (301 + 16)] = (v407[14 - 9] + v413) % v8
    v407[16 - 10] = (v407[6] + v414) % v8
    v407[18 - 11] = (v407[7] + v415) % v8
    v407[8] = (v407[8] + v416) % v8
end
local function v25(v425)
    local v426 = 0 + 0
    local v427
    while true do
        if v426 == (1 + 0) then
            for v1316 = 1 - 0, #v425, 39 + 25 do
                v24(v425, v1316, v427)
            end
            return v19(
                v20(v427[1], 1 + 3)
                    .. v20(v427[2], 12 - 8)
                    .. v20(v427[3], 4)
                    .. v20(v427[2 + 2], 4)
                    .. v20(v427[1024 - (829 + 190)], 4)
                    .. v20(v427[6], 4)
                    .. v20(v427[24 - 17], 4 - 0)
                    .. v20(v427[10 - 2], 9 - 5)
            )
        end
        if 0 == v426 then
            v425 = v22(v425, #v425)
            v427 = v23({})
            v426 = 1
        end
    end
end
local v26
local v27 = { ["\\"] = "\\", ['"'] = '"', ["\b"] = "b", ["\f"] = "f", ["\n"] = "n", ["\r"] = "r", ["\t"] = "t" }
local v28 = { ["/"] = "/" }
for v428, v429 in pairs(v27) do
    v28[v429] = v428
end
local v29 = function(v431)
    return "\\" .. (v27[v431] or string.format("u%04x", v431:byte()))
end
local v30 = function(v432)
    return "null"
end
local v18 = function(v433, v434)
    local v435 = 0
    local v436
    while true do
        if v435 == (1 + 0) then
            if v434[v433] then
                error("circular reference")
            end
            v434[v433] = true
            v435 = 1 + 1
        end
        if v435 == (0 - 0) then
            local v1234 = 0 + 0
            while true do
                if v1234 == (614 - (520 + 93)) then
                    v435 = 277 - (259 + 17)
                    break
                end
                if v1234 == 0 then
                    v436 = {}
                    v434 = v434 or {}
                    v1234 = 1 + 0
                end
            end
        end
        if v435 == (1 + 1) then
            if (rawget(v433, 3 - 2) ~= nil) or (next(v433) == nil) then
                local v1374 = 591 - (396 + 195)
                local v1375
                while true do
                    if v1374 == 1 then
                        if v1375 == #v433 then
                        else
                            error("invalid table: sparse array")
                        end
                        for v1537, v1538 in ipairs(v433) do
                            table.insert(v436, v26(v1538, v434))
                        end
                        v1374 = 5 - 3
                    end
                    if v1374 == 0 then
                        v1375 = 0
                        for v1539 in pairs(v433) do
                            if type(v1539) == "number" then
                            else
                                error("invalid table: mixed or invalid key types")
                            end
                            v1375 = v1375 + (1762 - (440 + 1321))
                        end
                        v1374 = 1830 - (1059 + 770)
                    end
                    if v1374 == 2 then
                        local v1525 = 0
                        while true do
                            if v1525 == (0 - 0) then
                                v434[v433] = nil
                                return "[" .. table.concat(v436, ",") .. "]"
                            end
                        end
                    end
                end
            else
                local v1376 = 0
                while true do
                    local v1435 = 0
                    while true do
                        if v1435 == 0 then
                            if v1376 == (545 - (424 + 121)) then
                                for v1571, v1572 in pairs(v433) do
                                    local v1573 = 0
                                    local v1574
                                    while true do
                                        if v1573 == (0 + 0) then
                                            v1574 = 0
                                            while true do
                                                if v1574 == (1347 - (641 + 706)) then
                                                    if type(v1571) == "string" then
                                                    else
                                                        error("invalid table: mixed or invalid key types")
                                                    end
                                                    table.insert(v436, v26(v1571, v434) .. ":" .. v26(v1572, v434))
                                                    break
                                                end
                                            end
                                            break
                                        end
                                    end
                                end
                                v434[v433] = nil
                                v1376 = 1 + 0
                            end
                            if v1376 == (441 - (249 + 191)) then
                                return "{" .. table.concat(v436, ",") .. "}"
                            end
                            break
                        end
                    end
                end
            end
            break
        end
    end
end
local v31 = function(v437)
    return '"' .. v437:gsub('[%z\1-\31\\"]', v29) .. '"'
end
local v32 = function(v438)
    local v439 = 0 - 0
    while true do
        if v439 == (0 + 0) then
            local v1235 = 0
            while true do
                if v1235 == 0 then
                    if (v438 ~= v438) or (v438 <= -math.huge) or (v438 >= math.huge) then
                        error("unexpected number value '" .. tostring(v438) .. "'")
                    end
                    return string.format("%.14g", v438)
                end
            end
        end
    end
end
local v33 = { ["nil"] = v30, ["table"] = v18, ["string"] = v31, ["number"] = v32, ["boolean"] = tostring }
function v26(v440, v441)
    local v442 = type(v440)
    local v443 = v33[v442]
    if v443 then
        return v443(v440, v441)
    end
    error("unexpected type '" .. v442 .. "'")
end
local v34 = function(v444)
    return v26(v444)
end
local v35
local v36 = function(...)
    local v445 = {}
    for v1129 = 1, select("#", ...) do
        v445[select(v1129, ...)] = true
    end
    return v445
end
local v37 = v36(" ", "\t", "\r", "\n")
local v38 = v36(" ", "\t", "\r", "\n", "]", "}", ",")
local v39 = v36("\\", "/", '"', "b", "f", "n", "r", "t", "u")
local v40 = v36("true", "false", "null")
local v41 = { ["true"] = true, ["false"] = false, ["null"] = nil }
local v42 = function(v446, v447, v448, v449)
    local v450 = 0 - 0
    while true do
        if v450 == 0 then
            local v1236 = 0
            while true do
                if v1236 == (427 - (183 + 244)) then
                    for v1505 = v447, #v446 do
                        if v448[v446:sub(v1505, v1505)] ~= v449 then
                            return v1505
                        end
                    end
                    return #v446 + 1 + 0
                end
            end
        end
    end
end
local v43 = function(v451, v452, v453)
    local v454 = 1
    local v455 = 731 - (434 + 296)
    for v1131 = 2 - 1, v452 - 1 do
        local v1132 = 512 - (169 + 343)
        while true do
            if v1132 == (0 + 0) then
                v455 = v455 + (1 - 0)
                if v451:sub(v1131, v1131) ~= "\n" then
                else
                    v454 = v454 + 1
                    v455 = 2 - 1
                end
                break
            end
        end
    end
    error(string.format("%s at line %d col %d", v453, v454, v455))
end
local v44 = function(v456)
    local v457 = math.floor
    if v456 <= (105 + 22) then
        return string.char(v456)
    elseif v456 <= (5805 - 3758) then
        return string.char(v457(v456 / (1187 - (651 + 472))) + 146 + 46, (v456 % (28 + 36)) + (155 - 27))
    elseif v456 <= (66018 - (397 + 86)) then
        return string.char(
            v457(v456 / 4096) + (1100 - (423 + 453)),
            v457((v456 % 4096) / (7 + 57)) + 128,
            (v456 % 64) + 17 + 111
        )
    elseif v456 <= 1114111 then
        return string.char(
            v457(v456 / (228869 + 33275)) + 240,
            v457((v456 % (209206 + 52938)) / 4096) + 115 + 13,
            v457((v456 % (5286 - (50 + 1140))) / (56 + 8)) + 76 + 52,
            (v456 % (4 + 60)) + (183 - 55)
        )
    end
    error(string.format("invalid unicode codepoint '%x'", v456))
end
local v45 = function(v458)
    local v459 = 0
    local v460
    local v461
    local v462
    while true do
        if v459 == (0 + 0) then
            v460 = 0
            v461 = nil
            v459 = 1
        end
        if v459 == (597 - (157 + 439)) then
            v462 = nil
            while true do
                if v460 == (1 - 0) then
                    if v462 then
                        return v44(
                            ((((v461 - (183736 - 128440)) * (3028 - 2004)) + v462) - 56320) + (66454 - (782 + 136))
                        )
                    else
                        return v44(v461)
                    end
                    break
                end
                if v460 == (855 - (112 + 743)) then
                    v461 = tonumber(v458:sub(1172 - (1026 + 145), 1 + 3), 734 - (493 + 225))
                    v462 = tonumber(v458:sub(25 - 18, 10), 10 + 6)
                    v460 = 1
                end
            end
            break
        end
    end
end
local v46 = function(v463, v464)
    local v465 = 0 - 0
    local v466
    local v467
    local v468
    while true do
        if v465 == 0 then
            v466 = ""
            v467 = v464 + 1 + 0
            v465 = 2 - 1
        end
        if v465 == (1 + 0) then
            v468 = v467
            while v467 <= #v463 do
                local v1317 = v463:byte(v467)
                if v1317 < (52 - 20) then
                    v43(v463, v467, "control character in string")
                elseif v1317 == 92 then
                    local v1526 = 1595 - (210 + 1385)
                    local v1527
                    while true do
                        if v1526 == (1690 - (1201 + 488)) then
                            v1527 = v463:sub(v467, v467)
                            if v1527 == "u" then
                                local v1580 = 0 + 0
                                local v1581
                                while true do
                                    if v1580 == (0 - 0) then
                                        local v1598 = 0 - 0
                                        while true do
                                            if v1598 == (586 - (352 + 233)) then
                                                v1580 = 1
                                                break
                                            end
                                            if v1598 == (0 - 0) then
                                                v1581 = v463:match("^[dD][89aAbB]%x%x\\u%x%x%x%x", v467 + 1 + 0)
                                                    or v463:match("^%x%x%x%x", v467 + (2 - 1))
                                                    or v43(v463, v467 - 1, "invalid unicode escape in string")
                                                v466 = v466 .. v45(v1581)
                                                v1598 = 575 - (489 + 85)
                                            end
                                        end
                                    end
                                    if (1502 - (277 + 1224)) == v1580 then
                                        v467 = v467 + #v1581
                                        break
                                    end
                                end
                            else
                                local v1582 = 1493 - (663 + 830)
                                local v1583
                                while true do
                                    if v1582 == (0 + 0) then
                                        v1583 = 0 - 0
                                        while true do
                                            if v1583 == (875 - (461 + 414)) then
                                                if not v39[v1527] then
                                                    v43(
                                                        v463,
                                                        v467 - 1,
                                                        "invalid escape char '" .. v1527 .. "' in string"
                                                    )
                                                end
                                                v466 = v466 .. v28[v1527]
                                                break
                                            end
                                        end
                                        break
                                    end
                                end
                            end
                            v1526 = 2
                        end
                        if v1526 == 0 then
                            v466 = v466 .. v463:sub(v468, v467 - (1 + 0))
                            v467 = v467 + 1 + 0
                            v1526 = 1
                        end
                        if v1526 == 2 then
                            v468 = v467 + 1 + 0
                            break
                        end
                    end
                elseif v1317 == (34 + 0) then
                    local v1557 = 250 - (172 + 78)
                    while true do
                        if v1557 == 0 then
                            v466 = v466 .. v463:sub(v468, v467 - (1 - 0))
                            return v466, v467 + 1 + 0
                        end
                    end
                end
                v467 = v467 + (1 - 0)
            end
            v465 = 1 + 1
        end
        if (1 + 1) == v465 then
            v43(v463, v464, "expected closing quote for string")
            break
        end
    end
end
local v47 = function(v469, v470)
    local v471 = v42(v469, v470, v38)
    local v472 = v469:sub(v470, v471 - (1 - 0))
    local v473 = tonumber(v472)
    if not v473 then
        v43(v469, v470, "invalid number '" .. v472 .. "'")
    end
    return v473, v471
end
local v48 = function(v474, v475)
    local v476 = 0
    local v477
    local v478
    while true do
        local v1133 = 0 - 0
        while true do
            if v1133 == (0 + 0) then
                if v476 == (0 + 0) then
                    v477 = v42(v474, v475, v38)
                    v478 = v474:sub(v475, v477 - (1 + 0))
                    v476 = 3 - 2
                end
                if 1 == v476 then
                    local v1436 = 0 - 0
                    while true do
                        if v1436 == 0 then
                            if not v40[v478] then
                                v43(v474, v475, "invalid literal '" .. v478 .. "'")
                            end
                            return v41[v478], v477
                        end
                    end
                end
                break
            end
        end
    end
end
local v49 = function(v479, v480)
    local v481 = 0
    local v482
    local v483
    while true do
        local v1134 = 0 + 0
        while true do
            if v1134 == (0 + 0) then
                if v481 == (447 - (133 + 314)) then
                    v482 = {}
                    v483 = 1
                    v481 = 1
                end
                if v481 == (1 + 0) then
                    v480 = v480 + (214 - (199 + 14))
                    while 1 do
                        local v1506
                        v480 = v42(v479, v480, v37, true)
                        if v479:sub(v480, v480) == "]" then
                            v480 = v480 + 1
                            break
                        end
                        v1506, v480 = v35(v479, v480)
                        v482[v483] = v1506
                        v483 = v483 + (3 - 2)
                        v480 = v42(v479, v480, v37, true)
                        local v1508 = v479:sub(v480, v480)
                        v480 = v480 + (1550 - (647 + 902))
                        if v1508 == "]" then
                            break
                        end
                        if v1508 == "," then
                        else
                            v43(v479, v480, "expected ']' or ','")
                        end
                    end
                    v481 = 2
                end
                v1134 = 2 - 1
            end
            if v1134 == 1 then
                if v481 == 2 then
                    return v482, v480
                end
                break
            end
        end
    end
end
local v50 = function(v484, v485)
    local v486 = {}
    v485 = v485 + (234 - (85 + 148))
    while 1 do
        local v1135, v1136
        v485 = v42(v484, v485, v37, true)
        if v484:sub(v485, v485) ~= "}" then
        else
            v485 = v485 + (1290 - (426 + 863))
            break
        end
        if v484:sub(v485, v485) == '"' then
        else
            v43(v484, v485, "expected string for key")
        end
        v1135, v485 = v35(v484, v485)
        v485 = v42(v484, v485, v37, true)
        if v484:sub(v485, v485) ~= ":" then
            v43(v484, v485, "expected ':' after key")
        end
        v485 = v42(v484, v485 + (4 - 3), v37, true)
        v1136, v485 = v35(v484, v485)
        v486[v1135] = v1136
        v485 = v42(v484, v485, v37, true)
        local v1138 = v484:sub(v485, v485)
        v485 = v485 + (1655 - (873 + 781))
        if v1138 ~= "}" then
        else
            break
        end
        if v1138 ~= "," then
            v43(v484, v485, "expected '}' or ','")
        end
    end
    return v486, v485
end
local v51 = {
    ['"'] = v46,
    ["0"] = v47,
    ["1"] = v47,
    ["2"] = v47,
    ["3"] = v47,
    ["4"] = v47,
    ["5"] = v47,
    ["6"] = v47,
    ["7"] = v47,
    ["8"] = v47,
    ["9"] = v47,
    ["-"] = v47,
    t = v48,
    f = v48,
    n = v48,
    ["["] = v49,
    ["{"] = v50,
}
function v35(v487, v488)
    local v489 = 0 - 0
    local v490
    local v491
    while true do
        if v489 == (0 - 0) then
            local v1237 = 0
            while true do
                if v1237 == 1 then
                    v489 = 1 + 0
                    break
                end
                if v1237 == (0 - 0) then
                    v490 = v487:sub(v488, v488)
                    v491 = v51[v490]
                    v1237 = 1 - 0
                end
            end
        end
        if (2 - 1) == v489 then
            if v491 then
                return v491(v487, v488)
            end
            v43(v487, v488, "unexpected character '" .. v490 .. "'")
            break
        end
    end
end
local v52 = function(v492)
    if type(v492) ~= "string" then
        error("expected argument of type string, got " .. type(v492))
    end
    local v493, v494 = v35(v492, v42(v492, 1, v37, true))
    v494 = v42(v492, v494, v37, true)
    if v494 > #v492 then
    else
        v43(v492, v494, "trailing garbage")
    end
    return v493
end
local v53, v54, v55 = v34, v52, v25
local v56 = 31937 - (414 + 1533)
local v57 = "4a156cbd-7be0-4ec3-a6fe-0dcce4d61f50"
local v58 = true
local v59 = { "https://api.platoboost.com", "https://api.platoboost.net" }
local v60 = cloneref or function(v495)
    return v495
end
local function v61(v496)
    local v497, v498 = pcall(function()
        return v60(game:GetService(v496))
    end)
    return (v497 and v498) or nil
end
local v62 = v61("Players")
local v63 = v61("RunService")
local v64 = v61("UserInputService")
local v65 = v61("Workspace")
local v66 = v61("TweenService")
local v67 = v61("Lighting")
local v68 = v62.LocalPlayer
local v69 = v65.CurrentCamera
local v70 = Vector2.new
local v71 = Vector3.new
local v72 = Color3.fromRGB
local v73 = UDim2.new
local v74 = UDim.new
local v75 = TweenInfo.new
local v76 = Enum
local v77 = v72(53 + 7, 220, 810 - (443 + 112))
local v78 = v72(30, 1609 - (888 + 591), 426 - 261)
local v79 = v72(1 + 7, 9, 48 - 35)
local v80 = v72(12, 13, 8 + 10)
local v81 = v72(16, 9 + 8, 3 + 21)
local v82 = v72(22, 45 - 21, 62 - 28)
local v83 = v72(28, 30, 42)
local v84 = v72(1723 - (136 + 1542), 157 - 109, 64)
local v85 = v72(234 + 1, 238, 389 - 144)
local v86 = v72(109 + 41, 155, 656 - (68 + 418))
local v87 = v72(90, 257 - 162, 208 - 93)
local v88 = v72(70 + 10, 1312 - (770 + 322), 8 + 122)
local v89 = v72(255, 27 + 63, 13 + 82)
local function v90()
    local v499, v500 = pcall(function()
        return gethui and gethui()
    end)
    if v499 and v500 then
        return v500
    end
    local v501, v502 = pcall(function()
        return v60(game:GetService("CoreGui"))
    end)
    if v501 and v502 then
        local v1209 = 0 - 0
        local v1210
        while true do
            if v1209 == 0 then
                v1210 = pcall(function()
                    return v502.Name
                end)
                if v1210 then
                    return v502
                end
                break
            end
        end
    end
    return v68:WaitForChild("PlayerGui", 19 - 9)
end
local v91 = v90()
local function v92(v503, v504)
    local v505 = 0 - 0
    local v506
    local v507
    while true do
        if v505 == (3 - 2) then
            v506 = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            v507 = {}
            v505 = 2 + 0
        end
        if v505 == (2 - 0) then
            for v1318 = 1, v504 do
                local v1319 = math.random(1 + 0, #v506)
                v507[v1318] = v506:sub(v1319, v1319)
            end
            return v503 .. table.concat(v507)
        end
        if v505 == 0 then
            v503 = v503 or ""
            v504 = v504 or (8 + 4)
            v505 = 1 + 0
        end
    end
end
local function v93(v508)
    local v509, v510 = pcall(function()
        local v1139 = 0 - 0
        local v1140
        while true do
            local v1211 = 0
            local v1212
            while true do
                if v1211 == (0 - 0) then
                    v1212 = 0 + 0
                    while true do
                        if v1212 == (0 - 0) then
                            if v1139 == 1 then
                                return nil
                            end
                            if v1139 == (0 - 0) then
                                local v1558 = 0 + 0
                                while true do
                                    if v1558 == 0 then
                                        v1140 = (getfenv and getfenv()) or _G
                                        if v1140 and (v1140[v508] ~= nil) then
                                            return v1140[v508]
                                        end
                                        v1558 = 1
                                    end
                                    if v1558 == (4 - 3) then
                                        v1139 = 832 - (762 + 69)
                                        break
                                    end
                                end
                            end
                            break
                        end
                    end
                    break
                end
            end
        end
    end)
    if v509 and (v510 ~= nil) then
        return v510
    end
    local v511, v512 = pcall(function()
        return _G[v508]
    end)
    if v511 and (v512 ~= nil) then
        return v512
    end
    return nil
end
local v94
do
    local v513 = 0 - 0
    local v514
    while true do
        if v513 == (0 + 0) then
            v514 = { "request", "http_request", "syn_request", "http", "HttpRequest", "HttpGet", "HttpGetAsync" }
            for v1321, v1322 in ipairs(v514) do
                local v1323 = v93(v1322)
                if type(v1323) ~= "function" then
                else
                    v94 = { ["fn"] = v1323, ["name"] = v1322 }
                    break
                end
            end
            break
        end
    end
end
local v95
do
    local v515 = 1320 - (1199 + 121)
    local v516
    while true do
        if v515 == (0 - 0) then
            v516 = { "setclipboard", "toclipboard", "set_clipboard" }
            for v1324, v1325 in ipairs(v516) do
                local v1326 = v93(v1325)
                if type(v1326) == "function" then
                    v95 = v1326
                    break
                end
            end
            break
        end
    end
end
local v96
do
    local v517 = 0 - 0
    local v518
    while true do
        if v517 == (0 - 0) then
            v518 = { "setfpscap", "set_fps_cap" }
            for v1327, v1328 in ipairs(v518) do
                local v1329 = v93(v1328)
                if type(v1329) == "function" then
                    v96 = v1329
                    break
                end
            end
            break
        end
    end
end
local v97 = (function()
    local v519 = 0 - 0
    local v520
    local v521
    while true do
        if 2 == v519 then
            return tostring(v68.UserId)
        end
        if v519 == 0 then
            v520 = v93("gethwid")
            if type(v520) ~= "function" then
            else
                local v1377, v1378 = pcall(v520)
                if v1377 and v1378 then
                    return tostring(v1378)
                end
            end
            v519 = 1 + 0
        end
        if v519 == (1 - 0) then
            v521 = v93("get_hwid")
            if type(v521) ~= "function" then
            else
                local v1379 = 0 + 0
                local v1380
                local v1381
                local v1382
                while true do
                    if v1379 == (470 - (304 + 165)) then
                        v1382 = nil
                        while true do
                            if v1380 == 0 then
                                v1381, v1382 = pcall(v521)
                                if v1381 and v1382 then
                                    return tostring(v1382)
                                end
                                break
                            end
                        end
                        break
                    end
                    if v1379 == 0 then
                        v1380 = 0 + 0
                        v1381 = nil
                        v1379 = 161 - (54 + 106)
                    end
                end
            end
            v519 = 2
        end
    end
end)()
local v98 = Instance.new("ScreenGui")
v98.Name = v92("n_")
v98.ResetOnSpawn = false
v98.ZIndexBehavior = v76.ZIndexBehavior.Sibling
pcall(function()
    v98.Parent = v91
end)
local v103 = Instance.new("Frame")
v103.Size = v73(1969 - (1618 + 351), 320, 1 + 0, -30)
v103.Position = v73(1017 - (10 + 1006), -(86 + 254), 0 + 0, 15)
v103.BackgroundTransparency = 3 - 2
v103.Parent = v98
local v108 = Instance.new("UIListLayout")
v108.Padding = v74(0, 1041 - (912 + 121))
v108.VerticalAlignment = v76.VerticalAlignment.Bottom
v108.SortOrder = v76.SortOrder.LayoutOrder
v108.Parent = v103
local function v115(v523, v524, v525, v526)
    v525 = v525 or (2 + 1)
    v526 = v526 or v77
    local v527 = Instance.new("Frame")
    v527.Size = v73(1290 - (1140 + 149), 0 + 0, 0 - 0, 56)
    v527.BackgroundColor3 = v72(3 + 11, 15, 75 - 53)
    v527.BackgroundTransparency = 1 - 0
    v527.BorderSizePixel = 0
    v527.Parent = v103
    Instance.new("UICorner", v527).CornerRadius = v74(0 + 0, 20 - 14)
    local v534 = Instance.new("UIStroke", v527)
    v534.Color = v526
    v534.Thickness = 187 - (165 + 21)
    v534.Transparency = 112 - (61 + 50)
    local v538 = Instance.new("Frame")
    v538.Size = v73(0 + 0, 9 - 7, 1 - 0, -(8 + 12))
    v538.Position = v73(1460 - (1295 + 165), 12, 0 + 0, 5 + 5)
    v538.BackgroundColor3 = v526
    v538.BorderSizePixel = 0
    v538.Parent = v527
    Instance.new("UICorner", v538).CornerRadius = v74(1398 - (819 + 578), 1402 - (331 + 1071))
    local v545 = Instance.new("TextLabel")
    v545.Size = v73(744 - (588 + 155), -(1314 - (546 + 736)), 1937 - (1834 + 103), 16)
    v545.Position = v73(0 + 0, 65 - 43, 1766 - (1536 + 230), 499 - (128 + 363))
    v545.BackgroundTransparency = 1 + 0
    v545.Text = v523
    v545.TextColor3 = v526
    v545.Font = v76.Font.GothamBold
    v545.TextSize = 12
    v545.TextXAlignment = v76.TextXAlignment.Left
    v545.Parent = v527
    local v557 = Instance.new("TextLabel")
    v557.Size = v73(2 - 1, -(9 + 23), 0, 24)
    v557.Position = v73(0 - 0, 64 - 42, 0 - 0, 18 + 8)
    v557.BackgroundTransparency = 1
    v557.Text = v524
    v557.TextColor3 = v86
    v557.Font = v76.Font.Gotham
    v557.TextSize = 1020 - (615 + 394)
    v557.TextXAlignment = v76.TextXAlignment.Left
    v557.TextYAlignment = v76.TextYAlignment.Top
    v557.TextWrapped = true
    v557.Parent = v527
    local v571 = v75(0.3 + 0, v76.EasingStyle.Quad, v76.EasingDirection.Out)
    v66:Create(v527, v571, { ["BackgroundTransparency"] = 0.05 + 0 }):Play()
    v66:Create(v534, v571, { ["Transparency"] = 0.6 }):Play()
    task.delay(v525, function()
        if not v527.Parent then
            return
        end
        v66:Create(v527, v571, { ["BackgroundTransparency"] = 2 - 1 }):Play()
        v66:Create(v534, v571, { ["Transparency"] = 4 - 3 }):Play()
        task.wait(651.35 - (59 + 592))
        if v527.Parent then
            v527:Destroy()
        end
    end)
end
local v116 = v59[2 - 1]
local v117, v118 = "", 0
local v119 = false
local function v120()
    local v572 = 0 - 0
    while true do
        local v1141 = 0 + 0
        while true do
            if v1141 == (171 - (70 + 101)) then
                if v572 == (0 - 0) then
                    if not v94 then
                        return false
                    end
                    for v1509, v1510 in ipairs(v59) do
                        local v1511 = 0 + 0
                        local v1512
                        local v1513
                        while true do
                            if v1511 == 0 then
                                v1512, v1513 =
                                    pcall(v94.fn, { ["Url"] = v1510 .. "/public/connectivity", ["Method"] = "GET" })
                                if
                                    v1512
                                    and v1513
                                    and (
                                        (v1513.StatusCode == (502 - 302))
                                        or (v1513.StatusCode == 429)
                                        or (v1513.StatusCode == (645 - (123 + 118)))
                                    )
                                then
                                    local v1575 = 0 + 0
                                    while true do
                                        if 0 == v1575 then
                                            v116 = v1510
                                            return true
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                    v572 = 1
                end
                if v572 == (1 + 0) then
                    return false
                end
                break
            end
        end
    end
end
local function v121()
    local v573 = 0
    local v574
    while true do
        if v573 == (1399 - (653 + 746)) then
            v574 = ""
            for v1330 = 1 - 0, 16 do
                v574 = v574 .. string.char(math.floor(math.random() * (37 - 11)) + (259 - 162))
            end
            v573 = 1
        end
        if v573 == (1 + 0) then
            return v574
        end
    end
end
local function v122()
    if (v118 + 600) > os.time() then
        return true, v117
    end
    if not v94 then
        return false, "HTTP is not available in this executor"
    end
    local v575, v576 = pcall(
        v94.fn,
        {
            ["Url"] = v116 .. "/public/start",
            ["Method"] = "POST",
            ["Body"] = v53({ ["service"] = v56, ["identifier"] = v55(v97) }),
            ["Headers"] = { ["Content-Type"] = "application/json" },
        }
    )
    if not v575 or not v576 then
        return false, "Could not reach server"
    end
    if v576.StatusCode == (128 + 72) then
        local v1213, v1214 = pcall(v54, v576.Body)
        if v1213 and v1214 and v1214.success then
            local v1331 = 0
            while true do
                if v1331 == 0 then
                    v117 = v1214.data.url
                    v118 = os.time()
                    v1331 = 1 + 0
                end
                if (1 + 0) == v1331 then
                    return true, v117
                end
            end
        end
        return false, (v1214 and v1214.message) or "Invalid response format"
    elseif v576.StatusCode == 429 then
        return false, "Too many requests, wait 20 seconds"
    end
    return false, "Server returned code " .. tostring(v576.StatusCode)
end
local function v123(v577)
    local v578 = 0 + 0
    local v579
    local v580
    local v581
    local v582
    while true do
        if v578 == (7 - 4) then
            return false, "Response code: " .. tostring(v582.StatusCode)
        end
        if v578 == 1 then
            if v58 then
                v580.nonce = v579
            end
            v581, v582 = pcall(
                v94.fn,
                {
                    ["Url"] = v116 .. "/public/redeem/" .. tostring(v56),
                    ["Method"] = "POST",
                    ["Body"] = v53(v580),
                    ["Headers"] = { ["Content-Type"] = "application/json" },
                }
            )
            v578 = 2 + 0
        end
        if v578 == (3 - 1) then
            if not v581 or not v582 then
                return false, "Connection error"
            end
            if v582.StatusCode ~= (1434 - (885 + 349)) then
            else
                local v1384 = 0 + 0
                local v1385
                local v1386
                while true do
                    if v1384 == 0 then
                        v1385, v1386 = pcall(v54, v582.Body)
                        if v1385 and v1386 and v1386.success then
                            local v1559 = 0 - 0
                            while true do
                                if (0 - 0) == v1559 then
                                    if v1386.data.valid then
                                        if v58 then
                                            if v1386.data.hash ~= v55("true-" .. v579 .. "-" .. v57) then
                                            else
                                                return true
                                            end
                                            return false, "Response integrity check failed"
                                        end
                                        return true
                                    end
                                    return false, "Invalid key"
                                end
                            end
                        end
                        v1384 = 1
                    end
                    if v1384 == (969 - (915 + 53)) then
                        return false, (v1386 and v1386.message) or "Unknown error"
                    end
                end
            end
            v578 = 804 - (768 + 33)
        end
        if 0 == v578 then
            v579 = v121()
            v580 = { ["identifier"] = v55(v97), ["key"] = v577 }
            v578 = 3 - 2
        end
    end
end
local function v124(v583)
    if v119 then
        return false, "A request is already in progress"
    end
    if not v94 then
        return false, "HTTP is not available"
    end
    v119 = true
    local v584 = v121()
    local v585 = v116 .. "/public/whitelist/" .. tostring(v56) .. "?identifier=" .. v55(v97) .. "&key=" .. v583
    if v58 then
        v585 = v585 .. "&nonce=" .. v584
    end
    local v586, v587 = pcall(v94.fn, { ["Url"] = v585, ["Method"] = "GET" })
    v119 = false
    if not v586 or not v587 then
        return false, "Connection error"
    end
    if v587.StatusCode ~= 200 then
    else
        local v1215 = 0 - 0
        local v1216
        local v1217
        local v1218
        while true do
            if 0 == v1215 then
                local v1387 = 0
                while true do
                    if v1387 == (329 - (287 + 41)) then
                        v1215 = 848 - (638 + 209)
                        break
                    end
                    if (0 + 0) == v1387 then
                        v1216 = 0
                        v1217 = nil
                        v1387 = 1687 - (96 + 1590)
                    end
                end
            end
            if v1215 == 1 then
                v1218 = nil
                while true do
                    if v1216 == (1672 - (741 + 931)) then
                        v1217, v1218 = pcall(v54, v587.Body)
                        if v1217 and v1218 and v1218.success then
                            local v1560 = 0
                            while true do
                                local v1570 = 0 + 0
                                while true do
                                    if v1570 == (0 - 0) then
                                        if v1560 == (4 - 3) then
                                            return false, "Invalid key"
                                        end
                                        if v1560 == (0 + 0) then
                                            if v1218.data.valid then
                                                local v1600 = 0 + 0
                                                local v1601
                                                while true do
                                                    if v1600 == 0 then
                                                        v1601 = 0
                                                        while true do
                                                            if (0 + 0) == v1601 then
                                                                if v58 then
                                                                    local v1605 = 0
                                                                    while true do
                                                                        if v1605 == (0 - 0) then
                                                                            if
                                                                                v1218.data.hash
                                                                                ~= v55("true-" .. v584 .. "-" .. v57)
                                                                            then
                                                                            else
                                                                                return true
                                                                            end
                                                                            return false,
                                                                                "Response integrity check failed"
                                                                        end
                                                                    end
                                                                end
                                                                return true
                                                            end
                                                        end
                                                        break
                                                    end
                                                end
                                            end
                                            if string.sub(v583, 1, 4) ~= "KEY_" then
                                            else
                                                return v123(v583)
                                            end
                                            v1560 = 1 + 0
                                        end
                                        break
                                    end
                                end
                            end
                        end
                        v1216 = 1
                    end
                    if v1216 == (1 + 0) then
                        return false, (v1218 and v1218.message) or "Unknown error"
                    end
                end
                break
            end
        end
    end
    return false, "Response code: " .. tostring(v587.StatusCode)
end
local function v125()
    local v588 = 0 - 0
    local v589
    local v590
    local v591
    while true do
        if v588 == (0 + 0) then
            local v1238 = 494 - (64 + 430)
            local v1239
            while true do
                if v1238 == (0 + 0) then
                    v1239 = 363 - (106 + 257)
                    while true do
                        if v1239 == 0 then
                            v589, v590 = v122()
                            if not v589 then
                                return false, v590
                            end
                            v1239 = 1 + 0
                        end
                        if (722 - (496 + 225)) == v1239 then
                            v588 = 1 - 0
                            break
                        end
                    end
                    break
                end
            end
        end
        if v588 == 1 then
            if not v95 then
                return false, "Clipboard is not available"
            end
            v591 = pcall(v95, v590)
            v588 = 2
        end
        if v588 == (9 - 7) then
            if not v591 then
                return false, "Could not copy the link"
            end
            return true, v590
        end
    end
end
local function v126()
    local v592 = Instance.new("ScreenGui")
    v592.Name = v92("auth_")
    v592.ResetOnSpawn = false
    v592.ZIndexBehavior = v76.ZIndexBehavior.Sibling
    v592.IgnoreGuiInset = true
    pcall(function()
        v592.Parent = v91
    end)
    local v598 = Instance.new("BlurEffect")
    v598.Name = v92("b_")
    v598.Size = 18
    pcall(function()
        v598.Parent = v67
    end)
    local v601 = Instance.new("Frame")
    v601.Size = v73(1659 - (256 + 1402), 0, 1900 - (30 + 1869), 1369 - (213 + 1156))
    v601.BackgroundColor3 = v72(188 - (96 + 92), 0, 0)
    v601.BackgroundTransparency = 0.4
    v601.BorderSizePixel = 0
    v601.Parent = v592
    local v607 = Instance.new("Frame")
    v607.Size = v73(0, 480, 0 + 0, 340)
    v607.Position = v73(0.5, -(1139 - (142 + 757)), 0.5 + 0, -170)
    v607.BackgroundColor3 = v79
    v607.BorderSizePixel = 0
    v607.Active = true
    v607.Parent = v592
    Instance.new("UICorner", v607).CornerRadius = v74(0 + 0, 14)
    local v615 = Instance.new("UIStroke", v607)
    v615.Color = v83
    v615.Thickness = 80 - (32 + 47)
    local v618 = Instance.new("UIGradient")
    v618.Rotation = 2137 - (1053 + 924)
    v618.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, v72(23 - 9, 15, 1670 - (685 + 963))),
        ColorSequenceKeypoint.new(0.5, v72(15 - 5, 1720 - (541 + 1168), 1613 - (645 + 952))),
        ColorSequenceKeypoint.new(1, v72(24 - 17, 8, 12)),
    })
    v618.Parent = v607
    local v622 = Instance.new("Frame")
    v622.Size = v73(1, 0, 0 - 0, 32 + 60)
    v622.BackgroundTransparency = 1 + 0
    v622.Parent = v607
    local v626 = Instance.new("Frame")
    v626.Size = v73(765 - (181 + 584), 1439 - (665 + 730), 0 - 0, 89 - 45)
    v626.Position = v73(1350 - (540 + 810), 111 - 83, 0, 65 - 41)
    v626.BackgroundColor3 = v77
    v626.BorderSizePixel = 0 + 0
    v626.Parent = v622
    Instance.new("UICorner", v626).CornerRadius = v74(0, 10)
    local v633 = Instance.new("ImageLabel")
    v633.Size = v73(205.5 - (166 + 37), 1881 - (22 + 1859), 1774.5 - (843 + 929), 262 - (30 + 232))
    v633.Position = v73(0.5, 0 - 0, 777.5 - (55 + 722), 0 - 0)
    v633.AnchorPoint = v70(1675.5 - (78 + 1597), 0.5)
    v633.BackgroundTransparency = 1 + 0
    v633.Image = "rbxassetid://5028857084"
    v633.ImageColor3 = v77
    v633.ImageTransparency = 0.5 + 0
    v633.Parent = v626
    local v642 = Instance.new("TextLabel")
    v642.Size = v73(1 + 0, 0, 550 - (305 + 244), 0 + 0)
    v642.BackgroundTransparency = 106 - (95 + 10)
    v642.Text = "J"
    v642.TextColor3 = v79
    v642.Font = v76.Font.GothamBlack
    v642.TextSize = 22
    v642.ZIndex = 2 + 0
    v642.Parent = v626
    local v652 = Instance.new("TextLabel")
    v652.Size = v73(3 - 2, -(150 - 40), 0, 784 - (592 + 170))
    v652.Position = v73(0, 292 - 208, 0, 59 - 35)
    v652.BackgroundTransparency = 1 + 0
    v652.Text = "JUST TEAM HUB"
    v652.TextColor3 = v85
    v652.Font = v76.Font.GothamBold
    v652.TextSize = 7 + 10
    v652.TextXAlignment = v76.TextXAlignment.Left
    v652.Parent = v622
    local v664 = Instance.new("TextLabel")
    v664.Size = v73(2 - 1, -110, 0, 3 + 13)
    v664.Position = v73(0, 155 - 71, 507 - (353 + 154), 60 - 14)
    v664.BackgroundTransparency = 1 - 0
    v664.Text = "PREMIUM EDITION"
    v664.TextColor3 = v77
    v664.Font = v76.Font.GothamBold
    v664.TextSize = 7 + 3
    v664.TextXAlignment = v76.TextXAlignment.Left
    v664.Parent = v622
    local v674 = Instance.new("Frame")
    v674.Size = v73(1 + 0, -56, 0, 1 + 0)
    v674.Position = v73(0, 40 - 12, 0 - 0, 214 - 122)
    v674.BackgroundColor3 = v83
    v674.BorderSizePixel = 86 - (7 + 79)
    v674.Parent = v607
    local v680 = Instance.new("TextLabel")
    v680.Size = v73(1 + 0, -(237 - (24 + 157)), 0 - 0, 42 - 22)
    v680.Position = v73(0, 8 + 20, 0 - 0, 486 - (262 + 118))
    v680.BackgroundTransparency = 1
    v680.Text = "Enter your access key"
    v680.TextColor3 = v86
    v680.Font = v76.Font.Gotham
    v680.TextSize = 12
    v680.TextXAlignment = v76.TextXAlignment.Left
    v680.Parent = v607
    local v691 = Instance.new("Frame")
    v691.Size = v73(1, -56, 1083 - (1038 + 45), 95 - 51)
    v691.Position = v73(230 - (19 + 211), 141 - (88 + 25), 0, 335 - 203)
    v691.BackgroundColor3 = v81
    v691.BorderSizePixel = 0
    v691.Parent = v607
    Instance.new("UICorner", v691).CornerRadius = v74(0 + 0, 8)
    local v698 = Instance.new("UIStroke", v691)
    v698.Color = v83
    v698.Thickness = 1 + 0
    local v701 = Instance.new("TextBox")
    v701.Size = v73(1037 - (1007 + 29), -(8 + 20), 1, 0 - 0)
    v701.Position = v73(0 - 0, 4 + 10, 811 - (340 + 471), 0 - 0)
    v701.BackgroundTransparency = 1
    v701.Text = ""
    v701.PlaceholderText = "KEY_XXXXXXXXXXXXXXXX"
    v701.PlaceholderColor3 = v87
    v701.TextColor3 = v85
    v701.Font = v76.Font.GothamMedium
    v701.TextSize = 13
    v701.TextXAlignment = v76.TextXAlignment.Left
    v701.ClearTextOnFocus = false
    v701.Parent = v691
    v701.Focused:Connect(function()
        v66:Create(v698, v75(0.2), { ["Color"] = v77 }):Play()
    end)
    v701.FocusLost:Connect(function()
        v66:Create(v698, v75(589.2 - (276 + 313)), { ["Color"] = v83 }):Play()
    end)
    local v715 = Instance.new("TextButton")
    v715.Size = v73(0.5 - 0, -(31 + 2), 0, 44)
    v715.Position = v73(0, 28, 0 + 0, 18 + 172)
    v715.BackgroundColor3 = v81
    v715.Text = "GET KEY"
    v715.TextColor3 = v85
    v715.Font = v76.Font.GothamBold
    v715.TextSize = 1984 - (495 + 1477)
    v715.AutoButtonColor = false
    v715.Parent = v607
    Instance.new("UICorner", v715).CornerRadius = v74(0 - 0, 6 + 2)
    local v726 = Instance.new("UIStroke", v715)
    v726.Color = v84
    v726.Thickness = 1
    local v729 = Instance.new("TextButton")
    v729.Size = v73(403.5 - (342 + 61), -33, 0 + 0, 209 - (4 + 161))
    v729.Position = v73(0.5, 4 + 1, 0 - 0, 190)
    v729.BackgroundColor3 = v77
    v729.Text = "VERIFY"
    v729.TextColor3 = v79
    v729.Font = v76.Font.GothamBold
    v729.TextSize = 31 - 19
    v729.AutoButtonColor = false
    v729.Parent = v607
    Instance.new("UICorner", v729).CornerRadius = v74(497 - (322 + 175), 571 - (173 + 390))
    local v740 = Instance.new("Frame")
    v740.Size = v73(0 + 0, 320 - (203 + 111), 0 + 0, 5 + 1)
    v740.Position = v73(0 - 0, 30, 0 + 0, 254)
    v740.BackgroundColor3 = v87
    v740.BorderSizePixel = 0
    v740.Parent = v607
    Instance.new("UICorner", v740).CornerRadius = v74(707 - (57 + 649), 384 - (328 + 56))
    local v747 = Instance.new("TextLabel")
    v747.Size = v73(1 + 0, -(582 - (433 + 79)), 0, 34)
    v747.Position = v73(0, 5 + 39, 0, 246)
    v747.BackgroundTransparency = 1 + 0
    v747.Text = "Ready to verify"
    v747.TextColor3 = v87
    v747.Font = v76.Font.Gotham
    v747.TextSize = 36 - 25
    v747.TextXAlignment = v76.TextXAlignment.Left
    v747.TextYAlignment = v76.TextYAlignment.Top
    v747.TextWrapped = true
    v747.Parent = v607
    local v760 = Instance.new("TextLabel")
    v760.Size = v73(4 - 3, -(41 + 15), 0 + 0, 1054 - (562 + 474))
    v760.Position = v73(0 - 0, 56 - 28, 906 - (76 + 829), -(1703 - (1506 + 167)))
    v760.BackgroundTransparency = 1 - 0
    v760.Text = "Protected by Platoboost"
    v760.TextColor3 = v87
    v760.Font = v76.Font.Gotham
    v760.TextSize = 10
    v760.TextXAlignment = v76.TextXAlignment.Center
    v760.Parent = v607
    local function v771(v1144, v1145)
        local v1146 = 0
        while true do
            if (266 - (58 + 208)) == v1146 then
                v747.Text = v1144
                v747.TextColor3 = v1145 or v87
                v1146 = 1 + 0
            end
            if v1146 == (1 + 0) then
                v740.BackgroundColor3 = v1145 or v87
                break
            end
        end
    end
    v715.MouseEnter:Connect(function()
        local v1147 = 0 + 0
        while true do
            if v1147 == (0 - 0) then
                v66:Create(v715, v75(337.15 - (258 + 79)), { ["BackgroundColor3"] = v82 }):Play()
                v66:Create(v726, v75(0.15 + 0), { ["Color"] = v78 }):Play()
                break
            end
        end
    end)
    v715.MouseLeave:Connect(function()
        local v1148 = 0
        while true do
            if v1148 == 0 then
                v66:Create(v715, v75(0.15), { ["BackgroundColor3"] = v81 }):Play()
                v66:Create(v726, v75(0.15), { ["Color"] = v84 }):Play()
                break
            end
        end
    end)
    v729.MouseEnter:Connect(function()
        v66:Create(v729, v75(0.15 - 0), { ["BackgroundColor3"] = v72(1590 - (1219 + 251), 235, 1926 - (1231 + 440)) })
            :Play()
    end)
    v729.MouseLeave:Connect(function()
        v66:Create(v729, v75(58.15 - (34 + 24)), { ["BackgroundColor3"] = v77 }):Play()
    end)
    v715.MouseButton1Click:Connect(function()
        v771("Requesting link...", v86)
        local v1149, v1150 = v125()
        if v1149 then
            v771("Link copied. Open it in your browser.", v88)
        else
            v771(tostring(v1150), v89)
        end
    end)
    v729.MouseButton1Click:Connect(function()
        local v1151 = v701.Text
        if v1151 ~= "" then
        else
            local v1240 = 0 + 0
            while true do
                if v1240 == (0 - 0) then
                    local v1438 = 0
                    while true do
                        if 0 == v1438 then
                            v771("Please enter a key", v72(112 + 143, 546 - 366, 60))
                            return
                        end
                    end
                end
            end
        end
        v771("Verifying key...", v86)
        local v1152, v1153 = v124(v1151)
        if v1152 then
            local v1241 = 0 - 0
            while true do
                if v1241 == (2 - 1) then
                    if v598 then
                        pcall(function()
                            v598:Destroy()
                        end)
                    end
                    if v592 then
                        pcall(function()
                            v592:Destroy()
                        end)
                    end
                    v1241 = 6 - 4
                end
                if v1241 == 2 then
                    getgenv().JTH_AuthPassed = true
                    break
                end
                if v1241 == (0 - 0) then
                    v771("Success. Loading...", v88)
                    task.wait(0.6)
                    v1241 = 1590 - (877 + 712)
                end
            end
        else
            v771(tostring(v1153 or "Invalid key"), v89)
        end
    end)
    return v592, v607
end
if not getgenv().JTH_AuthPassed then
    v120()
    v126()
    repeat
        task.wait(0.2 + 0)
    until getgenv().JTH_AuthPassed
end
if getgenv().JTH_Loaded then
    local v1154 = 754 - (242 + 512)
    while true do
        if v1154 == (0 - 0) then
            pcall(function()
                getgenv().JTH_Unload()
            end)
            task.wait(0.2)
            break
        end
    end
end
getgenv().JTH_Loaded = true
local v128 = {
    ["Speed"] = { ["Enabled"] = false, ["Value"] = 55 },
    ["Jump"] = { ["Infinite"] = false, ["Bypass"] = false, ["Power"] = 707 - (92 + 535) },
    ["Fly"] = { ["Enabled"] = false, ["Speed"] = 71 + 19, ["Vertical"] = 92 - 47 },
    ["Noclip"] = { ["Enabled"] = false, ["Cache"] = {}, ["Watchers"] = {} },
    ["ESP"] = {
        ["Enabled"] = false,
        ["Box"] = true,
        ["Health"] = true,
        ["Tracer"] = true,
        ["Name"] = true,
        ["Distance"] = true,
        ["TextSize"] = 1 + 13,
        ["Cache"] = {},
    },
    ["Hitbox"] = { ["Enabled"] = false, ["Size"] = 17 - 12, ["Cache"] = {} },
    ["FullBright"] = { ["Enabled"] = false },
    ["NoFog"] = { ["Enabled"] = false },
    ["FPS"] = { ["Enabled"] = false, ["Value"] = 236 + 4 },
}
local v129 = {}
local v130 = {}
local v131 = { W = false, A = false, S = false, D = false, ["Space"] = false, ["Shift"] = false }
local function v132(v772, v773)
    local v774 = 0 + 0
    while true do
        if v774 == (0 + 0) then
            if v129[v772] then
                pcall(function()
                    v129[v772]:Disconnect()
                end)
            end
            v129[v772] = v773
            break
        end
    end
end
local function v133(v775)
    local v776 = 0
    local v777
    while true do
        if (0 - 0) == v776 then
            v777 = 0 - 0
            while true do
                if (1785 - (1476 + 309)) == v777 then
                    table.insert(v130, v775)
                    return v775
                end
            end
            break
        end
    end
end
local v134 = Instance.new("BlurEffect")
v134.Name = v92("b_")
v134.Size = 1284 - (299 + 985)
pcall(function()
    v134.Parent = v67
end)
local function v137(v779)
    pcall(function()
        v66:Create(v134, v75(0.35 + 0), { ["Size"] = v779 }):Play()
    end)
end
local v138 = Instance.new("ScreenGui")
v138.Name = v92("JTH_")
v138.ResetOnSpawn = false
v138.ZIndexBehavior = v76.ZIndexBehavior.Sibling
v138.IgnoreGuiInset = true
pcall(function()
    v138.Parent = v91
end)
local v143 = Instance.new("Frame")
v143.Name = v92()
v143.Size = v73(0 - 0, 753 - (86 + 7), 0 - 0, 470)
v143.Position = v73(0.5 + 0, -330, 880.5 - (672 + 208), -235)
v143.BackgroundColor3 = v79
v143.BorderSizePixel = 0
v143.Active = true
v143.ClipsDescendants = true
v143.Parent = v138
Instance.new("UICorner", v143).CornerRadius = v74(0, 6 + 6)
local v153 = Instance.new("UIStroke", v143)
v153.Color = v83
v153.Thickness = 133 - (14 + 118)
local v156 = Instance.new("UIGradient")
v156.Rotation = 605 - (339 + 106)
v156.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, v72(12, 7 + 6, 19)),
    ColorSequenceKeypoint.new(1 + 0, v72(7, 8, 12)),
})
v156.Parent = v143
local v160 = Instance.new("Frame")
v160.Size = v73(0 - 0, 180, 1 + 0, 0 - 0)
v160.BackgroundColor3 = v80
v160.BorderSizePixel = 0 + 0
v160.ZIndex = 355 - (260 + 93)
v160.Parent = v143
local v166 = Instance.new("Frame")
v166.Size = v73(0, 1 + 0, 1, 0)
v166.Position = v73(2 - 1, 0, 0 - 0, 1974 - (1181 + 793))
v166.BackgroundColor3 = v83
v166.BorderSizePixel = 0 + 0
v166.Parent = v160
local v172 = Instance.new("Frame")
v172.Size = v73(308 - (105 + 202), 0, 0, 60 + 14)
v172.BackgroundTransparency = 1
v172.Parent = v160
local v176 = Instance.new("Frame")
v176.Size = v73(810 - (352 + 458), 144 - 108, 0, 36)
v176.Position = v73(0 - 0, 18 + 0, 0 - 0, 967 - (438 + 511))
v176.BackgroundColor3 = v77
v176.BorderSizePixel = 1383 - (1262 + 121)
v176.Parent = v172
Instance.new("UICorner", v176).CornerRadius = v74(1068 - (728 + 340), 8)
local v183 = Instance.new("TextLabel")
v183.Size = v73(1791 - (816 + 974), 0 - 0, 1, 0 - 0)
v183.BackgroundTransparency = 340 - (163 + 176)
v183.Text = "J"
v183.TextColor3 = v79
v183.Font = v76.Font.GothamBlack
v183.TextSize = 56 - 36
v183.Parent = v176
local v192 = Instance.new("TextLabel")
v192.Size = v73(4 - 3, -(20 + 46), 0, 16)
v192.Position = v73(0, 1874 - (1564 + 246), 345 - (124 + 221), 14 + 6)
v192.BackgroundTransparency = 452 - (115 + 336)
v192.Text = "JUST TEAM"
v192.TextColor3 = v85
v192.Font = v76.Font.GothamBold
v192.TextSize = 30 - 16
v192.TextXAlignment = v76.TextXAlignment.Left
v192.Parent = v172
local v204 = Instance.new("TextLabel")
v204.Size = v73(1 + 0, -66, 46 - (45 + 1), 12)
v204.Position = v73(0 + 0, 2054 - (1282 + 708), 0, 1249 - (583 + 629))
v204.BackgroundTransparency = 1 + 0
v204.Text = "PREMIUM"
v204.TextColor3 = v77
v204.Font = v76.Font.GothamBold
v204.TextSize = 23 - 14
v204.TextXAlignment = v76.TextXAlignment.Left
v204.Parent = v172
local v214 = Instance.new("Frame")
v214.Size = v73(1 + 0, -20, 1170 - (943 + 227), 1)
v214.Position = v73(0 + 0, 1641 - (1539 + 92), 1946 - (706 + 1240), 332 - (81 + 177))
v214.BackgroundColor3 = v83
v214.BorderSizePixel = 0 - 0
v214.Parent = v160
local v220 = Instance.new("Frame")
v220.Size = v73(258 - (212 + 45), -(66 - 46), 1947 - (708 + 1238), -(10 + 100))
v220.Position = v73(0 + 0, 10, 1667 - (586 + 1081), 597 - (348 + 163))
v220.BackgroundTransparency = 1 + 0
v220.Parent = v160
local v225 = Instance.new("UIListLayout")
v225.Padding = v74(280 - (215 + 65), 7 - 4)
v225.SortOrder = v76.SortOrder.LayoutOrder
v225.Parent = v220
local v229 = Instance.new("Frame")
v229.Size = v73(1860 - (1541 + 318), -(161 + 20), 1, 0 + 0)
v229.Position = v73(0 + 0, 1931 - (1036 + 714), 0, 0 + 0)
v229.BackgroundTransparency = 1 + 0
v229.ZIndex = 1282 - (883 + 397)
v229.Parent = v143
local v235 = Instance.new("Frame")
v235.Size = v73(591 - (563 + 27), 0, 0 - 0, 54)
v235.BackgroundColor3 = v80
v235.BorderSizePixel = 0
v235.ZIndex = 1988 - (1369 + 617)
v235.Parent = v229
local v241 = Instance.new("Frame")
v241.Size = v73(1, 1487 - (85 + 1402), 0 + 0, 2 - 1)
v241.Position = v73(0, 403 - (274 + 129), 218 - (12 + 205), -(1 + 0))
v241.BackgroundColor3 = v83
v241.BorderSizePixel = 0 - 0
v241.Parent = v235
local v247 = Instance.new("TextLabel")
v247.Size = v73(1, -110, 1 + 0, 384 - (27 + 357))
v247.Position = v73(0, 504 - (91 + 389), 297 - (90 + 207), 0 + 0)
v247.BackgroundTransparency = 862 - (706 + 155)
v247.Text = "MOVEMENT"
v247.TextColor3 = v85
v247.Font = v76.Font.GothamBold
v247.TextSize = 1809 - (730 + 1065)
v247.TextXAlignment = v76.TextXAlignment.Left
v247.Parent = v235
local v257 = Instance.new("Frame")
v257.Size = v73(1563 - (1339 + 224), 46, 0 + 0, 2)
v257.Position = v73(0 + 0, 35 - 11, 844 - (268 + 575), -3)
v257.BackgroundColor3 = v77
v257.BorderSizePixel = 0
v257.Parent = v235
Instance.new("UICorner", v257).CornerRadius = v74(1295 - (919 + 375), 0)
local v264 = Instance.new("TextButton")
v264.Size = v73(0 - 0, 999 - (180 + 791), 1805 - (323 + 1482), 1946 - (1177 + 741))
v264.Position = v73(1 + 0, -(277 - 203), 0.5, -(6 + 8))
v264.BackgroundColor3 = v81
v264.Text = "-"
v264.TextColor3 = v86
v264.Font = v76.Font.GothamBold
v264.TextSize = 30 - 16
v264.AutoButtonColor = false
v264.Parent = v235
Instance.new("UICorner", v264).CornerRadius = v74(0 + 0, 115 - (96 + 13))
local v275 = Instance.new("TextButton")
v275.Size = v73(0, 1949 - (962 + 959), 0 - 0, 28)
v275.Position = v73(1 + 0, -(1391 - (461 + 890)), 0.5 + 0, -(54 - 40))
v275.BackgroundColor3 = v81
v275.Text = "X"
v275.TextColor3 = v89
v275.Font = v76.Font.GothamBold
v275.TextSize = 257 - (19 + 224)
v275.AutoButtonColor = false
v275.Parent = v235
Instance.new("UICorner", v275).CornerRadius = v74(0 + 0, 204 - (37 + 161))
local v286 = Instance.new("Frame")
v286.Size = v73(1 + 0, -(12 + 18), 1 + 0, -(135 - (60 + 1)))
v286.Position = v73(923 - (826 + 97), 15, 0, 62 + 2)
v286.BackgroundTransparency = 1
v286.ZIndex = 2
v286.Parent = v229
local v292 = {}
local v293 = nil
local v294 = {}
local function v295(v781)
    local v782 = 0 - 0
    local v783
    local v784
    local v785
    while true do
        if v782 == (1 - 0) then
            v785 = nil
            while true do
                if v783 == 1 then
                    local v1440 = 0
                    while true do
                        if v1440 == 0 then
                            v785 = nil
                            function v785()
                                v781.CanvasSize =
                                    v73(0, 685 - (375 + 310), 0, v784.AbsoluteContentSize.Y + (2023 - (1864 + 135)))
                            end
                            v1440 = 2 - 1
                        end
                        if (1 + 0) == v1440 then
                            v783 = 2
                            break
                        end
                    end
                end
                if v783 == (0 + 0) then
                    v784 = v781:FindFirstChildOfClass("UIListLayout")
                    if not v784 then
                        return
                    end
                    v783 = 1
                end
                if v783 == (7 - 4) then
                    v781.ChildRemoved:Connect(function()
                        task.defer(v785)
                    end)
                    task.defer(v785)
                    break
                end
                if (1133 - (314 + 817)) == v783 then
                    v784:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(v785)
                    v781.ChildAdded:Connect(function()
                        task.defer(v785)
                    end)
                    v783 = 2 + 1
                end
            end
            break
        end
        if v782 == 0 then
            v783 = 0
            v784 = nil
            v782 = 215 - (32 + 182)
        end
    end
end
local function v296(v786)
    local v787 = 0 + 0
    local v788
    local v789
    local v790
    while true do
        if v787 == (0 - 0) then
            v788 = 65 - (39 + 26)
            v789 = nil
            v787 = 1
        end
        if v787 == 1 then
            v790 = nil
            while true do
                if v788 == 3 then
                    v790 = Instance.new("UIListLayout")
                    v790.Padding = v74(144 - (54 + 90), 204 - (45 + 153))
                    v790.SortOrder = v76.SortOrder.LayoutOrder
                    v790.Parent = v789
                    v788 = 3 + 1
                end
                if v788 == 1 then
                    v789.ScrollBarThickness = 554 - (457 + 95)
                    v789.ScrollBarImageColor3 = v78
                    v789.ScrollBarImageTransparency = 0.4
                    v789.CanvasSize = v73(0 + 0, 0 - 0, 0, 0 - 0)
                    v788 = 2
                end
                if v788 == 2 then
                    v789.ScrollingDirection = v76.ScrollingDirection.Y
                    v789.Visible = false
                    v789.ZIndex = 2
                    v789.Parent = v286
                    v788 = 10 - 7
                end
                if 0 == v788 then
                    v789 = Instance.new("ScrollingFrame")
                    v789.Size = v73(1 + 0, 0 - 0, 1, 0)
                    v789.BackgroundTransparency = 2 - 1
                    v789.BorderSizePixel = 748 - (485 + 263)
                    v788 = 708 - (575 + 132)
                end
                if v788 == (865 - (750 + 111)) then
                    local v1457 = 1010 - (445 + 565)
                    local v1458
                    while true do
                        if (0 + 0) == v1457 then
                            v1458 = 0 + 0
                            while true do
                                if v1458 == (1 - 0) then
                                    v295(v789)
                                    return v789
                                end
                                if v1458 == 0 then
                                    Instance.new("UIPadding", v789).PaddingRight = v74(0, 8)
                                    v292[v786] = v789
                                    v1458 = 1 + 0
                                end
                            end
                            break
                        end
                    end
                end
            end
            break
        end
    end
end
local function v297(v791)
    if v293 ~= v791 then
    else
        return
    end
    v293 = v791
    v247.Text = v791:upper()
    for v1155, v1156 in pairs(v292) do
        v1156.Visible = v1155 == v791
    end
    for v1158, v1159 in pairs(v294) do
        local v1160 = 310 - (189 + 121)
        local v1161
        while true do
            if v1160 == (0 + 0) then
                local v1335 = 1347 - (634 + 713)
                while true do
                    if v1335 == (538 - (493 + 45)) then
                        v1161 = v1158 == v791
                        v66
                            :Create(
                                v1159.indicator,
                                v75(968.2 - (493 + 475)),
                                {
                                    ["BackgroundTransparency"] = (v1161 and (0 + 0)) or (785 - (158 + 626)),
                                    ["Size"] = (v1161 and v73(0 + 0, 2 - 0, 0 + 0, 18))
                                        or v73(0 + 0, 0, 0, 1109 - (1035 + 56)),
                                }
                            )
                            :Play()
                        v1335 = 960 - (114 + 845)
                    end
                    if 1 == v1335 then
                        v1160 = 1 + 0
                        break
                    end
                end
            end
            if v1160 == 1 then
                v66:Create(v1159.label, v75(0.2 - 0), { ["TextColor3"] = (v1161 and v85) or v86 }):Play()
                v66:Create(v1159.button, v75(0.2), { ["BackgroundColor3"] = (v1161 and v82) or v80 }):Play()
                break
            end
        end
    end
end
local function v298(v793)
    local v794 = 0
    local v795
    local v796
    local v797
    while true do
        if v794 == (6 + 0) then
            v797.Parent = v795
            v795.MouseEnter:Connect(function()
                if v293 == v793 then
                else
                    v66:Create(v795, v75(1049.15 - (179 + 870)), { ["BackgroundColor3"] = v82 }):Play()
                end
            end)
            v795.MouseLeave:Connect(function()
                if v293 == v793 then
                else
                    v66:Create(v795, v75(0.15 - 0), { ["BackgroundColor3"] = v80 }):Play()
                end
            end)
            v795.MouseButton1Click:Connect(function()
                v297(v793)
            end)
            v794 = 885 - (827 + 51)
        end
        if v794 == 7 then
            v294[v793] = { ["button"] = v795, ["indicator"] = v796, ["label"] = v797 }
            break
        end
        if v794 == (0 - 0) then
            v795 = Instance.new("TextButton")
            v795.Size = v73(1 + 0, 0, 0, 36)
            v795.BackgroundColor3 = v80
            v795.Text = ""
            v794 = 474 - (95 + 378)
        end
        if v794 == (1 + 0) then
            v795.AutoButtonColor = false
            v795.Parent = v220
            Instance.new("UICorner", v795).CornerRadius = v74(0 - 0, 6 + 0)
            v796 = Instance.new("Frame")
            v794 = 1013 - (334 + 677)
        end
        if v794 == (18 - 13) then
            v797.TextColor3 = v86
            v797.Font = v76.Font.GothamMedium
            v797.TextSize = 1068 - (1049 + 7)
            v797.TextXAlignment = v76.TextXAlignment.Left
            v794 = 26 - 20
        end
        if (5 - 2) == v794 then
            v796.BackgroundTransparency = 1 + 0
            v796.Parent = v795
            Instance.new("UICorner", v796).CornerRadius = v74(2 - 1, 0)
            v797 = Instance.new("TextLabel")
            v794 = 4
        end
        if v794 == (7 - 3) then
            v797.Size = v73(1 + 0, -(1440 - (1004 + 416)), 1958 - (1621 + 336), 1939 - (337 + 1602))
            v797.Position = v73(1517 - (1014 + 503), 1031 - (446 + 569), 0, 0)
            v797.BackgroundTransparency = 1 + 0
            v797.Text = v793
            v794 = 5
        end
        if v794 == (5 - 3) then
            v796.Size = v73(0 + 0, 0 - 0, 0 + 0, 523 - (223 + 282))
            v796.Position = v73(0, 0 + 0, 0.5 - 0, -(12 - 3))
            v796.BackgroundColor3 = v77
            v796.BorderSizePixel = 670 - (623 + 47)
            v794 = 48 - (32 + 13)
        end
    end
end
local function v299(v798, v799)
    local v800 = 0 + 0
    local v801
    local v802
    local v803
    while true do
        if v800 == (1 + 0) then
            v801.Parent = v798
            v802 = Instance.new("Frame")
            v802.Size = v73(1801 - (1070 + 731), 2 + 0, 1404 - (1257 + 147), 12)
            v800 = 1 + 1
        end
        if v800 == 6 then
            v803.TextSize = 19 - 9
            v803.TextXAlignment = v76.TextXAlignment.Left
            v803.Parent = v801
            break
        end
        if v800 == 2 then
            v802.Position = v73(0, 2, 133.5 - (98 + 35), -(3 + 3))
            v802.BackgroundColor3 = v77
            v802.BorderSizePixel = 0 - 0
            v800 = 9 - 6
        end
        if v800 == (0 + 0) then
            v801 = Instance.new("Frame")
            v801.Size = v73(1, 0 + 0, 0 + 0, 585 - (395 + 162))
            v801.BackgroundTransparency = 1
            v800 = 1 + 0
        end
        if v800 == (1946 - (816 + 1125)) then
            v803.Text = v799:upper()
            v803.TextColor3 = v87
            v803.Font = v76.Font.GothamBold
            v800 = 7 - 1
        end
        if v800 == (1152 - (701 + 447)) then
            local v1283 = 0 - 0
            while true do
                if v1283 == 0 then
                    v803.Size = v73(1 - 0, -(1355 - (391 + 950)), 2 - 1, 0 - 0)
                    v803.Position = v73(0 - 0, 14, 0 + 0, 0)
                    v1283 = 1 + 0
                end
                if v1283 == 1 then
                    v803.BackgroundTransparency = 1
                    v800 = 18 - 13
                    break
                end
            end
        end
        if v800 == (1525 - (251 + 1271)) then
            v802.Parent = v801
            Instance.new("UICorner", v802).CornerRadius = v74(1 + 0, 0 - 0)
            v803 = Instance.new("TextLabel")
            v800 = 9 - 5
        end
    end
end
local function v300(v804, v805, v806, v807)
    local v808 = Instance.new("TextButton")
    v808.Size = v73(1, 0 - 0, 1259 - (1147 + 112), 10 + 30)
    v808.BackgroundColor3 = v81
    v808.Text = ""
    v808.AutoButtonColor = false
    v808.Parent = v804
    Instance.new("UICorner", v808).CornerRadius = v74(0 - 0, 2 + 4)
    local v815 = Instance.new("UIStroke", v808)
    v815.Color = v83
    v815.Thickness = 698 - (335 + 362)
    local v818 = Instance.new("TextLabel")
    v818.Size = v73(1 + 0, -(120 - 40), 2 - 1, 0 - 0)
    v818.Position = v73(0, 14, 0, 0 - 0)
    v818.BackgroundTransparency = 2 - 1
    v818.Text = v805
    v818.TextColor3 = v86
    v818.Font = v76.Font.GothamMedium
    v818.TextSize = 578 - (237 + 329)
    v818.TextXAlignment = v76.TextXAlignment.Left
    v818.Parent = v808
    local v830 = Instance.new("Frame")
    v830.Size = v73(0 - 0, 26 + 12, 0 + 0, 1144 - (408 + 716))
    v830.Position = v73(3 - 2, -52, 0.5, -10)
    v830.BackgroundColor3 = v72(847 - (344 + 477), 5 + 23, 38)
    v830.BorderSizePixel = 1761 - (1188 + 573)
    v830.Parent = v808
    Instance.new("UICorner", v830).CornerRadius = v74(2 - 1, 0 + 0)
    local v837 = Instance.new("Frame")
    v837.Size = v73(0, 45 - 31, 0, 21 - 7)
    v837.Position = v73(0 - 0, 1532 - (508 + 1021), 0.5 + 0, -(1173 - (228 + 938)))
    v837.BackgroundColor3 = v87
    v837.BorderSizePixel = 685 - (332 + 353)
    v837.Parent = v830
    Instance.new("UICorner", v837).CornerRadius = v74(1 - 0, 0 - 0)
    local v844 = v806 or false
    local v845 = v75(0.2 + 0, v76.EasingStyle.Quad, v76.EasingDirection.Out)
    local function v846()
        if v844 then
            local v1286 = 0 + 0
            while true do
                if v1286 == 1 then
                    v66:Create(v818, v845, { ["TextColor3"] = v85 }):Play()
                    v66:Create(v815, v845, { ["Color"] = v78 }):Play()
                    break
                end
                if v1286 == 0 then
                    v66:Create(v830, v845, { ["BackgroundColor3"] = v77 }):Play()
                    v66
                        :Create(
                            v837,
                            v845,
                            {
                                ["Position"] = v73(1, -(67 - 50), 423.5 - (18 + 405), -(4 + 3)),
                                ["BackgroundColor3"] = v72(129 + 126, 388 - 133, 1233 - (194 + 784)),
                            }
                        )
                        :Play()
                    v1286 = 1771 - (694 + 1076)
                end
            end
        else
            v66:Create(v830, v845, { ["BackgroundColor3"] = v72(26, 28, 1942 - (122 + 1782)) }):Play()
            v66:Create(v837, v845, { ["Position"] = v73(0 + 0, 3 + 0, 0.5, -7), ["BackgroundColor3"] = v87 }):Play()
            v66:Create(v818, v845, { ["TextColor3"] = v86 }):Play()
            v66:Create(v815, v845, { ["Color"] = v83 }):Play()
        end
    end
    v846()
    v808.MouseButton1Click:Connect(function()
        v844 = not v844
        v846()
        pcall(v807, v844)
    end)
    return function(v1162)
        local v1163 = 0 + 0
        while true do
            if v1163 == (0 + 0) then
                if v1162 ~= nil then
                    local v1462 = 0 - 0
                    while true do
                        if v1462 == (0 + 0) then
                            v844 = v1162
                            v846()
                            break
                        end
                    end
                end
                return v844
            end
        end
    end
end
local function v301(v847, v848, v849, v850, v851, v852)
    local v853 = Instance.new("Frame")
    v853.Size = v73(1971 - (214 + 1756), 0, 0 - 0, 7 + 49)
    v853.BackgroundColor3 = v81
    v853.BorderSizePixel = 0 + 0
    v853.Parent = v847
    Instance.new("UICorner", v853).CornerRadius = v74(0, 6)
    local v859 = Instance.new("UIStroke", v853)
    v859.Color = v83
    v859.Thickness = 1
    local v862 = Instance.new("TextLabel")
    v862.Size = v73(1, -(685 - (217 + 368)), 0 - 0, 22)
    v862.Position = v73(0, 14, 0 + 0, 5 + 1)
    v862.BackgroundTransparency = 1 + 0
    v862.Text = v848
    v862.TextColor3 = v86
    v862.Font = v76.Font.GothamMedium
    v862.TextSize = 901 - (844 + 45)
    v862.TextXAlignment = v76.TextXAlignment.Left
    v862.Parent = v853
    local v874 = Instance.new("TextLabel")
    v874.Size = v73(0, 70, 0, 306 - (242 + 42))
    v874.Position = v73(1 - 0, -84, 0 - 0, 6)
    v874.BackgroundTransparency = 1201 - (132 + 1068)
    v874.Text = tostring(v851)
    v874.TextColor3 = v77
    v874.Font = v76.Font.GothamBold
    v874.TextSize = 18 - 6
    v874.TextXAlignment = v76.TextXAlignment.Right
    v874.Parent = v853
    local v886 = Instance.new("Frame")
    v886.Size = v73(1624 - (214 + 1409), -28, 0, 4 + 1)
    v886.Position = v73(0, 14, 1635 - (497 + 1137), -(958 - (9 + 931)))
    v886.BackgroundColor3 = v72(28, 319 - (181 + 108), 24 + 16)
    v886.BorderSizePixel = 0
    v886.Parent = v853
    Instance.new("UICorner", v886).CornerRadius = v74(2 - 1, 0)
    local v893 = Instance.new("Frame")
    v893.Size = v73((v851 - v849) / (v850 - v849), 0 - 0, 1 + 0, 0 + 0)
    v893.BackgroundColor3 = v77
    v893.BorderSizePixel = 476 - (296 + 180)
    v893.Parent = v886
    Instance.new("UICorner", v893).CornerRadius = v74(1, 1403 - (1183 + 220))
    local v899 = Instance.new("Frame")
    v899.Size = v73(1265 - (1037 + 228), 18 - 6, 0 - 0, 40 - 28)
    v899.AnchorPoint = v70(0.5, 734.5 - (527 + 207))
    v899.Position = v73((v851 - v849) / (v850 - v849), 527 - (187 + 340), 1870.5 - (1298 + 572), 0 - 0)
    v899.BackgroundColor3 = v72(255, 425 - (144 + 26), 255)
    v899.BorderSizePixel = 0
    v899.ZIndex = 7 - 4
    v899.Parent = v886
    Instance.new("UICorner", v899).CornerRadius = v74(1, 0 - 0)
    local v908 = v851
    local v909 = false
    local function v910(v1164)
        local v1165 = 0 + 0
        local v1166
        while true do
            if v1165 == 3 then
                v874.Text = tostring(v908)
                pcall(v852, v908)
                break
            end
            if v1165 == (2 - 1) then
                v908 = math.floor(v1164 + (0.5 - 0))
                v1166 = (v908 - v849) / (v850 - v849)
                v1165 = 9 - 7
            end
            if v1165 == (0 + 0) then
                if v1164 == v1164 then
                else
                    v1164 = v851
                end
                v1164 = math.clamp(v1164, v849, v850)
                v1165 = 1
            end
            if 2 == v1165 then
                v893.Size = v73(v1166, 0 - 0, 1 + 0, 0 + 0)
                v899.Position = v73(v1166, 202 - (5 + 197), 0.5, 0)
                v1165 = 689 - (339 + 347)
            end
        end
    end
    local function v911(v1167)
        local v1168 = (v1167.Position.X - v886.AbsolutePosition.X) / v886.AbsoluteSize.X
        v910(v849 + (v1168 * (v850 - v849)))
    end
    v886.InputBegan:Connect(function(v1169)
        if
            (v1169.UserInputType == v76.UserInputType.MouseButton1) or (v1169.UserInputType == v76.UserInputType.Touch)
        then
            local v1287 = 0
            while true do
                if v1287 == 0 then
                    v909 = true
                    v911(v1169)
                    break
                end
            end
        end
    end)
    v64.InputChanged:Connect(function(v1170)
        if
            v909
            and (
                (v1170.UserInputType == v76.UserInputType.MouseMovement)
                or (v1170.UserInputType == v76.UserInputType.Touch)
            )
        then
            v911(v1170)
        end
    end)
    v64.InputEnded:Connect(function(v1171)
        if
            (v1171.UserInputType == v76.UserInputType.MouseButton1) or (v1171.UserInputType == v76.UserInputType.Touch)
        then
            v909 = false
        end
    end)
    return v910
end
local v302 = { "Movement", "Visuals", "Combat", "World", "Settings" }
for v912, v913 in ipairs(v302) do
    local v914 = 0
    local v915
    while true do
        if v914 == (0 - 0) then
            v915 = 0 - 0
            while true do
                if 0 == v915 then
                    v298(v913)
                    v296(v913)
                    break
                end
            end
            break
        end
    end
end
local v303 =
    { ["Object"] = nil, ["Root"] = nil, ["Humanoid"] = nil, ["Attach"] = nil, ["SpeedLV"] = nil, ["FlyLV"] = nil }
local function v304()
    local v916 = 924 - (837 + 87)
    local v917
    while true do
        if v916 == (0 - 0) then
            v917 = 1670 - (837 + 833)
            while true do
                if v917 == (1 + 1) then
                    v303.SpeedLV = nil
                    v303.FlyLV = nil
                    break
                end
                if v917 == 0 then
                    v303.Object = nil
                    v303.Root = nil
                    v917 = 1388 - (356 + 1031)
                end
                if (1 + 0) == v917 then
                    v303.Humanoid = nil
                    v303.Attach = nil
                    v917 = 1648 - (73 + 1573)
                end
            end
            break
        end
    end
end
local function v305(v918)
    v304()
    v303.Object = v918
    local v920 = v918:WaitForChild("HumanoidRootPart", 1396 - (1307 + 81))
    local v921 = v918:WaitForChild("Humanoid", 242 - (7 + 227))
    if not v920 or not v921 then
        return
    end
    v303.Root = v920
    v303.Humanoid = v921
    local v924 = Instance.new("Attachment")
    v924.Name = v92("a_")
    v924.Parent = v920
    v303.Attach = v924
    local v928 = Instance.new("LinearVelocity")
    v928.Name = v92("lv_")
    v928.Attachment0 = v924
    v928.MaxForce = 0 - 0
    v928.RelativeTo = v76.ActuatorRelativeTo.World
    v928.VectorVelocity = v71(166 - (90 + 76), 0 - 0, 0 + 0)
    v928.Enabled = false
    v928.Parent = v920
    v303.SpeedLV = v928
    local v938 = Instance.new("LinearVelocity")
    v938.Name = v92("lv_")
    v938.Attachment0 = v924
    v938.MaxForce = 0
    v938.RelativeTo = v76.ActuatorRelativeTo.World
    v938.VectorVelocity = v71(0 + 0, 0 + 0, 0 - 0)
    v938.Enabled = false
    v938.Parent = v920
    v303.FlyLV = v938
end
local function v306(v947)
    local v948 = 0
    while true do
        if v948 == 0 then
            v305(v947)
            if v128.Hitbox.Enabled and v128.Hitbox.OnCharacter then
                task.wait(0.2)
                v128.Hitbox.OnCharacter(v947)
            end
            break
        end
    end
end
if v68.Character then
    task.spawn(v306, v68.Character)
end
v132("CharAdded", v68.CharacterAdded:Connect(v306))
local function v307(v949)
    local v950 = 260 - (197 + 63)
    local v951
    while true do
        if v950 == (0 + 0) then
            for v1339, v1340 in ipairs(v128.Noclip.Watchers) do
                pcall(function()
                    v1340:Disconnect()
                end)
            end
            v128.Noclip.Watchers = {}
            v950 = 1 + 0
        end
        if v950 == (2 + 0) then
            function v951(v1341)
                if v1341:IsA("BasePart") then
                    v128.Noclip.Cache[v1341] = true
                end
            end
            for v1342, v1343 in ipairs(v949:GetDescendants()) do
                if v1343:IsA("BasePart") then
                    v128.Noclip.Cache[v1343] = true
                end
            end
            v950 = 3
        end
        if v950 == (1 + 0) then
            v128.Noclip.Cache = {}
            v951 = nil
            v950 = 2
        end
        if v950 == 3 then
            table.insert(v128.Noclip.Watchers, v949.DescendantAdded:Connect(v951))
            table.insert(
                v128.Noclip.Watchers,
                v949.DescendantRemoving:Connect(function(v1344)
                    v128.Noclip.Cache[v1344] = nil
                end)
            )
            break
        end
    end
end
if v68.Character then
    v307(v68.Character)
end
v132("NoclipChar", v68.CharacterAdded:Connect(v307))
local function v308(v952)
    local v953 = 0 - 0
    local v954
    while true do
        if 0 == v953 then
            v954 = v128.Hitbox.Cache[v952]
            if not v954 then
                return
            end
            v953 = 1
        end
        if v953 == (1370 - (618 + 751)) then
            for v1346, v1347 in pairs(v954) do
                if v1346 and v1346.Parent then
                    pcall(function()
                        v1346.Size = v1347
                    end)
                end
            end
            v128.Hitbox.Cache[v952] = nil
            break
        end
    end
end
local function v309(v955)
    local v956 = 0 + 0
    local v957
    local v958
    local v959
    while true do
        if v956 == 3 then
            local v1292 = 1910 - (206 + 1704)
            while true do
                if v1292 == (0 - 0) then
                    v959 = v71(v128.Hitbox.Size, v128.Hitbox.Size, v128.Hitbox.Size)
                    for v1516, v1517 in ipairs({ "Head", "UpperTorso", "LowerTorso", "Torso", "HumanoidRootPart" }) do
                        local v1518 = 1506 - (396 + 1110)
                        local v1519
                        while true do
                            if v1518 == (0 - 0) then
                                v1519 = v957:FindFirstChild(v1517)
                                if v1519 and v1519:IsA("BasePart") then
                                    local v1578 = 0 + 0
                                    while true do
                                        if v1578 == (0 + 0) then
                                            v958[v1519] = v1519.Size
                                            pcall(function()
                                                local v1599 = 0 + 0
                                                while true do
                                                    if v1599 == 1 then
                                                        v1519.CanCollide = false
                                                        break
                                                    end
                                                    if v1599 == 0 then
                                                        v1519.Size = v959
                                                        v1519.Massless = true
                                                        v1599 = 977 - (230 + 746)
                                                    end
                                                end
                                            end)
                                            break
                                        end
                                    end
                                end
                                break
                            end
                        end
                    end
                    v1292 = 1
                end
                if v1292 == 1 then
                    v956 = 605 - (473 + 128)
                    break
                end
            end
        end
        if v956 == 1 then
            if not v128.Hitbox.Enabled then
                return
            end
            v957 = v955.Character
            v956 = 50 - (39 + 9)
        end
        if v956 == 2 then
            if not v957 then
                return
            end
            v958 = {}
            v956 = 269 - (38 + 228)
        end
        if v956 == 0 then
            if v955 ~= v68 then
            else
                return
            end
            v308(v955)
            v956 = 1
        end
        if v956 == (6 - 2) then
            v128.Hitbox.Cache[v955] = v958
            break
        end
    end
end
v128.Hitbox.OnCharacter = function(v960)
    local v961 = 473 - (106 + 367)
    local v962
    while true do
        if v961 == 0 then
            v962 = v62:GetPlayerFromCharacter(v960)
            if v962 and v128.Hitbox.Enabled then
                local v1388 = 0 + 0
                while true do
                    if v1388 == (1862 - (354 + 1508)) then
                        task.wait(0.3)
                        v309(v962)
                        break
                    end
                end
            end
            break
        end
    end
end
v132(
    "HB_Added",
    v62.PlayerAdded:Connect(function(v963)
        v963.CharacterAdded:Connect(function()
            local v1172 = 0 - 0
            while true do
                if v1172 == 0 then
                    task.wait(0.3)
                    if v128.Hitbox.Enabled then
                        v309(v963)
                    end
                    break
                end
            end
        end)
    end)
)
v132("HB_Removed", v62.PlayerRemoving:Connect(v308))
for v964, v965 in ipairs(v62:GetPlayers()) do
    if v965 ~= v68 then
        v965.CharacterAdded:Connect(function()
            local v1295 = 0
            while true do
                if v1295 == 0 then
                    task.wait(0.3)
                    if v128.Hitbox.Enabled then
                        v309(v965)
                    end
                    break
                end
            end
        end)
    end
end
local v311 = (function()
    if not Drawing then
        return false
    end
    local v966 = pcall(function()
        local v1173 = Drawing.new("Line")
        v1173:Remove()
    end)
    return v966
end)()
local v312 = v77
local v313 = v72(147 + 53, 121 + 84, 220)
local v314 = v72(342 - 87, 1499 - (334 + 910), 1150 - (92 + 803))
local v315 = v72(45 + 35, 1401 - (1035 + 146), 746 - (230 + 386))
local v316 = v72(80, 128 + 92, 130)
local v317 = v72(255, 1710 - (353 + 1157), 1174 - (53 + 1061))
local v318 = v72(1890 - (1568 + 67), 28 + 32, 9 + 51)
local function v319(v967)
    if v967 > 0.5 then
        return v316:Lerp(v317, ((2 - 1) - v967) * (5 - 3))
    end
    return v317:Lerp(v318, (2 - 1) - (v967 * (2 + 0)))
end
local function v320(v968)
    local v969 = v133(Drawing.new("Square"))
    v969.Thickness = 1
    v969.Color = v312
    v969.Filled = false
    v969.Transparency = 1213 - (615 + 597)
    v969.Visible = false
    local v975 = v133(Drawing.new("Square"))
    v975.Filled = true
    v975.Color = v72(18 + 2, 29 - 9, 17 + 3)
    v975.Transparency = 0.5 + 0
    v975.Visible = false
    local v980 = v133(Drawing.new("Square"))
    v980.Filled = true
    v980.Color = v316
    v980.Transparency = 0.1 + 0
    v980.Visible = false
    local v985 = v133(Drawing.new("Line"))
    v985.Thickness = 1900 - (1056 + 843)
    v985.Color = v313
    v985.Transparency = 0.4 - 0
    v985.Visible = false
    local v990 = v133(Drawing.new("Text"))
    v990.Size = v128.ESP.TextSize
    v990.Center = true
    v990.Outline = true
    v990.OutlineColor = v72(0 - 0, 0 - 0, 0 + 0)
    v990.Color = v314
    v990.Font = Drawing.Fonts.Plex
    v990.Transparency = 1
    v990.Visible = false
    local v1001 = v133(Drawing.new("Text"))
    v1001.Size = v128.ESP.TextSize - (1978 - (286 + 1690))
    v1001.Center = true
    v1001.Outline = true
    v1001.OutlineColor = v72(911 - (98 + 813), 0, 0 + 0)
    v1001.Color = v315
    v1001.Font = Drawing.Fonts.Plex
    v1001.Transparency = 1
    v1001.Visible = false
    local v1010 = { ["Player"] = v968 }
    v1010.Update = function(v1174)
        local v1175 = 0 - 0
        local v1176
        local v1177
        local v1178
        local v1179
        local v1180
        local v1181
        local v1182
        local v1183
        local v1184
        local v1185
        local v1186
        local v1187
        local v1188
        local v1189
        while true do
            if v1175 == (4 + 2) then
                if v990.Visible then
                    local v1471 = 0
                    while true do
                        if v1471 == (508 - (263 + 244)) then
                            v990.Position = v70(v1187, v1188 - (16 + 4))
                            break
                        end
                        if v1471 == 0 then
                            v990.Text = v968.Name
                            v990.Size = v128.ESP.TextSize
                            v1471 = 1688 - (1502 + 185)
                        end
                    end
                end
                v1001.Visible = v128.ESP.Distance
                if v1001.Visible and v303.Root then
                    local v1472 = (v303.Root.Position - v1180).Magnitude
                    v1001.Text = string.format("[%dm]", math.floor(v1472))
                    v1001.Size = v128.ESP.TextSize - 2
                    v1001.Position = v70(v1187, v1188 + v1185 + 2)
                end
                break
            end
            if v1175 == (0 + 0) then
                function v1176()
                    v969.Visible = false
                    v975.Visible = false
                    v980.Visible = false
                    v985.Visible = false
                    v990.Visible = false
                    v1001.Visible = false
                end
                if not v128.ESP.Enabled then
                    local v1476 = 0 - 0
                    while true do
                        if v1476 == (0 - 0) then
                            v1176()
                            return
                        end
                    end
                end
                v1177 = v968.Character
                if not v1177 then
                    local v1477 = 1527 - (629 + 898)
                    while true do
                        if v1477 == 0 then
                            v1176()
                            return
                        end
                    end
                end
                v1175 = 1
            end
            if v1175 == (2 - 1) then
                v1178 = v1177:FindFirstChild("HumanoidRootPart")
                v1179 = v1177:FindFirstChildOfClass("Humanoid")
                if not v1178 or not v1179 or (v1179.Health <= 0) then
                    v1176()
                    return
                end
                v1180 = v1178.Position
                v1175 = 2
            end
            if v1175 == (5 - 3) then
                v1181, v1182 = v69:WorldToViewportPoint(v1180 + v71(365 - (12 + 353), 1913.8 - (1680 + 231), 0 + 0))
                v1183, v1184 = v69:WorldToViewportPoint(v1180 - v71(0, 2.1 + 1, 0))
                if not v1182 or not v1184 then
                    local v1478 = 1149 - (212 + 937)
                    while true do
                        if v1478 == (0 + 0) then
                            v1176()
                            return
                        end
                    end
                end
                v1185 = math.abs(v1183.Y - v1181.Y)
                v1175 = 3
            end
            if v1175 == 5 then
                if v128.ESP.Health then
                    local v1479 = 1062 - (111 + 951)
                    local v1480
                    while true do
                        if v1479 == (1 + 1) then
                            v980.Position = v70(v1480, v1188 + (v1185 - (v1185 * v1189)))
                            v980.Color = v319(v1189)
                            break
                        end
                        if v1479 == (27 - (18 + 9)) then
                            local v1547 = 0 + 0
                            while true do
                                if v1547 == (534 - (31 + 503)) then
                                    v1480 = v1187 + (v1186 / (1634 - (595 + 1037))) + (1448 - (189 + 1255))
                                    v975.Size = v70(2 + 1, v1185)
                                    v1547 = 1
                                end
                                if v1547 == (1 - 0) then
                                    v1479 = 1280 - (1170 + 109)
                                    break
                                end
                            end
                        end
                        if (1818 - (348 + 1469)) == v1479 then
                            v975.Position = v70(v1480, v1188)
                            v980.Size = v70(3, v1185 * v1189)
                            v1479 = 1291 - (1115 + 174)
                        end
                    end
                end
                v985.Visible = v128.ESP.Tracer
                if v985.Visible then
                    local v1481 = v69.ViewportSize
                    v985.From = v70(v1481.X / 2, v1481.Y)
                    v985.To = v70(v1187, v1188 + v1185)
                end
                v990.Visible = v128.ESP.Name
                v1175 = 14 - 8
            end
            if v1175 == (1017 - (85 + 929)) then
                v1186 = v1185 * (0.5 + 0)
                v1187 = (v1181.X + v1183.X) * (1867.5 - (1151 + 716))
                v1188 = math.min(v1181.Y, v1183.Y)
                v969.Visible = v128.ESP.Box
                v1175 = 4
            end
            if v1175 == (2 + 2) then
                if v969.Visible then
                    v969.Size = v70(v1186, v1185)
                    v969.Position = v70(v1187 - (v1186 / (2 + 0)), v1188)
                end
                v1189 = math.clamp(v1179.Health / math.max(v1179.MaxHealth, 1705 - (95 + 1609)), 0, 3 - 2)
                v975.Visible = v128.ESP.Health
                v980.Visible = v128.ESP.Health
                v1175 = 763 - (364 + 394)
            end
        end
    end
    v1010.Destroy = function(v1190)
        for v1219, v1220 in ipairs({ v969, v975, v980, v985, v990, v1001 }) do
            pcall(function()
                v1220:Remove()
            end)
        end
    end
    return v1010
end
local function v321(v1013, v1014)
    local v1015 = Instance.new("Highlight")
    v1015.Name = v92()
    v1015.Adornee = v1014
    v1015.FillColor = v312
    v1015.OutlineColor = v72(208 + 47, 129 + 126, 131 + 124)
    v1015.FillTransparency = 0.6
    v1015.DepthMode = v76.HighlightDepthMode.AlwaysOnTop
    v1015.Parent = v91
    return {
        ["Player"] = v1013,
        ["Update"] = function() end,
        ["Destroy"] = function()
            pcall(function()
                v1015:Destroy()
            end)
        end,
    }
end
local function v322(v1024)
    local v1025 = 0
    while true do
        if 1 == v1025 then
            if not v1024.Character then
                return
            end
            if v311 then
                v128.ESP.Cache[v1024] = v320(v1024)
            else
                v128.ESP.Cache[v1024] = v321(v1024, v1024.Character)
            end
            break
        end
        if v1025 == 0 then
            if v1024 ~= v68 then
            else
                return
            end
            if v128.ESP.Cache[v1024] then
                return
            end
            v1025 = 1 + 0
        end
    end
end
local function v323(v1026)
    local v1027 = v128.ESP.Cache[v1026]
    if v1027 then
        local v1221 = 0 + 0
        while true do
            if v1221 == (0 + 0) then
                pcall(v1027.Destroy, v1027)
                v128.ESP.Cache[v1026] = nil
                break
            end
        end
    end
end
v132(
    "ESP_Add",
    v62.PlayerAdded:Connect(function(v1028)
        v1028.CharacterAdded:Connect(function()
            local v1191 = 956 - (719 + 237)
            local v1192
            while true do
                if v1191 == (0 - 0) then
                    v1192 = 0
                    while true do
                        if v1192 == (0 + 0) then
                            task.wait(0.4 - 0)
                            if v128.ESP.Enabled then
                                v322(v1028)
                            end
                            break
                        end
                    end
                    break
                end
            end
        end)
    end)
)
v132("ESP_Rem", v62.PlayerRemoving:Connect(v323))
for v1029, v1030 in ipairs(v62:GetPlayers()) do
    if v1030 == v68 then
    else
        v1030.CharacterAdded:Connect(function()
            task.wait(0.4 - 0)
            if v128.ESP.Enabled then
                v322(v1030)
            end
        end)
    end
end
local v324, v325
local function v326()
    local v1031 = 0
    while true do
        if v1031 == (0 - 0) then
            if not v128.FullBright.Enabled then
                return
            end
            pcall(function()
                v67.Ambient = v72(2169 - (761 + 1230), 371 - (80 + 113), 178)
                v67.OutdoorAmbient = v72(97 + 81, 120 + 58, 6 + 172)
                v67.Brightness = 3
                v67.ClockTime = 12
                v67.GlobalShadows = false
            end)
            break
        end
    end
end
local function v327()
    if not v128.NoFog.Enabled then
        return
    end
    pcall(function()
        local v1193 = 0 - 0
        while true do
            if v1193 == (0 + 0) then
                v67.FogEnd = 182782 + 817218
                v67.FogStart = 0
                break
            end
        end
    end)
end
v132(
    "LightingChanged",
    v67.Changed:Connect(function()
        local v1032 = 0
        local v1033
        while true do
            if v1032 == (1243 - (965 + 278)) then
                v1033 = 0
                while true do
                    if v1033 == (1729 - (1391 + 338)) then
                        if v128.FullBright.Enabled then
                            v326()
                        end
                        if v128.NoFog.Enabled then
                            v327()
                        end
                        break
                    end
                end
                break
            end
        end
    end)
)
local function v328(v1034)
    if v96 then
        local v1222 = pcall(v96, v1034)
        if v1222 then
            return true
        end
    end
    local v1035 = pcall(function()
        local v1194 = 0 - 0
        local v1195
        while true do
            if v1194 == (0 + 0) then
                v1195 = settings()
                v1195.Rendering.FramerateCap = v1034
                break
            end
        end
    end)
    if v1035 then
        return true
    end
    local v1036 = pcall(function()
        sethiddenproperty(game:GetService("RunService"), "FramerateCap", v1034)
    end)
    if v1036 then
        return true
    end
    return false
end
local function v329(v1037)
    local v1038 = v303.SpeedLV
    if not v1038 or not v303.Humanoid then
        return
    end
    local v1039 = v128.Speed.Enabled
        and not v128.Fly.Enabled
        and (v303.Humanoid.Health > 0)
        and (v303.Humanoid.MoveDirection.Magnitude > (0.05 - 0))
    if v1039 then
        local v1223 = 0
        local v1224
        while true do
            if v1223 == (1 + 0) then
                v1038.VectorVelocity = v71(v1224.X * v128.Speed.Value, 1408 - (496 + 912), v1224.Z * v128.Speed.Value)
                v1038.Enabled = true
                break
            end
            if v1223 == (0 - 0) then
                v1224 = v303.Humanoid.MoveDirection
                v1038.MaxForce = math.huge
                v1223 = 1
            end
        end
    elseif v1038.Enabled then
        local v1369 = 0 + 0
        while true do
            if v1369 == 0 then
                v1038.Enabled = false
                v1038.VectorVelocity = v71(0 - 0, 0, 0)
                break
            end
        end
    end
end
local function v330(v1040)
    local v1041 = 1330 - (1190 + 140)
    local v1042
    while true do
        if v1041 == (0 + 0) then
            local v1296 = 718 - (317 + 401)
            while true do
                if v1296 == (950 - (303 + 646)) then
                    v1041 = 3 - 2
                    break
                end
                if v1296 == (1732 - (1675 + 57)) then
                    v1042 = v303.FlyLV
                    if not v1042 or not v303.Humanoid then
                        return
                    end
                    v1296 = 1 + 0
                end
            end
        end
        if v1041 == (2 - 1) then
            if v128.Fly.Enabled and (v303.Humanoid.Health > (0 + 0)) then
                local v1403 = 977 - (338 + 639)
                local v1404
                while true do
                    if (380 - (320 + 59)) == v1403 then
                        if v131.S then
                            v1404 -= v69.CFrame.LookVector
                        end
                        if v131.A then
                            v1404 -= v69.CFrame.RightVector
                        end
                        if v131.D then
                            v1404 += v69.CFrame.RightVector
                        end
                        v1403 = 2 + 0
                    end
                    if v1403 == (735 - (628 + 104)) then
                        if v1404.Magnitude > 0.05 then
                            local v1562 = 0 - 0
                            local v1563
                            while true do
                                if v1562 == 0 then
                                    v1563 = v1404.Unit
                                    v1042.VectorVelocity = v71(
                                        v1563.X * v128.Fly.Speed,
                                        v1563.Y * v128.Fly.Vertical,
                                        v1563.Z * v128.Fly.Speed
                                    )
                                    break
                                end
                            end
                        else
                            v1042.VectorVelocity = v71(1891 - (439 + 1452), 1947 - (105 + 1842), 0 - 0)
                        end
                        v1042.Enabled = true
                        break
                    end
                    if v1403 == (0 - 0) then
                        if v303.Humanoid.PlatformStand ~= true then
                            v303.Humanoid.PlatformStand = true
                        end
                        v1404 = v71(0 - 0, 0 + 0, 0)
                        if v131.W then
                            v1404 += v69.CFrame.LookVector
                        end
                        v1403 = 1
                    end
                    if v1403 == (3 - 1) then
                        if v131.Space then
                            v1404 += v71(0 + 0, 1, 1164 - (274 + 890))
                        end
                        if v131.Shift then
                            v1404 -= v71(0 + 0, 1, 0 + 0)
                        end
                        v1042.MaxForce = math.huge
                        v1403 = 1 + 2
                    end
                end
            else
                if v1042.Enabled then
                    local v1522 = 0 + 0
                    while true do
                        if v1522 == (0 + 0) then
                            v1042.Enabled = false
                            v1042.VectorVelocity = v71(0 - 0, 0, 819 - (731 + 88))
                            break
                        end
                    end
                end
                if v303.Humanoid.PlatformStand then
                    v303.Humanoid.PlatformStand = false
                end
            end
            break
        end
    end
end
local v331 = false
local function v332()
    local v1043 = 0
    while true do
        if v1043 == 1 then
            v160.Visible = not v331
            v286.Visible = not v331
            v1043 = 2
        end
        if v1043 == (0 + 0) then
            v331 = not v331
            v66
                :Create(
                    v143,
                    v75(0.35 + 0, v76.EasingStyle.Quart, v76.EasingDirection.Out),
                    { ["Size"] = (v331 and v73(0, 142 + 518, 0, 78 - 24)) or v73(0 - 0, 1918 - 1258, 0 - 0, 427 + 43) }
                )
                :Play()
            v1043 = 1 + 0
        end
        if v1043 == 2 then
            v137((v331 and 0) or (3 + 11))
            break
        end
    end
end
v132(
    "MainLoop",
    v63.RenderStepped:Connect(function(v1044)
        local v1045 = 0 + 0
        while true do
            if v1045 == (158 - (139 + 19)) then
                if v303.Root and v303.Humanoid and (v303.Humanoid.Health > 0) then
                    local v1405 = 0 + 0
                    while true do
                        if v1405 == (1993 - (1687 + 306)) then
                            pcall(v329, v1044)
                            pcall(v330, v1044)
                            break
                        end
                    end
                end
                if v128.ESP.Enabled and v311 then
                    for v1487, v1488 in pairs(v128.ESP.Cache) do
                        if v1488.Update then
                            pcall(v1488.Update, v1488)
                        end
                    end
                end
                break
            end
        end
    end)
)
v132(
    "NoclipLoop",
    v63.Stepped:Connect(function()
        local v1046 = 0
        while true do
            if (0 - 0) == v1046 then
                if not v128.Noclip.Enabled then
                    return
                end
                for v1370 in pairs(v128.Noclip.Cache) do
                    if v1370 and v1370.Parent then
                        pcall(function()
                            v1370.CanCollide = false
                        end)
                    end
                end
                break
            end
        end
    end)
)
v132(
    "JumpReq",
    v64.JumpRequest:Connect(function()
        local v1047 = 1154 - (1018 + 136)
        while true do
            if (0 + 0) == v1047 then
                if not v303.Root or not v303.Humanoid then
                    return
                end
                if v303.Humanoid:GetState() == v76.HumanoidStateType.Dead then
                    return
                end
                v1047 = 4 - 3
            end
            if v1047 == (816 - (117 + 698)) then
                if v128.Jump.Infinite then
                    v303.Humanoid:ChangeState(v76.HumanoidStateType.Jumping)
                end
                if v128.Jump.Bypass then
                    local v1406 = v303.Root.AssemblyLinearVelocity
                    v303.Root.AssemblyLinearVelocity = v71(v1406.X, v128.Jump.Power, v1406.Z)
                end
                break
            end
        end
    end)
)
v132(
    "InputBegan",
    v64.InputBegan:Connect(function(v1048, v1049)
        local v1050 = 481 - (305 + 176)
        local v1051
        while true do
            if v1050 == 2 then
                if v1051 == v76.KeyCode.A then
                    v131.A = true
                end
                if v1051 ~= v76.KeyCode.D then
                else
                    v131.D = true
                end
                v1050 = 1 + 2
            end
            if v1050 == 3 then
                if v1051 == v76.KeyCode.Space then
                    v131.Space = true
                end
                if v1051 ~= v76.KeyCode.LeftShift then
                else
                    v131.Shift = true
                end
                v1050 = 4
            end
            if v1050 == 0 then
                if v1049 then
                    return
                end
                v1051 = v1048.KeyCode
                v1050 = 1 + 0
            end
            if v1050 == (6 - 2) then
                if v1051 ~= v76.KeyCode.Insert then
                else
                    v332()
                end
                break
            end
            if v1050 == 1 then
                if v1051 ~= v76.KeyCode.W then
                else
                    v131.W = true
                end
                if v1051 ~= v76.KeyCode.S then
                else
                    v131.S = true
                end
                v1050 = 2 + 0
            end
        end
    end)
)
v132(
    "InputEnded",
    v64.InputEnded:Connect(function(v1052, v1053)
        local v1054 = 0
        local v1055
        while true do
            if (0 - 0) == v1054 then
                if v1053 then
                    return
                end
                v1055 = v1052.KeyCode
                v1054 = 1
            end
            if v1054 == 3 then
                if v1055 ~= v76.KeyCode.Space then
                else
                    v131.Space = false
                end
                if v1055 ~= v76.KeyCode.LeftShift then
                else
                    v131.Shift = false
                end
                break
            end
            if v1054 == 2 then
                if v1055 ~= v76.KeyCode.A then
                else
                    v131.A = false
                end
                if v1055 ~= v76.KeyCode.D then
                else
                    v131.D = false
                end
                v1054 = 6 - 3
            end
            if (1 - 0) == v1054 then
                if v1055 ~= v76.KeyCode.W then
                else
                    v131.W = false
                end
                if v1055 ~= v76.KeyCode.S then
                else
                    v131.S = false
                end
                v1054 = 262 - (159 + 101)
            end
        end
    end)
)
local v333, v334, v335, v336
v235.InputBegan:Connect(function(v1056)
    if (v1056.UserInputType == v76.UserInputType.MouseButton1) or (v1056.UserInputType == v76.UserInputType.Touch) then
        v333 = true
        v335 = v1056.Position
        v336 = v143.Position
        v1056.Changed:Connect(function()
            if v1056.UserInputState == v76.UserInputState.End then
                v333 = false
            end
        end)
    end
end)
v235.InputChanged:Connect(function(v1057)
    if (v1057.UserInputType == v76.UserInputType.MouseMovement) or (v1057.UserInputType == v76.UserInputType.Touch) then
        v334 = v1057
    end
end)
v64.InputChanged:Connect(function(v1058)
    if (v1058 == v334) and v333 then
        local v1227 = 0 - 0
        local v1228
        while true do
            if v1227 == (0 - 0) then
                v1228 = v1058.Position - v335
                v143.Position = v73(v336.X.Scale, v336.X.Offset + v1228.X, v336.Y.Scale, v336.Y.Offset + v1228.Y)
                break
            end
        end
    end
end)
v264.MouseButton1Click:Connect(v332)
v275.MouseButton1Click:Connect(function()
    v115("JUST TEAM", "Script unloaded", 2 + 1)
    task.wait(0.3 - 0)
    pcall(function()
        getgenv().JTH_Unload()
    end)
end)
local v337 = v292["Movement"]
v299(v337, "Speed")
v300(v337, "Speed Boost", false, function(v1059)
    local v1060 = 0 - 0
    while true do
        if (0 + 0) == v1060 then
            v128.Speed.Enabled = v1059
            v115("Movement", (v1059 and "Speed Boost: ON") or "Speed Boost: OFF", 268 - (112 + 154))
            break
        end
    end
end)
v301(v337, "Speed Multiplier", 36 - 20, 331 - (21 + 10), v128.Speed.Value, function(v1061)
    v128.Speed.Value = v1061
end)
v299(v337, "Jump")
v300(v337, "Infinite Jump", false, function(v1063)
    local v1064 = 0
    while true do
        if v1064 == (1719 - (531 + 1188)) then
            v128.Jump.Infinite = v1063
            v115("Movement", (v1063 and "Infinite Jump: ON") or "Infinite Jump: OFF", 2 + 0)
            break
        end
    end
end)
v300(v337, "Jump Power Bypass", false, function(v1065)
    v128.Jump.Bypass = v1065
end)
v301(v337, "Jump Power", 50, 1163 - (96 + 567), v128.Jump.Power, function(v1067)
    v128.Jump.Power = v1067
end)
v299(v337, "Fly")
v300(v337, "Fly", false, function(v1069)
    local v1070 = 0
    while true do
        if v1070 == (0 - 0) then
            v128.Fly.Enabled = v1069
            v115("Movement", (v1069 and "Fly: ON") or "Fly: OFF", 1 + 1)
            break
        end
    end
end)
v301(v337, "Fly Speed", 30, 1797 - 1297, v128.Fly.Speed, function(v1071)
    v128.Fly.Speed = v1071
end)
v301(v337, "Vertical Speed", 1705 - (867 + 828), 656 - 356, v128.Fly.Vertical, function(v1073)
    v128.Fly.Vertical = v1073
end)
v299(v337, "Collision")
v300(v337, "Noclip", false, function(v1075)
    local v1076 = 0 - 0
    local v1077
    while true do
        if v1076 == 0 then
            v1077 = 0
            while true do
                if v1077 == (0 - 0) then
                    v128.Noclip.Enabled = v1075
                    v115("Movement", (v1075 and "Noclip: ON") or "Noclip: OFF", 2 - 0)
                    break
                end
            end
            break
        end
    end
end)
local v338 = v292["Visuals"]
v299(v338, "ESP")
v300(v338, "ESP", false, function(v1078)
    local v1079 = 0
    while true do
        if v1079 == (0 + 0) then
            v128.ESP.Enabled = v1078
            for v1371, v1372 in ipairs(v62:GetPlayers()) do
                if v1372 == v68 then
                elseif v1078 then
                    v322(v1372)
                else
                    v323(v1372)
                end
            end
            break
        end
    end
end)
v300(v338, "Box", true, function(v1080)
    v128.ESP.Box = v1080
end)
v300(v338, "Health Bar", true, function(v1082)
    v128.ESP.Health = v1082
end)
v300(v338, "Tracer", true, function(v1084)
    v128.ESP.Tracer = v1084
end)
v300(v338, "Player Name", true, function(v1086)
    v128.ESP.Name = v1086
end)
v300(v338, "Distance", true, function(v1088)
    v128.ESP.Distance = v1088
end)
v301(v338, "Text Size", 17 - 7, 24, v128.ESP.TextSize, function(v1090)
    v128.ESP.TextSize = v1090
end)
local v339 = v292["Combat"]
v299(v339, "Hitbox")
v300(v339, "Expand Hitboxes", false, function(v1092)
    v128.Hitbox.Enabled = v1092
    v115("Combat", (v1092 and "Hitbox: ON") or "Hitbox: OFF", 773 - (134 + 637))
    for v1196, v1197 in ipairs(v62:GetPlayers()) do
        if v1197 == v68 then
        elseif v1092 then
            v309(v1197)
        else
            v308(v1197)
        end
    end
end)
v301(v339, "Hitbox Size", 2, 4 + 16, v128.Hitbox.Size, function(v1094)
    local v1095 = 1157 - (775 + 382)
    local v1096
    while true do
        if v1095 == (0 - 0) then
            v1096 = 607 - (45 + 562)
            while true do
                if v1096 == (862 - (545 + 317)) then
                    v128.Hitbox.Size = v1094
                    if v128.Hitbox.Enabled then
                        for v1550, v1551 in ipairs(v62:GetPlayers()) do
                            if v1551 == v68 then
                            else
                                v309(v1551)
                            end
                        end
                    end
                    break
                end
            end
            break
        end
    end
end)
local v340 = v292["World"]
v299(v340, "Lighting")
v300(v340, "Full Bright", false, function(v1097)
    local v1098 = 0 - 0
    while true do
        if v1098 == 0 then
            v128.FullBright.Enabled = v1097
            if v1097 then
                local v1421 = 0
                while true do
                    if v1421 == (1026 - (763 + 263)) then
                        v324 = {
                            ["Ambient"] = v67.Ambient,
                            ["OutdoorAmbient"] = v67.OutdoorAmbient,
                            ["Brightness"] = v67.Brightness,
                            ["ClockTime"] = v67.ClockTime,
                            ["GlobalShadows"] = v67.GlobalShadows,
                        }
                        v326()
                        break
                    end
                end
            elseif v324 then
                pcall(function()
                    local v1531 = 0 + 0
                    local v1532
                    while true do
                        if v1531 == (1750 - (512 + 1238)) then
                            v1532 = 0
                            while true do
                                if v1532 == (1594 - (272 + 1322)) then
                                    v67.Ambient = v324.Ambient
                                    v67.OutdoorAmbient = v324.OutdoorAmbient
                                    v1532 = 1 - 0
                                end
                                if v1532 == (1248 - (533 + 713)) then
                                    v67.GlobalShadows = v324.GlobalShadows
                                    break
                                end
                                if v1532 == (29 - (14 + 14)) then
                                    v67.Brightness = v324.Brightness
                                    v67.ClockTime = v324.ClockTime
                                    v1532 = 827 - (499 + 326)
                                end
                            end
                            break
                        end
                    end
                end)
            end
            break
        end
    end
end)
v300(v340, "No Fog", false, function(v1099)
    v128.NoFog.Enabled = v1099
    if v1099 then
        local v1229 = 0 - 0
        while true do
            if v1229 == (424 - (104 + 320)) then
                v325 = { ["FogEnd"] = v67.FogEnd, ["FogStart"] = v67.FogStart }
                v327()
                break
            end
        end
    elseif v325 then
        pcall(function()
            local v1422 = 1997 - (1929 + 68)
            while true do
                if (1323 - (1206 + 117)) == v1422 then
                    v67.FogEnd = v325.FogEnd
                    v67.FogStart = v325.FogStart
                    break
                end
            end
        end)
    end
end)
v299(v340, "Performance")
v300(v340, "Unlock FPS", false, function(v1101)
    local v1102 = 0 + 0
    local v1103
    local v1104
    while true do
        if v1102 == (1592 - (683 + 909)) then
            v128.FPS.Enabled = v1101
            v1103 = (v1101 and v128.FPS.Value) or 60
            v1102 = 1
        end
        if v1102 == 1 then
            v1104 = v328(v1103)
            if not v1104 then
                v115("Performance", "FPS cap is not supported on this executor", 12 - 8, v89)
            end
            break
        end
    end
end)
v301(v340, "Target FPS", 55 - 25, 360, v128.FPS.Value, function(v1105)
    v128.FPS.Value = v1105
    if v128.FPS.Enabled then
        v328(v1105)
    end
end)
local v341 = v292["Settings"]
v299(v341, "Controls")
local v342 = Instance.new("TextLabel")
v342.Size = v73(1, 777 - (772 + 5), 1427 - (19 + 1408), 384 - (134 + 154))
v342.BackgroundColor3 = v81
v342.Text =
    "  Insert - minimize or expand the window\n  WASD - move while flying\n  Space / Left Shift - up / down while flying\n  Full Bright and No Fog reapply on Lighting changes"
v342.TextColor3 = v86
v342.Font = v76.Font.Gotham
v342.TextSize = 17 - 6
v342.TextXAlignment = v76.TextXAlignment.Left
v342.TextYAlignment = v76.TextYAlignment.Top
v342.TextWrapped = true
v342.Parent = v341
Instance.new("UICorner", v342).CornerRadius = v74(0, 6)
v297("Movement")
v137(43 - 29)
getgenv().JTH_Unload = function()
    for v1198, v1199 in pairs(v129) do
        pcall(function()
            v1199:Disconnect()
        end)
    end
    v129 = {}
    for v1200, v1201 in pairs(v128.ESP.Cache) do
        pcall(v1201.Destroy, v1201)
    end
    v128.ESP.Cache = {}
    for v1202, v1203 in ipairs(v130) do
        pcall(function()
            v1203:Remove()
        end)
    end
    v130 = {}
    for v1204, v1205 in ipairs(v128.Noclip.Watchers) do
        pcall(function()
            v1205:Disconnect()
        end)
    end
    v128.Noclip.Watchers = {}
    for v1206 in pairs(v128.Hitbox.Cache) do
        pcall(v308, v1206)
    end
    pcall(function()
        v134:Destroy()
    end)
    pcall(function()
        v138:Destroy()
    end)
    pcall(function()
        v98:Destroy()
    end)
    if v324 then
        pcall(function()
            local v1307 = 0
            while true do
                if (1 + 1) == v1307 then
                    v67.GlobalShadows = v324.GlobalShadows
                    break
                end
                if v1307 == 1 then
                    v67.Brightness = v324.Brightness
                    v67.ClockTime = v324.ClockTime
                    v1307 = 2
                end
                if v1307 == (0 + 0) then
                    v67.Ambient = v324.Ambient
                    v67.OutdoorAmbient = v324.OutdoorAmbient
                    v1307 = 203 - (10 + 192)
                end
            end
        end)
    end
    if v325 then
        pcall(function()
            local v1308 = 47 - (13 + 34)
            local v1309
            while true do
                if v1308 == 0 then
                    v1309 = 1289 - (342 + 947)
                    while true do
                        if v1309 == (0 - 0) then
                            v67.FogEnd = v325.FogEnd
                            v67.FogStart = v325.FogStart
                            break
                        end
                    end
                    break
                end
            end
        end)
    end
    pcall(v328, 1768 - (119 + 1589))
    getgenv().JTH_Loaded = nil
end
task.wait(0.15 - 0)
v115("JUST TEAM HUB", "Premium edition loaded", 3 - 0)
if not v94 then
    local v1207 = 552 - (545 + 7)
    while true do
        if v1207 == (0 - 0) then
            task.wait(0.2)
            v115("Warning", "HTTP request function was not found in this executor", 3 + 2, v89)
            break
        end
    end
end
return getgenv().JTH_Unload
