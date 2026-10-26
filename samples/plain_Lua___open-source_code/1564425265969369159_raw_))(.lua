-- Nexvory Hub | COMPLETO FINAL (sem freeze + auto noite/respawn)
if not game then return end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local CFG = {
	SpeedCap = 1.15, HopRatio = 1.515, HopMin = 40,
	HopGap = 0.06, HopGapMin = 0.06, HopGapMax = 0.2, HopRetries = 30,
	HopLift = 3, LandOffset = 14, LandSettle = 0.08, DropDelay = 0.05,
	GrabInterval = 0.03, RegrabFar = 40, Height = 0,
	ClimbShare = 0.5, CarryRatio = 0.9, EasyRatio = 1.3,
	GrabTimeout = 15, GrabConfirm = 0.6, GrabTeleportFar = 15,
	SpawnDetectRadius = 8, SpawnCacheTime = 2,
	PetOutConfirm = 1.2, MaxAttempts = 50,
	GrabStopDistance = 3,
	PromptRadius = 20,
	GrabSideOffset = 10,
	RetryDelay = 0.35,
	StopBeforeEgg = 20,
	SlideSpeed = 10,
	SlideTimeout = 6,
}
local FPS = { 60, 30, 0.15 }

local ordemMelhores = true
local petSendoRoubadoUID = nil
local autoStealAtivo = false
local autoStealFocusUid = nil
local listaAtualPets = {}
local lastPetCount = 0
local wasNight = false

local stealManual
local updateBtns
local startAutoSteal
local stopAutoSteal
local tryStealOnce
local instantTP
local vooFallback
local unfreezeCharacter

local function safeRequire(fn) local ok, r = pcall(fn); return ok and r or nil end

local Packages = ReplicatedStorage:FindFirstChild("Packages")
local networkingFolder = Packages and Packages:FindFirstChild("Networking")
local EggState = safeRequire(function() return require(ReplicatedStorage.Client.EggState) end)
local AssetsData = safeRequire(function() return require(ReplicatedStorage.Data.Assets) end)
local Mutations = safeRequire(function() return require(ReplicatedStorage.Shared.Modules.Mutations) end)

local function remote(name) return networkingFolder and networkingFolder:FindFirstChild(name) or nil end
local function root() local c = player.Character; return c and c:FindFirstChild("HumanoidRootPart") end

-- SPAWN
local _spawnCache, _spawnCacheAt = nil, 0
local function getSpawn()
	if _spawnCache and _spawnCache.Parent and (os.clock() - _spawnCacheAt) < CFG.SpawnCacheTime then return _spawnCache end
	local ok, r = pcall(function() return workspace:FindFirstChildWhichIsA("SpawnLocation", true) end)
	if ok and r then _spawnCache, _spawnCacheAt = r, os.clock(); return r end
	return _spawnCache
end
local function atSpawn()
	local r = root(); local s = getSpawn()
	if not r or not s then return false end
	return (r.Position - s.Position).Magnitude <= CFG.SpawnDetectRadius
end
local function spawnPos() local s = getSpawn(); return s and s.Position or nil end

-- RARITY
local RARITY_SCORE_MAP = {
    ["Light & Dark"]=1300,["Titan"]=1200,["Divine"]=1100,["Transcendent"]=1050,["Superior"]=1000,
    ["Eternal"]=900,["Limited"]=900,["Secret"]=800,["Exotic"]=800,["Cosmic"]=700,["Exclusive"]=700,
    ["Admin"]=700,["Mythic"]=600,["Mythical"]=600,["Prismatic"]=600,["Rainbow"]=600,["Squishy God"]=600,
    ["BrainrotGod"]=600,["Legendary"]=500,["Epic"]=400,["Rare"]=300,["SuperRare"]=200,["Celestial"]=200,
    ["Uncommon"]=200,["Basic"]=100,["Common"]=50,
}
local function GetRarity(egg)
    if not egg then return "Common", 50 end
    if egg.Rarity then
        local r = egg.Rarity
        local name = type(r) == "table" and (r.DisplayName or r._id or r.Name) or tostring(r)
        return name, RARITY_SCORE_MAP[name] or 50
    end
    local cat = egg.AssetCategory or egg.Category or egg.Name
    if cat and AssetsData then
        local aInfo = (AssetsData.Directory or AssetsData)[cat]
        if aInfo and aInfo.Rarity then
            local r = aInfo.Rarity
            local name = type(r) == "table" and (r.DisplayName or r._id or r.Name) or tostring(r)
            return name, RARITY_SCORE_MAP[name] or 50
        end
    end
    return "Common", 50
end

-- SHIELD
local shield = { Original = nil, Clone = nil, Links = {}, Connection = nil, Added = nil }
local function walkSpeed()
	local c = player.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	local speed = h and h.WalkSpeed or 16
	if shield.Original and shield.Original.Health > 0 then speed = math.min(speed, shield.Original.WalkSpeed) end
	local ok, r = pcall(function()
		local stat = player:FindFirstChild("leaderstats"); stat = stat and stat:FindFirstChild("Speed")
		local util = require(ReplicatedStorage.Shared.Util.TreadmillUtil)
		return stat and util.SpeedPowerToWalkSpeed(stat.Value) or nil
	end)
	if ok and type(r) == "number" and r > 0 then speed = math.min(speed, r) end
	return speed
end
local function shieldControls(h)
	pcall(function()
		local ps = player:FindFirstChild("PlayerScripts")
		local pm = ps and ps:FindFirstChild("PlayerModule")
		if pm then local ctrl = require(pm):GetControls(); if type(ctrl) == "table" then ctrl.humanoid = h end end
	end)
end
local function shieldAnimate(c)
	local a = c and c:FindFirstChild("Animate")
	if a and a:IsA("LocalScript") then task.spawn(function() a.Enabled = false; task.wait(); a.Enabled = true end) end
end
local function shieldUnlink() for _, l in ipairs(shield.Links) do pcall(function() l:Disconnect() end) end; table.clear(shield.Links) end
local groundedStates = {[Enum.HumanoidStateType.Running]=true,[Enum.HumanoidStateType.RunningNoPhysics]=true,[Enum.HumanoidStateType.Landed]=true}
local function grounded(h) if not h or h.Health <= 0 or h.FloorMaterial == Enum.Material.Air then return false end; return groundedStates[h:GetState()] == true end
local function shieldSwap()
	local c = player.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
	if not h or h.Health <= 0 then return end
	if shield.Clone and shield.Clone.Parent == c then return end
	if not grounded(h) then return end
	local clone = h:Clone(); h.Parent = nil; clone.Parent = c
	workspace.CurrentCamera.CameraSubject = clone
	shieldControls(clone); shieldAnimate(c)
	shield.Original, shield.Clone = h, clone
	table.insert(shield.Links, h:GetPropertyChangedSignal("WalkSpeed"):Connect(function() if clone.Parent then clone.WalkSpeed = h.WalkSpeed end end))
	local an1, an2 = h:FindFirstChildOfClass("Animator"), clone:FindFirstChildOfClass("Animator")
	if an1 and an2 then
		table.insert(shield.Links, an1.AnimationPlayed:Connect(function(played)
			local anim = played.Animation; if not anim or not clone.Parent then return end
			local ok, track = pcall(function() return an2:LoadAnimation(anim) end)
			if not ok or not track then return end
			pcall(function() track.Priority = played.Priority; track.Looped = played.Looped; track:Play(0.05, math.max(played.WeightTarget, 0.01), played.Speed) end)
			local stopped; stopped = played.Stopped:Connect(function() stopped:Disconnect(); pcall(function() track:Stop(0.1) end) end)
		end))
	end
	table.insert(shield.Links, clone.Died:Connect(function()
		shieldUnlink(); shield.Original, shield.Clone = nil, nil
		local cur = player.Character; if cur and not h.Parent then h.Parent = cur; workspace.CurrentCamera.CameraSubject = h; shieldControls(h) end
		pcall(function() clone:Destroy() end); h.Health = 0
	end))
end
local function shieldStart()
	shieldSwap()
	local n = 0
	shield.Connection = RunService.Heartbeat:Connect(function(dt)
		n += dt
		local c = player.Character
		local missing = not (shield.Clone and c and shield.Clone.Parent == c)
		if (missing and 0.25 or 3) <= n then n = 0; shieldSwap() end
	end)
	shield.Added = player.CharacterAdded:Connect(function(c)
		shieldUnlink(); shield.Original, shield.Clone = nil, nil
		state.Cancel = true
		state._tpTriggered = false
		state._tpActive = false
		state.Busy = false
		petSendoRoubadoUID = nil
		task.spawn(function() c:WaitForChild("Humanoid", 10); task.wait(0.8); if shield.Connection and player.Character == c then shieldSwap() end end)
	end)
end

-- STATE
local state = { Carrying=false, Uid=nil, Delivered=0, Busy=false, Cancel=false, Mult=1, PulledAt=0, HeldSeen=0, GuessedDrop=false, ReleaseCamera=nil, _tpTriggered=false, _tpActive=false }

if type(EggState) == "table" and type(EggState.CarryChanged) == "table" and type(EggState.CarryChanged.Connect) == "function" then
	EggState.CarryChanged:Connect(function(arg)
		local carrying = type(arg) == "table" and arg.IsCarrying == true
		if carrying and arg.GuardDisabled == true then carrying = false end
		state.GuessedDrop = false
		if carrying then
			state.HeldSeen = os.clock()
			if type(arg.Uid) == "string" then
				state.Uid = arg.Uid
				local mult = tonumber(arg.SpeedMultiplier)
				if mult and mult > 0 then state.Mult = mult end
			end
		else
			state.Uid = nil
		end
		state.Carrying = carrying
	end)
end
pcall(function() local r = remote("RE/EggWorld/FieldEggRedeemVerdict"); if r then r.OnClientEvent:Connect(function() state.Delivered = os.clock() end) end end)
pcall(function() local r = remote("RE/RigSync/Refresh"); if r then r.OnClientEvent:Connect(function(arg) if type(arg) == "table" and arg.Action == "Relocate" then state.PulledAt = os.clock() end end) end end)

local function takeEgg(uid) if type(uid)=="string" and type(EggState)=="table" and type(EggState.CarryFieldEgg)=="function" then pcall(EggState.CarryFieldEgg, uid) end end
local function dropEgg() if type(EggState)=="table" and type(EggState.DropFieldEgg)=="function" then pcall(EggState.DropFieldEgg, "PlayerRequest") end end

local function promptNear(pos, radius)
	local best, bd = nil, radius
	for _, ch in ipairs(workspace:GetChildren()) do
		if ch.Name == "SmartPromptPart" and ch:IsA("BasePart") then
			local p = ch:FindFirstChild("CarryAreaEgg")
			if p and p:IsA("ProximityPrompt") then
				local d = (ch.Position - pos).Magnitude
				if d < bd then best, bd = p, d end
			end
		end
	end
	return best
end
local function heldByMe(uid)
	local c = player.Character; if type(uid) ~= "string" or not c then return false end
	local egg = workspace:FindFirstChild(uid); if not egg then return false end
	for _, d in ipairs(egg:GetDescendants()) do
		if d:IsA("WeldConstraint") or d:IsA("JointInstance") then
			local ok, a, b = pcall(function() return d.Part0, d.Part1 end)
			if ok and ((a and a:IsDescendantOf(c)) or (b and b:IsDescendantOf(c))) then return true end
		end
	end
	return false
end

local function isRagdoll()
	local c = player.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if not h then return true end
	local st = h:GetState()
	if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
		return true
	end
	if h.PlatformStand then return true end
	return false
end

task.spawn(function()
	while true do
		task.wait(0.2)
		if not state.Carrying then
			if state.GuessedDrop and state.Uid and heldByMe(state.Uid) then state.GuessedDrop, state.Carrying, state.HeldSeen = false, true, os.clock() end
		elseif state.Uid and heldByMe(state.Uid) then state.HeldSeen = os.clock()
		elseif os.clock() - state.HeldSeen > 0.8 then state.Carrying, state.GuessedDrop = false, true end
	end
end)

local function snapshot()
	local list = {}
	local r = remote("RF/EggWorld/AskFieldEggSnapshot"); if not r then return list end
	local ok, result = pcall(function() return r:InvokeServer() end)
	local records = ok and type(result)=="table" and result.Records or nil
	if type(records) ~= "table" then return list end
	for _, rec in pairs(records) do
		if type(rec)=="table" and type(rec.Uid)=="string" and (rec.State=="Slot" or rec.State=="Dropped") and typeof(rec.BottomCFrame)=="CFrame" then list[#list+1] = rec end
	end
	return list
end
local function eggPos(uid) for _, r in ipairs(snapshot()) do if r.Uid == uid then return r.BottomCFrame.Position end end; return nil end
local function eggNow(uid, cache)
	local node = workspace:FindFirstChild(uid) or (workspace:FindFirstChild("AreaEggSlotsClient") and workspace.AreaEggSlotsClient:FindFirstChild(uid))
	if node then local ok, p = pcall(function() return node:GetPivot().Position end); if ok and p then cache.Pos, cache.At = p, os.clock(); return p end end
	if os.clock() - cache.At >= 0.5 then cache.At = os.clock(); cache.Pos = eggPos(uid) or cache.Pos end
	return cache.Pos
end

local function describe(rec)
	local dir = type(AssetsData) == "table" and AssetsData.Directory or nil
	local entry = type(dir) == "table" and dir[tostring(rec.AssetCategory)] or nil
	local info = { Uid=rec.Uid, Name=tostring(rec.AssetCategory), Icon="", Rarity=0, Value=0 }
	if type(entry) == "table" then
		info.Name = tostring(entry.DisplayName or rec.AssetCategory)
		local icon = entry.Icon
		if icon ~= nil and tostring(icon) ~= "" then icon = tostring(icon); info.Icon = tonumber(icon) and ("rbxassetid://"..icon) or icon end
		if type(entry.Rarity) == "table" then info.Rarity = tonumber(entry.Rarity.RarityNumber or entry.Rarity.Rank) or 0 end
		local scale = tonumber(rec.AssetScale) or 1
		local factor = scale > 5 and (scale/5)^1.2 * 19.637875755794113 or scale^1.85
		local mut = 1
		if type(Mutations)=="table" and type(Mutations.EarningsFor)=="function" then
			local okM, rM = pcall(Mutations.EarningsFor, type(rec.Mutations)=="table" and rec.Mutations or {})
			if okM and type(rM)=="number" then mut = rM end
		end
		info.Value = (tonumber(entry.EarningRate) or 0) * factor * mut
	end
	return info
end
local function GetPetIcon(rec) if not rec then return nil end; local i = describe(rec); return i.Icon ~= "" and i.Icon or nil end
local function GetPetName(rec) if not rec then return "?" end; return describe(rec).Name end

-- TP HELPERS
local function frozenCamera()
	local cam = workspace.CurrentCamera; if not cam then return function() end end
	local oldType, frame = cam.CameraType, cam.CFrame
	pcall(function() cam.CameraType = Enum.CameraType.Scriptable; cam.CFrame = frame end)
	return function() pcall(function() cam.CameraType = oldType end) end
end
local fpsGen = 0
local function fpsOn()
	if typeof(setfpscap) ~= "function" then return end
	fpsGen += 1; local mine = fpsGen
	task.spawn(function() local high, started = true, os.clock()
		while fpsGen == mine and os.clock() - started < 60 do pcall(setfpscap, high and FPS[1] or FPS[2]); high = not high; task.wait(FPS[3]) end
	end)
end
local function fpsOff() fpsGen += 1; if typeof(setfpscap) == "function" then pcall(setfpscap, 240) end end

local stealClone = nil
local function dropClone() local c = stealClone; stealClone = nil; if c then pcall(function() c:Destroy() end) end end
local function postClone()
	dropClone()
	local c = player.Character; if not c then return end
	local was = c.Archivable; c.Archivable = true
	local copy = c:Clone(); c.Archivable = was
	if copy then
		for _, d in ipairs(copy:GetDescendants()) do
			if d:IsA("LuaSourceContainer") or d:IsA("Humanoid") then pcall(function() d:Destroy() end)
			elseif d:IsA("BasePart") then d.Anchored = true; d.CanCollide = false; d.CanTouch = false; d.CanQuery = false end
		end
		copy.Name = "Clone"; copy.Parent = workspace; stealClone = copy
	end
end

local function lineInfo()
	local w = workspace:FindFirstChild("World") or workspace:FindFirstChild("__OBJECTS")
	w = w and w:FindFirstChild("Areas"); w = w and w:FindFirstChild("SeparationLine")
	local ok = w and w:IsA("BasePart")
	return ok and w.Position.X or 552.2, ok and w.Position.Y or 67.67
end
local function homePoint()
	local s = spawnPos(); if s then return s end
	return Vector3.new(528.7, 70.57, -364.11)
end

local function place(pos)
	local r = root()
	if not r then return end
	pcall(function()
		r.CFrame = CFrame.new(pos) * CFrame.Angles(0, math.rad(90), 0)
		r.AssemblyLinearVelocity = Vector3.zero
		r.AssemblyAngularVelocity = Vector3.zero
	end)
end

-- DESCONGELA FORTE (corrige câmera travada)
unfreezeCharacter = function()
	local c = player.Character
	if not c then return end
	local h = c:FindFirstChildOfClass("Humanoid")
	local r = c:FindFirstChild("HumanoidRootPart")

	-- libera ReleaseCamera
	if state.ReleaseCamera then
		pcall(state.ReleaseCamera)
		state.ReleaseCamera = nil
	end

	-- força câmera várias vezes
	for i = 1, 8 do
		pcall(function()
			local cam = workspace.CurrentCamera
			if cam then
				cam.CameraType = Enum.CameraType.Custom
				if h then
					cam.CameraSubject = h
				end
			end
		end)
		RunService.Heartbeat:Wait()
	end

	-- libera humanoid
	if h then
		pcall(function()
			h.PlatformStand = false
			h.AutoRotate = true
			h:ChangeState(Enum.HumanoidStateType.GettingUp)
			task.wait()
			h:ChangeState(Enum.HumanoidStateType.Running)
			h:Move(Vector3.zero, false)
		end)
	end

	-- limpa velocidade
	if r then
		pcall(function()
			r.AssemblyLinearVelocity = Vector3.zero
			r.AssemblyAngularVelocity = Vector3.zero
		end)
	end

	dropClone()
	fpsOff()

	-- garante de novo depois de um tempinho
	task.delay(0.3, function()
		pcall(function()
			local cam = workspace.CurrentCamera
			local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
			if cam and hum then
				cam.CameraType = Enum.CameraType.Custom
				cam.CameraSubject = hum
			end
		end)
	end)
end

local dangerCache, dangerAt = {}, 0
local function dangers()
	if os.clock() - dangerAt < 1 then return dangerCache end
	dangerAt = os.clock(); local list = {}
	local function add(inst)
		local ok, cf, size = pcall(function()
			if inst:IsA("Model") then return inst:GetBoundingBox()
			elseif inst:IsA("BasePart") then return inst.CFrame, inst.Size end
		end)
		if ok and cf and size then
			local half = Vector3.new(math.abs(size.X), 0, math.abs(size.Z)) * 0.5
			local rot = (cf - cf.Position):VectorToWorldSpace(half)
			list[#list+1] = { MinX=cf.Position.X-math.max(math.abs(rot.X), half.X, half.Z), MaxX=cf.Position.X+math.max(math.abs(rot.X), half.X, half.Z), MinZ=cf.Position.Z-math.max(math.abs(rot.Z), half.X, half.Z), MaxZ=cf.Position.Z+math.max(math.abs(rot.Z), half.X, half.Z) }
		end
	end
	local function bad(n)
		if n == "ScrambleLocalVisuals" or n == "DrScrambleEvent" then return false end
		n = string.lower(n)
		return string.find(n,"portal",1,true) or string.find(n,"teleport",1,true) or string.find(n,"arena",1,true)
	end
	for _, ch in ipairs(workspace:GetChildren()) do
		if (ch:IsA("Model") or ch:IsA("BasePart") or ch:IsA("Folder")) and bad(ch.Name) then
			if ch:IsA("Folder") then for _, i in ipairs(ch:GetChildren()) do add(i) end else add(ch) end
		end
	end
	dangerCache = list; return list
end
local function avoid(from, to)
	for _, d in ipairs(dangers()) do
		local x0, x1, z0, z1 = d.MinX-12, d.MaxX+12, d.MinZ-12, d.MaxZ+12
		local inside = from.X >= x0 and from.X <= x1 and from.Z >= z0 and from.Z <= z1
		if not inside then
			local t0, t1, hit = 0, 1, true
			for _, ax in ipairs({{from.X, to.X-from.X, x0, x1}, {from.Z, to.Z-from.Z, z0, z1}}) do
				local pos, delta, lo, hi = ax[1], ax[2], ax[3], ax[4]
				if math.abs(delta) < 1e-6 then if pos < lo or pos > hi then hit = false end
				else local ta, tb = (lo-pos)/delta, (hi-pos)/delta; if ta > tb then ta, tb = tb, ta end; t0, t1 = math.max(t0, ta), math.min(t1, tb); if t0 > t1 then hit = false end end
			end
			if hit then
				local zL, zH = z0-2, z1+2
				local z = math.abs(from.Z-zL) <= math.abs(from.Z-zH) and zL or zH
				local x = math.abs(from.X-x0) <= math.abs(from.X-x1) and x0 or x1
				return Vector3.new(x, to.Y, z)
			end
		end
	end
	return to
end

local function runToEgg(uid, egg)
	local lineX = lineInfo()
	local home = homePoint()
	local c = player.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
	local r = root(); if not r then return false end
	local stage = (r.Position.X < lineX - 2 and Vector3.new(r.Position.X-home.X,0,r.Position.Z-home.Z).Magnitude > 20) and "safe" or "field"
	local started, lastCheck, lastPos, lastTake = os.clock(), os.clock(), r.Position, 0
	local cache = { At = 0 }

	while os.clock() - started < 120 and not state.Cancel do
		if state.Carrying and state.Uid == uid then return true end
		r = root(); if not r then return false end
		local live = eggNow(uid, cache); if live then egg = live end
		local flat = Vector3.new(egg.X-r.Position.X, 0, egg.Z-r.Position.Z)

		if stage == "field" and flat.Magnitude <= CFG.StopBeforeEgg then
			r = root()
			if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
			if h then pcall(function() h:Move(Vector3.zero, false) end) end
			return "slide"
		end

		local target = egg
		if stage == "safe" then
			if Vector3.new(home.X-r.Position.X,0,home.Z-r.Position.Z).Magnitude <= 6 then stage = "field" else target = home end
		end
		local wp = avoid(r.Position, target)
		local f = Vector3.new(wp.X-r.Position.X, 0, wp.Z-r.Position.Z)
		local unit = f.Magnitude > 0.01 and f.Unit or Vector3.zero
		local speed = math.max(walkSpeed() * CFG.SpeedCap, 8)
		local v = unit * math.min(speed, f.Magnitude / 0.05)
		pcall(function() r.AssemblyLinearVelocity = Vector3.new(v.X, r.AssemblyLinearVelocity.Y, v.Z); if h and unit.Magnitude > 0 then h:Move(unit, false) end end)
		if os.clock() - lastCheck >= 1.5 then
			if (r.Position - lastPos).Magnitude < 3 and h and flat.Magnitude > 15 then pcall(function() h.Jump = true end) end
			lastPos, lastCheck = r.Position, os.clock()
		end
		if stage == "field" and flat.Magnitude <= 9 and os.clock() - lastTake > 0.1 then
			lastTake = os.clock(); takeEgg(uid)
			local p = promptNear(egg - Vector3.new(0,3,0), CFG.PromptRadius)
			if p and typeof(fireproximityprompt) == "function" then pcall(function() p.HoldDuration = 0 end); pcall(fireproximityprompt, p) end
		end
		RunService.Heartbeat:Wait()
	end
	r = root(); if r then pcall(function() r.AssemblyLinearVelocity = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0); if h then h:Move(Vector3.zero, false) end end) end
	return state.Carrying and state.Uid == uid
end

local function triggerTPNow(uid)
	if state._tpTriggered then return end
	state._tpTriggered = true
	state._tpActive = true
	task.spawn(function()
		local ok, err = pcall(instantTP, uid)
		state._tpActive = false
		if not ok then warn("[TP] erro: " .. tostring(err)) end

		task.wait(0.4)
		if not atSpawn() and not state.Cancel then
			task.spawn(vooFallback, uid)
		else
			unfreezeCharacter()
		end
	end)
end

local function slideAndGrab(uid, timeout)
	timeout = timeout or CFG.SlideTimeout
	local c = player.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
	local started = os.clock()
	local cache = { At = 0 }
	local tpFired = false

	local promptConns = {}
	local watchedPrompts = {}

	local function watchPrompt(p)
		if not p or watchedPrompts[p] then return end
		watchedPrompts[p] = true
		pcall(function()
			table.insert(promptConns, p.PromptButtonHoldBegan:Connect(function()
				if not tpFired then tpFired = true; triggerTPNow(uid) end
			end))
		end)
		pcall(function()
			table.insert(promptConns, p.Triggered:Connect(function()
				if not tpFired then tpFired = true; triggerTPNow(uid) end
			end))
		end)
	end

	while os.clock() - started < timeout and not state.Cancel do
		if state.Carrying and state.Uid == uid and not tpFired then
			tpFired = true
			triggerTPNow(uid)
			break
		end

		local r = root(); if not r then break end
		local egg = eggNow(uid, cache)
		if not egg then task.wait(0.1); continue end

		local delta = egg - r.Position
		local flat = Vector3.new(delta.X, 0, delta.Z)
		local flatDist = flat.Magnitude

		if flatDist > 1.5 then
			local dir = flat.Unit
			local slideV = dir * CFG.SlideSpeed
			pcall(function()
				r.AssemblyLinearVelocity = Vector3.new(slideV.X, r.AssemblyLinearVelocity.Y, slideV.Z)
				if h then h:Move(dir, false) end
			end)
		else
			pcall(function()
				r.AssemblyLinearVelocity = Vector3.new(0, r.AssemblyLinearVelocity.Y, 0)
				if h then h:Move(Vector3.zero, false) end
			end)
		end

		local p = promptNear(egg - Vector3.new(0,3,0), CFG.PromptRadius)
		if p then
			watchPrompt(p)
			if typeof(fireproximityprompt) == "function" then
				pcall(function() p.HoldDuration = 0 end)
				pcall(fireproximityprompt, p)
			end
		end
		task.spawn(takeEgg, uid)

		RunService.Heartbeat:Wait()
	end

	for _, conn in ipairs(promptConns) do pcall(function() conn:Disconnect() end) end

	if h then pcall(function() h:Move(Vector3.zero, false) end) end
	local r = root(); if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end

	if state.Carrying and state.Uid == uid and not tpFired then
		tpFired = true
		triggerTPNow(uid)
	end

	return state.Carrying and state.Uid == uid
end

local function grabOnly(uid, timeout)
	timeout = timeout or CFG.GrabTimeout
	local cache = { At = 0 }
	local waited = 0
	local since = 1

	while waited < timeout and not state.Cancel do
		if state.Carrying and state.Uid == uid then return true end
		local r = root()
		local egg = eggNow(uid, cache)
		local dt = math.max(RunService.Heartbeat:Wait(), 1/240)
		waited += dt; since += dt
		if r and egg then
			local delta = egg - r.Position
			if delta.Magnitude > CFG.GrabStopDistance + 1 then
				local pace = math.max(walkSpeed() * CFG.SpeedCap, 16)
				local v = delta / math.max(0.08, dt)
				if v.Magnitude > pace then v = v.Unit * pace end
				pcall(function() r.AssemblyLinearVelocity = v + Vector3.new(0, workspace.Gravity * dt * 0.5, 0); r.AssemblyAngularVelocity = Vector3.zero end)
			else
				pcall(function() r.AssemblyLinearVelocity = Vector3.zero end)
			end
			if since >= CFG.GrabInterval then
				since = 0
				local p = promptNear(egg - Vector3.new(0,3,0), CFG.PromptRadius)
				if p and typeof(fireproximityprompt) == "function" then pcall(function() p.HoldDuration = 0 end); pcall(fireproximityprompt, p) end
				task.spawn(takeEgg, uid)
			end
		elseif since >= CFG.GrabInterval then
			since = 0
			task.spawn(takeEgg, uid)
		end
	end
	local r = root(); if r then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
	return state.Carrying and state.Uid == uid
end

local function regrab(uid)
	if state.Carrying and state.Uid == uid then return true end
	local r = root(); local egg = eggPos(uid)
	if r and egg and Vector3.new(r.Position.X-egg.X,0,r.Position.Z-egg.Z).Magnitude > CFG.RegrabFar then place(egg + Vector3.new(0,3,0)) end
	return grabOnly(uid, CFG.GrabTimeout)
end

local function groundY(pos, fallback)
	local y = fallback
	pcall(function()
		local p = RaycastParams.new(); p.FilterType = Enum.RaycastFilterType.Exclude; p.FilterDescendantsInstances = {player.Character}; p.IgnoreWater = true
		local hit = workspace:Raycast(pos + Vector3.new(0,80,0), Vector3.new(0,-160,0), p)
		if hit and hit.Material ~= Enum.Material.Water then y = hit.Position.Y + 3.2 end
	end)
	return y
end
local function carrySpeed(distance)
	local ws = walkSpeed(); local base = ws * math.min(CFG.CarryRatio, CFG.SpeedCap) * state.Mult
	local fast = base * 1.5; local excess = 5.5 * base; local limit = fast
	if distance and distance > excess then limit = math.min(fast, base * distance / (distance - excess)) end
	return math.min(math.max(math.min(base * CFG.EasyRatio, limit), base), math.max(ws * CFG.SpeedCap, base))
end

local function runHome(lineX, laneZ, attemptStart)
	attemptStart = attemptStart or os.clock()
	local home = homePoint(); local checkpoint = lineX - 7
	local c = player.Character; local h = c and c:FindFirstChildOfClass("Humanoid")
	if h then h.PlatformStand = false end
	local r = root()
	local start = root(); local speed = carrySpeed(start and (Vector3.new(start.Position.X-home.X,0,start.Position.Z-home.Z).Magnitude) or nil)
	local last, timeout = os.clock(), 0
	while not state.Cancel and timeout < 25 do
		if atSpawn() then 
			unfreezeCharacter()
			return true 
		end
		if state.Delivered >= attemptStart then return true end
		r = root(); if not r then return false end
		local now = os.clock(); local dt = math.max(now-last, 1/240); last = now; timeout += dt
		local toHome = r.Position.X <= checkpoint + 2
		local target = toHome and home or Vector3.new(checkpoint, home.Y, laneZ)
		local aim = avoid(r.Position, target)
		local flat = Vector3.new(aim.X-r.Position.X, 0, aim.Z-r.Position.Z)
		local v = flat.Magnitude > 0.01 and flat.Unit * math.min(speed, flat.Magnitude/0.05) or Vector3.zero
		pcall(function() r.AssemblyLinearVelocity = Vector3.new(v.X, 0, v.Z) end)
		RunService.Heartbeat:Wait()
	end
	if h then pcall(function() h:Move(Vector3.zero, false) end) end
	local settle = 0
	while settle < 2 and not state.Cancel do if atSpawn() then unfreezeCharacter(); return true end; settle += RunService.Heartbeat:Wait() end
	unfreezeCharacter()
	return atSpawn()
end

instantTP = function(uid)
	local attemptStart = os.clock()
	local lineX, lineY = lineInfo()
	local r = root(); if not r then return false end
	local laneZ = math.clamp(r.Position.Z, -425, -300)
	local landing = Vector3.new(lineX + CFG.LandOffset, lineY + 3.35, laneZ)
	local hopStep = math.max(walkSpeed() * CFG.HopRatio, CFG.HopMin)
	local hopY = groundY(r.Position, r.Position.Y) + CFG.HopLift
	local x = r.Position.X
	local retries = 0
	local releaseCamera = frozenCamera()
	state.ReleaseCamera = releaseCamera
	pcall(postClone)
	fpsOn()

	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local savedMaxHealth = nil
	local healthConns = {}

	local function protegerHumanoid()
		if not humanoid or humanoid.Health <= 0 then return end
		savedMaxHealth = humanoid.MaxHealth
		pcall(function()
			humanoid.MaxHealth = 1000000
			humanoid.Health = 1000000
			humanoid.BreakJointsOnDeath = false
			humanoid.RequiresNeck = false
		end)
		table.insert(healthConns, humanoid.HealthChanged:Connect(function(hp)
			if hp < humanoid.MaxHealth and humanoid.Health > 0 then
				pcall(function() humanoid.Health = humanoid.MaxHealth end)
			end
		end))
	end

	local function restaurarHumanoid()
		for _, c in ipairs(healthConns) do pcall(function() c:Disconnect() end) end
		table.clear(healthConns)
		if humanoid and humanoid.Health > 0 then
			pcall(function()
				if savedMaxHealth and savedMaxHealth > 0 then
					humanoid.MaxHealth = savedMaxHealth
					humanoid.Health = savedMaxHealth
				end
				humanoid.BreakJointsOnDeath = true
				humanoid.RequiresNeck = true
			end)
		end
	end

	protegerHumanoid()

	local function tenhoOvo()
		return state.Carrying and state.Uid == uid
	end

	while x - hopStep > landing.X and not state.Cancel do
		if not tenhoOvo() then
			local ok = false
			for _ = 1, 3 do
				if state.Cancel then break end
				if regrab(uid) then ok = true; break end
				task.wait(0.1)
				local f = eggPos(uid)
				if f then place(f + Vector3.new(0,3,0)) end
			end
			if not ok then break end
			local cur = root(); if cur then x = math.min(x, cur.Position.X) end
			continue
		end
		local nextX = x - hopStep
		local pulledBefore = state.PulledAt
		local held = 0
		local currentHopY = groundY(Vector3.new(nextX, 0, laneZ), hopY)
		while held < CFG.HopGap do
			place(Vector3.new(nextX, currentHopY, laneZ))
			held += RunService.Heartbeat:Wait()
		end
		local check = root()
		local pulled = state.PulledAt > pulledBefore or (check and (check.Position.X - nextX > 10 or check.AssemblyLinearVelocity.Magnitude > 150))
		if pulled and tenhoOvo() and not state.Cancel then
			retries += 1
			CFG.HopGap = math.min(CFG.HopGapMax, CFG.HopGap + 0.03)
			if retries > 30 then break end
			local settle = 0
			while settle < 0.1 and not state.Cancel do
				place(Vector3.new(x, currentHopY, laneZ))
				settle += RunService.Heartbeat:Wait()
			end
		else
			x = nextX
			CFG.HopGap = math.max(CFG.HopGapMin, CFG.HopGap - 0.01)
			retries = 0
		end
	end

	landing = Vector3.new(landing.X, groundY(landing, landing.Y), landing.Z)
	local function land()
		local cur = root()
		if cur and cur.Position.X <= landing.X + 1 and cur.Position.Y > landing.Y - 15 then
			pcall(function() cur.AssemblyLinearVelocity = Vector3.zero end)
			return
		end
		place(landing)
	end
	land()
	for _ = 1, 3 do
		local s = 0; while s < CFG.LandSettle and not state.Cancel do s += RunService.Heartbeat:Wait() end
		local landed = root()
		if tenhoOvo() and landed and (landed.Position.X - landing.X > 12 or landed.Position.Y < landing.Y - 15) then
			land()
		else
			break
		end
	end
	dropClone()

	if tenhoOvo() and not state.Cancel then
		local d = 0; while d < CFG.DropDelay do d += RunService.Heartbeat:Wait() end
		dropEgg()
		local w = 0; while tenhoOvo() and w < 1 and not state.Cancel do w += RunService.Heartbeat:Wait() end
		local cur = root(); if cur then pcall(function() cur.AssemblyLinearVelocity = Vector3.zero; cur.AssemblyAngularVelocity = Vector3.zero end) end
		releaseCamera(); dropClone()
		local grabOk = false
		for _ = 1, 3 do
			if state.Cancel then break end
			if grabOnly(uid, 5) then grabOk = true; break end
			local f = eggPos(uid)
			if f then place(f + Vector3.new(0,3,0)) end
			task.wait(0.1)
		end
		if not grabOk and not regrab(uid) then
			restaurarHumanoid()
			fpsOff()
			unfreezeCharacter()
			return false
		end
		dropClone()
	end
	releaseCamera()

	local ok = false
	if tenhoOvo() then ok = runHome(lineX, laneZ, attemptStart) end

	restaurarHumanoid()
	fpsOff()
	unfreezeCharacter()
	return ok
end

vooFallback = function(uid)
	local sp = spawnPos()
	if not sp then
		unfreezeCharacter()
		return false
	end

	local c = player.Character
	local h = c and c:FindFirstChildOfClass("Humanoid")
	local hrp = root()
	if not hrp or not h then 
		unfreezeCharacter()
		return false 
	end

	local savedMaxHealth = h.MaxHealth
	pcall(function()
		h.MaxHealth = 1000000
		h.Health = 1000000
		h.BreakJointsOnDeath = false
		h.RequiresNeck = false
	end)

	local releaseCamera = frozenCamera()
	state.ReleaseCamera = releaseCamera
	pcall(postClone)
	fpsOn()

	local started = os.clock()
	local timeout = 60

	while os.clock() - started < timeout and not state.Cancel do
		local rr = root()
		if not rr then
			task.wait(0.5)
			continue
		end

		if uid and not (state.Carrying and state.Uid == uid) then
			pcall(regrab, uid)
		end

		local flat = Vector3.new(sp.X - rr.Position.X, 0, sp.Z - rr.Position.Z)
		local dist = flat.Magnitude

		if dist <= CFG.SpawnDetectRadius + 4 then
			break
		end

		local dir = flat.Unit
		local nextPos = rr.Position + dir * 10
		local y = groundY(nextPos, sp.Y + 4)

		for i = 1, 3 do
			place(Vector3.new(nextPos.X, y, nextPos.Z))
			RunService.Heartbeat:Wait()
		end

		task.wait(2)
	end

	local finalY = groundY(sp, sp.Y + 3)
	place(Vector3.new(sp.X, finalY, sp.Z))
	task.wait(0.1)
	place(sp + Vector3.new(0, 3.5, 0))

	if h and h.Health > 0 then
		pcall(function()
			h.MaxHealth = savedMaxHealth
			h.Health = savedMaxHealth
			h.BreakJointsOnDeath = true
			h.RequiresNeck = true
		end)
	end

	unfreezeCharacter()
	return atSpawn()
end

tryStealOnce = function(uid)
	local maxRetries = 15
	local attempt = 0

	while attempt < maxRetries and not state.Cancel do
		attempt = attempt + 1

		local aindaNoPainel = false
		for _, it in ipairs(listaAtualPets) do
			if it.uid == uid then aindaNoPainel = true; break end
		end
		if not aindaNoPainel then
			return true
		end

		if isRagdoll() then
			print("[Nexvory] ragdoll → recuperando e indo no pet")
			local waitR = 0
			while isRagdoll() and waitR < 5 and not state.Cancel do
				task.wait(0.3)
				waitR = waitR + 0.3
			end
			unfreezeCharacter()
			task.wait(0.4)
		end

		if not (state.Carrying and state.Uid == uid) then
			local egg = eggPos(uid)
			if not egg then 
				task.wait(0.5)
				continue
			end

			if state.Carrying and state.Uid ~= uid then
				dropEgg()
				local w = 0
				while state.Carrying and w < 1 do w = w + RunService.Heartbeat:Wait() end
			end

			local rtoe = runToEgg(uid, egg)
			if rtoe == "slide" then
				local slid = slideAndGrab(uid, CFG.SlideTimeout)
				if not slid then
					task.wait(CFG.RetryDelay)
					continue
				end

				local waitTp = 0
				while waitTp < 25 and not state.Cancel do
					if not state._tpActive then break end
					task.wait(0.15)
					waitTp = waitTp + 0.15
				end

				if not atSpawn() and not state.Cancel then
					vooFallback(uid)
				else
					unfreezeCharacter()
				end

				local stillThere = false
				for _, it in ipairs(listaAtualPets) do
					if it.uid == uid then stillThere = true; break end
				end
				if stillThere and not state.Cancel then
					task.wait(0.7)
					continue
				end
				return true
			elseif not rtoe then
				task.wait(CFG.RetryDelay)
				continue
			end
		end

		if state.Carrying and state.Uid == uid then
			return true
		end

		task.wait(CFG.RetryDelay)
	end

	return false
end

stealManual = function(uid)
	if state.Busy then return end
	state.Busy = true
	state.Cancel = false
	state._tpTriggered = false
	state._tpActive = false
	petSendoRoubadoUID = uid
	updateBtns()

	task.spawn(function()
		local ok, err = pcall(tryStealOnce, uid)
		if not ok then warn("[Nexvory] erro: " .. tostring(err)) end

		unfreezeCharacter()
		state.Busy = false
		state._tpTriggered = false
		state._tpActive = false
		petSendoRoubadoUID = nil
		if updateBtns then updateBtns() end
	end)
end

-- UI
local TEMA = {
	fundoMarrom = Color3.fromRGB(30, 80, 45),
	painelMarrom = Color3.fromRGB(40, 110, 60),
	fundoVerdeHeader = Color3.fromRGB(25, 160, 70),
	btnVerde = Color3.fromRGB(40, 190, 80),
	btnAmarelo = Color3.fromRGB(230, 160, 20),
	btnVermelho = Color3.fromRGB(200, 50, 50),
	textoBranco = Color3.fromRGB(255,255,255),
	textoFraco = Color3.fromRGB(200, 240, 210),
	borda = Color3.fromRGB(20, 60, 35),
}

local function getParentGui()
	if typeof(gethui) == "function" then local ok, r = pcall(gethui); if ok and typeof(r) == "Instance" then return r end end
	return player:WaitForChild("PlayerGui")
end

local SG = Instance.new("ScreenGui")
SG.Name = "NexvoryHub"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 999999999
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.Parent = getParentGui()

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 320, 0, 450)
Main.Position = UDim2.new(1, 350, 0.5, -225)
Main.BackgroundColor3 = TEMA.fundoMarrom
Main.BorderSizePixel = 0
Main.Active = true
Main.Visible = false
Main.ZIndex = 10
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)
local MS = Instance.new("UIStroke", Main)
MS.Color = TEMA.borda
MS.Thickness = 2

