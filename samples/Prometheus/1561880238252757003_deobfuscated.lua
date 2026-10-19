-- This file was generated at discord.gg/syncrypt

local rochessUnload = {
	value3 = 22126428612671,
	value2 = "\192\19{i\246\24\186\250"
}
local t1 = {
	value1 = "https://www.youtube.com/@RansbloxScript",
	value2 = "https://ransblox.net",
	value3 = "https://raw.githubusercontent.com/YTRANSBLOX/RANSBLOX-SCRIPT/refs/heads/main/Rochess.lua"
}
if _G.ROCHESS_Unload then
    pcall(_G.ROCHESS_Unload)
end
local ok, value12 = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/YTRANSBLOX/RANSBLOX-SCRIPT/refs/heads/main/maingui.lua"))()
end)
rochessUnload.value11 = ok
rochessUnload.value12 = value12
ok = not rochessUnload.value11
t1.value4 = rochessUnload.value12
if ok or not t1.value4 then
    return
end
ok = {}
value12 = true
local function value45(p1, p2)
    local connection = p1:Connect(p2)
    local v7 = ok

    table.insert(v7, connection)

    return connection
end
rochessUnload.value4 = game:GetService("ReplicatedStorage")
rochessUnload.value5 = game:GetService("HttpService")
local value5 = rochessUnload.value5
rochessUnload.value5 = rochessUnload.value4:WaitForChild("Chess", 10)
local value52 = rochessUnload.value5
rochessUnload.value5 = rochessUnload.value4:WaitForChild("ChessClient", 10)
local value53 = rochessUnload.value5
rochessUnload.value8 = value52
local value8 = rochessUnload.value8
local value1 = rochessUnload.value1
rochessUnload.value6 = value8
rochessUnload.value7 = value1
if rochessUnload.value8 then
    rochessUnload.value6 = value53
end
value8 = not rochessUnload.value6
value1 = rochessUnload.value7
rochessUnload.value5 = value8
rochessUnload.value1 = value1
if rochessUnload.value5 then
    t1.value4:Notify({
		["Title"] = "Ro Chess",
		["Content"] = "Chess game not found. This script only works in Ro Chess.",
		["Icon"] = "x",
		["Duration"] = 5
	})

    return
end
function rochessUnload.value8()
    return require(value52:WaitForChild("VortexBot", 5))
end
value52, value8 = pcall(rochessUnload.value8)
rochessUnload.value6 = value52
rochessUnload.value7 = value8
value52 = rochessUnload.value7
if not rochessUnload.value6 then
    value52 = nil
end
function rochessUnload.value10()
    return require(value53:WaitForChild("App", 5))
end
value53, value8 = pcall(rochessUnload.value10)
rochessUnload.value18 = value53
rochessUnload.value19 = value8
rochessUnload.value13 = not rochessUnload.value18
value53 = rochessUnload.value19
rochessUnload.value9 = rochessUnload.value13 or not value53
if rochessUnload.value9 then
    t1.value4:Notify({
		["Title"] = "Ro Chess",
		["Content"] = "Couldn\'t load the chess client.",
		["Icon"] = "x",
		["Duration"] = 5
	})

    return
end
rochessUnload.value14 = rochessUnload.value1
rochessUnload.value15 = syn
rochessUnload.value13 = rochessUnload.value15
if rochessUnload.value15 then
    rochessUnload.value13 = syn.request
end
value8 = rochessUnload.value13
value1 = rochessUnload.value14
rochessUnload.value9 = value8
rochessUnload.value1 = value1
if not rochessUnload.value13 then
    rochessUnload.value14 = rochessUnload.value1
    rochessUnload.value15 = http_request
    rochessUnload.value13 = rochessUnload.value15

    if not rochessUnload.value15 then
        rochessUnload.value17 = request
        value8 = rochessUnload.value1
        value1 = rochessUnload.value17
        rochessUnload.value16 = value8
        rochessUnload.value15 = value1

        if not rochessUnload.value17 then
            rochessUnload.value21 = http
            rochessUnload.value17 = rochessUnload.value21

            if rochessUnload.value21 then
                rochessUnload.value17 = http.request
            end

            rochessUnload.value15 = rochessUnload.value17
        end

        value8 = rochessUnload.value15
        value1 = rochessUnload.value16
        rochessUnload.value13 = value8
        rochessUnload.value1 = value1
    end

    value8 = rochessUnload.value13
    value1 = rochessUnload.value14
    rochessUnload.value9 = value8
    rochessUnload.value1 = value1
end
value8 = rochessUnload.value9
if not value8 then
    t1.value4:Notify({
		["Title"] = "Ro Chess",
		["Content"] = "No HTTP support in this executor. Cloud engines are unavailable.",
		["Icon"] = "triangle-alert",
		["Duration"] = 6
	})
end
rochessUnload.value28 = 8383730569023
rochessUnload.value22 = 2454295594102
rochessUnload.value16 = "\188\2439\196M():\169\223\245p^\164$YK\22\217\16\179\242\197p\240w\229+\31\20\170\128\245E\227\220\233[\217\251\242\20\172@\220.T\193\16L\'RG\226\229\145"
rochessUnload.value17 = 28419280057265
rochessUnload.value24 = 18506816119209
rochessUnload.value23 = 33401477053633
rochessUnload.value29 = "$`LFe\fi"
rochessUnload.value22 = "\229\\\196\n\189\174\202\148^t\187\253z\2252)"
rochessUnload.value30 = 29939078395509
rochessUnload.value24 = "O\203f\243J\15\215x:"
rochessUnload.value23 = 6762923478093
rochessUnload.value9 = {
	"chess-api.com",
	"stockfish.online",
	"Lichess Cloud",
	"VortexBot"
}
rochessUnload.value22 = "\14\219\8\201l\5\193"
rochessUnload.value25 = 23335222979186
rochessUnload.value24 = "\n\161\135m"
value1 = rochessUnload.value9
rochessUnload.value23 = "Auto (best available)"
rochessUnload.value38 = "\138\131\170m0"
rochessUnload.value27 = true
rochessUnload.value9 = {
	["running"] = true,
	["mode"] = "Auto Play",
	["engine"] = rochessUnload.value23,
	["depth"] = 12,
	["thinkTime"] = 1.5,
	["humanize"] = true,
	["quickOpening"] = rochessUnload.value27,
	["vortexFallback"] = true,
	["vRating"] = 2800,
	["vDepth"] = 20,
	["vTime"] = 2,
	["autoQueue"] = true,
	["queueDelay"] = 2,
	["tcChoice"] = "Same as last",
	["autoExec"] = true,
	["style"] = "Balanced",
	["styleTol"] = 0.5
}
rochessUnload.value17 = -1
rochessUnload.value38 = 5552344730137
local value9 = rochessUnload.value9
rochessUnload.value32 = 32786031344547
rochessUnload.value39 = 7189173865747
rochessUnload.value9 = false
local value92 = rochessUnload.value9
local value17 = rochessUnload.value17
rochessUnload.value28 = 12456980485800
rochessUnload.value27 = "\149J\146\245\20\203\171\214"
local t2 = {
	["played"] = 0,
	["queued"] = 0,
	["lastMove"] = "-",
	["lastEngine"] = "-",
	["lastEval"] = "-"
}
function rochessUnload.value32(p3)
    local t3 = {}

    for i = 1, 8 do
        local _ = i
        local n1 = 0
        local s1 = ""

        for i2 = 1, 8 do
            local v23 = p3.board[i][i2]

            if v23 then
                if n1 > 0 then
                    s1 = s1 .. n1
                    n1 = 0
                end

                s1 = s1 .. v23
            else
                n1 = n1 + 1
            end
        end

        if n1 > 0 then
            s1 = s1 .. n1
        end

        t3[i] = s1
    end

    return table.concat(t3, "/") .. " " .. p3.turn .. " " .. p3.castle .. " " .. p3.ep .. " " .. p3.half .. " " .. p3.full
