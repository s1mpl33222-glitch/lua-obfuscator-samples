-- This file was generated at discord.gg/syncrypt

local game_ = game
local t1 = {
	value2 = game_.GetService,
	value6 = 12834712622936
}

t1.value2 = t1.value2(game_, "Players")

local t2 = {
	value1 = game:GetService("TweenService")
}
local _ = t1.value2.LocalPlayer

t1.value3 = nil
t1.value4 = "pcall"
t2.value2 = t1.value3
pcall(function()
	local gethui_ = gethui

	if gethui_ then
		gethui_ = gethui()
	end

	local CoreGui = gethui_ or game:GetService("CoreGui")

	t2.value2 = Instance.new("ScreenGui")
	t2.value2.Name = "CyberHubIntro"
	t2.value2.IgnoreGuiInset = true
	t2.value2.ResetOnSpawn = false
	t2.value2.DisplayOrder = 999999
	t2.value2.Parent = CoreGui

	local Frame = Instance.new("Frame")

	Frame.Name = "Backdrop"
	Frame.Size = UDim2.fromScale(1, 1)
	Frame.BackgroundColor3 = Color3.fromRGB(3, 10, 27)
	Frame.BorderSizePixel = 0
	Frame.Parent = t2.value2

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(4, 18, 48)), ColorSequenceKeypoint.new(0.55, Color3.fromRGB(5, 35, 78)), ColorSequenceKeypoint.new(1, Color3.fromRGB(2, 8, 22)) })
	UIGradient.Rotation = 25
	UIGradient.Parent = Frame

	local Frame2 = Instance.new("Frame")

	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.Position = UDim2.fromScale(0.5, 0.47)
	Frame2.Size = UDim2.fromOffset(180, 180)
	Frame2.BackgroundColor3 = Color3.fromRGB(0, 145, 255)
	Frame2.BackgroundTransparency = 0.88
	Frame2.BorderSizePixel = 0
	Frame2.Parent = Frame

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(0, 195, 255)
	UIStroke.Thickness = 1
	UIStroke.Transparency = 0.35
	UIStroke.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.BackgroundTransparency = 1
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.Position = UDim2.fromScale(0.5, 0.44)
	TextLabel.Size = UDim2.new(0.8, 0, 0, 56)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.Text = "CYBER HUB"
	TextLabel.TextColor3 = Color3.fromRGB(235, 249, 255)
	TextLabel.TextTransparency = 1
	TextLabel.TextScaled = true
	TextLabel.Parent = Frame

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.BackgroundTransparency = 1
	TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel2.Position = UDim2.fromScale(0.5, 0.52)
	TextLabel2.Size = UDim2.new(0.8, 0, 0, 24)
	TextLabel2.Font = Enum.Font.GothamMedium
	TextLabel2.Text = "PREMIUM CONTROL INTERFACE"
	TextLabel2.TextColor3 = Color3.fromRGB(92, 203, 255)
	TextLabel2.TextTransparency = 1
	TextLabel2.TextSize = 12
	TextLabel2.Parent = Frame

	local Frame3 = Instance.new("Frame")

	Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame3.Position = UDim2.fromScale(0.5, 0.61)
	Frame3.Size = UDim2.fromOffset(190, 3)
	Frame3.BackgroundColor3 = Color3.fromRGB(24, 56, 91)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 0, 1, 0)
	Frame4.BackgroundColor3 = Color3.fromRGB(0, 195, 255)
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame3

	local UIGradient2 = Instance.new("UIGradient")

	UIGradient2.Color = ColorSequence.new(Color3.fromRGB(0, 112, 255), Color3.fromRGB(0, 235, 255))
	UIGradient2.Parent = Frame4

	local value1 = t2.value1
	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
	local UDim2_ = UDim2

	value1.Create(value1, TextLabel, tweenInfo, {
		TextTransparency = 0,
		Position = UDim2_.fromScale(0.5, 0.43)
	}):Play()

	local value12 = t2.value1
	local tweenInfoNew = TweenInfo.new
	local Quad = Enum.EasingStyle.Quad
	local Enum_ = Enum
	local v24 = value12.Create(value12, Frame2, tweenInfoNew(0.55, Quad, Enum_.EasingDirection.Out), {
		Size = UDim2.fromOffset(260, 260),
		BackgroundTransparency = 0.94
	})

	v24.Play(v24)
	task.wait(0.12)
	t2.value1:Create(TextLabel2, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		TextTransparency = 0
	}):Play()

	local value13 = t2.value1
	local tweenInfo2 = TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local uDim2New = UDim2.new
	local v28 = value13.Create(value13, Frame4, tweenInfo2, {
		Size = uDim2New(1, 0, 1, 0)
	})

	v28.Play(v28)
	task.wait(0.82)
	t2.value1:Create(Frame, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundTransparency = 1
	}):Play()

	local GetDescendants = Frame.GetDescendants

	for _, v in ipairs(GetDescendants(Frame)) do
		if v:IsA("TextLabel") then
			local value14 = t2.value1
			local tweenInfoNew2 = TweenInfo.new

			value14.Create(value14, v, tweenInfoNew2(0.18), {
				TextTransparency = 1
			}):Play()
		elseif v:IsA("Frame") then
			local value14 = t2.value1
			local tweenInfo3 = TweenInfo.new(0.18)

			value14.Create(value14, v, tweenInfo3, {
				BackgroundTransparency = 1
			}):Play()
		elseif v:IsA("UIStroke") then
			local value14 = t2.value1
			local tweenInfo3 = TweenInfo.new(0.18)

			value14.Create(value14, v, tweenInfo3, {
				Transparency = 1
			}):Play()
		end
	end

	task.wait(0.22)
	t2.value2:Destroy()