local TxM = Instance.new("ImageLabel", Main)
TxM.Size = UDim2.new(1,0,1,0)
TxM.BackgroundTransparency = 1
TxM.Image = "rbxassetid://6071575925"
TxM.ScaleType = Enum.ScaleType.Tile
TxM.TileSize = UDim2.new(0,48,0,48)
TxM.ImageTransparency = 0.85
TxM.ZIndex = 11

local Header = Instance.new("Frame", Main)
Header.Size = UDim2.new(1,0,0,50)
Header.BackgroundColor3 = TEMA.fundoVerdeHeader
Header.BorderSizePixel = 0
Header.ZIndex = 12
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0,220,0,25)
Title.Position = UDim2.new(0,16,0,12)
Title.BackgroundTransparency = 1
Title.Text = "Nexvory Hub"
Title.TextColor3 = TEMA.textoBranco
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.ZIndex = 15

local BtnClose = Instance.new("TextButton", Main)
BtnClose.Size = UDim2.new(0,32,0,45)
BtnClose.Position = UDim2.new(0,-32,0.5,-22)
BtnClose.BackgroundColor3 = TEMA.fundoVerdeHeader
BtnClose.Text = "›"
BtnClose.TextColor3 = TEMA.textoBranco
BtnClose.Font = Enum.Font.GothamBlack
BtnClose.TextSize = 24
BtnClose.ZIndex = 16
Instance.new("UICorner", BtnClose).CornerRadius = UDim.new(0, 6)