end
function rochessUnload.value33(p4)
    local v24 = string.split(p4, " ")
    local t4 = {}

    for i = 1, 8 do
        t4[i] = {}
    end

    local n2 = 1

    for match in string.gmatch(v24[1], "[^/]+") do
        local n3 = 1

        for match2 in string.gmatch(match, ".") do
            local v31 = tonumber(match2)

            if v31 then
                n3 = n3 + v31
            else
                t4[n2][n3] = match2
                n3 = n3 + 1
            end
        end

        n2 = n2 + 1
    end

    local v32 = v24[2] or "w"
    local v33 = v24[3] or "-"

    n2 = v24[4] or "-"

    local v34 = v24[5]

    v34 = tonumber(v34) or 0
    v24 = v24[6]

    return {
		["board"] = t4,
		["turn"] = v32,
		["castle"] = v33,
		["ep"] = n2,
		["half"] = v34,
		["full"] = tonumber(v24) or 1
	}
end
local s2 = "Running..."
function rochessUnload.value20()
end
function rochessUnload.value26(p5)
    local startFen = p5.startFen

    if startFen then
        return startFen
    end

    startFen = p5.engine

    if startFen then
        startFen = p5.engine.startFen
    end

    startFen = startFen or "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1"

    return startFen
end
local value20 = rochessUnload.value20
function rochessUnload.value34(p6)
    return 9 - tonumber(p6:sub(2, 2)), p6:byte(1) - 96
end
local value26 = rochessUnload.value26
local value33 = rochessUnload.value33
local value34 = rochessUnload.value34
function rochessUnload.value35(p7, p8)
    local v41, v42 = value34(p8:sub(1, 2))
    local v43, v44 = value34(p8:sub(3, 4))
    local v45 = p8:sub(5, 5)
    local board = p7.board
    local v47 = board[v41][v42]

    if not v47 then
        return
    end

    local v48 = board[v43][v44]
    local v49 = v47:lower()
    local upper = v47.upper

    v49 = v49 == "p"
    upper = v47 == upper(v47)

    if v49 then
        if v42 == v44 then
            v58 = false
        else
            v58 = not v48
        end
    else
        v58 = v49
    end

    if v58 then
        board[v41][v44] = nil
    end

    board[v43][v44] = v47

    local v51 = board[v41]

    v51[v42] = nil

    if v49 then
        local v52 = v45 ~= ""
    end

    if v59 then
        v51 = board[v43]

        if upper then
            upper = v45:upper()
        end

        v51[v44] = upper or v45:lower()
    end

    v45 = v47:lower() == "k"

    if v45 then
        v45 = v44 - v42
        v45 = math.abs(v45) == 2
    end

    if v45 then
        if v42 < v44 then
            board[v43][6] = board[v43][8]
            v51 = board[v43]
            v51[8] = nil
        else
            board[v43][4] = board[v43][1]
            v51 = board[v43]
            v51[1] = nil
        end
    end

    local castle = p7.castle == "-" and "" or false or p7.castle

    if v47 == "K" then
        for match in ("KQ"):gmatch(".") do
            castle = castle:gsub(match, "")
        end
    elseif v47 == "k" then
        for match in ("kq"):gmatch(".") do
            castle = castle:gsub(match, "")
        end
    end

    v45 = function(p9, p10)
        local v56 = p9 == 8

        if v56 then
            v56 = p10 == 8
        end

        if v56 then
            for match in ("K"):gmatch(".") do
                castle = castle:gsub(match, "")
            end

            return
        end

        if p9 == 8 then
            v56 = p10 == 1
        else
            v56 = false
        end

        if v56 then
            for match in ("Q"):gmatch(".") do
                castle = castle:gsub(match, "")
            end

            return
        end

        if p9 == 1 then
            v56 = p10 == 8
        else
            v56 = false
        end

        if v56 then
            for match in ("k"):gmatch(".") do
                castle = castle:gsub(match, "")
            end

            return
        end

        if p9 == 1 then
            v56 = p10 == 1
        else
            v56 = false
        end

        if not v56 then
            return
        end

        for match in ("q"):gmatch(".") do
            castle = castle:gsub(match, "")
        end
    end
    v45(v41, v42)
    v45(v43, v44)
    p7.castle = castle == "" and "-" or false or castle
    p7.ep = "-"

    if v49 then
        v44 = v43 - v41
        v44 = math.abs(v44) == 2
    else
        v44 = v49
    end

    if v44 then
        v42 = 96 + v42
        v42 = string.char(v42)
        v41 = 9 - (v41 + v43) / 2
        p7.ep = v42 .. tostring(v41)
    end

    if v49 or v48 then
        p7.half = 0
    else
        p7.half = p7.half + 1
    end

    if p7.turn ~= "b" then
        p7.turn = p7.turn == "w" and "b" or false or "w"

        return
    end

    p7.full = p7.full + 1
    p7.turn = p7.turn == "w" and "b" or false or "w"
end
local value35 = rochessUnload.value35
local value32 = rochessUnload.value32
value33 = function(p11)
    local fen = p11.fen

    if type(fen) == "string" then
        return value33(p11.fen), p11.fen
    else
        fen = value33(value26(p11))

        for _, uci in ipairs(p11.ucis) do
            value35(fen, uci)
        end

        return fen, value32(fen)
    end
end
rochessUnload.value27 = {
	["e1h1"] = "e1g1",
	["e1a1"] = "e1c1",
	["e8h8"] = "e8g8",
	["e8a8"] = "e8c8"
}
value32 = rochessUnload.value27
function rochessUnload.value36(p12, p13)
    local v66 = value32[p13]

    if not v66 then
        return p13
    end

    local v67, v68 = value34(p13:sub(1, 2))

    v67 = p12.board[v67][v68]

    if not v67 then
        if v67 then
            return v66
        else
            return p13
        end

        return
    end

    v67 = v67:lower() == "k"

    if v67 then
        return v66
    else
        return p13
    end
end
function rochessUnload.value37(p14)
    local ok2 = value8(p14)

    if not (ok2 and ok2.Body) then
        return nil
    end

    local StatusCode = ok2.StatusCode

    if StatusCode then
        StatusCode = ok2.StatusCode >= 400
    end

    if StatusCode then
        return nil
    end

    ok2, StatusCode = pcall(value5.JSONDecode, value5, ok2.Body)

    if not ok2 then
        if ok2 then
            return StatusCode
        else
            return
        end

        return
    end

    ok2 = type(StatusCode) == "table"

    if ok2 then
        return StatusCode
    else
        return
    end
end
value32 = rochessUnload.value36
function rochessUnload.value31(p15)
    local v71 = tonumber(p15)

    return not v71 and "?" or string.format("%+.2f", v71)
