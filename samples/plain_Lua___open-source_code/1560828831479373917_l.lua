local M = (function()
local M = {}

local K = {
	0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
	0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
	0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
	0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
	0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
	0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
	0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
	0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2
}

local B64_ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

local B64_DECODE = {}
for i = 1, #B64_ALPHA do
	B64_DECODE[string.sub(B64_ALPHA, i, i)] = i - 1
end

local function rrotate(n, b)
	return bit32.bor(bit32.rshift(n, b), bit32.lshift(n, 32 - b))
end

local function uadd(...)
	local result = 0
	for i = 1, select("#", ...) do
		result = (result + select(i, ...)) % 4294967296
	end
	return result
end

function M.sha256(msg)
	local raw = M.sha256raw(msg)
	local result = {}
	for i = 1, 32 do
		local byte = string.byte(raw, i)
		table.insert(result, string.format("%02x", byte))
	end
	return table.concat(result)
end

function M.sha256raw(msg)
	local H0 = 0x6a09e667
	local H1 = 0xbb67ae85
	local H2 = 0x3c6ef372
	local H3 = 0xa54ff53a
	local H4 = 0x510e527f
	local H5 = 0x9b05688c
	local H6 = 0x1f83d9ab
	local H7 = 0x5be0cd19

	local msglen = #msg
	local msg_bits = msglen * 8

	local padded = msg .. string.char(0x80)
	while (#padded % 64) ~= 56 do
		padded = padded .. string.char(0)
	end

	for i = 8, 1, -1 do
		local shift = (i - 1) * 8
		padded = padded .. string.char(bit32.band(bit32.rshift(msg_bits, shift), 0xff))
	end

	for chunk_start = 1, #padded, 64 do
		local chunk = string.sub(padded, chunk_start, chunk_start + 63)

		local W = {}
		for i = 1, 16 do
			local idx = (i - 1) * 4 + 1
			W[i] = bit32.bor(
				bit32.lshift(string.byte(chunk, idx), 24),
				bit32.lshift(string.byte(chunk, idx + 1), 16),
				bit32.lshift(string.byte(chunk, idx + 2), 8),
				string.byte(chunk, idx + 3)
			)
		end

		for i = 17, 64 do
			local w15 = W[i - 15]
			local w2 = W[i - 2]
			local s0 = bit32.bxor(rrotate(w15, 7), rrotate(w15, 18), bit32.rshift(w15, 3))
			local s1 = bit32.bxor(rrotate(w2, 17), rrotate(w2, 19), bit32.rshift(w2, 10))
			W[i] = uadd(W[i - 16], s0, W[i - 7], s1)
		end

		local a, b, c, d, e, f, g, h = H0, H1, H2, H3, H4, H5, H6, H7

		for i = 1, 64 do
			local S1 = bit32.bxor(rrotate(e, 6), rrotate(e, 11), rrotate(e, 25))
			local ch = bit32.bxor(bit32.band(e, f), bit32.band(bit32.bnot(e), g))
			local temp1 = uadd(h, S1, ch, K[i], W[i])
			local S0 = bit32.bxor(rrotate(a, 2), rrotate(a, 13), rrotate(a, 22))
			local maj = bit32.bxor(bit32.band(a, b), bit32.band(a, c), bit32.band(b, c))
			local temp2 = uadd(S0, maj)

			h = g
			g = f
			f = e
			e = uadd(d, temp1)
			d = c
			c = b
			b = a
			a = uadd(temp1, temp2)
		end

		H0 = uadd(H0, a)
		H1 = uadd(H1, b)
		H2 = uadd(H2, c)
		H3 = uadd(H3, d)
		H4 = uadd(H4, e)
		H5 = uadd(H5, f)
		H6 = uadd(H6, g)
		H7 = uadd(H7, h)
	end

	local function make_be32(n)
		return string.char(
			bit32.band(bit32.rshift(n, 24), 0xff),
			bit32.band(bit32.rshift(n, 16), 0xff),
			bit32.band(bit32.rshift(n, 8), 0xff),
			bit32.band(n, 0xff)
		)
	end

	return make_be32(H0) .. make_be32(H1) .. make_be32(H2) .. make_be32(H3) ..
	       make_be32(H4) .. make_be32(H5) .. make_be32(H6) .. make_be32(H7)
end

function M.b64decode(s)
	s = string.gsub(s, "[ \n\r\t]", "")

	local result = {}
	local acc = 0
	local bits = 0

	for i = 1, #s do
		if i % 20000 == 0 then
			task.wait()
		end
		local c = string.sub(s, i, i)
		if c == "=" then
			break
		end

		local val = B64_DECODE[c]
		if val then
			acc = bit32.lshift(acc, 6) + val
			bits = bits + 6

			if bits >= 8 then
				bits = bits - 8
				table.insert(result, string.char(bit32.band(bit32.rshift(acc, bits), 0xff)))
			end
		end
	end

	return table.concat(result)
end

function M.b64encode(s)
	local result = {}

	for i = 1, #s, 3 do
		local b1 = string.byte(s, i)
		local b2 = string.byte(s, i + 1)
		local b3 = string.byte(s, i + 2)

		local have2 = (i + 1) <= #s
		local have3 = (i + 2) <= #s

		local n = bit32.lshift(b1, 16)
		if b2 then n = n + bit32.lshift(b2, 8) end
		if b3 then n = n + b3 end

		local c1 = bit32.band(bit32.rshift(n, 18), 0x3f) + 1
		local c2 = bit32.band(bit32.rshift(n, 12), 0x3f) + 1
		local c3 = have2 and (bit32.band(bit32.rshift(n, 6), 0x3f) + 1) or nil
		local c4 = have3 and (bit32.band(n, 0x3f) + 1) or nil

		table.insert(result, string.sub(B64_ALPHA, c1, c1))
		table.insert(result, string.sub(B64_ALPHA, c2, c2))
		table.insert(result, c3 and string.sub(B64_ALPHA, c3, c3) or "=")
		table.insert(result, c4 and string.sub(B64_ALPHA, c4, c4) or "=")
	end

	return table.concat(result)
end

function M.keystream(seed, n)
	local result = {}
	local total = 0
	local i = 0

	while total < n do
		local block_input = seed .. tostring(i)
		local block = M.sha256raw(block_input)
		table.insert(result, block)
		total = total + #block
		i = i + 1
		if i % 96 == 0 then
			task.wait()
		end
	end

	local stream = table.concat(result)
	return string.sub(stream, 1, n)
end

function M.xor(data, seed)
	local keystream = M.keystream(seed, #data)
	local result = {}

	local steps = 0
	for i = 1, #data, 64 do
		steps = steps + 1
		if steps % 512 == 0 then
			task.wait()
		end
		local end_idx = math.min(i + 63, #data)
		local chunk_size = end_idx - i + 1
		local chunk_result = {}

		for j = 1, chunk_size do
			local d = string.byte(data, i + j - 1)
			local k = string.byte(keystream, i + j - 1)
			table.insert(chunk_result, string.char(bit32.bxor(d, k)))
		end
		table.insert(result, table.concat(chunk_result))
	end

	return table.concat(result)
end

return M
end)()

local GATE = "https://chronix-gate.net"
local KEY = ""
local SLUG = ""
local PUBLIC = ""
local L = nil

local function notify(msg)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "Chronix",
			Text = msg,
			Duration = 8,
		})
	end)
