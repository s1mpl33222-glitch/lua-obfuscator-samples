-- This file was generated at discord.gg/syncrypt

local v640, v654, v660, v661
local v664, v665, v667, v668, v674, v675, v676, v677, v678, v681, v682, v683, v684, v685, v686, v687
local v688, v689, v690, v691, v692, v695, v696, v697, v698, v699, v700, v701, v702, v703, v704, v706
local v707, v708, v709, v710, v711
local v712, v714, v715, v716, v717, v718, v719, v720, v721, v722, v723, v724, v725, v726, v727, v728
local v729, v730, v731, v732, v733, v734, v735
local v736, v737, v738, v739, v741, v743, v745, v747, v749, v750, v751, v753, v755, v757, v759
local v761, v763
local v639 = "RoChess"
local v642 = "v1.1"
local up28 = "https://www.youtube.com/@RansbloxScript"
local up29 = "https://ransblox.net"
local v643 = "https://ransblox.net/lua/RoChess.lua"
local v647 = _G
if v647["ROCHESS_Unload"] then
    pcall(_G.ROCHESS_Unload)
end
local v649 = function()
    local v331 = loadstring(game:HttpGet("https://raw.githubusercontent.com/YTRANSBLOX/RANSBLOX-SCRIPT/refs/heads/main/maingui.lua"))

    return v331()
end
v674, v675 = pcall(v649)
local up30 = v675
local v651 = (not v674) or (not up30)
if v651 then
    return