end
local value37 = rochessUnload.value37
local value31 = rochessUnload.value31
local value312 = {}
rochessUnload.value31 = value312
function rochessUnload.value29(p16)
    local v75 = value37
    local move = value5
    local depth = value9.depth

    v75 = v75({
		["Url"] = "https://chess-api.com/v1",
		["Method"] = "POST",
		["Headers"] = {
			["Content-Type"] = "application/json"
		},
		["Body"] = move:JSONEncode({
			["fen"] = p16,
			["depth"] = math.clamp(depth, 1, 18),
			["variants"] = 1
		})
	})

    if v75 then
        move = v75.move
        move = type(move) == "string"
    else
        move = v75
    end

    if not move then
        return
    end

    move = v75.move
    depth = v75.mate

    if not depth then
        return move, depth or value31(v75.eval)
    end

    depth = v75.mate
    depth = "mate " .. tostring(depth)

    return move, depth or value31(v75.eval)
end
rochessUnload.value31["chess-api.com"] = rochessUnload.value29
rochessUnload.value31 = value312
function rochessUnload.value29(p17)
    local v78 = value37
    local success = value5:UrlEncode(p17)
    local depth = value9.depth
    v78 = v78({
		["Url"] = "https://stockfish.online/api/s/v2.php?fen=" .. success .. "&depth=" .. math.clamp(depth, 1, 15),
		["Method"] = "GET"
	})
    if v78 then
        success = v78.success

        if success then
            success = v78.bestmove
            success = type(success) == "string"
        end
    else
        success = v78
    end
    if not success then
        return
    end
    success = v78.bestmove:match("bestmove (%S+)")
    depth = v78.mate
    if not depth then
        return success, depth or value31(v78.evaluation)
    end
    depth = v78.mate
    depth = "mate " .. tostring(depth)

    return success, depth or value31(v78.evaluation)
end
rochessUnload.value31["stockfish.online"] = rochessUnload.value29
rochessUnload.value31 = value312
function rochessUnload.value29(p18)
    local moves = value37({
		["Url"] = "https://lichess.org/api/cloud-eval?multiPv=1&fen=" .. value5:UrlEncode(p18),
		["Method"] = "GET"
	})
    local pvs

    if moves then
        pvs = moves.pvs

        if pvs then
            pvs = moves.pvs[1]
        end
    else
        pvs = moves
    end

    if pvs then
        moves = pvs.moves
        moves = type(moves) == "string"
    else
        moves = pvs
    end

    if not moves then
        return
    end

    moves = pvs.moves:match("^(%S+)")

    local mate = pvs.mate

    if not mate then
        return moves, mate or value31((pvs.cp or 0) / 100)
    end

    mate = pvs.mate
    mate = "mate " .. tostring(mate)

    return moves, mate or value31((pvs.cp or 0) / 100)
end
rochessUnload.value31["Lichess Cloud"] = rochessUnload.value29
rochessUnload.value31 = value312
function rochessUnload.value29(_, p19)
    if value52 and p19 then
        return value52.think(value26(p19), table.clone(p19.ucis), {
			["rating"] = value9.vRating,
			["depth"] = value9.vDepth,
			["time"] = value9.vTime
		}), "in-game"
    else
        return
    end
end
rochessUnload.value31.VortexBot = rochessUnload.value29
function rochessUnload.value28(p20, p21)
    local v85, ok2, v87, result
    if value9.engine == "Auto (best available)" then
        v85 = value1
    else
        local vortexFallback = value9

        v85 = { value9.engine }
        vortexFallback = vortexFallback.vortexFallback

        if vortexFallback then
            vortexFallback = value9.engine ~= "VortexBot"
        end

        if not vortexFallback then
            for _, v in ipairs(v85) do
                ok2 = value312[v]

                if ok2 then
                    v87 = v == "VortexBot" and true or value8
                else
                    v87 = ok2
                end

                if v87 then
                    ok2, v87, result = pcall(ok2, p20, p21)

                    if ok2 then
                        if type(v87) == "string" then
                            ok2 = #v87 >= 4
                        else
                            ok2 = false
                        end
                    end

                    if ok2 then
                        return v87, result, v
                    end
                end
            end

            return
        end

        table.insert(v85, "VortexBot")
    end
    for _, v in ipairs(v85) do
        ok2 = value312[v]

        if ok2 then
            v87 = v == "VortexBot" and true or value8
        else
            v87 = ok2
        end

        if v87 then
            ok2, v87, result = pcall(ok2, p20, p21)

            if ok2 then
                if type(v87) == "string" then
                    ok2 = #v87 >= 4
                else
                    ok2 = false
                end
            end

            if ok2 then
                return v87, result, v
            end
        end
    end
end
value52 = rochessUnload.value28
rochessUnload.value28 = {
	"Balanced",
	"Aggressive",
	"Defensive",
	"Simplify"
}
rochessUnload.value39 = 21431007291131
rochessUnload.value42 = "\21"
rochessUnload.value30 = "\235"
rochessUnload.value29 = {
	["p"] = 1,
	["n"] = 3,
	["b"] = 3,
	["r"] = 5,
	["q"] = 9,
	["k"] = 0
}
function rochessUnload.value40(p22)
    local t5 = {}

    for i = 1, 8 do
        t5[i] = table.clone(p22.board[i])
    end

    return {
		["board"] = t5,
		["turn"] = p22.turn,
		["castle"] = p22.castle,
		["ep"] = p22.ep,
		["half"] = p22.half,
		["full"] = p22.full
	}
end
value1 = rochessUnload.value29
function rochessUnload.value41(p23, p24, p25, p26)
    local function v96(p27, p28)
        local v97 = p23[p27]

        if not v97 then
            return v97
        end

        v97 = p23[p27][p28]

        return v97
    end

    local v98 = p26 and "P" or p26 or "p"

    if p26 then
        v132 = p24 + 1
    else
        v132 = p26
    end

    local v132_ = v132 or p24 - 1

    if v96(v132_, p25 - 1) == v98 and true or v96(v132_, p25 + 1) == v98 then
        return true
    end

    v98 = ipairs

    local v100, v101

    v132_, v100, v101 = v98({
		{ 1, 2 },
		{ 2, 1 },
		{ -1, 2 },
		{ -2, 1 },
		{ 1, -2 },
		{ 2, -1 },
		{ -1, -2 },
		{ -2, -1 }
	})

    local v102 = p26 and "N" or p26 or "n"
    local v103

    while true do
        v101, v103 = v132_(v100, v101)

        if not v101 then
            break
        end

        if v96(p24 + v103[1], p25 + v103[2]) == v102 then
            return true
        end
    end

    v102 = p26 and "K" or "k"

    local v104

    for i = -1, 1 do
        v104 = i

        for i2 = -1, 1 do
            local v107

            if v104 == 0 then
                if i2 == 0 then
                    v107 = false
                else
                    v107 = v96(p24 + v104, p25 + i2) == v102
                end
            else
                v107 = true
            end

            if v107 then
                return true
            end
        end
    end

    v132_ = p26 and "B" or p26 or "b"
    v100 = p26 and "R" or "r"
    v101 = p26 and "Q" or p26 or "q"

    for _, v in ipairs({
		{ 1, 0 },
		{ -1, 0 },
		{ 0, 1 },
		{ 0, -1 },
		{ 1, 1 },
		{ 1, -1 },
		{ -1, 1 },
		{ -1, -1 }
	}) do
        if v[1] == 0 then
            v103 = false
        else
            v103 = v[2] ~= 0
        end

        local v110 = p24 + v[1]
        local v111 = p25 + v[2]

        v104 = v110

        while true do
            v104 = v110 >= 1

            if v104 then
                v104 = v110 <= 8

                if v104 then
                    if v111 >= 1 then
                        v104 = v111 <= 8
                    else
                        v104 = false
                    end
                end
            end

            if not v104 then
                break
            end

            v104 = p23[v110][v111]

            if v104 then
                v = v104 == v101

                if not v then
                    if v103 then
                        v = v104 == v132_
                    else
                        v = v103
                    end

                    if not v then
                        v = not v103

                        if v then
                            v = v104 == v100
                        end
                    end
                end

                if v then
                    return true
                end

                break
            end

            v110 = v110 + v[1]
            v111 = v111 + v[2]
            v104 = v110
        end
    end

    return false