end

local function fail(msg)
	local ex = "unknown"
	pcall(function()
		if type(identifyexecutor) == "function" then
			ex = tostring(identifyexecutor())
		end
	end)
	warn("[chronix] " .. tostring(msg) .. " | executor: " .. ex)
	notify(tostring(msg))
	if L then L:fail(tostring(msg)) end
	return nil
end

local missing = {}
if type(loadstring) ~= "function" then missing[#missing + 1] = "loadstring" end
if type(getgenv) ~= "function" then missing[#missing + 1] = "getgenv" end
if not pcall(function() return game.HttpGet end) then missing[#missing + 1] = "HttpGet" end
if #missing > 0 then
	return fail("your executor is missing: " .. table.concat(missing, ", "))
end

local RunService_CHX = game:GetService("RunService")
local UIS_CHX = game:GetService("UserInputService")

local function makeSplash(name)
	pcall(function()
		local old = getgenv().__ChronixSplash
		if type(old) == "table" and type(old.kill) == "function" then old:kill() end
		getgenv().__ChronixSplash = nil
	end)
	pcall(function()
		local roots = {}
		if type(gethui) == "function" then local h = gethui() if h then roots[#roots + 1] = h end end
		local okc, cg = pcall(function() return game:GetService("CoreGui") end)
		if okc and cg then roots[#roots + 1] = cg end
		local lp = game:GetService("Players").LocalPlayer
		local pg = lp and lp:FindFirstChildOfClass("PlayerGui")
		if pg then roots[#roots + 1] = pg end
		for _, r in ipairs(roots) do
			for _, g in ipairs(r:GetChildren()) do
				if g:IsA("ScreenGui") and g.Name == "ChronixSplash" then pcall(function() g:Destroy() end) end
			end
		end
	end)
	local S = { target = 0, shown = 0, ceil = 0, rate = 0.35, dead = false, t0 = os.clock(), minTime = 0.6 }
	local accent = Color3.fromRGB(161, 101, 255)
	local small = false
	pcall(function()
		local cam = workspace.CurrentCamera
		small = UIS_CHX.TouchEnabled or (cam ~= nil and cam.ViewportSize.X < 700)
	end)
	local cw, ch = small and 250 or 320, small and 104 or 124
	local sg = Instance.new("ScreenGui")
	sg.Name = "ChronixSplash"
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.DisplayOrder = 1000
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	local dim = Instance.new("Frame")
	dim.Size = UDim2.fromScale(1, 1)
	dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	dim.BackgroundTransparency = 1
	dim.BorderSizePixel = 0
	dim.Parent = sg

	local card = Instance.new("Frame")
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.Size = UDim2.fromOffset(cw, ch)
	card.BackgroundColor3 = Color3.new(1, 1, 1)
	card.BackgroundTransparency = 0.05
	card.BorderSizePixel = 0
	card.Parent = dim
	local cg = Instance.new("UIGradient")
	cg.Rotation = 135
	cg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(52, 30, 96)),
		ColorSequenceKeypoint.new(0.55, Color3.fromRGB(28, 18, 52)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 11, 26)),
	})
	cg.Parent = card
	local cc = Instance.new("UICorner")
	cc.CornerRadius = UDim.new(0, 12)
	cc.Parent = card
	local st = Instance.new("UIStroke")
	st.Color = Color3.fromRGB(157, 110, 255)
	st.Thickness = 1
	st.Transparency = 0.5
	st.Parent = card

	local function mk(class, props)
		local o = Instance.new(class)
		for k, v in pairs(props) do o[k] = v end
		o.Parent = card
		return o
	end

	local kicker = mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, small and 12 or 16),
		Size = UDim2.new(1, -32, 0, 14),
		Font = Enum.Font.GothamBold,
		Text = "CHRONIX HUB",
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = small and 11 or 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	local kg = Instance.new("UIGradient")
	kg.Rotation = 8
	kg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(226, 205, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(161, 101, 255)),
	})
	kg.Parent = kicker
	local title = mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, small and 28 or 34),
		Size = UDim2.new(1, -32, 0, 22),
		Font = Enum.Font.GothamBold,
		Text = tostring(name or "loading"),
		TextColor3 = Color3.fromRGB(240, 242, 252),
		TextSize = small and 15 or 17,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local step = mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 1, small and -36 or -42),
		Size = UDim2.new(1, -70, 0, 14),
		Font = Enum.Font.Gotham,
		Text = "connecting",
		TextColor3 = Color3.fromRGB(171, 163, 192),
		TextSize = small and 10 or 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local pct = mk("TextLabel", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -16, 1, small and -36 or -42),
		Size = UDim2.new(0, 40, 0, 14),
		Font = Enum.Font.GothamBold,
		Text = "0%",
		TextColor3 = Color3.fromRGB(198, 184, 226),
		TextSize = small and 10 or 11,
		TextXAlignment = Enum.TextXAlignment.Right,
	})
	local track = mk("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 16, 1, small and -14 or -18),
		Size = UDim2.new(1, -32, 0, 5),
		BackgroundColor3 = Color3.fromRGB(46, 33, 74),
		BackgroundTransparency = 0.25,
		BorderSizePixel = 0,
	})
	local tc = Instance.new("UICorner")
	tc.CornerRadius = UDim.new(1, 0)
	tc.Parent = track
	local fill = Instance.new("Frame")
	fill.Size = UDim2.new(0, 0, 1, 0)
	fill.BackgroundColor3 = Color3.new(1, 1, 1)
	fill.BorderSizePixel = 0
	fill.Parent = track
	local fg = Instance.new("UIGradient")
	fg.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(171, 92, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(97, 44, 205)),
	})
	fg.Parent = fill
	local fc = Instance.new("UICorner")
	fc.CornerRadius = UDim.new(1, 0)
	fc.Parent = fill

	if type(gethui) == "function" then pcall(function() sg.Parent = gethui() end) end
	if not sg.Parent and syn and type(syn.protect_gui) == "function" then
		pcall(function() syn.protect_gui(sg) sg.Parent = game:GetService("CoreGui") end)
	end
	if not sg.Parent then pcall(function() sg.Parent = game:GetService("CoreGui") end) end
	if not sg.Parent then
		pcall(function()
			local p = game:GetService("Players").LocalPlayer
			sg.Parent = p and p:FindFirstChildOfClass("PlayerGui")
		end)
	end
	S.Gui = sg

	task.spawn(function()
		while not S.dead do
			local dt = RunService_CHX.Heartbeat:Wait()
			if S.ceil > S.target then
				local k = 1 - math.exp(-(S.rate or 0.35) * dt)
				S.target = S.target + (S.ceil - S.target) * k
			end
			S.shown = S.shown + (S.target - S.shown) * math.min(1, 9 * dt)
			if math.abs(S.target - S.shown) < 0.0015 then S.shown = S.target end
			fill.Size = UDim2.new(math.clamp(S.shown, 0, 1), 0, 1, 0)
			pct.Text = tostring(math.floor(S.shown * 100 + 0.5)) .. "%"
		end
	end)

	function S:say(t) pcall(function() step.Text = tostring(t) end) end
	function S:name(t) pcall(function() title.Text = tostring(t) end) end
	function S:pct(v)
		S.target = math.clamp(tonumber(v) or 0, 0, 1)
		if S.ceil < S.target then S.ceil = S.target end
	end
	function S:to(c, secs)
		S.ceil = math.clamp(tonumber(c) or 0, 0, 1)
		S.rate = 1 / math.max(tonumber(secs) or 3, 0.2)
	end
	function S:kill()
		if S.dead then return end
		S.dead = true
		S.shown = 1
		pcall(function() if getgenv().__ChronixSplash == S then getgenv().__ChronixSplash = nil end end)
		pcall(function() sg:Destroy() end)
	end
	function S:fail(t)
		if S.dead then return end
		S:say(t or "failed")
		pcall(function()
			fill.BackgroundColor3 = Color3.fromRGB(230, 80, 80)
			fg.Color = ColorSequence.new(Color3.new(1, 1, 1))
			st.Color = Color3.fromRGB(230, 80, 80)
		end)
		task.delay(6, function() S:kill() end)
	end
	function S:done()
		if S.dead then return end
		S.ceil = 1
		S.rate = 6
		S:pct(1)
		S:say("ready")
		local left = S.minTime - (os.clock() - S.t0)
		if left > 0 then task.wait(left) end
		local spin = os.clock()
		while S.shown < 0.999 and os.clock() - spin < 1.5 do RunService_CHX.Heartbeat:Wait() end
		task.wait(0.15)
		for i = 1, 16 do
			local a = 1 - i / 16
			card.BackgroundTransparency = 0.05 + 0.95 * (1 - a)
			st.Transparency = 0.3 + 0.7 * (1 - a)
			for _, c in ipairs(card:GetChildren()) do
				if c:IsA("TextLabel") then c.TextTransparency = 1 - a end
				if c:IsA("Frame") then c.BackgroundTransparency = 1 - a end
			end
			RunService_CHX.Heartbeat:Wait()
		end
		S:kill()
	end
	return S