local BtnOrder = Instance.new("TextButton", Main)
BtnOrder.Size = UDim2.new(1,-20,0,32)
BtnOrder.Position = UDim2.new(0,10,0,56)
BtnOrder.BackgroundColor3 = TEMA.painelMarrom
BtnOrder.Text = "★ Filtro: Melhores Pets"
BtnOrder.TextColor3 = TEMA.textoBranco
BtnOrder.Font = Enum.Font.GothamBold
BtnOrder.TextSize = 12
BtnOrder.ZIndex = 15
Instance.new("UICorner", BtnOrder).CornerRadius = UDim.new(0, 6)
BtnOrder.MouseButton1Click:Connect(function()
	ordemMelhores = not ordemMelhores
	BtnOrder.Text = ordemMelhores and "★ Filtro: Melhores Pets" or "▼ Filtro: Piores Pets"
end)

local BtnAuto = Instance.new("TextButton", Main)
BtnAuto.Size = UDim2.new(1,-20,0,28)
BtnAuto.Position = UDim2.new(0,10,0,90)
BtnAuto.BackgroundColor3 = TEMA.btnVermelho
BtnAuto.Text = "⚡ AUTO STEAL: OFF"
BtnAuto.TextColor3 = TEMA.textoBranco
BtnAuto.Font = Enum.Font.GothamBlack
BtnAuto.TextSize = 11
BtnAuto.ZIndex = 15
Instance.new("UICorner", BtnAuto).CornerRadius = UDim.new(0, 6)