end
value26 = rochessUnload.value40
local value41
function rochessUnload.value38(p29, p30, p31)
    local v113, v114 = value34(p30:sub(1, 2))
    local v115, v116 = value34(p30:sub(3, 4))
    local v117 = p29.board[v113]
    local v118, v119, n4, n5, v122, v123, v124
    if not v117 then
        if v117 then
            v118 = v117:lower()
            v117 = v117 == v117:upper()
            v119 = p29.board[v115][v116]
            n5 = 0
            if v119 then
                v119 = value1[v119:lower()] or 0
            else
                if v118 == "p" then
                    v119 = v114 ~= v116
                else
                    v119 = false
                end

                v119 = v119 and 1 or n5
            end
            n5 = value26(p29)
            value35(n5, p30)
            v122 = v117 and "k" or v117 or "K"
            v123 = false
            for i = 1, 8 do
                v124 = i

                for i2 = 1, 8 do
                    if n5.board[v124][i2] == v122 then
                        v123 = value41(n5.board, v124, i2, v117)
                    end
                end
            end
            if v117 then
                n4 = v113 - v115
            else
                n4 = v117
            end
            n4 = n4 or v115 - v113
            n5 = v118 == "k"
            if n5 then
                v114 = v116 - v114
                n5 = math.abs(v114) == 2
            end
            v114 = v117 and 8 or 1
            v116 = v118 ~= "p"
            if v116 then
                v116 = v118 ~= "k"

                if v116 then
                    if v113 == v114 then
                        v116 = v115 ~= v114
                    else
                        v116 = false
                    end
                end
            end
            v113 = value1[v118] or 0
            if p31 == "Aggressive" then
                return v119 + (v123 and 2 or 0) + math.max(n4, 0) * 0.4 + (v118 == "p" and 0.3 or 0)
            end
            if p31 ~= "Defensive" then
                if p31 == "Simplify" then
                    if v119 > 0 then
                        v113 = v113 <= v119
                    else
                        v113 = false
                    end

                    if v113 then
                        return v119 * 1.5 + 1
                    else
                        return v119 <= 0 and 0 or v119 * 0.5
                    end

                    return
                else
                    return 0
                end

                return
            end
            v113 = (n5 and 3 or 0) + (v116 and 0.8 or 0)
            v114 = v118 == "p"
            if not v114 then
                return v113 - (v114 or 0) + (n4 < 0 and 0.4 or 0) + v119 * 0.2
            end
            v114 = math.max(n4, 0) * 0.5

            return v113 - (v114 or 0) + (n4 < 0 and 0.4 or 0) + v119 * 0.2
        else
            return 0
        end

        return
    end
    v117 = p29.board[v113][v114]
    if v117 then
        v118 = v117:lower()
        v117 = v117 == v117:upper()
        v119 = p29.board[v115][v116]
        n5 = 0
        if v119 then
            v119 = value1[v119:lower()] or 0
        else
            if v118 == "p" then
                v119 = v114 ~= v116
            else
                v119 = false
            end

            v119 = v119 and 1 or n5
        end
        n5 = value26(p29)
        value35(n5, p30)
        v122 = v117 and "k" or v117 or "K"
        v123 = false
        for i = 1, 8 do
            v124 = i

            for i2 = 1, 8 do
                if n5.board[v124][i2] == v122 then
                    v123 = value41(n5.board, v124, i2, v117)
                end
            end
        end
        if v117 then
            n4 = v113 - v115
        else
            n4 = v117
        end
        n4 = n4 or v115 - v113
        n5 = v118 == "k"
        if n5 then
            v114 = v116 - v114
            n5 = math.abs(v114) == 2
        end
        v114 = v117 and 8 or 1
        v116 = v118 ~= "p"
        if v116 then
            v116 = v118 ~= "k"

            if v116 then
                if v113 == v114 then
                    v116 = v115 ~= v114
                else
                    v116 = false
                end
            end
        end
        v113 = value1[v118] or 0
        if p31 == "Aggressive" then
            return v119 + (v123 and 2 or 0) + math.max(n4, 0) * 0.4 + (v118 == "p" and 0.3 or 0)
        end
        if p31 ~= "Defensive" then
            if p31 == "Simplify" then
                if v119 > 0 then
                    v113 = v113 <= v119
                else
                    v113 = false
                end

                if v113 then
                    return v119 * 1.5 + 1
                else
                    return v119 <= 0 and 0 or v119 * 0.5
                end

                return
            else
                return 0
            end

            return
        end
        v113 = (n5 and 3 or 0) + (v116 and 0.8 or 0)
        v114 = v118 == "p"
        if not v114 then
            return v113 - (v114 or 0) + (n4 < 0 and 0.4 or 0) + v119 * 0.2
        end
        v114 = math.max(n4, 0) * 0.5

        return v113 - (v114 or 0) + (n4 < 0 and 0.4 or 0) + v119 * 0.2
    else
        return 0
    end
end
value41 = rochessUnload.value41
value1 = rochessUnload.value38
function rochessUnload.value30(p32, _)
    if value9.style == "Balanced" and true or not value8 then
        return
    else
        local v130 = value37({
			["Url"] = "https://lichess.org/api/cloud-eval?multiPv=5&fen=" .. value5:UrlEncode(p32),
			["Method"] = "GET"
		})
        local pvs
        if v130 then
            pvs = v130.pvs

            if not pvs then
                if not pvs then
                    return
                end

                return
            end

            pvs = #v130.pvs > 1
        else
            pvs = v130
        end
        if not pvs then
            return
        end

        return
    end
end
value5 = rochessUnload.value30
rochessUnload.value39 = game:GetService("Players")
rochessUnload.value42 = rochessUnload.value1
rochessUnload.value43 = queue_on_teleport
rochessUnload.value30 = rochessUnload.value43
if not rochessUnload.value43 then
    value8 = syn
    rochessUnload.value44 = value8

    if value8 then
        rochessUnload.value44 = syn.queue_on_teleport
    end

    rochessUnload.value43 = rochessUnload.value44

    if not rochessUnload.value44 then
        value8 = rochessUnload.value1
        value1 = fluxus
        rochessUnload.value44 = value1

        if value1 then
            rochessUnload.value44 = fluxus.queue_on_teleport
        end

        rochessUnload.value43 = rochessUnload.value44
        rochessUnload.value1 = value8
    end

    rochessUnload.value30 = rochessUnload.value43
end
rochessUnload.value1 = rochessUnload.value42
value8 = rochessUnload.value30
function rochessUnload.value43()
    if value8 then
        if t1.value3 == "" then
            return false, "SCRIPT_URL is empty"
        else
            local v133 = value8
            local value3 = t1.value3

            v133(("loadstring(game:HttpGet(\"%s\"))()").format("loadstring(game:HttpGet(\"%s\"))()", value3))

            return true
        end

        return
    else
        return false, "Executor has no queue_on_teleport"
    end