end)
t1.value4 = game:GetService("ReplicatedStorage")
t1.value3 = game
t2.value3 = t1.value3:GetService("HttpService")

local ok, value6 = pcall(function()
	return loadstring(game:HttpGet("https://raw.githubusercontent.com/YTRANSBLOX/RANSBLOX-SCRIPT/refs/heads/main/maingui.lua"))()
end)

t1.value5 = ok
t1.value6 = value6
t2.value4 = t1.value6
t1.value6 = not (t1.value5 and t2.value4)

if t1.value6 then
	return
end

t1.value8 = 3505773069920
t1.value10 = "ډ\240\226/"
t1.value6 = true

local value62 = t1.value6

t1.value15 = nil
t1.value7 = 10
t1.value16 = nil
t1.value17 = nil
t1.value8 = "\185\1j\190\147\205=\139\"\171\214"
t1.value18 = nil
t1.value6 = "WaitForChild"
t1.value13 = nil
t1.value19 = nil
t1.value6 = t1.value4:WaitForChild("Chess", t1.value7)

local value63 = t1.value6
local WaitForChild = t1.value4.WaitForChild

t1.value12 = 18676145758712
t1.value11 = nil
t1.value6 = WaitForChild
t1.value20 = nil
t1.value8 = nil
t1.value22 = nil
t1.value23 = nil
t1.value14 = nil
t1.value9 = 10
t1.value24 = nil
t1.value6 = t1.value6(t1.value4, "ChessClient", t1.value9)

local value64 = t1.value6

t1.value9 = nil
t1.value6 = nil

local _ = t1.value6
local _ = t1.value9
local _ = t1.value8
local _ = t1.value11
local _ = t1.value13
local _ = t1.value14
local _ = t1.value22
local _ = t1.value18
local value16 = t1.value16
local value24 = t1.value24
local value15 = t1.value15
local _ = t1.value19
local _ = t1.value23
local _ = t1.value17
local value20 = t1.value20

t1.value21 = not (value63 and value64)

if t1.value21 then
	t2.value4:Notify({
		Title = "Cyber Hub",
		Content = "RoChess was not found. This script only works in RoChess.",
		Icon = "x",
		Duration = 5
	})

	return
end

local ok2, value35 = pcall(function()
	return require(value64:WaitForChild("App", 10))
end)

t1.value34 = ok2
t1.value35 = value35

local value352 = t1.value35

t1.value27 = not t1.value34
t1.value26 = t1.value27

if not t1.value27 then
	t1.value26 = type(value352) ~= "table"
end

if t1.value26 then
	t2.value4:Notify({
		Title = "Cyber Hub",
		Content = "Client module not found.",
		Icon = "x",
		Duration = 5
	})

	return
end

t1.value25 = pcall

function t1.value28()
	return require(value63:WaitForChild("VortexBot", 10))
end

t1.value29 = { t1.value25(t1.value28) }

local v62 = t1.value29[2]

if not t1.value29[1] then
	v62 = nil
end

function t1.value31()
	return require(value63:WaitForChild("Engine", 10))
end

local ok3, value30 = pcall(t1.value31)

t1.value29 = ok3
t1.value30 = value30
t1.value31 = not t1.value29

local value302 = t1.value30

if t1.value31 then
	value302 = nil
end