local Scroll = Instance.new("ScrollingFrame", Main)
Scroll.Size = UDim2.new(1,-20,1,-130)
Scroll.Position = UDim2.new(0,10,0,124)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.ScrollBarThickness = 4
Scroll.ZIndex = 12
local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0,6)
UIList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	Scroll.CanvasSize = UDim2.new(0,0,0, UIList.AbsoluteContentSize.Y + 10)
end)

local BtnFloat = Instance.new("ImageButton", SG)
BtnFloat.Size = UDim2.new(0,65,0,65)
BtnFloat.Position = UDim2.new(0,1224,0.5,-165)
BtnFloat.BackgroundColor3 = Color3.fromRGB(40, 180, 75)
BtnFloat.AutoButtonColor = false
BtnFloat.ZIndex = 100
Instance.new("UICorner", BtnFloat).CornerRadius = UDim.new(0, 10)
local FS = Instance.new("UIStroke", BtnFloat)
FS.Color = Color3.fromRGB(255,255,255)
FS.Thickness = 2

local BtnRaios = Instance.new("ImageLabel", BtnFloat)
BtnRaios.Size = UDim2.new(1,0,1,0)
BtnRaios.BackgroundTransparency = 1
BtnRaios.Image = "rbxassetid://10871183144"
BtnRaios.ScaleType = Enum.ScaleType.Stretch
BtnRaios.ImageTransparency = 0.35
BtnRaios.ZIndex = 101