end
value8 = rochessUnload.value43
local u134 = false
value45(rochessUnload.value39.LocalPlayer.OnTeleport, function(p33)
    if p33 == Enum.TeleportState.Failed then
        u134 = false

        return
    end

    local autoExec = value9.autoExec

    if autoExec then
        autoExec = not u134
    end

    if not autoExec then
        return
    end

    pcall(value8)
end)
value45 = function(p34, p35)
    local thinkTime = value9.thinkTime
    local quickOpening = value9.quickOpening

    if quickOpening then
        quickOpening = p35 < 8
    end

    if quickOpening then
        thinkTime = math.min(thinkTime, 0.3)
    end

    quickOpening = value9.humanize

    if quickOpening then
        quickOpening = thinkTime > 0
    end

    if quickOpening then
        thinkTime = thinkTime * (0.6 + math.random() * 0.8)
    end

    thinkTime = thinkTime - (os.clock() - p34)

    if not (thinkTime > 0) then
        return
    end

    task.wait(thinkTime)
end
value8 = function(p36)
    s2 = p36 or s2
    value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)
end
value45 = function(p37)
    local session = value53.session

    if not session then
        return
    end

    if session ~= nil then
        value17 = -1
    end

    if value92 or session.over then
        return
    end

    if not session:isMyTurn() then
        return
    end

    local v139 = not p37

    if v139 then
        v139 = os.clock() < 0
    end

    if v139 then
        return
    end

    v139 = #session.ucis

    local v140 = not p37

    if v140 then
        v140 = v139 == value17
    end

    if v140 then
        return
    end

    v140 = os.clock()
    s2 = "Thinking..."
    value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

    local match, ok2 = value33(session)
    local v143, v144, lastEngine = value52(ok2, session)
    local suggestion

    if v143 then
        suggestion = value9.style ~= "Balanced"
    else
        suggestion = v143
    end

    local lastEval

    if suggestion then
        ok2, suggestion, lastEval = pcall(value5, ok2, match)

        if ok2 and suggestion then
            lastEngine = "Lichess (" .. value9.style .. ")"
        else
            lastEval = v144
            suggestion = v143
        end
    else
        lastEval = v144
        suggestion = v143
    end

    if suggestion then
        suggestion = value32(match, suggestion)
    end

    if suggestion then
        match = suggestion:match("^[a-h][1-8][a-h][1-8][qrbn]?$")
    else
        match = suggestion
    end

    if not match then
        session = os.clock() + 3
        s2 = "Engine unavailable, retrying in 3s"
        value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

        return
    end

    match = t2
    match = t2
    t2.lastMove = suggestion
    match.lastEngine = lastEngine or "?"
    match.lastEval = lastEval or "?"

    if value9.mode == "Suggest Only" then
        s2 = "Suggestion: " .. suggestion or s2
        value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)
        session = t1.value4
        v139 = {
			["Title"] = "Best move: " .. suggestion,
			["Content"] = (lastEngine or "?") .. (" | eval " .. lastEval or "?"),
			["Icon"] = "crown",
			["Duration"] = 4
		}
        session:Notify(v139)

        return
    end

    value45(v140, v139)
    v140 = value53.session == session

    if not v140 then
        if v140 then
            value53.send({
				["type"] = "move",
				["id"] = session.id,
				["uci"] = suggestion,
				["ply"] = v139
			})
            t2.played = t2.played + 1
            s2 = "Played " .. suggestion or s2
            value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

            return
        else
            s2 = "Position changed, recalculating..."
            value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

            return
        end

        return
    end

    v140 = not session.over

    if not v140 then
        if v140 then
            value53.send({
				["type"] = "move",
				["id"] = session.id,
				["uci"] = suggestion,
				["ply"] = v139
			})
            t2.played = t2.played + 1
            s2 = "Played " .. suggestion or s2
            value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

            return
        else
            s2 = "Position changed, recalculating..."
            value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

            return
        end

        return
    end

    v140 = session:isMyTurn()

    if not v140 then
        if v140 then
            value53.send({
				["type"] = "move",
				["id"] = session.id,
				["uci"] = suggestion,
				["ply"] = v139
			})
            t2.played = t2.played + 1
            s2 = "Played " .. suggestion or s2
            value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

            return
        else
            s2 = "Position changed, recalculating..."
            value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

            return
        end

        return
    end

    v140 = #session.ucis == v139

    if v140 then
        value53.send({
			["type"] = "move",
			["id"] = session.id,
			["uci"] = suggestion,
			["ply"] = v139
		})
        t2.played = t2.played + 1
        s2 = "Played " .. suggestion or s2
        value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

        return
    else
        s2 = "Position changed, recalculating..."
        value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

        return
    end
end
task.spawn(function()
    while value12 do
        task.wait(0.4)

        if value9.running then
            local ok2, result = pcall(value45, false)

            if not ok2 then
                ok2 = os.clock() + 3
                warn("[RoChess]", result)
            end
        end
    end
end)
value5 = rochessUnload.value1
value5 = rochessUnload.value1
value1 = value53.selectedTc
value1 = type(value1) == "string"
if value1 then
    value1 = value53.selectedTc
end
rochessUnload.value1 = value5
local id
value5 = function(p38)
    if value9.tcChoice ~= "Same as last" then
        return value9.tcChoice
    end

    local tc

    if p38 then
        tc = p38.tc

        if tc then
            tc = p38.tc.id
        end
    else
        tc = p38
    end

    if not tc then
        return id
    end

    id = p38.tc.id

    return id
end
id = value1 or "3+2"
value1 = function(p39)
    local black

    if p39 then
        black = p39.black

        if not black then
            return black
        end

        black = p39.black.display == "Searching..."
    else
        black = p39
    end

    return black
end
local n6 = 0
local u154
value5 = function(p40)
    local v155 = value5(p40)

    n6 = os.clock()

    if p40 then
        p40 = p40.over
    end

    if not p40 then
        pcall(value53.send, {
			["type"] = "queue",
			["tc"] = v155
		})
        t2.queued = t2.queued + 1
        s2 = "Queued " .. v155 or s2
        value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)

        return
    end

    pcall(value53.send, {
		["type"] = "leaveGame"
	})
    task.wait(0.2)
    pcall(value53.send, {
		["type"] = "queue",
		["tc"] = v155
	})
    t2.queued = t2.queued + 1
    s2 = "Queued " .. v155 or s2
    value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)
end
value5 = function()
    local session = value53.session
    local now = os.clock()
    local over

    if session then
        over = session.over
    else
        over = session
    end

    if over then
        if u154 == session then
            now = now - n6 > 15
        else
            now = false
        end

        if now then
            u154 = nil
        end

        if u154 == session then
            return
        end

        task.wait(value9.queueDelay)
        now = value53.session == session

        if not now then
            if now then
                value5(session)

                return
            else
                return
            end

            return
        end

        now = session.over

        if not now then
            if now then
                value5(session)

                return
            else
                return
            end

            return
        end

        now = value9.autoQueue

        if now then
            value5(session)

            return
        else
            return
        end

        return
    else
        over = not session

        if not over then
            if session.kind == "idle" then
                over = not value1(session)
            else
                over = false
            end
        end

        if over then
            over = now - n6 > 10
        end

        if not over then
            return
        end

        value5(session)

        return
    end