t1.value37 = 31277103593700
t1.value38 = "2\127b\179q+\4_\255"
t1.value39 = "Tv\1580b\24"
t1.value32 = {
	autoPlay = true,
	autoQueue = true,
	engine = "Stockfish - stockfish.online (cloud)",
	fallback = true,
	depth = 15,
	think = 2,
	moveDelay = 0.3,
	rating = 2800,
	queueDelay = 2
}

function t1.value33(p1)
	local v66 = type(p1) == "string"

	if not v66 then
		return v66
	end

	v66 = p1:match("^[a-h][1-8][a-h][1-8][qrbn]?$") ~= nil

	return v66
end

t1.value39 = 2609307157695
t1.value38 = 8142647185103

local value32 = t1.value32
local value33 = t1.value33
local t3 = {
	n = 2,
	b = 3,
	r = 4,
	q = 5
}

local function v70(p2)
	local algToIndex64 = value302
	local ok4, result, sub

	if algToIndex64 then
	elseif algToIndex64 then
		ok4, result = pcall(value302.algToIndex64, p2)

		return ok4 and result and result or (tonumber(p2:sub(2, 2)) - 1) * 8 + (p2:byte(1) - 97) + 1
	else
		sub = p2.sub

		return (tonumber(sub(p2, 2, 2)) - 1) * 8 + (p2:byte(1) - 97) + 1
	end

	algToIndex64 = value302.algToIndex64

	if algToIndex64 then
		ok4, result = pcall(value302.algToIndex64, p2)

		return ok4 and result and result or (tonumber(p2:sub(2, 2)) - 1) * 8 + (p2:byte(1) - 97) + 1
	else
		sub = p2.sub

		return (tonumber(sub(p2, 2, 2)) - 1) * 8 + (p2:byte(1) - 97) + 1
	end
end
local function v75(p3)
	if type(p3) == "string" then
		local ok4, result = pcall(t2.value3.JSONDecode, t2.value3, p3)

		if ok4 then
			return result
		else
			return nil
		end
	else
		return nil
	end
end
local function v78(p4)
	local syn_ = syn

	if syn_ then
		syn_ = syn.request
	end

	if not syn_ then
		syn_ = http

		if syn_ then
			syn_ = http.request
		end

		if not syn_ then
			syn_ = http_request

			if not syn_ then
				syn_ = request

				if not syn_ then
					syn_ = fluxus

					if syn_ then
						syn_ = fluxus.request
					end
				end
			end
		end
	end

	if not syn_ then
		return nil
	end

	local ok4, result = pcall(syn_, p4)

	if ok4 then
	elseif ok4 then
		return result.Body
	else
		return nil
	end

	ok4 = type(result) == "table"

	if ok4 then
	elseif ok4 then
		return result.Body
	else
		return nil
	end

	ok4 = result.StatusCode == nil and true or result.StatusCode == 200

	if ok4 then
		return result.Body
	else
		return nil
	end
end
local function v82(p5)
	local engine = p5.engine
	local getFen

	if engine then
		getFen = engine.getFen
	else
		getFen = engine
	end

	if not getFen then
		return nil
	end

	local ok4, result = pcall(engine.getFen, engine)

	if ok4 then
	elseif ok4 then
		return result
	else
		return nil
	end

	ok4 = type(result) == "string"

	if ok4 then
		return result
	else
		return nil
	end
end
local function v87(p6)
	local session = value352.session

	if not session or (session.over or (session.kind ~= "online" and true or not session:isMyTurn())) then
		return false
	end

	if session.viewPly ~= #session.ucis then
		session.viewPly = #session.ucis
	end

	local v89 = #p6 >= 5 and (t3[p6.sub(p6, 5, 5):lower()] or 0) or 0
	local ok4, result = pcall(value352.onBoardMove, v70(p6.sub(p6, 1, 2)), v70(p6.sub(p6, 3, 4)), v89, false)

	if not ok4 then
		return ok4
	end

	ok4 = result == true

	return ok4
end

local value36 = {}

t1.value36 = value36

function t1.value40(_, p7)
	if p7 then
		local depth = value32.depth
		local v94 = math.clamp(depth, 1, 15)
		local v95 = v75(v78({
			Url = "https://stockfish.online/api/s/v2.php?fen=" .. t2.value3:UrlEncode(p7) .. "&depth=" .. v94,
			Method = "GET"
		}))
		local v96, bestmove

		if v95 then
			v96 = v95.success ~= false

			if v96 then
			elseif v96 then
				bestmove = v95.bestmove

				return bestmove.match(bestmove, "bestmove%s+(%S+)")
			else
				return nil
			end

			local bestmove2 = v95.bestmove

			v96 = type(bestmove2) == "string"
		else
			v96 = v95
		end

		if v96 then
			bestmove = v95.bestmove

			return bestmove.match(bestmove, "bestmove%s+(%S+)")
		else
			return nil
		end
	else
		return nil
	end