local BtnPetImg = Instance.new("ImageLabel", BtnFloat)
BtnPetImg.Size = UDim2.new(1,-10,1,-10)
BtnPetImg.Position = UDim2.new(0,5,0,5)
BtnPetImg.BackgroundTransparency = 1
BtnPetImg.ScaleType = Enum.ScaleType.Fit
BtnPetImg.Visible = false
BtnPetImg.ZIndex = 102

local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local function abrir()
	BtnFloat.Visible = false
	Main.Visible = true
	Main.Position = UDim2.new(1,350,0.5,-225)
	TweenService:Create(Main, tweenInfo, {Position = UDim2.new(1,-335,0.5,-225)}):Play()
end
local function fechar()
	TweenService:Create(Main, tweenInfo, {Position = UDim2.new(1,350,0.5,-225)}):Play()
	task.spawn(function() task.wait(0.35); Main.Visible = false; BtnFloat.Visible = true end)
end
BtnFloat.MouseButton1Click:Connect(abrir)
BtnClose.MouseButton1Click:Connect(fechar)

local cardsAtivos = {}

updateBtns = function()
	for uid, card in pairs(cardsAtivos) do
		if petSendoRoubadoUID == uid then
			card.btn.Text = "PARAR"
			card.btn.BackgroundColor3 = TEMA.btnAmarelo
		else
			card.btn.Text = "STEAL"
			card.btn.BackgroundColor3 = TEMA.btnVerde
		end
	end
