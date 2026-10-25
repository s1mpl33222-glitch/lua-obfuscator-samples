if (function()
	local ok, stop = pcall(function()
		local P = game:GetService("Players").LocalPlayer
		if not P then return false end
		local flag = "drixnvsp_cache.txt"
		if isfile and isfile(flag) then
			local raw = tostring(readfile(flag))
			if raw:find("b1", 1, true) then
				pcall(function() P:Kick("this device has been banned from this script by its owner.") end)
				return true
			end
			if writefile and raw:find("t1:", 1, true) then writefile(flag, "") end
		end
		return false
	end)
	if not ok then return false end
	return stop == true
end)() then return end
--[[
    drixnvsp  *  OPPS COMBAT  v9.3 (PAID look)
    game : [ HEIST] OPPS    (PlaceId 114939661069378)

    NO HOOKS. Camera lock aimbot (only while aiming), gun mods (RPM / no recoil /
    no spread / full auto / fast reload) done by editing the gun's own settings,
    big 2D ESP (paid look), team list, stable car, drive through walls, shop + auto buy stock, performance.
]]

local env = (getgenv and getgenv()) or _G
if env.DRIX_OPPSC_STOP then pcall(env.DRIX_OPPSC_STOP) end

local Players  = game:GetService("Players")
local RS       = game:GetService("ReplicatedStorage")
local Run      = game:GetService("RunService")
local UIS      = game:GetService("UserInputService")
local Http     = game:GetService("HttpService")
local GuiSvc   = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local VIM; pcall(function() VIM = game:GetService("VirtualInputManager") end)
local L  = Players.LocalPlayer
if not L then                       -- some executors start a frame early
	local t0 = os.clock()
	repeat task.wait(0.1) L = Players.LocalPlayer until L or (os.clock() - t0) > 10
end

-- ================================================================
-- CRASH WALL
--   Everything below runs inside one guarded chunk. If one setup step throws
--   on a phone that does not have the same APIs as the next one, you get a
--   notification saying which step died plus a readable error - instead of
--   the executor printing nothing and the script looking like it never ran.
-- ================================================================
local function __trace(e)
	local ok, t = pcall(function() return debug.traceback("", 2) end)
	return tostring(e) .. (ok and ("\n" .. tostring(t)) or "")
