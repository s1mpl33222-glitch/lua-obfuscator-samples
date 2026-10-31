-- apex hub | the strongest battlegrounds
-- RightShift hides the menu, ctrl+click teleports

local plrs = game:GetService("Players")
local rs = game:GetService("RunService")
local uis = game:GetService("UserInputService")
local lighting = game:GetService("Lighting")
local vim = game:GetService("VirtualInputManager")
local tps = game:GetService("TeleportService")
local http = game:GetService("HttpService")
local vu = game:GetService("VirtualUser")
local core = game:GetService("CoreGui")
local sg = game:GetService("StarterGui")
local lp = plrs.LocalPlayer

local cfg = {
	speed = 40, jump = 70, fly = 80, fov = 90, grav = 120, clock = 14,
	espRange = 0, aimFov = 300, aimSmooth = 30,
	blockRange = 12, dashRange = 8, m1Range = 7, spamDelay = 0.2,
	orbitRadius = 8, orbitSpeed = 3, hitbox = 8, alarm = 40,
	version = "1.0.0",
	url = "https://raw.githubusercontent.com/worldcupi3/apex-hub/refs/heads/main/apex_strongest_battlegrounds.lua",
	discord = "https://discord.gg/9KkKHQZdHF",
	file = "apex_tsb.json",
}
local nums = { "speed", "jump", "fly", "fov", "grav", "clock", "espRange", "aimFov", "aimSmooth",
	"blockRange", "dashRange", "m1Range", "orbitRadius", "orbitSpeed", "hitbox", "alarm" }