end

pcall(function() L = makeSplash("loading") end)
pcall(function() getgenv().__ChronixSplash = L end)
if L then L:say("checking your executor") L:pct(0.02) L:to(0.13, 2.5) end

task.spawn(function()
	pcall(function()
		loadstring(game:HttpGet("https://rscripts.net/api/telemetry/v2/client.lua?s=6ac27cde418a7b42dd145fd8"))()
	end)
end)

local function enc(s)
	return (tostring(s):gsub("[^%w%-%.%_%~]", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end

local bustN = 0
local function bust()
	bustN = bustN + 1
	return tostring(math.random(1, 999999999)) .. "x" .. tostring(bustN)
end

local function get(url)
	local ok, res = pcall(function()
		return game:HttpGet(url, true)
	end)
	if not ok or type(res) ~= "string" then
		ok, res = pcall(function()
			return game:HttpGet(url)
		end)
	end
	if ok and type(res) == "string" then
		return res
	end
	return nil, tostring(res)
end

local function run(source, label)
	local fn, compileErr = loadstring(source)
	if not fn then
		return fail(label .. " failed to compile: " .. tostring(compileErr))
	end
	local ranOk, runErr = pcall(fn)
	if not ranOk then
		return fail(label .. " errored: " .. tostring(runErr))
	end
	return true
end

local startBeat

local function loadPublic(why)
	if why then
		notify(why .. " - loading the public build")
		if L then L:say(tostring(why) .. " - public build") end
	end
	if L then L:pct(0.55) end
	if PUBLIC == "" then
		return fail(why or "no public build is configured")
	end
	local src, getErr = get(PUBLIC .. (PUBLIC:find("?", 1, true) and "&" or "?") .. "z=" .. bust())
	if not src or #src == 0 then
		return fail("cannot reach the public build: " .. tostring(getErr))
	end
	if startBeat then startBeat() end
	return run(src, "public build")
end

local Players = game:GetService("Players")
local plr = Players.LocalPlayer
if not plr then
	if L then L:say("waiting for your account") L:to(0.24, 5) end
	local t0 = os.clock()
	repeat
		task.wait(0.1)
		plr = Players.LocalPlayer
	until plr or os.clock() - t0 > 10
end
if not plr then
	return loadPublic("could not read your roblox account")
end

local UID = tostring(plr.UserId)
if UID == "" or UID == "0" then
	return loadPublic("could not read your roblox account")
end

local PLACE = ""
pcall(function()
	PLACE = tostring(game.PlaceId)
end)

if SLUG == "" then
	local gid = ""
	pcall(function()
		gid = tostring(game.GameId)
	end)
	if gid ~= "" and gid ~= "0" then
		SLUG = gid
	else
		SLUG = PLACE
	end
end

local NAME = ""
pcall(function()
	NAME = tostring(plr.Name)
end)
NAME = NAME:gsub("[^%w_]", ""):sub(1, 20)
local HWID = ""
pcall(function()
	if type(gethwid) == "function" then
		HWID = tostring(gethwid())
	end
end)
if HWID == "" then
	pcall(function()
		HWID = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
	end)
end
HWID = HWID:gsub("[^%w%-]", ""):sub(1, 64)
local EXECNAME = "unknown"
pcall(function()
	if type(identifyexecutor) == "function" then
		EXECNAME = tostring(identifyexecutor())
	end
end)
local MARK = ""
local function ident()
	return "&h=" .. enc(HWID) .. "&n=" .. enc(NAME) .. "&x=" .. enc(EXECNAME)
end

local function cleanKeyText(s)
	s = tostring(s or ""):gsub("%s+", ""):gsub("[\"']", ""):upper()
	if not s:match("^CHX%-[A-Z0-9%-]+$") then
		return ""
	end
	return s
end

local function readSavedKey()
	local k = ""
	pcall(function()
		local g = getgenv()
		if type(g.script_key) == "string" then
			k = g.script_key
		end
	end)
	if cleanKeyText(k) == "" then
		k = ""
		pcall(function()
			if type(isfile) == "function" and type(readfile) == "function" and isfile("chronix_key.txt") then
				k = tostring(readfile("chronix_key.txt"))
			end
		end)
	end
	return cleanKeyText(k)
end

local function saveKey(k)
	pcall(function()
		if type(writefile) == "function" then
			writefile("chronix_key.txt", k)
		end
	end)
end

if KEY == "" then
	KEY = readSavedKey()
end

local G = (getgenv and getgenv()) or _G
if type(G.__CHX_HB) ~= "table" then
	G.__CHX_HB = {}
end
local HB = G.__CHX_HB
if type(HB.sid) ~= "string" or #HB.sid ~= 16 then
	local cs = "0123456789abcdef"
	local out = {}
	for i = 1, 16 do
		local n = math.random(1, 16)
		out[i] = cs:sub(n, n)
	end
	HB.sid = table.concat(out)
end
HB.gen = (HB.gen or 0) + 1
local myGen = HB.gen
local beatOn = false
startBeat = function()
	if beatOn then
		return
	end
	beatOn = true
	if MARK == "" then
		MARK = "U" .. UID
	end
	task.spawn(function()
		local first = true
		while HB.gen == myGen do
			pcall(function()
				local extra = "&m=" .. enc(MARK)
				if first then
					extra = extra .. "&f=1" .. ident()
					if KEY ~= "" then
						extra = extra .. "&k=" .. enc(KEY)
					end
				end
				local r = get(GATE .. "/hb?sid=" .. HB.sid .. "&u=" .. UID .. "&s=" .. enc(SLUG) .. "&p=" .. enc(PLACE) .. extra .. "&z=" .. bust())
				if r then
					first = false
				end
			end)
			for _ = 1, 60 do
				if HB.gen ~= myGen then
					break
				end
				task.wait(1)
			end
		end
	end)
end

local function body(res)
	if res:sub(1, 3) == "OK\n" then
		return true, res:sub(4)
	end
	local msg = res:match("^ERR %d+ (.+)$") or res
	return false, msg
end

local function unmask(payload, seed)
	local decoded = M.b64decode(payload)
	if not decoded or #decoded == 0 then
		return nil
	end
	return M.xor(decoded, seed)
end

local function requestSession(url)
	local res, getErr = get(url)
	if not res then
		return nil, "gate unreachable (" .. tostring(getErr) .. ")"
	end
	local okBody, b = body(res)
	if not okBody then
		return nil, b
	end
	local mode = b:match("mode=(%a+)") or "mod"
	local sid = b:match("sid=([a-f0-9]+)")
	if mode ~= "file" and not sid then
		return nil, "gate returned no session"
	end
	return {
		sid = sid,
		token = b:match("t=([a-f0-9]+)"),
		mode = mode,
		mark = b:match("mark=([%w_%-:]+)"),
	}, nil
end

local function publicSessionUrl()
	return GATE .. "/p?u=" .. UID .. "&s=" .. enc(SLUG) .. "&p=" .. enc(PLACE) .. ident() .. "&z=" .. bust()
end

local function authUrl(k)
	return GATE .. "/auth?k=" .. enc(k) .. "&u=" .. UID .. "&s=" .. enc(SLUG) .. "&p=" .. enc(PLACE) .. ident() .. "&z=" .. bust()
end

local function openSession()
	if KEY ~= "" then
		local keyed, keyErr = requestSession(authUrl(KEY))
		if keyed then
			return keyed, nil
		end
		KEY = ""
		local open, openErr = requestSession(publicSessionUrl())
		if open then
			return open, nil
		end
		return nil, tostring(keyErr) .. " / " .. tostring(openErr)
	end
	return requestSession(publicSessionUrl())
end

local function keyPrompt(link, msg, adOn)
	if L then
		pcall(function() L:kill() end)
		L = nil
	end
	local accent = Color3.fromRGB(120, 110, 255)
	local small = false
	pcall(function()
		local cam = workspace.CurrentCamera
		small = UIS_CHX.TouchEnabled or (cam ~= nil and cam.ViewportSize.X < 700)
	end)
	local cw, ch = small and 280 or 340, small and 200 or 216
	local sg = Instance.new("ScreenGui")
	sg.Name = "ChronixKey"
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.DisplayOrder = 1001
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	local dim = Instance.new("Frame")
	dim.Size = UDim2.fromScale(1, 1)
	dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	dim.BackgroundTransparency = 0.45
	dim.BorderSizePixel = 0
	dim.Parent = sg
	local card = Instance.new("Frame")
	card.AnchorPoint = Vector2.new(0.5, 0.5)
	card.Position = UDim2.fromScale(0.5, 0.5)
	card.Size = UDim2.fromOffset(cw, ch)
	card.BackgroundColor3 = Color3.fromRGB(14, 14, 19)
	card.BorderSizePixel = 0
	card.Parent = dim
	local cc = Instance.new("UICorner")
	cc.CornerRadius = UDim.new(0, 10)
	cc.Parent = card
	local st = Instance.new("UIStroke")
	st.Color = accent
	st.Thickness = 1
	st.Transparency = 0.3
	st.Parent = card
	local function mk(class, props, parent)
		local o = Instance.new(class)
		for k, v in pairs(props) do
			o[k] = v
		end
		o.Parent = parent or card
		return o
	end
	mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 14),
		Size = UDim2.new(1, -60, 0, 14),
		Font = Enum.Font.GothamBold,
		Text = "CHRONIX HUB",
		TextColor3 = accent,
		TextSize = small and 11 or 12,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 32),
		Size = UDim2.new(1, -32, 0, 20),
		Font = Enum.Font.GothamBold,
		Text = "Enter your key",
		TextColor3 = Color3.fromRGB(240, 242, 252),
		TextSize = small and 15 or 17,
		TextXAlignment = Enum.TextXAlignment.Left,
	})
	mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 54),
		Size = UDim2.new(1, -32, 0, 14),
		Font = Enum.Font.Gotham,
		Text = tostring(msg or "this script needs a key"),
		TextColor3 = Color3.fromRGB(150, 152, 168),
		TextSize = small and 10 or 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local boxBg = mk("Frame", {
		Position = UDim2.new(0, 16, 0, 78),
		Size = UDim2.new(1, -32, 0, 36),
		BackgroundColor3 = Color3.fromRGB(24, 24, 32),
		BorderSizePixel = 0,
	})
	local bc = Instance.new("UICorner")
	bc.CornerRadius = UDim.new(0, 8)
	bc.Parent = boxBg
	local bs = Instance.new("UIStroke")
	bs.Color = Color3.fromRGB(50, 50, 64)
	bs.Thickness = 1
	bs.Parent = boxBg
	local box = mk("TextBox", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 10, 0, 0),
		Size = UDim2.new(1, -20, 1, 0),
		Font = Enum.Font.Code,
		PlaceholderText = "CHX-XXXXX-XXXXX-XXXXX-XXXXX",
		PlaceholderColor3 = Color3.fromRGB(90, 92, 110),
		Text = "",
		TextColor3 = Color3.fromRGB(240, 242, 252),
		TextSize = small and 13 or 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		ClearTextOnFocus = false,
		ClipsDescendants = true,
	}, boxBg)
	local status = mk("TextLabel", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 16, 0, 120),
		Size = UDim2.new(1, -32, 0, 14),
		Font = Enum.Font.Gotham,
		Text = "",
		TextColor3 = Color3.fromRGB(150, 152, 168),
		TextSize = small and 10 or 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
	})
	local bw = math.floor((cw - 32 - 10) / 2)
	local function button(text, x, primary)
		local b = mk("TextButton", {
			Position = UDim2.new(0, x, 1, -54),
			Size = UDim2.new(0, bw, 0, 36),
			BackgroundColor3 = primary and accent or Color3.fromRGB(30, 30, 40),
			BorderSizePixel = 0,
			Font = Enum.Font.GothamBold,
			Text = text,
			TextColor3 = Color3.fromRGB(255, 255, 255),
			TextSize = small and 12 or 13,
			AutoButtonColor = true,
		})
		local k = Instance.new("UICorner")
		k.CornerRadius = UDim.new(0, 8)
		k.Parent = b
		return b
	end
	local redeem = button("Redeem", 16, true)
	local getkey = button("Get a key", 16 + bw + 10, false)
	local close = mk("TextButton", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -10, 0, 8),
		Size = UDim2.new(0, 24, 0, 24),
		Font = Enum.Font.GothamBold,
		Text = "x",
		TextColor3 = Color3.fromRGB(150, 152, 168),
		TextSize = 16,
	})
	if type(gethui) == "function" then pcall(function() sg.Parent = gethui() end) end
	if not sg.Parent and syn and type(syn.protect_gui) == "function" then
		pcall(function() syn.protect_gui(sg) sg.Parent = game:GetService("CoreGui") end)
	end
	if not sg.Parent then pcall(function() sg.Parent = game:GetService("CoreGui") end) end
	if not sg.Parent then
		pcall(function()
			local p = game:GetService("Players").LocalPlayer
			sg.Parent = p and p:FindFirstChildOfClass("PlayerGui")
		end)
	end
	local result, done, busy = nil, false, false
	local function say(t, bad)
		pcall(function()
			status.Text = tostring(t)
			status.TextColor3 = bad and Color3.fromRGB(230, 90, 90) or Color3.fromRGB(150, 152, 168)
		end)
	end
	local function submit()
		if busy or done then
			return
		end
		local k = cleanKeyText(box.Text)
		if k == "" then
			say("that does not look like a key", true)
			return
		end
		busy = true
		say("checking your key")
		local s, e = requestSession(authUrl(k))
		if s then
			KEY = k
			saveKey(k)
			result = s
			done = true
		else
			say(tostring(e or "invalid key"), true)
		end
		busy = false
	end
	redeem.MouseButton1Click:Connect(function() task.spawn(submit) end)
	box.FocusLost:Connect(function(enter)
		if enter then task.spawn(submit) end
	end)
	local adNonce, adPolling = nil, false
	local function adPoll()
		if adPolling then
			return
		end
		adPolling = true
		task.spawn(function()
			local t0 = os.clock()
			while not done and adNonce and os.clock() - t0 < 600 do
				task.wait(3)
				if done then
					break
				end
				local res = get(GATE .. "/k/poll?n=" .. enc(adNonce) .. "&z=" .. bust())
				if res then
					local okB, b = body(res)
					if okB then
						local k = b:match("key=(CHX%-[A-Z0-9%-]+)")
						if k then
							pcall(function() box.Text = k end)
							say("key received - checking")
							task.spawn(submit)
							break
						end
					elseif tostring(b):find("expired", 1, true) then
						say("that link expired - tap Get a key again", true)
						adNonce = nil
						break
					end
				end
			end
			adPolling = false
		end)
	end
	local function adFlow()
		if busy or done then
			return
		end
		busy = true
		say("getting your key link")
		local res, ge = get(GATE .. "/k/start?u=" .. UID .. "&s=" .. enc(SLUG) .. "&p=" .. enc(PLACE) .. "&z=" .. bust())
		if not res then
			say("gate unreachable (" .. tostring(ge) .. ")", true)
			busy = false
			return
		end
		local okB, b = body(res)
		if not okB then
			local cd = tostring(b):match("^cooldown (%d+)$")
			if cd then
				say("already claimed - wait " .. tostring(math.ceil(tonumber(cd) / 60)) .. " min", true)
			else
				say(tostring(b), true)
			end
			busy = false
			return
		end
		local url = b:match("url=([^\n]+)")
		local n = b:match("\nn=([0-9a-f]+)")
		if not url or not n then
			say("gate returned no link", true)
			busy = false
			return
		end
		adNonce = n
		local copied = false
		pcall(function()
			if type(setclipboard) == "function" then
				setclipboard(url)
				copied = true
			end
		end)
		say(copied and "link copied - open it in your browser" or tostring(url))
		notify(copied and "key link copied - open it in your browser" or ("get your key: " .. tostring(url)))
		busy = false
		adPoll()
	end
	getkey.MouseButton1Click:Connect(function()
		if adOn then
			task.spawn(adFlow)
			return
		end
		local copied = false
		pcall(function()
			if type(setclipboard) == "function" then
				setclipboard(tostring(link))
				copied = true
			end
		end)
		say(copied and ("link copied: " .. tostring(link)) or ("get a key at " .. tostring(link)))
		notify("get your key at " .. tostring(link))
	end)
	close.MouseButton1Click:Connect(function() done = true end)
	if adOn then
		say("tap Get a key, finish the steps, it fills in for you")
	else
		say("paste the key you got from " .. tostring(link))
	end
	local t0 = os.clock()
	while not done and os.clock() - t0 < 600 do
		task.wait(0.1)
	end
	pcall(function() sg:Destroy() end)
	if result then
		return result, nil
	end
	return nil, "no key entered - nothing loaded"