end

t1.value36["Stockfish - stockfish.online (cloud)"] = t1.value40
t1.value36 = value36

function t1.value40(_, p8)
	if p8 then
		local v99 = v75
		local v100 = v78
		local value3 = t2.value3
		local depth = value32.depth
		local v103 = math.clamp(depth, 1, 18)
		local v104 = value32.think * 20
		local t4 = {
			fen = p8,
			depth = v103,
			variants = 1,
			maxThinkingTime = math.clamp(v104, 10, 100)
		}
		local v106 = v99(v100({
			Url = "https://chess-api.com/v1",
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = value3.JSONEncode(value3, t4)
		}))

		if v106 then
			return v106.lan or v106.move
		else
			return nil
		end
	else
		return nil
	end
end

t1.value36["Stockfish - chess-api.com (cloud)"] = t1.value40
t1.value36 = value36
t1.value39 = 10146448527988
t1.value37 = 9637392486791

function t1.value40(_, p9)
	if p9 then
		local v107 = v75(v78({
			Url = "https://lichess.org/api/cloud-eval?multiPv=1&fen=" .. t2.value3:UrlEncode(p9),
			Method = "GET"
		}))
		local pvs, moves

		if v107 then
			pvs = v107.pvs

			if pvs then
			elseif pvs then
				moves = v107.pvs[1].moves

				return moves.match(moves, "^(%S+)")
			else
				return nil
			end

			pvs = v107.pvs[1]

			if pvs then
			elseif pvs then
				moves = v107.pvs[1].moves

				return moves.match(moves, "^(%S+)")
			else
				return nil
			end

			local moves2 = v107.pvs[1].moves

			pvs = type(moves2) == "string"
		else
			pvs = v107
		end

		if pvs then
			moves = v107.pvs[1].moves

			return moves.match(moves, "^(%S+)")
		else
			return nil
		end
	else
		return nil
	end
end

t1.value36["Lichess Cloud Eval (cloud)"] = t1.value40
t1.value36 = value36

function t1.value40(p10)
	if not v62 then
		return nil
	end

	local startFen = p10.startFen

	if startFen then
		v109 = v62.think
		v110 = table.clone(p10.ucis)
		v111 = value32.rating
		v112 = value32.depth

		return v109(startFen, v110, {
			rating = v111,
			depth = math.min(v112, 20),
			time = value32.think
		})
	end

	startFen = p10.engine

	if not startFen then
		v109 = v62.think
		v110 = table.clone(p10.ucis)
		v111 = value32.rating
		v112 = value32.depth

		return v109(startFen, v110, {
			rating = v111,
			depth = math.min(v112, 20),
			time = value32.think
		})
	end

	startFen = p10.engine.startFen

	local think = v62.think
	local v113 = table.clone(p10.ucis)
	local rating = value32.rating
	local depth = value32.depth

	return think(startFen, v113, {
		rating = rating,
		depth = math.min(depth, 20),
		time = value32.think
	})
end

t1.value36["Game Bot - Vortex (local)"] = t1.value40
t1.value36 = {
	"Stockfish - stockfish.online (cloud)",
	"Stockfish - chess-api.com (cloud)",
	"Lichess Cloud Eval (cloud)",
	"Game Bot - Vortex (local)"
}

local v116 = false

function t1.value41()
	if v116 or os.clock() < value16 then
		return
	end

	local session = value352.session

	if not session or (session.kind ~= "online" or (session.over or not session:isMyTurn())) then
		return
	end

	local v118 = #session.ucis
	local t5 = { value32.engine }
	local fallback = value32.fallback

	if fallback then
		fallback = value32.engine ~= "Game Bot - Vortex (local)"
	end

	if fallback then
		table.insert(t5, "Game Bot - Vortex (local)")
	end

	local v121 = v82(session)
	local v122 = false

	for _, v in ipairs(t5) do
		local v125 = value36[v]

		if v125 then
			local ok4, result = pcall(v125, session, v121)

			if ok4 then
				ok4 = value33(result)

				if ok4 then
					ok4 = value24(session, v118)
				end
			end

			if ok4 then
				if value32.moveDelay > 0 then
					task.wait(value32.moveDelay)
				end

				local v128 = value24(session, v118)

				if v128 then
					v128 = v87(result)
				end

				if v128 then
					v:match("^(.-) %(")
					v122 = true

					break
				end
			end
		end

		if not value24(session, v118) then
			break
		end
	end

	local v129 = not v122

	if v129 then
		v129 = value24(session, v118)
	end

	if not v129 then
		return
	end

	value16 = os.clock() + 2