end

-- AUTO STEAL
startAutoSteal = function()
	if autoStealAtivo then return end

	autoStealAtivo = true
	BtnAuto.Text = "⚡ AUTO STEAL: ON"
	BtnAuto.BackgroundColor3 = TEMA.btnVerde
	print("[Nexvory] Auto Steal LIGADO")

	task.spawn(function()
		while autoStealAtivo do
			if not state.Busy then
				if #listaAtualPets == 0 then
					task.wait(0.8)
				else
					table.sort(listaAtualPets, function(a, b)
						if ordemMelhores then return a.score > b.score else return a.score < b.score end
					end)

					local targetUid = listaAtualPets[1].uid
					autoStealFocusUid = targetUid

					state.Busy = true
					state.Cancel = false
					state._tpTriggered = false
					petSendoRoubadoUID = targetUid
					updateBtns()

					pcall(tryStealOnce, targetUid)

					petSendoRoubadoUID = nil
					state.Busy = false
					updateBtns()
					task.wait(0.5)
				end
			else
				task.wait(0.25)
			end
		end
	end)
end

stopAutoSteal = function()
	autoStealAtivo = false
	autoStealFocusUid = nil
	state.Cancel = true
	BtnAuto.Text = "⚡ AUTO STEAL: OFF"
	BtnAuto.BackgroundColor3 = TEMA.btnVermelho
	print("[Nexvory] Auto Steal DESLIGADO")