local conns = {}
local function bind(sig, fn)
	conns[#conns + 1] = sig:Connect(fn)
end

local function note(t)
	pcall(sg.SetCore, sg, "SendNotification", { Title = "Apex Hub", Text = t, Duration = 3 })
end

local function root()
	local c = lp.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function hum()
	local c = lp.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

-- everyone else that is alive and loaded
local function others()
	local out = {}
	for _, p in ipairs(plrs:GetPlayers()) do
		if p ~= lp and p.Character then
			local r = p.Character:FindFirstChild("HumanoidRootPart")
			local h = p.Character:FindFirstChildOfClass("Humanoid")
			if r and h and h.Health > 0 then
				out[#out + 1] = { p = p, r = r, h = h }
			end
		end
	end
	return out
end

local function nearest()
	local me = root()
	if not me then return end
	local best, bd
	for _, o in ipairs(others()) do
		local d = (o.r.Position - me.Position).Magnitude
		if not bd or d < bd then best, bd = o, d end
	end
	return best, bd
end

local function lowest()
	local best
	for _, o in ipairs(others()) do
		if not best or o.h.Health < best.h.Health then best = o end
	end
	return best
end

-- feature registry
local F, order = {}, {}
local function feat(key, name, up, down)
	local f = { name = name, on = false, up = up, down = down }
	F[key] = f
	order[#order + 1] = f
	return f
end

local function set(f, v)
	if f.on == v then return end
	f.on = v
	local fn = v and f.up or f.down
	if fn then
		local ok, err = pcall(fn)
		if not ok then warn("[apex] " .. f.name .. ": " .. tostring(err)) end
	end
	if f.refresh then f.refresh() end
end

-- state
local gui
local saved, lastSafe
local flyBV, flyBG
local orig = { grav = workspace.Gravity, zoom = lp.CameraMaxZoomDistance }
local esp, lines = {}, {}
local ragHum
local keys, binding = {}, nil
local last = { block = 0, dash = 0, m1 = 0, spam = 0 }
local aimMode = "Crosshair"
local specIdx = 0
local hitSizes = setmetatable({}, { __mode = "k" })
local alarmCd = {}
local rec, recording, recStart = {}, false, 0
local hud
local fullOrig, fogOrig, speedOrig, jumpOrig, clockOrig

local drawing = Drawing ~= nil

-- movement
local function stopFly()
	if flyBV then flyBV:Destroy() flyBV = nil end
	if flyBG then flyBG:Destroy() flyBG = nil end
	local h = hum()
	if h then h.PlatformStand = false end
end

local function startFly()
	local r, h = root(), hum()
	if not r then return end
	flyBV = Instance.new("BodyVelocity")
	flyBV.MaxForce = Vector3.one * 1e9
	flyBV.Velocity = Vector3.zero
	flyBV.Parent = r
	flyBG = Instance.new("BodyGyro")
	flyBG.MaxTorque = Vector3.one * 1e9
	flyBG.P = 1e4
	flyBG.CFrame = r.CFrame
	flyBG.Parent = r
	if h then h.PlatformStand = true end
end

feat("speed", "Speed Boost", function() local h = hum() speedOrig = h and h.WalkSpeed end,
	function() local h = hum() if h and speedOrig then h.WalkSpeed = speedOrig end end)
feat("jump", "Jump Boost", function() local h = hum() if h then jumpOrig = { h.JumpPower, h.UseJumpPower } end end,
	function() local h = hum() if h and jumpOrig then h.UseJumpPower = jumpOrig[2] h.JumpPower = jumpOrig[1] end end)
feat("infjump", "Infinite Jump")
feat("fly", "Fly", startFly, stopFly)
feat("noclip", "Noclip")
feat("clicktp", "Click Teleport")
feat("antivoid", "Anti-Void")
feat("antiragdoll", "Anti-Ragdoll", nil, function()
	local h = hum()
	if h then
		h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
		h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
	end
	ragHum = nil
end)
feat("bhop", "Bunny Hop")
feat("grav", "Gravity Changer", nil, function() workspace.Gravity = orig.grav end)

bind(uis.JumpRequest, function()
	if F.infjump.on then
		local h = hum()
		if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
	end
end)

-- visuals
local function clearEsp(p)
	local e = esp[p]
	if e then
		for _, i in ipairs(e.items) do pcall(i.Destroy, i) end
		esp[p] = nil
	end
end

local function label(adornee)
	local g = Instance.new("BillboardGui")
	g.Adornee = adornee
	g.AlwaysOnTop = true
	g.Size = UDim2.fromOffset(180, 28)
	g.StudsOffset = Vector3.new(0, 3, 0)
	local t = Instance.new("TextLabel", g)
	t.Size = UDim2.fromScale(1, 1)
	t.BackgroundTransparency = 1
	t.TextColor3 = Color3.new(1, 1, 1)
	t.TextStrokeTransparency = 0
	t.Font = Enum.Font.GothamBold
	t.TextSize = 13
	g.Parent = adornee
	return g, t
end

local function updateEsp()
	local me = root()
	local low = lowest()
	local seen = {}
	for _, o in ipairs(others()) do
		local head = o.p.Character:FindFirstChild("Head")
		local d = me and (o.r.Position - me.Position).Magnitude or 0
		if head and (cfg.espRange == 0 or d <= cfg.espRange) then
			seen[o.p] = true
			local e = esp[o.p]
			if not e or e.char ~= o.p.Character then
				clearEsp(o.p)
				local hl = Instance.new("Highlight")
				hl.Adornee = o.p.Character
				hl.FillTransparency = 0.5
				hl.OutlineColor = Color3.new(1, 1, 1)
				hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				hl.Parent = o.p.Character
				local g, t = label(head)
				e = { char = o.p.Character, items = { hl, g }, hl = hl, txt = t }
				esp[o.p] = e
			end
			local isLow = F.lowhp.on and low and low.p == o.p
			e.hl.FillColor = isLow and Color3.fromRGB(255, 160, 0) or Color3.fromRGB(255, 70, 70)
			e.txt.Text = ("%s [%d] %d hp"):format(o.p.DisplayName, math.floor(d), math.floor(o.h.Health))
		end
	end
	for p in pairs(esp) do
		if not seen[p] then clearEsp(p) end
	end
end

local function clearLines()
	for p, l in pairs(lines) do
		pcall(function() l:Remove() end)
		lines[p] = nil
	end
end

feat("esp", "Player ESP", nil, function() for p in pairs(esp) do clearEsp(p) end end)
feat("lowhp", "Highlight Lowest HP")
feat("tracers", "Tracers", function()
	if not drawing then note("Tracers need the Drawing API") end
end, clearLines)
feat("fullbright", "Fullbright", function()
	fullOrig = { Brightness = lighting.Brightness, ClockTime = lighting.ClockTime, FogEnd = lighting.FogEnd,
		GlobalShadows = lighting.GlobalShadows, Ambient = lighting.Ambient }
	lighting.Brightness = 2
	lighting.ClockTime = 14
	lighting.FogEnd = 1e6
	lighting.GlobalShadows = false
	lighting.Ambient = Color3.fromRGB(180, 180, 180)
end, function()
	if fullOrig then for k, v in pairs(fullOrig) do lighting[k] = v end end
end)
feat("nofog", "Remove Fog", function()
	fogOrig = { lighting.FogStart, lighting.FogEnd, {} }
	lighting.FogStart = 0
	lighting.FogEnd = 1e6
	for _, a in ipairs(lighting:GetChildren()) do
		if a:IsA("Atmosphere") then fogOrig[3][a] = a.Density a.Density = 0 end
	end
end, function()
	if fogOrig then
		lighting.FogStart, lighting.FogEnd = fogOrig[1], fogOrig[2]
		for a, d in pairs(fogOrig[3]) do if a.Parent then a.Density = d end end
	end
end)
feat("fovchg", "FOV Changer")
feat("timelock", "Time of Day Lock", function() clockOrig = lighting.ClockTime end,
	function() if clockOrig then lighting.ClockTime = clockOrig end end)
feat("zoom", "Max Zoom Out", function() lp.CameraMaxZoomDistance = 1000 end,
	function() lp.CameraMaxZoomDistance = orig.zoom end)
feat("hidetag", "Hide Name Tag", nil, function()
	local h = hum()
	if h then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer end
end)
feat("hud", "FPS / Ping Counter", function()
	hud = Instance.new("TextLabel")
	hud.Size = UDim2.fromOffset(170, 22)
	hud.Position = UDim2.new(1, -180, 0, 6)
	hud.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	hud.BackgroundTransparency = 0.3
	hud.BorderSizePixel = 0
	hud.TextColor3 = Color3.new(1, 1, 1)
	hud.Font = Enum.Font.GothamBold
	hud.TextSize = 13
	hud.Parent = gui
end, function()
	if hud then hud:Destroy() hud = nil end
end)

-- fighting
feat("aim", "Aim Assist (camera lock)")
feat("face", "Auto Face Target")
feat("follow", "Follow Nearest Player")
feat("orbit", "Orbit Target")
feat("hitbox", "Hitbox Expander", nil, function()
	for part, size in pairs(hitSizes) do
		if part.Parent then part.Size = size part.Transparency = 1 end
		hitSizes[part] = nil
	end
end)
feat("alarm", "Proximity Alarm")

-- key automation (you bind the game's keys)
local function tap(k)
	task.spawn(function()
		pcall(function()
			vim:SendKeyEvent(true, k, false, game)
			task.wait(0.05)
			vim:SendKeyEvent(false, k, false, game)
		end)
	end)
end

local function click()
	task.spawn(function()
		local v = workspace.CurrentCamera.ViewportSize
		pcall(function()
			vim:SendMouseButtonEvent(v.X / 2, v.Y / 2, 0, true, game, 0)
			task.wait(0.03)
			vim:SendMouseButtonEvent(v.X / 2, v.Y / 2, 0, false, game, 0)
		end)
	end)
end

feat("autoblock", "Auto Block", function() if not keys.block then note("Bind your block key first") end end)
feat("autodash", "Auto Dash", function() if not keys.dash then note("Bind your dash key first") end end)
feat("autom1", "Auto M1")
feat("spam", "Key Spam", function() if not keys.spam then note("Bind a spam key first") end end)

-- utility
feat("antiafk", "Anti-AFK")
bind(lp.Idled, function()
	if F.antiafk.on then
		vu:CaptureController()
		vu:ClickButton2(Vector2.new())
	end
end)

feat("autorejoin", "Auto Rejoin on Kick")
pcall(function()
	local ov = core:WaitForChild("RobloxPromptGui", 5):WaitForChild("promptOverlay", 5)
	bind(ov.ChildAdded, function(c)
		if F.autorejoin.on and c.Name == "ErrorPrompt" then
			task.wait(2)
			tps:Teleport(game.PlaceId, lp)
		end
	end)
end)

feat("joinalerts", "Join / Leave Alerts")
bind(plrs.PlayerAdded, function(p) if F.joinalerts.on then note(p.DisplayName .. " joined") end end)
bind(plrs.PlayerRemoving, function(p)
	clearEsp(p)
	if lines[p] then pcall(function() lines[p]:Remove() end) lines[p] = nil end
	if F.joinalerts.on then note(p.DisplayName .. " left") end
end)

-- main loop
local t1, t2, t3, t4, fpsT, frames = 0, 0, 0, 0, 0, 0
bind(rs.Heartbeat, function(dt)
	local h, r = hum(), root()
	if not h or not r then return end

	if F.speed.on then h.WalkSpeed = cfg.speed end
	if F.jump.on then h.UseJumpPower = true h.JumpPower = cfg.jump end
	if F.grav.on then workspace.Gravity = cfg.grav end
	if F.hidetag.on then h.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
	if F.timelock.on then lighting.ClockTime = cfg.clock end
	if F.bhop.on and h.FloorMaterial ~= Enum.Material.Air and h.MoveDirection.Magnitude > 0 then h.Jump = true end
	if F.antiragdoll.on and h ~= ragHum then
		h:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		h:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
		ragHum = h
	end

	local floor = workspace.FallenPartsDestroyHeight + 80
	if h.FloorMaterial ~= Enum.Material.Air and r.Position.Y > floor then
		lastSafe = r.CFrame
	elseif F.antivoid.on and r.Position.Y < floor and lastSafe then
		r.AssemblyLinearVelocity = Vector3.zero
		r.CFrame = lastSafe
	end

	if F.fly.on then
		if not flyBV or flyBV.Parent ~= r then stopFly() startFly() end
		if flyBV and flyBG then
			local cf = workspace.CurrentCamera.CFrame
			local d = Vector3.zero
			if uis:IsKeyDown(Enum.KeyCode.W) then d += cf.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.S) then d -= cf.LookVector end
			if uis:IsKeyDown(Enum.KeyCode.D) then d += cf.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.A) then d -= cf.RightVector end
			if uis:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.yAxis end
			if uis:IsKeyDown(Enum.KeyCode.LeftShift) then d -= Vector3.yAxis end
			flyBV.Velocity = d.Magnitude > 0 and d.Unit * cfg.fly or Vector3.zero
			flyBG.CFrame = cf
		end
	end

	-- things that need a target
	local t, dist = nearest()
	if t then
		local tp = t.r.Position
		if F.face.on then
			r.CFrame = CFrame.lookAt(r.Position, Vector3.new(tp.X, r.Position.Y, tp.Z))
		end
		if F.follow.on then h:MoveTo(tp) end
		if F.orbit.on then
			t4 += dt * cfg.orbitSpeed
			local pos = tp + Vector3.new(math.cos(t4) * cfg.orbitRadius, 0, math.sin(t4) * cfg.orbitRadius)
			r.CFrame = CFrame.lookAt(pos, Vector3.new(tp.X, pos.Y, tp.Z))
		end
	end

	t1 += dt
	if t1 >= 0.2 then
		t1 = 0
		if F.esp.on then updateEsp() end
	end

	t2 += dt
	if t2 >= 0.1 then
		t2 = 0
		local now = os.clock()
		if t then
			if F.autoblock.on and keys.block and dist <= cfg.blockRange and now - last.block > 0.4 then
				last.block = now
				tap(keys.block)
			end
			if F.autodash.on and keys.dash and dist <= cfg.dashRange and now - last.dash > 1.5 then
				last.dash = now
				tap(keys.dash)
			end
			if F.autom1.on and dist <= cfg.m1Range and now - last.m1 > 0.25 then
				last.m1 = now
				click()
			end
		end
		if F.spam.on and keys.spam and now - last.spam >= cfg.spamDelay then
			last.spam = now
			tap(keys.spam)
		end
		if F.alarm.on then
			for _, o in ipairs(others()) do
				if (o.r.Position - r.Position).Magnitude <= cfg.alarm and (alarmCd[o.p] or 0) + 8 < now then
					alarmCd[o.p] = now
					note(o.p.DisplayName .. " is close")
				end
			end
		end
	end

	t3 += dt
	if t3 >= 0.5 and F.hitbox.on then
		t3 = 0
		for _, o in ipairs(others()) do
			if not hitSizes[o.r] then hitSizes[o.r] = o.r.Size end
			o.r.Size = Vector3.one * cfg.hitbox
			o.r.Transparency = 0.8
			o.r.CanCollide = false
		end
	end
end)

bind(rs.Stepped, function()
	if F.noclip.on and lp.Character then
		for _, p in ipairs(lp.Character:GetDescendants()) do
			if p:IsA("BasePart") then p.CanCollide = false end
		end
	end
end)

bind(rs.RenderStepped, function(dt)
	local cam = workspace.CurrentCamera
	if F.fovchg.on and cam then cam.FieldOfView = cfg.fov end
	if hud then
		fpsT += dt
		frames += 1
		if fpsT >= 0.5 then
			hud.Text = ("FPS %d | Ping %dms"):format(math.floor(frames / fpsT), math.floor(lp:GetNetworkPing() * 1000))
			fpsT, frames = 0, 0
		end
	end
	if F.tracers.on and drawing and cam then
		local from = Vector2.new(cam.ViewportSize.X / 2, cam.ViewportSize.Y)
		for _, o in ipairs(others()) do
			local l = lines[o.p]
			if not l then
				l = Drawing.new("Line")
				l.Thickness = 1.5
				l.Color = Color3.fromRGB(255, 70, 70)
				lines[o.p] = l
			end
			local v, on = cam:WorldToViewportPoint(o.r.Position)
			l.From = from
			l.To = Vector2.new(v.X, v.Y)
			l.Visible = on
		end
	end
end)

-- aim runs after the game's camera script
rs:BindToRenderStep("ApexAim", Enum.RenderPriority.Camera.Value + 1, function()
	if not F.aim.on then return end
	local cam = workspace.CurrentCamera
	if not cam then return end
	local pos
	if aimMode == "Lowest HP" then
		local l = lowest()
		pos = l and l.r.Position
	else
		local center, bd = cam.ViewportSize / 2, nil
		for _, o in ipairs(others()) do
			local v, on = cam:WorldToViewportPoint(o.r.Position)
			if on then
				local d = (Vector2.new(v.X, v.Y) - center).Magnitude
				if d <= cfg.aimFov and (not bd or d < bd) then pos, bd = o.r.Position, d end
			end
		end
	end
	if pos then
		cam.CFrame = cam.CFrame:Lerp(CFrame.lookAt(cam.CFrame.Position, pos), math.clamp(cfg.aimSmooth / 100, 0.01, 1))
	end
end)

-- input
bind(uis.InputBegan, function(input, gp)
	if binding and input.UserInputType == Enum.UserInputType.Keyboard then
		keys[binding] = input.KeyCode
		note(binding .. " key set to " .. input.KeyCode.Name)
		binding = nil
		return
	end
	if recording and input.UserInputType == Enum.UserInputType.Keyboard and not gp then
		rec[#rec + 1] = { input.KeyCode, os.clock() - recStart }
	end
	if gp then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 and F.clicktp.on and uis:IsKeyDown(Enum.KeyCode.LeftControl) then
		local r = root()
		if r then r.CFrame = CFrame.new(lp:GetMouse().Hit.Position + Vector3.new(0, 4, 0)) end
	end
	local k = input.KeyCode
	if k == Enum.KeyCode.RightBracket then
		cfg.fly = math.clamp(cfg.fly + 10, 20, 300)
		note("Fly speed " .. cfg.fly)
	elseif k == Enum.KeyCode.LeftBracket then
		cfg.fly = math.clamp(cfg.fly - 10, 20, 300)
		note("Fly speed " .. cfg.fly)
	end
	local hk = { [Enum.KeyCode.F1] = F.esp, [Enum.KeyCode.F2] = F.speed, [Enum.KeyCode.F3] = F.fly,
		[Enum.KeyCode.F4] = F.noclip, [Enum.KeyCode.F5] = F.aim, [Enum.KeyCode.F6] = F.autoblock }
	if hk[k] then set(hk[k], not hk[k].on) end
end)

-- actions
local acts = {}
local function act(name, fn) acts[#acts + 1] = { name, fn } end

act("Teleport to Nearest Player", function()
	local r, t = root(), nearest()
	if r and t then r.CFrame = t.r.CFrame * CFrame.new(0, 0, 4) end
end)
act("Teleport Behind Nearest Player", function()
	local r, t = root(), nearest()
	if r and t then r.CFrame = t.r.CFrame * CFrame.new(0, 0, 3) end
end)
act("Teleport to Lowest HP Player", function()
	local r, t = root(), lowest()
	if r and t then r.CFrame = t.r.CFrame * CFrame.new(0, 0, 4) else note("No one found") end
end)
act("Cycle Aim Mode (Crosshair / Lowest HP)", function()
	aimMode = aimMode == "Crosshair" and "Lowest HP" or "Crosshair"
	note("Aim mode: " .. aimMode)
end)
act("Spectate Next Player", function()
	local list = others()
	if #list == 0 then note("No other players") return end
	specIdx = specIdx % #list + 1
	local ph = list[specIdx].p.Character:FindFirstChildOfClass("Humanoid")
	if ph then workspace.CurrentCamera.CameraSubject = ph note("Spectating " .. list[specIdx].p.DisplayName) end
end)
act("Stop Spectating", function()
	local h = hum()
	if h then workspace.CurrentCamera.CameraSubject = h end
end)
act("Save Position", function()
	local r = root()
	if r then saved = r.CFrame note("Position saved") end
end)
act("Return to Saved Position", function()
	local r = root()
	if r and saved then r.CFrame = saved else note("Nothing saved") end
end)
act("Bind Block Key", function() binding = "block" note("Press the key you use to block") end)
act("Bind Dash Key", function() binding = "dash" note("Press the key you use to dash") end)
act("Bind Spam Key", function() binding = "spam" note("Press the key you want spammed") end)
act("Record Combo", function()
	rec, recording, recStart = {}, true, os.clock()
	note("Recording, press your combo keys")
end)
act("Stop Recording", function()
	recording = false
	note(#rec .. " keys recorded")
end)
act("Play Combo", function()
	if #rec == 0 then note("Record a combo first") return end
	local copy = rec
	task.spawn(function()
		local t0 = os.clock()
		for _, step in ipairs(copy) do
			local wait = step[2] - (os.clock() - t0)
			if wait > 0 then task.wait(wait) end
			tap(step[1])
		end
	end)
end)
act("Rejoin Server", function() tps:TeleportToPlaceInstance(game.PlaceId, game.JobId, lp) end)
act("Server Hop (Low Population)", function()
	note("Looking for a server...")
	task.spawn(function()
		local ok, res = pcall(function()
			return http:JSONDecode(game:HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId)))
		end)
		if not ok or type(res) ~= "table" or type(res.data) ~= "table" then note("Server list failed") return end
		local best
		for _, s in ipairs(res.data) do
			if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
				if not best or s.playing < best.playing then best = s end
			end
		end
		if best then tps:TeleportToPlaceInstance(game.PlaceId, best.id, lp) else note("No other server found") end
	end)
end)
act("FPS Boost (one-way)", function()
	lighting.GlobalShadows = false
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	for _, i in ipairs(workspace:GetDescendants()) do
		if i:IsA("ParticleEmitter") or i:IsA("Trail") or i:IsA("Smoke") or i:IsA("Fire") then i.Enabled = false end
	end
	for _, i in ipairs(lighting:GetChildren()) do
		if i:IsA("BloomEffect") or i:IsA("BlurEffect") or i:IsA("SunRaysEffect") or i:IsA("DepthOfFieldEffect") then i.Enabled = false end
	end
	note("FPS boost applied")
end)

local steppers = {}

local function saveCfg()
	if typeof(writefile) ~= "function" then note("No writefile on this executor") return end
	local d = { nums = {}, tog = {} }
	for _, k in ipairs(nums) do d.nums[k] = cfg[k] end
	for _, f in ipairs(order) do d.tog[f.name] = f.on end
	writefile(cfg.file, http:JSONEncode(d))
	note("Config saved")
end

local function loadCfg(silent)
	if typeof(isfile) ~= "function" or typeof(readfile) ~= "function" or not isfile(cfg.file) then
		if not silent then note("No saved config") end
		return
	end
	local ok, d = pcall(function() return http:JSONDecode(readfile(cfg.file)) end)
	if not ok or type(d) ~= "table" then if not silent then note("Config is corrupted") end return end
	for k, v in pairs(d.nums or {}) do
		if type(v) == "number" and table.find(nums, k) then cfg[k] = v end
	end
	for _, r in ipairs(steppers) do r() end
	for _, f in ipairs(order) do
		if d.tog and d.tog[f.name] ~= nil then set(f, d.tog[f.name] == true) end
	end
	if not silent then note("Config loaded") end
end

local function checkUpdate(silent)
	task.spawn(function()
		local ok, src = pcall(game.HttpGet, game, cfg.url)
		if not ok or type(src) ~= "string" then
			if not silent then note("Update check failed") end
			return
		end
		local v = src:match('version = "([%d%.]+)"')
		if v and v ~= cfg.version then
			note("Update available: v" .. v .. " (you have v" .. cfg.version .. ")")
		elseif not silent then
			note("You're on the latest version")
		end
	end)
end

act("Save Config", saveCfg)
act("Load Config", function() loadCfg(false) end)
act("Check for Updates", function() checkUpdate(false) end)
act("Copy Discord Invite", function()
	if typeof(setclipboard) == "function" then setclipboard(cfg.discord) note("Invite copied") else note(cfg.discord) end
end)

act("Run Diagnostics", function()
	local out = {}
	local function add(s) out[#out + 1] = s end
	local function yn(v) return v and "yes" or "NO" end
	add("apex tsb v" .. cfg.version .. " diagnostics")
	add("VirtualInputManager: " .. yn(pcall(function() return vim.Name end)))
	add("Drawing: " .. yn(drawing) .. " | setclipboard: " .. yn(typeof(setclipboard) == "function"))
	add("keys: block=" .. (keys.block and keys.block.Name or "NO") .. " dash=" .. (keys.dash and keys.dash.Name or "NO") .. " spam=" .. (keys.spam and keys.spam.Name or "NO"))
	add("combo steps: " .. #rec)
	add("-- players --")
	for _, o in ipairs(others()) do
		add(("%s hp=%d dist=%d"):format(o.p.Name, math.floor(o.h.Health), math.floor((o.r.Position - (root() and root().Position or o.r.Position)).Magnitude)))
	end
	add("-- my humanoid --")
	local h = hum()
	add(h and ("walkspeed=%s jump=%s state=%s"):format(h.WalkSpeed, h.JumpPower, tostring(h:GetState())) or "no humanoid")
	local report = table.concat(out, "\n")
	print(report)
	if typeof(setclipboard) == "function" then setclipboard(report) note("Diagnostics copied (also in F9)") else note("Diagnostics in F9 console") end
end)

local function unload()
	for _, f in ipairs(order) do set(f, false) end
	clearLines()
	for p in pairs(esp) do clearEsp(p) end
	for _, c in ipairs(conns) do c:Disconnect() end
	table.clear(conns)
	pcall(function() rs:UnbindFromRenderStep("ApexAim") end)
	if gui then gui:Destroy() end
	note("Unloaded")
end
act("Unload Script", unload)

-- ui
gui = Instance.new("ScreenGui")
gui.Name = "ApexTSB"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
if not pcall(function() gui.Parent = (typeof(gethui) == "function" and gethui()) or core end) or not gui.Parent then
	gui.Parent = lp:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 430)
main.Position = UDim2.new(0, 20, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local accent = Color3.fromRGB(255, 170, 0)
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = accent
title.BorderSizePixel = 0
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.fromRGB(20, 20, 26)
title.Text = "Apex Hub | Strongest Battlegrounds"
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 8)

local scroll = Instance.new("ScrollingFrame")
scroll.Position = UDim2.fromOffset(0, 34)
scroll.Size = UDim2.new(1, 0, 1, -38)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.CanvasSize = UDim2.new()
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main
local lay = Instance.new("UIListLayout", scroll)
lay.SortOrder = Enum.SortOrder.LayoutOrder
lay.Padding = UDim.new(0, 4)
lay.HorizontalAlignment = Enum.HorizontalAlignment.Center

local ord = 0
local function nxt()
	ord += 1
	return ord
end

do
	local drag, ds, sp
	bind(title.InputBegan, function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			drag, ds, sp = true, i.Position, main.Position
		end
	end)
	bind(uis.InputChanged, function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - ds
			main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
	bind(uis.InputEnded, function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
	end)
end

local heads = {}
local function sec(text)
	local l = Instance.new("TextLabel")
	l.Size = UDim2.new(1, -16, 0, 20)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamBold
	l.TextSize = 12
	l.TextColor3 = accent
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.Text = text
	l.LayoutOrder = nxt()
	l.Parent = scroll
	heads[#heads + 1] = l
end

local function styleBtn(b, parent)
	b.Size = parent == scroll and UDim2.new(1, -16, 0, 26) or UDim2.new(1, 0, 0, 26)
	b.BorderSizePixel = 0
	b.Font = Enum.Font.Gotham
	b.TextSize = 13
	b.TextColor3 = Color3.new(1, 1, 1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 5)
	b.LayoutOrder = nxt()
	b.Parent = parent
end

local function btn(text, fn, color, parent)
	local b = Instance.new("TextButton")
	b.BackgroundColor3 = color or Color3.fromRGB(60, 60, 110)
	b.Text = text
	styleBtn(b, parent or scroll)
	bind(b.MouseButton1Click, fn)
	return b
end

local function tog(key)
	local f = F[key]
	local b = Instance.new("TextButton")
	styleBtn(b, scroll)
	f.refresh = function()
		b.Text = f.name .. ": " .. (f.on and "ON" or "OFF")
		b.BackgroundColor3 = f.on and Color3.fromRGB(40, 140, 70) or Color3.fromRGB(45, 45, 56)
	end
	f.refresh()
	bind(b.MouseButton1Click, function() set(f, not f.on) end)
end

local function step(text, key, inc, lo, hi)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -16, 0, 26)
	row.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
	row.BorderSizePixel = 0
	row.LayoutOrder = nxt()
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 5)
	row.Parent = scroll
	local l = Instance.new("TextLabel", row)
	l.Size = UDim2.new(1, -60, 1, 0)
	l.Position = UDim2.fromOffset(8, 0)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.Gotham
	l.TextSize = 13
	l.TextColor3 = Color3.new(1, 1, 1)
	l.TextXAlignment = Enum.TextXAlignment.Left
	local function refresh() l.Text = text .. ": " .. tostring(cfg[key]) end
	refresh()
	steppers[#steppers + 1] = refresh
	for i, d in ipairs({ -inc, inc }) do
		local b = Instance.new("TextButton", row)
		b.Size = UDim2.fromOffset(24, 20)
		b.Position = UDim2.new(1, i == 1 and -54 or -28, 0, 3)
		b.BackgroundColor3 = Color3.fromRGB(55, 55, 70)
		b.BorderSizePixel = 0
		b.Font = Enum.Font.GothamBold
		b.TextSize = 14
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Text = i == 1 and "-" or "+"
		bind(b.MouseButton1Click, function()
			cfg[key] = math.floor(math.clamp(cfg[key] + d, lo, hi) * 100 + 0.5) / 100
			refresh()
		end)
	end
end

local function box()
	local f = Instance.new("Frame")
	f.Size = UDim2.new(1, -16, 0, 0)
	f.AutomaticSize = Enum.AutomaticSize.Y
	f.BackgroundTransparency = 1
	f.LayoutOrder = nxt()
	local fl = Instance.new("UIListLayout", f)
	fl.SortOrder = Enum.SortOrder.LayoutOrder
	fl.Padding = UDim.new(0, 4)
	f.Parent = scroll
	return f
end

local function clearBox(b)
	for _, c in ipairs(b:GetChildren()) do
		if c:IsA("TextButton") then c:Destroy() end
	end
end

sec("MOVEMENT")
tog("speed") step("Walk Speed", "speed", 4, 16, 200)
tog("jump") step("Jump Power", "jump", 5, 50, 300)
tog("infjump") tog("fly") step("Fly Speed", "fly", 10, 20, 300)
tog("noclip") tog("clicktp") tog("antivoid") tog("antiragdoll") tog("bhop")
tog("grav") step("Gravity", "grav", 20, 0, 400)

sec("VISUALS")
tog("esp") tog("lowhp") step("ESP Range (0 = any)", "espRange", 100, 0, 3000)
tog("tracers") tog("fullbright") tog("nofog")
tog("fovchg") step("FOV", "fov", 5, 40, 120)
tog("timelock") step("Time of Day", "clock", 1, 0, 24)
tog("zoom") tog("hidetag") tog("hud")

sec("FIGHTING")
tog("aim") step("Aim FOV (px)", "aimFov", 25, 50, 800) step("Aim Smoothing %", "aimSmooth", 5, 1, 100)
tog("face") tog("follow")
tog("orbit") step("Orbit Radius", "orbitRadius", 1, 3, 30) step("Orbit Speed", "orbitSpeed", 1, 1, 12)
tog("hitbox") step("Hitbox Size", "hitbox", 1, 3, 30)
tog("alarm") step("Alarm Range", "alarm", 10, 10, 200)

sec("KEY AUTOMATION")
tog("autoblock") step("Block Range", "blockRange", 1, 4, 30)
tog("autodash") step("Dash Range", "dashRange", 1, 3, 30)
tog("autom1") step("M1 Range", "m1Range", 1, 3, 20)
tog("spam") step("Spam Delay (sec)", "spamDelay", 0.1, 0.1, 2)

sec("UTILITY")
tog("antiafk") tog("autorejoin") tog("joinalerts")

sec("ACTIONS")
for _, a in ipairs(acts) do btn(a[1], a[2]) end

sec("WAYPOINTS")
local wpBox
local wpn = 0
btn("Save Waypoint Here", function()
	local r = root()
	if not r then return end
	wpn += 1
	local cf, n = r.CFrame, wpn
	btn("TP: Waypoint " .. n, function()
		local rr = root()
		if rr then rr.CFrame = cf end
	end, Color3.fromRGB(40, 90, 90), wpBox)
	note("Waypoint " .. n .. " saved")
end)
btn("Clear Waypoints", function() clearBox(wpBox) wpn = 0 end, Color3.fromRGB(110, 50, 50))
wpBox = box()

sec("PLAYERS")
local plBox
btn("Refresh Player List", function()
	clearBox(plBox)
	for _, p in ipairs(plrs:GetPlayers()) do
		if p ~= lp then
			btn("TP: " .. p.DisplayName, function()
				local r, pr = root(), p.Character and p.Character:FindFirstChild("HumanoidRootPart")
				if r and pr then r.CFrame = pr.CFrame * CFrame.new(0, 0, 4) end
			end, Color3.fromRGB(70, 60, 40), plBox)
			btn("Spectate: " .. p.DisplayName, function()
				local ph = p.Character and p.Character:FindFirstChildOfClass("Humanoid")
				if ph then workspace.CurrentCamera.CameraSubject = ph end
			end, Color3.fromRGB(50, 70, 50), plBox)
		end
	end
end)
plBox = box()

sec("MENU")
local themes = { Color3.fromRGB(255, 170, 0), Color3.fromRGB(80, 160, 255), Color3.fromRGB(80, 210, 120), Color3.fromRGB(255, 90, 160) }
local ti = 1
btn("Cycle Theme", function()
	ti = ti % #themes + 1
	accent = themes[ti]
	title.BackgroundColor3 = accent
	for _, l in ipairs(heads) do l.TextColor3 = accent end
end)

do
	local mb = Instance.new("TextButton", title)
	mb.Size = UDim2.fromOffset(28, 26)
	mb.Position = UDim2.new(1, -32, 0, 2)
	mb.BackgroundTransparency = 1
	mb.Font = Enum.Font.GothamBold
	mb.TextSize = 18
	mb.TextColor3 = Color3.fromRGB(20, 20, 26)
	mb.Text = "-"
	local small = false
	bind(mb.MouseButton1Click, function()
		small = not small
		scroll.Visible = not small
		main.Size = small and UDim2.fromOffset(280, 30) or UDim2.fromOffset(280, 430)
		mb.Text = small and "+" or "-"
	end)
end

if uis.TouchEnabled then
	local tb = Instance.new("TextButton", gui)
	tb.Size = UDim2.fromOffset(46, 46)
	tb.Position = UDim2.new(1, -56, 0.5, -23)
	tb.BackgroundColor3 = accent
	tb.BorderSizePixel = 0
	tb.Font = Enum.Font.GothamBold
	tb.TextSize = 13
	tb.TextColor3 = Color3.fromRGB(20, 20, 26)
	tb.Text = "Apex"
	Instance.new("UICorner", tb).CornerRadius = UDim.new(1, 0)
	bind(tb.MouseButton1Click, function() main.Visible = not main.Visible end)
end

bind(uis.InputBegan, function(i, gp)
	if not gp and i.KeyCode == Enum.KeyCode.RightShift then main.Visible = not main.Visible end
end)

loadCfg(true)
checkUpdate(true)
note("Apex Hub v" .. cfg.version .. " loaded | RightShift hides the menu")