end
task.spawn(function()
    while value12 do
        task.wait(1)

        if value9.autoQueue then
            local ok2, result = pcall(value5)

            if not ok2 then
                warn("[RoChess]", result)
            end
        end
    end
end)
value12 = function(...)
    for _, v in ipairs({ ... }) do
        local ok2, result = pcall(t1.value4.Creator.Icon, v)

        if ok2 and result then
            return v
        end
    end

    return "info"
end
value5 = t1.value4
value1 = Color3.fromHex("#FF8200")
value92 = Color3.fromHex("#0B0B0D")
rochessUnload.value47 = Color3.fromHex("#F5F5F5")
value17 = Color3.fromHex("#27272A")
value26 = Color3.fromHex("#FFB066")
value33 = Color3.fromHex("#EA6F00")
value34 = Color3.fromHex("#FF8200")
value35 = Color3.fromHex("#1F1F23")
value32 = t1.value4
rochessUnload.value49 = Color3.fromHex("#1C1006")
value37 = value32.Gradient
value31 = {
	["Color"] = rochessUnload.value49,
	["Transparency"] = 0
}
rochessUnload.value51 = Color3.fromHex("#0B0B0D")
value32 = value37(value32, {
	["0"] = value31,
	["100"] = {
		["Color"] = rochessUnload.value51,
		["Transparency"] = 0
	}
}, {
	["Rotation"] = 135
})
value37 = Color3.fromHex("#000000")
value31 = Color3.fromHex("#FFFFFF")
rochessUnload.value49 = Color3.fromHex("#FF9F40")
rochessUnload.value51 = Color3.fromHex("#FF8200")
rochessUnload.value52 = Color3.fromHex("#FF8200")
rochessUnload.value53 = Color3.fromHex("#18181B")
rochessUnload.value54 = Color3.fromHex("#F5F5F5")
rochessUnload.value55 = Color3.fromHex("#FF8200")
rochessUnload.value56 = Color3.fromHex("#161618")
rochessUnload.value58 = Color3.fromHex("#F5F5F5")
value312 = value5.AddTheme
rochessUnload.value59 = Color3.fromHex("#A8A29E")
rochessUnload.value60 = Color3.fromHex("#FF8200")
rochessUnload.value61 = Color3.fromHex("#FF8200")
rochessUnload.value62 = Color3.fromHex("#2A2A2E")
rochessUnload.value63 = Color3.fromHex("#FF8200")
rochessUnload.value64 = Color3.fromHex("#FFFFFF")
value312(value5, {
	["Name"] = "RansBlox",
	["Accent"] = value1,
	["Background"] = value92,
	["BackgroundTransparency"] = 0.02,
	["Text"] = rochessUnload.value47,
	["Outline"] = value17,
	["Placeholder"] = value26,
	["Button"] = value33,
	["Icon"] = value34,
	["Hover"] = value35,
	["WindowBackground"] = value32,
	["WindowShadow"] = value37,
	["WindowTopbarTitle"] = value31,
	["WindowTopbarAuthor"] = rochessUnload.value49,
	["WindowTopbarIcon"] = rochessUnload.value51,
	["WindowTopbarButtonIcon"] = rochessUnload.value52,
	["TabBackground"] = rochessUnload.value53,
	["TabTitle"] = rochessUnload.value54,
	["TabIcon"] = rochessUnload.value55,
	["ElementBackground"] = rochessUnload.value56,
	["ElementTitle"] = rochessUnload.value58,
	["ElementDesc"] = rochessUnload.value59,
	["ElementIcon"] = rochessUnload.value60,
	["Toggle"] = rochessUnload.value61,
	["ToggleBar"] = rochessUnload.value62,
	["Slider"] = rochessUnload.value63,
	["SliderThumb"] = rochessUnload.value64
})
value5 = t1.value4
value1 = UDim2.fromOffset(560, 360)
rochessUnload.value50 = UDim.new(1, 0)
rochessUnload.value57 = ColorSequence.new(Color3.fromHex("#FF9A1F"), Color3.fromHex("#FF6A00"))
value92 = {
	["Title"] = "Ro Chess",
	["CornerRadius"] = rochessUnload.value50,
	["StrokeThickness"] = 3,
	["Enabled"] = true,
	["Draggable"] = true,
	["OnlyMobile"] = false,
	["Scale"] = 0.5,
	["Color"] = rochessUnload.value57
}
rochessUnload.value49 = Enum.KeyCode
value5 = value5:CreateWindow({
	["Title"] = "Ro Chess",
	["Author"] = "Ransblox Scripts",
	["Icon"] = "youtube",
	["Theme"] = "RansBlox",
	["NewElements"] = true,
	["Folder"] = "Ro Chess",
	["Size"] = value1,
	["Radius"] = 20,
	["ElementsRadius"] = 16,
	["ShadowTransparency"] = 0.6,
	["User"] = {
		["Enabled"] = true
	},
	["Topbar"] = {
		["Height"] = 44,
		["ButtonsType"] = "Mac"
	},
	["HideSearchBar"] = false,
	["OpenButton"] = value92,
	["ToggleKey"] = rochessUnload.value49.RightControl
})
value5:Tag({
	["Title"] = "v1.0",
	["Icon"] = "youtube",
	["Color"] = Color3.fromHex("#FF8200"),
	["Border"] = true
})
value5:Tag({
	["Title"] = "FREE",
	["Icon"] = "badge-check",
	["Color"] = Color3.fromHex("#22C55E"),
	["Border"] = true
})
value1 = {}
value92 = value12("house", "home")
rochessUnload.value46 = Color3.fromHex("#FF8200")
value1.Home = value5:Tab({
	["Title"] = "Home",
	["Icon"] = value92,
	["IconColor"] = rochessUnload.value46,
	["IconShape"] = "Circle"
})
value92 = value12("crown", "swords", "house")
rochessUnload.value46 = Color3.fromHex("#FF8200")
value1.Auto = value5:Tab({
	["Title"] = "Main",
	["Icon"] = value92,
	["IconColor"] = rochessUnload.value46,
	["IconShape"] = "Circle"
})
value92 = value12("cpu", "settings", "info")
rochessUnload.value46 = Color3.fromHex("#FF8200")
value1.Engine = value5:Tab({
	["Title"] = "Engine",
	["Icon"] = value92,
	["IconColor"] = rochessUnload.value46,
	["IconShape"] = "Circle"
})
value92 = value12("info")
rochessUnload.value45 = Color3.fromHex
value17 = value5.Tab
rochessUnload.value46 = rochessUnload.value45("#FF8200")
value1.Misc = value17(value5, {
	["Title"] = "Misc",
	["Icon"] = value92,
	["IconColor"] = rochessUnload.value46,
	["IconShape"] = "Circle"
})
value92 = function(p41, p42, p43)
    return p41:Section({
		["Title"] = p42,
		["Icon"] = value12(p43),
		["Box"] = true,
		["BoxBorder"] = true,
		["Opened"] = false
	})
end
value12 = function(p44, p45, p46)
    return p44:Section({
		["Title"] = p45,
		["Icon"] = value12(p46),
		["Box"] = true,
		["BoxBorder"] = true,
		["Opened"] = true
	})
end
value17 = function(p47, p48)
    local v165
    local function v166()
        setclipboard(v165)
    end
    v165 = p48
    pcall(v166)
    t1.value4:Notify({
		["Title"] = p47,
		["Content"] = "Link copied to clipboard!",
		["Icon"] = "check",
		["Duration"] = 2
	})
