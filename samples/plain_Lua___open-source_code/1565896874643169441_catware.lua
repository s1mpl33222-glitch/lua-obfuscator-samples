-- Catware - Turbo Soccer (place 101880234193261). Obsidian UI, port of Catware - Blox League.
-- Turbo Soccer runs its own RocketSim-style sim (ReplicatedStorage.Shared.Sim, uu, 120Hz, same axis/sign
-- conventions as RocketSim). Matches go through Net.Prediction:step(controls) (server-authoritative, inputs
-- only); training/tutorial/free play runs a local single-car Sim.World. Both are hooked at their step.
-- Run: loadstring(game:HttpGet("https://gitlab.com/azulacs/catware-turbo-soccer/-/raw/main/catware.lua"))()
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LP = game:GetService("Players").LocalPlayer

if getgenv().CatwareTurboSoccerUnload then pcall(getgenv().CatwareTurboSoccerUnload) end

local Shared = RS:WaitForChild("Shared")
local Client = LP:WaitForChild("PlayerScripts"):WaitForChild("Client")
local Sim = Shared:WaitForChild("Sim")
local World = require(Sim:WaitForChild("World"))
local BallPrediction = require(Sim:WaitForChild("BallPrediction"))
local Prediction = require(Shared:WaitForChild("Net"):WaitForChild("Prediction"))
local Protocol = require(Shared.Net:WaitForChild("Protocol"))
local Units = require(Client:WaitForChild("Units"))
local Motion = require(Client:WaitForChild("Motion")) -- atMenu(): title screen (the menu backdrop is a live World)

local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options, Toggles = Library.Options, Library.Toggles

---------------------------------------------------------------- live sim
-- live = { cars = {{car, team, index}}, ball, pads, tick, me = entry } of whichever sim stepped last
local live
local lastMatchAt = -1
local TICK = 1 / 120
local path = {} -- predicted ball {pos, t} every PATH_STRIDE ticks
local PATH_STRIDE = 4
local ballPred = BallPrediction.new()

local function fromMatch(P)
	local m = P.match
	local cars = {}
	for _, e in m.cars do
		if not e.vacant then table.insert(cars, e) end
	end
	return { cars = cars, ball = m.ball, pads = m.pads and m.pads.pads or {}, tick = m.tick, me = P.localIndex and m.cars[P.localIndex] }
end
local function fromWorld(w)
	local me = { car = w.car, team = 0, index = 1 }
	return { cars = { me }, ball = w.ball, pads = w.pads and w.pads.pads or {}, tick = w.tick, me = me }
end

-- Blox League-style read-only view of a car, so the control code below ports verbatim
local function stateOf(car)
	local b = car.body
	return {
		pos = b.pos, vel = b.vel, angVel = b.angVel, rot = { forward = b.fwd, right = b.right, up = b.up },
		boost = car.boost, isOnGround = car.isOnGround, isFlipping = car.isFlipping,
		hasFlipped = car.hasFlipped, hasDoubleJumped = car.hasDoubleJumped, isDemoed = car.isDemoed,
	}
end

local function predictBall(seconds)
	table.clear(path)
	if not live then return end
	ballPred:run(live.ball, seconds, PATH_STRIDE)
	for i = 2, #ballPred.points do
		table.insert(path, { pos = ballPred.points[i], t = ballPred.times[i] })
	end
end

---------------------------------------------------------------- control helpers (signs from Sim.Car)
-- steer/yaw + turns toward rot.right, pitch + = nose up, roll + tilts up toward rot.right
-- rates: pitch = -w·right, yaw = w·up, roll = -w·forward
local UP = vector.create(0, 0, 1)
local function clamp1(x) return math.clamp(x, -1, 1) end
local function flat(v) return vector.create(v.x, v.y, 0) end
local function angleTo(rot, dir)
	return math.atan2(vector.dot(dir, rot.right), vector.dot(dir, rot.forward))
end

local function now() return (live and live.tick or 0) * TICK end