end

local value41 = t1.value41

local function _(p11, p12)
	local autoPlay = value62

	if not autoPlay then
		return autoPlay
	end

	autoPlay = value32.autoPlay

	if not autoPlay then
		return autoPlay
	end

	autoPlay = value352.session == p11

	if not autoPlay then
		return autoPlay
	end

	autoPlay = not p11.over

	if not autoPlay then
		return autoPlay
	end

	autoPlay = p11.kind == "online"

	if not autoPlay then
		return autoPlay
	end

	if #p11.ucis == p12 then
		autoPlay = p11:isMyTurn()
	else
		autoPlay = false
	end

	return autoPlay
end

task.spawn(function()
	while value62 do
		task.wait(0.3)

		if value32.autoPlay then
			local ok4, result = pcall(value41)

			if not ok4 then
				local _ = os.clock() + 2

				warn("[RoChess] " .. tostring(result))
			end
		end
	end
end)

local function v136()
	if value15 then
		return
	end

	local session = value352.session
	local over

	if session then
		if session.kind == "online" then
			over = session.over
		else
			over = false
		end
	else
		over = session
	end

	if over then
		task.wait(value32.queueDelay)

		local autoQueue = value62

		if autoQueue then
			autoQueue = value32.autoQueue

			if autoQueue then
				if value352.session == session then
					autoQueue = session.over
				else
					autoQueue = false
				end
			end
		end

		if not autoQueue then
			task.wait(1.5)
			value15 = false

			return
		end

		pcall(value352.newGame)
		task.wait(1.5)
		value15 = false
	else
		local v140 = not session or session.kind == "idle"

		if v140 then
			v140 = not value352.searching

			if v140 then
				v140 = not value352.joining
			end
		end

		if not v140 then
			return
		end

		pcall(value352.startSearch, value352.selectedTc)
		task.wait(3)
		value15 = false
	end
end

task.spawn(function()
	while value62 do
		task.wait(1)

		if value32.autoQueue then
			local ok4, result = pcall(v136)

			if not ok4 then
				warn("[RoChess] " .. tostring(result))
			end
		end
	end
end)

local function v143(...)
	for _, v in ipairs({ ... }) do
		local ok4, result = pcall(t2.value4.Creator.Icon, v)

		if ok4 and result then
			return v
		end
	end

	return "info"
end

t1.value38 = t2.value4
t1.value45 = Color3.fromHex("#24C8FF")

local color3 = Color3.fromHex("#050D1B")
local color32 = Color3.fromHex("#EAF7FF")
local color33 = Color3.fromHex("#174A78")
local color34 = Color3.fromHex("#7FCFFF")
local color35 = Color3.fromHex("#087FE8")
local color36 = Color3.fromHex("#35D5FF")
local color37 = Color3.fromHex("#10365D")

t1.value46 = t2.value4
t1.value53 = Color3.fromHex("#071B38")
t1.value50 = {
	Color = t1.value53,
	Transparency = 0
}
t1.value55 = Color3.fromHex("#09264A")
t1.value52 = {
	Color = t1.value55,
	Transparency = 0
}
t1.value47 = t1.value46.Gradient
t1.value56 = Color3.fromHex("#040B17")
t1.value47 = t1.value47(t1.value46, {
	["0"] = t1.value50,
	["45"] = t1.value52,
	["100"] = {
		Color = t1.value56,
		Transparency = 0
	}
}, {
	Rotation = 135
})
t1.value49 = Color3.fromHex("#01040A")
t1.value51 = Color3.fromHex("#F5FBFF")
t1.value53 = Color3.fromHex("#68D5FF")
t1.value55 = Color3.fromHex("#35D5FF")
t1.value56 = Color3.fromHex("#75DEFF")
t1.value57 = Color3.fromHex("#07162C")
t1.value58 = Color3.fromHex("#EAF7FF")
t1.value59 = Color3.fromHex("#35D5FF")
t1.value60 = Color3.fromHex("#0B2340")
t1.value61 = Color3.fromHex("#F1FAFF")
t1.value62 = Color3.fromHex("#9ABAD2")
t1.value63 = Color3.fromHex("#4AD7FF")
t1.value64 = Color3.fromHex("#25C9FF")
t1.value65 = Color3.fromHex("#173B5E")
t1.value66 = Color3.fromHex("#25C9FF")
t1.value67 = Color3
t1.value42 = t1.value38.AddTheme
t1.value67 = t1.value67.fromHex("#F5FCFF")
t1.value42(t1.value38, {
	Name = "CyberHub",
	Accent = t1.value45,
	Background = color3,
	BackgroundTransparency = 0.03,
	Text = color32,
	Outline = color33,
	Placeholder = color34,
	Button = color35,
	Icon = color36,
	Hover = color37,
	WindowBackground = t1.value47,
	WindowShadow = t1.value49,
	WindowTopbarTitle = t1.value51,
	WindowTopbarAuthor = t1.value53,
	WindowTopbarIcon = t1.value55,
	WindowTopbarButtonIcon = t1.value56,
	TabBackground = t1.value57,
	TabTitle = t1.value58,
	TabIcon = t1.value59,
	ElementBackground = t1.value60,
	ElementTitle = t1.value61,
	ElementDesc = t1.value62,
	ElementIcon = t1.value63,
	Toggle = t1.value64,
	ToggleBar = t1.value65,
	Slider = t1.value66,
	SliderThumb = t1.value67
})
t1.value38 = t2.value4