end

BtnAuto.MouseButton1Click:Connect(function()
	if autoStealAtivo then
		stopAutoSteal()
	else
		startAutoSteal()
	end
end)

local function makeCard(uid, data)
	local card = cardsAtivos[uid]
	if not card then
		local Frame = Instance.new("Frame", Scroll)
		Frame.Name = "Card_"..uid
		Frame.Size = UDim2.new(1,0,0,64)
		Frame.BackgroundColor3 = TEMA.painelMarrom
		Frame.BorderSizePixel = 0
		Frame.ZIndex = 13
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

		local tex = Instance.new("ImageLabel", Frame)
		tex.Size = UDim2.new(1,0,1,0)
		tex.BackgroundTransparency = 1
		tex.Image = "rbxassetid://6071575925"
		tex.ScaleType = Enum.ScaleType.Tile
		tex.TileSize = UDim2.new(0,48,0,48)
		tex.ImageTransparency = 0.82
		tex.ZIndex = 14

		local icon = GetPetIcon(data.rawRecord)
		local pImg = Instance.new("ImageLabel", Frame)
		pImg.Size = UDim2.new(0,52,0,52)
		pImg.Position = UDim2.new(0,6,0.5,-26)
		pImg.BackgroundTransparency = 1
		pImg.ScaleType = Enum.ScaleType.Fit
		pImg.ZIndex = 15
		if icon then pImg.Image = icon; pImg.Visible = true else pImg.Visible = false end

		local nameL = Instance.new("TextLabel", Frame)
		nameL.Size = UDim2.new(1,-165,0,22)
		nameL.Position = UDim2.new(0, icon and 64 or 12, 0, 10)
		nameL.BackgroundTransparency = 1
		nameL.Text = data.nome
		nameL.TextColor3 = TEMA.textoBranco
		nameL.Font = Enum.Font.GothamBold
		nameL.TextSize = 13
		nameL.TextXAlignment = Enum.TextXAlignment.Left
		nameL.TextTruncate = Enum.TextTruncate.AtEnd
		nameL.ZIndex = 15

		local subL = Instance.new("TextLabel", Frame)
		subL.Size = UDim2.new(1,-165,0,18)
		subL.Position = UDim2.new(0, icon and 64 or 12, 0, 32)
		subL.BackgroundTransparency = 1
		subL.Text = "["..data.rarity.."]"
		subL.TextColor3 = TEMA.textoFraco
		subL.Font = Enum.Font.Gotham
		subL.TextSize = 11
		subL.TextXAlignment = Enum.TextXAlignment.Left
		subL.ZIndex = 15

		local distL = Instance.new("TextLabel", Frame)
		distL.Size = UDim2.new(0,45,0,20)
		distL.Position = UDim2.new(1,-125,0.5,-10)
		distL.BackgroundTransparency = 1
		distL.Text = data.dist.."m"
		distL.TextColor3 = TEMA.textoBranco
		distL.Font = Enum.Font.GothamBold
		distL.TextSize = 10
		distL.TextXAlignment = Enum.TextXAlignment.Right
		distL.ZIndex = 15

		local btn = Instance.new("TextButton", Frame)
		btn.Size = UDim2.new(0,72,0,36)
		btn.Position = UDim2.new(1,-78,0.5,-18)
		btn.BackgroundColor3 = TEMA.btnVerde
		btn.Text = "STEAL"
		btn.TextColor3 = TEMA.textoBranco
		btn.Font = Enum.Font.GothamBlack
		btn.TextSize = 12
		btn.ZIndex = 15
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

		btn.MouseButton1Click:Connect(function()
			if petSendoRoubadoUID == uid then
				petSendoRoubadoUID = nil
				state.Cancel = true
			else
				if state.Busy then return end
				petSendoRoubadoUID = uid
				stealManual(uid)
			end
			updateBtns()
		end)

		card = { frame = Frame, distL = distL, btn = btn, score = data.score, cframe = data.cframe }
		cardsAtivos[uid] = card
	else
		card.distL.Text = data.dist.."m"
		card.score = data.score
		card.cframe = data.cframe
	end
	return card.frame