local function orient(c, st, f)
	local rot, w = st.rot, st.angVel
	local eRoll = math.atan2(vector.dot(UP, rot.right), vector.dot(UP, rot.up))
	local ePitch = math.atan2(vector.dot(f, rot.up), vector.dot(f, rot.forward))
	local eYaw = math.atan2(vector.dot(f, rot.right), vector.dot(f, rot.forward))
	c.roll = clamp1(3 * eRoll + 0.6 * vector.dot(w, rot.forward))
	c.pitch = clamp1(3.5 * ePitch + 0.8 * vector.dot(w, rot.right))
	c.yaw = clamp1(3.5 * eYaw - 0.8 * vector.dot(w, rot.up))
end
local function recover(c, st, heading)
	local h = heading or flat(st.rot.forward)
	if vector.magnitude(h) < 1 then h = vector.create(0, 1, 0) end
	orient(c, st, vector.normalize(h))
end

local dodge -- {t0, pitch, yaw}
local function startDodge(st, target)
	if dodge or not st.isOnGround then return end
	local a = angleTo(st.rot, flat(target - st.pos))
	local p, y = -math.cos(a), math.sin(a)
	local m = math.max(math.abs(p), math.abs(y))
	dodge = { t0 = now(), pitch = p / m, yaw = y / m }
end
local function runDodge(c)
	if not dodge then return false end
	local dt = now() - dodge.t0
	if dt > 0.9 or dt < 0 then dodge = nil return false end
	c.pitch, c.yaw, c.roll = 0, 0, 0
	if dt < 0.08 then
		c.jump = true
	elseif dt < 0.13 then
		c.jump = false
	elseif dt < 0.2 then
		c.jump, c.pitch, c.yaw = true, dodge.pitch, dodge.yaw
	else
		c.jump, c.pitch, c.yaw = false, dodge.pitch, dodge.yaw
	end
	return true
end

local function nearBall(st, within)
	local b = path[math.max(1, math.floor(0.15 / (PATH_STRIDE * TICK)))]
	if not b or st.rot.up.z < 0.7 then return nil end
	local d = b.pos - (st.pos + st.vel * 0.15)
	if b.pos.z > 220 or math.abs(d.z) > 200 then return nil end
	local fwd, side = vector.dot(d, st.rot.forward), vector.dot(d, st.rot.right)
	if vector.magnitude(flat(d)) < within and fwd > -40 and math.abs(side) < 130 then return b.pos end
end

---------------------------------------------------------------- Nexto (neural bot)
-- Nexto by Rolv-Arild & co (github.com/Rolv-Arild/Necto, CC BY-NC-SA 4.0), Luau port shared with Blox League.
local NX
local REPO = "https://gitlab.com/azulacs/catware-blox-league/-/raw/main/"
local DIR = "Catware/TurboSoccer/"
-- bump when nexto.lua or its weights change on the repo: caches without this stamp re-download once
local NEXTO_VERSION = "2"
local STAMP = DIR .. "nexto.version"
local fresh = isfile(STAMP) and readfile(STAMP) == NEXTO_VERSION
local function source(name)
	if fresh and isfile(DIR .. name) then return readfile(DIR .. name) end
	local src = game:HttpGet(REPO .. name)
	pcall(function()
		if not isfolder("Catware") then makefolder("Catware") end
		if not isfolder(DIR) then makefolder(DIR) end
		writefile(DIR .. name, src)
	end)
	return src
end
local nxOk, nxErr = pcall(function()
	NX = loadstring(source("nexto.lua"))().load(loadstring(source("nexto_weights.lua"))())
	if not fresh then pcall(writefile, STAMP, NEXTO_VERSION) end -- only once both loaded fine
end)
if not nxOk then warn("[Catware] Nexto failed to load:", nxErr) end
local nx = { action = {0,0,0,0,0,0,0,0}, nextTick = 0, job = nil, kick = -1, lastGround = {}, spent = 0, deadline = 0 }