else
    local up31 = {}
    v651 = function(arg27_1, arg27_2)
        local v279 = arg27_1:Connect(arg27_2)
        local v280 = table
        local v282 = v279
        v280.insert(up31, v282)

        return v282
    end
    local up32 = true
    v654 = game:GetService("ReplicatedStorage")
    v660 = game:GetService("HttpService")
    local up33 = v660
    v661, v660 = 10, v654.WaitForChild
    v660 = v660(v654, "Chess", v661)
    local up34 = v660
    v660 = v654:WaitForChild("ChessClient", 10)
    local up35 = v660
    v660 = (not up34) or (not up35)
    if v660 then
        up30:Notify({["Title"] = v639, ["Content"] = "RoChess not found. This script only works in RoChess!", ["Icon"] = "x", ["Duration"] = 5})

        return
    else
        v665 = function()
            local v361 = require
            local v362 = up35
            local v366 = "App"
            return v361(v362:WaitForChild(v366, 10))
        end
        v681, v682 = pcall(v665)
        v668 = (not v681)
        local up36 = v682
        v664 = v668
        if not (v668) then
            v664 = ((type(up36)) ~= "table")
        end
        if v664 then
            up30:Notify({["Title"] = v639, ["Content"] = "Client module not found.", ["Icon"] = "x", ["Duration"] = 5})

            return
        else
            v685, v686 = pcall(function()
                local v380 = require
                local v381 = up34
                local v385 = "VortexBot"
                return v380(v381:WaitForChild(v385, 10))
            end)
            local up37 = v686
            if (not v685) then
                up37 = nil
            end
            v677 = function()
                local v633 = require
                local v634 = up34
                local v638 = "Engine"
                return v633(v634:WaitForChild(v638, 10))
            end
            v667 = pcall
            v678 = {v667(v677)}
            v676 = v678[2]
            local up38 = v676
            if (not v678[1]) then
                up38 = nil
            end
            v687, v684 = 33401477053633, 18533191344566
            v688, v689 = "\210D\n\192\250\171.H", 9968251441697
            v690, v691, v683 = 27088934891846, 12401025635982, "S[\178\157\189!6\140\253]\182\239\158\212N\127\027:\205\170\196\237}m\014"
            local up39 = "Game Bot - Vortex (local)"
            v677 = "Stockfish - stockfish.online (cloud)"
            v696, v690 = "\175\000>\183X(", true
            v695, v698 = true, 32335369419473
            v683 = {["autoPlay"] = v690, ["autoQueue"] = v695, ["engine"] = "Stockfish - stockfish.online (cloud)", ["fallback"] = true, ["depth"] = 15, ["think"] = 2, ["moveDelay"] = .3, ["rating"] = 2800, ["queueDelay"] = 2}
            v696, v691 = 31322275133689, "\018'\001\145\197"
            local up40 = v683
            v698, v697 = 12275578852948, 2257827628059
            v689, v692 = "\n\161\153[\142", 23335222979186
            v697, v683 = 23493441252027, {["moves"] = 0, ["games"] = 0, ["lastMove"] = "-", ["lastEngine"] = "-", ["state"] = "Idle"}
            local up41 = v683
            v683 = function()
                return
            end
            local up42 = v683
            v695 = function()
                local v390 = (string.format("State: %s\nLast move: %s (%s)\nMoves sent: %d  |  Games: %d", up41.state, up41.lastMove, up41.lastEngine, up41.moves, up41.games))
                pcall(up42, v390)

                return
            end
            v701, v698 = 1382054216323, "\235"
            local up43 = v695
            v687, v691 = "\152", 3
            v695 = {["n"] = 2, ["b"] = v691, ["r"] = 4, ["q"] = 5}
            v692 = function(arg46_1)
                local v399 = arg46_1
                local v405 = ((type(v399)) == "string")
                local v406 = v405
                if v405 then
                    v406 = ((v399:match("^[a-h][1-8][a-h][1-8][qrbn]?$")) ~= nil)
                end
                return v406
            end
            local up44 = v695
            local up45 = function(arg47_1)
                local v408, v409
                local v407 = up38
                v408, v409 = v407, arg47_1
                if v407 then
                    v408 = up38.algToIndex64
                end
                if v408 then
                    v408, v407 = pcall(up38.algToIndex64 , v409)
                    v408 = (v408 and v407)
                    if v408 then
                        return v407
                    end
                end
                return (((((tonumber(v409:sub(2, 2))) - 1) * 8) + ((v409:byte(1)) - 97)) + 1)
            end
            v700 = function(arg48_1)
                local v421, v422, v423, v424
                local v418 = arg48_1
                local v420 = type(v418)
                if (v420 ~= "string") then
                    v424 = nil
                    return v424
                else
                    v424 = pcall
                    v421 = up33.JSONDecode
                    v422 = up33
                    v423 = {v424(v421, v422, v418)}
                    v420 = v423[2]
                    if v423[1] then
                        return v420
                    else
                        v424 = nil
                        return v424
                    end
                end
            end
            v696 = function(arg49_1)
                local v431, v432, v433, v434, v435, v437, v438, v444
                local v428 = arg49_1
                local v429 = syn
                local v430 = v429
                if v429 then
                    v430 = syn.request
                end
                local v436 = v430
                if not (v430) then
                    v437 = 14438251
                    v435 = http
                    v429 = v435
                    if v435 then
                        v429 = http.request
                    end
                    v430 = v429
                    if not (v429) then
                        v435 = http_request
                        v431 = 14438251
                        v429 = v435
                        if not (v435) then
                            v433 = request
                            v435, v432 = v433, 14438251
                            if not (v433) then
                                v438 = fluxus
                                v434, v433 = 14438251, v438
                                if v438 then
                                    v433 = fluxus.request
                                end
                                v444, v435 = v434, v433
                            end
                            v429, v444 = v435, v432
                        end
                        v430, v444 = v429, v431
                    end
                    v436, v444 = v430, v437
                end
                v430 = v436
                if (not v430) then
                    v444 = nil
                    return v444
                else
                    v444 = pcall
                    v436, v437 = v444(v430, v428)
                    v429 = v436
                    v436 = v429
                    if v429 then
                        v432 = ((type(v437)) == "table")
                        v431 = v432
                        if v432 then
                            v433 = v444
                            v432 = (v437.StatusCode == nil) or (v437.StatusCode == 200)
                            v444, v431 = v433, v432
                        end
                        v436 = v431
                    end
                    if v436 then
                        v444 = v437.Body
                        return v444
                    else
                        v444 = nil
                        return v444
                    end
                end
            end
            v698 = function(arg50_1)
                local v446, v447
                local v445 = arg50_1.engine
                local v448 = v445 and v445.getFen
                if v448 then
                    v448, v446 = pcall(v445.getFen , v445)
                    v447 = v448
                    v448 = v447
                    if v447 then
                        v448 = ((type(v446)) == "string")
                    end
                    if v448 then
                        return v446
                    end
                end
                return nil
            end
            v691 = function(arg51_1)
                local v459, v460, v463, v465, v466, v470, v471
                local v456 = up36
                local v457 = arg51_1
                local v462 = v456.session
                local v461 = v462
                local v458 = (not v461)
                v456 = v458
                if not (v458) then
                    v459 = v462
                    v460 = v461.over
                    v458 = v460
                    if not (v460) then
                        v458 = (v461.kind ~= "online") or (not (v461:isMyTurn()))
                    end
                    v462, v456 = v459, v458
                end
                if v456 then
                    v462 = false
                    return v462
                else
                    v456 = v461.viewPly
                    if (v456 ~= (#v461["ucis"])) then
                        v456 = (#v461.ucis)
                        v461.viewPly = v456
                    end
                    v456 = (#v457)
                    v458 = 0
                    if (v456 >= 5) then
                        v458 = (up44[(v457:sub(5, 5):lower())] or 0)
                    end
                    v459 = pcall
                    v463 = up36.onBoardMove
                    v470 = v457.sub
                    v465 = up45(v470(v457, 1, 2))
                    v471 = v457.sub
                    v460, v466 = v459(v463, v465, (up45(v471(v457, 3, 4))), v458, false)
                    v459 = v460 and (v466 == true)

                    return v459
                end
            end
            v703 = function(arg52_1)
                local v473, v474, v476, v477, v478, v479, v482, v483
                local v472 = arg52_1
                if (not up37) then
                    v473 = nil
                    return v473
                else
                    v478 = v472.startFen
                    v479 = v478
                    if not (v478) then
                        v477 = 4554475
                        v474 = v472.engine
                        v478 = v474
                        if v474 then
                            v478 = v472.engine.startFen
                        end
                        v479, v473 = v478, v477
                    end
                    v478 = v479
                    v473 = up37.think
                    v474 = table.clone(v472.ucis)
                    v476 = up40.rating
                    v482 = math.min(up40.depth, 20)
                    v483 = up40.think
                    v479 = v473(v478, v474, {["rating"] = v476, ["depth"] = v482, ["time"] = v483})

                    return v479
                end
            end
            local up47 = v692
            local up48 = v691
            local up49 = v696
            local up50 = v700
            v702 = function(arg53_1, arg53_2)
                local v490, v491, v492, v493, v494, v495, v496, v497
                local v489 = arg53_2
                if (not v489) then
                    v490 = nil
                    return v490
                else
                    v495 = (math.clamp(up40.depth, 1, 15))
                    v492 = ("https://stockfish.online/api/s/v2.php?fen=" .. ((up33:UrlEncode(v489)) .. ("&depth=" .. v495)))
                    v493 = (up50(up49({["Url"] = v492, ["Method"] = "GET"})))
                    v491 = v493
                    if v493 then
                        v497 = (v493.success ~= false)
                        v494 = v497
                        if v497 then
                            v494 = ((type(v493.bestmove)) == "string")
                        end
                        v491 = v494
                    end
                    if v491 then
                        v490 = v493.bestmove
                        v494 = "bestmove%s+(%S+)"
                        v496 = v490.match
                        return v496(v490, v494)
                    else
                        v490 = nil
                        return v490
                    end
                end
            end
            local up52 = v698
            local up46 = {}
            up46["Stockfish - stockfish.online (cloud)"] = v702
            v702 = function(arg54_1, arg54_2)
                local v506, v509, v510, v514, v515, v517, v523
                local v505 = arg54_2
                if (not v505) then
                    v506 = nil
                    return v506
                else
                    v506 = up33
                    v509 = math.clamp(up40.depth, 1, 18)
                    v517 = v506.JSONEncode
                    v514 = math.clamp((up40.think * 20), 10, 100)
                    v517 = v517(v506, {["fen"] = v505, ["depth"] = v509, ["variants"] = 1, ["maxThinkingTime"] = v514})
                    v506 = up50
                    v523 = v517
                    v510 = up49
                    v515 = {["Content-Type"] = "application/json"}
                    v510 = (v506(v510({["Url"] = "https://chess-api.com/v1", ["Method"] = "POST", ["Headers"] = v515, ["Body"] = v523})))
                    if v510 then
                        v517 = v510.lan or v510.move
                        return v517
                    else
                        v506 = nil
                        return v506
                    end
                end
            end
            up46["Stockfish - chess-api.com (cloud)"] = v702
            v702 = function(arg55_1, arg55_2)
                local v525, v526, v527, v528, v529, v530, v531, v533, v536
                local v524 = arg55_2
                if (not v524) then
                    v525 = nil
                    return v525
                else
                    v526 = ("https://lichess.org/api/cloud-eval?multiPv=1&fen=" .. (up33:UrlEncode(v524)))
                    v525 = up50
                    v527 = (v525(up49({["Url"] = v526, ["Method"] = "GET"})))
                    v529 = v527
                    if v527 then
                        v536 = v525
                        v533 = v527.pvs
                        v528 = v533
                        if v533 then
                            v530 = v525
                            v531 = v527.pvs[1]
                            v533 = v531
                            if v531 then
                                v533 = ((type(v527.pvs [1].moves)) == "string")
                            end
                            v525, v528 = v530, v533
                        end
                        v525, v529 = v536, v528
                    end
                    if v529 then
                        v525 = v527.pvs[1].moves
                        v528 = "^(%S+)"
                        v536 = v525.match
                        return v536(v525, v528)
                    else
                        v525 = nil
                        return v525
                    end
                end
            end
            up46["Lichess Cloud Eval (cloud)"] = v702
            up46[up39] = v703
            v702 = up39
            v698 = {v677, "Stockfish - chess-api.com (cloud)", "Lichess Cloud Eval (cloud)", v702}
            v701 = function(arg56_1, arg56_2)
                local v543, v544, v550, v552, v553, v554
                v543, v544 = arg56_1, arg56_2
                local v545 = up32
                local v546 = v545
                if v545 then
                    v553 = up40.autoPlay
                    v545 = v553
                    if v553 then
                        v552 = (up36.session == v543)
                        v553 = v552
                        if v552 then
                            v550 = (not v543.over)
                            v552 = v550
                            if v550 then
                                v554 = (v543.kind == "online")
                                v550 = v554
                                if v554 then
                                    v550 = ((#v543.ucis) == v544) and (v543:isMyTurn())
                                end
                                v552 = v550
                            end
                            v553 = v552
                        end
                        v545 = v553
                    end
                    v546 = v545
                end
                return v546
            end
            local up53 = false
            local up51 = 0
            local up54
            v704 = function()
                local v566, v567, v568, v570, v571, v572, v573, v575, v576, v577, v578, v579, v580, v582, v584
                local v564 = up53
                local v565 = v564
                if not (v564) then
                    v565 = ((os.clock ()) < up51)
                end
                if v565 then
                    return
                else
                    v572 = up36.session
                    v564 = v572
                    v571 = (not v564)
                    v565 = v571
                    if not (v571) then
                        v566 = v572
                        v570 = (v564.kind ~= "online")
                        v571 = v570
                        if not (v570) then
                            v567 = v572
                            v570 = v564.over or (not (v564:isMyTurn()))
                            v571, v572 = v570, v567
                        end
                        v572, v565 = v566, v571
                    end
                    if v565 then
                        v565 = v564
                        if v564 then
                            v565 = (v564.kind == "online") and (not v564.over)
                        end
                        if v565 then
                            v572 = up41
                            v572.state = "Waiting for opponent"
                        end
                        return
                    else
                        v572 = true
                        v571 = (#v564.ucis)
                        v565 = up41
                        v565.state = "Thinking..."
                        up43()
                        v566 = up40.engine
                        v566 = {v566}
                        v567 = up40.fallback
                        v565 = v567
                        if v567 then
                            v565 = (up40.engine ~= up39)
                        end
                        if v565 then
                            table.insert(v566, up39)
                        end
                        v570 = up52(v564)
                        v567, v568 = false, "ipairs"
                        for v573, v575 in ipairs(v566) do
                            v576 = up46[v575]
                            if v576 then
                                v577, v578 = pcall(v576, v564, v570)
                                v565 = v577
                                if v577 then
                                    v579 = up47
                                    v580 = v572
                                    v582 = (v579(v578)) and (up54(v564, v571))
                                    v572, v565 = v580, v582
                                end
                                if v565 then
                                    v582 = up40
                                    if (v582["moveDelay"] > 0) then
                                        task.wait(up40.moveDelay)
                                    end
                                    v565 = (up54(v564, v571)) and (up48(v578))
                                    if v565 then
                                        v565 = up41
                                        v580 = up41.moves
                                        v565.moves = (v580 + 1)
                                        v565 = up41
                                        v565.lastMove = v578
                                        v565 = up41
                                        v580 = v572
                                        v582 = ((v575:match("^(.-) %(")) or v575)
                                        v572 = v580
                                        v565.lastEngine = v582
                                        v565 = up41
                                        v565.state = "Move sent"
                                        v567 = true
                                        break
                                    end
                                end
                            end
                            v584 = up54(v564, v571)
                            if not ((not v584))then
                                continue
                            end
                            break
                        end
                        v568 = (not v567) and (up54(v564, v571))
                        if v568 then
                            v568 = up41
                            v568.state = "No move found, retrying"
                            v568 = ((os.clock()) + 2)
                        end
                        up43()
                        return
                    end
                end
            end
            up54 = v701
            local up55 = v704
            task.spawn(function()
                local v587, v591
                while true do
                    if not up32 then
                        break
                    end
                    task.wait(.3)
                    v587 = up40
                    if v587.autoPlay then
                        v587, v591 = pcall(up55)
                        if (not v587) then
                            v587 = ((os.clock()) + 2)
                            warn(("[RoChess] " .. (tostring(v591))))
                        end
                    end
                end
                return
            end)
            local up56
            local up57
            v699 = function()
                local v598, v599, v600, v601, v602, v603, v604, v605, v607, v608, v610
                if up57 then
                    return
                else
                    v603 = up36.session
                    v602 = v603
                    v598 = v602
                    if v602 then
                        v600 = v603
                        v599 = (v602.kind == "online") and v602.over
                        v598, v603 = v599, v600
                    end
                    if v598 then
                        v598 = v602.id and (v602.id ~= up56)
                        if v598 then
                            v603 = v602.id
                            v598 = up41
                            v600 = (up41.games + 1)
                            v598.games = v600
                        end
                        v599 = up41
                        v599.state = "Game over, re-queueing"
                        up43()
                        v599 = v602
                        task.wait(up40.queueDelay )
                        v608 = up32
                        v600 = v608
                        if v608 then
                            v605 = up40
                            v607 = v603
                            v604 = v605.autoQueue
                            v608 = v604
                            if v604 then
                                v610 = up36
                                v605 = v603
                                v604 = (v610.session == v599) and v599.over
                                v603, v608 = v605, v604
                            end
                            v600, v603 = v608, v607
                        end
                        if v600 then
                            pcall(up36.newGame)
                        end
                        task.wait(1.5)
                        up57 = false
                        return
                    else
                        v601, v608 = v603, (not v602)
                        v599 = v608
                        if not (v608) then
                            v599 = (v602.kind == "idle")
                        end
                        v603 = v601
                        v601 = v599
                        if v599 then
                            v604 = v603
                            v605 = (not up36.searching)
                            v607 = v605
                            if v605 then
                                v607 = (not up36.joining)
                            end
                            v601, v603 = v607, v604
                        end
                        if v601 then
                            v608 = up41
                            v608.state = "Searching for a game"
                            up43()
                            pcall(up36.startSearch, up36.selectedTc)
                            task.wait(3)
                            up57 = false
                        end
                        return
                    end
                end
            end
            up57 = false
            local up58 = v699
            task.spawn(function()
                local v615, v619
                while true do
                    if not up32 then
                        break
                    end
                    task.wait(1)
                    v615 = up40
                    if v615.autoQueue then
                        v615, v619 = pcall(up58)
                        if (not v615) then
                            warn(("[RoChess] " .. (tostring(v619))))
                        end
                    end
                end
                return
            end)
            v707 = queue_on_teleport
            v699 = v707
            if not (v707) then
                v708 = v640
                v711 = syn
                v709 = v711
                if v711 then
                    v709 = syn.queue_on_teleport
                end
                v707 = v709
                if not (v709) then
                    v710 = v640
                    v711 = fluxus
                    v709 = v711
                    if v711 then
                        v709 = fluxus.queue_on_teleport
                    end
                    v707, v640 = v709, v710
                end
                v699, v640 = v707, v708
            end
            if v699 then
                pcall(v699, ("loadstring(game:HttpGet(\"" .. (v643 .. "\"))()")))
            end
            v706 = function(...)
                local v169, v170, v181, v182, v183
                v169, v170 = {...}, "ipairs"
                for v173, v174 in ipairs(v169) do
                    v182, v183 = pcall(up30.Creator.Icon , v174)
                    v181 = (v182 and v183)
                    if v181 then
                        return v174
                    end
                end
                return "info"
            end
            local up59 = v706
            v706 = up30
            v716 = Color3.fromHex("#FF8200")
            v714 = Color3.fromHex("#0B0B0D")
            v719 = Color3.fromHex("#F5F5F5")
            v721 = Color3.fromHex("#27272A")
            v723 = Color3.fromHex("#FFB066")
            v725 = Color3.fromHex("#EA6F00")
            v727 = Color3.fromHex("#FF8200")
            v729 = Color3.fromHex("#1F1F23")
            v730 = up30
            v737 = Color3.fromHex("#1C1006")
            v734 = {["Color"] = v737, ["Transparency"] = 0}
            v739 = Color3
            v731 = v730.Gradient
            v739 = v739.fromHex("#0B0B0D")
            v731 = v731(v730, {["0"] = v734, ["100"] = {["Color"] = v739, ["Transparency"] = 0}}, {["Rotation"] = 135})
            v733 = Color3.fromHex("#000000")
            v735 = Color3.fromHex("#FFFFFF")
            v736 = Color3.fromHex
            v707 = v706.AddTheme
            v737 = v736("#FF9F40")
            v739 = Color3.fromHex("#FF8200")
            v741 = Color3.fromHex("#FF8200")
            v743 = Color3.fromHex("#18181B")
            v745 = Color3.fromHex("#F5F5F5")
            v747 = Color3.fromHex("#FF8200")
            v749 = Color3.fromHex("#161618")
            v751 = Color3.fromHex("#F5F5F5")
            v753 = Color3.fromHex("#A8A29E")
            v755 = Color3.fromHex("#FF8200")
            v757 = Color3.fromHex("#FF8200")
            v759 = Color3.fromHex("#2A2A2E")
            v761 = Color3.fromHex("#FF8200")
            v763 = Color3.fromHex("#FFFFFF")
            v707(v706, {["Name"] = "RansBlox", ["Accent"] = v716, ["Background"] = v714, ["BackgroundTransparency"] = .02, ["Text"] = v719, ["Outline"] = v721, ["Placeholder"] = v723, ["Button"] = v725, ["Icon"] = v727, ["Hover"] = v729, ["WindowBackground"] = v731, ["WindowShadow"] = v733, ["WindowTopbarTitle"] = v735, ["WindowTopbarAuthor"] = v737, ["WindowTopbarIcon"] = v739, ["WindowTopbarButtonIcon"] = v741, ["TabBackground"] = v743, ["TabTitle"] = v745, ["TabIcon"] = v747, ["ElementBackground"] = v749, ["ElementTitle"] = v751, ["ElementDesc"] = v753, ["ElementIcon"] = v755, ["Toggle"] = v757, ["ToggleBar"] = v759, ["Slider"] = v761, ["SliderThumb"] = v763})
            v706 = up30
            v717, v715 = 17540306067431, 6270119332711
            v721 = UDim2.fromOffset(560, 360)
            v728 = {["Enabled"] = true}
            v730 = {["Height"] = 44, ["ButtonsType"] = "Mac"}
            v707 = v706.CreateWindow
            v738 = UDim.new(1, 0)
            v750 = ColorSequence.new((Color3.fromHex("#FF9A1F")), Color3.fromHex("#FF6A00"))
            v734 = {["Title"] = v639, ["CornerRadius"] = v738, ["StrokeThickness"] = 3, ["Enabled"] = true, ["Draggable"] = true, ["OnlyMobile"] = false, ["Scale"] = 0.5, ["Color"] = v750}
            v736 = Enum.KeyCode.RightControl
            v707 = v707(v706, {["Title"] = v639, ["Author"] = "Ransblox Scripts", ["Icon"] = "youtube", ["Theme"] = "RansBlox", ["NewElements"] = true, ["Folder"] = v639, ["Size"] = v721, ["Radius"] = 20, ["ElementsRadius"] = 16, ["ShadowTransparency"] = .6, ["User"] = v728, ["Topbar"] = v730, ["HideSearchBar"] = false, ["OpenButton"] = v734, ["ToggleKey"] = v736})
            local up60 = v707
            v707 = up60
            v714 = Color3.fromHex("#FF8200")
            v707:Tag({["Title"] = v642, ["Icon"] = "youtube", ["Color"] = v714, ["Border"] = true})
            v707 = up60
            v717, v715 = 11900865009061, 22470645131487
            v708, v715 = "Tag", "\188\"+\179"
            v708 = v707.Tag
            v715 = Color3.fromHex("#3B82F6")
            v708(v707, {["Title"] = "PATCHED", ["Icon"] = "wrench", ["Color"] = v715, ["Border"] = true})
            v707 = up60
            v708 = v707.Tag
            v715 = Color3.fromHex("#22C55E")
            v708(v707, {["Title"] = "FREE", ["Icon"] = "badge-check", ["Color"] = v715, ["Border"] = true})
            v717, v707 = 7419783105919, {}
            v709 = up60
            v715 = up59("house", "home")
            v717 = Color3
            v710 = v709.Tab
            v717 = v717.fromHex("#FF8200")
            v710 = v710(v709, {["Title"] = "Home", ["Icon"] = v715, ["IconColor"] = v717, ["IconShape"] = "Circle"})
            v707.Home = v710
            v709 = up60
            v715 = up59("crown", "house")
            v717 = Color3.fromHex("#FF8200")
            v711, v710 = {["Title"] = "Main", ["Icon"] = v715, ["IconColor"] = v717, ["IconShape"] = "Circle"}, v709.Tab
            v710 = v710(v709, v711)
            v707.Auto = v710
            v709 = up60
            v715 = up59("cpu", "info")
            v717 = Color3.fromHex("#FF8200")
            v710, v711 = v709.Tab, {["Title"] = "Engine", ["Icon"] = v715, ["IconColor"] = v717, ["IconShape"] = "Circle"}
            v710 = v710(v709, v711)
            v707.Eng = v710
            v709 = up60
            v715 = up59("info")
            v717 = Color3.fromHex("#FF8200")
            v710 = v709:Tab({["Title"] = "Misc", ["Icon"] = v715, ["IconColor"] = v717, ["IconShape"] = "Circle"})
            v707.Misc = v710
            v712 = function(arg16_1, arg16_2)
                local up4 = arg16_2
                pcall(function()
                    setclipboard(up4)
                    return
                end)
                up30:Notify({["Title"] = arg16_1, ["Content"] = "Link copied to clipboard!", ["Icon"] = "check", ["Duration"] = 2})

                return
            end
            v708 = function(arg17_1, arg17_2, arg17_3)
                local v199 = up59(arg17_3)
                local v208 = {["Title"] = arg17_2, ["Icon"] = v199, ["Box"] = true, ["BoxBorder"] = true, ["Opened"] = false}
                return arg17_1:Section(v208)
            end
            v709 = function(arg18_1, arg18_2, arg18_3)
                local v211 = up59(arg18_3)
                local v220 = {["Title"] = arg18_2, ["Icon"] = v211, ["Box"] = true, ["BoxBorder"] = true, ["Opened"] = true}
                return arg18_1:Section(v220)
            end
            local up61 = function(arg19_1)
                local v222, v230
                local v221 = arg19_1
                local v223 = type(v221)
                if (v223 == "table") then
                    v223 = v221.Title
                    v222 = v223
                    if not (v223) then
                        v223 = v221.Name or v221[1]
                        v230, v222 = 13090974, v223
                    end
                    v221 = v222
                end
                return tostring(v221)
            end
            local up62 = v712
            v712 = v709(v707.Home, "Patched - v1.1 (latest)", "wrench")
            v712:Paragraph({["Title"] = "This build is up to date", ["Desc"] = "RoChess v1.1 is patched for the latest game update. If you are on v1.0 and moves stopped being played, update to this version."})
            v712:Paragraph({["Title"] = "Why v1.0 stopped working", ["Desc"] = "A recent game update changed how the client submits moves. Each move is now packed into a session-keyed payload and sent through a remote whose name rotates every build. The old plain move message is no longer accepted server-side, so v1.0 kept calculating moves but none of them landed."})
            v712:Paragraph({["Title"] = "What changed in v1.1", ["Desc"] = "Moves now go through the client's own move handler, so the game builds the payload itself and the script no longer depends on remote names or the message format. Also fixed: the start position is now read from the session engine (it is nil on the session object in this build). Added an engine selector with fallback, move delay, and queueing through the game's own flow."})
            v712:Paragraph({["Title"] = "Heads up", ["Desc"] = "The game can change this again at any time. Automated play is used at your own risk."})
            v716 = v709(v707.Home, "100% Free Script", "shield-check")
            v716:Paragraph({["Title"] = "This script is free", ["Desc"] = "No key system, no payments, no subscription. It was never sold and it never will be."})
            v716:Paragraph({["Title"] = "Found a version with a key? It's a scam", ["Desc"] = "If someone is asking you for a key, money, or to complete tasks to use this script, you're looking at a fake copy. Don't pay, don't enter your info. Only trust the official links below."})
            v714 = v709(v707.Home, "Official Links", "link"):Group()
            v715 = v714.Button
            v727 = function()
                up62("YouTube", up28)

                return
            end
            v715(v714, {["Title"] = "YouTube", ["Desc"] = "Ransblox Scripts - subscribe for more scripts", ["Icon"] = "youtube", ["Color"] = "Red", ["Callback"] = v727})
            v715 = v714.Button
            v725 = function()
                up62("Website", up29)

                return
            end
            v715(v714, {["Title"] = "Website", ["Desc"] = "ransblox.net - script hub & request page", ["Icon"] = "globe", ["Callback"] = v725})
            v715 = v708(v707.Auto, "Auto Play", "crown")
            v726 = function(arg22_1)
                local v244, v245, v246
                up40.autoPlay = arg22_1
                local v243 = up41
                v245, v246 = v243, v243
                local v247 = arg22_1
                if arg22_1 then
                    v247 = "Running"
                end
                v244, v243 = v247, v245
                if not (v247) then
                    v244 = "Paused"
                end
                v246.state = v244
                up43()
                return
            end
            v718, v717 = v715.Toggle, {["Title"] = "Auto Play", ["Desc"] = "Plays your side of the board automatically.", ["Value"] = true, ["Callback"] = v726}
            v718(v715, v717)
            v726 = function(arg23_1)
                up40.autoQueue = arg23_1
                return
            end
            v717 = {["Title"] = "Auto Queue", ["Desc"] = "Starts the next game when the current one ends.", ["Value"] = true, ["Callback"] = v726}
            v715:Toggle(v717)
            local up63 = {}
            v720 = function()
                local v259 = require
                local v260 = up34
                local v264 = "Config"
                v260 = (v259(v260:WaitForChild(v264, 5)))
                local v258 = v260
                if v260 then
                    v258 = ((type(v260.TC_BY_ID)) == "table")
                end
                if v258 then
                    for v264 in pairs(v260.TC_BY_ID) do
                        table.insert(up63, tostring(v264))
                    end
                end
                return
            end
            pcall(v720)
            if ((#up63) == 0) then
                up63 = {"1+0", "3+0", "3+2", "5+0", "10+0"}
            end
            v725, v721 = "\158\169\185\234", "table"
            table.sort(up63)
            v721 = "Title"
            v727, v726 = 26716323754136, "\214T\205H\r\153\015\012\234pN\208"
            v722 = "Time Control"
            v727, v733 = "\023\2194\183", "\156S\223n#"
            v723 = "Flag"
            v724 = "RoChessTC"
            v725 = "Desc"
            v726 = "Time control used when queueing for a new game."
            v727 = "Values"
            v728 = up63
            v729 = "Value"
            v733, v731 = v640, v640
            v734 = up36.selectedTc
            v732 = v734
            if v734 then
                v732 = (tostring(up36.selectedTc))
            end
            v730, v640 = v732, v733
            if not (v732) then
                v730 = "3+2"
            end
            v732 = function(arg0_1)
                up36.selectedTc = up61(arg0_1)

                return
            end
            v715:Dropdown({[v721] = v722, [v723] = v724, [v725] = v726, [v727] = v728, [v729] = v730, ["Callback"] = v732})
            v728, v725 = 22715082795345, "\021t\250\177\206"
            v719 = v715.Slider
            v730 = {["Min"] = 0, ["Max"] = 10, ["Default"] = 2}
            v732 = function(arg1_1)
                up40.queueDelay = ((tonumber(arg1_1)) or 2)

                return
            end
            v719(v715, {["Title"] = "Queue Delay", ["Flag"] = "RoChessQueueDelay", ["Desc"] = "Seconds to wait after a game ends before queueing again.", ["Step"] = 0.5, ["Value"] = v730, ["Callback"] = v732})
            v719 = v715.Paragraph
            v720, v728 = {["Title"] = "Status", ["Desc"] = "State: Idle"}, 22435538872527
            v719 = v719(v715, v720)
            local up64 = v719
            up42 = function(arg2_1)
                local up1 = arg2_1
                local v78 = function()
                    up64:SetDesc(up1)
                    return
                end
                pcall(v78)

                return
            end
            v721 = v708(v707.Eng, "Engine", "cpu")
            v722 = v721.Dropdown
            v733 = function(arg3_1)
                local v82
                local v81 = (up61(arg3_1))
                if up46[v81] then
                    v82 = up40
                    v82.engine = v81
                end
                return
            end
            v722(v721, {["Title"] = "Engine", ["Flag"] = "RoChessEngine", ["Desc"] = "Evaluation backend. Entries marked (cloud) send the current position (FEN) to a third-party API. The local bot runs inside the game and sends nothing.", ["Values"] = v698, ["Value"] = v677, ["Callback"] = v733})
            v722 = v721.Toggle
            v731 = function(arg4_1)
                up40.fallback = arg4_1
                return
            end
            v722(v721, {["Title"] = "Fallback to Local Bot", ["Desc"] = "If a cloud engine fails or times out, use the local bot for that move.", ["Value"] = true, ["Callback"] = v731})
            v733 = {["Min"] = 1, ["Max"] = 20, ["Default"] = 15}
            v722 = v721.Slider
            v735 = function(arg5_1)
                up40.depth = math.floor(((tonumber(arg5_1)) or 15))

                return
            end
            v722(v721, {["Title"] = "Depth", ["Flag"] = "RoChessDepth", ["Desc"] = "Search depth. Cloud engines cap this on their side (stockfish.online: 15, chess-api.com: 18).", ["Step"] = 1, ["Value"] = v733, ["Callback"] = v735})
            v722 = v721.Slider
            v733 = {["Min"] = 1, ["Max"] = 5, ["Default"] = 2}
            v735 = function(arg6_1)
                up40.think = math.floor(((tonumber(arg6_1)) or 2))

                return
            end
            v722(v721, {["Title"] = "Think Time", ["Flag"] = "RoChessThink", ["Desc"] = "Time budget per move in seconds (local bot) and request budget (cloud).", ["Step"] = 1, ["Value"] = v733, ["Callback"] = v735})
            v733 = {["Min"] = 0, ["Max"] = 3, ["Default"] = .3}
            v722 = v721.Slider
            v735 = function(arg7_1)
                up40.moveDelay = ((tonumber(arg7_1)) or .3)

                return
            end
            v722(v721, {["Title"] = "Move Delay", ["Flag"] = "RoChessMoveDelay", ["Desc"] = "Seconds to wait before a move is submitted.", ["Step"] = .1, ["Value"] = v733, ["Callback"] = v735})
            v733 = {["Min"] = 800, ["Max"] = 2800, ["Default"] = 2800}
            v735 = function(arg8_1)
                up40.rating = math.floor(((tonumber(arg8_1)) or 2800))

                return
            end
            v723, v722 = {["Title"] = "Local Bot Rating", ["Flag"] = "RoChessRating", ["Desc"] = "Strength of the local bot (only used by the Game Bot engine).", ["Step"] = 100, ["Value"] = v733, ["Callback"] = v735}, v721.Slider
            v722(v721, v723)
            v722 = v708(v707.Misc, "Interface", "palette")
            v723 = v722.Toggle
            v732 = function(arg9_1)
                up60:ToggleTransparency(arg9_1)
                return
            end
            v723(v722, {["Title"] = "Glass Mode", ["Desc"] = "Makes the window slightly transparent", ["Value"] = false, ["Callback"] = v732})
            v723 = v722.Slider
            v732 = {["Min"] = .7, ["Max"] = 1.2, ["Default"] = 1}
            v734 = function(arg10_1)
                up60:SetUIScale(arg10_1)
                return
            end
            v723(v722, {["Title"] = "UI Scale", ["Desc"] = "Lower it if the GUI is too big on mobile", ["Step"] = .05, ["Value"] = v732, ["Callback"] = v734})
            v723 = v722.Keybind
            v732 = function(arg11_1)
                local v127, v130
                local up2 = arg11_1
                v127, v130 = pcall(function()
                    return Enum.KeyCode[up2]
                end)
                v127 = (v127 and v130)
                if v127 then
                    up60:Toggle()
                end
                return
            end
            v723(v722, {["Title"] = "Toggle GUI", ["Desc"] = "Key to show/hide the window", ["Value"] = "RightControl", ["Callback"] = v732})
            v723 = v708(v707.Misc, "Config", "save")
            v724 = v723:Paragraph({["Title"] = "Auto-save", ["Desc"] = "Dropdowns and sliders with a Flag are saved automatically whenever you change them, and loaded back next time you join."})
            local up65 = v724
            v724 = v723:Group()
            v726 = v724.Button
            v735 = function()
                local v132 = up60
                if v132["CurrentConfig"] then
                    v132 = pcall(function()
                        up60.CurrentConfig:Save()
                        return
                    end)
                    if v132 then
                        up30:Notify({["Title"] = "Config", ["Content"] = "Settings saved!", ["Icon"] = "check", ["Duration"] = 2})
                        pcall(function()
                            up65:SetDesc("Last saved just now.")
                            return
                        end)
                    else
                        up30:Notify({["Title"] = "Config", ["Content"] = "Couldn't save settings.", ["Icon"] = "x", ["Duration"] = 3})
                    end
                end
                return
            end
            v726(v724, {["Title"] = "Save Now", ["Desc"] = "Save your current settings", ["Icon"] = "save", ["Callback"] = v735})
            v726 = v724.Button
            v735 = function()
                local v150
                local v146 = up60
                if v146["CurrentConfig"] then
                    v150 = function()
                        up60.CurrentConfig:Load()
                        return
                    end
                    v146 = pcall(v150)
                    if v146 then
                        up30:Notify({["Title"] = "Config", ["Content"] = "Settings loaded!", ["Icon"] = "check", ["Duration"] = 2})
                    else
                        up30:Notify({["Title"] = "Config", ["Content"] = "No saved settings found.", ["Icon"] = "x", ["Duration"] = 3})
                    end
                end
                return
            end
            v726(v724, {["Title"] = "Load Saved", ["Desc"] = "Load your last saved settings", ["Icon"] = "upload", ["Callback"] = v735})
            v726 = function()
                local v161, v163, v164, v165, v166
                local v160 = _G
                if (v160["ROCHESS_Unloaded"] == up60) then
                    return
                else
                    v165 = _G
                    v165.ROCHESS_Unloaded = up60
                    v164 = up40
                    v164.autoPlay = false
                    v164 = up40
                    v164.autoQueue = false
                    for v161, v163 in ipairs(up31) do
                        local up3 = v163
                        pcall(function()
                            up3:Disconnect()
                            return
                        end)
                        v163 = nil
                    end
                    v166 = function()
                        up60:Destroy()
                        return
                    end
                    pcall(v166)
                    v164 = _G
                    v164.ROCHESS_Unload = nil
                    return
                end
            end
            v727 = _G
            v727.ROCHESS_Unload = v726
            v708(v707.Misc, "Script", "power"):Button({["Title"] = "Unload Script", ["Desc"] = "Removes the GUI and stops everything", ["Icon"] = "x", ["Callback"] = v726})
            v728 = v707.Misc
            v730, v729 = {["Title"] = v639, ["Desc"] = ("Made by Ransblox Scripts \226\128\162 " .. v642)}, v728.Paragraph
            v729(v728, v730)
            v730 = up60.Folder
            v728 = v730
            if v730 then
                v728 = up60.ConfigManager
            end
            if v728 then
                up60.ConfigManager:CreateConfig("default", true)
            end
            v728 = up41
            v728.state = "Running"
            up43()
            v728 = up30
            v729 = v728.Notify
            v732 = (v639 .. (" " .. v642))
            v729(v728, {["Title"] = v732, ["Content"] = "Patched for the latest game update.", ["Icon"] = "check", ["Duration"] = 4})

            return
        end
    end
end