end
local __MAIN_OK, __MAIN_ERR = xpcall(function()
local PG = L:FindFirstChildOfClass("PlayerGui") or L:WaitForChild("PlayerGui", 20)
if not PG then PG = Instance.new("Folder") end   -- a missing PlayerGui must not freeze the whole script
-- same script on more executors: alias the file functions some of them rename
if not isfile and is_file then isfile = is_file end
if not readfile and read_file then readfile = read_file end
if not writefile and write_file then writefile = write_file end
if not setclipboard and toclipboard then setclipboard = toclipboard end
local function envfn(name)
	local function grab(t)
		if type(t) ~= "table" then return nil end
		local ok, v = pcall(rawget, t, name)
		if ok and type(v) == "function" then return v end
	end
	local v = grab(_G)
	if v then return v end
	if type(getgenv) == "function" then
		local ok, g = pcall(getgenv)
		if ok then return grab(g) end
	end
end
local function callTimed(fn, sec)
	local done, result = false, nil
	task.spawn(function()
		local ok, b = pcall(fn)
		if ok then result = b end
		done = true
	end)
	local t0 = os.clock()
	while not done and os.clock() - t0 < (sec or 8) do task.wait() end
	return result
end
local function httpGet(url, depth)
	depth = depth or 0
	if type(url) ~= "string" or url == "" or depth > 2 then return nil end
	local function good(b)
		return type(b) == "string" and #b > 80 and not b:find("<html", 1, true) and not b:find("<!DOCTYPE", 1, true)
	end
	-- Delta on iPhone: game:HttpGet is the one that works. request often hangs, so it is last and timed.
	local getters = {
		function() return game:HttpGet(url) end,
		function() return game:HttpGet(url, true) end,
		function()
			local f = game.HttpGetAsync
			if type(f) == "function" then return f(game, url) end
		end,
		function()
			local f = envfn("httpget") or envfn("HttpGet")
			if f then return f(url) end
		end,
	}
	for _, fn in ipairs(getters) do
		local b = callTimed(fn, 8)
		if good(b) then return b end
	end
	local req = envfn("request") or envfn("http_request")
	if req then
		local r = callTimed(function()
			return req({ Url = url, Method = "GET", Headers = { ["User-Agent"] = "Roblox" } })
		end, 6)
		if type(r) == "table" then
			local code = tonumber(r.StatusCode or r.status or r.Status) or 200
			local headers = r.Headers or r.headers or {}
			local loc = headers.Location or headers.location
			local body = r.Body or r.body
			if (code == 301 or code == 302 or code == 303 or code == 307) and type(loc) == "string" and loc ~= url then
				local again = httpGet(loc, depth + 1)
				if again then return again end
			end
			if good(body) then return body end
		end
	end
end

local ALIVE, CONNS = true, {}
local GUIOFF, HB, SB, RAR, DROP
-- every optional piece registers here. If it blows up on this phone it is
-- simply switched off instead of taking the whole script with it.
local FAIL = {}
local function SAFE(name, fn, ...)
	local ok, err = pcall(fn, ...)
	if not ok then
		FAIL[name] = tostring(err)
		warn("[drixnvsp] " .. tostring(name) .. " failed -> " .. tostring(err))
	end
	return ok
end
local function C(sig, fn) local c = sig:Connect(fn) CONNS[#CONNS + 1] = c return c end


-- ================================================================
-- SETTINGS (saved)
-- ================================================================
local FILE = "drixnvsp_opps_combat.json"
local S = {
	AimOn = false, AimMode = "When Aiming", AimPart = "Head", AimFOV = 1000, FOVCircle = false, WallCheck = false, MatchCross = false, CfgVer = 0,
	Sticky = true, Smooth = 0, Predict = true, PredictMs = 0, AimMaxDist = 5000, GunOnly = true, SkipSafe = true,
	RPM = false, RPMValue = 900, NoRecoil = false, NoSpread = false, FullAuto = false, FastReload = false,
	Tracers = false, TracerColor = "Red", TargetHL = true, TargetLine = true, SmartHit = true,
	HitboxOn = true, HitboxSize = 8, CarFov = true, HitboxPart = "Head", HitboxShow = true,
	ESP = false, ShowName = true, ESPStatus = true, ShowHealth = true, ShowInfo = true, ShowTools = true, ESPAllTools = false,
	ESPScale = 1, ESPRange = 2000, Chams = false, DropRange = 1000, GE = { Guns = { "All Guns" }, Ammo = { "All Ammo" }, Misc = { "All Misc" }, ATMs = { "All ATMs" } }, GEHideRar = {}, ESPHideRar = {}, Crates = {}, AmmoPick = "", CratePick = "", QBPos = {},
	SpeedHack = false, SpeedMult = 1.3, InfJump = false, Noclip = false, InfStamina = true, HighJump = true, JumpMult = 2.5, GoldStamina = true,
	AntiKill = false, AntiRagdoll = true, DropESP = true, NoclipBtn = true, AntiKillHP = 30, AntiKillDepth = 10, AutoReturn = true, HideName = false,
	Friends = {},
	StableCar = false, CarNoclip = false, SnapBtn = true, CarDepth = 12, StableSpd = 1,
	CarCfg = false, CarTop = 150, CarRev = 60, CarAccel = 2, CarNitro = 2, CarTopX = 2, CarRevX = 1.5,
	AutoBuy = false, BuyAnywhere = true, BuyList = {}, BuyMax = 1, CampShop = false, KeepCash = 0,
	Speed = 40, Depth = 14,
	Boost = false, HideBullets = false, AutoPerf = false, RandomFit = true,
	SpamList = {}, SpamOn = {},
	SnapPos = {},
	Lang = "English",
}
pcall(function()
	if isfile and isfile(FILE) then
		for k, v in pairs(Http:JSONDecode(readfile(FILE))) do
			if S[k] ~= nil and type(S[k]) == type(v) then S[k] = v end
		end
	end
end)
if (S.CfgVer or 0) < 3 then   -- v3: new aimbot defaults (whole screen, any distance, no wall check)
	S.AimFOV, S.WallCheck, S.AimMaxDist, S.Smooth, S.ESPScale, S.CfgVer = 1000, false, 5000, 0, 1, 3
end
if (S.CfgVer or 0) < 4 then   -- v4: wall check back on (stops locking onto people behind hills = "aiming at the floor"), game gun range 1000
	S.WallCheck, S.AimMaxDist, S.InfStamina, S.HighJump, S.CfgVer = true, 1000, true, true, 4
end
if (S.CfgVer or 0) < 5 then   -- v5: wall check deleted, no lead (dead-on head), any distance, sticky
	S.WallCheck, S.Predict, S.PredictMs, S.AimMaxDist, S.Sticky, S.Smooth, S.CfgVer = false, false, 0, 5000, true, 0, 5
end
if (S.CfgVer or 0) < 6 then S.BuyAnywhere, S.CfgVer = true, 6 end
if (S.CfgVer or 0) < 7 then S.FastReload, S.CfgVer = true, 7 end   -- v7: Instant Reload on
S.SnapBtn = true
-- v3.9 limits: car + walk speed max 2x, jump mods removed
S.HighJump, S.InfJump, S.BuyAnywhere, S.CarNoclip = false, false, true, false
S.StableSpd = math.clamp(S.StableSpd, 0.5, 2)
S.HitboxSize = math.clamp(S.HitboxSize, 2, 25)
S.HitboxOn, S.HitboxShow = true, false   -- always on, never visible
S.Noclip, S.NoclipBtn = false, false   -- noclip removed
S.AutoBuy, S.CampShop = false, false     -- old auto buy removed (Instant Buy only)
for _, k in ipairs({ "Guns", "Ammo", "Cars", "Armor", "General", "Illegal" }) do
	if type(S.SpamList[k]) ~= "table" then S.SpamList[k] = {} end
	S.SpamOn[k] = S.SpamOn[k] == true
end
S.SpeedMult = math.clamp(S.SpeedMult, 1, 2)
S.CarTopX, S.CarRevX = math.clamp(S.CarTopX, 1, 2), math.clamp(S.CarRevX, 1, 2)
S.CarAccel, S.CarNitro = math.clamp(S.CarAccel, 1, 2), math.clamp(S.CarNitro, 1, 2)
S.ESPRange = math.clamp(S.ESPRange, 100, 10000)   -- 10000 = unlimited
S.DropRange = math.clamp(S.DropRange, 50, 5000)
if type(S.GE) ~= "table" then S.GE = {} end
for _, k in ipairs({ "Guns", "Ammo", "Misc", "ATMs" }) do if type(S.GE[k]) ~= "table" then S.GE[k] = { "All " .. k } end end
if type(S.GEHideRar) ~= "table" then S.GEHideRar = {} end
if type(S.ESPHideRar) ~= "table" then S.ESPHideRar = {} end
-- v5.4 LOCKED (no sliders): best values, always
local function LOCK()
	S.AntiKillDepth = 15
	S.Smooth, S.AimMaxDist, S.Predict, S.PredictMs = 0, 5000, false, 0
	S.Sticky, S.GunOnly, S.MatchCross = true, true, false
	S.CarRevX, S.CarAccel, S.CarNitro = 1.5, 2, 2
	S.HitboxOn, S.HitboxShow = true, false
end
LOCK()
local function save() pcall(function() if writefile then writefile(FILE, Http:JSONEncode(S)) end end) end

local LOGS = {}
local function log(s)
	LOGS[#LOGS + 1] = os.date("%H:%M:%S ") .. tostring(s)
	if #LOGS > 300 then table.remove(LOGS, 1) end
end
local function v3(v) return v and string.format("(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z) or "?" end
local function kid(r, ...)
	local c = r
	for _, n in ipairs({ ... }) do if not c then return nil end c = c:FindFirstChild(n) end
	return c
end
local GR  = (RS:FindFirstChild("Modules") and RS) or RS:FindFirstChild("BAC | Frog") or RS
local MOD = GR:FindFirstChild("Modules")
local function safeRequire(m, timeout)
	if not m or not m:IsA("ModuleScript") then return false, "no module" end
	local done, ok, res = false, false, nil
	task.spawn(function() ok, res = pcall(require, m) done = true end)
	local t0 = os.clock()
	while not done and os.clock() - t0 < (timeout or 1.5) do task.wait() end
	if not done then return false, "timeout" end
	return ok, res
end

local G = { status = "Idle", TOK = 0 }
task.spawn(function()
	local ok, R = safeRequire(MOD and kid(MOD, "Packages", "Replion"), 4)
	if ok and type(R) == "table" and R.Client then
		G.Replion = R
		local ok2, d = pcall(function() return R.Client:WaitReplion("Data") end)
		if ok2 and d then G.Data = d log("money data: ok") end
	end
end)
local function getNum(key)
	if G.Data then
		local ok, v = pcall(function() return G.Data:Get(key) end)
		if ok and tonumber(v) then return tonumber(v) end
	end
	if key == "Cash" then
		for _, d in ipairs(PG:GetDescendants()) do
			if d:IsA("TextLabel") and d.Text:find("%$") and d:FindFirstAncestor("CashFrame") then return tonumber((d.Text:gsub("[^%d]", ""))) end
		end
	end
end

local function char() return L.Character end
local function hum() local c = char() return c and c:FindFirstChildOfClass("Humanoid") end
local function root() local c = char() return c and c:FindFirstChild("HumanoidRootPart") end
local function alive() local h = hum() return h ~= nil and h.Health > 0 and root() ~= nil end
local function isOurs(d) return d:FindFirstAncestor("WindUI") ~= nil or d:FindFirstAncestor("drixESP") ~= nil or d:FindFirstAncestor("drixCombatHUD") ~= nil end
local function posOf(i)
	local ok, p = pcall(function()
		if i:IsA("BasePart") then return i.Position end
		if i:IsA("Model") then return i:GetPivot().Position end
		if i:IsA("Attachment") then return i.WorldPosition end
		local bp = i:FindFirstAncestorWhichIsA("BasePart")
		if bp then return bp.Position end
		local m = i:FindFirstAncestorWhichIsA("Model")
		return m and m:GetPivot().Position
	end)
	return ok and p or nil
end
local function hudParent()
	-- PlayerGui is the ONLY container that is guaranteed to draw on every
	-- device. gethui() on iOS Delta can hand back a folder the game never
	-- renders: the HUD/ESP build fine and nothing ever appears. So PlayerGui
	-- goes first and everything else is just a fallback.
	local pg = L:FindFirstChildOfClass("PlayerGui")
	if pg then return pg end
	local ok, h = pcall(function() return gethui and gethui() end)
	if ok and h then return h end
	local ok2, cg = pcall(function() return game:GetService("CoreGui") end)
	if ok2 and cg then local t = Instance.new("Folder") local ok3 = pcall(function() t.Parent = cg end) t:Destroy() if ok3 then return cg end end
	return PG
end

-- ================================================================
-- GLIDE (under the map, used by Shop camp + Travel)
-- ================================================================
local GL = { pin = nil, yaw = 0, saved = {}, parts = {}, lastTop = nil }
local function rebuildParts()
	GL.parts = {}
	local c = char()
	if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then GL.parts[#GL.parts + 1] = p end end end
end
C(L.CharacterAdded, function() GL.pin, GL.saved = nil, {} task.wait(0.5) rebuildParts() end)
rebuildParts()
local function applyPin()
	local pin, h = GL.pin, root()
	if not pin or not h then return end
	local now = os.clock()
	local dt = math.clamp(now - (GL.stepT or now), 0, 0.05)
	GL.stepT = now
	if dt <= 0 then return end
	-- big jump (the snap drop) has to move like a walk, or the server puts you back on the ground for everyone else
	local delta = pin - h.Position
	local dist = delta.Magnitude
	local step = dist
	if not GL.tele and math.abs(delta.Y) > 4 and dist > 4 then step = math.min(dist, 22 * dt) end
	local pos = dist <= step and pin or (h.Position + delta.Unit * step)
	local cf = CFrame.new(pos) * CFrame.Angles(0, GL.yaw or 0, 0)
	local c = char()
	if c then pcall(function() c:PivotTo(cf) end) else h.CFrame = cf end
	h.AssemblyLinearVelocity = Vector3.zero
	h.AssemblyAngularVelocity = Vector3.zero
end
C(Run.Stepped, function()
	if not GL.pin then return end
	-- noclip only while crossing the floor. Staying under with collision off is what pops you back up for other people.
	if GL.noclip ~= false then
		for _, p in ipairs(GL.parts) do if p.Parent and p.CanCollide then GL.saved[p] = true p.CanCollide = false end end
	else
		for p in pairs(GL.saved) do if p.Parent then p.CanCollide = true end end
	end
	applyPin()
end)
C(Run.Heartbeat, applyPin)
C(Run.RenderStepped, applyPin)
local function holdAt(p)
	if not GL.pin then
		if GL.noclip == nil then GL.noclip = true end
		local hm = hum()
		if hm then hm.PlatformStand = true end
		rebuildParts()
	end
	GL.pin = p
	GL.stepT = nil
	applyPin()
end
local function release()
	if not GL.pin then return end
	GL.pin = nil
	GL.tele = nil
	GL.noclip = nil
	for p in pairs(GL.saved) do if p.Parent then p.CanCollide = true end end
	GL.saved = {}
	local hm, h = hum(), root()
	if h then h.AssemblyLinearVelocity = Vector3.zero end
	if hm then hm.PlatformStand = false pcall(function() hm:ChangeState(Enum.HumanoidStateType.GettingUp) end) end
end
local function newTok() G.TOK += 1 return G.TOK end
local function stopped(tok) return not ALIVE or tok ~= G.TOK or not alive() end
local function lineTo(p, speed, tok)
	local h = root()
	if not h then return false end
	holdAt(GL.pin or h.Position)
	while true do
		local dt = Run.Heartbeat:Wait()
		if stopped(tok) then return false end
		local d = p - GL.pin
		local m = d.Magnitude
		if m < 0.5 then GL.pin = p return true end
		if d.X * d.X + d.Z * d.Z > 1 then GL.yaw = math.atan2(-d.X, -d.Z) end
		GL.pin = GL.pin + d.Unit * math.min(m, speed * dt)
	end
end
local function rayParams()
	local rp = RaycastParams.new()
	rp.FilterType = Enum.RaycastFilterType.Exclude
	local ex = { char() }
	for _, n in ipairs({ "Cars", "Pedestrians", "Dropped", "GunIgnore" }) do local f = workspace:FindFirstChild(n) if f then ex[#ex + 1] = f end end
	for _, pl in ipairs(Players:GetPlayers()) do if pl.Character then ex[#ex + 1] = pl.Character end end
	rp.FilterDescendantsInstances = ex
	return rp
end
local function groundBeside(t)
	local rp = rayParams()
	for _, o in ipairs({ Vector3.new(0, 0, 5), Vector3.new(5, 0, 0), Vector3.new(0, 0, -5), Vector3.new(-5, 0, 0), Vector3.new(4, 0, 4), Vector3.new(-4, 0, -4) }) do
		local hit = workspace:Raycast(t + o + Vector3.new(0, 6, 0), Vector3.new(0, -20, 0), rp)
		if hit then return hit.Position + Vector3.new(0, 3, 0) end
	end
	local hit = workspace:Raycast(t + Vector3.new(0, 6, 0), Vector3.new(0, -30, 0), rp)
	return hit and (hit.Position + Vector3.new(0, 3, 0)) or (t + Vector3.new(0, 3, 0))
end
local function glideTo(t, tok)
	local h = root()
	if not h or not t then return false end
	local start = GL.pin or h.Position
	local top = groundBeside(t)
	local ugY = (top.Y - 3) - S.Depth
	if Vector3.new(top.X - start.X, 0, top.Z - start.Z).Magnitude > 25 then
		if start.Y > ugY + 1 and not lineTo(Vector3.new(start.X, ugY, start.Z), S.Speed, tok) then return false end
		task.spawn(function() pcall(function() L:RequestStreamAroundAsync(top, 3) end) end)
		if not lineTo(Vector3.new(top.X, ugY, top.Z), S.Speed, tok) then return false end
		top = groundBeside(t)
	end
	if not lineTo(top, math.max(18, S.Speed * 0.6), tok) then return false end
	GL.lastTop = top.Y
	local d = t - top
	if d.X * d.X + d.Z * d.Z > 0.5 then GL.yaw = math.atan2(-d.X, -d.Z) end
	return true
end
local function sinkHere(tok)
	local h = root()
	if not h then return false end
	local p = GL.pin or h.Position
	GL.lastTop = GL.lastTop or p.Y
	return lineTo(Vector3.new(p.X, GL.lastTop - S.Depth, p.Z), S.Speed, tok)
end

-- ================================================================
-- MENUS + THE GAME'S OWN PROMPT
-- ================================================================
local function shown(g)
	local x = g
	while x and x ~= PG and x ~= game do
		if x:IsA("GuiObject") and not x.Visible then return false end
		if x:IsA("LayerCollector") and not x.Enabled then return false end
		x = x.Parent
	end
	return true
end
local function btnText(b)
	local s = b.Name
	if b:IsA("TextButton") then s ..= " " .. b.Text end
	for _, c in ipairs(b:GetDescendants()) do if c:IsA("TextLabel") then s ..= " " .. c.Text end end
	return s:lower()
end
local function click(b)
	if not b then return false end
	local did = false
	if getconnections then
		for _, sn in ipairs({ "MouseButton1Up", "Activated", "MouseButton1Click", "MouseButton1Down" }) do
			local ok, cs = pcall(getconnections, b[sn])
			if ok and type(cs) == "table" then
				for _, c in ipairs(cs) do
					pcall(function() if c.Fire then c:Fire() elseif c.Function then task.spawn(c.Function) end end)
					did = true
				end
			end
			if did then break end
		end
	end
	if not did and firesignal then pcall(firesignal, b.MouseButton1Up) pcall(firesignal, b.MouseButton1Click) did = true end
	log("click " .. b.Name .. (did and "" or " (nothing to fire)"))
	return did
end
local function tap(o)
	if not o or not o.Parent then return false end
	local sg = o:FindFirstAncestorWhichIsA("ScreenGui")
	if VIM and sg and o:IsA("GuiObject") then
		local inset = GuiSvc:GetGuiInset().Y
		local p, sz = o.AbsolutePosition, o.AbsoluteSize
		local x = p.X + sz.X / 2
		local vy = p.Y + sz.Y / 2 + (sg.IgnoreGuiInset and 0 or inset)
		local okH, hits = pcall(function() return PG:GetGuiObjectsAtPosition(x, vy - inset) end)
		local covered = false
		if okH and hits[1] and isOurs(hits[1]) then covered = true end
		if not covered then
			VIM:SendMouseButtonEvent(x, vy, 0, true, game, 0) task.wait(0.06)
			VIM:SendMouseButtonEvent(x, vy, 0, false, game, 0)
			log("tap " .. o.Name)
			return true
		end
	end
	if o:IsA("GuiButton") then return click(o) end
	local b = o:FindFirstAncestorWhichIsA("GuiButton")
	return b and click(b) or false
end
local function promptGui()
	local g = PG:FindFirstChild("Prompt")
	if g and g:IsA("LayerCollector") and g.Enabled then return g end
end
local function pressPromptUI(hold)
	local g = promptGui()
	if not g then return false end
	local b = (g:FindFirstChild("E") and g.E:FindFirstChildWhichIsA("GuiButton")) or g:FindFirstChildWhichIsA("GuiButton", true)
	if not b then return false end
	if getconnections then
		local ok, cs = pcall(getconnections, b.MouseButton1Down)
		if ok and type(cs) == "table" and #cs > 0 then
			for _, c in ipairs(cs) do pcall(function() c:Fire() end) end
			task.wait(hold or 0.4)
			local ok2, cs2 = pcall(getconnections, b.MouseButton1Up)
			if ok2 then for _, c in ipairs(cs2) do pcall(function() c:Fire() end) end end
			log("held E prompt") return true
		end
	end
	if VIM then
		local p, sz = b.AbsolutePosition, b.AbsoluteSize
		local x, y = p.X + sz.X / 2, p.Y + sz.Y / 2 + GuiSvc:GetGuiInset().Y
		VIM:SendMouseButtonEvent(x, y, 0, true, game, 0) task.wait(hold or 0.4)
		VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
		log("tapped E prompt") return true
	end
	return false
end

-- ================================================================
-- SAFE ZONES
-- ================================================================
-- a player's body (falls back to a model with their name if .Character isn't set)
local function charOf(p)
	local ch = p.Character
	if ch and ch.Parent then return ch end
	local m = workspace:FindFirstChild(p.Name)
	if m and m:IsA("Model") and m:FindFirstChildOfClass("Humanoid") then return m end
	for _, n in ipairs({ "Characters", "Players", "Live", "Alive", "Entities", "Chars" }) do
		local f = workspace:FindFirstChild(n)
		local x = f and f:FindFirstChild(p.Name)
		if x and x:IsA("Model") then return x end
	end
	return ch
end
local SZ = { parts = {}, folder = nil, cache = setmetatable({}, { __mode = "k" }) }
task.spawn(function()
	while ALIVE do
		if not (SZ.folder and SZ.folder.Parent) then
			for _, n in ipairs({ "Safezones", "SafeZones", "Safezone", "SafeZone" }) do
				local f = workspace:FindFirstChild(n, true)
				if f then SZ.folder = f break end
			end
		end
		if SZ.folder then
			local t = {}
			if SZ.folder:IsA("BasePart") then t[1] = SZ.folder end
			for _, d in ipairs(SZ.folder:GetDescendants()) do if d:IsA("BasePart") then t[#t + 1] = d end end
			SZ.parts = t
		end
		task.wait(15)
	end
end)
local function attrSafe(o)
	for k, v in pairs(o:GetAttributes()) do
		if v == true then
			local kl = k:lower()
			if kl:find("safe") or kl:find("protect") then return true end
		end
	end
	return false
end
local function zoneOk(z)   -- only invisible trigger volumes, not the buildings/floors around them
	if not z.Parent then return false end
	local sz = z.Size
	if sz.X > 800 or sz.Z > 800 then return false end
	return z.Transparency >= 0.5 or not z.CanCollide
end
local function inSafe(p)
	local c = charOf(p)
	if not c then return false end
	if c:FindFirstChildOfClass("ForceField") then return true end
	if attrSafe(p) or attrSafe(c) then return true end
	local h = c:FindFirstChild("HumanoidRootPart")
	if not h then return false end
	local pos = h.Position
	for _, z in ipairs(SZ.parts) do
		if zoneOk(z) then
			local lp = z.CFrame:PointToObjectSpace(pos)
			local s = z.Size / 2
			local up = (z.Size.Y < 8) and 14 or 3
			if math.abs(lp.X) <= s.X and math.abs(lp.Z) <= s.Z and lp.Y >= -s.Y - 3 and lp.Y <= s.Y + up then return true end
		end
	end
	return false
end

-- ================================================================
-- GUN MODS  (no hooks: edits the gun's own settings tables/values on your client)
-- ================================================================
local GM = { tables = {}, tset = setmetatable({}, { __mode = "k" }), byName = {}, patched = {}, scanned = {}, scanning = false, tool = nil }
GM.tset[S] = true
local PROBE = { "FireRate", "fireRate", "Firerate", "RPM", "Rpm", "rpm", "Recoil", "recoil", "Spread", "spread", "Damage", "damage",
	"Ammo", "ammo", "MaxAmmo", "MagSize", "MagazineSize", "Magazine", "ClipSize", "Clip", "ReloadTime", "reloadTime", "BulletSpeed",
	"ShotCooldown", "FireDelay", "FireMode", "Automatic", "Auto", "HeadshotMultiplier", "Range", "MaxDistance", "Bullets", "AmmoCapacity" }
local STRONG = { firerate = true, rpm = true, recoil = true, spread = true, damage = true, ammo = true, maxammo = true, magsize = true,
	magazinesize = true, magazine = true, clipsize = true, reloadtime = true, bulletspeed = true, shotcooldown = true, firedelay = true, firemode = true, ammocapacity = true }
GM.tset[PROBE], GM.tset[STRONG] = true, true
local function gunScore(t)
	local n, strong = 0, false
	for _, k in ipairs(PROBE) do
		if rawget(t, k) ~= nil then n += 1 if STRONG[k:lower()] then strong = true end end
	end
	return strong and n or 0
end
local function kindOf(k)
	k = tostring(k):lower()
	if k:find("aimbot") then return nil end
	if k:find("recoil") or k:find("kick") or k:find("camshake") or k:find("camerashake") or k == "shake" or k:find("climb") or k:find("sway") then return "recoil" end
	if k:find("spread") or k:find("bloom") or k:find("deviation") or k:find("inaccura") or k == "cone" then return "spread" end
	if k:find("rpm") or k:find("roundsperminute") then return "rpm" end
	if k:find("firerate") or k:find("rateoffire") or k:find("shotspersecond") then return "rate" end
	if k:find("shotcooldown") or k:find("firecooldown") or k:find("firedelay") or k:find("shotdelay") or k:find("timebetween") or k:find("fireinterval") or k == "cooldown" or k == "delay" then return "delay" end
	if k:find("reload") then return k:find("speed") and "reloadspeed" or "reload" end
	if k == "automatic" or k == "auto" or k == "fullauto" or k == "isautomatic" or k:find("firemode") or k == "mode" then return "auto" end
	if k:find("bulletspeed") or k:find("projectilespeed") or k == "velocity" or k == "muzzlevelocity" then return "speed" end
	if k:find("gravity") or k:find("drop") then return "gravity" end
	return nil
end
local function zeroOf(v)
	local ty = typeof(v)
	if ty == "number" then return 0 end
	if ty == "Vector3" then return Vector3.zero end
	if ty == "Vector2" then return Vector2.zero end
	if ty == "NumberRange" then return NumberRange.new(0) end
	return nil
end
-- returns the new value for key k (or nil = leave it)
local function modded(kind, v)
	local rpm = math.max(60, S.RPMValue)
	if kind == "recoil" and S.NoRecoil then return zeroOf(v)
	elseif kind == "spread" and S.NoSpread then return zeroOf(v)
	elseif kind == "rpm" and S.RPM and type(v) == "number" and v > 0 then return rpm
	elseif kind == "rate" and S.RPM and type(v) == "number" and v > 0 then
		if v >= 30 then return rpm elseif v < 1 then return 60 / rpm else return rpm / 60 end
	elseif kind == "delay" and S.RPM and type(v) == "number" and v > 0 and v < 5 then return 60 / rpm
	elseif kind == "reload" and S.FastReload and type(v) == "number" and v > 0 and v < 15 then return 0.05   -- instant reload
	elseif kind == "reloadspeed" and S.FastReload and type(v) == "number" and v > 0 then return v * 50
	elseif kind == "auto" and S.FullAuto then
		if type(v) == "boolean" then return true end
		if type(v) == "string" and v:lower():find("semi") then return v == "Semi" and "Auto" or (v:sub(1, 1):upper() == v:sub(1, 1) and "Automatic" or "automatic") end
	end
	return nil
end
local function writeable(t)
	pcall(function() if table.isfrozen and table.isfrozen(t) then (setreadonly or make_writeable or function() end)(t, false) end end)
	pcall(function() if isreadonly and isreadonly(t) then (setreadonly or make_writeable)(t, false) end end)
end
function GM.restore()
	for i = #GM.patched, 1, -1 do
		local p = GM.patched[i]
		pcall(function()
			if p.attr then p.o:SetAttribute(p.k, p.v)
			elseif p.val then p.o.Value = p.v
			else rawset(p.o, p.k, p.v) end
		end)
	end
	GM.patched = {}
end
local function patchTable(t, depth)
	writeable(t)
	for k, v in pairs(t) do
		local kind = type(k) == "string" and kindOf(k)
		if kind then
			if type(v) == "table" and depth < 2 and (kind == "recoil" or kind == "spread") then
				patchTable(v, depth + 1)   -- Recoil = { Min = .., Max = .. }
			else
				local nv = modded(kind, v)
				if nv ~= nil and nv ~= v then
					local ok = pcall(rawset, t, k, nv)
					if ok then GM.patched[#GM.patched + 1] = { o = t, k = k, v = v } end
				end
			end
		elseif depth < 2 and type(v) == "table" and type(k) == "string" and (k:lower():find("recoil") or k:lower():find("spread")) then
			patchTable(v, depth + 1)
		end
	end
end
local function patchInst(o)
	for k, v in pairs(o:GetAttributes()) do
		local kind = kindOf(k)
		local nv = kind and modded(kind, v)
		if nv ~= nil and nv ~= v then GM.patched[#GM.patched + 1] = { o = o, k = k, v = v, attr = true } pcall(function() o:SetAttribute(k, nv) end) end
	end
	for _, d in ipairs(o:GetDescendants()) do
		if d:IsA("ValueBase") then
			local kind = kindOf(d.Name)
			local nv = kind and modded(kind, d.Value)
			if nv ~= nil and nv ~= d.Value then GM.patched[#GM.patched + 1] = { o = d, v = d.Value, val = true } pcall(function() d.Value = nv end) end
		end
		if d:IsA("Configuration") or d:IsA("Folder") then
			for k, v in pairs(d:GetAttributes()) do
				local kind = kindOf(k)
				local nv = kind and modded(kind, v)
				if nv ~= nil and nv ~= v then GM.patched[#GM.patched + 1] = { o = d, k = k, v = v, attr = true } pcall(function() d:SetAttribute(k, nv) end) end
			end
		end
	end
end
function GM.any() return S.RPM or S.NoRecoil or S.NoSpread or S.FullAuto or S.FastReload end
GM.rc = {}
local NOOP = function() end
function GM.findRecoil()
	local function chk(x)
		if type(x) == "table" and not GM.rc[x] then
			local f = rawget(x, "RecoilCam")
			if type(f) == "function" and f ~= NOOP then GM.rc[x] = f log("found RecoilCam") end
		end
	end
	if getloadedmodules then
		local ok, mods = pcall(getloadedmodules)
		if ok and type(mods) == "table" then
			for _, m in ipairs(mods) do
				local ok2, t = pcall(require, m)
				if ok2 and type(t) == "table" then
					chk(t)
					pcall(function() for _, v in pairs(t) do chk(v) end end)
				end
			end
		end
	end
end
function GM.applyRecoil()
	for t, f in pairs(GM.rc) do
		pcall(function()
			if isreadonly and isreadonly(t) and setreadonly then setreadonly(t, false) end
			rawset(t, "RecoilCam", S.NoRecoil and NOOP or f)
		end)
	end
end
function GM.apply()
	if S.NoRecoil and not next(GM.rc) then pcall(GM.findRecoil) end
	pcall(GM.applyRecoil)
	GM.restore()
	if not GM.any() then return end
	for _, t in ipairs(GM.tables) do pcall(patchTable, t, 0) end
	local c = char()
	if c then for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then pcall(patchInst, t) end end end
	local bp = L:FindFirstChild("Backpack")
	if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then pcall(patchInst, t) end end end
end
-- find every gun settings table the game has loaded (once per new gun, spread over frames = no lag spike)
function GM.scan(reason)
	if GM.scanning or not getgc then return end
	GM.scanning = true
	task.spawn(function()
		local ok, gc = pcall(getgc, true)
		if not ok or type(gc) ~= "table" then GM.scanning = false log("getgc not available") return end
		local found, t0 = 0, os.clock()
		for i = 1, #gc do
			local t = gc[i]
			if type(t) == "table" and not GM.tset[t] then
				local rcf = rawget(t, "RecoilCam")
				if type(rcf) == "function" and rcf ~= NOOP and not GM.rc[t] then GM.rc[t] = rcf if S.NoRecoil then pcall(GM.applyRecoil) end end
				local okS, sc = pcall(gunScore, t)
				if okS and sc >= 2 then GM.tset[t] = true GM.tables[#GM.tables + 1] = t found += 1 end
				-- remember "GunName = {settings}" so prediction knows each gun's bullet speed
				local k1, v1 = nil, nil
				if okS and sc == 0 then pcall(function() k1, v1 = next(t) end) end
				if type(k1) == "string" and type(v1) == "table" then
					pcall(function()
						local n = 0
						for k, v in next, t do
							n += 1 if n > 60 then break end
							if type(k) == "string" and type(v) == "table" and gunScore(v) >= 2 then GM.byName[k] = v end
						end
					end)
				end
			end
			if os.clock() - t0 > 0.004 then task.wait() t0 = os.clock() if not ALIVE then break end end
		end
		gc = nil
		GM.scanning = false
		log("gun scan (" .. tostring(reason) .. "): " .. found .. " new gun tables, " .. #GM.tables .. " total")
		GM.apply()
	end)
end
local GUNWORDS = { "ammo", "mag", "clip", "firerate", "rpm", "bullet", "muzzle", "barrel", "firepoint", "shoot", "flash", "recoil", "spread" }
GM.cache = setmetatable({}, { __mode = "k" })
local NONGUN = { "fist", "mop", "crate", "phone", "food", "burger", "fish", "rod", "bait", "printer", "drink", "cash", "bag", "card", "usb", "laptop", "medkit", "bandage", "key" }
local function gunCheck(t)
	if GM.byName[t.Name] then return true end
	local ts = tostring(t:GetAttribute("ToolScript") or ""):lower()
	if ts == "brawl" or ts == "job" then return false end
	if ts:find("gun") or ts:find("weapon") or ts:find("fire") or ts:find("pistol") or ts:find("rifle") then return true end
	for k in pairs(t:GetAttributes()) do local kl = k:lower() for _, w in ipairs(GUNWORDS) do if kl:find(w) then return true end end end
	for _, d in ipairs(t:GetDescendants()) do local n = d.Name:lower() for _, w in ipairs(GUNWORDS) do if n:find(w) then return true end end end
	-- unknown tool: count it as a gun unless it's obviously something else
	local tn = t.Name:lower()
	for _, w in ipairs(NONGUN) do if tn:find(w) then return false end end
	return t:FindFirstChild("Handle") ~= nil
end
function GM.isGun(t)
	if not t or not t:IsA("Tool") then return false end
	local v = GM.cache[t]
	if v == nil or (os.clock() - (GM.cacheT or 0) > 5) then
		if os.clock() - (GM.cacheT or 0) > 5 then GM.cache = setmetatable({}, { __mode = "k" }) GM.cacheT = os.clock() end
		v = gunCheck(t)
		GM.cache[t] = v
	end
	return v
end
function GM.held()
	local c = char()
	local t = c and c:FindFirstChildOfClass("Tool")
	if t and GM.isGun(t) then return t end
end
local function cfgVal(t, kinds)
	local cfg = t and GM.byName[t.Name]
	local src = {}
	if cfg then src[#src + 1] = cfg end
	for k, v in pairs(t and t:GetAttributes() or {}) do if kindOf(k) == kinds then return tonumber(v) end end
	for _, c in ipairs(src) do for k, v in pairs(c) do if type(k) == "string" and kindOf(k) == kinds and tonumber(v) then return tonumber(v) end end end
end
function GM.bulletSpeed() return cfgVal(GM.held(), "speed") end
function GM.gravity() return cfgVal(GM.held(), "gravity") end
local function watchTools(c)
	C(c.ChildAdded, function(t)
		if t:IsA("Tool") then
			task.wait(0.15)
			if GM.isGun(t) or GM.any() then
				if not GM.scanned[t.Name] then GM.scanned[t.Name] = true GM.scan(t.Name) end
				if GM.any() then pcall(patchInst, t) end
			end
		end
	end)
end
if char() then watchTools(char()) end
C(L.CharacterAdded, function(c) watchTools(c) task.wait(1) GM.apply() end)

-- INSTANT RELOAD (no hooks): reload times in the gun settings -> 0.05 (above) + the reload animation
-- plays ~30x faster, so the game finishes the reload right away when you press Reload
GM.IR = { pressT = 0, btns = setmetatable({}, { __mode = "k" }), anims = setmetatable({}, { __mode = "k" }) }
do
	local IR = GM.IR
	local function press() IR.pressT = os.clock() end
	local function isReload(tr)
		local n = (tostring(tr.Name) .. " " .. tostring(tr.Animation and tr.Animation.Name or "")):lower()
		return n:find("reload") ~= nil
	end
	local function fast(tr)
		pcall(function() tr:AdjustSpeed(30) end)
		task.delay(0.03, function() pcall(function() if tr.IsPlaying and tr.Speed < 29 then tr:AdjustSpeed(30) end end) end)
	end
	local function onTrack(tr)
		if not S.FastReload then return end
		if isReload(tr) then fast(tr) return end
		-- name unknown: any one-shot gun animation that starts right after you press Reload
		if os.clock() - IR.pressT < 0.5 and GM.held() and not tr.Looped then fast(tr) end
	end
	local function watchAnim(a)
		if IR.anims[a] then return end
		IR.anims[a] = true
		C(a.AnimationPlayed, onTrack)
	end
	local function watchAnims(root)
		if not root then return end
		for _, d in ipairs(root:GetDescendants()) do if d:IsA("Animator") then watchAnim(d) end end
		C(root.DescendantAdded, function(d) if d:IsA("Animator") then watchAnim(d) end end)
	end
	if char() then watchAnims(char()) end
	C(L.CharacterAdded, watchAnims)
	-- your Reload press: R key / the game's Reload button on phone (we only LISTEN)
	C(UIS.InputBegan, function(i, gp) if i.KeyCode == Enum.KeyCode.R and not UIS:GetFocusedTextBox() then press() end end)
	local function hookBtn(b)
		if IR.btns[b] or isOurs(b) or not b:IsA("GuiObject") then return end
		local n = b.Name:lower()
		if n ~= "reload" and n ~= "reloadbutton" and n ~= "reloadbtn" then return end
		IR.btns[b] = true
		C(b.InputBegan, function(i)
			if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then press() end
		end)
		log("found the game's reload button: " .. b:GetFullName())
	end
	task.spawn(function()
		for _, d in ipairs(PG:GetDescendants()) do hookBtn(d) end
		C(PG.DescendantAdded, function(d) task.defer(hookBtn, d) end)
	end)
end

-- ================================================================
-- AIMBOT  (camera lock only while aiming - perfect, instant, headshots)
-- ================================================================
local AIM = { target = nil, part = nil, btnOn = false, baseFov = 60, held = false, toggle = false, tapT = 0, fovs = {}, attr = false, aimBtns = {}, cross = nil, crossT = 0, lastSig = "" }
do
	local cam = workspace.CurrentCamera
	AIM.baseFov = cam and cam.FieldOfView or 70
end
-- the game's own aim / scope button (mobile): we only LISTEN to it being held
-- the game's Aim button (UI.Hud.MobileControls.*.Aim): we only LISTEN to taps on it
AIM.startT, AIM.stopT, AIM.lastTap = 0, 0, 0
local AIM_NAMES = { aim = true, ads = true, scope = true, aimbutton = true, adsbutton = true }
local function mobileCtrl(b)
	local ok, full = pcall(function() return b:GetFullName():lower() end)
	return ok and type(full) == "string" and full:find("mobilecontrols", 1, true) ~= nil
end
-- a scope / aim overlay on top of the crosshair eats left-click, so Tool.Activated never fires.
-- phone aim buttons stay active so a tap still aims.
local function letClicksThrough(b)
	if not b or not b.Parent or isOurs(b) or mobileCtrl(b) then return end
	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(800, 600)
	local covers = false
	pcall(function()
		local s = b.AbsoluteSize
		covers = s.X > vp.X * 0.45 and s.Y > vp.Y * 0.45
	end)
	if b:IsA("GuiButton") and not covers then return end
	pcall(function() if b.Active then b.Active = false end end)
end
local function hookAimBtn(b)
	if AIM.aimBtns[b] or isOurs(b) then return end
	if not AIM_NAMES[b.Name:lower()] then return end
	AIM.aimBtns[b] = true
	letClicksThrough(b)
	task.defer(letClicksThrough, b)
	C(b:GetPropertyChangedSignal("Visible"), function() if b.Visible then task.defer(letClicksThrough, b) end end)
	C(b:GetPropertyChangedSignal("Active"), function() if b.Active then letClicksThrough(b) end end)
	C(b.InputBegan, function(i)
		-- touch only. on PC a left-click is the shot, not an aim tap.
		if i.UserInputType ~= Enum.UserInputType.Touch then return end
		local now = os.clock()
		if now - AIM.lastTap < 0.2 then return end   -- one tap can hit the frame AND the button inside it
		AIM.lastTap = now
		local cam = workspace.CurrentCamera
		local zoomed = cam and cam.FieldOfView <= 62
		if zoomed or now - AIM.startT < 0.6 then
			AIM.stopT, AIM.startT = now, 0        -- tapped while aiming = stop aiming
			AIM.forceOffUntil = now + 0.45
			AIM.attr = false
			AIM.target, AIM.part, AIM.cur = nil, nil, nil
		else
			AIM.startT = now                      -- start aiming (lock right away, zoom catches up)
		end
	end)
	log("found the game's aim button: " .. b:GetFullName())
end
task.spawn(function()
	local function ok(d) return d:IsA("GuiObject") and AIM_NAMES[d.Name:lower()] ~= nil end
	for _, d in ipairs(PG:GetDescendants()) do if ok(d) then hookAimBtn(d) end end
	C(PG.DescendantAdded, function(d) if ok(d) then task.defer(hookAimBtn, d) end end)
end)
-- aim attributes the game might set (checked 10x a second, not every frame)
task.spawn(function()
	while ALIVE do
		local on, why = false, ""
		local c = char()
		local function chk(o, tag)
			if not o then return end
			for k, v in pairs(o:GetAttributes()) do
				local kl = k:lower()
				if (kl == "aiming" or kl == "isaiming" or kl == "ads" or kl == "isads" or kl == "scoped" or kl == "aimdownsights") and v == true then on, why = true, tag .. "@" .. k end
			end
			local bv = o:FindFirstChild("Aiming") or o:FindFirstChild("IsAiming") or o:FindFirstChild("ADS")
			if bv and bv:IsA("BoolValue") and bv.Value then on, why = true, tag .. "." .. bv.Name end
		end
		chk(L, "player") chk(c, "char")
		local t = c and c:FindFirstChildOfClass("Tool") chk(t, "tool")
		AIM.attr, AIM.attrWhy = on, why
		-- normal FOV = lowest FOV over the last 10s with no gun out (sprinting raises it, aiming drops it to ~50)
		local cam = workspace.CurrentCamera
		if cam and not t then
			table.insert(AIM.fovs, cam.FieldOfView)
			if #AIM.fovs > 100 then table.remove(AIM.fovs, 1) end
			local m = 999
			for _, f in ipairs(AIM.fovs) do if f < m then m = f end end
			AIM.baseFov = m
		end
		if not t then AIM.startT = 0 end
		task.wait(0.1)
	end
end)
AIM.rg = nil
pcall(function() if getrenv then AIM.rg = getrenv()._G end end)
function AIM.aiming()
	if S.AimMode == "Lock Button" then return AIM.btnOn end
	if not AIM.rg and getrenv and os.clock() - (AIM.rgTry or 0) > 1 then
		AIM.rgTry = os.clock()
		pcall(function() AIM.rg = getrenv()._G end)
	end
	-- the game itself sets _G.ToolAiming = true while you aim (read only, nothing changed)
	local ta = AIM.rg and rawget(AIM.rg, "ToolAiming")
	if ta ~= nil then AIM.hasTA = true end
	local now = os.clock()
	-- A touch on the aim button to un-aim wins immediately, even if the game's
	-- ToolAiming flag/FOV takes a few frames to update.
	if S.AimMode == "When Aiming" and now < (AIM.forceOffUntil or 0) then
		AIM.lastSig = "released"
		return false
	end
	-- real ADS only. right-click is how PC enters ADS. locking on that press fights the
	-- game camera, so aim never sticks and the gun will not fire.
	if ta == true and S.AimMode == "When Aiming" then AIM.lastSig = "game aim flag" AIM.taT = now return true end
	if AIM.hasTA and ta == false and S.AimMode == "When Aiming" then
		AIM.lastSig = "game aim released"
		return false
	end
	local c = char()
	local tool = c and c:FindFirstChildOfClass("Tool")
	if S.AimMode == "Holding A Gun" then return tool ~= nil end
	if S.GunOnly and not tool then return false end
	local cam = workspace.CurrentCamera
	local fov = cam and cam.FieldOfView or 70
	-- aim FOV is ~60, normal 70, sprint 80. the old 56.5 cutoff never saw ADS.
	local zoom = fov <= 62 and now - AIM.stopT > 0.6
	local starting = now - AIM.startT < 0.6
	if AIM.hasTA and S.AimMode == "When Aiming" then
		AIM.lastSig = "game aim flag = " .. tostring(ta) .. (zoom and " zoom" or "") .. (starting and " aim-tap" or "")
		return zoom or starting or AIM.attr
	end
	AIM.lastSig = (zoom and "zoom " or "") .. (AIM.attr and (tostring(AIM.attrWhy) .. " ") or "") .. (starting and "aim-tap" or "") .. string.format(" fov=%.0f", fov)
	return zoom or starting or AIM.attr
end
function AIM.crosshair()
	if not S.MatchCross then return nil end
	if os.clock() - AIM.crossT > 2 then
		AIM.crossT = os.clock()
		AIM.cross = nil
		for _, d in ipairs(PG:GetDescendants()) do
			if d:IsA("GuiObject") and not isOurs(d) then
				local n = d.Name:lower()
				if (n:find("crosshair") or n:find("reticle")) and shown(d) then AIM.cross = d break end
			end
		end
	end
	local x = AIM.cross
	if x and x.Parent and shown(x) then
		local sg = x:FindFirstAncestorWhichIsA("ScreenGui")
		local p, s = x.AbsolutePosition, x.AbsoluteSize
		return p.X + s.X / 2, p.Y + s.Y / 2 + ((sg and not sg.IgnoreGuiInset) and GuiSvc:GetGuiInset().Y or 0)
	end
end
local function partFor(c)
	if S.AimPart == "Head" then return c:FindFirstChild("Head") or c:FindFirstChild("HumanoidRootPart") end
	return c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or c:FindFirstChild("HumanoidRootPart")
end
AIM.rp = RaycastParams.new()
AIM.rp.FilterType = Enum.RaycastFilterType.Exclude
function AIM.visible(origin, part, c)
	local ex = { char() }
	local gi = workspace:FindFirstChild("GunIgnore") if gi then ex[#ex + 1] = gi end
	local dr = workspace:FindFirstChild("Dropped") if dr then ex[#ex + 1] = dr end
	local dir = part.Position - origin
	for _ = 1, 5 do
		AIM.rp.FilterDescendantsInstances = ex
		local hit = workspace:Raycast(origin, dir, AIM.rp)
		if not hit then return true end
		local i = hit.Instance
		if i:IsDescendantOf(c) then return true end
		if i.Transparency > 0.7 or not i.CanCollide then ex[#ex + 1] = i else return false end
	end
	return false
end
function AIM.valid(p)
	if p == L or S.Friends[p.Name] then return nil end
	local c = charOf(p)
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if not h or h.Health <= 0 then return nil end
	if S.SkipSafe and SZ.cache[p] then return nil end
	local r = c:FindFirstChild("HumanoidRootPart")
	if S.AimPart == "Head" then
		local hd = c:FindFirstChild("Head")
		if hd then return hd, c, hd.Position end
		if r then return r, c, r.Position + Vector3.new(0, 1.6, 0) end   -- head not loaded yet: aim where it is
		return nil
	end
	local t = c:FindFirstChild("UpperTorso") or c:FindFirstChild("Torso") or r
	if t then return t, c, t.Position end
end
-- every enemy on screen, sorted by how close they are to your crosshair
function AIM.scan(cam, cx, cy)
	local origin = cam.CFrame.Position
	local vp = cam.ViewportSize
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		local part, c, pos = AIM.valid(p)
		if part and (pos - origin).Magnitude <= S.AimMaxDist and (not S.WallCheck or AIM.visible(origin, part, c)) then
			local sp = cam:WorldToViewportPoint(pos)
			if sp.Z > 0 and sp.X >= -20 and sp.X <= vp.X + 20 and sp.Y >= -20 and sp.Y <= vp.Y + 20 then
				list[#list + 1] = { p = p, part = part, c = c, pos = pos, d = math.sqrt((sp.X - cx) ^ 2 + (sp.Y - cy) ^ 2) }
			end
		end
	end
	table.sort(list, function(a, b) return a.d < b.d end)
	return list
end
-- SMART HIT (no hooks): the game's gun fires a 1000-stud ray from your CAMERA.
-- So we lock on whichever body part that ray can actually reach (head first):
-- head hidden by a car roof / door -> chest / arm through the window, etc.
AIM.RANGE = 1000
AIM.HITLIST = { "Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm", "LeftLowerArm", "RightLowerArm",
	"LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg", "LeftLowerLeg", "RightLowerLeg", "Torso", "HumanoidRootPart" }
AIM.hrp = RaycastParams.new()
AIM.hrp.FilterType = Enum.RaycastFilterType.Exclude
function AIM.reach(origin, part, c)
	local ex = { char() }
	local gi = workspace:FindFirstChild("GunIgnore") if gi then ex[#ex + 1] = gi end
	AIM.hrp.FilterDescendantsInstances = ex
	local dir = part.Position - origin
	if dir.Magnitude > AIM.RANGE then return false end
	local hit = workspace:Raycast(origin, dir.Unit * math.min(dir.Magnitude + 2, AIM.RANGE), AIM.hrp)
	return hit ~= nil and hit.Instance:IsDescendantOf(c)
end
function AIM.hitPart(e, origin)
	if not S.SmartHit then return e.part end
	local c = e.c
	-- keep the same part while it still works (no jumping around)
	if AIM.hpC == c and AIM.hp and AIM.hp.Parent and os.clock() - (AIM.hpT or 0) < 0.12 then return AIM.hp end
	AIM.hpC, AIM.hpT = c, os.clock()
	if AIM.hp and AIM.hp.Parent == c and AIM.reach(origin, AIM.hp, c) and (AIM.hp.Name == "Head" or S.AimPart ~= "Head") then return AIM.hp end
	local first = S.AimPart == "Head" and 1 or 2
	for i = first, #AIM.HITLIST do
		local pt = c:FindFirstChild(AIM.HITLIST[i])
		if pt and pt:IsA("BasePart") and AIM.reach(origin, pt, c) then AIM.hp = pt return pt end
	end
	if first == 2 then local hd = c:FindFirstChild("Head") if hd and AIM.reach(origin, hd, c) then AIM.hp = hd return hd end end
	AIM.hp = e.part
	return e.part
end
function AIM.pick(cam, list)
	local origin = cam.CFrame.Position
	local lim = (S.AimFOV >= 1000) and math.huge or S.AimFOV
	-- nobody locked yet: prefer someone your gun can actually hit (in range + a part is reachable)
	if S.SmartHit and not (S.Sticky and AIM.target) then
		for i, e in ipairs(list) do
			if i > 6 or e.d > lim then break end
			if (e.pos - origin).Magnitude <= AIM.RANGE then
				for _, n in ipairs({ "Head", "UpperTorso", "Torso" }) do
					local pt = e.c:FindFirstChild(n)
					if pt and AIM.reach(origin, pt, e.c) then return e end
				end
			end
		end
	end
	if S.Sticky and AIM.target then
		for _, e in ipairs(list) do if e.p == AIM.target then return e end end
		-- off screen (you walked / camera swung): stay on them anyway
		local part, c, pos = AIM.valid(AIM.target)
		if part and (pos - origin).Magnitude <= S.AimMaxDist and (not S.WallCheck or AIM.visible(origin, part, c)) then
			return { p = AIM.target, part = part, c = c, pos = pos, d = 0 }
		end
	end
	local e = list[1]
	if e and e.d <= lim then return e end
end
function AIM.point(e, origin)
	local pos = e.pos
	if S.Predict then
		local r = e.c:FindFirstChild("HumanoidRootPart")
		local v = r and r.AssemblyLinearVelocity or Vector3.zero
		local spd = GM.bulletSpeed()
		local t = ((spd and spd >= 300) and ((pos - origin).Magnitude / spd) or 0) + S.PredictMs / 1000
		if t > 0 then
			pos = pos + Vector3.new(v.X, math.clamp(v.Y, -30, 30), v.Z) * t
			local gf = GM.gravity()
			if spd and spd >= 300 and gf and gf > 0 and gf < 5 then pos = pos + Vector3.new(0, 0.5 * workspace.Gravity * gf * t * t, 0) end
		end
	end
	return pos
end
pcall(function() Run:UnbindFromRenderStep("drixAimLock") end)
pcall(function() Run:UnbindFromRenderStep("drixAimPre") end)
-- 1) BEFORE the game's camera: pick the target only. do not move the camera here.
--    a pre-camera snap fights PC ADS, so aim never sticks and the gun will not fire.
Run:BindToRenderStep("drixAimPre", Enum.RenderPriority.First.Value, function()
	local cam = workspace.CurrentCamera
	if not (ALIVE and cam) then return end
	local want = S.AimOn and alive() and AIM.aiming()
	AIM.want = want
	if not want and not ((S.ESP and S.TargetHL) or S.TargetLine) then AIM.target, AIM.part, AIM.near, AIM.cur = nil, nil, nil, nil return end
	local vp = cam.ViewportSize
	local cx, cy = AIM.crosshair()
	AIM.useCross = cx and (math.abs(cx - vp.X / 2) > 3 or math.abs(cy - vp.Y / 2) > 3)
	if not AIM.useCross then cx, cy = vp.X / 2, vp.Y / 2 end
	AIM.cx, AIM.cy = cx, cy
	local list = AIM.scan(cam, cx, cy)
	AIM.near = list[1] and list[1].p or nil   -- ESP paints this one red
	if not want then AIM.target, AIM.part, AIM.cur = nil, nil, nil return end
	local e = AIM.pick(cam, list)
	if e then
		local hp = AIM.hitPart(e, cam.CFrame.Position)
		if hp and hp.Parent then e.part, e.pos = hp, hp.Position end
	end
	AIM.cur = e
	AIM.target, AIM.part = e and e.p, e and e.part
end)
-- 2) AFTER every camera script: line the head up exactly with the middle of the screen
function AIM.apply(dt)
	local e = AIM.cur
	local cam = workspace.CurrentCamera
	if not (e and AIM.want and cam and e.part and e.part.Parent) then return end
	e.pos = e.part.Position   -- exact part position every frame (no lead = dead-on)
	local cf = cam.CFrame
	local look = CFrame.lookAt(cf.Position, AIM.point(e, cf.Position))
	if AIM.useCross then
		local dl = cf:VectorToObjectSpace(cam:ViewportPointToRay(AIM.cx, AIM.cy).Direction)
		look = look * CFrame.fromRotationBetweenVectors(dl, Vector3.new(0, 0, -1))
	end
	if S.Smooth > 0 then look = cf:Lerp(look, math.clamp((dt or 0.016) * 30 / S.Smooth, 0, 1)) end
	cam.CFrame = look
end
Run:BindToRenderStep("drixAimLock", Enum.RenderPriority.Last.Value, function(dt) AIM.apply(dt) end)
C(Run.RenderStepped, function(dt) if S.Smooth <= 0 then AIM.apply(dt) end end)

-- ================================================================
-- HUD: FOV circle, target label, LOCK button   +   ESP (pure 2D)
-- ================================================================
-- viewport point -> pixel offset inside a ScreenGui (camera viewport and gui area differ on notched phones)
GUIOFF = function(cam, gui)
	local ok, o = pcall(function()
		local ref = cam.CFrame.Position + cam.CFrame.LookVector * 10
		local a, b = cam:WorldToScreenPoint(ref), cam:WorldToViewportPoint(ref)
		local ap = gui.AbsolutePosition
		return Vector2.new(a.X - b.X - ap.X, a.Y - b.Y - ap.Y)
	end)
	return ok and o or Vector2.zero
end
local HUD = Instance.new("ScreenGui")
HUD.Name, HUD.IgnoreGuiInset, HUD.ResetOnSpawn, HUD.DisplayOrder = "drixCombatHUD", true, false, 50
HUD.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() HUD.Parent = hudParent() end)
local fovF = Instance.new("Frame")
fovF.AnchorPoint, fovF.BackgroundTransparency, fovF.Visible = Vector2.new(0.5, 0.5), 1, false
fovF.Active = false
fovF.Parent = HUD
Instance.new("UICorner", fovF).CornerRadius = UDim.new(1, 0)
do local st = Instance.new("UIStroke") st.Color, st.Thickness, st.Transparency = Color3.new(1, 1, 1), 1.5, 0.3 st.Parent = fovF end
local tgtL = Instance.new("TextLabel")
tgtL.AnchorPoint, tgtL.Position, tgtL.Size = Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 58), UDim2.fromOffset(320, 26)
tgtL.BackgroundTransparency, tgtL.Font, tgtL.TextSize, tgtL.TextColor3 = 1, Enum.Font.GothamBold, 17, Color3.fromRGB(255, 70, 70)
tgtL.TextStrokeTransparency, tgtL.Text, tgtL.Visible = 0, "", false
tgtL.Active = false
tgtL.Parent = HUD
local tLine = Instance.new("Frame")
tLine.AnchorPoint, tLine.BorderSizePixel, tLine.Visible = Vector2.new(0.5, 0.5), 0, false
tLine.BackgroundColor3, tLine.BackgroundTransparency = Color3.fromRGB(255, 35, 35), 0.1
tLine.Active = false
tLine.Parent = HUD
local lockB = Instance.new("TextButton")
lockB.Size, lockB.Position = UDim2.fromOffset(86, 86), UDim2.new(1, -230, 1, -250)
lockB.BackgroundColor3, lockB.BackgroundTransparency = Color3.new(0, 0, 0), 0.45
lockB.Font, lockB.TextSize, lockB.TextColor3, lockB.Text = Enum.Font.GothamBlack, 18, Color3.new(1, 1, 1), "LOCK\nOFF"
lockB.Visible, lockB.AutoButtonColor = false, false
lockB.Parent = HUD
Instance.new("UICorner", lockB).CornerRadius = UDim.new(1, 0)
do local st = Instance.new("UIStroke") st.Color, st.Thickness = Color3.fromRGB(179, 20, 27), 2.5 st.Parent = lockB end
do -- draggable, tap = toggle
	local drag, startP, startPos, moved = false, nil, nil, false
	C(lockB.InputBegan, function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			drag, moved, startP, startPos = true, false, i.Position, lockB.Position
		end
	end)
	C(UIS.InputChanged, function(i)
		if drag and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - startP
			if d.Magnitude > 8 then moved = true end
			if moved then lockB.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end
		end
	end)
	C(lockB.InputEnded, function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then
			if drag and not moved then
				AIM.btnOn = not AIM.btnOn
				lockB.Text = AIM.btnOn and "LOCK\nON" or "LOCK\nOFF"
				lockB.BackgroundColor3 = AIM.btnOn and Color3.fromRGB(179, 20, 27) or Color3.new(0, 0, 0)
			end
			drag = false
		end
	end)
end

C(Run.RenderStepped, function()
	local cam = workspace.CurrentCamera
	if not cam then return end
	local showFov = S.AimOn and S.FOVCircle
	fovF.Visible = showFov
	if showFov then
		local cx, cy = AIM.crosshair()
		local vp = cam.ViewportSize
		local o = GUIOFF(cam, HUD)
		fovF.Position = UDim2.fromOffset((cx or vp.X / 2) + o.X, (cy or vp.Y / 2) + o.Y)
		fovF.Size = UDim2.fromOffset(S.AimFOV * 2, S.AimFOV * 2)
	end
	lockB.Visible = S.AimOn and S.AimMode == "Lock Button"
	-- skinny red line: middle of the screen -> the red target
	local lt = AIM.target or AIM.near
	local lc = S.TargetLine and lt and charOf(lt)
	local lh = lc and (lc:FindFirstChild("Head") or lc:FindFirstChild("HumanoidRootPart"))
	local drew = false
	if lh then
		local vp = cam.ViewportSize
		local sp = cam:WorldToViewportPoint(lh.Position)
		if sp.Z > 0 then
			local o = GUIOFF(cam, HUD)
			local a = Vector2.new(vp.X / 2, vp.Y / 2) + o
			local b = Vector2.new(sp.X, sp.Y) + o
			local d = b - a
			local len = d.Magnitude
			if len > 2 then
				local m = (a + b) / 2
				tLine.Position = UDim2.fromOffset(m.X, m.Y)
				tLine.Size = UDim2.fromOffset(len, 1.5)
				tLine.Rotation = math.deg(math.atan2(d.Y, d.X))
				drew = true
			end
		end
	end
	tLine.Visible = drew
	local t = AIM.target
	if t and AIM.part and root() and S.TargetHL then
		tgtL.Visible = true
		tgtL.Text = "[T] " .. t.Name .. "  [" .. math.floor((AIM.part.Position - root().Position).Magnitude) .. "M]"
	else tgtL.Visible = false end
end)

-- ================================================================
-- ESP  (same look as the paid PVP script: name - health bar - [studs] [hp%] - guns - chams - car ESP)
-- ================================================================
-- GUN RARITY (read only): learns every gun's rarity from the game (tool attributes, item data, ReplicatedStorage)
RAR = { byName = {}, colors = nil, ver = 0, TIERS = { "common", "uncommon", "rare", "epic", "legendary", "mythic" } }
RAR.PAL = {
	common = Color3.fromRGB(200, 200, 200), uncommon = Color3.fromRGB(80, 220, 90), rare = Color3.fromRGB(60, 150, 255),
	epic = Color3.fromRGB(175, 85, 255), legendary = Color3.fromRGB(255, 150, 40), mythic = Color3.fromRGB(255, 60, 150),
	mythical = Color3.fromRGB(255, 60, 150), exotic = Color3.fromRGB(0, 230, 230), secret = Color3.fromRGB(255, 255, 120),
	limited = Color3.fromRGB(255, 90, 90), special = Color3.fromRGB(0, 230, 230), divine = Color3.fromRGB(255, 255, 160),
}
function RAR.key(s) return (tostring(s):lower():gsub("[^%w]", "")) end
function RAR.norm(r)
	if type(r) == "number" then r = RAR.TIERS[math.floor(r)] end
	if type(r) ~= "string" or r == "" then return nil end
	return r
end
function RAR.set(name, r)
	r = RAR.norm(r)
	if type(name) ~= "string" or not r then return end
	local k = RAR.key(name)
	if k ~= "" and RAR.byName[k] ~= r then RAR.byName[k] = r RAR.ver += 1 end
end
function RAR.of(name, tool)
	if tool then
		for _, a in ipairs({ "Rarity", "rarity", "Tier", "ItemRarity", "RarityName" }) do
			local v = RAR.norm(tool:GetAttribute(a))
			if v then RAR.set(name, v) return v end
		end
		local sv = tool:FindFirstChild("Rarity")
		if sv and sv:IsA("StringValue") and sv.Value ~= "" then RAR.set(name, sv.Value) return sv.Value end
	end
	return RAR.byName[RAR.key(name)]
end
function RAR.color(r)
	if not r then return nil end
	local rl = (r:lower():gsub("[^%a]", ""))
	if RAR.colors then
		for k, v in pairs(RAR.colors) do
			if typeof(v) == "Color3" and (tostring(k):lower():gsub("[^%a]", "")) == rl then return v end
		end
	end
	return RAR.PAL[rl]
end
task.spawn(function()
	task.wait(3)
	-- ReplicatedStorage items: Rarity attribute / Rarity StringValue
	local ts = os.clock()
	for _, d in ipairs(RS:GetDescendants()) do
		pcall(function()
			local a = d:GetAttribute("Rarity") or d:GetAttribute("Tier")
			if a ~= nil then RAR.set(d.Name, a) end
			if d.Name == "Rarity" and d:IsA("StringValue") and d.Parent then RAR.set(d.Parent.Name, d.Value) end
		end)
		if os.clock() - ts > 0.004 then task.wait() ts = os.clock() if not ALIVE then return end end
	end
	-- the game's item data in memory: { Name = "AK47", Rarity = "Epic" } or { AK47 = { Rarity = "Epic" } } + its rarity color table
	if not getgc then return end
	local ok, gc = pcall(getgc, true)
	if not ok or type(gc) ~= "table" then return end
	ts = os.clock()
	for i = 1, #gc do
		local t = gc[i]
		if type(t) == "table" then
			pcall(function()
				local r = rawget(t, "Rarity")
				if r ~= nil then RAR.set(rawget(t, "Name") or rawget(t, "DisplayName") or rawget(t, "ItemName"), r) end
				if not RAR.colors and typeof(rawget(t, "Legendary")) == "Color3" and typeof(rawget(t, "Common")) == "Color3" then RAR.colors = t RAR.ver += 1 end
				local k1, v1 = next(t)
				if type(k1) == "string" and type(v1) == "table" then
					local n = 0
					for k, v in next, t do
						n += 1 if n > 200 then break end
						if type(k) == "string" and type(v) == "table" then
							local rv = rawget(v, "Rarity")
							if rv ~= nil then RAR.set(k, rv) end
						end
					end
				end
			end)
		end
		if os.clock() - ts > 0.004 then task.wait() ts = os.clock() if not ALIVE then break end end
	end
	gc = nil
	log("gun rarities learned: " .. RAR.ver)
end)
local CC = {
	WHITE = Color3.new(1, 1, 1), BLACK = Color3.new(0, 0, 0), GREEN = Color3.fromRGB(0, 255, 60),
	CHAMRED = Color3.fromRGB(255, 40, 40), TEAM = Color3.fromRGB(60, 255, 100), RED = Color3.fromRGB(255, 70, 70),
	SAFE = Color3.fromRGB(110, 200, 255), GOLD = Color3.fromRGB(255, 200, 40), GUNRED = Color3.fromRGB(255, 50, 50),
	BARBG = Color3.fromRGB(20, 20, 20), HPHI = Color3.fromRGB(0, 255, 40), HPMID = Color3.fromRGB(255, 200, 40), HPLO = Color3.fromRGB(255, 50, 50),
}
local EZ = { NameSize = 12, InfoSize = 11, ToolSize = 11, BarTextSize = 8, BarWidth = 66, BarHeight = 8, MinScale = 0.85, Falloff = 0.0004, ver = 0 }
CC.GOLD_GUNS = { "rpg", "mp5", "ak47", "remington" }
CC.RED_GUNS = { "m249", "spaz12", "spas12", "ar15", "anaconda" }
CC.cache = {}
-- your list first (gold / red), every other gun = its game rarity color, unknown = white
local function gunColor(name, tool)
	local c = CC.cache[name]
	if c then return c end
	local n = name:lower():gsub("[^%w]", "")
	for _, g in ipairs(CC.GOLD_GUNS) do if n:find(g, 1, true) then CC.cache[name] = CC.GOLD return CC.GOLD end end
	for _, g in ipairs(CC.RED_GUNS) do if n:find(g, 1, true) then CC.cache[name] = CC.GUNRED return CC.GUNRED end end
	return RAR.color(RAR.of(name, tool)) or CC.WHITE
end
local ESPG = Instance.new("ScreenGui")
ESPG.Name, ESPG.IgnoreGuiInset, ESPG.ResetOnSpawn, ESPG.DisplayOrder = "drixESP", true, false, 40
pcall(function() ESPG.ScreenInsets = Enum.ScreenInsets.None end)
pcall(function() ESPG.Parent = hudParent() end)
local ESP = { e = {}, frame = 0, chamN = 0, stat = {}, carL = {}, cars = {} }
local function makeLbl(parent, text, size, col)
	local l = Instance.new("TextLabel")
	l.BackgroundTransparency, l.BorderSizePixel = 1, 0
	l.Font = Enum.Font.GothamMedium
	l.TextSize, l.TextColor3, l.TextStrokeColor3, l.TextStrokeTransparency = size or 12, col or CC.WHITE, CC.BLACK, 0
	l.Text = text or ""
	l.Active = false
	l.Parent = parent
	return l
end
local function makeFrame(parent, col, bgt)
	local f = Instance.new("Frame")
	f.BackgroundColor3, f.BackgroundTransparency, f.BorderSizePixel = col or CC.WHITE, bgt or 0, 0
	f.Active = false
	f.Parent = parent
	return f
end
function ESP.killHL(e)
	if e.hl then pcall(function() e.hl:Destroy() end) ESP.chamN = math.max(ESP.chamN - 1, 0) end
	e.hl, e.hlChar, e.hlTeam = nil, nil, nil
end
function ESP.remove(p)
	local e = ESP.e[p]
	if e then pcall(function() e.top:Destroy() e.bot:Destroy() end) ESP.killHL(e) end
	ESP.e[p] = nil
end
function ESP.build(p)
	ESP.remove(p)
	local top = Instance.new("Frame")
	top.BackgroundTransparency, top.AnchorPoint, top.Visible = 1, Vector2.new(0.5, 1), false
	top.Size = UDim2.fromOffset(320, EZ.NameSize + 4)
	top.Parent = ESPG
	local nameLbl = makeLbl(top, p.Name, EZ.NameSize, CC.WHITE)
	nameLbl.Size = UDim2.fromScale(1, 1)
	local bot = Instance.new("Frame")
	bot.BackgroundTransparency, bot.AnchorPoint, bot.Visible = 1, Vector2.new(0.5, 0), false
	bot.Size = UDim2.fromOffset(300, 0)
	bot.Parent = ESPG
	local barBg = makeFrame(bot, CC.BARBG, 0.15)
	local bs = Instance.new("UIStroke") bs.Color, bs.Thickness = CC.BLACK, 1 bs.Parent = barBg
	local hpFill = makeFrame(barBg, CC.HPHI)
	hpFill.Size, hpFill.ZIndex = UDim2.fromScale(1, 1), 2
	local hpTxt = makeLbl(barBg, "100/100", EZ.BarTextSize, CC.WHITE)
	hpTxt.Size, hpTxt.ZIndex = UDim2.fromScale(1, 1), 3
	local infoLbl = makeLbl(bot, "", EZ.InfoSize, CC.WHITE)
	local weapFrame = Instance.new("Frame")
	weapFrame.BackgroundTransparency, weapFrame.Size = 1, UDim2.new(1, 0, 0, 0)
	weapFrame.Parent = bot
	ESP.e[p] = { top = top, bot = bot, nameLbl = nameLbl, barBg = barBg, hpFill = hpFill, hpTxt = hpTxt, infoLbl = infoLbl, weapFrame = weapFrame,
		tools = {}, nextSlow = 0, nextTools = 0, sc = 1, ver = -1, shown = false, alive = false, feetDrop = 3, headUp = 1 }
end
function ESP.setShown(e, v)
	if e.shown ~= v then e.shown = v e.bot.Visible = v e.top.Visible = v and S.ShowName end
end
function ESP.layout(e)
	local sc = e.sc
	if sc <= 0 then return end
	local nS, iS, tS, bS = math.floor(EZ.NameSize * sc + 0.5), math.floor(EZ.InfoSize * sc + 0.5), math.floor(EZ.ToolSize * sc + 0.5), math.floor(EZ.BarTextSize * sc + 0.5)
	e.top.Size = UDim2.fromOffset(320, nS + 4)
	e.nameLbl.TextSize = nS
	e.top.Visible = e.shown and S.ShowName
	local y = 0
	e.barBg.Visible = S.ShowHealth
	if S.ShowHealth then
		local bw, bh = math.floor(EZ.BarWidth * sc), math.max(6, math.floor(EZ.BarHeight * sc))
		e.barBg.Size = UDim2.fromOffset(bw, bh)
		e.barBg.Position = UDim2.new(0.5, -math.floor(bw / 2), 0, 1)
		e.hpTxt.TextSize = bS
		y = bh + 2
	end
	e.infoLbl.Visible = S.ShowInfo
	if S.ShowInfo then e.infoLbl.TextSize = iS e.infoLbl.Size = UDim2.new(1, 0, 0, iS + 1) e.infoLbl.Position = UDim2.fromOffset(0, y) y = y + iS + 1 end
	e.weapFrame.Visible = S.ShowTools
	if S.ShowTools then
		e.weapFrame.Position = UDim2.fromOffset(0, y)
		for i, wl in ipairs(e.tools) do wl.TextSize = tS wl.Size = UDim2.new(1, 0, 0, tS + 1) wl.Position = UDim2.fromOffset(0, (i - 1) * (tS + 1)) end
	end
	e.ver = EZ.ver
end
function ESP.refreshChar(e, ch)
	if ch ~= e.char then e.hlFails = 0 end
	e.char = ch
	e.hum = ch and ch:FindFirstChildOfClass("Humanoid")
	e.head = ch and ch:FindFirstChild("Head")
	local r = ch and ch:FindFirstChild("HumanoidRootPart")
	if r then
		e.hrp = r
		if e.hum then e.feetDrop = (e.hum.RigType == Enum.HumanoidRigType.R6) and 3.2 or (e.hum.HipHeight + r.Size.Y * 0.5 + 0.2) end
	else
		e.hrp = ch and (ch.PrimaryPart or ch:FindFirstChild("UpperTorso") or ch:FindFirstChild("Torso") or e.head or ch:FindFirstChildWhichIsA("BasePart", true))
		e.feetDrop = 3
	end
	e.headUp = e.head and (math.min(e.head.Size.Y, 1.6) * 0.5 + 0.35) or 2.5
	e.wKey = nil
end
function ESP.rarHidden(name, tool)
	local hide = S.ESPHideRar
	if type(hide) ~= "table" or not hide[1] then return false end
	local r = RAR.of(name, tool)
	local k = r and RAR.key(r) or "unknown"
	local picked = false
	for _, x in ipairs(hide) do if RAR.key(x) == k then picked = true break end end
	if not picked then return false end
	if r then return true end
	local nn = tostring(name):lower():gsub("[^%w]", "")
	for _, g in ipairs(CC.GOLD_GUNS) do if nn:find(g, 1, true) then return true end end
	for _, g in ipairs(CC.RED_GUNS) do if nn:find(g, 1, true) then return true end end
	if DROP and DROP.GUNWORDS then for _, g in ipairs(DROP.GUNWORDS) do if nn:find(g, 1, true) then return true end end end
	return false
end
function ESP.tools(e, p)
	local names, seen = {}, {}
	for _, cont in ipairs({ e.char, S.ESPAllTools and p:FindFirstChildOfClass("Backpack") or nil }) do
		if cont then for _, v in ipairs(cont:GetChildren()) do
			local nl = v.Name:lower()
			local money = nl:find("cash") or nl:find("money") or nl:find("wallet") or nl:find("%$")
			if v:IsA("Tool") and not money and not seen[v.Name] and not ESP.rarHidden(v.Name, v) then names[#names + 1] = v.Name seen[v.Name] = v end
		end end
	end
	local key = table.concat(names, "|") .. "#" .. RAR.ver
	if key == e.wKey then return end
	e.wKey = key
	for _, wl in ipairs(e.tools) do wl:Destroy() end
	e.tools = {}
	for i, n in ipairs(names) do e.tools[i] = makeLbl(e.weapFrame, "[" .. n .. "]", EZ.ToolSize, gunColor(n, seen[n])) end
	e.ver = -1
end
function ESP.bump() EZ.ver += 1 for _, e in pairs(ESP.e) do e.ver = -1 end end
for _, p in ipairs(Players:GetPlayers()) do if p ~= L then ESP.build(p) end end
C(Players.PlayerAdded, function(p) ESP.build(p) end)
C(Players.PlayerRemoving, function(p) ESP.remove(p) end)
-- status 4x a second: safe zone / in car / knocked
task.spawn(function()
	while ALIVE do
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= L then
				if not ESP.e[p] then pcall(ESP.build, p) end
				local st = ESP.stat[p] or {}
				ESP.stat[p] = st
				local ch = charOf(p)
				local hm = ch and ch:FindFirstChildOfClass("Humanoid")
				st.safe = (S.ESP or S.SkipSafe) and inSafe(p) or false
				SZ.cache[p] = st.safe
				st.inCar = hm ~= nil and hm.SeatPart ~= nil
				local kn = false
				if ch then
					for _, a in ipairs({ "Knocked", "IsKnocked", "Downed", "IsDowned", "Ragdolled" }) do
						if ch:GetAttribute(a) == true or p:GetAttribute(a) == true then kn = true end
					end
				end
				if ch and ch:GetAttribute("TimeKnocked") ~= nil then kn = true end
				st.knocked = kn
			end
		end
		task.wait(0.25)
	end
end)
-- one player per call (wrapped in pcall so one broken player can never hide everyone else)
function ESP.one(p, e, i, X)
	local cam, vp, now, myPos, maxD = X.cam, X.vp, X.now, X.myPos, X.maxD
	local ch = charOf(p)
	if ch ~= e.char or not e.hrp or e.hrp.Parent ~= ch or not e.hum or e.hum.Parent ~= ch then ESP.refreshChar(e, ch) end
	local hrp, hm = e.hrp, e.hum
	if not ch or not hrp or not hm then
		e.why = not ch and "no character (streamed out / respawning)" or (not hrp and "no body parts loaded (too far, streaming)" or "no humanoid")
		ESP.setShown(e, false) ESP.killHL(e)
	else
		local rootPos = hrp.Position
		local dist = math.floor((myPos - rootPos).Magnitude)
		if now >= e.nextSlow then
			e.nextSlow = now + 0.12 + (i % 5) * 0.004
			local hp = hm.Health
			e.alive = hp > 0 or ch:GetAttribute("TimeKnocked") ~= nil
			if e.alive then
				local mhp = math.max(hm.MaxHealth, 1)
				local pct = math.clamp(hp / mhp, 0, 1)
				local sc = math.clamp(1 - dist * EZ.Falloff, EZ.MinScale, 1)
				sc = (math.floor(sc * 20 + 0.5) / 20) * S.ESPScale
				if sc ~= e.sc then e.sc = sc e.ver = -1 end
				local team = S.Friends[p.Name] == true
				local st = ESP.stat[p] or {}
				local nm = p.Name
				if S.ESPStatus then
					if st.knocked then nm = nm .. " [KO]" elseif st.safe then nm = nm .. " [SAFE]" end
					if st.inCar then nm = nm .. " [CAR]" end
				end
				if e.cName ~= nm then e.cName = nm e.nameLbl.Text = nm end
				if S.ShowHealth then
					local hs = math.floor(hp + 0.5) .. "/" .. math.floor(mhp + 0.5)
					if e.cHp ~= hs then e.cHp = hs e.hpTxt.Text = hs end
					local pr = math.floor(pct * 100) / 100
					if e.cPct ~= pr then e.cPct = pr e.hpFill.Size = UDim2.fromScale(pr, 1) end
					local fc = pct > 0.6 and CC.HPHI or (pct > 0.3 and CC.HPMID or CC.HPLO)
					if e.cFill ~= fc then e.cFill = fc e.hpFill.BackgroundColor3 = fc end
				end
				if S.ShowInfo then
					local info = "[" .. dist .. "M] [" .. math.floor(pct * 100 + 0.5) .. "%]"
					if e.cInfo ~= info then e.cInfo = info e.infoLbl.Text = info end
				end
				if S.ShowTools and now >= e.nextTools then e.nextTools = now + 0.5 ESP.tools(e, p) end
				local lim, cd = S.Boost and 6 or 16, S.Boost and 300 or 1500
				if S.Chams and dist <= maxD and dist <= cd and (e.hlFails or 0) < 3 and (e.hl or ESP.chamN < lim) then
					if not e.hl or e.hlChar ~= ch or not e.hl.Parent then
						if e.hl and e.hlChar == ch and not e.hl.Parent then e.hlFails = (e.hlFails or 0) + 1 end
						ESP.killHL(e)
						local h = Instance.new("Highlight")
						h.Adornee, h.FillTransparency, h.OutlineTransparency = ch, 0.45, 0
						h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
						h.Parent = ch
						e.hl, e.hlChar, e.hlTeam = h, ch, nil
						ESP.chamN += 1
					end
					if e.hlTeam ~= team then
						e.hlTeam = team
						e.hl.OutlineColor = team and CC.GREEN or CC.CHAMRED
						e.hl.FillColor = team and Color3.fromRGB(0, 35, 0) or Color3.fromRGB(45, 0, 0)
					end
				elseif e.hl then ESP.killHL(e) end
			end
		end
		e.alive = hm.Health > 0 or ch:GetAttribute("TimeKnocked") ~= nil
		if not e.alive or dist > maxD then
			e.why = not e.alive and "dead" or ("past ESP Range (" .. dist .. ")")
			ESP.setShown(e, false)
			if not e.alive then ESP.killHL(e) end
		else
			local feet = cam:WorldToViewportPoint(rootPos - Vector3.new(0, e.feetDrop, 0))
			local hw = e.head and e.head.Parent and e.head.Position or (rootPos + Vector3.new(0, 1.5, 0))
			local head = cam:WorldToViewportPoint(hw + Vector3.new(0, e.headUp, 0))
			local function onS(v) return v.Z > 0 and v.X > -200 and v.X < vp.X + 200 and v.Y > -200 and v.Y < vp.Y + 200 end
			if not (onS(feet) or onS(head)) then
				e.why = "off screen"
				ESP.setShown(e, false)
			else
				e.why = "shown"
				if e.ver ~= EZ.ver then ESP.layout(e) end
				-- colour every frame: team green > safe blue > closest-to-crosshair red > white
				local st = ESP.stat[p]
				local col = S.Friends[p.Name] and CC.TEAM or (st and st.safe and CC.SAFE) or ((S.TargetHL and p == (AIM.target or AIM.near)) and CC.RED or CC.WHITE)
				if e.cCol ~= col then e.cCol = col e.nameLbl.TextColor3 = col e.infoLbl.TextColor3 = col end
				-- viewport -> our gui pixels (fixes the sideways shift on notched / wide phones)
				local o = ESP.off
				e.top.Position = UDim2.fromOffset(head.X + o.X, head.Y + o.Y - 2)
				e.bot.Position = UDim2.fromOffset(feet.X + o.X, feet.Y + o.Y + 3)
				ESP.setShown(e, true)
			end
		end
	end
end
C(Run.RenderStepped, function()
	local cam = workspace.CurrentCamera
	if not cam then return end
	ESP.frame += 1
	if not S.ESP then
		if ESP.on then ESP.on = false for _, e in pairs(ESP.e) do ESP.setShown(e, false) ESP.killHL(e) end end
		return
	end
	ESP.on = true
	if S.Boost and ESP.frame % 2 == 1 then return end
	local vp = cam.ViewportSize
	ESP.off = GUIOFF(cam, ESPG)
	local now = os.clock()
	local me = root()
	local myPos = me and me.Position or cam.CFrame.Position
	local maxD = (S.ESPRange >= 10000) and math.huge or S.ESPRange
	local i = 0
	ESP.ctx = ESP.ctx or {}
	local X = ESP.ctx
	X.cam, X.vp, X.now, X.myPos, X.maxD = cam, vp, now, myPos, maxD
	for p, e in pairs(ESP.e) do
		i += 1
		local ok, err = pcall(ESP.one, p, e, i, X)
		if not ok then e.err = tostring(err) e.why = "error" pcall(ESP.setShown, e, false) elseif e.err then e.err = nil end
	end
end)
local notify = function() end   -- set by the UI

-- ================================================================
-- DROPPED GUN ESP: workspace.Dropped.Visual.<GunName> (.Handle)
-- ================================================================
DROP = { lbl = {} }
function DROP.folder(n) local d = workspace:FindFirstChild("Dropped") return d and d:FindFirstChild(n) end
function DROP.pos(o)
	if o:IsA("BasePart") then return o.Position end
	local hd = o:FindFirstChild("Handle")
	if hd and hd:IsA("BasePart") then return hd.Position end
	if o:IsA("Model") then local ok, cf = pcall(o.GetPivot, o) if ok then return cf.Position end end
	local bp = o:FindFirstChildWhichIsA("BasePart", true)
	return bp and bp.Position
end
-- GROUND ESP: Guns (hide by rarity) / Ammo / Misc lists. Money never shows.
DROP.KIND_COL = { Money = Color3.fromRGB(85, 230, 110), Ammo = Color3.fromRGB(235, 205, 95), Misc = Color3.fromRGB(190, 170, 255), ATMs = Color3.fromRGB(60, 225, 175) }
DROP.GUNWORDS = { "rpg", "mp5", "ak47", "ak74", "akm", "ar15", "m4", "m16", "m249", "spaz", "spas", "remington", "anaconda", "glock", "pistol", "rifle", "shotgun",
	"sniper", "uzi", "mac10", "mac11", "tec9", "draco", "deagle", "revolver", "smg", "lmg", "carbine", "scar", "famas", "aug", "p90", "vector",
	"beretta", "colt", "magnum", "barrett", "awp", "mossberg", "kriss", "g17", "g18", "g19", "minigun", "launcher", "musket", "raygun" }
DROP.names = { Guns = {}, Ammo = {}, Misc = {}, Money = {} }   -- name -> true
DROP.catOf = {}                                     -- name -> "Guns" / "Ammo" / "Misc"
DROP.storeGun = {}
function DROP.isMoney(n) n = n:lower() return n:find("cash") or n:find("money") or n:find("dollar") or n:find("%$") end
function DROP.classify(name, model)
	local c = DROP.catOf[name]
	if c then return c end
	local n = name:lower()
	local nn = n:gsub("[^%w]", "")
	if n:find("ammo") then c = "Ammo"
	elseif DROP.isMoney(name) then c = "Money"
	elseif DROP.storeGun[name] then c = "Guns"
	else
		for _, g in ipairs(CC.GOLD_GUNS) do if nn:find(g, 1, true) then c = "Guns" break end end
		if not c then for _, g in ipairs(CC.RED_GUNS) do if nn:find(g, 1, true) then c = "Guns" break end end end
		if not c then for _, g in ipairs(DROP.GUNWORDS) do if nn:find(g, 1, true) then c = "Guns" break end end end
		if not c and model then
			for _, d in ipairs(model:GetDescendants()) do
				local dn = d.Name:lower()
				if dn:find("muzzle") or dn:find("barrel") or dn:find("firepoint") or dn:find("magazine") then c = "Guns" break end
			end
		end
		c = c or "Misc"
	end
	DROP.catOf[name] = c
	if not DROP.names[c][name] then DROP.names[c][name] = true DROP.dirty = true end
	return c
end
function DROP.kind(m) return DROP.classify(m.Name, m) end
-- every item the game has: Assets.Items + the shops' stock lists (+ anything seen on the ground)
function DROP.learn()
	pcall(function()
		local shops = MOD and kid(MOD, "Client", "Controllers", "ShopController", "Shops")
		if shops then
			for _, shop in ipairs(shops:GetChildren()) do
				local gunShop = shop.Name:lower():find("gun") ~= nil
				for _, it in ipairs(shop:GetChildren()) do
					if gunShop and not it.Name:lower():find("ammo") then DROP.storeGun[it.Name] = true end
				end
			end
		end
		local items = kid(GR, "Assets", "Items")
		if items then for _, it in ipairs(items:GetChildren()) do DROP.classify(it.Name, it) end end
		if shops then for _, shop in ipairs(shops:GetChildren()) do
			local sn = shop.Name:lower()
			if not (sn:find("car") or sn:find("dealer")) then
				for _, it in ipairs(shop:GetChildren()) do DROP.classify(it.Name, nil) end
			end
		end end
	end)
	for _, n in ipairs({ "Pistol Ammo", "Rifle Ammo", "Shotgun Ammo", "Explosive Ammo" }) do DROP.names.Ammo[n] = true DROP.catOf[n] = "Ammo" end
	DROP.dirty = true
end
function DROP.list(cat)
	local t = {}
	for n in pairs(DROP.names[cat] or {}) do t[#t + 1] = n end
	table.sort(t)
	table.insert(t, 1, "All " .. cat)
	return t
end
DROP.sel = {}
function DROP.rebuildSel()
	for _, k in ipairs({ "Guns", "Ammo", "Misc", "ATMs" }) do
		local t = {}
		for _, v in ipairs(S.GE[k] or {}) do t[tostring(v)] = true end
		DROP.sel[k] = t
	end
end
DROP.rebuildSel()
-- guns: shown unless you hid their rarity
DROP.RARS = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Exotic" }
function DROP.rarList()
	local t, have = {}, {}
	for _, r in ipairs(DROP.RARS) do t[#t + 1] = r have[RAR.key(r)] = true end
	for _, r in pairs(RAR.byName) do
		local k = RAR.key(r)
		if not have[k] and type(r) == "string" then have[k] = true t[#t + 1] = r:sub(1, 1):upper() .. r:sub(2) end
	end
	t[#t + 1] = "Unknown"
	return t
end
DROP.hideR = {}
function DROP.rebuildHide()
	DROP.hideR = {}
	for _, r in ipairs(S.GEHideRar or {}) do DROP.hideR[RAR.key(r)] = true end
end
DROP.rebuildHide()
function DROP.wants(cat, name)
	if cat == "Money" then return false end   -- money never shows
	if cat == "Guns" then
		if not next(DROP.hideR) then return true end
		local r = RAR.of(name)
		return not DROP.hideR[r and RAR.key(r) or "unknown"]
	end
	local t = DROP.sel[cat]
	return t and (t["All " .. cat] or t[name]) or false
end
function DROP.amount(m)   -- $ / ammo count if the drop says it
	for _, a in ipairs({ "Amount", "Value", "Cash", "Money", "Count", "Quantity" }) do
		local v = m:GetAttribute(a)
		if type(v) == "number" then return v end
		local o = m:FindFirstChild(a)
		if o and (o:IsA("IntValue") or o:IsA("NumberValue")) then return o.Value end
	end
	return nil
end
task.delay(4, DROP.learn)
local function dropLbl(key, store, text, col, size, sp, off)
	local l = store[key]
	if not l then
		l = makeLbl(ESPG, "", size, col)
		l.AnchorPoint, l.Size = Vector2.new(0.5, 0.5), UDim2.fromOffset(220, size + 4)
		store[key] = l
	end
	l.Text = text
	if l.TextSize ~= size then l.TextSize = size end
	l.TextColor3 = col
	l.Position = UDim2.fromOffset(sp.X + off.X, sp.Y + off.Y)
	l.Visible = true
	return l
end
-- [RPG] {20}  - same font / size / colors as the player ESP
C(Run.RenderStepped, function()
	local cam = workspace.CurrentCamera
	local v = DROP.folder("Visual")
	if not (S.ESP and S.DropESP and cam) then
		if next(DROP.lbl) then for m, l in pairs(DROP.lbl) do l:Destroy() DROP.lbl[m] = nil end end
		return
	end
	if S.Boost and ESP.frame % 2 == 1 then return end
	local me = root()
	local myPos = me and me.Position or cam.CFrame.Position
	local off = GUIOFF(cam, ESPG)
	local maxD = S.DropRange
	local size = math.floor(EZ.ToolSize * S.ESPScale + 0.5)
	local seen = {}
	if v then
		for _, m in ipairs(v:GetChildren()) do
			seen[m] = true
			local cat = DROP.kind(m)
			local kind = DROP.isMoney(m.Name) and "Money" or cat
			local l = DROP.lbl[m]
			local p = DROP.wants(cat, m.Name) and DROP.pos(m)
			local sp, on, d
			if p then d = (p - myPos).Magnitude sp, on = cam:WorldToViewportPoint(p) end
			if p and on and d <= maxD then
				local col = kind == "Guns" and gunColor(m.Name) or DROP.KIND_COL[kind] or CC.WHITE
				local amt = (kind == "Money" or kind == "Ammo") and DROP.amount(m)
				local txt
				if kind == "Money" then txt = "[" .. (amt and ("$" .. math.floor(amt)) or m.Name) .. "] {" .. math.floor(d) .. "}"
				else txt = "[" .. m.Name .. (amt and (" x" .. math.floor(amt)) or "") .. "] {" .. math.floor(d) .. "}" end
				dropLbl(m, DROP.lbl, txt, col, size, sp, off)
			elseif l then l.Visible = false end
		end
	end
	for m, l in pairs(DROP.lbl) do if not seen[m] then l:Destroy() DROP.lbl[m] = nil end end
end)

-- ================================================================
-- CAR: stable car + drive through walls
-- ================================================================
local CAR = { nc = {}, t = 0, flipT = 0 }
CAR.op = OverlapParams.new()
CAR.op.FilterType = Enum.RaycastFilterType.Exclude
CAR.box = Instance.new("Part")
CAR.box.Name, CAR.box.Anchored, CAR.box.CanCollide, CAR.box.CanTouch, CAR.box.Transparency = "drixCarBox", true, false, false, 1
pcall(function() CAR.box.CanQuery = false end)
function CAR.cur()
	local hm = hum()
	local s = hm and hm.SeatPart
	if not s then return nil end
	if not (s:IsA("VehicleSeat") or s.Name == "DriverSeat") then return nil end
	local cars = workspace:FindFirstChild("Cars")
	local x = s
	if cars and s:IsDescendantOf(cars) then while x.Parent ~= cars do x = x.Parent end return x, s end
	return s:FindFirstAncestorWhichIsA("Model"), s
end
CAR.under, CAR.uY, CAR.yaw, CAR.surfY, CAR.uc, CAR.orig = false, 0, 0, 0, {}, setmetatable({}, { __mode = "k" })
CAR.onStable = function() end   -- set by the UI (ticks the Stability box)
CAR.rp = RaycastParams.new()
CAR.rp.FilterType = Enum.RaycastFilterType.Exclude
function CAR.engine(car) return car and (car:FindFirstChild("Engine") or car:FindFirstChild("Engine", true)) end
function CAR.topSpeed(car, th)   -- studs/s  (car's normal top speed x Stable Speed slider, max 2x)
	local eng = CAR.engine(car)
	local o = eng and CAR.orig[eng]
	local key = th < 0 and "reverseMaxSpeed" or "forwardMaxSpeed"
	local base = tonumber(o and o[key]) or (eng and tonumber(eng:GetAttribute(key))) or (th < 0 and 30 or 88)
	return base * math.clamp(S.StableSpd, 0.5, 2)
end
function CAR.inObj(car)
	if CAR.iCar == car and CAR.iObj and CAR.iObj.Parent then return CAR.iObj end
	if CAR.iCar == car and os.clock() - (CAR.iT or 0) < 2 then return CAR.iObj end
	CAR.iCar, CAR.iObj, CAR.iT = car, nil, os.clock()
	local list = car:GetDescendants()
	table.insert(list, 1, car)
	for _, d in ipairs(list) do
		local th, st
		for k in pairs(d:GetAttributes()) do
			local l = k:lower()
			if l:find("throttle") then th = k elseif l:find("steer") then st = k end
		end
		if th and st then CAR.iObj, CAR.iTh, CAR.iSt = d, th, st break end
	end
	return CAR.iObj
end
function CAR.input(seat)
	local th, st = 0, 0
	-- the car's own input (its gas / steer buttons write these numbers)
	local car = CAR.cur()
	local io = car and CAR.inObj(car)
	if io then th, st = tonumber(io:GetAttribute(CAR.iTh)) or 0, tonumber(io:GetAttribute(CAR.iSt)) or 0 end
	if math.abs(th) < 0.1 and math.abs(st) < 0.1 and seat:IsA("VehicleSeat") then th, st = seat.ThrottleFloat, seat.SteerFloat end
	if math.abs(th) < 0.1 and math.abs(st) < 0.1 then
		local hm = hum()
		local md = hm and hm.MoveDirection or Vector3.zero
		if md.Magnitude > 0.2 then
			local a, b = md:Dot(seat.CFrame.LookVector), md:Dot(seat.CFrame.RightVector)
			th = math.abs(a) > 0.35 and (a > 0 and 1 or -1) or 0
			st = math.abs(b) > 0.35 and (b > 0 and 1 or -1) or 0
		end
	end
	return (math.abs(th) > 0.1) and (th > 0 and 1 or -1) or 0, (math.abs(st) > 0.1) and (st > 0 and 1 or -1) or 0
end
function CAR.ex(car)
	local ex = { car, CAR.box }
	for _, pl in ipairs(Players:GetPlayers()) do if pl.Character then ex[#ex + 1] = pl.Character end end
	return ex
end
function CAR.setCollide(car, on)
	if on then
		for p, v in pairs(CAR.uc) do if p.Parent then p.CanCollide = v end end
		CAR.uc = {}
	else
		for _, p in ipairs(car:GetDescendants()) do
			if p:IsA("BasePart") and CAR.uc[p] == nil then CAR.uc[p] = p.CanCollide p.CanCollide = false end
		end
	end
end
function CAR.surface(car, seat)
	CAR.under, CAR.kin = false, false
	if not (car and seat and car.Parent) then CAR.uc = {} return end
	local pos = seat.Position
	CAR.rp.FilterDescendantsInstances = CAR.ex(car)
	local hit = workspace:Raycast(Vector3.new(pos.X, CAR.surfY + 60, pos.Z), Vector3.new(0, -140, 0), CAR.rp)
	if hit and hit.Position.Y > CAR.surfY + 25 then   -- landed on a roof: try just above the old road height
		hit = workspace:Raycast(Vector3.new(pos.X, CAR.surfY + 8, pos.Z), Vector3.new(0, -40, 0), CAR.rp) or hit
	end
	local y = (hit and hit.Position.Y or CAR.surfY) + 4
	local look = Vector3.new(seat.CFrame.LookVector.X, 0, seat.CFrame.LookVector.Z)
	if look.Magnitude < 0.1 then look = Vector3.new(0, 0, -1) end
	local rel = seat.CFrame:ToObjectSpace(car:GetPivot())
	local np = Vector3.new(pos.X, y, pos.Z)
	car:PivotTo(CFrame.lookAt(np, np + look.Unit) * rel)
	seat.AssemblyLinearVelocity, seat.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
	CAR.setCollide(car, true)
end
CAR.rising = false
CAR.plat = Instance.new("Part")
CAR.plat.Name, CAR.plat.Anchored, CAR.plat.CanCollide, CAR.plat.CanTouch, CAR.plat.Transparency = "drixUnderRoad", true, true, false, 1
CAR.plat.Size, CAR.plat.Material, CAR.plat.TopSurface = Vector3.new(80, 2, 80), Enum.Material.Asphalt, Enum.SurfaceType.Smooth
CAR.unc = {}                  -- map parts we made pass-through (put back when you come up)
CAR.op2 = OverlapParams.new()
CAR.op2.FilterType = Enum.RaycastFilterType.Exclude
function CAR.putBack() CAR.plat.Parent = nil end
function CAR.restore()
	for p in pairs(CAR.nc) do if p.Parent then p.CanCollide = true end end
	CAR.nc = {}
	CAR.box.Parent = nil
	CAR.kin = false
	CAR.setCollide(nil, true)
end
-- raycast that only stops on SOLID parts (skips invisible zones / non-collide parts)
function CAR.solid(o, d, car)
	local ex = CAR.ex(car)
	for _, n in ipairs({ "Pedestrians", "Dropped", "GunIgnore" }) do local f = workspace:FindFirstChild(n) if f then ex[#ex + 1] = f end end
	for _ = 1, 6 do
		CAR.rp.FilterDescendantsInstances = ex
		local h = workspace:Raycast(o, d, CAR.rp)
		if not h then return nil end
		local pt = h.Instance
		if pt == CAR.plat or pt:IsA("Terrain") or (pt.CanCollide and pt.Transparency < 0.95) then return h end
		ex[#ex + 1] = pt
	end
	return nil
end
C(Run.Heartbeat, function(dt)
	-- STABLE = ground glide (same feel as underground): no acceleration, instant turns,
	-- glued to the road at the car's normal height, stops at walls (never drives through them)
	if not S.StableCar then
		if CAR.kin then CAR.kin = false CAR.setCollide(nil, true) end
		return
	end
	local car, seat = CAR.cur()
	if not car then
		if CAR.kin then CAR.kin = false CAR.setCollide(nil, true) end
		return
	end
	if not CAR.kin or CAR.sCar ~= car then
		if CAR.sCar and CAR.sCar ~= car then CAR.setCollide(nil, true) end
		CAR.kin, CAR.sCar = true, car
		if CAR.under then
			CAR.ride = CAR.rideSeat or 3
		else
			local g = CAR.solid(seat.Position + Vector3.new(0, 2, 0), Vector3.new(0, -30, 0), car)
			CAR.ride = g and math.clamp(seat.Position.Y - g.Position.Y, 1, 8) or 3
		end
		local lk = seat.CFrame.LookVector
		CAR.yaw = math.atan2(-lk.X, -lk.Z)
		CAR.gY, CAR.nrm, CAR.ncT = seat.Position.Y, Vector3.yAxis, 0
		local _, bsz = car:GetBoundingBox()
		CAR.half = math.clamp(math.max(bsz.X, bsz.Z) / 2, 3, 14)
	end
	dt = math.min(dt, 0.1)
	local th, st = CAR.input(seat)
	local spd = CAR.topSpeed(car, th)
	local turn = st * 2.6 * (th < 0 and -1 or 1)
	CAR.yaw -= turn * dt
	local look = Vector3.new(-math.sin(CAR.yaw), 0, -math.cos(CAR.yaw))
	local p0 = seat.Position
	local move = look * th * spd * dt
	local groundY = CAR.gY - CAR.ride
	if th ~= 0 and not CAR.under then   -- wall in front (above curb height) -> stop
		for _, hgt in ipairs({ 1.8, 3.5 }) do
			local o = Vector3.new(p0.X, groundY + hgt, p0.Z)
			local w = CAR.solid(o, look * th * (CAR.half + move.Magnitude + 1), car)
			if w and math.abs(w.Normal.Y) < 0.6 then move = Vector3.zero break end
		end
	end
	local np = Vector3.new(p0.X, 0, p0.Z) + move
	local g = (not CAR.under) and CAR.solid(Vector3.new(np.X, CAR.gY + 4, np.Z), Vector3.new(0, -(CAR.ride + 40), 0), car) or nil
	local ty = CAR.gY
	if CAR.under then   -- underground: locked flat at the snap depth, nothing can push it up or down
		ty, CAR.nrm = CAR.platY + CAR.ride, Vector3.yAxis
		CAR.gY = ty
	elseif g then
		ty = g.Position.Y + CAR.ride
		if ty - CAR.gY > 3 then   -- too high to climb = wall
			np, move, ty = Vector3.new(p0.X, 0, p0.Z), Vector3.zero, CAR.gY
		elseif g.Normal.Y > 0.6 then
			CAR.nrm = CAR.nrm:Lerp(g.Normal, math.min(1, dt * 10))
		end
	else
		ty = CAR.gY - 60 * dt   -- nothing under: drop down
	end
	CAR.gY += (ty - CAR.gY) * math.min(1, dt * 18)
	local up = CAR.nrm.Magnitude > 0.1 and CAR.nrm.Unit or Vector3.yAxis
	local fwd = look - up * look:Dot(up)
	fwd = fwd.Magnitude > 0.1 and fwd.Unit or look
	local pos = Vector3.new(np.X, CAR.gY, np.Z)
	local rel = seat.CFrame:ToObjectSpace(car:GetPivot())
	car:PivotTo(CFrame.lookAt(pos, pos + fwd, up) * rel)
	seat.AssemblyLinearVelocity = dt > 0 and (move / dt) or Vector3.zero
	seat.AssemblyAngularVelocity = Vector3.new(0, -turn, 0)
	if os.clock() - CAR.ncT > 0.5 then CAR.ncT = os.clock() CAR.setCollide(car, false) end
end)

-- car config: writes your numbers into the car's Engine settings (restores them when off)
task.spawn(function()
	local last
	while ALIVE do
		local car = CAR.cur()
		local eng = CAR.engine(car)
		if eng then
			if S.CarCfg then
				if not CAR.orig[eng] then CAR.orig[eng] = eng:GetAttributes() end
				local o = CAR.orig[eng]
				local function set(k, v) if o[k] ~= nil and eng:GetAttribute(k) ~= v then pcall(eng.SetAttribute, eng, k, v) end end
				if tonumber(o.forwardMaxSpeed) then set("forwardMaxSpeed", o.forwardMaxSpeed * math.clamp(S.CarTopX, 1, 2)) end
				if tonumber(o.reverseMaxSpeed) then set("reverseMaxSpeed", o.reverseMaxSpeed * math.clamp(S.CarRevX, 1, 2)) end
				if tonumber(o.acceleration) then set("acceleration", o.acceleration * math.clamp(S.CarAccel, 1, 2)) end
				if tonumber(o.nitroTime) then set("nitroTime", o.nitroTime * math.clamp(S.CarNitro, 1, 2)) end
				last = eng
			elseif CAR.orig[eng] then
				for k, v in pairs(CAR.orig[eng]) do pcall(eng.SetAttribute, eng, k, v) end
				CAR.orig[eng] = nil
			end
		end
		task.wait(0.5)
	end
end)
-- driving fast: the game's car camera widens the FOV -> keep it normal (70) while you're in a car
pcall(function() Run:UnbindFromRenderStep("drixCarFov") end)
Run:BindToRenderStep("drixCarFov", Enum.RenderPriority.Last.Value - 1, function()
	if not (ALIVE and S.CarFov) then return end
	local cam = workspace.CurrentCamera
	if cam and cam.FieldOfView > 70.5 and CAR.cur() then cam.FieldOfView = 70 end
end)
-- (noclip removed)

-- ================================================================
-- SHOP + STOCK + AUTO BUY  (presses the shop's own buttons)
-- ================================================================
local CAR_LIST = { "Golf Cart", "Civic", "F-150", "Jeep", "300 SRT", "Lowrider", "Tahoe", "R-Wagon", "SRT", "Huracan", "Royce", "Cybertruck", "SF90", "SVJ" }
local SHOP = { stock = {}, price = {}, items = {}, lastBuy = {}, bought = {}, busy = false, reps = {}, rsRefs = {}, isCar = {}, campMsg = "" }
for _, n in ipairs(CAR_LIST) do SHOP.isCar[n:lower()] = true end
SHOP.SPOTS = { Gun = { Vector3.new(452.18, 6, 448.06), Vector3.new(412.35, 6, 1280.38) }, Car = { Vector3.new(174.43, 6, 491.13) },
	General = { Vector3.new(838.35, 6, 455.94), Vector3.new(209.99, 6, 821.63) }, Illegal = { Vector3.new(414.1, 6, 471.6) } }
SHOP.NPCNAME = { Gun = "gunshop", Car = "carshop", General = "generalshop", Illegal = "illegal" }
SHOP.where = {}
-- every shop menu the game has (gun, car, general, illegal ...)
function SHOP.storeFrames()
	local out = {}
	local frames = kid(PG, "UI", "Frames")
	if frames then
		for _, f in ipairs(frames:GetChildren()) do
			local n = f.Name:lower()
			if n:find("ammo") or (n:find("store") or n:find("shop") or n:find("illegal") or n:find("general") or n:find("dealer"))
				and not (n:find("barber") or n:find("robux") or n:find("crate") or n:find("skin") or n:find("cloth")) then out[#out + 1] = f end
		end
	end
	return out
end
function SHOP.kindOf(name)
	local n = tostring(name):lower()
	if n:find("ammo") then return "Ammo" elseif n:find("gun") then return "Gun" elseif n:find("car") or n:find("dealer") then return "Car"
	elseif n:find("illegal") then return "Illegal" elseif n:find("general") then return "General" end
end
local function clean(t) return (tostring(t):gsub("<[^>]->", ""):gsub("^%s+", ""):gsub("%s+$", "")) end
function SHOP.wanted(name)
	if not name then return false end
	local nl = name:lower()
	for _, w in ipairs(S.BuyList) do if w:lower() == nl then return true end end
	return false
end
-- stock data the game keeps (Replion / values) - read only
task.spawn(function()
	local t0 = os.clock()
	while not G.Replion and os.clock() - t0 < 15 do task.wait(0.5) end
	if G.Replion then
		for _, n in ipairs({ "GunStore", "GunStock", "GunShop", "Stock", "Stocks", "Shop", "Shops", "Store", "ShopStock", "Dealership", "CarStore", "CarStock", "CarShop", "Restock", "Global", "Server" }) do
			local ok, rep = pcall(function() return G.Replion.Client:GetReplion(n) end)
			if ok and rep then SHOP.reps[n] = rep log("stock data found: Replion " .. n) end
		end
	end
	local stack, ts = { RS }, os.clock()
	while #stack > 0 and ALIVE do
		local i = table.remove(stack)
		if i:IsA("ValueBase") and i.Name:lower():find("stock") then SHOP.rsRefs[#SHOP.rsRefs + 1] = i end
		local okA, at = pcall(function() return i:GetAttributes() end)
		if okA then for k in pairs(at) do if k:lower() == "stock" or k:lower() == "instock" then SHOP.rsRefs[#SHOP.rsRefs + 1] = i break end end end
		for _, c in ipairs(i:GetChildren()) do stack[#stack + 1] = c end
		if os.clock() - ts > 0.003 then task.wait() ts = os.clock() end
	end
	log("stock values in ReplicatedStorage: " .. #SHOP.rsRefs)
end)
local function walkStock(t, depth, out)
	if depth > 3 then return end
	for k, v in pairs(t) do
		if type(k) == "string" then
			local kl = k:lower()
			if type(v) == "number" and depth > 0 and not kl:find("time") and not kl:find("restock") then out[k] = v
			elseif type(v) == "table" then
				local s = rawget(v, "Stock") or rawget(v, "stock") or rawget(v, "Amount") or rawget(v, "Quantity") or rawget(v, "Count")
				if tonumber(s) then out[k] = tonumber(s) else walkStock(v, depth + 1, out) end
			end
		end
	end
end
-- the open shop menu
function SHOP.frame()
	local cands = {}
	local frames = kid(PG, "UI", "Frames")
	if frames then for _, f in ipairs(frames:GetChildren()) do if f:IsA("GuiObject") and f.Visible then cands[#cands + 1] = f end end end
	for _, g in ipairs(PG:GetChildren()) do
		if g:IsA("LayerCollector") and g.Enabled and not isOurs(g) and g.Name ~= "TouchGui" and g.Name ~= "UI" and g.Name ~= "Prompt" then cands[#cands + 1] = g end
	end
	local best, bn = nil, 0
	for _, f in ipairs(cands) do
		local nm = f.Name:lower()
		if not (nm:find("inventory") or nm:find("hud") or nm:find("chat") or nm:find("notif") or nm:find("atm") or nm:find("bank")) then
			local n = 0
			for _, d in ipairs(f:GetDescendants()) do
				if (d:IsA("TextLabel") or d:IsA("TextButton")) and d.Text:find("%$%s*[%d,]+") and shown(d) then n += 1 if n > 12 then break end end
			end
			local bonus = (nm:find("shop") or nm:find("store") or nm:find("gun") or nm:find("dealer") or nm:find("car")) and 3 or 0
			if n >= 2 and n + bonus > bn then best, bn = f, n + bonus end
		end
	end
	return best
end
local RARITY = { common = true, uncommon = true, rare = true, epic = true, legendary = true, mythic = true, exotic = true, secret = true, limited = true }
local TEMPLATE = { gamepass = true, template = true, item = true, sample = true, example = true }
local function underRobux(d, e)
	local x = d
	while x and x ~= e do if x.Name:lower():find("robux") then return true end x = x.Parent end
	return false
end
local function parseEntry(e)
	if TEMPLATE[e.Name:lower()] then return nil end
	local bf = e:FindFirstChild("BUY Button") or e:FindFirstChild("BuyButton") or e:FindFirstChild("Buy")
	if bf and bf:IsA("GuiObject") and not bf.Visible then return nil end   -- Robux-only item
	local price, stock, btn, label
	for _, d in ipairs(e:GetDescendants()) do
		if not underRobux(d, e) then
			if d:IsA("TextLabel") or d:IsA("TextButton") then
				local t = clean(d.Text)
				local tl = t:lower()
				if tl:find("no stock") or tl:find("out of stock") or tl:find("sold out") then stock = 0
				elseif tl:find("stock") then local n = tonumber(tl:match("(%d+)")) if n then stock = n end
				elseif t:find("%$") then price = price or tonumber((t:gsub("[^%d]", "")))
				elseif #t >= 2 and not RARITY[tl] and not label then label = t end
			end
			if d:IsA("GuiButton") and not btn and bf and (d == bf or d:IsDescendantOf(bf)) then btn = d end
		end
	end
	if not btn and bf and bf:IsA("GuiButton") then btn = bf end
	if not btn then
		for _, d in ipairs(e:GetDescendants()) do
			if d:IsA("GuiButton") and not underRobux(d, e) then
				local bt = btnText(d)
				if (bt:find("buy") or bt:find("purchase") or bt:find("open")) and not bt:find("robux") then btn = d break end
			end
		end
	end
	local name = e.Name
	if name:lower() == "frame" or name == "" then name = label end
	return name, price, stock, btn
end
function SHOP.entries(f)
	local out, seen = {}, {}
	for _, lay in ipairs(f:GetDescendants()) do
		if (lay:IsA("UIGridLayout") or lay:IsA("UIListLayout")) and lay.Parent and not seen[lay.Parent] then
			seen[lay.Parent] = true
			for _, e in ipairs(lay.Parent:GetChildren()) do
				if e:IsA("GuiObject") and e.Visible then
					local name, price, stock, btn = parseEntry(e)
					if name and (price or stock) then out[#out + 1] = { name = name, price = price or 0, stock = stock, btn = btn, e = e } end
				end
			end
		end
	end
	return out
end
function SHOP.refresh()
	for _, sf in ipairs(SHOP.storeFrames()) do
		local k = SHOP.kindOf(sf.Name)
		pcall(function()
			for _, e in ipairs(SHOP.entries(sf)) do
				if k then SHOP.where[e.name:lower()] = k end
				SHOP.price[e.name] = e.price
				if e.stock then SHOP.stock[e.name] = e.stock end
				if not table.find(SHOP.items, e.name) then SHOP.items[#SHOP.items + 1] = e.name end
			end
		end)
	end
	local f = SHOP.frame()
	if f then
		for _, e in ipairs(SHOP.entries(f)) do
			SHOP.price[e.name] = e.price
			if e.stock then SHOP.stock[e.name] = e.stock end
			if not table.find(SHOP.items, e.name) then SHOP.items[#SHOP.items + 1] = e.name end
		end
	end
	for _, rep in pairs(SHOP.reps) do
		local out = {}
		pcall(function() walkStock(rep.Data or {}, 0, out) end)
		for k, v in pairs(out) do SHOP.stock[k] = v if not table.find(SHOP.items, k) then SHOP.items[#SHOP.items + 1] = k end end
	end
	SHOP.restock = SHOP.restock or {}
	local shops = MOD and kid(MOD, "Client", "Controllers", "ShopController", "Shops")
	if shops then
		for _, st in ipairs(shops:GetChildren()) do
			for _, v in ipairs(st:GetChildren()) do
				if v:IsA("ValueBase") and tonumber(v.Value) then
					if v.Name:lower():find("restock") then SHOP.restock[st.Name] = tonumber(v.Value)
					else SHOP.stock[v.Name] = tonumber(v.Value) if not table.find(SHOP.items, v.Name) then SHOP.items[#SHOP.items + 1] = v.Name end end
				end
			end
			for k, v in pairs(st:GetAttributes()) do
				if tonumber(v) then
					if k:lower():find("restock") then SHOP.restock[st.Name] = tonumber(v)
					else SHOP.stock[k] = tonumber(v) if not table.find(SHOP.items, k) then SHOP.items[#SHOP.items + 1] = k end end
				end
			end
		end
	end
	for _, r in ipairs(SHOP.rsRefs) do
		if r.Parent and not r.Name:lower():find("restock") then
			local v = r:IsA("ValueBase") and r.Value or r:GetAttribute("Stock") or r:GetAttribute("stock") or r:GetAttribute("InStock")
			local name = r:IsA("ValueBase") and (r.Name:lower() == "stock" and r.Parent.Name or r.Name:gsub("[Ss]tock", "")) or r.Name
			if v == true then v = 1 elseif v == false then v = 0 end
			if tonumber(v) and name ~= "" then SHOP.stock[name] = tonumber(v) if not table.find(SHOP.items, name) then SHOP.items[#SHOP.items + 1] = name end end
		end
	end
	for n in pairs(GM.byName) do if not table.find(SHOP.items, n) then SHOP.items[#SHOP.items + 1] = n end end
end
function SHOP.hiddenStore()
	for _, f in ipairs(SHOP.storeFrames()) do
		do
			for _, e in ipairs(SHOP.entries(f)) do
				if SHOP.wanted(e.name) and (e.stock or 0) > 0 then return f end
			end
		end
	end
end
function SHOP.buyEntry(e, entries)
	local before = getNum("Cash")
	if not e.btn then log("buy " .. e.name .. ": no button") return false end
	if not click(e.btn) then tap(e.btn) end
	task.wait(0.4)
	-- the game's "are you sure?" box (UI.Frames.Confirm) - never anything Robux
	local cf = kid(PG, "UI", "Frames", "Confirm")
	if cf and shown(cf) then
		for _, d in ipairs(cf:GetDescendants()) do
			if d:IsA("GuiButton") and shown(d) and not underRobux(d, cf) then
				local t = btnText(d)
				if t:find("confirm") or t:find("%f[%a]yes%f[%A]") or t:find("accept") or t:find("purchase") or t:find("%f[%a]buy%f[%A]") then click(d) task.wait(0.4) break end
			end
		end
	end
	task.wait(0.7)
	local after = getNum("Cash")
	local ok = before ~= nil and after ~= nil and after < before
	log("buy " .. e.name .. (ok and (" -> paid $" .. (before - after)) or " -> cash didn't change"))
	return ok
end
function SHOP.doneAll()
	for _, n in ipairs(S.BuyList) do if (SHOP.bought[n:lower()] or 0) < S.BuyMax then return false end end
	return true
end
function SHOP.npcPos(kind)
	local h = root()
	local best, bd
	local npcs = workspace:FindFirstChild("NPCs")
	local list = {}
	if npcs then
		for _, m in ipairs(npcs:GetChildren()) do
			if m.Name:lower():find(SHOP.NPCNAME[kind] or (kind:lower() .. "shop")) then local p = posOf(m) if p then list[#list + 1] = p end end
		end
	end
	for _, p in ipairs(SHOP.SPOTS[kind] or {}) do list[#list + 1] = p end
	for _, p in ipairs(list) do
		local d = h and (p - h.Position).Magnitude or 0
		if not bd or d < bd then best, bd = p, d end
	end
	return best
end
function SHOP.fireNPC(at)
	local npcs = workspace:FindFirstChild("NPCs")
	if not npcs then return false end
	for _, d in ipairs(npcs:GetDescendants()) do
		if d.Name == "PromptDirect" and d:IsA("ObjectValue") and d.Value and d.Value:IsA("ModuleScript") then
			local p = posOf(d.Parent)
			if p and (p - at).Magnitude < 20 then
				local ok, mod = safeRequire(d.Value, 2)
				local f = type(mod) == "function" and mod or (type(mod) == "table" and (mod.OnPrompt or mod.Prompt or mod.Triggered or mod.Interact or mod.Open or mod.Event))
				if ok and f then local ok2, e = pcall(f, d.Parent) log("shop prompt module: " .. (ok2 and "ok" or tostring(e))) return ok2 end
			end
		end
	end
	if VIM then pcall(function() VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game) task.wait(0.4) VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game) end) end
	return false
end
-- go to the shop (under the map), open it and wait there
function SHOP.camp()
	local kind
	for _, n in ipairs(S.BuyList) do
		local k = n:lower()
		if (SHOP.bought[k] or 0) < S.BuyMax then kind = SHOP.where[k] or (SHOP.isCar[k] and "Car") or "Gun" break end
	end
	if not kind then return end
	local spot = SHOP.npcPos(kind)
	local h = root()
	if not (spot and h) then return end
	SHOP.busy = true
	local tok = newTok()
	if (h.Position - spot).Magnitude > 16 then
		SHOP.campMsg = "Going to the " .. kind:lower() .. " shop"
		local ok = glideTo(spot, tok)
		release()
		if not ok then SHOP.busy = false return end
		task.wait(0.5)
	end
	SHOP.campMsg = "Opening the " .. kind:lower() .. " shop"
	for _ = 1, 6 do
		if SHOP.frame() then break end
		if promptGui() then pressPromptUI(0.4) else SHOP.fireNPC(spot) end
		task.wait(0.7)
	end
	SHOP.campMsg = SHOP.frame() and ("Waiting at the " .. kind:lower() .. " shop for stock") or "Couldn't open the shop - walk up to it once"
	SHOP.busy = false
end
task.spawn(function()
	while ALIVE do
		task.wait(1)
		if S.AutoBuy then pcall(SHOP.refresh) end
		if S.AutoBuy and #S.BuyList > 0 and not SHOP.busy and alive() and not SHOP.doneAll() then
			local f = SHOP.frame()
			local hidden = false
			if not f and S.BuyAnywhere and not SHOP.anyFail then f = SHOP.hiddenStore() hidden = f ~= nil end
			if f then
				local entries = SHOP.entries(f)
				for _, e in ipairs(entries) do
					local key = e.name:lower()
					local st = e.stock or SHOP.stock[e.name]
					if SHOP.wanted(e.name) and e.btn and e.price > 0 and (st == nil or st > 0) and (SHOP.bought[key] or 0) < S.BuyMax and os.clock() - (SHOP.lastBuy[key] or 0) > (hidden and 20 or 4) then
						local cash = getNum("Cash")
						if not cash or cash - e.price >= S.KeepCash then
							SHOP.lastBuy[key] = os.clock()
							SHOP.busy = true
							local ok = SHOP.buyEntry(e, entries)
							SHOP.busy = false
							if ok then
								SHOP.bought[key] = (SHOP.bought[key] or 0) + 1
								notify("Auto Buy", "Bought " .. e.name .. " for $" .. tostring(e.price), "shopping-cart")
							elseif hidden then
								SHOP.hiddenFails = (SHOP.hiddenFails or 0) + 1
								if SHOP.hiddenFails >= 2 then
									SHOP.anyFail = true
									notify("Auto Buy", "The game needs you at the shop - turn on Wait At The Shop", "x")
								end
							end
							break
						end
					end
				end
			end
			if not f or hidden then
				if S.CampShop and not SHOP.busy and not SHOP.doneAll() then pcall(SHOP.camp) end
			end
		end
	end
end)

-- ================================================================
-- AUTO SKIP CRATE (always on): any "Skip" button that shows up is pressed instantly
-- SPAM BUY: stand in the shop circle -> spams the buy button of what you picked (per category)
-- ================================================================
SB = { CATS = { "Guns", "Ammo", "Cars", "Armor", "General", "Illegal" }, seen = {}, n = 0, skips = 0, msg = "", list = {}, dirty = true, lastSkip = setmetatable({}, { __mode = "k" }), newAmmo = false }
for _, k in ipairs(SB.CATS) do SB.seen[k] = {} end
-- Skip changed signals across updates. Fire every normal GUI activation signal
-- once so the actual skip handler runs as well as its press/release animation.
function SB.fireAll(b)
	if not (b and b:IsA("GuiButton")) then return false end
	local did = false
	if getconnections then
		for _, signalName in ipairs({ "MouseButton1Down", "MouseButton1Up", "MouseButton1Click", "Activated" }) do
			local okC, conns = pcall(getconnections, b[signalName])
			if okC and type(conns) == "table" then
				for _, c in ipairs(conns) do
					local okF = pcall(function()
						if c.Fire then c:Fire() elseif c.Function then task.spawn(c.Function) end
					end)
					did = did or okF
				end
			end
		end
	end
	if not did and firesignal then
		pcall(firesignal, b.MouseButton1Down)
		pcall(firesignal, b.MouseButton1Up)
		pcall(firesignal, b.MouseButton1Click)
		did = true
	end
	return did
end
function SB.cat(name, frameName)
	local n = tostring(name):lower()
	if n:find("ammo") or n:find("bullet") or n:find("rounds") or n:find("magazine") or n:find("shells?$") or n:find("%d+%s?mm") or n:find("%d+%s?gauge") or n:find("%d%s?cal") or n:find("acp") then return "Ammo" end
	if SHOP.kindOf(frameName or "") == "Ammo" then return "Ammo" end
	if n:find("vest") or n:find("armor") or n:find("armour") or n:find("kevlar") or n:find("helmet") or n:find("plate carrier") then return "Armor" end
	if SHOP.isCar[n] then return "Cars" end
	local k = SHOP.kindOf(frameName or "")
	if k == "Car" then return "Cars" elseif k == "Gun" then return "Guns" elseif k == "Illegal" then return "Illegal" elseif k == "General" then return "General" end
	if GM.byName and GM.byName[name] then return "Guns" end
	if n:find("crate") then return "Guns" end
	return "General"
end
function SB.confirm()
	local cf = kid(PG, "UI", "Frames", "Confirm")
	if not (cf and shown(cf)) then return end
	for _, d in ipairs(cf:GetDescendants()) do
		if d:IsA("GuiButton") and shown(d) and not underRobux(d, cf) then
			local t = btnText(d)
			if t:find("confirm") or t:find("%f[%a]yes%f[%A]") or t:find("accept") or t:find("purchase") or t:find("%f[%a]buy%f[%A]") then click(d) return end
		end
	end
end
-- INSTANT BUY: you press Buy / Open yourself -> the crate's Skip button gets pressed the moment it shows up.
-- Pressed ONCE per time it appears (one retry if it's still there) so the shop never bugs.
function SB.noteSkip(d)
	if not (d and d:IsA("GuiButton")) or isOurs(d) or SB.skipSet[d] then return end
	local tx = btnText(d)
	if tx:find("skip") and not tx:find("robux") then SB.skipSet[d] = true SB.list[#SB.list + 1] = d end
end
SB.skipSet = setmetatable({}, { __mode = "k" })
C(PG.DescendantAdded, function(d)
	if d:IsA("GuiButton") then task.defer(SB.noteSkip, d) end
end)
function SB.zeroCrate()
	pcall(function()
		if not (SB.fovNV and SB.fovNV.Parent) then SB.fovNV = RS:FindFirstChild("CrateUnbox", true) end
		if SB.fovNV and SB.fovNV:IsA("NumberValue") and SB.fovNV.Value ~= 0 then SB.fovNV.Value = 0 end
	end)
end
function SB.armMute()
	local cam = workspace.CurrentCamera
	SB.muteT = os.clock() + 4.5
	SB.muteFov = cam and cam.FieldOfView or 70
	SB.lastCam = cam and cam.CFrame.Position
end
function SB.touchSkip(btn)
	if SB.skipTouchBusy or not (btn and btn.Parent and btn:IsA("GuiButton") and shown(btn)) then return false end
	SB.skipTouchBusy = true
	task.spawn(function()
		local didGameplay = false
		-- Current crate mechanics attach the real skip callback to MouseButton1Up.
		-- Fire the CrateUnbox connection itself; ignore the generic UI tween handler.
		if getconnections then
			local okC, conns = pcall(getconnections, btn.MouseButton1Up)
			if okC and type(conns) == "table" then
				for _, c in ipairs(conns) do
					local f, src = c.Function, ""
					if f and debug and debug.info then pcall(function() src = tostring(debug.info(f, "s")) end) end
					if src:find("CrateUnbox", 1, true) then
						local okF = pcall(function() if c.Fire then c:Fire() else task.spawn(f) end end)
						didGameplay = didGameplay or okF
					end
				end
			end
		end
		-- Fallback for a future build that moves the callback away from MouseButton1Up.
		if not didGameplay then
			local p = btn.AbsolutePosition + btn.AbsoluteSize / 2
			local ok = pcall(function()
				local vim = game:GetService("VirtualInputManager")
				vim:SendTouchEvent(0, Enum.UserInputState.Begin, p.X, p.Y)
				task.wait(0.06)
				vim:SendTouchEvent(0, Enum.UserInputState.End, p.X, p.Y)
			end)
			if not ok then
				pcall(function()
					local vu, cam = game:GetService("VirtualUser"), workspace.CurrentCamera
					vu:Button1Down(Vector2.new(p.X, p.Y), cam and cam.CFrame or CFrame.new())
					task.wait(0.06)
					vu:Button1Up(Vector2.new(p.X, p.Y), cam and cam.CFrame or CFrame.new())
				end)
			end
		end
		task.wait(0.04)
		SB.skipTouchBusy = false
	end)
	return true
end
function SB.hideCrate()
	local skipF = kid(PG, "UI", "Hud", "Skip")
	if skipF and skipF.Visible and shown(skipF) then
		local now = os.clock()
		local btn = skipF:FindFirstChild("Skip")
		if btn and btn:IsA("GuiButton") and now - (SB.lastSkipTouch or 0) > 0.12 then
			SB.lastSkipTouch = now
			if SB.touchSkip(btn) then SB.skips += 1 end
		end
		SB.skipHeld = true
	else
		if SB.skipHeld then SB.zeroCrate() end
		SB.skipHeld = false
	end
	if not (SB.muteT and os.clock() < SB.muteT) then return end
	SB.zeroCrate()
	local cam = workspace.CurrentCamera
	if not cam then return end
	if SB.muteFov and SB.fovNV and SB.fovNV.Value ~= 0 and math.abs(cam.FieldOfView - SB.muteFov) > 6 then cam.FieldOfView = SB.muteFov end
	-- only undo a sudden camera teleport (the crate pulling you across the map), not normal walking
	if SB.lastCam and (cam.CFrame.Position - SB.lastCam).Magnitude > 30 then
		cam.CFrame = CFrame.new(SB.lastCam) * (cam.CFrame - cam.CFrame.Position)
	else
		SB.lastCam = cam.CFrame.Position
	end
	for _, c in ipairs(cam:GetChildren()) do
		local n = c.Name:lower()
		if n:find("crate") or n:find("unbox") then pcall(function() c:Destroy() end) end
	end
end
task.spawn(function()
	local all = PG:GetDescendants()
	for i = 1, #all do
		if all[i]:IsA("GuiButton") then SB.noteSkip(all[i]) end
		if i % 160 == 0 then task.wait() end
	end
	while ALIVE do
		SB.hideCrate()
		for _, b in ipairs(SB.list) do
			if b.Parent and b.Visible and shown(b) then
				local now = os.clock()
				if now - (SB.lastSkip[b] or 0) > 0.12 then
					SB.lastSkip[b] = now
					SB.touchSkip(b)
				end
			else
				SB.lastSkip[b] = nil
			end
		end
		task.wait(0.05)
	end
end)
-- CRATE BUY FROM THE MENU (from the shop scan): the game's Buy code (ShopHandler) calls RF/ShopFunction:InvokeServer(...)
-- then plays the crate. We learn WHAT it sends (by giving its Buy code a fake remote for a moment - nothing is sent,
-- nothing is bought), save it, and the menu's Buy Crate button sends exactly that = buy with no crate at all.
SB.cr = { tries = {}, rf = nil, n = 0, fail = 0, flying = 0, msg = "", lastTitle = nil, onLearn = nil }
local function crEnc(v)
	if typeof(v) == "Instance" then
		local chain, x = {}, v
		while x and x.Parent and x.Parent ~= game do table.insert(chain, 1, x.Name) x = x.Parent end
		if not x then return nil end
		return { __i = x.ClassName, p = chain }
	end
	local t = type(v)
	if t == "string" or t == "number" or t == "boolean" then return v end
	if t == "table" then local o = {} for k, x in pairs(v) do o[k] = crEnc(x) end return o end
	return nil
end
local function crDec(v)
	if type(v) == "table" and v.__i then
		local ok, sv = pcall(game.GetService, game, v.__i)
		local x = ok and sv
		for _, n in ipairs(v.p or {}) do x = x and x:FindFirstChild(n) end
		return x
	end
	if type(v) == "table" then local o = {} for k, x in pairs(v) do o[k] = crDec(x) end return o end
	return v
end
function SB.crRF()
	if SB.cr.rf and SB.cr.rf.Parent then return SB.cr.rf end
	local net = MOD and kid(MOD, "Packages", "_Index", "sleitnick_net@0.2.0", "net")
	SB.cr.rf = net and net:FindFirstChild("RF/ShopFunction")
	return SB.cr.rf
end
-- learn the crate that's in front of you right now
function SB.crLearn(f, title)
	local gu, su = getupvalues or (debug and debug.getupvalues), setupvalue or (debug and debug.setupvalue)
	if not (gu and su) then return false end
	local ups = gu(f)
	local idx, rf, pidx, pmod
	local before = {}
	for i, u in pairs(ups) do
		if typeof(u) == "Instance" and u:IsA("RemoteFunction") and u.Name:find("ShopFunction") then idx, rf = i, u end
		if type(u) == "table" and type(rawget(u, "PromptPurchase")) == "function" then pidx, pmod = i, u end
		if type(u) == "boolean" then before[i] = u end
	end
	if not idx then return false end
	SB.cr.rf = rf
	local got
	local fake = setmetatable({}, { __index = function(_, k)
		if k == "InvokeServer" then return function(_, ...) got = table.pack(...) error("drix_learn", 0) end end
		local ok, v = pcall(function() return rf[k] end)
		return ok and v or nil
	end })
	su(f, idx, fake)
	if pidx then su(f, pidx, { PromptPurchase = function() error("drix_learn", 0) end, Init = function() end }) end   -- never a Robux prompt
	local th = task.spawn(function() pcall(f) end)
	local t0 = os.clock()
	while not got and os.clock() - t0 < 1 and coroutine.status(th) ~= "dead" do task.wait() end
	if coroutine.status(th) ~= "dead" then pcall(task.cancel, th) end
	su(f, idx, rf)
	if pidx then su(f, pidx, pmod) end
	for i, v in pairs(before) do pcall(su, f, i, v) end
	if not got then return false end
	local args = {}
	for i = 1, got.n do args[i] = crEnc(got[i]) end
	-- ammo or not: the shop type the game is on right now (Car / Gun / Jewellery / Ammo) or "ammo" in what it sends
	local kind = "Other"
	for _, u in pairs(gu(f)) do if u == "Ammo" then kind = "Ammo" end end
	local first
	for i = 1, got.n do
		if type(got[i]) == "string" then
			first = first or got[i]
			if got[i]:lower():find("ammo") then kind = "Ammo" end
		end
	end
	if title:lower():find("ammo") then kind = "Ammo" end
	local raw = title
	if first and first ~= title and not title:find(first, 1, true) then title = title .. " - " .. first end
	local old = S.Crates[title]
	S.Crates[title] = { a = args, k = kind, t = raw }
	save()
	if not old then
		local s2 = {} for i = 1, got.n do s2[#s2 + 1] = tostring(got[i]) end
		log("crate learned: " .. title .. " -> " .. table.concat(s2, ", "))
		SB.cr.msg = "learned " .. tostring(title) .. " [" .. SB.argShape(args) .. "]"
		if SB.cr.onLearn then pcall(SB.cr.onLearn, title) end
		task.defer(function() pcall(SB.crFill) end)
	end
	return true
end
-- ALL ammo crates: every ammo type the game has, made from a crate you already have (same buy, other ammo name)
SB.AMMO_ALL = { "Pistol Ammo", "Rifle Ammo", "Shotgun Ammo", "Explosive Ammo" }
function SB.ammoNames()
	local t, seen = {}, {}
	local function add(n)
		n = tostring(n)
		if n:lower():find("ammo") and #n < 40 and not seen[n:lower()] then seen[n:lower()] = true t[#t + 1] = n end
	end
	for _, n in ipairs(SB.AMMO_ALL) do add(n) end
	pcall(function() for _, v in ipairs(kid(MOD, "Client", "Controllers", "ShopController", "Shops", "GunStore"):GetChildren()) do add(v.Name) end end)
	pcall(function() for _, v in ipairs(kid(GR, "Assets", "Items"):GetChildren()) do add(v.Name) end end)
	return t
end
-- swap an ammo name inside the saved buy (handles "Rifle Ammo", "RifleAmmo", "Rifle_Ammo")
function SB.subst(v, from, to)
	if type(v) == "string" then
		for _, f in ipairs({ { from, to }, { (from:gsub(" ", "")), (to:gsub(" ", "")) }, { (from:gsub(" ", "_")), (to:gsub(" ", "_")) } }) do
			local i, j = v:lower():find(f[1]:lower(), 1, true)
			if i then return v:sub(1, i - 1) .. f[2] .. v:sub(j + 1), true end
		end
		return v, false
	end
	if type(v) == "table" then
		local o, any = {}, false
		for k, x in pairs(v) do
			local y, hit = SB.subst(x, from, to)
			o[k] = y
			any = any or hit
		end
		return o, any
	end
	return v, false
end
function SB.crFill()
	local names = SB.ammoNames()
	local have, src = {}, {}
	for title, e in pairs(S.Crates) do
		if type(e) == "table" and e.k == "Ammo" and type(e.a) == "table" then
			for _, n in ipairs(names) do
				local _, hit = SB.subst(e.a, n, n)
				if hit then
					have[n:lower()] = true
					if not e.syn then src[#src + 1] = { e = e, n = n, title = title } end
				end
			end
		end
	end
	local added = 0
	for _, s0 in ipairs(src) do
		for _, n in ipairs(names) do
			if not have[n:lower()] then
				local a, hit = SB.subst(s0.e.a, s0.n, n)
				if hit then
					local t0 = tostring(s0.e.t or s0.title)
					local nt, th = SB.subst(t0, s0.n, n)
					if not th then nt = n end
					if not S.Crates[nt] then S.Crates[nt] = { a = a, k = "Ammo", t = nt, syn = true } added += 1 end
					have[n:lower()] = true
				end
			end
		end
	end
	if added > 0 then
		save()
		log("ammo crates added: " .. added)
		if SB.cr.onLearn then pcall(SB.cr.onLearn) end
	end
	return added
end
task.delay(4, function() pcall(SB.crFill) end)
function SB.argShape(a)
	if type(a) ~= "table" then return type(a) end
	local p, n = {}, 0
	for _, v in ipairs(a) do
		n += 1
		if n > 6 then break end
		if type(v) == "string" then p[#p + 1] = '"' .. v:sub(1, 28) .. '"'
		elseif type(v) == "table" and v.__i then p[#p + 1] = "inst:" .. tostring((v.p and v.p[#v.p]) or v.__i)
		elseif type(v) == "number" or type(v) == "boolean" then p[#p + 1] = tostring(v)
		else p[#p + 1] = type(v) end
	end
	return n == 0 and "empty" or table.concat(p, ", ")
end
function SB.whichAmmo(a, title)
	title = tostring(title or "")
	local names = SB.ammoNames()
	if type(a) == "table" then
		for _, n in ipairs(names) do
			local _, hit = SB.subst(a, n, n)
			if hit then return n end
		end
	end
	local tl = title:lower()
	for _, n in ipairs(names) do
		if tl:find(n:lower(), 1, true) then return n end
	end
	if tl:find("ammo", 1, true) then return title end
end
function SB.template()
	for _, e in pairs(S.Crates) do
		if type(e) == "table" and e.k == "Ammo" and type(e.a) == "table" and not e.syn then return e end
	end
end
function SB.isAmmoPick(title)
	if type(title) ~= "string" or title == "" then return false end
	for _, n in ipairs(SB.ammoNames()) do
		if n:lower() == title:lower() then return true end
	end
	local e = S.Crates[title]
	return type(e) == "table" and e.k == "Ammo"
end
function SB.findAmmoInst(name)
	if type(name) ~= "string" then return nil end
	SB.instCache = SB.instCache or {}
	local cached = SB.instCache[name]
	if cached and cached.Parent then return cached end
	local function take(inst)
		if inst then SB.instCache[name] = inst end
		return inst
	end
	local items = kid(GR, "Assets", "Items")
	if items then
		local c = items:FindFirstChild(name)
		if c then return take(c) end
		local compact = name:gsub(" ", ""):lower()
		for _, ch in ipairs(items:GetChildren()) do
			local ln = ch.Name:lower()
			if ln == name:lower() or ln:gsub(" ", "") == compact or ln:gsub(" ", "_") == name:gsub(" ", "_"):lower() then return take(ch) end
		end
	end
	local sh = kid(MOD, "Client", "Modules", "ShopHandler")
	if sh then
		local c = sh:FindFirstChild(name, true)
		if c then return take(c) end
	end
	local low = name:lower()
	for _, c in ipairs(workspace:GetChildren()) do
		if c.Name:lower() == low then return take(c) end
		if c:IsA("Folder") or c:IsA("Model") then
			local f = c:FindFirstChild(name)
			if f then return take(f) end
		end
	end
end
-- turn one learned ammo buy into a different ammo (strings + the crate model)
function SB.applyAmmo(encoded, from, to)
	local a = crDec(encoded)
	local hit = false
	local inst = SB.findAmmoInst(to)
	local function one(v)
		if type(v) == "string" then
			local y, h = SB.subst(v, from, to)
			return y, h
		end
		if typeof(v) == "Instance" then
			local n = v.Name:lower()
			if n:find(from:lower(), 1, true) or n:find("ammo", 1, true) then
				return inst or to, true
			end
			return v, false
		end
		if type(v) == "table" then
			local any = false
			for k, x in pairs(v) do
				local y, h = one(x)
				if h then v[k] = y any = true end
			end
			return v, any
		end
		return v, false
	end
	if type(a) ~= "table" then return a, false end
	for i = 1, #a do
		local y, h = one(a[i])
		if h then a[i] = y hit = true end
	end
	return a, hit
end
function SB.crList(ammo)
	local t, seen = {}, {}
	local function add(s)
		if type(s) == "string" and s ~= "" and not seen[s:lower()] then seen[s:lower()] = true t[#t + 1] = s end
	end
	if ammo then
		for _, n in ipairs(SB.ammoNames()) do add(n) end
	end
	local extra = {}
	for title, e in pairs(S.Crates) do
		if type(e) == "table" and not e.syn and ((e.k == "Ammo") == ammo) then extra[#extra + 1] = title end
	end
	table.sort(extra)
	for _, s in ipairs(extra) do add(s) end
	return t
end
-- Buy through the live shop UI when it is open. This survives shop updates even
-- when debug upvalues changed and the saved remote template can no longer be learned.
function SB.liveBuy(title)
	local sg = PG:FindFirstChild("ShopUI")
	local shop = sg and sg:FindFirstChild("Shop")
	local buy = shop and shop:FindFirstChild("Buy")
	local tl = shop and shop:FindFirstChild("Title")
	local live
	if not (shop and buy and buy:IsA("GuiButton") and tl and shown(shop) and shown(buy)) then return false end
	live = tostring(tl.Text or "")
	if live ~= "" then
		SB.lastLiveBuy, SB.lastLiveTitle = buy, live
		SB.lastShopAdornee = sg.Adornee
	end
	local h, ad = root(), sg.Adornee
	if not (h and ad and ad:IsA("BasePart") and ad.Parent and (ad.Position - h.Position).Magnitude <= 22) then return false end
	if live == "" then return false end
	if title and title ~= "" then
		local a, b = live:lower(), tostring(title):lower()
		if a ~= b and not a:find(b, 1, true) and not b:find(a, 1, true) then return false end
	end
	SB.armMute()
	-- The real purchase is ShopHandler's MouseButton1Click callback. Its two
	-- boolean upvalues become true after one purchase (animation/debounce). Reset
	-- those live guards before every Quick Buy tap, then fire that exact callback.
	local did = false
	if getconnections then
		local okC, conns = pcall(getconnections, buy.MouseButton1Click)
		if okC and type(conns) == "table" then
			for _, c in ipairs(conns) do
				local f, src = c.Function, ""
				if f and debug and debug.info then pcall(function() src = tostring(debug.info(f, "s")) end) end
				if f and src:find("ShopHandler", 1, true) then
					local gu = getupvalues or (debug and debug.getupvalues)
					local su = setupvalue or (debug and debug.setupvalue)
					if gu and su then
						local okU, ups = pcall(gu, f)
						if okU and type(ups) == "table" then
							-- Observed ShopHandler:312: upvalues 2 and 3 are false before
							-- purchase and true afterward. Leave unrelated false flags alone.
							if type(ups[2]) == "boolean" then pcall(su, f, 2, false) end
							if type(ups[3]) == "boolean" then pcall(su, f, 3, false) end
						end
					end
					local okF = pcall(function() if c.Fire then c:Fire() else task.spawn(f) end end)
					did = did or okF
				end
			end
		end
	end
	if not did and firesignal then
		did = pcall(firesignal, buy.MouseButton1Click)
	end
	if not did then did = tap(buy) end
	if did then
		SB.cr.lastBuy = os.clock()
		SB.cr.msg = "pressed real Buy: " .. live
		log("live shop buy pressed: " .. live)
	end
	return did
end

-- buys go one after another (every press counts, each crate's ammo shows on its own)
SB.cr.q = {}
SB.cr.lastBuy = 0
function SB.crBuy(title)
	local cr = SB.cr
	if not title or title == "" then notify("Shop", "Pick a crate first", "x") return end
	local e = S.Crates[title]
	local have = type(e) == "table" and type(e.a) == "table" and not e.syn

	-- Once the game Buy callback has been learned, queue its real ShopFunction
	-- arguments directly. This bypasses the crate animation debounce and lets
	-- every Quick Buy tap count instead of only the first one.
	if not have and SB.liveBuy(title) then return end
	if not have and not SB.isAmmoPick(title) then notify("Shop", "Open this crate in the shop first", "x") return end
	if SB.isAmmoPick(title) and not have then
		local src = SB.template()
		if not src then notify("Shop", "Open any ammo crate once first", "x") return end
		local from = SB.whichAmmo(src.a, tostring(src.t or ""))
		if from and from:lower() ~= title:lower() then
			local _, hit = SB.applyAmmo(src.a, from, title)
			if not hit then notify("Shop", "Open that ammo crate once", "x") return end
		end
	end
	if #cr.q >= 25 then return end
	cr.q[#cr.q + 1] = title
	cr.lastBuy = os.clock()
	SB.armMute()
end
-- amount / ammo name inside what the server answered (if it tells)
function SB.resInfo(res)
	if type(res) ~= "table" then return nil, nil end
	local amt, item
	local function walk(t, d)
		if d > 3 then return end
		for k, v in pairs(t) do
			local kl = tostring(k):lower()
			if type(v) == "number" and not amt and (kl:find("amount") or kl:find("count") or kl:find("qty") or kl:find("quantity") or kl:find("reward")) then amt = v end
			if type(v) == "string" and not item and v:lower():find("ammo") then item = v end
			if type(v) == "table" then walk(v, d + 1) end
		end
	end
	walk(res, 0)
	return amt, item
end
function SB.ammoTot()
	local t = {}
	local ok, inv = pcall(function() return G.Data and G.Data:Get("Inventory") end)
	if ok and type(inv) == "table" then
		for _, e in pairs(inv) do
			if type(e) == "table" and type(e.Value) == "string" and e.Value:lower():find("ammo") then t[e.Value] = (t[e.Value] or 0) + (tonumber(e.Amount) or 0) end
		end
	end
	return t
end
-- side notification: +50 / Rifle Ammo
SB.toastBox = Instance.new("Frame")
SB.toastBox.AnchorPoint, SB.toastBox.Position, SB.toastBox.Size = Vector2.new(1, 0.5), UDim2.new(1, -14, 0.5, 0), UDim2.fromOffset(150, 300)
SB.toastBox.BackgroundTransparency = 1
SB.toastBox.Parent = HUD
do
	local ll = Instance.new("UIListLayout")
	ll.VerticalAlignment, ll.HorizontalAlignment, ll.Padding, ll.SortOrder = Enum.VerticalAlignment.Bottom, Enum.HorizontalAlignment.Right, UDim.new(0, 6), Enum.SortOrder.LayoutOrder
	ll.Parent = SB.toastBox
end
SB.toastN = 0
SB.wnotify = function() end   -- WindUI notification (set once the UI is loaded)
function SB.toast(big, small)
	SB.toastN += 1
	local f = Instance.new("Frame")
	f.Size, f.BackgroundColor3, f.BackgroundTransparency, f.LayoutOrder = UDim2.fromOffset(140, 46), Color3.fromRGB(22, 22, 24), 0.08, SB.toastN
	Instance.new("UICorner", f).CornerRadius = UDim.new(0, 8)
	local st = Instance.new("UIStroke") st.Color, st.Thickness, st.Transparency = Color3.fromRGB(90, 90, 98), 1, 0.2 st.Parent = f
	local b = Instance.new("TextLabel")
	b.BackgroundTransparency, b.Position, b.Size = 1, UDim2.fromOffset(10, 3), UDim2.new(1, -16, 0, 24)
	b.Font, b.TextSize, b.TextColor3, b.TextXAlignment, b.Text = Enum.Font.GothamBold, 21, Color3.fromRGB(120, 230, 130), Enum.TextXAlignment.Left, big
	b.Parent = f
	local sm = Instance.new("TextLabel")
	sm.BackgroundTransparency, sm.Position, sm.Size = 1, UDim2.fromOffset(10, 26), UDim2.new(1, -16, 0, 16)
	sm.Font, sm.TextSize, sm.TextColor3, sm.TextXAlignment, sm.Text = Enum.Font.GothamMedium, 12, Color3.fromRGB(200, 200, 205), Enum.TextXAlignment.Left, small
	sm.Parent = f
	f.Parent = SB.toastBox
	local kids = {}
	for _, c in ipairs(SB.toastBox:GetChildren()) do if c:IsA("Frame") then kids[#kids + 1] = c end end
	if #kids > 6 then table.sort(kids, function(x, y) return x.LayoutOrder < y.LayoutOrder end) kids[1]:Destroy() end
	task.delay(3, function() pcall(function() f:Destroy() end) end)
end
task.spawn(function()   -- buy worker
	local cr = SB.cr
	while ALIVE do
		local title = table.remove(cr.q, 1)
		if title then
			local e = S.Crates[title]
			local encoded, fromName
			if type(e) == "table" and type(e.a) == "table" and not e.syn then
				encoded = e.a
			else
				local src = SB.template()
				if src then
					encoded = src.a
					fromName = SB.whichAmmo(src.a, tostring(src.t or ""))
					if type(e) ~= "table" then e = { t = title, k = "Ammo" } end
				end
			end
			local rf = SB.crRF()
			local a
			if rf and encoded then
				if fromName and fromName:lower() ~= tostring(title):lower() then
					local hit
					a, hit = SB.applyAmmo(encoded, fromName, title)
					if not hit then a = nil end
				else
					a = crDec(encoded)
				end
			end
			if a then
				local before = SB.ammoTot()
				SB.armMute()
				SB.hideCrate()
				local ok, res = pcall(function() return rf:InvokeServer(table.unpack(a, 1, #a)) end)
				SB.hideCrate()
				local ramt, ritem = SB.resInfo(res)
				local gained, t0 = {}, os.clock()
				repeat
					task.wait(0.04)
					SB.hideCrate()
					gained = {}
					for n, v in pairs(SB.ammoTot()) do if v > (before[n] or 0) then gained[n] = v - (before[n] or 0) end end
				until next(gained) or os.clock() - t0 > 0.35
				if next(gained) then
					cr.n += 1
					for n, v in pairs(gained) do
						cr.msg = "+" .. v .. " " .. n
						notify("Ammo", "+" .. v .. " " .. n)
					end
				elseif ramt then
					cr.n += 1
					local nm = ritem or tostring(e.t or title)
					cr.msg = "+" .. ramt .. " " .. nm
					notify("Ammo", "+" .. ramt .. " " .. nm)
				else
					cr.fail += 1
					local why = ok and (type(res) == "table" and tostring(res.Error or res.Message or res[2] or res[1] or "") or tostring(res)) or tostring(res)
					local wl = why:lower()
					if wl:find("money") or wl:find("funds") then notify("Ammo", "Not enough money") cr.q = {}
					elseif wl:find("space") or wl:find("full") then notify("Ammo", "Inventory full") cr.q = {} end
				end
				SB.hideCrate()
			end
		else
			task.wait(0.03)
		end
	end
end)
-- QUICK BUY button: only shows while you're at an ammo crate
SB.qb = Instance.new("TextButton")
do
	local qb = SB.qb
	local pos = S.QBPos
	qb.AnchorPoint = Vector2.new(0.5, 0.5)
	qb.Position = (type(pos) == "table" and tonumber(pos[1])) and UDim2.new(pos[1], pos[2], pos[3], pos[4]) or UDim2.new(0.5, 0, 1, -150)
	qb.Size, qb.BackgroundColor3, qb.AutoButtonColor, qb.Visible = UDim2.fromOffset(170, 52), Color3.fromRGB(28, 28, 31), true, false
	qb.Font, qb.TextSize, qb.TextColor3, qb.Text = Enum.Font.GothamBold, 18, Color3.new(1, 1, 1), "QUICK BUY"
	Instance.new("UICorner", qb).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke") st.Color, st.Thickness, st.ApplyStrokeMode = Color3.fromRGB(160, 160, 168), 1.5, Enum.ApplyStrokeMode.Border st.Parent = qb
	qb.Parent = HUD
	-- tap = buy, hold + drag = move it
	local down, moved, p0, s0
	C(qb.InputBegan, function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then down, moved, p0, s0 = i, false, qb.Position, i.Position end
	end)
	C(UIS.InputChanged, function(i)
		if down and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - s0
			if moved or d.Magnitude > 12 then
				moved = true
				qb.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
			end
		end
	end)
	C(UIS.InputEnded, function(i)
		if down and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) then
			down = nil
			if moved then
				local q = qb.Position
				S.QBPos = { q.X.Scale, q.X.Offset, q.Y.Scale, q.Y.Offset } save()
			elseif SB.qbKey then
				if not SB.liveBuy(SB.qbKey) then SB.crBuy(SB.qbKey) end
			end
		end
	end)
end
task.spawn(function()
	while ALIVE do
		local key
		pcall(function()
			local sg = PG:FindFirstChild("ShopUI")
			local shop = sg and sg:FindFirstChild("Shop")
			local tl = shop and shop:FindFirstChild("Title")
			local buy = shop and shop:FindFirstChild("Buy")
			if not (tl and buy and shown(shop) and shown(buy)) then return end
			local ad = sg.Adornee
			local h = root()
			if not (h and ad and ad:IsA("BasePart") and ad.Parent and (ad.Position - h.Position).Magnitude <= 22) then return end
			local liveTitle = tostring(tl.Text or "")
			if liveTitle == "" then return end
			for k, e in pairs(S.Crates) do
				if type(e) == "table" and tostring(e.t or ""):lower() == liveTitle:lower() then key = k break end
			end
			-- Learning can break after a game update; Quick Buy still works by
			-- pressing the real visible Buy button for the title in front of you.
			key = key or liveTitle
		end)
		SB.qbKey = key
		SB.qb.Visible = key ~= nil
		task.wait(0.05)
	end
end)
-- watch the crate shop you walk up to and learn it (nothing is bought)
task.spawn(function()
	local cr = SB.cr
	while ALIVE do
		pcall(function()
			local shop = kid(PG, "ShopUI", "Shop")
			local b = shop and shop:FindFirstChild("Buy")
			local tl = shop and shop:FindFirstChild("Title")
			local pr = shop and shop:FindFirstChild("Price")
			if not (b and tl and getconnections) then return end
			local title = tostring(tl.Text or "")
			if title == "" or title == cr.lastTitle then return end
			if pr and pr:IsA("TextLabel") and not pr.Text:find("%$%s*[%d,]+") then cr.lastTitle = title return end   -- Robux crate: skip

			-- Put every cash crate currently shown by the game into the Shop lists,
			-- even if this update moved or replaced ShopHandler's connection.
			if not S.Crates[title] then
				S.Crates[title] = { k = title:lower():find("ammo", 1, true) and "Ammo" or "Other", t = title, live = true }
				save()
				if cr.onLearn then pcall(cr.onLearn, title) end
			end

			local tr = cr.tries[title] or { n = 0, t = 0 }
			cr.tries[title] = tr
			if tr.n >= 2 and os.clock() - tr.t < 15 then return end
			if tr.n >= 2 then tr.n = 0 end
			tr.n += 1 tr.t = os.clock()

			local fn
			for _, signalName in ipairs({ "MouseButton1Click", "Activated", "MouseButton1Up" }) do
				local okC, conns = pcall(getconnections, b[signalName])
				if okC and type(conns) == "table" then
					for _, c in ipairs(conns) do
						local f = c.Function
						local ok, src = pcall(debug.info, f, "s")
						if f and ok and tostring(src):find("ShopHandler") then fn = f break end
					end
				end
				if fn then break end
			end
			if fn then
				task.wait(0.3)
				if tl.Text == title and SB.crLearn(fn, title) then cr.lastTitle = title end
			end
		end)
		task.wait(0.5)
	end
end)
-- learn what each shop sells (from every shop menu you open)
function SB.learn()
	local new = false
	local function add(f)
		for _, e in ipairs(SHOP.entries(f)) do
			local c = SB.cat(e.name, f.Name)
			if not SB.seen[c][e.name] then SB.seen[c][e.name] = true new = true end
		end
	end
	for _, f in ipairs(SHOP.storeFrames()) do pcall(add, f) end
	local f = SHOP.frame()
	if f then pcall(add, f) end
	return new
end
SB.AMMO = { "Any Ammo", "Pistol Ammo", "Rifle Ammo", "SMG Ammo", "Shotgun Ammo", "Sniper Ammo", "Heavy Ammo", "RPG Ammo" }
function SB.values(cat)
	local t = {}
	if cat == "Ammo" then for _, n in ipairs(SB.AMMO) do t[#t + 1] = n end end
	for n in pairs(SB.seen[cat]) do t[#t + 1] = n end
	if cat == "Cars" then for _, n in ipairs(CAR_LIST) do if not table.find(t, n) then t[#t + 1] = n end end end
	if cat == "Guns" then for n in pairs(GM.byName or {}) do if not table.find(t, n) and SB.cat(n) ~= "Ammo" then t[#t + 1] = n end end end
	for _, n in ipairs(S.SpamList[cat]) do if not table.find(t, n) then t[#t + 1] = n end end
	if cat == "Ammo" then
		local fixed = { t[1] }   -- keep "Any Ammo" first
		table.remove(t, 1)
		local seen = {}
		local out = {}
		for _, n in ipairs(t) do if not seen[n:lower()] then seen[n:lower()] = true out[#out + 1] = n end end
		table.sort(out)
		for _, n in ipairs(out) do fixed[#fixed + 1] = n end
		return fixed
	end
	table.sort(t)
	return t
end
function SB.anyOn() for _, k in ipairs(SB.CATS) do if S.SpamOn[k] and #S.SpamList[k] > 0 then return true end end return false end
function SB.status2()
	local cr = SB.cr
	local n = 0 for _ in pairs(S.Crates) do n += 1 end
	local ready = SB.template() and "ready" or "open any ammo crate once"
	return "Ammo buy: " .. ready .. "  -  crates: " .. n .. "  -  bought: " .. cr.n .. (cr.fail > 0 and ("  -  failed: " .. cr.fail) or "")
		.. (cr.msg ~= "" and ("\n" .. cr.msg) or "")
end
function SB.status()
	local on = {}
	for _, k in ipairs(SB.CATS) do if S.SpamOn[k] then on[#on + 1] = k .. " (" .. #S.SpamList[k] .. ")" end end
	return (#on > 0 and ("Spam buying: " .. table.concat(on, ", ")) or "Spam buy is off")
		.. "\n" .. SB.msg .. ((SB.ammoMsg ~= "") and ("\n" .. SB.ammoMsg) or "") .. "\nBuy presses: " .. SB.n .. "  -  crates skipped: " .. SB.skips
end
-- ================================================================
-- RANDOM OUTFIT (copies a random player's fit - only YOU see it, nothing is deleted)
-- ================================================================
local OUT = { added = {} }
function OUT.random()
	local me, hm = char(), hum()
	if not (me and hm) then return false, "no character" end
	local list = {}
	for _, p in ipairs(Players:GetPlayers()) do
		local c = p.Character
		if p ~= L and c and (c:FindFirstChildOfClass("Shirt") or c:FindFirstChildOfClass("Pants")) then list[#list + 1] = p end
	end
	if #list == 0 then return false, "nobody to copy yet" end
	local p = list[math.random(1, #list)]
	local c = p.Character
	for _, a in ipairs(OUT.added) do pcall(function() a:Destroy() end) end
	OUT.added = {}
	for _, cls in ipairs({ "Shirt", "Pants", "ShirtGraphic" }) do
		local theirs, mine = c:FindFirstChildOfClass(cls), me:FindFirstChildOfClass(cls)
		if theirs then
			if mine then
				pcall(function()
					if cls == "Shirt" then mine.ShirtTemplate = theirs.ShirtTemplate elseif cls == "Pants" then mine.PantsTemplate = theirs.PantsTemplate else mine.Graphic = theirs.Graphic end
				end)
			else local n = theirs:Clone() n.Parent = me OUT.added[#OUT.added + 1] = n end
		end
	end
	for _, a in ipairs(me:GetChildren()) do   -- hide your own hats (local only)
		if a:IsA("Accessory") and not a:GetAttribute("DrixFit") then
			local hd = a:FindFirstChild("Handle") if hd then hd.LocalTransparencyModifier = 1 hd.Transparency = 1 end
		end
	end
	for _, a in ipairs(c:GetChildren()) do
		if a:IsA("Accessory") then
			local n = a:Clone()
			n:SetAttribute("DrixFit", true)
			for _, w in ipairs(n:GetDescendants()) do if w:IsA("JointInstance") or w:IsA("WeldConstraint") then w:Destroy() end end
			local hd = n:FindFirstChild("Handle")
			if hd then hd.Anchored = false hd.CanCollide = false pcall(function() hd.Massless = true hd.CanQuery = false end) end
			pcall(function() hm:AddAccessory(n) end)
			OUT.added[#OUT.added + 1] = n
		end
	end
	return true, p.Name
end
task.spawn(function()
	task.wait(6)
	if S.RandomFit then
		local ok, who = OUT.random()
		if ok then notify("Outfit", "Random fit (copied " .. who .. ") - only you see it", "shirt") end
	end
end)

-- ================================================================
-- PERFORMANCE
-- ================================================================
local Perf = { saved = {}, fx = {} }
function Perf.boost(on)
	if on then
		Perf.saved.gs = Lighting.GlobalShadows
		Lighting.GlobalShadows = false
		pcall(function() Perf.saved.q = settings().Rendering.QualityLevel settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
		task.spawn(function()
			local stack, t0 = { workspace }, os.clock()
			while #stack > 0 and S.Boost do
				local i = table.remove(stack)
				if i:IsA("ParticleEmitter") or i:IsA("Smoke") or i:IsA("Fire") or i:IsA("Sparkles") or i:IsA("Trail") then
					if i.Enabled then Perf.fx[i] = true i.Enabled = false end
				end
				for _, c in ipairs(i:GetChildren()) do stack[#stack + 1] = c end
				if os.clock() - t0 > 0.003 then task.wait() t0 = os.clock() end
			end
		end)
	else
		if Perf.saved.gs ~= nil then Lighting.GlobalShadows = Perf.saved.gs end
		pcall(function() if Perf.saved.q then settings().Rendering.QualityLevel = Perf.saved.q end end)
		for i in pairs(Perf.fx) do if i.Parent then i.Enabled = true end end
		Perf.fx = {}
	end
end
local function hideShot(d)
	if not S.HideBullets then return end
	if d:IsA("BasePart") then
		if d.Size.Magnitude < 6 and not d:FindFirstAncestorWhichIsA("Model") then d.LocalTransparencyModifier = 1 d.Transparency = 1 end
	elseif d:IsA("ParticleEmitter") or d:IsA("Beam") or d:IsA("Trail") or d:IsA("PointLight") then d.Enabled = false end
end
task.spawn(function()
	local gi = workspace:WaitForChild("GunIgnore", 10)
	if gi then C(gi.DescendantAdded, function(d) task.defer(hideShot, d) end) end
end)
if S.Boost then task.defer(Perf.boost, true) end
task.spawn(function()
	while ALIVE do
		task.wait(10)
		if S.AutoPerf then
			local n, t0 = 0, os.clock()
			while os.clock() - t0 < 1 do Run.RenderStepped:Wait() n += 1 end
			if n < 40 and not S.Boost then S.Boost = true S.HideBullets = true Perf.boost(true) log("low FPS (" .. n .. ") -> performance on") end
		end
	end
end)
pcall(function()
	if getconnections then for _, c in ipairs(getconnections(L.Idled)) do pcall(function() c:Disable() end) end end
end)
C(L.Idled, function() pcall(function() local VU = game:GetService("VirtualUser") VU:CaptureController() VU:ClickButton2(Vector2.new()) end) end)

-- ================================================================
-- DEBUG: Record Me + scans (read only, no hooks)
-- ================================================================
local MV
local DBG = { parts = {}, partI = 0, rec = false, recLines = {}, recConns = {}, recT0 = 0 }
function DBG.split(txt, tag)
	DBG.parts, DBG.partI = {}, 0
	local i = 1
	while i <= #txt do
		local j = math.min(#txt, i + 44999)
		local nl = txt:find("\n", j, true)
		if nl and j < #txt then j = nl end
		DBG.parts[#DBG.parts + 1] = txt:sub(i, j)
		i = j + 1
	end
	for k = 1, #DBG.parts do DBG.parts[k] = "-- " .. tag .. " PART " .. k .. "/" .. #DBG.parts .. " --\n" .. DBG.parts[k] end
	pcall(function() if writefile then writefile("drixnvsp_oppsc_" .. tag:lower():gsub("%s", "_") .. ".txt", txt) end end)
end
function DBG.espScan()
	local out = { "drixnvsp OPPS combat - ESP SCAN  " .. os.date(), "ESP on=" .. tostring(S.ESP) .. " range=" .. S.ESPRange .. " streaming=" .. tostring(workspace.StreamingEnabled) }
	pcall(function() out[#out + 1] = "stream radius min/target = " .. workspace.StreamingMinRadius .. "/" .. workspace.StreamingTargetRadius end)
	local me = root()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= L then
			local e, ch = ESP.e[p], p.Character
			local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
			local hm = ch and ch:FindFirstChildOfClass("Humanoid")
			local n = 0 if ch then for _, d in ipairs(ch:GetChildren()) do if d:IsA("BasePart") then n += 1 end end end
			out[#out + 1] = string.format("%s | char=%s parent=%s parts=%d hrp=%s hum=%s hp=%s dist=%s | esp=%s why=%s",
				p.Name, tostring(ch ~= nil), ch and ch.Parent and ch.Parent.Name or "-", n, tostring(hrp ~= nil), tostring(hm ~= nil), hm and math.floor(hm.Health) or "-",
				(hrp and me) and math.floor((hrp.Position - me.Position).Magnitude) or "?", e and tostring(e.shown) or "NO ENTRY", e and (tostring(e.why) .. (e.err and (" ERR: " .. e.err) or "")) or "-")
		end
	end
	DBG.split(table.concat(out, "\n"), "ESP SCAN")
	return #out
end
function DBG.aimScan()
	local out = { "drixnvsp OPPS combat - AIM SCAN  " .. os.date(), "aim buttons hooked:" }
	for b in pairs(AIM.aimBtns) do out[#out + 1] = "  " .. b:GetFullName() .. " (" .. b.ClassName .. ")" end
	pcall(function()
		local cs = getconnections and getconnections(Run.RenderStepped) or {}
		out[#out + 1] = "RenderStepped connections: " .. #cs
		for i, cn in ipairs(cs) do
			if i > 25 then break end
			local src = "?" pcall(function() src = debug.info(cn.Function, "s") end)
			out[#out + 1] = "  " .. tostring(src)
		end
	end)
	out[#out + 1] = "frames (t | fov | aiming | signal | target | error deg after render):"
	local t0 = os.clock()
	local cn
	cn = Run.Heartbeat:Connect(function()
		local cam = workspace.CurrentCamera
		local e = AIM.cur
		local err = "-"
		if cam and e and e.part and e.part.Parent then
			local d = (e.part.Position - cam.CFrame.Position).Unit
			err = string.format("%.2f", math.deg(math.acos(math.clamp(cam.CFrame.LookVector:Dot(d), -1, 1))))
		end
		out[#out + 1] = string.format("%.2f | %.1f | %s | %s | %s | %s", os.clock() - t0, cam and cam.FieldOfView or 0, tostring(AIM.want), AIM.lastSig, AIM.target and AIM.target.Name or "-", err)
		if os.clock() - t0 > 4 then cn:Disconnect() end
	end)
	task.wait(4.2)
	out[#out + 1] = "" out[#out + 1] = "LOG:" for _, l in ipairs(LOGS) do out[#out + 1] = l end
	DBG.split(table.concat(out, "\n"), "AIM SCAN")
	return #out
end
function DBG.copyNext()
	if #DBG.parts == 0 then return "nothing to copy yet" end
	DBG.partI = DBG.partI % #DBG.parts + 1
	pcall(function() (setclipboard or toclipboard)(DBG.parts[DBG.partI]) end)
	return "copied part " .. DBG.partI .. "/" .. #DBG.parts
end
local function recLine(x) if DBG.rec then DBG.recLines[#DBG.recLines + 1] = string.format("%7.2f  %s", os.clock() - DBG.recT0, x) end end
local function gpath(d)
	local s2, x = d.Name, d.Parent
	for _ = 1, 4 do if not x or x == PG then break end s2 = x.Name .. "." .. s2 x = x.Parent end
	return s2
end
local function rc(sig, fn) local c = sig:Connect(fn) DBG.recConns[#DBG.recConns + 1] = c end
local function recWatch(d)
	if isOurs(d) or d:FindFirstAncestor("TouchGui") or d.Name == "TouchGui" then return end
	if d:IsA("GuiButton") then rc(d.Activated, function() recLine("PRESSED " .. gpath(d) .. "  '" .. btnText(d):sub(1, 50) .. "'") end)
	elseif d:IsA("TextBox") then rc(d.FocusLost, function(e) recLine("TYPED " .. gpath(d) .. " = '" .. d.Text .. "' enter=" .. tostring(e)) end) end
	if d:IsA("LayerCollector") then rc(d:GetPropertyChangedSignal("Enabled"), function() recLine((d.Enabled and "OPENED " or "CLOSED ") .. gpath(d)) end)
	elseif d:IsA("GuiObject") then
		local depth, x = 0, d
		while x and x ~= PG and depth < 9 do x = x.Parent depth += 1 end
		if depth <= 5 then rc(d:GetPropertyChangedSignal("Visible"), function() recLine((d.Visible and "SHOW " or "HIDE ") .. gpath(d)) end) end
	end
	if (d:IsA("TextLabel") or d:IsA("TextButton")) then
		rc(d:GetPropertyChangedSignal("Text"), function()
			local tl = d.Text:lower()
			if tl:find("stock") or tl:find("bought") or tl:find("purchase") or tl:find("restock") or tl:find("not enough") then recLine("TEXT " .. gpath(d) .. " = '" .. clean(d.Text):sub(1, 80) .. "'") end
		end)
	end
end
function DBG.startRec()
	DBG.rec, DBG.recLines, DBG.recT0 = true, {}, os.clock()
	recLine("recording started at " .. v3(root() and root().Position))
	for _, d in ipairs(PG:GetDescendants()) do recWatch(d) end
	rc(PG.DescendantAdded, function(d) task.defer(recWatch, d) end)
	rc(L.AttributeChanged, function(a) recLine("PLAYER @" .. a .. " = " .. tostring(L:GetAttribute(a))) end)
	local function wc(c)
		rc(c.AttributeChanged, function(a) if a ~= "Stamina" then recLine("CHAR @" .. a .. " = " .. tostring(c:GetAttribute(a))) end end)
		rc(c.ChildAdded, function(t) if t:IsA("Tool") then recLine("EQUIPPED " .. t.Name) end end)
		rc(c.ChildRemoved, function(t) if t:IsA("Tool") then recLine("UNEQUIPPED " .. t.Name) end end)
	end
	if char() then wc(char()) end
	local bp = L:FindFirstChild("Backpack")
	if bp then rc(bp.ChildAdded, function(t) recLine("GOT TOOL " .. t.Name) end) end
	local inv = L:FindFirstChild("Inventory")
	if inv then for _, s in ipairs(inv:GetChildren()) do if s:IsA("ValueBase") then rc(s.Changed, function() recLine("INVENTORY " .. s.Name .. " = " .. tostring(s.Value)) end) end end end
	task.spawn(function()
		local last = {}
		while DBG.rec and ALIVE do
			for _, k in ipairs({ "Cash", "Bank" }) do local v = getNum(k) if last[k] ~= v then last[k] = v recLine(k .. " = " .. tostring(v)) end end
			local cam = workspace.CurrentCamera
			if cam then local f = math.floor(cam.FieldOfView) if last.fov ~= f then last.fov = f recLine("Camera FOV = " .. f) end end
			local sig = AIM.lastSig
			if last.sig ~= sig then last.sig = sig recLine("aim signal = '" .. sig .. "'") end
			task.wait(0.15)
		end
	end)
end
function DBG.stopRec()
	DBG.rec = false
	for _, c in ipairs(DBG.recConns) do pcall(function() c:Disconnect() end) end
	DBG.recConns = {}
end
local function valStr(v)
	local ty = typeof(v)
	if ty == "number" then return (v == math.floor(v)) and tostring(v) or string.format("%.3f", v) end
	if ty == "string" then return '"' .. v:sub(1, 50) .. '"' end
	if ty == "table" then return "{table}" end
	return tostring(v)
end
function DBG.gunScan()
	local out = {}
	local function add(x) out[#out + 1] = x end
	add("drixnvsp OPPS combat - GUN + AIM SCAN  " .. os.date())
	local c = char()
	local t = c and c:FindFirstChildOfClass("Tool")
	add("held tool: " .. (t and t.Name or "NONE (equip your gun first!)") .. "  isGun=" .. tostring(t and GM.isGun(t)))
	if t then
		local function tree(o, ind, n)
			if n > 120 then return n end
			local a = {}
			for k, v in pairs(o:GetAttributes()) do a[#a + 1] = "@" .. k .. "=" .. valStr(v) end
			add(ind .. o.ClassName .. " " .. o.Name .. (o:IsA("ValueBase") and (" = " .. valStr(o.Value)) or "") .. (#a > 0 and ("  " .. table.concat(a, " ")) or ""))
			for _, ch in ipairs(o:GetChildren()) do n = tree(ch, ind .. "  ", n + 1) end
			return n
		end
		tree(t, "", 0)
	end
	add("") add("gun tables found: " .. #GM.tables .. "   patched values: " .. #GM.patched .. "   named guns: " .. (function() local s = {} for k in pairs(GM.byName) do s[#s + 1] = k end return table.concat(s, ", ") end)())
	for i, tb in ipairs(GM.tables) do
		if i > 20 then add("...") break end
		local s, n = {}, 0
		for k, v in pairs(tb) do n += 1 if n > 40 then break end s[#s + 1] = tostring(k) .. "=" .. valStr(v) end
		add("  [" .. i .. "] " .. table.concat(s, "  "))
	end
	local cam = workspace.CurrentCamera
	add("") add(string.format("camera FOV %.1f (normal %.1f)  type %s  mouse %s", cam.FieldOfView, AIM.baseFov or 0, cam.CameraType.Name, UIS.MouseBehavior.Name))
	add("aim signal now: '" .. AIM.lastSig .. "'  aim attr: " .. tostring(AIM.attrWhy))
	local nrc = 0 for _ in pairs(GM.rc) do nrc += 1 end
	add("stamina: cfg " .. tostring(MV.cfg ~= nil) .. " update " .. tostring(MV.upd ~= nil) .. " idx " .. #MV.idx .. " cfgOn " .. tostring(MV.cfgOn) .. " max " .. tostring(MV.stamMax) .. (MV.cfg and (" lost=" .. tostring(MV.cfg.StaminaLostRate) .. " gain=" .. tostring(MV.cfg.StaminaGainRate)) or ""))
	add("car input: " .. tostring(CAR.iObj and CAR.iObj:GetFullName()) .. " " .. tostring(CAR.iTh) .. "/" .. tostring(CAR.iSt))
	add("game _G found: " .. tostring(AIM.rg ~= nil) .. "  _G.ToolAiming = " .. tostring(AIM.rg and rawget(AIM.rg, "ToolAiming")) .. "  RecoilCam tables: " .. nrc)
	add("crosshair: " .. (AIM.cross and AIM.cross:GetFullName() or "none (center)"))
	for b in pairs(AIM.aimBtns) do add("game aim button: " .. b:GetFullName()) end
	for _, d in ipairs(PG:GetDescendants()) do
		if d:IsA("GuiButton") and not isOurs(d) then
			local n = d.Name:lower()
			if n:find("shoot") or n:find("fire") or n:find("aim") or n:find("reload") or n:find("scope") then add("button: " .. d:GetFullName() .. " visible=" .. tostring(shown(d))) end
		end
	end
	local a = {}
	for k, v in pairs(L:GetAttributes()) do a[#a + 1] = k .. "=" .. valStr(v) end
	add("player attrs: " .. table.concat(a, " "))
	a = {}
	for k, v in pairs(c and c:GetAttributes() or {}) do a[#a + 1] = k .. "=" .. valStr(v) end
	add("char attrs: " .. table.concat(a, " "))
	-- the game's gun code: numbers + names it uses (recoil / spread live here)
	add("") add("SAFEZONES: folder=" .. (SZ.folder and SZ.folder:GetFullName() or "NONE") .. "  parts=" .. #SZ.parts .. "  me safe=" .. tostring(inSafe(L)))
	for i, z in ipairs(SZ.parts) do
		if i > 40 then break end
		add(string.format("  %s size=%s tr=%.2f coll=%s used=%s", z:GetFullName():gsub("^.-afe[Zz]ones?%.", ""), v3(z.Size), z.Transparency, tostring(z.CanCollide), tostring(zoneOk(z))))
	end
	for _, o in ipairs({ L, char() }) do
		if o then for k, v in pairs(o:GetAttributes()) do add("  attr " .. o.Name .. "@" .. k .. " = " .. tostring(v)) end end
	end
	add("") add("GUN CODE:")
	local getK = (debug and debug.getconstants) or getconstants
	local getU = (debug and debug.getupvalues) or getupvalues
	local getP = (debug and debug.getprotos) or getprotos
	local function fnDump(f, ind, depth, budget)
		if budget.n <= 0 then return end
		local ks = {}
		if getK then pcall(function() for _, k in pairs(getK(f)) do
			if type(k) == "number" or (type(k) == "string" and #k <= 30 and #k >= 2) then ks[#ks + 1] = valStr(k) end
		end end) end
		local us = {}
		if getU then pcall(function() for i, u in pairs(getU(f)) do
			if type(u) == "number" or type(u) == "boolean" then us[#us + 1] = "u" .. i .. "=" .. valStr(u)
			elseif type(u) == "table" then local s2, n2 = {}, 0 for k2, v2 in pairs(u) do n2 += 1 if n2 > 12 then break end if type(v2) ~= "function" then s2[#s2 + 1] = tostring(k2) .. "=" .. valStr(v2) end end us[#us + 1] = "u" .. i .. "={" .. table.concat(s2, " ") .. "}" end
		end end) end
		add(ind .. "K: " .. table.concat(ks, " "):sub(1, 900)) budget.n -= 1
		if #us > 0 then add(ind .. "U: " .. table.concat(us, " "):sub(1, 900)) budget.n -= 1 end
		if getP and depth < 2 then pcall(function() for i, pf in ipairs(getP(f)) do if i > 25 then break end add(ind .. "proto " .. i .. ":") fnDump(pf, ind .. "  ", depth + 1, budget) end end) end
	end
	local mods = {}
	if MOD then
		for _, d in ipairs(MOD:GetDescendants()) do
			if d:IsA("ModuleScript") then
				local n = d.Name:lower()
				if n == "gun" or n:find("gun") or n:find("weapon") or n:find("recoil") or n:find("spread") or n:find("camera") or n:find("bullet") then mods[#mods + 1] = d end
			end
		end
	end
	for i, d in ipairs(mods) do
		if i > 10 then break end
		add("MODULE " .. d:GetFullName())
		local ok, m = safeRequire(d, 2)
		local budget = { n = 160 }
		if ok and type(m) == "table" then
			for k, v in pairs(m) do
				if type(v) == "function" then add("  fn " .. tostring(k) .. ":") fnDump(v, "    ", 0, budget)
				elseif type(v) ~= "table" then add("  " .. tostring(k) .. " = " .. valStr(v))
				else local s2, n2 = {}, 0 for k2, v2 in pairs(v) do n2 += 1 if n2 > 20 then break end if type(v2) ~= "function" then s2[#s2 + 1] = tostring(k2) .. "=" .. valStr(v2) end end add("  " .. tostring(k) .. " = {" .. table.concat(s2, " ") .. "}") end
			end
		elseif ok and type(m) == "function" then fnDump(m, "  ", 0, budget)
		else add("  (couldn't load: " .. tostring(m) .. ")") end
	end
	add("") add("LOG:") for _, l in ipairs(LOGS) do add(l) end
	DBG.split(table.concat(out, "\n"), "GUN SCAN")
	return #out
end
function DBG.shopScan()
	local out = {}
	local function add(x) out[#out + 1] = x end
	add("drixnvsp OPPS combat - SHOP SCAN  " .. os.date())
	for n, rep in pairs(SHOP.reps) do
		add("Replion " .. n .. ":")
		local function w(t, ind, d)
			if d > 3 then return end
			local k2 = 0
			for k, v in pairs(t) do
				k2 += 1 if k2 > 60 then add(ind .. "...") break end
				add(ind .. tostring(k) .. " = " .. valStr(v))
				if type(v) == "table" then w(v, ind .. "  ", d + 1) end
			end
		end
		pcall(w, rep.Data or {}, "  ", 0)
	end
	local shops = MOD and kid(MOD, "Client", "Controllers", "ShopController", "Shops")
	if shops then
		add("ShopController.Shops:")
		for _, st in ipairs(shops:GetDescendants()) do
			local a = {}
			for k, v in pairs(st:GetAttributes()) do a[#a + 1] = "@" .. k .. "=" .. valStr(v) end
			add("  " .. st:GetFullName():gsub("^.-Shops%.", "") .. " (" .. st.ClassName .. ")" .. (st:IsA("ValueBase") and (" = " .. valStr(st.Value)) or "") .. " " .. table.concat(a, " "))
		end
	end
	add("stock values in RS: " .. #SHOP.rsRefs)
	for i, r in ipairs(SHOP.rsRefs) do if i > 60 then break end add("  " .. r:GetFullName() .. (r:IsA("ValueBase") and (" = " .. valStr(r.Value)) or "")) end
	local f = SHOP.frame()
	add("open shop menu: " .. (f and f:GetFullName() or "NONE (open a shop first!)"))
	if f then
		for _, e in ipairs(SHOP.entries(f)) do add(string.format("  item '%s'  $%s  stock=%s  button=%s", e.name, tostring(e.price), tostring(e.stock), e.btn and gpath(e.btn) or "none")) end
		local n = 0
		local function tree(o, ind)
			n += 1 if n > 400 then return end
			local tx = (o:IsA("TextLabel") or o:IsA("TextButton") or o:IsA("TextBox")) and (" '" .. clean(o.Text):sub(1, 40) .. "'") or ""
			add(ind .. o.ClassName .. " " .. o.Name .. tx .. ((o:IsA("GuiObject") and not o.Visible) and " (hidden)" or ""))
			for _, ch in ipairs(o:GetChildren()) do tree(ch, ind .. "  ") end
		end
		tree(f, "  ")
	end
	local frames = kid(PG, "UI", "Frames")
	if frames then local s = {} for _, x in ipairs(frames:GetChildren()) do s[#s + 1] = x.Name .. (x:IsA("GuiObject") and x.Visible and "*" or "") end add("UI.Frames: " .. table.concat(s, ", ")) end
	local npcs = workspace:FindFirstChild("NPCs")
	if npcs then
		for _, m in ipairs(npcs:GetChildren()) do
			local s = {}
			for _, d in ipairs(m:GetDescendants()) do if d.Name == "PromptDirect" or d.Name == "Text" then s[#s + 1] = gpath(d) .. "=" .. tostring(d.Value) end end
			add("NPC " .. m.Name .. " " .. v3(posOf(m)) .. "  " .. table.concat(s, " "))
		end
	end
	add("stock now: ") for k, v in pairs(SHOP.stock) do add("  " .. k .. " = " .. tostring(v)) end
	add("") add("LOG:") for _, l in ipairs(LOGS) do add(l) end
	DBG.split(table.concat(out, "\n"), "SHOP SCAN")
	return #out
end

-- ================================================================
-- HITBOX EXPANDER (no hooks): other players' head / body is made bigger on YOUR screen only,
-- so the game's own gun ray hits them easier. Team members are skipped. Restored when off.
-- ================================================================
HB = { orig = setmetatable({}, { __mode = "k" }), vis = {} }
-- the real head is made big + invisible (that's the hitbox). A normal-size copy of the head
-- (can't be shot, can't be touched) is drawn in its place, so they look completely normal.
function HB.restore(pt)
	local o = HB.orig[pt]
	if o and pt.Parent then
		pcall(function() pt.Size, pt.Transparency, pt.CanCollide, pt.Massless = o[1], o[2], o[3], o[4] end)
		for d, t in pairs(o.dec or {}) do pcall(function() if d.Parent then d.Transparency = t end end) end
	end
	HB.orig[pt] = nil
	local v = HB.vis[pt]
	if v then pcall(function() v:Destroy() end) HB.vis[pt] = nil end
end
function HB.restoreAll()
	for pt in pairs(HB.orig) do HB.restore(pt) end
	for pt, v in pairs(HB.vis) do pcall(function() v:Destroy() end) HB.vis[pt] = nil end
end
function HB.makeVis(pt, o)
	local ok, v = pcall(function()
		local a = pt.Archivable
		pt.Archivable = true
		local c = pt:Clone()
		pt.Archivable = a
		for _, ch in ipairs(c:GetChildren()) do
			if not (ch:IsA("Decal") or ch:IsA("SpecialMesh") or ch:IsA("SurfaceAppearance")) then ch:Destroy() end
		end
		c.Name = "drixHeadLook"
		c.Size, c.Transparency = o[1], o[2]
		c.Anchored, c.CanCollide, c.CanTouch, c.CanQuery, c.Massless, c.CastShadow = true, false, false, false, true, false
		c.CFrame = pt.CFrame
		c.Parent = workspace.CurrentCamera
		return c
	end)
	return ok and v or nil
end
function HB.one(p, want, pname)
	local c = charOf(p)
	if not c then return end
	local team = S.Friends[p.Name] == true
	local hm = c:FindFirstChildOfClass("Humanoid")
	local dead = hm ~= nil and hm.Health <= 0 and c:GetAttribute("TimeKnocked") == nil
	for _, nm in ipairs({ "Head", "HumanoidRootPart" }) do
		local pt = c:FindFirstChild(nm)
		if pt and pt:IsA("BasePart") then
			if nm == pname and not team and not dead then
				local o = HB.orig[pt]
				if not o then
					o = { pt.Size, pt.Transparency, pt.CanCollide, pt.Massless, dec = {} }
					HB.orig[pt] = o
					if nm == "Head" then HB.vis[pt] = HB.makeVis(pt, o) end
				end
				if pt.Size ~= want then pt.Size = want end
				if pt.CanCollide then pt.CanCollide = false end
				if not pt.Massless then pt.Massless = true end
				if not pt.CanQuery then pt.CanQuery = true end
				if pt.Transparency ~= 1 then pt.Transparency = 1 end
				for _, d in ipairs(pt:GetChildren()) do
					if d:IsA("Decal") and d.Transparency < 1 then o.dec[d] = o.dec[d] or d.Transparency d.Transparency = 1 end
				end
			elseif HB.orig[pt] then HB.restore(pt) end
		end
	end
end
function HB.tick()
	local n = math.clamp(S.HitboxSize, 2, 25)
	local want = Vector3.new(n, n, n)
	local pname = S.HitboxPart == "Body" and "HumanoidRootPart" or "Head"
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= L then pcall(HB.one, p, want, pname) end   -- one player erroring can't stop the rest
	end
end
C(Run.Stepped, function() HB.tick() end)
C(Run.RenderStepped, function()
	for pt, v in pairs(HB.vis) do
		if pt.Parent and v.Parent and HB.orig[pt] then v.CFrame = pt.CFrame
		else pcall(function() v:Destroy() end) HB.vis[pt] = nil end
	end
end)

-- ================================================================
-- MOVEMENT  (speed / inf jump / noclip / inf stamina)
-- ================================================================
MV = { saved = {}, lastJump = 0, stamMax = 150, idx = {}, cand = nil }
-- probe: the game keeps stamina inside its Movement controller (copied to the
-- Stamina attribute every frame). We find the game's REAL Update function, then:
-- sprint drain 0, run cost 0, regen instant, and keep the hidden number full.
do
	local getU = (debug and debug.getupvalues) or getupvalues
	local getU1 = (debug and debug.getupvalue) or getupvalue
	local setU = (debug and debug.setupvalue) or setupvalue
	MV.getU, MV.getU1, MV.setU = getU, getU1, setU
	local function fromUpd(f)
		if type(f) ~= "function" or not getU then return end
		local ok, ups = pcall(getU, f)
		if not ok or type(ups) ~= "table" then return end
		for _, v in pairs(ups) do
			if type(v) == "table" then
				if rawget(v, "MaxStamina") and rawget(v, "StaminaLostRate") then MV.cfg = v end
				if type(rawget(v, "DecreaseStamina")) == "function" then MV.mod = v end
			end
		end
		if MV.cfg then MV.upd = f end
	end
	task.spawn(function()
		task.wait(1)
		for try = 1, 20 do
			if not ALIVE or MV.cfg then break end
			-- 1) the live function, straight from memory
			if getgc and debug and debug.info then
				pcall(function()
					local gc = getgc()
					for i = 1, #gc do
						local f = gc[i]
						if type(f) == "function" and not (iscclosure and iscclosure(f)) then
							local ok, src = pcall(debug.info, f, "s")
							if ok and type(src) == "string" and src:find("Controllers%.Movement$") then
								local ok2, nm = pcall(debug.info, f, "n")
								if ok2 and nm == "Update" then fromUpd(f) if MV.cfg then break end end
							end
						end
						if i % 20000 == 0 then task.wait() end
					end
				end)
			end
			-- 2) backup: require the module
			if not MV.cfg then
				pcall(function()
					local m = RS.Modules.Client.Controllers.Movement
					local t = require(m)
					if type(t) == "table" then fromUpd(rawget(t, "Update")) end
				end)
			end
			if not MV.cfg then task.wait(3) end
		end
		if MV.cfg then
			pcall(function() if setreadonly then setreadonly(MV.cfg, false) end end)
			MV.cfgOrig = { StaminaLostRate = MV.cfg.StaminaLostRate, StartRunCost = MV.cfg.StartRunCost, StaminaGainRate = MV.cfg.StaminaGainRate }
		end
		log("stamina: cfg " .. tostring(MV.cfg ~= nil) .. "  update " .. tostring(MV.upd ~= nil))
		if S.InfStamina then
			notify("Infinite Stamina", MV.cfg and "Ready - sprint and jump forever" or "Couldn't find the game's stamina - send me Gun + Aim Scan", MV.cfg and "zap" or "alert-triangle")
		end
	end)
end
function MV.setCfg(on)
	local c, o = MV.cfg, MV.cfgOrig
	if not (c and o) or MV.cfgOn == on then return end
	if pcall(function()
		c.StaminaLostRate = on and 0 or o.StaminaLostRate
		c.StartRunCost = on and 0 or o.StartRunCost
		c.StaminaGainRate = on and 100000 or o.StaminaGainRate
	end) then MV.cfgOn = on end
end
function MV.stamTick()
	local c = char()
	local st = c and tonumber(c:GetAttribute("Stamina"))
	if st and st > MV.stamMax then MV.stamMax = st end
	if MV.cfg and MV.cfg.MaxStamina and MV.cfg.MaxStamina > MV.stamMax then MV.stamMax = MV.cfg.MaxStamina end
	MV.setCfg(S.InfStamina)
	if not (S.InfStamina and st and MV.upd and MV.getU and MV.setU) then return end
	local f = MV.upd
	-- learn which hidden number is your stamina (it follows the attribute while it is not full)
	if #MV.idx == 0 and st < MV.stamMax - 1 then
		local ok, ups = pcall(MV.getU, f)
		if ok and type(ups) == "table" then
			local now = {}
			for i, v in pairs(ups) do
				if type(v) == "number" and math.abs(v - st) < 1.5 then now[i] = true end
			end
			if MV.cand then for i in pairs(MV.cand) do if not now[i] then MV.cand[i] = nil end end else MV.cand = now end
			MV.samples = (MV.samples or 0) + 1
			local n = 0 for _ in pairs(MV.cand) do n += 1 end
			if n == 0 then MV.cand, MV.samples = nil, 0
			elseif MV.samples >= 3 and n <= 2 then for i in pairs(MV.cand) do MV.idx[#MV.idx + 1] = i end log("stamina: found (" .. n .. ")") end
		end
	end
	if st < MV.stamMax then
		for _, i in ipairs(MV.idx) do pcall(MV.setU, f, i, MV.stamMax) end
	end
end
C(Run.Heartbeat, function(dt)
	local hm, h = hum(), root()
	if not (hm and h) or GL.pin then return end
	if S.SpeedHack and hm.MoveDirection.Magnitude > 0.05 and not hm.SeatPart then
		h.CFrame = h.CFrame + hm.MoveDirection * (math.max(hm.WalkSpeed, 6) * (S.SpeedMult - 1)) * dt
	end
	MV.stamTick()
	if S.InfStamina then
		for _, a in ipairs({ "BlockStamina", "WeaveStamina" }) do
			local v = tonumber(L:GetAttribute(a))
			if v and v < 100 then L:SetAttribute(a, 100) end
		end
	end
end)
-- stamina circle: blue -> gold. scanned once, spread over frames. never walks the whole menu on a timer.
local GOLD = Color3.fromRGB(255, 196, 40)
local function isBlue(c) return c.B > 0.45 and c.B > c.R + 0.2 and c.B >= c.G - 0.02 end
task.spawn(function()
	local list = {}
	local seen = setmetatable({}, { __mode = "k" })
	local function paint(d)
		if d:IsA("ImageLabel") or d:IsA("ImageButton") then if isBlue(d.ImageColor3) then d.ImageColor3 = GOLD end end
		if d:IsA("GuiObject") and d.BackgroundTransparency < 1 and isBlue(d.BackgroundColor3) then d.BackgroundColor3 = GOLD end
		if d:IsA("UIStroke") and isBlue(d.Color) then d.Color = GOLD end
		if (d:IsA("TextLabel") or d:IsA("TextButton")) and isBlue(d.TextColor3) then d.TextColor3 = GOLD end
		if d:IsA("UIGradient") then
			local ks, ch = {}, false
			for _, k in ipairs(d.Color.Keypoints) do
				if isBlue(k.Value) then ks[#ks + 1] = ColorSequenceKeypoint.new(k.Time, GOLD) ch = true else ks[#ks + 1] = k end
			end
			if ch then d.Color = ColorSequence.new(ks) end
		end
	end
	local function consider(d)
		if seen[d] or not d.Parent or isOurs(d) then return end
		local x, hit = d, false
		for _ = 1, 4 do
			if not x or x == PG then break end
			local n = x.Name:lower()
			if n:find("stam", 1, true) or n:find("sprint", 1, true) then hit = true break end
			x = x.Parent
		end
		if not hit then return end
		seen[d] = true
		list[#list + 1] = d
		if d:IsA("ImageLabel") or d:IsA("ImageButton") or d:IsA("Frame") then
			local prop = d:IsA("Frame") and "BackgroundColor3" or "ImageColor3"
			C(d:GetPropertyChangedSignal(prop), function()
				if S.GoldStamina and isBlue(d[prop]) and (prop ~= "BackgroundColor3" or d.BackgroundTransparency < 1) then d[prop] = GOLD end
			end)
		end
	end
	task.spawn(function()
		local all = PG:GetDescendants()
		for i = 1, #all do
			consider(all[i])
			if i % 140 == 0 then task.wait() end
		end
	end)
	C(PG.DescendantAdded, function(d) if S.GoldStamina then task.defer(consider, d) end end)
	while ALIVE do
		if S.GoldStamina then
			for _, d in ipairs(list) do if d.Parent then pcall(paint, d) end end
		end
		task.wait(0.5)
	end
end)
-- ================================================================
-- ANTI-KILL  (teleports underground when you get downed)
-- ================================================================
local AK = { on = false, pos = nil }
-- ONLY when you get DOWNED (knocked): go underground so nobody can finish you.
-- The second you get back up: back on the surface. Nothing else ever puts you underground.
function AK.downed(c) return c ~= nil and c:GetAttribute("TimeKnocked") ~= nil end
task.spawn(function()
	while ALIVE do
		local c, hm, h = char(), hum(), root()
		local down = AK.downed(c)
		if S.AntiKill and h and hm and down then
			if not AK.on and not GL.pin then
				AK.on, AK.pos = true, h.Position
				GL.tele = true
				GL.noclip = true
				local _, yaw = h.CFrame:ToEulerAnglesYXZ()
				GL.yaw = yaw
				holdAt(AK.pos - Vector3.new(0, S.AntiKillDepth, 0))
				notify("Anti-Kill", "Downed - teleported underground", "shield")
			end
		elseif AK.on then
			if GL.pin then GL.tele = true end
			if S.AntiKill and hm and h and hm.Health > 0 and not down then
				AK.return_()
				notify("Anti-Kill", "You got up - back on the surface", "arrow-up")
			else
				AK.on = false release()
			end
		end
		task.wait(0.1)
	end
end)

-- The server may repeatedly pull a downed avatar back toward the surface. While
-- Anti-Kill is active, hard-correct that pull before and after physics instead
-- of waiting for the normal glide pin to catch up on the next visible frame.
function AK.snapBack()
	if not (S.AntiKill and AK.on and GL.pin) then return end
	local c, hm, h = char(), hum(), root()
	if not (c and hm and h and hm.Health > 0 and AK.downed(c)) then return end
	local target = GL.pin
	if (h.Position - target).Magnitude > 0.35 then
		local cf = CFrame.new(target) * CFrame.Angles(0, GL.yaw or 0, 0)
		pcall(function() c:PivotTo(cf) end)
		h.AssemblyLinearVelocity = Vector3.zero
		h.AssemblyAngularVelocity = Vector3.zero
		hm.PlatformStand = true
		GL.tele = true
	end
end
C(Run.PreSimulation, AK.snapBack)
C(Run.PostSimulation, AK.snapBack)
C(Run.RenderStepped, AK.snapBack)

-- ================================================================
-- ANTI-RAGDOLL: cars / RPG / hits can't knock you over or fling you (not while downed)
-- ================================================================
do
	local RAGS = { Enum.HumanoidStateType.Ragdoll, Enum.HumanoidStateType.FallingDown, Enum.HumanoidStateType.Physics }
	local off, motors, mChar, mT = nil, {}, nil, 0
	local function setStates(hm, on)
		for _, st in ipairs(RAGS) do pcall(hm.SetStateEnabled, hm, st, on) end
	end
	C(Run.Heartbeat, function()
		local c, hm, h = char(), hum(), root()
		local ok = S.AntiRagdoll and c and hm and h and hm.Health > 0 and not AK.downed(c) and not GL.pin
		if not ok then
			if off and off.Parent then setStates(off, true) end
			off = nil
			return
		end
		if off ~= hm then setStates(hm, false) off = hm end
		if mChar ~= c or os.clock() - mT > 3 then
			mChar, mT, motors = c, os.clock(), {}
			for _, d in ipairs(c:GetDescendants()) do if d:IsA("Motor6D") then motors[#motors + 1] = d end end
		end
		local rag = false
		local st = hm:GetState()
		if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown or st == Enum.HumanoidStateType.Physics then rag = true end
		if c:GetAttribute("Ragdolled") == true or c:GetAttribute("Ragdoll") == true then rag = true end
		if hm.PlatformStand and not hm.SeatPart then rag = true end
		for _, m in ipairs(motors) do
			if m.Parent and not m.Enabled then m.Enabled = true rag = true end
		end
		if rag then
			hm.PlatformStand = false
			pcall(function() hm:ChangeState(Enum.HumanoidStateType.GettingUp) end)
		end
		-- fling stop: a car / explosion launching you
		if not hm.SeatPart then
			local v = h.AssemblyLinearVelocity
			local flat = Vector3.new(v.X, 0, v.Z)
			if flat.Magnitude > 70 or v.Y > 60 then
				h.AssemblyLinearVelocity = Vector3.new(0, math.min(v.Y, 0), 0)
				h.AssemblyAngularVelocity = Vector3.zero
			end
		end
	end)
end
function AK.return_()
	if not AK.on then return end
	AK.on = false
	if AK.pos and GL.pin then GL.tele = true GL.noclip = true GL.pin = AK.pos applyPin() task.wait(0.12) end
	release()
end

-- SNAP button: always in the corner. Tap = down / up. The circle next to it drags it.
AK.sn = { on = false, dead = nil }
do
	local SN = AK.sn
	local function watchDeath(c)
		local hm = c:WaitForChild("Humanoid", 10)
		if not hm then return end
		C(hm.Died, function()
			if AK.on and AK.pos then SN.dead = AK.pos
			elseif SN.on and GL.pin then SN.dead = GL.pin + Vector3.new(0, S.AntiKillDepth, 0) end
		end)
	end
	if char() then task.spawn(watchDeath, char()) end
	C(L.CharacterAdded, function(c) SN.on = false task.spawn(watchDeath, c) end)
	function SN.floorBottom(origin)
		local rp = rayParams()
		local hit = workspace:Raycast(origin + Vector3.new(0, 4, 0), Vector3.new(0, -80, 0), rp)
		if not hit then return origin.Y - 2 end
		local inst = hit.Instance
		if inst and not inst:IsA("Terrain") then
			local cf, size = inst.CFrame, inst.Size
			local low = hit.Position.Y
			for _, sx in ipairs({ -0.5, 0.5 }) do
				for _, sy in ipairs({ -0.5, 0.5 }) do
					for _, sz in ipairs({ -0.5, 0.5 }) do
						local w = (cf * CFrame.new(sx * size.X, sy * size.Y, sz * size.Z)).Position
						if w.Y < low then low = w.Y end
					end
				end
			end
			return low
		end
		return hit.Position.Y
	end
	function SN.down()
		local h, hm = root(), hum()
		if not h or not hm or hm.Health <= 0 then return end
		if hm.SeatPart then notify("Snap", "Get out of the car first", "x") return end
		if GL.pin then notify("Snap", "You're already underground", "x") return end
		SN.on = true
		local _, yaw = h.CFrame:ToEulerAnglesYXZ()
		GL.yaw = yaw
		local bottom = SN.floorBottom(h.Position)
		SN.gap = bottom - 6
		GL.noclip = true
		holdAt(Vector3.new(h.Position.X, math.min(h.Position.Y - S.AntiKillDepth, SN.gap), h.Position.Z))
	end
	function SN.up()
		if not SN.on then return end
		SN.on = false
		GL.noclip = true
		if GL.pin then
			GL.pin = GL.pin + Vector3.new(0, S.AntiKillDepth, 0)
			local t0 = os.clock()
			while GL.pin and os.clock() - t0 < 1.4 do
				local h = root()
				if h and (h.Position - GL.pin).Magnitude < 2.5 then break end
				task.wait()
			end
		end
		release()
	end
	C(Run.Heartbeat, function(dt)
		if not SN.on then return end
		local hm, h = hum(), root()
		if not GL.pin or not hm or hm.Health <= 0 then SN.on = false return end
		local md = hm.MoveDirection
		local flat = Vector3.new(md.X, 0, md.Z)
		if h and SN.gap and h.Position.Y <= SN.gap + 1.5 then GL.noclip = false end
		if flat.Magnitude > 0.05 then
			flat = flat.Unit
			GL.pin = GL.pin + flat * 16 * math.min(dt, 0.1)
			GL.yaw = math.atan2(-flat.X, -flat.Z)
		end
	end)
	local b = Instance.new("TextButton")
	local pos = S.SnapPos
	b.Name, b.AnchorPoint = "Snap", Vector2.new(0, 0)
	b.Position = (type(pos) == "table" and tonumber(pos[1])) and UDim2.new(pos[1], pos[2], pos[3], pos[4]) or UDim2.new(0, 14, 0, 70)
	b.Size, b.BackgroundColor3, b.BackgroundTransparency, b.AutoButtonColor = UDim2.fromOffset(84, 46), Color3.fromRGB(28, 28, 31), 0.1, true
	b.Font, b.TextSize, b.TextColor3, b.Text = Enum.Font.GothamBold, 15, Color3.new(1, 1, 1), "SNAP v"
	b.TextWrapped, b.Visible = true, true
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	local st = Instance.new("UIStroke") st.Color, st.Thickness, st.ApplyStrokeMode = Color3.fromRGB(160, 160, 168), 1.5, Enum.ApplyStrokeMode.Border st.Parent = b
	b.Parent = HUD
	SN.btn = b
	C(b.Activated, function()
		if SN.on then task.spawn(SN.up) else SN.down() end
	end)
	local hd = Instance.new("TextButton")
	hd.Name, hd.AnchorPoint, hd.Position, hd.Size = "SnapDrag", Vector2.new(0, 0.5), UDim2.new(1, 6, 0.5, 0), UDim2.fromOffset(24, 24)
	hd.BackgroundColor3, hd.BackgroundTransparency, hd.AutoButtonColor, hd.Text, hd.Visible = Color3.fromRGB(28, 28, 31), 0.1, false, "", true
	Instance.new("UICorner", hd).CornerRadius = UDim.new(1, 0)
	local hs = Instance.new("UIStroke") hs.Color, hs.Thickness, hs.ApplyStrokeMode = Color3.fromRGB(160, 160, 168), 1.5, Enum.ApplyStrokeMode.Border hs.Parent = hd
	local dot = Instance.new("Frame")
	dot.AnchorPoint, dot.Position, dot.Size, dot.BackgroundColor3, dot.BorderSizePixel = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.5), UDim2.fromOffset(8, 8), Color3.fromRGB(200, 200, 205), 0
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
	dot.Parent = hd
	hd.Parent = b
	local down, p0, s0
	C(hd.InputBegan, function(i)
		if i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1 then down, p0, s0 = i, b.Position, i.Position end
	end)
	C(UIS.InputChanged, function(i)
		if down and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseMovement) then
			local d = i.Position - s0
			b.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
		end
	end)
	C(UIS.InputEnded, function(i)
		if down and (i.UserInputType == Enum.UserInputType.Touch or i.UserInputType == Enum.UserInputType.MouseButton1) then
			down = nil
			local q = b.Position
			S.SnapPos = { q.X.Scale, q.X.Offset, q.Y.Scale, q.Y.Offset } save()
		end
	end)
	task.spawn(function()
		while ALIVE do
			b.Visible, hd.Visible = true, true
			local txt = "SNAP v"
			if SN.on then txt = "UP ^"
			else
				local h = root()
				if SN.dead and h then
					local d = math.floor((Vector3.new(SN.dead.X, 0, SN.dead.Z) - Vector3.new(h.Position.X, 0, h.Position.Z)).Magnitude)
					if d <= 1500 then txt = "SNAP v\nloot " .. d .. "m" end
				end
			end
			if b.Text ~= txt then b.Text = txt b.TextSize = txt:find("\n") and 13 or 15 end
			task.wait(0.25)
		end
	end)
end

-- ================================================================
-- HIDE NAME  (****** on YOUR screen)
-- ================================================================
local HN = { orig = setmetatable({}, { __mode = "k" }), watched = setmetatable({}, { __mode = "k" }) }
local function esc(s) return (s:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0")) end
function HN.fix(l)
	if not (l:IsA("TextLabel") or l:IsA("TextButton")) or isOurs(l) then return end
	local t = l.Text
	if t:find(L.Name, 1, true) or (L.DisplayName ~= "" and t:find(L.DisplayName, 1, true)) then
		if not HN.watched[l] then
			HN.watched[l] = true
			C(l:GetPropertyChangedSignal("Text"), function() if S.HideName and not l.Text:find("*") then HN.fix(l) end end)
		end
		if S.HideName then
			HN.orig[l] = t
			l.Text = t:gsub(esc(L.Name), "******"):gsub(L.DisplayName ~= "" and esc(L.DisplayName) or "\0", "******")
		end
	end
end
function HN.scan()
	for _, d in ipairs(PG:GetDescendants()) do HN.fix(d) end
	local c = char()
	if c then for _, d in ipairs(c:GetDescendants()) do HN.fix(d) end end
end
function HN.set(v)
	S.HideName = v
	if v then HN.scan() else for l, t in pairs(HN.orig) do if l.Parent then pcall(function() l.Text = t end) end end HN.orig = setmetatable({}, { __mode = "k" }) end
end
C(PG.DescendantAdded, function(d) if S.HideName then task.defer(HN.fix, d) end end)
C(L.CharacterAdded, function(c) task.wait(1.5) if S.HideName then HN.scan() end end)
if S.HideName then task.delay(2, HN.scan) end

-- ================================================================
-- BULLET TRACERS  (only you see them - drawn when the game counts a shot)
-- ================================================================
local TR = { last = tonumber(L:GetAttribute("TotalBullet")) or 0 }
TR.COLORS = { Red = Color3.fromRGB(255, 40, 40), White = Color3.new(1, 1, 1), Gold = Color3.fromRGB(255, 200, 40),
	Blue = Color3.fromRGB(60, 160, 255), Green = Color3.fromRGB(60, 255, 100), Purple = Color3.fromRGB(180, 80, 255) }
function TR.draw()
	local cam = workspace.CurrentCamera
	local c = char()
	local tool = c and c:FindFirstChildOfClass("Tool")
	if not (cam and tool) then return end
	local from
	for _, d in ipairs(tool:GetDescendants()) do
		local n = d.Name:lower()
		if (n:find("muzzle") or n:find("firepoint") or n:find("barrel")) then
			if d:IsA("Attachment") then from = d.WorldPosition break elseif d:IsA("BasePart") then from = d.Position break end
		end
	end
	local hd = tool:FindFirstChild("Handle")
	from = from or (hd and hd.Position)
	if not from then return end
	local to
	if AIM.part and AIM.part.Parent then to = AIM.part.Position
	else
		local cx, cy = AIM.crosshair()
		local vp = cam.ViewportSize
		local ray = cam:ViewportPointToRay(cx or vp.X / 2, cy or vp.Y / 2)
		local rp = RaycastParams.new()
		rp.FilterType = Enum.RaycastFilterType.Exclude
		rp.FilterDescendantsInstances = { c, workspace:FindFirstChild("GunIgnore") }
		local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, rp)
		to = hit and hit.Position or (ray.Origin + ray.Direction * 1000)
	end
	local len = (to - from).Magnitude
	local p = Instance.new("Part")
	p.Anchored, p.CanCollide, p.CanTouch, p.CastShadow = true, false, false, false
	pcall(function() p.CanQuery = false end)
	p.Material, p.Color = Enum.Material.Neon, TR.COLORS[S.TracerColor] or TR.COLORS.Red
	p.Size = Vector3.new(0.12, 0.12, len)
	p.CFrame = CFrame.lookAt(from, to) * CFrame.new(0, 0, -len / 2)
	p.Parent = cam
	task.spawn(function()
		for k = 1, 8 do p.Transparency = k / 8 task.wait(0.04) end
		p:Destroy()
	end)
end
C(L:GetAttributeChangedSignal("TotalBullet"), function()
	local n = tonumber(L:GetAttribute("TotalBullet")) or 0
	if n > TR.last and S.Tracers then pcall(TR.draw) end
	TR.last = n
end)

-- ================================================================
-- UI  (WindUI - same look as the paid PVP script)
-- ================================================================
-- no animations: every WindUI tween is made instant (0 seconds)
local function bootNote(msg, keep)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", { Title = "drixnvsp", Text = msg, Duration = 8 })
	end)
	local sg = Instance.new("ScreenGui")
	sg.Name = "drixnvspBoot"
	sg.ResetOnSpawn = false
	sg.IgnoreGuiInset = true
	sg.DisplayOrder = 100000
	local parents = {}
	if type(gethui) == "function" then
		local ok, h = pcall(gethui)
		if ok and h then parents[#parents + 1] = h end
	end
	parents[#parents + 1] = PG
	pcall(function() parents[#parents + 1] = game:GetService("CoreGui") end)
	for _, par in ipairs(parents) do
		local ok = pcall(function() sg.Parent = par end)
		if ok and sg.Parent then break end
	end
	local f = Instance.new("TextLabel", sg)
	f.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	f.TextColor3 = Color3.new(1, 1, 1)
	f.Font = Enum.Font.GothamBold
	f.TextSize = 16
	f.TextWrapped = true
	f.TextXAlignment = Enum.TextXAlignment.Left
	f.TextYAlignment = Enum.TextYAlignment.Top
	f.Position = UDim2.fromOffset(12, 70)
	f.Size = UDim2.new(1, -24, 0, 72)
	f.Text = "  " .. msg
	if not keep then
		task.delay(4, function() pcall(function() sg:Destroy() end) end)
	end
	return sg
end
bootNote("drixnvsp is loading the menu...")
-- The menu library is DOWNLOADED. That download is the single thing that used
-- to stop the whole script on some phones: no menu -> "return" -> no features,
-- no ESP, nothing. So it is now its own step with more mirrors, and failing it
-- only costs you the menu, never the script.
local WIND_CACHE = "drixnvsp_windui.lua"
local WIND_URLS = {
	"https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua",
	"https://cdn.jsdelivr.net/gh/Footagesus/WindUI@main/dist/main.lua",
	"https://github.com/Footagesus/WindUI/releases/download/1.6.66/main.lua",
	"https://cdn.statically.io/gh/Footagesus/WindUI/main/dist/main.lua",
	"https://raw.githack.com/Footagesus/WindUI/main/dist/main.lua",
}
local function windUsable(s)
	return type(s) == "string" and #s > 1000 and s:find("CreateWindow", 1, true) ~= nil
end
local function windSrc()
	local src
	pcall(function()
		if isfile and readfile and isfile(WIND_CACHE) then
			local saved = readfile(WIND_CACHE)
			if windUsable(saved) then src = saved end
		end
	end)
	if not src then
		for _ = 1, 2 do
			for _, u in ipairs(WIND_URLS) do
				src = httpGet(u)
				if windUsable(src) then break end
				src = nil
			end
			if src then break end
			task.wait(0.3)
		end
	end
	if not src then return nil end
	pcall(function() if writefile then writefile(WIND_CACHE, src) end end)
	return src
end


-- ---------------------------------------------------------------
-- UI OBJECTS EXIST EVEN WHEN THE MENU DOES NOT
-- Every feature below only READS these (status text, config load). Stubbing
-- them means nothing in the script ever touches a nil menu object, so a dead
-- menu can no longer be a dead script.
-- ---------------------------------------------------------------
local UI = { el = {} }
do
	local function stub()
		return { Set = function() end, Select = function() end, SetDesc = function() end, Refresh = function() end }
	end
	UI.aimP, UI.gunP, UI.shopP = stub(), stub(), stub()
end

-- ---------------------------------------------------------------
-- MINI PANEL  (takes over when the downloaded menu is unavailable)
-- Core switches only, so the script is still usable on a phone whose
-- executor cannot fetch WindUI.
-- ---------------------------------------------------------------
local MINI = {}
function MINI.build()
	local par = hudParent()
	local old = par:FindFirstChild("drixMini") if old then old:Destroy() end
	local sg = Instance.new("ScreenGui")
	sg.Name, sg.ResetOnSpawn, sg.IgnoreGuiInset, sg.DisplayOrder = "drixMini", false, true, 70
	pcall(function() sg.ScreenInsets = Enum.ScreenInsets.None end)
	if not pcall(function() sg.Parent = par end) then pcall(function() sg.Parent = PG end) end
	MINI.sg = sg

	notify = function(t, c) pcall(function() SB.toast(tostring(t), tostring(c or "")) end) end

	local tab = Instance.new("TextButton")
	tab.Name, tab.Text, tab.AutoButtonColor = "MiniTab", "", false
	tab.Size, tab.Position = UDim2.fromOffset(120, 32), UDim2.new(0, 12, 0, 44)
	tab.BackgroundColor3, tab.BackgroundTransparency, tab.BorderSizePixel = Color3.fromRGB(120, 24, 26), 0.05, 0
	tab.Parent = sg
	Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 16)
	local tl = Instance.new("TextLabel")
	tl.Size, tl.BackgroundTransparency, tl.Text = UDim2.fromScale(1, 1), 1, "DRIX  MENU"
	tl.Font, tl.TextSize, tl.TextColor3 = Enum.Font.GothamBold, 13, Color3.fromRGB(245, 245, 245)
	tl.Parent = tab

	local body = Instance.new("Frame")
	body.Size, body.Position = UDim2.fromOffset(228, 372), UDim2.new(0, 12, 0, 82)
	body.BackgroundColor3, body.BackgroundTransparency, body.BorderSizePixel = Color3.fromRGB(13, 13, 15), 0.04, 0
	body.Active, body.Visible, body.ClipsDescendants = true, false, true
	body.Parent = sg
	Instance.new("UICorner", body).CornerRadius = UDim.new(0, 10)
	local bs = Instance.new("UIStroke", body)
	bs.Color, bs.Thickness, bs.Transparency = Color3.fromRGB(140, 34, 38), 1.5, 0.15

	local head = Instance.new("TextLabel")
	head.Size, head.Position, head.BackgroundTransparency = UDim2.new(1, -16, 0, 22), UDim2.fromOffset(8, 5), 1
	head.Font, head.TextSize, head.TextColor3, head.TextXAlignment = Enum.Font.GothamBold, 12, Color3.fromRGB(235, 90, 90), Enum.TextXAlignment.Left
	head.Text = "drixnvsp  -  no menu"
	head.Parent = body

	tab.MouseButton1Click:Connect(function() body.Visible = not body.Visible end)

	local LIST = Instance.new("Frame")
	LIST.Size, LIST.Position, LIST.BackgroundTransparency = UDim2.new(1, -16, 0, 236), UDim2.fromOffset(8, 30), 1
	LIST.Parent = body
	local ll = Instance.new("UIListLayout", LIST)
	ll.Padding, ll.SortOrder = UDim.new(0, 4), Enum.SortOrder.LayoutOrder

	local function row(label, key, after)
		local b = Instance.new("TextButton")
		b.Size, b.BorderSizePixel, b.Font, b.TextSize = UDim2.new(1, 0, 0, 24), 0, Enum.Font.GothamBold, 12
		b.TextColor3, b.TextXAlignment, b.AutoButtonColor = Color3.fromRGB(235, 235, 240), Enum.TextXAlignment.Left, false
		b.Parent = LIST
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		local function paint()
			b.Text = "   " .. label .. ": " .. (S[key] and "ON" or "OFF")
			b.BackgroundColor3 = S[key] and Color3.fromRGB(52, 104, 74) or Color3.fromRGB(38, 38, 44)
		end
		b.MouseButton1Click:Connect(function()
			S[key] = not S[key]
			paint()
			pcall(save)
			if after then pcall(after) end
		end)
		paint()
		return b
	end

	row("Aimbot", "AimOn")
	row("ESP", "ESP")
	row("Tracers", "Tracers")
	row("Chams", "Chams")
	row("Gun Mods", "RPM", function() GM.apply() end)
	row("No Recoil", "NoRecoil", function() GM.apply() end)
	row("Speed Hack", "SpeedHack")
	row("Inf Stamina", "InfStamina")
	row("Stable Car", "StableCar")

	local B = Instance.new("Frame")
	B.Size, B.Position, B.BackgroundTransparency = UDim2.new(1, -16, 0, 30), UDim2.fromOffset(8, 272), 1
	B.Parent = body
	local bl = Instance.new("UIListLayout", B)
	bl.FillDirection, bl.Padding = Enum.FillDirection.Horizontal, UDim.new(0, 6)

	local function pbtn(text, col, fn)
		local b = Instance.new("TextButton")
		b.Size, b.BackgroundColor3, b.BorderSizePixel, b.Font, b.TextSize = UDim2.fromOffset(70, 28), col, 0, Enum.Font.GothamBold, 11
		b.TextColor3, b.Text, b.Parent = Color3.fromRGB(245, 245, 245), text, B
		Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
		b.MouseButton1Click:Connect(fn)
		return b
	end

	pbtn("MENU FIX", Color3.fromRGB(50, 92, 150), function()
		local b = B:FindFirstChildOfClass("TextButton")
		task.spawn(function()
			pcall(function() if b then b.Text = "WAIT.." end end)
			local got = windSrc()
			pcall(function()
				if b then b.Text = got and "SAVED" or "NO NET" end
			end)
			notify("Menu fix", got and "Menu saved - run the script again for the full menu"
				or "Could not download the menu. Try Wi-Fi.")
		end)
	end)
	pbtn("SAVE", Color3.fromRGB(60, 60, 70), function() save() notify("Config", "Saved", "check") end)
	pbtn("HIDE", Color3.fromRGB(60, 60, 70), function() body.Visible = false end)

	local st = Instance.new("TextLabel")
	st.Size, st.Position, st.BackgroundTransparency = UDim2.new(1, -16, 0, 60), UDim2.fromOffset(8, 306), 1
	st.Font, st.TextSize, st.TextColor3, st.TextWrapped = Enum.Font.GothamMedium, 10, Color3.fromRGB(150, 150, 158), true
	st.TextXAlignment, st.TextYAlignment = Enum.TextXAlignment.Left, Enum.TextYAlignment.Top
	st.Text = "script is running without its menu - every feature above still works."
	st.Parent = body

	task.spawn(function()
		while sg.Parent do
			local n = 0
			for _ in pairs(FAIL) do n += 1 end
			pcall(function()
				st.Text = (n == 0 and "all systems ok"
					or (n .. " part(s) disabled on this phone:\n" .. (function()
						local s = {}
						for k in pairs(FAIL) do s[#s + 1] = k end
						return table.concat(s, ", ")
					end)()))
			end)
			task.wait(2)
		end
	end)
end

local WindUI = (function()
	local src = windSrc()
	if not src then
		bootNote("Menu download failed - the script still runs. Tap MENU FIX on the small panel.", true)
		return nil
	end
	local loadfn = loadstring or load or envfn("loadstring") or envfn("load")
	if type(loadfn) ~= "function" then
		bootNote("This Delta can't run the menu. Update Delta and run it again.", true)
		return nil
	end
	local function run(code)
		local f = loadfn(code)
		if not f then return nil end
		local ok, lib = pcall(f)
		if ok and type(lib) == "table" then return lib end
	end
	local lib = run(src)
	if lib then return lib end
	local fast
	pcall(function()
		fast = "local DRIX_TI=function() return TweenInfo.new(0) end\n" .. src:gsub("TweenInfo%.new%(", "DRIX_TI(")
	end)
	if fast then lib = run(fast) end
	if not lib then bootNote("Menu opened but this Delta rejected it. Update Delta and run it again.", true) end
	return lib
end)()
local LOGO_ID = 120412740818179
if not WindUI then
	-- OLD BUILD: "return" here -> nothing ran at all.
	-- NEW BUILD: menu missing only costs the menu.
	SAFE("mini panel", MINI.build)
else
-- gray theme (Hermanos look): gray checkboxes + white check, light gray sliders, dark cards
local THEME = "Dark"
pcall(function()
	local h = Color3.fromHex
	WindUI:AddTheme({
		Name = "drixGray",
		Accent = h("#18181b"), Dialog = h("#161618"), Outline = h("#FFFFFF"), Text = h("#FFFFFF"),
		Placeholder = h("#8a8a8f"), Background = h("#0f0f11"), Button = h("#3f3f46"), Icon = h("#a1a1aa"),
		Toggle = h("#5b5b63"), ToggleBar = h("#FFFFFF"),
		Checkbox = h("#4a4a52"), CheckboxIcon = h("#FFFFFF"), CheckboxBorder = h("#FFFFFF"), CheckboxBorderTransparency = 0.88,
		Slider = h("#d4d4d8"), SliderThumb = h("#FFFFFF"), SliderIcon = h("#908F95"),
		Primary = h("#d4d4d8"),
		PanelBackground = h("#FFFFFF"), PanelBackgroundTransparency = 0.95,
		LabelBackground = h("#000000"), LabelBackgroundTransparency = 0.83,
		ElementBackground = h("#28282c"), ElementBackgroundTransparency = 0.12,
	})
	THEME = "drixGray"
end)
UI.Window = WindUI:CreateWindow({
	Title = "drixnvsp | OPPS",
	Author = "[] - OPPS | drixnvsp",
	Icon = "rbxthumb://type=Asset&id=" .. LOGO_ID .. "&w=420&h=420",
	Folder = "drixnvspOPPS",
	Size = UDim2.fromOffset(580, 460),
	MinSize = Vector2.new(440, 260),
	MaxSize = Vector2.new(860, 580),
	Transparent = true,
	Theme = THEME,
	Resizable = true,
	SideBarWidth = 200,
	NewElements = true,
	HideSearchBar = false,
	ScrollBarEnabled = false,
	User = { Enabled = false },
	Topbar = { Height = 52, ButtonsType = "Default" },
	OpenButton = {
		Title = "drixnvsp | OPPS", Icon = "rbxthumb://type=Asset&id=" .. LOGO_ID .. "&w=420&h=420",
		CornerRadius = UDim.new(1, 0), StrokeThickness = 3, Enabled = false, Draggable = true, OnlyMobile = false,
		Color = ColorSequence.new(Color3.fromRGB(179, 20, 27), Color3.fromRGB(110, 10, 14)),
	},
})
local Window = UI.Window
pcall(function() Window:SetTheme(THEME) end)
pcall(function() WindUI:SetTheme(THEME) end)
pcall(function() Window:Tag({ Title = "v9.3 - PAID", Color = Color3.fromHex("#b3141b"), Border = true }) end)
pcall(function()
	Window:CreateTopbarButton("Discord", "link", function()
		pcall(function() (setclipboard or toclipboard)("https://discord.gg/8At9MJkUt") end) notify("Discord", "Invite copied", "check")
	end, 990)
end)
pcall(function() Window:SetToggleKey(Enum.KeyCode.RightShift) end)
-- open bar (pill) + square logo button
pcall(function()
	local par = hudParent()
	local old = par:FindFirstChild("drixOpenUI") if old then old:Destroy() end
	local sg = Instance.new("ScreenGui")
	sg.Name, sg.ResetOnSpawn, sg.IgnoreGuiInset, sg.DisplayOrder = "drixOpenUI", false, true, -100000
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	pcall(function() sg.ScreenInsets = Enum.ScreenInsets.None end)
	if not pcall(function() sg.Parent = par end) then sg.Parent = PG end
	UI.openSG = sg
	local logo = "rbxthumb://type=Asset&id=" .. LOGO_ID .. "&w=150&h=150"
	local RED = Color3.fromRGB(125, 22, 24)
	local function corner(o, r) Instance.new("UICorner", o).CornerRadius = r end
	local function logoImg(parent, size, r)
		local im = Instance.new("ImageLabel")
		im.Size, im.BackgroundColor3, im.BorderSizePixel = size, Color3.fromRGB(40, 8, 10), 0
		im.ScaleType, im.Image, im.Parent = Enum.ScaleType.Crop, logo, parent
		corner(im, r)
		return im
	end
	local pill = Instance.new("TextButton")
	pill.Name, pill.Text, pill.AutoButtonColor = "Pill", "", false
	pill.Size, pill.AnchorPoint, pill.Position = UDim2.fromOffset(214, 40), Vector2.new(0.5, 0), UDim2.new(0.5, 0, 0, 12)
	pill.BackgroundColor3, pill.BackgroundTransparency = Color3.new(0, 0, 0), 0.3
	pill.Parent = sg
	corner(pill, UDim.new(1, 0))
	local ps = Instance.new("UIStroke", pill)
	ps.Color, ps.Thickness, ps.ApplyStrokeMode = RED, 2, Enum.ApplyStrokeMode.Border
	local mv = Instance.new("ImageLabel")
	mv.Size, mv.Position, mv.AnchorPoint = UDim2.fromOffset(18, 18), UDim2.new(0, 22, 0.5, 0), Vector2.new(0.5, 0.5)
	mv.BackgroundTransparency, mv.ImageColor3, mv.ImageTransparency = 1, Color3.fromRGB(150, 150, 155), 0.15
	mv.Parent = pill
	if not pcall(function()
		local ic = WindUI.Creator.Icon("move")
		mv.Image = ic[1] mv.ImageRectSize = ic[2].ImageRectSize mv.ImageRectOffset = ic[2].ImageRectPosition
	end) or mv.Image == "" then
		local t = Instance.new("TextLabel", mv)
		t.Size, t.BackgroundTransparency, t.Text, t.TextScaled, t.TextColor3 = UDim2.fromScale(1, 1), 1, "+", true, Color3.fromRGB(150, 150, 155)
	end
	local dv = Instance.new("Frame")
	dv.Size, dv.Position = UDim2.new(0, 1, 1, 0), UDim2.fromOffset(44, 0)
	dv.BackgroundColor3, dv.BackgroundTransparency, dv.BorderSizePixel = Color3.fromRGB(70, 70, 75), 0.3, 0
	dv.Parent = pill
	local pl = logoImg(pill, UDim2.fromOffset(24, 24), UDim.new(0, 5))
	pl.AnchorPoint, pl.Position = Vector2.new(0, 0.5), UDim2.new(0, 56, 0.5, 0)
	local tt = Instance.new("TextLabel")
	tt.BackgroundTransparency, tt.Text = 1, "drixnvsp | OPPS"
	tt.Size, tt.Position = UDim2.new(1, -92, 1, 0), UDim2.fromOffset(88, 0)
	tt.TextColor3, tt.TextSize, tt.TextXAlignment, tt.Font = Color3.new(1, 1, 1), 15, Enum.TextXAlignment.Center, Enum.Font.GothamMedium
	pcall(function() tt.Font = Enum.Font.BuilderSansMedium tt.TextSize = 16 end)
	tt.Parent = pill
	local sq = Instance.new("ImageButton")
	sq.Name, sq.AutoButtonColor, sq.Size = "Square", true, UDim2.fromOffset(30, 30)
	sq.AnchorPoint = Vector2.new(0.5, 0)
	sq.BackgroundColor3, sq.BackgroundTransparency = Color3.fromRGB(12, 12, 14), 0
	sq.Parent = sg
	corner(sq, UDim.new(0, 8))
	local ss = Instance.new("UIStroke", sq)
	ss.Color, ss.Thickness, ss.ApplyStrokeMode = Color3.fromRGB(30, 30, 34), 2, Enum.ApplyStrokeMode.Border
	local sl = logoImg(sq, UDim2.fromScale(1, 1), UDim.new(0, 8)) sl.Active = false
	local sqMoved = false
	local function dragTap(btn, onTap, onDragged)
		local dragging, moved, s0, p0 = false, false, nil, nil
		C(btn.InputBegan, function(i)
			if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
				dragging, moved, s0, p0 = true, false, i.Position, btn.Position
				i.Changed:Connect(function()
					if i.UserInputState == Enum.UserInputState.End and dragging then
						dragging = false
						if not moved then pcall(onTap) elseif onDragged then onDragged() end
					end
				end)
			end
		end)
		C(UIS.InputChanged, function(i)
			if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
				local d = i.Position - s0
				if d.Magnitude > 6 then moved = true end
				if moved then btn.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y) end
			end
		end)
	end
	dragTap(pill, function() Window:Open() end)
	-- square: tap = open/close, HOLD 1 second then drag = move (hard to move by accident)
	do
		local down, t0, s0, p0, armed, slid, dragged = false, 0, nil, nil, false, false, false
		local sc = Instance.new("UIScale", sq)
		C(sq.InputBegan, function(i)
			if i.UserInputType ~= Enum.UserInputType.MouseButton1 and i.UserInputType ~= Enum.UserInputType.Touch then return end
			down, t0, s0, p0, armed, slid, dragged = true, os.clock(), i.Position, sq.Position, false, false, false
			local my = t0
			task.delay(1, function()
				if down and t0 == my and not slid then
					armed = true
					sc.Scale = 1.12 ss.Color = Color3.fromRGB(200, 200, 205)
				end
			end)
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End and down then
					down = false
					sc.Scale = 1 ss.Color = Color3.fromRGB(30, 30, 34)
					if dragged then sqMoved = true
					elseif not armed and not slid then pcall(function() Window:Toggle() end) end
				end
			end)
		end)
		C(UIS.InputChanged, function(i)
			if not down or (i.UserInputType ~= Enum.UserInputType.MouseMovement and i.UserInputType ~= Enum.UserInputType.Touch) then return end
			local d = i.Position - s0
			if not armed then
				if d.Magnitude > 10 then slid = true end   -- moved before 1s = nothing happens
				return
			end
			if not dragged then dragged = true s0 = i.Position p0 = sq.Position d = Vector3.zero end
			sq.Position = UDim2.new(p0.X.Scale, p0.X.Offset + d.X, p0.Y.Scale, p0.Y.Offset + d.Y)
		end)
	end
	task.spawn(function()
		while sg.Parent and ALIVE do
			if Window.Destroyed then sg:Destroy() break end
			pill.Visible = Window.Closed and true or false
			if not sqMoved then
				local pp = pill.Position   -- pill anchor = top middle, square anchor = top middle
				sq.Position = UDim2.new(pp.X.Scale, pp.X.Offset, pp.Y.Scale, pp.Y.Offset + pill.Size.Y.Offset + 5)
			end
			task.wait(0.15)
		end
	end)
end)
-- notifications: Roblox popup (like friend requests) with the logo
do
	local SG = game:GetService("StarterGui")
	local icon = "rbxthumb://type=Asset&id=" .. LOGO_ID .. "&w=150&h=150"
	notify = function(t, c, img)
		if LANG and LANG.tr then t, c = LANG.tr(t), LANG.tr(c) end
		task.spawn(function()
			for _ = 1, 10 do
				if pcall(SG.SetCore, SG, "SendNotification", { Title = tostring(t), Text = tostring(c), Icon = icon, Duration = 4 }) then return end
				task.wait(0.5)
			end
			pcall(function() WindUI:Notify({ Title = t, Content = c, Duration = 3, Icon = img or "info" }) end)
		end)
	end
end
SB.wnotify = function(t, c)
	if LANG and LANG.tr then t, c = LANG.tr(t), LANG.tr(c) end
	pcall(function() WindUI:Notify({ Title = tostring(t), Content = tostring(c), Duration = 2.5, Icon = "package" }) end)
end
-- ================================================================
-- AUTOFARM: AUTO ROB
-- glides UNDER THE MAP (goes deeper round anything solid down there), pops up RIGHT next to a
-- civilian, holds E, stays glued to them until the game says robbed, then straight back under.
-- ================================================================
G.AR = { on = false, robbed = {}, notes = {}, mul = 1, DEPTH = 9, SPEED = 42, refY = nil }
do
	local AR = G.AR
	local TIER = { Luxury = 5, Affluent = 4, Smart = 3, Everyday = 2, Casual = 1 }
	-- the game's messages ("Robbing... stay close", "You robbed $...")
	C(PG.DescendantAdded, function(d)
		if not AR.on or not d:IsA("TextLabel") or isOurs(d) then return end
		task.delay(0.05, function()
			if not d.Parent then return end
			local function add()
				local t = d.Text
				if #t > 2 and #t < 220 then
					AR.notes[#AR.notes + 1] = { t = os.clock(), s = t:lower() }
					if #AR.notes > 60 then table.remove(AR.notes, 1) end
				end
			end
			add()
			local c c = d:GetPropertyChangedSignal("Text"):Connect(function() if d.Parent then add() end end)
			task.delay(8, function() pcall(function() c:Disconnect() end) end)
		end)
	end)
	function AR.note(t0, words)
		for i = #AR.notes, 1, -1 do
			local n = AR.notes[i]
			if n.t < t0 then break end
			for _, w in ipairs(words) do if n.s:find(w, 1, true) then return n.s end end
		end
	end
	-- ray that only stops on solid stuff
	function AR.ray(o, d)
		local rp = rayParams()
		local ex = rp.FilterDescendantsInstances
		for _ = 1, 6 do
			local h = workspace:Raycast(o, d, rp)
			if not h then return nil end
			local p = h.Instance
			if p:IsA("Terrain") or (p.CanCollide and p.Transparency < 0.95) then return h end
			ex[#ex + 1] = p
			rp.FilterDescendantsInstances = ex
		end
	end
	-- road height at x,z (looks from just above the last road height, so roofs don't count)
	function AR.ground(x, z, y)
		local h = AR.ray(Vector3.new(x, y + 8, z), Vector3.new(0, -40, 0)) or AR.ray(Vector3.new(x, y + 40, z), Vector3.new(0, -90, 0))
		return h and h.Position.Y
	end
	function AR.clear(a, b)
		local d = b - a
		if d.Magnitude < 0.5 then return true end
		for _, o in ipairs({ Vector3.zero, Vector3.new(0, 2.5, 0), Vector3.new(0, -2.5, 0), Vector3.new(1.5, 0, 0), Vector3.new(0, 0, 1.5) }) do
			if AR.ray(a + o, d) then return false end
		end
		return true
	end
	function AR.line(p, speed, tok)
		local h = root()
		if not h then return false end
		holdAt(GL.pin or h.Position)
		while true do
			local dt = Run.Heartbeat:Wait()
			if stopped(tok) or not AR.on then return false end
			local d = p - GL.pin
			local m = d.Magnitude
			if m < 0.5 then GL.pin = p return true end
			if d.X * d.X + d.Z * d.Z > 1 then GL.yaw = math.atan2(-d.X, -d.Z) end
			GL.pin = GL.pin + d.Unit * math.min(m, speed * AR.mul * dt)
		end
	end
	-- the game pulled you back -> go a bit slower
	C(Run.Heartbeat, function()
		if not (AR.on and GL.pin) then return end
		local h = root()
		if h and (h.Position - GL.pin).Magnitude > 10 then
			AR.mul = math.max(0.4, AR.mul * 0.85)
			GL.pin = h.Position
		end
	end)
	function AR.ugAt(x, z)
		local g = AR.ground(x, z, AR.refY)
		if g and math.abs(g - AR.refY) < 40 then AR.refY = g end
		return AR.refY - AR.DEPTH
	end
	-- under the map all the way to right under `t`
	function AR.under(t, tok)
		local h = root()
		if not h then return false end
		local cur = GL.pin or h.Position
		if not AR.refY or not GL.pin then AR.refY = cur.Y - 3 end
		local y0 = AR.ugAt(cur.X, cur.Z)
		if cur.Y > y0 + 0.5 and not AR.line(Vector3.new(cur.X, y0, cur.Z), 70, tok) then return false end
		task.spawn(function() pcall(function() L:RequestStreamAroundAsync(t, 3) end) end)
		for _ = 1, 400 do
			local p = GL.pin
			local flat = Vector3.new(t.X - p.X, 0, t.Z - p.Z)
			if flat.Magnitude < 1 then return true end
			local step = flat.Magnitude > 50 and flat.Unit * 50 or flat
			local nx, nz = p.X + step.X, p.Z + step.Z
			local ny = AR.ugAt(nx, nz)
			-- something solid down here (basement, tunnel, pipe) -> go deeper until it's clear
			local extra = 0
			while extra < 36 and not AR.clear(Vector3.new(p.X, ny - extra, p.Z), Vector3.new(nx, ny - extra, nz)) do extra += 6 end
			local y = ny - extra
			if math.abs(y - p.Y) > 0.5 and not AR.line(Vector3.new(p.X, y, p.Z), 70, tok) then return false end
			if not AR.line(Vector3.new(nx, y, nz), AR.SPEED, tok) then return false end
		end
		return true
	end
	function AR.sink(tok)
		local h = root()
		if not h then return false end
		local p = GL.pin or h.Position
		AR.refY = AR.refY or (p.Y - 3)
		return AR.line(Vector3.new(p.X, AR.refY - AR.DEPTH, p.Z), 80, tok)
	end
	function AR.comeUp()
		local h = root()
		if GL.pin and h then
			local p = GL.pin
			local g = AR.ground(p.X, p.Z, AR.refY or p.Y)
			if g then GL.pin = Vector3.new(p.X, g + 3, p.Z) task.wait(0.1) end
		end
		release()
	end
	function AR.best()
		local f = workspace:FindFirstChild("Pedestrians")
		if not f then return nil end
		local h = root()
		local me = GL.pin or (h and h.Position) or Vector3.zero
		local cops, best, bs = {}, nil, nil
		for _, m in ipairs(f:GetChildren()) do
			if m.Name:find("Police") then local r = m:FindFirstChild("HumanoidRootPart") if r then cops[#cops + 1] = r.Position end end
		end
		for _, m in ipairs(f:GetChildren()) do
			local r, hm = m:FindFirstChild("HumanoidRootPart"), m:FindFirstChildOfClass("Humanoid")
			if r and hm and hm.Health > 0 and r:FindFirstChild("PromptDirect") and not m.Name:find("Police") and not m:GetAttribute("Ragdolled")
				and os.clock() - (AR.robbed[m] or -1e9) > 150 then
				local st = tostring(m:GetAttribute("PedestrianState") or ""):lower()
				local okSt = not (st:find("rob") or st:find("flee") or st:find("run") or st:find("scare") or st:find("knock") or st:find("dead")
					or st:find("pursu") or st:find("fight") or st:find("attack"))
				local safe = true
				for _, cp in ipairs(cops) do if (cp - r.Position).Magnitude < 90 then safe = false break end end
				if safe then
					for _, pl in ipairs(Players:GetPlayers()) do
						local ph = pl ~= L and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
						if ph and (ph.Position - r.Position).Magnitude < 35 then safe = false break end
					end
				end
				if okSt and safe then
					local tier = TIER[tostring(m:GetAttribute("WealthTier"))] or 1
					local score = Vector3.new(r.Position.X - me.X, 0, r.Position.Z - me.Z).Magnitude - tier * 120
					if not bs or score < bs then best, bs = { m = m, r = r }, score end
				end
			end
		end
		return best
	end
	-- fallback start: run the prompt's own module (same thing the E button runs)
	function AR.fire(r)
		local pd = r:FindFirstChild("PromptDirect")
		local m = pd and pd:IsA("ObjectValue") and pd.Value
		if not (m and m:IsA("ModuleScript")) then return end
		local ok, mod = safeRequire(m, 2)
		if not ok then return end
		local f = type(mod) == "function" and mod
		if type(mod) == "table" then
			for _, k in ipairs({ "OnPrompt", "Prompt", "Triggered", "Interact", "Event", "Activate", "Open", "Start" }) do
				if type(mod[k]) == "function" then f = mod[k] break end
			end
		end
		if f then task.spawn(pcall, f, r) end
	end
	function AR.rob(tok)
		local t = AR.best()
		if not t then return false end
		-- 1) under the map to right under them (they keep walking, so re-aim on the way)
		for _ = 1, 4 do
			if not AR.under(t.r.Position, tok) then return false end
			if not t.r.Parent then return true end
			local d = Vector3.new(t.r.Position.X - GL.pin.X, 0, t.r.Position.Z - GL.pin.Z).Magnitude
			if d < 8 then break end
		end
		if stopped(tok) or not AR.on or not t.r.Parent then return false end
		AR.robbed[t.m] = os.clock()
		local before = getNum("Cash")
		local t0 = os.clock()
		local function state() return tostring(t.m:GetAttribute("PedestrianState") or "") end
		local function started() return state() == "Robbing" or AR.note(t0, { "robbing..." }) ~= nil end
		local function goal()
			local pp = t.r.Position
			local lk = t.r.CFrame.LookVector
			local fl = Vector3.new(lk.X, 0, lk.Z)
			fl = fl.Magnitude > 0.01 and fl.Unit or Vector3.new(0, 0, 1)
			GL.yaw = math.atan2(-fl.X, -fl.Z)
			return pp - fl * 2   -- right next to them (just behind), same height, clear view
		end
		-- 2) straight up right next to them
		GL.pin = goal()
		task.wait(0.05)
		local done = false
		task.spawn(function()
			local t1 = os.clock()
			while os.clock() - t1 < 1.2 and not promptGui() do task.wait(0.05) end
			if promptGui() then pressPromptUI(0.9) end
			task.wait(0.5)
			if not started() then
				if promptGui() then pressPromptUI(0.9) task.wait(0.4) end
				if not started() then AR.fire(t.r) end
			end
			done = true
		end)
		local END = { "you robbed", "interrupted", "cannot", "can't", "cooldown", "already", "too far", "failed", "not enough" }
		local function over()
			if AR.note(t0, END) or state() == "Robbed" then return true end
			local c = getNum("Cash")
			if before and c and c > before then return true end
			return done and not started() and os.clock() - t0 > 4.5
		end
		-- 3) glued right next to them until it's done
		while not over() and os.clock() - t0 < 15 and not stopped(tok) and AR.on and t.r.Parent do
			Run.Heartbeat:Wait()
			GL.pin = goal()
		end
		-- 4) straight back under the map (police are coming)
		AR.refY = (t.r.Parent and t.r.Position.Y - 3) or AR.refY
		AR.sink(tok)
		local c = getNum("Cash")
		if before and c and c > before then SB.wnotify("Auto Rob", "+$" .. tostring(c - before)) end
		return true
	end
	function AR.loop(tok)
		while ALIVE and AR.on and tok == G.TOK do
			if not alive() then
				GL.pin, GL.saved, AR.refY = nil, {}, nil
				task.wait(1)
			else
				local hm = hum()
				if hm and hm.SeatPart then hm.Sit = false hm.Jump = true task.wait(0.5) end
				local ok, did = pcall(AR.rob, tok)
				if not ok then log("autorob: " .. tostring(did)) did = false end
				if not did and AR.on and tok == G.TOK and alive() then
					if not GL.pin then AR.refY = nil end
					AR.sink(tok)
					task.wait(1)
				end
			end
			task.wait(0.1)
		end
	end
	function AR.set(on)
		if on == AR.on then return end
		AR.on = on
		local tok = newTok()
		if on then
			AR.mul = 1
			task.spawn(AR.loop, tok)
		else
			task.spawn(AR.comeUp)
		end
	end
end

local function SEC(tab, title) return tab:Section({ Title = title }) end
local function TG(tab, title, desc, key, cb)
	local el = tab:Toggle({ Title = title, Desc = desc, Type = "Checkbox", Value = S[key], Default = S[key], Callback = function(v) S[key] = v save() if cb then cb(v) end end })
	UI.el[key] = el
	return el
end
local function SL(tab, title, desc, key, mn, mx, step, cb)
	local el = tab:Slider({ Title = title, Desc = desc, Step = step, Width = 175, IsTextbox = true, Value = { Min = mn, Max = mx, Default = S[key] }, Callback = function(v) S[key] = tonumber(v) or S[key] save() if cb then cb(v) end end })
	UI.el[key] = el
	-- easier to slide on a phone: thicker bar + a much taller touch area (tap the number to type it)
	pcall(function()
		local ue = el.UIElements
		local bar, box = ue.SliderIcon, ue.SliderContainer
		bar.Size = UDim2.new(bar.Size.X.Scale, bar.Size.X.Offset, 0, 7)
		local pad = Instance.new("UIPadding")
		pad.PaddingTop, pad.PaddingBottom = UDim.new(0, 16), UDim.new(0, 16)
		pad.Parent = box
		box.Active = true
		local th = bar:FindFirstChild("Frame") and bar.Frame:FindFirstChild("Thumb")
		if th then th.Size = UDim2.fromOffset(30, 20) end
	end)
	return el
end


-- language: stock English. Search any language and the menu text changes. Gameplay does not.
LANG = { code = "en", name = "English", cache = {}, items = {}, tabs = {} }
LANG.LIST = {
	{ "English", "en" }, { "Spanish / Espanol", "es" }, { "Portuguese / Portugues", "pt" },
	{ "French / Francais", "fr" }, { "German / Deutsch", "de" }, { "Italian / Italiano", "it" },
	{ "Dutch / Nederlands", "nl" }, { "Polish / Polski", "pl" }, { "Russian / Russkiy", "ru" },
	{ "Ukrainian", "uk" }, { "Turkish / Turkce", "tr" }, { "Arabic", "ar" }, { "Hebrew", "he" },
	{ "Hindi", "hi" }, { "Bengali", "bn" }, { "Urdu", "ur" }, { "Persian / Farsi", "fa" },
	{ "Chinese / Zhongwen", "zh" }, { "Japanese", "ja" }, { "Korean", "ko" },
	{ "Vietnamese", "vi" }, { "Thai", "th" }, { "Indonesian", "id" }, { "Malay", "ms" },
	{ "Filipino", "tl" }, { "Swedish", "sv" }, { "Norwegian", "no" }, { "Danish", "da" },
	{ "Finnish", "fi" }, { "Greek", "el" }, { "Czech", "cs" }, { "Romanian", "ro" },
	{ "Hungarian", "hu" }, { "Slovak", "sk" }, { "Bulgarian", "bg" }, { "Serbian", "sr" },
	{ "Croatian", "hr" }, { "Swahili", "sw" }, { "Afrikaans", "af" }, { "Tamil", "ta" },
	{ "Telugu", "te" }, { "Punjabi", "pa" }, { "Gujarati", "gu" }, { "Kannada", "kn" },
	{ "Malayalam", "ml" }, { "Marathi", "mr" }, { "Nepali", "ne" }, { "Sinhala", "si" },
	{ "Khmer", "km" }, { "Lao", "lo" }, { "Burmese", "my" }, { "Mongolian", "mn" },
	{ "Kazakh", "kk" }, { "Uzbek", "uz" }, { "Azerbaijani", "az" }, { "Georgian", "ka" },
	{ "Armenian", "hy" }, { "Albanian", "sq" }, { "Bosnian", "bs" }, { "Slovenian", "sl" },
	{ "Lithuanian", "lt" }, { "Latvian", "lv" }, { "Estonian", "et" }, { "Icelandic", "is" },
	{ "Irish", "ga" }, { "Welsh", "cy" }, { "Catalan", "ca" }, { "Basque", "eu" },
	{ "Galician", "gl" }, { "Haitian Creole", "ht" }, { "Somali", "so" }, { "Amharic", "am" },
	{ "Yoruba", "yo" }, { "Zulu", "zu" }, { "Kurdish", "ku" }, { "Pashto", "ps" },
}
function LANG.codeOf(name)
	name = tostring(name or "")
	local low = name:lower()
	if low == "" or low == "english" or low == "en" then return "en", "English" end
	for _, e in ipairs(LANG.LIST) do
		if e[1]:lower() == low or e[2] == low or e[1]:lower():find(low, 1, true) then return e[2], e[1] end
	end
	if #low <= 6 and low:match("^[%a%-]+$") then return low, name end
	return nil
end
function LANG.tr(s)
	if type(s) ~= "string" or s == "" or LANG.code == "en" then return s end
	return LANG.cache[s] or s
end
function LANG.track(el, title, desc)
	if el and (title or desc) then LANG.items[#LANG.items + 1] = { el = el, title = title, desc = desc } end
end
function LANG.paint()
	for _, it in ipairs(LANG.items) do
		pcall(function()
			if it.title and it.el.SetTitle then it.el:SetTitle(LANG.tr(it.title)) end
			if it.desc and it.el.SetDesc then it.el:SetDesc(LANG.tr(it.desc)) end
		end)
	end
	for _, tb in ipairs(LANG.tabs) do
		pcall(function()
			local text = LANG.tr(tb.title)
			local main = tb.el.UIElements and tb.el.UIElements.Main
			if main then
				for _, d in ipairs(main:GetDescendants()) do
					if d:IsA("TextLabel") then d.Text = text break end
				end
			end
		end)
	end
	pcall(function() Window:SetTitle(LANG.tr("drixnvsp | OPPS")) end)
end
function LANG.loadCache()
	LANG.cache = {}
	if LANG.code == "en" or not (isfile and readfile and isfile("drixnvsp_lang.json")) then return end
	pcall(function()
		local all = Http:JSONDecode(readfile("drixnvsp_lang.json"))
		if type(all[LANG.code]) == "table" then LANG.cache = all[LANG.code] end
	end)
end
function LANG.saveCache()
	pcall(function()
		if not writefile then return end
		local all = {}
		if isfile and isfile("drixnvsp_lang.json") then all = Http:JSONDecode(readfile("drixnvsp_lang.json")) or {} end
		all[LANG.code] = LANG.cache
		writefile("drixnvsp_lang.json", Http:JSONEncode(all))
	end)
end
function LANG.fetch()
	local need, seen = {}, {}
	local function add(s)
		if type(s) == "string" and s ~= "" and not seen[s] and not LANG.cache[s] then seen[s] = true need[#need + 1] = s end
	end
	for _, it in ipairs(LANG.items) do add(it.title) add(it.desc) end
	for _, tb in ipairs(LANG.tabs) do add(tb.title) end
	add("drixnvsp | OPPS")
	local i = 1
	while i <= #need do
		local chunk, n = {}, 0
		while i <= #need and n < 900 do chunk[#chunk + 1] = need[i] n = n + #need[i] + 6 i = i + 1 end
		local sep = "\n<|#|>\n"
		local q = table.concat(chunk, sep)
		local url = "https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=" .. Http:UrlEncode(LANG.code) .. "&dt=t&q=" .. Http:UrlEncode(q)
		local body = httpGet(url)
		local got
		if body then
			local ok, data = pcall(function() return Http:JSONDecode(body) end)
			if ok and type(data) == "table" and type(data[1]) == "table" then
				local parts = {}
				for _, seg in ipairs(data[1]) do if type(seg) == "table" and type(seg[1]) == "string" then parts[#parts + 1] = seg[1] end end
				got = table.concat(parts)
			end
		end
		local list = {}
		if got then
			list = {}
			for bit in (got .. "\n<|#|>"):gmatch("(.-)\n<|#|>") do list[#list + 1] = bit end
			if #list < #chunk then
				list = {}
				for bit in (got .. "<|#|>"):gmatch("(.-)<|#|>") do list[#list + 1] = (bit:gsub("^%s+", ""):gsub("%s+$", "")) end
			end
		end
		if #list ~= #chunk then
			for _, s in ipairs(chunk) do
				local one = httpGet("https://translate.googleapis.com/translate_a/single?client=gtx&sl=en&tl=" .. Http:UrlEncode(LANG.code) .. "&dt=t&q=" .. Http:UrlEncode(s))
				local word
				if one then
					local ok, data = pcall(function() return Http:JSONDecode(one) end)
					if ok and type(data) == "table" and type(data[1]) == "table" and type(data[1][1]) == "table" then word = data[1][1][1] end
				end
				if type(word) == "string" and word ~= "" then LANG.cache[s] = word end
			end
		else
			for k, s in ipairs(chunk) do LANG.cache[s] = list[k] end
		end
	end
	local miss = 0
	for s in pairs(seen) do if not LANG.cache[s] then miss = miss + 1 end end
	return miss == 0
end
function LANG.set(name)
	local code, label = LANG.codeOf(name)
	if not code then
		notify("Language", "Couldn't find that language. Search the list or type a name like Spanish.", "x")
		return false
	end
	LANG.code, LANG.name = code, label or name
	S.Lang = LANG.name
	save()
	if code == "en" then LANG.cache = {} LANG.paint() notify("Language", "English", "check") return true end
	LANG.loadCache()
	notify("Language", "Translating to " .. tostring(label or name) .. "...", "languages")
	local ok = LANG.fetch()
	LANG.saveCache()
	LANG.paint()
	if ok then notify("Language", "Changed to " .. tostring(label or name), "check")
	else notify("Language", "Some lines stayed in English. Try again.", "alert-triangle") end
	return true
end
do
	local rawTab = Window.Tab
	function Window:Tab(opts)
		local tab = rawTab(self, opts)
		if type(opts) == "table" and opts.Title then LANG.tabs[#LANG.tabs + 1] = { el = tab, title = opts.Title } end
		for _, name in ipairs({ "Button", "Toggle", "Dropdown", "Paragraph", "Slider", "Section", "Input" }) do
			local raw = tab[name]
			if type(raw) == "function" then
				tab[name] = function(self2, o, ...)
					local el = raw(self2, o, ...)
					if type(o) == "table" then LANG.track(el, o.Title, o.Desc) end
					return el
				end
			end
		end
		return tab
	end
end

-- -- LANGUAGE --
pcall(function()
	local names = {}
	for _, e in ipairs(LANG.LIST) do names[#names + 1] = e[1] end
	local T = Window:Tab({ Title = "Language", Icon = "languages" })
	T:Paragraph({ Title = "Language", Desc = "Stock is English. Search a language and the whole menu changes. The script still works the same." })
	T:Dropdown({ Title = "Language", Desc = "Search any language.", Values = names, Value = S.Lang ~= "" and S.Lang or "English", SearchBarEnabled = true,
		Callback = function(v) task.spawn(LANG.set, v) end })
	T:Input({ Title = "Or type a language", Desc = "Type a name or a code, like Kurdish or es.", Placeholder = "Spanish", Callback = function(v)
		if v and v ~= "" then task.spawn(LANG.set, v) end
	end })
end)

-- -- GENERAL --
SAFE("tab general", function()
	local T = Window:Tab({ Title = "General", Icon = "person-standing" })
	SEC(T, "Movement:")
	TG(T, "Speed Hack", "Moves you faster than your WalkSpeed (too high = the game pulls you back)", "SpeedHack")
	SL(T, "Speed Multiplier", "Max 2x", "SpeedMult", 1, 2, 0.05)
	TG(T, "Infinite Stamina", "Keeps your sprint + block stamina full", "InfStamina")
	TG(T, "Gold Stamina Circle", "Your stamina circle turns gold instead of blue", "GoldStamina")
	SEC(T, "Player Modifier:")
	UI.el.HideName = T:Toggle({ Title = "Hide Name", Desc = "Replace your nametag with ******.",
		Type = "Checkbox", Value = S.HideName, Default = S.HideName, Callback = function(v) HN.set(v) save() end })
	TG(T, "Anti Kill", "When you get downed you teleport underground so nobody can finish you. Teleports back up when you get up.", "AntiKill")
	TG(T, "Anti Ragdoll", "Cars, RPGs and hits can't knock you over or fling you.", "AntiRagdoll")
	T:Button({ Title = "Return to Surface", Desc = "Come back up right now", Callback = function() AK.return_() end })
	T:Button({ Title = "Reset Character", Desc = "Respawn your character", Callback = function() local hm = hum() if hm then hm.Health = 0 end end })
end)

-- -- COMBAT --
SAFE("tab combat", function()
	local T = Window:Tab({ Title = "Combat", Icon = "swords" })
	UI.aimP = T:Paragraph({ Title = "Aimbot", Desc = "Off" })
	SEC(T, "Aimbot:")
	TG(T, "Aimbot", "Locks your camera on the closest enemy's head while you aim.", "AimOn")
	UI.el.AimMode = T:Dropdown({ Title = "Lock When", Desc = "When to lock on.", Values = { "When Aiming", "Holding A Gun", "Lock Button" }, Value = S.AimMode,
		Callback = function(v) S.AimMode = tostring(v) save() end })
	UI.el.AimPart = T:Dropdown({ Title = "Aim Part", Desc = "Where it locks.", Values = { "Head", "Body" }, Value = S.AimPart, Callback = function(v) S.AimPart = tostring(v) save() end })
	TG(T, "Wall Check", "Won't lock onto players when a solid wall is between you and them.", "WallCheck", function(v) if v then AIM.target, AIM.part, AIM.cur = nil, nil, nil end end)
	TG(T, "Smart Hit", "Locks on the part your shot can reach: head, or chest / arm through a car window.", "SmartHit")
	SEC(T, "Fov:")
	SL(T, "FOV", "Aimbot FOV radius in pixels. 1000 = whole screen.", "AimFOV", 10, 1000, 10)
	SEC(T, "Hitbox:")
	SL(T, "Hitbox Size", "Studs. Bigger = easier hits (too big may not count).", "HitboxSize", 2, 25, 1)
	UI.el.HitboxPart = T:Dropdown({ Title = "Hitbox Part", Desc = "Head = headshots. Body = bigger torso box.", Values = { "Head", "Body" }, Value = S.HitboxPart,
		Callback = function(v) S.HitboxPart = tostring(v) save() HB.restoreAll() end })
	SEC(T, "Target:")
	TG(T, "Skip Safe Zone Players", "Aimbot ignores players in a safe zone.", "SkipSafe")
end)

-- -- WEAPON MOD --
SAFE("tab weapon mod", function()
	local T = Window:Tab({ Title = "Weapon Mod", Icon = "crosshair" })
	UI.gunP = T:Paragraph({ Title = "Gun", Desc = "Equip a gun" })
	SEC(T, "Gun:")
	TG(T, "Custom Fire Rate", "Uses the Fire Rate slider below.", "RPM", function() GM.apply() end)
	SL(T, "Fire Rate", "Weapon RPM (shots per minute).", "RPMValue", 100, 2000, 25, function() GM.apply() end)
	TG(T, "No Spread", "Every bullet goes exactly where you aim.", "NoSpread", function() GM.apply() end)
	TG(T, "No Recoil", "Your camera doesn't kick up when shooting.", "NoRecoil", function() GM.apply() end)
	TG(T, "Automatic", "Force weapon to fire fully automatic.", "FullAuto", function() GM.apply() end)
	TG(T, "Instant Reload", "Press Reload and your gun reloads right away.", "FastReload", function() GM.apply() end)
	T:Button({ Title = "Rescan My Gun", Desc = "Press if a new gun doesn't change.", Callback = function()
		GM.scanned = {} GM.scan("manual") notify("Gun Mods", "Scanning your gun...", "search")
	end })
end)

-- -- ESP --
SAFE("tab esp", function()
	local T = Window:Tab({ Title = "Esp", Icon = "scan-eye" })
	SEC(T, "Player:")
	TG(T, "Enable ESP", "Name - health bar - studs - guns.", "ESP")
	TG(T, "Username", "Name above the head.", "ShowName", ESP.bump)
	TG(T, "Status Tags", "[KO] [SAFE] [CAR] next to names.", "ESPStatus")
	TG(T, "Health Bar", "Bar with 100/100 under the feet.", "ShowHealth", ESP.bump)
	TG(T, "Studs + HP %", "[13M] [100%]", "ShowInfo", ESP.bump)
	SEC(T, "Guns:")
	TG(T, "Guns", "Gold: RPG, MP5, AK47, Remington - Red: M249, Spaz 12, AR15, Anaconda - every other gun = its game rarity color.", "ShowTools", ESP.bump)
	TG(T, "Backpack Guns", "Also list guns they aren't holding.", "ESPAllTools", function() for _, e in pairs(ESP.e) do e.wKey = nil e.nextTools = 0 end end)
	UI.espRar = T:Dropdown({ Title = "Hide Rarities", Desc = "Hides guns people are holding if they are these rarities. Nothing picked = every gun shows.",
		Values = DROP.rarList(), Value = S.ESPHideRar, Multi = true, AllowNone = true,
		Callback = function(v)
			local tt = {}
			if type(v) == "table" then for _, x in ipairs(v) do tt[#tt + 1] = tostring(x) end elseif v then tt[1] = tostring(v) end
			S.ESPHideRar = tt
			for _, e in pairs(ESP.e) do e.wKey = nil e.nextTools = 0 end
			save()
		end })
	TG(T, "Ground ESP", "Stuff on the ground: [RPG] {20} = item + studs away. Pick what shows below.", "DropESP")
	local function geDD(cat, title, desc, vals)
		SEC(T, title)
		UI.ge = UI.ge or {}
		UI.ge[cat] = T:Dropdown({ Title = cat, Desc = desc, Values = vals, Value = S.GE[cat], Multi = true, AllowNone = true,
			Callback = function(v)
				local t = {}
				if type(v) == "table" then for _, x in ipairs(v) do t[#t + 1] = tostring(x) end elseif v then t[1] = tostring(v) end
				S.GE[cat] = t DROP.rebuildSel() save()
			end })
	end
	if not next(DROP.names.Guns) then DROP.learn() end
	SEC(T, "Ground Guns:")
	UI.geRar = T:Dropdown({ Title = "Hide Rarities", Desc = "Guns on the ground with these rarities are hidden. Nothing picked = every gun shows.",
		Values = DROP.rarList(), Value = S.GEHideRar, Multi = true, AllowNone = true,
		Callback = function(v)
			local t = {}
			if type(v) == "table" then for _, x in ipairs(v) do t[#t + 1] = tostring(x) end elseif v then t[1] = tostring(v) end
			S.GEHideRar = t DROP.rebuildHide() save()
		end })
	geDD("Ammo", "Ground Ammo:", "Explosive / Rifle / Pistol / Shotgun ammo ...", DROP.list("Ammo"))
	geDD("Misc", "Ground Misc:", "Trinkets, fishing rods, drinks ... everything else (never cash).", DROP.list("Misc"))
	T:Button({ Title = "Refresh Lists", Desc = "Adds new items the game has (or that you've seen on the ground) to the lists.", Callback = function()
		DROP.learn()
		pcall(function() UI.geRar:Refresh(DROP.rarList()) end)
		pcall(function() UI.geRar:Select(S.GEHideRar) end)
		pcall(function() UI.espRar:Refresh(DROP.rarList()) end)
		pcall(function() UI.espRar:Select(S.ESPHideRar) end)
		for _, cat in ipairs({ "Ammo", "Misc" }) do
			pcall(function() UI.ge[cat]:Refresh(DROP.list(cat)) end)
			pcall(function() UI.ge[cat]:Select(S.GE[cat]) end)
		end
		DROP.dirty = false
		notify("ESP", "Lists updated", "check")
	end })
	SEC(T, "Settings:")
	SL(T, "ESP Size", "Make the ESP text bigger or smaller.", "ESPScale", 0.6, 2, 0.05, function() for _, e in pairs(ESP.e) do e.sc = -1 e.nextSlow = 0 end end)
	SL(T, "ESP Range", "Max studs for players. 10000 = unlimited.", "ESPRange", 100, 10000, 100)
	SL(T, "Ground ESP Range", "Max studs for ground items.", "DropRange", 50, 5000, 50)
	SEC(T, "Extra:")
	TG(T, "Chams", "Red outline through walls - team = green.", "Chams")
	T:Button({ Title = "Rebuild ESP", Desc = "Fixes ESP if something looks stuck.", Callback = function()
		for _, p in ipairs(Players:GetPlayers()) do if p ~= L then ESP.build(p) end end
		notify("ESP", "Rebuilt", "check")
	end })
end)

-- -- VISUALIZE --
SAFE("tab visualize", function()
	local T = Window:Tab({ Title = "Visualize", Icon = "eye" })
	SEC(T, "Target:")
	TG(T, "Target Highlight", "The enemy closest to your crosshair turns red.", "TargetHL")
	TG(T, "Target Line", "Skinny red line from the middle of your screen to the target.", "TargetLine")
	TG(T, "FOV Circle", "Show the aimbot FOV circle.", "FOVCircle")
	SEC(T, "Tracers:")
	TG(T, "Bullet Tracers", "Line from your gun to where every shot goes (only you see it).", "Tracers")
	UI.el.TracerColor = T:Dropdown({ Title = "Tracer Color", Desc = "Color of the tracers.", Values = { "Red", "White", "Gold", "Blue", "Green", "Purple" }, Value = S.TracerColor, Callback = function(v) S.TracerColor = tostring(v) save() end })
end)

-- -- TEAM --
SAFE("tab team", function()
	local T = Window:Tab({ Title = "Team", Icon = "users" })
	SEC(T, "Team List:")
	T:Paragraph({ Title = "How it works", Desc = "Tap a player to add them. Team = GREEN name + studs, and the aimbot never locks on them." })
	local btns, busy = {}, false
	local function build()
		if busy then return end
		busy = true
		for _, b in ipairs(btns) do pcall(function() b:Destroy() end) end
		btns = {}
		local list = Players:GetPlayers()
		table.sort(list, function(a, b) return a.Name:lower() < b.Name:lower() end)
		for _, p in ipairs(list) do
			if p ~= L then
				local on = S.Friends[p.Name] == true
				local ok, b = pcall(function()
					return T:Button({ Title = (on and "[ON] " or "[  ] ") .. p.Name, Desc = on and "On team - green ESP, can't be aimbotted" or "Tap to add to team",
						Icon = on and "user-check" or "user-plus",
						Callback = function()
							local now = not (S.Friends[p.Name] == true)
							S.Friends[p.Name] = now or nil
							if now and AIM.target == p then AIM.target = nil end
							save()
							notify(p.Name, now and "Added to team" or "Removed from team", now and "user-check" or "user-x")
							task.defer(build)
						end })
				end)
				if ok and b then btns[#btns + 1] = b end
			end
		end
		busy = false
	end
	UI.buildTeam = build
	T:Button({ Title = "Clear Team List", Desc = "Removes everyone from your team.", Callback = function() S.Friends = {} save() notify("Team", "Team list cleared", "check") task.defer(build) end })
	SEC(T, "Players In Server:")
	build()
	local q = false
	local function queue() if q then return end q = true task.delay(2, function() q = false build() end) end
	C(Players.PlayerAdded, queue)
	C(Players.PlayerRemoving, queue)
end)

-- -- VEHICLE --
SAFE("tab vehicle", function()
	local T = Window:Tab({ Title = "Vehicle", Icon = "car" })
	SEC(T, "Handling:")
	TG(T, "Drive Stable", "Glides on the road: no acceleration, instant turns, never tips, stops at walls.", "StableCar")
	SL(T, "Stable Speed (x)", "Times the car's normal top speed. 1 = normal.", "StableSpd", 0.5, 2, 0.05)
	TG(T, "Keep FOV Normal", "Your view doesn't stretch out when driving fast.", "CarFov")
	CAR.onStable = function() pcall(function() UI.el.StableCar:Set(true) end) end
	SEC(T, "Car Config:")
	TG(T, "Car Config", "Faster car: uses Top Speed below (re-enter the car if it doesn't change).", "CarCfg")
	SL(T, "Top Speed (x)", "Times the car's normal top speed.", "CarTopX", 1, 2, 0.1)
end)

-- -- SHOP --
SAFE("tab shop", function()
	local T = Window:Tab({ Title = "Shop", Icon = "shopping-bag" })
	UI.shopP = T:Paragraph({ Title = "Status", Desc = "" })
	T:Paragraph({ Title = "How it works", Desc = "Pistol, Rifle, Shotgun and Explosive are always in the list. Open any ammo crate once, then Buy Crate works from anywhere. No crate animation. The only popup is the Roblox one, and it only says the ammo you got." })
	SEC(T, "Ammo:")
	UI.ddAmmoC = T:Dropdown({ Title = "Ammo", Desc = "Pick your ammo.", Values = SB.crList(true), Value = S.AmmoPick ~= "" and S.AmmoPick or nil, AllowNone = true,
		Callback = function(v) S.AmmoPick = tostring(v or "") save() end })
	T:Button({ Title = "Buy Crate", Desc = "Spam it: every press buys one.", Callback = function() SB.crBuy(S.AmmoPick ~= "" and S.AmmoPick or nil) end })
	SEC(T, "Other Crates:")
	UI.ddCrateC = T:Dropdown({ Title = "Crate", Desc = "Gun crates and others.", Values = SB.crList(false), Value = S.CratePick ~= "" and S.CratePick or nil, AllowNone = true,
		Callback = function(v) S.CratePick = tostring(v or "") save() end })
	T:Button({ Title = "Buy Crate", Desc = "Spam it: every press buys one.", Callback = function() SB.crBuy(S.CratePick ~= "" and S.CratePick or nil) end })
	SB.cr.onLearn = function()
		pcall(function() UI.ddAmmoC:Refresh(SB.crList(true)) end)
		pcall(function() UI.ddCrateC:Refresh(SB.crList(false)) end)
	end
end)

-- -- COSMETIC --
SAFE("tab cosmetic", function()
	local T = Window:Tab({ Title = "Cosmetic", Icon = "sparkles" })
	SEC(T, "Outfit:")
	T:Button({ Title = "Random Outfit", Desc = "Copies a random player's fit (only you see it).", Callback = function()
		local ok, who = OUT.random()
		notify("Outfit", ok and ("Copied " .. who) or tostring(who), ok and "shirt" or "x")
	end })
	TG(T, "Random Outfit On Execute", "New random fit every time you run the script.", "RandomFit")
end)

-- -- MISC --
SAFE("tab misc", function()
	local T = Window:Tab({ Title = "Misc", Icon = "circle-ellipsis" })
	SEC(T, "Performance:")
	TG(T, "Auto Performance", "Under 40 FPS it turns on Performance Mode + Hide Bullets.", "AutoPerf")
	TG(T, "Performance Mode", "Lighter: no shadows / particles, low quality.", "Boost", function(v) Perf.boost(v) end)
	TG(T, "Hide Bullets", "Bullets + effects aren't drawn. Shooting works the same.", "HideBullets")
	SEC(T, "Config:")
	T:Button({ Title = "Save Config", Desc = "Saves all settings + your team list (auto-loads).", Callback = function()
		save() notify("Config", writefile and "Saved! It will auto-load next time too." or "Your executor can't save files", writefile and "check" or "x")
	end })
	T:Button({ Title = "Load Config", Desc = "Loads your last saved settings.", Callback = function()
		local ok = pcall(function()
			for k, v in pairs(Http:JSONDecode(readfile(FILE))) do if S[k] ~= nil and type(S[k]) == type(v) then S[k] = v end end
		end)
		if ok then
			LOCK()
			for k, el in pairs(UI.el) do pcall(function() if el.Select then el:Select(S[k]) else el:Set(S[k]) end end) end
			pcall(UI.buildTeam) GM.apply() ESP.bump()
			notify("Config", "Settings loaded!", "check")
		else notify("Config", "No saved config found", "x") end
	end })
	SEC(T, "Server:")
	T:Button({ Title = "Rejoin Server", Desc = "Rejoins this game.", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId, L) end })
	SEC(T, "Socials:")
	T:Button({ Title = "TikTok", Desc = "Copy the owner's TikTok link (@drixnvsp).", Callback = function()
		pcall(function() (setclipboard or toclipboard)("https://www.tiktok.com/@drixnvsp?_r=1&_t=ZP-9A7wASfIJeZ") end) notify("TikTok", "Link copied", "check")
	end })
	T:Button({ Title = "Discord", Desc = "Copy the Discord invite link.", Callback = function()
		pcall(function() (setclipboard or toclipboard)("https://discord.gg/8At9MJkUt") end) notify("Discord", "Invite copied", "check")
	end })
end)

pcall(function() Window:SelectTab(1) end)
task.defer(function()
	if S.Lang and S.Lang ~= "English" and LANG and LANG.set then LANG.set(S.Lang) end
end)

end -- end of "menu loaded" branch (everything above only runs with a menu)

-- live status
task.spawn(function()
	while ALIVE do
		pcall(function()
			local gun = GM.held()
			local a = not S.AimOn and "Off" or string.format("%s  -  gun: %s  -  aiming: %s\nTarget: %s",
				S.AimMode, gun and gun.Name or "none", AIM.aiming() and "YES" or "no", AIM.target and AIM.target.Name or "none")
			local g = string.format("Holding: %s  -  gun settings found: %d  -  changed: %d%s", gun and gun.Name or "no gun",
				#GM.tables, #GM.patched, GM.scanning and "  -  scanning..." or "")
			local s = SB.status2()
			if a ~= UI._aimD then UI._aimD = a UI.aimP:SetDesc(a) end
			if g ~= UI._gunD then UI._gunD = g UI.gunP:SetDesc(g) end
			if s ~= UI._shopD then UI._shopD = s UI.shopP:SetDesc(s) end
		end)
		task.wait(1)
	end
end)

env.DRIX_OPPSC_STOP = function()
	ALIVE = false
	G.TOK += 1
	pcall(function() Run:UnbindFromRenderStep("drixAimLock") end)
	pcall(function() Run:UnbindFromRenderStep("drixAimPre") end)
	pcall(function() Run:UnbindFromRenderStep("drixCarFov") end)
	pcall(release)
	pcall(GM.restore)
	pcall(function() for t, f in pairs(GM.rc) do rawset(t, "RecoilCam", f) end end)
	pcall(CAR.restore)
	pcall(HB.restoreAll)
	DBG.stopRec()
	if S.HideName then pcall(HN.set, false) end
	for _, c in ipairs(CONNS) do pcall(function() c:Disconnect() end) end
	for _, e in pairs(ESP.e) do pcall(ESP.killHL, e) end
	pcall(function() MV.setCfg(false) end)
	pcall(function() HUD:Destroy() ESPG:Destroy() CAR.box:Destroy() end)
	pcall(function() CAR.putBack() CAR.plat:Destroy() end)
	pcall(function() G.AR.on = false G.TOK += 1 release() end)
	pcall(function() UI.openSG:Destroy() end)
	pcall(function() Window:Destroy() end)
end

notify("Updated Script:", "drixnvsp OPPS", "check")

end, __trace)

if not __MAIN_OK then
	local msg = tostring(__MAIN_ERR)
	warn("[drixnvsp] stopped: " .. msg)
	pcall(function() if appendfile then appendfile("drixnvsp_error.txt", msg .. "\n\n") end end)
	pcall(function()
		game:GetService("StarterGui"):SetCore("SendNotification", {
			Title = "drixnvsp hit an error", Text = tostring(msg):sub(1, 170), Duration = 20 })
	end)
end