local uDim2 = UDim2.fromOffset(690, 450)

t1.value46 = {
	Enabled = true
}
t1.value48 = {
	Height = 48,
	ButtonsType = "Mac"
}
t1.value56 = UDim.new(1, 0)
t1.value62 = ColorSequence
t1.value42 = t1.value38.CreateWindow
t1.value62 = t1.value62.new(Color3.fromHex("#087BFF"), Color3.fromHex("#24D8FF"))
t1.value52 = {
	Title = "Cyber Hub",
	CornerRadius = t1.value56,
	StrokeThickness = 3,
	Enabled = true,
	Draggable = true,
	OnlyMobile = false,
	Scale = 0.62,
	Color = t1.value62
}
t1.value54 = Enum.KeyCode.RightControl
t1.value42 = t1.value42(t1.value38, {
	Title = "Cyber Hub",
	Author = "Zero",
	Icon = "youtube",
	Theme = "CyberHub",
	NewElements = true,
	Folder = "CyberHub",
	Size = uDim2,
	Radius = 14,
	ElementsRadius = 10,
	ShadowTransparency = 0.38,
	User = t1.value46,
	Topbar = t1.value48,
	HideSearchBar = false,
	OpenButton = t1.value52,
	ToggleKey = t1.value54
})

local value42 = t1.value42

t1.value38 = {}
t1.value43 = value42

local t6 = {
	Title = "Dashboard",
	Icon = v143("crown", "house"),
	IconColor = Color3.fromHex("#00C8FF"),
	IconShape = "Circle"
}

t1.value37 = t1.value43:Tab(t6)
t1.value38.Auto = t1.value37
t1.value43 = value42

local t7 = {
	Title = "Chess Engine",
	Icon = v143("cpu", "info"),
	IconColor = Color3.fromHex("#00C8FF"),
	IconShape = "Circle"
}

t1.value37 = t1.value43:Tab(t7)
t1.value38.Eng = t1.value37
t1.value43 = value42

local v159 = v143("info")
local color38 = Color3.fromHex

t1.value37 = t1.value43.Tab

local t8 = {
	Title = "Settings",
	Icon = v159,
	IconColor = color38("#00C8FF"),
	IconShape = "Circle"
}

t1.value37 = t1.value37(t1.value43, t8)
t1.value38.Misc = t1.value37

function t1.value39(p13, p14)
	pcall(function()
		setclipboard(p14)
	end)

	local value4 = t2.value4

	value4.Notify(value4, {
		Title = p13,
		Content = "Link copied to clipboard!",
		Icon = "check",
		Duration = 2
	})
end
function t1.value37(p15)
	if type(p15) ~= "table" then
		return tostring(p15)
	end

	p15 = p15.Title or (p15.Name or p15[1])

	return tostring(p15)
end
function t1.value43(p16, p17, p18)
	return p16:Section({
		Title = p17,
		Icon = v143(p18),
		Box = true,
		BoxBorder = true,
		Opened = true
	})
end

local value37 = t1.value37

function t1.value39(p19, p20, p21)
	return p19:Section({
		Title = p20,
		Icon = v143(p21),
		Box = true,
		BoxBorder = true,
		Opened = false
	})
end