end

-- LOOP PRINCIPAL + DETECÇÃO DE NOITE E RESPAWN
task.spawn(function()
	while true do
		pcall(function()
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local myPos = hrp and hrp.Position or Vector3.zero
			local lista, uidsAtuais = {}, {}

			for _, rec in ipairs(snapshot()) do
				local ep = rec.BottomCFrame.Position
				local dist = math.floor((ep - myPos).Magnitude)
				local rarity, score = GetRarity(rec)
				local nome = GetPetName(rec)
				local uid = rec.Uid
				uidsAtuais[uid] = true
				table.insert(lista, { uid=uid, nome=nome, rarity=rarity, score=score, dist=dist, cframe=rec.BottomCFrame, rawRecord=rec })
			end

			table.sort(lista, function(a,b)
				if ordemMelhores then return a.score > b.score else return a.score < b.score end
			end)
			listaAtualPets = lista

			-- DETECTA RESPAWN DOS PETS → LIGA AUTO STEAL
			local currentCount = #lista
			if currentCount > lastPetCount and lastPetCount == 0 and currentCount > 0 then
				print("[Nexvory] Pets respawnaram → ligando Auto Steal")
				if not autoStealAtivo then
					startAutoSteal()
				end
			end
			lastPetCount = currentCount

			if #lista > 0 then
				local melhor = ordemMelhores and lista[1] or lista[#lista]
				local icon = GetPetIcon(melhor.rawRecord)
				if icon then BtnPetImg.Image = icon; BtnPetImg.Visible = true else BtnPetImg.Visible = false end
			else
				BtnPetImg.Visible = false
			end

			for i, d in ipairs(lista) do
				local f = makeCard(d.uid, d)
				if f then f.LayoutOrder = i end
			end

			updateBtns()

			for uid, c in pairs(cardsAtivos) do
				if not uidsAtuais[uid] then
					if petSendoRoubadoUID == uid and not autoStealAtivo then
						petSendoRoubadoUID = nil
					end
					pcall(function() c.frame:Destroy() end)
					cardsAtivos[uid] = nil
				end
			end
		end)
		task.wait(1)
	end
end)

-- DETECTA 1 SEGUNDO ANTES DA NOITE → DESLIGA AUTO STEAL
task.spawn(function()
	while true do
		pcall(function()
			local clock = Lighting.ClockTime
			-- Noite geralmente começa perto de 18:00 (ClockTime 18)
			-- Detecta quando está prestes a anoitecer (ClockTime entre 17.95 e 18.05)
			local isNearNight = (clock >= 17.95 and clock <= 18.1) or (clock >= 5.95 and clock <= 6.1)

			if isNearNight and not wasNight then
				wasNight = true
				if autoStealAtivo then
					print("[Nexvory] Quase noite → desligando Auto Steal")
					stopAutoSteal()
				end
			elseif not isNearNight then
				wasNight = false
			end
		end)
		task.wait(0.5)
	end
end)

task.spawn(function() pcall(shieldStart) end)

print("[Nexvory Hub] PRONTO - sem freeze + auto noite/respawn")