end
value12(value1.Home, "Ransblox Scripts", "user"):Paragraph({
	["Title"] = "Welcome!",
	["Desc"] = "I make Roblox script showcases on YouTube and run a free script hub. New scripts drop on the channel and the website, so subscribe to catch them first."
})
value26 = value12(value1.Home, "100% Free Script", "shield-check")
value26:Paragraph({
	["Title"] = "This script is free",
	["Desc"] = "No key system, no payments, no subscription. It was never sold and it never will be."
})
value26:Paragraph({
	["Title"] = "Found a version with a key? It\'s a scam",
	["Desc"] = "If someone is asking you for a key, money, or to complete tasks to use this script, you\'re looking at a fake copy. Don\'t pay, don\'t enter your info. Only trust the official links below."
})
value26 = value12(value1.Home, "Official Links", "link"):Group()
value26:Button({
	["Title"] = "YouTube",
	["Desc"] = "Ransblox Scripts - subscribe for more scripts",
	["Icon"] = "youtube",
	["Color"] = "Red",
	["Callback"] = function()
    value17("YouTube", t1.value1)
end
})
value26:Button({
	["Title"] = "Website",
	["Desc"] = "ransblox.net - script hub & request page",
	["Icon"] = "globe",
	["Callback"] = function()
    value17("Website", t1.value2)
end
})
value17 = value12(value1.Auto, "Auto Play", "crown")
rochessUnload.value45 = value17.Toggle
rochessUnload.value45(value17, {
	["Title"] = "Auto Play",
	["Desc"] = "Automatically plays on your turn.",
	["Value"] = true,
	["Callback"] = function(p49)
    value9.running = p49
    s2 = p49 and "Running..." or p49 or "Stopped" or s2
    value20(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)
end
})
rochessUnload.value45 = value17.Dropdown
rochessUnload.value45(value17, {
	["Title"] = "Mode",
	["Flag"] = "PlayMode",
	["Desc"] = "Auto Play plays for you. Suggest Only just shows the best move.",
	["Values"] = { "Auto Play", "Suggest Only" },
	["Value"] = "Auto Play",
	["Callback"] = function(p50)
    local v167 = value9

    if type(p50) ~= "table" then
        v167.mode = tostring(p50)

        return
    end

    p50 = p50.Title or (p50.Name or p50[1])
    v167.mode = tostring(p50)
end
})
rochessUnload.value45 = value17.Button
rochessUnload.value45(value17, {
	["Title"] = "Run Once",
	["Desc"] = "Plays (or suggests) one move for the current turn right now.",
	["Icon"] = "play",
	["Callback"] = function()
    task.spawn(function()
        local ok2, result = pcall(value45, true)

        if ok2 then
            return
        end

        warn("[RoChess]", result)
    end)
end
})
value45 = value17.Paragraph
rochessUnload.value46 = {
	["Title"] = "Status",
	["Desc"] = s2
}
rochessUnload.value45 = value45
rochessUnload.value45 = rochessUnload.value45(value17, rochessUnload.value46)
value45 = rochessUnload.value45
local function v170(p51)
    pcall(function()
        value45:SetDesc(p51)
    end)
end
rochessUnload.value47 = value12(value1.Auto, "Playing Style", "swords")
rochessUnload.value48 = rochessUnload.value47.Dropdown
rochessUnload.value48(rochessUnload.value47, {
	["Title"] = "Style",
	["Flag"] = "PlayStyle",
	["Desc"] = "Balanced = best move. Aggressive = captures, checks and attacks. Defensive = safe, castles early. Simplify = trades pieces.",
	["Values"] = rochessUnload.value28,
	["Value"] = "Balanced",
	["Callback"] = function(p52)
    local v171 = value9

    if type(p52) ~= "table" then
        v171.style = tostring(p52)

        return
    end

    p52 = p52.Title or (p52.Name or p52[1])
    v171.style = tostring(p52)
end
})
rochessUnload.value48 = rochessUnload.value47.Slider
rochessUnload.value48(rochessUnload.value47, {
	["Title"] = "Style Flexibility",
	["Flag"] = "StyleTol",
	["Desc"] = "How much worse than the best move a styled move may be, in pawns. Lower = stronger, higher = more style.",
	["Step"] = 0.1,
	["Value"] = {
		["Min"] = 0,
		["Max"] = 1.5,
		["Default"] = 0.5
	},
	["Callback"] = function(p53)
    value9.styleTol = tonumber(p53) or 0.5
end
})
rochessUnload.value48 = value12(value1.Auto, "Timing", "clock")
rochessUnload.value48.Slider(rochessUnload.value48, {
	["Title"] = "Think Time",
	["Flag"] = "ThinkTime",
	["Desc"] = "Delay before each move, in seconds.",
	["Step"] = 0.1,
	["Value"] = {
		["Min"] = 0,
		["Max"] = 15,
		["Default"] = 1.5
	},
	["Callback"] = function(p54)
    value9.thinkTime = tonumber(p54) or 1.5
end
})
rochessUnload.value48.Toggle(rochessUnload.value48, {
	["Title"] = "Humanize",
	["Desc"] = "Adds slight variation to the delay.",
	["Value"] = true,
	["Callback"] = function(p55)
    value9.humanize = p55
end
})
rochessUnload.value48.Toggle(rochessUnload.value48, {
	["Title"] = "Quick Opening",
	["Desc"] = "Keeps the delay short for the first few moves.",
	["Value"] = true,
	["Callback"] = function(p56)
    value9.quickOpening = p56
end
})
value45 = value12(value1.Auto, "Auto Farm", "repeat")
value8 = {
	["Title"] = "Auto Queue",
	["Desc"] = "Queues the next game when one ends.",
	["Value"] = true,
	["Callback"] = function(p57)
    value9.autoQueue = p57
    s2 = p57 and "Auto Queue on" or p57 or "Auto Queue off" or s2
    v170(s2 .. "\nLast: " .. t2.lastMove .. " | " .. t2.lastEngine .. " | " .. t2.lastEval .. " | Played: " .. t2.played .. " | Queued: " .. t2.queued)
end
}
value45:Toggle(value8)
value45:Dropdown({
	["Title"] = "Time Control",
	["Flag"] = "TimeControl",
	["Desc"] = "Time control to queue for.",
	["Values"] = {
		"Same as last",
		"1+0",
		"3+0",
		"3+2",
		"5+0",
		"10+0"
	},
	["Value"] = "Same as last",
	["Callback"] = function(p58)
    local v172 = value9

    if type(p58) ~= "table" then
        v172.tcChoice = tostring(p58)

        return
    end

    p58 = p58.Title or (p58.Name or p58[1])
    v172.tcChoice = tostring(p58)
end
})
value45:Slider({
	["Title"] = "Queue Delay",
	["Flag"] = "QueueDelay",
	["Desc"] = "Pause after a game ends before queueing again.",
	["Step"] = 0.5,
	["Value"] = {
		["Min"] = 0,
		["Max"] = 15,
		["Default"] = 2
	},
	["Callback"] = function(p59)
    value9.queueDelay = tonumber(p59) or 2
end
})
value12 = value12(value1.Engine, "Engine", "cpu")
value12:Dropdown({
	["Title"] = "Engine",
	["Flag"] = "EngineChoice",
	["Desc"] = "Where moves are calculated. Auto selects the best available option.",
	["Values"] = {
		"Auto (best available)",
		"chess-api.com",
		"stockfish.online",
		"Lichess Cloud",
		"VortexBot"
	},
	["Value"] = "Auto (best available)",
	["Callback"] = function(p60)
    local v173 = value9

    if type(p60) ~= "table" then
        v173.engine = tostring(p60)

        return
    end

    p60 = p60.Title or (p60.Name or p60[1])
    v173.engine = tostring(p60)
end
})
value12:Slider({
	["Title"] = "Depth",
	["Flag"] = "EngineDepth",
	["Desc"] = "Search depth for cloud engines.",
	["Step"] = 1,
	["Value"] = {
		["Min"] = 1,
		["Max"] = 18,
		["Default"] = 12
	},
	["Callback"] = function(p61)
    local v174 = value9
    local v175 = tonumber(p61) or 12

    v174.depth = math.floor(v175)
end
})
value12:Toggle({
	["Title"] = "Fallback to VortexBot",
	["Desc"] = "Use the built-in bot if a cloud engine is unavailable.",
	["Value"] = true,
	["Callback"] = function(p62)
    value9.vortexFallback = p62
end
})
value12:Button({
	["Title"] = "Test Engine",
	["Desc"] = "Runs a quick test and shows the result and response time.",
	["Icon"] = "activity",
	["Callback"] = function()
    task.spawn(function()
        local now = os.clock()
        local ok2, result, result2, result3 = pcall(value52, "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", value53.session)

        now = os.clock() - now

        if ok2 and result then
            t1.value4:Notify({
					["Title"] = "Engine Test",
					["Content"] = string.format("%s: %s (%s) in %.2fs", result3 or "?", result, result2 or "?", now),
					["Icon"] = "check",
					["Duration"] = 4
				})

            return
        else
            t1.value4:Notify({
					["Title"] = "Engine Test",
					["Content"] = "All engines failed. Check your connection.",
					["Icon"] = "x",
					["Duration"] = 4
				})

            return
        end
    end)
end
})
value12:Paragraph({
	["Title"] = "Cloud engines",
	["Desc"] = "Cloud engines run on external services (chess-api.com, stockfish.online, Lichess). Only the board position (FEN) is sent in the request. VortexBot runs locally inside the game."
})
value12 = value92(value1.Engine, "VortexBot (in-game)", "bot")
value45 = value12.Slider
function rochessUnload.value49(p63)
    local v181 = value9
    local v182 = tonumber(p63) or 2800

    v181.vRating = math.floor(v182)