t1.value37 = t1.value39(t1.value38.Auto, "Game Automation", "crown")
t1.value44 = t1.value37.Toggle

local t9 = {
	Title = "Automatic Moves",
	Desc = "Makes moves for your side automatically.",
	Value = true,
	Callback = function(p22)
		value32.autoPlay = p22
	end
}

t1.value44(t1.value37, t9)
t1.value44 = t1.value37.Toggle

local t10 = {
	Title = "Automatic Queue",
	Desc = "Looks for or starts another game after the current game ends.",
	Value = true,
	Callback = function(p23)
		value32.autoQueue = p23
	end
}

t1.value44(t1.value37, t10)

local function v166()
	local Config = require(value63:WaitForChild("Config", 5))
	local v168

	if Config then
		local TC_BY_ID = Config.TC_BY_ID

		v168 = type(TC_BY_ID) == "table"
	else
		v168 = Config
	end

	if not v168 then
		return
	end

	for k in pairs(Config.TC_BY_ID) do
		local v171 = value20
		local v172 = tostring(k)

		table.insert(v171, v172)
	end
end

local t11 = {}

pcall(v166)
t11 = #t11 == 0 and {
	"1+0",
	"3+0",
	"3+2",
	"5+0",
	"10+0"
} or t11
table.sort(t11)

local s1 = "Title"
local s2 = "Game Time Limit"
local s3 = "Flag"
local s4 = "RoChessTC"
local s5 = "Desc"
local s6 = "Time setting used when joining a new game."
local s7 = "Values"
local v181 = t11
local s8 = "Value"
local value1 = t1.value1
local selectedTc = value352.selectedTc

if selectedTc then
	local selectedTc2 = value352.selectedTc

	selectedTc = tostring(selectedTc2)
end

t1.value1 = value1
t1.value45 = t1.value37.Dropdown
t1.value45(t1.value37, {
	[s1] = s2,
	[s3] = s4,
	[s5] = s6,
	[s7] = v181,
	[s8] = selectedTc or "3+2",
	Callback = function(p24)
		value352.selectedTc = value37(p24)
	end
})
t1.value45 = t1.value37.Slider

local t12 = {
	Title = "Next Game Delay",
	Flag = "RoChessQueueDelay",
	Desc = "How many seconds to wait before starting or joining another game.",
	Step = 0.5,
	Value = {
		Min = 0,
		Max = 10,
		Default = 2
	},
	Callback = function(p25)
		value32.queueDelay = tonumber(p25) or 2
	end
}

t1.value45(t1.value37, t12)
t1.value37:Paragraph({
	Title = "Current Status",
	Desc = "Status: Waiting"
})
t1.value45 = t1.value39(t1.value38.Eng, "Move Calculator", "cpu")

local function v187(p26)
	local v188 = value37(p26)

	if not value36[v188] then
		return
	end

	value32.engine = v188
end

t1.value45.Dropdown(t1.value45, {
	Title = "Chess Engine",
	Flag = "RoChessEngine",
	Desc = "Choose how moves are calculated. Cloud options send the board position to an external service; the local bot runs on your device.",
	Values = t1.value36,
	Value = "Stockfish - stockfish.online (cloud)",
	Callback = v187
})

local t13 = {
	Title = "Use Local Backup",
	Desc = "Use the local bot if the selected online service does not respond.",
	Value = true,
	Callback = function(p27)
		value32.fallback = p27
	end
}

t1.value45.Toggle(t1.value45, t13)

local t14 = {
	Title = "Search Depth",
	Flag = "RoChessDepth",
	Desc = "How far the engine searches for possible moves. Online services may have their own limits.",
	Step = 1,
	Value = {
		Min = 1,
		Max = 20,
		Default = 15
	},
	Callback = function(p28)
		local v191 = value32
		local v192 = tonumber(p28) or 15

		v191.depth = math.floor(v192)
	end
}

t1.value45.Slider(t1.value45, t14)

local t15 = {
	Title = "Thinking Time",
	Flag = "RoChessThink",
	Desc = "Time allowed for each move calculation or online request.",
	Step = 1,
	Value = {
		Min = 1,
		Max = 5,
		Default = 2
	},
	Callback = function(p29)
		local v194 = value32
		local v195 = tonumber(p29) or 2

		v194.think = math.floor(v195)
	end
}

t1.value45.Slider(t1.value45, t15)

local t16 = {
	Title = "Move Wait Time",
	Flag = "RoChessMoveDelay",
	Desc = "How long to wait before submitting a calculated move.",
	Step = 0.1,
	Value = {
		Min = 0,
		Max = 3,
		Default = 0.3
	},
	Callback = function(p30)
		value32.moveDelay = tonumber(p30) or 0.3
	end
}