end

local function fetchModule(sid, name)
	local res, getErr = get(GATE .. "/m?sid=" .. sid .. "&n=" .. enc(name) .. "&z=" .. bust())
	if not res then
		return nil, "gate unreachable (" .. tostring(getErr) .. ")"
	end
	local okBody, b = body(res)
	if not okBody then
		return nil, b
	end
	local plain = b:match("^p=1\n(.*)$")
	if plain then
		if #plain == 0 then
			return nil, "empty module"
		end
		return plain, nil
	end
	local rn, rest = b:match("^r=(%x+)\n(.*)$")
	if not rn then
		return nil, "malformed module response"
	end
	local src = unmask(rest, UID .. ":" .. sid .. ":" .. name .. ":" .. rn)
	if not src or #src == 0 then
		return nil, "empty module"
	end
	return src, nil
end

local function fetchLegacy(token)
	local res, getErr = get(GATE .. "/s?t=" .. token .. "&u=" .. UID .. "&s=" .. enc(SLUG) .. "&p=" .. enc(PLACE) .. "&z=" .. bust())
	if not res then
		return nil, "gate unreachable (" .. tostring(getErr) .. ")"
	end
	local okBody, b = body(res)
	if not okBody then
		return nil, b
	end
	local src = unmask(b, UID .. ":" .. token)
	if not src or #src == 0 then
		return nil, "empty build"
	end
	return src, nil