-- nexto.lua speaks the Blox League arena API; wrap the live sim in it
local function nxArena()
	local cars, me = {}, nil
	for _, e in live.cars do
		local w = { team = e.team, id = e.index, GetState = function() return stateOf(e.car) end }
		table.insert(cars, w)
		if e == live.me then me = w end
	end
	local ball = live.ball.body
	return {
		cars = cars, boostPads = live.pads,
		ball = { GetState = function() return { pos = ball.pos, vel = ball.vel, angVel = ball.angVel } end },
	}, me
end

local function kickoffTaker(arena, me)
	local ball = arena.ball:GetState().pos
	local function d(car) return vector.magnitude(flat(car:GetState().pos - ball)) end
	local mine, minD = d(me), math.huge
	for _, car in arena.cars do minD = math.min(minD, d(car)) end
	if math.abs(minD - mine) > 10 then return false end
	local mx = me:GetState().pos.x
	for _, car in arena.cars do
		if car ~= me and car.team == me.team and math.abs(d(car) - mine) <= 10 then
			local ox = car:GetState().pos.x
			local isLeft = me.team == 0 and ox < mx or me.team == 1 and ox > mx
			if not isLeft then return false end
		end
	end
	return true
end

-- seconds of inference per frame: the game can run several ticks in one frame when catching up,
-- so the budget is shared by all of them (nx.spent resets on RenderStepped)
local NX_BUDGET = 0.004
if NX then
	NX.step = function()
		if os.clock() > nx.deadline then coroutine.yield() end
	end
end
local function nextoControls(c, st)
	if not NX then error("Nexto isn't loaded (see the earlier warning)") end
	local tick = live.tick
	local arena, me
	if nx.pads ~= live.pads then nx.pads, nx.padMap = live.pads, nil end -- new sim, re-match pads
	if not nx.job and tick >= nx.nextTick then
		nx.nextTick = tick + 8
		arena, me = nxArena()
		local q, kv = NX.buildObs(arena, me, tick, nx)
		nx.job = coroutine.create(function() return NX:forward(q, kv) end)
	end
	if nx.job and nx.spent < NX_BUDGET then
		local t0 = os.clock()
		nx.deadline = t0 + NX_BUDGET - nx.spent
		local ok, best = coroutine.resume(nx.job)
		nx.spent += os.clock() - t0
		if not ok then nx.job = nil error(best) end
		if coroutine.status(nx.job) == "dead" then
			nx.job = nil
			nx.action = NX.ACTIONS[best]
			nx.lastBest = best
		end
	end
	local a = nx.action
	local ball = live.ball.body
	local kickoffPause = ball.pos.x == 0 and ball.pos.y == 0 and vector.magnitude(ball.vel) == 0
	if kickoffPause then
		local speed = vector.magnitude(st.vel)
		if speed < 5 then nx.kickArmed = true end
		if nx.kickTick == nil then
			if not arena then arena, me = nxArena() end
			nx.kick = kickoffTaker(arena, me) and 0 or -2
			if nx.kickArmed and speed > 5 then nx.kickTick = nx.kick == 0 and tick or false end
		end
		if nx.kick >= 0 then
			if nx.kickTick then nx.kick = tick - nx.kickTick end
			if NX.KICKOFF[nx.kick + 1] then a = NX.KICKOFF[nx.kick + 1] nx.action = a end
		end
	else
		nx.kick, nx.kickTick, nx.kickArmed = -1, nil, false
	end
	c.throttle, c.steer, c.pitch, c.yaw, c.roll = a[1], a[2], a[3], a[4], a[5]
	c.jump, c.boost, c.handbrake = a[6] > 0, a[7] > 0, a[8] > 0
end

---------------------------------------------------------------- step hooks
-- c: the controls about to be simulated for our car this tick
local function drive(c)
	local me = live.me
	if not me or Library.Unloaded then return end
	local st = stateOf(me.car)
	if Toggles.NextoBot.Value then
		local ok, err = pcall(nextoControls, c, st)
		if not ok then nx.job = nil warn("[Catware] nexto:", err) end
		return
	end
	if Toggles.AutoFlip.Value and st.isOnGround and not dodge then
		local b = nearBall(st, Options.FlipRange.Value)
		if b then startDodge(st, b) end
	end
	local idleAir = math.abs(c.pitch) + math.abs(c.yaw) + math.abs(c.roll) < 0.1
	if Toggles.AutoRecover.Value and idleAir and not st.isOnGround and not st.isFlipping and not dodge then
		local v = flat(st.vel)
		recover(c, st, vector.magnitude(v) > 300 and v or nil)
	end
	runDodge(c)