t1.value45.Slider(t1.value45, t16)

local t17 = {
	Title = "Local Bot Strength",
	Flag = "RoChessRating",
	Desc = "Sets the strength of the local bot. Only applies when the local bot is selected.",
	Step = 100,
	Value = {
		Min = 800,
		Max = 2800,
		Default = 2800
	},
	Callback = function(p31)
		local v198 = value32
		local v199 = tonumber(p31) or 2800

		v198.rating = math.floor(v199)
	end
}

t1.value45.Slider(t1.value45, t17)

local v200 = t1.value39(t1.value38.Misc, "Display Settings", "palette")

v200.Toggle(v200, {
	Title = "Transparent Window",
	Desc = "Makes the interface slightly see-through.",
	Value = false,
	Callback = function(p32)
		value42:ToggleTransparency(p32)
	end
})
v200.Slider(v200, {
	Title = "Interface Size",
	Desc = "Reduce this value if the interface looks too large on your screen.",
	Step = 0.05,
	Value = {
		Min = 0.7,
		Max = 1.2,
		Default = 1
	},
	Callback = function(p33)
		value42:SetUIScale(p33)
	end
})
v200.Keybind(v200, {
	Title = "Show or Hide Interface",
	Desc = "Choose the key used to show or hide the interface.",
	Value = "RightControl",
	Callback = function(p34)
		local ok4, result = pcall(function()
			return Enum.KeyCode[p34]
		end)

		if not (ok4 and result) then
			return
		end

		value42:Toggle()
	end
})

local v203 = t1.value39(t1.value38.Misc, "Saved Settings", "save")
local v204 = v203.Paragraph(v203, {
	Title = "Automatic Saving",
	Desc = "Supported dropdowns and sliders save changes automatically and restore them the next time you join."
})
local v205 = v203:Group()
local t18 = {
	Title = "Save Settings Now",
	Desc = "Store your current settings.",
	Icon = "save",
	Callback = function()
		if not value42.CurrentConfig then
			return
		end

		if pcall(function()
			value42.CurrentConfig:Save()
		end) then
			t2.value4:Notify({
				Title = "Saved Settings",
				Content = "Settings saved!",
				Icon = "check",
				Duration = 2
			})

			local function v207()
				v204:SetDesc("Last saved just now.")
			end

			pcall(v207)

			return
		end

		t2.value4:Notify({
			Title = "Saved Settings",
			Content = "Couldn\'t save settings.",
			Icon = "x",
			Duration = 3
		})
	end
}

v205.Button(v205, t18)
v205.Button(v205, {
	Title = "Load Saved Settings",
	Desc = "Restore your previously saved settings.",
	Icon = "upload",
	Callback = function()
		if not value42.CurrentConfig then
			return
		end

		local function v208()
			value42.CurrentConfig:Load()
		end

		if pcall(v208) then
			t2.value4:Notify({
				Title = "Saved Settings",
				Content = "Settings loaded!",
				Icon = "check",
				Duration = 2
			})

			return
		end

		t2.value4:Notify({
			Title = "Saved Settings",
			Content = "No saved settings found.",
			Icon = "x",
			Duration = 3
		})
	end
})

local function rochessUnload()
	if _G.ROCHESS_Unloaded == value42 then
		return
	end

	_G.ROCHESS_Unloaded = value42
	value32.autoPlay = false
	value32.autoQueue = false

	local function v210()
		value42:Destroy()
	end

	pcall(v210)
	_G.ROCHESS_Unload = nil
end

_G.ROCHESS_Unload = rochessUnload
t1.value39(t1.value38.Misc, "Script Controls", "power"):Button({
	Title = "Close Cyber Hub",
	Desc = "Closes the interface and stops its background tasks.",
	Icon = "x",
	Callback = rochessUnload
})
t1.value38.Misc:Paragraph({
	Title = "Cyber Hub",
	Desc = "Interface settings and controls"
})

local Folder = value42.Folder

if Folder then
	Folder = value42.ConfigManager
end

if not Folder then
	t2.value4:Notify({
		Title = "Cyber Hub",
		Content = "Patched for the latest game update.",
		Icon = "check",
		Duration = 4
	})

	return
end

value42.ConfigManager:CreateConfig("default", true)
t2.value4:Notify({
	Title = "Cyber Hub",
	Content = "Patched for the latest game update.",
	Icon = "check",
	Duration = 4
})