end
value45(value12, {
	["Title"] = "Rating",
	["Flag"] = "VortexRating",
	["Desc"] = "Playing strength.",
	["Step"] = 50,
	["Value"] = {
		["Min"] = 800,
		["Max"] = 3200,
		["Default"] = 2800
	},
	["Callback"] = rochessUnload.value49
})
value45 = value12.Slider
function rochessUnload.value49(p64)
    local v183 = value9
    local v184 = tonumber(p64) or 20

    v183.vDepth = math.floor(v184)
end
value45(value12, {
	["Title"] = "Depth",
	["Flag"] = "VortexDepth",
	["Desc"] = "Search depth.",
	["Step"] = 1,
	["Value"] = {
		["Min"] = 1,
		["Max"] = 30,
		["Default"] = 20
	},
	["Callback"] = rochessUnload.value49
})
value45 = value12.Slider
function rochessUnload.value49(p65)
    value9.vTime = tonumber(p65) or 2
end
value45(value12, {
	["Title"] = "Time",
	["Flag"] = "VortexTime",
	["Desc"] = "Maximum thinking time, in seconds.",
	["Step"] = 0.5,
	["Value"] = {
		["Min"] = 0.5,
		["Max"] = 10,
		["Default"] = 2
	},
	["Callback"] = rochessUnload.value49
})
value12 = value92(value1.Misc, "Interface", "palette")
value12:Toggle({
	["Title"] = "Glass Mode",
	["Desc"] = "Makes the window slightly transparent",
	["Value"] = false,
	["Callback"] = function(p66)
    value5:ToggleTransparency(p66)
end
})
value12:Slider({
	["Title"] = "UI Scale",
	["Desc"] = "Lower it if the GUI is too big on mobile",
	["Step"] = 0.05,
	["Value"] = {
		["Min"] = 0.7,
		["Max"] = 1.2,
		["Default"] = 1
	},
	["Callback"] = function(p67)
    value5:SetUIScale(p67)
end
})
value12:Keybind({
	["Title"] = "Toggle GUI",
	["Desc"] = "Key to show/hide the window",
	["Value"] = "RightControl",
	["Callback"] = function(p68)
    local v185
    local function v186()
        return Enum.KeyCode[v185]
    end
    v185 = p68
    local result
    v186, result = pcall(v186)
    if not (v186 and result) then
        return
    end
    value5:Toggle()
end
})
value12 = value92(value1.Misc, "Config", "save")
value45 = value12:Paragraph({
	["Title"] = "Auto-save",
	["Desc"] = "Settings are saved automatically and restored on your next launch."
})
value12 = value12:Group()
value52 = value12.Button
function rochessUnload.value49()
    if not value5.CurrentConfig then
        return
    end

    local function v188()
        value5.CurrentConfig:Save()
    end

    if pcall(v188) then
        t1.value4:Notify({
			["Title"] = "Config",
			["Content"] = "Settings saved!",
			["Icon"] = "check",
			["Duration"] = 2
		})
        pcall(function()
            value45:SetDesc("Last saved just now.")
        end)

        return
    end

    t1.value4:Notify({
		["Title"] = "Config",
		["Content"] = "Couldn\'t save settings.",
		["Icon"] = "x",
		["Duration"] = 3
	})
end
value52(value12, {
	["Title"] = "Save Now",
	["Desc"] = "Save your current settings",
	["Icon"] = "save",
	["Callback"] = rochessUnload.value49
})
value45 = value12.Button
function rochessUnload.value49()
    if not value5.CurrentConfig then
        return
    end

    local function v189()
        value5.CurrentConfig:Load()
    end

    if pcall(v189) then
        t1.value4:Notify({
			["Title"] = "Config",
			["Content"] = "Settings loaded!",
			["Icon"] = "check",
			["Duration"] = 2
		})

        return
    end

    t1.value4:Notify({
		["Title"] = "Config",
		["Content"] = "No saved settings found.",
		["Icon"] = "x",
		["Duration"] = 3
	})
end
value45(value12, {
	["Title"] = "Load Saved",
	["Desc"] = "Load your last saved settings",
	["Icon"] = "upload",
	["Callback"] = rochessUnload.value49
})
rochessUnload = function()
    if _G.ROCHESS_Unloaded == value5 then
        return
    end
end
_G.ROCHESS_Unload = rochessUnload
value92(value1.Misc, "Script", "power"):Button({
	["Title"] = "Unload Script",
	["Desc"] = "Removes the GUI and stops everything",
	["Icon"] = "x",
	["Callback"] = rochessUnload
})
value1.Misc:Paragraph({
	["Title"] = "Ro Chess",
	["Desc"] = "Made by Ransblox Scripts \226\128\162 v1.0"
})
rochessUnload = value5.Folder
if rochessUnload then
    rochessUnload = value5.ConfigManager
end
if rochessUnload then
    value5.ConfigManager:CreateConfig("default", true)
end
if t1.value3 ~= "" then
    return
end
t1.value4:Notify({
	["Title"] = "Auto Execute",
	["Content"] = "SCRIPT_URL is empty, so the script won\'t relaunch after a teleport.",
	["Icon"] = "triangle-alert",
	["Duration"] = 6
})