end

local origPStep, origWStep = Prediction.step, World.step
Prediction.step = function(self, controls, ...)
	lastMatchAt = os.clock()
	live = fromMatch(self)
	-- only while the ball is live: goal replays, countdowns and the end screen keep stepping too
	if controls and self.match.phase == "play" then
		drive(controls)
		Protocol.quantize(controls) -- same rounding the game applies before step, so server and history agree
	end
	return origPStep(self, controls, ...)
end
World.step = function(self, ...)
	-- the menu/training world can keep ticking during a match; the match wins
	if os.clock() - lastMatchAt > 0.25 then
		if Motion.atMenu() then
			live = nil
		else
			live = fromWorld(self)
			drive(self.car.controls)
		end
	end
	return origWStep(self, ...)
end

---------------------------------------------------------------- visuals (Drawing)
local cam = workspace.CurrentCamera
local lines, texts = {}, {}
local landing = Drawing.new("Circle")
landing.Thickness, landing.NumSides, landing.Filled = 2, 24, false

local function line(i)
	local l = lines[i]
	if not l then l = Drawing.new("Line") l.Thickness = 2 lines[i] = l end
	return l
end
local function text(i)
	local t = texts[i]
	if not t then t = Drawing.new("Text") t.Size, t.Center, t.Outline = 16, true, true texts[i] = t end
	return t
end
local function screen(uu)
	local v, on = cam:WorldToViewportPoint(Units.pos(uu))
	return Vector2.new(v.X, v.Y), on
end

local function draw()
	local n = 0
	landing.Visible = false
	if Toggles.BallPath.Value and #path > 1 then
		local col = Options.PathColor.Value
		local prev, prevOn = screen(live.ball.body.pos)
		for _, pt in path do
			local s, on = screen(pt.pos)
			if on and prevOn then
				n += 1
				local l = line(n)
				l.From, l.To, l.Color, l.Visible = prev, s, col, true
			end
			prev, prevOn = s, on
		end
		for _, pt in path do
			if pt.pos.z < 110 then
				local s, on = screen(pt.pos)
				if on then
					landing.Position, landing.Radius, landing.Color, landing.Visible = s, 12, col, true
				end
				break
			end
		end
	end
	for i = n + 1, #lines do lines[i].Visible = false end

	local m = 0
	local me = live and live.me
	if Toggles.BoostESP.Value and live then
		for _, e in live.cars do
			if e ~= me and not e.car.isDemoed then
				local s, on = screen(e.car.body.pos + vector.create(0, 0, 90))
				if on then
					m += 1
					local t = text(m)
					t.Text = string.format("%d", math.floor(e.car.boost))
					t.Color = (me and e.team == me.team) and Color3.fromRGB(90, 170, 255) or Color3.fromRGB(255, 110, 60)
					t.Position, t.Visible = s, true
				end
			end
		end
	end
	for i = m + 1, #texts do texts[i].Visible = false end
end

local conn = RunService.RenderStepped:Connect(function()
	local ok, err = pcall(function()
		local want = Toggles.BallPath.Value or Toggles.AutoFlip.Value
		if want then predictBall(Options.PathSeconds.Value) else table.clear(path) end
		draw()
	end)
	nx.spent = 0
	if not ok then warn("[Catware]", err) end
end)

---------------------------------------------------------------- UI
local hasExecutor, executorName = pcall(identifyexecutor)
local Window = Library:CreateWindow({ Title = "Catware", Footer = "Turbo Soccer | " .. (hasExecutor and executorName or "Unknown"), Icon = "cat", NotifySide = "Right", ShowCustomCursor = false })
local Tabs = {
	Main = Window:AddTab("Main", "car"),
	Visuals = Window:AddTab("Visuals", "eye"),
	["UI Settings"] = Window:AddTab("UI Settings", "settings"),
}