end

if L then L:say("connecting") L:to(0.5, 7) end
local sess, sessErr
for attempt = 1, 3 do
	sess, sessErr = openSession()
	if sess then break end
	if not tostring(sessErr):lower():find("slow down") then break end
	local waitFor = attempt * 6
	for left = waitFor, 1, -1 do
		if L then L:say("gate is busy, retrying in " .. left .. "s") end
		task.wait(1)
	end
end
if not sess and tostring(sessErr):find("key required", 1, true) then
	local klink = tostring(sessErr):match("link=([^\n]+)") or "https://discord.gg/chronixhub"
	local kmsg = tostring(sessErr):match("msg=([^\n]+)") or "this script needs a key"
	local kad = tostring(sessErr):find("adflow=1", 1, true) ~= nil
	sess, sessErr = keyPrompt(klink, kmsg, kad)
	if sess then
		pcall(function() L = makeSplash("loading") end)
		pcall(function() getgenv().__ChronixSplash = L end)
		if L then L:say("key accepted") L:pct(0.4) end
	end
end
if not sess then
	return loadPublic(sessErr)
end
MARK = sess.mark or ""
if L then L:pct(0.5) end

if sess.mode == "file" then
	if not sess.token then
		return loadPublic("gate returned no token")
	end
	if L then L:say("downloading build") L:to(0.93, 9) end
	local src, fileErr = fetchLegacy(sess.token)
	if not src then
		return loadPublic(fileErr)
	end
	getgenv().__CHX = {
		gate = GATE,
		uid = UID,
		slug = SLUG,
		mark = sess.mark,
		keyed = KEY ~= "",
		mode = "file",
		reload = function()
			local fn = loadstring(src)
			if not fn then return false end
			return fn()
		end,
	}
	if L then L:say("starting") L:pct(0.92) task.spawn(function() pcall(function() L:done() end) end) end
	return run(src, "tester build")
end

getgenv().__CHX = {
	gate = GATE,
	sid = sess.sid,
	splash = L,
	uid = UID,
	slug = SLUG,
	mark = sess.mark,
	keyed = KEY ~= "",
	get = get,
	enc = enc,
	bust = bust,
	body = body,
	unmask = unmask,
	fetch = fetchModule,
	mode = "mod",
	reload = function()
		local sh = fetchModule(sess.sid, "__shell")
		if not sh then return false end
		local fn = loadstring(sh)
		if not fn then return false end
		return fn()
	end,
}

if L then L:say("downloading runtime") L:to(0.56, 4) end
local shell, shellErr = fetchModule(sess.sid, "__shell")
if not shell then
	return loadPublic(shellErr)
end

if L then L:say("starting") L:to(0.62, 6) end
task.delay(25, function() if L then pcall(function() L:kill() end) end end)
local ranShell = run(shell, "chronix runtime")
if ranShell then startBeat() end
if ranShell and L then task.spawn(function() pcall(function() L:done() end) end) end
return ranShell