local Bot = Tabs.Main:AddLeftGroupbox("Bot", "bot")
Bot:AddToggle("NextoBot", { Text = "Nexto (neural bot)", Default = false, Risky = true, Tooltip = "Nexto by Rolv-Arild et al., CC BY-NC-SA 4.0." })
	:AddKeyPicker("NextoBotKey", { Default = "N", SyncToggleState = true, Mode = "Toggle", Text = "Nexto" })

local Assist = Tabs.Main:AddRightGroupbox("Assists", "hand-helping")
Assist:AddToggle("AutoFlip", { Text = "Auto flip into ball", Default = false, Tooltip = "Front/diagonal dodge when the ball is about to reach you" })
Assist:AddSlider("FlipRange", { Text = "Flip range (uu)", Default = 240, Min = 150, Max = 450, Rounding = 0 })
Assist:AddToggle("AutoRecover", { Text = "Auto air recovery", Default = false, Tooltip = "Lands you on wheels when you're not touching air controls" })

local Vis = Tabs.Visuals:AddLeftGroupbox("Ball", "circle")
Vis:AddToggle("BallPath", { Text = "Ball prediction path", Default = true })
	:AddColorPicker("PathColor", { Default = Color3.fromRGB(255, 220, 60) })
Vis:AddSlider("PathSeconds", { Text = "Prediction seconds", Default = 2, Min = 1, Max = 6, Rounding = 1 })
Tabs.Visuals:AddRightGroupbox("Cars", "car"):AddToggle("BoostESP", { Text = "Boost amount over cars", Default = true })

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Menu", "wrench")
-- queue ourselves on teleport (server hops, private servers, tournaments) so Catware comes along
local AUTOLOAD_FLAG = DIR .. "autoload"
local LOADER = 'if not game:IsLoaded() then game.Loaded:Wait() end local p = "' .. DIR .. 'catware.lua" '
	.. 'loadstring(isfile(p) and readfile(p) or game:HttpGet("https://gitlab.com/azulacs/catware-turbo-soccer/-/raw/main/catware.lua"))()'
MenuGroup:AddToggle("AutoLoad", { Text = "Auto-load after teleport", Default = isfile(AUTOLOAD_FLAG),
	Tooltip = "Re-runs Catware when you teleport to another Turbo Soccer server" })
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })
MenuGroup:AddButton("Unload", function() Library:Unload() end)
Library.ToggleKeybind = Options.MenuKeybind

Toggles.AutoLoad:OnChanged(function(on)
	if on then
		if not isfolder("Catware") then makefolder("Catware") end
		if not isfolder(DIR) then makefolder(DIR) end
		writefile(AUTOLOAD_FLAG, "1")
	elseif isfile(AUTOLOAD_FLAG) then
		delfile(AUTOLOAD_FLAG)
	end
end)
local queued = false
local teleportConn = LP.OnTeleport:Connect(function(state)
	if state == Enum.TeleportState.Started and Toggles.AutoLoad.Value and not queued then
		queued = true -- Started can fire again on retries; queue once
		queue_on_teleport(LOADER)
	end
end)

getgenv().CatwareTurboSoccerUnload = function() Library:Unload() end
Library:OnUnload(function()
	getgenv().CatwareTurboSoccerUnload = nil
	teleportConn:Disconnect()
	conn:Disconnect()
	Prediction.step, World.step = origPStep, origWStep
	for _, d in lines do d:Remove() end
	for _, d in texts do d:Remove() end
	landing:Remove()
end)

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind", "AutoLoad" }) -- AutoLoad lives in its own flag file
ThemeManager:SetFolder("Catware/TurboSoccer")
SaveManager:SetFolder("Catware/TurboSoccer")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:SetDefaultTheme(ThemeManager.BuiltInThemes["Catppuccin"][2])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig()
